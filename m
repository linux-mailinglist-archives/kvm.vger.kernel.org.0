Return-Path: <kvm+bounces-43400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA46AA8B29F
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 09:50:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2A0F16D5FC
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 07:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15CF122DFB3;
	Wed, 16 Apr 2025 07:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cA1sEXkT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xBtd4XUg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585F8189B9D
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 07:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744789804; cv=fail; b=rtcxcMHWkZ3UW/7dI9OU2wD8ISRFYnejMpNUBaP5keE4wxskyPVtmutehbBTEQupkGeKKdF2yltA0WFh46QHIKgGx5Ra1UPklaHprZ6ZnMIA9JGWLetk2UHgfNXbQ670NmI8C9UCCjt19/4YcQXkdm90Web5XjJFv+KZlwC4FZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744789804; c=relaxed/simple;
	bh=NwI/w7sEPr8M4cNj3Z3Vgr8mnZsspxrs/sQzytp7XRM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dsC+Jt9rBQJpzY9IBaoSfXEZlPmzih6bbCtlTkTxpSZyJF3JqpUsfo1xepKn750ZeAz/DVzItiS+VM78Srcg/xOfH0rJDra8s4iDreU+tzX7PSdgzd9IHkdeFrYp0a42zdb31QgNEALI2ZdLg5QMYB2LPAiESFNXPUgl+y5YwzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cA1sEXkT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xBtd4XUg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53FMMs2D005330;
	Wed, 16 Apr 2025 07:48:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=UuRMai/atUHGm8JGmWGErYAlxnmsmeI88qA/SN40DxE=; b=
	cA1sEXkTsiZpZ2wHN/Np+KGHo5VSSj1VowknnNE/jFPi5x7f+irsaxrv60irSmQe
	xXbgqdXELX5xRtMF9i0JjyxkqPdubBViJ9wQ5pSXgYSUSObpOwfxsjQif//EMr1b
	L+2gmcJS8d2pAa90A3naO1i7oPG6KmQaHMzqzB/jatBpgsVnxBUaA4yKyXdpTvmn
	Ob08Or5Yqy73S5RByrjmZ0+omMHlZGUgEa/gszB8NMhYN0ZTvJ93wTSC8JO8Cpjn
	gPR9+b55GHSpt/0/87YGuiqK2FLFf1qvuJZCnvdDJn3eB1bwPBnPntVc8iU7XvtR
	S6kSlzLxjBjm/WCYkKlvZw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4617jubgma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 07:48:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53G7J9qY009183;
	Wed, 16 Apr 2025 07:48:47 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 460d3k7xjb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 07:48:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rOxGLUBvl80kUYt1TNwtuOEGLY+BxxtUlU0oFw37A821WAxFnq9qTczs/uGkSA5aGhqZ9RQylc4MuEUwSgjdAFXqIg4iiHhECoonIr9y2i/mAcT8FUk9TpGnm/PNYhRQq4WtknP12kUAXBJZazP99AMZnRw0rA7FC+NQwsH61IoEURDf3R/wilIHr9UoOqM3BT1+LvpksR4OTvp6GMTFRF8DrhzRsksaJRcL/X/NHngTrD2AcFRBC4hcEEhN0suj2rMRO3e0V8nQn1ueAc7U0v2AQPWO+TpW6YLKg/y/Zh3ftNnJ3yQ1z4+Sf4EdgAHfxnIa9lndsYXpodpC+VNoJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UuRMai/atUHGm8JGmWGErYAlxnmsmeI88qA/SN40DxE=;
 b=CkXczWNxRv4pV4FR1aTaNscfc5sDLsIi63Ex4u0wISIU1HQaDfROXqHKLG97osLoUvBTDxdNY8LdHovKV59gKjDVYwLfVwJ211feYgk0i/lpAqlFdFGuMSxLfCgzMGvXemJQpH0OlDtG9nTl+zUBiiap9T6nhuzdiVP9x6iHy86u7dngbJv4yuv93J5yLwqrpS7zKfVcmrilmp1QPMCWgoy17Pr3Oqh6xtmc/E+DmXfgELcku2gjuPTBXysO2Q9GrZbVCUa/CET1NFgLXMBM8MfcmPyNwzCo7XYbF4FeKukCZM7msFvNNYvYPOJ5bs3zkye6TJuzrX8fPRdyZHzofg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UuRMai/atUHGm8JGmWGErYAlxnmsmeI88qA/SN40DxE=;
 b=xBtd4XUg/6b/wqjT5TUJ+XwI+zGvSWmDKrAjS3ZddIaJsAUYKpWm5eQEtbejXaw/qEOAbDMKsmPKWXgilJKctXUArVhXwbRIxROmNRQU7o4wN+e85vOEk2s9oQsZTO+qnR9TNPqlgp3wgOVFYv4302h/MzH39Q7nQnoOQ4WJYKU=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 CY8PR10MB6802.namprd10.prod.outlook.com (2603:10b6:930:99::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.32; Wed, 16 Apr 2025 07:48:43 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%5]) with mapi id 15.20.8632.030; Wed, 16 Apr 2025
 07:48:43 +0000
Message-ID: <7bdcb028-1068-4621-8c06-f8ba68af52ee@oracle.com>
Date: Wed, 16 Apr 2025 00:48:39 -0700
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
X-ClientProxiedBy: BY5PR17CA0004.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::17) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|CY8PR10MB6802:EE_
X-MS-Office365-Filtering-Correlation-Id: 2854c00a-5b41-4553-ba24-08dd7cbb1c84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NE5Id09oVjc5SEdRcGhkOWFlcGI1U1RhekNVc3IzY0EzQ2hDbFhickVTZjgx?=
 =?utf-8?B?V1cvV1BzN254c2pTb004Vm1ubzdnelNNYkNzTVZiM2s2OVZDWVNHV2R3U2py?=
 =?utf-8?B?UkVBWFFXczNabjVJRnJ1cTREOWtQMUNUMlRHakpOWFdEWWtsSEtCMytUTm0x?=
 =?utf-8?B?SG14L0FEb0VBbE1kT2dVVkJWT3JSUXlIOEZxeWJoaFNMWTNXcjZ5T3Iycyt3?=
 =?utf-8?B?WUlLRHBnY0NUVE51QTFVVFFwZERwMnpxaGVUSEk4bnRYa1pnUzNTQnhxR2Zy?=
 =?utf-8?B?UVJoVFpIVmVWa0JnZ1ZnSnV0RmNDVUlZeHllNHhFczB6Z21tQ0Y0djF0dDhz?=
 =?utf-8?B?YnlPSmg5bUtSWjREVmlvdGVyTWcrRFZWdXpMN0FZNW9yUzMrRVZycTZidGcr?=
 =?utf-8?B?YXVEWXJWNWphVHZwdVdtYUNnUzIxMUROVDNWbTZicEJPTlRJSHNpZUttZ3g4?=
 =?utf-8?B?WmRIbkUyTnNlUjk3Q0FIY2pVVXgwcWlLdzNWeFliaW90RzJ4QUxvYjZYN0ts?=
 =?utf-8?B?SDFXOUhBMG9JYUxlS1RVMC93RVMzUHJQaEtaeGhqQnJHOTR5eCtKczVWck9I?=
 =?utf-8?B?WGJUQ0tMS1E0SlBmMmZMTEhFRXBndzkwenNmNytSSVRML1NvTjg2ZkdScmU5?=
 =?utf-8?B?RTQ5b241eXkzdDlKSWpVTTNWdTdrdEVzVlJyREZ5WVZnS3hvUGpKTFdxZnpx?=
 =?utf-8?B?ZEFjOVN3TE1KZDU1TDJXSW9RSmwwaGlUbWpySlVzTjZlTlQ5KzdGSkRyK0x1?=
 =?utf-8?B?WW5EY1lsVk55bmVJdWE5Q3dveUxWVk5iTTNDenY1bE9ucFFHa2NnVkMzWU82?=
 =?utf-8?B?bjhIUzhvY0FBS0E5VHEyZXZKT0cza0hoWEEybngxWkRzek1hYmNiZTlPZ2tQ?=
 =?utf-8?B?ZDMrR0VMSENQVmhYSDBKWkZIbXp1b1U0Z0FqQXJQUWVrdGdwUG9pZURzSFU5?=
 =?utf-8?B?SkJnWHYvcTQvVWU3OUM4V1NpWERjT0NWK21ZTjR5Z05wVzZ3a0FxUGJzdlgy?=
 =?utf-8?B?cmg4STJXNWhHamtCUjUvZTVPV0dDS2w4QXdSaTM2SFJPMXpQdGxBOE80RWEx?=
 =?utf-8?B?clc2S21pemJjVllQdVFuUStNbHlqTEZDSVJ6S2dqeWFzdk4wbU1RSC8zU3JS?=
 =?utf-8?B?VXVMN2lrekk4c2tCWW5rcFJ3NWJ5TnFNQ3VqbTJ3WUdCa2hXcGN1dnJUTTRC?=
 =?utf-8?B?T2tSN1ZkcUFjOVp4M09iaUZqaEV6S2trbFFYaDU5TUUyMUZUcDA5TFh4VWxt?=
 =?utf-8?B?WG02TXovcFRTSmIrY0wyZkt3MkhlNFFSNHRVMGh1ZDZQV0V5djVkUk9pVkJU?=
 =?utf-8?B?aW1SWFhVY1hXbVNEMWYzQlptMXVHSDRKbCtJcE9xZTc4QnY1OHZ0ajJWQTg5?=
 =?utf-8?B?OHJHRU9mNEtyejRQM3B2VFowQk5ORnFpZG5HT2J0OEZsaXZ0Kzk5YWt5Ujht?=
 =?utf-8?B?czJrU1h4RDNKR280dk1GVlRuZXdyazY0VHhnbTUzSlUyd3dweVE1WkFOZnN5?=
 =?utf-8?B?ak1lUUxkVjJzWGhsaWF0V3FyUlpGK3prcVc0Y2M3dXU0WmVKb05Fdkt3cTdY?=
 =?utf-8?B?anZJRUk0UlhFcitGd0E0V20zdDA1RkxDRXJMMHc4cGNtcDJoczU3VkU1RzZU?=
 =?utf-8?B?Mm5CRmFSb2EzSFpnVk8rSjF0QzVsaThqbWozWHduQytFdnpKaDgxQldYWlBt?=
 =?utf-8?B?T3JNdzhPdGdsK3FLbzFHVVZXU0xyWENnaXUvMmVXTVNoZ210QTBlV1VDcVdr?=
 =?utf-8?B?dmpmQlZMbFpNSTlZS0x5NG55dThFWkhqVkFiUG53UGg1djV3RjFBLyt1SXEw?=
 =?utf-8?B?VEk5bjdQZ3pUVFNubTU0ZVdZT1FSNVB2QkpGT05yN1dCYVU1eHVkbWVBaEhT?=
 =?utf-8?B?aGI3ZThTKytueEt1TTc1TlNwNnVKTEZJVkJXVDBJRWlIRldGeFFJdCtLOW5k?=
 =?utf-8?Q?TCL9SMEVKRE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V05UM01kY3ZsWEMxVG1FVldVY2Z6bCtTZ3NTY1BST2pVUUY2WnpZSmJJTVEz?=
 =?utf-8?B?ejRXTk0xRzJMOUxBUjYxTzNxQVFZVmZjeTZ4c3Fobnh6R0dQeXhZRGl4U0JF?=
 =?utf-8?B?WEJCdjh3aE51U29oQmUwSEFwcm9JTUpMTlpZVnVFSnd4ZnFRSmsyUlVZOVV4?=
 =?utf-8?B?WG1BOWEwcmJWR200ZnJwTzdYbEE1RnNEamxjcS91b3l0aE9OS1ZTUlcwT3ZG?=
 =?utf-8?B?aEYwWVlMQ0lSWE9HQlF3L0h4OVQyYXQ5RUpzbjhzVVU0d3hmU3ptNFhGWWlN?=
 =?utf-8?B?M3ZFNFd0SlV3RjhNZER6S29Yd3F2TzdQYTlGc1VxNmpJZFZmZ09paFVleTBE?=
 =?utf-8?B?WDBZeXhDUWkwY0JVT0ZLeTNDRjBnU3VqQUtkNUwwZmkzQjdWMFFCNVdrM3Bm?=
 =?utf-8?B?SFhYZU8xZCtPbVNUMDlRazkvbTB3czZZdlI0OEdwU3F2QlEwNktscWlSd3g0?=
 =?utf-8?B?MHAvSUxDSmN1enRQcWFkU2xUc0JPN0VReDEwZTQvNFZUUFRhSE9ieVpLWTd3?=
 =?utf-8?B?bnZDSGsvekhBSENBMEFFQUFtQi9jLzdzb1hZd3paZjFFVXBSQWduM2U4TXN4?=
 =?utf-8?B?MFNEb1ZDWDJlYkxaVlNZVkF0ekh0Y1pFWnhudzFRejFEM20xUVhnUnh3TktB?=
 =?utf-8?B?VXJMSElyRzlwNWN2MTZQUGw3OCtKTE5ON044SExXY0V4dUJwN0tGRHdvK0xl?=
 =?utf-8?B?dnJLRnJzZGJWN3NkeEQ3NExSRDIzN2tSMjNHdkRJOFpKNWkxcG4zQllDTG50?=
 =?utf-8?B?em5Jd3F4ck56T3R6UWNNdjZOaGkyVkQvVEcyYzBtRlVBS2hWZ0Q1NUlEcURh?=
 =?utf-8?B?cXFia2VpZ3dnbnJ0dVA0OE5UaDZoQTJSWFh3Mzk4b2dzL042WkJWa01HZDNt?=
 =?utf-8?B?T0diMGFMSlZ5K2RuQU40WUNCS0JqNlZXWlVZNGNja1ZoK29ncE5nQkVOYUpD?=
 =?utf-8?B?dVZkOG9TbzJ2ZVNacm1BcEZlNURqV3k4R0VmenpWcC9UbThYcUVxTjJ4VlZs?=
 =?utf-8?B?L0dRZnlFVVRUclZXemhzbDBaTFh1clVoTmpsVWtoOXVCc0ZOVFRkZkw3cmtH?=
 =?utf-8?B?b1pDSm90WmdXc1Y4VG1ydWZ5SmRMVGFsWWR3UGtKNjJvZGg5bnM5TmQ3bGU1?=
 =?utf-8?B?cnRaa0t5a3Q2NkJzcnc2NkRFNCtJZXpYYXpWWFhxNnJUNTQ3Y21zZEFwWXJn?=
 =?utf-8?B?eG9EZjFWQ3hMWDBNRStwUzdCT28rWWUwM0xJdDlWMUNVQkMvVjVBUUlBN3o4?=
 =?utf-8?B?VmkwNEdpSnJZVFlFRFpjanh4Snl2blNlejZMMjZSS1M2MExNS1Blb3dhSVJz?=
 =?utf-8?B?R1JyaTBEWWIvMFF2b2R1ZGpxZUZ5TWVtTUhVZ3IvMnFsaGVkMERaazE3R1Nk?=
 =?utf-8?B?NU5KUW9HWXVzOEFIT25TQ3VUWXRrMjNSLzNEcTZxc2VqYWNvR2hiMjZheHVY?=
 =?utf-8?B?TU9BVzdmTmRvSys5ODB3dys3L1ZVM2ZUNCt5NkdodkE4dHUyNDZ0RG9WVFVq?=
 =?utf-8?B?eXNBdEMyYjMwU1V5Qm5nU09DeWsyM0JkZENJWnRka3FxMy92V2ZJcFlVS0ZL?=
 =?utf-8?B?SU0yT1FCWWYwTWVhQlcxN3hocWlad0c3RzZ4MnordDRiTjVPMmREVE0zZlhr?=
 =?utf-8?B?RFQzbVVUMEJ5Rm1oTWpSc0M5cm5GUDd4ZHZ0VHp0VC9RK3FhTEN6MkNyaFhw?=
 =?utf-8?B?YlVOWDNVRTFMazZXYWd0OGNmTlFsdEQzTkRwa1FGcGQyeWxhdmFuSlRmNUNY?=
 =?utf-8?B?ejhETDY1RXB3K3RLSXR3YXV6ejNpanlDejdjNi9JclVRQ3dJTjh1OGVkTytJ?=
 =?utf-8?B?QWF1aEtrSi9qZnZaUWhUYU55VHF4cTQxQ21nYnFNOTJwcUV4WVBZVjlYWjhG?=
 =?utf-8?B?bmw2UGxVZjhDY1pxQXl0VFoyRVRRcmVIVGgzN01OL0FXQ2RLdis4Sk9lazdX?=
 =?utf-8?B?bzhKNEtsanJBZngwRVJrYU8rdFUrcXRTUTFPQ3ZXTWJKbHNXRXF4b3FWZnBq?=
 =?utf-8?B?Wmt4TVhhK2FFTWpDK3h1Z04xUUNmczNoMVNUdWJ5cEoxMmRzRHlwWjJxSndw?=
 =?utf-8?B?bWY3MGp3MUhWK3A3ZWM2aS9DU0pQNEtqVjhlVGZMSXh5bEovQ0tkeGtrRFk5?=
 =?utf-8?B?NXNNT0VlTW5RYU5JL0d6NGtCZ2puSTduQXJ5K1d2OG80Q0E3QVVQdGtVbUw0?=
 =?utf-8?B?U1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CFlZY2pVK34Xc0T0BVYDXoaNv/rlP8f+Bu4AN4kyBh74LTzJyk7EFU0mvMSmOLK+FtAHyceSJHZYtfKw1CTjQokUOmpeNHmEmiAyourbW0pO2uoPzXAaVddnTRXTEgeO275AcuuxCzn84o2UZ8J1RzOQlWVwAnH+kvoQrL7dWW8ZNCLBvSZb/kL9DCc36WM5b/LAqSmVn9edVLxSv+fxanMt7lViFfZNZMedKiuEtABpxdkBSO3XOVEku4OJrn6VTcViEt9jbVWjHnRXfhC2HIuC2Uv+O8rf3NwqGzaN/uLNbu+UM1WaO5JjDdAtMcZem6zk7CihkYhBITddxL0nWIwdmJK8ujXutkVp7qF/hMdimQrm0de6LVhZun2u6yyIwNDIJxis4C8CL9ywxA5N7KVWeirEAgHiETWIc+c69Uer12F/PXzZXLvSCBdvR+4d/Xw0f4Oi8g3RJzv6lHmDF2A4z/Zp5iBYGDYE84t90QIMKjTHzOKh1/TI95wO8nTZ9ICFRJo+z92Hn2+umgGqKf0mSBZNGbztsB7Bgds34qK4fpQIlSzocQq/C6FEB9z0vCXemeRmsHKV355o9/oDN+s1GohKm7+cNujEq/zhtMY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2854c00a-5b41-4553-ba24-08dd7cbb1c84
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 07:48:43.7912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9C2Cq+r3bs8+OOMiiHWc/EuuoVb/0hty7wocIbs3GIeSjju5ojBHO/3X/o8hxsrDAsgkr2CQoGoOCUbapGbDVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6802
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_03,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504160063
X-Proofpoint-GUID: -fWpf8T8W4jBZAc3OFXMyPp6KnWKAoGR
X-Proofpoint-ORIG-GUID: -fWpf8T8W4jBZAc3OFXMyPp6KnWKAoGR

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

Base on QA of v4 patchset, since we are not going to exit with an error
(-EPERM), I will need to bring back the global variable as in v2: kvm_pmu_disabled.

https://lore.kernel.org/all/20250302220112.17653-8-dongli.zhang@oracle.com/

Because we don't exit with error, I need kvm_pmu_disabled in PATCH 08 to
determine whether to skip the PMU info initialization, i.e.:

- +pmu
- enable_pmu=N

In this case, we don't need to initialize pmu_version or num_pmu_gp_counters.

Thank you very much!

Dongli Zhang


