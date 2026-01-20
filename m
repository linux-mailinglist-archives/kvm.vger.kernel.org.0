Return-Path: <kvm+bounces-68660-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YEUiM4AGcGmUUgAAu9opvQ
	(envelope-from <kvm+bounces-68660-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 23:49:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7660A4D3FF
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 23:49:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D2D557ECCC7
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 22:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B32EC3D1CC1;
	Tue, 20 Jan 2026 22:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JZJtxemz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9883D2FF4;
	Tue, 20 Jan 2026 22:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768948699; cv=fail; b=dLixAXDW6Hwq5m08pVF+L/IOYif+ShWLa1Uo57xyAmQWoNE6q6ZhrAtfZ8SEqwkx9R8XQKgkefCC6PdmpMLuDYJSujZw7aggyGpiQYov3jAmDCZRU3nyZIWYH90BfiFNj0cvNxNCo13rBnEOGrbt3mZpsR2JWdJWEhQkYAPC4BQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768948699; c=relaxed/simple;
	bh=f63ai9aNnYiMADo+M8JyhmwXcwrwcRJt8MvIqJYNZnI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nQfCQxRV3fPV90MznoRRu/CyDl+dr5UZtyMOMHLtTj917ma1kIuxaVptrNbJkd5Jo1wydEyu4keM+ZHU8lc1hhPu2Vx8FrOV6mrFbpV5DBvMNcL91AOyFWtp9Z3d8Y2GTRh1d1cMTWvksRg2aMasAC+6Ta6QDv5HovPIVcMWNQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JZJtxemz; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768948697; x=1800484697;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f63ai9aNnYiMADo+M8JyhmwXcwrwcRJt8MvIqJYNZnI=;
  b=JZJtxemzBBl9iYvpU8EOL9UgG/v0vhjaTWWHUeMkD8sARZ5PHmumEbZi
   a+V3Mlk9XRKOu8cLeBAqAkGttLmh5tRGEdEhFksH7Z6ZOO0S6l1OegzjE
   DTxbiDT0CfMFvMQEaGmQwnX7b9PDddG8jz/RJIw7bBH4FfQowTIeuSJrh
   eRYg1WwHBmCvz0eu9VynoOi6lU/DgCeOY97dhKrhYylZeAeJpkL81BgP9
   2Iehi1jE7nBjkozm99/bULUdlpq6n5g/LKmnJOZUPt6bSA6+iCGWEOS8y
   HAZ5ELcsiajykSUf26QXRMhPw7HFzq6LeRa4R+BS6GtugGCkZycUt9vrW
   w==;
X-CSE-ConnectionGUID: tw2uJfM9S1i25hLDYUDAfQ==
X-CSE-MsgGUID: xx7GiGjLSbyhddYb/xglpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="80475661"
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="80475661"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 14:38:16 -0800
X-CSE-ConnectionGUID: z9GczPOdRz+A/zrke5DfgA==
X-CSE-MsgGUID: 4cymysfkS5qoEWH1BK7c0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="205888299"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 14:38:16 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 14:38:16 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 14:38:16 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.71) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 14:38:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YVwRbvyheWQooML2aEhuRMyyP0DromQrJ7XowVN659BQwuwLDPqYv8AsOk4FLjmvZ3E1DyDkCbpyX4gEGDJHgIexYipef2I8sG7cUbMyy8yAN4lf+OAmVILoUg16w7diYDRLAvEO65dsJphU+N1aFRinObFzlfqvas9MEdSOXxMAdu1VTWvVxi9v9QVqdBgODbWBLOHJGvTV2rYSnxyJZm+H0x8U/FTRHoRNw72Zz8nV7Zsrk0xqGiNLXOJcOQYF8YFBm8EooJ/KEiLUa4te2cmvd4aNSA/xdQGdvNfaVwa7qpSTGeNudhv5xP3ij/aPxklusD4uJQ7z19uJNV2MgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f63ai9aNnYiMADo+M8JyhmwXcwrwcRJt8MvIqJYNZnI=;
 b=ke9TnwLMcVbEuyP11dWOnqbA+FZTfdJad4MOyCkYAX/26rkOcTCsvuk2xsdAtXStOEIMIO4hGoiG8BEh2gmiS9ffOd5xTDY7Ds2A1Iz8YTEWqBfLi4/zQYMh0hfsi3EsEQShVYm4HGabAH6/ip/BF4jymf5dnAZCcbz3JV8q/RdEkoSZO+XK0Xev+SCJf0cRDbhKcHE8HjR/SFrUsDOyJRzk/o8nDgDoQSOqIh1FB2JvN0DoNFZ+etq+bZn8Pc+1OdyBDsT/PZ9q4x5skUYdAuFHly+LIx3t4T0rP1VnZVe+0f7KJ/Ezd89PcMFhgzlsl3+F76r3Ycs5DXOMKYXtFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN2PR11MB4709.namprd11.prod.outlook.com (2603:10b6:208:267::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 22:38:07 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 22:38:07 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@kernel.org"
	<tglx@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>
Subject: Re: [PATCH] x86/tdx: Use pg_level in TDX APIs, not the TDX-Module's
 0-based level
Thread-Topic: [PATCH] x86/tdx: Use pg_level in TDX APIs, not the TDX-Module's
 0-based level
Thread-Index: AQHcikztMjfJNzKvpEK6L02KgpqeNLVbpkkA
Date: Tue, 20 Jan 2026 22:38:07 +0000
Message-ID: <7a33ca7002696a666e2b51fc80ce01bac1381e3f.camel@intel.com>
References: <20260120203937.1447592-1-seanjc@google.com>
In-Reply-To: <20260120203937.1447592-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN2PR11MB4709:EE_
x-ms-office365-filtering-correlation-id: d21f8cb1-c19d-4315-418d-08de5874952a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NFlia3FDVnNuemtldWtHOFBsWnhwOEN4aG5WdjQ5VTNnczcrVzFKKzhGelhi?=
 =?utf-8?B?WTNlZWE4TGEyQWNVZlJ5R2RjZWJ6dldTSXVOVlpGOXRHemRGaEJCZkdITkpT?=
 =?utf-8?B?ME8veWZoc24zQXJTcDBoVTM4M2JYL3lqNTNlVVBuVVBXOUZvOTZNM0x5U1FP?=
 =?utf-8?B?ZE5lWmFyVFkxa3poMEFNcnhoOXduUVN0UWNqcHBEcFlTWUxncXFsL0JNZnhQ?=
 =?utf-8?B?blNiVGlJTEIvQnpiS3VtWDF5bCt5REF4Q3A0NzMrL0tpS00wN25oVmR3aC8r?=
 =?utf-8?B?K2xLZFVTcDRkaGdWVlZQVkJZOVBSU1pXYjErMTY3NXNzQ3pCZ1pVYWZocVhz?=
 =?utf-8?B?VktPaG80a1FUeWxDSEphREpuUTZSeFZJQUR5ZTBVZjFtT01mTVVBYjhodGNi?=
 =?utf-8?B?N0VoL3A0V2VKUEdkcUxYVm1taDJkMExHTVRGTkFJSU9ld2hrOHR1S2lTWlFp?=
 =?utf-8?B?SVp0OTlrVDNOd1NsNmZzWk91NnNPL2xlWEhoNENibHRITzJybG1lY1l4Vkc1?=
 =?utf-8?B?ZHU4WVpXK0ZHWVlRNWg0Yjl5Nmo0eU9mYVlPVjd4L3ZsUEJtUHMyVzlLRVpO?=
 =?utf-8?B?cDE3QklLaExKVVJxR1AvblhyeTdvOFRKZENEVDhzMzh2NzJhYlF2VDZRbEx4?=
 =?utf-8?B?TFdhMU15ZVBGSlNzODFsM1FMdUtZbEJvNFJBTGtJdll4K2lwOHFDcUxBS0gx?=
 =?utf-8?B?N1FVR2Q5YzZiM0F0V0szd3EzenFzcEY3bWZJMU04VVFYRFoxK1V0bmtQTnUw?=
 =?utf-8?B?Q1JBUGJyd2Zac0F5SkZQYkVGTVFtVm1ZTEw0a093Q09oRjVLT2M3VnlNa09r?=
 =?utf-8?B?VFZlNjJqclI0SEx5RzZaNStNWTNURk00VEx0K1UwOWY5RVdRT25FbGZIR2pz?=
 =?utf-8?B?VGRIOC85ZWUxMXRweSt2N0VvaTYwcHVBNnBNT1BCczczVmFyaDZLMlg1amtI?=
 =?utf-8?B?THFQNDIrK053VmgvcDVyUjVLMjNhUWczSWhpSTRKVTRBdG1ybW8xNGxCdmsy?=
 =?utf-8?B?WnZib28xV2ZDeG4wdk1jcGYwWS9OV1I2bGMxd0xhUVpYc3p0TG1qczY0WXlC?=
 =?utf-8?B?YVZrNFphUmZlek0wejZuNlVCUDd0MXFaTW1BWDRLMkZxLzlmRzhBMUhGZ0Ir?=
 =?utf-8?B?TDBBcTd5K1REN0FaTGtEdkt5OVlRcjNmUVF1Nkl3M2hSRTRZY0VEMzhWdVJo?=
 =?utf-8?B?c2ZoVmtZTVNYajN2RFFVaUU2MHFWTFRPVXVYdTV0OS8vemJsRGE4OXY2NUhK?=
 =?utf-8?B?L0N6YVVvZ09WcllGdCtvbzRUNXhJNVBKWTVNSkppZVFEOEwxMHVjT0s1UEtp?=
 =?utf-8?B?c2pRQmpHSjFDWHFSOXAzUm50T25XeUpUcmhGUVZQK3N2MExkM1hkRzJLYmc5?=
 =?utf-8?B?aVY2NkFoR2JkRzFhNGdGSGRlRjlZVitjWFV1OXdxTDNOaTZNd0xuY2dmd0pH?=
 =?utf-8?B?bzVrS1FtaVlKcm1kNGx1V3dyd2tJUklld1M2ajlhOEc0b0I1MURncjVhQTkz?=
 =?utf-8?B?K2Z0c3ZiWVlZcFZacTRSd1ZMVnQ1TXZWNXhkcGRTWEN4Y2s3eDg1R2EvRzll?=
 =?utf-8?B?THQ0WU10MGROK24vcjdoaXF0Ry81RURBdVdrbkFyR0tBdGRZUGRzbzVpcjFn?=
 =?utf-8?B?bnU2Z3VUOE1RcDJuNmlHd3d6cU5uajI5Nk5JQzk2aDI0M1NUM3IwbXlKM2U0?=
 =?utf-8?B?M2hjdVAyQS9vaVhaa1VWYlhZWmZHZm5YOEYyaXMrMEtUK0pLQnhieHQrd1Rh?=
 =?utf-8?B?U2x5UXBrZmVIR2ptVEdpbWRqSDhDRG40dTlGWExldGZwQSsyNVgwbjRSTDRG?=
 =?utf-8?B?MEpsWDRvSTN4SERwdW5FRFRjOTJha29xSmo2RE9oNk5FT3l1ZDR0dU9BQ0dM?=
 =?utf-8?B?Z2xTKzhVYzFoTzN3WHJJRG9TZUFOc0FXcUxIYjNQK2dSSWZlSXJZcXNlZHJz?=
 =?utf-8?B?N0FCSTcxWFRYWGdtS21DaTZDYjNwbEx3UTJobHo0L0dWWTZnNVBWTVFIcFNp?=
 =?utf-8?B?aXNUNUJ5SGdLWVRGMGRWaWs4ZVJ5QUJIdEhOZlZNRjJFN25jRW9Xa1FXNks4?=
 =?utf-8?B?aHFOc0I2SEl2Mi9GQ3pDeUtjWTR3dHlFNmd4TUZrdE9RQitVcC9ZUEVRampk?=
 =?utf-8?B?RjdHN084ZDE4dkFieStDZnB1d2c1YmxkNFRMNjE0dWlNS2JLN3VqOEs4Q1dz?=
 =?utf-8?Q?jFy/2fBj6CjtNJc5HJMnLSU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXhXUWl6SWVJZC9lbFo2bXRlSEM1KzRVc29XRGJrYmpvd2xPK3g2bmw2YmhI?=
 =?utf-8?B?NEZSRm9CbWk2ZXRnOXpkb3VmSEZFZyttelZ6bkk3OEkyaEpWS1FENXNnS3B3?=
 =?utf-8?B?Ujd5NDZWWG5SZW9UNVRuRkJNZE1Fcm5id1dDT2t3UDQrNzkxbG5BUXF1T1Bp?=
 =?utf-8?B?V3RwZ2FaYjRYRkRVUlBBWFNDSnhtOUsyRGRUWlM4MUdpV3VFY042OGxaUHZz?=
 =?utf-8?B?L0hSYmlLZDFvTDJVVjFnenRHVGx1M2o4QmhRL2FTclhVWkFyWktiY3dZbld2?=
 =?utf-8?B?cG9icUxyYUErL1FiQStqb3Z0ZXpmN3lic0FhUS9ncXd3Y043NVkrYXAxSjFO?=
 =?utf-8?B?QVlUMThwRGhvMzczTzlLTkJSS2lBM3RnVzhHV2NmL2cwbmNPaTEvTGp5OWl3?=
 =?utf-8?B?aHB2U3lhQmZ5V3M2TzM1SjRxeDNNME1wWjFieS9QWkdTdkdCd0Judnp2dWIz?=
 =?utf-8?B?UzVUb2dVNHgzTzNsZ1k1SkRMMlo0VG4vaHRNSWcwREJIdUptRXhHdTVxQ2Ez?=
 =?utf-8?B?SU5waklYbkREeldTTXo4QlJFYzg3Wmk5Kzh4VXdhcG1nRXNzUDg5OURyejY1?=
 =?utf-8?B?VHJ5TFc3MGVGRm0vZ2c4aS9SZmU1YmJVa2lDSWpXSExZMkEwUlM0ZzVsQ1Qr?=
 =?utf-8?B?b3Zmd1pxQ3JENkNWQWlrcUZRZTVJTDg0eUxSS0xrYXFRS21oaFZ2cy9lcnFl?=
 =?utf-8?B?dFV4cDVDNllqQjVyU3VZbEc1aGtKV012UUpDTHlyRkl4dGRuekFId0laUWJX?=
 =?utf-8?B?OXp2MnBpSitKQU9TNWt6L0duZ0kvTysrZG16VFV2TEYvSTlpNE5jYXUyOFR2?=
 =?utf-8?B?RlRodktpcGw3RXNPeFBQcDZqaHJ1QlJjNHVXRWs3Wm96MWRPb0plNFllUklx?=
 =?utf-8?B?VFZlL2dDYlFoUmQzK2txU3I0WUE3MlptcFNsYWJpTlBkV1FTaFk2RkR2OGFD?=
 =?utf-8?B?a0ZqTExDN2Q4Nk5UK0RsdzNvTFQ2VG1JVFljNEg2VGgvTFAyOFZFS1lYS3Ro?=
 =?utf-8?B?RnBlYlRrS3BIRGp5RDFZQ1hxdzI2eVNDNTZhREtMR216eVRoV1k5R3Q0SVBS?=
 =?utf-8?B?UitpWlJSSFhiNWJIQTBSNW1zNWF1eWVGOGIwOEdEWEVVQTllZ2lOUHlkUEg1?=
 =?utf-8?B?WWQ3dXc0ODFWUy8yVytic2x0RFVndTJXMEVjNzQ2c0FMT2NkZlBQQ3JGb2Yv?=
 =?utf-8?B?WVpjR0Y2K2c1MTlXNVhLOXZIYmROaGxobS9CT0ZFYkdpMXhIMjBTRXhRNmYr?=
 =?utf-8?B?QjU0QjBlOXBhOGFXNWRDS1p0bEJWZEtNcWhlTTg4VWhVYnFhYnFhcE9Ba013?=
 =?utf-8?B?WjRHK1ZLSlJTNm5qNkpEZytaV2JLaDdFcW1iT3lXTjEwWTF2bFArdFphYm9S?=
 =?utf-8?B?YUYzRTBiTy9aMnp2M1N2ajNrUnhIckdLN1FCV0pRSno4dHZkQzc1eUFPTTZS?=
 =?utf-8?B?T3I4dWxPeDN3T1o5YWsxVElUeGMxZVU4eGxJOE9kZVRGS0xZWVJ2Z3VFSjls?=
 =?utf-8?B?WXV6UGhhbGYrR3UzbUJZMVQ0VUZNZncyZkRXNTduSUVGQm9GOVE1NmE4OTRD?=
 =?utf-8?B?SUNJV0tsdEppNUNQeGtlN3hmK1Y0dVZOWXdHR1RRTEg0RWlubTVTcm1hdXZ1?=
 =?utf-8?B?eUZQVE5HRGJBQ090MmYyUGIzYzFyQlJIcDlJZGpNWTRBbG9WVzJGczdSQ0FW?=
 =?utf-8?B?alVTQVVCbnJuUDVDYUhjN2VMdkszMThNSkJvOE9HT3gxNVhjS29Fc0FOZ0cy?=
 =?utf-8?B?Nm91aHBPQTJQS3ZOWlg3bWNRSDhkaDcxeE9KR0F0UlIxajZjaDMxeG93TW80?=
 =?utf-8?B?eE5MNWdDVE8vcDlRZmpKb0dLVG0ybis2WWxFREJPNFJYbmRmbEU4OGsvdVFo?=
 =?utf-8?B?MTUvek5Nek5xNlY5NlN3cUxzZzRiOWhpUUhuemNKQjhSYlNDUmE0TG44R3Ax?=
 =?utf-8?B?N1RIL2FuZEZVMU45b0hOK1J4ajRaOS9NbFZra0ticU1teXNMUStSQ2x1aTZI?=
 =?utf-8?B?QkVrbGZTQjltbW1xSG9NUURjOE45MTFsUHJmL1pacGU3QjJUeVVWRWxhN1oy?=
 =?utf-8?B?UURKekpqVlUwVTc4M00zTkxxMStQQmU4VDN6VWZJeWhjZzhENmxTOTNGMDJT?=
 =?utf-8?B?T2pnOFJ0TFNxd25FOUdOUlhOSmFMQ3B3dEQyQnBtQXNFcG5PYUxYZ21qWmF2?=
 =?utf-8?B?Und0REdEMjVVRmVxbmRnd1hzTDRieUlpcWRvNmZnK1BoRjJHMDlHYkJwTGJk?=
 =?utf-8?B?US9FWTVUV0NFdUVxNHcrOXNRbjZlWTRGUjlsTHNVemY2N2tTYWtKQnFuWk1u?=
 =?utf-8?B?aE1LWTIvRDFkNGZwcG9ZMGNDQkk2WnZmUWxZdW9aQVZEOG1hWkVEb1FDYjNF?=
 =?utf-8?Q?OHI6pOGKR3znsDeY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EEDDDCF067B48F4086D174FF15975B30@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d21f8cb1-c19d-4315-418d-08de5874952a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2026 22:38:07.4221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xBqiPKWQRsCP0BOw2u7YkbgUycE+akODWl7FgIu+I5mCrBlFy927TXvWGJif9uLqxF/jr0CwT4BCIm0Mud0fG/op84dOfggDdR1oFUR7HGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4709
X-OriginatorOrg: intel.com
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	TAGGED_FROM(0.00)[bounces-68660-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 7660A4D3FF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

T24gVHVlLCAyMDI2LTAxLTIwIGF0IDEyOjM5IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IFJld29yayB0aGUgVERYIEFQSXMgdG8gdGFrZSB0aGUga2VybmVsJ3MgMS1iYXNl
ZCBwZ19sZXZlbCBlbnVtLCBub3QgdGhlDQo+ID4gVERYLU1vZHVsZSdzIDAtYmFzZWQgbGV2ZWwu
wqAgVGhlIEFQSXMgYXJlIF9rZXJuZWxfIEFQSXMsIG5vdCBURFgtTW9kdWxlDQo+ID4gQVBJcywg
YW5kIHRoZSBrZXJuZWwgKGFuZCBLVk0pIHVzZXMgImVudW0gcGdfbGV2ZWwiIGxpdGVyYWxseSBl
dmVyeXdoZXJlLg0KPiA+IA0KPiA+IFVzaW5nICJlbnVtIHBnX2xldmVsIiBlbGltaW5hdGVzIGFt
YmlndWl0eSB3aGVuIGxvb2tpbmcgYXQgdGhlIEFQSXMgKGl0J3MNCj4gPiBOT1QgY2xlYXIgdGhh
dCAiaW50IGxldmVsIiByZWZlcnMgdG8gdGhlIFREWC1Nb2R1bGUncyBsZXZlbCksIGFuZCB3aWxs
DQo+ID4gYWxsb3cgZm9yIHVzaW5nIGV4aXN0aW5nIGhlbHBlcnMgbGlrZSBwYWdlX2xldmVsX3Np
emUoKSB3aGVuIHN1cHBvcnQgZm9yDQo+ID4gaHVnZXBhZ2VzIGlzIGFkZGVkIHRvIHRoZSBTLUVQ
VCBBUElzLg0KPiA+IA0KPiA+IE5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVkLg0KDQpNYWtl
cyBzZW5zZS4NCg0KUmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJl
QGludGVsLmNvbT4NClRlc3RlZC1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVA
aW50ZWwuY29tPg0KDQo+ID4gDQo+ID4gQ2M6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNv
bT4NCj4gPiBDYzogRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGxpbnV4LmludGVsLmNvbT4NCj4g
PiBDYzogUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0KPiA+IENj
OiBZYW4gWmhhbyA8eWFuLnkuemhhb0BpbnRlbC5jb20+DQo+ID4gQ2M6IFZpc2hhbCBBbm5hcHVy
dmUgPHZhbm5hcHVydmVAZ29vZ2xlLmNvbT4NCj4gPiBDYzogQWNrZXJsZXkgVG5nIDxhY2tlcmxl
eXRuZ0Bnb29nbGUuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPg0KPiA+IC0tLQ0KPiA+IA0KPiA+IENvbXBpbGUtdGVzdGVkIG9u
bHkuwqAgQ2FtZSBhY3Jvc3MgdGhpcyB3aGVuIGxvb2tpbmcgYXQgdGhlIFMtRVBUIGh1Z2VwYWdl
DQo+ID4gc2VyaWVzLCBzcGVjaWZpY2FsbHkgdGhpcyBjb2RlOg0KPiA+IMKgIA0KPiA+IMKgwqAg
dW5zaWduZWQgbG9uZyBucGFnZXMgPSAxIDw8IChsZXZlbCAqIFBURV9TSElGVCk7DQo+ID4gDQo+
ID4gd2hpY2ggSSB3YXMgX3N1cmVfIHdhcyBicm9rZW4sIHVudGlsIEkgcmVhbGl6ZWQgQGxldmVs
IHdhc24ndCB3aGF0IEkgdGhvdWdodA0KPiA+IGl0IHdhcy4NCj4gPiDCoA0KPiA+IMKgYXJjaC94
ODYvaW5jbHVkZS9hc20vdGR4LmjCoCB8IDE0ICsrKystLS0tLS0tLS0tDQo+ID4gwqBhcmNoL3g4
Ni9rdm0vdm14L3RkeC5jwqDCoMKgwqDCoCB8IDExICsrKystLS0tLS0tDQo+ID4gwqBhcmNoL3g4
Ni92aXJ0L3ZteC90ZHgvdGR4LmMgfCAyNiArKysrKysrKysrKysrKysrKystLS0tLS0tLQ0KPiA+
IMKgMyBmaWxlcyBjaGFuZ2VkLCAyNiBpbnNlcnRpb25zKCspLCAyNSBkZWxldGlvbnMoLSkNCg0K
VGhlIGxpbmUgaW5jcmVhc2UgaXMganVzdCBmcm9tIHdyYXBwZWQgbGluZXMsIHNvIGl0J3Mga2lu
ZGEgbGVzcyBjb2RlLg0KDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUv
YXNtL3RkeC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4gPiBpbmRleCA2YjMzOGQ3
ZjAxYjcuLmJjMGQwM2U3MGZkNiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS90ZHguaA0KPiA+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQo+ID4gQEAgLTE4
OSwxOSArMTg5LDEzIEBAIHN0YXRpYyBpbmxpbmUgdTY0IG1rX2tleWVkX3BhZGRyKHUxNiBoa2lk
LCBzdHJ1Y3QgcGFnZSAqcGFnZSkNCj4gPiDCoAlyZXR1cm4gcmV0Ow0KPiA+IMKgfQ0KPiA+IMKg
DQo+ID4gLXN0YXRpYyBpbmxpbmUgaW50IHBnX2xldmVsX3RvX3RkeF9zZXB0X2xldmVsKGVudW0g
cGdfbGV2ZWwgbGV2ZWwpDQo+ID4gLXsNCj4gPiAtwqDCoMKgwqDCoMKgwqAgV0FSTl9PTl9PTkNF
KGxldmVsID09IFBHX0xFVkVMX05PTkUpOw0KPiA+IC3CoMKgwqDCoMKgwqDCoCByZXR1cm4gbGV2
ZWwgLSAxOw0KPiA+IC19DQo+ID4gLQ0KPiA+IMKgdTY0IHRkaF92cF9lbnRlcihzdHJ1Y3QgdGR4
X3ZwICp2cCwgc3RydWN0IHRkeF9tb2R1bGVfYXJncyAqYXJncyk7DQo+ID4gwqB1NjQgdGRoX21u
Z19hZGRjeChzdHJ1Y3QgdGR4X3RkICp0ZCwgc3RydWN0IHBhZ2UgKnRkY3NfcGFnZSk7DQo+ID4g
wqB1NjQgdGRoX21lbV9wYWdlX2FkZChzdHJ1Y3QgdGR4X3RkICp0ZCwgdTY0IGdwYSwgc3RydWN0
IHBhZ2UgKnBhZ2UsIHN0cnVjdCBwYWdlICpzb3VyY2UsIHU2NCAqZXh0X2VycjEsIHU2NCAqZXh0
X2VycjIpOw0KPiA+IC11NjQgdGRoX21lbV9zZXB0X2FkZChzdHJ1Y3QgdGR4X3RkICp0ZCwgdTY0
IGdwYSwgaW50IGxldmVsLCBzdHJ1Y3QgcGFnZSAqcGFnZSwgdTY0ICpleHRfZXJyMSwgdTY0ICpl
eHRfZXJyMik7DQo+ID4gK3U2NCB0ZGhfbWVtX3NlcHRfYWRkKHN0cnVjdCB0ZHhfdGQgKnRkLCB1
NjQgZ3BhLCBlbnVtIHBnX2xldmVsIGxldmVsLCBzdHJ1Y3QgcGFnZSAqcGFnZSwgdTY0ICpleHRf
ZXJyMSwgdTY0ICpleHRfZXJyMik7DQo+ID4gwqB1NjQgdGRoX3ZwX2FkZGN4KHN0cnVjdCB0ZHhf
dnAgKnZwLCBzdHJ1Y3QgcGFnZSAqdGRjeF9wYWdlKTsNCj4gPiAtdTY0IHRkaF9tZW1fcGFnZV9h
dWcoc3RydWN0IHRkeF90ZCAqdGQsIHU2NCBncGEsIGludCBsZXZlbCwgc3RydWN0IHBhZ2UgKnBh
Z2UsIHU2NCAqZXh0X2VycjEsIHU2NCAqZXh0X2VycjIpOw0KPiA+IC11NjQgdGRoX21lbV9yYW5n
ZV9ibG9jayhzdHJ1Y3QgdGR4X3RkICp0ZCwgdTY0IGdwYSwgaW50IGxldmVsLCB1NjQgKmV4dF9l
cnIxLCB1NjQgKmV4dF9lcnIyKTsNCj4gPiArdTY0IHRkaF9tZW1fcGFnZV9hdWcoc3RydWN0IHRk
eF90ZCAqdGQsIHU2NCBncGEsIGVudW0gcGdfbGV2ZWwgbGV2ZWwsIHN0cnVjdCBwYWdlICpwYWdl
LCB1NjQgKmV4dF9lcnIxLCB1NjQgKmV4dF9lcnIyKTsNCj4gPiArdTY0IHRkaF9tZW1fcmFuZ2Vf
YmxvY2soc3RydWN0IHRkeF90ZCAqdGQsIHU2NCBncGEsIGVudW0gcGdfbGV2ZWwgbGV2ZWwsIHU2
NCAqZXh0X2VycjEsIHU2NCAqZXh0X2VycjIpOw0KPiA+IMKgdTY0IHRkaF9tbmdfa2V5X2NvbmZp
ZyhzdHJ1Y3QgdGR4X3RkICp0ZCk7DQo+ID4gwqB1NjQgdGRoX21uZ19jcmVhdGUoc3RydWN0IHRk
eF90ZCAqdGQsIHUxNiBoa2lkKTsNCj4gPiDCoHU2NCB0ZGhfdnBfY3JlYXRlKHN0cnVjdCB0ZHhf
dGQgKnRkLCBzdHJ1Y3QgdGR4X3ZwICp2cCk7DQo+ID4gQEAgLTIxNyw3ICsyMTEsNyBAQCB1NjQg
dGRoX3ZwX3JkKHN0cnVjdCB0ZHhfdnAgKnZwLCB1NjQgZmllbGQsIHU2NCAqZGF0YSk7DQo+ID4g
wqB1NjQgdGRoX3ZwX3dyKHN0cnVjdCB0ZHhfdnAgKnZwLCB1NjQgZmllbGQsIHU2NCBkYXRhLCB1
NjQgbWFzayk7DQo+ID4gwqB1NjQgdGRoX3BoeW1lbV9wYWdlX3JlY2xhaW0oc3RydWN0IHBhZ2Ug
KnBhZ2UsIHU2NCAqdGR4X3B0LCB1NjQgKnRkeF9vd25lciwgdTY0ICp0ZHhfc2l6ZSk7DQo+ID4g
wqB1NjQgdGRoX21lbV90cmFjayhzdHJ1Y3QgdGR4X3RkICp0ZHIpOw0KPiA+IC11NjQgdGRoX21l
bV9wYWdlX3JlbW92ZShzdHJ1Y3QgdGR4X3RkICp0ZCwgdTY0IGdwYSwgdTY0IGxldmVsLCB1NjQg
KmV4dF9lcnIxLCB1NjQgKmV4dF9lcnIyKTsNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5XVEgsIG9vcHMuDQo+ID4gK3U2NCB0ZGhfbWVt
X3BhZ2VfcmVtb3ZlKHN0cnVjdCB0ZHhfdGQgKnRkLCB1NjQgZ3BhLCBlbnVtIHBnX2xldmVsIGxl
dmVsLCB1NjQgKmV4dF9lcnIxLCB1NjQgKmV4dF9lcnIyKTsNCj4gPiDCoHU2NCB0ZGhfcGh5bWVt
X2NhY2hlX3diKGJvb2wgcmVzdW1lKTsNCj4gPiDCoHU2NCB0ZGhfcGh5bWVtX3BhZ2Vfd2JpbnZk
X3RkcihzdHJ1Y3QgdGR4X3RkICp0ZCk7DQo+ID4gwqB1NjQgdGRoX3BoeW1lbV9wYWdlX3diaW52
ZF9oa2lkKHU2NCBoa2lkLCBzdHJ1Y3QgcGFnZSAqcGFnZSk7DQoNCg==

