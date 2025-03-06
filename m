Return-Path: <kvm+bounces-40265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B0A35A55368
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 18:48:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 084B97AA324
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 17:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5625C25CC9B;
	Thu,  6 Mar 2025 17:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fff7LqkS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iz7ihbhP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A85212D69
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 17:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741283305; cv=fail; b=XzNq8d3rk2zWHyO0Jpd7QiMEV2WyGTOkTpJuR/B5NpZcgKHbRZ6xEZaGGg25XzotP5VtbTl9IL/w74wg8uPLhQpsUlQoviBohG21RN6V0fTHFAreS3bEd69Q9L7yCY8K2Rbdq6dkCJYoJJq+lOu5XfQk6yLNz2sorYt8v/I0hoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741283305; c=relaxed/simple;
	bh=Oto2qEESlKbTUcOUPJ/Z+RJBQnAVv2k5sOeBjCktgn0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fE3hZxlCUVM+LWYpdAY2K/l6Si3naBLUKu7dqC2FbYwTbnFPYxm8zCHPiJQqTyfAMqwrsQTOwDi22kbjlPsrVy7rsSHV4jaB6KfQg5vIFRGo8QZJgtPGdL/+Z4Tao5nAECzEVtsTL0eKA/INYe07HMfBfnZ3nU9Tu9U2Wu9CJ9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fff7LqkS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iz7ihbhP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 526Fi22P023228;
	Thu, 6 Mar 2025 17:47:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=I9k6T4icx2l9aaI0YhDcSATs3DggUukTTF8ggBfKh88=; b=
	fff7LqkS2oKpu7Ik63fbjrgOvOTWMfnAHm8RKJa6UdMHzO23kONDYt1MRtIYZaZg
	vYHmSb0DJmn8fuWIXfcwI7V5N9eVw8cE+9uSAmu2fgvwbhbSpJieA4XbX5ks95XV
	VJMK0C9zBgpP3T4f7IwCyDeVIeUsEAV9IXPrZVKccoLl7eGkdK/gRoRZdeS+SkcO
	sg1vIQW6qdAY2GNaDC8Wnp+BS38JYR8vhQxc7OBKMmViVqtRAOBMbnhdx48S8VDm
	oNvx4Pbl7qg96qhE4vWO0d4yAD1EIU22KBxqYmd2XzGaiB+bvtw+/PfYlVhYmNZf
	zvL9euqD64hBVw/0lQmT/g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4541r4agpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Mar 2025 17:47:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 526H4oMV003230;
	Thu, 6 Mar 2025 17:47:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rpcehsh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Mar 2025 17:47:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uYUtpzbe6mE2eweDFo/pLqM/sEp0d9MFkMOl3tAkCm+lCvsW2UWfN0nL9/qvNyFXosahccDfFm5kdVml4iUPACgxdHLXBd9Qb3FmjdEBfHvkcFP6tb1ZbsS0PwxF/31NdPCN1+WQcQq8Voi7rb/M5apc4Ac8kwCMbTlzgcvgnkG6789pksyMXvUwzFQtPw+emRKhkhtoO2OLl9U7iAJ/cpnhOkw2djkjsL89kwjn6TI9aMf7Aqy0jft3F1UOBNLjpCWyFxpPxoJjYsqhyKIaNGpm7vy6DG4G+H+IF3808EastpmFoKRV/5ZTH7n9ksKCYG2y6zCab1M7NvWsbTlBWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9k6T4icx2l9aaI0YhDcSATs3DggUukTTF8ggBfKh88=;
 b=FuuNlvJnsnmGlSJWX3dG4a1ILINbJBqYkv445Ge1gaZag/WafMwU7KfusY9qNhjFdd4OHQxBSKNbCp1A1IsBk69FVvsXLzmiwx0N8Ss76GVthskYZGVBPk4mx+GYZ/AR/nYEOXokuBdZtL6ng6qMgpu0HPU1pRPEexo6jfrMGQMqz52oRLDWqenvlafyTdqPiNUWml+XxN0HpS1buVQDPS6APLO4TS+s3ktvIIG1VARC2DsdyQ1nAlFY3dApYLlvMfTwMx1z9l6G/n4Bie04gpffeLg3gWwbuKTHvTG5mtegVhGsvWTS5Vsl/PR0xCix/At7kA+yP86ICwMi3JLQzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9k6T4icx2l9aaI0YhDcSATs3DggUukTTF8ggBfKh88=;
 b=iz7ihbhP6gKa52Wa6hoDBhBYj9Wc3rf2EUkoMVuHrFFgMnH2VWeAwEKUWwH6Yh1LUzaSVnFDLeui3NAaI3nPReclYclHTMZ7EC+lgOQa523FS7zPN4r/InYcnkmubOAZdmqGyGK6XrJ9X/kv5IXPu4DmBokqPjA7Brk2QDBCMts=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by MN6PR10MB8000.namprd10.prod.outlook.com
 (2603:10b6:208:4f5::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Thu, 6 Mar
 2025 17:47:32 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8511.017; Thu, 6 Mar 2025
 17:47:32 +0000
Message-ID: <483c5783-6fb3-4793-9727-2cd4263dd92b@oracle.com>
Date: Thu, 6 Mar 2025 09:47:28 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/10] target/i386: disable PERFCORE when "-pmu" is
 configured
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
        likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
        groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-3-dongli.zhang@oracle.com> <Z8nSPf4bUPICgf3g@intel.com>
Content-Language: en-US
From: dongli.zhang@oracle.com
In-Reply-To: <Z8nSPf4bUPICgf3g@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:408:f6::27) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|MN6PR10MB8000:EE_
X-MS-Office365-Filtering-Correlation-Id: f4463342-6095-44d9-e74f-08dd5cd6f8f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UnNZZHhvZ2ZXSHAzK1IzOEFGejZTcUtjUzFyc1p1VjFZOFU5MG9wUG9SZEhu?=
 =?utf-8?B?b3I3UEZxd0ovd2RuQ0RxbHFPZnpaNmlROE84NTRvVU02dTF4UGRzbDUzdXJU?=
 =?utf-8?B?QlVtVGdsc0dnRmt0eU9ja1JIK0YraTBwM0ErR1lUY1dpM0VlYnBlTnloSFJZ?=
 =?utf-8?B?aXV1UVRmVnNoVHM3eDFZRFhPNnlXUmxnQm9rc1VzNGRNUmNscXNNKzMvQ1p5?=
 =?utf-8?B?RFBleWtrZkdwRFRLNm5ULzk1dzhZRVFqMmFlWnVJUTFRL1dDT3d2bEZXVFNa?=
 =?utf-8?B?SzdPaUErbitwS2F2VXlTY2hXL053dTBGOVVCeW9QdjlwQzlwZVNxL05JZlcz?=
 =?utf-8?B?czIzNlVyVDArZjAwTWJpWGhVZVFJT0Vza1cvOHdlN0w1L3RoRHRWV0FOa1RF?=
 =?utf-8?B?YW96SmJGRTh4Z0JIVVpCbE95bFRLVE1MNHViMTJob3RXVmNnNDB6UTYza2hR?=
 =?utf-8?B?c1BiWTQ5a09FcHY5NVZsY3FjOTREWHQ1WmRkUkFLam1JMG1LTS81SUJtMGRI?=
 =?utf-8?B?TW82M2xORXBnNGd6enlBajBxd3VMK0ZnZkpYd3BBa08zKzZBYWhwVU5xUmx0?=
 =?utf-8?B?VzdqQ2lrQ2FYSVVWTVltdEhkYWNsYUR0RkRBb0JHNzg1NUQ0MFdkc1ZsZ1BT?=
 =?utf-8?B?eCtzNzk0dys3TFI0eWhzOTRpQmJhMmxJbTdZZUpyTlZVL3NMTTIxNlJoNGMr?=
 =?utf-8?B?MDZhSGdpRE9jdkdFSFgxU2hkSXVsS0JhQnArRlNHL3NXditGVHpMaHlaWTRU?=
 =?utf-8?B?MVVMbU1mRzVZZTFLTHZxQmJvNitSOWg3OUJHcHltR1FxNnhqV2JFTXNQajhN?=
 =?utf-8?B?d0lRQVlmVUNDbFJRN3ZGSllZNDR2bXBUeDUzeVBacTlCcFZhclBnNm9MTWdT?=
 =?utf-8?B?UjlmcDJUaEFIMURQNUJHUjNTVkhEM1dIa1kreWRiazM0U1RMV0x2WHhwZGVW?=
 =?utf-8?B?ZzhkeXlxSnpWUGlia3NHTktId3o0THFBdkNpZUlHWkN1eTBDOGNSZHEvdXpE?=
 =?utf-8?B?cjdNclRveVVyMldXWjdBVGpUYkc1d1lmd29ROUVXL1hzcmwyL3dSbmtpLzZy?=
 =?utf-8?B?VWdlRDMxS1VhZ1BYYklZdlZoSlJRdnRLektJVllrdGNPTnc2MTNJVTgwMzBm?=
 =?utf-8?B?TWh4dURDVWFLaGJETy9ITXlVMWQ3UEwycURqM2ZmeTF2NjhlbVQxSnpLTDBJ?=
 =?utf-8?B?aDdGZVVEV2duUTFnQ1YvRlZVZFk0cWNFMHlObyttdnZtS3M3N25VWHNkUVJE?=
 =?utf-8?B?aDN4ZXU5Mm9uamRKajdCV0JGSWNEZTAzZmtOVUc4V0c5c3FKOVAwRmVNSFdF?=
 =?utf-8?B?c0liY3JMV0NGU1k5RnBzUnN3NUEvamVkWGVLY01COWtseGJ2UEJ1ZlMwVGQz?=
 =?utf-8?B?d0g5dFBZeS8zNmhmNmtUdVVXUlpNL1YvMkc5emlFQk9wMjRYL2VaT2Vua0w2?=
 =?utf-8?B?UytHR2FHVUx6TEM1VFkyb2ZwQnUrQlRQS3pMdHE0WTIvN29GSXE0UTNnYVRL?=
 =?utf-8?B?bnRSUkN0YjNaQThBUjIxaUxXeUtEYXFkajF5L25tYXkvTFRic2pCUXVyWUlC?=
 =?utf-8?B?YlFQM2N0WEJnMVNoQmE1dldET0VkUUdiTERDdE9qT05GYytETnZjakhGMUZK?=
 =?utf-8?B?Q05hbS83YjFWWURMSERoUFBEUXl5Q25sem90SXRJQytsdkpBVGJ2alVSNmky?=
 =?utf-8?B?R09YbkdZZDZkQktqbGlIOGdMQmx5WDlJRmU1YVVaZ2s4S05XYmx0SmYzTmJY?=
 =?utf-8?B?dU4rdXY5K0FhME1FOHVxWUZJeGhDcktXb2gvWXdjRE1BbkhFUWk1MFJieWhk?=
 =?utf-8?B?alZxa1B1UTZ3NmFaYlVvZ3JqL3hIZDdjZU95QU9xSkJoa2tkUlJ1UFkrUlpK?=
 =?utf-8?Q?7bKm1bEAJTqGj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ti9aZU0rS3RqU1lYanBraGtQL3B2Y2hOSXZmdTVYdk5FVkFQd3VuVEdpTHd6?=
 =?utf-8?B?L25MU3RlUzFmY3B2SFFHYW1Fbnp2eUxrMVFCVE8zZ1dIdUdUUDRWekt4SjZl?=
 =?utf-8?B?cUx3eUpNdG16emgzRzRPWElnbWRTWTNtaVlSbHI2bXkwYmdzYW9CaTJyTXl2?=
 =?utf-8?B?OHdPWGQzaE1RVmJWY3hrT0krTFV3T3Y2OEk4Zm5ieGZWTGUrYm94TjVPUGZj?=
 =?utf-8?B?ZjhBbWMzdjFhVjRwbm0rZDE1bGt3YnhHdkpaRWltL2Q1ZFRQTU9MZWluNG9l?=
 =?utf-8?B?cDZPZ2UrTjJZK1ByYXhJRVh3N1MvUVlUOXdUc2gxQ0VwUG9YWXQweGRYa1dj?=
 =?utf-8?B?bEo5T2pHTjE5aGRDdTFma1htNzV4Y3FCM0puUG1oT3BTU1FpeVBrMis5eVZw?=
 =?utf-8?B?ODM5dk1yMC91SExLWnlVZzR5R0UrelluTFJycUFEbXkzbHlpTGlDL0liclgz?=
 =?utf-8?B?ZmNkSWk4dlpqSDVqY3BhMDhIQUFLQWpNRjZaMUZzV2pzRUVCRnJiM2VHVG5s?=
 =?utf-8?B?S01YL1NQK1A3NG9xMWl3TVJtQUl5YXJmV1pOMUpncHZFb0ZaMjFHYlMvcFhF?=
 =?utf-8?B?Vmo4OU85ZFBuQ3BtL01UNytibmdwMzlkbUhycGpiOHpWNWVvV3g3TnNKUHg1?=
 =?utf-8?B?eHdIMFZtSGRNTFplU0tVeTBpZjMwOThDcHFLMXdhRFNoa2p3V3hWcHRzajBK?=
 =?utf-8?B?NU5RN1d3UEdpOWtKM08yOEFCUjNOd3d2bUEyNE9JUHR3c3NJc0xUYi94Z25B?=
 =?utf-8?B?aURtckx0WExPY01xNzkzR1pQSE1sSTZJQVdDeUwyT1hzeEcrZlJKV1pHMWdO?=
 =?utf-8?B?dWVjSFUwcEZaSFg3a1V4QlRqeFFOWjBQVzBlOXJsOGs2bzloU3lMUjNpTHU5?=
 =?utf-8?B?SmswQ3VwTVhVMTVXZy9RZlFxRTZLaWRGV3ZBd2hDUkY1UW1haDhnc0RhSDhZ?=
 =?utf-8?B?Tmp6bmxPYXplcG9nT1NyVGw5VEpqT2kvUkpESDlpaUFDOUNQRnZNN09tZWtL?=
 =?utf-8?B?bW1oVzdpYU9tVU5BWHpsUkFZNXV1V0JEdGdmRHNTSmtKQ0N3aVhmUHBXQkhS?=
 =?utf-8?B?YVMzR1FlT3lkU09STW9mdDdqSHdnTHpNeENIdlpObTJEK2JYVWttRFliZE1l?=
 =?utf-8?B?RDZMVXJJT2UxTk5jVVpFbkV4ZklhMmRGZEZKcm05YURvOXdEbGdLMkpPTVA5?=
 =?utf-8?B?cHRIYytYaVZxT0NYY253YmFKUWxteHpiWWVBWlJPbUQvT0x3WXd1NnBhL01m?=
 =?utf-8?B?WUxEZUtGakthU2NXS0ZhWmZGTzM0aHVFMmNwdDZLTHFtcWlNZHJ4d0JiOExP?=
 =?utf-8?B?aTNES0gvRFJ1alZ2UDRwOWtMSUF5cTU2QXZSSGxDUTVCQXFOeURoTUFFUTRO?=
 =?utf-8?B?cCtRRjhxUkZmZ25hQ01lc1dvZkRPL1o0dUMrY1RSY21HVUowNFdjY1J3UDZD?=
 =?utf-8?B?bUxKZjFTa2JrWWxjUm9JSkRDeTFqQ2JnajRWR0gxR0p4MUhNY2tabG81ZFJQ?=
 =?utf-8?B?M2pNTVZNbGo1eFFDQTNzUjBkbWJlVkJzOU5PMmlYUHUrSFo0TGRURCtNNlNV?=
 =?utf-8?B?MmdGcksxS0kvOWpxZVJoSmNEYzBjU3pDSkU5TjMzNm03RTBLQlVPcjVnaERp?=
 =?utf-8?B?eUU4WGlKS2U1QU9mUGczTHh1c2Z5b3Jid0NlT1lrL29RK0ZuKzFQaS9ONi9l?=
 =?utf-8?B?NGZKYVFrMHVSMjdpV0l0NEhwL2N6MDVSdjEvbTJZQXJTN0RDcDVhZy9XczJY?=
 =?utf-8?B?cmxHUzhXTllLUnA0S2EzNGJzRTlKMDZSZytoWVlEZy91c3hGWTg4dnFKbDFM?=
 =?utf-8?B?S0cwclgxb3lpZEhybjlNSStDMVg4Z2c0VjFaTml3VXBock9uc0lCRThFRHNa?=
 =?utf-8?B?MnVGdG5XV0NaUjU0WUM3S2Y0YW9HM2JENFB1UyswMjFXbCtudGhLL053OHE1?=
 =?utf-8?B?YkhPTkJBd0N4Qk56U3hWeGdOWm5pZi9YRHRVWG5GcnpmWU1ZaGJ0OFhVUVd6?=
 =?utf-8?B?azNYdldCNjNyL1RaV05iajJQZUtIWlVQYWtLU1JtWHh1Qis1U3N6bHloMVpS?=
 =?utf-8?B?NVJFb2ZvUXBjeitrUmdPUzl6MFdndllXblV6dnRjZTJBWlVNUVZKY1V1SElK?=
 =?utf-8?B?Q3BSMWpobWdWdkZUMlpRL0FCZVlLNS9Cb25yVXZsUG9jOXhlYnZrQ3ZLSkly?=
 =?utf-8?B?Rmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZRZkU9Ok+vV5Y2nQrGPKJI3wicbNcdppSkBjww6FW+qTsXeLB/8yic3+6h4Ken1s8j0eepFcHTeYyHW4n2Ipaz6M3ZamsWK9FkZW09ClmdtsU10tXqQEdV70KSYPkmKLn18mO7TydEehPkovr6joqfJl+Cq6FBqijkpLQis+8t5qhKWXg/kVlwnPznenodJjosSQFtezb3dRH+KZiql6vxa8IEQtKzIZuxaxYr5+0o2lHhEZXzQfv5TGPiz8kVw37Wnvmz0IuKdrrwiE5uLTbvvnkKvVUulmO0Ob7dXZCx9zFhjJklqs9cKhaLauPY9Ld4m3JWKuwY8ougBhv3PuY6L2ojOt50J4sD10TX7uldiyCBVm9plBLiEgVVlBBZ6yCrWGldzN+Ptq38HCHHgRu+pI0lzzOLh9mXMB9ahk2TraDW/jZvHd3uewBHL56XUHgOozB1V+bAnpIwksa2QO44+DqdFrN1hmAjZQCCgYLBP70xdZ6DlL0WBFff97LwIeK7IEEsdaRG4QeR9r7q2mnENIurojFWDEGUSVOWC8zOmoTem8SozaZR0EJMHV1vZ9LqsgAvoDPfOMiWEx7cG16bZusZsRT/kPbIxAqKDZysg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4463342-6095-44d9-e74f-08dd5cd6f8f5
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 17:47:32.8021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D4sX4aVi5LfKr1Sp5hPeraVfpW/lAfDDJh+vvRcu2UZRoWImLzBmi4yRm6Pc58N65i8lXW2NHbiZj9qrBK03Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8000
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-06_06,2025-03-06_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=953 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503060135
X-Proofpoint-ORIG-GUID: UpDFPnLvqbP8oLj7MszJs346MQCsJ6qu
X-Proofpoint-GUID: UpDFPnLvqbP8oLj7MszJs346MQCsJ6qu

Hi Zhao,

On 3/6/25 8:50 AM, Zhao Liu wrote:
> Hi Dongli,
> 
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index b6d6167910..61a671028a 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -7115,6 +7115,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>>              !(env->hflags & HF_LMA_MASK)) {
>>              *edx &= ~CPUID_EXT2_SYSCALL;
>>          }
>> +
>> +        if (kvm_enabled() && IS_AMD_CPU(env) && !cpu->enable_pmu) {
> 
> No need to check "kvm_enabled() && IS_AMD_CPU(env)" because:
> 
>  * "pmu" is a general CPU property option which should cover all PMU
>    related features, and not kvm-specific/vendor-specific.
>  * this bit is reserved on Intel. So the following operation doesn't
>    affect Intel.
> 
> I think Xiaoyao's idea about checking in x86_cpu_expand_features() is
> good. And I believe it's worth having another cleanup series to revisit
> pmu dependencies. I can help you later to consolidate and move this
> check to x86_cpu_expand_features(), so this patch can focus on correctly
> defining the current dependency relationship.

That means I don't need to change anything except:

1. Remove "kvm_enabled() && IS_AMD_CPU(env)" since the bit is reserved by
Intel.

2. Add your Reviewed-by.

Thank you very much!

Dongli Zhang

> 
> With the above nit fixed,
> 
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> 
> 
> 


