Return-Path: <kvm+bounces-67204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 286D8CFCA24
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 09:37:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D17CE3005F13
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 08:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4A72C21E6;
	Wed,  7 Jan 2026 08:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IMr6UT/3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xIKsFmXb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393C427F18F
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 08:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767775058; cv=fail; b=gy3tSGQB0yIcJrOyzkJh1j3mi+xCJcsPJhEj2O9WrxpueLSoRDc4gUM+1qOwECkQlIdMJdx2n+WZ4jUmAuc4Q/rL6WpquaT2Y20SKbLYx00E2FEPdEpSrlSodg/KTAQJtXdsjn6JPZLHzdd8/6DJYU9M7A32sGpLABQZLXN2Ebk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767775058; c=relaxed/simple;
	bh=f3goDkyq2cGrGb08zDTvWyP/QF088Hs3FUZdrH3GbPM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rs+34KzXSVP3dayYc2oH0LZzBvQHkBOYaQvG79k/Xd8RRZnX4F6+qyz7xJh8TdPFswPpD6xMgiq44DRrE9DOrUnDO9nF+gHGeE9RxWBTVQ0lJP88FlFDB44BsAAmKxj326q+NLgJrqW1J5IVpagLXytAaU8JBDd44Hph19mG83k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IMr6UT/3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xIKsFmXb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60786K5f1578170;
	Wed, 7 Jan 2026 08:37:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IM3+eDtML76/qRFpBWwZ3L78rWhB0MAIf+fHUhK1NtI=; b=
	IMr6UT/3UWK7BmT+QLnbxbF8TvXPmt5amEV9hiyqRuWQGB5YW7IGqMeUM6GSojEH
	Vye3PUEDpsrKX8GTeQ2jpNPX9U9ZLPk9+Dd4mFdmOABU2KDKZozqD6F5Gqm7YOpO
	a5jWPBdFiglS32M/K7Vbi0a2CIXNFOXCYoqUeaNIjd6u3xWirlAHcR/7yTcdAw9k
	vp/TaC/8GGGTRLR5i0U14VDCetskscV2QQuEPhDr518ViG6UyBSdNLaHUzWcA5su
	SWqy5setGbN6fRpMPwzHLz/5AAsbofRrAf9y+cOK0gyrLwu5qvezx2c52bVo2FpT
	RH2cfLThT9AOtjV3A4nsdg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhkper13k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 08:37:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6076KV2u026331;
	Wed, 7 Jan 2026 08:37:05 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012032.outbound.protection.outlook.com [52.101.43.32])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjkv8hs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 08:37:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CT2Qpl4h4qOTyrPo/7zRFxlxbJk0w+dFFTdsxzPI2GJAx/QnKLhr5J7dvcAWEWtvfNa/j4u4JvlDTA1NFmW7dYczOUxu2SzYFiMrdaGzyjmFWNjSkEwtv6ikm3LeyPw5ZbJPRg3xf3qIhJHe5d2hS4V0Ck4nEFeif2gxyvvMY6YD7ycSQGolWbVlm4Bs8WRx7zY7zUU8FesOvKANR5AYSPcpDzvyfJD7Oindy+Pr/B8DgvMakPpkdl6l6NiQ7lB204odxeZ8ZJ/yGJopyMw9CN+pi88WnyZ2LN9lk40/9I/V/Jzyzvdorgh1bThfHak0jccFUGLMDWGT08bCBFp9LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IM3+eDtML76/qRFpBWwZ3L78rWhB0MAIf+fHUhK1NtI=;
 b=RLnj8sJ7IoIqoUsUncHIKM8C9UZy9AvgUWp6Z7PQNN/7mEe63BwfsJX9w43/PmZN7HtoW3RhSs4KjNPTLfN9Yr3xXjj+G+KzqxyRREh4H6M/GwTRmOFU0IEYpnP2Voailx2TabOK7cFYAR28ULk2Rr7BWXkVJ+k/vkhz5f4cxE8rTM8tPvEjcXC2ZLcxRc46I6GqvzLlF1NFg1oES7mvahP8NH27RhjQ1ckTkD237Y64Np489FhBc/o2pLKoQvjU0QBD8B8iSi5Y1bS2bTJFQ0VWrEqG/Gw1uHCVJxr47Q0afzcZbQyJ/LSIvqiP4UIb/y457wWTyuo/MiPGa/UmmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IM3+eDtML76/qRFpBWwZ3L78rWhB0MAIf+fHUhK1NtI=;
 b=xIKsFmXbN7qbTwpgS8MBPwHBzS0n1zYjx2ZcJor3ub7OeqLR+BrkKjEgVV4TADwCdNUBy2ZOycTJuZNJu837oP6ttJZwHGuE6u7+V4csjuPs6xkWadjy/OhB1DviW1mtkOLyEyccex6XJ4DtfPnmf1bYLEpQqX2L8OsSvGYespk=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 IA0PR10MB7577.namprd10.prod.outlook.com (2603:10b6:208:483::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 08:37:01 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 08:37:01 +0000
Message-ID: <cbf5341e-a397-477a-9d5a-3a2305355539@oracle.com>
Date: Wed, 7 Jan 2026 00:36:58 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 7/7] target/i386/kvm: don't stop Intel PMU counters
To: "Chen, Zide" <zide.chen@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
References: <20251230074354.88958-1-dongli.zhang@oracle.com>
 <20251230074354.88958-8-dongli.zhang@oracle.com>
 <de20e04a-bfeb-4737-9e30-15d117e796e8@intel.com>
 <0f9f360c-b9a8-4379-9a02-c4b6dd5840a3@oracle.com>
 <d043ff42-9604-4acd-8341-830b30cba951@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <d043ff42-9604-4acd-8341-830b30cba951@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR21CA0002.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::16) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|IA0PR10MB7577:EE_
X-MS-Office365-Filtering-Correlation-Id: e9c9a65f-2783-46ac-4b92-08de4dc7ed89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWpBR0NzS2w0TGpURm9IUWxwR1VKaVAycDdCMnhzQ3hlMStkOVN4S3cvOXlt?=
 =?utf-8?B?ZnBsQk1hMzdSamJMdUNrclZzdXFDdHJ3cGdWREp1aXYvM3BCa2NmRHhtNTZu?=
 =?utf-8?B?Zmp4aHJaVlJTS2pEZTZPZTROUnh6azd0Ylk4KzhoemFlR0FFdjBVMUV1YW5Z?=
 =?utf-8?B?QTB4WWMvUlUvNVVJRGZvWXhsRElnUlF4RXZDaCtkb3UvQTNMMENPbjI4cU5H?=
 =?utf-8?B?bmRFN243Rkd3VFIxOG9Bd2s5TDJZS25hZ0ZrOGJnQ0FERkV3VFhsbEhjNklC?=
 =?utf-8?B?ai9WaVlFSTN6NldRalZpby84b1FWTkhXOVRTZGFyR0czTHZxN2R3U1EzR3gw?=
 =?utf-8?B?S0tIYkFoL0pKWTZxNXdJeWRZeVlKalJiR2hKYzF2Kyt3dzBzYXVIQTlKN2ov?=
 =?utf-8?B?ay9mYU4zYnhlZ0c3ajl2MjBUbkI1VDhMRTNHWHFqVDFWOVpuU1BRZkNvT1VB?=
 =?utf-8?B?RFdKWlE3QkdoekNRK0htNEh4RzhpWXVHNi96V2FVdG03RThBUWhZZ1JwOFcx?=
 =?utf-8?B?KzFPeUlMMGRlWmtyaXBIRy9VMjFYSnFsZkJXcDRhSWQ1R3g5MkV1VHprOXd4?=
 =?utf-8?B?TDErK3gyaVpnS2x1c1BFZjVRaTVKaHcvak55REd1cmIvbzVKd05CdkE3SjZa?=
 =?utf-8?B?bVhIM3lObktCRmNiNTgvRk5TYmxIUnBhRm10My9oaTlkQXF1MGFFaVJVTDg0?=
 =?utf-8?B?YTlEOGZQWlFwMWZMZ254UUdrMXMwNW8yeC90L0VxR2pXQkxXekhxVWlCak53?=
 =?utf-8?B?WTRVeGlmbm81RFdNc0lKeExtYUVKZVlSSDFlaU96b0pVdldDb2poSDhXSjlN?=
 =?utf-8?B?a2JEdW5DQzViNTNIditIRTlNS0lUdFlrT3RxRGNXb1l1V1NXRGRteVFxMU12?=
 =?utf-8?B?STgrcGJ0RVBzdkp4RmRzZ3J0emU5c1NQRlF6ZVljM0xEb0taUXVQbjgxYVVB?=
 =?utf-8?B?M3JEc0xSU0RBLzl2V0FyN2tEU0tzdjB4RHQ1UGI0emFxSXEyak55dnkzVGZz?=
 =?utf-8?B?VFNiL3lMRVJ6TzdGa3JDdnVXSGFNQTZ3TUVYV0hzV1FTMWNNaW5sdENZZVUw?=
 =?utf-8?B?SC9ZTTREbW1mckVUSWgxL1Z2TmtZaG1Id0lDWWFjTW1ZbHMvem5yQ3h4S3pU?=
 =?utf-8?B?ZDhBU2QrN29PUHJjdC81L0ErNmlBdmY4ZnorL044LzBzb25lWWhJaExoR1JQ?=
 =?utf-8?B?ZVZoaFdCOTU2UXZpTStsSERiYUNmb2VNREpaY2hySjNFdmsvNjNCbkNTNm9E?=
 =?utf-8?B?VU5DVzZnU0F6R0QvWE1mZGp2dnY3cVFGbWNVV0dUUTdwWm5udzJrQzJPL3l1?=
 =?utf-8?B?OHh4L1pWVU82SjhmRmFVRkorcUlBbUhSbmVwN2R5d1JkdDJGTXowMGRwWnpo?=
 =?utf-8?B?aU1jV0lTWDEzc0lla1JmRWdSbS8yM1hpZnBLM2hYTDBSUi9LTzdWUlNxOUlZ?=
 =?utf-8?B?UUVGYUF5WHFaU0FaNFNqU3kwODdUTEJyTFp3VndwNmt3NWhoQmg3ODdmWklu?=
 =?utf-8?B?UEJGK0tvR2E2U1U1RU4wMk9xQkVtVDFUOXUyUEtDcU1BeFlQWUlpUW5HdXhv?=
 =?utf-8?B?MmMzWFZqN3hqM2REelg3a3hKR2M0ZURnQkxXZzh5RVQxWTdIZS9UTWNYWFJI?=
 =?utf-8?B?SWk3Z1UwMUNkc1ZwUVdSR0ppRnpObTlDQjBtOVBaZTJJTkdRWnJQbk5xcXdY?=
 =?utf-8?B?RU5RNEZhNUg5aWtFUXdjWmtwNFBjRkc4V0pyU3JBRmFFaythVW9PYWw1SmlJ?=
 =?utf-8?B?RTBURW95Z3ZlQ0k0d3JEbCt3Q04xbTh6eG9sN1hlaThVL05oYUt1OHl5VHky?=
 =?utf-8?B?bGJYaWFKMjkwM3BkZHQ2WitPU0VHdU9vbWtmVGluOHBOMkRVOW1qNmJ5eVlK?=
 =?utf-8?B?ME4wcmhuWFptQXAwYnY5M1RuQXhkK2dKU3REN2IwMUFwenIrbzZuQ0hyVnRk?=
 =?utf-8?Q?ttcwa5g3bNuhFiwAuonNsCMjs8zw71WG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QnNuRHVGVjRLMWZTMWVWTU9wRUh6T2N3cFN0NnBUVjkxNjRYVlROWGJuN2d0?=
 =?utf-8?B?RkRJcTZJZkxoYWtTKzJxTEM5Q2RQWTIxU09OR0t2SzB2ZFlhTm16WWkzenFT?=
 =?utf-8?B?bFZ4OU9zUENEcS9qRU5HSWljQWJEeDd3WmU2QngzckxnTStpbzY2U2NPRnRM?=
 =?utf-8?B?YjlEdDRGMmxsNEtER2EvTU1sUCs3Z1paUUNHZGQ1L251R2RJNnlHeGhMVWVG?=
 =?utf-8?B?Z3JnZXlNZGJsdU1JU1BHeVFkMUorL2RHeWxrSVozdUdIMTlFaXphdFROYnYw?=
 =?utf-8?B?RWw2TWlkUll2RlpDMUp5azYxUEkyQytGSEpxY0VyY1FpOEo5Yy9GUEtEc29s?=
 =?utf-8?B?Nk5CbWUxRlZMRDUrL0xqS3R4dXBwdU5XNGdDMm5WWER2cTAzNHFhMmhqWnYv?=
 =?utf-8?B?NDZnNGErTEIwNi9uTm4xZ3lNaUpiVUMyeTM5emxPaGxLM1p6SHVWd0RPN0t2?=
 =?utf-8?B?eCtTM2ZsRW5MZDVaeko4S2Jkd1h0QW44WjliK3Nlby84TUtHNWg1OG1lWjFL?=
 =?utf-8?B?WlFtVEVvNDVmdkZ2V2R5b29aUFQvM3h2VDFUYmZraWFuaGxqeXlmb0pQMHpj?=
 =?utf-8?B?TGhoZnhMYWhyWmhSQ2xjeEFXWmh4cnJweEkvYmlLQkt6TUdCQWdYU2dBc09t?=
 =?utf-8?B?dCtsRk9HYjFwN0ZGOUJPL0FzWUpCTDV5NE5NQ0lQZUt4a1l0S3FHSTBjWFEy?=
 =?utf-8?B?clVOeThONHdjMG5pL1ppKzFZL2R6Um15KzJPQWMva2xrMkYwUklDUEVHVUdw?=
 =?utf-8?B?MnVsUkV3dUFHZUZHdzFNNGtzd2FBVTMrT1hnTk00YnNEbDN6WEl0YldaWmxk?=
 =?utf-8?B?dEltRmVpUUJDeW9DQUMxTWlYcVc2d2E3OE1SVnFxd2lyZ3FOQUFPNmNsUUZQ?=
 =?utf-8?B?QnFZak9WUXB4S1ZKL3l1c0d6SlRJZlFkTDk1UHF2aXBCMy9wekV4QzhqUjNm?=
 =?utf-8?B?cHBBOFR1ckl0UmorK2dlTFhFa2J6NjJHYkRVVmljNnBxaURUQzUvcVBkYVpp?=
 =?utf-8?B?N1dRdlg3YUpQNVFoNXRpZEJleTVuZUNuUld6UHBDT21lamhYTnd2Q0ZtY3Q5?=
 =?utf-8?B?eHFRZ3pnZWJ0ZC9XK25VUHFZUEN6RGl1cXF0ZFpIOUQwL3VPUVVQWThMaG5R?=
 =?utf-8?B?WTZaUUJhcy8xOW5xTnkzZUJpZGJrT2hoeTFickxqQmZnTW92aWVIT2JKQ01R?=
 =?utf-8?B?TkU2Z2xTeXNLbThRckRYT0FDakEzcU03OGl5Rm1rY3AvZzRISXQvTzRFeW93?=
 =?utf-8?B?SDZaM1hKVjc5VnNaQ0lxQlpDOStqam9jQ2pRTHNPOGNWenJCNDB1R0Q3WkpH?=
 =?utf-8?B?R0VSUUtEVjQzVDF6WU9taVh1akpDSzM5WkVyQVkvR2tkcEdKYTBYaE1oQmZ6?=
 =?utf-8?B?U0NCNzFtZTdKRDNRaWFMb3lJZTBiaWtGck8xUlVJMTFqenMyOFhsZDJMY29N?=
 =?utf-8?B?L2RreUh6L3cvTmVndStnZzVVSUxwZThTd3AvTUNoa3VSUC9tdmhMV3VtRmVi?=
 =?utf-8?B?a01UTk83SXJKVzhJczRVMVFFakdUVzVEOC95bEV6NGQ2V0dFQU9pUFBFMGtC?=
 =?utf-8?B?WHN0dGNaU1luTUdNT0FwOGhPMFJwdHhzQUc3N2EvY0w3TVJiajlNZFhiUWFO?=
 =?utf-8?B?OFBkcFh3R0hVVnFmUVc0OVpuQjJBdm5BOWwwQlpQeFpUMHg3VGNhbEdzdkVP?=
 =?utf-8?B?MnJpZjNyd0JLcFZJcUdFeUhLZHIvckdDT1dzY08rYll4Qldaenhnd3RiSzhz?=
 =?utf-8?B?SjdrU2cydm5YSXU3bUtiZ1R2QnlLS2VMWHlmYjJ4blh1QURqR1lFZHdzVDBG?=
 =?utf-8?B?bW5DbHlVRUJwMGdDVU5KUDNhYUltTXJqQUh5OThOOGtXYVIzbHJrNy9pK1d0?=
 =?utf-8?B?UkxBMmQrZUs3TjBHcDRKS096bUpmVW9nRG5tTVVQa0NGcUQ4OVdSVFJiREUz?=
 =?utf-8?B?K1F4WmpJUUV5QUsvbW0zZ0N1SERmNU9LRTRwMGs5eTVoNjF2bmFzSlZRUkxn?=
 =?utf-8?B?UWpYL0RmMVIvV040RzVrVnJsSGt4bkt0RkdxN2JKUmZkMjBHZTFXOWh0U3Vp?=
 =?utf-8?B?RUFycmlzQ2RvUkNMZjFVY0NhUU9ybFdXU0gwWGdDK0F1NWxRd1hKaitwU2E2?=
 =?utf-8?B?U1lwL25ucDhLTU5nbHNoRlJHbW5adGU1OFRnWHJ1QXlzTGVmOEh3YTUxNjZP?=
 =?utf-8?B?aGkrQ21qTExrL3hONHJ0cDR1M0dlRit6N3FtRUQ0a3d5YmZnZWhMWlh0V3JG?=
 =?utf-8?B?R3lZNC9hUVpjU2ZZczdtcGxOdENBNVVzL3A5MVdNMitvaVMxK2ZDRlBjbnZU?=
 =?utf-8?B?MDRTbmg1Z21PTHc5aGhObkVxM3ZOVUJVUTF6Qldad09zaVl4WVJGSDdrRERo?=
 =?utf-8?Q?U0QZIpHcM2+JDc6w=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	q0M0VzlfEtLP/6WWD9KPTevE3gp4sKMDjSbpcae/J9EjgtGkTwI7KAKu2bfKJcC0yXCAk7nVy6KLfiQK7Vctk+p6EKfeSlTpX/DHbkUBxyjATJ8uf1vQciQ4oDNifZnCRCsNr2qYHE3QiDj/DHRRPVgg71fc0rnmUv9hKtQ87lyepSzsinFEnAsppmdO0/7VTPOcQMGczHuwKzFkodooZbRngW5hFh2NurBtuvfXuin7r+RiGv/m1ihAjs1eoCtEaYtDAmkDEHChNujrY1TbIxg50xt2A8cBdG26dgD2b0FCZ0lMDsixJFnpBQXTl0Re2bPSUeo0MT8qtWEzIJIRlJAxAR++l2OJX24M0wbUjOYV2VvlsQdLSnDuOcIFTRsprE3FMHb/4GWJyRz/9ScDKyp78zpxyMIke0LAhGNbupjduHGOcx3ne0STzTdmvDPJoBZd+nYCGSz0Ulhn9gJ+IG2uzB7l52XYdaHWKm6VzWLJCcmjMFb0zn5wLJrbRZuoSe4Te+GWNhUVD5/zGuHNdeS66q1AxWPtsLaSKvQTZmL+kiJCO71cNBXFSBDSOzoX/cfetYLapG0wRrOuTQYKmupbL+ArAhA4TWoEG0qhKP0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9c9a65f-2783-46ac-4b92-08de4dc7ed89
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 08:37:01.3710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFnfcQZi5aS0y9K4Cpv0TKYIQf+LAjZ3vAl27latRS7eDJOrL9+BMLR4ik258WVulwUpfiYI7FplZ19HWFPhmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7577
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601070068
X-Authority-Analysis: v=2.4 cv=E4HAZKdl c=1 sm=1 tr=0 ts=695e1b31 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7DQ4xQMpdGrq_I9YWf4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12110
X-Proofpoint-GUID: UmJRi_ZIVx41oqKOGPKbStBX8KkZM0RE
X-Proofpoint-ORIG-GUID: UmJRi_ZIVx41oqKOGPKbStBX8KkZM0RE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA2OSBTYWx0ZWRfXyXi/2kvFKoAW
 /P+GDsxbi5E90ZHXD4RlUwimsE2+7fLKeFOnkjf1gLEA1IOg9XqbzAYuZWtVMpQy1oOc8xThqnV
 BZsF/dXseejxJyEgWKjFQvZ+sbDO+H8Y8/cbmTyk2rNcQ7rMyMFmFOPAVz8zIVAr2eojjJiPEe4
 DoIYlKw6Mv9WEwLPQWubaCFcxMcJRD8z0+mjok7GRkFHWKUh8L4/E2wzSzPx+7ENezY73qSWryX
 9UOSXI0d9jJwYg74T/DPQi64DDohi3HFb8CIvQTDjh1VJwxj+lbdrGKohjxG6wn2RBmCmRIVget
 PNSoFQ5rEY4V9hiV8Q+kOyFTiMBtwuBVggUpEcA+V3hbhQnnIhN/CgCZLtWzOWDatA0BUX6e6At
 2bFvLzJHkgqfpWnBfeiBRC8IW6eHOrAgHjK3uFLSLfChOwi5+DL75uh/3A0MtooyGiO2i3dbK8l
 C10CSTfDZXG8CBTK0wZbtqbmbZ4AENAgKZQgv/Ww=

Hi Zide,

On 1/6/26 1:04 PM, Chen, Zide wrote:
> 
> 
> On 1/5/2026 12:24 PM, Dongli Zhang wrote:
>> Hi Zide,
>>
>> On 1/2/26 4:27 PM, Chen, Zide wrote:
>>>
>>>
>>> On 12/29/2025 11:42 PM, Dongli Zhang wrote:
>>>> PMU MSRs are set by QEMU only at levels >= KVM_PUT_RESET_STATE,
>>>> excluding runtime. Therefore, updating these MSRs without stopping events
>>>> should be acceptable.
>>>
>>> It seems preferable to keep the existing logic. The sequence of
>>> disabling -> setting new counters -> re-enabling is complete and
>>> reasonable. Re-enabling the PMU implicitly tell KVM to do whatever
>>> actions are needed to make the new counters take effect.
>>>
>>> If the purpose of this patch to improve performance, given that this is
>>> a non-critical path, trading this clear and robust logic for a minor
>>> performance gain does not seem necessary.
>>>
>>>
>>>> In addition, KVM creates kernel perf events with host mode excluded
>>>> (exclude_host = 1). While the events remain active, they don't increment
>>>> the counter during QEMU vCPU userspace mode.
>>>>
>>>> Finally, The kvm_put_msrs() sets the MSRs using KVM_SET_MSRS. The x86 KVM
>>>> processes these MSRs one by one in a loop, only saving the config and
>>>> triggering the KVM_REQ_PMU request. This approach does not immediately stop
>>>> the event before updating PMC. This approach is true since Linux kernel
>>>> commit 68fb4757e867 ("KVM: x86/pmu: Defer reprogram_counter() to
>>>> kvm_pmu_handle_event"), that is, v6.2.
>>>
>>> This seems to assume KVM's internal behavior. While that is true today
>>> (and possibly in the future), it’s not necessary for QEMU to  make such
>>> assumptions, as that could unnecessarily limit KVM’s flexibility to
>>> change its behavior later.
>>>
>>
>> To "assume KVM's internal behavior" is only one of the two reasons. The first
>> reason is that QEMU controls the state of the vCPU to ensure this action only
>> occurs when "levels >= KVM_PUT_RESET_STATE."
>>
>> Thanks to "(level >= KVM_PUT_RESET_STATE)", QEMU is able to avoid unnecessary
>> updates to many MSR registers during runtime.
>>
>>
>> The main objective is to sync the implementation for Intel and AMD.
>>
>> Both MSR_CORE_PERF_FIXED_CTR_CTRL and MSR_CORE_PERF_GLOBAL_CTRL are reset to
>> zero only in the case where "has_pmu_version > 1." Otherwise, we may need to
>> reset the MSR_P6_PERFCTR_N registers before writing to the counter registers.
>> Without PATCH 7/7, an additional patch will be required to fix the workflow for
>> handling PMU registers to reset control registers before counter registers.
> 
> I might be missing something here, but since this is not for runtime,
> I don’t quite understand the need to reset the control registers.

Global control registers take priority over per-counter control registers. If a
counter is disabled by the global register, enabling it in the per-counter
control register will have no effect.

However, assuming !(has_architectural_pmu_version > 1), which is highly unlikely
in modern systems, there will be no support for the global register.

As a result, QEMU should:

1. Set the control register to 0 for each counter.
2. Write to the counter.
3. Write to the control register.

From the KVM source code, the minimum version is 2, although QEMU assumes any
version can be utilized.


> 
>> If the plan is to maintain the current logic, we may need to adjust the logic
>> for the AMD registers as well. In PATCH 6/7, we never reset global registers
>> before writing to control and counter registers.
>>
>> Would you mine sharing your thoughts on it?
> 
> Personally, I would lean towards keeping the current logic and instead
> adjusting patch 6/7 to reset the global registers.  This is just my
> view, and please don’t feel obligated to follow it.
> 

It just seems odd to me that we would need to emulate PMU MSR usage in a VM,
i.e., stop all counters in the global registers at the beginning, when they
won't actually take effect.

Perhaps other reviewers have some insights?

Thank you very much!

Dongli Zhang


