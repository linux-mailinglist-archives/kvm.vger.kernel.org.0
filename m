Return-Path: <kvm+bounces-41698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D48F3A6C18B
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:32:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F18664614B8
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E4C11E8348;
	Fri, 21 Mar 2025 17:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kNZh8FkC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97A64C80
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 17:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742578344; cv=fail; b=Fa5ss8lXlJjGjNfrCctQwH/g8TeyJCEfp1JHCCPyGkt1CUgNSXUF/tHwDAAxa++DGGDFnbpuv6y3AC12l8M4u04SdXejHfnnChoE+giCQAtwzQWqdyVRl/1O01EkFv2MKO72Zu6DtRFo/l+3H8oVFllzlggc3uwDf2FmhEsud/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742578344; c=relaxed/simple;
	bh=HhjlQNWG+rxD2PB9ByhhW3yawYU13tnwrv4M/yxDbY8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y6q5HV/hXLNtQaQGPwR0kVzwSt0L/Y9Hug66y5+/vMfEIQSAT/P0ZRtcs30AR2WIRjx4GY2wf6hyV8aJZ1+xrKOK2WawDtSO8byElnK1tIsrkwcBnwdPwt5Mf46sSlaJ89m34bmuaLr6RLPQLoZQCJmywIy/JeUdhZEyyGq9pWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kNZh8FkC; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742578343; x=1774114343;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HhjlQNWG+rxD2PB9ByhhW3yawYU13tnwrv4M/yxDbY8=;
  b=kNZh8FkCwWfK6Ga4geyR3YIc/yu6s1ltYfdWACW50R8S1urMQaziWGKh
   ZfdAJiDI9I0mDOfPk8lC3dunisK54nFztolx33fEF9uoYv4XWCKmzfLJM
   bslB9QdVICQ4y2W0YQ9sUCIco8mOZ1/IGfHVaGudXh83JEkPNQTmhhvFP
   c6wHN75Ff2XspTEluCdyoidmFet/bdSRMIaAVYyZ+neWQHQPrfl3jQ0Yt
   SrEdMZ6WMmZTuaAKoofeVCUhtoRcn23MKLZlmbsSrwlWQS19Efp48Bd2l
   85nMMC0m720cnuYmr/+LG4R9XuCrJo2ASOrScc1BQlZUOpOFJXDqb15bl
   Q==;
X-CSE-ConnectionGUID: KJ0fRTdsSFOz4SPG6msh6w==
X-CSE-MsgGUID: r9khKEzURLi881BRZApOag==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="47730302"
X-IronPort-AV: E=Sophos;i="6.14,265,1736841600"; 
   d="scan'208";a="47730302"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 10:32:21 -0700
X-CSE-ConnectionGUID: LRl4IfhyRxKl8r9CnGjRiw==
X-CSE-MsgGUID: /rZ/45WYTNiw55MPHicZEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,265,1736841600"; 
   d="scan'208";a="128518198"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 10:32:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 21 Mar 2025 10:32:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 21 Mar 2025 10:32:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 21 Mar 2025 10:32:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vtkNYJaOKLUCGmoucMMpqmq2RcG3auRz9IgpZH5RG3k06PQqHEFmaCvmu8ATiuTMzoObfL7LxscBKpOdZtUTo5Js4ZY+6rBLL1SAfAvqmEIIEXygA4GmHriaCwq5k2MGjYmc/WEngTNtOE6X99fw4Y4BpzH56EfnAr5zAyX8bkI4xFgHXU9csC+xUL39C1yZQxEB1gmqFTR4o+tmQogAI8jTPFCvxWA95y0DQtRgNwVol/78XX7taZ/GeOSz0KCwHtnwSfScGdEI8iBXBOYaMIv8LELF0sLQ36ZuZ7nbPST16XvOU66n0wWfh2Hh2Dh2eFW4Ikfkf57BdbaUIJ4AbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YVem5XKXB9vTBry01hH2+mBG5VaDtOdGRq9UyyNaV1g=;
 b=WkZNs3TJYkjIN5StYDl7d4y1K0cXsBejdPSUMf1tnevekdYnbu5fx7Dm+qU1bceWbSNAEV0KPtL8z0D604UqIAMkDNyWnrSl+ZnYTplj7H0keC2zAPj8VIgamqNBaP72cjp6MhWEtm7smJyIac2PVfi6JBCTK32MUa6mtG+NllkC37+m3z1+qoAFMqaIiFpIyiQ+B9uR39qQxTuMiPtZFYkwJsS/23ykB/+0GFk1At5c6T31DOGYe9zv37IpioPeIpU9HDeQO7ciDVgVDGK8Hm9dUs0lt35yEwU+TihpQbkqJ1BO+7+Y49XMl7gahzfqWLou379o+tfPb64h2/M9vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB6988.namprd11.prod.outlook.com (2603:10b6:930:54::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Fri, 21 Mar
 2025 17:32:12 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.8534.031; Fri, 21 Mar 2025
 17:32:12 +0000
Message-ID: <035649d0-5958-45f3-b26d-695a74df7c39@intel.com>
Date: Sat, 22 Mar 2025 01:37:39 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
To: Nicolin Chen <nicolinc@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	<eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<willy@infradead.org>, <zhangfei.gao@linaro.org>, <vasant.hegde@amd.com>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
 <20250313124753.185090-5-yi.l.liu@intel.com>
 <Z9sFteIJ70PicRHB@Asurada-Nvidia>
 <444284f3-2dae-4aa9-a897-78a36e1be3ca@intel.com>
 <Z9xGpLRE8wPHlUAV@Asurada-Nvidia> <20250320185726.GF206770@nvidia.com>
 <Z9x0AFJkrfWMGLsV@Asurada-Nvidia> <20250320234057.GS206770@nvidia.com>
 <Z9ypThcqtCQwp2ps@Asurada-Nvidia> <Z9zqtA7l4aJPRhL2@Asurada-Nvidia>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Z9zqtA7l4aJPRhL2@Asurada-Nvidia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::18) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY8PR11MB6988:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f0b773b-884f-4c93-664c-08dd689e50c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SWZhL0dKTktlWlhJbXg3blNIZmNHcksxbkhTcmtqeiswYTNwUTM3OTlub1g2?=
 =?utf-8?B?TGpUaFhjYy9DV2ZYazlJOVE2ZzdYVmxPZlQ2UkcxdTNMNUMzTEt5Tko0Q1ZS?=
 =?utf-8?B?Qk1HbFJaZ3JVaVB0RHM1NVNpdXdzUS9taitmVFpEa1kvTCt2eXVzck56UzBR?=
 =?utf-8?B?MTh5S2E4ejZjV2JvL2NGUXNLS1FyeHFjYXlacU1renM2VGp4bmZnL2gwMVdY?=
 =?utf-8?B?b0o1enN2Y20rWTVXbndzL1RoUHV0bFhWZkVsT1ZYSWpBNUNCbU5YaDVqazB4?=
 =?utf-8?B?V05qaDRGRmVWaVQ0b3AzOG1iTzJFUktzbi8rTXkrcm1jTnh0UHJnaHlHVzBx?=
 =?utf-8?B?eHZ2K2JDRVg3SW40c2paNC84VTdLNWdVNE1ON1FFeWxXSVZJUDF0UlhmUm5a?=
 =?utf-8?B?VkRRcHd5VTg4Vml0S0tmYXpjeE15dVdTTXprWDJnZjNOWGRVQWRtb0JDU1Jx?=
 =?utf-8?B?WlBXcCtCTWdTVmNBNW0zQkxaVkUwQ004d0NsUlUxYTBzRWpIUDFXblByZDdN?=
 =?utf-8?B?VHNQeFVlVUxFNzB2SzNCZWIrbmh5ZlVQaVRjOEtTblExeEdrZFU2WGpuNTFl?=
 =?utf-8?B?UjJIMzZOb2R1eU5DSTJCcFhOS043WjZnQUNTeHp1cVpBM1NSMUFIZjdWelFB?=
 =?utf-8?B?K2FKcTgrakNOdjNwZXJ0OURlRDNPa2pYcTlXS3hOTVhnRThmT1Nabk5QMEdS?=
 =?utf-8?B?MitDUFRoS29NZ1ZJbXZuZGxydGtvWDlKbzdrQUVmVmpNR1FZZFp4K2tYamVP?=
 =?utf-8?B?ZEIwNWFIM0tMSXZ5UG9qOWRoZHNkcDZBaVFPaEZjejU3RGEvbmdJZDNpbXZE?=
 =?utf-8?B?TGowclEzOFc0dmRHcTRaWkFpeEFlb3lCZmRheFFFNTlncC9QUjlVclQyeDdF?=
 =?utf-8?B?UytLalJYVWNUcGNLMWhBY3VtcittTDU3NEJ3SHA2bXVOYWVRVGVLblhkZFZZ?=
 =?utf-8?B?Nm1qVGhxV0VMSzF0amJ6QjUrRjVWY2VScnFYbXJiOXljUXlhb2MzTWZlUFR3?=
 =?utf-8?B?dUZuUUdZazhvTFo0amNFampTMmIrYjhSNXk4OVpHamMrYVh5Z0RNWHBGVU96?=
 =?utf-8?B?a040T0Q2M2FUWWhkbVJYZmc1Y3JyTHVKL2hHR2owZDBZcWJucDVxUDZyQUll?=
 =?utf-8?B?dHMwUlVmdzRLN0hmamQyVmR1OElKU1h1ak9KRXdEeGxRd2IzT1N1Q1JRcitB?=
 =?utf-8?B?NTl2bnIzZnFuaS92a0ZKMGRvSzJIVnBLbXVBMlhaRC9mWTF1NXVtQ21NZ1c0?=
 =?utf-8?B?MThzVHVyb0h0RXhvWjBtWU1QZWFYQVEySjZyUFZDcUlLcktTekdzTVBkbjVz?=
 =?utf-8?B?U0RLTlV0ZmxGc2FCVURHMVdyczQyMVlhdVVkQ2orVUFzK3ZLcVAzOHJIOVY2?=
 =?utf-8?B?Szg4aWswVUlzcjE0Q29sd2JSb1YzdHkrNHlOckFIV0djaTJWd2szdFl5YjRE?=
 =?utf-8?B?Nk0zWE9DeHhLOWNqZXg0ZGlxZFdISTNsdDI3LzFmd01MdlByUGFESkNIN3p1?=
 =?utf-8?B?aDljcnBjNE93aS9JbVZuYnBnVGdVREp4WERhemhkSmtXNDhTNm8ycjRSZlR3?=
 =?utf-8?B?OTl5S0pGcHlKY0JrMzNHYWZobzBmOGFMemtLaTRPb29ESlZBdU5JcG9rQVNO?=
 =?utf-8?B?WHl6VlJ1ZExLa0s2WE96L0NQN3FhRFhVVXh5Z2kyNWlobDU1am9qUEVZN1lz?=
 =?utf-8?B?RVJQeERCVWpCWlAzL1N1dytiaTZBbnQzREs1SjQvK3A5Y0ZTZjNoNkp6d3Fo?=
 =?utf-8?B?cDViOUkzbXBVamhZK1EvMnVPZWZtRGJwUnBkekNhN1ZLL2xVZVNKTGNxMWRI?=
 =?utf-8?B?NGxoZlVKMm4ycDJRdHZEZHYrMy9HVzBPV05OYWZkYUpzeDRyQlk3Ymptbyty?=
 =?utf-8?Q?j5foaE2GJj4mU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGhkYXlsd1Vscnlzc2Q1b1UrWmx5UFkrSS9SSVJJbENzcjNHaTRjMXlGekNo?=
 =?utf-8?B?KzVMMDdFUjJISjZYVnFlTXUybld3Y01laVZlZDViaCtoVHBJc2FIZVBCNmdK?=
 =?utf-8?B?OExvb0pMSlVLZ0Z3R0c4UjNmNXNmZzRLMFN1YTFUWWpTRDJCcVErN05SakJr?=
 =?utf-8?B?SWxjMnkvL3NWaDYzTmVVb0RVcmRWRXl3RWJ4dVo1N2MyK2xQK1hVUG13NVZ4?=
 =?utf-8?B?UURmZktuYVRZVUhBN1p5MXBSYm9jOUxORDRjU0RwUlRhMWx1N0xwcko5U3px?=
 =?utf-8?B?eFlYbGNGQmM3YStkeGtJcThIWkJneUJ2blJhdmN5dzNhYWhkQWNCbXB6aDBj?=
 =?utf-8?B?Q3pVb214OXIzVUlYREtIcTNqTWp6TXloZXZjL1JXT3lIcWVwdm9qODVEUUF4?=
 =?utf-8?B?cTdFYTFYeXJSNWc1ZitqMjkyK004dFNFbGNJYVlDSElxYnFXeGFlSVJhc0dV?=
 =?utf-8?B?aXNJREQyb3A2OE1EYnlGS0NTMUt5Y24yUnFRMG1kbzhzaGxQUzltNXp4bWsx?=
 =?utf-8?B?Z3FMbnJJR3QvZjk3M0c0UE9hYXVPYkFqKzI0R2sySDczYVRzRlB5KzJpd25t?=
 =?utf-8?B?M05uYzY0dXFYd2xHTUV6TE9hZzhXb1k1M2dXY3cybzFUUHRtZ1JSN2Q1REY5?=
 =?utf-8?B?Y2ppdS9rRTMwNld2YmdnNGJzM1J4R1FZVEhBWEo0UTJZQnhDZDlRaVlGdEZ5?=
 =?utf-8?B?RGhRaGFUQUFTZTRleHc0YWVjdGZNK20xUVY0TW1jaU44N1JlNHIwVjMyZGNv?=
 =?utf-8?B?QitlZStqbklTTmw5aHIrVG5WL2NyTXcwakU3SmVWSUVLY1dkWFB4ZTZRMGN6?=
 =?utf-8?B?ZFdQVjEwKzdHRUF6Y2t1bktIWnBnV2pTckdCc3Z0THY5bmg4VHIwU2N3M3lJ?=
 =?utf-8?B?WW05Z1VNVXhZTUo0bStWL2QvdVM2QjBaWHh2Y0lHV2x2T2I0TTY3eUVmSFM0?=
 =?utf-8?B?b0VBbk1SWDJWSDlLcUZvc0NReU94UzQ0a2tnb3F3WkFtNzYvZVdpL0cyS1dT?=
 =?utf-8?B?Y1Q0R09ScWFncGx1N1RTbVYxM3pzK0tkcFAvRmQ3NkpCUDFHSUZLSUd4U1FH?=
 =?utf-8?B?MFh4Z2ZmZ0JiTXMxNWpsRWM0NzcvYkdaVExHSTZ1c1pZYkhnVkRBUEtEV1R4?=
 =?utf-8?B?bmxEUW5FblJERkRld09WMnM5WThTVnBqS1VWR2ZKcFMyNzBZZDVPOXZmVUZC?=
 =?utf-8?B?a3RYNWRCSUEyenZwMkgrc2VoaHd1U3MzMWRKYzJ4QlJwbldVZXRhS3RVZjVY?=
 =?utf-8?B?RzFuRnZ5K000Q1ByYzNIRXkyRVNFbldjOFpQL2dFS2lNZ24vSk53RkwvamZz?=
 =?utf-8?B?ZHVjUTBvY2FlY1BWd3Z2U0hOdnN2QitLTktFVVE0cy81dlR2M0d5cklUSnJ2?=
 =?utf-8?B?OUZIS3hkbzF1d25Ca3VtK2swRlB5d2hXSXUvSTEvWmFwYkhBdkJ6MTA4Q1lL?=
 =?utf-8?B?TFowRm1qVnNnbFQyOU5zSmIyamRUZ29UV1NaaEFDaCt2blpkelRnY1RZQ3NX?=
 =?utf-8?B?SHRGRHJNNURxWDJBL0xmcEZ3RDErZTRwQ3FqRndPdW1XUmgyL3JYS3BhSmpv?=
 =?utf-8?B?OFVaQWdsUVgyTFhueVkrbi9NLzZSTjNnaFB6TCt6NEdRRXJGRWZOZVJjTXBT?=
 =?utf-8?B?MzBLUkl6c0E3eTBmeFY3QllOZ25ZUk1GMW11R1NzRnlCQ2RVNWJ3U1poTUk3?=
 =?utf-8?B?MTE3dzZMNFUzZk01WU4xZ2hkWGlnWEVqczhFQlVOcGw3L0xSYTVveDhPMHFt?=
 =?utf-8?B?WEdqcEhaUmluSUpDS3JLNHBFMG1aT1A4WTg5alpnL2lVNWl2R2VDQ0pXV3lx?=
 =?utf-8?B?bUdURktPRlhROVM5U284bjV3cDNUeTdka3hTaDFDWndMVVJhUU4xTGJTZFRh?=
 =?utf-8?B?UUVPSmNJTElpdE5kRXpUcnNxL3pkenRodWtBc0ZTckhIeGJKSk1XMFVBOWR2?=
 =?utf-8?B?QmRxSmVCQjFwUXhuSjZhRFBwRHVXL3JtNmFoK0VMOWU3aWhPNGhsYnJaRC9Q?=
 =?utf-8?B?UTRJcDNCWXlueGpibjdIMTU4UEZJWlVJVjlaTW9qWUhPdlIxUkZVTXFpc0VZ?=
 =?utf-8?B?RnY1NTVTb3hxbDRrR1JSdHBzWlhtQVV5UHR6QVVQdHN2YjI3SWRXME9SN0FI?=
 =?utf-8?Q?eupsWheq/g4z+ZUMIP9Vk/k4O?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f0b773b-884f-4c93-664c-08dd689e50c8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 17:32:12.7417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hYKEKMeWQ0MhRLDxDaZBZzFBTPtY5FoNKfp4BBEFkmuRSWuEXvhNNCVUD0jJZPNT5Z85J32cocMSBrOwY2H4Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6988
X-OriginatorOrg: intel.com

On 2025/3/21 12:27, Nicolin Chen wrote:
> On Thu, Mar 20, 2025 at 04:48:33PM -0700, Nicolin Chen wrote:
>>>> Also, this patch polls two IOMMU caps out of pci_pasid_status()
>>>> that is a per device function. Is this okay?
>>>
>>> I think so, the hw_info is a per-device operation
>>>
>>>> Can it end up with two devices (one has PASID; the other doesn't)
>>>> behind the same IOMMU reporting two different sets of
>>>> out_capabilities, which were supposed to be the same since it the
>>>> same IOMMU HW?
>>>
>>> Yes it can report differences, but that is OK as the iommu is not
>>> required to be uniform across all devices? Did you mean something else?
>>
>> Hmm, I thought hw_info is all about a single IOMMU instance.
>>
>> Although the ioctl is per-device operation, it feels odd that
>> different devices behind the same IOMMU will return different
>> copies of "IOMMU" hw_info for that IOMMU HW..
> 
> Reading this further, I found that Yi did report VFIO device cap
> for PASID via a VFIO ioctl in the early versions but switched to
> using the IOMMU_GET_HW_INFO since v3 (nearly a year ago). So, I
> see that's a made decision.
> 
> Given that our IOMMU_GET_HW_INFO defines this:
>    * Query an iommu type specific hardware information data from an iommu behind
>    * a given device that has been bound to iommufd. This hardware info data will
>    * be used to sync capabilities between the virtual iommu and the physical
>    * iommu, e.g. a nested translation setup needs to check the hardware info, so
>    * a guest stage-1 page table can be compatible with the physical iommu.
> 
> max_pasid_log2 is something that fits well. But PCI device cap
> still feels odd in that regard, as it repurposes the ioctl.

PASID cap is a bit special. It should not be reported to user unless
both iommu and device enabled it. So adding it in this hw_info ioctl
is fine. It can avoid duplicate ioctls across userspace driver frameworks
as well.

> So, perhaps we should update the uAPI documentation and ask user
> space to run IOMMU_GET_HW_INFO for every iommufd_device, because
> the output out_capabilities may be different per iommufd_device,
> even if both devices are correctly assigned to the same vIOMMU.

since this is a per-device ioctl. userspace should expect difference
and. Actually, the userspace e.g. vfio may just invoke this ioctl
to know if the PASID cap instead of asking vIOMMU if we define it
in the driver-specific part. This is much convenient.

-- 
Regards,
Yi Liu

