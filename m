Return-Path: <kvm+bounces-68150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CFA8D2241E
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 04:12:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 251B2304C0E2
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 03:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA5728A72F;
	Thu, 15 Jan 2026 03:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CrjtZLY9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C07020DD72;
	Thu, 15 Jan 2026 03:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768446684; cv=fail; b=gztFWQmSWWmW6fCmxPCOO6ypD3wFLvRRljcgz1Iq3BYQxnQM+0FfYT96vvbjRkDK1laNYLX07OwDUeeQho27gG1vfxNaZu4iCG1SEQovguTTaT31nN3Vj/G7b2/xiGuhNaaV3UfmNiIv2857Lce16+7uwMTvuYE1PdAnx3ONNTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768446684; c=relaxed/simple;
	bh=E5fOZE6YzXZXzohwvTPRr6+cAFmdLqByh3+2znGw4ZY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=b8v1mC2WXIreiEzXxQSClw501mSHOoEoXEHTOGxfJguhSdY4oGMvTCJ7jadpFkgAgX5cKVCFTAL7uw/xYqu5rA+Ht3g8Hg3kxowPFphxa6syzx327yPRWL51UpOgFKw3YTB+0wbxHbhs8XB+W89DUnK9OGpEA41SZnttv3NF6xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CrjtZLY9; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768446682; x=1799982682;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=E5fOZE6YzXZXzohwvTPRr6+cAFmdLqByh3+2znGw4ZY=;
  b=CrjtZLY9d6ehH1VDmC/m7VWh0IuyuwTF/e/PFmrrKoJ5Fd4oFknKvcdD
   WbML8bCU3lFC8gf0L2wWZrVKf1XvyOhhM+0EMGJ7+BVZgKv71tu2pjCw9
   H4PjfUo/toJxXkjyfy5SdAZn1/FUa1w0bEKs7almJxXr26IKJn7Cs0dPA
   rZaC7zCx0jKm2X6g03juUrghvbgiN1tcADEl8DBI3/Cu2jus+J2BUAs5u
   XJqYtqouj0QJD7+ojxCqQaMvnwFgvGx7QApcxtSs7Hm855c9bn4IK4KXG
   DcLIoJFQRLGBpFfGDedO8cZ1HZ4EG2TshFyTRKu9+V9teWA01QjdMx1yg
   g==;
X-CSE-ConnectionGUID: z9x77VPLRGO/6NLM5IXDmg==
X-CSE-MsgGUID: qybmYtfMRO2u8q1p2n9sEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="80864072"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="80864072"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 19:11:21 -0800
X-CSE-ConnectionGUID: hhXh1mPTShOIWCrDQsfdEA==
X-CSE-MsgGUID: jIfOZ6yBRQaUk0MB/dTUUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="209895448"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 19:11:21 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 19:11:19 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 19:11:19 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.71) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 19:11:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VqU92jfSnih/6P8YF+mLT1t1f/8Tr81Rwd6Fw3xHV6tPcK0G6HROyoZVNyeuiI0Uu4ju+VS83fcAZ7zV6SP32N/75UMUZoxjb0gOLYOVbfTsYwwso0hS8qvwKr+ghuJmtRnk9BYY9aniXbD4jlAXi5BdBG3xmuIS4OkuvyQ/cFABBY6lTMsa2vtDXfvKOEpEjNdFnN0c1HW7IvEuvXSISBCC0qQjFRh20QsGTzP0ppJyp2iMF6EPgQ/YUMJ7fA83E6vY4jSvTZ0TfzLkioUTKyZCDQiyl62Pu/D7WTNj8faSNY4E9Ce7sK2oavtMWdehuczcAHUyonlJzm4ThbE1Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=reeKzdaZ7Q233SQkn2MmwttJAP/mxQ5nn+znFQB8iq8=;
 b=bnqsk+L698Bvl6QpxuGze2rQduIJszowKLhQgbDrzItVcBL/kU3Dpb+2sbm39Uuv6avLBtWzjUcEOCQTJnbQQhZ86UNJyx65fVZk+GyRjWKnUQy3MxBvL0G+6ER5i9AewUktLWQxa9jYn+zbMUS/hgBEo5AvKhoG6eziqhcvLGPxcnsPNWuCiZbYiGuaha/CZVjsR9zvlzNiqVQ3gwE8SE7hLLmBjsitLw7UGPT8K3r4ski2Z5Lge8HpPCUP0yldWl0yoTD/0oMbUcHxUu68p+c+otCq4I7kAEVrOILbbuxyqjO6vq3fxB+Qu71cJ87Kq1dPlleWwcGf0QeMhtqYaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BY1PR11MB8054.namprd11.prod.outlook.com (2603:10b6:a03:52f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Thu, 15 Jan
 2026 03:11:12 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 03:11:11 +0000
Date: Thu, 15 Jan 2026 11:08:27 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: Sean Christopherson <seanjc@google.com>, Vishal Annapurve
	<vannapurve@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <michael.roth@amd.com>, <david@kernel.org>,
	<sagis@google.com>, <vbabka@suse.cz>, <thomas.lendacky@amd.com>,
	<nik.borisov@suse.com>, <pgonda@google.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <francescolavra.fl@gmail.com>, <jgross@suse.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<kai.huang@intel.com>, <binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>,
	<chao.gao@intel.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Message-ID: <aWhaK+ikw8QkH4hU@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com>
 <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com>
 <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com>
 <aWbwVG8aZupbHBh4@google.com>
 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com>
 <aWe1tKpFw-As6VKg@google.com>
 <CAEvNRgG40xtobd=ocReuFydJ-4iFwAQrdTPcjsVQPugMaaLi_A@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEvNRgG40xtobd=ocReuFydJ-4iFwAQrdTPcjsVQPugMaaLi_A@mail.gmail.com>
X-ClientProxiedBy: KU2P306CA0065.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:39::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BY1PR11MB8054:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f266f76-5bec-4240-1eec-08de53e3bc41
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?UxidyICKx4ed8TpZRVftCPmJsH96TZYAxY3AyhesLMVJPWONXsAKUvkmJtZw?=
 =?us-ascii?Q?C+ftvkfBtmvDce1cJfM0jhmIhIw4c7HsDq6i5YVK38Pfqdr3XCc3B4x0BGrc?=
 =?us-ascii?Q?cOWbw8VRrDEtnFBNxtGqSayDgBM9R2ZVKxjfQBqV6UTqow7RCSXjuDlvbtvt?=
 =?us-ascii?Q?MetQrh2tgNm/DSxiVpdTC7zhythQbhMXRhRUslie+0y/gT31p/pqTYKRG470?=
 =?us-ascii?Q?XWMR34/t30NyUAUI9eD7syYCTz6vxl1pyENEqkV62pagQBqAltIJfekeO3wT?=
 =?us-ascii?Q?Pc/EeDfvUDAHxjiVOCRZM0/T/2CLcdV/GWhBgCV/yEMYvWLs22aqrf+PEIfD?=
 =?us-ascii?Q?4Q3OZ2XO3JZlrLj+TfTRBR7Xji8Qshv5SpGIoj2da40jbz6ciIIQIomPwy/Z?=
 =?us-ascii?Q?j5g4oGhUkj5DulSurXJosC3NtUMAlJ/DrcgVLSWxoOBIH/xaC2x02CoiLWe+?=
 =?us-ascii?Q?bG0dfAUmGSeXdePubnDnrUUGIuuUShnAetxFzWVNK+eX5o2IIsh/jP3WOJL5?=
 =?us-ascii?Q?QQQ4kQrD9WF0VdrfxuPgJ/sXZP3ObP2HxOdwDHGZWgQouTet+EikopqzA9zf?=
 =?us-ascii?Q?SQI0DviWHURVE3I64rnx54uD42iVi9dFDpMsWSDUXRHcxaeI7h/1I8byedPX?=
 =?us-ascii?Q?Sx/jSpF9EhqUrPc5SMpjhKEYxhcpR8azd0BQ6VPKyIZ6hT3dQCKcbiv1G0z3?=
 =?us-ascii?Q?qIpg7SoADWT0mHnZh+qZ2XZPx/6OP1FmqJ1gs10wTo4hLMxNTzJmuL5v6tYC?=
 =?us-ascii?Q?dnoC+9WPJnl7152uY2mFuYtJ/PxdUq+XNrY9VC7JsjRyMLBUiRUecrNmwEZr?=
 =?us-ascii?Q?SuJiAo29NjTrj54/8nHzlaZ1bfwRMcvh/w5KVdLpLXg2xP2fnthzmXYkNK4I?=
 =?us-ascii?Q?HPd35kCqROtF2Nu13WKXznGp4JjokpWAN8rMErp3Pvx+rZ2Ao2iH/zZQhrfI?=
 =?us-ascii?Q?ylzvPLbn3yQre+JFNBZNDun94WjESiHYWk99omq4tIT44siiNFNkR+Kgmg88?=
 =?us-ascii?Q?W6RE5oUpXy1/nMD/z04k87VvgMEHDdMzKUvgmopgBJRXY8DVeKtvU0XbIBTv?=
 =?us-ascii?Q?dxGjKmv8Ac8dBs+MNHan+n8/3HNFuxICAP9/IVGlxNer6uIuCUZBFD50s5BD?=
 =?us-ascii?Q?ce81AwWBwvxK03E7opFTn9Mi+L9/yIdeG2wwjkDQj6eLJpUeguz3LumrLoXO?=
 =?us-ascii?Q?fxPJd92r6eudYr6q4UX6v6+jntg/nLiwcdHAU/H4uSS/B/59G+KMXdL+fDrG?=
 =?us-ascii?Q?MJDp7yhOv8qooSIgsW7TyehRIJ5U1ntxK0z0AhsluzXNI290HAc65FyfQ88z?=
 =?us-ascii?Q?cChVNfNIl/cTSzvoMqIYRRuS1Pf22LXv2D0VpOYo101l8EQf93YZlApJs35E?=
 =?us-ascii?Q?ZShYHg+4hNsk34FLTT9ikTXiOFFm52H0R41tf77zmZsDOqIKLb0i/aOQdMUE?=
 =?us-ascii?Q?5SNOwqfrf5QizPlDEtO9LQ/4zyKxVftc+yOuxW67a+ZdBM2TwqJbLojg1ViS?=
 =?us-ascii?Q?SLUDmzlwNX0WhIFdpSGgWLy/opxnREyKwWXLtjxDYQqNm93dz4RcbIjR6nBf?=
 =?us-ascii?Q?v5uaEd8plRd74yWdyxU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kLaDzC1BVV0YS+Vi9Q5/DjKHO9zTb9OVqXYHmn487LBNa4c19cWYM/Sw3dJ5?=
 =?us-ascii?Q?O1kkWDHNgQkf7TECc0Ma9IhMZBWMUSr/SBQwr/z4I9fEsPYEjrW2RI5sLVf3?=
 =?us-ascii?Q?HRu39/2WBUE6y2aSKgTSdeMcNs1PfgiRpuWgEVnGZt7Z0NHZSGlssSeJYgRL?=
 =?us-ascii?Q?KYpT+NpbhkNOPAyNnXK8kw6b6jnb+26ILiZ5heh4sBC4E9AFxRJOctK5Llpa?=
 =?us-ascii?Q?mSoTI4pixQusLXCkWLnqtcVDKXNGE3+Gey3KD5i+b6VPVRBkj99YqZwy+Vr2?=
 =?us-ascii?Q?ErUAe9I+tG9vTnyy/DsLludEw/CQC12TsqtCr3FjcZc4a00L018JTqsOFrY6?=
 =?us-ascii?Q?7XWEz8kroKO2pNhuSdLGvkCBMa9IGOkDnRh76qqzalYFXglc/ffUcuOUr0zx?=
 =?us-ascii?Q?9OYzW2Gg5wa+yVbvuGUXoBoFTZJzKZy0I8iAxOlpYUdzy0S+dz+c0TBkUhXF?=
 =?us-ascii?Q?cZ56XlpnzC8orkMDbtmOOoUHglymkJmNZdu6/4NNapC+40nc7vznf6U6F8wx?=
 =?us-ascii?Q?YTWlsURIK0sB1xHIohFsAQg72iV7+mGy0IBOc7Da3QIo4oH5Klz6nxHU+E+3?=
 =?us-ascii?Q?SfrRmfLtsXCjMyHKZXbf4F+DgCOH1zm5QwprMlmgOFYVfqfKWCsdlERtPZi0?=
 =?us-ascii?Q?mbIB5NRaeA6wSgVEmtlendNvnY9NRB3CBe1h8rKnLJIw0SbmgXX4nwPzGpEb?=
 =?us-ascii?Q?KfMIV4kYZ03B3sxl/ZPnqBh5Vtn2wl7sv2H9ZBeikRDDvBqySeCXufWXgfOT?=
 =?us-ascii?Q?Vpz4B/w1aSsEyOiYLjB9WrsxwvDALX5IiFRedknKKjE2biwznpP6CmaC+bFT?=
 =?us-ascii?Q?wZVT1WTbAqzAUsLOgz1AgnobwqCoAjQSpMMPdcIdShB3JB6i1VfDXLQD1Vxe?=
 =?us-ascii?Q?i9twN+jSJr7Dwa6dhwnvhnIzc2YPaV+V3YiRXYIaroQ+2BGvHiG0BwVYeUPs?=
 =?us-ascii?Q?eodEjX52c5r2kRvpDHz/Y5ryY8QGAUvw9mTUka4AVFPrH5F7S3rD+uq4xE6y?=
 =?us-ascii?Q?hjvCfcRPk8jsg47TZID3sLiX8TrYYhEf+1E1D6IyrCWsWcnomhelKCOj3MW8?=
 =?us-ascii?Q?W7VA3cwqN1RfL9UpF4yNMJwo5izjATLjXEYdVJRh2sSM+KwP61HIVUbLNwd+?=
 =?us-ascii?Q?DlOONo9JzwUhsacp/XxVAROiQgZKkA89KymYxUvcaQ4e/gKrwHtwheLUoMu4?=
 =?us-ascii?Q?CkPPCmZsutHHfBZyhkuSaFTDQ41R8eAMJDuBSbxdiqtdB0A5xh0krD7DT2wF?=
 =?us-ascii?Q?tA4032nho/hzSeZkkAf7zE5ETjOUizopG+f+ZcNHDXl46TWdkX8l2VaoRUOB?=
 =?us-ascii?Q?oalcpHxNtGxHLJCJxuBSavYaaSPiJ1Ibz+pu+z5dodzpAkcohMwIBrN+NAte?=
 =?us-ascii?Q?tg4Ol6HX+4QhuBJXUg3JafIGMVkDvFmbyLjp16YlFaoZ0658MTgFT2i0wSOk?=
 =?us-ascii?Q?YunGsdKMeNmLj+21wv3OBbvAVrcUcS/wAh40aetq7UzTydgd8b9ficRp9o4k?=
 =?us-ascii?Q?bJaOZkKgSl47KGL9ggVXtdhyOq5pR9/MHgyM48Vu/DZWSCMxcELJLLvBuArI?=
 =?us-ascii?Q?7y2D6eRcVAcwnAusfyMI6JQKa9UuyItzbIEYUYVRYnZRKerd+xvP2t8FQsi3?=
 =?us-ascii?Q?njFi+Nv8nhIGDou+zKtONyWv/Te2EHHrpeGcUkf1w74UFbM+Fr0QxTsdl/Be?=
 =?us-ascii?Q?qhSuJmR8xnqGHR/phkhmnGMA4a/GHev5hGBmkx9OHwR0taRhaqPASzCRjEMR?=
 =?us-ascii?Q?QWKIfT5gyA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f266f76-5bec-4240-1eec-08de53e3bc41
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 03:11:11.8806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VoyEhVL/v3wgmqIYI/zfdqECkJlnPUnX8G5kiNTFVUGgf1Z+HW0GpSRXBdM6ECI31GekS4+0pAm+S+YgFQjLbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8054
X-OriginatorOrg: intel.com

On Wed, Jan 14, 2026 at 10:45:32AM -0800, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> >> So, out of curiosity, do you know why linux kernel needs to unmap mappings from
> >> both primary and secondary MMUs, and check folio refcount before performing
> >> folio splitting?
> >
> > Because it's a straightforward rule for the primary MMU.  Similar to guest_memfd,
> > if something is going through the effort of splitting a folio, then odds are very,
> > very good that the new folios can't be safely mapped as a contiguous hugepage.
> > Limiting mapping sizes to folios makes the rules/behavior straightfoward for core
> > MM to implement, and for drivers/users to understand.
> >
> > Again like guest_memfd, there needs to be _some_ way for a driver/filesystem to
> > communicate the maximum mapping size; folios are the "currency" for doing so.
> >
> > And then for edge cases that want to map a split folio as a hugepage (if any such
> > edge cases exist), thus take on the responsibility of managing the lifecycle of
> > the mappings, VM_PFNMAP and vmf_insert_pfn() provide the necessary functionality.
> >
> 
> Here's my understanding, hope it helps: there might also be a
> practical/simpler reason for first unmapping then check refcounts, and
> then splitting folios, and guest_memfd kind of does the same thing.
> 
> Folio splitting races with lots of other things in the kernel, and the
> folio lock isn't super useful because the lock itself is going to be
> split up.
> 
> Folio splitting wants all users to stop using this folio, so one big
> source of users is mappings. Hence, get those mappers (both primary and
> secondary MMUs) to unmap.
> 
> Core-mm-managed mappings take a refcount, so those refcounts go away. Of
> the secondary mmu notifiers, KVM doesn't take a refcount, but KVM does
> unmap as requested, so that still falls in line with "stop using this
> folio".
> 
> I think the refcounting check isn't actually necessary if all users of
> folios STOP using the folio on request (via mmu notifiers or
> otherwise). Unfortunately, there are other users other than mappers. The
> best way to find these users is to check the refcount. The refcount
> check is asking "how many other users are left?" and if the number of
> users is as expected (just the filemap, or whatever else is expected),
> then splitting can go ahead, since the splitting code is now confident
> the remaining users won't try and use the folio metadata while splitting
> is happening.
> 
> 
> guest_memfd does a modified version of that on shared to private
> conversions. guest_memfd will unmap from host userspace page tables for
> the same reason, mainly to tell all the host users to unmap. The
> unmapping also triggers mmu notifiers so the stage 2 mappings also go
> away (TBD if this should be skipped) and this is okay because they're
> shared pages. guest usage will just map them back in on any failure and
> it doesn't break guests.
> 
> At this point all the mappers are gone, then guest_memfd checks
> refcounts to make sure that guest_memfd itself is the only user of the
> folio. If the refcount is as expected, guest_memfd is confident to
> continue with splitting folios, since other folio accesses will be
> locked out by the filemap invalidate lock.
> 
> The one main guest_memfd folio user that won't go away on an unmap call
> is if the folios get pinned for IOMMU access. In this case, guest_memfd
> fails the conversion and returns an error to userspace so userspace can
> sort out the IOMMU unpinning.
> 
> 
> As for private to shared conversions, folio merging would require the
> same thing that nobody else is using the folios (the folio
> metadata). guest_memfd skips that check because for private memory, KVM
> is the only other user, and guest_memfd knows KVM doesn't use folio
> metadata once the memory is mapped for the guest.
Ok. That makes sense. Thanks for the explanation.
It looks like guest_memfd also rules out concurrent folio metadata access by
holding the filemap_invalidate_lock.

BTW: Could that potentially cause guest soft lockup due to holding the
filemap_invalidate_lock for too long?

