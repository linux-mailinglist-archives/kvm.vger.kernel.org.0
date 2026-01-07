Return-Path: <kvm+bounces-67226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B515ACFE6A6
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 15:54:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2EADF3018402
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 14:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0239E34D3AB;
	Wed,  7 Jan 2026 14:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iyAI4UbZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12E234D39C;
	Wed,  7 Jan 2026 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767796910; cv=fail; b=hHu0KIPPJLc+96IyYAgeSVyEnYvLIC8X1/782osDPTS8J4MjNpu6UEzd03k7uvCfztga2eb5qRblpohVK4dwBrRiXG7oglwxjHoih+Ma4w65sDL+pOIQwhaF/zpdfAm1n672OLKtb2jw/pRyu4dmj/P5og424NEKCO2ebAz8T+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767796910; c=relaxed/simple;
	bh=MzQwPxEWxW9LfMZfNa0tgl7KZKjf7Iuy767JylgY7pA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kR0HF8V+Nng/uXDfpxhCnovQ3eoSx4g8I8xOmXd0xaDkyEmtBFTXw+5Rcrbar0jDoDPkod9Fj2sdyRyRj6W8xJm5nTs9n3pkJqmuOjNN+fAE1Fkf3mTpxg1qzaP1pxMv+vIGG9zSnAKTJZ+dv6dmdrcpBSV2BNBPMy5pjcFTt2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iyAI4UbZ; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767796909; x=1799332909;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MzQwPxEWxW9LfMZfNa0tgl7KZKjf7Iuy767JylgY7pA=;
  b=iyAI4UbZDsz3v4RNoSvXW57epuefT8gyLCAFJWQ8lKKHWWUBX+Mltpe+
   2PM6jL+i99yMe5pdsskkikAp3UKw2Vkk+jjZaQhzzQH6kZY3i1yrDJkKS
   +KZLjNt68QlXBFudZ14wpQXdTRH/4kQMEuy+fe41L6Mf08uWe0/Z0xQpy
   tXr9/8MHROJMWvVYkd5QE2c2/6defu4CgqkrQuzd6oLDUr53LNw+3qSvg
   plyhVy7cDjvYmnELdGa3SscOzm09FlK55RviuJOWm0atk0hZ0BrUZ1xn3
   anSm8ku9u7M9xEmT3QEDpKG+FcyU/Cxo4eVEWEwzdZQk6u1xIZczCO97W
   w==;
X-CSE-ConnectionGUID: e163tXzEReu9Xru/V4P2aA==
X-CSE-MsgGUID: 9vLE7jDUQ36RuDRMZjJe7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91824084"
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="91824084"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 06:41:48 -0800
X-CSE-ConnectionGUID: Tyuh0DsNSpmHJnzoQvR54Q==
X-CSE-MsgGUID: /e+C99T6TE6upKwm2aYY7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="202851888"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 06:41:48 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 06:41:47 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 06:41:47 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.15) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 06:41:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YYdFfd8bCjiaV7ZA+9wUKGa/WW1/APGFbM7LjMRFzGrU1oVD8JbRLt2lP4vE2A/9SfUAXmGe0//GOA5eHlBSnCXfSUq1sxCEiWzgOcZU+ukzrjY5zoQAA08owfna2c5mlVD7Dz9JF3gUSKkinvWCrC95P14/VPnD21aKFNzMQFtuAmf2+SFdbvwwTPija+Qa0lvn44JHNoNovIRo4d+7OMSOlX+wtaeDdiiwHXtpoaZeNg+ARcC8Rly+Wngv2Jg1RBJOk5me6zlaRcALZwFB3NSBUhHE1ALHdpWT7S1t7G8qx2PHIWzdm7L9pi9AWAn6JAPCGVZmElXibJTE333BEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MzQwPxEWxW9LfMZfNa0tgl7KZKjf7Iuy767JylgY7pA=;
 b=em6btMkO45kuixPzERiA8nsf9+NEYB7YVy7rU7Z/As5ZM3klI9MikQgZCRQjdCmIh7A0fz89RoF94uUl6GAHo34FZVHW2WpdhA93lkzyNQeBQ4w5CJdG5FbG5Ve2uTmORiTp9zNqQL2oSYY26GY1LP3gxWMEbzEY7zttBVYfYsPbjBCIylcmLEPQbNGMnYOstQgNd5WA155hmakhmv4MhYuQbXT2y9vXewelBocu6AnGNWbhQmu3/WByxFy9YLE0tsN/fRYY74auWeVBHvdb5jQjurIoUqXm2JovIq6o+WH4/zaoACiKrx97nVwHns04rhTdw2pDbdmMkJRodzGH4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB5263.namprd11.prod.outlook.com (2603:10b6:5:38a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 14:41:44 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 14:41:44 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Topic: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Index: AQHcWoEG0U6tpU/nuka5qLmVaBAkzLUwtToAgBO02gCAAGMxgIAA2fqAgADZ3wCAAJGaAA==
Date: Wed, 7 Jan 2026 14:41:44 +0000
Message-ID: <44fb20f8cfaa732eb34c3f5d3a3ff0c22c713939.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-5-rick.p.edgecombe@intel.com>
	 <aUut+PYnX3jrSO0i@yilunxu-OptiPlex-7050>
	 <0734a6cc7da3d210f403fdf3e0461ffba6b0aea0.camel@intel.com>
	 <aVyJG+vh9r/ZMmOG@yilunxu-OptiPlex-7050>
	 <94b619208022ee29812d871eeacab4f979e51d85.camel@intel.com>
	 <aV32uDSqEDOgYp6L@yilunxu-OptiPlex-7050>
In-Reply-To: <aV32uDSqEDOgYp6L@yilunxu-OptiPlex-7050>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB5263:EE_
x-ms-office365-filtering-correlation-id: dcd045dd-638d-47d8-fb44-08de4dfae0d0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SWtveUNDdmhJZ2J4dVVaMG1tOEpjYnM3QWdUeXBvRU1tQkFXQ1ZIMWg1TFlM?=
 =?utf-8?B?WEVvZ2RGK2JlWjc0bUFFcTNCNGxPZVpzNzJvSHJCNVozTHFTUXZnQ0trR2hx?=
 =?utf-8?B?clB1cGJaN2QrNG9STHNMSE5uVWZWWk1oY0NnN0JnUG5FMTBNSW8vWlJkaWp6?=
 =?utf-8?B?WG9zdk5JWW5FeGtQdEoxajhPcWVwZS92RXZiMEZSRDlzMDZ2NmdpQ0M0UHNO?=
 =?utf-8?B?RG44bWU2aHN3cGV6M08yVldDUTZ4MTZWdG9iVWkrR21Zd0RtRFIxMGZoT3JH?=
 =?utf-8?B?dVBldUpzZUxRSU45YVdPYm5LblpkT3QxY0J4K0tnQ2xxMDQ2Y1g1NmxkZWdp?=
 =?utf-8?B?Mmw5dEY5eVlYSndKamdPemtoQkg2bzlrMVBtQUl3WmhXVnlSUmhHVGZWenhJ?=
 =?utf-8?B?RENpcVhqcEtCbG1GTkQ1cm5wYjJuUjNvYkhTMzc0cTVNeEJOOWxxYS95bVFP?=
 =?utf-8?B?V3Q1QmZPa1pjc0tqekxsM0RtSCtDMDh0TGlxb3Z6QWwvNU5TMGhCU3Bod3BC?=
 =?utf-8?B?Z09LUmNMU1N5YlFVcVlDREtRSGpyT21qQjk2ODVrYzkrbTQ3SlVPdUIwWTFm?=
 =?utf-8?B?YmVDanFTRXBTL1Y0cTB0cEJCeG9mUUxwdWdCTldMVTg1NHdNR2d4YTRaSktk?=
 =?utf-8?B?RWhpMmtpL0NzVWkrVzMvREg5TDhVL1NHVVJrdXZXckZEcFZuZi9ZdW1BZzRR?=
 =?utf-8?B?dTc5OUFNMll6Z29Fa3g1Q0p2dlRaeHZXYWU0UHNra29uZFlxRk5KSFhVRkRk?=
 =?utf-8?B?SzBGQUV3c3JuWkRwdkhoS1JtVnJmWTE2VFBYdTNXRU90eVE5dkxCaHZ4T0lL?=
 =?utf-8?B?eTJGckw2ekkycFc2STlFK3NDUy9qY3IrcUZwY2MyMm5VMFFrMERLOWZYNndB?=
 =?utf-8?B?ZzUwVld4cmFKaTIxUEF1aXZCOUsyS2hSWmRHQStBTU9URksvbi9PQmozaVVO?=
 =?utf-8?B?L0ZQTjR1bU9BNkFMTFVicUFoaTVVTjkxM0ZuMUlNemF3bTJOUGo1ekV4ODM4?=
 =?utf-8?B?cGMwMnE1ODduVFZUTGdlaVFaVzVQYjM5dTkwTWhBVHFvK244RHVtblpuQnpC?=
 =?utf-8?B?a1BaSXdpbHl3RGpoV3BWdjZDK0c0OWdrVmxTMmpxbmlwRFhiVkZvNU9JL1Yr?=
 =?utf-8?B?eDYwUW1rdjhscVVvTHVPZ2lSS1loRUlJUEk1OWVtMmJmOFliWWo5UTJkNEQz?=
 =?utf-8?B?UmgweHNjU3FJVlJ6R21oZVloK29Dd2tYYlFPb0JvS2pyd2lPYjhqZXlKRkg4?=
 =?utf-8?B?WjFzc1JFQ0orWllJTUxFOG5SUzFDQ3hLZWd6UndmNUNadHdDK1p2VDlkM1lV?=
 =?utf-8?B?YUtKR0t2MjBuNVN2S1FJTmhIVzRPS1BLZXFrL3YxY1YxZ242NzdQVWs4cnI4?=
 =?utf-8?B?L2EwbXBuSk5vWExjc0NTeWp2STduV0Qwc29xSVYrNEpONGVVaE12UXpqMC96?=
 =?utf-8?B?WWNxL1RxV2lLN0pCejNHNnZteVA5Wk4zOEZTTUdJZVNyeEFHbkJlRS9qOXh2?=
 =?utf-8?B?aFp0ZEJTREhkMm52VkhNMXhSSlpIZGdRdVJrT3grQ1Z0SFpicHZVTDhvUnB1?=
 =?utf-8?B?KzdCVVUvYllrNC9SVytaTitOQThRWmlQcXhYelZVMzdKZmxhZTBhZ2wyTkYx?=
 =?utf-8?B?ZWJKeUVTc09CYzZYQnA5Szc5YjllSHcxRVZsbWhkWWQ4clhIWTZsNks3NUQz?=
 =?utf-8?B?ME9wNTBKYXdNdVdCb3dpNjRjZTJyWnp3N1FKaGNSQXpCTVYva1dSYU9ydTc1?=
 =?utf-8?B?UUhTdzhaOVpQOGdXRDhKZVhBZzQzVzV3bnVmVWlPRG9tazVxQVFaek5xS1VU?=
 =?utf-8?B?Y09Bb05jNlVBWTVjeUM4T3pHZUJZM3ovMGZ4VklWN3ExNFdiWnFzbFhTdlN3?=
 =?utf-8?B?TjhSMmFwMW5LMWJRL2U3K1ZiOWNzTFh6cDdxNHB4YTdudU9yTFVhZUpEN243?=
 =?utf-8?B?SU5GczNSaFlOSk1OdUppUnJGMWs4TWZjZjNKMklhSVozT0VRYjFEbEFNNDNX?=
 =?utf-8?B?Nm4xbXNCUURTTWhPVC8xc2E0MlhMNmhjMTc1MUNHZm5IMStXblREOVBSUGpU?=
 =?utf-8?Q?QDWUIU?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTZaTnBURW9WOWVWWU1GQlRMby9xem15SFRpMGxNeHNxVWt5aDdSZ3lXM0pn?=
 =?utf-8?B?WmkzUy9acHRoUzY4dVNaRStXOUM4aTNiWE5yeDFlUDBlUTFOTFJKTVpjQmZO?=
 =?utf-8?B?dUsrWHl1S1o3QXBGbHlWMzlUZWxNeUloZjVTN3pTaXB6MkRCZ09MUHN2d1Ja?=
 =?utf-8?B?c29zVXhRMjlLUkxHakJyU2dMWjg0ZE9DLzM1M20rekRSN0RuSTNtNXlXalNo?=
 =?utf-8?B?V0pvZkIvUnZGV25yQ3FiUXlrZ3RSK3lnZEFYdWxHcFR1enQwdU9yNmFjOFpa?=
 =?utf-8?B?c05yczFQY3EvMW5xK28yRUwyRHpqM0Z1RlRhdlBrbzIrbWRPODhnUWNzc0Zr?=
 =?utf-8?B?R3pZTU8wNmJWZExUZkg3NExETlZ0Z0VMeTNZc3loUVpiYVN2MVE1NVh1TFgv?=
 =?utf-8?B?QjRUNit4cmJhVmFQb2lmR2ZTMS9WUHlXbEVGVGVidHJCOUcvbVV1Vk9MdFRJ?=
 =?utf-8?B?cVZ4MnRvb2hySC9FRmVOWWN4OEVhQ2JZWXlnVXVlTUVTdHVTUk1uQWdzVjBi?=
 =?utf-8?B?Wi94SjNsSmJmY3pDK1M2RFpmVHVjVUsyRjE1dnYvMm9tTlRHSE9JSzRKTys1?=
 =?utf-8?B?Vys2QU1nN3FWSkF3RHYrVXNwVVoxOEpHZEttTlFaUnM4K0dySlBXNVpuVWhG?=
 =?utf-8?B?QkZCcEliektTb2ttWTNKam5qRExKOWJoVzRKdjFPZEQrdHBvVlVPcUpwTXRo?=
 =?utf-8?B?VmFHN3pvTjFkVmhhZUorb0NXN0hibWdUeWNXQUVMSFlNeFNRbEtKUlNkcVNx?=
 =?utf-8?B?TTFJUk5peC9SZGpzdkpNSC9KeUVGbXJ6U3dQN0wrM1NYRUJhTnRzWEhMMzZ3?=
 =?utf-8?B?R2Eya3RLMWczUUZHa1M1TmNkWE9wOGRDalIxNmVMaEZNU3FSNDQraXE2VC8z?=
 =?utf-8?B?UzdGMGNOdUNMc3FvR0VLY3lTcktLSXhYYm5iN3V6ZzNSMkQwZ0poakdWUGVV?=
 =?utf-8?B?Q1pWMjhLL0dmMTNMQThZeW96ZjFncG5IRmVlMUFoWUlFNTY2MFRqaGprU1k5?=
 =?utf-8?B?QUdEZTVXeXVObi9RWjhGSEhIZU1aeWVURE5meCtxVU5iVWltWnZMcEJBY2Vh?=
 =?utf-8?B?RXUyM0FVRTI3RjkxK1Z1a0w0bE1URlA5YWNjUGhEWi9pTVZEeHhVQWs3SHJN?=
 =?utf-8?B?ZzlINzFaejZmMHZkNEVSM1RuMzFoblFQOWY0eE4wVVFEWHpZS0RYUjdVZEtQ?=
 =?utf-8?B?K0tHcDJydE1QV2JRWHVDbDltQjJBZjBOZ080SVN5cDdhTHhJY2xxcUUrSmYr?=
 =?utf-8?B?RXBGWHRUdUY2L0dRZ2xwUys3WXMvZkY3WE1QWkRvSFo0d2ZqL3A0bEFlZDJ5?=
 =?utf-8?B?NXNuUGhOYlM5V0VrM21JV0JXd01LMmlwTW8vU0RZeVVGZ2pRU2ZtSDh1RVVR?=
 =?utf-8?B?anllbTlRVmgyRDNOT25OV0hNaUx2cE1lNHFkZi9BZ0t2dkNUdjZJLytmeG0w?=
 =?utf-8?B?cS9FTVQ0cit5ZnFaY1RKZ0N2Kzk1RWZEREF4ZWxFNzBDVnArK254WXI0UHVM?=
 =?utf-8?B?QkRzZnZicXpVSUJUeEhaM3Uxa3kwZUxkSlFGR3dPeWV2c0J2ai90SFEzTEVk?=
 =?utf-8?B?Y0VNNmdPbzkyeCtJR21jYmhXVUxCKy8rNUt4WUZpZlF4MUJPUEtiTGZkSHNC?=
 =?utf-8?B?UUVmeU82aE1MOGpoKzhnM3dMVU02eG5HMzZITFRVa3VJL25EekhNbEtVdk4v?=
 =?utf-8?B?R0NDNVJYZWZHcllwZ2ZXREZ0WEJqSWZEdEE5NndDZk9VTFh5NlpiL3JJQ1ZN?=
 =?utf-8?B?UzhvZW5JSHJ1Q215SWtuandoSTYwbFpZRzkxaUxPcS8xSDRjM2xlZFVtYlhD?=
 =?utf-8?B?LzVaOUNiR2ZTb3U1dVBDZUh3ZnZNeTlWeDBENkNtTGthRlhmZVU1UzRjRXVG?=
 =?utf-8?B?ekp5dUdoUnI1ZW9lNVNWeHhMNmFhWFpvMUJkNW5nMjBOUk9DS1FvMUZYVGhM?=
 =?utf-8?B?K2RESzBnTTVsL0NMcU1EVmoyc2g2OVNRRkJ2WkdHd3FhR2hpck9WTGFwWDla?=
 =?utf-8?B?anAwTEhCelYrbkpDZ0FyWUJ2T0NRdG1OMFBTd1I2Zm1XdFphc1ZpcDJsSXdC?=
 =?utf-8?B?dEZHcXhDMm5wSmpQelo4UU1TVUNuek42MnFLKzNOTVZPbWY3eS9DZVhjdHNJ?=
 =?utf-8?B?bjdjL2hYMEpqdmw3Wm02bVVlTkR3NzNaUzhBM0NRbmprY21GY1VDWjZRY2xY?=
 =?utf-8?B?aWZ0Y3pZdUNHZ1hPeVZHVlZDb1JRYnB2UlVOWmdycHBTbHBUR2NaSExzMDUz?=
 =?utf-8?B?QWFIcm4vN25RUU5JQ2lnUTVWSENTcjR4VXNDZUt5alA1NXpWN0VFMVBRdHhk?=
 =?utf-8?B?Rk1JL0NFZFRLRWhnQXBUc0ZhSFprNThTVkpDUVoxRFczYXFJVXYxRHNES05m?=
 =?utf-8?Q?cQqFr9xILInHssc4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66100057147CA84BB078C5444F608B43@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd045dd-638d-47d8-fb44-08de4dfae0d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2026 14:41:44.2112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mbr/7eLMcs62ws+wBiMLo/XlKu1zPdDZFhv1Ci+ri4xgkgywvgfMGsfqRTCsdilek+0OGh3oAQUjxAps3M2ghqqLJDdGxUtIGf1R6+Ez7FQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5263
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDE0OjAxICswODAwLCBYdSBZaWx1biB3cm90ZToNCj4gPiBJ
IGRvIHRoaW5rIHRoaXMgaXMgYSBnb29kIGFyZWEgZm9yIGNsZWFudXAsIGJ1dCBsZXQncyBub3Qg
b3ZlcmhhdWwNCj4gPiBpdA0KPiA+IGp1c3QgdG8gZ2V0IGEgc21hbGwgaW5jcmVtZW50YWwgYmVu
ZWZpdC4gSWYgd2UgbmVlZCBhIG5ldyBpbnRlcmZhY2UNCj4gPiBpbg0KPiANCj4gQWdyZWUuIEkg
ZGVmaW5pdGVseSBkb24ndCB3YW50IGEgbmV3IFREWCBtb2R1bGUgaW50ZXJmYWNlIGZvciBub3cu
DQoNCk5vLCBJIHdhcyBzdWdnZXN0aW5nIHRvIHRoaW5rIGFib3V0IGEgbmV3IFREWCBtb2R1bGUg
aW50ZXJmYWNlIGlmIHRoYXQNCmlzIHdoYXQgaXQgdGFrZXMgdG8gcmVhbGx5IHNpbXBsaWZ5IGl0
LiBGb3IgZXhhbXBsZSwgc29tZXRoaW5nIGxpa2UgYQ0KY29uc2lzdGVudCBUREguU1lTLlJEQUxM
LiBGb3IgVERYIG1vZHVsZSBjaGFuZ2VzIHRvIGJlIGF2YWlsYWJsZSBpbiB0aGUNCmZ1dHVyZSAo
Zm9yIGV4YW1wbGUgYXQgdGhlIHRpbWUgb2YgdGhlIG90aGVyIG9wdGlvbmFsIG1ldGFkYXRhKSwg
d2UNCmFjdHVhbGx5IG5lZWQgdG8gc3RhcnQgdGhlIHByb2Nlc3Mgbm93Lg0K

