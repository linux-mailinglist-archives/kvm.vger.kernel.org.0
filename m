Return-Path: <kvm+bounces-40466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9096EA57521
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 23:48:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC47E1706D5
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E2C256C80;
	Fri,  7 Mar 2025 22:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RDhcMl9B";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="umIwlT/B"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF1018BC36
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 22:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387715; cv=fail; b=faAdf4g34fOPq0rEV0JnXQRie2AR++HAHirUzHtg54cfuL2JEAPlsgYUIBt2SV7yOe0eJ5cBMZ4gjMqg8WQTQmhZb9f9QynRfyuZKbEEwLZmMZkumEADqg1BQW0vkUH4z4NyS4u26oJfdmSFPukmXf/Wu/w/+kr2lzWXypRirnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387715; c=relaxed/simple;
	bh=upsWzFBOzmMlRRcFVHRKHAC0YJ81Rp9R+qqqHGDmw1w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZsnrCtgXEA44bPeb6ivI8wJuNVK15YJwy8yzhKVi95JHH/cLQ+MOW7DodICVrgskSgk8l7nyTWXbtg/ILUk64drrkXaSa1LNGWRU/3kQ2ISlyoGJwU2DB6tWBujDwQs+uCgvF8bv6lonqfZLER/rUWntnTlBZaBYYG3qUgajfH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RDhcMl9B; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=umIwlT/B; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 527LJI83012281;
	Fri, 7 Mar 2025 22:47:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=DdSNich6hsqBbqHV+g14G3nLCBrE/IDsP2qnk5cgTmE=; b=
	RDhcMl9BGSSC6TCov6Oyv/K1J7zo7QMOobJe5/VJwSVZ7rsVvG6xqs1x0jJ4zmMo
	Pmsn4fR6tctf2bCzcc+A6XJA4UbdtJCWxpmmv/dW+CSAkCR+c5KrvC0bp90uplhg
	0KBU5Q/xMz/Fmjbt5aIQD0pkN/krS2wTkljJWo8CwOIXhxLbJnufCsGP96iXq+uQ
	gC4iPv+tW9tpNgUnhxnLr6MdQwHMpigymFbQXETPcGdWc1Ea2GSU2Hu0w/GQRAYf
	O92LF4TfEY6jY607vP8/0xWupKbXg3pTc3aXE3L4Uqfk0UD9MIFXL2gCE+p4qWhV
	KHXWs5SkGfPUk/S286QCXA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u8ww0mm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Mar 2025 22:47:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 527MOS0u003230;
	Fri, 7 Mar 2025 22:47:58 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rpe483g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Mar 2025 22:47:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KTVJOibS4Y29VxwNUbCKK8fliyKksPYXn2sw8toJ0WJ2cqEPcF3fYdsSFY2luVcl4ZsSuZS/2c66KXzlfFnTu5M67dtNIaIYHiqCmd7o1uEkorEjbMSx4Dbn6i5SYTj80eBYNqPpbPHO4CLJ60vSW9v06JMRVOM0EBjBL8Cwyqp3m9eJJd1lvMbfSUTaBtrQnAKh3L/J9pVNjqgjk/xzBPelV0ZNI87bcIxd1nV53ENBcJJAwWy+V6rF0TONEOU7zMJ1NszDMU6fRA0kOFrWYeJZqdYAMjoaxni22dWnEKKnVLBD0fVhOUnhmt+FD3gA5EfJ4iqIN2pY7+qv+Pijww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DdSNich6hsqBbqHV+g14G3nLCBrE/IDsP2qnk5cgTmE=;
 b=mllKq7aoSkUBocxCWZHT/Q2f8c+LoU7x9HPLvKBE1YtaDQHvNAhAnL0dENYXyLpyn2sH8MvrH4cSNAl/GKqJ/pHFBgTHf02/YAMYRzWTMWfITev9bJ1Pn42aXDEeT5dOTMphgXCOAqDXcZOQtDtSmLDxudXbK35n+rQWe56K1hes27kGcL7a12ARDYfFkiZVrIrFyCgmYcwoE1WLbHZSjm9briOtOdCYEBmmLzNaV/6GVWb0ddqNmBtHmvDFpOXSYHUHo4/ImS0yawHJGTEkUo1AhkniiveauxrV2WE3/NRn0tN91PtvFaLxR8IlaZoimzjRE1EJzHkQkB5Ignk75Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DdSNich6hsqBbqHV+g14G3nLCBrE/IDsP2qnk5cgTmE=;
 b=umIwlT/BdKvGEXnXRMDfK5T97P8jLCUO449psUez4Sqm++bOGxKImcxqO29hsXQHc/uAjpqSVIbgfjzpbepnxOKupzCQL1Lb2F1M/XBeB85DrdumF+yRUZltB6358nya49re0BInFcGXNElfDnM5rHyHcjFTW6NvlN7kgr2Pqr0=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by SA1PR10MB6663.namprd10.prod.outlook.com
 (2603:10b6:806:2ba::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.22; Fri, 7 Mar
 2025 22:47:55 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8511.017; Fri, 7 Mar 2025
 22:47:55 +0000
Message-ID: <23cca084-2081-408d-a360-22fad0ff5037@oracle.com>
Date: Fri, 7 Mar 2025 14:47:46 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/10] target/i386/kvm: extract unrelated code out of
 kvm_x86_build_cpuid()
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
        likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
        groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-6-dongli.zhang@oracle.com> <Z8q5NHQeIgXxTmPO@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <Z8q5NHQeIgXxTmPO@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0092.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::7) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|SA1PR10MB6663:EE_
X-MS-Office365-Filtering-Correlation-Id: 6903ae77-ca1a-40c8-78bd-08dd5dca1983
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y01wcW9vaWVWNUpTYmUydEFURjR1TzBrRzBwTVlsa0lJckR1UERuOFREZS91?=
 =?utf-8?B?dC81cVVmUHc3UEtUNHRSaDM4bmdxcTZNRCtqRUJqSEJYMHZ4MldxVDNHaE82?=
 =?utf-8?B?a2s1VXVwdVgrd0VZZXM5MlIxakZVUGNBdU1BaCtnd05MSmltMWkwVVY1UDdZ?=
 =?utf-8?B?SWxhLzF5dXRQQ0drUTczS01uT1NGTWN2MUZ4OVF3cHdROERZbUR5M0NVM2Jh?=
 =?utf-8?B?alBrNmw3TjlETTlXZ21GSElBM3FvQ05KNGxPRVRMcUVUSGVRd2dmenF3UmdX?=
 =?utf-8?B?bnUzcENHNVIzSm1rZjNmUUEwWERZOEpCUzVlM3lTWk82SU0xWEV6QlA4VjlL?=
 =?utf-8?B?c295blJlc2FGdGRSakZZKzA3cCsvNVNnblk3Y1RMRzh5NWJNd0xzRzJUMmZt?=
 =?utf-8?B?TTVkb0I2aHhtSG53cU5uMHMzTGpPVTRXU0NKaC94aVdBNXlJaFV4Ui9CdXNz?=
 =?utf-8?B?LzRoejc2dS9lSnp4LzgrMjdEU09FNHZWaWtpR0ZZdEx4Z1FQa01TaXJ4WHd2?=
 =?utf-8?B?K1FGSGp2TWJSQm1kZWpFRlF2dnUrcklSbEhiUFNDelRLTUQ3aXRma3JyYVdH?=
 =?utf-8?B?Q2xHdnVITGhGa05zSTB3Q1hUZEEwYnJDWGxIZ0ZUaXNPNTVSWmRMRlk4Mzlo?=
 =?utf-8?B?UGxFREUwbEVuUTRoVi8zeEdwaVBOV1pVdHk3bzJRY3RMWEVFK3luRkxhRGhM?=
 =?utf-8?B?RERxOWxmQmNsa2d1d3IvQmxOZG5OWDlsTjZpRUJaUjNLQ2xURGJNSmxjL1lH?=
 =?utf-8?B?UExYQjFENGV6bVd4RDlwRHNKeWFzMTFlSnNML2JocWVEMWRiTnNRSWQyaURq?=
 =?utf-8?B?dnd5SUNVREhaUXhrL3lNdWVLOWRBdklPK3VKT0VLOUFOR0UvSHp2Q2Z5ZlNx?=
 =?utf-8?B?S0JuSWVWaUVyTStRVVJvc0ltR1ZkR3pkQW11YjFKb2FKS3B1TVZ5VmZBamts?=
 =?utf-8?B?WFZzeTlTMkNqWVhqOXRnMlQvQnBGMng0R0F6VzhYb1E4OWR1aXR0T05KU0lV?=
 =?utf-8?B?UjV2ZnhuSkkrWW1NRTl0eitDdFg2Sm8xcWhHRjV1OWlYNnNOcUJNZE1VNnc0?=
 =?utf-8?B?MW1wM2xhWWdqL2ZtWHJlUkxHVWdLUEFKcUNicW5BZE9mSFRTeVZrT1JlSHVY?=
 =?utf-8?B?MnJlcDJjUjB1REtWWkF2cFFDZmxzY1FpaGR0aFdkNS9XdW1rTmhHa1pDN1pi?=
 =?utf-8?B?Y0IzYkFmSXhlZ3ZNUEFPa2cxVVZOYXYyM3RBaEsvVkNUYTI1Vkp0U09MaXlt?=
 =?utf-8?B?b3J5OGw5eGRHWVVycTY5N2ZkcjVITVJEQVFDVWNJMDZRYWlodndwY05sWG5D?=
 =?utf-8?B?ekhZNi9jazM1czlGWXNnQjdWTEY3SjUrYmpRbXMvWGgyUVJIVDlUNU05T0dL?=
 =?utf-8?B?clF4am1TUHdjeUpiZHZLVVNhVmNkODZLZkZ1d1VpS2s0eEx2S0hKS3o3U1Zh?=
 =?utf-8?B?VXpqLzdBdkJEUjNKMmM2YXp1NHNUM2ZwUkhaWmNYVEwzcVRYZlZFVkhIOVVj?=
 =?utf-8?B?TFp3a0c3VUxVYlZ2YlJhT0U0bUh4NDMwd2lkUVVkOENqMk1VUEQzcFZNUjUz?=
 =?utf-8?B?MnhzWXBHNERwOTR2bi9vR1Z0blo3NFVkamk3RUNXRjhjdGQ5K1V6K1AxejZU?=
 =?utf-8?B?a3BTV2VsZGZETTdvUEFNZnhKTzZPY0NuSGp3M0pzZDNMS2VxT1l5NmlqOEQw?=
 =?utf-8?B?NWp4d3NNYWJ3Q1RDc2NtRmNjcWlYOUtQYzJ1WGZhL0g0SmJTVitlVlg5N0Yx?=
 =?utf-8?B?ZEVWU05TMklDaE9VQjU0OWFoZTVYSEszUFM1cUgwR1RPZlNRWGt4cGVzNTJx?=
 =?utf-8?B?TGh5dUNSZnNZa3E0cjNaUmw5WUlnZHVZancyc2JxWXdSbUlLMU5Ic1A0cEpN?=
 =?utf-8?Q?N5Q+Z14hJD/l8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K0VJZkVCanljajhUN3dqUFh6aFhxbml1NzNpQjgzR0xuNHdhNERxTEJ0R05r?=
 =?utf-8?B?Sy80SGpBNmxucXFudFI3Z3QwUkRpU3YrdXFjNDhrVHJETzc0TllqZm1TdVVB?=
 =?utf-8?B?cVQ3UVI4aW5XNTQ0TmxvNGlxd1VhS1NvSSt3SnFaaEd1bGlHbk8wbzh3aCtM?=
 =?utf-8?B?eFprQWF6aU5ZZ1BmNFEyeVpnbTVua09UN1dvb3dJQ0JvQ00remtUdzhNY2ll?=
 =?utf-8?B?V0p3Q1BmNncrSUtRZllialVTOXJBN01ON0hVMjd6czhMR0VLc3Z0VmVMQk9I?=
 =?utf-8?B?MFZTYmNscUJ0Q2xGb3hKS3JTcGxCNGpJcDVxVDVCNWtEQWN2bHZ6cTJyY0Jz?=
 =?utf-8?B?NFhlVUlCNjMxMzBJVVhHL1JBN2ZYenExN0pLWjBEZXkzODlHbDVnUUJnZWxr?=
 =?utf-8?B?STRVeVNUWEkyUHVpYnBRam1tWE4xTmdVVldZRnZ1dlRWWTJ5cEluR0x6dFFS?=
 =?utf-8?B?aTBJYlNiR3U3VGpwYWMxM0dzTnVjaG51Q3R5RjNTVTYwaG5wV1hXeVJ4SjZm?=
 =?utf-8?B?b0IrVzRYc1N0WWo1RktObWtlTEFuYjNWcjVFV0djMEc1R1FrdEdvWHJxaUhN?=
 =?utf-8?B?WGI3K1FBVDY1WFhneDVhZW54Nm9wMFZxaHJMNE44YjM2ZVZsbTh2YlFKaXAy?=
 =?utf-8?B?bDI0ejFmUnNCcFhwZWNBYk5jQS9hVHEzMm10RXJuU2dKbW5JOFlKTTR6UFV2?=
 =?utf-8?B?YlRSNHdsYlVZUUVQcTV5cVJUczFwZlZLRFpIcm9KdFVPMDEvaE9pT0FWOUVw?=
 =?utf-8?B?TFdXc3ZvREcveHhKekZ1TWEyV3BZb1kyLzR5YmNMUDQ0b2NyanYzVkxhUDA4?=
 =?utf-8?B?UFBrRkVHelpKVUEyUWRZNXp5RWV4WmszQWc1WnU1TjJlSXJ0SFdYczg4dzUv?=
 =?utf-8?B?ZVNURlZkUDZIaFBYQWdTQmVpZFZUaXp4OVJtNnlpWHlwTWUxMEtiMG9XRHMr?=
 =?utf-8?B?YmRnazhPUEpycG9aUUFkYzZ4eWdDT0V2T284MkxvTFU4ck5hQnJXZjJpamVo?=
 =?utf-8?B?ZjdaeGNHTnRaV2phSC9VMm5ZSUxpb3dFNExUZ0pGWWI1Nk8xWlVYa2RoaEYw?=
 =?utf-8?B?OVprY0pTV2JPSGwxb3RuQ3dQczkwY3NGUHQwbE1jN0JTNUtYcENvRld2Y2Fj?=
 =?utf-8?B?aVc0a3BERE9HK1JYWnhNRjhCVkc4cGw3TjNNalNWUS9SK2tUOW1oeEpnbXJE?=
 =?utf-8?B?OGpQNEVHLzZtbUhBZEZHU2tVRXdLSzIxdWpnbUdiZG1CdWRMTXp2REY3aDEx?=
 =?utf-8?B?M2ltUDBxMjFhRlhwUjAwZzV4aWtYV2pMdFBRU2g5a2Y0NXhxaGQySzI2c2lT?=
 =?utf-8?B?c1VuNjRoeGZaSmlBNzl4UVJpMWVpcU82OUVXeU9ZZFBiS0tCOHJmODZocHBO?=
 =?utf-8?B?bE1uaFF3aDJEQTZ4ZzF6NGVhSXpqcGxiWnMxRWJ0SGlydDl5T3h3WmF2TnVv?=
 =?utf-8?B?WkhLejVXNkc1N2tkR1NJaFpEOU5VY3RQazhCcHN3empPU3d1OS8wSERKeDd4?=
 =?utf-8?B?ZHFuUVRJaXk0VUhuRjcyUTcyeVZoRXorUSt3dVJrRWZqVlNJblgvMFFmVlBw?=
 =?utf-8?B?S2VzQXB1MW5RNjJ4dWVGYVA2TVZVZSthQ2FXZUdjSitzZGlVNXJ3WnlGWG1v?=
 =?utf-8?B?MTkvYXVYbC9oQWliKzMxNVFja2ZTMzJtL3p0SEFwb3ZXaHRzSVJpNWs4eFN5?=
 =?utf-8?B?L2NQN2lFSjB1L1VRRDhEREZXL3RGVlg2TnFKWnQrVVBPT0NGVGZiM3hEcmtN?=
 =?utf-8?B?bnQwQ0NwWHRrUDZGVFNPRUNLeE04amt3ZGd6ZGtadFpzczZVSlFqWFczWFNB?=
 =?utf-8?B?TVd2OUFPRi9kRTlETTVqcGVPaTIrTWNQN09ISklxd0U0VEZNZnJHZDhXbFl3?=
 =?utf-8?B?WHY5akQwZVhSM3BMTDc3THNuWnphV3QweGNxcUZSZjRtOFZZZWJrK05KRUNX?=
 =?utf-8?B?c2JOaWFvUEtVUkJJQVRjNWxja09HVFltZi9TdmRybVo1c0x6ajJVeURCaFds?=
 =?utf-8?B?VjBNWnQrdlB6ME5HbnVXRzJSL3JmWjh1Ym1qakt0c3dPU2pTVGxzdHRReUpP?=
 =?utf-8?B?RW5yMUZ1c1RrOTdITG1TM1o3SHRtRE1nWDRSWDNybndwVGRVRXdIdW9ZeW0x?=
 =?utf-8?B?bmp4NSsrQ05Dd3Urck43ZitJU2pBdENRV216dHJ6aEtGWUJwWnozMXVKcDdX?=
 =?utf-8?B?V3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3W33AxGY/J5rjwbXjNA87CeYUDSgvmQgMKLTx2DHuDKIlN4YnUFtpVjwCp1SzZtZWqfT2dAK7tEl2kHhqOIFZgunDjkc7/FELVC3+ywHgJRs4wJvYv8f9YDKTu6xoTPEEYDnCiBJL9BbbstvH3YWQXyatZm9qs6id8bsLldOJ+ChvuFt+shyXrKdTDl7OoFNE66+p7bbE/WB7OCmMnc7b+shZLoX8CHWIxAjyvMJyR16RryJ8vNwQy/HVmihtJV5a+WTwc4IfTxA7ForKaTsXq4Nzn/NXY0WMwPw3RSciMhyJxZkw7WJwAtBx9eP/w5p3fqekXxvv6+f/wyYih/EPJ9NM4YY7K4Ad5PjgiSWujNEqUP9s5XMqts1ML57pP66hJd9QJ3AfATkfA52E//wdsZlMkAbMn1QFzPoYuNxSdxPa4LMgp6UJZ/Pyd6DgwrI1krtLsdSGHpdex++3r5ry6BsUIwpvvGY9DO7GzcXkwiI/sC8O3+/xDzNGzl6nPc2vFIM8+qjWJRZxu8vB/yMsOaL2vdV+2rGBFG8Syx5aMtJKFsv8dDUTj/l9yL7OXid3kMwHfTvyqLEpSyHMPG60B6EyczW0fx6lVeWKHbB/Q8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6903ae77-ca1a-40c8-78bd-08dd5dca1983
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 22:47:55.2859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: syH+F/+Bpsjrlyj1Kk+EOwVaHAw7xO/bHScTyyZ46D0SndoeewFG1czZQNS8bFsav9RKzbrefmKSbGVyKDJciQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6663
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-07_08,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503070172
X-Proofpoint-ORIG-GUID: 7S7rJmOHiiBpD9FC0qNfmsaOQX9VXBDt
X-Proofpoint-GUID: 7S7rJmOHiiBpD9FC0qNfmsaOQX9VXBDt

Hi Zhao,

On 3/7/25 1:15 AM, Zhao Liu wrote:
>> +static void kvm_init_pmu_info(CPUX86State *env)
>> +{
>> +    uint32_t eax, edx;
>> +    uint32_t unused;
>> +    uint32_t limit;
>> +
>> +    cpu_x86_cpuid(env, 0, 0, &limit, &unused, &unused, &unused);
> 
> At this stage, CPUID has already been filled and we should not use
> cpu_x86_cpuid() to get the "raw" CPUID info.
> 
> Instead, after kvm_x86_build_cpuid(), the cpuid_find_entry() helper
> should be preferred.
> 
> With cpuid_find_entry(), we don't even need to check the limit again.
> 
>> +
>> +    if (limit < 0x0a) {
>> +        return;
>> +    }
> 
> ...
> 
>>  int kvm_arch_init_vcpu(CPUState *cs)
>>  {
>>      struct {
>> @@ -2267,6 +2277,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>      cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
>>      cpuid_data.cpuid.nent = cpuid_i;
>>  
>> +    kvm_init_pmu_info(env);
>> +
> 
> Referring what has_msr_feature_control did, what about the following
> change?
> 
>  int kvm_arch_init_vcpu(CPUState *cs)
>  {
>      struct {
> @@ -2277,8 +2240,6 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
>      cpuid_data.cpuid.nent = cpuid_i;
> 
> -    kvm_init_pmu_info(env);
> -
>      if (((env->cpuid_version >> 8)&0xF) >= 6
>          && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
>             (CPUID_MCE | CPUID_MCA)) {
> @@ -2329,6 +2290,31 @@ int kvm_arch_init_vcpu(CPUState *cs)
>          has_msr_feature_control = true;
>      }
> 
> +    c = cpuid_find_entry(&cpuid_data.cpuid, 0xa, 0);
> +    if (c) {
> +        has_architectural_pmu_version = c->eax & 0xff;
> +        if (has_architectural_pmu_version > 0) {
> +            num_architectural_pmu_gp_counters = (c->eax & 0xff00) >> 8;
> +
> +            /*
> +             * Shouldn't be more than 32, since that's the number of bits
> +             * available in EBX to tell us _which_ counters are available.
> +             * Play it safe.
> +             */
> +            if (num_architectural_pmu_gp_counters > MAX_GP_COUNTERS) {

BTW, I may need this bound checking for the PerfMonV2 patch, where the
number of counters is determined by cpuid(0x80000022).

> +                num_architectural_pmu_gp_counters = MAX_GP_COUNTERS;
> +            }
> +
> +            if (has_architectural_pmu_version > 1) {
> +                num_architectural_pmu_fixed_counters = c->edx & 0x1f;
> +
> +                if (num_architectural_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
> +                    num_architectural_pmu_fixed_counters = MAX_FIXED_COUNTERS;
> +                }
> +            }
> +        }
> +    }
> +
>      if (env->mcg_cap & MCG_LMCE_P) {
>          has_msr_mcg_ext_ctl = has_msr_feature_control = true;
>      }
> ---
> 
> The above codes check 0xa after 0x1 and 0x7, and uses the local variable
> `c`, so that it doesn't need to wrap another new function.
> 

How about we still wrap in another new function with &cpuid_data.cpuid as
an argument?

1. In current patch, we need cpuid(0xa) to query Intel PMU info.

2. In PATCH 08/10 (AMD), we need cpuid(0x80000001) to determine PERFCORE.

https://lore.kernel.org/all/20250302220112.17653-9-dongli.zhang@oracle.com/

(Otherwise, we may use ((env->features[FEAT_8000_0001_ECX] &
CPUID_EXT3_PERFCORE), but I prefer something consistent)


3. In PATCH 09/10 (AMD PerfMonV2), we need cpuid(0x80000022) to query the
PerfMonV2 support, and the number of PMU counters.

https://lore.kernel.org/all/20250302220112.17653-10-dongli.zhang@oracle.com/

Thank you very much!

Dongli Zhang


