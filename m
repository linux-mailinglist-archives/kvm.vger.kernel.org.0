Return-Path: <kvm+bounces-52221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 433CAB0278E
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 01:18:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 843B7167861
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 23:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF2E722259A;
	Fri, 11 Jul 2025 23:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="feiTi8O8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1281B665;
	Fri, 11 Jul 2025 23:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752275881; cv=fail; b=FD3Hne/G0JnELU7WuEelvsXbfiQvQlZZqozCGkuP0nxEtqzxD2YwODglVCg/yxfYv3hpKWL2rGJf45eGKViOVwqIcN6Tv/C1pfBRVjfgo09uwOa+MHlnM07IQETw3eDWySZZJPMNlcOiluVkLa2vdnc5kKt9uZ8AIGvvcrOyhkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752275881; c=relaxed/simple;
	bh=5p1r7jOmcXiZlM9xkmm8IDgUjo30c7gEwZuaLF6Q2No=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=noXivbFhZEKbEZDzPh/SMBGqADwGyjOICJODjmQUaYsZQhexSkjpaWcswQR7FlzxvY5V2gfie9s5hSiXNayo+ZPEnPA5COzVHj+/A5ETyQ2p86GQp6MglNAEv+b4MpSkaJvErptAvTZMsrDQtO67797ZTMZ+Ca+ppd3xhsJ/LbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=feiTi8O8; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752275880; x=1783811880;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5p1r7jOmcXiZlM9xkmm8IDgUjo30c7gEwZuaLF6Q2No=;
  b=feiTi8O81qkObH55d5mn1cDIi7Hug24tIdHcD2e/8Xh9SuqXTRhh4EaV
   I2V1a+05c9+74yZZCh8V2DyFBtZtQvnEPCcHwc987tfjJeRjEZOFQqW5z
   FcDXJCCuzqIApu7KPOtHAk8Y26Iw89CuhWSi3MshGSdkPDy7FBPBoGRvC
   LYOFMTVplP1oIi70WvqQUIg27t5Ij5/EmVY4SGD366OZPEUrnAGHzb6uN
   DesII7wZog0xxEKIvXH6hoGTafQXPZas1I9bnYHUcpwvW5tCCSQxrvem3
   mw30BeKjBorKxIezTNDoYOgjYBtBmauakJzqwbmNcG0gNkX5+u0ldv3uF
   A==;
X-CSE-ConnectionGUID: mhZHaD0oSGG8cPRUZEIZMg==
X-CSE-MsgGUID: DqTjdy0DRuiS4n9Iatt3xA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="53688536"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="53688536"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:17:59 -0700
X-CSE-ConnectionGUID: rnLvlcLxQ9WiCxN5OmoXbQ==
X-CSE-MsgGUID: qLKaxlOvTgC8pYllA53MrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155897095"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:17:58 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 16:17:58 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 11 Jul 2025 16:17:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.50)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 16:17:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=upHLk6u2QmGmpb2lQm+QqHOsja2Fn0PTkaqP9I6680rxxglR4u3+WtrXIKjDumvyevyV/QrSAniN5+dwvSNJW9Q1gvYrz4+ymisjPG41Rsurq4WsX94/XZEQ3z7nc7vB+eoFL8t3Ao1/MOD2ln4mTuRvNo+2OdbHSj4pBmIrBvkoNjKqF729V2im1h4svIcmXaS60Sv9oUhS53QkrxtQzOFqw8ltzYKHEjbNO+VUX6fa8Wfe4O0K4+f6bEY186kQ9G30NZi/zOhvxVIIxU8K2Vp9WXy4eXnvlGGYMYJKIYSdR1z7GdUXkBRQ6DroKLggRqfl1fD199yX17dZv7djVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5p1r7jOmcXiZlM9xkmm8IDgUjo30c7gEwZuaLF6Q2No=;
 b=in7Dd/vMVmiwm4uMecS2+bbg4babUui8FbI/NLuv//VKRiAOt215x60pJDbJYZ8/OF3b10sZ7rrSisJlHKkTJipov39DeO94ss/iYRS1zJlQpjzki336aZFrmJhghubiHQgro4P5aVKuIPKZrLK0vvUQ8fFA0x+o4+yUj9GAaelKiz45CgkzYX1CM6v6jROf6lHllZwI+Adodb9zfNF45iEIYlrgC9p8l6nYrTd4M2yaeB3Xq7lnGs6gdVUz4BvASDsR1L/oD2Z/PvIllL8txYNseCmssVHWf65+Yz3DPHS5UVjFB96wTTybbQvOfi6NRboC5MDbJMkfJDCMLTcCaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7557.namprd11.prod.outlook.com (2603:10b6:8:14d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Fri, 11 Jul
 2025 23:17:21 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.028; Fri, 11 Jul 2025
 23:17:21 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
Thread-Topic: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
Thread-Index: AQHb2raNt52nCBW150es8dK7MAv5xrQUisKAgAEmNgCAFxzJAIAARa4AgAAJ4YCAAAr4gIAAkYsAgAABXACAAANKAA==
Date: Fri, 11 Jul 2025 23:17:20 +0000
Message-ID: <a29d4a7f319f95a45f775270c75ccf136645fad4.camel@intel.com>
References: <20250611095158.19398-1-adrian.hunter@intel.com>
	 <175088949072.720373.4112758062004721516.b4-ty@google.com>
	 <aF1uNonhK1rQ8ViZ@google.com>
	 <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
	 <aHEMBuVieGioMVaT@google.com>
	 <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
	 <aHEdg0jQp7xkOJp5@google.com>
	 <b5df4f84b473524fc3abc33f9c263372d0424372.camel@intel.com>
	 <aHGYvrdX4biqKYih@google.com>
In-Reply-To: <aHGYvrdX4biqKYih@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7557:EE_
x-ms-office365-filtering-correlation-id: 0916faa1-0ab7-4f42-2461-08ddc0d11666
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?clV1aG1KNXhWNDJtL002d2x4VEIwK3Q0bjFPaG85cHdBbzYzT1daTEsrMUVD?=
 =?utf-8?B?SitFaTlENW9xV0g2bDJZNWU0V3hUVmlzSGs3bzhnYitpdjNGUTZOME11Wnhm?=
 =?utf-8?B?TG1tbjMwU3kwWVZZZnRQVnhNMkRaQ1h2WUJWY3NwLzBNR2ZwQ3cxL2ZKYjRZ?=
 =?utf-8?B?L3MrSGM1WFBVK2gzZzRhdUs1cVRqODhkMzlWTE83MXpHeXZvSnJnckJkU3Er?=
 =?utf-8?B?ZUZIUkpFNWhmWVpRcWFDRnh2TDROZTBQVjV5K3I5R0krRThjZm9BQWU1Ulhi?=
 =?utf-8?B?TFIrUjJmaXFDRHpIa2tMcGVCQ1BSWUVaS1FDdWl3UDNFZzRiQzhjdmk1b20v?=
 =?utf-8?B?bzhZK1FtUjNnQ1Nmd3pwZmRQZmNSdGJRYU9vVjdxS2d1TlRkeWVJNEdVKzJw?=
 =?utf-8?B?aXo4alpjcGlaUGcwYWtKbXVocXJaczBCTzdtcFRaTDIvdUh6OTdJY3ZxUDl4?=
 =?utf-8?B?cnd3WXJ2bU0xNnl4UDZBaGEzZ0xQYmpGQmgyWjRNK0VFenFqeElQZkNUUVpL?=
 =?utf-8?B?NkVEbHI0ZXVaN0UwdjI0T3JQSHRVZ3JaSnRIT2toN2h1blpsaHBJUXJiU1hz?=
 =?utf-8?B?WGxaVllhUEVXd2l5WFB3SGZGekdFQUlSU2JOQWZJRU1Vdndnak1BdktYeHJV?=
 =?utf-8?B?SjdORzhiYjlwQW1ZbGs4cmROMzVqZXcxUi9CWDdRUmtKSUtwTnZqNnRueVhs?=
 =?utf-8?B?UkFaVVBIRzVnSVpRY0NaYlBUa2hnQ29IOVRxU2Y3L0xrcisxdzdLRUs3MVVk?=
 =?utf-8?B?RjNGMzFNa0dTTlVkMjlYN2QzbzJReUJWTHp0YkJRWHhCQWgzRlRWaFdtUTlv?=
 =?utf-8?B?bWVWVUNOTHVKRzl5Ym8zTnI0MkJ6WTMrNkxHbE96V3R4YVNkQlJFRVNiVHZ2?=
 =?utf-8?B?SDUrZDhwOGxVcUVYeVRxeWRHbDJlMDB5YWY3OEhHZWRCWnpYL2U1dWVLMnY4?=
 =?utf-8?B?UHBRWVpCNDJPUnd6L3g1c0RrSll3Zms4ZDV2ZGc4Z2JqbEV3d3R6VlB1c1N0?=
 =?utf-8?B?TWVvN3M5cUR6S01PMFYvaE04clZSUzBBcm9HdUZCY1hQNUtVb0dNbVlpdGIw?=
 =?utf-8?B?UmE4UHBiN1BNQUJLc1FvM0IyOHN2TlQxazlIdHhBNzV4YThiaU90aE94emNq?=
 =?utf-8?B?KzF2dGxwaDJ0L0FJMlYrSGxvSitqS2V5aVVpZWpJTStyUFl3VzUzanZMS2t5?=
 =?utf-8?B?Z0xRcG4vWmU4cFVPUWt5M0pETEdYWTFGQlNXNDE4WU11QnRQOHQ1bGRqemo0?=
 =?utf-8?B?NUpWeDVvOG5NdEhaejJOR3h4MVkwTUlPU0FHSjRjdGZSM2FjSkhseDd1U2J0?=
 =?utf-8?B?d0FGcFVQM212ZFZVMGJ5WVhyckErNmZHbTBtajZ5eUJrMUhMZVh6UnEyVi9r?=
 =?utf-8?B?NGxnQmZRUlk3MTNKT2ZObDRWVXo5bWdDRFZpZE81WGh2M1IrbDlTV2Zwdzdp?=
 =?utf-8?B?OGN1WHlhTEVHaW1qVjVkb0ZyeTZkOVNkVWxKYUU2RGtCWHlOeHJDMHJaU3pz?=
 =?utf-8?B?ZXVzSTJvVjJXRWJyNUVweXp0VUNLVTV0Mmw1NmNGWUJCOHN2M1pzMkI3YlJp?=
 =?utf-8?B?bTlZQUlRUU9ucUJJOVh2RW9QbmYyRklVcG1uTlZXMVNFZlRsSTZFZ2FIMDVs?=
 =?utf-8?B?Q3p2OU13RnQyMUhQelBvYnhQYW5Ld2pXeWpXdS8xV21MckwwKzZRNWxLYzhM?=
 =?utf-8?B?Z1IvcmpDSDRnQ2hDWDdWdldoRi8zQnBGcXg5U3ZVbFhvQVNUcXdadzFiSFZN?=
 =?utf-8?B?MUJJSENNOUpnMEpKK1BUMGxTNERnL0RoWittTThLcmJqUzRuMG9DSUpqaExF?=
 =?utf-8?B?NGN4N1AxOUNLQnNXT2ViTGlwL2hraG1qT2J1WlZCSHhsV0dTeW1rOGFuTGVF?=
 =?utf-8?B?V1BaODhCWUMyTEdrOXhPb0YzSVoveVQvb2l6czRtS0p5Yi9LWThMdEJyWTVR?=
 =?utf-8?B?aXdCWWpBZVdYUkkwVkZCeWpuVWxMWC9KRnFzZnlQaG9WV2ZEbU50Znd5VTMw?=
 =?utf-8?Q?QBzfroxDtEoMVWC00X9C215ZEKz+hM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y1paajRTamtoTG5CT3FtNlpUSkd2L2x0eTdQcWp0ckJCNVlGM0twYzZtTDhR?=
 =?utf-8?B?SXZqR1VVNDFOaTN6VnlySFczRlhvdWNNWEVnU1NPbWRZbEdQSUpEa05IM05W?=
 =?utf-8?B?ay9rM1Z6ZDNlZUk1dmthWDQ5V2prZ2tQUzhERnFTdlZuSDFhNFdUNm5GRnIy?=
 =?utf-8?B?YWhWVWRwWStkVFVMMVh0NG9ESVh3aC85bXEvQWpCWjFGbER2VFJjVkJ5bVQ0?=
 =?utf-8?B?NjNiZzBPQXRrdjFPSDF6ZHd6dDBsKys4M2JDZzNrcnVGRWVidWxRNFZ0UFdp?=
 =?utf-8?B?L09RYmNLRTZqZ2t5ODEvWDlLdlhUNVZyT2M5UExCZ3V1ZzBxOGR3RjZrU29P?=
 =?utf-8?B?bmhFWEp3ZG1uWVVoNWpPRHdLUUovTmNiTHdQZjQ5YVM0ZWgydFNIL3djUlA1?=
 =?utf-8?B?dkxuU2VEZGNUYVRiQ0pISXJ4Y1Q5cXFXNGYzL0trZU1OSFdHYUtOWkxISDA2?=
 =?utf-8?B?dWNMc2ZweSswZ1dTbE5hdVdVYVJkSzdzV0xpQUxoY0ZVZ2RDNTRYQ0UrTERn?=
 =?utf-8?B?R1FQemRvMHJ4U0ppM2dxYmwzUmxmL2wwMk8zaHBUamFZd1NLa0FyR3lVS2M3?=
 =?utf-8?B?c01EeXhXTEZlZExvMTdCZ2xUSHhTODBZYWJyQ1d6NGdDbGVLYk5INzlPalJ0?=
 =?utf-8?B?N3hGYSt4cnlPUFlDZ0ZteXRmcW5RMDNoMUc1QVhvcmZ0R3hoUmhVTUs3elM5?=
 =?utf-8?B?c21ydGdVSkNTc1Iyam8yUkJNSGdGRDlzOUNlNDV5eXlWclhIemZDMFhXR0JE?=
 =?utf-8?B?WFYzTUVpSHFvN3JPeXRpd2FtUUFiN3lJM3dlQm51ZmlMc3cyWEw3d050TGds?=
 =?utf-8?B?Yi9qeXdsdjRiTzJienR2YmlUR3pLYXFBY29OMk4zQlUrYUxaZmp2eGV4WU5w?=
 =?utf-8?B?MmZYR1VQeUhOTWxUdUQwdHRidERJeUtMK1ZVWUZaUldIUjlONVhjTEZFbGdp?=
 =?utf-8?B?Y21CNnFscG95RDJIZmQxUDJNSUZ3SXhaRUhvSGxDelZKRzNjaURnQktNS1F5?=
 =?utf-8?B?YkJBK2ZyR3VMNnF1c2FtTXJwUm5ZQlhYcWhmMC9GV1pENlBoSjgvdEVtKzdK?=
 =?utf-8?B?VDdtQVhoVTZtMWZYcXEyYmtyRTR0bTZvWHFiMVdXUk5VUnVXSVJ6Ny9uZGpa?=
 =?utf-8?B?NWU5TmV6c3lsMjhJVzQ5TWJhV1Z0WEtEa1lUK3ZJVWNKSkQvdnVNVzlsQkNP?=
 =?utf-8?B?NkFJaFdadHNkdUg0bmNybkl3MkFOUnR4VkVLdnhVK0hzTTQxeVpnb0pFQklP?=
 =?utf-8?B?eVNSM1ZCR2h1Rk5tK0RGZllYVnhwVW9aeW1JNW1RM0JndEdJRTRyczlEUGN5?=
 =?utf-8?B?NFBiTVNmMXplS0QzV1g5aFVBTWdadmtEMU01WFM1Mk5ReEdnWnViV3RRRHRT?=
 =?utf-8?B?TVpwS2k5dkVTdjNuMW9aeWNFK0c1NW5VR29ISUduQUdNMEk3dmdKMStiM2Zo?=
 =?utf-8?B?TDczenh5Z0lCU3ZzMUdtQmFtdHB6R09WeDk3YlVUeVgwOVhOaE03SDhuQ2ZD?=
 =?utf-8?B?UjZoRmpMRGxFSmk2Szk0VlZlV1B3cVZhc1ZwQjJ2c0paZjNycmJnSWFNQmJv?=
 =?utf-8?B?bHVFMUE4UlJEYUZ3cnVXb1MrVFhMcDRYSmM1SXpzWnBtVjc2UkVrRHVKc2tt?=
 =?utf-8?B?UitueExrUUpQT0lJYXBBeHF6QXFVLzdtV215SkFWY2tEMnFjbFpwcDlsRW91?=
 =?utf-8?B?Yjd2cWhZY3U3bTFsbGt5Qyt6b29FcFRrajFrRU9lWjdDdGxaR3I4UC90My95?=
 =?utf-8?B?a2VVRmY1RXY5bXVvUkI1NWlIZUJoOElvZVNkWi9obzVobjJ5dGw0d3J2VVcz?=
 =?utf-8?B?L1BraUZUR0JvbHE3bTNTVDhmMXZvMDd5TWdCUVFuWi9BZmZpdy9DTjZoYW1n?=
 =?utf-8?B?NWRxSTZYZW52L1k2ZXpXdmhyT24rcVF2Yjl3RFFqOWgwdDYwekZHaTVYcDQw?=
 =?utf-8?B?ajJaZGswWnMvaFMwbERWWnROR2llWmppVTI4TnFYcnI2YTVEMVBzeHhYTzUy?=
 =?utf-8?B?SXNXWFVjdlczNnRkNlFGVEJaL2s3d3VYVGdmTU1OWmRCTXN2bytNTzZmMHJ6?=
 =?utf-8?B?UDEwUndmbkVLMERWQnlVZzFraTNydjNrRnltdFlndk9VT1hVYTNVZTROL09m?=
 =?utf-8?B?VDJ6MjZoT1hHM29leVNVRkl4ZEpJZVNjajVHRmpjb1A5b3JkbWhNMWZETVhz?=
 =?utf-8?B?dnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D590EAB92AAE244E92D1CCE10A24CB14@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0916faa1-0ab7-4f42-2461-08ddc0d11666
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2025 23:17:20.9399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4mwvnc37YjyfrOvRVhVfv4D2ZT4enrs0NMtchrxYcR7RBpp5YUe5fZ7BCg2YvXDlUbNhYbKDL8Od4BTnmUh7eySCBGRz3OpLVxBTuDq/Lsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7557
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA3LTExIGF0IDE2OjA1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IFplcm8gdGhlIHJlc2VydmVkIGFyZWEgaW4gc3RydWN0IGt2bV90ZHhfY2FwYWJp
bGl0aWVzIHNvIHRoYXQgZmllbGRzIGFkZGVkDQo+ID4gaW4NCj4gPiB0aGUgcmVzZXJ2ZWQgYXJl
YSB3b24ndCBkaXN0dXJiIGFueSB1c2Vyc3BhY2UgdGhhdCBwcmV2aW91c2x5IGhhZCBnYXJiYWdl
DQo+ID4gdGhlcmUuDQo+IA0KPiBJdCdzIG5vdCBvbmx5IGFib3V0IGRpc3R1cmJpbmcgdXNlcnNw
YWNlLCBpdCdzIGFsc28gYWJvdXQgYWN0dWFsbHkgYmVpbmcgYWJsZQ0KPiB0byByZXB1cnBvc2Ug
dGhlIHJlc2VydmVkIGZpZWxkcyBpbiB0aGUgZnV0dXJlIHdpdGhvdXQgbmVlZGluZyAqYW5vdGhl
ciogZmxhZw0KPiB0byB0ZWxsIHVzZXJzcGFjZSB0aGF0IGl0J3Mgb2sgdG8gcmVhZCB0aGUgcHJl
dmlvdXNseS1yZXNlcnZlZCBmaWVsZHMuwqAgSSBjYXJlDQo+IGFib3V0IHRoaXMgbXVjaCBtb3Jl
IHRoYW4gSSBjYXJlIGFib3V0IHVzZXJzcGFjZSB1c2luZyByZXNlcnZlZCBmaWVsZHMgYXMNCj4g
c2NyYXRjaCBzcGFjZS4NCg0KSWYsIGJlZm9yZSBjYWxsaW5nIEtWTV9URFhfQ0FQQUJJTElUSUVT
LCB1c2Vyc3BhY2UgemVyb3MgdGhlIG5ldyBmaWVsZCB0aGF0IGl0DQprbm93cyBhYm91dCwgYnV0
IGlzbid0IHN1cmUgaWYgdGhlIGtlcm5lbCBkb2VzLCBpdCdzIHRoZSBzYW1lIG5vPw0KDQpEaWQg
eW91IHNlZSB0aGF0IHRoZSB3YXkgS1ZNX1REWF9DQVBBQklMSVRJRVMgaXMgaW1wbGVtZW50ZWQg
dG9kYXkgaXMgYSBsaXR0bGUNCndlaXJkPyBJdCBhY3R1YWxseSBjb3BpZXMgdGhlIHdob2xlIHN0
cnVjdCBrdm1fdGR4X2NhcGFiaWxpdGllcyBmcm9tIHVzZXJzcGFjZQ0KYW5kIHRoZW4gc2V0cyBz
b21lIGZpZWxkcyAobm90IHJlc2VydmVkKSBhbmQgdGhlbiBjb3BpZXMgaXQgYmFjay4gU28gdXNl
cnNwYWNlDQpjYW4gemVybyBhbnkgZmllbGRzIGl0IHdhbnRzIHRvIGtub3cgYWJvdXQgYmVmb3Jl
IGNhbGxpbmcgS1ZNX1REWF9DQVBBQklMSVRJRVMuDQpUaGVuIGl0IGNvdWxkIGtub3cgdGhlIHNh
bWUgdGhpbmdzIGFzIGlmIHRoZSBrZXJuZWwgemVyb2VkIGl0Lg0KDQpJIHdhcyBhY3R1YWxseSB3
b25kZXJpbmcgaWYgd2Ugd2FudCB0byBjaGFuZ2UgdGhlIGtlcm5lbCB0byB6ZXJvIHJlc2VydmVk
LCBpZiBpdA0KbWlnaHQgbWFrZSBtb3JlIHNlbnNlIHRvIGp1c3QgY29weSBjYXBzLT5jcHVpZC5u
ZW50IGZpZWxkIGZyb20gdXNlcnNwYWNlLCBhbmQNCnRoZW4gcG9wdWxhdGUgdGhlIHdob2xlIHRo
aW5nIHN0YXJ0aW5nIGZyb20gYSB6ZXJvJ2QgYnVmZmVyIGluIHRoZSBrZXJuZWwuDQo=

