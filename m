Return-Path: <kvm+bounces-43106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DA68A84F26
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 23:22:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9373D9A4962
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 21:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF41290BCB;
	Thu, 10 Apr 2025 21:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XvwXeoIV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Jm/6UjMh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12E91E5B62
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 21:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744320136; cv=fail; b=cyKbeduHgYsf9DEisWB3ZPs7DuyygcEZcEOWLEx4o5/mKxgjrZW4tZIaa8/SSFj3VhTlmgikwvi5hZKapgUAs4ujC2xEOorbPtONz53doHJXrKnAxa7L101yEd8tr70kMWs59FPBVdMZADRVA2zO/W/jDyrQra3Mt8VGClljO/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744320136; c=relaxed/simple;
	bh=Ila8T31EyCKeUoJi//vWeZUHtRPzXrae6ttdHnUyZJA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rrTbYRyU/qg0BddqcxG10LkimksB4AhuhG0zq0IyxAAI2lkx61tuE460PoHFDj86eBbqTsEYGfPWcvVMPFpugtsoZln+Xr1M5mMxkN4wAktMhkZ4EaCfBzz9qiKKCA3wz5bfvXm7Gw7kXEIJsw488PRspSOr5THtnVh/KAx0m2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XvwXeoIV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Jm/6UjMh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53ALC5J5020309;
	Thu, 10 Apr 2025 21:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=K0LpGbodnG9o6PSBDzq4jLvFaYWVvr7O/KalIb+LgsM=; b=
	XvwXeoIVuTiykfjW1le7oUUOK0Ik9tRRuDh8xrmmJz3MUQtMDIwr4CXbRPc9doBH
	lTqclY+WVy80n0LCFv4CC8/yFuBqinzuHYGnhJXGLve9o78QEHtowNYZjgzLjpwk
	aFK2SACjADQXjzFqs8acoCILR9C/X7fEacuD5wrSxluqBYoGkld+rcDGJFFgeeXb
	WvbwJYp4JMIT+TWBU40nKP91IRRy1RsG4rsq2wdejdoPKTNAverTIXb3beVBSNP9
	CV+ksG2b/LmlDOi04wMuZBu2O7DqI4BSjb31xLhQ/cQGTrdtsBUPje74uPodETNL
	gfURFr3G0YeUL3rc5nfDdg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45xnphg0ey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Apr 2025 21:21:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53AKTEWk023775;
	Thu, 10 Apr 2025 21:18:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyk5tdj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Apr 2025 21:18:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LrpYPGmsx3v8mE8SRo/IAXmbyevCmKrZIw5ahfIH2tGTBxwyjj3wSH28zHupMJ+S4uGE+UVdVEsNOU9SLe3Vb8uMigcXULznBo5eEvyGDe8Q9Z2LwN1vHP+PKI95tKqHqhi3a2ulxPRTlx/K3lGvB0ItxYzNCPOUnUw5pbJHhwDfyEZ8k0K/scY5/C8NW6crNVu7j1SRICCFSDOBETYjUL9qexNAqjI+2XYD9gtv9IxeWcjnLaJdhQhy2tn5q6aEWh/sxSBBKK7ZiuBY+iJAk5moI7UZjgeaCksSqYyCtV6AI9YkVqCfm0M004aMNZbjszzNIxuvto6rvs2dnFOhBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0LpGbodnG9o6PSBDzq4jLvFaYWVvr7O/KalIb+LgsM=;
 b=r34oGYuoGkzMl78eE1g79cnEnrOplEEpkarjl2F5GgJhYAaqcYUOsK0j7x9U5lq2skRnEyDoIlKzDBBwbhV3bJbHX5H7LXwW1O+OxlEbP9PuB5tlyuBNute9r2oDI+qK8hC22LRxZp9xQlkw2+kgscAF02maSONJFrnKh0WJnHggPcnq3F3FpdcePNpcJqrwE+zRGnkx8sw0TGzhRgPh70NX/scTAN197UFosByr2x5werwMtZh3QQTcysUQrig1gnTzR3M7nDCuI0pJ4OgxwYkqGu/Yi7Wz5FNMOL2cPcQLtlC6WVgEkg/N0yB0oCW3czHuTftSDksFyIOQiouSiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0LpGbodnG9o6PSBDzq4jLvFaYWVvr7O/KalIb+LgsM=;
 b=Jm/6UjMhAg6brG2VqNm5dqygGXHia0iCkHTFNXI/+VNhgV5HTXn15mBKl9qsxHvVDT3P+k2PVRdXEC6GiZoDP1o+EGG+rRMdMSp3hMqkVFNhZbvdwHl3LCJ1CeQTiJ4A2PaIvsQr9b151MsdAKshZGp/SWiQRSYBpkTtTc/2XLI=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 SJ0PR10MB5858.namprd10.prod.outlook.com (2603:10b6:a03:421::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.24; Thu, 10 Apr
 2025 21:18:02 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%5]) with mapi id 15.20.8632.021; Thu, 10 Apr 2025
 21:18:02 +0000
Message-ID: <2c15a62f-760b-4c52-8bda-9c516bd3c6a4@oracle.com>
Date: Thu, 10 Apr 2025 14:17:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
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
 <20250331013307.11937-9-dongli.zhang@oracle.com> <Z/d2ucu6Y5xlNh6S@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <Z/d2ucu6Y5xlNh6S@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0458.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::14) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|SJ0PR10MB5858:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f565992-79a7-4485-6adf-08dd78752d2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bnNQSElPWUZYL3NoTFVROE5wUFNjRGNiNWFhdVl6enJsRHBZNndyYkdKeTY5?=
 =?utf-8?B?a2szRmxIcWxLNUt1U21Zd3BGRi9vUFVqMnlFOWcrcVZXdWlBRHdNVlBxYmh4?=
 =?utf-8?B?eXBGQ1J2UlJrak1IUXJ3WE9yNVgzL0YxTm5CenIwaVlGeG5hNDg5Rkk5Y0dz?=
 =?utf-8?B?UTdWVHRYV2JSekxKS3RMeHZzOGRNOGNxRVR6YVEyQ1BnaXcyRWdNeGNwNWN3?=
 =?utf-8?B?L3NvVFdwSzZMa1pWZTE2K1AzdlBsYi8xeDJ2M2krVG95dUR5YlNBalZIR2ky?=
 =?utf-8?B?YVRQdHJCYTAxVWxFZW5YS3NLaThNS1ZPL3dzdnpIcmpCZDEyU3lWWndQZEdk?=
 =?utf-8?B?ZVJ5Zjhua3FIUnFsVXVVY01UODExbUl5a1dhV0xDeC9BZGJHSGRUWUFEZzBS?=
 =?utf-8?B?SFhac3hzaUJydGgzVU5oWkxBb3lKNGUxOUs1b3k4dVRaN3JZWXhwVm1vL29G?=
 =?utf-8?B?OGJRKzF5Yk5HYlZTc2krdjBqclZPdjNtUHBYNmtoQytLeTRGbEhvZ3JaY3R0?=
 =?utf-8?B?cFgvWWtueFZFd1Fpcnd6QWNPOEIzaTM5bVFFV1MrOVdRczJBYWxxVVlPYklQ?=
 =?utf-8?B?THR4aWRuZkY3MGMwWTU4Q2JQd0s2Z0dScGhTa3l1TStqUDhGKzBBcWNkNlZn?=
 =?utf-8?B?cTB4bytCOXRLMzUxZGg3V3BLRC9yU284c1I2MGxmejNYRE5lN0JKbU9OTTMw?=
 =?utf-8?B?V2pmbFdWM2xOd0NKS2MzM0d0SXAzWHFNUlIvR0l4SGZDaUZ5Z0dhRUxRMzI1?=
 =?utf-8?B?VmV2KzltVG82b2tUMnBZaVBCNTdHTlhIWmdzNWxBdDdqbXg3YzBoYXBvUnhm?=
 =?utf-8?B?dDQ3bUJvUTdlSlVzTFFIOVp0TU5mNWd0YkdVanF4OEZVT0lzaHVKRUNpRnpF?=
 =?utf-8?B?eUdJWUUvN3RUaWhFUjNheXlTa3B0dFBUYmZDYzZDQVlEaVJ3eGVtTXVrRTQr?=
 =?utf-8?B?UlpPa2JYS205elRaSHpkSklwZThqTWFSZUdTYVRQT0JkOGc2ZnpCcGI2bGZJ?=
 =?utf-8?B?cHZ0VWNMbExqSjBCcjg1azVzTGEraE9VV25YQ2ZhNDUreFI5Zjd2emVGZi95?=
 =?utf-8?B?Y3daZW1WQWsvSElYOWM5T1U2QmRPTWgyb2dJcWk1eVo0dzVUY1pZNS8rSGdK?=
 =?utf-8?B?NStsN0lhWHFRbmd0SnhsWXJpa245MGZTTEtVbUFaMnJBT0ZMbWlPUm94end3?=
 =?utf-8?B?QlBzYTNaRmp0dFA2d092b0UrMTczL09MOWlYMG1FN2pzakI3WHVzSEx2TXRS?=
 =?utf-8?B?UzIzTzRPV2Evci9DaW56Si9MMVU1ZGUyRzU0VnhjUExJMHgySHY1SFgySnFY?=
 =?utf-8?B?YVFwdGFTZXNFbzdqUGhSZktXbXc5S0IrWjhZT3dXaVNFVUZKRVQrRHVCU0pV?=
 =?utf-8?B?QXpyeHhhdzhGVkFSY295clBNT0ZjSUZSQmxwa2tQUEhpSUNrbUtBaTZpYmNB?=
 =?utf-8?B?WEhwWUpXbjRXK0NPSUJEUUZ6cFpySDJxRnFxMndhQjNnOTIwbUJzcHV4am5K?=
 =?utf-8?B?ZVRrbXF6SWtWTWtXZDlwSXpWdzlQczQvU1loNXFqVCttVmFSQ0ZaSU9uZk9q?=
 =?utf-8?B?OHlucDZEQUZ1bnlFb2lUSGdpSkZ0cCtEKzNrZmk4dlI1UjV4Tk4zNXVOVEti?=
 =?utf-8?B?RDRHSTY1eUhIdGMzS3NodTErOXJlN3BySzJoczNSTnR0OGM1WHZPS3ZnQTBn?=
 =?utf-8?B?QWN1aEsyNkU3emkzZVN1eFpwdDlvMVF5V1dnQXJ2RmI5QS9ZM3ZVb3l4blRz?=
 =?utf-8?B?eFRNbGhURmxwR1hKeGJSZExwYzBQRFNFTHN2SVBPQW5wbm1JMzJwSDBZczRE?=
 =?utf-8?B?dGM5aUZKSTJzaXZ4cndmZFloUEVnNlJnMS81U3hpNEtUT203NE5KcW5oZmVB?=
 =?utf-8?B?cmJKODVJdkVUUzNNQ3cxQ3JtZEM3OGNxZy9pVFVnbmlMS2c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHhWOHhOUmtJcWpVMHY0YkljT3VoNkU1ZHE5VU9CMEVEb1NCdkFmS05CYm5p?=
 =?utf-8?B?OEZ5SjVkV3M2M2l1N05SeVVYU0tFSUhmd0xyQndhcGJFTVBTOHBUWlE0RVdG?=
 =?utf-8?B?T1JaVE94STMveGNwMXduVFpZYi9qSTRKV0FsOGZCcEUvSGJTS3IyRHhpLzYz?=
 =?utf-8?B?L2FReGwxWnVuNFltZ3RXSTc2TGh3OC8rSnhSdHNrU2llK1ZiQjlheFlQa0Jz?=
 =?utf-8?B?Z2M3bDk0TFZNSVJkZjNOY01Ka3FZNE1TNUM2aVUzdDNzNmt2QWVTdE9VYzcr?=
 =?utf-8?B?VlMyZk9PRWttRFlSOEpFMjZLQVNlR0puUG1PVzl1UUlzUHlTb3g0TW5lMU1u?=
 =?utf-8?B?bEd4VTdiWmw2ak9HcWRwdjc1Z29VWldFVy9HR2YwOGlmM1FkN0Qrd2FnWURY?=
 =?utf-8?B?UWZyN0o4U3d4R2lDZCtjMGxwWVZXMUtWeHpJclI5a1JSOFZqTDBTcTF1cmFi?=
 =?utf-8?B?RzMzYXBselRvUFhHcG9xWW0vM0Mzb2YzQ01MT0hoTFlqcEFIQmQrQ0pNK1FL?=
 =?utf-8?B?aG11TVZrRWV1UTdxRmRDTHNLRDNYazB6VEtrckNBeHFPemJydDhScnFQV2dW?=
 =?utf-8?B?bXZucWVqeSthNFZld1RPN0ExZ1k0V2kwRUprV3NzTG1FRmFYeGg4T2F3a3Nh?=
 =?utf-8?B?OTAvQ2twc3BnY3ByVXk2OHZXSXlZL21jZUhyVzQrdGhXSTZyVDBCMGNyc3hh?=
 =?utf-8?B?b3B5MGwrVDN4K0MwVlNNWnFCdEV2bndYOVp0cXR1WElYSWkzMGMxVFdQZER1?=
 =?utf-8?B?ZUJYWEh0Rzl4NEpwQTNGanhiUUU4ckJJK0QxcXJEQUJZV05SVyszejZmemM1?=
 =?utf-8?B?L2FYbFU4aThWYXJhUGorZnZKNXdXMS9rOGlWdXo1Mjc4dzgvcE9BRjVna1d1?=
 =?utf-8?B?UXJTc09yUDNXajNHanNJaDhKNEJwVWpkZGdXMDcwdjVRd3VXcnFyM2JMb3FX?=
 =?utf-8?B?djMzTE9Wc0lXNmRTNWE4QTlPRmlqbWlWWDI5YWFOOTRlT0RMTDZWb1hpVVIr?=
 =?utf-8?B?M01nNkVYVVA1YVh1emhUKzFKVTU1bEVrdDRQTlBDaWx5b3dnM2JwNlIxZ0Z4?=
 =?utf-8?B?Y3pDVExTd2hRcXJQVHZrc29ndGdJWmdWRUhQQ3I1NnM3OXZQcCthREVLUXpr?=
 =?utf-8?B?a1lXTzZ1L0h6eTF6WElNdVJ0QVBsaTEyUTNPYnZHZEYvbzVtR0ZRWXpZOUlh?=
 =?utf-8?B?MlIzT0pyVi8zNW5vUit0THZGYXR0ZWIwMllydHV4TDRuM1ZpclQzZmJzaG83?=
 =?utf-8?B?ZEJER1djc25sMW0zTVRMQjJGSCs4d2JqS0Zyayt6WkU2cFQwSGdGbGRtNzYx?=
 =?utf-8?B?NWlrOE5xblU4Mm1HdGpxVGlXVmU2dmR4cUVMQjQ5WEhpUXgyK1pnSURjb3Zq?=
 =?utf-8?B?Z1hKd0JLaGdiSXBqdmFJUHRRRjJjOU95MzM5TTExUHYyWkRGQnZBNXZVVXlL?=
 =?utf-8?B?YWhSNTlHSTAxK3IxZmswUUVCNzM5Q1lUeERKN2NVL0Ryb2pnTmkrVG1kQTEy?=
 =?utf-8?B?ZWtxbUR6dGhiVTJxellvV2Y1VjVSU2ZIOEFsQ3VvMGtma1ZaanM0U0IrWjB0?=
 =?utf-8?B?L3NkMUJzNjMzVGE5U0FURW5LWWN0NTU1OEFsM3llZVd4b1RJaE5SVVE3RGR5?=
 =?utf-8?B?V1FLWldySG5mdUtwOHNzMi9zZXNhSzlOS3U5ei9kUHoyNUY4V0lwZ2dFY3RL?=
 =?utf-8?B?VkZGNU5weXR0T3FMRlFqdVQ0Y3o5bk9kRm96dVVmTnd5cTdKMVVGK1JiSU9i?=
 =?utf-8?B?bVo0elN4VXpPZzZiRW1PVGNZQ3l1aWFoZnJua1Q5WmF6TE5POWxEYXVmNXV0?=
 =?utf-8?B?L1pQcFZjNTNCdkxwVHd4VGFzQS9UTE1ZdmRyUC9qRTZOaVRNL01SRlR4LzV0?=
 =?utf-8?B?dGhlTFVwM2hFUXFKYTVsWm1qMW1PQmIycjBYanpMaWZyOVZ4SmxUL2FrWXBt?=
 =?utf-8?B?UC9zNVNqVGFuTU1yVFVIdTFQMktwVEVVUzE4S21mNmxkemh1QmovTk10YkE3?=
 =?utf-8?B?MUxDblcvdGlheGlhSFF6ZkQ4NHZubnlQSHZRK1poNk50SmszUi80SEN5di9M?=
 =?utf-8?B?T1UwVURXcU9Ec0ljNXZjbUlTQUNpbVl4TVpDU3JmOEU0YlVhV0JYWEpEZ2xK?=
 =?utf-8?B?SGlRL0ErWWFISENxREdRU1pIQWIyczR2c09ub0lQMWk5Ly9rSFk3amllT0lI?=
 =?utf-8?B?UWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	anVh8TpRV+W5VhNWcn4apwQUCROjqNPTdrfTQYS7prriSAzRopnH5nhElb3hVc8Edd0QSo6SMLFKlNLZ8HBLP+sTSsiyBGD/LmTpssZZn2DUEErggtHzXFB35oj92ktYtwvNQCC8314qIAQ9ghVAlhs+e+6EkhmxDQoX9PygRhxoe805iOFMPmn6fsB234eC/4482mYgxH8VUt6Go1Tq7zL9OsOT4XpjIhpjTcofWsou/wZbfuZVMkjwgn6UZQoBK/IbdMHsYmhI3SouoOZUhyttEzWpudY6x1oozuB+rEZ6z8oD484uRQDzBf5UgBQkvV2IfNaUAsnc08dObUorhkGtXajxwCKZoxIW7MJv86RY1r0DlHHGRYClDhd7wGeUWi7PW7ktdWND0Kq1Bs1ksAZq14ncy7kHJZFPaKk/M60kSksIUSlfXDGQaUyTvobJhsMPkZwIwaJN9azDj+VIzt2L7h7UfOI2LHhkpO+Lm0h8eVv2oyvX1MnpRL12i1TCvdEFzb9mK2kN0NDQSU78VUyIadSq9WElCu/ujcrfYKkc7N118ldOKe6/+ndCR6LW2tBAsNMp6xDHNTxrp958EAZcmXbF1QNgda5r78zFMPg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f565992-79a7-4485-6adf-08dd78752d2f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 21:18:02.4136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oGjN4zkVB0HW+4xDs6M0Z5HpqeK/fuER+LC/D4m4EroyXOkIzkv49VOyrCesSKG7fWrr8FBGzxi3gd20eEezuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5858
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-10_06,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504100154
X-Proofpoint-GUID: gygysaWpijnmXHaZYSO90VhQRr7_vRZR
X-Proofpoint-ORIG-GUID: gygysaWpijnmXHaZYSO90VhQRr7_vRZR

Hi Zhao,

On 4/10/25 12:43 AM, Zhao Liu wrote:
> ...
> 
>> TODO:
>>   - This patch adds is_host_compat_vendor(), while there are something
>>     like is_host_cpu_intel() from target/i386/kvm/vmsr_energy.c. A rework
>>     may help move those helpers to target/i386/cpu*.
> 
> vmsr_energy emulates RAPL in user space...but RAPL is not architectural
> (no CPUID), so this case doesn't need to consider "compat" vendor.
> 
>>  target/i386/cpu.h     |   8 ++
>>  target/i386/kvm/kvm.c | 176 +++++++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 180 insertions(+), 4 deletions(-)
> 
> ...
> 
>> +static bool is_host_compat_vendor(CPUX86State *env)
>> +{
>> +    char host_vendor[CPUID_VENDOR_SZ + 1];
>> +    uint32_t host_cpuid_vendor1;
>> +    uint32_t host_cpuid_vendor2;
>> +    uint32_t host_cpuid_vendor3;
>>
>> +    host_cpuid(0x0, 0, NULL, &host_cpuid_vendor1, &host_cpuid_vendor3,
>> +               &host_cpuid_vendor2);
>> +
>> +    x86_cpu_vendor_words2str(host_vendor, host_cpuid_vendor1,
>> +                             host_cpuid_vendor2, host_cpuid_vendor3);
> 
> We can use host_cpu_vendor_fms() (with a little change). If you like
> this idea, pls feel free to pick my cleanup patch into your series.

Sure. I will try to use host_cpu_vendor_fms().

> 
>> +    /*
>> +     * Intel and Zhaoxin are compatible.
>> +     */
>> +    if ((g_str_equal(host_vendor, CPUID_VENDOR_INTEL) ||
>> +         g_str_equal(host_vendor, CPUID_VENDOR_ZHAOXIN1) ||
>> +         g_str_equal(host_vendor, CPUID_VENDOR_ZHAOXIN2)) &&
>> +        (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))) {
>> +        return true;
>> +    }
>> +
>> +    return env->cpuid_vendor1 == host_cpuid_vendor1 &&
>> +           env->cpuid_vendor2 == host_cpuid_vendor2 &&
>> +           env->cpuid_vendor3 == host_cpuid_vendor3;
> 
> Checking AMD directly makes the "compat" rule clear:
> 
>     return g_str_equal(host_vendor, CPUID_VENDOR_AMD) &&
>            IS_AMD_CPU(env);

Sure.

> 
>> +}
> 
> ...
> 
>>      if (env->mcg_cap) {
>>          kvm_msr_entry_add(cpu, MSR_MCG_STATUS, 0);
>>          kvm_msr_entry_add(cpu, MSR_MCG_CTL, 0);
>> @@ -4871,6 +5024,21 @@ static int kvm_get_msrs(X86CPU *cpu)
>>          case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
>>              env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
>>              break;
>> +        case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL0 + AMD64_NUM_COUNTERS - 1:
>> +            env->msr_gp_evtsel[index - MSR_K7_EVNTSEL0] = msrs[i].data;
>> +            break;
>> +        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR0 + AMD64_NUM_COUNTERS - 1:
>> +            env->msr_gp_counters[index - MSR_K7_PERFCTR0] = msrs[i].data;
>> +            break;
>> +        case MSR_F15H_PERF_CTL0 ...
>> +             MSR_F15H_PERF_CTL0 + AMD64_NUM_COUNTERS_CORE * 2 - 1:
>> +            index = index - MSR_F15H_PERF_CTL0;
>> +            if (index & 0x1) {
>> +                env->msr_gp_counters[index] = msrs[i].data;
>> +            } else {
>> +                env->msr_gp_evtsel[index] = msrs[i].data;
> 
> This msr_gp_evtsel[] array's size is 18:
> 
> #define MAX_GP_COUNTERS    (MSR_IA32_PERF_STATUS - MSR_P6_EVNTSEL0)
> 
> This formula is based on Intel's MSR, it's best to add a note that the
> current size also meets AMD's needs. (No need to adjust the size, as
> it will affect migration).

I will add a comment to target/i386/cpu.h, above the definition of MAX_GP_COUNTERS.


Thank you very much!

Dongli Zhang


