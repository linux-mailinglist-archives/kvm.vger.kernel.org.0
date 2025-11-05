Return-Path: <kvm+bounces-62129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FA96C380DA
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 22:36:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7681C4FBF4D
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 21:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85EA62D9EDB;
	Wed,  5 Nov 2025 21:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YTRbGTRF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CF222257E;
	Wed,  5 Nov 2025 21:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762378409; cv=fail; b=hT1VXNKhggdGhOIgXW8Y+NbsD5GIHLAV70h44iIdR2RHwvzA1RjdhieUlXY4iunAApr/63Q2iuWn5Xp/xbu8InAVOWJu+Y/l0slCqvIqGbpbITdbqa+paRbTf8Ym+oq2xNp1y4oFZTnX0nzCWumtc7ZMTRYPnWf5DDLQ8uNTRRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762378409; c=relaxed/simple;
	bh=P6IQPWo31FSuxhByiY2+MQ1OQUIXoOznWlUYPyIcSKo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gnp4922P/t7bGFQuRTYM6pgVWl0f2h89orD/wo+AQjv167LdrPVmC9rH02QJ0fyyeIMHko/w+jgJQb3PV67MeV1S5thBalz5v0vgN/xEEj2+baaNWdiBdLxJ2Wo1X8fTTl/Jhb2WND44Ca8NnssziCmp+QwGGXNi0XHAOY4OZvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YTRbGTRF; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762378408; x=1793914408;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=P6IQPWo31FSuxhByiY2+MQ1OQUIXoOznWlUYPyIcSKo=;
  b=YTRbGTRFBnOTATsBeqcxRwGmVX2+dQ7PLBe4Ach2daHgDUGAvGcFh2kk
   1u1wdZ+D+vTBNY/MfTMecXkmleiM+TkbjwTJdWkGzpmzjJa1ipw0E0k4k
   YkuHn/0+cZ7AZmuSOWYA8GKUFR7p+SEde7so1L/U/mfesvTeGgTBsKzf7
   STUtuHpBFC7NjfxmiKYK9bWanX2vmDIKMvIde1jm1XpyJq2fFFaw6NVul
   Ve5EPZ4IualYrEVxl3ci1l6qNVKnIkoXBhWhmh82uRV70eq96t718fh+z
   CYxpyR8LGdi5T9v1RF1eY2fWtFCjpAAZ1E1VaD7fyQTzFXdp3q2ZD3zjD
   g==;
X-CSE-ConnectionGUID: I35Ls2mJR120tC2+io2Q0w==
X-CSE-MsgGUID: xzRoZw0zSxajlQuu3BjJRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="75858181"
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="75858181"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 13:33:27 -0800
X-CSE-ConnectionGUID: VmW6pEmaRXu4tMKsV/WSdA==
X-CSE-MsgGUID: j4xbfp3iTlCpk+zAPJDAkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="218224000"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 13:33:27 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 13:33:26 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 13:33:26 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.59) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 13:33:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SdKaYhrFMEKMzERi7fmYnmQ23z5MX93teLBEG/hJUI/2NQeCy5pZUBoITiLu9BT/MVcILCe3Eo/QbW4kqppijZatE6TuIrbJL+/e3RX4YBx/DmuuT6HLPdPS0GlNhA4bRxDZM84/2B2vFS2TsVx1IFAGwHxpUxJxqPE+BwSb1KtqGJojgfaxFxUVnuDqzCc7gtn3GrBe4HXzHuyJxVst3mwMUTumePvxHqj5yEhTL93s4KlKSwhILzQlLTn7p/otcKESbq5igvcL0TTsCjboy+TPvpln7X5x6YqBwP1PdOJDE3KgVzfJbQDPQwNJCLmhDREhP0tYxUy+7sEIzvNrrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P6IQPWo31FSuxhByiY2+MQ1OQUIXoOznWlUYPyIcSKo=;
 b=iTE0TPXg9NEGf2U0WRrkwFaZI0cbGAGT98bnNpUJEn22oXTz5yJhb9JwWWxglRBZyy7haTVbjxrNxMCuoHMWtsKemf7lLU83o+BPk/MttxtO1wjQEySPKduiMudCVSprj0bzziT0rq1Gggnl6KUV7E9gR1EWsgyZDbQVEBSUzdqYNhzjC6HN+FODKoRZquLEVEsz4bE7jdaqqk18HBHuodHxrIcW1cARv90+hIpEgZ64dS0q59oL9qtamnmB/CY3tQuERha8/I7epdyYufnzPpe2Sk6ZEXDCoDzn431PGnXtMAwVi6RSTrEP6Yzy9OGVYmxivxXfaH7yW+AbJQ2f6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB8502.namprd11.prod.outlook.com (2603:10b6:510:30c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Wed, 5 Nov
 2025 21:33:21 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 21:33:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "mingo@redhat.com" <mingo@redhat.com>, "khushit.shah@nutanix.com"
	<khushit.shah@nutanix.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>, "Kohler, Jon"
	<jon@nutanix.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
Subject: Re: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
Thread-Topic: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
Thread-Index: AQHcKLR2qfH/HOUBJUuLEhaZhzaNXbSfxJ6AgABfW4CAEG1ZAIAhZPWAgAqBMwCAAE6GgIAFyuaAgAIBkQCAAFO6AA==
Date: Wed, 5 Nov 2025 21:33:21 +0000
Message-ID: <d78f865ccb5acbf4363d02592762c8830c707298.camel@intel.com>
References: <20250918162529.640943-1-jon@nutanix.com>
	 <aNHE0U3qxEOniXqO@google.com>
	 <7F944F65-4473-440A-9A2C-235C88672E36@nutanix.com>
	 <B116CE75-43FD-41C4-BB3A-9B0A52FFD06B@nutanix.com>
	 <aPvf5Y7qjewSVCom@google.com>
	 <EFA9296F-14F7-4D78-9B7C-1D258FF0A97A@nutanix.com>
	 <aQTxoX4lB_XtZM-w@google.com>
	 <cc6de4bfd9fbe0c7ac48b138681670d113d2475e.camel@intel.com>
	 <aQt8Yoxea-goWrnR@google.com>
In-Reply-To: <aQt8Yoxea-goWrnR@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB8502:EE_
x-ms-office365-filtering-correlation-id: 12f80895-97b9-436e-964a-08de1cb2f1aa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?a3B4TmFoWFR1aTZTOWFXZXgwbHNBMXR0NUlhRi85aHVuZ3cyOS9JbGx5amlR?=
 =?utf-8?B?U1B4SSt3TVJOWURjdkQ1OW1MN3FiQTJMc0U5QzNBS3ZyWk0wVVJlaDBRL2hh?=
 =?utf-8?B?MElLRm00T2plUmx0aTlWZzExaGZKNzlsbThHTFoxcm5kajFpQ1BveG00eEZs?=
 =?utf-8?B?bWp5LzRDLzM1V3JUM1NnVUI3TzlIZ3k3Mnl4WEsvOGdneWEvOUc4dERBM1dX?=
 =?utf-8?B?R3JheHlHbW5ULzBoTzdhWlFXQWR4dmhsT05XbzNuaWE5SmlXajUzbGFoL0dl?=
 =?utf-8?B?dEZxc09Ya3NFVmhieFVpT3FoMmtXd2dubTBuWS9oL0xDZDN3bHU4ZjFOSkc2?=
 =?utf-8?B?bE9CMkJIcjB4WG9JZjBvekg1aXZxcFNPek4xYzFNUStzQUMxQkVEaE1zOWV2?=
 =?utf-8?B?bHBDL01DVUlRRktqV05zdlpRTEZNOUZQRTBzRVhaVGpGSlZuaGlUcG5IeVpE?=
 =?utf-8?B?blpabnFhYVFXdjA4cG4vaFR2c0ZudlNQSE1UUkl2TTRVb2l1TDFhWjJ5WkVa?=
 =?utf-8?B?MFZnS3grdEdJTFFrNWJuM0llNmxnVVhGT01JS0JqM1JsZ0hhWlNRVzBuNWo5?=
 =?utf-8?B?YWoxU2lrd2dBaDJFbmJnclhrTFoxUjFQbUlJNW5WeVJOaWV0VlgxcXZ2dXFo?=
 =?utf-8?B?MXpETERJZXRPOFJXNHEyS3JwZG0veHArRWRIUkZsSUxBRUlSSy92MnNVTEV0?=
 =?utf-8?B?UDdBYnNiUlZBNGdDQkxwZEJ5N3hqazdXeEE1U1ZjMWtpRkRPTHU0OHNpTW1R?=
 =?utf-8?B?Q1BPQVpWUHlNUytNc0kvMkJKSGlPMWE2Q1lOL0dzazJSZklZZjVUT00vV3hj?=
 =?utf-8?B?V3p5L0NvMkFnMXB4Z0VGbTBYRnAyUW1kMTVlSmhPZVg4TXdlZE54UFZDY05w?=
 =?utf-8?B?VnN3eHg3MWEzUGhtWnZBY1g1eGkxelhlQ25MWXR3eXV6ZjNuY3ZaclVRa1Rw?=
 =?utf-8?B?WFlnWjc0ZnBpam1qTlJiTDhvZmZ5a0R0b20zc0RpN2JFTTBqV3RBcGtVZk9F?=
 =?utf-8?B?QXY3eitJY2JUT2xFSEVJckE3OXh5OG1XSDZIVTQ1d0VrQWMvaERHYVhPdVlD?=
 =?utf-8?B?WWNuWnAzQkpHS1J4TEE5cjRUcXhiUFZ1S3FCcmxFTERJOFZSaFAwaWJJSXV2?=
 =?utf-8?B?dENLQ1BodmRTdnNHNTRFc3VVUnQ5Q3JLVmhkbGNaTDZpV0tkUlRhdlA3MWhy?=
 =?utf-8?B?UVpiQktXZG1zSnJpNEJ3OHFsYWJHMFU1KzhmVHNMekt2cjJaamtBeTlBb01N?=
 =?utf-8?B?blBUNkdqWitlUWxpbHJFYjZuVGlacWNEUFJ4UkM2VHpOaU5jc0puSjNwanpo?=
 =?utf-8?B?d1VPRWlDRk9kZ0RXUnVnTWJ4aDllV0ZnZy9JS0JBTXIvUVhGUVhDcW0yV0dY?=
 =?utf-8?B?Nlg1UDZVeEVnUGFCNVdnNHZLUTcycDJXZTFFRk84elVNUmwvdVFKa2RMdHJI?=
 =?utf-8?B?QW5ZK3ZjVDd5dFhRVWx3d21JK3VKYnhwTDFRQVNWU2pVWkRGdHVRMm0wSG9x?=
 =?utf-8?B?UEhGVVJpd0t1eC9SVG9ZbG5Mc0dPZ1MvQkE5U242REpWcnZZNDlUU0QrVk40?=
 =?utf-8?B?L0JiUmw3cklsaWtwWTdSZEl1SVk2NVY5b0MweTl1WFdSY1VLemtncHJBZzB3?=
 =?utf-8?B?enZITDRUT01MR29WNWlnREE5aENvNmw5UHF4b0t6QzlRdld2Z1FGOGVqTndE?=
 =?utf-8?B?NFdDU1hMa0E1ZG9pMUJxempFTlJtZXpzVlhzOFVhaXVuUFRndXRWZkpxQ04r?=
 =?utf-8?B?NmNuSTI3bEh6QXBDWktINnNKcEJnb2p5ZmV6T3VLaGhZcE81b2hWM0dyL256?=
 =?utf-8?B?d0VTdlA4c3kvc1VodFBJbUxDRDFtYXhtOXcwd0NrNEROL29nYUh0RU40eXZn?=
 =?utf-8?B?NlY3SWx5SHlITVZpdlF2U1lpN2Zqc3UzS2JrakNyZHJ1MmVGbjJwcGVBdHZh?=
 =?utf-8?B?YUVOVTlISmNQK3BUQTBXaFcwTDgyTG1vMUl2NnZmUnluT2VMYkdPcVh4bTFL?=
 =?utf-8?B?bnZxNlk4RUhHcUlDMU1ueStyUW1UMFpoM1pjZ1lzVVFRZjRRbk9OUE9mU2VV?=
 =?utf-8?Q?1Ids2w?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZU84a3Z6Q3lmc214eFVGK0NaNGtoTWVyV093T1RpWFBidHRBZFpPc1R5cTlL?=
 =?utf-8?B?bi8wLzhUNFowK2xycy9TV0pkbkNxU3ZFQUhlN2dvTC9aNDFwWHFZZWszRGtL?=
 =?utf-8?B?dmRoVTRLbUlJVTY3aTl0TWMrcEhsYjBNZjFnVmJKTUVTQ2NCOXZYeEdhSHU2?=
 =?utf-8?B?WkU4S0VmSFdpWU12UXRHMk1zUXY3WWwxZ1NRdytEMmVZZkhTRXJJTHA1NEVk?=
 =?utf-8?B?Z2k1Q3RONUgrL29pUDBXMWVmS2VxOWFTMWpwdDIrRDB3SHQ3MTVVY1YwejB0?=
 =?utf-8?B?SERFaTk0UWNKeEV4SDR3NWNBVDNzWmhZOVRSOExUU3NNWllJUEU1akU0UC9w?=
 =?utf-8?B?a1VPSUVQY3BoTW5vaS9FTTN5S3ZxM0FxZUVQb3FxUVNlT2dXU2lzbXJMRGNv?=
 =?utf-8?B?b3ZMOHJwcStyOXVHYzk5UTNXRk12a1VJelJCOExpRnpHVXdkRDNTYnFPT0Ry?=
 =?utf-8?B?Ti9ZZ0JPVmdpeTRIbHpLY1U0a3VHQk02VmNKQTFZR1JEOXBHK01RN1d0ajR1?=
 =?utf-8?B?dDd4Z3hrUHRyZHl6cCtyWEtlZG5HUi9QVFNtNlJUS1lWSlZQTzh0aENPdnpZ?=
 =?utf-8?B?SWkxUmxvamZUR2FvdUlCOFFBRkVUUTNtU1dlT1c1Vkd4UnU3TTFkNkVTYllX?=
 =?utf-8?B?ZmVuZFpnWCtyTFB6WEZCaVJ4THVudmRLVitjM1poL2FEL1gva3l4cCtJeWE2?=
 =?utf-8?B?VVBlaGYwZTZlT0FPK0FxYktXZmtUL1Y4MVBVaVFHQ2RrcUV6U1c4WnBYbG42?=
 =?utf-8?B?VEl2aUxwWk9uN21zUGV0VVJjZS9zNEsrRlpodkpFQWJ0SDBkd3pSK3VJcHZK?=
 =?utf-8?B?dzY4LzBxWm9ReTBybklpZVpDb3hmTk53OWkyazMySkdMNEtCNU1qY1cyeW9F?=
 =?utf-8?B?azBUSDN2aEJBamNUdnZhNEV1aWNsOHVnNjZaSkxULzFwdTZ2a2Z3by82K05R?=
 =?utf-8?B?NUhleFBMR1MybzFWQm4vdDJiTzlmNXB6RnhZQ0V3NUJiV3ozN0xjMy9oeUs2?=
 =?utf-8?B?TXBlQzhuMzA0QnB3YXRTK3hKOVA4SDZvaUZTWnUxV0hFY2lUYWxobldnRkMy?=
 =?utf-8?B?emZNOVF2eGU3aVFUZUw1MVM3ZDgzclp5Z3hjK0ZpeGJvOUZ6T1VCVFlqWk5I?=
 =?utf-8?B?Yys0MnREOHhoWWxnYjBFN0FwMkxBM04vYTdic1hxRWY1WmpkQ1N1WDRBOUlX?=
 =?utf-8?B?c2pvOUxMbTc5TE1MeENaS2tTRWV3emVZTzZ3aU54Nyt6bW1HNkFrQ1d1dVdp?=
 =?utf-8?B?QzJtcmFvaVp4Nnd1TlBqb1h4RTYvdWVlK2RHSENIcU1rKzNEcW8zcGFHbzRw?=
 =?utf-8?B?MkREek9JTVlzWGZpYWxkSTFyTnFiTkUyaElTZ3BUTmt1MUVnZEJFUnkwNWVN?=
 =?utf-8?B?bjBZWWkxSFhSeTRJMTFQRlAwcC9CSFJKallEQ0RNcHZJMTlYMGVUdUlwU2dS?=
 =?utf-8?B?M3JaTW1XcHlJYWF4YTFPQXVvOWxVU1FVS0pPT0V6eWdaeUNZNnowTmhxbnZ2?=
 =?utf-8?B?NGlKaGdvbkZRY3hxc002TmY2NmgycDFUTUxpbWU3TVdEaUJzM29Vazl0cXdG?=
 =?utf-8?B?YW5QaCs2VmVGUDBrTXJQdTJVWVBxTXlCeVcwa2VrL0VkbU9veG9VTm1SNWJO?=
 =?utf-8?B?S0pHRXNjNi9TRmtSeFk2bEc1MXZwcFA3dUdiS0ZqMUxHQUNObUhuWUMxdVp1?=
 =?utf-8?B?a2kwZXMzMmQreVJxSk9wYVVRQlpIVCtuUG13Q2VxMEhpZHp1VlNBOUN6WVNO?=
 =?utf-8?B?Z0hwL3UwNjR4N2p2T2IzSWFwVEhYM0kvTVVETkZSYkVYUEJwdlpjcHVoUm83?=
 =?utf-8?B?NGw3YmZic2tyeGo0SlRVa3I2VVRxQWZKdUx3ZmRBTTQ1QWlnM3RUY3R5cVN4?=
 =?utf-8?B?WWFwY3lYWTBnYmpCTHovaWQyRFk4WmtpRzFyN3FhN1F2VGVkNDJjbTJoU3g4?=
 =?utf-8?B?bDVpazl1eGdRQjlZLzBtYlUxL1Y4VEJUeUluNThsSHFCSFF5Z0Q2UjVESkhn?=
 =?utf-8?B?Wmt3MmN5bXVzNjQ3NW1taGtGcURRbE9UbGE1K21XSHFSdThoZ24rRGxyS3Z0?=
 =?utf-8?B?bDVoMEpLakpsc3dub3pZK0NzajU5RGFOYmNNcFJCTnBhOEFNNUN1YzF3TkhM?=
 =?utf-8?Q?Z1OgAF9xBLj6aFllpUmtLucgH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F24FFDAD5CDF6478FF00C6F3591B1F1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f80895-97b9-436e-964a-08de1cb2f1aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2025 21:33:21.7149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xs7btmH4OlkMGdwgQEYOnuCP5FgzsSct0g7nc0JprdK8QQf+bFt3rdET9sPxhEn/zr0GVYkcK6tmoOThDn/nbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8502
X-OriginatorOrg: intel.com

PiA+IA0KPiA+ID4gQEAgLTE1MTcsNiArMTUxOCwxOCBAQCBzdGF0aWMgdm9pZCBrdm1faW9hcGlj
X3NlbmRfZW9pKHN0cnVjdCBrdm1fbGFwaWMgKmFwaWMsIGludCB2ZWN0b3IpDQo+ID4gPiAgDQo+
ID4gPiAgCS8qIFJlcXVlc3QgYSBLVk0gZXhpdCB0byBpbmZvcm0gdGhlIHVzZXJzcGFjZSBJT0FQ
SUMuICovDQo+ID4gPiAgCWlmIChpcnFjaGlwX3NwbGl0KGFwaWMtPnZjcHUtPmt2bSkpIHsNCj4g
PiA+ICsJCS8qDQo+ID4gPiArCQkgKiBEb24ndCBleGl0IHRvIHVzZXJzcGFjZSBpZiB0aGUgZ3Vl
c3QgaGFzIGVuYWJsZWQgRGlyZWN0ZWQNCj4gPiA+ICsJCSAqIEVPSSwgYS5rLmEuIFN1cHByZXNz
IEVPSSBCcm9hZGNhc3RzLCBpbiB3aGljaCBjYXNlIHRoZSBsb2NhbA0KPiA+ID4gKwkJICogQVBJ
QyBkb2Vzbid0IGJyb2FkY2FzdCBFT0lzICh0aGUgZ3Vlc3QgbXVzdCBFT0kgdGhlIHRhcmdldA0K
PiA+ID4gKwkJICogSS9PIEFQSUMocykgZGlyZWN0bHkpLiAgSWdub3JlIHRoZSBzdXBwcmVzc2lv
biBpZiB1c2Vyc3BhY2UNCj4gPiA+ICsJCSAqIGhhcyBOT1QgZGlzYWJsZWQgS1ZNJ3MgcXVpcmsg
KEtWTSBhZHZlcnRpc2VkIHN1cHBvcnQgZm9yDQo+ID4gPiArCQkgKiBTdXBwcmVzcyBFT0kgQnJv
YWRjYXN0cyB3aXRob3V0IGFjdHVhbGx5IHN1cHByZXNzaW5nIEVPSXMpLg0KPiA+ID4gKwkJICov
DQo+ID4gPiArCQlpZiAoKGt2bV9sYXBpY19nZXRfcmVnKGFwaWMsIEFQSUNfU1BJVikgJiBBUElD
X1NQSVZfRElSRUNURURfRU9JKSAmJg0KPiA+ID4gKwkJICAgIGFwaWMtPnZjcHUtPmt2bS0+YXJj
aC5kaXNhYmxlX3N1cHByZXNzX2VvaV9icm9hZGNhc3RfcXVpcmspDQo+ID4gPiArCQkJcmV0dXJu
Ow0KPiA+ID4gKw0KPiA+IA0KPiA+IEkgZm91bmQgdGhlIG5hbWUgJ2Rpc2FibGVfc3VwcHJlc3Nf
ZW9pX2Jyb2FkY2FzdF9xdWljaycgaXMga2luZGEgY29uZnVzaW5nLA0KPiA+IHNpbmNlIGl0IGNh
biBiZSBpbnRlcnByZXRlZCBpbiB0d28gd2F5czoNCj4gPiANCj4gPiAgLSB0aGUgcXVpcmsgaXMg
J3N1cHByZXNzX2VvaV9icm9hZGNhc3QnLCBhbmQgdGhpcyBib29sZWFuIGlzIHRvIGRpc2FibGUN
Cj4gPiAgICB0aGlzIHF1aXJrLg0KPiA+ICAtIHRoZSBxdWlyayBpcyAnZGlzYWJsZV9zdXBwcmVz
c19lb2lfYnJvYWRjYXN0Jy4NCj4gDQo+IEkgaGVhciB5b3UsIGJ1dCBhbGwgb2YgS1ZNJ3MgcXVp
cmtzIGFyZSBwaHJhc2VkIGV4YWN0bHkgbGlrZSB0aGlzOg0KPiANCj4gICBLVk1fQ0FQX0RJU0FC
TEVfUVVJUktTDQo+ICAgS1ZNX0NBUF9ESVNBQkxFX1FVSVJLUzINCj4gICBLVk1fWDJBUElDX0FQ
SV9ESVNBQkxFX0JST0FEQ0FTVF9RVUlSSw0KPiAgIGRpc2FibGVfc2xvdF96YXBfcXVpcmsNCg0K
RmFpciBlbm91Z2guIMKgSXQgZm9sbG93cyBLVk1fWDJBUElDX0FQSV9ESVNBQkxFX0JST0FEQ0FT
VF9RVUlSSyB3aGljaA0KZGlzYWJsZXMgYSBxdWlyayBuYW1lZCAiYnJvYWRjYXN0Ii4NCg0KSSB3
YXMgbG9va2luZyBhdCBiZWxvdyB0aG91Z2g6DQoNCiNkZWZpbmUgS1ZNX1g4Nl9RVUlSS19MSU5U
MF9SRUVOQUJMRUQgICAgICAgICAgICgxIDw8IDApICAgICAgICAgICAgICAgICAgIA0KI2RlZmlu
ZSBLVk1fWDg2X1FVSVJLX0NEX05XX0NMRUFSRUQgICAgICAgICAgICAgKDEgPDwgMSkgICAgICAg
ICAgICAgICAgICAgDQojZGVmaW5lIEtWTV9YODZfUVVJUktfTEFQSUNfTU1JT19IT0xFICAgICAg
ICAgICAoMSA8PCAyKSAgICAgICAgICAgICAgICAgICANCiNkZWZpbmUgS1ZNX1g4Nl9RVUlSS19P
VVRfN0VfSU5DX1JJUCAgICAgICAgICAgICgxIDw8IDMpICAgICAgICAgICAgICAgICAgIA0KI2Rl
ZmluZSBLVk1fWDg2X1FVSVJLX01JU0NfRU5BQkxFX05PX01XQUlUICAgICAgKDEgPDwgNCkgICAg
ICAgICAgICAgICAgICAgDQojZGVmaW5lIEtWTV9YODZfUVVJUktfRklYX0hZUEVSQ0FMTF9JTlNO
ICAgICAgICAoMSA8PCA1KSAgICAgICAgICAgICAgICAgICANCiNkZWZpbmUgS1ZNX1g4Nl9RVUlS
S19NV0FJVF9ORVZFUl9VRF9GQVVMVFMgICAgICgxIDw8IDYpICAgICAgICAgICAgICAgICAgIA0K
I2RlZmluZSBLVk1fWDg2X1FVSVJLX1NMT1RfWkFQX0FMTCAgICAgICAgICAgICAgKDEgPDwgNykg
ICAgICAgICAgICAgICAgICAgDQojZGVmaW5lIEtWTV9YODZfUVVJUktfU1RVRkZfRkVBVFVSRV9N
U1JTICAgICAgICAoMSA8PCA4KSAgICAgICAgICAgICAgICAgICANCiNkZWZpbmUgS1ZNX1g4Nl9R
VUlSS19JR05PUkVfR1VFU1RfUEFUICAgICAgICAgICgxIDw8IDkpICAgICAgICAgICAgDQoNCldo
ZXJlIHdlIGNhbiB0ZWxsIHZlcnkgY2xlYXJseSBhYm91dCB0aGUgbmFtZSBvZiB0aGUgcXVpcmsu
DQoNCkFuZCBBRkFJQ1QgdGhlIG5hbWUgdGVsbHMgd2hhdCBLVk0gYWN0dWFsbHkgZG9lcyAoSSBk
aWRuJ3QgY2hlY2sgdGhlbSBhbGwNCnRob3VnaCkgLS0gZS5nLiwgZm9yIHRoZSBTTE9UX1pBUF9B
TEwgcXVpcmssIHdoZW4gYSBWTSBoYXMgdGhpcyBxdWlyaywgS1ZNDQp6YXBzIGFsbCByYXRoZXIg
dGhhbiBvbmx5IG9uZSBzbG90Lg0KDQpJIGd1ZXNzIHRoaXMgd2FzIGhvdyBJIGdvdCBjb25mdXNl
ZCBhYm91dCAiU1VQUFJFU1NfRU9JX0JST0FEQ0FTVCIgcXVpcmsgLS0NCkkgdGhvdWdodCBpdCB3
YXMgIktWTSBzdXBwcmVzc2VzIEVPSSBicm9hZGNhc3Qgd2hpbGUgaXQgc2hvdWxkIG5vdCIsIGJ1
dCBpdA0KYWN0dWFsbHkgbWVhbnMgb3Bwb3NpdGUgLi4uDQoNCj4gDQo+ID4gQW5kIGluIGVpdGhl
ciBjYXNlLCB0aGUgZmluYWwgbWVhbmluZyBpcyBLVk0gbmVlZHMgdG8gImRpc2FibGUgc3VwcHJl
c3MgRU9JDQo+ID4gYnJvYWRjYXN0IiB3aGVuIHRoYXQgYm9vbGVhbiBpcyB0cnVlLCANCj4gDQo+
IE5vLiAgVGhlIGZsYWcgc2F5cyAiRGlzYWJsZSBLVk0ncyAnU3VwcHJlc3MgRU9JLWJyb2FkY2Fz
dCcgUXVpcmsiLCB3aGVyZSB0aGUNCj4gcXVpcmsgaXMgdGhhdCBLVk0gYWx3YXlzIGJyb2FkY2Fz
dHMgZXZlbiB3aGVuIGJyb2FkY2FzdHMgYXJlIHN1cHBvc2VkIHRvIGJlDQo+IHN1cHByZXNzZWQu
DQoNCi4uLiBhcyB5b3Ugc2FpZCBoZXJlLiA6LSkNCg0KPiANCj4gPiB3aGljaCBpbiB0dXJuIG1l
YW5zIEtWTSBhY3R1YWxseSBuZWVkcyB0byAiYnJvYWRjYXN0IEVPSSIgSUlVQy4gIEJ1dCB0aGUN
Cj4gPiBhYm92ZSBjaGVjayBzZWVtcyBkb2VzIHRoZSBvcHBvc2l0ZS4NCj4gPiANCj4gPiBQZXJo
YXBzICJpZ25vcmUgc3VwcHJlc3MgRU9JIGJyb2FkY2FzdCIgaW4geW91ciBwcmV2aW91cyB2ZXJz
aW9uIGlzIGJldHRlcj8NCj4gDQo+IEhtbSwgSSB3YW50ZWQgdG8gc3BlY2lmaWNhbGx5IGNhbGwg
b3V0IHRoYXQgdGhlIGJlaGF2aW9yIGlzIGEgcXVpcmsuICBBdCB0aGUNCj4gcmlzayBvZiBiZWlu
ZyB0b28gdmVyYm9zZSwgbWF5YmUgRElTQUJMRV9JR05PUkVfU1VQUFJFU1NfRU9JX0JST0FEQ0FT
VF9RVUlSSz8NCg0KSSB0aGluayBpdCByZWZsZWN0cyB0aGUgYmVoYXZpb3VyIG9mIHRoZSBxdWly
ayBtb3JlLCB0aHVzIEkga2luZGEgcHJlZmVyDQp0aGlzLg0KDQo+IA0KPiBBbmQgdGhlbiB0byBr
ZWVwIGxpbmUgbGVuZ3RocyBzYW5lLCBncmFiICJrdm0iIGxvY2FsbHkgc28gdGhhdCB3ZSBjYW4g
ZW5kIHVwIHdpdGg6DQo+IA0KPiAJLyogUmVxdWVzdCBhIEtWTSBleGl0IHRvIGluZm9ybSB0aGUg
dXNlcnNwYWNlIElPQVBJQy4gKi8NCj4gCWlmIChpcnFjaGlwX3NwbGl0KGt2bSkpIHsNCj4gCQkv
Kg0KPiAJCSAqIERvbid0IGV4aXQgdG8gdXNlcnNwYWNlIGlmIHRoZSBndWVzdCBoYXMgZW5hYmxl
ZCBEaXJlY3RlZA0KPiAJCSAqIEVPSSwgYS5rLmEuIFN1cHByZXNzIEVPSSBCcm9hZGNhc3RzLCBp
biB3aGljaCBjYXNlIHRoZSBsb2NhbA0KPiAJCSAqIEFQSUMgZG9lc24ndCBicm9hZGNhc3QgRU9J
cyAodGhlIGd1ZXN0IG11c3QgRU9JIHRoZSB0YXJnZXQNCj4gCQkgKiBJL08gQVBJQyhzKSBkaXJl
Y3RseSkuICBJZ25vcmUgdGhlIHN1cHByZXNzaW9uIGlmIHVzZXJzcGFjZQ0KPiAJCSAqIGhhcyBO
T1QgZGlzYWJsZWQgS1ZNJ3MgcXVpcmsgKEtWTSBhZHZlcnRpc2VkIHN1cHBvcnQgZm9yDQo+IAkJ
ICogU3VwcHJlc3MgRU9JIEJyb2FkY2FzdHMgd2l0aG91dCBhY3R1YWxseSBzdXBwcmVzc2luZyBF
T0lzKS4NCj4gCQkgKi8NCj4gCQlpZiAoKGt2bV9sYXBpY19nZXRfcmVnKGFwaWMsIEFQSUNfU1BJ
VikgJiBBUElDX1NQSVZfRElSRUNURURfRU9JKSAmJg0KPiAJCSAgICBrdm0tPmFyY2guZGlzYWJs
ZV9pZ25vcmVfc3VwcHJlc3NfZW9pX2Jyb2FkY2FzdF9xdWlyaykNCj4gCQkJcmV0dXJuOw0KPiAN
Cj4gPiBBbHNvLCBJSVVDIHRoZSBxdWlyayBvbmx5IGFwcGxpZXMgdG8gdXNlcnNwYWNlIElPQVBJ
Qywgc28gaXMgaXQgYmV0dGVyIHRvDQo+ID4gaW5jbHVkZSAic3BsaXQgSVJRQ0hJUCIgdG8gdGhl
IG5hbWU/ICBPdGhlcndpc2UgcGVvcGxlIG1heSB0aGluayBpdCBhbHNvDQo+ID4gYXBwbGllcyB0
byBpbi1rZXJuZWwgSU9BUElDLg0KPiANCj4gRWgsIEknZCBwcmVmZXIgdG8gc29sdmUgdGhhdCB0
aHJvdWdoIGRvY3VtZW50YXRpb24gYW5kIGNvbW1lbnRzLiAgVGhlIG5hbWUgaXMNCj4gYWxyZWFk
eSBicnV0YWxseSBsb25nLg0KDQpJIHN0aWxsIGtpbmRhIHByZWZlciB0aGUgZXhwbGljaXRuZXNz
IGJ1dCBubyBwcm9ibGVtIG9mIHNraXBwaW5nIHRoaXMgcGFydC4NCg0KQnR3LCBoYXRlIHRvIHNh
eSwgYnV0IHRoZSBleGlzdGluZyB4MiBhcGljIG1hY3JvcyBoYXZlIGFuICJfQVBJIiBwb3N0Zml4
DQphZnRlciAiS1ZNX1gyQVBJQyI6DQoNCiNkZWZpbmUgS1ZNX1gyQVBJQ19BUElfVVNFXzMyQklU
X0lEUyAgICAgICAgICAgICgxVUxMIDw8IDApDQojZGVmaW5lIEtWTV9YMkFQSUNfQVBJX0RJU0FC
TEVfQlJPQURDQVNUX1FVSVJLICAoMVVMTCA8PCAxKQ0KDQo+ICANCj4gPiBCdHcsIHBlcnNvbmFs
bHkgSSBhbHNvIGZvdW5kICJkaXJlY3RlZCBFT0kiIGlzIG1vcmUgdW5kZXJzdGFuZGFibGUgdGhh
bg0KPiA+ICJzdXBwcmVzcyBFT0kgYnJvYWRjYXN0Ii4gIEhvdyBhYm91dCB1c2luZyAiZGlyZWN0
ZWQgRU9JIiBpbiB0aGUgY29kZQ0KPiA+IGluc3RlYWQ/ICBFLmcuLA0KPiA+IA0KPiA+ICBzL2Rp
c2FibGVfc3VwcHJlc3NfZW9pX2Jyb2FkY2FzdC9kaXNhYmxlX2RpcmVjdGVkX2VvaQ0KPiA+ICBz
L0tWTV9YMkFQSUNfRElTQUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUL0tWTV9YMkFQSUNfRElT
QUJMRV9ESVJFQ1RFRF9FT0kNCj4gPiAJDQo+ID4gSXQgaXMgc2hvcnRlciwgYW5kIEtWTSBpcyBh
bHJlYWR5IHVzaW5nIEFQSUNfTFZSX0RJUkVDVEVEX0VPSSBhbnl3YXkuDQo+IA0KPiBJdCdzIGFs
c28gd3JvbmcuICBEaXJlY3RlZCBFT0kgaXMgdGhlIEkvTyBBUElDIGZlYXR1cmUsIHRoZSBsb2Nh
bCBBUElDIChDUFUpDQo+IGZlYXR1cmUgaXMgIlN1cHByZXNzIEVPSS1icm9hZGNhc3RzIiBvciAi
RU9JLWJyb2FkY2FzdCBzdXBwcmVzc2lvbiIuICBDb25mbGF0aW5nDQo+IHRob3NlIHR3byBmZWF0
dXJlcyBpcyBsYXJnZWx5IHdoYXQgbGVkIHRvIHRoaXMgbWVzcyBpbiB0aGUgZmlyc3QgcGxhY2Us
IHNvIEknZA0KPiBzdHJvbmdseSBwcmVmZXIgbm90IHRvIGJsZWVkIHRoYXQgY29uZnVzaW9uIGlu
dG8gS1ZNJ3MgdUFQSS4NCg0KT0sgZmFpciBlbm91Z2guDQo=

