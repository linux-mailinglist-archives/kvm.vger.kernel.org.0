Return-Path: <kvm+bounces-65083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 86E5BC9A525
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 07:33:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 701B34E2B42
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 06:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C98483019DE;
	Tue,  2 Dec 2025 06:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rb/LV9q2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C384A2FFDED;
	Tue,  2 Dec 2025 06:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764657175; cv=fail; b=IHQBj1a62ITd8DdxX1HfzN/FHjES/jnKuxIzJHco/d7Tih93+47skdGqZZcPTw8X0oi2x9MIr2yrikoJLqsH2BgNgdJMojCdi8sxWjwf/8IW+PLhseoeIjT9wfRAmncu4gPeGN0bbq29f5yZt8Szio7NarBl6/poJH4eowapAdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764657175; c=relaxed/simple;
	bh=gOuspjjQWMFH8HJGAIdyrjLAWQGALl4CviKL1fUN55I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=F0aSCrynDiGhWml5j6epXBUs91+6lLzk8Lam0TQVkZSeHCP3uqHoWBPdLVZS+r7TI28X3vLf3AVbK/nlAVmHL3MmEHwNnxPP/OwDiWWOjQQTTwvML12BYgWUSsoqa6jwR3RObA4Xp0XY0w/3w792mqNzoVb9EITi9VhJrSxdkws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rb/LV9q2; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764657174; x=1796193174;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gOuspjjQWMFH8HJGAIdyrjLAWQGALl4CviKL1fUN55I=;
  b=Rb/LV9q2PpouInBy/6CSJuZbvJJSa2Ypo2Kg9HsH8Aejvwc49PkH3vEH
   +O0eC8KA/DurWDdP2y3MEhadfCNSRgjdyqbMllv4dm+5wcDdq77vHI0Di
   5PEDNwPXvgIG14uwkv2m8q/kmM0fHqglopeNdKWiHd0duro/eMzb6ZNoF
   WjKO0L1gvUNu8PV2zeI8CzoyAzVOWzrOOngdRndblyz+FmurAkVzZn/5z
   Ccqa31L0e7ThuH9o0jxO7zNtbByXuKnM2e96qznY8TJWDEE3r1A9gWGaU
   TryPDHOSWPWsYwJpatb6X8G4vN5JAxJlmJA1jMgkOozvAaF51TXf0hT8c
   w==;
X-CSE-ConnectionGUID: uWWr+RyzSgK4NQKiFCE3yQ==
X-CSE-MsgGUID: +WVLOMRMSSG1yZSkjF+oIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="65616635"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="65616635"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:32:53 -0800
X-CSE-ConnectionGUID: +roHOMbGRHeKt0jwShvRVA==
X-CSE-MsgGUID: 5nb33bO5SEa2d72Y5ZzWfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="199413435"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:32:53 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 22:32:52 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 1 Dec 2025 22:32:52 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.11) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 22:32:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z2yy3PalYifGqmoq4auXx+1guduTB0Jsj2rdjnSElv2c3ZJCHh3dhPBXZIm7JqGmg5Bu7PFxEJej6B20+hRZqUpCTrhWb/SzaxlemZfNaamsuUG13uabZpqeatYeMpUVN1wv8NwW19C6jgkaNKco971J/FHs1lJ3wYJMVnof/F48FD0pydZM62rfIIjp7bTyTlMMCI+fgQIprJaqmDAhi9Nwh2pS1SSIDt+FSkWbAuJKcL6N4ZdqxTgeGreRs/Pn0E6iRnFMJlrSy2oSGH+8FAf/ujhGnBFTCnGR9h86+il8ThY6yJpqqdkbfZN/TDCC8HzZ87SJ5MdpNivHYeY3jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOS2iQ+fQzk+Xt9l90gZSVDV5835qx6IwTsyF3dweH0=;
 b=rwcAydBt6KXKcbuveE13Jeo7P1QbcuIDkHwk2nsSRQ4zEohkQajVZ5dIjvUoGLvlibB/6aliAYvrOsb/f5sLqx8H/wAVpwwr05LY6o27ietdSPjWO9HUY/jf3fWp8kGmCCrWYtYkWIpnX7LyXJ8r7s2qgXe0wqjuFCL9JNxT3JowFMKZBnosWgKT+X9fmYavnD1MKaE0wlhd4PnYl47dVD7LmCILZi3WbpZcjS1TVUfBptjcxT7ChCgwy8FgEUBTv4hU1JCulmEo1CWaex8tb6OXdspwLc2ga10SRbf2Bajm2PwLcBFseifklzUJ8cxf669XxH+/O4NmsSrdYfx4yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ2PR11MB8539.namprd11.prod.outlook.com (2603:10b6:a03:56e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 06:32:44 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 06:32:43 +0000
Date: Tue, 2 Dec 2025 14:32:30 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 19/22] KVM: nVMX: Handle FRED VMCS fields in nested
 VMX context
Message-ID: <aS6H/vIdKA/rLOxu@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-20-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-20-xin@zytor.com>
X-ClientProxiedBy: SI2P153CA0002.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ2PR11MB8539:EE_
X-MS-Office365-Filtering-Correlation-Id: 8632d6be-1588-40be-d295-08de316c9986
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?k0k/l9VvvV7TRew8e7n1uuE4U+yD76bIsQWu7OHdOK9TnW9qZtpBz0SuyZTH?=
 =?us-ascii?Q?kltQSmLpynZ1DMPc2Xpj0vzxzBYfS1jPE+lU1tOFu60jssGGJeduz1c2hF6H?=
 =?us-ascii?Q?TBUafI/O08Qc7TfQoQF/njNqeDIUw/0X2ei5Fqwlr7/hkoVTjOPW+uJe99QE?=
 =?us-ascii?Q?vaBr5yhl3SUc2ltJt/KUdUs3RzMdl+caxz8xDW1Le/u2M8+cILS0RpxPbl51?=
 =?us-ascii?Q?AhUgm5PwcwfgZUt6AblivvyD5sNJIGClnOeuV9M2wclfR4KbCJkk5jIgMzLm?=
 =?us-ascii?Q?U2WONHfBkzFqy06fC2fyacUfuHGF73OyepM2Bn3EJL6ih55OmjC3jhY10g7I?=
 =?us-ascii?Q?RnPsSVXhJ4UvP7/KHMrgVnzXZxI9DKysi1cAxQQg3cAapO2s2QqJ8XTdVhm6?=
 =?us-ascii?Q?NBesB+R0oykLQQYmm52ov4yLxcmGB7VYfxqGMvsr6Qcq9XE/Dev3npYeJ/ed?=
 =?us-ascii?Q?acgcfrWj5GgY5WhvkBR7Lyodt/mSXeWnbN5Hh2snKIJdv6fi/F9NajStUWmp?=
 =?us-ascii?Q?72XhLJohhSP0wlwDtbRaXHQvDPKnI2zdX8qgomY+AuLocxV3nuwL7jttgUF5?=
 =?us-ascii?Q?cIkmSSWElVbfwND0DlaBmmQ4Qf0rYiD2h4rDs6QTVH7KXoIn7abfGlkkw6y9?=
 =?us-ascii?Q?CoyCDoeF8oY80nYnh4T9JYlV9NkYuZKL9SpPTXc6/pIgCZanBRy2iCW7Vi+Y?=
 =?us-ascii?Q?l79jyC40n1Q+R0sk1u3R4PD5HiSL5L70DDNGi39pphSjPQLq/D0F2c2SBSGj?=
 =?us-ascii?Q?I5l8u4cRdIIerpe3e+y+ql5tCL0nV9yTu4QILv48+rYprECVQlED6h4BdpHe?=
 =?us-ascii?Q?mkTx50AXXcxd1Gl1sDTIaO9moddDCA1n1FOfgzOVJc/7EJzH9lyp/RL0ehq5?=
 =?us-ascii?Q?lrlWwnOqI7kZ0WkE8D9vnQk96lsNVIB7VJGth3K5/EjGoFbPgPaVfadasU3U?=
 =?us-ascii?Q?UjOxAXOp7KapDPceDab29OB2hDK4kV3nibx0Y90FVZt3YqdfVyBaIiHRa/pH?=
 =?us-ascii?Q?fGu6xwSsBa3PTnIen7a25wlq+4AabswN9S1o0cC14eo1vHgyF5oJHcLu6JQ9?=
 =?us-ascii?Q?H6NeexfmmErglT6nku/a5fSi1lch2AUQv1u0bGlM5/IFUE5HXEhefvakrt+J?=
 =?us-ascii?Q?rCG0+7UQRQFxMp5lUf/dhduTlzJSJxZEjOBzk9C4EjU3aY370CbO6/uUgZoC?=
 =?us-ascii?Q?OEJCO2g12XeY8GMN+uG07WXYWP+oTw/H6DmaPprykqfBZNYi+sHRhXTaTyy7?=
 =?us-ascii?Q?7NUBg6+M81ir5qloCwumwJzprJOt3j4V/i0M97Ym/qOHSg2fKpJQ6mWmRDwp?=
 =?us-ascii?Q?K8ORBP2LDcQPgPCf2Ae96dsnG/spR0eImXOe+qOdDnQFn3BvvILloZcLpglV?=
 =?us-ascii?Q?Hatkes7EYC4hTlPsQPeS8w7RFfMrTLWnqrLgJXoq05W7+rkC3Dy30UydKopX?=
 =?us-ascii?Q?6H1MwYW+ybFe7dvA1t4AVgQF48Q8Gpyr?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4YyjNDJr7gTFyBB+q8HXFzRvFuXHYHmKVYPWzby4YpNuM6ougZ0jOtoIPfW3?=
 =?us-ascii?Q?gNbdbhHgxZXhajLGc3MNbEDmrDjbzdd1Dnsfk3TdIs/cprdbI/hm3z27q99h?=
 =?us-ascii?Q?qHQB9KoyBlXrOsxu/HsuhoHfsDf9voLgSTCTjc18v7NO4PiS6igLl5hBkwAa?=
 =?us-ascii?Q?ttqo2bLwooElaJ+odZor7e5CLzDBW3GqoVysZP0+A/rLkaoUPSb771LmhPrI?=
 =?us-ascii?Q?wZa6uh8ZPejqjxsw9/ApsOTRUWzdzGRisJ0lodYZ3gReN7xpUV6ilD1v+N0D?=
 =?us-ascii?Q?Np3ozyGeNBZvxNW/3/VkMYv8X6n5vATlaNDsPSQwCJYaQaejp4PzOEGYPEaO?=
 =?us-ascii?Q?B1/AArAV8h7I9GnE1n0KhDx9ylKrgGZpAdojKlcuDaWJjywT/bG5BJkr/m+C?=
 =?us-ascii?Q?PgJXbYoLhzI/vqDBw/c4Gt10laT8Wa1Rd8jix+0zXM4gDo+d6mLV6JidPga0?=
 =?us-ascii?Q?tbCHyax5gdxUucg9zwyGTxHS3QmLTYDugoeC4Ds7dOQ48GzdJMOMBOe3Nu/m?=
 =?us-ascii?Q?wdTuETt6DuBmkagfH1IeWMmTCWX9u6HuBCR6ntxCozlA/qGjVJPA5S1YhcfN?=
 =?us-ascii?Q?85KEUQu5lsApba+hA68Wng3eKasJYuRS+TbaJtp0ikVQds+kA50UHZJnkawM?=
 =?us-ascii?Q?KfNNT5UuGcqP2P2kR87azu3iSHh63jWl6Xfn6u/Hy/2K5q/s08H6O80OzdPr?=
 =?us-ascii?Q?mR7kWDUlE7dxU1U4U3gCS2NobYxvCHOXdAyEgY//2ehtSaILrVKg4oa5Z6qU?=
 =?us-ascii?Q?c4VQ6y6OTbiGeph4uWCZzuwPsGXk718JRR5ziL3draN+SkJhUoMnC1fckogT?=
 =?us-ascii?Q?tOodYGYAl12Pg4nbl219KWP+Mc3PoZTqyNZTd07/oF88mgwEkVLmIbMwM07W?=
 =?us-ascii?Q?KlFRsjG3lIFACsThZJ3NnjAUDst3QN+NLhUW5erFXxUWxzLxiaAXS/lP4MlR?=
 =?us-ascii?Q?lmeYFMNB/1rhFeU0pnOVBe6N2lP4W9+aGhBT/1lAeaEZk6kvgoHMf8PGnAKX?=
 =?us-ascii?Q?C65hDXS1XbaFl7lbEDMDSoWGOZFvYgm4beo4DfvLn4Hwf3RqyKBp+L6qAu1h?=
 =?us-ascii?Q?6OgaanIFZrbZxogSImi+CCdyF9mMlIklY/Ot83QwklhabuzuzWZMHPqI66IA?=
 =?us-ascii?Q?2YhyVXrVvkvdjTPhqOF3p/hDp+nCBUeexVOFgARqG7kOQyzZZJru5fRwMz4u?=
 =?us-ascii?Q?Ecv5AdBX69JRhf3g6D2c+EeVciWnhcMIeNeOelAbbEts+LHrzkzm16VAW1LF?=
 =?us-ascii?Q?lP7/Eilc4nZPEXYOu5TaTWZ3E+sLj6malthzgYQAsUb44+4+kwYhq/QJ6uip?=
 =?us-ascii?Q?zrA/rntFL15dtTsocEUtR7y3/3a6N3HwyInRQgFBjRLXxInNYp2EJ0pFZBBc?=
 =?us-ascii?Q?u0aGZLuYdY+5xCpFC5/ZL9DcdqcJ+48yc57oHLLrFtXM0y1q0xsxxy42NYT/?=
 =?us-ascii?Q?xaXehBjMKqvwaSV/4EmEJ7mLl4fEIQOSh2vdWQZxUfKXe0+i9LWeO3VDxgH8?=
 =?us-ascii?Q?MJwh/TSAOwl95LIGQYKeYiolZRhsT5sO3UajUGVbfzq54E07IzqxJy9hBT1/?=
 =?us-ascii?Q?ocHre+0TMTVX4/BmbTcwvUMSPtdD3+bP7SQtAqJo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8632d6be-1588-40be-d295-08de316c9986
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 06:32:43.8381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NnvT4mIbUsSfGIh13JHJl0ImhU0BLuOYSi6HvROxZZ7IXfumnw2OhvJAfvFlj50TgSE4DntEvH+BDTAiw2itQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8539
X-OriginatorOrg: intel.com

>diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>index f390f9f883c3..5eba2530ffb4 100644
>--- a/arch/x86/kvm/vmx/capabilities.h
>+++ b/arch/x86/kvm/vmx/capabilities.h
>@@ -80,6 +80,11 @@ static inline bool cpu_has_vmx_basic_no_hw_errcode_cc(void)
> 	return	vmcs_config.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
> }
> 
>+static inline bool cpu_has_vmx_nested_exception(void)
>+{
>+	return vmcs_config.basic & VMX_BASIC_NESTED_EXCEPTION;
>+}
>+
> static inline bool cpu_has_virtual_nmis(void)
> {
> 	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
>diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>index cbb682424a5b..63cdfffba58b 100644
>--- a/arch/x86/kvm/vmx/nested.c
>+++ b/arch/x86/kvm/vmx/nested.c
>@@ -708,6 +708,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> 
> 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> 					 MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
>+
>+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>+					 MSR_IA32_FRED_RSP0, MSR_TYPE_RW);

Why is only this specific MSR handled? What about other FRED MSRs?

> #endif
> 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> 					 MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
>@@ -1294,9 +1297,11 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
> 	const u64 feature_bits = VMX_BASIC_DUAL_MONITOR_TREATMENT |
> 				 VMX_BASIC_INOUT |
> 				 VMX_BASIC_TRUE_CTLS |
>-				 VMX_BASIC_NO_HW_ERROR_CODE_CC;
>+				 VMX_BASIC_NO_HW_ERROR_CODE_CC |
>+				 VMX_BASIC_NESTED_EXCEPTION;
> 
>-	const u64 reserved_bits = GENMASK_ULL(63, 57) |
>+	const u64 reserved_bits = GENMASK_ULL(63, 59) |
>+				  BIT_ULL(57) |
> 				  GENMASK_ULL(47, 45) |
> 				  BIT_ULL(31);
> 
>@@ -2539,6 +2544,8 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
> 			     vmcs12->vm_entry_instruction_len);
> 		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
> 			     vmcs12->guest_interruptibility_info);
>+		if (cpu_has_vmx_fred())
>+			vmcs_write64(INJECTED_EVENT_DATA, vmcs12->injected_event_data);
> 		vmx->loaded_vmcs->nmi_known_unmasked =
> 			!(vmcs12->guest_interruptibility_info & GUEST_INTR_STATE_NMI);
> 	} else {
>@@ -2693,6 +2700,18 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
> 				     vmcs12->guest_ssp, vmcs12->guest_ssp_tbl);
> 
> 	set_cr4_guest_host_mask(vmx);
>+
>+	if (guest_cpu_cap_has(&vmx->vcpu, X86_FEATURE_FRED) &&
>+	    nested_cpu_load_guest_fred_state(vmcs12)) {
>+		vmcs_write64(GUEST_IA32_FRED_CONFIG, vmcs12->guest_ia32_fred_config);
>+		vmcs_write64(GUEST_IA32_FRED_RSP1, vmcs12->guest_ia32_fred_rsp1);
>+		vmcs_write64(GUEST_IA32_FRED_RSP2, vmcs12->guest_ia32_fred_rsp2);
>+		vmcs_write64(GUEST_IA32_FRED_RSP3, vmcs12->guest_ia32_fred_rsp3);
>+		vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmcs12->guest_ia32_fred_stklvls);
>+		vmcs_write64(GUEST_IA32_FRED_SSP1, vmcs12->guest_ia32_fred_ssp1);
>+		vmcs_write64(GUEST_IA32_FRED_SSP2, vmcs12->guest_ia32_fred_ssp2);
>+		vmcs_write64(GUEST_IA32_FRED_SSP3, vmcs12->guest_ia32_fred_ssp3);

...

>+	}
> }
> 
> /*
>@@ -2759,6 +2778,18 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
> 		vmcs_write64(GUEST_IA32_PAT, vcpu->arch.pat);
> 	}
> 
>+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED) &&
>+	    (!vmx->nested.nested_run_pending || !nested_cpu_load_guest_fred_state(vmcs12))) {
>+		vmcs_write64(GUEST_IA32_FRED_CONFIG, vmx->nested.pre_vmenter_fred_config);
>+		vmcs_write64(GUEST_IA32_FRED_RSP1, vmx->nested.pre_vmenter_fred_rsp1);
>+		vmcs_write64(GUEST_IA32_FRED_RSP2, vmx->nested.pre_vmenter_fred_rsp2);
>+		vmcs_write64(GUEST_IA32_FRED_RSP3, vmx->nested.pre_vmenter_fred_rsp3);
>+		vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmx->nested.pre_vmenter_fred_stklvls);
>+		vmcs_write64(GUEST_IA32_FRED_SSP1, vmx->nested.pre_vmenter_fred_ssp1);
>+		vmcs_write64(GUEST_IA32_FRED_SSP2, vmx->nested.pre_vmenter_fred_ssp2);
>+		vmcs_write64(GUEST_IA32_FRED_SSP3, vmx->nested.pre_vmenter_fred_ssp3);

Would it be clearer to add two helpers to read/write FRED VMCS fields? e.g., (compile test only)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c8edbe9c7e00..b709f4cdcba3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2614,6 +2614,30 @@ static void vmcs_write_cet_state(struct kvm_vcpu *vcpu, u64 s_cet,
	}
 }
 
+static void vmcs_read_fred_msrs(struct fred_msrs *msrs)
+{
+	msrs->fred_config = vmcs_read64(GUEST_IA32_FRED_CONFIG);
+	msrs->fred_rsp1 = vmcs_read64(GUEST_IA32_FRED_RSP1);
+	msrs->fred_rsp2 = vmcs_read64(GUEST_IA32_FRED_RSP2);
+	msrs->fred_rsp3 = vmcs_read64(GUEST_IA32_FRED_RSP3);
+	msrs->fred_stklvls = vmcs_read64(GUEST_IA32_FRED_STKLVLS);
+	msrs->fred_ssp1 = vmcs_read64(GUEST_IA32_FRED_SSP1);
+	msrs->fred_ssp2 = vmcs_read64(GUEST_IA32_FRED_SSP2);
+	msrs->fred_ssp3 = vmcs_read64(GUEST_IA32_FRED_SSP3);
+}
+
+static void vmcs_write_fred_msrs(struct fred_msrs *msrs)
+{
+	vmcs_write64(GUEST_IA32_FRED_CONFIG, msrs->fred_config);
+	vmcs_write64(GUEST_IA32_FRED_RSP1, msrs->fred_rsp1);
+	vmcs_write64(GUEST_IA32_FRED_RSP2, msrs->fred_rsp2);
+	vmcs_write64(GUEST_IA32_FRED_RSP3, msrs->fred_rsp3);
+	vmcs_write64(GUEST_IA32_FRED_STKLVLS, msrs->fred_stklvls);
+	vmcs_write64(GUEST_IA32_FRED_SSP1, msrs->fred_ssp1);
+	vmcs_write64(GUEST_IA32_FRED_SSP2, msrs->fred_ssp2);
+	vmcs_write64(GUEST_IA32_FRED_SSP3, msrs->fred_ssp3);
+}
+
 static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
	struct hv_enlightened_vmcs *hv_evmcs = nested_vmx_evmcs(vmx);
@@ -2736,16 +2760,8 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 
	set_cr4_guest_host_mask(vmx);
 
-	if (nested_cpu_load_guest_fred_state(vmcs12)) {
-		vmcs_write64(GUEST_IA32_FRED_CONFIG, vmcs12->guest_ia32_fred_config);
-		vmcs_write64(GUEST_IA32_FRED_RSP1, vmcs12->guest_ia32_fred_rsp1);
-		vmcs_write64(GUEST_IA32_FRED_RSP2, vmcs12->guest_ia32_fred_rsp2);
-		vmcs_write64(GUEST_IA32_FRED_RSP3, vmcs12->guest_ia32_fred_rsp3);
-		vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmcs12->guest_ia32_fred_stklvls);
-		vmcs_write64(GUEST_IA32_FRED_SSP1, vmcs12->guest_ia32_fred_ssp1);
-		vmcs_write64(GUEST_IA32_FRED_SSP2, vmcs12->guest_ia32_fred_ssp2);
-		vmcs_write64(GUEST_IA32_FRED_SSP3, vmcs12->guest_ia32_fred_ssp3);
-	}
+	if (nested_cpu_load_guest_fred_state(vmcs12))
+		vmcs_write_fred_msrs((struct fred_msrs *)&vmcs12->guest_ia32_fred_config);
 }
 
 /*
@@ -2813,16 +2829,8 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
	}
 
	if (!vmx->nested.nested_run_pending ||
-	    !nested_cpu_load_guest_fred_state(vmcs12)) {
-		vmcs_write64(GUEST_IA32_FRED_CONFIG, vmx->nested.pre_vmenter_fred_config);
-		vmcs_write64(GUEST_IA32_FRED_RSP1, vmx->nested.pre_vmenter_fred_rsp1);
-		vmcs_write64(GUEST_IA32_FRED_RSP2, vmx->nested.pre_vmenter_fred_rsp2);
-		vmcs_write64(GUEST_IA32_FRED_RSP3, vmx->nested.pre_vmenter_fred_rsp3);
-		vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmx->nested.pre_vmenter_fred_stklvls);
-		vmcs_write64(GUEST_IA32_FRED_SSP1, vmx->nested.pre_vmenter_fred_ssp1);
-		vmcs_write64(GUEST_IA32_FRED_SSP2, vmx->nested.pre_vmenter_fred_ssp2);
-		vmcs_write64(GUEST_IA32_FRED_SSP3, vmx->nested.pre_vmenter_fred_ssp3);
-	}
+	    !nested_cpu_load_guest_fred_state(vmcs12))
+		vmcs_write_fred_msrs(&vmx->nested.fred_msrs_pre_vmenter);
 
	vcpu->arch.tsc_offset = kvm_calc_nested_tsc_offset(
			vcpu->arch.l1_tsc_offset,
@@ -3830,16 +3838,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
				    &vmx->nested.pre_vmenter_ssp_tbl);
 
	if (!vmx->nested.nested_run_pending ||
-	    !nested_cpu_load_guest_fred_state(vmcs12)) {
-		vmx->nested.pre_vmenter_fred_config = vmcs_read64(GUEST_IA32_FRED_CONFIG);
-		vmx->nested.pre_vmenter_fred_rsp1 = vmcs_read64(GUEST_IA32_FRED_RSP1);
-		vmx->nested.pre_vmenter_fred_rsp2 = vmcs_read64(GUEST_IA32_FRED_RSP2);
-		vmx->nested.pre_vmenter_fred_rsp3 = vmcs_read64(GUEST_IA32_FRED_RSP3);
-		vmx->nested.pre_vmenter_fred_stklvls = vmcs_read64(GUEST_IA32_FRED_STKLVLS);
-		vmx->nested.pre_vmenter_fred_ssp1 = vmcs_read64(GUEST_IA32_FRED_SSP1);
-		vmx->nested.pre_vmenter_fred_ssp2 = vmcs_read64(GUEST_IA32_FRED_SSP2);
-		vmx->nested.pre_vmenter_fred_ssp3 = vmcs_read64(GUEST_IA32_FRED_SSP3);
-	}
+	    !nested_cpu_load_guest_fred_state(vmcs12))
+		vmcs_read_fred_msrs(&vmx->nested.fred_msrs_pre_vmenter);
 
	/*
	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
@@ -4938,25 +4938,10 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
			    &vmcs12->guest_ssp,
			    &vmcs12->guest_ssp_tbl);
 
-	vmx->nested.fred_msr_at_vmexit.fred_config = vmcs_read64(GUEST_IA32_FRED_CONFIG);
-	vmx->nested.fred_msr_at_vmexit.fred_rsp1 = vmcs_read64(GUEST_IA32_FRED_RSP1);
-	vmx->nested.fred_msr_at_vmexit.fred_rsp2 = vmcs_read64(GUEST_IA32_FRED_RSP2);
-	vmx->nested.fred_msr_at_vmexit.fred_rsp3 = vmcs_read64(GUEST_IA32_FRED_RSP3);
-	vmx->nested.fred_msr_at_vmexit.fred_stklvls = vmcs_read64(GUEST_IA32_FRED_STKLVLS);
-	vmx->nested.fred_msr_at_vmexit.fred_ssp1 = vmcs_read64(GUEST_IA32_FRED_SSP1);
-	vmx->nested.fred_msr_at_vmexit.fred_ssp2 = vmcs_read64(GUEST_IA32_FRED_SSP2);
-	vmx->nested.fred_msr_at_vmexit.fred_ssp3 = vmcs_read64(GUEST_IA32_FRED_SSP3);
+	vmcs_read_fred_msrs(&vmx->nested.fred_msrs_at_vmexit);
 
-	if (nested_cpu_save_guest_fred_state(vmcs12)) {
-		vmcs12->guest_ia32_fred_config = vmx->nested.fred_msr_at_vmexit.fred_config;
-		vmcs12->guest_ia32_fred_rsp1 = vmx->nested.fred_msr_at_vmexit.fred_rsp1;
-		vmcs12->guest_ia32_fred_rsp2 = vmx->nested.fred_msr_at_vmexit.fred_rsp2;
-		vmcs12->guest_ia32_fred_rsp3 = vmx->nested.fred_msr_at_vmexit.fred_rsp3;
-		vmcs12->guest_ia32_fred_stklvls = vmx->nested.fred_msr_at_vmexit.fred_stklvls;
-		vmcs12->guest_ia32_fred_ssp1 = vmx->nested.fred_msr_at_vmexit.fred_ssp1;
-		vmcs12->guest_ia32_fred_ssp2 = vmx->nested.fred_msr_at_vmexit.fred_ssp2;
-		vmcs12->guest_ia32_fred_ssp3 = vmx->nested.fred_msr_at_vmexit.fred_ssp3;
-	}
+	if (nested_cpu_save_guest_fred_state(vmcs12))
+		memcpy(&vmcs12->guest_ia32_fred_config, &vmx->nested.fred_msrs_at_vmexit, sizeof(struct fred_msrs));
 }
 
 /*
@@ -5119,25 +5104,10 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
		WARN_ON_ONCE(__kvm_emulate_msr_write(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
						     vmcs12->host_ia32_perf_global_ctrl));
 
-	if (nested_cpu_load_host_fred_state(vmcs12)) {
-		vmcs_write64(GUEST_IA32_FRED_CONFIG, vmcs12->host_ia32_fred_config);
-		vmcs_write64(GUEST_IA32_FRED_RSP1, vmcs12->host_ia32_fred_rsp1);
-		vmcs_write64(GUEST_IA32_FRED_RSP2, vmcs12->host_ia32_fred_rsp2);
-		vmcs_write64(GUEST_IA32_FRED_RSP3, vmcs12->host_ia32_fred_rsp3);
-		vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmcs12->host_ia32_fred_stklvls);
-		vmcs_write64(GUEST_IA32_FRED_SSP1, vmcs12->host_ia32_fred_ssp1);
-		vmcs_write64(GUEST_IA32_FRED_SSP2, vmcs12->host_ia32_fred_ssp2);
-		vmcs_write64(GUEST_IA32_FRED_SSP3, vmcs12->host_ia32_fred_ssp3);
-	} else {
-		vmcs_write64(GUEST_IA32_FRED_CONFIG, vmx->nested.fred_msr_at_vmexit.fred_config);
-		vmcs_write64(GUEST_IA32_FRED_RSP1, vmx->nested.fred_msr_at_vmexit.fred_rsp1);
-		vmcs_write64(GUEST_IA32_FRED_RSP2, vmx->nested.fred_msr_at_vmexit.fred_rsp2);
-		vmcs_write64(GUEST_IA32_FRED_RSP3, vmx->nested.fred_msr_at_vmexit.fred_rsp3);
-		vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmx->nested.fred_msr_at_vmexit.fred_stklvls);
-		vmcs_write64(GUEST_IA32_FRED_SSP1, vmx->nested.fred_msr_at_vmexit.fred_ssp1);
-		vmcs_write64(GUEST_IA32_FRED_SSP2, vmx->nested.fred_msr_at_vmexit.fred_ssp2);
-		vmcs_write64(GUEST_IA32_FRED_SSP3, vmx->nested.fred_msr_at_vmexit.fred_ssp3);
-	}
+	if (nested_cpu_load_host_fred_state(vmcs12))
+		vmcs_write_fred_msrs((struct fred_msrs *)vmcs12->host_ia32_fred_config);
+	else
+		vmcs_write_fred_msrs(&vmx->nested.fred_msrs_at_vmexit);
 
	/* Set L1 segment info according to Intel SDM
	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 36dcc888e5c6..c1c32e8ae068 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -87,7 +87,7 @@ struct pt_desc {
  * running the L1 VMM if SECONDARY_VM_EXIT_LOAD_IA32_FRED is cleared in
  * vmcs12.
  */
-struct fred_msr_at_vmexit {
+struct fred_msrs {
	u64 fred_config;
	u64 fred_rsp1;
	u64 fred_rsp2;
@@ -215,16 +215,8 @@ struct nested_vmx {
	u64 pre_vmenter_s_cet;
	u64 pre_vmenter_ssp;
	u64 pre_vmenter_ssp_tbl;
-	u64 pre_vmenter_fred_config;
-	u64 pre_vmenter_fred_rsp1;
-	u64 pre_vmenter_fred_rsp2;
-	u64 pre_vmenter_fred_rsp3;
-	u64 pre_vmenter_fred_stklvls;
-	u64 pre_vmenter_fred_ssp1;
-	u64 pre_vmenter_fred_ssp2;
-	u64 pre_vmenter_fred_ssp3;
-
-	struct fred_msr_at_vmexit fred_msr_at_vmexit;
+
+	struct fred_msrs fred_msrs_at_vmexit, fred_msrs_pre_vmenter;
 
	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
	int l1_tpr_threshold;

