Return-Path: <kvm+bounces-60927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25CC5C03A9C
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 00:21:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AFBD3B69A3
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 22:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19298283CB0;
	Thu, 23 Oct 2025 22:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QW1EKCP2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A771C3C11;
	Thu, 23 Oct 2025 22:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761258052; cv=fail; b=bh7S2DhWBRlvyFpewDeJSMwHoG+i+LR6s0ApgiJRIUg7cyWCKQup+DIHsO0KDNiHbbRhWkmBe6NnxwCTsM2CVW68vqcE8guHQ6hU5dPLuecTZRSF99uucniC0ZCMyVflw2h1pHMaWdjPIdmcVqixZNRzzKrj/AfKNLshm2jygYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761258052; c=relaxed/simple;
	bh=C0X6fVk0Lyfk5iDQCbJG/fRqcL/et4xfVqf3ivMscok=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=neR60SpI/nIX71Cm3ypiBJLE1t8izVbSr2PNK+OreXmjSwYDa7t7fQ9MEgE343gsXw11RGmXfVZcqNcbcuShc/CGkvpdwS7G/bf914QXV+HaaFxUy7g3KbsAQ35XUfvl/5dcXya9TUvZcUCCG0/07+Lxh6F774Sxf1Hvxw80OKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QW1EKCP2; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761258050; x=1792794050;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=C0X6fVk0Lyfk5iDQCbJG/fRqcL/et4xfVqf3ivMscok=;
  b=QW1EKCP25vR3n4glppnkExwchiv14/LrznA8Q/CY8FwaKpR90GCV+g0V
   eJBgU4ga4YIH+L90ZaYHR/6JCrLKAVE+9g+fm0+yzRjPZtzqjKgu9raiK
   KXZgmInIfFrSM2Q4wbSaN7r2vPRD2CbHFCr0uQN+CvIuq10ghrjy50vmQ
   TyaXwW0LFEtfsasYlnCjs/Pksc9Eqxs2v4KY6DRBf+nLK+0OrdjEf68xW
   MZn7taW1n0IuzI7Z1PfTc9BkY1ORixLybRqRfwfO/HVH/U/5OtUpS/YGD
   ln2DuiyZLV4UNvZatbe7oHw2aBj2UtsY0S3yuJVX12JZPoz0f79eixdP6
   Q==;
X-CSE-ConnectionGUID: ee+kU0hnSReJScWT10RxnQ==
X-CSE-MsgGUID: mlD0nLvsQ2K+B3yh5mJeEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80876223"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="80876223"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 15:20:49 -0700
X-CSE-ConnectionGUID: WGJSjZkdTmySbhxrehufFA==
X-CSE-MsgGUID: RtglXEVtSBywKjBgZkzNfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="214928280"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 15:20:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 15:20:48 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 15:20:48 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.15) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 15:20:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wv+1trIdZmgG6YTiLdwtSPkZ6z8hm4KIw6eOTRZ3fO/djGCai+M90O3J8NuPjPlTH/vnjd9hVs1x1fbkMwqk8a7vF13J6YA8q7+jTWiki+tR0jYjl52tBlGcja0FwQm6k5KXMa9H7SRylIOprSt2vj4PEPnDAo2r+cBWdO02XVpG0tOXSQytxcu8jC/+O9xruxtvA2QDoNsDQlnBIPTl+uuDTyl3yHnjR2T4/s30s9JlCYjkF5dB7psXWDtA+zKxDvPKlYGYA1S/A+Y40HZINioa4SOjcGPdyN5/G0iEh7N/pXOo+jqy+aGeJWkEsVxaIc2Xz1o52m4fypUGBm3lVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0X6fVk0Lyfk5iDQCbJG/fRqcL/et4xfVqf3ivMscok=;
 b=bszZ4mey8lJvil0uAuGGO/f3eLB7S13MLYKoZ/DGOtaPHC1fZT19spBH+4ufCJJJLA1MWJQmO53MAoGB0BEZDsw1X5+8JwLrPqXiILJyITMPCJvnxQZ9LaZDvQO+/ha60jXNKmkzbZ7x4kApOqcPNsJY//igVK6p9EHSrr4Fuy1SqPDVL9zFT0WX9f3Z5zAQCfyYjxkKMsdegHsF8YWFuAdDD/Is7w6WtvXeUYNee1ZnOa2YquBNeMHhmxdxXbo1HJqzBv5Kmr2L5mFjthyJuklL0tm3cB7duKPURd3rFPjmktPhqnrgxqd0utSAZPcoFdqHfW23SbRhrL/AprL0dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH0PR11MB7445.namprd11.prod.outlook.com (2603:10b6:510:26e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 22:20:45 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 22:20:45 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org"
	<linuxppc-dev@lists.ozlabs.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "palmer@dabbelt.com"
	<palmer@dabbelt.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "x86@kernel.org"
	<x86@kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"maddy@linux.ibm.com" <maddy@linux.ibm.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "maz@kernel.org" <maz@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
	"anup@brainfault.org" <anup@brainfault.org>, "pjw@kernel.org"
	<pjw@kernel.org>, "zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "kas@kernel.org" <kas@kernel.org>
Subject: Re: [PATCH v3 09/25] KVM: TDX: Fold tdx_sept_drop_private_spte() into
 tdx_sept_remove_private_spte()
Thread-Topic: [PATCH v3 09/25] KVM: TDX: Fold tdx_sept_drop_private_spte()
 into tdx_sept_remove_private_spte()
Thread-Index: AQHcPv2gLm0PphD5f0WVfdqHF7sfHrTPmGoAgABFAACAAHskAA==
Date: Thu, 23 Oct 2025 22:20:45 +0000
Message-ID: <4c2e498be574c9e0e75aa0e8d4f10229d0373785.camel@intel.com>
References: <20251017003244.186495-1-seanjc@google.com>
	 <20251017003244.186495-10-seanjc@google.com>
	 <28136b62074550826efa3f57b1f7be07f571abdc.camel@intel.com>
	 <aPpC7mt3CwWuhv1p@google.com>
In-Reply-To: <aPpC7mt3CwWuhv1p@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH0PR11MB7445:EE_
x-ms-office365-filtering-correlation-id: 44dd29d9-021a-43af-c48b-08de12826910
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ekFVMzMzYjAvNElFSkpVTElZMDBFQmtGWnpXQkh1V0FWVXZFeEZteHYycDVs?=
 =?utf-8?B?Y3dLM2xlK1QrVlVQaHZDdkFCYjJLbXpNTEY5ZVNGTXZJSTVEdjRXQkExdXdR?=
 =?utf-8?B?VmQxS0xrWVBQUFVpRDNTV2g0U0svc0tFd3hBNXdPRTJIdUJ3ZkU4czhteWN6?=
 =?utf-8?B?YmpiQ0JwQVFic200SCt5d240Nld6NTAyV09INEtMMXg1U2MySmxQNHE5d09L?=
 =?utf-8?B?T2pyandyd29RbDhhSlhuNUxhMy95Mm9HUUViT1NPUUJGV1hhSG5WZ2FnM2Qr?=
 =?utf-8?B?VFVtRmh3UUl4emZrVFB0N3Vib0o5QzFaSTNtbGtKVGw3Zk1hSUluKy8ybGl5?=
 =?utf-8?B?ZXR1MlorbUhDWXFyNFhrajhQU1k3M0RqRlRNZzE2Ni8vUWkyZmFLSjV1L1BR?=
 =?utf-8?B?aTdDaG1Xc24xeGVKRXJ3QWRoVVlhREZ1aG5LLytiMzFGZldQcHYyejZHWkpv?=
 =?utf-8?B?ZlZKZDNPUmZNTVdmUHMwZTR1VXN1bFR3YkkyZGE4YURwMVBtTm5KNk90WTUz?=
 =?utf-8?B?cS9sUzlwZXA1ZTIzRmFpR0hMWmcxeURWeDBuNVZHa1hGVlJKdGdlemhiU0Jv?=
 =?utf-8?B?THpkTVZtOXlFTjFvaDdhUDZ6VlVVbE1POUcySWNIY2FBek1sTVY1eVlLaUg2?=
 =?utf-8?B?ektmUVE1Y2NWS3JQRDRnQTFpMFJ2RTVRNFJFYU1vd1Q5Qkg5REpaN0JpbHNt?=
 =?utf-8?B?RmxTL3V5VkljbzM2VU9BV1Zkd3puOTdkVUdVWEZ0ZVJCYU1MY1BJTEMrdHc2?=
 =?utf-8?B?MDNLNTgwS0cxWGpqUEhVS2I1VTJackEyY2l5b1ZCeTJIT25LcStNejRsMVl0?=
 =?utf-8?B?THlNRG01and3T21TTEExc3ZkcHdjZG9jQzlTL1Ixa0I2eU9GbkRWR2llbjZo?=
 =?utf-8?B?RWVkRUhiUEt2b0RBRERvWVFVY3dUbzJydkRBbXpRYTI5TkthRGRzZ2tSempt?=
 =?utf-8?B?S3lPM0kxd09ZY0xVZDRPdWgvaTlmQXVNZUhqcU9NWU9sWllTc2NPVjNjTmlT?=
 =?utf-8?B?aU5yOEtIN1dJTisyOGc1WnF6WkVYbVY5ekNJQ0I3Q2Q3OHdnOWdoVUNLUmVI?=
 =?utf-8?B?ekFhRnFFdVA2cFV6ZWVWRnlYaW8vRzdaaUZ2SWJhektlcUtwU1Y2dWsvL3Js?=
 =?utf-8?B?ak1ucEl2eFhXSFhRbk9lZUFJQU1RYjdIWjB1eklCdjZBcGxTME1idFNTMlZj?=
 =?utf-8?B?YkZaN3QxZElTUzIwdkJqcnlhMVFWeVU4MFBPWFVEQzlZV0pJanJrZWZQdUVL?=
 =?utf-8?B?MWlhQjdrWWVXWm5WT1RFTTA0RFBNSFFJSGpRTWVDdVBzckh3a3V6ZGxxQlEv?=
 =?utf-8?B?QndocHlCT2F5d2FRRG5iVlpPbkR4S0NDQ1BLSnhuUUF6SGJHLzRBQWY4RVY5?=
 =?utf-8?B?VVdxSmpZc1VONVZaS01BQUo4UlE1dnBObHI4bHAzSlFZK1FZNkRucW1BK2Vy?=
 =?utf-8?B?SUZXTTFCQ2x4SEpWTzhhN2R4RjVMRHhlU3pEWHI4NC9Yays5YWFIVzloSFU1?=
 =?utf-8?B?eisyNHFOSURGWnhoZGxYZlg4K1ZtL1JpYkg5eGJEb1lLOE5oeTREbnkyMmw3?=
 =?utf-8?B?U28rQ0lLRnlkM0FQY0k1b0FGdEZxRG1KRHRrcGNyZ2k4K0RyOUU0ZkVlR243?=
 =?utf-8?B?RHFLb0NGQnp5ZXhycENSdGFqMncyYThCd2xoUmNEZlhyeEtoUU5UcUlRYkVs?=
 =?utf-8?B?QnJLRUhQOEgwMENNaHJDNHNmYjdVTC95eTBxRGFsMnN1blV6T3pNK2MvTStV?=
 =?utf-8?B?d3gvTWZCNTNnWmtQL1BBM2FELzJ2Qkx4aG5rQm1wdkxHODlVTnV0ZjlXMG5O?=
 =?utf-8?B?dVVOWllPSHYwUWkwSkNBZ1ZJSDRya1AzL2Ixblp0WFZqdzhqQzBiNHhvcHhT?=
 =?utf-8?B?eFovdmM1eVg0ckp0OHp0cFhuQnJsYkRSSkliajVRYzI1SmZGVlM1WVppRVRG?=
 =?utf-8?B?U3IzL3NtS3c5VjROUmRwc2IzbWFQNU5XNnlZaGtNbHJURDIvZkkyVE40R3Bm?=
 =?utf-8?B?Wnczc3loemlvS2R0MzhsVW9ZR2wxRzVqV0RCdWZxTHFHRlg4RFNaOHYrYVR2?=
 =?utf-8?Q?GQrT6f?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzlpbmxYNkxhcWJDUkJaQjZLVTlIeUZTbkZ4SXkwNVVKTkk1WDJWVHBnc2JM?=
 =?utf-8?B?cmZmVjZUV3pLcWxnazdNQ3ZEOXhBenh4OVhxazZYY3d2bkdBSFJEak9hZzNp?=
 =?utf-8?B?SXVHTE9JdEFpOTV1VDBRK0RFdXJrSmx4Y0gyZDRIdXRNMVRXbGQ2bDBaUm91?=
 =?utf-8?B?OEZBeVd1L3p0Qnc3Sit4WFpUUVVVYnBYWTE3RkVIMmRZYjZNS2U2QTdLb2xT?=
 =?utf-8?B?Q3hMOHpFeXBWYVRtK2VyWVNZQ3FqeEdMc3JBYTdjUElVV2Z5bFN2R09sRFdi?=
 =?utf-8?B?ajlFZGQvTi9meEdpWHpxVHJVOTFiV3Z5clQ0Vmo0T3pIbVJ3MDNFeGNpRmFR?=
 =?utf-8?B?OUFQZldiK1RWdi9oc0o0SEZuNGhrRTRacXFYMnVuU25KUFFPSWlxWStSNnds?=
 =?utf-8?B?Y2RqMFRrcVBleHBiT0pBUlg0K1lZNG1oOWQ0MlQyaGJxcmVRaTNlWHpnMWs1?=
 =?utf-8?B?L2IrN3pBcS9mZ0xXZUsxckFhVGQ1d2t2Z3ArUFNCanZ4VGl2a2E5c2JDTE16?=
 =?utf-8?B?RzdtQSt4SWVMbndPeEtmZThaNCt6QS9BUk1XU1JyV3F5MVRoWmZGZHVPM0FC?=
 =?utf-8?B?b1ByajVoVk9xZ0UzZ0R4MHpKcGNyQ3A1dU1OcEhiLzFBQnJhWEF1emdzQkw4?=
 =?utf-8?B?ak1pMytSZXhWdGVITlFDemNDREpNVUFRT1JScVBQZzhLY0lhUk5ySXBpWWd4?=
 =?utf-8?B?cWhKT0F5eFBpaVBUT0FXQWFYd2FVUlNtUTUrRW90TEo1MncwclozZnUvSkE5?=
 =?utf-8?B?Umo0aWRXNWVxZEZLdXVQcTltM3pERFp2aGt3d0FjQkhiM25mNkhDeHhlblJ5?=
 =?utf-8?B?RU5JQ2FQUHVVaEpmZ21meWpOSm5ibkg2Z0MyS2J1OFh4SG1VbTRRVnNqSVNH?=
 =?utf-8?B?NzVMMW9mV01FTzl4T3RFbzlzeGwrWU0xekFEUWlPb1VRa0RDdzN6MUhzZE5y?=
 =?utf-8?B?Zjh3SW5kWGdkVDQ0S3RTZ2ZCSEw1TEJ0aUVhSDJIQ3BtWFlNSE9DaFhaNnI2?=
 =?utf-8?B?ZDBZU3p1YVJjNmJkeC9ESTA5bGtrQjhvUkFuKzhiOW9VeWtwOGowa2tqdlBL?=
 =?utf-8?B?K2Z2SXNrWVZKSS9aUmVHd0dTMUtVY21VLzlxcTFJWHVZZmwyVDdIVGxSZjg2?=
 =?utf-8?B?Zm5peFFSUmtJT0FVS0xUa1JsQWpTSjJVQnBjNEQ5T3ZkSjluWVFxczFmUTBj?=
 =?utf-8?B?NUU2M3MyQVg1bWpLNmoxdHlDOUJSeU84KzA3WHFROHJRMTFZd0U5U09tem41?=
 =?utf-8?B?aE4vWVBNakZYMmlyZWJJaDE5UUY1U25WbXFMcVQ1a1FCWmloeFlncGpEdWx1?=
 =?utf-8?B?S2FuT1Q3alR3bVlKSmp2M0RDcko1QU5LSkxja01OeFNFSFNLZDd3WmFVZWJt?=
 =?utf-8?B?Ynh2WFRBbVpXQ05SeDFTbEdIM1Z2Mm5pU0t3SmRMeHhjMk1LcmpYS1NZZXVQ?=
 =?utf-8?B?UEdWeUl5cndSQ1dTbHBnL2lMdlV0OThqMW9CejZieU0xaVFHeVpXUjlDZkJG?=
 =?utf-8?B?MkxRbzJmSi9ONzl4ZVF4QnduVlBxK05oa21JSzBRb2hhVEZVazErdFU0SDhG?=
 =?utf-8?B?aVdTUDhUSC8wZ1J3dDFFbldXQUMxajdlTW5TQ3ZnTnZvb1pIQXoreUVGWmZv?=
 =?utf-8?B?WU93S1c1SXYzM3Y5bUkrTHJEQWlBMCtqQmVXUXQwRm9MTk85NTJ4NTFPUTBj?=
 =?utf-8?B?dDNoQk0rUDBHc3NISC8vamRQdkNLTWU1NXpSZ0FKY3Z6ZWJjTXMvdmFPTENF?=
 =?utf-8?B?bG93Q3krRmlwYThCVC9KQVdiVWQ1dm5MbFYxLzhhR25KTVJpOWRaTmtySHhm?=
 =?utf-8?B?Q3VMR2d1WEEwWTFsLy9ZYlJETzJyU1Btck9UZzlENEZCUUF1ZHJEYnBXRTNQ?=
 =?utf-8?B?c01GY3cyTnpnWFJmSG90N1JEczdTa1VpMVF6NmluZEFzVXByeU1JUm9Jcm1u?=
 =?utf-8?B?LzgxWGo0VldPSy9wcy9hekllNFhCOUtSakZoTVU5YjFsVTc3TEdWY09uTkdn?=
 =?utf-8?B?SHVuWkFNMUtnYnZDRkxxOEVGOWI0UWlGU0sySFFNSVhnRjVHMnN0L3VYdjFW?=
 =?utf-8?B?OFRGRjlRZFcxMXpyWUtiMVNHRjBYK0lJOG1XYXAyeVRiOUpaL0dTd3h0aUZl?=
 =?utf-8?Q?9yIC6LLPjBXAZOfjQSAdCRUuu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC69F26A20AAA54F86BEA02E783B0DCA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44dd29d9-021a-43af-c48b-08de12826910
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2025 22:20:45.0651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mh2bOMDJz8Qtky5uKaaSalIbmowY8b9lEpJyrYGEPu3r4uUusDuIEKPFQ/Zm0rGM19AfKp36vlKjV1zZakTV1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7445
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTEwLTIzIGF0IDA3OjU5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIE9jdCAyMywgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyNS0xMC0xNiBhdCAxNzozMiAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IEZvbGQgdGR4X3NlcHRfZHJvcF9wcml2YXRlX3NwdGUoKSBpbnRvIHRkeF9zZXB0X3Jl
bW92ZV9wcml2YXRlX3NwdGUoKSB0bw0KPiA+ID4gYXZvaWQgaGF2aW5nIHRvIGRpZmZlcm5hdGlh
dGUgYmV0d2VlbiAiemFwIiwgImRyb3AiLCBhbmQgInJlbW92ZSIsIGFuZCB0bw0KPiA+IAkJICBe
DQo+ID4gCQkgIGRpZmZlcmVudGlhdGUNCj4gPiANCj4gPiBOaXQ6IGl0J3MgYSB3ZWUgYml0IGNv
bmZ1c2luZyB0aGF0IHlvdSBtZW50aW9uZWQgInphcCIsIGJlY2F1c2UgYWZ0ZXIgdGhpcw0KPiA+
IHBhdGNoIHRkeF9zZXB0X3phcF9wcml2YXRlX3NwdGUoKSBpcyBzdGlsbCB0aGVyZS4gIEJ1dCBp
dCBtYXkgYmUgb25seSBtZQ0KPiA+IGZlZWxpbmcgdGhhdCB3YXkuDQo+IA0KPiBIbW0sIHllYWgs
IEkgYWdyZWUgdGhhdCdzIGEgY29uZnVzaW5nL21pc2xlYWRpbmcuICBIb3cgYWJvdXQgdGhpcz8N
Cj4gDQo+ICAgS1ZNOiBURFg6IEZvbGQgdGR4X3NlcHRfZHJvcF9wcml2YXRlX3NwdGUoKSBpbnRv
IHRkeF9zZXB0X3JlbW92ZV9wcml2YXRlX3NwdGUoKQ0KPiAgIA0KPiAgIEZvbGQgdGR4X3NlcHRf
ZHJvcF9wcml2YXRlX3NwdGUoKSBpbnRvIHRkeF9zZXB0X3JlbW92ZV9wcml2YXRlX3NwdGUoKSBh
cyBhDQo+ICAgc3RlcCB0b3dhcmRzIGhhdmluZyAicmVtb3ZlIiBiZSB0aGUgb25seSBhbmQgb25s
eSBmdW5jdGlvbiB0aGF0IGRlYWxzIHdpdGgNCj4gICByZW1vdmluZy96YXBwaW5nL2Ryb3BwaW5n
IGEgU1BURSwgZS5nLiB0byBhdm9pZCBoYXZpbmcgdG8gZGlmZmVyZW50aWF0ZQ0KPiAgIGJldHdl
ZW4gInphcCIsICJkcm9wIiwgYW5kICJyZW1vdmUiLiAgRWxpbWluYXRpbmcgdGhlICJkcm9wIiBo
ZWxwZXIgYWxzbw0KPiAgIGdldHMgcmlkIG9mIHdoYXQgaXMgZWZmZWN0aXZlbHkgZGVhZCBjb2Rl
IGR1ZSB0byByZWR1bmRhbnQgY2hlY2tzLCBlLmcuIG9uDQo+ICAgYW4gSEtJRCBiZWluZyBhc3Np
Z25lZC4NCj4gICANCj4gICBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4NCg0KWWVhaCBM
R1RNLiBUaGFua3MuDQo=

