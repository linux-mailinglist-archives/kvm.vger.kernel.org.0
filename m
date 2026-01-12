Return-Path: <kvm+bounces-67709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3518DD118F7
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 10:43:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 546893015BDA
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 09:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDB2C34A794;
	Mon, 12 Jan 2026 09:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DsMhrXjT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277C2347FFE;
	Mon, 12 Jan 2026 09:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768211017; cv=fail; b=Yhia1Do8AyFXdRMs57YyL1X3iN6U8Q6muqI+K1P9UTt4lxqHQx45/pQkR/zLeLlzrIVPiv65Co8zIXEjQ+vU/CCC/fM0wK+GzGpi9h0UfvDnP/ooOwmviqCaU7/srNPtWMa4YdRPxsW9cXpuI8tjuRaLI9RmL9JzuadhRfpmPM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768211017; c=relaxed/simple;
	bh=jHBR9WN6fQHx6U5N+qp89DQege8kbFhk9HpOxIRMeXY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Xs+AbpuRl8YRHHCmZSTS8uH2pUabhfkf2pMk1xQw7eVgzo66MUFPHO+PdRahoYbiTRiWshgTIJo+U0H2ABCSGDMlhklauhKr20Vpi4HmIZOQn0WTcNAPjmHdvL5yeM6f2ybWOW1ndSgVqKDSoTzXgKFl9jb/Nm+ToN/bK2DfZAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DsMhrXjT; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768211015; x=1799747015;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=jHBR9WN6fQHx6U5N+qp89DQege8kbFhk9HpOxIRMeXY=;
  b=DsMhrXjT0gGPUsbBi53vcmL/yt/VwRsY1OJ/GeSgYBaD6VuJwgQrTE0R
   duMa4rD2gQ+WQYs1mKCBkhVqjqA9GSyOtyRva7mzpHOh4VfH0hKgtC++C
   56gWOybNDvKfJPR02ePhvm6S4SvhYP4B3zR49ROcjjarlrYQFpZvz4pEZ
   DfmkDd972Ele2Zy0ppLK0YVlD3Z/qr7kSRq1COlRMAdJwnSHIoAMd4q6t
   CABLNK5VbEGjgq0QRjhlENHZXnks4VVmC/A/dK3d4rQlbGKkWz6A+gQoy
   es0HADmTDx+7HBug80jsNotOst8YQUkb4F4ST1c9j1EwrIydLHv3Whigm
   g==;
X-CSE-ConnectionGUID: nOCGVk2eSdOF2brnTNxfnQ==
X-CSE-MsgGUID: rJdDzDUoSI2BK/DuGdnNGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="80848500"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="80848500"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 01:43:34 -0800
X-CSE-ConnectionGUID: jKdfUHLJQVyHyr6cfm/G7Q==
X-CSE-MsgGUID: svuoe9vBQAWULEQL5F6qpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="204328946"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 01:43:34 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 01:43:34 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 01:43:34 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.39) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 01:43:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kxv4tXoWBL04/awWDiCZhbafZsM5fuuR2OiHyzX23+UayAqUDNrENapcMyQRhJep3k3KNhYybkThMa8p6UnYfvtf/ss/tEkSHSDoatjF8kHQdxhtsJwlAgRTBqlyPIYGbvXiu8NTHcr0Egn9+1HCPjqNXXJGAsUNucyDDRZdCWqI3/AIsczlkXujwGMkXMgAeK4Z4iWJ4yiWxWDsb26XlI3ZPFuPJ32HiajAyjagqwSYKsftSrsqri08qqIJ6B7SY7KxAiCid8hdobgcWou+UP7hnm4GE4r+USQHZAUkr6h8nYCNb7Qg16isk+C625azbgbh1tGJmAoa2BUtXSlrcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHBR9WN6fQHx6U5N+qp89DQege8kbFhk9HpOxIRMeXY=;
 b=v/pz3HX7WRSfBnU3EapUesT956Rh6LwCvAMcH7mSi31x8KBrYGu33KugnzG1mhaVFzB9wyMdMaCCeb7nwkQCUbUJ7yKPiEy3dTA7EuOin7uvlGq3eeinI78QOlHxSdrUtIhaGqJXjFokbY5n43fdXUX13zx+sQLzUbRG70fS2RSha0Trd4lexu88tekUBx/fTwIGC8jUElmOwVr6GCUzgtwszudBZMev6so0FqzdPH4A4AB9wK7oMjb642mjzkbg1AqwUjg1BZv+LB5igVoSqnmRKR0oLntJYeACzDSMDmbOM0mLJamThzRVls67WzwdhH5fPkrqHt/qLp2jgH53FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA4PR11MB8914.namprd11.prod.outlook.com (2603:10b6:208:56b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 09:43:26 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 09:43:26 +0000
Date: Mon, 12 Jan 2026 17:41:16 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <pankaj.gupta@amd.com>, Kai Huang
	<kai.huang@intel.com>
Subject: Re: [PATCH v3 6/6] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <aWTBvFnrT6Y2eF4S@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260108214622.1084057-1-michael.roth@amd.com>
 <20260108214622.1084057-7-michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260108214622.1084057-7-michael.roth@amd.com>
X-ClientProxiedBy: KL1PR0401CA0004.apcprd04.prod.outlook.com
 (2603:1096:820:f::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA4PR11MB8914:EE_
X-MS-Office365-Filtering-Correlation-Id: 45bc8eff-9651-4173-202b-08de51bf08fd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WFh5OVmr6/Op1i2ZEDr1yX1ZKR4B9knCCwEiYyFI48BxK79enTdU25HPXFGq?=
 =?us-ascii?Q?53/H2trFM2008vlGnaC5lfOOHhmzNQZV/fKLbMDzHg0Ul7KfXpromaFYEBhk?=
 =?us-ascii?Q?AwK+6tFar8sJgPHigTN/LwhR6z8aN7a4Tr/R/3NA47ooiYUNg2O0L9Mtgze2?=
 =?us-ascii?Q?/AYQavPowWD+M099aV9iVfbM8saZZUBbCIoZQbRzUGjJkFEWpBRMttX2v4Rw?=
 =?us-ascii?Q?PKTb7NvSQFwM+qXMpC5eeXdwFPpuyOwoFU6bbYrubXXgdvpohEvm4A2eHkjg?=
 =?us-ascii?Q?Op8ZQqtoiy+yWkMhxMFjofAxx8s+yq14+4geezDPY17tsLDQswaeCv/g0uKe?=
 =?us-ascii?Q?2WWU1NkwKY522z5uUdmKbiKNE71l1JDZotYaV+oHxCwG3qVN3pei/Ug+Yd3Z?=
 =?us-ascii?Q?2zND6L0wFdKcrv/F/NEpI7CN+MIJZsVqq27sd4WmBi9U4j+xacJ5/+j9l2nt?=
 =?us-ascii?Q?8C7zUvJycwbntHc5E241SO1Hwnv1QHl4FoMIyOkxTog0uKmc0PTLQCBA25Vt?=
 =?us-ascii?Q?VK/upWWD36Zrw2F0nByu7pCf+y1tmvr98AeAhscI6j+89T7R2asVHh0B20VL?=
 =?us-ascii?Q?xdD8iQbIkX/TIm3tdcS9G43gm5/FGQSnpaeaajwZF475kFT19rzICKJKSMVh?=
 =?us-ascii?Q?zAwHlxeUwyOv05q6pkMdTjixQA99whzGeLWIyppDOlN6dyy87UNAaKJ/f7EZ?=
 =?us-ascii?Q?Z7DvfDOocHjVoak5tr3gQzGkwkQlDf+2GOaArOBD6ntVDKPtSGOiOc3GbDE/?=
 =?us-ascii?Q?JBaZotkQx71Ybd2HmqFZVaTz1HS105MhhqMymM2Ow33lLAqCG6BDw8qa5x2U?=
 =?us-ascii?Q?qI+WtDyDxzRxkTTA1z3oriaiebdZqBQIpNrgEPtENga1Ts1wvqo/0b6liCfE?=
 =?us-ascii?Q?89BX0a7p5yhtX2iy8JbYWnSKX9IFfTL5bBsWh6qL/sKvf6x8DVgCkhuuNNdh?=
 =?us-ascii?Q?9UHfJVY092j3CMEs5jrHaK/O8j1zwdMRloLDICqm8rtyYpvrN7+nFdP0QCZz?=
 =?us-ascii?Q?cn8KbQmkC8wdD3QzuKQ2MjC3bpZBJeO4SEl/xoqKadaKearPTgBC3rI8pvDC?=
 =?us-ascii?Q?lCwssWdndRV90Ly0BXjHHR52d1TkidroTovxfZZJlzOK/c7DSOIGH5+E1jH5?=
 =?us-ascii?Q?HKC3kevRGOWsKTNgSZ2+x682doSEZycFqsEU9S8qkLsbFCFtrgrmjK+EUA5t?=
 =?us-ascii?Q?sgkS06qGqLilbwFRj/qqeMJ5FNb/Cp8kR8I9QgxEumxe9pg+QHRXgdWMFty2?=
 =?us-ascii?Q?KJe1GMjzX6iDhSI5S3uFzbbgkWuIecJYKfAtcb4To46o5c8zZ9ZqOtmD6Neu?=
 =?us-ascii?Q?H8bLcd6vs2Y92z1pf8y6QORS/qDohO1sOYFD/OFQcw5Q+inH/A5mZkXkvJEi?=
 =?us-ascii?Q?hEeKRdqcfZohZVR3iSsBnf8m+0qF0wy422fPVxVfLtX8Zb4xoG95JR7H4sMq?=
 =?us-ascii?Q?dEvD1gfMgMssKIf1MyPRxW1NypqNMdtm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M3w/uZWGIqPmxfqkbSlZ74txsNwLnSSR7Va7AWz4gkpEIN28eJzWyeEx3Hb4?=
 =?us-ascii?Q?h+df+g81YVXbiE1UZL0mMYSYqVMxsQt+foBbQGESBvO8KzTWn6WG7iDzNDMR?=
 =?us-ascii?Q?H0kmGP8H6GI20xeZymQ7nXS6ru88oDEyDw7ljak8ysCBkqrih7W7udkOdUyX?=
 =?us-ascii?Q?a36g0yIzy+SBKSrk6PsYslBlBIF0wXF98REeKMfTx5ki9LHReDyM7efnLqca?=
 =?us-ascii?Q?0jskPRMz2Ges6YP1zbUA0MJ0+00wn+8rrolYbsubWTIDw8ibaLPy9faAI9xA?=
 =?us-ascii?Q?6aKxOgbd3dg/PuM1nO0oHxJGniSiWgV1Yi8qKqJwGz8LHIzU4gfOnihfPY5u?=
 =?us-ascii?Q?0rbxf85sVJS1VD5iUVZvK5e/KdE7LHLzznqMhwtI4otjF08Jex568F6bPHVV?=
 =?us-ascii?Q?DFmAlUMo+vTAamg0tRzuqp/3Pl1V1P9SDYfrEJP8KULoYRIcVrpndQaxTXkr?=
 =?us-ascii?Q?kdh68oEN6curA44n3tihagzLnKtUP3HvjZaBmnOyVmr213BeMZz8YIRI/WMt?=
 =?us-ascii?Q?vUDzflJgRHHkH2r9MccZzWl4ntNfWhDzgNWszPppyatMiUr1hxWhgaizcJqf?=
 =?us-ascii?Q?73U9hZfI1et/lONWWU8FB4uEq/92VOvyVpPkkhIOndnyUCQkU73Fkqz+dORv?=
 =?us-ascii?Q?gPqixe+tCulixrAfjskBJmXNCgn9Am7NKePkGyYwgpFYUGVWB0LMQ7qKuT5D?=
 =?us-ascii?Q?8V99UtR8FA87YK3+H7i62n4P2j1NKAbPsME/K6CaW6gXmm/jK8nWFJEaj88X?=
 =?us-ascii?Q?Z0WApLjKJlDWcI5kEAs3ctuvhQGHg4BDNmC/jJb+dYfQsZC47suChR0fU2ut?=
 =?us-ascii?Q?jefSK/Bk1IQPfDQC//0MLE3FYEsGNsBBL5r57K3KMUMOQufqmicHpXB77TV8?=
 =?us-ascii?Q?y5JVbYCb8ZBE2E6bfLh4w+2nDS3tgANSbOJDIavxhyw0lu865/nEyUVLxhMH?=
 =?us-ascii?Q?lvuNKraxYWVEnDwpvOTGYfXIllQc5sCJGm2yPpOpZD6h9BGTIz8BZPHLNWdg?=
 =?us-ascii?Q?pU5HVC9bYk5Y/OfQv/SOcmSSYxOnNDng0bvRC9dBXL+BgbEqMqkgt4msYCyi?=
 =?us-ascii?Q?BBvF3Eikzna18/B9L06/5PV51mQWLMeBTF/kxUGNJAIvGLzI50KE40jofIvA?=
 =?us-ascii?Q?al7SlfeLD+TiSaRHmHzvTRulHVTJLqSABzDGWRKEfp8fFgycjrEnqLDyyTHL?=
 =?us-ascii?Q?8qh9q7S1IKoth6cJuVzhiwIlB9BYCY3jh9IbyJV+OUsVA5TNEdQ8MBxLMZjt?=
 =?us-ascii?Q?TIilt0irA56bfO+OZL4TAA32n0OxtNOQLXVg8XKrXfpNINZF95l+vwlTAvN5?=
 =?us-ascii?Q?mNGjyBKxZRF2jWKE0aPdh+D4RF5+yqIzJraLSKP2E69cS2/c81T8EJ7GPCT0?=
 =?us-ascii?Q?9gBMSTJP2tlSFGBslK2u4XE61nIYUa0OqFV35+OAE9IZtrPaQI5xv2etddQq?=
 =?us-ascii?Q?m3ljsVA0wIB72n4wXil4wYiVj164J+yHopjrSPiVzergxGqmfWbRrscNYWhh?=
 =?us-ascii?Q?8h1IQU8XMfgC3og6f2PbXgn9OvrxhdadBOA8XlOylWZ/GekJxwhxVeYSPlom?=
 =?us-ascii?Q?yjx7s22Fy18wQ3w/vTp7nW+D7VokDNRXG9u1l3jrXPvx05zVlSXhCBK8enEU?=
 =?us-ascii?Q?ACiyUbgioA66VexDszFfSmP525sTxqEtkiccZWfNvzXt72M0ATMPUDMWF7O6?=
 =?us-ascii?Q?mtaphc9NWzw1DhEQsXFA3c8Ix8TZ5dKNS9BFC/BzU0I+D4pq2+/Z0snoWAx8?=
 =?us-ascii?Q?KtfhhBZVyQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 45bc8eff-9651-4173-202b-08de51bf08fd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 09:43:26.5758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LZufLjXLfCmdb+tZLrN1wbspNw5nN3yDDPvY1QcknOnn6d9Qw78VRNOtDWw5D9HwCm56JnLpjSmmoRHgBhTlvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8914
X-OriginatorOrg: intel.com

Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>


