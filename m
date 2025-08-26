Return-Path: <kvm+bounces-55738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F22E0B359D2
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 12:07:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E26FD1B673F3
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 10:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21E6D3218B0;
	Tue, 26 Aug 2025 10:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mVhuWBM0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33FA2FAC1F
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 10:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756202858; cv=fail; b=olrzeVpso/UEr38m+FolL87IWqPNR/5JUXV3GZPTzddBNLibTmVKJomGMgJo5RJnSm4hCHLt895Rgul/JsdV9s8Ea6HK2WdjRwDA/6wH0U99Lz7n9JO2vdr+yU9Ad+rRZFv12MOpaVXrIXqin+c7SOxTDAp7dgfBs9YlCgbN8f4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756202858; c=relaxed/simple;
	bh=1NXILCWzY7P5WFODcrHU/kqxGUQijRBFpPcb36AJphA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tssYDNga/FvmDuhavuyzxWci+pleonBWLnu6TciLUbLMk2f+V8RJakjGpKujYsyAdWcDoIAn+IWDfYpweRlIzRfkGTPJjtM45iIlKxqEyySmkyWKZeZvmg7ZrF8E2UwyGr0QOoKLaynsRHLpWpBnAFATvqndcrhFPJO4Zptx9oc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mVhuWBM0; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756202857; x=1787738857;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1NXILCWzY7P5WFODcrHU/kqxGUQijRBFpPcb36AJphA=;
  b=mVhuWBM0gKbZSj64rOYnDF9DtTI2XLyQ7n6O39iUG+lRXPcnVaSBqRnf
   v52kF+TYrbhbP6VleE77QOo9+t4cX0jws6fZHphAWYCbT24w+ZjyRyEPz
   ImjTEXmcqXQ/act5r1C+jvdyPUj/hRjCDELH2Vnkm89GuD2/PWMLd22cl
   OEHr5rjzxQ8ecxKolxXMex659ZxRapkHy4vSPy0BPMTbKYV7YU8NchJoB
   S6356poeWiRv9XilxQAionRBgfuO7Qc4WEOFFfBV1lmf75/uvoHk4FXe/
   KEn/2cSsZUwbQJZbOpdd2UvhzDzoDYDUfbYTATaHFYmUGdCp5sT3O4Vln
   g==;
X-CSE-ConnectionGUID: 3YYOrQUeSiOYITRByjYOSg==
X-CSE-MsgGUID: FzqosQPiSQKZzQzOsoKdeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58372994"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58372994"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 03:07:36 -0700
X-CSE-ConnectionGUID: mPmcsUJJRleQBZCfNSguQQ==
X-CSE-MsgGUID: o7gJN1XURPqLilV1qGW/XQ==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 03:07:35 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 03:07:34 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 26 Aug 2025 03:07:34 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.58) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 03:07:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w673cj8MPpr6HDXcmMlAq9Rt9CQpxmlLqhoDKRrC9qF6LUSR4E9EhuWov1CqefB6nV7PVdcYeex+DdnAJ/pwvUXW7mDYkjfteCi1hvLyON9tCosVb0eQvdwdK8q9N5AhOeLhBdtwyu1krQvarE8TEcLqqB3wJ7HsdT/hXo0GJRIdqyIxkkQrlmPtaXPX/AnCde/OQrqoXs+ptRGeYuLf+6PfWpxP+5FNck6PGK5rhcj2hmAN+zGLdgQ79Iq40P/0dKzOCouSge+H2J7wCgIviwMXA+v/klWv6wL0fdNEtHeLmu8OnuvoHEEXqMY9t1fhlOcRGuO/YQs+4cwWvCDFLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1NXILCWzY7P5WFODcrHU/kqxGUQijRBFpPcb36AJphA=;
 b=UX+B2YOQdZhLi0T1087FICJdseznaTbsrVQWXQf19hEy9i1ms4IYu2bWCg7hIF3H9Ni2b/ARJJXtH5sOOx+uZ2FEmPFeZyaj9tocerK59/jN9ZJ0tYG+xqiFIf172cDCxasT2K3EfcEItLaxLv5WFFDpp038+wvLX/Gu9+ovSh+GlCTxkwX0W1wxzl2QXGSg1zIgbpIOJNbHquuibL/qvzM3CwLhAoTDHZOa7Ry8+eyTmNEEwTKNCw/PBvBgBx6uMOGdWmhiJGgmv4CbEdTToKr+sDXj4EuLJ3OnsYEQRPcFEVVnMDuLFvi2wgZWfkBx0VrDYsCWUB156Oh85uJcGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA0PR11MB7881.namprd11.prod.outlook.com (2603:10b6:208:40b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 10:07:32 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 10:07:32 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [RFC PATCH 2/4] KVM: SEV: Skip SNP-safe allocation when
 HvInUseWrAllowed is supported
Thread-Topic: [RFC PATCH 2/4] KVM: SEV: Skip SNP-safe allocation when
 HvInUseWrAllowed is supported
Thread-Index: AQHcFdP714/Q88e1kUqqVYxi9qUV37R0ts2A
Date: Tue, 26 Aug 2025 10:07:31 +0000
Message-ID: <668a279d908bfdac33a0e64838d4276ec43fcce0.camel@intel.com>
References: <20250825152009.3512-1-nikunj@amd.com>
	 <20250825152009.3512-3-nikunj@amd.com>
In-Reply-To: <20250825152009.3512-3-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA0PR11MB7881:EE_
x-ms-office365-filtering-correlation-id: 61b22cf0-2bc7-43f4-636d-08dde4885f32
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y2hEY1VGU0hqcHpma3MrSmpSWGJDSHV6VXpBYXdvWnk1UDltNllTT2NPdWtU?=
 =?utf-8?B?S2lXdDNDOGtMK0RqUFo4VGJzMlRPekQ2OEZvSjNOT3lqdkVTMmVVeHRRUG1w?=
 =?utf-8?B?c1A5MVR3QStTM1ZIdzBpQ1FVb0t0UUh5dlc3THRCWUpZVCtGcElOMEcxT0Mw?=
 =?utf-8?B?TEJBMTNNZ2ZnV0ZnVjdRUnl0VlBSU0pSa3Qrck40RXcvWDFqNzMrVjlGWjdQ?=
 =?utf-8?B?V2ZSYU4rVWlIK3VGbDlUTTdZR1YrSXNjYmJHb29WTEh4QnZ3V1BUSGtxcElE?=
 =?utf-8?B?WC9GbFNWdUUvSjU2THpTOG1EdmtHZElyKzlZNExwT08vS3dVeGlvdmNXZHJa?=
 =?utf-8?B?L04yYWt5Q2oyMTFsTExXNmNBc3RUZFAyeGh4eCt6Q1M4b05zdlJCTTRMNjE0?=
 =?utf-8?B?UzkvZzlLUkRGNFBLdlY2dXozeTE1eGJTRGZkM1d0ejhKRytZeStEK1ZMWUY0?=
 =?utf-8?B?Z3Z3UjNGVEN3RXNNbUtrcU1iR2Rza3ZBcXBaclR2K2Z5YjdYcDBWUWhpNnpz?=
 =?utf-8?B?RjZkME1EbEhNSGdySDJONFlySktadjNwOW5kK2xESEtDb2ZzSXg3VHZWd0c1?=
 =?utf-8?B?Q1dWaFZ3cmhPUFNxWUpzWFRCNVJJVW9JNWtSeUJ1eGRFK0JrZHpvckZVQUR0?=
 =?utf-8?B?dVBwZWFmVCtvaTNGYlVHZ2xnZWNKMklzVHJ5cHBOTVN2NjdESk42blV3eDlr?=
 =?utf-8?B?amdmWXEvby9FYmh3cVJ5SHBId1ZPM2hpM0tocVNQWGZZYWR3bm1CVHpWZGVP?=
 =?utf-8?B?N0xjNnRyNmkzZmt5OGYwZ1BaTTVSQWtob3dvUTNLNFNiQjVqbm9BUzlFeWc5?=
 =?utf-8?B?WXRMbkJBMUF6bmRPUWxnZEJlVFQydjE5aUZCVWlwS0t3UDkxc1hWSUpEK0I0?=
 =?utf-8?B?bTNGZGtMbDRpTnlQSTVja05WcGg3cFIvYldTVVlNNGRCUjRQZ1pzcDhSbFk0?=
 =?utf-8?B?YkQvdTkrOUZ2RTV5V2FWcEZYMWNCV1JFZFhsdFZXL0pEU3VVV0N1VVpHY0ZO?=
 =?utf-8?B?aWRKMkN2RklZNyt3Qm5HaVd6bmNlc3F4Y1V6S1RUdHN1Mm9LNGFyd2tCYWNx?=
 =?utf-8?B?d1Nkd3N3OFpvdkg3S0ljM0VaK1UrNm1UdHZ4OFRJSFRSdmczaW5NRUp5Z2ZN?=
 =?utf-8?B?QTIvT28rc1ZOazFvem1BQ2tMcXZNTzlIWjVBTWZDWThZTEYyWVJ4RXA1THZn?=
 =?utf-8?B?bVd1MEpSRTFFRjlHNEdMaTNtUU0rSjA3OC9KNUhMU0JsMTdkSTYxd2FpQjVt?=
 =?utf-8?B?U3BWVnY4RzlNTS9qTEdPZERmalhZQ0liWW1RZkFUKzBickdXaVdmODMzVVYv?=
 =?utf-8?B?RTdjSjY2cEoyUm1FRytOdjB3cUVYaWxqQVFkTm1GYmszRXpQOTN4ck1RaFEw?=
 =?utf-8?B?ai9mNHZJUWdFZjJGU044RkZoK2pQUE9KSDZZMmRvZlNmUEg0N0djSVpkKzJN?=
 =?utf-8?B?ZmxSbUF5SjNIcGc4b2x3V0pmMmJ5R3lNYTFhNDBuNkMxTndvUG9TU3pTWmx5?=
 =?utf-8?B?cVgvQjVJaGpXNHUwUGNlZE4rNGxVaDVYZzg1OS9oWUN6N3o5NDcwQmNnNEZJ?=
 =?utf-8?B?bkthNXlWbnpmNlNMSDVoeTAvbUxEWG5HRVhyMjBQSjBMSjlycENHcE90UkRz?=
 =?utf-8?B?MXZpNnB3bjF4dnNWbitlOVQvREEzYWNzYVJzSFo4bUN2Y3l5V21PMDhMQURh?=
 =?utf-8?B?NE5ROUtxVlVDN3RTc3ozY1Z2OXgzTkszd3U1YVhKNkZyRmNGengyZ1lKeVZF?=
 =?utf-8?B?ZjJaeDIvOFUzeTFrTVNyYm42UE1hMFQ4OFRIaThSK0I0dHJYTFNLQm9nanJQ?=
 =?utf-8?B?TG5xLytPdnFYczJYVGU5d04xdGVwUmlhWW5HbXNmYjkvaXRyMWdLOHk4L3NZ?=
 =?utf-8?B?OW1aK3JBalNCWHlRQzRpZTYvNGpNSGNZSDBpNUJNNUFUNWZzUHh1N2NOQjgv?=
 =?utf-8?B?NDNzMFBwd1EwbTlTYXE0cmNRMk41QUpEQXM4VnYwdEUydEVqYWw3MU93QUEx?=
 =?utf-8?B?aFkxU1JSa1BRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OUFFQkgzMzI1Z25FSzNodVJPNU8vMUViQk9Nd3ptSW9lTE9OVWMwTE8rM2lz?=
 =?utf-8?B?VDI4VFNEUkVyU0lBZkFsUTdxSzhEUXQySWsxNmtDRk9kVkU0Sk9lRytra0lx?=
 =?utf-8?B?cmRHNVA0ZUdwVWtOS1BDZUszbUo5THhPYTNmT2ExWC95WS9GcjlJM2NWQUdX?=
 =?utf-8?B?YmZ3dHVDMnFaanlqN2hNZmVrL2hXZUR0SUZEMDlFMUcySlUxUlpJTTdSVEo2?=
 =?utf-8?B?NWtHSG85S2NROWp2VUh2M2xsR2FEZjlSbTVHNnpKM3FlTlJNU0M4YktZeFpq?=
 =?utf-8?B?eGZ2NTRNZTFyZWRUSWdoYU5DamxWTVZCVjJOQUNpdjMvbktHWXQxK0FMeFhy?=
 =?utf-8?B?UTY4cEJVdjZHM2wyKzI5TlhENUZmTHJad0hqaGJzRFVGenJlbVJJclg3MEg2?=
 =?utf-8?B?Y3E2ZHJNd21pdnRwSTRSdDd4TUFTaWh3YzRvNUNUT0F0djd3L3dRQlByUC9n?=
 =?utf-8?B?RWM4cmRJclhyTldjclM0T0xNOE9JWlBacWJJNElBcjhVcG1RejRoRFZRWHNh?=
 =?utf-8?B?ZHNpeW5TdkNSVDVIMmN0Vy9FR0huWFJKRzNOWmVtZ1M0VG1UOGVqQSt2QWhz?=
 =?utf-8?B?Y3RxOFZkeWNZbWpmU2JQVFh1cVRQRDBaUmVZc29RQlIyWmNWUmdQVWtPdGEx?=
 =?utf-8?B?dmoxeGFNbkxrZmhTQ3ByU2JOc2Z6eGJPQVpsNGFFdVRGWDdxOUdBK0h1b1Ny?=
 =?utf-8?B?cVBwUFh5anp1RmxiSW9TTHNBNis2M2RtdDBjMHhYeHl0SldibGx0Vk9rSUNC?=
 =?utf-8?B?WWRNd2hqSnJzZjFWK3NKM3JxSEFvYnZLNkNibmhBRkxzZzRoQXlxRVlvd05p?=
 =?utf-8?B?Mk5BU240MmpOVEdPUHJmVmVWUlpTWVRhRS8zRFEzOG5wdDVKL0tzNG56SFNQ?=
 =?utf-8?B?MWg1S0ZscnB0NFpCb2g2NHExL2N0NTJJc3hsSHZPQklQOHVCQzJJWGJOSENt?=
 =?utf-8?B?c0VFNEdNTWxHV3AvSVpEZmFZelREVWxGRndzN3hkV3FDaGZxWWJMNlA2N1Qy?=
 =?utf-8?B?d05Ibnk3Zi84M0xwZHIvckRUTGVVWVNSdTlBMkpZczVvM0JnRmdJSHoyMTcz?=
 =?utf-8?B?M3kxVkRXR2xBYWM2Nk1abDdXYlRNN2VMaUtJcXRIbTJ4TkVQWXNIWVEwSXdE?=
 =?utf-8?B?ek5NV1hpRUdwRDg3VTZlcWRCU05aUkZkOEl1NzZNTWs2TEd3TTZMZ2g4amky?=
 =?utf-8?B?eS9SYkVxVnJHZGkrMXpsOEJkZHdNNWo5ZXkrY0dtb1dOUTNoWHNSQUlTdUJT?=
 =?utf-8?B?Y1hpWG9xd2FadkdHTmltYTgydm9OOEhsNW5VZHJvVFVIbUxLTUhjK0x3V2Fw?=
 =?utf-8?B?YkNlSFltRFBURUwxNUl5Rk5tT2diQUl6b1JIOWs4VVp3NU1tL0tRcVZnWWd2?=
 =?utf-8?B?czdEVWZqbXNiS2JsTnNtOSswWkQxMXdHZm93Um91TjFCT2hVaEw5clZPQXNV?=
 =?utf-8?B?UU02L21zNFJsNU41TUo3WGQ4Rm5KMUJ1bGt3Q05yQmYweEUyQ2poQW84Y2Uz?=
 =?utf-8?B?TWhiTS9pSDBkVFhlQTh3SnVaYmpkbXROY2ExMWZWSlBiNGtQSE9mY0xZL29j?=
 =?utf-8?B?aW83Q1MyMWJQU0puYU0rektCV2lzcHg4c2JLWlhFNVdrbWF1bGxsd09selpB?=
 =?utf-8?B?YldwRFhqVzd4ZjRwdmdURUJDL3MyU0NWdkk1VW5IVndRNDIvbk54ZnFUUjho?=
 =?utf-8?B?dW1SSkh0SFFNN3ZGNkkyNnExK3I0cDgvSkdvcUxheVhiNC9rcmIyUEVtVnRS?=
 =?utf-8?B?bU1vZmM4b1dLRk1uaEZuMVhlZjhxUlJ2RkI1SXNFcjgzaUV2YUZ5dUtzcWRp?=
 =?utf-8?B?b1lVbnNSNnIyWTkyYVpNQjNCVW5sVkgreXV0RHRIZWE2QmFud0Fmc21SN1dt?=
 =?utf-8?B?aFNxbzRUQXoybmRqYktLTUxZZlNDUzNVTEtpWVpBbzhsd0VhQVBxNzZ6WlpR?=
 =?utf-8?B?Uk56NG4xQ3ZSODd1QTExaU1hSHY1eDBMWFhmeml3WWhiTUJvMmI4VURoQVZB?=
 =?utf-8?B?U2lLWDhtNHk4RjRQbTd3TjFXQ2dJTHJVZEVDZjcxZXYxRjhVN2JmcmtkNHE3?=
 =?utf-8?B?RlZraWZTemQrY2RyZzRBSW0yaWtWLzFEUnhDSmMzVjVqdkcxdkRuRjlrRHRP?=
 =?utf-8?Q?dP9EWkfT+wG8WPZFxMO342vGN?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F571C8A8F94F1E4CAB8B6E978CE257CD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61b22cf0-2bc7-43f4-636d-08dde4885f32
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2025 10:07:32.0167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4vkUdUKQEE+M264pybqSzWCwbgZ7vD+MUg4yUiyqq67Gl80zfr+tESI+GoniIUcLpg6seIhEnuZFWxwBbl4uNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7881
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA4LTI1IGF0IDE1OjIwICswMDAwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gV2hlbiBIdkluVXNlV3JBbGxvd2VkIChDUFVJRCA4MDAwMDAxRiBFQVhbMzBdKSBpcyBz
dXBwb3J0ZWQsIHRoZSBDUFUgYWxsb3dzDQo+IGh5cGVydmlzb3Igd3JpdGVzIHRvIGluLXVzZSBw
YWdlcyB3aXRob3V0IFJNUCB2aW9sYXRpb25zLCBtYWtpbmcgdGhlIDJNQg0KPiBhbGlnbm1lbnQg
d29ya2Fyb3VuZCB1bm5lY2Vzc2FyeS4gQ2hlY2sgZm9yIHRoaXMgY2FwYWJpbGl0eSB0byBhdm9p
ZCB0aGUNCj4gYWxsb2NhdGlvbiBvdmVyaGVhZCB3aGVuIGl0J3Mgbm90IG5lZWRlZC4NCg0KQ291
bGQgeW91IGFkZCBzb21lIHRleHQgdG8gZXhwbGFpbiB3aHkgdGhpcyBpcyByZWxhdGVkIHRvIFBN
TD8NCg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBUb20gTGVuZGFja3kgPHRob21hcy5sZW5kYWNreUBh
bWQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBOaWt1bmogQSBEYWRoYW5pYSA8bmlrdW5qQGFtZC5j
b20+DQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL3N2bS9zZXYuYyB8IDMgKystDQo+ICAxIGZpbGUg
Y2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva3ZtL3N2bS9zZXYuYyBiL2FyY2gveDg2L2t2bS9zdm0vc2V2LmMNCj4gaW5k
ZXggMmZiZGViZjc5ZmJiLi5jNTQ3N2VmYzkwYjkgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2
bS9zdm0vc2V2LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3N2bS9zZXYuYw0KPiBAQCAtNDY2Niw3
ICs0NjY2LDggQEAgc3RydWN0IHBhZ2UgKnNucF9zYWZlX2FsbG9jX3BhZ2Vfbm9kZShpbnQgbm9k
ZSwgZ2ZwX3QgZ2ZwKQ0KPiAgCXVuc2lnbmVkIGxvbmcgcGZuOw0KPiAgCXN0cnVjdCBwYWdlICpw
Ow0KPiAgDQo+IC0JaWYgKCFjY19wbGF0Zm9ybV9oYXMoQ0NfQVRUUl9IT1NUX1NFVl9TTlApKQ0K
PiArCWlmICghY2NfcGxhdGZvcm1faGFzKENDX0FUVFJfSE9TVF9TRVZfU05QKSB8fA0KPiArCSAg
ICBjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX0hWX0lOVVNFX1dSX0FMTE9XRUQpKQ0K
PiAgCQlyZXR1cm4gYWxsb2NfcGFnZXNfbm9kZShub2RlLCBnZnAgfCBfX0dGUF9aRVJPLCAwKTsN
Cj4gIA0KPiAgCS8qDQo=

