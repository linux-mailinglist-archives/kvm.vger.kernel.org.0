Return-Path: <kvm+bounces-69744-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kAUxOYDrfGmdPQIAu9opvQ
	(envelope-from <kvm+bounces-69744-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 18:33:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A396FBD44D
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 18:33:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 184303029430
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 17:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A3B36403F;
	Fri, 30 Jan 2026 17:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OW2u9n3k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC04363C70;
	Fri, 30 Jan 2026 17:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769794341; cv=fail; b=VRmvM7x5P+Jx7eHpKiNCncLXE92BYsUeebujkdrcH0o3+SwVoHlmUxNFSd0SKq6yBzw/IXry3lcwp5K0hVkHOckfFrl1oOkjLTo+x/kv8EsRCSJCTBu8O2+k+8LqlJ6JG6xlL5h4KL5ELVe675slatL6JwatN3VXhW4K3b/F9js=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769794341; c=relaxed/simple;
	bh=Tbqi2+146hYoP14aP0jUxGHx/Iifu4eSqcl/Qx0QX5o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XfF2EvTn3mJfNKx+TGo6HE7Uthz4pN6qz/Q6c68Zn6b0qAU0OLADsxvfzLqrD9wnfodsrcI54MmEzIZ44drIA1Xn0vmH6MGmTA4+WHgd2ebMe75YQvHAjo2rpEC+hQH5bZl9t6YHziwt6UrhdE/XiH0km2tEvRkQD+eQoh8poSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OW2u9n3k; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769794339; x=1801330339;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Tbqi2+146hYoP14aP0jUxGHx/Iifu4eSqcl/Qx0QX5o=;
  b=OW2u9n3k840F7U2jzgFF+QXJ9lnH120VJXLlDG/yg6H2AzdPPI+64G7W
   ccVgVcvuGH15+WU7/nitJjYtXWtNyptIElS3Bw53aOzfyRDWR6AWvtGoG
   FRD/A0OS9YI11+B67ja0ymbiLuaMmpfWJ2WGA2zv3HmJpki0jCQQQTQIC
   D1YR/SOi+fTmzLtAg0j0KbAzWwb8jkV1suTZgRfFdb4jUz809K02hB2ew
   AxkNRGPXuRGxl0YRVIW7G6GNuFIwRKNaClyunedoE7sqU6JlqNTLl3dLi
   wbvyljsjjTLAWOBHP63UMiVKHPUs5b5+h2iQ0l7sRsjwORfdlfqvEdCHc
   Q==;
X-CSE-ConnectionGUID: DLny1iwcSsyCkSm9DJAhnA==
X-CSE-MsgGUID: 1r8s6nAWRRKymhWKa2LOLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11687"; a="82473123"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="82473123"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 09:32:18 -0800
X-CSE-ConnectionGUID: EUoh7aZOT3aUbcai+/QQow==
X-CSE-MsgGUID: Xerrn4/VTo+QoAxaFPF8EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="213438352"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 09:32:18 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 09:32:17 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 30 Jan 2026 09:32:17 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.67) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 09:32:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pFd++haKnRc7DqehiimHJuH89pU79fBv3qmt2FUNUH0YrvoXIrMEXjfmUGpyETTKzU0kWlyDFFU4OKSj+XPkMPruB9/hh6Kf0lHG7VTh8zzhwXX9wA2Re/J671fO+CKxTmNyFEoG5eJuqTXzLrfewDCTysQB0To+7CL5Xf211ZtqAGBog28a48jISgn2OZUxclNrFHLqki2BS9o9QmIHAQPb7MHrpZYWs8nK8vZiL9zJy1AHHR9qZIfhVxNULu9zdNSZ306xaldKO0399LE/J8wllB0/ELzYFwOlDccynomAAgfPRf8sNZ0jxubAUpVabI/PkN0PEgqdaiy2VXI3ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tbqi2+146hYoP14aP0jUxGHx/Iifu4eSqcl/Qx0QX5o=;
 b=mXoj/DydFhoRwGKFc/yXTVRfvavPCZTfqE7+PmBykNzJMvXGkspFkmw2G30cSYc7uYQ4bF1IbRKhsV8Nc7gKguZ3olohy1p/S+VO3qvaEjs4XsPMziphmtM58zhtXkodJsSIDjkjPj87YSbliI2VI3bdKvjn5VmvUi1twA2AIg9ChjIKw7eaIqLtSsA7+CaNmhuvA3s6Ou2aF9Kxcjrkf5XI817OCv4F3JoHx09izMK0Uh0tv18sZXIfPeSByhHL/dbtaD5pCPgMMl+OJQXlVtO6xKloX1WwMVhGFXrkHJ8UbbHTr55ykuf3AO7yJPBBP99FO04ToEHEC3dUTBISQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB6037.namprd11.prod.outlook.com (2603:10b6:8:74::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.11; Fri, 30 Jan 2026 17:32:12 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9564.010; Fri, 30 Jan 2026
 17:32:12 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kas@kernel.org" <kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sagis@google.com" <sagis@google.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "Annapurve, Vishal" <vannapurve@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v5 04/45] KVM: x86: Make "external SPTE" ops that can
 fail RET0 static calls
Thread-Topic: [RFC PATCH v5 04/45] KVM: x86: Make "external SPTE" ops that can
 fail RET0 static calls
Thread-Index: AQHckLzQFrPuo30t10erbAiwVzJgFrVpuWuAgAA0dACAAQ24gA==
Date: Fri, 30 Jan 2026 17:32:12 +0000
Message-ID: <e3feb0224cf2665a71ba6147e4e3e3bb30f96760.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-5-seanjc@google.com>
	 <f9f65b0fad57db12e21d2168d02bac036615fb7f.camel@intel.com>
	 <aXwJIkFJw_4mRl70@google.com>
In-Reply-To: <aXwJIkFJw_4mRl70@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB6037:EE_
x-ms-office365-filtering-correlation-id: afca4ee0-7ad3-49ac-7d5a-08de602580e6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?QTRLWGJEWHAzUElEU25BcllZTjg3OWkraC9jRTRxNCt5YTQvUUMwdE5tNzJj?=
 =?utf-8?B?WGRhTlZtQitzdlZJZDdTNklKRzBKYUhuYzdYV2dNYUZVeEgwVEhPODJUQUNM?=
 =?utf-8?B?MWpPb1VjcWpIMnFmcVVCdFFpNmpvamcrQWpvZ3RBbXVsQzd3QWhwNkwzZWRt?=
 =?utf-8?B?S2ZvS1hNb0dEZU93K294d0NMbDRKKzNub01jV0hYSGF5bk4vRXVqNXBxR1F1?=
 =?utf-8?B?eWVCUTg3Zy9sbmkxUU4yek9UUDRVZEtRZDBsS0tFKzl0a2o0RXVML0RvbjYv?=
 =?utf-8?B?Ky9PU0hqanJ2c0tnQmp0UlFsd1M0TmlNaFlTaFAvanBmQlZWQ2tZUUtwd0V0?=
 =?utf-8?B?THA4UHFBTmFEYjF5QnBPVDE4WWh5Ykl2NDBkeEpuNFZUNjVvZ1BQRDd3U0hQ?=
 =?utf-8?B?N2tUK0ppMWNsNU1aYXR1WnluQkcyOE11TllKYS9DeHIzamJ5R0hqcVdQbzhL?=
 =?utf-8?B?UzhuRldaVk8zVzN1WkxYV1J6QlA3dTZNNk1WR1pNTHFhWitvWVhXSUlxa0pZ?=
 =?utf-8?B?cDZaVzVsYmlWeUNYc0cxUGhIMmMyaTJmMnZzNEdtcUpzYUNzTnhTaXVLSjg3?=
 =?utf-8?B?b3VqNHR4emROQy9zNTlxNHkyTWNVajI4WnVlNllCU3lHL2JPYXBHK1M0Y0NZ?=
 =?utf-8?B?akJkYTBQaGVSanlkMmNCNHVhNXQ4bUdPYmpHcjhYZTdaWUt6T1RpM21NOTlM?=
 =?utf-8?B?L1k5ZkV3ZXFZaW9yZVJmbXpBWTN6UnUxRFAzMEhoR0k5NEIzV2lIeVUwOEw4?=
 =?utf-8?B?Vm1yZ25Qdjh3TmlmWXBSOUxRcTczUDIvV09YUjIwZDlRNlFyeHNnNVk2STY5?=
 =?utf-8?B?eEh3RGlBV3paLzFVaWFYZzVCNHdzam52YmZMUHRCQUNKTk1BVTFna1VHa2lN?=
 =?utf-8?B?dW9jRkYxTlFGSEZ5dFRiM0QweVRjQlJESEdTUE9oK3gyZDduRC9jR0w4T1BT?=
 =?utf-8?B?cXlxcHFmQ0VVc2VKSzFDVVgzbkIzcW1TWlJibmRDNkdmRFBjc01aWlVXakpJ?=
 =?utf-8?B?TUhObzRGZTk5cXRqWGhRcGd0Nnh4cFVPcW9GMXBwdTVoS3EzeFlYZ0VhcE1s?=
 =?utf-8?B?RU5rVUNXdC9abnZnMmE5bk1VUSt4Z0txdTFyeGw5b3JEZTFTTG94WDg0aUhu?=
 =?utf-8?B?b2p2a3pmWElvM2tGK2ZKc1JHUEM3U3lmcmZUMGw1UXdueTI3cXhTNkE3Q2cz?=
 =?utf-8?B?STdJVTVZVCtiSXNtWUIvM1hQSFZVWXNGNUhGeG5CelA4NlZBRGR3NGM2SmdJ?=
 =?utf-8?B?T2ZPN0FSY0MwZkdXbDBkUStrSEJDRGdmMTMyTW1GV0Y2cGJUbFpNUmo1djJY?=
 =?utf-8?B?RWV3eUpNYmxIeGNQT2hBMGN0RHFDMCtCU1BJZUcxNTNtNmFNNUtFV0ROTHZU?=
 =?utf-8?B?Tlg1OGh1RHhoV2lsZVlCTXBOYkRucTdUMjljWVh1U0ExWFd6VlVVTXMzVW5h?=
 =?utf-8?B?Si9IQWRlR0lYMnVjU2cwdk1Jd0l5U2xPLzcyMkpVQnVVL0JTUG1rRlJSVjdY?=
 =?utf-8?B?RlVucGFGT2dQcjQrcXZWbXFOTmRlOXlnZ0RHTTVwQXJoOU1NZlZxRDZURGxW?=
 =?utf-8?B?akhTazFTT09mbVVKWHJRbkNFdTlpNWV6eEJBd29FT2ZseXVEQUhoTHBGODJN?=
 =?utf-8?B?QjFYM0c5WkxGTDl6OXlJUWtuOWwwc1lTcldhNSs2NUY0YUpZeGJ5RXVRSzJj?=
 =?utf-8?B?VnJWbWpVT0E1VmJ6eFo1MmJIN3BCM1RPRTBwUm5zQ2NhOGE3Y0dZSDNqNFdz?=
 =?utf-8?B?STJQM24zcVhadXV5QVpjS01xeXNJQXBqek83WFJUZEF5UUdZYXNLRUJ5V0I5?=
 =?utf-8?B?aHRjRFVNbGw5ZWNTdE5IMHNmaWJCekIzWnpPeThvR2hjL3dxWVROeFpiWjJV?=
 =?utf-8?B?RXNPWlowU1dMRjl2T1NGMkkvbllqRy9GUk1qbTJpM1hieUdTUlBJOGZFckJX?=
 =?utf-8?B?SGFITnV5MjgxbExybHkzTGZqSllyRCs5OW1jc053a1crWWN5VS9tZ2NGUE41?=
 =?utf-8?B?c2JzNjMvUmZyRUtzT0w5WkczZzlxMEdtcHFYaGdwaTRoWXFXSTJyZ2d5ZGdK?=
 =?utf-8?B?M045UHNMOUU4V2wwZGEySHlybnFKWXJXSGQ1ZVpWcUJMc3hFWGtpWXhYWEho?=
 =?utf-8?B?OWpWM0NFRm1RZnpPWGRLaGdhMHBocExJZWwyeWxXMnNTWEpWRUFLRzdFRlF5?=
 =?utf-8?Q?Gl/9T6N8Uxc7b82FEkG5d5c=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MlFPL1hnbkFFSk5yNU5JY2Fva1hWcVR5TmlUL2NJL2MvenQ1MUdDQzFXRGxs?=
 =?utf-8?B?eTc2RDdvRGJIaDVjV1M5eWxieFk3SlFFbjRqZ0RiNkZNbUtmbk5kS21UY3d3?=
 =?utf-8?B?S0trSVIwWXk3SGk4c1hycnVyOGxzZ2hYUzM5WWFSSjViazlSTW5vdEtqNUtL?=
 =?utf-8?B?VGF3RjRVaWRIdmJ0UkZoV290dXlkcWFoOHJQMWhOeU1xQVZ3V1RHejAyTHdP?=
 =?utf-8?B?T294MGN2UTk0czV2bmd2ZmU3WXFrZnBWQVQ2WVo5L05RYTNvcUpHSUJSdDVT?=
 =?utf-8?B?dVZUdW1La1VDY1FKNkdoODVmYTlrN0RKa3dpOHdFMmJxUGVHVXlXcGJlRkJJ?=
 =?utf-8?B?U3ZXSENQZmhjNzB0VXVldHk0Y2ZOZzhrM2hjZEF3VFVYMm5VdGtkUTcrWG82?=
 =?utf-8?B?OFZCSitKeHNrTkRoUmcrRFFBbnlEcUNIUld1NkNYMFEwMGszblBxSXl3RXJB?=
 =?utf-8?B?eEhhSmhXMTJ3KzdjS2YreGE2TitONVpCeVNLL0p1M1FmRm1oaExkM2kxdis4?=
 =?utf-8?B?NWR1Y2hLZFJONkV3ZUlMVkt1SHpZczhqNGtab013WXptdHpMS28zanY5SkMy?=
 =?utf-8?B?YzdBYWE5T1N0Y1pHUWdoaE91aWNQc3RKajRNZ3YwRUpWMmpKUWplbENESklV?=
 =?utf-8?B?WUJEZXdnbFkzeUhMbTVJeWZPUVMzN0lrYzQ4NlpYSFZVa3RPZWRGQ1VkRzFX?=
 =?utf-8?B?RW53Qy9ZZXVwV2dFQ3VndDBjdGVpQ2YwTGMyN2ZTMFEwQVpTZ3poQTRuckFq?=
 =?utf-8?B?UVlSaUlpdE82QW00VU9YRFpyZkdkQ01vb0ZtemFGSkczMzZoVTJjU2pvb3Rw?=
 =?utf-8?B?V0o3ZWZSQ0JEcjltSmI0bC9NU1RFRWR5QWFDVFpJV2VLK1llektoMXRtV1p1?=
 =?utf-8?B?Ym9YQm41b2J6V01uL3hEdE9OODE2WnFRZzVIYjVBY2JjTVpZak1VZjdKQnRz?=
 =?utf-8?B?eTJNOFFKamtBSG0rK3pmN2UrVlJPOUJwV3FpZ254dlIrKzgyMHlSZFcybmVF?=
 =?utf-8?B?bU1GaEx6M0Z6cEsrUEZObFZxR2MzZ0ZYMnJ4RGg2bmFEcHBsUitMNCt5M2Fl?=
 =?utf-8?B?T1QyYTZQYmFZWWZLTkcxdk40c1J1WVE2QXRFeWxnK1lTSENEbjRrYmV3cVNz?=
 =?utf-8?B?dG1zQzNCektiTlE0ckNHZDlmTUc3VWYyUDVxcTc0MUNJeHZ4UUxKVXFwZHlv?=
 =?utf-8?B?RUkvRjcxd1E2YkRERVBlZmNiZkU2MXQxQS9JbjUzdFlBTEY0Rnc2L2ZpTkZt?=
 =?utf-8?B?RDJEUDJOUjJzV1ZEWG9PYTdiMmE0NUZsSHJDc1lqYmdOWkYreHE5bHFEaW9s?=
 =?utf-8?B?bW1ld0xwdW1NWXdwRFdXV3ZUdkI0VUtDdGY4WVN1R0hBVG5YQlpSeVZNSC9M?=
 =?utf-8?B?cVF0K280NFdqZHgzcDA5WDQrU3g4cHdaTEovYTJHK0NsTzd0TWpjL2MzbWl2?=
 =?utf-8?B?TFVjKzdBV3pLSVIvc1RnRGFSOW0yL3NHZE1sVGFJQXNRaGJEek15NXpUSlVa?=
 =?utf-8?B?YUVmUUJzZWxpL3lqU2ZGRmlnRjltcG5WTitMWXZYbkx0ZzZXeGw0WUZiaHhK?=
 =?utf-8?B?WnB5R0wyRVM5OWZpREgyQXZpT1JnNFFXUTE2UFVjT2ZKblBVV0RYWGZlKzIw?=
 =?utf-8?B?cnduMThKVVBtbXV5eWQ0QWNTUUYreDVMcVl6aFVtTWxmbUp2VGVKSXV3eEZ1?=
 =?utf-8?B?Zm1PeEg1UUNoSENUeDM3NlpMWTcxTkJMYzgwWWdjQm1WWksxSW4rUnBtNVBL?=
 =?utf-8?B?Z08vQmh4c056akx3VUxIT3l4bkMxWC9yd1I5am1ueHNmeVNFUkpSaW15eFVn?=
 =?utf-8?B?ZTlwMkxrTlpDQng0b3FzRGx2a0ZKVFovNzU4bHZhUkE5dDdUdVBYTjB3eWVu?=
 =?utf-8?B?cWJOL0JiUStSeC9oNGdYTnpSR2MrZW9lUjRXcmlmbXhyN0hFU1Q0MGEzbThx?=
 =?utf-8?B?cUI5ZHRxMWI2cnQvWE5XTThOU0ZRVHN5cjgzWXlKUFhNUWE4cXBjVE9zMkNR?=
 =?utf-8?B?WndsUDEyUmFEbE9seWFpbG4yL1E4VzVYanBNRzNaUElLWHlxMFJVZ3V0RlJo?=
 =?utf-8?B?dUVWUDFWU3haUytlMk0zbWdWNlpQc2kvbE50MWZDSUFRb3daNS81d2ZLRlpH?=
 =?utf-8?B?anpHbk5aa1ViaklCYW1FdnhjblJwT3lGRThrZHRlcHgxL2NQeVl2YjlVWVNk?=
 =?utf-8?B?QzBvaDZvTGZCVnIrRWpIQ1BxSVhOcWRQNVdCVlVJSVZSc21NaVFIKytFMUhS?=
 =?utf-8?B?S0k0WS84TGVMeVRvQzgzNHNXRS9MQnY2U3FTYi9sM1huOGhENFBMUXQwbVI2?=
 =?utf-8?B?NFY4dTJva1VHRWdVMkg1UCtKYUdPdFl0eENFdWtzTThqYTRucUNOTjF5anlF?=
 =?utf-8?Q?ZkLsAFofaTQl8vZs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DBD892B21E111446958F59DB1C658464@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afca4ee0-7ad3-49ac-7d5a-08de602580e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2026 17:32:12.5421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aaXG8bxVvGiS8julUVhbqHWSkl5GGibnVdvzP2mGyJOmqK/KvnwxSu9Dh6GxW09uENpTV3dWq1mb2E8SqcjzFIdyoYWrzgvBT/z3P2pzYKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6037
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69744-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: A396FBD44D
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAxLTI5IGF0IDE3OjI4IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiANCj4gSG1tLCB0aGF0J3MgcHJvYmFibHkgZG9hYmxlLCBidXQgZGVmaW5pdGVseSBp
biBhIHNlcGFyYXRlIHBhdGNoLsKgDQo+IEUuZy4gc29tZXRoaW5nDQo+IGxpa2U6DQoNCkkgdGhp
bmsgaXQgd291bGQgYmUgYSBnb29kIGNoYW5nZS4gQnV0IGFmdGVyIG1vcmUgY29uc2lkZXJhdGlv
biwgSQ0KdGhpbmsgdGhlIG9yaWdpbmFsIHBhdGNoIGlzIGdvb2Qgb24gaXRzIG93bi4gQmV0dGVy
IHRvIHR1cm4gYSBidWcgaW50bw0KYSBkZXRlcm1pbmlzdGljIHRoaW5nLCB0aGFuIGFuIG9wcG9y
dHVuaXR5IHRvIGNvbnN1bWUgc3RhY2suIFNlZW1zIHRvDQpiZSB3aGF0IHlvdSBpbnRlbmRlZC4N
Cg0KQW5vdGhlciBpZGVhIHdvdWxkIGJlIHRvIGhhdmUgYSB2YXJpYW50IHRoYXQgcmV0dXJucyBh
biBlcnJvciBpbnN0ZWFkDQpvZiAwIHNvIHRoZSBjYWxsZXJzIGNhbiBoYXZlIHRoZXJlIGVycm9y
IGxvZ2ljIHRyaWdnZXJlZCwgYnV0IGl0J3MgYWxsDQppbmNyZW1lbnRhbCB2YWx1ZSBvbiB0b3Ag
b2YgdGhpcy4NCg0KUmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJl
QGludGVsLmNvbT4NCg==

