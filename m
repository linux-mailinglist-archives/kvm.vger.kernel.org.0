Return-Path: <kvm+bounces-70588-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aMKJMj6piWnfAQUAu9opvQ
	(envelope-from <kvm+bounces-70588-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 10:30:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 41B3010D90A
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 10:30:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E73163016CB1
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 09:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51FC53644BB;
	Mon,  9 Feb 2026 09:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MgZDTMZ+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E16A318B8F;
	Mon,  9 Feb 2026 09:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770629336; cv=fail; b=qXXf8iyzARQz1OY/9sUBOJrOZunVGFi4c4hfvFZsbP7TbE6cD6TCziz7hyvPDk3rIPsN5dEgrOGCInJuT/xw359ct3rfFtN/HEwmLmSs0pDK8f+DgLe1vlw3K1+b+SatEUvY0o8X7RSEk2f9JuT8iycvTo1fx2tCekutSLpjuAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770629336; c=relaxed/simple;
	bh=MlkIdQ4eTD/Jp5oFyLVfpZk/yXbEJtDLj+9p8D6cXYw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bSN6c5aAh9Zrb7xIfV3KrOqIVPU4vZTFbnzUHueJvtr+dsm2gKPbInhk4QFxsEft2mfolzDmK/DmwRS9p6+TAPdk+ztZ6wLvy9dunVQJQAx0jGoqtYxjG1+NTqiaSLEzoF1URcuaYwIDgDXmKpFxGuOoUZ8M5burQPnI5gVnlXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MgZDTMZ+; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770629336; x=1802165336;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=MlkIdQ4eTD/Jp5oFyLVfpZk/yXbEJtDLj+9p8D6cXYw=;
  b=MgZDTMZ+h9uAgcEcK0awRifStA+5m1cgFf3F9/EqnjXxmtu/+NtyUc+V
   L4eNFCrPwxWBPgNIo1MyN4WsH/5ghq0uMfFOrdDFlfdIT8OIZI7RdX8WG
   OQOLHffgqhBcPfS5f53fYOfw9kCotCg4MBFqcUVltcyYUpryOuKHqv+J3
   OXU6ll/whV+chQF0lfg3mum8H5ACKp36HRtGfKJI59fc8TE1nd+4g2++E
   Yjy4JaVBQlTuz27yB4kSD4Ro48yokVZYvMmY4Knnuwpj+lTnKR+VXIESZ
   vqS+dZUyoLBdwwTghgw0ffiKxXgYEiQL4sraPUsqt8YYpkLwhfawdIB/p
   w==;
X-CSE-ConnectionGUID: NOprOjRRRKGue8v2KM/pXw==
X-CSE-MsgGUID: sDW/yeqvT2ySNO3ZYN6Yeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11695"; a="71776755"
X-IronPort-AV: E=Sophos;i="6.21,281,1763452800"; 
   d="scan'208";a="71776755"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 01:28:56 -0800
X-CSE-ConnectionGUID: 21YOEE+BRYeAfMZ+wZtIsQ==
X-CSE-MsgGUID: xXTn65t/QKmCkF40kTZt+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,281,1763452800"; 
   d="scan'208";a="215953869"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 01:28:56 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 01:28:55 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 9 Feb 2026 01:28:55 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.17) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 01:28:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TVCe3SUWyA1icRB1yF/iJ+IutGBtURZ5UUiFdFoIIvdxfcOyz5XNU9muWxsAOueaP+hg/auaj6dWZb0wvQ+GQgQY9EvydQ4zT/YAGJXTx+T+/lX3Ijw4Vqk7yAUFK49uu109ZbBmsaA9Z68fOBKJ7sTlOGgIJ/dKSLOp9NKTRxqVO9uhESr5EKCZFIwQUUVQvZw6BWTCVc0YHSK0E3OEu7095T9uRcPOZ92ieDdDaaTmcRqFpAPbHbbQ1gHD6ffEzRfVkwXYLQJmzf1xMcim0g1RlYqhyl65U7v8GTEx0439yad2wxJt0lNTk8sAZq4iMScOluDYQygNSNUf1KVYBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I0JvYysublYm83ZO0lJtWseM7rN7HtieQ6Kruz/BXoA=;
 b=sSyeFnJYz1Jy1vigPb9FLn6YJSOvHi434PZOca5CIyc1HTRY+azZtguK+cVcC1Sqcln/LlRlhqD8JpU4bg67f+T0121w6GE16IqR3yzxVkPCulvPNhXLMpyZc0Qs9i85AarEv7NCSvX1u2W71P5SdepyqVDstL3mRCZCTkhc8FDzVQEygVNWb170jXn6kLjgoROqDKN/dOstbGN94/4iQkayAkbs2XMdN9KF0al3Yq9LNMoq0xA1JMaNt3W/hxjjgqkxBVV6eN7ES4GwvG40XI/GUGZ1rDRuQtlm66sUMl0xPPJ57739UnoBS+czgEcyDl8lYT72K0cdU/aMGp4MyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4882.namprd11.prod.outlook.com (2603:10b6:303:97::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.19; Mon, 9 Feb 2026 09:28:52 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Mon, 9 Feb 2026
 09:28:52 +0000
Date: Mon, 9 Feb 2026 17:25:53 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages
 using tdx_{alloc,free}_control_page()
Message-ID: <aYmoIaFwgR6+hnGp@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-21-seanjc@google.com>
 <aYW5CbUvZrLogsWF@yzhao56-desk.sh.intel.com>
 <aYYCOiMvWfSJR1AL@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYYCOiMvWfSJR1AL@google.com>
X-ClientProxiedBy: SI2PR01CA0019.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4882:EE_
X-MS-Office365-Filtering-Correlation-Id: cbca6e17-6cf2-4d19-3cfc-08de67bda3a6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LKNst3H9qJqvCeY9rpMxBoDUcYGAE/O01HIC4AVO09ykei6rr4W1Qfu6Pphq?=
 =?us-ascii?Q?yyMb8ELDkdwmVpIx4Btxp6fywzynkXMw0VlZpiGCOqsZwo2fIdQzVPL4RInY?=
 =?us-ascii?Q?odPAVOI/0p2F3kO9Bfi4P1c3oCoYXX3Jqm1cpfHXdJ+G3S496g2ms2PXm7kR?=
 =?us-ascii?Q?ny2lNdPADI/fKM712vgft8OqhKQHiLwS86VdPmSLdEbdE0FRDWv1cKP3bADT?=
 =?us-ascii?Q?WCaV0hXncyGWZi0drGZ4P5xmxr2f+Ns9vecxS9BsUI9Gdj9N/x8xBReqcoeC?=
 =?us-ascii?Q?mlduSneQiMiZB3sCA3pM++gMjljevgNuEEOBLCHB5WberxqWdHfkXct1XJ6y?=
 =?us-ascii?Q?FUmxRMfqxX5yr+PNdN8laZtSD3Pwl4bQsgjtwvRvF4jUgjwPEOuPT5Gqs6L6?=
 =?us-ascii?Q?aoWMx/zWbugx2kQx+Ifj0bhYKPYD/qEhep2WsiR8KMJcEZxrAqQHyju5+btv?=
 =?us-ascii?Q?TPM23QUUxztq+cGNwVX+NTSfO7NWVxkVcUGrKwbSHd+Ni//L86tja3mkrZKm?=
 =?us-ascii?Q?yBJIxz794MlkWHcB53voRnU+fuloXFZe4BTqpHtSYz1xZda1mE/sqU1PyWvQ?=
 =?us-ascii?Q?aGOsYA6ejCHwqANM+HXQUNRnV5lrGA+BTlXM2tUWVT5VGuDl8Ktl7bMMK1xy?=
 =?us-ascii?Q?RptQgfnyg4q0QH9LwRxQbyssB9YQ8AftoHvCABvaocveB59YyeUVtuypjQNs?=
 =?us-ascii?Q?CZWM+ozH69M4jh4IlrdfrpnQL7KDEYPPsLQa/jF2TKH3G/thc9NXRRMhdjmJ?=
 =?us-ascii?Q?0BtPk6sP0nLxEP9Flf+u78qpY4OLrxe7KCqRLBiFbwv8zyHQJRAR/piDwW4x?=
 =?us-ascii?Q?KZg1JiQBOHVG+mNm2StII62cXxBAs/fvUDEF/3SAvuO+y1nDjM5AdhfdJCl4?=
 =?us-ascii?Q?C3yl0BaV+oHddbK+UIBDvgqvr3u/l5UrOpwGZySibWfMVvmKgw8AWfCoUTDa?=
 =?us-ascii?Q?99sskv8N1w5BrqaD7URsB/2x+Q/UzHBp5/bOswDauWyOCrjI0opMTO3puA90?=
 =?us-ascii?Q?YeYOsR+GinY6I99jPABwxDvAjAQPXSNDXtlocKVZ6KKIQt4bdH+h6vNU+1Wq?=
 =?us-ascii?Q?x4Tjt7/7eyro+SrM+in5BJv4HsRWdxFGZR5rzvHUA2Dsli5qT1p84UnHeCrN?=
 =?us-ascii?Q?MKCRK9lCcwgs3ogZUNFjvi7NV9Kzzm6OeRmaYsVyGoTmgTI9kxiHwbadgLbu?=
 =?us-ascii?Q?9MoAmxpznlRjSYjnrMAQPsFEVztxBvFRbDqDwAFfTXqiNg/X8qUhJT20dsir?=
 =?us-ascii?Q?2YqEDpg7NGB47lTDVgjVpiBTjooAxVYcl/zGBtqyyZ6PeQAaaCIzFrrGoJpo?=
 =?us-ascii?Q?q2IxjiQu/sx7YCdrZAZgrYUlyV+W5r1A+cgsGSDcfH9k3ktYv9ZXpUCyO6tz?=
 =?us-ascii?Q?CS/RmcTBYKiU7o17I0Y3kA6bMa6lCAfic+q3qVvaqH09OnefIyBaSFi76eIH?=
 =?us-ascii?Q?TpBZmsCYbwV7wC4vmXDIn3z+h5CAqiD4j/zb2JLCwWDEDHmdHA6DpspT20ar?=
 =?us-ascii?Q?PJRCH/aUBsTEYItob9EHy0AiOdKsdF14Cr4qtbyqbJKIczx+r7tKGeasrUcR?=
 =?us-ascii?Q?lA0EJWiuUBjyppRUVbE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X3MdrtCORStIcxG8JC9CbO71DvnTIu8lfA3lJbfbnwnfm3LRQbDczilGdZUw?=
 =?us-ascii?Q?X8uFelSdC+69Cq8puzCAl6zYL55+AgLS2u6t94LTsPONQza7VzCItB+FDG4l?=
 =?us-ascii?Q?mRwnteXrZLtVdmn2bT/Lw3UJQoy48aIDPgi1DPF0GYyKZ26J7YrbSigdUt7D?=
 =?us-ascii?Q?4uFVXpAaKJXzTm7fwd20rUbDQft0IBoHxBizzjIEWZADD2/Xfg5H+k0CpsGR?=
 =?us-ascii?Q?PIH+42Kc2J/mhaPIVfApIeI5a11zgIA7LvCKzZPtlU1esVRs+0ia3PngHBeF?=
 =?us-ascii?Q?YiWZNY9ksAsQJA1ayayxK9QvsWh27UfQlU+lbu32kYZbnu37wIhV6YeIadRW?=
 =?us-ascii?Q?hc10DYUy+a4KbdrgRSy9Rk7FDUIPW/ON5QEWcW74sZgSmVqvDjA76FUL7ht+?=
 =?us-ascii?Q?tHrhgV2W/PVHbbM0LTqHudoIHogr5/da/Ocut45GTdKg5hMDNj46VKnXOWj8?=
 =?us-ascii?Q?fBdzasYCEGsjVLsRxezEVELeQOocMB5cZpTB5vI0JPVADgRDhwI4t27LNXO1?=
 =?us-ascii?Q?XzSyKwAJoOJuyimyeZByRfDGcs+8c2BufFT0R9iLTH1diNUYVZPPLVWbWJVa?=
 =?us-ascii?Q?TnArD0kwA0UmZxokwmMKt3niAUBKcFWiIHnk9oAzHjvTy95JPSq9KbfC7Qp0?=
 =?us-ascii?Q?OzjQEyYIsoljsj9foamjk7T+CpXOqok8zbvyfl8E+2+r9Xhs2YY25DOf6pLU?=
 =?us-ascii?Q?MCCUzSFlr5oIXeSXo2n27+fZi65jEqNovyQ0A0Dg/cdSL9xw2oCAIU7BELr7?=
 =?us-ascii?Q?OySESZJ0Tyy1V6vSWnfT3K7dwCzpoJcaF0bcT+rVN7QMVFpDqtW9YQUYorqU?=
 =?us-ascii?Q?wXf5HeUf4lV9iPZTFuG+cXdnMJim+YDdKNwE9ibyMuR3xU644uderZy+H+rI?=
 =?us-ascii?Q?D5ZvyUoMiSSfDwYxDntrs9hTYS6DNF18qOjjtRMX/yhtSxpmr8q9c/fo4Hot?=
 =?us-ascii?Q?TmfWoEggl+kaDR2Da0cHeCQbEXb3gTYUDtmQ2rtNr88BP8Qb2f4u9+rnkyFt?=
 =?us-ascii?Q?9GfY1+2c6X3Mvt8imSwf+NeHhIWhLqGKYyynUGj2xPJ3S5SC/T8vT5pEm6Xu?=
 =?us-ascii?Q?CZU54H3vsNKaJr/nN/BnluBPZaADX/EzPtKwfjpgJ6xQ5K0aNU73o4qFE7+k?=
 =?us-ascii?Q?vA6eDnJO9bpVaeI5CaeSDJ9QB58SVdIQkuSOomAxC7l9O0FRc1EFck0KYWNN?=
 =?us-ascii?Q?kcSonyo35sV/yKdd3wnIOhV7JmXV82TawoU570aXghGGmw7qL8ieFuIwtRuJ?=
 =?us-ascii?Q?1LCVrjY/0zv2i6KYW6lfqjj9dV+VRSznTeUA9PSNmjk+rsjeu3odLUGOofqb?=
 =?us-ascii?Q?TehBb8rAYT68PeIrhPzlWS6VTBkR28hRY1Gxc1r3mxqLW3B46YdmrlneaMbh?=
 =?us-ascii?Q?zqH3ZSo/Kl7nIah7/7kJ9Xl5vQwYlCnuMxqxbekXAqegEGlQZWtTBV/HHKkQ?=
 =?us-ascii?Q?ev2DOabxnNaEzNbtFn6f7h/2ovpf1kFLpeRv/C9dvwEmBuXDQyOMJoMUEQMr?=
 =?us-ascii?Q?+tJhFkIr4eEn3l6XCr+WEdZKjsA+uMffU7rO6PEu7atgCE6klwuKG6V5pwSY?=
 =?us-ascii?Q?98PQLuHYDEqgiAZhfB117CD1Pkbu05LS0SHAp8OyyENz6v7cH7dkalEE46pk?=
 =?us-ascii?Q?zuu+L8mF3GRIZGubkNJweP9qvQb8FVFFnwmQjUClVxDXeVm90C1edxvwEuwj?=
 =?us-ascii?Q?0gRA9s6bHPV61BhvYkAskN7Jklth1V0pb/yw23qH5ULe1Y23nBGszKs2fpgr?=
 =?us-ascii?Q?4VfPjlaCBQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cbca6e17-6cf2-4d19-3cfc-08de67bda3a6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 09:28:52.7587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jg9y3B2zdtvpGLQ9u50KlqthnvU1lJigkkkkkJRgN40l09ZUOi2Sz8akuvVrWfLtNW8fxw/M1WMWgVdvHOryTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4882
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70588-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:replyto,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,yzhao56-desk.sh.intel.com:mid];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 41B3010D90A
X-Rspamd-Action: no action

On Fri, Feb 06, 2026 at 07:01:14AM -0800, Sean Christopherson wrote:
> > (1) alloc
> > tdx_alloc_control_page
> >   __tdx_alloc_control_page
> >     __tdx_pamt_get 
> >       spin_lock(&pamt_lock)   ==> under process context
> >       spin_unlock(&pamt_lock)
> > 
> > (2) free
> > tdp_mmu_free_sp_rcu_callback
> >   tdp_mmu_free_sp
> >     kvm_x86_call(free_external_sp)
> >      tdx_free_control_page
> >         __tdx_free_control_page
> >           __tdx_pamt_put
> >             spin_lock(&pamt_lock)   ==> under softirq context
> >             spin_unlock(&pamt_lock)
> > 
> > So, invoking __tdx_pamt_put() in the RCU callback triggers deadlock warning
> > (see the bottom for details).
> 
> Hrm.  I can think of two options.  Option #1 would be to use a raw spinlock and
> disable IRQs:
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 823ec092b4e4..6348085d7dcb 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -2246,7 +2246,7 @@ static u64 tdh_phymem_pamt_remove(u64 pfn, u64 *pamt_pa_array)
>  }
>  
>  /* Serializes adding/removing PAMT memory */
> -static DEFINE_SPINLOCK(pamt_lock);
> +static DEFINE_RAW_SPINLOCK(pamt_lock);
>  
>  /* Bump PAMT refcount for the given page and allocate PAMT memory if needed */
>  int __tdx_pamt_get(u64 pfn, struct tdx_pamt_cache *cache)
> @@ -2272,7 +2272,7 @@ int __tdx_pamt_get(u64 pfn, struct tdx_pamt_cache *cache)
>         if (ret)
>                 goto out_free;
>  
> -       scoped_guard(spinlock, &pamt_lock) {
> +       scoped_guard(raw_spinlock_irqsave, &pamt_lock) {
>                 /*
>                  * Lost race to other tdx_pamt_add(). Other task has already allocated
>                  * PAMT memory for the HPA.
> @@ -2348,7 +2348,7 @@ void __tdx_pamt_put(u64 pfn)
>         if (!atomic_dec_and_test(pamt_refcount))
>                 return;
>  
> -       scoped_guard(spinlock, &pamt_lock) {
> +       scoped_guard(raw_spinlock_irqsave, &pamt_lock) {
>                 /* Lost race with tdx_pamt_get(). */
>                 if (atomic_read(pamt_refcount))
>                         return;

This option can get rid of the warning.

However, given the pamt_lock is a global lock, which may be acquired even in the
softirq context, not sure if this irq disabled version is good.

For your reference, I measured some test data by concurrently launching and
destroying 4 TDs for 3 rounds:

                               t0 ---------------------
scoped_guard(spinlock, &pamt_lock) {       |->T1=t1-t0 |
                               t1 ----------           |
 ...                                                   |
                               t2 ----------           |->T3=t4-t0
 tdh_phymem_pamt_add/remove()              |->T2=t3-t2 |
                               t3 ----------           |
 ...                                                   |
                               t4 ---------------------
}

(1) for __tdx_pamt_get()

       avg us   min us   max us
------|---------------------------
  T1  |   4       0       69
  T2  |   4       2       18
  T3  |  10       3       83


(2) for__tdx_pamt_put()

       avg us   min us   max us
------|---------------------------
  T1  |   0        0       5
  T2  |   2        1      11
  T3  |   3        2      15

 
> Option #2 would be to immediately free the page in tdx_sept_reclaim_private_sp(),
> so that pages that freed via handle_removed_pt() don't defer freeing the S-EPT
> page table (which, IIUC, is safe since the TDX-Module forces TLB flushes and exits).
> 
> I really, really don't like this option (if it even works).
I don't like its asymmetry with tdx_sept_link_private_spt().

However, do you think it would be good to have the PAMT pages of the sept pages
allocated from (*topup_private_mapping_cache) [1]?

private_mapping could also include non-leaf mappings.
So, we could invoke tdx_pamt_get() in tdx_sept_link_private_spt() for symmetry.

[1] https://lore.kernel.org/all/aYZ2qft-akOYwkOk@google.com/
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index ae7b9beb3249..4726011ad624 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2014,7 +2014,15 @@ static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
>          */
>         if (KVM_BUG_ON(is_hkid_assigned(to_kvm_tdx(kvm)), kvm) ||
>             tdx_reclaim_page(virt_to_page(sp->external_spt)))
> -               sp->external_spt = NULL;
> +               goto out;
> +
> +       /*
> +        * Immediately free the control page, as the TDX subsystem doesn't
> +        * support freeing pages from RCU callbacks.
> +        */
> +       tdx_free_control_page((unsigned long)sp->external_spt);
> +out:
> +       sp->external_spt = NULL;
>  }
>  
>  void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
> --

