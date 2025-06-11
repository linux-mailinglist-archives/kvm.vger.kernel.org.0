Return-Path: <kvm+bounces-49074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30B37AD58C7
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:31:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 763287AC20B
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E475244678;
	Wed, 11 Jun 2025 14:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pro0Tm0F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090B518DF89;
	Wed, 11 Jun 2025 14:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749652238; cv=fail; b=spnB6c2Kq++Y78Thef77z6+YimYIcaa0QL6qd6732+0/F4n6n6ksWzz1w/Vi1ir3dKLbvy2u7slRI2L27iYLtXpTc8HY8H8NqW2PZV5NXwRDFNruUNLrF6Fv7HZ0kAS91yPj8W1MluvdceD/KgcSISTYMuVeS2NEL6bzfJMvcP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749652238; c=relaxed/simple;
	bh=tkn8zhAspJjLxwm0ZGQC06dSiJnsWsNCcqNF8Arjm/c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D6mLGS+Rs/x0cOlhMYsEjA7UmEoBnwwTjbeiFy14NfQTrWL2KD9T7d3Uw7Q/mFmlxXLhAVvMoZFZ22QilWHPjc9pUuoN26HNTo8erRSfTxpDwdSbiqPqkjf2Zr7B9hd0wM+JBewOkAHzuE+4tqrUF/sY7GoGDwJ2E2KtUovAiak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pro0Tm0F; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749652237; x=1781188237;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tkn8zhAspJjLxwm0ZGQC06dSiJnsWsNCcqNF8Arjm/c=;
  b=Pro0Tm0FINgb9Ex5ddZM8Poc08IeveR7MTcGpzU9/7zJwk/DMH3p+AR3
   aDrK+3hOwocVi+2ReRvkTlbD7I43bJQ0BCEvFZutYYI71H7W1USELH90y
   scKnoKtSXBOT95ciFPyjKWR4++hAqVPGe6yO5VJmshioxL/SwXZba6viY
   PtjMqkWc8cXq7b0EpOTart4mZynOfHKzGzvTX3qkg5HGWQ4rnYEl08P9G
   X7mfrDYRko27cfxI1kB+csO3dLEES+cUvSp7xcNXxE6GqnBeV7TYWdl1X
   Fx4A+egZfk9MdE0RozcQV/qaHOxNVbmCl1BYkWdd3aufjiTm1tsJFH2hG
   Q==;
X-CSE-ConnectionGUID: siYFf0ZQR2O11Kapjek11Q==
X-CSE-MsgGUID: 07VRbsF4RtK2kdDCI2eHNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="62408896"
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="62408896"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:30:36 -0700
X-CSE-ConnectionGUID: wg4W2B83RmuOhlrNBi9OyA==
X-CSE-MsgGUID: 5wAcdUUmQ96WL1g57BKBrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="147094762"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:30:36 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 07:30:35 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 07:30:35 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.50)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 07:30:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Znb2uAg1Q7tuJ4D4BE1Y7axkzZrHqs6ChMtTVfLxE07t2SYq5b0DLr/urDiYYmE96WyClpZC4DXAJPvRii/l/oX6HPndtVGuOqBckomVreTcck1D/7RXtkZXOWkL+F5apSjAv5caKEctGEiKgf+XXpI6tYyDP0d5HFMWDp5u1YyUreebLEP2tHpmNZJAvAr/e4MuuLsm6DLVuOIXDalc1gDq+g6BPlU1CzM5Y9csydXHnBanMlGyIvunNdskLc61ZZxtF/xmaCaoUOpiAIe4UEyvTK3wk8acW2BDxXI1GESlvwaoj4RhLC/Urw0Y1pIX2CVF3Q2FZ4I4A6qKu/DOiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pE2hQ0xWLtgKLtRpks1Q4pzobmKj1YKeNfXBjDro2aw=;
 b=Af6TIrP3s1+lTr4a8b7iQEGmpueOft6hY8Z/mPgnDzbKQ4mvDOnJZHuC7FwSxKdI9TGil8xYwyc7qZ/EOUZxrYOwWrH6fh+Iy21MiQaMgJVOUdJJLvOP6lrTJd3c0SnP/zRgC+TvG17vmtd++G3HjpP/GIW95G+bRMPI+9VEcPfKXV4X7BJaLJ/VEyPWMbMGKDQb1ddJeScaGNOvSJoxERRSWb8wrj3RXStpwl4nKdiLvgpSux1Oa3ZzIhXxS0a59QcsIrdMPWcpeX1oKSqwg+yZyHecTidKY78IewsyXr1QL5NRuj/DUYAEbBpMXy7eBVGeYBSv3q2g+42Ct08dcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DM6PR11MB4530.namprd11.prod.outlook.com (2603:10b6:5:2a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.25; Wed, 11 Jun
 2025 14:30:24 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%3]) with mapi id 15.20.8835.018; Wed, 11 Jun 2025
 14:30:24 +0000
Date: Wed, 11 Jun 2025 15:30:16 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Mario Limonciello <superm1@kernel.org>
CC: <bhelgaas@google.com>, <alex.williamson@redhat.com>,
	<mario.limonciello@amd.com>, <rafael.j.wysocki@intel.com>,
	<huang.ying.caritas@gmail.com>, <stern@rowland.harvard.edu>,
	<linux-pci@vger.kernel.org>, <mike.ximing.chen@intel.com>,
	<ahsan.atta@intel.com>, <suman.kumar.chakraborty@intel.com>,
	<kvm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] PCI: Explicitly put devices into D0 when initializing
 - Bug report
Message-ID: <aEmS+OQL7IbjdwKs@gcabiddu-mobl.ger.corp.intel.com>
References: <aEl8J3kv6HAcAkUp@gcabiddu-mobl.ger.corp.intel.com>
 <56d0e247-8095-4793-a5a9-0b5cf2565b88@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <56d0e247-8095-4793-a5a9-0b5cf2565b88@kernel.org>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2PR04CA0009.eurprd04.prod.outlook.com
 (2603:10a6:10:3b::14) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DM6PR11MB4530:EE_
X-MS-Office365-Filtering-Correlation-Id: 65eb3fc0-c579-4fa1-237e-08dda8f480c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jQVCLV+grmds3HdYUcz2EDSTcd6I3eQ4uodXZioLMdWZ6FgYfwbLVWBC8r3w?=
 =?us-ascii?Q?N2/HBEN5AQ9tp5pWiarj0tNNqebEFUlTHbOx/UCLOTNMU35KSth71mFh1rIC?=
 =?us-ascii?Q?sHSuDKhARQO7tbUgrFaWmols2Sl5sPbz3+lcKOWrnH+EA2CTxc+m9sUbaEBY?=
 =?us-ascii?Q?h42dtyk0m/JWBOMciWIvg9pb0Xt0NPHTvVTq/cwyrZ430mDAGjUJQp8EM0AA?=
 =?us-ascii?Q?cmHUhhz3nJAX8bT2uHytXiCQRLc6Su2al9nLIUMQLrsXNaN7DxntwsDLmGKA?=
 =?us-ascii?Q?LaBc/nP+KSG0y8h1gy+QP+uQNzyW49eGReGp47oAXj8GVOn8htOR+NxAig37?=
 =?us-ascii?Q?K2cBmW6o0+eyHAS9bbZsmc66sIXrSiicn91IXM9yaKr7CQYJN+n0p5L9nYrd?=
 =?us-ascii?Q?dCqaM6+CuNjqABXBhKLtWk1rofw3QFRPECn+8FKUSooQOXJJQm3K4F4kr7UZ?=
 =?us-ascii?Q?gCvxElULYE5iALTxfSn9j8e5sYVryP6osA9rcfLhVzJit/5naWZiY2ewrBLP?=
 =?us-ascii?Q?ardd0PJ4lbMIiaZ6C0KJozZzdIM5tJdDHxV6CBXxWK8E6arRa4gdovWfFCFY?=
 =?us-ascii?Q?zLH4AHL4AuPW4rs4UGcVWk+HksVOTB+Go00GtL8ig1E+y5OXnilz3d1Q5PDt?=
 =?us-ascii?Q?FTwV2FKH5LOtyJDMb9KhnnMhoYV3ZsIPAwgvwnTHgM9tEzamb/xH9JrkNxdX?=
 =?us-ascii?Q?RvmEl31zv9l9fWJkeJqv4QxUCTFJu7pLmaX7DtYKy+EavCoasvpLPHFfl8/9?=
 =?us-ascii?Q?gM6C0w65oG1zySm53RiG8PT9d6yARnx+s0VRU4tmLE5eF4tTzNKmAiCly2Xc?=
 =?us-ascii?Q?p1e/VgxofMEjpNPj2GIOlp2OK1sRzeeJ/9cAdjgshcgtEH0AoHHe1HPIi3z+?=
 =?us-ascii?Q?7j3HL2NXuvKHkFHcJ4L9XAqWcxHlGRG0nP7DT4rF3Lrm8zLgfJ1udVv9iFCA?=
 =?us-ascii?Q?IPe8GB40dMxdpPh/jpBVJgv8BRtwtqZvEQCogFjETAxSpRxjHSnH0sB1BYNV?=
 =?us-ascii?Q?CrlfeJ8bri/Pz0mWAFBhwbpbXS0xMtqFj0Jari7eQawI12ve5AIWTEN10vmP?=
 =?us-ascii?Q?8crAjkfTG2PlO+x/diJ10q8Y1x3pL8s0BtxdhfVmaYUPIWwbXqx77tWqIk55?=
 =?us-ascii?Q?cnhe1gxtiFMoUkjSUQ0qnYKYimnxei2KterxhyLUSms+FP3QnsEt2/Rk/p5k?=
 =?us-ascii?Q?J/CSLmoP//hPc2Wk2TLa+4Pwc7fvveypGrNokpAcGXHw2FyEKOyjb1xFiC9o?=
 =?us-ascii?Q?qilADeLOTtitJqkYmR4hBQ/iqAn6JXPqhanhSUPI4T977MUQJk6Y2yFPf7vF?=
 =?us-ascii?Q?pKPUxsqeHveQOjdVbBroKaQbJrhJiO+G07J7qnuNljWxnmN+Yy7xjoLUK8NE?=
 =?us-ascii?Q?DdsHFjacrfDwBg2GzBTydKO9N7TiZVN1kgaKhVBF3JslbGZBvTWW5sBmL9b9?=
 =?us-ascii?Q?hIgv3PvX5Jc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1jWtnXKf0JuSfqYpU1TJxqDkucOMM27+StjQF2OlF4pf67PG/USENOd302L+?=
 =?us-ascii?Q?mYNmAo98+O/hqMu8NI7oyO/V1OvdeHdLkFFo0FHTHVkYOHBgTQtTT1WmN6wV?=
 =?us-ascii?Q?1nZFvSteH32CrLCmIq6QGR4jLMPy4XvUPlbgoe+6NTQItGhfNR+xhHB4hjqZ?=
 =?us-ascii?Q?YMmYUUEsB4xMvPfNDLeDYKlZLBEQNyYfn0kEDGypeC6wX8V24AQtdRVXym1P?=
 =?us-ascii?Q?8opiOEPWcXz8tlssaNy2t+NeihOXICa6MNxxO+60LUYY+48sR7dGGWk5Hkuo?=
 =?us-ascii?Q?AXebkhOFUWqjmxuJ/KqvvwpXSDpggdBg+iEB3aleAf7uFXKT/9EFH5MzGt7W?=
 =?us-ascii?Q?+HEAnRuxmCUAB/3fd70bLlkzgiHTR3Vx6g6PACcpXgWcQ6rt8qRo+nka3yBQ?=
 =?us-ascii?Q?VJ7SR1uTgWOj7/rmyPufRT1QMXtliSW4Vob4EHAa/eisvMSw2Ed1RZOt5jNa?=
 =?us-ascii?Q?zLnm0E1wAGEnsnhAZqa2o/aHpFHBr8umdENSzA69psGVD1FLmTG8cv1Jz15F?=
 =?us-ascii?Q?guzFxLHTbTRoSfDY+zJHLGlEfs2phMHPNsqNgBaw5vgWHCpUu+Kd4MZs5HYr?=
 =?us-ascii?Q?lIEClS3QgTkU/upye30H9WWk3sEoV5xELeYmY4wGHSDXDJMvK7tk0lSrrJx3?=
 =?us-ascii?Q?Kw65dCGb02ziETB2Aubv5S4XSpiGvNbwVAXrLFOBGslFFdmoByzpSpDo3NXb?=
 =?us-ascii?Q?9a8jPFhVu5Xo8VQU1BcJdq7V8uwJ7kU41KqHks7d/yf8gmRjuRlwm56S9dOZ?=
 =?us-ascii?Q?hy6c55jp0Ly6CZJZYEbX0RIXC08KMmCW5YTSMm/kihgrZHIPyivW1bKMLRch?=
 =?us-ascii?Q?4Y684sSO/3no77i2QCLvQT5PsnIoTmVyHaDH7QWxLpkp+6at2EINRYKbe5OT?=
 =?us-ascii?Q?H2Wkg6m8KnXCnI9heQwb5dPFs8Ul8s/89+YDl5O4/5cp1OLJyktxRjsRjAZ6?=
 =?us-ascii?Q?IGZa4kboHhRor2YF6bJirhqR2lcxCTmoJrfiN4cLdU1IX5fJBc9RtiWQjA9d?=
 =?us-ascii?Q?X8sQpiG/xS4GBWWTKakagr0+k0iMjV+kINdIIlIOrw/XcD1Cmff4Y2Q2R2w6?=
 =?us-ascii?Q?HvgMU1XVn2oJfuNRakQTNM4rpsKSn0I7Mp+KWj5lXii7YaRk4K+RrQBz/+eD?=
 =?us-ascii?Q?rWhAPqLSzI0t18wSSmBYqVyglfkCXMd7/et0z/3XKh0uGx0rlip5c5IvLn6Z?=
 =?us-ascii?Q?8Chg9RlMgn5mIIdoo/XjzDYchn9di8fB//CYp2AvOmsJ7y4vDqE1PKPmpKPs?=
 =?us-ascii?Q?n6giPWCGAID+zas4hhfLVereQMnvHSET+8yOFvej5UouZxiPjTbwaW5E4fZK?=
 =?us-ascii?Q?rFE90Qif2TUidFMwSr2tfFMA+aVoFCWF4tVGyX/WWb8JdQmaN+GxWbJ3+B6g?=
 =?us-ascii?Q?QZSS3sqwWBZtal9ea771dhV/Y73umpF5H7x+p/YlWtar6LEC9wULoXdU0/6s?=
 =?us-ascii?Q?mWRx18fu+E3xkwy/T5QdJByScghtHPfB3sZ4JFvi5N3pCmhgfGovp1LmtQHF?=
 =?us-ascii?Q?O1PetbNIZlWciBNF/COdCX4fjCChd5VJbH/nt5+4+IMD+1vCfouRivx0ReJI?=
 =?us-ascii?Q?6G7jxq4+fgJ6AQNk/Y7T67Q58iE1ior9MMcHTR632aJ6pPXGoAuKZeL4D4eZ?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 65eb3fc0-c579-4fa1-237e-08dda8f480c9
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 14:30:24.3913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DrtsA7kXIu8x1oJU9kV4zitCZ3vTBSB1TaoWt/0cQNqH9znh8yOUmum6BRcqy63k4deFdUd2QuN3/yoaZ9U7RMGHL9nOJj1g0EgnZ0qu/kc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4530
X-OriginatorOrg: intel.com

On Wed, Jun 11, 2025 at 06:50:59AM -0700, Mario Limonciello wrote:
> On 6/11/2025 5:52 AM, Cabiddu, Giovanni wrote:
> > Hi Mario, Bjorn and Alex,
> > 
> > On Wed, Apr 23, 2025 at 11:31:32PM -0500, Mario Limonciello wrote:
> > > From: Mario Limonciello <mario.limonciello@amd.com>
> > > 
> > > AMD BIOS team has root caused an issue that NVME storage failed to come
> > > back from suspend to a lack of a call to _REG when NVME device was probed.
> > > 
> > > commit 112a7f9c8edbf ("PCI/ACPI: Call _REG when transitioning D-states")
> > > added support for calling _REG when transitioning D-states, but this only
> > > works if the device actually "transitions" D-states.
> > > 
> > > commit 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI
> > > devices") added support for runtime PM on PCI devices, but never actually
> > > 'explicitly' sets the device to D0.
> > > 
> > > To make sure that devices are in D0 and that platform methods such as
> > > _REG are called, explicitly set all devices into D0 during initialization.
> > > 
> > > Fixes: 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI devices")
> > > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > > ---
> > Through a bisect, we identified that this patch, in v6.16-rc1,
> > introduces a regression on vfio-pci across all Intel QuickAssist (QAT)
> > devices. Specifically, the ioctl VFIO_GROUP_GET_DEVICE_FD call fails
> > with -EACCES.
> > 
> > Upon further investigation, the -EACCES appears to originate from the
> > rpm_resume() function, which is called by pm_runtime_resume_and_get()
> > within vfio_pci_core_enable(). Here is the exact call trace:
> > 
> >      drivers/base/power/runtime.c: rpm_resume()
> >      drivers/base/power/runtime.c: __pm_runtime_resume()
> >      include/linux/pm_runtime.h: pm_runtime_resume_and_get()
> >      drivers/vfio/pci/vfio_pci_core.c: vfio_pci_core_enable()
> >      drivers/vfio/pci/vfio_pci.c: vfio_pci_open_device()
> >      drivers/vfio/vfio_main.c: device->ops->open_device()
> >      drivers/vfio/vfio_main.c: vfio_df_device_first_open()
> >      drivers/vfio/vfio_main.c: vfio_df_open()
> >      drivers/vfio/group.c: vfio_df_group_open()
> >      drivers/vfio/group.c: vfio_device_open_file()
> >      drivers/vfio/group.c: vfio_group_ioctl_get_device_fd()
> >      drivers/vfio/group.c: vfio_group_fops_unl_ioctl(..., VFIO_GROUP_GET_DEVICE_FD, ...)
> > 
> > Is this a known issue that affects other devices? Is there any ongoing
> > discussion or fix in progress?
> > 
> > Thanks,
> > 
> 
> This is the first I've heard about an issue with that patch.
> 
> Does setting the VFIO parameter disable_idle_d3 help?

It does, ... a bit. With disable_idle_d3=1 the ioctl() is successful, but a
subsequent read on that file descriptor fails with -EIO.

    ioctl(5, VFIO_GROUP_GET_DEVICE_FD, 0x7ffd2b38abf0) = 6
    pread64(6, 0x7ffd2b38ab06, 2, 7696581394436) = -1 EIO (Input/output error)

> 
> If so; this feels like an imbalance of runtime PM calls in the VFIO stack
> that this patch exposed.
> 
> Alex, any ideas?
> 

Regards,

-- 
Giovanni

