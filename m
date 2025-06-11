Return-Path: <kvm+bounces-48975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ADD84AD4ECD
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 10:48:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5EFB189EFF1
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 08:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B99242930;
	Wed, 11 Jun 2025 08:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aC3jHqaE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UEm1bOnB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59656238D53
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 08:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749631612; cv=fail; b=Rp6Hwzs74zrECfxqwz+D+Tk+i64MAx3nk+APaDolX/HSBVeKrlVPX/pSHyb6Unael8OjCoPuXgPG6XZtJwCcwg7lloBQke0F9n87TNPXi+6BsXs1KhI9IjaXyRCRnX4E+2vXXWPf/X2WfIdI45scqn2gH8Rtmr2XswNjEczfpD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749631612; c=relaxed/simple;
	bh=5QfMLF1fBeslOUJet4uvSr5ccdfel1hQr+C78WeXMuk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OOX6qG/sR9rDBdf5uY2O6CtuRO4OBcRsQhYuSCo5e6zpTLL71K2iuKYfItZH3FS5gbxu2CUFdDnNIYtpIRIZxSNgVC7M8BDaobL9OnLZOLy1pAqXzpvqRwDNnvVIXOgi14YnLHn8XdUCAvVBjQmApc8FEBGDajh+hLFRggShCsw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aC3jHqaE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UEm1bOnB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55B1BwdR001340;
	Wed, 11 Jun 2025 08:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1/YzwtTMNRohtgOY8/HGOdvsPs3BOSU4u8OIIcRDQx8=; b=
	aC3jHqaEIzK2RwyF8B9CB7B/0qznLIhz+xFmTDv0VaZ/GZRTlcrg9P7qJVelqTKg
	qkUC+S568ac6+nLys8zL7VaJh6a7gpKUATRR078HZhUIvAySAg4BOa+e/nF9sZqS
	eWFZcAcUZWeT+tRL4xTvkVkp9YE8/y8HFI6eLi/VpsfJKBK9gc4CpCVWDbwyq7Nh
	e2TRcjioiNDppvbkRJwuv9U7J613Vih8yIqo5l3O8yuWK1LlGN0Ho3vq1ekKUYSm
	7N7XYqWxDKSS7dKBb+MvT/7qtf1ZcYuOcrc4H+vlNXBRCsEmY/eFFMpkJGEGEdJr
	YOqHUmyxtnuma5FRB+YULg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474c74wua4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 08:45:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55B7jAl8011872;
	Wed, 11 Jun 2025 08:45:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bvaukt3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 08:45:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YARUm//kp3qo5YRSFo5IyoX/txftBXj7CUyU/6spnPDP9pEBMtB+QyAT5uvcC2KzlcLOARqgpUb3SCoOrbwPI30zkHJTJmGa5zaJXO19ovQ5DZYHi7uP7K9PhFvpd3YnpdVnLJUpq8rh4HlH/iWWl+oSJWJMnEJuIIwxh2eXRklbNxDGgjhyb4nIfyZTBQBcxBadOAaOi4OU79GfLlBbVdq8odlaFsrgC6oWRymzFlMnX4fLHZCsZqMpFjssSFqnQyNhdQE4br4C6Ge3/VUN0ZZl2pQTYlxfbd2Xx+GNkWuoxEvHxulUuAWHnkGk2YTenVjdjHkzCz9Bh2CKVqRWcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1/YzwtTMNRohtgOY8/HGOdvsPs3BOSU4u8OIIcRDQx8=;
 b=WtQfl0oBplfKjobt1lWvQAO+8AN3zjoqFjKLa32TtHVNNpSBNxNcWqJJctI+u+LmrrdVWzH3c5zfT7JXfgE/L5dQeAr+rv5R0zFmuh1EtpjVDU5NJ4IX9ndDkBDFETg4rI+oo+c758320pys4Qtb8R0KwWQPcv/sKcY2d0fdyJqMy1YciEB4BRoLAtThhTAhh5fC5tLBD6xXquXINfmszCLACqEBmZs/WVh3A0x65OlkJDYZI/XqAGqKNdCatYH2qyp9tyXHoSon4sOzwKLxk3T2q9A12FX4pG562UuZqdXNUIezyUboAv7BBx2nH4rwZKrMJ3ZZvkkseDofbjPQ5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1/YzwtTMNRohtgOY8/HGOdvsPs3BOSU4u8OIIcRDQx8=;
 b=UEm1bOnB54NlyLrHFTjBhrPGjlZ3M/fU4EPg5KRzpMuWrHfODzfVHB81WxdZo6mNVTH6KzsXhIzs/eOqREZVZZVPvlg0npnZ7AGTQ6HsnJ8ILoEwU3J4hNLEgIS/mbAUv9p2Nyh1d/7g0mxSSpNjJJ9jUBRsH/8NynsuWPYCCC8=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 IA1PR10MB6685.namprd10.prod.outlook.com (2603:10b6:208:41b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.30; Wed, 11 Jun
 2025 08:45:35 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%4]) with mapi id 15.20.8835.018; Wed, 11 Jun 2025
 08:45:35 +0000
Message-ID: <3897e8f1-73d8-4fb7-a894-22c73902e634@oracle.com>
Date: Wed, 11 Jun 2025 01:45:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/10] target/i386/kvm/pmu: PMU Enhancement, Bugfix and
 Cleanup
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
        frankzhu@zhaoxin.com, silviazhao@zhaoxin.com, kraxel@redhat.com,
        berrange@redhat.com
References: <20250425213037.8137-1-dongli.zhang@oracle.com>
 <aEbS93r7YRcIadj0@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <aEbS93r7YRcIadj0@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0042.namprd03.prod.outlook.com
 (2603:10b6:610:b3::17) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|IA1PR10MB6685:EE_
X-MS-Office365-Filtering-Correlation-Id: f2cabc82-d19d-4039-07a4-08dda8c454d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?STZTSlY4eGhqQXZkdkZhVTh3MGMzWkVtellYeUNRMjByWkVFazhqdFNRUVZT?=
 =?utf-8?B?bnhFZW9CTi8xTUdkQWNtemVIcmZ3VjBmdk1kYnFvWWdsWlRxaW42R1pyWmE2?=
 =?utf-8?B?aTNuSVg3MDVLUEdJYUwyQ2M0ZkVRQ3JHdzBLS1VGeDIxcHlMZy9GMnNVc0xS?=
 =?utf-8?B?UlhwR2NNQlczZWFYWnRscmRpQVFndzJ4cUVvYXRGbTNSSGNGU3lOSWp0K3Fv?=
 =?utf-8?B?Tk11SGhaRFNOd1pxcmtYOWx3WmdJWjMzUmcra2VGL2I4T2VtN0hTOHpQZjhZ?=
 =?utf-8?B?a0hXZEZZcTBJTjVJVXRYOCtBbDR3M24vQVd5VDNEdGRPMENYdWpDMkk0VHFD?=
 =?utf-8?B?RVNpZ0JCU09qYkVUZkRoMFZNQW9UanB4cW5qY0JSV05VS1k5Um5FUVpzcjU4?=
 =?utf-8?B?N3NObFQ1b3J6ZXB5NUpYWjVlR3VOSkszQXRwemNqdzAvaWlicFhGUzZSNkN4?=
 =?utf-8?B?Ukx1V2xYR3k1N3FaS09qMUluZk5nVW5ieXF2aE1VT2gybzU1Mjl2TFhQcTlH?=
 =?utf-8?B?bU4ybmhpaVpqY1VVZkRYSHVlM2FnZUZKZVFnMmx1T25qcmZPRytVd2wxNEJm?=
 =?utf-8?B?eU9keFpSTDRZcFZsY3JRWG94Ky9RQUU5R1pGK0lSdFRJVnBNNExKMGhsSmly?=
 =?utf-8?B?RWpOOW1MQU1qc1BBeWZVemVYRmlsRTJ0MnpGUXczUllsZWNZQlJtZXVjQ2pt?=
 =?utf-8?B?b1JjVjh6cFp0dlpIcFJ3QTY5NjAraVp2OHRRL2dScWRyMUxVVlUrNGk0WEFP?=
 =?utf-8?B?a21sOEx5VHVIaWp5c01PZEpuN0FpUnlSb3Y1NjZvcVpqaUR1YTdOalc0bzFI?=
 =?utf-8?B?SEx6YnJqd2pqalJ4YmRPUkZtdUtYSUhCWExrS2srRnIrc2Q2RTlYVlNiUTVo?=
 =?utf-8?B?OFd0ZVZJTUdKRFdSWXNvdGlvdWJ3ZWI4ODdvb1lLWnRGUFBxSnRQMGhTS0Ro?=
 =?utf-8?B?amdKRWRwK2tkOGRFUUJSaWJnZnZJQ05TWnF0QVNlUmhkTEZoY1FBb3pDUlpD?=
 =?utf-8?B?SUhUeGx2Y3JVWDFOUXFrK2MvUUFaUmFiU0pGNmtXZXBMaElWQjR3cVlmdVBX?=
 =?utf-8?B?amJuc3doL0plVi9lL3FSa1BMU1l2Rk9uUnYvUFpSbHpYbHY0ai9TM1R1ellh?=
 =?utf-8?B?QXluNDA4eUllWGoweWlheTI1OTcrR0xnNzEvM01ka3JYMVNRN1NuOE5BaEFr?=
 =?utf-8?B?SEJEZWdmbTJSM2wvSW9KQWlOUkxLcnVIU2pWMDdLYzFtY2xXc3JLeWhFRk1H?=
 =?utf-8?B?ZDZNOFZEdWc4UHdham54ZTVLN2RiMGtTTlEyQ2lkTWoyTTN1d0NtTmdmN0VT?=
 =?utf-8?B?cFgxUmFSbHArSEs3aFpMS0ZXM0pZYkR6TzI5SkVXNWZSRHZYcWI4UndRQWdl?=
 =?utf-8?B?SkRVbi9ZUlVkVWVBa0QzcWQ2Qy81Ny83QldPQ0srcEdrRVlmeEc2OGppa0VZ?=
 =?utf-8?B?dnNOdTlmaGdDVUV0N0V6RnA0dDFUK3hwTi8yZkw3ckJlQmx6U2phc0FSRGZT?=
 =?utf-8?B?ZFd3NjhHek5yNjlaZTNQTnR3QVU4bU1QWGJFUlhVYVU2Y2VTL1ZnY2hPazZ0?=
 =?utf-8?B?YU9NY2VUNGE2ZmgrdGFnclFsNHI5RUpreU1oTVVhTU9lMkN1TU1OSGEvcjhG?=
 =?utf-8?B?QlZvNmw1bG8xSDdDeVZTSmJtemY4b1lPZHNsWnBLRzdtL3RmNFBkQmFycTRF?=
 =?utf-8?B?U0txMjNxVlBHMFZ0VCs4S1pwM0hEWmJCS05JSmVzbmhodVBVSFQ4WEZhM2hI?=
 =?utf-8?B?WlFPTFZKb1ZTZGtTY3MzcUNNbzZPVDhFdVRjY0d5WUtUaG9teit2Yk5uL0kr?=
 =?utf-8?B?OWlCQ2pFRkVwbHVqQTlFZE00OEV3blEraDIxcWtRTkFkSi9mQjlVYXY0aStZ?=
 =?utf-8?B?Wkk0Rm5hbDNNQ0x4dEJ6Y3o0RUt0OG1ySTZXS1BmUDIyMjlOZFhpUGk1ZU9z?=
 =?utf-8?Q?fi73i6ladWs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N2pVSDVjUEhDNENLNC9IekY3MXNXbUpiR096NC9Wc1dEaWl6YmhFWlpQdzFN?=
 =?utf-8?B?QktsZWExS3NlZUpsa2JqeGtFYmdJTlVPYmtCQWYxRk5HSi9nR202S2EwR2pT?=
 =?utf-8?B?cHRWVUhXL3E4MW1zMExqUDNORzh4cmFtKzdFZ2F3aTBsMktod1ZVYkYwQXJX?=
 =?utf-8?B?WjQ4b0pBd0tkMU5sUFJzOXNheHJnVmQwT3ZYMEpNaWV4MWxldTlKMkh6T1I3?=
 =?utf-8?B?SW56N3lIZHFDZEJ6WExnU2RoUm9tRHNYd0x4WndIc2xKckZVQjM0WWFsN1lX?=
 =?utf-8?B?NXNZdHcvSEV0aHgyUjBZM05teU02U3lkK2Y5Y0RQRmIySTZBMWk2OWhwbEV3?=
 =?utf-8?B?b1NYQ0cxdHdrNGFGQU0yRTRmNHk1QlFUTGx6bjlJSVJGZ1d2My9tK2FHRk9x?=
 =?utf-8?B?cHZKWWliVHp1QVFXSnFLQTJiVjNHblhzQldJQVRQa1JqN05QSnZpdlQxamxa?=
 =?utf-8?B?OENuZnNTU2VweXBQemdVWHMwU1lTT2xaclZpVi93RG9wR05jZFptM0ZqTmJU?=
 =?utf-8?B?RzlqeWRlbjg3bzd2eTM2UkN1VkxtYjRhclhCM0h4cTN0cUdqR05xSWNMeHVE?=
 =?utf-8?B?MlM5d3VWanVHN3A4UlcrYzZ3SmpxYWl4Sm04dHVTQmJ1c3NoV1VkMHJKeWE1?=
 =?utf-8?B?UVhVV2cxMi85ZHhqdkJUNnVyR3R6N2s2MkhMU3RLdEVJcm5QUUh2Z1VtZ2Nt?=
 =?utf-8?B?RjhybW9QcTZLNWJ0OGVGR29aQWRwN1c0eHR4VDJYZTBJNStsRkg0RjBvTDFT?=
 =?utf-8?B?TE96OFRod1FVRDJnUGtidUVxekpsTGZESkhHVHlMb3RUTW9nVnhNTmhPSmIz?=
 =?utf-8?B?aWxjbTN3TlBOZ3VXSnllbXkzdENkWWlUbGdKazJlMS8xc3FXQ2tINEwzZXFi?=
 =?utf-8?B?bHBrSVFDaVp3UDE5aStWeGtmbjJlS3E4ZS84clcrMk52ejQ5UmMzcXNSK29K?=
 =?utf-8?B?NVBIWGl5SkV5RU9weTNPaEFEcjhuR0d2VWtsaElxSmpkUWtvWm85ZkVLYVJt?=
 =?utf-8?B?bUJDWnVkV0Z4eEwwNWRsK3ROOWdXK2cxMEc0cFQyL1dFTzhwZW1pRUtjaS9Z?=
 =?utf-8?B?MW44TDJxMWMxdDAwdEVsYTFUZ3FmbkhXRURyZGx2NDBUb1d5Vjg5ZnNFb044?=
 =?utf-8?B?d09NQXJzajFkSUxOcFhCcHpQcnN2bVNDYit4cWpDWlpoMU4zWGhjWkREaXl5?=
 =?utf-8?B?cFRTUXcxdk1XMGJSOXZTakg0MHRicDNpNTFMeUtiT2o3bm5HN2RkWlNFT1Yw?=
 =?utf-8?B?MXRNYUhaeC85NGNKMzdoMFpBTGV2NUd1bTJxR1RFY3U1N0hkOWx5RTJQTEYy?=
 =?utf-8?B?ZFR0MFg5ajA4Wmd1VVhsdTU5M0hHQitNVzQva3BuSC9jSElFVXlDTHAyRnRi?=
 =?utf-8?B?clJwQ3JKN0sweHFnM1kvNm5WRkNPZDVFRTU0SVlCdDRmQ2pVdndGaDdrSkJk?=
 =?utf-8?B?NGFJVlNLWmcxcG45WkxkZ282WnFrVGFOYkk3MGRKSHIrSGkybWM0Sll0aElx?=
 =?utf-8?B?V3JHam1Bd3BJcUM1cU9lNGI4ditJVE45a2lhRzJlS1hkaE5HNEVQVnFJNmNs?=
 =?utf-8?B?TG1mbm0yalcwRTZZMmlud1pvcUJGbzlqUCtYUFBqM0VGamszWFZUY3UweStO?=
 =?utf-8?B?L01VZUE1R2h6b0Q5a2tmQXVUbS8zaHV3WHIrQ0h6bzJuQW5PZzdoN2t2MDhv?=
 =?utf-8?B?aFNkTllwT2JDREZySlY4clAxN00vOFZ1cm9nZTc4R0ZzWk41NVdsak5YUlBk?=
 =?utf-8?B?Q29ZRXhDaURqSlFoRUJyYW1oejBLNXVlcWtTRXM2d3pKWko1SWNvdFVyRGh5?=
 =?utf-8?B?WUtEejUwTlQxSVVybzgvcHJ5eDRrTzMyb0NDd29NNm9kY3lqVTRreHRFcXVI?=
 =?utf-8?B?aHEwZHhFam1lM2FhMXVFRlZjeXp2QU00RFdGY0RFNWxFZmZETHJ4RGhpU3Vz?=
 =?utf-8?B?VXNrRmZYdEVUcVBIY25EYnhSV3RCZ2RpN2sveFFMK3FhTGluSlFFTmVrZ3d3?=
 =?utf-8?B?Rjc0dW5nVkpZWTJSMVB0NTd4dmZGK0orZ1Y1ZE5oNm9GNHR3dzJjZHA3UkYy?=
 =?utf-8?B?UnZXRERzZS9LWVVlN1poRXNOTWR5dk4wZmRjRXZoM3Y1OFBLakx2T0pWcEI3?=
 =?utf-8?B?ZWJLYzhMakQwTlFwYjcxa3FhZ3owenZIcSswV0UrR3lLN3pRNVAwS2twNk1U?=
 =?utf-8?B?eVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZM8S0s/uY3lepQqwy/xYSlhNPHnKe7Bkh3gvehYP9isjEHE/XszNzH64EYslkoQxwmigjPNXjngz/21+KrhUHTHXu53Ep5fEKFJ6cxiF+DN7NuaA29On+6eDWo96LM51Q20V0zIIZ61oOWfjQHeW3pbXYrfF64/KanjBcbZGvsj3R1fE3fzdMUUTVSY6NDCqrUUfQAqCPfvMYAFQciNLokL92XIJj8U5m9i2ofWpDoCcaKt9b05jJdbVdELcYLE0B2P1xcpCxr4fLL7Y1sMIMgXMJt4c17wG3laTdeuZix1UAlNW7KIOwPp342ugxQOc1kKTOuqn3SVUstOYs/FJztq/d5BG9R71z1SLebCYTZrKVlHLMnXrfRtfqBdp18c45HE7KDI/4/RojJzTUnIYKWqwM12H8JIib34l+mfZuggnFZaaSoIFgJe75GIh2S0OHJ512vImnbqFaDBjc9bkupIy+RiYbmd/IUXmIPo/WixJzM9wKQM1vRWnWiigrD2IvZeWwuAkZtHnVudokeqyCJszGPC/AWgRAMhMvZwtXpMk7jiYHWHKs+Yy6kSPuNSUw3IfubE8d7tYr9n4PI1EodJiECul5yH6doNlDK78KuQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2cabc82-d19d-4039-07a4-08dda8c454d8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 08:45:34.9109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2RiZ8z8ACgXUfpgCWvYvg+NMSdHpJ75nbbLMRgiH2Hsn1hVTuUalbivvkG0giSAp8qn+TkYW2k/N82rrMBvaVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6685
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-11_03,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 mlxlogscore=920 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506110076
X-Authority-Analysis: v=2.4 cv=LIpmQIW9 c=1 sm=1 tr=0 ts=68494233 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=8v4FunDBqJgXfeyFKsAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 7LXdAY3mZyDHRKGdJZMOSR_pF0RmZ_Dv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjExMDA3NiBTYWx0ZWRfXzjt4p4rdEXvD dj47srJcSCuvuTTiS6X1Ras6ruqBb8LI1OmiXhfVDJ0VgosbahrGBfKDOSl4s6PF6AWv6xkCCsr 2MqK8Hp16DuIS8RcFWQOyagE+9nmrnUL1G7XtPPQFhI0ibypk3z7R0Gu/NZMNcMT4MzMdUgRt5x
 U3GZ7dyY2sm9VmEC5f3El5dYpD09zGfOXUnYDGJ8eYaOS6wNw7SUDTv/LABoaSiXnFvHNpDpUNe TkXJCCky9CXuu5Cnf7y82MY3lKsmTHfJU9FoNTRUQ8DipwcH2mxfc7ZBzQKIOQEisoAu4bZSb6H GXhxgsx23hY3upa5EQRWBjb2tsBwJ6xF8fCa1g3h5eI4YDNGdT3u5mBid35Hveap+q7XgagNF+a
 O/xD+DzeI+qgrDHtZDOA2og1h8F6NVIUgy8AKqKlYuf0l7sCiVwp67MNYdBh+hjMm/a3rs/i
X-Proofpoint-GUID: 7LXdAY3mZyDHRKGdJZMOSR_pF0RmZ_Dv

Hi Zhao,

On 6/9/25 5:26 AM, Zhao Liu wrote:
> Hi Dongli,
> 
> Since the patch 3 was merged. I think you can rebase this series.
> 

I will rebase the series.

Thank you very much!

Dongli Zhang

