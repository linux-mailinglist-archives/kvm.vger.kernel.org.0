Return-Path: <kvm+bounces-40714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3819A5B65B
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 02:54:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10814167BC1
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 01:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B6561E25EB;
	Tue, 11 Mar 2025 01:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OXgpmWwD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CF641C63
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 01:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741658056; cv=fail; b=L+AddRyNl+hcwZslB/T4+a2Af9XiTUIUZZOW0qBAkT8ZylYMlIkjYCMJkDlnEv6bQHryV14BhhpUKpi6ox/Jo1DjosrjPYKeong9wRlFeq6JjWHhqDkisypyO/wyHe6nmhMpbU7YpojXqjVotTxWrn97NK4aUeNRgy8zfKfxdaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741658056; c=relaxed/simple;
	bh=kD+3ms0RXMoF2v8BO9MeNfFgnlYh0sAKskNUlXoDhKU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MWcdUubQY/sfD07HXfc/aY+7mqrFUb924uxoxfAqtUg5Lp/BRD7lJF3TKezHx6TGYaq6Jeu0oGOnQEELu2QX84ioHxee1Cv5/T8nadjLBSo+mYMitcfvV/2fAeSqwEeJp6NqfTuonB1NJyQRYXbYujkL7SqATqFXcmufz9JXLk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OXgpmWwD; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741658054; x=1773194054;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kD+3ms0RXMoF2v8BO9MeNfFgnlYh0sAKskNUlXoDhKU=;
  b=OXgpmWwDq99L+vxfItG4B+xqL7LI0CHKYVIMXGFxlee0DbSuR776dOxv
   ANam+xRECWRmZULmL/xfAX0F2aIgwkIHx2HTJcqE4WMrxivdw9104UhRY
   IevLsYvnROJgEEjH6tHoPXxPnw4W2S0gDQAbI1/hGLtNX4Ozz0r2UoBji
   rEKKPZNEHRsPkv9MZc1ZLwEayingummE+MMQVltpFhK9qdzlmkFC4udd6
   apaJ73BoU6quSt8FRrwn0vzENyuVpYBbk4RqV/WdcWOTiuI5+DcP/fmzu
   UpiH2ZygJtRBKxcjPPJFTEGzGWiw/xkQuOLawb3FsCNBOpxB7yVEeuI6k
   A==;
X-CSE-ConnectionGUID: yjLAK7odQYqLTEdLi7L3Gg==
X-CSE-MsgGUID: XvUn2LWmRTiIQ8ZOwXGxkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11369"; a="42530036"
X-IronPort-AV: E=Sophos;i="6.14,237,1736841600"; 
   d="scan'208";a="42530036"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 18:54:14 -0700
X-CSE-ConnectionGUID: 4w0GBkpwST2alrFV9EMcSw==
X-CSE-MsgGUID: xKSJSa9XRgisfcOOONwgdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,237,1736841600"; 
   d="scan'208";a="143359151"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Mar 2025 18:54:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 10 Mar 2025 18:54:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 10 Mar 2025 18:54:12 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 10 Mar 2025 18:54:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MTdMpHX8IV1e2dKBIa7v8qp29iMFpngv47pj0LFH9mUnSmq8RungqLWp14FN6ZW9RtK2m8wVmzEXRXEAW1Cx3cYLMevJ7kyIhO2MFdQ4CvAlY+h7964/lskOCn5KQY4Z2pyjQwbdoeXV/l7eV6pJHfv0rvXQO7rsaz7Ay6z7hQ/CMtv2thieoUw0IatE6i+C6XqCLulsAcGMFhI0iFIf9guasCK6iPvG4ZIbQRnMNYhjXXWz48RRg6cKQ83lOOp7z8mZJfPDs67xPLnFpU7yfGa49wL3xWUvimAW+EzOPo7hVa9ytjOH21QoGC9PZVywypILiH1au4EfmfmGig+uyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kD+3ms0RXMoF2v8BO9MeNfFgnlYh0sAKskNUlXoDhKU=;
 b=ruyhROiuLNMazRxwvCwn56l+bw72cRQq13UBrv2bRGTlBwO79YzoBdRbu6xn/uK20COsWkUXeASJtCcBqNezuQnWl+33+7Qn0kNGhFbjYkTJipDFOwCNvBdLU+AR1b8KiPtFMNzVn/cyohBFAiuH9soDSt9nvE0cHBj1d7g/7JGhto/iDjoTFEeU8ygMmywYp5hGkpY2GC5Im+LY3yZATgt/HAvgZt0XX+rwsIzb4hmWdCq1Na1H2uz6xJgDKfXC/PS6LdxK7Hhhk/Izaf7xLS33F0kZSdQoIoz/5W2zvYNb5ItgjaoseroKBswH/Vegfzmck5WHywYb6EWVPPfTWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com (2603:10b6:a03:47d::10)
 by PH7PR11MB6030.namprd11.prod.outlook.com (2603:10b6:510:1d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 01:54:07 +0000
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::fe49:d628:48b1:6091]) by SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::fe49:d628:48b1:6091%6]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 01:54:07 +0000
From: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
To: =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC: "Liu, Yi L" <yi.l.liu@intel.com>, Pierrick Bouvier
	<pierrick.bouvier@linaro.org>, Alex Williamson <alex.williamson@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?utf-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Tony Krowiak
	<akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, Halil Pasic
	<pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, David Hildenbrand
	<david@redhat.com>, Igor Mammedov <imammedo@redhat.com>, Matthew Rosato
	<mjrosato@linux.ibm.com>, Tomita Moeko <tomitamoeko@gmail.com>,
	"qemu-ppc@nongnu.org" <qemu-ppc@nongnu.org>, Daniel Henrique Barboza
	<danielhb413@gmail.com>, Eric Farman <farman@linux.ibm.com>, Eduardo Habkost
	<eduardo@habkost.net>, Peter Xu <peterx@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "qemu-s390x@nongnu.org" <qemu-s390x@nongnu.org>, "Eric
 Auger" <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Harsh
 Prateek Bora" <harshpb@linux.ibm.com>, =?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?=
	<clg@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Jason Herne
	<jjherne@linux.ibm.com>, =?utf-8?B?RGFuaWVsIFAuIEJlcnJhbmfDqQ==?=
	<berrange@redhat.com>, Richard Henderson <richard.henderson@linaro.org>
Subject: RE: [PATCH v2 15/21] hw/vfio/pci: Check CONFIG_IOMMUFD at runtime
 using iommufd_builtin()
Thread-Topic: [PATCH v2 15/21] hw/vfio/pci: Check CONFIG_IOMMUFD at runtime
 using iommufd_builtin()
Thread-Index: AQHbkH9n6UTdqDYxnk2KS04mTYbprbNrsnswgACvxgCAAMu6cA==
Date: Tue, 11 Mar 2025 01:54:06 +0000
Message-ID: <SJ0PR11MB674427BA969DCC35B1FACBAF92D12@SJ0PR11MB6744.namprd11.prod.outlook.com>
References: <20250308230917.18907-1-philmd@linaro.org>
 <20250308230917.18907-16-philmd@linaro.org>
 <SJ0PR11MB67449BEA0E3B4A04E603633C92D62@SJ0PR11MB6744.namprd11.prod.outlook.com>
 <d883d194-3a68-4982-a408-d9ab889fd2c7@linaro.org>
In-Reply-To: <d883d194-3a68-4982-a408-d9ab889fd2c7@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB6744:EE_|PH7PR11MB6030:EE_
x-ms-office365-filtering-correlation-id: 07dcbe07-ef81-483f-5567-08dd603f9bdb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RmZHVlNWVm5ja205bEJ1U0diL0cxaVVub0JjKzhLOFg5dDJoUmlHczVILzFN?=
 =?utf-8?B?RlkzTXFTTDFXQVJydDFCWm1MVzRYaVJwbHZ5QnJ5T2lVRzhzWFMybVVSU0dD?=
 =?utf-8?B?UWlWQS9Yd2U1YzNqLzhZdXlmOUxNYWdBVy9mdzVVRCs5UEhiczFYcy85WTVW?=
 =?utf-8?B?NTZDVU1iNHBvL2ZCcVBPbEJtakpCdS9CUytJSDRpWU90QmVCNUNDU2lSTWRn?=
 =?utf-8?B?UlhjU2xvL25DOWRKWFJJZmlRRHZaMFBLbzNXQVo5U2dhdkR4MTVQRW5Lamx3?=
 =?utf-8?B?QWZzTjdLc1BvdEh5cW9tdXJ3NGlOTW9XaGNjN1ptTlRBTWhkK05Kd1d6TnZJ?=
 =?utf-8?B?SjhFRU9rUUdoYURYcUFPV0FDdVFtR3U3eENZYXhWdTNqMXFLRUpMVlRNYXdS?=
 =?utf-8?B?U1c3b1pXUHRuUXV2d1RKTEpENTdOYUFoc0FmSGcyM3F2S0dKUWs5dGIwVEdG?=
 =?utf-8?B?b2psalVDUmMzL09rQ3pqbUpiVS92WWw2dGhHNG80WWgySUFKWGpnUHU1NFdI?=
 =?utf-8?B?ZUlMMFJhL0c5TGpRc2tBUDFrdTZkTG8xT042UE0yVjNsckg2enlEUEg3VUV5?=
 =?utf-8?B?b0tTU0FzTm9LUnlQVndEa2YvREwvdVg5VGV3VWIvVXI2Z210S01KQW1wazlw?=
 =?utf-8?B?UFltSUk1QXZNMzUrZ0FRUnAzRXBOaHQzSFRYRXU4UklkSDNWeEpUOU92NXRC?=
 =?utf-8?B?UlE5R1VFRENzQ25UeDN5eWtzMVBUSzc2Vmt0U2RtR0o4d2NwWUpKV1lFS2hF?=
 =?utf-8?B?Y1o1NTQvWGtqK1BHOVVwYW1qV3V6ajFLbjdFNnl1Y204akNUNEplWUg2UEkr?=
 =?utf-8?B?MkZQMDZodndPSVdKcWlPUWI4QWIzcXczOHVEL1crblVxbG1wMmlOdXVLQ2pP?=
 =?utf-8?B?SFJqT3RBbUw3WGhHUEZUVENLRWR2aDhHUUpCU1FmcWFDM3RmYStjeDdDaVVx?=
 =?utf-8?B?OHFHdUx2NWhSOEZhWC9zaVk1NUM1VTdDc2pDWkJnQnc4Z0JGMDk4TUF1OTFI?=
 =?utf-8?B?dGROMTAxRDZoVkl2RTc4blN2TTlkOXBDVk5kUjUvaTB6RUVTRmpGMG1yRUtP?=
 =?utf-8?B?TjRkOVZYZk5qdUNmdDd4d0N2VU1KQkFGTjcrdnFrREN6RktqWGRFSjRraDJp?=
 =?utf-8?B?Zm5LUnJ5NEZUbW5oanE2QU9HUjNzQi82aXlRWFBQaERaQm40emZCYWZjOE1m?=
 =?utf-8?B?Nk5OblJVWWtmS3M5b2RDaE5DWjlQRGM0MmRhWXRyMHJDekg1OEtGZkNHWHNj?=
 =?utf-8?B?SHpyMURlTXljLzdxc3o0YzgxTE1jRGNrbVhRemNya09yTTE0M1VYeXZJTXd3?=
 =?utf-8?B?S1NCTHRWR3F5TWdkbEVBdVNBR0RWNlJyaHc3ZndRa3dGMXBVcFdjUzYvekx3?=
 =?utf-8?B?YzJsaXVaQ1lkT2FkenhqR0RxMjcyWnRLOUhQQ0p2Vy9nbklpNi9pRGk3b05X?=
 =?utf-8?B?QWd1NzB1b0thQk1Oa3gxU3FZanpCRjZ3SHY1OFhUbWM1Yjg4dWZLUzMydVBR?=
 =?utf-8?B?VWQ0eHRyUUxXbXYvc1FnY2FxdUxMNmRmRk1KcDFVc1ppY01KUnpLVW4wNHRy?=
 =?utf-8?B?azdCNTV5TFdJb0E2TldrajFFa2cyRTlqc2tyQXhoTlpSUXlOWlBtM1h6QTJ1?=
 =?utf-8?B?aTZwbUVQaDhvUm1mMVpKWDlHc0pwem90UmdkNGtwWFdjdk05OHRFa29KdG5n?=
 =?utf-8?B?S2ExTzQyVEtXdzlxZ2FubWU2SlhpUGlmTkhoQTZyYzM4eFl5eklmRkRMbm9G?=
 =?utf-8?B?RUEyMnVidDl4aTNnanFVZWJqNVIzbTE5SmtrQi9CSXVaM0Ewd0ZkamlVNjVW?=
 =?utf-8?B?d2hoay9UaWJ4VlBEbFNoSnhlWStPTW96dGY1UmdUSXdnSzNhMlNhdDA3clVo?=
 =?utf-8?B?S3FZWXFZOEdnYll3dC8rVG5ONEdVdGladW9lcUtKUFVuemZNTnM1ZWd2R1Fo?=
 =?utf-8?Q?A7NJ8qqk2xz8WFQEAeydoZu/hfQ0Zzng?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB6744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0VkUllrTkZkQWE2UVNKcHQrWEZVWHhETGVoWkNqMEEzTlllMEJhZE54Z09t?=
 =?utf-8?B?MHJJcU9TRVVKbncyUkpnT1k4amExYWNGaDNoUkVDSFk5QXdXV084eE1XOG4r?=
 =?utf-8?B?UHJNU2JWendsaFRNY01rcVRNMEN0dGFuandQY04wdCt0a28yYkhydC9ValFW?=
 =?utf-8?B?TjRZTzhSYzlnWGRkSm5zc21pcjZwQ1kvR2paeThhVWV6SEhCU1ZuL25MRll6?=
 =?utf-8?B?eFRmakdBWGx6bmtpWkRmVHJmeklQTU9oSDF0b1pGSVE1ZnFUc2ViT25hZnFC?=
 =?utf-8?B?WU9QRmE0WmlKRDF4QzdFOWkyQmoyT2xPNmpOdXVuRGUydnQrYXBRaHArQU5j?=
 =?utf-8?B?cE1STHhjaWhCMldkSk5CUndESHcxZk4rSUJ5aWdkOHdYME1xTmw0ZFBaanFs?=
 =?utf-8?B?bGxYWVo0MzVZRitBeHdsTDgzd0owcEZxZ20vOG1xTzZhTUxlYUhMZTZZUUxG?=
 =?utf-8?B?WmVSUHNQWndKZS9INGF3VnZ5OEdFazJmdFFOZ24zVnZoUlhDQ0s0c0tuVEdX?=
 =?utf-8?B?OWNzNjRQZkNLb1VqTG8zejVtNHlZWFVIbXpnSnhvV2YzMXdjNWdTMlc5MjYr?=
 =?utf-8?B?TUtZaFJHS24wcUsrYTRsZytQY3JRaHpyOFltZjlDU3Rrd3FoeUNDcFNOb1Mw?=
 =?utf-8?B?RWhmRm5HdEI1RnVYOVlNS2drTUdBbGVCaXFkenNsZTNXSk9MYk0xYlV5Ky9G?=
 =?utf-8?B?UTUrQXpNSXZkNFV2OVdFTjRYMnd2cWh6NGVxN0xud3BiTDA1dTFBaXNjSEUz?=
 =?utf-8?B?RzJBS2lBd0xYeDJCekVNRlhILy9XQjlrMEQxbnpSUDdTdHZraXpaQlJ6U0t5?=
 =?utf-8?B?ZDNiVGZsZjZoNzdXUXM2by8xc1Z3L3lGK2FTMXZLejBpTGNtMjJRSXYvR0xM?=
 =?utf-8?B?SlZENUNOaGxhSHZ6OVFXUzdnVVFkbnkxZElxTW1lY05sN1BwLy9Lb3V3eTI3?=
 =?utf-8?B?YzNNZGVOa3NlTktXQWJDYmY4WmMyRW5iNWNpcmVoNEN1OTRUVGtHLzNpaDZm?=
 =?utf-8?B?NkROeGp0c0JPZWFrSWwyNXpwc2NHNHBXcG5BSDlRY3hTSmIvYndjeUcxaTBK?=
 =?utf-8?B?T3Nobzdhb1Ntc3Q0Y2toNVRZZXFjS2Z3UG9oWkhoYlBIbmNLRE5KTHpnYU1R?=
 =?utf-8?B?cjNxak05MDMzYnhhWXNnSDZwSEZYeGhYYkdyaG8xTDVxUEthY0sya05FcHBJ?=
 =?utf-8?B?MldTUDZUdkRBVCtUZUtQck9tRHlNcFdpVjdHdllaaUlTUjI4UTF2eTgrVnhi?=
 =?utf-8?B?RElwTHlnY3B0UTFlVW4wcXkvZkFrbnMrQ0d4NWRVMFNHY2V3OFBvMk9LRHAx?=
 =?utf-8?B?MkdsdnJVajJteUpIb0ZiVGFJNnN0SExPM3hJUFN5OUh3Qm1qY0RBcmIwenVT?=
 =?utf-8?B?RW5nUWI0bG5yT0tmTXF2bnRzVG03WEJ3V1Q3V3hUcjUyeDNEbEF2TjRabkd5?=
 =?utf-8?B?T1N2anQrVGJERTBKVUF4QzlBOGY3S1V6M3VEZm9NU2xwcTNVNzhxQ3RQZDBn?=
 =?utf-8?B?Qkt6czVzQTh2OFhQY3VKSklRT01YdkNEbkN3N05scVRVeWZUQk9sUmV5Q0Zz?=
 =?utf-8?B?T24rMkVMZnJQZW9lRmhxcExVZnpDdjdtc1ppS0FSZVpNSzhIWEkwZ002UVdz?=
 =?utf-8?B?aDJPMmxTOVQ5N0RMRmpmeDlNcllFaUlJaFZFOCsyc09hMWdsK1duM1pOK2ww?=
 =?utf-8?B?UjBzeThYenJZMnJEckY5aTRrZFNUWjFPL3k3ZzNDTU80YUNlMDc3M29aM09x?=
 =?utf-8?B?N1lnVG5FYWNKbTdJUmxlL3dmSDFCRklPcGp6dk1leFhiSDRtVUtlR3ZXTXpC?=
 =?utf-8?B?WkI3b09vY1dGRzVUQXF4bkdSd2hISHI5TUhzekQyNmduSjIwdGRIN2lzRVRp?=
 =?utf-8?B?MUc4WlVIWTZ5Q3lKVnZsTmt6N3R3THZXQklEUTdwckJZRG9teW9BRnZNM2pw?=
 =?utf-8?B?V3Z3SFVRa0dsaGljQi9rSXFkdXJ5dGZHbGtLMVRVL3piQkVLanVKUVQ4ZzdY?=
 =?utf-8?B?MXdnZCtxYmQ5NTdnN3NGYWtMRTBhUThoYnZJUGRKV21WanUzaTI0NW5JeEho?=
 =?utf-8?B?Q21JR2s3S1VtUUVIVEJRRVZZNERIblZTVDB3V3M0bmg2dlFMSm91WlVYR3kr?=
 =?utf-8?Q?LZ6RXlTPMXEjGtb3JH34LlruW?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB6744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07dcbe07-ef81-483f-5567-08dd603f9bdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2025 01:54:06.9955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Cgdgtu62fQl3S+Fp7SHgnAEx4/Js+pIrMIjLPVEJVg6hNFlK3AnNNGXDfF5f3aE3uokjfxI4kW3SE2xs+oknjeHxQQ4O6C4pyzYBZyIDTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6030
X-OriginatorOrg: intel.com

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IFBoaWxpcHBlIE1hdGhpZXUt
RGF1ZMOpIDxwaGlsbWRAbGluYXJvLm9yZz4NCj5TdWJqZWN0OiBSZTogW1BBVENIIHYyIDE1LzIx
XSBody92ZmlvL3BjaTogQ2hlY2sgQ09ORklHX0lPTU1VRkQgYXQgcnVudGltZQ0KPnVzaW5nIGlv
bW11ZmRfYnVpbHRpbigpDQo+DQo+T24gMTAvMy8yNSAwNToxMSwgRHVhbiwgWmhlbnpob25nIHdy
b3RlOg0KPj4gSGkgUGhpbGlwcGUsDQo+Pg0KPj4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0t
DQo+Pj4gRnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEBsaW5hcm8ub3JnPg0K
Pj4+IFN1YmplY3Q6IFtQQVRDSCB2MiAxNS8yMV0gaHcvdmZpby9wY2k6IENoZWNrIENPTkZJR19J
T01NVUZEIGF0IHJ1bnRpbWUNCj4+PiB1c2luZyBpb21tdWZkX2J1aWx0aW4oKQ0KPj4+DQo+Pj4g
Q29udmVydCB0aGUgY29tcGlsZSB0aW1lIGNoZWNrIG9uIHRoZSBDT05GSUdfSU9NTVVGRCBkZWZp
bml0aW9uDQo+Pj4gYnkgYSBydW50aW1lIG9uZSBieSBjYWxsaW5nIGlvbW11ZmRfYnVpbHRpbigp
Lg0KPj4+DQo+Pj4gUmV2aWV3ZWQtYnk6IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZp
ZXJAbGluYXJvLm9yZz4NCj4+PiBSZXZpZXdlZC1ieTogUmljaGFyZCBIZW5kZXJzb24gPHJpY2hh
cmQuaGVuZGVyc29uQGxpbmFyby5vcmc+DQo+Pj4gU2lnbmVkLW9mZi1ieTogUGhpbGlwcGUgTWF0
aGlldS1EYXVkw6kgPHBoaWxtZEBsaW5hcm8ub3JnPg0KPj4+IC0tLQ0KPj4+IGh3L3ZmaW8vcGNp
LmMgfCAzOCArKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPj4+IDEgZmls
ZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkNCj4NCj4NCj4+PiBz
dGF0aWMgdm9pZCB2ZmlvX3BjaV9kZXZfY2xhc3NfaW5pdChPYmplY3RDbGFzcyAqa2xhc3MsIHZv
aWQgKmRhdGEpDQo+Pj4gew0KPj4+IEBAIC0zNDMzLDkgKzM0MzAsMTAgQEAgc3RhdGljIHZvaWQg
dmZpb19wY2lfZGV2X2NsYXNzX2luaXQoT2JqZWN0Q2xhc3MNCj4qa2xhc3MsDQo+Pj4gdm9pZCAq
ZGF0YSkNCj4+Pg0KPj4+ICAgICAgZGV2aWNlX2NsYXNzX3NldF9sZWdhY3lfcmVzZXQoZGMsIHZm
aW9fcGNpX3Jlc2V0KTsNCj4+PiAgICAgIGRldmljZV9jbGFzc19zZXRfcHJvcHMoZGMsIHZmaW9f
cGNpX2Rldl9wcm9wZXJ0aWVzKTsNCj4+PiAtI2lmZGVmIENPTkZJR19JT01NVUZEDQo+Pj4gLSAg
ICBvYmplY3RfY2xhc3NfcHJvcGVydHlfYWRkX3N0cihrbGFzcywgImZkIiwgTlVMTCwgdmZpb19w
Y2lfc2V0X2ZkKTsNCj4+PiAtI2VuZGlmDQo+Pj4gKyAgICBpZiAoaW9tbXVmZF9idWlsdGluKCkp
IHsNCj4+PiArICAgICAgICBkZXZpY2VfY2xhc3Nfc2V0X3Byb3BzKGRjLCB2ZmlvX3BjaV9kZXZf
aW9tbXVmZF9wcm9wZXJ0aWVzKTsNCj4+DQo+PiBkZXZpY2VfY2xhc3Nfc2V0X3Byb3BzKCkgaXMg
Y2FsbGVkIHR3aWNlLiBXb24ndCBpdCBicmVhayBxZGV2X3ByaW50X3Byb3BzKCkgYW5kDQo+cWRl
dl9wcm9wX3dhbGsoKT8NCj4NCj5kZXZpY2VfY2xhc3Nfc2V0X3Byb3BzKCkgaXMgbWlzbmFtZWQs
IGFzIGl0IGRvZXNuJ3QgU0VUIGFuIGFycmF5IG9mDQo+cHJvcGVydGllcywgYnV0IEFERCB0aGVt
IChvciAncmVnaXN0ZXInKSB0byB0aGUgY2xhc3MuDQo+DQo+U2VlIGRldmljZV9jbGFzc19zZXRf
cHJvcHNfbigpIGluIGh3L2NvcmUvcWRldi1wcm9wZXJ0aWVzLmMuDQoNCkJ1dCBpdCBzZXQgZGMt
PnByb3BzXyBhbmQgZGMtPnByb3BzX2NvdW50XywgZmlyc3QgdG8gdmZpb19wY2lfZGV2X3Byb3Bl
cnRpZXMNCmFuZCB0aGVuIHZmaW9fcGNpX2Rldl9pb21tdWZkX3Byb3BlcnRpZXMsIHRoaXMgd2ls
bCBtYWtlIHFkZXZfcHJvcF93YWxrKCkNCmZpbmQgb25seSBpb21tdWZkIHByb3BlcnR5IGFuZCBt
aXNzIG90aGVycy4gRG8gSSBtaXN1bmRlcnN0YW5kPw0KDQpUaGFua3MNClpoZW56aG9uZw0KDQo+
DQo+SSdsbCBzZWUgdG8gcmVuYW1lIHRoZSBRRGV2IG1ldGhvZHMgZm9yIGNsYXJpdHkuDQo+DQo+
UmVnYXJkcywNCj4NCj5QaGlsLg0K

