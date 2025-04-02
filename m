Return-Path: <kvm+bounces-42521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B42C0A7980F
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 00:06:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05CEB1895FA0
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 22:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2726E1F4E34;
	Wed,  2 Apr 2025 22:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="huhrrakJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DAD1E8326;
	Wed,  2 Apr 2025 22:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743631567; cv=fail; b=eVFHq6eLl4kCtX+3/ETtCR11ycBxmrEEaHMAi7yjr+axOCrZzC8PRthm18MmRk2N2Bg80nPPNkb4/OdK8PE5Ngs9GNAVEUFUDl9i7YhTDEXYi/Dela1r3hQjl34pb8OOo4QQcuD+bzNbZPhdzPGfKqnwjvd5JF7GtBvuu7CoXNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743631567; c=relaxed/simple;
	bh=2FUWJXJdJsk4taCp8hwL5QTUAvKVpyPFLAzhztbxH3k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GJ5Suv2zfgimYzGvWgbEZzlFIheofXD7bI5fxgMl8tmF9tN0urEX+pcVP1ZepNmkPCdrU+USbdPFbl9GHyGwJaK0T/fUb7x6yieiZXWVucCk6kQNoJsz3AAIw8dOYDspFtW+HFyJgIgZK6reCx59nTAoVcxda1crMmQ1GcBTmZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=huhrrakJ; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743631565; x=1775167565;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2FUWJXJdJsk4taCp8hwL5QTUAvKVpyPFLAzhztbxH3k=;
  b=huhrrakJixHO57EwjiPh6K4Kw9jsz1g3fIbBK79wK783sCxTns/iugD8
   Odr6OqXRiIsgYy5D0lZ0VD6JMQt/fzH3zB0f/Pvbn3eBsuHYwF4Z5x8Ev
   rca037T0XzEBLVNcdCwu2m9gBE/k6tlW+XuRlNoG7r2lSauDLi2T4hQ1D
   zAwtsE7xtQmZWyWdd9ZKKj0F7Uz5dPsqwI6DBipiv516ujRI7yXVNzhIP
   MxeqSxkabhhDjHC2pCc7s4KwBHnJGP+IAVdEo2s8ObrEZyEW9DbKVQcmt
   R9lhUj/7rqVP/vhwKbPXccH7kEV28n7+D7PTXzoYVyuUOyPOsir7Y4mm5
   Q==;
X-CSE-ConnectionGUID: AAVZT01ZSLmYTis9kuibyQ==
X-CSE-MsgGUID: etLlGJ83Tvugov57FNwYnQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11392"; a="48684722"
X-IronPort-AV: E=Sophos;i="6.15,183,1739865600"; 
   d="scan'208";a="48684722"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 15:06:04 -0700
X-CSE-ConnectionGUID: KctZWWKWSt6V1f5vqrnLEQ==
X-CSE-MsgGUID: uZ6+5PexTE68RqoONi911w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,183,1739865600"; 
   d="scan'208";a="127320433"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 15:06:03 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 2 Apr 2025 15:06:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 2 Apr 2025 15:06:02 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 2 Apr 2025 15:06:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kl+E0vDjKZ9k36PJPjIM8teC8opIFhkp43WzGM1jRYMbbxBKTjFncoQoT9ZkMeCTcqpkh6wCajWYXt6taxXhMs/vmHVK+Vv6EJykPt/5imtF55RWH/QM8xUknrh2qqVBRtiZCOwlxlrg9Z1RJqtdeCrhGO6Na/yqfJGUvLlI4KrUENQDSkQUBi7YY5aB4WwR4HxCm204Fcv1SrJnCVQwvTQBMOjrgSFs2DgbhvHc6lY6gB5qbp0crjE2nuyfjJHIm3/1MLw3oKJsJbDCvxyzjdLB1iklhOu38c41BF6NHdb07vZ3pzmIzDHcHGeCUlBpkd4JfrsvAoPmjIK1xxb7lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2FUWJXJdJsk4taCp8hwL5QTUAvKVpyPFLAzhztbxH3k=;
 b=r/Qu2Stcw/1jkJpE//56LY47vBEVOyV7ZCFShCmMrhNlStucUp32iiCb1byKgQwMF1yHIHaRaKEpgWW0GpCrOhzxLizOao2Rf5oNaRWPj8QPHNXtUqjI2WebSrZ4B5FrvOXNpanp3eRE4Y6IEs+6CRzntLdSAZAsgLAfRRPy6fT2eR0JVyy3peJ4JNLDTUOnMmZ9YhM85ukMCzvXDczYySuPWn0b61226dzP3l6Hfa+qNrVaMW7YgjT01ullb/zlugppqxrd+btw3ok1K1E8/B9kOVD+uabDim8cwyPV2yCO31sEd5bf0IoHKFHQTA8iLRR5yfe8jVveYErcMk3P9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB5971.namprd11.prod.outlook.com (2603:10b6:8:5e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.52; Wed, 2 Apr 2025 22:05:58 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8534.045; Wed, 2 Apr 2025
 22:05:58 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "Gao, Chao" <chao.gao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Lindgren, Tony" <tony.lindgren@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Topic: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Index: AQHbo2Q+reE/k3eiXkm8HRe31hfG0LOPjGSAgADJMACAAAaQgIAAk90A
Date: Wed, 2 Apr 2025 22:05:58 +0000
Message-ID: <46d208b59038b5e4dce3122d7efe85f9106dae32.camel@intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
	 <20250402001557.173586-2-binbin.wu@linux.intel.com>
	 <40f3dcc964bfb5d922cf09ddf080d53c97d82273.camel@intel.com>
	 <112c4cdb-4757-4625-ad18-9402340cd47e@linux.intel.com>
	 <c96f2ed1-1c7f-4b61-85ff-902e08c61fbc@linux.intel.com>
In-Reply-To: <c96f2ed1-1c7f-4b61-85ff-902e08c61fbc@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB5971:EE_
x-ms-office365-filtering-correlation-id: 233634d6-b4f7-46bd-a810-08dd72328c31
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?My9ScysyMk1UKzZCTFh3K0R1OHhrbUlvUlBVWC9iWVhWZjVpZVJhRkVEYmc0?=
 =?utf-8?B?SlpYT0xvQVZXbGp0L2ZqMU5VQ3FUSTBpbVFCMHFxd3Z5NjJBd29RUUIzQ1ht?=
 =?utf-8?B?aGxseXE4K0g1bXZWQlNWejZCV1pEM1UzUTU4cko3ckorNEdmY1NrNHMva205?=
 =?utf-8?B?UkxmSDAyMGJ3T3NXbm5hSllGVldDK0JsdU1WMUQ5YVM1L3ZQOFVLaEk2VlJv?=
 =?utf-8?B?NFNYcFc1N1dyYW5EdVZhcW15TGxvK1Fva1Bza2ZBNmRGQUtIK2xCaGtRU2x1?=
 =?utf-8?B?azRLTTdnK1RaR2FmTSt4OXFzRFZuMG9BZGx5aXE1V2YrMk4vam93OFVaLzJi?=
 =?utf-8?B?TjRLODRFcUFMVk8wbG1DQWpCMExKNWNGVDhKY3JTQkNvQ2NQVlZnVjI3ZStK?=
 =?utf-8?B?YzV0a1F6OGYwNmJNZEJyRmY5eXp3Y0FvV2Q2cDJzRjdWcmlBQmNsZVdxQzhl?=
 =?utf-8?B?bUtjamVpYUZuNXl0YVdLY1cxVDZNUzRpbjdPVW1TUCt4bXpMOTlwWUpSM2Zx?=
 =?utf-8?B?MmkwWlhPckRRcmNZM1BxQUIvcEN5dTdiZjdIV3d5R3BaTkRTQ3Y5dDc2OGd1?=
 =?utf-8?B?Z0Z0RndSY0FrclVTNDhzMllkdGRkOFNNT1dBZGF4c2JLcnd4cXdlQVBtQTVE?=
 =?utf-8?B?SXJsbWtDWDhoVzJ2blUrbEcxVmx4R2hQREhBTVh5WkEvak1tY1ZuSk45TDFr?=
 =?utf-8?B?bjJzRit3Y2h5T1JQNkhBakRVVUt0ZHBQbFByTHg2bko5QTZTb0dzMTJxRUlJ?=
 =?utf-8?B?T2owZ1hWRjIxU21KSHl2VFRaYmx0T0RrS1F4RzQwWksxSWlJSmlVdmFKeE9T?=
 =?utf-8?B?Y2NWNVBVOUQwNVcwWVNxclgwOHU4cXNIL25OS0lEVEVJczgxSXJhSHpQMmF3?=
 =?utf-8?B?bnpHcXhPbWlVS3orN1JQckY5anIwUW5MOENVclBEK2lWSTBuV1MzaG11aVlo?=
 =?utf-8?B?OUFSdzBsWWhhYTlFVlVsN2piRkxUblFtOVo3bmNUR0xHaVgzMlI1blBrM3d4?=
 =?utf-8?B?TjkxemZWQXp6Q1c0TjdFclNBQkl5bmg2T2ljV1N6RWZXWTBxczE1b2J0elRH?=
 =?utf-8?B?QTBUOG5nSGJSZytFUXV0Ums3cDR6NWtYUXZCUzdDUCtNeHh3SXMwR0JYMUp4?=
 =?utf-8?B?b2FiQWplemhPWkpwSVdtUFd1TVNRdHhqSmRzQk1XYWxOUDFkWS8vcXA5aFEw?=
 =?utf-8?B?VW8rRERPazdjSEU4bXJGM3VaZTU2WkRDcWw0Q2JLb3V5aW9uOGhNd3dUQnFB?=
 =?utf-8?B?ZzlXU3AvWmlRcUM3RzZSV3dkaEFPUXM0K0pXTHh4WlpEY2U3SmRjUDh4aWFX?=
 =?utf-8?B?dXJDc05jUnBNYkpqaFZDZzMxb0g3VWZEVzZTZHRVOEE0emdiUWdqeHBwMVJN?=
 =?utf-8?B?NEFKblY2MGhPdHZGemhlZU1YSjdxMDhyRXhuV0ZZSURsZmU0YWNVREpIdlpO?=
 =?utf-8?B?TVl5VlRsRmtJejV1aWkxYlZjdlJ3UVFkc3pka1dSMzBuU3BhaXo3c3lPc0Fl?=
 =?utf-8?B?dkdLQzl3OGhDb3dwM3Q5NmpjMVd1b1dtSWNlRlpJUDBTOFVPRmlveDRXMVBC?=
 =?utf-8?B?Vy9mei8ybzJaZjZhcVV2eXZHUDNwb05CVUdRRW9GbTZEN2NGMmdxMlluMWR1?=
 =?utf-8?B?Y3dHM0xmVnNyRnV4Zmx6U2JEdnpHTFYyQ3dTVHg2TVJtZWc1VUJsTmhWTldv?=
 =?utf-8?B?cmhQTEpZemtvZTRocjFvT0x4S09rR3k5a3R1VVEzY1pHVmxvSGgva0p0MTZp?=
 =?utf-8?B?aytSSEZabW5iWmRtN0ovU3Uyem9PdEVDS0RNNFhSNTdDRlpjM0kwVDhXVCtu?=
 =?utf-8?B?UGd6aE1xUnM5STBYNTRTRkxHb09vb05YRXh1M1Q2dEMvdVAwU0VQWi80VlJw?=
 =?utf-8?B?TU5ZaXl0aklEaXpTU2drNEEzcXQ1aHArSTl2ZDhYNGdraVJhczBJSWdMbHhh?=
 =?utf-8?Q?RZF2iHIkl+EUzZ1odabD1CpQw+LNNKO1?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzcwZ3RPTEErMGZBWlcwbEhwazAvaVBNMnc1NmczUXhINmNKSW9QTmdTZ0lY?=
 =?utf-8?B?MjFFVStMOFRYYVFtUDdLTm9TWW83UlBpakdqNm9XWCs5cWVBeUpoVWI2NzVH?=
 =?utf-8?B?a0pQdzN2RXFXUUpUNWZJN010R29BSjNOaEd4ZEtkVGcxS0FVVmprb2RZbi9B?=
 =?utf-8?B?VkdGcDNObGdyRjN3ZjhMOGp6ck5rY0V6SHltSDhpSEcwQmZDMmNjVUFjQVFt?=
 =?utf-8?B?SG1HdERIUjc5NFJBc1ArUFBOSUs3WG93WStkQlJDb25tVHVqam1vanRGRklm?=
 =?utf-8?B?SGV5cmp1Z201bDRhOTJCU3c4NEgxUUp1R2JaaFVoeXYwRGR4OC8rcWhJaHdC?=
 =?utf-8?B?OFpxbFF1dWQ1ZllUU3U1d3M3NjhEUTh2NmRrdEhUVDZRZVFWOE56Mk5BUm9q?=
 =?utf-8?B?dTBaS01xOVRaNXoxeDFPZG9IWi9rd01uYXh5UmltVXZnYlo5MzJNUHVjbjdv?=
 =?utf-8?B?WE11S01wa09pN1BmNk5rQmtPUFA2QVVoTm1WK1N1dkNIQlNLeTh3NVZ5NUUw?=
 =?utf-8?B?QVg2eUJ0eXo3TWFmTU5xSmp0Uko4VFJ2bHhJRk5oSno3RVZ1VFFZME56WGpn?=
 =?utf-8?B?Ly9hdW5BNzVUN09Rb1ZBaURSN3czeGhYU2dvWGwxVjVDN0drT1RJRjMyaEtW?=
 =?utf-8?B?UGRzRnNCYTlINW1VeHU4cVZxdGozdDdlVjJFdmtHK1JPN1ZkMzNjOVR3Q0d2?=
 =?utf-8?B?dGluQkh4NEpodTc4bDUzNUpQSndXQ0dkODdKeGxVR0pZRHo1VEdsNmZwSWhF?=
 =?utf-8?B?UWwwZzBaNGZOZUZuOEhrU2wySk9EODdmTGJRVXd4ckhBMlFXbHMrRmpVY2hh?=
 =?utf-8?B?dGdTeVM3N21RUXNDdUJ2a2U1cWgzZll3L1FxTmdZM0pnbmUzMlVUdm9BbGEz?=
 =?utf-8?B?WDZOQU9adFBHTVF0cVlmSHF1TTFSY1BKZHE1VGE0bWZISm4xcHJLSGM0NjNO?=
 =?utf-8?B?TGNSYzFUZEhycVJ6MkFDOGpwNGw5TGh0ZThSQ3JaNi9ZNUl5TUFvRHU1N1M1?=
 =?utf-8?B?bmo2UkdSd3dnNmpSS1pjL0JHMkZDUGx3NWNhQ1lub29TRmFWdUlTbDhPZ2Uv?=
 =?utf-8?B?cHJUdUxscFhjSzVUY0g3UjcwTDRhRzAwdVRTZ0dFZDN1VmtvZ1NUaWpkOUto?=
 =?utf-8?B?cC9qQVJSSS9nemlFOHJTcnV1SXhrWTRQemROYUZWN1FuckNSUUhUZHNLdDIv?=
 =?utf-8?B?bWV0MUIxTWZxQlQ2S3Z4MmkrWnVXMldldTc2S0cya3ZWb1gycitOTEMrVEVl?=
 =?utf-8?B?dERibk11d0EycVBrWmowMDRQbnhTMm1saXkzQkNndUV6TDJjdStjQWYvTXlx?=
 =?utf-8?B?UEdWOHRrRkU0c2NvSWtpV1VudXJYWGJkR1c0dG5NZDRBMi9oRGlXOFRFRkx1?=
 =?utf-8?B?YXUzOWJsRTFlY20yTlVROWdyN3BTZm9SUHhxcVBPT0xFMGJEMUcyQjhVcHBz?=
 =?utf-8?B?SmJGS1grOTF0YkxkWXlZNko3aU1lSlBTY2ZkL0F2dmI3eVlJaDNMWFpYc1Zo?=
 =?utf-8?B?blRZZW0wcXNiNGNFOE45b0hNRTd2RUxSVWFnZVcyME1wY1BOS3dyWTdsUkxt?=
 =?utf-8?B?SVBPR0l5WWJ0NysxOVhCM1Z2ZnFiYU1lWEk1VmdBMTZtejhEVFRxZjhBY3RZ?=
 =?utf-8?B?ZE5jVVQzdkhPZStkZ0pINDFYaFNZU1hPOUNqUk5YeHBPS1Bxd1VPVC90UEtS?=
 =?utf-8?B?dWo5U0d4bzhsclVmaUJhSTJBU3gxc0luRHcyMm9kSWZycDNEUTYvRzZ6cmhu?=
 =?utf-8?B?N1U1aHBqcW02ZHRyYXB3bDFGK1ZBakE0VVNSV01pZjcwaFU4a21Ma2VuT3Q4?=
 =?utf-8?B?NFJTSUVnenRuZG1Ddis5K3krUUNObllWWm5SZFUxNThzZXE0QU9jMjZJTEp3?=
 =?utf-8?B?VDRDRVhGL2dxajJlbkE3K3hkcmNwWXhzelh4Y3Z6dCtmUnRLSTFLdlpwdXI2?=
 =?utf-8?B?VmhmS1JGZS94TFJBMG1YYlBlMVY0R0thYjlYS2NrYW0vcnpteEJleUhFaCtN?=
 =?utf-8?B?bGV5Wmlwdm5KcTdDa204enAxU3J3dk9XN3pQQ2U1MHIvOFRKZzlQcnovQUxi?=
 =?utf-8?B?dW45YkZDUHJVTFV2THNuRmVUU1NkelpVa0dxRVVFK1dhYWtQcWRVUThPdmVR?=
 =?utf-8?Q?BxyX139NzO//1tUCl+qhA5aoz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A60252B06CA15446830645AA3690F478@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 233634d6-b4f7-46bd-a810-08dd72328c31
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2025 22:05:58.1927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NIMJyBdcDHs9Ah6T3WNk3o2cUoGhxvFDzNSirRrBd/fyUq3rmn/NuxGEzcdS2O6hPOSaU511vZbp9w8MNuCngw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5971
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA0LTAyIGF0IDIxOjE2ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
PiA+ICtzdGF0aWMgaW50IHRkeF9nZXRfcXVvdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+
ID4gPiArew0KPiA+ID4gPiArwqDCoMKgIHN0cnVjdCB2Y3B1X3RkeCAqdGR4ID0gdG9fdGR4KHZj
cHUpOw0KPiA+ID4gPiArDQo+ID4gPiA+ICvCoMKgwqAgdTY0IGdwYSA9IHRkeC0+dnBfZW50ZXJf
YXJncy5yMTI7DQo+ID4gPiA+ICvCoMKgwqAgdTY0IHNpemUgPSB0ZHgtPnZwX2VudGVyX2FyZ3Mu
cjEzOw0KPiA+ID4gPiArDQo+ID4gPiA+ICvCoMKgwqAgLyogVGhlIGJ1ZmZlciBtdXN0IGJlIHNo
YXJlZCBtZW1vcnkuICovDQo+ID4gPiA+ICvCoMKgwqAgaWYgKHZ0X2lzX3RkeF9wcml2YXRlX2dw
YSh2Y3B1LT5rdm0sIGdwYSkgfHwgc2l6ZSA9PSAwKSB7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDC
oCB0ZHZtY2FsbF9zZXRfcmV0dXJuX2NvZGUodmNwdSwgVERWTUNBTExfU1RBVFVTX0lOVkFMSURf
T1BFUkFORCk7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gMTsNCj4gPiA+ID4gK8Kg
wqDCoCB9DQo+ID4gPiBJdCBpcyBhIGxpdHRsZSBiaXQgY29uZnVzaW5nIGFib3V0IHRoZSBzaGFy
ZWQgYnVmZmVyIGNoZWNrIGhlcmUuwqAgVGhlcmUgYXJlIHR3bw0KPiA+ID4gcGVyc3BlY3RpdmVz
IGhlcmU6DQo+ID4gPiANCj4gPiA+IDEpIHRoZSBidWZmZXIgaGFzIGFscmVhZHkgYmVlbiBjb252
ZXJ0ZWQgdG8gc2hhcmVkLCBpLmUuLCB0aGUgYXR0cmlidXRlcyBhcmUNCj4gPiA+IHN0b3JlZCBp
biB0aGUgWGFycmF5Lg0KPiA+ID4gMikgdGhlIEdQQSBwYXNzZWQgaW4gdGhlIEdldFF1b3RlIG11
c3QgaGF2ZSB0aGUgc2hhcmVkIGJpdCBzZXQuDQo+ID4gPiANCj4gPiA+IFRoZSBrZXkgaXMgd2Ug
bmVlZCAxKSBoZXJlLsKgIEZyb20gdGhlIHNwZWMsIHdlIG5lZWQgdGhlIDIpIGFzIHdlbGwgYmVj
YXVzZSBpdA0KPiA+ID4gKnNlZW1zKiB0aGF0IHRoZSBzcGVjIHJlcXVpcmVzIEdldFF1b3RlIHRv
IHByb3ZpZGUgdGhlIEdQQSB3aXRoIHNoYXJlZCBiaXQgc2V0LA0KPiA+ID4gYXMgaXQgc2F5cyAi
U2hhcmVkIEdQQSBhcyBpbnB1dCIuDQo+ID4gPiANCj4gPiA+IFRoZSBhYm92ZSBjaGVjayBvbmx5
IGRvZXMgMikuwqAgSSB0aGluayB3ZSBuZWVkIHRvIGNoZWNrIDEpIGFzIHdlbGwsIGJlY2F1c2Ug
b25jZQ0KPiA+ID4geW91IGZvcndhcmQgdGhpcyBHZXRRdW90ZSB0byB1c2Vyc3BhY2UsIHVzZXJz
cGFjZSBpcyBhYmxlIHRvIGFjY2VzcyBpdCBmcmVlbHkuDQo+ID4gDQo+ID4gUmlnaHQuDQo+ID4g
DQo+ID4gQW5vdGhlciBkaXNjdXNzaW9uIGlzIHdoZXRoZXIgS1ZNIHNob3VsZCBza2lwIHRoZSBz
YW5pdHkgY2hlY2tzIGZvciBHZXRRdW90ZQ0KPiA+IGFuZCBsZXQgdGhlIHVzZXJzcGFjZSB0YWtl
IHRoZSBqb2IuDQo+ID4gQ29uc2lkZXJpbmcgY2hlY2tpbmfCoHRoZSBidWZmZXIgaXMgc2hhcmVk
IG1lbW9yeSBvciBub3QsIEtWTSBzZWVtcyB0byBiZSBhDQo+ID4gYmV0dGVyIHBsYWNlLg0KPiBB
IHNlY29uZCB0aG91Z2h0LiBJZiB0aGUgdXNlcnNwYWNlIGNvdWxkIGRvIHRoZSBzaGFyZWQgbWVt
b3J5IGNoZWNrLCB0aGUNCj4gd2hvbGUgc2FuaXR5IGNoZWNrcyBjYW4gYmUgZG9uZSBpbiB1c2Vy
c3BhY2UgdG8ga2VlcCBLVk0gYXMgc21hbGwgYXMgcG9zc2libGUuDQoNCkkgYW0gbm90IHN1cmUg
ZGVwZW5kaW5nIG9uIHVzZXJzcGFjZSB0byBjaGVjayBpcyBhIGdvb2QgaWRlYSB3aGlsZSBLVk0g
Y2FuIGp1c3QNCmRvIGl0LCBlLmcuLCB0aGUgdXNlcnNwYWNlIG1heSBmb3JnZXQgdG8gZG8gdGhl
IGNoZWNrLiAgSXQncyBjb25zaXN0ZW50IHdpdGgNCm90aGVyICJ1c2Vyc3BhY2UgaW5wdXQgY2hl
Y2tzIiBhcyB3ZWxsLg0KDQpBbm90aGVyIGFyZ3VtZW50IGlzIHRoZXJlIGFyZSBtdWx0aXBsZSBW
TU1zIG91dCB0aGVyZSBhbmQgdGhleSBhbGwgd2lsbCBuZWVkIHRvDQpkbyBzdWNoIGNoZWNrIGlm
IEtWTSBkb2Vzbid0IGRvIGl0Lg0K

