Return-Path: <kvm+bounces-46757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 930F7AB947B
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 05:10:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 616315041A4
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 03:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF0C26A0CA;
	Fri, 16 May 2025 03:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nhk4+td8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4988232365;
	Fri, 16 May 2025 03:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747364791; cv=fail; b=KXqD8pP6MuKnVO5yqvWa3r5gfErtWhfBqlDswHbEnTG7kH7jC5JOshLCWyjtdVo79OeoEHXzotTJBnb+mg8SinG9pFfsIninB3QYdNv32rTyC3o0hUJPF9Ddd4iyjI7FIa2R0BXgxn9/D4Gcs/yZi8ovPUIfAMunbJ4ADCP/G6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747364791; c=relaxed/simple;
	bh=NGybmHzZVZU7TtVbVZzhpRg3GTpQJI2WEBBLzxIINWY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JqAlP/bkekptCY6WisiIyjfXUacMy2I0TxK8qRBeNRN8JlGLCTXc3G2cYGQMy/VP7dJSmtOndKVnvMpzLOt1lrp9knvZJkvBoUmhBes0tTtcrsGLe9vuyy6Y7ufnsCArqmHCsK64bFHhka677lMEDZR2CX1p9DvYpMYhIkvI8+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nhk4+td8; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747364789; x=1778900789;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=NGybmHzZVZU7TtVbVZzhpRg3GTpQJI2WEBBLzxIINWY=;
  b=nhk4+td8DBCH3xe7gj+9w5fIutqDwJdaAAQ49kv6BjzMXkMerisPscbg
   uTUVDo96ILdBCP5Wfu6xi5JVNk+SlmxeV0WrlaI0WzFdVo3W2ZWMwAjv0
   rr4hF7vkpkKWYVY0hvmO7WCRYZ86ucQEe7F3wgyzgd98zxX6fhqQDBdrR
   C3DRQZkSwC+3IUysmRlI+ctqDn5/NOtueTHf/Mr3fxiTorUDbUXi49hZ3
   2FYGHYpaAmLc0qWe9MyBwTlJX54AtBT2LuyKS0OQE7W5FAkjmAhEPbB5Q
   ND//PISDG7ld8APxEbH/e6Rma+wc9ea68WmxqpfZXq1XO3xXb8lyDHz5S
   g==;
X-CSE-ConnectionGUID: QVVKUHyDSo2MiHAqbS/kRQ==
X-CSE-MsgGUID: F5gjeWrbQZaIUVTbmjHWKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="49486198"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="49486198"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 20:06:29 -0700
X-CSE-ConnectionGUID: TcUjF8m/TJCAUB5hayhWXw==
X-CSE-MsgGUID: jFYLRv95SwuodQpv/yLIUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="175692916"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 20:06:29 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 20:06:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 20:06:28 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 20:06:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qtOheXXMhhMOeJ43YrWFEBPf2ynBRPsVvRHrd/+rGmQrH+AWrbqXUUjp/QsyJqdVuD/8bxUlhE2hNjAO08Q3d4n34Ua8x9Fd8b3mL8GiAOe784FF5gZ+zYHO8IyPPS7x2hayXpN6upmcIXtq7hjdCo6wE47nqNC0GKnjkGzwKdrKu5kyUO/q7Qv6NmSEiJsaE5/QjMweeexHcZKeFIYgKwB5IV+tBKJvmvcKsRtPkNbBK+5qKeP031XUWyhJ4AEFw0whxRwBfJJCsqWrfSPuBhQ4P5XG1hEnRZc/bDozjcpGRKZGHqEgfFmMyPLagSuNk1b2I9rbxSkiy51iNVL5FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zztwtH6/sfkwsRNIcgRKVOi8p491qFYsvScidAvQwSc=;
 b=Gp8F+RuKYIUwlXuPhERg6NJjqiIi06rfMEvJsJH0ON5PGJZHEkGxOddfg79UYgJaieZydf5z11OBXst+ZNuzXbAxG0M2rFq9mG+GlzV6uVv1fhXfRusohF4ZwdjalW4dfKQltvKyZKjC0O3TXWUlI7BsSiJS+yZLDY3fzUfI+oIXxbA4TeDV9vT5NuIhuwIGcHdoewYc6Nx4l0Sv4/6qn6Q7riz7E+cCpEq0GSMY0//dPY6ZXHwle+0yCDLSvz8H9yMFaX7gnkXVqdXnvZ3JcLLiLcaVEo/yfGhj86BihWJZVFPcWldfl0etoEhrj2Ezku/wCcY6XaerpAGQy8zzfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6310.namprd11.prod.outlook.com (2603:10b6:8:a7::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.32; Fri, 16 May 2025 03:05:40 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 03:05:40 +0000
Date: Fri, 16 May 2025 11:03:30 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 07/21] KVM: TDX: Add a helper for WBINVD on huge
 pages with TD's keyID
Message-ID: <aCarAoK2C2bcki66@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030549.305-1-yan.y.zhao@intel.com>
 <40898a3dc6637f89b59c309d471d9f4a8f417a9e.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <40898a3dc6637f89b59c309d471d9f4a8f417a9e.camel@intel.com>
X-ClientProxiedBy: SG2P153CA0047.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::16)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6310:EE_
X-MS-Office365-Filtering-Correlation-Id: 2139ca07-e5e5-45d6-9ac7-08dd94268a0d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6OZf50TQ1qGTETw9TDbV/PrjJFf6V+xxPAu/ZPSRH32F9NSESPadqXrTjwEV?=
 =?us-ascii?Q?UAUaPDDM3T0xTTl6zDBnAUvY0+X3tSFRLH19P9PpP+vi7xS1lpihGfsd9Ikq?=
 =?us-ascii?Q?N1lZQXLpuvXmjFzBShxUpfwhmuJ0xAOaGX7YT3HrP0WZMEUWsDdpSuzH7wgT?=
 =?us-ascii?Q?itbVsO+6Gmf4mj4xlTGUklp64deqdESdNZ7rF25VJwUzd6eqnexJHjo4DEuL?=
 =?us-ascii?Q?wY1XOHOENdAU/iOCt/PoMHaQ8R68nPtFD7qTcmOWCWAsHRHwXuhRB9C216un?=
 =?us-ascii?Q?VUrwBSG5WJbtL50eqYZ2FyUJl0XD2B99ufkkAVGsP7C7zhNL13OcaC2DT7ej?=
 =?us-ascii?Q?2foM5UZNjNAxood2bAU+gL5Uldl2kv8pz0TMLIBg/KsYej0K0Ene+bnJArxg?=
 =?us-ascii?Q?xqvZ4Ea34roQI8QwcgJSCj+mVJvpFgZeALPEHWbeklh3dEQM/9f/fh6jDFoI?=
 =?us-ascii?Q?poES9L2cuDCvIqdb9QlVKWwygVcHMrcMDM1pKdHeix1f2xTKVhxBIIu/iMat?=
 =?us-ascii?Q?KaagaV+bY6DOc4jabjdbF2XEDg6iC0JbES98VuhMIDszmy1Hv8cXO5FLzBzh?=
 =?us-ascii?Q?Djqjp07QTYCCqYIIEVOgu+PUIJuXEPib+nhRhdzXBWM/uzySrZL1w62lc4Hy?=
 =?us-ascii?Q?tAfCElccxKBPjnI3t7/k0IvFlmVnMhZGBA4ub9DvxjS1PDdmUNau+AGeYDAK?=
 =?us-ascii?Q?3yFRGq5AZecyxY026BNP4jyHqoCT6zh1r8iob1Ala+YOGigh5B+/pKNAKGA0?=
 =?us-ascii?Q?cn1K2WiOeFmOo2wi24hafonxblvzdRTtd6sXlBFtWxZL6rYf04xAYik7KJWc?=
 =?us-ascii?Q?2Ghw9NcMYv4DPuAgNs2ksNFAGiAD+Xq6ebw2XY4za8j/b66Lg3W3pTAOblJG?=
 =?us-ascii?Q?KECjo4wWHvJFNv74SXH9ScjV6ihSKPzOw+AJzox+wIqEcBZyFXlSH8NStrcZ?=
 =?us-ascii?Q?yJfmD7IHAAGqDBkPXmYBsdHGQujE5U/GlDibdzzkiwH4GOlT2CZjDNpOcMlV?=
 =?us-ascii?Q?BV/bccLDVYyQCqGrgNaERk80z/B9nTsYWDtqhr0LGEiLic8gbr6sxeXatzWq?=
 =?us-ascii?Q?BOrTP+sY7ZIbQFUzgMwerxc80b43obt7aUnYbsJDXfOwIjpIdrQar9cZ0kOZ?=
 =?us-ascii?Q?7jMFmYYazv8XlGMmlm/D6zl1l2KQ1l51kPu8Qx/ixFWtDCKFRomT1aA0t+KA?=
 =?us-ascii?Q?n1x2g5gbo0xk37g8JO9s6N7+GoPT+WgLGafIj6+QO6fhdz6HAOtTSMXDpXoH?=
 =?us-ascii?Q?MgvmSSP8yfFBi0UVS4Q1W3NuC3o21U7WhgVAByT5UKQcSRKbx768DZc9LRrq?=
 =?us-ascii?Q?bTiXoqUEOVQbn4YuSIeG2KPVkNxeZop3WBgp+V/qoHbO2ZuV7U/9BROU6BLz?=
 =?us-ascii?Q?NstCJabNOI/S4eq4/SVd/DJeMSdrw5ME6etgt0I25yaRde2jo1uE48dcfEWO?=
 =?us-ascii?Q?+WdWUqz40h0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1k2Ir9yBrfWjAlYFnTVW+PKF7BPNo/CLAFMEuhU9gqGShQGCIAY4g+FPFqkE?=
 =?us-ascii?Q?t1w26qFn+V5VeoFXhwC1A/D/+HjEZaWkDZWOgp9E7D4MztqJUutZQhKh8R5/?=
 =?us-ascii?Q?CwSobIJ6BNPGigKZilMeJ5VEF4/TXA889d+58lY0VSq+b3bL1ZTGTT8Uco7f?=
 =?us-ascii?Q?x8b/vA7miC5CMel2KEInZWVRIg1Q7PqnWPb9Yad8/3UFhbwDKDjCjOJzwhsY?=
 =?us-ascii?Q?zrE7LFc2nCFlamgqLB16FBqiFQri4yfv1Hgv8wfmq0Lm6cKgD4zWtO00FB0y?=
 =?us-ascii?Q?9ml93U4ohdJK0Y8mTyFRtl6i8U/rDl5xfVxxuTz4W0aW5hHU1ekC/fMsBVSs?=
 =?us-ascii?Q?+/+5OeKmduuX0lcTriMYSp1s+3InCiaIgvK0VFSHCGjW2Pw/9ZFbr293EGiN?=
 =?us-ascii?Q?YuXXYgGJawrSUHCdvp1CTdaTBv0QNpd8K/lwtbgO2ue4wqT5PxSKA055LcBB?=
 =?us-ascii?Q?b3ulAjQoAqK95tlcVG/oUlNzE0edyuy7T1FAlqdZ0J7PI387FWEV9BMuzGN/?=
 =?us-ascii?Q?CH+NqnL4d6oo3EA3rpLKsyHup6GiD+kgB6Lb+1EaDIvkID/2+BKUImNW4PYv?=
 =?us-ascii?Q?x0eUbwok6c+DEyk+yEB1FKGk4BnrtniNpCJV+Cq6djMdzGvrhZG3srF4dQ8a?=
 =?us-ascii?Q?ewVQmaMSRrhXsghFMAOi8Yd7koVoZ2ViNgac4Es/jXo99zeWjNj6MPrnZ9m4?=
 =?us-ascii?Q?TGAt4ecy508SFwyMH68a94ty5yJvvM1NYXiAU0vnptxWyNnZGjQ4StVn4zg6?=
 =?us-ascii?Q?82P1C8eS7iWgho9WpYANXjc7i/SLqKafAJy5ElurZzh7lORyYqbjNV8gbQMj?=
 =?us-ascii?Q?XV8WyCXjx3dojuxGmUG4U5hZsG4vN0l/sGGP4akbYwehCmutOhBdsiInwyfQ?=
 =?us-ascii?Q?CTLmgjMY/iVCSd7yq4uD3kEALbaOYvw1FFBqMab7nTjLjKJbCLRfb39ut4h4?=
 =?us-ascii?Q?ZrnuoQjy8lK/YOoxnctyi8VZVSB5fhibXF+fkhpbaCHm/bGcyG5v5ZiFCNAr?=
 =?us-ascii?Q?2xlsiPnBhegS4Wj5goaB9J3W3TgzkuCJBNT4tcb9BDzAdcdJ9R4mf0I98NR5?=
 =?us-ascii?Q?gK3PS5z/6oYrTowWbPRl27fGRjbgXgMAFfM3z5HzW6jP/g5l3HzqsGq3atMi?=
 =?us-ascii?Q?JMmXrvLsgyEjIRpXV/iaPRVZLGTZ4WMhxbm0Iq2C5KQsP2YoFv0U9MgTmJ/H?=
 =?us-ascii?Q?xAbZ66aXBMPjSRtr3Y5+NIPL7Mc20Dz4m8ZSOaGUCNBn62XodK8od5uO6EZS?=
 =?us-ascii?Q?zblVxfX9FbGX7INGjo1pIGmCnK9ZDYCXYQGJpZiRz1Qdl4hOYFVX0Et76mqr?=
 =?us-ascii?Q?48hk0r59PAIwDmQMP1FNImsET6No/z8D8uYkDbGOtC+wrdSU+SYk/7ZP72IG?=
 =?us-ascii?Q?F35uJChg9Yuop9AS0ozRzpnu2HyFxcYm+qF1R6VbZ7w58EhUM/cdQWcSob9P?=
 =?us-ascii?Q?sQPpdlb4kDS/kC7m5TiXC9Egk3ZejsT/zH/+M8crshvotPX4A7UQukMpNVJc?=
 =?us-ascii?Q?XxELBRmFGsJjCMaF7NYvJPnwXMXf5zvfOdySixNRiJYiaIHFJl+CB6HLhZeF?=
 =?us-ascii?Q?7j17fxZrzcBQ+Cj7bMDmknCGxkGvJOP2jyusNXKP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2139ca07-e5e5-45d6-9ac7-08dd94268a0d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 03:05:40.5729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wFHDGcASyyuhJAwP1g4B4xcEkR8loJ3Yu+s+JOI54d3MUDVTstgIiQDCbPhaPMWs7Q+G7Z6MfmEG8JrtSbk0FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6310
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 03:29:00AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:05 +0800, Yan Zhao wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > After a guest page is removed from the S-EPT, KVM calls
> > tdh_phymem_page_wbinvd_hkid() to execute WBINVD on the page using the TD's
> > keyID.
> > 
> > Add a helper function that takes level information to perform WBINVD on a
> > huge page.
> > 
> > [Yan: split patch, added a helper, rebased to use struct page]
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 24 +++++++++++++++++++-----
> >  1 file changed, 19 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 69f3140928b5..355b21fc169f 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1586,6 +1586,23 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> >  	return tdx_mem_page_record_premap_cnt(kvm, level);
> >  }
> >  
> > +static inline u64 tdx_wbinvd_page(struct kvm *kvm, u64 hkid, struct page *page, int level)
> > +{
> > +	unsigned long nr = KVM_PAGES_PER_HPAGE(level);
> > +	unsigned long idx = 0;
> > +	u64 err;
> > +
> > +	while (nr--) {
> > +		err = tdh_phymem_page_wbinvd_hkid(hkid, nth_page(page, idx++));
> > +
> > +		if (KVM_BUG_ON(err, kvm)) {
> > +			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
> > +			return err;
> > +		}
> > +	}
> > +	return err;
> > +}
> 
> Hmm, did you consider changing tdh_phymem_page_wbinvd_hkid()? It's the pattern
> of KVM wrapping the SEAMCALL helpers to do some more work that needs to be
> wrapped.
SEAMCALL TDH_PHYMEM_PAGE_WBINVD only accepts a 4KB page.
Will move the loop from KVM to the wrapper in x86 if you think it's better.


> >  static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> >  				      enum pg_level level, struct page *page)
> >  {
> > @@ -1625,12 +1642,9 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> >  		return -EIO;
> >  	}
> >  
> > -	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
> > -
> > -	if (KVM_BUG_ON(err, kvm)) {
> > -		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
> > +	err = tdx_wbinvd_page(kvm, kvm_tdx->hkid, page, level);
> > +	if (err)
> >  		return -EIO;
> > -	}
> >  
> >  	tdx_clear_page(page, level);
> >  	tdx_unpin(kvm, page);
> 

