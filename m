Return-Path: <kvm+bounces-31203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D85DB9C12B3
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 00:45:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 932E1283627
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 23:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB5F11E6DC1;
	Thu,  7 Nov 2024 23:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GjYStS/F";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PNqPskB6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02A51D86ED
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 23:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731023133; cv=fail; b=Y1pv9yWibloVsDABrk/+iSTa7fxsLb/VeMuO4wnFiv5yPwMg7uARH+jMEz8IZy9p9j/ovB2USzw+tHKYKgJl4NYnlfcuJP0+SPeGYaz0Lt+aTo9MYG/7UlNpdpnW3PMWxwD7bApEE59fKbp7EiO/pEkQ4zp742ZdXPLMjhmDjhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731023133; c=relaxed/simple;
	bh=EWV/FBMaXL+7zW4qva2gKVlPcJ2ME6bkXR96WnXoFdU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O09D44JG4L0o6CiWk8pIGnRq5KtDRABYwq2oVykiUywEnvhez3YC4xPur8E7s2VQgnWE9UsP9wsmn4bNMV9go+gVsmtsbXY71TM20IW/vP4SweeJywmsZ+vN+2Wh19OcblQeEVvxPfC99NmXbsi9nSPv7rlMir93J8JJFZVXVz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GjYStS/F; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PNqPskB6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7MtWOL009306;
	Thu, 7 Nov 2024 23:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=In5YDfwn+ensvNmrelFgcRPyJmH4FZfoWXO2lXge2OA=; b=
	GjYStS/FXd8TCtkFazZv6Z3GFU2x3gF4Z2Fl529TtPqduW0gV49c7EmB7+WwXTD1
	qQM+3bXovX6nv/1M9IqUHR1yhoOM8rxakFzRH/E3OUPXdPpPJGkqSypq0o1v2shU
	jkJhnSTg+v6bUFipYnQRT+lY8GQY1Yj/98EkHuERNqCD6olga/r69pNVSX2NS2DF
	5pGaDE6lDtcamtsgzxzuSvwT82gTbWPAgez8VCNTmj2lRVI+6BAHWP2DUf8Q8/lq
	XmjuGsqOh9t84VB+eR8/6fV/Lpa85Rz6brij/0flInzWRkXfK8HOXQoabyGPHER3
	YNrkVYaiQhWXq52f61Wo4Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42s6jtg28e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 23:45:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7MKKmS008594;
	Thu, 7 Nov 2024 23:45:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42nahaqp1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 23:45:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KVlnnT0mnauV5KKCs8X0oCDdqjVvHCeqwBAgyV7F2wb9zKz/AMwt624TKS5KJUYMR26Z7S5O2bdRzfNBvjM0xsX/3vYkayRmaCA6x34cqx+NYe3MwqCd/z0ikt4VTVIwXB6P2lXGKy2Rh69eIMpi/VogsqsRGmDbk5WTmBYm4K/MEfJ7AW/b9oB8spb4AT4utC7AQsDlb3zeBjxJWz42+N4Fj6q6MzEnlZwgO8VIiip2X65jL7FnkZQziq2MJVQJTAh9y9Fx9yl0jU5wL/25/x14vcfRgomgrwxnSQdJcaiBEi3tH3dBwTWVJUlcFSq+iGTQilC4g1NVgBOT7iVH4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=In5YDfwn+ensvNmrelFgcRPyJmH4FZfoWXO2lXge2OA=;
 b=f+no2+W2gu52/z0KgScVBk7Sl/y0cMVuRkrt1Xl6GLk4AQ9H4BkjWTncOkBJqjFaHkNB0atCF3lluANgM4iiZJq1yo8pokS8P6NRR8aFvQVouee2VBNF4559Z6ymMK9LOxIp9qIj4LC9KpGiY2ju4uhxczglK1SEiU21Nedcivp0Lv3aTsY1RhsAKCbVSgqj4KuOVO6tX0wUnuMR14WEc/9rEwRdmk52u848e2ua8hbpQTtak4QnM6os4d0UgMIJTORX+IS4TalXxnlCojXwJuxyjzJZoxLmMxdPN8w43mWyzClgXoiCC74GSd5FjhLEyPvO4/9vmT/1qeCSgIN05w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=In5YDfwn+ensvNmrelFgcRPyJmH4FZfoWXO2lXge2OA=;
 b=PNqPskB6CWpDb9VDt8eLcClOZSeWxIRD5DF5BKUk7kvzs7Cz+y++HXQWAF+GIiQVWymJWG2hZQ0I99WfpALDRdo/dVDE34XPerfRsRiR8DQUkHUsPBZKdVn1MiJNlrYx00FK3F9QPr73PKJsZvhp7dKB0Hd3K998ANZdVoRSmC8=
Received: from SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8)
 by SA2PR10MB4777.namprd10.prod.outlook.com (2603:10b6:806:116::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 23:45:01 +0000
Received: from SA0PR10MB6425.namprd10.prod.outlook.com
 ([fe80::a37d:ab3f:9a23:c32d]) by SA0PR10MB6425.namprd10.prod.outlook.com
 ([fe80::a37d:ab3f:9a23:c32d%3]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 23:45:01 +0000
Message-ID: <57b4b74d-67d2-4fcf-aa59-c788afc93619@oracle.com>
Date: Thu, 7 Nov 2024 15:44:57 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set
 KVM_PMU_CAP_DISABLE
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
        likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
        groug@kaod.org, lyan@digitalocean.com, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
        davydov-max@yandex-team.ru, dapeng1.mi@linux.intel.com,
        zide.chen@intel.com
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-3-dongli.zhang@oracle.com> <ZyxxygVaufOntpZJ@intel.com>
Content-Language: en-US
From: dongli.zhang@oracle.com
In-Reply-To: <ZyxxygVaufOntpZJ@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN0P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::11) To SA0PR10MB6425.namprd10.prod.outlook.com
 (2603:10b6:806:2c0::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR10MB6425:EE_|SA2PR10MB4777:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b9100f4-4ef9-41bb-4966-08dcff863229
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?alBwZFp3T3Rtbm9wc0FPTXg3VUJ6QUR5MUVnREQ1blFBU2tSVEpBSDA0aTN3?=
 =?utf-8?B?d1ZwK2k0SFZBUE5pZUk5TXFwcHA1SCt0eDFscE5OVHlsRHoxUE11QitzN053?=
 =?utf-8?B?V3B2SFJ1TjF5TzNkUGxnRERXSGpSUDlndTlSUjFyM0hpbDhzSXFOVHd6cjQ0?=
 =?utf-8?B?bGJiejVMVWVTVUVhajFMMjdoMnRUZEwwTm9wYnRINWVOZUptOWV2ajNCdTdv?=
 =?utf-8?B?UVhJQU41SWtRZG9uTHpPdEZ4c2NSbklhVjduOVZoNXp4OTViOUZOdWgwZEpG?=
 =?utf-8?B?LzFrZnhzU2ltTmYzVFRaTTlHSzFQL0NpQStrcERHdUp5MmVjYkFXWkR3V04x?=
 =?utf-8?B?cnZkYWdpYVpzeU1LcWYvSkpHUS9ucmthR1NxYmZsNFpBb3lPSHNRSlprVjc5?=
 =?utf-8?B?cG5uR1lvb1dyekpUV2p5MCt2ODg1N3pyeGdJTVppZ2V1Z1VnRmlnYVllbUJ0?=
 =?utf-8?B?N2Zzbm9zVjl5TmVIMHlLZDN1L2d6WkFLMWlNQXRSbXI0NkRySlM0VFJkUVRX?=
 =?utf-8?B?Q0F0U1lzcHIxVG1IcVo1SHZKbTNjVmp5VFBzMU8xMC9Ud0R1MFljcVNhUXly?=
 =?utf-8?B?Qyt4WWxyc3p6QWhlZFNlcW54QjJaeHBMb2VCZFR5NW0yMk1Yd1BQeFZHaU1G?=
 =?utf-8?B?VnQ4ZUp2aWFpV0lscGtnOS9OU1pMZEk5bGYrYWdmNk56SHVZOUFDanRiWGlH?=
 =?utf-8?B?NzNTNVUwa2ltUkQxSEJDNVoyZmZUUlhRVHpoOTJOQzZ0ME9XS0tmQW4wZ2Ux?=
 =?utf-8?B?MStzRjFMQjdCdUFYdFhoR0hOM012bnhsd242RWpBcFBvd25uaDZHZDNHSGxv?=
 =?utf-8?B?MTlrMXNYem5ja1N2SmU5N0RVZi9vSWxNU3p5SUlveEFDdElqY0JpYWhYMWNR?=
 =?utf-8?B?NERPVjBSZjFicEdzSSt6clYyT1ZEa2t6ODJWQ3hndlVnaDM2Smx1RG9GaXFy?=
 =?utf-8?B?WG9NS2FHVkMvK04yck5Zc1JOaHI2RjJLVHZyRG1QUnJ0TXJoYUY2RkpNcUFR?=
 =?utf-8?B?QkpVbUJWN3V0dDE3U2pDRkREakhDL1NySU53YmtYUkRYSmkzMm9lN1dGVGRq?=
 =?utf-8?B?Um9sdjE2SGVnQitsYngzbUN3bUZ4ZG9laGJyNWczTmlTMmhiMmJlTzJGb0Fw?=
 =?utf-8?B?S3o3VC9WeHQ5Vi9JckgwZlFzTzc2QlJQWm1MdDJ6VUlkZUlWV1V3aytQNTFz?=
 =?utf-8?B?Y2kxdEdmemkrMEc5eFFCUlB0WUdiRk81eFArRmZOOEhEMkFhRktrdnBJMkd0?=
 =?utf-8?B?MEVYWlNlalo5WXJmN2ljenlNQ0Ura2NjY3hMN1h0ZXA1U0p6Z0tSTThGcWs5?=
 =?utf-8?B?MU8waDhoRlE2SDVWZkJmbzZ6Wm9rR0RIUnpyRzlYQzRSQTNLekoxVURUZG5V?=
 =?utf-8?B?Z2lnNG53MnRmdkFtbVlzdWVaQ0xhZFJkWG1kRmlicSthQy9nbzdycDdZT090?=
 =?utf-8?B?U0NXbzBlcndyak1uRVFOTUowUm95Z3Y4QzRObG5rT2NSSHE2NGlodkZFcjlx?=
 =?utf-8?B?Yy80T1N3U3RDdyt6UlI0RmZpcFowQWpJM29vanVIajNWa0llakdoMEdVN3Ra?=
 =?utf-8?B?TTRCMWlMUVFYeWI2RmVVZS9SUTI3eVpHRUhEc2d2bk15ZnBoQ2owT1dNWWMr?=
 =?utf-8?B?MTJEem5ySzExRkUxNkJTSEtURGhUeGxkZUlMNkpTTm0xZ1VFd1ZOTERXbmwy?=
 =?utf-8?B?YzhRR3NHU1V1YUkwditoM1JCalVxd2M2T3RaYXZMTjJzRkJuUjE2YWtMa0dy?=
 =?utf-8?Q?Mdi6WRIfE6EK7oxJTtmxUxGdeOf14mWDT3j/lzZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR10MB6425.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bTYzOGtzN1NhTzBHeXNZYjI0UXF0ODJ2d25NTEQ2RUVWdlh1citTdlo2dE9T?=
 =?utf-8?B?Q1ExeHFRS3pEWWVCNXNobzZadGE0UG9PZ3M4Z2o5NU5YQ3BRTjVBeExQR29V?=
 =?utf-8?B?MU9JT2NleVhNSFZMSzIyUmhITVpZUnNiRnV6MjlJdnR1QmdueTBLUXpnQ1BG?=
 =?utf-8?B?OW8zOTg1MWtKdEpzNmVRQU5RQ2JxZVo4QUo1K2dBOERKenYyeG1SRU80SExP?=
 =?utf-8?B?ODZTSkl0VkdsUG91djQvbEpIbytUNzNXQzdVWlNseXhaazBmNzdJUmRQSjNm?=
 =?utf-8?B?S3g2N2p3VjlWL1V5K3Irdm5nVldiazZMMnQ5Nm9ZQ01KSGFqdERVRDVyS3dq?=
 =?utf-8?B?NWxHa0t6ODRmcXk1VTZtekZGaXB0VzZNbmJSVFAyaU45LzhKTTFjMFhDUkpu?=
 =?utf-8?B?bDBSeVZycUg3TytKN05HZ0hWam9vOXp0RURXbTRsUFE2Nm9SSFFKR3BPMkUx?=
 =?utf-8?B?cTQ3VVZLTnU1V2R2VWRibXdhc2dPWnowbnExa3lCQ1hFdzhRNEE5OE5RSXdh?=
 =?utf-8?B?TVhhaC9TSytUMjNrVjRzQkRzSWFoaThoUkZ0bDhIOTJzS0ZSKzVMOW9SVCtZ?=
 =?utf-8?B?WFFock9vRlRZSEV3NzU3WFdoZ0tCRnF4Y3g4eTRsRE9Fc1d1bW1FY0trdXV1?=
 =?utf-8?B?ZnY4VlBxSFRydStEdUNMaXBQT2JCeG1JTmVIZ09LOGFJU2dUUHdZLzhMaGVM?=
 =?utf-8?B?ZUZ3NTM5bndZRytTNkowMnJvWUgvc0V3ZkRmcTN0WHQwNnZVRUk5RnZNYkF2?=
 =?utf-8?B?VWVPQXQ4WmdnblI5Nk54T1JxeHNoVlRMN1JBZWlybXRKSVN5VFRoQk5mZXJo?=
 =?utf-8?B?Vzl3aGE0ZkhicmhJelJ2MzYzSlBMRUdQUWV6eTlvNTkyYWlsSk9kQ2tnWDNN?=
 =?utf-8?B?SzI5SmZ0KzZzamhpVml6U25rZFhIaVUxMmJta3FybXlIRkhpUllKRXkzNm1U?=
 =?utf-8?B?NzM0UFkzSlZoWXZsbnB1d29heUxuTnhlSmJiWnhtVjlFcUV5dmowSHBDMHpK?=
 =?utf-8?B?QmZrVTVMU0pqNXdJRG0xbks3bWhXOHFoMVRCMnNZeEg3bnVqdkJUcENFL3pY?=
 =?utf-8?B?V1RsOWx3SlRvZUd4RDZvTFYwbHU2V2JHOVFUYWtobndZUWp2Q1hOeUdaU0FQ?=
 =?utf-8?B?cDFGMnpQNWN6a0ZDOGpuNElVb1BtSkFjcDJOTEZ2NXp6YnpNUkkvaWEwcTBk?=
 =?utf-8?B?cWcwTUs4dzQ3dklzUHZTcDNWVG9RU0VlckcwalRGSHlVWjlIcWtHQjVHNnk3?=
 =?utf-8?B?RlRaTW1rMS9TdDdFOTNONmwvQU9hNExXQkNXV2tWaWR2MkZudC9mSTJ3Y2FF?=
 =?utf-8?B?dkUwT0lBbUJDMmswcUVCa0VzeFc3QjcrV09CczE2cGMxZnM0Zk44d2lURGVz?=
 =?utf-8?B?U2xRTThOaDZxVURjVFlTUnFId1pBeTBVYWM1eDB1Q0lBZTFPck1wTjE3WWVv?=
 =?utf-8?B?WVBCaE9qM2ZVU2JQWmNmK2FYQXF4WmExdWwzY2V5MjNGOVYxMzdZYURTSkJR?=
 =?utf-8?B?dmZENFZQbzcyOTBTNWpBbGhPd200TFl6aXdYSzNTRnk4MkRPRkJ1Q0JydlVu?=
 =?utf-8?B?d21LZldaZlFBNE4ycHNFeDlJeXRNNy93L3c2dFdIb040SU5rRmx5b1UwOEti?=
 =?utf-8?B?VU9XVzRRUGFwa0VVWmI3NDFMNk9KMUFyeDczVlVTdFYzL25peXcxVGk0VUUy?=
 =?utf-8?B?NE5XMWRNSDAraWJpKy9wSVhGak9xamhtVTIxRFpNRFNuSHZjQ1N3TXFpSk5o?=
 =?utf-8?B?WXZjcnEyaktGRnRKUHlXMXBGNTJ4QTR2UDl3MG5RejdQVTNSWm9BdVVQaklH?=
 =?utf-8?B?Ym1lT05lbEZjbW5pZFc5MitMSzRvUVVianlzbTFObXp0VjQ1aWpaRjVHKzFG?=
 =?utf-8?B?QjJrY3VabnpxY24vYzNDZlZoWUI5VXJIS3VkamQwOWtvNXpkZ1ljUGJicG83?=
 =?utf-8?B?cEhNVXNwcE5KTERJSmVZNllpcHRScCt2VkJCUGQyTC9VbXd3ZUNSNHNQMjIw?=
 =?utf-8?B?ck5xUmZpTjJNTW5Odi9HTGh1dG54d1QrNXBTVG1LU3RTbWptV2Z1VzdoYjh1?=
 =?utf-8?B?MlFJMFJLZi8xTjRLK1VraDg5QU80QngySzZzeGRKM0xrSGsxdTk4MkpRWjhH?=
 =?utf-8?Q?pbVcFCCzGzS5CJRzQGK9IPAkl?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DuiqHzTpWZS0jrXox7AmjHbYX2T+xO+psWtDlVYRHlPxrpAG9WMFNhV5uO4y3W4h2kBWTqP2NIpO/MEruqDjdXYBWzdQNYgKjKL/szbTY9xqTCMowsA2jYL05jqGd0kVHSJnaT751M+1IsZBv1c5srjiDJYjyyvx+kW3KPH8oq/V1yYZfTMtM6m2xGls2nPqCS1ZN2q5gzXb2fStx7vpLKBZmzjhNxurPiADtRYk7xI54xJSr1BhQ6aiIcBYoRQlc8hie8xfI07FJM9AdZAjWm2rMLIE7k8GZYeQqUTcoTf3RHuNfd9OltOpzIpnrzxCYw4OQ43fncPKI7F3gtE085xetWGE+AZ7iN+T18GDtYpNP8fJ1yRfo/n+JOiAQzGHy47EuWKFHRtCR/7xz1zyF3lHdVw37SGCizSXMWBJXQgStqMpllu1HExH2UvZq+iULRkyjIz4VnEIFAMhOJqIJ2UNFGVAPQ/JiLGJbwb8WdKWpTAI8MY32rCT3XAyIXcdbEegRMnwnRy0AHMMd4uZh66irDmZ6jX1ouEcxln7eB+tRO30onyoixvbUly4/c503B9poL4uVHaXoSVyeZAIC/h1C2BnE+BuEwhfXC86bhs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b9100f4-4ef9-41bb-4966-08dcff863229
X-MS-Exchange-CrossTenant-AuthSource: SA0PR10MB6425.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 23:45:01.3924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XfjSyN5URLQPuYYhJHVnCWBE+d4cuJxlY2MeVpy68jp4l/ieqif7a6roLYsExFiu8ybbL9yk5uJ9L1ZV8nOoLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4777
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-07_10,2024-11-07_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411070185
X-Proofpoint-ORIG-GUID: AGPUmh_NKTDFZjyLsUz53TiZd30yNAKg
X-Proofpoint-GUID: AGPUmh_NKTDFZjyLsUz53TiZd30yNAKg

Hi Zhao,


On 11/6/24 11:52 PM, Zhao Liu wrote:
> (+Dapang & Zide)
> 
> Hi Dongli,
> 
> On Mon, Nov 04, 2024 at 01:40:17AM -0800, Dongli Zhang wrote:
>> Date: Mon,  4 Nov 2024 01:40:17 -0800
>> From: Dongli Zhang <dongli.zhang@oracle.com>
>> Subject: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set
>>  KVM_PMU_CAP_DISABLE
>> X-Mailer: git-send-email 2.43.5
>>
>> The AMD PMU virtualization is not disabled when configuring
>> "-cpu host,-pmu" in the QEMU command line on an AMD server. Neither
>> "-cpu host,-pmu" nor "-cpu EPYC" effectively disables AMD PMU
>> virtualization in such an environment.
>>
>> As a result, VM logs typically show:
>>
>> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
>>
>> whereas the expected logs should be:
>>
>> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
>> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>>
>> This discrepancy occurs because AMD PMU does not use CPUID to determine
>> whether PMU virtualization is supported.
> 
> Intel platform doesn't have this issue since Linux kernel fails to check
> the CPU family & model when "-cpu *,-pmu" option clears PMU version.
> 
> The difference between Intel and AMD platforms, however, is that it seems
> Intel hardly ever reaches the “...due virtualization” message, but
> instead reports an error because it recognizes a mismatched family/model.
> 
> This may be a drawback of the PMU driver's print message, but the result
> is the same, it prevents the PMU driver from enabling.
> 
> So, please mention that KVM_PMU_CAP_DISABLE doesn't change the PMU
> behavior on Intel platform because current "pmu" property works as
> expected.

Sure. I will mention this in v2.

> 
>> To address this, we introduce a new property, 'pmu-cap-disabled', for KVM
>> acceleration. This property sets KVM_PMU_CAP_DISABLE if
>> KVM_CAP_PMU_CAPABILITY is supported. Note that this feature currently
>> supports only x86 hosts, as KVM_CAP_PMU_CAPABILITY is used exclusively for
>> x86 systems.
>>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>> Another previous solution to re-use '-cpu host,-pmu':
>> https://urldefense.com/v3/__https://lore.kernel.org/all/20221119122901.2469-1-dongli.zhang@oracle.com/__;!!ACWV5N9M2RV99hQ!Nm8Db-mwBoMIwKkRqzC9kgNi5uZ7SCIf43zUBn92Ar_NEbLXq-ZkrDDvpvDQ4cnS2i4VyKAp6CRVE12bRkMF$ 
> 
> IMO, I prefer the previous version. This VM-level KVM property is
> difficult to integrate with the existing CPU properties. Pls refer later
> comments for reasons.
> 
>>  accel/kvm/kvm-all.c        |  1 +
>>  include/sysemu/kvm_int.h   |  1 +
>>  qemu-options.hx            |  9 ++++++-
>>  target/i386/cpu.c          |  2 +-
>>  target/i386/kvm/kvm.c      | 52 ++++++++++++++++++++++++++++++++++++++
>>  target/i386/kvm/kvm_i386.h |  2 ++
>>  6 files changed, 65 insertions(+), 2 deletions(-)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 801cff16a5..8b5ba45cf7 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -3933,6 +3933,7 @@ static void kvm_accel_instance_init(Object *obj)
>>      s->xen_evtchn_max_pirq = 256;
>>      s->device = NULL;
>>      s->msr_energy.enable = false;
>> +    s->pmu_cap_disabled = false;
>>  }
> 
> The CPU property "pmu" also defaults to "false"...but:
> 
>  * max CPU would override this and try to enable PMU by default in
>    max_x86_cpu_initfn().
> 
>  * Other named CPU models keep the default setting to avoid affecting
>    the migration.
> 
> The pmu_cap_disabled and “pmu” property look unbound and unassociated,
> so this can cause the conflict when they are not synchronized. For
> example,
> 
> -cpu host -accel kvm,pmu-cap-disabled=on
> 
> The above options will fail to launch a VM (on Intel platform).
> 
> Ideally, the “pmu” property and pmu-cap-disabled should be bound to each
> other and be consistent. But it's not easy because:
>  - There is no proper way to have pmu_cap_disabled set different default
>    values (e.g., "false" for max CPU and "true" for named CPU models)
>    based on different CPU models.
>  - And, no proper place to check the consistency of pmu_cap_disabled and
>    enable_pmu.
> 
> Therefore, I prefer your previous approach, to reuse current CPU "pmu"
> property.

Thank you very much for the suggestion and reasons.

I am going to follow your suggestion to switch back to the previous solution in v2.

> 
> Further, considering that this is currently the only case that needs to
> to set the VM level's capability in the CPU context, there is no need to
> introduce a new kvm interface (in your previous patch), which can instead
> be set in kvm_cpu_realizefn(), like:
> 
> 
> diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
> index 99d1941cf51c..05e9c9a1a0cf 100644
> --- a/target/i386/kvm/kvm-cpu.c
> +++ b/target/i386/kvm/kvm-cpu.c
> @@ -42,6 +42,8 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>  {
>      X86CPU *cpu = X86_CPU(cs);
>      CPUX86State *env = &cpu->env;
> +    KVMState *s = kvm_state;
> +    static bool first = true;
>      bool ret;
> 
>      /*
> @@ -63,6 +65,29 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>       *   check/update ucode_rev, phys_bits, guest_phys_bits, mwait
>       *   cpu_common_realizefn() (via xcc->parent_realize)
>       */
> +
> +    if (first) {
> +        first = false;
> +
> +        /*
> +         * Since Linux v5.18, KVM provides a VM-level capability to easily
> +         * disable PMUs; however, QEMU has been providing PMU property per
> +         * CPU since v1.6. In order to accommodate both, have to configure
> +         * the VM-level capability here.
> +         */
> +        if (!cpu->enable_pmu &&
> +            kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY)) {
> +            int r = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
> +                                      KVM_PMU_CAP_DISABLE);
> +
> +            if (r < 0) {
> +                error_setg(errp, "kvm: Failed to disable pmu cap: %s",
> +                           strerror(-r));
> +                return false;
> +            }
> +        }
> +    }
> +
>      if (cpu->max_features) {
>          if (enable_cpu_pm) {
>              if (kvm_has_waitpkg()) {
> ---

Sure. I will limit the change within only x86 + KVM.

> 
> In addition, if PMU is disabled, why not mask the perf related bits in
> 8000_0001_ECX? :)
> 

My fault. I have masked only 0x80000022, and I forgot 0x80000001 for AMD.

Thank you very much for the reminder.


I will wait for a day or maybe the weekend. I am going to switch to the previous
solution in v2 if there isn't any further objection with a more valid reason.

Thank you very much for the feedback!

Dongli Zhang


