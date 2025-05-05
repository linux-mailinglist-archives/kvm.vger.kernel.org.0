Return-Path: <kvm+bounces-45416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A5A7AAA9386
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 14:46:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F669188ECAF
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 12:46:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F5422837F;
	Mon,  5 May 2025 12:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fgAehx9q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5675A4315C;
	Mon,  5 May 2025 12:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746449171; cv=fail; b=sDcu8aUhCE/eiXP6vfiPCCtH6fcQob8RSSKYBkc2NWwnkDiNUw6pLZQ1feFgbrsO1l95hTteCVmAT+kJz6jbLoyPQBAdoyxfjS0IYwbjp0JYX3DqWgJiT3/NRi4hEQok6poteCX88bnIQZQfrkaCR3O37IaP25/N/fqpzqY1bMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746449171; c=relaxed/simple;
	bh=Ldeum5lumB6V33WV7uHKcgzES1GonD59k+7LPWuPumw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t2tc4sdzoYwNuPxy1pUhsFvrbkf39ggwSD31ITD3CVcr6qmeumQqFk21GZPcZBVjJO+xy7uRR7RpHlMg0eTi2LPe2jaDw41qEot0jMKtOSEEvdDolxdRsE0lmvhBMpf4XhVA5KKgKW0bCZgljW2UbbEwmPlt5K0G9VfpocNMtGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fgAehx9q; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746449170; x=1777985170;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ldeum5lumB6V33WV7uHKcgzES1GonD59k+7LPWuPumw=;
  b=fgAehx9qBuF5qtvW8XGHOKTFc3y8UjHUX5aBQPYNV5N/EZJ7IeEVRJDO
   g/IfbtPsM1N8ur9fKQODWax4xUqgik0jYsCZrFkDEPRu+22o5LTc9BD8t
   2SHqS0bqV04qf022Y/8Y9WPjFHrcPLDII0/1vS4a/WLTvsuf0DJxupigp
   q9SFhKCadyqRZvrTwdrvtSVDqN2Ev0h6j+8H8H2QiAuAV/gIf/zDn9QU4
   kybC2wyLSSBo4IFCy2zmCZVWU4fXv2nRiSm6BjWAOgnyWT/Sledopy0QU
   f6lKFrIyMJZUrpkqN50C0fNX3TB+zn04aWSK4Hk89FVavGStt324h3itV
   w==;
X-CSE-ConnectionGUID: njHsZVz6RtyMm+wci0FPRA==
X-CSE-MsgGUID: 2U1mGxmXQj6JIwl/4rXjsw==
X-IronPort-AV: E=McAfee;i="6700,10204,11423"; a="47161272"
X-IronPort-AV: E=Sophos;i="6.15,262,1739865600"; 
   d="scan'208";a="47161272"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 05:46:09 -0700
X-CSE-ConnectionGUID: 2QPQdU8VSYqjREiHn9bNNw==
X-CSE-MsgGUID: 9qcISKeaTt6aK9KBdjnOmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,262,1739865600"; 
   d="scan'208";a="135577599"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 05:46:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 5 May 2025 05:46:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 5 May 2025 05:46:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 5 May 2025 05:46:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M3q81O2ykkts0y9lXSlIwu8YTJ+qWa31BxwhecTYa+wm+1yyR/CHJhF3aQcF37rM7UY+YMCuIMDCwYx14k71k/PkhKytqxwGj6Q2oiU81hokPTvEEJEQaHg3Z4GZDGWDAcwdwMaaXxbwq4fYl2YKYIUNufgVDrswywIHlAUAPdG0aijXxj2KA2EvsX1qOuwj0q90RcBTpHPFJm+IMgs17LQz6oqNXQmADkYjuC5iJ5SaLdEJybmdSvcJYLzgW+bwuuTdOcg1hKw0HssKzLpT0MclF8MOrjB8izV5r9zhIZagB+m/yxliRbBT+nfcWR3tw8P8/4FPuEQ+4EKCPnau3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ldeum5lumB6V33WV7uHKcgzES1GonD59k+7LPWuPumw=;
 b=Eh1cw8ZZwTUbBsOLfvSn1by55CCfCH25ZsvffbkY/yuAhEginUCBzs7PnFhcwwi0DcS5XsCQtD5RIKXHizTOjTMF/14JlTdrHUMtKGCrgGIsjXWHNjd4/VsneTdsCIOpoER0EToZWv8v3o9NGUkrQ3X6paI2YXXvNM1AWfwUY9NZ856ptCpBuMKa1xHHb4Uq6Uza4LSMg5mKCZh1qLsG8SCeJbMs72dce25IGoBtM1sAq+GkDwZ/tT2Ofte9xViQrURbShNeiW6zEJ9pSpHrdo/jKTzRANo043ajsNSsItQOGqDP7azZ27FPYEgIigKYcVEugal5+2hwh6RrRH8e8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4442.namprd11.prod.outlook.com (2603:10b6:5:1d9::23)
 by PH7PR11MB6793.namprd11.prod.outlook.com (2603:10b6:510:1b7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Mon, 5 May
 2025 12:46:05 +0000
Received: from DM6PR11MB4442.namprd11.prod.outlook.com
 ([fe80::b4a2:9649:ebb:84f9]) by DM6PR11MB4442.namprd11.prod.outlook.com
 ([fe80::b4a2:9649:ebb:84f9%4]) with mapi id 15.20.8699.022; Mon, 5 May 2025
 12:46:04 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 06/12] KVM: TDX: Allocate PAMT memory in
 __tdx_td_init()
Thread-Topic: [RFC, PATCH 06/12] KVM: TDX: Allocate PAMT memory in
 __tdx_td_init()
Thread-Index: AQHbu2Na50iTavayHkeY2eR2WU5eALPEAIoA
Date: Mon, 5 May 2025 12:46:04 +0000
Message-ID: <157ade490701bbb545f50aa32ed3e06ea8dc370a.camel@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
	 <20250502130828.4071412-7-kirill.shutemov@linux.intel.com>
In-Reply-To: <20250502130828.4071412-7-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4442:EE_|PH7PR11MB6793:EE_
x-ms-office365-filtering-correlation-id: fcfe90c2-d857-4ef8-7c38-08dd8bd2cca4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U0QwamVBeG1lS0tENExjVHVCSElpbVp1WlhnVUdqemZnT1JWdlpvUEp0S3Zh?=
 =?utf-8?B?MllFSG05SEJRcTR4MGM1N2pNVGJ1aU1ERktrRERmTXJENFZyQkdVNWw1VXZn?=
 =?utf-8?B?eTdQcTErbWoxR0wrbENrWnF3L21HZmtybVVRbnM5M2trcitiaFlVSnYrbG5t?=
 =?utf-8?B?U0hoN0M1dVZKU0dwSG5OMmpSTGxmRnZFVWhENUs0Ukh3YU9OajUweU4zaDM0?=
 =?utf-8?B?NHZ1V3ZyOEdMRkFRUWVGTEVhYmRtZ1N6RlY5elhSa3NwSFNGLzRoNU16YVhi?=
 =?utf-8?B?VjJ3Z2ZOQmlncHh6alJFZ2pNTEFSNHhWT2pTcSt1WVFROW5Hd2FvRzNZaGx2?=
 =?utf-8?B?UUFKRDVIcmh4RXpVbERrS2tZRkVZWWNCaVhKSWRqU0pjbVJqeTNPTlFCRVF3?=
 =?utf-8?B?NFpCcWpwTmJlVlg1YjZsSkQrTFI5MWpWYURvdVVJQXdWeEptd211eUxaUWQ5?=
 =?utf-8?B?elhkem9nTXc2clQ4Y2RuQWI5em5MUEFKVVBOekNnTDEvSENHUTUrd1RjMStr?=
 =?utf-8?B?bjc0VGk3NHkxN01rbThlSVYwWTlPS3JIOHdldWtyVnNmRTU2SnQ1MnJUeGUx?=
 =?utf-8?B?bjg4aU54c0xFdTVJRy9LVWJoVDNhamlPZklHU3l6d3EwdlNDb0xXMTlhZkFK?=
 =?utf-8?B?M3pGUkRLTURmblJkV1lyeTBwajcrclFuSHZNRG5iRDVoN3hidllvWUxzcVh2?=
 =?utf-8?B?OWRBazQyNDBzT2U3K3F3Nm92dXhwZVlNS09tSXdoaVlpTnl6NmhiVW9KV29y?=
 =?utf-8?B?N2FyVDZ2b2puZlRETVNKNFovRndxQkZycFJ0K2U5bzJzOXVzU3NFN2RpLzZm?=
 =?utf-8?B?ZXhlK0xxc2dhU2MyMk1iYXZDK1IvUnhUVTRZemVNTmY2bzVGQnBOOVROZUx3?=
 =?utf-8?B?NEJia0xIbVRwWGdQRWxtRDFGUm44WUI4WVAvcHRLaXJCU2FzeUhKREpjNFZ5?=
 =?utf-8?B?a0Z5WE9SWUhEeWduNnJBUXBvQVBZeTRUR2JiUVlmbXhnSmJCRDMyNnlRcTlD?=
 =?utf-8?B?dzMzbmhOOUdablRPUmhzU1kzWVMzdWRsN0FTazZ4aG0rRlZla2t5d2ZvS0xC?=
 =?utf-8?B?a1hRY2JHOGNQUCtaN2hVbGpvcndCbTVYaFNTdmFMYjhuVWlLRzg0aHdzbXZT?=
 =?utf-8?B?RHB0d1BhWStYMExNc3dHVVpjeDZoRUFUZE5JNzFWKzdCM0ZhdWY1MW5VOEg1?=
 =?utf-8?B?OWQwRHM4QWZWdkpWVVU1Q3Vvc09PM1lvMU9JV0J4SEJZM3UzaGFpdUxwNDJM?=
 =?utf-8?B?TnhyUGt3Vk1uWTdhc2NTelJxUFJScURneHZvZ3VoRmRDaHcrZlVPRHRXZjFR?=
 =?utf-8?B?dUZsZlFjTHNCY1ZaMHorK2t6L25tQkVKTkFsUHVpNi9PRVoyL0tEbGlJUHh5?=
 =?utf-8?B?eC95L2t2RkJEK09uWURCK1dkRDNXYml4UjZjU0s0Vm5ab2NPeTFjMGFYMkdF?=
 =?utf-8?B?WjVxcEJVSGtvOVpWWHJPQWltdGdDUWFXQ2VYTDd6ZFFuanVERmlFL3dkMjIz?=
 =?utf-8?B?ekpzM2tQSWgvUWZ1RFYwYUNNenVzUVZSZDNvNW5NbmFab1A5Z0FoRDRaMVh4?=
 =?utf-8?B?VG1WcE00cHltL0ZKM0lmWU9uM2pISTFzM3ZsOVBnSUt1SElpd3lFZDBDMkgv?=
 =?utf-8?B?NWhuOE1FRnFqdFNETDFjam5xd0ZPSmRndmplcnF2VjVSYlgxUHN1WUVJY0ZN?=
 =?utf-8?B?MDFzOUtJWmNoR3hLZHZNK3QrNG5xS09KcVg4dnVvMFA5VEpvSTZxb3BmR0pR?=
 =?utf-8?B?RUFIV3Zobmd5T0VpVStqWnZVUmtjOHRvQmIwaTVNME9SZjlkaUk1MDR0anNZ?=
 =?utf-8?B?dThmVjdNQ2J3T2FyYjRTeUxyVVA2eWVxeng3K3lmLzFYVW9vN2RGT01PbmpW?=
 =?utf-8?B?Rk02bkVIamNML2l3TFV4ZmRPaU84M3Q1eGlaSTZqc3drdThadnVsMWhGbjFK?=
 =?utf-8?B?ZXduUTJjWnVBM0o0Y20vTVIyazJMYWxSdk9WTFdabmFvM0x2UUx2MENocUUz?=
 =?utf-8?Q?3fMnQ/B3smIfA655rEQYwJv71cEvK0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4442.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2FER2dkc3kxTWNQUG5PMzduSVBsVlZzcC9rOGNPSEE1cjJXMys2ZEk4RnVn?=
 =?utf-8?B?T0g2VkhuZmRjOFRWYkFaYThKbEhESU1HQlE4U0RFRE1tUzd3d2V5OFNXOUtT?=
 =?utf-8?B?QW1Jb1pQNXZYVVVLVnBLeERMMkFkMkN1WEw1UDVoSnVCYncvRlJmYUFoWnJn?=
 =?utf-8?B?RzI3NGY5dHprMFhRUUhQWW1KUHBEY3BBQW5JYnMvMzIvUHU4L2tVWEdpdXVk?=
 =?utf-8?B?bjd4K2U3ZVBsckhZMmpvVG9YNnd4YmswdngwcVhid01Gbk1VSTdmZ2FoTFA1?=
 =?utf-8?B?Y3hndXJ3SlQxN0FxM29yR0kvQmowMVVCS0hPb3kxM3NoU0gyUnhUWTFpMHh6?=
 =?utf-8?B?NS8xb2dvRGFEaFlzZzlwQXdzUm5kN2d2QWdlb0hlNm53SXhNc0g2U2Vta2xj?=
 =?utf-8?B?RWJVcFZ6UzNiNFQ5cXVaZ00xSUIxL0JxOWZYdFpvWGRCVHpjNFNJR0hYQTI1?=
 =?utf-8?B?YWdJUzl0R2tRYXNkSEdVNWRSYlFyTFRKQk5wZ3NZemdKQS9FNGM2Q3d6ZnhV?=
 =?utf-8?B?VW9kSUdEcDJSNk9MeWQyTVp0K1JaS2ZwVVl5SXoraGlxMDMzZTUvTEhiVktp?=
 =?utf-8?B?SHZTSVRkVFNaY3R2Y25DM1FZVjRsWC95MDR5OFE2OWJ6TUlWeGt0T1JhN2hY?=
 =?utf-8?B?L3pLZSt1T3ZHMkdJcEJvQmFtRlhUVXdteU9tUG16Zm9zeTNpZS9Nd1dyWVl2?=
 =?utf-8?B?RU12ZW8vYS9sK0c0Y1VoSzQ3bklyNHdnNWprRzV2d2RuS2dqTS84a1pwOGRo?=
 =?utf-8?B?ZkUyVjU5WG5zOG0xcWp1TUovZG5iSlBlQVdLTlAvZVRlOG9xK3pEVmR5LzAv?=
 =?utf-8?B?anRveDQ3cFJtSkRZME1HRW1Hb0lRbXg3bVdaTUFQbjM5amlYL2xmOGtLWXFB?=
 =?utf-8?B?WjE3VVk2MXNQSnQ0VG9vbnJ6RGEzc3poU1BCZWh1YzBlY0d4MHdYNy9UK21i?=
 =?utf-8?B?V0Jlamp0TzBkaFh3aE1Wck1yNUJoblhXdU5YQ1Zlb2dlWmsxT0lDem92WmMv?=
 =?utf-8?B?RlZOYysxWWlBUmlmS0xRYXBXVm9zQ1FWaHRVSXVpYkJZUEtDejBoYXhGL1pm?=
 =?utf-8?B?NllwcU9pVklaWVV4L0FndkhkZDF3d0wvT3NKR1N6cVhLSHRMU3dwOEFGN3V0?=
 =?utf-8?B?OXdha2dQNGUrQnVjVWx3bFZ1NDhHUHNYajFGY245QjBJaWw4TG04VUtETlVK?=
 =?utf-8?B?b3RlNjllQm9ROUQvTC9UcG9OQjhPVzMrRStuM0JCWGN0ZUZxeGFtdlVnamhL?=
 =?utf-8?B?cWJVQmlaZW5FSnZQUzJSZ2Iyb2N4WnU1WC9aUStLYlRQRWYxZFBHOFBGS3dp?=
 =?utf-8?B?T0RNTndXY3lPUTNBbnRjejhCU1A4eW04bWhaRnRPZzFoTXJqWFhKblNRUzhm?=
 =?utf-8?B?dzB6VGJpRlJpWGdlUG9paVRQNkgvdkRPLzlOQ1l1NHdRTzUwa0Qwc0s1a3VK?=
 =?utf-8?B?T1loMGJOZ3lUWE9TZmkyMm40NEcxZDhyR1NGbzQ1TnVsSW1QMXZvdUNibXEy?=
 =?utf-8?B?NERNeGFaN3J5UmZBV2NXWDZFR1FMRm91WTAxYlVYaTYzNFVIU1ZaU2dRWjd1?=
 =?utf-8?B?a1hVdERSbm1MbHVSK2ZKbDZhZk51REV3TCtQb09HZjF3WkdFSzJVZ1NKMXcx?=
 =?utf-8?B?MDhxVFI5ZlNGZENvcjZkY2hKWmlPTkZ3S2tNbDN1MnY4dFkyaTlhUUtMcnkw?=
 =?utf-8?B?QTJRd1htZTE5REJpeHdlL2VpMHVwV2hMS2YyZUhISVRJekVpNVROMnE0aVAz?=
 =?utf-8?B?bkJ1NTE4bGN3Y0U4ays5UGNrZU16aEFxTitNZm9WSUNydTByUGRiMG9PK0M2?=
 =?utf-8?B?dlU0bXJSeGhXVWMzK0tySzBjTnhpU2tzNzVld2J5TytYc09DMU4vVTRiY3Aw?=
 =?utf-8?B?YWRweXNWcEpjc1RsNEFUK3laUU82Z2RVaWdkc1AwNUhabGxXWnd6OGVNOEhS?=
 =?utf-8?B?d2Z6LzlMVm13VHdzbWdyNVV5ZklXSC9hcHRoaDQ4V0FodE44Nzk5bTloZHNi?=
 =?utf-8?B?aFRSdVpieUR0bm5OZTlMV1NBa0J1V3VodnNPUFhqTmhralBhcnlPUGNmQVhH?=
 =?utf-8?B?ODk2cEt5dERVaG1BYldsUWgwbHJLeENIVmtTalhaSW9GZ0g5aE80a2l1MC93?=
 =?utf-8?Q?gaArPGQHGCbGzO6fA3b136ovd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <38594C4065E24F4AAE2560A561BD6A49@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4442.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcfe90c2-d857-4ef8-7c38-08dd8bd2cca4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2025 12:46:04.8918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uwyfr5Yxxy+LJTj8pJ9nO9eNf+xPt8vMJucOejdEXlgIaFV39SsPs+fEDa74LFn142ChL8oBvtV3WG8UhK+ZdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6793
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTAyIGF0IDE2OjA4ICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IMKgDQo+ICtzdGF0aWMgc3RydWN0IHBhZ2UgKnRkeF9hbGxvY19wYWdlKHZvaWQpDQo+
ICt7DQo+ICsJc3RydWN0IHBhZ2UgKnBhZ2U7DQo+ICsNCj4gKwlwYWdlID0gYWxsb2NfcGFnZShH
RlBfS0VSTkVMKTsNCj4gKwlpZiAoIXBhZ2UpDQo+ICsJCXJldHVybiBOVUxMOw0KPiArDQo+ICsJ
aWYgKHRkeF9wYW10X2dldChwYWdlKSkgew0KPiArCQlfX2ZyZWVfcGFnZShwYWdlKTsNCj4gKwkJ
cmV0dXJuIE5VTEw7DQo+ICsJfQ0KPiArDQo+ICsJcmV0dXJuIHBhZ2U7DQo+ICt9DQo+ICsNCj4g
K3N0YXRpYyB2b2lkIHRkeF9mcmVlX3BhZ2Uoc3RydWN0IHBhZ2UgKnBhZ2UpDQo+ICt7DQo+ICsJ
aWYgKCFwYWdlKQ0KPiArCQlyZXR1cm47DQo+ICsNCj4gKwl0ZHhfcGFtdF9wdXQocGFnZSk7DQo+
ICsJX19mcmVlX3BhZ2UocGFnZSk7DQo+ICt9DQo+ICsNCg0KSU1PIHRoZSB0d28gc2hvdWxkIGJl
IG1vdmVkIHRvIHRoZSBURFggY29yZSBjb2RlLCBhbmQgZXhwb3J0ZWQgZm9yIEtWTSB0byB1c2Uu
DQoNClRoZXkgY2FuIGJlIHVzZWQgZm9yIG90aGVyIGtlcm5lbCBjb21wb25lbnRzIGZvciBURFgg
Q29ubmVjdC4gDQo=

