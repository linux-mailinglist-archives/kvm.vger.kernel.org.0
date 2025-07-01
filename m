Return-Path: <kvm+bounces-51223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85BADAF057E
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 23:15:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 565CE3A8222
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 21:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A2425F793;
	Tue,  1 Jul 2025 21:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PDEQ+lCO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEFA1CA81;
	Tue,  1 Jul 2025 21:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751404542; cv=fail; b=S2fKwK/AxSvVYmKRkxAhN053Rbt7VKgaC0XGn+CRxFEf0Dw68AcC0mB9vrWRvvVqipNYKUydkDOGyrxQlM3t+1evcPKgKTadHtkkzYNzNVbCAv4ywV/HzNj2BFX2notqYP7F9JToBLdgPJjbpq1zsFGlvVJzvjrRQsrETO6jTXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751404542; c=relaxed/simple;
	bh=y4Q6TBMOrMF1ihpLIJdjc4BP1QujpNhe67LAZxhVd2k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ddblM7r8tFFxtB0uj5K1idxjUTJv5yH0kh3HsnpEJHnhLYKsAXX9AQfAs8vch6BZrTN3grL4jOjgRD+/eEyj0MoFAvZ6FOo00me+0ZfwusUV1HywBV+te58kQUG8jp9iJ0GJ36Ep4b5fYNr+AgrA5ZmHIxiJmSLE39IR/L9WAeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PDEQ+lCO; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751404541; x=1782940541;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=y4Q6TBMOrMF1ihpLIJdjc4BP1QujpNhe67LAZxhVd2k=;
  b=PDEQ+lCOKS9vghpLhlT69KYl7eKXtaGEfAk+T9XSDdsRyE5n7F5tCCWN
   y3urqRLDbVN58cRNcx3e1FFlTI2c2C+RDC4khhs9aBJ3a4ftkT0XhP5SV
   fCnCXqbpR/hspZgmGLqxL6ZmMQiubUaoEMTM2TNj5shiZ9xlSc5avqtil
   8OpUPyUBQCEB8ctaXQhKPVAILmBEYa93VlRPyLbIXwXaAIZ2uPmpfqmcp
   2SN55xAgtvwZbp5pHOeiHDglLx4L4nbc9qA9lBLIx3opY8J00XZCsbbdS
   APc1b8K4WOAScei8QgMGrmGROKeA+GVYt29GsTDbFi078enUTT2U+YLPH
   g==;
X-CSE-ConnectionGUID: Ujze62yPQBmcKrp8ZhowYQ==
X-CSE-MsgGUID: dYk+gc1IT4mDBjLnbZSSRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="57364393"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="57364393"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 14:15:40 -0700
X-CSE-ConnectionGUID: 5MEU2jRoS6Wfn5cM+lcWcQ==
X-CSE-MsgGUID: JavUlCHqTMuvrKKstyiqtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="153978332"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 14:15:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 14:15:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 14:15:39 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.85)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 14:15:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DjTz2LJKB2EIK3g+T05ikdl78o/5eBKbfYolFL7PTwDixwX4YdD6ljcCL5FgaTazE728O98MTJV6PvTE6XadwvjTI9XzvpKhIvsgQszBUalzmzF0ZtpHSQPk0ytOfqyU8VMr44zt5u97qJIPu3HfHk2PU5BugsqW42ah9TUuMoJmBI6DDPO3oXSzS3tbnMUz5Aof8JUoORIuncJdSbMJLMvMxr4Y65vd2pzA1AZCZkphyx9gCj2nZtMQvpThS+WLyn5b6Hngdh9PbC6gCFSNicSQ7qqum2nbKglRQJPIsFhTCl9vCkcmmrue/zzrDOVxE6dDkYO24cgXTobfYCXGGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y4Q6TBMOrMF1ihpLIJdjc4BP1QujpNhe67LAZxhVd2k=;
 b=LsTCaWJMjxsMPkDDoh/ZFBU1x5wJifRFS+Q2xxL+FA9RVkSEnLkzqvCypBphCKJFy8xgb+DeEWpGEl8TR6Gsj3MADXonEjHTbQt+ClMhBfyaXq0YTZIQHcOtvVuVp90b6xzkR4r4U0rohNmGaMdHBwJfvILetsFkpczZpX8bwBQgHjP2k69vTrjikd60p2B0aoHD97OgIXqwDBEgL8jXQQDt56xD9PNrvQ0Dmn696wW3H99xHPTdNQ2GQ5KSHmrfagsAzCPuhk0HBjl9Njwgl7P7kuPe27KjWd4rfLXwbzyE5RaaKEXTbDfWs69d6TWZBI1UJ7DVNYDNFXrt9k5K6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB8718.namprd11.prod.outlook.com (2603:10b6:8:1b9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.23; Tue, 1 Jul
 2025 21:15:36 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.018; Tue, 1 Jul 2025
 21:15:36 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 03/21] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Topic: [RFC PATCH 03/21] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Index: AQHbtMXplPLpm4nddEmAiCVIEk5qsrPQ/bSAgAJ+u4CAAJeqgIBKHO2A
Date: Tue, 1 Jul 2025 21:15:36 +0000
Message-ID: <99f5585d759328db973403be0713f68e492b492a.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030445.32704-1-yan.y.zhao@intel.com>
	 <fd626425a201655589b33dd8998bb3191a8f0e2f.camel@intel.com>
	 <aCWlGSZyjP5s0kA8@yzhao56-desk.sh.intel.com>
	 <81413f081fde380b07533a7839346334bb79d3cf.camel@intel.com>
In-Reply-To: <81413f081fde380b07533a7839346334bb79d3cf.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB8718:EE_
x-ms-office365-filtering-correlation-id: 2a2f0db5-638e-41fd-4e52-08ddb8e46c3f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RHBFeHpmdVRrdlRkblhkRXRIZ1dxNStpOUZQaUE1OE5yVW55VkNqRVU2djla?=
 =?utf-8?B?UkVhSzRKZXNJdnZnL3JRRjdpRWc2anBaclZ1RnlteHBRT2YwQ3JnYlVUYzFo?=
 =?utf-8?B?aTZrYkVGdDREUU9MeUhIeHVUWC9zTHRiR1RNdEErRmEwMnFZWlRjZzdUMVBz?=
 =?utf-8?B?cE5xVXlDalVQUzRDcE45TnJTTzhUNS9sNWt5cnpJc1pCNUFCNHBvUmkzK29F?=
 =?utf-8?B?M0xqR09IUmIyZnpGNVA1QlBObW9SS0NRWmhBaHZqcWMwckFObjFJNzM2amtD?=
 =?utf-8?B?SXJobDBwWGp4ZCtXS0hacklEa29BVUJQVXJZUTJwN0NzT2owTFlTNHE2QndC?=
 =?utf-8?B?dXQ2TXNNYnI1NGk2R0dpdUZjRDBOdEJkbm52L09XdmptY1JIejhTYjh5RU5E?=
 =?utf-8?B?Q2loMWU3eVM1RU8rU2N4QU5KajdzVElNaG9QNEdZZ2I2dWkrODk1Z2tFU3Vs?=
 =?utf-8?B?SUNOK3JtSlZmNmZLakdqR1diNVNXMUNoOWllQzgwc1hhQkwvUVFvTDFicjFj?=
 =?utf-8?B?anF2eGJ5dkhWaDJQVnhhbjVMM0t0dS9XY3JMMjNIdUljUWxRRUpDeWRPaUlQ?=
 =?utf-8?B?UVl6TWkzN1FDcFNZVGt1ZUtiYjdXbFNiYnVDV2VDV2RBbmErdVkyZm1nZFhL?=
 =?utf-8?B?NFVyMzUyU1lTOHJVUjdaUHo2aTlLdEFpZlNrblp2cEtGd1BOZUlEaktWNE5z?=
 =?utf-8?B?d1pBUGFHWTJnTGRKdkFrWG8yY1FNdS80UUxrN3RNcDZtLzlvS01YeGc0OVhD?=
 =?utf-8?B?Lzd1NTJvc3FKZWIxYWpTRUR3cmt4bUw2N05xbVY0dTZRNDBNSHRpMnBuVUhH?=
 =?utf-8?B?ZkZkcDVCNWhFNE10ZzFkdzN5d1AvdGx3R25oMi9oTnIxUzE0RHJmK0h0TEFl?=
 =?utf-8?B?cDkvNU42WGVyVUlSc1B4dFJkclJGMEhQTXZ2QUVTNkZPUjZmbzl4UGZUcmFV?=
 =?utf-8?B?UlhqWU5DMFhUWWY5cGRuNlFVQ1R1YkIzNXlOVnh1aEtzMG4wbnQwTlU3MG9Q?=
 =?utf-8?B?V0NHS0FoOWFGR1kvK0NYU0g4d1BBckt6YWkwT0RDNVh5VFJlaEx1K0lRSXVI?=
 =?utf-8?B?bkZUM2dJVTJZd0o5LzFmWmJQclJKbG1BNFVKMmIwQ2dhTWxZOW1uTDBQNmxX?=
 =?utf-8?B?dEtacm9jTGlYRTY1WWtHQ1Z3T0FYTk9HaFNINDRIODNNcGl5bGFkc09ubHF1?=
 =?utf-8?B?Ynh5M0R5aUJhQTBKK1BRM1RXYmtETG9NRXFleVU2dmt3cWttM0Q5ZzVJanBX?=
 =?utf-8?B?Z1pGQ0tycTJBRnhtbjl4M3ovMnJsTEdVYjhYWDU2ZXYxN0lQVHY4aFFzNkt4?=
 =?utf-8?B?Y2EvVk03S3Q5bG1LV1l2YW5Uc0ZNRW5OYVdSM2tUMnpsVzNZWk5kUzJuKzNC?=
 =?utf-8?B?dEJYSkhwaTFNMkxsWndiTS9DQ2lEa3gwWmFocWlhY0tRVGd5ZUg4TWtYV2k4?=
 =?utf-8?B?VHFRM1BZVTR2MDlLYk5SMmsyRW84WEtob0l1Qi9tanVVRlhqTkcvUHUwMm1i?=
 =?utf-8?B?Z28vYmFzRG1GSDZRWmFyRC9JSmt0Qjllc0xVKytaK0dKQkJkRldUeDZkN3Z0?=
 =?utf-8?B?S3lXN0RkM05hd1NRaGFqVE5ZWWl1UFcrTEdVTUdONjVYZk01bVBVM2NWQU9h?=
 =?utf-8?B?Q0xtMEpkRGdQQWpRdm9jS1VSNzl0RjBPSkJjNUpuQzUwWGJvUFAybTVsaFRi?=
 =?utf-8?B?L2ZpdjJOSnVKQ3p4aCt1Q1hyamdQK2wvd3hqUnFkdStUMDZHV2N2SUNRdFFr?=
 =?utf-8?B?Q3dYY0J1SEkxUCtDZWpESFQ4K2hYdzZYYUpmeEVGK3hWNnJlV2IyMXI0aW85?=
 =?utf-8?B?UnR6OTloaFFOOC9VeHFSai9ONFRmZ1Rob1AwR3ZSTGtmRW0vSE9NM0JaRWFT?=
 =?utf-8?B?Rlp1bE9nUXI0L0paVXZMYmliUFdhY2JRWUJIZHNTdVZYVlBXWXFxdTVzY241?=
 =?utf-8?B?UWUxaDRkaU5uZFd5VXQ1Vjl1aXBoZHFGWmZzaUJmMUF1aVJPbGFhRFF5ejl6?=
 =?utf-8?Q?0AoYqQb4S/dkCOsXd4I5pkD0/Dlbc4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWhoNHFCSkR1T2FMMERBZnhyMXpGTTBRTXlFcDFCcFVlRk5xTTR5TWZ0UFdi?=
 =?utf-8?B?cjlTQXUzdGNSdnhpdWpxV2ZwTVJwK0tycWVTa3VneG5mUXp6aVRrQU43RTNE?=
 =?utf-8?B?Q3FRWTE0VlZKTGtUWmI5cFkyemErNzNZNXFOcjFoc1E0anNRVm5VZU9nWksv?=
 =?utf-8?B?YzZrTk82TWkvb1hxRWpBRm1TZlZTN1RqeWJZWmJHYnlsUVpXdmdJUG1rT2Ri?=
 =?utf-8?B?S2xscTBzdVZxNzBRMnh5eThWZk9GR1hYcHBnSW1NenV6MVJTWS8xbVJXT1A0?=
 =?utf-8?B?MUJKQTRyL3pnWkJJMVJwWWlhVzNNWTI4WFEvREVzamJUVVM2NDFLY21hVEdw?=
 =?utf-8?B?YkRMSW5LSDdRVHZkYVdXUjBMSU9vMmsyUHF0RjBnNTRHN0xDRy9Bc2RBaFdp?=
 =?utf-8?B?cmpIRktmRHQ3aFNrSVlBQTBFb2JFY09sWkRNTjhSa0pSRmhyR1M5VnhMZEJ3?=
 =?utf-8?B?MExXbm1DWk1vT0ZHYXhBODlGbnd4MnZRbEFrbDhoMmpIZHUzdVB5Qnhhc2Fs?=
 =?utf-8?B?U0p6WGYzTkd6TGR1bWUvU0YvKy9sL3JiTVlmZHl5NVFnQkhFMDJJaGhUdDZI?=
 =?utf-8?B?YzdnQ1FzRldqd29xa1ZDcTF1U05DYzkvbVFVQ3dBNWx1MXB2RkJEMDI4M2Jx?=
 =?utf-8?B?bGFEUm1KYk5pa29BMnN0V1doNVpLME9RTCt0ZmVvejhZUUw2VTF3MU44T1RL?=
 =?utf-8?B?WkJSUHdhWkl5YlRiMk9MQ2EvM21mRFk1TjNKTlJnY3RmcVhyamk1T3RBdnUv?=
 =?utf-8?B?Z1F6Y1RrSzhjZm1nWDF6Tm41eGp6WDh2M3VqMEJweGNFdmJST0VUakdiZUFx?=
 =?utf-8?B?cUVGV2hhQnBtbEx1YVcvOGx1alBoT0VLYlVnNUQ1bUNCajVpYU5YenhDUGVM?=
 =?utf-8?B?bThFV0daeVpGUElqeDJsQ2FoaFlBV2ZwMC8wWjJmZUhYK0VRSmFQRUhnNkly?=
 =?utf-8?B?Z0pQaXN2aTRjKzFlWkJFT3hzR2FWTWJ0dlZ0cGNmOWI0K3RiRERtN0U4Z2lE?=
 =?utf-8?B?ZlRxWk1xMitNZFNrNGVLQndmWlNOaW80ZituVXdlZ0EwQzh4MHVydVdic2Nu?=
 =?utf-8?B?eUJVdThzNjZDTlRWMG1NM1VrditFbUczbU4xZmhnbk9FMit6bDN4VFRoTTll?=
 =?utf-8?B?Y0YxQVl1eTh0ZUVaS2ExQTNrMGg1THdxQ3dUNkVyWTBKWTh6RjFPSU5DNDFk?=
 =?utf-8?B?eXFYSFYrbnM1UVFSWVdZdDAwcGNjZC8vQlFyVmtWNGdoSzFOME1ESkVYQ2ZN?=
 =?utf-8?B?ZUt6cEhWdW9qVlNaQmxmSVRGeVJwV2lWaHhXYlhIZjM0UlhVdnVoWkxBQStz?=
 =?utf-8?B?cmNYbFQvQUJSeWJMd05PdDZ4MmNYazBhblc1WDhiMGIzUDZyOElwYnVjaStp?=
 =?utf-8?B?N090c0M1QkVMbW1Hd1FSU1RBQ0VOblhqVGRrSWhVWmo2L3V3dTU2NnBYSG1H?=
 =?utf-8?B?RWNPTVE5aUszcjhHYjFPQnV1MllQeE9oSWVYeEYxbGw1VytlTms1K3JiSVNs?=
 =?utf-8?B?QkYyMVloSGdiaDNhOUszTmNQa2tPQjduRDcxeldicVJ3T20vWWJuUHozQVBs?=
 =?utf-8?B?N084UzdZTWZuOTBWZy9MdWhaazdWeTBRUEdpb01QY0JtblBNZUxpMnp4eW9j?=
 =?utf-8?B?TytoUVNYdWRwZGpMS0hjNmNxSTlubXc3bDJQRzJsZ3A4bFdvVitxbWx6bloy?=
 =?utf-8?B?dXdFYVczOG1YeSs2c3l3ZTJZNGdkUUZiRmNLOFBwcXpQOXdnNS95cEszcVZR?=
 =?utf-8?B?bGVNNnk0UXQxQ3ZVM3YxZEYwYTllOThiZ3ZUaVM2QXBUUUsxVzgvWnRjcjIv?=
 =?utf-8?B?eTZHMXhNcVdvR2FZRFp0SjF1WjIxUXRmMWFvOHpHejF4aTZWQitIbnp3N1JW?=
 =?utf-8?B?VVVlajBURDl6Qm9vY0p3aEdJRSs1QkN0Y0RUdFhkWUR2RGVoWkdTNjFIY2VB?=
 =?utf-8?B?VWNUWWExY3U2enE3ZXA1THJrVDVOMWZBZ0FVZkloUU16WTR2TnZDNWtmSDhw?=
 =?utf-8?B?b1REbDJOM1ltdFRGTWd5R3hwS1gxYmV1TzRVSU9NbGNIK0xOQmt4eStNQUJ0?=
 =?utf-8?B?Z1ZlZkYzMGtocUljQnZRQmNQS1JkbjltcjZTZWJPWm52cWhOQ2hkWndsU25a?=
 =?utf-8?B?MHRDNFZNL0NZcG1BRTJRZDFYN01sL0h3VDdiQ1NlS29od1puc2VScmtMN0J5?=
 =?utf-8?B?SlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B539FAB11F5ABC418FE6649B155F5B31@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a2f0db5-638e-41fd-4e52-08ddb8e46c3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2025 21:15:36.3915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3c4bN0mkdI3fIwMw7zXCjSG7ixA+nmbe6Nb6DOncCw200UuvFa1KbSJ0A3LL8GkSsWpojXF2Zj0VoE0NZxwUGsQ/1MCGrRKxdTLIRDYy9EM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8718
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA1LTE1IGF0IDEwOjI4IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gPiBJIGRpZCBhIGJyaWVmIHRlc3Qgb24gbXkgU1BSLCB3aGVyZSB0aGUgaG9zdCB3YXMgbm90
IGJ1c3kgOg0KPiA+IHRkaF9tZW1fcGFnZV9kZW1vdGUoKSB3YXMgY2FsbGVkIDE0MiB0aW1lcywg
d2l0aCBlYWNoIGludm9jYXRpb24gdGFraW5nDQo+ID4gYXJvdW5kDQo+ID4gMTB1cy4NCj4gDQo+
IDEwdXMgZG9lc24ndCBzZWVtIHRvbyBiYWQ/IE1ha2VzIG1lIHRoaW5rIHRvIG5vdCBsb29wIGFu
ZCBpbnN0ZWFkIGp1c3QgZG8gYQ0KPiBzaW5nbGUgcmV0cnkgd2l0aCBpbnRlcnJ1cHRzIGRpc2Fi
bGVkLiBXZSBzaG91bGQgZGVmaW5pdGVseSBhZGQgdGhlIGRhdGEgYmFzZWQNCj4gcmVhc29uaW5n
IHRvIHRoZSBsb2cuDQo+IA0KPiBUaGUgY291bnRlciBwb2ludCBpcyB0aGF0IHRoZSBTRUFNQ0FM
TCBtdXN0IGJlIHN1cHBvcnRpbmcNCj4gVERYX0lOVEVSUlVQVEVEX1JFU1RBUlRBQkxFIGZvciBh
IHJlYXNvbi4gQW5kIHRoZSByZWFzb24gcHJvYmFibHkgaXMgdGhhdCBpdA0KPiBzb21ldGltZXMg
dGFrZXMgbG9uZ2VyIHRoYW4gc29tZW9uZSB0aGF0IHdhcyByZWFzb25hYmxlLiBNYXliZSB3ZSBz
aG91bGQgYXNrDQo+IFREWA0KPiBtb2R1bGUgZm9sa3MgaWYgdGhlcmUgaXMgYW55IGhpc3Rvcnku
DQoNCkNpcmNsaW5nIGJhY2sgaGVyZS4gQWZ0ZXIgc29tZSByZXNlYXJjaC9kaXNjdXNzaW9uIGl0
IHNlZW1zIGRlbW90ZSBzaG91bGQgbm90DQp0YWtlIHRvbyBsb25nIHN1Y2ggdGhhdCBpdCBzaG91
bGQgbmVlZCB0aGUgb3B0aW9uIHRvIHJldHVybg0KVERYX0lOVEVSUlVQVEVEX1JFU1RBUlRBQkxF
LiBFdmVuIGluIHRoZSBkeW5hbWljIFBBTVQgY2FzZS4gVGhlIGRldGFpbHMgb2YgaG93DQp0byBn
ZXQgdGhpcyBjaGFuZ2VkIGFuZCBkb2N1bWVudGVkIGFyZSBzdGlsbCBvbmdvaW5nLCBidXQgZm9y
IHYyIEkgc2F5IHdlIGNsb3NlDQp0aGlzIGJ5IGV4cGVjdGluZyBpdCB0byBuZXZlciByZXR1cm4g
VERYX0lOVEVSUlVQVEVEX1JFU1RBUlRBQkxFLiBGb3Igbm93IGl0IGNhbg0KYmUgYSBWTV9CVUdf
T04oKSBjYXNlLCB3aXRoIHRoZSBleHBlY3RhdGlvbiB0aGF0IFREWCBtb2R1bGUgd2lsbCB1cGRh
dGUgdG8gbWFrZQ0KdGhlIGxvZ2ljIHZhbGlkLiBTb3VuZCBnb29kPw0K

