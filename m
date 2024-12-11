Return-Path: <kvm+bounces-33474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 40C769EC2FD
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 04:11:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 936AC188995E
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 03:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D92220968B;
	Wed, 11 Dec 2024 03:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vqu9Z99O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAE71FECA3
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 03:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733886693; cv=fail; b=qyGQpi1dYimjTkf5tOajkuwCnEgAYm32QUm+SXhPS7Dp52GIrV2C2lfkQTUX10plguEvGtelJmhhNpLcN+0TyNsCoUWu6V+prAg088l6HXqwLKriuxafRpsOzUYFgy5w0thkG+0FBnlEzPVvmyEfwjbYHN9C8f8UJD6JUOx5N54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733886693; c=relaxed/simple;
	bh=Xscgg/P99Xp5nlETWE+55LiyCVbWzvVzspy9fc+riP4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kekyB6fv0hVs+JZUElQ1dH9Yt11qEilc8kfpmm95QTJQWNj6F8z/yueFDQE3i/PQU1ZPdoMjNJ0RCQ8J2ihv8AehYeAUIj4nuJAmLO5tmGGQTWpSvgbyGTq4QIbL1IIIGi/0P0tQ0jHACAlsXESnZyh42wRJHCm9b4fiKjG7HdI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vqu9Z99O; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733886692; x=1765422692;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xscgg/P99Xp5nlETWE+55LiyCVbWzvVzspy9fc+riP4=;
  b=Vqu9Z99OoD6nnNJenzqHV/Hhg+01N2FmfJQiUsk1jeV5wZ9Iy2AMbN7I
   ShFhViNdx2l6tqxxqgnlpQq2FDS5K4xAiHdYnWw8Ti6YLlALt/jGSkW7r
   zFUWmTOyMQCCTE16lOVHeVmQC6fExX5izlPrTaeHhKR+UirLZhgtCUpXM
   0W8EAoHS2UTRvXD9KBE7HJC2jAiSapj2HI+yiYw6pbbTpfUXn64+03Qrq
   Boc3CjTaqy1F9wwEc6Vfug2dmKi4MLZNlrkgG3Q0z+JSLXNtNawD3j99i
   4eA11659qkqoBuLNseuZbAkB8KmCUosZzDvq9jl4DbxqSSvbPkv37g1dG
   w==;
X-CSE-ConnectionGUID: piTS+YGdQLCoWN2aulvMBQ==
X-CSE-MsgGUID: I8OZi5MiTiqy1H+1dVhJJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="21835328"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="21835328"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 19:11:31 -0800
X-CSE-ConnectionGUID: u0xEuRkUQ5KxhNYtd0iw6A==
X-CSE-MsgGUID: mmcxXrRhSf+NfQpmItUdog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="95466070"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Dec 2024 19:07:32 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Dec 2024 19:07:32 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Dec 2024 19:07:32 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Dec 2024 19:07:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QPnvpqNgOGQmHxkgmoidY6p//QLKdbb1uFD7pRltqCmsAcFvt+ZwP5ZoFmwPuSSTBIXjpt+Do4xK1NU04bq0JdTF7mKVDQez3f0e4GaqDV0KW0Z5QMG94WkxEObHJV7RPuRep3CfuhQ/Vp32WgZPpVgVEswyEfUcwBlQD66jUEBKOb7imCHJFaC9MrFXONlIogaOJKX4aUyqD75nKIeFxG+smPN8eXvCFby7VKJI8BmJR53MiMSClt/PZtMOZu2EeLEAsBPwf4b07MFgKBHEuZWLSgdQuD1hSInGbD8+N0pczNn/CjN0hna/Y1P+muqbl7sUVtelG0oMXQ+97k60sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zXzmXMGgxtLGFAzreWooG+skLUHr67rPshJBQaviY6I=;
 b=tM1QSM/ZNHHevJ6YSiwZYDMlkKWlyFIHGfC0bmgEXMkIOKw8kv2WmUCs2aYHWMtkHDXy3IReWZ+yASNdC8a36FlqrtOxvs+it533VlNKsCZ73yxRQ734AKIfytyN0+Jvjlx1duPocFwOLaNjJHDD8bF7Gb8ymUYibCIrVW+F9Y2OKRuH8LtLx87ZPTqxtgeLEgFLmrmki8CSuKRzFlEbSTOxAB0Akk91ZNMl/p566GYz0QHKNKajx1/r4AbWXvIkaULFE0nPtBqP92LFKm2/n8duJbBj00VOqglGfe9S9lMk2Pia6uknKgvkLNbrjxDRf6luRHPE2wrY5017GxQPmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN6PR11MB8243.namprd11.prod.outlook.com (2603:10b6:208:46e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Wed, 11 Dec
 2024 03:07:24 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8251.008; Wed, 11 Dec 2024
 03:07:24 +0000
Message-ID: <fcd4abf9-8be0-4740-8a33-5739cc07559b@intel.com>
Date: Wed, 11 Dec 2024 11:12:22 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
To: Zhangfei Gao <zhangfei.gao@linaro.org>
CC: <alex.williamson@redhat.com>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <joro@8bytes.org>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>,
	<will@kernel.org>
References: <20241108121742.18889-1-yi.l.liu@intel.com>
 <20241108121742.18889-6-yi.l.liu@intel.com>
 <CABQgh9GgWVZ6onc7Tu5ARJ_bPrm1GB-5EaQuh4OCu+ywC1Ez_g@mail.gmail.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <CABQgh9GgWVZ6onc7Tu5ARJ_bPrm1GB-5EaQuh4OCu+ywC1Ez_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0002.apcprd06.prod.outlook.com
 (2603:1096:4:186::10) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MN6PR11MB8243:EE_
X-MS-Office365-Filtering-Correlation-Id: eca4ca66-6f30-4975-e0aa-08dd1990ef91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QnZXUTNBVXRacUhOL1JoWEtRUEVtdmUyOHQra2VGVkw0VkRUcDZGbHFFUmMy?=
 =?utf-8?B?N0FKOFh5YzQ5RGFiMHNyMGRBd2wwTi9UZS95MU0wNmJVQVl3NEZzUlA3Ym1R?=
 =?utf-8?B?N3k4Q2dxZmhiUUl1bGw5WUhCTTJFM0JEY053YjJNLzRlcjNaZHlaYlpZaVdm?=
 =?utf-8?B?bmpWTWswUTlaWnowS0FLQ1htb0JIbTl1bGpqWXBhaWUxMW4zY1JYOTdOQTFq?=
 =?utf-8?B?Nm5uYXovdEpWRVMzcnNFZkx1TnpscldsRmg1bWd5Y0pLQXBwa0FHODIrNkJl?=
 =?utf-8?B?WXpRYzRPRVhvVFFpMElNSlh5YkFVWXhuajJLcXJwSCtkcWNlQlBkUUdVQ3pV?=
 =?utf-8?B?WHEwdTRES2NsWlRmTnh4aThUM3FVTktSQlQ1NFkyTG1VQ1huOWp0b2VpUGg3?=
 =?utf-8?B?TWRzb0pxSE1SeldQM3NueE9oRlF5VWR3NEVCVGJUNGNaVm05VVZoMzVPcHVz?=
 =?utf-8?B?WUQvVk96L3VNK21QVjByWExsSnRSWWkxSFlCWmVuWERFdVZ5blIwWXcrbTEr?=
 =?utf-8?B?U1BtYUl5Yk11WWJ5WWdVeDRYR1Fpbkd4TDY5VU9tOTh5MVV2RWJuNGZ6a2tO?=
 =?utf-8?B?bEQrdk81Y2dQU1EwcXliU3dwTFdLWGJXYkdJMGM2Zm05V1ZHazRjRkV2cXlH?=
 =?utf-8?B?WlppNzZMRVd5TU1ZUi9UOFNlMUlGdC9XbWsva3BlR29YMVRvTDlBeDRRT3Jt?=
 =?utf-8?B?ZmkrZExFb3FicTMrMGd6eTNFWDh5Q3kxckp1QTdHRG5LcWlkQ2ppSDBzVGRF?=
 =?utf-8?B?T0wrRUVYdzd0dnhDeVRFVmtkTnlCeFJDSlhWR3Z0MWlZcHhsRG5oNjFHeTc1?=
 =?utf-8?B?aWxmT3JPWlA2Y2IybVVyTUF1S283Y0JveElhblRIb1hKZXFjeTVDNmRLSjhR?=
 =?utf-8?B?Wi9rNzRpdmdBVmx1NzRiR0ZBNWZxYjBsQ0dIekIyZllxdzRjaXV5RzZXZzFI?=
 =?utf-8?B?V3diVHcxY3IzMFdodjdmTE5LNHdvbWxGcjd5WlBOL2srOGs5dEd6cUdvVVh2?=
 =?utf-8?B?R2JjOTFFSUNkOURLeFdLUHpyYVZmNTNkdENOK2lrM3RBMGY2a1RUMUc3VlBr?=
 =?utf-8?B?KzdjQXd4MEROVG9pRU1TT011dUdXQzMrL0RhWUp2a1VZY2dCWVFQZ1dEUWdB?=
 =?utf-8?B?anVKSWRVVGZsNWY2VVRHNytVZ3djQ1czOC82YmVPeFd6clpQWWl3QzArSG5V?=
 =?utf-8?B?WnVBQjR0UUMzZGNhdkZwMm1sNlYzT1JKVHgwRDRiQ0g2ckNDSGM0OWRsNkg4?=
 =?utf-8?B?R040eFZGMmNNSlBPUjl1N2pqVTFncUJtNnpYS29rTUZhMW8wQy9XTUhjRlNR?=
 =?utf-8?B?STV4WUlUamZWUHlyV0p1bDNOS04xNkd0c2srR0NiVTNBMk9xNWdkTlJqSU04?=
 =?utf-8?B?aWlnelFUWWR4NUozUDR1bzA4OUhleUtIdWdwRjlpZzVhNktha3pYOWRsWmxE?=
 =?utf-8?B?Zy9EMmsxOEhCUVdmQmU0VXlsRGdXY1l1NG82WVVzZFh6VFkzQ2JiRm95Z2FL?=
 =?utf-8?B?MlBGM0lmV0xEZHhCRWVRakZESkUvNEttVENKMFRFRDZsVjdTR29YWSt0dXov?=
 =?utf-8?B?STBmM1N4czhZNmNLSUlFczh5NHVFVTNsaHAyc2JBamY0eFNTMUpnMWYyL2tS?=
 =?utf-8?B?QnlJeHRQM29ZMkpYQnloc2cxLzBZMk1ETVFTVGNTaTlleTdnTlRkT1MwWU0x?=
 =?utf-8?B?Q1VXUEhYbkhjUnRSTGxQc1pINlJZdEp0NnZKUTN1bzl6em0xRnI4TjVHemFq?=
 =?utf-8?B?WXBZVVFMa0tIN1FaZm95bFRUS2t4eHc2TldKTC9GSzl3SFdiOEFSNWRKRzhK?=
 =?utf-8?Q?7s4jBCfdt6vrXbHA1tm1ab1/iju7WW10+Na8U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1ExYTNsZlZPdVZYMk83dHY5Q0lXTzQ2bEpHVyt3N0g1V0NZQXZEVEN1YTRY?=
 =?utf-8?B?OG42V2pUUERnUG1JN2JmUWtwRitZUUNoMWZTeG43MFY5TXYvaVMxd1oxU2E3?=
 =?utf-8?B?L3p1WTdBV2hRNk5JaTNJWERMa1pTNkZubHBMakkxc0ZudS9KdFEwS2ZPc0pU?=
 =?utf-8?B?S3dlcXRnbHNpQ09samNndm91WVdDR054NkNJdnRkUk80Nll2WGt1Q2ppRlFP?=
 =?utf-8?B?ZnlsVUUyWjYwVmdrVVBHemRFNWVCczZKS2NlZFFNMlJVQkRpbDVxK1U5V0lx?=
 =?utf-8?B?YlRvYWhzcGtsNmttNEkwdWFzK3RKTzVCOUtxdS9kRGxRd1NFQlBHUVNaNTli?=
 =?utf-8?B?OVQ1MlFObTdkYUVmalhMak9ITEhxdGlrbFk1dEJ1NkcrL2lXNUw0elIweXEw?=
 =?utf-8?B?S3NlY3F1bWJ0Y0M2TzhuQ2J6TjZXd01BeGFlbEFPL3BxKzNKZU1Xd2ZEN3F0?=
 =?utf-8?B?M2dlYUl2MUNTYkZWRUtZTE5BUGdmWnVxYTRhL2o0ZTdUbEVMcTBVZ21iL1dI?=
 =?utf-8?B?TkwrN2FxRHd3ekk5UGQ5Nmg5SERaclM5QStkTHZJeThMdlFPTEgrYkxCSllH?=
 =?utf-8?B?U3FJeXJ5ZjllV1FScTJCdFBacFcvOGV1UVNybHoyejdXYUhld1F2MWp2bFhv?=
 =?utf-8?B?TnVCZzNTeEJqUjhhbDdsYk1nNTVVZ2RJYWlXd3dLc1AySm1NWE94S3FpMGJm?=
 =?utf-8?B?aysxWXcxVTg4aHVENjZWSTd0NEJweHBnTUJSL1QweUhKOFRMenhKVkZjNDhn?=
 =?utf-8?B?OXZCSlpod1pwajV0MDFVTE9YU2dteDQzbW0yNzEzNkZFYjROYXJXYi9wMDdn?=
 =?utf-8?B?cE5Ea09xRTg4R0g4OTYyZnAvNUxubUJweDRkWmY4bU5LaEl6V2Y4OHEveG9w?=
 =?utf-8?B?aXVtanZLWkRTdWxVTVdqRlU0YXhWWXZzTndXQUJLRnE5NHFxdjQvTjJzSWsy?=
 =?utf-8?B?WkVqa1phdTNBSXZtK3lxUFNUZVREU2tjQkMveG52blk4TDZlL3Z2STVubmx6?=
 =?utf-8?B?T1NYU1dMbml1MVh6QURSVDdyUFpZNHFaNHp4bWRvQzBPYllZNk1zLzZSNG9l?=
 =?utf-8?B?ZkN3YUFPdTYrd0xZNUxtNThkaVRzUFdjV0hlWkROc2ZqL09PTnRzQy9Xbjd5?=
 =?utf-8?B?TG4rdm90R3U0SDl5WEpuaHR6QVlZR1E1RHhTQ0FpOEQ0bjN6RGNUV2FpaW95?=
 =?utf-8?B?bUs3SjJWM3BZVnI2SlBuNEV0eFAxVmhjckNRV0l1NEZrcm1vMWk4K0ZybVVP?=
 =?utf-8?B?THgyK0VjK1piN3o4cnRzdzRaVjRvWWtGQTc4blRQTXlreUtkc2xQYkZiRStk?=
 =?utf-8?B?MjZlVnhFblo2YnFvWlVOZlVzUlppMGZ6aE81WE9pcTEvSmFVQW4wTzVXWmdU?=
 =?utf-8?B?TU1WRVZ6Ulhtd2ljV0FjbC8xYmNlU3JPTGVPMzRIVEQ2K1lQQTVrVHRvTXpj?=
 =?utf-8?B?b2J5L1lQVU4ySzZpQ3RWK0h6R1ZFN0FOZEt4YU13Y2N4d1pjT1ZOVlZRaTEx?=
 =?utf-8?B?Y0c0bUR6SU5SM0NPdldJNjQybEIwYUhCbkhYL1FwU0tXRnFSN0k4bG9KT29v?=
 =?utf-8?B?RWlQbEQ3Y2RNV3k2WTUwZkhBbEFVWFo4Q3VtSnJwRFh6aEVIWkE0SVozV0s0?=
 =?utf-8?B?YkRjaU1adnJDazd4cndteDJmSVhwcXFiNkxBMmloeVBySnhUczNuTExTSFA3?=
 =?utf-8?B?ZzE3R2U1RDBkTVdiK3hWakhxVVcrcks2eVJacmRaK3BuYmdpd3lSK1Y5eElX?=
 =?utf-8?B?SlNmMWk5SmhYdXd1cnNZU04za0lDRnFzY0ttWXNyL1o0Z0o2RkRBRnBIVThN?=
 =?utf-8?B?M2tiV1ErRUxBRTZDUzNhbUoxZG9ZMWIyWWQ4SzdDTnViNllxcVJoODJSckFB?=
 =?utf-8?B?MGFYWTR3YzRBTjdiVk1sRzdiRWRJS3Y4ZWNTZWZPSkdXQ3BaV3Rvb2lvcDUv?=
 =?utf-8?B?QmpJL0xUcEtRSmtYSDZuQnRENXdWcUFoakRRNE5HeXJBSndUQXYrazFBQXU1?=
 =?utf-8?B?b0RHT041akMzTSs1RERGNDhkQW1MRnRpSTFmK2Vwc0lIbDFlV2lXOXZPTGs5?=
 =?utf-8?B?bnYvbzMrN012ZTY1ejRsaHBjZVBtNmpGM0hmMkd3ZGw4WUh0M3NHMWp1YWg4?=
 =?utf-8?Q?IZEJb81CHfEXLnhflJJVvd3t8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eca4ca66-6f30-4975-e0aa-08dd1990ef91
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 03:07:24.4799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aEre9XGsGqFi56wFbjrdmOrr9IHa+ZToX4g+AqfuVTvAd8ZrplG6GQygs2oKKD2UZu3M+OyTT7l3pI22PNmNBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8243
X-OriginatorOrg: intel.com

On 2024/12/11 10:43, Zhangfei Gao wrote:
> On Fri, 8 Nov 2024 at 20:17, Yi Liu <yi.l.liu@intel.com> wrote:
>>
>> PASID usage requires PASID support in both device and IOMMU. Since the
>> iommu drivers always enable the PASID capability for the device if it
>> is supported, so it is reasonable to extend the IOMMU_GET_HW_INFO to
>> report the PASID capability to userspace.
>>
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org> #aarch64 platform
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> 
> Hi, Yi
> 
> Found this patch still not gets merged in 6.13-rc1
> Any plan to respin.
> 
> Will this target to 6.14?

yes, due to dependency [1] of this series, we need to target it to 6.14.

[1] 
https://lore.kernel.org/linux-iommu/20241104132513.15890-1-yi.l.liu@intel.com/

-- 
Regards,
Yi Liu

