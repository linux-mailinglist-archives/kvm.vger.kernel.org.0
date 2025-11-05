Return-Path: <kvm+bounces-62042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 297E3C343D7
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 08:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF91218C58C9
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 07:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B915F2D24B8;
	Wed,  5 Nov 2025 07:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QHQJszs0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5512D0636;
	Wed,  5 Nov 2025 07:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762328083; cv=fail; b=XPpxjN1rC1BUPHNtKG0n3G3PzhnCyj7VVQQlWS6NQNLvCiiqB4X84hUK6M6ytSRIty37U6nDSOoJXVumOfEbzD8ZPFkWKckKQ7ywr3a4k7JEKnez/e9kCaGKkAiBqSJJGfcpX7J1ZiUBrUnx94j4mNAJ/45NiK1rbKkI/Wc0b/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762328083; c=relaxed/simple;
	bh=zq11GAr43sPwTZR15h2cBItUdusfxqdwx8osk8sOsk8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cfzaGpsfRpRrjuLL0z7VzRRpL2Oj+OK8sTWAjePrDtgR586T0X4UT9tE5Zn33xcJNE28XstTKjgWkYhoz+1zvQv02jeTsHGPvG+NhGQa85X/5vnuh5KvPTF0cDgn2mTu3qNTvsIM/oq/YyyDoZRFyt5Stsx4y5xAZ2igt2T1frw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QHQJszs0; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762328082; x=1793864082;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=zq11GAr43sPwTZR15h2cBItUdusfxqdwx8osk8sOsk8=;
  b=QHQJszs0bx5mcMXdVsp4kXJGFs+1gM/T46yT4OV60Alv7hFAW6WhIilV
   QN6Mj6wmdcxxOb2u+FQpmvScNKqQ2b15yk/aZY4z9cLt2JYlmWMguQHnt
   kz9htL52vRvz+LvZtKasNfnHAwVCO47PI9M1osTjJRA1HQ+2GOWaWt8Hh
   PGmOVqRYio/wJrB7XqXSHOr86IWEIb757IvGd8vIg221L/TisdFs8E9K2
   guiyz3lr3k+IWhuRihp0d2MOCqxs70r3nW8/+ZQsbqHzvRFlCDOh66cUa
   f4O3v7pjN8Hk07yL4bxUrgbKwn4I6ORmQPzCl5UC8grMzinfHSE3/7Id8
   Q==;
X-CSE-ConnectionGUID: mt7JhhDuT4Ohvc+iclfRnQ==
X-CSE-MsgGUID: stKnBOuqQd+4ENRESaWgSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="68087896"
X-IronPort-AV: E=Sophos;i="6.19,281,1754982000"; 
   d="scan'208";a="68087896"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 23:34:41 -0800
X-CSE-ConnectionGUID: pX3ZU/frT4a7OKigT/M1fw==
X-CSE-MsgGUID: 3XrUvOEzT9Sq8ZE2yBxXiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,281,1754982000"; 
   d="scan'208";a="187830649"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 23:34:40 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 23:34:39 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 4 Nov 2025 23:34:39 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.48) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 23:34:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YE/tT6AaxbMLYDrTnZHlBQIPJcoMq/VCgpLrIXz7fwQhAxyCNzqp9LOa1l5tvFCy8n7jF6gBHyrJkEtb+/3RzCqnOriBPtsvjHCGLbdJ1/t7LJqXXsQf9bmQEj6Ru2/4tY8fLXlkxzRQgUUlZucRUQX3pAiisHrUAHALk5GPKMM2G0fuCcbunM3ynFPtI42HAIMSxrp8s7Ml+012JG83ImDZN4ERi/+UHYEbKyB+jxYjlueXvZokC4Z/piPvW97+51VbSDVgNv7UUyeQO4uAwiphUlg/AInwLTGaHd0PJQw86EibgL1QvYOn9GBYARqXOSMWQNhju5zeTtGVVdKvDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jrbVvVV7Lbtrq3MF7g7soch5HyB6b54V8ztjd8tvPBQ=;
 b=JELLnAkaiAqf0Aalj9lF5cqTo45jgmJywFerhLuRXiKMEi5j69nYWpX01XRTFQPcm3bG73nCqZ7qR8pklIQAWx2Z2DtDqs4chtLh2S7j3XH/DXIEupq7NSselxfVjMZ9vGA6nLjDBFEQ3VHr0uW8e9bwa+3kFLU5GnY/8fLS7OqzxN6PaJo63JitWtRDH8+jptXHH00FVxHXGsMV4TpymN2wzSGdNjQdoMEtbWIb1p91/DXPT8liRRWUH7hldQ6tSXJBC5THVxpiBvisFHaE6yBZNLo4lLqjUmdyrYchMLhMhV3kERZRZDwDAKSI+TqplyW4Bafx3N1KxsOmBp7+5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4946.namprd11.prod.outlook.com (2603:10b6:303:9e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.8; Wed, 5 Nov 2025 07:34:36 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9275.015; Wed, 5 Nov 2025
 07:34:35 +0000
Date: Wed, 5 Nov 2025 15:32:29 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan
	<maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley
	<pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda
	<imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Kirill A.
 Shutemov" <kas@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-mips@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
	<x86@kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, Kai Huang
	<kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, Vishal Annapurve
	<vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ackerley Tng <ackerleytng@google.com>, Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v3 04/25] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Message-ID: <aQr9jW/7zwWJaDFf@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251017003244.186495-1-seanjc@google.com>
 <20251017003244.186495-5-seanjc@google.com>
 <aPhjYcOFjL1Z8m2s@yzhao56-desk.sh.intel.com>
 <aQMi/n9DVyeaWsVH@yzhao56-desk.sh.intel.com>
 <aQo-hus99rE7WBgb@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aQo-hus99rE7WBgb@google.com>
X-ClientProxiedBy: SI1PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4946:EE_
X-MS-Office365-Filtering-Correlation-Id: caeabc42-1357-482f-ed2e-08de1c3dc4f9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jBFHBRiy+lb25Spc1JhPYuYeKD43Qs/ynhp5zsi0PUBNVxYf4JTceIcdPRi3?=
 =?us-ascii?Q?9miPSO0FGiXZWPd0cTbEC9L+gplGxqcfn4dht+XcaslLy5nrpsXFQyC6ONEP?=
 =?us-ascii?Q?fJyZ8eoTu78zNwEG+egIW+sdUudyIaG9FIzgP7hKHiGiXyZtZPEA/ljKw7FW?=
 =?us-ascii?Q?S4IMHDiQfbKJYdNGbnXND1MDpoTuUGsq555LI2NgoZlak65xnuwXlHMIfInM?=
 =?us-ascii?Q?CCZypwI4TSR5uhRXaO7ctX3pzTJICs8LngQrhsxe4qmb7rpvgpzsawGj6Ayq?=
 =?us-ascii?Q?WehL4jTsAIFvd5s6j8yklxwkaR1+U5vSR534dO5APVQWRsD7lDj24HSwg07/?=
 =?us-ascii?Q?wbpc3ZEsELW0exH6SlGunfH4XVlS/U+7Ikmv+hqHL4CRpD7l3OFl+MSCrt0h?=
 =?us-ascii?Q?CAHIPipq/7TTs8OmJXobd6ry+PkIL5Z76fOlDVBQaIxuAA4cGVETv+6duIcD?=
 =?us-ascii?Q?K+kcFvpmPlATh2IRtydEYSgUXyADODkfrIGPg0MuBc3rOlja7th7A58lQBM1?=
 =?us-ascii?Q?i0jHmKhDqt1LCPLW+RDuSZgTNxV1gMRIRySQpwtcsuOp78gMFcgbOKjtwDwd?=
 =?us-ascii?Q?snSLCugg4P6J0MGZg6QoA17oNdw+8CO6nz/9gFGUp8Ae3tyGNPDeAiwKGkVB?=
 =?us-ascii?Q?RH8lZBGs63EPjL6P8IuMQzPgJ7bVbpN3ol6JjELlUQGzv10WBUtyY8qBRYFA?=
 =?us-ascii?Q?mrV5w1DszlcFSXsAGabZMrn9jltQ/sKpc+iygwmxZSaHqv24iTsFH0cRtmY+?=
 =?us-ascii?Q?8QPvsI0KmOVfsDAePBaa19uURLayQl1LBijNBbZ28uc2IjJPPv9kASFScMTP?=
 =?us-ascii?Q?1r9kDMREe9dK+SEldoA2tNHDWSuCy4Sa8F50n0a6XCYpx7+nndHKEWsF4ofh?=
 =?us-ascii?Q?jZRoHo5n0O/52P+8J7kBwSvg2U8Xu6RNgVYZWi1K0NWrW1M1JN62QBC6VZlr?=
 =?us-ascii?Q?KMZwyXJap9SCsCI/2izeZiPo0SwSQWn68c5GF6kVqCc7CeFWJMl1wwtswpBu?=
 =?us-ascii?Q?JRA6Z9GWR1SU8PDnZYuPoDN8JWy0P1w0IHWF78BagnL9GkvhJj+XsveLhtn2?=
 =?us-ascii?Q?KWJxRTBXAD5n0Dam86szTuqlQa8o2pd8S0s8KjfQwJB4OS3LO1vEeBy25nhB?=
 =?us-ascii?Q?ipViIIMnVbbs61n69nxtjx5wTx2kHpfb/fuNsl3Up7cBmmNVyk5Kzm3R55oR?=
 =?us-ascii?Q?xcRkunKUzcgOIJqignMhHVQGp7rOmScxmS4Cv19/8faVrOKPhKVUrCugtY3S?=
 =?us-ascii?Q?zqVzUr94cRsfEl4NCa8cNspKqXi6T17YHZitn9sDe8pT4oat6yaevFJSLKvD?=
 =?us-ascii?Q?Zi0DqKJCOKcskyn4lvCHxddyf1bp8YOSxZoSHrqaLmQdv7ZI6FTx3GqUxVM5?=
 =?us-ascii?Q?AE2FuCmW9kG/Un7RRoi5RvNQlV0BK7fNR1Q/mEl64eNZqynDtwyc+HY7Nl48?=
 =?us-ascii?Q?qOti+qdah/qr+lHMlDLORRU2B2uCejHTgW6wIsmKbxlML88ez3GV6g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gmDFeY1fENQOZnVS1n6LUcStbd0grd1f5fUdym78JeRfLOTL1dojCpcauoSi?=
 =?us-ascii?Q?ShSIQ+H33aWBigY5RLjNB2wA5EQ8ATx9UZ2+8WNh+N4EeK5fwNrbERyxfYSz?=
 =?us-ascii?Q?mIfMNn+IJNHTPBMsTogUfMXHj36Dh/jYiLZ6b+Xt83XM0F35/PV+l046qe/o?=
 =?us-ascii?Q?rFqzfHN1ZrmggPz0DN0SBmIymX1bG5Xqyi7dQD2HXLnlIu3onirg7fpbUjTb?=
 =?us-ascii?Q?6IkjiEEsSep2laMmevsHbw62c4bIyUeyO6gYaNRV7bDChZVncDvHf/8sCI2a?=
 =?us-ascii?Q?wqQmbJfSbYOPmj5l54orLkfXhKY/w3Huvf/oQ7+43TVRZAY4NGCpRY8gLm8S?=
 =?us-ascii?Q?PgOJqCJqYavk17nR7oQvBuvC1HFuzFnp29q1/tuJXJAZ90KmFOXnbnFBLDSj?=
 =?us-ascii?Q?FeYvbNLUZHa5X0oTUgQg1R0Is5VYmkhCKOZVphOntZc+Ex3LeHEYq1YlHavo?=
 =?us-ascii?Q?Ewlq0PX8c0m1qRrZPWcBCGQGs2qnbjJNHyg/hQn6GXKv2wibnGGCyLdd8lOG?=
 =?us-ascii?Q?2IzTZfO3xUkcPwDCke8RLIC3Y1AuYY9hNI/1jq9ZmBGAhLi1FrtksaQKJVXg?=
 =?us-ascii?Q?JbPjyDu+6nXmamQyCNO8UuyfFDFa9iJQcsNIw/TurZl23F6R07x5Z7vVG1oy?=
 =?us-ascii?Q?aViG4qHuJjGx4PFTlEdgbBOzpswqpX90h4vMRJ/uacdsd4pqKm/l82qCjgNO?=
 =?us-ascii?Q?H52ocqxJ39EhafdP9fHtDtl8XVQ+RlAKkO/vHlFPPLKlaGe1SexUM+UDcbN0?=
 =?us-ascii?Q?ZdgFuVc04ah3amXh8EsLhvCjK9EBopCnz2iNtc3d7L7Zz9UW1FgV6GoG2EZG?=
 =?us-ascii?Q?+hN61YKYdJ7yZ2KC8X6LvjMN26wOimHb1gaKeMTXrHBQwfDZdyS3xVzynpPV?=
 =?us-ascii?Q?tNPWSLVvWkXrBHn6Fu8P9oSct1Wz/WU7GcGbFKEVk/TvT0R47mYljncwlwX1?=
 =?us-ascii?Q?CkW0XGjqPosu8ph3zEu1M10vg0l08BPT+VOR37Uwfjre84zzobFwteS16rcp?=
 =?us-ascii?Q?jjjxiRNFXc3UUFoUEh8KrYIGKIJwr/02xxn9ZFQE5W1X+HTP4SSksjYkHzei?=
 =?us-ascii?Q?5URGkpgETb7Xs00io26beo/Ahy8wzvxXZ9qCI8aQiOrlmzA/LrsKwHPLoXGg?=
 =?us-ascii?Q?nPLD4kEJCCK1HqopsP9Q0+JkrtZ46xDXZUVg0MhDp0FYc8XmYlxtgfRbvRmM?=
 =?us-ascii?Q?8D/sdRjkqWI8gCPki0/+obDpiWNAHjUm+HVy+dRZpQQPZ9fKYinbKY16aA6u?=
 =?us-ascii?Q?MySottrEtPAiJvdnMUAHRAasEscYOg/sk4ZGgRhWIxi+mqyuQmG4Vwmme63h?=
 =?us-ascii?Q?+ZwZClTIPon7KyCiIttUpVwGNcIa8ZiZNfdNoQvDcPKiIOnaMBCVJ77soCrj?=
 =?us-ascii?Q?K1K4hPkaOWPTvq/i9QkAGimFt0GV6xmpayzSVvvMbD4dFnJLv/VLhC3qTC7/?=
 =?us-ascii?Q?lII2/GVgyMqbZcs/8Ec5Wipvu8Dl6xtzTc4xGj3ZGoe8UlGZrNR516QQcp3B?=
 =?us-ascii?Q?/6ln2QfFps46TWTtgBldyhX7WBPAnIlCCQp+hATmwHXoRpU83mfQeAj+dhk9?=
 =?us-ascii?Q?nUvrN9QQ0dpgPPRAPPGShuIlTfzk526SuTH6UBDe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: caeabc42-1357-482f-ed2e-08de1c3dc4f9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 07:34:35.8381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cMyY9RXdGWP7Ql1BfNYyjYNqPXr0x3JvaWvyLpHEI2YluXdHvTVtA2QmLRqCARVxVRAhGoyHlLYmuWZXjX/2lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4946
X-OriginatorOrg: intel.com

On Tue, Nov 04, 2025 at 09:57:26AM -0800, Sean Christopherson wrote:
> On Thu, Oct 30, 2025, Yan Zhao wrote:
> > On Wed, Oct 22, 2025 at 12:53:53PM +0800, Yan Zhao wrote:
> > > On Thu, Oct 16, 2025 at 05:32:22PM -0700, Sean Christopherson wrote:
> > > > Link: https://lore.kernel.org/all/20250709232103.zwmufocd3l7sqk7y@amd.com
> > > 
> > > Hi Sean,                                                                         
> > > 
> > > Will you post [1] to fix the AB-BA deadlock issue for huge page in-place
> > > conversion as well?
> 
> If you (or anyone) has the bandwidth, please pick it up.  I won't have cycles to
> look at that for many weeks (potentially not even this calendar year).
Got it!
On the other hand, do you think we can address the warning as below?
The code is based on [2].

@@ -853,6 +859,10 @@ static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
        inode->i_size = size;
        mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
        mapping_set_inaccessible(inode->i_mapping);
+       if (flags &GUEST_MEMFD_FLAG_MMAP)
+               lockdep_set_class_and_subclass(&inode->i_mapping->invalidate_lock,
+                                              &inode->i_sb->s_type->invalidate_lock_key, 1);
+
        /* Unmovable mappings are supposed to be marked unevictable as well. */
        WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));


As noted in [3], the only scenario can trigger the warning after [2] is when a
process creates a TDX VM with non-in-place-conversion guest_memfd and a normal
VM with in-place-conversion guest_memfd. The two invalidate_lock's don't contend
with each other theoretically.


[2] https://lore.kernel.org/all/cover.1760731772.git.ackerleytng@google.com/
[3] https://lore.kernel.org/all/aQMi%2Fn9DVyeaWsVH@yzhao56-desk.sh.intel.com/

