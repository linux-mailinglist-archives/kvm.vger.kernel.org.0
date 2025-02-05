Return-Path: <kvm+bounces-37293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B7DA28318
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 04:52:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37F453A42AE
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 03:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE94C214215;
	Wed,  5 Feb 2025 03:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W7iViL+X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3129521420B;
	Wed,  5 Feb 2025 03:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738727494; cv=fail; b=Mkm1P/hLIgWRGjKIC7zmtO4PNXTVF6FRIcrIFHtIXBq0M3Kn9s7xQlp0CSXUam5xnUdEJYSkjVNojcHzeShBU2Snuhfv5BvBB4VMWzGFqUxuvyAWexj4QUIjhXG9kPevsKoLNFzasTmbp//8Wglz+uLLc76qVgj9HnMjOFICuyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738727494; c=relaxed/simple;
	bh=PmjBZsSyQT9B4TNqa6D0596F/P/MzNfGBIE6mtbe2PA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N3pujZP9pl1n25q0u+bt4DLwYoJOORRp4R3iuVDwisFsp7eqCfpXfC0SDVdVOotLnHai0+4lnqqIQ6CWN2YpreZ4O/EhYlLOc6WRi/767wnp8anF23lv3rMdbJPY8Ci4SijUqALEiSNNMpf+Oo0WlCylCZHhbmv3dLbi6TD5vNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W7iViL+X; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738727492; x=1770263492;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PmjBZsSyQT9B4TNqa6D0596F/P/MzNfGBIE6mtbe2PA=;
  b=W7iViL+XkfTcHt63boObFrDFYu/Nz6zZY3Nq3KE0ST2e4JreyLRmnQm7
   A4RhKdOY9nlpPejrSarD537mV0LQm7Tv2sh8MptSpnkXShgADnS6jkk6T
   tVAsNpS8g6l83VX8beE9LKET6Simg8EekHxo/HFm8y5WSIbath/q4QPEy
   P8Y2j2d1gusTRVywmoh8hHStW96x6iiZKE7MbAiApJkzCVMCYEEd/QrRa
   1bKogrcQmKRIlutN7792Hjvy+4yK/HLEea5n4khazA+EoXv5v5+CFxpXd
   ETp3e7HZ/8ktAGNo6pe8ChDSxQGXwhvs3n3UlhWC2ZqrToEyTxn1IhwXi
   g==;
X-CSE-ConnectionGUID: SZKS1zr0TNiSpxnJICMMGg==
X-CSE-MsgGUID: x+Oe/H6aTVmPu0KNYguqsA==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="39420959"
X-IronPort-AV: E=Sophos;i="6.13,260,1732608000"; 
   d="scan'208";a="39420959"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2025 19:51:32 -0800
X-CSE-ConnectionGUID: XLT5mksoS5CYARpYF35UVQ==
X-CSE-MsgGUID: x16P5FWxTsmzq2Jlxprnww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,260,1732608000"; 
   d="scan'208";a="111363998"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Feb 2025 19:51:31 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 4 Feb 2025 19:51:29 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 4 Feb 2025 19:51:29 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 4 Feb 2025 19:51:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x+MjA05iQEN3GoSzmteahH2kKmDSP3xmxrxBmvhyJb5OYL7ngUDDat1x0oz2QpBMCssQw4a5eidLLG+BNrejyVsXjZNJvKHb6MSulaDiHRoukW4eAbwB4Bltw3L5xVuMFxa/kLZVJOvmF+g0UMZ222MnE9vOpP0vrDsAl+ZUF6bJcCpeq5lG4A1YSGp37/TuLktqNfTdvv0KWICb1YbBkF9un/9UhPgzD77k+9ADiKWNB31GtgzKbpVd7d+3CaZjDEXWa+gkIUz0npYg0xt7vXD4UghQNbKcPiO3Z7P/5kCQLcIV/CIv6yzh2ZwxEeU0pl4i9HI6JWJtRiXkvQoLuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PmjBZsSyQT9B4TNqa6D0596F/P/MzNfGBIE6mtbe2PA=;
 b=W4Wb6j+zIPV3HxDLr5VEf8D/wllP6p/lEKrGudONM7NeM7Sn436quOp7JqVwTCtqnMcy+/v1xmPt8sSizFOHMjfU9+ziTaSj7ajS/y2/LKT2jqYGioqjE9XyXPEsdmHSd30LIeznKIwohj/G3A5FRK2uoYEmL5yt5Tco+UGffiZSxjPo7GWtnGZPIKRNe4T2+f1feU9z7dAaReqjuA2/m40JKCDmnP8mw1ToNx2EJWHc+zn/fnQjV30TQS2eyKzy69FHHH6VqJ+KrauHaHrpH/mHNA9dzkl8lcld+RJrj5EHZJo7Cahe+ToTAAEA+G50qnC18+2RRsHdIAwOAZP7Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW3PR11MB4633.namprd11.prod.outlook.com (2603:10b6:303:5b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:51:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8398.025; Wed, 5 Feb 2025
 03:51:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Xu, Min M" <min.m.xu@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "dionnaglaze@google.com" <dionnaglaze@google.com>,
	"Wu, Binbin" <binbin.wu@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, "vkuznets@redhat.com"
	<vkuznets@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "jgross@suse.com"
	<jgross@suse.com>, "x86@kernel.org" <x86@kernel.org>, "pgonda@google.com"
	<pgonda@google.com>
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
Thread-Topic: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
Thread-Index: AQHbdeRiwegNjOp2EEirKtkE9yTgJLM14ykAgAAmtACAAClbgIAAGAQAgAHLUgA=
Date: Wed, 5 Feb 2025 03:51:00 +0000
Message-ID: <f1800b4f27554df2b2c538bdbe0a38419a231a09.camel@intel.com>
References: <20250201005048.657470-1-seanjc@google.com>
	 <dbbfa3f1d16a3ab60523f5c21d857e0fcbc65e52.camel@intel.com>
	 <Z6EoAAHn4d_FujZa@google.com>
	 <0102090cd553e42709f43c30d2982b2c713e1a68.camel@intel.com>
	 <Z6Fe1nFWv52rDijx@google.com>
In-Reply-To: <Z6Fe1nFWv52rDijx@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW3PR11MB4633:EE_
x-ms-office365-filtering-correlation-id: 497f9ac4-26cd-4bc9-2cb8-08dd45984e51
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bG1GNGw0U2FxVWV3aUxvWTNMQ3NUV1NvaFc2dWRJVmhQMHJVTjBVU2FJcHNw?=
 =?utf-8?B?TXFpNWhVQnFicVVlK29SUzlvc0IyRGtDeTFsT01IN01TNHBBVk9UTFdSZjdR?=
 =?utf-8?B?NFpETW5STHdmWnAwZDdWV1IrZzVGSnZHbWowbjJsY21TWjkxdWxTdEhKN0ph?=
 =?utf-8?B?VE8rR0NqU2YzT2NBSE9sQ3ZpZE1yM0ttSkVRSGdRc1lWbVYxbUhoOXNpejdC?=
 =?utf-8?B?OHkwNFVNaEpvUWZZM1d3bjBNRUZWb24rTG9jWldUK0lFVVJ1VFZGcFoxek1s?=
 =?utf-8?B?Y0lvSUh4eXIya0tETG1aeU1lV29LQTFtdFR0VjhlaTJZblFPUjUxbGNHVWpR?=
 =?utf-8?B?aGJEcmpvVGx2eXFRN0l2MGN6dzNsbFBzWXc3cGdqeTR2YzNIWWtZK1kveGdV?=
 =?utf-8?B?ZnZUK3lMU2hBM3ZaMk1Ia0x5QytZQ1RqOUMyNUphRzBzL3N2aVE0WFVwQTds?=
 =?utf-8?B?eUt0amZQTjlSaUo0UmN2SkVGTU9TS0JVWXZ0VElHRXN5RkZWNzBLTFl3NUJh?=
 =?utf-8?B?dUZYV21ZNjMyMEJLSzlXVUFYNDF6VEdpUjFTaXlRVFNGSThSeWJyM25rY2U3?=
 =?utf-8?B?bXduTUh4R1RBR2pyUVRML1FSWjRNZXV0aFdOSFVLbnVmMGlZdHNDQ1l0aVlF?=
 =?utf-8?B?UXltdEpPeVBURWFBQmhGaW1mMThid2JncU1taDR3dmtNMWlxdG9sUDNnQWpY?=
 =?utf-8?B?a1ZBQWFGQjFRV0pST1N5Slg0N1Z2aWY3dmZha3J6NUxQczl4MGk0cnliblR2?=
 =?utf-8?B?K2xYU2RhQzFZbU5ONEJ0cjRDYSt1aXpoNUowSUZxcit3VDJmejNGT29uWW1C?=
 =?utf-8?B?V3VFdEdoUHZNUG1Qd1VHc080T1pPV1dSTEI0V0ZqUmQzbFE2dTJMVURyVldk?=
 =?utf-8?B?eGRKaW1tMVRZcEZBTUJUUzhEUzE3ZUN1RkZDdGtmcWorcTdQb0xoNGpBaWZX?=
 =?utf-8?B?MGxEY0tzUXJ1RGo3bFBFK2cwcnY1U3F1d1FBTy9zZ1dLSjFDaXpGUncyTStt?=
 =?utf-8?B?WTc2UEtqQkF4dlM4c3N4SEdBMDYwZjY3N21uN2RiU0J4RzFPbWNuQnJxMC9m?=
 =?utf-8?B?VUVOcW9HTmFzKzBoWkRKNFZ3b2NSaFJTQWlBdjh1U3U1d1lrYVIwQjBFYktk?=
 =?utf-8?B?UnJkSlB2VVg1NlpEbEtCVWFEN2VhOGFwTlZCUEJpSFpIZldGbjFXc2xMdUdO?=
 =?utf-8?B?UVBQY3M0NkN6SGg1S21IQTZtV2VOc1U0citXS0k2N3FFQjIzakJVVjFoNXlH?=
 =?utf-8?B?eVM5d1JvREhqNHIrSzZ1ZEFwSFRWczhjUzJQVm5rV3pncTVsZERNOEFrOUF4?=
 =?utf-8?B?d0VmQWxYbzhlM3ZUQmJYcmNWSVQ3cW1tVEdMUlNEQ2xPdG5kN1ZtYVNwWTRF?=
 =?utf-8?B?Y0FJb0luRlJCTUp4L0t1YysxL1dRTUljdDFZQWVHYkRYdUlLbG1UVk5Dd2E2?=
 =?utf-8?B?Y3NqZkZtTFpJNHQrUzZGZTFKZGdwN2E2dFhwSjB1LzMvRkllR3VnekxUb1Ft?=
 =?utf-8?B?NXRTTmIxOHI3dEM4a3RnWU9UaTNFTzI5azBRdnA4TUlsd1hVSHV1U0ZudEVh?=
 =?utf-8?B?blRBdmVnZ1dKWGh3RHlVeGQ4T2hzUFZXOWpkL0lLZEJ0VVBYaE43ZXZLVTBk?=
 =?utf-8?B?bGtGblIrR3JNT1JxaDAxR2pXZDIycm11ZFkrbkY3YlBNS3hVbWd6bmRYY1Ex?=
 =?utf-8?B?UFZ4WmJuYXF1d3ozZjdteThKOC9SYVlaUG9aQlJ4Rk9LTlZRMTBRRFBIZHQw?=
 =?utf-8?B?aVZxQjJwSXF0NDRtVmliRS9aZW1zVXdTREVnYW8wY0dRQlp3ckw5S2VQa0hJ?=
 =?utf-8?B?NHVIMlVNSDlyQTJFWHo0azdoSFhmc01IY1g4Mks2K2tBRmdWeWx2UG9EeWpH?=
 =?utf-8?B?a2wxSXYxN3hJL1EvRGd4Wmh5RHB2V2xqbFVzRmNtcGdGOUE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWNUb3RQU2V1VGlONTN5MVB4dERzTURvdSs4Q2t2dURRQitseExvMlJtYm9Z?=
 =?utf-8?B?Ty9BMUFhb2laYVlwZjh1UWo1eUI5a0RxNVhJTmJxQ3Y4N0ZUY0Nvc1JlK3U0?=
 =?utf-8?B?SFAwT3M4MzhVNVN6Q3VjMGgrUmxWQlNMWFhoRlYvR0FwTHp0SXBuOXROWlJa?=
 =?utf-8?B?eXIxeEl1L2UwS0pIK3YrNE5NOVNzWVNGWGhkai82ZlVBd2ZvWXM5aGhCUWE5?=
 =?utf-8?B?NGhUdWNsTUVBRzZtNHVTcUwrVklsSGo2M2h2SExmRy8vZWl5UEozMGxkVXNQ?=
 =?utf-8?B?cVN4NE9JR2VzTFBUbWlRRWVJOFdaY0pnVDQvNTR5bzFMcld1T203eGMxYW1i?=
 =?utf-8?B?bW9IaEVzaWZIZjVTc1FnNjh5eFNmWU5QS2NqSWF5V0xwUCtub3NBaWlRcS9h?=
 =?utf-8?B?TVBBZ1hDOGJxeDZXYloyTG1maXVjK0dzUVlZUXdKL0s5K1lmWUlsZkVzbmFj?=
 =?utf-8?B?ampKdHRRTEpGMFgzOVlJNFR6Z05LbnNCRHZPK29CeW5sNG02TjJLVU0rUEVI?=
 =?utf-8?B?N2JQZnVwMmJxM2s0V2VXWGFFdGRoOEhsVXpOc1BSNjlhOEhCNzliNFZrQW5W?=
 =?utf-8?B?Mnl3MWpGRzZoc0l6V0FFUGcwaXNxWk1lNjNZbUpPb2lmcUQyb0VtbjgyRWtN?=
 =?utf-8?B?T1NmMzk1djVrNk9STE9CSG92T2F3MTNlTytaNXVnemJiUVBIUEJSYXdMUHVZ?=
 =?utf-8?B?RUZYeUlpY29NVFRNV3BnNGZEeXNvN01ZSDdtUktydVB2K1oyUVdKaFZyT1F1?=
 =?utf-8?B?SFhsREdxdUJEWElaMTlEN2Z5SkxWYnJrb3NwbGJ3UWpVR0FTQXM0dmQySUFt?=
 =?utf-8?B?WHdnWW95cGhjeGgyWHAyZ3lsOUpvVzVoajFtMEZLek9keWNHbVBQMlJiWEN3?=
 =?utf-8?B?YmdZcVN0RlJnSGFjTUdmUGFobExob29maWEzVXRuakRDd0xBcXdQS3d1L0w3?=
 =?utf-8?B?MkFiVzZsRVZlVFNseWJnUytLMkt5MG53WXBEaU5ETHZMR3QrRDlDazVjSWd1?=
 =?utf-8?B?N1NNL2NUa2ZBMUVrUnd6UVdvM2xsMmNtTmJML2hTOU9MUTdmNGJXRnBwUG41?=
 =?utf-8?B?NzdlV0cwd3k1amcrWnJSaTJuZzM4YUlGaDR2aVJvNnBmZlEvVGcvdFpoR2Zk?=
 =?utf-8?B?YUdaL21ielR4TERpZk1tOTY3MVV2K21LSnJHSWZncDMxc2s5S0MySnQ1VmVn?=
 =?utf-8?B?bFVMdE5neWpaekVWZDZ4NmUrMkFHcEVEK1p0UUpBZWtnSVFsU25BT3p4R1Za?=
 =?utf-8?B?c0JqMmcvZDRabUJqMlpzQzcyOGN0K3UwTTZzZWJma2RaZjcvQkhGL09ZOWcv?=
 =?utf-8?B?WGN5Vi9aYjdyQWsycUtyYjJkdVZTREc4VmxNUUR2K1FEd2lmclRtNVJ6SDU3?=
 =?utf-8?B?TFRBR0tuazQ1QUJQQzdoaDN3WkZaZzNoV2RCVTR0LzFJNVVwcTNQTlpMSUNQ?=
 =?utf-8?B?aXhXdG9pTkFoUG80VDgrems5aXNGRHlWdXNGYTFiK2J6LzJBZGtVOW4xR08x?=
 =?utf-8?B?dnZKZVgySC8vS3hobkYwYldmalhrMUhQWDJSRFdvR3p3V0xkUHErdWJNaS80?=
 =?utf-8?B?WU1kbERmRndCeFBSaWQ5TFJta1hTcFV5anVOT0RGRndOdUNWZFNUWFdCaXo1?=
 =?utf-8?B?QXdldkIvektDc3lDb0p0c1JBU3pyQ1d4T244dEJyUDBjcWU1a0dPREJYS1hT?=
 =?utf-8?B?UjBxLytHS3RyUXVjbGpXSWpHR3pMSWxGNkgxd1FHNU9ia2xPeHJpSzN1RVlY?=
 =?utf-8?B?VmF5Q083QkZzSnRZYlZsVGorUU5BejhPdU1aaTBwd3ZHdk1DaVc1WjZLY0Ft?=
 =?utf-8?B?Z1hUczFkSERGcENUQXdtK3JiN1hFN3hhMzdvWmluc3pRb2VBZTZ0Y3ZGdFRW?=
 =?utf-8?B?WlJESXliV3NFTk9uR0hmUGNXM3ZrMUpPRVlqSldEM3lFSXl6YzBHTWQzRjhR?=
 =?utf-8?B?Sk9ZQzM0RHBNZS9CNzBsSy9sWjVYMDQxVWRhRnIreU1McUFIb0tyRCtPTkFY?=
 =?utf-8?B?NUZ2MUt6RmJmTDVsOW9aV3F1ekxYWXFRSy8weURCMnJGMGIwK1hSZnR6NlNP?=
 =?utf-8?B?Q1gyaTFQeEdsUmw5SWV1SEF4eUFDZExzOWgwVjA4VEJ2M1FMeDUzSFExcVhR?=
 =?utf-8?B?VmtNY216dFhVcEdXTmsvRVBCRzhLbEtaMWtpT2FqYU43RGljZGlHdHdJVFRZ?=
 =?utf-8?B?T0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <604CCB0DA8501C47A98B199F25120265@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 497f9ac4-26cd-4bc9-2cb8-08dd45984e51
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2025 03:51:00.7297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XiuNrJ6hFSrU9Xnt/A85X8fQBXDtXlAN8elHftFx3kBcMipxNnU0Fja59RQCin8mJtixME6HjF8rNu229oLLcxwTU65XgGy9PyR62GPubzI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4633
X-OriginatorOrg: intel.com

K01pbiwgY2FuIHlvdSBjb21tZW50Pw0KDQozYTNiMTJjYmRhICgiVWVmaUNwdVBrZy9NdHJyTGli
OiBNdHJyTGliSXNNdHJyU3VwcG9ydGVkIGFsd2F5cyByZXR1cm4gRkFMU0UgaW4NClRELUd1ZXN0
IikgdHVybmVkIG91dCB0byBiZSBwcm9ibGVtYXRpYyBpbiBwcmFjdGljZS4NCg0KRnVsbCB0aHJl
YWQ6DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vMjAyNTAyMDEwMDUwNDguNjU3NDcwLTEt
c2VhbmpjQGdvb2dsZS5jb20vDQoNCk9uIE1vbiwgMjAyNS0wMi0wMyBhdCAxNjoyNyAtMDgwMCwg
U2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gT24gTW9uLCBGZWIgMDMsIDIwMjUsIFJpY2sg
UCBFZGdlY29tYmUgd3JvdGU6DQo+ID4gT24gTW9uLCAyMDI1LTAyLTAzIGF0IDEyOjMzIC0wODAw
LCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+ID4gPiBTaW5jZSB0aGVyZSBpcyBubyB1
cHN0cmVhbSBLVk0gVERYIHN1cHBvcnQgeWV0LCB3aHkgaXNuJ3QgaXQgYW4gb3B0aW9uIHRvDQo+
ID4gPiA+IHN0aWxsDQo+ID4gPiA+IHJldmVydCB0aGUgRURLSUkgY29tbWl0IHRvbz8gSXQgd2Fz
IGEgcmVsYXRpdmVseSByZWNlbnQgY2hhbmdlLg0KPiA+ID4gDQo+ID4gPiBJJ20gZmluZSB3aXRo
IHRoYXQgcm91dGUgdG9vLCBidXQgaXQgdG9vIGlzIGEgYmFuZC1haWQuwqAgUmVseWluZyBvbiB0
aGUNCj4gPiA+ICp1bnRydXN0ZWQqDQo+ID4gPiBoeXBlcnZpc29yIHRvIGVzc2VudGlhbGx5IGNv
bW11bmljYXRlIG1lbW9yeSBtYXBzIGlzIG5vdCBhIHdpbm5pbmcgc3RyYXRlZ3kuIA0KPiA+ID4g
DQo+ID4gPiA+IFRvIG1lIGl0IHNlZW1zIHRoYXQgdGhlIG5vcm1hbCBLVk0gTVRSUiBzdXBwb3J0
IGlzIG5vdCBpZGVhbCwgYmVjYXVzZSBpdCBpcw0KPiA+ID4gPiBzdGlsbCBseWluZyBhYm91dCB3
aGF0IGl0IGlzIGRvaW5nLiBGb3IgZXhhbXBsZSwgaW4gdGhlIHBhc3QgdGhlcmUgd2FzIGFuDQo+
ID4gPiA+IGF0dGVtcHQgdG8gdXNlIFVDIHRvIHByZXZlbnQgc3BlY3VsYXRpdmUgZXhlY3V0aW9u
IGFjY2Vzc2VzIHRvIHNlbnNpdGl2ZQ0KPiA+ID4gPiBkYXRhLg0KPiA+ID4gPiBUaGUgS1ZNIE1U
UlIgc3VwcG9ydCBvbmx5IGhhcHBlbnMgdG8gd29yayB3aXRoIGV4aXN0aW5nIGd1ZXN0cywgYnV0
IG5vdCBhbGwNCj4gPiA+ID4gcG9zc2libGUgTVRSUiB1c2FnZXMuDQo+ID4gPiA+IA0KPiA+ID4g
PiBTaW5jZSBkaXZlcmdpbmcgZnJvbSB0aGUgYXJjaGl0ZWN0dXJlIGNyZWF0ZXMgbG9vc2UgZW5k
cyBsaWtlIHRoYXQsIHdlIGNvdWxkDQo+ID4gPiA+IGluc3RlYWQgZGVmaW5lIHNvbWUgb3RoZXIg
d2F5IGZvciBFREtJSSB0byBjb21tdW5pY2F0ZSB0aGUgcmFuZ2VzIHRvIHRoZQ0KPiA+ID4gPiBr
ZXJuZWwuDQo+ID4gPiA+IExpa2Ugc29tZSBzaW1wbGUgS1ZNIFBWIE1TUnMgdGhhdCBhcmUgZm9y
IGNvbW11bmljYXRpb24gb25seSwgYW5kIG5vdA0KPiA+ID4gDQo+ID4gPiBIYXJkICJubyIgdG8g
YW55IFBWIHNvbHV0aW9uLsKgIFRoaXMgaXNuJ3QgS1ZNIHNwZWNpZmljLCBhbmQgYXMgYWJvdmUs
IGJvdW5jaW5nDQo+ID4gPiB0aHJvdWdoIHRoZSBoeXBlcnZpc29yIHRvIGNvbW11bmljYXRlIGlu
Zm9ybWF0aW9uIHdpdGhpbiB0aGUgZ3Vlc3QgaXMgYXNpbmluZSwNCj4gPiA+IGVzcGVjaWFsbHkg
Zm9yIENvQ28gVk1zLg0KPiA+IA0KPiA+IEhtbSwgcmlnaHQuDQo+ID4gDQo+ID4gU28gdGhlIG90
aGVyIG9wdGlvbnMgY291bGQgYmU6DQo+ID4gDQo+ID4gMS4gU29tZSBURFggbW9kdWxlIGZlYXR1
cmUgdG8gaG9sZCB0aGUgcmFuZ2VzOg0KPiA+ICAtIENvbjogTm90IHNoYXJlZCB3aXRoIEFNRA0K
PiA+IA0KPiA+IDIuIFJlLXVzZSBNVFJScyBmb3IgdGhlIGNvbW11bmljYXRpb24sIHJldmVydCBj
aGFuZ2VzIGluIGd1ZXN0IGFuZCBlZGsyOg0KPiANCj4gVGhpbmtpbmcgbW9yZSBhYm91dCBob3cg
RURLMiBpcyBjb25zdW1lZCBkb3duc3RyZWFtLCBJIHRoaW5rIHJldmVydGluZyB0aGUgRURLMg0K
PiBjaGFuZ2VzIGlzIG5lY2Vzc2FyeSByZWdhcmRsZXNzIG9mIHdoYXQgaGFwcGVucyBpbiB0aGUg
a2VybmVsLiAgT3IgYXQgdGhlIGxlYXN0LA0KPiBzb21laG93IGNvbW11bmljYXRlIHRvIEVESzIg
dXNlcnMgdGhhdCBpbmdlc3RpbmcgdGhvc2UgY2hhbmdlcyBpcyBhIGJhZCBpZGVhDQo+IHVubGVz
cyB0aGUga2VybmVsIGhhcyBhbHNvIGJlZW4gdXBkYXRlZC4NCj4gDQo+IEFGQUlLLCBCcmluZyBZ
b3VyIE93biBGaXJtd2FyZVsqXSBpc24ndCB3aWRlbHkgYWRvcHRlZCwgd2hpY2ggbWVhbnMgdGhh
dCB0aGUgQ1NQDQo+IGlzIHNoaXBwaW5nIHRoZSBmaXJtd2FyZS4gIEFuZCBzaGlwcGluZyBPVk1G
L0VESzIgd2l0aCB0aGUgImlnbm9yZXMgTVRSUnMiIGNvZGUNCj4gd2lsbCBjYXVzZSBwcm9ibGVt
cyBmb3IgZ3Vlc3RzIHdpdGhvdXQgY29tbWl0IDhlNjkwYjgxN2UzOCAoIng4Ni9rdm06IE92ZXJy
aWRlDQo+IGRlZmF1bHQgY2FjaGluZyBtb2RlIGZvciBTRVYtU05QIGFuZCBURFgiKS4gIFNpbmNl
IHRoZSBob3N0IGRvZXNuJ3QgY29udHJvbCB0aGUNCj4gZ3Vlc3Qga2VybmVsLCB0aGVyZSdzIG5v
IHdheSB0byBrbm93IGlmIGRlcGxveWluZyB0aG9zZSBFREsyIGNoYW5nZXMgaXMgc2FmZS4NCj4g
IA0KPiBbKl0gaHR0cHM6Ly9rdm0tZm9ydW0ucWVtdS5vcmcvMjAyNC9CWU9GXy1fS1ZNX0ZvcnVt
XzIwMjRfaVdUaW9JUC5wZGYNCj4gDQoNCkhtbS4gU2luY2UgdGhlcmUgaXMgbm8gdXBzdHJlYW0g
VERYIEtWTSBzdXBwb3J0LCBmb3IgaXQncyBwYXJ0LMKgSSBndWVzcyBLVk0NCnNob3VsZCBzdGls
bCBnZXQgYSBjaGFuY2UgdG8gZGVmaW5lIGEgY2xlYW5lciBzb2x1dGlvbiAoaWYgdGhlcmUgYWN0
dWFsbHkgd2FzIGENCmNsZWFuZXIgc29sdXRpb24pLiBCdXQgeWVhLCBpdCB3b3VsZCBtZWFuIG9u
bHkgY29tcG9uZW50cyBmcm9tIGFmdGVyIHRoZQ0Kc29sdXRpb24gd2FzIHNldHRsZWQgY291bGQg
YmUgdXNlZCB0b2dldGhlciBmb3IgYSBmdWxseSB3b3JraW5nIHN0YWNrLiBBbmQNCml0wqBzaG91
bGQgcHJvYmFibHkgYmUgY2FsbGVkIG91dCBzb21laG93LiBNYXliZSBjb3VsZCBiZSBpbiB0aGUg
S1ZNIFREWCBkb2NzIG9yDQpzb21ldGhpbmcuDQoNClN0aWxsIHNlZW1zIGxpa2UgYSB0aGluZyB0
byBhdm9pZCBpZiBwb3NzaWJsZS4NCg0KPiA+ICAtIENvbjogQ3JlYXRpbmcgbW9yZSBoYWxmIHN1
cHBvcnQsIHdoZW4gaXQncyB0ZWNobmljYWxseSBub3QgcmVxdWlyZWQNCj4gPiAgLSBDb246IFN0
aWxsIGJvdW5jaW5nIHRocm91Z2ggdGhlIGh5cGVydmlzb3INCj4gDQo+IEkgYXNzdW1lIGJ5ICJS
ZS11c2UgTVRSUnMgZm9yIHRoZSBjb21tdW5pY2F0aW9uIiB5b3UgYWxzbyBtZWFuIHVwZGF0aW5n
IHRoZSBndWVzdA0KPiB0byBhZGRyZXNzIHRoZSAiZXZlcnl0aGluZyBpcyBVQyEiIGZsYXcsIG90
aGVyd2lzZSBhbm90aGVyIGNvbiBpczoNCj4gDQo+ICAgIC0gQ29uOiBEb2Vzbid0IGFkZHJlc3Mg
dGhlIHBlcmZvcm1hbmNlIGlzc3VlIHdpdGggVERYIGd1ZXN0cyAidXNpbmciIFVDDQo+ICAgICAg
ICAgICBtZW1vcnkgYnkgZGVmYXVsdCAodW5sZXNzIHRoZXJlJ3MgeWV0IG1vcmUgZW5hYmxlZCku
DQoNCkhtbS4gVGhpcyBpcyBxdWl0ZSB0aGUgdGFuZ2xlZCBjb3JuZXIuDQoNCj4gDQo+IFByZXN1
bWFibHkgdGhhdCBjYW4gYmUgYWNjb21wbGlzaGVkIGJ5IHNpbXBseSBza2lwcGluZyB0aGUgQ1Iw
LkNEIHRvZ2dsaW5nLCBhbmQNCj4gZG9pbmcgTVRSUiBzdHVmZiBhcyBub25ybWFsPw0KDQpJJ2xs
IGhhdmUgdG8gZ2V0IGJhY2sgdG8geW91IG9uIHRoaXMgb25lLiBLaXJpbGwgcHJvYmFibHkgY291
bGQgZ2l2ZSBhIGJldHRlcg0KYW5zd2VyLCBidXQgbGlrZWx5IHdpbGwgbm90IGJlIGFibGUgdG8g
Zm9sbG93IHVwIG9uIHRoaXMgdGhyZWFkIHVudGlsIG5leHQgd2Vlay4NCg0KPiANCj4gPiAgLSBQ
cm86IERlc2lnbiBhbmQgY29kZSBpcyBjbGVhcg0KPiA+IA0KPiA+IDMuIENyZWF0ZSBzb21lIG5l
dyBhcmNoaXRlY3R1cmFsIGRlZmluaXRpb24sIGxpa2UgYSBiaXQgdGhhdCBtZWFucyAiTVRSUnMg
ZG9uJ3QNCj4gPiBhY3R1YWxseSB3b3JrOg0KPiA+ICAtIENvbjogVGFrZXMgYSBsb25nIHRpbWUs
IG5lZWQgdG8gZ2V0IGFncmVlbWVudA0KPiA+ICAtIENvbjogU3RpbGwgYm91bmNpbmcgdGhyb3Vn
aCB0aGUgaHlwZXJ2aXNvcg0KPiANCj4gTm90IGZvciBLVk0gZ3Vlc3RzLiAgQXMgSSBsYWlkIG91
dCBpbiBteSBidWcgcmVwb3J0LCBpdCdzIHNhZmUgdG8gYXNzdW1lIE1UUlJzDQo+IGRvbid0IGFj
dHVhbGx5IGFmZmVjdCB0aGUgbWVtb3J5IHR5cGUgd2hlbiBydW5uaW5nIHVuZGVyIEtWTS4NCj4g
DQo+IEZXSVcsIFBBVCBkb2Vzbid0ICJ3b3JrIiBvbiBtb3N0IEtWTSBJbnRlbCBzZXR1cHMgZWl0
aGVyLCBiZWNhdXNlIG9mIG1pc2d1aWRlZA0KPiBLVk0gY29kZSB0aGF0IHJlc3VsdGVkIGluICJJ
Z25vcmUgR3Vlc3QgUEFUIiBiZWluZyBzZXQgaW4gYWxsIEVQVEVzIGZvciB0aGUNCj4gb3Zlcndo
ZWxtaW5nIG1ham9yaXR5IG9mIGd1ZXN0cy4gIFRoYXQncyBub3QgZGVzaXJhYmxlIGxvbmcgdGVy
bSBiZWNhdXNlIGl0DQo+IHByZXZlbnRzIHRoZSBndWVzdCBmcm9tIHVzaW5nIFdDICh2aWEgUEFU
KSBpbiBzaXR1YXRpb25zIHdoZXJlIGRvaW5nIHNvIGlzIG5lZWRlZA0KPiBmb3IgcGVyZm9ybWFu
Y2UgYW5kL29yIGNvcnJlY3RuZXNzLg0KPiANCj4gPiAgLSBQcm86IE1vcmUgcHVyZSBzb2x1dGlv
bg0KPiANCj4gTVRSUnMgIm5vdCB3b3JraW5nIiBpcyBhIHJlZCBoZXJyaW5nLiAgVGhlIHByb2Js
ZW0gaXNuJ3QgdGhhdCBNVFJScyBkb24ndCB3b3JrLA0KPiBpdCdzIHRoYXQgdGhlIGtlcm5lbCBp
cyAoc29tZXdoYXQgdW5rbm93aW5nbHkpIHVzaW5nIE1UUlJzIGFzIGEgY3J1dGNoIHRvIGdldCB0
aGUNCj4gZGVzaXJlZCBtZW10eXBlIGZvciBkZXZpY2VzLiAgRS5nLiBmb3IgZW11bGF0ZWQgTU1J
TywgTVRSUnMgX2Nhbid0XyBiZSB2aXJ0dWFsaXplZCwNCj4gYmVjYXVzZSB0aGVyZSdzIG5ldmVy
IGEgdmFsaWQgbWFwcGluZywgaS5lLiB0aGVyZSBpcyBubyBwaHlzaWNhbCBtZW1vcnkgYW5kIHRo
dXMNCj4gbm8gbWVtdHlwZS4gIEluIG90aGVyIHdvcmRzLCB1bmRlciBLVk0gZ3Vlc3RzIChhbmQg
cG9zc2libHkgb3RoZXIgaHlwZXJ2aXNvcnMpLA0KPiBNVFJScyBlbmQgdXAgYmVpbmcgbm90aGlu
ZyBtb3JlIHRoYW4gYSBjb21tdW5pY2F0aW9uIGNoYW5uZWwgYmV0d2VlbiBndWVzdCBmaXJtd2Fy
ZQ0KPiBhbmQgdGhlIGtlcm5lbC4NCg0KWWVhLg0KDQo+IA0KPiBUaGUgZ2FwIGZvciBDb0NvIFZN
cyBpcyB0aGF0IHVzaW5nIE1UUlJzIGlzIHVuZGVzaXJhYmxlIGJlY2F1c2UgdGhleSBhcmUgY29u
dHJvbGxlZA0KPiBieSB0aGUgdW50cnVzdGVkIGhvc3QuICBCdXQgdGhhdCdzIGxhcmdlbHkgYSBm
dXR1cmUgcHJvYmxlbSwgdW5sZXNzIHNvbWVvbmUgaGFzIGENCj4gY2xldmVyIHdheSB0byBmaXgg
dGhlIGtlcm5lbCBtZXNzLg0KPiANCj4gDQoNClllYSwgSSB3b25kZXJlZCBhYm91dCB0aGF0IHRv
by7CoEkgaW1hZ2luZSB0aGUgdGhpbmtpbmcgd2FzIHRoYXQgc2luY2UgaXQgaXMgb25seQ0KY29u
dHJvbGxpbmcgc2hhcmVkIG1lbW9yeSwgaXQgY2FuIGJlIHVudHJ1c3RlZC4NCg0KQW5kIEkgZ3Vl
c3MgdGhlIHNvbHV0aW9uIGluIHRoaXMgcGF0Y2hzZXQgaXMgaHlwb3RoZXRpY2FsbHkgYSBiaXQg
bW9yZSBsb2NrZWQNCmRvd24gaW4gdGhhdCByZXNwZWN0Lg0K

