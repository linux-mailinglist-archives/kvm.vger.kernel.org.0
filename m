Return-Path: <kvm+bounces-63484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F1515C672BB
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:38:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2E0D6352D7E
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27899316192;
	Tue, 18 Nov 2025 03:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cBMe7Yjn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Lqm/brXo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9E219E82A;
	Tue, 18 Nov 2025 03:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763437046; cv=fail; b=IqKEDCVex6NEdCkS51cyq8C4LQ7oc3WRFHrPwcY9UmfzIa0siqNal49/mNa8beKKJnR7iFSW2V9uPgfHeUk0hR6NNtWIxHAgIpJySAXXPloNYtW9+43zf0tVI5wb1w3pvPBlFmPQPWPdUvfAo+Gzl9gI1AILAmrypYzj9FkACss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763437046; c=relaxed/simple;
	bh=OuLl0I4D6Hfm8KM48LjMHAVxH43lQC9Z+G3xT83KxcU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PLA/+QHcSvLUfswg0xc8WLgEnW35fl6/TjDJkUUXD/5J96DfwmvXJj4MvOg/wfkD3mc0nbUF3oMD13/ogtfSN4lWDSv4TczHzLK8GtxlEP1jxPlK6q1YsbfuWJFpODTwGjCxAeWlNiwtAB14BKXgQLtIfUualNgdg3HnBzgh5es=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cBMe7Yjn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Lqm/brXo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI2gcfe031371;
	Tue, 18 Nov 2025 03:36:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/JwQetBvyJHnnTJFu6/PUF29RlGTolEppdli5duTgLo=; b=
	cBMe7YjnMwirwq3N5ea7cgcX3XwR8yq0SNczNVX+yY49MokOqbRv+4cZGLCp7Bg5
	iWPTtrxiOr8Orf8UgxeluEJ5h1vV05OdUoxTHPbyzebDqFqbPoS9XY5dshASpmJv
	C0XCrUFvsPkTQLNxW0w5c/CaIbll0k5aNc7wxHlmLm+aK1dk8xPjjgnJiSwhMrM7
	FBDso5pF1yF+/GNdG6Ob28JzaKVi+MVsTAuXyiMTQc/zW3OIgU6hMS7JDNLfepuF
	odYl9ClBSpLNNZJw+GfJwOdlvZdUCbt4sfD9HPMfqhPgL5Mkpltv0TsGYnMRYYi+
	ECKnCoSTYrjgHSUZ9QCTXw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej8j4147-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 03:36:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI1hwRs036111;
	Tue, 18 Nov 2025 03:36:37 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010010.outbound.protection.outlook.com [52.101.85.10])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyjtcy3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 03:36:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bHg7CrARd4+iCR7Z8gJL1I5tu5L3gMoWZLp9fKnPZLVhNPLMzTATCkTEwnHqfdBtK5UgMF+LJNhDAiS7OanzIdofuRzs4w3wZiNpasTynxksG6PvTGR15Dd8Qv+OPVen+df3usSO/bNfadMgzq8faWTWvrGtljLNWrs6Kff114NFQEt1X41kfhtINY60u7C/THglHZYMDqzjOCS4v6dIkTNOPcdUB3Td55v8VIIuBrOryOiStspwtzGa71112HD+BIoNeNiH8PTViGRzv7ovHYnYjZk0y2T+suPoRifut2brhbjRLO5ANiLJwN2y144EgPZoZlNsPCn8nPvmqFtJJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/JwQetBvyJHnnTJFu6/PUF29RlGTolEppdli5duTgLo=;
 b=hM5eN1DZGwJzHNEzTUo+Qbhg0XkBXHgSWln3lle04oaI7ABn7yuwuQ3K9r6FPBwYG+XHwsJA82wkQ86PpQ5ZxC3IDCa56uBeNmQYqZiJIjqbqtWrlSB9plqLyceNF2CXZHUvxGn3fDWbZ3XNYsFHf7LZCS7RgmSH1M1nDRzpskJ3wBV2A7DxIC5aI+EHspit8Ju7MoxsfxJJC6VQBOQNAqdjX043eVTZjnjCIhQJxhq6IVoRWaGfUCpUNyku/l5ziBHD1SiUEAdT8kpOruX4Ws2BQYQiavFNPT+ejBfDpxZN2V4HerhlAT+7M4nc+V66i5qHQc4NzQCA/Fy6v8NhrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JwQetBvyJHnnTJFu6/PUF29RlGTolEppdli5duTgLo=;
 b=Lqm/brXoUN7b1CY0VzgW+seXu39139E/OGVNfvi8KUBrdqVahvLS6xPASVx4cz65oLUVulqYa6ugnhsGOXVQgI7azjgpx+Mtevb2s1qrOhaTN8XjfxQHZUZ3h5l5wtDC0tAxwTUFvt9o0vk7DIgW92CLBAFX0ptIAIhkbfnvfYg=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 DS7PR10MB5184.namprd10.prod.outlook.com (2603:10b6:5:38e::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.22; Tue, 18 Nov 2025 03:36:33 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9320.013; Tue, 18 Nov 2025
 03:36:33 +0000
Message-ID: <a3d1407c-86d6-46d4-ae96-b40d7b26eb34@oracle.com>
Date: Mon, 17 Nov 2025 19:36:31 -0800
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
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <aRZKEC4n9hpLVCRp@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0031.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::6) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|DS7PR10MB5184:EE_
X-MS-Office365-Filtering-Correlation-Id: 54336878-5e2e-4728-57dd-08de2653ab5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MmI2dmxnUkRFTGJpbFgvYjBNandZSTRXS3Z4a0pZeTdmdS9EVngvNkd4ZVRL?=
 =?utf-8?B?cmxDeXRTVVpJYmt1NUJPS2RmOWdJYVJReGJPeFlQU2RjcnVPcXdSRnBDdnhq?=
 =?utf-8?B?RGdnT1l0OWhKMm5JVmdiNWVjd1M4b3VXQlY4T21qYllRVS9zU0E1V2JkTTlv?=
 =?utf-8?B?YnYwNERJVFZ0N21McmVuRjBtTjJENEtMNnRLZzc0SlI5YmQwMFNJSEVDQ0cx?=
 =?utf-8?B?aG5XeldGb2xaMTFWQmRkZi9xL3Zvc2FqRXdZNDRMOWlYNnQ2V3NZTmxDbXNs?=
 =?utf-8?B?VjJHcE5FM2dWQmpYOFlPNURGN2pnQXQ1VzVWUURhallRWlhQVzJTZ1RucFpy?=
 =?utf-8?B?V3pNaEFJWU4zeVFobEJXaENuVWxkd3VJbWFJY2Fza3JIR2Z0QkRsU0prSEt1?=
 =?utf-8?B?YS9ycHdHSlg4VG5Md2lrbXJrWjBGQSs3ak0vejN0TUptVGhwQmdBbWI5YVdM?=
 =?utf-8?B?dXUrRHQya3FLUTlHbXQwZ3AxcEFlckVPbW54Nm9KWFltWHZUbmY4cnFPeCtC?=
 =?utf-8?B?U0RqS2Z6Y3MreXUrVklGQjZMU1lsdEEvNHFaMkRaNktmN05BV1NnWWpRNEdG?=
 =?utf-8?B?alh0dnVwWVc5WjREejVCZFRpTnBZTXpTZXFxVmdoVSttMUhqRDdzbVpIcTZV?=
 =?utf-8?B?N0tWWXNQUURtZC8yNExaeTV0UW9mQVdrV3crOU85WWx0YzAxNlZuSWliR1pE?=
 =?utf-8?B?QTFRTTNjU28vVG1RZnNWbW9pV1Z0RXdNRk1rSTlES2VpTnRDakU3cCtSRXE0?=
 =?utf-8?B?NUxMR1NHa3kwQkFyVWUwcXREVVZMSkVBVFRHZDlOS3FRVHBQQXBuZHJhT25I?=
 =?utf-8?B?VkI5MGVtYktYQVBCaGVJNG4rUkFUZWJkWlByblYwVzlzQTdqR3RGNXRLeXk5?=
 =?utf-8?B?UEkwZ2QvbEJ4Y1Izd0VLamJuWGlwSkxZVTZvblQrTCtMVk5JS2lCeEVydkVt?=
 =?utf-8?B?SFp6ZmpZZTdkaS9oaGh4TWhHM1FZbGdydlJxSjVlK1RnMlhkRDJDdlJBSyt5?=
 =?utf-8?B?YXROZTE1Y0FEZms4UXlHdWhlNEJaczNJb00wZjNPZzd4bTd3M29YTEtLOEUv?=
 =?utf-8?B?YnAyOXZPZGpUTEk0aUd1NE1wVHhLRHNtWXdnaVpSSUlTODRLVmlxUUpybjk1?=
 =?utf-8?B?MTh4RFFoUC91bWwxQnZwZWd6Z3ZTNjVNK1FPZCtyNGpYUStldVFWTmxQZlk5?=
 =?utf-8?B?Z2k5QkpxaWdlMnpxbTZudk1MM0NsaTA2SVBKMWRTdmR1VVdsZEVLUHV1TW12?=
 =?utf-8?B?cmduWFN5bEhSQjBtWGROTVNncEprRGpiMk5tZy9wZnk3Um1aUENZOW5TSjNu?=
 =?utf-8?B?OTMrTVdpOHhWZHc1KzB5b1pFUmxlejNjNHdVdkJUQUFObnBjN1F0WENPOUVy?=
 =?utf-8?B?b09yRmJ0STNoT1B5TkI0WXJidGhoeE5YMU5Mc0QwMlZwMkJ0QUxVSzB1Rnd4?=
 =?utf-8?B?WUpqSDNSNytRUi9tNE5FbVp3c05IR0ZQWmdMK2g4QmZwMVRpV3RxMDQrSmxG?=
 =?utf-8?B?QVQwTFh4NkhDb3o1L1dnMlZGbkpHam5mNVF0V2wzbkcwTng2YmV5NlNEekI5?=
 =?utf-8?B?Z1Q5QWNkUnRQektLY1N2Qi9idStwUkNydGE4TWJZY1dxdWtLeE5ta2FIK1NY?=
 =?utf-8?B?ZXdmZ0FuQ2tBYVhKWTZtbW9VZGJEMzdKUHkyOEd6ZXZIdW1RMnBTd1RFWWR5?=
 =?utf-8?B?MDFaY1NRRTFQRVQzU0dLRU80VXA1d3NOOXo1cyswMllwMlJGRFJUZzZlMElu?=
 =?utf-8?B?bE01R2hDa25mWkZEaFhhOEhFNzhMUE9qcVpaSWRlc2lmSzZsVVBiOGJqMW5m?=
 =?utf-8?B?TmJLRUNSbVZXSkNnS0p6WXkzSnNuK2NSWDRIWC9KUGFBTmc3YldjOTF4am5B?=
 =?utf-8?B?eFkrRGlKK1M2UUovRDA5UlhPYnBjNVdPVm0vWHVzcU5yOVAyUTNiTE11Tk8r?=
 =?utf-8?Q?CwptQYOl2ckfxzSYTEde3geRaOsmx+e4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGowY0oyZnVIcHdreXA0ZWxVMVJKdHYzNCtJSkhtckdCUXRNNnFFUjJJbEI2?=
 =?utf-8?B?dWUxU3pnc1ZJMzJIQXhDaWRNOVVycTh1Wi9LcXBhUDBuUFJnRXhGdFF6U2VV?=
 =?utf-8?B?MnJCaW9WOEx5SFZRMnhKdTNzTmxGN3lNV2lrbUJTbWFNV0pUWXZ1V1NDMjdJ?=
 =?utf-8?B?bVcvL29qc1h0Z0g0ZDhWK3BDOVZuMExOWDlNaXZtbHhpa0RjR0Q4aEVHekh5?=
 =?utf-8?B?Z3hMZmNTbmdFZ2lCMTdSQkZwYTFWL1dseThtVHZSM0ZRMFVBMkIrREZzb3Q2?=
 =?utf-8?B?YkNYaytOWVN0YkNOc3NnT1FPVlZLbnErN05KY2tJYU1ENERSQW1iRS9hN3BU?=
 =?utf-8?B?dUtERUlPUUxrKzJHdmxoeWpaamJGOGRXa2hjVm1XVlErZ29rcGdyRHlsd0lu?=
 =?utf-8?B?UzR4cnZwdWVtYUZkNXdwUlk3SWkvbTdtWTF3QXExeFRKTGhRckl0cEVwOGVa?=
 =?utf-8?B?QUZWWmlnL2tHcndFN09ROGR1MDVOMWZwRHo0QWtHQm1jbFF3aWdOZlR1bE9p?=
 =?utf-8?B?T0pSOEFhMlFNUHpBZHVZUmF3QUdXSHpibHppdlFZT0x2N2pobmUrRnNtaHJW?=
 =?utf-8?B?ZlZ0S0p3dFBoUS9UQjgybS9PQUFSWXdGMDVsREpJR3Q3NVpYRmNQU3Y4V0l1?=
 =?utf-8?B?T2tWT29iVnEwT2xoOENtcjBTNlp1KyswWnFKVko3dE41cEI3Tk9JYmt6bER5?=
 =?utf-8?B?WVNCc0RRYWN4M2h0d0FtMWRlUmpLZCtZZEhhWnBJeFA3bnk2Qms0dzdyaVIy?=
 =?utf-8?B?dzNQVnBIL0dhYzVjdjBMVHlaM0RicjR0bGZzTWhmWHdNbUJ3TEVGd3EvUTZz?=
 =?utf-8?B?OXdBZlNYRnJZUDNwcmtyeE12LzE0ZGhTQmFORUVvUFlMVk5oZmFSSW53QzV6?=
 =?utf-8?B?YXdLR2U2WVAzOThKUTgyb25EZlNxYThxNGFMM0VJRXNVaVViWHJSSFhZd0J5?=
 =?utf-8?B?ZDZyNXFyWjA0bCtLcG96bFJpYWlzZzJpNENOTEtwaHJWR1UvT0RUN3BlVUlV?=
 =?utf-8?B?eSs5RHdYRG9XVFZHNE1ESlJXWE1kS3RtRGVOT1lJcGNNWlBla3hRRjZpMzBh?=
 =?utf-8?B?aEhHeDNKYmZHbTFBamxPZmJyTzdzeEV6c1pjRVUwb2o5amlqaG40MTY4d1Zj?=
 =?utf-8?B?bHV5SG9OeWVBV29hRTJJV1gyT295QVpWdkR4NDBFSkNKcTMzVVBvRWE1eVhj?=
 =?utf-8?B?RXRkS1B3eXFIZGMwSGh1THdyUEczdjEzSnc2SHpyVS83NWtTUWQ0d1hsN2RQ?=
 =?utf-8?B?b0FqRHZ5bVlhZHR2ZnRKNEwrdU9keHFnMHVYdS9WaGNuNVRwNmZUaE5BRldk?=
 =?utf-8?B?ai8rNDFhUWI3SUhtU3A1SE9waW5FYVZRQTMrN2hXT0JOYjRLZXhYZDJjZjNI?=
 =?utf-8?B?RFpqVElUSStMVmhIRFlMbmdUWnF4N1Fqa2d5LzkyMVIvMi83d2ExUndlRGRJ?=
 =?utf-8?B?am5jeTlmSjFsbXV3L1RoQzczcGNDUXFJa1RaOHBVeDVPYTNuMmFSVDNkelVF?=
 =?utf-8?B?M1htU0dLU3BBM2NvTytrZ3F5VWJsRHMydTZRL2ZvamtQdHMwL2ZnT1g3Smsy?=
 =?utf-8?B?Y1B6b2pLb2d3Q2NFUzk2YWJNS2k3bitLUFlSS2FQVzdpdjl5RHBIRkRlZVNt?=
 =?utf-8?B?b1Boek90Um1hVFZQeFpGT3BUVzJxb3IzdHNDd2Y2V2RyMk9kTnJoRXFlVWYw?=
 =?utf-8?B?Rmd2SGhJVUM4eXhZK2JVa0QyT252WXJZNUIxWnhZcjBUcmRJYS9QTGRwYjdI?=
 =?utf-8?B?UHdqd2xkUFRHKythVG04d0FhWndmbElOZGNjbUs3UkRCQmc1SDAvRTVIZjNC?=
 =?utf-8?B?MTFVVThQSG84OXIvSzhib3kyWUJGOERFZjI3MlhwSmF3VmI2ZWhaMlh5RGRL?=
 =?utf-8?B?QjNSUFFjMVFCak93eFBFVUJkcnh4RDcvWXJiSkdqaGNsVkFXZUF1V3VqYkli?=
 =?utf-8?B?UjkrcG5EVktKak9PSkpoaklCaStVVktPT1loVUo1U1VRUnlGVG9GQ1pVRWxa?=
 =?utf-8?B?SGhwUGVuQ0xaSllvZDNmMW9LQ29BNG0zQVhVLzAwTlE5NGZEc2wvT01LMXp4?=
 =?utf-8?B?QmFzNDJNN1J3Y1hYNVY0bEwyZzZIOURaU0NhdVNnSkpxaXZJRSt4NEdaZDlG?=
 =?utf-8?B?ZlBHSUZjSjRxTURnSWt3eEdNdldUK2lhdGNkRTF4MElVZHJXN0dHOCtkSjJt?=
 =?utf-8?B?L2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ILhRrgOVaEZH4zHiO2PXix2B11r5bWInviL9opAoaTv02ZB8HL/TYlXDtcBvxVvkowM+U8epmnkPZdJQcXfTx3B5WE3UiDkZHwqYvuiS6ahZFeidDWPR99/jn+eIGsMZiPD8aHnRIbJB2Uj6btKdbDAmOiW/2gjqqqXwOuJXy8mBNwPRBtzRLg7EFYj8mSdhI3QZNTdz00+hBQKdvxg53Z83LMMsSsnSzVqhOpcaQVi4EhmSGl6xhuavlI2uG3bBOEOB4J6ZyY7yifOUqg+MVanCrsYvzAGuJXZPhE4y5MVo9g466BVaa30RG+vb7d750qtwdPEEi9mOqTfeG7wi58s+pHe1Zv8Jabo8937RisGGhVvZqkAOem1wy1Mq3r+I8ivAEZHUxw+oTdLY3rRR8mpUSf1yV4kAz6HRRXvVqrw9mbmnb/Xk14n3tSgpYgWMRSWWDKKG7N59M1dngYM4zGyPmy/tLLEAiRb8GH0o6w8DEW826Br6HTxy0jeUjWA9Oe/J+5GpvvjhItNt5qU+AeezYW/KeQhzJEJ6jbE/airaxgMpfZW3Vsv31zLPbDbDyQCj9EouvEkpqHjQ1lT/3DqrhCYhwbfEQAkxGzXjqLE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54336878-5e2e-4728-57dd-08de2653ab5c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 03:36:33.3833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1sCEBxgT2sGSix/61cCpY+Km1TJrEJ8i8AoSofBHpaZ8mxKcuIgRxtGEtYwlXyNBp7ovIaFwfq5c0ztzoL72Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_04,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511180026
X-Proofpoint-ORIG-GUID: s8yf-YPjpRV9pWvb6CZ6Sk0SXmjhlm3A
X-Proofpoint-GUID: s8yf-YPjpRV9pWvb6CZ6Sk0SXmjhlm3A
X-Authority-Analysis: v=2.4 cv=I7xohdgg c=1 sm=1 tr=0 ts=691be9c6 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Vnfp25b-4WvJMoGJZdUA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX2fhBYxWqzE/c
 zznot3zPJhubFKVB11+7dNQx/gmIA/i/dghMvZVQ3XufSXu9B9z1sJOgDZOH7i9Caxv6CJxGweE
 TMa9Ts5gtJutS2LLD3rzBQ9DkWZcVjB6rXZN8+SkEiuvcSe8wE71R2iPYc2zH3RhZAUwPcrIv8s
 Kgy8cDQ2qQXwF6cdkq9anTkKs9jxqaqJEzXMei26m++2H1Pe68rblqmEcS6uyvepa5Wd0TNU8U+
 Y8Y3E07o1BD43VWd0uxAiQBqVqmNPwqvQAairji0BzAN+LQcw23BsPfm0sLnEugElKZ7Q6hc8TY
 88ZrzFHw/z2/kVDtEsravPugUwIK8LcbWnzFR/THUNBHr/jHr77bEdM9RM78nKXEycT13QQNge1
 8evVMT7pADe3sSKxYvuSjbtre1w2GwCb5Dx2va/I/XjxenqPNBQ=

Hi Sean,

[snip]

> 
> Hmm, what if we go the opposite direction and bundle the vISR update into
> KVM_REQ_APICV_UPDATE?  Then we can drop nested.update_vmcs01_hwapic_isr, and
> hopefully avoid similar ordering issues in the future.
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 564f5af5ae86..7bf44a8111e5 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5168,11 +5168,6 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>                 kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
>         }
>  
> -       if (vmx->nested.update_vmcs01_hwapic_isr) {
> -               vmx->nested.update_vmcs01_hwapic_isr = false;
> -               kvm_apic_update_hwapic_isr(vcpu);
> -       }
> -
>         if ((vm_exit_reason != -1) &&
>             (enable_shadow_vmcs || nested_vmx_is_evmptr12_valid(vmx)))
>                 vmx->nested.need_vmcs12_to_shadow_sync = true;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6f374c815ce2..64edf47bed02 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6907,7 +6907,7 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
>                  */
>                 WARN_ON_ONCE(vcpu->wants_to_run &&
>                              nested_cpu_has_vid(get_vmcs12(vcpu)));
> -               to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr = true;
> +               to_vmx(vcpu)->nested.update_vmcs01_apicv_status = true;
>                 return;
>         }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index bc3ed3145d7e..17bd43d6faaf 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -135,7 +135,6 @@ struct nested_vmx {
>         bool reload_vmcs01_apic_access_page;
>         bool update_vmcs01_cpu_dirty_logging;
>         bool update_vmcs01_apicv_status;
> -       bool update_vmcs01_hwapic_isr;
>  
>         /*
>          * Enlightened VMCS has been enabled. It does not mean that L1 has to
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9c2e28028c2b..445bf22ee519 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11218,8 +11218,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>                 if (kvm_check_request(KVM_REQ_HV_STIMER, vcpu))
>                         kvm_hv_process_stimers(vcpu);
>  #endif
> -               if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
> +               if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu)) {
>                         kvm_vcpu_update_apicv(vcpu);
> +                       kvm_apic_update_hwapic_isr(vcpu);
> +               }
>                 if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
>                         kvm_check_async_pf_completion(vcpu);

Thank you very much for suggestion.

There are still a few issues to fix.

1. We still need to remove WARN_ON_ONCE() from vmx_hwapic_isr_update().

[ 1125.176217] WARNING: CPU: 8 PID: 8034 at arch/x86/kvm/vmx/vmx.c:6896
vmx_hwapic_isr_update+0x1c7/0x250 [kvm_intel]
... ...
[ 1125.339364] Call Trace:
[ 1125.342341]  <TASK>
[ 1125.344793]  vcpu_run+0x2edf/0x3aa0 [kvm]
[ 1125.349629]  ? __pfx_load_fixmap_gdt+0x10/0x10
[ 1125.354771]  ? __pfx_vcpu_run+0x10/0x10 [kvm]
[ 1125.359841]  ? fpregs_mark_activate+0x99/0x150
[ 1125.364909]  ? fpu_swap_kvm_fpstate+0x1a1/0x360
[ 1125.370129]  kvm_arch_vcpu_ioctl_run+0x7b3/0x1560 [kvm]
[ 1125.376123]  ? __pfx_eventfd_write+0x10/0x10
[ 1125.380989]  kvm_vcpu_ioctl+0x525/0x1090 [kvm]
[ 1125.386133]  ? __pfx_kvm_vcpu_ioctl+0x10/0x10 [kvm]
[ 1125.391801]  ? vfs_write+0x21e/0xcc0
[ 1125.395928]  ? __pfx_do_vfs_ioctl+0x10/0x10
[ 1125.400746]  ? __pfx_vfs_write+0x10/0x10
[ 1125.405260]  ? __pfx_ioctl_has_perm.constprop.0.isra.0+0x10/0x10
[ 1125.412141]  ? fdget_pos+0x396/0x4c0
[ 1125.416225]  ? fput+0x25/0x80
[ 1125.419628]  __x64_sys_ioctl+0x133/0x1c0
[ 1125.424102]  do_syscall_64+0x53/0xfa0
[ 1125.433954]  entry_SYSCALL_64_after_hwframe+0x76/0x7e


2. As you mentioned in prior email, while this is not a functional issue,
apic_find_highest_isr() is still invoked unconditionally, as
kvm_apic_update_hwapic_isr() is always called during KVM_REQ_APICV_UPDATE.


3. The issue that Chao reminded is still present.

(1) Suppose APICv is activated during L2.

kvm_vcpu_update_apicv()
-> __kvm_vcpu_update_apicv()
   -> apic->apicv_active = true
   -> vmx_refresh_apicv_exec_ctrl()
      -> vmx->nested.update_vmcs01_apicv_status = true
      -> return

Then L2 exits to L1:

__nested_vmx_vmexit()
-> kvm_make_request(KVM_REQ_APICV_UPDATE)

vcpu_enter_guest: KVM_REQ_APICV_UPDATE
-> kvm_vcpu_update_apicv()
   -> __kvm_vcpu_update_apicv()
      -> return because of
         if (apic->apicv_active == activate)

refresh_apicv_exec_ctrl() is skipped.


4. It looks more complicated if we update "update_vmcs01_apicv_status = true" at
both vmx_hwapic_isr_update() and vmx_refresh_apicv_exec_ctrl().


Therefore, how about we continue to handle 'update_vmcs01_apicv_status' and
'update_vmcs01_hwapic_isr' as independent operations.

1. Take the approach reviewed by Chao, and ...

2. Fix the vmx_refresh_apicv_exec_ctrl() issue with an additional patch:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bcea087b642f..7d98c11a8920 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -19,6 +19,7 @@
 #include "trace.h"
 #include "vmx.h"
 #include "smm.h"
+#include "x86_ops.h"

 static bool __read_mostly enable_shadow_vmcs = 1;
 module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
@@ -5214,9 +5215,9 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32
vm_exit_reason,
                kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
        }

-       if (vmx->nested.update_vmcs01_apicv_status) {
-               vmx->nested.update_vmcs01_apicv_status = false;
-               kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+       if (vmx->nested.update_vmcs01_apicv_exec_ctrl) {
+               vmx->nested.update_vmcs01_apicv_exec_ctrl = false;
+               vmx_refresh_apicv_exec_ctrl(vcpu);
        }

        if (vmx->nested.update_vmcs01_hwapic_isr) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c3b9eb72b6f3..83705a6d5a8a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4415,7 +4415,7 @@ void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
        struct vcpu_vmx *vmx = to_vmx(vcpu);

        if (is_guest_mode(vcpu)) {
-               vmx->nested.update_vmcs01_apicv_status = true;
+               vmx->nested.update_vmcs01_apicv_exec_ctrl = true;
                return;
        }

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ea93121029f9..f6bee0e132a8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -134,7 +134,7 @@ struct nested_vmx {
        bool change_vmcs01_virtual_apic_mode;
        bool reload_vmcs01_apic_access_page;
        bool update_vmcs01_cpu_dirty_logging;
-       bool update_vmcs01_apicv_status;
+       bool update_vmcs01_apicv_exec_ctrl;
        bool update_vmcs01_hwapic_isr;

        /*



By the way, while reviewing source code, I noticed that certain read accesses to
'apicv_inhibit_reasons' are not protected by 'apicv_update_lock'.

Thank you very much!

Dongli Zhang

