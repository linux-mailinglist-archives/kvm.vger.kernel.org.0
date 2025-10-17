Return-Path: <kvm+bounces-60434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4439ABEC5FF
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 04:49:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACE8A5E0F6F
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 02:49:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FB5526F462;
	Sat, 18 Oct 2025 02:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iNRqw+S+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245C82773D8;
	Sat, 18 Oct 2025 02:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760755714; cv=fail; b=DcfrSP6LnmfyfwvBrkem2oO1r/aEP7gYPxniF81TSFr5cgk5vZ4g/vK0tv+Q+77Qr2rX6BFBtt/f62wKq5kG7pL0lV/EvXkQVZb7DYfPt9tSKvC3JXOHPPjfcORXMCEj0nv7GiIP5BFF4JTbwNQjen8JIVpY5/0lAp1MlAqh6Kc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760755714; c=relaxed/simple;
	bh=UMCu9VxWuQXNOFxaCiZ2eUzhSUbdO+lfbVFU9h7tmno=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YAkgQwES2u1MEvPtF81Doho4qgwzCuze/2cMnbiInUkuschRaJ0bNATL+I3oDYxeVQB9gFKMRgIEH2jrCO3CwIJPKCyP9+OuOTVKadNPJgcRMOAGFdS3pftYtej82jGBlo8mZAfQ+MuuZbf3q9LIvcGB2Ex310cRqU4RxOSOTpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iNRqw+S+; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760755713; x=1792291713;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UMCu9VxWuQXNOFxaCiZ2eUzhSUbdO+lfbVFU9h7tmno=;
  b=iNRqw+S+erkSp3byoaVpe7Nclu6jXw7+43eIQMepDzfb92faXNEkbS/k
   cPzV3uUrTYm/appJ1/XXf+BnVITcdU1jAhR6ks267NERudSFRyQOAsOjZ
   Z177Xcd8fCZt7AzIioR96saoNnayxL951e7yBT9QUseXdzi4NTWkD2Eif
   7T4HT6VMar89yvf7O3EXcsA2dIslGrXEDIUHajjurK29lIJOgADQ6k83S
   FxmLqKvIv1h4VQsMRpZ6R7ZgMz1T5Do1ESM0GdTdKMenWovLGKJy7NUPH
   Sk/tq/i+gK1WzgfueCdwe+wZj7s7OmQYTmcOCRAmqC0fdUEIY14WI+VlF
   g==;
X-CSE-ConnectionGUID: JYeUtp5QRTWSDMIzfGUVnQ==
X-CSE-MsgGUID: UPZIVDaNT0e6sSai2AfVLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11585"; a="50541602"
X-IronPort-AV: E=Sophos;i="6.19,238,1754982000"; 
   d="scan'208";a="50541602"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP; 17 Oct 2025 19:48:33 -0700
X-CSE-ConnectionGUID: jH+9WnsdRZyBY9Fe/j2Jvw==
X-CSE-MsgGUID: omOBg+N5S9Sc4gPml9iItA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,238,1754982000"; 
   d="scan'208";a="182818878"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 19:48:11 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 17 Oct 2025 14:11:14 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 17 Oct 2025 14:11:14 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.26) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 17 Oct 2025 14:11:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nlzn5nVLr9CqkXgzyC0hPOLGoTQNqT+mUaifgVxzJ65ITbYVZgqw2khMFLpgCGIB1kwlW1v3HlyceLpMgzwh206RYFc77YH7QrOU3mxAeuvIxj4sa8iMvwrSZqvrdewA61xCV0YqfOjCz2U4pII3JymqI3kjvV/of17wOoxsS5XzZIs7EY9HsKa6FqEg5XSed0INUF/xYRES+3dvVFhQBKf4pbSofShsGvmJv7EQvV3gscEVukoPxmbzeS+XI+tBh50YJnA55RbQUVTquUr+C3ojypDm7ZcRFUMPY0axIBerINBM+vGFvIaI8q+GgthkrvMu+Om3LGubqA1gH6idIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMCu9VxWuQXNOFxaCiZ2eUzhSUbdO+lfbVFU9h7tmno=;
 b=m9H5l0rSwIavDSkni03N0po9rHGUfYF4raTUlzFokJNk2P82J5/7GYNn52hqkdeFaVurB+pRvLJsNn70JHK8fV6RvQO0s2ZBg8PHILl2PxtSqe2SYaP3PrWMmyAwWr28XgL4YGED6DPu0hR+3hvoEptUAk4jJx4g3NiZALetZNaTXQXVIiQmlq9RW+/aMfGdcFooy9r0IZ0sR9RhOzC1Jwdr0z0gqetSlSQ2qtyLAHxRxMVQ7sq8P//NhX8+b1+ff7SSl9o+MONQD8xub5sEmfR8q21WuVF+yJl+XTkGMlL11Ve/c2bcA60i2urdsyEtJcDCOJ+7KXswePq7+6l30g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by LV8PR11MB8462.namprd11.prod.outlook.com (2603:10b6:408:1e8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Fri, 17 Oct
 2025 21:11:12 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 21:11:12 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [PATCH v2 2/2] KVM: TDX: WARN if a SEAMCALL VM-Exit makes its way
 out to KVM
Thread-Topic: [PATCH v2 2/2] KVM: TDX: WARN if a SEAMCALL VM-Exit makes its
 way out to KVM
Thread-Index: AQHcPsnJasRrDnCPH0SaPtwK/HwoHLTGJ2uAgABxC4CAADuPgIAAA4WA
Date: Fri, 17 Oct 2025 21:11:12 +0000
Message-ID: <3e16e69ce147db64abfc52464cc3be0358f11ae8.camel@intel.com>
References: <20251016182148.69085-1-seanjc@google.com>
		 <20251016182148.69085-3-seanjc@google.com>
		 <46eb76240a29cb81b6a8aa41016466810abef559.camel@intel.com>
		 <aPJ8A8u8zIvp-wB4@google.com>
	 <38ac916f7c3ae7520708f37389f5524d9278c648.camel@intel.com>
In-Reply-To: <38ac916f7c3ae7520708f37389f5524d9278c648.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|LV8PR11MB8462:EE_
x-ms-office365-filtering-correlation-id: 1c2b860b-42f0-485d-2994-08de0dc1b357
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RFpJMTJRaTdnKzZDdjB6SWRsY2REVGN0d05MRllXQTdadm1LcXdVSWtKWlpY?=
 =?utf-8?B?bEpYWlpuUGtDQTROcHFJVk1sTHZUaW9ZTzJYQTJadUZEYys0RVhIcUpPMWF3?=
 =?utf-8?B?ZEp1Y1dyVWczRXUvb1lEa2twNFNVRmI2SnpNMG8vZE9sYlljN1hrS1d3cUVH?=
 =?utf-8?B?cGJtc2xmcXRRTFNIUjhjcC83WlVNSDNUaitDMkxmckhNUEFJa0pFaExwOVVV?=
 =?utf-8?B?c2pGb0Fxb0xJd0xVVnp2bU9iUUI5QWdvbHlRMTVZSmQyRUhzMzllSUtZZm9X?=
 =?utf-8?B?UVNFS2ZYVTNmWnVCSlppVG44VkZxSi8xT1hqRnUyOVBlb3VCU2RuWmx4RHlj?=
 =?utf-8?B?TG9OeXhwOEdaSGtKZyswVkRCc2NBWFB6RHRVQ0RaQjQ3ZERJYzAvQU94Y3R6?=
 =?utf-8?B?UnRvT2R5OGdJYkw5R2NLRXRYUDhIMllzVWpXMmFWUWl3cXB6MW5rNDVUcEty?=
 =?utf-8?B?djZRbW5VQkZPZHduSU9NaVNUUkMzZ1R1enZ5UE1sZFJ2eUllWWMvQWlRZGVH?=
 =?utf-8?B?T1A3U0xoMUFTdHh4QkM4UEpRaG9GNXhQNldqejVSN216NXMzRUhNYUV2aTJj?=
 =?utf-8?B?SlIxQ2RCajdkQytldEpNTGRrNHpFZHB3QlhUOExZTWN5R2dZckF0b1FyMElj?=
 =?utf-8?B?M1kwNHZQcjQ1aWV3UXk1cmUyaTNQaTB2U05vM2VOYTdRTkhuZEJiUGhDRGhS?=
 =?utf-8?B?a0NNbnZNcEFQNXorMCtERjRDMmlSaHA4WHhIRWFTZnJUQ1pqc3V3cXlkSWY5?=
 =?utf-8?B?b3BLQ2N6L2hMVjRlWHRvd2VPYjRUYXoxSEVtc2Ixb1g2bUNRcWp5MXRIcE5U?=
 =?utf-8?B?TXpYSjJHRStVZExtY013b3VkMk0rVFp3VmIxNHgvSms0aEFnbzhPanB6ajF0?=
 =?utf-8?B?WWQvZWF4b2owcXZjSkp5dW1pNHJaeG5wYWl4V1BhUEtLTzNuUE9CSGVLeHJB?=
 =?utf-8?B?NGNQYmc2MERhSUhRU256VVYwVDgvWC94eGFVNzY1WXIxendDNjNHbU5DYjZQ?=
 =?utf-8?B?ZWxDS0dWUUVXNmE5S25iM0lXbktyZ1Y0N1p3WW5wNUY2MG13Y2ZvdkFTNFlu?=
 =?utf-8?B?c3hVd2s1M2xianNOaUtwa0RYUWZvZWVLTWpjQm9JU2tycDdtaWd0Nnl0NVNx?=
 =?utf-8?B?dzJhVkRPSGJWUHZ1NTdINkJFVjkzOXdOcUZQOTlINXp3M05ETmhybEpmTXhP?=
 =?utf-8?B?VnNWOFViY2srM0ZBZ292U0pPb1VjVVQyM0pBaGIzUEJKVk9rRDM0MDFjMldY?=
 =?utf-8?B?TDcvTlErVWtsZ0VGQUZmMzZ0Y2ZXbkNxbnd6WEJpMC80VTFoQVNMMUpTbFlv?=
 =?utf-8?B?VVB0VXo0KzN6OWoxMmRudGZCZ2hLTWJHaExvdWgyRGN2N0hhZDY4UjFBSzBs?=
 =?utf-8?B?akJ3R3Z0SFFDNzFCOHljKzBucWorMEQwemhTdzhYaURsc3o0U3Z3TThHMlBi?=
 =?utf-8?B?Y01TV0dVM2NqL1RYUEJmdnpGb3AzSnVsb3gzS3ptSXRvQ3RwbytDc2xnMlNU?=
 =?utf-8?B?ekZydnRJUjZPVXFoR0VZaG0zMG5IQ3dWZWpvTStEdUhZWDBLbnF6Mm1aaXpr?=
 =?utf-8?B?dkxSU0xIK0EyazB0VzZBYkkzVlZNcVdmdTNCOWlkVjFvdFM2aGl2TTdnZXIz?=
 =?utf-8?B?Um53bURDM09UbDc2eUoySVdqVlY1WVhDdXMyRmZtR3M2aHR4QTU3a2g0LzUw?=
 =?utf-8?B?TEZwWkRkcUZwcE5HbWtXbG8yVnRFRE9JbGl5aXlGcmhXaEUwMHZ5WUFEY3Zq?=
 =?utf-8?B?SzRoc1NXcEFMb3R2N2luK1hhdnlvbFRySFJRbGRzaTZPcnpvSnlYT25iZHdM?=
 =?utf-8?B?RWJya0JKOG5UalY1a1BPdlJtQTgzWm4ybnRyOVlzTjJoM0p2cDI5NHAzRVdI?=
 =?utf-8?B?c0xkS3U3S3hRRHFCaGhFUmQwdmpkS0h2ZUdLSnIzbXRreCtiL2hQUURJNGFr?=
 =?utf-8?B?Yi93ZFRSQlREeE9HaEN5TzdzU0dYNWxzUjAxeDg1QXNXYWJsaDQ2S09qRUpB?=
 =?utf-8?B?WGd4SnQwNnRLN21ISUhnZzVaWUlrOHFsVVN1c2VYdFhwNmw5cVB3Wmk4eDZH?=
 =?utf-8?Q?MujNfA?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YzhMQ3h6Y3FHVzZqMFNjWTV3QndYRVI2RGVCOUtKMjBFd0JCY0lNbm5GaWpq?=
 =?utf-8?B?YUk5dk0yU25EZTBMUUVZa2dqY3owWk1WcUNlNGI5cDRiMTczZzhreXpmVTdQ?=
 =?utf-8?B?Y05Qck04NCtjNHlvS2dTVjhaM0NJU1hYNlYyMmdBUUpHemxHMDVQVXZQeG5L?=
 =?utf-8?B?a3JoRlN5eFdSK2ZmNWZyQ3NTSVVFUTd1VHB3U0RBTG5CVEx5WVhNeGlpVWd4?=
 =?utf-8?B?YkdObDJZNXRuNHM4MHYxbDJ5Y3c0eVU4ZU1yUlBUM2hxd3lROTVFcTJoOTF6?=
 =?utf-8?B?blZESDkyMjNxWlByM24rWVR0TXZ0UDBESnlWU0lRK2dEaFY0dk5HSWcvWjk3?=
 =?utf-8?B?YW9TNkRzcE4vUHlDSFBRNnoxaitLN3ZRR3NHVGRmY1pSTUZnaDFYUzl5bCsx?=
 =?utf-8?B?dmVNYU9udndsY293T3k3S0x6RGM5QytGQ0RkdXRTZGhIMXkwR2tvL25XSkQ2?=
 =?utf-8?B?RU1FTjVZSEZMSGRlcklrWTRSS3FpbkpIQ2N6QWxjeG9ieDN0L3NqazhyTmFJ?=
 =?utf-8?B?aXJwZXVjWEZjNEZnalZvQlJoNWY0ZWZBVHV2Z2c2Y1l2SmdNTFEyUk5JUnE0?=
 =?utf-8?B?QUtHRnpBWS8rS0RSUWxqUnQ0d05GL3hDTnBGbDF0amF1RE9hMjlrT1ZKYmlt?=
 =?utf-8?B?aysvRU9VWkFSUlpFc1c3K3FwWWRxMnh0eDNLbFhQNUtzdG5UUDZxekRYeUdj?=
 =?utf-8?B?bWo5SmtRb21idmhRZkZhak5pUTRPMHBVeHVLcTVyazgwRGRIOUpXM3l6SHFw?=
 =?utf-8?B?a0x6N05IRG9Ha1AvYnFWMm13S3hERW5oTlh2TWJyS1RxSGdRaHhSNXpPR2lD?=
 =?utf-8?B?cFN5WGU4dEFtQlViREtnSERGQnRtaVRRemZhMW9OcXVBdnViTzE5Q1hUT3hT?=
 =?utf-8?B?cDhueHVhL1RSdjZsTGJvQ1FsaXJ4enBHVVRXc2N2alkwZk95dHY4ZlBjbU9U?=
 =?utf-8?B?MVc3RWxSK0dJdUl5clBRcER0ZCtvMWpUdVN1R0FZN3c2Z0p6enBoeEw0TC83?=
 =?utf-8?B?RGhDL0gxWnovK0RXMHRqc1FZRytrK2hhZFM1L0J6b0FkdndwTE05aGNFeWUy?=
 =?utf-8?B?UHFvRHFET3B6ZVFCVE90Y1JFbDM0bHZtcktCdlJYa1JRR2NHb2pLVUNha0tS?=
 =?utf-8?B?NTVuYmlvd2NQYjBuNUNENEZjSVFtM0NrQ2YyWEc2SEtMR0svTWt0U29RMFlo?=
 =?utf-8?B?bzdpOEg5OXUzRDZwSGtPczdCRkExVy92dWpsd1dETGt2MWZRZnR0MG9pWm5K?=
 =?utf-8?B?NVFBa1g1Y0pFYUx4NFUrZElCMEVqOUdwWklIMWdNenMxNWFyeEdHc0lCOUYy?=
 =?utf-8?B?NysyeCs5SVdVa0pDNTJkNUFSeko0WFAzbFRiSStPOStreVRzWDA2ZVpuUDhS?=
 =?utf-8?B?MjR3eEtzQ0EzN1V3OVZqS244ZDlrQ1hNSnhJdDNpWlk1N0pMdDJOUlRva2ps?=
 =?utf-8?B?WVNUZ1JQcVY1OWJZejNiWVJ0cHdRZjdUcGd2NXFmaGo2aC9ncjgxcnMreHpk?=
 =?utf-8?B?MDQwQWllUFZLcE0yRVU4VHZZdzZUeFd0ZmRKOVNqRUpoUE10OHlDZkhwN3Bu?=
 =?utf-8?B?cTJHSWk5K3gyVWRSa2EwVW8rSzRLTG5waU9DYncyaG5hOXlQWHJ3cTdqSStF?=
 =?utf-8?B?Q2ZNRlp1bGxINXczZTM5TFVXNTBBR1F3Qm5ranlBYW5YMWdFVHExTWtFOWZO?=
 =?utf-8?B?ZUEvYk5sbEVDQW5EUGs5Vk03YVNPb1Bma0lKMU9NYXV5Q3licC8vanhQWHlS?=
 =?utf-8?B?dW96dHdkcm4yd2lJNVZDenNSU3ZKc3BNNGV1WkRrdDZBM2d2UW5hdG81ald1?=
 =?utf-8?B?cER3M1JtT3RJSVY3OENHZExxZS9Ka3RXVWxBSHRHZk1adVd4NngyRkMzb0x1?=
 =?utf-8?B?Y25Pb3hlYnduOElkT2o2UlJPZlk5TU85NWR2WXd2Zk5Ya05pVFp2eFRmbys0?=
 =?utf-8?B?bW1KU3J2NWJCM3RZNUNOcTRodG5RZlViVEc0OTNtRGdZSFJVRjRFTnNiWUhG?=
 =?utf-8?B?ZEJtNkhCSlNvVlE2YTJMTU5UVE5PcVZKMVEwaktaVmxhcFh2YmIva0x6TnJS?=
 =?utf-8?B?b2UxTkZsVFoyTUtjVEMzRFpwODNGNDdaNS9CbkZoOG1rd3liOWVsQm5jeEsr?=
 =?utf-8?Q?Qf02HEaFzqx/Rj5A8QJth0cMu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4822E1F13CD6749BCDAFF8616DAB293@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2b860b-42f0-485d-2994-08de0dc1b357
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 21:11:12.1324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kyRm6lsn8iUqqCzGl6o7SJkfO/W1d0bUDr5PsoaGHZCct2jO7gQqSZjOw2MvsZFtHQRpaFjo9aw5jqN+kUgAGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8462
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI1LTEwLTE4IGF0IDA5OjU4ICsxMzAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IE9u
IEZyaSwgMjAyNS0xMC0xNyBhdCAxMDoyNSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90
ZToNCj4gPiBPbiBGcmksIE9jdCAxNywgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gT24g
VGh1LCAyMDI1LTEwLTE2IGF0IDExOjIxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3Rl
Og0KPiA+ID4gPiBXQVJOIGlmIEtWTSBvYnNlcnZlcyBhIFNFQU1DQUxMIFZNLUV4aXQgd2hpbGUg
cnVubmluZyBhIFREIGd1ZXN0LCBhcyB0aGUNCj4gPiA+ID4gVERYLU1vZHVsZSBpcyBzdXBwb3Nl
ZCB0byBpbmplY3QgYSAjVUQsIHBlciB0aGUgIlVuY29uZGl0aW9uYWxseSBCbG9ja2VkDQo+ID4g
PiA+IEluc3RydWN0aW9ucyIgc2VjdGlvbiBvZiB0aGUgVERYLU1vZHVsZSBiYXNlIHNwZWNpZmlj
YXRpb24uDQo+ID4gPiA+IA0KPiA+ID4gPiBSZXBvcnRlZC1ieTogWGlhb3lhbyBMaSA8eGlhb3lh
by5saUBpbnRlbC5jb20+DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJz
b24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiA+ID4gPiAtLS0NCj4gPiA+ID4gIGFyY2gveDg2L2t2
bS92bXgvdGR4LmMgfCAzICsrKw0KPiA+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9u
cygrKQ0KPiA+ID4gPiANCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdGR4
LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ID4gPiA+IGluZGV4IDA5NzMwNGJmMWUxZC4u
ZmZjZmU5NWYyMjRmIDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5j
DQo+ID4gPiA+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gPiA+ID4gQEAgLTIxNDgs
NiArMjE0OCw5IEBAIGludCB0ZHhfaGFuZGxlX2V4aXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBm
YXN0cGF0aF90IGZhc3RwYXRoKQ0KPiA+ID4gPiAgCQkgKiAtIElmIGl0J3Mgbm90IGFuIE1TTUks
IG5vIG5lZWQgdG8gZG8gYW55dGhpbmcgaGVyZS4NCj4gPiA+ID4gIAkJICovDQo+ID4gPiA+ICAJ
CXJldHVybiAxOw0KPiA+ID4gPiArCWNhc2UgRVhJVF9SRUFTT05fU0VBTUNBTEw6DQo+ID4gPiA+
ICsJCVdBUk5fT05fT05DRSgxKTsNCj4gPiA+ID4gKwkJYnJlYWs7DQo+ID4gPiA+IA0KPiA+ID4g
DQo+ID4gPiBXaGlsZSB0aGlzIGV4aXQgc2hvdWxkIG5ldmVyIGhhcHBlbiBmcm9tIGEgVERYIGd1
ZXN0LCBJIGFtIHdvbmRlcmluZyB3aHkNCj4gPiA+IHdlIG5lZWQgdG8gZXhwbGljaXRseSBoYW5k
bGUgdGhlIFNFQU1DQUxMPyAgRS5nLiwgcGVyICJVbmNvbmRpdGlvbmFsbHkNCj4gPiA+IEJsb2Nr
ZWQgSW5zdHJ1Y3Rpb25zIiBFTkNMUy9FTkNMViBhcmUgYWxzbyBsaXN0ZWQsIHRoZXJlZm9yZQ0K
PiA+ID4gRVhJVF9SRUFTT05fRUxDTFMvRU5DTFYgc2hvdWxkIG5ldmVyIGNvbWUgZnJvbSBhIFRE
WCBndWVzdCBlaXRoZXIuDQo+ID4gDQo+ID4gR29vZCBwb2ludC4gIFNFQU1DQUxMIHdhcyBvYnZp
b3VzbHkgdG9wIG9mIG1pbmQsIEkgZGlkbid0IHRoaW5rIGFib3V0IGFsbCB0aGUNCj4gPiBvdGhl
ciBleGl0cyB0aGF0IHNob3VsZCBiZSBpbXBvc3NpYmxlLg0KPiA+IA0KPiA+IEkgaGF2ZW4ndCBs
b29rZWQgY2xvc2VseSwgYXQgYWxsLCBidXQgSSB3b25kZXIgaWYgd2UgY2FuIGdldCBhd2F5IHdp
dGggdGhpcz8NCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBi
L2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gPiBpbmRleCAwOTczMDRiZjFlMWQuLjRjNjg0NDRi
ZDY3MyAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ID4gKysrIGIv
YXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiA+IEBAIC0yMTQ5LDYgKzIxNDksOCBAQCBpbnQgdGR4
X2hhbmRsZV9leGl0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgZmFzdHBhdGhfdCBmYXN0cGF0aCkN
Cj4gPiAgICAgICAgICAgICAgICAgICovDQo+ID4gICAgICAgICAgICAgICAgIHJldHVybiAxOw0K
PiA+ICAgICAgICAgZGVmYXVsdDoNCj4gPiArICAgICAgICAgICAgICAgLyogQWxsIG90aGVyIGtu
b3duIGV4aXRzIHNob3VsZCBiZSBoYW5kbGVkIGJ5IHRoZSBURFgtTW9kdWxlLiAqLw0KPiA+ICsg
ICAgICAgICAgICAgICBXQVJOX09OX09OQ0UoZXhpdF9yZWFzb24uYmFzaWMgPD0gYyk7DQoNClNv
cnJ5IHNvbWVob3cgSSBjbG9iYmVyZWQgdGhlIHRleHQgKGF0IFNhdHVyZGF5IG1vcm5pbmcpOg0K
DQoJV0FSTl9PTl9PTkNFKGV4aXRfcmVhc29uLmJhc2ljIDw9IEVYSVRfUkVBU09OX1REQ0FMTCk7
DQoJCQkNCj4gPiAgICAgICAgICAgICAgICAgYnJlYWs7DQo+ID4gICAgICAgICB9DQo+IA0KPiBO
b3QgMTAwJSBzdXJlLCBidXQgc2hvdWxkIGJlIGZpbmU/ICBOZWVkcyBtb3JlIHNlY29uZCBleWVz
IGhlcmUuDQo+IA0KPiBFLmcuLCB3aGVuIGEgbmV3IG1vZHVsZSBmZWF0dXJlIG1ha2VzIGFub3Ro
ZXIgZXhpdCByZWFzb24gcG9zc2libGUgdGhlbg0KPiBwcmVzdW1hYmx5IHdlIG5lZWQgZXhwbGlj
aXQgb3B0LWluIHRvIHRoYXQgZmVhdHVyZS4NCj4gDQo+IERvbid0IHF1aXRlIGZvbGxvdyAnZXhp
dF9yZWFzb24uYmFzaWMgPD0gYycgcGFydCwgdGhvdWdoLiAgTWF5YmUgd2UgY2FuDQo+IGp1c3Qg
dW5jb25kaXRpb25hbCBXQVJOX09OX09OQ0UoKT8NCg0KLi4uIGFuZCBjb3BpZWQgaGVyZS4uDQo=

