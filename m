Return-Path: <kvm+bounces-52712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1BB5B08762
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 09:58:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6EE294E5C99
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 07:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C32E267F53;
	Thu, 17 Jul 2025 07:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YIey0xO2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878CE1E5B60;
	Thu, 17 Jul 2025 07:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752739075; cv=fail; b=PsKmvn/8g10IRfaPhX9MPlRLKOApIYhbQwQM+eCAa5ysPXFo6FQmNIEt2Ll9fhDKhqspO+vmKaLziwbty58O4P6H4BGU/YP66P8hn6flQdS6iV0TZ+Ar1ws90h/IAUOrrPiaq1k8zVcXGWdqZXXjF6H4w1FV21AyNWeGBzcnvLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752739075; c=relaxed/simple;
	bh=nLQ9EPavQPVe/ud5dZMt+a4brHz7hHpB3ISTlw2ffdg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hD0u4P0IHfRL+bQt8ankEPmCh+bpv4v0VdC4KabHqv7n8ZXIDcM0tFPUDF8lsm5jhRxcO4UKAbO272m0KBhKd/MQ680qoK/XQ5GPgl8XYNwUmzdAfQV5Ahi4FFK6yosKY/rLJAPAocQXzC4ctnfV4d5urAs+ZMDdjmPs6GJhvP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YIey0xO2; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752739073; x=1784275073;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nLQ9EPavQPVe/ud5dZMt+a4brHz7hHpB3ISTlw2ffdg=;
  b=YIey0xO2cmBHMDAzXM9KZzV6ZY1tP6VEWSBzawV+Pj4sSpDQvWZ7rosl
   MP7KDL9NPBvXhy9tOIpyw/OGj1/kZ8INLrrkh1MAVAUpTHXKrwPpTzvyL
   OzVmU9NGwEPhnaety5Bg4ol7isePK2s1yHOu5wUTpcuEWAhMv2CxTib5m
   xGdSXghvDEA86c4J7KYBy0zVbXo7yyNFe8FQlcsbeIYyDWJejbl+kMn6J
   8fhVjBA4mJOlUiVAOi15xgxWKQ+KlKmKlVFO8T8fiZ6sNWKfVnSKRsenF
   tOKXNsB/AS/YpWp95dKiB0VeDr9+u9YXqW5dnY9uAD/DP6s9cvCvWZRFL
   A==;
X-CSE-ConnectionGUID: 6tnfx7R3T0uRHAqQW9LPKg==
X-CSE-MsgGUID: O3NRm9ttQIiosQSKGc2xvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="72570132"
X-IronPort-AV: E=Sophos;i="6.16,318,1744095600"; 
   d="scan'208";a="72570132"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 00:57:46 -0700
X-CSE-ConnectionGUID: 03V/kVGhQwSaZPQxsNg+8A==
X-CSE-MsgGUID: 3XBhE5qWT1maMYLH24mC+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,318,1744095600"; 
   d="scan'208";a="157100547"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 00:57:45 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 17 Jul 2025 00:57:45 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 17 Jul 2025 00:57:45 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 17 Jul 2025 00:57:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qOXD/YiWFeQzAEEt0ZVzKeBw7xqPm6FYQPJdI+D95RIA9YxeyJ6TN2fg+DGlhzaBpr/tlfkqnc+Y1UNmjsVfO7sXou9oR7VpQGuJA1KijEP71HGRp12UvthypNVUMHVvDcBgEJbrIb1oJxU3y9XtN1rAsllzhvs1jy16lSWsT5wymS0q/vPD4cutvy7dcR0NhHlwhqedgPxtbLKNl1wJIWWyPylY0rPJomsPxDXgnRMatgcEJ30/q3q6rrn4UqUBUQyI20ZEQE3+ADIjoNopOOXSLbCrkgCmthT7EqQnx50eBeKm8QN7f66OEx6bSzOyMHR41n0ATqLR+iEu6ynmmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cNuDKZikt+Z3NYTz3rCVm037kCDuIpUhK0kboH90nTs=;
 b=wHlpG4EXCmjSqlBW20oTzmZ/Z5WsTouXVx9fPhinZrn7UGdcHdnv/nIUReTqniD2sbW5YnLbAQ11TmlZPiCyPETpaiMigyZ52a5dBWic1xIwcA25tBPo6J+MIet0AoMZMmHZBxWP0bM/cKNEld3OJhlv96LwsexnlZ8bmhf8I4HRJp+8ZWFsktMI0T5IBjDhbj4ojOpr2XyKrQ495s8icIIGS6Sb5SPw1z8gQgAh90TcTpSbEKvCfJxeS0e/b/7WSsI+RaFFzvsSpXeHQnDnoj9DsAzpDH295AiFFmI/VHYLT8Oy4tsJjZjSH/j6mfzAd6xoOGYRC+sBvA2CKuO3sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB6806.namprd11.prod.outlook.com (2603:10b6:806:24d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Thu, 17 Jul
 2025 07:57:16 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.8901.033; Thu, 17 Jul 2025
 07:57:15 +0000
Date: Thu, 17 Jul 2025 15:57:03 +0800
From: Chao Gao <chao.gao@intel.com>
To: Mathias Krause <minipli@grsecurity.net>
CC: John Allen <john.allen@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <xin@zytor.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v11 00/23] Enable CET Virtualization
Message-ID: <aHisz7hU0VGsf78Z@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <88443d81-78ac-45ad-b359-b328b9db5829@intel.com>
 <aGsjtapc5igIjng+@intel.com>
 <aHgNSC4D2+Kb3Qyv@AUSJOHALLEN.amd.com>
 <faf246f5-70a7-41d5-bd69-ba76dfbf4784@grsecurity.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <faf246f5-70a7-41d5-bd69-ba76dfbf4784@grsecurity.net>
X-ClientProxiedBy: SG2PR04CA0152.apcprd04.prod.outlook.com (2603:1096:4::14)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB6806:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dbe5c76-610b-4e6b-f3f9-08ddc5078b99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?PQLwg0sRb2hEAL486PJWBgvPxYM2b8Ic4FkfW/n5EiO3qVesRX/g0wS3CdOw?=
 =?us-ascii?Q?ni28wp7N4L2RzBznZnfI12Bcm1uwMMq5W9b+FxVccCpaiNrUvfsKk7gBBFCi?=
 =?us-ascii?Q?5TgF9SZDQ+490AvvkykQXwO11WrPAjWTyAtxhGsVNwVC5hNqL2wbi5cjeFaM?=
 =?us-ascii?Q?mxSgKOdyzUBoxxI8anR/DAy3m8MErpTtLsUdrYNQTWc3k/s2tWBEzAHbeSTX?=
 =?us-ascii?Q?A4o9bwF5skSaCgc7NJyWGnaBjn+YNAqPg7shs5PRcdhgJ863LHej9L29ah8p?=
 =?us-ascii?Q?Hla8BfodRfwb/i+0IAyk5rq1aaT6FnDr+YoE8iAxh6iFt1f3GIe6JM/FrFNG?=
 =?us-ascii?Q?Bmb8r5sCZjtdo3SPDIerekGmlfFA3NIrfp1mIRo/wQfsChqAdEB+pgQgZtWV?=
 =?us-ascii?Q?FaPenFqzVw2IEhMeX9tkY4Y79/ayhBQ9e++Kk/fgvoHQVt3lkHV+W6bj9i6u?=
 =?us-ascii?Q?2XXQHBWTxstg8FfCuvrY95Dqq6lKXa/BmlhT2stNOTKT59q2ecscpLludoFC?=
 =?us-ascii?Q?5jKo2axDz6PFOfQxF4mkW7+rRIZu/HkxcfGN9WhSh0HVmf2UMMEhN7Mwf2oy?=
 =?us-ascii?Q?2hIIvLbF+VnSuWHnoyK8g/o0TRLf0enLa0PfhVtm50g/7t6HyVDJ8WbhTnEF?=
 =?us-ascii?Q?4caNqyPsMZ04pr9jaVT85S6ok7uAuK5pelL7gUoz8Qhcz3K6JG0waNoS4/tC?=
 =?us-ascii?Q?/vSL+Bq9faPbL++FK78RCJ9n0BQn8gQngXtyySicPzDPy+KjP5LYkGu5mrj6?=
 =?us-ascii?Q?pJlbmSddFPR2YlrqW7nZESIusAvxZ/qhacMBoSyGAEQQDNi2u3BVIS8SvNGx?=
 =?us-ascii?Q?WwpQh2Y80YscByqwqxKO+yPYhQIPYVYjOYWpUhHfiNivt4PhiSO567OIRb2K?=
 =?us-ascii?Q?ROK7tlL7mNYhKInQL0V1m80c3/XUAXPFxR1Zx8CB3RL7bx4zCE1vWbENNvAI?=
 =?us-ascii?Q?yPaUKl389St1mUv3rh735R+SUfSHHDv55r2yS6KjaQcCg3W7/60EmcqmDlnA?=
 =?us-ascii?Q?2YE26j4Be6HpqC1Hs8Ce4UDuPOYVfuRe8pPz3qfDqnwt55oPie0SGyxJbv/z?=
 =?us-ascii?Q?LVXJnOOlSEXDIVWOwxDInwOKCdMGZvj6uTeWWEnhwsPVtTzz/vwr5S5aHq7D?=
 =?us-ascii?Q?aFxoGL+gEx84idK8Duj7Om5+Mifcz2Drcf3XA+liivAi8TwyYn9549QCuR3J?=
 =?us-ascii?Q?l6yonM1Da1VH6tRylZb+KqNfUbPa0kWT0leYhZS+6gPng1fMfo7CHPCs0Z/Y?=
 =?us-ascii?Q?57TnG8c3XCyvTHrG/51tMEsjH5h4e/ZJC9/cqSDhZFhrJgcpNZjPoVSNKS/g?=
 =?us-ascii?Q?RpvPtKFo1I0eQV2sWxBzEhoMXdqN5eApj8L/4wcGAm4od+KUTwbJo2DdM2V3?=
 =?us-ascii?Q?Qvic6hd9niqB+FHavi573/8YwUKslNo1ugst8iDh5GkjotUi51qTgI9DuvYK?=
 =?us-ascii?Q?mqsKYa9Awfc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tve3oBt/nWE5xhxPdusW/jiVor2svZzcCMUUebsfnI9ej5CIMQD02OSoBhzO?=
 =?us-ascii?Q?4Qw5MkqbYODo4ebw7b48EeGmbBwldd4GSDId8MAiMfLxS9ltU4SlSVr7uu/N?=
 =?us-ascii?Q?ldIDziV5UragQDFVfDhxdqdGNd+jYuDRw0Un2u0btQRjr0WEdaAAO7rXb5Hx?=
 =?us-ascii?Q?rgsTtwMcJoAuEKQ6EcSSFZdHDtuCd2vezyT3+QOwIiHZki7iChMbY2yJL/pz?=
 =?us-ascii?Q?pIQ+OaX+HKB/Nzt50ABLzfWKhJZ7NW2okoO23Gzly73GDM8BXqkxz9h9lC2q?=
 =?us-ascii?Q?0tUriG02SxVlP9bsuqjaC14fcXtNviiNX45pK+1j+gZpwX2Mkc4TO9XRkQGJ?=
 =?us-ascii?Q?Npmvu6ptU6z0oE40VPQZbqcAOeZcb5iEUJqFE67jx65xapuJBuSNZnjDZcBx?=
 =?us-ascii?Q?+1ToAEXWwscckCIQq6oCu2FBbCy8kLgN5QjOfjBcUJG+YwQ7G4YwnoH/MD+E?=
 =?us-ascii?Q?lkv5UJKc8Vv+luflXZz0cVv2aK9KoE7k1A/XHYExFw5jS/DP3R5RhmCVPikS?=
 =?us-ascii?Q?sTFadoMA/v4ebxp0vO6q6ckkdNo2EMzKW+ANNF25Iss4MI6m+zjLMGHLe7sh?=
 =?us-ascii?Q?dRE5kVtZ7SCQ3zofvciBe3ZlLbwrENdRUwf7+t3S8LwE06I6ea8EQppRsFOv?=
 =?us-ascii?Q?qP8B21UDCYIZPN8ca2e8Q8m5tl0JZqNEHkW1FARrGEyCY/T8C9WO1RkGVmVA?=
 =?us-ascii?Q?rAEV0hH2RmYUpyDLR2p2Y3Mvu9s+ZpDJkrmQu9NBB2oJ9vPPCk9tP9UnB1sV?=
 =?us-ascii?Q?yAcnD3NikTXWUC7lfFKspeEE4642Jy8Rwmt0NNkGQBONklWx+IvQ53u3LnI3?=
 =?us-ascii?Q?O5nlZevTbhqzL0RWjuOeB06BdXVnGk9MHcKpMrGqBCy7qwtBfKQ4U7WiTZPa?=
 =?us-ascii?Q?dxXv3iHSZ9LQnI+ysU2lzHjNSvg7Ki6Pd8JjOrVGGr3L8vE3gVskoSEIoVt1?=
 =?us-ascii?Q?bTL7xFB0h3W5RubtpLFd1+bV5j3Lzk/hwfastJpWDn/wEHrqmxpo+ctdrHFf?=
 =?us-ascii?Q?VajCfujzSZ4JRDCWkwQ6H+d2bx8boQ1tTVP2x1qdVnaVliGnWa5aaCvrnD8g?=
 =?us-ascii?Q?Xc9dp1AUu7297MVt+1ts4gMRQXTaQn81fo6YolCWLqpYb9vasY2VvSo4rHJn?=
 =?us-ascii?Q?V+xxJohlE4kQ0kkQpkwz/sEtM7eA/t5SmE2qUOMWBgG7tKk/Dp5LdqqkOqKI?=
 =?us-ascii?Q?+ARArEYhXOfl/Pbvq0PUufjV4+7oytDIVWLx5/IQG12SN8Lg/PucDI5nmHHi?=
 =?us-ascii?Q?7QJ/vMdxMMZ9RPzSRRD+bCivlK8KadB4r3MXE75T/Oifv3t0Y7dApPC+deDs?=
 =?us-ascii?Q?khuUBpqlfpOmPGJJiBcJmxb+z/wEEsrBCFgUJuNl2HDNy2GXy9oSZX8v2idj?=
 =?us-ascii?Q?ZQM/LgvlqJPEtsPx4ID20mh9wDaaxmuoYJP2wY7YAgLG5VDAg7UmzGNIQmX4?=
 =?us-ascii?Q?Li3xPqy2MPDbmPt/AOaj2EL+sKehd4I9x4vFa2pk6Y7WDwfCxx07XtExLVHv?=
 =?us-ascii?Q?xaIDRAdNG8Os9XddQQh+IL/XRiiwWsYD48SAD+C5isCcXkRTRTLmYzvtNdw5?=
 =?us-ascii?Q?6VWa7mSCHwRjiQ0bIcmxWSbgVwconPcrEULCYOX9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dbe5c76-610b-4e6b-f3f9-08ddc5078b99
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 07:57:15.7734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XmAifwVayHLESmbkPlFxHHrYYJWCUo96hlaUXgoNcLonXfmVj3OItx696LnGHnciq0GCs8yRi+97o6QcAH2iig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6806
X-OriginatorOrg: intel.com

On Thu, Jul 17, 2025 at 09:00:04AM +0200, Mathias Krause wrote:
>On 16.07.25 22:36, John Allen wrote:
>> On Mon, Jul 07, 2025 at 09:32:37AM +0800, Chao Gao wrote:
>>> On Mon, Jul 07, 2025 at 12:51:14AM +0800, Xiaoyao Li wrote:
>>>> Hi Chao,
>>>>
>>>> On 7/4/2025 4:49 PM, Chao Gao wrote:
>>>>> Tests:
>>>>> ======================
>>>>> This series passed basic CET user shadow stack test and kernel IBT test in L1
>>>>> and L2 guest.
>>>>> The patch series_has_ impact to existing vmx test cases in KVM-unit-tests,the
>>>>> failures have been fixed here[1].
>>>>> One new selftest app[2] is introduced for testing CET MSRs accessibilities.
>>>>>
>>>>> Note, this series hasn't been tested on AMD platform yet.
>>>>>
>>>>> To run user SHSTK test and kernel IBT test in guest, an CET capable platform
>>>>> is required, e.g., Sapphire Rapids server, and follow below steps to build
>>>>> the binaries:
>>>>>
>>>>> 1. Host kernel: Apply this series to mainline kernel (>= v6.6) and build.
>>>>>
>>>>> 2. Guest kernel: Pull kernel (>= v6.6), opt-in CONFIG_X86_KERNEL_IBT
>>>>> and CONFIG_X86_USER_SHADOW_STACK options. Build with CET enabled gcc versions
>>>>> (>= 8.5.0).
>>>>>
>>>>> 3. Apply CET QEMU patches[3] before build mainline QEMU.
>>>>
>>>> You forgot to provide the links of [1][2][3].
>>>
>>> Oops, thanks for catching this.
>>>
>>> Here are the links:
>>>
>>> [1]: KVM-unit-tests fixup:
>>> https://lore.kernel.org/all/20230913235006.74172-1-weijiang.yang@intel.com/
>>> [2]: Selftest for CET MSRs:
>>> https://lore.kernel.org/all/20230914064201.85605-1-weijiang.yang@intel.com/
>>> [3]: QEMU patch:
>>> https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/
>>>
>>> Please note that [1] has already been merged. And [3] is an older version of
>>> CET for QEMU; I plan to post a new version for QEMU after the KVM series is
>>> merged.
>> 
>> Do you happen to have a branch with the in-progress qemu patches you are
>> testing with? I'm working on testing on AMD and I'm having issues
>> getting this old version of the series to work properly.

Hi John,

Try this branch:

https://github.com/gaochaointel/qemu-dev qemu-cet

Disclaimer: I haven't cleaned up the QEMU patches yet, so they are not of
upstream quality.

>
>For me the old patches worked by changing the #define of
>MSR_KVM_GUEST_SSP from 0x4b564d09 to 0x4b564dff -- on top of QEMU 9.0.1,
>that is.

Please note that aliasing guest SSP to the virtual MSR indexed by 0x4b564dff is
not part of KVM uAPI in the v11 series. This means the index 0x4b564dff isn't
stable; userspace should read/write guest SSP via KVM_GET/SET_ONE_REG ioctls.

