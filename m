Return-Path: <kvm+bounces-31653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD7549C6036
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 19:18:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F7E31F21A3D
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 18:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2792B217F5C;
	Tue, 12 Nov 2024 18:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kBdd0RCZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pAZdgfMu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB0521766F
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 18:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731435486; cv=fail; b=bA+fEbt1n4lRFmdlrGxnu2oryqKFV/gjuJOvdTKhCbnHmWaJlELAEtYsqeU6raH89Wf9j9h+jgCI2OQegNSS3dxAgyILU30r4qaud/OumZlNtvEKlPTdqPmFuL5YJKH1XX/BjFXxK/nYY9FqVK8/8rDyo3QDjZq9V6I+5gwjo3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731435486; c=relaxed/simple;
	bh=A57Ro9eS9HTQVQZci1cz+TjayZ7q+JLir61OvsVSuYM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mVOPbZXOoWiWqHxKOe33KpBqKj6SDkzBFIeSBlrroIyV0J47DNvV5o8TiTflij6kIzKFKtIWs3oT0nXgrdRYTj9shw2NE6ipVYSLNzcl8WukcKKW8GZpmT0Z6bb2fhxplTeJ3wBqo/YFbCRq3dUOl0iFVlodC5dir2JGBmMCbc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kBdd0RCZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pAZdgfMu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACHtb03031404;
	Tue, 12 Nov 2024 18:17:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=/GC+G0+AJCdndcb/p+ne3kLzvTUxU7Udt5ovKx5QwDA=; b=
	kBdd0RCZafVJmvyndscJugBFuX2l/ob4MVWVKfI/fWvFYRZXgYcB/Gd4RR81oFol
	DkZwjtHDvx4AKPClBoEA9rVFtUkepxR0F4GSYBa7pGqzxHiyU9vOisDyEG/iKDVs
	MTFQXKU3rUaaMXW4UqNDIdBd2vbeRMYNoGPNEremTdHh8UbvOtAi/iZHp20UZAIA
	wcxpml5HoyP96enEyb4OmQ1DGojQg1U+E48mpnj1B/gDoMZl4/DR+mHvLC1KszdJ
	Nu+jontClC+0KVmiGhcoHC8CxI/tcfY78M8vlIj+Fr1/NyZq4jCiCRSlOKLDra8H
	1q6iqpQlflrCkL7hCJcxLw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0nwn3d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 18:17:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACHLDm2036004;
	Tue, 12 Nov 2024 18:17:51 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx688yhf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 18:17:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IuEOR0qaDnvLgmddf9NzDDqv+V2gt4FoHAqiD+5mrL2PD32fu7RUJfrRrxKdZTMR9x1CKPE56C/S7BxNl7pneng1U7uOxdubqBts6h6ILFdYJ3PP9Q2qfopPRzLeSBU7U/SzZ20mOmH8zEChPjCti5AvLLF4/p+HsAwBQDAGxoneslztZYi/S6w5R1XKqqSnf9zyclIFI/yfmcPKlsUCYTEPbbcNe9WE9WQxke9waHbnoYq6E9JZdVxcGiI4l/KBxaR+dxe//V9WQWHNJfNCbEAs/cEaXEEHcfzyuxfZWQRxeYA81zoPWi9Zphbb69MzC1//26JYZkcfZXpqbfQFiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/GC+G0+AJCdndcb/p+ne3kLzvTUxU7Udt5ovKx5QwDA=;
 b=YAvs7kXhwDkpxAyTh8Bp+UydcshmvUYrHXYKj4Lzl4WcvX860o5vTBMYAlMbNT3uUVxujSfHbaYG1p35A6m6XNwfjLuac4sC6A5gHOHNwF8iXyPfIcfLPs8DhqtH/HjfWgO+XAIsBgCdBP8fTxiQSXwX6Euwch7H1QdUlcVNoYLoPSa8HQ9+KfxqGeO0I5MihuvbKFxpoV4q3SIUfgAb7GMzV/12PfKY1dZOpfFoP5thVf8M6t0uVpE21czInP6Zak2C/jZih6Y9ayVfelcehIIq8zNX5oipnfzJHiS9996tJZ0H+fgWl2J6rtHX+EYPBDQ4EEriL/9IchrYuUxp0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GC+G0+AJCdndcb/p+ne3kLzvTUxU7Udt5ovKx5QwDA=;
 b=pAZdgfMuOzu0nnjOrMSXqusBTMYsCp+VApD52K3yMh9aKwuHvDEFutOfvuMnXoie/zS4XV+F0UgcVUa58T7D3Ab+nO6El7OnFeUQI0iV8udQGkGiSDICfNJb5FnwYMjF5pa2uZrMTnk73kot8dNCCg4dD8EpIdYA2co6ES2J4JM=
Received: from IA0PR10MB7349.namprd10.prod.outlook.com (2603:10b6:208:40d::10)
 by DM4PR10MB6157.namprd10.prod.outlook.com (2603:10b6:8:b6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 18:17:48 +0000
Received: from IA0PR10MB7349.namprd10.prod.outlook.com
 ([fe80::8940:532:a642:b608]) by IA0PR10MB7349.namprd10.prod.outlook.com
 ([fe80::8940:532:a642:b608%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 18:17:47 +0000
Message-ID: <b6bdff02-4ebe-466f-93af-dda572505995@oracle.com>
Date: Tue, 12 Nov 2024 19:17:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] hostmem: Handle remapping of RAM
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
 <20241107102126.2183152-1-william.roche@oracle.com>
 <20241107102126.2183152-7-william.roche@oracle.com>
 <3ed8c7c2-8059-4d51-a536-422c394f34e5@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <3ed8c7c2-8059-4d51-a536-422c394f34e5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0125.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::17) To IA0PR10MB7349.namprd10.prod.outlook.com
 (2603:10b6:208:40d::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7349:EE_|DM4PR10MB6157:EE_
X-MS-Office365-Filtering-Correlation-Id: 72539d7e-1f3a-4f40-499c-08dd03464fb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V1RpcnVKUWpjUHJVWXJYM2NhMmw4YnIveG5aZENUZ3BjaWY2VGR4SXhFaTBJ?=
 =?utf-8?B?bUZ3OG5wSjNmejlpOUlML2I4Ky9MRDd2My96ZGRoRGJWYTBWOG9BaDI3aTZ0?=
 =?utf-8?B?dmRHZHpXUng0SUhLeE5jQkVJMjRrNEhqUmw2NE9Ga3hib0dVUWc0bmc4bWF5?=
 =?utf-8?B?RU96SGhvNGtzRk82OHcrT0VwN3JxZmlCT1J3cXdrSTdBdlc2L1FVVEh5YkJW?=
 =?utf-8?B?Qk9yWTJZMExzSHFzWUh5UmpPbTFXV3VGa21VUEpRNXgyTGhOODlEUUNUNEJW?=
 =?utf-8?B?aU5OcTdMMUs0UFdOVEszc0VUdzJ2bXZhNHpIYWhnVG81SGMyL1hDbktiYXFS?=
 =?utf-8?B?eFpQWE1KS2dCVHNNdlJUVWhvMWM0UVpTWTJERHE0RXBLZXN4UndlRkdqMFI3?=
 =?utf-8?B?NWs0aE5UcGlmOUxQOEYySjk2VUVtcGxqNTllL1pMaGpPWGFCYVFVTXZCVDdX?=
 =?utf-8?B?WGxpZEc4SStXM1p0bTRCQU1XSmpLZnhIc2hiSVMvbElmbEVJMlV5aXVEQmVU?=
 =?utf-8?B?YVlNNVFTQ0tEUUVuL3Z5TjdsYkQzRzlSc1E0NVdzSEYweHhVYjdQSnFMR1Fm?=
 =?utf-8?B?eXNiM3gxek1vbkEzVGwzanZNdzYxWW0xOUR5VkJBMW5JUnhETU9KMklBOHhl?=
 =?utf-8?B?MnlwVTUwZUt1K3U1eFM0T0ZxOUVjVDlLcnE4OTV5elRKVzRQbjVEeTU4bjZM?=
 =?utf-8?B?WkJyQ1gvWFloc0lhSTQ0dFVZQlRwMXNXOWRyZmtqWWFFZTVtc2p5YjlnWTAv?=
 =?utf-8?B?Lyt0SktnVW5tWmNGeHBXT0hRNEp0ZEFqUzE2T3d0WGdnSlNPT1p5eFVCblVw?=
 =?utf-8?B?MHRScmkwRHZIajFRdjdCWUh1RmdDQnR2bGRiUUFJVkx4d1F6VmZuS0txTDFa?=
 =?utf-8?B?SlI3UmVscm44bnR2YXVnWDVhaGx5WVlkSjh4cURlUU91NDJleVFFUzdsUnlD?=
 =?utf-8?B?NjRoSlRDN1BxUm95YXBXdUljQ0k2VFJHOFpHNDdFNHlDdWcvSG02d05zZnYr?=
 =?utf-8?B?MVJDTHYrbDdZWndNYTUzcU03cU00RlNNWFpJalNxK3plWmlkc0wzSFRvaTVZ?=
 =?utf-8?B?T0l1ZFlGdkRqU3RmNklYeURFMmwxdXFIL0RMak5EZzNVNU9EMlM4VVIwRmtJ?=
 =?utf-8?B?WUhVUHJBNWhRdEFxZFE5YkpVYW5EUGo3UUFvU1pGd1c3bTRIYVo0VlVRc1Jx?=
 =?utf-8?B?SHhJbFB5YjJmeUZzR0lISWVYNDNwN1E3NHhDRmxJK2trcE5WOFU5VlJCbFpq?=
 =?utf-8?B?QnZRdjVWMERORTJnZXgyL1R4MUlDODdmVUE5dnpnSy9kbE94akdxMC9wNm9U?=
 =?utf-8?B?Wkx3SnY4WUhxYnRhU2JIRldNN2QwMWdaWmlTS0lhUERCZHFpTHpqMlN4QTRp?=
 =?utf-8?B?eGJvS0RkNEd1dGhPY29JZDRBak5rTzFRcnFmdmFvM1hPTWw5UDJBRHlDcFh1?=
 =?utf-8?B?RytUOENhcXNyWkJYOTdOV0VYZnN4SnF2TlFvQU9jd0c1VzRxdkJWV0tyKzlx?=
 =?utf-8?B?dlA1M21nZU1HTXhhVHN3ZlVDdno0cDBwUkI2N205dEFJZ3RVVDQrZ2QxUHR1?=
 =?utf-8?B?Z0ZnU3VDMHlMS2VrVlphZVE2Q2orVTBlWEViV2JBcTZpemdnUlZ0OU04U0Iw?=
 =?utf-8?B?dmcrUnVHUFdGMVNhaDhib1NtRVVDQ1VlSlhsN3FQalEwNjhnWkVqSlMwNURu?=
 =?utf-8?B?ek5nSkJwcUJkZkZQSnpFN0RjRXQ5TWhXbWd4MnRzT3BXcGRZNXIrMlNmLzZH?=
 =?utf-8?Q?bFUzuBPUQyUhtyEee6iZwxI3PtU/Ecjc05c5Aya?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7349.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmZXcEJJOTg1TjNTeDg5SVhwUzZ6UVVrdkRrazhxbXpXSEZsemcvSXhJYnBV?=
 =?utf-8?B?MkJKSjNMSm9SUTNXbFdLT3JjaFk3aHE5dTc3WEp1T3hVM1BBVW1xWVpua0dW?=
 =?utf-8?B?aWY0YVBnbHhMc1o0Z2NHN0w3Z1IxWWJDSm1ueFMvWGEvbUQ5M1VRY3dnNmRr?=
 =?utf-8?B?RCtQRGdlcUtUK3RzbHlNaGRXQS9WR3RWblFzUVhMVm1hdmN1QXl5aXdTMW84?=
 =?utf-8?B?TGdhdzcyMWpVZzBtcTVzNlVzejZCUWFDWEt2TUp2K3ViOXFXeXlsYkx1cjlC?=
 =?utf-8?B?a3Z5Z0Joc2poMTRDL1ZGWHZaL0hIdzBkekNRMnhIaEcxK201U3h6d2hObEow?=
 =?utf-8?B?Wlg5bTB2R0JaRU03cVNVWXVwTUxjOXFlL2NmL284MjgwK1NsY1dvaUR1L3Nr?=
 =?utf-8?B?bmV2cmUrTE9aUzB3M05CM1hjVTQ2eTVybUlZY2Z3akJMdnR4VXNJcVpKS3Jy?=
 =?utf-8?B?b2JPT3RWb1hrZ0N6bGpZck1UTGlwTnhQYTRpQ0Q3bEFTdkhrMkc3aWFKcGg0?=
 =?utf-8?B?SGZwYjUwL29UR0VaV2d1bmQwcWtpbG1rZ09IaFRIbEFOTDkxWXNYUlNZQjdH?=
 =?utf-8?B?YkRGN0xSNFJNQnFacjZITFVLOGRQWGl6YUZ4OFJLLzhwcW5POTZRcXkvb3o3?=
 =?utf-8?B?WDc3STdOZGFYVGU0SHhoWnB6TWpBc3NSM3ZJMmJhMjFUcmlyVGl4eGpUNkZF?=
 =?utf-8?B?L3JqNUk0TWNFVHMrQnQ5ZDdBOGd3ZmRVQ0hYY3BLbE96MEJTVUliY3RnQWVN?=
 =?utf-8?B?RTVZRlBmdXN5eXVHT3JGWEhJa1I1Tm05TXd4N2YxVjVKRmhMcXIxTXNnUDM2?=
 =?utf-8?B?Tkxmck14U2lGQlpIUTU0R2NSMWJkZDN1V0EzbU5xNGtkQmhlYVpyaVltc1Fh?=
 =?utf-8?B?MSs0cnRvdFFKYlJTc29GcG5JV2QzcmZyUEtzelZyM0ZML2lNZ2oxYXRZZ0E2?=
 =?utf-8?B?eXgzanNHbkZuNzBta0FZNlhIVGM1ckFsS3FUWisxaGF2Nmhha2F4cE83ZE9X?=
 =?utf-8?B?MG1XQU5xaWE4aFFKUE81WkpjOUluMDc4aFdBVytlV0hLN08xeTM4bitMSmNU?=
 =?utf-8?B?aENReDF4ODJnUHNXSXNzTThhN2x3ZWZjSWx0c3VtcWt4S04xQ0NTRi9zbWFN?=
 =?utf-8?B?cGFVd1hHSXdjU3JTR0J3bnpPTU0rVVVIVmtCN0pPMXBYcHFjWmhoUWRINk9z?=
 =?utf-8?B?dHpJbmpzQTNyTVNmZHhmWlczRGZnRHJZRm1ZdjNrc2pXOVVyZ3RLaGxmYVg2?=
 =?utf-8?B?TFJGTGpxTW1sV3c0Nm1WaktxeW4xSVNjbTVEWkZxb0pZTHJVZ2tDR2dUd3pp?=
 =?utf-8?B?Tjc2dk5WbXNQd1FlT21OWGM4SThQUG9oTk1RRzdxSWtlem84bnFQRVdhaS9p?=
 =?utf-8?B?QXhoOGhlcWgycDFYdWFWL2t4K2haSnhjS3VyazhjUG5QeS8xWU5BcitWejNE?=
 =?utf-8?B?OG9rMDduWGdudWJKV0d3WU4wVW5qTGtXU2VqYml1dnN2SzRoZ2hVbUg1a2RZ?=
 =?utf-8?B?a0RrS2NhVXljQytIUFB6NTJZOTRWQnZTMzEzUGcxRlNRVElMVGtDc3VBTjVN?=
 =?utf-8?B?dzBoYzhJV2l4MStsSWtBa2R5ZHk3aWJmV2d0Y0JaRFcyVmVFTG5hS1pmU01v?=
 =?utf-8?B?U2dVdVMyeHF1U3BjendqWHR5ay9FWEdCUHlMYkpZTTdhVktyWUR3dlNyQVdZ?=
 =?utf-8?B?L2JDSUlzNzhKZ2JvSXd6Q1c5MUw5SHVKMGl2NXBReklCLzQ3d0xCa1R4L3R3?=
 =?utf-8?B?N3dmY3dmOWIrdFJWa1A0MHU0b01ZTzNkeU5oTUFGRVdlc1F2V1dCQTZJYXpu?=
 =?utf-8?B?a0RCSnJNczVIVWlsSWYramtuZWRXN3JpQ3dMQnVNNldLQnFPMzBEL0tpN3pY?=
 =?utf-8?B?dnBFaXVRSnZGcmN4ZXVWWkEvTUM5L2hnNjNwdFlJcU10V1NDcEpXL2Nqd0ZH?=
 =?utf-8?B?U0JmNjdCem9zYWMvRU9wQzVzVlFXNWROek5YZzRPbEJyRERnV3IzRUI4RHNk?=
 =?utf-8?B?cW0vUVZrZGlJcEhQUlV2VTVlYVJZaXhpdk5iZ1JFTTA4cXdDRmhsUHg2d2Z0?=
 =?utf-8?B?dW55MVRzZFJKQVMrS2w3WmsyZnRRM2ZOUmhQd3J0TkVnclhZKzBXeEFYMER0?=
 =?utf-8?B?SlFuWnZpSzhWOW1TS2NTa25JcGwwRXdESGdkYmhRQXJmbUlrMHBTaVNUS1pw?=
 =?utf-8?B?Y2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GttqPVPj8marUKC1sZ3Q59/TIXlFg63zZVts2TFsMo3gA572O/DOvGPHkLrZNmOJjbiadnvG19iV9VoqxLV8pSeuimOcVqcx2jAWZSsHUqnmsJ6Y4YDIXOtObOyWXgJKBliXsaS35imzhzmGJPfQrI/6IXshN4YLgFaQozKAU7GHye1kqj0u1LT13mULd7anZArxB83mFoO25Vm3q3cznOj0uPbzf1zlM7xJx1Lu1bNk7tE4BJkZ4TFkwVgQWPMeNBi+cXZxduR2QzYmuAVQwrWF7bIjcQMyg6cEhGcixQiZ8mnuFaGlRbf8ACoGH3dFOIElXfEj64AwX25V6VRHhmV1liw8kHQt8D26wALu8wXNXoN6zslvFtSnA4M67B4K3+mm38xmX4JlSamorsxiKiLL7pBqYUgTM6UWcvKxShls3SW1tC0JyJv3F+t2igSvMl9owPL4092UbdfTMa3/PXyLk72w9KMTlo1bRSQNlL6AuD39NBrunTNVx0fOAynaXu9vI/SByOcsW7HaTj6OLLK0wWTq9sponpno4dlXXB+UTK2lIPK31FJ0Xkk6X/QpYKZ2bY8NejuOnKYdLpxyDgGKL56r8b+BAHWqy4PRK3w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72539d7e-1f3a-4f40-499c-08dd03464fb3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7349.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 18:17:47.8304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: utbqAoRxvwpaL0ilypcRqHihtjGu1Db2mtL8WmdJiPf9oWBd5dIT0VPNuPleK/Ct7GSPKa9Rv+c50AYUGiunpP09DAJaM1jc1O6QBLrCGio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6157
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_08,2024-11-12_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411120146
X-Proofpoint-GUID: eFBxJ8TOluqZvxFEsa1aOVoDHX01D0D4
X-Proofpoint-ORIG-GUID: eFBxJ8TOluqZvxFEsa1aOVoDHX01D0D4

On 11/12/24 14:45, David Hildenbrand wrote:
> On 07.11.24 11:21, “William Roche wrote:
>> From: David Hildenbrand <david@redhat.com>
>>
>> Let's register a RAM block notifier and react on remap notifications.
>> Simply re-apply the settings. Warn only when something goes wrong.
>>
>> Note: qemu_ram_remap() will not remap when RAM_PREALLOC is set. Could be
>> that hostmem is still missing to update that flag ...
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: William Roche <william.roche@oracle.com>
>> ---
>>   backends/hostmem.c       | 29 +++++++++++++++++++++++++++++
>>   include/sysemu/hostmem.h |  1 +
>>   2 files changed, 30 insertions(+)
>>
>> diff --git a/backends/hostmem.c b/backends/hostmem.c
>> index bf85d716e5..fbd8708664 100644
>> --- a/backends/hostmem.c
>> +++ b/backends/hostmem.c
>> @@ -361,11 +361,32 @@ static void 
>> host_memory_backend_set_prealloc_threads(Object *obj, Visitor *v,
>>       backend->prealloc_threads = value;
>>   }
>> +static void host_memory_backend_ram_remapped(RAMBlockNotifier *n, 
>> void *host,
>> +                                             size_t offset, size_t size)
>> +{
>> +    HostMemoryBackend *backend = container_of(n, HostMemoryBackend,
>> +                                              ram_notifier);
>> +    Error *err = NULL;
>> +
>> +    if (!host_memory_backend_mr_inited(backend) ||
>> +        memory_region_get_ram_ptr(&backend->mr) != host) {
>> +        return;
>> +    }
>> +
>> +    host_memory_backend_apply_settings(backend, host + offset, size, 
>> &err);
>> +    if (err) {
>> +        warn_report_err(err);
> 
> I wonder if we want to fail hard instead, or have a way to tell the 
> notifier that something wen wrong.
> 

It depends on what the caller would do with this information. Is there a 
way to workaround the problem ? (I don't think so)
Can the VM continue to run without doing anything about it ? (Maybe?)

Currently all numa notifiers don't return errors.

This function is only called from ram_block_notify_remap() in 
qemu_ram_remap(), I would vote for a "fail hard" in case where the 
settings are mandatory to continue.

HTH.

