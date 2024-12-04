Return-Path: <kvm+bounces-32975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 885F79E30BE
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 02:25:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19F56283ADC
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 01:25:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09677BE4A;
	Wed,  4 Dec 2024 01:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TDU9xtYH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232C421345;
	Wed,  4 Dec 2024 01:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733275530; cv=fail; b=iiOhyN0o+Ya8XrcAzzViHFRR6wNwfvX3dy5QFi4zRPXmOkAHSERyvZAdqmYNu6e6WgwzQjYhpYfan02Va6ft/f/rM0D9Y/+oZM8HiM4D7JYs7xwU9jhH+5FuKokQ/RHhUPbSmX2BMqlV18OpsDawmEScbwVWpZV8oLUpSA1Uy50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733275530; c=relaxed/simple;
	bh=5QuH5b3IbnMe7CheioFzoL6nobYPO5AiJsUnzneXcg0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pLWTGrXTL2drXqCrOqdXIxvhdGFSaTjaW+DncBGPLMm0Qk8MQoCxlNe42hVIRAKTiOF7iad/hnYxqXYZty0A2V5I1NvsJGlIwlDnJ4kkYanC61mDrOwJXLMST9nd284ZmREAeJZde1Joq+huL3f5ejg8jjcz/AznA86ItWAWbzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TDU9xtYH; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733275528; x=1764811528;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5QuH5b3IbnMe7CheioFzoL6nobYPO5AiJsUnzneXcg0=;
  b=TDU9xtYHqmNem6naeOnZ2sdHqYAh8/VkbjY3KJgIvZyYamEVb1ILCxb2
   gvm6LNBIRza5FepqeYlNKK9DQhL3K5oleuTqz0+VlbbbzrTo8e901f7YB
   wYDzmeATv3OsRVeHo6hjzE2oSNyLwLUKYCJDMfYOA0brdqs4LYz8nC01+
   hYxwQZEBFddHr5wUmHTSgivfNiTvURWpjBPkIr79T6dLSJsCpyqjaU9H1
   AwlvUzQWNeXe366Ln+2kvdZ40ejtkHCxfO9P53d0nsc5ut30Jao/j+InU
   zbpDRFCj/8b6BEjAc0s0dcHfTN2N5rF26HZ/bqfhYiUY1vVLzngAOuNWJ
   g==;
X-CSE-ConnectionGUID: mgH6VlH8QiO50I0BLxfsDQ==
X-CSE-MsgGUID: qp5rAEFgQVGZo/AOV88jkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="21103263"
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="21103263"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 17:25:25 -0800
X-CSE-ConnectionGUID: ul/Tf9WCQnCQX4z+4g5GIg==
X-CSE-MsgGUID: BfxHvE8aTIe9l7drPWUkBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="93800734"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Dec 2024 17:25:25 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Dec 2024 17:25:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Dec 2024 17:25:24 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Dec 2024 17:25:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=stPNtUn6yDJ+LMIbLXcTQcpe7BBINcDJYwORQkl8lM9rJr/a2cwPW9blW4wf3y/TvXVJRsfXCX0VZR3+z/ZfBXJTFwnHtgq2hkYGu51gqMTUkY+4ftfDplFhlVRVrqlV2klDmqnfrnQ/SqyQnhYYob+2lxTp6+RCnRhcgTTFAYBLa90myTPE8KVJ5zk0256WSPciepQE/6Z5gRmmRdlDaULLcFRKnFj73YFDl1hCTAP9qUAkEt9LxDbso6ihB4UA996ois7pYS7tHQFrstM+4BqoPtZK04r3m5ku4lETfVUVTRgGWB7Bu8pNvFP5pTas/chfdW7vBIsUglOWUZYDsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PjWUcqcop7JVZIIZseUArp7FeqfZehTBjp0gteJAuqU=;
 b=ySCyIAc2SbEPYV+CM+BBW57o4Rua5p7whgHMyI0dJSlJN4GjT/L2ZdOGld/z1tIBmMvNKDAZDdlPMdHeqrGrDi8vwVPtoDfJcYLtSpkzOoZ57ne7n6fc3kgVBoA8ng5KHl+LVcwEjDPziz0u5PuVJ3mA4TZx0KbMGxPO7/RfBF7Htsh4mNybfgx0HoRXCNTpR6mVkZdnPzxvHSmhn/sfFh31KbcaA8wK5OVqe2B7Ofcm5qbvgMZEGzzLv8yeRTAVk1JaHw6PNoSV4r2l3KYmcbt75oMn3AgsP0G18VVNzDJ7NM8Xc1zJiCFNhObDygWO45hBYrwMgtWXeWJVSx3XjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB7146.namprd11.prod.outlook.com (2603:10b6:510:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Wed, 4 Dec
 2024 01:25:21 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%2]) with mapi id 15.20.8207.017; Wed, 4 Dec 2024
 01:25:21 +0000
Date: Wed, 4 Dec 2024 09:25:09 +0800
From: Chao Gao <chao.gao@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yang, Weijiang" <weijiang.yang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Message-ID: <Z0+vdVRptHNX5LPo@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-8-adrian.hunter@intel.com>
 <Zz/6NBmZIcRUFvLQ@intel.com>
 <Z0cmEd5ehnYT8uc-@google.com>
 <b36dd125-ad80-4572-8258-7eea3a899bf9@intel.com>
 <Z04Ffd7Lqxr4Wwua@google.com>
 <c98556099074f52af1c81ec1e82f89bec92cb7cd.camel@intel.com>
 <Z05SK2OxASuznmPq@google.com>
 <60e2ed472e03834c13a48e774dc9f006eda92bf5.camel@intel.com>
 <9beb9e92-b98c-42a2-a2d3-35c5b681ad03@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9beb9e92-b98c-42a2-a2d3-35c5b681ad03@intel.com>
X-ClientProxiedBy: SI2PR06CA0008.apcprd06.prod.outlook.com
 (2603:1096:4:186::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB7146:EE_
X-MS-Office365-Filtering-Correlation-Id: 83ce9460-01e0-470b-f7d6-08dd1402855c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?402pqhQgq6eiKMZwJMKDb6wwWOqKHs83ObfswpA1gOZLKUNTvDScr8//WW7a?=
 =?us-ascii?Q?QpVAptbyKZgj6/0yIRxB3CKjcdejJZwDKXiwQ/Xh4usz8vEFbW0Lv7ojZh7g?=
 =?us-ascii?Q?RTEQ8f3wkORDpuPZXWg+VqAQMTusud8xSVQfS5eVDRFeelU96tEtj0kYl2cn?=
 =?us-ascii?Q?OFWpPSanjSd5PrvxFGrHZxmRHWWE2OJG7VpuIcvsecReuETCuCTI1idnR8a+?=
 =?us-ascii?Q?hQOtRGxMmTRdaQJwWDiIoxJXFJZg20fS5w46yQCZwlDian9s6MnEjgeEatrF?=
 =?us-ascii?Q?LXRDramuTEcbOWkhee88/a2hv7I+un4VxkAg9OsQoZhcWvX+odxnB/Gd9Bsj?=
 =?us-ascii?Q?YXhfju3LtwC5dnO0d0dUMFma+A2h/F+XvJeaLz0Hm/JrONG/h547nyYDS+Ns?=
 =?us-ascii?Q?86dPCfnFlPQLv54lnS+onIpPeRERZ0yJoLUeTxtm0jFVUXTJg924TMsuu/Rh?=
 =?us-ascii?Q?KI7qX0EKT8Ri8ONHsmJnpz0MtBEcsNh1dJ7oeoswiWMic/iEZUM81LWeamJc?=
 =?us-ascii?Q?2/CsNoYk4HVcFX5kRCkjhLf5zs+r4otet3coEG1o2+MJyvmdv5GYl79WDP2z?=
 =?us-ascii?Q?SxDOy5SOcX47cglINb8/c7GIqKGicSInKx9xJG6uh1qHU8pP3kf3/eTpYFRb?=
 =?us-ascii?Q?cYAWfzasBUvGWYIOCx+iuqvpes7f2lPoVIXDL3D4mbRSh95cMaT7LCuhKiG1?=
 =?us-ascii?Q?ZoP7fm1vqslxEYKEix3Y/1BY7ace8IOMU6GB2/P09dCtnosb5PdBMl0mMQr+?=
 =?us-ascii?Q?xbL2j5Pf+2/QiIGjgp/SkrnZStWJlqqshaZ+ZA8bkfWg8svULMm421eCNMaG?=
 =?us-ascii?Q?mRYRb5w0n5vpBzLoohVWnckI8lh6Nq6fF6Q/1Riq3aXME7akptqGR3G2bCJi?=
 =?us-ascii?Q?/recXBEih8Eb6ajxNMmnKeCAYvxfxvpRvLn+/H0JZjLpMQinGBFFwBOuY+2X?=
 =?us-ascii?Q?IFG6vihaoMxoKUWdLoYg8/F3yY2galjueM8/2xSS5POEIqlHD+ObNfMD6jld?=
 =?us-ascii?Q?Tl90kcUq4UFQnKBe3QEBBGIKxuYyf/08+H4woKTcEG4NCiAaFO0JnI3DcSYS?=
 =?us-ascii?Q?syQx5rk6QJJC2JIwUYCL+xVuxGbPZmYzsfLJf35Gwzd/FzX4vTyaDVV2/VjH?=
 =?us-ascii?Q?/rRtju42X0C+LTytDNeIRJblpLSL71CKYvcmZxwaP4Ver600cHfGcw114Rmt?=
 =?us-ascii?Q?Hiu4QVjUpTzRlb9y+p5R4GHv+X+e7qTRFWG/k8VKKu6XW1iS7sJipfNLwLlE?=
 =?us-ascii?Q?3b/QRxhFECXnbE5YZr5GPTs5TldD5Cfmse5rHjGk7i6/mFjQWmOV5r5keggz?=
 =?us-ascii?Q?RbAhFAx43+fXfQB1jk/rrqAsJ8enD2MzTaZcUQpfafFEpw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+uA1FOVVZW3mAIK2NteZKCwNa//I9ghE1HDZREnmYSUDpyR4F56PBy/KSgdr?=
 =?us-ascii?Q?zR+EIgZW9jNewSSN8gRpxG1fI1AGtDjfmVm5qf6hb5YV7f/77/owNrI+Gvf/?=
 =?us-ascii?Q?agBVmz41YQzFYirtatKttR6CRVfHe8mNuOu/jQD7JmgFkTpOIJhwFftL+xiF?=
 =?us-ascii?Q?hfFWkLpT+uzVZSXbERW6p/LgTzfrXtUB9YLYbShHMw+BiB3QbzVxxlZ52IWM?=
 =?us-ascii?Q?MocX2t9LjnlAQWAYljeXfeZXpr2fWMAAxHAT2slqQSE9bKHaS8drjg1sTAOK?=
 =?us-ascii?Q?jzYkrv3JLJUxQZgMpOi3uitILZdQxvSP+ISlsG9Qwx2/P9M91VjT9gbLjPqg?=
 =?us-ascii?Q?QJBhr7P3BoBQTlHkYRMElTjQDEa38dmL2D7mVuNnjEGRmqXkeoSG6eccWoAW?=
 =?us-ascii?Q?eTXZPa//TXxYXDfieYB2vf9iWKryHbo7U8AAWeb+kdq4bsTp/N6eqHptkysn?=
 =?us-ascii?Q?TdqGMl8zHxP/ZwVDPjPRZr6g0Clm98DgZTF8OmQ/Ka7yK1jv/kFgHDp1YhVY?=
 =?us-ascii?Q?aAcct1HPLK9SxSO+ynJRlssd3Rn/i97WN1pH8AwK6xqU2APwK2CkZ6DJFo5m?=
 =?us-ascii?Q?uk7eggGmwyr5twdTJ0qQt+qEs16EVKs4QHW1nmMKFZukaC57s32fyzeIBkVC?=
 =?us-ascii?Q?pBa06r5Frck9yGJY30kO6H9Kyyz3cJ1oY5ea5KBNZUV1LAodXmgacCOw7BWk?=
 =?us-ascii?Q?oorW0Xfw1jdY3BNuINhs0La2i6Szc60nFZL3tDTbSFGhScyxusRAMUX8SF56?=
 =?us-ascii?Q?9qfbZTRouYgwOOjUP3lVkgOtK7DoqXtQih/81sccqUKRW5UvELauUqGlX2z8?=
 =?us-ascii?Q?uBXAVcM2V6oN8gMT9BDnfkzCi9H6yVdZN4hZkqxEmcu7c4qyHV0F4QGrL6pV?=
 =?us-ascii?Q?jtsJSFwKEF+rNSwORRp9WMqMvd1/3MRxWJxFT2u4uTRyR/JBsvG7eC3aCod8?=
 =?us-ascii?Q?nZGMeSXpBlLk/ScvlLRprUqKkWQHtwutukpshQ8hcnBNBSgC3j/DlDdxAJSY?=
 =?us-ascii?Q?NrjF8eIiubLYpv9ettRrJnJexiNXHmvEFTDwjebVnPDKeFRRSsNP+Mn2nS04?=
 =?us-ascii?Q?u55pPoJ3yDINLHNBuAWPGb/1Hif2uxFUaOoWZZo0RPq5qVMoUnZo+jJX+rxm?=
 =?us-ascii?Q?k+uyqhn033B0si/uKf2PIWAJXhwsvh2VLoBRHaMHs57NWuHdy2KK8gSF+xys?=
 =?us-ascii?Q?DILzIFe/Lha/s1OczeVNgVmxXGR/n6oM0/iuf33IehKgnUPLjj+PEIrCiUgh?=
 =?us-ascii?Q?8FnzauVflc03QpzOl3NJNsLs6YKQfMZMZrRQ/UoDJhb1b1dE2anuyKtVamF/?=
 =?us-ascii?Q?igmwYlxQZKmOjcuYO45NCyw/M3mrT9+OwtP6BAHthy2HHvTbgOOoegnr/WqQ?=
 =?us-ascii?Q?XQgVJZOsLXAqDjSCBgVrnzM//xOHym3dQqTiM3ofjJypVKPo94ab3ENrUx7n?=
 =?us-ascii?Q?KpUZ44pE5Ox56bm8W6RgwbCL1NxSe6JIuauvqI1c/Vlnai0oTq7Qd9nwxyGw?=
 =?us-ascii?Q?uxr5+4lAXHHAe2vzX8n5yhav3L+q1n6O+3OIPWzD+XQDT/wdaI4OeppOiJtV?=
 =?us-ascii?Q?ibvAEloGKt0WVzzEQsXP7Y9od3Q5/Ecz7VQHB0Vq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ce9460-01e0-470b-f7d6-08dd1402855c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 01:25:21.8158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /26dshSxyNGz7hyA+QISxTYp/wB3mEewWM2lL4LH+oLRz+HhxmKHYqx9jIKD6mJfrzPyrXRup1O6qDPOtH4pKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7146
X-OriginatorOrg: intel.com

>+#define TDX_FEATURE_TSX (__feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM))
>+
>+static bool has_tsx(const struct kvm_cpuid_entry2 *entry)
>+{
>+	return entry->function == 7 && entry->index == 0 &&
>+	       (entry->ebx & TDX_FEATURE_TSX);
>+}
>+
>+static void clear_tsx(struct kvm_cpuid_entry2 *entry)
>+{
>+	entry->ebx &= ~TDX_FEATURE_TSX;
>+}
>+
>+static bool has_waitpkg(const struct kvm_cpuid_entry2 *entry)
>+{
>+	return entry->function == 7 && entry->index == 0 &&
>+	       (entry->ecx & __feature_bit(X86_FEATURE_WAITPKG));
>+}
>+
>+static void clear_waitpkg(struct kvm_cpuid_entry2 *entry)
>+{
>+	entry->ecx &= ~__feature_bit(X86_FEATURE_WAITPKG);
>+}
>+
>+static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
>+{
>+	if (has_tsx(entry))
>+		clear_tsx(entry);
>+
>+	if (has_waitpkg(entry))
>+		clear_waitpkg(entry);
>+}
>+
>+static bool tdx_unsupported_cpuid(const struct kvm_cpuid_entry2 *entry)
>+{
>+	return has_tsx(entry) || has_waitpkg(entry);
>+}

No need to check TSX/WAITPKG explicitly because setup_tdparams_cpuids() already
ensures that unconfigurable bits are not set by userspace.

>+
> #define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
> 
> static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char idx)
>@@ -124,6 +162,8 @@ static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char i
> 	/* Work around missing support on old TDX modules */
> 	if (entry->function == 0x80000008)
> 		entry->eax = tdx_set_guest_phys_addr_bits(entry->eax, 0xff);
>+
>+	tdx_clear_unsupported_cpuid(entry);
> }
> 
> static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
>@@ -1235,6 +1275,9 @@ static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
> 		if (!entry)
> 			continue;
> 
>+		if (tdx_unsupported_cpuid(entry))
>+			return -EINVAL;
>+
> 		copy_cnt++;
> 
> 		value = &td_params->cpuid_values[i];
>-- 
>2.43.0
>

