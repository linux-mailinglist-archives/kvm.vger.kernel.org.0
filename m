Return-Path: <kvm+bounces-62991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 412C8C56885
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 10:15:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E68CE4F21A4
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 09:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FB4E334C07;
	Thu, 13 Nov 2025 08:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C+insMSZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48E3331A6F;
	Thu, 13 Nov 2025 08:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763024206; cv=fail; b=AaiyZBSkRd4nNVZmh5ICNYvRb2qK9D9MZmA960/uT2BNe0QhqdQlOYKFFNWAzC7eUKKlESO4fcuAUFlT3MFJZk9SeKnKm4ElMONEbIlsvKN8rxQFhfMWe68/AtUsickxrrW9DT3JwDTitcnTCf52U94FAEWGpW3XYBHVNYAawHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763024206; c=relaxed/simple;
	bh=JDRgbBupjgsl+ZCxszPfmDPChIlpJdpSMNhnGPQ4ayE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BHYLU0GxIr0A+UKTtCJEVl3tINTsQlD7vo8otAqQcEgnz7obD0uYTDGwZqyo5+SlqkUdSRxB8DeP2FBBWP3fOV6+X8wd+yEEG7jPgy8Aybx/PA+EygVpjO8Atn+5UAJCtbhxG/xO2tsIgzaAHqGlJ6Wl2pqGd9kpeDX7J5FgpfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C+insMSZ; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763024205; x=1794560205;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=JDRgbBupjgsl+ZCxszPfmDPChIlpJdpSMNhnGPQ4ayE=;
  b=C+insMSZeGf16EmDjD+SqCcR5NwNTQgOgdhFZBGK/dEPf0MJrZAF+weR
   vB1gPf9gbq8gbHvfzdnETTQAcNUoY0B8M3ODLT6cSAMo7NsGEWWDFfotk
   Kmzpt7Zs4d0d/FuRLdYfWdywNmaYdg9U+PJf3+MNHsvKpR3Wrrdb1YGUl
   0YSz3QddsgAI7g8XcpvBTUNjjYm8UxYVkuhUaMCXs9+Mr7n56Hb2rY7GT
   T9MjwAAnave1DKMZDYPsDRo7vUXNs29Kp3Ft6u6UYd9W8H4Cqzdj2UM21
   4/8VX92mjRfCu+547R/XnCV1xXCfJ/B4/mQDon+nOCov6biWJjitXTp0V
   w==;
X-CSE-ConnectionGUID: f2kR5ChVQaa8qMff2Npfyw==
X-CSE-MsgGUID: +aCv3uK+TtCb9fLW5havQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="75413419"
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="75413419"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 00:56:44 -0800
X-CSE-ConnectionGUID: pDSntdAVTzqI3xpNKo7pKw==
X-CSE-MsgGUID: RrPNM7W0SrGMSgLUR6p4xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="220221437"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 00:56:44 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 00:56:43 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 00:56:43 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.17) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 00:56:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AkZmTzWENRCpeWc2VExKWt5NQvpurn6YXuVYwu3OHsVgvndIIHwiUZHSoeOrpMG95nkA3zVwVewz4XxN3vVTtbDDC0XAzqbvCz3SQ/fTuO6c/JPAnJjDziYQx/hb4ibRyN9ByTQq2A29WmCOLFG2myLyOIStwQHnu02wuAkLeOc/MPUl813H6+qPIw2wSPw89RsCwUgGFqhoRhITokRjVN7fnv14qAcu14hoEQIB2zu89jZi12L1wCQTi/jdwLzvyKivmNlrLijQj2OOGi23m2TAu7uaZkU4zYRB3ViKRC2Uh6sa6lIoQ23OpOA37BFb1AbGleH3c1T8mcFhUHeaCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vi2o0O9PQs0U4SMEz8cLzIXSZ0KzZhyajplDD8449Tw=;
 b=HW1y3fKD+/h4h95wgW+NRke0PgnQBfTKYTxcIRsCkbmDVd8A129uFJNRsE3AI/FXM5ilhAyG6HXDtjWExNGCh6RQfW8o96nnm0kPCJG8MIi/Zlw1ov3pK5mCnr2OVuOKp5Q3f/kmL0PvwrbryLR9ogVUtNIJ8pCzyhZyBfYrTLV3032AclhXXvlAmTOQ5RZEdhhnKs2JQWdu1B5fHCLIQnQVwu40GyZAOlul9A28VUASLJ3UonJkczr01X2HOL9480N6G5xk0J0Twx8KLxwjw5S8gcr0H+FQpVhRAM2FGbXespwIR2bW+BZxX4NoxNzNBf1/NvtLiOtc+Up1nEPovg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL1PR11MB5288.namprd11.prod.outlook.com (2603:10b6:208:316::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 08:56:40 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Thu, 13 Nov 2025
 08:56:40 +0000
Date: Thu, 13 Nov 2025 16:54:33 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Message-ID: <aRWcyf0TOQMEO77Y@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094358.4607-1-yan.y.zhao@intel.com>
 <0929fe0f36d8116142155cb2c983fd4c4ae55478.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0929fe0f36d8116142155cb2c983fd4c4ae55478.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL1PR11MB5288:EE_
X-MS-Office365-Filtering-Correlation-Id: 80bcc8df-8f33-4851-f925-08de22928f42
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?NxZw0qsRskMVR1vFU0qM2Vkbu8oA9VyP7PY5QTEOhS/dgAXy50fxKLebjT?=
 =?iso-8859-1?Q?WXfQZRvbD+1ryZg5Id9cYTua6MvfVatRb9awjh/F6ExVv3eKgYaXZEIqDT?=
 =?iso-8859-1?Q?q97wtpFig5kHH+CF56sioMUoi7WZSN+wcAi39YF/TxMC50VrUiQnACLw37?=
 =?iso-8859-1?Q?Lzu0qg4TlMS/Arom5v6JQFMZ+ezNiLJ8vl49uSC245yJdu9O5dsBI0Wl1a?=
 =?iso-8859-1?Q?Jvyj6CwHf8k0UsX2cTayRcY1PJrxj51D9ViOKwl2AdlmZj9JiqHwYgStG1?=
 =?iso-8859-1?Q?1VwkOGIIpN7c5rPK+t7N8mjPC6FZfI94JoERfOr/oNr8Vvp8hO/tukJ5Oe?=
 =?iso-8859-1?Q?tR8kKJNS1qx4lyXfEA8ZQi8WDiXS7UZSQwDhSOiUqtyGGWPodQ2JeksV9p?=
 =?iso-8859-1?Q?UcsdWFVfCVF6A9Grz2s/rijpNHqoGHiGwsfnSEw3LuNW1j3C8romr+t7Lm?=
 =?iso-8859-1?Q?03+deXmctCxSNPNbVU1p4wv+8d9cCRSNDICAhpWrZGZ7WjM4POP9wFETIx?=
 =?iso-8859-1?Q?DRuTaVMoukZqGBqEvzmseaYyUvtkyz1zvgxo0L5NgFjsSdhUmYaniNDGGx?=
 =?iso-8859-1?Q?GjnE8SkBUpW5WRyw7a4nCfaYqWgSYCrdo1i51fyEsj0JPLOINKa2iWcL1y?=
 =?iso-8859-1?Q?1kP48F5w9m3Kgz2ElQovLG/UuthDuQe83KFFZCNbMo4vmsmSVUaMOLxff8?=
 =?iso-8859-1?Q?9qU216omtt7b21ekMHWdozcqJaLbY9uz2hME5/l/AG6PfFWDpflYCpC0fq?=
 =?iso-8859-1?Q?wxzq+OgSJkcyIcVdG7pUC0zDWlX8/+Rb65WUTkCNgEvkH8UWqJHalteWxN?=
 =?iso-8859-1?Q?3Cvf9RAujVctWOmTeaD/6BKXxJrgRdBO8UclrdZC8/R6IDpm3bmQHR4bII?=
 =?iso-8859-1?Q?7OPZzuVvUwfS8qVtkrveqTYALVatfQJ9LLe6X7G975jZUvKDJaxPvb/jyx?=
 =?iso-8859-1?Q?wP3LQcQboHoVvlwZ4akh1rOYeM+u95gznOHKZwhqyoj2WpnGxDJ8pvBQ4V?=
 =?iso-8859-1?Q?hffUnqQNT8EENXK1nOQYiSsS0KdIIZduLZzMVRUCbG2Vmr0QzW4bcyULg5?=
 =?iso-8859-1?Q?Dbr4r57kWSEDByvX6EPB+GxFWFIy57JKN98QOt7iCTc5HZ7idEh2D1H14q?=
 =?iso-8859-1?Q?gTua/+uU7tSRipt6W7En+IM5qzvpnLQzfoUIjUhOTgRdN9sgEUtiI9O/P8?=
 =?iso-8859-1?Q?7FJcJ4kzvtrNPjLY7GI1zHh/GgfpWJjgjc/IT0acV7A/26dN/uCDkax3eF?=
 =?iso-8859-1?Q?XVWIH/Mpy9jr86ZjVBzIJQ77qDdbTpoa5R7t43lz85Q6qispI0Y0UGAFri?=
 =?iso-8859-1?Q?9pgB39gH7RiHf80o7q8mujgsxwFCXFBDmMrWpv9HgAIvTVOVzM29l2+P0r?=
 =?iso-8859-1?Q?9UQVAZYa93jdLZPmEzUspRx6tPJD9Zj+a2kHMIsnDs3qqzXUGEq1fhbm6D?=
 =?iso-8859-1?Q?CS6x5jiQ52zFhoITZvb7vn38Kmxb4GZWA79EpvrzZVfCD7gh0Uu5YT42t7?=
 =?iso-8859-1?Q?11VnNyp43dSvrarn6hTRD6?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?6tJL0SXXYMzuy2WW0IPgbZM9V5grMCWAmuenUN8JGD1hTRsKMFHZRYkOeP?=
 =?iso-8859-1?Q?LHTxIomjUvg1EpBPtntjuZh4nYxQTj1bwDRY99zPeuwmerkzJIyt5Ybb0Q?=
 =?iso-8859-1?Q?b8CBJ68reiBp+/PYumqdw/NG25wweqGbpWxuXZh/nDzQj85Suzm4jwwcbJ?=
 =?iso-8859-1?Q?TxEq6EHkHB8R8TwELzKCJLkIrNTbd4LwIs4yVwat8CGNAdIyTedvXTlPcI?=
 =?iso-8859-1?Q?QqwNSnibcsVe25W9QWzb9jev5nt620p3d8E+TpckteHwFAuIjQXubTr8M4?=
 =?iso-8859-1?Q?pPiH8fHSuro0hTeRX7v1cYxVh+J9r6fkAf7S63Y3RkgvwqARcG109vSYy2?=
 =?iso-8859-1?Q?Hf7CTSAoaeuRtl5oo1TYx9JfLjlvXBP9ggQBJrA/nozV0G/1UU6YHvcBHK?=
 =?iso-8859-1?Q?SvyVFnRO/anTi5FDZibX9YeylOC1/XhpiUQtTAs0OkcuV97Lgfm1qZDKJk?=
 =?iso-8859-1?Q?OaiySBSDp0cy7pJEuaZPfSYvx46zujFtnmJCdBtU+4eLw67T6Wh1OROOwf?=
 =?iso-8859-1?Q?Y+e6XeOVPx2FNr7gT6gQYv/Dmz4Y3hQxO5aHP9rx6VdrLvR6dGbC4ZFwuv?=
 =?iso-8859-1?Q?RE3cB6TBHtfTB2Ve6zZtwT+veF7f79tyoqkKiBVbkOgSbaWHtz9KyVTvmB?=
 =?iso-8859-1?Q?p2nr37a3mmxsgjzVF4GeTnYWOIQKdXtAPtSfi+vziEX22CVZrV5D1m58NS?=
 =?iso-8859-1?Q?ZdZ8WfMIFE9uMgjKyQ4g8HfDp1a4QqNeQqybWne+yj6LnnkmNabt1F+TsU?=
 =?iso-8859-1?Q?s5UTCfO2pfmzjRvCFzuZ6XfBJIUP6gKUGlhPBYLZ8um2P6LHpibtRVaxqP?=
 =?iso-8859-1?Q?Np3tB75vWaR6vgJR6OeZxk+W6LAsg+j866L7syzAbf4jKdJxNAM5OahlG8?=
 =?iso-8859-1?Q?0s8nhRU7o+tSFdGPHWI62E1ssWZV9t8vCwDg+4uLZKxwvNONNie4CcBlIc?=
 =?iso-8859-1?Q?+bPkLLpUI5AADU4adBv2RcEN89meLRRy8fXTGosL1DHnt0LMjTfLv8nEJq?=
 =?iso-8859-1?Q?p2GPtDVCFYRj01sTP9lIB8N7SWYgzyiUCmw7If9yXfEFatSuLkSGmfOdo2?=
 =?iso-8859-1?Q?M7hrIxKUAQ6YKKcm+c1jAORoeF39WGJXOnFxAfCOkyqOuil1aHpQnk48ue?=
 =?iso-8859-1?Q?KFHlp69rtUZJtpA/PLVTixVFXB2BwvwBTL8y/Aeeguas0Dt+6hH3jn0c40?=
 =?iso-8859-1?Q?IFdDYUyL6VFPqFOzCRLsPk2/1pm1rtFYf3u9PRAKQC2Whn+TEAgh4JJJii?=
 =?iso-8859-1?Q?n33efJuA00hLdjg1SKmR5E6197tFzKOQRncHq+znMQ5IflgyplwRbV3nMN?=
 =?iso-8859-1?Q?IwLJCKXc2gnWEpEcjBo3ci4cXAS37C6CzyRzXA8Bu+ZWi44akh24TTEP1s?=
 =?iso-8859-1?Q?mxFCJBjxBwgM3MGKObJ5bEZvqulV2VmpGpUPIA4DIzj1OpWh4XmK6Phhcd?=
 =?iso-8859-1?Q?Gb0pHxOR8wTP6Bucs5tdQi33o80GAAg8Tn9SsijiQSfWoYSRqwSZQG+1Tc?=
 =?iso-8859-1?Q?Ct1UuBPcd5fXfXe0fovvtV8ZwfmaczKGLEanqfvDKHVHJfSHL4NHGkDqWj?=
 =?iso-8859-1?Q?hkhI2NiTxufAtQR4/5p1JkUKrXZC3tcNCY62G0WmjUyxtJ7d4mXx+nmzpR?=
 =?iso-8859-1?Q?VhOrbJNhC9RW0QY1LiPGGfWFuvMu04wg01?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 80bcc8df-8f33-4851-f925-08de22928f42
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 08:56:39.9383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ZPy4xHqXBdZc1O/0yThpvQw4k4lgLoFlMIZ6HHw/QIwfXP67l31JMLkSqVoD3W+2aQGaffQbh4ujLZ4eGfsPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5288
X-OriginatorOrg: intel.com

On Tue, Nov 11, 2025 at 06:42:55PM +0800, Huang, Kai wrote:
> On Thu, 2025-08-07 at 17:43 +0800, Yan Zhao wrote:
> >  static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> >  					 struct kvm_mmu_page *root,
> >  					 gfn_t start, gfn_t end,
> > -					 int target_level, bool shared)
> > +					 int target_level, bool shared,
> > +					 bool only_cross_bounday, bool *flush)
> >  {
> >  	struct kvm_mmu_page *sp = NULL;
> >  	struct tdp_iter iter;
> > @@ -1589,6 +1596,13 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> >  	 * level into one lower level. For example, if we encounter a 1GB page
> >  	 * we split it into 512 2MB pages.
> >  	 *
> > +	 * When only_cross_bounday is true, just split huge pages above the
> > +	 * target level into one lower level if the huge pages cross the start
> > +	 * or end boundary.
> > +	 *
> > +	 * No need to update @flush for !only_cross_bounday cases, which rely
> > +	 * on the callers to do the TLB flush in the end.
> > +	 *
> 
> s/only_cross_bounday/only_cross_boundary
> 
> From tdp_mmu_split_huge_pages_root()'s perspective, it's quite odd to only
> update 'flush' when 'only_cross_bounday' is true, because
> 'only_cross_bounday' can only results in less splitting.
I have to say it's a reasonable point.

> I understand this is because splitting S-EPT mapping needs flush (at least
> before non-block DEMOTE is implemented?).  Would it better to also let the
Actually the flush is only required for !TDX cases.

For TDX, either the flush has been performed internally within
tdx_sept_split_private_spt() or the flush is not required for future non-block
DEMOTE. So, the flush in KVM core on the mirror root may be skipped as a future
optimization for TDX if necessary.

> caller to decide whether TLB flush is needed?  E.g., we can make
> tdp_mmu_split_huge_pages_root() return whether any split has been done or
> not.  I think this should also work?
Do you mean just skipping the changes in the below "Hunk 1"?

Since tdp_mmu_split_huge_pages_root() originally did not do flush by itself,
which relied on the end callers (i.e.,kvm_mmu_slot_apply_flags(),
kvm_clear_dirty_log_protect(), and kvm_get_dirty_log_protect()) to do the flush
unconditionally, tdp_mmu_split_huge_pages_root() previously did not return
whether any split has been done or not.

So, if we want callers of kvm_split_cross_boundary_leafs() to do flush only
after splitting occurs, we have to return whether flush is required.

Then, in this patch, seems only the changes in "Hunk 1" can be dropped.

Hunk 1
-------------------------------
        for_each_tdp_pte_min_level(iter, kvm, root, target_level + 1, start, end) {
 retry:
-               if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
+               if (tdp_mmu_iter_cond_resched(kvm, &iter, *flush, shared)) {
+                       if (only_cross_bounday)
+                               *flush = false;
                        continue;
+               }

                if (!is_shadow_present_pte(iter.old_spte) || !is_large_pte(iter.old_spte))
                        continue;

Hunk 2 
-------------------------------
+               if (only_cross_bounday &&
+                   !iter_cross_boundary(&iter, start, end))
+                       continue;
+
                if (!sp) {
                        rcu_read_unlock();

Hunk 3 
-------------------------------
@@ -1637,6 +1658,8 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
                        goto retry;

                sp = NULL;
+               if (only_cross_bounday)
+                       *flush = true;
        }


Do you think dropping of "Hunk 1" is worthwhile?
Would it be less odd if I make the following change?

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9f479832a981..7bc1d1a5f3ce 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1589,6 +1589,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 {
        struct kvm_mmu_page *sp = NULL;
        struct tdp_iter iter;
+       bool caller_unconditional_flush = !only_cross_bounday;

        rcu_read_lock();

@@ -1613,7 +1614,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
        for_each_tdp_pte_min_level(iter, kvm, root, target_level + 1, start, end) {
 retry:
                if (tdp_mmu_iter_cond_resched(kvm, &iter, *flush, shared)) {
-                       if (only_cross_bounday)
+                       if (!caller_unconditional_flush)
                                *flush = false;
                        continue;
                }
@@ -1659,7 +1660,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
                        goto retry;

                sp = NULL;
-               if (only_cross_bounday)
+               if (!caller_unconditional_flush)
                        *flush = true;
        }



