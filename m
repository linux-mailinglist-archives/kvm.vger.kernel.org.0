Return-Path: <kvm+bounces-43861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71869A97D22
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 05:07:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5F1F7AC5BE
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 03:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E602641FD;
	Wed, 23 Apr 2025 03:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AnenJOit"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E2945948;
	Wed, 23 Apr 2025 03:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745377619; cv=fail; b=HUPW63jdkHCDJZVELuZKMlh8Q42WEpHZKEzOlDoVj5cV/MA0DJscNqx9cWncANNO9UI8fiFBUliVOfM1PAgVE/jdirjzsooX/ue783bNOIG6PSv/Cnr05dzNDQXohO/XExePB5LA8NeS6SRJLwuZPyWFRfxZsDFHpqo3Fbg1e/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745377619; c=relaxed/simple;
	bh=9a4GjdUUDuJBv0IdBxjkUy5omGL2jWNhxevAAEyHNs8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jJTFxy5aAwu0Y4HtnoU6ZsbckTOopvRYF8dYJiO+K1kRfbL/iREh/Tc2RkC6L8xrw47HOaDZDi9Jb8of3qkMYtR8eveQEyxGLF1RNN22PDgAIPlcjbuFqyRfVMmFmCU9RKDWwlnqbj/Cofw9ol1bKWPz0YFMmeO6za61likyR6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AnenJOit; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745377617; x=1776913617;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9a4GjdUUDuJBv0IdBxjkUy5omGL2jWNhxevAAEyHNs8=;
  b=AnenJOit1CgG15u4raPhgrkqbALeyry/XH6r7B02nmwlO5iswQEDj82Q
   beAV0G7DBuVWY85JA72kW/8MlwvSTKJPUoKEu7QQtSDJ1J19Dr5Jeb0JQ
   KG5t6tz1FfUL9i5P6mpxgOyMKj+bjxhG3VE7z41bAj0mKtNlX8GmC9zD4
   MWysW9Zdii+TTvpxmE0wAfKjKgju4DLvWSnc2cCoZsjNI9rQdoiljcd+Y
   BZM0DmojNeRbKDL4HYtUbneupk55OVD7IpFK3gukHBKTKhmICxaZiY04k
   Wr98cJ6qwbOff30keYhlU80+NM6ZKqrOl2HYlpcCSDN/U61Nw3n1fogwW
   Q==;
X-CSE-ConnectionGUID: qBCOIIQfS2yX6XAtiRKUsg==
X-CSE-MsgGUID: 6pHcax5gRyanp9w/BznBEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="46657961"
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="46657961"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 20:06:56 -0700
X-CSE-ConnectionGUID: IN/Ix5XVQzWFSIrcjSeU1A==
X-CSE-MsgGUID: 1ON5tHjKSAWyLSQr6CLDeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="133066429"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 20:06:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 20:06:54 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 20:06:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 20:06:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kRkeNLTf2gWANXiVxZmDhXRdmwBpMYPReZ79mmQjfgXY5MuJgVQ1NUT1ugGOBeHWYtEXVPipSopHx+UATx2mWD48F5PfqsjgiWzhb/JIrVq6asIayAQj6wNn6YSo/MldvG8dFcyQ9f9gCDJdUn1rPxwVPi7+4BiQLAlDNjYP1EdTue2D0n6qrkhk7YG1diBo5PJhc5N/nXAQmyM2Vi69Q1u/Y8zGsLqVHSTKzaaBmotj/rIZYo+0Nn2XJ6l8SPMKQGRlUSRxs0rL/n0doWOX1r7nA9mHxt0G2Fyuw/JGkUoDjv0QdmqR3emUHngaOYFZq2b9Q15IC8t+LA8fPoROcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5kUdPHt5+CbvSpvQi5UVLqxTKvKwnrsm/sBdBrvRK1o=;
 b=jpf5qZz7ZSuMZWXoO58AMozi3ptH6pU2NqTWmhPrCDeX+Eb7wOdY6LR4TptSFiW3FHt0zHbEySJR+CHGc2lhltG7zgqXovPZKbXijTLouVkodxOUEITBB5y5TY/5BVjOlHl/sYaP6KKHWj6kJB6YrN6thU9DwaBtFLhgoH9t30gWp1P5MWRFBdmilwTNMYB8eKMW4COYmXCMNzX+w3Y/gCsBAXt11dnikDFnnAv1dreLEyj6lQYbNhOaXwcNEakmnf6pCR9Ly9p4tt3kcjJ5oPgE0VxfPvRW53z+Az4Ec2oILinvh5xt5CVZzyy97EiYu7q1/2HK+HZJ+xbn0u68CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL1PR11MB5223.namprd11.prod.outlook.com (2603:10b6:208:31a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.22; Wed, 23 Apr
 2025 03:06:52 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8655.033; Wed, 23 Apr 2025
 03:06:52 +0000
Date: Wed, 23 Apr 2025 11:06:42 +0800
From: Chao Gao <chao.gao@intel.com>
To: Jon Kohler <jon@nutanix.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Sergey Dyasli <sergey.dyasli@nutanix.com>
Subject: Re: [RFC PATCH 12/18] KVM: x86/mmu: Introduce shadow_ux_mask
Message-ID: <aAhZQh3FVq3TD7pJ@intel.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-13-jon@nutanix.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250313203702.575156-13-jon@nutanix.com>
X-ClientProxiedBy: SI2P153CA0026.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL1PR11MB5223:EE_
X-MS-Office365-Filtering-Correlation-Id: aa08dfc6-89f1-42f0-97e4-08dd8213e55c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?RrlDlox9NmZgQL0x/2NABilZwIWIKihyD04ovoa+d3U9JUjl8TQM/yQkCXEK?=
 =?us-ascii?Q?Sf2yZUDVJDRBhw2ajva87ASYNSMs2NdbbK0sUXiN4BVTQOh7KIWDaiRgX0tC?=
 =?us-ascii?Q?RaeaCFw43CQkQutMv6R1X9yy09ePtZZKujGBYtjeaQ8obiHSablY/NYiQ1Ae?=
 =?us-ascii?Q?alg6b/jRsOVu45boQ3pdPp8x0q7ucRI+yDNha9+z/78VdYf8ICNOfYWmotcR?=
 =?us-ascii?Q?hCRG066kRuVpw8rWFLVvuKCKYZxg3pV4d/Nv9/16Tv+rbZuPi+YKBdZ4SQns?=
 =?us-ascii?Q?bmdqBOsFamuEttJbx/wXDKYqpL2TRlrHZa9S0LGQ7tsBK9eRqFEc557zQ7h4?=
 =?us-ascii?Q?Wr6oYOPyEUYrJY8w/oIwgE9rbVtLKakvSaoTsw1YJOAfsImmUVTh7wqglIKB?=
 =?us-ascii?Q?EJUFpuWUBaAlGBzZ4Z6OE6Qg4HJjp/RoIpx9SPLpnXTzoownn4ZhlnhN5/9E?=
 =?us-ascii?Q?AIzJaPjlnL9PhjGFCkokaM/XtK02an6MMf00rYB2upXCu888PGPJUacQvbnO?=
 =?us-ascii?Q?bQLOZahP68eTHXfJ1uQv5A0Gp64lhkBiqNhSyTMH9kWBgxt3LwbI/xXGAfCG?=
 =?us-ascii?Q?NWSFHpuktAu8/QiABIFn5HaTxJGDajYYO4PBTRDPadhkFKkWu8LZWiB/dq/2?=
 =?us-ascii?Q?sFngpXV/nWmrTyWazOH22JE8LOegwHwg8EkPjYu/cFnWvjfWTnXqAJyRX2Kr?=
 =?us-ascii?Q?iTRbORtZ/MLzBa1DEoRc4HasjrMV5IUBEiqth0WgXqK2bLtIo1ITCwz8U/w/?=
 =?us-ascii?Q?g1bb2kXVGyslxRdTyOSqEB6xSAsq+J6RhMfJNq6KU9VovjrFAwbYM5s6PTnp?=
 =?us-ascii?Q?Q3uStiVK+q2fHNvnbcPuq0/i6bAqWB3muv1krtFMSzAQSOL3WqXBsJILYO0W?=
 =?us-ascii?Q?kNqGh049cdhw2Z5WPDnWZZsFa/jkR3h0DTX1elsAwIU2wdJr2BzeIw49E6eZ?=
 =?us-ascii?Q?fRskn4mcQssLq6i+G5Bi2pS3732z6s91NNEYVBDAIgdF6BT+sMYHoilZNdmN?=
 =?us-ascii?Q?YOF68+OzAhoIRmgNPtyC/lOioXaH3YfRwDY7vp+gf1u+/X+9mKfS8DJ43iyg?=
 =?us-ascii?Q?sMBXWDEjp9wlJ5vIDS4Os829GdY+H81tbnCk6cmFUv7x1R9sF9NrRcpJ5vYs?=
 =?us-ascii?Q?Qnv47xpQfW9cr4mqeOLXu4tWtE/Lc2/ChFVXJDENpnENgH4ivQclFHeWWS2n?=
 =?us-ascii?Q?QMjR2U7BAYpccSZVXEbHGWdeWWrIJzL0McULb3xpRpGuNjQYlEOFyNm5m5sH?=
 =?us-ascii?Q?d31kCEUwZYZygoi0/RgBMZ0RCV8CW2JEMWammL+h+qSv7oq3qst/5w6Hclsa?=
 =?us-ascii?Q?6KjylTnQoHYlpF6pkMPN+x1AT9uGjdF439JZ1ebHjA1p62gsht7DmQ8l0Gp8?=
 =?us-ascii?Q?MqEFswtb0HWs73y3cbtNq82fRj0VZGj6RQQ5t1lwz62t/nOdvg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VvNgqPd1rotzIAXySW/36/z1Vt2OdNprQXCCEaT2TbHtelDbJJJLBx59KVFx?=
 =?us-ascii?Q?WNgbT2z5tj1F8/1kjs1H6Tzsjs1Xx4+z9f2znnA7GQLi7kxsHT06dm5q6EfO?=
 =?us-ascii?Q?SKC83owFyR6dxfBKYokxU+HVGrV4b81ze9/cJ9Rcw8p5w3O7IoWKUgj9xTVN?=
 =?us-ascii?Q?OSo/2ryJ7F3NssLFgjZ+6h3NBVA9o1JX2DWMbGP5ivHZmXEhg3HdqA4Her0Q?=
 =?us-ascii?Q?sYvqlW78FYDWERNMptyYrhUz//JhnVnuzueu+BNvohjoTAw8BKet0yti+U+Q?=
 =?us-ascii?Q?ti9+OQdGpRAbo8Rf5Cdia3i5/ZOMwS/zuqjt3hiWge9ff95yoizihyRghQJj?=
 =?us-ascii?Q?avH0jNQLP+tIXfOhvdmwjsSuXIyZ13CMom0VyzBvNtaoSoi4FzEnofX6yYYv?=
 =?us-ascii?Q?VNJdrV+X0Myt7QzqE8Av6zq51t65Pkz5ynrOMPe/HM5nFeGVZm6WHCgujYRP?=
 =?us-ascii?Q?/3HaXv2RbJSfAkw3gv+gkqFfF1w7VZ/fc9SOXKQ5YT4LL1Viv745mKsSp+kj?=
 =?us-ascii?Q?68hh9oo4uXP6tqTTEbquVIwvHWoM7AEsAFuRM9zeHKKOdEhdFzZnRip1Dijl?=
 =?us-ascii?Q?oeRDnFRiumH6gl3qXK872nvhUy01+hAuR3+1HXaJL7tBqzIrtGISm8/P8nQG?=
 =?us-ascii?Q?ugv5974mXrmMhUH2mWtG851Bpf81OHkUlG8ymNJEY/k415YSm8w/YCYkzj36?=
 =?us-ascii?Q?T8blcLL47rYH48mG0QUZMUY7RsFEhX97Jvn2XOb7ZE5UvlExd8ZlS26r6dEW?=
 =?us-ascii?Q?ch2QjPJjV6hWIrRmaSl7lfHfBbk8mrEC9sDwhpWn+SJvLSgMh71k2jUcNWwb?=
 =?us-ascii?Q?zYUFxTHHUQvvRgHLqQSYhbl8GBKufH9QIZYEbv4woVKxLhERwMac9xSze7nE?=
 =?us-ascii?Q?Tvuiw4GKLAITtBUas5WYXCgTsOYi96t3B17GiGcwV2DUtXvzGj/YwSIm3xAt?=
 =?us-ascii?Q?KKpUbB8ASDkaVnSnd0gHMYB/kb7U5D/iY+dtfGNdaC2BQPx31zsVPUEVkpy8?=
 =?us-ascii?Q?Eq1h0DF75qMO0Fh/IHMaVPZOC+mni9W1RCKvuQ3MIhLnUSmCnA5S6HAjSgjs?=
 =?us-ascii?Q?a6lJDqyB/HD/+oPWm8jBYI0uPu8kOFkg6yb/eAZ32EtL9u6j42OYIf2TAoLe?=
 =?us-ascii?Q?OVSzFWcVdb9zayCJNAB++ojP4uVJdj4iLodfwUTfO5GPR7LoYlpvwMVVhq03?=
 =?us-ascii?Q?q9FPb8B7Xf4s/4scAya8Dg7xVUq4nYh1UW0E83jXLeBK7x9juA2jkQKaPj39?=
 =?us-ascii?Q?pJZ+3PVmt8BiKJ+RQro5lYEJ9dUoO4tgfoF4nsQGwoWliEoMq4/ow0q+JI+j?=
 =?us-ascii?Q?9cAa65Gm+2ug4PF1Lak2c8q5mgBN9bltOBgAi4WTLv8MGoDWnD/uYp2EoesK?=
 =?us-ascii?Q?Trq6bhyK0Ua4Kj1fZsR1LEFDgkpIe1+DcfExeVMVtA3ctu+KldopsaMCwR3A?=
 =?us-ascii?Q?4gJmNplxGex6vDQyubjxJAXWgSvX+eeAlSrlgnCBqGUdpNqDjczqETmf4Wiw?=
 =?us-ascii?Q?fOSVqOTNNXQaiNeGxikAddqV2DRvcGzcFw3jr4CPVGOgCE3qZw3lAOeVPx91?=
 =?us-ascii?Q?XY0RtHpUMaex794iLhEFkzCDod+n/W4LOEhsnu2u?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa08dfc6-89f1-42f0-97e4-08dd8213e55c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 03:06:52.2818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DC+v4NBu+HsaDJHB4AME/kpBBI8+5APvQBoddgF1t+u1/t8aAm6ASjcqy/Ew8ypXD0j+TtjAUCdT6fjUy/ezSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5223
X-OriginatorOrg: intel.com

>@@ -28,6 +28,7 @@ u64 __read_mostly shadow_host_writable_mask;
> u64 __read_mostly shadow_mmu_writable_mask;
> u64 __read_mostly shadow_nx_mask;
> u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
>+u64 __read_mostly shadow_ux_mask;
> u64 __read_mostly shadow_user_mask;
> u64 __read_mostly shadow_accessed_mask;
> u64 __read_mostly shadow_dirty_mask;
>@@ -313,8 +314,14 @@ u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
> 		 * the page executable as the NX hugepage mitigation no longer
> 		 * applies.
> 		 */
>-		if ((role.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled(kvm))
>+		if ((role.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled(kvm)) {

is it possible that role.access has ACC_USER_EXEC_MASK set but not ACC_EXEC_MASK?
if so, this condition should be:

		if ((role.access & (ACC_EXEC_MASK | ACC_USER_EXEC_MASK)) &&
		    is_nx_huge_page_enabled(kvm)) {

> 			child_spte = make_spte_executable(child_spte);
>+			// TODO: For LKML: switch to vcpu->arch.pt_guest_exec_control? up
>+			// for suggestions on how best to toggle this.
>+			if (enable_pt_guest_exec_control &&

If enable_pt_guest_exec_control is 0, then shadow_ux_mask will also be 0. i.e.,
this check isn't needed.

>+			    role.access & ACC_USER_EXEC_MASK)
>+				child_spte |= shadow_ux_mask;

MBEC can be tracked in the kvm_mmu_page_role, then you can do:

			if (role.mbec_enabled && role.access & ACC_USER_EXEC_MASK)
				child_spte |= shadow_ux_mask;

>+		}
> 	}
> 
> 	return child_spte;
>@@ -326,7 +333,7 @@ u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
> 	u64 spte = SPTE_MMU_PRESENT_MASK;
> 
> 	spte |= __pa(child_pt) | shadow_present_mask | PT_WRITABLE_MASK |
>-		shadow_user_mask | shadow_x_mask | shadow_me_value;
>+		shadow_user_mask | shadow_x_mask | shadow_ux_mask | shadow_me_value;
> 
> 	if (ad_disabled)
> 		spte |= SPTE_TDP_AD_DISABLED;
>@@ -420,7 +427,8 @@ void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask)
> }
> EXPORT_SYMBOL_GPL(kvm_mmu_set_me_spte_mask);
> 
>-void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
>+void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only,
>+			   bool has_guest_exec_ctrl)
> {
> 	shadow_user_mask	= VMX_EPT_READABLE_MASK;
> 	shadow_accessed_mask	= has_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull;
>@@ -428,8 +436,14 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
> 	shadow_nx_mask		= 0ull;
> 	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
> 	/* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
>+	// For LKML Review:
>+	// Do we need to modify shadow_present_mask in the MBEC case?
> 	shadow_present_mask	=
> 		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | VMX_EPT_SUPPRESS_VE_BIT;

No, the SDM requires that present EPT entries have the VMX_EPT_READABLE_MASK
set if execute only translation is not supported. (The VMX_EPT_SUPPRESS_VE_BIT
is for TDX).

MBEC does not change this requirement.

>+
>+	shadow_ux_mask		=
>+		has_guest_exec_ctrl ? VMX_EPT_USER_EXECUTABLE_MASK : 0ull;
>+
> 	/*
> 	 * EPT overrides the host MTRRs, and so KVM must program the desired
> 	 * memtype directly into the SPTEs.  Note, this mask is just the mask
>@@ -484,6 +498,7 @@ void kvm_mmu_reset_all_pte_masks(void)
> 	shadow_dirty_mask	= PT_DIRTY_MASK;
> 	shadow_nx_mask		= PT64_NX_MASK;
> 	shadow_x_mask		= 0;
>+	shadow_ux_mask		= 0;
> 	shadow_present_mask	= PT_PRESENT_MASK;
> 
> 	/*
>diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
>index d9e22133b6d0..dc2f0dc9c46e 100644
>--- a/arch/x86/kvm/mmu/spte.h
>+++ b/arch/x86/kvm/mmu/spte.h
>@@ -171,6 +171,7 @@ extern u64 __read_mostly shadow_mmu_writable_mask;
> extern u64 __read_mostly shadow_nx_mask;
> extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
> extern u64 __read_mostly shadow_user_mask;
>+extern u64 __read_mostly shadow_ux_mask;
> extern u64 __read_mostly shadow_accessed_mask;
> extern u64 __read_mostly shadow_dirty_mask;
> extern u64 __read_mostly shadow_mmio_value;
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 0aadfa924045..d16e3f170258 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -8544,7 +8544,8 @@ __init int vmx_hardware_setup(void)
> 
> 	if (enable_ept)
> 		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
>-				      cpu_has_vmx_ept_execute_only());
>+				      cpu_has_vmx_ept_execute_only(),
>+				      enable_pt_guest_exec_control);
> 
> 	/*
> 	 * Setup shadow_me_value/shadow_me_mask to include MKTME KeyID
>-- 
>2.43.0
>

