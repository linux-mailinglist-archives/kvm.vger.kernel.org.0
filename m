Return-Path: <kvm+bounces-40471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 51F55A577B5
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 03:49:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97B6A18999A1
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 02:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1713914A0B7;
	Sat,  8 Mar 2025 02:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H7+zwk6X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C718B323D;
	Sat,  8 Mar 2025 02:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741402162; cv=fail; b=l6smJs4jRUPFsm7WHJkQXXvYlpgik5wifEBlVOrIdrg9DPGLw3RWk95nl1xnqOlEHsXd06tB2Yt2Tg6z/YfwtrN17BcvZeyWjU8/qfaQZZlKUa6/c+y6bcdhBrB+ISE31kTwpktJSfdLzwC1Plk3A5R4S+4+NohtqVB2m3CZgFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741402162; c=relaxed/simple;
	bh=z+bngZCYdWwP7k6Z220tzkxmPV9vsGYaQyn8nQ+nwgE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MTTfasOUOqMxwJCd70et3Q55Mp1/REGJT3YDR9vvY3ZIFGx7hQo/pucpXepuWMks8D7gQYNSqnA4KlOps+fmPTOjBWOaK391m3X3uDxwwYyvIHHJ9soU5CXhb+BtoAOmomIPyG041W7+U9jlSjcMWqNOf1I7kkAyx9Q7ohrgJFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H7+zwk6X; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741402161; x=1772938161;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=z+bngZCYdWwP7k6Z220tzkxmPV9vsGYaQyn8nQ+nwgE=;
  b=H7+zwk6X+XDXodG9Dbp1GxFn1locTJAqYrrf613P7PWpLEmiFfqddALO
   6d6QIOsJehTcaAC+IK94pdyahdNj9V950qdZ2LJwx0QR4RJ73ZlY/ThdC
   CHi4Tz3Ci9OAeEe4HGsmJJfYz/lRRE/vW0xP1d9TAtKO4VTrVbAiaEB70
   Eeu1Yb2ne/rjsGmwCVi6jPg1sEnlWWA0E2m9JI9oZrP1sHVnZ5bjCHBt2
   MiKP/qdxI9w0LLJzn7HjbMrQ/BfIhcoWucvXNQi7o7keTnm8YFwng9cjU
   r/gRb01/PwWPGRQOu0XU7bX3D97/y5VYmp3zmWmxWCgm0UUpi1TMkSsj4
   A==;
X-CSE-ConnectionGUID: yY4O2hAoTSapGEvlnSx0nQ==
X-CSE-MsgGUID: wvx7j4zyToKbfUp8ZdjHEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11366"; a="42340935"
X-IronPort-AV: E=Sophos;i="6.14,231,1736841600"; 
   d="scan'208";a="42340935"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 18:49:20 -0800
X-CSE-ConnectionGUID: lScy010sTjGiedxANiOdww==
X-CSE-MsgGUID: kMS9/S7NQlO+TrzjUfIKrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,231,1736841600"; 
   d="scan'208";a="142712983"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2025 18:49:19 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 7 Mar 2025 18:49:18 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 7 Mar 2025 18:49:18 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 7 Mar 2025 18:49:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vaG8v08fhWWBqjziwwK6AHHfqYv1yJtGm5hjcy+iLMHHKJaoFUt3iX2+byKMCwQKmEseulUFA/gHZhbnytXYlAJhOHUXcmQbOmanEykaheQQCZ/Q//O+sdfjp31xO6qNr6O8tjlW66jUdZLvj1bfF2A45WdY7m9vCRFGlXkLStDe08/P41wxmk6J75yWhNytEOFSmjP64IaMkSnqu7Nvjh2kfGbrd4iwBdxJiRr4dxgtRKzcEJ+w5CRyHCuSHjX1affhQtyeiFdZBOuWteg9/Ek4d/13ocHfDuHNH1mvoxVEF5tIoK9no4FTz8pWI9O2cFDpYkRhLD7ZmlszMaIHOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PKAWGWRmpccob6eLlPXIfEADfTCj7E3RSr3GlO7l2mo=;
 b=xv4ewT40gQmhd1UZDT3EnHhjQHLN/eAsY4HtE7QYdYs5JWLSYIsHFR1BFVxhQF/4wn9Gl7IHKawDpi3yK9q+e+8ObobF9fyRFvpkoDpmOr1KVPndNzAULx349vSV7GCixjOLH4z+zapzFbjN90BLFUGkScTbjx4ww0OaILg05roKilQKD26/tfWZk6/AqBULhpq+HNkU63H4QgnWzhwcCGFey06FnCqnPxFJJN7j4/DqcdkzXcu9J6swWRTiuV7skLMxGslviPGKbDtKgZ3rETbvDoulYy8ZKtPJ55F5+s0KS5EteJ+YqAKgfAX91a5vlnAZC7cDwf436yo0rpO/Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MN0PR11MB6280.namprd11.prod.outlook.com (2603:10b6:208:3c0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.18; Sat, 8 Mar
 2025 02:49:14 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.017; Sat, 8 Mar 2025
 02:49:14 +0000
Date: Sat, 8 Mar 2025 10:49:05 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
Subject: Re: [PATCH v3 04/10] x86/fpu/xstate: Correct guest fpstate size
 calculation
Message-ID: <Z8uwIVACkXBlMWPt@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-5-chao.gao@intel.com>
 <b34c842a-142f-4ef7-97d4-2144f50f74cf@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b34c842a-142f-4ef7-97d4-2144f50f74cf@intel.com>
X-ClientProxiedBy: SG2PR06CA0205.apcprd06.prod.outlook.com
 (2603:1096:4:68::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MN0PR11MB6280:EE_
X-MS-Office365-Filtering-Correlation-Id: fb5085ee-4db7-4c4a-0e62-08dd5debd00b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ahAflwNa1VchopmssoLgpAoJOGGJQWl1d9RFfZnOGHmKD5EqH524bvduWNw+?=
 =?us-ascii?Q?iYEs/mjjFRVCSHj1K+P/mpOM4MM2RKbBkAJNSiPlEQpA7TE1K6BEJlxWdxUG?=
 =?us-ascii?Q?hyCSjWpZTQEKDjNitGy86qvJM4DCqadCuVsZbuElL/08kqxvw7sEkUwik4Zt?=
 =?us-ascii?Q?R64IhanKCl1aWN0olweUl2XukCsl3z3SjFfYaaHsG7IjbA7JGUZchHBudI6K?=
 =?us-ascii?Q?AVKIaxQUk8H3wswn8eneDTNUn++XJ9C2NXMuOyHF8fYAiq14oxtk5iUqgDUp?=
 =?us-ascii?Q?HqBu2S53r0YqH9EpFFHl3foyrugA6OKx/I1vmrFUPQN6bBNllK276EgVvf2h?=
 =?us-ascii?Q?HqoFDDkTAGS/O43bArWISju51jHkNnW3Eg6IwW8c9z+C9+11020QGPjmf3nS?=
 =?us-ascii?Q?w0VxRf6qtdRmXb1pTufayN+alxYfVeVujtp+kh1raMFVa/ej8InKCXI3bdmG?=
 =?us-ascii?Q?Ywwp4Njx0f6loqfjw5FwQxIbp0bIlvYbK2Jxdr2+j7NXyUkhOZF+kwqANqPd?=
 =?us-ascii?Q?2SwF2q8OzIEr3j7wHDHA/KLLr/ljJ2cdNTsoSHst5bcqnt6hquOYRyJAsmBc?=
 =?us-ascii?Q?b7T6DekPWVyUOIwJ6CBVdy+1SmXCLeYXlegAS7O3eiZKYgecmLTUhC5CzLW1?=
 =?us-ascii?Q?ZHJHvjshxN6vcfvZ5XwcJtIlghAlqYZsuOV6g7IBZTK7wJY2f4AKtjgXO3WQ?=
 =?us-ascii?Q?ZaTSD7cj0m8rZ1RbLQSOeMX65RT711GxR0kV5/6byFtVa9+7ofxMj8hY6ZAq?=
 =?us-ascii?Q?XWGWOuBJ9xCQf9sWCRxkEJ8dVkDZh7Fx8NRJc89t92e3knonFHiR7aCYTNEs?=
 =?us-ascii?Q?05jXPOWje7xDprnB9WovPZN/9pHTc8F5QEznjARJ6Gzc7oQ4/mQVyCm2KIcX?=
 =?us-ascii?Q?spPiuk5nZWMgLNnpOVNbHdobUUySUaL06fcoWnHjThKv7uemFkto+DMHyM7l?=
 =?us-ascii?Q?0gltctFt75GkkUCTA4V7PvpEt6aUFwNyeUMNCCl+gsNZdfW/rSqTZagsXjMX?=
 =?us-ascii?Q?cy8ndAuGLd3fWN3U0DMWMR9qSNw2f1yjcCQuZxBYhFrjptmlO83DHONnxlDD?=
 =?us-ascii?Q?+ZI6mPULl4DI+kaoMUtaTWZzHFt4Nhv6rnDm+VVOBkQDcmBGRPRVQeVvBpa0?=
 =?us-ascii?Q?tnacdAsIUXJemWmwz1pJgWgLgDIkc1XvgUFFw30Pr6CPQ/JzrhIfVL7ITfXU?=
 =?us-ascii?Q?9QAJSr9lL8ePXUYo42i74AFH13SQlqBFxd4zFxOa88fwOo/v2tnmnOb5ClF0?=
 =?us-ascii?Q?GybarLJ6C6m8IquWq38T2lhng8+6bP6uc22xaK9XGNsPp5ksX7Ilp+i0MKzN?=
 =?us-ascii?Q?EndE9JhccAa19orElDOxDrVfeyokTvHsB0FDjXURQ2kvSeuAdk6h3645nikt?=
 =?us-ascii?Q?oYlYBhynuygFvn2BxAQSyhUI7dgm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dFSixF+P8pFHA+7B4l/5bQOHVH7/PkQJ/EoZlN3YGGd8E67iskGQ96tjRFqA?=
 =?us-ascii?Q?Y9L8GSNAojANxdOCFWPLgIT0CZgqd/6a5LGCUkV1TzVS5XNSjMyWEYHnVXSG?=
 =?us-ascii?Q?ymOn4BeDpRS/Y5zlR7bGfB1Pbd98CQYrQ05xiAksqS3rHrdNpfkjcgg1a6w1?=
 =?us-ascii?Q?BL6qjcg4tV6Jm3jlnkp9avdvMc7p4aVC1SxPZpMQ3WmXgAs199/lVwSF67m4?=
 =?us-ascii?Q?g1w6diPg9e4Frodlv3lHEx+P+5/soP52MkCCGLtE/4D7rnWmkcS+qI/HZCzh?=
 =?us-ascii?Q?lsTIqbfcj3YB33joUawBmc4lMUZvvPBFw+8pJ/7d3nnEqPwo0FByPfhI4SkW?=
 =?us-ascii?Q?bed+Y0mwR56Q0QXIbMwRRERBSojByTsMAL/6wZB/jz3Lk9Kga+qg7HEVSUkd?=
 =?us-ascii?Q?DVucaVOANFuSMu/ydUaVgQRC8XQHpuavGOEdSFr0Y/KRc8PYgEIeZhce0LXD?=
 =?us-ascii?Q?mWJ8Orm35d88/q3MnIrqM6BMDvVOdrZB1THLSn404OC5ODKiFdnVJHgrSfRw?=
 =?us-ascii?Q?CbAFwbfZJc1r2Sxg0fVFdhV5Bq1aWFFxli1qHEmsropmHXh5VfH9ZkmbPgCW?=
 =?us-ascii?Q?lBqmNKXFO27rMrkmz4yhNHuqEXP9XmaRFClmIg/yk2pujaeoOTbpWct1MQ1Z?=
 =?us-ascii?Q?5WaQ0j39ygsJeDOn3QuNv9AC+JFnyY+MxUVZfL7t3X302GkQiv2pNmMM8xhs?=
 =?us-ascii?Q?VnxNfeTX//tf+Z/TOsyBQbAwrkgZxbaisdK85Prg/yXP9eUAPWTNjbWYXiLP?=
 =?us-ascii?Q?s9Yxc9P1HbzrG4WaZMsmk9luVHY5/Je9KvXN47xbTD8ppq9Tf0k8v11x0gxB?=
 =?us-ascii?Q?iaIMfGD8Xp0ugwOTFrb6eIwruk+9CM0zSm+EEv/PpJ7t5KxtjvDy07lQ3GT2?=
 =?us-ascii?Q?ojspFP19PQNo671f6XlvjhPbdQ57O+I9Iovm/sLzYWk/6MSaQurnuv+yHeLg?=
 =?us-ascii?Q?HLwJ4FO9OvxjPSXdWkLL5/RxkkN8biCWYkS+vPOXxQYaLp+8FSRh3/fveMju?=
 =?us-ascii?Q?qazwG2d6z+5KsyviPuYGtZXNDrUCFsTtPuoCqh/IS5F9VaeViR6r3pnx3VBU?=
 =?us-ascii?Q?kS85xBEVNe5gZ2gsPo7MkvjMaSSeqQ+fFE0tPfZzVNqXCsCFUKvNjNv9288K?=
 =?us-ascii?Q?wTNWLUJXPs6Na+EHhQmo/lNfIjkWBZCBZEtGTmfFDgdL8C/7itQxlP10ap1P?=
 =?us-ascii?Q?p7UyErhRtthr2Y/XgaGAfWS2KX2IRN+8F1mDJiQ+adzDh3hQxeT8XLX0tB5h?=
 =?us-ascii?Q?ch5/l2Mn6mBOZmuIofZt4k/PAd3V6J8+heQFvybdKrOiqm90NSMTM3fyQ6AB?=
 =?us-ascii?Q?7qxvyXqM1I2b5LskCMjAqSvODGDM6SnNBJI910rFCaPB8mz1CHBjJ2FiRTBI?=
 =?us-ascii?Q?jt2QtzrP8BeE2I4SxUxHBzFjJVL7615m0BlvDUzy/HGAemR1fLHeu4qZcOKR?=
 =?us-ascii?Q?G+B817yv6JtBONJ7S6KFaIEXu6WM6cbSRAf79qoE1AqAKEFU4IY7PtqY/1K3?=
 =?us-ascii?Q?ofm9X8VnjZONpZnxLOKHdP4gwKj/21qRibPkemIRvHdPec4EeHUBnhfRrNQj?=
 =?us-ascii?Q?ukZ8cxK9ugTEpWICKdM2JFaJ3xAImY+gIVVRlo44?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb5085ee-4db7-4c4a-0e62-08dd5debd00b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2025 02:49:14.6811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p/KYoD8qDALfx56xQsBhjHLiTh2DTKrwwmG2GP3eljS5wL1pR/9LOdcXy2uHqz9vQ8l+2bTaTgWfBaM82PT7BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6280
X-OriginatorOrg: intel.com

On Fri, Mar 07, 2025 at 01:37:15PM -0800, Chang S. Bae wrote:
>On 3/7/2025 8:41 AM, Chao Gao wrote:
>> 
>> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
>> index 6166a928d3f5..adc34914634e 100644
>> --- a/arch/x86/kernel/fpu/core.c
>> +++ b/arch/x86/kernel/fpu/core.c
>> @@ -218,7 +218,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>>   	struct fpstate *fpstate;
>>   	unsigned int size;
>> -	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
>> +	size = fpu_kernel_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
>>   	fpstate = vzalloc(size);
>>   	if (!fpstate)
>>   		return false;
>
>BTW, did you ever base this series on the tip/master branch? The fix has
>already been merged there:
>
>  1937e18cc3cf ("x86/fpu: Fix guest FPU state buffer allocation size")

Thanks for the information. I will remove this patch.

This series is currently based on 6.14-rc5. I should have used the tip/master
branch as the base and will do so next time.

