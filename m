Return-Path: <kvm+bounces-53051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA34BB0CEED
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 02:53:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8229C7AB873
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 00:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B060714A639;
	Tue, 22 Jul 2025 00:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WdzAkmrO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEFB1C32;
	Tue, 22 Jul 2025 00:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753145618; cv=fail; b=Y/zPh+OTIIBCj5j1AjLv/DmMZfTFTlN1rJ7gyOzEJ73lBZjfhzmfkHyLEUpxkb0Mr4Wm9n8c2MLpRs5+LRffFTUg7Y6X1csF33aXNEooxr6DJGQygUxPZMFBMfm6LiD1QUFfz84MxydsbSdQjc+Q86JX5on/SdLoUdCOAhfTCEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753145618; c=relaxed/simple;
	bh=x2aIOjY4E2QvYv2MSs0rd0pm0cQgqMjkRmICFzKHYZ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=euFrkFhHAc5gU8UbbrqK/EXXon7oFHK8eYnmoXsBcKG/I43T8nhaRSVOVXI2eQEcyyU7gq0FNG8orhnoqbyFX2F5EHos8gQsyZdV9X6tuyUXaMHAfKOXISFygBUYrmBHqERPJUHnz+d+Lo5sdBh5M1P4ZhbmDwazcEoabZzL+GM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WdzAkmrO; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753145617; x=1784681617;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=x2aIOjY4E2QvYv2MSs0rd0pm0cQgqMjkRmICFzKHYZ4=;
  b=WdzAkmrO2KRFLw1NC3kakvvRgVMRe5LWpbXfpTRi7OFjsUIy6U9mbZnF
   y7pw9HygUaWe40dQh/H0NOjzEjbMfLuy+L9yhIc7RiN/469YmLIvR1oAH
   W3mHO6DbdVpNLwOhaMtZT8FAQ6naHS8Uk77b6vbwIZhh86tZx7bfJ3R37
   oMlmpcQTvnxt7VFuo3+tvpFkOuB3S55Gs1952ohwiYe00fyqIhffKc/Ae
   zfVb/PKJ3lStbWhj0j063HCsbQEtmlzUI+C+gVHWm2YhhrQKU7R3jxJUh
   GXTaeh64hWLd4jMDoYNftdDEy+cRV74dSWElTyReStmL8OiNpMVTzOJzq
   A==;
X-CSE-ConnectionGUID: HCXpowu0TkSsX07z2fHgmA==
X-CSE-MsgGUID: uUz5e/NNTT6M8tsr7mccZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="65643268"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="65643268"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 17:53:36 -0700
X-CSE-ConnectionGUID: 1AEF1jEoQwGX4KJ7qghI1A==
X-CSE-MsgGUID: gwKoIw1GSvW3ofaDwffKog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="159080966"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 17:53:36 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 17:53:34 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 21 Jul 2025 17:53:34 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.60) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 21 Jul 2025 17:53:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A54OTWFVwRyTWGbL8FIiCl8xrz+qKNoeF20xlEm6NwKexi74VU+icfdFFTaXNOxl7wwBbKHHhjjfX5WMHFygI9CvOFui5HTDMjYDXQzq8T/BUhrhbbeWVIxVHtfS95r13m1gaIwYdzdOsUr0SlSb7Ea9JAU9XV+iQU6x7sScZzlyq/ugMeEYHo0VDb7bSkUjQJfwXjRT31Yl8PWgcQto7x/sG5rzov7oVD1DLYMoyapj7ZP7ufZKjfhbbWJ6jla4WA3YdocdOlN7crvUOrXoy4+tkHALRo0AcJEe+3f57dfTfPqyO5surNq1Lu1MiZbj/6eZ5hc6STykJjqLeJVOYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2aIOjY4E2QvYv2MSs0rd0pm0cQgqMjkRmICFzKHYZ4=;
 b=rfpBVLWs8RxOrBW3jqY13iHjZh6M9TGxCnWjan80hmnwff0UzDFfPjkAF3W8KlJwBdeSA+2ktYLK7Br88cLuwhgUPnwuUtgV/LTR2czju9ja92RqPjoYuzMmuKo6M6bdaYGqbZH3gJk9rc8jI5iXdewpxIqPCxoLf71XzR6p6zt4xZGoC4ScXqS0AazUyW0I881OhuEtW17X+BLxj55Kp1UcG7OokUn6tNuXJh6IFrj1MDVSNGTbJLTZn/1Sc44FKCCbB4djS5Mqk0m5ML7qz5LEz/+CyxABY3gQMKt8Lhf9bj79LvuCgrEVHTT24ZeO/1Sm1YS1GsNM8GMA8myS7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB7662.namprd11.prod.outlook.com (2603:10b6:510:27d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.25; Tue, 22 Jul
 2025 00:53:26 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 00:53:26 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "hpa@zytor.com" <hpa@zytor.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Hansen, Dave"
	<dave.hansen@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>
Subject: Re: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Topic: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Index: AQHb92MJH4Vi4bs6uUOSkG2OAWH7LbQ8rCmAgABvgwCAAAIgAIAAAokAgAAYrgCAAAYskIAABDyAgAARSYCAAAKSgA==
Date: Tue, 22 Jul 2025 00:53:26 +0000
Message-ID: <c198c40d6df2d48dd6050ec003abb78c065f1b40.camel@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com>
		 <c7356a40384a70b853b6913921f88e69e0337dd8.1752730040.git.kai.huang@intel.com>
		 <5dc4745c-4608-a070-d8a8-6afb6f9b14a9@amd.com>
		 <45ecb02603958fa6b741a87bc415ec2639604faa.camel@intel.com>
		 <7eb254a7-473a-94c6-8dd5-24377ed67a34@amd.com>
		 <1d2956ba8c7f0198ed76e09e2f1540d53c96815b.camel@intel.com>
		 <38C8C851-8533-4F1E-B047-5DD55C123CD1@zytor.com>
		 <BL1PR11MB5525BEC30C6B9587C2DF23A0F75DA@BL1PR11MB5525.namprd11.prod.outlook.com>
		 <c494ea025188c6b1dcf7ef97a49fcd1cf2dab501.camel@intel.com>
	 <D6A63DDD-6A33-4A78-8A3F-2A7D0ACC9902@zytor.com>
In-Reply-To: <D6A63DDD-6A33-4A78-8A3F-2A7D0ACC9902@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB7662:EE_
x-ms-office365-filtering-correlation-id: cce78519-0631-40b9-8183-08ddc8ba2adb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U2NKWWF3Q2xGNnRrUjIreTN5akh5dU5SeER3TjVIRW10T3kyNmxxbTZIaGRh?=
 =?utf-8?B?eXhxdlZreGtiZ3ZBZWc1dE5nTmIxaU9VSUJPSktYUEdaRkxYMzFtU1JNTE44?=
 =?utf-8?B?ZVNtbXgvQ1JFaWZsazl0UnlNZG5velEwNzkzTHgyTVhPRjhBaGZOSW1oL0ZI?=
 =?utf-8?B?aHRMUjZmMDN0VFplTUtVTFkzRjVhaGRUdWZ1bUY2Y2ZCc2lxK2N4WklES2dB?=
 =?utf-8?B?ZHhLUE43ZUpTYWxnVkZZRm9yVkJha3NBMW1EYmpXOXhRWURaRVZPeStpbC90?=
 =?utf-8?B?T29WYVNMbTFFOUlOSzYyUzFUVGFxZzdJcWVwVmhNYnRweTAzOHo5c0IvSXBG?=
 =?utf-8?B?TGNGMzhEQWVKaklhMG9JRFdTVTZOVUJ5V0I0eStvNmFqcEJKMWxoc3BORXh3?=
 =?utf-8?B?RHZwZTZ4VHlBRE8zNDFGUWxLdHF5RTNXV2pMcjB0NldLeCt2R3ArOTlmdUk1?=
 =?utf-8?B?dUV2TG9sZ05xdHEwbDJaUVpjaFhBMmFKTlJ6ZE0wYnJNVkFYb1JaK0g0QkNp?=
 =?utf-8?B?V2lvREdNUVArd0s1UTZNUWZyVXFPbUVEV1c4OC9uUm4zaVU4Z09SVzN0aHEv?=
 =?utf-8?B?dS9udWM0d0Q1VlFuSExwNEFKNUhOT0lwQ2VSY1pCT0s4T2lGd2dqZG5ad2wy?=
 =?utf-8?B?cnJHd1VaVWN4WWlNY3JTYjQyMWwrUEZiNGJ4RHgwY2F4L09qd3F0TVYyV2FS?=
 =?utf-8?B?em4vZ2lROGx3aGU5Q2MwNS9yOG13bUJ5VlRVMC9vdWJLRkIzOGRnT0pGWGRW?=
 =?utf-8?B?OE8vYmtZT0xReUxkTk9wM2JmekZiTzFaQ1FQTXlNeDVHMzBMU3JwSkJPZm4w?=
 =?utf-8?B?R3NLdDJpMFBIN3pUNGNWcnhTaXorVmxNRGZ5M0REdEJlK1JhMFN0Ui9mM2cy?=
 =?utf-8?B?UmwyczZDeXB4bWpLM0w3Z2hiSTF3OSt4a0xFbFZZQ1JQWkt5UjRQVkNGSHJ3?=
 =?utf-8?B?bU5NQU1PT3lUdDZDa29lVzNadmhXMjVDc1FMbXE3bWMwdWhUK0lUcTZUZFU5?=
 =?utf-8?B?MzV2bWpZRkRKTXB1cTlkUXR5QkwyRjFjQnJMK3F3bE9iQjFMZVlqS2RpYVFK?=
 =?utf-8?B?VVp5aGR2YzJIaWtqSTd3MXRpcmJkT2ZkVW9IbndCcU03WGd5cmV2UmcxKzVT?=
 =?utf-8?B?YmZiZ0N5Z2lPamFmZkQ4UUNuWS94MUxZS1BScDBXZTRrSmxhb3EvVmJuOUEw?=
 =?utf-8?B?dTV5aG9qSXdhdmRiRHB2Vk1QL29IWGpQeDJTNnlHQmo4djYzR0NKelArdjc5?=
 =?utf-8?B?WkVkV3F3RGdxZWVSbXZsY1BEWnpES0czWDdMVHllTm5jZ0drRWZYTXJjN2RN?=
 =?utf-8?B?dTdRY3owQ3BwZ2RRU2EyVzJ4aVVOTWExc2oyZEg4ZUpTNzJWS21Ydkhzb25E?=
 =?utf-8?B?RFVZZUVKeC8xTDZuYXNVWkRISmt2bWJFY2cyTFdBdjZVT2JoZ2xtajNUUDFU?=
 =?utf-8?B?elF4R253cldjb0ZsUGZJUE9FUVp3ejRVaWg5S3BqTG9NMjhRZmRFQTIyMHRW?=
 =?utf-8?B?cWozMlk4bXdZS1NFTHc4Wjh5QnA1RzFqemo2NmFXOURxUzl3czFlM0p3SmMz?=
 =?utf-8?B?Z3RFdWZjdXRMb05heUNCWlp2L3lpZkVMOHV3WC8yK2N4YzBEVHhrYkx5L1g1?=
 =?utf-8?B?eDl6V0Y3YVJiNGVqaU1UQnNxOStHNVZoODVBdHdsL01YSXR3Ym9CQ1RldkpK?=
 =?utf-8?B?SEo1RUZJZFBLbUdNRWJrLytpMzFvNGhVUnN4K0h3QnEvdnVaYkxCN2xwa0tp?=
 =?utf-8?B?czV2VC91aFpodDlNNEtzKzU2VFZUeE1hVnB0OFA1ZEVTVnRKRGZCd3RUdzkr?=
 =?utf-8?B?eVdmZE5VU1hMK2tqZjg4UUdud25GY2IyRUtSbEVQRW8za0dpRm1SSTVRY3hN?=
 =?utf-8?B?WGY0UmtFVDA1ckFuRFBQQ1pmMjhseTlpRHJNQ0RiZ3pJODlsR3hTNzZvaFJO?=
 =?utf-8?B?MEFxaFhPMzEyK1ozWHR0blZQTnRGLzJLbTFVVERUcGFKUDNNRGp6MDZwY3Nj?=
 =?utf-8?Q?IfmMOHcNqeVPUfkPLL62+vUSFcU1y8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cnFMQUtIMytMaUYvOHNlOVZCL2JWZEVSd0hiLzlpTzgycUIzaVo5Wm92SDFP?=
 =?utf-8?B?UzZMME9mRzNsZzZnUzhnQ0RvTVFocTZLOHArdEV5RlNDc3VzOXZrSkhqaG52?=
 =?utf-8?B?WVVtemxyTWYwaGlGN1BXRGpGbzVqS1lNZjVRbXpxb2lOTVU0UmlyUm5iMnp0?=
 =?utf-8?B?dVdhckV2ZDFMbVB3bkwzK1lFb21uTzhiWTFGL09NZDU0QWNVZVkvODBFT0tG?=
 =?utf-8?B?NGMzQTh1WTlKNVZIN05iakpHdThMZjRlSmRZc0VLQ0pOVGJiVFhDaHRaaXV4?=
 =?utf-8?B?a1FVN3hqTm44U204SExwU0ZJMHZKUVdNVWVsUG80SDM3d0R1aFdsb2FSenF2?=
 =?utf-8?B?L1pSUWhoQWVablJQTTYyY0NUTnMvWmFzRWxjNGMza0FCZGhHaXkxSmwram5O?=
 =?utf-8?B?RUFvS0pXeVVjYkEyOXdCZXpvci9KVHBYYmFkTWI1Y2g3T0FiamRJd3RaWEtG?=
 =?utf-8?B?Y0hDUkpja3Z0NkV0MFBBVjhzUFN5bkxhZm5WTk9vbzFDMXo3bDdoWTJZc0VO?=
 =?utf-8?B?Qm9BYlE2VU5RT0Y2bWdtQ3BRWEdEQ0taakRVaUEvUmhqMFl1cXMzWG1FdGRj?=
 =?utf-8?B?Yi9obEFXUGlTajZCQVQxNGM0eEEwR01jZ294SHFsYTBCS1VHdlVoVGk1OVBE?=
 =?utf-8?B?WHFzdzRQb091cEZWM3l6T01aZXl6OEpxeXAzOVp0MXNmUWlubjZEZTdCZlRh?=
 =?utf-8?B?WjRlZExzM0tKclF5c0J5bUp5eWtkSGZxNWdYS2k5czJJVnRPYlpmeTloUlpD?=
 =?utf-8?B?RmhTUDRwNkNvS3d5UHl5WWlkL1BEQmdYZVJHNWVpakp4WVd2MDA4cm9LakFR?=
 =?utf-8?B?L2VJMDAzaGpnQ05vdXpBeHpxT09sT3hzVmlxdVBWdm5SMXJqbk4zL3JDcmkx?=
 =?utf-8?B?Y1YvVFk4Z1Y3aTZRUGFxazJNSVpOK0tMMXExdEFGZ0tjcnRNUXpoSlJyQlh5?=
 =?utf-8?B?WVNEaVNFQXhXUERyTjFtMkgwQXpReUxheTJpZ0JzUHIrUzdFUEFyT0grRUg2?=
 =?utf-8?B?aXpDcXd5K2xpU3hSaUIxVzVJRm9iVnNnajVpbjdQd3djV3hxb1Q2RSs1bGN6?=
 =?utf-8?B?STlIYUlwOThwVTdOS1RtcXFZWXZrT3dWUlZERndKVkk1em50ai85TkcwaWQx?=
 =?utf-8?B?UUVlOWppVER5ZTNoclNBU1NQczdwSm5KdW9pbFVpcTVMQXhaTFJzREdCN24v?=
 =?utf-8?B?WnNBdVBnRVlGMWg0MTVzUW1Va3ZmN1kzcmdhUUNteGRjdDJPZk8yMnN6dlBX?=
 =?utf-8?B?Q012ckRrVUpwdzBVUXFwSmtCbTd5bEplSi9pNzJEdms1eFBwMzhpVzE4WWpL?=
 =?utf-8?B?YksydFJWVEVzVDVTVmVJZEVoVzc3VTY2SVNGSi90d0lLTFZISFU3Qk5jdkgx?=
 =?utf-8?B?QmxBbjh6YTBRVS96b1MwR3ozTE1CeFl2R0RmTUMvbkNDbGJFcU5Wd0thUWhE?=
 =?utf-8?B?ZzVUMU80NDJOQnFVL1RVQzZOZjY5KzdYUGhOaUdRdGYzdXJVdmcweEx3US91?=
 =?utf-8?B?aGIybWZJbUJqZ0x0YzNhaWUxV20zcEhuQ3Vjb293aGk5ZEM5ZzY3eVNuSFdv?=
 =?utf-8?B?cUFkVXB4Rk9pcHdPNnZmb09Kek5VRWQ0OGt3Z0Z5eWNRZ3owYWZBdmw0Skl3?=
 =?utf-8?B?WWJQbXk0b0FDb1I5S29zcGlrb211V0ZLWHdWbm9Yck94aTRXNFZuUzlpaHhE?=
 =?utf-8?B?RGdycVJ2bExaY3g3REQ3cEtET1AwUityYllwdzZBZzlNdUxBVWRHZDQrTXVX?=
 =?utf-8?B?TWVKcHEyc3ZoNkNydVk0UUhUMXI0YnRpaENJSEFhRDJ5NFFzK3kybzlIQitK?=
 =?utf-8?B?bGs0RlVuWUwva1ZaNllST3lNZm02RVQ2MTBVVGx2Zm1tVStudlVTTEV6TjlR?=
 =?utf-8?B?d29IWHk1TzhTRmplcGN1bGgwdTBWaytCME1zUUNwbUpBRm5KZGZoMEhEQmlk?=
 =?utf-8?B?dUhqLzFLb2xHV1VHdmRETFI1SUh1VEswQkRFYms5ZE8vaHRjQ3pqTDlHaXZZ?=
 =?utf-8?B?WGxjbVdSdXp5RXRjM0Nuc3MrMlBRMFZkUEg3alZBUzZMNDhpNEgvdTNPRnpW?=
 =?utf-8?B?RDdsOVFYeTkrRTVra0FqNjdUMWU2L0xoZUQwWGZSaEdJTkx2T010NEM5bVVX?=
 =?utf-8?Q?wiL4zRNA/ggSmZLrLGiBXOq/I?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED5BD2A5D903B343BFAFE37F7C573A03@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cce78519-0631-40b9-8183-08ddc8ba2adb
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2025 00:53:26.4654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /hs9DDV+NTg0JWmJySDkfKMor1Epd0l6D8tcLaq0Ef57LOV2ES4+cROQfNm8WX+JdluSL1aizYK6qgY5co2dbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7662
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA3LTIxIGF0IDE3OjQ0IC0wNzAwLCBILiBQZXRlciBBbnZpbiB3cm90ZToN
Cj4gT24gSnVseSAyMSwgMjAyNSA0OjQyOjIyIFBNIFBEVCwgIkh1YW5nLCBLYWkiIDxrYWkuaHVh
bmdAaW50ZWwuY29tPiB3cm90ZToNCj4gPiBPbiBNb24sIDIwMjUtMDctMjEgYXQgMjM6MjkgKzAw
MDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiA+IE9uIEp1bHkgMjEsIDIwMjUgMjozNjo0OCBQ
TSBQRFQsICJIdWFuZywgS2FpIiA8a2FpLmh1YW5nQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPiA+
ID4gT24gTW9uLCAyMDI1LTA3LTIxIGF0IDE2OjI3IC0wNTAwLCBUb20gTGVuZGFja3kgd3JvdGU6
DQo+ID4gPiA+ID4gPiA+ID4gPiBAQCAtMjA0LDcgKzIwMiw3IEBADQo+ID4gPiA+IFNZTV9DT0RF
X1NUQVJUX0xPQ0FMX05PQUxJR04oaWRlbnRpdHlfbWFwcGVkKQ0KPiA+ID4gPiA+ID4gPiA+ID4g
wqDCoAkgKiBlbnRyaWVzIHRoYXQgd2lsbCBjb25mbGljdCB3aXRoIHRoZSBub3cgdW5lbmNyeXB0
ZWQgbWVtb3J5DQo+ID4gPiA+ID4gPiA+ID4gPiDCoMKgCSAqIHVzZWQgYnkga2V4ZWMuIEZsdXNo
IHRoZSBjYWNoZXMgYmVmb3JlIGNvcHlpbmcgdGhlIGtlcm5lbC4NCj4gPiA+ID4gPiA+ID4gPiA+
IMKgwqAJICovDQo+ID4gPiA+ID4gPiA+ID4gPiAtCXRlc3RxCSVyOCwgJXI4DQo+ID4gPiA+ID4g
PiA+ID4gPiArCXRlc3RxCSRSRUxPQ19LRVJORUxfSE9TVF9NRU1fQUNUSVZFLCAlcjExDQo+ID4g
PiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gSG1tbS4uLiBjYW4ndCBib3RoIGJpdHMgYmUg
c2V0IGF0IHRoZSBzYW1lIHRpbWU/IElmIHNvLCB0aGVuIHRoaXMNCj4gPiA+ID4gPiA+ID4gPiB3
aWxsIGZhaWwuIFRoaXMgc2hvdWxkIGJlIGRvaW5nIGJpdCB0ZXN0cyBub3cuDQo+ID4gPiA+ID4g
PiA+IA0KPiA+ID4gPiA+ID4gPiBURVNUIGluc3RydWN0aW9uIHBlcmZvcm1zIGxvZ2ljYWwgQU5E
IG9mIHRoZSB0d28gb3BlcmFuZHMsDQo+ID4gPiA+ID4gPiA+IHRoZXJlZm9yZSB0aGUgYWJvdmUg
ZXF1YWxzIHRvOg0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gwqAJc2V0IFpGIGlmICJS
MTEgQU5EIEJJVCgxKSA9PSAwIi4NCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IFdoZXRo
ZXIgdGhlcmUncyBhbnkgb3RoZXIgYml0cyBzZXQgaW4gUjExIGRvZXNuJ3QgaW1wYWN0IHRoZSBh
Ym92ZSwgcmlnaHQ/DQo+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBE
b2ghIE15IGJhZCwgeWVzLCBub3Qgc3VyZSB3aGF0IEkgd2FzIHRoaW5raW5nIHRoZXJlLg0KPiA+
ID4gPiA+ID4gDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gTnAgYW5kIHRoYW5rcyEgSSdsbCBhZGRy
ZXNzIHlvdXIgb3RoZXIgY29tbWVudHMgYnV0IEknbGwgc2VlIHdoZXRoZXINCj4gPiA+ID4gPiBC
b3JpcyBoYXMgYW55IG90aGVyIGNvbW1lbnRzIGZpcnN0Lg0KPiA+ID4gPiA+IA0KPiA+ID4gPiAN
Cj4gPiA+ID4gWW91IGNhbiB1c2UgdGVzdGIgaW4gdGhpcyBjYXNlIHRvIHNhdmUgMyBieXRlcywg
dG9vLg0KPiA+ID4gDQo+ID4gPiBZZWFoIEkgY2FuIGRvIHRoYXQsIHRoYW5rcyBmb3IgdGhlIGlu
Zm8hDQo+ID4gDQo+ID4gSSBqdXN0IHRyaWVkLiAgSSBuZWVkIHRvIGRvOg0KPiA+IA0KPiA+IAl0
ZXN0YgkkUkVMT0NfS0VSTkVMX0hPU1RfTUVNX0FDVElWRSwgJXIxMWINCj4gPiANCj4gPiBpbiBv
cmRlciB0byBjb21waWxlLCBvdGhlcndpc2UgdXNpbmcgcGxhaW4gJXIxMSBnZW5lcmF0ZXM6DQo+
ID4gDQo+ID4gYXJjaC94ODYva2VybmVsL3JlbG9jYXRlX2tlcm5lbF82NC5TOjIxMjogRXJyb3I6
IGAlcjExJyBub3QgYWxsb3dlZCB3aXRoDQo+ID4gYHRlc3RiJw0KPiA+IA0KPiA+IEknbGwgZG8g
c29tZSB0ZXN0IGFuZCBpZiB0aGVyZSdzIG5vIHByb2JsZW0gSSdsbCBzd2l0Y2ggdG8gdXNlIHRo
aXMgd2F5LA0KPiA+IGFzc3VtaW5nIGl0IHN0aWxsIHNhdmVzIHVzIDMtYnl0ZXMuDQo+ID4gDQo+
IA0KPiBUaGF0IHdvcmtzIGp1c3QgZmluZS4NCg0KWWVhaCBJIGhhdmUgbm93IHRlc3RlZC4gVGhh
bmtzIDotKQ0K

