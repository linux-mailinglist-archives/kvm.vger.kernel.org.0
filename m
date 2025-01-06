Return-Path: <kvm+bounces-34629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74412A03077
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:22:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDBCA3A15A6
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 19:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E381DF998;
	Mon,  6 Jan 2025 19:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RjRstqB9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F921DF27D;
	Mon,  6 Jan 2025 19:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736191310; cv=fail; b=IQ8LllMJ/2PxtamfyRgddQY5zZjhXNl2yGQkZiihiJquDok72SZNXr4vvBzjyFfE5ea8C/iz52xJrcJyRW9HMWVnHDJjZuS43FBru8yOgBh1yuhiLr19C2IGOsG6S0fTs7JiCVJusTBCYxthsPQ0CA680L7h6LDVw7fevKjY5Vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736191310; c=relaxed/simple;
	bh=3RJzwW4kFH9hcNkl7ZMpo3gSwR094+iNk6xCLMJLFWI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tAiNHGXSTt9mWPTObWLSWoy1aXkhH470eTus6c1P6M1imiI65j59sU1OgNCh5ym4Ibez9hhIg6NMyhkjaDlO9E/qXkXLfyOn4vdMBNxvSJwQ0+3BRrB2ApMygEPld3GQ6lwvs+4e5QePsDKyrTvmfN7CYMBMV629xMKsQBNVYy4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RjRstqB9; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736191308; x=1767727308;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3RJzwW4kFH9hcNkl7ZMpo3gSwR094+iNk6xCLMJLFWI=;
  b=RjRstqB9vBbkMaxVfuTetJThBx9pUfB6S8PI2C2sDxj9vdKs3Iqgbzy9
   +nvv768PdgoICwvfE/VTSH59KAZq1fAlEdGAHnNdfZxByG8obI4IGDX3h
   6HP+UaAyVGw6Zdb2UIy9+06W6TDDTAxN60teGA5WNldf0SKE+lk1XUnEE
   3cUHM/KbWwhzvR9ZSFM/bOHghldw15Rc/pIP2/gBV8NANM0CBqXhBg29c
   GRkSsvU1ey3s7+RGPPoAWloMYxxlicvJ/JQy0fcpuxtJfLYHh8JqLzcl3
   7yRFORZuVNz2eqBzyVj3MOmQ94VgmTFBhMLoVLaWAnodnNBt6NheYK868
   w==;
X-CSE-ConnectionGUID: YqT1QZaLQ3aJdjtDdi+sKw==
X-CSE-MsgGUID: ImrPnr9aTKWoyC75yFmcFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="40122654"
X-IronPort-AV: E=Sophos;i="6.12,293,1728975600"; 
   d="scan'208";a="40122654"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 11:21:48 -0800
X-CSE-ConnectionGUID: wm7jQx2JRmyfrgrlK5vVpw==
X-CSE-MsgGUID: hZPirugLS/Olh88wadcBSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="106566281"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 11:21:47 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 11:21:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 11:21:47 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 11:21:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LFtYMg/p6Cn+H9/N3IUWozGwd3dtRX8iORT4b+4kjihrjuObmuOLXigY5/r0O8TbfoZzrYsNgtUt2OFMWgiHdCQszRmu5vFqf/YHJKFxJhLNgxPpFuY6+G6/4/LaKeSU/Bwy2GCpY2DlwxYdZg/z0cz7pOvY3/gLgEzRPs6qrJ9mOtx31mWToZma71hgGaKGv0X1t0bNUYB/4pUiYWHp6bwXk8JPg2C4i/t9RTim+Bm+7dNdDf1PtkijdHnY8kQCPeE72Bpv1HEELAkUQ5u/aeykmisTBQWSMEW/t1k3X1DU9+n84P213ODNSiHtQbuu2uiCkQ+bWqr60HTKXjn82Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3RJzwW4kFH9hcNkl7ZMpo3gSwR094+iNk6xCLMJLFWI=;
 b=tFhlAXvHc9kwqCy7HF/crFQeXgi9cUKQahY8/nYTU+l/TbZU81chZwsAXHJCrwiJTfvhj1MZ3TMjTDYitDFUg69t0npsu9t4O4YcGGur5pWigiq9FUde5p+BlMgigmFGu+2fR7r7vqd8Gv2Swq3p1yYXJVxxBeCfMkhCElCRyc+5sDDxMhT+yMVsfMDJ1GPUZxx2BRTw3L+Iey5qewbvXJhUfOBYHYOqj1Z7yUWzA0PueMN6UbctHQSAYzYkifG2TdKfIB8Wpar2Lg+SnB+J9VkrJ8w7nv+agG1IzL7V/jSYrz+/hRnyV/aWf+dTxQEtdVvHAPJwiStWs3yVtCKs2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB8071.namprd11.prod.outlook.com (2603:10b6:8:12e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 19:21:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 19:21:40 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 08/13] x86/virt/tdx: Add SEAMCALL wrappers to add TD
 private pages
Thread-Topic: [PATCH 08/13] x86/virt/tdx: Add SEAMCALL wrappers to add TD
 private pages
Thread-Index: AQHbXCHZnPs8r4rRz0yF1XZL7xOWcLMEJPsAgAUgfgCAAOKtAA==
Date: Mon, 6 Jan 2025 19:21:40 +0000
Message-ID: <dbac12aec5270170c2f1a396f56c184a34b14133.camel@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
	 <20250101074959.412696-9-pbonzini@redhat.com>
	 <c11d9dce9eb334e34ba46e2f17ec3993e3935a31.camel@intel.com>
	 <Z3tvHKMhLmXGAiPg@yzhao56-desk.sh.intel.com>
In-Reply-To: <Z3tvHKMhLmXGAiPg@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB8071:EE_
x-ms-office365-filtering-correlation-id: 67403844-e77e-42c1-2315-08dd2e8758f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RXcrSmtvWS9jUktUeDVuRHFnRTBrK2J3Y080MHpTazgxZ0FpZ3ZNd2t3WDdN?=
 =?utf-8?B?dXJOc3BDUzU4Ykw0dlNXcWl2Z3JBN29qWnE2MENyN3hKKzhjR1pCdGNxbFRh?=
 =?utf-8?B?TFJPcWtKVU15TEJuZ1o4d21ES3FQUThETnAzdU9ENkFjYzk4U00ycytqYVBN?=
 =?utf-8?B?bDlxc0NXNnJXTWhjWUduK3BpSFpRclExWkptSlo0T09iSG91RUUrQ1JIa3hK?=
 =?utf-8?B?TStDcm13aHliMnB2QkFvYjlNSEVKOStMQUNBK1k2ZDBvQWV5ajkxMmphYTVl?=
 =?utf-8?B?TGNRVjkvSkV2WmtMTVJQMEw2bytLQTZpcjRJNS9VSXI5Y05Gb2hFcDgvbVFW?=
 =?utf-8?B?Vm56OGxzdXF2WDlQY0hrUzUyZVM4aENaOXk4Z28vMm03Y1h4dE5IUmRQVHJH?=
 =?utf-8?B?bm9ualEwcEpMaGNpN1k4N2d0SDFFUzAybHhRejV6eFBXbi95dXRsTDNBTjVr?=
 =?utf-8?B?eloxeGdIcC93UEIvNXZLMkRPV2Jsc253OHdDT2NPb2FFSWpsZ24xZmxLUjdJ?=
 =?utf-8?B?QlFPR3g5QytBb3dHSVJpQWsxWEVUdXdtZzBhQlU4ODh5VFo3c2g2MWVFK2th?=
 =?utf-8?B?TzlFcVJTVGxYZ01PalpPQnZUVldlaHAyK2FZRWFqQTF6TkFDVnBwcngwaEYw?=
 =?utf-8?B?WDIwUExtRHVtY3gvL3pPZ2lId2wwdmJydTZGYkMxa2JWd0MzWC9lUUFEL0ZT?=
 =?utf-8?B?UkVncTBnOFVMTlN6QzBIMWltSEl2SHkwdk1ZalV6Z09HeTVQazNOOGxEQURm?=
 =?utf-8?B?UjlrM2hWcDlTSWoxNzJVdmN1V2NLK3JleFpSSndYZ2V5bEJmZWdRazZla0lt?=
 =?utf-8?B?WURpUFpBYjBYSVcyNUpaTWpkdHpCUTFQL01wRURCL0luaWtrRmhFQVUrekhF?=
 =?utf-8?B?OU1OS1dqdjdqMGkzTmRFREo1dnpibWFKN2R0SjZQS25TZGVrdGwrSVFTSnpY?=
 =?utf-8?B?WjNOZ1BDSWxIRUZyeExaYWx1S1hPWEJqc2J4TXV3aGcreTgyVkwxSU83RzhO?=
 =?utf-8?B?MFhPWkRBejVqZ3VqRHMxZ2tUTUZJRm8reStXVm9IVStESjRGNTFsak1nMmZK?=
 =?utf-8?B?OE45WVFYaVI0eW1yeEtLRzBZVXpjYTQwazV3Tng2dm9VMTZ1YmRIMnRGeXo5?=
 =?utf-8?B?c2szaURSbHphM2Z6TW5DRXdFRWhrMi8zOXlxSWVrVWx2TU5PSE9QbkQ3SndH?=
 =?utf-8?B?R1E5ZEhPN1RvYWMvME16dFRrRUVUWHA5amcyM1FiZnFRRUE1cHRyWlZCYVJa?=
 =?utf-8?B?MzJROHhHQzUwMlBXSVR6RlBJY3lndml3dnhVYmIzR2hNM3YxdVlwcm5IbFdE?=
 =?utf-8?B?QW5mZ09RUExTMkFwVzZSWDdJeXpRNHY3bGtxdTBFdVBUa3JMUytCYTgwK01S?=
 =?utf-8?B?SllxUVBYWW9iOWRkR25MTHlWK2pyRWdBVmdveHpYc2hIaVIxUC9tMklDL2ZD?=
 =?utf-8?B?MkpYakNkaFZKOVVjSHIxWk4xM0NPL1d5T3R2Tm1sbmtaU2ZGaklYMzhwYzdE?=
 =?utf-8?B?eE9pMlh3RHkwLzB2TmdyMHp2WXI0SzJud2toU2tGLzNpZ1dzSnE3dHZ4V3lN?=
 =?utf-8?B?R3c2eVFxbXN5bU02QU15Q1dPWDN4UVlWQlBSTUVzZi8vaE9qeHRXMUNyMlFk?=
 =?utf-8?B?WmI0eUtvZlBXME9vTkJvTXVYeENyV1JaU0FVaE5xeWpQbDRWOTl5SzVYVzJk?=
 =?utf-8?B?VE1hNU9YenVLdVk1MnZHRE1neGNMMktvcUZxNVdrSVNOWnJLMndoVFRIWU1M?=
 =?utf-8?B?SXY4bVBFYVF1cmlieTdFZGdjMk1CT2NERExhT3NPRUo2dVpwL2Z5TGkyZEZx?=
 =?utf-8?B?Z3liN3BjbzUwT0RMNFpSR0xNNm9ZYTlacXFiWnlPQzNpS3B2NFAzK2JmRHVT?=
 =?utf-8?B?NWNOVzBTd0wzek5JT1BjWmNGMUorOE53RDJuR3pvdHhvMjMvZzU0QnR6STRE?=
 =?utf-8?Q?AKNRbM5LL0XmwrOQ4PsTh2x4ZPbzFN7r?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVYzNlJqbXdyNHRhMkI3V2ZSU05OK050WW5RRXZLbFlzblNhcmNNZWM5OXdU?=
 =?utf-8?B?UzNBeGFjRTB2ZDZpTmZMbXdTV2dxaG9VT3JMYXk2Zk9sUUxURm5TYnA4aEpG?=
 =?utf-8?B?N29qL1hGSm9CUVJ5MDZjSkE5L3BKR0ZndENEekh4a0FnSFNsY0todnBpNXRY?=
 =?utf-8?B?Q3pSbkoxNmxReUFTTGFXOVdnN0JQS2dOOFlPN2hXNlJENDI2VWNrRnJQMEFH?=
 =?utf-8?B?YUZDMGpCdkRoQ2ZWczZnd0h0V2RjUldZdms1bzZLVmFSRGFYR05XY0pvRm1s?=
 =?utf-8?B?WlQyR200R0V1Y29BUythekwxTG1HczVabHdNSit1ZGl1ejBsRnZKMmlNdUNW?=
 =?utf-8?B?QkdROHZYMGRJVXVENGdhV0kwUWplZEdvNnA3aEpYUTArRFJUc3A5MUErUndM?=
 =?utf-8?B?dzJtN0Z4NWxsb3JKOTN6WkUzNFkzRHBOY1pCaVEwNzYzY2VaU0IyemhmRXo1?=
 =?utf-8?B?OHFHQlNzMVVnVUc3bm5UODVCbWJGMXFVTmo0TThNdkM5SkRHdHpVTmVZRzli?=
 =?utf-8?B?a3lGMUV0WmlIWkhPdjlrUGFGVWhhY3dXVUJ4TE1pMFFKSkExWjFGcGVFY3M4?=
 =?utf-8?B?RGhKdjZDWnJrVDFtUkx1aDMzQTVnTURYWk5FTWIyNm8yYmlnQTArR01qUzIz?=
 =?utf-8?B?YmVUVkltdFFSRXlNc2lOaEZaWkpHUk8rRloweDNqMXJFT1pxbWo3Rk83MVYr?=
 =?utf-8?B?ZDRqVGZlZ3RtR3dVSExBbytRUXZlZUI1WHEwc3hJS3JLUDJZYmFNOWZvM29T?=
 =?utf-8?B?WVJjYlFjWkwxMUxqbVZOSVlXNzI1YVI3ZGRBYjdzbStkRVduWkdCNFA4UDgz?=
 =?utf-8?B?M1VONFEvZEdlMXg3cTJwaWpFWkJzemhDbXgreTVPcHBNUlRRYm42S2djL29G?=
 =?utf-8?B?NU00dUFXSmV6L3g5OGticU1OVzU5RmxDTHkxS3Y4S2V0VytkZHhwMnhFZSt5?=
 =?utf-8?B?WWlEWWYyRFhLY1hmSWtVM3dGNE9OeVVYUmJ0R0tOdjZwNzRYdFhkekpDWlVv?=
 =?utf-8?B?eGcyUUwvWEJnejQrcU1TKzc3ZG5jdE9TWWxJS3VWaEcxQ3Yzbm1KWkhCYml3?=
 =?utf-8?B?YzdhY3lYTk1OMVU4ZGlVRTdHQXJKWllFYUEyNlhaalJBVFluMXI5cXFCU09M?=
 =?utf-8?B?TEErWHBUVFB1T2tNQ3lkZ0dEUllMcXNQZU8rZlFHYnpvd3ZEZDVuM2h2VnRw?=
 =?utf-8?B?VTk4dms3WlZWNGlScVRNcHFKdXZaWmYxMVV0L0tpc0xSWEhkQkZNWUZqTmVi?=
 =?utf-8?B?QUMvTlEwd1FMMy9OdWRnV2lkVXh1ZnJ0aGZsYVhLTEFucTNreUJtOEtGaitl?=
 =?utf-8?B?Q1Q0WEFoRDAwTk1NbGN4QVZFbi9vYkZ5bnFnOFA5ZU91MFdrdmdMVVp4Vzdm?=
 =?utf-8?B?T0toNHBYVGpUZVJHempGZHQrV2Y0aTZzYk5TTFFEMXhCSVhETW5YeHpvb1hX?=
 =?utf-8?B?dFNSSXM3SWN0UzNQRlQ1MVJmL1ZxaEZaa0VnRTEycjIzbXV4TE1BN3diUnRi?=
 =?utf-8?B?TzJKY2NTRGlKYXE3OGRqQzFTQnF3L3F2TG00RzQ0Q3ovMHdib3Jzbmd5cnQ5?=
 =?utf-8?B?TFJVZ21HeXdrSlRmM1RFUkhzMldkem9qOUsvNUdESkhRWXFVd05raFJ1R2p0?=
 =?utf-8?B?Rm56bXNNcTM5T3dhb0dCRnppM2h4VHZ4WUN4WCt0YUwxdG9jTU5XdzlhMDZJ?=
 =?utf-8?B?V25BakhhNnptSzNreXVFTTB4RjNTckJ4Z1B5MnRJbzhNcitkTkc3RFgva0RO?=
 =?utf-8?B?MFE1eTlkSFJrTzRnajh1SnZMZnZ1VnVyRjJVbWRYM01KcjhzUmZLMFMzV1JR?=
 =?utf-8?B?WWhEaVowSG9FNHV5QWJ5b1BoSnAySzBBalRXVzBHZ1BFNGQrNEpvdXdXRWQ4?=
 =?utf-8?B?TUN0OG5nQkU4WE8wbjRXWm1yaVN2d3I4bHF2REVNTXcyWS9MVGJ0RldTWkJT?=
 =?utf-8?B?djhEc2VMWWIvSDc1WGQ2bDJPdS9Oejg0UldxVnM1SDhQNmIvTHVmYzNITlMz?=
 =?utf-8?B?UHB6eDVkTWsyYXJ3WGdSYitINFN5b1FPKzdncHlUUHBJR2ZqL2xrNis2eVhz?=
 =?utf-8?B?MUlhWWNhTXdVUlF5cDYvZERBaXJ0K3pOajcvNERORVNXblUxdjJVcHFXdHJG?=
 =?utf-8?B?MHA3aGdWNXQwYzJSOXA1a1BQbGh0Z2Ezb1NGUkN3cTlCNVRXdXpMSzl5Tmhr?=
 =?utf-8?B?UFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D8A4DE76A51A34288D87ED5C93608F9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67403844-e77e-42c1-2315-08dd2e8758f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2025 19:21:40.4133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jq6twjhGaDHEEznAo//KVzmv7GHiVrB30/IveeeNsRW/1kfRqpgOlAI1Ep0j3g4Z/8tVX4ceou2YVGoC4UbiH5GmWMxd9Rjq6jAAZFTijTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8071
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTAxLTA2IGF0IDEzOjUwICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBJ
IHRoaW5rIHdlIHNob3VsZCB0cnkgdG8ga2VlcCBpdCBhcyBzaW1wbGUgYXMgcG9zc2libGUgZm9y
IG5vdy4NCj4gWWVhaC4NCj4gU28sIGRvIHlvdSB0aGluayB3ZSBuZWVkIHRvIGhhdmUgdGRoX21l
bV9wYWdlX2F1ZygpIHRvIHN1cHBvcnQgNEsgbGV2ZWwgcGFnZQ0KPiBvbmx5IGFuZCBhc2sgZm9y
IERhdmUncyByZXZpZXcgYWdhaW4gZm9yIGh1Z2UgcGFnZT8NCj4gDQo+IERvIHdlIG5lZWQgdG8g
YWRkIHBhcmFtICJsZXZlbCIgPw0KPiAtIGlmIHllcywgInN0cnVjdCBwYWdlIiBsb29rcyBub3Qg
Zml0Lg0KPiAtIGlmIG5vdCwgaGFyZGNvZGUgaXQgYXMgMCBpbiB0aGUgd3JhcHBlciBhbmQgY29u
dmVydCAicGZuIiB0byAic3RydWN0IHBhZ2UiPw0KDQpNeSB0aG91Z2h0cyB3b3VsZCBiZSB3ZSBz
aG91bGQgZXhwb3J0IGp1c3Qgd2hhdCBpcyBuZWVkZWQgZm9yIHRvZGF5IHRvIGtlZXANCnRoaW5n
cyBzaW1wbGUgYW5kIHNwZWVkeSAoc2tpcCBsZXZlbCBhcmcsIHN1cHBvcnQgb3JkZXIgMCBvbmx5
KSwgZXNwZWNpYWxseSBpZg0Kd2UgY2FuIGRyb3AgYWxsIGZvbGlvIGNoZWNrcy4gVGhlIFNFQU1D
QUxMIHdyYXBwZXJzIHdpbGwgbm90IGJlIHNldCBpbiBzdG9uZSBhbmQNCml0IHdpbGwgYmUgZWFz
aWVyIHRvIHJldmlldyBodWdlIHBhZ2UgcmVxdWlyZWQgc3R1ZmYgaW4gdGhlIGNvbnRleHQgb2Yg
YWxyZWFkeQ0Kc2V0dGxlZCA0ayBzdXBwb3J0Lg0K

