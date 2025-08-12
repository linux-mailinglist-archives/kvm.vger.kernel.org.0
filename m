Return-Path: <kvm+bounces-54465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 511A2B219F1
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:51:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDEB21A24DB0
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 00:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8383B2D77F6;
	Tue, 12 Aug 2025 00:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YGoSPaqJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC02A2D6623;
	Tue, 12 Aug 2025 00:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754959903; cv=fail; b=pUTyqoaLbenbGRNTT+/scK81TNirx0fvYWD9iLMeCr1TgW80DM5Fyk8EQj3Cuswnzihh+lPf8I6mKIJNVFVz+P3CQUqW/zrzAklNDWY8ucmz3ndbuWBy+QP1W8QBxd0F+ueM1DNt1if071eBZvu/CxHcW1gZ40mSO30yYYzDOzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754959903; c=relaxed/simple;
	bh=Q95rH2wm8kvH7JeDhZQGQxPUfx3X4KDUPh+XpOxztmI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MGUz3G8pzz61Z3bIIJhb0/kzs/fsPJ3j5EJgIhl4FGFZ6yCwk1QJPjx8qQQra5k9XDGFtAXdSxE91BIKgi/klCkWyFJf9F3M5HWTzwyL2aCJVhIBD8lbV9n53Z3uG/kit7955Z6Igz1V9rT4hXNlTZbG99ZMvyEmQXghiyZk0dQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YGoSPaqJ; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754959902; x=1786495902;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q95rH2wm8kvH7JeDhZQGQxPUfx3X4KDUPh+XpOxztmI=;
  b=YGoSPaqJ4TtcntcYcKX8SH4rUPWm+Dmus5MpfzWa9fyV0B+wfhTc2Vr7
   mPyIAHhUTlNqmXDafjfoM1qR0bIJ2JuyhZ91zOsJdoSheeocWUGrjz2Ot
   NcBf3j6Ie9EfyAwX/g8W7OMu9J8mvPQa5QGsrCaPW36sUsMlkckPPMyrZ
   ph6P1nz/AjY3Q0lynzSmJ4eaqoZZS+WFq/8C4Dv5zz4Y+4egIFLuPebLo
   ZauoLVIbr1/8rmQfVwxq9RMvw4pxPKZzAcrEpk+tfv/2GBCI9SYHpF6jO
   1SS6WkpL6sQx7aYMjLfghxlWZLcjGIr1xQ2vLXhd/SfXQFR59G8pvLqcP
   g==;
X-CSE-ConnectionGUID: NCiR7HeVQoGCN5ecKGqL4w==
X-CSE-MsgGUID: 4jCVfWLRT9up8NixiXGn6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="56251248"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="56251248"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 17:51:41 -0700
X-CSE-ConnectionGUID: 6Fdux7FhSv6aDeuuGRdb0A==
X-CSE-MsgGUID: 02uwAqndThCvH1PCec78IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165942013"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 17:51:40 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 17:51:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 17:51:40 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.80)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 17:51:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sw+OktR/GNdesBhiDGK1ag1A5pTQY83tiEWH6FM0eOaJ9ERN5i9RlIrWwUcG3Mf+PpDJlH1lXSvDFIOBikiO67D1WtrR+SPQpA49dcYE+EHta2IzELNyVRNTSIemJq/1pmOc47f0uH4QRaZD4eV7mK3zsplcsYhsWTlZeeOybkxRSRNI3IWhwmQUoKcyLOxYM1He+YDaXJJ75sTYNXah1WgC81W1bA2/j9F2fi2xTqLGb1MdwKaOwHuS8YwRatEHCuh0x4R8sLJaJDv8VCWP1oC12k1gLMvlqL/FM5yTu9LCBRQzCkpfZTkz0m45MN35VG62G8Eps6pKx/04VhOZ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q95rH2wm8kvH7JeDhZQGQxPUfx3X4KDUPh+XpOxztmI=;
 b=V3bX0RmcChMXUDbgi+D6ukrc3+QzmEQ6P9c8M7ODttMRfUSZJVML+Y6LGNkObl+WEZxJ6+0Y/W2pTgtcF/iX/dLHRVirIFdyTVdOp5IXrkWArexEJyVxhIIyWEhII2ScaQt3PMxOhrBijWAJ5Y7yuPwO8UWWOzWdYWwSP5C/5G1yzzZ99FIkpkdGvCy0LCJytiFKpCrj4KDrTLisJXkdmPfN9UAzLTYP8y4fUnK8+46moWZ4cne2CFwU+sPKpdTepmieafCl8slC0DXpEgJzBLOtvTZzdb9k7bCJSEBe5nVseo06wuKuIXP8o7bdgyD8RAOAcpgp0KdARxGWO0BKCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6114.namprd11.prod.outlook.com (2603:10b6:930:2d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Tue, 12 Aug
 2025 00:51:38 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 00:51:38 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC: "ashish.kalra@amd.com" <ashish.kalra@amd.com>, "Gao, Chao"
	<chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"Chen, Farrah" <farrah.chen@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH v5 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Topic: [PATCH v5 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Index: AQHb/7s/GFUyxCBlEUe07NNlQFqqxrReRw2A
Date: Tue, 12 Aug 2025 00:51:38 +0000
Message-ID: <3bd5e7ff5756b80766553b5dfc28476aff1d0583.camel@intel.com>
References: <cover.1753679792.git.kai.huang@intel.com>
	 <03d3eecaca3f7680aacc55549bb2bacdd85a048f.1753679792.git.kai.huang@intel.com>
In-Reply-To: <03d3eecaca3f7680aacc55549bb2bacdd85a048f.1753679792.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6114:EE_
x-ms-office365-filtering-correlation-id: 59052520-4c03-4a50-cd11-08ddd93a6503
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?dGptZ0xqZlZseHJweE1lUnJmZTJqd1NuWjUrb1BMYjc0NXNiUkZqWkRmdWlT?=
 =?utf-8?B?NEJmSkl3S1lRK1JlZnBIWnlraWp1RTE1WkxPamRuSXNCQzVIMHh1RWRqN09C?=
 =?utf-8?B?VFJJT0c1VHVJU29tTkRXWVRnaG56T3ExTmFLUFE4VGZjVHVKRUo2UzVWck9S?=
 =?utf-8?B?RE1sMmg0bVVpVjF0dkdDeFlBTms1N0JWMk94NmU2R24wUG1mcEM4cysrY2Nm?=
 =?utf-8?B?bWEzbEpmZHhBQzdXemJFTHlhTUIrQVFmNGxwL1U5VGpFeVZSZ2hJZDZTNVFp?=
 =?utf-8?B?UTNrWm8zZ1BOZUZVcTdWZGY2dEwzclZuR3M5MW9aN1IxaVhVK253S3NNUVN3?=
 =?utf-8?B?ekc1d29NelhPdDRVeVdvNUVWM3ozUkNpRkRyMnh0blA1TmlxUkYyZ0RBYW9h?=
 =?utf-8?B?NWpGTGdRVUNlZ0YzUjJWQWdUR2d4ekhmamdFRk11WGVTeTYyRjVWSWpWWVR3?=
 =?utf-8?B?Y3BRcGhmK0ZxSEJyWmtJeEwwaktzU0VNUmFxNVJwdkJLYkloS0xObTJ4cGF6?=
 =?utf-8?B?dXVycmduUHFSWDE2andTdElKNWdnZ002QlJ0MUVobERkZUsvTy9KVER6Q3h1?=
 =?utf-8?B?djI2MkttMXoybm5QQ1BLUkpLUFlUMjBiSS96ZTZLTGpQVGIwQ2JZOFhtSCt6?=
 =?utf-8?B?anpiekJ3NjFWZkVoUFQwZTc0b0x6blZyOFlvcmV6MjZpYzlGUVhxMWtLSEtw?=
 =?utf-8?B?RjNWb3IvSHdXK0Z1SUZGLzRyM0t5bHhzcDB0Q3lhS2RqQUY5a0dwcWRnUmpF?=
 =?utf-8?B?WEVxS2ZNakQxaGswMEVlTmdLRGZ5d2FXeDBVbFF1Y3Aza1lpSy9oRE14ZDZN?=
 =?utf-8?B?emtSOEZidFVKR0M2K3FNUy81TFE0TzRQNmQreEVuN21IU0dINXo1U1h0eEQw?=
 =?utf-8?B?WFlYUW9ieE9kN2dKa0orTFhYN3ptU1dFeERla2JSZHNGUXprUldjQlNKeW9p?=
 =?utf-8?B?QVZGNVQ5T2pWT3JuZVFjbUZWN0VhMGZDOFBOUFdxQzhWZVhGRE9CRjBtSTdv?=
 =?utf-8?B?OE13Z0hHRUxvS2Rudm10ajlMTWwvN1FpN2VDY2I0OXprMjZHN0ttNlR3cEpI?=
 =?utf-8?B?ejJ0eVFVby9HS2ZJUlg3amtsaGpZRG0vSGhMbGdYTjVndzRremg3STkrQUFQ?=
 =?utf-8?B?UkJzdVI0UnMwUXk4T2FlL2xMTzdaK254VEYvQ3NaTFFmL2ltK0Joa2tOeHV1?=
 =?utf-8?B?NjZtSFgvOXNlV3pWWGRCQ3Z1UmhPYzZKbzYva2RybjhKVUt3V05DY0pBbG1k?=
 =?utf-8?B?ZjFnSFdTNHRHT2xqak1kb0dHQUpCZ1Y4aHQxenNnZFFQbGxQUHlCNHNKeDVJ?=
 =?utf-8?B?WEZlbUhmMU93OTlDYmtJR3hXeDBYeFN2ZGNzbDdxS2swdDZYc2UxS0Nkc3U4?=
 =?utf-8?B?Wk9pMDcvaG4zYU5JelE5NkRWWnl0bEh5cUNBZlpxcFNHNVRjWCtrdmtnRk1W?=
 =?utf-8?B?N0V1THIrOHA2K0FaeXE4NWwrMERVV0RHMnR5ekxsVXBkbko4MURTdm9BWUNi?=
 =?utf-8?B?ZEpoNGxFUUJiQ1hVSGZOdk84WjFKU0RneUdNSWh1ME8raG9lN0puTGZiYk52?=
 =?utf-8?B?LzJGS041by9OZG96L2Vua29GL0F4d1pVN1V6OUFyL29Da3dJei9STmppQ1Z0?=
 =?utf-8?B?WWg5THdnbXREY0dFK0VPUnpzQkQxaWcxQVhDbFZVeGxjR3M5NmdWWnNOUHJy?=
 =?utf-8?B?STA4bWJnSW5McnNPc3BqZzYwYXdCK0RPc3E0TVE3Nkd6QlZ1bVJuTko0L2tI?=
 =?utf-8?B?ZXpwU0VtVzlYQmRnMGRiQk5iUUN3cnkra2EyNEVNbUhOOVRUTk5oeHkxdFJN?=
 =?utf-8?B?RlN5T2dXQUJkSXdrbmNzZURBanlBM1NpOVZWdmJ0WFVqVitVNEticyszZ21V?=
 =?utf-8?B?Mm1ZbkJnWEdKUDJ5eStZUXFIdnZEdlV4aVFoNWN2b2R2VVhZdTZ6bW1sLzVx?=
 =?utf-8?B?aUpUc2JiYUgxa2ovUWJTUjlXMVp5OGwrNVZtZW1hbVFFUUhMSlVvZnJlSkFB?=
 =?utf-8?Q?3BczVECgCp+ARJwtH613OHovCTJ1Pc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3UyZ2M4MlpGRXZUMEduQkZqRmkvb0RQOFl4MkVOMUQ3Q1dlOFh3TWI1WEpx?=
 =?utf-8?B?aHZqcWVRUGNVOTh0Z3BLSUVTdkM4Nm8vYk10L3hFQWpoekI1dktnbERqRnBK?=
 =?utf-8?B?REhsdjdLcDRyVnFIeVZvcWR2cWZ2L2lETjZaZHFCL0lLeGpjZW9FcmhNNDJu?=
 =?utf-8?B?U2hJNzZKVHJBMFRuVEpQMG5VbGxzTzJLMlJFNGRqWmh0Z0FDbUcrcHd1ZjhG?=
 =?utf-8?B?WnN5SDdBaVV4eG96bmNubTRFSlk4cEZ6Um0zdmZDdTk0Mk5qbUpSZTNZelNT?=
 =?utf-8?B?bXd1R3l1UUVvaVArUERMdWRwc29EREJqQ2prZXgxMDIvU2hoWXJVY2dUY2ZL?=
 =?utf-8?B?N1ExYXArMlpoTHN4b3BmeGwvQ05ON2NPTGEvTUNlT2ltcGtJa1VxMWpXQTVO?=
 =?utf-8?B?NklJSUhobDUxcWZ3Rm4xNVZKeXg0dWp3TUNETDVPMnpic3pjRHlteTBQYjhG?=
 =?utf-8?B?M1BTdmlKSkZCdTN4WDBDSEMyZUNlZ1pNeHJVc1FBU3FEMDgvRmlHOVVadkZl?=
 =?utf-8?B?V0JoZ2VsL0x5VHVadXowdWFVdExtSUtIVEtMNGtSYnVjTTIrMkQwOTVpOHBQ?=
 =?utf-8?B?ZTFBbGM0bG9JNk1kTGNid0tEdUU1OGlOcWp6NVcwZGoyanhYUHVkRkhqWUlI?=
 =?utf-8?B?M255MW9XVE1sQUpEVjVkMXhrWVNFZEpYRVE3cHg5R0M2UEFzYWJLUUpCWk92?=
 =?utf-8?B?T0FZNnVQV2FpRm1NSGE5L1V0aG0wLzdLZnVBZWFUeEJoQkJ0SCtXM3dwYXVR?=
 =?utf-8?B?NVQzK2I0RE9YMmR3YTh6SDFVWUNFNzh0RDk1TVlqRUxpNC9XbFlKWmRXYnhs?=
 =?utf-8?B?cHhJMjNEVzA1RnRnazNnK2xFNG1ybU1aUDM4TXN2d2ErVEwvbHJqbmtHN1gx?=
 =?utf-8?B?UmNEaDcyWGIvaUxNa0lUUzJmK2wrMzZTVUtzZy9aUnMwTitBTEpkS3JMTUpi?=
 =?utf-8?B?MVNnUDFEY2Y3WUVuVStQMUM1UTE4bmlkNzNDUTA3UlFYMkdmQXlHbW11ZGU4?=
 =?utf-8?B?eXk2WDA2dkJHZnZ0OW9wUlUrSVhoU2hkVU1ZQlcvQ1dDRGFzUU90VHlxdDB2?=
 =?utf-8?B?U1pON3Y3OHRTQ0RzYjBIVzRhRXRMdXBNOXhCWmhsVWkxTVgyQ2xyQzBEaEhR?=
 =?utf-8?B?ank5aDVpRTNLNWV1cXFLNzlsYVlFOXhOeG1ZdHN3QTJkMkFlcHpCQ2Jsek8y?=
 =?utf-8?B?cyt3ejJCcDY1d1NRQUZocnRjVFZkdHB3eTJNQUpUeXhNeFRNOVd4d0N2eXNp?=
 =?utf-8?B?ajRzU0ZpckgzcCs1eHNLUFAyZTdaais4M0UyQXdOSk5ZVEo0b1FRSENKeWx4?=
 =?utf-8?B?UGRDNmYrQW9SMndXOGpqR09ia1lBSEo0ZE5SMUcyM05nM254K09VR3NaZ2tt?=
 =?utf-8?B?RVR3ZXdaMWpaYWNpQkR6WGlVdWVmVW5JcTZKZ2FLdm03MVNrbFE1NndHa0VK?=
 =?utf-8?B?QmM3TzU1QnpGZWdrWU00TXlaTUo0a0l6WlNGc205YlJNNFhpUERadkRZT2VM?=
 =?utf-8?B?T2ZyUkJLMVNlMDdiNm9hRWNKQWwrTmZTRVlCZHk3QVBlbkJnUFcveHd5SnpN?=
 =?utf-8?B?eWRsNXpwVXZjRW43VVUyL1ZDTitXS0hkbnhoa2JmZ25rZjlKMjhPUkZaNFUy?=
 =?utf-8?B?YXBxL3NJOWlheDg4cE1UMFRFakVyS3lQQTZneVhrMFltTlBUa2Z4THBnWDZa?=
 =?utf-8?B?ZThScVMzQXFNWVIzUDlLSjlmR2pEcFNDNG9qVGUyWHV0Q0lWK0JRMFFSMDBQ?=
 =?utf-8?B?Tm5FUWpnamNNSzZCV2QvMktaaUJKVjJESFhWcVM2M29YUXE3U1dGdGFKVEVI?=
 =?utf-8?B?cS9DQ3JsWER1Sll4bmVYZmt6YVJESGZDNzFTd3k4aEdEMVgwaTh6WmE0dUdk?=
 =?utf-8?B?cEN3YUU2M3c3bDRoRXFBZWR0WjR1UGdURmI2WWJWUGVlV003Tm5Yem9nRDhY?=
 =?utf-8?B?eW5JNFhEK29nampBV0FJVmMxbjlMbGNwL3BhYzkwR2F4T0xJLys0dU05Snpr?=
 =?utf-8?B?bWJoUzJrbDZnMW9UVU1XQkc4NlZOVHZYUmdhbE9aT1lWWkl6RGkyQW1FQmFZ?=
 =?utf-8?B?a0Mvb25pdWRibVg3RUxEenFzRXJ1S3k3Yjh1cFVlOGYyTFhMRlBnVTNtc2kx?=
 =?utf-8?B?K2NZdnJIZkJUdnRsL29JZUJWdUpDME9iRERhcmt4a2pTT1o0ajNCYnM3ZEQ2?=
 =?utf-8?B?ZkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC885AAF85AB954ABBA1C95FFBA57A57@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59052520-4c03-4a50-cd11-08ddd93a6503
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2025 00:51:38.2352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GS4BdCayH/qOD4I6/jrMGtXQsqRXVPSCXygxEwNNAXpkpe7Ez5TCj4kzNX5R6R19AZvZb5SM9tXvOp1E8Bl8tcgfClJUftKmZ/qegK9Yc/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6114
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTI5IGF0IDAwOjI4ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ICtz
dGF0aWMgX19hbHdheXNfaW5saW5lIHU2NCBkb19zZWFtY2FsbChzY19mdW5jX3QgZnVuYywgdTY0
IGZuLA0KPiArCQkJCcKgwqDCoMKgwqDCoCBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICphcmdzKQ0K
PiArew0KPiArCWxvY2tkZXBfYXNzZXJ0X3ByZWVtcHRpb25fZGlzYWJsZWQoKTsNCj4gKw0KPiAr
CS8qDQo+ICsJICogU0VBTUNBTExzIGFyZSBtYWRlIHRvIHRoZSBURFggbW9kdWxlIGFuZCBjYW4g
Z2VuZXJhdGUgZGlydHkNCj4gKwkgKiBjYWNoZWxpbmVzIG9mIFREWCBwcml2YXRlIG1lbW9yeS7C
oCBNYXJrIGNhY2hlIHN0YXRlIGluY29oZXJlbnQNCj4gKwkgKiBzbyB0aGF0IHRoZSBjYWNoZSBj
YW4gYmUgZmx1c2hlZCBkdXJpbmcga2V4ZWMuDQo+ICsJICoNCj4gKwkgKiBUaGlzIG5lZWRzIHRv
IGJlIGRvbmUgYmVmb3JlIGFjdHVhbGx5IG1ha2luZyB0aGUgU0VBTUNBTEwsDQo+ICsJICogYmVj
YXVzZSBrZXhlYy1pbmcgQ1BVIGNvdWxkIHNlbmQgTk1JIHRvIHN0b3AgcmVtb3RlIENQVXMsDQo+
ICsJICogaW4gd2hpY2ggY2FzZSBldmVuIGRpc2FibGluZyBJUlEgd29uJ3QgaGVscCBoZXJlLg0K
PiArCSAqLw0KPiArCXRoaXNfY3B1X3dyaXRlKGNhY2hlX3N0YXRlX2luY29oZXJlbnQsIHRydWUp
Ow0KPiArDQo+ICsJcmV0dXJuIGZ1bmMoZm4sIGFyZ3MpOw0KPiArfQ0KPiArDQoNCg0KRnVuY3Rp
b25hbGx5IGl0IGxvb2tzIGdvb2Qgbm93LCBidXQgSSBzdGlsbCB0aGluayB0aGUgY2hhaW4gb2Yg
bmFtZXMgaXMgbm90DQphY2NlcHRhYmxlOg0KDQpzZWFtY2FsbCgpDQoJc2NfcmV0cnkoKQ0KCQlk
b19zZWFtY2FsbCgpDQoJCQlfX3NlYW1jYWxsKCkNCg0Kc2NfcmV0cnkoKSBpcyB0aGUgb25seSBv
bmUgd2l0aCBhIGhpbnQgb2Ygd2hhdCBpcyBkaWZmZXJlbnQgYWJvdXQgaXQsIGJ1dCBpdA0KcmFu
ZG9tbHkgdXNlcyBzYyBhYmJyZXZpYXRpb24gaW5zdGVhZCBvZiBzZWFtY2FsbC4gVGhhdCBpcyBh
biBleGlzdGluZyB0aGluZy4NCkJ1dCB0aGUgYWRkaXRpb25hbCBvbmUgc2hvdWxkIGJlIG5hbWVk
IHdpdGggc29tZXRoaW5nIGFib3V0IHRoZSBjYWNoZSBwYXJ0IHRoYXQNCml0IGRvZXMsIGxpa2Ug
c2VhbWNhbGxfZGlydHlfY2FjaGUoKSBvciBzb21ldGhpbmcuICJkb19zZWFtY2FsbCgpIiB0ZWxs
cyB0aGUNCnJlYWRlciBub3RoaW5nLg0K

