Return-Path: <kvm+bounces-66216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C7863CCA7E8
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 07:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D15C530198FA
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 06:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3812632E6B8;
	Thu, 18 Dec 2025 06:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lTHdC+u5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YO2KkPBu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D82329C4D
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 06:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766039815; cv=fail; b=e0QqqMj4298RuP3yTh2S82COzRaXrX32rHJoueW/WNhOU0kLePkpc2BiaJM92GUN3KfEeIIJfXg5t2iXd02a/61tk7bGSylC5Aw9BsZCSKAcq6MymvX40js9fKO6gUYYJZ5rpUlLDB3Z0Dk1DapYYzZdQmFlNwivQ+eiWab4hls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766039815; c=relaxed/simple;
	bh=LzCvb97iRdkZBMuGzB/juzsIoI3mwibp9ln+lCVaVQg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c/JDgEzbnlDkG4Nz24LVUw2/lPkNrff3E6upvrkT/Jox/JGlprEkScDKGUbXJq4SbUXxfM+sXp/wbf/qZoeFubnZqaLmfkKUHrRqLRxvIOLbQhTn5PEcPKSlLhYz+3BXSLBqQXraHHs8hI96vIj/+PD0v9RkAM9biQiu2FWVKBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lTHdC+u5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YO2KkPBu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BI1h8fI306015;
	Thu, 18 Dec 2025 06:36:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mpeGa8YQ/SBOvn1WT8inBiS0DSgo0pyR7r9jVro8PEQ=; b=
	lTHdC+u5nIbZd50xANpY9qgigwECmLlZDT6CdwMg/PkVLMD1057vWQHiGVWqhSoS
	FpwAficZX4Kpktyy0bvjPGI5WrGL3xnOpna44yzP0tkjS/HNoOeuO4/Day52NpFa
	0her1QpqKXhGNtIK0mJ2fws95koM7nRBfx1VsVKQ4YZuv4sf02iylhV3bhe8ap62
	sUK5TE7xDP3b0pBak6aBA4XrP6r9mY/bVq9JRZRruxBEhc7lAVdH943a6uuup7Iz
	xax8lS37rgkqK4KeY/lv5HurzS3jtZLHrHGGXYE/CvAS9/DoDZlcaSW/r7QzBNwK
	2EJECpGznZezvZdkRMCzKQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b47vwr79n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 06:36:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BI3SLuA025242;
	Thu, 18 Dec 2025 06:36:07 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012063.outbound.protection.outlook.com [52.101.53.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkcrb3s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 06:36:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b2B4epTsrrfqjZ9c3GfzYT1LDjVN1H9KqztiLke3FpGZku5HeNna/WIpBJYbAM7hvVfDCbfTYSBmyYcKhbjc2fpTprhkODVyLGi9wfSTgy8icdYifFED9Rl30rLz/RCQ24q+HQXqrEPywvp36vPY9QGY6nkWhKJzo8vS3rOT5HzTIPVG8WpSHCG5Zn6oXpXXYZnin0dL8nNOuQn+fwakBU1m+/5nyhmRbqln+fDryp+KvV3x5n0IlCBVLfc22Z4fkbTjdAFkRr13rYIjMPma56vJY/4ZmrWKqZoVUI0oABw8nbW064OcS2Xri9NDTcI+nPIEzqmnQeLPzr+e+j9l3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpeGa8YQ/SBOvn1WT8inBiS0DSgo0pyR7r9jVro8PEQ=;
 b=Al3HRzhv2VeQk7wJrWjJY5tb1+Yn3lKVQdWSlvSGjNe49AiI1rZQ9pQ0OV5UPofh8HQoi0aW3if088gxZL+b1ONVkq4a/fcD5BSael2ll/LnIPZIv/vrEwDqBYJa5O/wKB+I5W4lcA9zDIDj6VCftnh2p6BRav5KDK6slxQGPvAO6yvY8SVz/WaKuEP6cc131iel9vXtRms4x06owbp0Ej7CMScuURvPQADGrrzfTzJ/OIPXUbct+8Rgr1PXjv/DHKJom6Gjynl3Mj8NwM/7Z26+qxknfSjoKLj5/nVK7/YcbnJAMhy+xNMVKdDwLYqmqCFePuj+R2CcrAV6B2qmSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpeGa8YQ/SBOvn1WT8inBiS0DSgo0pyR7r9jVro8PEQ=;
 b=YO2KkPBuFc6POgnu4LNu/lkDr9ad/uukSJbE5sD20cfSlCBPMiXOc8H46k3+l9c3Sdrr5huhF5vwP3lbWwWwkFhgviUP0MW8W1QUuP3eOEAs55KmTiglxfno8gOQpHbRrHFj39FsmDEoBmKNfXg07LIrD2rahJmioZUq2zYTkQE=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 IA4PR10MB8688.namprd10.prod.outlook.com (2603:10b6:208:55c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Thu, 18 Dec
 2025 06:36:04 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 06:36:04 +0000
Message-ID: <2bd82e11-15d0-47df-85a5-2f5fa045223a@oracle.com>
Date: Wed, 17 Dec 2025 22:36:01 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/9] target/i386/kvm/pmu: PMU Enhancement, Bugfix and
 Cleanup
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
        likexu@tencent.com, like.xu.linux@gmail.com, groug@kaod.org,
        khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
References: <20251111061532.36702-1-dongli.zhang@oracle.com>
 <aUEXkDDOba+oZ4v+@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <aUEXkDDOba+oZ4v+@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH1PEPF00013311.namprd07.prod.outlook.com
 (2603:10b6:518:1::c) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|IA4PR10MB8688:EE_
X-MS-Office365-Filtering-Correlation-Id: c5c3820b-9233-4031-89e3-08de3dffb794
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0dCM01IcDVVU3d4SWE4dGJkWlZyb21kUElCNjhienRQb1lpK3JKY2Y3MXhk?=
 =?utf-8?B?UGloc3g1MEhoY050ZHlJN29kbzgvb3JCRDYzeGs4b2sxeVNGYXY4QmhSdEpw?=
 =?utf-8?B?blNiQUtTdW9TM1cvQjNhYWZzOERjcHBzNDlqdVo1S2RzNkIwdHRCcmpIbXNQ?=
 =?utf-8?B?MjU1ZzIrelRNRnZOZmRJaStrdWJkd253OTFidzhxRTFZeWVhd1JGV0RWRDR0?=
 =?utf-8?B?MUViUUswTTluQWo5aHM4dlR1cHA4a1RGWGZtWkltWVNXc0VQbHdiUkZOcDNR?=
 =?utf-8?B?OU5iT25XdFlOMFVvSFFmNENESFpVLzM5REhPRm81QXhHUlBkL0lqY2t2Uklz?=
 =?utf-8?B?Yy84enNudmx1Q3ZaOGxkUU5hMnFGa2NiSEhzZWZwV1FGaXVOOWdsMkRxK3hv?=
 =?utf-8?B?VDlxV2JINkFublA4K1luTU80OExjSlNzZWhWc3BDVXhEMlVlUS91YmlVR3VZ?=
 =?utf-8?B?VUZiRzJRemlQeW9GZWRZYkduUGpMMlNGSnc5KzhxRVJoeXJLeWFIajZNczIy?=
 =?utf-8?B?bUhzVytpK0kvTXc3ZUJSMnlrSUowM05GNkNsbnBGa0lrM1A4MzlLZ3l0VVlp?=
 =?utf-8?B?UWdVcVlNM1hjOVhkZ3JrcEdhc3FHQUNSOHk3WjU0N3YzT1J5d3pWbE4xZTNa?=
 =?utf-8?B?cHhSNzdTWHFlRW9IYXJHcDdCWkppY0ZoZklSVTNuWHBtUkxWazNtRjN0eGIy?=
 =?utf-8?B?bEpjRDRaYktYcDZGandOMzdhZjBjTzVacWg0QnVPbU9JUXhXUnI4SXJBWmhj?=
 =?utf-8?B?cDRPMXFxQ0NHRmR1V2c2c3JXTm9yaGY1eVB4TFNXMmpzTFpYMzA1T1phalQ4?=
 =?utf-8?B?WHM5SkhkN3lqZ282M1NmUitXSmxzRDVxYkJOYUV3R1hqUVVnTSt5bGJrR0xn?=
 =?utf-8?B?Y3BxNWV2RFFGOUVMM0k1TjdPZDFSNDhxNlJHYnU2SU5zbFRiU3J2ZnFxeEJW?=
 =?utf-8?B?bWdhRjFYSkh2U2R3aWg2S2RHanpKYThiWnJpQUVVUVpKNFNHU2J2dkhUOTZB?=
 =?utf-8?B?Nit2d3hwdTZmY0tpbHVvaU84QldTSjY1UktreTlZZHlQU1VSeFZqTmJkT25P?=
 =?utf-8?B?VDAwYzg4KzhDRU80YStPRXhxdnZiRDRGMkpnZXRNNGh2VTEzbjRxbVpPbEhR?=
 =?utf-8?B?UXJ0TmdyblNsMmd1T2VveEdvdzIwbzJBUi9QZitBZmhrRHZxYUoyUzVMMG9N?=
 =?utf-8?B?UTFZRk8ydkxYYURpc0M0QlhvWFViQ2RlU09jOHovWnBpcEtkemNjdzhNUnpN?=
 =?utf-8?B?VE5nRGNnNklZVHg2Q1lmbEx4czlSYzNSTnlkQVR2VTRQNWRIZmFmR3BCcmpY?=
 =?utf-8?B?ZVJoME9KUFh0UjhLeFNraERDbFdRcXpPaVViTk9wQy9jd1Zua3hZRkFpRlJY?=
 =?utf-8?B?STVXRnU5NWdESHZVcndvdmx6dSs0OXppRHVWYUFOWUdtdVJxVm1MZWs1MVV2?=
 =?utf-8?B?MVpNTXVKK3ROQ3J5amdESjN2UmdaK3BZdlVZQjZrSUw2WS9nRi9WMTJwR1pa?=
 =?utf-8?B?T0tPZGlyck0vcmtiTWNBRW1QRkp6MkQyQ1V3S2ZjSk04SnJCankxTjgzUHZq?=
 =?utf-8?B?c054SUpHM005RmJUT3FYb25pTFVrdTk5bWl3QllNTGQ2emovSzg1ZGNDZUVH?=
 =?utf-8?B?NThIVkZObFFGRG94all4ZFVKSmp4Z20vSHh0M3l4aVRBMndqc0ZvV0hwL2JX?=
 =?utf-8?B?OWc2Q0NIUkJXc3VFaDlUeDdTcllrQkNmc0VNdVk1MndjTHdDQTFLWUdmdEY1?=
 =?utf-8?B?V2ZaajV2TVlmRFY5eE1zYVhrdE9ZWWR1cDhnR0MxV2hpemxQbldqcUhPTXZV?=
 =?utf-8?B?MTdWem9XYlJtcFc4YnhtcXJjTlAxUUpueU1xbDVZemczRmpGTld6VGttMXZL?=
 =?utf-8?B?TFF5L010SUVqTWp4TmQzZEQwMGpuZnpNOGJXTk9abHZCVnVDbjhqM0VWZGha?=
 =?utf-8?Q?kUd7iJVPTC38ThqphO72YUJeVkFPp8II?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LytPZFh0WnBMSEtRZ1AwcWxhaDBjN1UwR21nU01IL2UvTUlwMG1yVWlGbmxI?=
 =?utf-8?B?UWJnWmgzMFpvQVo1QWVKZEIxMDRLMEY1R29HbG90TGx5NU1wSkhQREdETnJ3?=
 =?utf-8?B?Q21QRDhnVDdZSzFMZ0ZyRnZjTWhPU092ZEdZYmVncTZxYlRaWXBqQXljMllU?=
 =?utf-8?B?WlhES3V0NVR1SEdmT1FFMitPVlVnNDVpZVNiUk9KNHo4WklpMFg5OTVQelk5?=
 =?utf-8?B?RXBkYUFQdGlRd2lSQllzSHZiTURodUhoL2Zla2hMQXE0VUJFSzgzSy9BcG1H?=
 =?utf-8?B?SUFMalRqWWdxdTJZQXJkek4vVVZxZnEweWJjN21PQ1hON0w0aTJLb1BLNkx0?=
 =?utf-8?B?R2twYmxnWVlvY2tENTR1T25jYncxWGRYTDJvUmZWRTBtL1FEbEFOMGFuSW1Y?=
 =?utf-8?B?UkhYREg0YUJkNmg1TTViNHRINHBQNTcwNDFjYzlPWW82UGF1LzJmeDBJdGFT?=
 =?utf-8?B?aFRWbzcyNjQrOVk2bFVuRlF6TzRoaGpGQnVCRHhBQnVvVkVoVTE1cFdva2NP?=
 =?utf-8?B?elFMNXZncnI3OXlwcUd6SmxDUHJ1Nm9EU1J6aEpPVWhIZW9qU3lvMldVNlFx?=
 =?utf-8?B?Q1lURUlHQVZTdlpOSlhocU1Vb2NHUk1rWS8yU1NvSDIzTDJwOGpXTDlYaDJz?=
 =?utf-8?B?SE5EZU5VaFRSYkduU25mV1NBVk15MVZlSVdSbjB5MkthS28vM3FSbklva0FL?=
 =?utf-8?B?UU1qR3pnQjZrajMzdS9jcjQ1NFNXejRPNVA1amhydEowQjBjRHA2VVNHQk9Y?=
 =?utf-8?B?L1BSaTZZQlc2bU1wUHAvMXM1MGZhUGUreVlseHJpSE0vOCtUSWRaUWJTcnds?=
 =?utf-8?B?TzBld000ZjRYRGgzQTc1RW53TTBoRkJiRkpzMlNiK3VnanE4cXlMNHdiUnpE?=
 =?utf-8?B?VXlQTlQ0dGZqcGsvbmxsTUNMYnZWSW9JTFFwbnpKOWtHRHZCZndUazlJVWtW?=
 =?utf-8?B?NXp1SEQyOUNCYUY2T3FaRkxCYjRlZllsdTZGVWlNQzBMcTU0VDFLcVhPVFdj?=
 =?utf-8?B?ZDBMandWeTJvN29qYWtBSVlUaHRubUhrb0ZXajk3TVNzT3J0aWJjQ1RrR1JK?=
 =?utf-8?B?dVBBZVlHUEFCSWdYWjJmc3VYVlNDTkI2ZXYweHM2Y0JjRTVTOUppVTZTaTdQ?=
 =?utf-8?B?bldsamFBWmloZXhFNUhXd1h3SitvUHVZQ2Z5SngwMDB4cjBJaVR2WGFwcGZL?=
 =?utf-8?B?SkdDR3JkVjQrb21peVlJUy9mQWFiRHR3UUpqMFZ6MElIOFZqdkZjVmR3VlU3?=
 =?utf-8?B?QlZ3ZFhHOHA2c1dYc1REZXZjUU9iMExmWkVYcjkvTWNjN3RlaEFpcWRTb0pz?=
 =?utf-8?B?QWtvVmowWktyYzlaaU5YQUhCdkt0QUFlTURUbHlHYVVmQnFhbVFDdkJKaTM5?=
 =?utf-8?B?eEFPWnI4bkFtWXEvMThzcGxuOVlNOTQ5LytrRFZPQ1VtWE8wTmNHSDNCT3h2?=
 =?utf-8?B?TGsvYVpBZEpzSWM5Wmt5QVFrRHROTUtkalBHOU9HNlJ4N1A4aE9HKzNqc3ZQ?=
 =?utf-8?B?K2grS2RPUC9nWVlQZ2pON0I3cEdTVDNCSnBFRlYzdy96anNoY1VlZGNLdUow?=
 =?utf-8?B?dUQ4bnAxVDYyaXRUZURVRE1nZnBlRjZnNXhPMHkyc0VWQ2RrQWFQTU5TZDNW?=
 =?utf-8?B?WVJNck5lZXkvaElKUkVFREJESlh3Q1F2ckRBdlFPOGhSZkY2WmRPT3ZKS3oy?=
 =?utf-8?B?eHhqSW1vQUdicGw0dEQyam5SRnVvYzJWMjMwUkE2L2dMNjhyV1MwQndza0JC?=
 =?utf-8?B?MFkydXBSaEpvODlYZUpUck9YTTlRZW92elIrYTliUklQYzFxZS9QWW83UHor?=
 =?utf-8?B?TFo4TEdSaFJqeUVkNFJmOFE0YWRRUXB3enoxSVdTTjFOa2xML2JSRWt1Qmxr?=
 =?utf-8?B?ZnpodE9PTkdyS2pYZHFIRVhlcDVPb0ROb2EvS0FLUUtpM2RPMjkrKysrREZD?=
 =?utf-8?B?TzJNS1prRTNQdkM1UUVQRTVWZ2F6RWdoZWI3ZGlpSlRBc3VmTnRrNVVjU3pV?=
 =?utf-8?B?S1kzYzZUTHI0OEhSUTVGclMwYmtxbTJ2dnZYZlRaUEFlblRKOTBYVjc1Tnds?=
 =?utf-8?B?aDRhZHlvUUlCdDYxYjZxQlNhbWNCMnJ5TG1XRGlHKzJGcnEvcTFqRW8vZ2pU?=
 =?utf-8?B?NkRZaEo3VUU1a0dJTldMSmZ3Ty80eEZTYlFSV0tFYWdBdG8rRVl3QTBrSjFQ?=
 =?utf-8?B?NUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	95lmGYSZMeaqpCCs+pMhLfd0qa2f9xzTA/xtvShs1lCbGKskvOnMQj9h6BJ03VROF1mfUVc/Fvf1vvWV8BHOipH7hXwpF/KJOR0qUI3PpyxTJPrOVnY5qNFuk3Zdhsob6f/q6ei1a+S4lrAgMXec93C8nLQhgygRBOwwhSBzsD1Iuz4JFklFalnXVk1lrxQVTLZHw9opwUvB/4sUiWN7lAzWQkuFMsi8ojnv3I2uQC5Hu9Na5MW1UnZAuIPYtezuzu0Fw+a2j+Uk7xftg1xGuBTQKMazr4fP9Jrbm5r+u5P1/FV6w7analFV1+91eC4GHPy0fEjfyg2Kdus37vwU0JuvzmxAX7jbxWoG7D+LaYKfsK1pGlSWh/KA4Vz+jH3P7f0ESqJZmhGEKpDgVBcLZjqAGU+peSmoiwXeuhPJEzmEZFBtfdhefkEs94+1V5QY18MD/lyyCqKFSBFrEeQ0TUjbsHEOpp9D1pnnemxDMs5tttoSsfmzD4Z7J+mwkFriaesaAvkGsgaptoK0ToGLlU53vMVNTgHT1+J3YnEEOeP3eUiTa+C+SmktnL+TdbeYQrM+NOmr1fPw3rSlz314VtCzyAsQGei63fcdiVuXv74=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5c3820b-9233-4031-89e3-08de3dffb794
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 06:36:04.0859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKo1WqtnbkDpuu++RNKvqwka8f2OqHBtYV5Bt7wKrJQ0BJQ8N+BFGJPhzeIzD8Bs278bL8SgCxkgV8/tRKmVBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8688
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_01,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512180052
X-Proofpoint-GUID: KWr_8V9PjXhu9A9D8WuZJcXSDAD9VQYG
X-Proofpoint-ORIG-GUID: KWr_8V9PjXhu9A9D8WuZJcXSDAD9VQYG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE4MDA1MiBTYWx0ZWRfXzfp7HGItwkA4
 FcjL7zzbkqf0ZK+0bWByZzdf8gA1yBpS8yq2gKXNWcO8ZrI/pxQ65CJyeixr6dGCauMRlosSEkx
 k1N99NJ/dCd4CEdgvVb+mAv2MD1RffeBsHO58xJJiPtXcD3Zh6rME9Kj4zZtMM1sPg1cETAIr4z
 iESuZleacvvzjXWnvbct+uhUJ9fykgjXEhWLKS1l3ym/1WCOsEn/uKQJc3RzeRE5QxR1gBWyLGN
 /HFpLTsZCaI6q7eVQzd/wKVe9Dtn7X/t+V2Vz6AkdDCR2APZO0+cutnwLckd5g2yTQBbx6d8Jtx
 hBj8NUUm4mhhbxW90Fe1J7p/b/qK9In868p3bBF0EyT23xyNDNdDBVpPZkqsTjIrQrKmodIjLtp
 F/Jy+tJTtLQtxog4xNKBE/juxM9JCQ==
X-Authority-Analysis: v=2.4 cv=PpGergM3 c=1 sm=1 tr=0 ts=6943a0d8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=cTSCwLhszCzkOhAk-70A:9 a=QEXdDO2ut3YA:10



On 12/16/25 12:25 AM, Zhao Liu wrote:
> On Mon, Nov 10, 2025 at 10:14:49PM -0800, Dongli Zhang wrote:
>> Date: Mon, 10 Nov 2025 22:14:49 -0800
>> From: Dongli Zhang <dongli.zhang@oracle.com>
>> Subject: [PATCH v7 0/9] target/i386/kvm/pmu: PMU Enhancement, Bugfix and
>>  Cleanup
>> X-Mailer: git-send-email 2.43.5
>>

[snip]

>  
> Hi Dongli,
> 
> Except for Patch 1 & 2 which need compatibility options (if you think
> it's okay, I could help take these 2 and fix them when v11.0's compat
> array is ready).
> 
> The other patches still LGTM. Maybe it's better to have a v8 excluding
> patch 1 & 2?
> 

Hi Zhao,

Sure. I will rebase on top of the staging branch, excluding patch 1 & 2.

Feel free to take 1 & 2.

Thank you very much!

Dongli Zhang


