Return-Path: <kvm+bounces-49570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B48ADA6BB
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 05:16:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D90DB16DE7F
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 03:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 730492882D6;
	Mon, 16 Jun 2025 03:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AN90mCOe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FC923AD;
	Mon, 16 Jun 2025 03:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750043806; cv=fail; b=aXML+cmIMrMsa+fmkRsLpkXBAFaT+VWKttiaANQdOBu4pEpyJ33aDf7t3CMcOHMitNFFHHnUe2ZwDjq8HFp2wl505BDOdWn7Sv3nNClgeWC1fvJNqK6PI9CHPHHywMH1zrXOp8m8vB6GzDuqjto457Ri69u9a6LkzSL0sTumZfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750043806; c=relaxed/simple;
	bh=+XQrEzryWP2S542gjy6aGC4SoIJyDhQOJCmGn+T2bhs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cpJfbPIhjVAZ8taK0PMvpSYVff6oxyv2tAswoEN5H0u5MRl4AXVrTkelo1PTnTjP7qFTkX95bJ5+TmMnhP2R2ElR/5WytLkhLNW3T1X1EHs/VgNmt+DhVof+vG2Xfbe+l39kf4hTV8Colj15LBEK1F9XcEi43u8ZNpALb9LpN18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AN90mCOe; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750043805; x=1781579805;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=+XQrEzryWP2S542gjy6aGC4SoIJyDhQOJCmGn+T2bhs=;
  b=AN90mCOe0DS7sJZySA44tpy7s4itR1MdoY5E+Pl7Nd8I33+LYHviPQoa
   ej1UMRp+uT66P4iwk6o41y5GtWEmI1e01J3iljLKYv6sOXHytAUKvYh44
   saXjNZWp9u4GqyoIJta3nVJzqkU6/XSoUimDjwBSHbdT39+4aSRMeAwUa
   H/C3sAYnjIkLyXyNBDnF6nPI/WuxKtzqj2BSaICC7i1lhhvl+Q6WtnSps
   DwOHuA+nAywj4Ni41JccVZlspeyEv82CeZYTBLXEnYMhPt9Dfgct0vrH2
   sybbycb27aBYz/GfqHnYrFnX94OMKEq45IY3ZY7Ctzq63vpyA679yvZet
   g==;
X-CSE-ConnectionGUID: DpITq+DAQ9qtgcS+AjzRWg==
X-CSE-MsgGUID: T2/iuqoYTLyjjmnV+2pu9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="63208687"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="63208687"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:16:44 -0700
X-CSE-ConnectionGUID: rYdrsZ27TjSSE4JEkX4UTg==
X-CSE-MsgGUID: tx5GFFh4SEaeZkV7I0mbGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="148808229"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:16:44 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 15 Jun 2025 20:16:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 15 Jun 2025 20:16:42 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.57)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 15 Jun 2025 20:16:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fd7P7zWECUKKc01kp3f/2MB4nONQVOVkPe1edaeC3XmhI33NmCoiBDjdvfKKRiULpryGuZ5AOl4+B0mR5mf/lg5P68t1nV5U0HUAp4sXagD6DZIQb55QuKCkbGBHXQ/9lCKqWl3xn7cVLlK8MIShKqMua4She1PQuom0abcP2tTd5NnJTIwrLUcOh0Ry8Ix64hlyWIUhTystMUr3lw1YjCclJHmkY6ZeuUIZ/fTDz9vb9BWFAMk4z2rEcigP2Vrm+I3L0++LBbzM5tfr4lZ6MauaLwZ3swkdHYHYHjHmuXBfAf93bnDBkszl4bQxOZX/Mmm8u7c2WBu3kYyVRx05dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/4mBLK1WnTbYpvEOFdYLCv4MFQUJ4+5F28OymUSiirQ=;
 b=Rf3Ixl+i7h7ilvvAv3YgUZIBA9qAOsHOazb1RSaEjT0uC6M4M2EsDFAeT2aZAiSnqS+Dlj2ERyAVLkjGmZx/hE48wN6V91RibZmg94gd/oMSz5h0X//RH8fLv/X6DGPvY/ZFkPMC9sL/ncx+nUje1+VpMA97fUDtol0fQ5TUpY9+rXQ4yfIa0UsbKGOJ+zksa/bYOy2A9TyX+oE5olbSsYNK6+tAytpS6+VFywaV1Mp2k3UK/2lkvFZRydjQ2kaBq7aT4D3qfftxh/pQyb0G6D2mHM8FVlRlTs6cNG5vcoTqmXD+6xrQJQx/iq7SzCqy9O7ExJQ1CLjeMuc0wxaFnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB4831.namprd11.prod.outlook.com (2603:10b6:a03:2d2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 16 Jun
 2025 03:16:37 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.018; Mon, 16 Jun 2025
 03:16:37 +0000
Date: Mon, 16 Jun 2025 11:14:07 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Du, Fan" <fan.du@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "tabba@google.com" <tabba@google.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aEmVa0YjUIRKvyNy@google.com>
 <f001881a152772b623ff9d3bb6ca5b2f72034db9.camel@intel.com>
 <aEtumIYPJSV49_jL@google.com>
 <d9bf81fc03cb0d92fc0956c6a49ff695d6b2d1ad.camel@intel.com>
 <aEt0ZxzvXngfplmN@google.com>
 <4737093ef45856b7c1c36398ee3d417d2a636c0c.camel@intel.com>
 <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com>
 <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
 <aEyj_5WoC-01SPsV@google.com>
 <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
X-ClientProxiedBy: SI2P153CA0002.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB4831:EE_
X-MS-Office365-Filtering-Correlation-Id: df4ea0f3-8498-46ea-f11d-08ddac84342d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?ASehO6zPIo6nxnvUJLYAzdcqYjkUWEAugRcHzjzW8zXOGRpkHsYZTXy8sB?=
 =?iso-8859-1?Q?p5dY6s+/M0yBv+rBZVK9M8aVRjU0Twv86EcCR3+WemkS1TZA8d3NAJolN4?=
 =?iso-8859-1?Q?vrFYEAUVzMdgXrQGx1+Ma1CYhtuJVccf+jAh9P21pFmCVUfrppyDrRRy90?=
 =?iso-8859-1?Q?M+d82avVdG1gAzz5mZKRVwKnwqg+dOvVGEmvftQPLPqrfkIkUMQ3F0ivXL?=
 =?iso-8859-1?Q?fOnr6wJldQlujUx9lMrOS5hg56+U2BD9iDAOC3Nng+iKc3tVlsgjSwAbu6?=
 =?iso-8859-1?Q?ygQLWei9at6bK/Ww3BWEudRbxNBoYv85aRyq48z1R3WbI9reuVa79GJpGX?=
 =?iso-8859-1?Q?ziyqMSEc1FP0zfxfoTU6Mm9XuldTmfddLJ1pQ7ueaXdfnDTRKi72SffRh1?=
 =?iso-8859-1?Q?medo+QjkiUnNQyGBmHzKyypiL9ZbiL6nqdSKEN+UGu6DPAXToZ37W/GznJ?=
 =?iso-8859-1?Q?EHIQvIjJTsv5xxMvSnOipCo8SpNI5qXNVtU0LA5LznO91EiRvswJtHxWN6?=
 =?iso-8859-1?Q?3IcVxgV13oB6Wpu0ebQ36+FbQv0NEjcfyfB4SLuyvJBmVMWG5Izhorvu6g?=
 =?iso-8859-1?Q?K7qXeQCL7SMn6UJPGgAffx32FpVr5miHisyIziC2W642/uJxjc+lQu4A5e?=
 =?iso-8859-1?Q?5pWHPvD1JarhWUOrBYuou96h5YexSmOeihK/roJjvRHkl3dJxJwgXQVZDr?=
 =?iso-8859-1?Q?Fe80n3CxZsC+FzIlFqcPumvY/B/2Yl8GgYyWlStdz5oDdSo7WlCGccrfPu?=
 =?iso-8859-1?Q?L7P3FhbOniHBOIN3z7/P02G6OCT8zA929L5q6jbDOeUXauznxMx/jvIsM1?=
 =?iso-8859-1?Q?ZGCcz088eWgbzZe7ZxxFcLpdQMbZ2ap0NVECaZtAwCzSsUvz4CWl/sLRp7?=
 =?iso-8859-1?Q?DccV5NAZZZUWOy5pU7Q6gHhNvW5qX4GDu1OTVfptxA35U3oA19opwezUDd?=
 =?iso-8859-1?Q?u8t+VwL19o4NXyBpH5aNnz8oxqxQa2jbYTcRtpvc5I+CJfWks0jlEYMByD?=
 =?iso-8859-1?Q?Ng0qojyI4t4tm0dtOjPbjRUjMJCMdqCwwFqnz6z1q3b7tVQrywsZ0CY1pu?=
 =?iso-8859-1?Q?J/TTyPQqKqhj+UXljajsLZNYxZyXWjnV5fTgZKX4Yyx1pLPkzWdY5DU/wJ?=
 =?iso-8859-1?Q?imxRQn7lYI9pPT1Gx5f27gtgXjvmxECRFhzpfukvHELJDnrUh7CEBm30Xo?=
 =?iso-8859-1?Q?M/wh59xbyQjagQY0eqM/r3/4lOVVDTMTCCXu8LBDXJY/dDEfSf8Y94/klz?=
 =?iso-8859-1?Q?3xbOHnAkX2UPUoXS1mVxbsP/gjuly9potG61MWCsHhoIYlZeifo9gvqD38?=
 =?iso-8859-1?Q?7mjc9gZshSWY7t3/Edsp5Emg4S+aRlD50hj94Fw/vO306yo4HYFUufQNM0?=
 =?iso-8859-1?Q?OO4ftA1wk4nZCOioyd3d3eRQRtypP3b9lrjd5s3QQS2XjktssWoITjysy2?=
 =?iso-8859-1?Q?z97IYhs7ii3YmVSehWqyXFPHrwuLa19PfAsHwR50MxsJpSvTgs3Uisr2xL?=
 =?iso-8859-1?Q?A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?IJD9dJucBj7EvZQPBvuVPv9KH0ArHd4aE/5kv6594Ny8PqrYf+tiWdM9QQ?=
 =?iso-8859-1?Q?DbY19HGmLB5oPte+WCAgYAGxM98b1C2Jp6Uc6JcosEo1SButvC5t1CXLlG?=
 =?iso-8859-1?Q?HctpLLCutBV4VgtPDHiVTm9MpIkoZ4uKERB36cuk6eabHGNAU8846pCv44?=
 =?iso-8859-1?Q?HBPNfdwvtgRMIVyzDvLX1rT6R65GZjA9RJNLr8D4V/1at4fTGeO9g5jhb7?=
 =?iso-8859-1?Q?CCm0Ywsw2quXhlHKVxFkGNPCKEzjId9YwGpRwpB9ypcFZWLyA0vl+pV9YY?=
 =?iso-8859-1?Q?5jqhVWGU3xv2qtop/M7qOqZTkUZBGl3141csi8V14ZakP8cz97CsW4073y?=
 =?iso-8859-1?Q?zWeTJBpd277r+9VFFiGk4ebpz14/xjd3lCOuMmgoNujYe01/J+pnsfWVSj?=
 =?iso-8859-1?Q?ZTB2pcb6488P5T/J8QwckQV5hh+titKZbaC4JLieES7dVD4QoOjoMC+MOI?=
 =?iso-8859-1?Q?VE7YV6HlcjYQCNHj8aAq8rJmz4637Gaqu2fLjjvri+ZyU/e7jnmg/6jo6L?=
 =?iso-8859-1?Q?mmbpMuT6+5Xl8CgrDS5LqM5JpfN7mOIkic0lU+/wx/oiU+2iY5ivqBZ6bA?=
 =?iso-8859-1?Q?dldgzHLcEiR924J2wfmP01TuB/VKu974+coKGmuV0Zisu6PXqwK0xfF7uG?=
 =?iso-8859-1?Q?MNuMCmBbuQ5iN5bFwF98hwMJ5LRnuv3hYbxIoYTj9G8dSbN1r03qtGzOKO?=
 =?iso-8859-1?Q?itkdxqxkgZVxcBLwMmwWld57IqGjW/DxiBUdXykNRt8VzQQKqD+cO9BtPi?=
 =?iso-8859-1?Q?J0YmSqgumA7Z9rtBvl6XT7I7bG0eSGmx/1foSzc+4drvVc1ccebRdJbo3q?=
 =?iso-8859-1?Q?CUH+CxzxyTUZu7np/twZYcPdEkoIa4UIh7AigX8rQVOElHeHJKEi7g2Mrr?=
 =?iso-8859-1?Q?XVATTAGGLer9PP/jffU82tnmgzLMga7GimwlEKejdLdjOvpOOEA7A9I1wU?=
 =?iso-8859-1?Q?YfwuKIQy1thHjBYp8PU0daOG1GbpP3riFu/oFwE/EoapkHkV7Db2lOqcE5?=
 =?iso-8859-1?Q?Mbc5UyBHpz9tQ9r9WLyubBkPA6+iziiqpNuj3gIwZKCqfAS8jl65scregc?=
 =?iso-8859-1?Q?RSXa5dzVtFt+cyqZEqL83pGyZSnIVqFue+r3G0f4gbkiL74K7tbxWz53F3?=
 =?iso-8859-1?Q?E36YbxQBgG7H5Pe7ljkejwnezq6qlQNI0wD5wgll3+g/HMc9dUzIfTHWta?=
 =?iso-8859-1?Q?ftJWb5GUe/6TLZ8T/y9SXOipIJGxJhQqFkLvLRw66JUz2moBfFbKrCWh1o?=
 =?iso-8859-1?Q?k6Qt78n4z58QZNo6cAkTGViRASzhQG7O7rpklufHWO+RDZsVREFP9n0wA9?=
 =?iso-8859-1?Q?PyxWGLcb7OzK7QIwyawPqzyLZV386ky8hcmmMSLoc1QiBkpz499aZeQZ86?=
 =?iso-8859-1?Q?0imCr8j4j+fkl5e4h9iHfeRCFoBwMOBGU/+4mEyFeEQVFvGDema28bC5lQ?=
 =?iso-8859-1?Q?g/JSde3Mvwc6wD9lMmBQROUnAEcqyCZwJdWkAMAocfNBjtMtrQhtWVTR+K?=
 =?iso-8859-1?Q?p6GlVKN8xTIWm7lW6gcM/lSXZVQLTvZI7RVjFD3AF7dn+ml59EqOoynW59?=
 =?iso-8859-1?Q?uJ6MU1Y7nOJB23z5kn9nxq41pv28JI2W9nQQ9SCvaprEnFtSlqfVkPNArh?=
 =?iso-8859-1?Q?m38jcVMPNu/rA9aRLMNYTsAnZNROnz2c3j?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df4ea0f3-8498-46ea-f11d-08ddac84342d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 03:16:36.9423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEzuVy26yAQqRYafbOMyn4DMMuWDsCak4I/0qLcsVndEoJcfu0KtV480pu9GxuN98EgGq+7merGA2MnKk09tXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4831
X-OriginatorOrg: intel.com

On Sat, Jun 14, 2025 at 07:33:48AM +0800, Edgecombe, Rick P wrote:
> On Fri, 2025-06-13 at 15:19 -0700, Sean Christopherson wrote:
> > > Arg, I just realized a one-way opt-in will have a theoretical gap. If the
> > > guest
> > > kexec's, the new kernel will need to match the opt-in.
> > 
> > All the more reason to make this a property of the VM that is passed via
> > "struct td_params".  I.e. put the onus on the owner of the VM to ensure their
> > kernel(s) have been updated accordingly.
> 
> Hmm, it gives me pause. At minimum it should have an enumeration to the guest.
> 
> > 
> > I understand that this could be painful, but honestly _all_ of TDX and SNP is
> > painful for the guest.  E.g. I don't think it's any worse than the security
> > issues with TDX (and SNP) guests using kvmclock (which I'd love some reviews
> > on,
> > btw).
> > 
> > https://lore.kernel.org/all/20250227021855.3257188-35-seanjc@google.com
> 
> Oh, nice. I hadn't seen this. Agree that a comprehensive guest setup is quite
> manual. But here we are playing with guest ABI. In practice, yes it's similar to
> passing yet another arg to get a good TD.
Could we introduce a TD attr TDX_ATTR_SEPT_EXPLICIT_DEMOTION?

It can be something similar to TDX_ATTR_SEPT_VE_DISABLE except that we don't
provide a dynamical way as the TDCS_CONFIG_FLEXIBLE_PENDING_VE to allow guest to
turn on/off SEPT_VE_DISABLE.
(See the disable_sept_ve() in ./arch/x86/coco/tdx/tdx.c).

So, if userspace configures a TD with TDX_ATTR_SEPT_EXPLICIT_DEMOTION, KVM first
checks if SEPT_EXPLICIT_DEMOTION is supported.
The guest can also check if it would like to support SEPT_EXPLICIT_DEMOTION to
determine to continue or shut down. (If it does not check SEPT_EXPLICIT_DEMOTION,
e.g., if we don't want to update EDK2, the guest must accept memory before
memory accessing).

- if TD is configured with SEPT_EXPLICIT_DEMOTION, KVM allows to map at 2MB when
  there's no level info in an EPT violation. The guest must accept memory before
  accessing memory or if it wants to accept only a partial of host's mapping, it
  needs to explicitly invoke a TDVMCALL to request KVM to perform page demotion.

- if TD is configured without SEPT_EXPLICIT_DEMOTION, KVM always maps at 4KB
  when there's no level info in an EPT violation.

- No matter SEPT_EXPLICIT_DEMOTION is configured or not, if there's a level info
  in an EPT violation, while KVM honors the level info as the max_level info,
  KVM ignores the demotion request in the fault path.

> We can start with a prototype the host side arg and see how it turns out. I
> realized we need to verify edk2 as well.
Current EDK2 should always accept pages before actual memory access.
So, I think it should be fine.

