Return-Path: <kvm+bounces-58908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AED9BBA54E4
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 00:11:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B01E31C030E4
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 22:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD01A29D26C;
	Fri, 26 Sep 2025 22:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UX3F4vVs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B00299924;
	Fri, 26 Sep 2025 22:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758924658; cv=fail; b=fuQz/ymnOlc/D4ZFq2ZAlS77rA9Rpf2eMcDVqs9o9Oi1gDe7FghMwJs04vVLHheTCPfABXG5BtbKETX2Py/rbPUTZIxgucDL4KHh/rPCfSR6oCwBxe8SZDm1hVoHQ94qmDgSmbHnGzjDvL1+ilYCoovzv9p9Ev4ZBJDQnfdXx+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758924658; c=relaxed/simple;
	bh=OGTkIjibmed2IepcjiXyyZmAhQIzxbaFgGZKVdZUohs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ffNsXwTyH+WGhHlRRCS5T1TxxS+Eml3svMVT53feomb6ZK6JSQl8BT1mB7XtBy5816Wj+nxEwzx/6CDxQyxt1gm78CSuTEPTBVceHy/2fmF79DYDldsO3Y9UGBAPJCGdgKZxFgHBvt/IolPfe058nP2Ssvv22R5zKp2E9l3km8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UX3F4vVs; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758924656; x=1790460656;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OGTkIjibmed2IepcjiXyyZmAhQIzxbaFgGZKVdZUohs=;
  b=UX3F4vVskCjFfYFlh8lqPMwJ+Th+2jjaAdiZDsnON0MU2BFn8SfXAxui
   is4tpq69Em7U8a87eBIWxKpY+iOgy+h9Ux6/G6dpP7ZJmsqvRgvceYOtK
   w0qgpdiDJSGWwZc198MLicvj9mCB881GjzLqKtby28iu831bPgghTlyHi
   N6PJ+gyFyp77pgsEDZavTSxxA4ET/hkr0jV7tHVkyJxTygvED9oRDDY5Y
   Io52hh/4qfFj+gYt1zHgxX9dQ6BoGctRPdlqutYERPIy0i9LJlRKdlDX5
   kB9w8bF9hHBBi38fWIqu71hl5TuRKMTc6KWMF4O8iN9VfHHoe/bQDY18b
   Q==;
X-CSE-ConnectionGUID: +fSk9QyWRCuEmuXFGcXEeA==
X-CSE-MsgGUID: p6le//6RSR6vXS3dyYkMKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="60300044"
X-IronPort-AV: E=Sophos;i="6.18,296,1751266800"; 
   d="scan'208";a="60300044"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 15:10:55 -0700
X-CSE-ConnectionGUID: Qqq+nEg6RDiKZZazQnBlsQ==
X-CSE-MsgGUID: XX/Q1YBNRoikkSI+v/yRFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,296,1751266800"; 
   d="scan'208";a="214854084"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 15:10:55 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 15:10:54 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 26 Sep 2025 15:10:54 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.27) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 15:10:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gc2GxdvJklBA3hTJgGPeFlDdl2iPPupvfCTP46xhaBcKLEoKM10msP6VsY/NdY408tHB7oVIWmGdF1oAPqOyG5viG8kP4ynsqoBzZOUyXMvDsSTyVaBNb0YJ5nTZHri8Hwmm2XKYdWoMaPk5wZV22ot7XjQerfZGGcAsyJDKWAvlgrxHXP9FAsT5aDLpp0n/sCIsws+rZ+xhoyy4YYkO+E6/ZDUGkKdL2ykz6jm07MthFXDbo0ieRKw5xLLWYRy8kpKM/z+VPHeWsAxL/sre4QNxxR9VUDLfblk+RXuNxVkdnNKdWp7ld1PM46cC8Zs7ISofnUIsYAPUcrddFSC99w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OGTkIjibmed2IepcjiXyyZmAhQIzxbaFgGZKVdZUohs=;
 b=BBLzrnM3cx2Cr+5Q8fEA89dt4sBpIUsNCk8QO155iIKaqfZiFuc/MuUFdfebW0TOgykdxRIDYAeL6/m5j/1S8QUwvoypX9Ri6eYBlMt1GdmIfHGA9rTJGlGENGXXTcMLhWBPhLGdpo957XRBVCSXRRZSh/uHRuCbXB5UTVHQ3jH4oKm99x+HgpJndJV+bP9qd6dLLaOXx9LykBrBk+l511CVaIaBoNMlpw99tymEezweQvcqXnT97WaCRNH0995fkEOAk+Ni7o7aeSdYIoEq6KOzhE27KN0WeTr3otw3TNX8FlvK0SZq8u4SoghACumwZsMRB+oPmbiomcHXTmX7fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL1PR11MB6028.namprd11.prod.outlook.com (2603:10b6:208:393::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Fri, 26 Sep
 2025 22:10:44 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 22:10:44 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 11/16] KVM: TDX: Add x86 ops for external spt cache
Thread-Topic: [PATCH v3 11/16] KVM: TDX: Add x86 ops for external spt cache
Thread-Index: AQHcKPM1I9Uz3YNymUWJSwvxA2Y0bbSgXmuAgAW0aIA=
Date: Fri, 26 Sep 2025 22:10:44 +0000
Message-ID: <9f18cd1aa0d51e7cb7bb2cc360f67b8cf92ed487.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-12-rick.p.edgecombe@intel.com>
	 <aNJGP6lwO9WOqjfh@yzhao56-desk.sh.intel.com>
In-Reply-To: <aNJGP6lwO9WOqjfh@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL1PR11MB6028:EE_
x-ms-office365-filtering-correlation-id: b277de36-7290-4d2f-4249-08ddfd4989bb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bEdvNlpUQUs0TEdFK3FoZnBYek9CSnlxbERxZ2l2SzA2dUFxVElreVk5QU0x?=
 =?utf-8?B?WDVIZ3pMZjFvU1BTbmhXZ2tTMTZpNzlJaU05Mk9RTE1KNm9jTndTOVFWblRR?=
 =?utf-8?B?RUNpRXpZYXk1citlSE1GaDFaeEVzUUpXdEd2dmMycUxKZmk5NEc0RGtVWTJS?=
 =?utf-8?B?S0hPOWpjMUhsNGxhY1dGU2JnZXVnWUU1cFFLdVhzZ1kyQnVVWHdvZmI2MWsz?=
 =?utf-8?B?REZTYUJ5MWVGcmlDVDhEdnIyWEE3cnd6UjM0VVRNU2VUNFFHclFpbTNlNHhC?=
 =?utf-8?B?ZW90cTIrZlluS2NmUUhCRlIxNlZuQ3BZbHBOOUdQRjZPRUpHNHFQVVFYRGJi?=
 =?utf-8?B?RXN3RFJyaWF6VU1WTlQrU3BkUDJZV2hJWGhOcWZsOVE0cEVyUmx4cFc1dWlj?=
 =?utf-8?B?R2xqbDJDcE5TMlJjVGQxWFJIVzB3U3lCbEg2dC8rWHV6ek5KRmVnMWl1TVRW?=
 =?utf-8?B?S3JMNVhXclVUWmp2WnVKdGYwMS8rdXlDOEt5d0NLYU1YYWJ0Y0lvYXhpeXVy?=
 =?utf-8?B?all0eFBvYm5IbE5RL2pzaDRnaVc3Q1pKTFRqdklqcjdFUXdXOWpvZW54cDI1?=
 =?utf-8?B?MWV4Rll1N2phR0pOanpkaHFNS3FWc3g5Ylczd3VWRjVmdkUzOG9GQkhqR0Jh?=
 =?utf-8?B?Vk1IWkhzV2pyeDhGQVRXUTF3WjlGWmwzRHJrWHNWM2JSQWRGTk50RVVVVWJL?=
 =?utf-8?B?Mmk0OUVScVVmWUNVb0lZeDdxRVVNaG85TDhUZ1oxZUs1MWlxUUhrdFBIWVdk?=
 =?utf-8?B?R1NlTlFib1hFdjBpcHQ1NnNsT2F6QUh2UVdtc05ZakZ6L3dBb0pZMnNVenN3?=
 =?utf-8?B?eHhEOUFML2RZZ0hTZHZmNU1ZRnNxWE5YMWg1N1BDZTE0NkhVWUx2aUtIN3gv?=
 =?utf-8?B?TDJHaHBGQUJXOWNmTnM2SUVoak5Eb29tYzdhT1VGQ0VsU1RxMktrLzRvUHpk?=
 =?utf-8?B?Y1FEM0RrYVY2eE16cTF4NURYejJpT1VseDNPeGJIdXdpZ290dUpIKytnS0NX?=
 =?utf-8?B?OUdtUXBSQlNPVzVTWDNoV2l3ZHRkdWQvbisrWGZrNGszODVISnpQTUx0UEll?=
 =?utf-8?B?TzVzQ25walJGbDZKSnB3TjdmVXpBaTFNL0RUa0lOdHBFeFZFQXZIUzN3dzJH?=
 =?utf-8?B?NkRZSGFZLzdYZXI0MjJUeGFneTEvZ3hRZ3E5aW1KaEhqYWNjREsyY2Rvc0ls?=
 =?utf-8?B?M3h4dkY0RjlBc3cwQnBoUmgyemlXUVJxOGhEd1RtelNqUHY1dHBvSHVGcjcy?=
 =?utf-8?B?eWlHVWs3ZDBTdXNCR25oWFFvdlhEZHA1Y2YvWksvcnI3QVRESitqcDFNWHFN?=
 =?utf-8?B?TnB6SG5nTXhzVzltTXpLYlBqd0E4YlpYYXd6amxTc3BiekdyOUo1ZTJEUFpM?=
 =?utf-8?B?RFJGcDMwcUlUVFhPSEFHUURrUUdtSjRaNEd2OE92M3BzSDFxbDBxRSt0dmdW?=
 =?utf-8?B?cVlhRmlkWkRJZkVhb1ZkeTBuS3JWSENsakp0UjJyTDdlbXI0WUh5RlF2WnRv?=
 =?utf-8?B?aTJDQmNaeWJWK2VRdzFUTmdiL3lDQXA4MHlDQ2M0QTYwK1NXRGhER0ZDR3Ix?=
 =?utf-8?B?UEpEV3ZpY0JOM2ZwQTExYW1SNmxvVFJ3UHFGR2cwWGpybXJOb3RpN21VSUdz?=
 =?utf-8?B?WkY2OHcyY1VZSEcyWk1sN29xUE5GcFhOU3hZNU1NY2xDRDVsaklWOFFnc0NF?=
 =?utf-8?B?eFAzNGsxcktmNS9wZlpzVXl3blM2bzVEbjVLY2ZQZTlzZmJkSTFnMjRJQTJF?=
 =?utf-8?B?dllzaGdlbW5KblhXM21HWG1jN3FpWjVtZmZhcGNqVnZyZTNsa0d1RFY4UTc1?=
 =?utf-8?B?YnF2Tk9QMk1sNnFyNEtocTFXMTV4ZERWamtUV05pWUU2QzBZOUpMVmNTUHNG?=
 =?utf-8?B?a3NJRWtMaDZ4VERHREtoUC9obThXS0tKTjdrSEdxMkZaSWtsb3ZOUXJaKzM5?=
 =?utf-8?B?Q2g4YmxpeERvUGtDZjJPL0lmMno0M0k1UVY4OGF4T2YzTzlsWk1NVjR6Ukk0?=
 =?utf-8?B?di9tcmNodmxGcVJWT1dPaCtNNllMNXE1NCtYbUF5UnE0cy9jRmtnUnZoWHJx?=
 =?utf-8?Q?euwvy0?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVQrTXJqMFozUUtVemNrcmVQSHIyYnBPRDA2QTFQcWlOTWVqcUgyRE1DRGJr?=
 =?utf-8?B?VU44RUg0NUhNclcyREJzVVltYUwrUWY4dVBaMWR3ektseGs2WHgxelpFWk12?=
 =?utf-8?B?NHhveW9wMlV0NnB4elpyN0hBMTRtVG1tUWwrak94L0lwOVNGRzc5L3o5c01J?=
 =?utf-8?B?aXAxVHFhZlVrdFVLNmk1VVhCQk8ycm9naUJHOVcwWEU2T093SlJNR2VheEVl?=
 =?utf-8?B?TEp1bnNsSDdXR2xyNUdBaVR4V3JucGs3OVhVWHJ6dkZqR21uY0hWbkJ6Rkx5?=
 =?utf-8?B?QW02dGRvMFpLT0ZaV2FHZzd6Q3hKcnlzRENrcmlmRForczZZOXFuaTN2UkNa?=
 =?utf-8?B?WnVxenFBZHpnSzJOU3oyOTMwdjZQYU1PLys3QlhvemhMM0tLMCtWNkZHVDcz?=
 =?utf-8?B?RnVOL0ltWlV1NFgydkNYaXZJM2JMNmZSS1NwQmE4d2hCZUkrWXNOUy9rKzU4?=
 =?utf-8?B?dXVTeDk3cnVsbHplSzZXOXA2L2RnNFNQUCtWL0lRUXptZ0Y4T2Z2VGd0M0Vu?=
 =?utf-8?B?cE1WcTBvTzBONjhUWTVmYWp4b0RuVEpUNHlibW5mRTNxY2N2dGRaU2Y3cmIz?=
 =?utf-8?B?L05VM0h4WVZrcUdPOFZnS2NKdUxpNkRxS09YWVd6ZThXMk84VEUrOEhyY25N?=
 =?utf-8?B?ejM2WXp3Y1Q2QmZnbm5nRDRMbzJzcHFBc3ozRVdOaytuTDBjRFRQbW5yUFpp?=
 =?utf-8?B?N3pCMEFoZWdYNnZYOFBGWGVLcHJ2TklTN0R5elZKbzZ3N3Y0NDRnOG9XYW1Q?=
 =?utf-8?B?ODBqZEY2OU1kaHh0bHdSeGVxVW9BTVFJUXdBb1BIWGMwTVg2MkRIb0FyS1d0?=
 =?utf-8?B?dFpaU2QzM2swd25qN1B3cktiYTY0MC8zenYzQ1lsQkk2eUg3Q212MXpaNlNX?=
 =?utf-8?B?bEJ6TU0xd0hqYVdJMWxYWmF3SHRoMjZSaGpQTXF3bVBjSkg1U2VERnhJUDQ5?=
 =?utf-8?B?dDVMNXg3UHM5MTQrL2VxNnB0UDRwTFFabzBScnF4NHFHTnhEdWpISzdlWWtr?=
 =?utf-8?B?dGY3MVA4K1U2dk9zMzRUdFdvRkVFZ0xLR2lMSWd1c1UzTm5jNEFBVjhwdzYv?=
 =?utf-8?B?ckVEa2xRSnRwcHdzRStjcisrTDIza0pNMUlYNk9hMlY4NVJDUURRVU5RUFpT?=
 =?utf-8?B?QnhGY1dPcTZQMmdnL2g0bzRpNmNzVk1COG11Q1B0SXE0c25ZM2VkNkQ0OVRj?=
 =?utf-8?B?VHRJcmZsM0FZUE1UWmswT2E3dXNuMitkVXJ0dGZzUDlyK0ZiYnV2S3NrZld6?=
 =?utf-8?B?Q0xPeURzcDU0MW5PMjF5OEZ4V0NhekJpci9ERDZjNEJjTnZGL1kwcTRNZzNO?=
 =?utf-8?B?eVJwRksxUEJoZjEwdnN2Zy9TVVJwZUlUV1JLK3RSaTRZeUZwZ0RGellNV1lp?=
 =?utf-8?B?WHFJK3UzQTQ2MnloM0pjNmF1bGN2RGgwTUozanUvV1lBVDIweWZwcis0V2w1?=
 =?utf-8?B?K0d0dVlHSUdLdTQ3TkJuenMwWlRjOC9HK1JDQkcxVkx2bVp2Vjc5QjFaMGU1?=
 =?utf-8?B?NVlrL0ZPMXE3ZUhhZXdZQ1p1eTYwMlIwV2VsLzNyU0Y5REJwU0ZNdGlrb3Vi?=
 =?utf-8?B?MU9rSG5BMU5aaDdvN095dTRscS85V2x0dW5DdVk4R29RbUNkNDJCVko4ZWc5?=
 =?utf-8?B?QmNrY3JwNWVLYUJ1WUo2aU5ZREJpeUsxMndjT2R5cmFSRjBWZXQyanpJVko0?=
 =?utf-8?B?TWVwZXVKTFB2ZW5BZnJ2TkMxSGdrSHZ3R3pvZDdCMlFRNVR6d1p1SEpyb0Rl?=
 =?utf-8?B?NEM1djJMd2lwQTQ2ckRVdzczdEVzT29SM2lPam9BbTNPSGNSTDliSGpndHAy?=
 =?utf-8?B?WkVWb2x0bXBOQWdaZElHNjZ4THkxMUFuSVRhWC9haUZzUmR2NXRITEpVRkJM?=
 =?utf-8?B?d0V5ZjdpSVdqamNycXcwSlBHY2FXMkFGYnFwVk5pVjE0L2liOVNyTmt3M1Vk?=
 =?utf-8?B?UUswWjZCbTRIV1FlOHFHR2EwZkthQ2ZmdmZjOG50YkhjZjhsQjZMRDRkV0E2?=
 =?utf-8?B?cytMcGt1bld3V1FBSzNsRTZGSGFDbFk2VGIyR2xrZWM2bmpVMGZISkJXaXRp?=
 =?utf-8?B?OEYxbk80dGpacVlCNS9Nbms3RDFESi9rR29jTUY5bCs0azRzRWdrRFRLeURL?=
 =?utf-8?B?R2pWeXJQajJhSnNXOXRDUXI0V3kzSzFZOVFpa1pvSE1PT2xoUXZMT2JFQ3RC?=
 =?utf-8?Q?cY28ZXPSmljSNvIfY3qNeAk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D277CA9FC20D1448B3CC8D78F35075B1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b277de36-7290-4d2f-4249-08ddfd4989bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 22:10:44.1389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Azci1lh9Jn8WsAxZio/2HlcgXT682bwQbPMObRCVdW9nsfp8mPZ6eb7LQ2wCIE5hXSgnQQNu4NFYEFIQkWluaxxM/vMG2jA1A5Fta2wI/i4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6028
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTIzIGF0IDE1OjAzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBA
QCAtNjI1LDcgKzYyNCw2IEBAIHN0YXRpYyB2b2lkIG1tdV9mcmVlX21lbW9yeV9jYWNoZXMoc3Ry
dWN0DQo+ID4ga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gwqDCoAlrdm1fbW11X2ZyZWVfbWVtb3J5X2Nh
Y2hlKCZ2Y3B1LQ0KPiA+ID5hcmNoLm1tdV9wdGVfbGlzdF9kZXNjX2NhY2hlKTsNCj4gPiDCoMKg
CWt2bV9tbXVfZnJlZV9tZW1vcnlfY2FjaGUoJnZjcHUtDQo+ID4gPmFyY2gubW11X3NoYWRvd19w
YWdlX2NhY2hlKTsNCj4gPiDCoMKgCWt2bV9tbXVfZnJlZV9tZW1vcnlfY2FjaGUoJnZjcHUtDQo+
ID4gPmFyY2gubW11X3NoYWRvd2VkX2luZm9fY2FjaGUpOw0KPiA+IC0Ja3ZtX21tdV9mcmVlX21l
bW9yeV9jYWNoZSgmdmNwdS0NCj4gPiA+YXJjaC5tbXVfZXh0ZXJuYWxfc3B0X2NhY2hlKTsNCj4g
VGhvdWdoIHByZS1hbGxvY2F0ZWQgcGFnZXMgYXJlIGV2ZW50dWFsbHkgZnJlZWQgaW4gdGR4X3Zj
cHVfZnJlZSgpIGluDQo+IHBhdGNoIDEzLA0KPiBsb29rcyB0aGV5IGFyZSBsZWFrZWQgaW4gdGhp
cyBwYXRjaC4NCj4gDQo+IEJUVywgd2h5IG5vdCBpbnZva2Uga3ZtX3g4Nl9jYWxsKGZyZWVfZXh0
ZXJuYWxfZmF1bHRfY2FjaGUpKHZjcHUpDQo+IGhlcmU/DQoNClRoZSB0aG91Z2h0IHdhcyB0byBy
ZWR1Y2UgdGhlIG51bWJlciBvZiBURFggY2FsbGJhY2tzIGluIGNvcmUgTU1VIGNvZGUuDQoNCj4g
SXQgbG9va3MgbW9yZSBuYXR1cmFsIHRvIGZyZWUgdGhlIHJlbWFpbmluZyBwcmUtYWxsb2NhdGVk
IHBhZ2VzIGluDQo+IG1tdV9mcmVlX21lbW9yeV9jYWNoZXMoKSwgd2hpY2ggaXMgaW52b2tlZCBh
ZnRlciBrdm1fbW11X3VubG9hZCh2Y3B1KQ0KPiB3aGlsZSB0ZHhfdmNwdV9mcmVlKCkgaXMgYmVm
b3JlIGl0LiANCg0KSG1tLCB0aGF0IGlzIG5vdCBzbyB0aWR5LiBCdXQgb24gYmFsYW5jZSBJIHRo
aW5rIGl0IHdvdWxkIHN0aWxsIGJlDQpiZXR0ZXIgdG8gbGVhdmUgaXQgbW9yZSBjb250YWluZWQg
aW4gVERYIGNvZGUuwqBBbnkgc3Ryb25nIG9iamVjdGlvbj8NCg==

