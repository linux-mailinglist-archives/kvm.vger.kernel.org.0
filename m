Return-Path: <kvm+bounces-56649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6A77B41049
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 00:47:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EDCF3A27AD
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 22:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8349E275B1B;
	Tue,  2 Sep 2025 22:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G/l8HGSC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D50258EED;
	Tue,  2 Sep 2025 22:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756853223; cv=fail; b=NT4WgqMaDZAB7eV/i4CrI/gpW+Qap+lRuiaJ961rpTAis3P1DQhXQkEvRdeCi6JQJ8qpVV6iGsJFOPhajL2r21CwbXj+HWDUrpElYLiXlP4XI2+dK7I5UwgS2YFrOs2aPYzN1tjJIkIrK8c0deJw2EmZQP3lLSCEKdGTN/sTF38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756853223; c=relaxed/simple;
	bh=e/VV2jxNPoph7duNbs6dgOjw22vcGj3oSorUSeb6mzY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ohz+jOBCnztUZDhf8q7tGOhNJIdJUtjtVim7Bn61emTIORtWywtCwTi1dNxOXUvtNQFwmeYLNaiW+v7zuYyBVTyZNw+CEW91t7Z04DYL5XkynyhwDJd+L/p+64G5WOJzcBkuDSgPsbElg9sFD+LOBXnNjFvhioUvlGVKLpJeoX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G/l8HGSC; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756853222; x=1788389222;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=e/VV2jxNPoph7duNbs6dgOjw22vcGj3oSorUSeb6mzY=;
  b=G/l8HGSC0S62I2wNIuoaDen3zuxrJWGNF123h8/5gKZ3+qufeiM//M0+
   B7Mb6vuI15yvyg2jGNispoHNUmZVmf2HfcowPqmQRkOHgANvDeHANs45p
   mj05CHTI22TpTYlouJsXIOWskfJMW4UNtwKtU2up1vqJF4wBh5V7hdrBF
   cn2vjEhI3nANioeTmbL7Z8bQnhX3iDyGXrul+ACYdqK5oR9C6/RqmXB85
   cQR29pzYLECFt2jRDOSo7acPLc9WQ1ATSZyYoTShHiwoyD83mZjSVQZKS
   uDjofqo4sfrYAZf+g1gpIS4/lRZfWItUiOIOy456G+ptVleLCh8CY/y8m
   A==;
X-CSE-ConnectionGUID: ntvpjtSNSj6JxSmJEvqvzw==
X-CSE-MsgGUID: ByyQT5McS1mdd25PhEVvJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="69416724"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="69416724"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 15:47:00 -0700
X-CSE-ConnectionGUID: z48heRU7QOybAt/2MMcnQg==
X-CSE-MsgGUID: fxkrl0m3TjW6RF/Vqt1qmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="202370399"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 15:47:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 15:46:59 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 2 Sep 2025 15:46:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.54)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 15:46:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ej2UV968/1gGBJHgftT46ulOaNwa45NVLeTSa5UtOyTfhXYOfIFtsqrNkrjAQ+d499+tM0K84Et4CZgo9U768yziZR13CSDDYPh6Qej69NIhz2Zy5Tmt6aiQEV+mNLAO0xFlU7KJuz9S/yu/Clwkr5nLCAQwmVhVhRRWrFci3MQIXu7T0nN2OVUW/VyRRiv2jZLDwwo3HdY6MHBRKZPd18RbbQv8GUYGA+XN2Hnf7AdKcQSrZ6is/sQ7la7RSR+3jvBjL2Dxk5su/9PZkp6yAlHgXWFUSOafzmgKdRIJB+7Eac0rSL+KlXUyPkF0HdwVjdfK29cfsUbNBEYO8uw7rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e/VV2jxNPoph7duNbs6dgOjw22vcGj3oSorUSeb6mzY=;
 b=bDzUhf5LtnNDc+/JyLgoKcP1moD+x00HGx93yco5FZNFBYBuMhbchEDZvWp/ty+TIOaHcXyRLg1IQGH0qHRGMK5KhqFHrN2GwAuQsMaHBfi3iVOGYKtYijRBtGWXwc2H8IngQrAA5cQ+88CnWuDRqcLcDRc3fs8bVPL+6bw5dvA/K+K7MsetOffAWRnvK/hFlc6U8+o0OojXF5lWM/RKddfFzT8NZGoFWJDy6VvCtqoH2CKZa6tR9sSqlF/VGKK0Qniga+8h6Obp+fHnbYqzGLgrzrpgIk8Yx/Kng7UjAs4SwyttMX69BP6ZAvMOwNOMlfuVlb4gh7fJ2u/QivA26g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB8523.namprd11.prod.outlook.com (2603:10b6:806:3b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Tue, 2 Sep
 2025 22:46:56 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9094.015; Tue, 2 Sep 2025
 22:46:56 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>
Subject: Re: [RFC PATCH v2 11/18] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Thread-Topic: [RFC PATCH v2 11/18] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Thread-Index: AQHcGHjRJn68PQjSkUOZJqCmTYtJD7SAhgSA
Date: Tue, 2 Sep 2025 22:46:56 +0000
Message-ID: <fa7864ad360545c0673c8e07f458a447baf366d6.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-12-seanjc@google.com>
In-Reply-To: <20250829000618.351013-12-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB8523:EE_
x-ms-office365-filtering-correlation-id: 01c13b49-d541-4d4c-50f9-08ddea729eb1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a3hzSytvVHcwUzFIM0pFdmxkSzQvbWZ3Sk5ZWm9NVVlnZlZCYzVYNy9IeXlz?=
 =?utf-8?B?K05FbW1NemxaZjlzSklSWXlGY0EvQ09yd3lhRmxYTWZSMlRKdE1DZlFBRUw3?=
 =?utf-8?B?dmQ2ZnpxTGxSN3hiejN4dHJubG5SV3psUy9ueDRiQTRacVZKdjFmWUtMMmVa?=
 =?utf-8?B?ZTh3bzREMkpqVUxtUXNvYjFDZUVSNWlQQkJIczdzQU5GRUduYzFhejNTUmlZ?=
 =?utf-8?B?RFh5WDNTTFpRTlZFSnVLamh6L1g4MmJqdkxCcXUyZ2hhK1RPN21oOUk4eGh5?=
 =?utf-8?B?NlNKWThsMVhaMzZQb014aWdiT2Z6dGpuc0ZNUHA5WFRGb2hoRnoxU1BGajN2?=
 =?utf-8?B?ZkpBU21zYjUyQnpQa1lmMHpTM04rN1pGNXozd3VBbXNHV2dwWFc4OWxSREtC?=
 =?utf-8?B?SVJPWERqcTFlWGovZjhtV1RUUnpxOHJUdUcyUmpza3JMTHhaMlhzV0N5YVZZ?=
 =?utf-8?B?VzI0b043Z0xCcGFoUG9jS0QwRVRDRUttWUpXRXVFZ3VtdzJ4MUdyUEY3bDg0?=
 =?utf-8?B?ZmtXMU8xT0I0bVFvUm51UDVzYU5xeDBoUTFZemxWTWNDZ3VEMVFrbmxrQ3lQ?=
 =?utf-8?B?NU9RWGFJeDFCKzlsaDBhaXhoc1dvM0FnMjZYcGFtVjNHY0hQajhHaDU3M0dt?=
 =?utf-8?B?aXVEWmRnK1RQdW9FandUemc3RmhYWGFicENSM1RTNWYyRzRZaEpiQnZEWC8r?=
 =?utf-8?B?eU5wTkpFaU5MeU5qZnhzNVBNZFE5SEYwRmpyUkJlM2NaaXNPTngyVGdaeDIy?=
 =?utf-8?B?dFhJWFlJNDBmbG16MGpmT0d0QjVSbVVIbGJOZzAvc0NZQTJoZXdxbVFPUFNI?=
 =?utf-8?B?d085QU9FWTRxV2cvZFNIWUdadmtnUmZpSDdlQmNPM1h1V0dGT2FJYUgxWDIv?=
 =?utf-8?B?SDlGUFFjVUx3NXdFUldUQ2pmUmdlRHd2d3hEZG05Zk9UVHFKZmozMjIrN0VO?=
 =?utf-8?B?ZFY4aEtBdXRHNUtRR3djVm5OdVp2NFhYanAydXF3TnRrQjlKTy9xbXBORFJF?=
 =?utf-8?B?RHZjZkhpa1Y3Sm1iR2YrSkdXZzJOTmZmZjFjZ3lWbDdUc3k2dzRIWnZobFBs?=
 =?utf-8?B?Q3BUeTNMNyttU2dnWWNZalVLYWRObVBFaXFwM2diaFNNd0p2aWx2T1JNSlpI?=
 =?utf-8?B?aDBGc3ZSRmNpNVk5dVo4OXczWmM0dUdiM0V2bnd6WGNZaWFaY0dYU0p2KzU3?=
 =?utf-8?B?WUJOWUJRL2hMOFNWdnBhak1hT3NWZ2grMG9rc1pDMURSN3FDVDBBQ3I0ZGps?=
 =?utf-8?B?NzNOSXlJanh5bnNiUk0xMTVFU2ZoQWl3TXREUk12VVEyZ29iRW9sN1M1Rnp1?=
 =?utf-8?B?UXhrQ3REVG9hV3lFYi90dXNNS2F2UlQ5TmxMU0VVWlhuQWttN0xXRWQvM0V6?=
 =?utf-8?B?d0RJc0hwQ1FaUlJyTlREYzBPZ2VwcTQvNzFLSG9aM3crQjc3WlNsOHNUajNN?=
 =?utf-8?B?SzNNbEoxUi9uSWdwU244eUY5dzFkRHVHbzRiam92djlCNUI4OGZzSzdZcDhL?=
 =?utf-8?B?bUZ0WFY3NUl4dHJEZnk5MEdrUlY1SlpVOWpYa3NiLzNTbGYyZlh5SHAxRlhI?=
 =?utf-8?B?d25MeTAwaHpLakJOSkoxUVpJVjRDQjBDUFNlN0Fiak55UlJxRDRVdzhyUjZU?=
 =?utf-8?B?aVozb0FZRGQ4bnd6R2s4Ykx5ZlVQM0R5bTFKNGk4R0xPWEo3ZU1lWS9ab2FB?=
 =?utf-8?B?SWhITnNJN3NWMUwwYUZyTkVyMThrdk5BWUlWVjdKSGZnN2dWRnRlbVUrZGhI?=
 =?utf-8?B?V0VuRFM3Sm44ZGJVbTEySXYzNGkvUlIzR1FsZ0s5RXI1b1NuMzZXNWtyL09P?=
 =?utf-8?B?aTNmdm52OFdDcURQdENXVmdTZkx6SDVJNERONTNydVNpYUp6TmQwSGI0RzFO?=
 =?utf-8?B?dDlPWkg3blRTaTRMZ1F5ejQvbFN0VHRMRkxIQ1V3a2FnaURwOFl4ZlBGcktU?=
 =?utf-8?B?SCtjd0NLa0phRU5hZG5QRCttMFM0ajFyNm5mWW54MllxcG1ZYmwvczRPUkU3?=
 =?utf-8?Q?KLEpGvSJZdrRHqsyWoHdgy5JsmkBoo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2NIUUxycnJEdm8yK2pKaXFwbHkrUzFPMlg1aTUrdnYvQXI4T1lieWpkRGhV?=
 =?utf-8?B?OWJKVHRTTGtTT3BtMEpaUHREWGhvTkVHWVhKSUhiQkkvZHdBdHI1YmxBUXRQ?=
 =?utf-8?B?MzdWMTBwNWp0WXo5dUt6WnE0b3BDNkhOUHY2M2swdGZreEJMUzZQc3Rha2Ju?=
 =?utf-8?B?aVcvSDA0dUNERWxWcmRQQjZyVFlpVi9MMmhrMUNDYkVmV2t6TUxMczk5K2J3?=
 =?utf-8?B?dDlZNE5ITUExYkVHNXBpQkkzek50TC8zQitITzBibVZhbVh1Qy9EeVNMU05K?=
 =?utf-8?B?R0VQS1F1SzBMTkRHNUp5TVlXSE1TRksrV2lURTNRd29yaFl4dDVTc2RLdXdj?=
 =?utf-8?B?RDZSNDlUV0ZMSTdpSXI3V2ZXSXRmNTRnMGIwa2Fod1lqNmd1SWNtdnYwZVAv?=
 =?utf-8?B?SG96Mmw0YU5mSGxuZjhDd2xrT1R3NDhqQXA3T2FJRU5rSnU4OTZFd2Mva0Nv?=
 =?utf-8?B?SytmdFY5bVJwOUpJVGt1VzlQSEQ0Vy9nTytMNkQyTjFmc3hMM0FCWWdMRjlG?=
 =?utf-8?B?VVY2M1lnSmY3a2JYSXVoa3NuT2JwODlmTURpK2RQejhJeDMydlh2NjAydFdT?=
 =?utf-8?B?ZzFhcUlGdXZrOXpGcU9WRElhOXd6UXRUeVRRY2RNZlE3ZnNGT0UwR2EwaUxj?=
 =?utf-8?B?RU4rTFNNYldRN3lwV0xaa3pBSktsODlVbXJtaHJ1cG5oeDJnRmxmYStDUlhj?=
 =?utf-8?B?Q2ZiekkwODdnSTQ5MldXMklWMjFPVzRhUmtCYVVEMENHaHduWExhWWFFQjZR?=
 =?utf-8?B?UFZGNVI1Nk5ZU1hoOWZ6SXNDcXREays5LzUxYWgxd241MllmSFZEeklQWjZE?=
 =?utf-8?B?OFlTMDZOck96SlE4dnNJQ1o5aGZwKzhDV0ZpeVVjcVBQSnRXamd5TGoyZWQv?=
 =?utf-8?B?Z2tLeStKRUh4bm1VOHUvSWNveVBTVTR0b2lPclRWRXI3cjI0dUNtdGdHUXdi?=
 =?utf-8?B?SThDVUlUenlLS21Ra25VY3dEYVRvcGEzQzN2L0U5dyttV0xpV1A3NVlvRFVt?=
 =?utf-8?B?QkNQcXo0NzQ0c2hLaS80T0ZreDJFVTI3QktWODBsVHM3VDVzRGh4VzBmRTE4?=
 =?utf-8?B?azF5U3JCbW5jM211ZmZTMEtaamg3SFB1MUYwcEhTNnRBWDVjcytmcVhVbDUz?=
 =?utf-8?B?bjJMWHZaVllkSG1yVUprY01BZE9Wd2ZnVEFuVDJTb053Wms1bzFkRWx1TnBw?=
 =?utf-8?B?WXRyOFpJdTVUVWFZeVNPcFlYYXgzZWFvdG83dGNRYm5xQnVsNHFMc0dQYUMx?=
 =?utf-8?B?OHp5ZnY3N1NWbER3dzZEQkp5K09mTkVsQlg0S05lMzJQN2xBcFFIa2d5Tlc5?=
 =?utf-8?B?aWlQS1ROVVRER0Zyb3U3QnZreFNyMWdadlJQSC8wQWRYaE1SSEl5dWJMRFpq?=
 =?utf-8?B?enRiaHZjeHdGWkVPNWdZSGlxRDFjeTdhTkVXNWxzVnRzUnJ0TjZXVjA3aEt3?=
 =?utf-8?B?T0ZWd3I4QkU3SDRoZjZyd3dYWkJQbjdnbTAzUFVvVllSWjZGUUs1Y3kxY0lp?=
 =?utf-8?B?RGhyQVVlOXFBNDg5SUJIaTdrTitjbGp3SlNyT2FrRnhDK2g1bGYxK3RGVjBa?=
 =?utf-8?B?cDhCS3MzbTRFOW1FeHZiVUpCRWNsZ2JEU0dYc21RS3QzWlA4MjRsUksvNG5V?=
 =?utf-8?B?VVlQdVprbDE2Skl3VmF1ZWdJcUEyTEg1aGl5cjM2K2FlNjVxUnhjRWFhN1dt?=
 =?utf-8?B?TGFad1lOeDMxTHV5Z09XUm1qQXRsMzhldWRoZDhhc3ZONXBpYnYvTStYWTdu?=
 =?utf-8?B?aWdLNG9JQ0lNc3hFKzZwamVWUkxlbVV5eStxdlRqbndSUncwWlJPM0UzZkRl?=
 =?utf-8?B?YzVDWkZYTnpZTHk5VWMramVIWmlLMnVaVTNVVEpyUmRaRmtVZTNVeGlDR1do?=
 =?utf-8?B?QjBCbGlNVmg4QkJsQUtDaFRYRDMyV282bWhtK1FMUnN6bStQQWNjQm5TQVlh?=
 =?utf-8?B?a2hSdXdBTFpzeEdQb3ZManZLUjVQVk1wNXJDdTNteWZ3Zm5lZXJoOXZ3anhY?=
 =?utf-8?B?OUxvTjQyMkFIQmlKYmZBUFpEa3Zza1RXY2pURER1a0JFd2Z5elBxVDdGQk9Y?=
 =?utf-8?B?dFdOOXJ3aTdhaGJTWGN1b3AzdHJZcEtGZldIZHJsYUxjS0VPOWpPRTBreVZq?=
 =?utf-8?B?NzN0TENjYjREUTczVmFsenBHS2VPU0hrbVlxZUN1WS9LZzhTY2FvVW1iVlht?=
 =?utf-8?B?OXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA6BC96A99D33C47BE30854F72401DF8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01c13b49-d541-4d4c-50f9-08ddea729eb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2025 22:46:56.5436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nbqyRqUhuvX0dZTzEm+37pJP2Nei/JYwht/nF5mGmp979HxP8rC1oMJukJZ3NFvFmAHwcsldHXbIpKjS8uiwRyixIN+J3S//u7aoHL9z5l8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8523
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDE3OjA2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGb2xkIHRkeF9tZW1fcGFnZV9yZWNvcmRfcHJlbWFwX2NudCgpIGludG8gdGR4X3Nl
cHRfc2V0X3ByaXZhdGVfc3B0ZSgpIGFzDQo+IHByb3ZpZGluZyBhIG9uZS1vZmYgaGVscGVyIGZv
ciBlZmZlY3RpdmVseSB0aHJlZSBsaW5lcyBvZiBjb2RlIGlzIGF0IGJlc3QgYQ0KPiB3YXNoLCBh
bmQgc3BsaXR0aW5nIHRoZSBjb2RlIG1ha2VzIHRoZSBjb21tZW50IGZvciBzbXBfcm1iKCnCoCBf
ZXh0cmVtZWx5Xw0KPiBjb25mdXNpbmcgYXMgdGhlIGNvbW1lbnQgdGFsa3MgYWJvdXQgcmVhZGlu
ZyBrdm0tPmFyY2gucHJlX2ZhdWx0X2FsbG93ZWQNCj4gYmVmb3JlIGt2bV90ZHgtPnN0YXRlLCBi
dXQgdGhlIGltbWVkaWF0ZWx5IHZpc2libGUgY29kZSBkb2VzIHRoZSBleGFjdA0KPiBvcHBvc2l0
ZS4NCj4gDQo+IE9wcG9ydHVuaXN0aWNhbGx5IHJld3JpdGUgdGhlIGNvbW1lbnRzIHRvIG1vcmUg
ZXhwbGljaXRseSBleHBsYWluIHdobyBpcw0KPiBjaGVja2luZyB3aGF0LCBhcyB3ZWxsIGFzIF93
aHlfIHRoZSBvcmRlcmluZyBtYXR0ZXJzLg0KPiANCj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UgaW50
ZW5kZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNA
Z29vZ2xlLmNvbT4NCj4gLS0tDQoNClJldmlld2VkLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmljay5w
LmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo=

