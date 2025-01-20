Return-Path: <kvm+bounces-35951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A4E3A167E7
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 09:06:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B3891885FEF
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 08:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF836191F91;
	Mon, 20 Jan 2025 08:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ns3rtE1g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1055A47F4A;
	Mon, 20 Jan 2025 08:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737360390; cv=fail; b=uPqiot/ZPFOQDvSLUpNkFqSvH51AcT/XY8G+GzjXvWhh7vNrszWJFFeWIZjC/nR+DXmkTRd2aCb4QNZbHppFi+Hso83uK+Zx7XxnKOwhf2OAO51mrdaPGPOE1cWChvgG8Qg2HqiyMdSDZbB/vyHW1SEaLaVveBAiVuvb5g+BQ+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737360390; c=relaxed/simple;
	bh=4pLis1bpMUU+MTueJflwR9bXEbIFZzENXeuntTyxbXg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OklcA0eLW5LJzn63Qzw4TybWuQ7F/qBIibICOiOHfEZhcoMxsHU4DubfPSgK3a5ra7y3SInYdiVQ/crT9KZwEYYORXxD7gRdxbzU2TLC3YNAjzcDjmzAmBUi2Xa5peJRic2/XinnQXqGxhkG6JOPxNq4FXxEjT0bsg94JmOjvVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ns3rtE1g; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737360388; x=1768896388;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=4pLis1bpMUU+MTueJflwR9bXEbIFZzENXeuntTyxbXg=;
  b=ns3rtE1glJ5mHMjF+Lu6Rkd3I9+HppJl/hnvTc5PT12mND1+v+7CwJK8
   0nqcxY9WA1KW91GmN0eWqJO/EeCA4OHcESOmdOXxeUcAIbnPjFRX70ix/
   d76G9bZlwkfQFnmx7Ljlfxeaocr+2rNN2PW3QYd9DJWC4CG/Z+AtLm17C
   8qv7LoGBAz3mqMaW0GJjrAVcZvkND69tNUEM3W/cOnU/gkT7vi9MckO4o
   0zGK1NMqSFIohTgzjbsejyxopwhsJ92WevJtgw2YtdbLa8C6MYSGLKJmh
   ji5TEHirB3EzFtg73drcKNhmr+Vh8Rc3Wgq2kmSfs8xAaxjFSIKMJ2UFT
   Q==;
X-CSE-ConnectionGUID: P17y/6CXTUKkuzy34XibZA==
X-CSE-MsgGUID: QvzdvOp/SWmU8a7fwxPdAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11320"; a="48721920"
X-IronPort-AV: E=Sophos;i="6.13,218,1732608000"; 
   d="scan'208";a="48721920"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2025 00:06:22 -0800
X-CSE-ConnectionGUID: nF7/9pvnSnqS3sm/4DJXYw==
X-CSE-MsgGUID: yXSFyTbdTjiDFyCB1u5bDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,218,1732608000"; 
   d="scan'208";a="137262679"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jan 2025 00:06:23 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 20 Jan 2025 00:06:22 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 20 Jan 2025 00:06:22 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 20 Jan 2025 00:06:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yF5zsbKmPFLo5RT3cfZ9qdb8+p41wQHhdCBQm5D1TKxPoLoJC+J0zH3mCcZOes3aOvg637y/eHJBAKtYedoluOB7LMcLiImH9QwfY2gUneGlZNoCEEv8Dras5h80E8cB6SsVrMEWeaDJLXPewqBel/7cGzNLjIBpAhtTQs9XGL30OXFkiCevjDLkDuD9pkN6d9ejC0qjPgg9EB9vReM63nn2igq4QcFCT1Z8absaXWtwkrQJN6VIz7/vom9sbIeyrrDLGB0P9VyXeHXXirWvWAqUxyxPolOliXgjYz2Q2Xq4pVupDehMSS0aLN+IAA3Z/08gYa4PgyQBpvTC6CuNzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3oRJ524jaIqdLs2UpDTHJM/wTF8DIEdxDD27+WXe1nQ=;
 b=G2cAILuGf3mdmLM5ep8dkJ7X2eEa02TG4auLFeXyTor9Rf1+QHBqb3pzSxqXM1K4A0re3W998or8vf3bMvP77oxOxJL/LDKGvYNVcy/Hv+SF+aR330eAMGCdTYle7aooYq3ICltMWTXP2HnoSlRXRBSqvYR3pVf1F1AP/lhIlVqiTx3qAe1tfA4TpfIOUTGZNVvyyY7hEnosRSiYb9pxIKeHOfm/qomftzR/Nsfz0G5HxbsnlgXVkrNbyk77TRddS0gMYIXfNLG+GfmUJtUvKogJU6DUOrSAShkv4QRQBn7Je8QY8jJXSRuvJUXk44NeGaU8U68cVHmA+Q8nrdGMqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6772.namprd11.prod.outlook.com (2603:10b6:510:1b6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.17; Mon, 20 Jan
 2025 08:06:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8356.017; Mon, 20 Jan 2025
 08:06:05 +0000
Date: Mon, 20 Jan 2025 16:05:06 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 3/7] KVM: TDX: Retry locally in TDX EPT violation handler
 on RET_PF_RETRY
Message-ID: <Z44DsmpFVZs3kxfE@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
 <20250113021218.18922-1-yan.y.zhao@intel.com>
 <Z4rIGv4E7Jdmhl8P@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z4rIGv4E7Jdmhl8P@google.com>
X-ClientProxiedBy: SI1PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6772:EE_
X-MS-Office365-Filtering-Correlation-Id: 77fa25fd-ef87-43c2-c5a5-08dd39294a1d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QFB2Xn7d8mTESw5lzxIPzVcAODP6dwCMPNRogL8e70AAtq2k6zFZvKEr3CHy?=
 =?us-ascii?Q?gxVxYiqLCXBoyEXCbASJgF08gw0FvSj8lFP/2eXCQR9tgix2hMWjIW0HLVqJ?=
 =?us-ascii?Q?FTg1MWYXuGiOhLvCfQpsOIyaxX5lfi5m1DsYluU//3P07o2FYJvaZOS8ESa6?=
 =?us-ascii?Q?zmzYjQb9pXlmRNpsPE9QTd091nsEloY0SPPmEcGadH54gjJzQOicbfB2m9nl?=
 =?us-ascii?Q?Jb+253ZVu2yljtkl2a8Tk44sNPcliBzYWoD7PtXOvnW4CGgsguoWIFf2McQJ?=
 =?us-ascii?Q?DJanpGb1oMV+x8UBL4ScoSbhfx4sXyLUSs4TvuhPkaCaJD2h0tgQc0zOR1Z/?=
 =?us-ascii?Q?O2iIFeNOsAnw4b7BzeZQWUJgYQvtw9o+W88+BD2kgglGpk0okdmNlx/O0obV?=
 =?us-ascii?Q?GHPoTcVxJuO0qrt5c+1QsZxgH56JfNA2LXYl0r5YzKqP+nEmsJTIpOPqTwdT?=
 =?us-ascii?Q?0xuTbDWiU8dpUz/voqokcGn+leZL/LQVINXu7WdepFOPzqgwSDimt88t887T?=
 =?us-ascii?Q?7TBrKnow4E/7lqyx7M6GXacezYIHOxRLe2tDZiCgJ42sVIfoQhD4u1rCrWUE?=
 =?us-ascii?Q?wkYCOeklvHVsNUI3JHqURyGqS+aji5d5oaSkJi3up9qtI0u3luwuxXjX6X2x?=
 =?us-ascii?Q?LaP/ooPXwTcl6i9d6La+1TdJdGNMT8AFFcoMjGRQFIBRO0DHoT9CySz5Qf+t?=
 =?us-ascii?Q?tJ66EvafGPwdpz6/tn5wvB9nETpN1wYN+cFJWbXct4tg4BImaSOlS9FVExIy?=
 =?us-ascii?Q?MVFRubQqGN/7Swzfcg7l9RNxfjVhPjmbFhi++fHM9k7WehY+LXxjY9ZdXt0Z?=
 =?us-ascii?Q?R5PPYDXZAId9Y3ght+YfZdxW1JIy1IUOmAMEARTxuffQze+LKGMuBcGZY4GV?=
 =?us-ascii?Q?TcUPkq9o5uZdPKcI4B9DupRMcVO6ze+n2pudYi2ZA9yh0ixy7oLNq0diDFFy?=
 =?us-ascii?Q?X3yyZ4WPormVWHACM130df7a2Ou2I+FSTvuE8Zqu7L4ogg2SDdfCtUcEq3c7?=
 =?us-ascii?Q?Jm2fiYslO00GXk8uXTyTfK1uABgnXZDGm9+Xgp+4bBeB991fRPmGHzyY5MWY?=
 =?us-ascii?Q?+2TzTflo0UYGXbEPptpz66PKwShjdFULSfA29Nohq522psYxh0ineyiOUlsA?=
 =?us-ascii?Q?ZSvNLeq1tDKVbP8etX7cdpvpN89xU5i0qHSrs1sKVl1sIlmNP9G09/60QWPy?=
 =?us-ascii?Q?TLaprH8B+5xvAl3u2DLdt/ZYlP5IfgrKtGxcsPUNn0p5ep8lf1h2X3krmVck?=
 =?us-ascii?Q?OCdq1xXbt9K5enB//aB7Ow3NJj09aSWfi09vNMrCfG7nHh0Kv0A0T2mLPXsL?=
 =?us-ascii?Q?GWt5Hz/jXoax2JZd7GXthJmcNtqP78lq6HsrUtbJVEvSetoKv2nnQEqIlVqL?=
 =?us-ascii?Q?UV4cXjTEcw2C9G4NwbgMabAGRb7r?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D1MfIE5mlM4G5TBNaymJ3NY1pCfaUe3PePo5A1RVGYyoeOgxPcSMIaOQPI5u?=
 =?us-ascii?Q?ki4F2Utgk/vERDyLVZQ4rskKs5t3S6DzRdCVlDHS3Mrg/0/Zj+Tzmu413fBE?=
 =?us-ascii?Q?OMpzuX4nIcrSAJOUL+pf22LWS5oj5mP2Sl/YJY0mKr5C2TaBHjoCA4FUHcq6?=
 =?us-ascii?Q?Q5fkdtBAEA5Y6HN23PE6K/TVJ7qpGYICKK7YpFdJDEacwGw+IGqenneIBVpI?=
 =?us-ascii?Q?C4tZuo1bKo7JdMjCHi9vZtxJPO+RHOdyvEYOJN4Is7MMfnwGGFOVFVAQILn/?=
 =?us-ascii?Q?4ZPyf9F8VJ5m1XZu7U6O9n0fAJs5jlsubJrieUPrZhaGSf4QNE0kyizfxGiD?=
 =?us-ascii?Q?9o1t/knv+9DoDZmHnT6LWyMZRjyZp36Bb3WjSH7qqpiFNC+V5E7IZ41OeXYs?=
 =?us-ascii?Q?3FB/drrhneatwNpd7CWDQoaPsadiXHpE4htwi99m5uAN9k4fdGoKFC2OrbPq?=
 =?us-ascii?Q?YTHvTTjDSVKP/3j76n0Ia9jOdMvIzYrXOCPL1T87aIValqhsANEGnvFqnkFF?=
 =?us-ascii?Q?W/Ye2izzk8mn/b6PygTLiCngY+jJDBwWpguYL/p98PbI8rp7yUlv2ly+Mcs7?=
 =?us-ascii?Q?ZpecOQbMu30H1AARE0+gbU9nCfIBWKLjmKxxOpGQ+hV/6zlxQHgMewFOHcc3?=
 =?us-ascii?Q?C0mQmkz2VY+JwLZvQF1tL1f74R3UgcI2y1B2wCkR0dOMUjYtHaUoEn0G2FAH?=
 =?us-ascii?Q?jN5XKUyIuvC78J4hsBIdp6fFyvO9Oa1APOMDFXcOEd//8EyemIYvaT3j5fYF?=
 =?us-ascii?Q?QuoCnWr770Uuwli7s+klOWcMKPMt3y/wGyjSh0bxrrcgAeJuSd/JeKvBIwgr?=
 =?us-ascii?Q?BTvaRDIEZcniiMkXpf965/bpqcqbi+1QDJhdFT7/04P3z0U0094JT84juG4g?=
 =?us-ascii?Q?yZFHZkDkSKsSsxQZM990sdY72Wl0VR8t85qv4WuDrKkJXX1J/xblodnVZPl6?=
 =?us-ascii?Q?jbHV/C3lL/mZqgHUFrawKZyl4HoxR8ve/QdD9oh09VMsJdsNL7EMzybBKtMn?=
 =?us-ascii?Q?Zl84SNe3NIG0btFsoiC+pnomzGkTZurT3eseTsb+uTZVpftw/dSvR9dEpanB?=
 =?us-ascii?Q?X0wzJU92wQmRyJdtyY9tRjzhz9vsteE2lP/egDoCqw/KdK5663PofC3XdH8n?=
 =?us-ascii?Q?k88JmzWsY3FYX+gVUvBdrEv2DZM2pi/dwughcShDt3g9qV0LSloP9KMvFdfs?=
 =?us-ascii?Q?8jWCbJRczQfxHhoDkleVPZ+xTQB2wl+Y8Q2ljLEPXCOq9nF6Azk3jii4dO82?=
 =?us-ascii?Q?7C1xKym/nLEQoC2YRMXkk7CCRGQpq5Wa1H4EzmwM7C2eH0zus1c3PCQauwQN?=
 =?us-ascii?Q?kY6D5vnf+/Zwc3wDjCGwXTM+4GXG8eBEOqOufQfEK6TQ3W0b7B7H3Mj2FlaK?=
 =?us-ascii?Q?HyOTTH6LKI9oHvA2zeXVHq3p3o87X40FZzUxPv7r82vgQjM9094ab/oJaVCo?=
 =?us-ascii?Q?huYQ6E8gY5rpTjNBfcLtp/W9tL3f3LI5fn0taNo1VGAySTJSmACegraMZIQh?=
 =?us-ascii?Q?Cw2mUkS3zXRvnzkUnvsXFBkzpkWAZT9rDiEKw6RRQOCFD6K8RL7VBUr0bfnx?=
 =?us-ascii?Q?8aoQmpxN974Mj/M3ZJhZTpV0Bf/lA2z54oL2JVj7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77fa25fd-ef87-43c2-c5a5-08dd39294a1d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 08:06:05.7522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbr+He9KxelQpTP0NnVtCaIvIIdzFbqHzwk8+4MplbK7/znS9+FbJY/hdOXzLkloSzZGrj3ti4jrtfYhbgxFkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6772
X-OriginatorOrg: intel.com

On Fri, Jan 17, 2025 at 01:14:02PM -0800, Sean Christopherson wrote:
> On Mon, Jan 13, 2025, Yan Zhao wrote:
> > @@ -1884,7 +1904,24 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> >  	}
> >  
> >  	trace_kvm_page_fault(vcpu, tdexit_gpa(vcpu), exit_qual);
> > -	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
> > +
> > +	while (1) {
> > +		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
> > +
> > +		if (ret != RET_PF_RETRY || !local_retry)
> > +			break;
> > +
> > +		/*
> > +		 * Break and keep the orig return value.
> 
> Wrap at 80.
> 
> > +		 * Signal & irq handling will be done later in vcpu_run()
> 
> Please don't use "&" as shorthand.  It saves all of two characters.  That said,
Got it!

> I don't see any point in adding this comment, if the reader can't follow the
> logic of this code, these comments aren't going to help them.  And the comment
> about vcpu_run() in particular is misleading, as posted interrupts aren't truly
> handled by vcpu_run(), rather they're handled by hardware (although KVM does send
> a self-IPI).
What about below version?

"
Bail out the local retry
- for pending signal, so that vcpu_run() --> xfer_to_guest_mode_handle_work()
  --> kvm_handle_signal_exit() can exit to userspace for signal handling.
- for pending interrupts, so that tdx_vcpu_enter_exit() --> tdh_vp_enter() will
  be re-executed for interrupt injection through posted interrupt.
- for pending nmi or KVM_REQ_NMI, so that vcpu_enter_guest() will be
  re-executed to process and pend NMI to the TDX module. KVM always regards NMI
  as allowed and the TDX module will inject it when NMI is allowed in the TD.
"

> > +		 */
> > +		if (signal_pending(current) || pi_has_pending_interrupt(vcpu) ||
> > +		    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending)
> 
> This needs to check that the IRQ/NMI is actually allowed.  I guess it doesn't
> matter for IRQs, but it does matter for NMIs.  Why not use kvm_vcpu_has_events()?
Yes. However, vt_nmi_allowed() is always true for TDs.
For interrupt, tdx_interrupt_allowed() is always true unless the exit reason is
EXIT_REASON_HLT. For the EPT violation handler, the exit reason should not be
EXIT_REASON_HLT.

> Ah, it's a local function.  At a glance, I don't see any harm in exposing that
> to TDX.
Besides that kvm_vcpu_has_events() is a local function, the consideration to
check "pi_has_pending_interrupt() || kvm_test_request(KVM_REQ_NMI, vcpu) ||
vcpu->arch.nmi_pending" instead that
(1) the two are effectively equivalent for TDs (as nested is not supported yet)
(2) kvm_vcpu_has_events() may lead to unnecessary breaks due to exception
    pending. However, vt_inject_exception() is NULL for TDs.

> > +			break;
> > +
> > +		cond_resched();
> > +	}
> 
> Nit, IMO this reads better as:
> 
> 	do {
> 		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
> 	} while (ret == RET_PF_RETY && local_retry &&
> 		 !kvm_vcpu_has_events(vcpu) && !signal_pending(current));
>
Hmm, the previous way can save one "cond_resched()" for the common cases, i.e.,
when ret != RET_PF_RETRY or when gpa is shared .

> > +	return ret;
> >  }
> >  
> >  int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> > -- 
> > 2.43.2
> > 

