Return-Path: <kvm+bounces-30066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F1119B6A2F
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 18:07:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A0CE1C2428C
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 17:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D0E218D60;
	Wed, 30 Oct 2024 16:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ffeIMoPn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sVVWZ7MH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86A5217455
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730307454; cv=fail; b=HEX53bWQhly2UxjC5LDyJ6rVlG2YMr4VP2wKPTBgIinC13DKvmd+LaVbt3/rDjxrlXErofniGkBzDgwQ8SGdJJM+pGqPAS3tJXSjMBR/MoTH5HrykZWPayFtvZkOb7jgaZ2ZnqKeZ8ZufZkqhpC4w7NoaQjcBeKVKR6ZFQwjuJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730307454; c=relaxed/simple;
	bh=rhM6Xw79wloSAZYyUvqyB0S7heuzcQ/WotXsK2qPGCA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MTHfZB0jqSc9IbiNpB8XQRSsSAUPkiLJQJUBvMRtPcmhds6oPwOPHZuLuKZ6IOl9r5i2zWBLzA8Ev1Ssl9HMSaut5F1T7CJWres2ZIlgGA122qy3g7gzYht5EX/Tu/uUL0XQJul1ffzi2cSqJuvNOaYGHBMeA8SwVxA6Dmh2VYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ffeIMoPn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sVVWZ7MH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49UGXd70029477;
	Wed, 30 Oct 2024 16:57:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ugTHPAK4EHBzPfyauEXVJN4Zm5H8o19a9MY0Qm4xwCw=; b=
	ffeIMoPn29InixDmfrdp1u4U9jwOx8QcMb13r4RNvDRGBeMEJ/Uyk9zE4pLbUBI7
	zNEebtcEXZLTyx8kIHUMrLwCsrnz1djlCDqzjO8nlqUQyUo49jNREmOY9kGMVTTv
	RERqzbDsNPwMlOY87iyB/Aj+GfB7zdFa5PfafHl1WC568Nc9rBlg4lNlwZeh4Whx
	dFgIA4c8dnNyoe6MauR9XJ8Bmj3MYnegc/yg+OTdTsIiSOGu6XuBTu1OyVnlh861
	i/6cf1cRSrgxZ+dstpgLzl1IW4qQXuoPNQ7AmIvcXmlO5rBkHR73oLi2j1ub5ztq
	I+Usl1oAgEB99ItbeCwvKQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc90h0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 16:57:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49UFgsGf011744;
	Wed, 30 Oct 2024 16:57:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnaeagrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 16:57:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xlSTZZ7ft4RZB2D6YLzbB48MCBkTMA3yLZidEA3eiRsq/agnjRrRpAn4Juqn6EOKhBMdj/iJzPe10nGPiuN/VgfWsD92l/6tsAjUtKSH945UTL0dNThbrXtawBsvdOrKtk6McXajQcwsxqbQwTb9H55iCBI2wUYXGseIwxMQRXmpNLMghM2Tvo2USs9fReO33yX3Z0iHb5rt3v0arNJiemT6M7fFQVp0R1MfmlYr5q+kO9g/IKyv8qQRJsecKIsyy7kpP6WIdrrPWafgQDuh6OiWucg2WaY1LTo6AWnutyIZhI9NlmZv1L3DNVHmM+UCgxIzF+372sZl+LZX655YRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugTHPAK4EHBzPfyauEXVJN4Zm5H8o19a9MY0Qm4xwCw=;
 b=is0pyKIDlFyK5RHhc/gEnzkIc/b7vp4HgaKh08LKthIDQ1u1vUFTIAC8T+CiMpFO+XklPntH9w7KWwph7rjE6ljTc1nf9Vattek0SrzOKLB9d9tT/UBGRO11j2IbxIPy20LLY/Rs2yENk2nF71bkEVM6g/8qgbBqjXP7w7H3EyPw9o18IL7ZGCYfgRMXZeygeOUQYBdc1GIJvmX87FcW/TK78u737V5bpxVu733LsYmfjdVf8PLDXTdRWk4L79F1Ac+tZLik8CnXv9p3NWYoOstSmwOQwuQzvmNDyD2L8g5ZXWTHk+r7iOolTOmmfIhN2rPp8Qd2JaJJtd6u3O2DFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugTHPAK4EHBzPfyauEXVJN4Zm5H8o19a9MY0Qm4xwCw=;
 b=sVVWZ7MHP2XLnYrWilp/aKVOn9wYV+9LhKFRwDMOmNf2fgPhx8RHZybbmMwCdOQiojdJRwmfJRg5tbG10CLlj9MKGo19dY2VO1R0+3bt4MudByrfptawZLc9c7jO2knNG8BKHH94OEH25Aig+Nb51DBRux+oyrgtRZXEyGAIQPU=
Received: from PH0PR10MB5893.namprd10.prod.outlook.com (2603:10b6:510:149::11)
 by BL3PR10MB6236.namprd10.prod.outlook.com (2603:10b6:208:38f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Wed, 30 Oct
 2024 16:56:54 +0000
Received: from PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53]) by PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53%5]) with mapi id 15.20.8114.015; Wed, 30 Oct 2024
 16:56:54 +0000
Message-ID: <59d76989-3d7f-449d-8339-2edd31270b08@oracle.com>
Date: Wed, 30 Oct 2024 16:56:46 +0000
Subject: Re: [PATCH v6 00/18] IOMMUFD Dirty Tracking
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Kevin Tian <kevin.tian@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Shameer Kolothum <shamiali2008@gmail.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
 <CABQgh9HRq8oXgm04XhY2ajvGrg-jJO_KirXvfZxRsn9WiZi7Dg@mail.gmail.com>
 <20241030153619.GG6956@nvidia.com>
 <9a2394ca-fd8d-471b-8131-55f241e9cf26@oracle.com>
 <8401eb12c4a54826ba44e099a0ec67a9@huawei.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <8401eb12c4a54826ba44e099a0ec67a9@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P302CA0012.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::19) To PH0PR10MB5893.namprd10.prod.outlook.com
 (2603:10b6:510:149::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5893:EE_|BL3PR10MB6236:EE_
X-MS-Office365-Filtering-Correlation-Id: e76b1479-21b0-4024-fd6e-08dcf903db93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eTBoTUJYVTc4RnNpUGM1aVNZdHZCUENDeG1UaTJZYklFRk1OM1U5ZW9KSE9D?=
 =?utf-8?B?WE5TUERLZHBLQ3J3Vkw2ZzhEUXZBS1FJdFdDQmdVZ1pRZjJjeUt4dElsdCtU?=
 =?utf-8?B?VW14NUNXZmdicXZRaE9qUWJONkxEejdXcHVwZ3hmaWl0R0h5MkZtMTRyZUZr?=
 =?utf-8?B?WHpaL0lodFNMZ1AwbjBiNEY0SUVNZy93QmtpYnM4U0lsRHRhMXVLRkVnTDY3?=
 =?utf-8?B?b0lBK2JLejRzY1lBbENxRWRPMzY2cmRMdE1SSkRLSCt0Z0Y2eG1YTk4wUjg3?=
 =?utf-8?B?ZUlKOEZWYzVxY3I3Z2RuenhiYU8wOGZIbUJxU3hxN1VqOU5NVzBqNzUyTm1Z?=
 =?utf-8?B?ZDZHdkJWYzI2d1BMZnpMT1hySnJiTjg2S0ErdnVRdnM4bStHcE54Y3RmcHYx?=
 =?utf-8?B?NC8yNGN2a2pTL2ZlTmlsbnY5VzBSRnNsWXJhV0tkUTV4eXdNZDUyQlRTQk45?=
 =?utf-8?B?SEUzMUMrNDluSHlDbFJjcENkZzhuTGpsWDNZUjdsM0lOdlF5bk9nb1F0TjF2?=
 =?utf-8?B?ZEJETldZdXNsYmxINEYzcnJKV2tPbmplblY3L2VnaFRIYVJnZFlWME8rcitx?=
 =?utf-8?B?YTdkUXJqVWJOQnhuQTAwcmFPMG5JSEpTYmp2UWo2d08zb0tURlVTTGtPMy9R?=
 =?utf-8?B?bHBndlNXUi8vaHgyWXBxcDMyQ3gwV05YVFR1OGx0dXlhVUFOVXgzSnRoZlNH?=
 =?utf-8?B?TlI2dmFrMlF6ZkRoZzNqclN3WVZPOE9qc2FONkJhNk93U2twckREOFNzYVEr?=
 =?utf-8?B?NjJuM3ZxeGJvem9pQjdsZ3dNZEE3UkE1QjQzK2tFM1R0SVVJVDUyMDBYb3Nu?=
 =?utf-8?B?RzcveVZWcFRYbms3dnRnRkVWQWdndGFPSGZWUjZKaG1pUE55RXNrQmFmSWcw?=
 =?utf-8?B?Uk8xNGlFb0VXTGgzK3VreTVkYVhUbXY3S1VjeUM4eDFYQ1QybGorb0l6cjFB?=
 =?utf-8?B?RURuNy83VkUrbkRvN0h2M1ZRNTdsazlmRHdEOUxBdWNCcHVDcmxzRlVHRW0r?=
 =?utf-8?B?Z2xpQjZoQUxJWVJkZURGcUkvcm5lZkdzNlYzVTJ2dml4dC9tTXUrR3pmc3F0?=
 =?utf-8?B?YVJtcWl2ZUo0QzIxQ1VWZ1JPdGlVd01reDVUUE1oN3NFeklaSTJFVFR0M0Uy?=
 =?utf-8?B?TnRDQWdPLzNRUDdpUGhUVWp4bXpmbm5ZVHVDZC9JTUpCTVl4RFFhUkUvUTRB?=
 =?utf-8?B?UlloZTRvd0MzN1hYUHdJYWVzNXMxOExmS3U5MmpKdSt4VVFZQ2txb1oxVXBm?=
 =?utf-8?B?Z3FtKzNyekM4Z25Cai9Pb3d0TXlqWnorYmpFNTFkZVB4UldVNUJ6WTI5UFNM?=
 =?utf-8?B?bU1ReGtuNVVXa3F4c3NmMzA2dm13Nmk0WWhNSXIzaUdmSEJpNlo3c1VGNDhO?=
 =?utf-8?B?c2JBWGxobndxZ0o0dy9YK0RoenpvcmtWaFRxdXQxRnZ3WEpkbmZwYUVYbGhY?=
 =?utf-8?B?bjRvQkg2WE8zclk3Zk1iN2s3SjZick1rSDVZQ1hSWHBLYXZxSkJmRFB6dWQ2?=
 =?utf-8?B?K05NSnoySWdoY25hZjdmM09GVE5TSFR4bUgyS0grU2dQWUlkVjNkQ3RvaVo3?=
 =?utf-8?B?YnU4aUlYNTkvREF4MndRVkhob3ZpNGFRS3NqaGxlZVhweVZybytSNS94T2VU?=
 =?utf-8?B?VEhKQkpZNklyYWZTdVZnTXUxSnFhQlpKeHhCRWwwaWxGQStJR1VZcjBsQ3BG?=
 =?utf-8?B?bHR6RzlSZWFSYUNRLzdlVzZJbWhIT2tnRmphMTZFK3hqYWtzbG82T0hBM09r?=
 =?utf-8?Q?lUCkZWKKetiQXyeGet/HUU8GzMtc7u1QccCsFje?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5893.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajdQSVA0N3hnaklXWjBIOWlGQTByRmdOck5qLzMxSVFRRlZ1endqWGpsL2Rs?=
 =?utf-8?B?LzhnWWROKzhSdGhiK2VYVGpHdE1oQ3k1VklMcnRqNjcyZnhMa1RoYmQyR09M?=
 =?utf-8?B?RUZZYitGSkNKRE9YMGFDVUl2QXZJMDZwZ1FTUk5PNU5DL25PMWtBVlRmWW5z?=
 =?utf-8?B?UnpZWldGYkxxUDdmS3RkVGkrY2NUOXVZakNKSmhIOStTNnM0YVBWRmlGdjlK?=
 =?utf-8?B?R2E4OVIzam50c25ldlVaOGxJMWZGcE5jMGxVYmM5dTM1R0V6cTBiT1ZrRHU4?=
 =?utf-8?B?SHhuTzlWZTZFcTNqNVJXRGNQWWYwbmZ3dDlGUkNKTjFBcjVFOFhpZVBkV0Y4?=
 =?utf-8?B?Z0xNM0p4WHBCK1J1Mm82dXlQMDR5NFB2eWN5VERtNDRtUmZUSVJBM0lIWDdr?=
 =?utf-8?B?Z1hVVW5ValE1SWwyaW56WTM1UnExcFFib2FQVktMQXp0YTRPdndiNVJWYW1W?=
 =?utf-8?B?U3hsYldsL1VJT3JSTWIrNTZXTFZ6eThKTkNVQmZleFA2SkY3MERBTVFFbHQw?=
 =?utf-8?B?VHRwU0JITnZpV3lXNnQ2SWJHQzlsci9YVGVGaUQzVDIrazNhK1ZTbytoOTlj?=
 =?utf-8?B?a3NLUE53a0gxSUZiazdFY2Y5R3AzMFFEYlMxOXlNQjRXUWI4dzZVa010TVFn?=
 =?utf-8?B?T0N4QkdPUzJ6cTFlNnNUSFpENmVSbUhYa241UXRjcGZZQjdwWnJqbStMcUx3?=
 =?utf-8?B?Qk4rcWlFSm1oSFNwQ25tUkV3N285YXZ4UjAyejllNXorYjVkUEVBREZzbVE5?=
 =?utf-8?B?NnpJb1ZIeWF5WFB3WE4xNEFuSUlKSzZ0b2Njd25VRFRIQk54ZWN3N3VUZUZO?=
 =?utf-8?B?ZDY3aWwyM05idGtMbCthaHdLeGRRUTZWNERjMDBNbnk2UU4vaGFlN01ZRUd5?=
 =?utf-8?B?aURTYlFnZHRjOFNqekkrUGVEVFA5NmlvU1FnTzdDQWJFSDVzK1kzeVBkT1hN?=
 =?utf-8?B?REdJR29iWVBuRnZTdkhVVGNhLzd0b1cxYk5rbXNlT3pOMloxY1A1WUFOWVp0?=
 =?utf-8?B?SUNHYWVSMitCaHRiT0lYZ25iSmpiRjUzMU9GVGJ6NXVuSEZoRjhrZERJZ1hs?=
 =?utf-8?B?RjR4akJlQnMzbkRxdWNlc1NGbk5USG9DR0RvQ1d3QUdhWUN3azlBK0plRUlM?=
 =?utf-8?B?OWxnNlRGbU9sRkNYd29GYU40TktEMFBicHRIb2NYNG5DdHRsVHdwa3BTdWRi?=
 =?utf-8?B?bys0RnJNLzVPdlVYM1ZYMkU5b1JXVVR3aEdNOUdMa2x2eVpQSTZ5TDhQcEtM?=
 =?utf-8?B?Nk9aK2V1UVA0d1JjMUpWWDRlbDZadTNPdzU3UTNNT2I5S1lkb01Mb2hWYkRo?=
 =?utf-8?B?YTk0dlY3SnN4elJ4c2RUVm1lOEIwR0ZIUTJldlNhOGF5L1VGQUtpZFJ6KzNn?=
 =?utf-8?B?Q1RWRG5HQ3NEc3ljNDhiUFBycmJwRzAyU1ZueHNWT2JWT3RWRTdDZlAyeXda?=
 =?utf-8?B?RnZEY3hKMEpRaGdQeE0rdG9EZjV0MzVBemFvUGVzWU9LSkx2SmFWeXlWTUp4?=
 =?utf-8?B?UEVTR3Z3ck8yMUhZN1NYa1h3dXBSdnFWTlVkSCtIWlIyb2lJNEVtcEd6bWVZ?=
 =?utf-8?B?b2lLUzI2ZnpMRWF6NWl3Yk82dTZDRjhsc1FFa0RReFQ4blVPdk9uUnY2WWxQ?=
 =?utf-8?B?YUIwWW4yVmRWMXl6L2E5V0pnMDQ1L1pJdW5RRjF2TmRpRDlvcTR1bDJuU1VB?=
 =?utf-8?B?SUFiZldVY3F3K1BmQWtKVDd1VzdkQlI1T2NtK3hrS0Znd25obkQxMmhJS0RL?=
 =?utf-8?B?VWphNkcvZW1CMk5kSk5ldUs1ejJKOWo5cDZObmNJOTF1MlRtRGE1dHNsVC9C?=
 =?utf-8?B?dkYxNHhBM2NSZGF4dGVUUkkzellHZjljcVlhK1ViRlhLWkR3ZUVhYThUeURG?=
 =?utf-8?B?VTVhVjNkWXpsMWE4eVlvRWxMMXBPbGtTMk5nME5EUTlDbmI0am15YUlDY0p0?=
 =?utf-8?B?TFlhSFlVL2tRZ2JjYXZjeTh6MW1wRjNOQmQybzF5SWJZVWw3ZFJ0bHpRbkQ0?=
 =?utf-8?B?cUIyMUNtZFVSVU1tbVVSTUFISXlMdkFCTUhnSjBYSVFWc0YxSXNWK3JVbUZo?=
 =?utf-8?B?bjNCWDJBMFFlYk1LWEdycFpuQkZ6RUVpZDBiNW12bElyNHlWTzFGSjNtNjBK?=
 =?utf-8?B?ak1iaHBLVWhldWNSQncxc2FlRlVSdCtad0NDOHZNcWYxeGpUcDZjUWtBZmNq?=
 =?utf-8?B?NkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fWZ69H0HH/p4FrheWEIUmqDM0wJD8DDUo2SJGYx+F4fRei9618VofMRZDppMZ0CN7lzXYrIFSfyRhXdLn17kYwkE10pxkUVaw8JvuGbH4xoQiqiMkl3BocoP/BiYE8WZx0ZGNNvX7XmqUbScCiFX2fyTd/jkOa0ob9TowJk7dEXV8xFJiuLeNjpyWe9CZmEEI9PeqFhsbzzFHkLmSGGMzxYXa9jayLIUJDiCKL/JqPw7svNLGP0Ks/QLTk2ULlccCL0EWTgqW24HReI0jxRrd0Ekkr+HQ0u+M5CGEqqeCyBK9+hOgeRNcB5maFX1ntJCQXSZDuO6Ixve7rVkOz8T9qHz+y1iYB6OMOuUCLjFMO+b/bajEow88OKvdnspmcJnlq5NroHCfKroBvoAD8OO+fBoMzxIBsPSrTesavGDLgyU8BOoKAxA+6cBtuCa2bq/9DQhDtgayiNBguxswMKZPhGvfZ8k65WVNoMTtk28gMjX2h66r0KY6yWemgWTWcc7F95cDd69fYNOamnIUuBKIFp6LySsVurbRnXmPNVHoYU1Nto6IT010RrwDPGKErlqkhxLdsbaS+3ZmScmnqHeRf78BVrFUvvgjH6aAW2nCFs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e76b1479-21b0-4024-fd6e-08dcf903db93
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5893.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 16:56:54.6487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NMCeO4QNIwnENd+JidqcRc3ts7KcbZpcQrmzp4JjOihEM736hR2ijDsu90wBUtSQVMn4SR3JrSrHcC1u6mqlk7Rhde0qqlQsGJta+dx/cL8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6236
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-30_14,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410300133
X-Proofpoint-GUID: lQ3Wxz39DdXvea02ldpuEfvucjUf8gjM
X-Proofpoint-ORIG-GUID: lQ3Wxz39DdXvea02ldpuEfvucjUf8gjM

On 30/10/2024 15:57, Shameerali Kolothum Thodi wrote:
>> On 30/10/2024 15:36, Jason Gunthorpe wrote:
>>> On Wed, Oct 30, 2024 at 11:15:02PM +0800, Zhangfei Gao wrote:
>>>> hw/vfio/migration.c
>>>>     if (vfio_viommu_preset(vbasedev)) {
>>>>         error_setg(&err, "%s: Migration is currently not supported "
>>>>                    "with vIOMMU enabled", vbasedev->name);
>>>>         goto add_blocker;
>>>>     }
>>>
>>> The viommu driver itself does not support live migration, it would
>>> need to preserve all the guest configuration and bring it all back. It
>>> doesn't know how to do that yet.
>>
>> It's more of vfio code, not quite related to actually hw vIOMMU.
>>
>> There's some vfio migration + vIOMMU support patches I have to follow up
>> (v5)
> 
> Are you referring this series here?
> https://lore.kernel.org/qemu-devel/d5d30f58-31f0-1103-6956-377de34a790c@redhat.com/T/
> 
> Is that enabling migration only if Guest doesn’t do any DMA translations? 
> 
No, it does it when guest is using the sw vIOMMU too. to be clear: this has
nothing to do with nested IOMMU or if the guest is doing (emulated) dirty tracking.

When the guest doesn't do DMA translation is this patch:

https://lore.kernel.org/qemu-devel/20230908120521.50903-1-joao.m.martins@oracle.com/

>> but unexpected set backs unrelated to work delay some of my plans for
>> qemu 9.2.
>> I expect to resume in few weeks. I can point you to a branch while I don't
>> submit (provided soft-freeze is coming)
> 
> Also, I think we need a mechanism for page fault handling in case Guest handles 
> the stage 1 plus dirty tracking for stage 1 as well.
> 

I have emulation for x86 iommus to dirty tracking, but that is unrelated to L0
live migration -- It's more for testing in the lack of recent hardware. Even
emulated page fault handling doesn't affect this unless you have to re-map/map
new IOVA, which would also be covered in this series I think.

Unless you are talking about physical IOPF that qemu may terminate, though we
don't have such support in Qemu atm.

