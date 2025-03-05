Return-Path: <kvm+bounces-40123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 870BBA4F552
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 04:23:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD3233A8FC5
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 03:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFDA71624F1;
	Wed,  5 Mar 2025 03:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KrJRjFXt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD624A95C;
	Wed,  5 Mar 2025 03:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741145005; cv=fail; b=Ihgtu05zPAAFOeUgiQGvU0+j1l7NfpvqyxRovDZ8TEaNxdGXylwvstK11YEdUGnH4EX4vl2O34u+qgY4+wxY7mi/zmoS0Lvcbez5IgPjsoeoJDbJFPLxUY+UfMy9BBX8mJ1o+IbLHAbkLgmKNPbHadOsKlmPUfNRWqXqpRFk1No=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741145005; c=relaxed/simple;
	bh=8+G+7pP8/d3E4F2rruzRuU5/cp0T62P3n5ndX7BqwYk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kTRty7RHyeo9ZwQ4hiN1E1GPOnBeBpUmlcRUII5iUEspX07vmfGuw50GLMHhUk1xcnFVG5bxPtQaBu1ocf3sF/jUKxmLmM2XjwoZYRksQk+6sWFpkyXLkPyf9MaJbaJl0a+2lx7poQkaUGn1GAx/zyaqJsVg1VAbVg5FZaBmTNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KrJRjFXt; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741145004; x=1772681004;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=8+G+7pP8/d3E4F2rruzRuU5/cp0T62P3n5ndX7BqwYk=;
  b=KrJRjFXtQHNaKwjGQNts5esVy2M1fg833PZUO63tZK1WLjVPijS82PfF
   pjtHWvBe5BEqZfk0hOQrHtq8mMaodQ1hfcZlYOLr8n1DS/2LB6B0izNOi
   fYp9EMiwjiPrDjIg+SlsvyQvZ5/aQ7O6p9z0Ki1eSGbMYU79fTmPcfVqQ
   vSrcGQGkr6nzyqHQ+JOUsUOSU5QP7tFNXEfeijrPt8jmO0oFMNNfFi0MM
   pWfyRd23mWe+37jI2dcwXEciXgQesNtjaA0BwQXFrsW3H/p9Q3D35qrWI
   7aBeRl6e2ujPFG+sAuzc1kXIaJHwtu3axKVWBnHKi+dqqA9L6nH1YOlQP
   Q==;
X-CSE-ConnectionGUID: o4Z6UywsTBCl2SkDhG2AJA==
X-CSE-MsgGUID: Cjz3py6hRZWfT1p7utmmdQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="67459579"
X-IronPort-AV: E=Sophos;i="6.14,221,1736841600"; 
   d="scan'208";a="67459579"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 19:22:40 -0800
X-CSE-ConnectionGUID: vHnxS9iaSOSvtnT+DK/f5g==
X-CSE-MsgGUID: L0MZ60D5Q4ODPHjmZho5iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119069587"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Mar 2025 19:22:31 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 4 Mar 2025 19:22:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 4 Mar 2025 19:22:29 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 4 Mar 2025 19:22:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GBBkjOlbhPhvzdzDy7qKfJCKvFjkdZfzePiYE95mUy/fhqe/ti004UUQY3bQ9G5iLcb6yBOkL3x/32G3QqWDcOaFyQpM+5bFo806i8XlEv5wY39w5u7OwnTLYkQsRa3dtcmmURmzG89ywiufbtBiWHXJutuY85nqiL7BrVvSm1mdFjgxqAsPaJ3HC4/SsB6QwRTcMC6MJQKC7wvzPdmluSN6IT0tHs51x9gFPTklgPgaYdSWIH4RCqyY1snylz4p3kXle0rvAY9Nm2+jjjD4JA0ESDtl3UDalEaQvhg7tCWJmkJBrZws66i/jTEiy0H0harvr+mYrRRgWJw41LLPBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8iOHkN5ftkwMmZqxfXdRdH2S+NBxDsyOR4yXYAo8ueI=;
 b=L2DbKKX8M2xZM2waCJsLjSbJVCCHdSn3Tosw5L1+jL0qUFljNF9E4inOaWC1dH6c3k7aVKXBaqQCJKv68igqVIrR+dqPz56fYmL+jD6laqzmU8B/rWklprLWXJaAycSj15Zl4S7pJfxxkBXtC4WIetjo4djAJQ7Azuu/qsoG+1MzXUa2rkF0M6ECZO49P2D31euUCwAaXUHyM+W/F0xIZ4LHzkg7AN3/givqk7Snt8BDSmy/RcRd7Qb+4I1+rxlPBjNZzmABvxhhgBWiGjEQQAK8caQJBq0qH0RGkA+4Ab2YP0Rd7WRKcXibE2jF59WwdVJY7BvpsaOc+JDjxOWebA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB8599.namprd11.prod.outlook.com (2603:10b6:510:2ff::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.29; Wed, 5 Mar 2025 03:21:47 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 03:21:47 +0000
Date: Wed, 5 Mar 2025 11:20:25 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<xiaoyao.li@intel.com>, <seanjc@google.com>
Subject: Re: [PATCH v3 1/6] KVM: x86: do not allow re-enabling quirks
Message-ID: <Z8fC+T5xvUhBKYbZ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250304060647.2903469-1-pbonzini@redhat.com>
 <20250304060647.2903469-2-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250304060647.2903469-2-pbonzini@redhat.com>
X-ClientProxiedBy: SG2P153CA0050.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::19)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB8599:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b290202-d744-476c-0a1d-08dd5b94dcc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?U2NEuRPAVckCAgYKJIVB7KDaoATaWAepibNdp9Y8WmZZRtm+BUlAhNrxeZ7H?=
 =?us-ascii?Q?iX3lHYM6DzzkaDdcirh/Jg8sgOTHSGM3RCK04Do6o+yKEEwFEEkiW7e7TXWX?=
 =?us-ascii?Q?y2Vwe/4+VSTHrRGxLWRc6v0GhC4Lg7qBvenC/FE0yrX/PnhALEcaY2P9M2Ji?=
 =?us-ascii?Q?UbFP9UI3TktOOfOMgRziYTHvmL2wfq5kVe78M3Hcd0qLCP25AiBDkdE19Ki+?=
 =?us-ascii?Q?C4Uws7btVDrvGoHMW2pcpQUthEg47TBCPfPS3YiT1PmVGX19hxW+JuUh5Pyx?=
 =?us-ascii?Q?M8rHi1w0y5jgQutBNEhBXM1bKFENq6lVpp9RFQOxHYn8IiC58FVhhuo+CGDO?=
 =?us-ascii?Q?liC4Fc9i70K9L0aL3jScSDqpF9mt6+uG9ktG80E1e9uQFseAz4907FM/6C7X?=
 =?us-ascii?Q?JULvclECAnN4s/R2/DNQCRqoClGFjywNAcFwzUEww5IUlWYXWVvq7QIdxI0e?=
 =?us-ascii?Q?TssF7+5SG2Ew46sxPw1gLDQpBIr8S+qY+rRQviqReAX3st82Bysl5QmpEEQG?=
 =?us-ascii?Q?0u6bPZ/Mgh5wPS2fnTY9vjhC3vlmdlVogJ5oW6L1RERvCDczi4FWHY40EYxb?=
 =?us-ascii?Q?3n1o536ldYLsmmaoYkmwlNbeRzOP5XtITI4fwb2gbZQnvp7Qbu/64N4GjDqf?=
 =?us-ascii?Q?06JS9yfzSzpPYc47cSwloyj7DJty4Z7B0Vejp6MaSAxo/aK6BZIvvRhIOTgU?=
 =?us-ascii?Q?YAWRkHprPlcFQIh3N7Rf/4OAEksaERylc9yVt5ytEbmjyHZUbkfJw1WQSdZb?=
 =?us-ascii?Q?W05junvY3xWCNmg6XZ/P2RT0l8Gi5megxBXjwnhCTdlUUGkM8eHHVa9hw7aa?=
 =?us-ascii?Q?WVWF6jNaKd4rhGuUb1eyprsVBH0xaZtHQq8YnyURe1AfrNaOCQkP/yJUV3Jd?=
 =?us-ascii?Q?Q44iFhLRRt6G5jMNMo4bUeS3lW2utiybyYyrIVc+bM5a7F80Bt6Dfcb1PhWQ?=
 =?us-ascii?Q?v8CaIXouT1AXbra9zmOKi4x1fs1IsA7PP8BM0k8C1d+NoE0ytWf0CMgkUcKJ?=
 =?us-ascii?Q?UheHFSkXaEgEDDBFy49NoTF5JOjlyl+F0aasFOKAAMzbeNepVs8rbc5xsPSD?=
 =?us-ascii?Q?ood8S7o9IQ3lAU9yabIjVtWT6TU3iEHvfU6jjJ0JBOWpWCe5LQr/V4tYJfyO?=
 =?us-ascii?Q?rysj7DpAw0jVEF++cgkjKhlVtSEmHv+0k3qEHuLUNlLl4lhW61g0+QDxMXyb?=
 =?us-ascii?Q?62BMVvxRkDEyiKsWSR/UfK6xnCAjCjkF60nuqkhhya2PbVcr7DmCa0AeAq12?=
 =?us-ascii?Q?4ptX62wVATh91L6aKJMe7bfRUJd8DlDCso67d50nUoXvufvjHkEQHv1aUuE+?=
 =?us-ascii?Q?5GjaTPWzX1WzC821VcAMQ2BpmMP/uhVAz8VZmmaJjStBcf5Tp5vZDTRR4W7n?=
 =?us-ascii?Q?zDVT6r9yvvM+JAEfZSqdNUtr55x/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t9tccI/b5qXj6UZEJw5efwnQcrnQoo5rzFPA7eBXVeWtsWYkmDsrqA6dXFZQ?=
 =?us-ascii?Q?30QnJCTl8wRoTLzK5USVMbisNc3pm4RjvgeLuoVj3y+EHRSLOFBxipftrRrq?=
 =?us-ascii?Q?7Ht3jfCFAPZTKvs7VebiDAeK7KxeWzdo0f31N1OlnWNzwVjaLOpXmF3Mq7sK?=
 =?us-ascii?Q?UdsZrTnplG1E70o7nYUTfTnY8WGQZZrhPPtSXPvCcpn/URTT/ADwd00CnXV3?=
 =?us-ascii?Q?hEj/X7jKGArkyhvcjD88kT8UssBkSJegGCwq7DfdXDicMhEgIjUoyQP5yhF4?=
 =?us-ascii?Q?6vUE6cuUbIk4vmmw7dn0R28VP4a+Y4bOPr2ndejKE1nUPfdhad0wmMjoKgII?=
 =?us-ascii?Q?ZpsXL956x1c4x0OJT4Z58lOMHZHtysTIpcD9LwGAhv+9k6P+XzYMwATie5Xb?=
 =?us-ascii?Q?xhz6cLKyc01OXsx5T8eFQor9ZVGb8RYGKu5+0vcbmculdchA6Ji/v1idfT1k?=
 =?us-ascii?Q?0/hF3Jlot/3zo81pjQa0XX9rDA1f4l6PAGsg7yLrfkw5CfWhJtu1C89ekB+l?=
 =?us-ascii?Q?78YsHIdwgjS4X872xYVpSbqnmkpCgwRnX3aHxOyyIt5uSPNe09U8i3KOy3X6?=
 =?us-ascii?Q?+R3uitONNpm4DfsiBiIIQKwawbHpYEwWdCL16OVu+RXBFgP/wcUsJyDmbtRR?=
 =?us-ascii?Q?XKyuAdfQvMbTCQsvHH48zYMb87pgCyN6ZNmAWPJcnyXduGafg15J+X5UDorT?=
 =?us-ascii?Q?MNGb07Lgq6hlXGnEvIOmOr1TOEiM4WinB3/4QqvjRbYqlIDaJAfaoueNeQrq?=
 =?us-ascii?Q?mVo9zzx5qSIU7j8+OMsjOKl9otPPnwDjDzRW47CxtHFsANvVXds79Qhzaw1V?=
 =?us-ascii?Q?xSy3OL0z+KUDX0DKJArQr6BA4HghzDh14qIILB645yADFeCjsWrAE2qma8IL?=
 =?us-ascii?Q?nRLmUaR9gDPcn7UtL0t3kzUiXqK5ohSDsh/YLhecsIp5Zfi8Ur/z5Uea4xt/?=
 =?us-ascii?Q?DzNV5jKmWwssS5lru9lGnq79LGiri0bAPT14x9EVur1yLUMRb+j6xvx1Ag1r?=
 =?us-ascii?Q?wA2vcmvguyYXSlWvzhMI3kAy9s/MYX46liFFxzVogaXa3wFc7TPwVx7QuPms?=
 =?us-ascii?Q?nQOf/BLZl376/si40zRdoQ2H3SBaxNgvY2SCMDz5cqEQSt3GoHqerpIH50Iq?=
 =?us-ascii?Q?oQ7S5YfcwuFPPtesrYlRktofYloIY/nj0SApaa9QX0h+1loGS4KUkn8p7NTJ?=
 =?us-ascii?Q?lfNu8lWBLKGfUcs0OrcBmjy0imE4zZgLfpTKJm8OXVfERhGPLGeARn1St8O8?=
 =?us-ascii?Q?CStKiUZwgwnZbu+N2T+fBbrh14LDgIGF33hLEcX2i5k20ydpYW6cnjnXl+BZ?=
 =?us-ascii?Q?NJY15pN930QNtlLyvgt0VQW/iwBicsh7zvn7hE5Ndtaolr6elfrPGNXRY7+z?=
 =?us-ascii?Q?6SA74soXUuN1ZJLAFQMTz8EkjsJIlSIH5xf2r7aMiQfzYGaLPhy0qiitqVhF?=
 =?us-ascii?Q?VkNSOgYpjWI6AAn4HFVDwe4H2WzBKkx57TbIi65JDMCL8FSngjKhmAMGfX4e?=
 =?us-ascii?Q?5mOs4WThFCjgZHRHzFHbQrD8esPng3FMzOQURfkwPB0eV0OEz1ZQHew/M76+?=
 =?us-ascii?Q?D6YFs1kJtWaeAQ3RRti7hke2aM5/VJgp4FcSo/ux?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b290202-d744-476c-0a1d-08dd5b94dcc5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 03:21:47.4595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hg8yoeXOklnVx4icX2W2NxLs6IU+xcHQ6E9i9xvXov2NZiYquu/GB96PS1e1xt6GllwqsU+fLJo/yFZg2hpAVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8599
X-OriginatorOrg: intel.com

LGTM.

On Tue, Mar 04, 2025 at 01:06:42AM -0500, Paolo Bonzini wrote:
> Allowing arbitrary re-enabling of quirks puts a limit on what the
> quirks themselves can do, since you cannot assume that the quirk
> prevents a particular state.  More important, it also prevents
> KVM from disabling a quirk at VM creation time, because userspace
> can always go back and re-enable that.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 856ceeb4fb35..35d03fcdb8e9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6525,7 +6525,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			break;
>  		fallthrough;
>  	case KVM_CAP_DISABLE_QUIRKS:
> -		kvm->arch.disabled_quirks = cap->args[0];
> +		kvm->arch.disabled_quirks |= cap->args[0];
>  		r = 0;
>  		break;
>  	case KVM_CAP_SPLIT_IRQCHIP: {
> -- 
> 2.43.5
> 
> 

