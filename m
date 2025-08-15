Return-Path: <kvm+bounces-54700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31510B2734A
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:02:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76AB960042E
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:01:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1CDCA5E;
	Fri, 15 Aug 2025 00:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MxJEqWjN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0385319A;
	Fri, 15 Aug 2025 00:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755216088; cv=fail; b=dJqdKtPNAy76lBtn6GJdIaO0tUcx79kmXJqcX1x7nuYzj5ep7jKLYwuLc9dWfdcOgf7hrgeDTYvvb360uNeU0P1BSYJf8bzofYHUrMtLla64YrYYF3QmedRRSJGCKUKckA1hV9Dl6AyRVUsmbRrlWn0UAm8oYTtG3MOcBlZyGuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755216088; c=relaxed/simple;
	bh=tLQvGOTe50aatWVhxTFlfO2IMx1N43NcMTOWlNJxGYk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qlf/ZEw7FlRNccxMtOGt8T4bedrILbdJz6dnfelv/1Wz45RB/TJFVSfDksQo6eNtYnWc9358lL2yQzTvC74hZCk21ZrcrEZqNGgf8vwxIKup9YRgkmkHGJ+xOz59U5XcDt+Jyt3NP+uksxrGa6XmPRt1T85rlMkYf321ze9aylA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MxJEqWjN; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755216087; x=1786752087;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tLQvGOTe50aatWVhxTFlfO2IMx1N43NcMTOWlNJxGYk=;
  b=MxJEqWjNguwxAV/vJ2WpjsHsoJ6pPukUxLc1gXLs9+aP9zkB2hXZVNcX
   lrp4W0r+V5PqvlP7Tu+Ln2nPLqHksB+vJnTL9YfQRiGW0sbmZhYF3eTus
   uwdpr8ZV+sWpxx0AxQpThV7D7gtFmIwgdCubmEZZ2z8O62Wa+K9Ry/wLK
   uhWj5fhZrhmfgY/jDh2uJfA8LKaw2Qlzn4bqYXTEppWekkEgIYcI/ZaRE
   9RvD5Fh+YaaUIvVc44btOmKSbY1PLOxog0PztqAC8+6U7a9gsPuDo6FuE
   JLNBUOqXcIPK0HYw2HU1qrWNs4aRAP+kKl/DojDdwjqj1K4ZApFNtc2O3
   w==;
X-CSE-ConnectionGUID: Dj4hNYdMSHKTNbq7Z27LoA==
X-CSE-MsgGUID: SbviUDlsRSeq3S+i8P0aqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57497553"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57497553"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 17:01:26 -0700
X-CSE-ConnectionGUID: 2OPMv7txSWSLckYknneh3Q==
X-CSE-MsgGUID: 1ZX1Nq4cSG63WhpBurcuAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="172112864"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 17:01:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 17:01:25 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 17:01:25 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.87)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 17:00:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xSKNma7yrMhFT4JLy5Gy9XqWaOFLSvVoBahbwhg4QiN/9etT6HG3WRkF/ZoFatCnwtvvFL9OHh+dEGgZftfu49VEMNqAy3ZTxHH1O7gBTV3sTLAFMbFiEBgfZZ9wOBCv0D067pWIV3wD2fZu1u+IUNv+UBmAoMgsf9fQvvz737RwbMAZwn1jsyt34rOJZwbMnnHG4uoObYQfzgzHB/hs3wSGMEIx2pQi24jQ5aWtxAZjL35tHEzC3Tcj2JBM9D+V8Xf7WWzxv+gKwY9SeFkit/bwK22v5KebH2RBn0ddH32ISGvVSHUhXQR+oRf0Rrr41om6Jpuoqd1vveAnEHtPjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tLQvGOTe50aatWVhxTFlfO2IMx1N43NcMTOWlNJxGYk=;
 b=U7JIzMOfUm6x7c9yZibrSgq9Y4DV9tULyr8o6tLEoHcAmBjsSmUbWuKMVwbSaOnXCPGyLaKca5DkCPxI9kE7UINeoDSYhpACH3DNlf6ZRDtbu+BTyrOdcvwhj6HL/7DX0rr8ZIOWaTUUG1ZM631d6M9AlxnF6pjEqN111q0oa6xEgl8Pk80IRA9GISsQuJXCet/E/I/qxet/KrVNlyB9b9SSkNUAXQNK0T2KAyqsd8TeCVyd0a4u4vwoz8Vr6WEoHKuxqhUywHW8lkNDLIdPhdBluIiGIVe64jAmQRDZdfn/4F2XWHtXgyQWNuPrFUhZZLtzG2Yl8eZhWECa3xfsqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA3PR11MB8940.namprd11.prod.outlook.com (2603:10b6:208:57e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Fri, 15 Aug
 2025 00:00:50 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 00:00:50 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Gao, Chao" <chao.gao@intel.com>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Topic: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Index: AQHcDKj0KRQjWZhTjEidjLxSJo7SHrRiLIQAgAAdHQCAACfSgIAASCAAgAAR1ICAAAqVgA==
Date: Fri, 15 Aug 2025 00:00:50 +0000
Message-ID: <f5101cfa773a5dd89dd40ff9023024f4782b8123.camel@intel.com>
References: <cover.1755126788.git.kai.huang@intel.com>
	 <d8993692714829a2b1671412cdd684781c43d54a.1755126788.git.kai.huang@intel.com>
	 <aJ3qhtzwHIRPrLK7@google.com>
	 <ebd8132d5c0d4b1994802028a2bef01bd45e62a2.camel@intel.com>
	 <aJ4kWcuyNIpCnaXE@google.com>
	 <d2e33db367b503dde2f342de3cedb3b8fa29cc42.camel@intel.com>
	 <aJ5vz33PCCqtScJa@google.com>
In-Reply-To: <aJ5vz33PCCqtScJa@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA3PR11MB8940:EE_
x-ms-office365-filtering-correlation-id: cac181e5-5be7-448e-0234-08dddb8ecba4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dVZxbkdXQ2VhMjZBU2pNUkl0dllNWnBnMForSXR6UFhRdnBVR1EvZDhpYXYr?=
 =?utf-8?B?cStIaUUrVko0ekExM2tReFVhSWNQa1hHblBVTjk3SzF6V2hpanFlUDlNSjdr?=
 =?utf-8?B?Skprc0hCOEg2TlVMNWtLeVVEdFBHbU81cmlRRVZLL1psQXk5R012Zit1Z2M0?=
 =?utf-8?B?N2NaQ21jMFhQcWhpV0E4NzlRZDdCNTI0aThHb2lBZGtkLzhSTCt0ZGpJazcv?=
 =?utf-8?B?K2NiUHdTWFZibU1xTUNjbXJoaEhLWWJ5cDJhZXBvK1VEMkpqK1cvUlN2by9Z?=
 =?utf-8?B?WWVhMlAyTzFiL2VReVlicTFKOXpiQ3FVM2hvYXBKU09aRFNySkh6ai80UE9w?=
 =?utf-8?B?ODJlYWlkUytwYmQ5WXBRalJLR1dqY2JlbitGM1Zaa1dIQTZJYU12ci94Qi80?=
 =?utf-8?B?SUR4TmRsaThtYkpxOUVuY1hOcUF4MVFhOFVwWjJPQXdoc2M3dFlvZEphRW9J?=
 =?utf-8?B?QktjZ1JRblFCYis5MEtXM1pSVk5uUjVQK0lSVG5KWWFURk93MUJZdE5NenJX?=
 =?utf-8?B?R0k4aUgybVlPaVdnMWdXRFlDWHR2dlo5UTRDYjJTY3BxQ0svWDVDclcwQlZV?=
 =?utf-8?B?SithYzdtQngrU0d1N3dnbm40QjIzN01RL0NVUHIvVkZxU3Viek10emJSSWJk?=
 =?utf-8?B?T3ZicTgyVVZsejlWN0dnYzdMOGhpaU42Qm5idHJNdHhxV05OUncvSUZFU3k1?=
 =?utf-8?B?a1Y0aExGWWN5SzJHcWZHZTExUm4xZk9qWVpPVk4yUzBoRXNlTmljS3lnMVAz?=
 =?utf-8?B?ekh2VTkyK1BDM1FKK1JNTWlGa2RvbVR1Yk11MW54Z1BieXZsajIvcUduTXVu?=
 =?utf-8?B?RWlIenkvSzcyU0QrR256UTJrMFFGR09jY29tL2hlNndOVVYwSzVLMllIYmpO?=
 =?utf-8?B?T3ZDVDEwV1RENVZFODJOQXlRNlBhZUcvT3VGMFVoUGZoMG1wbzNIMEQ2dE9n?=
 =?utf-8?B?VjZGT3UvV21KcmpNYXFwODQ4RXJHNHBmRkJ5amp5UVlhbUJBZTJhczFueXBk?=
 =?utf-8?B?L3ZRT1VXcjdHeGVJTi9sQ1N0VGxCQ2l3d2s2RktUUTUycURReUJXQzI4V0dy?=
 =?utf-8?B?T3ZvYnoyaG14WnJRcElXblJQenFGQm8yUG9JOEU4bDNWQlFyM2s4KzJINTZQ?=
 =?utf-8?B?YWpPN0czUmwramplcWhabnJIaXYyT1c5anMvYllFTllzcVFXdjZocVpJNDF6?=
 =?utf-8?B?YU5uS0JsOXdxRDJhMjRZcEUyaEZYMkxvSWVzUVhma0tOV2VjcFdLNjNobHhC?=
 =?utf-8?B?ZUdXRjFWRWVRcklQV0k2MEsxby80cjBnUHpHNExKQU85Z0F0YnlKSW8ydmxM?=
 =?utf-8?B?ajYyQ09wZWtIVU02MGNRWmhRQjd5aVdnd2tlOGlZbitHSzZBQUNPWDhUY3RL?=
 =?utf-8?B?a29TQzlXRW01dk1zc3VSb2dtaFVUM0xiM0Uvd3RHSmhtSWtGUlZ5c0FpUm13?=
 =?utf-8?B?VjR3ZERXQWgvNnN0MkFtYnNDcXdzcC92anplUG5yeUNQelg2N3ZJRnBkQU5S?=
 =?utf-8?B?OExQL1RDM0FjOWVMWGV6TW9zV3B2dFkrd3ZuMDhlYWtrUTQ3TUZCZ2ZDK0ZP?=
 =?utf-8?B?SFZzZ1JkQkRiVHg5VFMvOE1kTC9HM1RxZ1d0aFBLNEdLdXlWZlphb3hJWFZT?=
 =?utf-8?B?NE9LUC9FNGptL05ZeW5lZnpoZ1I2STdGalJneGpJeDMrTFJSM2RaVE1oTmg1?=
 =?utf-8?B?V0s0QnpLYTRjMXYyL1hFS0J1dGUrbEV1dWZWUlRiRUZ0ZnZBTlZWUU5IWEph?=
 =?utf-8?B?TFhJSUZUWEYyNEsxODg2UElIQ1psMUNzZlpWdng0ZGdja0E2UjRzeDhLUnE5?=
 =?utf-8?B?VlV0emMzTnBEMEUrNzNHdDBGcXcyNWsxcWFqMVJCWGdBZEJMeXFnbGN4QVVa?=
 =?utf-8?B?YUh4WUxjdEhKWUJENFY0elFMaEM4eG5peEJUbEFiWXhRRzJRbjIwRUlYWStj?=
 =?utf-8?B?VHFHZG5XY3g2d1dzODVOb1ZrV1NYK2FoSzlObHdvYmtwbnIwbWQ3UVQ1bTcv?=
 =?utf-8?Q?cA1N4YwJHRi9NRBzsX7auIEX2arRBY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXp1UzNPVkNOaWZRSE9nQVZIV0lEcmhLZGFiOUx2RXhKWThpY0J0UnAyaVRN?=
 =?utf-8?B?WWRuYVZ2RHNoYVhpdks5Q1ZNMjI4YTdrdGtkMkdIWVdaK3E0eHZXcjVnMTAw?=
 =?utf-8?B?em9UTFdudGlFV1ovSW8rMzVBbEtzczBuZDBOK2ZicnBDYlhWTk5RNkp5QXNC?=
 =?utf-8?B?ZzVMQlAxekNkaG9aMGlHMjJieFhSelAxMGVtSjVpS0dYRy9vZGtWbXMzS3BC?=
 =?utf-8?B?d3g3N0l5ZDBVcWVESUQwUUxxRGlJUXp1MnV0Z2czYUFzTi9GYkx4Wkg4L3V2?=
 =?utf-8?B?aGNDdFJ1TTNsKzExejMvN2JhelBKelJaYk11RWhEKzB3YmdhbUhGd2I4bnI3?=
 =?utf-8?B?akNNZ0htZmw4bGx3V1FhOERGcDVSQ25aWVZqcVMxYUV2RDhuN0FRU013QjdL?=
 =?utf-8?B?MXZoTVlXWGpEeG1QR1paR1ZLNmliYWFUZHNFZE9maE1iSVVoQzRySGNxS01J?=
 =?utf-8?B?VzZ0TFRTRzlveE9TVE9rTUp6NzlZM0FJS1liMGQzaFZEcmRPSGhYeGhKcVBS?=
 =?utf-8?B?aHhXR1BmVTdpdE5sT3R0cDlvdWhYdjhsbXZNTE9UZ3Z6ZjNPZ0dTRXhQc3FL?=
 =?utf-8?B?Sk4vY0xZU2ovdTZyOEZWY2M5dTRpK0NibnFZa1ZmeHNYQm1FRlRwV2x2T0Vo?=
 =?utf-8?B?YzhydmNTcnJQVmppYkVwWk1wdnBEWkIxN1puUVIyd1IvLzFTRVd1aURPUFB3?=
 =?utf-8?B?WU5uSjc5TUcrazdwdW1kamMvWnY3S3BsRG0rVmlXY25NZWRkSy9RQ1U3Mmgw?=
 =?utf-8?B?M1paMEp4K3JQT0twOFBFMGJHc2hmZmNqOTZkc3lvQkdFb1JnT3ROT0IyQXN3?=
 =?utf-8?B?S0pqbVB0eVZ5SEo5b2RZZU5JWFVkd216M2lOUVpMTEFrdjZIa2NRSDJmOG5K?=
 =?utf-8?B?MndLRWIxT3ZsYXpMYjRTQ2U4TVpsYXRsNU4zaHk1cUt2MlR6N0RZTEVTczFS?=
 =?utf-8?B?VmxUbXE5K0pROGtHYmE0SHIzam9lcnRyc3c2YnNONWFYRm1JY013N2dTTEh3?=
 =?utf-8?B?VWdRWTVlQUZ0Qis0UXorcVpMcWFKVnZQQ0NodGNhYnFsZ1dPWU9vdDFrbTZD?=
 =?utf-8?B?NWpuNXNhSlNWWnRjZHdha0QxdXhsVC9HSUpCZk5zRHVHaGlQdS9RT2M0QnhI?=
 =?utf-8?B?TnQyN3ZwQ3ZWa0FTZDRGb09DeGVHc1IyYTM4TlVjcFBHNk1EdU1VNnVZODVm?=
 =?utf-8?B?djNXTDI4dWRWRi9LSlV2MW9oMit2VERMc1d6NEpOaFg1eWh1UGx0QnlLZWxP?=
 =?utf-8?B?dWk2bTA5Zk54WlRucWpNalhIVHRSMWVSVnNjK3pPdm41NE0ybzJEWGdTZHR2?=
 =?utf-8?B?eG9iVkdkQ1VEWXgrN2kwVGgraXhlb0tGbTZpSDZJaWFQVXR1SmVURC9iZkVr?=
 =?utf-8?B?U0h3SHo1bnlmZkFuV2FXRXlPeGE1bmhJR0pjRDVqSmRMaC96UGhyTEZBQVU5?=
 =?utf-8?B?NjV2bHBxYVM3Zmh2VHRDYWk3WWtsZlhNVmFMNHlQaWtKRmFHcmZ3QlQyVS9k?=
 =?utf-8?B?bytUdVdURURqc1o3bXVZUmVNSVVMa2wrUE8vUXJOaitoRTA5S3EwNXA5WVRM?=
 =?utf-8?B?ZmlRVEtyakRKa2tMOUJ3blBVRW8zZFI5YkNNV2xma1VHdGVZNTM1ZE1qZGxE?=
 =?utf-8?B?c0FMWTNFZFZ6dytXNTlCNnU5NHJQdUt6TG4rLzNvNXpXeHZwTlNZNy82dkdp?=
 =?utf-8?B?U20zZzVzYkE2OVlaUC8zNWFDTEN6WmF6VkFsZXphVkhtc1didHJvZmVnSk5E?=
 =?utf-8?B?YkR3VEZZY3hnNktiRVpDYWFsajR4R2x2cjFUSTNMZG9sUVFnQUNyRFVRL2d4?=
 =?utf-8?B?Vy8vblBzY0IvUkpiWDRWTUdQaVhkc0NxMU9yUmZaTU0zRXhIN1ozL01VOEwy?=
 =?utf-8?B?bE9ZNUpkUGVYNXU1NUhQNzcwVEVpWUVIYndRd2NJM0toaXN6K0QxYW1OYnJ4?=
 =?utf-8?B?anNXa0s3YncyNEs4YUZhSkJ6bXZOdDZVdTExdnJiblZDVjlRcVlQbWFMQVBM?=
 =?utf-8?B?RmJ4eFFUcGpSQkZKWUpSejEweGdRUlN0Q1dYVWVnSHJBQVBLOFBZYzBnTEtH?=
 =?utf-8?B?SzhkVTRXQ3JWNiswVU50dWpCbWZsUGtnSmw4WWdPdWsyUDV0WXR0U1huTm1Y?=
 =?utf-8?Q?fySGMEv6pGVqan+OTm4OLX1Ek?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71C543108B96FA409D3D574F27A999FF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cac181e5-5be7-448e-0234-08dddb8ecba4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2025 00:00:50.4618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8bcbYi2rnuBwKZICpr0xiAPTUJqQjsznDeS6PP2fBhcYjB80EPHTrrz7luMDzsDeydokP5gvbMahjfGq1K4wqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8940
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTE0IGF0IDE2OjIyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEF1ZyAxNCwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyNS0wOC0xNCBhdCAxMTowMCAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+ID4gPiA+ICsJICovDQo+ID4gPiA+ID4gPiArCXRkeF9jcHVfZmx1c2hfY2FjaGUoKTsN
Cj4gPiA+ID4gPiANCj4gPiA+ID4gPiBJSVVDLCB0aGlzIGNhbiBiZToNCj4gPiA+ID4gPiANCj4g
PiA+ID4gPiAJaWYgKElTX0VOQUJMRUQoQ09ORklHX0tFWEVDKSkNCj4gPiA+ID4gPiAJCXRkeF9j
cHVfZmx1c2hfY2FjaGUoKTsNCj4gPiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+IE5vIHN0cm9u
ZyBvYmplY3Rpb24sIGp1c3QgMiBjZW50cy4gSSBiZXQgIUNPTkZJR19LRVhFQyAmJiBDT05GSUdf
SU5URUxfVERYX0hPU1QNCj4gPiA+ID4ga2VybmVscyB3aWxsIGJlIHRoZSBtaW5vcml0eS4gU2Vl
bXMgbGlrZSBhbiBvcHBvcnR1bml0eSB0byBzaW1wbGlmeSB0aGUgY29kZS4NCj4gPiA+IA0KPiA+
ID4gUmVkdWNpbmcgdGhlIG51bWJlciBvZiBsaW5lcyBvZiBjb2RlIGlzIG5vdCBhbHdheXMgYSBz
aW1wbGlmaWNhdGlvbi4gIElNTywgbm90DQo+ID4gPiBjaGVja2luZyBDT05GSUdfS0VYRUMgYWRk
cyAiY29tcGxleGl0eSIgYmVjYXVzZSBhbnlvbmUgdGhhdCByZWFkcyB0aGUgY29tbWVudA0KPiA+
ID4gKGFuZC9vciB0aGUgbWFzc2l2ZSBjaGFuZ2Vsb2cpIHdpbGwgYmUgbGVmdCB3b25kZXJpbmcg
d2h5IHRoZXJlJ3MgYSBidW5jaCBvZg0KPiA+ID4gZG9jdW1lbnRhdGlvbiB0aGF0IHRhbGtzIGFi
b3V0IGtleGVjLCBidXQgbm8gaGludCBvZiBrZXhlYyBjb25zaWRlcmF0aW9ucyBpbiB0aGUNCj4g
PiA+IGNvZGUuDQo+ID4gDQo+ID4gSSB0aGluayB3ZSBjYW4gdXNlICdrZXhlY19pbl9wcm9ncmVz
cycsIHdoaWNoIGlzIGV2ZW4gYmV0dGVyIHRoYW4NCj4gPiBJU19FTkFCTEVEKENPTkZJR19LRVhF
QykgSU1ITy4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgdGhhdCB3aWxsIGFjY29tcGxpc2ggd2hhdCB5
b3Ugd2FudC4gIEUuZy4ga3ZtLWludGVsLmtvIGlzIHVubG9hZGVkDQo+IGFmdGVyIGRvaW5nIFRE
WCB0aGluZ3MsIHdoaWxlIGtleGVjX2luX3Byb2dyZXNzPWZhbHNlLCBhbmQgdGhlbiBzb21lIHRp
bWUgbGF0ZXINCj4gYSBrZXhlYyBpcyB0cmlnZ2VyZWQuICBJbiB0aGF0IGNhc2UsIHN0b3BfdGhp
c19jcHUoKSB3aWxsIHN0aWxsIGdldCBzdHVjayBkb2luZw0KPiBXQklOVkQuDQoNClJpZ2h0LiAg
VGhhbmtzLiAgTGV0IG1lIHRoaW5rIG1vcmUgb24gdGhpcy4NCg0KT25lIG1pbm9yIHRoaW5nIGlz
IEkgdGhpbmsgd2Ugc2hvdWxkIHVzZSBJU19FTkFCTEVEKENPTkZJR19LRVhFQ19DT1JFKQ0KaW5z
dGVhZC4gIEJlc2lkZXMgdGhlIENPTkZJR19LRVhFQywgdGhlcmUgaXMgYW5vdGhlciBDT05GSUdf
S0VYRUNfRklMRSwNCmFuZCBib3RoIG9mIHRoZW0gc2VsZWN0IENPTkZJR19LRVhFQ19DT1JFLg0K

