Return-Path: <kvm+bounces-69726-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6P7kFW2/fGlVOgIAu9opvQ
	(envelope-from <kvm+bounces-69726-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 15:25:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F8E0BB948
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 15:25:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 214BE30097D5
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D59E30BF68;
	Fri, 30 Jan 2026 14:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eUK7VuGr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178311862;
	Fri, 30 Jan 2026 14:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769783137; cv=fail; b=FsPuEslse6b/AHdFyI7Q2spnh7VmR0JbdwxadhXtK+xeV47wYknt54y4JnmS8k/dgNx0q2sBytm/0Q7gMabeqKTIb37QJLwH4e56lDieDSW9wHBLwZXrsUAXzWrh8W5GAoc6hXh1DM9VqPnJaOBaGZ/CH2yRpnKme95Utu2MYPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769783137; c=relaxed/simple;
	bh=qg0sp10iLy6xfEloE8N8kOMRNFJ8O5o31Qf7yNCqnkE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=s/g9+ARSCe71QzOFaPzNijkiHNnmm2NfcPaZ4xnOZuYi3+8Zsw/UUDV584DH6ILNb0WRPtH+13Wz6tYP2KPRHhW/ux5WXHIlAqe13CdYdtqCxaPdI4/Jz1aEzs3fYP9E4SP8H1aBjTdcuqphqOdHIFXW8salVZjRvbuwMDe71Fo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eUK7VuGr; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769783134; x=1801319134;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qg0sp10iLy6xfEloE8N8kOMRNFJ8O5o31Qf7yNCqnkE=;
  b=eUK7VuGrAG+qtie6WsHUcsANqivPVbk8c7+upnpVb3UsiKRsGgIscrw+
   nhz+HERVnY6n33xzCQ0AC12bCZoxFfO6jsQSi6F6jcIzn8Mun7y66eG6h
   tyJBGSrXyTtkZLa3hlTTz4OWENPzuEM8sNOxrHXYgxDzpQ55J5sga6TV2
   V5OlzgkgOY4KONW86w7CNelL1BRqxn+m0IvQc/fwXVgxXpTvBUReG19f9
   5wUWu2FwjKeovMNtC5XxLHIX95DbgcKngfxzLICB1rsASrfDtcN8M/ph+
   4mkVe7a1uOwDflVbqgUhP2jFyh/3XoiwnSQz3gnMC9y7lgx4Oaau1xtGR
   Q==;
X-CSE-ConnectionGUID: v39iJ43qS0Wl76reljV0XQ==
X-CSE-MsgGUID: NH6TiPqAQnenu9zB3ivIVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="70750151"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="70750151"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 06:25:33 -0800
X-CSE-ConnectionGUID: fdnKRYDbS4eanRZBO+vEGQ==
X-CSE-MsgGUID: zVuc3bu3Q1GMuZHURSKDqw==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 06:25:33 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 06:25:31 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 30 Jan 2026 06:25:31 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.34) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 06:25:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tsPucXn+t+FyrezKLwV9hx6BdQm+toKZOjloaJFyLCaGRfVzY8EAhxeIVWOKTKVJpodtHyvRVnBRyoJwqdBiTjui53ODXnHmTyz7RwctX/bD/e8MYs8vnSL+WFeHT5Xh66qEnzEnRpPCVXWDwTunhvjInDyTaCPo3sfqCHkMTv+xJ1wlNa0VF+VLrDzMyvC6ITAtQnPaX4OtVCnY4/NRfpNfW+QRKHr1ad7bwRBhgY9EXyTUWsdP03mxUXVVt0ANd3TwePct54Z2Z2jQE/dvseaRChtPTGDiW9gPQKy4fe9cy2xr9TbTQRBY9/cklxMC6lC5ipSkGEfVZ+DX+YZ3BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uP2Au98B+rJnI7HMs2UuN69tj+YPRBehBOq9RsYQnVw=;
 b=fhQ6mG9DB02F9kXKJgULaV8PjNlNGdW0fGaONio++C49u6uwa6T1slCx/7WcG/ZgWB57uyifIpVcyYI/5g8Bj1ScBDHjgmJnaFySh5bPMmSExEo4kQ/d6oiLKzsniuNHIPUW/JHyUID0gL/zX0VfuDyfTz0/hhvo2wJSAO/Flfju0vnIpf5Cj2gRg2zDFqomtYNBqj0FaNWPP4yFY6HlvjaCh+p8zHQP8LqfjYaHJDg7+bKGOeRzq4dnTEwLtOzKOHFmgwfVrC5HjWPX1GI6cLY3IWxJS/IMncV+9csZVSXYjLX9Z+9dA0uH3Fp27Q3YMi2spyGFX2nQrXit/S11Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL3PR11MB6410.namprd11.prod.outlook.com (2603:10b6:208:3b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 14:25:26 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 14:25:26 +0000
Date: Fri, 30 Jan 2026 22:25:15 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "Verma, Vishal L"
	<vishal.l.verma@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"sagis@google.com" <sagis@google.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "paulmck@kernel.org"
	<paulmck@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v3 24/26] x86/virt/seamldr: Extend sigstruct to 16KB
Message-ID: <aXy/S47ryxy0PwpM@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-25-chao.gao@intel.com>
 <c9c648536ed4cd242ce5d7de87cafe352503839f.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c9c648536ed4cd242ce5d7de87cafe352503839f.camel@intel.com>
X-ClientProxiedBy: TY4PR01CA0022.jpnprd01.prod.outlook.com
 (2603:1096:405:2bf::8) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL3PR11MB6410:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c9f5670-86e9-4230-f3fd-08de600b6952
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8iKROfgvdmb22fYlnhrh1coH+Unmwz7WWTuQLF3g8nVjv50fa+o11lhWRIOV?=
 =?us-ascii?Q?D6TJjMYmgS8uZpOAa+ik2FawkHaCkUdD0W11UKEdEphZ8u0snMcPBQigHZzq?=
 =?us-ascii?Q?IOPU9gj7X7pjDnpB3zK6RpFZbL78Toq0lhYtczTetijlhNMRADsS7yny8CQj?=
 =?us-ascii?Q?QjsFQMyrsAXxdaTskOTv7g3X/ImTdfygMMVBARRVQnvK1ocJAVxshd79E+cH?=
 =?us-ascii?Q?FEC7kMOrYldyskM1+c1LC8NyAI3Hpn/wklAw/r0VdHr+sxgs5JrX7NB2icyN?=
 =?us-ascii?Q?Pvu+rOxpFgEEhPm/Z0yYAFzGvDrhgWsqonqQPTl4IT+wxZoszB/1V1FOKqMV?=
 =?us-ascii?Q?VuUnrnbu8X85BfbYIrq3Y7TQhaX65134eoDQ5jyFb1cNMSQaW4jo9iOU2WdY?=
 =?us-ascii?Q?rHG+YvFG25/NyfP18ZX4hYq5C65SKe+Tzhc1ohTpUXua2gYSe5qZTHunRFqg?=
 =?us-ascii?Q?gmUM6Z3rjE1iLyRxUgDU+LqgBXe4f89IYqcghuX3ZFZBgNd6rimd19hKpGEt?=
 =?us-ascii?Q?iZUDQ6E9hEvYD8CuGYyT+IjNfckgiwZEXYl31JB/ohkYg41FJQZXT4oA5K2R?=
 =?us-ascii?Q?jY4RbzzaMCgPW5rxZIfYQlG5daMLjD0/VQAIs9/Vlkr+wqi9plGQ3qqDP/TZ?=
 =?us-ascii?Q?kXgGKb8kaq1ZBiobFH8xz/giJS0bQrVMPFu8zLTWSNfJNqoo50S2gidjx5xt?=
 =?us-ascii?Q?7HGCv0rzNfnBNYFsUZgjMVdpbKRpX4XuFeicczLLMbHAJ+uSDUv81TtFxtMY?=
 =?us-ascii?Q?szLJm8mEmsUeaKHik2txV7SvMwdR3N69hpNXCEdTTJU9n9oh6dKIWPOF9qPM?=
 =?us-ascii?Q?YP2LRDwBo785GwOao5q07w5huGGTdV/M30fowRFZ0XMIhvXOUUi0qZrTi+du?=
 =?us-ascii?Q?cj1+1QRX0t+LFQnJwtpyS3sfsd8oAV2HCCVKP/if5gAHw9ZcoFczvAl8Ci3o?=
 =?us-ascii?Q?hzQ7DSSMSO25WhU5zCiJzZxnBWFEWxU53UwwJ1IdlAh58MmfXyCO3RXSx6Kh?=
 =?us-ascii?Q?hcMemkxjSvsKHMppQSRO319GrJSth9EdFYwc1Ae5sTezIv9RZVaVliNeV28L?=
 =?us-ascii?Q?b8kU7XPWoxkHBMv08r1DeggVQbyqnlOD1wVmI4sHZCfqV7J/QQ6lUMOHtdal?=
 =?us-ascii?Q?XL4ah+ZesV4NcKCAtNulE7+8pYWBwPxKVOxakbkP/b3FUC2r4eW8te9CdD7z?=
 =?us-ascii?Q?49Mxow4Ou6XleJMYilOEjsC9LP1ljxUEPO54KCQ2TbqZ4LvEQMv0oj3qrnhp?=
 =?us-ascii?Q?HdG1SXbEN9xcZlI1hYSN+cc4ZTFYsYaxxyMp5MEVGIGYjpLm/UUgAj6ZjluK?=
 =?us-ascii?Q?P14DFTkYsvfBwJ6z27jCWytkOsO0T9voZJhRImujGRZOjSAMuhOFEKw5DZk3?=
 =?us-ascii?Q?teyv96gOuBwr8uyJT3LBfp6RYbMaBq/YcgZzJwzskHnx0RPQxyq6FR19yx3W?=
 =?us-ascii?Q?J22uIpPlnoqQqs6B5+gpxV2oSCd3WacMFpTdipqVv4N/OvPLlMmax4BXFIRw?=
 =?us-ascii?Q?H2OUCmaevTnkkBc4s09ztvbvbPP8jFQoJj8g5TeDXC4xNf71mQXgwihe/jHy?=
 =?us-ascii?Q?UutXITgiaim60iLmIb7JGOSvn3dfFs6MJGrriUnP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AK9rlhW62U6Q62GLLX+MsgTjBcCQkMrRwXn83ZdVl2an7QG/4eBZKnINBcYf?=
 =?us-ascii?Q?JMpeviF00RsveyHktZYJ6bFHpu/kA1hV8eYEjYO9L/rgqgy1VEkhr4U9zE1/?=
 =?us-ascii?Q?taQ0ZVakq9lonJ+LVX2JsevWG7bv1qm1nnalhRKfIhCYAyz5hTCheXqgyp4u?=
 =?us-ascii?Q?/r2fqFtuS70e+N3FzHEV8hN0WRNTJo9qB8vkquLQSGVjhhpkxLhsWPHuVzxn?=
 =?us-ascii?Q?7Mdcal5E8BUL3LnfA54bibqQTTXS/BVNLmNtrxVvqmLbHG1R0EsH6zXnnnWr?=
 =?us-ascii?Q?1ozeLGojcm5MG9STFWM1UbUtC3E/VgrtIWW5XIR5259iIgFxrMkpLuEZNHuz?=
 =?us-ascii?Q?TEgOMDoGkSF/g5Z+rVRCt/d3moCgBKb2xUil9yB1whoMKHceYdwDgXSWijch?=
 =?us-ascii?Q?y0X4yftxPVk77RfbiP73rufDfrWlKMjAggYWFdevXk1eoM/dwPxp/KHMXAJ0?=
 =?us-ascii?Q?xhI5TqSze/rOCcfDueigrRqB9BC94MlL750LoVcR0ickwebi10/N//6S1GNn?=
 =?us-ascii?Q?uS3oZKmsoqzEb1RM+gNuEbri+GjSALEBYhMiTCe4xPCPnJoEByLNM1gE0pn/?=
 =?us-ascii?Q?gJFrTroxGr+0HZuIVhGjSR+LB3KEvtCQhHfe06hHEdLO0WO8ZIJMk1G1uvlL?=
 =?us-ascii?Q?ok9fRwMURI8K1J05D3zNEiQ1rvbC0kroFJ4AUQnvKBA5VwyTW3Qsl4dHjZWW?=
 =?us-ascii?Q?ggF+0R0mLVbaDp7FBaa3ab2IebSH59QEyEr8WHW49lxzFtKczBt7wnWdLIre?=
 =?us-ascii?Q?BV7iK6j68V+FvE2lpoE/jRPT/AF8XK2lVTGfA7jYw4J+j67Jklan6NCJpIQE?=
 =?us-ascii?Q?zO/dC3stm/qFQE8QFaXAVg9BYHbwhx8kthVBx2fSODfriCkYiZL7d6V317+U?=
 =?us-ascii?Q?F/AsXuT3z4eGPpAlsBo5Wd9jws+5ckxNfgrcf2gfJ1wahpbcMSgVMZas5Rh3?=
 =?us-ascii?Q?Tm82Oypw9Nkfz+h/GW2fypYI/UXmCtgFe3FI+S/KmP8qqkDYMwb8g061OSHi?=
 =?us-ascii?Q?ub2kdGHFgnAYhrWtgaYBAKbjUDtyxG1NUsI8nqBOURoKxyQajhZDx0Y6VIV6?=
 =?us-ascii?Q?vEnaoCkpVI24I4cohcr0+lpYpYkOOpy/P4WGo74nrJ5wDY4PckQZev+aZwVV?=
 =?us-ascii?Q?S8RQNpc9BUrh6AbjolrO1pTEagpn5BuIjplfKyfiplaw9LDp4st6HThM1kvu?=
 =?us-ascii?Q?pZrnH+SZYI6lkntzYi1mMJ0RvkA7gyn27jjPUz4mbRKMV3zGi5jUmRfDlQvN?=
 =?us-ascii?Q?howhNzr2d3L1EzUBGvrdvuOAfiYKTnL1AAGE3mdis25nafXu0iqGZ/6zfmW8?=
 =?us-ascii?Q?9Uhg3qoQOw/1bYIOQaLtI4uF5rUYJPQQIFjrF5PbCnSnDPL7o6evRIFfLRYm?=
 =?us-ascii?Q?JePa46zURds9lntzfkfU1wAgQtxn1VifQBApU7KKycjG/B/ZoZOnlcUHQxgm?=
 =?us-ascii?Q?HbppMKvOE9SRzVrYh5bDqeV9ghhdlLwOON2Jytl57jv0Z6G32WIejtq0ZVo2?=
 =?us-ascii?Q?6drUt4soUIywE9RcnKrrCUOrbsO0BxgH0H77oK9A50z9U2Z0yt7kT84Bzpqs?=
 =?us-ascii?Q?HgBz0oUVg1NbcrFpCUw5amXiVoFu5+EXikVM0ZgG2h4pIX489uEHfMH/0sY9?=
 =?us-ascii?Q?Z5drQG8AEY7VarVxd+Ma/a4Ep7Jf+NNIZDYv3/M9CnWqpdVH8kmlvlUR83YD?=
 =?us-ascii?Q?kwc4HEnIlgV9lem4y9F2+cX+72TZFwmbhI/1uwkdgmJjMMzgQ9Vv5OQGSepS?=
 =?us-ascii?Q?6O0Ah0mOTA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c9f5670-86e9-4230-f3fd-08de600b6952
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 14:25:26.2803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t4+COHYaDrd6G838d/RSkdZNB8dFofBLhQROGJVs1yMC6K0/yIjj6av6cxAnfTzI0BLmQIwiarpgm5k53LyVBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6410
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
	TAGGED_FROM(0.00)[bounces-69726-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 6F8E0BB948
X-Rspamd-Action: no action

>Let's move the discussion here (from patch 13 -- sorry about that):
>
>IIRC this patch just simply re-purposes couple of reserved space in
>SEAMLDR_PARAMS (which is part of P-SEAMLDR ABI) w/o enumeration, explicit
>opt-in whatever.  The code change here doesn't even bump up its version.
>
>IIUC, if this code run on an old platform where SEAMLDR.INSTALL still only
>works with 4K SIGSTRUCT, the SEAMLDR.INSTALL will only see part of the
>SIGSTRUCT thus will likely fail.
>
>How can we know whether a given 'struct tdx_blob' can work on an platform or
>not?  Or am I missing anything?

Good question.

This is actually userspace's responsibility. The kernel exposes P-SEAMLDR
version to userspace, and for each module, the mapping file [*] lists the
module's minimum P-SEAMLDR version requirements. This allows userspace to
determine whether the existing P-SEAMLDR can load a specific TDX blob.

If the kernel cannot load a module using the current P-SEAMLDR, that's
userspace's fault.

*: https://github.com/intel/confidential-computing.tdx.tdx-module.binaries/blob/main/mapping_file.json

