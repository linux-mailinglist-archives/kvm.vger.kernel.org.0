Return-Path: <kvm+bounces-68815-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UA6YBHxUcWkKCQAAu9opvQ
	(envelope-from <kvm+bounces-68815-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:34:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A1EA15EDCB
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:34:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9B7285080F0
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F28441048;
	Wed, 21 Jan 2026 22:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ill/r52N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A763C41B359;
	Wed, 21 Jan 2026 22:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769034861; cv=fail; b=PDMmnq0tYdhfIqM5J8y+2GDcpxQnBk+AB61Jb93mY4k1jzOSiE4MaXsW2nsbcQJECDy/zBE72M2u+OevrRS6sPww7Eh/XhmTGLm4dfPyWv6dsf9Wwst6wIWQCet9YgXQShRz6HQs0MuoMVNGM2WEq06d5eb21lrL85Jt4g/KQiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769034861; c=relaxed/simple;
	bh=4yJmY0vwaaC7bjaqau2VvTlj5jaWVsXGAYRbzgaLai8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mmLnhiQE1L5Vrhsr3Fpy6TaBieicyEiaAyoKYwOZ7kLOFqX0KUgbepOJsW5JwKRe4DBQRgo1ISYQqohe8q1lsDA5KLu0y0XhNlyyppSqnYoRZ5kb/JEgOakEJT3dA6mmtxB9uXGUGpIROhtXPZ6wMirWIZDJU22nREGVHvKv75s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ill/r52N; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769034860; x=1800570860;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4yJmY0vwaaC7bjaqau2VvTlj5jaWVsXGAYRbzgaLai8=;
  b=ill/r52NlBhsqgkrjFK5HIeA/PEG0T9IBVTS4IheFMkjnVchxLE5Oizi
   1zlQaRMJM0PgNkg7ZvDMPhPTRAg87gNGYYoR7VqZD2rrZwYnrAV23QTNJ
   jS7gsZERbD5G7MBtt+FOVIEe6ZilAl+Wcw0didhbHeZNZPhRXvCmZygdV
   u9wATdkF0BQ6HcQPAB8odeG76q2eKdIcCNgNUku4Twn4HpudjFkcSe1uL
   O/3JPIDbmUgmJE0Gb8u09TEIlPvdFsXYZNO9+CT8v01RvJufjOQjv0dR4
   C1HS/Nmfy9jaqm3IKJKzFxmYXT1C/2gwDLCVXd1ewKFrpdgbGX5o2uiwv
   Q==;
X-CSE-ConnectionGUID: FQtN9qmnQH+ihT8GaCq15w==
X-CSE-MsgGUID: dzqtvcwGQh2YCBWVz/gEYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="73897406"
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="73897406"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 14:34:19 -0800
X-CSE-ConnectionGUID: 1q3dCsKwS9WfWNBR0GdWvw==
X-CSE-MsgGUID: nKakOFckR0mHjazdMDEJow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="211582595"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 14:34:19 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 14:34:18 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 21 Jan 2026 14:34:18 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.66) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 14:34:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BkBpAk2lk+g5r57uIIT+d35Bpt6/tuSGPgk+OenUphGwoZiYP9m9ZRvPLrVHDjpAiYfpQoMuFu0hy3o2O/+jg+heZBkJdpNa5NXwsuF4oJX5SYeMt2qBVhXdVENKHr7FDqbwQ1z+PUs2FxHXcWX94A+KzilPjX5vQkd86jBh7IVOze3gR6HWwkw5A3TLGewvcSa8uw0WchFbbHTbT1XzSluWgbueY+Xqq7QPd4qEjEnJGcjH3ms962wVsKwsse/9QJhtd6PRlKSOKVuf3nfBYD+0c4LOJRU4krq+58lwyZcLwV488aFHWnsoHTzEj5FhbyoGnDtKs7DX48YOBvmjpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yJmY0vwaaC7bjaqau2VvTlj5jaWVsXGAYRbzgaLai8=;
 b=Pmg1FYP38gII+ydhhYTR1RFZ1qxIvTUDe7zjLWKIDrGkWE+HYbXdX20mDWYeilCxqL5skmepwYT3MMmCD/8cSErsfQeRqe7ODuPsWg5bzAYqPh1EkAXCj7YYAQPmkV+qAJwm+H6d+HCaKr0Sh5jx8vFFfNJ+NzL5d3ASGnCkqWTu+x0ouSZZfpZUslXC3Nqy8ZVyNbByZVce5jK2SoLjSRv6Sfxuq6W0jBg3yhCu3SHtIs0zUy3yFFoEnTBZv0e5S4/hDmVllELXhuina9zEXVXmWqUp0GmbYL0+qUD4v6e/YWWu3cVegEJ7XPrO7YIm8YWg1Jf9WqN4k7FaQa2+TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CYYPR11MB8359.namprd11.prod.outlook.com (2603:10b6:930:ca::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 22:34:15 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9520.011; Wed, 21 Jan 2026
 22:34:15 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"Gao, Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 11/16] KVM: TDX: Add x86 ops for external spt cache
Thread-Topic: [PATCH v4 11/16] KVM: TDX: Add x86 ops for external spt cache
Thread-Index: AQHcWoEJBgBbBG6UnECVQd/2Mz81/LVV4oKAgAX1VACAAbkbgIAABjAA
Date: Wed, 21 Jan 2026 22:34:14 +0000
Message-ID: <69bc12acb3eaf740bff12e8bd0334cd327876a20.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-12-rick.p.edgecombe@intel.com>
	 <aWrdpZCCDDAffZRM@google.com>
	 <24665176b1e6b169441c9f6db9b5d02d073377a4.camel@intel.com>
	 <aXFPNbCvKURxby1q@google.com>
In-Reply-To: <aXFPNbCvKURxby1q@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CYYPR11MB8359:EE_
x-ms-office365-filtering-correlation-id: 3edba560-40c5-4979-513d-08de593d3500
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Ykxid1A5Z2tKZmY2NXJQSVZ4ZTh6aTdWMjlpMmRtMC8xUzJJQnZ0d3N3dnBm?=
 =?utf-8?B?cWZCcXAzVmFYalI2Wk5wVlBjVExPMW9ub1hlSloxRzJaVWFrOGJSZlF1bDBS?=
 =?utf-8?B?NnA0YXpxTU9BRFlnOU9XVndScW1qcEwwcFJyZlFqcDMvMGJNTElTZUY5TFBE?=
 =?utf-8?B?YlBwYit2aHY1OHBPdkk5Y3l6bmR0cTRTbzVaVW9qRS9zWEl0dFh0cDQ0ZHph?=
 =?utf-8?B?cVVMT2JXQzdXdStsUGJLOFV4elJ1UkRTd3NIblNKL3h6UllqMTJWUENXU2Fl?=
 =?utf-8?B?S2xsTWl1TkpqbVVRZlJPdVJmMFY3d29saEJnMDRvVzNSdk53NE5WYUNENndS?=
 =?utf-8?B?Sk9mc1dxbTJlQ1FUTWZNM0dVZjIyUnlzcGJLVEVZUGpiRG8vTk9iR0VLMGIz?=
 =?utf-8?B?ZzJLUUt5YXpmSTlFdGFaYldFeGhmWWRuVS93dllGVE90SEVKTklna0QzQld5?=
 =?utf-8?B?dHNTakJqWUVBNVZLQmRrTXA0NDd3bG0zazgyL0dWSU8vSmphaVNJSTJpM1pi?=
 =?utf-8?B?MURQN2xpQTB3SVJ2TFVOTmlJNTVrK1cxVmVQV3dGcUFaOHBORGdzam9IQ3BJ?=
 =?utf-8?B?QVJ3bE1zU0U4WWthcTRrWnhNMGRtVEREenA3NitFN3FvR2NVZ1dodk1yUjFl?=
 =?utf-8?B?NnVSWmlCaDhvSURpS3NDNjVFdnFDblE0SjRxRlZXMFQxelRIVU9mcnBJc0N1?=
 =?utf-8?B?dVV2RDdORDBjTmJBaTBSNVZYWkk4M0tUaE5JZWtPT0NLR2QwWFZ2RkpiYi96?=
 =?utf-8?B?WVhMK1VEcUdZV1FsTGRKOWFmWXJnRDlPbVIvREVjN1FBUmVQQldoU1JSNjA3?=
 =?utf-8?B?SkFyZTJwY2FjeWZpRlEwMUYzS1Z3SVczYUJiUHFwcWZKaElVVjBsNXhyYW9Y?=
 =?utf-8?B?RGw5ejJtWDc5UkZzTHBzWXY2OCtsYXZoQ3ZWOFRmOG1WSmhZS0xWK283MnZj?=
 =?utf-8?B?TVNPdnYyQXAwT3g0VzRmK1kzLy9Oa0VvWGNKVW5salBiKzUwYnJHR0t4RnRS?=
 =?utf-8?B?ak1icUQyVDd0UEFmaENaNWtObW54TnpCTVFDWGpNcmExandWa0EzMHFnSWUz?=
 =?utf-8?B?c1ZFRVMrRzBTdDVtUVV2bnZDRHNZcVpFUlBkVXd4VGF0SGcveVJTOEI1aU9G?=
 =?utf-8?B?ZkMxUmNUV3p1SDZBcDZvdGk2cWsrdnhoc1VtWkE4UkxtbkRLb0Q3NStYdlNF?=
 =?utf-8?B?NnJzeHR1N283dkxOWDZuQ1FZK24yYWJDY3VQRHlxb2FRMkNZV3l1cjZCUU5B?=
 =?utf-8?B?QU4zdVd3OEFZYmk4bnNaY0ZOeHJVNGhqWDhGVUZHcW56YUZoMEsxa243N1Ax?=
 =?utf-8?B?b0JxNU9qa0w0SFdkWmRyQkw5cTQrb29XRU5VTExYL0lWbmk1OVdsU0ZjM0w3?=
 =?utf-8?B?cmxFL2JDQk1iNEZjdWdIajJod1hKMnBvdkQ1VktqcHZ3aTRTbEFPT2R4NGt3?=
 =?utf-8?B?cHdrOE1mZHdnL2k0M3Z1RDcrVGFDZU1CcCsvT3NVclpvRUZ4c1dJTzVpOTU5?=
 =?utf-8?B?QnJib1gyVFc4T1Y2d2xkb3JBR2lOdy83eTZjSG83eXUvemhHZm1xcFZmNTho?=
 =?utf-8?B?NURkRHRaUmFHMVU5QkV1Z1pVZlFQUy9MbUdKVzdnM3hWTDNHTEdhWGdkNC80?=
 =?utf-8?B?ZHRwbDZsSTZJWTJYbC8rY3dkRlVxYjlTKzUwenhzayttQkJkYkVwV2ZYUGFw?=
 =?utf-8?B?OWVSZlBnUlpVcTlQWWN1NWJiOGVabDkzbkJYZHZXS3c0VnZ5Z1kvRE5wVXdp?=
 =?utf-8?B?amlkRHpDSFdoemJqV2pxZFhac2ZXZTBYNDJ3UEtPUVFFKzU0ZU1vUUdnaCs0?=
 =?utf-8?B?R3F6UmdoeWpEYUE3czFFWlA3eGYrdlc2aVRZYzdwWUdUKy9jRUFnNEU4YXo0?=
 =?utf-8?B?U0tHNEswUzZlcXdOZEVUNjk2TFlnMk4ycXYwcnRlV09zOUR5NDhSZGQyV2ZV?=
 =?utf-8?B?MktZaTlFWGI5aXdTYkVkWnlTRXZZSFFVNXErRUdIdkdRbHF5RkZnenBmZzZY?=
 =?utf-8?B?OXdJYXdERmtTT1BvRHpEVi94T2ovb3B2U1RJREZtTFUyYXJqM3N3QUdIaDNx?=
 =?utf-8?B?OFcrZEpxd3kxcmNsNkxxSmRaNnJoQVZmc1gwZlArazM0a29QZDFwdERDUktP?=
 =?utf-8?B?Z0hzcWhOTk1hVUxqYURWd0RwcWRYTFFEODdZS1BvOUcrMTFIUXg1dE11UjZ5?=
 =?utf-8?Q?1o5+WmWnEzLVTUPUg1nXQc8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cDMxdVVUL3BOa0JURjFSVlJSNXEvNXJOTGsvaU9DQU5QV0txL1RTanMzcnFn?=
 =?utf-8?B?V1phb0dtb1ZsM0Q2TmxoS0RwTi80WFdXTGtrQ2NEa1hxS3JKRU5acE1WeC8r?=
 =?utf-8?B?R0pYRkpFSDZLZjg2VnhWNitaeXVQNitESTNib29wVXlhTUh3VllNY0hNem5i?=
 =?utf-8?B?TVQwQ2RPZzlGU2FQajVQVnI1MVZlSWNSTHRlL2piQmZMQjhtdWFyaDVER3F0?=
 =?utf-8?B?MlQwOFYyZ2p6ZkV2b1JNYmlMMVc0SDZldjJaRWU1YlAvQWkxQWdVaStDVlBT?=
 =?utf-8?B?Vk5QZ0FHMlovZHRJUlJJUDBZV2laRTNqZVlMWDVQT1hLVzFTOEpwalBIMyt1?=
 =?utf-8?B?V0tOckdpaml6S1M0QkVHZ0txaHplNWlIZERiNndMMGdVdGRmQVl4emIvWWQx?=
 =?utf-8?B?QU9sQ2xyS1c3bmVNRllpaWU0MU55S1Y2bnAyRWk3V0o5WlZDWG9yTXpjcEkw?=
 =?utf-8?B?V0hlUlhXWEt6dWhUZHE5UFd1akNsazU1alB4M0VwWGxWNVlVbG44WDFVYkZY?=
 =?utf-8?B?cERlSmUzcjd6RWk0YUtZeSt2ajRXMFNFZ1ZiV3NuUUFVQWt4b2FQQjNiOFB6?=
 =?utf-8?B?cWkwWkM1QzZjUENCNEtFbWpvNG5GN2o4VlEyVFBESmFQcGJGSU9vejV4RHRE?=
 =?utf-8?B?a29uUTBxMjlzVGorU3BaaWovaStYalBKK0ljRW1YZG84YmlUc3FZa1VhMG5D?=
 =?utf-8?B?azVsZ1o4L21UZWNqWDM4cFJjd0d5QVlTc05xS0VSTk5kS3NZaVlTTTUzdE5C?=
 =?utf-8?B?TG1Xc3JMdzF2SHg1TkpiZHhWYytNL1NjZEFKYVdWVTJUK2VSY3ZWWkpVUzZ5?=
 =?utf-8?B?dnhRMmwyaDRmYmNMUEVucDNIdFVrblhIamFPYktIOGNtOEREOGJZT09ieXR2?=
 =?utf-8?B?NGVGeG9PMjRQSXdqZDVjN1VQRGNpa0syeENoQmZta1RQOXY0dlF1S3UwanZK?=
 =?utf-8?B?djFnWGZERHE2WlBnYUVab0pCZGtGemxNaXVld2FFaVkxcWhQVWd2MGp2K2o4?=
 =?utf-8?B?c2Rwc3Z5QlcyRk1jbXYyNjlwQjVweXpEM1U3Sm9qWkRRTkV4U0xjUXZrZ0lB?=
 =?utf-8?B?OGR2WUxsN0t3WGNUbEdUbEw4dXlpendsOURhSFVqTGpIUlJkc25vKzk4Qnlz?=
 =?utf-8?B?MHJDeW9YRFRFMTVIYjhPcGpUell2SjhPT3A1cXJSbDVOUEF2MVNGL0NYVkFi?=
 =?utf-8?B?SEZkTi9SYmpMeGdIdW5tNUQ0MitVRU9JcDJkL0Q1WHdPRXRKVTBKalJhWGdY?=
 =?utf-8?B?eUJDcWFoM0NuOTl5VUtlU3lWSkMwdFhjQk9DUitXRzlOM1NkNzh6Wmc0VVps?=
 =?utf-8?B?NUdsN28vKzhIb1hmVnY2SDJRWEd1OXQvYkptblVzVlhZZ2pkWXRRTUxOejQ3?=
 =?utf-8?B?bURxSGdGWHNKTERlaGdKVmQwOVFlNy8rUmxlNFZXVjJXWXFOTFoyb3dmMXVK?=
 =?utf-8?B?dEJ6UG1Sa2JpYTkwSnBwWG1vZzlOY1R4YldycVIvZjM4WDFZUnFLWFQ2YnNR?=
 =?utf-8?B?UWppdS83YnBscEllRFc5Y0YydG9rK3E1WDkwVGEreEpCa292Tk1lZXA5QUxr?=
 =?utf-8?B?TnJVb1lxb3g5Sm16K29QR1FvaThLdC80bE9RWlNwN0NLNkl0VVB6MjlFRkZR?=
 =?utf-8?B?UGdjMUtvUmZVd0VOd2Q2dDlMNWR2aGx6eU9VcnlERWo0OTNoQnFqN0N1VWFQ?=
 =?utf-8?B?K0tKeHRKa2lzK0dTbzI1dE9ra2UxRVczMElFVit2cXFkdHFXMEtTZHh4UTlq?=
 =?utf-8?B?a0ZTSjFISis5QU8rSUJvZzdKcWVTYk1XWFhJUisxZkREa0ltWXNmSlEzZXBa?=
 =?utf-8?B?amhmVlUrQ0RVbDdvSWpjVEJUV1NTN0EzRzNFdWJma2t2d3JjeWtNTWovUElp?=
 =?utf-8?B?bElSZjdrV1dpekl1dHpvNVJ0a00rbnpvQnc3Q2p3dzFiSk40MlcvSlZKcCsz?=
 =?utf-8?B?ZE1SeC9IWGV1eVRHUFhoSFpaSDk3V0FyUENJb1JjQTBPVmlqQllUK0k3TFp3?=
 =?utf-8?B?bjQwTW44QkV2eXVWbDZTMGlmN2FhaktGa3RsOS9Ea2RNckx5R2RuR1RoenlO?=
 =?utf-8?B?aVpxNUVTaGZPUis5Y1lWcFBUQjNBdiszSEJJOFkvNERQZUpRRTZHNjJ2TVV4?=
 =?utf-8?B?ckFvaHY4c2laZnVhS2RKdE5xeWNqVmVqWU5zaUhwUkF5cWQxekxvUGRxL3A2?=
 =?utf-8?B?UFhKaWhNeVROWkNlMUlSK2VrT1VmelcxdnZQa3owbldUZ2htckgxcmZOcjM1?=
 =?utf-8?B?MzlQVXN2R0dmSXNkVWdGWDFsZlZVenF5bitWbWVQUFM3czRWbWNjeDZPZnZ4?=
 =?utf-8?B?OGlxSUR3MUdvZVVmNzI3RVk2MVVleXc2TCtJcDgvTllsNTNZbHA2aUVxVHBl?=
 =?utf-8?Q?iCBDKeBDklB4+3aM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3149EDFE13A5D40B7467455078B7C09@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3edba560-40c5-4979-513d-08de593d3500
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2026 22:34:14.9663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DAle84xevOP4vRmKT83avZiSAP/YzY3/JHaE+pdx1r0gxVsd2FiF3prjLFLpU1CGJdCQrrFg57bp9KRTStU0YsUsEQcunOu7rgOGaQ1OL7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8359
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68815-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[18];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a01:60a::1994:3:14:from];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	DKIM_TRACE(0.00)[intel.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[52.25.139.140:received,10.18.126.90:received,10.64.159.145:received,198.175.65.15:received];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: A1EA15EDCB
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAxLTIxIGF0IDE0OjEyIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBJTU8sIGl0J3MgbGFyZ2VseSBpcnJlbGV2YW50IGZvciB0aGlzIGRpc2N1c3Npb24u
wqAgQmx1bnRseSwgdGhlIGNvZGUgcHJvcG9zZWQNCj4gaGVyZSBpcyBzaW1wbHkgYmFkLg0KPiAN
Cg0KRldJVywgSSB3YXNuJ3QgZWNzdGF0aWMgYWJvdXQgaXQsIGJ1dCB3YXMgc3RhcnRpbmcgdG8g
ZG91YnQgd2UgY291bGQgZmluZCBhDQpiZXR0ZXIgc29sdXRpb24gYWZ0ZXIgYSBzdHJpbmcgb2Yg
ZmFpbGVkIFBPQ3MuIFdpbGwgdGFrZSB0aGlzIGZlZWRiYWNrIHVuZGVyDQpjb25zaWRlcmF0aW9u
IGZvciB0aGUgZnV0dXJlLg0KDQo+IMKgIFMtRVBUIGh1Z2VwYWdlIHN1cHBvcnQganVzdCBtYWtl
cyBpdCB3b3JzZS4NCj4gDQo+IFRoZSBjb3JlIGlzc3VlIGlzIHRoYXQgdGhlIG93bmVyc2hpcCBv
ZiB0aGUgcHJlLWFsbG9jYXRpb24gY2FjaGUgaXMgc3BsaXQgYWNyb3NzDQo+IEtWTSBhbmQgdGhl
IFREWCBzdWJzeXN0ZW0gKGFuZCB3aXRoaW4gS1ZNLCBiZXR3ZWVuIHRkeC5jIGFuZCB0aGUgTU1V
KSwgd2hpY2ggbWFrZXMNCj4gaXQgZXh0cmVtZWx5IGRpZmZpY3VsdCB0byB1bmRlcnN0YW5kIHdo
byBpcyByZXNwb25zaWJsZSBmb3Igd2hhdCwgd2hpY2ggaW4gdHVybg0KPiBsZWFkcyB0byBicml0
dGxlIGNvZGUsIGFuZCBzZXRzIHRoZSBodWdlcGFnZSBzZXJpZXMgdXAgdG8gZmFpbCwgZS5nLiBi
eSB1bm5lY2Vzc2FyaWx5DQo+IG1peGluZyBTLUVQVCBwYWdlIGFsbG9jYXRpb24gd2l0aCBQQU1U
IG1haW50ZW5hbmNlLnENCg0KLi4ub3IgcmVxdWlyZSBtb3JlIGV4dGVuc2l2ZSBjaGFuZ2VzIHdp
dGggcmVsZXZhbnQgaHVnZSBwYWdlIHJlbGF0ZWQNCmp1c3RpZmljYXRpb24sIHJpZ2h0PyBXZSBh
cmUgbm90IGRlZmluaW5nIHVBQkkgSSB0aGluay4NCg0KPiANCj4gVGhhdCBhc2lkZSwgSSBnZW5l
cmFsbHkgYWdyZWUgd2l0aCBEYXZlLsKgwqANCj4gDQoNCk9rLg0KDQo+IFRoZSBvbmx5IGNhdmVh
dCBJJ2xsIHRocm93IGluIGlzIHRoYXQNCj4gSSBkbyB0aGluayB3ZSBuZWVkIHRvIF9hdCBsZWFz
dF8gY29uc2lkZXIgaG93IHRoaW5ncyB3aWxsIGxpa2VseSBwbGF5IG91dCB3aGVuDQo+IGFsbCBp
cyBzYWlkIGFuZCBkb25lLCBvdGhlcndpc2Ugd2UnbGwgcHJvYmFibHkgcGFpbnQgb3Vyc2VsdmVz
IGludG8gYSBjb3JuZXIuDQoNCldlbGwgdGhpcyBpcyB0aGUgdHJpY2t5IHBhcnQgdGhlbi4NCg0K
PiBFLmcuIHdlIGRvbid0IG5lZWQgdG8ga25vdyBleGFjdGx5IGhvdyBTLUVQVCBodWdlcGFnZSBz
dXBwb3J0IHdpbGwgaW50ZXJhY3Qgd2l0aA0KPiBEUEFNVCwgYnV0IElNTyB3ZSBkbyBuZWVkIHRv
IGJlIGF3YXJlIHRoYXQgS1ZNIHdpbGwgbmVlZCB0byBkZW1vdGUgcGFnZXMgb3V0c2lkZQ0KPiBv
ZiB2Q1BVIGNvbnRleHQsIGFuZCB0aHVzIHdpbGwgbmVlZCB0byBwcmUtYWxsb2NhdGUgcGFnZXMg
Zm9yIFBBTVQgd2l0aG91dCBoYXZpbmcNCj4gYSBsb2FkZWQvcnVubmluZyB2Q1BVLsKgIFRoYXQg
a25vd2xlZGdlIGRvZXNuJ3QgcmVxdWlyZSBhY3RpdmUgc3VwcG9ydCBpbiB0aGUNCj4gRFBBTVQg
c2VyaWVzLCBidXQgaXQgbW9zdCBkZWZpbml0ZWx5IGluZmx1ZW5jZXMgZGVzaWduIGRlY2lzaW9u
cy4NCg0KSSBzZWUgd2hhdCB5b3UgYXJlIHNheWluZyBoZXJlIHRob3VnaC4gSXQgZGVwZW5kcyBv
biBob3cgeW91IGxvb2sgYXQgaXQgYSBiaXQuDQo=

