Return-Path: <kvm+bounces-39916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E24C4A4CB31
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 19:46:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60CC23AC2E0
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8DBA230BCC;
	Mon,  3 Mar 2025 18:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TEuOjx70";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I1YSJ8X9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8621EFFB7
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 18:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741027553; cv=fail; b=Rzlqp5N8tq2zgMx5mFRRUKE575QG9icjVX8F30rCe67aR7qafs16kUOY2hgS2HR+yWCRZhDEMHPeVM1OdnwL9tkZUroHY0NwPi4ZyDUiMdxTB6ZtlxBkW1oGrtbmGPtv7nXbZLhHrSfAn1HOnCPo+Sneni0Dmtt+N7qeA1QYfNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741027553; c=relaxed/simple;
	bh=FUTftqplnUTgql+/aOBPY/BrV9F1oQeol68UFvmQqQI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YugYFh2KoIc7JJph/gStRG3HICaqLQDkY0jtWC97xxXme1Pg7/n8GbmVemjBRGvErPnU+SXpO14GR15bDMt9QEXddS+YYzxPBVzRWKNhNoResESTsnOUWFvzgg1eX0EHB36o96wUz1I4OW24aolcVsOasky2woL3iwC9xhJ9pQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TEuOjx70; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I1YSJ8X9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 523IfeAu012052;
	Mon, 3 Mar 2025 18:45:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=pL/Yqec7K7NVxswFD+Wfad85NGWyIilob2iDhg0aNOc=; b=
	TEuOjx70O1ChVHainWFSimjni+sBwxyqsXMWmKnNK43YBBj/um2TPBbFbdRx8kgV
	i9LKl2dZh5r2AUR9pc0bkBHvdr4fVPGpSacedhCfAyuUetXsWZW+qAvQg6Xm3r+K
	zLjaPJoHkvAKOPmBtlL/qG+AVuS1HMehAmzm+c+38zzjjKZTsRYF2JhyB8Jl73V9
	lYMtmUylCl5ncPfDVynfVa/BOYXrlgWrYNW6CtWYZogZQup97yKtmsQR9hHlUk6z
	Lq27AEhFJCsb75NQo0WsRW9H2bUEQwqMLUW6kWFJuUKvWRMiQUiNRi95q4n2osqG
	TG1OOnboCMukxhZbxODMTA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u9qbcua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Mar 2025 18:45:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 523I5bYB015695;
	Mon, 3 Mar 2025 18:45:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2043.outbound.protection.outlook.com [104.47.58.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp94m6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Mar 2025 18:45:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A41GYHiumTCdGJxwa7wiYmo4k3FelJLresdAnAqJg8ZFBSsg2fDhMcn/PuWEY37YtLCZI0zYzYv8tmk/5rWyoLKqH3iwCvvy3BsaDWKeFWFbL8+IEEqfbeUoiY+ZUaxTbVquZnDNRLGWVcdilZIWnZzIXQgQZdbO6yU8b625Bf11vYPk3XXfsXW8rfLLoe+3mhTgS58iTGtj9dQSOupasQe55Jdsfo+8TBPGCkIcFfnjwA4CzTtBVJkpsmH6AVwITGEVOH+srnVMgy6P9R8ZHgg4G9umrc5lF9l4bXbZhHO7K8ur7cVgJMJ8MmsePB9X4J/hptGBR1OyiXAEWY0H7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pL/Yqec7K7NVxswFD+Wfad85NGWyIilob2iDhg0aNOc=;
 b=vN3128laWv6ZW0qyJ3robQobXawCq9q9i3VNAi6Bfb4qoI1c4r1MLSW1PEDi4WEMMt13FJ5t9BdbGlv4sd4HDFLu6ZaEJOW8dloiQByGaC++uYfkHs3RGwMGnijhU+THwFFpnM2ie3ZaZPkfGcFGM9/MNtGYzMt2d1pE0Fnv9SfuhQk/ws2aFYMZew0p1mfxP+r4QkYRNfggp9P1MnRmqYK67CsJSn9Zk4PAunLvRrwel9kFpvFziDTdORQwDa7a9Jii5Hne8ODxUXKOupwnru2ZEK6ZlRahjR1cu7T/XJoXKUQ7+EaTgSe2AiTmeZb+FDVbrW/ZUhDYklIYGeqadA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pL/Yqec7K7NVxswFD+Wfad85NGWyIilob2iDhg0aNOc=;
 b=I1YSJ8X9EALSjhf2CtLmtNpY7c30YnbPjktarJNVSUnGakhIh9fqDD/H3m+AdXg5rbVnaLd8unpkA+/jZRsopB21HRvOdzS3Vm1DxdT3H3v7KzZZf3E6QvqjSXm92KoQ86QYhShetwl58gy+gyE8Vkhn1Jy0XhFj5GadSm96f/E=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by CO1PR10MB4708.namprd10.prod.outlook.com
 (2603:10b6:303:90::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Mon, 3 Mar
 2025 18:45:11 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 18:45:11 +0000
Message-ID: <0dcdd9c1-35e5-4cee-be0b-59113e01e73c@oracle.com>
Date: Mon, 3 Mar 2025 10:45:08 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/10] target/i386: disable PERFCORE when "-pmu" is
 configured
To: Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-3-dongli.zhang@oracle.com>
 <99810e4f-f41d-4905-ae6d-1080b14fc8fd@intel.com>
Content-Language: en-US
From: dongli.zhang@oracle.com
In-Reply-To: <99810e4f-f41d-4905-ae6d-1080b14fc8fd@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::31) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|CO1PR10MB4708:EE_
X-MS-Office365-Filtering-Correlation-Id: a7d810b5-9ee8-484d-bb92-08dd5a83872b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWVNajlSZTdSVzJ2WHdib0s1cmZpNHV6Q0tSWXhxMnZaVHBsMXN1cmhEaFVW?=
 =?utf-8?B?YSt0d1ZSeG54V2J5Tm41TVNuT3NmSFBUZDNMMWpYYmJ5S3NlRUE0NE5pcGpS?=
 =?utf-8?B?aWhFMlVIRlZOOS9LV1EzSldPcDZmanM1NDNyQ1ZpK1VQeVNTSHVCN0RhOVpJ?=
 =?utf-8?B?dHUvNVdJem1IdnR6ODF1aFZrcGJBQjd5VzhMZHFFdTFhZTYvREovMmJjTFdq?=
 =?utf-8?B?RzdndG16UzhscnVNNEFtT1hxNWRPaWhBNCtXcjZiaWpQUkduMTEwQ0ZBWEsw?=
 =?utf-8?B?clp1SUtDRVo0aGRFdVAzQlkvNUQ2czZkOFJQakl3bDlSQm0yWFVaWi9PNGV0?=
 =?utf-8?B?TDRvRzI3ckpURWlxeDFkK1RmdWk5eDB4OElUcFcvVEVqNk1QVUtJV3kwN2gr?=
 =?utf-8?B?QlcwRnEvbVI2cEtNdEZvbS90WVhGOFEvV0M2elpSZlEwVWVkQUlUQkg0N25E?=
 =?utf-8?B?eHQyNFEwUDFScFBxNEFKeGd1R0ZzcVh2NmVpcUhrdVNVaVhVYStxZXRlMUV6?=
 =?utf-8?B?UllsMVVlU2tVVlZVL0lCV0FiUUZkcWZxd3dENW9WYXVrRjYwaGdQbGV5L2ZS?=
 =?utf-8?B?STl0d05MaWFNUTllT2NpQzkxVmRwam1WYUNjWk5YQndhS1ZqWDIrTEtQV2lK?=
 =?utf-8?B?UTFielNYZVJWWXZVZWlUaDNBZ29QcnY0RVlydWcwdmZTSFlVR29WV0thWWxF?=
 =?utf-8?B?TGh6VTQ3YzJ6TCtSaDZtcCtuR3VPRUhNYUtxS2t1UldMaTM5MXpVa1l3U2px?=
 =?utf-8?B?cDJEQmI1OE9IVHpKNW50cEdTOFh2RFFtR0lYdEZrbFlBREtLYy9ZcEF1NEg2?=
 =?utf-8?B?WUxRT1ZuQTF0S21Rd1ZpSzJmN3lEeUlpQlNLUHlwZDNmQnR2emJjdkF2bGNL?=
 =?utf-8?B?Q1FEbUhMRVFXL0I5eFgyTFQveGRBdVNoVTlWNGpISVZNeGF2ZnB1cGdlSW5s?=
 =?utf-8?B?alY0R0draXI1WVU4RFgyL1Y2MWE4QVkwS3NsR3VmT3UyK0VVWDZiWUdzSHJa?=
 =?utf-8?B?YVFqS21DZ0NWOEl6YStnbi9YS3I0RXhlUVZJS1EwZzYzSS9RczlkL3hwWksy?=
 =?utf-8?B?Zmc0YlFQRWZPUUJxN0M3U1U4MzlGRTRYMHVscytGZ0prRit0Y0ZwMndNbU5m?=
 =?utf-8?B?VVNsN0lPRUwrZHd4NFlja3hPSVJ1Zm1aUDJreEpBR1d6NS9ZWWVYLytzaHJS?=
 =?utf-8?B?R2p3bU5xYUdnRk12a2RHVHR4SkJoaG16ZHlMUkpWQUI2Vmc0TFc1SnpqTCtj?=
 =?utf-8?B?SGhTU3VEWkZOWFREb0o3REMvTlY4NlQyL2ZJK0dEQzNZd1llVDVKNnFpWG5U?=
 =?utf-8?B?U0xSR2Rra0ROZkZRVFFYQXVFS1FXWVlPd09HT3oxM2RQb3kyWmNIbEM5bW8r?=
 =?utf-8?B?VTgyUjdVZWlkRTYwMHlwOWdFeUhLUmttMW9HaGhaUlF1RkVFMXdPOUdXN2dO?=
 =?utf-8?B?N085aDRLZDFaVHBMMlFEcjNDZ1ZPUjNiVmtJa3F1WXRuRi8rd2tFN1ZCaXpZ?=
 =?utf-8?B?Mnc2YzBkM0dFeU1ucVVKN1pEemh1ZmRWSlM3QmR2cTZ3dHVsUkZOTXAxdmtR?=
 =?utf-8?B?VzNMWDlkdWFHQlVwLzNHdmVOcUZUVmY4L1dmNmtXbk5pZkhLcjhFYm9PNzMy?=
 =?utf-8?B?TS9jdzVJbEpSVTd0aXpRRDJEU1hnMC9YR2lkWVg0U25iUlg3ZEN6YS9ubE9t?=
 =?utf-8?B?VDFucm9vcmZyU25GbGtMRUFjNnhma2U4MitGL0FuSVVqMU9yK3pOZ0ZjWVRB?=
 =?utf-8?B?L1duU0NYUjFOb3JhRk9kRnczbFVISktDUjF0QStYa1dCWjBtS0EvV3lyaWRY?=
 =?utf-8?B?SytIekZheUxMcWU5UE9UNTVFdU8wSGNpY0F4bzhZV2oyTktidVE4bGN2Wm1s?=
 =?utf-8?Q?ZXH2ahl3XnUV5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGVnM1lCOVMxSTdKOEJkc1B5S0Q1OEEwbWY4eE8xeHdzQ1BOakRLTDVWdTdS?=
 =?utf-8?B?bkxuRnJ6TW1GTk5BZWZhZ1VTSVJRK2JUckxYemRzQnArQ3pTekJYbTJsZW9u?=
 =?utf-8?B?UU9LdkFmRnNNUzBnR25MNk1lbHhheTVnSmJabWsyd1Z2cjJvRTRHQmVUOHMw?=
 =?utf-8?B?dnJzRW11emJQTE01Snh4ZE5vN3VXMW5ZaWhhQkt2SldPOXcxVjI0bzdNWDFN?=
 =?utf-8?B?eHVYZG1TY0pqWlY4MGNOMTduZGxod0FNeEE3anpqSVZpbTdmVCtFWjVMeTNT?=
 =?utf-8?B?L3dmWEJOblpROGNocndNd3JqRTVrS04rZXBFWW1waVd3eFBwVEw1dDRUZEhK?=
 =?utf-8?B?ODUyRzFXN2JReWNCZ3BLTWVxRTNhOUZTYzZHU1BHaTZDK0tpZkxhQVJLMi9C?=
 =?utf-8?B?T2NnUkVTZ1dpYWJqQklBVXdFOS8zNzMxSmFibFExdUhHOFdvV0pGcysrRTZr?=
 =?utf-8?B?ZHlNZ1pSZkRwdzIxV2NuVU1pNk1Bd1h5RXlMTGdwR05rejVISWk0dks3NDg4?=
 =?utf-8?B?SWIveUkvalptaFZLMjh6cXNvZk1NYmFJZHNHbHpEKzVsRXFKeXFuUmhLYjhG?=
 =?utf-8?B?b3FjRGJKR3BJdEhmb21nM3VNSGJoOWJ6bStuQTc4M1FFUy9vOWtkanJRSlkr?=
 =?utf-8?B?bDk4Qm1oSm9VZTlQVzduR3prdnJ6YmZXUDBua050RC9rUmorTjREend0OGFB?=
 =?utf-8?B?bE9SRHllZXI5dkgwYWtGUEZlVE1hbCtnU0dmRCt0djFtQnpRdm9PNCs5Qnov?=
 =?utf-8?B?OVZPOEVmc3NtRTRPUE1GQUVJRWt0TFJOTE91V05IbXVZdFBka0pPdjRYQ25s?=
 =?utf-8?B?SVZnRitqR3A4aWo1KzIxNlJoTVowQ1lKVmVoR1dWZ0tjSmtzOVdCemU4aGFq?=
 =?utf-8?B?RzlISndxbjlpTjFkZitYbWJPM0J5QkxacmdQMnl2MUR0WFAxQzUraWoyUjlL?=
 =?utf-8?B?ZmxTM3RkMUVqRC80S29od0JSYWJSRjFQM01wSTI3N0tzUGZpVkVDZDdNdC8x?=
 =?utf-8?B?REV3Z1dHclkvdFZnWW5lSzRXMU1GenJkNEF1T3N3QkUrSHNOVk05NjZrN0hx?=
 =?utf-8?B?RW1JMk5ZSFliUHRQd205enVBVjFuT0d6SitraVhEV05jSVFlL3Ura2x1cXEv?=
 =?utf-8?B?VjVEYjg4NzlQOEZTVzM1cjIyNk5lQy9PQUR5R0N5VlFHWlNuR216TzVmUitu?=
 =?utf-8?B?SlNYR0QwN0srUUJrR0ExcTB0c2RacjZNaE0rZGpXQ3JEM294YkxnNm43TGRT?=
 =?utf-8?B?cjN3dmpZa2FaTldNcUZvZnRzSjdIVGtGYk04d1FkV29sWnZ1bUdub2JWMzFt?=
 =?utf-8?B?TmRJU2FQRExKYXcxSmdvY2ZxLzB1YloyTWRwL3NCbjRodjBNS01XMmVRK09s?=
 =?utf-8?B?OU1UclpCRml2b210UllhSy96OGpaVjFTaEIyV0ZUcVdCQ0t3WFg0YnA1Mk5D?=
 =?utf-8?B?WXJrVWFzc1JtN25GOHdnQ0VraWtBOEV2blVnU1hYK1hZS2J4bzRGSS9JNEVH?=
 =?utf-8?B?N0N2SHk2bGZpdHJMRFlvTmEwTTVUZ2xNQWM1OUllWjMrVVFPNmt3MURGdklT?=
 =?utf-8?B?SEJLTUhsNmFJekY3ejFnamFUd3pvWVRqb3BkQkttamVQaDZycEdHVm9ubnhs?=
 =?utf-8?B?VzAzS2kwbFlyTXA5UXNUODFnMWVoY2tvdnpZRGlMMHpVaTVRKzNidWZZemRV?=
 =?utf-8?B?bFJBbnNMRDE5eWxURGhZRTB4R2xRVExheGtQc09PN0h4L2xUR0dRbXNzM3lM?=
 =?utf-8?B?dkE4TGdBdDVxbTdTU1lQMFBzdVlHRVFjSGpyNDVhcytlZ1FiZWlRdE5xZjJY?=
 =?utf-8?B?a3VnV1c5NmJJWUh5Yzh0dGgrS1JyeFBzYkVyeVBKdnF6OFpOVWl4ZzZrRmk5?=
 =?utf-8?B?OTNSRmlONmlId0NhY1B2bHBteTByT3MremNjNnB1UlZhcUpleFAvWm9IcDl6?=
 =?utf-8?B?MjgrUkFneUF5aHlpMWNIQzVuMWtIaU0xeUg0NmNlUUN2Q3RrVHBsM3VueUly?=
 =?utf-8?B?SHVGZHFPbWNlT0ZuQkVzYjdRMmo5ZnBkL3NxZ2E2elRiWjZSU3k5UHoxb3A0?=
 =?utf-8?B?VCtDN2xmMmgyOU93ZERWd05qNVdHbHpORWYwUUlDWlFBcHhoVjJHREtSdjQ2?=
 =?utf-8?B?ZzUzaTVpTWNEb1BqNitnYVloc25JOGJINDYwUVBGYVN2Qy9Ib1BtcHVBTHlj?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rMrXP+xABp1Tkx1MyuJ9Moq+xSMgzmBtTZmH6k+4D+G3fOKM1lAKuQu0ci7UMH0BKuaCnla3ijVvMekxE7GP9K1tFVeS2K03ssTVIoZxU18aRWBnnOji5WoexAnOuFxg/UxB9xFdh9kY4DuT7ZzAhmX1qbM8+nDW0x+AEBZNTzOH7p7GAuNJCstGBYh4H4Gn8J0FInR8fTrqMxwgSJKYvhuZ/9p5FtsMMUpM6f4i8rxvhEgua6uLYBmb6oatwHTmJ2L/MELpoKwdKmwe4ZMrIWELkOP3GBtyt+9xHUSR2MZ9QgUp8f2H8ig21/XxPE+4uzqC+lU0NqULQy3F/wY/T/GONGtSB4y33exz4qeqbykQOEHlpcKlyK5HrdBM5t2mM9dmHeAgzXSPUWxjRta0d/YP17a2abuWPFcdty9vn2cYeQHDh5SVvXLRR0QN8iNHSEtVQBc4WhIXDYTkHD8L7YN5B29JvsXAhUiHpnSqIxliXR8PYfZq7CwTNklVofx4lgZTtTkRc+dyThMqFpiy0BKAKayEYRz7fR7KOEi81VkcyUSLgbq7VL14AVm3aecsrgPS3yoNMY1FCut40YVhoh6JWnlGAY5Or2sB5CXm4+U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d810b5-9ee8-484d-bb92-08dd5a83872b
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 18:45:11.4187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J8cGYin/Vj1HfYVQzZOvshh4hFPEjIsJNmlXgD8dtd4uH5d3tLGTDb/I5tm/BpjqWLXMRz1o2Z3xK5gDdzTs3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-03_09,2025-03-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503030143
X-Proofpoint-ORIG-GUID: mQ5MR29aNogQeX6UlAETCqSmxQymxXz9
X-Proofpoint-GUID: mQ5MR29aNogQeX6UlAETCqSmxQymxXz9

Hi Xiaoyao,

On 3/2/25 5:59 PM, Xiaoyao Li wrote:
> On 3/3/2025 6:00 AM, Dongli Zhang wrote:
>> Currently, AMD PMU support isn't determined based on CPUID, that is, the
>> "-pmu" option does not fully disable KVM AMD PMU virtualization.
>>
>> To minimize AMD PMU features, remove PERFCORE when "-pmu" is configured.
>>
>> To completely disable AMD PMU virtualization will be implemented via
>> KVM_CAP_PMU_CAPABILITY in upcoming patches.
>>
>> As a reminder, neither CPUID_EXT3_PERFCORE nor
>> CPUID_8000_0022_EAX_PERFMON_V2 is removed from env->features[] when "-pmu"
>> is configured. Developers should query whether they are supported via
>> cpu_x86_cpuid() rather than relying on env->features[] in future patches.
> 
> I don't think it is the correct direction to go.
> 
> env->features[] should be finalized before cpu_x86_cpuid() and env-
>>features[] needs to be able to be exposed to guest directly. This ensures
> guest and QEMU have the same view of CPUIDs and it simplifies things.
> 
> We can adjust env->features[] by filtering all PMU related CPUIDs based on
> cpu->enable_pmu in x86_cpu_realizefn().

Thank you very much for suggestion.

I see  code like below in x86_cpu_realizefn() to edit env->features[].

7982     /* On AMD CPUs, some CPUID[8000_0001].EDX bits must match the bits on
7983      * CPUID[1].EDX.
7984      */
7985     if (IS_AMD_CPU(env)) {
7986         env->features[FEAT_8000_0001_EDX] &= ~CPUID_EXT2_AMD_ALIASES;
7987         env->features[FEAT_8000_0001_EDX] |= (env->features[FEAT_1_EDX]
7988            & CPUID_EXT2_AMD_ALIASES);
7989     }

I may do something similar to them for CPUID_EXT3_PERFCORE and
CPUID_8000_0022_EAX_PERFMON_V2.

Dongli Zhang



> 
>> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>   target/i386/cpu.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index b6d6167910..61a671028a 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -7115,6 +7115,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t
>> index, uint32_t count,
>>               !(env->hflags & HF_LMA_MASK)) {
>>               *edx &= ~CPUID_EXT2_SYSCALL;
>>           }
>> +
>> +        if (kvm_enabled() && IS_AMD_CPU(env) && !cpu->enable_pmu) {
>> +            *ecx &= ~CPUID_EXT3_PERFCORE;
>> +        }
>>           break;
>>       case 0x80000002:
>>       case 0x80000003:
> 


