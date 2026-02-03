Return-Path: <kvm+bounces-70077-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KBvjC6JTgmliSQMAu9opvQ
	(envelope-from <kvm+bounces-70077-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 20:59:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B373EDE512
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 20:59:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5302D30B3235
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 19:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6339D36829D;
	Tue,  3 Feb 2026 19:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fvwdank8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617AF35D603;
	Tue,  3 Feb 2026 19:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770148743; cv=fail; b=LB7QbYyTddICIeNss47IvDtJs0Z0as/9tl+xx7BIFvgoxoGAc3lweK6M7h1t3kAi9Eoo1j0psWjIvZ5a96s5AiU6OvcebL1t9hR2divPf4KHjgh68BRYdEJ/cvV13Exwe7+PdAb1NHqwYvz34wX2x+tEp/137ky1UVtqG/wRjfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770148743; c=relaxed/simple;
	bh=DrO5Eeye9sEeOdjUnYr4PF5A59zHPlK3/uDDvtnqa7Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tyPaRNZwvTmaxrS2mH9vrpeuI6K87Y3H3tJgaZV0RNNBOuu/G2D9pY7fmlr6/Gs4GHijzgONS9gZDwSKaOtFTK8pwBHwsGhrnziP9Grn5a61HzXZjO3iZgKAtNgkmlPT9xC6YY0KxDELZjY2AeXgpKqegb0CSAiqesSaDBH2NAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fvwdank8; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770148743; x=1801684743;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DrO5Eeye9sEeOdjUnYr4PF5A59zHPlK3/uDDvtnqa7Y=;
  b=fvwdank8WMzIU14vKgsABoza7CQ/y54zb8sQdkKAZYaavI9OaAhRUaX7
   SuoIcexyIcp4bVdHSyXN3Maj1y/KTEBUFHIvQWyDEyT3X/AwPP1/SH8bF
   Ou+XdgUx+LvHfOLg1us/BNhCvigO1PWxIN7mYkLFsniOmmET96jWWTypy
   7IZw2xDON89EbcBx+gV4i1FUdjBN6Ha3UypHcKnedj03l8CF20O1hINva
   4gp/L8+rYYV209gEZ7s0pwv1hFIpZ2m1cJNgPHYGMDjLBJ7ewjoL7oSij
   15ePoSub7bc6VnQaBOHinj8gh0DRH/tGsYJArT7YTLy09i+wWDcspR00U
   Q==;
X-CSE-ConnectionGUID: bXcAs6FtQaGRz5khZHJpBg==
X-CSE-MsgGUID: 4LqkEpV1Q0OqMdoGJLMn5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="71051990"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="71051990"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 11:59:02 -0800
X-CSE-ConnectionGUID: 0erO5rUJTbyLO+GpO9PgKw==
X-CSE-MsgGUID: /kADwtX0TUWe6wREHoMqoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="210041506"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 11:59:01 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 11:59:00 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 11:59:00 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.61) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 11:59:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jr3bJflaRqcHMcd4reRcCKj8Iiba9D8FvSuWGguV316lb0gatuG9vi3R8r29xzBptJdp0dmaXqrD7VIf7SDtpJaPywQnXN6jv19ZiWxJyiwXvVnf+gnL6SWaSpfD5Owjl/Xl0w78dIf7m2l0UfsqdVVZg8q/JmZny7hFOyzVg2kUk23HJ8eB5QmC51m7gJwDEMo2is90Aw7tylNFsaIUDroDD0X87M+8NMb7AjX9ZDm4emoxVpCYgVOyjvN4CeJHtItBrBX5vBPs7Bbi6tbtDXWojhPejS1A4oH4sHEbJlr4CUbgy1F7RF8ukG6EFo5OoF79uPPbF4dMkZ4Ce0sq0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=og9HoLQpjw3HLvQJ+SJOuPO8wXYugKMlZpIJhymil6A=;
 b=dKsZnIyJzWbxVAe5cF+X60QKzT8U/HlRjPZH4x/HjgzmresolUNlkkd6iCEZVOmnDKyHUxxJNPS0T6U5fMacRCbMq9Db9/N1ocqFBwu4heohOSzivA0EXdI8vgrkrVmCbQpp72/i5sDZpU09Dcfr8rwONgmdrBgUhkiSZ67/lp8o+KdXeFWVBd41UgIVMWav1LDai7aL0d9XFiSPz4x5FM6DGIObnCrhbc9fjwQvv8tKNvGLkns4Fz5mndAdGn6FCt8i+aZkTyBZR4eYvzhuygky7Qne01LlBDpdz8ql7MsTz1Jpf/vQ1ISJWUTDgIdy3pAYJ8qWDTXtHxNZMKFWoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ2PR11MB8298.namprd11.prod.outlook.com (2603:10b6:a03:545::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 19:58:56 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 19:58:56 +0000
Date: Tue, 3 Feb 2026 11:58:53 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Babu Moger <babu.moger@amd.com>, Drew Fustini <fustini@kernel.org>, "James
 Morse" <james.morse@arm.com>, Dave Martin <Dave.Martin@arm.com>
CC: <corbet@lwn.net>, <reinette.chatre@intel.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
Subject: Re: [RFC PATCH 00/19] x86,fs/resctrl: Support for Global Bandwidth
 Enforcement and Priviledge Level Zero Association
Message-ID: <aYJTfc5g_qgn--eK@agluck-desk3>
References: <cover.1769029977.git.babu.moger@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1769029977.git.babu.moger@amd.com>
X-ClientProxiedBy: SJ0PR13CA0098.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::13) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ2PR11MB8298:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b30f6c7-c43c-47b3-8752-08de635ea9d6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?w9W5J7sFpa3ErPRJJ5/gVKVCUJ8scmUOLLlcs/Ur4mPOzTDbOyMlMj2O/tbH?=
 =?us-ascii?Q?i/ysSY9Mq687FrV6chgmZeF6E2poHTAfZt6DoDatmYJhJkYNhOF/7eakD+/K?=
 =?us-ascii?Q?hXC8On+MsnO01hqMtOA28aqW6JaiolT35CSomxAUp+8BfKEL5QWft6zj4dQ2?=
 =?us-ascii?Q?lg90b+9MwGb454ixjPl+6ndELJ2g1mlCwL5W1LN4Tz05mibYzzKKIs2J+DEL?=
 =?us-ascii?Q?sYNCkYT4jX8INutppEwjHAbVC+RwcnLjPC0vPcXQFgIO15/EP0650hL0ZHSp?=
 =?us-ascii?Q?rgWPmuMD5nkxa7drkFOsbXu4prIdtQk1x8/ifPmxLeQclyMjl6+cCRioNrEk?=
 =?us-ascii?Q?CyCHz6XzEiG6t8QU0pmZ/naKglvQ8R3QsDrezwCY1nn40EeXQYjSoX0RK2/o?=
 =?us-ascii?Q?8HTh0qRUCK604rls2G7uYLkvdN1NlR0us4xAHQ/XGqDKC4gerzqpuCW21vyZ?=
 =?us-ascii?Q?njd74przVKTlpIYvcz6m0Juq28A2JcpADJGe8IKbLgslw72cV8pbj347Wuma?=
 =?us-ascii?Q?cMX6BkjteStmKhCaLFYDIMVVPAuAldzimWAfwttnioRPqjAXzWZF+2FeFIK/?=
 =?us-ascii?Q?56GYMK2e7gFeFFsi9aPHnb6JXd+JW1gPtdk8deSN8nX15C3SbHBHONAe1FNy?=
 =?us-ascii?Q?i1U3v8NnpxNDWvSqKWSBQym7o28RCeTMwO++QWqIA65VUAGoDI2l2fbxqWd9?=
 =?us-ascii?Q?gPL3BE8fIup/929l9zTNnSfE7+RGKpuUiSQVmRUjd2vzT2tmqxZGD4DuFwkW?=
 =?us-ascii?Q?bcV6+o1LUvUmdlw+ZQo6M6d00pv7KIOk6vwI5quXOShSf2/eF9Y6UClsxNCc?=
 =?us-ascii?Q?THmBivK0Xd5UWsiCYv5JmmDoDMmwn51elVyGUSy/gE0Q60pEeHYAJKq41fbD?=
 =?us-ascii?Q?840hi09JUHozLgiZZUOpJhw2q6oFboAMYGaO5AXeOho3dPWB8pZEKuE/rPT4?=
 =?us-ascii?Q?meHolHOoqr5btjFhOVFVUBT/9hqDb0OHLd2ZKgIAzpFAWiTiU5W5QG8Uyt7b?=
 =?us-ascii?Q?44NOUAjXu/8ORYRFARdby9F8wOUJgrN+/cdYYL161Nhf2vg/tJFVrOAI4tAQ?=
 =?us-ascii?Q?ywcMgSRXaYCosUrM2OQmQ2a1WAGItNNguBj7frArnIBatO9/3l9bFQKwN/ik?=
 =?us-ascii?Q?tkeSHMrz2ILMDIoRMLw49ZunY4jSlFJwApjv94JgL/CwkKO6238FqPTe1mBu?=
 =?us-ascii?Q?c3CQhjAfWdikn4tz5c5nOdbZQDk1AdulpTkPcPzWGoE2jYBlplVKVUexJIQi?=
 =?us-ascii?Q?UhwOLx4d03ZUTFRQXOfRCFaN2ZruZVVduj6NRFxvpb0D/wBaoHHy0c4kOHT4?=
 =?us-ascii?Q?z2625VqjFeJUPSw8Pic4qmCQzmqOT8WkdAD4a7oAyqsRCx30Hb+pImA1Rede?=
 =?us-ascii?Q?hoXILDy3EgaE/pUs1ScJn5ysz7+T9GztbmP7Pnk08CeUBY8fDjh3CS/EIWxP?=
 =?us-ascii?Q?K0uDpzmwe5FgcrbKn7ZOc73wbL0xZJauoTX3SGFjPpwHiVxOtVytIqP2yCJ+?=
 =?us-ascii?Q?55GbJco6mvZ+ZwwPuLUKGsJzWkkWtB+yOc+HRREw2EhXKx2oqC51EXclqOxt?=
 =?us-ascii?Q?s38aOo/k+rrUhTajDcw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NmgYBI/Z+jwitilbKGpV+duCAsWmG0O5ipORxZ9sWR1lUHGRaiBDgqxV+yZH?=
 =?us-ascii?Q?wFo7H2k1BNava78QSC58xMCas7sdHCr7HrCwxhNltrnhlCW/nV/ktYtfqJ4R?=
 =?us-ascii?Q?EQLe5zhxIIpEhG78X0oCQEmMjbE5e9yOSFegpyyAid77orryfgeylRAEvskH?=
 =?us-ascii?Q?PwLkGtnYXK/C6kjFJ9169m0pFaidI4kuDek1VB8+8S9Oqk0Qx3egqUCc/Mqs?=
 =?us-ascii?Q?iov3hb3RQG4rPAeGaka3pHsfjXNJUhz7T5d1xx9M5mBK/3cdctCboeAh46Kc?=
 =?us-ascii?Q?MS9nme5JrKQsMsr7H+q9sv4QH7cI6ZAWCMbqJ5NbUdqujUhkgUa8XBt89clw?=
 =?us-ascii?Q?L5V+IdOGy2BHgVrEs4jjgH8vLf68PIzI/Vokb/u1RfkST9tZfQ81SQqnnnb5?=
 =?us-ascii?Q?cDwunvC8zKH7vP9udHUHeMyNfXi7EE4XeUceMwXCKMCVNf3ig0xLmG1H1f00?=
 =?us-ascii?Q?h9ud6R1idniKdU5EsRHtOe0WRtNGW0PpaACgVCr3TVnEch5q2GYMkoApztgt?=
 =?us-ascii?Q?E3Nkxw/UEJhDY3OQjdyU00m8rFxXcY7kqBSHFzcCoAUk3tPS3M74pvtvjVBj?=
 =?us-ascii?Q?3INHTRfpfWiOgBiqoSYdBNP8UxSrCdjTNbyyAALxbzPQaEC6D/oY+R1N5sYa?=
 =?us-ascii?Q?0K19x/FA3+JO/Uf/Or31H4m0N49Rsac5ePHSi3sEfw3NSfb4HG3lMelqs5Y7?=
 =?us-ascii?Q?s6WcCwl4Ss2u2LTwsSOJ4vmXnR9St+6FG74ANKAfq8NVN7oNjPBWk5u6CmI0?=
 =?us-ascii?Q?OAorOn1WBAqnJ6ubUTfljHWQ1Srozf/b4lVrzXCKMZSrNlq+/0aw9ZKVTU6L?=
 =?us-ascii?Q?XAtliGSER97MeTNfKhJWUtuM3uNdn8KYmrnvfDxm+E/A1R5uKBJXHu+G0/Ji?=
 =?us-ascii?Q?k61HZrHBvjnhY2+wwhSzJd8giQGNOrtWoiVLWcQrLoLKlpFOHkZ2xyFR5n+3?=
 =?us-ascii?Q?ae4S0VSQmPeQIY/dagpxqFswvRcUYPSeiKCDrwxZ1FF6YsJtRSZcxQrK4xrX?=
 =?us-ascii?Q?kmwTNmqpbORvdaOVwAAk1mRPtfa0FZ13+qdo70zUM7D0sdUpX6PwkZ+IeDNV?=
 =?us-ascii?Q?x7v7q1/NO8hJm5yYaUZRrA8BY5YBR70h7UwhsUb4ASqYwg67hDd3yiUaPe17?=
 =?us-ascii?Q?bPLTJEBBZXlKplDAebvDHUjC8ej5XSKjC54cPzVwznN3k0PDQr8dK/xP3MgT?=
 =?us-ascii?Q?+NIoFVUIl4PhnYV4h7kr1Opu1SC8jvSlo8qdcuYP+dDF34BZvFruSNLYrIfT?=
 =?us-ascii?Q?tDVa+69gY+ztSyT/RL0KJ8yFrujhJSP7PmRtyn82KaDGCCXz1TLxvh18H9nU?=
 =?us-ascii?Q?k/pm88FD2wYD5VXDrivGrGjahRM87L6BQDz5rVYgVtDXgxGGCD7xujXNNSN4?=
 =?us-ascii?Q?XAkRhpM9jrKYY9nLD8fm697qvIPZZwqK6T7qoljPvXrp3VZfFYOSTtI7cniw?=
 =?us-ascii?Q?aZlVO+Br9HZysKXequZN4mhw5FMmO8qu5sIDV1W+brdc7BAIzrF7HTQRalEZ?=
 =?us-ascii?Q?FeIGq/zrQG4L7uw8217aqVQxCs4eWHaBV9ezYfBcat2rE5STE2TM9Cu+TDjt?=
 =?us-ascii?Q?D/kRjdGanBdOVy3VlEDpi7oaPgTOpjm9Y1f1AWWsYQxlhdIQXB423rBYLFfR?=
 =?us-ascii?Q?EvERQGSZ8SnIWvU5oXvgVis4ZkoMIIoNSGh1MICpSPh6hvIEXYg1duRm5gqW?=
 =?us-ascii?Q?0q2MUd6IgIvRw7R9JyLQ1a9L38lWsVAfJIG1fmJ7r2fFrPa3aeo/F7r393xV?=
 =?us-ascii?Q?K1XchrMYpA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b30f6c7-c43c-47b3-8752-08de635ea9d6
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 19:58:56.2324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mI6YP8pQ7uNQnIN0bkMOM2aUDs0bHT2aautRh4WHfdT5HWFi16lSlY8FtOheGZMLhB5uE4DZI1qMrTKqDzw0QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8298
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70077-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[44];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.luck@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: B373EDE512
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 03:12:38PM -0600, Babu Moger wrote:
> Privilege Level Zero Association (PLZA) 
> 
> Privilege Level Zero Association (PLZA) allows the hardware to
> automatically associate execution in Privilege Level Zero (CPL=0) with a
> specific COS (Class of Service) and/or RMID (Resource Monitoring
> Identifier). The QoS feature set already has a mechanism to associate
> execution on each logical processor with an RMID or COS. PLZA allows the
> system to override this per-thread association for a thread that is
> executing with CPL=0. 

Adding Drew, and prodding Dave & James, for this discussion.

At LPC it was stated that both ARM and RISC-V already have support
to run kernel code with different quality of service parameters from
user code.

I'm thinking that Babu's implementation for resctrl may be over
engineered. Specifically the part that allows users to put some
tasks into the PLZA group, while leaving others in a mode where
kernel code runs with same QoS parameters as user code.

That comes at a cost of complexity, and performance in the context
switch code.

But maybe I'm missing some practical case where users want that
behaviour.

-Tony

