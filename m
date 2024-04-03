Return-Path: <kvm+bounces-13424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FD628964EC
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 08:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF7CD1F23A8A
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 06:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F4352F92;
	Wed,  3 Apr 2024 06:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="STKhbPNW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A81D17C64;
	Wed,  3 Apr 2024 06:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712127087; cv=fail; b=PghD4K07LxKaq9QsjyOcI88mKLlIoh6+nsE5inbzn//SRMuk2pCqcPManad+V0maCUkdPhWjIhLQIDmEm21EvqSEyoxnp9otsaNnpMFSMUnZ+L5xgWkofJIkfgCHbjv4YecOngrw16oRVERj5+Com+OOEK9veo7fxDk4krV9EXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712127087; c=relaxed/simple;
	bh=Vn6eG6GV6uXVG3Y27duvY3JOtVj2+JpH8d060mf+nBY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=f+KSiZ3He7Rj4adoweC9Wq4pvXrxvXwMGHHrkqpMRwjAN4D0ns+ZlPXqMY6j+nVC+tZLKSzvVVW2oYGT2V+wsk8oCprdw+pEM54ta8Pq0sklIAMBA97imyrVaq6nDug8VsSNBGm/qM9hlgV9s9uCBRyajMn+eZCEdehUEjyH/M4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=STKhbPNW; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712127085; x=1743663085;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Vn6eG6GV6uXVG3Y27duvY3JOtVj2+JpH8d060mf+nBY=;
  b=STKhbPNW+lGsGfxoXvxVY+TjL1AhHMb7QkmgSZkvocbRmmy5IMi4SdHS
   PzEjHwafCJS2IIZvOatQ5lyugvDtIMuNn7cr4Jm55geMwME0u0y99LL/F
   rcucDjvPcNQ/5Sl1uoCAcTnU5MHbZMaF7jYGwaXXxETg7bd/4ewLV8jvl
   vJKirH655IFvGlUr6S0hxRPJJ/KKuVXsk5Co6y24hRCHNRpiUub7SWXZJ
   etad+j8JV9ASAzYlYrUdx8vhvGH4wPXmDxkj2WSnQmziZwteWukr0oiyY
   QKkfbbNhzwvjGFmfQZRzsques9tKBhVXQvUPIKVfnbzZIkUVR/vHyRou9
   w==;
X-CSE-ConnectionGUID: ZwZLmfqOTBavExQJv6DNTg==
X-CSE-MsgGUID: Bv4JKjerSPWKIEbANcX5XA==
X-IronPort-AV: E=McAfee;i="6600,9927,11032"; a="7527427"
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="7527427"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 23:51:24 -0700
X-CSE-ConnectionGUID: 2gPBTUUqS/ybHJ4vg16elQ==
X-CSE-MsgGUID: 7AbJhHnnS1uEJ75VRQn3Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="22806315"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Apr 2024 23:51:25 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 2 Apr 2024 23:51:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 2 Apr 2024 23:51:24 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 2 Apr 2024 23:51:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ia/MrmgAKTHuaTqXvU5W4YZBpBTNo4+4dujdbs4cVSTcRtIKXLwIGoGB7fP/+FpZimGhRr38pAch1IrRp3UnEmvP9d61pC9ogzUmNc5X/GAQ5gHPJzFZPZLCiag4GLyiieaNFQB0NqxCG7LIPtpqL7TeVkUHBLHstijqt3gko9QE2OyKU/qEblszb2yXmisUkHIkivvtPu4pbWSpzBvwC+XnhG06+MWEgwrOrSxaJvo8CoUfOnBhfEhfi7yxdaTLi1LK6RqK3hgw2AcMAOaD3QEeBbNDHG9RcAYXsUrk9IlGRWnhwF/t4JnaDsaqKlVwdGZTVMiF5NDgLcVbA3a3BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ljuFXk3sg+sT1aKIf3L4oQ+I3d4isl8pkASXLO7T9l0=;
 b=lUSf+bBBWMvwOXUxhbzxHky0PYjkNJA8ldgT5daoqunhXXEIy96I3fhoiEQu0u8wo8Fhunzj01qKgE7e0OYHr57JOBsafQtPtEif00sB0mIcJ/fixj6gHqIobbx2QXvF+wO+mRXRoTQEN7PYEgHfIsAF6/KTpRC3joPEaILEKgaVAw0dub3oAsogQ+pSOuKckhh/Lg5W2G5dGIEjGL7bwlEBnfiU39Zv+WYvvjFXoMg1iZ12FKhYXfjC54bF2L/fSwp/qFj+lNuCGi5yOEsRMcn5DXfk5R1b7QMUtZ3vJWVM8SLsUg7IFw5UXSHMDlGSDVPCXQLn4fy1X93VFUpPDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM6PR11MB4722.namprd11.prod.outlook.com (2603:10b6:5:2a7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Wed, 3 Apr
 2024 06:51:22 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Wed, 3 Apr 2024
 06:51:21 +0000
Date: Wed, 3 Apr 2024 14:51:12 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 111/130] KVM: TDX: Implement callbacks for MSR
 operations for TDX
Message-ID: <Zgz8YFgD1CysKaDl@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <62f8890cb90e49a3e0b0d5946318c0267b80c540.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <62f8890cb90e49a3e0b0d5946318c0267b80c540.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SGXP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::21)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM6PR11MB4722:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: plrU8px1iu30Uy9qu1xeNSfxXFMjwxI8OkLd+mQkasBsZ1H+FddXwoicIETDY2Q/NYzUKP2zNAguSFeMkFxAVqNqM9ykCZbGfpx0padNtRqlFfghZxNVVbSaMF3jTUA8I0KqxW2tSOoPAc6Oy4RgXMMln21kd1eXsuFh+zmA6NrCbcJ/7LsbHlZAAIhhxUjV/MpdeMyVobcj7g3A8t/pAgjd1SPT29QQZaO3/n39GUGFjIWJz2b8P/8tCanKiQNN7QWqwr2GoKxzs0Abn96C3JIQvNXfJ/8gLT2LUkuaC5O3O15VVfK6NW9W+D1/oTQrEM9bvji5Xqef1h868ew5NweVfrCqZxO1L1/CsYEFG7wnN68BTsqDNu80FO5kHbWIyzgs/NzFn5TKjP8ttEaJk9gFl/+RZAuJnil0RE9ADB894j1bGp88Qfj1v0fKuaNbiUN21EhXqZ9uOV82X4+A6CRaQ+kmJxh2ThZKCgZtWR8Tr0VXbdufgfZylw9C1JFwIrA7Yoq/ZW4od7gGB9wHdY7hkwwsO6LzHqt2qRztZTEThq9fcD7GazBgeyJZaK//KHE6lwy3+BTR1yhqWgHM4Aplqr3jmnIaNiZP/UwgF7S5vWNwKJv59BYksvEFPpnyoApf8XR5uugok6BjFd6XGmLSJ8CwlP1wCbTic95PLrs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NYIQh19u1X5jWqQHXGLIU1+SK/dP2x2QV4rEz0ZrzGOf4rUgXzx/L7io2xAh?=
 =?us-ascii?Q?hs3kKOO5nfSJ8SW2KIaKQzGnPNz26r26dCAbTdJLJmjpnguCGvJ/bvFHHXaP?=
 =?us-ascii?Q?SX0QC0de0t56Zz0Fdu65cRlQdUF+RgfOtaYThSuKCY7utWYYmjo8Yxa624dA?=
 =?us-ascii?Q?usAFv55jtsZu4J7r2Wd9jLZeXzJAwVssTonGZ/3FukCniP2H1WgQOO0gYwou?=
 =?us-ascii?Q?ADdMa7kWvkEzCmAJBiJbkf9P1l9cuLmAq0hkKbu7XhPlqE+UsQsEbKLZZQ9Y?=
 =?us-ascii?Q?owXNqnKjCBo1kMEfDMpVRl8FllffA7SOnIMyoa+Jjs8vO2Sfwt8Vj+8m5f2h?=
 =?us-ascii?Q?UpX2DiZZrFliLIbQHLlWKbza13FJe8WfJ5npiMPgOzi61zf8T0LotYt5WdPE?=
 =?us-ascii?Q?MoXWxORC39HZqPg8miD3ggAlW5VhzvY0gPIBqzGFmWxE6UmRsvINS8Cnv6mU?=
 =?us-ascii?Q?YfXtpvzUwnsJ6oj88o2puokE+3WbV9/l4xSqIgcqijTz00pB3oF8Rz56og1/?=
 =?us-ascii?Q?Jor0fLOvtOsfoMAjg+fxFWBoICFWEH5gNRtD+fdjVCFBpagmuK6RsAvhL9Qs?=
 =?us-ascii?Q?+7pLq3GnuXsw1DXEpdCXAs32JgtJ59E7NmTX3MPliw4hDHP/j4KpKYZ2eNNx?=
 =?us-ascii?Q?buo2U1tQAUfVg2B8NRLOV6lyqjT95R3E8uxvgWSPcPG7cUWsDB3TK3/brNDB?=
 =?us-ascii?Q?VpTwapwFQ/n1ysPMBacdA1BWSrIaSn8oPzQtjP/O4zZLfi4pLaNCCUrQ8YeG?=
 =?us-ascii?Q?iFy7KY1YU328zG9Y/xQe5M1MScI//NjASu4Bo8lGnILpKIjMGq4DOc4A3uuT?=
 =?us-ascii?Q?BRDNaaX2JSJirdCJI5kcJAMMDfN76M5H3Rd53OXV549kF+BWVocudQ8jFWji?=
 =?us-ascii?Q?ZamBN3RX0hzl3brj66viLnolxMrJ57s5mEmDpAOhmUBrX6BVj/FXPPct85An?=
 =?us-ascii?Q?b6ONIhdfdnHdMaSMcuEPB3XQInIWCJ8gCoDFTQSBb1IVrs478BJAYZsKawm1?=
 =?us-ascii?Q?x1Ls9p8YfGz9TgEy1XVz6hAaGVhNn1AiOFPgRieIBHFt8ab+l2tfIZG5Ctq3?=
 =?us-ascii?Q?u1jrPzHaN8aINRU5gWc+ox6l79xqKBzlw5g69BoizQaE54yEysHXYRfcbY6e?=
 =?us-ascii?Q?9FSymqvmquADVHJrBAwpNizhxqWcSBqNut0Ny56x6Uq3HAMUKrqDQ3grxds5?=
 =?us-ascii?Q?XesCJXKJ7aaLvYGOMjaL7L0cLPPQKosOE7DWC+Jyc+e2+ruxw9ju/rZpDoJj?=
 =?us-ascii?Q?QJ5zHFYm65FLROmlGmATAj7f1TvMIiROYm1KIuToB08JpXu90DNxrNrbgpNH?=
 =?us-ascii?Q?PlUf/fqFUAgADlnZTNgCmm+mCJhyAmse9A+wEd9SEgXzegiT89A96kjaLPN+?=
 =?us-ascii?Q?AjByMFoh/l91UCWQoGRGHgkH1lIUHOSG2L1NwM/j4JLJTjguXORkA38/TWSq?=
 =?us-ascii?Q?QaN1XOMuRW2Oa18UoOl/fMOD1gHxTEl+9uu0NAVtRTLVuE3KP0b/VsBW+8MX?=
 =?us-ascii?Q?mNFyyv+j1sUmPgcVcOQr4elSx/tYsYvkYoRvyJBZdXlmqrP90eMHvCdOz80S?=
 =?us-ascii?Q?MVe4H0vEfqhDszVFBQ60SKbts0WEBkyhekhUs9uH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bdaa8675-1821-43db-3e61-08dc53aa78d6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 06:51:21.8123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o2bhvRwLYvWDT5c8rEtqZ5go33pJVRu9bGxIZHNUduLuiKT+fUeNU4Zm4qYPqQ5P3jyookDITYj3S3jEI8t7Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4722
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 12:26:53AM -0800, isaku.yamahata@intel.com wrote:
>+bool tdx_has_emulated_msr(u32 index, bool write)
>+{
>+	switch (index) {
>+	case MSR_IA32_UCODE_REV:
>+	case MSR_IA32_ARCH_CAPABILITIES:
>+	case MSR_IA32_POWER_CTL:
>+	case MSR_IA32_CR_PAT:
>+	case MSR_IA32_TSC_DEADLINE:
>+	case MSR_IA32_MISC_ENABLE:
>+	case MSR_PLATFORM_INFO:
>+	case MSR_MISC_FEATURES_ENABLES:
>+	case MSR_IA32_MCG_CAP:
>+	case MSR_IA32_MCG_STATUS:
>+	case MSR_IA32_MCG_CTL:
>+	case MSR_IA32_MCG_EXT_CTL:
>+	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
>+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
>+		/* MSR_IA32_MCx_{CTL, STATUS, ADDR, MISC, CTL2} */
>+		return true;
>+	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
>+		/*
>+		 * x2APIC registers that are virtualized by the CPU can't be
>+		 * emulated, KVM doesn't have access to the virtual APIC page.
>+		 */
>+		switch (index) {
>+		case X2APIC_MSR(APIC_TASKPRI):
>+		case X2APIC_MSR(APIC_PROCPRI):
>+		case X2APIC_MSR(APIC_EOI):
>+		case X2APIC_MSR(APIC_ISR) ... X2APIC_MSR(APIC_ISR + APIC_ISR_NR):
>+		case X2APIC_MSR(APIC_TMR) ... X2APIC_MSR(APIC_TMR + APIC_ISR_NR):
>+		case X2APIC_MSR(APIC_IRR) ... X2APIC_MSR(APIC_IRR + APIC_ISR_NR):
>+			return false;
>+		default:
>+			return true;
>+		}
>+	case MSR_IA32_APICBASE:
>+	case MSR_EFER:
>+		return !write;
>+	case 0x4b564d00 ... 0x4b564dff:
>+		/* KVM custom MSRs */
>+		return tdx_is_emulated_kvm_msr(index, write);
>+	default:
>+		return false;
>+	}

The only call site with a non-Null KVM parameter is:

	r = static_call(kvm_x86_has_emulated_msr)(kvm, MSR_IA32_SMBASE);

Only MSR_IA32_SMBASE needs to be handled. So, this function is much more
complicated than it should be.

