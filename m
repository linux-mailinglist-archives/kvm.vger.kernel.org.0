Return-Path: <kvm+bounces-68306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F43D30775
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 12:35:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 26C393139301
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 11:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66552376BC9;
	Fri, 16 Jan 2026 11:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hMC+xIyq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BB6363C64;
	Fri, 16 Jan 2026 11:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768562918; cv=fail; b=oOZ5emCo3qe6Rz+scqz9/0+P7IUvAElIm/NdnobdRsaFOSVTVOo0/owTLIs7Huq3ZKMOQJAUHGvRNaen3U7WKIkHIBVTTWuKL9er4s+94o7fSztun4gqx/y6tgrGyaX0gfHItO71D3HjWxFZQASfypcTeaofsr8lf7GJMvYlfcA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768562918; c=relaxed/simple;
	bh=be4q3SqAPOVCVYAKCRKqkzGgprjgrtfpQ9aAtcQ8bfA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aAcn95PKyB6/2pxCSUGgUuUgW0zN0yCBhl2NxULZq6DbMkq21HxR/frjX/vTtiJ2H/9VpW+LPullPsF53ixoiYaCFDoF0FrZA8ib/t5qGaepSkgTeIgS5h8pY27TOxGL7uL//v+8PoO3YVirUVkgTFq6WdM0h2cVbYUzcZVPf6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hMC+xIyq; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768562914; x=1800098914;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=be4q3SqAPOVCVYAKCRKqkzGgprjgrtfpQ9aAtcQ8bfA=;
  b=hMC+xIyq98ZXU36NvvX9l/haG9j3aPyaQuGwNFnCcC9JG21Vs06VVqac
   l95aaMTcVjsnR6ebz5LAeZ3DENMZzMVHKQlmr8FmX++mWXYnGMymFJ1Bp
   sP0MSyJpJ8t+5ZfN0b4+4An94JDg7rtoP38yX0quSZkKbXtZ5wEkQ3tOm
   sLCwC9AFwtT21KUrz4Wk+k04IdY4NFi4ivAmgsO2Sir1WzpNBGYiG7p3y
   JE/QyWixavH10s99X2QmvJgZyR+gR4x+IR/ruatybL7xb8KTsiX4ZNvWg
   JdvqogA/ZKuVJFXCU4RvZnh5ctYnXeiSjEBbBmD7CZrZ67wKDgYryECv7
   A==;
X-CSE-ConnectionGUID: meU0lVpOSlmVY8ZgVc58tA==
X-CSE-MsgGUID: ZX6ejn2jSbW51/fo3UL9eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69968126"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="69968126"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:28:31 -0800
X-CSE-ConnectionGUID: Wv3c/PukRp6n9ynYvvlTzQ==
X-CSE-MsgGUID: 123y0SxJQ3WDhUml4kQSww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="205501368"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:28:31 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 03:28:30 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 03:28:30 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.25) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 03:28:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oc6N0oQdKP6kv8lxga26Eu8MyPaEDZ4NNOvHiOEUKgrVj/9d21IKG27myE+KbqX30IO8AKASovE0B3xwx+H4c8hPKbkLQ+UkFYJSN0MP2VN0m2KZgh6Bm58bOjMDiOoP7eorCLzwhYBwPLYnTbfmHvPyw6vqpEE3R+lWhvVATs7x87Fl2TQ+LS5oZoUQPskSyS4+B0FkUBwVj83TGcdCqB12cHwnaxbQzsKBzznpUNDpiNv6+t8KJXCO0wIDxAiGweoS/2fYuCFoincluZDmO89dFOmnzSi5BjDMi3jmiktzs7UaEd3T+pmAyT+nM/Zo6NbwIqLJzRxrw4y5fD+2iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NR0W+8CCYbNyYP1wyJFOnWlJYddmqzo40yV1KsRCOP0=;
 b=oi+90aZnx6UgfAGNDh61c4SBOhTPRs/X84O3XWc/8KoYQxmwlYWDmB8qQm8bsK2PlCryVxH4ePx4IU+l+KGWBYIq9Pr7T47c4EafWjoBcc13xxP0O5oRyf2BTAa+47L7KlY0k1OHdRssyhK46G8f6rTxg85RIbSXwmkQWGYBpAAk9M+97EZ1FRRpCFkCOR5kWEW90yXc1r3V9h2Pd3pDWWQalyDaExhALHBySKe0fMBH4eC0TixM0MyizxmTuiJvZml9p1w1kNqrsgsDBiG4uEx97rVDRi0UJZMvt0+YmJOpfoMv55SQLatbKYjIqjnsGk8bBJYPDd4sT0gniYacag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4582.namprd11.prod.outlook.com (2603:10b6:208:265::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 11:28:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 11:28:23 +0000
Date: Fri, 16 Jan 2026 19:25:38 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <rick.p.edgecombe@intel.com>,
	<dave.hansen@intel.com>, <kas@kernel.org>, <tabba@google.com>,
	<ackerleytng@google.com>, <michael.roth@amd.com>, <david@kernel.org>,
	<vannapurve@google.com>, <sagis@google.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <nik.borisov@suse.com>, <pgonda@google.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <francescolavra.fl@gmail.com>,
	<jgross@suse.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <kai.huang@intel.com>, <binbin.wu@linux.intel.com>,
	<chao.p.peng@intel.com>, <chao.gao@intel.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Message-ID: <aWogMveOU4YEpQ4q@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <aWmGHLVJlKCUwV1t@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aWmGHLVJlKCUwV1t@google.com>
X-ClientProxiedBy: SI2PR01CA0042.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4582:EE_
X-MS-Office365-Filtering-Correlation-Id: 38bbb3c2-5735-49b0-6974-08de54f25bac
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?IE1YvAKGMoPtevf8qlSenGsbqEmwfYUThoZ1oXOMvWJHgTC0/8LzrV5pK5mg?=
 =?us-ascii?Q?nRrMfNv1dW1JzA80H+wlvAzl/WyHOjlrV0mc8Oa03DlcwlnBQZI2Za4EBFR5?=
 =?us-ascii?Q?EAhPxwJ4R6732eEqTDHOn3QaU26jvKwBZLiRbLlxr6760g4o113G7Kb90+7/?=
 =?us-ascii?Q?GUsfzosH1HZdVotJTC3kXLnNYorTSbAOyerwx3six/TRXpbE4OpjIwJNsnWM?=
 =?us-ascii?Q?r++tzPSt4MVCZi6nUuykx/2QHQkQCjkHnCGqNiLtEMbrM9qv22Gqy1OqmHtk?=
 =?us-ascii?Q?tOJK3LZ1H8jYFKTckZXTLxy4vsyXSiVIEe0/IAdu8x+aANRFTY8hLOd1LLuF?=
 =?us-ascii?Q?hoMtQN08VBPrsVu4hofhCgyfPP/R+JnN3AjFl9yl7eWPlI4XI0ThY94AGPjr?=
 =?us-ascii?Q?WtTTxUZUPdwyo7netn6v0Q3Xuz/BQs8th94f/w54GY89gAd9DHpMcbQaWwN4?=
 =?us-ascii?Q?m3Kd6Y/xWy7NKIFZR0OkIuTZXqXEiUSM8BiNDQCXq1oT3ml/jzii2iNDYmGQ?=
 =?us-ascii?Q?7wcwKSCiWuaAa8vZoj8WQSvKEGeBEhJVGgN9xbYnVl14XinBcUieJDUiM0x6?=
 =?us-ascii?Q?8rpIYmLIM0aljHv5PJ12kcf+C3mU0f5AYS8ygt/d31KykTzLapcyvRU6mULc?=
 =?us-ascii?Q?RwwjHezSathp9WrUe5IcclISl6RVywIxVM11ZVMpt/RpZNOqyJWEBrtfDDtv?=
 =?us-ascii?Q?7aHDgzC5thDbZuY2moJJ3ePiUtRXp8KVkTeK4zhV9x3WRxwsVhENYCxXhq+y?=
 =?us-ascii?Q?LpMgfcmJVc5fC8b/13hgsWVG5DEH0jBHb3VDz8GvOyzzNUAe3QpHeP5xRAja?=
 =?us-ascii?Q?sFEPOBwxKoKQXIXiuUZpc9gdUQ94MB8Hgf/dmQ3YZbLcw/zLSDnQFezwoM/g?=
 =?us-ascii?Q?YUPQHdbr162/GywTsBfyxXjjdCVTQhIXvEcXPI9dnKxWPkSZRwJLYKrG+rae?=
 =?us-ascii?Q?zsk4DjVyGNcCEzNaOtJCwNezqrIcQKMgRvDK+zdxwgRI3RNxUEh1T61Inzc2?=
 =?us-ascii?Q?Ib/rrka7UNYdlaTV49WcDTifTz5eOwgS0vRBA99oZ6zFwXfv+OdWSE4mbuxf?=
 =?us-ascii?Q?GuOAZXO0Me57U9VseFFxF6Cv1vEp9lldNHUu0/fDDCoU0KE4Qnqqv8ykJp4F?=
 =?us-ascii?Q?Ig4VDro+rwuK7LuLxsK78nQKaGRNG0GW5zd5gdW7SILGPTpDFNdM3F2mtfOd?=
 =?us-ascii?Q?NoycHeXIYkhuWGOe5gUVXDUn3DkyIvqcVrgd87R65eqFbZOqrIKaWqzzAiL8?=
 =?us-ascii?Q?SzhV2zJ0V6ioLY9bxBtddxFokUdQYDOGkbrbvr1QYna90KCUlG+5Nf+eoapg?=
 =?us-ascii?Q?iLOEWgI7o0MB9c5uL+PFghdrZd06QPUOkOchBvuLhiq3iS/QTPiEqLeQsJ36?=
 =?us-ascii?Q?1OdBxNppZIooAojA+yi5vSMk7U08kWZNwq6RpBtfz1B/+tC6yHhXIOZOlx0I?=
 =?us-ascii?Q?63LAXhxyYBZ2EhW88Ni7dRrT1R31FXvfGCQn88Ak4SmIyObe3X2ajZsBQ39Y?=
 =?us-ascii?Q?4jHxNEHcVgNZknoSWz+/pwWanOtbl4IDmrPIbcWPsNUgXIxW6UZA2rEzeVC1?=
 =?us-ascii?Q?1NFLqvtU2jKt2UwnQ3CTvD/Lb4bFbK0tdLcziTKT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6o3Awfu+dJja0b+053JOX31rZdCj+Zx81xG7cbURRuEeIWK9gMxnxhXnxxLt?=
 =?us-ascii?Q?OD/IhzTtPl9PleOy884EyUiWGtHnc3/tx30pqsAlFistNuHB02ulgBC+LA7I?=
 =?us-ascii?Q?ak1C5qUlsPZk9/t1kjQy2tMJ+emGf9BiuUDBhHrsLYz9q8BfSBBKfxElWqT4?=
 =?us-ascii?Q?/y/D9Z/2MMkx+gm3PBxSOeROhT0+HLA9Z0ykx67Cjpdmzt2A0U1pgtCtb22l?=
 =?us-ascii?Q?1mq8RG9nJ7qHMkd3WigO0jYWzK8ZsvlIpgQhNm6oJdH60yVyHxoN65McqQGy?=
 =?us-ascii?Q?L5BHWRCbFfll0xui7RdbMpthsAloYaSNCvJn4xEIftOsDwhTK18bESjeLbJi?=
 =?us-ascii?Q?Trh6bdkeCnr+7FfUfKD/fH44V+ih5j+Cw2R2GiBQZ40KoAGNPxWEup0Xy7fP?=
 =?us-ascii?Q?a8a+6E5eE3krJeVsK11ttkSBcqN3d3RGD16i0hoa7EhXANCn1rxgJYlrpd4u?=
 =?us-ascii?Q?rhYVhTi+Vuk8dTE1PllfP8hGKYXiYCoZUrnCdIQJieQhyFC52898eJP0a2UL?=
 =?us-ascii?Q?9PcO8ty6Ee1YGc7g+ioSbBoZfJLV3+2lpRhiqHmptmuwj0hTanoXhrfNM6IC?=
 =?us-ascii?Q?l/pvb4z0ZQ+EDx4E/jh8gaXAECBVG17yepZs/TN5YRjbt9WaBQayZsXqSaFK?=
 =?us-ascii?Q?KMr2zxmxemD8oiB8QA0i9MV5vni2vAnaKSUSm2hTVYBkFN9NRRCSIpPhfYdZ?=
 =?us-ascii?Q?qgNpAxd/la2d1RL1xpRSbpELGZDa11CpXQawIs8mVvIQLiIVsfsZsumXgazv?=
 =?us-ascii?Q?9/kzZbB0lWLJ6AOx7a/ype+ZhMl4HBri7AgvVAa2GYkbapKXX/h/jPximhXy?=
 =?us-ascii?Q?wdvEsHMEaofJ3KwKkEdaw+9tNddjqa6/EVt6UvBe1ZQYzJ97gMyLnMF4Oxn5?=
 =?us-ascii?Q?uOiJwLXI7j0x9HnYSpGCf2UovSsc/2w19fNwh9SEGfH8wPO34XBjCWrTwjhy?=
 =?us-ascii?Q?T2KWdtuO0f3Lh0dCPTJyRgtvDs6RdsGoJcl7CjI3LFl91/2QjCbSfNlGxLqq?=
 =?us-ascii?Q?TP1j5AvVtp6RkeeQf9EaXvo0WhQ1qgl3Yci+UTc+ZkAfbYy2r6lVPw+f78gG?=
 =?us-ascii?Q?/BaZM+xJh/vWyGPuwp+0o5YWyiM8hIpM/s0fFben3ttQNBObj50NQR6Glp1V?=
 =?us-ascii?Q?iOv8/sZvkT23BC1/lt02KRuusGUVfLSw6VREzP2EPKiiW41p8Hx2pi35OYWh?=
 =?us-ascii?Q?6mYZkxaVQ4CVIE3sJ7Rek/x2i2Icb7g5vtbaqOdEE7WM0OKxUQsLFsOQ3/JZ?=
 =?us-ascii?Q?N+YRimJ1kAGw9xNFcas5bm8o/SsxscTeCY+zaRjPv917tvz7EzSkdimy60qu?=
 =?us-ascii?Q?6wiN6w3Ye3AxlyxJTabVM5wkRVLl/M6gRf4xrCLHQfyEBzKPTClBUbf2l6po?=
 =?us-ascii?Q?UXAySE8McPP7YU7FuAeIO1j8DbLkb/zGfKQk/73+jAfXlW2+z79qgpHW5477?=
 =?us-ascii?Q?ssMYgSilZ4YZZwbQSNV8G70KIrLVsm1ZCQayn+GQkro+SjrRtxrcO9cyJGv3?=
 =?us-ascii?Q?WCY2oO0AuHhP5rATU3qja4M2eswJvd7drqS/+DiMf7xaYF7exAF1QzWQdgOv?=
 =?us-ascii?Q?czBN7Sg6wBnBdD6XRMQoHLOhXtwUh7rWl6Sok7SVrGpHiEll4WZKbUOF1leB?=
 =?us-ascii?Q?4/MotB7G/67gYcsa50xy8YaqNdVn2cPG6TfE949vahWsHecnS5MpgqHvTa+8?=
 =?us-ascii?Q?sGyjZ9jmsot3F6weMq+vX/r6krGzfKU6xNo4Vl0Os1Nfbdwul5whzs9awTL+?=
 =?us-ascii?Q?I4wYYvjXYA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 38bbb3c2-5735-49b0-6974-08de54f25bac
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 11:28:23.1819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9SIR/ULGo4LEYNt/cboMK265LKxy+GGHdhaYUVUpn485M6dvxclkyE+IJhxSCYn/PyjuFJNkjuF54GpEMcrzBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4582
X-OriginatorOrg: intel.com

On Thu, Jan 15, 2026 at 04:28:12PM -0800, Sean Christopherson wrote:
> On Tue, Jan 06, 2026, Yan Zhao wrote:
> > This is v3 of the TDX huge page series. The full stack is available at [4].
> 
> Nope, that's different code.
I double-checked. It's the correct code.
See https://github.com/intel-staging/tdx/commits/huge_page_v3.

However, I did make a mistake with the session name, which says
"=== Beginning of section "TDX huge page v2" ===",
but it's actually v3! [facepalm]

> > [4] kernel full stack: https://github.com/intel-staging/tdx/tree/huge_page_v3
> 
> E.g. this branch doesn't have
> 
>   [PATCH v3 16/24] KVM: guest_memfd: Split for punch hole and private-to-shared conversion
It's here https://github.com/intel-staging/tdx/commit/d0f7465a7f56f10b5bcc9593351c32b37be073a4

