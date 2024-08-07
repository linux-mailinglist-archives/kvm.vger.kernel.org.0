Return-Path: <kvm+bounces-23531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2DF794A785
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 14:09:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 996C3286109
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 12:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A7BE1E4F04;
	Wed,  7 Aug 2024 12:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OBv1CLN+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44761E4EF2;
	Wed,  7 Aug 2024 12:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723032576; cv=fail; b=Ybzc/KPioRbmcRhVPhbnEYwPF4oXkWplGjpqNwVM8VQampvS8oSdQHZm71jErUo1sy7Rv525cA+fggaZ2jro4oJGpMw9EVAMFSyohb9qM2UxCfQNJinFaGE5L62gVhyNqUOIsgm27TyBVFC0g1/VXYepftgXoN2MMEbk++5JNO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723032576; c=relaxed/simple;
	bh=DsmWeTifFGtI3D3RAdcZIKi0fJ6TuOwbPH23RkTeuOs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Dx9cJ5u3uDGUVVILG8f/KPnny+0LcpyLEsgW58Np8QCiv5fL+vo63zCkCmXcw+AIsfCdKuzBrfFeU6XBJuMGcT/9ltZtoEsi5bIlY8HkGxj3MEeWa3brgKaMWWnQlRnr8HSyfqRflx/vD19Tns5iDKwsQkAvBpFCbRwJUQwWI2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OBv1CLN+; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723032575; x=1754568575;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DsmWeTifFGtI3D3RAdcZIKi0fJ6TuOwbPH23RkTeuOs=;
  b=OBv1CLN+pm7QwDMndFEXJlu53Q6RqSujzhSjzCuNY3pwU2jlBCVh4fTY
   u4Adtt9zdZQahlzlh0JPB7rgHWTzK3AcOIa+VnnZdXgwjazZA3sNOtJHy
   5r1N9+Mv3JhX2Mcc/uIVSaeTwAh6jxqrkn5Jv6SZ2uU9M+APFvn5dMKfI
   odpmAdGf178lywqWehGiyWZJLMAYhGerhbVnugdNwHYHFrZy8OxTcMdcj
   4l5fyTCFEd1VM8B/X7NxX135BzxIk919fc2iWaSxuIsp+vvvIJd/2kjdA
   mbQ1RIJ3TURMVq6jVrg63sfxJP3HBJ2SKGGmd7PHrmu4MBQpq1gluvRwl
   A==;
X-CSE-ConnectionGUID: aVTHhkQEQvGfQWAG393/4w==
X-CSE-MsgGUID: 4F/UIS1FT/WOQYL0hsSiSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11157"; a="12900723"
X-IronPort-AV: E=Sophos;i="6.09,269,1716274800"; 
   d="scan'208";a="12900723"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2024 05:09:34 -0700
X-CSE-ConnectionGUID: G7BImAAqTi28MifFKyFcDg==
X-CSE-MsgGUID: S9fnyX91Qk6ooAsOHkh8qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,269,1716274800"; 
   d="scan'208";a="56776327"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Aug 2024 05:09:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 7 Aug 2024 05:09:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 7 Aug 2024 05:09:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 7 Aug 2024 05:09:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 7 Aug 2024 05:09:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BkxYXKIhURdE6s2uJb/Ztk4tC5XPXiklkuBOxtF1FPWyZvTvYpRL66EOQWo9NRwe5U6+YjzMMxy4hPI1Zs/cZVOY5u7FcRWboF1/o093USsdHF7zeQoYodRVtIJ2VX3l0CuA0GKzCOIuYuWjbTOOjQVGn4EHSYKsXCz2TkUQYWFM2OdAfPw3KS+T6JtFFA59w60GvueY+8UGMExCkHQeKa53mr2g4/wCeEmQczbf1pcTpx24TJD6WrOH6aY0fgvJjnEhuwxjF48JOfXJnl4ElHpBwTK7vlG79Opapyw+oWwq5+nwMd4w1dvSBmq5oN6blF3eqC598N2DF49gOcQUYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DsmWeTifFGtI3D3RAdcZIKi0fJ6TuOwbPH23RkTeuOs=;
 b=hpbRn4tg2U0QiMCUk8z2kFwyQt529uwDwLk9m/LT8m4W3uKMKosOjkpSHJidxOoKW+W7yzRvJPHQdhWFtrPT567O1R1wiowVOLaOgDTqxDIJdLmXuOMP1XWnvDT3eeA+pM2shNKK/R5XfBkAlI6MBdqXTCLY+E9TVs7TohRLPbOZq3XxFLe/mKiSS4mQ6OLt2qhyIzDa0W/Zo11HU/fOPrIyTiSOV+PHeDMmMjnbH2EJMalO0DZyVwRLcZIBc14tVI0DUjbZG5dMD/feQtfrEmXj7zJr2dnOnFEj1ApCFLyCfNjNNIVRTHuA6M2p1Z4RYEFWzxdWzWby5+Cou5Al8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CYXPR11MB8661.namprd11.prod.outlook.com (2603:10b6:930:e4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Wed, 7 Aug
 2024 12:09:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 12:09:24 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 02/10] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Thread-Topic: [PATCH v2 02/10] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Thread-Index: AQHa1/rBf1e/y/ONHUu17Yv0cGvYCrIZb5uAgAAKUoCAABHuAIACSXUA
Date: Wed, 7 Aug 2024 12:09:24 +0000
Message-ID: <96c248b790907b14efcb0885c78e4000ba5b9694.camel@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
	 <7af2b06ec26e2964d8d5da21e2e9fa412e4ed6f8.1721186590.git.kai.huang@intel.com>
	 <66b16121c48f4_4fc729424@dwillia2-xfh.jf.intel.com.notmuch>
	 <7b65b317-397d-4a72-beac-6b0140b1d8dd@intel.com>
	 <66b178d4cfae4_4fc72944b@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66b178d4cfae4_4fc72944b@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CYXPR11MB8661:EE_
x-ms-office365-filtering-correlation-id: 2191c63a-c1a6-4f01-22c1-08dcb6d9c718
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?NlFyajh0OTYvN2dKVk0zR25vZE12VVBIWE15eEFMTnB1SFQ3clI2TFlTUXdP?=
 =?utf-8?B?aHZ0VmxsRnJmZXhFa0R4VlZkdndEaFc4SFlBSEhPbHdydlExVXFDMzlKbDFl?=
 =?utf-8?B?dnpFWjAvRzUyejExVHFMcUJLaHNRcWhYZ0s4Y2pHWGNDUXE3ZFJtcmVIdzRi?=
 =?utf-8?B?cmlpN01PdVV3R3prTDVQMmFoTkRMODg3cGlOMjlhMFpSOUtkZjhxMDdLRS90?=
 =?utf-8?B?MmRDLytlT1RUMzN4Njd3L0N3TUtGQ1lhMk5IVHdiUERKWDFlYXVaSUZmVi8v?=
 =?utf-8?B?bkh1STFVbGMwVDlJMUVsbkEwQSt6MFJxc3RYTXpsTC9tNHBIQWxuaE1XeG1H?=
 =?utf-8?B?c1BJZkdMZmRDcmloOGpjMnliOWx2Qk9ieXNtVGlsbXBiVGZsWTdYZUw3emtC?=
 =?utf-8?B?NUwvMnZ3MHFnNFFvbFQybHFFRGIvZ3l3T2pqdk1NaVAyeEttNWVQcDhseWVw?=
 =?utf-8?B?QVpyY2JXcElyRkRlWjVnc1VsNlZsQnJiODJNSlR3U3pMbElMQTdVaDRaN2pk?=
 =?utf-8?B?SEt1aEU2V1FqbmdlWVdlZG1BT3ZxczRJYVFhZTFFWVZFS3NyR0RBcGkxVko5?=
 =?utf-8?B?OVZLeFhRZXRNSEZVOHB3WDhlZndlVmFidTZFU3BDazRMUmNtOWsraUR0cEw0?=
 =?utf-8?B?VGQ4dFpZRCtzZjRjQmRZODRzaU5GbUtrMGFQdW8rQmN3R1UrOTNGYXdObTBq?=
 =?utf-8?B?V2JncFlRUzEwZ1JrZEkwOVNpUm9HSjRzdEcxV2pYNm5XMGhUajdDOC9VOEtR?=
 =?utf-8?B?VVk3VEduUnM5d09hVFRBQU0ySXlsYUVMN0Y0SStoNTU0MUp4aW9Jc0ZwMTFB?=
 =?utf-8?B?VVhNZmR1RjJ1RTJlT1hzWlJFei9TelhCYjRqUTBobUczN2dtTmYwQ2J6eVFt?=
 =?utf-8?B?RDlFeGVTK2dPKzc2MDFkNGt2b2xCWUw3bzQrL0xQMHIyc2RUWVBHcWpUS2Q3?=
 =?utf-8?B?R0s4YUtQOWNVd3J0Q2o4U2pnSjJWQVVnUEdUcVZjUEtOanZaTjlJWFY5SSti?=
 =?utf-8?B?UDZucCtJOHlXRTdBRnFjZCtKMS9SaDRnM2pSb05RRDdoaFU3alNBaFNnZzRO?=
 =?utf-8?B?b2RSYUV1Nk1kM2VTdlhhNk9SN2V4NFh6eGtYN04yWGd3QklTSkdISHowbGtR?=
 =?utf-8?B?T20rTU1NRkdBdE56M3hBeGV4T1pRZkY1QnZVcTR3QngyY2dSRldJNllTZFcr?=
 =?utf-8?B?bTIzMXBLMDVRVXdsMTgwRkRBV2ZJbXhtVGQ1MHR6L3RqOXk4SmNlMVNRbEtS?=
 =?utf-8?B?bFhwckZBc3BhcFM5V1lXZmx0SFZxQWFxSE1YZFRVUGJibVN2R3Z0L2dDL0s3?=
 =?utf-8?B?T0FSbGhpV0pLdzZhVFNvSWlnN0NXSUtiL0NtT3BYYlhMcTN0bW1tdERFSEFS?=
 =?utf-8?B?VlFqOFprUmlRT0hJbmtGdWorLy9KU1psbTNHY0RraURUUDVoOFJXbjNEM0x5?=
 =?utf-8?B?Z3lBSDYrWWEwc1BMVVVCSkJ6cytrU1ZxNzcwbksvSlBzdnUva0VCYTF4UjFT?=
 =?utf-8?B?bU1melRZR2hENi9WdllFTHVyZU92dVBKelJwb1JVZXdaQVMrWU9YdVlZVFA1?=
 =?utf-8?B?OWxrbkY5U0Rqb3MxNmdFV2RyTXd2bzJnb1dNVGRVbVZkWkthOFFsdkpobWRK?=
 =?utf-8?B?QlY5M25Gc3pQcWlpYVV1clNXRFNwcmtkWEpydFA2QTZDVnhXdVlETEF2djBU?=
 =?utf-8?B?UEVjanF4b0ZicGlHL1p4MEpSN2k3OEVUaWFVUWI2L01PT2RFYnNBMkFRM2c4?=
 =?utf-8?B?RGd1bGo2ZHBwS09LQUY2M3pJMUx4K0Q4SzM5SCt2cS9YR2ltazV1Z2J0R1Vv?=
 =?utf-8?B?Ly8rcFU5eFlrS0lONEM3cXdQRytZbEJ1ek5meEh4OWx0ZVdyQkpFN01nZ1B1?=
 =?utf-8?Q?M1hRbTvu5E8yF?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TktMSzdPeDRGU1Q1bTBQT1N2a3NDd3pzaGFGdTdDOG8wQVd2SG10MHNKRzVV?=
 =?utf-8?B?aE5TMGQ1MGkxTUJtcXQvMzZkakNTQkg1V1QvMmVtV0Y2RkR3Q1pXU2IyZWN3?=
 =?utf-8?B?dWRhbGZTSWk1TytxR2MwUEJZaUE5S1VxYWNBVXpOL1JyNGtSTU1VU2ZMU2pL?=
 =?utf-8?B?R0h5a0oyNk9PZHNqZHpZcDYvQm5VcHdXcW1BODZtTDZoYUhYbE12c2tYa09v?=
 =?utf-8?B?eEdueGNRVHhpMFNGVTJENjN4a1UybkhaR0xWbDAyMTNmOHF4WnZFRCt0a2dU?=
 =?utf-8?B?eG14Q01kSnZObmZnNGFiUkdqWXVtZ1oxRTVSdUJtajkyNmlONHBRQjhzSkhi?=
 =?utf-8?B?dTJlYTQ2b3VYYnlQZVBCWlZ6ekJSTUV3ckx1aDAwZnREaVpRelBCVnVuMmRH?=
 =?utf-8?B?N00zdEcxNHVrRFNycGpnTVJHUWlkajhRcGFDOUNlL2l4SlhSdkhYVWJJUE5a?=
 =?utf-8?B?YWZZbTRiTlFIdnpNQVAwVUxubHFCRjFqQ2ZvS1JwVTJ6RDFuMmdlWFd6ckZZ?=
 =?utf-8?B?OTMxRFpYeTFacUtGcjZxMzFGVHhNQXV6Q0NsS3lKVWlaQ3V2QzZmbDhWQ1Ft?=
 =?utf-8?B?M1JWREtPNFF4MGdEbXV0ZG1Fak1sYW1IZlRlOHcxcjhITVdMbU1LNHBEcXpE?=
 =?utf-8?B?OURzVmlhMWdzN1l6dkFMZGlmT2w0Wnk0elZXVlAyU1p0WlgrUTNONWhmT1FB?=
 =?utf-8?B?UnRNM2xpbDhtZXpqZVNuL2IydXBZRlVUb3JsOEVZWlpiUFZaZVk1c1hDcGFI?=
 =?utf-8?B?QUw5WTNaN24xYkQ5TVpwOVY4VmlDVWVJWHY0TWJIaWZTNHBhK25Ocy9JMkpn?=
 =?utf-8?B?bCtzSlJJZzc3bDVtWWJjdDN0d3c2OWRZa3RNOVZFUEw0MHRnOEZoTHNxQThH?=
 =?utf-8?B?Yzd0bnlyTCtVR2txeUR2cElyMVR5azFsY2I4cC85TWNTVHFJVG9LVWY0MTZI?=
 =?utf-8?B?SWY4VjQ2amk4M2l0ZE9TRTJlTFM3WGUralQ4aHpWYmVVbDlGNHg2WkovUW03?=
 =?utf-8?B?SkEwRlVOcThPeDlxQkROQW8xU0hMVnV5NDhJa1ZGb2VuWGxMN2pJYWkvNS9R?=
 =?utf-8?B?TmtIRHBGZ3BON0RuMjY5dnlVaEx4bGlFa2R2YXFNeVhCWGcyOTN1Nm1yb0lt?=
 =?utf-8?B?SXJpYWloeVJBcFltNzRpWERFWHM2MjNlSThML0xybHJpcUxjUTJrb2htRXZW?=
 =?utf-8?B?MzdPNThCK0RRQVJUV1FQTnViUURqNUhtUnUxaXFDQnBtWnF4Ylh0ZlVpdk1q?=
 =?utf-8?B?RmZEOVJzMHR3TGY2ek9KbmszQ0VxdHhibWl5eXRmdXZ3dCs1Tjh2ZUtVR2NL?=
 =?utf-8?B?Z1EvZXhxMVI0UmlpUUxQV24xUmV0bC9tU3JxemNTR3k3a0tpQ2NGZWkvcGRE?=
 =?utf-8?B?Wi8wdWR2SmE5ZFZPM2RTYnJpSG5jN1RldWIrUFJTclB6TG9lcDAyOGVTakJB?=
 =?utf-8?B?K3Z6NjZjUXNmZ3NEV3pBaTFrZ2ZTUDlycnYzeExqdy8wSTRqSVBncVdqRDNi?=
 =?utf-8?B?SmQ5TUxZTFYwR1FhS3czVFlwZEtEbUFxK3JJa2djdVpPT2lQdmp2MitvUlY1?=
 =?utf-8?B?UzZGR2twdXhLcXhINjNXWnZzZ2dFTDMwaTI0UVFCMnAvT09PUGFNQ3NPT2l0?=
 =?utf-8?B?dGQrMVJFak1yNlRiYUlvd3lSajRpYzRncTV4a3U3Z2FwMlp2ZkMvc29tUnZk?=
 =?utf-8?B?QVd4ZnB4VDlhdGptZFlDbnVIbTQwU1gxYXFqbTJRTnk1TGVnRjBuRFRndUQ4?=
 =?utf-8?B?aEtVTmpYUmZjdnNoWkV5VndXaGxkZWNjRFlXQmhMUzAvUXQvNG9rWStoZGJn?=
 =?utf-8?B?MmpWemV2eEN5MEMxWXhnT0dGbUVXUy9UU2dmcWNJNHZDRU1IUGpoN1VLTTVL?=
 =?utf-8?B?YjJaajRIRk8xOGNWZ3dHZnFzRTlvUTcvOE14cmJzbHo5dk15N0E3Y2IrSTBB?=
 =?utf-8?B?OTBveHl2emJ4SXJnZ0FjbEpYR0NLRUpaUmlZMTNTWlZHaDJDWTcwMElKb3p3?=
 =?utf-8?B?UXVNd3ZMQVdsc2tCSTR4Rm40L3kyQUlXN3NVR0tqK2hLa2VFSXNZdzd6bThj?=
 =?utf-8?B?RUxNRmpPSlI5MEZHbVo4MHZCUGFrS0NNZzlsOHIxelI0T2UvOFFDc3g0OFVt?=
 =?utf-8?Q?Lgd9XOYejcLmsho0dxo/6wWDR?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A50F282247FD3B41A08F6151D716B261@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2191c63a-c1a6-4f01-22c1-08dcb6d9c718
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2024 12:09:24.3912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 64dV3YgebfMTnIeTU5oT0zsnI9mcAJt5meNxoN/Qog/o2whwEK8iqcGnWL73K/OSnyh5vWueVMKn4piq+WzP1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8661
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTA1IGF0IDE4OjEzIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEh1YW5nLCBLYWkgd3JvdGU6DQo+IFsuLl0NCj4gPiA+IFRoZSB1bnJvbGxlZCBsb29wIGlzIHRo
ZSBzYW1lIGFtb3VudCBvZiB3b3JrIGFzIG1haW50YWluaW5nIEBmaWVsZHMuDQo+ID4gDQo+ID4g
SGkgRGFuLA0KPiA+IA0KPiA+IFRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KPiA+IA0KPiA+IEFG
QUlDVCBEYXZlIGRpZG4ndCBsaWtlIHRoaXMgd2F5Og0KPiA+IA0KPiA+IGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2xrbWwvY292ZXIuMTY5OTUyNzA4Mi5naXQua2FpLmh1YW5nQGludGVsLmNvbS9U
LyNtZTZmNjE1ZDc4NDUyMTVjMjc4NzUzYjU3YTBiY2UxMTYyOTYwMjA5ZA0KPiANCj4gSSBhZ3Jl
ZSB3aXRoIERhdmUgdGhhdCB0aGUgb3JpZ2luYWwgd2FzIHVucmVhZGFibGUuIEhvd2V2ZXIsIEkg
YWxzbw0KPiB0aGluayBoZSBnbG9zc2VkIG92ZXIgdGhlIGxvc3Mgb2YgdHlwZS1zYWZldHkgYW5k
IHRoZSBzaWxsaW5lc3Mgb2YNCj4gZGVmaW5pbmcgYW4gYXJyYXkgdG8gcHJlY2lzZWx5IG1hcCBm
aWVsZHMgb25seSB0byB0dXJuIGFyb3VuZCBhbmQgZG8gYQ0KPiBydW50aW1lIGNoZWNrIHRoYXQg
dGhlIHN0YXRpY2FsbHkgZGVmaW5lZCBhcnJheSB3YXMgZmlsbGVkIG91dA0KPiBjb3JyZWN0bHku
IFNvIEkgdGhpbmsgbGV0cyBzb2x2ZSB0aGUgcmVhZGFiaWxpdHkgcHJvYmxlbSAqYW5kKiBtYWtl
IHRoZQ0KPiBhcnJheSBkZWZpbml0aW9uIGlkZW50aWNhbCBpbiBhcHBlYXJhbmNlIHRvIHVucm9s
bGVkIHR5cGUtc2FmZQ0KPiBleGVjdXRpb24sIHNvbWV0aGluZyBsaWtlIChVTlRFU1RFRCEpOg0K
PiANCj4gDQpbLi4uXQ0KDQo+ICsvKg0KPiArICogQXNzdW1lcyBsb2NhbGx5IGRlZmluZWQgQHJl
dCBhbmQgQHRzIHRvIGNvbnZleSB0aGUgZXJyb3IgY29kZSBhbmQgdGhlDQo+ICsgKiAnc3RydWN0
IHRkeF90ZG1yX3N5c2luZm8nIGluc3RhbmNlIHRvIGZpbGwgb3V0DQo+ICsgKi8NCj4gKyNkZWZp
bmUgVERfU1lTSU5GT19NQVAoX2ZpZWxkX2lkLCBfb2Zmc2V0KSAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIFwNCj4gKwkoeyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiArCQlpZiAocmV0ID09IDApICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gKwkJCXJldCA9IHJlYWRfc3lzX21l
dGFkYXRhX2ZpZWxkMTYoICAgICAgICAgICAgICAgIFwNCj4gKwkJCQlNRF9GSUVMRF9JRF8jI19m
aWVsZF9pZCwgJnRzLT5fb2Zmc2V0KTsgXA0KPiArCX0pDQo+ICsNCg0KV2UgbmVlZCB0byBzdXBw
b3J0IHUxNi91MzIvdTY0IG1ldGFkYXRhIGZpZWxkIHNpemVzLCBidXQgbm90IGp1c3QgdTE2Lg0K
DQpFLmcuOg0KDQpzdHJ1Y3QgdGR4X3N5c2luZm9fbW9kdWxlX2luZm8geyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgdTMyIHN5c19hdHRyaWJ1dGVzOyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICB1NjQg
dGR4X2ZlYXR1cmVzMDsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgDQp9Ow0KDQpoYXMgYm90aCB1MzIgYW5kIHU2NCBpbiBvbmUgc3RydWN0dXJlLg0KDQpUbyBh
Y2hpZXZlIHR5cGUtc2FmZXR5IGZvciBhbGwgZmllbGQgc2l6ZXMsIEkgdGhpbmsgd2UgbmVlZCBv
bmUgaGVscGVyDQpmb3IgZWFjaCBmaWVsZCBzaXplLiAgRS5nLiwNCg0KI2RlZmluZSBSRUFEX1NZ
U01EX0ZJRUxEX0ZVTkMoX3NpemUpICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCnN0YXRp
YyBpbmxpbmUgaW50ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBcDQpyZWFkX3N5c19tZXRhZGF0YV9maWVsZCMjX3NpemUodTY0IGZpZWxkX2lkLCB1IyNfc2l6
ZSAqZGF0YSkgICAgXA0KeyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIFwNCiAgICAgICAgdTY0IHRtcDsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQogICAgICAgIGludCByZXQ7ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCiAg
ICAgICAgcmV0ID0gcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoZmllbGRfaWQsICZ0bXApOyAgICAg
ICAgICBcDQogICAgICAgIGlmIChyZXQpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgXA0KICAgICAgICAgICAgICAgIHJldHVybiByZXQ7ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIFwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQogICAgICAgICpkYXRhID0gdG1w
OyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KICAgICAgICBy
ZXR1cm4gMDsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwN
Cn0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIA0KDQovKiBGb3Igbm93IG9ubHkgdTE2L3UzMi91NjQgYXJlIG5lZWRl
ZCAqLw0KUkVBRF9TWVNNRF9GSUVMRF9GVU5DKDE2KSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgDQpSRUFEX1NZU01EX0ZJRUxEX0ZVTkMoMzIpICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANClJFQURfU1lTTURfRklFTERf
RlVOQyg2NCkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0K
DQpJcyB0aGlzIHdoYXQgeW91IHdlcmUgdGhpbmtpbmc/DQoNCihCdHcsIEkgcmVjYWxsIHRoYXQg
SSB0cmllZCB0aGlzIGJlZm9yZSBmb3IgaW50ZXJuYWwgcmV2aWV3LCBidXQgQUZBSUNUDQpEYXZl
IGRpZG4ndCBsaWtlIHRoaXMuKQ0KDQpGb3IgdGhlIGJ1aWxkIHRpbWUgY2hlY2sgYXMgeW91IHJl
cGxpZWQgdG8gdGhlIG5leHQgcGF0Y2gsIEkgYWdyZWUgaXQncw0KYmV0dGVyIHRoYW4gdGhlIHJ1
bnRpbWUgd2FybmluZyBjaGVjayBhcyBkb25lIGluIHRoZSBjdXJyZW50IGNvZGUuDQoNCklmIHdl
IHN0aWxsIHVzZSB0aGUgdHlwZS1sZXNzICd2b2lkICpzdGJ1ZicgZnVuY3Rpb24gdG8gcmVhZCBt
ZXRhZGF0YQ0KZmllbGRzIGZvciBhbGwgc2l6ZXMsIHRoZW4gSSB0aGluayB3ZSBjYW4gZG8gYmVs
b3c6DQoNCi8qDQogKiBSZWFkIG9uZSBnbG9iYWwgbWV0YWRhdGEgZmllbGQgYW5kIHN0b3JlIHRo
ZSBkYXRhIHRvIGEgbG9jYXRpb24gb2YgYSANCiAqIGdpdmVuIGJ1ZmZlciBzcGVjaWZpZWQgYnkg
dGhlIG9mZnNldCBhbmQgc2l6ZSAoaW4gYnl0ZXMpLiAgICAgICAgICAgIA0KICovDQpzdGF0aWMg
aW50IHN0YnVmX3JlYWRfc3lzbWRfZmllbGQodTY0IGZpZWxkX2lkLCB2b2lkICpzdGJ1ZiwgaW50
IG9mZnNldCwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpbnQgc2l6ZSkgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIA0KeyAgICAgICANCiAgICAgICAgdm9pZCAqbWVtYmVy
ID0gc3RidWYgKyBvZmZzZXQ7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAg
ICAgICB1NjQgdG1wOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgDQogICAgICAgIGludCByZXQ7ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCg0KICAgICAgICByZXQgPSByZWFkX3N5c19t
ZXRhZGF0YV9maWVsZChmaWVsZF9pZCwgJnRtcCk7ICAgICAgICAgICAgICAgICAgDQogICAgICAg
IGlmIChyZXQpDQogICAgICAgICAgICAgICAgcmV0dXJuIHJldDsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgDQogICAgICAgIG1lbWNweShtZW1i
ZXIsICZ0bXAsIHNpemUpOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAg
ICAgICAgDQogICAgICAgIHJldHVybiAwOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICANCn0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KDQovKiBXcmFwcGVyIHRv
IHJlYWQgb25lIG1ldGFkYXRhIGZpZWxkIHRvIHU4L3UxNi91MzIvdTY0ICovICAgICAgICAgICAg
ICANCiNkZWZpbmUgc3RidWZfcmVhZF9zeXNtZF9zaW5nbGUoX2ZpZWxkX2lkLCBfcGRhdGEpICAg
ICAgXA0KICAgICAgICBzdGJ1Zl9yZWFkX3N5c21kX2ZpZWxkKF9maWVsZF9pZCwgX3BkYXRhLCAw
LCAJXA0KCQlzaXplb2YodHlwZW9mKCooX3BkYXRhKSkpKSANCg0KI2RlZmluZSBDSEVDS19NRF9G
SUVMRF9TSVpFKF9maWVsZF9pZCwgX3N0LCBfbWVtYmVyKSAgICBcDQogICAgICAgIEJVSUxEX0JV
R19PTihNRF9GSUVMRF9FTEVfU0laRShNRF9GSUVMRF9JRF8jI19maWVsZF9pZCkgIT0gXA0KICAg
ICAgICAgICAgICAgICAgICAgICAgc2l6ZW9mKF9zdC0+X21lbWJlcikpDQoNCiNkZWZpbmUgVERf
U1lTSU5GT19NQVBfVEVTVChfZmllbGRfaWQsIF9zdCwgX21lbWJlcikgICAgICAgICAgICAgICAg
ICAgIFwNCiAgICAgICAgKHsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIFwNCiAgICAgICAgICAgICAgICBpZiAocmV0KSB7ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCiAgICAgICAgICAgICAg
ICAgICAgICAgIENIRUNLX01EX0ZJRUxEX1NJWkUoX2ZpZWxkX2lkLCBfc3QsIF9tZW1iZXIpOyAg
IFwNCiAgICAgICAgICAgICAgICAgICAgICAgIHJldCA9IHN0YnVmX3JlYWRfc3lzbWRfc2luZ2xl
KCAgICAgICAgICAgICAgICAgIFwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBNRF9GSUVMRF9JRF8jI19maWVsZF9pZCwgICAgICAgIFwNCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAmX3N0LT5fbWVtYmVyKTsgICAgICAgICAgICAgICAgIFwN
CiAgICAgICAgICAgICAgICB9ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIFwNCiAgICAgICAgIH0pDQoNCnN0YXRpYyBpbnQgZ2V0X3RkeF9tb2R1
bGVfaW5mbyhzdHJ1Y3QgdGR4X3N5c2luZm9fbW9kdWxlX2luZm8gKm1vZGluZm8pDQp7DQogICAg
ICAgIGludCByZXQgPSAwOw0KDQojZGVmaW5lIFREX1NZU0lORk9fTUFQX01PRF9JTkZPKF9maWVs
ZF9pZCwgX21lbWJlcikgICAgIFwNCiAgICAgICAgVERfU1lTSU5GT19NQVBfVEVTVChfZmllbGRf
aWQsIG1vZGluZm8sIF9tZW1iZXIpDQoNCiAgICAgICAgVERfU1lTSU5GT19NQVBfTU9EX0lORk8o
U1lTX0FUVFJJQlVURVMsIHN5c19hdHRyaWJ1dGVzKTsNCiAgICAgICAgVERfU1lTSU5GT19NQVBf
TU9EX0lORk8oVERYX0ZFQVRVUkVTMCwgIHRkeF9mZWF0dXJlczApOw0KDQogICAgICAgIHJldHVy
biByZXQ7DQp9DQoNCldpdGggdGhlIGJ1aWxkIHRpbWUgY2hlY2sgYWJvdmUsIEkgdGhpbmsgaXQn
cyBPSyB0byBsb3NlIHRoZSB0eXBlLXNhZmUNCmluc2lkZSB0aGUgc3RidWZfcmVhZF9zeXNtZF9m
aWVsZCgpLCBhbmQgdGhlIGNvZGUgaXMgc2ltcGxlciBJTUhPLg0KDQpBbnkgY29tbWVudHM/DQo=

