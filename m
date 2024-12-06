Return-Path: <kvm+bounces-33197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C707B9E6844
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 08:52:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82BA2281CDD
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 07:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED5291DDC35;
	Fri,  6 Dec 2024 07:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NkM/86ud"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4004C197548
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 07:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733471569; cv=fail; b=mwGjS1ARFaudsAKn3jdoLFWXL8EPyoCX1/6rqJ3vgQMKh/cBBfZTZ+P71K7WjU/bpEnXpY4n7mLaVPXnf1juZmidytWmvwFTLgokHUqMbPDp8Kts+1Br4+U4Cbnygl4J9waltLJmp7koNaaU3qdo/07GNOMeSjp10n+4IisJBXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733471569; c=relaxed/simple;
	bh=IWU1d5TYW1iVnoID0CoWd6BbwqLkT2bils8g4n2151s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FDktgM7oP10xCiuxJhGO4fBdDaYBd6kL3LMqvdk+TlGU9ALIo6/MlbCg+jwkcWf7kN1Wrlamm8v3aeapq0qxxn+JERQ+MNiRWD27zUJlWdaAg3iUIALi638QLiMXhnsBc8dM3oyjfYt7O5NJi1tZw4xCOGHU3LPnZ98Oi57i+z4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NkM/86ud; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733471568; x=1765007568;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IWU1d5TYW1iVnoID0CoWd6BbwqLkT2bils8g4n2151s=;
  b=NkM/86udHnJ9i+NyRVXJkFu4GdA92S4cTVw8n+wwXI9sItPcQltc9uUZ
   oVgvxN4OPsXflkFLalQolgf2fnVy7MozgXVnPY96h04ZImfiwzgI3rBJs
   5VEh/+DddctJCl015xbSaUwQ02cEdz7d/wy1J/piUeP2aptV4zDh1r6ol
   y+U6Amd0pug31pk4VAW4+mEOpAq9fVMlJtfvrTx2IDj4ANsVtQjvoatoL
   zmtLCc+02z8o7HdsfWiZyVyEHIRh7QPdseDuIrUA75geritaJDu9fYPDY
   Y3h9FP3YgsBGUjCp5zS1KJsfvxOWkJ2wH8PONiBGR2Gk+hIIy8QSal6Wl
   g==;
X-CSE-ConnectionGUID: j1krIVZWT1ikL0H1k+P0zg==
X-CSE-MsgGUID: YpJNu1KISjiYhzwDHL1WSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="37490517"
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="37490517"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 23:52:47 -0800
X-CSE-ConnectionGUID: WWrvl3rZQU+QmIjIABxHPg==
X-CSE-MsgGUID: 0C7KXHv/TEWCWz8NEGLK0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="98785047"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2024 23:52:46 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Dec 2024 23:52:46 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Dec 2024 23:52:46 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Dec 2024 23:52:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hppUXn3iG3wQv1thDWGYcdk7pnzd3Xf3eAnzoAGu1Y5Pr3NRuI5+B70DLHTl5jxE2Qv4bBrCp6rlXmZFCj+Pyhm6HJj2Zwg5qkru/UMgbPdTWQ/IzxXDVWd9wb89UkYB9ZEOEPIiDe+utUUZC+rybZD/ax8Tn63HSt7ewtyz+QcWZygs2ybUEAA1YV8giEy9E6GbnSmH8C36pFLmfgT3A/SXHz3ZY8+SohVHacXzROUmYBYUAZGcfZdm60oO8GZDR9NYjReYh1hpYlim+FTGWkVS/fgIptJwlzGzjxvASlyzW0Fv7fUrVYE4SGQ4rbDI298nOt57t6kBYLrBe6u1Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y6KXF1uWIVI11izBQFcSVWH9rhuerFPHFLOZqkRhHLs=;
 b=yDpyt6WbMKwwIrfMdXLPUC3670GE54G0bme6OhFQlKa2lzCCyqvs8CFsseHJ/rCxqk2yycd2EqWw03rJybbVNlPpyvrBQWIWWmzFiAQ98WRBJoxsK8Fa3E9Xrnsyqq5SeGyVVMyTWkX7DW/VdsHz7blKUVG217JqWJGQXSbgDZOb3pAhalykUMv1ljlbhLQxILDt/CDk+RvKRXHegKJ4kOjoZ6asTRDvUn//wtEyrpxDO7qY2AqYtEQQ+unRJgznqFX26r0hBMyc10L5kcf5T0BqPm3riDqVdalO3RD0e76xmBWKU/o2Wt8F1Fa4WN+3Q1oGSLLjtXfgPH4ajIAb0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB8805.namprd11.prod.outlook.com (2603:10b6:8:254::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Fri, 6 Dec
 2024 07:52:43 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 07:52:42 +0000
Message-ID: <39a68273-fd4b-4586-8b4a-27c2e3c8e106@intel.com>
Date: Fri, 6 Dec 2024 15:57:39 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
To: <joro@8bytes.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-9-yi.l.liu@intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241104132513.15890-9-yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0007.apcprd06.prod.outlook.com
 (2603:1096:4:186::9) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS7PR11MB8805:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f494a43-ba5a-4419-1fe4-08dd15caf6cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U1htS2g5NlFkc0IzKzVmcXVGMW1NNEs4UTcxVjFWbWhuVGp2T0pjKzhJdE5m?=
 =?utf-8?B?SFNqOGxRcDJ3NVNuczAraDYyU3FMWlFxdzRseFU4ZmZ0Z1dROUt5RWJtaEd6?=
 =?utf-8?B?N1hjRzJLbDQxb1B6WS9oY2c5OUVTb3NSYW9JRlVSWnpkaXJ2OWFXVUpnTVlJ?=
 =?utf-8?B?Q2ViYWlOWnlWV1NRbGU1MThEbVpBYmMzZmQrekVXY1VaYWVPQytjREtjYjFx?=
 =?utf-8?B?QlkzWkNGeXk4Y1dyVytqRkZhenpWdWNVKzl1clgrQmVOeXFzQUFPS1g4ZTRK?=
 =?utf-8?B?NVJJNXFhbmZmdzY0RENjd2JRTEtXMHBVcEwyQmNhSGlVMnFHZFE2SEdWbjBs?=
 =?utf-8?B?ZnZOK1lmRk53amViUTMrUVlMTlhkenlSVS9VRVFYUFRDeXQwWFM2VFVuL0h5?=
 =?utf-8?B?OFptcDVTK0EzbENuMFNKUUJxWmZvRHJSQnQvbnNpVXZOa25kSWp5eG9tMDdC?=
 =?utf-8?B?bHZsaTlGM2pHckF1bk5NSVRBMnFlb2VLK0Y5SzB6YmRYODdRUnlCK2pSc0ha?=
 =?utf-8?B?M29xQVo4RHJScFg5SzI2YlRnZVg4SXQ2TEkvOW9wZ0tCQURBeG82TEtKbjcw?=
 =?utf-8?B?ckRZOVM3cEt6L1VqbGxWZWMzOC9NcVRhcnYvYUgxcjdqeG1JVUtoalIvSWRK?=
 =?utf-8?B?dUZPWm1jWHRoOTZZWFFhWklCZmZQTldESTFBZkcvQjJ1YThuSzlGSUV6VFRF?=
 =?utf-8?B?clpuNjBYb0ptcFh6Y1lWc3dVemp0YkVGTFFJN2UzckxBbm1UWSsyYVB4Z2U2?=
 =?utf-8?B?cXBKeS8xN1NXZzhxbzhNUklPOVQ4alR5RmJYRWh4QS9Pd2tBTkcxT0Z2dVZx?=
 =?utf-8?B?ZVpYOW92TUdhbnF0MXZ6ME9oUjhBWWN2RGw4em90TEVsaGJWdWRlSlBpcXE0?=
 =?utf-8?B?bTA5bGJZaS84SnZNMmljVk5zeE1TaDZ3QkhPdVRuSnB0NWJ0YytpM1AzZDZy?=
 =?utf-8?B?L1p3ZWQ2QUZVUWErb2pDbUJtOFEwQjEwS3JrTTF5SUc0WEpZUEx0aVJzaGhT?=
 =?utf-8?B?ZW11RlJoSTdzL09uV0ZzZGVPS3lLWTZBTyt6djgxRmRhKzNBcGkwelpRL0RZ?=
 =?utf-8?B?cW5rcm9ycW9KR3lyYjZQYkxxRkRMQUVXb3gySjdONmEyZk9UMTNoSmxWM3lT?=
 =?utf-8?B?U0RZTmR0cksraEhMYVdIYVllOWJqZXl0UVArZUVxNFY5Q2hIKzJ6SGcyM2t5?=
 =?utf-8?B?bXhjVS9KTEhieGVNdC9WRlhJUHdNeENxemdiaHBkUDRid1d6ZnowcU9ha2RH?=
 =?utf-8?B?bUxWUzRldGt6NWs5UXRIaGRKWG1ISUFRa0ZQeEJDdGVVc1Znbm52TDNQUEpi?=
 =?utf-8?B?S1JuSmI1dW9ETDdlUXU5Y2l1MHFxMnBaVjlqZVplUWJWSzBqazRvK3pyNllB?=
 =?utf-8?B?bFdtVTEycDNXVExWYklxU2sreUwxdzFVQ3diZGF5Q3BqdElFZmVKZWpqajJa?=
 =?utf-8?B?NXNGTjU3WGRFaHZQTHg2dEd0dVlCOFcwTHdscVRpMlBMWUpsbnFkRUZBQnht?=
 =?utf-8?B?RkRNSzNwWHpiRWdmRWhjM2Q4N3JsQnZ2UXo1ckUxN1RlS3l5Q1dxeGdzVEgz?=
 =?utf-8?B?L2FQYmUvNEpDMElQTTRUb29OUXI5ZXVTWEV5a2lFV1ZjRzdNTk5UVkNQaFJl?=
 =?utf-8?B?MkJDYW9NL0MwRkp5ZXc1L25HUHplODhiOSsvWC9EeUMxdDA0NlJ3dkx1a1NF?=
 =?utf-8?B?TnFvY1VoNXY1YlgzbDhRS0NyODBxaW81NVlxaWF2WnA1VE4wVTJ3anZ5bjB4?=
 =?utf-8?Q?ZgnaQJinJpmyjyDA0Q=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWxmYnMxSUNNYW9vM256K05TbGx1eFR6L0tnWXZJVGZDZkt5eXZnN0o0MXpX?=
 =?utf-8?B?Q2JtdEdjZnFwT3ZwS2czRlRGaE81V2ZiRTdLdnNvVFA3N1hHbGYyTGxMc3JN?=
 =?utf-8?B?Z0Z1ak1PdHp6ZnI5SGdNVVJjU2hBZlR1KzhRem1KNnRLaVVLbEdrVkl1N21B?=
 =?utf-8?B?d2dzejA0bEdqaHUvT3I1Ykx6R1F1Ymp6M3hVeEFHZ3NLK21GTG1sYlk1ZDFQ?=
 =?utf-8?B?cU84ekhxOHlQVXdXd0JrUVRiNFJyYlpCb0pwK0tDa2pCM3hWazRhbUlNSXhw?=
 =?utf-8?B?eDQvTFc2NHlPZmRhaFpxb0dRVDdHU1dOMWJBMGI0eFk2eUpzdFRoaVVDb1Bt?=
 =?utf-8?B?emRTYm1oYmxMeEZOVnpuc25weGkwQllRTStzM05lT2tNUWlmTUN0a3lZTjhR?=
 =?utf-8?B?TTUwRU0ralZjSHJYcjBYYnNJSmhxUXJSQy9WcmlUZ3F4UUtDMWZCT0N1bzd3?=
 =?utf-8?B?OGsxUzJDYmlvV0tVNlptbUF0cEpoZFpFcWtUOC9XRzNpRlFYYXRsTmdmL0VW?=
 =?utf-8?B?RTRta21NY0VmYXJWY0l0ZFEzazJDRDRsU3pTVnJOU2kvOTR1RXR3OGM3SGVL?=
 =?utf-8?B?Tk5UTDY1aXp3QnFYUGVzaE56a25hQnRrdWx5VGVsWGNhb2IzYmZBRkRkOTdB?=
 =?utf-8?B?b1ZnbzRUWkVjNFNzMjU1d3JsU2V0ODFEb3hVaFdmWHltaW81VTZzZGk3V2VX?=
 =?utf-8?B?WFZPWjFLSFNDenRBL2JhUXQwOXZtRlQ1L3ArNEFOS1F1VFQ0WDludDBZRS9h?=
 =?utf-8?B?OVd2ZWVjZGp4U0h3dTVudHhPQjUxMFNrVDlCc0NRM3BrdmhFMjNxSFJlcnc5?=
 =?utf-8?B?dDlKMmd4aDJVU2tocGJLazZralVtTVhoMHVYVjZrMlRxN0VkUGpJejFNc3Rk?=
 =?utf-8?B?Y1lZQUhqVURCcHRIMTFLMSt6UTQ4R2JWWDZDQVVVV3ZrMEJuSDBwdm5nV3Nz?=
 =?utf-8?B?K3k5VGdVNFZZQm50TS8xRzB1TEl2TzJJK0N3TjBwV1BCdUhZQVAwYVBDaWtE?=
 =?utf-8?B?YXVLVEhpcURPUktqWmM1aVZYb0lnL3VjcnpOa05YV2trelJDcFhLejN6dWdj?=
 =?utf-8?B?bVdmcVVDcDlKRmJTRXNvRXhyRGxGNzdRNWxOUDNjSEVLUEVqYzVuNEVER1FY?=
 =?utf-8?B?WERwbHM1aVNvcFc2UmJyeU1kY1kwUU03elZud0NESENBZWJVd2JIUUtLbCtJ?=
 =?utf-8?B?YzlNcHdiRDZMUEVBT1JtcnZKcWpwNUlCRk11ZnJUK1VoTHY3aGtrZG5YdzVl?=
 =?utf-8?B?MlJYVlRQZGpST3BkcHdqbWNuQldtS3FPblpGaUIzaXRaTEl2Y1c1SVFNWk5C?=
 =?utf-8?B?d0RDeFBvVHVndkpNSE03cXdmWVRlY3VvZWpONFFXTkRHODVCT0lTWlZTUGhn?=
 =?utf-8?B?c0dIRG5FUXM2L0FLdW5GTjN6V1NIVWF1cG9HKzNqczJmU3RBSC9mUThpWGVn?=
 =?utf-8?B?QnU4T0NuUjF2eWU0WHA0aXhidElBVWRmQ1dvcmFVNExlbmJtUTdmSlF4bEhI?=
 =?utf-8?B?NVVoRWFqaFQxS3Exek85RE9jTXozL1JPT0ErWm5jQW9ncUtJdkFURzJERng5?=
 =?utf-8?B?MXZDbUZLSnhES0ZkUER4RUhza1JRUXNrREhrbmdLL2poZ0FBaktRNmt2cGlQ?=
 =?utf-8?B?aXNXT2YvR01idG1QUm9HL1AxWDU5OW5pVjd5TGJCZk5abVcrUFNCbW9wOTlH?=
 =?utf-8?B?V0tKR1FHdzIvMlZiYzVRSCtnMXh2b2djQUwzTlA4NWpDbUZNU3psdm45MUJz?=
 =?utf-8?B?U0JBV0FjS2luQXFDZDlaaHhiLzlseWtBc24vMHAya0JCMlQxNzdYOFJseFFk?=
 =?utf-8?B?czVaTGxEV2lMeHMzbXpvNCtYWkpDdGZPRVBQKzYxWXNwYzJyeUsrbTRLWFNk?=
 =?utf-8?B?RHZLSmJGRzdERUp1dXRYU1huVHZVTTlxdU45VDRyVVRiM2t3SkFDcURTb0RJ?=
 =?utf-8?B?dy9rK2pNd0pkQ20rZ0ZqbDVGU1JRdHVENDE5TUFENnJjZzRsbWNnTWNXeCtF?=
 =?utf-8?B?K1Q0OHRXVXFGUFVjeWZQeHZ3c3ozRlk5N2RmaFlLeTdkWTRXdXdWblY3L0h2?=
 =?utf-8?B?QUs3K1BnNjJsZ3RwZlBYaEpNZm43LzVrYmRHS0FDRVA1OEF3Z2JVWG9iaXgr?=
 =?utf-8?Q?h9BNvFSZniakE8YiNa8Fg3zca?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f494a43-ba5a-4419-1fe4-08dd15caf6cf
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 07:52:42.7882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T6TpflQNKXA8dqaB/p4DuW7i+qje69iY41hYB1JVNFNdGz2r9kAWfwP1pPPKA/5m/O5DzrGTgPf0UQgBIDXjYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8805
X-OriginatorOrg: intel.com

Hi Jason, Vasant,

When cooking new version, I got three opens on enforcing using
pasid-compatible domains to pasid-capable device in iommufd as suggested
in [1].

- Concept problem when considering nested domain
   IIUC. pasid-compatible domain means the domain can be attached to PASID.
   e.g. AMD requires using V2 page table hence it can be configed to GCR3.
   However, the nested domain uses both V1 and V2 page table, I don't think
   it can be attached to PASID on AMD. So nested domain can not be
   considered as pasid-compatible. Based on this, this enforcement only
   applies to paging-domains. If so, do we still need to enforce it in
   iommufd? Will it simpler to let the AMD iommu driver to deal it?

- PASID-capable device v.s. PASID-enabled device
   We keep saying PASID-capable, but system may not enable it. Would it
   better enforce the pasid-compatible domain for PASID-enabled device?
   Seems all iommu vendor will enable PASID if it's supported. But
   conceptly, it is be more accurate if only do it when PASID is enabled.
   For PCI devices, we can check if the pasid cap is enabled from device
   config space. But for non-PCI PASID support (e.g. some ARM platform), I
   don't know if there is any way to check the PASID enabled or not. Or, to
   cover both, we need an iommu API to check PASID enabled or not?

- Nest parent domain should never be pasid-compatible?
   I think the AMD iommu uses the V1 page table format for the parent
   domain. Hence parent domain should not be allocated with the
   IOMMU_HWPT_ALLOC_PASID flag. Otherwise, it does not work. Should this
   be enforced in iommufd?

Thoughts?

[1] 
https://lore.kernel.org/linux-iommu/5a6c2676-256a-4fa5-b9a0-e433d4e933c9@intel.com/

Regards,
Yi Liu

On 2024/11/4 21:25, Yi Liu wrote:
> iommu hw may have special requirement on the domain attached to PASID
> capable device. e.g. AMD IOMMU requires the domain allocated with the
> IOMMU_HWPT_ALLOC_PASID flag. Hence, iommufd should enforce it when the
> domain is used by PASID-capable device.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>   drivers/iommu/intel/iommu.c             | 6 ++++--
>   drivers/iommu/iommufd/hw_pagetable.c    | 7 +++++--
>   drivers/iommu/iommufd/iommufd_private.h | 7 +++++++
>   3 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index a1341078b962..d24e21a757ff 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -3545,13 +3545,15 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags,
>   
>   	/* Must be NESTING domain */
>   	if (parent) {
> -		if (!nested_supported(iommu) || flags)
> +		if (!nested_supported(iommu) ||
> +		    flags & ~IOMMU_HWPT_ALLOC_PASID)
>   			return ERR_PTR(-EOPNOTSUPP);
>   		return intel_nested_domain_alloc(parent, user_data);
>   	}
>   
>   	if (flags &
> -	    (~(IOMMU_HWPT_ALLOC_NEST_PARENT | IOMMU_HWPT_ALLOC_DIRTY_TRACKING)))
> +	    (~(IOMMU_HWPT_ALLOC_NEST_PARENT | IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> +	       IOMMU_HWPT_ALLOC_PASID)))
>   		return ERR_PTR(-EOPNOTSUPP);
>   	if (nested_parent && !nested_supported(iommu))
>   		return ERR_PTR(-EOPNOTSUPP);
> diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
> index 48639427749b..e4932a5a87ea 100644
> --- a/drivers/iommu/iommufd/hw_pagetable.c
> +++ b/drivers/iommu/iommufd/hw_pagetable.c
> @@ -107,7 +107,8 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
>   			  const struct iommu_user_data *user_data)
>   {
>   	const u32 valid_flags = IOMMU_HWPT_ALLOC_NEST_PARENT |
> -				IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
> +				IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> +				IOMMU_HWPT_ALLOC_PASID;
>   	const struct iommu_ops *ops = dev_iommu_ops(idev->dev);
>   	struct iommufd_hwpt_paging *hwpt_paging;
>   	struct iommufd_hw_pagetable *hwpt;
> @@ -128,6 +129,7 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
>   	if (IS_ERR(hwpt_paging))
>   		return ERR_CAST(hwpt_paging);
>   	hwpt = &hwpt_paging->common;
> +	hwpt->pasid_compat = flags & IOMMU_HWPT_ALLOC_PASID;
>   
>   	INIT_LIST_HEAD(&hwpt_paging->hwpt_item);
>   	/* Pairs with iommufd_hw_pagetable_destroy() */
> @@ -223,7 +225,7 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
>   	struct iommufd_hw_pagetable *hwpt;
>   	int rc;
>   
> -	if ((flags & ~IOMMU_HWPT_FAULT_ID_VALID) ||
> +	if ((flags & ~(IOMMU_HWPT_FAULT_ID_VALID | IOMMU_HWPT_ALLOC_PASID)) ||
>   	    !user_data->len || !ops->domain_alloc_user)
>   		return ERR_PTR(-EOPNOTSUPP);
>   	if (parent->auto_domain || !parent->nest_parent ||
> @@ -235,6 +237,7 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
>   	if (IS_ERR(hwpt_nested))
>   		return ERR_CAST(hwpt_nested);
>   	hwpt = &hwpt_nested->common;
> +	hwpt->pasid_compat = flags & IOMMU_HWPT_ALLOC_PASID;
>   
>   	refcount_inc(&parent->common.obj.users);
>   	hwpt_nested->parent = parent;
> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> index 11773cef5acc..81a95f869e10 100644
> --- a/drivers/iommu/iommufd/iommufd_private.h
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -296,6 +296,7 @@ struct iommufd_hw_pagetable {
>   	struct iommufd_object obj;
>   	struct iommu_domain *domain;
>   	struct iommufd_fault *fault;
> +	bool pasid_compat : 1;
>   };
>   
>   struct iommufd_hwpt_paging {
> @@ -531,6 +532,9 @@ static inline int iommufd_hwpt_attach_device(struct iommufd_hw_pagetable *hwpt,
>   					     struct iommufd_device *idev,
>   					     ioasid_t pasid)
>   {
> +	if (idev->dev->iommu->max_pasids && !hwpt->pasid_compat)
> +		return -EINVAL;
> +
>   	if (hwpt->fault)
>   		return iommufd_fault_domain_attach_dev(hwpt, idev, pasid);
>   
> @@ -564,6 +568,9 @@ static inline int iommufd_hwpt_replace_device(struct iommufd_device *idev,
>   	struct iommufd_attach_handle *curr;
>   	int ret;
>   
> +	if (idev->dev->iommu->max_pasids && !hwpt->pasid_compat)
> +		return -EINVAL;
> +
>   	if (old->fault || hwpt->fault)
>   		return iommufd_fault_domain_replace_dev(idev, pasid,
>   							hwpt, old);

