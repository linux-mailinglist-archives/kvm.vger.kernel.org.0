Return-Path: <kvm+bounces-37814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF56A303FA
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 07:56:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79A8E3A7062
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 06:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71661E9B31;
	Tue, 11 Feb 2025 06:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EkIXDlXb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0461D63E1;
	Tue, 11 Feb 2025 06:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739256978; cv=fail; b=u81wkK9pHcVsw7mDFHU5dJUth55GvJ1H9FrHvS6GTBig0ylASBoXlwtPTg6R00Xvs/l6Ew7a0hk5EsIqzWfd2BSSRNlG/1dh23VrzlKFtFS+3v5SRXC5PBVPZodcN0HXsymvhT1DgjWcEoUunlcJgHej9sDXl5e3ElKK7tpldgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739256978; c=relaxed/simple;
	bh=h/skftrwZEt1N1+XJcg+LTDekNvvSad9zDFmseOWWYA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=q7GVuCPEfP9kKvb6yRn9vKupNwbgzKKVDYTj3Ks9LQuIZ2V/ZZX5x9yNCaUklw4VfJOOb3oWP6Jo1UQpofajI6epI9dGBWBlP5KLWpdEoGRXs0KBXsn9OB0Ao+4kDscjEmjKLNNEBjGYIw7tbCoLucgeMpgztyr+SM3UubmdfKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EkIXDlXb; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739256978; x=1770792978;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=h/skftrwZEt1N1+XJcg+LTDekNvvSad9zDFmseOWWYA=;
  b=EkIXDlXb06wZBukme1WgjMRSrYy5J/GMZJrEVK08L0xGCv5MGK8W3mwX
   p6wXWMx44le6Xv9s/SB7DDtAPMwxPEgsgUh2duoKT56s78ieItG2a/dwc
   bTH+IYFcNVuKwJmd165HGYFfdBhFrX3EkHDMqnV/SYgxow2Y2OiCEgZuf
   RxmIreJrshoP5QY0efb7c1pfVJljmQYLLiFpRbc4ZxxNN4xE/tGVIWLmS
   kocTBZVlBqN7ENCCO/bpglb2Di+yzXHNup37HjbqunrG5Qu/a6ZH64nLw
   rt1/IPb498/h6CjmAD3rRkbmCZO/pkxNqkishsJ4t+ldA9cEsDhdfvuto
   Q==;
X-CSE-ConnectionGUID: wm8f42KeQKOvegwKmlxAmQ==
X-CSE-MsgGUID: Mt+XIElkQ5iF6n0SOXQBqA==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="39982100"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="39982100"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 22:56:14 -0800
X-CSE-ConnectionGUID: Yv7eJpKaTDuX031rnN5zBw==
X-CSE-MsgGUID: LVUodVqRSoKkwPtYcNBi7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112365391"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Feb 2025 22:56:14 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 10 Feb 2025 22:56:13 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 10 Feb 2025 22:56:13 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 10 Feb 2025 22:56:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PkxN3JLS3dJQtmPUwqTFKsYb0y6QxJ73nbK694lW4Y/nUNxEoA1qDR2muq6JVZLxACxgeJs1Q1x2x6AU6UA+lz8jcYqG4pCA5wFq1K//hY7GzkPN9pobuERHozYsng5EPM6iQQ9NeuzXJ7zW0hd2v5zKxOyLPvqCBWcIA9THJHO6pzkryixrQHpYl0qP0P6BUbLADXEYQ4V6eCIf8MKVllnvYZsX9Wf7+YXCbm80jkbHC1QQucmav0kGSnSai44ztYzDDpABP9GuIli2KnyX4+hTzfV4EwqZG0w7ev9Nquw5rNwdMPBMg+GnR9Jud2j1kiNPL+nRcWpbzlu40yf9JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zEb6COflbph2dLhXvL0EO23LTo92l5ltJN2XEuGBZhU=;
 b=w0UaFPmtdDcEDXY+sXqc/xZ21uZJcOyYtaGyXrOnYJkquJBJemXAu0G7v0F1ciRcAtIYQDTUvwJPi996q7Eh86YS+9DlX0moxz+qHcqVO+ldG3D16KGiVskY47zWNAHpTR67QM0k6Upah/uk2Fin9euOLe0FB1Juqmhg6ruFC33r27PpU2mEPtT6yWeH4vnBV10JRMzGp5zqGouULeoQnvPz9sm5gzDBM71mUr9rSrwghlPaSYtRfKFVae9V4FaMBx6FU7SxIigiBe42uWzWDkFIcxM5ypU2TbuhxRjkwwc+1sn6ycb2G5QpUarPMJKYBzsP+jIglwIR9tSa/b/bhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8422.17; Tue, 11 Feb 2025 06:56:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 06:56:10 +0000
Date: Tue, 11 Feb 2025 14:54:59 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<isaku.yamahata@intel.com>, <chao.gao@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/8] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
Message-ID: <Z6r0Q/zzjrDaHfXi@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-6-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250211025442.3071607-6-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR02CA0079.apcprd02.prod.outlook.com
 (2603:1096:4:90::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB6763:EE_
X-MS-Office365-Filtering-Correlation-Id: ea6bf574-e939-4ceb-e56a-08dd4a692a74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?pT50DYDCdBteoNqjsWMId+zUftGcO7oOhcPOI6w36+NH37ZdBHCs9eDT6JDI?=
 =?us-ascii?Q?LrA9EwU3+Sy0HVnEZuqptfQQVaPkiacL95v0+SARxwrfoCpCdu/yBYejycux?=
 =?us-ascii?Q?LrC3eXijgosIvOEa2J6oSmjuWHCxFG05ZmsrWPQyYL6SLZb7gmBLb2evfGBr?=
 =?us-ascii?Q?eoEkIQZnT6QxrqBpj4AavtmQ8xr+wQwb/eKO62RQyOm3AJCHD2tlAvtlYKpt?=
 =?us-ascii?Q?aVZsGKShP4RqxPzZPApFU08AkdqXO1wUrHjVNlNgBYKyD1neRCGseklyxfVU?=
 =?us-ascii?Q?gc63HrAJu2+t4dlV8RKfZQ9NvP0BGpMxFII/CmgJNgOUz16BzKEKXHy1zMh2?=
 =?us-ascii?Q?16IURl5i3efZfF8UUVvzxBzBhL1VbP4zim5M3dZPgn44gp+ARNh//JtL+r08?=
 =?us-ascii?Q?H4HdE/SwRW+ylr7IrEqGuIMLrnaDIqGILghHFW5HZmkG3KY2GF1+yf4vu0tE?=
 =?us-ascii?Q?h/PU5dBaslTPHwtzf9n0qoKQt04wdGVSVwH9wDu/qE5EvOawlOYGj3oeLTtM?=
 =?us-ascii?Q?gq5iWre0z8FCP95Jam/ePW4NEZ6Typ+vI/Q0X/QXOJ9uxTq8U93VBDmrtVoB?=
 =?us-ascii?Q?uvW/XDRTbyDD1XjHZ0c3CG61vr4YCHHKKlJsWdsAq29RA0qRAi6FmvDQ5cOy?=
 =?us-ascii?Q?uGkOWv4ROr++5jmXYymkojWJ4jMiqUV6Yu14GIzuAnEiGCl8S9P+oON3PEuU?=
 =?us-ascii?Q?ok1BlYzL3DsukH7Ncl09SFUXGDP66mLHJcU1nJtIyLqP+2aMnIt2HaLsVX8x?=
 =?us-ascii?Q?KYmgc2oxNajYvF+7I9hP7FEBYRj892q4otjsW2yPD8siCutyGFeRHP0eLviP?=
 =?us-ascii?Q?pJsS575Z1A9x3A1Dy2w4ss93lK9ARIoxlwuRLLpsLMcjKb8bz9WCngJHJD4C?=
 =?us-ascii?Q?+eHBYtPL9loDDnt5ja8JgHu1B0vc/qb1CLPh2cYpZAeZ5Qv6iNsAb+Zq+wSR?=
 =?us-ascii?Q?sT+X8gokQLCSuc5RCYjJn7dng20wla9jfO79NszEegL6Uqkak0j5O5OHzVkl?=
 =?us-ascii?Q?+E3+Lu9syxuevNCNJhfPNSDdJN/7f3K/AhnOVJ7LanYYi+0BTlvkP9ulTlAH?=
 =?us-ascii?Q?bKHo/e7gd1mfBLPsmhLVMIt492sdzVkAsn6iscivgclqcMEd9JdK7LLuX1nk?=
 =?us-ascii?Q?gY66srxcoIMgFWnFEPiG3joiw1zC5zcQk4zrNdxWnnGzL0D+wC88Wet0WT58?=
 =?us-ascii?Q?uXefhresbz8MIAhNxyM7PHTBNPbOFi4TKbeqjoSLeg2Qt1Q6EK8/vca07UMq?=
 =?us-ascii?Q?PdLNYfpHbZ5DTbYi/Lj6p4rhws7e3gdDssBrfmRT1sEewfFBGS+LCwm0OtAy?=
 =?us-ascii?Q?2S4zbSNqi8M4IZdzvULtrNAN8zXyGT691Q+yxC5xQwxo1eJM7ONjdfsS7QLh?=
 =?us-ascii?Q?IVxUecshUy23xfUJ+1/MGuHjHpOK?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GKSCSuoFTeWLPQgq6HT+ELiWQCxGd26XfqZ6+DV71v5YkMtOV7umEb5Dj2ob?=
 =?us-ascii?Q?Dun2TQLA8WWiluqUWusWSOEJaKdFFVikPSS8F8ABTP9JaU0qqwLX31sBe/PA?=
 =?us-ascii?Q?jSzd6EvjRohZAej0Nu/JS4PuCU0ahlMNDZsuMknklttoPq2mGtYqoC4wJpHs?=
 =?us-ascii?Q?sEM6y3/ejqYWRctMRMpoW4q0d7lckDvtvwfX9Irrx9kc8miBnJyDRJQ7MdCR?=
 =?us-ascii?Q?Gmo8JbcrEra5YT2SYiAZ06T8N5IeR6NdjqXB9FWLNAe14bhQ4KezRkOT350G?=
 =?us-ascii?Q?ULqnGmkJlBBhVdBSMLoZIoBhpUpJi6+FTxhk8pU9/4dRi2JsemPROZFO1eYu?=
 =?us-ascii?Q?OwvKrfOowcSXiadfksPWzB4iaAoyVen3Mp1w2zt64DLlLny1vVLMmNkJYeRs?=
 =?us-ascii?Q?HGsMXwaQ1sqc/+3AN6tEqkmGi02yRsV2/BJcd0t//AhqdAdnyPb1l5H4SDEK?=
 =?us-ascii?Q?gxqLgZ4LKmZodQPwjZW7Mgv455hM7vzX1z4kb6/zJDljnJp2jZhnBLg8G4IC?=
 =?us-ascii?Q?JE7RvtW8NlI1tHDmSp58UsMUIjeXT1c/Sp0DleDLUlp38ywinVV36RPjXBd7?=
 =?us-ascii?Q?NMHwwKa5pjgkzhH4W8yes20x3B3fWFPCF9haRRQp2sSGeEWs/pqYHSEA6TyN?=
 =?us-ascii?Q?AmiHeBPnz27dYTi9Tw1+6RMSOn9Oabz2jJDCwlWbelDJFLaZk67AT2qOHS9s?=
 =?us-ascii?Q?K7Bd6D4f9PkhYxCwsVQE5eOo3yI8pShgljrg3atYvB1bslq2P2TCHPAbZwsg?=
 =?us-ascii?Q?j2UC/+LAWQhg0/DMs9qOb77k5FVd8xmXcOskiX2wBxV1dvts0I6s+2mRBKjm?=
 =?us-ascii?Q?NwY+kNDuuYYbkklhP5PVKwUM4XOrLBro1bmOI8bnoAJjPftVuaggmfjruL2Y?=
 =?us-ascii?Q?c7oGpq4YNmJnRf1eyWjK7bXKjwqxT9UT5nKyHg0pcq6wvoEATyHekrFZOXfZ?=
 =?us-ascii?Q?dm1fPh353MgHD0XMMVGPc/lN510fviJrtlh88kFirFM3kfoQa4/cQ5pdRmrW?=
 =?us-ascii?Q?q/auhhKmTClnLaYVmg8RhFCHarwtYvoedS7RRYRWXYeg3DH7KZKjRhYzTZKd?=
 =?us-ascii?Q?IvOnZD71xX1VPg6nCx3RyqX4EcXBDLFvPubaSBgOmK2CSf+4iX27xNP2waKe?=
 =?us-ascii?Q?izI4XaOyXUH4/VE4uNoRBM0zMvJknAqaOH1Q4+SYC3tzL91v/vhZ7qhgfugB?=
 =?us-ascii?Q?T2kP/I1iXiIA26cWNjb1IyJ9HpsJXslb60ShPDCLp93kKq5+sVwfi1PACjGB?=
 =?us-ascii?Q?LKB+Caq08N0K86OPxfnQdirwVn7aPPlqpFC8gDvBgI1E90zY1L0qrLYSH2VV?=
 =?us-ascii?Q?7nfzLMzNffhN0NjhII6+s/f40P++CkjibCXI0gO2oz+Vzm/4jmYk/6XzkcTG?=
 =?us-ascii?Q?gSuyUZMpgSsENYLzf6SHsCnpfodx0rnBqPbyF1z+fG5HJjTwBIopbXusTNQ1?=
 =?us-ascii?Q?+DfjKg+NHiLvvV75asbyI4pci12f+UUuqM6aQS0XwDzB9i9EeJ1PVswzB1d7?=
 =?us-ascii?Q?7KVae3HPcNdNDn3aiqtifha/KJyA8f9Vn7ofmyVCGXyNPPre21/HMsPgjfLi?=
 =?us-ascii?Q?JsiWRmp66r7M3szsv+heya0NSFTJOnWeAvqoV1OF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea6bf574-e939-4ceb-e56a-08dd4a692a74
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 06:56:10.2144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uDzMMrCGMG7tFiJ8oh43Rgq/ndteCkS6mR4Wv9mrcK9IPK1D6r7dnN1mJLM/gNWu/O8jeUCvEt7JVRrIdB0gjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6763
X-OriginatorOrg: intel.com

On Tue, Feb 11, 2025 at 10:54:39AM +0800, Binbin Wu wrote:
> +static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	if (vcpu->run->hypercall.ret) {
> +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> +		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
> +		return 1;
> +	}
> +
> +	tdx->map_gpa_next += TDX_MAP_GPA_MAX_LEN;
> +	if (tdx->map_gpa_next >= tdx->map_gpa_end)
> +		return 1;
> +
> +	/*
> +	 * Stop processing the remaining part if there is pending interrupt.
> +	 * Skip checking pending virtual interrupt (reflected by
> +	 * TDX_VCPU_STATE_DETAILS_INTR_PENDING bit) to save a seamcall because
> +	 * if guest disabled interrupt, it's OK not returning back to guest
> +	 * due to non-NMI interrupt. Also it's rare to TDVMCALL_MAP_GPA
> +	 * immediately after STI or MOV/POP SS.
> +	 */
> +	if (pi_has_pending_interrupt(vcpu) ||
> +	    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending) {
Should here also use "kvm_vcpu_has_events()" to replace
"pi_has_pending_interrupt(vcpu) ||
 kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending" as Sean
suggested at [1]?

[1] https://lore.kernel.org/all/Z4rIGv4E7Jdmhl8P@google.com

> +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
> +		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
> +		return 1;
> +	}
> +
> +	__tdx_map_gpa(tdx);
> +	return 0;
> +}
 

