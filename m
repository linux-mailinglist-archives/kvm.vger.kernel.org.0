Return-Path: <kvm+bounces-58959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9B11BA8582
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 09:58:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62C8517AE07
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 07:58:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F56A264A60;
	Mon, 29 Sep 2025 07:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H3C0Sz9M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6E42566FC;
	Mon, 29 Sep 2025 07:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759132677; cv=fail; b=Q5aY96FglmrzduvAO32bCBiwsReldIS9mvjBPLt4RD6ts9REGPNPKcShq7LKztL+1x2yjNv4EGrxhh+cWnyODCmGgWpyp+c+Wmcmjhe1i294N/EvlSsVK5fMb45l/Mv8UauVVwpPJe94t1QqpmwZKXKFFm3C83we/qsK1QRbEt8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759132677; c=relaxed/simple;
	bh=/5q2jKJwV/idMMeS1upTZKLbP0DCnOv0MXhtpysDiUs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FXw/ixnvTHp08Qeqw32qfOOJ25kXDCmud4xQBeuun47D8n7Ph178h0IflKDvI9Pif7r4LHRsLaecmguh3YfTp1Q0G1MhW/4Dw/VVIugX6IqcgMS7Lykuuv7w7sB0pcBOmf9X/mF8bP0i/7dIw+WSHsuYDzd3bpRtgDm/+9vlAiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H3C0Sz9M; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759132676; x=1790668676;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=/5q2jKJwV/idMMeS1upTZKLbP0DCnOv0MXhtpysDiUs=;
  b=H3C0Sz9MRYYc5lUY9JpAVMQg1CSIKPPvLF9LaJhIvs4u2CrYikrndgVX
   lb6YPtuWVYrb9ULAWrACSChJo7HE7wTCsuxo08WrdbwUJ0GaNQDY1DAKN
   4UhSVoY6eEoscNz07D9xWm6WeeC/uqO6n26YiAKEGKYtL5mCeHePyLRBI
   MOfmgTGeqgSOQy/gLCQApkD1BSiakLrLfTanNMNQTb4neuOT4vPZEmdRO
   JwUTWq9Gqs8Y27hDRAIzOBoc7aTRYNelNTevUXDg3ilGOMW2zIdqu6U9m
   8Zrid5Zq7zzJijF4xKv4PzmKLv8JuGz2WVDlvsR+46ls9SCxPZ3rA28dS
   w==;
X-CSE-ConnectionGUID: pQWWUOoAQp6dv/H6Lp0Vew==
X-CSE-MsgGUID: v+LY7tZISNOmuZxco0s39w==
X-IronPort-AV: E=McAfee;i="6800,10657,11567"; a="60403897"
X-IronPort-AV: E=Sophos;i="6.18,301,1751266800"; 
   d="scan'208";a="60403897"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 00:57:51 -0700
X-CSE-ConnectionGUID: 3azMMogmRZW3C3cOvHY1qA==
X-CSE-MsgGUID: Z+O+MavYRGaD46NTjtbouA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,301,1751266800"; 
   d="scan'208";a="178116677"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 00:57:51 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 00:57:50 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 29 Sep 2025 00:57:50 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.11) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 00:57:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VGrmVHblWXPtXLTPtXrZOQnz4cv0HMNn/beIceAVmu6vglb+rPqRp81iEAPrIVwF11u3EQXVN4MDaZcFab7jCOepxrXm3yNX5xVk0UedKfI2lf+5r3ooXnkf3zYC86Bhl6bRYISOlh52soLhLdDj+1bzyUtFn2Sq++CM5XkcFzA/HcHFJrI9hk0EeV5nl/8uwB4Rk8VBYuW/3IfMoXSLPNvVDXaYUZYrD1H2elJHMV554iR9Gh6/E6QBU8tqTmP2oPtEhojqWLW+R+lTI1iGvOLILZV+bYlAvzPSChJ/ZqPFGavfc+TmW5sEbHbQDYEAfuse4XgIZwfOiRNJ14khBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tF4mtYvWUUGWGs5TlRVeFqtMZzY9y1t2ppXoNq1oFDM=;
 b=jzbE2mCug0SFObOJNMMFthh4vb7SqEV6wc1+ymjzHrfHXLqDL/bkRETsyhrRuktXe1Xm/XTKDSFXLDK96HajtYWC4/pgyrs1zo3TRxf8mu/hCkjJBZH93dTYX8a2aj9qpx/2IF3nHfKltbJMcTK+Hn3FHPhVbfcCkSgDDaYpzxlaR0T9+CdzbNShElS1JqGPIzHQKA8UMLw5jJ3ZZ+UrS5fy+vawSfKVauSp0k7Ew4/iaLZWBBvrtJloTC2QFRWPzj3p7ihyvusqN/88kYyL4TqyD4XqJvrpihA4Il8FGCelE95fM3R1joAdwE/gkWPl+MJCBPUZLGPrEKzR6W+IdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4727.namprd11.prod.outlook.com (2603:10b6:208:26f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.16; Mon, 29 Sep
 2025 07:57:47 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 07:57:47 +0000
Date: Mon, 29 Sep 2025 15:56:36 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <kas@kernel.org>, <bp@alien8.de>, <chao.gao@intel.com>,
	<dave.hansen@linux.intel.com>, <isaku.yamahata@intel.com>,
	<kai.huang@intel.com>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <tglx@linutronix.de>, <x86@kernel.org>,
	<vannapurve@google.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Message-ID: <aNo7tGlyGhVdGze9@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-8-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250918232224.2202592-8-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SI2PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:195::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: a6ae5184-3d61-4118-6421-08ddff2de0f1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tRriRRELJrC7uot0GhCYc4JEW2+urt1jMrb4tY7OhZHU8L7q+wLuVKD+4qjp?=
 =?us-ascii?Q?6lUDHFpHlvrA8jhylGQnoATSc63jvvtdkV0oUEfZ8SdHTbT8gCXI3uzUJSnt?=
 =?us-ascii?Q?8YQvGw0Jm3FVw6Oyqkn6Fw8ja2RI5C4n0nVowLNcSqtZzIdSdUBGxUKUDGgL?=
 =?us-ascii?Q?Oo2w/UQGHmO+lW9OBcx0CidzJz18pPCYQlQLSe8RLQwJ9XdODcJSgKr6Faqe?=
 =?us-ascii?Q?ayGDXL0QD7t4pcCvntbbtp/7e+XVH9Pk5VbrtH6bh7uylGIWk0RsV3Seyxjr?=
 =?us-ascii?Q?KR8xftPksBA37SX1+h7OGPsaCzUWpOVBPpRjY8uh/LkDkv25X7W13bME9KlH?=
 =?us-ascii?Q?9SN49nPNcjFIc+yWllWVoP+rchf/26bbqWcXWAs9rKM2IZdf2i8wLFQv8nwD?=
 =?us-ascii?Q?c4g0kUNGBpvhVKLdBCrPHk1nCArcMCj+/uHYJuMEd4OsbWw3DNT8AIvYxVRC?=
 =?us-ascii?Q?eYIDJmjxMA+81Lbdgq94CvVEf03ZcnjZueV2A43ZDRj/AqjVmAVTk4a1ShfZ?=
 =?us-ascii?Q?adIaC8O5WZWMLgtD4p/tzjBOlVXYfWLs6BhbmM2iFPf70o7RTpsj+05a/sbg?=
 =?us-ascii?Q?P8vIZM3DpSkWvP21r14gq2612fU55fBIy/UwjkDXBtADKChFoKDAu4N7rbi9?=
 =?us-ascii?Q?O+lyEpnWktvzXv38v6UDyJNYtiyd7TC5MXvS7ZTezZP9GD4JxK8MXGFigLEb?=
 =?us-ascii?Q?4o7OIxaMQffxfbl+IpY1RwsrB7VgOr9R60MSqyB77cz/6KNdMI49SyBeo+01?=
 =?us-ascii?Q?1B4bJxquLIupqiQDpPjf13Y4+T6kx6aUJJKy4RUCozQvpHZRTu41u+4xQ4eB?=
 =?us-ascii?Q?PKQllX86GGsseH0aaeG336hg+q4AodOjEVpRakGHnZhYVLbpEHQ2aNgJXtkQ?=
 =?us-ascii?Q?yGm9t5DS5DWVHgO9yaHvFKyEYNKELg7pmMWpyxGXXnHiIldCHGLeDY0CmTKE?=
 =?us-ascii?Q?E/nzQQVd8rrFqfHdG9e7tkrPr4+i0Dos18ftBsJPdjYxrld6vEd48IdjbCvj?=
 =?us-ascii?Q?yTM7KLEe12kleGS0LP1IdBoyKx2rJWjz0s+CQz3PLm7gJ+KxKW+7nx5Zn+1d?=
 =?us-ascii?Q?tKI6ykOBIe62MKaAUYZmElWlvM50u3Y1oO22wybE7KEXp9RASKlte6NFeFSw?=
 =?us-ascii?Q?J5qgmnBJwi2h5ATiPLKVm26LDZA/makTXQszla4H1nOIpT1M5XZWkl3hOO7G?=
 =?us-ascii?Q?W7B0Th3A7k4SHq8wLx0y6tRYMbSdO+76HlUQye2bCmuJMqndqF2+ysuf5eml?=
 =?us-ascii?Q?RDBN+m6xZdvxQA2wp/mZO6ewCkZAVlMR/9cXP7y5EGmA72+sLT4WUf5rab4Q?=
 =?us-ascii?Q?z4bTNi3OJKmD9BdG9Adgo7ySSbNONuypxQGjmlCN3Qbs/U2VwSee6xF09yJ4?=
 =?us-ascii?Q?nOTVM7NSzNLFcDxorj4Jp4Tp7G2DorXQidiBAAVAvkJPlhj3ZLryDUVcaaGJ?=
 =?us-ascii?Q?DWSxSeXsWqFhYaCyZFZ47Q6cErHrctKi?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dWrh8wMAJFgLtrnbtKmE0u1f9qHBEf8ELHUetDFT47eqISbUqfbEP/kAJMke?=
 =?us-ascii?Q?3Dc3X8KqYiVm+5zF68Zq74zQxZfX+s1fKLTyb7hzQaHrZi60EqcC260Xf/+I?=
 =?us-ascii?Q?vW+Ov8oGP368fUwyiFWwW9yQ9uX+BISAjBHDNF/JYM35o8FCinIVUMoy389p?=
 =?us-ascii?Q?n2PLR/G9cD76Qq52arrqcJe0kBAVSS48FDks5xhYTPZzGmpsPnsdlmNpMfxg?=
 =?us-ascii?Q?ovx2vZeVNxp64L/16qRaujk3Npda7fw8O+78z57T5fA5RgXylHbepg/E9HTw?=
 =?us-ascii?Q?0pdBFyjtYP208++/3Sxiq56xUoQwO3q9/YOKLabc8J2OjI5r4dr1PDj6nbql?=
 =?us-ascii?Q?euBxvny+Dmfs1mnO4hwvph+4spqD9HE5dHWPcEbWBhmE8arixRWRCoDuu+cW?=
 =?us-ascii?Q?S7IBXp0Uu3wBBfefmtSYLDTa+ZodWH8yK1iFh5pEgaPfwaSEc6LafjlV18Ac?=
 =?us-ascii?Q?7VB3d0/+Dc8Kwj+UxhEaZnUoeTv5/oyVIGYYa7bsYIGbeeEBt01mlgaJej5Q?=
 =?us-ascii?Q?obAv0fjvDt2MgG7MfxjN9YEdrkFmqlUioI7ydc9XqcbpDR5WspB+eNuEQSmc?=
 =?us-ascii?Q?ConJdxdZC/2QWviSAaDq3hphrjOOxN2nRZ1zVv2K5mZGPGVakeWT+2KmC6fL?=
 =?us-ascii?Q?w+z9XVCOifmwPSw4SdXtEV3cQe6WF+3GFZYWUrLbc8XsAl3Z0ESrTo90IWbc?=
 =?us-ascii?Q?3cMY+0HfF+OVYuBPKZ9xr3lPuKJ3LNi3Ln1RCcrfIJhgu/bvjWRUzWZ8aB/k?=
 =?us-ascii?Q?NNKxu6MbhrTbqSOtWuECoYHHXfROdOoqgSeCCPF0WcphVYmQmWqaCjN5AwAP?=
 =?us-ascii?Q?Ltpp3W620X6SoTEOJO8fOuuuyRyV1ky9+vlxoyUN7EJquT9gfKp+4fI+n1rp?=
 =?us-ascii?Q?1BTF3/gQuwM5nz74VSVDJdbtdoagw+OWrJZUcFD6MGEfDjKSsUI5332Wx54j?=
 =?us-ascii?Q?NsG6RGOqrHmj4CTuGEfj2YJGJaU4AKm7TILV40OVo5YVFJ/gDgeIViTtRw3Z?=
 =?us-ascii?Q?OdMgHkpQW2XACdJm/0ntV8zqRJLe2vWH0v3uCgMSvJ6SnRaVkVm7IG2nKrEn?=
 =?us-ascii?Q?Uu+7b0eAO7K/PmJ/iWXWjkG48YZNUxYU9zfwmAJXYUpEGf7G9Vy3K+A3OQFK?=
 =?us-ascii?Q?mLBgAYW6Fx49YmHEFWMbhfczB+t1lsizj51NyCd2jElCXzw2LW+QjxNUzyn6?=
 =?us-ascii?Q?7v8sLPesDGWSUMQd98MLxIFymT28yNauF5YPwEiKiMsvfVoS8TsYtEJNxPoA?=
 =?us-ascii?Q?SqIL6QRLwII0V3q/P6CLu+YuMdRIY5iK8PHgQRtUZ3aQPpby6Lm/2cPqp2Zf?=
 =?us-ascii?Q?8aK/pdo4BMIymXVYYZs9oVxkwO8hJRI8honvJl011YHylreRiIrPICDiMkWr?=
 =?us-ascii?Q?igUuKK6PkU7dX9JbHGQnkjP4zbVaINlCh63IQluDglYUiZYVuNWx8nnTE8eL?=
 =?us-ascii?Q?v9KIsL+mY+mtsyqlEHPU75gGpX6eCG0L8oU8DLKGfvt8a3jjbsp0I5byqJJn?=
 =?us-ascii?Q?2Ib3grxGHat4k4g+XC+pXz38Rvg3b3qnXEbBI4cl42gK+HDElsyH6LkgUyY7?=
 =?us-ascii?Q?j9ENcssH5274oj2lGGPtY2Bn5ZtDd+C7E48Z/0j8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ae5184-3d61-4118-6421-08ddff2de0f1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 07:57:47.4960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CBlhtDEBxAgVUxI4a3KwmM6HQ+aF6c8Sn2J03fENo7ybvfCWPP+utDPXb2a8IRyzl/KSvOvniijIHbDGJm4LEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4727
X-OriginatorOrg: intel.com

> +/*
> + * The TDX spec treats the registers like an array, as they are ordered
> + * in the struct. The array size is limited by the number or registers,
> + * so define the max size it could be for worst case allocations and sanity
> + * checking.
> + */
> +#define MAX_DPAMT_ARG_SIZE (sizeof(struct tdx_module_args) - \
> +			    offsetof(struct tdx_module_args, rdx))
The rdx doesn't work for tdh_mem_page_demote(), which copies the pamt pages
array starting from r12.

Is there a way to make this more generic?

> +/*
> + * Treat struct the registers like an array that starts at RDX, per
> + * TDX spec. Do some sanitychecks, and return an indexable type.
> + */
> +static u64 *dpamt_args_array_ptr(struct tdx_module_args *args)
> +{
> +	WARN_ON_ONCE(tdx_dpamt_entry_pages() > MAX_DPAMT_ARG_SIZE);
> +
> +	/*
> +	 * FORTIFY_SOUCE could inline this and complain when callers copy
> +	 * across fields, which is exactly what this is supposed to be
> +	 * used for. Obfuscate it.
> +	 */
> +	return (u64 *)((u8 *)args + offsetof(struct tdx_module_args, rdx));
> +}
> +
> +static int alloc_pamt_array(u64 *pa_array)
> +{
> +	struct page *page;
> +
> +	for (int i = 0; i < tdx_dpamt_entry_pages(); i++) {
> +		page = alloc_page(GFP_KERNEL);
> +		if (!page)
> +			return -ENOMEM;
When the 1st alloc_page() succeeds but the 2nd alloc_page() fails, the 1st page
must be freed before returning an error. 

> +		pa_array[i] = page_to_phys(page);
> +	}
> +
> +	return 0;
> +}
> +


