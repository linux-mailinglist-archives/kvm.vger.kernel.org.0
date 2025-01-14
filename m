Return-Path: <kvm+bounces-35455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8A6A11406
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53C5B188B419
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 22:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74097213221;
	Tue, 14 Jan 2025 22:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lsrDeSSp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9B91FC7F6;
	Tue, 14 Jan 2025 22:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736893515; cv=fail; b=ZRJSrNQ/ODQdVM0YJhwyde7U4lDaCIkcbM7bhJyiuQHRlKqiHU2gI47PWYWBr6YbbVKqy6jgQSSj0VUO23fDoSmEwlMc6DpGdP2WXo34O3DR6Ey17VDz4DiQdqzarzRGfF8GE4R49baLAjfb8U+PrqauY0sr8IJtst+BRDCbmJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736893515; c=relaxed/simple;
	bh=oFiyl+9eRjpl6nYzXoMPak7yytIj1Xewqy18TIcQ1Sk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hCZbkdVnxRVUuDUQ+AbyAL0XFcg/4WfOoOcYbbvjkJt/zkHBVrKvtyMMKGGHJGxDfhbX2zJrE7WWeSseR4yy9P+ePZ96Q+C9z/JEYk3fE5cEBnX7JhAsNNFUhG1Dg4Yv8D/I3jLCozCKv7js/uhV5NmziO6+hAhntP0yE0PSSd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lsrDeSSp; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736893514; x=1768429514;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oFiyl+9eRjpl6nYzXoMPak7yytIj1Xewqy18TIcQ1Sk=;
  b=lsrDeSSppS/x/0lAqbEWFYKpSJMqpZ+uonlkKa1JigMWA28SqQEN857I
   rmtfQ6VxTckhCg9/bS3KJqCj+txjwk/yXPXhFAg891R3I45pHQyJwDpi4
   c8dUHSgwB+ZxWf3nxQllKlGRhlRbqOHxSKx3SPFu+aWWPGFVF3Jm1U5VW
   WZlt6n2Io+ffGVR5eDVwC5UgM4WvZY7++5yCugMuBApopEKHBWqMlNMaQ
   iOZ4Qk+jOJN8viCzTFpcHKT0iT0eQLh3bBfTPpoK8P7GZlDuISTS6Yt3M
   V0Zs29aPLKqnFEVWakgOAdXEhCDsm80Cfgc66lPVt0tar2C1SbdyEYTjZ
   g==;
X-CSE-ConnectionGUID: HfuWfMVWSyGvy6KKknycCQ==
X-CSE-MsgGUID: Ashw+kGRRx+hadW9vPTI6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="37237055"
X-IronPort-AV: E=Sophos;i="6.12,315,1728975600"; 
   d="scan'208";a="37237055"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 14:25:13 -0800
X-CSE-ConnectionGUID: X2Jf6fS9RdmpZtoddZe4/w==
X-CSE-MsgGUID: bJDH6UIeTW+YYuuCPL84zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,315,1728975600"; 
   d="scan'208";a="109912485"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jan 2025 14:25:14 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 14 Jan 2025 14:25:13 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 14 Jan 2025 14:25:13 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 14 Jan 2025 14:25:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hRyXs2yWWiruYvb2nEd3mCpGszNw+2sCBY83uf197OM8xUP/H5y6OHker8J4qvr0Rm/TzBE0KxjpYcrJshhXWth4n1nDQmvbkPCnvs5hnppJmbCUo7bI3q9lOeBkdOJ2WKhO1ztQhZLJrHr/V2drzcFDdo8SpHEE3vKkoYm/K1+63uicqNMfDQyD3+MyF/5TNN64hhe/u2YwsPr4Wwuu9G1ksqXZaXa0Yc+TMGtKAvM48SKEbLEMCU3s30jerVGp5AQgsbTvK+qvjW9nzlj9KfgqXCbj7BHVlvmqxJ6bzx+sF22J++uC0I8uBSBoSJUApMgK5iFq/9pl7c9OudCcMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFiyl+9eRjpl6nYzXoMPak7yytIj1Xewqy18TIcQ1Sk=;
 b=DGVjGVtDqAXZvfDiGkMuUqrRMfrHoEz7bPoakiUCMYK52jRfXrVcg99ZN4gVAuW7t+eHdP+LKHaaF9ykYv7psiG3DCXC+QZ1VH1TvxjrqCJo57wlIcg2J/9tsrdWT9CQBXJ5MfdU8wKii7XTz5WHBF9P6r6HUDh2q1jqXs9chI2Dl3GCqt55DohOxhceFcmNfnH6UXqmgKnssNLMi80bkQukLawmWEKYa3ru+4VnOH20X0PK7o2CmTQ3nZvEF8jKOY/JGuwQzmvMlP9iprOxTiYNhkyN0BvHAvzP9m6zlAz9bUQG9UVlweEGOe9aGJQ3f0hzMCvRY22Arx8A8IE5NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7674.namprd11.prod.outlook.com (2603:10b6:610:12b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Tue, 14 Jan
 2025 22:24:43 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 22:24:43 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Lindgren,
 Tony" <tony.lindgren@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH 2/7] KVM: x86/mmu: Return RET_PF* instead of 1 in
 kvm_mmu_page_fault()
Thread-Topic: [PATCH 2/7] KVM: x86/mmu: Return RET_PF* instead of 1 in
 kvm_mmu_page_fault()
Thread-Index: AQHbZWChwWyFRdNReU224Mtyyy6GjLMW23UA
Date: Tue, 14 Jan 2025 22:24:43 +0000
Message-ID: <a7b8151808b82550c7c5b5bfba69d334383cb2ba.camel@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
	 <20250113021138.18875-1-yan.y.zhao@intel.com>
In-Reply-To: <20250113021138.18875-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7674:EE_
x-ms-office365-filtering-correlation-id: d217ebc1-648e-45ff-e6d3-08dd34ea3e7f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U21Ldzk4UythNXYzMUkwb2J4V2pYa25xRFZlQnRFakkrNkRLZzMxOTVKSGs4?=
 =?utf-8?B?WDFLVU1CbGFpS3lWMURld0FBQ203VThDUUtsZjU4Q1MxaHptenA5RlltSjlU?=
 =?utf-8?B?bjhrUFMySCtiSE5qbHQ1L0s4cW5RUTFkVTBxQ1MyR2JmREk5UDlkSkZZWUZj?=
 =?utf-8?B?ZFY3VUo5dmVQYnJDZExqZUJGNWhMWm9MOCtVTk85UUp2STZiaEdDTm11Vlpl?=
 =?utf-8?B?bk1Ldk4yOG5wWXpKVnh2WUVVZTUrTXIzdFN3aENPd3ZaYnBXaHNDbFpBSVdN?=
 =?utf-8?B?ZWE3Z05TRGV0cHQ0K0pTdjZlczlOZVVNVmpNc3VISS9qNVZVOEJsSjR1WXhX?=
 =?utf-8?B?T3FoUC9oZm9PaFBCSGo3YVh0SExZayswZUJuVGRiU0VzdjhRTk1QVlNRWDEz?=
 =?utf-8?B?cW52b2wyVzM4S091K2JOOFRxK2FZVGdOQ3JDUTBwRU5LYUloekVJcE1yNTNO?=
 =?utf-8?B?K2dULzROOFlOTk03KzNnVTBCRHRVOFVWMHMvdFZLUkx1RzBlaVAvUndmNWIz?=
 =?utf-8?B?b0IwRUhlSXV0Z1ByOGszU3J2UHpHZzZBc3hDaklLM0RIUnBqNXo0cVN5MlhJ?=
 =?utf-8?B?RUZsRkVWcEg3RzBiUDVLMmdSZTRFQzFkMm80ZDJHMzZxblVSY2dFUVE5TTBR?=
 =?utf-8?B?cWFmWW5veVBGK2FhV2swZkordFhXdHNMYmhCUWtXNmd0YlRYalhFRHNBeXhr?=
 =?utf-8?B?MWtmVzFYVTN1VWprQWpoQlNMdTFJY0V0bWJhRkxOa3M3Y2l4eDkzWk5JK0l2?=
 =?utf-8?B?bWRRYlRyTlhycjlmRWR0cmloeWI5d2JrM29RenllbW5pWFZuME1NNWNNQk5V?=
 =?utf-8?B?RFRHUTVUeFZnM3JaZlpDTkVaS1NpdVpFMWppUnVhSE1pc0picWlPNlRCQ0ps?=
 =?utf-8?B?Nm54S2JVSVd0S1VYeW1CYUt5cUE1aUlVWTd3NzkvaGMxRk9KWWNpdkhYR2c5?=
 =?utf-8?B?YWhTOWJWMUFwK3d2eWdwV2pqZWN0cTdnRkRBV1dZWTlTNTVUL00zVndPSzM3?=
 =?utf-8?B?cFV4dFg4Nk9VL0hFcXcwbTJNeXNrSXlKU04xSnF2TmlRUW9wV3JQL3ZrSEht?=
 =?utf-8?B?RFgyWW1tT0ozRFJQOUdkZFAyUHZ3ekF2SE9Vd2VKNldwSkVnbFI4bVVFK0tr?=
 =?utf-8?B?QVI3dHZ0REVzSERWNlRhRCtrS2JwOE1ySDQzRE1IVGw3d2VGRnpmZDVSbC8y?=
 =?utf-8?B?UnhiZDN6MXp1dkNFaDFqbzN6QitrV0VFOHo5NjNZYnVEWmgzWURLWTVKRGl3?=
 =?utf-8?B?RkFkc0kxZkZkTlFqaUlNQ3hiRXIvL2xKZVNxUFVOTmpvY2IxTE4rbkJPRWh4?=
 =?utf-8?B?MjVWZjhIUEttMk55QVVrM3Ayd21OdDAyVUwyY0hBVTJqYUFUVFVrZnVxdHcr?=
 =?utf-8?B?aHRnYjh5R3VHOUtBSmJoZDRPU0lqak5UUTNTTnpUVzlOUWRLTXU4cFJsMWpF?=
 =?utf-8?B?eE1hSzQvWU5FRFBjUHQ5ckxjL0VvelRVOHNMMFIvN2FyR1dYWlNlNWw0U3hk?=
 =?utf-8?B?ME1STzZnZFBoTG5lUERiaVNTNzhUU2pLUVc1OWtKanRGcG1Mc1RLdmVJZ0Nx?=
 =?utf-8?B?WDQwOERLSU9WbWpHbkNFV3pleEJtR0xEcVdyb3Q2QzlESzVlRHdmckZjMEc3?=
 =?utf-8?B?QmxTR1JCUjY5VlBLN1hZaDVrUS9UUm80RExQLzVaYjhnUytFSXZRQUY1Mm01?=
 =?utf-8?B?RzZibDlkUGlpWWZXSFRLL1BldXFBNTZUdG1hMlV2d1diOUY5RGt5MzlnZXNM?=
 =?utf-8?B?SHREblJtSFg2V0hTclJFVEJtRW9FY0ZHMlNDakJ6TGQ2dG41NzhGS1RmdVky?=
 =?utf-8?B?djNMbE9ETXlpdzVoQ2V2R3lOMmx0cUQ1Q1hSSmowTzVINE9oZ0hSdTBKZkV4?=
 =?utf-8?B?dlVxVVZ2RVRpQ0dGMW0ycXVOSjNmdXY0MWF2VENVaWJjM2xyWjMvWmNNZmN6?=
 =?utf-8?Q?Go4+ZyBUkGMWnpiGBv+M5jfp0eQgjUZ+?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlJEVUxBS3VyVmhCdVFpcnFuMEFKN0VmQURjR1lsbFVLN2M3cVB1SHRJekRT?=
 =?utf-8?B?YXUzRGlsdW10NTFZUXFPanh4bnVaM3FoZXF1eGYxbU9Jb3llM1RFb04rU0Zp?=
 =?utf-8?B?bDFoaTlxR0RJcVkxeWUyMUdNZnVFZCtRK3FtZ20vVHNacjE3RFMrSjB2U05z?=
 =?utf-8?B?cVJDSXdoUVU3YTJPK1R1OW1LNkJNV3V3VzhDeW15NXhxN09XcWR1NERrNmhO?=
 =?utf-8?B?TDRheWRlNVlobStUMXdUYWhzNUxNZDlUbVdPN3NRV1ZYbkVTOHNRbm9Xa3lv?=
 =?utf-8?B?V2lYYkoyVWgyRTRvdlZ5bGg5RHpQOUtRK05FUUFCaGxYN25YMERrejZuNkJQ?=
 =?utf-8?B?ZDdpbEpxcVpmUU9lTUxaOHVyQW8vdXZxZW1IL1J4VklNL1ZaaGU3SVd4ZGdP?=
 =?utf-8?B?OVRpL001TjlLN2Q5ZW9KWUFpUFdFMmJGVGRmMWFtb3liZHYzbmRVcFRBTzZP?=
 =?utf-8?B?SHV6QWN1V25vTnFiZGo5TEFycXRCSDQ3VXJ5aEFRaFBuaFJiL3lkS3VVRDFB?=
 =?utf-8?B?QUpMS2VjaTROQmV5QU1xYXdxbitMTG0rUWl1ZzFQK3JNRXQ5NklsYlVhS3ly?=
 =?utf-8?B?cVpjdU5ZR1VteVBnUHAyVlVDN2RyYU83c2RjOGxSNmsrd2JTWjFFYW5zV09L?=
 =?utf-8?B?YjUvNDY3aW9aSStMdDF1SGwvV3Z6T1Yxek9MS3FobXRpcklLRUhhalQ2RjVa?=
 =?utf-8?B?NjAvRW8xUlZ3blczaXUzQms4UW8xQWYzeXdRbnBLbkFRU1Z1NXBRc2YwSTRM?=
 =?utf-8?B?aXh0QmhXQkFISFgvTEhRVXVKYU8zcEl5cEJVcm9mQ1BOam1vUEI2U0F2a1JE?=
 =?utf-8?B?SVBPdTFvSFAwbmFEeW5jWWpOM0MvSU1xYVF3d0FYYTFtVkQvcThFNm9Fa2JN?=
 =?utf-8?B?aEVkV3Byb045MWp1QTZqRXdLeUJHSDJmQi9OcGszZEpzRjdabXllaVpxZkRU?=
 =?utf-8?B?dUg4V0Z1UmR2bG9xQkc5ZURGUmpxeTF1TnBKQ3U1M0FXdzZRZUY5WGlBdTM3?=
 =?utf-8?B?QlcraTNZZ2ZOdHhQTHBtZWIwMHBQTENVSEdLRSthUE1TYzE2MGQvL2FsS0R0?=
 =?utf-8?B?Z0NYQndUc0tFSy9PTE5DOGxkeEhQMGhBVWhQMFZWdVhGNGsyNG0rRzN0SGlw?=
 =?utf-8?B?bkJuZkpaS2djVHRkOUxKYXhRanF3ckVGSmlUejBLMEpoYjRXM1ZwaTI5eHor?=
 =?utf-8?B?RjBPY1NBVDdSOHlUZE5VcnU0VEt2ZXRoODUvZXk5RzZmSHQreHZ2U011c0RE?=
 =?utf-8?B?bzcxN0pWUlNidkxBeUlYdHU4MHRTblVNVXNlTHFZckQ0V3ZzaTVMbFFVTmVo?=
 =?utf-8?B?bTBkVm10MDJMNkRwYWQ5aXJISVVPUzhtNFFBS2pzdS9WV2NGTUM4a3A0NUQ5?=
 =?utf-8?B?b3VYbk9mcUszbWRrTi81bWNtQ1dURlZINVFQYTFFYkx4czNseE9DUWdnWlE3?=
 =?utf-8?B?K1BhbjZzaDJtcU5ZRFEwbjBxQlRJcUp2UUlBUEZ5Q0xoMlJvRlk4MUdSK0tS?=
 =?utf-8?B?SWZCd2ZQVDJWRk1XYUN0Wlg4d1FHNWtsT2paRmVxNDVOUjRZUW9FZVljb2hE?=
 =?utf-8?B?cndRTGNZdmhtSmVCR3N4RXNoaEs2OGdwN2ZuY2xhbFpwUnk1RzJCamY2eFMv?=
 =?utf-8?B?c1ZWRjV4TktCcnVZVFJSYjV5UVBMOWNEcFN2UWkwODBTQzJmcHRoeTJYSVRN?=
 =?utf-8?B?YitrTEZ4OUZsbVNValR6eHNXOEd2ck96M0NZRXVVdFNUTmk2UFlTNzJUWFQy?=
 =?utf-8?B?V0VGTmtLelVBNGtPSlZUTVdvTXZkeEhxYlVPdm1vOS9qdHpwZlV2RmMzR081?=
 =?utf-8?B?UXIzUmJFaXFhaDZBS3VKRTFCcGRUNXdsbVZjcFJESGxjVC9vR2thSWp0Tmt1?=
 =?utf-8?B?WWE1OWVLcVgrcUtCL2ZvMUVVZ0lKcHlZS1NrRnNhUm80TUFMSDRydGdhOEcr?=
 =?utf-8?B?N1hlTUppL285aEtnMThHNkZqd2ZHQzFRUnRpSFNhaHduMWViOUt2dTlPQWI1?=
 =?utf-8?B?VFRrOHBucnRUL2lOazlXZVl6K1hDdDBDUk8zMDVHK3dZQ2ZaOS9RQXBPb0Fa?=
 =?utf-8?B?UmtQOWlORkFzMHpzb05VSG9OdENGQWRwd2VZMEVTNFZGOVlySWhhWmo2SEM5?=
 =?utf-8?B?amhEVTJQdTVjQ3RLVmdrbWlKVTFoZ056NXJySGg3QWFITmVOd3BVbW1lNG9K?=
 =?utf-8?B?elE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2E6875B39A9CC43B43969D1F8C06219@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d217ebc1-648e-45ff-e6d3-08dd34ea3e7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2025 22:24:43.1881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V2XtrV6+yIX9lq5XV7Q5WAW9Me/VT2r+f1DYSTmNVyvukLi8ZMbJBbGI9ZKWyNDOgJ82HlI9CrQXQkiUbK3uFKu6nZqzDHPilOC6lz872ds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7674
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTAxLTEzIGF0IDEwOjExICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gUmV0
dXJuIFJFVF9QRiogKGV4Y2x1ZGluZyBSRVRfUEZfRU1VTEFURS9SRVRfUEZfQ09OVElOVUUvUkVU
X1BGX0lOVkFMSUQpDQo+IGluc3RlYWQgb2YgMSBpbiBrdm1fbW11X3BhZ2VfZmF1bHQoKS4NCj4g
DQo+IFRoZSBjYWxsZXJzIG9mIGt2bV9tbXVfcGFnZV9mYXVsdCgpIGFyZSBLVk0gcGFnZSBmYXVs
dCBoYW5kbGVycyAoaS5lLiwNCj4gbnBmX2ludGVyY2VwdGlvbigpLCBoYW5kbGVfZXB0X21pc2Nv
bmZpZygpLCBfX3ZteF9oYW5kbGVfZXB0X3Zpb2xhdGlvbigpLA0KPiBrdm1faGFuZGxlX3BhZ2Vf
ZmF1bHQoKSkuIFRoZXkgZWl0aGVyIGNoZWNrIGlmIHRoZSByZXR1cm4gdmFsdWUgaXMgPiAwIChh
cw0KPiBpbiBucGZfaW50ZXJjZXB0aW9uKCkpIG9yIHBhc3MgaXQgZnVydGhlciB0byB2Y3B1X3J1
bigpIHRvIGRlY2lkZSB3aGV0aGVyDQo+IHRvIGJyZWFrIG91dCBvZiB0aGUga2VybmVsIGxvb3Ag
YW5kIHJldHVybiB0byB0aGUgdXNlciB3aGVuIHIgPD0gMC4NCj4gVGhlcmVmb3JlLCByZXR1cm5p
bmcgYW55IHBvc2l0aXZlIHZhbHVlIGlzIGVxdWl2YWxlbnQgdG8gcmV0dXJuaW5nIDEuDQo+IA0K
PiBXYXJuIGlmIHIgPT0gUkVUX1BGX0NPTlRJTlVFICh3aGljaCBzaG91bGQgbm90IGJlIGEgdmFs
aWQgdmFsdWUpIHRvIGVuc3VyZQ0KPiBhIHBvc2l0aXZlIHJldHVybiB2YWx1ZS4NCj4gDQo+IFRo
aXMgaXMgYSBwcmVwYXJhdGlvbiB0byBhbGxvdyBURFgncyBFUFQgdmlvbGF0aW9uIGhhbmRsZXIg
dG8gY2hlY2sgdGhlDQo+IFJFVF9QRiogdmFsdWUgYW5kIHJldHJ5IGludGVybmFsbHkgZm9yIFJF
VF9QRl9SRVRSWS4NCj4gDQo+IE5vIGZ1bmN0aW9uYWwgY2hhbmdlcyBhcmUgaW50ZW5kZWQuDQoN
CkFueSByZWFzb24gd2h5IHRoaXMgY2FuJ3QgZ28gYWhlYWQgb2YgdGhlIFREWCBwYXRjaGVzPyBT
ZWVtcyBwcmV0dHkgZ2VuZXJpYw0KY2xlYW51cC4NCg==

