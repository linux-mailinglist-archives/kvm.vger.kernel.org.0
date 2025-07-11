Return-Path: <kvm+bounces-52214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60A46B0274D
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 01:01:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 994E11C884B0
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 23:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7078A221F20;
	Fri, 11 Jul 2025 23:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QTL4ms9m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61C3EEBD;
	Fri, 11 Jul 2025 23:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752274867; cv=fail; b=QQQkeeBK+2q4SFrtIawDnc6US147BfAQTAnse07doemwG3jv4OBk7eo19VR/bnYyhhAigjLOnZSscgVkWInrQZ8/CMCRGVLvPNvTXV3nBmV9vy47mx2rt5Gm5BqEA4xVHRSSeehtMbFMaq6lPvStsSUQJv3n4TzxLqC7eLcxNwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752274867; c=relaxed/simple;
	bh=F8Bf0DQAHccig18sHh+BpxAD57F+cpLIV9aiqSb/koY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EuU6aG+i1ecQ+iP0KTRUJFRSWRqGlxISQZGv7Fu2J2GUBJJ2hCYY4tJfWlaE3im/aSoGz17QFVdUPBIh26tEMFSUtRcVscbXA8if7qM8Fb5+8bpTB31wNaib9iSt0Y0Rd4rUk/XPh8ObEx1zaVv8JC/kdTtnfgXxafwyHp8cDu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QTL4ms9m; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752274862; x=1783810862;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=F8Bf0DQAHccig18sHh+BpxAD57F+cpLIV9aiqSb/koY=;
  b=QTL4ms9mzyXr4kh6JfpLrt4pKAKw4ol4CHDJD3P2YJiQXDl1AWLoISz8
   GHxR4NcLf2npwF51KkghCfn5HZQxwJIxVNV4+jNrByGQG4tQ77QwGpwtF
   7rUmwszytV2Yk8cX18Y0G1BEpsmnKITIsp3d1+QHHmsmDyza3y+f3yt+M
   trMXJGkckurVKxhxJXXTVv7zuW7kL5dB3at7ON7x4EN282qBvk+Ykaymd
   NxjNFqjY2ByJhHMJWvUeBBYOu9stOX5WC7R9fPcipwRLDPpnQ0fm6QY80
   GhRi/erEIkMXSdxLiwXrtzBqVchl9ksBzDCciW3GUfky/WzpsO1Bm+15g
   Q==;
X-CSE-ConnectionGUID: orOfsEJtRXCX+ScWATdFjA==
X-CSE-MsgGUID: phZpdkzKQxKMxR9n2WTDFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54707174"
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="54707174"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:01:01 -0700
X-CSE-ConnectionGUID: 4PFXBlVIR36IbzEtNnF3IQ==
X-CSE-MsgGUID: qGrpStEGSsmnUl6KMzicvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="157196067"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:01:00 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 16:00:59 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 11 Jul 2025 16:00:59 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.74)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 16:00:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BxXrPN+1T1AVIvmWFMw+vISzVzhyFlQ9+BN4bnoi/Ixbkci/927+AKtiSRGsIMOoje23CtNEu1Ly4tmtbtLfJ2l+UcW/4YAQOc+vqPdC/+HkBDd8Wlh3bREaHUuN+HAtcJMA8xabKmqYyv6Mfxszc+qboMtePhYgZASGwP3z5VFdHPiBS9lo80Vqx4E/Z/lsO1+7uK9NfhcecWYYuAsmAY6sNLwA3QcaILKZ1MPLsB0KwmlZ6R+szXbgVB2inemTff2LD+FJ7s8O8E5ZL6L3wbeGV5+Q7ljdY4mbakjCdW2JU9jSU18MnF1htyaOQ/hmCFt8ysmPgm8+x0eKeV9kDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F8Bf0DQAHccig18sHh+BpxAD57F+cpLIV9aiqSb/koY=;
 b=aUci+qfhoZZbzqEoWcB6Got78uuRkdGCF8ohL7pz/vnta9d1Cfuzl1KWqWSrp55zkCDDUFnS2zOCPbQCNIgmGrpRNK+u/vExWl1l2vmw5hAcbqbPAV7ctXKJ9EOyFmwtrcrP1BvE1K6Agp7dnDJWwPtDz3XMpi1vdiySjYGZdgHsrp6zydpT95vZ8P5axlgN10rrU/3kHO/G878+jzD9a9N4S656L7JKCfDxrmFuuYeYIILOXV+/AoHkbIxgYlqttel6f2PspbLNhS+bvRUqrq+dJyPEAEbfI3pSi+fi69QAVsz9ZVhMe6LaNMt58kaXxk0BWu7ZCt4c/liQMYFtzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW5PR11MB5859.namprd11.prod.outlook.com (2603:10b6:303:19e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Fri, 11 Jul
 2025 23:00:43 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.028; Fri, 11 Jul 2025
 23:00:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
Thread-Topic: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
Thread-Index: AQHb2raNt52nCBW150es8dK7MAv5xrQUisKAgAEmNgCAFxzJAIAARa4AgAAJ4YCAAAr4gIAAkYsA
Date: Fri, 11 Jul 2025 23:00:42 +0000
Message-ID: <b5df4f84b473524fc3abc33f9c263372d0424372.camel@intel.com>
References: <20250611095158.19398-1-adrian.hunter@intel.com>
	 <175088949072.720373.4112758062004721516.b4-ty@google.com>
	 <aF1uNonhK1rQ8ViZ@google.com>
	 <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
	 <aHEMBuVieGioMVaT@google.com>
	 <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
	 <aHEdg0jQp7xkOJp5@google.com>
In-Reply-To: <aHEdg0jQp7xkOJp5@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW5PR11MB5859:EE_
x-ms-office365-filtering-correlation-id: a5456dd4-e62f-4e89-1d00-08ddc0cec353
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MUl4dElSZGJVTHY2K25uUmR0V3ViVjRpYzhLZU9WeW9hZUlsS0lreitib0pD?=
 =?utf-8?B?aVBIZG1EQjZPN2RDeTZVSDlsai9vQkkyWDBjQ3R2Qk5LbXlrUC9kcENGLzA2?=
 =?utf-8?B?YzBzVmJVVlluTGIway9hZXBLVFVMa1E2L0ZoYzFsZUZnS3VZZnl2NWM1OEZV?=
 =?utf-8?B?NDlKNURWQWR1MXpkajRUUFJEcUNtWWtBc2MyVTIrSC8veDlJMlRNZ1FDZy85?=
 =?utf-8?B?a0kvUVcxNGdITXl1Z1BNYkxkdlVDSExsWUd3YnhyeGQra1cwWDk5a0Roamsx?=
 =?utf-8?B?NmRxZ2YzNlBjanRYOGt4NjY3dzdXUWtHTm5iOU5MWktHSkFNTUNhWkxzTEc2?=
 =?utf-8?B?c2JRYXhpaGUzck9YOExVTEhqTmxoMDkwbmcwMkRBMHBabnJ6eVczT3g3RkUv?=
 =?utf-8?B?dE5UN29ma1JsQWFkVHE2d25RTTRxZkhad0VndEV3MmhaTE1mTGtQY29ta1cx?=
 =?utf-8?B?Q3JtWHJhb244NXN0dEtCMnJmeWpUdkRYY0pURnFLR2s1eS9oRFA1ZVNSQVlz?=
 =?utf-8?B?dEVUMmFDZWsvY0pNRzNHcndWWm1FMlRxT3pCOTVqUXV1a01peitjT2tEdWNa?=
 =?utf-8?B?YmsrTTAwaGJsMFJraWg5OVFJOFF6aXF5MG82THJDcGtRcmMyMGN1alN2QlpV?=
 =?utf-8?B?TTRsWmhLSHpZVm1sUUIwTzlyYWtEVFkzOE9TVEs1Ukw0a0gxUkt1bGp5V25P?=
 =?utf-8?B?R1BrTUhaUHNXR2x5djVpa0dxeC9PbnNyRUU4dWErVVk2Qzk1TUgxQ2Q1ZXF0?=
 =?utf-8?B?Q2ZBcTd1NW5lZVpMNUwvSUMrRVltcFFtcFk4bEpuQ3Urdnl5ak52NWw3Q3I1?=
 =?utf-8?B?eFpWSDcyVE5jeGNVSmQvblJmZUpNN2JmMW9jN2JPQVlFR284VHdTL0t4TFdt?=
 =?utf-8?B?bTdGa0tmWDhXc3YzMkhKMTcwZ3BVSCtrS0hLOEVuWkErUXczL0hWTitUSzZp?=
 =?utf-8?B?T3EraU10WmtlYVVkOTZVRDF6enJESHZJOFVMRVN3eHJ0bHlldWRTQm1uMUVN?=
 =?utf-8?B?T0IvT0ZIUDE2Smp5c2drN1ZsMVR0RU5pK09JcnROVzlvSEhrOTR1bXZYVmdC?=
 =?utf-8?B?enlScjh2N1ZxcmpzdDNWQUJDS01uVkp4VUpSUGEvM2tkVGNwTzlTdTJPYzZF?=
 =?utf-8?B?SkpqN3FmbE5PVGlaT1pxYmdNOXVXc2VVQWY3cUx6bERLWVFuM3VoTmk1SFVI?=
 =?utf-8?B?cFZKOVAxM0dFcytsaTJXT3ZkblJ6VWU4K29OMlJWYVlLTk4wUlQ5MTFZaFhW?=
 =?utf-8?B?QlE3S3VacUdHa2drNTZrN2E0MDFFZ0VMYXl3OVVyelpsYVNycFM4Z0w0eTEy?=
 =?utf-8?B?ZEU1bTdiUlFLNWJsVlhxaXlzaTZqMTNOVUppUmNhSTNUeXQ3MHpTRHpoTHJZ?=
 =?utf-8?B?TTNYNy9EbllLR1NlTXc5eWlJc0M0MDQ0TStjWGVDYlRXTVVMS21qTlFrY0NC?=
 =?utf-8?B?K1VLVzYzTmNhSERGWUNlZDFWdWNLZUg0K3dxUXhQQk0vTVl6R1lHcTlPLzlT?=
 =?utf-8?B?dkZBa3NBU1hyaklrUnNQZDR3ZHgxazhYZEl6TkpQV0svY1dXOVFsOHoxVHZ5?=
 =?utf-8?B?ZnRrLzdwZVIxYVQ1WnYwYklvaWppeWM4VThCUFpFUmN5dmZJSXpzZjR1YmdV?=
 =?utf-8?B?VFB3T0VRY2NaWFUraVEyODhKWjc5L2I2MWl4Z3Z3QkYwSERqS25WT0V6Z2ZY?=
 =?utf-8?B?b1hiNmRXWWkzWHdiQ3dBckxqdThBNHpVclNiUnBQd2k0aitaamVIS3pzVWFB?=
 =?utf-8?B?b1huZnJxSUE2UW9EVlhUa1dPV20rbHF2U01CMHU2c2tOd1YxUUJoeG5QSFM0?=
 =?utf-8?B?WDY4RFFKWHhOZE1jck9EQk1udXg4eG5uUVgyZ3VpRFhYc1hDOUEwcGlsNjlZ?=
 =?utf-8?B?TGZmK0NDekR0QzlqbklxbDJqaEp2NjJhSTRFRHBHVUU0L1o2eVk4UE11YWFm?=
 =?utf-8?B?YzFJelZocGZJVEsyTG9SYWtsc1U1VUpZUVJTc3ZSU0tSSHRRY1pGcXZoRG5I?=
 =?utf-8?Q?YNfmTdTE0uOoC8FdzZCIqWOeIMWDaU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWdOWGdNYW4zQitwVGUyMmJwZEhkWEFjNUNlMmo1c0tOd3c5c0V5S1cycDhv?=
 =?utf-8?B?THZIcHJFT3Z3NmpnT094K0lXM2pSeDh6U1lnUTA0eEw4aGZiNEJyaDRzejBK?=
 =?utf-8?B?TFV1cG9XcnFLazVkcHV6aWxscEdpd3BZUGRVNDVpNGNvMWlCakNvc1VuNUxU?=
 =?utf-8?B?ekZ6TExqQm5mVk9PWVkyYjYvOFRCL1ZEeThSTllTeW1qSkdjaUtKbXlnWlVV?=
 =?utf-8?B?TUVhSTJTWjVKbE5QeEphT0tueFYzdEFCTUh3MXg4R1plMnlUbVBZd3JReVZk?=
 =?utf-8?B?VXVNT1lBUTRwNVBqR0dMaW1RNlJ5MHBKZTNRUzRudFRoQ1pZcE15c2VISkRL?=
 =?utf-8?B?dXBqUnRhV0c1OTgwTHNqMjJRRUNTTjJtYUhwR3hJbVpjMTRxTjVsM2k5eFZj?=
 =?utf-8?B?bHJPV0xIV0lyOGVzUHlzSmVhYlhHS25NU3F3M252T0hubjBwTWtWeHJ3QytB?=
 =?utf-8?B?eVFhTTZuanNoK2tmWDR1Y0xWQU5yNHAxaEF4QzU5TW9LNlNKVFBjbkNMNzVq?=
 =?utf-8?B?US9WOTFFZ1ZDQ0o0MWdmTTNRR2hrSUd1aml6eUdMZmRwUldFbjBCOXo2SEZR?=
 =?utf-8?B?dDU2dU1wc0xVZWl3UWdwTzJDTVFIWjB2VVk4K1NZZ2xDaWV2SVYycE1FUUhY?=
 =?utf-8?B?Z2FBWUF2anR2Q1NPU0ZRV0JnZzdERnlwbDdtVlNKN1dTR2dqLzlPTUlNMnht?=
 =?utf-8?B?NzVQOXpXc0YrUmMzVHBQaE03eUVLWlQ5aW4rQ3F0TXhaaStSSFVwNUIwRVgw?=
 =?utf-8?B?d1BXMmt3QTVsUlROY2ViNDhCbjlLZVJiNUtuMXEvRjdiUnlQTm1tcTJRYUp2?=
 =?utf-8?B?dEI2RmZFc0dyb0VGUGZLSmRZblhzKy82bHdzMjhoNk1qNUx1R2pqSXhmS0Nw?=
 =?utf-8?B?VmwwS1hXQmpVZUJuRWtwNzdmTXFvaHRXbDMwNjZ6K1Y2Z1dkQjZWc2ltZHJa?=
 =?utf-8?B?ZXpuNGpMTG4vZjF1UFlrUW03WjhzSjBZMVNsUmV4dHViNEoxenZZL0cxRUEv?=
 =?utf-8?B?QkNNbGYzMkZUZitmV2UvaWtna1A1TUdvVmJteDNlZnpHNXhxUVFQSFBaaXhZ?=
 =?utf-8?B?dk05Mk5wVWNiQnZzWWplclJxbFV5OWhXcllGaDVyc2hWbEkwaFJ2S0RsK25q?=
 =?utf-8?B?UDl6ZU5PRUJLZlN3OTYwSnJ2WVlXY08yTUVjR09JK3RMZC9HZEVKMFRPR0xD?=
 =?utf-8?B?T2I1Qjk3bjJ6Qzd4SHlrUUkxdUFzVkpqbERodG1OWTBEcTNuVUVjUVMvaU5a?=
 =?utf-8?B?bDFuZEN6Mm5Eb3JiN1BZVU11OHlBOHM4c2ptVWorSGlhb1pYU1MxYzJKWTB2?=
 =?utf-8?B?cThRVEhZQW83QTJxWE44QTBnVThrVTZwU3djeHQ3NjZKZVV1TW5hNzF2VE53?=
 =?utf-8?B?R3N6L1U0MmRXeHBZVFBQajZEcUlWbURXdDBaczNaTmRES1IwZXdGNERFVjk4?=
 =?utf-8?B?d1QzZGxMUGVFWE5WVU9PQVJVaVRSYVN2akZlWlY3TnRjRGw2S0phdGh4a1ZL?=
 =?utf-8?B?d1pHbCs1R1VHWFg4bm5DWDdPVkdGeGlJUnhQaWNwQ0dXT0JVblV5NHJWTnIx?=
 =?utf-8?B?dWFKZ2h4Yk0rZldIeVNJaFAyNUY5MFRqd3VzODVZbUdkYkc2LzB5b1dvR0o4?=
 =?utf-8?B?WkFCUWYxUVFiSW5KTWdPSXU1MXcyczI2M291dUEycWwrN1ZGK1RZalhBN281?=
 =?utf-8?B?RmJIVXgyUTFwdDgrMTV3MmJuY1FFMDNaNTNHYlNTdjJPNkpNdzNyakZHUCtG?=
 =?utf-8?B?VmVhVm9rVm01UitVSlJ2eDlBK24wVy9oN0hvQS9tdVBWbEhjM2k3ek9NVU1I?=
 =?utf-8?B?S0s3bnNza1ZrV1BGY3lDcG94VDBUZ3lZc0xkM2drRHVacWVPbDI1N1hBUTRY?=
 =?utf-8?B?Ylp4YkJxU1oxRDlCWGZiVFJrL0J6VTZoMmJpODNlQWNxQ2FtbzV6MUZZYkx2?=
 =?utf-8?B?RStnTGpBVU5uTHhpbTkrQXZPOHRJa1hWOGpMd0lSdEpmZXFwVkQ0R1VXeVlY?=
 =?utf-8?B?N1FtaWVxVHRtdUtaazArelBuM2lYMVFxNlFKTXNRRDVFN3VIeWJDbDkveDBo?=
 =?utf-8?B?RzlVVWJUM3B1cHlBWno1OGRubzg1bUljMW12dWQ1OFFwTXdlOVJsc3NNcllR?=
 =?utf-8?B?eFRMclliMEFKY2JiSWgxcUdKZ3ZvN3NTQ1JIY1dHSkdEcXdvYkNJUEZ6eXU3?=
 =?utf-8?B?MXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <89FADA22895D3B4A9D361B4395005D42@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5456dd4-e62f-4e89-1d00-08ddc0cec353
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2025 23:00:42.8833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fh0CLAhbKFaWjfMARL10tHP0HLdzn6aB/NBvBE65cSMiiph6SC72C3QUKYthKH5oIrUx/djDywCA7JHM96+n4tiKYFZ9dKhexNZ0eRqa9h8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5859
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA3LTExIGF0IDA3OjE5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiAtLQ0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gv
eDg2L2t2bS92bXgvdGR4LmMNCj4gaW5kZXggZjRkNGZkNWNjNmU4Li45YzI5OTc2NjU3NjIgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gKysrIGIvYXJjaC94ODYva3Zt
L3ZteC90ZHguYw0KPiBAQCAtMTgxLDYgKzE4MSw4IEBAIHN0YXRpYyBpbnQgaW5pdF9rdm1fdGR4
X2NhcHMoY29uc3Qgc3RydWN0IHRkeF9zeXNfaW5mb190ZF9jb25mICp0ZF9jb25mLA0KPiDCoHsN
Cj4gwqDCoMKgwqDCoMKgwqAgaW50IGk7DQo+IMKgDQo+ICvCoMKgwqDCoMKgwqAgbWVtc2V0KGNh
cHMtPnJlc2VydmVkLCAwLCBzaXplb2YoY2Fwcy0+cmVzZXJ2ZWQpKTsNCj4gKw0KPiDCoMKgwqDC
oMKgwqDCoCBjYXBzLT5zdXBwb3J0ZWRfYXR0cnMgPSB0ZHhfZ2V0X3N1cHBvcnRlZF9hdHRycyh0
ZF9jb25mKTsNCj4gwqDCoMKgwqDCoMKgwqAgaWYgKCFjYXBzLT5zdXBwb3J0ZWRfYXR0cnMpDQo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTzsNCj4gLS0NCg0KSSBz
dGFydGVkIHRvIHRyeSB0byBoZWxwIGJ5IGNoaXBwaW5nIGluIGEgbG9nIGZvciB0aGlzLCBidXQg
SSBjb3VsZG4ndCBqdXN0aWZ5DQppdCB2ZXJ5IHdlbGwuIHN0cnVjdCBrdm1fdGR4X2NhcGFiaWxp
dGllcyBnZXRzIGNvcGllZCBmcm9tIHVzZXJzcGFjZSBiZWZvcmUNCmJlaW5nIHBvcHVsYXRlZCBT
byBhIHVzZXJzcGFjZSB0aGF0IGtub3dzIHRvIGxvb2sgZm9yIHNvbWV0aGluZyBpbiB0aGUgcmVz
ZXJ2ZWQNCmFyZWEgY291bGQga25vdyB0byB6ZXJvIGl0LiBJZiB0aGV5IGxlZnQgdGhlaXIgb3du
IGRhdGEgaW4gdGhlIHJlc2VydmVkIGFyZWEsDQphbmQgdGhlbiByZWxpZWQgb24gdGhhdCBkYXRh
IHRvIHJlbWFpbiB0aGUgc2FtZSwgYW5kIHRoZW4gd2Ugc3RhcnRlZCBzZXR0aW5nIGENCm5ldyBm
aWVsZCBpbiBpdCBJIGd1ZXNzIGl0IGNvdWxkIGRpc3R1cmIgaXQuIEJ1dCB0aGF0IGlzIHN0cmFu
Z2UsIGFuZCBJJ20gbm90DQpzdXJlIGl0IHJlYWxseSByZWR1Y2VzIG11Y2ggcmlzay4gQW55d2F5
IGhlcmUgaXMgdGhlIGF0dGVtcHQgdG8ganVzdGlmeSBpdC4NCg0KDQpLVk06IFREWDogWmVybyBy
ZXNlcnZlZCByZXNlcnZlZCBhcmVhIGluIHN0cnVjdCBrdm1fdGR4X2NhcGFiaWxpdGllcw0KDQpa
ZXJvIHRoZSByZXNlcnZlZCBhcmVhIGluIHN0cnVjdCBrdm1fdGR4X2NhcGFiaWxpdGllcyBzbyB0
aGF0IGZpZWxkcyBhZGRlZCBpbg0KdGhlIHJlc2VydmVkIGFyZWEgd29uJ3QgZGlzdHVyYiBhbnkg
dXNlcnNwYWNlIHRoYXQgcHJldmlvdXNseSBoYWQgZ2FyYmFnZSB0aGVyZS4NCg0Kc3RydWN0IGt2
bV90ZHhfY2FwYWJpbGl0aWVzIGhvbGRzIGluZm9ybWF0aW9uIGFib3V0IHRoZSBjb21iaW5lZCBz
dXBwb3J0IG9mIEtWTQ0KYW5kIHRoZSBURFggbW9kdWxlLiBGb3IgZnV0dXJlIGdyb3d0aCwgdGhl
cmUgaXMgYW4gYXJlYSBvZiB0aGUgc3RydWN0IG1hcmtlZCBhcw0KcmVzZXJ2ZWQuIFRoaXMgd2F5
IGZpZWxkcyBjYW4gYmUgYWRkZWQgaW50byB0aGF0IHNwYWNlIHdpdGhvdXQgaW5jcmVhc2luZyB0
aGUNCnNpemUgb2YgdGhlIHN0cnVjdC4NCg0KSG93ZXZlciwgY3VycmVudGx5IHRoZSByZXNlcnZl
ZCBhcmVhIGlzIG5vdCB6ZXJvZWQsIG1lYW5pbmcgYW55IGRhdGEgdGhhdA0KdXNlcnNwYWNlIGxl
ZnQgaW4gdGhlIHJlc2VydmVkIGFyZWEgd291bGQgYmUgY2xvYmJlcmVkIGJ5IGEgZnV0dXJlIGZp
ZWxkIHdyaXR0ZW4NCmluIHRoZSByZXNlcnZlZCBhcmVhLiBTbyB6ZXJvIHRoZSByZXNlcnZlZCBh
cmVhIHRvIHJlZHVjZSB0aGUgcmlzayB0aGF0DQp1c2Vyc3BhY2UgbWlnaHQgdHJ5IHRvIHJlbHkg
b24gc29tZSBkYXRhIHRoZXJlLg0K

