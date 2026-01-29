Return-Path: <kvm+bounces-69638-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YGBkCErke2nBJAIAu9opvQ
	(envelope-from <kvm+bounces-69638-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:50:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AB5EAB5842
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:50:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 577DB3062234
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4AC36B075;
	Thu, 29 Jan 2026 22:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HOfVmPGY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0BF36B040;
	Thu, 29 Jan 2026 22:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769726900; cv=fail; b=h5oHluMrebqbZtj5vzmlb2Q2/Zh2ija5GRV63o43BQghMTaoV1Y4lqKnn5YlgvZHEM2Gx2gxWNjO1my3kGtBuUBr6HKqB3ZMfQDrXN9tfC0ZX9Ec0nSEJGsxFRtGgXVpgRSY70X/l6YVAU9h5LpVQCvYxV8jSg8TDgEW7832XRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769726900; c=relaxed/simple;
	bh=ZltBVGF7zN/+QdMlUKcDjRjHA8HPScuevKss8XmLliU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PUQx5/FZg13shDoIIB1Hg24pJv9hfQJc1Gupm+34m+4lq6ZG9QEWNboKxpe544LykhGflG+DMZWH0CDoC8fxn33/zHYIfECb/+owNpn3h5Njv8/FFT39His/JV7L+U8+ebIKp0EIj8e+AnX40p6FJFOa6PErNspd+gWCRYSVDf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HOfVmPGY; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769726898; x=1801262898;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZltBVGF7zN/+QdMlUKcDjRjHA8HPScuevKss8XmLliU=;
  b=HOfVmPGYUULRhXDyzN/gmoybz+LUl95VWV4ftmTzQWlzkycOSvHfNx0u
   RBbyFuHI7pT9Is5bbW273+Mfm1VxYi6NpHG65dDJw1qOl/2nBviboFSm/
   EqVMcNZU8AdgxYqop/yduGYVfkmLCGVcm8VJLi9+OiLmE1HFDZUDMY/nw
   2wmph+knje1mRfjC7ZfEec/yvcRKVT18M7Z3UxrPbqMCXs4dOOMiZmzpY
   C/WW3K2vL72C63yvzirvJGqocf+0+pAK1VSAQyqZ+lHb2enLyBOe8K6K9
   T6SigdxqZtu95yFoL7lPHMnHiKlE/7IDoHFDEO99Ep2cMJvSBhncJVRGp
   g==;
X-CSE-ConnectionGUID: jwGbYlxORnKyarpMknBwuw==
X-CSE-MsgGUID: dPiaP5zFShGpPKo7wh1nlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="82407209"
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="82407209"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 14:48:18 -0800
X-CSE-ConnectionGUID: BAj5SjqfT2GoGcMX964gQg==
X-CSE-MsgGUID: nb5Nm6yEQHmBpENVTH1p/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="209121379"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 14:48:17 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 14:48:16 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 29 Jan 2026 14:48:16 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.6) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 14:48:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bPQf0ecUBd37zyb7hL40291q+9+dxjB1vNpHLIDSoHkbc6lBwvUxJgbmMA/15Ott3nqyu4YJFfVlqYDHcJ2kcU6RVLmJDpzvDjYS5SThMvpKbIjX6r7afavaopbVZ0nPkp9iIlUho2bY5Xe3z3VyDCJxsp+qLSYiK3SO2vKh2QWYyy+pDFTlcgObjViAzshjDfRFjdTHi0OVwEc8x/+geV7SHsg7ph7AzsMNU0yT+Tmbf2vs/+T/p5u1ZKwikYB+OWITLE0T7UDc242UtobW4DpmR4h6iu8rw3XDw7OFKIFfvYkp0enR5FF/xWEg6otHM5U/4Z0aotdxnejRb1q3aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZltBVGF7zN/+QdMlUKcDjRjHA8HPScuevKss8XmLliU=;
 b=etc1DdC/m6ATFazTReyNdZKio0xguJrT8Cbb81B/qcHStKSu9Ha+KwvfURfHAQar1ggNxQ+lH6eKZBmskKeEq3wMeaEeoFT8bsc9DOJ6i9EwY8B17Pk+u5VES0WML5Zs5bGSU2hPMpKSz7e9Dc5BxUAAPZqlVqKy67FXW7C2foRtmGN0h3Le496WsOUd8VBDmEmImbZgfGb/uoh35CEBAnb2eQX8asdl39j9QiHtmz3RTt4gJDqqOHEevRnEFRUbp2nR9wA6LCTlNNKMTaOsyHb0vgnnlbIbaQGP4pqgyZjKiRDTnwLmtx+RWVP0wkrozHzWYshd/xoYtGp5NCXVjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM3PPF1B59FAA3B.namprd11.prod.outlook.com (2603:10b6:f:fc00::f0f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Thu, 29 Jan
 2026 22:48:12 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9564.007; Thu, 29 Jan 2026
 22:48:12 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kas@kernel.org" <kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sagis@google.com" <sagis@google.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "Annapurve, Vishal" <vannapurve@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v5 02/45] KVM: x86/mmu: Update iter->old_spte if
 cmpxchg64 on mirror SPTE "fails"
Thread-Topic: [RFC PATCH v5 02/45] KVM: x86/mmu: Update iter->old_spte if
 cmpxchg64 on mirror SPTE "fails"
Thread-Index: AQHckLzJq8v9Vhu8u0ueQ1FsCiqC7LVptryAgAADjICAAAbugA==
Date: Thu, 29 Jan 2026 22:48:12 +0000
Message-ID: <ac4d337f508eef06f354b60e4f9baff2eb727fde.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-3-seanjc@google.com>
	 <fbaeb0d2f4658efd4c7bb61ac0ba2919c8226a36.camel@intel.com>
	 <aXvd2z8HmLFd50io@google.com>
In-Reply-To: <aXvd2z8HmLFd50io@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM3PPF1B59FAA3B:EE_
x-ms-office365-filtering-correlation-id: f0997127-096c-48d9-0c80-08de5f887b95
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bDBWNHRHR0pFSGlNcVBiT01kRDluT29kTURZYUR6RjM4VzFNNmQweW5RdDI3?=
 =?utf-8?B?SDlCWHFldTdIR1ZyRS9DT2hobHpmQVdka3hqYUJzVzlaOEdGR3VMbGY5eVhk?=
 =?utf-8?B?eHZlbW1aUDE1Sk9GZStNb0RlVzVjZGk4WXhQMjd3T09GWkw5R2xWVlQ4ZXR5?=
 =?utf-8?B?YmNnaWhEZ1hwdlNpZ3FMOTJrOFJjcmxLQ3RqbEYvYXhnQTlSU0F2QUR6dWdH?=
 =?utf-8?B?VlJuY3psUTk3RnJpNVYva1BuaXVINjZnTDVvTndzZ2VQd3lvb0pqQXZKUE41?=
 =?utf-8?B?QXNXdDNuR29zTGx2NWxYTmlSQWd2Z2p0ZmV5Rmg1d1hVb3d0M29BZFJhWjhL?=
 =?utf-8?B?QjkzYjMxYVNOZllwOGI3dXZQS1NTcWZRQ3JRb2JYd3hyVmlOd0NQNXdPdmRF?=
 =?utf-8?B?NVBNRGNMZlNHN05CKzlLRWFENFhtRmE4bno0MGpxUm1qZmhBOEJuMnJTS3JK?=
 =?utf-8?B?UUJYVnNrY0JNR0RubGJrQnNYL3JNNURGK1g1dWRkWnNDTE83UnBUL1Qzelow?=
 =?utf-8?B?MkVhTHB2S3cvTUZVTWVBYXJwYmhVbVFIOGZaWjRnSGFzYmkrRmlsV1d6THZN?=
 =?utf-8?B?eEhFeCtMMjFCNm1TbVFvK2FvdURjVlZPZzJTMkpIR3VsVktvVmpyOWErZExw?=
 =?utf-8?B?L2RqcG52Ky9BVUNlQm96TmFRTTF3QitPUzhaVURTVEx3b211ZG9vaU10aTZH?=
 =?utf-8?B?a2YwNldVQmZ6VXVUL2tZQlpZRytxd3JLaWpzNnpRVzJyTDgxakFiQkZkNWRS?=
 =?utf-8?B?R0JjQTRMZjRmb3dxaHpTa3ZlcTJtOWFHTzFYUEI2c0c0MlAyc2xJNi9UaXNY?=
 =?utf-8?B?NEYrQ25VUzU1eDhkZ1JaQXZ4cHdNVXRid3cxTndPU2ZQb3d2RnRHd1AyRTJQ?=
 =?utf-8?B?WjdXMmk0aDFjaThneTkxNFlHc0lPcjBQYzNvZDJFRmI2R0VVUHR2Q29XbUdN?=
 =?utf-8?B?NGwxTmNlRFdhajk0ZWswTE1vZktkUzY2WTlHZFVVejZiZnA1cTdWc2g3T3lF?=
 =?utf-8?B?ZUtWakluY20vSlFERUNLZG5jakk4azBySmk2QVpkY0ozUXN4R0ZIdWlTV3lm?=
 =?utf-8?B?T05WdGlXM1p2UFhsWnllQm53QzZ0RFhFNGdramh6Y2xIbjBwaDNGWFJBb2Ev?=
 =?utf-8?B?WmpNVkZnbnByOThHUE4rTGZLK0R5eFQwVzc3ZHZaRnkzRjRXRGFHRTBwSWwr?=
 =?utf-8?B?WHZnakhrQ0JRMGdYcHQ3ei9BeklOMEg5aUtScFVMVi9QWWJVYk9lMmFVVDRp?=
 =?utf-8?B?bmh2dnM3RlNOeE13ejZJQThZMUoyUFdGK0VEUmJ3czBZckFGNEdyQS96Ym1o?=
 =?utf-8?B?SEltOVBqNVBaK2FtUy9EUTZaaEppNFFlWkhOd3Q4bDg5TWttRnhXOFJTckpj?=
 =?utf-8?B?eVFNcmxHL2VWM2pIMThWbG5oVzNwb2RKb0NHRjI1T0NjY2RuNXN5UU1sVkFB?=
 =?utf-8?B?Q0hUNTAvTkYyOXl3NFI5bEpMdTRacWRoTUpvbU5SNExnVlhEZGlwT3c1UWNk?=
 =?utf-8?B?enBqQ1J2WUNOYUx5b1dnYktBTFc1YW9OSUVzYU16dERLWmducFdFRnBDQmlV?=
 =?utf-8?B?WjdVcjZoSEhlYUJkNEtra2xNZ0FOU293OUZOWjFFMXRwWDhINGNLb1dBQi90?=
 =?utf-8?B?L2R0ZnBoY1R1TTA0ckhnZDVuSVZDNG80UEpMRWxwMEVURjUrWU5vR3JsYmFP?=
 =?utf-8?B?c0lRbVVlOEwzRi9Ha2F4aUJEUkVvOEswME0xNml5OUhMZWZPMHVkT2R0bTIw?=
 =?utf-8?B?OXRJOUpJRzM2aENMdmRLVktoNnJXZm1SNWdudnV4K3VuOHdjZFB1dGQvYmpD?=
 =?utf-8?B?cDZ6QnVDRzUwRkpJaUVsSWtNNi9PQzVTcER2SXJIU21MeHBFSmRwT29YdVZZ?=
 =?utf-8?B?NW15cWRJM2NFSkZXZ080YTR0eE54ZUxpTE9LWGxwbjJoZXRlRjJLbTBoTlo0?=
 =?utf-8?B?Rm9JekV3ZFFMUEN3ZU9Ubk4yS0lYcUFBbUZ1Qzl4eVdDTHBnRDVWSUIzbnBX?=
 =?utf-8?B?UnBoWTlhWW03Y3g1VUJabjNsL1d1NTdTT3FxbVNIcGFwK2ZnVnprenkySGZj?=
 =?utf-8?B?MXF3V3lWZkljSUY1NitSTTRzNXRvL3paRzd4VXQzK0xhUVU4TE1jSmtVcWl3?=
 =?utf-8?B?S0w4Y3RJWnNwQjB2ODdCaDQ4b0djVWdLSHlKMnQrd0draC9COG5hcnBPWGxs?=
 =?utf-8?Q?SZsClURS9cVYCyjzLqdTOuU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWU5bWh4U0ZYYnFoWUs3YjJSZi9ycHU4WTh1MnNhbGJJZGcxSVJydUw1M2ZQ?=
 =?utf-8?B?WU90WjFHUlAydldmTE9kdWdqNlhBcWJISTFMQ0FFZEhLSU5BdWgyVEpEY1Nn?=
 =?utf-8?B?OE9yLzNGVVB6KzFTc3BqMHBmRThhTi9NajZxSkVEOXJwVjFzLytrSHRDSzJ1?=
 =?utf-8?B?SUVsVTVTMmxFd29jcDVrMVlJMENNMTFtMDVwWXYvWmczMnZFaW9CZzZVcEdy?=
 =?utf-8?B?UWdYa2xEYW4rK2FLbml2dkozdHNWSkVQWEVBZU1kVHl3djVWQ0FCbWx3eTE2?=
 =?utf-8?B?SE05a3BFT1FYOExmYzl3UXBCQktKWkJjQmVLQ003RkpZaHg5WkVXc1BmK1o2?=
 =?utf-8?B?S2E4a3RGSWRLVFdQRXBBeDNaRG90eWMvVmRXcDA3RVFwMG5iUDhPT09LN1hn?=
 =?utf-8?B?QWhVdkhjM1pDYVEzeDFSQ3J0Y1ZpazI0enp3clJXUEh4MjlPQjNzWTRDZlFS?=
 =?utf-8?B?T0VUUnBjYVJJSGl6ZVBRZXZzalZnN1lBVFpkUzJzYjl2czM4aS9sUEp5d3BL?=
 =?utf-8?B?aDNoaUhnR0tqcWx1WnBrRUZHVnVzTDYrUlovajhPZ1Bsb2x0TXUzN0NQOGY0?=
 =?utf-8?B?VHJyRUlQQWJQMUNKem5kbGlWanZhSFFwUmRZQkI5UU9WSTExK1B1SEE5QUxY?=
 =?utf-8?B?aUVqVDJYZWd6bU9rSm9ZeVF6UXoxTlZzb3RmZGlXM2NvbmhQazBmUkVET1VI?=
 =?utf-8?B?d2dZU2l5UUZROEgxeVVGdGdOWEw5VmNqQ0hkZHkrT2hYTDMzNTZNWDluVWIr?=
 =?utf-8?B?aENPQmFsOGdPc2lpZEF6SXFtMk0yK1QxV1lzcElkNFYyNTRtM2pYTlFkT09G?=
 =?utf-8?B?MWE2UU9NdnhmRHQ0SkVvV0lxMmJmYXVaYURPWHJmVmUrUjM1YnJodHFaZmUw?=
 =?utf-8?B?R3NZQkdCb0cwNFRNVUtCRkFkb2E3WnlwMFlGRzZjOVRSMWwxVnFIWUdMTWFq?=
 =?utf-8?B?L3hpUGdYM29RbThubGdsZzN0WEFNQ2dKSFNIR25vY3lPYnhiMmdxcXhtSjR6?=
 =?utf-8?B?SzVjaTZvdVdiQ0NpNzNyazVJSEVOU0RTUloyOEFzRUNsRGZjVDVKZWVHcEF1?=
 =?utf-8?B?WTI0YVM2KzFxWnpnSnFXTWZEdHVvNkp0RldMclFNNERUMXpDT2ZzemQ1RmRL?=
 =?utf-8?B?eng1OTRnYTQyWUZtM2txemVVSmdtQUVHckk2ZU8vbXQrL29MOFFWN1hiMzZw?=
 =?utf-8?B?aXhoYVRoR2VvVlB2RUJ3RFFvclp2UkZlOXF1My9XUldrZDFwcGxZL1dmSlBM?=
 =?utf-8?B?VFUvQUdZa1N5NWFnOXdRZFowNHpSeTMyR1pPZk81NWZVMzNIZFFWbjhNYVhD?=
 =?utf-8?B?RHdXcjBPSkZ3V1Q0UUFhdnNYK3RTUDFxUnJFbmdmV3hKcnFNcjl6aFlOWkMz?=
 =?utf-8?B?ajJ5b1BhbGN5Ti9lR2Q0aHlISlVFYm9RdE5ISmwyRnE1VjUxWnBqVk1sRjdw?=
 =?utf-8?B?cjF5NTRuWWRWanYxM2lhR3ZqUmhEQUFoR1pJdGgxb0dPYjdqR3BMUElWUXpz?=
 =?utf-8?B?eDZIRnlpRXVOSTNhT1FFdks1M1lNTEx6ZnY3SURYam9obys1eExBeEJNVTd5?=
 =?utf-8?B?cEg2WFMwa3NwOG5DWEhJdzlrR3VpVUx5d1B3dUtZOVdTY1dYNXVScTdyYy9z?=
 =?utf-8?B?OEtaaCtFeWxkVk1GaW8vNWJlUVRQWEtBVWJGNjhSWDRhSWNxcTNWZ2EzeWpj?=
 =?utf-8?B?aEcwMnplcXgwZ05DaGdpcU5qeVQ2eFFNTXVxM1dzTUMzNm5GR1NwRUx3Sjlm?=
 =?utf-8?B?a0ptZWx3Zm9RbkdnWWMyczBCMmRJcWlSR0NLc1hURE02d3IzbzFjT2lIN2kv?=
 =?utf-8?B?R0NueVdOaDk5Ui80Tnc0OUtjdkVaQzA3TlFPSnMzeWx2TUxpRFdzNVN4aEt5?=
 =?utf-8?B?NFVSdHJ1YmxrdXVWZnNadmU4aWN6UkNINnZ4RVd3aHMvZVJucEZsZ3U2NjZB?=
 =?utf-8?B?YzFaM0FlbDZtMFN6UisydE5xWkIzbGI1Sjd6dDB5dmR2YUZWY2V2ekl4R0pk?=
 =?utf-8?B?djAyRlhjU09MTGNpaTJ3L0dja1A2R08vUGh3MG9oVUVzTXpuR3Q3bHZKd2Ns?=
 =?utf-8?B?dkdZdnBNUzZmazZyQU9jaVRxeVZTY1RmZ1EwOE9xZk0xYlRibTA4OGxsd1Rt?=
 =?utf-8?B?ODVGcENzT29xRXZwVGdQdXVvdW9XckQrNDZkNm84clR3MUZnQUpCZ1gyZWNE?=
 =?utf-8?B?c0NjZ1BzMU9laExPNFdjc2paYVhKb0lQZzJndEJnL3cvWWlISVh1M2toTlNz?=
 =?utf-8?B?OGR0Y25JUVJ5UXdpYi9mL2ZJWlc1ZnpxUTZTb0twbUpLRlNoYmdzSGc3ZURu?=
 =?utf-8?B?ZDJQb0kxK0gwb0lKaTg0RXJjMmZUcVFlQmpkUFJ3R1dKTzlWdVZEL1JsTEtt?=
 =?utf-8?Q?0EeNjpGcVN2abxns=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CC11EF58C117F4A9C199CD17F893AF8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0997127-096c-48d9-0c80-08de5f887b95
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2026 22:48:12.6177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pTSlthmlR5YFxD1n+ExH7Kcg7ONLEypmAX+KQ88pnZVkmJrZzQASz9S/FfTid/oUQXb/FgDip2U8Z9ZpWgNDYsi4IdxuDHYDgCXbj4uCPms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1B59FAA3B
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69638-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
X-Rspamd-Queue-Id: AB5EAB5842
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAxLTI5IGF0IDE0OjIzIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBObywgdGhlIGJ1ZyBpcyBpZiB0aGUgY21weGNoZzY0IGZhaWxzLsKgIE9uIGZhaWx1
cmUsIHRoZSBjdXJyZW50IG1pc21hdGNoaW5nIHZhbHVlDQo+IGlzIHN0b3JlZCBpbiB0aGUgIm9s
ZCIgcGFyYW0uwqAgS1ZNIHJlbGllcyBvbiB0aGUgaXRlci0+b2xkX3NwdGUgaG9sZGluZyB0aGUN
Cj4gY3VycmVudCB2YWx1ZSB3aGVuIHJlc3RhcnRpbmcgYW4gb3BlcmF0aW9uIHdpdGhvdXQgcmUt
cmVhZGluZyB0aGUgU1BURSBmcm9tIG1lbW9yeS4NCg0KQWgsIEkgc2VlLiBTb3JyeS4gSnVzdCB3
ZW50IGFuZCByZWZyZXNoZWQgdXAgb24gdGhlIGRpZmZlcmVuY2UgYmV0d2Vlbg0KY21weGNoZzY0
KCkgYW5kIHRyeV9jbXB4Y2hnNjQoKS4gSSBzZWUgbm93IHRoYXQgdGhlIGxvZyBpcyBhY2N1cmF0
ZSBzaW5jZSBpdA0KcmVmZXJzIHRvIHRoZSBiZWhhdmlvciBvZiB0aGUgaW5zdHJ1Y3Rpb24sIGJ1
dCBzcGVjaWZ5aW5nIHRyeV9jbXB4Y2hnNjQoKSBtaWdodA0KYmUgYSBsaXR0bGUgY2xlYXJlciBz
aW5jZSBjbXB4Y2hnKCkgZG9lc24ndCBhdXRvbWF0aWNhbGx5IHVwZGF0ZSB0aGUgJ29sZCcNCnBh
c3NlZCBpbi4gSW4gZWl0aGVyIGNhc2U6DQoNClJldmlld2VkLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8
cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo=

