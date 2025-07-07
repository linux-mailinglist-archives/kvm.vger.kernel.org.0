Return-Path: <kvm+bounces-51633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4968AFA984
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 04:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0944316D62C
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 02:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993CF1A3179;
	Mon,  7 Jul 2025 02:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iRRQPLHr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058BC635;
	Mon,  7 Jul 2025 02:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751854219; cv=fail; b=oLcaydPKwvv85Y7k6+gwNAWmPtH5h1LvozypfZJ0czZOLJPHEff8tV1q7G6B1cLPcSzOeKPpHqCgmFIi8JieFppZBok8ud0mOu4T8FVEjn0ERlUImtvUW047j2/N9+TkzuSnX0ObZlreAqMBqe/hNKvu4X7vpox7OmscbWyLCfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751854219; c=relaxed/simple;
	bh=43Vqq0xJl9B+wc9ex4PPoqsQfbxEQTjcCcIAFi2LlYc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gq42LzMLc86Zvhy+J8gxKU5siWf9ToBQGfyFHXp6LVj4/MAEe+dx974O73GIFvvWKHfYzHEF19nBMYs/eLuDEA1N7+f0W4tKnl+XxUK3a2Ki59IUmRbX/YJGji2PY45pnbEshGBZL+dPN3MaDseLZ66zZO9XFx7e0QIJQUwGE20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iRRQPLHr; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751854218; x=1783390218;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=43Vqq0xJl9B+wc9ex4PPoqsQfbxEQTjcCcIAFi2LlYc=;
  b=iRRQPLHrO3jujbfS+xF2FfCs8gdkDgcjDyXPLi+/5Itp/pj4GcClpz3A
   8wCKAfcQ74aj37/M4u5YbGCLv9bXEWa4aNsntUpG5J20p5p/eaZ8lYcgK
   03I+BoqSoQD6NzXq3V1L4AVl1w5j0vWQX/k1lc/muk3NOn/K9+dDcLsEQ
   zFmT6YvqqTdhT5w8iq9cskHw+mQ6M5jjrz76aK9MzMEGdF7qBO+A/jQP0
   gCT/OSQrIpbukIh+JW3/wjkECmztbCtp/lSRDsSGoY7az8JZEYdpW44Ml
   Sx5wa7LD97JkaKrhQdkA1xGvJ8B7yRMmA2fhUctz9auIzJpxEZt6WjxBQ
   A==;
X-CSE-ConnectionGUID: B6eU8w9wRpWEfku8X98YKg==
X-CSE-MsgGUID: bxtIBcaLSwG3jMcVbjJiLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11486"; a="64661605"
X-IronPort-AV: E=Sophos;i="6.16,293,1744095600"; 
   d="scan'208";a="64661605"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2025 19:09:55 -0700
X-CSE-ConnectionGUID: TfXZI4/JRLWmdW4T3rvLfA==
X-CSE-MsgGUID: JQkdXzUiQwSYYH7ehtN8Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,293,1744095600"; 
   d="scan'208";a="159112157"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2025 19:09:38 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 6 Jul 2025 19:09:37 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 6 Jul 2025 19:09:37 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.69) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 6 Jul 2025 19:09:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aDB/dctftXGqBK1H6KtHttHYnG+3fPTRrxQRRheoatyx4mfNGqD8Ve8YeMguF6swA6XIkGfSPkt1lyzZSHoZI3TKYPUXOm31vLMVVn7ZYrzintpZoHFsdl4K/o1P97MinbZ98dAjPRRYbLMgzY0+atS1ZvFj+w1axCqRaDPI7qNKcN6pgBQnIoYucjFBdUItznw1qPPSbIhRZEWpZnrSmf37WSFj0UZUHj9GqIZv1vmsO/rdIpZjANarGcQ/HXx9fYdgVNicweDliJK8KfZ0OuAltu9uQ+xN/iPUcKT2sEWdTyi3lamWWD3+FexMgLoOAcgWpfcjRCvvCRu1HpDFUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=43Vqq0xJl9B+wc9ex4PPoqsQfbxEQTjcCcIAFi2LlYc=;
 b=e4D0AP3BeenvlUHkozDZIbOZbS1LYtnEBAVbFOK6mRuCRsNNgvXJySJfmg8O4yKLzczhHRCVAZzxhvKdGXSOnJV61ruw0nt31Eaq83NmYBQ5/SFXvHMuV8TpBrogJTETdDGbDBmmzJcyzZfXGmm4ggujwTRwJP9jSh+F6XxXpMIOOCUNXEmDBxeq+W/p0KipDBGStdFjS7t1NZ/ylsTCEByZUovXOW3vW4lom88YfLn1VzWzJMjG3eg5zh9iW4vIEuJes49mciCNYw4qPM7wN6hUFqggEc4XVuTUwXxQ5ZCeJlELjJMOsddTaIUGd8blSqe6UtEQgRjGEyySDNSugg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM3PPF4AE904FD9.namprd11.prod.outlook.com (2603:10b6:f:fc00::f1d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Mon, 7 Jul
 2025 02:09:35 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Mon, 7 Jul 2025
 02:09:35 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Luck, Tony"
	<tony.luck@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Gao, Chao"
	<chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH V2 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
Thread-Topic: [PATCH V2 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
Thread-Index: AQHb7DBwzT38WlKsQ0GMFAXu/JzorrQl7/iA
Date: Mon, 7 Jul 2025 02:09:34 +0000
Message-ID: <0ad0d81bf5465c5eb21166d06b1bf077dd2bd941.camel@intel.com>
References: <20250703153712.155600-1-adrian.hunter@intel.com>
	 <20250703153712.155600-3-adrian.hunter@intel.com>
In-Reply-To: <20250703153712.155600-3-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM3PPF4AE904FD9:EE_
x-ms-office365-filtering-correlation-id: 80659d01-0eaf-41ae-f75b-08ddbcfb51ae
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WHZvSll5cSs5NEhSTWlRTG91Wkowb3BweENWODBMdXRCaTNKSkxEMWlFNWc0?=
 =?utf-8?B?VEcrVjVIQWhKUTNUMWRWR0ZuSFk4c1VRb3A4Y2gySm1adE1zRTZ6Yk9CSlVC?=
 =?utf-8?B?MG1EWHg5U0NnRDgrYjBXZ3lJTXlLc0V4Y2JSVjNodTVKUDhlRDhTT1VnKzAw?=
 =?utf-8?B?TjF3c2xISVgzYzlRMTdVWjdzYkRWaFR1bGJlUS91S2E4NS9NbkhDRzJob1dL?=
 =?utf-8?B?Wlc4dTlYQmpLYVAvUDVxdUhxNVZHdkpzRlpWbVZCeGI4VnM5aFA1MHNkVG5k?=
 =?utf-8?B?YU5QS21PSjRSR1AzY3A3Skp6Z1VpZ0VLb3luZFFmVDNIZ2tDWFR4M3NOMHVK?=
 =?utf-8?B?OWwzSHJ4NFBua1RwUENQK1d5ZTN3MmlaWEpOT3l0RXdQTUJvVytaQnZSKzlU?=
 =?utf-8?B?ZWdoc3BNUjhXS2lXSHFnblJyRGlaTmdpdjdhbjVaa2VvL0xseERTSDFBNElW?=
 =?utf-8?B?Uk9QQUJUU0dSUjg5U2JDSHFkenNna1lyMm0wUTdoVzBVQjNEcU9lMG5TZmQw?=
 =?utf-8?B?WlFwZEtGR201cmFpZFVWazFOTmVja0pLRVJ5TkVUNnZFOFVtSURBYzluN1RO?=
 =?utf-8?B?ZXJ4TzZ4eWszWHFHL0gvSVB2V3NEMGM0RVBXaDBOeHd4Y3lHd1ZhNFAxRDYz?=
 =?utf-8?B?bVVzSithYWpJZlhBbCtRUTRTeG9uR0o0ZjYzeGM1TWxGV1pFcFpTYWRuOEMr?=
 =?utf-8?B?ZE9HRXJ5U1IwVVVhbXFXTHA1b1dMcFMvclN5TDRjSXJlM25aVkMrblZ3SHhX?=
 =?utf-8?B?NHNLeEFTM093STlvNW5PSDNCM3pIZFNrTFFZKzhPeWxGaW0vTDFpSTBjQnJa?=
 =?utf-8?B?cU5zZ0NNN2lKaXl4aFZBYUkyZGFvR1NzOXoxcldERGR4RjBTZWk2VXZGMUhY?=
 =?utf-8?B?dlFaNE9iZER0cDhmTHhkOXlKNktPMzYvbm5ROEthaTFKSmpldWVNQU92L0Zq?=
 =?utf-8?B?aTVDMy9RdHVkcG11aGRHNmhWb0VEZnkrZDZOMG8xNlJ6RDJTMDJhQ20xM0hR?=
 =?utf-8?B?NVRZcEdJWTlDRnJncHdNVmNyNlV4VVpzd09KdERDdS9KbW1vQUxGaDVrZ0R6?=
 =?utf-8?B?QlgzQUwyWGVKd3QwOUZkZ3l2VnIrdmpmN1QrSEJTQkNpdTJRMDluaFJUVkNV?=
 =?utf-8?B?RnUxUTMvYzRWT3FPN2Y4YTAzTjBqMWRJb0tXdVVmc1ZOMHpaTnVnVHB2ZGhN?=
 =?utf-8?B?czR0TmhPaWVzY3ZIYnNIekt3dVJIVGZDa1ZpNWtJcW9Ld0hFSUg5R0M0UUFS?=
 =?utf-8?B?bnVoUjZXSXRmbmg3dEloYkhnNGczR3Vld0dFdjZmaHlVeGh6d0p2TU14ZUxS?=
 =?utf-8?B?bnYxZmdHSlhNalo2R1hYdm1SZTBWT1ppY05GQzd0eWhhTjYxMkNEdGlXV0JL?=
 =?utf-8?B?YXNBaytaZCt3a1VuL2dlN2cxTFJHWGhCQ2Y4cVFtMDBuSXpkQytOUDRnVWox?=
 =?utf-8?B?OFlQYU9wQmdaSExTT3ovV0R5QUFKNFJoN1l4akdPdGJjd2NsTjcyakdOMmdE?=
 =?utf-8?B?N0J5RGhZUE95YUN5TWZqajVCUFc4RFEzVDFxK2M2QysrTTlTQmk5SlF5azd4?=
 =?utf-8?B?Z0ZIS3F5RVQ3dTZjV2JQcHlPYURud2tIdk0zN0d2SU9TV1dPTkFQNVN0T1ZI?=
 =?utf-8?B?NENwcWxUeEM3VVlFMktsZ2x5dlRzYXJqSUdsRWR6bG9xWGV1NnJhSWFEUTA2?=
 =?utf-8?B?UVpPaW1lL3R6UmdFVnNPcis1aVF5NE9pUGh1Q0YrZnU4NnQ3SXBPTWU5cE1l?=
 =?utf-8?B?N2pQeXRaalhCTVJ5SWtuRFo3K3BPMkk3cW91K2xUSXJ3Rk9EdUtMbXZaQzJv?=
 =?utf-8?B?cW54QXNodkg5WVE3ZmsyUWZBN3JTYk4zalN1U0ZqWEEwU2E2aVgyRVV4Z2Zm?=
 =?utf-8?B?Tzl2d3VEc2NYazBWbGdQNHdYVnFPM2c5YlRhQW9aR1d5Z1hVWnhGcExCSkx1?=
 =?utf-8?B?ZEZVcXFpRGdQazU1Y3ZFWlNSaC9STTlHQ3UyT3kzaFZCaFdmc1lyR2JjZ3Vt?=
 =?utf-8?B?cHphbzVGWWN3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVhRTXI2Wmw3N3Q4UTZNVVZ1V2hWdGNhU2ZmN0lqUys0U0kxQlpyblhuTzN6?=
 =?utf-8?B?MGRZNmhyZUZLWkFJMnFlRlpqbFY0QW14OGNza1JrdUVoK3V1MUZEWnpqc29K?=
 =?utf-8?B?TXhRT01xcFZYci9BUGRGU2Y2ZjZHTThoY1FseW1qZC9KTGExaTZZR0RPVHUy?=
 =?utf-8?B?cE1NRXJBYkFTY2RhVHZrSmN6Q2UyZmovNlB5NG0xNm50aUdLM2VTUW9WMzFn?=
 =?utf-8?B?bGl4akpHRWp0SDFFWkhwMnRJa0t3cHhaT28zdEduaGpkZit3cXlMdnpoOFFw?=
 =?utf-8?B?N01RTjRnaE9xZjViUVBneUFrRlRnS3pNK1JPamRjYWJVQi9uS2lqdXlmcnZR?=
 =?utf-8?B?UVJxTmYwVXFDZGxCdU0rc05PZzNaVDU0c2JlcUtrSzZqcHZpVjFrOG9EenRK?=
 =?utf-8?B?eEZwQ3JSTUFQaHJPTndxNnJwc1hiaWE5Y05DL0RlODllZnV0anVjWGpEWDY2?=
 =?utf-8?B?QklIaXp2dVdtc3ZPTmFiT0l0Uk1HTnZwVmlrWDgwWHErZ28rMUk2N2xVaU0v?=
 =?utf-8?B?NnZXMlJoQ0xoS3BkYlZyU29HSnpBeUJRaVdHakpDV3JrakFacXE1aFE3VHFt?=
 =?utf-8?B?NXh6Vk9GdW9XYytVYmZVUGM5RVA5V1o2bURtRkxJU1BhVjAzNTd2Y0o4eDd4?=
 =?utf-8?B?OXlyV1YwTlczZzNwdTBrTGI5REVpRWpWZTBrZWJHVVkzUVVFSmVSZXhlUCtZ?=
 =?utf-8?B?M0VHTzVPbEs3b0JyeG9yeU9ZZ1pkL21ONnBVNWxZUHpMWnJoSnM4UHdFU2Rt?=
 =?utf-8?B?b3pCakIyV1FzdFV2UWhkYUI5OS9JVHM5Um83eURyNWwvSEdqSUpjVWFqMU1i?=
 =?utf-8?B?cmpCRGxBK2JiL3Fza3B4N3Byd29IVnlwVi9RYTM1bUNta0dmS1ZDMW11YS84?=
 =?utf-8?B?bC9vZXg0dkxhZFdNaUpqNDU1WlovZnVNbkRtTTBLK25DRmllUk5wc0h5RmFa?=
 =?utf-8?B?YSt0TXdPNEIrSGNQanFMeXRpZXI5UURyazlQSmRSSHRTTVNMeFVTSzZpMC9v?=
 =?utf-8?B?akkyeUlETDkrMVZ6amhoQU40RENIUlhpRXhxU1pQdTZwbU1TZlJLT2dTcml6?=
 =?utf-8?B?M25vckNMUmc2T2h0YTJIWHQ3YmVsNmQ4a1ZpTm1sNFBRSXZVTUxVWVRKVno2?=
 =?utf-8?B?OEcrSVJTc29MVGFjNWR0SmI1RnM4Nzh2cy9ITVNIMno0Nzk5UWIzVFQ0UEls?=
 =?utf-8?B?NldMVjdoMU9pVktTWHBkUEJlWWR1dDF6NFg1STdzUWNvY1d4anpkMzhqcVY1?=
 =?utf-8?B?b25WVUhYNENtR1VjR3BJc3dYS2doaGJ3RVJESGVXREthejJMTWVzVjdtYWxk?=
 =?utf-8?B?dXRzd3RsUDB2TDFHVkdSTG41bjZMSHdJSlRjbjJ2R2I5RCtvYnNBY1djRlNY?=
 =?utf-8?B?MXF4YktmNUlrY29GT2xoeUMzZE9uU2ZCOXJ3Y0xMdFNkQjdiaHh5S0x1a2hl?=
 =?utf-8?B?d01GSjBTQ2pHdkRWZWFvTXByRkRka2ovRjJOY3lkL3I4QkxCQjBIK0J5M25W?=
 =?utf-8?B?NGtFOE1jTjBma2ZFWUcxMjdRL2NkVlBIY2xja0llWWlPdDVmZjZlSWZ1Nnh6?=
 =?utf-8?B?OXdmT0lvdzBUd2Rsc2RHaklIUHZYREhKVzJaelZsVVVidFZMMW9zTEQvRmlj?=
 =?utf-8?B?WnkvMlA3K0Y1UU16dHg4S2NaNWVjYjUzd2VzWG45NTZxbTVDelJKSHJsQmRa?=
 =?utf-8?B?UHRtdFIzZzMxSm8wVFRjY1BWWmFOT3hnSk9rSWh4bFQyZ1JZZHFUazNnSkJv?=
 =?utf-8?B?bnNJOEU5cDFmZ0xFU1hPSFNZYWY3QUpJVjU4ZFhpNjZYbU5WKzlQRHVYN0Ex?=
 =?utf-8?B?a2k3a09FZ3ltWURPVnpmSjRuSWRqaEpWYmRSd2xVN2dBUC8wZ25WOExoZWdL?=
 =?utf-8?B?WEJlWTl1OE5mWWhaL0k5eUpPVjlmeFl0UE1uRDhXRFVLZU5RN2JWNGF1YUZv?=
 =?utf-8?B?Rkp1V0pjRmFzSUtic1VQdnBtdURwSUl5RmJmeERZbE8zSVhZS2xqbjJpcGha?=
 =?utf-8?B?Y3gxU0kyTlRSZGN1NVJ2QlBETFNpc1FxVEJCZ1prTzliNGJQWm9LdERYU0Rh?=
 =?utf-8?B?K0dza2RFbHFObFRQRnBha2hJdy9qa2wrWXBtQUx5LzJFaFNjWExiaEh4UGl0?=
 =?utf-8?Q?EZ+bnyvT9u1ZJKu/Z6J7jv8Je?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6591E2277C1ADA4F8E00A210190E4FAC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80659d01-0eaf-41ae-f75b-08ddbcfb51ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2025 02:09:34.9367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sy28N53uiBjg/2IWRKoFLCtT2DJYAZrBtFGU9VdxUbByP81JQkCf3H/laiGCVy4S8y3VWrMHs5U6GmgryaPJTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF4AE904FD9
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA3LTAzIGF0IDE4OjM3ICswMzAwLCBIdW50ZXIsIEFkcmlhbiB3cm90ZToN
Cj4gQXZvaWQgY2xlYXJpbmcgcmVjbGFpbWVkIFREWCBwcml2YXRlIHBhZ2VzIHVubGVzcyB0aGUg
cGxhdGZvcm0gaXMgYWZmZWN0ZWQNCj4gYnkgdGhlIFg4Nl9CVUdfVERYX1BXX01DRSBlcnJhdHVt
LiBUaGlzIHNpZ25pZmljYW50bHkgcmVkdWNlcyBWTSBzaHV0ZG93bg0KPiB0aW1lIG9uIHVuYWZm
ZWN0ZWQgc3lzdGVtcy4NCj4gDQo+IEJhY2tncm91bmQNCj4gDQo+IEtWTSBjdXJyZW50bHkgY2xl
YXJzIHJlY2xhaW1lZCBURFggcHJpdmF0ZSBwYWdlcyB1c2luZyBNT1ZESVI2NEIsIHdoaWNoOg0K
PiANCj4gICAgLSBDbGVhcnMgdGhlIFREIE93bmVyIGJpdCAod2hpY2ggaWRlbnRpZmllcyBURFgg
cHJpdmF0ZSBtZW1vcnkpIGFuZA0KPiAgICAgIGludGVncml0eSBtZXRhZGF0YSB3aXRob3V0IHRy
aWdnZXJpbmcgaW50ZWdyaXR5IHZpb2xhdGlvbnMuDQo+ICAgIC0gQ2xlYXJzIHBvaXNvbiBmcm9t
IGNhY2hlIGxpbmVzIHdpdGhvdXQgY29uc3VtaW5nIGl0LCBhdm9pZGluZyBNQ0VzIG9uDQo+ICAg
ICAgYWNjZXNzIChyZWZlciBURFggTW9kdWxlIEJhc2Ugc3BlYy4gMTYuNS4gSGFuZGxpbmcgTWFj
aGluZSBDaGVjaw0KPiAgICAgIEV2ZW50cyBkdXJpbmcgR3Vlc3QgVEQgT3BlcmF0aW9uKS4NCj4g
DQo+IFRoZSBURFggbW9kdWxlIGFsc28gdXNlcyBNT1ZESVI2NEIgdG8gaW5pdGlhbGl6ZSBwcml2
YXRlIHBhZ2VzIGJlZm9yZSB1c2UuDQo+IElmIGNhY2hlIGZsdXNoaW5nIGlzIG5lZWRlZCwgaXQg
c2V0cyBURFhfRkVBVFVSRVMuQ0xGTFVTSF9CRUZPUkVfQUxMT0MuDQo+IEhvd2V2ZXIsIEtWTSBj
dXJyZW50bHkgZmx1c2hlcyB1bmNvbmRpdGlvbmFsbHksIHJlZmVyIGNvbW1pdCA5NGM0NzdhNzUx
YzdiDQo+ICgieDg2L3ZpcnQvdGR4OiBBZGQgU0VBTUNBTEwgd3JhcHBlcnMgdG8gYWRkIFREIHBy
aXZhdGUgcGFnZXMiKQ0KPiANCj4gSW4gY29udHJhc3QsIHdoZW4gcHJpdmF0ZSBwYWdlcyBhcmUg
cmVjbGFpbWVkLCB0aGUgVERYIE1vZHVsZSBoYW5kbGVzDQo+IGZsdXNoaW5nIHZpYSB0aGUgVERI
LlBIWU1FTS5DQUNIRS5XQiBTRUFNQ0FMTC4NCj4gDQo+IFByb2JsZW0NCj4gDQo+IENsZWFyaW5n
IGFsbCBwcml2YXRlIHBhZ2VzIGR1cmluZyBWTSBzaHV0ZG93biBpcyBjb3N0bHkuIEZvciBndWVz
dHMNCj4gd2l0aCBhIGxhcmdlIGFtb3VudCBvZiBtZW1vcnkgaXQgY2FuIHRha2UgbWludXRlcy4N
Cj4gDQo+IFNvbHV0aW9uDQo+IA0KPiBURFggTW9kdWxlIEJhc2UgQXJjaGl0ZWN0dXJlIHNwZWMu
IGRvY3VtZW50cyB0aGF0IHByaXZhdGUgcGFnZXMgcmVjbGFpbWVkDQo+IGZyb20gYSBURCBzaG91
bGQgYmUgaW5pdGlhbGl6ZWQgdXNpbmcgTU9WRElSNjRCLCBpbiBvcmRlciB0byBhdm9pZA0KPiBp
bnRlZ3JpdHkgdmlvbGF0aW9uIG9yIFREIGJpdCBtaXNtYXRjaCBkZXRlY3Rpb24gd2hlbiBsYXRl
ciBiZWluZyByZWFkDQo+IHVzaW5nIGEgc2hhcmVkIEhLSUQsIHJlZmVyIEFwcmlsIDIwMjUgc3Bl
Yy4gIlBhZ2UgSW5pdGlhbGl6YXRpb24iIGluDQo+IHNlY3Rpb24gIjguNi4yLiBQbGF0Zm9ybXMg
bm90IFVzaW5nIEFDVDogUmVxdWlyZWQgQ2FjaGUgRmx1c2ggYW5kDQo+IEluaXRpYWxpemF0aW9u
IGJ5IHRoZSBIb3N0IFZNTSINCj4gDQo+IFRoYXQgaXMgYW4gb3ZlcnN0YXRlbWVudCBhbmQgd2ls
bCBiZSBjbGFyaWZpZWQgaW4gY29taW5nIHZlcnNpb25zIG9mIHRoZQ0KPiBzcGVjLiBJbiBmYWN0
LCBhcyBvdXRsaW5lZCBpbiAiVGFibGUgMTYuMjogTm9uLUFDVCBQbGF0Zm9ybXMgQ2hlY2tzIG9u
DQo+IE1lbW9yeSIgYW5kICJUYWJsZSAxNi4zOiBOb24tQUNUIFBsYXRmb3JtcyBDaGVja3Mgb24g
TWVtb3J5IFJlYWRzIGluIExpDQo+IE1vZGUiIGluIHRoZSBzYW1lIHNwZWMsIHRoZXJlIGlzIG5v
IGlzc3VlIGFjY2Vzc2luZyBzdWNoIHJlY2xhaW1lZCBwYWdlcw0KPiB1c2luZyBhIHNoYXJlZCBr
ZXkgdGhhdCBkb2VzIG5vdCBoYXZlIGludGVncml0eSBlbmFibGVkLiBMaW51eCBhbHdheXMgdXNl
cw0KPiBLZXlJRCAwIHdoaWNoIG5ldmVyIGhhcyBpbnRlZ3JpdHkgZW5hYmxlZC4gS2V5SUQgMCBp
cyBhbHNvIHRoZSBUTUUgS2V5SUQNCj4gd2hpY2ggZGlzYWxsb3dzIGludGVncml0eSwgcmVmZXIg
IlRNRSBQb2xpY3kvRW5jcnlwdGlvbiBBbGdvcml0aG0iIGJpdA0KPiBkZXNjcmlwdGlvbiBpbiAi
SW50ZWwgQXJjaGl0ZWN0dXJlIE1lbW9yeSBFbmNyeXB0aW9uIFRlY2hub2xvZ2llcyIgc3BlYw0K
PiB2ZXJzaW9uIDEuNiBBcHJpbCAyMDI1LiBTbyB0aGVyZSBpcyBubyBuZWVkIHRvIGNsZWFyIHBh
Z2VzIHRvIGF2b2lkDQo+IGludGVncml0eSB2aW9sYXRpb25zLg0KPiANCj4gVGhlcmUgcmVtYWlu
cyBhIHJpc2sgb2YgcG9pc29uIGNvbnN1bXB0aW9uLiBIb3dldmVyLCBpbiB0aGUgY29udGV4dCBv
Zg0KPiBURFgsIGl0IGlzIGV4cGVjdGVkIHRoYXQgdGhlcmUgd291bGQgYmUgYSBtYWNoaW5lIGNo
ZWNrIGFzc29jaWF0ZWQgd2l0aCB0aGUNCj4gb3JpZ2luYWwgcG9pc29uaW5nLiBPbiBzb21lIHBs
YXRmb3JtcyB0aGF0IHJlc3VsdHMgaW4gYSBwYW5pYy4gSG93ZXZlcg0KPiBwbGF0Zm9ybXMgbWF5
IHN1cHBvcnQgIlNFQU1fTlIiIE1hY2hpbmUgQ2hlY2sgY2FwYWJpbGl0eSwgaW4gd2hpY2ggY2Fz
ZQ0KPiBMaW51eCBtYWNoaW5lIGNoZWNrIGhhbmRsZXIgbWFya3MgdGhlIHBhZ2UgYXMgcG9pc29u
ZWQsIHdoaWNoIHByZXZlbnRzIGl0DQo+IGZyb20gYmVpbmcgYWxsb2NhdGVkIGFueW1vcmUsIHJl
ZmVyIGNvbW1pdCA3OTExZjE0NWRlNWZlICgieDg2L21jZToNCj4gSW1wbGVtZW50IHJlY292ZXJ5
IGZvciBlcnJvcnMgaW4gVERYL1NFQU0gbm9uLXJvb3QgbW9kZSIpDQo+IA0KPiBJbXByb3ZlbWVu
dA0KPiANCj4gQnkgc2tpcHBpbmcgdGhlIGNsZWFyaW5nIHN0ZXAgb24gdW5hZmZlY3RlZCBwbGF0
Zm9ybXMsIHNodXRkb3duIHRpbWUNCj4gY2FuIGltcHJvdmUgYnkgdXAgdG8gNDAlLg0KPiANCj4g
T24gcGxhdGZvcm1zIHdpdGggdGhlIFg4Nl9CVUdfVERYX1BXX01DRSBlcnJhdHVtIChTUFIgYW5k
IEVNUiksIGNvbnRpbnVlDQo+IGNsZWFyaW5nIGJlY2F1c2UgdGhlc2UgcGxhdGZvcm1zIG1heSB0
cmlnZ2VyIHBvaXNvbiBvbiBwYXJ0aWFsIHdyaXRlcyB0bw0KPiBwcmV2aW91c2x5LXByaXZhdGUg
cGFnZXMsIGV2ZW4gd2l0aCBLZXlJRCAwLCByZWZlciBjb21taXQgMWU1MzZlMTA2ODk3MA0KPiAo
Ing4Ni9jcHU6IERldGVjdCBURFggcGFydGlhbCB3cml0ZSBtYWNoaW5lIGNoZWNrIGVycmF0dW0i
KQ0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWRyaWFuIEh1bnRlciA8YWRyaWFuLmh1bnRlckBpbnRl
bC5jb20+DQo+IA0KDQpBY2tlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

