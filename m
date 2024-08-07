Return-Path: <kvm+bounces-23475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 780B7949F86
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 08:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75CB71C2122E
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 06:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C9AB1EEE4;
	Wed,  7 Aug 2024 06:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kP3rZZzz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D522C163;
	Wed,  7 Aug 2024 06:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723010434; cv=fail; b=Nvw7OEZpTaQaxUx+3PQAEndIZhwkQ0VLIJp92qfc4P5Avu7E3pt+iPlqjZiQoUuUIczlZmY/hmNfMu3OAF7RyMrj3cvxA+9wtw6cTITmSlrgY5oG9/16OOFSVz2/qsvFkXxHmQYRNzb8CUv2nNe5dclodIDabxEC8b8FG+oj6lU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723010434; c=relaxed/simple;
	bh=ikR6H3Hcc+zuApA71muZehXF2FeuzIwNvQ36uWbW+EU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SXWenWAgN3WRTNexy/J/qA05Qmk1Md5hNd7jTbSiZ9RFf75Dkk+TQcO199e2/MHpTWCAJ8Y9OvdUOsGxdQVlx9bUmy0CwjfoNIj6OMEUIlHkHU3ZYKItId466tXucww5BV6BefqKxy79C9pLVBZNEDQwBKEP3FzNfvgUWcruq3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kP3rZZzz; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723010433; x=1754546433;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ikR6H3Hcc+zuApA71muZehXF2FeuzIwNvQ36uWbW+EU=;
  b=kP3rZZzzR7OD7c51aZTl4AMv3XOT4YiXDLJDTcApTVb2YjctX7kODXe4
   LOl2d7iPmt03RAELca2Vtj8k1fjBejiqIaRR6X9qM0Gg1Rss7FSVMo3Rn
   RNJpLiF7O3Vf4vFAPFrSDJ7yHFCx5LDAlYFcaUX2Jy2vgjSCOHlP+yjJg
   3VBJ7ilvKewTOh/A7j4DlCuSYQ6gfBrBs9h0TUiRqtRdbyq2yOyZ0VKyP
   MUL/1Ih4yUC3Emcrq4tTauWwigRH8VOd92+TESrEyIx/6MdvT8eGnC5Qw
   uIFQa0MK3vmvDBqrxykZX1lz1lHSZvwCOl1UfWPmp5ITbuQlbPhr34cpb
   g==;
X-CSE-ConnectionGUID: V4NYFR0CR5CDlW0bpdWh6g==
X-CSE-MsgGUID: GzUMGD53TIOPRKi6I+C56A==
X-IronPort-AV: E=McAfee;i="6700,10204,11156"; a="32447696"
X-IronPort-AV: E=Sophos;i="6.09,269,1716274800"; 
   d="scan'208";a="32447696"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 23:00:13 -0700
X-CSE-ConnectionGUID: X14kXje/TcyxvPP74BkO9w==
X-CSE-MsgGUID: xpytfGt9SueSHZUC64xtkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,269,1716274800"; 
   d="scan'208";a="87678577"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Aug 2024 23:00:12 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 23:00:11 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 6 Aug 2024 23:00:11 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 6 Aug 2024 23:00:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RaE6Cd+mpGB2pejCwySh35R3Yr9WgLnx+S2uqwUYTkgQaQaE/zirc1XzDYlXPN4B+POYniPc9ErKc7U20dkPHDoFeSbh2mvhDLuA8z99OrQx2OvJaoV8VHdZaIWnE+trt2lDnrhN/scAkFrM+a6/+qiifWKue3/GRY632h/wqOgFqHV8joIIqEbpodDqeNT12wT18d4Tg2RfOH5Y07l0yDA1jVPQQM2QvIrdfbTj6L0pjjglE0dpUzThryLCVPfWnqko3VDwSoVtEECQU515g/bFzORh9yZXrLV8DdvyifD5/uceXBYvSrPdRLQgCeO/403l2NewXZAe0XV3XUrzzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rOxGdWbWUxcoBb7QBq+BRVT+MJol4EjV8/MmzuXmSdA=;
 b=yTzfbr2xPj98wxX+NBA1AMtPHMSilXl1/qIEttQszu0UbkKPMxI4RhpVnM+EkS/j90szcK96J61SfxsUP5exb7YYPEcBsE3w172UpZPPI3r9trXeyzOPluzEPAXv95VXXR5+8kMWPR+beDEUTrclHfbjGDOL789HdrE/ZJx6InSb+DWI5gGujncZhC2T1g2U6/E+0AW6UzOhVxmQaXEWL3rJjAIcQku1X6QTYxg2/joitKb1kffmYS67er/RvQ4LwAstNJhqmb6H/Se1d52BlolH2tS2ltQAuUoXbaZS2yw6zUjnpm/WJWMq8iUNYnRqizBx2aA7AIFrtrZxkCV6lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB5947.namprd11.prod.outlook.com (2603:10b6:806:23b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.32; Wed, 7 Aug
 2024 06:00:03 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 06:00:02 +0000
Date: Wed, 7 Aug 2024 13:59:49 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Eiichi Tsukata <eiichi.tsukata@nutanix.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<vkuznets@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<jon@nutanix.com>
Subject: Re: [RFC PATCH] KVM: x86: hyper-v: Inhibit APICv with VP Assist on
 SPR/EMR
Message-ID: <ZrMNVYmqpDKulDdE@chao-email>
References: <20240806053701.138337-1-eiichi.tsukata@nutanix.com>
 <ZrJJPwX-1YjichNB@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZrJJPwX-1YjichNB@google.com>
X-ClientProxiedBy: SGBP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::19)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB5947:EE_
X-MS-Office365-Filtering-Correlation-Id: 058051f5-2a7b-425e-382c-08dcb6a62d81
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dVK0XY5CIsz9KHtWqbl07K4OApv8Fsrkruxc6X15JiRgjHKALlEarm5x6ULD?=
 =?us-ascii?Q?mQGpINFOQnlz3ZkBpiO7uA/WacEeakblMe6r46vq2RvxzDtMRD260DQxkpXA?=
 =?us-ascii?Q?63ls3/78m/Hjlhr+RODyrftqDm7cHMNAtlIQCw85Ma+toCRb6Ii59z1thpcn?=
 =?us-ascii?Q?7nl3r3Gfmra0rfg1VAhfLzu3AWJ7tBYiAaKO1xI24sk7dWA+/naVUH0jQeQI?=
 =?us-ascii?Q?xhS2DQzFhE8sMh0G1+urWzhTq0pg7twvuZeCMXHHQhi77uO2O/4UAmIBq+7d?=
 =?us-ascii?Q?TD4YMUF2KZ9L2xaXhSsIXd//HRtWBn6G1aZgRdi+BiJIKw26O8KC6TiUNDEU?=
 =?us-ascii?Q?Nsb7jvHIgAaH/ck8bUJp5SGqwh7djT9ToT3P+neaQihbFprqOlid+uOnVR9e?=
 =?us-ascii?Q?0/xZtvC5Hig76BB9eyXTkJ4soj+Pl44G8oQXcEezRdWVzIMNfDmJflzcchhq?=
 =?us-ascii?Q?XRtVeQlcwWOjDL7PhhnPsQvjHc1inwB/Xlj2Iu5TSe0SBCsXinjLl3hDoczo?=
 =?us-ascii?Q?bkneYzva94gkfjgDdgBug3n0B2x5ZmnnQN5DbZU0hkdTLnIpAo/rtdGSxXtC?=
 =?us-ascii?Q?pMzfSxxk39ePcVUzkzxRCqomp562UkX+x9nqKWFcsuUY84j4R/TARobE9erA?=
 =?us-ascii?Q?X2fLf0EVU9a5WIAaCZe2hVB7C1O4YfJqx+cq0D56b8QN/4AB5m0Oo+ixfit3?=
 =?us-ascii?Q?b0mejgPgA4hUjsSBXF9Pkptv/gXrQKFmxj2xveQfXjGNrUSUezB9b9ERcmP1?=
 =?us-ascii?Q?hjYh0KQD2cT3M9fkA80Nwtt2x7rrcFb73l4dFdC0xemOSIhRrMqBAsAtF+nT?=
 =?us-ascii?Q?YokFFmjy+a/fvRD53Of4SqX43jozGm/Q6ammQLuGsHa2/x6yFZPzdcGJN9ln?=
 =?us-ascii?Q?d3R5qr8TOCJkfmweNMQT02Qs6buwdy6lsJPSbyilRN+FGxhpKZG3LZfKhUko?=
 =?us-ascii?Q?i7c06tB8ea1VTWHicd1NRHOjmIvq+VGr0ISOYv0pXvbqjov52cyFK/tgGvSV?=
 =?us-ascii?Q?EctlsoGICBKgRBBW225QrtpSSonsL0dLShZOqnw1FOvZHzbIlTwwCAOQzDJU?=
 =?us-ascii?Q?hoqaALjG+vrQsYpOe6ic74lrfLUP6fDYZDe6/kcUZVKU8LUuXk+1B2658paE?=
 =?us-ascii?Q?eAna3BQFnX5MjlNtwe93u5D55Gd3L/LgNYZyd2P6DYimH2k/L1VKfKft9Upy?=
 =?us-ascii?Q?7CIZSWQfxsrHteqb5IZUCG54yXHCId4sJZw7TpeA7vMkeznrNnUuPaVXaRx7?=
 =?us-ascii?Q?49buxy9/sfWDFiopVnfOkSluDZZwIEmfwM7iQGWqIvZgiQH8DG6+lOt3pt6K?=
 =?us-ascii?Q?QtYENmpJqhsxaanJEcBa5PgoXYWPtB1/18cIRaAJkvo0pQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3KHeBScRwCy9o7GFzDY5svVaMC1lftBxkOeoHcQdU/XULib2m1lHeR477lkk?=
 =?us-ascii?Q?D/hlJKh7RBlSnSoHD5asOQjYmlhU4/39QDqX+Xv1J/nmXOKngTTnsQb9lB9K?=
 =?us-ascii?Q?DTs4XlOPnhwMdQZ0iUqZBSxzC1t2GwJ2vW5fyPd2PQ/thZVVYjVsfBPoJ1Jl?=
 =?us-ascii?Q?1c45zOjFSOsaBvf2FSpkMGVj7Inctjxo/rywNSLWua1aZ2t0zncG+ekYrQLa?=
 =?us-ascii?Q?oRYTbM1L+f6k2jr1FWcAq9xrOXjt0/5/qXNhZEsB4u+PVdw/7oSQ2BH+tplw?=
 =?us-ascii?Q?hS5LKJblP5KEKRj94zLruP6l4oq4lQZOP2rNtVaVFhqU0r0dMybREve/nbiw?=
 =?us-ascii?Q?AdvF79F2icz7Dn/UQXGcYZzideLwoNfWqWUWGFLau0/SCcuKm9CJNRQXZ6oP?=
 =?us-ascii?Q?K/GYQ9IF2eYJAjZ9s9cdap8nDpcSctG7QZfAIRVzTtx/wCvoJc/4hJHNPpbA?=
 =?us-ascii?Q?aw81JLbcvQYJVQYs3MoH1NY0n3ugOhviUTvRdf7npCv0o/GacyCw/lnhb/6P?=
 =?us-ascii?Q?Rf10xSkENfhTzOTi+V8YxHuJ1PlCljXbHtmcZuXNUDMIPgbQcnSyK7lZgNuh?=
 =?us-ascii?Q?is8sd8c1fH66vQXXQDcqAbB/kBBIYuygXmRltuT5ZiK2wPmIUdEDSleAR0Wf?=
 =?us-ascii?Q?vdRrVinKzmYSt8So/RGa5AR/9dBOV6ARfROsMvgh4Z4p+ImDqKDZiMXQv6Ch?=
 =?us-ascii?Q?UlwfBeK6uZtbOh1C7WBk0oQQ+jDQ872YgPL5BO17qyOIeKwOrCkoHtG0SVFA?=
 =?us-ascii?Q?GdQT/R95KnXfesFExXGucW9BedNDd9OePkr4UwsDy7B8Tw9q1GXpiwJpXcCi?=
 =?us-ascii?Q?KyPvMhne3CLIscd3VhrzluGwJ5IGGByeLPtnlray1A12b8bZoyX97i7CBTZU?=
 =?us-ascii?Q?WsIhrebXzdBrpmS0vtXUosU9yc+HJhEw9mc5o/5p78jGI4oRqaQipQwfm2sj?=
 =?us-ascii?Q?E2tDBiWhr2gpXz75DZlw6SsN3NwcnQYrvtstidcMt+/95uBjAjJvLQNmpXM1?=
 =?us-ascii?Q?OHyrR/VRRxFT/17fIitWhv+ffqBfLb4bvZ0KdPsvn2RsmpWXFv62mzigoev7?=
 =?us-ascii?Q?umVDSCj6mKJuYXuQwG2EqWe2nx+mRngxQmF6S9b37LBcE+eJL2BDHfUHjV9l?=
 =?us-ascii?Q?dr/onoOWc8NaJDQmW4ify9LJcFspVQvLDK2Mc1t3ky0JSgng9q9rd3wpD1cV?=
 =?us-ascii?Q?5tIPkaL8HH64gi1iWKtlVreqOjGQc8rdwC9S9/dmC2FZntfPeN4MShWPRRzU?=
 =?us-ascii?Q?oqPS4lQ3N8MrZmdEUlu6dabDn7lOiiAXSBLD8dHcguYaDc8qHMyW4Hn4mFyg?=
 =?us-ascii?Q?TyJb2OegUZWWL3cv+hnMEMYKIhCDhko5ksQ916L/8sl3qKI69hrOwo+8JffI?=
 =?us-ascii?Q?VDWBSEZsLIxMifRa7OVeUFr+2GsE2TJwevD4sHzo/2gg9Pt5fw9UFuvpKFcF?=
 =?us-ascii?Q?cWX/XgY7yG4i4x86NB02TrN4RPqG/RxoDAO3Ep6XcqJPzPNMlJS0asjYSY+E?=
 =?us-ascii?Q?v1eiKdfAM8lyjh+CKddZqTgvlOOejLUuL/vQ5unhw/6DdHjZwL6leNzbip3N?=
 =?us-ascii?Q?7VzrPEEnuIOO2S0GR6ugjzKyty57WBMkI9J0f5LT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 058051f5-2a7b-425e-382c-08dcb6a62d81
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 06:00:02.7379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bkOwdJb8/0zgPGcoELlAqmCT6HsrXJoH31qFyfWCkQ4HRaq72/6x8GbAgG4esSkm0ALypL0XGF+o9lR8tT6FtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5947
X-OriginatorOrg: intel.com

On Tue, Aug 06, 2024 at 09:03:11AM -0700, Sean Christopherson wrote:
>On Tue, Aug 06, 2024, Eiichi Tsukata wrote:
>> Running multiple Windows VMs with VP Assis and APICv causes KVM internal
>> error on Spapphire Rpaids and Emerald Rapids as is reported in [1].
>> Here Qemu outputs:
>> 
>>   KVM internal error. Suberror: 3
>>   extra data[0]: 0x000000008000002f
>>   extra data[1]: 0x0000000000000020
>>   extra data[2]: 0x0000000000000582
>>   extra data[3]: 0x0000000000000006
>>   RAX=0000000000000000 RBX=0000000000000000 RCX=0000000040000070
>>   RDX=0000000000000000
>>   RSI=fffffa8001e3db60 RDI=fffffa8002bc8aa0 RBP=fffff88005a91670
>>   RSP=fffff88005a915c8
>>   R8 =0000000000000009 R9 =000000000000000b R10=fffff8000264b000
>>   R11=fffff88005a91750
>>   R12=fffff88002e40180 R13=fffffa8001e3dc68 R14=fffffa8001e3dc68
>>   R15=0000000000000002
>>   RIP=fffff8000271722c RFL=00000046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
>>   ES =002b 0000000000000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
>>   CS =0010 0000000000000000 00000000 00209b00 DPL=0 CS64 [-RA]
>>   SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>>   DS =002b 0000000000000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
>>   FS =0053 00000000fff9a000 00007c00 0040f300 DPL=3 DS   [-WA]
>>   GS =002b fffff88002e40000 ffffffff 00c0f300 DPL=3 DS   [-WA]
>>   LDT=0000 0000000000000000 ffffffff 00c00000
>>   TR =0040 fffff88002e44ec0 00000067 00008b00 DPL=0 TSS64-busy
>>   GDT=     fffff88002e4b4c0 0000007f
>>   IDT=     fffff88002e4b540 00000fff
>>   CR0=80050031 CR2=00000000002e408e CR3=000000001c6f5000 CR4=000406f8
>>   DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
>>   DR3=0000000000000000
>>   DR6=00000000fffe07f0 DR7=0000000000000400
>>   EFER=0000000000000d01
>>   Code=25 a8 4b 00 00 b9 70 00 00 40 0f ba 32 00 72 06 33 c0 8b d0 <0f> 30
>>   5a 58 59 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 cc cc cc cc cc cc
>>   66 66 0f 1f
>> 
>> As is noted in [1], this issue is considered to be a microcode issue
>> specific to SPR/EMR.
>
>I don't think we can claim that without a more explicit statement from Intel.
>And I would really like Intel to clarify exactly what is going on, so that (a)
>it can be properly documented and (b) we can implement a precise, targeted
>workaround in KVM.
>
>Chao?

I am asking if there is anything I can disclose at this point, including the
plan to disclose details of this issue and release the microcode fix.

