Return-Path: <kvm+bounces-59052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D8432BAAD5C
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 03:05:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33D0A19225D3
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 01:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4685E1A9F8C;
	Tue, 30 Sep 2025 01:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UNw/KH/x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC92175A5;
	Tue, 30 Sep 2025 01:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759194293; cv=fail; b=N2YmdF7XBSy/Z/shGuSVvk4jTA1GYKTn9v200aCNX+dQcj7fspvmOLtYtuDXUNs20fp+HSoUqlbFs7TH4XjwNvbmxNk53mynrwxg/7CJHxtBpTKwhmC2gc4N/T/zS1StKyGyOp2Ue4J9YnqCYN9AhEP3ne9rZqls/ZaEPi9l+X8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759194293; c=relaxed/simple;
	bh=qsLPidYka/0TmWw07Ua474ufLAsjOdMJpKZt2on77Bc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T67lt7oof9QnYHU7eLlm3LtoW86vHQao7XMBDJTF/0sSq8oYDg+uSbbWP0YyMhS0XDJwkskpaqBT+0EDE/Ye85xomIpvhDYDLQjpdmoG2o2eOB1RR/Mluas5piBzd+Vc1fDTmQ3fv6jgudpt9D1BeqjMapg6Lsteae19ii9R9s4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UNw/KH/x; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759194292; x=1790730292;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qsLPidYka/0TmWw07Ua474ufLAsjOdMJpKZt2on77Bc=;
  b=UNw/KH/xW7YuTOAQqjTlJD84nMekJlji9YBkX+CO538WQAvX/ihDUann
   l2peMKPYNlSnldi5DhdyhctthYA4I375dJ3hJOVQZ4S6/8n9SIMrvS5RL
   zQ3+QW0lphOwnKyzY/MrNm58+wXfeGZpAc/rwsA3HEUmCHyMumXSBL3sm
   uERoUokVik9p86wRbPpByIc3YJFD2LHz3FaL2fJvxH6jqBUiZFfBgZBPd
   N7tIklEsoYmVi+RNwCOYF1R93NWJ8oC/Gk1FDq1NsYZJxJ72VrziqHTpz
   iiGweD7weMaoepCTRQu02citCggydI++lypDPx6k6iJj1zhA2LWj/XYM/
   A==;
X-CSE-ConnectionGUID: YMpnfPkpT7aTmNA83bjEoA==
X-CSE-MsgGUID: X0cQ/sjeSVa37JPwdMruYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="84057848"
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="84057848"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 18:04:51 -0700
X-CSE-ConnectionGUID: 9skF7bnKTrG7DC9OkPhhhQ==
X-CSE-MsgGUID: ba++7OHEQ7mI47+v7W+JAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="178768893"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 18:04:50 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 18:04:49 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 29 Sep 2025 18:04:49 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.46) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 18:04:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RVy3L31GM74a+OjBDp91miKXetUsYHAOV1wREj5+b5sc5M/pP1Dp7VdyxCl8NIMqSSg6N3ImUOdj9sfpPUEbv+oyLM6OuvvsKRVZNcMQ1jjyTIuRoa6LC55YReB8r3ALX6Su0zM9iZ9vE2Tya1jymC5pdgZasLIGI3szQUl2Vxiv/jY/6Y7kN0mDVViFEHymi7I0qqAmi1BHP3hREoNkdv8OzO+hMbFWq5rHwTOBtvXaWtTyon4P+csIMzyKvbjrI1ZRGHqhL7KtxdIRQx8FO15Ec5bdWDOCRCN7b6y9peVyFI5yPU5a1IlX4T4JeXweUIOYIU8fBPnnKASiXnYNtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsLPidYka/0TmWw07Ua474ufLAsjOdMJpKZt2on77Bc=;
 b=wm/f8uOef3ShfRK1Z2TgPd4JMraShAedaDZyuCLFVdPAdrAubAiyeERfkGv9SJpudQhNVH9QKEg9cfSmaKWZLi8fCtXl0wu9anMNmGLnqupZJqCEEfOEetWYFRovcoeZKphqi7VaKATD6p5KTHkcxjUs2YZjWUPF9EpvKEKLl1xADdIold7h70No1rJKWEA7VJI2WWPFxghRNejtumRQHBQsHtUPk6MzIgEq1H2CXT38sNisV3DvRFHIjGMjWPVCh2Lkb5WPL+KSBoyaxr3c3UkCtUEwNi6NC5j+fuWxgbU11HXPaOQjSICTa30Yl+KoUoc4JQSFr4qTGJn01Xg7mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by IA0PR11MB7308.namprd11.prod.outlook.com (2603:10b6:208:436::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 01:04:45 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%4]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 01:04:45 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Annapurve,
 Vishal" <vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 05/16] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Thread-Topic: [PATCH v3 05/16] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Thread-Index: AQHcKPMyqcZdyD86IkOkQscaglq3prSgakGAgAoUdICAAAd0gIAAdFoA
Date: Tue, 30 Sep 2025 01:04:45 +0000
Message-ID: <4e1a40459724f1d4169cf962acccbe471826b7e8.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-6-rick.p.edgecombe@intel.com>
	 <47f8b553-1cb0-4fb0-993b-affd4468475e@linux.intel.com>
	 <c8b69a9c5709d8bc482ce724f23da01e8d151727.camel@intel.com>
	 <c0590dca-13a6-4173-9b82-3604d26ce0c7@intel.com>
In-Reply-To: <c0590dca-13a6-4173-9b82-3604d26ce0c7@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|IA0PR11MB7308:EE_
x-ms-office365-filtering-correlation-id: f2974650-053a-4503-fd59-08ddffbd5895
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?R3h2WmFDWDlRTG0xZDVOOFdSTTVKM3VkaGtlbmVpRXdLUHdMMVpGZjlqUUs1?=
 =?utf-8?B?Y1RDL0tRc1ZnV25DOGhTMlRXdXB0RWdmVGJXVW45elpHYzBxNmJ5cXdCc0t1?=
 =?utf-8?B?Y2tTYU1WMjRCa0R2ZnFWZ2ZsazJ2Wkhtd3JEbGJWZmJKQlhQVXQ4TEdlalFY?=
 =?utf-8?B?R1RPb0lFcU9TMHhCNjl1SHduQjM4NzdxbkR3Y25tN09PYUQySGR5RDRTYzN1?=
 =?utf-8?B?UlVNYUh3bWNZYVV4RTVPTUdrZU1SN2llKzZrSHhWaW9INXJRN0lkRXdDeHZt?=
 =?utf-8?B?MXJ0WkRhQTZEaGQxcFpTQy83RXJjeFRrSE5XTWttWHllQ25VK1RoV25UWnhq?=
 =?utf-8?B?UERTbFRrd2tTU1JXTTNaYWdJQXlGdG05blVPMmVZZEd0dXFTakI4YjRyZVg5?=
 =?utf-8?B?eDFYb0lRbjBsbDk1UjByaEJPSXlXaVVnaFZldTdxM2owQTY0N3pybDg3Skpq?=
 =?utf-8?B?UkJVbVRENUc2UzdDNFlMVnZrK2VyRmcwamFoR1U0NUgwQUozbU1rWFJvRjls?=
 =?utf-8?B?WFA5RTJlc2U2UGZOTGZjTytLb1RnT0pQRVJMR0ZhcHJHdXpLRTZzVEhWM2k3?=
 =?utf-8?B?UFpBNys3K04zSVdHdG9FQi9kZmhEYzJmWVdsbW1BTVNSNVlRUWd2VXV1KzRX?=
 =?utf-8?B?QkVQVm1oMklkZDg5akpJSXlCRkVOMlhHcVAvZVJHbGp0MTloNmIyWDV0UzRS?=
 =?utf-8?B?V1c5UGdWVEFYQWdPSmVDU29mL1dBMUYxSktud1lqQnQrNW1OWXJ5dFVDd2JU?=
 =?utf-8?B?QUUrZVpmaWQ2d3NrckRrbjBMQm5lRk1iVGIydURGOURIemFlMjJSMGUxcU5O?=
 =?utf-8?B?M01DZWp2N0pjcTVLMWU4S3MzcHRHcUVhTnhGNW5ZL05GMHBOWS9uUUJKSERR?=
 =?utf-8?B?OFVacWJWTE9xc2JhTG82ekdrcGpQR1NzMStCWHNwRHN4M3dEVGRNcVRZaGkv?=
 =?utf-8?B?RXpYb2pIdXQyclh4VitOaCtHeGx0WmNQTDV1OWJ4M3MxQ2NFb2drN1BDdmQv?=
 =?utf-8?B?RlRkTDhOdWJIOFk4K3dMUjRHNFNzT0xLSVhmRVZCeEJNYUlPMEVwWFBFL0Z0?=
 =?utf-8?B?bTAxcEhxRG5FRHpqUm9WQWJHa3pTdFYrckhHcnBpU3JkcVRiQkFaQVNObktt?=
 =?utf-8?B?NmM2enA5Z2RWbTFYRXVVdDNIRzVtYnVNUHlDeHNDVGN2dEY1RFAvekhBbkVU?=
 =?utf-8?B?Y283UFl6bmU3RnpESkRiWTY3WTVKVm9lN3JkcURTMk9YYmdqVWJMcG5Dc09m?=
 =?utf-8?B?WmdYdThQQkNWaVNvUXZ0MXlSbFhCK3p5TzNzOUNNZXJHYmxYQkNuWXpXUW1a?=
 =?utf-8?B?TXNsRmlsNUd4MWlkRFlJNkFQTFlLZExwbFN6RFRqZ2diNmh6aVNpVlJvK3ZP?=
 =?utf-8?B?SjN1RHNVaURvL2QzZ2NOczVYc0d5cG1ja0NHYWo1emhFNTJ4MUxMYWZ0UVg0?=
 =?utf-8?B?U05uTkFOMUUzMXNuYnRLOTRRWkh2aTh5V0lpT21uR3NmamlDTXJBTmpsWWMv?=
 =?utf-8?B?RVYwTlkxK2k0V3psWHJFRzF5aDc3eXJ4VllFMVpRTGRDNHVJMkZRK1FZejFV?=
 =?utf-8?B?WDU5ZU90bXFKVWtkR1JtanJiekNSTXdmeGcrMEtlQ1FHekJDSXpQQnh4aUQ5?=
 =?utf-8?B?QWpaM1dWMmJEMjIwZnhXcm9ML3dnL3lhZjU4bEhUSVBtMzhwU3E3cEtCOVdN?=
 =?utf-8?B?WUhIcmErMmY1OUp2SzBwUTNTeUJjb29HWWQzVU9meVpqd3hTZG5jZkYrNTdu?=
 =?utf-8?B?Y2JIRVVwb2xoaUVQMzE3QytFUFBBaUdzUllKY1FNRzA0RVQ0UmhzZVBwOWg3?=
 =?utf-8?B?VlB0WFk1cjY2V1BHYlg5VFRXZVl0SlFKRDhvdG84QzhTL05ONnBkS052Qm5n?=
 =?utf-8?B?LzFZdW1qL28zQ1Vaby9MMyt5MHdrdnhVa2hpK0hwS3o2Q0xKbUZaN3hFTng3?=
 =?utf-8?B?Qm5kNmdHUmdKUmhTdVpCZ2JsU2pxSlNLdUpEc3BObVlRaDJEajNKdXhEUHpQ?=
 =?utf-8?B?bUtGM045REtQTStqaFBFb2JrVTZyUkxmT05CNU1sQmRBM1oxdGowUE1IOTJR?=
 =?utf-8?Q?YBzKke?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RkducGR4ZXpFRGd2VDZXK3ZvTk83YTlOSXppT25qZWxDMzcvNzFNZTNVV0Vh?=
 =?utf-8?B?b3JmZ1ExV1VuZ2RCdkZ1VEd0alVPZ2hnY1FDdFYwdnM4K2dmaHh1RGJOQzI3?=
 =?utf-8?B?ek5BZzV3SzNlV3dOdVNCOWJRWkd0U2dWbWJ4blphTXpoQXh6Nll2WC9RNWhH?=
 =?utf-8?B?TmxmVzQxZGN6L0lveTcvaEpHUlVuMzJ1bWRMOUwwQWZOWjFBVllqV01MN1dZ?=
 =?utf-8?B?cGdNUW05S2pqWFAzdGJvbFhWL3lXUjlSS1BaWEFzZjhqUi8xS0N5NlYrN0t3?=
 =?utf-8?B?RlNMZTFlMjMxRmVPRk0rT0ZGVnVWdEJYblhwYUZ2NUlwZS9hQy9jRjBsNjZR?=
 =?utf-8?B?bi9DS0VjMnIvNUxlNDlnc3krRjdSeFY4dDZ5b2RoOEF2dC96TndoalN3V09L?=
 =?utf-8?B?SitvVCtjRWZ6dFBabUdTcks1c1FKWFJEN04wcXBzOXVtbHVzYW9pYWJQS0JQ?=
 =?utf-8?B?ejJaZjhOaHY0SEo1V3pzMTNvVWp4STl0c1R1ZVgzRUJYY0hJZUh4Wk9DNmsz?=
 =?utf-8?B?L041d213M0ZPSmhIakNnR1J3SWV4dzk4L1hPVWJGNjNTV1FQVW41S2R1QVdv?=
 =?utf-8?B?VnZSazdYc1laM0hkS2JYR290VVZXNk1BdzJmUVBFTExBa3FwRE1IYW43ZDNz?=
 =?utf-8?B?Yi93cWREem95NldKb3NGWU9OK2taYkp2TlRVZDU5bW1mb1ZIa1kyQVYrV1lG?=
 =?utf-8?B?emltcHcvblprUURzRnlMekx4Rzh2NTdib0NwODI5T0NoZkhLUDNuK1RPMlAz?=
 =?utf-8?B?VCtSRXk1a203Smd2aGVnbm5VQmI3aGhxUHJXUGRLQVRKL3FVV29ZOXFKSkxu?=
 =?utf-8?B?Zi9CbHArUzlkcndBcXFzeUdhUFV5SGpxeEliZldnNDhYeDhoY3FFWkdtb1hC?=
 =?utf-8?B?eTBGNEVjWkZHeFozWUc2M2lSY0d3eWoySDVFWVI1M3FiYW5TMGZlZEtnb0Zj?=
 =?utf-8?B?RDZLQVJWZkVIeGxWN0ZjaGNSMk54Q3NIUUdZTi9UWjladjJEV3NjakRYTjNW?=
 =?utf-8?B?UVBGTDZERU43bUh4NUhRM3Z0NjlaSXlXQTYyb3JLMVA0aG8yZ056czcrdWhL?=
 =?utf-8?B?aEVWNFNUVEYyaGdPZ2kyam4weVE0UUcxZHMvZkFaZngzLzAraW1XcVJvRUN3?=
 =?utf-8?B?VFUwV0drY3dscGRPNnpxeks0TGVtOGVhUTJEeEsrVCtBb2xWaHRxSHU2Sldt?=
 =?utf-8?B?Ukh6V09Ba0o3SlB4Q0M1ZGNuVUhBR2tLSjlYdVBYbEFQS2tsZjM0TndvdmV1?=
 =?utf-8?B?b2FncHJpZ2Uxc25INFU1eElGT1hLNXJEM25HWmZnMk10NSsycy9ENnZCWHd4?=
 =?utf-8?B?aGdzayszenNDdGVMaWRiRktWa1MzYnM3RUZGM0thMytxVGxSYitwdURac1Jk?=
 =?utf-8?B?QVE4MFdMaGdxN2FsY29pWk41eTc2dXJWdFpXRHplUVF1bE5GYXFlODJpNnhv?=
 =?utf-8?B?ZXhZcVM1eis0eDJ1ckhMN1ZpRkFKQzdNdWdYUnNpT09CbkNZeWt3Qmd3cS9j?=
 =?utf-8?B?L1NRZEd1Nm10Zm1lRU9MMEtYa0NjaUZ1YWtFdXdUQklEWm5IVW4zNkhxSm5V?=
 =?utf-8?B?Q3lMOVBMd21TRnZPQUMrRFoyZFgvY2p1ME1DOUlWYWNub0cvWWxtY0l6NXky?=
 =?utf-8?B?Nmd4cnZoeTlzNFB3SEpONDJpbmFqSXZiOTlPNkFGTTIyUThpZ3hKL0xISGNj?=
 =?utf-8?B?MTRwMSt2TEEyQXMyb1JEcDZ1VGdRcDFVRFhndnpUYU9TaGxpZFg1bEN3YWpj?=
 =?utf-8?B?UisvVWUrbG1rZ25VRG5qNWp4QWNLOUcrMmVOZkRnbThvRlJYTVA0QzZBS3Qz?=
 =?utf-8?B?Y0tzeUQxNTRxaEVaZEFVK0FnYndIb0lXYkJEaTdYMWsyRlhVT3RrV3AwdWNO?=
 =?utf-8?B?eXEyaVFCYjVBb3UxNDlKaXRlbGt6dS9pVTIwV2JEWWJMb1I2RDd5ZCsreFAv?=
 =?utf-8?B?dnRGNHhKTnNpTGxVcHUrNVVBS3VaQ2RXUEZFZGREbHJzMnJwUmRXRkVxVXkz?=
 =?utf-8?B?R2UrZTRkYU12YTRWOTUvQXlLcDJvL3VOcy8xa3E1dHJ2NFVoZjJMaWtMd2hB?=
 =?utf-8?B?dUFPYmpQVG1GYUlvdXdpWnRHaUpXclFsRTRhaHNhVTNtcitSbm1MdEYzYjVs?=
 =?utf-8?B?anFzYXlmaEFMVm9zN0ZVeG1mSGZyeGtOOHhSWlIyR0w5VW1IYTMwUXlKSElQ?=
 =?utf-8?B?MWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E3A0D486C8798409110CE6B7F06522C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2974650-053a-4503-fd59-08ddffbd5895
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2025 01:04:45.6038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RGqX03npJ1XDwyk0B8B0MIjrK/fbK6yQJ9zDiOKJddCGJwKVxZkD87UNQ7uYa1ezcPRXrAE+3fpeAs/4el4Uz0aPpqx9StF1uaI30zxAmwQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7308
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA5LTI5IGF0IDExOjA4IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gOS8yOS8yNSAxMDo0MSwgRWRnZWNvbWJlLCBSaWNrIFAgd3JvdGU6DQo+ID4gT24gVHVlLCAy
MDI1LTA5LTIzIGF0IDE1OjQ1ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4gPiA+ICsvKg0K
PiA+ID4gPiArICogQWxsb2NhdGUgUEFNVCByZWZlcmVuY2UgY291bnRlcnMgZm9yIGFsbCBwaHlz
aWNhbCBtZW1vcnkuDQo+ID4gPiA+ICsgKg0KPiA+ID4gPiArICogSXQgY29uc3VtZXMgMk1pQiBm
b3IgZXZlcnkgMVRpQiBvZiBwaHlzaWNhbCBtZW1vcnkuDQo+ID4gPiA+ICsgKi8NCj4gPiA+ID4g
K3N0YXRpYyBpbnQgaW5pdF9wYW10X21ldGFkYXRhKHZvaWQpDQo+ID4gPiA+ICt7DQo+ID4gPiA+
ICsJc2l6ZV90IHNpemUgPSBtYXhfcGZuIC8gUFRSU19QRVJfUFRFICogc2l6ZW9mKCpwYW10X3Jl
ZmNvdW50cyk7DQo+ID4gPiBJcyB0aGVyZSBndWFyYW50ZWUgdGhhdCBtYXhfcGZuIGlzIFBUUlNf
UEVSX1BURSBhbGlnbmVkPw0KPiA+ID4gSWYgbm90LCBpdCBzaG91bGQgYmUgcm91bmRlZCB1cC4N
Cj4gPiBWbWFsbG9jKCkgc2hvdWxkIGhhbmRsZSBpdD8NCj4gDQo+IHZtYWxsb2MoKSB3aWxsLCBm
b3IgaW5zdGFuY2UsIHJvdW5kIHVwIHRvIDIgcGFnZXMgaWYgeW91IGFzayBmb3IgNDA5Nw0KPiBi
eXRlcyBpbiAnc2l6ZScuIEJ1dCB0aGF0J3Mgbm90IHRoZSBwcm9ibGVtLiBUaGUgJ3NpemUnIGNh
bGN1bGF0aW9uDQo+IGl0c2VsZiBpcyB0aGUgcHJvYmxlbS4NCj4gDQo+IFlvdSBuZWVkIGV4YWN0
bHkgMiBNaUIgZm9yIGV2ZXJ5IDEgVGlCIG9mIG1lbW9yeSwgc28gbGV0J3Mgc2F5IHdlIGhhdmU6
DQo+IA0KPiAJbWF4X3BmbiA9IDE8PDI4DQo+IA0KPiAod2hlcmUgMjggPT0gNDAtUEFHRV9TSVpF
KSB0aGVuIHNpemUgd291bGQgYmUgKmV4YWN0bHkqIDE8PDIxICgyIE1pQikuDQo+IFJpZ2h0Pw0K
PiANCj4gQnV0IHdoYXQgaWY6DQo+IA0KPiAJbWF4X3BmbiA9ICgxPDwyOCkgKyAxDQo+IA0KPiBU
aGVuIHNpemUgbmVlZHMgdG8gYmUgb25lIG1vcmUgcGFnZS4gUmlnaHQ/IEJ1dCB3aGF0IHdvdWxk
IHRoZSBjb2RlIGRvPw0KDQpEb2gsIHJpZ2h0LiBUaGVyZSBpcyBhbiBhZGRpdGlvbmFsIGlzc3Vl
LiBBIGxhdGVyIHBhdGNoIHR3ZWFrcyBpdCB0byBiZToNCisJc2l6ZSA9IG1heF9wZm4gLyBQVFJT
X1BFUl9QVEUgKiBzaXplb2YoKnBhbXRfcmVmY291bnRzKTsNCisJc2l6ZSA9IHJvdW5kX3VwKHNp
emUsIFBBR0VfU0laRSk7DQoNClBlcmhhcHMgYW4gYXR0ZW1wdCB0byBmaXggdXAgdGhlIGlzc3Vl
IGJ5IEtpcmlsbD8gSXQgc2hvdWxkIGJlIGZpeGVkIGxpa2UgQmluYmluDQpzdWdnZXN0cywgbWF5
YmU6DQorCXNpemUgPSBESVZfUk9VTkRfVVAobWF4X3BmbiwgUFRSU19QRVJfUFRFKSAqIHNpemVv
ZigqcGFtdF9yZWZjb3VudHMpOw0KDQpUaGFua3MsIGFuZCBzb3JyeSBmb3Igbm90IGdpdmluZyB0
aGUgY29tbWVudCB0aGUgcHJvcGVyIGF0dGVudGlvbiB0aGUgZmlyc3QgdGltZQ0KYXJvdW5kLg0K
DQo=

