Return-Path: <kvm+bounces-65685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 95117CB456A
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 01:08:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 84A5A304A8FD
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 00:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275CD14F9FB;
	Thu, 11 Dec 2025 00:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bgLLv1jJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23982A1CF;
	Thu, 11 Dec 2025 00:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765411676; cv=fail; b=l1jIgrkmjPrIGbMX0lgcm90/rFoPODAdduKFyKCwNKMntcnUGUc6gC6ka2Cl3rWe5lsl+RzuHBP36D+VM4vbDIfslvlFJJxnr7GyfrTBO6Kq1lP73sO4toFBbogN/TGn77S1B32ll52ayhYYUUEmU9/pEae7nwqAGuKzz5++ImQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765411676; c=relaxed/simple;
	bh=Lb9JNCBMQuIe1WDZ37DbsFzvFXv+wE5pnlbxTLIb+qM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Xsy5IryE6BjWvamgNp1Q2W+Nho9oMW9yj5EkiSTOOrp7XmDXgWg79K8o7+h9yBTuv1dekksHqcrbWAkoXFi6u+QTz65iOcHKOw3tivKwbBj/Pn2hNcgI3bkdVuK5m3iP1EzoblOShe7/ExzapV8u1VmMA7u7Z6/5t8qRE1JIvl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bgLLv1jJ; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765411675; x=1796947675;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Lb9JNCBMQuIe1WDZ37DbsFzvFXv+wE5pnlbxTLIb+qM=;
  b=bgLLv1jJmzebhtRon83Q+mFpoMzc0TNwbs6EShuMcD+iEBuWBbc92s2B
   P66jEtY0XfcLdbSidA3j6wcUyW6OrAj8NCg4Il/cySxoZLOwwZ4hnQVqO
   53Ik5OeQjUPrwG5+7d5TL/O1FtfGillrcN9KrbuIMnzXhM1H3jK/CWjrl
   Dfh/ObuIkUWGA7mJcjygqwapFC/A73f5OqtnFlIuEueim9V3E0f5URTqS
   8XECMixEVVIT/CfF45Rqka3SkAUxr8ZBMqbhhgd5B4lNl8RO8hwlhBjJX
   D2z0NoGDe1PMBJ292Lfu4/JGBAUlhGaxgw5A9EuRsaRhqTT60c5wlev65
   w==;
X-CSE-ConnectionGUID: G9h7AfCFTxqWH6W38p3C0Q==
X-CSE-MsgGUID: KSg8kAoZSW+stl3MECp0Eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="90037033"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="90037033"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 16:07:54 -0800
X-CSE-ConnectionGUID: JkAKz5wFSJm4BOWZ9IOTZA==
X-CSE-MsgGUID: 5Mdu6/M9TeqMerLqkUD3fA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227704373"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 16:07:53 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 10 Dec 2025 16:07:52 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 10 Dec 2025 16:07:52 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.42) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 10 Dec 2025 16:07:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CRCaJuWDObxtqxRPhtet5WG9CT/QRmoE6mMD8xcPa9Px7T5d08kcTKDEYRPvDnNrcyJL0M02fXIPcFcmMs4eY7DDxh2xe6mWmrrmSqy7r97IkGj8BgLM+fqRPIEoI/DAmkNZ8YcxEvdnRrpQhNeRnECGw+IttL132f1J2sfInSx4pME4g7S0FHbZW1UlMda0+4W/TOA037F8qgf0b86gitRFUV5wictXmaMOMTNjPoT0CnvSHUzAKJXOI/z1RBpY9u0TfRV8SPtmb6/3q9hCjp+te4KfzJQbsHTbcA2nW5YWNJCn0QN0tfmkSRRma4x4fDcJMcstnjvsu1qKPHQCLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lb9JNCBMQuIe1WDZ37DbsFzvFXv+wE5pnlbxTLIb+qM=;
 b=sxH6BnAI7a2Q2AOQWH/gNXIpzlhiK8wyb1fd7E4R/BmlNKWDjZznphqy5iZe23b4/y0rPwM6bPhL0vSUf4roWPRUKbcQiXlc7GFXVHUHVS/xSygUqo2YFkC/jnlLTl0DEvpe31iQxyVd6SiuYxe5vsxA4M+vzrL3ZJsgoyiSVghWtlvZrQ68V+HbPtC8tWI2ry4j7sTc30POyrvGhk6bInwOPDNKz8d0Uez2y4qwer95+duWBbQ8JeGdvkG09M5+Ygs2GMHFJxthIFMdmfWIF+ikIiNGk2ipCPKdHrG72XIB5+y22BKDcH9rFIwzKdIgGz+Q/u8CcDI08uJhzISjwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB8062.namprd11.prod.outlook.com (2603:10b6:510:251::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 00:07:49 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 00:07:49 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v4 06/16] x86/virt/tdx: Improve PAMT refcounts allocation
 for sparse memory
Thread-Topic: [PATCH v4 06/16] x86/virt/tdx: Improve PAMT refcounts allocation
 for sparse memory
Thread-Index: AQHcWoEIX9Tgaj6+NEu+xgbyqcurk7UFEbOAgABk8QCAALVNAIAVg2oA
Date: Thu, 11 Dec 2025 00:07:49 +0000
Message-ID: <92f4d9766a5b381abeac6c4f6afcf0e4cba183d9.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-7-rick.p.edgecombe@intel.com>
	 <b3b465e6-cfa0-44d0-bdef-6d37bb26e6e0@suse.com>
	 <7dd848e5735105ac3bf01b2f2db8b595045f47ad.camel@intel.com>
	 <69a2dee2-f6a5-4c1b-9daa-8c32ff7c3956@suse.com>
In-Reply-To: <69a2dee2-f6a5-4c1b-9daa-8c32ff7c3956@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB8062:EE_
x-ms-office365-filtering-correlation-id: d988e945-abc9-46d8-bdfe-08de3849523b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?YnFDQlVRQUNlUlB0YlVzOG1YVCsrR1Ywd0RHeXpTZXRGNVZybzkvR1J3bW8z?=
 =?utf-8?B?WGxqdU15ZU4zeWJwa2hZRjlOR245SUc3eDVHdzByMzZubnMxSWNkT0U5WkdI?=
 =?utf-8?B?Vkp2amNEc3dnTnJwcVAyRWoyaVcreC9OeDhzQkl5SGVGUVY2bmZla3BZRmVx?=
 =?utf-8?B?YittN1J6MjUrU0taRW1HenRyY1hsU0gzZTNRaFVZV01Xa3VXR21JUVFmU2s5?=
 =?utf-8?B?SWw1NSs0TUcrcjM2RHZTOTFGb2pGOHpQeHRHbmlyUm1wN0tmSDhwdGVNb3JH?=
 =?utf-8?B?cm4xL2ltZ1BnK1p4a2VTc0xjQWxFZHhQV3lSQlJYVHM4WDVBMkN0VjF2eFBh?=
 =?utf-8?B?N2RkSFdSTkdBaE5GK1NsVDM0ajRUbXdpMHNuajZmWk5mYlJDV3A2Q2RjZlp4?=
 =?utf-8?B?VHFRZUpCYXYvUzc2WHlYbU5naGdKVWQzWEh1L0tKNXdYTVF4L3BHZjJnNlp4?=
 =?utf-8?B?R0JDVHJ1MzdyOGJ5TjlpSW56VmRFVGVabFJ3YVRkbE5vbTlKRHZIeTNPOUtN?=
 =?utf-8?B?cHA3K2xpeUxRK28xcVdTRENhbmg0M2RFNFNNQWxUcldtbWpZN20xbURjQ21M?=
 =?utf-8?B?SVZOM0g1RWxsNmYwcU1ndC96TlFRWFRqRFg4OXBuT3VXMnJBZzluK0RFR0Iz?=
 =?utf-8?B?SzI2ekx1NlFtTnpXd3VRalRlT2FTcEtRREQrdks1SDlNd01MZkE1eHRTMm1m?=
 =?utf-8?B?aWc3Y2hXU1JsQnVVZCszY0dkdFJmaTFneXc0K09EdnVVeWRrTjFRVjY4a3dC?=
 =?utf-8?B?RG5jaXhqTGJKUCtTWk9QS1F2Q0ZpSStFQWI1a2ZUQ0NQWEdOY0FKNzYwMFAy?=
 =?utf-8?B?V1oxS0xFblZGN2pkNThOU2xBbHVDaGpHRGVTT2g2aU9sdCsvTWd0d1pxTDl0?=
 =?utf-8?B?bFBMeGNZTmZTTGxVM1lPbWxSSzRoRUM1M3BWaXJYU1RmZFk2bGRpUkZ0azNh?=
 =?utf-8?B?amdzbndnNFd1bVljTDZsREtHbERFeHpKYzE3N2lQNlR3WnUyRmlFQlA2d1Ar?=
 =?utf-8?B?SjczUTc0NEZOQTlieTJRY0g3OTNhUkpreGo0bzloNmM1U0kzUmZUS0wxTUxW?=
 =?utf-8?B?MGUyM2N0bjhSeHU2NnpDNUZkT3JVbmQxTC9mQTlBQUNvcDg2b29jNTg2Y3h3?=
 =?utf-8?B?OTA2R3Irdis0UE11d01qYTNlVUFoeUxLbmtiWXRQWUNQdnVRL0h3Z1RkSkdH?=
 =?utf-8?B?TFRNbUFSUFhjU1puK3ladmRuTzFSbUZMbnVxVUZnVXFGQ1lUdDFteWl1ck9G?=
 =?utf-8?B?RGx0N3k3bUVaeEQwRWFCQmdPL1ZsSGhyak40U250aFpKNFVWUGVDVTNOa1Yr?=
 =?utf-8?B?RWM4bTNKazM0YmowTFVZcm9kZEVQa0gxR1B3WnNtVUlLU0lzQ1RJVFFwZXBt?=
 =?utf-8?B?YkpGYzAzTWJlTjU0Z3ErdDM1bG1KRlp1V0duQ1Q1bGFsN0hZb20zeHkrcm1a?=
 =?utf-8?B?YVBKTEVMajUzMVlsUytiYzIyZGVWeXozWXIzQTF4SG9IKzRKZ2tyK3F5N3c2?=
 =?utf-8?B?Q1dQUi9jT3ljNTBmaUlOY1Zzd0tZTnNUMXFYcFBPQzkvakFTVHluVG1Ub2Uy?=
 =?utf-8?B?NVpwK3ZOZzBQbGNvc1Ywa0cySFRTa2dOOVYweEhheFVHMEdLWnN5c2EyNmZN?=
 =?utf-8?B?aVpvbDdsWDdHQWE5QkNuUk5yeHZROE1odHJaYXh4QkZjbmRwOW92NVcrSUFi?=
 =?utf-8?B?cU4xRTJuZmE3UzZZL2RmQTZCNTJ5TFVjUitXdmJwVzBxYyt3azByYXhHbTNo?=
 =?utf-8?B?UGFoN1RtYzB4SFMzakJWN1UvNjF5RjlGTUU0bXFvb3BnaUlWdGNnRVZDMHlm?=
 =?utf-8?B?UVlWRjE0cm5sVEpzZjFwVWxTckE1YjlxUWZSNkVIcTh4Vnl3eHNkRFBMNm13?=
 =?utf-8?B?RmRmT3ZiUTR1M004WVpmaWEyM2E4L2lKRnIvR2NIT05qaGVLWVNaWW1NdmVH?=
 =?utf-8?B?a1J3b1VuSGt5TG5xVjFLa3RGWERtWXNmVFpQcXUxOWZTYWlSeUVxMkFjTFJQ?=
 =?utf-8?B?NGtlekM1b3hJcGt2a1RUZ2RxWkFSbmhLclRTVzFPd1dlSlJqLzhjVmlxbEhU?=
 =?utf-8?B?Sk9teEdFVmFtSEVBS3U4NG1aTURPbHNQVlIvZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGdITEV1bE5rMmVQZWZuUllvOVFpZ1g3anYwTGd0NnoxY1JMaE9LTGRCdU51?=
 =?utf-8?B?VEdweUJJNVkvc05maWtLRFpJNHRNLy96UVg2QStxQ2tvbjd2bUhodlFPRGly?=
 =?utf-8?B?cGFRTkZIV1JTSWNLMjFjUWRMdkQya0E2dXFIVkFDYm5qY1Z0VUh5aFZiQlRu?=
 =?utf-8?B?SHFlSnpyVisvSDEzM3lQRjFxRHE5V1hDT01NcEp6WklCYjlRaDlscUV2T1NV?=
 =?utf-8?B?OGE5eDFram1DR3JaNmlkSGVJUDFtS3FZaDE3VjRPSnpTZmZVbDN3VzdpRUFW?=
 =?utf-8?B?WnNkWXV6MkE2UmY3SXVhMjlBMXk1c1pRVE9sVmZ3bUVnd0xselhIbFdYWGdx?=
 =?utf-8?B?L0dEYzIvMjQxT3FYQWx2TE1NV3VsM2kxTDRCNkpKWFZ0TlNUdzF4djczaGg5?=
 =?utf-8?B?bVh2ditCWjVMUTRGMEhLRG1JNmZXb1JEUDFiYTFONVRHM2FxbU5venlZYjhR?=
 =?utf-8?B?enEzUisxZkxPNVprVG5taE9DOFNEWnhGNHdPcDdnSVlKUThRN2JwUjdjRWpT?=
 =?utf-8?B?eXhVZXFLS2hPbStPQkNSbmFtM1lpcC8xUHRXK2lPNkFaNDArSTd4dTB3UGlL?=
 =?utf-8?B?L3VLTENJMG93TEcwOUgvanNaalVtUlIxZjBES0ZXNG5FSlgvZDI3V1JMRit4?=
 =?utf-8?B?cFo1V3V3RzFvUUVyNlBtenAyazNzQXFpZ1NhZTRFaitQdXhvSHhINjRkYlVp?=
 =?utf-8?B?cDI4d21jbm1LVmtzeVJVajl0Y09rWkYyQTVIRUtFYlIzNThZWlNNajJrWDk3?=
 =?utf-8?B?VDF6V21iTytOYkNSMUhZdFdxM0hhRVBBRWxSSFU0NkRXQzUra3dzQ0M2Qytj?=
 =?utf-8?B?Y1BpQnF2cTFkekJxV0RjUTBvV3hMNTFqeXQ4UDVtMHZBSE1iYkptRFU3Z3Rh?=
 =?utf-8?B?WDNXeFdWcDdsa1NkbGVYSktLRlArRm9ZZFdkVFF4WlUrUDlhTmNWMGdsTWI2?=
 =?utf-8?B?QXB6M1pKclZjVHdSTjF1dGxKRExFVDFkU3k2dzdhREo4VnJWMHV6eE01VFgr?=
 =?utf-8?B?RkliMitnR2tXdGY3NFQyU1FZOThZbmJIRWxMdlVTdDhFWUxvd3hkTkI3bVhM?=
 =?utf-8?B?WkM2RGZrS041djBVMjAvLzEyMXVJays5aVZFRU9UVUtIRk5IM2JBVytoVGtP?=
 =?utf-8?B?Yy9mVjJqQVpOQmZ5cXIyL05odFlUajU0bDk3eXZBaDVuVVdpVzAwQjJHem9j?=
 =?utf-8?B?NnZGZXZFVmRsZXJqTEdqOU11V0oxRTBEMDFHeVRXUElPQUNKcExzMHJXWm9h?=
 =?utf-8?B?bmlwTU42czV5WkRkUFEyTmcxL0JxbXAwKytOUStOdkV1MmR2c1dsbloxdUJm?=
 =?utf-8?B?OHk5bWJYemJobEVickM4ZWVpK2JNVldqdUF0cmdPN1JxY1VLS09TaHpNeXVO?=
 =?utf-8?B?QWN6MVk2WmoxMFhpZXg4eHlxenpWUmVKMG8xWEVMMTk1K3ZDcnhQM09hMFdT?=
 =?utf-8?B?N3NEdkFwbnc1VDVySENUamhCKzNvZDZ6bExid3RaUlRKMXV1UVlucldQQ1Zz?=
 =?utf-8?B?aUdLaXdEM3M3dXVsZFBQZ1NvWXBzZVhNWVVQdy8rQnpQOElsVjJPQzBkWnRj?=
 =?utf-8?B?cVpzVW5BWjZUUU9BdHJuTitPRStsR1lNWWUySnpkS2o1ODNGb3RJZ01HS0dH?=
 =?utf-8?B?N0xkNjlBVGk1YzZNUUlhQ3NtNzlOcXRnUUtnUTVZWDBMcFVIcTFSa1pBclB5?=
 =?utf-8?B?bFU5NDNHNyt3R2ZiT1ZOS0FnTVE3UFFDTTQvd2xsaXE0WWlnWS9ISGE2MkdT?=
 =?utf-8?B?S0E2bVhhdTRYRDRLM3BWbmV1a2x2UEMwVUJyZ3ZvQ0JmL1ZRRTFmVWJaZThB?=
 =?utf-8?B?Y1ZmTTY3K3lFQk1HRzd1b2pQdmFEa0hRa3JJQUtjVWtBa3U3ZjBsalZzNnFN?=
 =?utf-8?B?SENrS0pWcjhjTVY2RzI4dTJRQ1ZTdHJQUEVJT2VlYXVLWjd3RG04UDE2eE8v?=
 =?utf-8?B?aHByMXV1Tkx5TFQ1NVRFOHpDSnZBcURwSE82d0Ztb1pCdkU5ZG1BTUM5R1dx?=
 =?utf-8?B?UWVjcG05QjVRdEpKeGo5WUxjeUx0NldvQ2hlRXdGRG9BU3MzaVgrQzVWNHo2?=
 =?utf-8?B?bnpESjRKLzdpanZzTnZkdENmVlpXcDZQMVVjZHdqaTdKb1hGM01oaGZ0MnU3?=
 =?utf-8?B?YjYzc3Z4Tkl0N2lONkZWTU42UzZkRDkzalM3bG1sNk9HKzRpWDJwVGpMeHZr?=
 =?utf-8?B?Vmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6B9298E44D9134C84FE48567847F415@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d988e945-abc9-46d8-bdfe-08de3849523b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2025 00:07:49.5974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: goi95EZbg7m5h81HwjVs8oFTJ2oOmR65mVT/t7bFX1NX7WJx9Z2CNVEPyCs3XY1Q2p5YAcnct4EOwYs2kg6NpkBomUXjXrPj9xxX3L0Jxd4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8062
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTExLTI3IGF0IDA5OjM2ICswMjAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IEkgYWdyZWUgd2l0aCB5b3VyIGFuYWx5c2lzIGJ1dCB0aGlzIG5lZWRzIHRvIGJlIGRlc2Ny
aWJlZCBub3Qgb25seSBpbiANCj4gdGhlIGNvbW1pdCBtZXNzYWdlIGJ1dCBhbHNvIGFzIGEgY29k
ZSBjb21tZW50IGJlY2F1c2UgeW91IGludGVudGlvbmFsbHkgDQo+IG9taXQgbG9ja2luZyBzaW5j
ZSB0aGF0IHBhcnRpY3VsYXIgcHRlIChhdCB0aGF0IHBvaW50KSBjYW4gb25seSBoYXZlIGEgDQo+
IHNpbmdsZSB1c2VyIHNvIG5vIHJhY2UgY29uZGl0aW9ucyBhcmUgcG9zc2libGUuDQoNCldoaWxl
IGNvbW1lbnRpbmcgYW5kIHdyaXRpbmcgdXAgdGhlIGxvZyByZWFzb25pbmcgZm9yIHdoeSB0aGlz
IGlzIHNhZmUsIEkgZW5kZWQNCnVwIHJldmlzaXRpbmcgd2h5IHdlIG5lZWQgdG8gZG8gYWxsIHRo
aXMgbWFudWFsIFBURSBtb2RpZmljYXRpb24gaW4gdGhlIGZpcnN0DQpwbGFjZS7CoA0KDQpJbiBL
aXJ5bCdzIHYyIGhlIGhhZCB0aGUgdm1hbGxvYyBhcmVhIGFsbG9jYXRlZCB3aXRoIFZNX0lPUkVN
QVAuIEthaSBhc2tlZCB3aHksDQphbmQgc2VlbWluZ2x5IGFzIGEgcmVzdWx0LCBpdCB3YXMgY2hh
bmdlZCB0byBWTV9TUEFSU0UuIEl0IHR1cm5zIG91dCB0aGUNClZNX1NQQVJTRSBmbGFnIGlzIGEg
bmV3ZXIgdGhpbmcgZm9yIGRlYWxpbmcgd2l0aCBzcGFyc2VseSBwb3B1bGF0ZWQgdm1hbGxvYw0K
YWRkcmVzcyBzcGFjZSBtYXBwaW5ncywgZXhhY3RseSBsaWtlIHdlIGhhdmUgaGVyZS4gSXQgY29t
ZXMgd2l0aCBzb21lIGhlbHBlcnMNCmZvciBtYXBwaW5nIGFuZCB1bm1hcHBpbmcgc3BhcnNlIHZt
YWxsb2MgcmFuZ2VzLiBTbyBJIHBsYXllZCBhcm91bmQgd2l0aCB0aGVzZSBhDQpiaXQuDQoNClRo
ZSBjdXJyZW50IGFwcGx5X3RvX3BhZ2VfcmFuZ2UoKSB2ZXJzaW9uIGlzIG9wdGltYWxseSBlZmZp
Y2llbnQsIGJ1dCB0aGUNCmFsbG9jYXRpb24gaXMgYSBvbmUtdGltZSBvcGVyYXRpb24sIGFuZCB0
aGUgZnJlZWluZyBpcyBhY3R1YWxseSBvbmx5IGNhbGxlZCBpbg0KYW4gZXJyb3IgcGF0aC4gSSdt
IG5vdCBzdXJlIGl0IG5lZWRzIHRvIGJlIG9wdGltYWwuDQoNCklmIHlvdSB1c2UgdGhlIGhlbHBl
cnMgdG8gcG9wdWxhdGUsIHlvdSBwcmV0dHkgbXVjaCBqdXN0IG5lZWQgdG8gYWxsb2NhdGUgYWxs
DQp0aGUgcGFnZXMgdXAgZnJvbnQsIGFuZCB0aGVuIGNhbGwgdm1fYXJlYV9tYXBfcGFnZXMoKSB0
byBtYXAgdGhlbS4gVG8gdW5tYXAgKHRoZQ0KZXJyb3IgcGF0aCksIHRoZSBjb2RlIHBhdHRlcm4g
aXMgdG8gaXRlcmF0ZSB0aHJvdWdoIHRoZSBtYXBwaW5nIGEgcGFnZSBhdCBhDQp0aW1lLCBmZXRj
aCB0aGUgcGFnZSB3aXRoIHZtYWxsb2NfdG9fcGFnZSgpLCB1bm1hcCBhbmQgZnJlZSB0aGUgcGFn
ZS4gQXQgbW9zdA0KdGhpcyBpcyAyLDA5NywxNTIgaXRlcmF0aW9ucy4gTm90IGZhc3QsIGJ1dCBu
b3QgZ29pbmcgdG8gaGFuZyBib290IGVpdGhlci4NCg0KU28gcmF0aGVyIHRoYW4gdGhlIHRyeSB0
byBqdXN0aWZ5IHRoZSBsb2NraW5nLCBJJ20gdGhpbmtpbmcgdG8gZ28gd2l0aCBhDQpzdHVwaWRl
ciwgc2ltcGxlciBtYXBwaW5nL3VubWFwcGluZyBtZXRob2QgdGhhdCB1c2VzIHRoZSByZWFkeSBt
YWRlIFZNX1NQQVJTRQ0KaGVscGVycy4NCg0KSSBoYXRlIHRvIGNoYW5nZSB0aGluZ3MgYXQgdGhp
cyBwb2ludCwgYnV0IEkgdGhpbmsgdGhlIGRpc2N1c3NlZCByZWFzb25pbmcgaXMNCmdvaW5nIHRv
IGJlZyB0aGUgcXVlc3Rpb24gb2Ygd2h5IGl0IG5lZWRzIHRvIGJlIGNvbXBsaWNhdGVkLg0K

