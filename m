Return-Path: <kvm+bounces-58902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D4D7BA5015
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 21:53:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 751471C245D5
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 19:54:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A02283142;
	Fri, 26 Sep 2025 19:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kf8JOeBt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7A12222C2;
	Fri, 26 Sep 2025 19:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758916408; cv=fail; b=PzA4pHyL6vAzn5crnskEL/2LKzeSw2Vl3zPTbKsKP9lh2SEA7j8jW2r5XgGSLYnRoC7BdrqHnIXFyWNtf5Si7ZFgYbyDw8m4HL1E6JYUq4Iu1bwcf8HwBtytg/1uK/cPt0FxeneTGZr1ShHaFozwQ565GFOwfYvnqZyAKnhFM58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758916408; c=relaxed/simple;
	bh=s5h2SyVhK4r56YnKru+6XTYPok/fooLI5vgXUrP0F68=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uPQCItgf+iXpTRsuqgVrkd74uTdQmuLbV5MtxcAQr35KhDQqoqdhgB7nrof+goraOsqiuBS02WFi8p3BHyGG5F31UF0uJTiUaGeKZmKp0iWbO7w5GG1mY08ve2cL7imXSBvRP0ePTGw0+0FA25T8WwSQDlN5ZuIIoSJY6uO3Ubw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kf8JOeBt; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758916406; x=1790452406;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=s5h2SyVhK4r56YnKru+6XTYPok/fooLI5vgXUrP0F68=;
  b=kf8JOeBtQr9HT3NB4GR9PYTt+l7W2qIwwPQJQ5fwc2vZjKn2HMvCYiPQ
   nOYmUErTsFnPfo3KB00roFI7Va4yO3Ea+KvXTcoGUcaa+U4/9SHRmySSC
   RCsKlZfNnd9+WUOrm9zeVt45buLu2KpAHgmU1W8Se/XX0QUBtLOSnap0o
   9Ur61WpKxP3HTRJESRHyTBBzZ2J+I/LiZXobDNeVohwgGo1WbOFiTEamc
   7lTSLyLQD4+2zO9QZ3AW+BqWrj3W+3wPRRKG1tWDHcEtQNw5a+kVgBos5
   whS3yQl+4HZ6S3SOlXP+vExw9sGW7J4rWHJfHzuZnW4cv5c/MqedHz5A1
   Q==;
X-CSE-ConnectionGUID: TqjTxOmDROqqF++wprrORA==
X-CSE-MsgGUID: X1pPRnzcTMm026PEfU6JFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="61173396"
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="61173396"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 12:53:26 -0700
X-CSE-ConnectionGUID: Cl0dopOyT22LqMbwoiHbIg==
X-CSE-MsgGUID: 6aNq+hRLRLujpxGshw87dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="177750747"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 12:53:26 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 12:53:25 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 26 Sep 2025 12:53:25 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.58) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 12:53:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p8zVAmP3p2rZ/wdlgLtxMetwk9W1tPPuFThpAaILjAeEXfPhNeHU/3WU7DlbDdToSMUU3FC/nyGbvns6ekbnnIJPNvA7Jho6AsUa2WS1i7g2aogmFP4BJo01EXvloEGRRdu/YF6xr8JAnpLdQvEaTi3P7wqMKsjpDgOqoaZwP6AYb58YpfVD7ViV5mLkwOvaeugZAxkfWli81D2kdUhC4UcKUz/RopuJIZtvvlV9CDpC15HKOlAHHNFM5DIcZaJ7/9g3qdxl9yVVTE0hOFxPMO9H/2dpoDXRHsO1yx+tNTn8ZP+xVbR63c++p3kgD7s24eDpT/exL2yzcVKx6gTiAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s5h2SyVhK4r56YnKru+6XTYPok/fooLI5vgXUrP0F68=;
 b=cszEeoJMokgk+Cn1umA/tCiuc3nOASo6WeMkIwDYClrL7FzntkhzR/0FHxymK793ghNU1VJVIqa34k2TCoHCaVYFeftB8Q7rdF2iJYkdJ9g+D4LW+Mg5BnHHvx1CP/DVU3A8EK+AGy5wYsrLyB6vk22Vh+FM9IzHN6HvWgl7ehNN0lp33j+KE2oQLB3mUWfEa1dfliBh9jhKJuls/PrD1xMs8oRgSocxInfi+04wbAQBsJ6C/U5XY96V/DB6FJwN3KjwWjWjL06yCXDRgE6Y6zc0NhJME7aftm6J+ZwvSjH2MctwTW6ekZsZ4Ck+VJBwaovXmOthMt4rSYWtTrSu7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA3PR11MB9225.namprd11.prod.outlook.com (2603:10b6:208:570::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Fri, 26 Sep
 2025 19:53:21 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 19:53:21 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Topic: [PATCH v3 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Index: AQHcKPMwwODp7//+PEGBZ/2ZnMIQ/bSk8LkAgAD7uAA=
Date: Fri, 26 Sep 2025 19:53:21 +0000
Message-ID: <ce43fe6f2020be3fce65935d8a97f8ba771ddbf1.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-2-rick.p.edgecombe@intel.com>
	 <34a98a69-8ce2-447a-91b1-7c0232acdc46@intel.com>
In-Reply-To: <34a98a69-8ce2-447a-91b1-7c0232acdc46@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA3PR11MB9225:EE_
x-ms-office365-filtering-correlation-id: a307324e-fb77-4a66-71fb-08ddfd3658ce
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?TkM0SzduSjVYQWVHVVZEemxJSzZQbGcyV0cxR2FIQ21QdkxQTmhVaGZkZFQ4?=
 =?utf-8?B?VFpnOXJmUUFTdEx1REFvaUdLQ09XNVpKRVMrODUxdHpmRjVJSFBTRitqblNx?=
 =?utf-8?B?TXpwcUZWVVlaTWZLaFJUcU0vN002Ym4xU2pMZi9yM3hRSUNtR0c5WTBkRjZQ?=
 =?utf-8?B?NnVsNTRUaC9CZGxGZngxRG9JYTYwZWFWaTNVbFl6YlRIakZOMld1ejRmZXp6?=
 =?utf-8?B?dnV2QUk0bENRc2E5Z3c1Y0diOU4vWk5QTm5hWXZMQ2tTallQTURMNXBlMzlP?=
 =?utf-8?B?dVFXVGVwd2o3KzZRbU96ZUFpVkJFcXMrNy9lVU8xdDZkNHV6ZXpuWDN0WmVP?=
 =?utf-8?B?dEw1SGJLTHhRVEVRM1V6QmxOdUdJZEU3Q1ZiOFd6cE1IMjRWZkFlTExPVVZl?=
 =?utf-8?B?N24yN1AyUVZwMTdvdWhzQW4rN3NpQlZHZEQ1TVByejNMUW50RlJZVkpkUHkv?=
 =?utf-8?B?aWNuMzFKNUl6emdybi9YOGM4N0VrNlpTcXlBNHdpQ01WV2ViMXlkVU1zWEFC?=
 =?utf-8?B?cjBkRTd1Z0RLVDJNd0J4Z05kUFE0NHczZkRtRDd0QkszOGcvRld3NS9YL3dT?=
 =?utf-8?B?ckxiVFUwcis4WmpwTnA4NXNtTlFKeHkrRWNEaE5Rb2pTY2hPdDNxNVo1bnYr?=
 =?utf-8?B?KzdTb09wdzJIbmEyWlZtWXdweFdKejREVUdEcVZRemt4MndMQ29ocHB5R1BF?=
 =?utf-8?B?cDY2TmdqVi92N3RFeGZjUXNLeWxEK1BEeXpROE83eW5Gc29nSStTRUgzamNs?=
 =?utf-8?B?TWwydzFpMnVwa1JaMTFEVW02OHN2T0VBQ04vNWdibk1FbUNjaUVWa2JHMFBS?=
 =?utf-8?B?QSs1L0NoUWJYTkJUSEJ6bFJxaTcvcjNhVU96VEtMMlQvSGo1QzRCWFJtUS94?=
 =?utf-8?B?c0k5N2Rwd3FsQ1ltUTFXMzhQMVIxRWJ0cHFBOGoyWVc4MEF2cnJGcGwxOGtW?=
 =?utf-8?B?d1k4dDY0dzlzRnR4TE5iSWs5TjFhalNTM3FFRFYrNjI5Y1AzbzZnY1Znc3h2?=
 =?utf-8?B?UTcxSHNyM2NiU3I1emZvZ25maG9kVUZTR3FEbDdNZzdTUnJxMTh3bmpYR21L?=
 =?utf-8?B?Y0l0Z1JsalpHT2U4RGhyTEs3UEFmTExLRGpic1hmTngyQUFSZjhyTGljQXRj?=
 =?utf-8?B?a0tuSU5Hc0tISkxpVEpURmR2aU9jKy9lZVNjeDdaWUhDOUlWdHVKcHJIMTBZ?=
 =?utf-8?B?WUdzNVlFbUl6bWxRUE4ySFY3YnN6bVQyM0x4VG5nY1oyRC9IRnU1ZytOK05F?=
 =?utf-8?B?bC9JMzhkSGIrMjF3aCtvOWRqcm1sTmtDcTRtUENyRWhCREVzV1RJOHE4Njcr?=
 =?utf-8?B?UVVSTDNyU0dLa3BZTkJoaVRUZDluOEE0MFNHcjFUZ3N4Z3JoRm4zNmhQQzE3?=
 =?utf-8?B?S211NEQyWmhieDU0QWNvZnZnVk9Wc3IwZVIrK0VZejcxdGx5VzNaTEZpM3dY?=
 =?utf-8?B?YnR0eWFKZjBuZ3BiSExZc0JNaGY0VFliMUNiWXR5U1dxMzRYNEVhNHVTbTMy?=
 =?utf-8?B?d0EvRm5uK3loem56V3FWMy9VdmFqS3VEV1JlNDlORlNzZW1FUUl6SEhBMkZo?=
 =?utf-8?B?L2hyVmg4Y3hMbTNOVTJuQjRCMFROMnB5K3pqUnlDKzN3dXl5OTJlOVlGa0FK?=
 =?utf-8?B?MVhOblByZXh0RCtEVWZLNXlwOVUxclRNR2lmNlNpZzRQNW5hNWNITU1OVVIw?=
 =?utf-8?B?YmNCbXoxVnl4WWhHakNia29la1ZPdWNzeTVFNmRId01ERlM0OTR5b0NCczU5?=
 =?utf-8?B?aUJNa050aGJyM0szRTA2VjYxNnZBUFdxMHVzb0lXT0xEOVJneWtKVFZQNkFa?=
 =?utf-8?B?Nk5QUDUvOWU1a3Z2M1FPelZGbjU1NDNnVVR6cE96SStBSG9jeEIzRnRkOXlz?=
 =?utf-8?B?UlNFMFozMXREMkVwUGV0ZUYzYTV5TmNOMWlDV290M2dnWFpsU09PRG5RUUFI?=
 =?utf-8?B?RjVxUFRZSkdIOWp0VEVWWkpIRzNjdDBnczhQWXE0T01hOTZ3bjNXQ21VSmM0?=
 =?utf-8?B?QUc3MXNOM1JOU0hCcVRrelJTTEtjbW94NU5KWGZjSmZrMUtMNjFjRlRVTy9u?=
 =?utf-8?B?djFlMmk2MWZqem1tK0RKNGJ1bDFzSkorTTlIZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXN3OU5CbnFjbWRqWWZTSjdhWnY0VFVGYzkxYlVWaG9FdVZVR0pNNnYyUHhn?=
 =?utf-8?B?a2lrN1NNdkg3aTJPWTQ5SFAxOXBMK080c09Zd1pZb2dCUHNwcXE3ckVVTlpx?=
 =?utf-8?B?V3M0aDQ3dTlhZ242UzM0RWZnY2U5b0hBQi9TRlVzODcwb2Ezc2hpS2JETFNX?=
 =?utf-8?B?RDlDQjkrS2tVZUtkc2dvV0tXZ01tSXVQRG1UYjBuQVpjWUpDaU9jNnZsNHZV?=
 =?utf-8?B?aUQrR0ZOSm9HNXB0VU8zRzJqTUEwenVKU3EwS2ttT01uRUFMeFdZc3phc0d1?=
 =?utf-8?B?MW5YaksxUml1endsSjdEaFZENjNpQmZMYThTa1Z2UzlXdGJKWG9CQ1VmZ1Rn?=
 =?utf-8?B?a2FVZXA5M1pINW4rdjNrbnViYTlmZDFta1psUUk5T0wvVWZ5TmJSQ0xkRGZW?=
 =?utf-8?B?ZmtQYkcydmsvSmI3V2k4akxjN3UrVDlrUi9vRFVtKzA0QzBXUU9PR2tlLzI0?=
 =?utf-8?B?aWpCTDNSc3NtZGhJU0xzaWdJYU9rUFg3Mittdm0zcS9CNnVGR1R4SFhxSVUx?=
 =?utf-8?B?WjFlZXd4T0FKdVZ5Y25rQzhkUlNacjBVbWlIQzFwWHNzYzNPN2k5amsyR3NN?=
 =?utf-8?B?S1ZZelVacGZDdEFZNE9KaVBnamNRTC9iSkNkSVQvZTJYcmdhT3pkL3BrRDBk?=
 =?utf-8?B?RGhHWTgyQnc1ZWdhTm9RYkVwZDRlY0xISGJLWnBqMU1OTGduZ1NIRjlRUk5Z?=
 =?utf-8?B?TUlnZzRnMEFPK2ZjKzhGWkFQbmVDYzA5TGl1MzVMRGFHaStjam1FRWhBWGxP?=
 =?utf-8?B?Z1hlelV0VEdwNDdSdUpScGVsMFBaRVphdU9pbEMwcytTamV0YlcyOXhxSUo5?=
 =?utf-8?B?Tm56enhCOEtNNUt2RHdubWJteXZPaEdSNXJCckRqWkNhV0tSdjVtR2cyWmpG?=
 =?utf-8?B?UGpsdGMvSGdyUDlDb0FSZGlvR1FiZmZoS0pwS1lOWEJYQWdtQTVwUjNRUmVE?=
 =?utf-8?B?UCtBR1krSlovdU5zc2VlL3dJK25RdG1ZRFg0cjRiL1l4cVFaNHM0YzBRUzNC?=
 =?utf-8?B?QUt1Q0pmeVhrMkM3cEVrdGRrSjR6UnJJUFBKRnJsblJTcERnUFB0dVArU3pE?=
 =?utf-8?B?TnVjdWV0ekxER21Qbi9iakw1NWdkdmJuWFBGVmIwYkZ2aVA3bXcvMm1ubkFU?=
 =?utf-8?B?MjJNVVNBcUZWbDZTT0ZmQ082Qm1aQ25hN0hWNlVyQnYxb1BCeVdwWHo2MzE1?=
 =?utf-8?B?Nlo2UVlDUmxsMWE4R2plVzFWOXl4L0Q0N0xjWmpxSi9BaWk4MUtGbTAxZXlR?=
 =?utf-8?B?Vm5MLzRya3A3UkVmMnJ3ODlrVG9Ka0N2RXhHa3EvcDVrbEVQazhNV2dCTU5q?=
 =?utf-8?B?bWl2ME41ZSt3Q1RxM0VPa3N3aWNUeGx4alhFYXBGeU9zN0xRK1hSdWJLaDNQ?=
 =?utf-8?B?RjZjMDdOekdTdEdaUGlQK1ZJcVZlQ3FueGdxYkdzWm0vczRUaHpmdzNxQU85?=
 =?utf-8?B?K1cwM2JUbzVqbzVsL1BPc005SzlLN1BjTkduQTJhWFc0SjEvME1HZi93a0hV?=
 =?utf-8?B?VkFuT0lwK0pEQkJZaURZL0JhcUgzUUVGaStsR1VDdGlmT1ZzU1dzMGZPMkJq?=
 =?utf-8?B?aEZaaS9PRDlOS0VGVlRZUURtM1dsTUk0RDZ1bGtPNzdlNUs2ekM2bzQ4bmZ6?=
 =?utf-8?B?cU93ZGV2SjBFRVFVcUx5UDRQLzdFK1o0ck5xU3lVRWR6aTN6SHVLSXNwODBT?=
 =?utf-8?B?eFF2UnBkWDYvbDAvV3pqUG82bUxObzhkRDlLSXc5WEcvby9zVDZLbHkwME83?=
 =?utf-8?B?eXlKa0EwZllOQzAwWHA2ckJ0a2FscHFCWVdyU0JsYUdTaUFkWVBRUmZwTXE2?=
 =?utf-8?B?TXVFd0FOZUh3YWZmdTB1SGVHZ21jcmI0aUorQms0b1FPdEx1TXg0R2RvU2o2?=
 =?utf-8?B?M3p2S1VpMWxLWHRiL3VpcUQzdVkwMmZKMjVCZkthL01mbGFrcXp5TWVMQkpB?=
 =?utf-8?B?SkErd1VGY1hBQTIzOXc4czFQR2ZqV3V1MXUwNXp2WmVFSjBjSkJpOEFyQ0F6?=
 =?utf-8?B?eUlqUEtLZlNkQlNLN0RLd2ttRHczUUVGcUZwekRhRmFvVG9DYXRDNTYvWTRZ?=
 =?utf-8?B?VHZpRXBlTU93Qys4cFloQjYvcDNDZGY4OGpLUlovNVJtdERUdEJuZWY3MW9B?=
 =?utf-8?B?alRYMWJGTDJkWHQyOGFjTUtvU0x1RFpkdUh2TGZKVThEYWcxbWtxcDVkZi85?=
 =?utf-8?Q?ctw5t4S13OiMe/enZBqZk2k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E50981F298045C448F5C6F6EE4B193B4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a307324e-fb77-4a66-71fb-08ddfd3658ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 19:53:21.6412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tJ+isC7oJSLfk5r6zkeIJIgzinLYfWpXQiUejQ3YvWPpwKBaIIlQzj2ks+ca81m3nOsjxzSD7Cu7P806jAg7b//STSyVgamMnlWw008q7ck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9225
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA5LTI2IGF0IDEyOjUyICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiBp
dCdzICJhcmNoL3g4Ni9rdm0vdm14L3RkeF9lcnJuby5oIiBhY3R1YWxseS4NCg0KRG9oISB5ZXMu
DQo=

