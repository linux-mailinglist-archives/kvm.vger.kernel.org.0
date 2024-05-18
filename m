Return-Path: <kvm+bounces-17735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22D698C918A
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 17:41:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BD25281C38
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 15:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F41645025;
	Sat, 18 May 2024 15:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KlzQ/lha"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4021DFC5;
	Sat, 18 May 2024 15:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716046888; cv=fail; b=HpGl3xNFEwtEgYVh/9oTzdxhQp6xvqXl6IEx2ilU/Q3lgZhhjKvrzkScRRE2gUIqtsBd6nvpUXWbUNR5BtTF8GVIFCus05HEL4IAcHJergDAfkaT1Vi/PjGfT1EfFYSPyyF1L+wvkKDnSuw3HpGBfuo1n1pYTzd+xuaSmtsqer0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716046888; c=relaxed/simple;
	bh=8+kbJB/64DQXljpMrAguMx12NymeNvGD9nObIi2hAlc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PFpUHsTZlxH7vSsnS0aaw2WZUrLg5bbFUvvDVdBvWSyXl8pQQlcHPxq53B2CKzS2hO9oOz1Zym2cS3DwkWNr2kYblsNGnyZLMJbPyyKFfgoIm1eD7lysQ0xl8mvVxekQw13qvxTygDyBYKenmhkBO/3b07vLhI0e1zBwHPKVH5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KlzQ/lha; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716046887; x=1747582887;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8+kbJB/64DQXljpMrAguMx12NymeNvGD9nObIi2hAlc=;
  b=KlzQ/lhaO2ojXYaARpC32YPqe14D0mkc43kV7FStOH7xXLRV+KgwOaDm
   S7ALPF/a/1qYCc9EdWF7f5Ux8lolHWI9VZmcgHkx7fcDHQPwt6YG53Cnb
   p9W1+sAPzS/Qny91PMihvHJTUiRl8umL6ZYdfA13ZTJa+yzN5zhhanq91
   qY3yBJSosjRVWPkDTY9J6sSFulBeIrlT6dyECmrXGfF7byKzVcF1A1YA5
   eTkl4lUcPpNThTkMFgaEgpS3u/eeO6bhGmkHz4aHBOvMXHuKC70RX63rZ
   cSyQMIRytoI5ncc3ds+kXnTOym6pgunv/jIRr13XkT6S2kb6NoeGunAHn
   Q==;
X-CSE-ConnectionGUID: QHJVR/MMRmu1Lidgilb2iA==
X-CSE-MsgGUID: w4PpIr4TQkiYFtQ+v7WvuQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11076"; a="12394867"
X-IronPort-AV: E=Sophos;i="6.08,171,1712646000"; 
   d="scan'208";a="12394867"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2024 08:41:25 -0700
X-CSE-ConnectionGUID: IruoXmAAQGiYPbJiQyX+ow==
X-CSE-MsgGUID: bqhDz16GSx+vNsFpqzJenw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,171,1712646000"; 
   d="scan'208";a="37002247"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 May 2024 08:41:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 18 May 2024 08:41:24 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sat, 18 May 2024 08:41:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sat, 18 May 2024 08:41:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqnRo+dUdhcDUSvKjF78jAOVqsx1ckc4bU1X5EL5xtM7wFzcOu+0afmveiPIR0+zrSME0Ndaz54BvGuisOwoysf1muLDH0k9y2zjlV0bpa0iqGD4uYsxycfo9I4CrHcIljNMb7md4BZLX6tgAfQU8SVvA3SaTnjYKb65DSQFGwgJEHFc+E9ElcNa1Z2r08ny0eLkB9jmBHpURSGAIf7pYj0Y99gOm73NFirPDgfeN6dYzJW6KO+nU6h6p7uu0eqf971n1DrKzVXD5tGs2Z6vM0PcSP2Ix9enYYLUxJW5f56UGIK9VzbxLPIcjQdkq3yIKnvhWJtM6QF2T5zLytq3ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+kbJB/64DQXljpMrAguMx12NymeNvGD9nObIi2hAlc=;
 b=oFhlt10d3CJMHV+6qHVmH90CIGrZaSM0ohqWG1ppFy9E7P4HXhKN66mu6QtjF0q2NXeM/LluUdGGUCXC/I/74I7yauT+A5KpzRjaG/0zUtFvkVvtws+0iPCCCRAfU/0eySwHVMHBQuNHjk9N2TkL3aTQQkOtAJF5aZAy9th1sCkUs7sV+VkE5O3VnoVmw8dOMYGOst2998lJ8Md9BZrwfiq7VxYTcxCayGInWRTWgtaR+ksaVXVoNGgKDnEtYeMzFFmirQUZlsNKomCwHMv5KV6EOXtshGJeETNQGGF87qVWayL2sNo/zn4B077cROtTGQ1Q9SFOt7tU/Sp8thl3mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7922.namprd11.prod.outlook.com (2603:10b6:930:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.34; Sat, 18 May
 2024 15:41:22 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Sat, 18 May 2024
 15:41:22 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "sagis@google.com"
	<sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"dmatlack@google.com" <dmatlack@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GZCeQAgAAJxQCAAAs0AIAADfKAgACpkgCAADtVgIAAM8qAgABz1ICAAF5sAIABZ7wAgACnZ4A=
Date: Sat, 18 May 2024 15:41:21 +0000
Message-ID: <0d48522f37d75d63f09d2a5091e3fa91913531ee.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
	 <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
	 <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
	 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
	 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
	 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
	 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
	 <20240516194209.GL168153@ls.amr.corp.intel.com>
	 <ffd24fa5-b573-4334-95c6-42429fd9ee38@intel.com>
	 <20240517081440.GM168153@ls.amr.corp.intel.com>
	 <b6ca3e0a18d7a472d89eeb48aaa22f5b019a769c.camel@intel.com>
In-Reply-To: <b6ca3e0a18d7a472d89eeb48aaa22f5b019a769c.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7922:EE_
x-ms-office365-filtering-correlation-id: c8331b06-9281-406d-0ca8-08dc7750f7e5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?cWI3TTFUK1k1cnRvaFlGRGVmRDVKTXpyU1N1MXd3eGgxSnlHOW1RYk9mb09m?=
 =?utf-8?B?RWI1MjlGKytoMWpzZ3E5WnBMQWFGQWdzR0pFM0Q1YW91bkp2b0poeHVpWkVu?=
 =?utf-8?B?aWpxUXlZNkVVZ1hTeFlwVXRJczRWL2pKemxOSFpGUTFZRFYvcG1xSjkyYW0v?=
 =?utf-8?B?cEdMK1ZiN0RiQUk2bUJ2ak0yOVE0TVJldDkyRFgyRGJrMnJrZ1hOaFlSWm54?=
 =?utf-8?B?YTlqMklZZGgyRlV5dGIycWVja1JsMzRpYmMwK0lPb09MVGhrbmFWREgwb2NG?=
 =?utf-8?B?YWFPMzluR3FVdUNPTWxpejFGRWJSWVQzREo4aTlvMkFWUjE4aDUvVUpucHE1?=
 =?utf-8?B?OXQyQk9PRllQNTRnd2dTZDdhOWhETEtlOVUrakUyMHpBQ3lCdTRVVm1WVEZJ?=
 =?utf-8?B?U0lvdjJUakdMRnJOaDlIakdCZ08zbVlSdkx0SS82bnRRTjJJc3Rldml6NTdI?=
 =?utf-8?B?dVRET2FvUU42Z1dwOHVWNDNPY01rRVpLOW4xbi9kSDREYm43aXFlSzZ6dDdY?=
 =?utf-8?B?NGZQL2sxemIyeFRCRWp1aGIzWU1vYll6RUFmbGNUTjkxRzVUclpNcUlDK0E0?=
 =?utf-8?B?N1pJZFk0MDArTkwrR2RVYk9ONXAvTlpLaklFYXFCZmlBVFNMRmFWVWt4cklQ?=
 =?utf-8?B?c004K0E2MUJCWU5qeENucTZRZDJ0Q09hL09NOWF5dlRhbjJIc2JobG10akdP?=
 =?utf-8?B?L2M1cVdGWG93Y0NtQXpEb1JIa2VjeE4xamo1NXZjQkJCQXVUbkZCKzBtMWRT?=
 =?utf-8?B?dGpVeEFLMWZMN3YwUjlEQk5wNlNyc09hVlZNSUlodzh2eU53cC93Rm1XekFJ?=
 =?utf-8?B?ckFEVWNtVUxhNDZZbTBDRS9ac3kwdFBsMnExemFUU0pBVmh5M1VkU0lyZm1o?=
 =?utf-8?B?MkQzNUFxUEJXSTcrQnJHSXhwSncvT2VIOHNCbWJLbnpRNVFrUmdxSmVUMVAv?=
 =?utf-8?B?dCtPWUk2SVJhTjAvWE10NFBWblc4MDhKSW5CeVJ3ZlcvRHFtV3RJVEZDVS9C?=
 =?utf-8?B?RDFjc1E0ekU1NjdrVzNOOGhsYzFzOWp2dzhrNDUwa0JQU3YzSFFrT0dPanda?=
 =?utf-8?B?LytRSnZCQ1BrR1g3WmVmeDJiaXhYM3R4NUMzeU8rUDNGLyt1U3krY3gvNVJv?=
 =?utf-8?B?Umo4M1NtTHM4eW5VNGZwaVB1UnhVdDJQY3V1T3h3VDN4T09BQy84WURsU1Vl?=
 =?utf-8?B?OUFZTW9nMm1oMmV5Wmh1Z0ZBdVFLdkxhcmhLcUJEVHQ2NHgxUWxHOEsxbklh?=
 =?utf-8?B?cnY5RC9LQXl0WDJCV01qMW1ZLytqby9BZ1lqWm5WR2xreE5abVcrV1g2QldP?=
 =?utf-8?B?MnhUZCs2ZmFpVDhhbzYwL0FSSk9uRytxNnk5K3NwVWVaVUJxa01uTmpqd1Fu?=
 =?utf-8?B?MFZxSGFQV2xncW4zb0tMMWRPT1hQUkppRnh4YmdRcUVCM05KTFh2RVErRTUy?=
 =?utf-8?B?RlBDcmlJakFBYmRjRyt3WmNyWkJPQng2czRoZmFVTUI1YTkzWjRGOGF1Tisr?=
 =?utf-8?B?REo3R2xrRTlkZjJMcXd4UGhnSFR3S2QreEYrU2dmcmZMOVVGVkdCOGV3SUsx?=
 =?utf-8?B?bDlxZUh1djlFY2NKSEc0Mk55SWNIRzB0cHE5aXR6aHJmMHhlbHY2Q3BzYjQv?=
 =?utf-8?B?WFhDMkY3Q01MaHNLTnNtWkRPV3ptRGNmWUxTZFVnSzBHVy9LMWQweXFKYWdx?=
 =?utf-8?B?NHE3UGdpenFoMzcycVJ3cDh6SkxSNlR6T2tjbEVlQ0ZVc1h0SmxXWmdPdS9V?=
 =?utf-8?B?MG85Q1Y1NFNndGJqeU5wcmtKcVdjK1hGRVFPSVNndzFtUDZkQ2ZaRkl1a0hE?=
 =?utf-8?B?TnR2a1QzZHcvMXZSc1VYUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDg3c2szY21CVE9Hdncvazg4TmFUOVdQTW9XMlNWUkpJLzdaTzFuQ2Nuc0xy?=
 =?utf-8?B?RTM3bStYaHVJQktuc1dRQXRGK0pNalBSUnJsaklscWl0bmRYWnVaS1pGQzhm?=
 =?utf-8?B?ZjRaZmNwY0ZyZE95eFlQUGNTQ3p6NXlPVjFadCtyUEgyVnJqdUUwNngvL3VQ?=
 =?utf-8?B?aTVJRXRIaVFqcVdicC9LTVExL2tRdDYxQm9IZSs3dXFKc0VDV1lHWmFYb1F5?=
 =?utf-8?B?VEVTaUcyanZ1cjBYYWlCWDhUQVBoS1AxVkgvSnJjbk1scEdaRlNrRHhLWmJM?=
 =?utf-8?B?Q3Zyb2swZHFhM2tBSEJoVzBKalNOTysya09GZmNsZkxZWENHSEN4NzBRZ2dT?=
 =?utf-8?B?UmRtbTk5WmlmNHNMZkY4Rk1UVXNpeHRrM1N5Y05kSk95YzZhU2tzSVVERGJn?=
 =?utf-8?B?bllsVkFHZ0dSQ3lrb2RvZkdFNDdqVHB4YXdrV2JsU3ZDSTVEdDVJcDlnUWdu?=
 =?utf-8?B?YXRkNis0RE1zOTA4cUlDdHB3Uk5BTGlhUm1YVVNFMVF6VFVDZjZQWHpHQnB3?=
 =?utf-8?B?NkdtUUtXZnFGdzE5bW8xaC9XTy9haWpUNkJWcDd1WDNDZ0ZwV09WTU0zT3BD?=
 =?utf-8?B?OERzTTFIakI3Szd6YlBwUk04cStHOVlRWHdjTElKVnVFSWUwNUZ0SWkwd3Vn?=
 =?utf-8?B?Zm9qb0s2K1F5VCt5QnIydmtwcTRLTXF6NHZUVnlqQXQ5NUI5VlVibW00OTVU?=
 =?utf-8?B?VktjaE8rSXM0cHkvL3VUdVhXdjVMaEt2dDRLSWNmWkorbWJQN2lBQjRZdGJX?=
 =?utf-8?B?RVVnOFVlelJqMjNORllSVVpvbGNaZzdyeE90d0tCS20rZTZUWHoxcENSTklv?=
 =?utf-8?B?U3BaUFVTSXdFRXIwcHFFMEQvUUhSV3NYRnJJS0RqaDVOTzViS0hFSEpVMUFo?=
 =?utf-8?B?dHFxUkJ2ekVPMzBlbnFaVFUyeTVkMzlhY1NRYjR4VTA3dWQ0Wm5hYzRuOHdP?=
 =?utf-8?B?bG5HMmQ5ZlY2MjFpZDNhYzVYeHByQ1g5NGxGVmhZMWZncS92cUpBcUZzZDlM?=
 =?utf-8?B?V3hCL0NaNW1Hcys2UjU5d25NS0N2UjhaSEZqaTNEQXcrWDRKZGdOZjNXdnNB?=
 =?utf-8?B?ZXEwaFRkR0dCaUw4RWNKekREdElTTk1IZWdpVm1acDRWb1duSXIwcG92RFRH?=
 =?utf-8?B?U3hZWUV6TGVETnJjcUNvUUU4SS9ZR09qQ0lLQ0ZmYjU1dXduU1NWb2tVY0Na?=
 =?utf-8?B?MkphRlNaVmlCRUVvd2xHRVVzWllGVlZLcE9sSHcwZVVrdm5BUW80NDV6dmV0?=
 =?utf-8?B?NlRqT3gvcHorZkloOFFweVh0aldrcEQ3Zm15SlJibkNwOWd2UTFsaGZIemJT?=
 =?utf-8?B?LzdZVXBQNnNxdzNESkxzaXBoYlJsdjB4Y1RscjU5YTBBTStRN0NHUWNlb1F1?=
 =?utf-8?B?eGEwODk1MFZWazI3eks2aDBDdEd3bFgyWDNiVVBseUVHNGdiNHZYYkdtTkda?=
 =?utf-8?B?VElEQ3JmNGo1UThtVGxSS3UxZFlPb2N5V3dod2hnU242dWVMcjJQSzk3c2VT?=
 =?utf-8?B?ZTMyakRVMFVDY0Q5VkM4UmR5RStOODd3SDdqOFIxaUJ6SUJwaERFQ3g5VytI?=
 =?utf-8?B?WThEWS9LSzNScFRjSHdicDRVUStuQS96dHNMWHpOYlI3OXpMVzRwaUVNaHpN?=
 =?utf-8?B?NGx2NWppcTdIRjZMUysvcXoyaEdYeXkzNFNsZlhUalpkd0NHVkZRRTJRbThp?=
 =?utf-8?B?cGpDQ2U4ZmZqR01raE90VjFNMTNWNlI2VWxZekhrd2hQbFM3dklIaEFvMGlt?=
 =?utf-8?B?b0pkN0tBbzdGb3NPTlgxZ0JtbDRCNlB1UFFJdkplK0NpRkNlbUV3SHF4eTRr?=
 =?utf-8?B?ZjcvUDhYWjNnaDFubUw3d1VoenQ1dkIwZ01pZVd2RjhOUVZLVjFVNXJybG1K?=
 =?utf-8?B?aXphTzY0eHdnS25OL2pWVWtPTnM4RjRQaVMrZmtPL0RIckZ0UDRDQ3VVbTEv?=
 =?utf-8?B?Um9xS0k5Q1RQYW9aNkZxK1NPT2M5ekZaaHpjQjNtQ0w2OGUycjBsbFBXMVlh?=
 =?utf-8?B?dWRQQ2dkbEJhQzRUWVkwU3l2eXdJV1NJcVZBMmxOeGdFUUVpdzFGQ3RlTzBY?=
 =?utf-8?B?YTF2aWoyOHY4dkZ0RU1zNlB4dHF6a29jeUpjcWYzQU4wQ0VraTlZM2tCQXRP?=
 =?utf-8?B?OFVzaG1NTHBXNnoyakZvc0VEUTNZbTdCTEdaYkhNdHdMWDE5OVFDdTZtVmYy?=
 =?utf-8?B?NXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA108F9BC3FD0C429182EF53F2EAADF8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8331b06-9281-406d-0ca8-08dc7750f7e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2024 15:41:21.9804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qFrmDxj8vaNNXwH0DIDmsZL1jDFMTJRTdTMxTvLOGHPCXwy2DqvGJFGvPoldWf+prnlaw/B6Bz3AQ5Tohg89OeBnCgjfPPg4MwAuWrbe/DY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7922
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTA1LTE4IGF0IDA1OjQyICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAN
Cj4gTm8uwqAgSSBtZWFudCAidXNpbmcga3ZtX21tdV9wYWdlLnJvbGUubWlycm9yZWRfcHQgdG8g
ZGV0ZXJtaW5lIHdoZXRoZXIgdG8NCj4gaW52b2tlIGt2bV94ODZfb3BzOjp4eF9wcml2YXRlX3Nw
dCgpIiBpcyBub3QgY29ycmVjdC4NCg0KSSBhZ3JlZSB0aGlzIGxvb2tzIHdyb25nLg0KDQo+IMKg
IEluc3RlYWQsIHdlIHNob3VsZA0KPiB1c2UgZmF1bHQtPmlzX3ByaXZhdGUgdG8gZGV0ZXJtaW5l
Og0KPiANCj4gwqDCoMKgwqDCoMKgwqDCoGlmIChmYXVsdC0+aXNfcHJpdmF0ZSAmJiBrdm1feDg2
X29wczo6eHhfcHJpdmF0ZV9zcHQoKSkNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBrdm1feDg2X29wczo6eHhfcHJpdmF0ZV9zcHRlKCk7DQo+IMKgwqDCoMKgwqDCoMKgwqBlbHNl
DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLy8gbm9ybWFsIFREUCBNTVUgb3Bl
cmF0aW9uDQo+IA0KPiBUaGUgcmVhc29uIGlzIHRoaXMgcGF0dGVybiB3b3JrcyBub3QganVzdCBm
b3IgVERYLCBidXQgYWxzbyBmb3IgU05QIChhbmQNCj4gU1dfUFJPVEVDVEVEX1ZNKSBpZiB0aGV5
IGV2ZXIgbmVlZCBzcGVjaWZpYyBwYWdlIHRhYmxlIG9wcy4NCg0KSSB0aGluayB0aGUgcHJvYmxl
bSBpcyB0aGVyZSBhcmUgYSBsb3Qgb2YgdGhpbmdzIHRoYXQgYXJlIG1vcmUgb24gdGhlIG1pcnJv
cmVkDQpjb25jZXB0IHNpZGU6DQogLSBBbGxvY2F0aW5nIHRoZSAicmVhbCIgUFRFIHBhZ2VzIChp
LmUuIHNwLT5wcml2YXRlX3NwdCkNCiAtIFNldHRpbmcgdGhlIFBURSB3aGVuIHRoZSBtaXJyb3Ig
Y2hhbmdlcw0KIC0gWmFwcGluZyB0aGUgcmVhbCBQVEUgd2hlbiB0aGUgbWlycm9yIGlzIHphcHBl
ZCAoYW5kIHRoZXJlIGlzIG5vIGZhdWx0KQ0KIC0gZXRjDQoNCkFuZCBvbiB0aGUgcHJpdmF0ZSBz
aWRlIHRoZXJlIGlzIGp1c3Qga25vd2luZyB0aGF0IHByaXZhdGUgZmF1bHRzIHNob3VsZCBvcGVy
YXRlDQpvbiB0aGUgbWlycm9yIHJvb3QuDQoNClRoZSB4eF9wcml2YXRlX3NwdGUoKSBvcGVyYXRp
b25zIGFyZSBhY3R1YWxseSBqdXN0IHVwZGF0aW5nIHRoZSByZWFsIFBURSBmb3IgdGhlDQptaXJy
b3IuIEluIHNvbWUgd2F5cyBpdCBkb2Vzbid0IGhhdmUgdG8gYmUgYWJvdXQgInByaXZhdGUiLiBJ
dCBjb3VsZCBiZSBhIG1pcnJvcg0Kb2Ygc29tZXRoaW5nIGVsc2UgYW5kIHN0aWxsIG5lZWQgdGhl
IHVwZGF0ZXMuIEZvciBTTlAgYW5kIG90aGVycyB0aGV5IGRvbid0IG5lZWQNCnRvIGRvIGFueXRo
aW5nIGxpa2UgdGhhdC4gKEFGQUlVKQ0KDQpTbyBiYXNlZCBvbiB0aGF0LCBJIHRyaWVkIHRvIGNo
YW5nZSB0aGUgbmFtaW5nIG9mIHh4X3ByaXZhdGVfc3B0KCkgdG8gcmVmbGVjdA0KdGhhdC4gTGlr
ZToNCmlmIChyb2xlLm1pcnJvcmVkKQ0KICB1cGRhdGVfbWlycm9yZWRfcHRlKCkNCg0KVGhlIFRE
WCBjb2RlIGNvdWxkIGVuY2Fwc3VsYXRlIHRoYXQgbWlycm9yZWQgdXBkYXRlcyBuZWVkIHRvIHVw
ZGF0ZSBwcml2YXRlIEVQVC4NClRoZW4gSSBoYWQgYSBoZWxwZXIgdGhhdCBhbnN3ZXJlZCB0aGUg
cXVlc3Rpb24gb2Ygd2hldGhlciB0byBoYW5kbGUgcHJpdmF0ZQ0KZmF1bHRzIG9uIHRoZSBtaXJy
b3JlZCByb290Lg0KDQpUaGUgRlJFRVpFIHN0dWZmIGFjdHVhbGx5IG1hZGUgYSBiaXQgbW9yZSBz
ZW5zZSB0b28sIGJlY2F1c2UgaXQgd2FzIGNsZWFyIGl0DQp3YXNuJ3QgYSBzcGVjaWFsIFREWCBw
cml2YXRlIG1lbW9yeSB0aGluZywgYnV0IGp1c3QgYWJvdXQgdGhlIGF0b21pY2l0eS4NCg0KVGhl
IHByb2JsZW0gd2FzIEkgY291bGRuJ3QgZ2V0IHJpZCBvZiBhbGwgc3BlY2lhbCB0aGluZ3MgdGhh
dCBhcmUgcHJpdmF0ZSAoY2FuJ3QNCnJlbWVtYmVyIHdoYXQgbm93KS4NCg0KSSB3b25kZXIgaWYg
SSBzaG91bGQgZ2l2ZSBpdCBhIG1vcmUgcHJvcGVyIHRyeS4gV2hhdCBkbyB5b3UgdGhpbms/DQoN
CkF0IHRoaXMgcG9pbnQsIEkgd2FzIGp1c3QgZ29pbmcgdG8gY2hhbmdlIHRoZSAibWlycm9yZWQi
IG5hbWUgdG8NCiJwcml2YXRlX21pcnJvcmVkIi4gVGhlbiBjb2RlIHRoYXQgZG9lcyBlaXRoZXIg
bWlycm9yZWQgdGhpbmdzIG9yIHByaXZhdGUgdGhpbmdzDQpib3RoIGxvb2tzIGNvcnJlY3QuIEJh
c2ljYWxseSBtYWtpbmcgaXQgY2xlYXIgdGhhdCB0aGUgTU1VIG9ubHkgc3VwcG9ydHMNCm1pcnJv
cmluZyBwcml2YXRlIG1lbW9yeS4NCg0KPiANCj4gV2hldGhlciB3ZSBhcmUgb3BlcmF0aW5nIG9u
IHRoZSBtaXJyb3JlZCBwYWdlIHRhYmxlIG9yIG5vdCBkb2Vzbid0IG1hdHRlciwNCj4gYmVjYXVz
ZSB3ZSBoYXZlIGFscmVhZHkgc2VsZWN0ZWQgdGhlIHJvb3QgcGFnZSB0YWJsZSBhdCB0aGUgYmVn
aW5uaW5nIG9mDQo+IGt2bV90ZHBfbW11X21hcCgpIGJhc2VkIG9uIHdoZXRoZXIgdGhlIFZNIG5l
ZWRzIHRvIHVzZSBtaXJyb3JlZCBwdCBmb3INCj4gcHJpdmF0ZSBtYXBwaW5nOg0KDQpJIHRoaW5r
IGl0IGRvZXMgbWF0dGVyLCBlc3BlY2lhbGx5IGZvciB0aGUgb3RoZXIgb3BlcmF0aW9ucyAobm90
IGZhdWx0cykuIERpZA0KeW91IGxvb2sgYXQgdGhlIG90aGVyIHRoaW5ncyBjaGVja2luZyB0aGUg
cm9sZT8NCg0KPiANCj4gDQo+IMKgwqDCoMKgwqDCoMKgwqBib29sIG1pcnJvcmVkX3B0ID0gZmF1
bHQtPmlzX3ByaXZhdGUgJiYga3ZtX3VzZV9taXJyb3JlZF9wdChrdm0pOw0KPiANCj4gwqDCoMKg
wqDCoMKgwqDCoHRkcF9tbXVfZm9yX2VhY2hfcHRlKGl0ZXIsIG1tdSwgbWlycm9yZWRfcHQsIHJh
d19nZm4sIHJhd19nZm4gKw0KPiAxKSANCj4gwqDCoMKgwqDCoMKgwqDCoHsNCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAuLi4NCj4gwqDCoMKgwqDCoMKgwqDCoH0NCj4gDQo+ICNk
ZWZpbmUgdGRwX21tdV9mb3JfZWFjaF9wdGUoX2l0ZXIsIF9tbXUsIF9taXJyb3JlZF9wdCwgX3N0
YXJ0LCBfZW5kKcKgwqAgXA0KPiDCoMKgwqDCoMKgwqDCoCBmb3JfZWFjaF90ZHBfcHRlKF9pdGVy
LMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFwNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgcm9vdF90b19zcCgoX21pcnJvcmVkX3B0KSA/IF9tbXUtPnByaXZhdGVfcm9vdF9ocGEg
OsKgwqAgXA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBfbW11LT5yb290LmhwYSkswqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBfc3RhcnQsIF9lbmQpDQo+IA0KPiBJZiB5b3Ugc29tZWhvdyBuZWVkcyB0aGUgbWlycm9yZWRf
cHQgaW4gbGF0ZXIgdGltZSB3aGVuIGhhbmRsaW5nIHRoZSBwYWdlDQo+IGZhdWx0LCB5b3UgZG9u
J3QgbmVlZCBhbm90aGVyICJtaXJyb3JlZF9wdCIgaW4gdGRwX2l0ZXIsIGJlY2F1c2UgeW91IGNh
bg0KPiBlYXNpbHkgZ2V0IGl0IGZyb20gdGhlIHNwdGVwIChvciBqdXN0IGdldCBmcm9tIHRoZSBy
b290KToNCj4gDQo+IMKgwqDCoMKgwqDCoMKgwqBtaXJyb3JlZF9wdCA9IHNwdGVwX3RvX3NwKHNw
dGVwKS0+cm9sZS5taXJyb3JlZF9wdDsNCj4gDQo+IFdoYXQgd2UgcmVhbGx5IG5lZWQgdG8gcGFz
cyBpbiBpcyB0aGUgZmF1bHQtPmlzX3ByaXZhdGUsIGJlY2F1c2Ugd2UgYXJlDQo+IG5vdCBhYmxl
IHRvIGdldCB3aGV0aGVyIGEgR1BOIGlzIHByaXZhdGUgYmFzZWQgb24ga3ZtX3NoYXJlZF9nZm5f
bWFzaygpDQo+IGZvciBTTlAgYW5kIFNXX1BST1RFQ1RFRF9WTS4NCg0KU05QIGFuZCBTV19QUk9U
RUNURURfVk0gKHRvZGF5KSBkb24ndCBuZWVkIGRvIGFueXRoaW5nIHNwZWNpYWwgaGVyZSwgcmln
aHQ/DQoNCj4gDQo+IFNpbmNlIHRoZSBjdXJyZW50IEtWTSBjb2RlIG9ubHkgbWFpbmx5IHBhc3Nl
cyB0aGUgQGt2bSBhbmQgdGhlIEBpdGVyIGZvcg0KPiBtYW55IFREUCBNTVUgZnVuY3Rpb25zIGxp
a2UgdGRwX21tdV9zZXRfc3B0ZV9hdG9taWMoKSwgdGhlIGVhc2llc3Qgd2F5IHRvDQo+IGNvbnZl
cnkgdGhlIGZhdWx0LT5pc19wcml2YXRlIGlzIHRvIGFkZCBhIG5ldyAnaXNfcHJpdmF0ZScgKG9y
IGV2ZW4NCj4gYmV0dGVyLCAnaXNfcHJpdmF0ZV9ncGEnIHRvIGJlIG1vcmUgcHJlY2lzZWx5KSB0
byB0ZHBfaXRlci4NCj4gDQo+IE90aGVyd2lzZSwgd2UgZWl0aGVyIG5lZWQgdG8gZXhwbGljaXRs
eSBwYXNzIHRoZSBlbnRpcmUgQGZhdWx0ICh3aGljaA0KPiBtaWdodCBub3QgYmUgYSwgb3IgQGlz
X3ByaXZhdGVfZ3BhLg0KPiANCj4gT3IgcGVyaGFwcyBJIGFtIG1pc3NpbmcgYW55dGhpbmc/DQoN
CkkgdGhpbmsgdHdvIHRoaW5nczoNCiAtIGZhdWx0LT5pc19wcml2YXRlIGlzIG9ubHkgZm9yIGZh
dWx0cywgYW5kIHdlIGhhdmUgb3RoZXIgY2FzZXMgd2hlcmUgd2UgY2FsbA0Kb3V0IHRvIGt2bV94
ODZfb3BzLnh4X3ByaXZhdGUoKSB0aGluZ3MuDQogLSBDYWxsaW5nIG91dCB0byB1cGRhdGUgc29t
ZXRoaW5nIGVsc2UgaXMgcmVhbGx5IG1vcmUgYWJvdXQgdGhlICJtaXJyb3JlZCINCmNvbmNlcHQg
dGhlbiBhYm91dCBwcml2YXRlLg0K

