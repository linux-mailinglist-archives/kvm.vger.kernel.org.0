Return-Path: <kvm+bounces-38883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25890A3FE24
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 19:05:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 168EC19C2F1B
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 18:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E4F2512CA;
	Fri, 21 Feb 2025 18:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LiuPDBG+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="A1ltRY+f"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E611E9B23;
	Fri, 21 Feb 2025 18:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740161030; cv=fail; b=WCSTUH8O0Ynesq5LztOk9n0UvQ3LOsD2YrV5iz+69/kTyYySTaXmVn/pnrKWPmu+BrDE0bo40jhS2NMFHqzYAZKxG66A2znFcsNnDvJJrtx3ciXXXWNK2h4GVgA9guRgaVoBYNOvAthPjgt+y5oFnOrsy9Lb453GIRoiIShtlgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740161030; c=relaxed/simple;
	bh=xP2901ZAT+nLVHHdhSw0TQPCSKWWoJG1Y/ZcKhmOAhE=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NtkIujd3rqH7iwpEipK/fpZsyj9/uQ97pI1/4TBoPHzUYU5Lw7BcSmHDEEPuICtkN6h54v2iFzI4ZCPj7fgc/K/16/OcDhGX0LQFpj4ofgL1WFI/fCfVmk7kZu+PI2Cu+E8fq3LczkpT/QMtoBtoKwkt1f8K/fdyOD20/Yfn58A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LiuPDBG+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=A1ltRY+f; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51L8faO1029766;
	Fri, 21 Feb 2025 18:03:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=pHK2uBLpwx1J8PjqO8qyCLlz9Mp5rs30x9bYLVCDDh8=; b=
	LiuPDBG+38SnGZCJl+oDV8Q/dXpHnCcdelzqg/g1imugq2zy/roEZ1ECd4drOMFU
	KXjjgGH7p6qLURSyvm4F/2lV+iFxd5JP7zSKcZtYHGfAi3D/Lvr0ZH5JTqY0SUDw
	6t+an/7JvycK1v73JLg906m9gaWIplMevLEKphUseJ8YFBC89w467cjEynLW7rq/
	3dctKepKHuwsOJRsegf8oOJAfYfxwDeUhJ/0/fcT9x+lcFuvTEnpn02tISO9y8A3
	lnjfalJhgNzYi3HdfMYHGVIFSK5qoQFoHEyjBWj+jEmwzBSKQyxus+SsmQ+EU1u5
	dvU1nE7h9bkaobsplYXi1A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00n6ru2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 18:03:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51LHO4kj002063;
	Fri, 21 Feb 2025 18:03:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44w0tq9xtr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 18:03:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lixlg79zfYNv9GStH8nNsb/5uTvBU3hL6Nd44KXlcvDvLf71fyo5L6njfpi+X60XDqmr2CFiI6n1mATmQEy6yguc/64cZi0wOWM4UcBqdVSqToq4+URT9LyOr3GKeKNJtaLcGmtGwHHT+DyDZGGppNO1wWeh9EPRT9s8Awg+nCC4t88X18nT4iuOFLKrOp0s8aZzsYF0fXZBen/KlTsI50apjlF3DCe2DfPm8pMbfD4+7BWAAoksjUPG7Hfpjg/2Cc7cQtDKBqNCNbzGbRkR4pVRNueCfIBaczyLK50RU5Af+wF+BrZeg0i+8ALXpDaZlP6Urx14GyUZvzDG5N+/1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pHK2uBLpwx1J8PjqO8qyCLlz9Mp5rs30x9bYLVCDDh8=;
 b=TsETEUxohav9omSF9tuC8Dbi8nyHUfpfpDmGqzlV/Nm1PfZ+ve9yAz6ttQfInN5zdfBky/MQm7avEM+NLrFzSScQHS/ePFoTOonPlNFK6V2Svyj7pgSUqNXdEX7yr7emhDtIjbFyOig/OJkf5pqLZ4hprIafI9aQXKsz5Cq++evQj3oSZv+J39RFhMnFJX0vuvvODJH6A29GgM3WlfBtCTg8ic9qEdpheCcmx+ougkP3p+EwCPbO6ScNKk+khAAePwOKnZsTKvaDvBNjiYRCUJd57ftNjs1BEJF0M59ZX0uEthD9HlhON8j4M3yvbPBc7R0F3hDFlZ7/7H3T6ZNU/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pHK2uBLpwx1J8PjqO8qyCLlz9Mp5rs30x9bYLVCDDh8=;
 b=A1ltRY+ftvm3+y9Yk/IzhBfR7IfGCIoNgmSenka+edExOPmItH/NtVC3l3cG/HrDS3RJVMOwaC5gd5raTeFGO5dx/tXd7hxPnyWkQxSE2OZkVJyJxkPTVv5UdCd6kSfDAk8q0XP7ij5yPnVziB9aca+CQ+R6OBI0Q2edfqwtFXc=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by CH3PR10MB7632.namprd10.prod.outlook.com
 (2603:10b6:610:17f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.16; Fri, 21 Feb
 2025 18:03:39 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8466.015; Fri, 21 Feb 2025
 18:03:39 +0000
Message-ID: <2bdf263b-b0f8-41b6-8b40-6ace397e9bf8@oracle.com>
Date: Fri, 21 Feb 2025 10:03:35 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] vhost-scsi: log write descriptors for live migration
 (and two bugfix)
From: dongli.zhang@oracle.com
To: virtualization@lists.linux.dev, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        michael.christie@oracle.com, pbonzini@redhat.com, stefanha@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250207184212.20831-1-dongli.zhang@oracle.com>
Content-Language: en-US
In-Reply-To: <20250207184212.20831-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN0PR04CA0151.namprd04.prod.outlook.com
 (2603:10b6:408:eb::6) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|CH3PR10MB7632:EE_
X-MS-Office365-Filtering-Correlation-Id: 55594c88-e1bb-4ba4-545a-08dd52a21190
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clhMdForeXI3VGxpOTdFSlIwa1djVTE0SGpaaEU2eWpDZkNkUHRnWTFHYjJa?=
 =?utf-8?B?SXYxZWExd3VNTWFRblZnSmh1TFRzUEtlUVB6RWxXTUNTWC8wNTNVQmp3YTlH?=
 =?utf-8?B?L09FMko5QVdQWUFoUXg1WEVxeXZXQXVEempaNXVTdkFMZGZlaThQWlNsWUcr?=
 =?utf-8?B?S2NsdE96dXFZYjFNbnlkUDBWN2pvZEZJZ3ZHajRsZ2tzVEE1eU1RRHhFbnF4?=
 =?utf-8?B?eGIveWdaamQ4T2tGRFc0WDZIRVd6VDJHZmN0Q3ZYaThZWTV3Zm5mUENNZWVP?=
 =?utf-8?B?ZjFtVkJLaURER2JJOUtDVFA3eFVUK1hRc3lVU0QvSTMyWm1UOHlZaTBZOG1B?=
 =?utf-8?B?RE93b1haeG9YNnc3QnlZN0Z6ZDV0Ujkrd2hFalJUeTRMeWNtUHE5VHhtVjE4?=
 =?utf-8?B?YXc2STdUQXRzWFljUnVEY3dzZ0wwM2twYk5hdzQ0ZWtHU01QRktjZzJsL1gy?=
 =?utf-8?B?RnJBN3FiWVd1Z0NaQTBSb0gwbk9ZSmw1WVN0d1BhcC9ocHFhYXZSK28rTW51?=
 =?utf-8?B?cDMyMTh1NnNremtIQXdRZ0Yzcm41cWtjL2thSHpIdE44N2t3bjZtZllsNTRE?=
 =?utf-8?B?ZG5JdmRvR21xeTZpSlhwWEhWR3M5ejZHcHdlYjU3cmkvckVOUVJZYTJxMXhx?=
 =?utf-8?B?VXBzRWRaNlJQYVpmUllqMnJKb2ZibE5NeCtxTFhtQlhpME94di84WHE1QW5Z?=
 =?utf-8?B?V0J1SXZLWUpvaTZBbFlaek1KaU1UN3ZGNkdyc3ZOR1FaeWdzQ3liYUMvanlv?=
 =?utf-8?B?NTNpUjZuZnQ0MFVRVFRoMFpxTTRLUzNyTTQ0RlR1eDBkTEhGdzJVb1FCWjFW?=
 =?utf-8?B?N0lyVTU2ZHFmZUpFTVo4R3NiUkJINVpZQ3FKbXAwVUZPRGJ5QXRBUzROZmZr?=
 =?utf-8?B?QkRWUVhQcHpCbUpQMFhNM1dvUndIVFNBSUo0c0N2dm9IWXA2cytaUXAyZEVp?=
 =?utf-8?B?ZVh2eGkwT2xCQVhlSUNYeEJzRHVFcGlZWmtDOGFJSTVNV3pWOU4yMzl4N2Zi?=
 =?utf-8?B?ZWNJNVY1SWt0TkxoV25vRlJPZ0FWeGZQZ0RSTC9ML3p5N1MxRXQzZjNHK3FM?=
 =?utf-8?B?UDJxWGxHUm9YTjJ6c0xubDdNT3hTN0t1WXB2ZFhDVXdxUFlLUGFVWVcza2hH?=
 =?utf-8?B?a0w2NFh6WDE1UmtzeEZuTy9WZmdFcG83OEZUb2ZNU3NBaDVFc3VhRHhkMTN0?=
 =?utf-8?B?Smp2VXpNQXM2aFJYVUd6dERON0ZYcDJpWFJDcWlacWp5VVAxaTNnZ1AyTXd0?=
 =?utf-8?B?bUErMWN6bjNJb1J1ejhmbDlBS21TTHBYRGM2Ujl4Z1ExUHVvVWtJazkya2w4?=
 =?utf-8?B?OTVGbHpOWHRLUm52N05vaGx6c0hSWTFXRTFLVXNYTTlYeERORnVLMWhJMGI2?=
 =?utf-8?B?MThqYjRRendkck9lTDl0UHNSWjZodWJBSXltcTkraUt5NWxjK20rUTVaWDEz?=
 =?utf-8?B?bmJuWVFwRXZYeVc2Z3lTdjdXTVBKc09HTnRmUzduVXNtQUI0WlF0ejVOWDQx?=
 =?utf-8?B?bXRIT08xRFR1Y2xMTlVhKytsTjhSU2xzaTBlSzZWYVpRakwzNHQ5Z3d1dkt6?=
 =?utf-8?B?QWJ5LzZsTjR1MVJFWklUcVpvaUo1N042U3YyUjZheXpSa1ZFUVZZUmc1S0Zh?=
 =?utf-8?B?WWttcUdWRUNCU3FYTHRFVHFGbmttb1V3Zk1Ec2VHWGdCSjYwc0RIQ1MwdDR3?=
 =?utf-8?B?dEZIdW5Yc0ZnSFJiWlVwS2M4Qk5YOS9PV0VsZlBQZ0lKOHV2R05zZldSdC9F?=
 =?utf-8?B?UmhhM2ZaQXV1ZkNnOEdtajBNbWV2YUhMbm54YUdhMXc1MnVyZXlFYnNZUGl0?=
 =?utf-8?B?ODU5QlV4S0RheHFib3gzdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NDhRWi9PbXpqU0x1dzFkalo2V0p6RTFBOHl4NnJDK3lVamdiOXhFN3lWeE1F?=
 =?utf-8?B?U3FGemsrc1hwQXd1STZNelRNS0wrS2lJVGh3MHVZWlIxMStmQzdNNGc2Titp?=
 =?utf-8?B?cGNjN1AzV0xtdTA0dVRibFFQT29reUpkaDhMOVZjWGVyUitudSsvWnpUZEpt?=
 =?utf-8?B?SlpuWlVaOVQ1dFIzNTkyYzdscmNWZWZ6MnBFZXErYzd1SUNzRHlRM0ZPelgr?=
 =?utf-8?B?QVVwS2RPM1QyZkZwWGVMb25yOVZ1TTI2QjJvUkc4bERLU0NVMzBVWWI5V3Nw?=
 =?utf-8?B?ZjU3YUZ6MGJUTFlxdDlQSWdmTDFyUEJOY1pNYXJyMTlwdzFRNVV5WWZKZitv?=
 =?utf-8?B?eStFNk9TTllZUm8rdldVdHBLa3V0c1BiQkhLM0xXYkovMjNoQ3lsSXVqZ0R1?=
 =?utf-8?B?WkIyYTFtYVVxdmRxVUtRb29VY0EzK1hVQlJoTDVRUlNVb01ySGJoZGQ3aURE?=
 =?utf-8?B?VU4vRVJTZ2xzY21VQmI0MFVDczNHcjZjUFo3UHBKUjIxR1hvUHVrVDAwSS9O?=
 =?utf-8?B?Qis3QmorSG1ocm5KS0xUVElBZm44Q0dVUktYWFM5NXNnQTdmUjFTei9NSVBU?=
 =?utf-8?B?Q2hscmFnQWY0MnFnUHA2RHNHTmxhSDEzS3dHVUgxQVhLc2sxY3orOUUvZFVE?=
 =?utf-8?B?RHF5c0hpTTVick5ORGwwckJVUEtjcWpmYmdEbC9BcHZqR1RyYnZ0YzhHQnJT?=
 =?utf-8?B?T0RCMGl4Z3ZkdnFBd29OcEQyZlR3T1BuK1ZkNVl4a1IxUytHeFptRXRHdWQw?=
 =?utf-8?B?NytHUjJhNWJHcXFBWHhRcUJISnVrVkNTSXJDUFFJbGRyd21uNmF3N2hMSkVx?=
 =?utf-8?B?NElGM1o0TWM3YlpJT2FERmhrQlQvK2hrWVJ3d0xEZWRQU1pqL1hYUlAzTGlH?=
 =?utf-8?B?RzlWdXR5d0pWY0JhUk8vdUhiL3p5K1hyeHFOUVAwOTFMWHNFSmxyS25SNlpv?=
 =?utf-8?B?QnpEaE1VNG1tMXhnbG9EbTY1VkUxUkh3bk1POVVZSE1mV0dRS2trS3JnOHRY?=
 =?utf-8?B?WHN5VzdtUGZTdks1U0dlU2xaSDUrdzBtZEFEZUhSOXF4VEJUTjJ0V3JXbWNm?=
 =?utf-8?B?RUlDaG1uY1A2bTl3TGFzVTU3L1JkOThpU2xNMWFpd2xXd1U4RXN5bE41Z3Zz?=
 =?utf-8?B?S0k3SnFBSUc1enFVRFhBdlhpRDE2Yngwc1dmSkhYcWRUUmtQU2dMdm9SV3V5?=
 =?utf-8?B?Mm1MNFl1ejVKK0JBMC9zT3gvNEhnL1Yvb3NlR21sd0FGaGxPYjFxaXo1NkNi?=
 =?utf-8?B?d3hYai9NVVBUdFZoSm5MR3BGSG5ZTFgyU0xnQjU2b1ZqSit0RTB0YlRNVHZK?=
 =?utf-8?B?OU11YTU1NTQ4WlFpdE5rVERNSG1aZUtvNExhV2hPeU9ESEN3ZXpvTmwyUlN1?=
 =?utf-8?B?STBYUENnWUQ3QWk5NHVsZVJvUmVhNU9ST25SWFpWZHVYYjF6eTNHNU9jY0Z4?=
 =?utf-8?B?bGxPb1hsaFJ0ZXJwT3NwNitCb2xkQnRUUVFhMFRFbDI2K3BxQXRLM2xBeWoy?=
 =?utf-8?B?Qkg1dEQ5VWJpYk5ybzRsSUJySDh2N0FjSVRpQjlXeVU1eEk1N3FMSm4vWnlC?=
 =?utf-8?B?U24zTTFwQmVkcU01M3dHUEE1QzdEUGFpNDNWeDRWaDBPYnBZSmNNekpnaUwz?=
 =?utf-8?B?R3hwRmVoMWhPNGhWZksxR3FGZHBqTnRZNWlITFBUOWdsOTE4WU0zeW13Sndr?=
 =?utf-8?B?MVBLN01kaG1rMU1SNkIxQ3VNcFZuU29Mb1Ztb2JNQkMvbUkwOUFkdElZaVUr?=
 =?utf-8?B?UTZIMFFJNkJrcjdwNGtQNFBCdTBNTnlJZUVmWDE1Z3pwalJadlVmZlNWZ1h3?=
 =?utf-8?B?MXlEbGw1dy9vZW45RXVsa1oxdlQ1blFZb1V3SWlDUWV4UEk2VUlJc0VoRTEy?=
 =?utf-8?B?bEt2S2o5ZVdkQnlOMGtnVmFvSWRVeUpXejBMeDRyVFdQWEVJMVUycjFmQmdn?=
 =?utf-8?B?ck5CalpJZVBFSzFvemF5OGV5czlMdkZaM3NMVzljSEJ1VzEvaGZzdDBiS3Uv?=
 =?utf-8?B?QS81TEp5ajFzMHZ2SHczK09jbnZBSU14aVNPWi9Hdmxmbzh1NEZTa1ZSc2Nh?=
 =?utf-8?B?UFdFczExdzZVaVppa1R4RnMzamRkQmZ2YUtOSDZSeTlKTjBUTUxnN2l5QmVB?=
 =?utf-8?B?RzJub0VlR1BLK2QyOEVIV0hWeXg2cCsxdEMwYVp1UFBtdzVlNEJObGM2eVY2?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GxpMdR9B2AO3eljcqrGUqQFJip1YIY+682iE60cIadt13TnDsaBBpvkvPz7ixUL+iI2uhlcB79h5Kn/ak9hmDvs7IkaM3SzBXeRlb2x26vuTh5QyUQfCJKIdemJMg/eyW3EQU8XSOjh2qWqkItUfJx4veNy7e9ZYv1owfnuJJPeto7yVx5YqnQglbUU5dh4D8sHGRYIPZL4Dj1YS70xxk99lmq+xE6EoBAS8HH1ZxiRVrfA3pIaOSRCxHVtAAZ00Ngacmmd4SQtKNNur/ym2J7jteA5aRUxWKbTyXyAip+1F4yUrg+1eGKK/YViTtbsbeFobysvIUokme2K/GP94vYrOOomezOf1eM1OGwxGhaxowVZTdCKrLgUPOSrPE2Px++2Adr8d4lMY8we9+Q+iJPg3Dnwj+mmcH/mRXhjLzxjpOrPnhT2cnQQ43JkpznJ7J0xBYCYapE3Td3UmWwFML2RxHM6Ops5NCm1fupX2lybmScOV1thuQKAc3z6FDgI588WdOvh70mtudmKhTkT0FAMLj1bE+T33dCnKrqq9AIrERnBQPqDeu68poNnf7pwpTGqgOOu16YaFqKZOR+eGR8Q/pOPJWnNXunRPdUpf+KI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55594c88-e1bb-4ba4-545a-08dd52a21190
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2025 18:03:39.1523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zySrswKg1wnXYnc+4WzhwLef0ebF3ORhNdX64LnTDKE2qqAl+Dm9Qoux9a73bpVVQ6hOPTtbLTXKPuu/l9fxGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7632
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-21_05,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502210125
X-Proofpoint-ORIG-GUID: 3EwaMvlfoRiOrsAr4QHeo6EYDARh0VPE
X-Proofpoint-GUID: 3EwaMvlfoRiOrsAr4QHeo6EYDARh0VPE

Thanks to the suggestion from Mike, I am going re-send v2 with:

1. Re-base on top of the below patchset.

[PATCH v2 0/8] vhost-scsi: Memory reduction patches
https://yhbt.net/lore/target-devel/20241203191705.19431-1-michael.christie@oracle.com/

The patchset can clean apply/build on top of the commit 87a132e73910
("Merge tag 'mm-hotfixes-stable-2025-02-19-17-49' of
git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm").


2. Don't allocate all per-cmd log buffer until VHOST_F_LOG_ALL is set.

Either to take advantage of vhost_scsi_set_features(), or follow the idea
of below patch.

[PATCH v2 5/8] vhost-scsi: Dynamically allocate scatterlists
https://yhbt.net/lore/target-devel/20241203191705.19431-6-michael.christie@oracle.com/

Thank you very much!

Dongli Zhang

On 2/7/25 10:41 AM, Dongli Zhang wrote:
> The live migration with vhost-scsi has been enabled by QEMU commit
> b3e89c941a85 ("vhost-scsi: Allow user to enable migration"), which
> thoroughly explains the workflow that QEMU collaborates with vhost-scsi on
> the live migration.
> 
> Although it logs dirty data for the used ring, it doesn't log any write
> descriptor (VRING_DESC_F_WRITE).
> 
> In comparison, vhost-net logs write descriptors via vhost_log_write(). The
> SPDK (vhost-user-scsi backend) also logs write descriptors via
> vhost_log_req_desc().
> 
> As a result, there is likely data mismatch between memory and vhost-scsi
> disk during the live migration.
> 
> 1. Suppose there is high workload and high memory usage. Suppose some
> systemd userspace pages are swapped out to the swap disk.
> 
> 2. Upon request from systemd, the kernel reads some pages from the swap
> disk to the memory via vhost-scsi.
> 
> 3. Although those userspace pages' data are updated, they are not marked as
> dirty by vhost-scsi (this is the bug). They are not going to migrate to the
> target host during memory transfer iterations.
> 
> 4. Suppose systemd doesn't write to those pages any longer. Those pages
> never get the chance to be dirty or migrated any longer.
> 
> 5. Once the guest VM is resumed on the target host, because of the lack of
> those dirty pages' data, the systemd may run into abnormal status, i.e.,
> there may be systemd segfault.
> 
> Log all write descriptors to fix the issue.
> 
> In addition, the patchset also fixes two bugs in vhost-scsi.
> 
> Dongli Zhang (log descriptor, suggested by Joao Martins):
>   vhost: modify vhost_log_write() for broader users
>   vhost-scsi: adjust vhost_scsi_get_desc() to log vring descriptors
>   vhost-scsi: cache log buffer in I/O queue vhost_scsi_cmd
>   vhost-scsi: log I/O queue write descriptors
>   vhost-scsi: log control queue write descriptors
>   vhost-scsi: log event queue write descriptors
>   vhost: add WARNING if log_num is more than limit
> 
> Dongli Zhang (vhost-scsi bugfix):
>   vhost-scsi: protect vq->log_used with vq->mutex
>   vhost-scsi: Fix vhost_scsi_send_bad_target()
> 
>  drivers/vhost/net.c   |   2 +-
>  drivers/vhost/scsi.c  | 191 +++++++++++++++++++++++++++++++++++++++------
>  drivers/vhost/vhost.c |  46 ++++++++---
>  drivers/vhost/vhost.h |   2 +-
>  4 files changed, 206 insertions(+), 35 deletions(-)
> 
> 
> base-commit: 5c8c229261f14159b54b9a32f12e5fa89d88b905
> 
> Thank you very much!
> 
> Dongli Zhang
> 
> 


