Return-Path: <kvm+bounces-56093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FEA0B39B10
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:09:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7266D361BBF
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49C530DD12;
	Thu, 28 Aug 2025 11:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EZWgH/3c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB202165E9
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 11:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379368; cv=fail; b=rJpXe6uiI7i4OeHlPy7nrL9spU4JwXDZqgqklD5I7ZpRThkp/bOxfJD8nz7sGktX7Yuwts2XntSlyRTyN28WSajyYuQ84uwN2xhxikJR3JT5PbmWIRUY1y8G8zTeQdL16dstVhXXPxWvCx7rldCWnNa3owMT+eZErLAWDkGPcZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379368; c=relaxed/simple;
	bh=3B3nmhAL+TLjQOSCFdJMY3C1AMaDCkJ0LDQ7EM9hnuk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sgeHVZpJn1w920ci+X2P6n5xvzFi+x6U7EQJ5UD0AsdV83OptJ92DiZLrrFEUZ2lrCOzcDgSpDoPlQVuNZn+IQUrwBwCeoWAhWtTxf/wyC2tETPmk06upHRWKnca+eAlo+U7HDhr+HFtfo3ic10mSS1C0TafoEI9V+ziNdWK5cQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EZWgH/3c; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756379366; x=1787915366;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3B3nmhAL+TLjQOSCFdJMY3C1AMaDCkJ0LDQ7EM9hnuk=;
  b=EZWgH/3ckoZK/q9LfaycH9OAOIPrb0sbOupGsA3tk9ogA7lzdig6FnvE
   lWmTQ4su/RD6L8fopUkqrKC5oUVB/2XIj+dYvLKBUrD94GfiLCPEIMEAO
   IZxly0FpRi4JG3SQ/VWkI1ScdqZZeGPt3dJoEJDVthrN6YPNp2q+bcSap
   yOMofklmf6yU6ayYH2k8INAyfY4xzfVYBteooZsfQsF4/Jzle8Yne+zfx
   t65p/aY7jihgbgWzFs2Efc2FgrNCxSVcZgbgcPb0uYQtDdn3ZZzeack8J
   fXJbO4JLYjGOj/agvnJf++yDUEsI+GMusnCaUnxy6pPWAvjuXy2Ig6pAj
   Q==;
X-CSE-ConnectionGUID: A5sTxcfZRmuXBrcnb86Bfg==
X-CSE-MsgGUID: C0T5QWZHTX2KolmvWsSDZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="57670838"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="57670838"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 04:09:25 -0700
X-CSE-ConnectionGUID: Oc0WWLqmSSSSI5Bk8WXP1A==
X-CSE-MsgGUID: hosWLiPZSAC7CWvZvwTkQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169681545"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 04:09:25 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 04:09:24 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 04:09:24 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.51)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 04:09:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t75Sj1UIrcm2FYjO/fB8unNqfnZ2D5PXgbRlk8fcpQhwsDnaOx3SvCJQyOv9CzOP7DUBn5OH3BiGVyZTsc9rk/n8ud13JXdoLaas1zalZYrr7vPLpd4poWnqiU8SD2rhtUYHfkM7XIsQ+aBUhx1EWilxzEMbLPQ6mfAWn7GIfn+Nb4rh1p7Na2epyBRWHrB2tKNjChZ8Sk3OzvMTi9SfM7zB5dZEo12u9idpZayExet5XZIzFW+R5+FndVsBXRa1kAc4SXQi4rf1F/AhOFjHGkbP62GalFCtq790ZfjH3WlfA69eDOMWvZ2Bf5iDVflgnhXRaAAi7KtwyqLGIZ3dgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3B3nmhAL+TLjQOSCFdJMY3C1AMaDCkJ0LDQ7EM9hnuk=;
 b=S0TBUrV6dtqM25xI6FlwFd7Yenn41FI729nnxrVWxxauCk0gD7vdcrdYEIujcJOP/Fjjy3o4LUc6UenKPcrCp1oE7LwQKP9u41N7A+BY+cqiBO47FKn4NLQXuOt2hde5d5up2C6wL04Ddzdhs/x0Ka8pB1HUDJncFAygOdFMsWPP+g+ksviFNWkLGv1eM4pwIllumlyFw0mZq77X9zm+C/wYe9SvbCLstV/g1EtTt8J/FBADdnXWnnzFd8gW1FJOx3WwnHiaD60biIsg95Cm4bewAPHMMnkx4HR1OQ7L5ABHYuBhbGJOBdB4iCL2SwjTvZNfFHu7ddrieDLqGj6aXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH0PR11MB4999.namprd11.prod.outlook.com (2603:10b6:510:37::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 11:09:18 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9073.016; Thu, 28 Aug 2025
 11:09:18 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "nikunj@amd.com"
	<nikunj@amd.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [RFC PATCH 4/4] KVM: SVM: Add Page modification logging support
Thread-Topic: [RFC PATCH 4/4] KVM: SVM: Add Page modification logging support
Thread-Index: AQHcFdP/eGfeNpsxKkei0uEsxdMRfrR3LX6AgABzVoCAAEHjAIAAAtaAgAAHLIA=
Date: Thu, 28 Aug 2025 11:09:18 +0000
Message-ID: <444b1373702fb4871e82381bf3e01d9228df7f01.camel@intel.com>
References: <20250825152009.3512-1-nikunj@amd.com>
	 <20250825152009.3512-5-nikunj@amd.com>
	 <fb9f2dcb176b9a930557cabc24186b70522d945d.camel@intel.com>
	 <86c883c4-c9a6-4ec8-b5f3-eb90b0b7918d@amd.com>
	 <9e214c34f68ac985530020cef61f480f2c5922c9.camel@intel.com>
	 <fd1b557e-8b19-4e71-8e60-3b35864d63cb@amd.com>
In-Reply-To: <fd1b557e-8b19-4e71-8e60-3b35864d63cb@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH0PR11MB4999:EE_
x-ms-office365-filtering-correlation-id: ac0b52bd-b07a-4cef-4341-08dde623552c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V1pEQ0NUYm5Kc21lV1BNL2g0czIwZjFNWE5Lcjc0NEpGYmJZcFZ4bFR3SmQ0?=
 =?utf-8?B?bFFLSys4ekhlZ2lIa29ZakVXc09iYnVsZWRNeXNkaWZUdERVSFRlWkticWwv?=
 =?utf-8?B?d1ZMeUliKzRLb3NTdllwaFM0cUJCbGtMcHhvNGtGRktMRWh4TzJ2M1RLbWJE?=
 =?utf-8?B?SnI2RkxOOXpTVStJNXp2RnFRWUdYSzIrSWdXY1B6QTdzSHJDYjZFRjJrWnRY?=
 =?utf-8?B?M0tOZlA1MmpENWV4ekluWXlqVVZNckJ1dzJSektrb1JBbktXQitJamZzT3FV?=
 =?utf-8?B?Mll5cy9GQXl6SEJQTlUyNHpjL3kra1hqQWRXT0hjcnFKeXM5dUx1ckRZdnVJ?=
 =?utf-8?B?dGw1b1cyN1g4b3JqM04rRXdyNEkyTU5GOGpIVERqMDBQZlBUb1kxS3VxSjBx?=
 =?utf-8?B?V21Nb2VOa3IrSk4ramkySElRaDBJd1J1bDNxVmU3bURIREl1eTg0SFh5RUs3?=
 =?utf-8?B?UzZoMFRSOWk3Q0gvYllNbThNL25oRHVWVVhiTjh4UW9ZWi9WMGtYL1hpNXhE?=
 =?utf-8?B?VnBMSWdDeVljZytFNFJqanlwd0wvcHpLRGVrZTJkb3NNOTdkc3F4OGxkVGQx?=
 =?utf-8?B?SFRLcEo5MTlBb0h6QUoxM04rNWpDVUtDd1UrUVNaK2ducEM1UWUxekhSYWs5?=
 =?utf-8?B?bU5vbk5XZXBvTDZBUFNFemJmRmlGeWJZbE5MNGRZZE5PNCsvV2RhVlpXWHc4?=
 =?utf-8?B?QUs5TFRmY1JLSHFZc0JYVVptZHBoQ0dZTzlORW5Od3FxRXFFeGF3SDhnUldP?=
 =?utf-8?B?SjJYajM5YkF3Y3ZxRkpFQVdnS2lKUUJnN2ttT0xsMWJaUk1KbkJTdHBPV3dq?=
 =?utf-8?B?RlYwUUFJT3BFMlArWUFBTS9pUUt2MDJoOGh0S293cG1FSkVBVEQzbFc5bjUw?=
 =?utf-8?B?M291TVF2S3YwcnMyd1Z6dXR0ZDZmVjh2K1pzMUQxZFVCYkd3TzNpdm1HNnE1?=
 =?utf-8?B?U2JoR29TZTVoMllveDVPVFE5UFlUQ0d1SFg2K0lFUkFHb3ZUMlMxS1NOazkx?=
 =?utf-8?B?SnJBZ2JhTk1KOHNHRWxKMHZ5bFhQV0MyQWZGTzhRRk0wemlYYWIzcHlKOFQz?=
 =?utf-8?B?WVlhd0FLbkZVdjM5Y2NNNkxsMEpCQ3pKaHBqK3FxRWhMMGNESk52c2xLaFF0?=
 =?utf-8?B?b3hqd2pxZHViM2FVVmZ5UGJPb0tiRHBIVExQYVp1akt2RlVSTW9YenZjQXVG?=
 =?utf-8?B?K2szZFhMM1YrWUsrL3VoYVdML1V0eUFzZ3BqcGZtU253QlZqS0Ewcy8xK2R2?=
 =?utf-8?B?THlHMGJlY0JSQWxmMDVlTzZ4SUg3Wm5ZaCt3VU16TjhvellTeCtPK0Z1VjI3?=
 =?utf-8?B?Y3ZRK1dxcnRpck5NWm5NN2RZSmd3K0NYTFNtTXRyK0ppeW81ME5EY245aGNW?=
 =?utf-8?B?aUpzNUVqbE5sL0ZUU1REd2Z4RW9DRGFiVVJRNmN5Sjd3dEdlcTJJL1dCRWM1?=
 =?utf-8?B?VkJkZ3I0VUNaRDI0V3pUcVRaekRaTFF2T2J3Tkp5VVdsbjJWRW5ZTldhUHNG?=
 =?utf-8?B?Nk5VcGlIUlZvanIrUzUxd0s2TXl3S1hIOEJNRm5ZbThOUmRiU3I2allOSzc2?=
 =?utf-8?B?aFptc1p3akZLRy9BNWgwc2RIaTNlS0hrTG1jcGZBZ2RLSDlEZ0IvQTZtSkk3?=
 =?utf-8?B?cWRLMXRDaE8xUW5JbHIyWlUrNGorblIvTG5QVHQ4S0tlZXg2d3VDMDh4M0Ey?=
 =?utf-8?B?RTlXY25zTWE1eC9IUDNCZ3U4enV0QUdzeWEveXZJUExkV2pQRXJsN0xMaVE3?=
 =?utf-8?B?OGJKRDA4SEJGSytJVmlveWdvSTdiL1U0a2IrSGh0Vm95akhaN3ZURGZWcjIz?=
 =?utf-8?B?eGt5aHdHVXVCUGxZckpUTnVSTGZyR2h0UGlvaU9jeXYxUFdTTGd0akdkdktm?=
 =?utf-8?B?djRUNEVscnlWcHMrdXVpa2lzUDZGKytpemFiMTBrZDV6YnZDV2VrQkltZmF1?=
 =?utf-8?B?QzBxZ3RibTMvOVdPbWtKUkYvRmVwSmFVTk5oRGJLdHFGaWZDSHkxWklheU1j?=
 =?utf-8?B?bEkxWjNkcCt3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cm1Qdm01bTZIUC9XcE1sVG53dkZHSFYzaFBva3A5UFJ2RTZqQVZ3SUt2Z0M5?=
 =?utf-8?B?UFE3MSsrTzZaVmZsVzVMNitkWVh0eEd3NDJiSGlPYVRrREFZVTllZllxaEJk?=
 =?utf-8?B?TUhJMEVCUWV1UGVlSEQ4aGx5anhyZ1REdjVhZ2lhTURzUENYQjFTTGt1L1Uw?=
 =?utf-8?B?cHBoTFJxMmRtWlFKNGVwcTdsUUJ1SzI2UlBqK2tsY3JZcEdVeUFoYlh3bDJo?=
 =?utf-8?B?U2t2c05aNkg5cnNkVDVMYkFXYkJnMjhPelYybm5PNUdaQjROZmlXcTlEUm5u?=
 =?utf-8?B?SWN1cjBIYjZ2NVZJLzZsVGkreVMzeHYvNFMyRm9oUWxoSWJGZEFwSTNBc1lL?=
 =?utf-8?B?bXhaSWl1aFUrM2h5WnJxbHdtNEF0d2JVaFhVdUxoWE1KSHNrbFdrTU1wR1lC?=
 =?utf-8?B?UU5NV1k3bm1LbmNoOHNnNTFyRlJoVEh5STRqODBUU0VDemRzT2ZnV3QyWEVC?=
 =?utf-8?B?OWxqV21SeEpUZXIxcVJobytsQ0dCUkd1b1Z1cFloM2ptTnA5cW5XQzZOci9R?=
 =?utf-8?B?UkpZNGgwUnJzLytJWnl0Q0UvbE5maUZ6QUdFTCs4MGM5YlRXK3BEQ3EwSVRP?=
 =?utf-8?B?aDd4djlyYzM2akcvdlZ6Uk1rZ2U0WmlQUGpQT2NhZUxNbzBVR3ErbnlrVWRx?=
 =?utf-8?B?SFdoczVCWUJIclJTTWY2N1krRVJ0SXpBcUpTV3Yvc2VBcmNUUFNNMUNXV0hH?=
 =?utf-8?B?Y2NpcmVMOEUybWtPaHRXTCs3L1c0K29QRFl3S3EyV2doTEkwZXd2QkZLRXdu?=
 =?utf-8?B?WDhSM3A0NThJY044azRwdllwMU5BeWRYR1JpVmJ4UXQyS2lJYVlwZVBkbVpu?=
 =?utf-8?B?aG9JYzZrY3ExQ28rZUt3ZTdOdEFYTGJuM3VzcGp4ZnQrV0VuUWNWY1dkOXVK?=
 =?utf-8?B?RC91TGtrNFh3c3E2TlY5MEZHR2lIY3RYdWFuK2hoVXFudHByVDRCZmVrZXQz?=
 =?utf-8?B?MDEwQkhYZjkwc2pVVURLSE1YUlROL2VGTTdjOTY2bWFMYUx0QUdodUg4QzEv?=
 =?utf-8?B?aWZLRzVVZ0c3ZnpueUM1MUIwNm9XVzZrTy9MVWRwbEZ4K0hmM3UwcmJpL2Y4?=
 =?utf-8?B?Tm1iY1IxQTJXbm9ZYTVKemxxV1p6T2JsakttV20xUEd3eTY0SnRBU1hCWjRy?=
 =?utf-8?B?aFZRMjNDdGs1VER0Q3VpWHdvM0NxOEpoTWVJM2NRQk1EMUQ1NFhoRlQzSmQ1?=
 =?utf-8?B?UWxwZEtCRXlwVWxYdGs1UUVlWnd3NThpMEN1bXVYNUhPb3l1MUpyaG5vZVMw?=
 =?utf-8?B?TlArcmpTUDJVM2lDdzF2YnZRdXQrYkNUcFhTclNaZHpibUZEZkZlYTdheVFt?=
 =?utf-8?B?NXdNSzh5T3l3KzN1d3Q5Y01HdGFNWjlwYjhSMEZHekUvYmEydm14UWNuNlE0?=
 =?utf-8?B?dVUyOVJyMm9hMzdEZGNpWUJ6SmNPU1J2UUJ2eFlML3JuM01YUmYwRTN4cGE2?=
 =?utf-8?B?NjZLbFBVaUJIdWJBSGtIOTRRNC9wNEcyMm1yUDdCVjQ5eGtUL2VKcnp1WjdL?=
 =?utf-8?B?VFZVaUhHbDNtRlRVbTg2QmExdTlVOEVTbDdITnd6cFluUnZvUTgrYU9RY0Ey?=
 =?utf-8?B?L1RzWHJLYlU1VEkvR2xxcjJITHFpb0lMc1hPanZXbkdSaTRpSzMwa1VIZlZV?=
 =?utf-8?B?QjNWWnZMYTd4Y1N0OTRWODVadkhna2NmMWx0dmpUTTI4Y3JHUm5nalEra1Fm?=
 =?utf-8?B?U1hnZk1LSVpaU2dFRzR0bHpCK09VOFhjeTdXN2MxT1Njc2FOR3RtaG82aFl6?=
 =?utf-8?B?VE5MbFVkMjFEYnFnOXZHZmE2dTVXQUxNbjVjVytaRHMrclhGZ0tVcTJCVVBN?=
 =?utf-8?B?UUppNDA0K1RRcnE5VHk4c3E3YWMzT3NjdHlPQXlJWTdGRXV2SitWM1VsdDB6?=
 =?utf-8?B?S3dnWDU0YzJLMDN5eXNGMHN1dDg5OWJacERJdkJ0WkFCVFY2WlNnYkRXdHVl?=
 =?utf-8?B?Y2RBQlYvS1FmT0pIUU52Q1JYTHY5WEI4OGhSWmdqUmlRaHZHbTVXbHpCd3po?=
 =?utf-8?B?RWdoVHA1SjliakJRL2k1Uy9panUzaldXTjgrdmFPTmtLclJGRkFWa3NtUmZi?=
 =?utf-8?B?ekdqZUdKK0R4MXlhQ05XaERhS0c5ZWRqRHlXalV6cEIxK0dvK09mZlJ2UGxD?=
 =?utf-8?Q?a/d+LSqyvW7AYZTQJbdltUUew?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C15FB2A90337647A0A44E307959AA40@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac0b52bd-b07a-4cef-4341-08dde623552c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 11:09:18.3075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LecEwfYBtSbSEx2+AHW3IlTcPCDPBzRvZi8ZFNJ75wN9YPMivqrMnRpoI5Odtm58gLtcKcbHGPXD/H52SyBEkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4999
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDE2OjEzICswNTMwLCBOaWt1bmogQS4gRGFkaGFuaWEgd3Jv
dGU6DQo+IE9uIDgvMjgvMjAyNSA0OjAzIFBNLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyNS0wOC0yOCBhdCAxMjowNyArMDUzMCwgTmlrdW5qIEEuIERhZGhhbmlhIHdyb3RlOg0K
PiA+ID4gDQo+ID4gPiBPbiA4LzI4LzIwMjUgNToxNCBBTSwgSHVhbmcsIEthaSB3cm90ZToNCj4g
PiA+ID4gT24gTW9uLCAyMDI1LTA4LTI1IGF0IDE1OjIwICswMDAwLCBOaWt1bmogQSBEYWRoYW5p
YSB3cm90ZToNCj4gPiA+ID4gPiArCWlmIChwbWwpIHsNCj4gPiA+ID4gPiArCQlzdm0tPnBtbF9w
YWdlID0gc25wX3NhZmVfYWxsb2NfcGFnZSgpOw0KPiA+ID4gPiA+ICsJCWlmICghc3ZtLT5wbWxf
cGFnZSkNCj4gPiA+ID4gPiArCQkJZ290byBlcnJvcl9mcmVlX3Ztc2FfcGFnZTsNCj4gPiA+ID4g
PiArCX0NCj4gPiA+ID4gDQo+ID4gPiA+IEkgZGlkbid0IHNlZSB0aGlzIHllc3RlcmRheS7CoCBJ
cyBpdCBtYW5kYXRvcnkgZm9yIEFNRCBQTUwgdG8gdXNlDQo+ID4gPiA+IHNucF9zYWZlX2FsbG9j
X3BhZ2UoKSB0byBhbGxvY2F0ZSB0aGUgUE1MIGJ1ZmZlciwgb3Igd2UgY2FuIGFsc28gdXNlDQo+
ID4gPiA+IG5vcm1hbCBwYWdlIGFsbG9jYXRpb24gQVBJPw0KPiA+ID4gDQo+ID4gPiBBcyBpdCBp
cyBkZXBlbmRlbnQgb24gSHZJblVzZVdyQWxsb3dlZCwgSSBuZWVkIHRvIHVzZSBzbnBfc2FmZV9h
bGxvY19wYWdlKCkuDQo+ID4gDQo+ID4gU28gdGhlIHBhdGNoIDIgaXMgYWN0dWFsbHkgYSBkZXBl
bmRlbnQgZm9yIFBNTD8NCj4gDQo+IE5vdCByZWFsbHksIGlmIHRoZSBwYXRjaCAyIGlzIG5vdCB0
aGVyZSwgdGhlIDJNQiBhbGlnbm1lbnQgd29ya2Fyb3VuZCB3aWxsIGJlDQo+IGFwcGxpZWQgdG8g
UE1MIHBhZ2UgYWxsb2NhdGlvbi4NCg0KU291bmRzIHRoZXkgYXJlIHJlbGF0ZWQsIGF0IGxlYXN0
Lg0KDQpJIGRvbid0IGhhdmUgaW50ZW50aW9uIHRvIGp1ZGdlIHdoZXRoZXIgcGF0Y2ggMiBzaG91
bGQgYmUgaW4gdGhpcyBzZXJpZXMNCm9yIG5vdCwgbm9yIHdoZXRoZXIgc25wX3NhZmVfYWxsb2Nf
cGFnZV9ub2RlKCkgaXMgdGhlIHJpZ2h0IHBsYWNlIHRvDQp3b3JrYXJvdW5kIHRoZSAyTUIgYWxp
Z25tZW50IGZvciBQTUwgYnVmZmVyLg0KDQpJIGp1c3QgdGhpbmsgaXQncyBnb29kIHRvIHNlZSBz
b21lIHRleHQgZXhwbGFpbmluZyB3aHkgcGF0Y2ggMiBpcyBuZWVkZWQNCmZvciBQTUwgaWYgZXZl
bnR1YWxseSB5b3UgZGVjaWRlIHRvIGtlZXAgaXQgaW4gdGhpcyBzZXJpZXMuDQo=

