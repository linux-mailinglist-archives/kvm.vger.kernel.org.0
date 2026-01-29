Return-Path: <kvm+bounces-69597-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OCLnJzWxe2mSHwIAu9opvQ
	(envelope-from <kvm+bounces-69597-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 20:12:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D595AB3D61
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 20:12:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6782A3019FE3
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4696B31281B;
	Thu, 29 Jan 2026 19:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mwNnnojo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55AA1E505;
	Thu, 29 Jan 2026 19:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769713968; cv=fail; b=fqdi6Lzx0rFBgZt+BaSxlPwDEwvL53zjm0xrvhTBxmsvx25ZlfdWPXH//odTNN3QFWs1IyLV1ZHu6vs09tmU1K8IZCVQsIiUkc8/nQD32cT9HPYQuDqR+7IiurvOcF10uKbBwIay2ijZcooZzdLgQPR6mfd//AS+2BU+1iQQvkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769713968; c=relaxed/simple;
	bh=Th7resu0Z3XE2g31MehgP7J4tUqd8SpVY9+GtaKywN8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YcAZZ+Gwm2MDZAVPBD9+hZrs2j6lrR6jbj5jqQIVkBDjHmW05GK0++LRuh5Zrom449NBsfnYrm65CCUjd7sHVp9z5LVbzXJsUKkMxehqSRQoNd/FderLfonviUcOZ4e8UimHt3CRpR07vIJY1w2oZip4Ujw7YMZ+QSVBm13q/ag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mwNnnojo; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769713967; x=1801249967;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Th7resu0Z3XE2g31MehgP7J4tUqd8SpVY9+GtaKywN8=;
  b=mwNnnojonXgnfOdnmWvquXroarmLQTElFX7bohfVyq9wIAArzQh0RTzO
   xIDH34tksAIHZTuHYkeeI9i6E+cxC/khabEUdIGINcgvozesROWJ/MilS
   YqKdtDPEn4a79aKLSZ/+MwsSNRicaMHrn1tWeMZ+H8czNs9g9aDujol18
   /nTjloy8/sV21OqgsnReWeEgKFfIWwBYSYv0FTSCjDDD7W2hX3DaA33Yy
   Pyqj4HPAN5r4XuZr+3wwGek/15LzCw/87ln9z3N9w9BsO5iMCPgQb9hxY
   9MGDStojq+hpQMFkXsjFypU7rfwH1tRPJX4GlOWby+BSbYg7jDr8sj8uX
   w==;
X-CSE-ConnectionGUID: vVcMfh7lSCKkesjBEsLpnA==
X-CSE-MsgGUID: vPOZSrmXRO+XntXsRnlZPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="70859129"
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="70859129"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 11:12:47 -0800
X-CSE-ConnectionGUID: KWnJdJs1S0CoYqHhuhw6nA==
X-CSE-MsgGUID: jK2xinGbSjOY70rm/OaCdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="213191102"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 11:12:45 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 11:12:44 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 29 Jan 2026 11:12:44 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.66) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 11:12:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WyaRi1pUhtIX/gWMsDTRYTQpCttGF97k2QdzapNlAAuT+U7BVIHyqzn7bW+aF7K3c0mcyuC6Py7TF9f5R84WXgGPfQRtuA2seQcwZfeRIyXRFjCFPOyTyaNPeXuoW2C1QmDRYx8C98AjbPUs3plGotdDWSthFQg4RdpEEGcNj3xypi6VPvmOd46iPXQ147ZltQ5CguHyjXu8xsA/koGBu6yp1Uh3PVJdkFr3F7agXs0zyGHrogHKCt7uKPjYthd7aHIJShIwZ8yYnBdvryb9WQ/cNadNYJOlJZz5ntdTEtKjL27w3BCDdmRDIZWlpJ/rv+/eNT37m8uRJiUEzSlCJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Th7resu0Z3XE2g31MehgP7J4tUqd8SpVY9+GtaKywN8=;
 b=g+NO6kR7beIFd9ff+7y9Ipbvn8qHVkkcZswvowxl5s/ydBA8L1gXJUmozXPw/Okv+nLw8C6K7oajyL9e3eHTtSF2gdwzI3g1uKCd4gxzEXSSWY1R0w+t78Crn7S8qY2SER3THJghAUPZ9VliLmrEddB38LSB0sgeLuX8SROWea0iexR9DHgnenyeowJIi6PFMeS7bBMzqXsYeah6pQymIjd7H3ti3GgD8JAIV+nsQslLFHifoS+BMzcHNXlk9/dPTpfZX+/xOFs3Id/ttSZZnJTnggRa6cmUDt+MfNdQXP3XRtRUpAQDr3dcOUjLsxwybw51l2gnelZgESscgr8L/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB8475.namprd11.prod.outlook.com (2603:10b6:806:3a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Thu, 29 Jan
 2026 19:12:39 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9564.007; Thu, 29 Jan 2026
 19:12:39 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Annapurve,
 Vishal" <vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcWoEIh3ODz6GbaUW93Yfuwe0KJ7UDEL+AgAKCH4CAYzLJAIABDGCAgAAengCAAAElAA==
Date: Thu, 29 Jan 2026 19:12:39 +0000
Message-ID: <f47df41b0a20062a74bd7f2fc1875b78632527eb.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
	 <12144256-b71a-4331-8309-2e805dc120d1@linux.intel.com>
	 <67d55b24ef1a80af615c3672e8436e0ac32e8efa.camel@intel.com>
	 <aXq1qPYTR8vpJfc9@google.com>
	 <9096e7a47742f4a46a7f400aac467ac78e1dfe50.camel@intel.com>
	 <aXuweFnbPhoG4Jbk@google.com>
In-Reply-To: <aXuweFnbPhoG4Jbk@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB8475:EE_
x-ms-office365-filtering-correlation-id: 65bc5471-c712-48de-fc85-08de5f6a5e92
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?MmZxOTRyZS9yNGtnYWhxUTVaQW4raXJTZzMvY3IxQXR2RGUxb244OXNPVmxH?=
 =?utf-8?B?Z1pjNDEwMUlPSW11ZWIxcmlIOWNnbm1xMEhxSzJITWhUNHpyWWJqMnR1UnRB?=
 =?utf-8?B?bzhZODROM1Vmcyt5Q0R6SGYySHR6akM5TlprWXJzdXpKZjRKczZtYTV2a2Ni?=
 =?utf-8?B?bzdnRElkRnc3aVM1c3NZbEtWNWtRTzd5MXBpQ3NiaXNmRTVTN3NVQW11ZHZt?=
 =?utf-8?B?dGVudytLNDF3dHVKNlhzRkc5VngyaXZhYTBxRWVubFp2M0pKTUhRZHVwSG8y?=
 =?utf-8?B?UFNkSTFXOFMwQzFwbXJJaEhGd293N3ZRQVNsUmY2RlpuMXI2WGllSlg3UWVP?=
 =?utf-8?B?dnlwUUVaQ29SUHhWcmVkbXlwZ1dna3BqdjFneDJ2SEtYOTRVWlZZYUlMMnpK?=
 =?utf-8?B?Um9JTFhqZUNIc3B5L3JQY0I1dGhnK2VPSS9PeXRHZDFKQ0x6d2xPczV4YnM0?=
 =?utf-8?B?RkNMTm9NbC9wdExrY2RHRUVHR0MvYitEaHZNRnFtRDJzcDkrZnVzRy9ScDk1?=
 =?utf-8?B?NVp6ei8raXVnaWVuTmFYM1ZqL3FSSmVDYUZIc0R0TGwyNFNMSGRaRUdQNFNB?=
 =?utf-8?B?b2J0TndxSE92emtoMGgrQmgvNGdYZThnY1VsVVRQRmEzY1QzMmd2cENGNTVW?=
 =?utf-8?B?NzBpcmtXakFqcCs4ZEdLc1lJcUMxb0ZubVhMREViUkM0ZXhxRUQrSXUreEVt?=
 =?utf-8?B?bmlEN0RrZDkzRWNyWUpKWTZaTnFRTk0rcmlhT0tIUDdISnBCUjRKNmNzOHBW?=
 =?utf-8?B?ZzFMSXdTVC9CZTgyOWdEcE0xMmxYMDVVK3pHN3l4UFdENHlCbnZ1ZHpVdWxS?=
 =?utf-8?B?eHZuYmZmTHpkRXIxbU1kbGxxdFN4eXRlSlBVTWNSb1NsVWhhRnE0dm53dFZ4?=
 =?utf-8?B?OWZRb2JqU3VETjVzR3A3REdnWml3blV6UWlSTHlQTUdaNUV5bHRwWGNIb21V?=
 =?utf-8?B?OUxnTDNmNmMrbWxOSW5vUi8xVGhpZWZXc1Z5bTR1MEx6YWgyb0tqc3ZnRE5F?=
 =?utf-8?B?WkU3WnRPL2dsQmJmNzZjNVhiTFVFZVo4eWY2dnJ6YmozYjh3NGtZNUo1UnNY?=
 =?utf-8?B?RWpPRE5vYnZaZHlHTmkrbzYyeXhWcGlpdnNKYVFEcytiTjFSeFZsK2FoZFg1?=
 =?utf-8?B?bHFnMDdNc1NJVG1aSGhTQ09QRHhwZXFKOFluUDBQS3kwYi9GbWNmYkhLL0cz?=
 =?utf-8?B?ZUV0SW8yK1dldHhWL0sxR3RvQVRJWlhVejRXSjJ4RGYrMDJuN2tqaVg1RlBK?=
 =?utf-8?B?VE1keThQeitVdVpQVnh5MkEvWFRJYVBLZitjclJBOTUzeUJoOGptTXpjdnpI?=
 =?utf-8?B?SVc4am54OHJHUnFPRTNNOWZ2QXdyYkJtK2NxcjIzZjVVVVdTL3UwRGZjSlE0?=
 =?utf-8?B?L2ZRTTE4VUdsY001UWEvVHRkUFpFemkwWEdpcE5nUEVIYTQwOEZHdjZUekNX?=
 =?utf-8?B?YW9MSGlsSEwydVplUVA3a3VneFdHRXR1dEg0Wnp0bzlKY1UrbGVXME5QWS9L?=
 =?utf-8?B?cXZneWthKzNIQ2ZScVlHNVJWTzhQaHhYR0dRSXp1TXZKV3dBd0hvOFVtdnhu?=
 =?utf-8?B?U1dNNlVOcVQ5bWx3TzRVeXRtN3lmUlFLWVp1ZkEwMU1jQWx2bXgxNzFJVkxk?=
 =?utf-8?B?Q2paNjJXZEJmU29PKzIwSjdVMzRCSXI3SVE2Yk5yUGxSVWVLNm91bXZ1TTha?=
 =?utf-8?B?eE1vSCtOMzZBbzhPTHF6U2cvTmlDMGxrMmxKdTlEWjhPOFlzNG40d2lxY214?=
 =?utf-8?B?TVhlazlZOFNINUdhdEtJVnhyQ3BVcFphT3QvM2s0OWkwN1RvNWUvSnhyaTVE?=
 =?utf-8?B?Ukxnc3cyaTlvMUhidjExS25RZDQwWTdmQTExY1VFdWFYaVFqV1kvQXNvVGlw?=
 =?utf-8?B?ZCszenJjVTd5dG9VSCtNMFNoY2tDT0REMFFOYmQwNkxpa2tnMGk3REEzb1My?=
 =?utf-8?B?SFN3UUZ0OTJuTUxZS0Zmcm9BMDhXVkpaRkV0ZVVodHRhVmFPcnBnR1ZqRDlx?=
 =?utf-8?B?c1QrbVZta1RDaGtZVnovOVUwM012NVp4bG5idHFBZkM4WVJDTHJZbzJHUzBE?=
 =?utf-8?B?V1NiMzk3cjViT1hNU09LdTJlNHVKMzhBM0xjb3ZmQ3NUVUJkMm5OSWtPSXlG?=
 =?utf-8?B?UzNFTG9tNW9SV01pclNFa083WGRoTlpBd1FrbHZRNGFzQVlQMFNndGZPMytE?=
 =?utf-8?Q?UCgzOUyMLiW3sVBQKIljFXQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZG50VzQ4SGhJQ2RRbk1pS0NtNnlGcnhOTng3YlRZYXRkSEZhS1dHdzh0enp1?=
 =?utf-8?B?V2ozMnZWYXZabEgxTmxNYU80bWt4SkpPTURJZzBVM3dmYmw1U0xqVGt3blNS?=
 =?utf-8?B?WnAxS2lXRUplZVpxMnZOcUkyRnhHWFNuMmRqbTJOd1UzT3hxTTdrck9PWEJI?=
 =?utf-8?B?MnpPUnlzMU5ZZ1E3aDc5c3JHSHdsZ3lsZXZXODRiQUhzaDE4eWh5NndyeGZ0?=
 =?utf-8?B?bXZMTmVHTG1JWG1kZHErTEN0U3dDa0VwYmw1WDJDWFpRVkN6OWF5Ymw3aTJv?=
 =?utf-8?B?U3lnYnhCNkpRNFQwenlmdDhiSDBDS3EwRldwVHZ4eGNKa2ZqQUFxcTRCQzVv?=
 =?utf-8?B?YUZWUXlnbWVKV3dySDB6eEsvQTh0THB6S2ZDQVFOVFI2RFFDWmZPRFcvbHIw?=
 =?utf-8?B?T3YreDZIWGdsTmVKVVNjRUx5bU5IMnBoZXZTeFZ5QTBubnVqbmFGNTlKL3Z6?=
 =?utf-8?B?K2JWSEZ1TVJwaW12Sm5wNmh0cVBUQy94V3NRK29RaXcxZFAxZmtuZzB2dzVz?=
 =?utf-8?B?RFI3cnlMUXBCU0U5eHBOeWdFcVpVWFR4UVdMMTlHNWtoaXF2WEk0NlRYTmha?=
 =?utf-8?B?M1loOG92NlI1VTVTVEhlYllwaS9nR21jVDhLWlhrMnBEWjRUaUhuazhobWlo?=
 =?utf-8?B?R3hsdzlkMGFPWmZ2U0lLVW0zSHRwTU5WbGIyS0VoTytlQlpZNi91V1JCYXpm?=
 =?utf-8?B?cUYxTVB5SjI4TTlESnVUcENwankvMkd5d0pzc2Q4d1BrS2FndVJ1bzBzMzh0?=
 =?utf-8?B?aUhBMmt5Q1RRL045Z1YrcEQrbktwSUpFdHYweVNpaGhvbzhGRkJxQkVxWkVG?=
 =?utf-8?B?alZTQmNmMzZERDNxdHV5NUFYMFJxdzFsenVaM2tXcm9tZjl6em1PQ3d0bmtu?=
 =?utf-8?B?cTBIQzM4MUJrSWFwM1JiRUh0SFd4M2REM2cxY25NMGRhaGI3b0FIamFCNWoz?=
 =?utf-8?B?VnFVblRkWHNQMmFRcVAwaVZEOGY5NDdVS21JbldrbmpxOFdIcmJVMWt3L0k4?=
 =?utf-8?B?NXRvZk9ndEJSQUdWNjhVUkhuRFA3SHlBb0hzbUYveVJOMEwwV3pCaGxpZ21x?=
 =?utf-8?B?WGJUOVVjUkZqaGY5Rk1SR21aeEVqSFhUUGZQeGdkUE5BUHJFOFRmamJZNW9N?=
 =?utf-8?B?SUNtWCtBQXRwUlJkUldpQ1E2Wml6cVZsUmJGYWp1RkVmc3FnSmtab0IrRm5t?=
 =?utf-8?B?MHB1QSsyZ2lwSVRUVURWY3VwcTJIK1ZkSk43QlNxUjAzSEhJYnRFT1MyNlgr?=
 =?utf-8?B?cTZ5V21EaVBRbGtYOXQwdFNjY1RtYi9KQzJJOVR3UWxYaVBDOUdnekQ1SnhC?=
 =?utf-8?B?cFlxMW9aa2c5dVRmQzU2dmIxdmg4ZGVHSjVzZy9LeHN0clphUVV5SVRZL0RV?=
 =?utf-8?B?UjY3Q2tGYXhidXV6cVdvVFpkbDF5d1gyQlhsUSt0WktjZVhYdXlWc0U5Vms5?=
 =?utf-8?B?aXBJVXRGRUJ0MndBM1RNTGlkdzI5TlluNnI3dGhWSjV4NEh1NU5YTUFHakhZ?=
 =?utf-8?B?YmJxYTZBd2ZWN3pqTDJlaDJzZ1VSby9zUVNyMUtDVWdjeW5xL1VUdWJ3S29q?=
 =?utf-8?B?TTVHV1JZK2hHQWFidkhvNTlhL05oSUZKY1lQallhbnE5b1dFSjBzWEU0OTZT?=
 =?utf-8?B?Q2ZpZHpQdG82eVV2NmVGZG84UFZ1MjZ3UW9hT3pROG5vT09VQkhadDd2SEtI?=
 =?utf-8?B?T284MElJaTEwL3ZsSVJBSzFaaFpCTEUvcTFNYzJwVjBKL2xVeU1Uak1mTFJq?=
 =?utf-8?B?bThaTjZHNDFudHBSRk9PV2c1ZWVYTExFWHl4dmF0ZHVVQzFocnljVGFQaFA2?=
 =?utf-8?B?SDdzL1FLTkc4aDJUa0p0OU9GM0k5MmRkZ0E4NjlVckkxWDBoRGxZSDN0cU5k?=
 =?utf-8?B?TmJXbWNpZGdaU0dramdPRFcxWnBxRk1ndnNyQStNTVE5OUMveWQ4aHY5TWcr?=
 =?utf-8?B?Qzh4N3FyM2sxT0ZGdEdYSC9ZU0tTTVc5U3M4dlh1Wk9pTHdpczVkckNKaWVa?=
 =?utf-8?B?UnNTZUJMMUtXZWZsMzgxWjhNVHVuTlB6OUJKYWZTQzFHNHl6U2J3Zk9vck4x?=
 =?utf-8?B?dXVzNm5jNVplRXZSdHlvdWVrQTNNQ25IaWhYYXVpbmhOZ21lQklhZXFWbjBm?=
 =?utf-8?B?RmRIYUZzdkErZyt2ck9XdW1Tcmp5dmtSajQ1VisveHB6cU9YenVBdDdETWZ5?=
 =?utf-8?B?REhSSTd4WjY2TUFjYk9ueUdGcVI3NmszOVcrRGsxM2VjRERDaWpLendiL1lq?=
 =?utf-8?B?Q2hyZWVNdVVTeXgxN2hOYkpwUkpTQSt5dk52RlZUNTRuU1VyN0k5MFZIS1dq?=
 =?utf-8?B?Njd2alQ2WjdIQzZTZVBlT0pGcTlhRG1JOXBDRFpKL2tiOFVaM2R5Sm1scTlj?=
 =?utf-8?Q?Zm/BZcGsMlQRxNZ4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6062020D2B71114AB27640AEAE9E64A2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65bc5471-c712-48de-fc85-08de5f6a5e92
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2026 19:12:39.1032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nZHQD/XXtRk3coZr+uHceYuWqZXYIMuMuzsZwIK5IMcC1VyntMpzR0EELbRD9LnfC4SyRJ2CatJJhMeHiZFj2/ZeYv9P0Nr73/POJMx37zM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8475
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69597-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: D595AB3D61
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAxLTI5IGF0IDExOjA5IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBXaGF0IHlvdSBwcm9wb3NlZCBpcyBmdW5kYW1lbnRhbGx5IHF1aXRlIGRpZmZlcmVu
dCB0aGFuIHdoYXQgSSdtDQo+IHByb3Bvc2luZy7CoCBJJ20gbm90IGNvbXBsYWluaW5nIGFib3V0
IHRoZSB1bmlvbiwgSSdtIGNvbXBsYWluaW5nDQo+IGFib3V0IHByb3ZpZGluZyBhIGhlbHBlciB0
byBncmFiIGEgcG9pbnRlciB0byB0aGUgbWlkZGxlIG9mIGEgc3RydWN0DQo+IGFuZCB0aGVuIG9w
ZW4gY29kaW5nIG1lbWNweSgpIGNhbGxzIHVzaW5nIHRoYXQgcG9pbnRlci7CoCBJIGZpbmQgdGhh
dA0KPiBfZXh0cmVtZWx5XyBkaWZmaWN1bHQgdG8gZ3JvaywgYmVjYXVzZSBpdCBkb2VzIGEgcG9v
ciBqb2Igb2YNCj4gY2FwdHVyaW5nIHRoZSBpbnRlbnQgKGNvcHkgdGhlc2UgdmFsdWVzIHRvIHRo
aXMgc2VxdWVuY2Ugb2YNCj4gcmVnaXN0ZXJzKS4NCj4gDQo+IFRoZSBkZWNvdXBsZSBwb2ludGVy
K21lbWNweSgpIGFwcHJvYWNoIGFsc28gYmxlZWRzIGdvcnkgZGV0YWlscyBhYm91dA0KPiBob3cg
UEFNVCBwYWdlcyBhcmUgcGFzc2VkIGluIG11bHRpcGxlIGFyZ3MgdGhyb3VnaG91dCBhbGwgU0VB
TUNBTEwNCj4gQVBJcyB0aGF0IGhhdmUgc3VjaCBhcmdzLsKgIEkgd2FudCB0aGUgQVBJcyB0byBu
b3QgaGF2ZSB0byBjYXJlIGFib3V0DQo+IHRoZSB1bmRlcmx5aW5nIG1lY2hhbmljcyBvZiBob3cg
UEFNVCBwYWdlcyBhcmUgY29waWVkIGZyb20gYW4gYXJyYXkNCj4gdG8gcmVnaXN0ZXJzLCBlLmcu
IHNvIHRoYXQgcmVhZGVycyBvZiB0aGUgY29kZSBjYW4gZm9jdXMgb24gdGhlDQo+IHNlbWFudGlj
cyBvZiB0aGUgU0VBTUNBTEwgYW5kIHRoZSBwaWVjZXMgb2YgbG9naWMgdGhhdCBhcmUNCj4gdW5p
cXVlIHRvIGVhY2ggU0VBTUNBTEwuDQo+IA0KPiBJbiBvdGhlciB3b3JkcywgSSBzZWUgdGhlIG5l
Y2Vzc2l0eSBmb3IgYSB1bmlvbiBhcyBiZWluZyBhIHN5bXB0b20gb2YNCj4gdGhlIGZsYXdlZCBh
cHByb2FjaC4NCg0KQWggb2ssIGZhaXIgZW5vdWdoLg0KDQo=

