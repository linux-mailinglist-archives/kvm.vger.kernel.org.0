Return-Path: <kvm+bounces-65374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 75BFDCA8BC4
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 19:15:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4CBE8305F64F
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 18:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F9962EC0B3;
	Fri,  5 Dec 2025 18:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aE3FrZDi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZVLfhKdI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338C22ED168;
	Fri,  5 Dec 2025 18:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764958370; cv=fail; b=hS5IEwOVTZa9a8FZ8nGVdws3aMdHPKcFMj1hSGi/D0cp4JFafeowmrZmgdphd4E1OERjpXGk9NMNtVq5ThQ/CL24/Yy/U/ciX90zDrgJrLZjou8IgdSsx5xMxFbATVRq2sv4svlbA7/k2Ji1zBEpXpwykRYDZ1YL1Zfe7h43Qd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764958370; c=relaxed/simple;
	bh=Y0d25FA4MCkCKcerBtWUAg4zHDPcG9X8KRZzWUoPjxE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pzW4ELK2EAyOS1u+MAda5hwl76JQg26TVlcMmPnimfI0KeQB7AV2+F1bZbhxdFtTuEikjTq/CxduhbZEQOAK0NEcq1IbL7+tlCtt1iOfQHCYcNyIl1B8wu3xpE3ZZL6OHPScmXzAdVyXATUE1GDXYPN0AOe/3zLAJ2vYA3DC6IQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aE3FrZDi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZVLfhKdI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B5GCI6m033342;
	Fri, 5 Dec 2025 18:12:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LBxpRPSOBkjlInAnKU4BZRZvbqkYS3ECKvrwpzP+W20=; b=
	aE3FrZDiGniaW21QorbVmMjHqG7rOKh26MBwLAIVLTVk6RP79EaPVe8sKau6ODbX
	19TsTdqjO7ORoyfogQPu0HpYryVLAQrJvFHrOm3+ycN/oinGhdq6gb05G59wqNKp
	1rwFu8NvatL6ZybLvosy4X63JjN7qS0m7glkN/YGFYxhEPiqi+FoiTSt3SWYXMYl
	rq9trCVpqIMxh8rdxt1hpFxyrGAlY9Hp8lhnyxmGaa1sWKZw6Nghuti1BWwGsBi3
	UzuyZO0OvL1FOYewWjn7EjEjgRkV1YLxwyixMJRTKWvS5kmIT3CFEikIpoNju4Wl
	fbguwGpj/ECaYKEUoRX1OQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as7f2anaj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Dec 2025 18:12:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B5GNlxR004803;
	Fri, 5 Dec 2025 18:12:16 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012063.outbound.protection.outlook.com [52.101.48.63])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9drwqp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Dec 2025 18:12:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wj9RY5WLmpL8pYhKKiMo9aHsHfZ5EFP25kf1+SYenoBz1Z0hoNTIVRU0VE4ShlkEUvCQ/+jv6wedOBBQc77DXpaFVoEg6nHxG1q59h9p39GlJA1RTr7Y3o1cwE7bBfLCp75/oCOu16wCSqeQOyfKVKsYEumyrEjBbptqtZJJLH1r5jS5nCPOpuLnxfOjmaXf7gT/aIrd6qIfDEB3qfeiuhS2pKc/mgvRhXfvJecnlvK0s0qYDSrDYwqey6ljdZpboJAUejRB1iWU2sCf0qqFUd6KoMm7jwo5UMrI4W57E7HH2c7mfAR7uHXTHtSyDpAl65Qbu2gFUxbSE4nGASV+oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBxpRPSOBkjlInAnKU4BZRZvbqkYS3ECKvrwpzP+W20=;
 b=iwaJDK6ewqbS+GwrN6QDVbgWgFNxC8LiKtDIN37jNArUvKOo1VCiwvKR56IPUSX9X53n2b4Kbk5ZoR7fCgzHRIu2MJ5ny+bfRgSQcsGm9DRi5sbgUI/Y+/JgteifNHC0rnS8DGhBqdV/fDQBr379hEu8ABL91QAKqT/91LNiXiKk16UaUATWVC8haYJ/KdNj7OzTr7cZFO2ip+lPqoakk+RzDvcYFjgEaF0xHh3gDqDGxNXtBeLHxhlBDuaASgn8DEuZU3PDmrHOtpOGheMm3uWAFOFBAsT/vLc40nLAn4Xc59n13UahYdo6odvBZpTsz8Z+7ZEeaTAa14ZaaH2mrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBxpRPSOBkjlInAnKU4BZRZvbqkYS3ECKvrwpzP+W20=;
 b=ZVLfhKdIzeaWP3vcn1H0cy0WTWKGhvDpbOxt/OFoG1WEovr178AMW2BCWlyhWTWjETGmUPpGg/ZKqSaSJoyH7aXYKccLSi6IqVbpAheJNMJGubXHdvOU+qRW6G5IwRoArhd+vHATLOJYf7xDmac1Jul5t7g7oJcnTmqssHA8Oh8=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 CH0PR10MB5099.namprd10.prod.outlook.com (2603:10b6:610:ca::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.9; Fri, 5 Dec 2025 18:12:12 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9388.011; Fri, 5 Dec 2025
 18:12:12 +0000
Message-ID: <2b0de566-0602-4a9e-9c5c-b947617f684f@oracle.com>
Date: Fri, 5 Dec 2025 10:12:10 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] KVM: VMX: configure SVI during runtime APICv
 activation
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        chao.gao@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, joe.jin@oracle.com, alejandro.j.jimenez@oracle.com
References: <20251110063212.34902-1-dongli.zhang@oracle.com>
 <aRScMffMkpsdi5vs@google.com>
 <72da0532-908b-40c2-a4e4-7ef1895547c7@oracle.com>
 <aRZKEC4n9hpLVCRp@google.com>
 <a3d1407c-86d6-46d4-ae96-b40d7b26eb34@oracle.com>
 <aTJAVx7C3vuPDgkm@google.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <aTJAVx7C3vuPDgkm@google.com>
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
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|CH0PR10MB5099:EE_
X-MS-Office365-Filtering-Correlation-Id: f50be566-05b5-4ed4-1b87-08de3429d016
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YlRNcDREK0o0MTBUbHV0T0NXMnc3aW56UWluMXM1OE90NUZCVUwrM1l2OWM4?=
 =?utf-8?B?QTdjNVZFck56ZDdUU3hWYzJYOGhCdjhFMVZnQm9ZVkxVVmJ0dG9DMEptS2li?=
 =?utf-8?B?dVFnUU9QWFdYTWR5bzZ0V09TSGJuSkZuc09vMmh3dkJ0UTFQMGhFQzN5NFpO?=
 =?utf-8?B?cDBqOWlSODV1V1ltbk05NVo1VEFSQ2p1dVMzOGdQS05ZY2E2cHEyT0s4NWRw?=
 =?utf-8?B?YTM5RisxQnh6d3lHZXFQTDJkZ05hMFRWYkNweGlzK1lRL0dmSFBlbHlzVjFw?=
 =?utf-8?B?eEUxUitLU1RodjhscjdMdms0SDE5MHA1c2xsd0lVKytXdUxjdVFSVUgzUGs0?=
 =?utf-8?B?aGRLUGc4TTBwV1hkREVnOWdKTGlFVlg1VGxyWE1pSVN3T3VFUXNpa3lIamxL?=
 =?utf-8?B?ZFhBY2tlbTBOTEl2MmcremFwK2E0aTMya252Q3pGRWY2WlRaRTViL1ppQS9z?=
 =?utf-8?B?Q0JnUUhWWjl4YlpiNVkxUnVrdjFUQWNpTmZIbUNXMTRHS3VtNEFvdnlsSyt4?=
 =?utf-8?B?cjQvcmJtSzVobUNIMmhqRzZJWlordSt3SVJxVnRDcDJFOEpoa0ZuRDVLUW9s?=
 =?utf-8?B?RzkwdUM4Z1QwazlQWnZtanRHRnUrZHFTQm9kYWF1RWpHbXkvVGo1eG1RMVRZ?=
 =?utf-8?B?RG95b0JlZ0E1T3Y1bE9PU2lHQkd3ekNObkNpOHIyS0t3N2lwZ1gzdk9vb214?=
 =?utf-8?B?TEU2UG1IN1IzWTZhNFZyUk1xRnVBZTY2WkdhL1dHMEhZWDM0SUFEeWlVd1Ax?=
 =?utf-8?B?bmVHZ3IvNEU5TURNd0VNcWFwZEM1ZGs0aml4dU9HaXcxOVlDWXNYczF6OWdT?=
 =?utf-8?B?WnhPOENKdTZKSk1BUmZzUEZDOEt5OTIwQTFZdnF5aE1XQmdRSnhqWlpvS3dx?=
 =?utf-8?B?VWVuZ1NsaFZHYWVDeEVSTWc3WE5GYU8vZUt2Q29aTHRGWTJUazNCaVozMlgv?=
 =?utf-8?B?WDM5RE9UQWlRUW12T3dBemFBQ2FiOEdVV2FqYjV2WmVoYWkyYUV1c1BuRTVC?=
 =?utf-8?B?MUdhZFYzdTlWTElmYTlmbVdLZWIrNjRpYmtzOFNQRG5MbG9jb2E0REZNVDNQ?=
 =?utf-8?B?V0pHRjhtNURPYlRyak1FSHYwY2dzZDg3WVVLdnkzLzYyY1k1RlUzdzYxcGhy?=
 =?utf-8?B?UlRLVTJkTUxUWVlRcHIrc1F2TEN6aitReGZPWTUwVlJwbm16enVkTEZ5NFcy?=
 =?utf-8?B?L2FFYmJHQ1drNEdMeEdKMXdIVy9oYnpYZVUvSDdBWVNBQ1hUcUZnUU5DVC9E?=
 =?utf-8?B?R2FLb250SEVKWTZWVkdZY2t6NEt1Q1JxWkZlck9qWDhISFRNYTZzM2p4NXdP?=
 =?utf-8?B?NGN5RGh6OUxlcG5NbFNWclYxQ2VvbUE1Z3I2bWo1ei9ZNHVpSVUrQ1dNVVBW?=
 =?utf-8?B?RGw0V2YxSVRPeE1wQzdNbjBid2NNVTVzVDNRUHppUzEzcFZLU0xuUGRpWHdy?=
 =?utf-8?B?bTZWaENSV3BhL1JMTUk0Y3FlV2M0OS83VUJrZk12L2FPYjJ3QVEvNUFRNjQx?=
 =?utf-8?B?QUxlRHB0RkxaRTRVYTVDMGo3QWJtTnMwQ1RPeW9Halp3VlFpRHA3bjJqdjJo?=
 =?utf-8?B?Qm1YYlB2ajdaa3hxMDJnT0FVVm0yRU8xNk5JdGNlT0twTit5Yzd4Q3htN2Na?=
 =?utf-8?B?cEN0ZUhPUk5LdVFmNjdQelh0eC83UGJoT3FrMWFmdnFJMDhJdng0TDNHN0Nn?=
 =?utf-8?B?NDdZcjVYcEFDUSt0MWYvZkRKYW0wQko1dEJsalJNUkM5MVFpODdnSVNBOVF6?=
 =?utf-8?B?bWtlQ0tMakE1VE5FbDk4a0VUdVEvLzhyT1FiSEJ0VGJlb01ISEI2bGpERVRj?=
 =?utf-8?B?YjBhOEwyU1NnSDNTY3RoRkJ3TGZSV0NKclJiRU02eHhySTR5NS9idVdHaW5L?=
 =?utf-8?B?N3ZHUVVuUldLdWRKSHBPUHF2ZmlzYUNsMzZJY09neDBNbFo4V1Q2UjdBbHY5?=
 =?utf-8?Q?QM4SMXfJ0JIeInucRA9rN8GDN383phZQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dzdmbHdIeE9tZVNleXAwTlVjSmRNcGpUY2tySndlTGFkYStvYlBRd2RodjNq?=
 =?utf-8?B?eEdQR012M2N4TVJOa0FONEJtc2ozSE1RdlpLVkxtaVd4aTRYU294aUh0Q2Nv?=
 =?utf-8?B?NnNVQ1k2OExFY1BCZEZWa0lQNkI5MlNSZ2hQSFNzTjZxV2paM2YvV1VGbHBr?=
 =?utf-8?B?bVg1cXdjK2x4akVMTDZ6K2l3UTR5NXh5d3A5bERTUEQwUW1KVk1vOTRORWpG?=
 =?utf-8?B?RmRpZ0gyWWE1SmIzQzZHdzB3dzVqRFV4Y251SldFck9QMmFWbmVnRjRQMW5i?=
 =?utf-8?B?cWlSenpCcGs0MW42bjBiZ004Q0N5VEFBeVk3eG1rNnpkVGdURDFIaHFWVXdI?=
 =?utf-8?B?NC9YMEYzUGQ2c0ZFWVhGUnJkNGh2UDdCdU5LTXpqSG9XZ01IeVlvR0dRaUo5?=
 =?utf-8?B?ZXVTR25TTDFJeGJQU2lzcmpCNE1OdGRNTGtxQW5FQ1hRRkc5ZjVEK3phNGli?=
 =?utf-8?B?enhJK0hmMUFBNTBhQmgrNFczZnBySm4vRWh5Uk1KZkxVT1daVmhYeVQzSGYw?=
 =?utf-8?B?NjlIRVRVdWpPTHhhSmp4VWQyUEZKa2ZXRUwybjFicHNUYUJDMCtTZDdsLy93?=
 =?utf-8?B?K1pjaTR6MHc3eGVyMHZhWU02NGNEcjNxdmNBNzljREE3VGhSdmZMUC9SNW1k?=
 =?utf-8?B?K2NVZTBHc2JST0gxQnZ4T0k0cVdLNWE2T1pLVEJadDNnK0EyRFZlTUc5cmpU?=
 =?utf-8?B?U0xyQWNjUll4QUpNajRpNi9RZVF5d1pCSms4aHpvSDZHRHFaWDE1VDNKSHFJ?=
 =?utf-8?B?MUgvT0RUeTFVdkRBdndyNFlKYjd2Q3R5V3pOTGNNZ1VrSlRoMjl6WGNSNEVR?=
 =?utf-8?B?dSszSEVPVWVuM0F0TyszUnFpK0xOOS9SUEJVODIraFltVmdkL1hacndTNXJ2?=
 =?utf-8?B?aUdwNWpHRmJPbndXeGVJM25LbVNsd2dHYVlJTWk1K0JQbS9vQ2F3dGR2TEZQ?=
 =?utf-8?B?WDlvQ1JIRWhNSFhCRUI5RE1qRFVTWVpXZHVMcmE5dGwyK0pXdzFpaFF3NVAz?=
 =?utf-8?B?dW84Mm85MFp0Uk9TWkJyd0ZxZ1pMNTVxYkR1NjdzQkRMNWxuYUxRd0N6OXMz?=
 =?utf-8?B?blh6WmJUdzkwWE54NEEzdzZLWnlwMG1ESDRuYmw5YzlVV0tMS2NaNHhPSmVp?=
 =?utf-8?B?YmZZb05hWXFObTNQZDVIbnRqNU9Xc1Vwc2VsS2ZVOUNPeEVLNDcwN0pQOEZW?=
 =?utf-8?B?TytvZ2RseXBCQW0ydzJKSGtxZmlMTzVrdDlnMWRGdFdNM1VRQWFFY3FqS0FH?=
 =?utf-8?B?bUZjakNJeXd1RFJ6Qkg1OHlqd1BGQ0lGLzFGc090eEduQ3ZzY0JyY0pnalB5?=
 =?utf-8?B?NksrWjh5TFo2cThRUm1ZUFVBRmFmQTNKY2h4RFBLZUhhNTM5aTJIcWpFVGI3?=
 =?utf-8?B?MkRqZitmS1dOeFpYUS9yZUM5RnNOMTAvNXcxaCtOL25NL2ZmcHBDaDl2R2xq?=
 =?utf-8?B?Q2hJNWNVanJLdi9VU2gzMEd2ekc5OUxCUi9SOG5lSEpTNWlUNWYxRjRESWda?=
 =?utf-8?B?VXB4cFJydGgwTnpHaUFOdjRaZlVJTkJqZ1lTRElqLzdoMVZzU3VpeEF4a0NQ?=
 =?utf-8?B?NGZIZE9OSHE4V0lGQnljUE5tWXMrcGEya2RIMm0yWWErU2NzdDFMNklLem94?=
 =?utf-8?B?R3dhVEpHQTdVdUNhWVRFRUxqQUZGdTJoTlM5NXl3S1BUaGwxZzBQaWs1Zmpi?=
 =?utf-8?B?Y0FMT1NLZFEvYk5EVG9tL3YwWkNGOEVwS0x2OTZVbE9Vd2dVbU4xdGR0VVBC?=
 =?utf-8?B?WXlvZStzMVY3aWRwWW1UZmg1RnBzR3E3b3NNckt2ZXl3ckxiTkRwclFLYWVH?=
 =?utf-8?B?U1FtVi9pQVdRclNvR0dnVmlieG9yREdxRzJXNVhmRDFqYlp1c1haMng0eTB4?=
 =?utf-8?B?N2RqWUkvZjFaWUYrVDd4ZmZWOTFtZGt1Vi9VMUVNTjJzVlRyNDUyeVI5cTJr?=
 =?utf-8?B?UEdKVWlTWnlBVWxlbXJUQWswa0NXVEpicndjRFZEMkdyMWJhOXVmRmdSdWxL?=
 =?utf-8?B?eUIrZE5jK2tONG9RQ3k2R1F5V3VqQlNNUzBvTVRTbGlpYWc2Z3FId2VjNXh2?=
 =?utf-8?B?VlhmcHFlSndKcjJYaWxxYXUrS0lIbnNZOHJ0MU41dTZzbGRDZzBRa3RGd3F1?=
 =?utf-8?B?TGtQRkk2SUxydUZLUDUwWkk2cEZ2UVIxc1Z0bXhDdkVCMTdUME5BTERiQzlS?=
 =?utf-8?B?eUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CB79/hUmeolgiWlaUELvG9C+wFGeJVs49kuxRvIcr19MSz80ECZTl4l9+1Kxc3C9Gw1v/cwskE+rHoqh/o72x4tZ+l6br0GaKbIer7GlYK9ntar5nAdB1k2cOooNZ6mR7UhaMCZnZCxabznGcbg9rGAudqVcHISRiJzpV56TB0lpQ+DUCEyOObkZmCmHX76sM+2vsQnpIlaAOTHv47zZI//pd/2konAiYV8NOc8oI3VOpMWO07e7a31e4f5ZWF9UioQbmuQdVBJDTJ+YZho9jUugmWQKD993wkZIrQEKLR5JFEX3xsFb/jxQzMRtdJwgko6aJWQauSWLhK5g3s1MdoaDQXU/gcFMjfqzjXRFhYL9fuGNFHDpB1CKD3pkSaht54tZMnUXzlBwuPZiPwE/CrvgpZEasPkSnAiOiPtyaJ/gJ8lUsz+nCDT7GPZZP6jZj+EYpEuho0RUqEHwVMt5z9UjS6cAYyTG8JD/MwjqvASP/ua0TneC6+gX2zjhcozs9LqaUi+HvOVZlgjAQmpR9si7s8TgGxof1Bb3wVM7fDIkMD62JEyXVN5YC44iyFFw+wcvNmCqCrozc15kJHV91e3pi7rgKcpf2OfHKRpueBI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f50be566-05b5-4ed4-1b87-08de3429d016
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2025 18:12:12.5133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rwb3odNNKoVfnPOKLwonos9yvwWeiCfu5xnJp1DJ8fjYoKCcvptMLr5FRz9+JdUlTHo1ww/M4p9sIZgj2tYnlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5099
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-05_06,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512050134
X-Authority-Analysis: v=2.4 cv=QMplhwLL c=1 sm=1 tr=0 ts=69332081 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=LFCA6eD9qDATOFwwfWMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: nlLVdf_rVM5NMTCdqkegArgpoLSVXp1p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA1MDEzNCBTYWx0ZWRfX9V3MT3fJpN0C
 QNcfe62LIlZZQBguwfAKGxMUrq5hHgIAJV7D7SeoI31M/M7zON3YfHf6usT5/0fnfmqiL4k22uk
 decljH+XFAFXW1vD9YaZxxXRBWhWq4YYNMC6BhHfipYiughIlPblxBUla9W/gxENGetyxYJyqQG
 aNTogMi9roQUVrVXMClOu3IpTGDF2EF/KUgl+C/WINcSwq73om8vgP1Z2W4rscunbs6XKfYzfCN
 05ZzmPHhnvfX/PMYd8cDM5d0/Ir37jvUn2DYG0eJUu091NRqhW2YHEf/KnXxPgOTxI7j1+/1Pg/
 9yQ0M5KOR3h/Jry3568obUtXcmv328gbk77WUVbO0xsr4BEJ/QUBjj5fa8N9QNNUaraMUlNAwv4
 qUP0dkjSXpuBqSHsN3IFEBFmlqrzPQ==
X-Proofpoint-GUID: nlLVdf_rVM5NMTCdqkegArgpoLSVXp1p

Hi Sean,

On 12/4/25 6:15 PM, Sean Christopherson wrote:
> On Mon, Nov 17, 2025, Dongli Zhang wrote:

[snip]

>>
>> 1. Take the approach reviewed by Chao, and ...
> 
> Ya.  I spent a lot of time today wrapping my head around what all is going on,
> and my lightbulb moment came when reading this from the changelog:
> 
>   The issue is not applicable to AMD SVM which employs a different LAPIC
>   virtualization mechanism. 
> 
> That's not entirely true.  It's definitely true for SVI, but not for the bug that
> Chao pointed out.  SVM is "immune" from these bugs because KVM simply updates
> vmcb01 directly.  And looking at everything, there's zero reason we can't do the
> same for VMX.  Yeah, KVM needs to do a couple VMPTRLDs to swap between vmcs01 and
> vmcs02, but those aren't _that_ expensive, and these are slow paths.
> 
> And with a guard(), it's pretty trivial to run a section of code with vmcs01
> active.
> 
> static void vmx_load_vmcs01(struct kvm_vcpu *vcpu)
> {
> 	struct vcpu_vmx *vmx = to_vmx(vcpu);
> 
> 	if (!is_guest_mode(vcpu)) {
> 		WARN_ON_ONCE(vmx->loaded_vmcs != &vmx->vmcs01);
> 		return;
> 	}
> 
> 	WARN_ON_ONCE(vmx->loaded_vmcs != &vmx->nested.vmcs02);
> 	vmx_switch_loaded_vmcs(vcpu, &vmx->vmcs01);
> }
> 
> static void vmx_put_vmcs01(struct kvm_vcpu *vcpu)
> {
> 	if (!is_guest_mode(vcpu))
> 		return;
> 
> 	vmx_switch_loaded_vmcs(vcpu, &to_vmx(vcpu)->nested.vmcs02);
> }
> DEFINE_GUARD(vmx_vmcs01, struct kvm_vcpu *,
> 	     vmx_load_vmcs01(_T), vmx_put_vmcs01(_T))
> 
> I've got changes to convert everything to guard(vmx_vmcs01); except for
> vmx_set_virtual_apic_mode(), they're all quite trivial.  I also have a selftest
> that hits both this bug and the one Chao pointed out, so I'm reasonably confident
> the changes do indeed work.
> 
> But they're most definitely NOT stable material.  So my plan is to grab this
> and the below for 6.19, and then do the cleanup for 6.20 or later.
> 
> Oh, almost forgot.  We can also sink the hwapic_isr_update() call into
> kvm_apic_update_apicv() and drop kvm_apic_update_hwapic_isr() entirely, which is
> another argument for your approach.  That's actually a really good fit, because
> that's where KVM parses the vISR when APICv is being _disabled_.
> 
> I'll post a v3 with everything tomorrow (hopefully) after running the changes
> through more normal test flow.

Looking forward for how it looks like. The only concern is if it is simple
enough to backport to prior older kernel version, i.e. v5.15.196.

> 
>> 2. Fix the vmx_refresh_apicv_exec_ctrl() issue with an additional patch:
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index bcea087b642f..7d98c11a8920 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -19,6 +19,7 @@
>>  #include "trace.h"
>>  #include "vmx.h"
>>  #include "smm.h"
>> +#include "x86_ops.h"
>>
>>  static bool __read_mostly enable_shadow_vmcs = 1;
>>  module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
>> @@ -5214,9 +5215,9 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32
>> vm_exit_reason,
>>                 kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
>>         }
>>
>> -       if (vmx->nested.update_vmcs01_apicv_status) {
>> -               vmx->nested.update_vmcs01_apicv_status = false;
>> -               kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
>> +       if (vmx->nested.update_vmcs01_apicv_exec_ctrl) {
>> +               vmx->nested.update_vmcs01_apicv_exec_ctrl = false;
>> +               vmx_refresh_apicv_exec_ctrl(vcpu);
> 
> +1 to the fix, but I'll omit the update_vmcs01_apicv_exec_ctrl rename because I'm
> 99% certain we can get rid of it entirely.
> 
> Oh, and can you give your SoB for this?  I'll write the changelog, just need the
> SoB for the commit.  Thanks!
> 

Sure.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>

Thank you very much!

Dongli Zhang

