Return-Path: <kvm+bounces-53427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1757B114FF
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 02:09:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AEAD4E4F37
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 00:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA6D929A2;
	Fri, 25 Jul 2025 00:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XZvYNZeJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A888EC2;
	Fri, 25 Jul 2025 00:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753402175; cv=fail; b=kfYa3Xn9bJgbw2lu6via1fGbcHlP/QdBk+nF8O6LY8R+ceInXBEFvBq+6gnrxegWWivyVuy99UYhHcgT4dUkjRg1sOvWswQw0T4O6SgQv/KO1vba+Vf0ulLvivjnZpyiY/CiFePzPnrThcDtY+WhTy7QFvIVNIY2m1Bc05XJ1jI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753402175; c=relaxed/simple;
	bh=i0jDukLt4fl7I4AhACuAod4OQy4XoQWufQWshiSGgDQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lopHXom9ZtF2sjyioKcACSwXy0BmiMudXGNL3QFAD87Ye5spegSRnl9h+v4naNtr8SeZ0rfwlhO8QVZ6Hdc20+/jYps3yYRISwlxHmaPOMwJVX2I9FPb3mjIbcaaut0hFAHtto89Ub3jQu0FlwG3Sc0xEWzUu17hStfW19tQacU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XZvYNZeJ; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753402174; x=1784938174;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=i0jDukLt4fl7I4AhACuAod4OQy4XoQWufQWshiSGgDQ=;
  b=XZvYNZeJTAtBa6fu8YNbYDbZK0JpeOsaU+rLMTZeIVi8rf/QA/YZ2UhX
   ENNrV6VqfZr6fbAXu1HlXTeVgyNL+T507y8aK6oYqX4QHxBhu50oqYo1g
   18HgB9rnIkPLJ0vndddi4ucv+Lu22UIXLW5Od8VqmeS4tPqB2/6Y/uJyG
   OtE/TTda8SLrKGRjzJTVApZ5qwsrzkz4Yv1k+do+vcHw6436Nw5bMfLPz
   1V5CaQt4LTzYs7Srt1yF7/fIJAWKKwnDpqPlGiguJ4oFAwXsupmep50m5
   sIPUvi8m3+drJU78lprHwwFFcVxgbVNe3op4PkZAwUcujeYkxGMeUlC3r
   A==;
X-CSE-ConnectionGUID: TKSckJYORPSvE8M1OxtXwg==
X-CSE-MsgGUID: lcQixWkrTaeDJlmcSYIQeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="59389003"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="59389003"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 17:09:33 -0700
X-CSE-ConnectionGUID: xtctJK6IR0GBZWhnVHO+xw==
X-CSE-MsgGUID: T0zyz7DtQ0m8zQNn0orzSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="164579555"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 17:09:32 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 17:09:32 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 24 Jul 2025 17:09:31 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.45)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 17:09:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wsQTIZJXOUwb0Kq7eKl9MSGiu8Sbv2W4uQCei3SxhftDaGqBlnggu5Oua+3UtSntZI68IFzJ9lS7B/b5DF5fj4/+lz88X/LdgrTjwWPB+5BoGliZI7XJ1Ett/OxLc/1RTCiM6FOsaq86oKT0ekqLVq56rqsLc+j7DtdwqgTqpD8vuR/A+QgUEX0EEcZAw4AFqXtQAQ9pBOv7iY/K0t50E7i6HQwGMRE4kw58pXgNewFq23ziTnyxf7ssPqwLc2L+F0538EcT+2EUytNLxf2vSMXf/IKdGNRc9ZRLMkWiooAsEK2lDGOgYgZnYFPJix6sgJkC3MtMRK+FTDw2FATZSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0jDukLt4fl7I4AhACuAod4OQy4XoQWufQWshiSGgDQ=;
 b=KUZsgddns+9XIFw0CCcbzPjF5NmaQItoRDkzauXBHFpyPZ0EIHbpkcN/kxYxv62KR3BZGQQG6EZ+SPDKD9uuBXgT3ggqewuGC1cZaDUEJ3eq1KXzAo8eG1CboIuPnrP2en7hni9zjysJUdNLg0OXUiKHK8C2Su8+gQaxrFOrgap4aK1Y0+ayhedJeySjPOKgswjL9P2EUqEUQo/UZsRL5+3JESqZWCJQRY+qj/8S/MBcy2e1MWc8z4mjxLqvoz9dXKRcOUoY/PbNKJ22PVYZE0ZFnOW8rYBwgbeq6y4KgckPYXbVNXxGIbxOoh2WS4moWHTzn2Hh2OSILVuk7ZJWLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM4PR11MB6118.namprd11.prod.outlook.com (2603:10b6:8:b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 00:09:29 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Fri, 25 Jul 2025
 00:09:28 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Luck, Tony"
	<tony.luck@intel.com>, "kas@kernel.org" <kas@kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Gao,
 Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH V6 2/3] x86/tdx: Tidy reset_pamt functions
Thread-Topic: [PATCH V6 2/3] x86/tdx: Tidy reset_pamt functions
Thread-Index: AQHb/JuAibgOTGhBe0iOKuHtcYMgHbRB94uA
Date: Fri, 25 Jul 2025 00:09:28 +0000
Message-ID: <3c125380b1c52124e200583b3a413c44e1fd84c0.camel@intel.com>
References: <20250724130354.79392-1-adrian.hunter@intel.com>
	 <20250724130354.79392-3-adrian.hunter@intel.com>
In-Reply-To: <20250724130354.79392-3-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM4PR11MB6118:EE_
x-ms-office365-filtering-correlation-id: 86425906-01d8-4792-6632-08ddcb0f85ea
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?d05GU25XcWluMUw3QkVBYlZ1N1MrQm1WdlduUS83N1R3M0x1Y21XV3l1ZkFh?=
 =?utf-8?B?VWpIUFVyZ0I0aW5ocjhEVjBjaWpxRzFJSDY0eENJVmg3RHI2NHRJK1J4dTJR?=
 =?utf-8?B?N0lNM0FhV3RKcFhQbVJNV3ZVcmwxT0FzdEliT2pkRTJ3RzJQL2l6aXdsZGxF?=
 =?utf-8?B?ZXdIakdYa24xY2ZMQ3pMUStIQTlsTitsNG1zUGVOUnBmNEVYVFdTRm1RUCtx?=
 =?utf-8?B?VzFIRlhBSlhRQlQzd1dRNkFTZExjT0JnSExVRThaMjUrY0padkZVMzhuaGlu?=
 =?utf-8?B?dzhhTkV5dWkwd3ZaOXQzL28yRjZYYlhWaEtrc2pDOG0wTTJUbXYxY2MrbWR6?=
 =?utf-8?B?cnBYNTVQMlVOamo1UytBSEZKWW5XNytMMXB2dGRlYzA2NVRNOVR5NnRyOW5G?=
 =?utf-8?B?NTE0UFdrV0lBWXVJZjdvT2l1MGdkWkRkbldhdTNQazMrRE9UcHIraDRKUmFw?=
 =?utf-8?B?d0tMT3dnV1A4MHFRK0hkdUVaUERQZm9lR2hMNmxtL0FQTzRmS3FiTnVXblM2?=
 =?utf-8?B?SU1RTzhLTDdMclJIelFySU9acDBleG8zREJJTXdiQjlock84b0Fmd2dZZE92?=
 =?utf-8?B?RElVeHI0YWlMRzVrZHNYQVNvdnkxTGthN3hqLzlUQXhWcDRORTc3d1gzcHJM?=
 =?utf-8?B?aGp3V2VKL0MycVVDbVpVSlUvN2hOVERhR1ZyejRudjNBazRJZ3NuV21QZXB6?=
 =?utf-8?B?elFCUytiVWlFTHFlcnUyaDdRaDRZN0V3RXpKdjlYcGVmN2Q1UmpERFVVQU41?=
 =?utf-8?B?RmVqUGFOY3FRcDg2enNwQk4zVWJLc1FicWVxYlBOZHRBMERqNzBjekdOejlM?=
 =?utf-8?B?aDhQdGZTWVdDWDhvY3ZsbENUUUdoWUZjdmZBSmpoeDBLd1dGa3lNZzB4Zmcz?=
 =?utf-8?B?R04rVU5PN3hVMHd0d3BiMDd3OEFiZUVJdXE1UHFzQnp4L2QxYVlFS0VIR2tt?=
 =?utf-8?B?cW5Rald3U0xZT3NnMTRQenlmaXhTeXJtQ1hyeGJadk4reHhLTTgxVDBkbHdU?=
 =?utf-8?B?MUNjUWpvcFQrTFkwNll3M2lERm5LMjZVTW1oR0dSb0EyUGNKdHZFbWZnWDhO?=
 =?utf-8?B?VjQxZ1UxU0RXT2lxZ3hhaDBaSEtsL09ZZWRlZXM2cTlqVUE0eFBCcXV1NTRI?=
 =?utf-8?B?Z2lRZEZXYjBBM09NemV6YmRwR0JQaUNSTUlJM3l6MmFjaDlvZ2VDTjNKc1FC?=
 =?utf-8?B?byt4MW40L01abVdYenR4bzVxK1QzRkwxSGZTZzVSbUdkVWVSWHk0dGx2QVhy?=
 =?utf-8?B?ZmJNb2d1OFNRcXBUME92L0hxYVpwSmJyVmlWd2xsNTRLZzZBY1VzNDBCbEhV?=
 =?utf-8?B?NzlmOVFsR09lUityaEtJQWJDR1JWR2t1ZjAyZlhjN0tPZWNlUFVGaVNiWlg1?=
 =?utf-8?B?U004aEpWcVFXampIcXBhZkc5ZkdpNlJqNEh3Z3RWdWNGOGluYzlQRFdXamth?=
 =?utf-8?B?WEJuUWNHZXpvNkI1N1kzY2ZOTisrWVBxdmxDSVZEajR4enhpZVNtbEVndGFR?=
 =?utf-8?B?TVBoZ0l0b2ZndUl0YmtkenZCTU9SNlVjalNsMCthVENrZDFwd0xXbHpnRFQr?=
 =?utf-8?B?Y0hOSnZxVFJpV3QxKzdsRUNNVkp0TFBKK3ZtSS9UMkdXVDNXOGowVnc1ODVl?=
 =?utf-8?B?N1lyZkxNZG1MWkxyUHNPcjB4TmR5eTIxeGFTS2JVNXowSTl4SUg2aW5uc2dE?=
 =?utf-8?B?dkcvSnA1MXR5QS9xVGl6QUFTTzFqKzVHZSt4SzVCdVhHRUZUakVtTkdFdzVO?=
 =?utf-8?B?T2xMWGN4Ym02SjlnSTVyQVpPaTdKTjJpZkozRllxR3UrenVOdW1xUitGVzJW?=
 =?utf-8?B?enVqT2xsdEpudmdFU2VnRWxENnI0WW9PZ0I0NHU1OHNMb2crSURQUmZXbGxU?=
 =?utf-8?B?QXlEUUtNdXZHbGdOZk52cWdybmJWR3E4MGEybVQrSnp0d1o2UTN1WnJ1alI1?=
 =?utf-8?B?c3dkV3FiSnN6WTVtQmh1NG5Eb3pKN1R1R0NlTGhqdFByc1lEUUFBNEdmMFJ0?=
 =?utf-8?Q?kr3H8JnpEfNKLp+sXaQoDeWfbgtRCY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NTR2OVJSZVI5Zmt4b1NtYzVTZ3hlZ3Bld09xdnNIa2o5UVYyTFUzNm8wK05r?=
 =?utf-8?B?RjVicWUvUjIrdEo5NjZkZGludmtJNTd0bnQvNWJFbzdoVVdKZ2VjOEVBempU?=
 =?utf-8?B?c1ZiUkx6RnBneVdWODR3bDBwMVk0NEJyMzRaTDczVE1zeUxKZTBQTjZvSktX?=
 =?utf-8?B?NDB5eWxObFdqVWx3TUs2NGtLNG1mckdXYVJkT21TK2sxZzdwMUJXR2c1TnNu?=
 =?utf-8?B?aSsyc05XSmxoamhoblVmWHJ5WWszTXVJQzFNcWJDekk5bWdXdDlBUTViY1Zj?=
 =?utf-8?B?b2p5Rm1QL2F0RVFlR3NkNFVtbGgzcENDQU5uM3Z1MjlpSDFNMkZqMWt5R3Fn?=
 =?utf-8?B?OVBOTG5BSzM3SXlBMkgwbzFpY1cyZk1yL1NEN1NORmRrQTlxNGpkbHNkWlI3?=
 =?utf-8?B?QlA4bXZPNTY2dUZlbldCSHh5WVhiZitHb3B4SkRrbDdUd0xHVUVXVW01dWlq?=
 =?utf-8?B?dmI3MXJqczNnQk5uMHFxRXB5T2Z0eDFTR3U5RVpTT2RrdG5IR2QwcVFUUzBH?=
 =?utf-8?B?eTFHcXJBV3grdTBtKzNlQ0psdXNiNVFvL29BZ01hb2ozYzVpdzF6NzNYVlFh?=
 =?utf-8?B?YWxaNC85VVk1NnNhZVJ1ZGZPRTlhNGdkemlSNmNSRjNOVjIrbzhvRk4xRVVR?=
 =?utf-8?B?SDdZTHBqRWsxZGFVK09McmlpUm1VeDJiRHdwNEVxYStlOHNMTExtZFg4Z080?=
 =?utf-8?B?aCsreCs1N3dHMHNVdDkwZC9hNDQ0ZWpLMG1PQkxPcXY3dktZQzA2UEMrRmlq?=
 =?utf-8?B?S004Nm93T1VQYVBmVnNhTHZKK2JyWTR1RFdwbWx0N3hkOVZzdmJtRlVXOXhl?=
 =?utf-8?B?bkgrMXNPdkFDalhCbVN2N2JrbWppWTBhaFJJNzE0ZUc5VkZGL1BiaFdZNVVZ?=
 =?utf-8?B?dHlsU28wRmx1anJnVkdyWTJ1QzBaWkhtb25tSk0rd1BFc0NTcFJDS1hTK2Z3?=
 =?utf-8?B?NUJQQzhzeWVxWHg1SWpGUGVIQW5aS2tsK2Vna2JIckl4bUdacTJpL3FjbGdZ?=
 =?utf-8?B?ZkE0dkJkSC9UeDNkMVVOMUNBZ1ZHanZnL2JkdDB6STlJR29Hbnc0eURtK2Jm?=
 =?utf-8?B?RkNFZEc0Qjl4SUk4NXZieTdSL2ZUelVDSXgvWEQ1SjBVYkVEYWg1enpmMlI3?=
 =?utf-8?B?M3NmQUw0TDFTSTlpVXhHMDdvcERkcUtYemZ6MG5iaFdyZkJ2OEprRHAyNHVw?=
 =?utf-8?B?NEJ6amVhWlRyOEwyMXVyL0dpV2Z2TEZ0WkViZkZIaWZkcFRwUHVTd0tQZ0tF?=
 =?utf-8?B?YklpSFliOUZodHRxUDNJcStPYm9makJwcmszSFJoUmJUNmF5SW9TWnJ2bEEy?=
 =?utf-8?B?cHI3cXVPV2tpTEZuOUZEYWhVTk52Y3lTa2t3ZlgwTVFKclhEeW52RzU3b083?=
 =?utf-8?B?WFBLaE9HMUtrNktqaFNpQjdXbWRLZnZ0OFEzSlJhUHhYR3JDQnNxNXR3RkQz?=
 =?utf-8?B?MTh2bU5CU0xFbm5vdkRrRXc2QTJKZFJobXphM3dQWld0Ti92a0FDMW9KVitW?=
 =?utf-8?B?cmZRWFFqSEk1QllQNDYrZlFXQzBWSnV2WDM3REordXhVUGNpZ2NUSWw3WVAx?=
 =?utf-8?B?SlN3UmwzSnBOeStOTjlFUmVIV0VPclFKL3VnR2VhejFObFNiK0dGVUhveVdy?=
 =?utf-8?B?bEhjWVJhS3JhMzZLQ0Nkd0NVVjBlNmZQQjQxTnROdnlSMkxSTmVyTy9wZHJj?=
 =?utf-8?B?VEZLaWFOQzRPWXVPcEFDRlhwVHNST3RJMFZSNVZQbENOWUJGczJpdXRXNWUw?=
 =?utf-8?B?VEhOYTNkN2dOdC8yaDFzbUliaGhiSk5IWEJHM2lOekk0V2dTMDVERXpFNlpV?=
 =?utf-8?B?cFNUM1VnWWN6RzhZcC93Z0t0R0E5cmVxM1pZNlZudnJMYVFUMG5ybEpKT3ZF?=
 =?utf-8?B?bi9WRmZ5U21VS1EzNVBPOGZaenEvYjdZdXJHTHlSWitzRlBQN0JKcmRabTY5?=
 =?utf-8?B?U0ZqMVprVERlWW93NTBMOURwRFBsWDRVZVJuM1N6VUgwVlVsWUlRajBGVmxv?=
 =?utf-8?B?cXdRSzlwZnNCakhJUC9JQUJnTnJ4MkRNK3ZVU2dvRWxHNTNXcGZmcnRDYXhz?=
 =?utf-8?B?ZCtIRmVidFFhZFhhTXloNy9kbE00RXcvSGRUYm5BbjFtOTN4alF4K01wRFZF?=
 =?utf-8?Q?TL1KO4g5W60LLcBHPfj/nlkeS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC3758C51302C348A4093B689559AD5B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86425906-01d8-4792-6632-08ddcb0f85ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2025 00:09:28.7868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ICDnnRBl1FKXV9Yoh9dgwGWoninvXuYdzphKliJqnAJH0EgH7VKT/6wvdkoCj4UUien+frS/jRsLEHcupJnxsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6118
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA3LTI0IGF0IDE2OjAzICswMzAwLCBIdW50ZXIsIEFkcmlhbiB3cm90ZToN
Cj4gdGR4X3F1aXJrX3Jlc2V0X3BhZGRyKCkgd2FzIHJlbmFtZWQgdG8gcmVmbGVjdCB0aGF0LCBp
biBmYWN0LCB0aGUgY2xlYXJpbmcNCj4gaXMgbmVjZXNzYXJ5IG9ubHkgZm9yIGhhcmR3YXJlIHdp
dGggYSBjZXJ0YWluIHF1aXJrLiAgVGhhdCBpcyBkZWFsdCB3aXRoIGluDQo+IGEgc3Vic2VxdWVu
dCBwYXRjaC4NCj4gDQo+IFJlbmFtZSByZXNldF9wYW10IGZ1bmN0aW9ucyB0byBjb250YWluICJx
dWlyayIgdG8gcmVmbGVjdCB0aGUgbmV3DQo+IGZ1bmN0aW9uYWxpdHksIGFuZCByZW1vdmUgdGhl
IG5vdyBtaXNsZWFkaW5nIGNvbW1lbnQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBZHJpYW4gSHVu
dGVyIDxhZHJpYW4uaHVudGVyQGludGVsLmNvbT4NCj4gDQoNCkFja2VkLWJ5OiBLYWkgSHVhbmcg
PGthaS5odWFuZ0BpbnRlbC5jb20+DQo=

