Return-Path: <kvm+bounces-68330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AA37D334F2
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 16:49:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C85130DE594
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 15:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 428AA33BBB1;
	Fri, 16 Jan 2026 15:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QadHihUC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3CC33B6CE;
	Fri, 16 Jan 2026 15:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768578312; cv=fail; b=dkHQ9PMMA4tR6l9hyeRTIgty5OTvnqYjXF/TTtmChgu5PGnNheYePw7SitOD2ZVKiMkGMikP8Xznvf17acUNmyfq6dJV03KQKvQ9dwWq5vd/uHyTNvtdkjWsVg68Num4/ZRgAu6mKv2GWa8vUbGSE97R4NnKjHEJNFbew1baKhM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768578312; c=relaxed/simple;
	bh=f7crqWiYTgdwPRiD94/ziggRcOL7/WNIQ3Luw94lSlE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GGFwR5+sx9gLqXYMA1LORAsr6OfOkBrP+TQYxtDBIVYKSll+PVEMevBU+zfMpiY9I8BX+kAtklUnGuanymGCTxOQU7aysgi4Ubk6KUsBXa4x3JBrLNNb7dUWRuxKlcyrepmofvqCMp3QsfIYbDkMCLXyGVp2qUONMB64mU0fzN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QadHihUC; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768578310; x=1800114310;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f7crqWiYTgdwPRiD94/ziggRcOL7/WNIQ3Luw94lSlE=;
  b=QadHihUC1VTgskhRO08uM2V0qDGV/L2Hkzz7YU6CmTC7C3SDdEw29xB8
   bmb9x3l8IZHdIOEPIvubqELjTP4Yrwz+8MYprHuxV9ytdsxYGZRzPk8SG
   wh8jJownHtafvmm92rFDbkgHnuEU9DkuDrMOcrRoUmGhJp1vWdgAS48G7
   5vh/9wRPVqhH0Jt3aXVcVo2Av2K6tXUkVzul+Iyo9D7zg3MTenRnNTdW0
   cg9MX5WDNL65JwdJSRwDjijcLVkir4CesPVXglPF0YorvApSkPeGUOm2O
   yIHYFSi3xVv6kHEmt+cMZ4JOSurYivdMWYr4z9BhAe9QSNJw7s5IZFpmS
   A==;
X-CSE-ConnectionGUID: A1kCyrt8S/OkpObyD25jmw==
X-CSE-MsgGUID: 0b9Okj38TUe15AETpV7fVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="87310878"
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="87310878"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 07:45:09 -0800
X-CSE-ConnectionGUID: oA7G1DU/SUOBknp7X2GSbg==
X-CSE-MsgGUID: UcZ2uE5zThqyps05Z8IjEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="209767357"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 07:45:09 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 07:45:06 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 07:45:06 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.38) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 07:45:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OwIQS/1QlQdmgQ01nCpJ0miz1iBQiDqE+JYkxU0x9md8YxbJeHalzmTLmwzd0qkLmnH/OAZapiH8hcEh7hPDftXUcVbwKr1NIPXLsnqgUwKDDPRBqxDzyq5MpeWb67JoZUBQq+NkJfjrNLzZfJxC9XVpbKjwSqvmJLjqK2GGr9LyvbNfEtEOPfGcDui50Uw/WtVKqxuj8fOHqoqhLAt/BnsJqCwcfAiFs7wpn+FC9qojB67SZm45ZpPukTgz+FWtan05WoNP7x/9XwYt2IqOkkiGgefi5ssqksyFt2PbCC5lFvxspcJugtcVM+Yjz34QhtPVaQY1QgsZT4Dj1phzXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7crqWiYTgdwPRiD94/ziggRcOL7/WNIQ3Luw94lSlE=;
 b=mm1QghXC17lbD96/a763ykl3HAVCEKGZ7Qcm8ki3onx4n8BfMWz/7FJgCavHKI7NokCyWGvhMwmf2b688nU2lsXmcnmNz7xk/0ntqvfE8Oy+hcmP1v/IdlG6bs27XS9QhkfawlQcQstM2S4FqXzF+Ej9XY3x6/GqZjtIg6hiifEP5FaJxqZSdbw6UTRn8JbV1jZNjrGWllrmOEXHBu6K1uQ82arCeHDtSgmWuYc6la9Bm9rAw3xx5AOOA7Ms2F3mnT3fb7q/D3rMZ+7YM7ZKNpxFYgDxwfyscG9z+yGHgBVBsBS++3kTEpvJNgwxhr9VRUR2afAHlyMgT/P3aMmH5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6382.namprd11.prod.outlook.com (2603:10b6:8:be::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 15:45:02 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 15:45:01 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Du, Fan" <fan.du@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "david@kernel.org" <david@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kas@kernel.org" <kas@kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "sagis@google.com" <sagis@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "Miao, Jun" <jun.miao@intel.com>, "jgross@suse.com"
	<jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Thread-Topic: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Thread-Index: AQHcfvXkGzmJNKWdxk6kpDo1zXW6dbVFaxWAgAA9QgCAAANhgIAABy0AgAAbs4CACTPSgIAB2pWAgAAOLACAAIW0gIAAZZYAgAA6e4CAAFpRAIAClUGA
Date: Fri, 16 Jan 2026 15:45:01 +0000
Message-ID: <ac46c07e421fa682ef9f404f2ec9f2f2ba893703.camel@intel.com>
References: <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
	 <aV2A39fXgzuM4Toa@google.com>
	 <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
	 <aV2eIalRLSEGozY0@google.com>
	 <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
	 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com> <aWbwVG8aZupbHBh4@google.com>
	 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com> <aWe1tKpFw-As6VKg@google.com>
	 <f4240495-120b-4124-b91a-b365e45bf50a@intel.com>
	 <aWgyhmTJphGQqO0Y@google.com>
In-Reply-To: <aWgyhmTJphGQqO0Y@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6382:EE_
x-ms-office365-filtering-correlation-id: 45808b5f-ee40-4a8e-ba54-08de55163624
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SmlZOXk4N1llV3M5Q25RR0dVV0cxZkpIWFJpRGp1dEFFeUg2YTVQc2FMajVV?=
 =?utf-8?B?Uy94U1VhSE5ISXRpVnA5YmJvWUtSY2JwMXlNdkFWclgySkdIMzY2UWtXQ2xO?=
 =?utf-8?B?dW5JMHIvak1MYjhPQVdnbFAyZG10dzF2RlZsZTBwYWF4bEFQamNiYzgzRnU2?=
 =?utf-8?B?aGR5VFFiZEgwVXc0OUsrekxlVml3clJxbUpwTW5CbEJQMU8xQlFHbTkxbm9j?=
 =?utf-8?B?YlF5ZTY5enZpMXpCMXNobVBHQUtKNk95MURLTThnTDV0bFE3SEdRU2tKekRI?=
 =?utf-8?B?OVhtWTl6TnZSOWNyYVVFUDZ4bmc2THZXNzJYcTFTMDJxZm01VTFSSloyQ29w?=
 =?utf-8?B?bm41T2YyRUliOFJBenV4ODZ4dXNKWFJZajBPeVk0cmcxdEk5d1ZtUGh1MXor?=
 =?utf-8?B?QU1KQzRKdjRtWTN6aEVNMGlEbENhREFEczNtT0dZWWx4YjBkYVlDUWE3UERl?=
 =?utf-8?B?UEkvcCtvYXNpZVBxTi91WExFeVlmZHp4ZkE5UFZPMVZsWHppZndoZldHSitt?=
 =?utf-8?B?Z2tPbHN3WXpHQTgwdHc0TXpxU0dqR1p2NWphNXFDZ2RtYU1YZWhVa3NGc011?=
 =?utf-8?B?VzJxZFZWNU03M2NNY2NObmtReWlhZHdQT2w0ZUFKYzB0WmdBZjlscW1FeUtw?=
 =?utf-8?B?dTNsRFBQQXc4UVFYR0xTelpZSzRSV2J6WVNoeVZiRFNscXVKdjJ3ZmlrSVBv?=
 =?utf-8?B?Zjc0TWJrK3RWZlBGN29xaDBDaWFQbmsxMWE0dFNYZXpOOFlOQXFGUk8zckNP?=
 =?utf-8?B?MjNhN214ZTNldW9SNjVlazBGNmMvVnlCL3NDdmdvbWpyMkQ2Y1Q2b052dE1Y?=
 =?utf-8?B?WkZPT1daYkM2amRuVmJNTElmTDdvbGorYUVscUphSlJ6dXdsckNPdmx1N21Q?=
 =?utf-8?B?a09vVm9ZcHR1TDQvT1B0SEZrL2lST1RsQjVtZ0lUZzEwci9YSXl2MWpYeDlv?=
 =?utf-8?B?TWZXeVB0L285Si95SFQ5SC9lZkR5NlRzcmJHYzVweTVxYzRKaTVOY3FINk9T?=
 =?utf-8?B?Zll6djZNNEVUVDBXdGZDcUtNUzlUdEpsUzl6ZE1pTi9ZR1pYdXBkeVJhdHVJ?=
 =?utf-8?B?aU5DNHkrcnpDTVFqUWRKbmo2UTFxc0lCckFoQnVlSWtjNjIxa1BHUGxCUWtY?=
 =?utf-8?B?ZEY4Sy9SSFFEeWZ5QktXWktwMi9rTk9vOW4rMGU1VDJWQWZSQStqRm1qN3d1?=
 =?utf-8?B?djA3NVVJNHpSTmlNMzVlWndjQzJYeGlRWTc5eFJZYlYyVm16L29ISjRxQVhr?=
 =?utf-8?B?WmRWbXhJS0htMVdLUmRTZGx1V1pXTVFTMTFmZDNqb3ZuTWhxMnk5eUxEUzFh?=
 =?utf-8?B?MFIxdE5FWHdqd3lVeXVHK3AreG1wbTl3MEFpaFV5dUh3bmt3ckYwU2YrbXhD?=
 =?utf-8?B?LzRxVW8zUEcrYW9IWGxRSUhoN1Myalg2NHpMRHVQR245c2MvbGNPRHNET3h2?=
 =?utf-8?B?ZllVSjN0azZXYXVDS1hKZTVXNTZkdmJrRUVxalR3R2ZNM2JQWVUrZkVndmNo?=
 =?utf-8?B?M0lYWVRoY3V6RTZyaFlDdkpkTFZ2SXo1aXY2dFViTDZRbTFySFl0Nm9ZOXpB?=
 =?utf-8?B?UFdvZHQrdGhpdkZLdVdyV2NBQkNQSHlCU3lQMlp4TkF1dGFlakliOVdOTk05?=
 =?utf-8?B?ZkNYOWJIeDZ1KytsejdUbkZGY3JOZ2laQ1VRTXlrc0haZG1wQmQwV3IySmYy?=
 =?utf-8?B?Y1VVWUUvSlBnNXlnOW1rYml0eG0vNkR3ZjlBUWZvcHl0Zm1sWHFaQXhYS1Aw?=
 =?utf-8?B?QXFheXNWcVdjcGhaRjZXT3h3VXRhdHVRQVJHQXY0UUd5Wm0zS0JBYTNrZFM4?=
 =?utf-8?B?OEhkSU9ROG1WSGVLd1ZYWTRRdW1yTlFSakpFUHVXSTJBL2pnVkxEaVNnOVNR?=
 =?utf-8?B?Q091ZDdIeDkyaVRyMFV1UFNxdHAyRURkL2MxcHhrZWxodWVkR2FBenQ2bnpk?=
 =?utf-8?B?c3plQkEzRHo1YnVYR3lGYmt2Q0psVEpDRENOOVVFSlM4bFBnSmR4M2huOGdo?=
 =?utf-8?B?aWVzaHN1Q1hEOFNONnZKdHdDMVU4WVRSWWh2SUdUa2ZHZ0N2UDJmTXV5MHVu?=
 =?utf-8?B?QVdFRXFMbktSdVNEZktZeC91eDdjdXFhd2JFQkd5Ky90QkRwbU9WeURWVmRy?=
 =?utf-8?B?aXh5Y3FSU2dhYmpXTmYyd050T1RPQVIwRFhROWFOUUN3SFFvbW5JU3RhbFNV?=
 =?utf-8?Q?KFTbClNVKNXltTbjjwXNdCo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWNSd0RlRGFtOGVTanV3UGdRb0Joa0xkYlM4UDJML2YwRjZKNVBsMllGZkwv?=
 =?utf-8?B?YlBOZkIzQVYzaEcxekhpcUZ3OFBOSDFyZExsN3pWamk0WG1yMXRzc2ZZRUJj?=
 =?utf-8?B?VDRkKzJkK1daaHI4WWVyQ3BPZ3hNWExoZDF6YzUvU3ptUzVVYysralJFVGZt?=
 =?utf-8?B?RGFuVktGVjQzWlh0ZHAvRVdYVDAzV1ExN0VyYi96OHZMRm44Z0FQRi9ITFBo?=
 =?utf-8?B?WkszUjY3NzhKRXp2S0hicTVIZnFqR3M0V2ZtRFlJWWl4R0crYjgvODM4c3Vk?=
 =?utf-8?B?Nyt6L0Q1WFU4ZDZjWXdWOGdCSnhpY29xSmRJSjZyMk1mcndTZWRXQjNVYlQ5?=
 =?utf-8?B?bGJhVURkNHBoTit2ZzBlbk93a2ROZEl4ckFGaVB6WWhndUVFYU9ZV2g0Tmxu?=
 =?utf-8?B?M0RrZ0d1RjJPOHdTTHVoaVlxVFJ0TDQ1WTdJNkRPZ0lqTUJhU3dTQ2xkaktD?=
 =?utf-8?B?QUlhNFI4ck9jQll6THI0TnFhL3o2K040dlgwUXZXTUYxMTI5VlllZEhWcGRC?=
 =?utf-8?B?ZXVVTm8wUWZ0SjlCVnl4dkphQW9oY2ZyOWROWlJ0K0MzNVE1em54NzNJREJn?=
 =?utf-8?B?YmRvVFIrSEM1Qlh1Z3pGSWZYYjBwNzJjbStHT09GQWZGUThjRlJyRGFhRUhv?=
 =?utf-8?B?Ymk5aXVMS3pSc2Z4ZU1qWURkNzY2VDgrRTRReWJwRFlBL1hjbE5ueStKa01t?=
 =?utf-8?B?bzFucWN1YzE5a1JGOVAxeXB5NGF0YWkxekZuZXcwWUljT2dSNm1GM0pPWWpU?=
 =?utf-8?B?dWpxcld4Si9rcWVJdHduWWREK3Z5SGpNb0NNek1KWGVwSS9QWmhEcWl6OWM3?=
 =?utf-8?B?K0ZWckZtTy8rbjZLNFN0aVBSUkxBNExCZm5mdU4zU1dDejRzampMVWU1Vi9V?=
 =?utf-8?B?TVZybFlGdGIzM1d6YTArTm1oRnFPQ2hQTUFaVXNoam1PZUlHbzBOYTh3ODN0?=
 =?utf-8?B?ZEVWYWdBTXZTN0FPVEllZVNYQjRNeXloT0ZqNEhyYmVKSm15NXo2bHVnRDll?=
 =?utf-8?B?cFRzcERSOTBoYTN4eTJLamlxZkZPNHZUdlZIYTI2UDJ4eTBEV1ZFYnp4Ujdn?=
 =?utf-8?B?eUhRRW91WktwOVIzaGY1a0hWVHYvOGlwZEllVVEwWU5PeUNsNzlkN0hyVkt2?=
 =?utf-8?B?Q1RCWlBoQURUVmNNRTlJaUNWdXdjRGI3NTJHaFRwTkZQektrQU9uNnJCNEJE?=
 =?utf-8?B?bndBZGJMUkM1b1pVbmg3RXlDVmlOMkVMZG5qQ3MrMWJFak43QWQ4aHFMWlN2?=
 =?utf-8?B?bExpSkZCVUIxcjIvM2R1TVhvTlFXY1NoQUYxSm11elBlMkk3SUdPZmlaQUFR?=
 =?utf-8?B?ZUpqMnZLVmVVWWQ5UHJmNUdUZEJEL1FjVHBhMVdVV1M5RFhidklkQlByUm9q?=
 =?utf-8?B?dEtCMU11aVZ3ZTBQMHFlNlVJZGpXbWZ2WHY4VlBhelg5bWtKdlNicnlmYlZ4?=
 =?utf-8?B?VkFxd0tyYUN4MnVBSFlXV09wVHlCVjRubmdYOENTUGhDMDR1UW5RUVlHcFJT?=
 =?utf-8?B?MXd4amhIMGhKUUVqak55ZlhwUklXWElMNytIVWlSN1dTTHQraXljU3Zic2Nn?=
 =?utf-8?B?Y2RNTEk2M0FaeFEvdWZyNkY5N0J4bHRrZCt1bHpaUUgxOGdaRWQveTFYeHJy?=
 =?utf-8?B?Y2xmUlRGcWhOVzFuWitQeFRQK2QrQ2ZUVmFKdTRXWi9GWXVmbEZoZnE2SXNk?=
 =?utf-8?B?cGw3cDRsVFJNTXQvajRZT3RjbG05c2lxMllKaU16T1JEM0JnbG9SYmVqQTkv?=
 =?utf-8?B?U3NwZEM1WnUwSloyazM0TUtYUVhuUFljVFlYZUpTTFNVdXhGUnlPRWdUVVJh?=
 =?utf-8?B?cUR6ZWJmT29QTTNIbTZTd1U3QjFheVpWdE03TjRwb3JxeXg3V0sweTJZYTN6?=
 =?utf-8?B?bXNHcUo4b0JQQkdnNUU1TzhXUnV6MVdPM29CMVo0akRzRDc4aER4NU1qMHVi?=
 =?utf-8?B?aGtqUHlPQ0hNdEZ3aUtXSVNjL3ovMkN5RjBiRDAzNGJYODdoc2JBWUxGbWlu?=
 =?utf-8?B?Vm1xSUwwbnlSWmJqaHNWQUZKK1J2WEtnVnJNZG5qc0xSOE9BcmZ3djVpRC95?=
 =?utf-8?B?YzNCQ3NTTU0xQ0hxd1hLWFR6YnYwRDA3U01rQ0EwMTVDQ2FVTEpsUGpOdkFF?=
 =?utf-8?B?NFppbGNpME5lMVVpK3JhbnBJS1hUVld0bEV5bjRIakFEbXc4dlBjRy94Z2R4?=
 =?utf-8?B?NHIrVjRPRUNPaS9LbTFQL1FaRnRkY3ZZVFZjUytrZlhCQU50anh1K2RBd2Rr?=
 =?utf-8?B?TVJKdVFUOTZidFNrSzBrNUg4a0daei9uWVRvWStnUjNGanh2a0JXSm4reEll?=
 =?utf-8?B?aU1KdWhZL0RLM3NkUVNnMlpWMC9UQm9sOVhJaTlPaUE5T25pOUh4NlUwQVc0?=
 =?utf-8?Q?F7Cc/laWEzZqiL/M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2CB6076E2B845847BA398E7A713811CF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45808b5f-ee40-4a8e-ba54-08de55163624
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 15:45:01.8814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eassdQMaa/IAX1rod70QQNP8g0ZY6iUCyatLs59ADZZmqAxWCc+ta0T1FluCOGmdx0waXD5w5zZwyrlc0nSDD28G/YFkWl9C0j0rjM5MSzw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6382
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI2LTAxLTE0IGF0IDE2OjE5IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBJJ3ZlIG5vIG9iamVjdGlvbiBpZiBlLmcuIHRkaF9tZW1fcGFnZV9hdWcoKSB3YW50
cyB0byBzYW5pdHkgY2hlY2sNCj4gdGhhdCBhIFBGTiBpcyBiYWNrZWQgYnkgYSBzdHJ1Y3QgcGFn
ZSB3aXRoIGEgdmFsaWQgcmVmY291bnQsIGl0J3MNCj4gY29kZSBsaWtlIHRoYXQgYWJvdmUgdGhh
dCBJIGRvbid0IHdhbnQuDQoNCkRhdmUgd2FudHMgc2FmZXR5IGZvciB0aGUgVERYIHBhZ2VzIGdl
dHRpbmcgaGFuZGVkIHRvIHRoZSBtb2R1bGUuIFNlYW4NCmRvZXNu4oCZdCB3YW50IFREWCBjb2Rl
IHRvIGhhdmUgc3BlY2lhbG5lc3MgYWJvdXQgcmVxdWlyaW5nIHN0cnVjdCBwYWdlLg0KSSB0aGlu
ayB0aGV5IGFyZSBub3QgdG9vIG11Y2ggYXQgb2RkcyBhY3R1YWxseS4gSGVyZSBhcmUgdHdvIGlk
ZWFzIHRvDQpnZXQgYm90aDoNCg0KMS4gSGF2ZSB0aGUgVERYIG1vZHVsZSBkbyB0aGUgY2hlY2tp
bmcNCg0KWWFuIHBvaW50cyBvdXQgdGhhdCB3ZSBjb3VsZCBwb3NzaWJseSByZWx5IG9uDQpURFhf
T1BFUkFORF9BRERSX1JBTkdFX0VSUk9SIHRvIGRldGVjdCBvcGVyYXRpbmcgb24gdGhlIHdyb25n
IHR5cGUgb2YNCm1lbW9yeS4gV2Ugd291bGQgaGF2ZSB0byBtYWtlIHN1cmUgdGhpcyB3aWxsIGNo
ZWNrIGV2ZXJ5dGhpbmcgd2UgbmVlZA0KZ29pbmcgZm9yd2FyZC4NCg0KMi4gSW52ZW50IGEgbmV3
IHRkeF9wYWdlX3QgdHlwZS4NCg0KV2UgY291bGQgaGF2ZSBhIG1rX2ZvbygpLXR5cGUgaGVscGVy
cyB0aGF0IGRvZXMgdGhlIGNoZWNrcyBhbmQgY29udmVydHMNCmt2bV9wZm5fdCB0byBURFjigJlz
IHZlcmlmaWVkIHR5cGUuIFRoZSBoZWxwZXIgY2FuIGRvIHRoZSBjaGVja3MgdGhhdCBpdA0KaXMg
dmFsaWQgVERYIGNhcGFibGUgbWVtb3J5LiBUaGVuIHRoZXJlIGlzIG9uZSBwbGFjZSB0aGF0IGRv
ZXMgdGhlDQpjb252ZXJzaW9uLiBJdCB3aWxsIGJlIGVhc3kgdG8gY2hhbmdlIHRoZSB2ZXJpZmlj
YXRpb24gbWV0aG9kIGlmIHdlDQpldmVyIG5lZWQgdG8uDQoNCk9uZSBiZW5lZml0IGlzIHRoYXQg
c3RydWN0IHBhZ2UgaGFzIGFscmVhZHkgYmVlbiBhIHByb2JsZW0gZm9yIG90aGVyDQpyZWFzb25z
IFswXS4gVG8gd29yayBhcm91bmQgdGhhdCBpc3N1ZSB3ZSBoYWQgdG8ga2VlcCBkdXBsaWNhdGUg
Zm9ybWF0cw0Kb2YgdGhlIFREVlBSIHBhZ2UgYW5kIGxvc2UgdGhlIHN0YW5kYXJkaXphdGlvbiBv
ZiBob3cgd2UgaGFuZGxlIHBhZ2VzDQppbiB0aGUgVERYIGNvZGUuIFRoaXMgaXMgcGVyZmVjdGx5
IGZ1bmN0aW9uYWwsIGJ1dCBhIGJpdCBhbm5veWluZy4NCg0KQnV0ICgyKSBpcyBpbnZlbnRpbmcg
YSBuZXcgdHlwZSwgd2hpY2ggaXMgc29tZXdoYXQgZGlzYWdyZWVhYmxlIHRvby4NCsKgDQpJ4oCZ
bSB0aGlua2luZyBtYXliZSBleHBsb3JlIDEgZmlyc3QsIHdpdGggdGhlIGV2ZW50dWFsIGdvYWwg
b2YgbW92aW5nDQpldmVyeXRoaW5nIHRvIHNvbWUgdHlwZSBvZiBwZm4gdHlwZSB0byB1bmlmeSB3
aXRoIHRoZSByZXN0IG9mIEtWTS4NCkVpdGhlciBLVk3igJlzIG9yIHRoZSBub3JtYWwgb25lLsKg
IEJ1dCBiZWZvcmUgd2UgZG8gdGhhdCwgY2FuIHdlIHNldHRsZQ0Kb24gd2hhdCBzYW5pdHkgY2hl
Y2tzIHdlIHdhbnQ6DQoxLiBQYWdlIGlzIFREWCBjYXBhYmxlIG1lbW9yeQ0KMi4gLi4uIEkgdGhp
bmsgdGhhdCBpcyBpdD8gVGhlcmUgd2FzIHNvbWUgZGlzY3Vzc2lvbiBvZiByZWZjb3VudA0KY2hl
Y2tpbmcuIEkgdGhpbmsgd2UgZG9u4oCZdCBuZWVkIGl0Pw0KDQpbMF0NCmh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2t2bS8yMDI1MDkxMDE0NDQ1My4xMzg5NjUyLTEtZGF2ZS5oYW5zZW5AbGludXgu
aW50ZWwuY29tLyNyDQoNCg==

