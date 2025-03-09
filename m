Return-Path: <kvm+bounces-40531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17E46A588C9
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 23:06:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8263C188CDA5
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 22:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A7C021D3FC;
	Sun,  9 Mar 2025 22:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fB/GSNJJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B463715B543;
	Sun,  9 Mar 2025 22:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741557997; cv=fail; b=YKR5entKUph9cmdLk8ZObBV9Is+3Z3Eq3Q17yIw9orNiumL2vn+AAnKvM8+MzrMt6LBW1wDZkHPlLB8/Rn5d+13WVquoJ0RGv1wryF5FHjBUPw2nAqF/PnUyCesvTRAvsKxScuNdwxWb32NWkD774Fo94e7lkWSQgP1QDuyT0KE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741557997; c=relaxed/simple;
	bh=DlWA4zG1tsTGG1JduOjcQXEyfyIaumZntdCeSwc5clw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QDzTqFHucGHi3eiJC5zwHWMS8whYgc8kqBkuU+p/965LzEbBn/kylXaTxx4aDNr4yoFLNPhG4IRjIHmgIOSqzaYbriHUnsuH7aD+2XjIz7upi3W3A8ipo7gVL9GnicbAO08P8mOxMq+gmPzGFgS7v79wapWU4boGlBH4xoLHmBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fB/GSNJJ; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741557996; x=1773093996;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DlWA4zG1tsTGG1JduOjcQXEyfyIaumZntdCeSwc5clw=;
  b=fB/GSNJJW4TS3w7lCBis1qM13Ycj+Z7gPkbqg94s0lBns5ntNsHUCs3d
   1Xlzl87Pwd05KbqDXI9gOeDG2dQSSmWajKBWWbp2W0AkoVHdrjGkbXihL
   Gh8c2vFqxAWupK7Xo2dXNwFNNZwjeAWz5OSrGUuq0gKjFE7svw9u60dQ5
   vfKwwYrS756c79uN5KQeXVs6gzXVWPfmuAe7rWHhys1eXLs0H+QNa4raO
   rBeZ673C8BSnFParqfLGgLRp9vJi0VOeaxsel6AhrLnqs0lay5Ph0NdMX
   por662c/boYJOW/NSGBSTWINyL2Rg2/4loLLE+fJXfjO8Hl7f/d3NTzJn
   g==;
X-CSE-ConnectionGUID: D7jshP1SRGuDPMqN/d/pJg==
X-CSE-MsgGUID: /qA0Spe0TKuFVyjiNipsRQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="42453356"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="42453356"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 15:06:35 -0700
X-CSE-ConnectionGUID: IaSIax+5RaygUw8sZ6QSJQ==
X-CSE-MsgGUID: +Xta/c+fRBiJskdS8ESoDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="124902407"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 15:06:35 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Sun, 9 Mar 2025 15:06:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 9 Mar 2025 15:06:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 9 Mar 2025 15:06:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=soxFLMHEMEJfx0Fe2ARsCL4Oqcbuj1XgFCn8rO+jlqCBo36Y+8AkQbCynelCJ7ljyhAEdH+UfoYzAU8NZJOJG9fkYPf7u4wpvMLt08cUUX9m6UGWsYenNVDQySrSkUh1vmQg0rW4BVhQWG9plzcWIL2Nu0oxo3au2b0ilDnlKlcnimfudQpxxchh0O2PnT5zVY/dQvidOa9vvN8pBAYh0wm5bulVhIBmTh1668kuATIiN743vhAxoVlqbqZlrp2lSxoebweMcnpuRXYX0/Zql+0qEJacQkPlJd9IexGYG4YT1tG3QJO+nr34oE2QLzrbSzc4bQGD7ZLdQ0H6dC1+Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6BvPVNXgtb5yLgaIgfb+38GaekQleICiQ0AhHSaoWOc=;
 b=gvECuhnsLjOW0cNbcFpye3sTifrYYtIX7MsLaT1Yewp2v3hMWVdLiShtoc9JnZ5xixTCIUSOtHmf0dO4Tc77rx7qzi0pqxkYAQHmg8lwQmIWKGU25eT09ba17JNCFPzIvQAFwbNuhwChyXKX4ZCdySUzqqgBxgYP0+ksxRsuavqNbGagc00g5FX019MwB0Se46cjfxa7IfYIVAu0Fb2H5iHG0rwvdsrW0bJr1v6qeQQY+my4UXmdOsaZIC7lJSMkGFLHp2HxNCAeLFx8E3BqoW960rjG4UChs+3n/+qxv35rbl1SxEvFPgZXXsMcLSx7amlY/LECis8bpf6tz+it3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CO1PR11MB5107.namprd11.prod.outlook.com (2603:10b6:303:97::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.26; Sun, 9 Mar 2025 22:06:30 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8511.025; Sun, 9 Mar 2025
 22:06:30 +0000
Message-ID: <e15d1074-d5ec-431d-86e5-a58bc6297df8@intel.com>
Date: Sun, 9 Mar 2025 15:06:28 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/10] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
To: Chao Gao <chao.gao@intel.com>, <tglx@linutronix.de>,
	<dave.hansen@intel.com>, <x86@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-10-chao.gao@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20250307164123.1613414-10-chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0130.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::15) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CO1PR11MB5107:EE_
X-MS-Office365-Filtering-Correlation-Id: 6398ad2f-981c-4e78-594b-08dd5f56a583
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MHh3OTZOY3RKYWl5cVQwSnh5KzhjTHFiUXIvbXlmNjVTYzdESk9saGtFUzI1?=
 =?utf-8?B?RHlobWoxSFAvV1pHRGk3VnRxS1YxVGh1amprR1JCUXhUSU1ybUZ5QTVlN013?=
 =?utf-8?B?QldFMUM4WnozN1ZOQkV2NjRxNzJZdlNVYk56Rzl2aG1WOHg0bnAvdnZnaGZj?=
 =?utf-8?B?YytpSjlUcVhQSEZDMnRqRTlickk4ZWw3RjBYd3hyMHp3NTFtMnlxa2ovc0Fi?=
 =?utf-8?B?R0FtSGFjSklTZUxEVjZUWXhDcDc4RktRT01pN3NOMk5nZDk4aWRhM3RaK1Rw?=
 =?utf-8?B?K0ZEMXVnZzA1a3ZXSUpoMlErRytZb29aaC9pMXUxMW9YL0hxWm9DVlFvVS9s?=
 =?utf-8?B?MDlsd29HTWQxaXJZVDJYVUVlY2tUdUMzNXUzbHlqWURSUGYxRVBZSHUxaWtC?=
 =?utf-8?B?LzZSeGhFMHhUMTExVm5TRGwvZzZOenpYWnJSRTZqU1hscHBDMzVKUDFieUdY?=
 =?utf-8?B?cXhUb05mR2hLYnh3K3RIejBUR2NUbUl1ZzhGYjgxWTFNdTNUMjN3MmNjQmU5?=
 =?utf-8?B?YkNlR3lVeDJzVmRLbklkaFZBR3JxQ1VnSWtGdHFoRHFodCtUc2x3Zkx2VXdl?=
 =?utf-8?B?MlFEU3UzTDg5TlluTHJDTzNUekg1dVJ2MW5yZE5VcHdrZjF2VTUwK2JBc3NU?=
 =?utf-8?B?eXpqWE9oWXhweW9MMkFFTmNGQ3NQRG9RZzNSd2dKbW9MaU52MVBYM05KTVBW?=
 =?utf-8?B?U0ZlK1VxbnY0SUh6UnhJRW8yVWdyekx6b3pPK2lPQTJjM0NKTjYvUUpZL050?=
 =?utf-8?B?SVBsaGhVSjZPb3dla1g1ZGJnRUM0cHB1UzI3eEdicWpLZlpYQ0pkOHZsSHUv?=
 =?utf-8?B?WmtBZUtwOS9VOFlyK1hsVSs3eHZrREh4U0w1Mk90ZDBPcUxUTzFYNm5UKzVj?=
 =?utf-8?B?aDl6YjBkejhoKzQ4dCtsSUVwOGVWb2FoQThmV0NnL0FCVWZjelUzcWNsNXBl?=
 =?utf-8?B?aGVjQXgwSm5EbXhZYUpSem9BaWpqTXZDdFRHVmsrRUZURGZCUHdialV6QXJ4?=
 =?utf-8?B?VU9PakdxY0JyT0poZGpodjhEOTB0UTljc2hsZ2V3Qkc5czluQlNHSkV2SndG?=
 =?utf-8?B?YU11OENmRlhybzkrbGxOeWRCQUR2WTVnalNuSGhjRVVjb2I2am4vRDFyRTZT?=
 =?utf-8?B?OEVFSGlWVW8xUklJSVRIcExHTEYwakpyT2xHUGN1cTEvMnBBMmFHVGFpUzQr?=
 =?utf-8?B?ZlQ5STdpNlJHRW14RTdEOHdRdlNERFREY0g0T0lUT0tQVFdQN2UxU0JJMnhx?=
 =?utf-8?B?TElYODV6TUZGa3A0OXJVdS80OE9vMnVmcktoMGdpcHNBOHdHcWVJRXo5OUlT?=
 =?utf-8?B?c0hmaUduYXhjRUcxaWpqazNFeFkwS1FBVkErMi9KVEEvVy9LYTJBRE50NHV0?=
 =?utf-8?B?dnlLOU5HaGJtbFJNeUdIUlJjSVY0L04vbjMzRGVyb2cxWCtjdWQ3YkNXaUUv?=
 =?utf-8?B?YStYK1RwOWttUHl0M3dGSnBEbjdGVG5sU3NUUTE2OFdqM2IxUmJQWmw2QmNP?=
 =?utf-8?B?V0ovME9JV0x2dENsMGcxdHo4NVJyc1BCWVlWNUtnc3ZzNVYxVWtwSjNqaXh0?=
 =?utf-8?B?ZC9GN2ZPejg0K1FsWXVTOXpXZWdlRkVkZUpnTDJmODc2blBoZUQ4ZytlaGFm?=
 =?utf-8?B?dFBWT2hzSEZEdGNHcE96TDhncy9vQzhzN1pSMVFTRTJLL0MzNDBwS3BReVZL?=
 =?utf-8?B?SXVUMStXQmhYbWJUNkt4SjBHdk5iK29uL0NoRlNUekpvKzd2UFF6WWJ5cC9s?=
 =?utf-8?B?TTZsMUZoNHpIZzgyVWhoSXJtOE5BNGM3RXBvNlhzeXVQcWJXdytJbzVTb2Ja?=
 =?utf-8?B?ODYzVEl3MXRETTZFZEUvQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEdtSTFlRkNIWGlwcmVpcWZTazlkYTI2dG9lVzBMZytseCtZQ3EvS1pNbUZ1?=
 =?utf-8?B?cEUwNXNvTmJmNW8zdmRHLzB3ZDZ6VGJkclBkTytIcHZpTU1rZnRRTEdWOWEw?=
 =?utf-8?B?S2grOEZoVDBISHd5NU5Lc3V6Nnhwd0VUdUh6ZzJGYnViZnVYZWp1SWRMR0l4?=
 =?utf-8?B?TEZoaG5seVphUW94d3MzSEU5VUoySWtOellUK0orYkV4SC9DUHJWTzg3NzF4?=
 =?utf-8?B?NTk1ZGQ5OVdxYWZQeG0xQ3JVZjZHRnpHL0h2YWsrUjJiT3hyWFc2RVFiMmsv?=
 =?utf-8?B?Zmg3dVM5K2E3aUZHMzJTZzNlbkFOK3VDSDJ4RkYxMy9NMG9VWlA5YkNoaWxF?=
 =?utf-8?B?U1ZMTDViN2NLUDRZVjlQaG9EZ2dIZjlSTXk5NkRMS2NCdHd4dkxLbU9Zek5J?=
 =?utf-8?B?YXJ5RXoyYlVQeUpQQ0N6NTJlbzdSYjNXYVlic0hEQXA3bkR2S2F6bms4dllX?=
 =?utf-8?B?RndmVmw3ZVJ1Q1hPQy9IMkpKZjY1d0IxcGRqVlNhVFlKdnJ6OExYTDh2KzU1?=
 =?utf-8?B?Mi9yTGYzdlh0L0IxM0ZjcGN2ODRsOStCQWZ1aFZadktJL3NuRFU4Y2VZNm0w?=
 =?utf-8?B?T2JMTzNqRmM2RDJkQXNSSDIzbk1zZTlpbW1BS053WXBRRmRBcG1aRnhKU2dR?=
 =?utf-8?B?blVMY2hucnlBdjAyUWl1WFJZN2hWbVdvU0owSjQrLzR1NkJ3NzNQYTVmNks1?=
 =?utf-8?B?eFNpMExQTDB0UkpWRVE5eHhFUWpiV0lqRjFFTmVlU1J1c0huZWNvOHRUL1Fs?=
 =?utf-8?B?aTJnVWwzSTA4clMwM0E3MEZwMGkvcXFrTUdtdHZJTVUxS1M3UFZwSUtNZXo2?=
 =?utf-8?B?OXI3Y1kyb3hidEh3bHNCTVNBSU5QS3NnSW9XU1ZaczlvSHFBc1MrdHgrYVU4?=
 =?utf-8?B?T21RQis5ejd2NXZKblVZUG80d2lYdnFMdXhIRWpITEZDQy9FT0VKZGE2MDFD?=
 =?utf-8?B?QlBvN01iVU1TcVBxZlhEN0hQN2R2SjJ3UkRzYVd6OTg4UWhMbW95TGJPamVR?=
 =?utf-8?B?SzdqZmpNR0tSeWNpb0JKMW5uWGhEYXhybU9mQUl3SklLVkpUa1dsRTFPZkI5?=
 =?utf-8?B?MUZzOHdHajJaMXVsb1lRbDVMREx5YS9BRHpTamU4UVpZOWh6SG9JdDRUWHNO?=
 =?utf-8?B?a2JDbTdWRm9kNTloMTRWV01sOWlsS0pJcXRDOHBsMjRSVFRzNFBFcG1VbGQz?=
 =?utf-8?B?alpVQ2ZBNWhJaVFoN0VPRnVvZWpSZHRzZ3dWclE0T2V3ZHlZMHBMNDkxMnNm?=
 =?utf-8?B?NXo3cVZ1K0NXcEpMeFRTUUlNTWZHOFNYbHU4M0syclRQSmZ4NDdib0FaU0VP?=
 =?utf-8?B?MkQ3WTRZWTEwRUJESEVOVno2N25YRE5vdkVhWjNsaFF3WEVuT1ZXYkswbWYv?=
 =?utf-8?B?TWtDWjJYbU91enA2NnhVR0hFT1dYUHprb1pjTTFLWUJoQ0JBRlZlUWtzdVlM?=
 =?utf-8?B?N1IwQ1dMckJvVVdRKzZQTWRBV2hXWDFFNzViWmY5ZjhLenRNazl4Vmtld3RB?=
 =?utf-8?B?Tm1QYmNCZDRPSzV2MCtIKzY4d2ZKN1J3R1NyZFlHUFFOUTM1RWU2azRYMFE3?=
 =?utf-8?B?T0F6K1pXa2U0MjVzMjlSb3pGMnhFZU9XQXNOTlIwbFJjcCs2aEFUZEdTbG5q?=
 =?utf-8?B?cjQwM2xXSkU2MmlKLzRRZXdHd2hncFBvRHNrU0U2Ukl1YngxUHR3SGR5aTQv?=
 =?utf-8?B?cVZ0aUYzTzZLSms0WThuWGRoTTVXeGViSWEvc1VTMEdkTDJianNpYXBIc2lw?=
 =?utf-8?B?Wm5mNFpaL2dzMEVPcEJ5ZDJJMGVFRTZGVTRNUDlCSWlrbDBQT1ZnamRFS2sr?=
 =?utf-8?B?dzY2aW5iVGFGYndNeExKTW4zdHJEMVFRMHNldXdiOUt1OWd2TktkVG9kSGFU?=
 =?utf-8?B?R254Y05jQzBwR1hSMW53TnN0N29WYWhpWXBkdWZ3RzR6OG9KaXVsUFBBMzZR?=
 =?utf-8?B?d1c5bGZNNDg1bCttQ010MEFscE1vMG1LS2ZYcHUxdnh2cXo3bis5QnVRV2d4?=
 =?utf-8?B?WDBLT1BOR3dqYTYwVkw3S0VqNnlBeExlRUtzYU0zMDNxOUtsQW9UMTNrTmJ4?=
 =?utf-8?B?MFhwRU11SmVwbjMrN0RMdWpFcVgrbVdIZklmNjY5VUNScjVZdTlWTE5CcEk2?=
 =?utf-8?B?bWZLYVZQakJyTjcwWmJFNUVjbXNkSFlCakM4cnF3NkY5cSsvM2ZzdjhKQmpJ?=
 =?utf-8?B?dmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6398ad2f-981c-4e78-594b-08dd5f56a583
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2025 22:06:30.6711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ul8AQCY8ieBLjqPaRNEIysq2/5F8X8216JC+lS4mfJhcMorm9NPKEaNBrX7qDOKAoGwLHDfYF5YH9UPXmjcHcTUIqZOZm87kd/E3zEutNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5107
X-OriginatorOrg: intel.com

On 3/7/2025 8:41 AM, Chao Gao wrote:
> 
> Define a new XFEATURE_MASK_KERNEL_DYNAMIC mask to specify the features
> that can be optionally enabled by kernel components. This is similar to
> XFEATURE_MASK_USER_DYNAMIC in that it contains optional xfeatures that
> can allows the FPU buffer to be dynamically sized. The difference is that
> the KERNEL variant contains supervisor features and will be enabled by
> kernel components that need them, and not directly by the user. Currently
> it's used by KVM to configure guest dedicated fpstate for calculating
> the xfeature and fpstate storage size etc.
> 
> Kernel dynamic features are enabled for the guest FPU and disabled for
> the kernel FPU, effectively making them guest-only features.
> 
> Set XFEATURE_CET_KERNEL as the first kernel dynamic feature, as it is
> required only by the guest FPU for the upcoming CET virtualization
> support in KVM.

When introducing user dynamic features, AMX required a large state, so 
buffer reallocation for expansion was deferred until it was actually 
used. This introduction was associated with introducing a permission 
mechanism, which was expected to be requested by userspace.

For VCPU tasks, the userspace component (QEMU) requests permission [1], 
and buffer expansion then follows based on the exposed CPUID 
determination [2].

Now, regarding the new kernel dynamic features, I’m unsure whether this 
changelog or anything else sufficiently describes its semantics 
distintively. It appears that both permission grant and buffer 
allocation for the kernel dynamic feature occur at VCPU allocation time. 
However, this model differs from the deferred buffer expansion model for 
user dynamic features.

If the kernel dynamic feature model were to follow the same deferred 
reallocation approach as user dynamic features, buffer reallocation 
would be expected. In that case, I'd also question whether fpu_guest_cfg 
is truly necessary.

VCPU allocation could still rely on fpu_kernel_cfg, and fpu->guest_perm 
could be extrapolated from fpu->perm or fpu_kernel_cfg. Then, 
reallocation could proceed as usual based on the permission, extending 
fpu_enable_guest_xfd_features(), possibly renaming it to 
fpu_enable_dynamic_features().

That said, this is a relatively small state. Even if the intent was to 
introduce a new semantic model distinct from user dynamic features, it 
should be clearly documented to avoid confusion.

On the other hand, if the goal is rather to establish a new approach for 
handling a previously nonexistent set of guest-exclusive features, then 
the current approach remains somewhat convoluted without clear 
descriptions. Perhaps, I'm missing something.

Thanks,
Chang

[1] https://github.com/qemu/qemu/blob/master/target/i386/kvm/kvm.c#L6395
[2] 
https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kvm/cpuid.c#n195

