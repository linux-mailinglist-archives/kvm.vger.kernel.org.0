Return-Path: <kvm+bounces-44333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FBA5A9CD8C
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 17:48:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9EB34C8C61
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 15:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3ED291149;
	Fri, 25 Apr 2025 15:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OKXxw7pt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jNUHMyou"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C74290BC9
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 15:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745596008; cv=fail; b=rWRbAK8BKh6I6MPGJI5mXdjcOBk3UEYbvgrWXJW/XV9MoglsskpjbFG96lJM8+RxRzn3QfZYvJLDBLPb/yO2znuSmylQJJRUwFhoCXnmcsfTui3H7FpAM1V55LvjRJg5DWDaAtmxpKcSgonL0J2QUpqICoKczfcu+9rjiFdYw9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745596008; c=relaxed/simple;
	bh=GzvchWA1lJCuSWplVDf6lQc8km+369xNA7vBcGc7r6E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cnN04R7mxMbSmNt94Uy7NTx26SObzCxNv1I4WorfZBHM8BKIu2s4p1DNIpAeXkAOsGI+nV49I6pd91dZlUGji6rY67FjUzU4K0WFACSc1vgBGZbOf2Ges7p8rGoPtAFqBO7yzbHFogKge88EVk+jPC/7i26yXYY7x77IXJrLK5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OKXxw7pt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jNUHMyou; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53PEtraa000818;
	Fri, 25 Apr 2025 15:45:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=l6Ktrva4Od5BZhbLZ4CuzryaVmJv+lGtvdg/GcOllC4=; b=
	OKXxw7ptIBlJHyxU4RCAbjKEEEq1BOjCi0WRO+q2+l4IJQ18WsB06TKRPc6+odII
	opyGpwr2sQrfNjDahy5SVvbx5kSC+LTieXix7j85ssrNs/B59AqpZIWky+6GhSm3
	gMvlM3SwoJivev8RPrPR6Ksgc6DrClrBczX1crdC/0p61ROGnBDEq72gmPk878Vw
	QjpJM8d6TpsVTzpJHu/LS9OIY27305A2PiZa/zpBfQsdToZ4n2u4fRvfXIUc8snQ
	LaBCcrrSDeD1ol2Dhs8KZLJN9rl557S9syF5hctIUCbLwEW61NQPspQa5Q3zqDL0
	EjtQ8/2QBA8sLJZKqVMWnQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 468cf4g84w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Apr 2025 15:45:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53PFCiVY025291;
	Fri, 25 Apr 2025 15:45:33 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazlp17010006.outbound.protection.outlook.com [40.93.20.6])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 466jbtk8cg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Apr 2025 15:45:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SpwYM5gHiixuuqw4976d507ufh9INqyQg5Sl2HZAwYmlzyAOiKOBLhv1rtiSkXPpmhQDP3nrw0n8zJZyAGv5v3zyNAyJ1EOy8zjwRPtWePTunxObHBcSrk+dmpQsRhiM9H24ypJ2XhRzSljyZdetdiQWsibJk176egyVav2Kmq2mIDodKsniROkHfUUUlkC6RvK/JYUIMBv5coTzr4kDfJHVuazznPorDwqWf74+WoyX67nkGOzEWTRYhnzhwA6BGgw+6tl57FhOdIGcNpjiRm0fNJ5T6SHHafS0nWQLxev8I4lG9pxS1LQkdkwu1a43JtjMFIDdYD80VO9Up6Z6tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l6Ktrva4Od5BZhbLZ4CuzryaVmJv+lGtvdg/GcOllC4=;
 b=Xy+BTdkGuHROJWl7di7YOHpSRI24Gy8RaCXdy1hg2K731O+5w/6ElR5+ZXt9JtoLhWOyrkKTDbNoVo2sewDaLDFugfmDxSlQjpk2u1kv2Sr8Is1bPLmbG7555IL4O/LkYD/4Dhw2zZtgrwtADnmqIy1NdAY+7ZdMYztxFvyEkoSqNoTJwd674balgwTbD2BiWxEO9toahTbPizjOnluAxMmpG3dkjRmUyFTDVc7zsLnUFufKrUZRnWQkPPjWmPD12QuJwHTFUpe6yknLiQGUOJjgoZ6timIAMs57g/80mZR2HYv4W2QD7An1Ot7yVzn7HpJpza+DFoVsqS20zyHD9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6Ktrva4Od5BZhbLZ4CuzryaVmJv+lGtvdg/GcOllC4=;
 b=jNUHMyoup6Q97jTc9QBayAWWniK5c87UWmco38TfR740IPH/bhO04Ni66OfDjIKgqS4/wpsjfV8si6Kf4RIzRCa7oBX936e76KgiDTk7qkQDxsPMxG3Fc2ssvIQ3fSRxAQzKcUcNust9IQqzlvCIVk39rDguYfeUwbVH9U4gRLI=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 SJ5PPF0BB87A13E.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::78a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Fri, 25 Apr
 2025 15:45:30 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%5]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 15:45:30 +0000
Message-ID: <3ec9615c-3c42-4fc1-8b40-bc9d7403e7f6@oracle.com>
Date: Fri, 25 Apr 2025 08:45:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/11] [DO NOT MERGE] i386/cpu: Consolidate the helper
 to get Host's vendor
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
References: <20250416215306.32426-1-dongli.zhang@oracle.com>
 <20250416215306.32426-2-dongli.zhang@oracle.com> <aAtHxmpV7ka1lseC@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <aAtHxmpV7ka1lseC@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN0PR04CA0126.namprd04.prod.outlook.com
 (2603:10b6:408:ed::11) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|SJ5PPF0BB87A13E:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d94e13e-5db8-48f7-decb-08dd841034f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b01jVllsdWR4UHdUVEtUamZHaVplTHlSQitoVEI5cjN0SXJmamd2MlpYUCtQ?=
 =?utf-8?B?Q2Y5TlBoYmlCMjk4SWpSc1lCVU55Q0xNalpNc3craEk0UUIybENKRlNhemJu?=
 =?utf-8?B?SlE5cGpQeTF4YVJpanlncEF3U1VuaitiRjUyZC9lbDZCaG1INFp5TEVGUE9x?=
 =?utf-8?B?bmhGdFFGQXJTR1RYakptYzltNTVYRlJsTmMrUm5Mckt0akY2RWR6RmpxSE9M?=
 =?utf-8?B?SitObUIzOThVZGJPa0t2aGV4SXlGU3V2ekQwT2pLZnBhVUFnUXBzTGoyMlda?=
 =?utf-8?B?V2pIQWlMT1lrWlNxbTJ0UzdSVzFWVFU1VUtoL1M5bCswbUc3Zmw0WGxyTHVT?=
 =?utf-8?B?d2VUMDB2cFp5UUF6MGp1c3h3a1EyY0h5T09VRmtjaHh6SG0walJwd2k1UjNF?=
 =?utf-8?B?R0NzQy9CVzZYaGN0TFJwL0xlc0RGTExTSW1JenpwL05rWmg4VkxtTFRUN053?=
 =?utf-8?B?OWQ3elU2UlFXWFAxbFlwSWpTbTJJTC9BRXUrWGNWMmhCRzQvS3lLYmRjdmZn?=
 =?utf-8?B?R3lrVUJDMlQ2dUpFQ2xMeFhGN0VTajM2NEdyeWM1andHbVB3ajJVMDZ3dGRD?=
 =?utf-8?B?NHdFS3NoYXh2aHR1bUk3YjZYTFBFZEl3elB5a001TE1GSTJTdlU1L0NIM0kw?=
 =?utf-8?B?Tkd6RGUyNUpWTitzRlloQjdwUzFxQTMwVEZxN0l0bzN6QkRkMkgwS3FoNHRn?=
 =?utf-8?B?TEs3RURtWTNiWGZHejlrV3kyRW5FNW85eUxHVDZZdXZ0bXBzN0JkS1dHSll3?=
 =?utf-8?B?eUNXb21HczIyWnYxdGFNN3QxeEwwZlBLektmZ01YcVlVSXFRVk9lU1ZWQ2Ro?=
 =?utf-8?B?N21GaERkNlFENlZnRGZXcUJFSjU5cFYwR0o1WFpNd0c4a0d0RUozbTNUNFUv?=
 =?utf-8?B?Qm0yRnhHUzdWMWRtYjkyTjJxdFVQSW54dVA3MXRzcTB6emFjeHF2d3dTU3Z3?=
 =?utf-8?B?NXR4SG1GT2pvdDN6dHgrSnoxUzZFcWY0UjAvSEpJNlkzVE5oQ052LzhwRk92?=
 =?utf-8?B?ZWFwQmoxTTJvZ2dHOEpvMVd1bjNiQmIwOWNpUmxGVzcxOUtjNDFINXZET1dr?=
 =?utf-8?B?T09Wb1JSdDRxYWdsZjBHV3hJemh0MGZ6MDB0TFJtbDNNSXB0dUx1cC9XWlln?=
 =?utf-8?B?QUIvNi9ZNHp4Yzl6dGJzclpheGZMT1NXalpNdlZRN0NORk9DV1pmTDQyMzJ5?=
 =?utf-8?B?bVFwSTFOaktha0Q4dFhjOGhoRTNJaHdVUkxDZjdwUys1eEJsendUMnUwZzhk?=
 =?utf-8?B?RTNFK3dEL2pGVnJ5WVIzQUZ0RVpGOE9PQzZLZmxVM3NJdDJ3SG1iMmRaSGdF?=
 =?utf-8?B?V1N5M1V6V2Uyc3d3Zjl5WnIyLzlrVldNV1djd1VnVmI3MVQycEFuZ3p5SHRL?=
 =?utf-8?B?K0dhRk91UlRrMEFJR0oyM2FYQjR2dnRrS1IxYmZ2Y0RyRURuem9JS3ZmbFRO?=
 =?utf-8?B?L2tWaWVaUUJJMDk2b2ZVVHdFNmZhRVI5eTA0RjFJakpKRmRCbGVYaERFcml3?=
 =?utf-8?B?YjNXSUdveXhUdXRCUkh2Ny9tRE9kV0hqK0lyY2Z2ZHlHUHBsTnZGU2ZzTGlW?=
 =?utf-8?B?MU92Q3NYU2h6OXpCeDBxcldhZFBSdThaSVIrSzV1RXgrUGtjRUVvWHpOMUU1?=
 =?utf-8?B?OFZZTUtOQ044dUM1N0RkdThqaVVUWlAybFdac0x1bWpibFlDWmxLQkhYWTg1?=
 =?utf-8?B?NENXanBNYTNWUFhKeWx2VER5VkxYTFVzZG5MY2RiOERqUjF4eExQVm5zVE1h?=
 =?utf-8?B?OG5VOHl0Q0hFTkx3cFRTZUhTM1dxZWlaS2VnMkpobktqaWt0V0VuenZCenJa?=
 =?utf-8?B?N1Zoa2hsa1FMUSt3cVJwNW42S2lEcWJqUmJXZDU4UmtTRkVXZUhXZUpiT2s5?=
 =?utf-8?B?ZjQ2enN0MzJ0STZkV3RWU3lDZTNFY2lwU1NUQlkrOGdDRjZ5anBOSklIM0Ez?=
 =?utf-8?Q?QYRcKMi7Ib4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0ZWaVJKZjBVS2pDVWpOaVNtcGJzbVM2bTc0TkFBN1pGYURjVmY3VDVsMUNR?=
 =?utf-8?B?S0k5OHZ2cUp2bUtRdXRKVzF3S0lZcm4vR2x6VDBLbjhaOXBMdi8ybC9MUmtt?=
 =?utf-8?B?eHBDdGRxa0lFdks4dktUQi9RNlBUVlNCb0p6alF2YXlFRis5MnBqamRPcHI0?=
 =?utf-8?B?dUU1QWVsR0FqdnlWZUkzV2ZCSCtrbDBlUTRheHd1RFJzVmlJNlN0T0Z2RGhu?=
 =?utf-8?B?K210d1FyMmRHTGM3bk5OZHdLNmhEa2Q0OHp3YkVQd001d1F6N2tlMXI5aDJt?=
 =?utf-8?B?dWJaVVNUTG8vL2lOL1hremt1VHNNTE15OXAwL3Z5S0Y5d0xEOFNHQnUzYXZu?=
 =?utf-8?B?NHBWai90ZW8zOTVJa1FSN0l4NnF6YmxMZ25zbHRjMllacG5mb2p3ZEhtOWtH?=
 =?utf-8?B?NjlRcVlPUzdrNHdCc0lXQTVXU05YQ1FvNmhnZEdzZmgyRDNxblFDZ2hXOHA0?=
 =?utf-8?B?RDBTOCtMOGNWc2RCT0E3UlpkZExUUjBxd0prcUV3QnVNVmxuRXdnQ3lTQUVs?=
 =?utf-8?B?Z000elV6ZEJxTVcrUytreUJyTUxGUS9GekhhbStlTnRmbVNkaUdGM1Azalpo?=
 =?utf-8?B?UGU3emhnTFdQdzFmNmFEV2xIODlVVkgrZFRycU1rQU5hK3UyNDBzQTdxOFVq?=
 =?utf-8?B?RkpDbXhYbDBQY2I0UkNUeFdmNkl3MER0VjhqL1haSVVCK1hYVkcxU2xKUzN1?=
 =?utf-8?B?YUhYL3pHNjFyNzBEcjl1Z2lvSkh6cWVFS0dYaXpneTl5SzNVQllrcDc1ckNM?=
 =?utf-8?B?OFMvZnpDZEJRb1dPYm8ya2ZKenI4UiszVXN2VTltOVZ3OE94VzZLektKYVk2?=
 =?utf-8?B?VWJkOU9hdDVQK1FjUGM4RlhjVjJBaElpc2RQMG5wV0VqdnF5N0dhMmdwZmJN?=
 =?utf-8?B?UjRPbG0yd0hlTnBqUkcxNGswQkQzUE9POVZmZENXVUJMZlBpOVZHZXZHQ1Av?=
 =?utf-8?B?aEx1WWFwSlpGazVKcS9LaWxyeEJFWEtnekRUc2tVWWVib24wbWVaczd5Z2FV?=
 =?utf-8?B?NHdSbEFTVUFSd05uU3RTOTY4bkw4azFMbWVvd0NNQzAzWEI4dDIwdGxLbmt0?=
 =?utf-8?B?Y1BDRjNDT2s2NFZ0T1lvVVR4OEFvWXl5dll5ekZUdmplMm04enVvNC9EUmhn?=
 =?utf-8?B?RU1xVlhrKzJ4dSs3UCt1WUlPbVhIVzJib096eXZIeXQyNXlidmFHV08zUVZu?=
 =?utf-8?B?L0ZWNHhjZ1BiNWNFTGpyM2V1aGlqODVLSThjVUY4MVFYNkduaUhTYTJPZUdN?=
 =?utf-8?B?aCtGOWYvbVhVbTV0RHRJYW5hcUt2K2IwcHJKOFhDbnBpSnRwemV0MDJkNEtR?=
 =?utf-8?B?TG0vcURmSVU4dFJBaUpmd1BIWHN0L1pMQ3JBalpuMnBCRmdSbmFqK1VkUS9X?=
 =?utf-8?B?MkhhV1VZdWJhMnVhZzJNN2lhVXNEVWJDVVZKUjFUaGVEaTVyQk1OcFduU1hP?=
 =?utf-8?B?RGR6bndkOWdEckcrdXdMdy9NSzRybTVWaHU2Y2pFOFVnZlozY2hKTkJ3bGNC?=
 =?utf-8?B?V2lEN2NrcjArcGlLWnYzbFVrak92M2FGSnhCTUhCbDZkcXlVcFk2U2NhUzBa?=
 =?utf-8?B?Wi9STFIvZmpGd1pLcWl1c0FoalhVbjVOL2RtZ0tobHo5ZStXWkd2cDMrNXc3?=
 =?utf-8?B?STNtamF4bXlaamJsaGd5L3M0aytha0JYNzRHMlJSY09QLyt5eWtMRTFKMEFV?=
 =?utf-8?B?UUVuZStLQXdrNkZzdGlZb3FralY5N0hqSklHL0Qwcm5yRmFCdHVqNEE1N1lO?=
 =?utf-8?B?RitMYkJkaVZoYURSZnNURElxY1FXcGZWV1RZTHdraktGbmtIbXlrQzhnTk9o?=
 =?utf-8?B?YzZRZTlISU9PL2sxT1JGR0VVUXhBNHlnQnUxSVdFbUFydm1NdzZIR3ByRlVV?=
 =?utf-8?B?djE0QTNCclN5NHlBNjBDWWt0V0kxbDlIN2NHeEs0T1F6a3Y5QjNMdVcra3Nu?=
 =?utf-8?B?RXRmd2J1MVVQbklxaDMxSmJ1NjRuVTVkUzVMTGtiSlpnTTFnY3hUTGRtZkFI?=
 =?utf-8?B?TGx2bURiLzVjNElGek1UaGE1cTlEVmpXUGVwTm1XQTB0TEpyZVI1ajV1ZkZx?=
 =?utf-8?B?cjExM3ZnY0lIb0U5d3k4cVhjZEZGYVplNTVlNndEWmEwcEdpYVdvd2hpZGJO?=
 =?utf-8?B?SHFJWGxQT2FUS1QxejdzRE9kU3VGUURjOEgzUS9TK3JBVmhaYWt4R3RTYnhV?=
 =?utf-8?B?OUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oGeH/b86B/TPpfw1CcmqlHu5gMZoyi+sgPOcEYxcUHeYLXtAkibD3y84RjMToz/9jYkzmV2f01i0Qffz+JlfAXWHXJZnc78P27fujnMuR4/K94C5H2Y5kp9w2dmLeApj/cncG9O+1Rhtb8/yaV7BEr+O828h5jW9dJ9xCypYLwSQvMhMAMNuw3WYy6aO9PHym79s3fi1ojFFLaWZPrYb8lh76RMxjncTuk0ctRGyfr+yOCtmyern6EyKP0pYlzQ2jK8+Ypq+/DShSCvv9G3gJ67vevD9oaBKeqDZHNLzR7ObFNTjAafjlhO+KuBEcSqIJwDKnWSysCMlmObl7zS50KHzWQlkhswx600ci+XjsVZ012lFlF8gFS+fYxY4E7kBaCOpzF2rLITf0ESsKWaUsupyXn8o9RS+NEm42i7hZdtUF7N18pUzDWnJbqLOoF2okBP7DgCk6VJ8ek83sSZ8MVkW9SZOUGe8JEg+ZEenj25X5jlRCU80oU3P5wKOLvegHHJroW3hDnPPPx3C4VIL5YxwKKbETwSpWOS6JlpgAD8DD8ZJqk9vX1QGTtH3XiqKcR7XNc6+No79gNi7GBi4ILBplcqTumn6OjF53HZEeP0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d94e13e-5db8-48f7-decb-08dd841034f5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2025 15:45:30.1374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dkPQP+ge3Lc5lTH+xHKYJsX9ZSprzYjvl/Ya71xQXDWkypqXtIz1OauGQXQKMVS6sKJRB/wE2HHlUOzKDSHBBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0BB87A13E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-25_04,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2504250111
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI1MDExMSBTYWx0ZWRfX6DDFd2bTkKHd DZ90K6onJ+7s+ANI7WDjiwvIJDid1wBp8KOOyZy17QDvBI6b2P0smFm/ZwutQeXfhdAz5QpingM RjWCQVsJYsawo6ja8xiEf2vZHMxjhABYWsm5cHEQCLdFKyP8mTR660FLqRsJ94SUEIKQDE+C7sZ
 lkid40kcqg3Zc/TFMonxFTyzgcjSGKje/y2d9xopEfeGP6ECqJth7uLqKoRGeQAWK7MTpoezbV0 BgOiBMNIcrL3R9E209e6V9jAuFkFjVCCRf7D8eRGW1SqqUFXGJY5t8x4e5Lp42YrNjhB8cTlGJG bUFi6rXqTpl349qndfbODHHF+Q3kpXx/uXNPy5jHqSOCgkK3AL3uUDqS7XfN0hAIlmAhWi4NTGL 0R5tzw2N
X-Proofpoint-ORIG-GUID: FWq8D9AOiN9Uw1-RoF0YQ8HE3G1nYcC8
X-Proofpoint-GUID: FWq8D9AOiN9Uw1-RoF0YQ8HE3G1nYcC8

Hi Zhao,

On 4/25/25 1:28 AM, Zhao Liu wrote:
> On Wed, Apr 16, 2025 at 02:52:26PM -0700, Dongli Zhang wrote:
>> Date: Wed, 16 Apr 2025 14:52:26 -0700
>> From: Dongli Zhang <dongli.zhang@oracle.com>
>> Subject: [PATCH v4 01/11] [DO NOT MERGE] i386/cpu: Consolidate the helper
>>  to get Host's vendor
>> X-Mailer: git-send-email 2.43.5
>>
>> From: Zhao Liu <zhao1.liu@intel.com>
>>
>> Extend host_cpu_vendor_fms() to help more cases to get Host's vendor
>> information.
>>
>> Cc: Dongli Zhang <dongli.zhang@oracle.com>
>> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
>> ---
>> This patch is already queued by Paolo.
>> https://urldefense.com/v3/__https://lore.kernel.org/all/20250410075619.145792-1-zhao1.liu@intel.com/__;!!ACWV5N9M2RV99hQ!L2uxw6itl1xu4V_vdRWxQMeVR4PWVX0zvXndOqPHqmnCvnpPkyNamRGVSAil03m_ojnjPCMgUMEG0jBDtLNl$ 
>> I don't need to add my Signed-off-by.
>>
>>  target/i386/host-cpu.c        | 10 ++++++----
>>  target/i386/kvm/vmsr_energy.c |  3 +--
>>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> Thanks. It has been merged as commit ae39acef49e2916 now.
> 

Since all patches are reviewed, I am going to re-send on top of the most recent
mainline QEMU with all Reviewed-by.

Thank you very much!

Dongli Zhang

