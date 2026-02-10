Return-Path: <kvm+bounces-70713-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4O7IA4Dtiml6OwAAu9opvQ
	(envelope-from <kvm+bounces-70713-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 09:34:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6220A11848B
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 09:34:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5AB9A30459F2
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 08:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39F9133D4FD;
	Tue, 10 Feb 2026 08:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W4lWq10P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE9E2DCC08;
	Tue, 10 Feb 2026 08:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770712436; cv=fail; b=ZsNaoGu2HaXa7HXD17tPt3EFij8HGqRaCwSaiJEhHHzG7rQ68dOHTo8SxbSd7tTwKnzDqqCooerYsQccwge6wDQb9c041RYNtsSh4cJgJSSaAZYveSb3PXov5zsdwJkpB69OjmokZ73PyK5wDsi31hog0k17EtqDFKMGziuf5eM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770712436; c=relaxed/simple;
	bh=Tq0IxkrmfZdzPRNUzrkrrStUw2Ag6wx7yjdA9NB15O8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T7wrQUWm579sjsd3ZEEI/64mO5tgMNTOp7LiNs443O9SyZq3IBtJMyFTIkTVudnD/8huqqFDY7QAOE++nHOoEgg/BUJhmn85UhxJOo6JZnft7nzhRbgKRn71P120HOOp9Z4I1lPNaUe0g/6j4mLtb0d/Wo3YXkgahLpBNdb9rBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W4lWq10P; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770712434; x=1802248434;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Tq0IxkrmfZdzPRNUzrkrrStUw2Ag6wx7yjdA9NB15O8=;
  b=W4lWq10P2qjDYE4vAXHLVNDBfIW2uuxvo1q0S57J1BawFP3qJ0rKyyO2
   qpO4KjQhUp0//mJbpvdXuqKJcdzn/3m8sRLF/UquLxLkEGg6DmWpyszLW
   JuApNsKiAbmeWYzlWKuLjJRmp5cLTKpS6hbmF5e32Z6l/CiBzsqLh6+w+
   L4S9uJL63CRORqdkWS0T8YbMpGvIWOoETyutJ4iDXpoZAEa5X8SsekagA
   n/RF09v46qLc2xU0XZdamdfBomj0WGxo178kT46uvsY3nTy8ujUvKaCiF
   tjYTp9fLEFGgiqD7qsTYsgCGGbYpZsqC6ghuaZQjTuYPBEphye9pTHe/f
   g==;
X-CSE-ConnectionGUID: sNJKZuWFSD+pg7UfZ7vkaw==
X-CSE-MsgGUID: P37e76kORZWTlO7SVudPMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="71876687"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71876687"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 00:33:53 -0800
X-CSE-ConnectionGUID: rqYJnT9+RaaoQQd4rA+yIQ==
X-CSE-MsgGUID: W+aYPFACTqSHFhpsblZZyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211687473"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 00:33:53 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 00:33:53 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 00:33:52 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.52) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 00:33:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QUYweN8Dd0D+wJCIh/266org2QQgmkKgedQLYQJpycxcDdsLNZ3A/PrpwQ5har3F/FpwAQsII1OHl/D+hL5WmCtrHYd/w+SVYPveoPav4DvfcjqmP4FO8gwg8P9OUkjMCil44cg79/hVlcKO9uvVTZVHy6qRVFjAfMxFI3Bk++5NOyVwbtalrUz2gkEKFNxb7YVojvCql9ymf0+U5jR+GLEc7CViXX8tMdkkEuFOAO988Y3gMacRmnAeQ+nk+HzX2Ddhwca2yD79+BrhxjqdfaNQm4R4iuvFVfZwQLYRv/mP4bOSQtV2YSIM/HYkn7j5osbymic9j3TFeLMt4QBXpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIbv91FBJXufEb/ZcvsF4+QhpbYbwQO9Y7uFKwqJ/i8=;
 b=wtb+4rUk3daGNTl1QkpSoNQRlAWpW7m1QnZ1nwOQMSRJ+7TY8bnAaveV0n4AFhVGU+BaaKWr1ZVhrCBBPXOB57eho01z05Q1CW1pJu5aKyw+EVFevtxs7Bj2xesD8rRl+Uzlq3+8kP+gXaJqhWX8d3aALJ2Q0aP5ilxA3oNvZr6IXH5OEAMkTMfTCKKIYKF3bDf8ICOvbI6U22yqBKmwMUHAkFuUOUQC7AWq+4zvwjeVxtVUGxDbRHCfNOXlM4iEW0PSsjFZ2N5S6aSYXxdoZkopTyoj2fZrRH5FrdsfkmoWSHxbTMcJNUPRy3OFamBnk3qQO8rrrKon1V1XxLZkvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7799.namprd11.prod.outlook.com (2603:10b6:930:78::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.19; Tue, 10 Feb 2026 08:33:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Tue, 10 Feb 2026
 08:33:49 +0000
Date: Tue, 10 Feb 2026 16:30:54 +0800
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
Message-ID: <aYrsviTu/ET8N7DH@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-21-seanjc@google.com>
 <aYW5CbUvZrLogsWF@yzhao56-desk.sh.intel.com>
 <aYYCOiMvWfSJR1AL@google.com>
 <aYmoIaFwgR6+hnGp@yzhao56-desk.sh.intel.com>
 <aYprxnSHKHUtk7pt@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYprxnSHKHUtk7pt@google.com>
X-ClientProxiedBy: SG2P153CA0036.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::23)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7799:EE_
X-MS-Office365-Filtering-Correlation-Id: 30a07666-70c5-4e93-d39c-08de687f1d3f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?lRujdViAMwM6XHj/5se2RrPMDMQMs8WFE24WDVH04dQ9kEAMBAV5LzpjBqdZ?=
 =?us-ascii?Q?70hdEQUohnf+fMBPYIFdPvzY9AQrFF1jc81J66c3MlfSXR02vv9oaa5woMP/?=
 =?us-ascii?Q?YeMH/dVnbdb2E2poK5ST10j61Be5+77Xy2i1fs2LpW6T86lLt1LWpeTHFDUM?=
 =?us-ascii?Q?FZSA3r6CnYQcAu9IKm/Kd7enlal+LeITSWciaeV5gNA10vCl7Oj8invPd6U6?=
 =?us-ascii?Q?oehlyUB5DRBtxunyRj20D1qWotyNDPNxveOdT5MG6ezibKSVur/Dxox84aEW?=
 =?us-ascii?Q?cbXUOdMh1kLbz52i633gPGj6xoHi0WV9/vy71p/HcIOxnhTzdcIgkCyxYmKI?=
 =?us-ascii?Q?Hys7WT93NPGuwvg13d9OO9Iiv7Um1zvs8Fbwqzye+Z4s8wBNC/t2lJotL9D4?=
 =?us-ascii?Q?XsUEYK2y43RUsY56b8WVdwunl3qmDLgTrt/Zfoz31u3vCWNdlXHasO31VTrX?=
 =?us-ascii?Q?kNayRcHX8ezKMRgwa3PiEdR8Us/7V4PdM85dDxjdx/wNp2uIl8G4Eo/xTCdd?=
 =?us-ascii?Q?14Nyn/ahEeTAUb2srKCMHHWWS68eu7KPzwIY0vlV03FSkRtJiG7O1XuzhTJQ?=
 =?us-ascii?Q?WOYo023O95edkHgQs71B56bmePyJ/EL8FWZ39PAcLHM8k8knVG0yQmXWzMAo?=
 =?us-ascii?Q?tGD3qDfiYjTtYGJaCBJZgAHFaaxhA7RTSZvlkfWxJ1J06f2vUVLVkPYJAL3H?=
 =?us-ascii?Q?sUg7j0aN2RwvgmxCe0Nvio+QkT8vmtn++KMsbrEOprDV9UTKHF7dkNaIblZd?=
 =?us-ascii?Q?HXHC21biTXUaO2FO5HjpmthrGAiYbnirp2eJEOcNJ9TwcSVQr0jXThEtvZrc?=
 =?us-ascii?Q?JWQRn85yj3JyYOYlLgvvwcrT1PNHlpF/IbT2S3mKINOpWxYih9V5fCTN7yGp?=
 =?us-ascii?Q?pa311nFbckXTTMgcu3SJwA5VmuqGTolnYvwfOMyJovS3FPl93jrmJPj8pQsS?=
 =?us-ascii?Q?VQuh7SrXh8IVD2Sg7IBldfPZfiD+Z8jDmo8UvKRCwIxsGxvRSQjMoxgAWpI5?=
 =?us-ascii?Q?hY/g6tDwoUyKk2tkU+5S1orhcOC8ZH8AeHUUPpW0c6pR/gO48ts6+9Pj4umJ?=
 =?us-ascii?Q?RxHYwmuEWnSe3XhBc3ZjFXCpPftMIx6rLSfeEoUWyf3/hrQGWdPHzbOpszL2?=
 =?us-ascii?Q?OOJ+R0MYv6ZVNQ0b4qDD8d3+JLayoXVQpSXMlwPjVKhlCcsTHK/bq5on0Ys8?=
 =?us-ascii?Q?DmVRVCLT2R/tPkINVr0dpGAGaVU5me6s46bn5mtXIkU+AvHpOcJth8ZiSpQy?=
 =?us-ascii?Q?XTz92dDq/zbgu1NYc3P3EAZbjFZfd105+bqSrk36TlSOGuI2j/g8a/7EcfBh?=
 =?us-ascii?Q?9ufiKVlzgo0XHgMckLv78jgtCvu/ZyDUo4PV9kKPvvjTgS2lkZbQ4mj133L4?=
 =?us-ascii?Q?Ly9A2nbuKEzQq9jwKa0Ao+BGUia+hGa1B9jJdqrVwQrfZl6pIUS1wZDvCYEy?=
 =?us-ascii?Q?0PrfhBWrFWZ2sIB4KXHNP7qClq0JUImS8zToeEHu0BgAE4M9DFB6FyEw9KiR?=
 =?us-ascii?Q?kkRW3LQJdWbQ3HRittkyHfO6VToEUsE/+S56UZRfyA+umpWhjMGmq53sdxAR?=
 =?us-ascii?Q?rJckE601+ULfLYUA9to=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XrCpHj2gpJBvB56jLTA4+uTq1bkac9OvHpbt/GMX0VJwQmjvb5XblCwhMjkc?=
 =?us-ascii?Q?AKQLLozwUkbhIaKqbZ/tKFj/TieVsD8CTu5d1fSg32PgLutgAC2lQRiOjVpm?=
 =?us-ascii?Q?0d+NPOHCjAnApLo8VJllKAgk9nILi2iMdiC7zl4vosqnyX8r3GXhyO/zCNYC?=
 =?us-ascii?Q?M1IlHbtIRDUn8laqyB9tDLKEtAgsCpL/VsXu9zRv/R3F9+X2cqXzmRzzRyiC?=
 =?us-ascii?Q?4dfuoPBCfc26i8UmwDqupU2te+kRXVX6zaspJwmWD6FIMVZ6s5P4+m1k2pWX?=
 =?us-ascii?Q?AmRfK4B1c8OSC42O1xjNRmhwBW/LlrteS5yGo6YKuPeaaiFNmlfewwFRySiT?=
 =?us-ascii?Q?ujkf2nHH0QdqcBs8vwubp/xJNDgk9rOvUuEUo4jcFjTPKoOMcNKxJNiQ98Ac?=
 =?us-ascii?Q?s9BKCuScYMYzC7PfLBBs4aJf3kLnZJFJE9DmGCWhDPfff5wihsnGEur9TBPg?=
 =?us-ascii?Q?YedFsCOsAkB90ZLImFEKbHu0Hir2a6FwNxPb5FYBwc65GRpMJxoJE2NfIcLy?=
 =?us-ascii?Q?rpiZ7NWF8FCawE4AOKjAM0SGiRx6LOG4w3tbAfS5g2aunY9Ah2UTbAvWiJas?=
 =?us-ascii?Q?CnClDL0374y7X707EKDgfJsUyp/b2dsfvYMM01ns7zEaM6Ji3KmREDtUvVuS?=
 =?us-ascii?Q?vMiYb8XOX7dHZWlq0/n0VaLOx3vjnDEo1ioXSPZK0a+8ZtkrRI8IdeCp/py/?=
 =?us-ascii?Q?2+cj/R84BsUvqv01RZyG2t6OPBS0Wv0BMlSDNpK/Mv3+PCs6ejJErCnoKgeO?=
 =?us-ascii?Q?4Oo+QEf2qqIvTQyvdWvHqivH1CMLrA8Ksd3PG1Ec2kE8KX73JrLqsO0Y8XMA?=
 =?us-ascii?Q?plOJgpSqBBpxvmSGg2MtFpoH2krXIu03HIrLfDSHH9cXI00FMI16nK8UuTmB?=
 =?us-ascii?Q?gRkky5Nk/YUU3pSW95o5cKAMamuu9zXhT9EBl1SMgs6kfrSNFY8o6oRoBWxC?=
 =?us-ascii?Q?bgJqIeyiAfVJqfajRCLiSATNAaZaptIbus3jEWsPwCciAttBp0jwGOH8BnsS?=
 =?us-ascii?Q?bnxZbFUbs5LgVWDXb/dqcg4+Db8NHiySV1Qa0cMFHoQES14d84RzW74O0Wnf?=
 =?us-ascii?Q?PGBoBB4O9zh5+xFp/2z/fhokLribs9NYrrShAAYpQxk9ySaeg9I2Pea45j5w?=
 =?us-ascii?Q?tIyvhC85zm/YUGRImB1smtOR8vrLt5k+J2IL+3Jcr24y+tRjXx7miukJz6ZN?=
 =?us-ascii?Q?f4C9c0enJsGh0uAhZX45MK4UYl9u42D3OqL21F/1veOt5gx5cSpomT0yXmoR?=
 =?us-ascii?Q?XK2GjkeqWCRW8br78QYw6WS6FpWCj1pAExD8ecq0sfEX0UEalShYp8FJ4gR2?=
 =?us-ascii?Q?FQaT3Iss2v+6o6mkKOMr2K1DSBZde6tjmtEGuDXfHEB55+/Dxqd+5IU2FU/b?=
 =?us-ascii?Q?OJrwEfqd5fy3fXx1rAQan3aR+qJs8PEBG8vkVlUZfcsVNnf/75v53pvNdEHN?=
 =?us-ascii?Q?a+CathqjGAacdd3mQZFms25YsBhxJl/8G+/5fYUbVzoGuv3VS5SzVx9PRQRZ?=
 =?us-ascii?Q?fjz1GbynuCQSR+bJf3bnpgCjITizGOqGYtnZEmYpK+N8SNMephSNA8mMfHeJ?=
 =?us-ascii?Q?pnmYgMy4pI+TJpabsjz97xGM9MI/i2G5Ytp98q54940xlR3QvoMx4t2DCamx?=
 =?us-ascii?Q?I2KEM9aOkCmZIXT4c2cfAKMtTlWXBe+g0JS+zCMv0HY0Ek4VaHNxXDb3uuxu?=
 =?us-ascii?Q?BGaADiNeVfe5KMmJXza3DZPNHMOk3t/h5UgBknxa9Qa9zf4jB+Hem/S8bhQY?=
 =?us-ascii?Q?v7m1EVo7sw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30a07666-70c5-4e93-d39c-08de687f1d3f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 08:33:49.5721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJnmVzvfHBb0F0H9ZRIAzD0SFau3sXPIMU5UNY8XnxqGT7ZjpgF+//flolaA3b9rvCiGHpsmaT41sIGZda2IMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7799
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70713-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:replyto,intel.com:dkim];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 6220A11848B
X-Rspamd-Action: no action

On Mon, Feb 09, 2026 at 03:20:38PM -0800, Sean Christopherson wrote:
> On Mon, Feb 09, 2026, Yan Zhao wrote:
> > On Fri, Feb 06, 2026 at 07:01:14AM -0800, Sean Christopherson wrote:
> > > @@ -2348,7 +2348,7 @@ void __tdx_pamt_put(u64 pfn)
> > >         if (!atomic_dec_and_test(pamt_refcount))
> > >                 return;
> > >  
> > > -       scoped_guard(spinlock, &pamt_lock) {
> > > +       scoped_guard(raw_spinlock_irqsave, &pamt_lock) {
> > >                 /* Lost race with tdx_pamt_get(). */
> > >                 if (atomic_read(pamt_refcount))
> > >                         return;
> > 
> > This option can get rid of the warning.
> > 
> > However, given the pamt_lock is a global lock, which may be acquired even in the
> > softirq context, not sure if this irq disabled version is good.
> 
> FWIW, the SEAMCALL itself disables IRQs (and everything else), so it's not _that_
> big of a change.  But yeah, waiting on the spinlock with IRQs disabled isn't
> exactly idea.
Right. Though the SEAMCALL itself disables IRQs (which is no more than 18us from
my measurement), the time spent waiting for acquiring the spinlock with IRQs
disabled may scale with the number of contending threads. e.g.
When there're 4 threads trying to acquire the spinlock, the most unlucky thread
needs to wait with IRQs disabled for 3x18us=54us in the worst case.

> > For your reference, I measured some test data by concurrently launching and
> > destroying 4 TDs for 3 rounds:
> > 
> >                                t0 ---------------------
> > scoped_guard(spinlock, &pamt_lock) {       |->T1=t1-t0 |
> >                                t1 ----------           |
> >  ...                                                   |
> >                                t2 ----------           |->T3=t4-t0
> >  tdh_phymem_pamt_add/remove()              |->T2=t3-t2 |
> >                                t3 ----------           |
> >  ...                                                   |
> >                                t4 ---------------------
> > }
> > 
> > (1) for __tdx_pamt_get()
> > 
> >        avg us   min us   max us
> > ------|---------------------------
> >   T1  |   4       0       69
> >   T2  |   4       2       18
> >   T3  |  10       3       83
> > 
> > 
> > (2) for__tdx_pamt_put()
> > 
> >        avg us   min us   max us
> > ------|---------------------------
> >   T1  |   0        0       5
> >   T2  |   2        1      11
> >   T3  |   3        2      15
> > 
> >  
> > > Option #2 would be to immediately free the page in tdx_sept_reclaim_private_sp(),
> > > so that pages that freed via handle_removed_pt() don't defer freeing the S-EPT
> > > page table (which, IIUC, is safe since the TDX-Module forces TLB flushes and exits).
> > > 
> > > I really, really don't like this option (if it even works).
> > I don't like its asymmetry with tdx_sept_link_private_spt().
> > 
> > However, do you think it would be good to have the PAMT pages of the sept pages
> > allocated from (*topup_private_mapping_cache) [1]?
> 
> Hrm, dunno about "good", but it's definitely not terrible.  To get the cache
> management right, it means adding yet another use of kvm_get_running_vcpu(), which
> I really dislike.
> 
> On the other hand, if we combine that with TDX freeing in-use S-EPT page tables,
> unless I'm overly simplifying things, it would avoid having to extend
> kvm_mmu_memory_cache with the page_{get,free}() hook, and would then eliminate
> two kvm_x86_ops hooks, because the alloc/free of _unused_ S-EPT page tables is
> no different than regular page tables.
> 
> As a bonus, we could keep the topup_external_cache() name and just clarify that
> the parameter specifies the number of page table pages, i.e. account for the +1
> for the mapping page in TDX code.
> 
> All in all, I'm kinda leaning in this direction, because as much as I dislike
> kvm_get_running_vcpu(), it does minimize the number of kvm_x86_ops hooks.
> 
> Something like this?  Also pushed to 
> 
>   https://github.com/sean-jc/linux.git x86/tdx_huge_sept_alt
> 
It lacks the following change in tdx_sept_split_private_spte().

@@ -1836,46 +1841,70 @@ static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
        if (!pamt_cache)
                return -EIO;

+       r = tdx_pamt_get(page_to_pfn(external_spt), PG_LEVEL_4K, pamt_cache);
+       if (r)
+               return r;
+
        err = tdh_do_no_vcpus(tdh_mem_range_block, kvm, &kvm_tdx->td, gpa,
                              level, &entry, &level_state);
-       if (TDX_BUG_ON_2(err, TDH_MEM_RANGE_BLOCK, entry, level_state, kvm))
-               return -EIO;
+       if (TDX_BUG_ON_2(err, TDH_MEM_RANGE_BLOCK, entry, level_state, kvm)) {
+               r = -EIO;
+               goto err;
+       }

        tdx_track(kvm);

        err = tdh_do_no_vcpus(tdh_mem_page_demote, kvm, &kvm_tdx->td, gpa,
                              level, spte_to_pfn(old_spte), external_spt,
                              pamt_cache, &entry, &level_state);
-       if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_DEMOTE, entry, level_state, kvm))
-               return -EIO;
+       if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_DEMOTE, entry, level_state, kvm)) {
+               r = -EIO;
+               goto err;
+       }

        return 0;
+err:
+       tdx_pamt_put(page_to_pfn(external_spt), PG_LEVEL_4K);
+       return r;
 }


Otherwise, LGTM except for the nits below.

> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  6 +--
>  arch/x86/include/asm/kvm_host.h    | 15 ++------
>  arch/x86/kvm/mmu/mmu.c             |  3 --
>  arch/x86/kvm/mmu/tdp_mmu.c         | 23 +++++++-----
>  arch/x86/kvm/vmx/tdx.c             | 60 ++++++++++++++++++++----------
>  5 files changed, 61 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 6083fb07cd3b..4b865617a421 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -94,11 +94,9 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
>  KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
>  KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
>  KVM_X86_OP(load_mmu_pgd)
> -KVM_X86_OP_OPTIONAL(alloc_external_sp)
> -KVM_X86_OP_OPTIONAL(free_external_sp)
> -KVM_X86_OP_OPTIONAL_RET0(set_external_spte)
> -KVM_X86_OP_OPTIONAL(reclaim_external_sp)
> +KVM_X86_OP_OPTIONAL(reclaim_external_spt)
>  KVM_X86_OP_OPTIONAL_RET0(topup_external_cache)
> +KVM_X86_OP_OPTIONAL_RET0(set_external_spte)
>  KVM_X86_OP(has_wbinvd_exit)
>  KVM_X86_OP(get_l2_tsc_offset)
>  KVM_X86_OP(get_l2_tsc_multiplier)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index cd3e7dc6ab9b..d3c31eaf18b1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1850,19 +1850,12 @@ struct kvm_x86_ops {
>  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  			     int root_level);
>  
> -	/*
> -	 * Callbacks to allocate and free external page tables, a.k.a. S-EPT,
> -	 * and to propagate changes in mirror page tables to the external page
> -	 * tables.
> -	 */
> -	unsigned long (*alloc_external_sp)(gfp_t gfp);
> -	void (*free_external_sp)(unsigned long addr);
> +	void (*reclaim_external_spt)(struct kvm *kvm, gfn_t gfn,
> +				     struct kvm_mmu_page *sp);
> +	int (*topup_external_cache)(struct kvm *kvm, struct kvm_vcpu *vcpu,
> +				    int min_nr_spts);
>  	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, u64 old_spte,
>  				 u64 new_spte, enum pg_level level);
> -	void (*reclaim_external_sp)(struct kvm *kvm, gfn_t gfn,
> -				    struct kvm_mmu_page *sp);
> -	int (*topup_external_cache)(struct kvm *kvm, struct kvm_vcpu *vcpu, int min);
> -
>  
>  	bool (*has_wbinvd_exit)(void);
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 62bf6bec2df2..f7cf456d9404 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6714,9 +6714,6 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  	if (!vcpu->arch.mmu_shadow_page_cache.init_value)
>  		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
>  
> -	vcpu->arch.mmu_external_spt_cache.page_get = kvm_x86_ops.alloc_external_sp;
> -	vcpu->arch.mmu_external_spt_cache.page_free = kvm_x86_ops.free_external_sp;
> -
>  	vcpu->arch.mmu = &vcpu->arch.root_mmu;
>  	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
>  
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index fef856323821..732548a678d8 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -53,14 +53,18 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  	rcu_barrier();
>  }
>  
> -static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
> +static void __tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>  {
> -	if (sp->external_spt)
> -		kvm_x86_call(free_external_sp)((unsigned long)sp->external_spt);
>  	free_page((unsigned long)sp->spt);
>  	kmem_cache_free(mmu_page_header_cache, sp);
>  }
>  
> +static void tdp_mmu_free_unused_sp(struct kvm_mmu_page *sp)
> +{
> +	free_page((unsigned long)sp->external_spt);
> +	__tdp_mmu_free_sp(sp);
> +}
> +
>  /*
>   * This is called through call_rcu in order to free TDP page table memory
>   * safely with respect to other kernel threads that may be operating on
> @@ -74,7 +78,8 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
>  	struct kvm_mmu_page *sp = container_of(head, struct kvm_mmu_page,
>  					       rcu_head);
>  
> -	tdp_mmu_free_sp(sp);
> +	WARN_ON_ONCE(sp->external_spt);
> +	__tdp_mmu_free_sp(sp);
>  }
>  
>  void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
> @@ -458,7 +463,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>  	}
>  
>  	if (is_mirror_sp(sp))
> -		kvm_x86_call(reclaim_external_sp)(kvm, base_gfn, sp);
> +		kvm_x86_call(reclaim_external_spt)(kvm, base_gfn, sp);
>  
>  	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
> @@ -1266,7 +1271,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  		 * failed, e.g. because a different task modified the SPTE.
>  		 */
>  		if (r) {
> -			tdp_mmu_free_sp(sp);
> +			tdp_mmu_free_unused_sp(sp);
>  			goto retry;
>  		}
>  
> @@ -1461,7 +1466,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  		goto err_spt;
>  
>  	if (is_mirror_sp) {
> -		sp->external_spt = (void *)kvm_x86_call(alloc_external_sp)(GFP_KERNEL_ACCOUNT);
> +		sp->external_spt = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
>  		if (!sp->external_spt)
>  			goto err_external_spt;
>  
> @@ -1472,7 +1477,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  	return sp;
>  
>  err_external_split:
> -	kvm_x86_call(free_external_sp)((unsigned long)sp->external_spt);
> +	free_page((unsigned long)sp->external_spt);
>  err_external_spt:
>  	free_page((unsigned long)sp->spt);
>  err_spt:
> @@ -1594,7 +1599,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>  	 * installs its own sp in place of the last sp we tried to split.
>  	 */
>  	if (sp)
> -		tdp_mmu_free_sp(sp);
> +		tdp_mmu_free_unused_sp(sp);
>  
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index ae7b9beb3249..b0fc17baa1fc 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1701,7 +1701,7 @@ static struct tdx_pamt_cache *tdx_get_pamt_cache(struct kvm *kvm,
>  }
>  
>  static int tdx_topup_external_pamt_cache(struct kvm *kvm,
> -					 struct kvm_vcpu *vcpu, int min)
> +					 struct kvm_vcpu *vcpu, int min_nr_spts)
>  {
>  	struct tdx_pamt_cache *pamt_cache;
>  
> @@ -1712,7 +1712,11 @@ static int tdx_topup_external_pamt_cache(struct kvm *kvm,
>  	if (!pamt_cache)
>  		return -EIO;
>  
> -	return tdx_topup_pamt_cache(pamt_cache, min);
> +	/*
> +	 * Each S-EPT page tables requires a DPAMT pair, plus one more for the
> +	 * memory being mapped into the guest.
> +	 */
> +	return tdx_topup_pamt_cache(pamt_cache, min_nr_spts + 1);
Nit:
S-EPT root page is a control page and it has no corresponding sp->external_spt.

So, do you think it would be good to check the root level?

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ae8b8438ae99..fff05052de27 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1643,16 +1643,23 @@ static struct tdx_pamt_cache *tdx_get_pamt_cache(struct kvm *kvm,
 static int tdx_topup_external_pamt_cache(struct kvm *kvm,
                                         struct kvm_vcpu *vcpu, int min_nr_spts)
 {
+       int root_level = (kvm_gfn_direct_bits(kvm) == TDX_SHARED_BIT_PWL_5) ? 5 :4;
        struct tdx_pamt_cache *pamt_cache;

        if (!tdx_supports_dynamic_pamt(tdx_sysinfo))
                return 0;

        pamt_cache = tdx_get_pamt_cache(kvm, vcpu);
        if (!pamt_cache)
                return -EIO;

+       /*
+        * S-EPT root page is one of tdcs_pages whose PAMT pages have been installed in
+        * __tdx_td_init().
+        */
+       if (min_nr_spts == root_level)
+               min_nr_spts--;
+
        /*
         * Each S-EPT page tables requires a DPAMT pair, plus one more for the
         * memory being mapped into the guest.


>  }
>  
>  static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> @@ -1911,23 +1915,41 @@ static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
>  static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn, u64 new_spte,
>  				     enum pg_level level)
>  {
> +	struct tdx_pamt_cache *pamt_cache;
>  	gpa_t gpa = gfn_to_gpa(gfn);
>  	u64 err, entry, level_state;
>  	struct page *external_spt;
> +	int r;
>  
>  	external_spt = tdx_spte_to_external_spt(kvm, gfn, new_spte, level);
>  	if (!external_spt)
>  		return -EIO;
>  
> +	pamt_cache = tdx_get_pamt_cache(kvm, kvm_get_running_vcpu());
> +	if (!pamt_cache)
> +		return -EIO;
> +
> +	r = tdx_pamt_get(page_to_pfn(external_spt), PG_LEVEL_4K, pamt_cache);
> +	if (r)
> +		return r;
> +
>  	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, level, external_spt,
>  			       &entry, &level_state);
> -	if (unlikely(IS_TDX_OPERAND_BUSY(err)))
> -		return -EBUSY;
> +	if (unlikely(IS_TDX_OPERAND_BUSY(err))) {
> +		r = -EBUSY;
> +		goto err;
> +	}
>  
> -	if (TDX_BUG_ON_2(err, TDH_MEM_SEPT_ADD, entry, level_state, kvm))
> -		return -EIO;
> +	if (TDX_BUG_ON_2(err, TDH_MEM_SEPT_ADD, entry, level_state, kvm)) {
> +		r = -EIO;
> +		goto err;
> +	}
>  
>  	return 0;
> +
> +err:
> +	tdx_pamt_put(page_to_pfn(external_spt), PG_LEVEL_4K);
> +	return r;
>  }
>  
>  static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
> @@ -1995,8 +2017,8 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
>  	return tdx_sept_map_leaf_spte(kvm, gfn, new_spte, level);
>  }
>  
> -static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
> -					struct kvm_mmu_page *sp)
> +static void tdx_sept_reclaim_private_spt(struct kvm *kvm, gfn_t gfn,
> +					 struct kvm_mmu_page *sp)
>  {
>  	/*
>  	 * KVM doesn't (yet) zap page table pages in mirror page table while
> @@ -2014,7 +2036,16 @@ static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
>  	 */
>  	if (KVM_BUG_ON(is_hkid_assigned(to_kvm_tdx(kvm)), kvm) ||
>  	    tdx_reclaim_page(virt_to_page(sp->external_spt)))
> -		sp->external_spt = NULL;
> +		goto out;
> +
> +	/*
> +	 * Immediately free the S-EPT page as the TDX subsystem doesn't support
> +	 * freeing pages from RCU callbacks, and more importantly because
> +	 * TDH.PHYMEM.PAGE.RECLAIM ensures there are no outstanding readers.
> +	 */
> +	tdx_free_control_page((unsigned long)sp->external_spt);
This creates another asymmetry, where there's nowhere to invoke
tdx_alloc_control_page() for the sp->external_spt.

Calling tdx_free_control_page() here could be confusing because:
- tdx_sept_reclaim_private_spt() is called only for non-root sps, whose
  sp->external_spt is not allocated via tdx_alloc_control_page().
- The S-EPT root page is allocated via __tdx_alloc_control_page() by
  __tdx_td_init(), but has no corresponding sp->external_spt.

So, could we just invoke 
"__tdx_pamt_put(page_to_pfn(virt_to_page(sp->external_spt)))" in 
tdx_sept_reclaim_private_sp()?

After tdx_sept_reclaim_private_spt() returns, sp goes back to unused by the
external page table. So, TDP MMU can invoke tdp_mmu_free_sp() without needing to
differentiate whether it's unused or not.

Something like below?

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 732548a678d8..d621e94d73c2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -53,18 +53,15 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
        rcu_barrier();
 }

-static void __tdp_mmu_free_sp(struct kvm_mmu_page *sp)
+static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
+       free_page((unsigned long)sp->external_spt);
        free_page((unsigned long)sp->spt);
        kmem_cache_free(mmu_page_header_cache, sp);
 }

-static void tdp_mmu_free_unused_sp(struct kvm_mmu_page *sp)
-{
-       free_page((unsigned long)sp->external_spt);
-       __tdp_mmu_free_sp(sp);
-}
-
 /*
  * This is called through call_rcu in order to free TDP page table memory
  * safely with respect to other kernel threads that may be operating on
@@ -78,8 +75,7 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
        struct kvm_mmu_page *sp = container_of(head, struct kvm_mmu_page,
                                               rcu_head);

-       WARN_ON_ONCE(sp->external_spt);
-       __tdp_mmu_free_sp(sp);
+       tdp_mmu_free_sp(sp);
 }

 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
@@ -1271,7 +1267,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
                 * failed, e.g. because a different task modified the SPTE.
                 */
                if (r) {
-                       tdp_mmu_free_unused_sp(sp);
+                       tdp_mmu_free_sp(sp);
                        goto retry;
                }

@@ -1599,7 +1595,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
         * installs its own sp in place of the last sp we tried to split.
         */
        if (sp)
-               tdp_mmu_free_unused_sp(sp);
+               tdp_mmu_free_sp(sp);

        return 0;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b0fc17baa1fc..fbaf43b8cd46 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2035,17 +2035,12 @@ static void tdx_sept_reclaim_private_spt(struct kvm *kvm, gfn_t gfn,
         * removal of the still-used PAMT entry.
         */
        if (KVM_BUG_ON(is_hkid_assigned(to_kvm_tdx(kvm)), kvm) ||
-           tdx_reclaim_page(virt_to_page(sp->external_spt)))
-               goto out;
+           tdx_reclaim_page(virt_to_page(sp->external_spt))) {
+               sp->external_spt = NULL;
+               return;
+       }

-       /*
-        * Immediately free the S-EPT page as the TDX subsystem doesn't support
-        * freeing pages from RCU callbacks, and more importantly because
-        * TDH.PHYMEM.PAGE.RECLAIM ensures there are no outstanding readers.
-        */
-       tdx_free_control_page((unsigned long)sp->external_spt);
-out:
-       sp->external_spt = NULL;
+       __tdx_pamt_put(page_to_pfn(virt_to_page(sp->external_spt)));
 }

 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode, 

