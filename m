Return-Path: <kvm+bounces-35350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9701BA1014B
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 08:31:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B99471885DD9
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 07:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 789DD2451EB;
	Tue, 14 Jan 2025 07:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iybQiJfK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FD326296;
	Tue, 14 Jan 2025 07:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736839855; cv=fail; b=kr9aeNmrhznmN3czP/9Cw5EA0cxa6d7kyMZqg1LAZbN9bcslml8TsSH3+Lb17Xrw1ipsFlonF68sjudduzxY9tkiaF1CoK0ns5Vgtox6zxmNHQxvh6CWRBDAfx3MD4t+qAGD8aapAjcv8uaXFEty4+17E2Ofj56pCOJetDuGK5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736839855; c=relaxed/simple;
	bh=3Hy66fNacrbNt9PeWocvL8qdC0BvrDXdcLliGVay4Ak=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DwPTU+oR8z9WbV9yVQKjdZ/jbJSGhdNsKpkokV4m803Ioin9ubEUmdg7yRg37zFbP89MawCLpiKe1JcZ4jBP88L+QCFRCwxFJZ0Zz4YWA1RebRK91T6EaVyroosWh16oMQK/E1OZfZsL8xEDrjWaQMxwu9fEdwQLW4vNh9NrEX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iybQiJfK; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736839854; x=1768375854;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=3Hy66fNacrbNt9PeWocvL8qdC0BvrDXdcLliGVay4Ak=;
  b=iybQiJfK3wkHyw8figS/ImDsZK8Tuny3agrR0fGewvBIqpXE876GigXW
   2CFGPqrDVxXM9jkMcYgC+mdtKgfmnnCNni0U1u2DNfNCGdmOipoDdUiIV
   ABh3rsm9JOsm2Z+A8XcwbQ83U+7/hVlkrwxzp5Kc3z+LlbTt4q2TU+nHB
   djVX6szihpEfgYGGz0RDvPhxH2KO5Yv3wbjfGD2vMNQWfU73AQKnK5x7h
   kw2IGLaj8vIITbxESRWGYmABWWfYZZgWxLZfNmnmFd9DqYVCyou1pm9iG
   OuLFD/QO4ANUD/ka5QtfN4DtQiaRCNQHmt6GDnVhe/VOVt7XohxQA31AY
   Q==;
X-CSE-ConnectionGUID: xU31LFkoRCyNk/e9NfBZzA==
X-CSE-MsgGUID: d+/a2+0JTsmua4quVLOSCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="40887707"
X-IronPort-AV: E=Sophos;i="6.12,313,1728975600"; 
   d="scan'208";a="40887707"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 23:30:53 -0800
X-CSE-ConnectionGUID: mJQgwzM9RsS4AhddPC8gpA==
X-CSE-MsgGUID: bSA5pQllTQK7uYJku3vLrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,313,1728975600"; 
   d="scan'208";a="104542007"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jan 2025 23:30:50 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 13 Jan 2025 23:30:49 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 13 Jan 2025 23:30:49 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 13 Jan 2025 23:30:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JQERNO+v9VdbMtI24OgunClK6nxWS1UK8qJ+175Ljjb686NKfrYm0BO3b9T5nQQqgLq3vBOc9z7sgipUaznYzjGI35i0yrI/+tfTGNhmoO+tlTLtU1zzUxRDboZFqQClGALPQ2UgKFDeNFmH5+J3NgBjo2OU32d2oaTvHykIl8ADi9ZQAvrZ1ZvvhvD/YbRSEpY2+LhoxZBCSeLLHf/B6O68fkaShlK9WooCN8X/voSAOl0TkLEwW1GQg+uKKmRHWaXuyxCyqNb8e7Wa7yq5teHB2LWJ8l27ELlDwTPCgZO4O5MwqkeW/4PRVrHI/ZPocGEC1YNkuDMeUYv8VjHO5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/kgeBbWAm44PbePP3nTOWeQyQcM3jc8yqEVo9J7ItqU=;
 b=i2kCKD60LFZGOhY3c7vcopIdk5cedy5cj+Bo3ZLNRCfWEbbPDS3WqEQxAKD6ViOVdG4DKpFz8NUBXnSV0YBBvQhN3AduUZBRL51JLyfvxYoUogepxIt614cdU0kf6W2QiaTLq/jZU2GD/7kQsOYUBv2lO2M8znCSJu0VOnwcTlhMxhXDX5oJYPPb3/j1/tSCc5PTJ47jzsB5T6fYzl8OOH6RFkL5po0bNcYV+2wxc7gsr7GOwQhNcRiZauT3oQQYb/HENNmPqNnoAvo07LkwHY+mFmhn0iRn0fATPr5vGl1bX+LrpcnAZC5gsvEF7b0+mRzAV/8HeQ7/X6LkNb3SrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB5010.namprd11.prod.outlook.com (2603:10b6:303:93::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.18; Tue, 14 Jan 2025 07:30:17 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 07:30:17 +0000
Date: Tue, 14 Jan 2025 15:29:24 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, Maxim Levitsky
	<mlevitsk@redhat.com>
Subject: Re: [PATCH 2/5] KVM: Bail from the dirty ring reset flow if a signal
 is pending
Message-ID: <Z4YSVGDL7hL2iwVl@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250111010409.1252942-1-seanjc@google.com>
 <20250111010409.1252942-3-seanjc@google.com>
 <Z4TdaxQwMuA7NM5g@yzhao56-desk.sh.intel.com>
 <Z4U13s_TeP3jAedh@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z4U13s_TeP3jAedh@google.com>
X-ClientProxiedBy: SG2PR02CA0113.apcprd02.prod.outlook.com
 (2603:1096:4:92::29) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB5010:EE_
X-MS-Office365-Filtering-Correlation-Id: eeaf78b5-6fad-44cd-121d-08dd346d4b28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+i+LtX9POK9qN64dQRgSA6I1++K6DHDv6Wp+8MHDP+VRXw70hzXALX2IinmT?=
 =?us-ascii?Q?SnMPB6F9ANdNWWftzBx90U+ZOYyWCXjvG0dKJO0CMq1ZpX1k/lUI+8oX+IM3?=
 =?us-ascii?Q?aGw52X/3Q6eBCNnMOaCF5I0d/QwIrks/ErhHgjCHEE5KuxceU5t2+Ysll3Mi?=
 =?us-ascii?Q?+Dcf/sd0HLnjANu2MjUbSYRBUCDSGEECDbpRbi6UueJ5VauNwyqR+Z5KamXb?=
 =?us-ascii?Q?19pMR27milWNjyb9rQVQmPWuufRdalk9FADH+crb41tLUE+SHFPmgWcYNwyn?=
 =?us-ascii?Q?lKaxc3JPamlFkWoU4n/e1IRflePzvQ+mTMdv+BjfYyWF2Yh2ny1POvuTj9BO?=
 =?us-ascii?Q?+YBY28IOp8BAryspj1O3kBndNvHaT3BG7KKtPnmXyIMSvTcY5h4ojjZW7Xov?=
 =?us-ascii?Q?9ETBr7dg/vLL4e9k9Fa9pD59FMeVFia8DXvS104lVfS1hJXHyZcniocWQ6oH?=
 =?us-ascii?Q?0hl6zi7j/PuWeMS947Cvpcjr/1NSqhFtXO/gRqUgcvvUzh7gceJ2GJta3dY7?=
 =?us-ascii?Q?9L7wmXSudQHqJwALJQ8u1iigS2SKZUWCZpKCG+zF1EvdUf1QyPqAys6z2WMd?=
 =?us-ascii?Q?yKftZqcWt0rC0Ej5h94npFfJ7Ie7888Ex5CcZ1RDu749jDuxZVKrtayg1ozZ?=
 =?us-ascii?Q?23NyR/JMUw44Dntr7zm4xz4A+CobMBdhZzmWJfOC4JkTbjOXSmWaj25tyYtb?=
 =?us-ascii?Q?GsINVCKynsrFvY16n8gjORkHmqIyPsMNtpbXulhUnXDWDssoEVx2yDnrpI9d?=
 =?us-ascii?Q?/nGrJd7R3yKjpDpDO4KPscEdTGmX83cyxroZUkqUlsgS79d5IE6bLPxqpbg7?=
 =?us-ascii?Q?LRC1ITjYn42gIkViG+nPW3quKXeihN4/Wplbwc++h5MF5wrhCJxw/oeLx0nS?=
 =?us-ascii?Q?NINYftJUlaZLYae1Ub5oWVmM5QwR9dUVBV7xtDfJPwPgEuMhTmiB4PAbJcIt?=
 =?us-ascii?Q?ahTNGetanb45QNEUCc52YhxHXfP6HP4EDuU1tD93vfVUhbmbPq2LhrJzSzS7?=
 =?us-ascii?Q?lKRKIrErI12X9YAy/1+WJrb1sLY6gnfIrRF1+L1lJ+ZlREwFSix8tu6rjetC?=
 =?us-ascii?Q?Ar3ghuPCupcmaSURcMLklxpy5l9cTRWf4VpaY80EKU3hY8RlBsfeqrcRZOv5?=
 =?us-ascii?Q?3UNLU81wq/Um92396T21rg3UXZHgVaAczOH8UXT7MA/2ubbExcpClmlMFKLx?=
 =?us-ascii?Q?H20fCb8u5oUL13l0+J6GvLtRH386P6C80XjiKKmkEZ5Ra+gI873wdwFuwSWs?=
 =?us-ascii?Q?0FEN3/nQwVFyy6mSkxWh2ujJsELRMzkx8XGSROIBwhbPNLDl3lIjN00o6E/b?=
 =?us-ascii?Q?ZRF4bFVK5MdYnTKB1cKXA0Ay3JgX3esZVhgM6LrmoqsmqrmwkivX1VEI0WBj?=
 =?us-ascii?Q?b8lu8oSA5BsCaCbiDUwR8/8pthqm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ssvL9p6s3c0sSvcOqI4Xt79VmTpg7XuwgM+csHPD7GFM8MO1wQrhW+ACt8r8?=
 =?us-ascii?Q?d6y6i8wYecl0CRzob+HXAmJLcmFWvAheki7AZin7HUJO00yb/wFlIEp2txkJ?=
 =?us-ascii?Q?oIyM4dDp3/5IWPzLFq5O3S6/kIhVPQ3fovPras/rG9FoyBnzGUBfnw5Yetaf?=
 =?us-ascii?Q?TUlbrlSLUKXPx47hsab9WFuPvZcnkD0I2NXCIo4jmBvUePme29XeoDEFlXN4?=
 =?us-ascii?Q?oXfhIHMayi7FXbKPpJvAzN0HtgOT9/laDcZbLuc9swA3CQXPeyL0jhMbmmis?=
 =?us-ascii?Q?6LXGLjIxqBY9ky5zm/SNlZNPc6IdPCKN/mRnFgzNgZppXhKowhmxXdAgyMhC?=
 =?us-ascii?Q?dfKiMPrkz2a7BwVuFZ39c7kJG869XX1NDO0YYBG1BtI9HWDESUT358dZmIUx?=
 =?us-ascii?Q?iGGnG9sXoOfi0Bi8U98bsMFO36s+Z5bENVaN+8MSQx7Z+E9kfCjJvPU7+JdW?=
 =?us-ascii?Q?8+pjGTeX/LiLctXnWQnYNYb+qjsnBsHmcMuy4Ub00zhW3Uak3BmE1m0HJ9kc?=
 =?us-ascii?Q?tUqpUQwUtJ4m28PFf58lyu/TEraND22WRrd7dB/Fz/QY7+42aWmrtOs/tu+F?=
 =?us-ascii?Q?oN6wONqLcqSl5FYbUQ5rVcmFy6JuIkvvCRPL5wuSS01mWIzi6eQI8xOic/HA?=
 =?us-ascii?Q?PGx+TMryXQb30VxszyswIkWrRov4RcbMfAX52Ca+lS9SN5nmEve1AAP6bjHZ?=
 =?us-ascii?Q?8jtU93eubWWxDvunpP882TnfA+GBDSNiSC888eUijdnq72IZngkkBg8C7lp8?=
 =?us-ascii?Q?F/jfk2kogEylboJAQoet4rRrxRSINbI/AMAg/pvjYtTVd1fHD0c/JkVx2kyv?=
 =?us-ascii?Q?uxlbudLFZlUUM0UL0wUP66I94iaNWqokzfou4WOJvuLofeJMbwBPiR9qIVA8?=
 =?us-ascii?Q?0GmJq3B9k1UGh27LFw8/x38UPs49PsKJdB6R+5lt8Ly+pFP3A7+Y1zKMTvQk?=
 =?us-ascii?Q?s+suhxDo3+wuB2vIGgmFa4zQf4tAEb4M/L0MHQo1t1MsIHRi0v/kSJiQGhJB?=
 =?us-ascii?Q?24QTtqzUE+fQ/icj32yIb6shY9mej668TgXy5Rl3i3SksEQdq78V00AsDID1?=
 =?us-ascii?Q?RB/lJk54guqz9VA9muHJG630QCavwIbQkX5Ivn7wxcLxfOBkJMe5bNMJ3ldV?=
 =?us-ascii?Q?FLYnJOwn8Y0EDZ74vjqOm9dPzFp4BNm3myQ3SuaKCrbmjcVUTqTAtr2Z5aXH?=
 =?us-ascii?Q?0qPGpY+6uH4Zv9AIsn683epftxWp4CRhmqFLrrU9D37RrwYyGDkFOjrnSKn1?=
 =?us-ascii?Q?sxbPoHuQve0KBVt2mZNC2goiqqPmnAymVVWhvoUEZ3EZjYdEB/0n//u4Vc2u?=
 =?us-ascii?Q?QkBJFXex3GLLarL8j/lEVxQRDFHD+sRc5Fr6jqZVEZMz/0Cl5jrKMBGDMUj0?=
 =?us-ascii?Q?syn8vK11s8pE66DapToo5fNSY+ACEkxE46y1+o1lidBLh/3l5r2J2hqUKGQa?=
 =?us-ascii?Q?fhvH1kCqhSGQqObZ+LDYa1ZSMjtitMpw9Rhq/ZUKjpM21XYQpp9jZ5m1Exby?=
 =?us-ascii?Q?f/0j6TuIiWN+y1XJrMsIGw7IlxGM/AD1U1HWvmcFQEYT9tSoUkMxO74vvGMm?=
 =?us-ascii?Q?C/rKV5XWaiENADBq9P8MFZQhuxeuY2KU+gqeuJpb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eeaf78b5-6fad-44cd-121d-08dd346d4b28
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2025 07:30:17.4415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QphRbZkw35nyRYgqb6J8q6IP6dmispilP4RgTZJFlauWkPAXZ0nnYEfy9jnUZE+bQvKaGVPa140J/UX3eFdoDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5010
X-OriginatorOrg: intel.com

On Mon, Jan 13, 2025 at 07:48:46AM -0800, Sean Christopherson wrote:
> On Mon, Jan 13, 2025, Yan Zhao wrote:
> > On Fri, Jan 10, 2025 at 05:04:06PM -0800, Sean Christopherson wrote:
> > > Abort a dirty ring reset if the current task has a pending signal, as the
> > > hard limit of INT_MAX entries doesn't ensure KVM will respond to a signal
> > > in a timely fashion.
> > > 
> > > Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  virt/kvm/dirty_ring.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> > > index 2faf894dec5a..a81ad17d5eef 100644
> > > --- a/virt/kvm/dirty_ring.c
> > > +++ b/virt/kvm/dirty_ring.c
> > > @@ -117,6 +117,9 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> > >  	cur_slot = cur_offset = mask = 0;
> > >  
> > >  	while (likely((*nr_entries_reset) < INT_MAX)) {
> > > +		if (signal_pending(current))
> > > +			return -EINTR;
> > Will it break the userspace when a signal is pending? e.g. QEMU might report an
> > error like
> > "kvm_dirty_ring_reap_locked: Assertion `ret == total' failed".
> 
> Ugh.  In theory, yes.  In practice, I hope not?  If it's a potential problem for
> QEMU, the only idea have is to only react to fatal signals by default, and then
> let userspace opt-in to reacting to non-fatal signals.
So, what about just fatal_signal_pending() as in other ioctls in kernel?

if (fatal_signal_pending(current))
	return -EINTR;

> 
> > 
> > >  		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> > >  
> > >  		if (!kvm_dirty_gfn_harvested(entry))
> > > -- 
> > > 2.47.1.613.gc27f4b7a9f-goog
> > > 
> 

