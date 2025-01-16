Return-Path: <kvm+bounces-35631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73776A13531
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 09:19:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E9FE167057
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 08:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20D68199931;
	Thu, 16 Jan 2025 08:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cs6X84fJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D841E148314;
	Thu, 16 Jan 2025 08:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737015571; cv=fail; b=blWjEYCPEwEW9DY/tcg+WUTAoCwpKSJ/MQwfgIEwbWDSI3ripEscYiftHbwBMhJEyowVIFSf2aPKgNnzIrHyXU05vWhDxv1N9EhH+TBIujPCWH+fXMmudTwMAJMEFo61r4l7uxtYa+z34J9XIju5vU9s+VwU+008Ua2yKpZVO9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737015571; c=relaxed/simple;
	bh=07UU4pHryQovm6Pt5cu9Z/ZRmdhDspWvyOZD87OoWqU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RW4gBThMuq05G9+SdBLVc8d0MIN3v8Ow9VL0M9xE+oDVIhIj84LQkTEHl9zAjIq5Kse9G4/s5z/OsaMR8q5UVxnOYFaMEcCuaUHUVQq/7mQQ3cDG8E0I1RLja5lvIv1Elf96HcM7VUD/pKaHcfkrqBder8TAqYRTioIhCJ9/Kpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cs6X84fJ; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737015569; x=1768551569;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=07UU4pHryQovm6Pt5cu9Z/ZRmdhDspWvyOZD87OoWqU=;
  b=Cs6X84fJm5WduVY6xQwN740wtItW/X85MmDNKoGUtY60qmyHARKEC+tq
   hUdgZjK0hkJ5QIDOYIdP0uu8Tn62wt+U/IfRjxVh3bEVoVUAVbglu1or0
   3NTSvptTFkXuzetOl1nuIdH0+1c4ABY187+tfmBnIsSTpdYgZwqnQatSA
   hSR4hFvH7udUH7SGbovThg0eP5S2l6HXaUyJoFrcS4JSw0FbOej6dbCGP
   kxhNgwEvLek9ZC40lN4GICvHf8Sa3nf9QDCgJsGudJJvrw5b8ZK5z2PHe
   AjOLUgZNqQ3I/7blRrj5sqVM5CVhJd2vdmafWBBWQgps201RlB7fVFLjX
   Q==;
X-CSE-ConnectionGUID: UZnCoyXKQRGQ+a701zxFAw==
X-CSE-MsgGUID: wg1uN4sDSnes5CrjpifU7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11316"; a="41150453"
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="41150453"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 00:19:19 -0800
X-CSE-ConnectionGUID: ztADFG/fTgioZErZI9eSbw==
X-CSE-MsgGUID: C8cnR80sQS2KL0HTLanPTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="105572674"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jan 2025 00:19:18 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 16 Jan 2025 00:19:17 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 16 Jan 2025 00:19:17 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 16 Jan 2025 00:19:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E4Bh6dDBy6qmiSOM+N3xFoQhXmyMct6+Cpe5pVStvpWCO59CdbPZB3dDiBbBEB7wAPkiyzCnmzP5yuWzUdsKaBbGODdgfI5Or5UnQ2rckh0/YUXtRZhUbO/vgVUpo/xmUG29oUNYoInsBeeK0vuCWA63DkQIqsufs0dPKUmM/NirFmPwa955tlFbwLZpP4a/Qfdnj87JReMmtEWmq4t7u7+iREpA7xVkj4x6pQUaQBva5mj5sE3xDfiBaaIvjndve9uljYX0FRTyB7uu7RYf413vg/hcwcNZW909wJoUoiPgKPGnYKLF866+qD2fikTQjNQ37OkWcfXOo32QYdeAvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zw99Yk1E03DgYtWihbOns/ZZTheCvsJWX6LusNLm5lA=;
 b=W9Y+vTBW2uiQEEr2IvMQcBRn8N4grcaHLhxie6p90PvC8Z46tWcDTKgNvD9P7/fGuDlrukXkeTroV1WwweNktw/XN8PoGIn43bMCGb1CFF0xEumzakLkQoX6gIo+mmiXwXzd9/8F1BtlFDxUYJRPk3uWIG7LFiTPZbBvGPOt7WFIxtUBQxw7/bmXI+81K+xIzQHmzcx6EGmqW2CfEOfBem0rmwtFNAmgo7Ivi7GPbr633ZSwLzmagfkq7nVId12krhCwOE9dDnde91F/s+g5KPWR5CqOLxxXK+vNZx1BXdegPShf4oi0ImLyOTUm9SuOUHgOWxKdwaBhXiaQ+AYELg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB7694.namprd11.prod.outlook.com (2603:10b6:208:409::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.18; Thu, 16 Jan 2025 08:19:15 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 08:19:15 +0000
Date: Thu, 16 Jan 2025 16:18:18 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <dmatlack@google.com>, <isaku.yamahata@intel.com>,
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH 4/7] KVM: TDX: Kick off vCPUs when SEAMCALL is busy
 during TD page removal
Message-ID: <Z4jAyhtcSWJY9D/K@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
 <20250113021250.18948-1-yan.y.zhao@intel.com>
 <8f350bcc-c819-45cf-a1d5-7d72975912d9@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8f350bcc-c819-45cf-a1d5-7d72975912d9@linux.intel.com>
X-ClientProxiedBy: SI1PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB7694:EE_
X-MS-Office365-Filtering-Correlation-Id: 40808b23-bc6b-489c-a7fa-08dd360676d8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?PoNz8wYligqPe3KyVzUL/vWrj+idyseaitCJOrSljTi4lxPS/vaQDYG2J0lT?=
 =?us-ascii?Q?tIkKqz9lyNKisn61RyIEk6bAX73lCYbh0gV4wMU1FHpcyUjTB4uGAxufrK2h?=
 =?us-ascii?Q?yiTHGY68nQ5SJhwBhqpYDnODpvGjZ9Js9orIuG5QGmAYvDYty2JQjteBh//q?=
 =?us-ascii?Q?HRa8v74mUlDl05LPw+XugirkSsTaSLNjGvwTlTM05MVY1/M+MfL5YRV/9Hwc?=
 =?us-ascii?Q?TFYaqMQdwzdFlkcloFmQUmXs8wNqtGsTPfRn/d0dTjSWcrJ4czWbkxQhjQTE?=
 =?us-ascii?Q?guduCWsf5iFhL8qk68PzDjA14psw8Qt8OyXGhJ/Yb8HYL43+fh35j9k1aAyo?=
 =?us-ascii?Q?y7F/gg8AXCy/nFsM8418mXfg8xxGIh6J0LnQdb+F22ZQQZu2vxRnMvm+gSCB?=
 =?us-ascii?Q?HXgSX/6eySGx3mkObiRNv7MZJfzfltV3Wsxro1EE6aVMPwSdAJX3MOcyMf+S?=
 =?us-ascii?Q?4F2OIMTDW4Qom28sPQWTtLMRrhZhmNlSYbFAZg5HAw9alAQ2+mYfCjViis7k?=
 =?us-ascii?Q?cUADrKdS26OoJh6D7zXkCDNofLkoIilLXmLyUY0qBE1LHHFnDwFO8hwYPHPJ?=
 =?us-ascii?Q?OcMvdQTaONROHHhGzEp/w52rhc721BYU/2iIZenzhTfT+IALdigxXnVsXWoC?=
 =?us-ascii?Q?D1dxMYbb1s7MRaccJmQ0UhmyIwXh/EXmSTvJtV6j9t7/jyUiXU5J78y8KBpl?=
 =?us-ascii?Q?Gfau8RzA1iRlQtc8GHw2ocHgmBmNSiNBg54Bttt6rsUFjXVMXfGZShj+cA4l?=
 =?us-ascii?Q?O4LMWTw66cEQNKpN/vRGcQJ9LdgZ6O5W9Ff0cmF1faFxvMjQs0MF2oKFcKEQ?=
 =?us-ascii?Q?0ITm63+5cI5AHjuaDYxHMpfInmM9xtuyJ+uZrDVqduWsELcg1G1N8X5lpWuB?=
 =?us-ascii?Q?orY+h7q03gxZYyHe/xvH0JOWVVybshpRyU+JIGpNrKbQqa6MyWDcvDOMvyo5?=
 =?us-ascii?Q?ftZCBLgRJs3Zx6fof4mXRVntvCqWGUbQE6ZvSLNEj9YzuM9JhqJ3V4VvNG0p?=
 =?us-ascii?Q?2UJsibIyV8396dRIKWHnv+EH5mDlxQTQ7JxTxXo3pK1ffrT0XRZtulq0l3zJ?=
 =?us-ascii?Q?MLJfDPy2rhWmSSGHUKHTviTERDuAQzUk68Eu1ebj6bYPrr2XUDNGR8anhM3D?=
 =?us-ascii?Q?odp4XFzvFw3FO6W+P41nwaGhHU2oGGYIiGrT/JKOPpDWbGD0gP+cuT+81A1/?=
 =?us-ascii?Q?bJWbo98B4rfcMVQZOfnH7gYz60I+qdzkep2gBPQXfUIUEvrF2xoqlmAzE1N1?=
 =?us-ascii?Q?CIozN+qWLK8aBkLes8UofHKHS0OrugKPliqq4woSYUigJtiNqBvEZZMuZszH?=
 =?us-ascii?Q?bevy5NHsVkhbyJuthu/EgJ9B977Zqi4ZpFDPTLAWhRZ3H4QiqRpu/xvukQ1u?=
 =?us-ascii?Q?1WbMFGtUwbGOMg0wJ9qZGURQJ22P?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3qUrCMQyH1D/6ElepmbQpr+BNP44a3DvLQxl4ZXN/Hk78Fbf/4X6sFrV1y7Q?=
 =?us-ascii?Q?ZtsiXKRjQk8/Dkr5KHaukaIW04/aT41IgxXRJGUvWoOotmF/aDGeaCshyqpT?=
 =?us-ascii?Q?1TArvpfKU80pWZjr5vCREfRSV5I7IECbXEQPSP9NxKmHNSPNIPJSUsstTAx/?=
 =?us-ascii?Q?Qqxz0X7ebAfxzU7ZzAdIuQ5NdyjDGqjCqZiBLBVdERRkDtu2T9MkGqoheXPv?=
 =?us-ascii?Q?9TdzRmz6ZrWk1lgySl5/O0pQQ1snZY7cD23hlwaq5AT/xlwnR4AMtoN2LNs9?=
 =?us-ascii?Q?ALlYbYtXwwvWuJzBMrZ+dyIqssZWebKTnFwE1cXivegDbOs++jbJnlGfBFdc?=
 =?us-ascii?Q?59XCOj49BGWQYiU9sGpMXRceEqOgj2CFC0WBNLhh8Vd/GnN+aEmKNtUVrWuw?=
 =?us-ascii?Q?vw95jVV1nqMZxrOvjbeibxRrtjXZFidxVZugTcz1xF+ZlTxIzAOwDoixd7ZQ?=
 =?us-ascii?Q?rdWgN0vqG+QW9c8uy2/R8jFpC5CdAbNy0jNIsB00N3gqL2fhpXE55puZ5GXj?=
 =?us-ascii?Q?ise+MzaYe/ToWd+u+DGJnQpGd9X09YDD8H/APjngd76fc0qZcXYhqGfQA4ya?=
 =?us-ascii?Q?vspscT0+ekQTe184NWzXqIlZdpmqbrmtYJMGaWVsCHNKYL/JvPvnFoXhMO4S?=
 =?us-ascii?Q?VWSNd5vVSiZDknAZBHDmw3VrdHvDtrB78eKIuMszcU5c5HfXIm1V2EgcZD11?=
 =?us-ascii?Q?hBmOufIgQT58tuccxwqCM/vrvPxU8RdHUXXXTQwwkg54h0h5nXY/pL5YUE+U?=
 =?us-ascii?Q?DGzvdrv5gODMMfMPe15DsiEtWZo2kSlECvQRciK+rQt7M+7G3NihFT+c9Zg3?=
 =?us-ascii?Q?8G8He5zOz2b6BY5Pwpgao4eNr3nfU/zOTEVAw3bbtXl//fuC54dspyPURxHk?=
 =?us-ascii?Q?8bS3BNpDmOYPRl21JH+iUjiNUDoOt6DdE3TssvEZMh1xR7h1uWR1BmN5bC3C?=
 =?us-ascii?Q?GjDr1tmcQJ2sPmkJ4hetVLi4I/7V2Ell2kiyRIC10q/OQNNjai+CFysXbzwK?=
 =?us-ascii?Q?H4oDHGhDqGv42kWApquH/NLX3klxxX4RbSLlGSGue3pcV1PaYEsn+ZN4m6PZ?=
 =?us-ascii?Q?HeztUhomPrblm8Ovga5M8Gxp8xGdgn8YmiktpNRSwX4V83v2uy/iPszYBBuV?=
 =?us-ascii?Q?2pKV0tBOLCZnotJWb3U4F8o6bVLRotYP6dfDwMTGkrE8K/bpYA2jLWIoomOs?=
 =?us-ascii?Q?oNc3VAl8+TzYuaSUpqgzId5XuZ30dqkOWk91BIIk26tsP3uWncFB+aYTW3+a?=
 =?us-ascii?Q?a2kr4EheLTfJNAPyeXSt4LI4zFkp+6DLYS0UmmxQvXkSKk+kwPKt77/ruyUF?=
 =?us-ascii?Q?c1LrzDhGVH7GANl+r7PB1tqW/uvBafbEGH3mC1B2dQ7gcJtyogVyPnRPpRVW?=
 =?us-ascii?Q?FS2TtaKDn5rxIycary7iHCr4LpOkRn08rN/ZAYE/k+JUS/fnT9wGV12UzhpY?=
 =?us-ascii?Q?kOwwQRybnSXW1QSgfFxUnN3ZkvETs5L46NkKY1ByQYG3Ws3Mwdry7Ar0ancF?=
 =?us-ascii?Q?U3ekbinPlcrrkTWbyL0ZxjQ20sqJ3g9Gbn+DN+ZeH50BCuLXYrcbSoY1TXgJ?=
 =?us-ascii?Q?Z6s3IQmgjLLKbdif85oxYFCiXW544fAoO3bB4/Ae?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 40808b23-bc6b-489c-a7fa-08dd360676d8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 08:19:14.9397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2bb2krlfDGikJHWzrj9fJ+Ea3PbAkUmVLtc5uE6VtWVPVi3yapYJOkt6jQID0HSDElzYLurKr3n7Nx19snYkqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7694
X-OriginatorOrg: intel.com

On Thu, Jan 16, 2025 at 02:23:24PM +0800, Binbin Wu wrote:
> 
> 
> 
> On 1/13/2025 10:12 AM, Yan Zhao wrote:
> [...]
> > +
> >   /* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
> >   static int __tdx_reclaim_page(hpa_t pa)
> >   {
> > @@ -979,6 +999,14 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
> >   		return EXIT_FASTPATH_NONE;
> >   	}
> > +	/*
> > +	 * Wait until retry of SEPT-zap-related SEAMCALL completes before
> > +	 * allowing vCPU entry to avoid contention with tdh_vp_enter() and
> > +	 * TDCALLs.
> > +	 */
> > +	if (unlikely(READ_ONCE(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap)))
> > +		return EXIT_FASTPATH_EXIT_HANDLED;
> > +
> >   	trace_kvm_entry(vcpu, force_immediate_exit);
> >   	if (pi_test_on(&tdx->pi_desc)) {
> > @@ -1647,15 +1675,23 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> >   	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
> >   		return -EINVAL;
> > -	do {
> > +	/*
> > +	 * When zapping private page, write lock is held. So no race condition
> > +	 * with other vcpu sept operation.
> > +	 * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
> > +	 */
> > +	err = tdh_mem_page_remove(kvm_tdx->tdr_pa, gpa, tdx_level, &entry,
> > +				  &level_state);
> > +	if ((err & TDX_OPERAND_BUSY)) {
> 
> It is not safe to use "err & TDX_OPERAND_BUSY".
> E.g., if the error is TDX_EPT_WALK_FAILED, "err & TDX_OPERAND_BUSY" will be true.
> 
> Maybe you can add a helper to check it.
> 
> staticinlinebooltdx_operand_busy(u64err)
> {
> return(err &TDX_SEAMCALL_STATUS_MASK) ==TDX_OPERAND_BUSY;
> }
> 
Good catch!
Thanks!

> 
> >   		/*
> > -		 * When zapping private page, write lock is held. So no race
> > -		 * condition with other vcpu sept operation.  Race only with
> > -		 * TDH.VP.ENTER.
> > +		 * The second retry is expected to succeed after kicking off all
> > +		 * other vCPUs and prevent them from invoking TDH.VP.ENTER.
> >   		 */
> > +		tdx_no_vcpus_enter_start(kvm);
> >   		err = tdh_mem_page_remove(kvm_tdx->tdr_pa, gpa, tdx_level, &entry,
> >   					  &level_state);
> > -	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
> > +		tdx_no_vcpus_enter_stop(kvm);
> > +	}
> >   	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE &&
> >   		     err == (TDX_EPT_WALK_FAILED | TDX_OPERAND_ID_RCX))) {
> > @@ -1726,8 +1762,12 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
> >   	WARN_ON_ONCE(level != PG_LEVEL_4K);
> >   	err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &entry, &level_state);
> > -	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
> > -		return -EAGAIN;
> > +	if (unlikely(err & TDX_OPERAND_BUSY)) {
> Ditto.
> 
> > +		/* After no vCPUs enter, the second retry is expected to succeed */
> > +		tdx_no_vcpus_enter_start(kvm);
> > +		err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &entry, &level_state);
> > +		tdx_no_vcpus_enter_stop(kvm);
> > +	}
> >   	if (KVM_BUG_ON(err, kvm)) {
> >   		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
> >   		return -EIO;
> > @@ -1770,9 +1810,13 @@ static void tdx_track(struct kvm *kvm)
> >   	lockdep_assert_held_write(&kvm->mmu_lock);
> > -	do {
> > +	err = tdh_mem_track(kvm_tdx->tdr_pa);
> > +	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY) {
> > +		/* After no vCPUs enter, the second retry is expected to succeed */
> > +		tdx_no_vcpus_enter_start(kvm);
> >   		err = tdh_mem_track(kvm_tdx->tdr_pa);
> > -	} while (unlikely((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY));
> > +		tdx_no_vcpus_enter_stop(kvm);
> > +	}
> > 
> [...]

