Return-Path: <kvm+bounces-71196-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sJ9uCjjxlGnFJAIAu9opvQ
	(envelope-from <kvm+bounces-71196-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 23:52:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 51245151A19
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 23:52:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A2B45300A26F
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 22:52:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EEAC2DAFBB;
	Tue, 17 Feb 2026 22:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fw0ViumF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451011ADC7E;
	Tue, 17 Feb 2026 22:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771368754; cv=fail; b=EFKRcQ3s9yd0lcyi29yPTuzSwAg2EDNMftlZkFWp2f/+WaU5OVAIPKrf4dcAnsU9anq0oRb/HXgJ0a3x4U7RUnvT2+U7bY2V/zw2Y1F7D6SUPOYbsmV/6wL/o1+yvENiijuEcvV4zXRsRLXfvnnROD8mhlTwC10F9o/KPAi7CO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771368754; c=relaxed/simple;
	bh=J6ND5hELHOTOP/a2ZeyxxSn5Z1FdYuCtHTW7vcx38j0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ps8+q5bXWdUvcNnay3gvTqRTlVgleNejz1XPOsymo76yGdX4jb9zP7HpKcNpYeMnY4/X2SIFL5sWYk3Hm5IJ55ceg7rr3/+5YeTgQicWtp/kiegghG3h22LPYpQsj83yJl9kgU1lYkmuIOxVsRmNb0czOsnbhW1WJm1buCPAYVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fw0ViumF; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771368752; x=1802904752;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=J6ND5hELHOTOP/a2ZeyxxSn5Z1FdYuCtHTW7vcx38j0=;
  b=Fw0ViumFxI+mR5E+XvRfqssqG3TfGluhjtJvn2ybFDjL90BzU2Cmaqkp
   FUxdg4DjdB4fJMs7BNvsyzebAJuq/0jZxzoSqc6V/lrlJTDNxM3o97R3U
   XLA3rWKE5FewshbdUzVHDZ4sb5eDj3GyBUDfnlYWgA0sFokyuYue11JQP
   tZIk+e53dhgYooXv8TaXFQCtjyPSQGqCmqse1HcsyvawvPuBGSsjgYINP
   cKcaOvKv9BKuHu6sk4Ny2upuMs8fpGRLeZ83OfBCKrImXYRW6tt5d+XIP
   WRCGvSt48hlyJklBdMQTgP0+HMNTLlJNQ4LdPL+zNc9XaSpkDSk1uWVkz
   Q==;
X-CSE-ConnectionGUID: D6h733M5TGypoNesTGdU1w==
X-CSE-MsgGUID: VvJpEfwlT0mnSilkNLyGpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="72540804"
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="72540804"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 14:52:32 -0800
X-CSE-ConnectionGUID: cJg635vAT2WqFSj6R/97gA==
X-CSE-MsgGUID: NgXK1a9WQJOq+OnMnOjceg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="213870543"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 14:52:31 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 14:52:30 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 17 Feb 2026 14:52:30 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.36) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 14:52:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KSb7vpIIyJHU8WJwY7qXzjijFYOdJJpjhdBVHjaRHricD3kjCIgSxuk/RAIZl5U/ykb+y3fyzhckVb4yxk/oICiGysBcfXcSBsyaUSZ1m3IIroQc5RDxEh4+10He13W3GtOxfHRokFRMs7OIH5kpv5G+NxS7wvquOOQBZiRtUNAEkGnqRsbP4t9+z1iTRqZ1R1cqjpEsxlHtW3iF41byH+1ut0pVC2ZzeFQtwAGw3m6VH98k2a/PYEbzDiguRJMqz3PEGr3ORNuWhwrTcZbvD/jDemz1SVebjEVRBerSC2WQXS3toqbEcYcPIQ/fJsff2pludKM1gF60pkjec8j9WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q81EkJSizB3jdjXW/kyyYbC5EOdK7ihEOTj4PGxSPyM=;
 b=p1FcKZnyIdznSyFfRw11OyGc4PqkV3t5TOs1kb9PfjqUuDDOK8UJhwL0AnQlbD6YL3HwJAKmfQ6i7tP30bTYpom2VLJwsTTkYMe1e0evCJpA1tDLYoD3xEQ2IOySvFr/ovcppyMwA9uE880JN5ISlQ4CtuVHMuKIS9QQWp6LNcAPbew2seZZ5b/n+Y6hcvVr7k/OLlRRf9SdJXoToNOFQCuYcqXhXXqze746IGyOiyJgwyoREzaQMFRul1GF/xh6/8hHof3MfXmUwTMkG8S0gBdhdNYsPQxmVMTYWx/Bh5u2adlEot7/CiJz/wpvF30R1s6nzEuiAHUMpkD5mZNOVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) by
 SJ0PR11MB5055.namprd11.prod.outlook.com (2603:10b6:a03:2d9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 22:52:26 +0000
Received: from DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1]) by DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1%7]) with mapi id 15.20.9632.010; Tue, 17 Feb 2026
 22:52:26 +0000
Date: Tue, 17 Feb 2026 14:52:21 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Ben Horgan <ben.horgan@arm.com>, "Moger, Babu" <bmoger@amd.com>, "Moger,
 Babu" <Babu.Moger@amd.com>, Drew Fustini <fustini@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "Dave.Martin@arm.com"
	<Dave.Martin@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "bsegall@google.com" <bsegall@google.com>,
	"mgorman@suse.de" <mgorman@suse.de>, "vschneid@redhat.com"
	<vschneid@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "pmladek@suse.com" <pmladek@suse.com>,
	"feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
	"kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"fvdl@google.com" <fvdl@google.com>, "lirongqing@baidu.com"
	<lirongqing@baidu.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
	"Shukla, Manali" <Manali.Shukla@amd.com>, "dapeng1.mi@linux.intel.com"
	<dapeng1.mi@linux.intel.com>, "chang.seok.bae@intel.com"
	<chang.seok.bae@intel.com>, "Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"naveen@kernel.org" <naveen@kernel.org>, "elena.reshetova@intel.com"
	<elena.reshetova@intel.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "eranian@google.com" <eranian@google.com>, "Shenoy,
 Gautham Ranjal" <gautham.shenoy@amd.com>
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
Message-ID: <aZTxJTWzfQGRqg-R@agluck-desk3>
References: <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <1f703c24-a4a9-416e-ae43-21d03f35f0be@intel.com>
 <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
 <aZThTzdxVcBkLD7P@agluck-desk3>
 <2416004a-5626-491d-819c-c470abbe0dd0@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2416004a-5626-491d-819c-c470abbe0dd0@intel.com>
X-ClientProxiedBy: SJ0PR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:a03:331::21) To DS7PR11MB6077.namprd11.prod.outlook.com
 (2603:10b6:8:87::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB6077:EE_|SJ0PR11MB5055:EE_
X-MS-Office365-Filtering-Correlation-Id: aac537b5-6da9-428b-d06b-08de6e773818
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YRDxG86hPO+796xkdAcgzGKX0wCH3YkuNLKHoVO2u3zB5t9ZZb9GYvxocBm+?=
 =?us-ascii?Q?1dnnwXTcfD1/idyobQ9/PcF3yyj/lRiuBNxWlUnWXkJaa17qHkmRtpWN53XL?=
 =?us-ascii?Q?LZnNJWXFYeIuKHmhYSWW3AnnUAo1e3V5Ew+sOb9UpuW76iUMfvDiOFeJQco+?=
 =?us-ascii?Q?touLAWyFMW4hWzmkMBmgoWm5fPonwqYTxaax1rar8y7DwN71xoCSDpyEtxmx?=
 =?us-ascii?Q?CXWqkSvdXcnjXxX3jhWf/epwNZwx8myEiWidV6sxQmNMGizveDhobf3ma412?=
 =?us-ascii?Q?aph4Ep0Ha7M6BpkNBA507XPH2MUFQYY4PpnwAby5Z7BOOifKJ2g/9j2WjaHv?=
 =?us-ascii?Q?NHjY8+5g7BdMl5EubQvXmkJ/jCQ6ofhW6CwezR8yL8EdaJk29e42JBiTlnzu?=
 =?us-ascii?Q?LoOcCsLWYTUXZY6jkj5GpI/Mj0Fgf6fEYxZKmLxotSh52qAosFydAky3uY9s?=
 =?us-ascii?Q?apGJjwvAyqe0BfSjFhAzoM4G9A2xYxx7YaWpV/Hpml6MwaSdTU+FPxl3YGBm?=
 =?us-ascii?Q?OmPTZuUghpKeqBPJ3yfGIwmOnn1qHGS1u1Il8Xwm+ryQvDuNsZwm8DxgxlPZ?=
 =?us-ascii?Q?WSjZR0QNiwHGf05OLWvAFxiWw/00Yn21lHaQS6/IVYoqV2XE3g4xqWLc6OSY?=
 =?us-ascii?Q?mlkcjYYbR2+US7JAj8PBetGeslhyjjO4OGHSg4ryaTiyxSh9sF+oWeHxN3Pt?=
 =?us-ascii?Q?eaMFkOGqBTSOz+62u07qEoi8rMvLBnyaV3mS1Crgr6fW5l4nV/YWwEa5F3Gx?=
 =?us-ascii?Q?lXNP70FeXF8Sh5+BoWpB5CFIqMHNsXVTzVofUErRiQtF1Qvu2Q9p1+Z74IQG?=
 =?us-ascii?Q?j+DxN1pSgfpdceEgj54qMz0EvY0Ocgm1KtQA9n3vtqxkobgDieIxhhla8m2g?=
 =?us-ascii?Q?FUjjhceBR6oftFyIjGrIsDe1VZl4APBRb4Wri7e/+BHWI7AmJdTJTM3dZcAs?=
 =?us-ascii?Q?1X/dpfzOKLZ3JFCSfIQPR3v75nIsmr32oTQ04AZFRPHgxl2PADu2aVQKJhyh?=
 =?us-ascii?Q?4IfheNe50i4ZrN2J7UvWyQeyuhWd11wqxqiAg/njdKYLNtbDg0gMAfU2XdLZ?=
 =?us-ascii?Q?HFPzLysJKdJs7ToR5qQm5sINDbDFMbFWPf8o3a/ekxzGXJo5dHBrVZ2B3Ew+?=
 =?us-ascii?Q?+qOrUyEVdGthkFDNo7rlWYbcwruwxoR0WJngzjujB2SVdlqzwySm+v/yIt1U?=
 =?us-ascii?Q?F0Hz/sZ2hBe4kqLJAwHUMiwuapB+4fdrDxQZls4W1F7znLuTDToZ+6rkc27F?=
 =?us-ascii?Q?bR/EU99fvQ1W8FtPIGY+QkxobeZ2g2V2WReskOQjvTXJBpISw8p3LlEViCuG?=
 =?us-ascii?Q?6WkxAwSbr8kzllUpl3JNFuLg3vdNaPmTcswJuM+i6ETtkFHUNMqp8oSgPXLD?=
 =?us-ascii?Q?rd2ORwFB869lq8L5g2VfWgAJjqMmg4eVrPGK+txhWpryMOD+0CUC9YUCIrkL?=
 =?us-ascii?Q?5FJArVlhdjy9Ng6hpuU/IsfPHiBqsHGav2n+wpakhw2mcDJB2gAnSMdEpctj?=
 =?us-ascii?Q?bG5bOBVEGfwxiEnz2xt5GCP1rVZDlGNgAFzn6u1Hdc4mWPSFl3Y/K6Jn1Vyn?=
 =?us-ascii?Q?DjZX2fC7HgjX8/XLO2E=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6077.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bb07AorfDP89TRA3k25y6GUcaqiqeWnIUwr9B/Ld/ILPJqTmZqywkpwgJmdB?=
 =?us-ascii?Q?G/l5IysRuQNk4cQWea75hqArH9azhPQw7rOT8xrcEYAxz3JG0SOywmsOUY74?=
 =?us-ascii?Q?Lqxzz3XcxFNVRj0PgrRC/7ZtkEkz8AFnN3kB/YR+vEaq6DHKDtGZN6E9bHJo?=
 =?us-ascii?Q?/gldPRyWZxPNAqzo7z32V0hlM+hAWgR8vNaqjsPt7mp14OHbLW38f6xvq1YP?=
 =?us-ascii?Q?N+V/PbjJkCl0pA+WlyC+eU+PS/v9Lw5YtCiYYZAcyBNv/1ux+twtBtWsEU4T?=
 =?us-ascii?Q?8OrR4lvGBHoeRmw354XIe1BAGjwKE7tWBYFpH4N6kb8hQ9lh7aw+1tDqAHVV?=
 =?us-ascii?Q?dUkLaQ2DPG/er9J1Nsy9iiWMd6JUmddCj4S6tFJsqFcPld2GI7IixczKL4/w?=
 =?us-ascii?Q?M/VKOC8vr94VvEnLZj5gxYnjwG09bapzMKt6W6j7jQzP0P6Jm3zNPCmstHJC?=
 =?us-ascii?Q?hDB/WlIFoyvD8VXRl2+X0eNECVYM4nM1PfSXcfLNWD6Hj9Z9JoHnov32Z9oE?=
 =?us-ascii?Q?zlPR+6VvlOGXi3iidEwox5U4oH1TcC4HJ3FynG+WWVWCO6oEa1KzJyDCNunD?=
 =?us-ascii?Q?kYQs3J+OLdyhXeo/pZZUoW7ZgOVWEL+TLyRX6JQL+6Iyxemk6UOTJvYtKjKZ?=
 =?us-ascii?Q?H48di8VhPnzdujHC0BOZtpSE2b5fSDR3bmFafimKccUXj3mYzDaL/i3olnTw?=
 =?us-ascii?Q?a5RZU26hgtiLRmW6cl7XFzrd/X8RlaZ5+EiPxc5MGtS/NiNSXA4GDdhLPjYX?=
 =?us-ascii?Q?xaT37dD59t8XnOdmplDJAWN9FI9e9sh2TpwBgB7krWeCF3n5X1YQv75wEs8G?=
 =?us-ascii?Q?f7rnmQK6c6GeUHjVbwu7P3sGaqvXd/2u3afUgHxcaer0G17JQCB9PTlxz5X6?=
 =?us-ascii?Q?oddFpi3P0iWPeokWstWyuc7a/zDid8qowyiYjByCXODMxxGoGN7pF17hjXQ5?=
 =?us-ascii?Q?rNZayNPOt8rFYa6iGp0f+MEar3VinqKTOmQheFiT99pmujm/KKDQ+OaE/z/C?=
 =?us-ascii?Q?SAlb2KvMP6OT1U3WBTt2hTUq5Aq//eDka7qCI6lbkN22UU/N4q88wDhVeM5l?=
 =?us-ascii?Q?ffyITfG7j6/p08HhHWIcaXBe9jfXToizfo6puidWj3+tFwQBObOfuPo1Vn95?=
 =?us-ascii?Q?zGpju8baehKsEgZCEq1V7TWfTcgCv3fLttyv4kcqHo2+5zSg//2Kz4T44BG0?=
 =?us-ascii?Q?67rhHSGQkKtlOs1n3YnSlRyeGkqPl7j8rbCDkVquO7vOItIHZRJ9LYvfw0+J?=
 =?us-ascii?Q?wIkz14uCV9aWg5F+yan5jRAfUE/fQ/VkJhrcCeER9tx3c8nPWj97F7DG50gq?=
 =?us-ascii?Q?JFVGCWg+Nz0n87uWi6pFAwATLFg5VullYsLqf3KFemEaNYIuhKHwi2NnPQWf?=
 =?us-ascii?Q?0Rwc/jAN24SMOSNZQ4Bh3YCL8TuoOASx/lPiMPare0Wq1q+yiMru3OhJUrb1?=
 =?us-ascii?Q?bc+B96jARJG9CT/y7i5d4zmK/lTfTnJCPYC+fxVdaZz19CQS2vI7JGJYG2pJ?=
 =?us-ascii?Q?FUdVl4vrBFMW6AzQBzWnrPPl3KMyJo5InLWjmJz7nHorxUQJb72NWeWO1OzO?=
 =?us-ascii?Q?8HLyHVkwmtMHKoXuBYN9D7DNMPDJnP7hvfpSxKkzKdB7X+y88aVg4djhYFeC?=
 =?us-ascii?Q?3s7TQlx16ol/tkhKFtPBP5Km/T+9ZRP0UR41QIjv5UAJxWHbXgOeJgIPIOsb?=
 =?us-ascii?Q?q0TerNJ8B2mN2uk1Cwr8qLllCb1A048TlmB2y3tG1cXNRaZKRp5GMVzcCru2?=
 =?us-ascii?Q?lqNSxVn5Zg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aac537b5-6da9-428b-d06b-08de6e773818
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6077.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 22:52:26.4521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ximlbk37R1ZfBvyzG52RwT7Paq8gV9drkT2aFnOg1mL0hB1ykQmIqWP6q82QMhYQ54rfS6rwbJXEoHIvuPSbWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5055
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71196-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[46];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.luck@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 51245151A19
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 02:37:49PM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 2/17/26 1:44 PM, Luck, Tony wrote:
> >>>>> I'm not sure if this would happen in the real world or not.
> >>>>
> >>>> Ack. I would like to echo Tony's request for feedback from resctrl users
> >>>>  https://lore.kernel.org/lkml/aYzcpuG0PfUaTdqt@agluck-desk3/
> >>>
> >>> Indeed. This is all getting a bit complicated.
> >>>
> >>
> >> ack
> > 
> > We have several proposals so far:
> > 
> > 1) Ben's suggestion to use the default group (either with a Babu-style
> > "plza" file just in that group, or a configuration file under "info/").
> > 
> > This is easily the simplest for implementation, but has no flexibility.
> > Also requires users to move all the non-critical workloads out to other
> > CTRL_MON groups. Doesn't steal a CLOSID/RMID.
> > 
> > 2) My thoughts are for a separate group that is only used to configure
> > the schemata. This does allocate a dedicated CLOSID/RMID pair. Those
> > are used for all tasks when in kernel mode.
> > 
> > No context switch overhead. Has some flexibility.
> > 
> > 3) Babu's RFC patch. Designates an existing CTRL_MON group as the one
> > that defines kernel CLOSID/RMID. Tasks and CPUs can be assigned to this
> > group in addition to belonging to another group than defines schemata
> > resources when running in non-kernel mode.
> > Tasks aren't required to be in the kernel group, in which case they
> > keep the same CLOSID in both user and kernel mode. When used in this
> > way there will be context switch overhead when changing between tasks
> > with different kernel CLOSID/RMID.
> > 
> > 4) Even more complex scenarios with more than one user configurable
> > kernel group to give more options on resources available in the kernel.
> > 
> > 
> > I had a quick pass as coding my option "2". My UI to designate the
> > group to use for kernel mode is to reserve the name "kernel_group"
> > when making CTRL_MON groups. Some tweaks to avoid creating the
> > "tasks", "cpus", and "cpus_list" files (which might be done more
> > elegantly), and "mon_groups" directory in this group.
> 
> Should the decision of whether context switch overhead is acceptable
> not be left up to the user? 

When someone comes up with a convincing use case to support one set of
kernel resources when interrupting task A, and a different set of
resources when interrupting task B, we should certainly listen.

> I assume that, just like what is currently done for x86's MSR_IA32_PQR_ASSOC,
> the needed registers will only be updated if there is a new CLOSID/RMID needed
> for kernel space.

Babu's RFC does this.

>                   Are you suggesting that just this checking itself is too
> expensive to justify giving user space more flexibility by fully enabling what
> the hardware supports? If resctrl does draw such a line to not enable what
> hardware supports it should be well justified.

The check is likley light weight (as long as the variables to be
compared reside in the same cache lines as the exisitng CLOSID
and RMID checks). So if there is a use case for different resources
when in kernel mode, then taking this path will be fine.
> 
> Reinette

-Tony

