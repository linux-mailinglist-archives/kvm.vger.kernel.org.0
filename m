Return-Path: <kvm+bounces-42185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE220A74EA5
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 17:42:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D19C1898512
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 16:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF921D88AC;
	Fri, 28 Mar 2025 16:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NhzaQ+Na";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OYrJPvPU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF7E2AEED
	for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 16:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743180165; cv=fail; b=KHTfjmihSll+paZ+v9EoHGKFofLNAO+F0qcfDpkj1RbWxf95upseVg9MUrbd8aAHeRVqil8vyIGe0L2lA+OIqWJmcgI0BPoEzHZ0VmdWT8450yR4YSjQzAmICXJ8IkqDo9izrJBTg2/zNR6tTZfW6BG93Adg2XvlHrygSuVrmT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743180165; c=relaxed/simple;
	bh=qU8hOQMao2tgHr2TOr/clIyau+IU5PNQ64PZTQz2Xn0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kxldNFw7E6GbP9B7ktdOvPwKJSImKWvjT1XSxfzqT9ko2i7F7o4YcfZCM+E2JaRy6zX29lgea+YYGfqMlDw1srkRgfTyS28YCx/OqdJJ2gDl14qTHjkzdjpAOYuKP71K4PWpQEbYN3poEFgkMXYtN5QUqf8chJyt8MXufAjXdik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NhzaQ+Na; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OYrJPvPU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52SEtIUZ029226;
	Fri, 28 Mar 2025 16:42:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=lpM23Gky5GVu83y+6rN7zAE37YnTOrNKrEDt81v58cM=; b=
	NhzaQ+Na9HZg+kpN529hAQkznaiFbsSpI0DKSARrQsm1MVTfhClUYLPAEuwa2j3Q
	kpXIezoUv2OJ5vrFcw4A0jvT0upAhPl6h+onxCujXn2E2A4QLA2iZEqF20SEkvyy
	z4ETYl0JDVAbdJiDhGYkK8Zv5PEIiRq+hDk3iS0McCnU52u/12CcLHmz6neSaehj
	tvYPMsD0hnyserWzwzstv1ZeT5F+RYqHYRUD0O+vUjTj+59tg5Ot54tO6WQE4Csl
	5bmNJ8UocCis2CnM6vicNQxMh/fokMa4Po9+9WfKaZjoFDY4Ne/JXvKmUTLoOioq
	JIbbcMrBgkdpZX2YTcBt2A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hn7dy6q8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Mar 2025 16:42:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52SFMBKQ037009;
	Fri, 28 Mar 2025 16:42:08 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45jj5gwt8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Mar 2025 16:42:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KYgo3F0plqsH3Ps7LG+kaX+eCV/LFFP7rqXKmc4Tw01q3IcYyhQdG/wpWz+/6zmhX5twkgiY3z65aHLN1io76dLLdcYULsn7zZM2cS0Zcli4WWRGC/d7qjbtyvv9+vSHzLDf436VP5lMziXv5macNRogrhu0mG628i0XRlqr+eVnXj9trviiq54iQ0Etzc3nVM7CrOpDXA9zcpb2BljMRJFjug3vCUJtzaCkjCGrna11/rAFgcr4a1uVRY1/6Mt/JZ81UXZY2tHYmx0jhQMqufbfoikg3f2P4Y6bFiTUPel0aw/CoTPpH7SpvsCydcCDUgkzgRtKzG17uzG2JggjmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lpM23Gky5GVu83y+6rN7zAE37YnTOrNKrEDt81v58cM=;
 b=lI+3lByZiCsVXeG3ur3gofC9DMxTM0lY0E7aUtQAjwaFLP4mLKiW7GriGynKEeDnRvair/WgbuhBfgn7cr8tksUh2XX5X2wsjl7Q9GxxnUCalwbKzWJIbhv7+3VxWXKUcw9tVjnMmvccWbkYKlul9lj5Dr014GSP3a13oVXEtDZdLjFMKMzLcy35vqHRVsL2i89GTQIhRc5Jcu8rpLcinBQEcu1ZXhsI6Sj4EM6X57tkez5cZogCI+O1QXyYTPzG7M4DhYbnRupGdyeQwb0frMrNtlKw44mBKiFI4VNipSZh2zzKJITCg3Zv+cMUeU/YcpQ+Hxq9mQHmiv163iUVdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpM23Gky5GVu83y+6rN7zAE37YnTOrNKrEDt81v58cM=;
 b=OYrJPvPUzHtWwDhMr2heFZVR9hKjoM5kteRPL+PfPisMs8sqLzQJae0Vhl5JziDjHtuc4BSBaCON9uo6eWB7T77DrXcuUu6cRQSlybmr5J+3bMQr69lc4ujhyrd2XjR3aWfJhcASnDrkWPSLFoBnclckHmirNpGl1ERbPuCc8Is=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 PH7PR10MB5831.namprd10.prod.outlook.com (2603:10b6:510:132::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Fri, 28 Mar
 2025 16:42:06 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%5]) with mapi id 15.20.8534.040; Fri, 28 Mar 2025
 16:42:05 +0000
Message-ID: <84653627-3a20-44fd-8955-a19264bd2348@oracle.com>
Date: Fri, 28 Mar 2025 09:42:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
To: ewanhai <ewanhai-oc@zhaoxin.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, zhao1.liu@intel.com
Cc: pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
        babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
        zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai@zhaoxin.com,
        cobechen@zhaoxin.com, louisqi@zhaoxin.com, liamni@zhaoxin.com,
        frankzhu@zhaoxin.com, silviazhao@zhaoxin.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-9-dongli.zhang@oracle.com>
 <8a547bf5-bdd4-4a49-883a-02b4aa0cc92c@zhaoxin.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <8a547bf5-bdd4-4a49-883a-02b4aa0cc92c@zhaoxin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN1PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:408:e2::31) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|PH7PR10MB5831:EE_
X-MS-Office365-Filtering-Correlation-Id: eef6aefe-70cf-4b1b-d651-08dd6e177952
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Rkl2UTFUVmZzcTJNdTZJVjlqdENlN2gxVlIxalI3a2o3NEtPVUg5UGdvaVJW?=
 =?utf-8?B?M2YzTnNrenAvWkh3eGlXK2g3Y1I4QzRidFZDNHl0Y1ZjRXhPUzU3Z0lTOTFP?=
 =?utf-8?B?ekc5dTNYeGk2R2pCODJwZEd3UXpIZmxCRkRwaTZBeGNray9BYmtEK2oyTUdV?=
 =?utf-8?B?R1J1Z1FRVkFoZWljejh0N1U1b29zbFZ5TElxdVZEdGpqN0VZQ2MyQmd5UGhO?=
 =?utf-8?B?UmVGYTRncVBUaDdFN0RnbENFVmgyeXZGcWthaytSUkY5eWNINlFieVg0cGNy?=
 =?utf-8?B?R2VwLzY1NXlCK3poZzU1TlNtYTh0d01MZFlwdU1kMkdVVk85aCtRaGRjWTRj?=
 =?utf-8?B?Ulp5WjFvMVRDU0FvZm1EY2R3WUVCTnc4amwvR2lvNjk1ZGxsNzJIQmUrOWFw?=
 =?utf-8?B?UFF2aTJRdWJLOHM1c3QzUDFyRHpwSk9YdkU4WjVRWHJWVFhnYWhqeU95a3ZJ?=
 =?utf-8?B?WWdnVzJUY3FlWXJaUXI5R21MRTZ5MVJiQ1B4eklPWUZsT3JrUVh0MlRYY3BY?=
 =?utf-8?B?NjhPNHlRL0RQYzhTR1pKYjRnUkZCOWxVNGZXVTJqM3RnZFhDWjhVa3EvWGQx?=
 =?utf-8?B?N3U3Unh3VFNBRDlqbnZPcUg5QnlIQTJQT0JPWmovTFZ2ekU2bHN5eWx1MFFp?=
 =?utf-8?B?WmhKOEhKbFB4Z29ISTlIckphRElnMXpkdncvTFBFZzFsUUN5UGR5QzBiejV1?=
 =?utf-8?B?T1cxdXV5djhtQktFNGlPQ3F2OEtYWmRhaUhIYnNXejYzM0pOZGptSGFVRlJ6?=
 =?utf-8?B?Mkp0dHVDY0o5dnBjbVhBM0JtaGFxeGlqbklOVkFaY0V2M0pPUTJMTG14UVhy?=
 =?utf-8?B?YVRGT2V0amlWeGtYK1BZTDRDa2tqaXpzNnVQSWxMbE0xdWxCRHU2Y0lKVHhr?=
 =?utf-8?B?YThyS0ZXS1BPQlpxeUJZQ25SSkhmUVBSQWJwK0Z2blpuZXhRYmM0bzhsNEhT?=
 =?utf-8?B?TVR0MDBlWWpVY20yTkcxcGszTGR6aSticERsc2kyUjMwcTVQam1qRlVxNzRv?=
 =?utf-8?B?aEI1SjUxNHNoVTZZL01jQ3dDT2FpdERmTlRzS2V3WUk2S2IrS0xOdVpOZlc4?=
 =?utf-8?B?QVROS3g2OHYxVWJYQ2JaODROQ2NPMHVMNnVhb1VoK1BzTzZsVHIySnRaNlUy?=
 =?utf-8?B?V1VVdWhTQWFBWG1rV1g2LzNLNm1XN2ZJekQ2L0lxelpTMlBMV29BRkwvT3BQ?=
 =?utf-8?B?R0VOd1ZCQkNidXRiM2I4VkZPa1JRbVBZNWFxQld5UFV5RXBZR3NmVnJ2RFRj?=
 =?utf-8?B?bXQweGRsaEwzV1QwaGxwdGVza1FaTGFwdjluRzNnY0FKYWdMaHRyWERYRkp4?=
 =?utf-8?B?S096M3N2TGE3eDg4S1UwSmdpV29rQkNJMkdvUUE0c25Sa3pEOFl0WmxwRk1u?=
 =?utf-8?B?SS9zR3RxVkxjcnR0cHk2RStzWkRKUzFvSGZOMXE5VXNPSlY5RE1EeXpaalh3?=
 =?utf-8?B?VzRWZGh5WWFtRENiRXRJRytGSnhyU1pOL2NoWWRaWmcwQVNZYVVWNXY2VXkr?=
 =?utf-8?B?dTBJckx0NTRhVU1JVXBWNDVWSFFBWnYrZ1VjSHJxTVNwS2cvZ2hKR0V2VG8z?=
 =?utf-8?B?K1RPdzJuUjhKSGp0TVIyS2JUSzI5Zk5OcG5kMklXT1cxenFoWG5NSHl3d3hH?=
 =?utf-8?B?WkQ2LzNPUTNzMFpRSmxqRVY3ajlObldGOUt6b0xjbDVXUnVKcHk1R1BFTkl4?=
 =?utf-8?B?c3pHTTNOa284UFgrZElDVnVVT1BoV20rbHQ1WEJUaG5GbDFaZnlyS001RURH?=
 =?utf-8?B?ai8zYUpyaGF4UFBRM2w3MEZlZ3ZuWnpicjU3UWZidjkwcEpVeTVQRVRnM1dv?=
 =?utf-8?B?azhpbFZrNDNmeFlsTVh0YkRDWGtsbjJveExmbmFsZ2dCZHBoV2RLTEx0dWVY?=
 =?utf-8?B?b0JrN2NyV0wzeFpGcUR3RFVaL01MbUxETFBLNStYK2JWVm5XTFJIcTBnSGJF?=
 =?utf-8?Q?MLxHI2f4kow=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3ZoRUVTQzVaS0dTM1RDZ1hEUWZhVnhBdmhsZGRWQ1d3Y21JNGpWcFZqeTFo?=
 =?utf-8?B?QTdnQ0NhMFo2WnFGR2IwL1A5ZzhQU3c1QzhDQUtHemtsWlAyMmRPWEx4ZHdK?=
 =?utf-8?B?cThERU1JMlplMkhiTHlXbktUNnZwYmU3WmdLTEFWVUNFMXZnd1lvTm0weW1Q?=
 =?utf-8?B?NTlQMGRnK3RjL1hwSlp2WGNqZW1PbzAyWDExa2JzZ0NjK010eGRrRTBCcVRW?=
 =?utf-8?B?Uy8rOEFDTXZ1Rk5VOGZZeS8rTll4N2JQb0Y1YnJwT3RoL2E5UE9xOGhzTHdP?=
 =?utf-8?B?RFhWT1IxdmRTeGZMa3hqRFgwekdvTEgzQm9qVWY3QUp2ek1nZ0k3bmFNczFD?=
 =?utf-8?B?Vmh1dHFLTjQzZEtLd0xaUVhQQ2RTc1VkSXMwd2xnSWtZblVZZnZJdkJJVU4z?=
 =?utf-8?B?dEZRRDE4SnI0bUhRS2JkeVF4bnVRNGhuM3VDbTJmTDAyQVkvTHVobStZS0My?=
 =?utf-8?B?MndoWWsrSHlISU5jWnc3aUhiM3JUZ1VUa0xFL3M2T1lya0hrakY5K1QvdU1h?=
 =?utf-8?B?dFNhWjM1dHpKMXBML3pGZjFpQ2txaFF6TkpsTG5BYTJZeDk0V0hWa3ZIcmlk?=
 =?utf-8?B?QzNyajJIZGdYZ3dMa284aEVicG5PZ0l6eHJoeFFMZm9qK3lGdVdTT2loYk9z?=
 =?utf-8?B?QURNTVN2ejBrM2hlQ1c1T3RrN2t4TXpxVFF4d1Z3VVJsVitRZzVqL0UrV2lB?=
 =?utf-8?B?a0VmNmJQd0prZ0UyRTBabnhkV3NvMWV0UHIybU5mbnZZQldGakxOaFdFb1Bh?=
 =?utf-8?B?a0w1LzBacG9yZTBSQ01Kajd0ZlRMVmFhcjlSdUE5WkxqemR1dFc1MDhrMzR2?=
 =?utf-8?B?dzQwR1hndVVtS2RVZDlNUlFkMzVyS08yL1ViSEhWTXZ2N2R2VHVKaEFFQ21w?=
 =?utf-8?B?Um5GSlJ3eURhZHlMYjlTRFc5Rlk2Q2V5ZmJ1cE4zM21WcUJHMzM1cmlvbG5y?=
 =?utf-8?B?T2JPdUFubmdQeEZBQ3l4ZndmaVg0MTlQRHpZR0FwZVdpcXlTa1VUakRnWVlq?=
 =?utf-8?B?NnhLYlpvTHBqc0QxSEtKUVFDa21ZTVM1S3NKcmhHWlZxUno5YlRHakdCN0xM?=
 =?utf-8?B?bFZ2bnV4NDlzR3Q2QXc5V1hnOU5WdnhEdWoweG5OdmwwRXlsclJ4U2wvY0hx?=
 =?utf-8?B?c1NwS3RQNFpreXNBU1Nyc1hXbEU3dXowWWRGcXFqTWFqTDl6TkVQbUFRQXVL?=
 =?utf-8?B?THRuOE1aeXQwKy8zVkNBZld5M0ZGWlNRSTZiRkxkaWFCa1lGdVJ0SkdGZWpx?=
 =?utf-8?B?RnB1UEdRL2ZNS2RYd1NjcFRpVys0RE9kMzZWQk9VS005LzM3eDhEaVdtNlV6?=
 =?utf-8?B?NEEzRXFROEJ1TDU3NXU2eEt1NFZidkZpRjE5eSswVUVBQzBqcU9tRTRkMVNJ?=
 =?utf-8?B?ZVNhSUN4SDZ3UXQrTmpITGdZaVFudFFSZlgwVWVpb1NMYVQzQjBjMStFdXZ2?=
 =?utf-8?B?NEp4aFJlNWlTc2JMMUVUREQ0cE8zOTBpRjZ1M2hQVVE5QnJBU1AwKzRKK1Vz?=
 =?utf-8?B?ODlmZUx3cjF1Y3dBZGxMYWRXRVFwV1VIR0x4MENSNkVZcEhZd1M4S1Ewcm84?=
 =?utf-8?B?WXpOL0FuQTVHRG5kYncwUFp4TUZEWHdUeVdxR3U5QVJlYVBDSUk2bHlFQUhV?=
 =?utf-8?B?TlJDcC8wUWRaMG9iUE51eE5PYnJZbUFkU2I5aUJwZjVQYjh4VitTcmRuUWZX?=
 =?utf-8?B?OXlkSHpuZFRTZHkwSUtHTGJPeGVWWTU0NXJjeFNLd1BhSU1zN2p4bEkxYmxv?=
 =?utf-8?B?VjhTL1FzUitqaGRwN0huN3A1UjdzNUxiODVRZ3crMkljaVRZMkpiQUlsM1pU?=
 =?utf-8?B?WDhGcTBScTlaT1ZQQ2hnRTRmYWNOZm9KcGNUaWIrNm40Qmh0MUFMU3RUcHkv?=
 =?utf-8?B?d0hvNFZyK1pKNmhnMk5tdUZHcGovWnlNN1huZTBkNm5nMi9XU0RsdTFDWGoz?=
 =?utf-8?B?aHlSRm9CSVY1TTRaTTFnVzVzSTllWnV0MnI2YU5oZXVOOFVlNkFaSUJQZjcw?=
 =?utf-8?B?c2Y3NC9HN0RIOVFkTnNVclNvQ2NlUXhYSkVnb0RDbGRUZzg1eUlISmMvNU0z?=
 =?utf-8?B?ZTg3U1J1aVhBZXhwcy93b1BHK1Q3ekRxRkRiT2Rrd2JUby8rTVdzVlVGaWQx?=
 =?utf-8?B?Rmo4dkdBWVczMG9GL3BJVDJmSDNibDJBcDdlM0lkbHpVWVlmSGhIRWJJTVpv?=
 =?utf-8?B?YkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Emh6P9+8s85diH1P+eNLZd48JjkIWVDg13cLBBeU9kCNb+N5/dxiLLoCAn6fVB5L5Up9MLbEaJApLvk0UIQ7fRKGYLepvm2rRY8GBbs/dkk6bamqRTdbB4M4AxdPNTjZEi6CnyeM9mk2Y8QyjseQQQR/bEDtmTWXi8npZa7BOB4okCIKHS1+QtIn42p6dHSAivZ4SMAhb1OZN6cU/Yn3q3cIZoFH20UeJ9V7v1Tb3PKqmdkCSPovkFINnKs8I+T7jkFkJ0gsrWEUlax+jA3Nyz+XCXZeattBJbjyQK+qRkBCqQriVPxWzHIK6ZApVdPAgNfdWRiuoEryvM1URSMjrUY1oikIbGdE/TZVkjAMwKXqi/ePMJxTyMJhgdhXcgttx/5/qfPKPX55tXrRvoKDY1pzplPW3dUZ4CI1Q87uE1c/nFL6vYq+ucAJhFB2plUqIIyO57c3eyVtvSl1mMy9KqmIIQigEbPzTSY5CGMZvT90xaLJQVB6V3u877IVUxwnr4qgmLR5kz+KN4GH+JtQ+EA9Mcg1qW1Q+jks2a/nu60wXg7mj19Wxik1lv7VgeoWMyfN51zTD2eFT/+N9sEutP1EqjH1iLrRFrTDh4gkW1M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eef6aefe-70cf-4b1b-d651-08dd6e177952
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2025 16:42:05.7877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7VnEAUP6neLXZFhAEsPvO1al/zXSQwa7Lf9YoQ/RJEClY8EJiLQMzZkA0Od0IwrpHZR/NGN68RzgmTBCGHVSMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5831
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-28_08,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503280115
X-Proofpoint-GUID: UF_PJfqX6oRFsfhDTT4AuOSqTt96lfMo
X-Proofpoint-ORIG-GUID: UF_PJfqX6oRFsfhDTT4AuOSqTt96lfMo

Hi ewanhai (and FYI Zhao),

Thank you very much for suggestion! Indeed recently I am struggling with QEMU
and Zhaoxin. Please see inline.

On 3/27/25 11:29 PM, ewanhai wrote:
> Hi Zhao,
> 
> Thank you for pointing out the potential impact on Zhaoxin CPUs!
> 
> Hi Dongli,
> 
> Zhaoxin (including vendor "__shanghai__" and "centaurhauls")'s PMU is
> compatible with Intel, so I have some advice for this patch.
> 
> 在 2025/3/3 06:00, Dongli Zhang 写道:
>> [snip]
>> +
>> +static bool is_same_vendor(CPUX86State *env)
>> +{
>> +    static uint32_t host_cpuid_vendor1;
>> +    static uint32_t host_cpuid_vendor2;
>> +    static uint32_t host_cpuid_vendor3;
>> +
>> +    host_cpuid(0x0, 0, NULL, &host_cpuid_vendor1, &host_cpuid_vendor3,
>> +               &host_cpuid_vendor2);
>> +
>> +    return env->cpuid_vendor1 == host_cpuid_vendor1 &&
>> +           env->cpuid_vendor2 == host_cpuid_vendor2 &&
>> +           env->cpuid_vendor3 == host_cpuid_vendor3;
>> +}
> Should we consider a special case, such as emulating Intel CPUs on a
> Zhaoxin platform, or vice versa? If so, maybe we can write a

The vendor and CPU are different. i.e., if we use Zhaoxin CPU without
configuring vendor: "-cpu YongFeng,+pmu \" on Intel KVM.

The CPU is Zhaoxin while vendor is still Intel.

The PMU selection is based on vendor, not CPU.

[    0.321163] smpboot: CPU0: Intel Zhaoxin YongFeng Processor (family: 0x7,
model: 0xb, stepping: 0x3)
[    0.321996] Performance Events: generic architected perfmon, Intel PMU driver.
[    0.322867] ... version:                2
[    0.323738] ... bit width:              48
[    0.323864] ... generic registers:      4
[    0.324776] ... value mask:             0000ffffffffffff
[    0.324864] ... max period:             000000007fffffff
[    0.325864] ... fixed-purpose events:   3
[    0.326749] ... event mask:             000000070000000f

By default, IS_INTEL_CPU() still returns true even we emulate Zhaoxin on Intel KVM.

> 'vendor_compatible()' helper. After all, before this patchset, QEMU
> supported behavior-similar CPU emulation, e.g., emulating an Intel VCPU on
> a Zhaoxin PCPU.

I did many efforts, and I could not use Zhaoxin's PMU on Intel hypervisor.

According to arch/x86/events/zhaoxin/core.c, the Zhaoxin's PMU is working in
limited conditions, especially only when stepping >= 0xe.

switch (boot_cpu_data.x86) {
case 0x06:
    /*
     * Support Zhaoxin CPU from ZXC series, exclude Nano series through FMS.
     * Nano FMS: Family=6, Model=F, Stepping=[0-A][C-D]
     * ZXC FMS: Family=6, Model=F, Stepping=E-F OR Family=6, Model=0x19,
Stepping=0-3
     */
    if ((boot_cpu_data.x86_model == 0x0f && boot_cpu_data.x86_stepping >= 0x0e) ||
            boot_cpu_data.x86_model == 0x19) {


From QEMU, the stepping of YongFeng is always 3.

5502         .name = "YongFeng",
5503         .level = 0x1F,
5504         .vendor = CPUID_VENDOR_ZHAOXIN1,
5505         .family = 7,
5506         .model = 11,
5507         .stepping = 3,

Therefore, I cannot enable Zhaoxin's PMU on Intel KVM.

-cpu YongFeng,vendor="CentaurHauls",+pmu \

[    0.253229] smpboot: CPU0: Centaur Zhaoxin YongFeng Processor (family: 0x7,
model: 0xb, stepping: 0x3)
[    0.254009] Performance Events:
[    0.254009] core: Welcome to zhaoxin pmu!
[    0.254880] core: Version check pass!
[    0.255567] no PMU driver, software events only.


It doesn't work on Intel Icelake hypervisor too, even with "host".

-cpu host,vendor="CentaurHauls",+pmu \

[    0.268434] smpboot: CPU0: Centaur Intel(R) Xeon(R) Gold 6354 CPU @ 3.00GHz
(family: 0x6, model: 0x6a, stepping: 0x6)
[    0.269237] Performance Events:
[    0.269237] core: Welcome to zhaoxin pmu!
[    0.270112] core: Version check pass!
[    0.270768] no PMU driver, software events only.


The PMU never works, although cpuid returns PMU config.

[root@vm ~]# cpuid -1 -l 0xa
CPU:
   Architecture Performance Monitoring Features (0xa):
      version ID                               = 0x2 (2)
      number of counters per logical processor = 0x8 (8)
      bit width of counter                     = 0x30 (48)
      length of EBX bit vector                 = 0x8 (8)
      core cycle event                         = available
      instruction retired event                = available
      reference cycles event                   = available
      last-level cache ref event               = available
      last-level cache miss event              = available
      branch inst retired event                = available
      branch mispred retired event             = available
      top-down slots event                     = available
... ...
      number of contiguous fixed counters      = 0x3 (3)
      bit width of fixed counters              = 0x30 (48)
      anythread deprecation                    = true


So far I am not able to use Zhaoxin PMU on Intel hypervisor.

Since I don't have Zhaoxin environment, I am not sure about "vice versa".

Unless there is more suggestion from Zhao, I may replace is_same_vendor() with
vendor_compatible().

>> +static void kvm_init_pmu_info(CPUState *cs)
>> +{
>> +    X86CPU *cpu = X86_CPU(cs);
>> +    CPUX86State *env = &cpu->env;
>> +
>> +    /*
>> +     * The PMU virtualization is disabled by kvm.enable_pmu=N.
>> +     */
>> +    if (kvm_pmu_disabled) {
>> +        return;
>> +    }
>> +
>> +    /*
>> +     * It is not supported to virtualize AMD PMU registers on Intel
>> +     * processors, nor to virtualize Intel PMU registers on AMD processors.
>> +     */
>> +    if (!is_same_vendor(env)) {
>> +        return;
>> +    }
> 
> ditto.

Sure. I may replace is_same_vendor() with
vendor_compatible(), unless there is objection from Zhao.

> 
>> [snip]
>> +    /*
>> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
>> +     * disable the AMD pmu virtualization.
>> +     *
>> +     * If KVM_CAP_PMU_CAPABILITY is supported !cpu->enable_pmu
>> +     * indicates the KVM has already disabled the PMU virtualization.
>> +     */
>> +    if (has_pmu_cap && !cpu->enable_pmu) {
>> +        return;
>> +    }
>> +
>> +    if (IS_INTEL_CPU(env)) {
>> +        kvm_init_pmu_info_intel(env);
> We can use "if (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))" instead. This
> helper was introduced to QEMU in commit 5d20aa540b.

Sure.

> 
> The function name kvm_init_pmu_info_"intel"() is acceptable since the
> current Zhaoxin and Intel PMU architectures are compatible. However,
> if Zhaoxin develop any exclusive features in the future, we can always
> implement a separate "zhaoxin" version of the PMU info initialization
> function.
>> +    } else if (IS_AMD_CPU(env)) {
>> +        kvm_init_pmu_info_amd(env);
>> +    }
>> +}
>> +
> [snip]
>>   int kvm_arch_init_vcpu(CPUState *cs)
>>   {
>>       struct {
>> @@ -2288,7 +2376,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>       cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
>>       cpuid_data.cpuid.nent = cpuid_i;
>>   -    kvm_init_pmu_info(env);
>> +    kvm_init_pmu_info(cs);
>>         if (((env->cpuid_version >> 8)&0xF) >= 6
>>           && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
>> @@ -4064,7 +4152,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>>               kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env-
>> >poll_control_msr);
>>           }
>>   -        if (has_pmu_version > 0) {
>> +        if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
> Also use 'if (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))' instead.
>>               if (has_pmu_version > 1) {
>>                   /* Stop the counter.  */
>>                   kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>> @@ -4095,6 +4183,38 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>>                                     env->msr_global_ctrl);
>>               }
>>           }
>> +
>> +        if (IS_AMD_CPU(env) && has_pmu_version > 0) {
>> +            uint32_t sel_base = MSR_K7_EVNTSEL0;
>> +            uint32_t ctr_base = MSR_K7_PERFCTR0;
>> ...
> [snip]
>> @@ -4542,7 +4662,8 @@ static int kvm_get_msrs(X86CPU *cpu)
>>       if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
>>           kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>>       }
>> -    if (has_pmu_version > 0) {
>> +
>> +    if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
> Also use 'if (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))' instead.

Sure.

Thank you very much for suggestion!

Dongli Zhang

