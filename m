Return-Path: <kvm+bounces-42424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 863ECA7858F
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 02:20:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D8D11656A6
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 00:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F59A1853;
	Wed,  2 Apr 2025 00:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WAvIo/BQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B38367;
	Wed,  2 Apr 2025 00:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743553218; cv=fail; b=d7odgNson5u5kKr0XfUoAi9SW3+vriB8lV/DIHPPdRdywlfv2lYpy1vJK/S5sK5YsDcs61X0tHJs937dkO7yu5ERdZTBnxa9zjn5QhzqLi7OrJnh3Wnis9ofuAxiazNgJq/MNhFZF5Bzecknt1KbwOFJEWyHHq2AgidSaJn8gmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743553218; c=relaxed/simple;
	bh=mKia+Exobsdl7DcUYzb3YGeEmgYmo140S/lYbto+ajU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ns5VakHtiH1peZRsm7lFtSEpJ8IOpC5HOp3ikletTKn+rftfFbeK+0bJFqR+EXKDxsMnAAQJBZsoJ3KMPrmzJAIkzFliBGpW9M9o5GzLdvIOMw2mgkRp+HaBpiRkm5NKRb/hp0LDZFdrVxDreGyLhTt20Qvhn4rP1ixi025S8k4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WAvIo/BQ; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743553217; x=1775089217;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mKia+Exobsdl7DcUYzb3YGeEmgYmo140S/lYbto+ajU=;
  b=WAvIo/BQrRQ7eEnJntKZ0pDj35vd0v98W2CDX5GcxyoaLszCH7H3uYQm
   zxsf2Cd4DmfCRZ5NTMnwWyLXxMC68cGCDVgGaGc0FkY9CDnP0MFZb0oGi
   bUpTyMFyeGBbk3/+NwW1bIzizpCbB/a8W5trkQUFdF5sKBgbzB/1EVII1
   zvHJ8bPdnkeD+yV/jF2n6fpKZ6KTsmfOEDbEmwXfuJRcniJc9u/eInUjm
   0F4A+1AzGQd7z6SlhAvTVyoqKMP79y/OtEGhrKvRhDBsniQTD9IHiO0ZN
   4/qv+dgX28nq1bTVZ7Dbg4nElOJaUC7ixw4mJgep/SjZRsLV85A5AcDhh
   A==;
X-CSE-ConnectionGUID: Uzg1JgPbTgG1ehW1F040cw==
X-CSE-MsgGUID: 8a6q8wbiStiLS/KtxCsZTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="56265581"
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="56265581"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 17:20:15 -0700
X-CSE-ConnectionGUID: P1harWh5RTucN1F7CoN4MA==
X-CSE-MsgGUID: wYhdQEk7SFiHW09DBA0EhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="157475594"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 17:20:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 1 Apr 2025 17:20:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 17:20:14 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 17:20:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nqcdvMhXZqzVm/szNplr9GByvMNGCjD1B7ZL9St8nogzCRfc1XPkV+t0Lap1Ha/OsUPBXt9yFxQBFIkEqJLOJNJ6vlrHlZSX+pV8pms6hyXCDBY77BrZxUakA+V3k71cnfI3TdEuHJmHltqW3px60QlwC8LaCwUoXxRm/DSgxSQ3hIp84UfMzpO5LdLYctCKunL4mrvVpkBJ0DvsSULUGjhS6cpSyFbTUYWJkZjnoUIfvsVNqitQ/Z9fLHPwRxAJ6bLoUNYhb5tdABMt/CSMSA9XT7lPx0c6aYoQ7tG4RS36+mv8ui1Z33O35aczjtFeN0El+wiWaOGPTpURGS1sUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKia+Exobsdl7DcUYzb3YGeEmgYmo140S/lYbto+ajU=;
 b=KjogpBmpR31J/PbNDcaWiXyc98eWjG8K07I6x3X8iWLa80bFXCr2QBsm6VF7/VzwjZ1ln2jeAjPuDuc3BLiZqsB29P9KsMXMKB0EAcYehSVMwbDOvs3e70uZhtQcEWHQX+eZeSHtuZfVEFsz0Pd/fsU7xj37J3SGJ9NIJUw3scF3Ad05UATj2LZrUBA2KjemD/ghsE4arH1PfvN4eddJCQpew1j2lkIS118gd34guy1Ci+U6UqyHC+m0+1Gj1PYn7OZTCcm69vP1D3wG9f84EWdHmBMUQlG9zWRYu8d0qWBc9kPOyTSyuhhy1LCg/C1Fi+zlkcGdMnxffqooCZaZaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB6290.namprd11.prod.outlook.com (2603:10b6:208:3e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.41; Wed, 2 Apr
 2025 00:20:08 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8534.043; Wed, 2 Apr 2025
 00:20:08 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "mikko.ylinen@linux.intel.com"
	<mikko.ylinen@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 0/2] TDX attestation support
Thread-Topic: [PATCH 0/2] TDX attestation support
Thread-Index: AQHbo2Q9DZHHD4hWlkO9fLHSHommabOPgysA
Date: Wed, 2 Apr 2025 00:20:08 +0000
Message-ID: <b5bb71fdb3f9b4a1b08a169b2d6c9c70210c6d02.camel@intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
In-Reply-To: <20250402001557.173586-1-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB6290:EE_
x-ms-office365-filtering-correlation-id: 2d5b1ff8-9eea-45f2-01b2-08dd717c2045
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Vy9nRnZQZFpCb25MUi83aHdhQS9SaVRPeXBFUC8xaDhMQ09tdngxTXJZT085?=
 =?utf-8?B?bUdTd291L29rdUZHL0E4OGdQN1dPREJLS2dUTGx5NVNVTXN6b2VMeGlxeVc3?=
 =?utf-8?B?TUlJZDluUENkWnZuR011Mi9tb2RvNUtid25IWHNncW9leWRxQzdXKzB1L2VU?=
 =?utf-8?B?c3J2VWNuYnlpZ3dBSmkvYmJza2w5QzdzSk9UbTZyVVpqVmJlNXF6QmFvTXVR?=
 =?utf-8?B?ZXhseU5zMzBCMEFKeFVzVkpyOU01Z2lvbE9BZ0U5bm9FalpNdlhkamt6S0RU?=
 =?utf-8?B?UEllalJZUnhVRUJSVmNJWXl1bm1ENWtsMnI1Tld0VmNDeWxPVUFJNHZSSElI?=
 =?utf-8?B?QUNUY3Nib1hERlR4dmRVRW1ZM1FRZURsME1iUjU3N1JWV1diTGhnakxhbXZS?=
 =?utf-8?B?SlJQbEkrZXVvZVE3eVd1Z09rNzkwMEdqbzRlRG9NRFEzOFk3TCtCUjVWeUVl?=
 =?utf-8?B?eHRSb1RFQkUxY1ozdnphaDVzd1ZLMTd1Yyttbm5YYlp6V0FsWGU4c0VkNk5D?=
 =?utf-8?B?M1Jmc25LVlN6dHQxenpueWZITjRrUTVOTzJTRHZDaUNqeUptQWlTVzFhYjZO?=
 =?utf-8?B?cFlTZFFteXkxRDR6dGVqV0xYZDEwVlpUay94Um01ZnJTNmp0N09LdVUvY1Ax?=
 =?utf-8?B?Ym5zNDJEOWtsdXcrYlBxeHJySFc0OFhvbEh0c2V5YTFNeXUyWkNDaUt5NVp0?=
 =?utf-8?B?clFFRmxxNlRGcWJYVU1RRUFSZE43Q1R3bk0ydGFwZ3Yybk01QUJ3djJzdE9U?=
 =?utf-8?B?ZGQyVmRUZGYyKzZsblAzN0RBNy9sMExRRjFxV1VYc0MrZExPc0dvQmFxNktT?=
 =?utf-8?B?MmFmYU1rZ2tYUmFEODNzVmY0a3MvWER2SUh1bzBadC9wUTlJQjVoSlR5d1Mr?=
 =?utf-8?B?ZFo2d1d5WWtsUXJOZ2N4d0ZSSnpZRjRxTzRaS24vV1dqNXB3TzlVOVlZUmZ4?=
 =?utf-8?B?RFB3U21qY0hzeHdxOUxnOWMyOThjZEJTWC9SYUxPRnJDdS9XN0l2MmtQOTVX?=
 =?utf-8?B?T0NSNndHdkNSTlF2eVkvb2Rvbk9uMlhpWktNNE9VN2V3QXdjYzZ4T212Q0Uv?=
 =?utf-8?B?VWxNdkVtNUcxbUdJSTlVSzJVemxKMFQ4MnRPQ2JnbVBFYVk4bjRYZlBWajV6?=
 =?utf-8?B?NUwzQUovN25YTnBYY0h1aC9oOWZmVjhUN1lHVUk0bWxxdExkMDNPTFJBaGcv?=
 =?utf-8?B?TTJTWCtzU1d1UndhQ2doVm5hRmFrZWl2SWF5UzdtVSsydmF3eHVaS0JIUi82?=
 =?utf-8?B?dStTZ0tlOGV1aFExTUl3UDdmblFFZFl6bjhER3JpTXBxS1hQTnpxYzV0RWZH?=
 =?utf-8?B?aFl2QkcwL001cjBtMVZDTXZjdjdxTDNFNWVWUThtMlJoalBUenpyMmI2LzVP?=
 =?utf-8?B?ckxwbXkvNVh1SVRqQWY3VS9nMklGY1NBQU1uWlVDcnQxOU5KclpseFB1RzMy?=
 =?utf-8?B?cEFqRllvSWdab1ZET09zM1N1cXZvVm5nZCtadmJQYVVRTDJMTHZqWWxpM1VU?=
 =?utf-8?B?MFdNOUtZRmYzR1NqVk95TXpMNEdGSWlqQzdtK2EvSjZ2cm9TNi94S2JVVUNN?=
 =?utf-8?B?dEJMWDgxTU8rbi9wY2ZwOE1iVEk4R1BQT253cnBuc1h5S2FZNWhldjNzWDl1?=
 =?utf-8?B?ckE4eUtBTHhzOWdBa054NEtSVW9vWFhkN0o2QXpMWTVocVAxTGRzRTJPRmlZ?=
 =?utf-8?B?SWRpNEJDR2FzeFd4N1hqN3pDMlFYTVlsNXVXTE1jdEhUbUVmRUIxOC9VeU1P?=
 =?utf-8?B?b291WGJOc1ZhUzZBNW0xOEd0V0k5VkVoU0p0dE1FRjl2ODJGMUMvcTIvQkdh?=
 =?utf-8?B?eWs1VUVQTTRuWEJsaURGTXkvVnlZYzRLdFhOcHZYNzJUTXpRSTZLbXBxMEhi?=
 =?utf-8?B?Ym1VclkwSUYzOTdRcmx4VjNXU0dxS0loY3RTcDFvU2U2QkxpMTVxMm1jVFBN?=
 =?utf-8?Q?kgo8WVXukXJRD3xH4fmVvypbV/QsBGzj?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2twYUc4bnQxcGgyc0Q0WUIwK2tML3R4c2dvZ3UvNUVjOVExYXVxdmp2b1NK?=
 =?utf-8?B?T1Y3ME4wM01YVklSRklNbkFEenZkaUFZTUc0U3UrNlQ2M1N0T0gzSDVNM2li?=
 =?utf-8?B?eW10R1J6TldldDVuSWZRQndaNytCV2Ntb1hLRXJ0SzFPTzRyQjBaNEwrYUJj?=
 =?utf-8?B?N2d3WHFVWkloOWxiKy9xZ21BeFFjWGREbWVRdUtiZDZabVJhbU42RXNocXM3?=
 =?utf-8?B?Z1RocUJXMHJTazNNUmJ6ZHAwMUpCN2VlVEpxSGQ1bHl6WUVnbHZSTlVTRnlN?=
 =?utf-8?B?SmpEdVVwQ09NWTlveVY5dkVoUWJpRHNtVy94VXZFWUk5L0tST1UzNkU0Y0cv?=
 =?utf-8?B?SkpZM1pnR044a1J1cm4xeVlXU3JnTHJRWmgwVnVaNk1Mci9xcjcrczhWemlG?=
 =?utf-8?B?aVR4YyttSUhzOEFxRkRTZ1I4elJpK1dFL3ZxOUJLOXpKNEE5OTJHck1VNktX?=
 =?utf-8?B?T0VvU3N2OXNjWFlpRFRrYjJZV2k5QWtZZjhNRmdaM2E4YXZkZ2V5aVpBTHQx?=
 =?utf-8?B?WitGUStJdGNJZ0pKQnhwY0pBdzR2OU02Z0xsVnVnU3FBSjRjRVdWWFJFV21C?=
 =?utf-8?B?MmRwUDNBc3ZFaUg0bnluYXA2TTExK3J1TnJKYkRtdUFDY3ZncHRIUG9Hcm9n?=
 =?utf-8?B?a0E1S3ZSa08rL29aWS9LeEI0K3lITGF5b2tuRWhnU0RyVGRyNzhKM0NVdGtU?=
 =?utf-8?B?aGRrS3FseWQ4cFJHOFdFUFJ3emIwckNZQktaNXZod3I4VGlCODlYVGgvRUZV?=
 =?utf-8?B?ZFFHQkd2UDlrN09zSmdoUWNhTklPdjhUZFYxbkR1cldyU2MyVGFoTno4QjVz?=
 =?utf-8?B?R25ySzlYUWhCVC9vNktHd0pQOVRuSnRjb0tDUGJlV25NUzhMTEthWXFLc2Uv?=
 =?utf-8?B?aTNCNjA0emxtcWlydkJxb294NU16KzE3S21XSzRiZXpGcllyckEzMVZzMlZC?=
 =?utf-8?B?YndTMU5YbmJIQ04rVTVQVE5EZGRlcEZheTdkTW9ma2lLdllzZWNsYVQ0L09Z?=
 =?utf-8?B?M2U1K3VaaE1MbHc2NzNKOVhZUkM4bmZkRnl2MHFCcXZnZnhQYXFpUmJVSi9V?=
 =?utf-8?B?R2ErNjhDSlVRdGtYUTRzR0FoSFBmRGdQUTZMYTBEaXJQNHZjZnNqWnUrUVdj?=
 =?utf-8?B?ZDgrMmdXWTFXRTdnVzMyMEhMMk5iUzZ4d3hQc0s3ZGgxRTJmS3VMUFBTbm5w?=
 =?utf-8?B?MU9WZDFCdlBrdFBncXpMTWlxZEZmVjZNZGtnR1EwRk90dGhBQWdCWExNT1Vp?=
 =?utf-8?B?OThXMkJoZ1ZycWJKVHd2Ym9FelVqSktBRmh1b3JrWG03L2w4dTdzc091VWVL?=
 =?utf-8?B?RitUQ1N6eFF3MHM2ZDRFdVJzL3Nhb1NlME9ULzUrT2d5ejlqeGFOYW5MY3ZY?=
 =?utf-8?B?d1QvMldDOVhkZ1RvVW44cGdpZzNxbUhRNUdsYitEY1lKUk11dGZ5UzFObHhi?=
 =?utf-8?B?elovMktKZ2k5SjN3dUV0K2hJQ25VeWMxV1ZYcHdONjRLZGNFK2RTQkRKR04w?=
 =?utf-8?B?cUpLMmtGdVI0STNVZE5OTC9wdEN4bWtydEVMM2tMSUFJTTdONWNEVFF5YXkw?=
 =?utf-8?B?WjJwcytFOFQ4WXFyRlFMbUxiLzcwejNYc3dsVGJuQzZuREE2SXpxWnZranNR?=
 =?utf-8?B?WmY2dWtPYi9CZWNVaVpQelBIMXJlSTdiSTBTaGFXbHJsWlpua2JzVlZ5Sm9J?=
 =?utf-8?B?RFlOOW96aGpWMU5HblJBQXZwaEhTT3c4NmM5NjY5dHNVMzVZRVM2OE1KSEFO?=
 =?utf-8?B?K1VTRnY5OFhnaEJRcHJYVDRUZ2tmS3JkTW5IOVREV2kwalNSQVF4T1BvZVlm?=
 =?utf-8?B?b2tEc3JDNEt2ZHU5Mi9hMHQvcjhSdWF6M0xRb1Z2T1lTSTVPRVV3UUY3U3h3?=
 =?utf-8?B?UHZVMmtCUXlEbjlXVTNWeW10V3hOOGdoRkVhcUQxVGg0UzBKVTBiUUNkR0Jy?=
 =?utf-8?B?MDQwZGxDSENnaEJCSW5VdzBoVXFYN05sZ29KbG90c0hOdEJuOVJ4ZW1MZU81?=
 =?utf-8?B?bElxMHUrWjJyRVZpNEFEYlZ5cC9PSWlBTDJrSUtEUVRmck90Wi82TDFiQ0I3?=
 =?utf-8?B?T3ZGZWxPSy9EVUpzZXJvSlBBcG9xRmY4SDljRFI1RGZaZ3dyRnAzcSt4LzRB?=
 =?utf-8?B?a0hydkphd0xsSG9WSzNPV1kvQ1VsM2VRMzdNMHg2Rm5SMXl6bG5BMlQzMGh6?=
 =?utf-8?B?Q2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1C8D203D387DD4E9B7BD747D1E4ACD8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d5b1ff8-9eea-45f2-01b2-08dd717c2045
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2025 00:20:08.7683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J8/pMaE9HdKiZuTLJAH3H1Z3l3PVeZm2CT+ROUMsw89ph7Pz8q0/Sqx/s+s4ODeJbQ9/GzDpd8rwv2iMZ3NjrwQfPBx6QBtwiW6UL4pmb1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6290
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA0LTAyIGF0IDA4OjE1ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IE9w
ZW5zDQo+ID09PT09DQo+IExpbnV4IFREWCBndWVzdHMgZG9uJ3QgdXNlIFNldHVwRXZlbnROb3Rp
ZnlJbnRlcnJ1cHQgZm9yIFREIGF0dGVzdGF0aW9uDQo+IGN1cnJlbnRseS4gSWYgbm8gb3RoZXIg
VERYIGd1ZXN0cyB1c2UgaXQsIHRoZSBzdXBwb3J0IGZvcg0KPiBTZXR1cEV2ZW50Tm90aWZ5SW50
ZXJydXB0IGNvdWxkIGJlIGRyb3BwZWQuIEJ1dCBpdCB3b3VsZCByZXF1aXJlIGFuIG9wdC1pbg0K
PiBpZiB0aGUgc3VwcG9ydCBpcyBhZGRlZCBsYXRlci4NCg0KSSB0aGluayB3ZSBzaG91bGRuJ3Qg
YmUgYWZyYWlkIG9mIG9wdC1pbnMuIFdlIHdpbGwgbmVlZCBvbmUgc29vbmVyIG9yIGxhdGVyLg0K
QmV0dGVyIHRvIG5vdCBhZGQgdGhlIHNlY29uZCBleGl0IHdpdGggbm8gdXNlcnMuDQoNCj4gDQo+
IEluIHRoaXMgcGF0Y2ggc2VyaWVzLCBLVk0gZG9lcyBzYW5pdHkgY2hlY2tzIGZvciB0aGUgVERW
TUNBTExzIHNvIHRoYXQNCj4gZGlmZmVyZW50IHVzZXJzcGFjZSBWTU1zIGNhbiBzYXZlIHRoZSBj
b2RlIGZvciBzYW5pdHkgY2hlY2tzLiBCdXQgaXQgY291bGQNCj4gYmUgZHJvcHBlZCBpZiBpdCdz
IHByZWZlcnJlZCB0byBrZWVwIEtWTSBjb2RlIHNpbXBsZXIgYW5kIGxldCB0aGUgdXNlcnNwYWNl
DQo+IFZNTXMgdGFrZSB0aGUgcmVzcG9uc2liaWxpdHkuDQoNCkkgc2F5IHdlIHB1c2ggaXQgdG8g
dXNlcnNwYWNlIHRvIGtlZXAgS1ZNIGFzIHNtYWxsIGFzIHBvc3NpYmxlLg0K

