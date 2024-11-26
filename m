Return-Path: <kvm+bounces-32489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EA9F09D90D5
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 04:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5384CB26664
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 03:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19BDF86250;
	Tue, 26 Nov 2024 03:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d04Jkgo6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4A7CA64;
	Tue, 26 Nov 2024 03:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732593132; cv=fail; b=G649z6AOkp01yma3Vr6QBnU8Y5+uFF8d+AnTCgNi8eb0jERt4AkZ1p7/sECct+skLeS19+Rirhwyd6mD+gjxDS0YF5PSvKWlMQdVjIyYlm1WXP9s48asIwJpxhR06ieYm+r+XAF347wroxTTftj/pRcEu26Fd6SK7FFJGSi/wIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732593132; c=relaxed/simple;
	bh=s1eQH5wYSXk7eomAas5NDTHFa+4s1Zw1E2e+X8xZKyw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=StDIW5ouuVTI2i37fqqad0jumurzXEM1HXOVs4wtTysxDItV92d5EfoXPhC8ui11rwFMP27yGt0V2Q7yMbpMYg/Pg0YxFOSevzCTj0jy2+wtlO8zQxVcU5xJCGVQ6HDozI7A8JbMfVqlEAFnJhMpHlZOIBbMz7wmj+nOLaYNKWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d04Jkgo6; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732593130; x=1764129130;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=s1eQH5wYSXk7eomAas5NDTHFa+4s1Zw1E2e+X8xZKyw=;
  b=d04Jkgo6BWI3AiOesciDE3ZP2LbJtRHqukQ+kR3p9D0KFgor7BS/XVVE
   xgNU88k8Q5azpXVWWJfY5uAY/IlaeZhE/dcLoAww2090sNg//kqyuJY0I
   WVwMQhzdYo2Ks1fkplpAlxy35MiqeIJ9W10VxEgtJrahaoyoJ6moeHHr4
   xWSOqL6HTBMzzYfPsIqC/ww1gXq0UP7y9jJnU1e2bKTEoszEMgI0d8dkH
   pq3i+jHzHRjbQxsCCqSxpcXRGB/Zo1iJEJ6zeDdtgLgm6GZIyhDX8xgRJ
   fWolMCBSR/+glL9hbS7q3Gkcj0RCqWitHz4t3ABfyVYnVxx7jlCPPByVC
   Q==;
X-CSE-ConnectionGUID: 0TPOuvVDRKWwA7okbQHicA==
X-CSE-MsgGUID: fDYPWPCbT02/S5SIyePMoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="32590275"
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="32590275"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 19:52:09 -0800
X-CSE-ConnectionGUID: 1kSAZJLOSjOEf/qmBFILWQ==
X-CSE-MsgGUID: dudTGyrMQyqQ3ujkj4Ibrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="122444786"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Nov 2024 19:52:09 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 25 Nov 2024 19:52:07 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 25 Nov 2024 19:52:07 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 25 Nov 2024 19:52:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ViYJdeTM5UiN6pYjVrZoOJ+d5AhXDm5lnBgcB8df6RRxL4hq0aEb3rZMmWY2aV074SLUu3dC+QNfxqYtQ0r9IO6kVun8cqfFOxcY+IbgZXqYsYQ0UHssWTt9VU1o5xWS84pCDwZ8uF0X1LAl7a5uw9Iqn9QjT3BljlZNCsgwHtjxLfhkcdoTfa6v9+7zbenD4jhwd1fcxHa9iXJoLas548Dzhlzlrk7GQf1Cst3V9dwIwZvYRcjq7GlmgT9HAi1QUEO/Qmrnxkf6NhqVVDc56X3c0iagUMW9ZM5zi2KMlyIviFIYdjslLEfpYNsf5ZWlJn29QfOfIhgjXleCMWIMHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s1eQH5wYSXk7eomAas5NDTHFa+4s1Zw1E2e+X8xZKyw=;
 b=NA6a2O2sxXnfuiu8JOqQr/AZtETZgFoFCIQm7CNMWRHt6oYt2Yf5N5Gn1coC2VA/iHn4cp6BjXsbAoo02XK1061+FIpDBCzqVhGo9y9X5f60y7sRV72vq1YkhJHV6kVZcKKr9sB71FhOYP1aNTKDQvlS4ibvDB7psfd7WyRe3sd3l7RNaTkXO6gaGW69kf5zdE2utOLhvxVg0POu2XCl0hRMTqPm/fZKL+IPPZ/KfninUtukbBqstwkf5HOUt6dbEPBaQWQX4sx+tXWRavV4P0xiXUVCESXSA4rdcq2bwSXYQdlRqgda1S+DK/CcALn9jFvFMO6fyb9MMTBBAGH+IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7869.namprd11.prod.outlook.com (2603:10b6:208:3f6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.19; Tue, 26 Nov
 2024 03:52:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8182.018; Tue, 26 Nov 2024
 03:52:04 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"Yang, Weijiang" <weijiang.yang@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
Thread-Topic: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
Thread-Index: AQHbPFIlIBknYlpwZEWiEupj6OInArLHOU8AgADo4YCAAEuvAIAAMrkAgAAwOQCAACOiAA==
Date: Tue, 26 Nov 2024 03:52:04 +0000
Message-ID: <d27b4e076c3ad2f5d7d71135f112e6a45e067ae7.camel@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
	 <86d71f0c-6859-477a-88a2-416e46847f2f@linux.intel.com>
	 <Z0SVf8bqGej_-7Sj@google.com>
	 <735d3a560046e4a7a9f223dc5688dcf1730280c5.camel@intel.com>
	 <Z0T_iPdmtpjrc14q@google.com>
	 <57aab3bf-4bae-4956-a3b7-d42e810556e3@linux.intel.com>
In-Reply-To: <57aab3bf-4bae-4956-a3b7-d42e810556e3@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.1 (3.54.1-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB7869:EE_
x-ms-office365-filtering-correlation-id: 508217f8-a937-4481-30d5-08dd0dcdb11a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NzEwenlMTUNzZFY5RGVoVkVWTDU0d3JGTG94T2M1TnF0c2lGSUU1dENaQXZn?=
 =?utf-8?B?R2w1M25nc3cwN2JnbjM5eE5Ld3pVNnhUaFY2L0s0K1IyWmlYMzhHUXZ4Wkta?=
 =?utf-8?B?bkhJamprZVdROWtGck5IREt1MEtTbnJJOS95UHBWZW9YTGxjYmkwbFpWSk80?=
 =?utf-8?B?MjN3eHZZQTBoUHVKY3lNQ01uTTNCSENWWEg0MThVWEJMVkVnMkNaaU1kckIz?=
 =?utf-8?B?dW5yaE1EcTR0Tnl5VFArcTNZQ1dWQ1V0TytyS25ZSTQvU2tyK2wrU3EzSjc1?=
 =?utf-8?B?Vm4wSWY1c1pHWDMxQnZqb0cyWEE3bkxqWEdLZWE0TEtsVy9tYlRVNDJ3YXFD?=
 =?utf-8?B?V2duNEd2d2VNMkVVeEpHWlJpdW1SZWx6V3Y1cUJTdzF6YUZPZ1Brc09nVmtT?=
 =?utf-8?B?UFZoaHl3NExEUkx3aDN2K3I5ZmtPYmRkTTU2Q1dwVHBzVFNTTzRpUVdvT2hL?=
 =?utf-8?B?S2pYTWFEUlJNL3AyQk5RZkx0VDAvejc5Ym85L1dWemNJUkluemw0VjY0amdv?=
 =?utf-8?B?STlHYmJFSTJRSmFUdkVoYStoTVFEZEtnR0FGQ1Y5QmdYSUN2SW5HY0lPOHJ4?=
 =?utf-8?B?NnQyQ0x4eFZmR3ZOMXVTYll2dGxQUGZjODZlb3JJREVURHlRdFNTakFYWUtl?=
 =?utf-8?B?cjB4NEdLbVcrMTlIdEdXc0hjME9OMnBNMWtwYjVlUyt0cHBZdzlEL1hTOFND?=
 =?utf-8?B?LzRCUVJaNGhFT1Iwd0pEMUdTVGdDYk5RY0tQTGxLZVgzSWxNUkNDQm9pS3hQ?=
 =?utf-8?B?NzhjcmxYSUh5UGJFcDYyNGY2WEtlZldjNTF3M3NvcUg3S1J6ZGV1WERaTEJO?=
 =?utf-8?B?eXM1WHYzWEQ1SEgwMVhYcU9VMUFZWGpxUTBGT2I2Ym5tOS9jRy9Qcmx2QjJF?=
 =?utf-8?B?TmFVRlhvRytxUTY1NUw1Q2FxaVVSUVhqVDQrWFhsTXBkL25VS1NRaWltc3cx?=
 =?utf-8?B?T2JVcVlQbVUwTUhXRnA2N3QvallHU3hmdHZPTEUyR0FWdXhjNXJTWjhaRFE1?=
 =?utf-8?B?RUhhWWdIS1NwUTN0b2RLM3lMQk9uMi9Ib2tNNmZYNERXbWhJUTFLaVpWMGQ4?=
 =?utf-8?B?ekU2cDBxRlhnWS8yNDNHQW5BR0Rkb21MMGFZSk0vZUJJQWxKSFk1R2M3dTZs?=
 =?utf-8?B?emZ1RlJHbmdyM2Jia0VsL2ZuRmQ2WGVINmZSNzJuVm9DUDdMelJnbVlyY2x1?=
 =?utf-8?B?MEphVGFWUmc2T1ZvOHhlV0xKRTZpVUprTk9SenFhZHkvZVFXUjgxeUtCdEF6?=
 =?utf-8?B?bElHdVR3cFVITnZMSmdOU1V3SWdmbjZsVzRDdUFORlhZeWlsNnVqU1lhTFN3?=
 =?utf-8?B?OXRvbklXTlBSeXY0MkcxdXVnMDU5QnRidGFJdFFOSjdWaklzOHc0QXJHMEhl?=
 =?utf-8?B?bzRCeWJCdDFYM3lVRGJ4eHViV3crY3hNMkRpOTArcEpxY2p2dDJXWjZJVGJR?=
 =?utf-8?B?aWtpMUtwUExmSjNOZldYc3dwVUdSN3gydkFwMkRnMjE3dmhuMTROeG1NZ0tF?=
 =?utf-8?B?cG9jQytodEhUV1AybnNkcFFVd3RYMlo0UHdYMzJtbU94UzIzQ2FzbmJRU0ZU?=
 =?utf-8?B?WXoxRTVscTRqcVJxc01zRzYxNFpDaDhJRzI2REVCOGZycE1OREg4K3BRRlJS?=
 =?utf-8?B?V2lVYmphSy9QTzRuMlhGdmpGQzZYcmcvQWticzJ0TUFSRVAzUzBsYXJnVDNM?=
 =?utf-8?B?ZHNHOEdFSHNsV2MrVHRCdzUwVUxKcnQxR2xocC82RnNSLzArNlptaHdvZVoy?=
 =?utf-8?B?Sld2QnpoZ2d2OWs3Nk03dm16MlYrem50R0EwTkNZSklKa3Nkc3F1d2tKcmlt?=
 =?utf-8?B?Nms0WW1aczhnYnB4amJ2bFF6Qi80bitJOFB2bmRDSWI2OFlDdm13d3dhRUNo?=
 =?utf-8?B?QmJOV2NyRlhUMmFtbFJnOVhZNDFiNUtOZ1dkVHJPTFNxWWc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ujk4bzFwZTN4ZzRFaXVrM3ZIdzd4UjFpV2J0YW0ySW9TQXpxUDRyMU0rZCsz?=
 =?utf-8?B?bDVQQVFUZzk4Y3pkNWpkVUFaaGJOWDJlMUxkbFFXTGsrMG9aL2NmWjhSU1Fm?=
 =?utf-8?B?V0RXamVCcTZxSS9UNWMyL2t1TXRlY0dYUVl2UEsxNVloMVI2VEkxVGN0QU5i?=
 =?utf-8?B?bXAyQlhXbnFoQW4yZU9JUUMxZTJqSEtvZEZGcUNZVzQ5blB2UURZRzltR1lY?=
 =?utf-8?B?TlBzekJia3FPOEpveHlXSzlwOTIwSHVuWis2MUhwYW92Z0VTNTlaVEU1SVcr?=
 =?utf-8?B?c21VcFFWeDVRcnBKdlU0dUIxNFNWN1BRcTRIVkYveFppRlNrR1k1amM4MWZ3?=
 =?utf-8?B?WGV2alJGaUVpZGZRcnF6KzZyTW9LbDBSajBPbFEwdm5vaFJDWGJ5aWpodWdw?=
 =?utf-8?B?QlRPVkp6Rm1pUUdaQ25DWjRWMW5VaWxObUMvT2tJN0ZkRk5SU2cveGFhbHJn?=
 =?utf-8?B?c3dHaWxUWHI3eUE2dzNCWk9hb1RjQUhRdmduRTA4Yks4ai91ZzNuZkR2Vlhk?=
 =?utf-8?B?VnZOMHZvMmhWbU11MzRxQmlHV3VPekVWWXoxdlpMU0tvamxXYzVOYThLTWRh?=
 =?utf-8?B?TDYydnZiVGcrTjQzWlhHQTBpcnRhaUtuTmxvL3dVS2t6VWhUd0RoMitFMVNQ?=
 =?utf-8?B?bUZFc2lqOWp0NDlmM0tCV0VpZS83YndFWU1Eck1KNjhtSVE2U05OVU1oOEdN?=
 =?utf-8?B?UDhwMjIvcUJYaUpXQjlvQ3NmZjYybVNEcmZ6MzZVM01Zb25IZkVsMFJGZTFN?=
 =?utf-8?B?THdGc29MdnNNeTZXVFhRa3kzNXZwSFBlRXB5d3lmVkxqU3Nqcy8yOW1uS1N1?=
 =?utf-8?B?VFpaSHRweUNtNkpGeSthNGJQaEs5a0ZWeFh5U0k1WkRod0NuTlN4blo3VFV2?=
 =?utf-8?B?RktoL3dTWXBGQ3pWN2VDYWExRVF0c3pUeS81YXdMbXkySVpVcU1PRUJiSENr?=
 =?utf-8?B?cm9yL2V0UUE5a2Jhdi83SmJTYis1Ukh5Z2FZbWNNUmd3b1ptYmN6dURJdVFS?=
 =?utf-8?B?dmhVcENSOWw2SXUyckltdmdnejJMVWxwL0VRVk9NOWY5T3VlS2U1aEVhQjRj?=
 =?utf-8?B?eEFLWTVaWWt3TGp4ZkFKWUtjOEYwd1BRYjdEa1ppY1UxblVqVi9IeFQ4WHNh?=
 =?utf-8?B?M0oydytpOFBTNGpNRWtub3ZHT3RnM2ExaGhheTZQNStXTXlwNkJpQ2VNcVA0?=
 =?utf-8?B?a3o1LzBtb2V5NDBYRHlqT09XdXVBdzU0dUk5cHc4a3pDQVhZY2hpVHhwaEQ1?=
 =?utf-8?B?VG9KOWxqWVZtanovci90NXQ0ZjBLMzVoMFk1emNtK2U3enVtMEVFMW1pS0p2?=
 =?utf-8?B?N0I3T21ldW9KaENqbTBwYXVLV1MvV1FjS2Z0WnBUeUpCQXUwRWp2ZVIvRzR0?=
 =?utf-8?B?ZHYvSXVtQm9Gd0RGWmZXQWxtSDh2RTVoWDZEamVreDgvMnBDQldYSWVvZC8w?=
 =?utf-8?B?ckcyYTBScGtOdXVXdFNoTFdzbFRkaG9BU0s3QmVBRExScDRHQm83MnVSbnhO?=
 =?utf-8?B?NWJ6RHFGRVZsNjFUV3VWMFVDaXZ5OWlDazF2V2tpdjVHKzIzNDM5VUpOTXZY?=
 =?utf-8?B?NXVXTXh3bm51TUlmZTJKK0h5dG1TNVByZFkrSjhWK0VuZnZDbVdnL0dRRnpP?=
 =?utf-8?B?T05QMFVGL096S1llbmJQWGpvTXNhVFg4OEZTeTNCMDNxUlFOcEQwTGNpQit1?=
 =?utf-8?B?S2dJamZVK3FMamxycTRzRk5rY1FaNE1vRWJNTDMrajF4Z2kxdENOVWxUT1hN?=
 =?utf-8?B?S1NUVVlYWndCRmd6SkNwTUFSS0NzV2NMNVlTb2duZGdybHBNZEo4U284OUUx?=
 =?utf-8?B?VGJPYURyd0dDMnFvOTJ6ZFZNODZzeXdPVm55VWRnWnRNbEhBMEs0bmpiVURy?=
 =?utf-8?B?czVxaS9KMnBVUGhSZVJ2bjk1Nmg0ZEdNTXhKWnZaOVdGNTlKL0dOMHlmYVd5?=
 =?utf-8?B?Zjdja3pKVEo1SUlWUHpRUUZleDJBbExGdDczcWhSRGtrZkJUejJIdTFHZjBM?=
 =?utf-8?B?RGMzOWVRd0laT1FFZUpzem5qYzVWUCt2azhlTXJnbHU4TGV3ajdZaGJVVE9K?=
 =?utf-8?B?Ty9oN1pXTEdrUlR3dFNWMmkvR2dlSlJTVUxJdm5NR1QzTlRvem1rcTNJMHh6?=
 =?utf-8?Q?NuYjzvbFnaTHwxxb2UApAWaLk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <150FD7B4111D9340BF8673EACEF1FC8A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 508217f8-a937-4481-30d5-08dd0dcdb11a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2024 03:52:04.4830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 74O5OYDXtXtVq+SH0XXWGM6glCB9iU2jsKnp52qbWCGE8W7/1fnsjMoQeoq1l9z4mA1GQjV/8H8ExSDdnXEROg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7869
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTExLTI2IGF0IDA5OjQ0ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IA0K
PiANCj4gT24gMTEvMjYvMjAyNCA2OjUxIEFNLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0K
PiANCj4gWy4uLl0NCj4gPiBXaGVuIGFuIE5NSSBoYXBwZW5zIGluIG5vbi1yb290LCB0aGUgTk1J
IGlzIGFja25vd2xlZGdlZCBieSB0aGUgQ1BVIHByaW9yIHRvDQo+ID4gcGVyZm9ybWluZyBWTS1F
eGl0LiAgSW4gcmVndWxhciBWTVgsIE5NSXMgYXJlIGJsb2NrZWQgYWZ0ZXIgc3VjaCBWTS1FeGl0
cy4gIFdpdGgNCj4gPiBURFgsIHRoYXQgYmxvY2tpbmcgaGFwcGVucyBmb3IgU0VBTSByb290LCBi
dXQgdGhlIFNFQU1SRVQgYmFjayB0byBWTVggcm9vdCB3aWxsDQo+ID4gbG9hZCBpbnRlcnJ1cHRp
YmlsaXR5IGZyb20gdGhlIFNFQU1DQUxMIFZNQ1MsIGFuZCBJIGRvbid0IHNlZSBhbnkgY29kZSBp
biB0aGUNCj4gPiBURFgtTW9kdWxlIHRoYXQgcHJvcGFnYXRlcyB0aGF0IGJsb2NraW5nIHRvIFNF
QU1DQUxMIFZNQ1MuDQo+IEkgc2VlLCB0aGFua3MgZm9yIHRoZSBleHBsYW5hdGlvbiENCj4gDQo+
ID4gDQo+ID4gSG1tLCBhY3R1YWxseSwgdGhpcyBtZWFucyB0aGF0IFREWCBoYXMgYSBjYXVzYWxp
dHkgaW52ZXJzaW9uLCB3aGljaCBtYXkgYmVjb21lDQo+ID4gdmlzaWJsZSB3aXRoIEZSRUQncyBO
TUkgc291cmNlIHJlcG9ydGluZy4gIEUuZy4gTk1JIFggYXJyaXZlcyBpbiBTRUFNIG5vbi1yb290
DQo+ID4gYW5kIHRyaWdnZXJzIGEgVk0tRXhpdC4gIE5NSSBYKzEgYmVjb21lcyBwZW5kaW5nIHdo
aWxlIFNFQU0gcm9vdCBpcyBhY3RpdmUuDQo+ID4gVERYLU1vZHVsZSBTRUFNUkVUcyB0byBWTVgg
cm9vdCwgTk1JcyBhcmUgdW5ibG9ja2VkLCBhbmQgc28gTk1JIFgrMSBpcyBkZWxpdmVyZWQNCj4g
PiBhbmQgaGFuZGxlZCBiZWZvcmUgTk1JIFguDQo+IA0KPiBUaGlzIGV4YW1wbGUgY2FuIGFsc28g
Y2F1c2UgYW4gaXNzdWUgd2l0aG91dCBGUkVELg0KPiAxLiBOTUkgWCBhcnJpdmVzIGluIFNFQU0g
bm9uLXJvb3QgYW5kIHRyaWdnZXJzIGEgVk0tRXhpdC4NCj4gMi4gTk1JIFgrMSBiZWNvbWVzIHBl
bmRpbmcgd2hpbGUgU0VBTSByb290IGlzIGFjdGl2ZS4NCj4gMy4gVERYLU1vZHVsZSBTRUFNUkVU
cyB0byBWTVggcm9vdCwgTk1JcyBhcmUgdW5ibG9ja2VkLg0KPiA0LiBOTUkgWCsxIGlzIGRlbGl2
ZXJlZCBhbmQgaGFuZGxlZCBiZWZvcmUgTk1JIFguDQo+ICDCoMKgIChOTUkgaGFuZGxlciBjb3Vs
ZCBoYW5kbGUgYWxsIE5NSSBzb3VyY2UgZXZlbnRzLCBpbmNsdWRpbmcgdGhlIHNvdXJjZQ0KPiAg
wqDCoMKgIHRyaWdnZXJlZCBOTUkgWCkNCj4gNS4gS1ZNIGNhbGxzIGV4Y19ubWkoKSB0byBoYW5k
bGUgdGhlIFZNIEV4aXQgY2F1c2VkIGJ5IE5NSSBYDQo+IEluIHN0ZXAgNSwgYmVjYXVzZSB0aGUg
c291cmNlIGV2ZW50IGNhdXNlZCBOTUkgWCBoYXMgYmVlbiBoYW5kbGVkLCBhbmQgTk1JIFgNCj4g
d2lsbCBub3QgYmUgZGV0ZWN0ZWQgYXMgYSBzZWNvbmQgaGFsZiBvZiBiYWNrLXRvLWJhY2sgTk1J
cywgYWNjb3JkaW5nIHRvDQo+IExpbnV4IE5NSSBoYW5kbGVyLCBpdCB3aWxsIGJlIGNvbnNpZGVy
ZWQgYXMgYW4gdW5rbm93biBOTUkuDQoNCkkgZG9uJ3QgdGhpbmsgS1ZNIHNob3VsZCBjYWxsIGV4
Y19ubWkoKSBhbnltb3JlIGlmIE5NSSBpcyB1bmJsb2NrZWQgdXBvbg0KU0VBTVJFVC4NCg0KPiAN
Cj4gQWN0dWFsbHksIHRoZSBpc3N1ZSBjb3VsZCBoYXBwZW4gaWYgTk1JIFgrMSBvY2N1cnMgYWZ0
ZXIgZXhpdGluZyB0byBTRUFNIHJvb3QNCj4gbW9kZSBhbmQgYmVmb3JlIEtWTSBoYW5kbGluZyB0
aGUgVk0tRXhpdCBjYXVzZWQgYnkgTk1JIFguDQo+IA0KDQpJZiB3ZSBjYW4gbWFrZSBzdXJlIE5N
SSBpcyBzdGlsbCBibG9ja2VkIHVwb24gU0VBTVJFVCB0aGVuIGV2ZXJ5dGhpbmcgZm9sbG93cw0K
dGhlIGN1cnJlbnQgVk1YIGZsb3cgSUlVQy4gIFdlIHNob3VsZCBtYWtlIHRoYXQgaGFwcGVuIElN
SE8uDQoNCg0K

