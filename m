Return-Path: <kvm+bounces-14482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB4A8A2B3D
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 11:31:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2766A1F23765
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 09:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C928451C28;
	Fri, 12 Apr 2024 09:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LVECWtOy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF535027F;
	Fri, 12 Apr 2024 09:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712914299; cv=fail; b=rkSNH68UwPOg/b5YxgOSt+Y5dqF1GtHtuEVLCFlxmJEzM0rFUG1tNSTvr7sETRL7M7xmTr3ZRIj0UOMn8OQfpYGzdt563cR85az7ED6wFTexqx9HD7M7IfAxSmCxc69N824Ld3CTXmHq1i+3J5YgSfPT1j/ZHzbj+RCjqC7s064=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712914299; c=relaxed/simple;
	bh=8omDXhmHGb4NC55m1Dql5yK5NjKsiexoJxatcAXIg8E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bHhg81k/k0Rktvtm6rQETh7GkuWj/mk3jFtgkLY8rZde9FsYnx8e7of8Or3mCMiprQYcdWSszpbMc3tguM9/hd7hbsgJGR4nsm2rLTQiwNHCNUeI8+Kx9z2m+ilK/lAN7vdEbk0IxdHY0Hsw0o4aRXzdRnHKTnbty9qRbWaIzHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LVECWtOy; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712914297; x=1744450297;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8omDXhmHGb4NC55m1Dql5yK5NjKsiexoJxatcAXIg8E=;
  b=LVECWtOyymILkCKFjCziTCceM5LeinaztOPCU2Zw4ZBvaDQtxRSrM8KD
   SIzmuOCS3tIVoheXi3aRtJgM0PaK9gWdNyP1A8bJJtNFdJWIgzbq60uhU
   1Ez12wUGpde8+UivOURvDZxHMocaD9NwFGgDVpaUZbQpVDCDQT9h9kbAa
   NEsQen9B34qZYPBQn3Q6BE5THYES4hp+Xi7yFV0AccukFlZEeDHXesxDH
   qQUnIVcUiqMvb/hFNSctywNpPBp3ba9381DHzTCpQ1v2u/CC3IBqQlhNt
   AwUA429BBjkFp7DGTWbQyYn7xPW/hK8cuaT9umZrTEdZXfb7KDuZrzkqu
   g==;
X-CSE-ConnectionGUID: GQ22ix6MSy+amYdMBO6r1Q==
X-CSE-MsgGUID: HBELl5KTRcyoCiL46y1guw==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="25877979"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="25877979"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 02:31:37 -0700
X-CSE-ConnectionGUID: Dp5oFSbIRlm023GJCJTQfA==
X-CSE-MsgGUID: 2s92IXZyQfOhHU6eajVlWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="21227293"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Apr 2024 02:31:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 02:31:36 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 12 Apr 2024 02:31:36 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 02:31:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuFm+OwZFknjwitUTSBwF+JBIuNRrBqmYLyNkX57QrP/9qiOa09E0wud4kL+vXm38sZA9vr4NJcg1wiGUbdKsxrvzAvoYJGhb0nY4UAyHTUvfDUOE+L6a4EeekxHlDcDoUuFOhJ7sCC6fZikGdKcjRvNn7QN8mKtctqfAaCA4ohbz3CXVxxHMKBSvocoojogI/lVmS8MhU9hx5yxioxfgXqduuYhK3mu5sF26kr7useD7Wh+kMNxv8fH+NO6zgwZm3oKSW9UzQvTetxNJc0xm3xFIodQgmLTY0z5TdIlGK6T3WrmQgP//lL1Z8QmTi9H2dPXTlTSl0gNqYdzJL8CMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MZGl0q8Xh4vVtT8iJdiV7vLqmprTNMnDb/LsaUHU2mU=;
 b=Q4L5dJgTNKFWcqSCwKc8DAzdOyl55sAlsDS+WH8cj6G7VNbaR0pSPEgb5QShEj9wSzGsEVmsN9T/hNoaDiBGC+iIrQdg92Iq/OKv26COGZYffD8ej7/xv7wYxytpOczdDqWB40CkIQN6gHwlpp/TPTT9oRajViO9Jh9bLiEFsfSHEifTbcDWQCrZB7qVmb2fn/bywEvNlh8gwYDmBobY2qff/x9uwZ5LI3UphxdEbXDQnEDehUsUm0h0watWCtEtuJwnPePt9mJqatZeouEWv8X6TRIRVodeox7U/V2RnRpd+Nz/v95r8xItOCiLsXkZMcCIXjWbBzJzQckSOr/avw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5012.namprd11.prod.outlook.com (2603:10b6:303:90::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Fri, 12 Apr
 2024 09:31:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7452.019; Fri, 12 Apr 2024
 09:31:33 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, LKML
	<linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
	<mingo@redhat.com>
CC: "Luse, Paul E" <paul.e.luse@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "Raj, Ashok"
	<ashok.raj@intel.com>, "maz@kernel.org" <maz@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, Robin Murphy <robin.murphy@arm.com>,
	"jim.harris@samsung.com" <jim.harris@samsung.com>, "a.manzanares@samsung.com"
	<a.manzanares@samsung.com>, Bjorn Helgaas <helgaas@kernel.org>, "Zeng, Guang"
	<guang.zeng@intel.com>, "robert.hoo.linux@gmail.com"
	<robert.hoo.linux@gmail.com>
Subject: RE: [PATCH v2 11/13] iommu/vt-d: Make posted MSI an opt-in cmdline
 option
Thread-Topic: [PATCH v2 11/13] iommu/vt-d: Make posted MSI an opt-in cmdline
 option
Thread-Index: AQHah6hi0qfZeBkquE2g8LsVrlLDi7FkZ5DQ
Date: Fri, 12 Apr 2024 09:31:32 +0000
Message-ID: <BN9PR11MB527627DF2470FEC3144F59B08C042@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
 <20240405223110.1609888-12-jacob.jun.pan@linux.intel.com>
In-Reply-To: <20240405223110.1609888-12-jacob.jun.pan@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB5012:EE_
x-ms-office365-filtering-correlation-id: 8e4563ae-c8f9-4188-727e-08dc5ad35744
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KYFnMVPH3sgAwWvoqNdsA5CHs65KBiKCklQfij3Wid0lmD8FIHXkGKHF3hOPU4nrcjJo7LsqUp4UJrTw9SpQwsW1cE06xU8lbIBucjFxv0A/6vsMp//LfAS95SlyZ1Fgo0/VDfx4npiztmmMp3a3p1FPXlU2W8CFLhlCWD3qYFpaFTU8DWEBvRhTmg7rQuTFGOAsx5WppM4ZPvDMt/aBQjDSINxNT1xz4KI+o7eWGYDJZyyHRIpRe/AlMpCgvpjHDQMYzzj1cg7PjUGNWxXJmiaSOIxjiQisq7EApwNnxL9AyM76C7HUH0+pGsteh7HMwvMAe74KOIfWcoe97yQYWOap3+QzbU31tEakC0Hr4N5WdHwSWTN8+fRcyaNtUf23IURAr3c5ECFImaA/w2hAEisnJALT1X0UAelkJVEyjdi3f1e7Y68J8mo+H5FzAr7UKAzG1wmm8bIU6XgSjzS48qHnk7NDu7Ec/055EWhBAx/e7uiopkmyvfyQ8NBm6zc5rwadz0FF5r5cmOYqOFglM4g6lm1R4rd8eeoTYWFi0C8rCVCmQpUc9wCRHKqeLIsR8gr3FZYYpjLgUWlArgVFJ+6uk7ZQAjCBln1ft6KXa/NB31ZSqTaw+QE31hQBQHeFLamp83PsZK1tYye3S8eccP3QuF5H2FDa7jJGQBmNMB+ccoH+K34xiLmVed5bOpTaFymbToYlALE85yDscDDhxcCFwszfcjYRx2wfM0UTLHs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(921011)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9AUI4S0vUnUP4PBSvVNpNvsm3+HrnTF4RQWgWVjal5kBqkIx9B77ru/7ehjr?=
 =?us-ascii?Q?LG3ySZ1FifD5JPq2FJiUTn4HHtm9h88ouSHmaKv0cd2w9w5yTkBude99W7x7?=
 =?us-ascii?Q?O5Xqo6Kuu8EF7rTj4uOVZl8oqk0R4fYvSwnZACs3d+Ftyi9Ty4/5dGQ++hmc?=
 =?us-ascii?Q?aWX0t6rKuZVoP956L00b6pKewD0jxQhV7yBbtdHhzMmZBq0ilKFasARLC/WF?=
 =?us-ascii?Q?Htnb/rdsGXHThuHtbLpRiSeUp7q2TqCipimRKxymY1zERp7Cm85SqzMYf91y?=
 =?us-ascii?Q?aVQSZz1yOP9mYA4r5oZGE4cmEnM4tY2QmFKrF5BsM8rvadJ0F6JutwkeD9JE?=
 =?us-ascii?Q?COVZBbVIpm1FMJoKOFTELTHYLugx+IV8fYGHOdgKQmmTdOSNg7NZskb5NpYm?=
 =?us-ascii?Q?t9UxAjIdpLMbWjJDyYajO98tq9hcZTmXQIJswGdju1auKDn34GGIRWk1nIMg?=
 =?us-ascii?Q?OC8ikORPUVc+jvzzgH46cla8XsTzaYD2K6YDwfi2DamqxDP+vk08eGH3M4d7?=
 =?us-ascii?Q?Di06fj5RTu8Wb6JOsBX4LxVczV2mrn5Zr/uM0rHbUPHayExzid2TRuAPPh73?=
 =?us-ascii?Q?t/9vhagisRC1q+70Y26QbuWdMTafhSuyFQugnNx5nsjbEhXRSP1QN9AJUd57?=
 =?us-ascii?Q?fMbPHBRupmowtupZQ1p9tEp5QjpmhXGSiT2QdRuZhmtmSaXesw6JWAUgqe48?=
 =?us-ascii?Q?1dk+2Ng7bTOwTvbbUa/eAmKDW/82RUpV85Pck3aPLs0FjcPWxkBUYsi3JRsn?=
 =?us-ascii?Q?61Cs2+N9iwvE3s8D6e51ntXZc1tZbnjEFt2k9TEPINKAN1EzD+cad8f58fBV?=
 =?us-ascii?Q?bPlC94B+rj7Vv3dkbPkNLmrdjddcCwjlv0Q2Jx6yXO+wOUf+m47RyPk7C+S0?=
 =?us-ascii?Q?egDxyy+8B0OxLwlZylvLG9rJbUdYOWlE6AEb82a/zuLKPfhGHninP327HdY4?=
 =?us-ascii?Q?OWGL8m+Ii4ukt7wprMCYwn2zZ6oW7KLUlkWGN4JM0gOu1H6VyQ4JGc3G6M5W?=
 =?us-ascii?Q?VcMjjTdxPo7wXxtSo/VeIN3ZbuT1CSiojIRqwbpiLo4dHdlzcnU0tyIhpUr8?=
 =?us-ascii?Q?bx322pihOyBtSUYa/LUYdh4T1L4M6wm3T19gii3YFjv4nhMnnFwtehpEjwrb?=
 =?us-ascii?Q?tmUFWKKuVacWeV8sS414PYqG+SW2RYNKkv4Pi/uHQCHZ6VpsuzwR9i3Unv9g?=
 =?us-ascii?Q?0FwdpmlHYFziiZYfEKIf8iEsINJUCccRroFKGCwOEa+9vBrFuYh0S7VMy/4j?=
 =?us-ascii?Q?+tKZXKHqZc2QyGN5f7Vmzy5n17NyHyH91O0XyCvZ/7FXG0vx259PGBqK79Gu?=
 =?us-ascii?Q?TbO2RwKctYTRTUrMLD8YkAaZnqln5Co5hagZuFlo1cWmIqDiqOuvNv9lHcCn?=
 =?us-ascii?Q?b4dduq83PY2ARRI3HnWVBBTYKSdGsDPd1A+LWZzgZn0FiHHh8+GHLYJz0ZFj?=
 =?us-ascii?Q?7Tdeucr2XOcvQmnxNLT6fEXbcrCvkGwSS3LQSaRk4d24rlIoU06xpl4XUihO?=
 =?us-ascii?Q?9s+Y9WHTIsexF+I7NqGDiVF9hqAQEjbg/aeIaNmIgPpvhKvA6pkqF1S6KgSe?=
 =?us-ascii?Q?PwfODoF7DYkGN8TpdV6mJZC+SfsCfQYxp61ZHTFm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e4563ae-c8f9-4188-727e-08dc5ad35744
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2024 09:31:32.8369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +oQlNCqw7RiNZ5lBwTA6bX21tW2+VoEPBDtGIFZ1XK76xw42gehMeVTRqI1p62+OPx6wjKvBsiFGy1URFXjB2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5012
X-OriginatorOrg: intel.com

> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Sent: Saturday, April 6, 2024 6:31 AM
>=20
> +#ifdef CONFIG_X86_POSTED_MSI
> +		else if (!strncmp(str, "posted_msi", 10)) {
> +			if (disable_irq_post || disable_irq_remap)
> +				pr_warn("Posted MSI not enabled due to
> conflicting options!");
> +			else
> +				enable_posted_msi =3D 1;
> +		}
> +#endif

the check of disable_irq_remap is unnecessary. It's unlikely to have
a configuration with disable_irq_post=3D0 while disable_irq_remap=3D1
given the latter has bigger scope.

but thinking more do we really need a check here? there is no order
guarantee that "posted_msi" is parsed after the parameters deciding
the value of two disable variables.

it probably makes more sense to just set enable_posted_msi here
and then do all required checks when picking up the irqchip in
intel_irq_remapping_alloc().

