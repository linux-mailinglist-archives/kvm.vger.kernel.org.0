Return-Path: <kvm+bounces-42524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F2BDA79820
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 00:19:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 278F41700DC
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 22:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FB881F55EB;
	Wed,  2 Apr 2025 22:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AZXVWmUe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C490126F0A;
	Wed,  2 Apr 2025 22:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743632377; cv=fail; b=Hn9WrGsVQHnKbQx7td44gCNJJzLUM5MdhTGUWTgt3KLjnmJZ4D+o8XJODfGiUOAVSYvZSWrwVO2deDOR4+XFNcyrhx9SLJW+cYXJfn1wd/CiHZSM+ovT9ITNCujRqqpy13g+HORE7Wi7ldMpEX3V8rePJ40JFu/zEVmwK/EpDkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743632377; c=relaxed/simple;
	bh=+oGVpcGdODpsku0GDXSAkWUYM3Ml0b7SggQ92tzjTy8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r78zCi5SaK9/JDnFeoJho+3/AStGruTxaY6ekuEXD57bDsSCL/uxEL38Ay6uU71+9vV7331gpyWcLA++njEBL1XtZIoPCFq6KfAkO+4pOmtbEOCbGFWRJY7/f618LMYztNLRKJqPTyjxVUGRAwTSKy+tt/mJtaaB+AekG3tAfBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AZXVWmUe; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743632376; x=1775168376;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+oGVpcGdODpsku0GDXSAkWUYM3Ml0b7SggQ92tzjTy8=;
  b=AZXVWmUe6JpzMDydy8ip0DQeOakl7rFIs2fRUmlNWalcXC0kNBPH5W2C
   JIDywAtgknNaUSgltyfXsGaeJ2JyOBT52dmrL0d5BDf+sJvFG9RChBBvr
   PGhlB06CB99NNn3epVPvFBAOzAe/6ZHNq5rTgA2Be3IAJ6giIDFAy7Ed9
   rQa4fb7XB2jm6kNHrZV9U92c6nDfjhn3F45oT9qCtJGdBNrF4mDXENADH
   2NNOZGy1Kcij4M6zVKHOTwlgjXeTRLtPhUmjMiljSo9JfyttKDFFIAgsp
   pUfQ7NCjnEoP4DpmYkDFQ5iw5o8k4Yyw76iZEjg4E5W3oJF2rxgklO3lU
   Q==;
X-CSE-ConnectionGUID: 9EXjsDQ9QjSpBFnLiP2cTw==
X-CSE-MsgGUID: 6KjhSDazRryT3Okqj9/D9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11392"; a="55216506"
X-IronPort-AV: E=Sophos;i="6.15,183,1739865600"; 
   d="scan'208";a="55216506"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 15:19:35 -0700
X-CSE-ConnectionGUID: i1R2Qt1mQwO/gNS0/dDThA==
X-CSE-MsgGUID: j2KRI2RmR8mGshb6DoME+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,183,1739865600"; 
   d="scan'208";a="150032218"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 15:19:34 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 2 Apr 2025 15:19:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 2 Apr 2025 15:19:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 2 Apr 2025 15:19:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hfACJnM5Yyn04j+WIcOO3GXtGhG35hvKWiWNJGY8u4P5KSCpvm1xi9r9K/QA1VeXGNX98PGQrzQoeWdt3PgyeN2tUakME+NplqOth9KXw5xopu3wYobOPWl91Q+ZkMWscCukDjHbdovABpTFR77hhNWvIU9xnzGLmJ+kPqCEKJydrI0729j1OeltlWefv/JKGgtHPaeHqGgT7FeU5HOelF6EjQgWfCO0q0ix1r6xK80TMeb/2tdFebJLP5/yKDYtLKzM4lmp00+AXxVZ47WnILJO4kkP4xZg8UWBG6la5z5UTlrGfsgP0YGeA3TbZVCyWuuDEZa1jKYz2sAFUkAwlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+oGVpcGdODpsku0GDXSAkWUYM3Ml0b7SggQ92tzjTy8=;
 b=FHY6V9UPosjj79X20k9JA3XGdNQP4P0fp2PC2iMZ2nwY0tYYXegH1l5iHxQWUgmAinXarXTAmPOKTh7DXckwzG6kh3v+H/Td4FM2mluER1ZP9nd6FGNi7mPLRN9nNaQrgOls9aexqJ0UahQXtMNjDXjw89RCfOHX0MGA1MRCEi64+AwMvCeES/o0/OFLS5xI0aQCKhNNQ70akzffBA6prBcA6XvIFYldx7ChJoEQSmvVUJg0XqmvOPVbmSMSU0dj6+5B1NCIo65JdQLk4trLHCKLYrUykm4w8Ej89gBEfq8pbYbTbIT02M1SJL08bDv5WQxTPePuuy+KqyFJztp5Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6195.namprd11.prod.outlook.com (2603:10b6:208:3e9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 2 Apr
 2025 22:19:28 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8534.045; Wed, 2 Apr 2025
 22:19:28 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "mikko.ylinen@linux.intel.com"
	<mikko.ylinen@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Lindgren, Tony" <tony.lindgren@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Topic: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Index: AQHbo2Q+reE/k3eiXkm8HRe31hfG0LOQ88sA
Date: Wed, 2 Apr 2025 22:19:28 +0000
Message-ID: <2047f2964fa713f70823b9293bf1ffd65ac44fa8.camel@intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
	 <20250402001557.173586-2-binbin.wu@linux.intel.com>
In-Reply-To: <20250402001557.173586-2-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6195:EE_
x-ms-office365-filtering-correlation-id: 7cfc09ea-ad3c-4a6d-e7f7-08dd72346f1e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K2thNFhheHgzcnpXTjlsV3ZsQUZTTjR5aUZzWjA5blJIYzJzcjRoVFdCMTBB?=
 =?utf-8?B?VmZvckZOZFQ2NUx3WDRwRisvd3pVSFJhaDVZYUFqbnMzTFpPOWNJWmw0WnQ0?=
 =?utf-8?B?UVM4SFlsc2pMWTlMb085dUkvTUoxNGU1ZFc0a0ZqRUx1aC9tMEdwZFZWN0Rv?=
 =?utf-8?B?bWg5NW1FdUhLZzNZSkM3cERDS0VKVU05aTIxbmhTKzBEbDlXLzM3T2kyblRv?=
 =?utf-8?B?VDdSWk5GdWd3eHNqaytaVXg0MzlTbkxpQ01NaGtVUXR3WS9udEpqejl5TFRO?=
 =?utf-8?B?dHBiMzZSdHQxQWxBRWNaV29iQk5SRHZudUJLbjlSMFpESUpQUTkvemhEWEN5?=
 =?utf-8?B?K1FzR2lLOFRGUHlJTG1IakcvODM3Zjg4cXBSY0k0VmtvTGxISFhWOFE0cnVZ?=
 =?utf-8?B?VTYraVZRQk0rMDJwaUNDUVV0T0ZORDF5c2NicDdPZ3FxcGEyd1dDWVg2d2NF?=
 =?utf-8?B?QjM4QU1hU3hLbHpuWVU5MUlCTHcyakpxbWl5ZEZSK1JXUUFpOXNsYkhqNXJr?=
 =?utf-8?B?aEx6UTZCRkhtdEI2aVJFemNLRDRkTWg5RVV2K3NlVW9NSnppVTBXUDBOdTRM?=
 =?utf-8?B?c1hyVGZHaFBKSG1hK0J2cURNMVhyT2dwTVYyZlpZVFVINERmeEZrNVBpemxj?=
 =?utf-8?B?czJsaEVtZm85NnpEOWU1MEtSSHlpVEZXT2U0c250Z1hiZTZtYWtydCtOeFFh?=
 =?utf-8?B?QnFoaHJHR0VsVDczR1REaVp4b1NWZ1RtQWxydDdLc25GYVBraUdUWUMwWHE3?=
 =?utf-8?B?NnJ3OWowWDFvRTRpMVo1UnliTnRTY3hUU3c2L3FScVdPRUtQRDlyUmVETitG?=
 =?utf-8?B?UjVFOEVUOHBYWHJhbXpKcVNJeWR0SHBYR2MzbFh0eEVZUnpYWWEwQVZrc3Fy?=
 =?utf-8?B?N0Znbm1oVCtEeHllS3pVQ0F3UmZaa080bS9GVW5ldlNHMTV0dktTT3dpTFNS?=
 =?utf-8?B?c2xQMDlTNkxzYTYwSHUxeW5JeUw2cExFd090S093WG9WVW81L2lWczVCTThj?=
 =?utf-8?B?eG1IcGhVcitEcXdyc3JJUndsajlxbFBIck1NUExOeThQeFlWME1DbklMWW1q?=
 =?utf-8?B?N2tiTVNFMTlXRU1ENGpNaXJRMXZlUkljSmU2cDMvd2prbHhXZ2tuZjl6aHdF?=
 =?utf-8?B?Z0E3UVBqNTZRUGdJaXdURkV2blpDbVJBWURzL3VhRnVFZzlGYVpsK2srdk1F?=
 =?utf-8?B?ekQyQ2g4WEZKTStxQjJ3WHdSRDA2ZkVWaGhpdWwvMnNMdGZQdlhZdmpoZGlm?=
 =?utf-8?B?ak5HMDNhb05uc3ZnK3RIaXY3MnNoTzBGbnJvNlFZekg5VGY3RXNkZzJ0M2s5?=
 =?utf-8?B?U3VrcFJILzRWdXhkaWI5T3pNZ2VvZE9zNmRwSFZYbXRRZFpSeWQyUWQrSkx0?=
 =?utf-8?B?dzBFME5WRUxZTGcxaU1uZk5TWTZ3cHkyekNnRGJSN2tRdVU2MFpKYzRDM2c4?=
 =?utf-8?B?Z3VEVjgxaE1GUVVkU3ZtbElCTVpjYVI0Ui9KbmNOcW8xWGpHRVZJSElLL1JP?=
 =?utf-8?B?WFUxNjVHdzY1ak5Oc1p6TldPVDRmRzJ6YnNoMGVqaXFJVEphcGJ4aysrOXNa?=
 =?utf-8?B?WU84OTMrdWRLTlpvVE5BUGMycGQwZDJPa1kwOTQwOG5tVzZwN3hMcE5vdlhr?=
 =?utf-8?B?T1c2bkJkbUFZbzU1bE9LZi9nZWdHMUppRkZRQ1EveEJNSllPMDkvbzZOL1hS?=
 =?utf-8?B?Qkwrb2Q2bE94bHN5R3gwS29XTFVzb1FlRFJzdVdTQjlZaXNWYjRGM0pod0Fj?=
 =?utf-8?B?YlgzeUl6MHBEeG1KcjdqblFtMHRMV0RjTEdVL1ROOVVyU0dvYndmejFvRXBP?=
 =?utf-8?B?dW9UZlIyVzZJT0p3U3VSb2V3VGNBMnlSdFc3cURmVnE4b2xSNGZNb2FFSWY0?=
 =?utf-8?B?WURLbkg1dGlTekRoSklFeWNBT0FIdm84bisvbm5hSmxBL1hoUkJKejNnRGM2?=
 =?utf-8?B?S2RDNmtTbDFiMmpGellQaWNxMExiczFCNHBPOG5LTEMyWElTeE5uVzlObFpw?=
 =?utf-8?B?RW94a3IxUTVnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K25mR204TGhJbUpQblpzZWk0bUVkQTBrZXRUQ0t2NklaN09zamg1blA4NFMz?=
 =?utf-8?B?aGxRY3ZhTXphcVk4ek9tQzdKVDhQUkhkK3cyclBzbDZwRXJ6QkI2eklNLzhT?=
 =?utf-8?B?dnZMczhQNGZ6Nm9JUDY3OTIya2R1VW53UkxQMHFGSWZXK3VJN2NDZE5nU0Fk?=
 =?utf-8?B?bWl1ZnBIdjdsbXMwWTl3WDBuMFRrVExNaWpLWGE5MDJqb3VIeXFKMXVyL0Zy?=
 =?utf-8?B?NzNkVWxNMHBSVHdWQitiYzZLM1RHRVNZRzVFNHFFZnVRT042N25yTU9jVUxP?=
 =?utf-8?B?VUZGdGwzN2FieDFyQVhUSnBuclU5cXE0Q21XeldkVUtET2FZK1ZHTW4rV0Qv?=
 =?utf-8?B?MjNwc2pFbmw0dUx3bFB0L0xxUThUSzJwVjl1eUVrYXh3WnJURUo4R05uVzFW?=
 =?utf-8?B?OUtlRzdIeEo0OE5zdERjZzZhRWVmNi93dm5FcEhVOFRlMXlYMDZPZ1ZIQVh2?=
 =?utf-8?B?M0dwU3NxcXhMM0UxaHJrbG1nNHZJZGE5d3Fka1IyY2x6L3pXWlExWlpha3dV?=
 =?utf-8?B?cDF2SkF6NW4vSHEzZ1pBM2ZGM1JsL2VYOVhCZ0Q5RHJzZTdScGRlbVNUYTd3?=
 =?utf-8?B?WXdWUkIyaHYybytvaVFhVVhBZmQrRnA3V3RIYUg1ZzBIanl4S0VEamFHdWJ4?=
 =?utf-8?B?cXRsamRBQ3l0c2NTdDdsK0h3WU83TkNHNHZUb2loSHl3M2twQTVOR1hHY05M?=
 =?utf-8?B?MWtsNER4UkhTclJONDg1K09sY2Y2RStENnlDbWl3eGRtOFA1b2I1d2p6aGhj?=
 =?utf-8?B?SnNyOUpwYXJ6QkJjbkRaWTNFbEZNdi9LMUJTUE5MZUZVSlRNcU1LeU9RdjJu?=
 =?utf-8?B?UVljQzRaMk5jdjJ1bzZKQ0F4VDdBVUJrYkdVRXVpL0ZGNVBDbmJVdXl6eHMy?=
 =?utf-8?B?OWo1T285QW1jQmVUd1NPOHFMSXFrTjk1QXNEQzV6aW9oMC9NeW1mZDZpdHV3?=
 =?utf-8?B?R1dnWGFpU1VSMzhYRlRyUjJBaStDR0dkcEVyVjNlbnNhei84dXlzdGVWYWxT?=
 =?utf-8?B?cGovdEU4Tnd2Z3kwNU5GYkhoWmxkUStqZjIyYTVYNVpOdlQ0dTU5Smt0RHhO?=
 =?utf-8?B?cWNWNWVmTUE1cFZOSVBBd1NXemxDQVlnS2FMcTlYamlZU2FPWkdPRE5Zd2JE?=
 =?utf-8?B?cHJ0VmVRNzlNZVFUSWJvdzROdzR3RWk1L3RERmNackMyU2xjcDhidE05RzFH?=
 =?utf-8?B?TE00UVJCMnUreDVvaHdsVXdxcnNXUTNWSFVtaCt0aGVNMDdwWFRTQkxIZHVO?=
 =?utf-8?B?SmNXeXZNNE1xMDJ6VXkwdFBoaFBSNjJSRkcwdTNKR3Q4MHRUZlUzWVdRVm1t?=
 =?utf-8?B?TXU5VWdPMXJiWUNxdUgxZGRpMThjRDFxNWdNMGtMeEVGd1BhQ3pRcDAzUzhm?=
 =?utf-8?B?RzRRZEVxR29TNFJTUHpUOUVodnlRbUpURm9IRHhMeC9vNHIxdEhFbmF6TVBZ?=
 =?utf-8?B?akZwWEgvaEpEVmgvR3JmalpVcDdLb09KQUFuR2QyN045VDNSU3E3ZkZlanlJ?=
 =?utf-8?B?NlV5Yk1xQ2hnUFAxc0UyTzhRSTEwVVoxc2dzeXM0bjFlc244VFUxY1dNWXdh?=
 =?utf-8?B?cDUvSnVtWW95dGlGQnduWXJQL3BxZzFMdVhtZUQxOVl3RTVHbyt5a3lPSVpw?=
 =?utf-8?B?YjBHeE5ZWWdObm9ZRzNNTHFZRUZ1aVFQbTBlSE9mRGh4VWNUemV4SmRuMExs?=
 =?utf-8?B?RHl4NVJkNDgwN1J2WkpwdXl5d2FTUXYzYkVaRHk1TXBjMVdoSHdKS3QxNUpx?=
 =?utf-8?B?WlhrVzcxcmJzVWtsTWhIUnZLT2xrOXBER1ZNc1JFSi9mcXRFWGNBZHFGN3Ji?=
 =?utf-8?B?dzkvamR6QXB5bnVlb0NCVG1zdUUzcVlzY2piUGdyZVFLOTJFTXNnd3RsUXdJ?=
 =?utf-8?B?S1YxUTl1aGF1TjZwZGhYWjBtbHpMQzZsY1U3K3FhTWIvNnpyWFB3Mk5Kb2h0?=
 =?utf-8?B?UDhPNzZSb2IvMlkxRFhhSWU5TS91ekxnVEdZSVh0R2NnVDlSemlsSkVqcXQw?=
 =?utf-8?B?UXNwOWlxRWU0ckhuZklTcU9UdU4wS2xXeDg2MWJuMmxra2FSNHFhTG1ScjYw?=
 =?utf-8?B?VjJJbitmZzMwSEhxQy95NGQ0QkczUHgxSlVtODkrZE93Q3NwVmVSdE93dnE5?=
 =?utf-8?Q?1gjsGeM4eUy/oUj79XZjMhpS2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <234A09943A87E14582AB1ECDB7ECD4E0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cfc09ea-ad3c-4a6d-e7f7-08dd72346f1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2025 22:19:28.4520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QbdtAAP6qQ5FAYaDow44NUWYx7YdiNoTsCySsSKY2shH58iZDGhcgEDTAxioaeZxI2GnFhu/7iwhjNFciWg09Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6195
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA0LTAyIGF0IDA4OjE1ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ICs6
Og0KPiArDQo+ICsJCS8qIEtWTV9FWElUX1REWF9HRVRfUVVPVEUgKi8NCj4gKwkJc3RydWN0IHRk
eF9nZXRfcXVvdGUgew0KPiArCQkJX191NjQgcmV0Ow0KPiArCQkJX191NjQgZ3BhOw0KPiArCQkJ
X191NjQgc2l6ZTsNCj4gKwkJfTsNCj4gKw0KDQpUaGUgc2hhcmVkIGJ1ZmZlciBwb2ludGVkIGJ5
IHRoZSBAZ3BhIGFsc28gaGFzIGEgZm9ybWF0IGRlZmluZWQgaW4gdGhlIEdIQ0kNCnNwZWMuICBF
LmcuLCBpdCBoYXMgYSAnc3RhdHVzIGNvZGUnIGZpZWxkLiAgRG9lcyB1c2Vyc3BhY2UgVk1NIG5l
ZWQgdG8gc2V0dXANCnRoaXMgJ3N0YXR1cyBjb2RlJyBhcyB3ZWxsPw0KDQpJIHJlY2FsbCB0aGF0
IHdlIHVzZWQgdG8gc2V0IHRoZSBHRVRfUVVPVEVfSU5fRkxJR0hUIGZsYWcgaW4gUWVtdSBidXQg
bm90IHN1cmUNCndoZXRoZXIgaXQgaXMgc3RpbGwgdHJ1ZT8NCg0KSSBhbSB0aGlua2luZyBpZiBR
ZW11IG5lZWRzIHRvIHNldCBpdCwgdGhlbiB3ZSBuZWVkIHRvIGV4cG9zZSB0aGUgc3RydWN0dXJl
IG9mDQp0aGUgc2hhcmVkIGJ1ZmZlciB0byB1c2Vyc3BhY2UgdG9vLg0K

