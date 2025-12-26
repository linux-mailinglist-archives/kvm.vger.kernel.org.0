Return-Path: <kvm+bounces-66694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AAD27CDE348
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 02:46:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2EB88300B2BD
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 01:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287371DFE26;
	Fri, 26 Dec 2025 01:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JgBrLxM9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E209515E97;
	Fri, 26 Dec 2025 01:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766713566; cv=fail; b=dk/MKQdCjwZ2kJsnaUVh+cZlxZpMGWBsvp7IemDsOlRqrcOpnQMgSG7usPpLgLGbGkJ1F/90ZkLVVUW8kCqAUMlFAnHfUMeOS4J11MYVhgKTuswHsQPqqeV8dDRJD6EplFVGNNTK/PYZZKJ+WF0VfGixAesmZyEnMa5T4VWn3NY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766713566; c=relaxed/simple;
	bh=eLAosDJZ0Fl28v8AplX4YcE6Mc7erVzY7z4G6E8F3tQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=da2pjvmU1IydxnmyWxZqXDQLohOaah4/+ZOQINA4ijRrT1HmpLzNh4xvmzWIDNih6hsr8A6wJJ+7hCGt8/bERMisVpKxXTnM0yoZw2NAm0t47ZoWBmBFVAhD1AVp20u25ZxJbxc7p1odKNvXlG3wpyJv33VeaLNrccVnXTqqPRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JgBrLxM9; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766713564; x=1798249564;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eLAosDJZ0Fl28v8AplX4YcE6Mc7erVzY7z4G6E8F3tQ=;
  b=JgBrLxM9mRtqcURmSPmyAoXbmatwLO7GkLXSJjjg+xi9jUckZoj0y/zw
   zrRYyK3/XBdmGJWQU5o7+WuFDK9CyEHY3ByeUSlXcMmpBiW+cevLjrz4d
   7z490yA+pMjgTetVNIlcNooPU9comHBOTlLv4czUOgW++Va2IUnrxWIhW
   wZS1G3SsWJ/xPuPFd6ZOlwOAc0u8joshCRBLEBBqds+05w6wy6j8QOs0x
   a5P2YZhOo+2IYsJRRzfIheGgvrssjeLOmxu1wsSsItg9L+dU+gphDbKZ3
   yXoQYFzfJ//9c7uOhpDAf+Eup1p/6NzjUnabW2DGltT3xtOCZOITUQak/
   w==;
X-CSE-ConnectionGUID: osQVTVXwQbWfFOkqutlivQ==
X-CSE-MsgGUID: l8RDo5KLQKiswCnOp4UlQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11652"; a="79607220"
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="79607220"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 17:46:04 -0800
X-CSE-ConnectionGUID: 0VCZkXwGQPGrdQvxG1CMSQ==
X-CSE-MsgGUID: YWe0KImeT12XmQUA3+iBOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="200214785"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 17:46:03 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 17:46:02 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 25 Dec 2025 17:46:02 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.43) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 17:46:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rOl8sC+1bq9FmHELcPTbNY9ivDeJmrZzQglGM2fj+ZgPuRnWZlbvSbTe8VODZai/jJs5so/RLt294UIzDi7y0W5+3/fRxmJAk2cwy6ZlkU71/PBsqoTk0NZyngdp5jgLckpTRVrcUwtXimyqy1abumJUM9DYCrgKTxZAs5fTVd9D+FzfLtfQH6zKpXWE8NbM+OP2befsDQ3T93C01koC+5RPsrtj+K58yiSXdD8AQUe9PBc0ewXJsjzK9z3TkCBmU3I7aWG80mZbKizIDijYrktNP1NmAalhIDDD+HGKh7K6dV2OvSL0bCbVCs1foD9wlURj4ZGE4zj+foHmP81nlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IeqDamLtcIbsPs2IO6UZiubG2biBnA2r8lwD442DnUw=;
 b=YWNZe+e3o9AvdWCBeWRk6D14RxCs3UYiUVjqqDVC+AQPXbvOeB45Il4HiYYwS2ZMhbcTjpH/vi4cwvu5mUW2mfT4DWTdaS2vQeFdbGZLnmVaXIZck0slsykoWDS6xyodz2upxir8I87UZBkCn8dbkGaAeXNCno4Yw1L8P9bjylcyNHsF5kfrHyl4rAplnBNBH/6D0Bs97c35SHz/Mg/r0y8Qffxoa+PWuuRy2plkfw4fBXG9O0zqTUoGWZulg7gneRaVzJRyxhcoTiDVeSl6/x8HUC2pP7DeT0fsUl4oD10rsV7y7SNUCxhqYglZFyTAzhlurp3G4Ii442mvjakXfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB7856.namprd11.prod.outlook.com (2603:10b6:208:3f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Fri, 26 Dec
 2025 01:45:56 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9456.008; Fri, 26 Dec 2025
 01:45:55 +0000
Date: Fri, 26 Dec 2025 09:45:45 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Dongli Zhang <dongli.zhang@oracle.com>
Subject: Re: [PATCH v3 07/10] KVM: nVMX: Switch to vmcs01 to refresh APICv
 controls on-demand if L2 is active
Message-ID: <aU3oydjd+1fp3Exv@intel.com>
References: <20251205231913.441872-1-seanjc@google.com>
 <20251205231913.441872-8-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251205231913.441872-8-seanjc@google.com>
X-ClientProxiedBy: KU2P306CA0016.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3b::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB7856:EE_
X-MS-Office365-Filtering-Correlation-Id: b918d04d-4cea-4224-b448-08de44208284
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Q2Znc3C47OtKRgXIcBdqqtXqxKPdWCjh14Lpm1DIXZKcE954LG+UFE2/+42z?=
 =?us-ascii?Q?bzzEtp1wZoUz8Qp7vDZ7MXW6I9w10vDpRvV9YwwXVRTAeSPKuyUc1UCOAyfZ?=
 =?us-ascii?Q?TIKSvRtpXYrCis2yNAcxH073NHMLh/6QtWyyAkti63e8gbJDwqtxks8DKBFf?=
 =?us-ascii?Q?AtXPXAM34pj7qn+9W8DlE8QcTkoB9sl776vpDmuuIdzd2S5nkDEZAQD50ZuA?=
 =?us-ascii?Q?gaC4eHjmH5skoQfeLqyGVOgeaMaRvYJEJZKuDvBYH1EnOm+E9DsFe7QJWSOp?=
 =?us-ascii?Q?ptL1terdir1PuYOTi0A3MurSB27aN3gjf8xHx0NZbG79TmLjzvz6tb/kPT7u?=
 =?us-ascii?Q?nodagBjTMf2WvUYZL1mXRHJqqzDGPlTefXTc6VE0+NafJYyxP42WR3EIv1UF?=
 =?us-ascii?Q?70eglmuw6fcVnfDsdEPStgJHD3Q6xvC4v2DgmYUEj+bsTBNeddFhZqmXfYtx?=
 =?us-ascii?Q?YhrkOBVZf5/Y6/c0zHco78BXT3598Xch3S4L8nhqQGypVHhJomURFKemGmHJ?=
 =?us-ascii?Q?h/HJKm5UXmQi4eAE8D3noekl7mArc+IY+Iq1R7z3LZ6p40o5OjQaC2LX1TA0?=
 =?us-ascii?Q?JGmjnY9SjnIIedgl2JyO05wVhDsC8+xTAG8kXKonCCI/DhthE5a3wAeeQ1IB?=
 =?us-ascii?Q?6rCPDfYNAK2BygmMa5KZz7x1WA6wzSGMkQoy28m50/QwHsI1L4yGB1XMPRMx?=
 =?us-ascii?Q?FLu6sSLDd2DvjFAgRvmuNouYgmv+i5D1WD3fAQ+mjr/BMGkD+tyr2sqMl9MY?=
 =?us-ascii?Q?x8Uwbe/FmoXw08Rod2uqC6+F+drBwMKHthGlf9UNzYX3g6FXokIQvQLepWMm?=
 =?us-ascii?Q?h82VF2JSVPl9/ceFjUx58OhWOC5qCarpR8zHpIq5KAfV06jmkUctaINZ1np0?=
 =?us-ascii?Q?0+Nklq0HLo4PhWX94V/okz59H92pJn7iYUe1UN22JigsK2O1dfjyMKeym/dI?=
 =?us-ascii?Q?ak14DizDGure/ib70ibkDI6VIVgKNwFgmjzmDO7jW+g3hUzbo6rFUbkaTsTj?=
 =?us-ascii?Q?pIfVnMB83vtrRBWhmOsfkHXMBFTqmB+RQrEoNDkTyQtyL3h3RL1//Zgc/VMc?=
 =?us-ascii?Q?uP9/Txctyh5yYEgPVfEVyf8fdN4C0w1zUSSYIdZk5XZYd3aktfUIHgeBymwh?=
 =?us-ascii?Q?Sq8ztKOBiL0rxV6bEcFC7uJNHrf0zRG8iDoHmHr5E0G4alLVPZD9YIcHVTbv?=
 =?us-ascii?Q?Cxmg1LJPnMDrl1tu+OYrMiRH9Slr8etUGWe33WWJWfPafzHWoBe4//l38css?=
 =?us-ascii?Q?uwqUp4Mb2MLAnqtGBKBizTcTQGQnJ8HUNdXEgms5Z01ttMI3diYtTbCFUPEI?=
 =?us-ascii?Q?RnpfLmo9erBVGouzV+73hsH1bfkd49mJ1kQWxBMKbx+1BQNai8gQ1o4luJ8t?=
 =?us-ascii?Q?jJGFpXRXmGZGInmyVf2aq1Id0bieYDLihotRzsWhFLajDUtUqcz1vmMsT1q4?=
 =?us-ascii?Q?umN+V365/EvVkIutMyymz7iPn0LGkmh9?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jC/pyk/Nrnm6wTw6yudlqRDzgQ/dwyFeYuM+pHpDRKqYIDJckmqi0rVi4QeG?=
 =?us-ascii?Q?PWn8+w3Bc2AJ9lsmY29iP5VxN9uqmzdwCNwKHC4Spj/4PJgEDbZJcvpXZGBA?=
 =?us-ascii?Q?AemxtALFXuNeXxo6puF0omhI12neOT0RR5+/fkV1RHtxELGgwOb9TYuH8a9N?=
 =?us-ascii?Q?m5PrDn7/A9tHli1jEVBKiaOmTKn0njqrmqctQHIMwBR2mg4k/cKQ8ZWLiInG?=
 =?us-ascii?Q?qqWE8g/oS4ZnFZARaFC2dQUsaaLtHyWcMQdqUPJK+FGBvKMb8aMVrQBxyw+P?=
 =?us-ascii?Q?imtVJUqBg3VeuO8Pb7JWZ4B/qz7k+ZlTL3K73SZ+/QGb+5qx20VTh9UnWdmj?=
 =?us-ascii?Q?4u4+ytQ2YcgVrM/PSF/Eo5sV1Ca+y4Gs1beC0Szc16ucoATu2K3Wj6+QOEpF?=
 =?us-ascii?Q?FKcAna6VjRpbRJKey2s3k+/8W0SzqX67TaVyGxDoAYJGYUOVefxGmVXtEA4h?=
 =?us-ascii?Q?V4oeXKuMlmE1yfQ4cD+6ZakrcULRO+4A2DmtDbEE/MipTlBnjqn6jRUzRR88?=
 =?us-ascii?Q?NQCYvrE2psaNZEMJEcdxz9UJArFGng592QN96ik+yIKLcytd/WdggY1DV4kS?=
 =?us-ascii?Q?NgwjfTEQjS7S9nZ2NaDXpMYwyNEF94cHtvmUzFX+hETuzcLcoeSAwCRtm7I2?=
 =?us-ascii?Q?hEYus0R/e+wZA2vOjBpqBFkaM8JXPlCDpvyRT+R6XbTUyAmh/pXxgsOCklgE?=
 =?us-ascii?Q?x7XxiZ+QcpKLYtiIoIl9Af/VUJWkI7A18o1xUp+kfZeVdgicW83D7aBTQGFU?=
 =?us-ascii?Q?2BtX/0GzsNQ8SOP09TDSpei11EqztgdNaMEzqdicW9CNeIdAmLGOq9x2EmB2?=
 =?us-ascii?Q?8xh+6ECU+Drs8xFTcrje3bREL6NUYbOTDEd6digUROSJuivX3Hh6KmFB+F6D?=
 =?us-ascii?Q?bpLvNC/5ZKQrIVjs9P6a4pP1T89YJtDnEC7BfVtieNXGINdmPe6sj0saCGcO?=
 =?us-ascii?Q?Syw6IChPZ3DMhHY0vMPItEje3p2jEFzwf3Lf9pmJJo6rh3e56DeAG+J5ek+0?=
 =?us-ascii?Q?FE9CieTRPhrtPu+zCCs4cBPEvnbjx1KOYcR4aVOc8Zt2hh2bLg/Oz+6fqle9?=
 =?us-ascii?Q?RojllElOXrg17ELouOf1Ot9biue4kEHg5DTj8q1XYSOXnIS1hl0vbYBVcW9R?=
 =?us-ascii?Q?rbf9bZ0ua5pZA24y18HY0lxvkPK98qCcz+HGgi1+o30GrmhnWGm6lF/Pg9q3?=
 =?us-ascii?Q?vZvMmQVBLQfI+z3qpJueUOvAh2clJh8VqAi65XkOM2ilOpYbignJhx+NWGM9?=
 =?us-ascii?Q?G6Vi+JLuDQXsoMdRQJf/3NzVehcKVW8SRDyTbvaU9B1ZiPf9W0+qbGveApVn?=
 =?us-ascii?Q?l4/T9+p/wdEQdo/z/T+8bzboPqPzXKAdaeUzPXiztLJv8xTzmzI3C+Gw8lz1?=
 =?us-ascii?Q?3Hdp/FwjtYmDchNu/HOGUUEqpcubGjblA7BUutLFbdSps93dZz+MgzqPswBY?=
 =?us-ascii?Q?llPJdmLrHPVxh6cSOOPzLivwNKec8Ez4ifJRqbEVZ6M16ZaT7CW8l+RE/TcB?=
 =?us-ascii?Q?hZ6gzZu+v1wf8e3P9wp//nNUJrmExU/jEtMQvog4GTXHGOlbFxLdNgvug5im?=
 =?us-ascii?Q?SG20mHr20tx/YbpTxgCsl3tcpCTymkem3In8YbqJkgdUlX7DuxR4DOcq7vJz?=
 =?us-ascii?Q?+N1xNuizHb/aLh8QyYvqoyZMYZmodeG2AZowh4bV6T0ZaEopREr+ieboclht?=
 =?us-ascii?Q?+KkVcUhYixUeS5IWODmhd16E50mxRvifkA7zsoeHxNRXBgO3Q3E+BR2/l93z?=
 =?us-ascii?Q?TKNBTEMedA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b918d04d-4cea-4224-b448-08de44208284
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Dec 2025 01:45:55.4420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KACnPwz8S+umFY4hpQpqe6MdVDDhFTUBd90FRi27I9X14zdnZxlLXF8m1sMYQK58g47H+/B45n5xZ97GpksPNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7856
X-OriginatorOrg: intel.com

On Fri, Dec 05, 2025 at 03:19:10PM -0800, Sean Christopherson wrote:
>If APICv is (un)inhibited while L2 is running, temporarily load vmcs01 and
>immediately refresh the APICv controls in vmcs01 instead of deferring the
>update until the next nested VM-Exit.  This all but eliminates potential
>ordering issues due to vmcs01 not being synchronized with
>kvm_lapic.apicv_active, e.g. where KVM _thinks_ it refreshed APICv, but
>vmcs01 still contains stale state.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

