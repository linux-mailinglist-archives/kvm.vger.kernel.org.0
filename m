Return-Path: <kvm+bounces-43105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC509A84F24
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 23:21:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D779A9A3EB8
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 21:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE1E290BCB;
	Thu, 10 Apr 2025 21:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W2T5IQ+H";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hXuZKLsW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E3D1E5B62
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 21:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744320070; cv=fail; b=PDmv+smFy2gLmQbRHECrz+u6x/WxGoXX9yHzU6k5COfSRKD6+0W+IZegmEs25bYv498lmjEAsZJmmfN/awd5pVotmMiFMAVyFJHy65aPr4F8Dmc1HVuYxseQ00iCOct6KuUPh0fT6wgp2yTZ4RttfmHLhZYz/e5sq5xDkQHMAAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744320070; c=relaxed/simple;
	bh=KgDOl/e1Oc7d+cv7ciw4akBaSF7jtXSHOCVStbjHffg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MMUUzUQSo4II4RyrjjF5fzLM+VHNuhQIAnLzDecqu0DpTWm3pr60vOYNTJGI19m46+bTr7QYBigiPIBaPgS04gUJmDloZgz4bZQbZ4xLIZaUU+RO4rIBfMfqWmZ2rPsx2RdFD8uyMhErp7I+9JRlyERpspV88ijLH37NKyIr3ag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W2T5IQ+H; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hXuZKLsW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53AL7R2h011013;
	Thu, 10 Apr 2025 21:20:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=N2n3BCLvdlrIC2S21rEq8DkkWCctiGUO+CZA4v9fuzI=; b=
	W2T5IQ+HW6LZNSZyP30g0nVyBpgVD0NAdKxKPSPxCSU7H/7f/d1ld8TLI/a0b1ez
	oMsLcddzjcC1Khz73vV9v0klr20F0MlDq4wEKUNH+2eJKG3RC1GBCM7B+psecRk9
	UCMdeEUZtetgYnkeEkeNQo2wMfBfQ4mtAhU9gw5KVKztFYlL7KV9PKCTlxEt3GRB
	c9tiiCWzw6PZScwRDMorgR++KodFNjs3ZjV0VnTfo8zXsHTXmKKwLFSzx5iapVIV
	/zv1RXMgaUhM5vw22Z+MJJ2UVIxPcRLDL05jb2gBRfs5Lxog81QkMhYDLg3DzBOM
	DMYSPM9ba2cDuqIXHMYfAA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45xnm8g0ub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Apr 2025 21:20:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53AKj6Vu001435;
	Thu, 10 Apr 2025 21:20:08 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2049.outbound.protection.outlook.com [104.47.73.49])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyctajp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Apr 2025 21:20:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q/26bO5XvMZRE8fCbzjrIf/EjTN8+6b31ssB3LCKlO0LoHqBF1GIAWnQdvocjGmBVQ3/hrjpBYKBi7AbjKsJXFnTnIxwYzUJC4S1Gau/zsK1Gj1J9kR/Fmvd7HkTIpiIt0wXocRMdNQCWYupNFdhgHF2ZOvb7VrTGDpEwVBs+Hd4PvfmgBHRHf5LU8hIYG2ErnUxr1p3LHfBEHQ9jovN+5TwsiPo+VskROgImwGTvq7zCWFYXUz6YJqO3HDR3GCLFhA5sAn7IUGBsmML1UOUIIxgQeZhEpfeu5Zc+h0dwFmD2Fe47tbSH+DZoOVWk8KA9iPdIgK5fS52/508qVIHNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N2n3BCLvdlrIC2S21rEq8DkkWCctiGUO+CZA4v9fuzI=;
 b=M4U6pVULBAR9oWQe5PGeHHggkKp4s3rISu0WoNUJ+bndn+R65GsgeKMMu7Am7/13nxz99St12bbuc046iHPWVb7gHPxpzek0u1tb+7YPQ7YLc/HDRh3L7VMSd57Hq2HeNg9/+zgVEWogzXDGgdz7Q+ZdwyoQSyIF8DbrVTgcUPy9zbQs/sPffJIZ7wkU1THllgytrDFUiFNnN25rW1EXVUZCsNiseNUGaOroE++pAzVFKQBqL04U3O8ejUFCoJKJCpkVJ/0OGMNsaR7I0LZPzh84RrpnUsEctrWokPWBNiUR7Nh0UgAorXdoND7oWOLGTmXbEygr83CH01H7LjsylA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2n3BCLvdlrIC2S21rEq8DkkWCctiGUO+CZA4v9fuzI=;
 b=hXuZKLsW3d/0wb149+GJWvAoQXCoZdWVPsfnu5/jLAVfnQEq7dhPmsxtwDRYTYfu2cUF2om5r/E3rvkL2zfeoZ5Yyl8hTIneDmMsfKQCcZCO9kqIQj2w4MUvEIdRdWN7yQiH11jbByjNZUOY4tvgzigqkogUzh635BfYJlejLhU=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 CY8PR10MB7338.namprd10.prod.outlook.com (2603:10b6:930:7e::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.32; Thu, 10 Apr 2025 21:20:04 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%5]) with mapi id 15.20.8632.021; Thu, 10 Apr 2025
 21:20:04 +0000
Message-ID: <ecc2d76c-9c91-4bdb-8308-b93b516635a6@oracle.com>
Date: Thu, 10 Apr 2025 14:19:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/10] target/i386/kvm: support perfmon-v2 for reset
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
 <20250331013307.11937-10-dongli.zhang@oracle.com>
 <Z/d/ft0CufA8prwl@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <Z/d/ft0CufA8prwl@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::37) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|CY8PR10MB7338:EE_
X-MS-Office365-Filtering-Correlation-Id: cb74e5a3-691b-4476-30b6-08dd787575ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGN5RDNFcnhXSEhadkNLUmRSeGMrUHZyNVhWYjFDWlRqbjF2SUJoSys3VVJP?=
 =?utf-8?B?TkJqLzBQK0ZsTFJqVDVXdXNNaERGcC8vY0dTYjRDVHhETTNjNEVNd0UyUnFG?=
 =?utf-8?B?M1FqNWFoV1duOEh3OGJ2dXpEdHpyYTFtMFhFS1BXa0RQQTNRTUN4aldjYlpZ?=
 =?utf-8?B?UWtLZTV6WVhrV2N1NDg5S3MvNWtUVjFKalVFM1ZCVU04Qll3bVh2ajdtT3ZT?=
 =?utf-8?B?UjBwZkM2T1VvSzdPWnVXbk12QWRPSHJtQ0tucWN4UERYNlBkSk93bjFPdnAz?=
 =?utf-8?B?Tm1UQkFvdkdsYWQ3SmZEREFHUGkvaDlBT1hldzFwNHRDOE5KU3U5WERnNjRi?=
 =?utf-8?B?SjQ5WlMvWWpnVGpNTndzN253bGxRdnJBWE95VHpvejI3L2ZrSDRpZEFiLzEv?=
 =?utf-8?B?ZmVvVEhVY1VZRDNSbzVMUXE3S0R2YWtTVTczMmk5S1dNclJaVzl2cFNzWHFj?=
 =?utf-8?B?c0dTUjBjL1IrY29zV3oycUpIRG5rVTR1aXhmcSsxTnBrWkxpVUtXTXZDYkRU?=
 =?utf-8?B?ZE56cTRQRVVkcVU5NWtXclJhZDN1OG9zRk9VcnYxdHlJQlk1MWZldEZyczNJ?=
 =?utf-8?B?ZkhXa1NFRDlDKzhnZUxWcllqM0k5RUs4a3Z0M2ZuWUNZVkd6VkVEOEhNSWhu?=
 =?utf-8?B?L2tpL3pVWUFvdm8zNGpOVWhocnFtZDE1NEFGR25EYVRIV1RpWHVOalVqOW1C?=
 =?utf-8?B?K3pZcGFOSHFwZDBSQVF6L1RadjBrZTdUL0JBNUh6bG41VFJENVVzcFg2bloz?=
 =?utf-8?B?WlpDbVI0U3NEcnVnRGFuMjV6N1VnektGU3l3d3VIRUJEUWE2OU91NjVwOXZ5?=
 =?utf-8?B?VlJSN3lTcmE5dEZsZEUwYWx0L2tPMEVFNkRjalRJNTh4eEt4ZnFZRmdXL1Z4?=
 =?utf-8?B?SGNlcFFGRDgyenZhbDU2ejZHcWtITWo2RzM2RndPVVYwNUt5VzV5RzZHOWtn?=
 =?utf-8?B?eGRMdDdyeS9ITVovWXhLaFBJQy80cjlQd2hsenBrVW1NNzRhQ25aTDcxZE93?=
 =?utf-8?B?ZmRXdmhwdHBDaXEzazVzWjRUeHcyOTlkT3BKV0lvQUk1VGNCRytHMmxTNm5M?=
 =?utf-8?B?NVNlUU5sN1ZOcEsyMzBTY01VOUFxVHNpa3ZnVXlkQVhjRFpTbFhmSUFhVEgz?=
 =?utf-8?B?QWNNTUw2UUJhSFhqeE45MWFjRi9NNmQ0dGJ3bHFhNGwwQnJVbnlTbFEyL2lW?=
 =?utf-8?B?QVlEOVZpZERzaWJmd09MV1p0UytUSG0wekRMcG92UzlyREhOdUtFT245NVF0?=
 =?utf-8?B?RE45dkhWNmlDUCttOTN5RVJIUDloMmJ3bUFtdVRqb2ZGMmhySWFudFVwY3Vh?=
 =?utf-8?B?bTlEc3JrWE5YMllzYklNQXhSdStPaHRnN1E2ZVRHZnkvanZGOUR6Y2ZPTFZU?=
 =?utf-8?B?NWZ2T3h6akRpMnZNSmg5WW9xTDdrd2YrZ2ZZWjZpWjZOYzM1WGpQZFRhU0hn?=
 =?utf-8?B?UVpYeVRyRFRQUmpMV2JlMk1XZlRNU1h6UVQ1cFUyV2dCK21Za0JsZ3RJWkhC?=
 =?utf-8?B?Q3FaSUtGTUlPSjE5OUFpbXY2MTU1cmZsUW1EajlLVHVtbm96S2dEalFDSnhU?=
 =?utf-8?B?N21peDdsdFZ5b0pWZDcreHBSY0tVbG1HS05pV0xnYWJJU3lnZkVaQ2J6d0pl?=
 =?utf-8?B?WlBlemk2MUZrYmMyaFd1dG55NTJHMGUxRFJVYjdhb0N2MWRhNDR3ZFFHZllp?=
 =?utf-8?B?aFFIR1BMTzBZbUpmSk9zdTNCU01HaGp1RDU3eDBHNHR4THVCZ3BYUERLUXU1?=
 =?utf-8?B?Smo2aEh4eFdaWEVCR0RnanRvQjVQTUFtTjRldHhIdmp4OHZ6MkdXNHp2ME4x?=
 =?utf-8?B?VWdGem9tNkIyWjBOMUpnUjFQb1ZudHFVOHB5NnR3QnhEdDlCU3hCSjVHVGZ2?=
 =?utf-8?Q?iibneTnXSbFla?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SkRWTHU0dWlPeURRNjFVSFVGOFhGaEczd28vTjFKT3NVNlZrZVFscEsxVVEw?=
 =?utf-8?B?Z09EbzBMSlkzbnNJVmhkc0pCem4rSzkwT2pUS3RXSWhGcXc2aTc5ZXZucHpt?=
 =?utf-8?B?OS9jMS93QlR3NDlGRkoyd2liMXNkaWZ1cFVlRTkyTXdSRk53UnozYWtFQk5n?=
 =?utf-8?B?V1J3UlU5WE5iSHBLQkFnNzdHdGRmUjhSWFUxVEJnTG02RXNub1VZM0EveE9V?=
 =?utf-8?B?d25qUENQUlZudEJYMm03bElMZmNsK3Y1dTVYV3dCc21QRXNQOXRPUW02Ynl3?=
 =?utf-8?B?SS80VjY1NitwTDhqYW9oeFJUTHRrN1lDNUtCUXVyc0xHVklheWdydTJiRGJx?=
 =?utf-8?B?c3NjNWExaXZxdy9NNHRtOHdHZG9DcEozV2JieDRUcGdPVGVMUWZJazF0bTdn?=
 =?utf-8?B?K1FCVElnNGpVMmhON2lRUjBWTThjRXhEMFlSS0FTV2JFelVkcmdzSERvQjZR?=
 =?utf-8?B?VmRVbVVnay9qZkljVzdwK3hLZ2NtQ0dRUWVmY1BVcGJvdzlXeWVtcVRQdDJB?=
 =?utf-8?B?dkRuanF6MU5GUktvSDBIUnhzMmpGU0crdG9xWVo3ck9HbkdPak5md3JLb1Fu?=
 =?utf-8?B?WllncE1ueExoWTRzUytOVVlRYkloUFVlaVpsSVZIRFQ5ZnZVS3p6aVBKYkQ0?=
 =?utf-8?B?MFFRUktiQzU4c1NGTUtKaGFRcG9SbkxwT0FkSStjOTNMano4MXZYUzREZVh5?=
 =?utf-8?B?OXJUVENEUk04QTIrVEpzSFMzRXlFWm9kbE5xUE5SZHNyYWNjM3M5aVBYcCsy?=
 =?utf-8?B?dnhoUU0xaytUanZiNFpxam10RkxwR3pGaThRUHIveGN6eDFTRjVWNk9wYlJa?=
 =?utf-8?B?NVVyRnQyZ2M2dno3eXZIVXJuazFRekdOdmVmQUhQSkcraXV4S2lvV1Q4MHEx?=
 =?utf-8?B?aENUK083NThDdGJsdjJSVkVZdEx0V0NVVVZYSkppSXRVRzA3R0hVL0Z3RVRH?=
 =?utf-8?B?Um8vU25EdjJHQytaTi82bkMxeXEybDFOUUhoR2tPZzBPcTVNSnJjaW1yWFNu?=
 =?utf-8?B?RHcrU1daZ1FYZTM2L0ZobjBQU2k4b1F3RlJHTEtJSzVFVGdjVGN6WjFwZjAv?=
 =?utf-8?B?UmQxSi9zdlpCMVlabURleHJibi9nanFjNC9CZWRoMGh1QndjQUpKTXVjWWw5?=
 =?utf-8?B?c1ZweGpPenRZZ0ZYUWloRFpIU0dCd3QrdUp2Nm40c1o5UmpCUUw0QnNiNnBQ?=
 =?utf-8?B?SkwzYXhlNWFJbUxGbnZ0UGFwcW03UTArV1FKNDFadWI4eEE0UXlpTUdqNUd2?=
 =?utf-8?B?Zzh1L2ozUzg0M2h0OW1vbW9JYXRYeXl6K1VIbm9kZFRHWkJFeDA1cjNjdzd5?=
 =?utf-8?B?MVV2T1B0QTBqZHh5UkxJV3Y4MGtkQlFMZyszT2M3bzZ1eVNaWmNxejBxTTds?=
 =?utf-8?B?THI5ODh1Y0JUVjdSMHJqYzNmMWlYdmxzbVBWd29rOVVab3oxRkRXVUJ0bHBl?=
 =?utf-8?B?WG5lb0UrM0htbDVBdXl6dG9tSllQL3JhTDYzQWVLR1cyZE1kZ29kZ0xHb2la?=
 =?utf-8?B?THpMTWRBZ2lRTDV2RWhYaTkwNitMSGpoR3JBTXZNOE9tVWRoT0xnVWFmQ3lH?=
 =?utf-8?B?NzRlNCtDa3hPNlBobjl6V1pCa0VQVXUyUTJlbkhkM05Jc3lzSXRXVW8vYVpr?=
 =?utf-8?B?T0dINHAvQUZSVk5EeWpCaUVqR0ZNTHZ3bEEvVVMyRlZZcURTb1NGUWlFc290?=
 =?utf-8?B?V21PNmw5WjNqQWVSM2FtaEhLdktsUVBSc1pwOXJPUDBPZHd4bjhPejVDS3E3?=
 =?utf-8?B?NFpERVROdXhNeGRBd05Md0ZTR3NVUGJmNjBGdCtvRVBJd2dFWXE5Z0VpeUY4?=
 =?utf-8?B?dUNJaE9WN2NrWUFZbzgxcHo2QUVNVE5KRFZWQlpDbkw1bFNONldyYUZUdGYz?=
 =?utf-8?B?R0N6c1NLcStCWEhXUUNEc3lwVHpOVzlqRVJKOWlnWHBQckFJbHNuY3JqTnVh?=
 =?utf-8?B?dUhML3RKMjZqcnNtYm9xVndTYTQxSG1lNVE2MmtsdlhUdHN4eFJBUzVzR0tn?=
 =?utf-8?B?QWFmLzhnZ09GRGhxYUxjcEp0Qm4wUjVHR3Izb2o4MkpLT0twaS9la29VOHM4?=
 =?utf-8?B?UVlHcEpobDY5ajBCQW5sdTRNQ2lwOFFWcDdYREFIQWxGdUpTcS9WYkxYOGp5?=
 =?utf-8?Q?5x5syKVjjHzgbAQU1NRpExRB2?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v+rcw8eMO34kUMsQVZ0RF6ro7LeMcfL4uzi6kGdfySHfApPVExQdu5uUzhh+Nw6TNfkQDWu2cy0FexzUlPF9VvyG0/F9KACO/BbOjl5boaBQhxH/dzBOUMzp26hRJyfIEFEIFr6NJrng7SHac3lJk605tSh+8HYBtt4jJIKyVFsxqBaoma0/aP3xRnkgSvhUgkvrUyyD76vb7D5WdgmHH6IJ66FK9emTIFYPZxrJAUAOMdTd2NGwuAZs44z9EVhUa30hcTzIUT/G+NLUJNbJ5jClXgpB/iGKF0Fm7cVUx2nJtp5JIhKOzg9ofcTsH0cFOinjH6QnMgEjvx94kbB2qgUnm4eAEHtqfVhVcal1AxbfOW83xXT4jKTN4LSuivbmsI07+cF2MIsDonSUGrIqnJrzAh7nDlD4wiaFMV3dOmqNxAf7LEoenansHcF9u4H5quHZl7WgnYOmt+4AvA0sW8YPdkTefBfJQiLmT6bS9//b+YdDojJsN0pMircgQ+ThyoU9Z/gZe6dy61PGhIdAGWi+BRMlWTZTisTTmSP299h3jto6nr8/RD1Jq97mh1hzgWgK4UwYZJxDNzLHZmPGDWZ9O23kwszsGW5pXx+8VWc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb74e5a3-691b-4476-30b6-08dd787575ca
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 21:20:04.1056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 59tyiI+SOC7oS7peo8S100IXz7hJvXMkcPri8Ej5SLZ7o6nISgE6jUzOlRYQPFnoVKYyIpjezMbqSbJKcYgVCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-10_06,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504100155
X-Proofpoint-GUID: X0rna8BzvnM1G_VPKbOredBzvotxhtHN
X-Proofpoint-ORIG-GUID: X0rna8BzvnM1G_VPKbOredBzvotxhtHN

Hi Zhao,

On 4/10/25 1:21 AM, Zhao Liu wrote:
> On Sun, Mar 30, 2025 at 06:32:28PM -0700, Dongli Zhang wrote:
>> Date: Sun, 30 Mar 2025 18:32:28 -0700
>> From: Dongli Zhang <dongli.zhang@oracle.com>
>> Subject: [PATCH v3 09/10] target/i386/kvm: support perfmon-v2 for reset
>> X-Mailer: git-send-email 2.43.5
>>
>> Since perfmon-v2, the AMD PMU supports additional registers. This update
>> includes get/put functionality for these extra registers.
>>
>> Similar to the implementation in KVM:
>>
>> - MSR_CORE_PERF_GLOBAL_STATUS and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS both
>> use env->msr_global_status.
>> - MSR_CORE_PERF_GLOBAL_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_CTL both use
>> env->msr_global_ctrl.
>> - MSR_CORE_PERF_GLOBAL_OVF_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR
>> both use env->msr_global_ovf_ctrl.
>>
>> No changes are needed for vmstate_msr_architectural_pmu or
>> pmu_enable_needed().
>>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
> 
> ...
> 
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index 3a35fd741d..f4532e6f2a 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -2149,6 +2149,16 @@ static void kvm_init_pmu_info_amd(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
>>      }
>>  
>>      num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
>> +
>> +    c = cpuid_find_entry(cpuid, 0x80000022, 0);
>> +    if (c && (c->eax & CPUID_8000_0022_EAX_PERFMON_V2)) {
>> +        pmu_version = 2;
>> +        num_pmu_gp_counters = c->ebx & 0xf;
>> +
>> +        if (num_pmu_gp_counters > MAX_GP_COUNTERS) {
>> +            num_pmu_gp_counters = MAX_GP_COUNTERS;
> 
> OK! KVM now supports 6 GP counters (KVM_MAX_NR_AMD_GP_COUNTERS).

Thank you very much for the Reviewed-by. I assume MAX_GP_COUNTERS is still good
to you here in the patch. It is to just do an upper-bound check.

Dongli Zhang

> 
>> +        }
>> +    }
>>  }
> 
> Fine for me,
> 
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> 


