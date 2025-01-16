Return-Path: <kvm+bounces-35687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64AB0A142E4
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 21:16:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7847116AA18
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 20:16:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C158622CA1E;
	Thu, 16 Jan 2025 20:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IJiXFz57"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D608D23F293;
	Thu, 16 Jan 2025 20:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737058594; cv=fail; b=DmP9WlHx0G8OL1EysCji3TySiE/LjErfMNP0qg/m4WiS92hvcPtI2EJVtrw+B/06H9MDURSKm0s70eU3jcwUBswcZkt7Sb2LqdbIObJ9lYLZCuu1q3W3s0JV3uHyMCYxhTsCbIG9yszCcXUHN2mWtMSpIAVU4XH70UO2uotcpq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737058594; c=relaxed/simple;
	bh=57b0wibYJRnbWfnj54zznEhAm1CwtJdPGXjp9H2MOnE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T7kQok/J2FihJCogESQ6lAi/yBiY/3KYl0fb3fv8p7L5SafPyu3HqJ5H/qMKLLCRu3aO1XUx4ASL0cXRncsPu/0VWYDU8v8uQhUnT9P8JktIjlTKUQkkmuDFzXZhDvasF9Ooliuej3FicnKWuLP3mWau7bqV+VwSNHylZxLollE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IJiXFz57; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737058592; x=1768594592;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=57b0wibYJRnbWfnj54zznEhAm1CwtJdPGXjp9H2MOnE=;
  b=IJiXFz577ZwZfKA1rA+O6/6UaZa4eb9XAtekCVB7SDQE+6rOnbxzjmk9
   eY+7fDbMmsPyKmumwRIoE0E5fIGbfTcA9IAplzW7qUmkrOtHsNmp/Ojzu
   0lhKz4TAY4eSL6jz3EhFXy9aymY945aBXNy25PyCObSMvK4fJZmwatPDo
   048sc+KmLw//88Vh/N0Se8OUe4fYdTOVPweVaOXWjTDWUWM54sr85ujkM
   qsjT7IamRxVc4GB8F+mEbm9/QBBfzEkJbnhpHZAGw+rF2mDZSQ0xWUdu2
   CjQMP+z7j9xxUZceQ2c2NY0P9tegUr0IfWZRiSr8GqYQDUXeVg3432K2P
   Q==;
X-CSE-ConnectionGUID: v6U4i3QiRIuIcy9Y7nBplw==
X-CSE-MsgGUID: 450ksUgnQ4GfHi4pVf3AXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="48881958"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="48881958"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 12:16:31 -0800
X-CSE-ConnectionGUID: o0QPKTZIS3SbnrFrQlqZIA==
X-CSE-MsgGUID: 8SqsiIGyQMWO3BTZZX1qWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="110229586"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jan 2025 12:16:27 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 16 Jan 2025 12:16:26 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 16 Jan 2025 12:16:26 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 16 Jan 2025 12:16:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fTqcychjeGG93g3eMrQDm7Vgo37WYSWkzZaHs13NOseXOe9B1V5qdiJ+RO9O1MT8go7/QalfScYNeEz6HxpJZ97oAiyINcqisxupi3Qw1DXQOs4ZBfmtaF1YnT7EVmLPlsbfAXMgOEC3LqIlnW2KPclTFD8uhoMlpdWPfJf+zotGiqzIe8wJFpUQQEbzV4twS+mpjn0MqS7PuyE41rcKWgLeGz4hILEvy2/zi4GbCFCwbwx+OZ8IFwVxKKvRLz446+o8P0pcS1RoZD1SqmTcfYtt1N/5bhXm3sqVaQCOhH2reE/QQ2/odXem1itgF4ZOT7EkUn8ASt4wEPMmDUbcmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57b0wibYJRnbWfnj54zznEhAm1CwtJdPGXjp9H2MOnE=;
 b=EiSFNTpcG+sjNHK94legiVsouGps9thZSC0r4J5wB6uEqVUQbbuIlQu6rZBZRJNdtCQWTfQ96RH3DTPq+9cd6OC7pTi3OVBhJTS3L0T6oNk81sh7eoHDcbe924jnIp2xV3PF8H/HNBDAwIUEuzhQs984/wgYjg0cnu7vcWm842sdh8l0gn2WZbkpvHsSs3Fb5fYgQlIdy/YvBaHzQIVtSFvMHZ7HtqF3Phwfe7KZ1S2bcDYtIUaxEcWDSXI9FplFVZO4b+cmtYLAcEzESlVQq3Kyd5iLOuo47gcr2KoYfBE2/wF1p6OrvViG/6ihs3pppFOxWKdxEvmV9NmUlG6HAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB8783.namprd11.prod.outlook.com (2603:10b6:8:254::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 20:16:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 20:16:22 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
Thread-Topic: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
Thread-Index: AQHbSdaRKaJIAc3W+kqkHDGtm3kSR7MUKuIAgAABzACABVqtAIAAMPKAgABbB4A=
Date: Thu, 16 Jan 2025 20:16:22 +0000
Message-ID: <19901a08ab931a0200f7c079f36e4b27ed2e1616.camel@intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
	 <20241209010734.3543481-13-binbin.wu@linux.intel.com>
	 <8a9b761b-3ffc-4e67-8254-cf4150a997ae@linux.intel.com>
	 <e3a2e8fa-b496-4010-9a8c-bfeb131bc43b@linux.intel.com>
	 <61e66ef579a86deb453bb25febd30f5aec7472fc.camel@intel.com>
	 <Z4kcjygm19Qv1dNN@google.com>
In-Reply-To: <Z4kcjygm19Qv1dNN@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.2 (3.54.2-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB8783:EE_
x-ms-office365-filtering-correlation-id: ad6d7022-82d1-4c7c-1546-08dd366aa553
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RXFJaWlQbndrWkpMK0hHRFJDK24vVmdZZ1B1aUxvWCtLbWZoaWFlQ0JvOHlP?=
 =?utf-8?B?azg1ekEvelVMenVhNmRaNDFiUit4elRaVlVVYTBkdGM1QTVEZ0tSakp2UEdt?=
 =?utf-8?B?WmxGUUFBemo5VUJ6RThBV3l6djZRQkF2NTYvbzd5dkZxMnpWSkQ5WFRrQWhI?=
 =?utf-8?B?emRXd21IZXZhaktkRThleVJoQWJ2MGl6UHRlODhhbjJTMXNRVkcwSW5rRVh2?=
 =?utf-8?B?YWhncHJMdVQwN1lXTEVvT0RDNkNPTUlUTndTZGZCSWdaUGtwZ3BIeDNPYU1s?=
 =?utf-8?B?c3E2RjFwOWh5eERjRWQ5SmxLZW1Qb29PTXJBT1VqSTI3d3lCWlJodXFiRm1r?=
 =?utf-8?B?Slk2Wm53bWphdDZmbzlFTkloZ2lFb0YzakZhQ3JtOGlUWWNQNG1TSzlzZmc1?=
 =?utf-8?B?UmFwdnR0KzJ2QldZN21ieFVIZ3lFaFN3VkZ0Kzl1OFFuR01DZm5QOXE3QkJX?=
 =?utf-8?B?NmU2eC9sVWlpMjFlZWhVV3BJclQwK2NFUjFTL0MxMG11dzVST3F2Qk95NkMv?=
 =?utf-8?B?WTBiOVZPTXBXRDk5ak52cmNtUmd0OUpWNkV2a2YyOVpmU2lHVG5KZkI1d0lz?=
 =?utf-8?B?T0NHOTNBeXV6N2JJZXcxUmJMSUtXUWdNamJ0alQzMEV4QzFYelZEdzR0SEZ3?=
 =?utf-8?B?bXlFMmp5bEhHVFlsK3ZLd0dQWkpHa21Ba2NCWm9COTlickFLOEVYd2RxdFdC?=
 =?utf-8?B?VjJCM2F6THFVMEl3TmkybWl2N0k1Q3EwNjFiaHk5Rkx4UWdIVFQ5K1B2bU9T?=
 =?utf-8?B?cytPM2RWMXpxMUpJRVpCTU5XMlA4V3RQdmF0d0s0bjRheG5DRnNiaVloWVli?=
 =?utf-8?B?bFhlREtoK2IyaDhBMVlndGF1cDd5S3ZEa29FbklVTXdHMTJreDBPOFpQRGQ0?=
 =?utf-8?B?K0pTRDFxbmdMemFncURuT1VoNEVncDFXY1Rrcm5TbFhNUU9zWEYyZDNOYTBX?=
 =?utf-8?B?Qm9zc3FUM2U5d2krZTZ6UmJWQ1BRSWZOWFBPZ05DSVUrdDc1MWJEbklqL1BE?=
 =?utf-8?B?U3lZN2JzV1UySDJEM0xiMDRKVC9LU2Vya0p4UVZ6TGxoaEVlYlEyWXZyNktE?=
 =?utf-8?B?YnJjcDBNL1A0ZGhCbi9UTS80cHovUWh3RUd3Q0d0RFo2QjgrQ0JqMm1wTDR5?=
 =?utf-8?B?ZmVJalJUdk43cHBwVUVKNURscXJMZE1yaE5aelk2NGtWdTVCSlhMKzk1dEZs?=
 =?utf-8?B?MGl0QlpYUUEzZjUyUHhYUXdQTlZQbno2cFo4UGt0S0gvS0VWbFh2V0srOHNR?=
 =?utf-8?B?Y3QzQ3MwWXRYbEQwdGl5REY1UjJpYVorSGRFNThscU5mTjVyTit5Q3pwWkxw?=
 =?utf-8?B?dDd6dGJabVhrU09hQUxITVpoQ3hUeG92ZVhrTUIrNWJ4MkFwSEcyTlFVdE40?=
 =?utf-8?B?ZGtXaWdlQVNuZzg1WEJiNXVTSy9RRFg1YjlXeFlMVjdvWUpMdmRvSnhzWVF3?=
 =?utf-8?B?V00rbWdreXhERkRRNVE0QlphNFRvc0piblJIWFpqNW1nMlVzZExOblpiTjNn?=
 =?utf-8?B?Ti9sd0JsUGE4ZHBLcFg3RU05M2Q4b0JaaXVLRTNBcnU5ZXR6bWtGa0lZY0tm?=
 =?utf-8?B?WW04WEhlN2hlTVhXckkvaldneWtvZkVYTnZURzRrNks0Nk1yQnVNUkQ3bHFw?=
 =?utf-8?B?L0pTa1hlVFJjcmhPTFZmOWpCQmI1Ukl2RXFqOVV1NlVqamxyaWhHZjJmTit2?=
 =?utf-8?B?dlQvcFlUSCs5dHVOMkNSSjkzYVJ0Nm9KdEZRUEFhbDUrc1ZBU1ZhcjNIaEM3?=
 =?utf-8?B?bnEzd3NPcDhqVU9BM1Q3ZitoaU5PZDY5eFA5THRoaHVNWHdNWG5FUVhNK0NU?=
 =?utf-8?B?TlU2OElWV04rMDNBSG5PVEtoVEhHeDdFbFEwNzF3Q3c3anBSeVBLVS8vSXl6?=
 =?utf-8?B?cGlJTVFyMkZrTUVSMkNETENNZjVFbll5MU83ZzhzRE5xZ3BrcUViK0hQK0pB?=
 =?utf-8?Q?SlC5LdxeXp0i95SMg25IfKpO65bGO2am?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akZ6WGNJMmJNVUcxQ2tUME1xbG5xb3djR25FVDFGTEt1Q3REZ20vVTloM3dx?=
 =?utf-8?B?NjI5STBtSTQvUmc4YUV1WXkxRVIyWEFsSXVxNG95ay9sQmVGMUJUM0ZscHZw?=
 =?utf-8?B?cnR6SWhnT2dDdTJvc1BjZ3pHUjhZdkYxNmtjVFJYa0RPVFJYNlowZjd6bHlO?=
 =?utf-8?B?Tnp0bEhRS2NPVzcyRVh2SVI5SENGVXhMQXFId2RDUmdsWGpHNjJYNW83Rk5t?=
 =?utf-8?B?WVNJRU5mZnFVcVZ4ME5TWGo1RnNSV094dTdGTnZnT05UV29LbkFmSWJyb3RU?=
 =?utf-8?B?UVVzU3JaT1VPUHJKSksvWXQzQUNyZ3JhenA3dlRFZzZmVHRSMlNCM2ZlbFQ2?=
 =?utf-8?B?SllaeUd5b0xOSzR3MUJPQVBUbVV2R0xnclJyYWl0eWtwbzFNSTMvUk03T2hE?=
 =?utf-8?B?OGc5bjgyYXNBNXhlc2VyOEkwSVVlUXduM3R5K3Z3TjRPYXpvOVdXa0I5VEEv?=
 =?utf-8?B?ak0vaXltM2VVV0dZUmVKamo5bnNjMHg2Vm0yVEhHUjJBb25SbzlKYXlnMkpt?=
 =?utf-8?B?YUU0dDhmdUFXN2plNmdpeFU2OUJUMUR3K000NHV3ZFhNT1dIYzExdFcxN0xh?=
 =?utf-8?B?V0NPUFJwbENZYm1hSi84ZStuTU1mQmEzZzZXdll5U2p0NnZKalNiOGU0UFJM?=
 =?utf-8?B?SjhvYlNPbE5CelprK0g1MWZyYm1OU0hZVjRIYmVPMUlVV0kwVStTSnUvTFM5?=
 =?utf-8?B?ZXRXY2ZlRk9Lanh5NDVjK0YzNElhMFpMeUg3N1BYZHJOcGF1dVdwOXk5bEhN?=
 =?utf-8?B?U0pVQk1rekRuZjUxZktTRDN4anV2QlAxQm15NS9lR0EraFdRTWFsUnU3ZnV6?=
 =?utf-8?B?YzQyRnZtbXN5S3h4SlVoTU9ZZ1hKWHZ2aitkbEVYQkRvbkx2ejY1WHdadDVs?=
 =?utf-8?B?ZlRvMFR4ZFhmdytOQzhtYlZjb2luSWdQNlg3dmVpSElvY05mSUcyMmNqM3hk?=
 =?utf-8?B?M3FFOEpVK2RjK1NHR2psNlRMaTZYbTc1UWtGcHVIVXBXdmFhcjRMaHlCVVdm?=
 =?utf-8?B?WGdONkxvS2NqSi9zNG13SkoyN1ZRb1JrUDZWaVhyZ3AxWmdwZWdQV3MrakNN?=
 =?utf-8?B?REtXZVg4dFZ1ZlgxNitxMmtYUjI2QTlPTmRhZVFkd2dWcmxDYjMzTFZob1pJ?=
 =?utf-8?B?MlBBcFprbDArSS9ma05xeXlrQm5SVXkyUUloYnZsd1Yyb3FaTzVqU1dCdVFO?=
 =?utf-8?B?WFZ1UEFrQytkc3NjYjBBNGdsejU4VHhpU0QxYisxUlhRR3dodC9IV29Oc0U4?=
 =?utf-8?B?UkpZS3RrQjBXSXl2Y3FuazJHNTdtOVdsRVNNQnoxMFBRcld2ME5uWWNmem9S?=
 =?utf-8?B?b3ordm9kWTRxMm5aL2RuV2R0bEI0Y1B1RlJ2Q3BDcy9mOVdMNzQvZFhsRDdV?=
 =?utf-8?B?d2s2Z2Q1VnNSWFZwUUlPdm1pa0dmOHVwdlZtazRTMjROaWQwSGFINzFnQ0dJ?=
 =?utf-8?B?UmhFQnR3bVVyUytWVnFLNnNvSHZWVHFOdzZVL3FtK3ZNalRWT2xnSXBhNXho?=
 =?utf-8?B?VVlzSUhnLzVDVFlhWndnTlJFRGd0N2UrSXgyalR0R2swZ0VNbGZtRFBpUHM2?=
 =?utf-8?B?NGdnWXpFdThEbnVyeFkrY1YyOStDeWJzUUtlajQ3aXRCVXZqR1czVDMvOTl3?=
 =?utf-8?B?KzFMYUZLamRxMFRGRVlaaDVSVEpUWEMwQktRdU1YdHgwTzdKdWhDQnY0NVRF?=
 =?utf-8?B?djJxTCs2aFJwNkIwSXFtWkdxUEE0eHdMdU4rK0JsUDIzNFdWY1YrS3JqdHNP?=
 =?utf-8?B?UXMyOWEydlZXeVJ2TnY3bmRoc2ZTVjFqMmxnRUpVUlNFUmlpV0wvUkdQbndS?=
 =?utf-8?B?QnhyRlhiZjVOanM5SW9mTVg2RjkrN0ZGamlhUFF1ejlGWGJrZjJFLzYyYjBm?=
 =?utf-8?B?cUFPTllhYnJPc0k4ZnVXR2NmN2k2ZjZ4cnNuWHFnMTVjeEsrTW1vUDBNWXFI?=
 =?utf-8?B?ZmtxMk1qcVNRZ2k3SkxjbXlIVlhsdjBGZFpHQy9lSlZvT2JmN0tNZzY2Nndt?=
 =?utf-8?B?UXFYb0ZtZXFYOGdYVkY5cUljb0F6c0tMb0tXSnZKaGtCUHZaeis5bFpBVlY2?=
 =?utf-8?B?WGtScythdmF6VDhGcW5iQlFQMFp3TzhtUTgzcU1OVDRYOFEvMmtZdzd5WjFR?=
 =?utf-8?Q?JBIcYYi65lckeuPQUOQZihf6v?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC043ACAC25BB7478D04F7E271960376@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad6d7022-82d1-4c7c-1546-08dd366aa553
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2025 20:16:22.4137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bOaOsLYl2J949zQywGP/okxoWvJK5oOE7Q3oApU2uG9jswaVOU6vbOjG1DC/ze2eeAKr/ZcP5rCwitXWUItn7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8783
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTAxLTE2IGF0IDA2OjUwIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEphbiAxNiwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIE1v
biwgMjAyNS0wMS0xMyBhdCAxMDowOSArMDgwMCwgQmluYmluIFd1IHdyb3RlOg0KPiA+ID4gTGF6
eSBjaGVjayBmb3IgcGVuZGluZyBBUElDIEVPSSB3aGVuIEluLWtlcm5lbCBJT0FQSUMNCj4gPiA+
IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+
ID4gPiBJbi1rZXJuZWwgSU9BUElDIGRvZXMgbm90IHJlY2VpdmUgRU9JIHdpdGggQU1EIFNWTSBB
VklDIHNpbmNlIHRoZSBwcm9jZXNzb3INCj4gPiA+IGFjY2VsZXJhdGVzIHdyaXRlIHRvIEFQSUMg
RU9JIHJlZ2lzdGVyIGFuZCBkb2VzIG5vdCB0cmFwIGlmIHRoZSBpbnRlcnJ1cHQNCj4gPiA+IGlz
IGVkZ2UtdHJpZ2dlcmVkLiBTbyB0aGVyZSBpcyBhIHdvcmthcm91bmQgYnkgbGF6eSBjaGVjayBm
b3IgcGVuZGluZyBBUElDDQo+ID4gPiBFT0kgYXQgdGhlIHRpbWUgd2hlbiBzZXR0aW5nIG5ldyBJ
T0FQSUMgaXJxLCBhbmQgdXBkYXRlIElPQVBJQyBFT0kgaWYgbm8NCj4gPiA+IHBlbmRpbmcgQVBJ
QyBFT0kuDQo+ID4gPiBLVk0gaXMgYWxzbyBub3QgYmUgYWJsZSB0byBpbnRlcmNlcHQgRU9JIGZv
ciBURFggZ3Vlc3RzLg0KPiA+ID4gLSBXaGVuIEFQSUN2IGlzIGVuYWJsZWQNCj4gPiA+IMKgwqAg
VGhlIGNvZGUgb2YgbGF6eSBjaGVjayBmb3IgcGVuZGluZyBBUElDIEVPSSBkb2Vzbid0IHdvcmsg
Zm9yIFREWCBiZWNhdXNlDQo+ID4gPiDCoMKgIEtWTSBjYW4ndCBnZXQgdGhlIHN0YXR1cyBvZiBy
ZWFsIElSUiBhbmQgSVNSLCBhbmQgdGhlIHZhbHVlcyBhcmUgMHMgaW4NCj4gPiA+IMKgwqAgdklS
UiBhbmQgdklTUiBpbiBhcGljLT5yZWdzW10sIGt2bV9hcGljX3BlbmRpbmdfZW9pKCkgd2lsbCBh
bHdheXMgcmV0dXJuDQo+ID4gPiDCoMKgIGZhbHNlLiBTbyB0aGUgUlRDIHBlbmRpbmcgRU9JIHdp
bGwgYWx3YXlzIGJlIGNsZWFyZWQgd2hlbiBpb2FwaWNfc2V0X2lycSgpDQo+ID4gPiDCoMKgIGlz
IGNhbGxlZCBmb3IgUlRDLiBUaGVuIHVzZXJzcGFjZSBtYXkgbWlzcyB0aGUgY29hbGVzY2VkIFJU
QyBpbnRlcnJ1cHRzLg0KPiA+ID4gLSBXaGVuIFdoZW4gQVBJQ3YgaXMgZGlzYWJsZWQNCj4gPiA+
IMKgwqAgaW9hcGljX2xhenlfdXBkYXRlX2VvaSgpIHdpbGwgbm90IGJlIGNhbGxlZO+8jHRoZW4g
cGVuZGluZyBFT0kgc3RhdHVzIGZvcg0KPiA+ID4gwqDCoCBSVEMgd2lsbCBub3QgYmUgY2xlYXJl
ZCBhZnRlciBzZXR0aW5nIGFuZCB0aGlzIHdpbGwgbWlzbGVhZCB1c2Vyc3BhY2UgdG8NCj4gPiA+
IMKgwqAgc2VlIGNvYWxlc2NlZCBSVEMgaW50ZXJydXB0cy4NCj4gPiA+IE9wdGlvbnM6DQo+ID4g
PiAtIEZvcmNlIGlycWNoaXAgc3BsaXQgZm9yIFREWCBndWVzdHMgdG8gZWxpbWluYXRlIHRoZSB1
c2Ugb2YgaW4ta2VybmVsIElPQVBJQy4NCj4gPiA+IC0gTGVhdmUgaXQgYXMgaXQgaXMsIGJ1dCB0
aGUgdXNlIG9mIFJUQyBtYXkgbm90IGJlIGFjY3VyYXRlLg0KPiA+IA0KPiA+IExvb2tpbmcgYXQg
dGhlIGNvZGUsIGl0IHNlZW1zIEtWTSBvbmx5IHRyYXBzIEVPSSBmb3IgbGV2ZWwtdHJpZ2dlcmVk
IGludGVycnVwdA0KPiA+IGZvciBpbi1rZXJuZWwgSU9BUElDIGNoaXAsIGJ1dCBJSVVDIElPQVBJ
QyBpbiB1c2Vyc3BhY2UgYWxzbyBuZWVkcyB0byBiZSB0b2xkDQo+ID4gdXBvbiBFT0kgZm9yIGxl
dmVsLXRyaWdnZXJlZCBpbnRlcnJ1cHQuICBJIGRvbid0IGtub3cgaG93IGRvZXMgS1ZNIHdvcmtz
IHdpdGgNCj4gPiB1c2Vyc3BhY2UgSU9BUElDIHcvbyB0cmFwcGluZyBFT0kgZm9yIGxldmVsLXRy
aWdnZXJlZCBpbnRlcnJ1cHQsIGJ1dCAiZm9yY2UNCj4gPiBpcnFjaGlwIHNwbGl0IGZvciBURFgg
Z3Vlc3QiIHNlZW1zIG5vdCByaWdodC4NCj4gDQo+IEZvcmNpbmcgYSAic3BsaXQiIElSUSBjaGlw
IGlzIGNvcnJlY3QsIGluIHRoZSBzZW5zZSB0aGF0IFREWCBkb2Vzbid0IHN1cHBvcnQgYW4NCj4g
SS9PIEFQSUMgYW5kIHRoZSAic3BsaXQiIG1vZGVsIGlzIHRoZSB3YXkgdG8gY29uY29jdCBzdWNo
IGEgc2V0dXAuICBXaXRoIGEgImZ1bGwiDQo+IElSUSBjaGlwLCBLVk0gaXMgcmVzcG9uc2libGUg
Zm9yIGVtdWxhdGluZyB0aGUgSS9PIEFQSUMsIHdoaWNoIGlzIG1vcmUgb3IgbGVzcw0KPiBub25z
ZW5zaWNhbCBvbiBURFggYmVjYXVzZSBpdCdzIGZ1bGx5IHZpcnR1YWwgd29ybGQsIGkuZS4gdGhl
cmUncyBubyByZWFzb24gdG8NCj4gZW11bGF0ZSBsZWdhY3kgZGV2aWNlcyB0aGF0IG9ubHkga25v
dyBob3cgdG8gdGFsayB0byB0aGUgSS9PIEFQSUMgKG9yIFBJQywgZXRjLikuDQo+IERpc2FsbG93
aW5nIGFuIGluLWtlcm5lbCBJL08gQVBJQyBpcyBpZGVhbCBmcm9tIEtWTSdzIHBlcnNwZWN0aXZl
LCBiZWNhdXNlDQo+IGxldmVsLXRyaWdnZXJlZCBpbnRlcnJ1cHRzIGFuZCB0aHVzIHRoZSBJL08g
QVBJQyBhcyBhIHdob2xlIGNhbid0IGJlIGZhaXRoZnVsbHkNCj4gZW11bGF0ZWQgKHNlZSBiZWxv
dykuDQoNCkRpc2FibGluZyBpbi1rZXJuZWwgSU9BUElDL1BJQyBmb3IgVERYIGd1ZXN0cyBpcyBm
aW5lIHRvIG1lLCBidXQgSSB0aGluayB0aGF0LA0KImNvbmNlcHR1YWxseSIsIGhhdmluZyBJT0FQ
SUMvUElDIGluIHVzZXJzcGFjZSBkb2Vzbid0IG1lYW4gZGlzYWJsaW5nIElPQVBJQywNCmJlY2F1
c2UgdGhlb3JldGljYWxseSB1c3Jlc3BhY2UgSU9BUElDIHN0aWxsIG5lZWRzIHRvIGJlIHRvbGQg
YWJvdXQgdGhlIEVPSSBmb3INCmVtdWxhdGlvbi4gIEkganVzdCBoYXZlbid0IGZpZ3VyZWQgb3V0
IGhvdyBkb2VzIHVzZXJwc2FjZSBJT0FQSUMgd29yayB3aXRoIEtWTQ0KaW4gY2FzZSBvZiAic3Bs
aXQgSVJRQ0hJUCIgdy9vIHRyYXBwaW5nIEVPSSBmb3IgbGV2ZWwtdHJpZ2dlcmVkIGludGVycnVw
dC4gOi0pDQoNCklmIHRoZSBwb2ludCBpcyB0byBkaXNhYmxlIGluLWtlcm5lbCBJT0FQSUMvUElD
IGZvciBURFggZ3Vlc3RzLCB0aGVuIEkgdGhpbmsNCmJvdGggS1ZNX0lSUUNISVBfTk9ORSBhbmQg
S1ZNX0lSUUNISVBfU1BMSVQgc2hvdWxkIGJlIGFsbG93ZWQgZm9yIFREWCwgYnV0IG5vdA0KanVz
dCBLVk1fSVJRQ0hJUF9TUExJVD8NCg0KPiANCj4gPiBJIHRoaW5rIHRoZSBwcm9ibGVtIGlzIGxl
dmVsLXRyaWdnZXJlZCBpbnRlcnJ1cHQsDQo+IA0KPiBZZXMsIGJlY2F1c2UgdGhlIFREWCBNb2R1
bGUgZG9lc24ndCBhbGxvdyB0aGUgaHlwZXJ2aXNvciB0byBtb2RpZnkgdGhlIEVPSS1iaXRtYXAs
DQo+IGkuZS4gYWxsIEVPSXMgYXJlIGFjY2VsZXJhdGVkIGFuZCBuZXZlciB0cmlnZ2VyIGV4aXRz
Lg0KPiANCj4gPiBzbyBJIHRoaW5rIGFub3RoZXIgb3B0aW9uIGlzIHRvIHJlamVjdCBsZXZlbC10
cmlnZ2VyZWQgaW50ZXJydXB0IGZvciBURFggZ3Vlc3QuDQo+IA0KPiBUaGlzIGlzIGEgImRvbid0
IGRvIHRoYXQsIGl0IHdpbGwgaHVydCIgc2l0dWF0aW9uLiAgV2l0aCBhIHNhbmUgVk1NLCB0aGUg
bGV2ZWwtbmVzcw0KPiBvZiBHU0lzIGlzIGNvbnRyb2xsZWQgYnkgdGhlIGd1ZXN0LiAgRm9yIEdT
SXMgdGhhdCBhcmUgcm91dGVkIHRocm91Z2ggdGhlIEkvTyBBUElDLA0KPiB0aGUgbGV2ZWwtbmVz
cyBpcyBkZXRlcm1pbmVkIGJ5IHRoZSBjb3JyZXNwb25kaW5nIFJlZGlyZWN0aW9uIFRhYmxlIGVu
dHJ5LiAgRm9yDQo+ICJHU0lzIiB0aGF0IGFyZSBhY3R1YWxseSBNU0lzIChLVk0gcGlnZ3liYWNr
cyBsZWdhY3kgR1NJIHJvdXRpbmcgdG8gbGV0IHVzZXJzcGFjZQ0KPiB3aXJlIHVwIE1TSXMpLCBh
bmQgZm9yIGRpcmVjdCBNU0lzIGluamVjdGlvbiAoS1ZNX1NJR05BTF9NU0kpLCB0aGUgbGV2ZWwt
bmVzcyBpcw0KPiBkaWN0YXRlZCBieSB0aGUgTVNJIGl0c2VsZiwgd2hpY2ggYWdhaW4gaXMgZ3Vl
c3QgY29udHJvbGxlZC4NCj4gDQo+IElmIHRoZSBndWVzdCBpbmR1Y2VzIGdlbmVyYXRpb24gb2Yg
YSBsZXZlbC10cmlnZ2VyZWQgaW50ZXJydXB0LCB0aGUgVk1NIGlzIGxlZnQNCj4gd2l0aCB0aGUg
Y2hvaWNlIG9mIGRyb3BwaW5nIHRoZSBpbnRlcnJ1cHQsIHNlbmRpbmcgaXQgYXMtaXMsIG9yIGNv
bnZlcnRpbmcgaXQgdG8NCj4gYW4gZWRnZS10cmlnZ2VyZWQgaW50ZXJydXB0LiAgRGl0dG8gZm9y
IEtWTS4gIEFsbCBvZiB0aG9zZSBvcHRpb25zIHdpbGwgbWFrZSB0aGUNCj4gZ3Vlc3QgdW5oYXBw
eS4NCj4gDQo+IFNvIHdoaWxlIGl0IF9taWdodF8gbWFrZSBkZWJ1Z2dpbmcgYnJva2VuIGd1ZXN0
cyBlaXRoZXIsIEkgZG9uJ3QgdGhpbmsgaXQncyB3b3J0aA0KPiB0aGUgY29tcGxleGl0eSB0byB0
cnkgYW5kIHByZXZlbnQgdGhlIFZNTS9ndWVzdCBmcm9tIHNlbmRpbmcgbGV2ZWwtdHJpZ2dlcmVk
DQo+IEdTSS1yb3V0ZWQgaW50ZXJydXB0cy4gwqANCj4gDQoNCktWTSBjYW4gYXQgbGVhc3QgaGF2
ZSBzb21lIGNoYW5jZSB0byBwcmludCBzb21lIGVycm9yIG1lc3NhZ2U/DQoNCj4gSXQnZCBiZSBh
IGJpdCBvZiBhIHdoYWNrLWEtbW9sZSBhbmQgdGhlcmUncyBubyBhcmNoaXRlY3R1cmFsDQo+IGJl
aGF2aW9yIEtWTSBjYW4gcHJvdmlkZSB0aGF0J3MgYmV0dGVyIHRoYW4gc2VuZGluZyB0aGUgaW50
ZXJydXB0IGFuZCBob3BpbmcgZm9yDQo+IHRoZSBiZXN0Lg0KDQo=

