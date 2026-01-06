Return-Path: <kvm+bounces-67134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BF9E2CF7E07
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:49:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 53792311B321
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 121B133858A;
	Tue,  6 Jan 2026 10:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oy9doeqt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404AD24BD03;
	Tue,  6 Jan 2026 10:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695882; cv=fail; b=XRSljpX2zvF4QogE7H/VvxNgxyHGScmtxbc2LS74rOCxTy+BmOpSibTMmz7oR2hw+NDNxttzThU8Z+6KDzl08faSnM8AVPwNDfx3oer+qXIw2FjQq09hGM8Vgt8z+VDSp6CwIj7iDnOPFzFYbaGM/yt2cA9rmXfLyKgjRqFQNT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695882; c=relaxed/simple;
	bh=L5j6CTNRlxgLX0yYAf6A6ZXDiDktiOJQxeJYpI09sgM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Y3xMn1XrSWiuqV2SpP7J3vI1CPhC4cyAOT9wP4ed2D1qRGiC4zcKgcPX0nCsLz668A4gqVEUyhtJeBnl1OnBDT32qmFPPvL5mX2fs0m6JENB5KbHpZ2wHo9KjYQHtnDsyLlqHsO8aJE7CdVzl+YItzDf/sE20TDfeYrx87UdmCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oy9doeqt; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695878; x=1799231878;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=L5j6CTNRlxgLX0yYAf6A6ZXDiDktiOJQxeJYpI09sgM=;
  b=Oy9doeqtBaTsw428R3mp1Jx0HpFgwxZV7Br+knS5FG6QF22LH28+KZWa
   UQubsclY3WvV+fw3dd0F3YIs269JwEQbYts+XePaNntsgSgR/k0mLyYBS
   l7vov5vtCxDLm59T6cajDZSwt1XZAHRKGR+3yHwLG4KS6IF9W5ZHIrWbR
   x715jUwjXEQCHMSfUEXWesAGHPf44SyLVOAViCV0UGO+kjU+gr1MNEwQa
   +4ZFy9u7GjAcOXtwh69GA+o723Z9Z6GfPsP9I9j9GPSmtDt4NzMo6Sktk
   mv3u0DoCvfqpcROsnmHPk3yd7DWJSrfwGUFxdHhmKT9af/FSKsRaYQjnA
   g==;
X-CSE-ConnectionGUID: ZrFi5kUHSgeW1y57cMV1rg==
X-CSE-MsgGUID: HwgW1ReAS4mWwFUVJ+hpMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="68802866"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="68802866"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:37:57 -0800
X-CSE-ConnectionGUID: Zc8M4B6RRqS86JYE20n9gA==
X-CSE-MsgGUID: NkLTHx8FQJ+KPZih9sDP+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="201757387"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:37:57 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 02:37:56 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 6 Jan 2026 02:37:56 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.43) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 02:37:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uk8UHZ0cugPcgHRr2gfk9tRUACtvHdae4hfwiZso2a+qLy68EdWLLJzh9SO0JqA7/1bupFKoyVHlgIoBUacgFOI2ezN38OCuxliuJxQkz7gHvVjt8s0O8/sdONoTf+e8FrM0LW0CLlT1d1qcqR689qISWaQY93nSqtQ/MxtaZRX1CrsbXmtCpm7DyPfxv9eSsE7yPS43UzlTayt2XdgnR6g+vruiHQzWjEDItkl3XfTpOEWEbLHqtwoBXcz683FahBOpkXf0hF8mKCAGDJnYhsUjBAqCS/3zdWu7ZPE9MkGPzJd5dSeSYhz5OjJgsjHpXa72VL023znPsX9z3XG+Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bg73qX03SMWt6tkop8rLrUYpZUK9odlc9MIKY3HRQ8=;
 b=wlmvSrkZAxEJVeGCcBV2RQjj5CFWb7OH1XJdIGmtim+nGqa5owJtXbyaD6h1Lcg/twBGJgPyNdfwr71JB8cIC831jiqpR7ALZUw7bx7LTaxYipfgt7ZjRBqtULdXvMiZoPIMxe97OFI7vmLqfvJIQpcnZXEuiLxAGJnbZT+rlYt1oSEZ3ACAxtKPqyaS2NVColyJ4gvnR1iX4QuJTl1azu5zWuaoZ+bDbZzR6Y5KD8mc7ZaFtjLxjEqnp2RzPCIt1f555yb2OJmEGrvBkkAWghKD8dfV8QJh89sZ4LRqik0xOBTyPMTmi5eYB+B/Q4dvVozeoeNxXQ7KJI1w9fE0rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6200.namprd11.prod.outlook.com (2603:10b6:8:98::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Tue, 6 Jan 2026 10:37:53 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 10:37:53 +0000
Date: Tue, 6 Jan 2026 18:35:46 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "kas@kernel.org"
	<kas@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Message-ID: <aVzlgtXFMUotxI1d@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094358.4607-1-yan.y.zhao@intel.com>
 <0929fe0f36d8116142155cb2c983fd4c4ae55478.camel@intel.com>
 <aRWcyf0TOQMEO77Y@yzhao56-desk.sh.intel.com>
 <31c58b990d2c838552aa92b3c0890fa5e72c53a4.camel@intel.com>
 <aRbHtnMcoqM1gmL9@yzhao56-desk.sh.intel.com>
 <f2fb7c2ed74f37fdf8ce69f593e9436acbdd93ee.camel@intel.com>
 <aRwSkc10XQqY8RfE@yzhao56-desk.sh.intel.com>
 <35fd7d70475d5743a3c45bc5b8118403036e439b.camel@intel.com>
 <aR08f/n7j0RyGlUn@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aR08f/n7j0RyGlUn@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: TP0P295CA0049.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6200:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b0fb141-efdd-4402-f7e4-08de4d0fa56e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/Nzg6VzapXFKxesFS77eylwPHGhmYEza2emBjRg1HfcmXCRhQxPi3QwrvsTs?=
 =?us-ascii?Q?moppKX5PM7fnMDpke7wWrdOg0PrZuMwuYKCBQqwTP2gbcE1Sje2E0nnezyNq?=
 =?us-ascii?Q?75bNXtFD0d0GpK+0Q6At646zU8nD1kK5RSU//jEGGN0ZwL7RrN6RLjzaVMHF?=
 =?us-ascii?Q?LkbLWLxfxBThJb3Gnr/WcF9/Vtt5THBFjZuI5z/6P4CZVCYXIk11w3brNRTp?=
 =?us-ascii?Q?ZkMIaCIkKFaBcJb7aCnPkWjvx7huC/V3zQvLMzLURgB80QzYq/li46CEZuNj?=
 =?us-ascii?Q?V92azTwFkcRapq07kA+Aj5XVnw7GUckehmvGaauJrGoEuL50zgIaz4m7pfI0?=
 =?us-ascii?Q?xgeDMYsW1H5NiB4dq3qkfCCKQeCGsQYxQ4gap+Ub9t7t9Nz8o0B7fGmud3ef?=
 =?us-ascii?Q?cf7UI1kMldQ4Se+s7IIe6RQJsP70yYxjdcdcI6yLHR8dUXkHUYTKgoLOTxkQ?=
 =?us-ascii?Q?5y74Lg3tS55gu0rmL8vsficbuM0mbjZ3+2wGI3XIUxODsYYxY7sqDZShDlZI?=
 =?us-ascii?Q?XJZnMoMiwMm4OSW55a607UQ9kAC5evv8c+cHMxmyRPAXqPdUrzw+7p+ZMNGb?=
 =?us-ascii?Q?TqlBHWY+Uyzq2lzzzO5w1kAqCftyRYcyuSNJPOwooQ9ZmE/9Sc1QXBkcB2SM?=
 =?us-ascii?Q?kYS6KXs6JmYZ3bBA53DQbzACSubexWCuQuIW5GxmD3nxOOgqhwrVPVqK38nh?=
 =?us-ascii?Q?otk7Eh1f/ZtXo4BqLFnnJjVcZzPmFDS56JENq5b8Tm2vTnPUiVxUWunT9fqR?=
 =?us-ascii?Q?RWLHqZmlI1UAJpu68P4JGjbZKXKhu92Beu/FfXpYXTrTTMOQjjuAsDlZp42V?=
 =?us-ascii?Q?C0vkCkmXxTMUIFgt3C3vHfir03kYhYsU39tnqAQtokaJ9HXcY2TYL5zGRM7f?=
 =?us-ascii?Q?dMwH+2oxvRHtKGDqqJbAvfu4h+Ao5QQXgjBFA+g/rNySScPsDSp0CUnJEFIx?=
 =?us-ascii?Q?t/NnlB4MOTAn0Wm6VLg1neOsyn2DJx0vNsekxVIxsiLiLabGPjPAbrwrNsSb?=
 =?us-ascii?Q?w74gB4AgCyvlw9ZspScUFbciXmwVxSNybxW+jQIYs2iYWjc/aTrnekOzkTW7?=
 =?us-ascii?Q?9MS3nmxoyzO5vUbFFcE9xbU1r9KFjrN+98i12IOuKc++ye6vC/19FR5bLGw3?=
 =?us-ascii?Q?wUpAnZn4b2Yas4oz5rXrkcRQwQqNyOZN6BvGtKIOD4s4WJJo5/QkDEg5780I?=
 =?us-ascii?Q?tSvF4JDolMiLkhgQOh5QEijrV2g2xBjPAIwn6IGQNH5xLyhUxiEDcGv6bnM4?=
 =?us-ascii?Q?E6AM6QXyr3ViV/oWLI5bhDxh6wpzQtWAHpQZl6dR4Nth/spv0YGyREaXnMms?=
 =?us-ascii?Q?dCPIeUCAOTpvFVEq8rS138GzAmDHb0JKPAF3/15IPHtLW0F+xx4hNMTWob4i?=
 =?us-ascii?Q?ZMsgaf+BEmXCHolMQGEelT6q1+RLK94y7Ppp1z78EyDe7YYbNN9hdyfjwdmM?=
 =?us-ascii?Q?WO/iLPp54QEMS4dtdCXRLBpjH5a083yD0L/tYTSX42nisDM44DlcCQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FpPTZf/PTb3IedcXia8qW7PQ5bkVDyqS4mdm8PV1hMuFaON9r8ecZnnCXV8R?=
 =?us-ascii?Q?n/UwdotxZdyrYiJkkD+E++3mC8bLyJVSnbtvartK3QUZYdVDbYSOEHrLE7O8?=
 =?us-ascii?Q?+kis5IhrC8SO+fAgD1Ys+joxPfiOahEZaCYWH2i3NEp/s/+juZtIS/jXMvuR?=
 =?us-ascii?Q?+RBuyKcWlS/cTAfhhpIAGprBXG/Jnq5MaQJ3RwsmMJknRXkeZI+fHdJmzMZN?=
 =?us-ascii?Q?tfor1IfNOy1heZcPd+EoOGwgNj8nZH+88uWCKpd58bezbsQNGuqB+tv5ed8P?=
 =?us-ascii?Q?QxnugmI45M6aczuO5gTdL91q+iamrCGeupwXafnBADN4T2iAjS1idcFNQcuh?=
 =?us-ascii?Q?uXyeG71p6DkpM9uPb/ZTMgsHeUKXFAGV5MkTYtGEm15bUKWvSRi6ZApTNrFc?=
 =?us-ascii?Q?CeeXLb4OzrsUiFXIb69jdHP9Oc+Fa6nzEcI0FGR2YNLQL2BkYBaXgSl8N+5W?=
 =?us-ascii?Q?Ig50fUFvWtDpeyISCTFsFUil8/FHRU1i2VyI12/D3SDXy7IjAAmnFrHK6T8B?=
 =?us-ascii?Q?t3xfG8IuLyC7txdlJ5NHWg5Wle0NJDgTxnCD5sVr8easvFVjMzhm0JrqsoZz?=
 =?us-ascii?Q?IFcouhUr3PWcuMeKGg2N/73QdYccnZZJwUs4/oXM3V3Pyh44jrJiDejg+hHs?=
 =?us-ascii?Q?+uRd/AhA8hC8yOH3m4hMAbnQMEq1CDlDm9Dz3+wZKBqLnA6lPJBm+u6Iw2zC?=
 =?us-ascii?Q?eWUsgMAHqhNCgcGvJjuCbjEw+pu0YihuLUfgWtyWiXYNf4YCkNebJQaIPLlU?=
 =?us-ascii?Q?WynvR0P0TBL68wTfQmPdup6PL8D5Y5qHiTFTcSfGYsnw9y8CKfPQ5rQIYz/G?=
 =?us-ascii?Q?B7EEIwF6bvRqMumc9ckvRwnuRrWBJCzYNNMaV2IG1t12bk/mlaR9aBsx85xK?=
 =?us-ascii?Q?QvavnZGZH2NO49UwhuWZpOCgW1Zppr/9tEFGvvocKeBiAzM9KEVa10T7qc68?=
 =?us-ascii?Q?Zrcbxut47JwgZMLTSqpm/L//uPMDjG8ANoL5AIexc1tWbkUhl3//EathS+yj?=
 =?us-ascii?Q?zDwnVC1qaHiXtcnauzmG365kujKd3Bba702K8S/J1HWtGLWjWJ8NocwlCywi?=
 =?us-ascii?Q?pJsfp+Hws5U7VsPe0Opdg4X+Mf8+Kmjcqccs7bu0gVr4x3b+tdhLLwo3KAjP?=
 =?us-ascii?Q?ejCXghUpDSrendcdJi3VyTe6Ph+NY6h4gna77LaXzu+3yqHq4Vg9HhclHRZM?=
 =?us-ascii?Q?NM6B11GtonXw5QK4MML7BlovxySkNhN5ytA8zPnF21Tq7CoGjNVMTdj82Xa/?=
 =?us-ascii?Q?DUjfwrqtgA3xxVJFIZQQHRLy7G9S3cJ3Nt5wIdxAKCylbNRhr6nILTjmwRcJ?=
 =?us-ascii?Q?2Ey7fNvdtQqmqJzZ1g0p5iECptzW8y4RakprWXNBU6+tot54WDcdy71f6xrX?=
 =?us-ascii?Q?FY540YfOO+SBxHBOzz5JhA0/oQfZOromnbifbRhJx/k8jF3q1Xm3JCedAnL2?=
 =?us-ascii?Q?VlMx/yfq3qjLB5guSdkS+IG/Xr+VDhz+NziMhzc2uuHKdu64i4LQSuzjK9DP?=
 =?us-ascii?Q?aDfHLBymbiB4jXfc+S20RZpN3OE3Yxp+FOuAPD5mNrNhvzAM7hWdDyA+6gKS?=
 =?us-ascii?Q?VOAzARqyLlLsceJb4kM1CG1jIAgcRDb/8s2jQ9k7aWsBNaI0hKpkgOTWHJfc?=
 =?us-ascii?Q?BwMPeQKYpuO7Wkue4KULUiF/gn8IEEniswOEotZpnYOb+6aLbQ5+dzeUdzBe?=
 =?us-ascii?Q?uVMVufBPza2e+me/VpEos0uKM1sxGlKBt1XKCeubgUGM1HELZ58W/PUEk58D?=
 =?us-ascii?Q?mFQhpmXG3A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0fb141-efdd-4402-f7e4-08de4d0fa56e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 10:37:53.0220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PEE+6aN/kQU8bO2vaSNJlnRbarLdv4tVt7H0/C1nic46MG00v3JmeZsjNfR+qw1faXSTpuOLy274fk45K6ln/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6200
X-OriginatorOrg: intel.com

On Wed, Nov 19, 2025 at 11:41:51AM +0800, Yan Zhao wrote:
> Hi Kai and all,
> 
> Let me summarize my points clearly in advance:
> (I guess I failed to do it explicitly in my previous mails [1][2]).
> 
> - I agree with Kai's suggestion to return a "bool *split" to callers of
>   kvm_split_cross_boundary_leafs(). The callers can choose to do TLB flush or
>   not, since we don't want them to do TLB flush unconditionally. (see the "Note"
>   below).
Hi Kai,

Thanks for your review and bringing up the TLB flush issue!

After further thought, I finally chose not to return the split status in
kvm_split_cross_boundary_leafs(), because the split status is not accurate given
that we don't flush TLB before releasing mmu_lock in
tdp_mmu_split_huge_pages_root(). i.e., when the function returns split as false,
splits could still have occurred during the temporary release of mmu_lock.

So, I implemented the API like this:
(1) Do not return split status in kvm_split_cross_boundary_leafs().
(2) Let the caller decide whether and how to flush TLB according to the use
    cases. e.g.,
    - if it's for dirty tracking (e.g., splits before turning on PML),
      unconditionally flush TLB.
    - if it's in the fault path, e.g., tdx_check_accept_level(). No TLB flush is
      required (current TDX's tdx_track() also ensures no need for a separate
      flush).
    - if it's for gmem punch hole or page conversions, the callers can delay the
      TLB flush for splits and combine it with the flush for zaps.

I've posted this implementation in v3
https://lore.kernel.org/all/20260106101646.24809-1-yan.y.zhao@intel.com.

Please let me know if it doesn't look good.

Thanks
Yan

 
> - I think it's OK to skip TLB flush before tdp_mmu_iter_cond_resched() releases
>   the mmu_lock in tdp_mmu_split_huge_pages_root(), as there's no known use case
>   impacted up to now, according to the analysis in [1].
> 
> - Invoke kvm_flush_remote_tlbs() for tdp_mmu_split_huge_pages_root() in this
>   series is for
>   a) code completeness.
>      kvm_split_cross_boundary_leafs() does not force that the root must be a
>      mirror root.
> 
>      TDX alone doesn't require invoking kvm_flush_remote_tlbs() as it's done
>      implicitly in tdx_sept_split_private_spt(). TDX share memory also does not
>      invoke kvm_split_cross_boundary_leafs().
> 
>   b) code consistency.
>      kvm_unmap_gfn_range() also returns flush for callers to invoke
>      kvm_flush_remote_tlbs(), even when the range is of KVM_FILTER_PRIVATE
>      alone.
> 
> I'll update the patch with proper comments to explain the above points if you
> are agreed.
> 
> Thanks
> Yan
> 
> Note:
> Currently there are 3 callers of kvm_split_cross_boundary_leafs():
> 1) tdx_check_accept_level(), which actually has no need to invoke
>    kvm_flush_remote_tlbs() since it splits mirror root only.
> 
> 2) kvm_arch_pre_set_memory_attributes(), which can combine the flush together
>    with the TLB flush due to kvm_unmap_gfn_range().
> 
> 3) kvm_gmem_split_private(), which is invoked by gmem punch_hole and gmem
>    conversion from private to shared. The caller can choose to do TLB flush
>    separately or together with kvm_gmem_zap() later.
> 
> 
> [1] https://lore.kernel.org/all/aRbHtnMcoqM1gmL9@yzhao56-desk.sh.intel.com
> [2] https://lore.kernel.org/all/aRwSkc10XQqY8RfE@yzhao56-desk.sh.intel.com
> 
> On Tue, Nov 18, 2025 at 06:49:31PM +0800, Huang, Kai wrote:
> > > >
> Will reply the rest of your mail seperately later.

