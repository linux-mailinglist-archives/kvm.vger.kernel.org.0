Return-Path: <kvm+bounces-62153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF591C398EB
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 09:20:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8BA73BC6CF
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 08:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C77AB2FB619;
	Thu,  6 Nov 2025 08:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fVZ1WMhU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD83145FE0;
	Thu,  6 Nov 2025 08:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762417247; cv=fail; b=u3MNuT+3ND3TleuhoKAw7NN08fZ69FVOibYS8IuysLBsIDYQXXOhlJdrvX3PTxLwSEPMr0CyE+qTsfs+sRJJgbDvuOMTvxZwx/wPKx9YSsFwrOIozqWIuhqK14TEQfhuB3a5hCAu79WrlfaDjisXdgEfMnBphFiHCP+YWHoqRKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762417247; c=relaxed/simple;
	bh=qnWE5lCWFNGgEzaJ7SInchTwz5tb2dFeK9GVZaFQQEg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kJOnWvdQXglj+uv/cTmagEeAwlIiKPPup+I7mH3urwAP/XDOAm1aELnN4hLdqYZum3lQC6Z8NUpdqfqcutKwTzbJkGltEdC2uvGiSJwzkwm50AuDrBH5Evia/WqA9Bc5u5G3u4KYFdy0vqxGN2ugQ4szNf6upR/Ti/Cv8B6X2i0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fVZ1WMhU; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762417247; x=1793953247;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qnWE5lCWFNGgEzaJ7SInchTwz5tb2dFeK9GVZaFQQEg=;
  b=fVZ1WMhUnPWPF9QXkYp4tU5rHrurQn4HNNhU8idrNnbjW2fKvkJBgnbM
   gM5vcqOdeQuGArxK3QnwTV6/OyY4h/9uttswQNcA75Ma1zewkbOUckB/b
   DyGBhMLtAkJluI26dv/cYB2MMtP/cBB77X1L30IBpNgG3IO+cH9R+pJUe
   yW3qLmSxhCStebTzWLlgpz/R61uZQ/vr+2CZ3NRUQv3Yjt0TWwh2SLqcz
   GgohT76KZFXZKCiQTvOPDev/tLXX9JfVFIq1aM51JamxHAqFiEVpzWmAO
   3W9AMQrsJCSDkJ/Aye5lknwd46J6Adzaokt/m5T9i4kwYILLfMMEWM2ki
   w==;
X-CSE-ConnectionGUID: 5oCPQmpGSdK9qwSptd1+KQ==
X-CSE-MsgGUID: 3TWc20tZQ1OgInz+2bGBtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="64585984"
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="64585984"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 00:20:46 -0800
X-CSE-ConnectionGUID: hvlSm/WNTZ2yK7iEqIYvGw==
X-CSE-MsgGUID: T/10dVfcTomVerk1IAhVfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="188146297"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 00:20:45 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 00:20:44 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 6 Nov 2025 00:20:44 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.26) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 00:20:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QVwgyLl7DEmD0b2Ebkm1mgPCKXWlr2MWYIs4xBuVViG1RZOAW5eXgka67nacu7zWbHoBparWIItb1MSX+SkyxG9lhkn4PFbTXAKL8Q4O2h0tgvRt2ddsKaDjdu4houP1f2Rdp3h+O2+U1HZ/k3mS+STK5HrhjfAPrQJqv3uKC3iez20NqcDtZVuWfkCAZ+yX8ZKz9Rb/Fzg7fSftLZ/wGYt6hNsOd/IPAjnXmmVp9B41PC2a7MOPgUcyCfl5Yhnyqz0XP8oDaLHi5vTUzFzf3TLWhyqL0mrZat4KfHMaP0S/y3EXM31V4HrEp/QETk2Dw/P2wl4kzf16uAbJwwjgYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qnWE5lCWFNGgEzaJ7SInchTwz5tb2dFeK9GVZaFQQEg=;
 b=EoSQPflfhsuUPZmhVmaOhrqKwf22/JYsP4CJMifJ0YGHaQsbx+m6wYeyO8/WTMOt624OJxrek3ISqyaVuWI3vUbK00kAr8wnSsbuxe8Ff7c3dbmmw7yvmZT9Kb/xj/t5xWEnjTef77wCOGFcv+Uk8Ti6qTpBBzGK9GzdTfOOKJAXO/fjhZQOw8YxjzD26kdSD6q4/bPynM7ryTqK1q2gwkBM/AT2lR6WeGfnTpRhqEoywv1RS/Wss0hmYD/Yxqc8dJgbdIv/3ZJYkvRRNbfRG/9VRLaR82cTpgF4/19IR0pAQWJa63GtUo21JptuXUh20Koca7dxjRTxHp9BMsh1bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB7151.namprd11.prod.outlook.com (2603:10b6:303:220::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 6 Nov
 2025 08:20:36 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9298.010; Thu, 6 Nov 2025
 08:20:36 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Winiarski, Michal" <michal.winiarski@intel.com>, Alex Williamson
	<alex@shazbot.org>, "De Marchi, Lucas" <lucas.demarchi@intel.com>,
	=?utf-8?B?VGhvbWFzIEhlbGxzdHLDtm0=?= <thomas.hellstrom@linux.intel.com>,
	"Vivi, Rodrigo" <rodrigo.vivi@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
	<skolothumtho@nvidia.com>, "intel-xe@lists.freedesktop.org"
	<intel-xe@lists.freedesktop.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Brost, Matthew" <matthew.brost@intel.com>, "Wajdeczko, Michal"
	<Michal.Wajdeczko@intel.com>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "Jani
 Nikula" <jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Laguna,
 Lukasz" <lukasz.laguna@intel.com>, Christoph Hellwig <hch@infradead.org>
Subject: RE: [PATCH v4 28/28] vfio/xe: Add device specific vfio_pci driver
 variant for Intel graphics
Thread-Topic: [PATCH v4 28/28] vfio/xe: Add device specific vfio_pci driver
 variant for Intel graphics
Thread-Index: AQHcTma4AScpX+8jekK4XzUp/ut4Z7TlTUzg
Date: Thu, 6 Nov 2025 08:20:36 +0000
Message-ID: <BN9PR11MB52766F70E2D8FD19C154CE958CC2A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20251105151027.540712-1-michal.winiarski@intel.com>
 <20251105151027.540712-29-michal.winiarski@intel.com>
In-Reply-To: <20251105151027.540712-29-michal.winiarski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB7151:EE_
x-ms-office365-filtering-correlation-id: 0dd1d793-fe90-4bc0-3cad-08de1d0d5d21
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Rnd0RW94aDhOSWFnNE02VTkvcnZTMkg2RTdJWGZPay8rNnBka0JLd1o5UXJs?=
 =?utf-8?B?b1k3czJmc3FWM0FoU1R0K0I2MmdPQm9HdGx4NndUMVlTTVVaSXhrV0NHOUZZ?=
 =?utf-8?B?RS9mSmhXL0NNSHZUek10aGFjdDdtVVZpRCtZVkdPRlBlMURMM1krTlJBbVpT?=
 =?utf-8?B?VlZONGdsQ3MyKzNTSEJvZS8wNjAvbk9IdmE5aHZWRTR3QldMNUhqY0x5L2tr?=
 =?utf-8?B?WFlBd0d6c1NGZDVZdDNaMTRPa25SemNZeVlIbEM0SU5ocmkrQ0l5OGJ4cjJu?=
 =?utf-8?B?cEFRL0tGK3hId3RuVXA0ZVpiMHhVZDZyZFNQU1F1a2hTUXFUYVVzYTUzdGly?=
 =?utf-8?B?dDNxcDg0ZmFEbEorVHh5M1k5bE1YLzNGN2k1ZEQ0RFlIUWZqUmVUVEo2eWlV?=
 =?utf-8?B?VnkrYm9CUFVZWkFVK3JxaDR1WG4zWE9aR3ZYNTJES29pNjduSFVaUEhqSFN1?=
 =?utf-8?B?NG5nV3VLR2JhMmd6UVNuMHJ1UVExNmhVWjNFaHFVQ1VONXJFQ1d2Z3N4SzZX?=
 =?utf-8?B?RzllaEVZbXMvNFljNUFWRmxYdkpQQmJ2cVZIbFU4Q01mUWltVjRKS3ZRc1Bt?=
 =?utf-8?B?NTFIcUxVK0hpVmJ1K3hueHc0VDB6a1dSUlRuMTdYVVFiSERxMko5Z2V6V3Zj?=
 =?utf-8?B?Vk5zWllGUDBEZm9CZEJHbTdHaHlPVlE4UHZpMFpkeUMyYkxzU1dvZmNpeHdr?=
 =?utf-8?B?eVU4Y2U1MTVwL2ZuUDZpQTk4b2VzK09BTy9GT0VkdDB6dEp5c0l1K3ptTUVL?=
 =?utf-8?B?NGVmUkNHWTJYQVozclYvcmdReWlzQlMzSjh1SEg5UWR3a0dLam4vNk1sYWta?=
 =?utf-8?B?dUJnNFRTdzhuWDJTZGNnOVk5WkJCVytPVFFoTndUOEdXNUFGWmc1bGZHNHBQ?=
 =?utf-8?B?bUk5VnczSVc5emlQY1ZmNHJ1dUE3d0hYcWVwSkpweHkrU1RMRmtPWklMTlZB?=
 =?utf-8?B?RXIvUjRod0tnZ3kvVmNYUHZzQStuZXJSOGlQVkFSNjZ3ejVvMGZPUlZyYVVK?=
 =?utf-8?B?VHZSZ3ZZOSs0N1h3K283RUt3ZEppVC94Tm1KdUZHOUdrbnNRWGtodE1pYXoz?=
 =?utf-8?B?NTZLbmZtNlppeWVscmY0MHFKT2dBRmVIbWpzZ2wzTnBZV2JvRmNrdGxLbVc5?=
 =?utf-8?B?MzVENlA2OWZKZ1NOcGFQMHQ3c2ZpcEFHVzcwc0paaDZYZnRDM3hiNDErVUw5?=
 =?utf-8?B?eHpBQ3JzVDNZUWxBYWlIUkVoei9mWGh4TThqMWhodGpNMU9YRGlMZ3pNK2l1?=
 =?utf-8?B?NnBIdDU5Q09hb2JwekdBb1lBMzY0cDl2UWtKWGVsYTAyOHRBZnJKMUFsWE16?=
 =?utf-8?B?elBZdUxnMVhEakN6YmdsYlVZTmZ6dFBsUlRNVHprL1hxRVByWkdiN1JNc0I0?=
 =?utf-8?B?dzZEendCRVVocFJ2ZUFWUTV2d1NSZERoVGJiMW8rN2NuRkppQldCaGxYblVm?=
 =?utf-8?B?K1l6QmtkeVczblNSUWlLYWM3RXBHSzcyeTZkN21GejVHNjVYTDMvbVBrcDVI?=
 =?utf-8?B?dVhhNU9RejhXKytxTll1WEUrbUg2RnVpMUpaZlQvM0xzVUhVWUJNL2JTTHhD?=
 =?utf-8?B?dWNhQ1EyRXR2ZGdEa1VJVlpEd2dzOGlBWXdLcGE3OVU2Z1FqRGhlWEtrOFVC?=
 =?utf-8?B?MmVGVnUyZnY1V01JT0pId1o4MXVmWFplOC9rZ0UxTWhOUyt0eDRaMW5sc3lN?=
 =?utf-8?B?N2FXa3BoL1dDODgveGFYbUZwRzkzOEtBNVI4eGpVWE9FWTZVV050SFNZOXdE?=
 =?utf-8?B?NmxxbjE1MHN5UEFGRjNZR1pRbUE0S3FGZlh6cU5LUldqR2h4MldJdi9nVnVn?=
 =?utf-8?B?WXAvVloremNHcXF3UVN4WjMrVWFnQk51WS9CZGVBemRKVTBUVHBqUldqakVh?=
 =?utf-8?B?bVJwU1U0Znh0bnlVWkJIeDJtSkpxdFhTQW1GaFJiSlozZzhjamFIZC9WaUdY?=
 =?utf-8?B?NWFic0lMclMvVWt0bG1UckJoNHZJMVJId0VqQXJINnpCQkpVeVBKckNWMk5W?=
 =?utf-8?B?UGUvb21xQW9zWnJ3OU42dDBpek9icmRQMGhnUmRDRm5LeVRRL0ROQVlJVWxj?=
 =?utf-8?B?ZE1BREFtTUFvRlBxdEdQRWJVNGpMRlBvNVNjZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFdiSitWSzJUaTc1d2dNZWE1aCtDTFNXU0NDVzhta29EeVoraVExT0c5ZVJU?=
 =?utf-8?B?QkhlbGtsZ2RseHZ4aFZ1emliM3RVaXZxaWZncVphUytjN1RRRjVkaTRnTE9n?=
 =?utf-8?B?NjlPTDBURmsxbjRVdjNERzE1T2hVZnBNMlQvZm1PeHFDUDRVUUo1MXZyRUcx?=
 =?utf-8?B?Y2NRQVIzUW9YbFVhck1TSzgzemQ0djNzNHJRbUZZc00rSFJTWnp6WlJrd2xk?=
 =?utf-8?B?UGd2TDdTZWlIMUN6dUdKVHFjTXJuNEN5Ly91VEltWEpLZi90SkJRR0ZzZVlC?=
 =?utf-8?B?QlJNTUxCbkQzQWhQcjR5aERla1JSazAvTm1Rd1kxekRDL2VZTEJmdHQ1WmRp?=
 =?utf-8?B?K1lVcWlERyszRjU5TXhveGsrL0NRSGFhVDdnZG5HazZxZXFzVkJwZldZMUMx?=
 =?utf-8?B?N21UVW5FN0kvT3NDUGlLbW5ucXpjbThLWmF5SHFUUkhpdDlzSWk4cWdFall2?=
 =?utf-8?B?ZFpoV0NnSUJrb0h5dys5L1hGV0EzUFZUekUyQ2hJb1hGSnBMWjFyd3VmampK?=
 =?utf-8?B?Sk1KUFp5YzhPTkN5dVhBZU9vcStoT0lVVnNJcWtXOTh6R2hkeFV2Y3Q2MmJK?=
 =?utf-8?B?bnVaQ25mN2lUWTNBRExTQUZrbUJzRTVqVXB0elpnOXhwYjE1ODcrd3J5aEpJ?=
 =?utf-8?B?WVJROUdFbUxZOEVUS015b2kwK1Z4MjBNMEdjOFB1Y285ME5EQUZQZ25BQlcz?=
 =?utf-8?B?T3pxYVhWZ2JUMUxMRUg5Smo3alRKWHdJSTVxOFhQdERBNGpyUWNJbzgyQWw0?=
 =?utf-8?B?RnlsbTIxU1lubDdiSER5TGZCaGJyZGdERlIxYmgvVzZtTnNibkROUmZjMzda?=
 =?utf-8?B?RHYrQUhVWHltYnNMbHFLdDA1bU1GcFp0cE85WHUxZjA2MVE5SFE4ZTFaK2w5?=
 =?utf-8?B?RWxBTlpNS09CcDZwcnoybitodHphQUpMRTBTZXdTcUp1L3RmWWVxUUtYTTc2?=
 =?utf-8?B?SENVQTlLRnZsQ2lCTmI4TFBRdFQ4dW1NRytUeTdDem9sZUVKTXRyNzJvTnM1?=
 =?utf-8?B?TzRtYWE3cjhEblRJV3hPZWZpZk1kak9TUVpPTDEwMzRORFpEU2JIMFNpR2d2?=
 =?utf-8?B?S2gvaGdEcW1ySU1uTkE3Z0MxaG5PV3ZtNjAzbktMR0h1em13N1BNQjRGKzVG?=
 =?utf-8?B?enk2RGdhQ1NLdTRQRXZES1FVb09KWkYxODU5aFRhNEp3bUo4OVI1MlRTSVB1?=
 =?utf-8?B?RFZQcGVLb081dk52Mkc0RVFFOUkvY3c4MWdkM3UvNlY1OFFIWDZtR0lsaVBX?=
 =?utf-8?B?R29zTEg0NmF3YUUyR3BpQ1Vub2Q3TXF1Z0VIZHBDYngzczlieENsaDFaM1Fk?=
 =?utf-8?B?WTFTdmRxQTRDcFZpTFhtUnVrMmZiUnBlNm1zTGlueHZnenNYZzhaZVNFSHdY?=
 =?utf-8?B?bjhOSkU5amd3ajlsUyt2cFdvK2VscDg4QWdhaU1ZQVVXMTFPaXRwVVF4VVc5?=
 =?utf-8?B?V1AyaHZIV1JaNm5UbU5SZkVpeU5sRFU4TFJpM1huV09yNlRKcWljL1NsbG1D?=
 =?utf-8?B?Q0ZFSW5pb1dUTC9pak9xQWh0NVN4NjFsaFZQNGpVS3pkZ245TU9uL1ZXVXpu?=
 =?utf-8?B?OHFWdVFHRXVUSE1nSENtdWIwWmxZUnVpR1JlTHhiZ2xjc0EwR0lDS1hlV01Z?=
 =?utf-8?B?NzFqb0twZFJHR0p2ank5SjNMcFl0dXZkeUQycXRHZDczd2ROOEdKK3Bydy82?=
 =?utf-8?B?THBQbFkxOW9hbUlPZDhQb2xoY2ZCVysvWGV2NlpmbmpkM2dRN1FJVVQza3BS?=
 =?utf-8?B?ZzJUbVFWU2Jpa2IvZ3ppaXRqVEhYNk9tZmFEZ0I2K2pML2JaUU9IWGJES25K?=
 =?utf-8?B?cjlNSWlzdU00anJhNzNRaTZuRTd1YUlpdEVoUUg1RzlGZ0o5SkJpNW1aRHJW?=
 =?utf-8?B?MTR1Q3E5T3hJRGU1elp2OXJGYUhUZlZkem1BQ3RiSUIvUlVRZ3NIdS9EMXM4?=
 =?utf-8?B?YVJkNENiOUFPUmJ0SCtUQ1k3TUN0MFh5U0FrcnU3UzhPeVUwRUhWd216T0ZB?=
 =?utf-8?B?c1dTbE8yUzg2R1hlUDMzd3lpblZ3cng0dXYweS90NkVDOVcvbmpGV1VOck54?=
 =?utf-8?B?Zk5CVVN0c2xkNks5c1M2aDZCVHZIcElIN1B4V01zVmJQY0lPMlA5NWpGRGIv?=
 =?utf-8?Q?RgRGfrFmCjQDgB+4ubAprIlly?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dd1d793-fe90-4bc0-3cad-08de1d0d5d21
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2025 08:20:36.7298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G+MWbNsySFpTBh0PeYQsXUNSikePihK7QB1eq0BzoW0RvnmHsUF11lJZxx/ARrNowNCIVta4h7d/j7Dt+WrRGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7151
X-OriginatorOrg: intel.com

PiBGcm9tOiBXaW5pYXJza2ksIE1pY2hhbCA8bWljaGFsLndpbmlhcnNraUBpbnRlbC5jb20+DQo+
IFNlbnQ6IFdlZG5lc2RheSwgTm92ZW1iZXIgNSwgMjAyNSAxMToxMCBQTQ0KPiANCj4gSW4gYWRk
aXRpb24gdG8gZ2VuZXJpYyBWRklPIFBDSSBmdW5jdGlvbmFsaXR5LCB0aGUgZHJpdmVyIGltcGxl
bWVudHMNCj4gVkZJTyBtaWdyYXRpb24gdUFQSSwgYWxsb3dpbmcgdXNlcnNwYWNlIHRvIGVuYWJs
ZSBtaWdyYXRpb24gZm9yIEludGVsDQo+IEdyYXBoaWNzIFNSLUlPViBWaXJ0dWFsIEZ1bmN0aW9u
cy4NCj4gVGhlIGRyaXZlciBiaW5kcyB0byBWRiBkZXZpY2UsIGFuZCB1c2VzIEFQSSBleHBvc2Vk
IGJ5IFhlIGRyaXZlciBib3VuZA0KPiB0byBQRiBkZXZpY2UgdG8gY29udHJvbCBWRiBkZXZpY2Ug
c3RhdGUgYW5kIHRyYW5zZmVyIHRoZSBtaWdyYXRpb24gZGF0YS4NCg0KIlRoZSBkcml2ZXIgYmlu
ZHMgdG8gVkYgZGV2aWNlIGFuZCB1c2VzIEFQSSBleHBvc2VkIGJ5IFhlIGRyaXZlciB0bw0KdHJh
bnNmZXIgdGhlIFZGIG1pZ3JhdGlvbiBkYXRhIHVuZGVyIHRoZSBjb250cm9sIG9mIFBGIGRldmlj
ZS4iDQoNCj4gK2NvbmZpZyBYRV9WRklPX1BDSQ0KPiArCXRyaXN0YXRlICJWRklPIHN1cHBvcnQg
Zm9yIEludGVsIEdyYXBoaWNzIg0KPiArCWRlcGVuZHMgb24gRFJNX1hFDQo+ICsJc2VsZWN0IFZG
SU9fUENJX0NPUkUNCj4gKwloZWxwDQo+ICsJICBUaGlzIG9wdGlvbiBlbmFibGVzIHZlbmRvci1z
cGVjaWZpYyBWRklPIGRyaXZlciBmb3IgSW50ZWwgR3JhcGhpY3MuDQo+ICsJICBJbiBhZGRpdGlv
biB0byBnZW5lcmljIFZGSU8gUENJIGZ1bmN0aW9uYWxpdHksIGl0IGltcGxlbWVudHMgVkZJTw0K
PiArCSAgbWlncmF0aW9uIHVBUEkgYWxsb3dpbmcgdXNlcnNwYWNlIHRvIGVuYWJsZSBtaWdyYXRp
b24gZm9yDQo+ICsJICBJbnRlbCBHcmFwaGljcyBTUi1JT1YgVmlydHVhbCBGdW5jdGlvbnMgc3Vw
cG9ydGVkIGJ5IHRoZSBYZSBkcml2ZXIuDQoNCmhtbSBhbm90aGVyICJ2ZW5kb3Itc3BlY2lmaWMi
Li4uDQoNCj4gK3N0cnVjdCB4ZV92ZmlvX3BjaV9jb3JlX2RldmljZSB7DQo+ICsJc3RydWN0IHZm
aW9fcGNpX2NvcmVfZGV2aWNlIGNvcmVfZGV2aWNlOw0KPiArCXN0cnVjdCB4ZV9kZXZpY2UgKnhl
Ow0KPiArCS8qIFZGIG51bWJlciB1c2VkIGJ5IFBGLCBYZSBIVy9GVyBjb21wb25lbnRzIHVzZSB2
ZmlkIGluZGV4aW5nDQo+IHN0YXJ0aW5nIGZyb20gMSAqLw0KDQpIYXZpbmcgYm90aCBQRiBhbmQg
WGUgSFcvRlcgaXMgYSBiaXQgbm9pc2luZy4gY291bGQgYmU6DQoNCi8qIFBGIGludGVybmFsIGNv
bnRyb2wgdXNlcyB2ZmlkIGluZGV4IHN0YXJ0aW5nIGZyb20gMSAqLw0KDQo+ICsNCj4gK3N0YXRp
YyB2b2lkIHhlX3ZmaW9fcGNpX3N0YXRlX211dGV4X2xvY2soc3RydWN0IHhlX3ZmaW9fcGNpX2Nv
cmVfZGV2aWNlDQo+ICp4ZV92ZGV2KQ0KPiArew0KPiArCW11dGV4X2xvY2soJnhlX3ZkZXYtPnN0
YXRlX211dGV4KTsNCj4gK30NCj4gKw0KPiArLyoNCj4gKyAqIFRoaXMgZnVuY3Rpb24gaXMgY2Fs
bGVkIGluIGFsbCBzdGF0ZV9tdXRleCB1bmxvY2sgY2FzZXMgdG8NCj4gKyAqIGhhbmRsZSBhICdk
ZWZlcnJlZF9yZXNldCcgaWYgZXhpc3RzLg0KPiArICovDQo+ICtzdGF0aWMgdm9pZCB4ZV92Zmlv
X3BjaV9zdGF0ZV9tdXRleF91bmxvY2soc3RydWN0IHhlX3ZmaW9fcGNpX2NvcmVfZGV2aWNlDQo+
ICp4ZV92ZGV2KQ0KPiArew0KPiArYWdhaW46DQo+ICsJc3Bpbl9sb2NrKCZ4ZV92ZGV2LT5yZXNl
dF9sb2NrKTsNCj4gKwlpZiAoeGVfdmRldi0+ZGVmZXJyZWRfcmVzZXQpIHsNCj4gKwkJeGVfdmRl
di0+ZGVmZXJyZWRfcmVzZXQgPSBmYWxzZTsNCj4gKwkJc3Bpbl91bmxvY2soJnhlX3ZkZXYtPnJl
c2V0X2xvY2spOw0KPiArCQl4ZV92ZmlvX3BjaV9yZXNldCh4ZV92ZGV2KTsNCj4gKwkJZ290byBh
Z2FpbjsNCj4gKwl9DQo+ICsJbXV0ZXhfdW5sb2NrKCZ4ZV92ZGV2LT5zdGF0ZV9tdXRleCk7DQo+
ICsJc3Bpbl91bmxvY2soJnhlX3ZkZXYtPnJlc2V0X2xvY2spOw0KPiArfQ0KDQp0aGlzIGRlZmVy
cmVkX3Jlc2V0IGxvZ2ljIGlzIGEgbWx4IHVuaXF1ZSB0aGluZy4gU2VlOg0KDQpodHRwczovL2xv
cmUua2VybmVsLm9yZy9rdm0vMjAyNDAyMjAxMzI0NTkuR00xMzMzMEBudmlkaWEuY29tLw0KDQo=

