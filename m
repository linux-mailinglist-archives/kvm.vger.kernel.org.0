Return-Path: <kvm+bounces-70828-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cFv5IRZCjGm/kAAAu9opvQ
	(envelope-from <kvm+bounces-70828-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 09:47:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0172F1225E4
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 09:47:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 516493067091
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 08:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48682353ED2;
	Wed, 11 Feb 2026 08:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XSbfq/x9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BB01552FD;
	Wed, 11 Feb 2026 08:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770799622; cv=fail; b=ePfl1sbZlDEJFrjH3HUaDRvJozDIr801CbJUjkWHnHJPeUi4Bo7MVk6QBExHUt66wkgSAldKMFZHi+GBHYXedZUdoVn5EfF3jblZt5+gWtGjNKuTWU4vFRwK9CMEWINykvvH0zvP95+41/uU7AUDUau4HVb5g4EenQ+9XbPOxME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770799622; c=relaxed/simple;
	bh=BQpkm9OfoTgtZaRYgs21RuNQ8k2AOl7XAYbav86liLE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kLfSx7HypK9kwgLP28dGvUPl8vnBiP9zWQ6oAzPmaReQJK/8et68l2hXpZwUHWNmNAMZqMHYE7/l8s5z0Zx3XLabJwwR3rob645UBLsqmk0dAknyyvBlxaqcFlOWNo/Bie72AcJufIYTFhttRuSHrovV+0roWH+jyIIH4XdCiSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XSbfq/x9; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770799621; x=1802335621;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=BQpkm9OfoTgtZaRYgs21RuNQ8k2AOl7XAYbav86liLE=;
  b=XSbfq/x94BGLtrJ5d6oRQjcCSpbldk6812gdpMw/VIZkfcMy501Nk+mM
   dHsNGXtjV1Vh23apfOzVFcFXzctPE81LATZpb5Chh1D8JZMDs/3tpZ98D
   xWw/ltVxy3e+hcbbmU6fkl0PL0dGb1576s619hvEFj0WlIXKY+uinTgsk
   8Uq4SNtXqcVZbk462xCYqCKfaII0RfBzFvT5paM1sxvCoXNo0CwcSr51O
   42xGefOeKhuJSQwQMznZlZBImVGdzHJvGWCLoxDICwGtKwLzgQkvCwvn4
   8AJx2fIeufgV+QQ89lRj5hGhNJhDmTCdCKOzHYWumtUUrdXwWL9FTxYBg
   w==;
X-CSE-ConnectionGUID: 1wfU09nMT8Wcb3HwrD09og==
X-CSE-MsgGUID: sla3eCTnRviwedP8cm6nLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="71840434"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71840434"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 00:47:00 -0800
X-CSE-ConnectionGUID: /g7tUBp4QzWAkXBxW1Tr7g==
X-CSE-MsgGUID: Z+ETqf80RAWBGTi09YziwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211142193"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 00:47:00 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 00:46:59 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 11 Feb 2026 00:46:59 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.67) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 00:46:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mgKCMYjPl95GxCQ84dWFtAVXSuIoLGxy7p61GxR7MjQ7N4GLJS6sIUaTDz3HHbuxzgQfUA83x1+SBmj493R5VSP2/hxnhq9z+FmferCmR50vNRvFnXjiC9xPLJweLBL5bHU7Ai4bFTC2EGymAB1+w53s/sQWLsioc6phDN7Wf3wGs6mDMIWc/r5EKr9XX+EPFH1kvDQmtde3SNOwVTYuAz11ibcL9TUtNjDf64kcYX1U5pJjQ4fsndd4iwrzJogJNsoncvyBdkWH9Vyj2SdDF04ybHqFMwpWWE7sljmy29D8RnxM38SDD/2N+dSxcyiwxKP+0CZ6067/zx5UxD88Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjWjkPD6FbZGIAsF84VRv+EyI+apKVxtIiC/pRk4Uyo=;
 b=aaQeVmk/c1tU90pbxQsVbQ1ovRAkYIdLKITqbVIwqsrDfBvX9PiBrHOeACGEYL6UrXGJBD7CLRGV440bYRIefiSBpfmaRdcgT0eEKpOD0IxlfpZDJffX1S8REDGGHqT7IFr5vfM/nuEeSznXHAMQxuXUDUVSxLZYVmD5qSfhGvxtMFCmjx83NZiDmelNjlMbLa0vYgVTcl5L9SVKwqduASij6Jdk+r3jLSDw4nVxnMZjuhMO2D6fHbguGyX6Xm/Yum4v19CYL9yvEALilVKRN+/D8mNgFTFOg4i3e3WMk5nxCLul3TycOUkeU5P9ctQ6EVEt4Bcp2tIR643XiYQtsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7468.namprd11.prod.outlook.com (2603:10b6:806:329::21)
 by IA4PR11MB9108.namprd11.prod.outlook.com (2603:10b6:208:567::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 11 Feb
 2026 08:46:51 +0000
Received: from SN7PR11MB7468.namprd11.prod.outlook.com
 ([fe80::c17a:b7fa:6361:dbee]) by SN7PR11MB7468.namprd11.prod.outlook.com
 ([fe80::c17a:b7fa:6361:dbee%3]) with mapi id 15.20.9587.017; Wed, 11 Feb 2026
 08:46:51 +0000
Date: Wed, 11 Feb 2026 16:43:54 +0800
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
Subject: Re: [RFC PATCH v5 44/45] KVM: x86/mmu: Add support for splitting
 S-EPT hugepages on conversion
Message-ID: <aYxBCINUG80GYfus@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-45-seanjc@google.com>
 <aXt_L6QKB9CSTZcW@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aXt_L6QKB9CSTZcW@google.com>
X-ClientProxiedBy: KU0P306CA0086.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:2b::19) To DS0PR11MB7457.namprd11.prod.outlook.com
 (2603:10b6:8:140::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7468:EE_|IA4PR11MB9108:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f78ec7e-e5a5-4c38-39ae-08de694a193c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?EFU/Pzu0m1RwHuzwC19pppUwBfmcpGrALiXrXWab/fqeoLZ1v1jB2bWYh/ES?=
 =?us-ascii?Q?+ejMYRI57X1Wru9uZ0Z95dz5624c76Yo2JG2FB/PrF7gJ5heFlNEpEX3+NTX?=
 =?us-ascii?Q?pMSNofe9hBo90xpprE9KZiBB2mZ+BmqpV9GIO3UkhpEGiomc0+pdSDKWPgoz?=
 =?us-ascii?Q?HGnK0a7NcpSUnIDRige6UnXzDajTlUMUdBI+7XaXd6Shvv126nNxDJkoc37A?=
 =?us-ascii?Q?Ba97fSU4wySicBHSO8OImLdcDrUjDVHh3vKEXc8kKSj9G2TGSZV/S/6sah44?=
 =?us-ascii?Q?DzEUwVEpcq8Kjf+TVMlTC23gjJRYaNbrzhe0kuOWdld2YuaJbRPjqFKtfn7f?=
 =?us-ascii?Q?8h25rNQ86J+kEPw3eB5GmkqJOfNs4JskhnccFprxIv9G/MXd7+egK+EK5Y+7?=
 =?us-ascii?Q?pJ62JXKH6EvP/B0rY1ZID8rg/+T3e3+Xdxbnk4VIaJPpzXmZKIOvpLDQBo1p?=
 =?us-ascii?Q?DUecZYC5vl43lrbq9QMD4MKUFS3xNYpRqBVWLX+EZIbdNySiMkf62NI3ols+?=
 =?us-ascii?Q?1Bk0CaPotbrKpsn6R59iFTrkSotScLJtNaoqy2vPVNFUslo5NxmpeWzd3CeH?=
 =?us-ascii?Q?YjnWs3jid8GLBzCqv3rWZa/LacMq/tdrcbBl+vCFZ93XbsLBmoYCrUVdZeBD?=
 =?us-ascii?Q?5qC1xso4HI6dtPTEHcdq3oiu91Q2l53XHPzRBy1m1VEWP3tW/Og/lxQ+35TX?=
 =?us-ascii?Q?hJhdfysCaHCNy3efTLIslZYvN8QsdbIChPG+X4XZxiPEVZ+naiRZ4wMuKJp/?=
 =?us-ascii?Q?P53qlNHUNZOdSDj6jrYgvMeqYZVJXfQmeaxuekYj4EG5hi0Gi2MWjCatMPk+?=
 =?us-ascii?Q?ryTlhl5BCQN28+Me6Ghs9d72XEcBZbSrkQR5MTefdoqXWS+PxErBqkKtfl05?=
 =?us-ascii?Q?9dsTzdE4n1nkcpIiEJvLsXgOrQh5Oqy3PbCFbG0HwMqq/mzAgOgQ3O0n0j24?=
 =?us-ascii?Q?cnDIT9cMlkoTJoamwAyb9bHwXOFkP2Y0h9mhCp4Vf+RUqPqBgUMH68TE+i7J?=
 =?us-ascii?Q?y2gv/SNC0+BdIRlViikMDiXImdk4BoRs/lPWBX9xM8kYwqQJNOh4M+CgmVZ2?=
 =?us-ascii?Q?EwpwaamROQ3TAHcrP1BmElDKraU7Fx14VPZQIn2Z236eoWNRwxAddRSiXRRS?=
 =?us-ascii?Q?uUXhEQG+u5NvdpZnSGNYfUD9S3HXSpn69DQgb6488NQSq/TxfLAx0V9CgJR2?=
 =?us-ascii?Q?idCRcnvrkpzbwCTXK/bCOW83L+/Z2w7DrrquK4NENZ2aWs3sVBWKNabGlvPF?=
 =?us-ascii?Q?1ouZjg5cdPs1V/RExAgDC8Z0tXLWYZahAe+Rsv5MmW+voXgPkrIaDToY3gk2?=
 =?us-ascii?Q?gp0K6cwDu6/BRQfp+jk/GjpUNy9Y2edABD4OPVCKFLVNmK/d/ikYni3m2YO4?=
 =?us-ascii?Q?/JfxZbFlQHQomkFO6ezK7oviS/TiDPxQ6zvxRrb3UBp7bnSPVWXy1I3AoOGU?=
 =?us-ascii?Q?pAAZPxLNoY/EzIlTjQLrVxDRle++EB4TiMVQQnKK8IzXNyA+7z9jJKy4H0Mh?=
 =?us-ascii?Q?ZXoYLoScHHYtZdtUIdt3svMZU8HPK8Lm9u6VxE5HMaeU1KHLMCe6vInwUph7?=
 =?us-ascii?Q?AOrU/1ZqhFtQvxHsSiwnwksj3ZC5z8hhe2RSy/Zw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7468.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gyYh5yfkNcvAFEWGpS+oGWdovG7Fh2LXppNNil3bop3swzA7HTGb6YRYm3x1?=
 =?us-ascii?Q?kOHX++d3gs+MjUB+KeCtCx85fVhIOHu6OMnhiAp9aV5pgTrdG3CnOCTLzMjL?=
 =?us-ascii?Q?zm8pbnZSMUkC2DGXWVHcNkTFIjF2BsAYn7e+1/inHXko+TEKkOqynF2trhiN?=
 =?us-ascii?Q?apqDpfUh2WHByV9XACKNLmC+Ip9S5TmhUm35TzDW8lOY4M6bmH7EYRCtjpgt?=
 =?us-ascii?Q?9qQLiUUC4rWOOckcEbtDtxsY3pNWfgIqBDh9ZMf+RXeut4sCbnG36PigYy73?=
 =?us-ascii?Q?XjCjC/hzBvWxkUGakJh8BOkF3IE/I7o93bbeWY/XnCkpPjvbM/2Ctug32b/P?=
 =?us-ascii?Q?jy50RDf1dFeMVX2TQPeZgPeVPOVDG0MPrf/mfZflgJ5f+FIO200Hp16fuJPR?=
 =?us-ascii?Q?pqzbzAQWe1d+yQuC8akjS/4WlqWYf+kxJkHRPoxV8gvpLs5uQeQKif9WPN1g?=
 =?us-ascii?Q?h6LQBoWtd/ODqxCbJmKksv4XvSOiNhV+DjZljWo1R9QLsZzJwkXc+SrWAu77?=
 =?us-ascii?Q?XPL/GsxFxma9C1BQfGBv04PlBuAC4N7ISPjwDW8zoGKcCS35dMMUPRiyiYAO?=
 =?us-ascii?Q?+Pe+SzzO2YCUo0qu2yDRG6WIAZVfkt2zk3MGQBoixd3tjPZRzv15kcGh81ZR?=
 =?us-ascii?Q?5YPm4nBFYGonYe7CHr6eaKQLNlTre7IDtIvyRbh17iTWBd/3S/PjISEIJ9kX?=
 =?us-ascii?Q?H1AUohEL/MCqq75xfjf6ae2XXOnxxELjzrj8M9Mgv/6FbPAbqx8p6FsuJRAZ?=
 =?us-ascii?Q?cpIVOmrESAE6p2hlsvf/H+ZcKU/Ag2GTk2z+ujjD18dwJc9b/qskUJRyoEc3?=
 =?us-ascii?Q?nPhkP981ra22ms0iMTYyfRIC0weKMs6FZLhqWNjhOIOso0Lu1+XYZXwAYacP?=
 =?us-ascii?Q?PCoHPj2sYm106PGYKCDESz/3VIn/6omZKHOaYBPdmsf5SLLf1Rpgl8LajGKO?=
 =?us-ascii?Q?9JCRwAkNgWnv6NOPWXx6ZejWCDickyGL+taNAdlHK9qjfeep+32gb9/43Pv+?=
 =?us-ascii?Q?oZWTSllK1oWxgsjRLkfvTM8lq8IqdM3TGxW0YzbbPuNBFRAs5aJXuawBeFWS?=
 =?us-ascii?Q?H6J8zIuit42z6zdrQPMo931Jj1gOov5+A9Kl33YY43LN3lYl+dwJghRb4F54?=
 =?us-ascii?Q?SRCdjvGHMJdJrF55zGSEa7mSTfwglJs2u8LjyyP7TFbPKshU8T7t+vCZuhcI?=
 =?us-ascii?Q?9OBBH27D1MahRieOlkLrCjyryrUBptiuo5kUW+0zPjC4gmare316XRanvO+2?=
 =?us-ascii?Q?G60FZX4KRHAj1dfAwei9gciMdYORS80oYGjFpfO+HYt3RNLiyaQuvuFTQyKD?=
 =?us-ascii?Q?DPPUk//pNV6PzHzC1M5+vrucS48W6icwhZNS8DSJAXOpLf7yhGsJ4I5HUiX8?=
 =?us-ascii?Q?3ILEqr7q1JD90ZKW7mx278GCexjsfKyYissPlc/tbkXV5HRqNyc0IOXpRAgx?=
 =?us-ascii?Q?9iyQZ6vKD1qvFhDc73g6UREAECsK6WO4R9XJ7j/ESFuJyTLmclXPz+FCWLlU?=
 =?us-ascii?Q?+M02ZWKl0koJ5FRBlCdT8e34udVz1mo9OlyXyExUYj63fVUCtABmzu5lAWey?=
 =?us-ascii?Q?e4F2GU10Y5CVS17YtvVYQ7NlmL79lmIcj5dS3L0hwzYWlIVfiIAL1+TiOf5n?=
 =?us-ascii?Q?EasN/N/leg5TH1p2Rz6YOD/PUbiXd0NACP8wKo/mZ9FxpPerygl2u14eZyYq?=
 =?us-ascii?Q?6/i5hlE87lfSysvkZME2fVMZ8+dPut1/SXlyi221FMnSgRF5yrpvgGc+b2uW?=
 =?us-ascii?Q?eJwz6aEeXg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f78ec7e-e5a5-4c38-39ae-08de694a193c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7457.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 08:46:51.2647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: frfVccDzfgMBYFv5KotLBiGvd68W1Abmj/OUghKzF5vUQhoeimplbclGS/H0+xLmlcC9bXLLZk2lUFATTCDpDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9108
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70828-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:replyto,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 0172F1225E4
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 07:39:27AM -0800, Sean Christopherson wrote:
> Compile tested only...
It passed my local tests with the fix [1].

[1] https://lore.kernel.org/all/aYX-RpxDYrI65XRC@google.com.

> @@ -1950,6 +1950,7 @@ struct kvm_x86_ops {
>  	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>  	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
> +	int (*gmem_convert)(struct kvm *kvm, gfn_t start, gfn_t end, bool to_private);
>  	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
>  };
Since tdx_gmem_convert() only performs S-EPT splitting on the specified range,
would it make sense to rename the op gmem_convert() to something like
gmem_split_private_mapping()?
(This would also involve renaming
kvm_gmem_convert() to kvm_gmem_split_private_mapping(), and
kvm_arch_gmem_convert() to kvm_arch_gmem_split_private_mapping()).

This way, it's natural for it to be called by kvm_gmem_set_attributes() for
private-to-shared conversions, kvm_gmem_punch_hole(), or kvm_gmem_error_folio().

> +static int tdx_gmem_convert(struct kvm *kvm, gfn_t start, gfn_t end,
> +			    bool to_private)
> +{
> +	/*
> +	 * When converting from private=>shared, KVM must first split potential
> +	 * hugepages, as KVM mustn't overzap private mappings for TDX guests,
> +	 * i.e. must zap _exactly_ [start, end).  Split potential hugepages at
> +	 * the head and tail of the to-be-converted (and thus zapped) range so
> +	 * that KVM doesn't overzap due to dropping a hugepage that doesn't
> +	 * fall wholly inside the range.
> +	 */
> +	if (to_private || !kvm_has_mirrored_tdp(kvm))
> +		return 0;
> +
> +	/*
> +	 * Acquire the external cache lock, a.k.a. the Dynamic PAMT lock, to
> +	 * protect the per-VM cache of pre-allocate pages used to populate the
> +	 * Dynamic PAMT when splitting S-EPT huge pages.
> +	 */
> +	guard(mutex)(&to_kvm_tdx(kvm)->pamt_cache_lock);
Thanks for the change from spinlock to mutex, which is a smart approach that
eliminates the need to release the lock for topup.

However, I have a question about kvm_tdp_mmu_try_split_huge_pages(), which is
called by dirty page tracking related functions. I'm not sure if we might want
to invoke them from a non-vCPU thread for mirror roots in the future. If that's
the case, would they need some way to acquire this lock?

> +	guard(write_lock)(&kvm->mmu_lock);
> +
> +	/*
> +	 * TODO: Also split from PG_LEVEL_1G => PG_LEVEL_2M when KVM supports
> +	 *       1GiB S-EPT pages.
> +	 */
> +	return tdx_sept_split_huge_pages(kvm, start, end, PG_LEVEL_4K);
> +}
> +
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index f444fc84d93b..2bb4604a64ca 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -48,6 +48,9 @@ struct kvm_tdx {
>  	 * Set/unset is protected with kvm->mmu_lock.
>  	 */
>  	bool wait_for_sept_zap;
> +
> +	struct tdx_pamt_cache pamt_cache;
> +	struct mutex pamt_cache_lock;
>  };
>  
>  /* TDX module vCPU states */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c80cc60e7862..c3d71ba9a1dc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -14061,7 +14061,7 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
>  int kvm_arch_gmem_convert(struct kvm *kvm, gfn_t start, gfn_t end,
>  			  bool to_private)
>  {
> -       return 0;
> +       return kvm_x86_call(gmem_convert)(kvm, start, end, to_private);
>  }
>  #endif
>  #endif
> 
> base-commit: b2791d61e9774d8575525816e864d2e09ee9090a
> --

