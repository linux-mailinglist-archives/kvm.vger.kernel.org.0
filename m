Return-Path: <kvm+bounces-32929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78AE39E1FC3
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 15:41:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBA05168DA7
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 14:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 571361F6674;
	Tue,  3 Dec 2024 14:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nrn6ar2f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VNPdNoTX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BD71F4735
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 14:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236811; cv=fail; b=JoHKxCVH81jsnrREpAATTIpKPGwutz1wv5g3A2elrjICYRud6Xg5mbOJC4r/L6VIbpFayGZYIQP5uxwoq8Q9W/c7DiEOJN6pIY12QSHsH8zYvpszixY8TcE85k7NhiZo/zNiU2IZPscqew1gYJa++nBUdQtelAL+CEodIG2wYBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236811; c=relaxed/simple;
	bh=zCq/5/x9RSGpV3q3Qj0qpceaftT6HczjvLA81h/RI/Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N5ODq5dC8bxaOx9hS8p5tHyRwlRKWH86gkyyNq/jVMhyUZ++RMsLIVBoKDdqZkE5N+Gn8VoFxfoBU4pLFfDGSWkveHWRm+EZbDAkxTaKq/6REFn+ZYRReSb7OLCNrLitodoUm9QoJ7sjQ7JAD/IqbpqSK8MjTtllqAeLVqnf27o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nrn6ar2f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VNPdNoTX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B37XvK8005130;
	Tue, 3 Dec 2024 14:39:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=9Gn6QuM83sgLhwxXgU/GK/PoTFpjErf0/imxKjbmo9c=; b=
	nrn6ar2fnQEP46a1ZuKt7Nj4FfvbNivzbi2u+eXYuvm+4d4buxlOS1ut524cLnDG
	xkk2IQDko4UwMv+K+s8L22joaDmbJpWpCqhYNSo9O2iYaV7JXedx40wJZ0IGHFvT
	D5x9+QppRsPA3A9Ddru5aKoMt4wRFnLMfLBGD38rIDPDv/mEgTlplt8Kp4Bh/cop
	Gbp51yloAwaR3GSqCTKv835IB1I+jcXfTPdvfVAyigK8SGkpKZ43K8koqGy430ls
	zJvT0MH1WczXW0wcYdwS30CKfwjaWeOQQTWFdVANMWQB5z0jmWf0l9RiDiwbfyiE
	cqfHOdeOhUO0RX93gB8sPA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437sg267h5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Dec 2024 14:39:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B3Dpb5q031308;
	Tue, 3 Dec 2024 14:39:55 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43836u0hxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Dec 2024 14:39:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tmxXhG8i4k0JzlkZ1bUiKwbn28bNQc8wDYLe2rAmbG0PCh6pM8hOYOwD9s4NeZSmmUHTVNW68kzdmF5Rqc5jAXX+TSRMwIW+E0bqlvvVtq5lUEAn0MDC/UOhiuK9pasawLoKboijRdOZuugXGHbYUNeOs2eQikvvHaU3iYSDFqW0SiQaC1DxJRyzADYgNn/6lQBAWoj1YjDTBZIMoEM8qyUZNTJXHpimDA9UW+mdcRRwa5SQUN+fdwaYSYiWbvkm/VZLSHVLTnMlQOtWJhdVng8Mg/FZsAKkZGh8BTU+T/aTB2r97rEMXHgt0zDJhuGBHtR8eSULiOn4De91BMlHrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Gn6QuM83sgLhwxXgU/GK/PoTFpjErf0/imxKjbmo9c=;
 b=xrGmGQ4RXCe9r0uUTE4QFjEhkF5rhlAHyCdrCAk+vnjxn6K91H3uPF/4BKNkEjDYE5vD3OeuzKZPPRmgSZbfivg59zh11PWkovnA+qaJC2hJBvG5opT+Qg9yuUSYPMEoO/khjxiu5cQW5s9WyaEufasqhZxbtTyl6F8Z/9iGDOF9XWiPNe3dG1j9hdmDxaxf8Bfyan8fh/YnTsrMAaWoknQlxlW090Acs4KABniEXnjf9BGmK4FObBegzJ8IueQ9K/EDh3aMuqBPgv4kkKm7uOL4ks7IUHJFRHaQgGvGuxw5DouY85vM0N120Moh7ztXuTYf8Db20Br26+GRDh0EJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Gn6QuM83sgLhwxXgU/GK/PoTFpjErf0/imxKjbmo9c=;
 b=VNPdNoTXohHO7LZdDwpxm4TXQ2vkP/hCJWN8+OastfGSoP/QU073ZKcBthHVF6qCpe3drh22OKJym31HPuJHhVciki+h4/5S6LiMwvZyvrlh0trXBACHA3ZLsfN7H/M77zZKgjmR3EBJ2fE5VkrVGSAtCx+1sEKGpR6ZdBfT/z8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA3PR10MB8164.namprd10.prod.outlook.com (2603:10b6:208:514::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.20; Tue, 3 Dec
 2024 14:39:53 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 14:39:53 +0000
Message-ID: <31693f78-dbef-4465-9c8e-a68a25cb4af2@oracle.com>
Date: Tue, 3 Dec 2024 15:39:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] hugetlbfs memory HW error fixes
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241125142718.3373203-1-william.roche@oracle.com>
 <48b09647-d2ba-43e5-8e73-16fb4ace6da5@oracle.com>
 <874e2625-b5e7-4247-994a-9b341abbdceb@redhat.com>
 <e09204a4-1570-4d39-afc7-e839a0a492d8@oracle.com>
 <753a033c-7341-4a3a-8546-c31a50d35aff@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <753a033c-7341-4a3a-8546-c31a50d35aff@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO0P265CA0006.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA3PR10MB8164:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d390e48-5d64-4439-8ae0-08dd13a85925
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVFaRHBVR2R1Y2o0c1k5SDNUNzJwQ2FKekZwb1VXWGkxdFR0REJXVmYvSzJq?=
 =?utf-8?B?bGd4T1JpUS9CU0tLZFZDT1F3dE5XU0V1bWJ4K2ZucERoTEhoaVJ1c0tRdmN3?=
 =?utf-8?B?anVVc0tiVlRCQ080aVcwRVpmTXJRb3NjeVk1aDdkQXZ3Y2I2T1J0OHd1MlVx?=
 =?utf-8?B?OE0vaUoxU0xvamlPMmNHQmFBN3Y1RDN0OXNINXVYcHRKM1FDdGtpQ3BCcG4x?=
 =?utf-8?B?UTBQWVNpb2NtR2ZPTS9ObnJYUy9HNFpOSFhjcUhYV2xKeEFpMVprTWZYSGVL?=
 =?utf-8?B?bHQ0R1hRMWJsTDJRVHllMW5KRlBOVGt1K0FCazhSRXpPM09qa1Zhc3lzdXVX?=
 =?utf-8?B?cnJQcXhxZjZuZEF3WWIvVU9lVmdRb0dMdElZazl2Z1hWWjI5VFVTeERqblpV?=
 =?utf-8?B?c2FEalB1ZGEvdXVrSk5rd1BOWUdCOTV1VGFvN3ErSFN5OU1jZ3BWY3UwcCt3?=
 =?utf-8?B?NUh4RjdicnFkYTl4M3hyRU4vVGNqMkpoNVM4OVRuUVBReUtDcCtNaGhOWTdv?=
 =?utf-8?B?Y2ZXNEZQVG83SHowMU5CTVhLTlRleWhkMEhrbUZDTFJQVzVTeXJBK2pWTTBi?=
 =?utf-8?B?SlJjTURSdFY1ZkZwaVkrNGhDSGR2L0lWRHQydk15UjdrWmIxazNiNVQ3MjFE?=
 =?utf-8?B?MjUyRWdiRWFRT1RCNVlIdEsxeDFJRmVZVVhIWWJHbUtlOVBudm14WmR4dXhJ?=
 =?utf-8?B?N05yc3paYnNZclR4U0xkczFHb3ZxSm9wZmFsdSt0akp4RW5NeWN2UHBnaUNj?=
 =?utf-8?B?ZC9xU2JjRUxOb2k0UHdNMUhyM0J1eGZlaEpGSFpvQjdFWmlndkhlZWNyMzZR?=
 =?utf-8?B?eDY3WEhNWGhCWVd2V09nL1pEV0lzQWhGSG1aY1ptcXg3SjZSZ2FEZk4yaTBj?=
 =?utf-8?B?bmRyYkJEbkZ0RjVtTjFKRDNRa1A1cDNFK3plNHJQS29wR3NKUmJnZUZvSXEz?=
 =?utf-8?B?dkh6dkRIZWZBazJTanlUTkJ1V2JOS1VuZFU0Y0dUU0VHUHNkSzhRekZ5TEtP?=
 =?utf-8?B?RC8vajRkd2U1YU5SQkV6d0xacEV1Z01YS21naGRndzVBRXNtam16S0ZyaVJZ?=
 =?utf-8?B?ZnRmbDB6UkZjZVNWckcxZHVJaTVTZGtNaWM2ajIvbHJOWFN3aEpYc2RqK1Rr?=
 =?utf-8?B?bzlNSnl2R0JCUGdhQko0VnRlajhMMlM0Wmo3VjBHRU92d0J4bVkxcG1NT2dl?=
 =?utf-8?B?a3cwQlFQQ3NxTnMrNkdFa3g1MHMvenNCLzhUczRjTU95cWZZUDZzclM2cHR0?=
 =?utf-8?B?MFFOaWJuQjBBcVhFWkowOUk2UTVZMmdZd3k5bzVPeDNRbnNMM0ZaRW1xM2xI?=
 =?utf-8?B?dThPdWd6dUorenVxTnBoZDgwWldDbkpEWTRoTzJCR1U0WmZiK1h4V1lxSE9v?=
 =?utf-8?B?YXZFMEdZU1R6WGJzMnBNZUFqakl2bzJWR213R0xnYVpqUGxQRVBVUkRVTlAx?=
 =?utf-8?B?bXFiVEowbVV2WFFQd3VaYWUvblZwLzdiOE51amExV3RscmxWcG40OW5oNHRB?=
 =?utf-8?B?VlZ4cXZLcURWdGl2NkxNV085Uk9YNVdHZFpTdXRWZnFWcVlsaWJDcWo4WlQ1?=
 =?utf-8?B?aGd0c29yYkRJRjg4MXFEUUlZQ1dTcjZPN01hUXNiSldOSEdQdDd6dkl0M3JZ?=
 =?utf-8?B?ZFNicEV5Qituci9MZWZGUk5wNWNWenRzYk52YmtjcG9ha1RINWsxd0toNDVI?=
 =?utf-8?B?N1ZSS1NJenVSdTJidXBrT1VGTGVrREgyaHd2R3oyVTE2Qk9mM1RTZFVFT05D?=
 =?utf-8?B?YzRqK2F2WUI4eGd3SVhTM2NNM1RMNjdjdm9SRkY5N3owVTBmTjBnS3pKUU04?=
 =?utf-8?B?WklRWkMweUxldnlMTmlYZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1JreUtvdXpoUFdFLzlwblpCNE41RjU1OVFiNkFwYVI2VitnR3o5Qjk3KzEx?=
 =?utf-8?B?bGV0cDROcVFNTFFOZ2k3TDdTOVRBZ2ExcjcxTkVIZTJGZGd4SzNnUzEySWI3?=
 =?utf-8?B?WTlLNXNUV3FEd0M5QmcxNFhrNTJuaEFHM09WUkRUQyswWGZFWnBmaVptZ2FV?=
 =?utf-8?B?UVNDMkFaWXdWUVpYaWpDQmJSUXlGMzRweXVNYU1QMFRraVVzNitsL2RHN3Z6?=
 =?utf-8?B?OUpLajM1Z0lMTnVnSThhMDF1Um93UTBrWnNUV1VBUzZZQ2pUY3hkZXlEWXZn?=
 =?utf-8?B?bHQ1UFE5VHlxOHlLbER0d3VxZTA3WG5USUdLMnR1T0dLNUwzRjRJVm81Uk12?=
 =?utf-8?B?QjJWc1dmY28zdXpqUzFYK2V4OXBWcGFUU1VLUVN3bFpIdnNFRm1OS3lBVmpQ?=
 =?utf-8?B?MWU4UitRTWdlOUxrT1FNNVllUFZYVTFBeVFCZHpwYUg2REN4bko4d1B2ZFUv?=
 =?utf-8?B?NUhBQ1BEbkU5NFArc2t1SWJoY3VReEI1UXFOelFUQ2RMK1o3dmlrSERlYWk2?=
 =?utf-8?B?cXlpN095aWF4Z3cySTRQMUh5OGh2ellaSytTa1h5eFNlbUJjMGsxamI2VUdU?=
 =?utf-8?B?QTlvT01ISnRtYjZuTUdNVXhvU2pmQndOb2RxWFFWTWN2c2w1ZHo5d0xoTUk0?=
 =?utf-8?B?bGFERXVYUEx4Sk14TERjSmNocWsvL0x5bURtQUlxQzNOZkVpRDZSUUF0UEpl?=
 =?utf-8?B?MktIWnBpT2hIYjJJSmZHMWkvNkJwc20zaUZlbXlrTEdlaW1LL2RvT1B0dFJK?=
 =?utf-8?B?aUFUanI3clRSYTg3b3R2S3lNMGRoNmtzU1NtYlE4M2lCeTFTdTY4czVEUzRl?=
 =?utf-8?B?bXVCU01ELzRSNWVMbloyeENIOGFPUStHL2IyTnNXeVJadmpJd1lOQjcrd3o2?=
 =?utf-8?B?ejJKUTY2bzdIZUZPZzhReVVFZWNDTllwakxmSzhEYzZacUhyd2w1UDMra3I4?=
 =?utf-8?B?b3NMTm9aRFpoQUtpVXBPcm5LMVE2QmxtVnFYcUZEOWFtZTFKb0ZvWnEzWGFI?=
 =?utf-8?B?NmZtcXRDM1VTdjVSWDRObWdVTGZnc0I2aDA0N0pJak5oSFJ6WTNSRnlDZ3VB?=
 =?utf-8?B?R1NEZFRLN0JSNVFYMEdZRTdHTUJNTi9qRDhxa0JsY09JQ0hWWlBaN0E2QVk4?=
 =?utf-8?B?Nml4ZjQwcnVWUDhub0pCcWZGS1VmVDlvRDJjRDJZWHUyWE9kM05scDg0UWlH?=
 =?utf-8?B?RUlsbktLc0NPWXU2ZEp4ZDEvZjZhb1J4SGV3SDA0QUdXUnhjRVRFb0VCOTh6?=
 =?utf-8?B?QkRJRk5RQWMzUWNYOHl3RWl1Ny82aTdFMTdHNFZwUXZDaGkwalFUMjI0YXQv?=
 =?utf-8?B?QXkra0xHVlFvYWsxSWJCLzExSEFzbEJTaVJ0OHhSRndPSXM5eXZGY240cGNK?=
 =?utf-8?B?ZnJoODRIMGxqZ05od0hrb0FySFJxcnVVejBIMDUyYTg2enQ4M2pndlRDd1Y5?=
 =?utf-8?B?RFdaVWs2a2Q4eGl6VlN1cEZxaThFVkZIMEFhdFJwbjVYUmNibllxZGUzNFJU?=
 =?utf-8?B?ZFptSFRlNDJTS1gvNHIzU2pSSVFZTUt4Q1RNMFAreWlMQUx1Nlp3ai9aT3V5?=
 =?utf-8?B?UWRSMG15d2RwMFh3cy9JSnpiK25XaDBzM1BDUmtaS1FNUkNBTFVwbno4U0tT?=
 =?utf-8?B?SVo2QVo0SG9nN2FLYlpwRGF3UHVnWWRaSG1Gcnk4QVNhSmszVHNhWWpJZTlm?=
 =?utf-8?B?cVdRSDArc2JtUjdzSXZCK0RsVTZXL2g0ZG0ydUhDVHdGT2o0RUxUQjRrek9V?=
 =?utf-8?B?RDVJTzViaHhEeHVvOXdaNkdCL2ExUldHK3RFVENiZlpXS3ovNFU3c2hDdi8z?=
 =?utf-8?B?a1Yvd1B5WmpqbVQrREFZSEdPbmhTMytHZzFlYThWMmllL1E0S3RiQkd1Ykp0?=
 =?utf-8?B?aUdsQmxEUzRsY0xIbGhJdFpZKzNtVi8wWjhJbjBvTFVzcTlRVkF3RWk0aFNR?=
 =?utf-8?B?V0lWOHZnZVBNVklmdS96bGlEVnIyZXJLYTlvaUQ2Ykk0MkdGc25zZzZWQ1NE?=
 =?utf-8?B?cEU0eGVXYzJkWjkzRUo2RlJCRmZxZTMwdkNSVXBrOGhabnluTSs0VWhWek9H?=
 =?utf-8?B?bTZML0pyR21ra3VjdmpXWWI5WXM3TFc1blE4eU5RMGo0QlVtcVFsSE1xcm9o?=
 =?utf-8?B?WE96QWtiTHNFdGtyS0NiOWJGT2hOa21NRG5JZTlqbzM4eVljU1VVcm9iVnc4?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cgY6mFmxiSJa7LG1DPhp5taKkeo7tEJvGlyPtRWzDIU9lFxg+x0qnF/Z9DI2xUCSleU6NtiUp4LBRc3oo3J4IWzSSwfNQqg2hi/iHEqcS2Cn4LlDCeZ93k80auI4w6oavuiGjeKSjB+mZps3UoXfL4YsTbJs1M16doQgrIOW/4I/m1y30Pqaq50GfZ1wFjMULlJI6aWn0IUgRUaSOnvW0uvEcU7D8oMpK1UCJBVcU6Vgw52XIHsauY7sm/c1brqvNR3940/ZPfrK4RDrXkaE8aqCUn4rGd5CalMeogZ+8SnfbUC85Y2+dTLmuUWCz+tGiWp7UztMWQc9UVUSMdu2Mozy+PxHf3D8/jrF/28i3K8xIHHPBLRtw64n26hREoDsLent3S2LGuB4NOEkvhl7V0kxC54TXxeUtSBTksywbjId+9RWUX60NXc3+WJWGXuc0OG8NG9PvSRIKMecyDDvBjS6u+40PVVVIBdu5Rp17ddy3IONwvGb2Lm03Z7IOSUsG2YhcTJQAmsPl3/xKHyR7JfGl1R+LETdmbVoHO17y6w1MENcg1qEuLmxerZDVJKDx3QKisXGi+6iDwgM3E1+5dKQEPWa603UCFoX1OsIk70=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d390e48-5d64-4439-8ae0-08dd13a85925
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 14:39:53.0050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 64wlGxyPAFDHE/kVFMsgKSVM8oldSvgMrAysOVufOAMwhZ30UI+my45F1eJbDAQcVCF3IRSD9FWeYKzQnxMeE52IR7TmgDYC3Hgr0mSmz5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-03_04,2024-12-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412030125
X-Proofpoint-ORIG-GUID: 7xihNkfnqDw3VsTXeWJlL3Y6aVtqej9z
X-Proofpoint-GUID: 7xihNkfnqDw3VsTXeWJlL3Y6aVtqej9z

On 12/3/24 15:08, David Hildenbrand wrote:
> [...]
> 
> Let me take a look at your tool below if I can find an explanation of 
> what is happening, because it's weird :)
> 
> [...]
> 
>>
>> At the end of this email, I included the source code of a simplistic
>> test case that shows that the page is replaced in the case of standard
>> page size.
>>
>> The idea of this test is simple:
>>
>> 1/ Create a local FILE with:
>> # dd if=/dev/zero of=./FILE bs=4k count=2
>> 2+0 records in
>> 2+0 records out
>> 8192 bytes (8.2 kB, 8.0 KiB) copied, 0.000337674 s, 24.3 MB/s
>>
>> 2/ As root run:
>> # ./poisonedShared4k
>> Mapping 8192 bytes from file FILE
>> Reading and writing the first 2 pages content:
>> Read: Read: Wrote: Initial mem page 0
>> Wrote: Initial mem page 1
>> Data pages at 0x7f71a19d6000  physically 0x124fb0000
>> Data pages at 0x7f71a19d7000  physically 0x128ce4000
>> Poisoning 4k at 0x7f71a19d6000
>> Signal 7 received
>>     code 4        Signal code
>>     addr 0x7f71a19d6000    Memory location
>>     si_addr_lsb 12
>> siglongjmp used
>> Remapping the poisoned page
>> Reading and writing the first 2 pages content:
>> Read: Read: Initial mem page 1
>> Wrote: Rewrite mem page 0
>> Wrote: Rewrite mem page 1
>> Data pages at 0x7f71a19d6000  physically 0x10c367000
>> Data pages at 0x7f71a19d7000  physically 0x128ce4000
>>
>>
>>    ---
>>
>> As we can see, this process:
>> - maps the FILE,
>> - tries to read and write the beginning of the first 2 pages
>> - gives their physical addresses
>> - poison the first page with a madvise(MADV_HWPOISON) call
>> - shows the SIGBUS signal received and recovers from it
>> - simply remaps the same page from the file
>> - tries again to read and write the beginning of the first 2 pages
>> - gives their physical addresses
>>
> 
> 
> Turns out the code will try to truncate the pagecache page using 
> mapping->a_ops->error_remove_folio().
> 
> That, however, is only implemented on *some* filesystems.
> 
> Most prominently, it is not implemented on shmem as well.
> 
> 
> So if you run your test with shmem (e.g., /tmp/FILE), it doesn't work.

Correct, on tmpfs the test case fails to continue to use the memory area 
and gets a SIGBUS.  And it works with xfs.



> 
> Using fallocate+MADV_DONTNEED seems to work on shmem.
> 

Our new Qemu code is testing first the fallocate+MADV_DONTNEED procedure 
for standard sized pages (in ram_block_discard_range()) and only folds 
back to the mmap() use if it fails. So maybe my proposal to implement:

+                    /*
+                     * Fold back to using mmap(), but it should not 
repair a
+                     * shared file memory region. In this case we fail.
+                     */
+                    if (block->fd >= 0 && qemu_ram_is_shared(block)) {
+                        error_report("Shared memory poison recovery 
failure addr: "
+                                     RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
+                                     length, addr);
+                        exit(1);
+                    }

Could be the right choice.

William.


