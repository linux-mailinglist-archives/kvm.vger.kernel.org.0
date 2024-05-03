Return-Path: <kvm+bounces-16501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2312C8BAC18
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 14:10:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 978881F22E45
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 12:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332E0152E11;
	Fri,  3 May 2024 12:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b1WGYq2k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBDD17758;
	Fri,  3 May 2024 12:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714738221; cv=fail; b=c5eUkm2B0pZoTk9NJ/I0+amFd1FzgEFE8AdqdGX9Wi6o8ovU/yOTWOcSTeDhbFGD5pyiuSGriNcBIuLZr3ypWAsUIKFD6Rz5ercUcwfjnouWBlHpAjCbwdzthFHVvbhtWOobWozDMwcUVWC50cHKbNjrRXN12mM32yOstQ1wJvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714738221; c=relaxed/simple;
	bh=zaSdqZY0jKdF106U5lc3VyDsALDgaHALwH/PJDb/QjA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mR5Tkx/5ftrzNhwWWP7fPxZF7WIOogDccFh/dy7UGt0IjLjPoobs0eWFyKe4pAdekzpFizPgeVpBqWvP3SJ5tTSpf93MriDTDcOfdaritU2x7+4W1U5gUyCWKFhB5wp+IPFZVAqIXDhT+zasbd0K5E7njice5d8rUkkTP95rmUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b1WGYq2k; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714738219; x=1746274219;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zaSdqZY0jKdF106U5lc3VyDsALDgaHALwH/PJDb/QjA=;
  b=b1WGYq2kRvprayFmxpPKu2Tyirt3f53BsRy6BclNT9uuWZT/FTcWJV9W
   mDqiILUiZAS/jS4NiiPZc0ZIO9CeHGK7d4vcP7ey5diO7wx/BhfGAowbC
   FcLwh9BzG6qIlWRnq0WijJ7zP3Jav4D0TVfnjAcz72f33mAIzaCZ8TAZJ
   LGclcXweULsba1B2DieET3Q5ECWk+jRxplvDJtDPX+2sGkxjlW0ky9bnL
   AmwtpowJVXFKEWzTd3AWI2Sd1DcbagNEFNOZRGyvbWwXJnbSowzuWN1pn
   pe/12woAAuDs7nIhSOmmKEyO1t0VuL/ACZb006K0kzgVSALLBvsYtbG8f
   A==;
X-CSE-ConnectionGUID: AzH5XEi8T1Kl5Wv5YgFdpA==
X-CSE-MsgGUID: zQHo/oEjTjqsIEzOXMeneQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="10420462"
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="10420462"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2024 05:10:18 -0700
X-CSE-ConnectionGUID: YOtyA04LRluK2BSwkuIgXg==
X-CSE-MsgGUID: tb1TF8dySj+5vfoAXZl1Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="27526625"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 May 2024 05:10:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 3 May 2024 05:10:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 3 May 2024 05:10:17 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 3 May 2024 05:10:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqxnJbOwx2arvvzwAh0wO9fDZNkyaK1Df+N4AVCDHL4zOn3Jk1lCfgjTdEMGkuknzlzM2TLYZfbzvonl37wwp1WLJ8keewGvAJfexacTXkmat3jbHud/ejxqlEQEuPMcNZUHvrnqMCGH5EhqQeR4LrnQ1h2IojEXEcaPMngvCsMzNmkg90E+9w+gUca5b/+Upc7sUlx0Wtil7FtdvzKiSEnANoqgJTVH9lOdsHxIEjYzd41Wzr8ujADP1JwE7sWMNCrg+66Vk3DnXXz7i5wX/7Ya+7gr1g9TZWP6bIoF0oal9z46aEkjquMKJseiY5phahJEUGctid7hIKzvwds5WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zaSdqZY0jKdF106U5lc3VyDsALDgaHALwH/PJDb/QjA=;
 b=D7erB+MOtG5HyvccaeskDfTubJhJMBO0o7wXGMELdbjiJOn5dTH8eil2lP/52PZMiCSouuf69Cp9LtMXJVA8ZhrSXJcqGwBxL7vNGHGmfbJU3S9DlDnySBXX7vn3mTieZvO9ormDJ66x5BJwqTZ+XnjwkIm/clnMHQwc28e3axWcq8yLl8RjraEMbUrRLv+l+st9pSQm1ly6ODdsZXW8seiHurmIaalgNirBKmuPPzHft5/IMNaVjiabKbRq00/ySBe17KWqh7solAA8sRbseIRzMzy5biO3PDA4/5E/nSzgPNUQCYo+08vPoD+yQwBiBJ0RdcLe0FHpDXJnojYIqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB6002.namprd11.prod.outlook.com (2603:10b6:208:386::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.30; Fri, 3 May
 2024 12:10:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.029; Fri, 3 May 2024
 12:10:15 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 4/5] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Topic: [PATCH 4/5] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Index: AQHaa8JL7v9VUJLZkEWqE5TMIeieHbGFB4kAgAAPaACAALc+gA==
Date: Fri, 3 May 2024 12:10:15 +0000
Message-ID: <16a8d8dc15b9afd6948a4f3913be568caeff074b.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <17f1c66ae6360b14f175c45aa486f4bdcf6e0a20.1709288433.git.kai.huang@intel.com>
	 <c4f63ccb75dea5f8d62ec0fef928c08e5d4d632e.camel@intel.com>
	 <45eb11ba-8868-4a92-9d02-a33f4279d705@intel.com>
In-Reply-To: <45eb11ba-8868-4a92-9d02-a33f4279d705@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB6002:EE_
x-ms-office365-filtering-correlation-id: 2243ce24-add0-4ec0-0866-08dc6b69fe03
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Q2phK2N1Nkdvb3pDVTJhc3lsOVpMMjFBcVZnelRCV2ptWlJ6bDZOQ0hZOEJH?=
 =?utf-8?B?eDlMQXhib2JrYi94eDhBZ1pmNDdXeXRMWnRNZ2Z6NDRQd2oyQWZWNUcwTWxG?=
 =?utf-8?B?RWxIR3BxWDVPdERUOUtGUExhclA0VHMwbE12QWIvM01tenBoalNzSXc4c2tr?=
 =?utf-8?B?UjBMWTBwRGNaRFlqVTcwWU5TdjRyQXVvZk0venpKbVJ6ZFh1SnlzYXRxMWFP?=
 =?utf-8?B?bzlNWER2ZmYrWVVLTXMyemhBVGNRU2gvSVNmTWpuV28yZFZ3R1YwQmJQcmVV?=
 =?utf-8?B?QTZaakRjcFYxZTFVNVZxVUsza0ZJZkVhb3Q4dTE2U3Q0OXExeGdBUGpVYWFn?=
 =?utf-8?B?SzlobGQ0Q3pVelhjSXlVSTVOdUx3MEFzZTBuOHZmbjRQYWVjV1lvenBXZHVa?=
 =?utf-8?B?R1dSSkNLUkRaekQ3MUgxQTNBR1IxZEFhcm9IaFF0RVI1VU1LZHJwMWRkN2ln?=
 =?utf-8?B?N25MeFdLbXBMZVNhb3Z0dXNsbE91OTJFbXJBakljdmF2K05XWWlKcjJpNzRo?=
 =?utf-8?B?ZC9tdFNOQy9CbGtrRWZyVFFhcmFqcjZQWWxHT3Z4RW5tNzdNaTk5cGdPQzlk?=
 =?utf-8?B?Rm1EWHR3L1cxcXVXd1F5OU9yMlpFbnBxZjJKbG9VV24velJNWFlCY1VENmtp?=
 =?utf-8?B?d1phaEd4cnZVczMvd3ZWbWZJOFBJazAwSHVuc1BRekhHL2NRb2VvelpYQU0x?=
 =?utf-8?B?MGt6TVc4cWFSMFpVNVJmMHlyR3F0c3UvRnFDU2dsNlFaTlRYVmpqZmFpL2xJ?=
 =?utf-8?B?ZWtnRTYycjYxMHMrSThBcnVXNmVqSVp1VVg3OS9UZkdwTUxyQVduRitQaFFr?=
 =?utf-8?B?cjF2S1JmRVdpVkJDSjFvaTRTbGo4WUh6RWQ2cjh2aVUyYXYzSkRaUmRtNkpM?=
 =?utf-8?B?WS9JdVhDSitWQ2tJZ1VudklKaUh3YUhsMFZ0NUJQNGNkRVozUkpWa1pUa2N4?=
 =?utf-8?B?aFFRajh3SWFITUQwektyYU1FSDhUWlprYkE0SkhHM2ZVcm9ZQWd2NVBVQVlN?=
 =?utf-8?B?ZTlLU1RzaEltenV0d2V1N2ZCVWxpNDY1dXdiTE5sT1pFaFFicGw2ZUREMWNT?=
 =?utf-8?B?SnhhWXQzaDA3aDVDdVdMTm0zQmNBTUZKYXhHN1RzZ0tNZmZjMVoxOXpuNHV5?=
 =?utf-8?B?OTJIUUdWUzVqRTBiSHc2VFoya2hoUnk1T09WMHdDMXNIT2tVMFZuRWtOY0VD?=
 =?utf-8?B?VFdtVDNQalo1VTdpNWpkK0NHa2xCZTRJRUVPU1AzUnRFU0Z0QUsrcUp1dnRi?=
 =?utf-8?B?REVYR2dZOWQ5REpJcnMvRStvVFc0WVJzVGdRNzN0ZXVmWkU4MG1ObFZxQnVI?=
 =?utf-8?B?QW9nODg3ZDcxVE1iNWloNGtwdVlrbU9Ib1ZoelN5NzIzRW14UXJxb3k4TjZv?=
 =?utf-8?B?ZEdrWldiU2N3UmxaSGIyK2FOaURtK1pocktjaEMvcW15SU96ci84WWxJMnll?=
 =?utf-8?B?d1VrR2xmWmNuWU43eFZpOHpibW95YXFtUWp6c2NWVmI3N2xDWTVHMFRheFZh?=
 =?utf-8?B?c294WnBTeGUweFlGQ3RVWWxrb0pPZ1lJVzNDSFdyUlhpL1Q0SGtqN1BUSlR3?=
 =?utf-8?B?aGJjcE5JSHdnT0FGYnM3bHNkRWE3djNQbmhIdWtYcEJ0VlRmOTRVL3lJa3FH?=
 =?utf-8?B?d2pHcVNoU2g0aUhVWURoWnM2eVJpenBNU0pSTS9GT1l2K1JFdU1lbFhQR2dD?=
 =?utf-8?B?Ync2bmRuODd5MmY4R3hkUE11T01TcXBNSk5JN1lva3VDL092TlVoVjZ3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ukdtb1lvWGphMzZ5aVpTUkdkSnJmQXZ6aldXMWdpN1Bta1Jjbi9CbGpUdnp0?=
 =?utf-8?B?ZWhadWREVmt6RmttYXMreGNLOEl3eWFINXZ6bkZYZk5JVGZ4elBrd3hRYzdW?=
 =?utf-8?B?UU9FWmdHdU50NnRXN3I0YkwvUEp0b2J3K3F3MTJtRU50ZHltN3hzTk5FRHk5?=
 =?utf-8?B?dGpDbmY1MkdXQ29zdlBpaXpRNEd5b1laK0k2eEoxWjRsZFFaTi9GaXdpanB6?=
 =?utf-8?B?QkczekVYQ3V3WXFFYUZ3b3BWOW0rNTJvNmhpWVJBMDJ3MkJCQ283elNpSTBD?=
 =?utf-8?B?L3o3Qm02b0dJTjBwdFNDU0ttTVJmeXpMVUlUVVRLQjRDT2diY0dHN2xDTmNH?=
 =?utf-8?B?aW1HSGt2UFhSUFZ1djFDZ1VZajk2TEpnSm9lVDVzbE5RamdIcTIrTjNMczgr?=
 =?utf-8?B?RzlKaXV6Tkh0Rk52bDhxQko4SVN6dlp0OGxrNFBMSGprZXVuOWRtSjhlNFVN?=
 =?utf-8?B?NTh2SkhialA4NElZWjRrMGxVZFdJNC9NaDM3TndOVUc2NW1SVzJnNmo0S1c0?=
 =?utf-8?B?Umc3Umg2d1Zzbk83WW55aHQ3L2ZYNDVVaTR1L015d3pMMytrNTI3V3ZwTTds?=
 =?utf-8?B?TStEMDV1L3dTZ0ltamNkdm84ODVDN0lOT0lNZjVheTZoRVU2VDZjRkpSa0xM?=
 =?utf-8?B?RWpBSHRkdDd4d1pjaDBQY3ZOS0lCalF2dk5JemJpNEJMSTVXZ0pabEhKZmZu?=
 =?utf-8?B?QUNSaCs0Rnk4WmtDbTFRUmh6M01keHkzN243Q1d3VlBUY09ucUhvd3AyWEM5?=
 =?utf-8?B?OWlsSHA2OVY4Y0Y3YzN3Y2ZvVC83Y2RzWHY5b1N6bmNkc2REbHFqTUx5T1ND?=
 =?utf-8?B?QVZiUEYrczBuWmZUaUhyZW1ETDQ1U3dJdUo5WGUvR1BkdUQ3bHpxYVlRYnVD?=
 =?utf-8?B?UWk4V0hGRXJvM2hOVWh1VGk3TUdXelVNWmRuellWRHM1aEpyY1N1K2xhK25Y?=
 =?utf-8?B?R2ZDWVN3V0xwdU1MUFl4a2RPbWc2bmNscTExZkpLQkYvem9TSnNibDdNVmJF?=
 =?utf-8?B?TG5rWWR4anNGa3gyN1JWMVlIWHlpbkJxU0syTUxGYUZTTDVZNE16dWlJQ1JG?=
 =?utf-8?B?TkdtcWF2Z3J6RjhSekx5NWdrRzNCbDA1YjJHUTVmRnEyTlBrY2xsbnRkQkRj?=
 =?utf-8?B?aXphTUlhOE1rN1cvVkg0M2FieG1tSWlSQ2Z2d1B3WUsyYjcvNGZuZVdpQ0JM?=
 =?utf-8?B?OXNBNTZBWTJxU3ZUNU52d3gwdGJRUUIyeWVXalc1dkZ4RjM4b1BSdEtQaytH?=
 =?utf-8?B?Y000RkJCOVJHVjlKSEJoL0Y5S1RsS1NheGg4bmhkZXpraWZtVm81Um4vbUJu?=
 =?utf-8?B?bzdDV1laVzNJc1Z2eXpqTGFGQU9OTy9ndGREbDBzenN6d2hjc0p4cXRTSGpJ?=
 =?utf-8?B?Z1NtdXNvTHdscDdCZnlMMXlyQS9GQk55VU4rYXlZNTlYTGExMm81dFFBdnFK?=
 =?utf-8?B?dlNwQk02VnJUeGJHV0dhSjVZZFY3TTFrNjEwMXdkSExrZzI4Nkt3NjIwY2Vq?=
 =?utf-8?B?djJCTnBvNjZ6QWxITGliLytYd2sxNjBZK3pqRWMzdkhRMDFaemYzdjA5SHMz?=
 =?utf-8?B?K0RKdldrTmlXRk91OVBLZUpTb3Myb3lZenVyUUJ5TEN6eW4zRUxtZ0dVcjNQ?=
 =?utf-8?B?bkxHMElwR1RESk5TR2tDSUgzTE14bFFOSjMyOG81cWlZUGZkSG95eGJ4MVhV?=
 =?utf-8?B?N21hYzNESFBJYTF2WFZ4b3ZrbGV3ZWFGNGpiKzE3WjF1VENudHJWeWVnZDB0?=
 =?utf-8?B?SnlZcnJ2NVRCUVc5NzhSUngxMlhTZjJKalYrMmR3bUZTWjdNOEJLdWFwZzhJ?=
 =?utf-8?B?dkQzckdNd1JaeE84K0tvdTBHSVo3TlBPR0w4N1B6clVxdkNCNmI4aXdmbE8x?=
 =?utf-8?B?dG1IUytwb0puK2E5cWJ3dTUzWFRVRU5odUZYZnEvajYzVnJqYjdyNWVaRXNO?=
 =?utf-8?B?d1RTVjFvZEJvQnRoV0JFNjlSNTl5c1ExREM3TFkvS3VBZ0FBU2QySzBOYzhL?=
 =?utf-8?B?QjIyeUR5UDdvMlpRVUt0MmpzMnBJdDJaZVJBcm1ZZXpHR05rMXVCelZvVmxK?=
 =?utf-8?B?eCtvYkVMTzFReGhDUkFLNjdRazBXV0JtTDl3aWNFN2J3bllqL09QelRjdGRY?=
 =?utf-8?Q?yYP/9ljTYQz3lM7xwXWN3owQ9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F0BEA9A34E1B24282449F3A04386913@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2243ce24-add0-4ec0-0866-08dc6b69fe03
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2024 12:10:15.6516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OXE3YU78H8K3tCTCDSFiXrLgnwXx0KDlhyKSi7t8ozAUxkwn+0blgOH09P2vrpcAcOlsjUlX7HPcjusoD0A/EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6002
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTAzIGF0IDEzOjE0ICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAN
Cj4gT24gMy8wNS8yMDI0IDEyOjE5IHBtLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90ZToNCj4gPiBP
biBTYXQsIDIwMjQtMDMtMDIgYXQgMDA6MjAgKzEzMDAsIEthaSBIdWFuZyB3cm90ZToNCj4gPiA+
IEZvciBub3cgdGhlIGtlcm5lbCBvbmx5IHJlYWRzIFRETVIgcmVsYXRlZCBnbG9iYWwgbWV0YWRh
dGEgZmllbGRzIGZvcg0KPiA+ID4gbW9kdWxlIGluaXRpYWxpemF0aW9uLsKgIEFsbCB0aGVzZSBm
aWVsZHMgYXJlIDE2LWJpdHMsIGFuZCB0aGUga2VybmVsDQo+ID4gPiBvbmx5IHN1cHBvcnRzIHJl
YWRpbmcgMTYtYml0cyBmaWVsZHMuDQo+ID4gPiANCj4gPiA+IEtWTSB3aWxsIG5lZWQgdG8gcmVh
ZCBhIGJ1bmNoIG9mIG5vbi1URE1SIHJlbGF0ZWQgbWV0YWRhdGEgdG8gY3JlYXRlIGFuZA0KPiA+
ID4gcnVuIFREWCBndWVzdHMuwqAgSXQncyBlc3NlbnRpYWwgdG8gcHJvdmlkZSBhIGdlbmVyaWMg
bWV0YWRhdGEgcmVhZA0KPiA+ID4gaW5mcmFzdHJ1Y3R1cmUgd2hpY2ggc3VwcG9ydHMgcmVhZGlu
ZyBhbGwgOC8xNi8zMi82NCBiaXRzIGVsZW1lbnQgc2l6ZXMuDQo+ID4gPiANCj4gPiA+IEV4dGVu
ZCB0aGUgbWV0YWRhdGEgcmVhZCB0byBzdXBwb3J0IHJlYWRpbmcgYWxsIHRoZXNlIGVsZW1lbnQg
c2l6ZXMuDQo+ID4gDQo+ID4gSXQgbWFrZXMgaXQgc291bmQgbGlrZSBLVk0gbmVlZHMgOCBiaXQg
ZmllbGRzLiBJIHRoaW5rIGl0IG9ubHkgbmVlZHMgMTYgYW5kIDY0Lg0KPiA+IChuZWVkIHRvIHZl
cmlmeSBmdWxseSkgQnV0IHRoZSBjb2RlIHRvIHN1cHBvcnQgdGhvc2UgY2FuIGJlIHNtYWxsZXIg
aWYgaXQncw0KPiA+IGdlbmVyaWMgdG8gYWxsIHNpemVzLg0KPiA+IA0KPiA+IEl0IG1pZ2h0IGJl
IHdvcnRoIG1lbnRpb25pbmcgd2hpY2ggZmllbGRzIGFuZCB3aHkgdG8gbWFrZSBpdCBnZW5lcmlj
LiBUbyBtYWtlDQo+ID4gc3VyZSBpdCBkb2Vzbid0IGNvbWUgb2ZmIGFzIGEgcHJlbWF0dXJlIGlt
cGxlbWVudGF0aW9uLg0KPiANCj4gSG93IGFib3V0Og0KPiANCj4gRm9yIG5vdyB0aGUga2VybmVs
IG9ubHkgcmVhZHMgVERNUiByZWxhdGVkIGdsb2JhbCBtZXRhZGF0YSBmaWVsZHMgZm9yDQo+IG1v
ZHVsZSBpbml0aWFsaXphdGlvbi4gIEFsbCB0aGVzZSBmaWVsZHMgYXJlIDE2LWJpdHMsIGFuZCB0
aGUga2VybmVsDQo+IG9ubHkgc3VwcG9ydHMgcmVhZGluZyAxNi1iaXRzIGZpZWxkcy4NCj4gDQo+
IEtWTSB3aWxsIG5lZWQgdG8gcmVhZCBhIGJ1bmNoIG9mIG5vbi1URE1SIHJlbGF0ZWQgbWV0YWRh
dGEgdG8gY3JlYXRlIGFuZA0KPiBydW4gVERYIGd1ZXN0cywgYW5kIEtWTSB3aWxsIGF0IGxlYXN0
IG5lZWQgdG8gYWRkaXRpb25hbGx5IGJlIGFibGUgdG8gDQo+IHJlYWQgNjQtYml0IG1ldGFkYXRh
IGZpZWxkcy4NCj4gDQo+IEZvciBleGFtcGxlLCB0aGUgS1ZNIHdpbGwgbmVlZCB0byByZWFkIHRo
ZSA2NC1iaXQgQVRUUklCVVRFU19GSVhFRHswfDF9IA0KPiBmaWVsZHMgdG8gZGV0ZXJtaW5lIHdo
ZXRoZXIgYSBwYXJ0aWN1bGFyIGF0dHJpYnV0ZSBpcyBsZWdhbCB3aGVuIA0KPiBjcmVhdGluZyBh
IFREWCBndWVzdC4gIFBsZWFzZSBzZWUgJ2dsb2JhbF9tZXRhZGF0YS5qc29uIGluIFsxXSBmb3Ig
bW9yZSANCj4gaW5mb3JtYXRpb24uDQo+IA0KPiBUbyByZXNvbHZlIHRoaXMgb25jZSBmb3IgYWxs
LCBleHRlbmQgdGhlIGV4aXN0aW5nIG1ldGFkYXRhIHJlYWRpbmcgY29kZSANCj4gdG8gcHJvdmlk
ZSBhIGdlbmVyaWMgbWV0YWRhdGEgcmVhZCBpbmZyYXN0cnVjdHVyZSB3aGljaCBzdXBwb3J0cyBy
ZWFkaW5nIA0KPiBhbGwgOC8xNi8zMi82NCBiaXRzIGVsZW1lbnQgc2l6ZXMuDQo+IA0KPiBbMV0g
aHR0cHM6Ly9jZHJkdjIuaW50ZWwuY29tL3YxL2RsL2dldENvbnRlbnQvNzk1MzgxDQo+IA0KDQpB
cyByZXBsaWVkIHRvIHRoZSBwYXRjaCA1LCBpZiB3ZSB3YW50IHRvIG9ubHkgZXhwb3J0IG9uZSBB
UEkgYnV0IG1ha2UgdGhlDQpvdGhlciBhcyBzdGF0aWMgaW5saW5lLCB3ZSBuZWVkIHRvIGV4cG9y
dCB0aGUgb25lIHdoaWNoIHJlYWRzIGEgc2luZ2xlDQptZXRhZGF0YSBmaWVsZCwgYW5kICBtYWtl
IHRoZSBvbmUgd2hpY2ggcmVhZHMgbXVsdGlwbGUgYXMgc3RhdGljIGlubGluZS4NCg0KQWZ0ZXIg
aW1wbGVtZW50aW5nIGl0LCBpdCB0dXJucyBvdXQgdGhpcyB3YXkgaXMgcHJvYmFibHkgc2xpZ2h0
bHkgYmV0dGVyOg0KDQpUaGUgbmV3IGZ1bmN0aW9uIHRvIHJlYWQgc2luZ2xlIGZpZWxkIGNhbiBu
b3cgYWN0dWFsbHkgd29yayB3aXRoDQondTgvdTE2L3UzMi91NjQnIGRpcmVjdGx5Og0KDQogIHUx
NiBmaWVsZF9pZDFfdmFsdWU7DQogIHU2NCBmaWVsZF9pZDJfdmFsdWU7DQogIA0KICByZWFkX3N5
c19tZWRhdGFfc2luZ2xlKGZpZWxkX2lkMSwgJmZpZWxkX2lkMV92YWx1ZSk7DQogIHJlYWRfc3lz
X21ldGFkYV9zaW5nbGUoZmllbGRfaWQyLCAmZmllbGRfaWQyX3ZhbHVlKTsNCg0KUGxlYXNlIGhl
bHAgdG8gcmV2aWV3IGJlbG93IHVwZGF0ZWQgcGF0Y2g/DQoNCldpdGggaXQsIHRoZSBwYXRjaCA1
IHdpbGwgb25seSBuZWVkIHRvIGV4cG9ydCBvbmUgYW5kIHRoZSBvdGhlciBjYW4gYmUNCnN0YXRp
YyBpbmxpbmUuDQoNCi0tLS0tLS0tLS0tLQ0KDQpGb3Igbm93IHRoZSBrZXJuZWwgb25seSByZWFk
cyBURE1SIHJlbGF0ZWQgZ2xvYmFsIG1ldGFkYXRhIGZpZWxkcyBmb3INCm1vZHVsZSBpbml0aWFs
aXphdGlvbi4gIEFsbCB0aGVzZSBmaWVsZHMgYXJlIDE2LWJpdHMsIGFuZCB0aGUga2VybmVsDQpv
bmx5IHN1cHBvcnRzIHJlYWRpbmcgMTYtYml0cyBmaWVsZHMuDQoNCktWTSB3aWxsIG5lZWQgdG8g
cmVhZCBhIGJ1bmNoIG9mIG5vbi1URE1SIHJlbGF0ZWQgbWV0YWRhdGEgdG8gY3JlYXRlIGFuZA0K
cnVuIFREWCBndWVzdHMsIGFuZCBLVk0gd2lsbCBhdCBsZWFzdCBuZWVkIHRvIGFkZGl0aW9uYWxs
eSByZWFkIDY0LWJpdA0KbWV0YWRhdGEgZmllbGRzLg0KDQpGb3IgZXhhbXBsZSwgdGhlIEtWTSB3
aWxsIG5lZWQgdG8gcmVhZCB0aGUgNjQtYml0IEFUVFJJQlVURVNfRklYRUR7MHwxfQ0KZmllbGRz
IHRvIGRldGVybWluZSB3aGV0aGVyIGEgcGFydGljdWxhciBhdHRyaWJ1dGUgaXMgbGVnYWwgd2hl
bg0KY3JlYXRpbmcgYSBURFggZ3Vlc3QuICBQbGVhc2Ugc2VlICdnbG9iYWxfbWV0YWRhdGEuanNv
biBpbiBbMV0gZm9yIG1vcmUNCmluZm9ybWF0aW9uLg0KDQpUbyByZXNvbHZlIHRoaXMgb25jZSBm
b3IgYWxsLCBleHRlbmQgdGhlIGV4aXN0aW5nIG1ldGFkYXRhIHJlYWRpbmcgY29kZQ0KdG8gcHJv
dmlkZSBhIGdlbmVyaWMgbWV0YWRhdGEgcmVhZCBpbmZyYXN0cnVjdHVyZSB3aGljaCBzdXBwb3J0
cyByZWFkaW5nDQphbGwgOC8xNi8zMi82NCBiaXRzIGVsZW1lbnQgc2l6ZXMuDQoNClsxXSBodHRw
czovL2NkcmR2Mi5pbnRlbC5jb20vdjEvZGwvZ2V0Q29udGVudC83OTUzODENCg0KU2lnbmVkLW9m
Zi1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KUmV2aWV3ZWQtYnk6IEtpcmls
bCBBLiBTaHV0ZW1vdiA8a2lyaWxsLnNodXRlbW92QGxpbnV4LmludGVsLmNvbT4NCi0tLQ0KIGFy
Y2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyB8IDUxICsrKysrKysrKysrKysrKysrKysrKystLS0t
LS0tLS0tLS0tLS0NCiBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmggfCAgMyArKy0NCiAyIGZp
bGVzIGNoYW5nZWQsIDMzIGluc2VydGlvbnMoKyksIDIxIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0t
Z2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYvdmlydC92bXgvdGR4
L3RkeC5jDQppbmRleCBlYjIwOGRhNGZmNjMuLmU4YjhmNmNhNzAyNiAxMDA2NDQNCi0tLSBhL2Fy
Y2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KKysrIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3Rk
eC5jDQpAQCAtMjcxLDIzICsyNzEsMjIgQEAgc3RhdGljIGludCByZWFkX3N5c19tZXRhZGF0YV9m
aWVsZCh1NjQgZmllbGRfaWQsIHU2NA0KKmRhdGEpDQogICAgICAgIHJldHVybiAwOw0KIH0NCg0K
LXN0YXRpYyBpbnQgcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQxNih1NjQgZmllbGRfaWQsDQotICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW50IG9mZnNldCwNCi0gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB2b2lkICpzdGJ1ZikNCisvKg0KKyAqIFJlYWQgYSBz
aW5nbGUgZ2xvYmFsIG1ldGFkYXRhIGZpZWxkIGJ5IHRoZSBnaXZlbiBmaWVsZCBJRCwgYW5kIGNv
cHkNCisgKiB0aGUgZGF0YSBpbnRvIHRoZSBidWYgcHJvdmlkZWQgYnkgdGhlIGNhbGxlci4gIFRo
ZSBzaXplIG9mIHRoZSBjb3BpZWQNCisgKiBkYXRhIGlzIGRlY29kZWQgZnJvbSB0aGUgbWV0YWRh
dGEgZmllbGQgSUQuICBUaGUgY2FsbGVyIG11c3QgcHJvdmlkZQ0KKyAqIGVub3VnaCBzcGFjZSBm
b3IgdGhlIGJ1ZiBhY2NvcmRpbmcgdG8gdGhlIG1ldGFkYXRhIGZpZWxkIElELg0KKyAqLw0KK3N0
YXRpYyBpbnQgcmVhZF9zeXNfbWV0YWRhdGFfc2luZ2xlKHU2NCBmaWVsZF9pZCwgdm9pZCAqYnVm
KQ0KIHsNCi0gICAgICAgdTE2ICpzdF9tZW1iZXIgPSBzdGJ1ZiArIG9mZnNldDsNCiAgICAgICAg
dTY0IHRtcDsNCiAgICAgICAgaW50IHJldDsNCg0KLSAgICAgICBpZiAoV0FSTl9PTl9PTkNFKE1E
X0ZJRUxEX0lEX0VMRV9TSVpFX0NPREUoZmllbGRfaWQpICE9DQotICAgICAgICAgICAgICAgICAg
ICAgICBNRF9GSUVMRF9JRF9FTEVfU0laRV8xNkJJVCkpDQotICAgICAgICAgICAgICAgcmV0dXJu
IC1FSU5WQUw7DQotDQogICAgICAgIHJldCA9IHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkKGZpZWxk
X2lkLCAmdG1wKTsNCiAgICAgICAgaWYgKHJldCkNCiAgICAgICAgICAgICAgICByZXR1cm4gcmV0
Ow0KDQotICAgICAgICpzdF9tZW1iZXIgPSB0bXA7DQorICAgICAgIG1lbWNweShidWYsICZ0bXAs
IE1EX0ZJRUxEX0JZVEVTKGZpZWxkX2lkKSk7DQoNCiAgICAgICAgcmV0dXJuIDA7DQogfQ0KQEAg
LTMwMSw2ICszMDAsMjcgQEAgc3RydWN0IGZpZWxkX21hcHBpbmcgew0KICAgICAgICB7IC5maWVs
ZF9pZCA9IE1EX0ZJRUxEX0lEXyMjX2ZpZWxkX2lkLCAgICAgICAgICBcDQogICAgICAgICAgLm9m
ZnNldCAgID0gb2Zmc2V0b2YoX3N0cnVjdCwgX21lbWJlcikgfQ0KDQorLyoNCisgKiBSZWFkIG11
bHRpcGxlIGdsb2JhbCBtZXRhZGF0YSBmaWVsZHMgaW50byBhIHN0cnVjdHVyZSBhY2NvcmRpbmcg
dG8gYQ0KKyAqIG1hcHBpbmcgdGFibGUgb2YgbWV0YWRhdGEgZmllbGQgSURzIHRvIHRoZSBzdHJ1
Y3R1cmUgbWVtYmVycy4gIFdoZW4NCisgKiBidWlsZGluZyB0aGUgdGFibGUsIHRoZSBjYWxsZXIg
bXVzdCBtYWtlIHN1cmUgdGhlIHNpemUgb2YgZWFjaA0KKyAqIHN0cnVjdHVyZSBtZW1iZXIgbWF0
Y2hlcyB0aGUgc2l6ZSBvZiBjb3JyZXNwb25kaW5nIG1ldGFkYXRhIGZpZWxkLg0KKyAqLw0KK3N0
YXRpYyBpbnQgcmVhZF9zeXNfbWV0YWRhdGFfbXVsdGkoY29uc3Qgc3RydWN0IGZpZWxkX21hcHBp
bmcgKmZpZWxkcywNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW50IG5yX2Zp
ZWxkcywgdm9pZCAqc3RidWYpDQorew0KKyAgICAgICBpbnQgaSwgcmV0Ow0KKw0KKyAgICAgICBm
b3IgKGkgPSAwOyBpIDwgbnJfZmllbGRzOyBpKyspIHsNCisgICAgICAgICAgICAgICByZXQgPSBy
ZWFkX3N5c19tZXRhZGF0YV9zaW5nbGUoZmllbGRzW2ldLmZpZWxkX2lkLA0KKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBmaWVsZHNbaV0ub2Zmc2V0ICsgc3RidWYpOw0KKyAg
ICAgICAgICAgICAgIGlmIChyZXQpDQorICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gcmV0
Ow0KKyAgICAgICB9DQorDQorICAgICAgIHJldHVybiAwOw0KK30NCisNCiAjZGVmaW5lIFREX1NZ
U0lORk9fTUFQX1RETVJfSU5GTyhfZmllbGRfaWQsIF9tZW1iZXIpICAgXA0KICAgICAgICBURF9T
WVNJTkZPX01BUChfZmllbGRfaWQsIHN0cnVjdCB0ZHhfdGRtcl9zeXNpbmZvLCBfbWVtYmVyKQ0K
DQpAQCAtMzE0LDE5ICszMzQsMTAgQEAgc3RhdGljIGludCBnZXRfdGR4X3RkbXJfc3lzaW5mbyhz
dHJ1Y3QNCnRkeF90ZG1yX3N5c2luZm8gKnRkbXJfc3lzaW5mbykNCiAgICAgICAgICAgICAgICBU
RF9TWVNJTkZPX01BUF9URE1SX0lORk8oUEFNVF8yTV9FTlRSWV9TSVpFLCAgIA0KcGFtdF9lbnRy
eV9zaXplW1REWF9QU18yTV0pLA0KICAgICAgICAgICAgICAgIFREX1NZU0lORk9fTUFQX1RETVJf
SU5GTyhQQU1UXzFHX0VOVFJZX1NJWkUsICAgDQpwYW10X2VudHJ5X3NpemVbVERYX1BTXzFHXSks
DQogICAgICAgIH07DQoNCg==

