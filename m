Return-Path: <kvm+bounces-68098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D28ED21B6B
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 00:11:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 22A95300D4A9
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 23:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C9F348883;
	Wed, 14 Jan 2026 23:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aLbmz4U4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF4925DAEA
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 23:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768432260; cv=fail; b=tNvuu63nHALR0A1wcp5NTkJSmDw+l2dZ200VAReubogVVCW7z4RH2V3NTmFMkSb1mulme5Q4VbTjzMb20GHgwCviV7baSX+1C4Ch4gjRL3PyZ+S/bvNSZmLyiVnZi7GWjf2pf7ZLcLK5i3CYlAps1rTe3ENJjfGF4YWv1MsZRsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768432260; c=relaxed/simple;
	bh=PqeVnAsLnd1QpZYZUsaMIItfUwpCAptYxq3VPH355BM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hjg9a0hVybQrV0qVeEHl3OTZ9RMvAG43Ve7pD8zfLdxPQiVZZ+Y5Hb78REf7QexlJiQwbs7l56osaYMmp4zXaSO4ZDp5lcaLeGEyBKWjjp0cB+FL3vPQYUotTm/wRtJ2UXlKaKznXFBdoHXkDp+/SP0kN6EC/vN55sCNudCwlp4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aLbmz4U4; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768432259; x=1799968259;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PqeVnAsLnd1QpZYZUsaMIItfUwpCAptYxq3VPH355BM=;
  b=aLbmz4U4j4MC3mihYMzWu3hKdjq4lYmVi9Tg0ixajnYTSfqMjrnCs3fk
   H8pfoX9R5E3ymrDAZumD6S8ri4HHQ7PlgZOWW3+JDPuPlU4VKs8whrhfn
   BaQe0Xi6jGNU+s+d7MaPgAyAV8AulgFt2BWKlCqTRWH4zKU2l9bqqemwC
   zfdjeaNKVnR+YPw1SVZBoxUHrPlo7mqverGSRrAPlqSANIJzazokGf5c1
   WTQ176xBxHcokzIAf76h2mjRgw2ABiFY0XjzQIgyXxyZEKECIx90ND3rg
   Cxv+cwjVSYSk3IPjgJeGxH7VI18Jq8VNmb9tLLuQR4USTQZXz/KJngbjl
   A==;
X-CSE-ConnectionGUID: AEiCId/xR7OCRxXXPidouA==
X-CSE-MsgGUID: DmU1mMCATiyTRghFaljMYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="69474687"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="69474687"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 15:10:58 -0800
X-CSE-ConnectionGUID: bbWq2i/5T4ynF6Tll8STtA==
X-CSE-MsgGUID: YUetynTRR7+yo+ugceMdyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="204853112"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 15:10:58 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 15:10:57 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 15:10:57 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.26) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 15:10:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bpl88Y33/FJEfhriHwRpGh44mRLwvl9NyErIFlRLaeH01nGm4Bz/EDCyL4OLsIS+yC8XEkrcG9fORKkhlIe05sW9U90mmdfvIYEKMtOj5hNNuITDFyaqj4sV4GaXaG+dEtJTlHMd0UjWkmJKxtFki+Uda06fl5/RWnTfQAPJLcN30SbR9io/DzCl+adTELsaYS9Gh3LXMI6JM2SM9mNGhrlzUEuRoFX/gvku+WODJSjuIQvlTSssZte/uxsVtZ+wphbN1AYXICd/ZOyNRv59MSKlqgwB5kjQBjEUbaHUmhpGbwLJjWPkrDRyMl4vXzSvGe1nQh5t58tEW3Q1lXDAHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PqeVnAsLnd1QpZYZUsaMIItfUwpCAptYxq3VPH355BM=;
 b=HAu+BYuFUoH+/4mCoOPaw0oN7LZllkIRqYQlP8Lqnt110ef/hv5SXlf3q60ShqvzWTHDs7ErZJBeZ/02HE+ujU8OJlYElGkHkpU7gwIwY7db8M8Ev8WpKQcPNTxYk6Vk23cRu+/HnmMtU8Y6iM/MJGfQGK3Bkvl5oeYHKJoA3jiStzywlG1Fj2dbhqzsy2MWsM7+/H1CvXrAb1u4MWy+UqWBq6sqNz8II3jvKtsAv7UaaMQPBBbOaWZqHwSPGrRHHXbrcrRQIDTgxtIa0Ptb6Jp+tWV5OSsBcR0PVz4pkHHXdIUR9gWgqcVCoKA7Y6oGw0UPHiZQuhME7I6jzzESvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA1PR11MB6321.namprd11.prod.outlook.com (2603:10b6:208:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 23:10:55 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 23:10:55 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v5 7/8] KVM: SVM: Add Page modification logging support
Thread-Topic: [PATCH v5 7/8] KVM: SVM: Add Page modification logging support
Thread-Index: AQHcfg3Gf+n2YIr5Hk+kfGbv9gnU47VOXw6AgANh94CAAJjtAA==
Date: Wed, 14 Jan 2026 23:10:55 +0000
Message-ID: <f0a1813c8473e8ecdf2b7826559ae1e37ee1cd2a.camel@intel.com>
References: <20260105063622.894410-1-nikunj@amd.com>
	 <20260105063622.894410-8-nikunj@amd.com>
	 <3d89f9d545d5d8b4558b591201cae19ad4cfb285.camel@intel.com>
	 <2669381c-ddbf-4cb2-a770-8308cd5ff353@amd.com>
In-Reply-To: <2669381c-ddbf-4cb2-a770-8308cd5ff353@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA1PR11MB6321:EE_
x-ms-office365-filtering-correlation-id: 7dd5484e-8173-4861-c557-08de53c22ba7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NldiMlhxTFlTUnNyMmZuQlVxdTJ1WVd4b3k5aEt4VmZsV2NXMHd1cGUra0li?=
 =?utf-8?B?bnlLMXhxSytZcU9ySVZoOHYzVGM5M2NveHNudURUSXhzcFpFL1NydlVnTktD?=
 =?utf-8?B?UERCMWRtdFpTeU5pMHFBV0szd3YvT0FsRGNVVVg5SFAvSTI2NHJkUEtLU1RR?=
 =?utf-8?B?ZVpaNklmRzRCVU4vUG9GV0dBTEdhaVFORWxvbmY0VkU3NEtlZjJaK0dJMXF1?=
 =?utf-8?B?R1Z1OC9iRzhLQklaRnU5VUNGdVNhWk00emVJaXJIbmI1OVp3VEFaSFFGUmY1?=
 =?utf-8?B?bFVJQlg4LzFqTm1NYnczK0JHT3pubzRvM2Yyd3cyOStEOCtqUjNjM2R4WGxI?=
 =?utf-8?B?NC8velhSKzRaTEVGQ3UxL3MraTVLMFc0MXE0bE1hMUF1aW9mcSt4SVk3VjhS?=
 =?utf-8?B?WTZUMlpYNFVuQWh5RnNIeFpYOHptQ25YcjhvSlYxWkVtRytTQmpLYnA4S2NZ?=
 =?utf-8?B?bXBHUXhlOU5jNlQ0MUhKTXlBWWhrNWJZWlErRFh4RW15WFNSMjU2VkcwcFU0?=
 =?utf-8?B?ZTB0V1FXM2UzMDFZSXBqY21VaDVzL2Y1bUJlcFJwZDk3bHVIbStGRGQ0VGFV?=
 =?utf-8?B?MjlhaTJ3SkxkdERZRldnb2Jma3J0Q0o1V0IvbXBYblFZNi90NkRWekZDbTN1?=
 =?utf-8?B?OHdxTzhCdk54MGFxaHB6VTd0Q0pEUjRQSmtYTUFRSEpCMDU1alZGYmJMRHli?=
 =?utf-8?B?cjl6d3Q4YWIvWHhwTmNhd2tIck5POWo4VGdpOU5TaWR5azlxZ1NQNC9KQ084?=
 =?utf-8?B?em5XdWZXbC8ra0JENUJvZlBMUDlwcVh3L3RoZmhrOW9SL2pBUlgzZEFxaWZn?=
 =?utf-8?B?MjFaREN4MS9rcW1heWxsNERMaDBiMjlBdU44eGlwYTBNT2FFVlNzUWVMT3FT?=
 =?utf-8?B?QUxTQzBVT3VPSTRWQmQxM0NyNXFPenZNQjkwSkVwT1FNaW9UWk1OY0c2Nm9x?=
 =?utf-8?B?WnNTY01VemMrZm0zdEJrR0o1SUx5bHNma3BoNWxveVljdEVWSFROKzFoMWxP?=
 =?utf-8?B?c1FGUDFrdnUyUHVOTHlXSHl5STU2TmJGSG5TMDJ2ek1QUEUwWjlEOWRDUFZT?=
 =?utf-8?B?SFE5c0E0OWYwZXRRZlY1N2l3ZVdjOXVGeXpCS2dXNDJ2Z3cxc2tCdlU2U0NS?=
 =?utf-8?B?R2JBUkZxelk1OE42T3B6RC9MK0lCSzdLUDFkdlBPWDBTUWp3d1NNRzlMcm9a?=
 =?utf-8?B?Y1hVekFvdmdlbmZ3bnBsYm05VWp1RDVOYWVQVnJueUFtU2Z5OXdsbldQOWJu?=
 =?utf-8?B?ZmxiVm9kVUhabHZlek9mTEhwQXhHNDBEdlhwbUZBcTd3aHZaU2RpT0FEWHd4?=
 =?utf-8?B?YTZDNCtkc0pCZy95VFoyeHhmbFRNNjV2UDMreEhlV3Fmd3k3MWNwU29XT1FO?=
 =?utf-8?B?L1NQZDFIWmM1YkE5cElKMGZRMHc2VldyMVRsdzg2QUh3akx0OEp1cTE0bzlC?=
 =?utf-8?B?SmNxcVZtMGtVY2RucVNlY1ByUHpWSkhLdUh6OXJOaUhKaHRsYWVCcmJHZjdX?=
 =?utf-8?B?c2U1aFpLSE16dnZiNmdDZDJSd1FVY2pXaWRQVGM1bUZjNFRieEpXZGJpbksv?=
 =?utf-8?B?SDRCSEdzUnVkRC8xc2Q5SlFNYkcyWnJGTjBUK1diQ3FZV01tUDc4V0drelox?=
 =?utf-8?B?RTFvVnZLUzNjNW9YczEwZTJCc3JERjJoVHZqdlRtR2FBekxtMkg2bnJ5dWVw?=
 =?utf-8?B?UlZsTW0vNFppRTNvMDFOeXVqeUVXbDFvbEVqNXRBR2pZRVJFYzJ5NUNGS2F0?=
 =?utf-8?B?ZzdQdlZvbTM4cWJjSllBM2ZwRjVTS1hxWXZDc1R3VEhuZWtMNWc3TDF3Y0Vm?=
 =?utf-8?B?cCt1bmVYWGNrY0E1ZlRSdGloZ2M0cFpDOXV4cTVsYVNzQVpBeHNweTVLZDJ5?=
 =?utf-8?B?K21LSnh6UWdPK1hSclVDdjMxSkE0Uk9Zb0NiUjFPOTg5MGI5bVNCck00ZGpP?=
 =?utf-8?B?UFJ3eFJiY3ZoTjkvOFBxektTRkhBbzluZ2pvcmhuY09jZ0M1SDNVQ25STFJP?=
 =?utf-8?B?VnhwcnVId1NlRVhFRG1oYU1QMnFxRmcwNUxuWTJ6dU9seXE3M1R1N0lUYlJx?=
 =?utf-8?B?MjFDTTdKemI0Zkt2eVlPSlBTcmVnN3FaVm5xZUh5anRaZEJGMmRJYm1zM0Ev?=
 =?utf-8?B?UjU3Ui9aalZFeWN1YThSMXFQcU1SKzdhRkhQdkNKY1ZZUE85cUV6QkdTcHMv?=
 =?utf-8?Q?pRaSiSgZriZ758kkmqaGOBo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVBVdWE4THhobjlpdk03OFlJYVhRb0ZKaFJhY2V0UUdBSExtNGNtbm1qZE8z?=
 =?utf-8?B?ODFSTlpMc1hPSk1pdFdtaTBLeDkvL1h0YUprb1hjMiszYi84ejlNbXVqdEFD?=
 =?utf-8?B?bGxRQjN0aUViaGxsNjVGdzUvYTBvRXBucndnTTY5TVlwVjJ5cWRndW56NVNB?=
 =?utf-8?B?SDdqZFlBODVpcnEwMTFlQjVXMm5zamNYUFBaUjRvdkNWbkpicGdpZXMzVkp1?=
 =?utf-8?B?SGFkZmNzbTZhajVDa3ZYRXVNbC94aHlUSVZQbW1zQTVNeSt4azNkTEtXRWI5?=
 =?utf-8?B?Tk1IdVozY0dVMUtwTE5TV3RKUEFPL1U0OFlPcE4xVXU3VENwSHB0aWxhL3pR?=
 =?utf-8?B?ZFJUWjF0dzEzWExubGZHNTRpSW0wNjIvSEhzUDJyWU1hWFNZQXlVcnFBUDQv?=
 =?utf-8?B?dDZkS0oyNFE5b1hqYWIxdGxtRmFSMGc1OURKQWcydklpUjVWZThsaGRKSjE2?=
 =?utf-8?B?bHdUZlRwY0tmWGVqNVoyTDR6WlR0eGFXbWhINTNGTmJURnArKzAyQVJYQm9x?=
 =?utf-8?B?Z0MwQ2RJcWhnTG5yYWw3Q3lyY29Gb0k4Q2lHSVhPY1NhRlNpQksrT0hGZEh2?=
 =?utf-8?B?NC80WlJBVHVlRHd0NHdUZHBqK2dSemtXZ0UzZEVtOGZiVlAvQkg2TjR1ODBj?=
 =?utf-8?B?c2Q2MFhocDRxM1BlVTdUMVhKN011V09MaHR3ZnhwK3l1YTdNbW1EUTRPdU1p?=
 =?utf-8?B?ZGxuTURZWlROQWt0TnhZMzhjako2SEl2eENzQ0VUbWM0eEpqdHV5ck4xQ0VQ?=
 =?utf-8?B?dkJWK0FodktWeWZLNjVlMFk3dGZOUmVxUUxYK0RiU3V3Zyt2Zldqem81aXdw?=
 =?utf-8?B?L2FuMzFybnUvNkpwVmpTczdGMkdIcjArUzA0QkY5NkVXN0NISzNVeEY1d2V5?=
 =?utf-8?B?aGo2OCs4NmsrN3NDaDNGWjBPallHUDRrRDZYVmtzNnU2c0NDdWNTMVlvSENR?=
 =?utf-8?B?YW9ac3Q5THBvMnpMckE0R0NhKzNzSFBsNHNQRGxuWnB6K3hJekdueFJZSTVV?=
 =?utf-8?B?RTF3RTdIUU1Yd3BxMHBVdUdZNUZWd1c2Tk1uT2g2YitXc2JqS2FLWDNBenY0?=
 =?utf-8?B?eVlhTUM4S2F0eGxSQXprclN4Q01ZNlRIY29FVkNTMitrL3g3cTlBK2hHYm9r?=
 =?utf-8?B?cVZ0Wkh2YmpVaklOSHlUb1dRak96ZTlHb1lmN1NkVTUxVzQzM05KWWlmd3hw?=
 =?utf-8?B?cjhRQ1dvNitKaCtibnJKYzRSanoxM0V4YldsRGJ3UGhUM0JFWGtqTm02M3pU?=
 =?utf-8?B?UUNuaC9SaitFTVNHOWFmZWNDeDF6QjNhVE9DbzAzQkVYVkZxRExHZWNSZEg2?=
 =?utf-8?B?MTc3YkJ0dEJ5NTN1RzVqcFB5NXVjcHJsYlczUDJNQXVSd2pEQVY0N1FaTnZ5?=
 =?utf-8?B?MDVDRjZrNnI2cWlaMzRGSnRLMllFcWh0VENSWE5RVVhNV0JlQmlmU1p3TkJ5?=
 =?utf-8?B?TmdDWmMvV1hUOVZucVMyWTJmelZpU2cxelN1a3dxSlNBczVtaTJta3ZheDRw?=
 =?utf-8?B?V0FMU29rM3RIeXlhbUtoWktXbjJUM0pxQURuSG5VM1Ywa09KclNLNjNOcFRz?=
 =?utf-8?B?QXFDUlF4cmRiSUM4MG1LVlBZcXBXZEFGQy9uWldOWFVqRkQxVDlNRktaNXNh?=
 =?utf-8?B?Z2hRTEtBOHNzd2EvTWFlVURNamFWMm01WVNMNm9Eei9OaG0vaGtnWHovYjlB?=
 =?utf-8?B?d3N0bGVWM3FpaThOZ3hheVM2b3EybGhudEZLamViWTI3NGppclNMRUVRTzAr?=
 =?utf-8?B?UFlzRjY5aVV6c0NaaFFlOXlQb3JuSHB4VGRTTDFCRU1BVDFXbVJlVWZjKzlv?=
 =?utf-8?B?TXBUTEp2c3ptUFBXaVlpWTk2MnBjcGpnSGpyaGNTVXBFZmhkaFR0MmJ4U2Jm?=
 =?utf-8?B?UXFiWlF0TGhzM3J5TlZ1d2JQTWdWUjZQNkVEeFhWbWNHdHVyaGU3QmEzY01E?=
 =?utf-8?B?K01Lak4rN3dnUm85MDJCVE1zVkNRRzBPRUVQaFNMYjBHQ1Z1b3ZDSkpuYlRY?=
 =?utf-8?B?bEErdHBOaEtTb0V0SHp5WnU3WlhFL0lrSFBNRWhrbGFORThOUEZ3NGdwYlNT?=
 =?utf-8?B?MHVYVFlFV3AxTnMwTGcwVTIxZ2VFSGlUQThjNlpPeUptUGFpblRERTgvUzNJ?=
 =?utf-8?B?M1UweXRaZnJtdlN0ZXhUTW4ybmFxWWVGbktSaFlOMW5lY1N4aHo2L0drTWtH?=
 =?utf-8?B?TDQzYk01eE9aN1BOUzZuUWsxUVMzc2ZBQ0w2VzQrZlZjQmJsTVJwR0pWYVBu?=
 =?utf-8?B?T1VEL1pXMklnODVHZ3BMM015Ti9GYnZXcnR2K0E1bysvOGNTWE0vc3FPbTZn?=
 =?utf-8?B?T3FwYTdYU0dFditlMmpCLzhqR2oyVzBQNnBMZ3M3NEMzd3VlbGQ0UT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C06BBABCEEBA541B4B3328D665DC641@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd5484e-8173-4861-c557-08de53c22ba7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2026 23:10:55.4146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3dsJToRcbt00E9w3zs36u91Qdq5sjvNET14IV8YKgssm6P36m91/p4OxLLSYWgNUEP7VrZC/FOr4ksMaUEl5xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6321
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI2LTAxLTE0IGF0IDE5OjMzICswNTMwLCBOaWt1bmogQS4gRGFkaGFuaWEgd3Jv
dGU6DQo+ID4gPiBAQCAtNzQ4LDEyICs3NDgsMTkgQEAgc3RhdGljIHZvaWQgbmVzdGVkX3ZtY2Iw
Ml9wcmVwYXJlX2NvbnRyb2woc3RydWN0IHZjcHVfc3ZtICpzdm0sDQo+ID4gPiDCoMKgCQkJCQkJ
Vl9OTUlfQkxPQ0tJTkdfTUFTSyk7DQo+ID4gPiDCoMKgCX0NCj4gPiA+IMKgIA0KPiA+ID4gLQkv
KiBDb3BpZWQgZnJvbSB2bWNiMDEuwqAgbXNycG1fYmFzZSBjYW4gYmUgb3ZlcndyaXR0ZW4gbGF0
ZXIuwqAgKi8NCj4gPiA+ICsJLyogQ29waWVkIGZyb20gdm1jYjAxLiBtc3JwbV9iYXNlL25lc3Rl
ZF9jdGwgY2FuIGJlIG92ZXJ3cml0dGVuIGxhdGVyLiAqLw0KPiA+ID4gwqDCoAl2bWNiMDItPmNv
bnRyb2wubmVzdGVkX2N0bCA9IHZtY2IwMS0+Y29udHJvbC5uZXN0ZWRfY3RsOw0KPiA+ID4gwqDC
oAl2bWNiMDItPmNvbnRyb2wuaW9wbV9iYXNlX3BhID0gdm1jYjAxLT5jb250cm9sLmlvcG1fYmFz
ZV9wYTsNCj4gPiA+IMKgwqAJdm1jYjAyLT5jb250cm9sLm1zcnBtX2Jhc2VfcGEgPSB2bWNiMDEt
PmNvbnRyb2wubXNycG1fYmFzZV9wYTsNCj4gPiA+IMKgwqAJdm1jYl9tYXJrX2RpcnR5KHZtY2Iw
MiwgVk1DQl9QRVJNX01BUCk7DQo+ID4gPiDCoCANCj4gPiA+ICsJLyogRGlzYWJsZSBQTUwgZm9y
IG5lc3RlZCBndWVzdCBhcyB0aGUgQS9EIHVwZGF0ZSBpcyBlbXVsYXRlZCBieSBNTVUgKi8NCj4g
PiANCj4gPiBUaGlzIGNvbW1lbnQgaXNuJ3QgYWNjdXJhdGUgdG8gbWUuwqAgSSB0aGluayB0aGUg
a2V5IHJlYXNvbiBpcywgZm9yIEwyIGlmDQo+ID4gUE1MIGVuYWJsZWQgdGhlIHJlY29yZGVkIEdQ
QSB3aWxsIGJlIEwyJ3MgR1BBLCBidXQgbm90IEwxJ3MuDQo+ID4gDQo+ID4gUGxlYXNlIHVwZGF0
ZSB0aGUgY29tbWVudCBpZiBhIG5ldyB2ZXJzaW9uIGlzIG5lZWRlZD8NCj4gDQo+IEhvdyBhYm91
dCB0aGUgYmVsb3c6DQo+IA0KPiArCS8qDQo+ICsJICogRGlzYWJsZSBQTUwgZm9yIG5lc3RlZCBn
dWVzdHMuIFdoZW4gTDIgcnVucyB3aXRoIFBNTCBlbmFibGVkLCB0aGUNCj4gKwkgKiBDUFUgbG9n
cyBMMiBHUEFzIHJhdGhlciB0aGFuIEwxIEdQQXMsIGJyZWFraW5nIGRpcnR5IHBhZ2UgdHJhY2tp
bmcNCj4gKwkgKiBmb3IgdGhlIEwwIGh5cGVydmlzb3IuDQo+ICsJICovDQoNCkxHVE0uDQo=

