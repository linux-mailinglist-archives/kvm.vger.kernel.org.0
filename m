Return-Path: <kvm+bounces-56170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3362BB3AA89
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 21:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4470A1C86E86
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 19:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B96E4326D61;
	Thu, 28 Aug 2025 19:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XtwCY0em"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D575E279791;
	Thu, 28 Aug 2025 19:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756407858; cv=fail; b=cDPAoTv+0thRFl08BGoznWfZ1U07Cyp/ZqjNdv2r4HHs7N0ieh7udVBIqInXAMWrJ0GgQXT7N5kT20y7aVPtlBf4anw0HzO0OWE13O7Se+3opUd5LfIqkNRx82GMYhFouVa5yiMpWVhV3fBeHYUYo8/W3CKvxSwuXGvIDUhmfKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756407858; c=relaxed/simple;
	bh=ROzOwqDLP5y79TJIcH9pJQxSiOeryTYHLyO9PoYodCw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T9VfohojVGFxHsYUVlLvDIBA0r3vFlQSg7qY+6157UNXk8pXiecyBYsTCYrLvGjkEXea7mlNVWev7qLF7u6x6N+nlonXPo/nfwARosTqrJAGt9WyV2rHB25l6pQfFWJaJbI3y4buCcTebXdGd2veQ3Nx/dEhq1mUXlBtFG8KKNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XtwCY0em; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756407857; x=1787943857;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ROzOwqDLP5y79TJIcH9pJQxSiOeryTYHLyO9PoYodCw=;
  b=XtwCY0emte9w8g/VcLrvYCBKQ4pf0wixC6O93F2ATMTHmKwGQB6ikc4M
   XKUJtKEeyTdJUC4H4b12Qnq2hA2Oicl5eqwPqglI5FgHlta2jwblTvu61
   1kpDhlqu1SUeCWrYyPg8p4n1WO7vXGA0pbuhEAe9xKi6KeoLOkUb+Qduj
   UKJZdo5sv3Ae+nTB3QQyeUUbnPTcn5sgkHkDUb/NbSyzaiq2C7+ffPVP1
   eJRFJ9G2FM5/0gGdjt0CepuqLOm3FmTDq3JU50cDQslAS5/dfnKCzc4WQ
   bf4DcyDhhE+gkCKAsK3hkJuhcfTUwc0tT2q4TH7UCdxFbLSxw4x+v60PG
   g==;
X-CSE-ConnectionGUID: daewaPOZSKiR/y6/rLxYGw==
X-CSE-MsgGUID: 82bp5jV4SAKnp5Le08TP2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58632409"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58632409"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 12:04:14 -0700
X-CSE-ConnectionGUID: Az/XwK4eT9GQUuocgfjMSg==
X-CSE-MsgGUID: XfIat9EKQey6B+C0njlK8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,220,1751266800"; 
   d="scan'208";a="174365405"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 12:04:14 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 12:04:13 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 12:04:13 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.75)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 12:04:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WZeIGADK5f7lDpxFxIvwmx0SlOfAFOthcgEYQbih2ECtUWt3ZFMa9Akt8hHRos5jNnLXsbmW4ZX9izxwqtGQRkkN3RqsUInUGO0118IIfBdPQxPptQwgyVvaJi+7HPPeypC8u4IjwKNxlVI1Xw+ZIOP0xWJXmjPBLhuLNiTeJSIBIYHYe+u9iXOY4DCVhHXH7hLLz8IL9Ib3EtznJogLB5YMkaGyOYImfQHJ0iPuTORL4bHL6s4Z/upkNuTb/zqRsDbKyHq/1pFWcjBI940KK971xkONMS38knGIZuQfdLfos/fUBHQPRc3Vex0X34/NvvUpEEB/s2pkx49BzJiECQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ROzOwqDLP5y79TJIcH9pJQxSiOeryTYHLyO9PoYodCw=;
 b=JEKu+V9jDtrRDnbkH/A0aeDQ7Od/HDWcWU1qSXm5YR5a7dzDCTNtnqVWa3XaXdpfZUjrqSU+XLKOKP2tdXJ5ZCtueiVsVUfQISNe81b/QegJ/oU3rPCfeolLaelznobQJamAvOec1wrnZ31nioDjsX5R+Hu2kAplryhKbA7sAyWie6FJj9hSNeJxwr9eqdE+X4OMPCj6svUE2t9b9O04D8cIrihzEuoifHVQ+WTPh5OB5Femmc6DWkP8LcjbzX+yAOB80WOF8h5o2sKLCFhqosdZbCOIb8XSScWSWJY7A+OMqrLUtbBP59y38psksIjv8YvSzEJwIUWJMGgW8iJ7dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB5185.namprd11.prod.outlook.com (2603:10b6:303:6e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 19:04:10 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 19:04:10 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 04/12] KVM: x86/mmu: Rename kvm_tdp_map_page() to
 kvm_tdp_prefault_page()
Thread-Topic: [RFC PATCH 04/12] KVM: x86/mmu: Rename kvm_tdp_map_page() to
 kvm_tdp_prefault_page()
Thread-Index: AQHcFuZU9Hm9RGRGQkatSrLl2rbm6bR3UXUAgAEaF4CAAAO1gA==
Date: Thu, 28 Aug 2025 19:04:10 +0000
Message-ID: <56012f51fad537efdff61c7db0d6912e56d537e5.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-5-seanjc@google.com>
	 <953ac19b2ff434a3abb3787720fefeef5ceda129.camel@intel.com>
	 <aLClCzTepEk7bczL@google.com>
In-Reply-To: <aLClCzTepEk7bczL@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB5185:EE_
x-ms-office365-filtering-correlation-id: d5e86fb6-0056-41d4-0c82-08dde665abd8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VlBVRy8zN1JPNU9ETXVYSkt3Mk5vczJDejZqMGN1eFF0MjVUQU9yZXd0b2x0?=
 =?utf-8?B?UERQM3VWMFMzUk8yZElBeHlvWlhORitxQ0d6RUEyNjcrd2M2Uk40ckp6TVNH?=
 =?utf-8?B?NFgvV3d5K2wwSHErTEZoWlZzQWIxKzI1WCtTTkJLZk5HcFE5MktneWtyaHlR?=
 =?utf-8?B?UTVkdkxnNWU2QkZzUFFvWWxyZ1ZFZEMwTDIwNVp1S2hERXRNZHN1WWw2bE5X?=
 =?utf-8?B?dlg3ckNvSUsrMnUvQ1pBMFBmTUtYeXhOVEJDNWhBMkFjMlBYeFFvcUgwMlpx?=
 =?utf-8?B?V1p5TjV0MFRibGZjbmtQZ2NpUE1tdjBKbGNqdzJ5cXBkeWxqREx6TFEzQkE0?=
 =?utf-8?B?ekp1RmowVVRLNTlLY1RnZXpWUGNkY3dZOFBXOHcyNzYveVlYS21hWkxoTGlZ?=
 =?utf-8?B?SzBtaGRkZ0oyU0dydUg5bHo1Mk1uY0ZmTGtIY25ad096c1VBMkh6RytmbllE?=
 =?utf-8?B?TFJPV2I1VXlESTRMZzV2V3FEelVqUURMSEZzL0ExaGJ5Wlk2VjVYcUtzcks4?=
 =?utf-8?B?SXpPaXMwSy9yWTU1N3JlbDRSL0RHV3ptZ0tOV0VsbXFGTkFmUzZabFFUbUFw?=
 =?utf-8?B?anNONkZESjhPY2VINTZJcy9tanZlSjlDQXVPeEtkUW12STlFV3J2Mk1DaFYw?=
 =?utf-8?B?Vk5zMDFNMEdLaG9KRFkrZzFZeFdrVEFYbS95NVQ2UllvbnE5WUVJOEJYRWo5?=
 =?utf-8?B?R2JtcVd4R1RMQnFScjhmS2xEYW5Vck9rc3R5eFlzL2QzbnR0d3N3MlRjZHR4?=
 =?utf-8?B?ZWtXaUg1MVNnbmFJQkVjbEVJL0dScjF0dm5jaDIzMjExTEM4SEVocWIrZG52?=
 =?utf-8?B?cDhSUlFjL3ZPQjFwcndJR0FTRmNsSGUyN2RZbHJyQXFyb2FVWnl6SHRYUmZG?=
 =?utf-8?B?M3V2ZzNCQjVZclo4RU90UERZNWZwTEZkcytVYVlhcGt6WExJVngzYXhpZzNk?=
 =?utf-8?B?d0QrM2huUnhjSmlPWVlwUU4yRTFpQUFsS1pSOEVnQkFha1ZSMXpZUXBmeEl2?=
 =?utf-8?B?UHd1UnVROUVweE1IV250YUZYTnRPZDV3VEhqWTlaUXZBZUlpTDJKdTZaQzd4?=
 =?utf-8?B?aFFuZ0dxaFNMZldsVXZlQ0NoMlNtNFByS2xCRDNJU3B0ZUxLV2pVS3RtS3Ri?=
 =?utf-8?B?VzBsV0psYWpsR2lWR1BDRjltdjBZZnRENUFWMkxVSi9Bb0drSHZLT1E4TEJW?=
 =?utf-8?B?ZlloRi95MkV1ODhLRFA0dnBmcUQzMmV1dlZvMU5QVHNpN05RelhaTFEvSDVG?=
 =?utf-8?B?bUMwcWZvdjlyM2ZyNXEvUk5BSDBvdzBnYWtPR1NzUDFYYmV0d0tHWkFmcHlD?=
 =?utf-8?B?azRFZG9QQkw4aFpQRFhINnc4cE1rdXFJc0x4cGd3VG5xRlZFa0lZMjM3NUdm?=
 =?utf-8?B?aGNkeWp4bjVyWlh2NHpua0k1S3JucDBHc09EaUxxOUpHNjNqM2RZRmpJaUtx?=
 =?utf-8?B?ckNpRGI1dVJDaUZFaFBVY1IwYmFOYUptd1MrTVVJbS9HT3FScFpmeHpRYll4?=
 =?utf-8?B?NW5ib0RYbk9USGNFVGRqQU02SUFFNjlySTdiK2RTU3Bpb0xCWmU4ejFFcUpr?=
 =?utf-8?B?SE5NY1N1TzBBOU5yNW5zNnlEcG9uQzd6TVhJUEV5ZHdGdXRQUU9kVVhRL1g4?=
 =?utf-8?B?cGxVZkwrU25ZSkU2QzkxS2ttQy8xK3dTczFyN211MmRqTnhKY3pYWDRuYWFh?=
 =?utf-8?B?M3J2UmZUM2E0YURib04yZlVsRHBzSTVaYmpaTDYzM1JCOWVTNEp2Q0V4eHpY?=
 =?utf-8?B?VG9jc00xaWNTejZBSEF3Mk51ZW9YQ3JmblR6UERqc2ZkdzA0Y0dBTXdpQzJm?=
 =?utf-8?B?VFBSU0dZa2pRL1lQYWg3ejEyVVVVMFJ2YkVXdHlKaWtBZXRING9OUEtKTUVn?=
 =?utf-8?B?ZWhFN2Vya2VUeUI1WUZoZ1hCQXhyM0RBNXdpWldOZGlHaHhsbTM2WmJremhO?=
 =?utf-8?B?eHpmM3dzaXhpcmpMYUNoWUtvTWtTaG94cWhKZG9wU0tRSGI0OGtTNXNEWmhp?=
 =?utf-8?B?T0tnY2FOZC9BPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VU5CQU83SWZwak16a0JCY0pZZ2ZsNVZSV3ZDSGFBYlV0NDFFeFRYMzZ6ZmRv?=
 =?utf-8?B?QVpKOFBsK1FZRDNzK0Y0KzVrblFFR0FEYW5zZSticmhCdHNpMXp5MFVndTJs?=
 =?utf-8?B?Y2hROXdpRmNiUlRGbGNEQjNDdFBrTTAvb1V1ZW8wSGZ1TTFIWlZ5NTVrRlFw?=
 =?utf-8?B?YUxvdVBlWXhFNm05ak12L0t4MStXS25lblNmYkxNdy9UOSs5bEtidXBoM0ZQ?=
 =?utf-8?B?ZXZsWlBlVEt1MlhGUUFsZ05rbUJLVk45VEM4TjdUYUFzdUlLYmEvVHZLTVZq?=
 =?utf-8?B?cDhFcEtHOVJkVWY3QWY4WmR6MGJsaG0zYlo4QXdGaFpURTdHeExzSkltZDlC?=
 =?utf-8?B?VXFXVHRFT1BrOXpLSit2aUduSjQ0ejdsNGlrM0l3bmZBbWVIdmowNkg4VzdP?=
 =?utf-8?B?T2lGcTlNMkEwb0FuL0NXNDNNbVFhcXJLMUdYU3FmcUdNZTA3Q3RTVzNmWmU4?=
 =?utf-8?B?RHk2eVlrT0d2TWtHVi9MVDdxYW1OdzFJdm42V0xnUDBoOXA5cXNiVnpld1Vw?=
 =?utf-8?B?bUM2emR0SDIzMzZLK2ljZE14cjNwczJaQksvZ1NKMmNLYXNXL0RrQXVkVmxG?=
 =?utf-8?B?YkdrSGRZNElqN01yMWdMbkVPbXN3S2M0dVl4RHZkc2hmeUxRbU9LL1hiYlh1?=
 =?utf-8?B?SHdLTkxqMU1YMEJZZGtVZTgvdjhGeGpuYkNCbktZcUdUd1ZLbFpCWGQ3c1Ro?=
 =?utf-8?B?MGtqOEZ3VUJzcXBWTGZwUDNXVWNiQmFxOWlQVTZISVdUUkdKc0UyZXNVQlBQ?=
 =?utf-8?B?YW1TcFlOYTJpQWVWa2poQWFTY29Daktac3BTUS9oejlxUms4WGk1ZFFueHNF?=
 =?utf-8?B?Z2JpakRkZUsxN3ppTGpIVDNBZW5CSUZ5RDljcnhCMlBPTkJCMTNDMVV3V3JF?=
 =?utf-8?B?a2dSTXQ1UGhzWGpvYkRqZEdzT0VvTDZYMUtZZ0hIWUJnRjJXdGpkamdpN3pF?=
 =?utf-8?B?d3V1czZlQk9OR0hUWENVbnJ2UU1VWUJsRW9iNzltcElSOU9QWHNNcWRhcnZ3?=
 =?utf-8?B?N1l3bUhZa2FSQUllTk1MZ3VzT25rZTRaL2lDOXpOeXV3VitOd3ZFekh1V1Rw?=
 =?utf-8?B?czFyNEpSaStnT2M3ckhkcGpJSXBCc0NJYno2Q0RURmI4dS9KOGdMSit2TzNH?=
 =?utf-8?B?Rnc0MmJ1YXFjeCtkZnk5V1lpSjB2aWQ3dUNNVmhUVnZib01RZXZiWU5xRWdp?=
 =?utf-8?B?andJejh3SmsvV0N1QmhDODlVcHMzbE1ZaWttOXYrQmFPbDNOSTV2WVh3Vk1E?=
 =?utf-8?B?a1prRSsrQThxV1Yyc25UTlNCTlNzcXd2K0pVZDBXRDFFekdjejNuWkg3dVBB?=
 =?utf-8?B?ZUQ1V1BPTG9QQU1pWm5aT05TOGF3dUx4MkpDZmpMaWcra1ZGR1FwZkUzMmRF?=
 =?utf-8?B?Y0tvM2oxVWVFaFNwKzBQZDFqc2RDWGlaTkNlQ1VHTnJsNzFwbVkzM2RKQ0xP?=
 =?utf-8?B?aFdvRnpKS3lrMDhPaUMvajVlTHgyek4xUVV4dkI2Ni9ia0RtSDBaTlFoTzM3?=
 =?utf-8?B?YVJGbTZSUHZRQlVNN1dwS3BXSThxS2JVREhpSUlLSi92Y2JtaTVDRC9pMW9S?=
 =?utf-8?B?a2FxNWg0d1NJeXl5cG0rK3krQ1Q1WTFxMGJzMW9LS0pHZzdXRlFSZkZzN3Np?=
 =?utf-8?B?cVFFajRUWTVlRU12dXRQaUFGL3NjTDNaQUc3czJ2WGVFb2ZLMUJmcXF4UGVI?=
 =?utf-8?B?Lzk3azdWVUZndnJCM3NuZGZrUVZ2a1dsV2VGbTNERHFYcGR3QkJhUmVrQ0hD?=
 =?utf-8?B?ZitKVlUvSFdjcVFTRDVxcXJ0NFNZVUFwRGdUUUdaTjFZNzdqRU93VWk2cnA3?=
 =?utf-8?B?TWtvS3lSUkVnemZnYmpEcFhCdE5YU0pwNTBhRStwWVlyak05cGlnVWsvNGlF?=
 =?utf-8?B?MEt5L3dGUHArcWtrN1lOZUhDNEN5Y0Z6RUlSd3RkdWFQWnAxMWVKQ0JRc001?=
 =?utf-8?B?ZGxuaTg3RHMzb05PVmIxUm8vNm50THdIZW9jT3FScmpmWVdkVUtwNzgzVjRy?=
 =?utf-8?B?NUZuL1pTS1JZMzZDUnJSOVVHbUZ1bkRKbjhXVEdkOVNwTHloTHlNZmNsVkxL?=
 =?utf-8?B?cTFBM2FtUnI3ZS9yM1lacnJPaXBsKzRSVTd4U2czOC9TUlVxWmovTnN5djV3?=
 =?utf-8?B?ZldDWi9WVzI0OXI3a3ZXOTA5OVNtNHoxc2JQWnl6L21Tbmx0ak9NK2JGMWd0?=
 =?utf-8?B?cEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3245CF950A70DC43B5E58B1C4E8F88EF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5e86fb6-0056-41d4-0c82-08dde665abd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 19:04:10.5272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ELXSxROm9fQZVH2bWW1sB/ociXLrjNqkbADNKCkf1T9LUSeA79b8F0eK0lL9dquuTnCIQ+3aHfh5WkYxxAGlMFjTIUvBT9HegSPzp34rJ1I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5185
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDExOjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IA0KPiA+IEkgcmVhbGl6ZSB5b3UgYXJlIGp1c3QgdHJ5aW5nIHRvIGRvIG1hcC0+
cHJlZmF1bHQgaGVyZSwgYnV0ICJwYWdlIiBzZWVtcw0KPiA+IHJlZHVuZGFudCBvbmNlIHlvdSBo
YXZlICJwcmVmYXVsdCIgaW4gdGhlIG5hbWUuIFdoeSBwYWdlIGhlcmUgdnMgYWxsIHRoZQ0KPiA+
IG90aGVyIGZhdWx0IGhhbmRsZXIgZnVuY3Rpb25zIHdpdGhvdXQgaXQ/DQo+IA0KPiBrdm1fdGRw
X3ByZWZhdWx0KCkgZmVlbHMgYSBiaXQgYW1iaWd1b3VzL2JhcmUuwqAgTWFueSBvZiB0aGUgZmF1
bHQgaGVscGVycyBkbw0KPiBoYXZlICJwYWdlIiwgaXQncyBqdXN0IGJlZm9yZSB0aGUgZmF1bHQg
cGFydC4NCj4gDQo+IMKgIGt2bV9tbXVfZmluaXNoX3BhZ2VfZmF1bHQNCj4gwqAga3ZtX2hhbmRs
ZV9wYWdlX2ZhdWx0DQo+IMKgIGt2bV90ZHBfcGFnZV9mYXVsdA0KPiDCoCBkaXJlY3RfcGFnZV9m
YXVsdA0KPiDCoCBub25wYWdpbmdfcGFnZV9mYXVsdA0KPiDCoCBrdm1fdGRwX21tdV9wYWdlX2Zh
dWx0DQo+IA0KPiDCoCAoYW5kIHByb2JhYmx5IG1vcmUpDQoNClRydWUuDQoNCj4gDQo+IEhvdyBh
Ym91dCBrdm1fdGRwX3BhZ2VfcHJlZmF1bHQoKT/CoCBPciBrdm1fdGRwX2RvX3ByZWZhdWx0KCks
IGJ1dCBJIHRoaW5rIEkNCj4gbGlrZSBrdm1fdGRwX3BhZ2VfcHJlZmF1bHQoKSBhIGxpdHRsZSBt
b3JlLg0KDQprdm1fdGRwX3BhZ2VfcHJlZmF1bHQoKSB3b3VsZCBiZSBteSBwaWNrIG9mIHRob3Nl
LiANCg==

