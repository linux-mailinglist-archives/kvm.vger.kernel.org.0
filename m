Return-Path: <kvm+bounces-37366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AB6AA29651
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 17:29:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E3533A8FE0
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 16:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 789231DC9B3;
	Wed,  5 Feb 2025 16:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bH689x6n";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Q5b0hBp/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876DF1DAC95
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 16:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738772886; cv=fail; b=p4bnrJ4lGgrb2XPpi39TLeJtQ3KKfG3cDcqW2L3IsRZiNGenb3gOHH+pIFYWEqZEbe1ehmePyB1n1krtUj/GrWt54tub6DBwO6RtSUUsTmi6cI46p7xb/+ZFkPiXr0o555Spd942/FyajrAI/9mPTYdw4V4WsmWOm03jmuhcp2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738772886; c=relaxed/simple;
	bh=lF5B0ND/F3iKetO5yuxIT8YVT1R3KYqEGGqnhHdvC38=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IeM4p6dqgUFN8QHX55igoTDmXbQQpjW6FBoXKMCjW3IlXPNM+qOFQKCisRHrGV3kiWr0v8+P71yfTAmUxC21Ut6lZArKDmVuHHgNwD5VoyQvWXEgRDhBOHl7gAr4uLo9A4DDS/T1w5Gf3FDxtBnaZb1tuZuAkoIygBxmYN3tkSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bH689x6n; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Q5b0hBp/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 515GMsah028789;
	Wed, 5 Feb 2025 16:27:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=EDG/c9PFBhaSsD/vI5CwsuJxiR7CRFNQ6faYsIPy6Nk=; b=
	bH689x6nvJTiTv5tPPjG17Oz8dfm2uqHd3mqU2C+2SS1r1FrkjH/v9hiX0K0BRYT
	w7k60evxookFu9LFxFJesRE0pO9t9pqVhv5nhL+ScwNMuBarPeuRImxBnTAdQrGx
	5jaHO5ReWAjUWclK+ZJw3P7unNho2QxSiMgUFdQUOTj3IjdSAkEcwibvH65PxA96
	fAQNqUH5MvS2ONGSJw5GSeK22+VbbVBB34lO8g/hawYEBeKIc3avPibzkz0NPwh0
	hj4R8MSZ5MAFpszuL0hLjz/t7CMyc6c79p4212dG106XHL0GV7eQcR6BbUhC3uDy
	4881eLKtkmnqz64dnht+Gw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhbtfkhn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 16:27:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 515GO7hI027847;
	Wed, 5 Feb 2025 16:27:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8p4m1kq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 16:27:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z0c9mb20citSVRioPd4La/fEBrD4uwragupbJpeZJG6bQ1vBdGCNGUalP6BFK+dCJiWLzFeMcU6PJlrY+UUj4sR5W9FFF127cuK7qTK7UfsLPMiIbxS6PUrr2T3r/AK/l+iUMHHdHuttScRxcoN617a/6JlCt8y9wMShdwUOaj1qkIvu0HyWzpZvvgk3qUQpUSz5cQQWoKfK24vPqXlrT0n9MSqU2mDLsO+QOKEntBYiDjoH4wDXTUMK773nkXnb2pHJTnK+jwLB5UW5zm2TSlUwQRSsUq61N0ccH8x5/QAx4p6D4TgiCV1D2zBTTxCT7C1t7y7tjah0kNL7t1IluQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDG/c9PFBhaSsD/vI5CwsuJxiR7CRFNQ6faYsIPy6Nk=;
 b=zBoCI7WcwzeuATYK6j+yOJz5wOsuZrFWVIvMmrtfAHtRcKXxogRXztZbhEuLIkJYr1pQ6sjAtRj3+sGYyYq0g84UWOBfj/KhY/pRIgPpkWW0GapKoY7CZObAL5a7+vtIBeZqSicIRs96XPfCUEnerNrHBK8TmPbhdYGyxNGLK+kMlAOMavRTLzd5ymqW49zzhCmVkPmyXVNFS55K6iIIfd7RHy3H4cvCKxv+55Rgdkw5KrxbJxPfSEcdVdq0Jd3WzRyCzAHYi+X5D1QUseLbcDIY0L/eN3gdgbuwnoueavqmD0Ji+2C6sZik7WQ3C6dYTy2ZuWWt36QHbExAEn/lbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDG/c9PFBhaSsD/vI5CwsuJxiR7CRFNQ6faYsIPy6Nk=;
 b=Q5b0hBp/5Nnf4wcoAdz8PgF0VEbxZExUGsJ+XGqgE3m2zXMk8zkrpxGP5Z6w321OxNYZncWKbe9xba4UikuuueAfeZzeoYSJhWmN6/I5jPKow275Dh+zC/wL/WI4xwAdGa4L0iKwwFxVDRLlF0hKnTMIzCNbRusUdL+EG/63u8Q=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ1PR10MB6001.namprd10.prod.outlook.com (2603:10b6:a03:488::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 16:27:43 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8398.025; Wed, 5 Feb 2025
 16:27:43 +0000
Message-ID: <1123f5bc-3f20-4352-822b-fee875442f42@oracle.com>
Date: Wed, 5 Feb 2025 17:27:39 +0100
User-Agent: Mozilla Thunderbird
From: William Roche <william.roche@oracle.com>
Subject: Re: [PATCH v7 2/6] system/physmem: poisoned memory discard on reboot
To: Peter Xu <peterx@redhat.com>
Cc: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <20250201095726.3768796-1-william.roche@oracle.com>
 <20250201095726.3768796-3-william.roche@oracle.com>
 <Z6JJ0fDjkttUcW7n@x1.local>
Content-Language: en-US, fr
In-Reply-To: <Z6JJ0fDjkttUcW7n@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0254.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ1PR10MB6001:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c1b83dc-6dd1-4c67-1033-08dd46020433
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S3lTbTVBbTR5WXNRUnlydmtGWFNNR0thdFJhdE5pL1hFbzdhTldrTUFhaTlY?=
 =?utf-8?B?a3JvdHk1UjVFTXJDUGl6eDRqNllTSk13QjFRWEVWUjk1SWE0U1V6elJlWUQ2?=
 =?utf-8?B?SjNKRFZBOTJ0M0ZFQTJVNE9SVm1La1h1T3E5Um9IaSthUytHUTdEOFYxa29w?=
 =?utf-8?B?dE04TTJZL1U0ZDEzRGl4R0o1eUhyUVhRMUN4MHhvZnoxaWNtQzUyN0s4clVB?=
 =?utf-8?B?Vkc0Tm1KdTNHYThFdlRtZW9hdy9OVENPcGtjT2kvZ1AxbkhqUkFBdlNsdExE?=
 =?utf-8?B?UXJEVTExZ3M3bGNsKzRnUUhyalp0VFJadm5ndHhGN0Y5UTNWWG1hajM5RGNa?=
 =?utf-8?B?NEdNdUkxbmhqWGhzN0lsekpDaHlWT25sWmRrNWh2ekRlTXFCelhzVVhNejkz?=
 =?utf-8?B?dlU5TFMvNXNoVnVUZkVNVEtBRDNIYWVYR2hVZGVpeHRxMHhQUEFvU3dvMDB6?=
 =?utf-8?B?OTgrVUprUGdwT3NVZStRQmhZMmgrMkV5ZVMzV2o5SGFUbjNtZTlaSXZXNnN0?=
 =?utf-8?B?aFhtOXM2cERPbXNqZURyTzExL0R4a0tpUzVVWTk3V2VlYndxZkgvZEJSOGg0?=
 =?utf-8?B?UGJmZllBNEJ0UlFmNXdtbUZxR0ViakRrbkdPcDVkYVU2UjFMSHJuejBNNm5M?=
 =?utf-8?B?cjdKdXlIMklSRzJLU01DMVdCd21PRHFNYVpDMWJjTHJkVmx5RyswK3YwWXY5?=
 =?utf-8?B?NSsyTDVTcmV0bDJZZUVoME9ZWTVPdTFyVnpTM0tIZU44VTNkL1VuNmgvTWdl?=
 =?utf-8?B?NzdjY2liSGgvRVlxSWhZZjk3bERxYXZaMnFNWGVSTlVUWG9aMWZXV2R4Yjha?=
 =?utf-8?B?ZHlOdXR4NW55eEFrTmdMbGpzL28zdWJxOFFVbzY0bjRIaDZ3WnkraXFtdzR6?=
 =?utf-8?B?dkU4NDUvWXhhM3N2TFpHSnMvcE1HZDJHaVc4ZzB5N2sraFNYMzZZczdoSlRJ?=
 =?utf-8?B?STFtQVFDVVlxUXVsTXBEeFB6YnZKclFvZFU0WW5jQ25qa2NNNFBmUXU1djdU?=
 =?utf-8?B?Z3NtSU1OUEE5SUdXWFlqVGR3UDBvRmlHOTRzdnFvN21kQktLcFM1Q3NZQzJr?=
 =?utf-8?B?ODZVNWExNlg2WWx2R0swOUtETWczNTc0T3cxQkdrRDdsMmpHVUdLTjAwWHZ1?=
 =?utf-8?B?TEpNczB4dzRGdmsvYlBpWjVrd3hkS2J5aHNEZkY1amplTVJnTXYweVBMQlVu?=
 =?utf-8?B?em5pOW5MUkUwS0xuYStHYTdKcXBHNDFMSEN3N0Q5NGNzZnFReGJZK2E1WmZ0?=
 =?utf-8?B?cEtuZ2haUEFxckpTMmJFbi8xcUdIMDl6VFBBQ05rSHk4Tkhqc3NpQU0yZjlM?=
 =?utf-8?B?enpjLzRUVnVGdktzRjYxcktmWWlTSnlOTFZhUWxKQ3dTQ1Noa3M4dEZNZk1V?=
 =?utf-8?B?K0s2dlVxdGwwcjZ0STY0cXNBUlZhZ3NYeGJGTWd0YXBKczJYaDNuaXQrZ1Rw?=
 =?utf-8?B?YWNKU1VZeGdjNTdaYmxEOFVtc2dWYWU3cXQ4VFZHTFJoZ1pRQzIyYmhDWlYy?=
 =?utf-8?B?b3BEU0NKb1BEVTNhQ04rWHpsV2poTGNZblNRTk8rcmR6VW02R0pRcGwyZnY3?=
 =?utf-8?B?SWNGb1RaSjhwcFdRWFdZakRXNi9GY3JUSXp1ck5hNExiaXM4QlpteTM3SFp4?=
 =?utf-8?B?MWhhUzhOWG9RZ05WMjErc3RiMDJicWdtMmQzbm83R3U5SUsxaG9ycit0OWZN?=
 =?utf-8?B?cmY4REZKcEpRblM0b1BCYlpvL3ZLNHprT0tIZzlDSklxR2xyQnkxNi9ySHlT?=
 =?utf-8?B?MDN6RzhpTmdjYTdzNTJoTzF2dTlDRXROUWlXTW5wTTBJeXpyV05BWUdkSzkx?=
 =?utf-8?B?ZnQwaXNuQUxjVDRlS3ZMWVYxMXBKUHo5QjJYVVlldWtidFhFUlJTeFNhMGgv?=
 =?utf-8?Q?+hEKL3f+QStmB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UG9POWtuNzlGaGlINnFwdmw2aHNJUmdrVWNNd3BlL2R6SlBRWUJUVFJNVmFM?=
 =?utf-8?B?R1pmSkFhSHBBdDRTakZUV1NiSGxyUnAxWnpjakxVNkcvQ3BDd0FvQ3l0OWda?=
 =?utf-8?B?bW1IUVlWbmxoN1E4RUZxOW5hRWJ3dzlUbzI0V2p4N2ZoWTM4a0d0VjVFRkQ3?=
 =?utf-8?B?ZFVvYVErWUF1VlBkaWFFMVA3OW8wdjNzTzZOOU1rMUJ2enVjMlFkTGdzMlQx?=
 =?utf-8?B?YXlVNHRnNllRTE5FYkNmcm9qNmVLaW9ZODI1UWdGNkRYYXcvTkdKVmpwRnVD?=
 =?utf-8?B?TVBlMnJPb1dwbE1sdkREL005bytHb3c0ckhaVWxqRGlxOEFjaHV0L2MxcHl1?=
 =?utf-8?B?ZGgyRWp1akhCVHNTbURURXZtUXI0OUk2VWw1c0hsNmlUNUtTUXB1RHY5V2lr?=
 =?utf-8?B?MVVMMDlGTjN4Ky84M1lHVW1PaVZrQXVNUE1KOWNYYVpSNEttbDNSTGFHc3Rx?=
 =?utf-8?B?N2NGU05YSllLYWJkM0RoSTlnak5ZWjUxSE1VVVNZdXpBMExHSnB1V2pRdTdo?=
 =?utf-8?B?Mi9wQnVxa2dRb2NYZ0Jud0Q3SGNrVmJDdVpVbXJlUlF5VDNTazZCMlI5RE02?=
 =?utf-8?B?NGtuKzI5aDdWcU5qeDF4d1VqcEFDcm9LY0RCVFEvaUNPWjJIWmY0cytER0U2?=
 =?utf-8?B?TEhUQ2w0Wm1rL1dudmZnVkdqL0theFcxT1pDUCtkUitleUloOHdGeUxnRnR4?=
 =?utf-8?B?eTNvcjBiMHA5V2JNYnRsbUhhZzRmSzRGSkVaNnBRZHNBcVNyOUd1RWpqOE16?=
 =?utf-8?B?ZWlwcU9vbmFmd3Bwa09BMGlMMVRsNXl4N2JnWGZJVmR6MlN6WGxpSWZBZWVU?=
 =?utf-8?B?TGNsZitJU1BUcmhoOUJpUjRtdExRVHNRRmpaQkRqcGZ5RUFqUGFOOTBpRDdS?=
 =?utf-8?B?akI4dUphZFk2Tzd6RE9mUXBPMEFiUWJuSW0zeEQvT2p3TFQzUHlaRmk2U3Zs?=
 =?utf-8?B?L3BZeDUwcmx0NXVzSHdrZGpvNkFnNWg2OU83TnRxelpCL281OUY5cFJhQ1Nn?=
 =?utf-8?B?TEN2TURyMTFPWTRVdWk0TThGYjg0YklCdzRGdHFadmYvaDRKVEN4Z29KU1k1?=
 =?utf-8?B?Rlp3ZmJCWGtGZzZmZUpVRis0a1ZiU3ZObHlQZTdVUHdHOVFGZDI3YmNBdzk5?=
 =?utf-8?B?MXBJUGRvVDVxTlJjenBJa21RNUhQYzNScUlvTkg1N1krUTYxWjZ6UlkrdVNx?=
 =?utf-8?B?Y0JQQlg2Z0VzdlFlS0gzY1A2YzNxR3NTanIvYUo5WFZJWWNZdENGY0FJd3VJ?=
 =?utf-8?B?MHpSTjRkdmdxeGdFa01YSVc2UnM1cUQvNCt5andKY3VRaU40ekFDM1hrZTFm?=
 =?utf-8?B?d29xYkdURnVPYi9TbXBsc212L0E1Y1h0MThsWk9lSW9BUDJwczhyaFpNQ0Ny?=
 =?utf-8?B?OGlFdVpCbURPbDZaWEo1d2Z2aWVFVVllVTBtU2EzYWxVaXpYSWlIbzlMOWdX?=
 =?utf-8?B?UHQzWDFrVDhGdFplK0Z0RFcrWlhpYksxQ1o0OFEzZkhlRURLWjZqdndWSzZC?=
 =?utf-8?B?Q296a0JDZWlLRzRVQjMrV1l6MWgyZkRMb1g1dUhFYWtWWTdqNlVjLzN1WmNa?=
 =?utf-8?B?M0lsUlhXNnpTM3V5ZUZ4YTdJdjZjYm9OMU5HaU93Mk9BcDNqNlJ1d1FDUzJC?=
 =?utf-8?B?SE1pQVlYSytZLzNoQ0JtMHoyR3pVZjZ2NnVxS2puRFJYd1ZoQ2FBak9KVVlQ?=
 =?utf-8?B?a3FjUDhpTmk0YVVONnc4TzBYZXBYR1FqbmtINWdiWjZnWW9xZUpuVEI3QTdQ?=
 =?utf-8?B?dVFMSU1SVkFpdnY1cEFyYmJwbDNSS1dXVEJDM0VkTkdyajdvSHVibEo4RHEx?=
 =?utf-8?B?d2tETVdYaS9oUGM3S2p6K0dwb0I5QUc3eUxsNjVWN1E2VXhVNGMwbWpWQkhR?=
 =?utf-8?B?b0U4VEpOMVNZNTZmam8zMTM0Y25ORUxwTzNLeWZweGpqR0lnZHlQU3lhOWor?=
 =?utf-8?B?Uzk2ZHRvREVQcFFNLzFrNERSZkNaU2FpTVZadkhBT3RkaUFQSVBzMS9qNVE4?=
 =?utf-8?B?M0UvZ0Ntd3RabE9vUzlCbEQ4R3ZtRkdDMzFPSEFIRS9DYy83eUI2QmdPUDNo?=
 =?utf-8?B?Q0xPaStLKzF4L25qV2ZkZXdwcUlIVzVwdXJ2eDV2U0RqMEZaUWdxOVphNU1B?=
 =?utf-8?B?QlFwakZEK2tkOXVYR0tHUldPNy9UQ2ZNemttZUZteVlZV0tQd2FCcWxhY2hL?=
 =?utf-8?B?UlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jCdeD3iMe3axu2655xxb7aykcfWWpO9QMLRTzQbvTLC8kFNUZZQWgDKt3FdjaNPvIqhBwCBY8B3/Pb+m/bOd0j5fd6av6O4AZwJl0m8XMfdyRSfSUJS8gQs6aYWmzMohR6yZBRn0dXnSrjP1jJLCrlijWVTkevBJsHtXfWK8/5kXJtbaxceUxKqLlNfbxmGyi67geuuveDHnvtiTs8L8I57OaAUs26xB9HHP/SoOuZlaOr9mNlBdxJHHtIi5M4GVPOBPDKare3x29VlLZDh8icS1e/F/aXP7vK/vj1cIFgQogrUyjRmf8UdTrsdKFvdK3vB773EZ2OGh3Y9cJrh2MwJUvUg3l280YxLouR7lTHSnrSZ0R72gi62bFbBO4ld479gT7mT3DRVay9OEJbEHPConL/8rmrya94eyOFVmE40abrLOkbJWtoDN+5Mot4KZ7QQB+inPHM9oaBmvv78sFDIEXqyKT31zr7R+MkagBBD40C4FQ8SDeLuEp40hHYrFmoI7nUe0rloSztMvzuDHaxcGGK56qUmymb3iwACo2MJSUxUEto2Unyoya8qGnyTs84ANOMLTlIt5ijMZ+7SJC6EI7BTlI1ETwgqGK/Vkbm4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c1b83dc-6dd1-4c67-1033-08dd46020433
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 16:27:43.2342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: soea/J5kYfuIpWHw4x5n3sVpm2DUaa5eOFnMsdZtX3SBGWcOKLNH8qwoWUV/aLLXCdcHBsjmC2kl9EXKqmAmYn7/N4Qp49meoWtLpljnUZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB6001
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_06,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050127
X-Proofpoint-GUID: GBFwx1agYodiujgyjb90yZpvuMN_iLgo
X-Proofpoint-ORIG-GUID: GBFwx1agYodiujgyjb90yZpvuMN_iLgo

On 2/4/25 18:09, Peter Xu wrote:
> On Sat, Feb 01, 2025 at 09:57:22AM +0000, “William Roche wrote:
>> From: William Roche <william.roche@oracle.com>
>>
>> Repair poisoned memory location(s), calling ram_block_discard_range():
>> punching a hole in the backend file when necessary and regenerating
>> a usable memory.
>> If the kernel doesn't support the madvise calls used by this function
>> and we are dealing with anonymous memory, fall back to remapping the
>> location(s).
>>
>> Signed-off-by: William Roche <william.roche@oracle.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> ---
>>   system/physmem.c | 58 ++++++++++++++++++++++++++++++------------------
>>   1 file changed, 36 insertions(+), 22 deletions(-)
>>
>> diff --git a/system/physmem.c b/system/physmem.c
>> index 3dd2adde73..e8ff930bc9 100644
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> ...
>>   /*
>>    * qemu_ram_remap - remap a single RAM page
>>    *
>> @@ -2184,9 +2201,7 @@ void qemu_ram_remap(ram_addr_t addr)
>>   {
>>       RAMBlock *block;
>>       uint64_t offset;
>> -    int flags;
>> -    void *area, *vaddr;
>> -    int prot;
>> +    void *vaddr;
>>       size_t page_size;
>>   
>>       RAMBLOCK_FOREACH(block) {
>> @@ -2201,25 +2216,24 @@ void qemu_ram_remap(ram_addr_t addr)
>>                   ;
>>               } else if (xen_enabled()) {
>>                   abort();
>> -            } else {
> 
> Do we need to keep this line?  Otherwise it looks to me the new code won't
> be executed at all in !xen..


Very true, this is a mistake I made in a very recent version - sorry!
I'll fix it with my next version.
Thanks.

