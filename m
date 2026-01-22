Return-Path: <kvm+bounces-68856-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wJ1YNSTEcWnfLwAAu9opvQ
	(envelope-from <kvm+bounces-68856-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 07:31:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 81864623F2
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 07:31:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 132FE4A833E
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE2093F075F;
	Thu, 22 Jan 2026 06:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lK71GcVS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD4C315D23;
	Thu, 22 Jan 2026 06:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769063442; cv=fail; b=Cmxh4IdqrtKWgiC4uLg/F75pBCINej8s/Ht8ZrUUI0FlvHSlWEhYzW0nqLsvv54UpQqDTTc9LgkBaeU8EtQsITQ02DRME6oUmXmY5ZT+BY9UqFud8pAmnVJ9SVRnnQO8qZxDW4C0zABjmb9dHzHXTkDpwnSttGd97UffyEkzdwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769063442; c=relaxed/simple;
	bh=xTmX+xh6Rr680AsIX+3AURyKgYsN5WCyM6Opk3w6Ma4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m8m5jMgG+7kXiuTss8cfcAHoJsncrOCLwbBte66geGbvs6WXqUnYcHah21jU0XwbIIDB3tLZRjLj7BOq5el9+qascwyCVm19zf/QIZ+lnN97hvT7kSrERx8soYzd0YACvKmJHMUnn+EZ1PfwIke4XZtmUogAzXyMMSyMQnT/++Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lK71GcVS; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769063439; x=1800599439;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=xTmX+xh6Rr680AsIX+3AURyKgYsN5WCyM6Opk3w6Ma4=;
  b=lK71GcVSqj/GmA3lR9Opsn4LPnwLKqoSn9B5GCAhgE+RoDe+0TWKG0PL
   l+myXICLMo0Gr/qqP7qKrojThdNao9r3PvAn02ngBnlqCwUYFe1Sb6h8g
   ggNxUpje73T5tXPCuwtAcr1ZaOkR1XPMy77YSi+EK+OdkVh9s7lOBycf+
   ig+PeaHzhzyPDmHk7kQpvg3/qzQqD8Dk+rd+SvEGo+GrmrBXsC1gmL4Q/
   AU9o4TByAoV93WkcZpfd7FmzmnrjHpcctTRGp8BGjMq8QRfBsCy6P+2xb
   VHcSkDlKqduI4yHRXeqkW+8bmFWWiA0zaZ44Fghx2A+qGl8hm919H+lbr
   Q==;
X-CSE-ConnectionGUID: +EYLg9CSTPyH/NrdGU1ypA==
X-CSE-MsgGUID: IXk8tCLUQqKPJ5Ykt94moA==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="74151478"
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="74151478"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 22:30:39 -0800
X-CSE-ConnectionGUID: ym4Iw0aFRxaOPJbm/RzKIQ==
X-CSE-MsgGUID: ZRYJacm2QdSyjUdG+lo1xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="210806106"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 22:30:39 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 22:30:37 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 21 Jan 2026 22:30:37 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.58)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 22:30:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B2zsPAKKRIFK6t39me6JjjTKeCwV7HYquI7BqnSozeVc1dbzhPo+w/I+aGYOL24tXijaSE4PPbPV4bMlcRaTpsoE7iwCzuW+7TDXhZUlwiiac6pJYhh2ppmgr6Q+cULFup/gBKd9FE8FOTplVdkiDkRVYT2osDSu9I/+ak/pbacmcNs4+Vl1xbOHxRgCpdA8GRZ8bn7jHnH2mszuIA1zFc16hrnDv/YW9pWeSNyzN3kbtiwREoGnuRpt13brQSVjuDH3vlNH3L7AD6wi7Gu1NkXqj+fB0+DZFg2Lxh95xNzEwRHuvsovwJeBvH8WI87uXLyT4pEuqoRl59zqvRhyIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rlddBSC2RqEBhPCfKtqjALGNrZt21/li+jU+SLsme74=;
 b=Ag/Wp+sP1QgBJ9MfjdAuCLeyD72vBBfbQwfaQ4GN3+9E0iFDIz3lj63OrAkmJBUH5v8kkphQad/LEK/JtGrKLFO4UgvTH917Ua60RAn+DvbAh6jEQZl8z6Jk2RhkVxH4BYB/FkcHad97wmVR4pU2tvS287AAR0IOVNuJkjHrELfZXqFqgHglFg7BBSnouatGQo21/d4CG6Wmcqx0DWDoRGm3OU1dX+W/LHbNBgraMsgipbJk+54mgs/ScH+6ydWxGJn7DCv/Otn0uyiZAphhwtgie79/IDpY3MLb1IHX1EvQHJQZR3EuBbBkX1qsUI3MmDF8Pg/kMUL1PVJ+9gCVhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL3PR11MB6529.namprd11.prod.outlook.com (2603:10b6:208:38c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Thu, 22 Jan
 2026 06:30:33 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9542.009; Thu, 22 Jan 2026
 06:30:33 +0000
Date: Thu, 22 Jan 2026 14:27:45 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Kai Huang <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Fan Du
	<fan.du@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao
	<chao.gao@intel.com>, Dave Hansen <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "david@kernel.org"
	<david@kernel.org>, "kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Chao P
 Peng" <chao.p.peng@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>, Jun Miao <jun.miao@intel.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 11/24] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Message-ID: <aXHDYWN7AlK/KqoO@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106102136.25108-1-yan.y.zhao@intel.com>
 <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com>
 <aWrMIeCw2eaTbK5Z@google.com>
 <aW2Iwpuwoyod8eQc@yzhao56-desk.sh.intel.com>
 <aW_Aith2qkYQ3fGY@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aW_Aith2qkYQ3fGY@google.com>
X-ClientProxiedBy: KL1PR0401CA0035.apcprd04.prod.outlook.com
 (2603:1096:820:e::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL3PR11MB6529:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b374d0a-356a-49a5-d061-08de597fbeb9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ST76cgI1PWyhJGP4PIzofK3SaA01G+s4eLMhSij+RY+DwH2cFzq6F2Qz56KG?=
 =?us-ascii?Q?rS5KlF0bZ8ijXDtx/XF3mToAqbyD8hNiu5yQoZma3tgTVSIC8899y9Qn6Yl/?=
 =?us-ascii?Q?eiihJCVmPi68X9Fsa1hnJlOqWEeYopZerNgmGYhm5LUQXuyOjDFXm6RAX4jw?=
 =?us-ascii?Q?yR7Hu4U7uQYtZx5wh+tHNcYqoZ4mRhzuViRfIcCaqvO/B4uX+vN3j1i3wnWR?=
 =?us-ascii?Q?UpPftlp3rQmiKisGxYKfTcQ5sCCau//SElVyqq895hN9Yg0evIzGjJt3650n?=
 =?us-ascii?Q?LRD7jVHrJSZxvqnZFhquP9qwTobLbx/hLER4/eQwLq41g0P0XIjKh14dFmaA?=
 =?us-ascii?Q?vtqSxP25xXsID6e67n8jga+iTZBuVd6HFJew1qYZIHsEBJiqnnTkXPQfkjZc?=
 =?us-ascii?Q?pKyOp66Yl4ZsoV/aYlVj+OVf3Fc0xyULWW3NIMiLD/itOazThOKdgVKJXdZO?=
 =?us-ascii?Q?86g7uq2R4Fw/2aBDifH+uD4I5HMdB4mJv6Sv9N8PxfClwyAHU6nhrL/RomSw?=
 =?us-ascii?Q?g53T6ouPDOg66y4wH9I4zvlnM8ziZl28enTvgsmrg78M9hzcqhI+SnyBzVNR?=
 =?us-ascii?Q?Lo35tiyH3slgWK3N1TvYxdu07J4CgdO34dXcUICxbuw+rkuqGHpOC8oUvJEM?=
 =?us-ascii?Q?jiGnKkXfwMCzlO1omvnuX06AzJoXuKJrll3X+8IXNloS+QXdn4DV8RF3E9Qt?=
 =?us-ascii?Q?gZyqRQZdXwE3TCdx033d3CByg4FIw7xidGF2uA1EO2ncdYitLCPnP9SayRJy?=
 =?us-ascii?Q?PeV72NxDq6FuSHEsgSUYsqtXyE2ZGBHHmSsVg2DozMFSkqUUrDsMm/RCQ46C?=
 =?us-ascii?Q?MiH/ZcflUHoUCE7DwZvIwWBOu9DFrIuVTIxYBmFtZvGPOIrAFqRElzDnu0Q7?=
 =?us-ascii?Q?mQ+C4uuZaYfRieKYAVoKMKM1TiGJwJt9PHpGJxxweWLOppe+HGqrTpEvcg8c?=
 =?us-ascii?Q?7SOrf9TAXh2zg6p/f/Ga7R3n4Td4YT/163YVc5bJmEfwDDPlmqxD33HzDPcl?=
 =?us-ascii?Q?EdngLBTSfjuG2vjAFNVSjHf+M3oYItM2ANlZiSacSraWPYFLtcHSK0GRUGi1?=
 =?us-ascii?Q?su45jE1PK4WcpR98U3NmrGmoRVJ9rTTruNSWU1K5taNslUlVPQE8qQu4Se5r?=
 =?us-ascii?Q?cHl+v0urQmycNQpDjdmWinDCzHawLlDO2s2YHRYcCM5iVOBET2Ri8+TXgh4s?=
 =?us-ascii?Q?t3oqrxXuEzK7EPeVxNsA4BCdcDk39scv+20Pk3+/+Vxm4pBJZi9+Ib5bG5y/?=
 =?us-ascii?Q?nWPpXwUZVnizLphAVT7t7avbVWWVEiSNc4I6k5kpIPyMC9JX5281nYkuHJI/?=
 =?us-ascii?Q?5+4dxY43YQds+CyrTEg7rnffEKrY8aSmzFKpozDwyGpPUtUbwQmWMT2I6ra2?=
 =?us-ascii?Q?Yn3ejk4qkUXlH6wTASS3aY58TW5+0l4x1LCZSEIAabuf0rZw9oXKzl3ZGQvk?=
 =?us-ascii?Q?D1B3trJYVnm/UC7H9438dP6uvKz1NNBLAPJfsHjxN/eIgiZYIBLNPhIEVOyx?=
 =?us-ascii?Q?cIG+NFsVf8tB+E43lHkyJB0vLFpXsWw1SbqkC4cF5EYHCnAVe+URRXmYRz/y?=
 =?us-ascii?Q?MdLasUo4JDY515zfXp0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LqxRaOQt4qAtnjpCcVygsveDBcKzTLsMe9XOp5Y53OXUqPsnsvJb7NB76T6h?=
 =?us-ascii?Q?WTECuiV2cVTBWYsdplBp2/xcmiXk5FTJyWSk99ewtcKHDGV6xfomIhGbKoQD?=
 =?us-ascii?Q?IsdifaaB/LgYchfl96Ky/7oQro0qAAeofDVZKaRg2+v6eKyFrPEt98qlih0s?=
 =?us-ascii?Q?4GSWFcK/NWbTLzAbpnRGYSEkapZuic+xPLxHMhc4ZRmT7hDCUgPlXJQKqY4g?=
 =?us-ascii?Q?Cbh04dCOVO1N+ngOEJ/FFJM8VdRK4MdknIci0XGijOGxXXrDe24LSrOO7tng?=
 =?us-ascii?Q?wo+vilF2ejYsuDBDspnggJQ/gn7Tc9LAiZj0j4z+8eh8MIGOownmWQN5nTx1?=
 =?us-ascii?Q?miEONOwAc6XuF4pIKjq72Nbjz/Y11w92DUc+IyinUpfJrYtcUpFe6ydIT7YJ?=
 =?us-ascii?Q?Q8Xw9Zb2/McKwhlbIKC9AGSUZZwfscFYFFmPPgcXBx9efGaPqnCmQOSs53nY?=
 =?us-ascii?Q?FWs6vCe0UoFFbtfXAghgC3dqrh5LjCtpo4BeVXWzr8uxaIgnEV10PUk1jhPn?=
 =?us-ascii?Q?BlP/nmpcezsVgCQ3lbsd38lhna7x4FAPgjlX++JtekmCsNRyz0OxiIgjgocQ?=
 =?us-ascii?Q?I3Wqz+uj5OHjdnqx0QE9IDgNZHcrglbgrYGTrig21lpyshslcptOFE1Pu7nZ?=
 =?us-ascii?Q?c18nrMFpuNYUzJLsyyhHuDZZoQUKrsEbW2zQjYunpPvqJ4DwSH3rLSBV09GX?=
 =?us-ascii?Q?bL4gWSrILtchKNSGis6aiN90VVRMBUankD8UE9Ab9bcSXW/jSq3l9VIYv/W2?=
 =?us-ascii?Q?VdAiz2xxfhrYLbt1VA1SdpRo/VBwCevSjpM6gWA1kzvTbw2lPlKbPL4IfOIv?=
 =?us-ascii?Q?LSarKkrJe9JMwAC1L6TaMQfvpQaxphxl9vlxZu6aMNh1bQfaS5UMOb/Ap8+Q?=
 =?us-ascii?Q?zqduMrbXPV5FOx9MzfItf3SWZWpadhw7r76w3P/KHqOW7rYMb6wBMq3qitz1?=
 =?us-ascii?Q?xc/Q4i4HC8ADosypaK5uPb00v/VqPHlGwUtRTHGrSEmycm3HG3I9avoe8Lc2?=
 =?us-ascii?Q?aAEWEGBKfGnCMcqZUttzW1XqPIMdM8ZjdZ6q06qcoYh3UbmMaHjOx5DE9ARX?=
 =?us-ascii?Q?Hyi8XPjJjx91vA5TJqRahTmIM4tPz6isMK7O7aLerebCYR3F/AC+uoU1Wh0A?=
 =?us-ascii?Q?cZX1QqR+2oUdW6MYgdqK3kx7nPTONpVk8bRR0lKGuJTNRyev/+MjMiaoy9rs?=
 =?us-ascii?Q?kF+9RdqJ6iBSyhb/Y0dGVgGxmo41dW59Js3NqpCdQyeArh5UtCltK7dUgJd2?=
 =?us-ascii?Q?0uwvguSoBKzXntEd96FMuiOPboq3WDeyiBQcxsn2bnm2ZvF6tvoXWZ7e3k/q?=
 =?us-ascii?Q?BwxQQlsxivlPQqMPTE+tCTqWSqVZvMnVEVapafZxRef+GdDTQb/BP/HRaIfW?=
 =?us-ascii?Q?DZGwnIQQ/vM/ousOHPpM5c+xgeTo5tQrtvoPEGVn9xZCK0HpGEYG5qC07PoA?=
 =?us-ascii?Q?NqAtBYQOub3ifCbCVDJSslFIGyLPBcd16+q4XvEzYHQo0sS11kzaJ7gtoAow?=
 =?us-ascii?Q?Jh8jtoZXV2rgCAH2WoWFhuNyxd4PpUzI5yBXeewXMG4HH1D8zSMp/vFn5Js7?=
 =?us-ascii?Q?WCtj63dVGe4GsMCsdj11xVj+akKUt3ZPkGFn1hvdgyujIP+3bUWkjd1VUxZN?=
 =?us-ascii?Q?PwCAEycYWIT7VpywgcI8S7sjd4gn/9+rq8TWchoLJ88dnitZBR15vVhMYDBr?=
 =?us-ascii?Q?hJ9CLfsEB8dKwcCRIN8DQbRB5uwwOXei7K1nf7mcuEOSLRIp8JavndLyvOz2?=
 =?us-ascii?Q?l0GHl9psFA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b374d0a-356a-49a5-d061-08de597fbeb9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 06:30:33.2036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: krkfbh8qVFnykOqOx4ulpkfOkDtSTsXxswwmjN7crIVT/T6LP7q0DlK0WOM7QZsgOVOW3ptavsre0WiqFcvP3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6529
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,redhat.com,vger.kernel.org,amd.com,suse.cz,google.com,kernel.org,linux.intel.com,suse.com,gmail.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-68856-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_COUNT_SEVEN(0.00)[10];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[yzhao56-desk.sh.intel.com:mid,intel.com:replyto,intel.com:dkim,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	FORGED_SENDER_MAILLIST(0.00)[];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 81864623F2
X-Rspamd-Action: no action

On Tue, Jan 20, 2026 at 09:51:06AM -0800, Sean Christopherson wrote:
> On Mon, Jan 19, 2026, Yan Zhao wrote:
> > On Fri, Jan 16, 2026 at 03:39:13PM -0800, Sean Christopherson wrote:
> > > On Thu, Jan 15, 2026, Kai Huang wrote:
> > > > So how about:
> > > > 
> > > > Rename kvm_tdp_mmu_try_split_huge_pages() to
> > > > kvm_tdp_mmu_split_huge_pages_log_dirty(), and rename
> > > > kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs() to
> > > > kvm_tdp_mmu_split_huge_pages_cross_boundary()
> > > > 
> > > > ?
> > > 
> > > I find the "cross_boundary" termininology extremely confusing.  I also dislike
> > > the concept itself, in the sense that it shoves a weird, specific concept into
> > > the guts of the TDP MMU.
> > > The other wart is that it's inefficient when punching a large hole.  E.g. say
> > > there's a 16TiB guest_memfd instance (no idea if that's even possible), and then
> > > userpace punches a 12TiB hole.  Walking all ~12TiB just to _maybe_ split the head
> > > and tail pages is asinine.
> > That's a reasonable concern. I actually thought about it.
> > My consideration was as follows:
> > Currently, we don't have such large areas. Usually, the conversion ranges are
> > less than 1GB. 
> 
> Nothing guarantees that behavior.
> 
> > Though the initial conversion which converts all memory from private to
> > shared may be wide, there are usually no mappings at that stage. So, the
> > traversal should be very fast (since the traversal doesn't even need to go
> > down to the 2MB/1GB level).
> > 
> > If the caller of kvm_split_cross_boundary_leafs() finds it needs to convert a
> > very large range at runtime, it can optimize by invoking the API twice:
> > once for range [start, ALIGN(start, 1GB)), and
> > once for range [ALIGN_DOWN(end, 1GB), end).
> > 
> > I can also implement this optimization within kvm_split_cross_boundary_leafs()
> > by checking the range size if you think that would be better.
> > 
> > > And once kvm_arch_pre_set_memory_attributes() is dropped, I'm pretty sure the
> > > _only_ usage is for guest_memfd PUNCH_HOLE, because unless I'm misreading the
> > > code, the usage in tdx_honor_guest_accept_level() is superfluous and confusing.
> > Sorry for the confusion about the usage of tdx_honor_guest_accept_level(). I
> > should add a better comment.
> > 
> > There are 4 use cases for the API kvm_split_cross_boundary_leafs():
> > 1. PUNCH_HOLE
> > 2. KVM_SET_MEMORY_ATTRIBUTES2, which invokes kvm_gmem_set_attributes() for
> >    private-to-shared conversions
> > 3. tdx_honor_guest_accept_level()
> > 4. kvm_gmem_error_folio()
> > 
> > Use cases 1-3 are already in the current code. Use case 4 is per our discussion,
> > and will be implemented in the next version (because guest_memfd may split
> > folios without first splitting S-EPT).
> > 
> > The 4 use cases can be divided into two categories:
> > 
> > 1. Category 1: use cases 1, 2, 4
> >    We must ensure GFN start - 1 and GFN start are not mapped in a single
> >    mapping. However, for GFN start or GFN start - 1 specifically, we don't care
> >    about their actual mapping levels, which means they are free to be mapped at
> >    2MB or 1GB. The same applies to GFN end - 1 and GFN end.
> > 
> >    --|------------------|-----------
> >      ^                  ^
> >     start              end - 1 
> > 
> > 2. Category 2: use case 3
> >    It cares about the mapping level of the GFN, i.e., it must not be mapped
> >    above a certain level.
> > 
> >    -----|-------
> >         ^
> >        GFN
> > 
> >    So, to unify the two categories, I have tdx_honor_guest_accept_level() check
> >    the range of [level-aligned GFN, level-aligned GFN + level size). e.g.,
> >    If the accept level is 2MB, only 1GB mapping is possible to be outside the
> >    range and needs splitting.
> 
> But that overlooks the fact that Category 2 already fits the existing "category"
> that is supported by the TDP MMU.  I.e. Category 1 is (somewhat) new and novel,
> Category 2 is not.
> 
> >    -----|-------------|---
> >         ^             ^
> >         |             |
> >    level-aligned     level-aligned
> >       GFN            GFN + level size - 1
> > 
> > 
> > > For the EPT violation case, the guest is accepting a page.  Just split to the
> > > guest's accepted level, I don't see any reason to make things more complicated
> > > than that.
> > This use case could reuse the kvm_mmu_try_split_huge_pages() API, except that we
> > need a return value.
> 
> Just expose tdp_mmu_split_huge_pages_root(), the fault path only _needs_ to split
> the current root, and in fact shouldn't even try to split other roots (ignoring
> that no other relevant roots exist).
Ok.

> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 9c26038f6b77..7d924da75106 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1555,10 +1555,9 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>         return ret;
>  }
>  
> -static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> -                                        struct kvm_mmu_page *root,
> -                                        gfn_t start, gfn_t end,
> -                                        int target_level, bool shared)
> +int tdp_mmu_split_huge_pages_root(struct kvm *kvm, struct kvm_mmu_page *root,
> +                                 gfn_t start, gfn_t end, int target_level,
> +                                 bool shared)
>  {
>         struct kvm_mmu_page *sp = NULL;
>         struct tdp_iter iter;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index bd62977c9199..ea9a509608fb 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -93,6 +93,9 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>                                    struct kvm_memory_slot *slot, gfn_t gfn,
>                                    int min_level);
>  
> +int tdp_mmu_split_huge_pages_root(struct kvm *kvm, struct kvm_mmu_page *root,
> +                                 gfn_t start, gfn_t end, int target_level,
> +                                 bool shared);
>  void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
>                                       const struct kvm_memory_slot *slot,
>                                       gfn_t start, gfn_t end,
> 
> > > And then for the PUNCH_HOLE case, do the math to determine which, if any, head
> > > and tail pages need to be split, and use the existing APIs to make that happen.
> > This use case cannot reuse kvm_mmu_try_split_huge_pages() without modification.
> 
> Modifying existing code is a non-issue, and you're already modifying TDP MMU
> functions, so I don't see that as a reason for choosing X instead of Y.
> 
> > Or which existing APIs are you referring to?
> 
> See above.
Ok. Do you like the idea of introducing only_cross_boundary (or something with a
different name) to tdp_mmu_split_huge_pages_root() ?
If not, could I expose a helper to help range calculate?


> > The cross_boundary information is still useful?
> > 
> > BTW: Currently, kvm_split_cross_boundary_leafs() internally reuses
> > tdp_mmu_split_huge_pages_root() (as shown below).
> > 
> > kvm_split_cross_boundary_leafs
> >   kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs
> >     tdp_mmu_split_huge_pages_root
> > 
> > However, tdp_mmu_split_huge_pages_root() is originally used to split huge
> > mappings in a wide range, so it temporarily releases mmu_lock for memory
> > allocation for sp, since it can't predict how many pages to pre-allocate in the
> > KVM mmu cache.
> > 
> > For kvm_split_cross_boundary_leafs(), we can actually predict the max number of
> > pages to pre-allocate. If we don't reuse tdp_mmu_split_huge_pages_root(), we can
> > allocate sp, sp->spt, sp->external_spt and DPAMT pages from the KVM mmu cache
> > without releasing mmu_lock and invoking tdp_mmu_alloc_sp_for_split().
> 
> That's completely orthogonal to the "only need to maybe split head and tail pages".
> E.g. kvm_tdp_mmu_try_split_huge_pages() can also predict the _max_ number of pages
> to pre-allocate, it's just not worth adding a kvm_mmu_memory_cache for that use
> case because that path can drop mmu_lock at will, unlike the full page fault path.
> I.e. the complexity doesn't justify the benefits, especially since the max number
> of pages is so large.
Right, it's technically feasible, but practically not.
If to split a huge range down to 4KB, like 16G, the _max_ number of pages to
pre-allocate is too large. It's 16*512=8192 pages without TDX.

> AFAICT, the only pre-allocation that is _necessary_ is for the dynamic PAMT,
Yes, patch 20 in this series just pre-allocates DPAMT pages for splitting.

See:
static int tdx_min_split_cache_sz(struct kvm *kvm, int level)
{
	KVM_BUG_ON(level != PG_LEVEL_2M, kvm);

	if (!tdx_supports_dynamic_pamt(tdx_sysinfo))
		return 0;

	return tdx_dpamt_entry_pages() * 2;
}

> because the allocation is done outside of KVM's control.  But that's a solvable
> problem, the tricky part is protecting the PAMT cache for PUNCH_HOLE, but that
> too is solvable, e.g. by adding a per-VM mutex that's taken by kvm_gmem_punch_hole()
I don't get why only PUNCH_HOLE case needs to be protected.
It's not guaranteed that KVM_SET_MEMORY_ATTRIBUTES2 ioctls are in vCPU contexts.

BTW: the split_external_spte() hook is invoked under mmu_lock, so I used a
spinlock kvm_tdx->prealloc_split_cache_lock to protect cache enqueuing
and dequeuing.

> to handle the PUNCH_HOLE case, and then using the per-vCPU cache when splitting
> for a mismatched accept.
Yes, I planned to use per-vCPU cache in the future. e.g., when splitting under
shared mmu_lock to honor guest accept level.


