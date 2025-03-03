Return-Path: <kvm+bounces-39840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F76DA4B5CC
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 02:31:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FECC3AFC9C
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 01:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A817C13BC3F;
	Mon,  3 Mar 2025 01:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WbJ8MDUB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41E22B9BB;
	Mon,  3 Mar 2025 01:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740965503; cv=fail; b=BTB6Btp5KGoE/gHSfAYU4r/HnYL/5I3lEAVH7hIiZNbO8PTm2Jbfj4zKTAJ4zaRUVk0QkUOmD1ZpIDiwuq2teKlgjLo7QaYAz2Ux1viWDG6uUjglT/GG38mTnltEVKDzyzUoPN0qsj6HXltmxUt9nQvfrkcObNxHt39AkgtUhIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740965503; c=relaxed/simple;
	bh=ABZQOmAdF9MzJygZSjHi8R6vLjgTez+xQuOBJIwmI5Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=U2xwpWf0ctnx4iAxOa4fC4p5Ut5Q7QjQIyNrdmBU6ktjgIspPwg9HxjZGzEvw5EM8wx9OFT6120yyssVYOcUDL9gzuUJo8CMk60h+qlHWZ12ngqVPFTMP6/qL2ilx3s1pbbRz1ozLcElccBbPqje1eRsXtwjnnAdjNU6zbDMHAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WbJ8MDUB; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740965502; x=1772501502;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ABZQOmAdF9MzJygZSjHi8R6vLjgTez+xQuOBJIwmI5Y=;
  b=WbJ8MDUBT3SZJlRWCAfgZ2u18SYEgYco0nDr5hrbN3wyzrufykLapSIG
   D9kJ8Zb0VFb+ALjNKMDPTIk6DRqsZ5iNzbCNfXe3xh+Oz6qbjprf+5eAv
   RLgufEB7j39+pz2S1kDqU1CzfgNiSSSBW9Dqdt/HxOrDdnIQutz/t9prE
   2wHfrT+Y31vqhZDcLey8lks5/y5OX2Fh8kI99CJ27a+dy5PiK76yJu7ZO
   w2+gMeSI+hOXwdX1WBcTEDTUUyGvuX0kg5tKDyFhbomCkwpB1n2JnXdsn
   rl7NSNC15Gj0dD2CJjO8gp/IuXvlvYKFKAJHT0A8Lt3Gh9P4Rrd2NAcEF
   A==;
X-CSE-ConnectionGUID: ngXV6AO6RIOmwbe9QX41tA==
X-CSE-MsgGUID: M8qVaxaHTYuNIA9GtRi87A==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="59372575"
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="59372575"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 17:31:41 -0800
X-CSE-ConnectionGUID: I43UGhlaSry5WIRG5SmiyA==
X-CSE-MsgGUID: cVc7wAiPTy+NcN/Y6WTZdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="122817945"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 17:31:40 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Sun, 2 Mar 2025 17:31:39 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 2 Mar 2025 17:31:39 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 2 Mar 2025 17:31:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eFFSOSKP3w4U3Inen41aueCf/QnVLKqHFNb1jmARS63Tjoiuzow1hkU4e/JpS2Hd0X4aKxoI/xdUQ0X8MBEfPHH0ATSVxcSB4wlH51o8liTSg6r9RyTLQkbnfy3gPwFONjh3LdwYxZ+9zlEQsrdZA76MPwqrsAagW19vGiftw6PV1aW3uarTWbDl1SnFsClxVMC6w/mGlvvhc01yV/pod+EBvjY/Jxd2QChvmRQgHxj7rR8TkdBtGfpSLjy1gLWQ3BdIM/8Y2pB6Xiva7lLAg5eGLxz6/6brBYI3SHXxJ9lWX7J9RyRTxLGvaNXZGqzUc9WhvBp/CddUkwducBdVfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sF9glYrjhd+VtuYf5V2QeadJf+mn92WbmRuIsqb8SiA=;
 b=JJJq45y2a2XYdj7DLu/Gtg0RE0NE7V/DqyOAmTTByKR9/r5orlfI9axxcruhZPhJcUUeUpEcKYehCCBgZspJwNcJ4k2fXDzVSHMva/Q1UgB0W56uSKhdiWa54fYpAcalJUujMCvNqWXhnqamRRj5pQMSEvJT1vxeGau160l5he6zRA9nKrMH/4qZEX9jD8HDTt61uZQFrLpFJteY/ErZTpZetu+gFklMDcpKjLCSgMxNWMunPPLShj2uVaWLjmK03AZVVD8Aj0wARL19kTA64/GJrJi59OAuOR2f3TB9cd66Vo8VwprZhm/L2LWcRvU+sg3cK5DHA/9AtsjAhh90yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB6879.namprd11.prod.outlook.com (2603:10b6:510:229::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Mon, 3 Mar
 2025 01:31:29 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 01:31:29 +0000
Date: Mon, 3 Mar 2025 09:30:10 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 4/4] KVM: TDX: Always honor guest PAT on TDX enabled
 platforms
Message-ID: <Z8UGIryFjJ+msO6i@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250301073428.2435768-1-pbonzini@redhat.com>
 <20250301073428.2435768-5-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250301073428.2435768-5-pbonzini@redhat.com>
X-ClientProxiedBy: SG2PR06CA0202.apcprd06.prod.outlook.com (2603:1096:4:1::34)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB6879:EE_
X-MS-Office365-Filtering-Correlation-Id: 32b405db-6e25-43f3-26a3-08dd59f31f80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?sbU2Tzoftboqxrb/xW9njLJL5O2Z01d9iz1nRSeQdSIiNPjDgT/h+gW8N/dI?=
 =?us-ascii?Q?jANEBstPEIOgjdLtJXUj7oJ9+VQG6yN4v8c1mIuverLDhlO+vLPpGxFTmL2e?=
 =?us-ascii?Q?v1RifNKV5r0SQq/e5UDGeB1S7kKse4C7kfIcbnw/AGRpl2ZWsQSJbMmEBrUj?=
 =?us-ascii?Q?ODcaQjcIT2uAkTV60P08BpcsbTEiyXzI3DEwXXlZWwns0SlGUr0LfpGDhQYV?=
 =?us-ascii?Q?TmxKJJULM45c/qpsFznqgz78AWPASlSmhvDCtgFdtkx2Xnxj39dfUnY3wmnT?=
 =?us-ascii?Q?f3QNWcX1hL1QaZZwwufmnZkoU0uj8wT/SnJ1fUSoHvHxOwUFJgkUcHVThiAJ?=
 =?us-ascii?Q?HmhVLgGIlfmOtcXlBSL22q/sJT4Cn8ELIMOd0txtDj8GBnCLZKExDeQCQ15n?=
 =?us-ascii?Q?gkUVp6nCUeER6hQOwoqhBbtUxRF77xc/26i3a47vAfoXjKswChA08l3caAKj?=
 =?us-ascii?Q?XA+tz8d+8FWsMG/2FAzJEzDDbSvvbSyRKloAYkV7ATWSO6s7EDQLc93j18wl?=
 =?us-ascii?Q?FEQZytIimcLP9USvSaFxaQNClvgPlacjH2okzoqGdvJCo1FBS0F8D26KlC8j?=
 =?us-ascii?Q?LPIdjlv46cmTYuh5CJh55J7sxRtREEHPWuZg75AnfVla6jcGTO3XG6zEEqFu?=
 =?us-ascii?Q?h/PyqGp+lw1FHUMTYh4Ce6GOC7dnCiMnteFTpfSberYMwjq/Jli5YzsGBBlU?=
 =?us-ascii?Q?DPIyhHyiKPQ6qEz2LYXlhqpf8oxueq4/ADVeIdXSPoP3H/MeIqJ0pW8MsLGA?=
 =?us-ascii?Q?wX7lLMgpUlQ6aH5UorMDuEA92YdqxAAcH/nvtUuA2J/3BogJFcgCwehopyL6?=
 =?us-ascii?Q?N4Z7WY+YnpcFNgQsAbydH783BTE6VIqHoYHt2alDKJiRHyo6h/7O/cm09HBJ?=
 =?us-ascii?Q?hY/id9RVMgi/7tcIirJeNnzJJWri8PiDn6nrihu1L2FhLGFR/PKrQrs9qFeC?=
 =?us-ascii?Q?zMjrlJzm22r4wVYD8X0lmpiViB2V9T4f5oLndBQ3DQWITtWKVWqjASnWrmRg?=
 =?us-ascii?Q?C1QZ2xodQoy01nD3JgWccEw73cPRqvVPYS0Dqi39GqJXPvPOXUV1NkYQZKaU?=
 =?us-ascii?Q?B9FMBBR8pXyAkwj+MrxyOT1RuIAXyhNJim9CLJGd7+AkprqseXittzUgVIkU?=
 =?us-ascii?Q?5aLspdROzZPLMLews8c1hubloyjRiUAeowgHL9rZfNCygRKdhYI55PTLUrz0?=
 =?us-ascii?Q?RSx360RRwVhsGfB6b8nxQRiaM4akTBqWnjB4gwQTY8FJlfROzIZbZl1a2Th/?=
 =?us-ascii?Q?dd770bBXRKdk/WRyRLzZbSFDL26wOjr4w8TUIOZnr1kpsZTdfOLUjXMbdOY4?=
 =?us-ascii?Q?6zqrQYD7t+uYmkV//MntjRWgn9FpaLqHpnSI66m6Rb3PaiFn2XF6ZUwS0NC7?=
 =?us-ascii?Q?ai9Wpv97L7DNVk95oBWOcU4qnRh8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4Og3tCgi0g23IZ/GciWvCWrtVycWfaiL5GTtH7nfSPxnNH1UnybZZRiwTviN?=
 =?us-ascii?Q?c3MFaVtrarUb81eH0kQOgZJW6ebqCGbhDGb+/jJD7GSx+3U2gag50VjHo9vx?=
 =?us-ascii?Q?xtkAe13wNvD9qBzUVMVBmsr2FQAlDL9qT+gAcrpcBx5MeqTlt4uJv67R8/gc?=
 =?us-ascii?Q?b8nC+m/iaK2rVeUuXQThdInXijdo3QNvHk+qh4//1EJpe8R9J3AUOwiXruo2?=
 =?us-ascii?Q?QAk1WXJBXFCXdgjD57nphBhGmzzHDHw9uZcse7988HsgzASoNsfbuDirvIt/?=
 =?us-ascii?Q?czIUwKtuuR9M/dXjMfSNnHssXziJybl/zbW7EZEMKHV7jqDnJX/j1UXftxd4?=
 =?us-ascii?Q?JGqn/S1nh9EYPPa+4hzqVL9ovEiLolpbTGRHPb7hmWXgAPS/jMVR+0xH5X/5?=
 =?us-ascii?Q?izoPqFu4oNjwUVumwJE7OEyFlWmV3WDS8hLsbkPZ4SrMsZKlLbISuyrpkjPK?=
 =?us-ascii?Q?iP7JN8XhkvjGPHvrPbGBZfn7UI2JKOqwpFJHKigsCRfYl28APCgwhRI2Xz0b?=
 =?us-ascii?Q?cSQz+Kb9pIj1e2qy43gxhU0NGsaPrbiPiTbeE7w/GMFvyZ3JEBDFJ3Nkp+il?=
 =?us-ascii?Q?qzzX+x28LzWqf14yy7NI35JjQJaS05aIXXanWHHYU3CFkn4RDOMgFtb5drMS?=
 =?us-ascii?Q?oqpphcL6ZQX+mW4v+cieWH7nB4U+9buBgZpS78/sQreVZgEByPQw4dl6eOog?=
 =?us-ascii?Q?0T58gVuLlgrfb3eqVXjXLDauaUeTb8uIBZqlidSQC8u15Ie/XLnwKEDQ3BJB?=
 =?us-ascii?Q?5qrkUiqGgDa8MSeKa41giJpFPzNGDjequ5VBR1gb/jF06fZK0R3QVnlcbGQ/?=
 =?us-ascii?Q?XU6jAt2VYg3nYYA0zZ7wFnEqO4r9vw+l/yhScWgjynhbZuDPIDZazBi1A5VI?=
 =?us-ascii?Q?QAxV+b8lS76pCh2JqF9bKV/XFJT97HxNPzmKdTmJiXea9fEyFDyf3UexpnyZ?=
 =?us-ascii?Q?IIJSvl4jj4lqr12gmqNFP9Ax/bP3MaJx8Ctmmdd0v+ikKjHq/0nTTHPRzSjP?=
 =?us-ascii?Q?TELTifSsIGMQeEnlgGs/BzawNQi9b2IaTk/HltcqCvYQYXM4MKc2k04F7jhY?=
 =?us-ascii?Q?8X4tF2jLnTFfd9ruzjh/kFKL4ccLqsaXnxtoli5ztoxxSGltOf2xMbn7XkTU?=
 =?us-ascii?Q?Kg61SwrJwiidm9/FKneTPHvbaI1nROvM5Vq1rurceoh7gsNdShHGEAlNJ6rQ?=
 =?us-ascii?Q?edzNnP8cFHAbmVHSOkwuKEuGWalc4T9NlvnRoQC+D+HDZXU8x+XKwEii/hif?=
 =?us-ascii?Q?KU0yxjl3qQr341e7DfheCE59/Oq9OziRAUnrHhSrZ3WsIRdDW8Llpg5tdG4i?=
 =?us-ascii?Q?6D1KMujV8QaY/OZV/Q+5fhjlC9gV+nSz3nB4lziCUk2vkR9li63P7bktIFfG?=
 =?us-ascii?Q?EvQgx+9sd/tszc2P154DwSRTI+qVvw5vEq9K+fwmd1eqWq5/OyIGMhohL7XP?=
 =?us-ascii?Q?NavzF9s6xEawmh+I1e0d0PP+REWA2iWOBmKzbRW861tCDJ5CYd+NNjZxjih5?=
 =?us-ascii?Q?5w0a2cms3zeKsk6skRy42DiavtXjb+BQkJ8QEdHurfVlWl57FHfU2aQ0r2Bk?=
 =?us-ascii?Q?Xdzqznh6G06D6dDgE9dS0XB1nOmo6UdL7fFG/L4T?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 32b405db-6e25-43f3-26a3-08dd59f31f80
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 01:31:29.7828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g5ndYqPsI+LqIN1NQ0KpyxHEJ3SHiZXkP+l/+rWUYRf+93l9OZwnac/79lZE/onz4HAekmVXw1EGB636WA36HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6879
X-OriginatorOrg: intel.com

On Sat, Mar 01, 2025 at 02:34:28AM -0500, Paolo Bonzini wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Always honor guest PAT in KVM-managed EPTs on TDX enabled platforms by
> making self-snoop feature a hard dependency for TDX and making quirk
> KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT not a valid quirk once TDX is enabled.
> 
> The quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT only affects memory type of
> KVM-managed EPTs. For the TDX-module-managed private EPT, memory type is
> always forced to WB now.
> 
> Honoring guest PAT in KVM-managed EPTs ensures KVM does not invoke
> kvm_zap_gfn_range() when attaching/detaching non-coherent DMA devices;
> this would cause mirrored EPTs for TDs to be zapped, as well as incorrect
> zapping of the private EPT that is managed by the TDX module.
> 
> As a new platform, TDX always comes with self-snoop feature supported and has
> no worry to break old not-well-written yet unmodifiable guests. So, simply
> force-disable the KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT quirk for TDX VMs.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Message-ID: <20250224071039.31511-1-yan.y.zhao@intel.com>
> [Use disabled_quirks instead of supported_quirks. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b6f6f6e2f02e..4450fd99cb4c 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -624,6 +624,7 @@ int tdx_vm_init(struct kvm *kvm)
>  
>  	kvm->arch.has_protected_state = true;
>  	kvm->arch.has_private_mem = true;
> +	kvm->arch.disabled_quirks |= KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;
Though the quirk is disabled by default in KVM in tdx_vm_init() for TDs, the
kvm->arch.disabled_quirks can be overwritten by a userspace specified value in
kvm_vm_ioctl_enable_cap().
"kvm->arch.disabled_quirks = cap->args[0] & kvm_caps.supported_quirks;"

So, when an old userspace tries to disable other quirks on this new KVM, it may
accidentally turn KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT into enabled for TDs, which
would cause SEPT being zapped when (de)attaching non-coherent devices.

Could we force KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT to be disabled for TDs?

e.g.

tdx_vm_init
   kvm->arch.always_disabled_quirks |= KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;

static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
{
        WARN_ON_ONCE(kvm->arch.always_disabled_quirk & kvm_caps.force_enabled_quirks);

        u64 disabled_quirks = kvm->arch.always_disabled_quirk | kvm->arch.disabled_quirks;
        return !(disabled_quirks & quirk) |
               (kvm_caps.force_enabled_quirks & quirk);
}

>  
>  	/*
>  	 * Because guest TD is protected, VMM can't parse the instruction in TD.
> @@ -3470,6 +3471,11 @@ int __init tdx_bringup(void)
>  		goto success_disable_tdx;
>  	}
>  
> +	if (!cpu_feature_enabled(X86_FEATURE_SELFSNOOP)) {
> +		pr_err("Self-snoop is required for TDX\n");
> +		goto success_disable_tdx;
> +	}
> +
>  	if (!cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM)) {
>  		pr_err("tdx: no TDX private KeyIDs available\n");
>  		goto success_disable_tdx;
> -- 
> 2.43.5
> 

