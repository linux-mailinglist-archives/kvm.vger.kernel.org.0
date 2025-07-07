Return-Path: <kvm+bounces-51658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C604AFACD7
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 09:15:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0211818900F8
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 07:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BC5D27A133;
	Mon,  7 Jul 2025 07:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QI/ydmho"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DB911CA9;
	Mon,  7 Jul 2025 07:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751872526; cv=fail; b=Y24spwPmvRixtpECGGDCfWrk3HU/WMsQwTUcstyF6OfpByaLfYnf1av+TpIIXHgyxMW81SN/IO3Cg5BrGawNrCwmgxkD7caJ5FdoCWOhggGMKAC52JY+ZKqhGx/7V3k+/tljhFziK2ZVZNsVY6QHldiHOJlbEqSmKmseivxkOg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751872526; c=relaxed/simple;
	bh=neX6IecG1xx1uY7esJE4aVdumd/wivfZC5GGX7oZLi8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=M16RsdriN+niSklSonAoFshpJVF4rqV/jW++wLfzfgd89khDFM6SF0coZzRDBa7h9lfcul1jppF1PszBEwqWc7y5SVRr69arTuDFjmYwFIo/wFBXMMki4KBpGvqn/hxjTwz1K+3KQcDNlqJf2E2sawzJs6KNa6oRlmXhD63ubCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QI/ydmho; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751872525; x=1783408525;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=neX6IecG1xx1uY7esJE4aVdumd/wivfZC5GGX7oZLi8=;
  b=QI/ydmhojPWgpzuJWKIj52E4vKUAqPPcFWwpoy0DJcNQRI9ZGyo2JSCu
   duQnpfPduALsCIn0VJcj0WWeT3Ayo0hfYWx2pXX699NMugD8fqR61xjIS
   MiEUOFOm9b+H/ijMsqWumzPS6zhUNbhTw+ca2YtFtmrsDOg9mBhJjQ6vs
   aqlz2cQo8zj3UU6EqLXe5Bhwl5tORgXc8J+fj5H7jYSjaY+8nGMLbrPI1
   babtJXKWPpuQqD8pImA0gnRPshreomFQml5YWpTmNuIl2WtnQlyj2AXSb
   6zJ03BfgwzsMuTwNwv+zW8xRzyLvxCG4d6NrUCi2dSoKs49xUn2FMMVw0
   A==;
X-CSE-ConnectionGUID: pfWxlq4jRfah80y6kSJSLA==
X-CSE-MsgGUID: PEqcr0+vQUuRuG9sMYmtxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11486"; a="64676516"
X-IronPort-AV: E=Sophos;i="6.16,293,1744095600"; 
   d="scan'208";a="64676516"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 00:15:24 -0700
X-CSE-ConnectionGUID: iA1wBmPRSIigW0XObL47QA==
X-CSE-MsgGUID: VeHOo4HjR2O3nZ9rfEnZgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,293,1744095600"; 
   d="scan'208";a="154563066"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 00:15:23 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 00:15:23 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 7 Jul 2025 00:15:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.70)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 00:15:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nDpCCIRd+lhWC6WDqDPbD/4BWianF1Obwe2toYM8R50sMzU3ET7liTVz0jTABY2CAhyC5keWvt6AckZcNVIi+FbWCIoSUtaTEWdusOxgTQHMWdaXaph9Ihe5Uo4kq6gNPgdlmTZCgQqRucu1PoEZZKpPo61YJWDLa1NgcCkjQEAkbtbs33E0FIVe0zlwZXiDilCu9JDnnA7Aj2vo4WaZYae1zRR1oRD2OPH59iyFBwQ/9TiKYFYBlOLmdcWNYqzMETqdIAVBZ79VbHNmv5Ekhx28wJnySlFaevyiK8VTFzTjh7ssQOjss3TrpxthZStONTSn/nIMQN7YeHgCw45ImQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V5YX5+7f/TUH7SWMVaLuY7Orp1qJ2KQsG6y9Hk51EJY=;
 b=EKx9sT7iJD49v3BfXeQrUMrG12lRU3qTbu1xrTE/ScvNMxqHeeybvGjXGJJomwQ+Jr02NCRW//2xy2KUut5xdDK6q7qUGYjdv+DJ7Wx3eoXXClKFI0c4mI6czfJgtUPdfEBOBO6vKd+VcCChQHsxwjPUbCRZeF4GZtB5jNC5cMtbMy34Gi+xJkDFqHg8FZmLoQc49tiHkXXMlU1UAeHOvD65y1DFGgYYdOYs88rM2azyBpqjWHTwMNbrMJuiB8wX1a41Cq9AX49QOWD2Bz4QDrVdFVTqDJqRkwomcgczxtP8inNKOdICYvNaMCySjzBzaxlkwOGONFS00qUTAczdGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB7027.namprd11.prod.outlook.com (2603:10b6:510:20a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Mon, 7 Jul
 2025 07:15:13 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8835.025; Mon, 7 Jul 2025
 07:15:13 +0000
Date: Mon, 7 Jul 2025 15:15:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Adrian Hunter <adrian.hunter@intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vannapurve@google.com>, Tony Luck <tony.luck@intel.com>, Borislav Petkov
	<bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, <x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>
Subject: Re: [PATCH V2 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
Message-ID: <aGtz9KfszwNKBrZb@intel.com>
References: <20250703153712.155600-1-adrian.hunter@intel.com>
 <20250703153712.155600-3-adrian.hunter@intel.com>
 <aGs7/C0W58nEUVNk@intel.com>
 <ca275d32-c9fd-4f60-9cf4-cd88efc77d78@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ca275d32-c9fd-4f60-9cf4-cd88efc77d78@intel.com>
X-ClientProxiedBy: SG2PR06CA0188.apcprd06.prod.outlook.com (2603:1096:4:1::20)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB7027:EE_
X-MS-Office365-Filtering-Correlation-Id: d54770ff-51d4-4b86-8310-08ddbd2603fd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ko0rlZp1Rcpaogzk4UyfhSAO6Yd8RwR8KDcaUXACtqo0sk8XOa/ZZCgqc8bk?=
 =?us-ascii?Q?MF7vqHOasNkQGICOhWjrVTHrfsEkBwr46uv+jpdJ/DT4G7YIpKrDlsBP+4d7?=
 =?us-ascii?Q?1jID5NCjuWrhQCBtvcz88CX8dmjpMTckdgslfgmpBfn5bx2Au9yX+knKPA9+?=
 =?us-ascii?Q?ApEfrYVMxgQt4C7zA36Hk7JM7/dnK6VzeQmDtpq+mBDpZ4RrGzBEIH6EQnBh?=
 =?us-ascii?Q?jEDxKkwF5tY5UGGhGXHW7HaKX6smSSf4wtainvOK8rWy19C2ETG3x/jhtC5Y?=
 =?us-ascii?Q?Qlrf4wG/7tfvXz0Gw0fUA/hGavsjia3UxDc0UtoANI+SpG3+IpFtBNz4NqKb?=
 =?us-ascii?Q?Yhq3/FRjdbMwjduKA/OFp/D6Sd1v8udFAGBeV6bIkAmh6ZzYL6JHE4af81oE?=
 =?us-ascii?Q?UDwA//QqXsMZMOzpvQ1fe+S64+LlXCoQ3/n//ZjFRv2TmJCEOj5R7Bt80rDE?=
 =?us-ascii?Q?2e9A5kZ1J4fKCOD3anN995bEWQLlQGXRCzSxuGDosPK3UvOwrllKuAR75TLI?=
 =?us-ascii?Q?2OKX+ogGAAJ3rooOlqr4qdjyNKR08SZZ2WmWKJUGmvw+QPJkDMqWS0p1G+AZ?=
 =?us-ascii?Q?g7PdimfP2rPtUd2EEqZCqnT4vLDo+1+k9i1RlIZSzhk5610bB8xLHtCbAEtP?=
 =?us-ascii?Q?Y7nhCq4SgEWpYz5NeGZG1aG+gNKHQbQAUka/QSiiS8DvI3AFMZfUxcl3dS9s?=
 =?us-ascii?Q?gYlA50FOUouW0DqcRmF0XnjfePHVM2GmZUQ32353BddnN20jNhV/Nt6FTRAq?=
 =?us-ascii?Q?wAaEucXacAOkV5Dq62ebApGX8ozN1JhQ0Won82yB30Y8XZiWWmsxrUmprGZa?=
 =?us-ascii?Q?Aleq033k9pHzA5beJ45XRhAmZGdllk+oxr4K04N83RQ4zhMZBw1fBGov/cPG?=
 =?us-ascii?Q?2n9UaPvqAlgyhdOQzq64dgSOlsCDMr55szu1Qz0sZAYJRJw98sqYRzCJ1JxH?=
 =?us-ascii?Q?Q+gR1IMYWj7/YHSS2ekn3Tq7x/+Ms+3kpIK9vq014K+Jg/S4KUwl7I7cEkzP?=
 =?us-ascii?Q?qXfsk5dbNXZpyHFRIHM0s7K/+v5kCfyBTKwmV6l/NAKPkPoL2Lzzl/c3SU2C?=
 =?us-ascii?Q?JLzjca99e0Sp8LqsFVXTVBDSTKrKc4DpnlWQXzm2P+ufbzF/TETccU+KLFlM?=
 =?us-ascii?Q?5CGyY+cQT+FaRrdLJ6cMGnRSY0rwcH5iw/9aI64ld3xQQVvMJEjBgaG0vSMm?=
 =?us-ascii?Q?kMeXMOEDwlDn2K40yVIGAs5HMpekujEOZ3jts6iXIBxENNjR+EnyVTwboFR+?=
 =?us-ascii?Q?quAueTt0yAZRedWreloCzY6zni9go2dfSX1YiFORU8J8raJAFDeHnSsAPvuG?=
 =?us-ascii?Q?eCU0Jr4e6XjgfLMm8/FLVT4yotphh890uEBVFSwwMxwRqlNXd+bL+uyKYlRR?=
 =?us-ascii?Q?iTPdmbR2Naf2imllDJWE7bTlkymVvgHPtjvVrL4YGxAkg1Pmw2ctGaDBch42?=
 =?us-ascii?Q?dZE4M3ffLfs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zV/ToFiabCyhKxurhlplYGbfafaFN4iDrLLJI1sN2bnrJMRW4bDQQGGb+bCe?=
 =?us-ascii?Q?wIkq5TyoluIQuJubYNPPZHYAsL+SqkNatH3rzU7YvKrwOd3rRfcSeXVhutdY?=
 =?us-ascii?Q?o7pvWUzQHx2v4wNT7+TRRiTT+X1YxvJqEjAmAF0FZHj0GtRivPA6fUjxNknI?=
 =?us-ascii?Q?kii51U2GDiJr0wgkI8nZQ9QZVhVWoBYJy/ut+m9JE1NoY4mW7in4OHkZRuho?=
 =?us-ascii?Q?0Vd3Kfbi4FSzkQN8fgGwHaly43IzdSCkjf5CCwFR1kmsGnqUm6xn4PXN/THv?=
 =?us-ascii?Q?2TOrG5Ngq4ttf7B9voApbG3m79BofUQdza2TE4FOiI8Yt7i1yyvpRHmiIE1q?=
 =?us-ascii?Q?T+lgruLLHWza2S9YTQovJBHj8r3IIIxZnFcV2/vPjC1VdopPGos7pgQz/DEW?=
 =?us-ascii?Q?Hqdk9MAv2y8+C1WB5zCv22X0KywuvORceD3NoyP5YQehC/VfYp3n3KsmArj2?=
 =?us-ascii?Q?whBxXVdjsLIdDK9Z5m2ZxCCdPppYqG4xUIt4J8zYmFRyLsRJng1p0z2yeyp/?=
 =?us-ascii?Q?caFZyLDs6oxZcNe2o7zMPUtWRoROgg+r81wBluX80z0CkgG71lbTeNJYumPh?=
 =?us-ascii?Q?XNTx2X1jLtIk51rBTL1nnWCISRT9Iua4bfUUm+yzvIUnrvFSbAuZc/TDlKy+?=
 =?us-ascii?Q?+ZosXgFyJGHFA3jxZhrV8ll08P8LqvVCly1Luc9cvOmHO9MchFovjIah9Zfs?=
 =?us-ascii?Q?jYbaxVB1efc8sztfahXI1FctEYsgjmYzv+E/DTtyQIhLGt/NWwC1GqFEQv+7?=
 =?us-ascii?Q?Uv6PfEiOMtINnQDL6aureHoEv0DIC7j4DWnr+jRJ0uYMeR7CgZjb/2NHVtNO?=
 =?us-ascii?Q?6UNFZrtdIgui8eC3XDax4+7ih6R1JDIb303X6VXpz1xw9PPH75qcojq8HkKy?=
 =?us-ascii?Q?rqofDg3CC3hsZ3n0OvokAdJ/B4Ij7HFWzDdXv3ZVUpi+oRa20UAG3J0GVCcr?=
 =?us-ascii?Q?i5gGUTSjW9JHLqpAHKc7T41k4eqruk9FQoXkXNLm650RxiuHTgwogLqYBO7T?=
 =?us-ascii?Q?5P1RU9sHHePECH7C3mX/qIE1WYx6I8jAW8s1vBs/uBNsmZwNMYGzKJwWOEmf?=
 =?us-ascii?Q?w/zi8CtHH/JVJdzzZccMJVrY8QAatZFDNSlSHR3Et3bGPA+beSsd+/vibkZr?=
 =?us-ascii?Q?oYqQr5jvXztXwWM88eJjt68XLbiK2Gcrbot90q6M/w0bRoNP6TSavb6PVl2O?=
 =?us-ascii?Q?d4TJT6vxRRxw+pZr/6qUNmTm2307EaqnZwX5X1s0kfdujJRcIBo1AwNMZieF?=
 =?us-ascii?Q?NFGwOYKrUINg8p1S0e/B1x6Jg4dil0Eu2NC+dpLH5sZLUSk1KYIYB9qOMzS5?=
 =?us-ascii?Q?cfXV749qzGYJ/Cqyy6ZxMptKh7UnCrqcuQXdts9NSAzUquv0IM/mL5B/OXNV?=
 =?us-ascii?Q?Id4n8ncQaR0jAdgmlEeCiXsNyaQBmYhVx7PnqZqJ9L2Z+OKXpRgnRo/ontMj?=
 =?us-ascii?Q?JG9LA3LXjbzBevgH3Ofne2JZ3X/gSYJ9XTiyWtPvzN8Hn0m64ZsiOHqghBIF?=
 =?us-ascii?Q?wiCXD2SC9UWk8ZuvAsB/+TrJ7xr/LPufo83jKOqdt99Gx/reQHSNtc+ZYvnG?=
 =?us-ascii?Q?ciP7G3QqiVbwkV/3edgB8AF3cBtiDzYmXj43cXwZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d54770ff-51d4-4b86-8310-08ddbd2603fd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 07:15:13.2018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1byB8s6R1Rhu71jO0DZSpyZ3014Ql+3zLSeUE9iG/h4j89W08TFsI2Tuj+8ktGu1QCOuc9+oHS0uPnBzyNsd4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7027
X-OriginatorOrg: intel.com

On Sun, Jul 06, 2025 at 09:23:05PM -0700, Dave Hansen wrote:
>On 7/6/25 20:16, Chao Gao wrote:
>> Even on a CPU w/ SEAM_NR and w/o X86_BUG_TDX_PW_MCE, is there still a risk of
>> poisoned memory being returned to the host kernel? Since only poison
>> consumption causes #MCE, if a poisoned page is never consumed in SEAM non-root
>> mode, there will be no #MCE, and the mentioned commit won't mark the page as
>> poisoned.
>> 
>> A reclaimed poisoned page could be reused and potentially cause a kernel panic.
>> While WBINVD could help, we believe it's not worth it as it will slow down the
>> vast majority of cases. Is my understanding correct?
>
>How is this any different from any other kind of hardware poison?

I wasn't arguing that MOVDIR64B should be kept. I was highlighting the risk of
kernel panic on CPUs even without the partial write bug and guessing why it was
not worth fixing.

Regarding your question, the poison likely occurs due to software bugs rather
than hardware issues. And, as stated in the comment removed in patch 1, unlike
other hardware poison, this poison can be cleared using MOVDIR64B.

>
>Why should this specific kind of freeing (TDX private memory being freed
>back to the host) operation be different from any other kind of free?

To limit the impact of software bugs (e.g., TDX module bugs) to TDX guests
rather than affecting the entire kernel. Debugging a TDX module bug that
results in a #MCE in a random host context can be quite frustrating, right?
But, on the other hand, MOVDIR64B incurs a 40% slowdown when shutting down a
TD. So, It's a tradeoff between containing theoretical software bugs and
experiencing a 40% slowdown.

Personally, I also prefer to remove MOVDIR64B, but I also want to point out the
bug triage issue and the risk of kernel panic after removing MOVDIR64B.

