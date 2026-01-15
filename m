Return-Path: <kvm+bounces-68143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 71085D220E9
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:44:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 726F63076749
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B84A25FA0E;
	Thu, 15 Jan 2026 01:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bE3zLFQv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59D527456;
	Thu, 15 Jan 2026 01:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768441454; cv=fail; b=DLs6o+x01s2LokkeKcH412hu6gjXeIxI0R28UzxGxELCkaFNdT+22Y5vf1UT8K5yzINRF7aVXDXtxSdJSh8b/ffb9zicJ3ZYyI1GiUy2k0DnMCTBqUTyr6Vu6iwPCWjkmKd9RxvKCxGguyHjOjdQOlZhnfc5smL/x+zMcPvt0Es=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768441454; c=relaxed/simple;
	bh=Tpsay3wBmk0/cX/yKeqvsFs9TWkZuIPpNLv5UJAmAFk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iYDLj8kgxIVUWXEUCLla8JVbhiIFLjj/n5Q30WdU6lJUMVHb2aiqUkxqrDbb6ft9ZkiMNijji5QOBVvnvrxeIEx93ngVRrC50NZ3OgaCHXXerbAG6tymaJdEP5HuUgN/MIlrw7eUPHb2YB92lbicQZfO9fAQFpbGWLx9PK03ggU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bE3zLFQv; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768441454; x=1799977454;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Tpsay3wBmk0/cX/yKeqvsFs9TWkZuIPpNLv5UJAmAFk=;
  b=bE3zLFQveT3BHif11Teien71C2sEVbFwmRW0GKiqCNT+MYb18Mr5rWVU
   Mr7GYy592uX+HqSBXJHrgO8sGd1Et0ygENrgb1FINbf/qYN93F7fMqS6C
   VNtLkN66FpmWx+2nx9OeSTKcWtIeB2G2DAnJ9huDpvVtSd04KX/F+Tdnz
   zB7eTnlle3iKzlj4TntQPhYxLaM607Cppk2reaQHhF0So6PfmWWPXs7GI
   E17VVk10dHxruVqKwRJlC40/4BRZoQclRQ290hwO4s1SD54L9pl6R3QcI
   CkOcx+RJ5YR0iu4/cU8uff80qDac5XqQTznyEZZkePlJoIXqJWf4kXrYe
   w==;
X-CSE-ConnectionGUID: WZtuigUdTWyuUXBQerIwOg==
X-CSE-MsgGUID: opfLagqpTGauS/7zbUQPwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="92421591"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="92421591"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 17:44:13 -0800
X-CSE-ConnectionGUID: fICX82F2TMCOf09CYlVdyw==
X-CSE-MsgGUID: WTa3KSMvQbOW0l2Jr+27qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="209336555"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 17:44:12 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 17:44:11 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 17:44:11 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.39) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 17:44:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SzcUAJEvMAxO0SFHBeshW+HxrO2ovCtkdcRIuC116LajOHzv1AwSqfLZuMEryO4lX+x4t71Wnjp0ofhUr3h50DWL06rFYR8YzVOJ64RvOtrLj85L1/DqC4ceXVRF3nxOyFhNODIl5E00twPPJnRVxEvtT5DxmPsaYxgQWGvggNGvPhco8M5mkZIPHZFCvj5H72CaSPs8c5CQhIQ6q08OP/EU+mbMxtR5h74cgd1D6ODCRYG/a6jeaoe8s47cuvVy4UeqLjuVpmMK2Kw8A+ISKyg5U6E3fmBCxQv6Pjkn24oVor0Hd/a+CDojHM3l2w/VkN5Oi9yFVAu90EbcjX154A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YeVcXoZJiA4h4ssa3uj/WxPkyaaO7fzl0nvL22IRwK8=;
 b=XKA7AySUbXdf3giGBxn5BBWTWyU+lHI80T62VIJBTVtgSSCa3XMpgiauh3qJ09S+5V9vCniui2RnIkDFqU2Z8OHyf3MEzjSju1EWuMlUEZamj0PIO/KUq375qh0kbPsCjDtzDfeJcJ3mWBSmd6IiFlCYqOwLMSWdD+a6iaQjlh9w7QHIE1yubDCSzvSlD+LqfaZ6QfAsNZAFxfKJjRf7c7skqM1YOROgQ4lcum4nIOV70IXVsoSsPHo+Dsnn2ZCCcwzm3WYRmdlihz+7w5fNDXbBk7n7bG3qHrYuSwKlaRJ/n2+thyOgslMxf0lQUILc2r3o7h+K4YyqpSoNb9bqBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ1PR11MB6228.namprd11.prod.outlook.com (2603:10b6:a03:459::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Thu, 15 Jan
 2026 01:44:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 01:44:06 +0000
Date: Thu, 15 Jan 2026 09:41:23 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, Vishal Annapurve
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
Message-ID: <aWhFwzlqqrnBLLiK@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com>
 <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com>
 <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com>
 <aWbwVG8aZupbHBh4@google.com>
 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com>
 <aWe1tKpFw-As6VKg@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aWe1tKpFw-As6VKg@google.com>
X-ClientProxiedBy: SI1PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ1PR11MB6228:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c32e213-de14-42a9-db14-08de53d791eb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8ZGfTOFUuEVVzt/QB2JfLxO4a0jLWZWvntfDdqN3SF1DN4eaNjp2J3JgzWdn?=
 =?us-ascii?Q?NopHxi6Cbb0sW/mwaNsj2LTywnm3jc+OiXg2Q2QTRYGJJz75dj7d1E/dMHEI?=
 =?us-ascii?Q?kG8j+JsYFi+oBLNT35z43SSDnIDh9luI2AH5+8pspmqWxs/6fhYxUMMnpDP2?=
 =?us-ascii?Q?Lqp95iyyHODX38Iwb0peBkxZLBG4szX/04aD0oZdlFW7Y6Qzyi6iiA7Sgxvt?=
 =?us-ascii?Q?CiyF8yElr752tZngc+Bq/RP5luu43ZHqzdmNTcPyJ5s5lxPSS+Pp/RQ+dS4W?=
 =?us-ascii?Q?3gi0DlrNFna2Olu8IH0XE7BKp2AcVmntGO2wB/HTlCKmHPEbdadfWLhs8K9b?=
 =?us-ascii?Q?76efl93KXgRDQ68/Rr1+GyQVEPAaegHZgp2mkPQ+WWHpe9xoZ8tDgiRPUVXK?=
 =?us-ascii?Q?shzhuqDsv86rLnLAtYPZxjsuSduDZTCKYre5L18LtKc2Pt3OSRHfQ7ogbEom?=
 =?us-ascii?Q?DUwmSN5LA6/JliktOtiHoLdYHI3K/QTXtcBueL8vtbUMT9KyUhjkk2M5clGl?=
 =?us-ascii?Q?TDqd0bxiALGGf2/24N/B0Qf11JoECL8QHGJk2ilHn5kUh43pmg9MsHDy2gHK?=
 =?us-ascii?Q?JIIgKYEPFguiI5e1yCU6USOpSTJLXNtZ+uYgLR0DH/PORsyPR1IUjt1B7cYM?=
 =?us-ascii?Q?vhAd9sehyNtYaUaiBDBUiFXQMWAcGE/l++k0wiNpXPi19y91wXPR9GigO/oH?=
 =?us-ascii?Q?SI162B4hV73SZozXGTclLZiDUUSN5wgTpsmNvzCEtIsc0lQH/4x+igrOO3pk?=
 =?us-ascii?Q?+o0aBT59ZFusTjdUqR2xk+Nogg8mxq/QI8ad/GcAR8d9dVoSxn783XOJAx2o?=
 =?us-ascii?Q?QK6e+BmNBeOoGlLF2F0SaWcRoooLqLBD0CtPI1MCEmv5jWusdHK5jEP8fdNE?=
 =?us-ascii?Q?/mauNCsOe4cBL/YzLgbzsZ8jXj+UrenSrjduga6YiL5w7N7NcjEG7IeOQFzj?=
 =?us-ascii?Q?jGUgt/LrYyCSRh2GtOEnA1U/nxPL9G9yAsLeX2z9q3gJor8GgLfcwwfSXo+y?=
 =?us-ascii?Q?vruvkp1HbMEK5KD68+yoygyjmogrSIloAuuaBb44D81g5KHjhn7QhDsI59hl?=
 =?us-ascii?Q?QDMdWTt9YjIEOI5zjFhwru9hpXmVbxn7oQzRQNFpOGzfg7rjVhaONsXjwXDR?=
 =?us-ascii?Q?sq52a21cO3HzSzvp38w+CWHLjEplK4zIR9AjBCL/eYxHzY+Ew6pucjoaMjTq?=
 =?us-ascii?Q?YW6yYbSkxcdg3Mhk8SW2v2fNCa8D2kUUGCwcvfXlMnRKrgbWpPCAvh1RAbX2?=
 =?us-ascii?Q?Kd+DOHMTKdQpzpWwVhC6nHi6Io1abG7Gm3bxJSWZjyNpaTWf7I23sCMstH7Q?=
 =?us-ascii?Q?A5THirWyVQrdrFmUwah1P7kyWMMJAXkDnFNIVCvT/Xr/UWUJntV4aK7LJGrA?=
 =?us-ascii?Q?NmLmK3gdVWIZXlq/IkVbZJqRCcjE6E5gEEDQsOOCbiV77naTQZ5LSMg7cz33?=
 =?us-ascii?Q?/ok5zVm6P7/grzzdf3DZ8UxfwEu/dvhTYZjuUXSL8+nvxyQGbHZnyl6f10tH?=
 =?us-ascii?Q?4/3sT1QbjqwfxGM/NGD3UWG/Mu4Zlge/qxpph4JfNsfqLd8aBhp3bGZutcHW?=
 =?us-ascii?Q?ziogMZRtWxGFXDlxL2ZlUIo7gmdJxAOlvh8UlqA5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qkpsDsRdrq0uu2wQrbQkF8HDqG26PHGc+IvZXtptpkVolGlD9JhU8ucIkB7E?=
 =?us-ascii?Q?l2AQvrwXB7g5vtKDf6tt1f70vejo8SNqaxNWXI9leDNaDanY1Gj9F4wGQhFZ?=
 =?us-ascii?Q?UdbJiV7pSaRoj0YcJTuN2VmR69z8vmgVtyB+xmovk+kox+2zSVpPZZBi2TJb?=
 =?us-ascii?Q?5KXcOW6VaYsewhcef4bSRN6sRscR8aw5tEuQwF/wYb6nTXPp6xiaGnwpyPVo?=
 =?us-ascii?Q?YVqMsZ2AOCJSrdJs6KOf5Tg237e3xggW8dj74ZRTXFBTed55X9+1kHi3MBU/?=
 =?us-ascii?Q?fsnsvbyBh1Y6ESw0alHollxDmPCQCQhxDLzU8FpHQzPjbEFIe3doc4j91LPs?=
 =?us-ascii?Q?y9wa9CS1QlxpARYMXc8vWW0zAunriMltfOxXvE2/ihOoF8QqOTULh9nrwOAA?=
 =?us-ascii?Q?zAk4T6q6zrSeQvF7w6IIk6AsjzLR/wqGjs+7L81y52fwUSut/s5g4ONUIoss?=
 =?us-ascii?Q?EN7QoARqJZXVOSSLk8+TPiF5+UZ6I2U2xCL7JaYSzcrdShuJDFmXvBTSnJ7y?=
 =?us-ascii?Q?8sijOKjVoDZE9tsu3ZzLYxL91ccOkOoRMssmuRBQQG49dC9i4PsqO8CbLrrt?=
 =?us-ascii?Q?mWbqygN3jVPhBjYBQqnuozqgae+E+2TUGGBrFK8Ta0mb6u2NPD4FN+A9IV+K?=
 =?us-ascii?Q?1t4wfvjyro6a2xY7jPEzkZFf4uorVu7oAd8NYbeh3clspnNm58ohv2MhzSNv?=
 =?us-ascii?Q?fw8zE0alchByN2hSBHqSdtzuw9s6JSzhqHwdHz/Qe6UtzXRp1N7fRvaKV1J7?=
 =?us-ascii?Q?a7pTyls1vlfMp95z2KvPV6SJMfCxylkjoDHjoPUsCmwgS45PnUvE7rZOSS47?=
 =?us-ascii?Q?0qplVqN6OaqlAFrvZXQUZ0WQVsfByOW0NtLBiQ40McC8UbmRSePt8hY9nL40?=
 =?us-ascii?Q?MOdF8PLXRTJ0q/GS7GEyK7p58RnEcTtw7L6tcCnpc8j89wH3PwUjtAVawpDs?=
 =?us-ascii?Q?Ews1FOxVEl0JRqZvdQ4JAUbdm7kDfPVis9ZPQJ/Oy3f8AVRE+GUzMOYNMb/T?=
 =?us-ascii?Q?3rfPhtQKX1HGp534PGfMtymxgcSr0V0TmEMgZ8aN1qm4NYZZVhxG4eZcFVXc?=
 =?us-ascii?Q?XNuTlGFAUrVnNCxVDBdRDvQX8VLZjfd0rilaVLHqllUPKni9tOscmHaqF8Q/?=
 =?us-ascii?Q?bJF4Zmy1I9+Ki9Frbd8Ozj/rtDNcBITh30gBZifY1IdQoshDnuEyo91sgKAJ?=
 =?us-ascii?Q?ButquR7PlkT4kFWU7x8rA1sGbt8QHV/HyK8g6uKXN3lmI79BvWGUdaEtVkS5?=
 =?us-ascii?Q?f7JipODTifGVb/rcY8L5JBiTLmfkEcoONSruRVHFeCxF+brJOYw0je4HZqhp?=
 =?us-ascii?Q?nd9l3NuSRFWnWTL8lydQ3EIGmQHOGNMz3uV3smQGFvjMQUTCLfqexf+7MM2z?=
 =?us-ascii?Q?SKJS/cAEn3ZCH2Pue9k5DKAE7f1WP7ucI5pB6vCmjuNE2/iyOmHpQjE468SX?=
 =?us-ascii?Q?O7LnXknMuVVYTeW8sABaTKnaYsItskFEE1r+pRhrOB/rDzLfMFz65Nw0iouh?=
 =?us-ascii?Q?SJE4NeIdLjEqLp5r7laqW1yBIm2hmLr6SoGn7FMBhwY2rLo8TG1FQ/qt9JmT?=
 =?us-ascii?Q?VzDfZ52E3RHG5U2WK8+VTGw9hY79qk/KZhDwVT8qzB0SmmI56TTe4wwjDjSj?=
 =?us-ascii?Q?9CRXPKNzdn2RXIm8W2VFJI0+FXDnCdiCwJVCj/CNHl/YYUFLPP+bseBfJE4D?=
 =?us-ascii?Q?DQrQD7OeMXzYVw61TsOS5CxeSWrGiVFXJz5NlnTHCXhHottlmWnJN8nU58ju?=
 =?us-ascii?Q?GmEbtzHRVA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c32e213-de14-42a9-db14-08de53d791eb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 01:44:06.6582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o9PYEoef20F6aul0t9SY0JNwDRkkXfSEXq1NZ2WApXxuc6y0M0adeeE/V00S+5+TMjARsTABGD2d0EA1Mpm9kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6228
X-OriginatorOrg: intel.com

On Wed, Jan 14, 2026 at 07:26:44AM -0800, Sean Christopherson wrote:
> On Wed, Jan 14, 2026, Yan Zhao wrote:
> > On Tue, Jan 13, 2026 at 05:24:36PM -0800, Sean Christopherson wrote:
> > > On Wed, Jan 14, 2026, Yan Zhao wrote:
> > > > For non-gmem cases, KVM uses the mapping size in the primary MMU as the max
> > > > mapping size in the secondary MMU, while the primary MMU does not create a
> > > > mapping larger than the backend folio size.
> > > 
> > > Super strictly speaking, this might not hold true for VM_PFNMAP memory.  E.g. a
> > > driver _could_ split a folio (no idea why it would) but map the entire thing into
> > > userspace, and then userspace could have off that memory to KVM.
> > > 
> > > So I wouldn't say _KVM's_ rule isn't so much "mapping size <= folio size", it's
> > > that "KVM mapping size <= primary MMU mapping size", at least for x86.  Arm's
> > > VM_PFNMAP code sketches me out a bit, but on the other hand, a driver mapping
> > > discontiguous pages into a single VM_PFNMAP VMA would be even more sketch.
> > > 
> > > But yes, ignoring VM_PFNMAP, AFAIK the primary MMU and thus KVM doesn't map larger
> > > than the folio size.
> > 
> > Oh. I forgot about the VM_PFNMAP case, which allows to provide folios as the
> > backend. Indeed, a driver can create a huge mapping in primary MMU for the
> > VM_PFNMAP range with multiple discontiguous pages, if it wants.
> > 
> > But this occurs before KVM creates the mapping. Per my understanding, pages
> > under VM_PFNMAP are pinned,
> 
> Nope.  Only the driver that owns the VMAs knows what sits behind the PFN and the
> lifecycle rules for that memory.
> 
> That last point is *very* important.  Even if the PFNs shoved into VM_PFNMAP VMAs
> have an associated "struct page", that doesn't mean the "struct page" is refcounted,
> i.e. can be pinned.  That detail was the heart of "KVM: Stop grabbing references to
> PFNMAP'd pages" overhaul[*].
> 
> To _safely_ map VM_PFNMAP into a secondary MMU, i.e. without relying on (priveleged)
> userspace to "do the right thing", the secondary MMU needs to be tied into
> mmu_notifiers, so that modifications to the mappings in the primary MMU are
> reflected into the secondary MMU.

You are right! It maps tail page of a !compound huge page, which is not
refcounted.

> [*] https://lore.kernel.org/all/20240726235234.228822-1-seanjc@google.com
> 
> > so it looks like there're no splits after they are mapped into the primary MMU.
> > 
> > So, out of curiosity, do you know why linux kernel needs to unmap mappings from
> > both primary and secondary MMUs, and check folio refcount before performing
> > folio splitting?
> 
> Because it's a straightforward rule for the primary MMU.  Similar to guest_memfd,
> if something is going through the effort of splitting a folio, then odds are very,
> very good that the new folios can't be safely mapped as a contiguous hugepage.
> Limiting mapping sizes to folios makes the rules/behavior straightfoward for core
> MM to implement, and for drivers/users to understand.
> 
> Again like guest_memfd, there needs to be _some_ way for a driver/filesystem to
> communicate the maximum mapping size; folios are the "currency" for doing so.
> 
> And then for edge cases that want to map a split folio as a hugepage (if any such
> edge cases exist), thus take on the responsibility of managing the lifecycle of
> the mappings, VM_PFNMAP and vmf_insert_pfn() provide the necessary functionality.

Thanks for the explanation.

> > > > When splitting the backend folio, the Linux kernel unmaps the folio from both
> > > > the primary MMU and the KVM-managed secondary MMU (through the MMU notifier).
> > > > 
> > > > On the non-KVM side, though IOMMU stage-2 mappings are allowed to be larger
> > > > than folio sizes, splitting folios while they are still mapped in the IOMMU
> > > > stage-2 page table is not permitted due to the extra folio refcount held by the
> > > > IOMMU.
> > > > 
> > > > For gmem cases, KVM also does not create mappings larger than the folio size
> > > > allocated from gmem. This is why the TDX huge page series relies on gmem's
> > > > ability to allocate huge folios.
> > > > 
> > > > We really need to be careful if we hope to break this long-established rule.
> > > 
> > > +100 to being careful, but at the same time I don't think we should get _too_
> > > fixated on the guest_memfd folio size.  E.g. similar to VM_PFNMAP, where there
> > > might not be a folio, if guest_memfd stopped using folios, then the entire
> > > discussion becomes moot.
> > > 
> > > And as above, the long-standing rule isn't about the implementation details so
> > > much as it is about KVM's behavior.  If the simplest solution to support huge
> > > guest_memfd pages is to decouple the max order from the folio, then so be it.
> > > 
> > > That said, I'd very much like to get a sense of the alternatives, because at the
> > > end of the day, guest_memfd needs to track the max mapping sizes _somewhere_,
> > > and naively, tying that to the folio seems like an easy solution.
> > Thanks for the explanation.
> > 
> > Alternatively, how do you feel about the approach of splitting S-EPT first
> > before splitting folios?
> > If guest_memfd always splits 1GB folios to 2MB first and only splits the
> > converted range to 4KB, splitting S-EPT before splitting folios should not
> > introduce too much overhead. Then, we can defer the folio size problem until
> > guest_memfd stops using folios.
> > 
> > If the decision is to stop relying on folios for unmapping now, do you think
> > the following changes are reasonable for the TDX huge page series?
> > 
> > - Add WARN_ON_ONCE() to assert that pages are in a single folio in
> >   tdh_mem_page_aug().
> > - Do not assert that pages are in a single folio in
> >   tdh_phymem_page_wbinvd_hkid(). (or just assert of pfn_valid() for each page?)
> >   Could you please give me guidance on
> >   https://lore.kernel.org/kvm/aWb16XJuSVuyRu7l@yzhao56-desk.sh.intel.com.
> > - Add S-EPT splitting in kvm_gmem_error_folio() and fail on splitting error.
> 
> Ok, with the disclaimer that I hadn't actually looked at the patches in this
> series before now...
> 
> TDX absolutely should not be doing _anything_ with folios.  I am *very* strongly
> opposed to TDX assuming that memory is backed by refcounted "struct page", and
> thus can use folios to glean the maximum mapping size.
> 
> guest_memfd is _the_ owner of that information.  guest_memfd needs to explicitly
> _tell_ the rest of KVM what the maximum mapping size is; arch code should not
> infer that size from a folio.
> 
> And that code+behavior already exists in the form of kvm_gmem_mapping_order() and
> its users, _and_ is plumbed all the way into tdx_mem_page_aug() as @level.  IIUC,
> the _only_ reason tdx_mem_page_aug() retrieves the page+folio is because
> tdx_clflush_page() ultimately requires a "struct page".  That is absolutely
> ridiculous and not acceptable.  CLFLUSH takes a virtual address, there is *zero*
> reason tdh_mem_page_aug() needs to require/assume a struct page.
Not really.

Per my understanding, tdx_mem_page_aug() requires "struct page" (and checks
folios for huge pages) because the SEAMCALL wrapper APIs are not currently built
into KVM. Since they may have callers other than KVM, some sanity checking in
case the caller does something incorrect seems necessary (e.g., in case the
caller provides an out-of-range struct page or a page with !pfn_valid() PFN).
This is similar to "VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio)" in
__folio_split().

With tdx_mem_page_aug() ensuring pages validity and contiguity, invoking local
static function tdx_clflush_page() page-per-page looks good to me.
Alternatively, we could convert tdx_clflush_page() to tdx_clflush_cache_range(),
which receives VA.

However, I'm not sure if my understanding is correct now, especially since it
seems like everyone thinks the SEAMCALL wrapper APIs should trust the caller,
assuming they are KVM-specific.

> Dave may feel differently, but I am not going to budge on this.  I am not going
> to bake in assumptions throughout KVM about memory being backed by page+folio.
> We _just_ cleaned up that mess in the aformentioned "Stop grabbing references to
> PFNMAP'd pages" series, I am NOT reintroducing such assumptions.
> 
> NAK to any KVM TDX code that pulls a page or folio out of a guest_memfd pfn.

