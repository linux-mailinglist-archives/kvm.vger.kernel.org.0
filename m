Return-Path: <kvm+bounces-71373-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id INsTLXitl2nO5QIAu9opvQ
	(envelope-from <kvm+bounces-71373-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:40:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CDE8163E46
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:40:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A8296300B45B
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 00:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A4F81E1DE5;
	Fri, 20 Feb 2026 00:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RkhUYwG3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9E41EDA32;
	Fri, 20 Feb 2026 00:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771548022; cv=fail; b=n/HKKmQb9MRTMqQ3QqkpI+pQqUc0a1K0sf1E7+9eXhOPaG/l9+tFI/jlTyiPIiQWGvqY7bN/Sf248UJXdCyo4l1hxM72HEnxewAatDVPDCJqwCVhWWoTi/u0CXfjEHuogv0qBtMXO9IO9SFnnv88xrbCGcoYZcRkVClkaaeXMYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771548022; c=relaxed/simple;
	bh=L5IkF9F6tkHaNTj6Cn7g+mGzv9i+iGNYJfj+3gdwWak=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hgEvKtEJcO5qji/ES2yLmz4q6u9aCrXFgm+/yflmkagoQQzOxxBvHujRVNZuizMNh4CnnYD5R0lD+rccd0Z1boDqCSqcSh9UsdGE42AcaP8wQYuwE4ppp/ud/+56g5pSO2AagSKnmnM3O22HV54pLUou5VPiiBnIq0nnNOxescU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RkhUYwG3; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771548020; x=1803084020;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=L5IkF9F6tkHaNTj6Cn7g+mGzv9i+iGNYJfj+3gdwWak=;
  b=RkhUYwG3sMDy71bzdwUOUTjqR4hWyp2tTX5SzBsl3rN6d2BUfBuIghLJ
   WoUqtIjGNRp2kZ+60kuOVraMBVZcSQ2MIxL1EwfinnBb35QOpiCCA7Lay
   //fKgOWqjykFRy16SSmd8zOK++oRIp12wdSezVpWB87CPkYFMleniO/po
   X0X7aONBZ39k91WIX2fqUtPg1272b8L0Y3CfGTLPMxm6g4o5f6S0ycdRD
   30EkJSEPK1gHjCUEik56z2VACM80Dz+URfuWBkeG2jQnIrH/Pu25EJGPz
   aqVMqSkTypt0rLL0qHKHvRO2Be7/k58hLeAhawbltPoYCAqCG3yZhL4jC
   g==;
X-CSE-ConnectionGUID: 7pu9Dbm8TRWvSsq1tc8fgw==
X-CSE-MsgGUID: ejuhN67LSWWefw4nQgkzhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="98110921"
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="98110921"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 16:40:18 -0800
X-CSE-ConnectionGUID: WFw/Ti+hSLSJmYxtNs5yVQ==
X-CSE-MsgGUID: FWWzwKz4SwybwxvNjJE5gA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="214550941"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 16:40:18 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 16:40:17 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 19 Feb 2026 16:40:17 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.28) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 16:40:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E5m6XHlk5XTJRd0Bjo1BohdluAUvLrZNBsk6OFjOcyQnxulJlllJtWG0JwFiHmjlcg9LpnKyvps100kIYQP+Hfmqf/jhMc7w5ViS3YYizHptfwDLxVRDVhH1gicv+rEex+1wOkMSkiJiGwgtzpH3NK3ArS9/06TD9nwBHU7z4SdCiyOv7UGGRsK8CWW+pW5XIB1i8FVugtw0YTKiLpa5hI+88F5IEXbPt13ScguRiepk73fYG9ruJTt0cgD/jQPgdsbBglMDLL7f3fibeCNyoH+Ihn9yLUvGdqEpEX6yodcydCZRFMxd36STDWXHRDumh2n6YDib456MRDSdHK0TtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5IkF9F6tkHaNTj6Cn7g+mGzv9i+iGNYJfj+3gdwWak=;
 b=YRrcHmNjwRKQrdvbYU+4DXAqpZLPrfacKJtP73eZVGIg6zQWYqvziuNRL0pFeyFU0oBXR4pnIp4LgMAVTfibO+LdhjQEoElAF2hchIk3tEWPvheZPVmi9aWqg+g+778QaY26Lm9VPLthHjMIfxflGc/VOqVyF+c0TmBAZKHnmhJbw2ufmzCuJfVBV6lP1rAak3NHtmqPxoTQ0PX94+jHFoFPPjQKvnjPTggIMyKDS9Jm7FZWbuNIzAYJQkOXd1UfJS4iW6um2q321V0oqOXZoiGcTMYTXN2lCn0Ox2dW1XJaA+FwDwpk/MkdbBxBRHAEHw4gTSoyYxX6aiy+1XhqcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 SJ0PR11MB7703.namprd11.prod.outlook.com (2603:10b6:a03:4e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Fri, 20 Feb
 2026 00:40:14 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.010; Fri, 20 Feb 2026
 00:40:13 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 03/24] coco/tdx-host: Expose TDX Module version
Thread-Topic: [PATCH v4 03/24] coco/tdx-host: Expose TDX Module version
Thread-Index: AQHcnCz4ZiVFmLmZwkuE/IZIhNL+V7WKypaA
Date: Fri, 20 Feb 2026 00:40:13 +0000
Message-ID: <3a8feb5470bd964e421969918b5553259abdd493.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-4-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-4-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|SJ0PR11MB7703:EE_
x-ms-office365-filtering-correlation-id: 673ea665-73d8-4907-e70d-08de70189c5b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?L3pieVZqVm11VkYyc2toeng4TDdpOHh0NUE3eUlCaXdnYmU5K1NxbmNXaHpK?=
 =?utf-8?B?dEF4aVN2bmQyWWtTQ3VyOTViTlNmbm53LzFRbjFNTktObWJSYlVZaitpOG9C?=
 =?utf-8?B?dzJZblJ4Y0g5VUpjRVlpNkR3T0tBNzc4NXpJeEIzTExyb1BUN2ZuaGhFTzN2?=
 =?utf-8?B?WGZydzFYbm4wWWdONGhoQzNUL1hHQThzWGpDVUhMLzZ2RXM4dkw0VEJjMzZm?=
 =?utf-8?B?aTFFVTNCbnVWcFVKWXpReXA4VXNBTmpqNUdCZ3ZqNXBzRTNwUFZUaGp6VFJO?=
 =?utf-8?B?UXF2djFMU1p2QjNyazdnTlUzdSs2OHREWGU1YVo4bi90Z0FUWjY5d3NmaXlS?=
 =?utf-8?B?OTF0VHh5VFdKblNOUm9WOG9hRm1UNVZTWWNKNld3WVRISHpOeGdUbUdHcHJQ?=
 =?utf-8?B?Zlp1ZXdnUVUrY2lNb1NCWmJ3bDlIeUorUTIvYXNPbFQzeExrUWpyOFk0QmJz?=
 =?utf-8?B?cE4yc3Q1VXNEeVBlKzRKcjFMMjl2WWRkc29rb2Y2Z1BmYU5ydFBOZGJxZmpI?=
 =?utf-8?B?alV4bkxRMUQ0ekE2S2dkK2F0Y01FMlFXQ0dkK1N6eXpZM1V4Yk9WR1lucXBy?=
 =?utf-8?B?bEkreXEreGpXc202Y2hRV0w3aFpZMituRWNSNVFSRjE0YVM4bWhEaTFzUkZ4?=
 =?utf-8?B?bjZjSDMzWVBjaGF3ZThNYzBCbVNSWEw4K0k2MEhIeW9wc0FNU1RidjlWUGww?=
 =?utf-8?B?RUU2WllIWW5pTDhFNk0zb29UTFBzVTQzcFJjejFWekFUd013a1NiS2h5U3hC?=
 =?utf-8?B?UTFhaXdVZGZKaFZxMjZidXl5b2d4bzJUOUNnZkdGY1V1QnVxV2pqWnZkbGZq?=
 =?utf-8?B?NzFHRzdpVUhPNGd1dEQ0WG0wdFdKVnZ2RUt0dk02R2tpZlFobENKWERpUWlY?=
 =?utf-8?B?ZXBwT0JTaDAwU2JRMXVEd0hVanREZ24xdm9ZeEQrckV6WkdSSlhVQjF3bzNQ?=
 =?utf-8?B?ZWk5RkdlTGhiNnUrUkUvakt1K0RaZ0JsWHlmRnhTMWduN1VXU3duRFE1eXRH?=
 =?utf-8?B?UU9lY2lCUHBxL1JHdkh2cCsxQStCbzAyaWtmK1ZnNE9pL3ZzcDhsN1hoTStN?=
 =?utf-8?B?SW1tRFREZ3BzMklBZUhjc3d6Wlgxa21kNjliakVLZSsybjBLVXFnT2kzTEZj?=
 =?utf-8?B?K2d1U2pGYW1aVzRvditFUCswejZieVNtUm1peVhYSjI4YjYrYU9takpvSEZV?=
 =?utf-8?B?a25oVjBTRTcyWDdkRjhqWXZNN1JsTG9ZQndqYWFha2JSeHRzbi82UndnOVZG?=
 =?utf-8?B?RWpVaG1YellSd3Y3NllRWE9NQXlDTFhBcVVVVUh6cDdOakxJc3J6ZUxiNFZs?=
 =?utf-8?B?ZjhRaWFXM2lFZ3l1cTlLb2phaVBYdFNqZDNQL0xQcWZHMFRGR3YxNVM4Z1Iy?=
 =?utf-8?B?QklYNTJvcHAvQ2dIdHF0WjJXcGJNZktuK015dWh1Y3hhUFAzTE5abHg4Y2s5?=
 =?utf-8?B?T0tPMS9qM0FKaHk2c1duZzVnS2FzbnJYK053clkrcGMwaHJiSW90azIwK0t4?=
 =?utf-8?B?cjlpVlRPcDM1VjdmenRweDNzdEZlRHJoa2VsVEVscWVXTE1sOFYrUWxWMEI5?=
 =?utf-8?B?SGlJcXl5SHgzNVVyTU5uYTBqK28vdnQxNzYyRDYvRkpmTHU2cWllYlVGMnJn?=
 =?utf-8?B?eUw5aldNd2pkb0Z3YUpxMVFjUm5JT1hyVnFnd1gyOE52M0tzSG5NeHR0Ync4?=
 =?utf-8?B?ZjJya0hHZTRZWEpLL3h2b3NlTWthQ3ByRUN3eEdGcUx2dkUyOWFWUC9nUEpE?=
 =?utf-8?B?WEVyS1VpVTNCVDExdzlvUjFWa1NIS01pZWtpSmVoVVFFWXpoWFRBV2J5cGtW?=
 =?utf-8?B?VUhseVo3d1g3Qm1lMUNSalJaSFFJaXhwekVpK3Q2Snd6d3dRTnk3b3hIN0RW?=
 =?utf-8?B?TTh0NnE1NTNsTUJKUXBWNzl6NDRNN2d4Unkxb3BzbGt2L3dwSHhteWxIeXF4?=
 =?utf-8?B?SUx2RTVwaUk0N0t6K1I5R2xCbytnU2xzVXdqRVdYdG95bUtxd3l5WFFPNS9N?=
 =?utf-8?B?VEMwQ3VwQWxDTkhKVjFQMmtzWDkwdzdhRjByNnlvUUZSS1ZUbjRJSTNac2M1?=
 =?utf-8?B?TEhlRDljUTFVOFBoQ3U5c09RcFFmN0dNeER1MVNFUXhiVk44UlZLUXR4bnox?=
 =?utf-8?B?bkxDWjVjSzI1Y1FhNWduMVdya2crTGFUWU1BMnUxU1JVL243RldVWFRrV0dG?=
 =?utf-8?Q?FHuCyv8WASzEieFf+/Jwt0c=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dDVWL3VXajFwZEswclNvY09WNDdDT0JEZHRESUlxZ3F2UDltbG8wTjBxdUdY?=
 =?utf-8?B?OFFQdGtsN29NTHZTaHRzSHp4bWI4K09CcXlpTEhhd0ZqRFJDc3FZQ3BGSlhW?=
 =?utf-8?B?ZFIyaUdzcWFSNkN2aHFFMWRyd3RyR214OE5PUDh4ZllpUWRuVGg0VmgyL2ZD?=
 =?utf-8?B?NEZsdys3TE9TaEl4RWVxdS9YMUQwRWg3ZGJVQlJEQzVlMUZFMzBIaTdkamt2?=
 =?utf-8?B?elhSRm9TSEdRZnFKbXRsUDNaLzRmbURwaGtwVU5keWJNaVp1WERhOGorbXFR?=
 =?utf-8?B?RDl3dzhyamNYSTI5VE1TTTZoL0kxRXN3NWJHNFlUTmV6S0FUalcxanJmcGJE?=
 =?utf-8?B?bkVIZ2RnOUNtNTZYY0crRW5rdWVnYW1iOXdvMUdjY0Z6NzhTV1VsNWlKd3JV?=
 =?utf-8?B?VXdVWUt2WjQ5a0VFT3JDd2FYclo1SzFNakNYVUFOWHYvSDdiNjBsUHpUUGY3?=
 =?utf-8?B?VVVlWUVUK0R2dm1wYmtORUwzYlNxbnZwL3AyeExwd1RMR1I5QjlNVmZKZ2cz?=
 =?utf-8?B?T2JrZlNYaGpITVcya3NnZ1JTNS9KTEFZWnY0eFBDcXlwV3pFbGI0dnpPMDlH?=
 =?utf-8?B?TWNpQXNwaU9sb3hweXlURXZ0dER3YnNONkt4T0o2S1VOUWE2bXN1ZS9YUG1Q?=
 =?utf-8?B?MlU0SUZIN3A2WEdSbmF4Mjhoak1HMTNKSWhReE5TNjU4ZWYzRGRQelVnNkV2?=
 =?utf-8?B?WmlkOTBaZ1NIWHhvSnlnRXdzUVhhZnF2ZEVXaWFRbkt4eVdmYU9RK1hvZkk3?=
 =?utf-8?B?M09DNGx4UEtNV0VkR0o4TDcrMm9CeEN6cGlmS3dQeGpVdW5JbmdabkFkK3BH?=
 =?utf-8?B?RldMQWRtM2hvelpvS2tML0hMN1VFWnY0UHlpUDNYS3VrR3g0cHN2a2luOEVD?=
 =?utf-8?B?c3Zwc3VHemF1MGY0MXJFUGFqdjU5Q1pRcmc2WE10UStQS0NublB0dUl0c0JN?=
 =?utf-8?B?bEVNRkZ4OTNHUHdmUDRoSXNRTjhib0dVUHpJOGFobGRZakFZWTd3OWlpUGlW?=
 =?utf-8?B?Mm8rYkpBRkY0SlQrQ2RoV2ZCVHc0MmJOVEg4L08yRk1wZWZGSEJacmljdk5S?=
 =?utf-8?B?QXZoeEQ4M3ZZaGJtYWwwMUE2MVlOSitQMGxINlZ1M2I5a0VTQW0veFZsaDVi?=
 =?utf-8?B?WGRjTDVOd2lqNGxOZFdLamVmT0doNENNSkhvWjBlSnh3bTVQM1dkdUVzRVYy?=
 =?utf-8?B?UFozTUp5blRPL3hwQW9uTis4YTRiMStrK0ZZRXdDOVdxTnh3OFZETmFoRDNs?=
 =?utf-8?B?UHNOUW55N0RqcjZVNUlEZzcxczdkS3lzeERUVFpLeE1ZVUEvdXlaUitNa1I4?=
 =?utf-8?B?NXJHZU1VdS85d056cVB4cnFmTzYxSjJCS0hMbDhxekVZaHpYb1J1RktNdVZa?=
 =?utf-8?B?UkdoeTdoblExOVJPWmtubG5mTUJCeG02QXFyUHRGMThZakRXc3FMZS84azI0?=
 =?utf-8?B?RDVQMi9CYW5vV0NNVjk2NE1kMVBmSDhTS3BOSDc1OTdFTGZEQlcyaHdxZ1Jw?=
 =?utf-8?B?WXpUSE13a091WVV4QUNHdTVNbGlLUVRrWmpvNnd6Z1cyRFMxNzdOMDNlbGl5?=
 =?utf-8?B?cnlBb09NVUtzVDg4MUZZeVVZcUNHaExUTHBHRitTVmh2QVNERkNQb0VnMS9N?=
 =?utf-8?B?SHZJOVlpVDFidlpaYyttTFNFSk4rZFJlVWF0eTV6YTNGTzU4SzFzVmVtUnky?=
 =?utf-8?B?ZUE2Y0lFMHNMcWFTaHFpeHplVWlGdFlGeTVkREgvUEllcFFZelBnQXlCK3JK?=
 =?utf-8?B?b05kVHgwaXI4cTlHaGdILzVBbTJnWjFXNFEwUlNTck5LditqaEQyQTZCeXBT?=
 =?utf-8?B?WEZ2SEtnVUZWZTRIMFhnOFUyK0tMR2lXd3p3ZE5KTTZ5T2RSU3ZVTDVlNDRD?=
 =?utf-8?B?azNLSk10VFBXVnF5QXBFK1NDeW1yM0Z4MGtOckpaRG1tWGp0MzNIdTZ5dHFw?=
 =?utf-8?B?N1ppNnNnQVB0TGRXV3Vqb2FEeUNUUFZ2MVg0Z2drUjA3MnpIc3l3bkRDUCtE?=
 =?utf-8?B?VGxNUkVhbmRrTkhITUFzMFdyaFZOUE94alJlQXFEakdsRE9rOGNzYS9sRTJE?=
 =?utf-8?B?OUxBa2hzd2NsOE94NmdnRXJBOC8wOWtkT1QxTzRrZW53cTlkMkpPaUFXOU53?=
 =?utf-8?B?TVlwN1ZFaGxxYmZTa0lveFdpbVVQQkZ5MmVHODNVWUJITWNkQ21BWHY4cCsv?=
 =?utf-8?B?ZHN6Y0Q3VFNZQkZQNnM5b2p3ZEpNMENOZ2NZeGwxd0hHQ3NoT0ZudTdzeUdx?=
 =?utf-8?B?Wi9jM2FURUNqbmNKWExHR1RKbGEzdFZtb0lmM3VqT1ZvbDNXNUxQcnk1aU9i?=
 =?utf-8?B?TWR3Nmp2clptd0tqZStjdlgvYVQ1NnQ0cm1pVmtXUTRnek5RQ1FKZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62E36E80BBB37C44B66BDA9269D06C0F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 673ea665-73d8-4907-e70d-08de70189c5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2026 00:40:13.7562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hvpWMOhaDY0MWRySz1BypyX426Rrm9a+6jANYAH+SWaynQ7IMzigyGVRBaNiw+hfqPZuqZSasYlbyXcp1bXlWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7703
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71373-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,intel.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 5CDE8163E46
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAyLTEyIGF0IDA2OjM1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gRm9y
IFREWCBNb2R1bGUgdXBkYXRlcywgdXNlcnNwYWNlIG5lZWRzIHRvIHNlbGVjdCBjb21wYXRpYmxl
IHVwZGF0ZQ0KPiB2ZXJzaW9ucyBiYXNlZCBvbiB0aGUgY3VycmVudCBtb2R1bGUgdmVyc2lvbi4g
VGhpcyBkZXNpZ24gZGVsZWdhdGVzDQo+IG1vZHVsZSBzZWxlY3Rpb24gY29tcGxleGl0eSB0byB1
c2Vyc3BhY2UgYmVjYXVzZSBURFggTW9kdWxlIHVwZGF0ZQ0KPiBwb2xpY2llcyBhcmUgY29tcGxl
eCBhbmQgdmVyc2lvbiBzZXJpZXMgYXJlIHBsYXRmb3JtLXNwZWNpZmljLg0KPiANCj4gRm9yIGV4
YW1wbGUsIHRoZSAxLjUueCBzZXJpZXMgaXMgZm9yIGNlcnRhaW4gcGxhdGZvcm0gZ2VuZXJhdGlv
bnMsIHdoaWxlDQo+IHRoZSAyLjAueCBzZXJpZXMgaXMgaW50ZW5kZWQgZm9yIG90aGVycy4gQW5k
IFREWCBNb2R1bGUgMS41LnggbWF5IGJlDQo+IHVwZGF0ZWQgdG8gMS41LnkgYnV0IG5vdCB0byAx
LjUueSsxLg0KPiANCj4gRXhwb3NlIHRoZSBURFggTW9kdWxlIHZlcnNpb24gdG8gdXNlcnNwYWNl
IHZpYSBzeXNmcyB0byBhaWQgbW9kdWxlDQo+IHNlbGVjdGlvbi4gU2luY2UgdGhlIFREWCBmYXV4
IGRldmljZSB3aWxsIGRyaXZlIG1vZHVsZSB1cGRhdGVzLCBleHBvc2UNCj4gdGhlIHZlcnNpb24g
YXMgaXRzIGF0dHJpYnV0ZS4NCj4gDQo+IE9uZSBib251cyBvZiBleHBvc2luZyBURFggTW9kdWxl
IHZlcnNpb24gdmlhIHN5c2ZzIGlzOiBURFggTW9kdWxlDQo+IHZlcnNpb24gaW5mb3JtYXRpb24g
cmVtYWlucyBhdmFpbGFibGUgZXZlbiBhZnRlciBkbWVzZyBsb2dzIGFyZSBjbGVhcmVkLg0KPiAN
Cj4gPT0gQmFja2dyb3VuZCA9PQ0KPiANCj4gVGhlICJmYXV4IGRldmljZSArIGRldmljZSBhdHRy
aWJ1dGUiIGFwcHJvYWNoIGNvbXBhcmVzIHRvIG90aGVyIHVwZGF0ZQ0KPiBtZWNoYW5pc21zIGFz
IGZvbGxvd3M6DQoNClRoaXMgImZhdXggZGV2aWNlICsgZGV2aWNlIGF0dHJpYnV0ZSIgYXBwcm9h
Y2ggc2VlbXMgdG8gYmUgYSB3aWRlciBkZXNpZ24NCmNob2ljZSBpbnN0ZWFkIG9mIGhvdyB0byBl
eHBvc2UgbW9kdWxlIHZlcnNpb24gKHdoaWNoIGlzIHRoZSBzY29wZSBvZiB0aGlzDQpwYXRjaCku
ICBPdmVyYWxsLCBzaG91bGRuJ3QgdGhpcyBiZSBpbiB0aGUgY2hhbmdlbG9nIG9mIHRoZSBwcmV2
aW91cyBwYXRjaA0Kd2hpY2ggYWN0dWFsbHkgaW50cm9kdWNlcyAiZmF1eCBkZXZpY2UiIChhbGJl
aXQgbm8gYXR0cmlidXRlIGlzIGludHJvZHVjZWQNCmluIHRoYXQgcGF0Y2gpPw0KIA0KPiANCj4g
MS4gQU1EIFNFViBsZXZlcmFnZXMgYW4gZXhpc3RpbmcgUENJIGRldmljZSBmb3IgdGhlIFBTUCB0
byBleHBvc2UNCj4gICAgbWV0YWRhdGEuIFREWCB1c2VzIGEgZmF1eCBkZXZpY2UgYXMgaXQgZG9l
c24ndCBoYXZlIFBDSSBkZXZpY2UNCj4gICAgaW4gaXRzIGFyY2hpdGVjdHVyZS4NCg0KRS5nLiwg
dGhpcyBzb3VuZHMgdG8ganVzdGlmeSAid2h5IHRvIHVzZSBmYXV4IGRldmljZSBmb3IgVERYIiwg
YnV0IG5vdCAidG8NCmV4cG9zZSBtb2R1bGUgdmVyc2lvbiB2aWEgZmF1eCBkZXZpY2UgYXR0cmli
dXRlcyIuDQoNCj4gDQo+IDIuIE1pY3JvY29kZSB1c2VzIHBlci1DUFUgdmlydHVhbCBkZXZpY2Vz
IHRvIHJlcG9ydCBtaWNyb2NvZGUgcmV2aXNpb25zDQo+ICAgIGJlY2F1c2UgQ1BVcyBjYW4gaGF2
ZSBkaWZmZXJlbnQgcmV2aXNpb25zLiBCdXQsIHRoZXJlIGlzIG9ubHkgYQ0KPiAgICBzaW5nbGUg
VERYIE1vZHVsZSwgc28gZXhwb3NpbmcgdGhlIFREWCBNb2R1bGUgdmVyc2lvbiB0aHJvdWdoIGEg
Z2xvYmFsDQo+ICAgIFREWCBmYXV4IGRldmljZSBpcyBhcHByb3ByaWF0ZQ0KDQpUaGlzIGlzIHJl
bGF0ZWQgdG8gZXhwb3NpbmcgbW9kdWxlIHZlcnNpb24sIGJ1dCB0byBtZSAidGhlcmUncyBvbmx5
IGEgc2luZ2xlDQpURFggbW9kdWxlIiBpcyBhbHNvIG1vcmUgbGlrZSBhIGp1c3RpZmljYXRpb24g
dG8gdXNlICJvbmUgZmF1eCBkZXZpY2UiLA0Kd2hpY2ggc2hvdWxkIGJlbG9uZyB0byBjaGFuZ2Vs
b2cgb2YgcHJldmlvdXMgcGF0Y2ggdG9vLg0KDQpXaXRoICJ0aGVyZSdzIG9ubHkgYSBzaW5nbGUg
VERYIG1vZHVsZSIgYmVpbmcgc2FpZCBpbiBwcmV2aW91cyBwYXRjaA0KY2hhbmdlbG9nLCBJIHRo
aW5rIHdlIGNhbiBzYWZlbHkgZGVkdWNlIHRoYXQgdGhlcmUncyBvbmx5ICJvbmUgbW9kdWxlDQp2
ZXJzaW9uIiBidXQgbm90IHBlci1jcHUgKHRodXMgSSBkb24ndCB0aGluayB3ZSBldmVuIG5lZWQg
dG8gY2FsbCB0aGlzIG91dA0KaW4gX3RoaXNfIHBhdGNoKS4NCg0KPiANCj4gMy4gQVJNJ3MgQ0NB
IGltcGxlbWVudGF0aW9uIGlzbid0IGluLXRyZWUgeWV0LCBidXQgd2lsbCBsaWtlbHkgZm9sbG93
IGENCj4gICAgc2ltaWxhciBmYXV4IGRldmljZSBhcHByb2FjaCBbMV0sIHRob3VnaCBpdCdzIHVu
Y2xlYXIgd2hldGhlciB0aGV5IG5lZWQNCj4gICAgdG8gZXhwb3NlIGZpcm13YXJlIHZlcnNpb24g
aW5mb3JtYXRpb24NCg0KQWdhaW4sIEkgZG9uJ3QgZmVlbCAiZm9sbG93IGEgc2ltaWxhciBmYXV4
IGRldmljZSBhcHByb2FjaCIgZm9yIEFSTSBDQ0ENCnNob3VsZCBiZSBhIGp1c3RpZmljYXRpb24g
b2YgImV4cG9zaW5nIG1vZHVsZSB2ZXJzaW9uIHZpYSBmYXV4IGF0dHJpYnV0ZXMiLg0KSXQgc2hv
dWxkIGJlIGEganVzdGlmaWNhdGlvbiBvZiAidXNpbmcgZmF1eCBkZXZpY2UgZm9yIFREWCIuDQoN
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IENoYW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+IFJl
dmlld2VkLWJ5OiBCaW5iaW4gV3UgPGJpbmJpbi53dUBsaW51eC5pbnRlbC5jb20+DQo+IFJldmll
d2VkLWJ5OiBUb255IExpbmRncmVuIDx0b255LmxpbmRncmVuQGxpbnV4LmludGVsLmNvbT4NCj4g
UmV2aWV3ZWQtYnk6IFh1IFlpbHVuIDx5aWx1bi54dUBsaW51eC5pbnRlbC5jb20+DQo+IExpbms6
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDI1MDczMDM1LWJ1bGdpbmVzcy1yZW1hdGNo
LWI5MmVAZ3JlZ2toLyAjIFsxXQ0KPiANCg0KWy4uLl0NCg0KPiArRGVzY3JpcHRpb246CShSTykg
UmVwb3J0IHRoZSB2ZXJzaW9uIG9mIHRoZSBsb2FkZWQgVERYIE1vZHVsZS4gVGhlIFREWCBNb2R1
bGUNCj4gKwkJdmVyc2lvbiBpcyBmb3JtYXR0ZWQgYXMgeC55LnosIHdoZXJlICJ4IiBpcyB0aGUg
bWFqb3IgdmVyc2lvbiwNCj4gKwkJInkiIGlzIHRoZSBtaW5vciB2ZXJzaW9uIGFuZCAieiIgaXMg
dGhlIHVwZGF0ZSB2ZXJzaW9uLiBWZXJzaW9ucw0KPiArCQlhcmUgdXNlZCBmb3IgYnVnIHJlcG9y
dGluZywgVERYIE1vZHVsZSB1cGRhdGVzIGFuZCBldGMuDQoJCQkJCQkJICAgICAgIF4NCg0KTml0
OiBObyBuZWVkIHRvIHVzZSAiYW5kIiBiZWZvcmUgImV0YyIuDQoNCkNvbnN1bHRpbmcgZ29vZ2xl
Og0KDQogIE5vLCBpdCBpcyBub3QgY29ycmVjdCB0byBzYXkgb3Igd3JpdGUgImFuZCBldGMuIiBC
ZWNhdXNlIGV0Yy4gaXMgYW7CoA0KICBhYmJyZXZpYXRpb24gZm9yIHRoZSBMYXRpbiBwaHJhc2Ug
ZXQgY2V0ZXJhLCB3aGljaCB0cmFuc2xhdGVzIHRvICJhbmQNCiAgb3RoZXIgdGhpbmdzIiBvciAi
YW5kIHRoZSByZXN0LCIgaW5jbHVkaW5nICJhbmQiIG1ha2VzIHRoZSBwaHJhc2XCoA0KICByZWR1
bmRhbnQuIFVzaW5nICJhbmQgZXRjLiIgaXMgZXF1aXZhbGVudCB0byBzYXlpbmcgImFuZCBhbmQg
dGhlIHJlc3QiLg0KDQoNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlydC9jb2NvL3RkeC1ob3N0
L3RkeC1ob3N0LmMgYi9kcml2ZXJzL3ZpcnQvY29jby90ZHgtaG9zdC90ZHgtaG9zdC5jDQo+IGlu
ZGV4IGM3Nzg4NTM5MmIwOS4uMDQyNDkzM2IyNTYwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Zp
cnQvY29jby90ZHgtaG9zdC90ZHgtaG9zdC5jDQo+ICsrKyBiL2RyaXZlcnMvdmlydC9jb2NvL3Rk
eC1ob3N0L3RkeC1ob3N0LmMNCj4gDQoNClsuLi5dDQoNClRoZSBhY3R1YWwgY29kZSBMR1RNLg0K

