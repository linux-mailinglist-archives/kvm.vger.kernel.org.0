Return-Path: <kvm+bounces-68483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F1661D3A1B8
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 09:35:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7160230087A1
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 08:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A766233FE33;
	Mon, 19 Jan 2026 08:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TScr6E5P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DD227144B;
	Mon, 19 Jan 2026 08:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768811736; cv=fail; b=mHfDFx8QfwH/BMcQ4/bF8fhzqE9o6XsoGGd2Po3SFEM7SjkkHbvU5d/mjgjpGsD55Zj08YmB1vLYoAMslDOdN1fpqMjt2xqzelhKB/aoBvG1uOvR+ijWMZrjKx+DWRUkjbBTs7n47ozvf5yok5qEYqJ0QjGg3vykL1yVpn60Xxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768811736; c=relaxed/simple;
	bh=2huVcmgdrvXM9B2dDEO2iUUBUkIOXsIWwO+ehRbslQ0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mWsGme9fIiNit22P/CWYt9K3qBx7P7VIHrbuptPp+ZNdB8IP80SNMqXGVuJeVm+VVuylzIBUesE9DXrm0h2UcRhIdzQFhW5pMjp/Mdc9E5LU4sMphP7RY54uCQII/hy9f5iVyO9s7bxKN3hPXdtoDwN8n1zRDkbwTovbDIOVdiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TScr6E5P; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768811734; x=1800347734;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2huVcmgdrvXM9B2dDEO2iUUBUkIOXsIWwO+ehRbslQ0=;
  b=TScr6E5PoIzdZQcBrvRnFtJv7MPr1jOoc+EDtkr1l4l/Htix8w8aphA/
   9eLErjS3CxeWByFEkKdVDeAESExbLXRlNe1Ui0lUWis8iK18eKmr/SL49
   nV71KAKa/x0IMUmW6KQlMj/kh+2ItY6v8Je5yuUFepr2o87WrQIu/Ew9j
   wi/MSGasJjqRwl0NgWyjT0idkHtTUv8r/iKJiLL2ZfXTu1HziUiRps/qL
   2hQNR4Z71FahXx0fovIf+46+iVwkqgaG1yQVVQ8xzJDMWlLMovvWzHjPi
   iwt6wMdi1L63IzV3HzAkvKJkeCBKcoM6dNpS9uj/mw9VLeiWM1nhbUTRV
   A==;
X-CSE-ConnectionGUID: sCp1B6vIQs64vKQZ3ElpsA==
X-CSE-MsgGUID: Z2jN57rYR4CM7lPe+rNvhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="69218474"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="69218474"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 00:35:33 -0800
X-CSE-ConnectionGUID: LjWyj+zQSlOoQu3mppK67Q==
X-CSE-MsgGUID: xC+4KvCLTXy+LEBHjMJiUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="228744665"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 00:35:33 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 00:35:32 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 19 Jan 2026 00:35:32 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.31) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 19 Jan 2026 00:35:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z1Ban2ey3GRP6Ea2Mbv3Rn1E7mR366UCj2dh7T9HAbvdi5jwXJOvP8UhHaOvRq3Fo7dfSm2Fx6x0A06CezZn1KDAAqK88iT5kmioKQEpvc4wpk8hgLTQUCpUsDmY4ADx2QcmUNU0WS5EVwmhK/AaZhppM8WjnPsuOzWwyARn3YKF5zjedhjq7UV7S6l37w+yqu4Fw9W+opO+TYNBXZR+1nfMbaexBqJhTPtWFny5W5MGWoi2DZQREqPsmU7gsB61P3nhcj9Cpm6hY+3DrcS4nTOF2gNX0bVEaqoUfbkGatCvPq0Fr96nCxgcIUQr9kTZSW17ALCKxVK2qeo6tt7wyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2huVcmgdrvXM9B2dDEO2iUUBUkIOXsIWwO+ehRbslQ0=;
 b=deQelp5Dh5ymny4kVY4kAHI12wtjwRzH0hOiJf+2K6COnl8Fg30ZMw5uNCNqOnMUoAGgirToKmIH8beusNU9VD6PTF+/Lxhxn+qkZUus1xtwhKCSHVnLihTPJL8hSkehw1Du0C1MV5Xt7w8/lbIwmhob1gAAXw41td4x7T6LbCxU1P5vp8apns/AH0EJYi0cEwn3Z38yqyWn04cUhAE1ptTH3iDx5om+rYEsZz9rHAT3Mms5ad+bDSWAqd0hs1CTuK0IkYV44etvEBNGIcuubLynYUV2WqJGBn3CAW/CXSMGTs/0RxBmk1HTbp60o0GkgklT11N/GRMgZwljaMhleA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA1PR11MB6444.namprd11.prod.outlook.com (2603:10b6:208:3a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 08:35:26 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 08:35:26 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "david@kernel.org"
	<david@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"kas@kernel.org" <kas@kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "sagis@google.com" <sagis@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Miao, Jun" <jun.miao@intel.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "jgross@suse.com" <jgross@suse.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 11/24] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Topic: [PATCH v3 11/24] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Index: AQHcfvaNGzJc+xBW3kWaSmjSCr7TyLVTNhiAgAJOnoCAA0M3AIAAd0CA
Date: Mon, 19 Jan 2026 08:35:26 +0000
Message-ID: <3ef110f63cbbc65d6d4cbf737b26c09cb7b44e7c.camel@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
	 <20260106102136.25108-1-yan.y.zhao@intel.com>
	 <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com>
	 <aWrMIeCw2eaTbK5Z@google.com> <aW2Iwpuwoyod8eQc@yzhao56-desk.sh.intel.com>
In-Reply-To: <aW2Iwpuwoyod8eQc@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA1PR11MB6444:EE_
x-ms-office365-filtering-correlation-id: e910baa3-d9aa-4bf0-0f80-08de5735b1d4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UXRnZ3lDTlJ4QjFxekIwdzB6eDBuVlk4RWZ0eVF2amM1bitQa1dJUzgwQnBZ?=
 =?utf-8?B?ODFEd2JrVld1UjNQNUhibHZ0blZPemNVZ3diSzc2c01CblZCbWw0aWdsZktm?=
 =?utf-8?B?OVNOSHpWZXBOMkN6Y25UMDZKY2NjLzBKWGt4Z0VVUXlsWS94eTJCVGw4RFd5?=
 =?utf-8?B?clVJcDJKaEdoODdUeUNRWUdwYmFxR1BvTHJqWUJpUjQvd2lvVXM3Qk5SUFF0?=
 =?utf-8?B?c3FSZlF3Qi9sbFIvTzJYdEhobG9qREd4YlRxZk9JVjUrODhvVWJudHh5U3Fh?=
 =?utf-8?B?SUs4NUxuNUtjVzNZOVhoK1hTUUNuQlE3SlRaclk5czlSM3JOUkkrSkpaM3RT?=
 =?utf-8?B?Q3VNLys5N0JzQmt0dWE4NmF2TSs4Wm5WR1YvME1lQ2p2aEhsVDBnYVlYc0dN?=
 =?utf-8?B?Rk1IdXZVNjhTNUxnY0w0THF3YnVEblNOSlpSb2VybWJlbWxuVFRHUWZGdWt4?=
 =?utf-8?B?MmNLV0p3cTlxWW94TEFMVGZEbFlMYXYxRFQyQkkxSWpQMWIycFRQdi9IcGtr?=
 =?utf-8?B?SHAvTi9CTHFscGhKcWN1Ym5qcnpBZVBlay9OSFN4NGxhTDYwdXd5UzdxWlpy?=
 =?utf-8?B?Z2tZcTA2Q083L2Q1WVp4bkhDMEc2SzdFRkxYalBBTFg1YkI0ckNLRUhqRml2?=
 =?utf-8?B?MW4yQVJhVFJmQ1NCek1YZVZVVjl1TkJXUjBzb1BxVWgrSTlmQWM0dTNtQ0x4?=
 =?utf-8?B?TTBnVmpmN2dDOHZkaEJMSURIQ0NWNDBlemlBelRwblZPanRRQjJIRlJtK2RR?=
 =?utf-8?B?a2FTVWwwcCsxRUo4d2t5eGJJTTV3RW80c3JPY09NV1MwZUJwdGh3cG40N3ZO?=
 =?utf-8?B?Y1c3MDhxY0JwSTJGQ0tNVDdZS0UxelpPc05kV0FIYk1Zekxva1NERXdUY3pj?=
 =?utf-8?B?STl5K2hmMXZmTUFIYWJod0FUb0kvZDkvN2lOQXpwUXVnMXNHVVJKZ29iUGR6?=
 =?utf-8?B?TldOVTB5VFcxQ3NDQU45M1k4VlF1Vi95bTN5OWFoQUZLdmhoS2VkQzYxUVhY?=
 =?utf-8?B?Q1lzR1RibTRHZ0hWRlpsd3AwMm1GVDdvMWIxUXIwS281SGZwWmV1RDcrWjNZ?=
 =?utf-8?B?d2ZtWis3MjNWNE9RbnU0eUJWYm9nRjFIRTRCcUdHc25nSDh5bHZ0NlF2THU0?=
 =?utf-8?B?QW9XV04yeG1kUFV6VU1QcnZnY3NnUEFOYVFRZ3ZuNlN1SHJ3RkhJVjJCQ3la?=
 =?utf-8?B?UjB3TnVKQWFtMG9wU1lkUDdwWDFrbExUNy95czZCc3JsWjhLcGdMUkREWkVi?=
 =?utf-8?B?ZjFFV0hVQjBpTmo1NG5FQkJ1NG9VcFdKeWNHU3NqTnRXTFBhRU5Zay9NOXVo?=
 =?utf-8?B?dUJRZ25DVzFNQWtyZ1lsTThRblpIQ0JWYS9paWg4bnBYNnI2aVNjMXVhbm5E?=
 =?utf-8?B?YTduU1F1NlNoU2pwSjE0c1JhSEVzY3BtSVJtVnovYXlQTFVuakZPWHhCRm96?=
 =?utf-8?B?RlN4K2RONi9hNGdvNkkrNnBkREp2L05VenBGWUJXZ3ZhaW9OaWJVTmhXNlVM?=
 =?utf-8?B?YUJ5TmgvSS9nMmFlNVh6UXhEZHdVWFQwbkVjMzlud2VRRHZTaSt4S0s4YXlk?=
 =?utf-8?B?SjRuanp3YzNVSzhFV0I4RUxmcW5rK1NObnZ5bHZUK3lLYWt1cFJvdEllMWVS?=
 =?utf-8?B?NmRkV1U1VkhPWVZ4a3M4MWdEU2JPQlZ3SG5JV0pQV2NRblBJYU1KY0ZoWW1y?=
 =?utf-8?B?NnBPVlZYQTdRbE40dzRtTXJtUzR1cjlGN2pDYm9Gc1VoT1F4MXpSMzkza1JE?=
 =?utf-8?B?QWlhSmJyYTJjODRJVzNBL1hFdEk5V1duQmVkNENhZ21qTG5yL3BHMEhmVFgw?=
 =?utf-8?B?RjhlMVRiazhRR25HWklyUld3Zm1LZVNCT3hJVm1EQ05aNUlqVkFZUzZURnF6?=
 =?utf-8?B?TGZYNWpMUUpXOGhDNGtFWHpSVFZRUjN2Q3ZkWVRGdmMvYmoxVG5ra0U1VTh2?=
 =?utf-8?B?eUhmVGlueVRETkUzSndLQmJOVnJRQXd0VzFQNytYK3lIYTJaNU9ZelhIeW5D?=
 =?utf-8?B?eHZBdUJDMzh1Z2pld3JlVVVMRENobDdBTThSZTF1V0NNb0p3dnZmK2xLZkpv?=
 =?utf-8?B?L2EyOWZxQlgrNDlpWWUrMStsclhZN3ptQmlSSlBUbC8yTFZtOW1qVWloemJI?=
 =?utf-8?B?VWU0NVJUUWJjaGFEVzdFR0FrTy9HaU4zMlI0T3I5d2EwU0JMS1RFSjV2Ynd5?=
 =?utf-8?Q?XAemGz/g8MWUMvzAzJHVTsg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2RpMS9adXFDVjVUejRtdWVjWjhjUHgrNXhneHlaOVVwT0dsaXVtTVJkZzM2?=
 =?utf-8?B?VGNBOEI3TU0yL2JJOGUvMzNhSDlweWNUQ1QzNmxEVW5JeS9LTU9maTFSNTY4?=
 =?utf-8?B?bFRVVlFWVzNLQUJhQ05abXZBbDJNMlFRRW53eEVzNHZGOVoxVnRyMSt1bzNE?=
 =?utf-8?B?QjJwVGxQcDJaTVFFUnp4UW4zT1gvRmFlK1JsSGtJUFdBUk56N3doYVRQTXZu?=
 =?utf-8?B?dG50UFVIVENkdHVrVmxJbmFPVll3MGx4dnpQOVI3NExzbVBHcDhZeVBNVTBu?=
 =?utf-8?B?bUJ0RHJnUEtFS1ZNUC96Y3d0bFl3Njczak5nWG5odnpoOE1YcWxSNWs3N1E2?=
 =?utf-8?B?K2Z2Sm1TN0NOYzQvOUtmblNVS1ZFZklEcTZmTHR5dzcrNUFyd3VGOGk1Znlx?=
 =?utf-8?B?WmF1UThBRUkzWmZjaWlDYnAzTU1DbkROdDlEV0p0V1ptb1ZMd0MrWDV1b3VS?=
 =?utf-8?B?UXVCK2J4RUlQSFd2V2JnYWwzK0VuVll4ZERJekxYTTg2bUtwS2d3ekc5Yll3?=
 =?utf-8?B?R3g0Zi9yR2xMK0NGSDRnQ2g5R1NRczNFdWZEUW1CbWtDenQwdzc4UG50eFh1?=
 =?utf-8?B?WFdsQUpLelJFYm1JazNoL015SzlVcXkxeW9uNHBnYWlrVEJWQnZ6NDVuc2tr?=
 =?utf-8?B?ajdITTIrTnN1OVhucW9weG4xZEdwcWRqNnJvZVQrM1plbnFKanZaem1BQWFo?=
 =?utf-8?B?UEQ4VEZZQldMcytyd2o4Y0tPNitGUjg0VVZWVmVtMU43SVRCVEF4ZFozUFpj?=
 =?utf-8?B?VXVUV29OeldIdmRDMnljOWttRUYwVm0xbjJmKzdZNkFUdG8zdGd0TDB2UDRL?=
 =?utf-8?B?UUovZStFeUttYjhwL1hDNCtEdnZjZzRWTDlYSFRld200MTFFMmtXQUp2RDBo?=
 =?utf-8?B?anhzZUtxc052VFFGV2RJaFN0VFN2QmNONTgxUnE0cmFibU1HMnAzekRXWmdz?=
 =?utf-8?B?R0x0bjUzbll0Z0lUTEU2OTFGejJGU3FNSCtRSG0vQjhVVFh1NWp6aWRRcUV6?=
 =?utf-8?B?ZVhjNHhIWXdnVWc3bmtOdzZXaTNsNUpOaFg1UlBwb21vU0RYVUYyU2p2VmtV?=
 =?utf-8?B?UGxWS2NWZWdsbC9BajEzcTBVQmJTajBlOWNHYm1RcG1TOHpjbmRLUUdOcHB1?=
 =?utf-8?B?dG93YTZqQkJDdGJZeklNTGduSjhnaHd1VElaR1NIWFloS2E5SC9Qakk1RGZB?=
 =?utf-8?B?NjRHWWM0STZNRkJlQ0NWZTRvb2lNVDBYSFh1dVNjRlVKNzVvNDlvNGU5a095?=
 =?utf-8?B?Z3dPVHpYTjRFK0xDb0RtcS96SCtjNENTMkxzWUNPNzVRYkVKcTlqUzArVWRZ?=
 =?utf-8?B?ejNsYk9yVktOWjd2YW54cm1rR3I4TVFkNHNZR3NNKzh2YWNaN05MWEFHVVBP?=
 =?utf-8?B?ZHFzT0NhZ0N2dDM1TXk2eVlQalM2Z1dEZVBHbGJSOGN1NHZPMk94U2dNdnNx?=
 =?utf-8?B?ZWpFSHRIS0ZYNzdENHNWNW1xdWhoTUFnWDVzSzRxOXBCQ2xBL0h6WmtjRm1D?=
 =?utf-8?B?UmVTWEhzeXdrTGFocmtxekhhd3Q3aFBYa1N1VCtJZFBadU1nVXE0WU1MaDNx?=
 =?utf-8?B?M3BGeVVpWmh2Q2ZIK0Ixa1dRK05RTWdOeDRFRzBHbzhIM0FJWUQva3FFZ0NX?=
 =?utf-8?B?ay9UR1VKaUxwMk53ZS91V3ppUERoNTF6KzBmckR4QkhreWdJYjNLM3lmRTZt?=
 =?utf-8?B?VG1icVVxRUhKdXhvY0JkVHkzNTd3WTVIQm9MYW5yUjh5T0xXc08wNDJnSDVF?=
 =?utf-8?B?b082M0pOL2ozT2gydFFiZGNUM0ViZjUxWkVuWVBsQlowaUJoK0Zla2VlUkNL?=
 =?utf-8?B?aEVrN1o0LzZYMVdMdi9kWTJTOUZudUZjbGpMbDhwNC9lQmlNbmlEaGI0N0Uz?=
 =?utf-8?B?MDRHNFl2a0pTcitNTSt2enB4MTM1QmNiSWpnVHBFV0ZMZ1YxWUZHeE1zUkN5?=
 =?utf-8?B?SHlUdEZTRHNUWGxUQS9rRUloOGtxaVVGME5GQUEwdkxrM1RKN1VPL0VPVzky?=
 =?utf-8?B?ZkNicHMrWnJQaExxeG5OQlFvTUVkaVRNSG9MR1RpQ1NEN2pucjgzU2NrRWRL?=
 =?utf-8?B?NVNLZnZ6em9VRFRvSlV4ZmJSRGlsMFZMRkFudjNsZDdJSFJIeENTR2Z6K0FR?=
 =?utf-8?B?YTVZTGFHMS9NRDJ2eXE5Y1B1SDcwZklRQjlzbXAwbE5LWW9RNjR6RTZoUndS?=
 =?utf-8?B?bFY5eFNWMyt5eGYvcGdLVVNHb3ZnWU1ST3pYYUNuNTM0SC9INHlDdmpPc3F1?=
 =?utf-8?B?aFZZclRSci9tRzRic05SRHR5YVlBSDdiUUlPMDdSRVovVERuYnRwZWtqcHA5?=
 =?utf-8?B?N29NRHlrNEp3TnIrbTBGTVp1VEQ4N0kzdStuSXIxaFByZXlHeG1iQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EBA0C233977DFC46A0A5B5FF06B065A4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e910baa3-d9aa-4bf0-0f80-08de5735b1d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2026 08:35:26.0953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hPUYrjhbhv6pJkQ7UIS77LyKSi/h4PW40uzKbBWzKiWI4JDDrkximC3FZebt0lTsQPJTTwRK/IEKrJnICQDNkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6444
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI2LTAxLTE5IGF0IDA5OjI4ICswODAwLCBaaGFvLCBZYW4gWSB3cm90ZToNCj4g
PiBJIGZpbmQgdGhlICJjcm9zc19ib3VuZGFyeSIgdGVybWluaW5vbG9neSBleHRyZW1lbHkgY29u
ZnVzaW5nLsKgIEkgYWxzbyBkaXNsaWtlDQo+ID4gdGhlIGNvbmNlcHQgaXRzZWxmLCBpbiB0aGUg
c2Vuc2UgdGhhdCBpdCBzaG92ZXMgYSB3ZWlyZCwgc3BlY2lmaWMgY29uY2VwdCBpbnRvDQo+ID4g
dGhlIGd1dHMgb2YgdGhlIFREUCBNTVUuDQo+ID4gVGhlIG90aGVyIHdhcnQgaXMgdGhhdCBpdCdz
IGluZWZmaWNpZW50IHdoZW4gcHVuY2hpbmcgYSBsYXJnZSBob2xlLsKgIEUuZy4gc2F5DQo+ID4g
dGhlcmUncyBhIDE2VGlCIGd1ZXN0X21lbWZkIGluc3RhbmNlIChubyBpZGVhIGlmIHRoYXQncyBl
dmVuIHBvc3NpYmxlKSwgYW5kIHRoZW4NCj4gPiB1c2VycGFjZSBwdW5jaGVzIGEgMTJUaUIgaG9s
ZS7CoCBXYWxraW5nIGFsbCB+MTJUaUIganVzdCB0byBfbWF5YmVfIHNwbGl0IHRoZSBoZWFkDQo+
ID4gYW5kIHRhaWwgcGFnZXMgaXMgYXNpbmluZS4NCj4gVGhhdCdzIGEgcmVhc29uYWJsZSBjb25j
ZXJuLiBJIGFjdHVhbGx5IHRob3VnaHQgYWJvdXQgaXQuDQo+IE15IGNvbnNpZGVyYXRpb24gd2Fz
IGFzIGZvbGxvd3M6DQo+IEN1cnJlbnRseSwgd2UgZG9uJ3QgaGF2ZSBzdWNoIGxhcmdlIGFyZWFz
LiBVc3VhbGx5LCB0aGUgY29udmVyc2lvbiByYW5nZXMgYXJlDQo+IGxlc3MgdGhhbiAxR0IuIFRo
b3VnaCB0aGUgaW5pdGlhbCBjb252ZXJzaW9uIHdoaWNoIGNvbnZlcnRzIGFsbCBtZW1vcnkgZnJv
bQ0KPiBwcml2YXRlIHRvIHNoYXJlZCBtYXkgYmUgd2lkZSwgdGhlcmUgYXJlIHVzdWFsbHkgbm8g
bWFwcGluZ3MgYXQgdGhhdCBzdGFnZS4gU28sDQo+IHRoZSB0cmF2ZXJzYWwgc2hvdWxkIGJlIHZl
cnkgZmFzdCAoc2luY2UgdGhlIHRyYXZlcnNhbCBkb2Vzbid0IGV2ZW4gbmVlZCB0byBnbw0KPiBk
b3duIHRvIHRoZSAyTUIvMUdCIGxldmVsKS4NCj4gDQo+IElmIHRoZSBjYWxsZXIgb2Yga3ZtX3Nw
bGl0X2Nyb3NzX2JvdW5kYXJ5X2xlYWZzKCkgZmluZHMgaXQgbmVlZHMgdG8gY29udmVydCBhDQo+
IHZlcnkgbGFyZ2UgcmFuZ2UgYXQgcnVudGltZSwgaXQgY2FuIG9wdGltaXplIGJ5IGludm9raW5n
IHRoZSBBUEkgdHdpY2U6DQo+IG9uY2UgZm9yIHJhbmdlIFtzdGFydCwgQUxJR04oc3RhcnQsIDFH
QikpLCBhbmQNCj4gb25jZSBmb3IgcmFuZ2UgW0FMSUdOX0RPV04oZW5kLCAxR0IpLCBlbmQpLg0K
PiANCj4gSSBjYW4gYWxzbyBpbXBsZW1lbnQgdGhpcyBvcHRpbWl6YXRpb24gd2l0aGluIGt2bV9z
cGxpdF9jcm9zc19ib3VuZGFyeV9sZWFmcygpDQo+IGJ5IGNoZWNraW5nIHRoZSByYW5nZSBzaXpl
IGlmIHlvdSB0aGluayB0aGF0IHdvdWxkIGJlIGJldHRlci4NCg0KSSBhbSBub3Qgc3VyZSB3aHkg
ZG8gd2UgZXZlbiBuZWVkIGt2bV9zcGxpdF9jcm9zc19ib3VuZGFyeV9sZWFmcygpLCBpZiB5b3UN
CndhbnQgdG8gZG8gb3B0aW1pemF0aW9uLg0KDQpJIHRoaW5rIEkndmUgcmFpc2VkIHRoaXMgaW4g
djIsIGFuZCBhc2tlZCB3aHkgbm90IGp1c3QgbGV0dGluZyB0aGUgY2FsbGVyDQp0byBmaWd1cmUg
b3V0IHRoZSByYW5nZXMgdG8gc3BsaXQgZm9yIGEgZ2l2ZW4gcmFuZ2UgKHNlZSBhdCB0aGUgZW5k
IG9mDQpbKl0pLCBiZWNhdXNlIHRoZSAiY3Jvc3MgYm91bmRhcnkiIGNhbiBvbmx5IGhhcHBlbiBh
dCB0aGUgYmVnaW5uaW5nIGFuZA0KZW5kIG9mIHRoZSBnaXZlbiByYW5nZSwgaWYgcG9zc2libGUu
DQoNClsqXToNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8zNWZkN2Q3MDQ3NWQ1NzQzYTNj
NDViYzViODExODQwMzAzNmU0MzliLmNhbWVsQGludGVsLmNvbS8NCg==

