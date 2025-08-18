Return-Path: <kvm+bounces-54862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAD8FB29606
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 03:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 592654E1804
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 01:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0606F222575;
	Mon, 18 Aug 2025 01:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NZ1i2DYS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92D41E9B2D;
	Mon, 18 Aug 2025 01:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755479719; cv=fail; b=XVihm8G50bIQFq/Zbka9su97y1si2WBkND8H5rbLooHAl9Whcoj1pXJvPdSpHKnaNm0GdeZaBsolG0OiNAlbLI2ToJtqXuABk9EkGnqYU8IAE1VtosePnjJv/xEGK6eLUG/G9Rp2X/aJgQW2ScdLecRaxzul8Jk8CZ8pyUULk5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755479719; c=relaxed/simple;
	bh=7bzx8MsXM1TDKJQ6rPxOnzsmwVyWe4ts+FsYFYPyPAo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BH24dx/MX+T3hPgDlnJsNLJJbT/fEYPZ7TDTVNBNiabTJ0KkXjr1tGQlwkkT2a6lPv35xBKSoLfPkpAmGUwVEgk6p3AbmuGVx+GsiTizwgarwCV1XI7+PiA0Amq73hDX3Qb3J0jQuLvwBRupo5PUKamEtMhcf7sEYh98+gkhH3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NZ1i2DYS; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755479717; x=1787015717;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7bzx8MsXM1TDKJQ6rPxOnzsmwVyWe4ts+FsYFYPyPAo=;
  b=NZ1i2DYSHE1Kc3SU3qdbSipOps1I6MXAUr0b5LB24ZhrgsF3THmhSbSS
   DwauJ8qQSsOsprZKGZofzRnfi0ErggbJG1nHCwW5UPhuWR3I3qgNe/wQ8
   vgTl9zTgWEoUpmLGHmG/rIUdCKH7NdtKxcJA0bfx1XVLy2b3VIroHowCV
   Br2Bt2GyDS7NpbRJmd0RhX5XYF4f/op7elYHzkXFdMXm7Q06tnhh/1Gm9
   6tZzYcY+ub0ruKh/lbWNnWT4ec889KYgLzU/rJRnz1bgvdCKpFZIRgMEX
   iFTZCiVQk0YwJPyyDmUKrrZvTKVoS8KR0Fe4zEhsDmnkH1ciwTYvikwMh
   Q==;
X-CSE-ConnectionGUID: 3hvhMVn8Sji/I2DZAWq4qQ==
X-CSE-MsgGUID: 6WaYIz4cQdiAQSWD7TGLJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="69068521"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="69068521"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2025 18:15:14 -0700
X-CSE-ConnectionGUID: YcmBJNeSTyaEk5/3HAOLKQ==
X-CSE-MsgGUID: 4JDExh2bSAOcbAgnRigcwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="166622202"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2025 18:15:14 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 17 Aug 2025 18:15:14 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 17 Aug 2025 18:15:14 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.75)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 17 Aug 2025 18:15:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AF6L+VBR0rYtAafYKusnsOq9U8TTF1B2IF3HcJd1JHk/IPlgK40SM8CxBuVV7JXUXWet58USOdyEM9mxII5mkDxiC4Bhng7cX5+zOj7vwhbuGBoIpVQJw0qw5rYr4PneXuLdaxblRD7gbZWdnlUl2jX8tGBDgRGg2Of+1rdG0jN/83ZaD/zcurcSdXgF6OmMK44AwhFrVGqUyMq5/O8p2m+e3Zy6X1s8bcYsFg5mm4TsfGsZd4/0IPQ4n0udIjXIbGTYK48B7jQ2W1UkeKSOVukoJsfy6KnRMYgkNNsrnWbP3dIP5Cm492R31JtZip4UTrf9UU3r8NiULMn3HI1xRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7bzx8MsXM1TDKJQ6rPxOnzsmwVyWe4ts+FsYFYPyPAo=;
 b=grfMf/ALpa6gUXUZRxPRP9TApx4TnFeeLVNzO4dhdHAYpy3IaW70fhuwX2xUCt5yzXqUE/ZWoNsAHFm845W5BY3TA0bH5Ua+CxiFGa5gAtJq/2LVvGXAaWsW4PFCYdWHh37DGSMYSt7poiSiyJqBu7C8kSUnsYDv57E5dIeb/NoHwCZoR+LH+wMI2tfSyXY+eQOo7D0n8TcqEBu45/oTG10RP5MNttRBuoTUngoCvHCo+mOqcSjUttqwuI7joaNV7KDZGBkJR0xEg1RAI5n0JdH7LmOzRnMiUAHlTOIGPaamvWqy5m1kNYC6kQL13/TzaoYm6g75ZhTbCy1hjrmRIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ1PR11MB6105.namprd11.prod.outlook.com (2603:10b6:a03:48c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.21; Mon, 18 Aug
 2025 01:15:04 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 01:15:04 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "bp@alien8.de" <bp@alien8.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com"
	<sagis@google.com>, "Chen, Farrah" <farrah.chen@intel.com>, "Edgecombe, Rick
 P" <rick.p.edgecombe@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v6 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Topic: [PATCH v6 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Index: AQHcDKjwA/MDJMaULEiIw1pbHh6AXbRjikOAgAQXdAA=
Date: Mon, 18 Aug 2025 01:15:04 +0000
Message-ID: <5e7e201d7e733e7b353b7446de701e0a2c6629f8.camel@intel.com>
References: <cover.1755126788.git.kai.huang@intel.com>
	 <b88c6a54174a757f44e2f44492a21756be05dcda.1755126788.git.kai.huang@intel.com>
	 <20250815104601.GDaJ8P6efRLzRTD-2i@fat_crate.local>
In-Reply-To: <20250815104601.GDaJ8P6efRLzRTD-2i@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ1PR11MB6105:EE_
x-ms-office365-filtering-correlation-id: 3d62fd38-eabd-4d82-b35d-08ddddf4a9ae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VXJVSEtxYitFRXdIZmdTOVA5bW5tam1LWS9ib1J1TWlVTFhvM1JHdk5pNzly?=
 =?utf-8?B?K0w4TUVkR085UU1vQnRMcjVEVVJ3NEtlN0lVbHFWY3JIcHJFVHJVQXR6dG9D?=
 =?utf-8?B?alJjc24xZmFhMGx2Q2Fha1cvWnBVT0g5ak5GVHU1VGFtbHBJaU5UZVcycnkw?=
 =?utf-8?B?MXFxL2x5ZmxJbHBzQUQ1Q2h4eXRmWWx3ZWR4bE9DanViZ1BOOXJvb0RGeUMw?=
 =?utf-8?B?VW1SZ2UrQkdrQTRyT0tqczk0SW5SVW5YbGdoQWZSSlQxTXJSYWlnVlRJUFc3?=
 =?utf-8?B?UW9jNG9QUlRXV2VPSENBc1JTRDI3T2JPbks5WUhzOXllZFMreXFzMXdCZWkx?=
 =?utf-8?B?Tlo0Rk5CaDdjL05ROFRNSm1nNHdUWWJyeFhXcUpaQUZ3NzVSN3dhYU9IeG1p?=
 =?utf-8?B?WlZnbytWaFhOWWxOTnR3cGJPRkRwTzhaMExYMkJEcHptS1ZOR1NrSlluT1pM?=
 =?utf-8?B?WGQwWFgzSkozTyszTU9tL0hWOExHTmRDUEZzUXpDT3NKRGREcy84MVV3Z2xw?=
 =?utf-8?B?VTRPWDQrYnRNa2ZnanhzZUI4YnpieXBneGFsZUpJb1lYdXhEbjJMMFYrcmYr?=
 =?utf-8?B?TmpqT0dSN3VQL081b3hGcjFTYnhDN3RZQ29LNGVMYnV3R1dOQXZCVk82RHhK?=
 =?utf-8?B?bmRHTGYvMVJSUFE2ZzgxWUU0U1FHRmw1SVk3TmpuMk5ocTRxTkcxTUN5Nisz?=
 =?utf-8?B?VGRya1FYWjl4L3FjNFZZUktmbGhnVzhPRFVZUG5qd0oybktlNHJReGRWa2M0?=
 =?utf-8?B?NUNxcXU3aVR1eFVSandYOHZWaTNmZmRGdmR5U2pkMkc2QW93dmNWTFZKOUxL?=
 =?utf-8?B?ZEwvTEV2a21ZaTNRYTVNM0Z5UmdYR1F2TEdvYjBvZkljcWU2YmdPam1Gb3JM?=
 =?utf-8?B?cm5JRDdhaFZWZkIrTlRkUUFUZGVQUnR0TDhKY1FvQVpUZEhmZmZic1doaUtu?=
 =?utf-8?B?K0RkdEVOc2pWdkdyNmRIUm1zaXZqbXA1U0tudEFldXVtSEJGVFE2NHhraUdu?=
 =?utf-8?B?MkcrbVlCSk1tY280K1JvNTRDdElZQUpvU3Y0MVdHaGE2WHMzR0M3NlBqZ2xl?=
 =?utf-8?B?Q0lXS0M2OUxadmtIYlNYQlBxbmd5OExnd1pvQWZyMkRQRkNMMEFhNVN1dGow?=
 =?utf-8?B?WnNRQW9kTTJuaDVKL0VSU2k4S3Y2aU9OL0ZzbW1nM1pkbHl0R2pXNHBHaHdD?=
 =?utf-8?B?bU9uZTlncUlTY3FHdjVlTkNEUFpKbDZ4WFRSdElDWDdPUTUzbWhIZTlSbm5X?=
 =?utf-8?B?Zlo4bUViOHg0d1RJdHBnNGgzWWE3VHhWbFJuNERPUzMxTzBJZDlBWVpMbVZw?=
 =?utf-8?B?U0phRS80Z1o0T2JTRDNTNWpUc0tpVjhYYkZnNnNleTlSdVlxY1M3bFE4VXVS?=
 =?utf-8?B?RnZGMjByMU5FUnVySm11a0RnM3RFb0Z6MHd4RzVDKzJkMDUyUTZOdnhpbDZm?=
 =?utf-8?B?Zkl2Z3V4cldFM3oxUytnamd2c2lOYnZWSUNWMkdNRDc2MUxlSkdDV1VNcWEx?=
 =?utf-8?B?Q3ByNDNwazFhS0RsR2VsNllkbFFqYzJQVVgvZ2xaV24wODlNMnV1TlhwZzQ0?=
 =?utf-8?B?L0dCUkt2RVY3dldOMzdLKzJrMGJNVmR2a1NiNnpzNzBmdVRrcjA2T2d4a2pl?=
 =?utf-8?B?K2NhU1pHWSt4Q29RMGVjK0pVdlRMK2hrQlVoK01aeElYSmlDd2VLdlAxZ0Ju?=
 =?utf-8?B?T1Q4aUl6b2tHU0FBWEYrSTliazdHSk5oT2lMcnozM24vWGFCbnRYVUZBK1BD?=
 =?utf-8?B?aG54Z3RoZUVxTHU3R29OR1pwKzBBRlJXK3RiVWszWGxveWlzZXNuS1NKVTZL?=
 =?utf-8?B?YlZOYThyM1U5WHc4NlR2R2pQUGtYbzlJV1lDRmFjNmh2UU0wenpNV0E5WjRw?=
 =?utf-8?B?V2NBaTgrcmFDS3NveU93ZUZ0cndaTldTMDc4MzJ4M2hIWXlDNVZ3bHBuRDA2?=
 =?utf-8?B?dTlJNDNPeGwrMDdGQTdLZXhTaHBqVXdNK2xYTnpVOVp5SEt0Qi9VNzBwb1p0?=
 =?utf-8?Q?QKsQq+vLR6nXONmxod0LHmJa+MRI5o=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MklRSm1KSnMzT3kyUDBtbVdEdTE5U215cGRidEYwNUhicmpVdWtJZnB2ZWhm?=
 =?utf-8?B?c2tpTkxtQ3FLdkJqS2xVRm94dlNKQUpwbHlJSjBiUlk0SER2MmFhdXJUODVv?=
 =?utf-8?B?NkJuRE4zVy9ka1RNejltejdFazNYUys3NUF1MnNnZEgxV2FUcm1GenRjY2ZH?=
 =?utf-8?B?ODF6TWhiWGJ5V3BlRDVrMWZzQjBaS3ZoMnpyNlVydDRBRmdDNkZWcUVLeXVj?=
 =?utf-8?B?T2hPS3Z1WDlTNDFiNWdCNXIxNmVzOVZjZFZEcktYTCtjWFlLMXJwbTlXT3Er?=
 =?utf-8?B?aW8yOEh2dkZiS1NFZGNNdGIvOGdZR21YOS9tcWhOSm5Mc2kxYnVhUWEvYlBo?=
 =?utf-8?B?RlR3bndUeGU0RUJiT1NQaUV5Wjl0dkNjdTZZZGVwVVJQOXNIRVhIelQ3RXdU?=
 =?utf-8?B?ZVpoSUcxeVo2d3pWOVIxamhmdzJwUENIWWhoditwaWY5NVRhaC9ITFl2Rzhx?=
 =?utf-8?B?UzlYNHIrZkxBR0VZVk5jTEY1azlwVFVRYTFHNkhyVFVKYTFLSnFYcmRUa0Yw?=
 =?utf-8?B?MWk4TlVucG9OYml1akNDTUtveTZLTnBhVnkwaDhyWjMzcDdkaHNIUEN1cUpi?=
 =?utf-8?B?WG9HR3pOWXJUYUxuR3U4YWhIb0lKU2J5RlZxQzI3UTJlanJ6OTM0ZmVHSCt0?=
 =?utf-8?B?d2VmSVZxWWkzcC9haXlRT1g4MUVOclY4a3ZBZmdsUS9rTHZVb0pZb3A1cGFO?=
 =?utf-8?B?bDV1ZHdCV2hYSXZVaElycmQ2TDJlVjFaN0lPbmdCUDJBS3dVcHF6eGlSQ2Zn?=
 =?utf-8?B?MUlCN09SRWMzZkI2ZER1NlZYcG5iODI4RWhIM3FKWE1EVjQxdGVabklCQjFL?=
 =?utf-8?B?V3AvV05scFBtdlRDdkM3R0Ywd1dENk54QWFKblRXalluZlExUURiUkhSeEMw?=
 =?utf-8?B?cEFhaTdRWWFZdG82SEFPd2dKUWF2RnNsWHR3SUtUd00raTZxaEw5S2h5YXdT?=
 =?utf-8?B?SHFGcnlJalhPVmZ2OVAwT09rN2xsblNuVkhOS1hLZDFmNjlobEljVUxBV1Mz?=
 =?utf-8?B?aGtBbG1mZC9Ma3ZKRG5Td20zZnJQUldxOHp6c2FIdUFuQ1NQRHdWUVIxWDV4?=
 =?utf-8?B?Y1p5NXhidStZZHpDTHQ1SmRLZ2YzcjBLeXhwbWlwcTk4M2gvcXNtYWhXY09p?=
 =?utf-8?B?M3h6cFRHdldIVWkzc0ptYlo5ZVZybWJMMXd5eFkxamNIMGJBMDBTOExvdXlL?=
 =?utf-8?B?bTNmcHF0dVZDNEZ6SnRUdTJHWXJCUFJyM1M2RlNkT1VsU1JHbzRZUE9OQi9a?=
 =?utf-8?B?THh1YThlT1Uzdm9iZldabll1YkowcXN3ZE1oZGc0NWNGVFowaVdtWmNFb2ZH?=
 =?utf-8?B?YjhsUDJNK1RvbktsZ3pqdzczcnZFa3ZkTmQwaWhwbkltbFVUNDluZXJIMThk?=
 =?utf-8?B?N3Z4OTlPbzFwZmQyM0dNTFYremIzYlU4S2Z1TjJhWHM1YVJVSnQ3ZEJFamRG?=
 =?utf-8?B?cUltaGJpaXJaUGVZejlJdU1GS1B0MTVqVm45aVlOdncrMklidFF6YnRuZmF3?=
 =?utf-8?B?eWdORDZBdmdMTVBkYXRhNzd0cU1jd0h2UkdNd0lNZmhOelRpUDNyRlI4bG1Y?=
 =?utf-8?B?UHhESXZndm93QzExSGp5OXh1NWpmMGV2V0pERFkxSlFsVTBjbVhQZ2dZalhZ?=
 =?utf-8?B?bmtLVjIyUi92N3RmTHF3UHd3bmxQTTczTC9BaktwMFlrYkRkSzI0MmhVN1FM?=
 =?utf-8?B?OTFpSG54R1p4RUpPN0l0akJja2xoVWVOWU42UWZaMTNscVppUEV3RzNQU0pw?=
 =?utf-8?B?dzZLcWJ0NWEwSjZNWWpOV2RnK1IyUWJZQkpSVkZZOGFodmtzemRtS3A2NFlP?=
 =?utf-8?B?WDBUZWxjSE5LUWhPeDZ5NVdNazBpRkVDRExkQTVWaVVFWUdxeU9hUGkwODVh?=
 =?utf-8?B?UVlGTXBSRnh2ZUxhY0JveTRVYnV5cVp4ZG05a0VZSjhXcEVGTlVnT0pJbURE?=
 =?utf-8?B?aS9XZmJyODY1UDVJN1lRUEdDUG5ZSHpYbTVickszcUdiK2JSVTQyV0FMYitM?=
 =?utf-8?B?RHhVWVBheUNCN1VIUWhIdUtSeFhCSW5IS0g0UExtVFZpakd6Tm1rTVBvdmxB?=
 =?utf-8?B?anU1ZlZieTJCMGlxTGVWMDhtR0lySFFicGxKSHZoakZuREN3bVpqZm8rTXUv?=
 =?utf-8?Q?AiHVhdbXO7I2koo5T1EbuKywt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <50A3F0076B7E79428C30E26F5DC4E4A9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d62fd38-eabd-4d82-b35d-08ddddf4a9ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2025 01:15:04.4677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N4ZbYIT8osRm3YE4vwvpFjae9CZPXw3w2NZNtV14uuQh204RkcSTgFCiPyIeyWnhJRxDSeVAT9TD/eXptCOEPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6105
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA4LTE1IGF0IDEyOjQ2ICswMjAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIFRodSwgQXVnIDE0LCAyMDI1IGF0IDExOjU5OjAxQU0gKzEyMDAsIEthaSBIdWFuZyB3
cm90ZToNCj4gPiBEdXJpbmcga2V4ZWMsIHRoZSBrZXJuZWwganVtcHMgdG8gdGhlIG5ldyBrZXJu
ZWwgaW4gcmVsb2NhdGVfa2VybmVsKCksDQo+ID4gd2hpY2ggaXMgaW1wbGVtZW50ZWQgaW4gYXNz
ZW1ibHkgYW5kIGJvdGggMzItYml0IGFuZCA2NC1iaXQgaGF2ZSB0aGVpcg0KPiA+IG93biB2ZXJz
aW9uLg0KPiA+IA0KPiA+IEN1cnJlbnRseSwgZm9yIGJvdGggMzItYml0IGFuZCA2NC1iaXQsIHRo
ZSBsYXN0IHR3byBwYXJhbWV0ZXJzIG9mIHRoZQ0KPiA+IHJlbG9jYXRlX2tlcm5lbCgpIGFyZSBi
b3RoICd1bnNpZ25lZCBpbnQnIGJ1dCBhY3R1YWxseSB0aGV5IG9ubHkgY29udmV5DQo+ID4gYSBi
b29sZWFuLCBpLmUuLCBvbmUgYml0IGluZm9ybWF0aW9uLiAgVGhlICd1bnNpZ25lZCBpbnQnIGhh
cyBlbm91Z2gNCj4gPiBzcGFjZSB0byBjYXJyeSB0d28gYml0cyBpbmZvcm1hdGlvbiB0aGVyZWZv
cmUgdGhlcmUncyBubyBuZWVkIHRvIHBhc3MNCj4gPiB0aGUgdHdvIGJvb2xlYW5zIGluIHR3byBz
ZXBhcmF0ZSAndW5zaWduZWQgaW50Jy4NCj4gPiANCj4gPiBDb25zb2xpZGF0ZSB0aGUgbGFzdCB0
d28gZnVuY3Rpb24gcGFyYW1ldGVycyBvZiByZWxvY2F0ZV9rZXJuZWwoKSBpbnRvIGENCj4gPiBz
aW5nbGUgJ3Vuc2lnbmVkIGludCcgYW5kIHBhc3MgZmxhZ3MgaW5zdGVhZC4NCj4gPiANCj4gPiBP
bmx5IGNvbnNvbGlkYXRlIHRoZSA2NC1iaXQgdmVyc2lvbiBhbGJlaXQgdGhlIHNpbWlsYXIgb3B0
aW1pemF0aW9uIGNhbg0KPiA+IGJlIGRvbmUgZm9yIHRoZSAzMi1iaXQgdmVyc2lvbiB0b28uICBE
b24ndCBib3RoZXIgY2hhbmdpbmcgdGhlIDMyLWJpdA0KPiA+IHZlcnNpb24gd2hpbGUgaXQgaXMg
d29ya2luZyAoc2luY2UgYXNzZW1ibHkgY29kZSBjaGFuZ2UgaXMgcmVxdWlyZWQpLg0KPiA+IA0K
PiA+IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiBS
ZXZpZXdlZC1ieTogVG9tIExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lAYW1kLmNvbT4NCj4gPiAt
LS0NCj4gPiANCj4gPiAgdjUgLT4gdjY6DQo+ID4gICAtIEFkZCBUb20ncyBSQi4NCj4gPiANCj4g
PiAgdjQgLT4gdjU6DQo+ID4gICAtIFJFTE9DX0tFUk5FTF9IT1NUX01FTV9BQ1RJVkUgLT4gUkVM
T0NfS0VSTkVMX0hPU1RfTUVNX0VOQ19BQ1RJVkUNCj4gPiAgICAgKFRvbSkNCj4gPiAgIC0gQWRk
IGEgY29tbWVudCB0byBleHBsYWluIG9ubHkgUkVMT0NfS0VSTkVMX1BSRVNFUlZFX0NPTlRFWFQg
aXMNCj4gPiAgICAgcmVzdG9yZWQgYWZ0ZXIganVtcGluZyBiYWNrIGZyb20gcGVlciBrZXJuZWwg
Zm9yIHByZXNlcnZlZF9jb250ZXh0DQo+ID4gICAgIGtleGVjIChwb2ludGVkIG91dCBieSBUb20p
Lg0KPiA+ICAgLSBVc2UgdGVzdGIgaW5zdGVhZCBvZiB0ZXN0cSB3aGVuIGNvbXBhcmluZyB0aGUg
ZmxhZyB3aXRoIFIxMSB0byBzYXZlDQo+ID4gICAgIDMgYnl0ZXMgKEhwYSkuDQo+ID4gDQo+ID4g
IHY0Og0KPiA+ICAgLSBuZXcgcGF0Y2gNCj4gPiANCj4gPiANCj4gPiAtLS0NCj4gPiAgYXJjaC94
ODYvaW5jbHVkZS9hc20va2V4ZWMuaCAgICAgICAgIHwgMTIgKysrKysrKysrKy0tDQo+ID4gIGFy
Y2gveDg2L2tlcm5lbC9tYWNoaW5lX2tleGVjXzY0LmMgICB8IDIyICsrKysrKysrKysrKystLS0t
LS0tLS0NCj4gPiAgYXJjaC94ODYva2VybmVsL3JlbG9jYXRlX2tlcm5lbF82NC5TIHwgMjUgKysr
KysrKysrKysrKysrLS0tLS0tLS0tLQ0KPiA+ICAzIGZpbGVzIGNoYW5nZWQsIDM4IGluc2VydGlv
bnMoKyksIDIxIGRlbGV0aW9ucygtKQ0KPiANCj4gUmV2aWV3ZWQtYnk6IEJvcmlzbGF2IFBldGtv
diAoQU1EKSA8YnBAYWxpZW44LmRlPg0KDQpUaGFua3MgQm9yaXMhDQo=

