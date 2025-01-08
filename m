Return-Path: <kvm+bounces-34716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 731DCA04E3C
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 01:42:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 753937A20D6
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 00:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F741DFD8;
	Wed,  8 Jan 2025 00:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KcueP+/z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADECB1F957;
	Wed,  8 Jan 2025 00:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736296931; cv=fail; b=YOHfe8IfpvxcZghczMDDup3ZkPjtS23j4je0BTFCEk95FXVtZuH2FysIklW/XQM3Zqu1J2tb9u3WfylXsmfOUxFfLyv4Y/nzdPCeGWnaVq+xBzaX3stqoL/1MKzMv1ZZ1dcYwWmL0XQPZ1kW4QyQUf1+IvVqcaGyJis1cy05yiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736296931; c=relaxed/simple;
	bh=H/fhgwQ3TAV4y5zLeS0nH1yIgmMnPKDTTyQMKgKsSKQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Yx7nEVOEUtEMqHX2cOBVHWQeWpMpA9O0SucPJVehE8RxiIzXVr8jxZzU6SsJY4jhs2b9NnBbV60H2hrLt8natANGvKZASkFs27Ute7rXdrsZkpkABtOKM6X7XbkS3WFv0TgMExVbqBDA6copib9m/54lxduUoXKeXqFWrgo+phg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KcueP+/z; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736296930; x=1767832930;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=H/fhgwQ3TAV4y5zLeS0nH1yIgmMnPKDTTyQMKgKsSKQ=;
  b=KcueP+/zWlFLuVaejGwtdwSD8cTdNt/NGWOnQ2CvEQsU9MmmukfL/RaA
   QN3Ppd6moxW4vuHbjBSIOYWiYBniKmCasv4EvxxA4+qHB2nIrTeNeatoQ
   /pj0SlWVqaPxxCr+4yhMSGKVhGRhTJoyK75j1Zv3aVTMZQcwu4Xo+iaHS
   AGcB7FKu+Ug9uvwGQgNXijQY8hKBhHVB+0YHdyJgfGV63/0XDuA56aTIV
   EC9r8heS0Eu5WPjGBBZJWpA7XtY+hcwm8++gKgZU+8UyiBPhSVkeiFOsk
   SSYkruJq82InTTpclxtYfwF3DWSDXc0wK9TRe2ei2mbqlid4Qn7w1ZaF/
   A==;
X-CSE-ConnectionGUID: oREBRcVHSa+yKcTevneG4w==
X-CSE-MsgGUID: 5Kt9KSTGRh+VVj86pzw22w==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="47497459"
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="47497459"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 16:42:10 -0800
X-CSE-ConnectionGUID: kUFNRco1QlyjprzZLyfdaQ==
X-CSE-MsgGUID: 4HvwR+kYTDOQ2+9rSw2JMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="102838541"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jan 2025 16:42:09 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 7 Jan 2025 16:42:08 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 7 Jan 2025 16:42:08 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 7 Jan 2025 16:42:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bLZUjMI547hJIVgrv23Pz9NqO7LzCm7Q6M2g973SW17HYoztBB80pgLdudkOjqyvIN2vKYdH3jhi7MIkNtomlxOqbSPcpF0oXVJQe2lNY8Doy9vefzbulVr9l6eiUdgODDMWLdKG2Ui3GsvR4xLzPaNEqvEUEjN0Cr02mhX9qqD1EI6bmbDbpcg1CEgPc/pvjui7a1v9K8Dp36ZMuGRYOWvNeatKpfKjCh6jlrWTg1/qDDVU20tt7nc+AP4mbxqk0D5KAolP2OwYFhMe7KOKS6ay3ruPBEoZieIxdlo9E5/evoGPDzJC/KslSTr5SOFAeTuP3xF9UXeT6mIDYGMqpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3PIOZJDwORg7cUnoJ1UJ+dx95hFceVFt69qlaSU90SI=;
 b=B7ERos9l9fzi9i/7yFUD+cNktXj2EYP/tLOxPLedMZic/kMeWffkkhyCprt8fkDN8h33af+3Omo8x029nwMFPft+9syTFVd/rD7rwXgu6ySTnuLFcXdeD98CEThc6ArGa35K6l7I244eRdOQ17K8zOaMC3OoxlFj8ozasxSuf0D7Xc/nu+k64t1p3x6qiL8nSPx7v9N23cgom6a6y+lap8E2drVN5UrMx/wnr1rsbiQd8R6r4SVJXa+N0l4HpAorzXXqkjx2KM/txZ2aS/ux55Fowri7qRcGg6AXxTqsKecuyMI+ZWq9Ry8ziOR1swyUl5D0aDJvvo0EW9bQr/4cQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7869.namprd11.prod.outlook.com (2603:10b6:208:3f6::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.10; Wed, 8 Jan 2025 00:42:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.010; Wed, 8 Jan 2025
 00:42:06 +0000
Date: Wed, 8 Jan 2025 08:41:11 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 10/13] x86/virt/tdx: Add SEAMCALL wrappers to remove a TD
 private page
Message-ID: <Z33Jp85ospUC/QaD@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
 <20250101074959.412696-11-pbonzini@redhat.com>
 <f35eff4bf646adad3463b655382e249007a3ff7c.camel@intel.com>
 <Z3zM//APB8Md0G9C@yzhao56-desk.sh.intel.com>
 <9654f59b-9b8b-445c-9447-d86f6cfc9df7@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9654f59b-9b8b-445c-9447-d86f6cfc9df7@intel.com>
X-ClientProxiedBy: SI2PR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:4:197::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: 94c5fdd2-bed6-400c-a010-08dd2f7d46df
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?p5X6fxIousFx7D9dfLXR3ep9yR6tgDiYcP5cdMtCMcmPI/14yvtS7kTVMbtE?=
 =?us-ascii?Q?kmws9jt4AtPexReDfIPTCD4LKTrvTyWWH3eh1WVu9fJFKKXnYNtcNqiW9/Lj?=
 =?us-ascii?Q?IdMmUCUzLchODdtNXoIQlj4wlxD41lt5B4rwL4uWzlj3KzieT+pPNUnaXJoI?=
 =?us-ascii?Q?YeKQ7PgtBFHExBLSPxmfNP0rBDK57caUDY22lBeHvcOtZLxAMuxBBeWkq70w?=
 =?us-ascii?Q?f+oIDlMmiiPpC6tqRuuwPhiktM+V8aUQqM7D09qzNfA3pMUMDzSMluwUJ+Uk?=
 =?us-ascii?Q?2GmqE3EWjfdoLqklYWNlo8sA0Zoqk4xd6E42Z/ED8ileEdo8o5jcMd8nCNxC?=
 =?us-ascii?Q?/sLClJ9HFdFBtlCUwXmsWG/8FNuwetbVXyNkRogFA8fE09EioSc55X5lHOAZ?=
 =?us-ascii?Q?PL2prkiX/t9IIuE3GUIibAFvEKd1kePVkGy/u9+HK0mlXcm2elOQALuzdo1/?=
 =?us-ascii?Q?6oOO4t+akZq3MTy/4wIps4b1mGf0ddisugI/AwBc7Pnab7x8EL1wBlUeaASq?=
 =?us-ascii?Q?lSmoOWo1dBBsrKkQ7rk7HbeYRZwIujXnd5r98FWOyE6BPPtxk6I4H3fg23+z?=
 =?us-ascii?Q?tTcRpHPPxqbXu+21EK3ygQ4UEKjuP5fjNeYyKQsHUBj3iw8Isu+x6d6W0IgY?=
 =?us-ascii?Q?ZbxGUw8JTLgzilOVOFuX3sajS737JuK0lRloZJHivsqqqOlIldYdnC/WOzP0?=
 =?us-ascii?Q?c0Pp//HxO84t+v2o0TSav6lJ0fYZyaY/4LAIRPj5W+1TXi7oHf/Z0f3L7ZDw?=
 =?us-ascii?Q?7ck1wgap/kjflvK7fFGucNjlaIiKIBgemNSCqajY5gPWJe+4Z4Ih5IiuxBJU?=
 =?us-ascii?Q?cKYJy1OHNY3Kuims/xZEcAkeXmDIAgc4vxyzRahjofLq685xWsl+O68ALCSz?=
 =?us-ascii?Q?gCV+oLj+163kxn95cfRg0ZaIr0J5rhnDNvZJB6zI7kyQ5fdt34umODlBSkSd?=
 =?us-ascii?Q?Pdc+eGcYY+N6DD7+rh2/Q08gWIDXyj04IukKknsq0SKwfyNtbSg3ink+L1XX?=
 =?us-ascii?Q?yIahm0UdyGWI5WRiaQl3IhDStYen0WMZlhkkFFywUyRt79vPDKjUp+4EWedm?=
 =?us-ascii?Q?K3qtAltFL2MJWPC8Rd0aPvrA0Zu8QNG54NpKSc0e8Er/66WmocGnCkx/01CI?=
 =?us-ascii?Q?4skK2knIA37Wp1SewI0Icvlhm+yOJ/NaUxX1to4GalOGSphJQisUvIC+b82U?=
 =?us-ascii?Q?fAjUhtxQy80LODEpMbD6F/QbT0q6ghKx/bH6WVpl3hNvBep7w6AlFYkpCFdd?=
 =?us-ascii?Q?ShLMfhdaAR4ncQuYbP+RAa6dX9SxLL8oct0sZDZ27fC3OqwVrqQP3n0VkCVY?=
 =?us-ascii?Q?zK03eefhvtooHknEMwOC8rh/H5WkEagAncSb1jueAQ6qV96b5hEQxVS5qB2U?=
 =?us-ascii?Q?XTw70Q0uCkj/PmZaBtEZXk51MgDO?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sVG+BA13WvVU/ZPDB1wmHvj/is3HiODIfh7KJFPs9RRVhNhqunGQ3QHwT3U4?=
 =?us-ascii?Q?5Y+AuksHmFF47wshxKoto9B574DkrbXwSuutsUnYzhXcMu+cF7qRHamSxFjH?=
 =?us-ascii?Q?G0ogE0XzzBqCr4ryJXqih6ODIXj5DNtZrICEChBGoTRqeaOV1kHQA2AAMfDe?=
 =?us-ascii?Q?3E/cUa0kVbVjiJv45o5ludIqnVy+YgFWtNYuDVTRMzVB1rqRDnoW1xx7ka/0?=
 =?us-ascii?Q?PBzXf65u4DRka+aFsjBnRwAi02JBSlkZCQGbhuDr+yiZO5qYCjsuoAnEIuS8?=
 =?us-ascii?Q?FSGDakJQljWxY+I2hCmTE2uXECcX7Ao2BdfXGlwemfOibgW7M4JRN9j3VdfB?=
 =?us-ascii?Q?9Xez/7VCl/cCtVA3x2JQ07w1wf/mYbRjuC0RB0PaawJiiHZbLRwdwRTM1yQN?=
 =?us-ascii?Q?OgTCpRuU03TbAMTrcSGyVIEWuKIOM4aF39WPA5pm825BWvc4M9d4WDO3bOVC?=
 =?us-ascii?Q?Uriw5lzP4iYXBKkum6YNU5s/L5Ip6oLkXYAiM3nqfG2SwoBipJv6TUetR0e4?=
 =?us-ascii?Q?dLIXFRz15x20nR/6tJIHHNg4p2LC63nv37I3tE7iFU/2R/ZEaAJjp8K2LFrd?=
 =?us-ascii?Q?kuzngSrW6V43QVKTxLxNDKg+AHQCM9km5GSB3M6X7zM89QV18A8l+Ehkc1As?=
 =?us-ascii?Q?9M8AO4Omweus1y7yJQIyNHIb03D5mnPy1awo0uDM4dlixED0akti+Odig/Qj?=
 =?us-ascii?Q?D3BS4axEfmadHIfQrCP13Bzf02VlwOtk2FuNDstLGk0FZjN0pNXGWekJA78x?=
 =?us-ascii?Q?oil8kaUaY3b2mqcK3+UnWK7TL2w0q0flSoLCQIeoVRgtjspqZoRlXIpDnfYv?=
 =?us-ascii?Q?rzzhHOwy5RSmSW/1xSf7EAp3DBPIDXfgvDLKooySYU2v/U04xvL0qNAT3cLT?=
 =?us-ascii?Q?0n7dNkKUkvYRSXHAX49lQoqDUPzY+9To5yOS5IufO31BEIu2nHwFvWgaOHFU?=
 =?us-ascii?Q?SY77oukGBlSbB/3E6PNqEMVebs1HFwjrxW4ByO7GZXYnFGLemLYK2kGDpspM?=
 =?us-ascii?Q?RJnXf0zrZqbO7FIoEhyggHUoo31w2ZXSqehiu/17sJ+K7he9B9tUFsj81QTr?=
 =?us-ascii?Q?Mxs23hTgyziUDhvYuulbUysUIK4f5qSmi6khgg+DNsBDVCYtzbzCxdI2SyQW?=
 =?us-ascii?Q?FFxyAsMytayJ3KZ/RGV2PJ24wXZ3wawhpkkk37x4LXJCHxxW3zYae0vGgkdX?=
 =?us-ascii?Q?Aiqu09EhMZsf6nDp/ZP8KhGaeDI58tTbgMXDmenRyrjnKIJcNG2trkfjrTqg?=
 =?us-ascii?Q?DKGiNPYB4qzLHHM8AQM26jOmiRtU182NByBNBLIbT7hm2p8EyRYQTQW7uilR?=
 =?us-ascii?Q?RBUDvrXspMlbA2zOKIfvmEct9JHRvTX1Znh1TqDa6ZIrUN/cSoLyXkHtq2pd?=
 =?us-ascii?Q?zikcuVNY1mg9GuGu/s4d/Jdm1VOqJpQ8wftS9JTSndLIejcKWInu2bmOPjXt?=
 =?us-ascii?Q?v2/AAjnua08MtvLyK9ehsa99W5GC0hrYe4QOTx2ZFraAhCdluYFXrXRqU8yj?=
 =?us-ascii?Q?pBAuODZ7fhVvhEl/8usUyA/8iioW6nQOqiOxbjSEW5KCmnCN+ANJ107QeEy0?=
 =?us-ascii?Q?eroiCIwY3QMcj4yhW7qBUc6jRrPsuoc/2G4zkNRn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 94c5fdd2-bed6-400c-a010-08dd2f7d46df
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 00:42:06.4288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQ6aMwVMi4oGmuUYBaIinqXaDmmG+47WeDptVjmgI8IdDsPwe25l5MKAAzZYaZOAPYkfFprKvDOhwiZIeBfqPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7869
X-OriginatorOrg: intel.com

On Tue, Jan 07, 2025 at 02:13:19PM -0800, Dave Hansen wrote:
> On 1/6/25 22:43, Yan Zhao wrote:
> > +u64 tdh_phymem_page_wbinvd_hkid(struct page *page, u16 hkid)
> > +{
> > +       struct tdx_module_args args = {};
> > +
> > +       args.rcx = page_to_phys(page) | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
> 
> I've seen this idiom enough times. You need a helper:
> 
> u64 mk_keyed_paddr(struct page *page, u64 keyid)
> {
> 	u64 ret;
> 
> 	ret = page_to_phys(page);
> 	/* KeyID bits are just above the physical address bits: */
> 	ret |= keyid << boot_cpu_data.x86_phys_bits;
> 	
> 	return ret;
> }

Thanks. There's actually a helper at [1].
I made the helper in [1] as a fixup patch since it needs to be applied to both
tdh_phymem_page_wbinvd_tdr() and tdh_phymem_page_wbinvd_hkid().


[1] https://lore.kernel.org/all/Z3zPSPrFtxM7l5cD@yzhao56-desk.sh.intel.com/

> 
> Although I'm also debating a bit what the typing on 'keyid' should be.
> Right now it's quite tied to the physical address width, but that's not
> fundamental to TDX. It could absolutely change in the future.
Changing from "u64" to "u16" was raised during our internal review.
The main reasons for this change are to avoid overflow and also because:

- In MSR IA32_TME_ACTIVATE, MK_TME_KEYID_BITS and TDX_RESERVED_KEYID_BITS are
  only defined with 4 bits, so at most 16 bits in HPA can be configured as
  KeyIDs.

- TDX spec explictly requires KeyID to be 16 bits for SEAMCALLs TDH.SYS.CONFIG
  and TDH.MNG.CREATE.

- Corresponding variables for tdx_global_keyid, tdx_guest_keyid_start,
  tdx_nr_guest_keyids, nr_tdx_keyids, tdx_keyid_start are all u16 in TDX module
  code.

There is a proposed fix to change the type of KeyID to u16 as shown below (not
yet split and sent out). Do you think this change to u16 makes sense?

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 296d123a6c1c..5f3931e62c06 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -122,7 +122,7 @@ const char *tdx_dump_mce_info(struct mce *m);
 const struct tdx_sys_info *tdx_get_sysinfo(void);
 
 int tdx_guest_keyid_alloc(void);
-void tdx_guest_keyid_free(unsigned int keyid);
+void tdx_guest_keyid_free(u16 keyid);
 
 struct tdx_td {
 	/* TD root structure: */
@@ -164,7 +164,7 @@ u64 tdh_mem_page_aug(struct tdx_td *td, gfn_t gfn, struct page *private_page,
 u64 tdh_mem_range_block(struct tdx_td *td, gfn_t gfn, int tdx_level,
 			u64 *extended_err1, u64 *extended_err2);
 u64 tdh_mng_key_config(struct tdx_td *td);
-u64 tdh_mng_create(struct tdx_td *td, u64 hkid);
+u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
 u64 tdh_mr_extend(struct tdx_td *td, gpa_t gpa, u64 *extended_err1, u64 *extended_err2);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d86bfcbd6873..4e7330df4e32 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -308,13 +308,13 @@ static __always_inline void tdvmcall_set_return_val(struct kvm_vcpu *vcpu,
 static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
 {
 	tdx_guest_keyid_free(kvm_tdx->hkid);
-	kvm_tdx->hkid = -1;
+	kvm_tdx->hkid_assigned = false;
 	atomic_dec(&nr_configured_hkid);
 }
 
 static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
 {
-	return kvm_tdx->hkid > 0;
+	return kvm_tdx->hkid_assigned;
 }
 
 static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
@@ -2354,7 +2354,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	ret = tdx_guest_keyid_alloc();
 	if (ret < 0)
 		return ret;
-	kvm_tdx->hkid = ret;
+	kvm_tdx->hkid = (u16)ret;
+	kvm_tdx->hkid_assigned = true;
 
 	atomic_inc(&nr_configured_hkid);
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index b07ca9ecaf95..67b44e98bf49 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -29,7 +29,8 @@ struct kvm_tdx {
 
 	u64 attributes;
 	u64 xfam;
-	int hkid;
+	u16 hkid;
+	bool hkid_assigned;
 
 	u64 tsc_offset;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 1986d360e9b7..5dd83e59c5b6 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -40,9 +40,9 @@
 #include <asm/mce.h>
 #include "tdx.h"
 
-static u32 tdx_global_keyid __ro_after_init;
-static u32 tdx_guest_keyid_start __ro_after_init;
-static u32 tdx_nr_guest_keyids __ro_after_init;
+static u16 tdx_global_keyid __ro_after_init;
+static u16 tdx_guest_keyid_start __ro_after_init;
+static u16 tdx_nr_guest_keyids __ro_after_init;
 
 static DEFINE_IDA(tdx_guest_keyid_pool);
 
@@ -979,7 +979,7 @@ static int construct_tdmrs(struct list_head *tmb_list,
 	return ret;
 }
 
-static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
+static int config_tdx_module(struct tdmr_info_list *tdmr_list, u16 global_keyid)
 {
 	struct tdx_module_args args = {};
 	u64 *tdmr_pa_array;
@@ -1375,8 +1375,8 @@ const char *tdx_dump_mce_info(struct mce *m)
 	return "TDX private memory error. Possible kernel bug.";
 }
 
-static __init int record_keyid_partitioning(u32 *tdx_keyid_start,
-					    u32 *nr_tdx_keyids)
+static __init int record_keyid_partitioning(u16 *tdx_keyid_start,
+					    u16 *nr_tdx_keyids)
 {
 	u32 _nr_mktme_keyids, _tdx_keyid_start, _nr_tdx_keyids;
 	int ret;
@@ -1394,6 +1394,11 @@ static __init int record_keyid_partitioning(u32 *tdx_keyid_start,
 	/* TDX KeyIDs start after the last MKTME KeyID. */
 	_tdx_keyid_start = _nr_mktme_keyids + 1;
 
+	/*
+	 * In IA32_TME_ACTIVATE, MK_TME_KEYID_BITS and TDX_RESERVED_KEYID_BITS
+	 * are only 4 bits, so at most 16 bits in HPA can be configured as
+	 * KeyIDs.
+	 */
 	*tdx_keyid_start = _tdx_keyid_start;
 	*nr_tdx_keyids = _nr_tdx_keyids;
 
@@ -1467,7 +1472,7 @@ static void __init check_tdx_erratum(void)
 
 void __init tdx_init(void)
 {
-	u32 tdx_keyid_start, nr_tdx_keyids;
+	u16 tdx_keyid_start, nr_tdx_keyids;
 	int err;
 
 	err = record_keyid_partitioning(&tdx_keyid_start, &nr_tdx_keyids);
@@ -1544,7 +1549,7 @@ int tdx_guest_keyid_alloc(void)
 }
 EXPORT_SYMBOL_GPL(tdx_guest_keyid_alloc);
 
-void tdx_guest_keyid_free(unsigned int keyid)
+void tdx_guest_keyid_free(u16 keyid)
 {
 	ida_free(&tdx_guest_keyid_pool, keyid);
 }
@@ -1697,7 +1702,7 @@ u64 tdh_mng_key_config(struct tdx_td *td)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_key_config);
 
-u64 tdh_mng_create(struct tdx_td *td, u64 hkid)
+u64 tdh_mng_create(struct tdx_td *td, u16 hkid)
 {
 	struct tdx_module_args args = {
 		.rcx = tdx_tdr_pa(td),

