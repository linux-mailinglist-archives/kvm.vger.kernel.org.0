Return-Path: <kvm+bounces-53844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8397B1846B
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 17:04:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A913E5670DC
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 15:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12AA726C399;
	Fri,  1 Aug 2025 15:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cedKcWoA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C787C78F2B;
	Fri,  1 Aug 2025 15:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754060658; cv=fail; b=JxpMGFEcbY+pK1tDqMq/mF35x28HVZsvYcmzg1Pm4p3sX0VSZG5fDJnNKqerSEWRkDO7OXpR1ScRGKe+Ikar+KSNbO2fRylOhJxkO8oQxxeW7jEQshVglCs4JhRNdzp0eIXe6V4BZ62CnrrTxRDmfvZULTV23MNL67aI+KvIS+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754060658; c=relaxed/simple;
	bh=bfm5twww5bTaCAZ497z5fab3NizD1uYKhZP+yiEnmys=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GCxHRzN5s+3q5ciALqgLJ2sAZhAEBc4ZdepPhh6ZoMcccZnxPyvYl3CxABYn3dtd2MqoVZm0rgX63+JIlAgQC9AYQ3Ig/d0O5a3WYoPSugOgYReZ4tT0//M4f0NGFIm1cy36ytroPJtS5owGrVOGI8Ih2aGiUXh6R9eAt2/XP9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cedKcWoA; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754060657; x=1785596657;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bfm5twww5bTaCAZ497z5fab3NizD1uYKhZP+yiEnmys=;
  b=cedKcWoAbqb0Ezdpy5vcYcBQ+xKe0E+dAwSblPC9vEkJ13539s6Ckbue
   HBeNlXZ1z+tlzij2o/C7/3LUQMBDaEBGknfUJqiSHjAjINunUhm46cGlL
   JrNlNc6e7PYHKQVQOReJ+u/p+scJvcTY1ZH3xCWY9OWVW2ncDk9fvTp0q
   lNjPpRTFdg08BFtKcZSsKMdj4KifetdpUBMQer2lzI5evT+Ms/Fw/mJdu
   Cg6O1GADbyX/CAr8tndERqcXFIrs0b2QvevyLMVeXqPfFfGrAl9lkDwAS
   md8m2wV5bOG2OlOLuW/8ezM8GGX4g2SwU6ddXIM+quIB9RNd9Xzs43K+F
   g==;
X-CSE-ConnectionGUID: DeImyOe9Sgaui1i/irL4RA==
X-CSE-MsgGUID: jCRXUu6hRPKAqoT11z5zSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11509"; a="56300955"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="56300955"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 08:04:15 -0700
X-CSE-ConnectionGUID: 5jE0pUlbSQOt1XAZR55atg==
X-CSE-MsgGUID: BV8mVyDyQAS16a5KR3nhTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="200748792"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 08:04:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 1 Aug 2025 08:04:15 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 1 Aug 2025 08:04:15 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.64)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 1 Aug 2025 08:04:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XRbugc6vVz2RBrSbQ+LpcbgGqff0lg8bpc6jO6EMd1Q9S5aR5PrwPK+9a/zYSibpCJ/thuCXsbkg+AeqJxZ1wP/mY6ZlojeFEbq/Qon4F+ygcY0b/ZFjDN8VZtsb9yjUib5O2NAJA1v73n2hUnz16gQWE4f/VNbSNT7OATpId0e9XYVkOhjHaZ/fsW/B4FUOJtA27EdwprXaD/bzhQejl0suMGnufK2n28665ji3OcMrS0ni3ULYES8Pwy/h6dBe/H4TMs+h6d3zGv8Yn+wpT+oiQGAGCQ0CXF6orxK6igjNiDN3sjXkcQV5vwLmeBqM/tXdWzMAfuskHPtki1fG/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bfm5twww5bTaCAZ497z5fab3NizD1uYKhZP+yiEnmys=;
 b=QAeTnMhItL28jvkdtWmNYmhuKd6SG5M8B3vKvbd9z6P8xNhztQq7blK95m3L8TAPj2inFZodqysOFDvi8c46lMiiSvoyjQuo74iRKO86c5zS6Lv4DpNM1VZORFzcQU1+ZdQ1xeh/VN9RCUVPBZhNwm5R1P4Wsx7TYpC9lBsQTMNDYOZBCrGl2CDIww+U4dKypAdyRwSqIfm0n98rDldZeLCzrBEBhVjr+q5x75qF7+w658C+Oh0mrNG3vQFxSe7gPpNcLvTkRoLKZqBc28EFZS/dJT8N8n15RsDP+nH3A4bjDMm86jORQfFJgUwqysVYwh4gJVJ+CTKstEq5052UtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.12; Fri, 1 Aug
 2025 15:03:58 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8989.011; Fri, 1 Aug 2025
 15:03:58 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "Huang, Kai"
	<kai.huang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Thread-Topic: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Thread-Index: AQHb2XKrlmf/Zzss+E+nUDEbBxD0tLQUQqeAgAAyUwCAAAf/gIAAyKeAgABZzICAABIZgIAAEweAgDWJGwCAAeXbgIAABEuAgAAB24CAAP5zAA==
Date: Fri, 1 Aug 2025 15:03:58 +0000
Message-ID: <7f1aaf559a4f93f63f8e996938cfd957e151cb50.camel@intel.com>
References: <5cfb2e09-7ecb-4144-9122-c11152b18b5e@intel.com>
	 <d897ab70d48be4508a8a9086de1ff3953041e063.camel@intel.com>
	 <aFxpuRLYA2L6Qfsi@google.com>
	 <vgk3ql5kcpmpsoxfw25hjcw4knyugszdaeqnzur6xl4qll73xy@xi7ttxlxot2r>
	 <3e55fd58-1d1c-437a-9e0a-72ac92facbb5@intel.com>
	 <aF1sjdV2UDEbAK2h@google.com>
	 <1fbdfffa-ac43-419c-8d96-c5bb1bdac73f@intel.com>
	 <70484aa1b553ca250d893f80b2687b5d915e5309.camel@intel.com>
	 <aIv8wZzs1oXDCXSU@google.com>
	 <3f39e6f85341e141f61527b3192cefde0097edb8.camel@intel.com>
	 <aIwB6X6cw9kwgJzs@google.com>
In-Reply-To: <aIwB6X6cw9kwgJzs@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB5984:EE_
x-ms-office365-filtering-correlation-id: 9ee14e9e-5dba-4a69-79b6-08ddd10ca446
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Uk51M2Fhcm9qWmo0N0NFSVg2Sm85OWtTK0loRXVXOExLVG5XUTl2UDZaSnU4?=
 =?utf-8?B?aXZMMzJmMGN6ZUhOQjV3anlNUHhMUUM3bkJ0Z085YmpjZUF4d0ViU2xNZ2xu?=
 =?utf-8?B?ZUpYMlNZdlJ4REZ3dFA1cVcrZlZoeWhud0R0ZFQ2NkRzSjVTWmpoSTNxRFBs?=
 =?utf-8?B?N2VRTU1zbHgvT0FIWHVRUHhncDlIOHhHenE3RFJhQ01Ub01NZ0NFSFliUGtQ?=
 =?utf-8?B?NnR3UUNibjZNeUZ5R2RtT294UERxRERENDUyWFRXMzBaWW1CNnJxNkF5cy9W?=
 =?utf-8?B?bXY0ZzlXZjRTMTdCNEkyaHd2Q3Z0TVRtQmdJdy9KL0RISzlFVDRQb2x3VGN6?=
 =?utf-8?B?RXNsZFJ4UlYxc0JMdGNqVkMrTm1DVnJEeVovNWNyRVpHMnBpcUpDSWZmaHZl?=
 =?utf-8?B?RjhTL2ZaTWtidFJjRXB5a2NuN3FxVXhMeWdZV0gvZURTNE1hVFByVUUrRjgv?=
 =?utf-8?B?UnhIWWlYUlozNVkrQVMwTXlJaUZkVVUrcXh4Q0o3STAvdVloT29kQ2I4Tk8z?=
 =?utf-8?B?a2lEKzNOc1ZUWkhnNXpCQnZxMmJvNkZoamVJNEdlV2pJQnV6SURvTHF6Um1t?=
 =?utf-8?B?TEhQN0hSR3pzU1dPTHpuQ00wTlZjald3ZjQ4TTVKdFVQd3FLcU9YaFJMdExS?=
 =?utf-8?B?ck1hRzl2SzRpb1EzRFlFaFZ2bUlodzNLZ0lNTnZ0SWJzVkd2YWF4UlQ0Q285?=
 =?utf-8?B?T0djbC9IM3l3Z213a0ptTEd5a0hCR0REWXh4Zm1mNzZVN0FyVzI4b2hUeWhl?=
 =?utf-8?B?UEtpN2xtZWNKUjU1NzlQWllCR096cE1Zek1nRE91eGhqL2h6NVV2cTE4YW5Z?=
 =?utf-8?B?VVNWV09WRFhCVStrN05YeHlhRlc4VWM1SGRLcUlEa05DSEtWRkVyTWNYTDl3?=
 =?utf-8?B?aS9xOGx0QUZKanZDUTRsM1JOUDRJSlo5dEMwRzl3YnVjU2wyejRmYnRBRDdv?=
 =?utf-8?B?VjBKcG1yMDZ4S0lZZTVRbjA5RXVMMjc5YjlLbmZaQjVvcTZwM1JlU2JRdUk4?=
 =?utf-8?B?QW5RUHVLZE1IU1Jta01XT09Fb3VDMHhhK2Q0NVV1R0NRYnJRTnJEeVRIcDZ6?=
 =?utf-8?B?bEQzaWIyUFdtaFNraEhVQVRxZFlVK2lqUEt1QXY4NGlURmZaeGw5R01BRmVC?=
 =?utf-8?B?RXg4N0VEcDhZaFk1d0xaOGJVL2FkM2JoclJsWFNaOEcrdHRXbisyWEVFRmVr?=
 =?utf-8?B?dUhoUzhTMFJQSzNQNFpLUERwMkJCMUtnU3YzdTk5STdNUmtGeVJSZ3NBdUhw?=
 =?utf-8?B?VG8rVm1aVzYrR1UzeGxTdUJCOE45bXIvSUI3aXpWcnVWTlh3MFdtbXIydzlN?=
 =?utf-8?B?MHUvM2tJMzNRbW9mcnZEeEJQd2Y4Rll2b2ZMRVkrSU40NjBrYXh5akFobkdk?=
 =?utf-8?B?QTJrTDB1MFl5WDlocGowdUc0V1VtYVllaHFhaXV2REl1SzZ3K05LSitkQTl5?=
 =?utf-8?B?ZnV5MVlJbVhYYWJwbXdRRldYN3c2M0g4S0VuN1BUNlRyWW9uK1ZNL2loN0VH?=
 =?utf-8?B?YnJDYUVadXpWbjVuQU1aRE1iTEJhRit5WDBCcHM1cGN6TDAzeW1tRDIwUlpJ?=
 =?utf-8?B?dTloQ2pFVFJWSmhvVWFoQlhMSnJ1VzNxWllCc2dDZGQ2OWJGSEpnQmRjcStl?=
 =?utf-8?B?a0R3emhkVzhnNkw0bmdveGpOT3Z4dGFsenBZWVNuK3hQZUlTbTVUOWwybVNi?=
 =?utf-8?B?aFJiQmJHYVVpc0M3U1Jta1lZUnRBUFFnNFlPbVB3OFRHbkd6SG42UTE5MGZy?=
 =?utf-8?B?enVOamFVcXZVSHRhQ1dIVTg3K3U1cThQYjRUSmNQTVR3V2ErY2NWOWRCem1E?=
 =?utf-8?B?MThFS3piR2ZGcUx5SmVzaXVjRHZhTkNNNENXNVFiRWNkMmdsZnRYeTNJcFF0?=
 =?utf-8?B?TERUb1dWSDYxaDg1REpJczdNcDloM2w1TnhXQXYrVys4MlY3anRkYSthYWFl?=
 =?utf-8?B?OXpBdmFiMDRYR2FBKzNaYzcwSGtib1pPM2Y0TGpPK1pWTDk4aXpKeHBjYVZL?=
 =?utf-8?Q?J9Z/0OYQnfpXmZ2vaJd1GcsHRiB2oI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vi84SzBycGdhbFJZYTRrNkFVUVR3d0RDUmdRSWpRVGZTUFE4bENUeFYrOVhy?=
 =?utf-8?B?R090MHo5MmlNVWhQUmVwOHoycjNOMmdtTjJkVzlJVGoybjJYN1RDQ1dGUmtM?=
 =?utf-8?B?VnFmdDA5MW8wRzI5UG1YTCtBQ1FZVnJpc0RrUGdnL3lDTTRySlQvNUVYM2Ev?=
 =?utf-8?B?ZG0zN0p6QkZBSzlwRFlLRWNaRGJ0TlBUdkJYM2cycThwVFV5ZmcrQk5PY1F5?=
 =?utf-8?B?aEwzSjFGN3R1UnhzQy9MS3Y2MWxQbmNsQUpjY0doYUxFVG13RExScXNuUlZ0?=
 =?utf-8?B?OGlOdFFWMklOV0w0dzRxZ201SWlZRk1JY0ZZMTFQckdqVmFSRW5ZajRZU09W?=
 =?utf-8?B?V29HUmFoWFhBdzYwa2hQa0t1ck1FRm9Hd3ZPSXYra21SVnFNZk1KT3JzYzBk?=
 =?utf-8?B?ZTlzNjJJclpFKzNCaDBDSEVFb3BqQ3k5R3FDdTVDQm5Ia2xNczY2c0xXVUNL?=
 =?utf-8?B?dVg0SnVYdE0wRGRDTUdaNndwV3hacUNJaXFIc1U2NG14ZUwwRWtZd0lWcEkx?=
 =?utf-8?B?bnlNd3FvNXdHNmkrMDJ4MnFhWTNjNENIQ0Z6VWlwaWV3S0NqVnlpM2V4eUtu?=
 =?utf-8?B?NGpRenZMQUtRVHBFWStZVDBER3dLMjZsbE5yL0tqQXZyQmtMcnN5SWt5bGhX?=
 =?utf-8?B?WlhyZkhPOGQ4R3lGRTROODlCMnlnSy9VS20vRG0yTHQ5OGpiMTc0c0JHNU4r?=
 =?utf-8?B?OTRaNkV4T3pxUzZsRGFKWVZxbW94bllWc2dZNVlIcjZ0MGluT0VqNCtXZUh4?=
 =?utf-8?B?MmtPcHpCMzhlR0trZGJFZFkvdjlaaFRqNlp4VlJyc2lHTC9sZW9PREEzcnEr?=
 =?utf-8?B?RGZEUVA2VzA5V0RkN3RDWVpzUmxUdm8zQTl3NjJ1WWlZZVRja3R3Q3JBM2NE?=
 =?utf-8?B?empXcGlodkd2RDBFZld2UlRzdXJ5OTF4dmRYN0Z5UWFEVlFIenpOQm9VbEdF?=
 =?utf-8?B?K2VFS0FiQ1RaNGZtRWNvRXV1K05zRmlIcGRTMzdvT1dBMW40N0lGN1Z2SjJs?=
 =?utf-8?B?MC9OKzN6Ulp3TFZxQU5WNVhKK1FBZHQ3cG4vblM3Q01EcGwxb0IrYUpKQWlR?=
 =?utf-8?B?YVdMSmIweEIvUXBpa3N1ZE44ZkhIZkNzbGRKa2Q2Y0lPSU1kdTJaTGwvM0ZY?=
 =?utf-8?B?WUFjazVnd3BUaFMyMDJ0T2lueEhNc2ozVm5LUmpkcXcraVdnNlhjRTVVYzBL?=
 =?utf-8?B?RFgzMHN0SUVsSmRYL2pxTnBBMTFuTk9Gem1GUHhWM3lRcGE5eDNTUnpXODRG?=
 =?utf-8?B?R2xmcDFRUFJLM3JjNGpKSlk2bWc3djJMNHhZaFpnY2w4S2w1TFdCY21jekNS?=
 =?utf-8?B?ajR2VDZFOVFGbk1sV1RCOTR2bEY1anJjR2x4WXNObERuNmFBZXI3OVkyOVBJ?=
 =?utf-8?B?V2JpWHd0R3ZrbmcreHJYMkJOVFp3VlY2N2pnVSs1MzUzYmNpaklBbTV5NnZU?=
 =?utf-8?B?Z0ptbXZFN0llRDhpUENmSm1CUHNKUm1wUnRKRUgzaEVFVFhZYTVmNUZDdVlE?=
 =?utf-8?B?bXRSYWJPVldZU3UyekFLdmcxYk9SUW5tVm5HTHR2TUs4bXBXMGdmMU90TkN6?=
 =?utf-8?B?cmJhRmZZaDRJaDNGaFp1MEhBTlhvaEN5TWVPc2dUeVRWQWY0ZWdSSlIzMUdr?=
 =?utf-8?B?dEJ0YXlKNzlwRmVGanBOSmczbmRDNzlpOGMvQmgwTGRnQ3RMdUJ3ZzBJWU1B?=
 =?utf-8?B?Tk9GVm0xck96emljUytmMndrNE5kUWFHa1puNlhWdGpOd3FKUXd5RlBpbXJq?=
 =?utf-8?B?eUt1SzUwYWxuR2F3M1kxSEtHK1dESVhMZXhHMlJuQUp1U3J1N2pyUzJWSW1q?=
 =?utf-8?B?cCt1SmQ5bUN1WVQ3ZGZoWndZaVl3ZlMyMEZDRUR5Zmg1T25jTFZ1NmhwMEZz?=
 =?utf-8?B?VVpZaXNGcmp3dnRvSlpBSldKdlFpaGF2dHMwb0wrRlNFSXhXazlLMXhtTmRq?=
 =?utf-8?B?NzlyR1FzaHZUZU9xVlkvdDNxS1g4RmRWSjR1M1cydENndGVHazR6WXZnVHJx?=
 =?utf-8?B?Smo1L2cwcm9tbTlHRFZVUGw2RGprR3E2ZVdoV1A3WTJ5RHZJMWc4dTZGcStt?=
 =?utf-8?B?NjdUVEJ0cXhIUzY2NEVvQlk3MmFoaDkrSkFNU0dpeFVmR2pXNE13Q0tBZ2NP?=
 =?utf-8?B?RlR5NCs4R1paMGZyRUQ0SnQyYmxCNnNkL0VVWUhrVjBZMmdIQkUyYjRNYUZx?=
 =?utf-8?B?dUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7981B142670AF479DAC79A8EEE337DA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee14e9e-5dba-4a69-79b6-08ddd10ca446
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2025 15:03:58.1786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DwmOux4cudPmBRSvCUpfNhwxny0+WdY5KAHi01F5XWXbPQmEOZs3PyJdpXUh1nv8UJ8JD6g86braM8ui5jRaUw7Qa1skSh++amREN+d5oNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5984
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA3LTMxIGF0IDE2OjUzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEp1bCAzMSwgMjAyNSwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBPbiBUaHUsIDIwMjUtMDctMzEgYXQgMTY6MzEgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+ID4gPiBPbiBXZWQsIEp1bCAzMCwgMjAyNSwgUmljayBQIEVkZ2Vjb21iZSB3cm90
ZToNCj4gPiA+ID4gU28gU1RBVFVTX09QRVJBTkRfQlVTWSgpIHNlZW1zIGxpa2UgYW4gb2sgdGhp
bmcgdG8gdHJ5IG5leHQgZm9yIHYzIG9mIHRoaXMNCj4gPiA+ID4gc2VyaWVzIGF0IGxlYXN0LiBV
bmxlc3MgYW55b25lIGhhcyBhbnkgc3Ryb25nIG9iamVjdGlvbnMgYWhlYWQgb2YgdGltZS4NCj4g
PiA+IA0KPiA+ID4gQ2FuIHlvdSBtYWtlIGl0IElTX1REWF9TVEFUVVNfT1BFUkFORF9CVVNZKCkg
c28gdGhhdCBpdCdzIG9idmlvdXNseSBhIGNoZWNrIGFuZA0KPiA+ID4gbm90IGEgc3RhdGVtZW50
L3ZhbHVlLCBhbmQgdG8gc2NvcGUgaXQgdG8gVERYPw0KPiA+IA0KPiA+IEl0J3MgYSBtb3V0aGZ1
bCwgYnV0IEkgY2FuIGxpdmUgd2l0aCBpdC4gWWVhLCBpdCBkZWYgc2hvdWxkIGhhdmUgVERYIGlu
IHRoZSBuYW1lLg0KPiANCj4gSVNfVERYX1NUQVRVU19PUF9CVVNZPw0KDQpFaGgsIHdvdWxkIG5p
Y2VyIHRvIGhhdmUgaXQgY2xvc2VyIHRvIHdoYXQgaXMgaW4gdGhlIFREWCBkb2NzLiBUaGUgd29y
c3Qgd291bGQgYmUgdG8gcmVhZA0KVERYX1NUQVRVU19PUF9CVVNZLCB0aGVuIGhhdmUgdG8gbG9v
ayBhdCB0aGUgdmFsdWUgdG8gZmlndXJlIG91dCB3aGljaCBlcnJvciBjb2RlIGl0IGFjdHVhbGx5
IHdhcy4NCg0KTWF5YmUganVzdCBkcm9wIFNUQVRVUyBhbmQgaGF2ZSBJU19URFhfT1BFUkFORF9C
VVNZKCk/IEl0IHN0aWxsIGxvc2VzIHRoZSBFUlIgcGFydCwgd2hpY2ggbWFkZSBpdCBsb29rDQps
aWtlIElTX0VSUigpLg0K

