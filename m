Return-Path: <kvm+bounces-40142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D44A4F8C1
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 09:26:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 498933A7E50
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 08:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F69F1FAC56;
	Wed,  5 Mar 2025 08:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KcsgbebQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CB31C8FBA;
	Wed,  5 Mar 2025 08:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741163179; cv=fail; b=MhCrBd0BLqNGltTTlBIXGYk18CnbIpAsjPpHh9avWBHC4ZJOWdZBptGxdhBGaFbkMetNhXAR4fDo9PFub13hXNkrtxr+sP4a9lBRaQFasWCpbmQNERWBnFx0OMjJuYCfK8NnDE/43ZBCYznndFKzLhlnRG9BBTy7n8HzMhOL2WI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741163179; c=relaxed/simple;
	bh=HYj7wC/dAOCksskolYUxW3//gN/G51Cdfht86vAqhf8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TqdyKRrYKtCUWChr6jE5bLmwmaJq/+f5U5gH3IdzF1sAcVDPU/EJAw5TbrRljcDUzDA/9iGu2sDz5Tfae68adZoAxq+tzknyzTDNL6YEuubP9a1o7ZMceFlBe30K7nMLFpugFZbbFj9qoXQWxXRNsS/My7WIJyRhHFpaF0mADE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KcsgbebQ; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741163177; x=1772699177;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HYj7wC/dAOCksskolYUxW3//gN/G51Cdfht86vAqhf8=;
  b=KcsgbebQH9Ba3Arkp7Sc+ELAy8Vt3rDEb9xKTxITVMqGtLKGujG388yI
   OMVgpS6I3IXlzVoyObmZF17YdVWWQQCF4zeW3+WgOKqL1xnc8e593jM2Y
   5ONbhBClGHy2hEmedY0HOiBGABnMSytz8/yVdsH7CU7ztt820ufc00/7L
   5iY99o8TxSEBS+AuTjKJaVDJX1veRc/68fIkWgn/7jgPKM3Ef5Fd/kkIm
   x3+hSD2uD0RudVtR5jyNnWjLoSe5DYhupv/9jILkNTsWH1RdKrrJ6GrF5
   jooeylglouYJbmGScwkltOuLAJ+SvlEZ+SrIuw6Bfpft2AIHW8vT8OkgH
   g==;
X-CSE-ConnectionGUID: iIZtHuQ0T+O/elZn/kjg8w==
X-CSE-MsgGUID: 83hvtAv3SyCrQ7CUeqnE9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="41291995"
X-IronPort-AV: E=Sophos;i="6.14,222,1736841600"; 
   d="scan'208";a="41291995"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 00:26:16 -0800
X-CSE-ConnectionGUID: hS5dZs0YTiu3jlUr8RFvtQ==
X-CSE-MsgGUID: 6DvvEgUFTHafzPkXTp6cyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,222,1736841600"; 
   d="scan'208";a="149393345"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Mar 2025 00:26:16 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 5 Mar 2025 00:26:15 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 5 Mar 2025 00:26:15 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 5 Mar 2025 00:26:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NusiFwJ3ULYt+bPYaMojChZSllNqRpMsizuXOYCG3MaGAQtyawo1KGLVP9Cc8ahk+G6+Rr3TE/gnwgG2xP8cHYTG7ULQ3vsssitYhdQNnkClqg/asHFSx6Ae5ylPCAOlov/Ycj1pc/AiiaQurfUeRsJYXPyyd5eOvORk84Ojv+XqzuR1/tK0a9M1vIleyZ8F4gLGiafU9bCGWDGC4gEJSdQT+lmWmzLgLcf9SUmB8upmJGWqtGP8dUVCx6d/TIJJS82UH5BYuOZ50fKunBbLkr3DjcioX/9Dkb4hfjXZWJ9PVH1D/ruZlJYkUnOSfOjCWnSLN/eqZ3lhDZC/fN6sHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1evIc79jkB826e3oC9P76vahaRkArFA9LOf45BendE=;
 b=dj8ljfRqO2hIcLfbo4rDgIBiGYjibPNQyQzXrVuuvVu0K8Q7Tr25HP6ZafgpNknJdx2q01UOzdJH7wIlM3vXBlFjqZIyfad5ryx+DjaZe4jNAUyGIUkuFwYlN/DonP7aQ476slcHqdzFCtRWQTxQe4qM/Unx+Pjdc6QKtbVV4Vy3G4WIBASxdY8hTtOUyL4A8bXADT0GkS1FM0F97Q0HYnaDmEZgW17me5wirK6VkUBO/0gz+mRllXyQFmzJsOHNTKGV+8tX8gYONZb0KTvzIkOOFbEOo19fYE9LMgzWK0l8IxTxrg49L8JOGrthViWvzdd1RHW6gwJ2gs6hxnQWQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MN2PR11MB4583.namprd11.prod.outlook.com (2603:10b6:208:26a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Wed, 5 Mar
 2025 08:25:39 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 08:25:39 +0000
Date: Wed, 5 Mar 2025 16:25:29 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <tglx@linutronix.de>, <x86@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>
Subject: Re: [PATCH v2 1/6] x86/fpu/xstate: Always preserve non-user
 xfeatures/flags in __state_perm
Message-ID: <Z8gKeVN83omngleo@intel.com>
References: <20241126101710.62492-1-chao.gao@intel.com>
 <20241126101710.62492-2-chao.gao@intel.com>
 <ce5e2f44-144b-47bd-9f7e-02f61abed76a@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ce5e2f44-144b-47bd-9f7e-02f61abed76a@intel.com>
X-ClientProxiedBy: SI2PR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:4:197::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MN2PR11MB4583:EE_
X-MS-Office365-Filtering-Correlation-Id: 746e773a-cbc2-4c84-2468-08dd5bbf5011
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?EH05jQ8w/WQqo+ITPDPDcHTeCZjYPxmzALn/pbgdyRDFuKY2EVyScK6hg/Jw?=
 =?us-ascii?Q?6yu2HM3TYejm1Lf1g3z3uiECCVS8I/k7ntdhpebK4fTIUuNbuKLxw2IH0R4Z?=
 =?us-ascii?Q?iUAFTiTnZ9i4iw211zEBMPHXwGswbLrHqRbigPiY/91NcMyLROsFofKJrXMS?=
 =?us-ascii?Q?wH+eVIPHz/WaD2Qyt1rMi1Nwc88vEPVksEJXs9JGG5L+bMcigwhuExoNayXY?=
 =?us-ascii?Q?zOYACutfBphlF9B4y5NGJSsDjQplvjuBvGI/D+F6tOZaE6NpTWoQM93ZRCVn?=
 =?us-ascii?Q?SsKSZZj1iQWfmIncCvNSYX2rRc7J1FJ6mW6mtfl6rIShRgGVIgoHFgBWNse4?=
 =?us-ascii?Q?JDoGxlxuA19uAQEIJ2W0o2gC1mnYmeOiAOok5e17HXyVov5ShZuGK+7XGIJ+?=
 =?us-ascii?Q?8WH+9qsDZXy1s1LeQ/TvIVfajlORcV27MeuHXSrkh6vi7bXIrU3ku2PyBz7Q?=
 =?us-ascii?Q?UjsBRBNnLmiFDOqn8E1Eyare+a7bOyVw+JL3zQp7jWJJZvglS8hNk/uq1TJJ?=
 =?us-ascii?Q?TNnEyiH0itNyoEeEtsReJzitVvYEupbj8hCRa9nkdDqMm1DHj4PNOtOafRiG?=
 =?us-ascii?Q?f+bFlElj05tRJHt4l4PluZNS9Fe9A5eUrE6Ez7BEdRZ5zb2nzGaDt2X7lZUP?=
 =?us-ascii?Q?JuYt5RR34NbzaT1WMa0Mkp/mBBMQ5ph6aFdfpdNuJGPsQqGHht22RGZE59l8?=
 =?us-ascii?Q?Hd4h/S3xX+iEBofWqV0ExKwVcbusMIAcZaBPzWmWOn2AmqN5/VncTNfv/c5s?=
 =?us-ascii?Q?e2wZMh9iKvMvMH7ixAJwoPfAid5aJCIDH/Ck5+8L2qGVffPDtEd6uS+c97/P?=
 =?us-ascii?Q?62Y7FRkIPa0jKuLXGrr2UeBx8CQ5svFCrJ+67dwIK3RP+WlDllWmEN9NjsPU?=
 =?us-ascii?Q?/AwRp5toOug73jhtr9QYSuJ1+9jmNRExagPyMqYXwX7YMBSRn50y5ovDA4Xx?=
 =?us-ascii?Q?NShrClGmPvNGS8txwnsZjq+udtbg8zvRRNCeYl/o9ChUTlIBFtQ1EetFKZO9?=
 =?us-ascii?Q?nmTVbaquzbDfq07XNnSTRqvVgpRIFsRxSpxNl0fS7cEN8vhsbESUnFQXaAXq?=
 =?us-ascii?Q?2jFAlPwGmnETt/iyfH34exrv+PgMymMmUA2/EqMLUporBcLoO6iHDO6QAqjc?=
 =?us-ascii?Q?HdR72jDfGDEL4R1LQegl1AxsIvLRge/EcmL/zk5k+mNhiJVfoN7U3q8s5VAR?=
 =?us-ascii?Q?HaeOFLksskalWZ1q4DpGBlc7e5LK7VKzqdVG6b4NXV4BSqAs8m1xERsJfu4c?=
 =?us-ascii?Q?uanqUMfwNNaJ6asA7wA7B5a8nucumlpdfQi2r4mu9ngYMTDs1MTXK2fMX1xU?=
 =?us-ascii?Q?wr47Puwx8W4eZOxfL4R+Foann/7TzGowokttaAbQwJecOkC/Y0OyFtPFfuu7?=
 =?us-ascii?Q?9Bnxu1sXxfTdOHFskY5VqTN87qvk?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lmi8BoaUzoAGzHoY+NqQPV3GruEZM8MnIu5Ro08q8dwct5NtrjmSUw/ADq8h?=
 =?us-ascii?Q?KOaR5DxhWoD1oxhFAU3fq4ANlc20aX/0q1cxKNX62QCYNUbLhnTr+de3IZo7?=
 =?us-ascii?Q?uIQ+yKr+EzlUqtNo0RqoHmLv8MGKU8JvfnxkGkNgQaHvrXr5OiOv2hMaZvIo?=
 =?us-ascii?Q?wMmO0f8xInfCFgftnbX6mM9L3zjLor4f6k/5YD1Yf//pWM4ISg1zDZQoMLi0?=
 =?us-ascii?Q?hsEcnpfBP+seuS8X1bI5SVqd1MERH14JcMXwWEEC+CbvRbkyo0sfS4RH4swm?=
 =?us-ascii?Q?imzwA9vXpSlv2Z3/009xaxXAEFD/QgeS+dxKZ2Ma9MiXvH4g/0aSdSP9X+ek?=
 =?us-ascii?Q?UHaTMiyfndA+KwyxoNL4XKXmTfsCTQbxhQKfQh89LI+vzocoUQkZrsNKys2X?=
 =?us-ascii?Q?KGEHsB6aJVrETp22kLNIYfKSuvcwMu/Tbhckl7hlb01T9/jhG4ytnW5+oQO5?=
 =?us-ascii?Q?D1vWZcpgumWv08RMg7iGCFNpWGhlKhlVVOvWqcEanyMX5OW61Nzk6OtDQyYJ?=
 =?us-ascii?Q?fPyUcwliCx5Uw++mJeK7ntDzKY4t71461743sNtkDzEmddTxU7ik6Kr6GWI0?=
 =?us-ascii?Q?k/YMUPH/HU7IESwrJDeCYGLzS9m2/6s7YQ49PZ9rS1jHRYi/1y+5rOrMat97?=
 =?us-ascii?Q?vtch3QYZYzYmWDZF3kjbHioNwUbTxPBP/U9q26hasol9tasXFIh4Iw4YKdIs?=
 =?us-ascii?Q?UBAqdvW+eKAM9mjfqvURasNbkYieAU4b6ttP6vIZVxJz1V8DzpenjkP4/o01?=
 =?us-ascii?Q?rEmxtx69tdJEasmLgW5iZQeViKqDDjJVtLjpmYdQVyMs1qvvDEAxgPn48BnU?=
 =?us-ascii?Q?XAuenc+qPmPGx3Zv6B6ht96u6mDEg4UJMVUeY8kcVuw2/evm2/ZpHl6vBk6T?=
 =?us-ascii?Q?x3NbUlSn1tIrbFvtqAFO1sK6In3n7NjW6ZbCcl/YPxL6S6qOsYj5mLdzHi/7?=
 =?us-ascii?Q?XBEW3BAGXI+2AUfoSXdnDAEW9d7WImXNn3wqi6YR1DXGpxTUsOx2XXzFTDvS?=
 =?us-ascii?Q?yXoGuLgP/m2/W1oWEVVSk3jzKTd70p78bzhvCMdIJoH9vBohhA8jt1SGeWqm?=
 =?us-ascii?Q?S0OLpNt5t8PfKkudiep4qr7Vu7pw+BdcCIAU5qSM4MS/xqklM62pVL5P6QPt?=
 =?us-ascii?Q?yPvXMt9GvbhGaP+G2WHXg1u8cZk3TcOU0X+dniHMelMD8BRo824VdYQbv7JD?=
 =?us-ascii?Q?LwWM7vpr9Vqmzp/VQDSLpvPZxZcPkzyxaC1UM4vjIKpiHqNDjf0KZdpPs7Ji?=
 =?us-ascii?Q?HVdIzijPOZ23PxZc7fGzRnlGWfs7p/rIEC8/8LuGpYiMo61jRy0IFlZ69VDn?=
 =?us-ascii?Q?K1UE6jkEYwjdQgTgvKe33SzjHHKd7AjGKThWhyuv/KTRn6rhqcYy22F3JBpQ?=
 =?us-ascii?Q?88xv6LDK3kjyxgVkAk80BN+k9hSlfojxxzlcyALa0kMIhvLPd50S66ujBkgj?=
 =?us-ascii?Q?mVXdcXDW7Ddzl/eojKqcThSP99oJbwEShgoSLrNCY68tXXZBFD4eN7MZTQtD?=
 =?us-ascii?Q?LWfr1iq1upnMXuIGuwFLlQPqSnnVfnM44DNv+kn68ZHuqD7Npyl+fB0FJzxg?=
 =?us-ascii?Q?s79WCsfbqd3ftJVCh3CuhiQ0UvNEUBxh3Uu+6xqd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 746e773a-cbc2-4c84-2468-08dd5bbf5011
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 08:25:39.8313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XZo2v4xZqJ4aCkx3nhg/UfIgGPDvc5W4nVlBjwe0EKeYOlPB9qW599b94EXN9ULHk305XVxiVh57LWORrAwR3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4583
X-OriginatorOrg: intel.com

On Tue, Mar 04, 2025 at 02:20:31PM -0800, Dave Hansen wrote:
>On 11/26/24 02:17, Chao Gao wrote:
>> When granting userspace or a KVM guest access to an xfeature, preserve the
>> entity's existing supervisor and software-defined permissions as tracked
>> by __state_perm, i.e. use __state_perm to track *all* permissions even
>> though all supported supervisor xfeatures are granted to all FPUs and
>> FPU_GUEST_PERM_LOCKED disallows changing permissions.
>
>Should we document what __state_perm contains either in
>fpu_state_perm or xstate_get_group_perm()?

Yes. I think we should document it. Will apply this change:

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index da6583a1c0a2..93481583dc85 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -417,9 +417,11 @@ struct fpu_state_perm {
 	/*
 	 * @__state_perm:
 	 *
-	 * This bitmap indicates the permission for state components, which
-	 * are available to a thread group. The permission prctl() sets the
-	 * enabled state bits in thread_group_leader()->thread.fpu.
+	 * This bitmap indicates the permission for state components
+	 * available to a thread group, including both user and supervisor
+	 * components and software-defined bits like FPU_GUEST_PERM_LOCKED.
+	 * The permission prctl() sets the enabled state bits in
+	 * thread_group_leader()->thread.fpu.
 	 *
 	 * All run time operations use the per thread information in the
 	 * currently active fpu.fpstate which contains the xfeature masks

>
>Either way:
>
>Acked-by: Dave Hansen <dave.hansen@intel.com>

