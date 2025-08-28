Return-Path: <kvm+bounces-56012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBDDAB3915E
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 04:01:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A81B7C80ED
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89DED24678E;
	Thu, 28 Aug 2025 02:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hsRuzWta"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0006FC5;
	Thu, 28 Aug 2025 02:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756346488; cv=fail; b=h+tl3v6TPzH/vtry49l+99ZjI1EtHjVfouHljLXZFL2eUXMk5WNu76gSaWYRryVB2KdzCRhTOZg17d0+X4HxRNcBsh+pz98nT7S56hhiu6XmQpuUZuPm/jN+IoOP80by4RVJdSkweXrL/Wv5YytJdeTTw0K8VtVq3DMG6pSlBzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756346488; c=relaxed/simple;
	bh=TShJRqnWts8BYoAz/LGTdVgTV6gURkNjRqkCzzOmTEw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kH+uuEn3m3dBKyGk2adyRc37bCSxk1MYukUEk5WkNvU2ErlY/rIVsYrfA1k49AMo6pUhfMEQENQ/50AG8d1yrh/Zxms5PSaYoC1LdxRB3sEc2PtsAdic26YOwtXHoG0MQWM3QMeT6MqnlpangOiZBMv8d4PZyfnnCsXqjbgfaaw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hsRuzWta; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756346487; x=1787882487;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TShJRqnWts8BYoAz/LGTdVgTV6gURkNjRqkCzzOmTEw=;
  b=hsRuzWtad0dzbBatss5+23w+4Z5o+3Jz0PEDXo4JuRd7nXYx/acUwULM
   vitAi7SHYV0IQ/j7RTgrpki9tgC3Gvvh0MYhLjPsVPag8YD+J7OoKswi+
   6rNiIf3R741feR0qPaxOdWPb6oPkYB8wrFiUFbk9AHHWbDOW2JelSOSBc
   OVMdI6x5CLZO0MMgUz7E2df3jq102d+pAylgxK7ldGyljaESnM4OYNsVU
   qZGteHgytrrxfqg6JcvVKxG7KwKpX2vJ3OZjc8Yfpom1Xh8wgC4+pe8Bg
   Xxgk9o4dwOQ/VGWgoWoVkW+bbDXx1KnSrILwKO7zqUW3JhJzqIKL9R2ZP
   Q==;
X-CSE-ConnectionGUID: uAqukNipR2K2M2VKNz76vA==
X-CSE-MsgGUID: zcuyZANrTau07WFacZ6W5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="76206064"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="76206064"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 19:01:26 -0700
X-CSE-ConnectionGUID: zRVM6T7YQB2cupCtdq4SAA==
X-CSE-MsgGUID: Z0ed8ostTHiy00aAfSymIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="174154227"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 19:01:25 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 19:01:25 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 19:01:25 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.41)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 19:01:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xPsjv8+S0+gEhcrRcZpKRpadMQvYt4vGXw0eWUBTJ0fcOjwWCJFqQ2WL9JuUPE6XA4ttEGOJ7GiVcEqZExgmiMjqljrnLllhRtTnexyYH9+/9gQcpmcUYbNrAkTj198AnCJjl7YpyHevE6/EDH/vBMOtqxVlhIfxVSeW/sO+mLsfALubipatcqOKOciRW/DaYGq9yWKwHgVXIwOT5NDQkFyJqN478JhHliMGlHS0KzSEwJVptHbzdzY+5DA3Qa7B6WfiVgIISLyn9Hqrhe1aXz5ORFybBNd2BJlTp1pAlgHgS9yHUoLMqO1PKYAmsabFRVXA9pTLnzd0eed+LHT9RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TShJRqnWts8BYoAz/LGTdVgTV6gURkNjRqkCzzOmTEw=;
 b=ao0F4qdGlBKPADC8aqmjvcBwHgXPrzUqhT4npDLxki6199yp5K1d3JR6ya1RyZF2gydOPa+TRqn3Ks5j4MWgjJOnr64Q7GuzovRX6djRr9jlup2+8fGQEsNG47asNyuVlPbdyAQmAF/FcDTa0+SMvhu3rcE/ocupTm4cjVHC0EhHEfOhhkDji9CUbFfLbjQZT/S5gBTr3HEcAvXFlpkwBi66v0fCrov07bW5PbyM6KsYOVrGs4wDyxZ1tI8o7+2fIwkBT9ONS2eFY4ByOFfQCNxGo3uCsiQxUr+xaVsQQQeFZ+R4OPix61+/W5BILEnlthofHD4duOlFo3X0x5hP/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB9477.namprd11.prod.outlook.com (2603:10b6:8:290::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 28 Aug
 2025 02:01:13 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 02:01:13 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
Subject: Re: [RFC PATCH 04/12] KVM: x86/mmu: Rename kvm_tdp_map_page() to
 kvm_tdp_prefault_page()
Thread-Topic: [RFC PATCH 04/12] KVM: x86/mmu: Rename kvm_tdp_map_page() to
 kvm_tdp_prefault_page()
Thread-Index: AQHcFuZU9Hm9RGRGQkatSrLl2rbm6bR3UXUA
Date: Thu, 28 Aug 2025 02:01:13 +0000
Message-ID: <953ac19b2ff434a3abb3787720fefeef5ceda129.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-5-seanjc@google.com>
In-Reply-To: <20250827000522.4022426-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB9477:EE_
x-ms-office365-filtering-correlation-id: a3ca0e35-7f21-4ef2-49ec-08dde5d6c454
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VnhwMXlLaCtvczc3TlR2S0JUTSt3TlFhdU0wM2tUb1dTUlgxdkJXTEw1Y3ND?=
 =?utf-8?B?a3kyTE1vakZqbjgxS29jTkdTaklzN2pXZzZnaDcwZVBEVUlRMGNwMlE0eVQv?=
 =?utf-8?B?RVRFd3V4NEszNCtwWHh0MWlkSGxsaHpLcFY5L2l1YkVITlBFVTArSm92M0NU?=
 =?utf-8?B?SlBkQ1RmWHZxTnlOdFc3Q0ttdnE1NzBwVWRjdjVZeEpqOHpkU1dVMVlsQnlD?=
 =?utf-8?B?NVZZVlZERUM5dC9EMStNUlgrdTNEcU1xU2FYZWN3eTM2T0dQcmZJd0hJVDln?=
 =?utf-8?B?RHltdzRxV0NGaHlZRVNJWjM1dVptNmdyNWhITzdyekVZUGNwZEhDWGNPZlow?=
 =?utf-8?B?dzMwZ3dTWUFNeEZBeTBibitrTjk1cFovcFRHY0xSOFVCQllQQm1UT3hmb2w2?=
 =?utf-8?B?WWFZN3Z5MjRBcU5XOHlLOTIwd09rV3dIMnN2SFRETkN1UDhBQ0dia3d3QXk5?=
 =?utf-8?B?MWY5cmZqeGl0aUo0YTlZQ0czd0pNZXN4ZUliZWJvdEtrMHJPcGdGOEd2TmMw?=
 =?utf-8?B?T1ZyVXFURE43SlptcjVhTS9oU3VwVmh6eWF3cGFycmhzN2p6c0I1N1V0WmZK?=
 =?utf-8?B?WE10S1NGVzY0TmZzOVlYSHRxbFBqUnYySGxXNE1KQWtwZ1RZa1YwTWw2UGVF?=
 =?utf-8?B?amJ4QzQ0SHg4UTlJSktTejdmVnFYdS85YVdRd3o0K29aajVqOHVBbUZJS1Ax?=
 =?utf-8?B?N0Jadm5NdWllV1JDTDhSN0ExYlZLc2hGeFVMSUplalpOdE1XTENuUXYxWndO?=
 =?utf-8?B?amc2dXdiYzFHaytEaFUzekJkeGFnZzBhQjRzcmI4VStod3kzbDkwdFM3ZUVT?=
 =?utf-8?B?N20xQWl6MWh1NE9TOWFQaFVadWg2Wno1NFFXbkdReWxGQTNraEFDRkVPVE8r?=
 =?utf-8?B?bW9ERXdFcE5vanVoSDR2YlI0Wk9HNnNycGJSMjM4eURYbFN4dmcySWNDRFVW?=
 =?utf-8?B?NHBFU0ljVmM0M0RaVzdRdDlQTHJ4WWlIbXI2aEE5SFFISkZNVGZRZEUyVE15?=
 =?utf-8?B?OGx1Nnk4Q3p6Yng5S1J3WGhUUGNBMWowcVFwMm10Y2J0RVJzSXR4ZFoxQUw4?=
 =?utf-8?B?ZDBCVmoyaUtDZXBST04xL0g3eEVQcjM2MExsU3hJQ2xLd0Q0ZkQ2Y1B0R3I2?=
 =?utf-8?B?WVd6MDdzNVJpNkkzNlpOQ2N6QXRpZDR1c1NKdHVWQko2Z0s3OFpjeHNPL0ZQ?=
 =?utf-8?B?dUgzYzdpb2tKSi9vaFRaVjFsUjJ3bzMzeHdYTTljUC84MWJ4Y29xZXlTaDF4?=
 =?utf-8?B?UUdpcjlMNkhIQitFR1BLckN0SWZ1Wkdmemhsb1REdmxoRHhTMHIyS0N1dWhL?=
 =?utf-8?B?OXVDbEt1S0J0ZmhvRi9nK1V2dkRzdEZDb0hORVBQTDlTL2RsQU9oOXNJOENN?=
 =?utf-8?B?U2tyNzhybWV1eDZocGptRFc1dkp0dTg2TEN6U2tlREMzazNqcVM4bDU4R1VR?=
 =?utf-8?B?Wm9FTVB0ZlRLNTFMYlRkbTdEdmpKaGZseDVlbm9JdHg5M0JEaTJvZzkzS05Y?=
 =?utf-8?B?ZUtWUFBudmVpbHRzK1lPWFozYkcyT0hZQ3JVbmphTHI0ZW9RWlVZU2Y0enMx?=
 =?utf-8?B?NEJ5aDNFUXdWR0IvVW9SYlg1bzBWeDJGWnEvcUs5NDR5by9COXJGeEtzVm9M?=
 =?utf-8?B?MVhYY2E1eTkveVJBSzAycm5haUIrZTF1YnNqYm5vZE12anQvSFBscENYUWxV?=
 =?utf-8?B?NFJvUGllaGJqeEhrdTBUb2NXUTJmRVhwQnp5dTBLck9XNnQ5UzV0WDk1NjBS?=
 =?utf-8?B?dEh1QzFJRUFsUlBzeXhZaEowdldmUmVVTFdXQ2FaUzNlcnpsUFRzTFY1THY1?=
 =?utf-8?B?TVZwMXRQYXB2TklFUVpVK1Q3WGxVeU9HVnlYc01IVW12NktiU1VMcUl3M3dL?=
 =?utf-8?B?SHhOYXE4MVZRWHV4UEQvTGEva0orUUNpVEorRnNDaWxOVUhRZ202K0lBVHhN?=
 =?utf-8?B?a1JhMGtJUTd6aTI4VkFVbFBZNm4rRXBYMkdYSmlwa3ZJd09OazJId21XQjdp?=
 =?utf-8?Q?1JnVRQGbZJWhZbLjyPrgBbCuRQFDsI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2lxYzVpelNjanppRmpKQVFkb0ZoRExJRU1STEIwdlA0MWh2NW9jS0lPN1hH?=
 =?utf-8?B?bVQ0OWtlcUpiNittNlExSTE1WTlQZS9pZmxlUG15bmpXMlRkMGpZL2wxRnd0?=
 =?utf-8?B?WmY1NkJ5aUsxUUxqbzJiOUVzS0JzcmNVMmtsL3BXOUNXR1k5V3VPMGR0NVg2?=
 =?utf-8?B?NnBxQkt2a09seFBLSy9PZi9VK1VZeWRpLzhTNG90WURnalMvSGxHR2gydG1s?=
 =?utf-8?B?WGVEQll6a1BycmI3TUZDaDVnUWdNN2o2UzRoSUhRRGtlNVJxejhmY2dUaUhm?=
 =?utf-8?B?Uk92eXRScStWYVFlZzg1WklBVHB0bHowTFdKSzV6Tkl1TGpNTExtNSsycDZ5?=
 =?utf-8?B?cXVRQVBPRDdKK0cxeWpiSWFzU0l0dUw4RE1DN1JmZ3Uybk9acEtDdEhlb25V?=
 =?utf-8?B?VytURVE2YmJiOEE4UGFYalBvSCs0Mk1naThDbTNjNlA5b3YwZUF6SmQ3RGlk?=
 =?utf-8?B?NjczWnFFUHhmY2FHWWpZWDZuTktqZy80WDFCTlg5UHcvM3hIVU5ZMHZUOHNI?=
 =?utf-8?B?N2hJNVd3NDhWUDg2a1dwcTRoaERpZlFuNkdsUzBjMXFYendVcVpZeUlYOTdr?=
 =?utf-8?B?SStYd0tBUUJ3Y2dJTHAxdisvdlJUSSt6VFZ4cW1GU0lyOXN2ZXQxaUFDWlE4?=
 =?utf-8?B?MFlXWEtDckpjRTZILzlwOEJPcUpwNTJ3d3pWdG1vQnRYTVdrM3R0eDNzQ3Rx?=
 =?utf-8?B?OEpzdjdEbzc3OXh0Vkx2ZXJBcno3SWdVU2FlOEJGYktHcE56L054ZmUxMHh6?=
 =?utf-8?B?L3JrQnpjWVdkb1Vka2pscGxGc3NjME9qYVpueXExcjZ4eXVCZ21BUW43eFlh?=
 =?utf-8?B?d1lGU0V4MTFLQnE0QUhSVWZLdGJUYUp4NlJXczIrQ2VQcld4VWhJQmdPa3FD?=
 =?utf-8?B?dU9BNkt3czBpajBoZldwOXRoL3E5NkFVYjBzcUVIeDlVL2RLdEYyZUhYMlpF?=
 =?utf-8?B?RXRHclc0Wk9yTTR2YXVHREt5RFFUb0N1ajlNb2JqblJOSUhHeWdvRG15M0JU?=
 =?utf-8?B?bzFjbEdtSGJ1cUJrL1lCWkF3STlQTDBLKzN5c0YrTmxKWC83cVUrc2w4WjBh?=
 =?utf-8?B?ZDRLUFNyamJFc0VOZXJXd3JaYldBQlFjaUdUK1RqdExoc0prZWdyZkxSLzBz?=
 =?utf-8?B?Z1lnYWZyaHgvZFNVS2pyWjZZelFKQjcxYkJ3YjgydG1LUFdjeHYrU05XVzBz?=
 =?utf-8?B?ZitmMU5MNmRuZjl5R213MnBJNXM5Ykk3L1ljcUFlQ05NV2tZUi9FTWtHREg2?=
 =?utf-8?B?S1p2djFKaTA3VWZTMUkzZ2hIbUw0aFJUQWlXYUFnYlhYeWFZVWZxbTcwNWRn?=
 =?utf-8?B?d2lLbUFFQ2VNbTV5OGRSMmxmQzk2OHpEaVl4NGthU29GUHBaSDRVYVkwNnFI?=
 =?utf-8?B?UTVBTVNCTC9ybVdSOWZlU3BzSTZaaHZNWTNqMW1uWVJSUVErSG5icDAvTHJH?=
 =?utf-8?B?U05PcnpsVDNjeU4wYmZJTVFGM21XUlhJT0lJVm5nTkV6OXl3dmJJb1VWL29H?=
 =?utf-8?B?TDRHOUd2dVdTWXRSSjJRYmY5YXZwcnd6aURtbGp0MUQ1VGNmOThMelRjekFI?=
 =?utf-8?B?THBkMHlJM2FFd043ZDg5VVEyNS9aM1RZK3hDalJYSDE0V3Fydld2MWNBbTVk?=
 =?utf-8?B?Vk9ZbWNMTGRzdkU5akh3cGtKNCsyb0NrbVdFZW9GTU5NbFdqWmJSK1diUTdH?=
 =?utf-8?B?Z2FqZHhVQW54eWprYUgvNndlZnNPTG1rYVM2NFRyRHFxbUg4V1lyU2hzWXYw?=
 =?utf-8?B?NnE1OTdZazVQM0hZSUVjNVVrUHpDQTdmcjlpSHhqTkJyZ3plVStYRndhSlBQ?=
 =?utf-8?B?QzU5UWZXMkNxMHBGaXhnU0Q5bkZCYWtMS2p2cXVZY3JvOUszOUxiMGVFN3Uw?=
 =?utf-8?B?bEJoUG1pS2kyc2hIejlORlJQUkYwOGh1UXBJODZKWElaNXpzSTNVdC9oem5O?=
 =?utf-8?B?Nk9sM3BRdWE5cjFkR3h5OUhNNEdSSUwvMGx2VFlWOG04N2NzR3RPSHlrclNM?=
 =?utf-8?B?T2wvbW9GU0J4eXp0dVRMUWVoNVQvZnd0U3pYT3FVdGpvYXBLUktsV1Z3Wklu?=
 =?utf-8?B?WE9jWHdqUHFuZmNnVXhQc1ZHYzlhT0VqS0JSdVpaUlNXSHZmSzNSM0dCaDQ4?=
 =?utf-8?B?cWxxckMyN2RhUTl0SWV3YjFnS2xaU3gwbUNjSW05b0N2akI2M3JUUmtBMUtM?=
 =?utf-8?B?Z2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B644E5E468AB074DAB48650D51D29C50@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3ca0e35-7f21-4ef2-49ec-08dde5d6c454
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 02:01:13.5498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DLNupKfABQ9prUjUf6njHEUzQRhu1nTCMm6+UTLzG6yq5flEaocNTmIRYn6N4bO8O1WKluFBTwUwObj6bPouf/1LEp7/QbJ4Jl9zc/Rod/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB9477
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTI2IGF0IDE3OjA1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZW5hbWUga3ZtX3RkcF9tYXBfcGFnZSgpIHRvIGt2bV90ZHBfcHJlZmF1bHRfcGFn
ZSgpIG5vdyB0aGF0IGl0J3MgdXNlZA0KPiBvbmx5IGJ5IGt2bV9hcmNoX3ZjcHVfcHJlX2ZhdWx0
X21lbW9yeSgpLg0KPiANCj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UgaW50ZW5kZWQuDQoNCkkgcmVh
bGl6ZSB5b3UgYXJlIGp1c3QgdHJ5aW5nIHRvIGRvIG1hcC0+cHJlZmF1bHQgaGVyZSwgYnV0ICJw
YWdlIiBzZWVtcw0KcmVkdW5kYW50IG9uY2UgeW91IGhhdmUgInByZWZhdWx0IiBpbiB0aGUgbmFt
ZS4gV2h5IHBhZ2UgaGVyZSB2cyBhbGwgdGhlIG90aGVyDQpmYXVsdCBoYW5kbGVyIGZ1bmN0aW9u
cyB3aXRob3V0IGl0Pw0K

