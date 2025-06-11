Return-Path: <kvm+bounces-49039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1CCAD5520
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:11:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 508923AC515
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 12:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7E1227EC7D;
	Wed, 11 Jun 2025 12:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RWtQzRfE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="G3UFx1py"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82B22749E2
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 12:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749643857; cv=fail; b=moTS2wylt8tpR5FeYyIXMPLpwsaLAT2ff8MvAXMoq6owaUcV30pxyX6/HkAykYo2F+/xyqDYuiPciqDJuwN6RlJnSkfjjZn/w8VBQcEAbLyWz6jD0haK9BfWxUnbCh0aY2UZF9Ic22/8VbsYFyX4OPcCLbg2ZBkJaXz53ARlx+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749643857; c=relaxed/simple;
	bh=JdmnqjvwSPBJIRGKss7JZZQAdS74V1oO3DVx4yk9Nc8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oQ6yNXBE2txkaavR+hy78sboodw32zG4Vm9j6oI6+4thUI4/7XknyDoaGntbasdnLghb4Uvai0/zk5Mw9TCZOpM8P6/h5faFu8puqsoygev0rT8ih+NImEjrqWuWqtO70x26grcCu6nexJKS81Ns6nAj5R/SYUQ4sKNWAZPCego=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RWtQzRfE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=G3UFx1py; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55B1BbRK030306;
	Wed, 11 Jun 2025 12:10:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XRlF4Sl/3zGevNnuD21DhGTlSP2iJ382CzJArgz5rYw=; b=
	RWtQzRfErYLFqak4LQKMCz9GOesMXVDt8M7SSBH5SsHlpHr9PkcUwLEVmWTTRwlS
	9iY3FhckiNJU1jhnR0JOd23TqQIDwdpx0/QZmghmJhci+httgFnDvbC2yNJgeI4p
	xyKXEmqdubw2mM2tvhJ8XwT6ylNsfHosi6SuDFMQ6CYBIf7eDdsv8yn21mWEp5Dn
	80tgFk/tXe/siL399LUvKWpFU0+TkOsdjfJW6N2S2ZJWJIiaTW0nC2GBkv8dSySK
	piC4YRbTcCJ4n6PJasvUmRnNv6q4kok0+B1ffvFhNpZdZ4NdwsN4zsaWnTO2Vf4p
	mzqQIoOk7sAHGtXfwUeaCg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474dywx7ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 12:10:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55BBogBp007367;
	Wed, 11 Jun 2025 12:10:47 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010047.outbound.protection.outlook.com [52.101.61.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bv9u3yp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 12:10:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PgoPI53ir9onGcALnkK6If7udTYP7wK8Oq3kKhZr7JRWxqa+hykcPmod1MLkjfYu760h+z6L8NBtrKPqiwZfL5tBuYc2Gb1pixCVmL3yI54RyCtkoAema3+E3+psC961tpJPU/DlEcOTAkZibrHo+v4QzWXDhr7ZWFwpvFh5ymx5SyFVc1hYRn7nCAenORIECgIx0UPQoOBYyae+pd6vNvjQWDZR5MjFKSRXbYXZCk9Z/p2v/2f9/UTodY9aOHmck4OJ1gxUNuyRWtpPl8dPEnkEQ2WosK4FB7MSbuYnpZDqFQLVDQKsJc/ZWdQYt5MsRHguI0JX5joWKI6XmStVkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRlF4Sl/3zGevNnuD21DhGTlSP2iJ382CzJArgz5rYw=;
 b=ZzbZ2SWXP5YHiGe6nbl7swF0LO1Qai1q9+YiW8z5SNAk3D3JMQS7wB9v0EaVP3xCb4IK6ni6Ct5JpyNW6Nf7fQnA7CZtGe+Cq5+UJ8bcpZoXH0v0AbS/u7w8/lZ9zr6TqyQcgNucQVzMhFhb6EzP+RQqsrohohLc3bsdVwGA53f2MGc21s5OFYqkM6I5yKHchnv+wkdmT6+pgXpmInpS3Ge73Prn8Di8p7mpOmqEXSzch12Vp0Z1TM0X4WZFUZV1olodniwPeV5+KyC6yM9Gv1tr2SblXoPszfatJ0Aum0GzpGQwJCUdmyDzvjq8KiukcGqKnoJJImX7oU/nXh+QhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRlF4Sl/3zGevNnuD21DhGTlSP2iJ382CzJArgz5rYw=;
 b=G3UFx1pybor+EWjJmizWmAGaF0mtwvgguN0Rp08LtIOO8k174BjxamM5kXG59W7dmavCT/aIDU+mehsxEB7AVvb8wpsKi9uTg14Z7RQTy3zU5rlJpVO1RxIdrHgHx3Hk0cfq9Fm7o7nM+zAxNbR+CuFxdi7VE9AyhE5++JhVBBA=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by CO6PR10MB5791.namprd10.prod.outlook.com (2603:10b6:303:14c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.40; Wed, 11 Jun
 2025 12:10:44 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%6]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 12:10:44 +0000
Message-ID: <aceb42e4-71d0-46af-b652-851ae5d60e4f@oracle.com>
Date: Wed, 11 Jun 2025 13:10:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 07/14] x86/pmu: Mark Intel architectural
 event available iff X <= CPUID.0xA.EAX[31:24]
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20250610195415.115404-1-seanjc@google.com>
 <20250610195415.115404-8-seanjc@google.com>
Content-Language: en-GB
From: Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20250610195415.115404-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P189CA0050.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:659::28) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|CO6PR10MB5791:EE_
X-MS-Office365-Filtering-Correlation-Id: 285fc487-4253-40b8-ff29-08dda8e0fd9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OVBZaWVZa2phdU5NRStsZ2x2ZHRzbWtYamlLa1lyV1lBMjROUmZiV0dVYTdF?=
 =?utf-8?B?Vk1ZTHNQcmI0UnpnWFNFc2MzNFo5M1JaMEZmQit6dXJpQ0N5aVVnTTN5aTAx?=
 =?utf-8?B?OW9EZE9NRGFBMjZkZDI5d1FwNW9UK3QrU2s2K0srd1VVRzhOdTR0cjZ0UEV6?=
 =?utf-8?B?dUNRbUdxZmRBb1ZZOHVhMlNjeHdLd1p1TjZOcUc1WFZqSCtFa0V0WWgrSTFN?=
 =?utf-8?B?bGcySXdIcTB0SGJHT2ZwQnc2VU0yeVpkUitrTWY3UGwwM3M1Q28yQmJ6Unlh?=
 =?utf-8?B?dlB0SWxZUHlPYVhoRk5VVi9weDBnYkdUVjFxajZmemVoL25vaHhBMEhOTmNk?=
 =?utf-8?B?dzhMcDdKcVlYeGFQd1NNZ0d5S1dkRWlqdUY5SVN4dThkM2FkSjlCUUw5KzN3?=
 =?utf-8?B?cUhVaHpDeGdIQ1NJRExlTkwrMVpxbTlYSjRGTmdGaGVJZENRVXNTK240bEJE?=
 =?utf-8?B?UW9EeXZFT041cnA2V002dnlSV2hvTXAvbWl0NXEyR1lrODFFZi9qTjB3ZUxj?=
 =?utf-8?B?cmxteUVFK1RRYWdaWEVTM1JyNk5reGx6dkd5NnhidUg5cS9lU3Q5SDV4c3Qr?=
 =?utf-8?B?T081c2xqRzVkekI5a1M0bzNrQlc1Sm56R1JOdnlQM0M5V013dHlXZkcrTjN5?=
 =?utf-8?B?OVU4TmlTZFNYUWNTVytFMitLZ0E4Sitsd2swOVhFQWI1WmE0L2lFd3cya1hx?=
 =?utf-8?B?dVNSbVdyOGIvc25WMUlJNGlNSDl6YlZodTJYQVI4ZHp6VkVLRSsxTFBpa1B1?=
 =?utf-8?B?eUdEWVhxcFE4WnRvbVFKVFI0cXZqYkZFNFRiYVV3QlF6VTZsZzJsL3V6S3pU?=
 =?utf-8?B?UUVGK29GMXN1SVRWRk1NVnNRREoyZW9YY1VDcHgzTUhmdjF2cCtvWHJQWnVs?=
 =?utf-8?B?RElDd3dIS2poQjhlTHBSbmN3ZjBpYmppRElPMjNkaGx3dkxNSUoyRTFMc2hW?=
 =?utf-8?B?aUtrWVVSOTJmMnA5a3ZJV1cwV2RMYUFUYTE4akttU0dUQWdsaHlPcnJ0d1lM?=
 =?utf-8?B?bmV3UjJRUXdGTXVFREpqZDNlc2FlNVRaNm1TQUdOa0JucUc4bmxhb1RVRlZo?=
 =?utf-8?B?SFZRTGJPdEd2VkdDd1BWbCtHWml4bWFTUnRkUWlIU1IrTHZwUXpTS1ZYZWZN?=
 =?utf-8?B?VGEvUFZBOFJWUmZwNEp2U2d6UzRJQ0FDdUx6UXphWGVUQWNhTGhCT25MTHNm?=
 =?utf-8?B?dS81cE5vUExqT2hRM3ZHbXpSRHh1eEZxeDBzM1dBdkhod1QwZ2RNbWNZQy9K?=
 =?utf-8?B?bWgwMWlFN3M3ditMS0hGQStnSjVCZGFTckRwakVRUnVHQVZCNmlzZ1JjVjFW?=
 =?utf-8?B?UVBFOWFUa3VZK3pBY3RuTmJMNDllWklTWTFOdnVXR2wwUlpoaTlLOHU1WlJF?=
 =?utf-8?B?QkFCYjFzVVNnUm5FQVJYdnArUTVYNHJVU243MHBPVG1BbG5BOE53VU9XRm5T?=
 =?utf-8?B?K0VTcGUwVkFTbEYxNTZYVUJtT2orMGY0d25KeWFaVnloUlFOQXVNWGR5dEhh?=
 =?utf-8?B?WVBpT1N4eGZ1NXZ5c0ZhNTJtVDRBSHhnZDJWR1cxNStPeU9mYWUyVk5uWnJC?=
 =?utf-8?B?clhGQ0h2RTJLOVo1eHNnaGJrZmtobHg2V0gxM2tJYVpxRDQyaUFhbldtWDRv?=
 =?utf-8?B?ZXpiaXRPOGh0ajdEZnVYZDBBbmd6bG1NUU9JbGs4d1VVRzIvbDFHYkt2alMx?=
 =?utf-8?B?U0N6Q2xiVm9uWnJkbHkxL1dLZ0x6d3lFS1BPV210UWhqMkZLQy9pMk03MUdo?=
 =?utf-8?B?Rk9rSkVybFJ6ODJLWGpleldLdWpEeS9zN1NxcGJZWFJPTjlpYWFqS3lrMlkx?=
 =?utf-8?B?S1ZFdHpab2prYXhubmdXZkZ6R3BULzhRTTRpT1RzUmlQUGxXOUs4ZWl3alB2?=
 =?utf-8?B?MnRqOHpMWnNYMG04bGJXZ21MMHR0bG9qWllLQy9pcSsyUDdZRlllNkF0UW4v?=
 =?utf-8?Q?mCKQIvnx+XU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SENnR2lUT2ljVnAxVVV3aWJBNEEyNnBlTit1L25Ga1M3U0RXQlFMVzJsRmJJ?=
 =?utf-8?B?ek52SWdKQU9BUitLLzQ3ZUxNb25zODJkeXhrMDZRTk5wdERpOWFjbVdUMUdu?=
 =?utf-8?B?Qkl5UUsxUTFmSFJhSFpyZWFvR0VITnF0TWdaYnVjMWlyV1o3bFdMWlAvaWJm?=
 =?utf-8?B?NGNnVnJyWW11cDFXUTI0WTdlVnphQ2NvTHNpL3o1Y0c2dHMxN1BDajlmWDVW?=
 =?utf-8?B?dEVwYjRUOWZNL0pHeTgvR1VMOVh3eVRFcXVoc0tWUWRycFFpNFRrSzl6d01C?=
 =?utf-8?B?c0hsMDd3VDRDZno4bjlyV0RZNllHcloxNlBZdmFFSkJHcis2RW5FMEgwT1Nq?=
 =?utf-8?B?UlRVRnhGQzU3RnltUytIb2RRUTdBSVF6ZDAzWlE1Nk5sYlpyYXVPSTI3MHRk?=
 =?utf-8?B?K0R4S3g1KzUxbTlFK2RBamRBR3dmNDB6WHI2cldFU0VwVjFJVmQwblpCcG1x?=
 =?utf-8?B?VUVjQU5lSlVsT0pCKzlGa05PYU1oY3ZGT3JDL0pVYmdUejg1blU4cnBEY2VC?=
 =?utf-8?B?N0dhZGhlZDlnWS91UkhPZ2RsdGhoVUVKRHZVQ3IrdWFXaWI0KzAwTkIwUFV6?=
 =?utf-8?B?L1BERm5FMG9UV3k0RXl6aUFEYytUZmpaVDQ4aitmb0l6OEU2bkQ2aW1HUEZt?=
 =?utf-8?B?SWJHMTR2cysvVGE5ckRHVklHZ2ZjZzFyWVBNTW5EK2ZsVUY4Y2RSZjdZMzR2?=
 =?utf-8?B?bmVOR2t6eVExY1Z6ZnJ4OE10YkpJd0xweUFUNlBDeTZtclpFaEFyVEpJcDRt?=
 =?utf-8?B?Ni9sT3FUTGxST0pMdy81b1ErZVdrK3VMVkk3SUVFL0Q1ZHhlOGxFcXFjYmNx?=
 =?utf-8?B?Skl2L250WnRpUVkrN1FIS1ROQ01nR0RwN090VUs1dEloR0xpaHh0TFVQNStz?=
 =?utf-8?B?R3JOZ0NYMGdseXJadTA0N0RDc2ZKY2lvK21wbC81VTZITnVFOFVwc01od3FP?=
 =?utf-8?B?VmIzOTZBeTVOTy9PVlh2cFNTWFNaSzhReVJjYnh0TnNlbFNTZjhuYldOa0dF?=
 =?utf-8?B?WXZ4U3dwVFhBR2t1cGFHb0t6eEl4ZXRERnptY3VPbkNSY3BDUHRDWUtZTEZF?=
 =?utf-8?B?dCtUOG1GSzNkZ0VLbG13OXhUaE80SkZReGRSMkZIN2F5MElyRW5JN25OUGhG?=
 =?utf-8?B?d1Bic1dtWk9mVzJvdDhJK3UwZ250aCttSVh2ODFlRnU3L2dsQ0tIZ2ZYVk0y?=
 =?utf-8?B?VndjRnpPVjdsTS96S2wvdnVGWjEzUWlFM1BSQ0Z0bS9KSWhRVUlNcTliNHBm?=
 =?utf-8?B?UUVlTFpkeGxGTUJCYVcyU2VkVG1CVzdpRTBQeGdGdGozSFVKK2hIcDR5ZGdk?=
 =?utf-8?B?K3F4bmFWVFpLVFJhbHQ4aS9Ia1ppY3JtRHQxUmFORnlzdERlN2VxVGdSRHdP?=
 =?utf-8?B?STJhY0E4QmViU2V4aW0rN0poaXVMYTRwUWdTZ29qdWpFUGV1dkUwaklrVzVF?=
 =?utf-8?B?RjNOc2tpMDAvSkJSdms2THRnRTVTejR6dENkK2VyVmJLbGJ2RWNoekJxdi90?=
 =?utf-8?B?T0FYNHdJSUs1N2RqUUJxVHdTRklZYWZNQ2l0akI4SFQ2dWVISXIzYXZETVo3?=
 =?utf-8?B?SktTblgrZmU1MFBFVU50czhmQ2c1UFRJTE5sWCs5ck1ubjR0bWZuNm5WbDNZ?=
 =?utf-8?B?Y3dEYTFGajJVdzNvZVkyUmsvTXRVVXRrektEeXBLSXdUWnJRNUpYMFp2aU0y?=
 =?utf-8?B?bHJ1c3YwWGd3Y29NVnhLSnRISzNGRUxRUUp0TDdDV2xJOGl3UHhld3M3RmVT?=
 =?utf-8?B?cmRwcnNnSzJ1RzVIK2h5bDhZRWpxZjduRlZPUVpwQk5xZ0d5MXkzR2h0ZE83?=
 =?utf-8?B?ZWh1eVE2bFBvUDhMMXA4cmZQTVNwV2h4Si92Y1ZWaGVlS1BFT1hzaGRVNWNJ?=
 =?utf-8?B?cnh6R1hIeWxSaTBaeTZ1UVh6RnBNcVViUm56ZWlkUDNaUkt2WTlmcUR1S0or?=
 =?utf-8?B?dStISmMreUR1a0FXNEN3akRaMGxKNDJMWnVab0UzSVZzZ1JxWHVtR3daV2d4?=
 =?utf-8?B?bHFyMUdLZVZScGVtZG5iUjcvVEVkbVZSdHcvN3UvUTJaRXdVNS9mVEx2Y3Fp?=
 =?utf-8?B?Ujd0OUUvaFU1cVRUeFdmbExrbjZsRXVOQzF5dmJqZ2ZibEpIVlFEUi9IWWJh?=
 =?utf-8?Q?u1GpCA43bL0tsBlwFuDYtJytQ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OriDXj4AwauRERbOZXAWh/LGKpCMJ7NkqVXw3LY9bhl7PhWO7n9PITfwsD6PtI2b5IK33tNEKsmChHlzwpTF+FCGXhbQvIoItLdBNcWkSNMfNltCcaFNgAMTouM6U+o88M9jyjmmRRyef4hx6c9qPuHCoKu7slxcCchC4WBer4u4kyphY66ZImsHt4RBhY4w8O2ReUhRfzX+IleBJ5fm7zt+cdnebOmdkjHaj3xbfINC8bz6i32vF2KZ5/DtMwTgzFhp0m5HYQJd3IJqW+tDFyLj0a2Nhg/iQrML0kvqGGvxn9E80QJsB3kEuhMAbqVB+Tk20vKMacQ2axkHZY5t25qoywUdE+7hBHQgc5Hs+v+N9xNZ4z5sJow6Fuyhp2ROidnTu/jhIcKdVxm4yXEqQbd90hDfKvM2PUWRITc2v8xdtaevES8tOCfgGFdjUz28t9bqwFl+SClUI9M/mqecKLDdBTjmx+CCX0T0DKSRpXoeYVn2cpryGtanqWV5DHQSRNAis90KeCnuzBS0ZQpAXbrXP8/jbIDmJMcrBW+b0T/iu8Uf2X5nnIx9asOWY1W+8b9NgyhO/9sbM0kyi3EjWzFjjTcqzAjtWEcAR6ZPhCk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 285fc487-4253-40b8-ff29-08dda8e0fd9b
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 12:10:44.6785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7KSQYDOAidZrCo25m7v9IDIvhBAxCgTWoUhVoyjlk8+wwfpk5p3aOaDp+V4MFSfBGQRjB/KDsN6oynaZQm11g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5791
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-11_05,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506110104
X-Authority-Analysis: v=2.4 cv=fdaty1QF c=1 sm=1 tr=0 ts=68497248 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=QyXUC8HyAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=E7cv1es_hfGnMRjpuWEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: pHw6xgXYDe06dMHBtSvN24QAbTBF_tir
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjExMDEwNCBTYWx0ZWRfXzlUizhJdq/Vk ZbiCx8Y8cjJevqASLQmvuSj7+P5H2mnzuNWwi4lihe8bv4m6UU5UrAMZrm25wcZEb1rzZKI+4M8 YYyRz4kce8KaPkgOVoa3RjzNV3A+pZvfw6BCDhKixckSh3ZdjH8VjGnayC3YmwT0CGDGojY+t0F
 tv1lCC6Vtacw8UjaIS0rSK6sotX73i9QwQY0qpMPriLqPGxTHUUmlCMv2Vq7xLDlu1oK9t/+Lw3 wjhFrCxQsEAEMIyq1st827kqk7JdmG6LL4cZhISQunTKBd1I5pcdHxXgxCVrVCuqJuHUgS+2xle m+TAgNmuV7lUVA3NYqwHTmk/7GRxKaQAAd/n7hB1/x5VkByPpoUF0OBLkU90zlIwla4DoEwlJR9
 2XW2wNuCQ/g9pcwCSH6GGBsfvrREQa9POhC/D6fPFaIk8uJMIjEt9pTzMqzdIu41roFDQ6NZ
X-Proofpoint-GUID: pHw6xgXYDe06dMHBtSvN24QAbTBF_tir



On 10/06/2025 20:54, Sean Christopherson wrote:
> Mask the set of available architectural events based on the bit vector
> length to avoid marking reserved/undefined events as available.  Per the
> SDM:
> 
>    EAX Bits 31-24: Length of EBX bit vector to enumerate architectural
>                    performance monitoring events. Architectural event x is
>                    supported if EBX[x]=0 && EAX[31:24]>x.
> 
> Suggested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


> ---
>   lib/x86/pmu.c | 3 ++-
>   x86/pmu.c     | 1 +
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
> index d37c874c..92707698 100644
> --- a/lib/x86/pmu.c
> +++ b/lib/x86/pmu.c
> @@ -21,7 +21,8 @@ void pmu_init(void)
>   		pmu.arch_event_mask_length = (cpuid_10.a >> 24) & 0xff;
>   
>   		/* CPUID.0xA.EBX bit is '1' if an arch event is NOT available. */
> -		pmu.arch_event_available = ~cpuid_10.b;
> +		pmu.arch_event_available = ~cpuid_10.b &
> +					   (BIT(pmu.arch_event_mask_length) - 1);
>   
>   		if (this_cpu_has(X86_FEATURE_PDCM))
>   			pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
> diff --git a/x86/pmu.c b/x86/pmu.c
> index e79122ed..3987311c 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -993,6 +993,7 @@ int main(int ac, char **av)
>   	printf("GP counters:         %d\n", pmu.nr_gp_counters);
>   	printf("GP counter width:    %d\n", pmu.gp_counter_width);
>   	printf("Event Mask length:   %d\n", pmu.arch_event_mask_length);
> +	printf("Arch Events (mask):  0x%x\n", pmu.arch_event_available);
>   	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
>   	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
>   


