Return-Path: <kvm+bounces-65549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D6900CAF31D
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 08:47:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 47F07303CF75
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 07:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0759327B335;
	Tue,  9 Dec 2025 07:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YTu0h0Js"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D25816DEB1;
	Tue,  9 Dec 2025 07:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765266409; cv=fail; b=CI9CTBdlDSjNPluqeji2K5JIp+ur3qz3ScgOnpMP7+81ItnSvKqsRhHrZk9bND1pDN9Mmixa/qmM8GwuceVWC0XrTXqX4+vF3VnN27wK/oZds8K4A8S8yfM/ogEcTPRnEpCSvQsLYnOdrzT1R4UATCArwJBpiOvLvJL9wMppbs4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765266409; c=relaxed/simple;
	bh=HWzXRKn5+sMwCWe43DwYg/+wQQaKvzpyKmqd0zsfZao=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=q8P8UuyrYRH1uMe4bPy82QQyo4ZyCCupxj6gp/QZBy+pQyh8OQp+4pihQTNrNjsnIpztIL1tFKunT0/zcbA+Oeu+nS/gqrjn+TdLriAmnF9TSpHZpNbiXAHjGGddAQQDsjzP2IgqQyXt0as71ep5R8fnxaAR/TZF+w+FCLwVI3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YTu0h0Js; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765266408; x=1796802408;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HWzXRKn5+sMwCWe43DwYg/+wQQaKvzpyKmqd0zsfZao=;
  b=YTu0h0JsJuyznJvs0RusqIb1FMcJchQi909ypQydJNBkTq4JQT/XlrUJ
   hvXpFL2JJFeTGxtV9qoJXmqxQha69b5MfUeeiu251AxVN2f0g0rUmGCzr
   wFYR4zhTg/QqnjimvViz251uHYAZy7+cJLVBwZLpFP/HA4C76f0XQddKB
   6o2YF8+TO7MpptiIjkfdmRm0G94jzC9iRROAcIpCA5JGkJ2O5xUjKZO4c
   zgn+FlnHOgb9YRXHt9NpeQ3XKD0qnaRU5nInPXhIAXXph+dB2ejoZBUi0
   IvddFuhkD3BTgyd4Q/Qqobeci2AWi9s8VgnMKCmmDxNot59Hos6zj10rd
   g==;
X-CSE-ConnectionGUID: UhimuDT9QDqCsgh3Y6/jRw==
X-CSE-MsgGUID: ZlOtGGeNQYWnhW7VqmpRNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="66942090"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="66942090"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 23:46:47 -0800
X-CSE-ConnectionGUID: v+Q5ubMzR0maHT8j0soMMA==
X-CSE-MsgGUID: Z4CFglOvQVe6kgfnHu3lBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="200598965"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 23:46:46 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 23:46:45 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 23:46:45 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.18) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 23:46:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gUJroIHpMwDq8Y1qKfBRhd5kYPWE3yHVO5cCa9PzRHJq9exGPOtslVNPzdiagR8XxADd8hzuwqIWY2JBiYvFpQmIQRDObNOAzMFkurNpV8UBL7GWiXIymqYHjhoFMoFNtLqZHAxmKzLM0OkD3KYTMRgY35UQEA5vXTmuaPSBm33xIvfTxOfBKpsyPdCKVYr0sxaI+DjHA4re0t98gGgSiA1gJXt0DkviVjMHhUWuhv1kfaOVea/Z0120DDHkX8SBtzwollf+8n7zW11hL7JS8BIzeaL9JJ+pyZiqocoZ1XI4kjU+X+VXNXdkrxAwDi3stYaTWCRbtXu2sZ8NhGKxNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gxnq3Uh9eE4ljUQgsTNJ3l4GsYz27orYSSoR6l55jDg=;
 b=E9SgTPRbZtqAqekbSXvXQstHdm90Bt1OHxCVNoR8G8OfgEs/Lf39BmF6p3KuSOj5C+JNIqKGYoaV/kJG+7q65vnPhdc1U4UVERd0HVfK/GwpCTJ6ViC2wdGfrhQ11xijLZ9HuxabBMPoMX5RSeDPXQRQDzXZpDcCXYQU81IodTTu7qqWUaSzhgMldNa5UWBCW0Xije4YhnKLm4CC6NzbcVdxnd8q5BPbg2rjCoKwIGu2yPhPwQdSmujlXlu+NHOfx40c5tHCUi4kJ6m/7HwnYSxGf+sEaaNW78uX3QaaX3UeLtPK93rX1cMzLVN0eJfZ2Zswqsibgub87Wbgl5/CNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS7PR11MB6269.namprd11.prod.outlook.com (2603:10b6:8:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 07:46:37 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 07:46:37 +0000
Date: Tue, 9 Dec 2025 15:46:27 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v2 1/7] KVM: x86: Move kvm_rebooting to x86
Message-ID: <aTfT05N++/hVWMyz@intel.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251206011054.494190-2-seanjc@google.com>
X-ClientProxiedBy: SGAP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::31)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS7PR11MB6269:EE_
X-MS-Office365-Filtering-Correlation-Id: a1b43779-a696-437f-e7f9-08de36f71549
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8jpBsHDcqHkgbACF7YLScz1zpY7+VqpcBRmOEu/+8FwFeUYNmDHjcpVs3A9R?=
 =?us-ascii?Q?H+uOo2d7uGfL6M3f4fkTSWJkedmBDlmKsMm5MPhzt69pxB3Q9v/unXUJoH41?=
 =?us-ascii?Q?4bDsRgEDtca5csIqmOJZuEDbmyVgBY9GurNCIZetISfOIWymDS+TqtBbTtTH?=
 =?us-ascii?Q?JS373XU867vp5nb1KNURLjuQcl9cb79H2qQPduB+/M3kb4d6gro7kVqR+Dci?=
 =?us-ascii?Q?uEPu2FrqFj7Wn3T+mIBoLoxnpvnCcZtPYGmKC1pUlS2jxQaCDGE6uaXIoAdf?=
 =?us-ascii?Q?l27/2KYkCJEBDOMMAFz4xeDHuSwspM0luAVIIUWsKnrXcFKxpC2W9dI0S3PT?=
 =?us-ascii?Q?YoXQRCEN0sO/3g+BS5qUEkCTTh77Dzl3hvKa4gDKSB7k8NkrqSdcEOj/j8fV?=
 =?us-ascii?Q?aObSJrz3sX0JYYs0CHxpkiGESLZLDNDLRk1LPKXfqr8d4gQzOawRwCQGwueF?=
 =?us-ascii?Q?ZcmwXH1qqs2JDrI6DkkPpbW6/98BeY11N6ydgco/3SOWtc7iLCImOJ0SL4Yg?=
 =?us-ascii?Q?M6cy4vrYlU1XtXHNONqPmc/VyRZVIZFkj6/aQXNAZyMvv7TsiZV8rZYz6mUG?=
 =?us-ascii?Q?nItJT43cM1ciHwrVl3wGREwz/SaXvDTXJ2f15HE0Pp1bVxJXLWk7L5j6SUUs?=
 =?us-ascii?Q?5vS2ouADPSy6btAC2nz9ykK4obdZLHiX3gcF/4aSwl6Cu9GQMn3Eefhf6N50?=
 =?us-ascii?Q?XlOxHy81FtORJZ9PY858IjwRpQSfm3M9ar8SPi/pphP2v/xuvFfetKS387VM?=
 =?us-ascii?Q?huZGVCH6l+14ml0JgD21OxC6DmYcV8BlbCzfPnzZonKJAlQBCc7XenYiH4BR?=
 =?us-ascii?Q?04K4Tstj1F9efuOqWPila/RRAMXasZcrkxt9G+otMYELPwAG3wpmtMh9EgEn?=
 =?us-ascii?Q?ARWcVrxfhJOsLRnPYcOsNmhH9yzUBde9g4VV3lEdPHN6geUN16buutf5G4mb?=
 =?us-ascii?Q?nIZOkt2oyZgWkd5Dyia0OzQvw/WYuaF3vpi0+RPm8IoP7uY4oPRSRqnLqzy0?=
 =?us-ascii?Q?SBQTji7W8i32jh6W89aLMQP66m5msJvtI3FFAZMKGWdKG1jx7jGd+lbMPM8f?=
 =?us-ascii?Q?amI32jUbxVYmCxmoRwwvhdPRHKuqqgqERI+rjVsht2TstH8JdE0TMZVjzO2Q?=
 =?us-ascii?Q?kTaWtaUpTHrW3C2dtYJeCwIZ806KHeYAlwwGgZ6ip6+JMkZ2p1hYxOy6lT+K?=
 =?us-ascii?Q?nRJe6oKNJv0D4Rm/N7CAVcEedvFX1xPxSa1jf80B1KlMAiSsh5EPiZGxA62U?=
 =?us-ascii?Q?oKMmCrSLu2xU34S/+hsfwpO/TJhchyWjLfxgIhYEF7MAZapZ4tknVKIwNMzt?=
 =?us-ascii?Q?C9pn+7GcigwbmxfTZpBK6Cg3rTEReQzkWyxMX0VoB3dkUW+1zWUB5LUhANCh?=
 =?us-ascii?Q?QXYv0IavdVsG/kxdjfQvHPQjjf7WafdAs4Bj80Xi1qmAV7OS0jRUMh7jWLZl?=
 =?us-ascii?Q?SKixtZhKKtMxarpslgSzEW0pDmIyZBl6?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mPR+4LFQnsAAzXcoEb+ZN3WeLeCh9gCnbegqebygIHUCdP2ODAAolMnv1Cfr?=
 =?us-ascii?Q?IB0+VgDva2isLh8bYeyTkTqu3adtLBnZvUt23Big0uAGuQdNwk9IJO85U1fL?=
 =?us-ascii?Q?K+z72Az7/vgfCeS61lhMHldM2GqdgpEWBtXRPq04GEgzGNb4cIz/V2p5bUkP?=
 =?us-ascii?Q?PH9P/ezP+zA5gVCxm0lMBcb9DS5y5ATHS4QUXxGV9oeAROuAUdBcuxZyof/H?=
 =?us-ascii?Q?E0STrEa4AGeMbVKKIFSh6uWCe4DWo1PRkA6U6Jlij8Yc4CPIzc6EtaDsanoM?=
 =?us-ascii?Q?0Cs6/6gQatN3CIsXo/EmHCAFz2QxyFq1lOOzwhh8j5OEnDn/k2APx2W+RhPA?=
 =?us-ascii?Q?cqnuNYYoScsDutc5oW4vtVFHSKoBlTbCCaMA/5HmmjaSDl+MeDsoH+EGnHVu?=
 =?us-ascii?Q?cLS70iwUPD4UjpuitKjYbAjtNK5Wfckis+r1Km8v36V9gfKOB5x3Jc7yrLo7?=
 =?us-ascii?Q?aA2xjjjjq7oLYZm4hTAFUzbUHA7QudkNZiXp6P9pEPiy8xJXboYhXbu1df3B?=
 =?us-ascii?Q?mBPdMMP4mLTK9HvOU1X3sUvY0+wT0clKCbaTN80NBSfOfi46+XjhxBbrHe5R?=
 =?us-ascii?Q?MOS1H25DaMZbA+c9hCgBxblY6qhoz2vq7xvud/YRus1m9zlqyrKquBppeQjn?=
 =?us-ascii?Q?plM6cWR0PN0fEGQlHGUJ04HxULsdBhUd+dT6w826oGFRCMybHF+WPaTqitR6?=
 =?us-ascii?Q?7LlfbLL9JEhg+hVzJtru1vsayT6hcYIXFhnHJWGMYnb5wKfJNdaW5xTVSwp2?=
 =?us-ascii?Q?ODd0tnEXFN4/xEVn80i++vwRrUcVj9CYEGKxXfPOX+6aIhdezpQqYSE2UwR9?=
 =?us-ascii?Q?CSQwZDUK0/F+wQ7WGEUvfzqwm8j0z+TxRbgU45MrohdRVmrlunt+TqBw33iT?=
 =?us-ascii?Q?qCJlnz6b1xqXQLgVzvobiIIDFgPD0KQiz/Z+kG6I/dZXsC0aHOXBHOrSnEzE?=
 =?us-ascii?Q?x4R++iSiVokyLoxod5O2j9vu6trHDvuMtb/bP/VVFb3iNgt4WNJa8Tx+Cwjn?=
 =?us-ascii?Q?YUR1up5wrUIqeYHJauDiEoS5Kj+ApqMxqzFpRNPR2Wn4KVBof2+F4zouk7FA?=
 =?us-ascii?Q?ObvgOS8Omvx2Pa08b69vZOC/yU3UZ+rEjhd16t1oYw87ypG3erfyUM7Ax+c6?=
 =?us-ascii?Q?yta0t6MAnmGl9jA49yxvenp0BOrOskNc3Rhg8VX/yfOMxbkpEiWlileStq2k?=
 =?us-ascii?Q?TpvPt9RP3sggU/hGs1j/LM6u8YmDjupOx3We2cdrWPLYCjNCCul3mENG+6jk?=
 =?us-ascii?Q?v2s0j/5IjYQ3IdWTjfrgaen9AEcpNUkj0rzLkgzCedpWCJpfYA64KzhpRirG?=
 =?us-ascii?Q?Z3QWGNwwQX1t5+LA7GhvFEBwNNyF/FwnixwjYstU0BqzJLFytBPueRMZHHCK?=
 =?us-ascii?Q?A0ubiBdIMFuONXmNA5F1ceDxHWR7+Y2phYQL0NB772jVGWINCfPzElLg7YVx?=
 =?us-ascii?Q?doZ7H6dPSgt6ko2ulNzuy/hxdTZl+ncbVcZmhJE921JiikL2wpoaFdZ+apHo?=
 =?us-ascii?Q?73X4ZD6GiBwDF7ar6DMYsATlBLlBGLoWepbxHuLwUOzuf1oAoj5SVhajUoAB?=
 =?us-ascii?Q?RyRHWBmXS8AOTlo2Y6Dep1PCQMX49pMB5O8AtyRl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b43779-a696-437f-e7f9-08de36f71549
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 07:46:37.7324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jJs90yhXS529G75gI8BnEz03CwmxJDbx0f+uWFZQ5+aL1kBQUA7w+W7Yu51NTPcxeZFQCYJRpaBuiFEs3OBx/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6269
X-OriginatorOrg: intel.com

On Fri, Dec 05, 2025 at 05:10:48PM -0800, Sean Christopherson wrote:
>Move kvm_rebooting, which is only read by x86, to KVM x86 so that it can
>be moved again to core x86 code.  Add a "shutdown" arch hook to facilate
>setting the flag in KVM x86.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

