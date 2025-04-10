Return-Path: <kvm+bounces-43103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C038A84E03
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 22:17:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DB9E19E7A89
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 20:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B36CE2900B7;
	Thu, 10 Apr 2025 20:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jw5sUJ1b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZbnZOhyU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CEE20C038
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 20:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744316250; cv=fail; b=KUWMsGW5YObk+SFIixwvkb+iQ/L4xF+9QxhWbXt0tLYhDLLrXGELdC6ruVBbqzhBHFxaB90pGY2CNsNUqXWouIZ3LWuSaXzX8z/hUzRR5aOzdq25jiXKKpoFE1c0IgZPy0BqAYV45NFkVlIHNc/3SfssuBIO96NHsF9o4Ms0Fng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744316250; c=relaxed/simple;
	bh=/zb8M3fM7lK5BQPeywnw+1wi10Li15nUzOKinwZmq7A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Mqf5Av8t4ffAiQw/Zlf4dA2840CU29+h9PJbByAP7LRkrLmxRH8aGQWbYNWF62IMXxgRxnMzajXBSMDgxXD4cn1InjbVZJov7QoV6FYdaqmkxuXdcIjEUnPjc9LyVf7xPy1racVwmflxWq3D2APymsdxDA18oiM0w92xNSntUnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Jw5sUJ1b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZbnZOhyU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53AJmv1f021239;
	Thu, 10 Apr 2025 20:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=z+PrqAdKoXJiQn4F1DO+YaXY33sNfpMpLEjidVOfoPY=; b=
	Jw5sUJ1bweS9nxMxXiWkn8bfp8CyogfFYlnSBBPGanbYlN5MMMmHwhqtin9GMO8m
	/DikTlwwO9lmP0OJeIpVmpIXJgSlehFfKMgq29iRsvRSPmkdAbtB//P+BPbl+HK8
	zxAC2Zx/69/r4QT+AUH2Adj8PpSzBc8Eh+rCDO+WMr1MScEXbmOd4/o8py6LG6qd
	HhkKMbKAOrhCjJPGhPLOnRcT+2Cj+BPJcl1u2HMBrZwzWRuEil/2D5tnufEGv19X
	JXKxnnnq+FNhKtPcvavXovPrxfbVW23txV+sgNCZMmHjSeSRIsb/U9/33UvThCbD
	p2LNg19n0cUby7M42N69GA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45xmf3r2ec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Apr 2025 20:16:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53AIjZsZ001330;
	Thu, 10 Apr 2025 20:16:23 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17013077.outbound.protection.outlook.com [40.93.6.77])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45ttycr6yv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Apr 2025 20:16:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aI90oceWYj3bLv17YmGNJprookkbOCnkQATkRDak5ZOck1nfhSD/tLKnYpf4vkNa8qNN+nVl1mg4ocuWb9XTptVADAfMGxPHBROCYELWmon5+cf7h6rqfYkeZR1JDqqvZm9lxXp8fn6SKLc2hO0Gl0HhYm68L0SKuLzLvBsw1GQHYhPyrmlJUayf8Ul0tu8dmuSLBjUAmrQry7JuOSgrW4ebu84zfVKpj6O2oes6L/tjGUchJwrV06eBFOLRjwZYEE/+bHWjJebqD7paKv/nKEGhgFyNKLXdSdwMMJsMko3wdi1YJHB+7aWfd3PxkJgkVi/XSpqqjNjxjKyI/3ns8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+PrqAdKoXJiQn4F1DO+YaXY33sNfpMpLEjidVOfoPY=;
 b=aCTlneC5m47Hzy36h+Q3Z8Sbr3Fp4g1JERKK/x9Z1yvjts8/VN4NYPFIzCOeyhLQ9j8zyHcmgh3ItjNAF2gntLN/Ml/nFrshcYBU031shGdiTz+7biDwK4SbRhCGgagCeGM0R7JJl/Y0FxwYorMdSGPXd7SjEKgvl2ExOTuG25OIl9AXZfGL7evWUIaxmeRUW4+Pjo+Pl2QzWMemsXZBcIOHgimoVP8Nx3uoseLiR5CThV6F3NBpFe6HytxTB4kg56/m1P4ArVjeaUo0VNHWYrZcpEAh6W2ZjzkzQICyiiaOft+imDVKq5wIgxdEqw3ejjxr+mA+k4a8HXWLHlkBOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+PrqAdKoXJiQn4F1DO+YaXY33sNfpMpLEjidVOfoPY=;
 b=ZbnZOhyUbcrqilQJRIncsDueI4ma1TB9XXOcmvcyVGtcf7BHDlmrXefo1kzlEiXpp7xzOmIqOLTIPSWqBvEl10f9gTa03A7mjXeucgYkD6CWPSKMxOpEvOaSL49QzKRmrSzcZAghODbTCWBdbozXThT0nntEceTnzynSnqBjuuc=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 IA1PR10MB6685.namprd10.prod.outlook.com (2603:10b6:208:41b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Thu, 10 Apr
 2025 20:16:20 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%5]) with mapi id 15.20.8632.021; Thu, 10 Apr 2025
 20:16:20 +0000
Message-ID: <9427cf24-cf16-427c-99a0-90f5fb9c09b2@oracle.com>
Date: Thu, 10 Apr 2025 13:16:14 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] target/i386/kvm: query kvm.enable_pmu parameter
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
        pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
        babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
        groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
        peter.maydell@linaro.org, gaosong@loongson.cn, chenhuacai@kernel.org,
        philmd@linaro.org, aurelien@aurel32.net, jiaxun.yang@flygoat.com,
        arikalo@gmail.com, npiggin@gmail.com, danielhb413@gmail.com,
        palmer@dabbelt.com, alistair.francis@wdc.com, liwei1518@gmail.com,
        zhiwei_liu@linux.alibaba.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, thuth@redhat.com,
        flavra@baylibre.com, ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com,
        cobechen@zhaoxin.com, louisqi@zhaoxin.com, liamni@zhaoxin.com,
        frankzhu@zhaoxin.com, silviazhao@zhaoxin.com
References: <20250331013307.11937-1-dongli.zhang@oracle.com>
 <20250331013307.11937-8-dongli.zhang@oracle.com> <Z/dRiyGTxb8JBE8v@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <Z/dRiyGTxb8JBE8v@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0239.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::34) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|IA1PR10MB6685:EE_
X-MS-Office365-Filtering-Correlation-Id: 173527ff-9aef-40fe-e343-08dd786c8e5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MmNoTVNLcS9renRINmEvNzVhR2swMTZwNVVlRllqV3JHaUVJVmtwT0FEQTQ3?=
 =?utf-8?B?NDlRejJmM1BlRWZTZ0lwYzZEazBUSkt2ZkhmK3gzQXJoVlAyNWQwaUJmM3Bu?=
 =?utf-8?B?V2cxNVRWVnE1Vlg4WEh3Sjh5SXk0TDB4WTFVMzZ0enlDMyt4T3FjaGVlT1VQ?=
 =?utf-8?B?M3dQcjdBN2lSZHFuTXpWWTN0T0RGMEl2b2RYdlVtVGJLdm1mRThMMHh3ejFR?=
 =?utf-8?B?ZHlXVE11MnpaYWdNNGY2U0hDcXZMWmFveUlMQUpqNnFUWU4zUnF0dGJYSEUr?=
 =?utf-8?B?bHY5Q1hBT0pMTTl6SW96SU5mQ1dQdEdLT3BQbHFKOW55dkdwM1YrUjF4TGpm?=
 =?utf-8?B?c2w5MWFHRnB4TDdXNUhNNTVHbE1tLyt5b2gwZ2JTZUJkemsvbUxIaGpYdmtD?=
 =?utf-8?B?Wk9QNjZuWmRaN0Z0UStYVWkvU05GbUZvZUc4TmNFdlZaZUgxSkk0MnIxM1h4?=
 =?utf-8?B?cFVMTEhlaHNxeGxTSk5rcEpZWFF6ZmlNOWQyVVlnRk1PTnZwUG1MNi9UNW52?=
 =?utf-8?B?Z1ltNURvVkh6SjlZTFFNdFh2YWpXQmZGbmxWUUdROFU4bHRKQzgxc1dLWEJ4?=
 =?utf-8?B?NmxTa2VwOWlqTXNJYmxhajRXdXZSbk5hd0JPcFVhbUZoRVdOSFRsVkVNKzNM?=
 =?utf-8?B?Tm5ST09CdGIzTmxMZkFiRTYwZTFCb1VzbDliV3hLbno1VGtVeU1FdUo2T3A0?=
 =?utf-8?B?akN1YkRHSUorZ0ovVnBraWNrb2NqSmV1SlYzb3pLRFFGc3ZKdGNHd1ZJRmRF?=
 =?utf-8?B?VVVjMXNCK0ZKa01mRVpLWUpmSVZiSzVjRWN3K0JrYkxtWkhYUWw1cWM3L3Nr?=
 =?utf-8?B?TWtybFJxZzd0T3N4UWVUR0h1eG5oei9LRXpFcjZYRkRzUWRxUVdwMExEekxC?=
 =?utf-8?B?eEdhMlJ4dm1XYW9WTXU2ZmJuaXRVMTFDSzc0YUFLa3JNRXAremlhTWs4YWVL?=
 =?utf-8?B?WU4rYkdjVDhCSGFBVUF0UW1YdEJnSWRGSUV6WXNhc3hxN1N2MnFBTFVVZW9H?=
 =?utf-8?B?YnhGK2xpMjNEeDFwSWJxKytyOVpXeWgrMlF6WDU3Skliajg1V2lyRFJiL2Jq?=
 =?utf-8?B?N1JXRGFjUHl5dmhqZWJJOUdvN1AwaDhHVmhtQU8rSkxnRWhHaDJQT0dXYzJM?=
 =?utf-8?B?U0hCSnFnNXAxb3NmVW5nSS96cWYveEx5RFB6Rk1hTVBvUHA5SWNHOEorUlpM?=
 =?utf-8?B?eHVRN1IrZ1dHc04xQUt1bmpxZWZxNGhNUlhha2hKWnNBMnJ3bGRnZ0NUTUlv?=
 =?utf-8?B?bDZ2VTlXQzRVK0tJb2plS0FiNmM4ZmJIWlhKQkpQT1J3MEZvcXNNTXlWZmt6?=
 =?utf-8?B?c056WmZ4RktRTmF4Yi8yYmQzYUc4UzBzRjBrZExrN1puNkszYm9hL2lCcUM5?=
 =?utf-8?B?c0RFbWNiODdabzV1S1JXaFYwRCtDMnhyUWcvSmRaNTVsTVJ5MUR3R3dkblcw?=
 =?utf-8?B?ZlpnanVMSFkzNW0xS2ZvTkU4VkZwYUdwN3Z1RFo5dWJOYi9lL2JjbFRzM0dJ?=
 =?utf-8?B?aG9qUjZVeURZcmJJNVZrK2RqeTBOVFhobG5NSVZBMm8yMEVQc0tyUml2aHND?=
 =?utf-8?B?VklkRlhPNXVaQ1pZc0dRVEh0TTdKTlMxNjdQVmMzbkZMMlExSWJvQ21XeDIw?=
 =?utf-8?B?c29ManJCZFI3YmhyelY3YVFERmZMM1hCZ2M3azNZL05KZ2hySlBKVEJxcFRW?=
 =?utf-8?B?TlRxOXdMS0RGbkxNQVQxeWpvNXBFZTc1bUlpVSsvVHVSL1FtQW41WnRURHQ4?=
 =?utf-8?B?NllFckdHT1o0QlY4bUR3dEtwWjZYTG1aNTNoZThjWnNPUlhTRDdTNVdoSUtQ?=
 =?utf-8?B?NFUvN2piK0UvZ1Noa3dMUmJtc0NXQ1JwYi9xL2czWGtlYTNTLzREV3F6STFW?=
 =?utf-8?B?cERkV3htbEN3L0ZFRloweGVSbzdBRitpS1hnS0N5b24yZ3lwOTA5WTV0SHhG?=
 =?utf-8?Q?60xh4dObrAw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVhtSlY1S1dyNEl0QmlQcjhWeVdzS0xpRlZwR3VmdDRkK3F4d1liWWdpREdm?=
 =?utf-8?B?SHNyY3BVRkFYQ1BPK2JmYWdXdzBkWG1Pa3gvYmdtUHlPS1hnQ3VweHpJZ3h6?=
 =?utf-8?B?emlJYlMxMkNPZkNmRVlzSFArVk9LVHZoVW9lTDZFSkx5b01CdlZ6dmtXUGlv?=
 =?utf-8?B?YTRWTDdKSlI5dVBNb1ZUNU9lc2ptc1ZqZjFmbWtrOFFaWUo1NUxRVno3TWdI?=
 =?utf-8?B?b3NjZ2dJM3UvclJUYkJRUk5OUVJQOWJZWThWSG84QmFwV1ZDMDVoZndqSUpB?=
 =?utf-8?B?SnEybzE2SFhyekxjTnhGYkZ5QlVhZXZTNHQyTi9pdE5CekFYRE5IQjZKSEtj?=
 =?utf-8?B?eVMxRGlOcXRaaGVpUlg3Wm1laW5HeThrcm1zQUtadnpUQXh2aVdyWTMyb2ZL?=
 =?utf-8?B?MWpvN01zVkdNMjR3UVNLV2Qwazk3SGZXUHVaNm4xTzBhR2x4L0xtM0VtdmlR?=
 =?utf-8?B?SGZNL2JCZ0xyRFF0RWhJZmdUZ0hITFI4eC9DUXUweFM0NzJlc2FCVm42Ty9F?=
 =?utf-8?B?RWdFaWJJaU5FYjNlL3QwU0pCRlNtbW1kcEJjQmlLdHZxaStuMk9ab3JjRUZq?=
 =?utf-8?B?UFZRNU5wVVJJZDJqdjVJZlNYZ1dMWXhkRlM0d08vcXpDVGZBSjNuVmpwWk9l?=
 =?utf-8?B?b1ZqM0FsN3Boa3ViVFlNZXZ3czd4MkRxMVlTQUJDRWhHT0h6NVpMOGhyZW1s?=
 =?utf-8?B?ck1zTUpMdUwwMkFLd3BwaCtrY0JFYURTS1l0L1FkYW41ZWR0RkU3Tm5xRVNk?=
 =?utf-8?B?dWdEMitQcFdsTEl0RHNIRXJINjIwcVMrK05sZVh6cUNBQm5KcExabkt3K1BL?=
 =?utf-8?B?QjFMbDF5YjBBaitPUnNscDNYYlpVbEdRQWg5SVUwaGZ2cW9aT2hVRnYvUEh1?=
 =?utf-8?B?ZFBKQjI1WVRMRDJ3T3hEcE9SMnI2UjIxZTVNaFJGcTNvQUcrcnl3eFpiNE1n?=
 =?utf-8?B?b25Ya1JWdE1IZ0FQUTYvcnBZa0lHdmVVL0wvV1NUREE5WVJrRFYrc3kwaEpY?=
 =?utf-8?B?VnpwMUNoM0QzaFJScFpXbzhZN0ZVemxoaVhvTFVJK2pRYk4wOS9rb0tUWnA0?=
 =?utf-8?B?aTVCNzdLTGxaODRuOFg0UVJmb0pGM09BYlVDcXV6QUZIM3VubmZOdzRBRUUv?=
 =?utf-8?B?a0YvTnR3eWZ3aVd0b0V5NVVWTUp1dHlOSTJoa0ZWaDVGV0dzT1VMbW5NTzZo?=
 =?utf-8?B?RzAzOXg3L1Y3TUpYdjdBREZKZlJXbElTbU5MUE11RnJDOGdwZEsxcEpBZC8y?=
 =?utf-8?B?M2Q2aHU3MDQ3bkFzY1IrbWhwdE1RdWl4WWw3QlBZT2EyNGIrazAzeUxqTzgx?=
 =?utf-8?B?QWgwTzZqNHZTOGQ2WTQ0cy93MjUzK0hCQXlSV25ldnJRVVZzczVQeHVIQ2Na?=
 =?utf-8?B?eGNQRG4wRkk4akdkWXBabkg5bHZlbkJaZGZ0clZ3a1ZDMkNZaGViTWtDaTYx?=
 =?utf-8?B?VkhyRWppSjJ1VXlRc21RMm9sUHVVN0pvSmthandTSEdqd0Y2U0taY0pBVkpx?=
 =?utf-8?B?NHc3U3BoVzRKVjB0OWh1TFVLLzV5REZJUnpUZ0o2andGWU1SU3IrL05MVUdz?=
 =?utf-8?B?cWEvMzdYV2VzaWlseW5NZzhSOWhNMGFNZzRpdDJxQ0xwbWIxSTBkcS96MVJq?=
 =?utf-8?B?UUhMZkdVckhiS1VYVW1NV2JITmx2dCtoQWhsVEFtYlcyaFFvbVdhSmpBWnNG?=
 =?utf-8?B?NHRYRW5zZWg0dlQ3bWxkZVkwMFhLelVaMHlSVjJmTm14VlJmeklQZ1pFcGFu?=
 =?utf-8?B?Mm9hcWtGVGtzOWVkOHh2UHBoclZUaTU5c1Z5MzNHeTAreDdqUXF2K0hEQUVY?=
 =?utf-8?B?bEdYRFlVSkdRMWZqcGxmSW16MDBWT2gyQ0tYZVJ6MFluNkRlYmQ3elNXcGI0?=
 =?utf-8?B?RVd5TVN3QURuczhtVnN5cGxCWHgrNXdaVmVKVVFZL0RWYlZRaCtMRVNSeWtH?=
 =?utf-8?B?VC9xTGU0T0RNY0VVeVlZdGx6UzhBVWlwYTZoaFhsck9sMWpJeFBsNmJMcUF0?=
 =?utf-8?B?bzBoUXlXeEhPTWVBQ2JRbTJlL1V4ZHhQczJ0Rkd0U0NnUkxVVWFPZk9Lc3NB?=
 =?utf-8?B?U21xWkNzVWFZYnRZQVhvSkVBRU5IWTFzVDFQeVFPYmFjcXcyQVorYTZaelRL?=
 =?utf-8?B?NWViMWhXRndFcEIxbWtIL0EwWmdRc2xJb2V5eWYvMkFkK0x2VnB6R2hBZzZj?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GPrY/JAUjHj5UFnhGR4jk9qlRHRi22exROwW4VsS6vOhB78C4p26VMlTiTG58f+MvmM58EbJiU8U2kj9ggh+VJTx1iqHxdn26t/Y/d8MBnuxGcZ67nu1BKOd6DoZPP45t5fzIoHXNQmIG/x9qca2IqrG5O6EQftZgXPbDNjA3c+PHymWKFI6plecTUG6aN0qhoM4jHT4noUojiaXZuA63wAmaEMwcl6GoLyG92DZ95YuYrOumsIuqSZ4+aBAWljIQH/XEiabRPBuNU7pxgKXbuRyjmqrElXU7miaAZJKsRFbRf1YDoij00P+izGaRt6dg6KQ0287oUWlZleKI6+fcBLpvDzIMUS7pLHHCFNY9xUCgavp1BsHiaInJXTKcrhFhLiFAzgIuqyQC68HRZHFY0Ux1/WaR8xLNjZhv6v9fWmYfTq7FuIAUQ0IYaE2fhX3dfNgsqelpt6rM+JUobKTiFM1L3nRkr9+1pnKR9XzjRFj1soe16/WsS0McF58Vno4XAkhJeXVUO7oOkjjPYhnSNM9mTKeldDHfEOCEiT9l26uJkt/hehSyR650cAhsDVUtQoG+5qW1BjirTBb7fKdQBPYhlsdoAJgBtoLeKpIA0E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 173527ff-9aef-40fe-e343-08dd786c8e5e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 20:16:19.8899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rYjf2LCg9msQF4IYkqzqMVtMFi6UPqmHpxnOs4kaGmKZMj1ciWmzPNpStWcAsn7MpK5Ncc+RRJT8ausXaeVVuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6685
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-10_06,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504100147
X-Proofpoint-ORIG-GUID: CEVgf8MnlrqL8PdkzIslkPiUVvNheA6u
X-Proofpoint-GUID: CEVgf8MnlrqL8PdkzIslkPiUVvNheA6u

Hi Zhao,

On 4/9/25 10:05 PM, Zhao Liu wrote:
> Hi Dongli,
> 
> The logic is fine for me :-) And thank you to take my previous
> suggestion. When I revisit here after these few weeks, I have some
> thoughts:
> 
>> +        if (pmu_cap) {
>> +            if ((pmu_cap & KVM_PMU_CAP_DISABLE) &&
>> +                !X86_CPU(cpu)->enable_pmu) {
>> +                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
>> +                                        KVM_PMU_CAP_DISABLE);
>> +                if (ret < 0) {
>> +                    error_setg_errno(errp, -ret,
>> +                                     "Failed to set KVM_PMU_CAP_DISABLE");
>> +                    return ret;
>> +                }
>> +            }
> 
> This case enhances vPMU disablement.
> 
>> +        } else {
>> +            /*
>> +             * KVM_CAP_PMU_CAPABILITY is introduced in Linux v5.18. For old
>> +             * linux, we have to check enable_pmu parameter for vPMU support.
>> +             */
>> +            g_autofree char *kvm_enable_pmu;
>> +
>> +            /*
>> +             * The kvm.enable_pmu's permission is 0444. It does not change until
>> +             * a reload of the KVM module.
>> +             */
>> +            if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
>> +                                    &kvm_enable_pmu, NULL, NULL)) {
>> +                if (*kvm_enable_pmu == 'N' && X86_CPU(cpu)->enable_pmu) {
>> +                    error_setg(errp, "Failed to enable PMU since "
>> +                               "KVM's enable_pmu parameter is disabled");
>> +                    return -EPERM;
>> +                }
> 
> And this case checks if vPMU could enable.
> 
>>              }
>>          }
>>      }
> 
> So I feel it's not good enough to check based on pmu_cap, we can
> re-split it into these two cases: enable_pmu and !enable_pmu. Then we
> can make the code path more clear!
> 
> Just like:
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index f68d5a057882..d728fb5eaec6 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2041,44 +2041,42 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>      if (first) {
>          first = false;
> 
> -        /*
> -         * Since Linux v5.18, KVM provides a VM-level capability to easily
> -         * disable PMUs; however, QEMU has been providing PMU property per
> -         * CPU since v1.6. In order to accommodate both, have to configure
> -         * the VM-level capability here.
> -         *
> -         * KVM_PMU_CAP_DISABLE doesn't change the PMU
> -         * behavior on Intel platform because current "pmu" property works
> -         * as expected.
> -         */
> -        if (pmu_cap) {
> -            if ((pmu_cap & KVM_PMU_CAP_DISABLE) &&
> -                !X86_CPU(cpu)->enable_pmu) {
> -                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
> -                                        KVM_PMU_CAP_DISABLE);
> -                if (ret < 0) {
> -                    error_setg_errno(errp, -ret,
> -                                     "Failed to set KVM_PMU_CAP_DISABLE");
> -                    return ret;
> -                }
> -            }
> -        } else {
> -            /*
> -             * KVM_CAP_PMU_CAPABILITY is introduced in Linux v5.18. For old
> -             * linux, we have to check enable_pmu parameter for vPMU support.
> -             */
> +        if (X86_CPU(cpu)->enable_pmu) {
>              g_autofree char *kvm_enable_pmu;
> 
>              /*
> -             * The kvm.enable_pmu's permission is 0444. It does not change until
> -             * a reload of the KVM module.
> +             * The enable_pmu parameter is introduced since Linux v5.17,
> +             * give a chance to provide more information about vPMU
> +             * enablement.
> +             *
> +             * The kvm.enable_pmu's permission is 0444. It does not change
> +             * until a reload of the KVM module.
>               */
>              if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
>                                      &kvm_enable_pmu, NULL, NULL)) {
> -                if (*kvm_enable_pmu == 'N' && X86_CPU(cpu)->enable_pmu) {
> -                    error_setg(errp, "Failed to enable PMU since "
> +                if (*kvm_enable_pmu == 'N') {
> +                    warn_report("Failed to enable PMU since "
>                                 "KVM's enable_pmu parameter is disabled");
> -                    return -EPERM;
> +                }
> +            }
> +        } else {
> +            /*
> +             * Since Linux v5.18, KVM provides a VM-level capability to easily
> +             * disable PMUs; however, QEMU has been providing PMU property per
> +             * CPU since v1.6. In order to accommodate both, have to configure
> +             * the VM-level capability here.
> +             *
> +             * KVM_PMU_CAP_DISABLE doesn't change the PMU
> +             * behavior on Intel platform because current "pmu" property works
> +             * as expected.
> +             */
> +            if ((pmu_cap & KVM_PMU_CAP_DISABLE)) {
> +                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
> +                                        KVM_PMU_CAP_DISABLE);
> +                if (ret < 0) {
> +                    error_setg_errno(errp, -ret,
> +                                     "Failed to set KVM_PMU_CAP_DISABLE");
> +                    return ret;
>                  }
>              }
>          }
> 


Thank you very much! I will split based on (enable_pmu) and (!enable_pmu)
following your suggestion.

Dongli Zhang


