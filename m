Return-Path: <kvm+bounces-40536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1415A58A18
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 02:34:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9B873AA841
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 01:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 214AE1531E3;
	Mon, 10 Mar 2025 01:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TbQ1mJ4a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D817D11CBA;
	Mon, 10 Mar 2025 01:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741570438; cv=fail; b=hsUm3ODceg97Mxl2ZthAMCyOb4zSlUf2SzEFV6R2sLzvdBAXDvZziMxsEhXpX+qJE3GbFI4gOS9IzX2dGf62ZMH2aU/EQqu4GoJMDQvnmcqsq4v3NhhZdiZ9FcSHzgDnA0oI8BWLP9/g5tP5ddbonb5lHQ4LwmRJNLR9S7eebb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741570438; c=relaxed/simple;
	bh=jZjxRHwwXlavvGMSLyUD/SBzd6sG4dnAPAp4wDamDpA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=J1qQhtOZgfxT1wpGcDEdwh6IB1ghVgUwOyIjZH8Xvy9V5ZeW72XZjnJ3m64hKb8SxizBqupGGo+MFOxXrsNAClTPkFrHY0pX6NBM2zksIus50m91GSkdQVD+WV/So9aMhgsN8YFe3Tq0qlFxMsOmVdfIbOoo2QZ30b854KrsFO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TbQ1mJ4a; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741570437; x=1773106437;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jZjxRHwwXlavvGMSLyUD/SBzd6sG4dnAPAp4wDamDpA=;
  b=TbQ1mJ4aSAmkvscl6hBf/iZ+RtpG0jIlrXqD1bSshsJMYgR98wmmCU7b
   ZHnobMIPibk5mocMrvIu507igA7cThT6iIOYKYNyKbYCHNfoQrGOksdnu
   uWlFWUkYOsxlE7jIwYBOnirm4in6e/ILPb7UClVvshiP65uwdGxmimSPN
   7XXE19qFC9KrPSZkVUxPFdbLMHFv9om2VY0X9QhAUCxNtkfIjKsK21BpR
   o1QATdhOSMCT2hZnSEhC07vF7GSR6UwirgketVj1L30R/Ttn08yhUdc5r
   +oNqGh8879+6LXXwRnhNzAOntEB/WPLAMfCNxj+kFyZxnuzVGKY6yRV8N
   w==;
X-CSE-ConnectionGUID: oQ1mBQXYTOiJK4sKrJ05bg==
X-CSE-MsgGUID: W2sqZ6OSSs+hqO3Mf49gQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="42427088"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="42427088"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 18:33:56 -0700
X-CSE-ConnectionGUID: UsAVFT+NQ9yCmiqCxAZoWg==
X-CSE-MsgGUID: VjV9CZy7QKCkyHtbis1oKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="125099992"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 18:33:55 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Sun, 9 Mar 2025 18:33:55 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 9 Mar 2025 18:33:55 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 9 Mar 2025 18:33:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fj68XlSi571+bK6tTeuLKC4A+FClaU3+csrAI7KGbkG6F782hA7M/BXoDLGp0zTxyVFMukyMW7XLG0Dv9dH0+1KEsoYJWq2HyFQa9+JzSHBmHauh7ycmh53TFe0c9iRN06tPA54RvPqQI4iacansogmnMNh54VA6FjYdjjRTsvvTCbv39FtIS08Sro23j02XsH4IoXl9uKm/A1KM1KWzWLvuXcFkUNCo29Tcnl6MaYZkNcOBchR5oePoh9e0sv1YX64uYRY8mW1AZcRcV+/Jo3MHAYY5bSGAg3OL3beHdp619FJJfZ2RCk70enptn4YSxwwiawSAiAHx6mEH6pYWPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lX0k2Wq8YtdP2NCZ9BQAO8fV8uZIwkKkzvSGmAw0aFo=;
 b=KetC/i+r6XNptyoNwKGAS5WA+sD5kcqO1bimRIjPyB+qv7H8GPklSc7MaOJ57N3aoJIhiTIoUKorXbySafe2BT4p/MnYHsYwDtF73SWX0zHFCaNXANjqhlarkdO/tC9MvHAoWhPI5/zcPZEA3pL3Hwtz9e++Igz6r7XdBlKufCQL4sV2lyKuHp2pqu8VE4wjpyLLx1gQXeFZFSO5CRW6t9Hx1z3kVZ0jXEOmnlcuwj+F6PiXlsQy9XCmPpmO2dZUNJSygipMw3cdHo2Afo0Qlv+922Q2mUqmzCCkaugBXINQnawLzLaZjTkGl7jlHl7NPWl1ap2wcgIeCOtJR6/amQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA2PR11MB5084.namprd11.prod.outlook.com (2603:10b6:806:116::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Mon, 10 Mar
 2025 01:33:52 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.025; Mon, 10 Mar 2025
 01:33:52 +0000
Date: Mon, 10 Mar 2025 09:33:41 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
Subject: Re: [PATCH v3 04/10] x86/fpu/xstate: Correct guest fpstate size
 calculation
Message-ID: <Z85BdZC/tlMRxhwr@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-5-chao.gao@intel.com>
 <b34c842a-142f-4ef7-97d4-2144f50f74cf@intel.com>
 <Z8uwIVACkXBlMWPt@intel.com>
 <481b6a20-2ccb-4eae-801b-ff95c7ccd09c@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <481b6a20-2ccb-4eae-801b-ff95c7ccd09c@intel.com>
X-ClientProxiedBy: KU1PR03CA0027.apcprd03.prod.outlook.com
 (2603:1096:802:19::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA2PR11MB5084:EE_
X-MS-Office365-Filtering-Correlation-Id: 155ac044-ce85-4b87-e7ff-08dd5f739d62
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?P5hmV4HGJvwz3EJDzLq+FZj71BkUDh8arvUtKCGDERyWvn+Z+SNsw2Q8I5V8?=
 =?us-ascii?Q?X3tzkKvgGlkj4/BUKQNqfxK5NPWHPFkbmBYi1WBBdwJ6iDERg7vs9oVV62zU?=
 =?us-ascii?Q?spoEDcIUs3GUeHz/Zl3nEbI8nuRhPiGhDP4Dp8yiPWq9UHF9B8p6HnFzGQsV?=
 =?us-ascii?Q?WOWGPp+wFjkdscn8mpInBDnLLwHCqbFy449paLLMKIxC7A3+3R57iJBq/vvP?=
 =?us-ascii?Q?Wu4/Ot3rffEcuhJJuLiEWKoGzXufruvlYAA9zN7bIFZ+9E5rBTamz50SlyC1?=
 =?us-ascii?Q?K/UmonRw6UTPQV07W1Iye+yr7pwiLOT/NSLVNL/W1DeHbGXmPZz3JoDGgSsB?=
 =?us-ascii?Q?ywCdzPD1iTi8qUWJ4eq3c1DpgYpb78Wk9nuDaYHKvGtCkk4MOsAhb37N2eud?=
 =?us-ascii?Q?4runkxw6JCfDZog1BDGZrI0B2JUYR90a2aO5taMRRvA+AQ0p8aLN1P6toAf7?=
 =?us-ascii?Q?bjoxo98lxtBWk+pQkSbb9+9vVXswr4UiB0RAJ0F0Dc00wgRdyA79zR7iDfa+?=
 =?us-ascii?Q?5N8RYHix8cei6IvFK/h0nrhPWNofFgzj/Asp5tyYjMlF5h/IJh5ngZr0fVnn?=
 =?us-ascii?Q?0h9GtRXWTWEO29mpPqajnk6vAvNT9jG01zf4xdARZe06NhORTh9uG160KE9Q?=
 =?us-ascii?Q?kfSSzznD73T0yKbGKuuBRYjfUjl1NCOhmYQWETwfg/XDzSeUNwhnY5fGChmu?=
 =?us-ascii?Q?blzAvEwRRrFqw/Ti3LFpzkp5UiiuxLBrT6LqaYDplyvEO0lYdtqq0yxljDYL?=
 =?us-ascii?Q?2Yf9sI+KB36cYxL+xAzlliALL6/BUAsrTNaJ+YqJwhLlB1acIAeaguXilaPc?=
 =?us-ascii?Q?U3dQqV6oU4irc1A9cAimJp+NAMpoxFTOXwU3ocOogDP7A5aXEkgcXRs8GFKT?=
 =?us-ascii?Q?qr73td3bbaSF0ZAAH1aH1H0X5oYduCdj1n27roY9tGdcA1aQVsE/uTS0hMjW?=
 =?us-ascii?Q?s2Riys8Rzt3FNP8mzDaTbbLZfjvPmoYZYMNGd/qDiuiBxRhcQWzkEWQu0CGX?=
 =?us-ascii?Q?PpJZBCDN6qpj3esEED+JFqMvqnGZo4vT8LJ7HoLpc8DuxzO5MvivVIxIM/bx?=
 =?us-ascii?Q?U0qIjhkITKM7tD+eu91yaTSKvJu6hbw6oA/y6tszxxN5A1Nl7+kPbmX64Gkp?=
 =?us-ascii?Q?dZ0BafS4h+ruhFWqdrdgC4LzW1XAUQHz07ghmDWzd91c2GG+QlB774YcGa6E?=
 =?us-ascii?Q?Nrx+vSlzELE1Gmg80SuNOErf+K6txczpiGDTro7rk5FSq2YUOqphA30OjNjB?=
 =?us-ascii?Q?CdhN4zJMTbVKx6/V/eKD0o70Um6UtIlWR71G0OS92eadoVjqBHpclldfTWnx?=
 =?us-ascii?Q?q/W/XrnI88tGgSuaeQEHfzwqScfy+DefzQyqFxj/zbMsH9AK0dLh2o7pfpOx?=
 =?us-ascii?Q?Cft5FCADGixcBhhF3E36Qz1QCqeX?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DQzPT9Rk2haQILEiv+HEAurs30oKwqqPC3GSuLZ9rF4tpahSQcmqDKBT8hfa?=
 =?us-ascii?Q?emt68lMnfQ9ZJIEeuPBh0l4D7MasnZnnH20gfnIRzTCqZKg10ixMbnIB1GbS?=
 =?us-ascii?Q?sEZZWoFMdSTf2yiHfZ+tSNqh/LsivodOVmOv6198szzwjPrBXXPGj68BFga0?=
 =?us-ascii?Q?pUYQa+rg+ZPGUqzfELeFabx8zegJ4edl4p36USkLQEQaqphAbHWJPyzqP1Qs?=
 =?us-ascii?Q?sYoIoanFBu1HT1L0kIN8V4dZKyawkNMTmBSOqvVGD/L+93pkM7UW7tPrtHP4?=
 =?us-ascii?Q?IMX8OaagdcF3ycduxpIGNSL403vjUEJRh0pfad9EzM6bV+voqXyCwCobOeP3?=
 =?us-ascii?Q?TZ0VQDi84BVgildE2lVkpho/+4Wb4cFsNH8NR1SGGAkB9sWOlmJI0I0nyao/?=
 =?us-ascii?Q?ZxnXLFTOdUfkk88poahVis5UBBChhOpO6UD6CbfgyByz2HPoTS8DOww9REvM?=
 =?us-ascii?Q?9HfvAeq5GbNeTNXZcRS185UMlKHa8OgBA9BO2zGVAforFtgAvMKDBSnS7Ooa?=
 =?us-ascii?Q?Sg003GkWu0iZG53eCATU2vw0yNKx66i70iFbGf6j8obOWcW8+FQV9R1vdCxp?=
 =?us-ascii?Q?LwtsPC+N2vgzJm4WgByOdFkxpSXQtSbhjQV48/yk/dWxU6/fil18dqM2IZQ1?=
 =?us-ascii?Q?uA5YOmYm2KugT8qjiGJysu9YgIjMUqrfxC1SbdQCKld3Q4C6jqourocQcUQq?=
 =?us-ascii?Q?2pw66VBdW/LjdLfHzbE5vDrE/ryryYU+jpZjj0bIkEHpVVDllO+/FJzBmfNQ?=
 =?us-ascii?Q?ogVYHyTWhQp4ESgrVcszaXH+eQ916VUNCGOBRSFf2PrpNfm/r1E0T3PaTbfp?=
 =?us-ascii?Q?9BqMCL4BNEkqGZMwZYjEKmBDjmjphrTmDiIJpoh8TPGFofPlAMfa3GYmBZLG?=
 =?us-ascii?Q?ODtzKvCrF5mi+Y/Blx1WLyJEZx7TWFXhRrgtvVZ7/Kb5GeYfZkcGAV95kW5j?=
 =?us-ascii?Q?S+35z7Cz6CFnhHTIfIK96OmqxEN0logA5xHY29cxlX2mdfXbhgbbJY9DUE31?=
 =?us-ascii?Q?aYJHnZow2kxff+lbVUrXno+uIn9ZjDywNvxCe7G7DdyTid+AwudnQsU1VeLi?=
 =?us-ascii?Q?Iq4ZZ/sphNWvho1mcH/rneKt3UsIzWwYP/8HMIBDkCo0AJcDUy6a2mg9kZmX?=
 =?us-ascii?Q?cvjqS9TOjmkLKKzdls9+wKXWhFrbOs11PpMsEfLJlKbyjLQs3S7XuM8OoTdC?=
 =?us-ascii?Q?PiSK6SVNC4JTIXce/IKkpWXq8RUk1lB/oPONbFrtWLCnq4EGH18EM7FC5l1T?=
 =?us-ascii?Q?SjluJT4UsqTW9OcPDJPsXeAQ5+NRhft6Y6tGwXXL37eospavn8rCeR3rbjM1?=
 =?us-ascii?Q?mFAQr4drfnDCznPZKYjeyC+zmy6NdK9Toy6B3PIklvypvKKUutrQJebZkBNN?=
 =?us-ascii?Q?VwwBkndMVCV4gEquqRdzgTDkgrSSfWO96mzU2srz9qNln0EfOtPcKrk95L+0?=
 =?us-ascii?Q?4LrvSI4hEvH6J/TFsWaM9Bdj0FmYQhx4cPN4PblZW/mFVR8e42K3s09Y831/?=
 =?us-ascii?Q?5g6rtbPWcEE6YqRfLRyCtPjH3LJLRiropnS4lxYx9b6J7M5WTS9oXoub90dw?=
 =?us-ascii?Q?BRRXP2ia4J8+iHh5VMT9/cTFkNTuwAZahQH6IUtM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 155ac044-ce85-4b87-e7ff-08dd5f739d62
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 01:33:52.4577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eo6cz0C3Op/Xuv2BOWNUgFgLQ8unr9P8Su5A4tNsVFo/RAkRBoWZ9dx88Em9KHmozOduxZbFAonVX8jqoHA2mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5084
X-OriginatorOrg: intel.com

On Sun, Mar 09, 2025 at 03:06:19PM -0700, Chang S. Bae wrote:
>On 3/7/2025 6:49 PM, Chao Gao wrote:
>> On Fri, Mar 07, 2025 at 01:37:15PM -0800, Chang S. Bae wrote:
>> > On 3/7/2025 8:41 AM, Chao Gao wrote:
>> > > 
>> > > diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
>> > > index 6166a928d3f5..adc34914634e 100644
>> > > --- a/arch/x86/kernel/fpu/core.c
>> > > +++ b/arch/x86/kernel/fpu/core.c
>> > > @@ -218,7 +218,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>> > >    	struct fpstate *fpstate;
>> > >    	unsigned int size;
>> > > -	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
>> > > +	size = fpu_kernel_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
>> > >    	fpstate = vzalloc(size);
>> > >    	if (!fpstate)
>> > >    		return false;
>> > 
>> > BTW, did you ever base this series on the tip/master branch? The fix has
>> > already been merged there:
>> > 
>> >   1937e18cc3cf ("x86/fpu: Fix guest FPU state buffer allocation size")
>> 
>> Thanks for the information. I will remove this patch.
>
>But, I think there is a fallout that someone should follow up:
>
>The merged patch ensures size consistency between fpu_alloc_guest_fpstate()
>and fpstate_realloc(), maintaining a consistent reference to the kernel
>buffer size. However, within fpu_alloc_guest_fpstate(), fpu_guest->xfeatures
>should also be adjusted accordingly for consistency. Instead of referencing
>fpu_user_cfg, it should reference fpu_kernel_cfg.

This is fixed by the patch 3.

>
>Thanks,
>CHang
>

