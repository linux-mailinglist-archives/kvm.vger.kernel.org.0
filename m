Return-Path: <kvm+bounces-49085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8F3AD5AE4
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 17:44:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E03DF18856F8
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C9541D130E;
	Wed, 11 Jun 2025 15:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qnm8r+Kt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AVtCyEMx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016BE1C6FF6
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749656500; cv=fail; b=NAJCc9vy3Pb9bQWwtSa6Y+JbCOfAUYvjm7eter//mvJSHPHyEYU7dRdt9buvGyH4ZlVCnhkbDJVubBFIhkfyk4waZVdm90qpnorG3UHoWGDAaHCgGl5cVIL3UUddUEi917hpyN+XvB+0aPAL/wjjvCRSSD5NYqRJu3faz8CPiDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749656500; c=relaxed/simple;
	bh=KWbR1hFbN61Yh+hrWQL7SuC4F89dtwM9Aw7JslxZwU4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BZi5bY0OLHYan4Frfua3zk0lcZWZVETWNl4s+G/MFPI9/6uq0TtuCzzsotlOFcgyIxwVbAF8MZ7JvZD0POgvAm5gLKYobmi5ur/21jnLdM/jpBvDRzW3UilhKXV0Qwbiq5PD2ntiyhoOEe70gXrKe+BcIGfOsgfhv+NBjAJzSKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Qnm8r+Kt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AVtCyEMx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55BEfW4K016550;
	Wed, 11 Jun 2025 15:41:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rY6ehxaWlilMU4FX5ks0c+MvtEvKQZR+wA50TguueAk=; b=
	Qnm8r+Kt+fDmAK9YelR8O8pt5ZGABtscnLy109G5WVoKKqbghAeFCY+qRmSglnis
	d3qKN/FJuyX2noM3xGnTBEB776xh0EJU4gDIwxh/zcDI83CDqYcspl3L/VFSLt7M
	4HmuOG18I4EFaN2ILq4ieAfnVYlbb8ph0A0Ae/hA8dz9nCCHfSBAyD6Hu4s5EWSR
	FK60J+1dskWgtuWHcgoZyZhBR5XYmsO2F7ZsYhFbdPE8qCV1Cs7mIIduVyVrvcLZ
	2F79Z/A+dtc1Fgb1G1vwpqa/m5AHuoxZQOLU5t7AQQ+uGJ9wF2mu3X9tKjyJRtAd
	25j2z8boLYtko3ULyE5ebQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4752xjyap9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 15:41:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55BEehHl031998;
	Wed, 11 Jun 2025 15:41:32 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011046.outbound.protection.outlook.com [52.101.57.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bvabv6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 15:41:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w3i/BbvY7Q1OjVugcAxOZ5CcYi4tWaG8i37HMjNR89tKR2A6ZDu65ob6Cemi8v9JuOJB3r739L9K+2RlvPCoxmTtR092kRHlCD5mNBB7+zqtfZhAnl+itv14fqHea314fEiNjPl3OTX2HRxjVLmj9YuNvRGmiqLucLECuMyldYtyyvHvUvFVpeoyUx5Ta1FqlMIkD+ww7VJp/TcHxs1ZRGpdlXMtyRFTPf4qjPGj95+02DrAT1D4jG7GWLIsFLGq0Z2D743mY9qXEYk2UUSYEKBtNIPCwOyjCI9kaDZl5jxJdoIW+OrAWiaTui9tYOGQNwi5XF5rRBozZEwNtH2DvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rY6ehxaWlilMU4FX5ks0c+MvtEvKQZR+wA50TguueAk=;
 b=mQXGvcBtsshYcOIBwM3KZam6TNqCSLpBT8WPQM0AWYzRtdnMGSgLl4yJmO9k2CMXJmpo5Z7DkPymS2v9JqidLSOXb9bvadupFgb5XMrtKP/f+TK0IKGDjubyTLMYwiriqV6A8OHRYRpEaUKUfJh9omPg5YEeRK1zUMcPcW6hs2YaGZ55+GqXtOQ/g9+PLHHXVXD4MiEH/wrvgtznbtcGorRVtkUMZVBF3XpuyA90ZXR5IfuKg3sdW4UkO0s3u6otjutx0l3hRmxlrzNb+7BnGKSyQNtBi5zMF+NJdB9DeJasmUs1HLJh4myi5qyCz9t7XBnbgqZAEvZYFIZHZUksXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rY6ehxaWlilMU4FX5ks0c+MvtEvKQZR+wA50TguueAk=;
 b=AVtCyEMxaxlVnNJvGNSnaje2q3iGMvm1WxycllbSWq6D3tay5hnoTZTdBuTNrK+I3wAmKiv1vShA8ITCb2SPTuHGqSA1UgtUCdSlS0JwPtrdjR9Xk/f0t6FYuTfoMyI/q1YnE5pLXMgD9Ju9Dlw4iJwT8W3kfWESvszKg429coE=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by MW4PR10MB6629.namprd10.prod.outlook.com (2603:10b6:303:22e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.30; Wed, 11 Jun
 2025 15:41:26 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%6]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 15:41:26 +0000
Message-ID: <47906f80-d896-4839-bb31-2d3fcd876db9@oracle.com>
Date: Wed, 11 Jun 2025 16:41:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 14/14] x86: Move SEV MSR definitions to
 msr.h
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>,
        liam.merwick@oracle.com
References: <20250610195415.115404-1-seanjc@google.com>
 <20250610195415.115404-15-seanjc@google.com>
Content-Language: en-GB
From: Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20250610195415.115404-15-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P191CA0014.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::20) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|MW4PR10MB6629:EE_
X-MS-Office365-Filtering-Correlation-Id: e7891a97-b82c-4550-ac53-08dda8fe6cdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c1ROdVJEcVMxNFJLV3ZkZDI5S0w4TWhISmR4R0JzLzljTGdHSzNwdWFzQ0Jm?=
 =?utf-8?B?WjlCeEJlaDB2M09TVnNGeW9udnVGOWZ3UkVoR2RiTHNHR0NmaXQ4L0NyS3lW?=
 =?utf-8?B?eEVlSzVLU3I3a0dlaDhwL2ZzeGlYYnpnSG1WaVdoTy9nV2ZOaE9zYWwreEhH?=
 =?utf-8?B?SnFMSjNUcmxKWnhxdFFWUWV3eXFvYVZlT3dXN3hST1BBejFzaTRtRm1YcWRL?=
 =?utf-8?B?U0IxVVJCM3hRUkp1dnBWVUdCTHVmczNiVnFJdkVldG1COW0vOW1LbllmR05J?=
 =?utf-8?B?TmZ0b043UDM0TlNJTEY1bXFGUUdNbksvK0VlbytkVXFBb29WL3NVZHg4MWp5?=
 =?utf-8?B?Njl4TUlld0xFdTdOOU1uVWRLKzNESVlXSjFsNFpTRXU5Q3hMUkFXRnE2a0Iy?=
 =?utf-8?B?VTdSc2diN3JUOXRCdlVEU2Uwd0hheVZyUUNZV1A2Q2xTUlZBQWhaWC9hZTdo?=
 =?utf-8?B?T3BUeVZ2NkNNSWdJd2szV2c0MGxlSUFBTWNwUU9TRVYzVHNiYmFXbUdnQUdj?=
 =?utf-8?B?SThEU0NtZ01mb21QYi85Z0dsNTRmTGY4NGsvT0UvdVREOVhBZGR2dVdNZXdy?=
 =?utf-8?B?SHlUWE5wQUtmUVNPc3lRazIyWWhPZHU1YUFKMEtwbGVJbjFNQU1BWUJ5Mkdv?=
 =?utf-8?B?Ujl6OEJrWGR5Vmxka0FEelI1dXkwRnVRMUU3ZVZMQncvYTJ0RTV5Y1hLejFz?=
 =?utf-8?B?UVM5dUQrOXNOanNtOEE0RFpsYy9sMnNzT1pvQzIvOGxBeWdReXNNTU96Z0NK?=
 =?utf-8?B?STlzaW9HVi96MzdxMDU3UWt5dFlIMkRZSXpjeEpBdlVpTHV6a0pZMERxUWNZ?=
 =?utf-8?B?RW91bk1iNUVaWlRQcXJHSWZ3R0FUMzVXbEtOSGNIemoyWSsvOWtnUjRPTGN3?=
 =?utf-8?B?VEtVRklGczNVNGdOYUo5UVNjR3drL0s1bEtXdTlkUXVtWTUzNVRYSEdUQmtJ?=
 =?utf-8?B?dVRxWkR3dlQ4NFcvOFJ5alg1YUlQK1dCK3Y4OWpMUzIxYUpUR1BkL2V6NS9o?=
 =?utf-8?B?WjlST1pCbU4xNjRDQkRYNkJjWXpWd2ZkRzZMODhGTjIrVW5wbG1hK1dadVlx?=
 =?utf-8?B?UUwwaXNPK0JJbUs1emswMDZlc1ZyeFp2QmtSazBFanlKc2dKRjExemxxZHdy?=
 =?utf-8?B?QlRGSzMzUGFDQklyeHdrQ1d1OGpmNzVTaENtaDlyMWNXMjlaQnJmcFAzcW0r?=
 =?utf-8?B?dStZUHFYVG5ZblRTWnJTd0p4dkRubFBMdkQ0QVJUQllEMlgwOVd6WDFTZ1J3?=
 =?utf-8?B?Q0xNbjJSVUFlOWhIdGpYYUZxNitrenU1UkNSK1F2RDYrL1VrOWd6WFRVaDJR?=
 =?utf-8?B?aHNQRVcvdUV4UktOSktyOHcyRjFtenk4QUtyYndScWJQeE5NTzF2UElmWFlN?=
 =?utf-8?B?WkpodlJldlllY3RCZXJYUXdqZUtmOXhYTWVNVTA5aHUrVTJrOHhhT1RIc1Q5?=
 =?utf-8?B?VzYxUHlCRVU1M0FOVWRHdUJEQTI0K2VKRm4rTXVPQ3JqdW9PZWFQVWM5blhP?=
 =?utf-8?B?aVhQRzBaWnhOSXllbCtqb0RnTXNGRmV6VVVLZ3NiYWFHZlJZeWhGMWRJNSs5?=
 =?utf-8?B?cnFMaUdiNnR5S0RYdEhnNVJrTkcvUnU3d0NqVGZTUFg1Z0pzV01zbkNsYlov?=
 =?utf-8?B?OGk1aHZMeHcySndXcGc5N0laeWlsZ1daQXJJREpHN0xqT29vRDkwZk9CWWN3?=
 =?utf-8?B?NDAzUXJuOHVmdFZpQWhmQ1V1a0R1N2E4R2k5ekhwSUZDOElnOVZ3TlhHaGlQ?=
 =?utf-8?B?WkJhM3pVQ3hkVktLRTgxQk42dEpiekQ4bHRTWjVDM29reURTU1IwU2JKZmZs?=
 =?utf-8?B?R25sTlVQMFpIclg3VyttTUlyZHorRlE1TUxIbmJzTkhiSDEva2hJOENpU1RY?=
 =?utf-8?B?cnVsVXlWaHNvdDFXR0NTVVQyZnZPb2hCdnh4L1NyekFtOUZrcDBlNnBOalhP?=
 =?utf-8?Q?TG/G7IpaDfY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3NDdzhWbUoyajVXQTJZUzhvdjFjd0hyZGZ1UTBlWVg3N05nWVdVbzF4YXh0?=
 =?utf-8?B?WGJ3bTZXYXdreHh6Q2M4NWxVSmI5TmM1UG9JZEY3R3ZwbDU2YXBHV0dpRlM1?=
 =?utf-8?B?N2huVlpZa1pPSkJUY2ozbTVRQXQvWnBFdGVHTGVKU3R0WmtzbDdxRkdUL25L?=
 =?utf-8?B?L3NvWDcxRFF0ZFJHWXZNWVBsZi9HMzRPT2cwZXcyL2RQZWIzb01VUHQ3UHBV?=
 =?utf-8?B?dFA1VFkrYlliWXNZenRleEV3bE5IaHZwTklvZk1peFJoWWJNandHOWEwZStt?=
 =?utf-8?B?N0NiMkxIZlBKTHV6RWJFNnozT3Q5U2I1Ukd1bi9LVjRpTDlqeVgvem5DWVRC?=
 =?utf-8?B?MG94YVU4a3AraHYrdk5zN0lSTVQ0V3liMHgrenFIaCtONUFXaGNUQlVSZXNs?=
 =?utf-8?B?dDJ2Mlcvam0wZEQvMVdKNW9YeXFYWFgySnVQc09kaU91RVhKZUNjWHdQU0tL?=
 =?utf-8?B?WE9ONzBZZXFrQWNhdW16ZUx0UFc1Vnp6WHd4TkpMVWNsUjJlOEJlZVg1M1Vx?=
 =?utf-8?B?WkwrWHJYR3ZJa2t3czRlOHBCRWZnYUZsKytUSmxYTEc0dFN3OFg1TmJ0djYw?=
 =?utf-8?B?MHY0SVpibUFRdzlzOFdFVGQyNEN5d3h2cFpHb2U0QUdIZHV1eTJRSXRRQUVn?=
 =?utf-8?B?cFViZlJuYTBaeWYzQkhVZmlwckU0aUhmN0dCSU1aNEloWVpWNmI3cXBaR3RL?=
 =?utf-8?B?RHNOaWpwZHQ3S2grcnRkaURDaEMyQmRmVFduL09TM1FLcUdYcTI2S2o5SGty?=
 =?utf-8?B?MUoyVmZrQ1NpeGVMV05rU1QydUNjZUtWaG9rRjNSdnViM3dLNGJ6K3pvM0dX?=
 =?utf-8?B?NHArcTE2UFhxTGQ1RG1WODUrNzBlR1REQ3UzV28zUzNYYkFzaVFwTjZlUEZX?=
 =?utf-8?B?eGlwLzdRUGhNeVlUQUx3aC9FcllnWkdtOHkwMlBIMURBVWJiK2lQQmI2b1Ni?=
 =?utf-8?B?d2xVTmRlQWdlbTJEVmN4bjVNUi9kUUg5WWd3Qk9QVVJmUHZGWTB1SThVN0pq?=
 =?utf-8?B?MDFZbnFuUXBWWFZ4akxRUkllZUdZWnNLaHdaRHNBTzJUbHRLMTlYVHJIS2ZV?=
 =?utf-8?B?RVVSckl3Z1pHU3pneUxBT2Z6eFA3VXZUSDNEeTJKMVZpMEdFWVd2dVBxSnZR?=
 =?utf-8?B?VkswRElCVHN4QmtZQ1RjdEIwZGt1Qi9tUFF5dkJpYk5RbFE3SFNvTGc3Yisy?=
 =?utf-8?B?ZTdnRDVvejkzODR6ZmplWUxLQWFQYjVwdEc0L0JtcXBHbG9XMk9vYnBqZnFl?=
 =?utf-8?B?SVFtdWo1ZUdnWWRVd25oa0VSbzZiajlFS0k4ZGt3UDZXT3FLdHFiNjlwQVFR?=
 =?utf-8?B?NkxNZjlnMUJDK3FDYU1ORWIzbHk2eGZFTjhiTnMzejlJTUVxMTdoa3hZQXZG?=
 =?utf-8?B?b1RFZDFzSW9nNkp6UElSVFlKaGtpWS9BZlR2NFo5SmdCMVhXdGtpVFlBdWFx?=
 =?utf-8?B?NkRPMjhmOU5DUTRaNzJZbWFLMC9mNmY2ajFvY1oxMndmSC9MajVyKzJHL1Rm?=
 =?utf-8?B?NVFYa3RlUFZtZnJ5RVFPNWRnNzlNOUVBZUU2VGd2cHpISmowQWZ6eWsvM1VL?=
 =?utf-8?B?ODVNT2N6MmJyVXp1TlZWdDhBN2d4L1hNWDFyQzI2RTlVUXlnZnB3SzZFamJC?=
 =?utf-8?B?V2xTcEFGRnlIVlZDZUVPUjNYcVFlYzYvaE9DYmNmYUJVUmtDWVViVW93cTNy?=
 =?utf-8?B?RmlDSHlvcHZ3WVJYN1dsWDNPWkRwZGNpc0tkNXdZeXVNbzBEWXFqbERpZTRw?=
 =?utf-8?B?Q243VVM0cHIvNnJodVZqVjJWMkxKaWltazh6V25RZkNkNXB0eGtub1R0WjVk?=
 =?utf-8?B?cVhaUTJYeGZYcmNBdWxlM1d5QzMvbWZxK1NhMDF1SHlkWjdKZU1NZ3oyMGdK?=
 =?utf-8?B?ZTUvSGltTGN4UEJsbFV1TU5ZR2twWEpoTStIRURHRks0WW5NL3lqeU92WTdi?=
 =?utf-8?B?NUV5cGxMTnJiRTY5azBnTXlWblU5SkJzY1B2SkVhU1hQZEhxZVZsZ1B0VGZ3?=
 =?utf-8?B?a0NHOHdCaFZXUnB4WFptSjZJTFNYSHNyaTg4dkZuVDV2eHBucVZzZm9sWW95?=
 =?utf-8?B?Y2EyNjQ0NDlWaWx3U2pZbG1XcXFMUC9FN1Z0OE1JbjNmL0JrcTFVYkhaNTJZ?=
 =?utf-8?Q?J0nd4iSlnV7SDJNY2bmFJJIsD?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D7gIqb+Yel0S/+gTQSxPsP9pTCfUjH6uq9ao75mt7IUad9YVbZhjB4FCi1x8xYstu7g/7peuleTrUEuRI20TAxtgdyk56PUJqgDgOCO+0Z2mDZJZp/DwI7N0bFTfsWfSxy+rPIDfQcY3nebY6+QOPZLs6HEVO4vRM5fewa+Idofj3KFsH5pSFzzI4Aw5el5Pj0tspvXoIjztP7bPjxIPanxRhqEDaD3dhiKiPuFmxwyiSkVrj6b9qYdBKHtPFUEPY4AZt36/gpcQ/uY77i/EIGZSSfj5Vd9gKy20tPI9P/Xw0rm4HTAqMkrP72/z/Vowb812lgSvKCKLbVbb7piG6vNFIEO3pcB+9KsU2srEi8r9ZV+p0gbzDrs+nksY33+cxytPpWdzmbri+hAiuWFQ44G7ELS8iRTfPKAnicwDdxFzvU3TaMQcuMxuTYdzNYNrk7O9JvnUKwXZaihV6aBm6F6J253CpVhjalUkZ/yNiSxN6li0U3hYCie2LmoXfBLGMKT2xCPem9Xluxs21boa6pivmOv1rbdEX8UmlKOIwKZ9nG12yEVz1+wwEo6fLkZbGZ2LAGx/GBevPmMLjJrKI0X8WiRgIpjzVC66C0OUgD4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7891a97-b82c-4550-ac53-08dda8fe6cdd
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 15:41:26.0251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KiAOepcSMNxp+hxMiqfJjxdYeJCXYcvo3fTs6IAdowfu0IJx07/TbjaaTJuRmba8sqelELO9JdaYdUchHQTh/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6629
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-11_05,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506110131
X-Authority-Analysis: v=2.4 cv=K4AiHzWI c=1 sm=1 tr=0 ts=6849a3ad cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=pZzlKUcM6NCZhvr9rdEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjExMDEzMSBTYWx0ZWRfX8S1exx8WL168 3LPaAnI5MfVVzKd2unusWdnGSsqEcWrynDr2IXWOW0taWIaXFfzXpKP5ya1Qj+677X29P8Hy0tM ObWNSHKBq4BWTnPU5IBp5RvuzWeGOLKsTrk/aOvfCDWmwYNQhxn2da1eEaAgVspijNvroxhrSkK
 5mMtQ97PJfewY3BP8+t6Rdm9HAOwPPbyk+MjuK7EthNEGXqUg4ROrsnXdoLzzThfa+B5yrIjTPH ZboS5GAEfP7IzIh6UTzhWewyunYIczWbk3rfGwqkuaG3EBw3eMueFwjk3mWpEeo/W8ylGTzwRtc pNm4sg108uBwVAIWgGUYaW/DNM9HQNOIJVYORdFwMEGhH73lgrs9p0YXFlq+PxCZxikgN7L8wTB
 LJDp62S/3KJMezHQiExPd3Jykkoyc4ac6F7TOC8iSDqQqW37T7sutm04yB1q6iGirUzPNZpG
X-Proofpoint-ORIG-GUID: q6Vfrg4Mu8_ODbvGb9q7O7ESlaSlXv43
X-Proofpoint-GUID: q6Vfrg4Mu8_ODbvGb9q7O7ESlaSlXv43



On 10/06/2025 20:54, Sean Christopherson wrote:
> Move the SEV MSR definitions to msr.h so that they're available for non-EFI
> builds.  There is nothing EFI specific about the architectural definitions.
> 
> Opportunistically massage the names to align with existing style.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   lib/x86/amd_sev.c |  6 +++---
>   lib/x86/amd_sev.h | 14 --------------
>   lib/x86/msr.h     |  6 ++++++
>   3 files changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
> index da0e2077..7c6d2804 100644
> --- a/lib/x86/amd_sev.c
> +++ b/lib/x86/amd_sev.c


Maybe msr.h should be explicitly #included?

either way
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>

> @@ -25,7 +25,7 @@ bool amd_sev_enabled(void)
>   		initialized = true;
>   
>   		sev_enabled = this_cpu_has(X86_FEATURE_SEV) &&
> -			      rdmsr(MSR_SEV_STATUS) & SEV_ENABLED_MASK;
> +			      rdmsr(MSR_SEV_STATUS) & SEV_STATUS_SEV_ENABLED;
>   	}
>   
>   	return sev_enabled;
> @@ -52,7 +52,7 @@ bool amd_sev_es_enabled(void)
>   
>   		sev_es_enabled = amd_sev_enabled() &&
>   				 this_cpu_has(X86_FEATURE_SEV_ES) &&
> -				 rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK;
> +				 rdmsr(MSR_SEV_STATUS) & SEV_STATUS_SEV_ES_ENABLED;
>   	}
>   
>   	return sev_es_enabled;
> @@ -100,7 +100,7 @@ void setup_ghcb_pte(pgd_t *page_table)
>   	pteval_t *pte;
>   
>   	/* Read the current GHCB page addr */
> -	ghcb_addr = rdmsr(SEV_ES_GHCB_MSR_INDEX);
> +	ghcb_addr = rdmsr(MSR_SEV_ES_GHCB);
>   
>   	/* Search Level 1 page table entry for GHCB page */
>   	pte = get_pte_level(page_table, (void *)ghcb_addr, 1);
> diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
> index daa33a05..9d587e2d 100644
> --- a/lib/x86/amd_sev.h
> +++ b/lib/x86/amd_sev.h
> @@ -19,23 +19,9 @@
>   #include "asm/page.h"
>   #include "efi.h"
>   
> -/*
> - * AMD Programmer's Manual Volume 2
> - *   - Section "SEV_STATUS MSR"
> - */
> -#define MSR_SEV_STATUS      0xc0010131
> -#define SEV_ENABLED_MASK    0b1
> -#define SEV_ES_ENABLED_MASK 0b10
> -
>   bool amd_sev_enabled(void);
>   efi_status_t setup_amd_sev(void);
>   
> -/*
> - * AMD Programmer's Manual Volume 2
> - *   - Section "GHCB"
> - */
> -#define SEV_ES_GHCB_MSR_INDEX 0xc0010130
> -
>   bool amd_sev_es_enabled(void);
>   efi_status_t setup_amd_sev_es(void);
>   void setup_ghcb_pte(pgd_t *page_table);
> diff --git a/lib/x86/msr.h b/lib/x86/msr.h
> index 658d237f..ccfd6bdd 100644
> --- a/lib/x86/msr.h
> +++ b/lib/x86/msr.h
> @@ -523,4 +523,10 @@
>   #define MSR_VM_IGNNE                    0xc0010115
>   #define MSR_VM_HSAVE_PA                 0xc0010117
>   
> +#define MSR_SEV_STATUS			0xc0010131
> +#define SEV_STATUS_SEV_ENABLED		BIT(0)
> +#define SEV_STATUS_SEV_ES_ENABLED	BIT(1)
> +
> +#define MSR_SEV_ES_GHCB			0xc0010130
> +
>   #endif /* _X86_MSR_H_ */


