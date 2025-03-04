Return-Path: <kvm+bounces-39991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73FFAA4D609
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:18:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DB2A3A819A
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 08:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86EF01FBC99;
	Tue,  4 Mar 2025 08:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cmiB2SOY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B9F1F4E49;
	Tue,  4 Mar 2025 08:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741076285; cv=fail; b=MXyoBYQLp50PJKRWzvtvo3nIbjs35QyiKHpIZmFnT9QE6b8XfY+oHhIuvEqWcdNmAN672PY+QOcE2YoYiF/I/lSR3nuXoTXY2BAk1JGw9l3m27zQVmkLw/nTfrIS3CEw/uxgBhcGg5UqBLazmMXsRT0Nv61ec7evaiwy4EUa5vQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741076285; c=relaxed/simple;
	bh=Jrp7oMvdfkN0JOcCiwC119qjYptKH9ugIQw7pmLDShM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tYguSjt0xfjAKLsT6Ip5nTA8sEuYDZz+D9UPgD7MbfzVcwL5lSWspr0RGz2U0h25KIlbmD3rYICn0ginywLGDpsGiWR/2LphbbXApYzI8+76P3TXmnOrNNHwPFIQcPrnoo8QE7a4sazb1QONQFjEugd2nMZ3rddgS4GdWXDh3To=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cmiB2SOY; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741076285; x=1772612285;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Jrp7oMvdfkN0JOcCiwC119qjYptKH9ugIQw7pmLDShM=;
  b=cmiB2SOYvu25PZNAI+nZZiuAjI+hdy1LOKfedtiNjqAZ/iDai54u4Alf
   a3lvoqhl9nKkd5SCp/lgqmvHwLMYdMInca+e/JkvfQgbMlloDm7lTr0zD
   4khgRV+OX+1nBr5TRHasmiEpXZZ2a+rvWiGp/SsFneZEu/U9TOyXTjELR
   7um64vJP3Z9/5xS80ej+OA527jBMNCF/exvY0yMs4/rwMd2tueuShfjSq
   MNAKc1aVVi8ss1Pml/21vv4oyqvZA1BEovtvwZbma2QGxHUN6owLD5vRq
   9lowicNXi1O1R2nDf9+SwImaLRmAM4ajbbUSjIrnF8tYPGBAclWlTzdzt
   w==;
X-CSE-ConnectionGUID: QfpFaYdHT2mnEAzdCfl+CQ==
X-CSE-MsgGUID: UY/thGuPQYSzWd6SHCtL+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41891150"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="41891150"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 00:18:04 -0800
X-CSE-ConnectionGUID: Ale5KwWGTti90WlcM+6Cjw==
X-CSE-MsgGUID: rYe4yjQRR3+2BJuWEYZ88g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="123424359"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 00:18:03 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 4 Mar 2025 00:18:02 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 4 Mar 2025 00:18:01 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 4 Mar 2025 00:17:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AVHmjVrUV7O+bFHTjyV0mR7eE8mavKtVih3haVAfXyZWBFSzhClCy0K3XLdhgkQdk2Sp4TsbwY+5pODoGgln3pyqVYDt9SpUHQYX6/mr4bwQu1WCEjGCy6ewLdstDDdY41eZLauXlfzbg6F1tLZOxFijxKy/hE15KaAQRGFgWuTf2kOMqU20W1RpQdh/q7idgP7vcB9akj01qvzFfxr2GsLHSaa9GZtw8MagRsaH7VtgTlh2TnLlWP44zAq48FFMhEPUIl5Cb7huzauqxm1nbElSBGIo5ANQovB4B+NpbRqRaA9+6my45Zs61mLsV4E03vNGEFjADrKjqcbEHbHuVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fq0bOab84Avr9lR5dh1OwtnMu9N7DQGz8nVEznI5zBs=;
 b=K9GlgHq/fR46RQc+SfuQEFxmtHG4pWcQ1DDSV3b3FTYfx00+KI/xd1HveQmO8T5FR/s+vR0+ENHEFypoldt7SbyckCA1URsJJhHGNlW/wqZXWYyG58UtEWJ26L0jFrbXO/D6y4ro4MIGcLRlZ/2ye7uPBUwzE0/2Dcp4HEBmyyfJH9V4590vaHfIzLJXnvd6ZqlkQZ29TL5EpnB41WSbttWHvNSRbB/pRnO+602IxoXsnSzHDVVoBFbQ1SBE4EvVY8EpgUkdZmDgo7xf0Tvc9nOoGz1mIb7rcsQ+k3mEG0UyZFD79UtpS+/D95PAZ/7yxtWKcwI9v/+DPy99VSNRmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7438.namprd11.prod.outlook.com (2603:10b6:806:32b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Tue, 4 Mar
 2025 08:17:11 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8511.017; Tue, 4 Mar 2025
 08:17:10 +0000
Date: Tue, 4 Mar 2025 16:15:49 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<xiaoyao.li@intel.com>, <seanjc@google.com>
Subject: Re: [PATCH v3 2/6] KVM: x86: Allow vendor code to disable quirks
Message-ID: <Z8a2teWy+LevUKsb@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250304060647.2903469-1-pbonzini@redhat.com>
 <20250304060647.2903469-3-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250304060647.2903469-3-pbonzini@redhat.com>
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7438:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b65b135-93ee-4bd0-4cbe-08dd5af4f605
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hcNN+ekbrcw/Xaiaoa6vLDgO+Ofr0b3n1Bk1pjaKqF4HMlhCoTMREGXiIJ7+?=
 =?us-ascii?Q?oEBcWDrLbGC7jGbxGka1zv2CXgLkyE6YE9egKeNCHFigjiSX7pVRiBUyb9q6?=
 =?us-ascii?Q?Hwxsu78/hyqf8bfvhRHQWNi3KKQouJotXPyuvDis314LCz0kAAS4lpX/M+Xq?=
 =?us-ascii?Q?P2y7vOWZOBU3cLdSNe4SYm5pIu5/K7OwsdOEZFVlCec2LNWTMHINe2d2QvT4?=
 =?us-ascii?Q?uOH2GOGhM0fMcQNHG3Ia9DI1h/qCEOPzocfAG8cMQxWbpd+s/lg4Bt11MpVI?=
 =?us-ascii?Q?7X6MLOUVhnhmz0fpJJMKw/UWVgAu2YtJm9MY8Yp6Q0o4zKltVT0ouTxgOaZb?=
 =?us-ascii?Q?GPyCAidG5IWdbw0jvdIMGtVC62cX4hi2dUE/0uBR4ELx8ttUIFmW9AMGq9/1?=
 =?us-ascii?Q?f60hmq8vIjZ4vKZrq1LQ86eT2Hjrr5xs4InoJE4RmjjYx49b0mlQpK1SCqv4?=
 =?us-ascii?Q?78vE7blPwTkJBo/dLaA2z3k7o5XWwZcslqSU4wphmaxutEPhj8D2RzCqA1bK?=
 =?us-ascii?Q?YbUeNOpY9T/WD8aIB+niZd5TWPpzW9o8UuhhXajQkwAT8Zlp0l/OvFeAsGRE?=
 =?us-ascii?Q?rnFiLIQCt06z7PCz5H+Al78KGI5sMHxN1MqxLLOQIUmy5eGDsbIWOZf+D5Qg?=
 =?us-ascii?Q?2RkppmDMxnLd3dZzm22TmtMqrG3tpeWX2PebUMrngWFKuRIfedAiSCTFXGy8?=
 =?us-ascii?Q?YTLV33eKDA5/KhBM/YZbZAPEbjPkFW+lLG2Qfb4YkGSKsKb1zZcKyF0+M80D?=
 =?us-ascii?Q?SRQ4pJUsmUxhELnqguVyeg+vb5jEYjPQ+xV6iLQMHTz945rB4lbLSWZEn55D?=
 =?us-ascii?Q?iPMDgRpuXIo5m0GH6qmFgpRdZ2OtlnLOhjNxg8HMtwRp29307wo/ScQN9AMK?=
 =?us-ascii?Q?5sri09c4jLe1L9qrp5IVPVy7HTwz0PeTJo83SFrrEEuMtBvTRO4Zy3MMi4vK?=
 =?us-ascii?Q?kWtUJqGO9ruWYalDqgm6yi2RSvQDEvx2pKjKFbpBvHyKQuZ8S+GlAv1vJM0B?=
 =?us-ascii?Q?vuVnmNYNf4Z/KVFGvN7d/ZzgCJe71o5Nfy0tKTN25Hb8ub3flpPfDBNOW9Hr?=
 =?us-ascii?Q?kejKPOYh/G/jjwxFhNOfyxmILwveb+aPzohX5Fu4r/JrXMwQ/rY2b/1500OO?=
 =?us-ascii?Q?zoChRk5z82p0Ylsu92tbNnKIjXd4qOqJU64/DbJSeBEPciVXXkuSDwSgtqpz?=
 =?us-ascii?Q?QMToZFJEnsKGHDI3B7LgVFWXF3KM3ApEj5OpWIgkKxxhzD3tcHfJGv7afT69?=
 =?us-ascii?Q?BoRkLMOCYdasXWNavGlohYJ5MUm08jRZ1GjzlH/Panouwb3bdZbKXDTB5Pgh?=
 =?us-ascii?Q?k1h1/ZAi59bvEeyoXv4on8OxKYdMbpxLsN9uIWulVdoKjARkD0VXbFeE7zWc?=
 =?us-ascii?Q?Ygdet7zdetxWLaFzd1GjH2PPzgbP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bshwz89XzH8bw5PoD8199UBoWEMUiHET+/ruuWtyQDf58MyBToNc1KysiFlE?=
 =?us-ascii?Q?jpV+3OSOsZZBsUkMo+TkVYhfAxFDLxx56mAkB2YGWCX6zJWZnr9XbCfQ1QA+?=
 =?us-ascii?Q?LK0lEZj+gZggJW1m1hWh3nDQfLkiePnvI9p266qf8KYVZ594+Nb9d9DY4a8x?=
 =?us-ascii?Q?ciUHadAR9menZFaxAZYYcZV+rGbzb+d1n+TgzHr5diKDnyRWJf1ToWbLFdg/?=
 =?us-ascii?Q?VuVZBtfiFYIqF/cu/lgRBnTzfIOBxdPJCgeX9EFHeUiAvMdOVQZ9VKAGccon?=
 =?us-ascii?Q?zqcguqQSxXwt/4kFoLy8SG8AbTaNWbUE+uFXMnAgZCnk8EZy3onWtRFBkK4/?=
 =?us-ascii?Q?KzhFm8bB4iHayyR+3fvQkb9CLn9t5S09JvijVlxv76L3od5maUA08/7J5rzw?=
 =?us-ascii?Q?4gBnXJR9ymp87lubaNOFOLUA9blyouZZydvNe81XVIFsetclAR/p4fHvZFfp?=
 =?us-ascii?Q?7xAnPGkq1tSwqaSdoQBxXQhrBJNZcEho7Dm55FlbR5+dI0wx2YMNRxRf8uGG?=
 =?us-ascii?Q?DI+5pBXv8WWQ8huo4i8rAme0DtC14No4DQu8BPDBurJfa5Lx+cF9Ii/XzixU?=
 =?us-ascii?Q?y+rkR3nSJ7gMb7c0ps9nkuudGWQgxxJ1j8VPljip6NkhcB1TJrvogrk9+diS?=
 =?us-ascii?Q?n/BdCrn03XwwJz026dNVLbI/gLxofm6FGOfspNzenosIaw+WNh22vliyvKKD?=
 =?us-ascii?Q?oGsAThXKrKmMyxYEN1uv8Oc0Jz3wYJ0ZEGopKemLVB/mNbhB+R3kDHIicHle?=
 =?us-ascii?Q?baKUtA+lVftRCOhSdMrWlAsDZ5iowChgFD4tqXr9kK8O2H+n9hQfhS75PWLp?=
 =?us-ascii?Q?rmIf4UmKCmryF3Y5NyXE223uXIHS1X95rntECI22QOJLQinhNlF7gDiuWfbD?=
 =?us-ascii?Q?nJK/XYh43wGHo37EjE4ymCvk70KmkQ+D1yuaBi4cm3L888rk0msFsyfCyQN0?=
 =?us-ascii?Q?PuyApysA8jEZBJ7YMnq8rEYxLOsLmEc+KnOwNZfi+Ey+ilAWg9qIfsjIDnD1?=
 =?us-ascii?Q?Eo3/XK+qg/1HJPsLTCn6wCIepQIAQkD9//NH5HmCFyUDxZ9Dv5J6k8edrr86?=
 =?us-ascii?Q?jK2fp93aHY2GsM6u7dhUjQcSrgqqvu3qxd4h6S2GQkMzvZc04/LBqjm5CqMH?=
 =?us-ascii?Q?kqR2Wr5SXjVGSNNhTgMWQ1w6rzy0EwlIxQlY751MwP+FCeziJgQWjOtIXVRh?=
 =?us-ascii?Q?Pw9459ItozRDAlHj+eb1Nx0CdOGHqmTMOGElZvjU2XGCmbNg5OQhTL6hxgKI?=
 =?us-ascii?Q?7stLFIlULzZHX0jrkCF4RTG3O2Qlkx8b8ZZlnwdUeW9S+4ENb3rBky25D0Zx?=
 =?us-ascii?Q?JkNwZ6lVcDzCG5aBMrg7e40SCjrijycjhBA9kw6x6nWimbnQTE6EmqYY2x7d?=
 =?us-ascii?Q?sXs+Wi+jefQX3W+aZ8mDM/pZdA4Z4/63uZgeoI4NYPqxuUp3o7BC307k93/T?=
 =?us-ascii?Q?vYkv3W/7IyTZ3QDW9rgAw5pc+n4ecWokxVcuKPJOKO5weCTs7fiWbz50azb/?=
 =?us-ascii?Q?CluZbZ5pYcbrqb4UFl5tzE1lXaPSBTeSPhbZAFHSw0fB1wuGS00GfMVGFDXg?=
 =?us-ascii?Q?F70A3zPRZXTMiZWLcxaUcvDEzkbepSpREQG0hfEq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b65b135-93ee-4bd0-4cbe-08dd5af4f605
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 08:17:10.4735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lvEaMA2NDxAHFGuOkDYwSvc8q+6W74ViirL59HD20WAL+BdRb5oa8uq0TtwXrY9f8o2bxo+kYRw0ekrG82Tu2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7438
X-OriginatorOrg: intel.com

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 35d03fcdb8e9..5abea6c73a38 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9775,6 +9775,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
>  		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
>  	}
> +	kvm_caps.inapplicable_quirks = KVM_X86_CONDITIONAL_QUIRKS;
>  
>  	rdmsrl_safe(MSR_EFER, &kvm_host.efer);
>  
> @@ -12754,6 +12755,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm->arch.apic_bus_cycle_ns = APIC_BUS_CYCLE_NS_DEFAULT;
>  	kvm->arch.guest_can_read_msr_platform_info = true;
>  	kvm->arch.enable_pmu = enable_pmu;
> +	kvm->arch.disabled_quirks = kvm_caps.inapplicable_quirks;
Should be

kvm->arch.disabled_quirks |= kvm_caps.inapplicable_quirks;

Otherwise, it may overwrite the disabled_quirks value set in vm_init hook.

>  
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
 

