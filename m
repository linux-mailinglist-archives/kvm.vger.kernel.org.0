Return-Path: <kvm+bounces-62487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1BDDC4507A
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 06:37:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 891A5188E30C
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 05:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8C9D2E6CD9;
	Mon, 10 Nov 2025 05:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I5hdn3hp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F8A214812;
	Mon, 10 Nov 2025 05:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762753032; cv=fail; b=X1D5ghfbAS11c9Zzl9+Qqa95byROBV2D/w1o2ygdy18iU18xarm4+CLiu3seKIeIkeAxjOVGRlUKAdnyJZeMgRT/DxrzgyfIJZhDOePoRaUaOnZDhU2sgfZIfBT4TB3dB8UuNGkoTa24puvRVq9Wl+ehigDEYsiUzLgaERFBpTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762753032; c=relaxed/simple;
	bh=wqrwX5bEctnwvgC25Z+IdwzYCZvp0e0xFsurH8AaNOk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mXAJG7nYgOGUTS/C1YgK790y0u2vQT/13PVSUhWVRyccPlrOi/9TjMkXVvcA7hzU/qxRjP6E6BmKm6j7pEqeIeveC90TSXKtqo73WPtOtDpUZnV/PcFJaAccxfNm6IydiESkc1VuvAKJdpjgUh2Dd2XDifdQ3N4PBAdU2V/qwMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I5hdn3hp; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762753031; x=1794289031;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wqrwX5bEctnwvgC25Z+IdwzYCZvp0e0xFsurH8AaNOk=;
  b=I5hdn3hpGiyTvUc2Aa0WOOgJZbIUG+jw/3v6Sv/opoTEr3jvA+TfvwwQ
   prk20X2Ab8wseHN4vuDnWixcs0ucDqOiV3k51xtjSoidORRCwVPbkrgbp
   YzPVRX9lh2ywoBoM0uKQf3foKLlRGGzvfFFXx6ntd+5Sy2ljLABQPWmzh
   xRdkDgSvT5fNPDCUtGyUeIEUXzHb7mhIqJd0oe7N+lhjV11wH/cOm5VoE
   FciAUcWHHx5eZLQtxsdYdt+N5cTv0n2oGyfQGyWPrh/ReV1fNQlBbwTAL
   oCr316noWaKgqw1S5tat308rv5l3F4P3p1db8mYTOwQbrIV/YIraU1KR6
   g==;
X-CSE-ConnectionGUID: u69vr6F/SpObh9jffIc+Gg==
X-CSE-MsgGUID: WS7QYy9GSg6HAlM0GsrybA==
X-IronPort-AV: E=McAfee;i="6800,10657,11608"; a="68659609"
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="68659609"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 21:37:10 -0800
X-CSE-ConnectionGUID: KBF7G2CoR2id45z2qPlMgg==
X-CSE-MsgGUID: JLdyDxVFTGmhjHIE+LZQGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="193764768"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 21:37:10 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 9 Nov 2025 21:37:09 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 9 Nov 2025 21:37:09 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.56) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 9 Nov 2025 21:37:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HwClnsjI1mMMlJNNDq4e0GftB6dtbiDEzxdJNq9EhLs5urQ6szv/kvnt+ocd7o2MT1Arb9nedU6mdct3WrsrFPBIi1H61qM2L9efem7IjtDsk0oF+rCK2KLR/e/w5/zC/4LbOmMLp8/wRTXmWm112sHX90fVZIaRbZZU8pAdAx4dvk8pjchM1Hq0kdXuTBIjkEnqz8MSyO3hrZtusppRLn9pd1UkxAv9xHSAyxiHMZwX+ZpIQxja9U3eYu2tGW0jJ8/LuHkXxYyi5ZsZOL5Cdn0+9GztzAnkL11HbZAZIpCiaJF0V4AipsLqs2Ju655dhLStSv+WnNqljqonh3dIeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RnQyzcBoBJ76/XXoPxrZ0ksrySrSO16msCNPQUT16Cc=;
 b=INH14iVIKQiMFlQOaBI8H6yoBSeWZIaGdJT0ak53Nxr65nBIjjB4nK2k8tBvsSIPOuRcPthXKjDaCBhiJa1BubcZOszqK5UR0MVDmT5c+U4JADMbBTifv0neUboqyVkSmgMjYWkZ8Ip+3SU39r4Ijw3m7LDOGQhPPs787NTj/97tJp8pXGJ2/BF98OPuaNhPr9Jq7HMFuGssm+LQESx8tYvTcA3dvk9LMSAlCfEv+7kZcVaqJa1eKy5aYsryyZNO+7L/Zo+0PnmTKvfB31kepYo/hxLFzliaiuX6jwJDLDJhmv41KEjq5IcnFtZE1ZmO3CqXIKiUd/6mvBm91GzcZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH8PR11MB7046.namprd11.prod.outlook.com (2603:10b6:510:216::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Mon, 10 Nov
 2025 05:37:07 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 05:37:07 +0000
Date: Mon, 10 Nov 2025 13:36:59 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Enforce use of EXPORT_SYMBOL_FOR_KVM_INTERNAL
Message-ID: <aRF5+3NW4V1z8oSi@intel.com>
References: <20251106202811.211002-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251106202811.211002-1-seanjc@google.com>
X-ClientProxiedBy: SGBP274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::14)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH8PR11MB7046:EE_
X-MS-Office365-Filtering-Correlation-Id: 6afacc46-2971-4b01-b8a1-08de201b300c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?RTSbElVDLieEppz+aJUBUXNeLJUDcucvSGFVqGKAorKUhZ7ud9AoxslkVcRv?=
 =?us-ascii?Q?Zu0IGhoWol3VMc80tTxho0TyUNJqXrU9BmPUB6UbtpE2Cv5cUQXf2EXMXnGN?=
 =?us-ascii?Q?KMqN4ksQXYozHGlL+BwdLp6I3umGyC/HKjZjn87Q5Cku/aGKHzmzW0cf/zEe?=
 =?us-ascii?Q?mWlVbM8tXfNWfuSUWOVp11Nyu8XRn0t9umYqyIBQV3nRndZD8guokYs091Pr?=
 =?us-ascii?Q?5sSnina5QYLUDrqVUfAHVgujOI/FhVyZMe4TnsyNfuobqMs24etpFkkapcXp?=
 =?us-ascii?Q?ePySeYq/robh96RgzPMNv2EPcVb+1QcwV4NpVEPN8OK9m/wb3xtVyDho/v6q?=
 =?us-ascii?Q?LU3kHrdpUVpLBufGMeN0hllAG8cb6qL/Vmj3JPjj5jb+XAp/sKOMzawtcbQY?=
 =?us-ascii?Q?FRu9yi7fBX7pHntBWw1LOHi28Je18qLytQjFt/2C5l3LBoRn9Y5dSV7UcsVm?=
 =?us-ascii?Q?COZYPJjV18Me5/xgOO2jB1MihwB6oew+ASx+cdSy+5DdRqfT6erwRunnRCGt?=
 =?us-ascii?Q?YkRlhA0nMKVmnSb/lSfEwbgcpcLUh23gMOVHuLexSwuhRG1jZWAbFt4XyncJ?=
 =?us-ascii?Q?rIah0g8E9EJillUOS1ysYFYXHGRdr5Z1uC5QV7vFEknEI4vG7QFBtXjJwKBt?=
 =?us-ascii?Q?K8tXdV/CVFzgFWsK9o4vZv3XXJCWne+cLYfInALe+/SPCe7XY+i8WC1zPDNM?=
 =?us-ascii?Q?gDscUGEL1jCuBBxutJzjkReXMwRTUGas3T1azllMkjcOu/0LWZMg3m1A1pY+?=
 =?us-ascii?Q?rQEQLF7ItqfBUIgtNNgw6rNbTyfbtBNgQO6/qvate99GFGytQOzdQNWL4z2H?=
 =?us-ascii?Q?EqAWaCapxNtE6bv1FtzVgzYwKCKZlDlT+4BbvQeN71RqXG4/TRBlFFHakn/I?=
 =?us-ascii?Q?XEEYCqdjFjolgRnKU4bt7Pb3TNKL46up6k3GjxLi/O7lyLCa2yqbPErsWgep?=
 =?us-ascii?Q?7A03h7e2VHjRkLkcn1vZWNFJRyAsgjGIs24hhH4jrm7jfucVtPm89BVpYLzp?=
 =?us-ascii?Q?qhs1W9e/fyRVg87Gw7I5RE33iA94N7Cw6mEJy3rBa7YGS35iRLryzGudRQ3T?=
 =?us-ascii?Q?1OpPYp5BuZHZ0rpDqhOUOuo/SwUba96niVM6BqEsWK8zP4+sZOQv3U1Y96Gf?=
 =?us-ascii?Q?jKFIrPEx/pSnK3/91vlbmnfJOOvwQr9Gg3n32zGNfBXgF86FClRkY+7F7hHZ?=
 =?us-ascii?Q?+msS1sehDC2UGIHSVT1HiDUKzzJEFQu0pPUu8/ikDkvrmAzbAiPr+KELhGws?=
 =?us-ascii?Q?y2oJjAPLrUOMWZgo2L0DnTtpPZhItBVyoE5oMs1g5k/XOVsPvHXPM5/hGIXz?=
 =?us-ascii?Q?9IpTX7HPCG5OrEqQzKrFlYsMCOc6Liyb0NRC5UoaV0eBWIzNeQK57UwEcSR5?=
 =?us-ascii?Q?K+fep3umHy5WCp0URyf26JiTAn5g/hTd1SBfygowKZVygLjUSiviDdFKUebm?=
 =?us-ascii?Q?KaIMCWk8vnT9Iy4e+UNBjrf/G55ZxEGo?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+VPC6Ewo1utKdXnPikZtRlVNeATBpV0dloQ4uuhjrE1LRJW6TwwCl1hNhQjM?=
 =?us-ascii?Q?D86VOlE4mX+QEW6U3AOGHOps8jG5ZLk2VwjgHORTcwi3W8FnwUc2BJ2N9mIv?=
 =?us-ascii?Q?RFd/oK8e6VerPrOHaxONZtw6ps2KCeFbnDu+nJh4Jc9W1iROXlmxBpPmwNjX?=
 =?us-ascii?Q?KIRQzl1cAkA9r6pc11JFTY2zwsDYIvyxheNXUdll3PSZK47Gc0KiMcX74dn5?=
 =?us-ascii?Q?bHmDNbPdHYrQzSLjJjXXowaA27tESymza/6Ujn58QxEbWifnwQ0pwAUiajbn?=
 =?us-ascii?Q?5kd1vUxhPj0f2WkTHLefYgl2d+8o7opKbrE6Vm8uNpbvDDao9RXdgCbXoOaF?=
 =?us-ascii?Q?7p9F9qthpjsPgyS7w/9Vyf8XF3hkTrRECOpFDuoupOt7vlR8+hL9/dFIXl+T?=
 =?us-ascii?Q?B4zaS7LMi9wdhYVdRG7e9Vlm1UnmiiQa5C58nql/lMEvgW0dj4hlJUVkp06X?=
 =?us-ascii?Q?UlBLV1F8E92jditH1cQ04Z/w1urkMM/6rlkJ6Xkoj6+lyIg97Bt+w56nQZ/W?=
 =?us-ascii?Q?UvRmrsm+7Xk+t7YAdG8ttgfNI7M84iTTXU9yH5ssYfM6O/ZCsm9GM6wbwQA5?=
 =?us-ascii?Q?/WSyB3mzGQR81+dJFwJa5uZhyo14ZqoQ/ilYDqaOtZt4OY8+DfUseSwAnGDQ?=
 =?us-ascii?Q?iIjamEGEuVoF0KyerbT2z0GTPfpnSLICI+BgE1U3d4/G7wIQKeRMb90Vf5xa?=
 =?us-ascii?Q?JrPRlx9W/PJG8QljycE+sIGCQkYNvUEllqMb3XpVgDCXqdKPHSh0Az9Q1XOP?=
 =?us-ascii?Q?GTK+ql/HRaRvacABU9z2XcFpPsjSKmH8bN1fey0L4W0sm5nbkWHg0K6ADWZR?=
 =?us-ascii?Q?dKbknkcB8aITwiVCiOuBvqrIFvXWjLSHQ8Z5kzXm7FABiyAecK2t20dKRHNf?=
 =?us-ascii?Q?n67LvgrVEnI9bM/yLtB5VyX83EL/OKejLzzAuv/ti/DiaHfr49Xhh9kHq8Z7?=
 =?us-ascii?Q?XgTVUQwcRzSnHx6iHVy9931+F7UyOplcET1kPtYW4XqDF6yd0luKNHhXHOkP?=
 =?us-ascii?Q?VGNULvYcQyMEhhCIcegq8Wlv9oNpDsH8pNEro2aV09f0/IFS7Yd2aHM1ntbn?=
 =?us-ascii?Q?xywUXP2n1w1jMYWzO7x4g8LkkyyuckfpP3AsYlzU9c0VZYw5ft19IEcrYaoT?=
 =?us-ascii?Q?g7ZzBP+VK77bo6QZPJN/SDFA43uSRqnoxFR3LxpF5zs5pC8Z5A+snGbX7G2N?=
 =?us-ascii?Q?RYuomZDgDn36ViRlZnq4LWIyEE5fmUamL7YkJUhxlECTheDWs/FsuQUCgwNH?=
 =?us-ascii?Q?uM3m/lGVjPprLyw4jvtoYSAJQBtWcF+Qle2dIeADlQgDnu07JouFKj1P2Otn?=
 =?us-ascii?Q?sTwkR8YKqS5PDaGF4/+mprQ0hq7g4v7b43wZGgRicu/zEfPL37ahKWx56SP8?=
 =?us-ascii?Q?bwgFuQ34RaKGJ19qsIjAAWrJRk/vu6QzGHWywOrwWeJVguOHLkbjh3MGtJua?=
 =?us-ascii?Q?iMdTadoo2rwxNbb4Gts+si9zKG05BwfzH23/95Xykhc1mO4JAQPMXvh1mtTw?=
 =?us-ascii?Q?5lVsLkf6LY96RWKlunjTXRfoy2mn3MENMLRH5eHq3dY/3j0InelyXpQ1BLNC?=
 =?us-ascii?Q?AyYiH1HC38/Cc6gSQiEEay/uN39si6ePM3PRdOOX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6afacc46-2971-4b01-b8a1-08de201b300c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 05:37:07.7829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eHCRmDNwPehN56eJK44mCEJouG0Pprr2QMKZ2n6GWWXooIpesDc/FxmQY1OcCy4/tXrVyuqgyZHba4zpOROJpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7046
X-OriginatorOrg: intel.com

On Thu, Nov 06, 2025 at 12:28:11PM -0800, Sean Christopherson wrote:
>Add a (gnarly) inline "script" in the Makefile to fail the build if there
>is EXPORT_SYMBOL_GPL or EXPORT_SYMBOL usage in virt/kvm or arch/x86/kvm
>beyond the known-good/expected exports for other modules.  Remembering to
>use EXPORT_SYMBOL_FOR_KVM_INTERNAL is surprisingly difficult, and hoping
>to detect "bad" exports via code review is not a robust long-term strategy.
>
>Jump through a pile of hoops to coerce make into printing a human-friendly
>error message, with the offending files+lines cleanly separated.
>
>E.g. where <srctree> is the resolution of $(srctree), i.e. '.' for in-tree
>builds, and the absolute path for out-of-tree-builds:
>
>  <srctree>/arch/x86/kvm/Makefile:97: *** ERROR ***
>  found 2 unwanted occurrences of EXPORT_SYMBOL_GPL:
>    <srctree>/arch/x86/kvm/x86.c:686:EXPORT_SYMBOL_GPL(__kvm_set_user_return_msr);
>    <srctree>/arch/x86/kvm/x86.c:703:EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
>  in directories:
>    <srctree>/arch/x86/kvm
>    <srctree>/virt/kvm
>  Use EXPORT_SYMBOL_FOR_KVM_INTERNAL, not EXPORT_SYMBOL_GPL.  Stop.
>
>and
>
>  <srctree>/arch/x86/kvm/Makefile:98: *** ERROR ***
>  found 1 unwanted occurrences of EXPORT_SYMBOL:
>    <srctree>/arch/x86/kvm/x86.c:709:EXPORT_SYMBOL(kvm_get_user_return_msr);
>  in directories:
>    <srctree>/arch/x86/kvm
>    <srctree>/virt/kvm
>  Use EXPORT_SYMBOL_FOR_KVM_INTERNAL, not EXPORT_SYMBOL.  Stop.
>
>Put the enforcement in x86's Makefile even though the rule itself applies
>to virt/kvm, as putting the enforcement in virt/kvm/Makefile.kvm would
>effectively require exempting every architecture except x86.  PPC is the
>only other architecture with sub-modules, and PPC hasn't been switched to
>use EXPORT_SYMBOL_FOR_KVM_INTERNAL (and given its nearly-orphaned state,
>likely never will).  And for KVM architectures without sub-modules, that
>means that, barring truly spurious exports, the exports are intended for
>non-KVM usage and thus shouldn't be using EXPORT_SYMBOL_FOR_KVM_INTERNAL.
>
>Cc: Chao Gao <chao.gao@intel.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Tested-by: Chao Gao <chao.gao@intel.com>

>---
> arch/x86/kvm/Makefile | 56 +++++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 56 insertions(+)
>
>diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
>index c4b8950c7abe..357138ac5cc6 100644
>--- a/arch/x86/kvm/Makefile
>+++ b/arch/x86/kvm/Makefile
>@@ -47,3 +47,59 @@ $(obj)/kvm-asm-offsets.h: $(obj)/kvm-asm-offsets.s FORCE
> 
> targets += kvm-asm-offsets.s
> clean-files += kvm-asm-offsets.h
>+
>+
>+# Fail the build if there is unexpected EXPORT_SYMBOL_GPL (or EXPORT_SYMBOL)
>+# usage.  All KVM-internal exports should use EXPORT_SYMBOL_FOR_KVM_INTERNAL.
>+# Only a handful of exports intended for other modules (VFIO, KVMGT) should
>+# use EXPORT_SYMBOL_GPL, and EXPORT_SYMBOL should never be used.
>+ifdef CONFIG_KVM_X86
>+define newline
>+
>+
>+endef
>+
>+# Search recursively for whole words and print line numbers.  Filter out the
>+# allowed set of exports, i.e. those that are intended for external usage.
>+exports_grep_trailer := --include='*.[ch]' -nrw $(srctree)/virt/kvm $(srctree)/arch/x86/kvm | \
>+			grep -v -e kvm_page_track_register_notifier \
>+				-e kvm_page_track_unregister_notifier \
>+				-e kvm_write_track_add_gfn \
>+				-e kvm_write_track_remove_gfn \
>+				-e kvm_get_kvm \
>+				-e kvm_get_kvm_safe \
>+				-e kvm_put_kvm
>+
>+# Force grep to emit a goofy group separator that can in turn be replaced with
>+# the above newline macro (newlines in Make are a nightmare).  Note, grep only
>+# prints the group separator when N lines of context are requested via -C,
>+# a.k.a. --NUM.  Simply request zero lines.  Print the separator only after
>+# filtering out expected exports to avoid extra newlines in the error message.
>+define get_kvm_exports
>+$(shell grep "$(1)" -C0 $(exports_grep_trailer) | grep "$(1)" -C0 --group-separator="AAAA")
>+endef
>+
>+define check_kvm_exports
>+nr_kvm_exports := $(shell grep "$(1)" $(exports_grep_trailer) | wc -l)
>+
>+ifneq (0,$$(nr_kvm_exports))
>+$$(error ERROR ***\
>+$$(newline)found $$(nr_kvm_exports) unwanted occurrences of $(1):\
>+$$(newline)  $(subst AAAA,$$(newline) ,$(call get_kvm_exports,$(1)))\
>+$$(newline)in directories:\
>+$$(newline)  $(srctree)/arch/x86/kvm\
>+$$(newline)  $(srctree)/virt/kvm\

any reason to print directories here? the error message already has the file
name and the line number.

>+$$(newline)Use EXPORT_SYMBOL_FOR_KVM_INTERNAL, not $(1))
>+endif # nr_kvm_exports != expected

nit: "expected" in the tailing comment is not defined anywhere; maybe use 0 instead.

>+undefine exports_advice

exports_advice is not defined.

>+undefine nr_kvm_exports
>+endef # check_kvm_exports
>+
>+$(eval $(call check_kvm_exports,EXPORT_SYMBOL_GPL))
>+$(eval $(call check_kvm_exports,EXPORT_SYMBOL))
>+
>+undefine check_kvm_exports
>+undefine get_kvm_exports
>+undefine exports_grep_trailer
>+undefine newline
>+endif # CONFIG_KVM_X86
>
>base-commit: a996dd2a5e1ec54dcf7d7b93915ea3f97e14e68a
>-- 
>2.51.2.1041.gc1ab5b90ca-goog
>

