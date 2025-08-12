Return-Path: <kvm+bounces-54499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 147A9B21E7B
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 08:38:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18A6E5054F8
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 06:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BB102D4804;
	Tue, 12 Aug 2025 06:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QtnofB1c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4093270545;
	Tue, 12 Aug 2025 06:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754980715; cv=fail; b=b+u1DYG/m0mSlbratU8o9/KDAp4G1JaWhNHvfjrqLEwayIzyHVB9tN4rqwSWRWXXvbzSlIa4m+ApXJ6oOO9pWBpkPemgmrh2WUBxiOwfQRyixZpP3euVPipTiQrNISO4uLaw4FZbY+vGt0sL4PVcJCpQU5KYnh7+kTrze1Is+6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754980715; c=relaxed/simple;
	bh=AQgmxvmezAzwvm6qUNKsU9tJHZ5tXC+bnhsGgxSKHoQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=W7KsLaSYX8zCNTst6M8wJyVJKXkOh1pOD9c9lT32GHN5ENhEsl0gsoJ8Q0LjxOSMzg8ccZTSuF0V7EvfkDOX9pdo849MvInUjl5KkrqQBLL4/I4aaslYGkQehqJaFkIcBfHgEyHHBH3tv4MxFvpJZ0IXNFkR89mwctlEt/MirT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QtnofB1c; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754980714; x=1786516714;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=AQgmxvmezAzwvm6qUNKsU9tJHZ5tXC+bnhsGgxSKHoQ=;
  b=QtnofB1clUEZDutkE5MwSFn+YAo+3g6JkmcJDnBNmdy2pJwmP/6aI6D/
   JmEDuFfcYfHQmBlniUqs9lmmzCPaym+sI6qEXitvWzcj43OG0d2LbsKuv
   QldIKEvooXFE8VL1hRtpBIFiQFd1WhJvOKOCNZj4k7l8rJTX9M59qnl2m
   sI6JjgTOM4TKQ+gVxFEH3w6sz2CLM51uUNv9acYuHtNGtrMQQYIAyPZVm
   09s8E4DXIL6wGKSJz9q8eVELKg1TJddHZvUDhUBacSdsRlgjs2uwI0axZ
   /b0la+uipDvcrNlSPZJSAf9GHRxgT9zkLH20OhPRWX0DvyH+gftlKsKHH
   g==;
X-CSE-ConnectionGUID: PgnZignGRhii4XjzwcDbiQ==
X-CSE-MsgGUID: nqhitWGPTein70a5a1rcBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57147809"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57147809"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 23:38:34 -0700
X-CSE-ConnectionGUID: Hk3lZ3PuTnyi1J2py5IMow==
X-CSE-MsgGUID: 8nJx97NYQfy2kKcsG+tyMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165747225"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 23:38:33 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 23:38:32 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 11 Aug 2025 23:38:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.71) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 23:38:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jx2PteBc0wWYi/20GiA9dCaCcbde5UqUF9V5vX6VfBlrk/88Y4sj87g9UE3Nbc0hoO1kDsjKREoxvTULhStH7/pltsKfTf8EgJdoDRX3bp/MidN2hEUNiiYVZKwgL4nvlb7sQYcOWBn4nKZv5IzKpmWLvF5l1Y3DN8ZMBQSv3q9dY9KRPwujg8Wrc+0rDaen8YYspF01ZDIQdNCWM3ZhNiAlzLF832ASrUtvLNWV96zFUCnHSh2ncQKxf/S7m/NeUnvBQkARsAjRVjCWv2Q1iqEChVoh4fI5t9HtDZoz5qLU1F2a1plZtXuUgvbQsN2xvjM09Fb9VmEOHSxOe84jdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ls+z8sebxz+vMDC/mpb8hayIO01I3/qRnrQkxdh30f0=;
 b=h7/clwNTDMbLkLpSmQ/khg/9W4cBcpgyjQb00fogbPonFxm3zXXu5y74FLKWyq6e27GmiaN3PYMNpzoXa1r9sLLVy/UpPkQbG05QiLXJM8Tf7hAModEoL3kMT+jBt0CCecZUQl/nQX08q9Y06dF0KXf/HfEvx/m1AnqmJYdsRnSXjowdYTBLAm3VQ0rIVi5YPiob8S976xCpwxLCcPSOlib3gSfdmv+NsVUnVpRr/J3ZO2gNUvU1GKDPkkltJFcKY1Su3ouDBrTJ1Cxod0PRtlDbPwn7uNNX7F8oS7h9u4GXRwBmAAqIpvwe2WXCW/vPBnA3kKq8Q6vJO2thKSBykw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB5175.namprd11.prod.outlook.com (2603:10b6:510:3d::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.22; Tue, 12 Aug 2025 06:38:25 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9009.021; Tue, 12 Aug 2025
 06:38:25 +0000
Date: Tue, 12 Aug 2025 14:37:40 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sagi Shahar <sagis@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vannapurve@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 18/23] x86/virt/tdx: Do not perform cache flushes
 unless CLFLUSH_BEFORE_ALLOC is set
Message-ID: <aJrhNFmLFBOP2TVK@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094516.4705-1-yan.y.zhao@intel.com>
 <CAAhR5DEZZfX0=9QwBrXhC+1fp1Z0w4Xbb3mXcn0OuW+45tsLwA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhR5DEZZfX0=9QwBrXhC+1fp1Z0w4Xbb3mXcn0OuW+45tsLwA@mail.gmail.com>
X-ClientProxiedBy: SI2PR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:4:197::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB5175:EE_
X-MS-Office365-Filtering-Correlation-Id: fd7e792d-6607-456d-6030-08ddd96ad6b8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cC9QVEgycjdoUjZMcktsV1R1blhDVUpiQ3pBc2ltWDJ6MUc1VzFkVHBMT2dl?=
 =?utf-8?B?ZFVoRDZ1TFZ1UUR4Y1Y1aHhzRHlZcllaMjh2V2lTME5ZVXNxOExLZlJRSkxa?=
 =?utf-8?B?emUrZjc5eXgvc2V0ejRZb2NsblpYc2tBUnpMemV1MEpmbnpUV2I3QTdjckVk?=
 =?utf-8?B?Rk51M0IxZUdDc3llbHZPR2dETHVSeXQ3UDlSRGxEcXJzNHR4RmZVYVUvZjla?=
 =?utf-8?B?QjFHVmxWSXF6N1lTb3I2aHFpbFBFSnptV29FSEhNTHd3eXlUQnpJN045K2Ry?=
 =?utf-8?B?SWRyOER0VitoaHM5UjlXc0daNUZYNHVlY1NyV2QxdVNPREVmaUV1dmtmWnIy?=
 =?utf-8?B?VDhINkNjVTk4WHN3NjZrNW9EMjN6SnlRU3RlcTJ6SS9WWGpzRjlRWlpoWTU0?=
 =?utf-8?B?YzZxcEx4WEVoWVZiYzNDcVpSaFRxNHk5UXUwVUtkSjNWVWRCbEdUZHArNVhB?=
 =?utf-8?B?T2lTMlZyYWRjQ2gyUXFVajZBMk9lYkVNRWh2L0Z6ejBRZWVhWC8zcnBuTGxH?=
 =?utf-8?B?OVpYUFU0MWp2WEdkb05ZNmM2b0lHQjN4YlBidDZYeVU4dGtCWUpraVoyN2pR?=
 =?utf-8?B?ZFNxclNqVE5yTURQQjNTTitVdzN1ZytPaTBQYmhDYzE5VmplVmxKeHNtaFh5?=
 =?utf-8?B?NWw5ZlZqcWV5cktPbGVHWTVlQ05WT3JJeW1IdWdEYzlJbnRjMDZVQjFOczc5?=
 =?utf-8?B?US9wMzJoc21DeFkzZGp1RGJoR3BmV1c5UkpyU2MvQWZDTnZwQ2I5bm9MOWk5?=
 =?utf-8?B?TU9VM0tTci95eEtTQlZGd21aUHFjYXFPQkFEYlZEcHJHcjVlTk9nYlc0STJO?=
 =?utf-8?B?M2NCdWdWTllFclhHanF6UUtLWUkybjg1dHNUR25zSmRDd1ZJYkhObVFqUFdD?=
 =?utf-8?B?cmwrVTdnUFVYanYwREFvYjRLWnAwOGh0MExjZDVZalZJYms4SjdlTDV6Nitw?=
 =?utf-8?B?TDZxN2RxUXNvTkM2TzlGamdtKzZEVkVnZ0s4WHVPOEhHZTJxb3BFOGVLYW1B?=
 =?utf-8?B?TkQwbXlyc04wTDJBV2MyeC9KdjM2Mi9XeWtTdkRndlRCZUN4VUU1dWgxRGVO?=
 =?utf-8?B?ODV2QXlBZ3A4My8rSTFObGJwdGprR016Nk5oS2pvR3FGZkg1RTZvNzcwTm9N?=
 =?utf-8?B?NzQzTk9wZGVkZHd0SFAxMlpJRE82ZnlkOXBnR2FJdWQxbXprcyt2VEFVWlY0?=
 =?utf-8?B?SUNlUHZuSE9RbTVoWGpzZHBXWU1qenFUcXp1UG9Za0R5UzhEWnhYN1ZoMGsv?=
 =?utf-8?B?b1FLcFJFazNyaTk0Lzgxdy8zQzJYc0kwdWk1bEpDTk9ueHZ2cFh4bm5GakJi?=
 =?utf-8?B?MkxRcVhMQjN6ZWQ3dlc3SE5QNU4rL0xnT3B1WHlhc0hFTG1sOGNmR0FsTDBY?=
 =?utf-8?B?dXZlNHZHMWR0bXVoVm5JUnV5M0paK0JTR2ZZODlFbDNOQkVsOVRLdlI1QTRh?=
 =?utf-8?B?N2xZMWRDRGZtb2dMQm1lU0xGQ2w2bUhKRXZTZHVIYlVRa1ErV0EzeU9rQm9j?=
 =?utf-8?B?bGl1VURhL2hHQS82a0x1SDEyVGFZWUhDZkFQbmRybWNUcFRNY29ybWNsTzRM?=
 =?utf-8?B?TzNKdThwbXhRdlpTUGVKU2lmSmhYbng1WlpkcDNERXBYVmpqQ2M1N1czUmJY?=
 =?utf-8?B?VkEzNXBlRk5KTWYrd0t2U2xHVmQ2cVh2b2hsUWttcXQ5MDk1dVlMLzhJYnNp?=
 =?utf-8?B?ZXl5Ylc2M3luY2o3ZVgrTlEvWkJINjQrdGVsZ0svZXZIYlJ2ejk2bWxzdVFU?=
 =?utf-8?B?dTZtbWorRm00L2xNVVlmRStPbWZLOFVPTSt2RXUrUzFYVkZmTm13YU1OcDRh?=
 =?utf-8?B?VUNZUUZramZ1Q1dsUkhVSGg1dDUwR3pOMGFEemFleHF2bUtiQ0VtbXh5VHMw?=
 =?utf-8?B?YzBnekUrNjM0YkZsbmtDOEUyTnBCa0E0TGFMazBBQWxKT2Jqang0RjFuZW9u?=
 =?utf-8?Q?Q3viSzCYdV0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUpVMGpUR3JuNy83Q01hQ0hJdGp6WnBaWmowZktxWUJkTTFhdmJYYzVvMk5u?=
 =?utf-8?B?ZkNvM01PSVNjQ00xSU9YeHZkTkZRd0Nuc3c0OXJPZGU0Yk52T3Z3bnF3azZH?=
 =?utf-8?B?VjJ1YUdMRjBzeS9qMjhhWVBFRStyMGVCVEZUZyt4VlI3SzQyUTRsSnN0K1Z6?=
 =?utf-8?B?TmFpa1FJZjJZbEhPelRXOHdhMEVPQkFMUzZ0d0NoelJ1NkVGNXNpVCsyaURa?=
 =?utf-8?B?QWZtTVdKN1BpTkdXaHp0SDl5b0hYSDdhTFllQ092RnlKZDAwT2l5RldlL1RR?=
 =?utf-8?B?MDYzS01xNUVCSzhJUnJKRi9FUTNVMTkrdnh4OUNqYituN2o0YTRqSU0xb2Np?=
 =?utf-8?B?anFOa2lXN3NuZEtJSnFXczFHYmRkdldTWTRJN2RnVFBxbFJteUREcmZHK0tZ?=
 =?utf-8?B?ZC96dkhqcVloMTNuQ1U1bVFER2R6Q1FGMWdYT3E4Y2xWWUNEYVBqamdEalg1?=
 =?utf-8?B?eHRqUHpsWHhwZWU5K3AxZGhVZms4OWc0dXFSazJlTzNHT081T2lFK1dUQ04z?=
 =?utf-8?B?K24zNWhzZzg0R2J0RDhLWS85TFBob0RVZXBEcUtmc3hiR0s3ampxSHlIeSty?=
 =?utf-8?B?ajEzalJMellTVjc2MGFZZjlBc00rckNWbnZwQWxvSXZRd25PcFNNZkp4Z3F0?=
 =?utf-8?B?d2VSbHRYcXJUNWJWY083QXRyTm5telRUczBKWmxpU0VWMTFCRkZXL3pLazdH?=
 =?utf-8?B?K3prK2xhN2VSN2JKU2xPRy9MRklXREViVlExYUdoSWJ6TE5IeW81WkNpRktr?=
 =?utf-8?B?dG9xWDJyek00ZVQ2a0g2bm9TRER0WldUS3QyRzBORklPSS81aFR0MTZlcXNV?=
 =?utf-8?B?QnlQbW5sRTRyNmljc3VIWkZpV0ZmTDUyRGJqOEhjNWRwTExnaHI5SUp6djNR?=
 =?utf-8?B?ODM1Y0dOWnkxSFVMTlQ3b0Zjc2NVRGlDWHBtRzl1VHlsMFlVZC9kakVHTlhK?=
 =?utf-8?B?YU01RmZlMHk3VnJxaDQzWWNrVEhjdU1WSW5saDNQSkl4VEpLWW5Ic2F1N1ho?=
 =?utf-8?B?SU5YZDI3bXhqK2dXWlRRcXNLamQxTUErem5tNTAvUzRrR0Fkd2lnMlZzVmNs?=
 =?utf-8?B?aXVUQ0VrSXFiL1VLZDNYOTMrZTZWM2ZGWkY2RWt5dXJsRHlSRkIrRS9YWW90?=
 =?utf-8?B?WXZRUWdvbHkrWDRwTjJRaEwvWThhYTd3YkRmRCt4VGh2TjBFL2o1M1UxOXkr?=
 =?utf-8?B?Z0VBU1FkQ2dCM2pUbFNMamlxWUdiSlplZDg4ODU5aFNuQ3lmTlJhQjIxcVdh?=
 =?utf-8?B?NEd1Rnl4LzhJcWQ4Ni95cWFqVXBscG1tc3BHR09wODRHejhiOFNwUDMyTFY2?=
 =?utf-8?B?RkhwRTArZlNSYjB2NDFTZ1IrL3Q4NGFXUmpibmpSMmFjdHAxR1lIbXhTRTNh?=
 =?utf-8?B?RlJMT2NRekpsd29IZXNIdXVKUWZFUXhHa1dFZ2tpYlYyL2cwNnBnYzVtOWFL?=
 =?utf-8?B?ZmZwSEY2eEZ1QWhzOVpEYXRuZS9nRXJ5ck0rYkJIUzMyUEJYRDdQbkpaY0ov?=
 =?utf-8?B?M3ZjQllaRjdkZG51cXVxL0NWN0JyZ1VZM0FXVkFidHRRdklXSVZDVkRJUkti?=
 =?utf-8?B?QnZDTUVrOGVGT2JoUmpxa3NYKzB4MHk3WHg1U0hZelMvOVBSWFpDanRYSnlC?=
 =?utf-8?B?Zk8wUVozMXBiTDhlU3R2YVBuK3RDMmdDM25LMnVoV0dqRS90NHd4c3owNHMy?=
 =?utf-8?B?NjV3ak5jRWQxSjNIUURpbzJ3UHlxNjE5TWR2UWFKS3haTzIvNG1TdDFOVTFO?=
 =?utf-8?B?SFV5Tk9MRXdWM0VncnRlb0ZMWDY3QTFOL1g2SlBZMTVxZ09FSnp3Vmk3ZGxS?=
 =?utf-8?B?cmZWQklia0RjVHU1dEczQnZKMDVFdG1tWTZXdVJyRnRSTEVIbkZjSlZhOXVi?=
 =?utf-8?B?U1JaYkFTWUFJL0R1cXJ1dlVHUXNDZWlKTFVZdmkyUkUyREZsUHdVbnZrMW12?=
 =?utf-8?B?Z2Nwd3lFN2Y4dWN4UDl5YTJSbUtvL1NsaGVxSnBsK0VUSDcrSlpWdURPd1dT?=
 =?utf-8?B?b3pqL3l5Ui9VWWdMQmpLR0Zac3ZyKzhjQXRMNHNBK0RZb2MxeEhzMEwvVURt?=
 =?utf-8?B?QSs2bUxZWUFyNXU3QWpGZzF6NXVKeFV6M3gvdGhRN3Arc3A1TmMvSHZZWjBN?=
 =?utf-8?Q?4goJ2ISEngGNYVpDkAALpxUSA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fd7e792d-6607-456d-6030-08ddd96ad6b8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 06:38:25.0654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zpfhLBei++bvQqiyKd/NBGPI4Py7LdWPKpzkjNBn8MpzFCYMbOSWC24wik3i29b45ZqRNpTXxcDmvsglQ2Hc/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5175
X-OriginatorOrg: intel.com

On Mon, Aug 11, 2025 at 04:10:41PM -0500, Sagi Shahar wrote:
> On Thu, Aug 7, 2025 at 4:47 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >
> > The TDX module enumerates with a TDX_FEATURES0 bit if an explicit cache
> > flush is necessary when switching KeyID for a page, like before
> > handing the page over to a TD.
> >
> > Currently, none of the TDX-capable platforms have this bit enabled.
> >
> > Moreover, cache flushing with TDH.PHYMEM.PAGE.WBINVD fails if
> > Dynamic PAMT is active and the target page is not 4k. The SEAMCALL only
> > supports 4k pages and will fail if there is no PAMT_4K for the HPA.
I actually couldn't observe this failure in my side with DPAMT + hugepage
(without shutdown optimization).

> > Avoid performing these cache flushes unless the CLFLUSH_BEFORE_ALLOC bit
> > of TDX_FEATURES0 is set.
> >
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> > RFC v2:
> > - Pulled from
> >   git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-huge.
> > - Rebased on top of TDX huge page RFC v2 (Yan)
> > ---
> >  arch/x86/include/asm/tdx.h  |  1 +
> >  arch/x86/virt/vmx/tdx/tdx.c | 19 +++++++++++++------
> >  2 files changed, 14 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> > index f1bd74348b34..c058a82d4a97 100644
> > --- a/arch/x86/include/asm/tdx.h
> > +++ b/arch/x86/include/asm/tdx.h
> > @@ -15,6 +15,7 @@
> >
> >  /* Bit definitions of TDX_FEATURES0 metadata field */
> >  #define TDX_FEATURES0_NO_RBP_MOD               BIT_ULL(18)
> > +#define TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC     BIT_ULL(23)
> >  #define TDX_FEATURES0_DYNAMIC_PAMT             BIT_ULL(36)
> >
> >  #ifndef __ASSEMBLER__
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index 9ed585bde062..b7a0ee0f4a50 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -1648,14 +1648,13 @@ static inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
> >         return page_to_phys(td->tdvpr_page);
> >  }
> >
> > -/*
> > - * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
> > - * a CLFLUSH of pages is required before handing them to the TDX module.
> > - * Be conservative and make the code simpler by doing the CLFLUSH
> > - * unconditionally.
> > - */
> >  static void tdx_clflush_page(struct page *page)
> >  {
> > +       u64 tdx_features0 = tdx_sysinfo.features.tdx_features0;
> > +
> > +       if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
> > +               return;
> 
> Isn't the logic here and below reversed? If
> TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC bit is set, we want to perform the
> clflush()
Yes, I think so.

As my test machine has boot_cpu_has_bug(X86_BUG_TDX_PW_MCE) returning true, I
thought it was right to perform clflush() and overlooked this logical error.

> >         clflush_cache_range(page_to_virt(page), PAGE_SIZE);
> >  }
> >
> > @@ -2030,8 +2029,12 @@ EXPORT_SYMBOL_GPL(tdh_phymem_cache_wb);
> >
> >  u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
> >  {
> > +       u64 tdx_features0 = tdx_sysinfo.features.tdx_features0;
> >         struct tdx_module_args args = {};
> >
> > +       if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
> > +               return 0;
> > +
> >         args.rcx = mk_keyed_paddr(tdx_global_keyid, td->tdr_page);
> >
> >         return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
> > @@ -2041,10 +2044,14 @@ EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
> >  u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct folio *folio,
> >                                 unsigned long start_idx, unsigned long npages)
> >  {
> > +       u64 tdx_features0 = tdx_sysinfo.features.tdx_features0;
> >         struct page *start = folio_page(folio, start_idx);
> >         struct tdx_module_args args = {};
> >         u64 err;
> >
> > +       if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
> > +               return 0;
> > +
> >         if (start_idx + npages > folio_nr_pages(folio))
> >                 return TDX_OPERAND_INVALID;
> >
> > --
> > 2.43.2
> >
> >
> 

