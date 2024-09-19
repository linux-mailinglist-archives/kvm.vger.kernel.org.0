Return-Path: <kvm+bounces-27182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A09FD97CCB1
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 18:53:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DC2A285FBC
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 16:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D8E1A0AF4;
	Thu, 19 Sep 2024 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WKkvD0u9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bCC4LJC7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B94194C8D
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 16:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726764788; cv=fail; b=nixuQP+MjbIHnZ8xmV9hm1iLi0F7poeS2HbtrSAA48imAhQWHP0fGQgsUAL/ASeFxkHubARRtBynmpPIw/KsV2AEs18wLXYSTwkYVSoJ6o3IKbAYRAkbTA7wfj1BTwmSv9bnqA3+6kA28Na058n3BRSaKLslnIbI4ovq3CvQ2bM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726764788; c=relaxed/simple;
	bh=faypXQfRjjKo7nSmC3roCfOMFOgVUJIGUIAswE120x8=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kTJ+EnSLX20/Fs+iBl8eF4RC6bLZ05k/t3xkn8pYngo1lslfZCF09eMTVoU4eg4qgd6m2NRnnRoky7PYmA1UZ8OMXEDZxlLwoE37ZUzGt65NeV4wb56XxCypa7QSLDi4gBeWM5NC1M9nCuHvFu4Q58cU9MjplGoFlKMRmVqNPwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WKkvD0u9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bCC4LJC7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEr6bA001479;
	Thu, 19 Sep 2024 16:52:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:from:subject:to:cc:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=c7XjqE/0UN2GXbpfV3mmNT7XJdmBnNJ6bnfSAYbUfok=; b=
	WKkvD0u9p9MRf9Ds9xtXqEP9WqfXSoybAAVrtA2tXCH30m8m8Ntp9uNQeQiM2tyi
	zBIJK8csGSMqsNLV3Bel9cR38pJjhPeB9MnTCXZG7POCCf/5y02PhTqFaDXUWl5L
	6Jqa3OS0T4NWCQpGLkyWHA8D2RQJzB/5hifs21uLoU5DO2uIydEMYP/AkpK6mb4/
	Oso1malX67GVL7/d9dH6a5yFiPYCJrXrUYqdzAxyXC6RMfx1vD/WXB6G1i/RBrkh
	RVF5OW0gE2toiQakJCA+H0tGFJtqrmPnzWvPhqF4qsooRyKS57NUKxBdi5BgPqIK
	SLAluFK5i7H6Qp8yAuFlWQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3rx4hgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 16:52:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JGcO7H014907;
	Thu, 19 Sep 2024 16:52:46 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41nyg6br04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 16:52:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AHYGpgeAOPIdGuIMXvss+piTGl9/vcTfOqcR2DpfHDNWauCB2gIhrldmRZLGcxaCMlW73TdP4ATriKaD+0+0LS69LyDc9QwC650kImWLraqY4e0TIo+IelcYVa12XfQVW0TvrJ/eGWMYzJLX4jme0CrkXjWBy0Fv6kSbiXuyWfQ/uUgDQZA8N9RW12rjDHlORKTnT5KCPfq0CIBkxB4njdY7MofEpLU7tLI7zHoum+J0wSO0YvWcld9ZFK7Cq1GfijxMKbmMPaTESURxldE6Fqmy+x++hrlRST2+L5NoJg/MsysiLps0TdmLDklDRrTEzkXe8oBLHUYNl+5JZ3gCsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c7XjqE/0UN2GXbpfV3mmNT7XJdmBnNJ6bnfSAYbUfok=;
 b=UQOTJnvDhypv8i0l6hYGPkpKzf8RxHDCbjU2R6tq8au/vpObJp+Q4bQb71wZankBAfroa4/A2MnbKFAat815OsHKQNxyDQqXpaG5IdRjsRej7lcg5SBsTtV6zr/uu00iAKkcq7G+sWirY3O4bBmNRnq1/uJfpgcomL55Uyqxb/H0GfP2DkTG6OFbDqtzgWJPNB28gDyq/uqcOo+mSCcHwxeZFyHRSnmTdkOA4zp+pv/NvmMsozQBPfonPaVqkwYeTTCWiObx9p5XcWlWD1ziC2hW6G9O5FSDx9cLaIhAXt7dukNKkuXmo9G0YLuHGwYEuvzDAt7pN2tSoHrDhJ9SKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7XjqE/0UN2GXbpfV3mmNT7XJdmBnNJ6bnfSAYbUfok=;
 b=bCC4LJC7iLmNDflam8+xP+rFL5HR1GTR0kJOUEIGEAhGZQwjzR7nL4rvSJMpLe4UGP1aJFRBcb2PnkuP/idm0UWbNtkjc8R7SjpN7oncneg6+hp2gIv/YF4Ps4vWp/mqGyo9lP8HDkPMnySR/VVdVZjT8/VdLCfRPghaVFqDIHw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SN4PR10MB5576.namprd10.prod.outlook.com (2603:10b6:806:207::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.22; Thu, 19 Sep
 2024 16:52:43 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8005.006; Thu, 19 Sep 2024
 16:52:43 +0000
Message-ID: <0ef808b0-839d-4078-90cb-d3d56c1f4a71@oracle.com>
Date: Thu, 19 Sep 2024 18:52:37 +0200
User-Agent: Mozilla Thunderbird
From: William Roche <william.roche@oracle.com>
Subject: Re: [RFC RESEND 0/6] hugetlbfs largepage RAS project
To: David Hildenbrand <david@redhat.com>, pbonzini@redhat.com,
        peterx@redhat.com, philmd@linaro.org, marcandre.lureau@redhat.com,
        berrange@redhat.com, thuth@redhat.com, richard.henderson@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org, joao.m.martins@oracle.com
References: <20240910090747.2741475-1-william.roche@oracle.com>
 <20240910100216.2744078-1-william.roche@oracle.com>
 <ec3337f7-3906-4a1b-b153-e3d5b16685b6@redhat.com>
 <9f9a975e-3a04-4923-b8a5-f1edbed945e6@oracle.com>
 <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <966bf4bf-6928-44a3-b452-d2847d06bb25@oracle.com>
Content-Language: en-US, fr
In-Reply-To: <966bf4bf-6928-44a3-b452-d2847d06bb25@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0104.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SN4PR10MB5576:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a82550e-7beb-43a5-fe4a-08dcd8cb7ae1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R3YwbGdBRVprb0J3WWpTdlh2OVdnN2h1SXpXVmlqTytzU3IyTFl2OFIwWWZT?=
 =?utf-8?B?WHlFQmFFcXh4RUhnUm41VWh2elRNM2F0aDljaTRybHJHZGFCVTNWOU5yajk5?=
 =?utf-8?B?Szl3aVI1ZTkwVnlrTGZmY05YUWtpTzRpR3dnZThlMUdZWCtpeDRIeGs0Vk0v?=
 =?utf-8?B?THRNWjMxZ3oyakk3Rk95b3R6RFZ6elkvV3lOUUZaeWl0bnp1LzJhNFlUTUZW?=
 =?utf-8?B?ZjRiQWR5bFpEd0hNK000c1NBM04xMG5STGgvenh0Uk9tK0Rtc2RyUmF3amJz?=
 =?utf-8?B?YTVIYUh4dkplZlBVR1pmcjFRNmJWbnFxR0xvZUhLd2tRWXdhWkwvVDFzY29C?=
 =?utf-8?B?K3RhRkh5TlVaQVFETFozOFdPYk1veVZIVTYvaFZoTE1XRWVRM1JONFAvV2xt?=
 =?utf-8?B?b3FuZGh1T0U5VXF6SS9iT2dlWHZkWFk1ZU1GWkYwbTFOM0RlaUNnV3J0UVMz?=
 =?utf-8?B?ZkttN0tUOUFMbTU4c1B3ZmY5cGxYVE8wTVhGTWhRZWZCampKOVdFanVsdHBL?=
 =?utf-8?B?L3oxTTRSRzZsR1d1OE1xNkhIdjh2RGtFckV2UGZGajNGWGxROFpkdE5SYUNH?=
 =?utf-8?B?cHZ5YnBCS2VYS3BkaDhyT0JKWC9KVlBnbXdnVjlsVHR2UUFtNGRpNHBZN0ZS?=
 =?utf-8?B?eEQ1RnV1VjBJcG1WU1p6bndaaVpBc0NrNGtuZmE0MzJJLzV5QVpCcW1IK0FY?=
 =?utf-8?B?TTQzNU02VDFjbFE4bjEyUjljRFA2dE85bUpyb0NjVW1SK2lZUEFQbnpZTWtT?=
 =?utf-8?B?eFV5NmpYZ3FFNDFoc1FyaytuNmJrRFJ4T3hWUDJsQk52anRVNXZJSHA4U05y?=
 =?utf-8?B?b2xsREdGRFpnQ3N0WkU4enJ5N2pOWjlybkttc3R4bUQyVkZ2YTZrWnFJSE9D?=
 =?utf-8?B?bE5GdFNQeFh1MjlJMWwvRExuYUdpVDRNL2JKeE9GVGtGWVJMUDc1YUhvTHNx?=
 =?utf-8?B?LzVmbDVrYTRJOCsxZklCZldWSm9lSWZiMlZFWFI0a1dJZG1neW0xMHBRZ1g0?=
 =?utf-8?B?ekRZMExQTElGdmJieHQxTk5UVGRGOXBKYzcrU0syamdqV2hyV0phaUpLK09a?=
 =?utf-8?B?ZGt1MGVlZlprT3NOOUZvU2VxM0phRnZ2NnlmSGs2bTJqdlFTbU9jYVlZTUp0?=
 =?utf-8?B?SGVMY3BWVm9WbkJySG82VVY4SDNvNlNMdGZwUjVHMXpyNmx4WGYwZHZFSTVn?=
 =?utf-8?B?VjlZYy95QTJoWlFFWnhOY2RJTk5FMVN1UXA0ckM3Rm16S28zQVVUZjNjTkgz?=
 =?utf-8?B?aGdZNFBWcXpYYUJzNmNhUFExdnJMcSs5ZTI0RnVnK3RwZkNUU29GZTZZK0oz?=
 =?utf-8?B?WFNQMXlmWDBTTFl2WjZJOE5MamlPVkx6cHdvQ0YwZGNkb2VXTm1MczJ2R1JE?=
 =?utf-8?B?Q3JjVVdiNThmSmJpQTlCbFE1b1VDMCtIK1Iyb0ZWMlJJbEdVMFJkMHcxZ0Ix?=
 =?utf-8?B?TGMvN0wzS2kvYXZaWEZ0T1BFcE1RT1pSdzJPSndvVzJibmVhYTBDVEF0bzVs?=
 =?utf-8?B?TnNvZnpQNkpUbGY3UmtzdDJBc2E0OUtyUytWcWVrcTBhaUgwV0xxSUJ3ZWhs?=
 =?utf-8?B?VDI1UEh0WEgxMkZmUDhYRlhPUEY1d2NlRFhRQ2Q5bit5cWg5TlhUTDkrcERn?=
 =?utf-8?B?aUNOb00vanRWdmY0V0VPSnM4R0M5RVFsSkJNSkpJM2p3TzlyN1Q1ZkxEMnYv?=
 =?utf-8?B?dTBMd1VwT0phUkxwZ0JjRmRaamlkUUJ1QXVpZ2I5QUwya0VQRi9Ea2I2cUVl?=
 =?utf-8?Q?YclUy6BK8PQcbGYlqbYV4f4Gfj6kz0FSdOnhtIG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWJTK2c3U1NwR00wY2VDUi9GbFhNa1JEQ2dwUlhoWjd0K1BCRk1ZdTRqNUpa?=
 =?utf-8?B?ZGhJUCtxZithckVvQkFCcmoxcmhrN1ZabCtuRlM4WU5EOGpVYW4xY21qQTRp?=
 =?utf-8?B?eG9zamhBcnNieUhJbjM4cjJOYlNhbzRyUEV3QVlhQ21RdXZmWXFWSUlFNEQv?=
 =?utf-8?B?Y1VPTFk5RG9EMXkyU2tUa0JZVFFMdVRkU09hOTQ5VWx2ZzQwd012Qi85cnFH?=
 =?utf-8?B?WUpEcWx6c2ZYT2xvdGJXcmE2MFUrcGZwS1l0RjdWOEhrdWMwSlpKd09FUGRR?=
 =?utf-8?B?K0dIQTVLdFVEUnozMGZZazc1TzVJOElKaTkzZkJyRFI3RkI2Rk0zV1pQSEg2?=
 =?utf-8?B?ejI3VWszVms0dGxnMW1aVS9ONmZKYVZDQ3lFUXhmWGpDa0J2emdnZHhLSjFV?=
 =?utf-8?B?djlHNmJ6bi9IWWVqS1hmN2t2Z1VaQ0xTM1NZT3FyODl1U1h0c0JHakNlLzk3?=
 =?utf-8?B?TW9FTlM0K2J4YjJWZlBaRWVteWE2L3NrbVpHYXB1TllsUHpReHRNdDNqZlJr?=
 =?utf-8?B?cnhiMmRLOGFQM1JQVXJxNGNWMzJ2aFgydWhFNHEvZU5jNUdJakZZeWpHb0xa?=
 =?utf-8?B?cVJHeWtTS2o3eVJmdHRTM3hNTzFuMVlyaG9RSXI1Y0ZXWkdCaVdmRXRUTUs3?=
 =?utf-8?B?ZjJXQy8vaG5SeENnSXBZSENWSTNKV3ZieDh1dHdGa2YwRlhuR1hYdlpqNkpF?=
 =?utf-8?B?U08yZ3BlSUxnUjJRT2kzSlFPUU5NakxJcVg5ZzRjWVAwU3cram9adVFyaXRq?=
 =?utf-8?B?VkFNMU1lRGl1VFV0S05BdlZ6TFV2S0hNWXc3d1Q5N1BWK1dGUXd2aEtDeG5x?=
 =?utf-8?B?eVVpS3VGSVdTOGNpdTFSWGwwcE9SS3dvNXpSSDd1OFVZSkRHZE5lVHpiSWpK?=
 =?utf-8?B?UEs5blNZSVFUMi8xcjdlck9hOTFJL0gyZlZhdGpYOUNaeHBCbUpKandYWkJw?=
 =?utf-8?B?T0lEOTA5NXZlZk1CYWE2OGxkcW96Nlpjc3k2NytnM0JPTXVkRjYxakM4bkxE?=
 =?utf-8?B?b1N1NmZpVjA1M2VZWjlTM2VMWngvT1FFNkpaNGJLRzZvRU12MFQ3VzBRNFJ3?=
 =?utf-8?B?d0FzMGVMSVlmeXluVTFFVGxEbThaK2dTRGlOdmthK0s3UVhxdU1CRFBkOThJ?=
 =?utf-8?B?SFBEVldxbmxZMUluQWxjUUJlcmhOb0pQRmZmNUZReEUxOTAvejJHS1ljUUFP?=
 =?utf-8?B?Y280QzZ2TFBub3ZlM0dWRkNHZlFwa2lKSGxCSXR4RDF5RXJqVXZRbkcwOVZn?=
 =?utf-8?B?SWhxY29YcWUyUm90cnBEQzNDSnhoSXFjOTVFdW9ROGljV2NnMW9vYTB0dUtF?=
 =?utf-8?B?aDYxUHN2eWxXbzBIRFVvZUxEU3VjMmtqYnRlMTRINHZISnJxaUFVeiswL1lS?=
 =?utf-8?B?R2N6aXp4VkdPd0lBdis1ZlNRVDQ5SG5IRkpVcGpFbDRUN05kZE80VGJrZGl5?=
 =?utf-8?B?cXlQbjNLOC9PRTNRUDFSZTVGNjdacytweVhQTW44Snd0T1plU3NKenc1RDlr?=
 =?utf-8?B?Vm9vYWkrS291SzF0djF5R2hMdXRsU0FBa21VVVNCY2Y5bWRhV3FWWmROcll3?=
 =?utf-8?B?T0p4RkpNVGxHeEROdW8vaCtOSDlQeXhNTlhySG0zaXhmSnpXTFlkMVNDeW1r?=
 =?utf-8?B?ZkhGcFBJOWsxdWxNeEYyRDFNKzI0aGFaZEpTbE5BUTVqQkQrblBxTG9VN3U2?=
 =?utf-8?B?NWM1eDhTSk9XdmNlR0JXY3hKd042dnpFcjg0MFVTeFJwajdMZFU0YmQwNWtH?=
 =?utf-8?B?RmZDbUxvZWFGczUwRElDMjZrNEdkcUZlUm5oSzFsY0hvQzZiSzBiUVh6NGZQ?=
 =?utf-8?B?WGw1RmY1aXF2WlZ6WXZzRmNtaEpVNWhSU0dFczNJdlJQWlJNdnd0VHAxczU3?=
 =?utf-8?B?ODdGZngzZ1FoSzNoazBqL1h6aVdMY1hVRlE1YnEyeXdJVHJSbEViVDdDNG1j?=
 =?utf-8?B?NEs1Z01DMVhuSGJMdmZiMWNpaGNQYmJ3dkYvaXBTNkNUUE1zV2FaR2Z5aEVu?=
 =?utf-8?B?aUUzYy8wd3FOOUxMaUhJWmF0RkJzMCtzTlVWaHNWK2FqczRzUENZdFAxc2NQ?=
 =?utf-8?B?Y1YxeVhrNTcwL2loWG1iRnh0aXRtYWY3KzhMdXNkOU5PRlh4S0lteVIzTVRM?=
 =?utf-8?Q?LcvWZTMCOqqUA84Ckea33GbkW?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o9wQWl3Hvznem3hHmvXCWnSkPrAu57kcvWjwDSO2gA8rngC8Y52uyNjX/jOheN5nhYMGginaZEdvSJTwJnowbVr6AIxtihmO7AUThpkCx5R5K+O2YmV4lLw5IUgln6cUWW4dJ9pI9JmZ/udmBCz1NUCpTRENOVS83KmIv/WuS1CLxqtofqBr4Orw3fhtZ+syAfmEgs4kr9UWOk7K+a6sw8PXe0MdECrVX0QMLmy+WD8UbNahYgfhZf2s0a+Kht35be66r1OhJrZN9V5wPw84O9+jjfG69X7Q8Rv4qBC6ehQ6swyj6OUKEdmqqrx2cehlyf6Xi+7VBlEqxuaI7nKK3VOe+ZIEJewelucWP9WoKhqokP49DsT5WWaiBWbz6GgMltZVZ/tcUFzE2o9ZWJO8b0joxf5p70LGgTavTsjKDfueZQOMOoqy8CUs1sU9hzjJa0FSPleA1ZISH2z5aVGtORNtrRQsgDNRqVt29bOKsfuWfk69nv3kaHESvcR1zZZPXI19c9ssFEDfyZ1IBgcRXeqUF+5tQgDiVQuQYXPznf0FROfaRmTNr40v3zsMuS3pZiDaei8v9V4T+/T94Q2qiYQh7RGJPFZLPEy6Ct247I4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a82550e-7beb-43a5-fe4a-08dcd8cb7ae1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2024 16:52:43.3872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eQMXeudDJJSCbREdPO/CioXPo3aPh2QiFEUJLp2aKJUSmu+8BzlyGDmkeAeSQaMzViYwcuhdXToIDH8SVB6qczps/4DyjYJhoBO/oJhlOGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5576
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_14,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409190111
X-Proofpoint-GUID: v5MGujXWxfVxnohx3sttuxlBprkglymJ
X-Proofpoint-ORIG-GUID: v5MGujXWxfVxnohx3sttuxlBprkglymJ

Hello David,

I hope my last week email answered your interrogations about:
     - retrieving the valid data from the lost hugepage
     - the need of smaller pages to replace a failed large page
     - the interaction of memory error and VM migration
     - the non-symmetrical access to a poisoned memory area after a recovery
       Qemu would be able to continue to access the still valid data
       location of the formerly poisoned hugepage, but any other entity
       mapping the large page would not be allowed to use the location.

I understand that this last item _is_ some kind of "inconsistency".
So if I want to make sure that a "shared" memory region (used for vhost-user
processes, vfio or ivshmem) is not recovered, how can I identify what 
region(s)
of a guest memory could be used for such a shared location ?
Is there a way for qemu to identify the memory locations that have been 
shared ?

Could you please let me know if there is an entry point I should consider ?

Thanks in advance for your feedback.
William.


