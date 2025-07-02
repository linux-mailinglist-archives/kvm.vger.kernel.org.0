Return-Path: <kvm+bounces-51241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8A27AF07CB
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 03:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1EEB1C05A85
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 01:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559E1146A66;
	Wed,  2 Jul 2025 01:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q2TkgGWF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47331E555;
	Wed,  2 Jul 2025 01:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751418593; cv=fail; b=PLCMEixXow4iLr7exrg+lZUdQfJQ7daacsVHZpe/HPcoZBF4TXL9Ez5RTNxuQwqi32DLlkaLpb9sg9AsSplj2o77gOJemHHwbO+L+HIDKem+kUBgTokW+YMTFzoh5mjxEpcCVeymTSmSD1ncz25cw7VdO4ONuVBnFZvX9RuYqlg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751418593; c=relaxed/simple;
	bh=/bzRwo33zQDVv5Hf46iyQFXOFdWiPsib6jvER4v/s4k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GzTQ7qWDp6r5uGhT3aphilWxcKtV+8bOX0USUshDiYKD2eucS8Mb+1XJQUgDoPcKkop3Gt3Y06czQt7sU3kTvhUq7m5VKwhGNwk30DiLharDP3TnJP9gImHVvMpyYDCCUR+VL3TIMzIABn462OyC36AgDsNtENZvC09gTpiQpeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q2TkgGWF; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751418591; x=1782954591;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=/bzRwo33zQDVv5Hf46iyQFXOFdWiPsib6jvER4v/s4k=;
  b=Q2TkgGWFF25ZKf/twKgUa9l64fmJ37zW7H5OEML0MJ46fSUvjMIwNKYe
   tb9MwmWiCsy5NB1y2nT6lwpaQKNQiuhcfkPpREkl7EWT2QI6axeazZf0U
   nWQHFEX3fQcKS1nE2FlexEUbCih2U8VGr1gUfPPkNG5PvG7C7e81818gF
   l13KaPu0KiZjrRtAKEVRlv3pbbKzGa/YS3N+CItxW1cH4Q1n85dY/oTyF
   5JSuxmbO3HywwKWyaHgss7lvfeeoXDZlc8RxSAYmzNEDAevJCbWlHKQBB
   L+wazTrv5iy4/LMbMeWeU9deykB7kvo/jCNrbUhzUJvSf43G/rbYePoH2
   g==;
X-CSE-ConnectionGUID: 0/pDFqdBSSev+pJddZNPUg==
X-CSE-MsgGUID: Y/KuZPzER2C//HPAvXWA0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="71267478"
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="71267478"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 18:09:50 -0700
X-CSE-ConnectionGUID: XIKPUngRQGKR7csKzzwO6Q==
X-CSE-MsgGUID: /am4QdEGReSqT2oRYcQszw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="154083502"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 18:09:51 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 18:09:50 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 18:09:50 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.79)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 18:09:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AjJVkrnZGbpGfxYFd8Z1fqO6gwFaoKA948Ua4L00ftbIs70LpDgRR+5YsbQ2AxmyXEp3OZyiYj37olUMlr5LDmp9vOMWT1xt9BcVYWk5rVx2KvYH48Ju7pnScA1Bm+nEa3JU1TUOhJruFqiZYah844XrPbtL0wFdwue4752Zcjlvwsy8bRW+hZlvzTfJj6RJqGLbgVwDL3dr+G6Lf4LsDIX6QiL6d+nbssxofZadh3qpwpa00amSrqUXYP0Ya9zwVncGOM/HBmb6U/lSAz8IorpAA/C54X7ERb56uBlfUiVOdL7iPxW6BZsAAob/TFP9njdpvY/3SuI5T2FZWjt0Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KhYUjsx72X3KrOzvAiJPcCDiT9IS9UjD//2VB7cSTnM=;
 b=CnMxbqTv4pqlGS7h6ociVWvimCJgsjJ4j3g01RV37lHy3dgi3/E75lNCbmQgiYeBvFhJ/IzcgRVE5NsUY1tb0ptPGPFJ3z9o0M1dR2n9H9ERQkg1X8XfqIZ64EhLOQ+LeX0uPUQihNuWSfa0e9VzOuAdVfGGlOx+BRa123Nc/DqjI9358XkLPfjzbBcQEUqSYdU62GkCyqHcT3i2DTBvnnC8eIIyJ3k8C7NzpU4asPzR55BOQuIMtiuI53mHU+qB4BIrDC4ygtOAORvYLTHSpXjwOg2vL/eRo5kgXzUai1vwoaNntcDi5hUI362vbalewA3j2hb1y8j49J/na4HjTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW6PR11MB8312.namprd11.prod.outlook.com (2603:10b6:303:242::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Wed, 2 Jul
 2025 01:09:47 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 01:09:47 +0000
Date: Wed, 2 Jul 2025 09:07:09 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "tabba@google.com"
	<tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aGSGPc+aovhd/SsN@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
 <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
 <aFvBNromdrkEtPp6@yzhao56-desk.sh.intel.com>
 <0930ae315759558c52fd6afb837e6a8b9acc1cc3.camel@intel.com>
 <aF0Kg8FcHVMvsqSo@yzhao56-desk.sh.intel.com>
 <dab82e2c91c8ad019cda835ef8d528a7101509fa.camel@intel.com>
 <aGNK2tO2W6+GWtt3@yzhao56-desk.sh.intel.com>
 <908a8abdf0544d4fba23d3667651c4cfcafa9c4f.camel@intel.com>
 <aGR5ZYpn3xyfOZhS@yzhao56-desk.sh.intel.com>
 <f13239faa54062feb9937fe9fc6d087ffcca7ac6.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f13239faa54062feb9937fe9fc6d087ffcca7ac6.camel@intel.com>
X-ClientProxiedBy: SG2PR04CA0165.apcprd04.prod.outlook.com (2603:1096:4::27)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW6PR11MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: 319cfe28-7c80-4f98-974f-08ddb905230a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?g3YJtLtk/PyfUZxxn5Ff1AvXG+KqZBeNoLb/iMqYYAqYwcOJ9OTHuku3oW?=
 =?iso-8859-1?Q?uaNBxlyf5riDdyajKXP+jsMvY7YsCNNxeCI/MXHybyiAXz/EZdDxK+2DOQ?=
 =?iso-8859-1?Q?pYAqVeWVHxGNdgoLm43+FTDteEBwttG84OOv366uJPJuQSGBiFGHwZN2FC?=
 =?iso-8859-1?Q?B0FPGkV6jiKuuL7MwdTXWc9vBuCamWDRRHhjNl/YpzUUdSFXV8po6uEbgF?=
 =?iso-8859-1?Q?2cdreZ2HfJIKZ5/bib5yxVY9VQ6Z1X42z0d4INf4TBBL+M6dCnQ21dUoNS?=
 =?iso-8859-1?Q?5T2w3kYPahWoBImECbWzGnss38gfunRKxOnr/f3mZ7OD2o1ipozc6W3hMU?=
 =?iso-8859-1?Q?fdf9HizkcrDdVCrH66kSMH9XNDYUGm+37UbPpIL7qaRrX78hVkuGFxNzWs?=
 =?iso-8859-1?Q?n0Ggh4WGJWSy6zFN2shvCwHwk72syrpGs4WugRoKzi1uAuaKmsdzEmTpz8?=
 =?iso-8859-1?Q?oXjZE29S59fPs3c7rqbX4z10Udc6lwklRikEIBZpVfvgvMGL1OQ/CqZbyy?=
 =?iso-8859-1?Q?pnVK3y0hh4egj6GJKwL5y3FS6ithkW47tBjkHOz4iZk70AMu++0y+2pg5M?=
 =?iso-8859-1?Q?hUGPeQah4umgon90VY3eBIS6SEFFjA7+tjBlvPLtcuad3MjB1Bsb0qkSBz?=
 =?iso-8859-1?Q?VCEO0yVlng9TEAaIPrbkPIlvnkxRaPyo1obArJ8TgrFGP2bLGfpK0De6xo?=
 =?iso-8859-1?Q?r2zdo5iHanYCBwlpKAZqQ5nLOhXNYIi2zZtvm60/UsatXVs+obcGCq5WmU?=
 =?iso-8859-1?Q?6ef5+OOVjhov+mtw6EdoqyNsjMuECxgfto+d8eS164jIz2Zj003kD8FJRR?=
 =?iso-8859-1?Q?Inl9FtZsCW9F99kOLJM2VxxrjH77txEuTlIL+LyDSKlruCz1DlbfVCRLcK?=
 =?iso-8859-1?Q?UY3fJF5Ruyb4aYMiVuiTMrWJ7zAezSAO7CrVrQYNHCL4uMtYI/5g6hcddd?=
 =?iso-8859-1?Q?X9DcqRKJLNFsDZu6iCjIHSYGIzknC0aYC1ErHXwAs4BxebJ/Z7C43rTe/0?=
 =?iso-8859-1?Q?RnWk04zt/gAQ8x99SdU6ENhnPLa/xso2TShnZoxARVJhlxXRwpG7MmFJaE?=
 =?iso-8859-1?Q?Kgd83Vck4acbuVkxxKZGXpBwNOvgzLUqSIQVfRgSjdfpkCCcgH2JqRjGA5?=
 =?iso-8859-1?Q?Q9E5vYdVb23zpFXmj7RZEQA92WFtd3maGfArIIj1G72/SuKAbwRPYaSsK8?=
 =?iso-8859-1?Q?r76WlJdZEChWOwj3iRNxghXr0vV/lEfATxL/1vlOJPqrbe47ThudSDEWRq?=
 =?iso-8859-1?Q?VhAKJl+p51slBr0MHnlXwTojQ2ARbu1bWnHc34dhL+Enaz28laNNHNf7F3?=
 =?iso-8859-1?Q?s0zP/LKmUBKQfONwdQ9cp92xX+DZeKNfoUQu1jIQCYUJrScHMBBZk5GYG0?=
 =?iso-8859-1?Q?WrfUVvjeaNOfYHzsa5YlJ4QaR38ffoZOtWErT1jnS+4b/PWb4KNBMkJ9Gb?=
 =?iso-8859-1?Q?d5wByJZJN+XUuXd44eXujK3/4c4hvGCIlrzKLzEI0BVft6rS8joGLge0n0?=
 =?iso-8859-1?Q?4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ax0Q5CV1OqearR2ZpKRlHV2NCog3SEiF/ZEluEgBOVaY8rFZoEBs853l+B?=
 =?iso-8859-1?Q?ZoToao4Q71Dr+a0KCaIXFd8OZKREP5Jr+PM4XCtenKE0XRrFGOPceeIUyK?=
 =?iso-8859-1?Q?Q3HWKVu5u4PzpThTszP0iT0buJA58fg/MtKIfrraF76sqOOHJwg6ztgDPI?=
 =?iso-8859-1?Q?iTXt64pA52Fgu/OJboaw18ibcQ/zS+2XHv5KK9Zo231mwHRzPxO96ttniE?=
 =?iso-8859-1?Q?1FXYA062GdUK+aXqhb8FZgF7vX/a0v2Y6aqxWuf7tDFq9C6y0+jPBn/Yxw?=
 =?iso-8859-1?Q?C4wGC36oprzvZXPilvXGJc+X3S7TwCY6hn8a7EgqWKnMsEKcR3JUxL0KKG?=
 =?iso-8859-1?Q?54/8t7sK1iibZlQ0mPajz/Di/NTqKk/31AXhLbypPfrGOwPV2R+qlsnxcI?=
 =?iso-8859-1?Q?vPkSBDN2F+BsGBfPMi5lrkMk/C+4qaQiGZzFLjaTYNSCpqDos2XzXjPDTA?=
 =?iso-8859-1?Q?S7NmESKrTbBK2HfJeXvXQW990lclJj7gySJV4V5KjrUVUBy+4rYN/MfcC2?=
 =?iso-8859-1?Q?BsEBgIPFt1vFpddyjBpHZ8+1RG8+mtwtNKKpzeHqvg0cPr5+/+D3wQnWjT?=
 =?iso-8859-1?Q?2Y7phVMMHT2VqynC1h2u/UJ1sphjC+ST53kEmrjGbE2ZQNzcpl6mnOEWDN?=
 =?iso-8859-1?Q?r/cZE5z99ZiTIAxKWzKui5bh9nHZ8m/bcc93iK/CDtlBfaEwlqm37aDpqP?=
 =?iso-8859-1?Q?A7EARUJn35QJZClNX9JLPnNWYcua2kEqjTipgsUBZYPL0ApryVrnbgfl5i?=
 =?iso-8859-1?Q?MqBzirOrvw7wxFArjsztlQDwMU78GnAqGtcxdQ0YeeQILYKRVu3+UaMWWd?=
 =?iso-8859-1?Q?nzdvdGg5jk7nOEOSZybQFOtUtcde1Zxe5vVbGqlHkBHeT7LYSDxdT1pYv0?=
 =?iso-8859-1?Q?ufxwqBWH2HpFCXld5xS01pjEH1avif+c9Rp5atATRTNqjuY6rUJiF+Nve5?=
 =?iso-8859-1?Q?Sq7D76IcqUojBGcKPQ+nCoyasRm229bubKAKeCM5hBFF7eCClaqe7Ua2Sp?=
 =?iso-8859-1?Q?jotbJsKCnXcLwKI6i75J7QtU+0Bn2cTDdPCG7ci2HdEqu5+0N997K2pFNi?=
 =?iso-8859-1?Q?WScVjMZ0asc0vTYdeRYOBeAUfN0baPVMc2+QzozToWwR74NVaKIAsjk2Ht?=
 =?iso-8859-1?Q?xTMSzgLkdSXd5N0SoAhpz65UFvWvaPvWFf98nfIWChNoKE3U82hnPulukN?=
 =?iso-8859-1?Q?trrAZKVHbKrwcV7U29DwYCzPJOy/4LAVnnhfD5PRvdXp+Dxb3IO8iVyZsi?=
 =?iso-8859-1?Q?7o/LBFGWdZhV4e5FI8HWmG9qxtfJPZz64S+8iejMVFVbyuuENwZVNQtnZ+?=
 =?iso-8859-1?Q?VzId1u2cE/w2N12sBq+7rzf5q6caLJ14JmTyWigd2qXfdXj7k7tVMVGOIn?=
 =?iso-8859-1?Q?HSrmZ0+xY3FB61uLTgF7N0v87L1u3ZnZFrON27R5H28+RGsnOiGDMkpyPy?=
 =?iso-8859-1?Q?1dKbPFecrZ6Vwbe31mR4nx/TuH+kzuxj1n9xw1miWsxQBAsuX9vBQAElY3?=
 =?iso-8859-1?Q?QJzmlvgd3m72t3Y6/RYXmhb6cQKQc7zaqkjKbtw10KUZO0yng/xa7qvQzJ?=
 =?iso-8859-1?Q?2UIfIrQCI07xy5JT3dnxyy3neH/zdbw0EagyyL+ZJKJ7eRRxOf/6UAp4zQ?=
 =?iso-8859-1?Q?NSxZVbX7SMZ6Kv7rGEYmEKIaOc0modS/7m?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 319cfe28-7c80-4f98-974f-08ddb905230a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 01:09:47.2425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O1/sB95p6VXZGTMUpDY4WJKoSPlfgABTOzYlBDE8DIGVvfghU9KTL6fdVVkpPrH1sTVqiTj/FV0+gvC+FfVc2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8312
X-OriginatorOrg: intel.com

On Wed, Jul 02, 2025 at 08:18:48AM +0800, Edgecombe, Rick P wrote:
> On Wed, 2025-07-02 at 08:12 +0800, Yan Zhao wrote:
> > > Then (3) could be skipped in the case of ability to demote under read lock?
> > > 
> > > I noticed that the other lpage_info updaters took mmu write lock, and I
> > > wasn't
> > > sure why. We shouldn't take a lock that we don't actually need just for
> > > safety
> > > margin or to copy other code.
> > Use write mmu_lock is of reason.
> > 
> > In the 3 steps, 
> > 1. set lpage_info
> > 2. demote if needed
> > 3. go to fault handler
> > 
> > Step 2 requires holding write mmu_lock before invoking
> > kvm_split_boundary_leafs().
> > The write mmu_lock is also possible to get dropped and re-acquired in
> > kvm_split_boundary_leafs() for purpose like memory allocation.
> > 
> > If 1 is with read mmu_lock, the other vCPUs is still possible to fault in at
> > 2MB
> > level after the demote in step 2.
> > Luckily, current TDX doesn't support promotion now.
> > But we can avoid wading into this complex situation by holding write mmu_lock
> > in 1.
> 
> I don't think because some code might race in the future is a good reason to
> take the write lock.

I still prefer to hold write mmu_lock right now.

Otherwise, we at least need to convert disallow_lpage to atomic variable and
updating it via an atomic way, e.g. cmpxchg. 

struct kvm_lpage_info {
        int disallow_lpage;
};


> > > > > For most accept
> > > > > cases, we could fault in the PTE's on the read lock. And in the future
> > > > > we
> > > > > could
> > > > 
> > > > The actual mapping at 4KB level is still with read mmu_lock in
> > > > __vmx_handle_ept_violation().
> > > > 
> > > > > have a demote that could work under read lock, as we talked. So
> > > > > kvm_split_boundary_leafs() often or could be unneeded or work under read
> > > > > lock
> > > > > when needed.
> > > > Could we leave the "demote under read lock" as a future optimization? 
> > > 
> > > We could add it to the list. If we have a TDX module that supports demote
> > > with a
> > > single SEAMCALL then we don't have the rollback problem. The optimization
> > > could
> > > utilize that. That said, we should focus on the optimizations that make the
> > > biggest difference to real TDs. Your data suggests this might not be the
> > > case
> > > today. 
> > Ok. 
> >  
> > > > > What is the problem in hugepage_set_guest_inhibit() that requires the
> > > > > write
> > > > > lock?
> > > > As above, to avoid the other vCPUs reading stale mapping level and
> > > > splitting
> > > > under read mmu_lock.
> > > 
> > > We need mmu write lock for demote, but as long as the order is:
> > > 1. set lpage_info
> > > 2. demote if needed
> > > 3. go to fault handler
> > > 
> > > Then (3) should have what it needs even if another fault races (1).
> > See the above comment for why we need to hold write mmu_lock for 1.
> > 
> > Besides, as we need write mmu_lock anyway for 2 (i.e. hold write mmu_lock
> > before
> > walking the SPTEs to check if there's any existing mapping), I don't see any
> > performance impact by holding write mmu_lock for 1.
> 
> It's maintainability problem too. Someday someone may want to remove it and
> scratch their head for what race they are missing.
I don't get why holding write mmu_lock will cause maintainability problem.
In contrast, if we want to use read mmu_lock in future, we need to carefully
check if there's any potential risk.

> > > > As guest_inhibit is set one-way, we could test it using
> > > > hugepage_test_guest_inhibit() without holding the lock. The chance to hold
> > > > write
> > > > mmu_lock for hugepage_set_guest_inhibit() is then greatly reduced.
> > > > (in my testing, 11 during VM boot).
> > > >  
> > > > > But in any case, it seems like we have *a* solution here. It doesn't
> > > > > seem
> > > > > like
> > > > > there are any big downsides. Should we close it?
> > > > I think it's good, as long as Sean doesn't disagree :)
> > > 
> > > He seemed onboard. Let's close it. We can even discuss lpage_info update
> > > locking
> > > on v2.
> > Ok. I'll use write mmu_lock for updating lpage_info in v2 first.
> 
> Specifically, why do the other lpage_info updating functions take mmu write
> lock. Are you sure there is no other reason?
1. The read mmu_lock can't prevent the other vCPUs from reading stale lpage_info.
2. Shadow code in KVM MMU only holds write mmu_lock, so it updates lpage_info
   with write mmu_lock.
3. lpage_info is not updated atomically. If there're two vCPUs updating
   lpage_info concurrently, lpage_info may hold an invalid value.
4. lpage_info is not updated in performance critical paths. No need to hold
   read mmu_lock.

