Return-Path: <kvm+bounces-46001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE82FAB076C
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 03:28:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75D9A4C509C
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 01:28:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA56B83A14;
	Fri,  9 May 2025 01:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ks82rUEW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD11A933;
	Fri,  9 May 2025 01:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746754096; cv=fail; b=RItqxsj1zzc90lkWcGAVu1Gqwx7o3KU5RJptOs4h34IRiZ0ZZ2sere3a7O7Pe0RHm/itb0kJuQweTxXb8vyW9n+A26t7wj1ajKnKNRGSiQYQ/Qlvb5hptxDP9uBS3Lr+DNRvlueZEhckjyKFFQQpVwag9tBSWFhw+4ujplEpz90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746754096; c=relaxed/simple;
	bh=4Kb3n8fH4xliAe6SCf88W8t1lDXNdDppPEDAmwTkSNg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=B3Ninhww2PieUZbnJT7LR1IUgd5VaBBcX1d6eMJK4HHqZb2iv4j9fk3SPjhaox2JCQtQUduJlJm2mtqtZd+yWti2VtSVip1pOYlYNloUYkr+xTLPhRGKhe5yUP7+jVgcu7dJW2QcAjHsxQ0keFViSyYI2hL2QyRhyn86K46JTKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ks82rUEW; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746754095; x=1778290095;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=4Kb3n8fH4xliAe6SCf88W8t1lDXNdDppPEDAmwTkSNg=;
  b=Ks82rUEWM5Blb3bPr47Qi6SdLu0IzsZrTNTJYnAxLk5NhtruNaLi56X3
   tt+lpEtPEusax9uiZest97LPOPoza/7pjvPQb+Lzjae0Jm6eMWcHSuzVN
   AeZqGm1vAW2ShT7NhR4lnVJKMTGk5BVdZ/QApCvDwCNlr/Zy/5EusjAag
   s3odWYd+M6P+04Ke4x7ZTwuA6ozHvJnFBz0Uq7w6FxjY7xAD4kNlbudYD
   BRNbIKI/odQxfxFvXV1cz7759UtjNkKVKXdVBqhqwvKTp7qigK9VxMsPI
   ktHMPWPa+H5VF9Dw5l6vt1e+pzaaFKcw2E9R4GiV81GG/XgdoO8PqBQOo
   w==;
X-CSE-ConnectionGUID: tgNGhvIlSJucz/mFPKwPGQ==
X-CSE-MsgGUID: RvznKEs+RXyJuD0MyOfO7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48436552"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="48436552"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 18:28:15 -0700
X-CSE-ConnectionGUID: Duf5y9/MRWCSyojeVDPoAg==
X-CSE-MsgGUID: Gi7I3fA/Qiu/tnxNE5s3CQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="167407441"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 18:28:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 18:28:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 18:28:13 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 18:28:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oL9GOAC560OBaDavhouFVt0T28GAbgkzq48ajjCfnj5vyzVTJexdr1W2PNB8blrCCl6RXPDR1ny26mFXmaE6B2A5qn3V2S6iMVRBcCYf/drHK416Z0RDeyqJkqoZ3JkkK1nqkSq79BVgBlZ15kEXVlzI8gwDFngYMTHROO6gFQLMKWh0R0LccBudpIer6rU8IG+QBSOeIhqrttGL6i9RynhD3vj2+8F/J8LSS1xyYFpS5mgZ4BBWBKNJFkOi49wWYACSoRzL3Hx22Ra3HXS+bVxhNfEjrrvtH0aH9iaLgqXsvo8+734vBGfjzNEinVcfG4ImANrq+eVSXvMAG/wO6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o2fQHl25oLIjF6M5lUH3o6t5T8RGXc37tRxeX/dzKrc=;
 b=PZn+3l3HummMeNEMC/IfaUBFSQ3Hp7mf6rSTVCzgS/dnLWa3uD0GrCtLFiRZKFmCQQpHTLqjCedybRgxMjJ9YrmYtv0xsMSIX47Vl3i6OCfFr9aXKJjFAgHOs6TcBMnL160LsdowvJitZTKJCwcZwBXUVlOB9cvC1J7qivnxYzgIdtsLpkWnJUdmeUio5NYBtHsSIddEmuOyBB1XV7Ufl9hsU0o5M9oZEpdxyLwNQzYTwliSAsIEYWcM8NzSSmFfiQlcaoHHjOyLv7v7+nI1iKJW3FQep8B7wtAaWCuTVijqSSCuQD89R0zy0tfZ6tc6fnZqQY2cACPc3k1O2yUdHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4598.namprd11.prod.outlook.com (2603:10b6:208:26f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.24; Fri, 9 May 2025 01:28:01 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.020; Fri, 9 May 2025
 01:28:00 +0000
Date: Fri, 9 May 2025 09:25:58 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <rick.p.edgecombe@intel.com>,
	<isaku.yamahata@intel.com>, <kai.huang@intel.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 08/12] KVM: x86/tdp_mmu: Add phys_prepare() and
 phys_cleanup() to kvm_x86_ops
Message-ID: <aB1ZplDCPkDCkhQr@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-9-kirill.shutemov@linux.intel.com>
 <aBn4pfn4aMXcFHd7@yzhao56-desk.sh.intel.com>
 <t2im27kgcfsl2qltxbf3cear35szyoafczgvmmwootxthnbcdp@dasmg4bdfd6i>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <t2im27kgcfsl2qltxbf3cear35szyoafczgvmmwootxthnbcdp@dasmg4bdfd6i>
X-ClientProxiedBy: KU2P306CA0009.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:14::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4598:EE_
X-MS-Office365-Filtering-Correlation-Id: f2030284-0af2-4406-31c2-08dd8e98bca3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6mx8ymkLMv92Y4igEoLGASGW50hfMq6B4/lq2WnNXGwALhE9d73SOdEv7OVR?=
 =?us-ascii?Q?Lh1pGuX1QHY0yqHyj7fTHt548a46qRT7+eZBrO2kvdfHALQaZYkBe4kctXHg?=
 =?us-ascii?Q?g4Ej3p8vjLA+uPeifVOpjNoBGu3Q6gMF3n9RgOoeECWSSSxfhxcKaXh8VQai?=
 =?us-ascii?Q?aPZOCExNP91Rs/xpd2Dcd3g6GhjRfyNx5aFD2Dv1SNC+9CWQ76zJfZIkxwt5?=
 =?us-ascii?Q?YwsirQIS6u0S2ZPQtSF2VFkRccMRt0QoPkjOy4apwetanDstKVosroJjXcGf?=
 =?us-ascii?Q?5JciAw35zHIa75NODzBmH+3qwQN+qSflh+B2ML051Ukaqfn+/iM71xvxThRO?=
 =?us-ascii?Q?f0RTuleuUUH7mUSrrEpx1peRH7AJ67cVhT0ksrCt6gKAjLlrsouO/AqK+q+7?=
 =?us-ascii?Q?VUCmGhHgKfbpBnPTsJPCLvGbdF6wPQ34qj2t3EpIXpFck3lsVHZNjeUgrMDY?=
 =?us-ascii?Q?ITukbcOcLO1bgOAxCnaVzdrm3GrUSyXWtDWITCZMatuaWVG144z2pV+3a5WI?=
 =?us-ascii?Q?RH38zzl9WgaCW5ZpkLYShALjE6Le2mgZCRsgwLOCuvw5wlPNvF8bgCvhDW0Z?=
 =?us-ascii?Q?Qp50jACRqNjhD1DiazTnw759MtB50II+MnqzliYZhfhZflR01E2opXw+jsWo?=
 =?us-ascii?Q?DwTLbn7Y+Rn3qurIjRAQn9QHBdzzQN3YYetCDtTbZeGt7n/CW1hxhtSlAYdB?=
 =?us-ascii?Q?fMBqM+kMwFgNxyPhHRshKUq3bq1Pkd/gLLSajhKKT6slSJZmUd7YqN2SLI73?=
 =?us-ascii?Q?MPKayTx2TMmpVzgI8O3cHsakOCnyoVQZMCOc1oA35+QJR23NyqTbC3MVhcEJ?=
 =?us-ascii?Q?TvZCORipnZoYKynicp+mi4QTsCFEuCeEn7jGwpIyQABS+QryiQpbcSf0JA/N?=
 =?us-ascii?Q?9RRfs4eajVPgZAhox74+fKN6OOlTSPSq9vTEA2aGWlIvKOtT9Qg601CtD3so?=
 =?us-ascii?Q?pTPsv+UVpxn6jZJcdoeDX5Kj3sU75A9xlxCVGoBrjYvYfxsbV/ua1R/tb0Oz?=
 =?us-ascii?Q?vYvoOxmyoBkQam8CpAbYScFDJITUrr3ZL9MVBCIjAVLHyEhjcCnQg9GtQKw6?=
 =?us-ascii?Q?/U+o2s6wOu/B8TMWEzBeA3AdHsu45SSaYyX+mcdlP6J4zFQ9ZxkVttYHUqa2?=
 =?us-ascii?Q?tsveZm0EqDxvfTRsWKwN7GITbEmo/EHnOX31IknpRpPNG9nLrOGdrEgDlfsB?=
 =?us-ascii?Q?9bfznscYOcHhHYefH1pwNUlOO4GbL65Qr6NRFjvedrNPzU0iwDe41jTPYkZM?=
 =?us-ascii?Q?5VO2mTSNdm9t5uae4TgnJ+OGDAybZXtAaMyhbW6OteWQDRSR1pHXpvlJ6RgQ?=
 =?us-ascii?Q?kJLeLMkCifKpX66dQLfl6kWOrDwgnW87QO7phsmi8wcx3Ta3eoUODgOt5Eg4?=
 =?us-ascii?Q?r0dyIg7+rkhSB2LgRtLAUln8/yK+Rz4etPOZNvuj1mZqiR2LF5Pz+aqO7Z0h?=
 =?us-ascii?Q?+49PBQ67F/c=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HhGWvwDf2fFFtDeBhTDQ8GhvYD8Nibon3JZU/ZUshpu7C6cMwGQKYF+4yCIZ?=
 =?us-ascii?Q?OBdzvp54eRD+l447t8QKca0dfeoSPHMwim8g9WOnzejwbPpt96sfDE7MVP6s?=
 =?us-ascii?Q?g2VIioYM2OOng26WKaQ2dbqqjWG4+1vd+qUz06lM6tK5zoymJZLcm/9lVkDU?=
 =?us-ascii?Q?J+tV8OCXKzBLXiQJvBGgLcStOax4FgtZDGHeBRoou0tRCpw1pQssOriobjdW?=
 =?us-ascii?Q?bEYe48U/HKMHiRavRRTzsDx8CngzuVpx7UFSkct4ZjBSXPKAKB1YlhDgtVgg?=
 =?us-ascii?Q?UYjZA6vENz514LTwvhumC+mgIwvVR6XvOhUFR1ezbiJw2WK+RwH+Z9xKPdop?=
 =?us-ascii?Q?YdVqgOan8MYMOrvkWZUxnFFKcWlOKnu6SWHTpF7d8y2OnuY7M0VLbwLHpEfq?=
 =?us-ascii?Q?OVl9f/FJQukSQTiOLFCShE5U6L9GxN1sLr3FkazZdo8yJo1nTb467slbjoEB?=
 =?us-ascii?Q?SFCU3/UfWamuZXiMbIkl+5A2vIdVel0vw3K6BwHwg8BFQj2Z7Qj1Up4BiBLX?=
 =?us-ascii?Q?dxSXNdYeal9EgTAKablgSbWCUDGsrU6n1mhR2KwxbsE06pD+Y7MbXQTAfUhu?=
 =?us-ascii?Q?REsjKvGBV4nyLsFt8JVUqfaUCU7EcZH6xLy+n7MiIxlLVpoSm1CxNPkG0V8B?=
 =?us-ascii?Q?Ghf0v+6oxjgD8nqf53KLZ0hWCC9Gca2phI8YYQuztQ+GEZ64AAV6BfkI+7tQ?=
 =?us-ascii?Q?9XTKXB7/y6VKyzIO+ZkMIADDQ90w1opExxKdvgbzihhPLZdr9o+1anhlG0IR?=
 =?us-ascii?Q?Mwc18plrn3c9SyeftLMafqhrYsam3ds9g+Vzq1/uNz7zIWN/BrKyLQ0GizOq?=
 =?us-ascii?Q?CA/F5pSiM3KziU6zvzuM9JHoKnjAIeB1RMgslrUNjgYW0xIvm4mntw2yCkCX?=
 =?us-ascii?Q?2YxCFoM6ubkgIEk0GCXdms8bxyLl2MQpH7EJ3u5xXkT2JYD20L0LJYGH7LLQ?=
 =?us-ascii?Q?RyOES8GPtfIoiIbykTgGERxbJP2NCskRga/El1Sx5vDBPsR6SkL6LhhTLo2s?=
 =?us-ascii?Q?DgR4w+fEu4Kxhwlb+IbQ4A2K8KLSp2qvBpLuxZIq1XbPMKPfa0vid64H/2Cm?=
 =?us-ascii?Q?vyUZn+J9jOqLvqkpYNsLUz/p/0cdGtpLj1GEfzReBPYNCo7L59RtdX1k7CQg?=
 =?us-ascii?Q?/dkJA+ZpsE1Tsm9oSE5B3GEWreQOkOa9MoXtZmov4AQt/rsTmsoNnQ89+XDY?=
 =?us-ascii?Q?rk6bbPTxCj0tdfT21kkErBkMb8QPN7/svl9Dq6HDmbJdRg7kftW3XvDPUBSS?=
 =?us-ascii?Q?3UTbdpFwjqAW0io5pbelj3QFnTqc+e9ZxjLdEf02j8kFKprlZTVVEhE1WFVM?=
 =?us-ascii?Q?Vy3MzoxZF2t8Fxa6IaK+iTrbrXVMizBl4Gbl3dYUMu8X2fC5LtbticSN7PpE?=
 =?us-ascii?Q?Z1IalMt9NIdrjFVDQQRs9nDMr8ZB690mcwzpVHauIKAnVh3dvEMfWkIryXCx?=
 =?us-ascii?Q?2qfWSoJrog+AJ14Ffo94frsGqfb2P53kFoY+/gPnZrmsyYfg9FYIDAezQJYG?=
 =?us-ascii?Q?by3qgCaBXm1XQwcPYMj6AdM2IbOD2TJb9EwwZ5bR4FgjetV+C6VPGaXAQrLw?=
 =?us-ascii?Q?oH4Rd3r9/0V+wmrOef7fTsxdzMEMN3RvzqSCN1Fi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f2030284-0af2-4406-31c2-08dd8e98bca3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2025 01:28:00.8929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ih50d3aRHTH2SSqq8dH/sKuLWn1LjS25VYWzjzJ/AEmk+4yJHI5+kkcXNId3qbZB2G26TnYBBo+H/xIb4daxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4598
X-OriginatorOrg: intel.com

On Thu, May 08, 2025 at 04:23:56PM +0300, Kirill A. Shutemov wrote:
> On Tue, May 06, 2025 at 07:55:17PM +0800, Yan Zhao wrote:
> > On Fri, May 02, 2025 at 04:08:24PM +0300, Kirill A. Shutemov wrote:
> > > The functions kvm_x86_ops::link_external_spt() and
> > > kvm_x86_ops::set_external_spte() are used to assign new memory to a VM.
> > > When using TDX with Dynamic PAMT enabled, the assigned memory must be
> > > covered by PAMT.
> > > 
> > > The new function kvm_x86_ops::phys_prepare() is called before
> > > link_external_spt() and set_external_spte() to ensure that the memory is
> > > ready to be assigned to the virtual machine. In the case of TDX, it
> > > makes sure that the memory is covered by PAMT.
> > > 
> > > kvm_x86_ops::phys_prepare() is called in a context where struct kvm_vcpu
> > > is available, allowing the implementation to allocate memory from a
> > > per-VCPU pool.
> > > 
> > Why not invoke phys_prepare() and phys_cleanup() in set_external_spte_present()?
> > Or in tdx_sept_set_private_spte()/tdx_sept_link_private_spt()?
> 
> Because the memory pool we allocated from is per-vcpu and we lost access
> to vcpu by then. And not all callers provide vcpu.
Maybe we can get vcpu via kvm_get_running_vcpu(), as in [1].
Then for callers not providing vcpu (where vcpu is NULL), we can use per-KVM
cache? 


[1] https://lore.kernel.org/all/20250424030926.554-1-yan.y.zhao@intel.com/

