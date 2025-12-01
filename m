Return-Path: <kvm+bounces-65048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 31F20C99666
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 23:39:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 622E84E2537
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 22:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEA6C286897;
	Mon,  1 Dec 2025 22:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CKgTHPAS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67256221282;
	Mon,  1 Dec 2025 22:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764628754; cv=fail; b=U6WGyTRPyAwDSEW6hLwwDc2IsHk8zAwW14FU7Eap0pFDJxE6vH8O3BCsTFNwO49czPxUZLvpC/bnYHYZPNqfw0miQ5N9OpJc67uJvYPjP/gs1+gZAZlODnY8NqoDQ/RpZM9pYcQI1btCst9r3CMzcxmobKTWtkIRHgRSPd+DkpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764628754; c=relaxed/simple;
	bh=zKN3wY9OSdD3IDdyv/f8HiYQ1zbSmSsaCVEGpPuxESI=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GLKyas5iKCUoPIKd0e/fpj1TOtKPXRPTaBb+T4OL3sSPHtq2PVaAkt8UAnQ/JELNCnN6qe0VYHPhp4QneGK6zXB4oJ+hXmUdDXfjjbzssAMNsE612b6/j4aiqIoDNL4UKJw0npuyYu2e/MRrir73nxzLUTjCsU6c6GiBvwFat+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CKgTHPAS; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764628754; x=1796164754;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=zKN3wY9OSdD3IDdyv/f8HiYQ1zbSmSsaCVEGpPuxESI=;
  b=CKgTHPASEn9PIdjei/BMkQ0ccITBu34T8kwBossULxiezFH8Y6i1IAZ/
   asKe3Az7Cc/xaTI+rZV7k5P/QwpvZSi1fdbNTjs+8eg7e5E1+d6KbqP+3
   eme+ltVtv4KWEjunhFZXY04BffONTJ5wdu5SlXoAmi+8SZQtpMgRYJdc9
   NlC9R1GujrR2rvHZ7AS20gARvUDwl20qLEogWVNwlPhnPtQH1l3IVJ9ns
   EJLIkhOXl+ATi+uOEx3oupFhxaIwLf6RrDkGcsw2YBAwyLKZL6C/ZsbBx
   rgT2WHPAtmkFpFNhQdjjHiub19/zaNplW1a/x6W0jE05xjYOF2AGuoNZO
   Q==;
X-CSE-ConnectionGUID: oFyHBNdIRR+agtp/7rxcaA==
X-CSE-MsgGUID: LtUbqYQyTGCEMxbN3f9gbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="65770883"
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="65770883"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 14:39:13 -0800
X-CSE-ConnectionGUID: GDc5R+DMQFG8fL4jFu/YAw==
X-CSE-MsgGUID: qGhxYddCTZyzRAx98LuvxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="231512256"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 14:39:10 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 14:39:11 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 1 Dec 2025 14:39:11 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.34) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 14:39:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P2Bz5fuBPqvq1Ad0vNLnHep8vtt+OwvjGFiTNVKV8UTE8OP5N8C/a3E9kEdsl8U5P6UI2Tj2EDGniZjQLQ1nzHFCDjmqBtqRVkPIFREQPK2UhRX0dmJjPBTbtgxlyt/cmPlz77RJtG+F8vlK59tXZNea4CTHzuLy/+SWebEa0f+UWLIF16wKj2xN47OyEJ9HFGNoG0xM19WsdGLSdw4Ry2Io2G/ksnWmU8Ud2zLTKt2swPs+v1DV4MCXCg7Kn3o0wmL8rqRPuSdJ9B8V/DQXP8ALYn4guJpQ8gd8J/p2W/uhC9owfVWHunqWEZQIU1LuLWlN8cn+cDcxOZ5UXhXvhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zKN3wY9OSdD3IDdyv/f8HiYQ1zbSmSsaCVEGpPuxESI=;
 b=rl2JyEZQTJ3tQNyEY2cpUo/f8FehO6AvQhhJBo5LG1uhSSUJdhzx2PXdddUnd/e3fI3b3+Mb56W1+Ad2AzimpmH1tj25H1EP1FQ5gTIrhfEIkHqpXd/0c6l5tt//TAePe0SJQNeDt9dwiJIiWUa/v04AqjC+hkRqBbwvksXB49Sr/pVGZ8hWWyKN3OrMkYFrtZXs9Yi1hL/jWbUuZBporOa+tP5pGPnZf/Rk+65Cyn0ba6j6VFwsRGtRhYWX4FfYI8MeGETUGx65aE7DlEUKUj8YengTCz7cNSX5+wIDbSw+6iQXtuqoVKKkqLHQ+xSNNKU50nqx+E/tTHtIi/NGWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5782.namprd11.prod.outlook.com (2603:10b6:510:147::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Mon, 1 Dec
 2025 22:39:09 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 22:39:09 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcWoEIh3ODz6GbaUW93Yfuwe0KJ7UGu/sAgAa1nwA=
Date: Mon, 1 Dec 2025 22:39:09 +0000
Message-ID: <730de4be289ed7e3550d40170ea7d67e5d37458f.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
	 <dde56556-7611-4adf-9015-5bdf1a016786@suse.com>
In-Reply-To: <dde56556-7611-4adf-9015-5bdf1a016786@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5782:EE_
x-ms-office365-filtering-correlation-id: 7e8d3920-7bca-4582-7831-08de312a713e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?N1dwV1NUYVdmNStycjhrNzQ1STBSZThXMUxTa2ZuK2h4cVEvMUhwSU42S25S?=
 =?utf-8?B?R1dCRWc2VHpyNXRGTklwdVYrTnRkaHowc0NCNFFhd0dKb1UwUkZNWlR0Nnhi?=
 =?utf-8?B?NTVYTWEreUtpUFlqM1JvbzVFQkR5MFl0KzdQMHdHL2FDc3E3TXl2ZTIxNUdJ?=
 =?utf-8?B?SFhINE9jWFNFYndZU08wOU4rLytpTEtLVWNkM3BBUG5lUU5GTElWWWxuLzU5?=
 =?utf-8?B?U1FxVUZvWTN0YzkvMzY2dy9Hc2V1SzhQcjA5MDdNZWlaUVZJWmhEbHZ6R1ph?=
 =?utf-8?B?TGRRQkFraFlZSDl0SG5tOEVUTGFlZ25PNHBCQXBqVzhVMVkxWWd4eFhXMUNM?=
 =?utf-8?B?T2lxZm0rdHlmTlRUYjhLU1dtZWdQMm9oM25qNWRvNU1zVVljS3dHRHA3MWN2?=
 =?utf-8?B?OG1DWk5SaXJJTmo2QTBpZDVOclZ5WlN4YUhBL1d2ZXArUTN1Mys1TXZVRjI4?=
 =?utf-8?B?bE5XbnpvRHZjSHhZaGNSYmVHcXpFSFM0QllWSTVmTHpIRnVLdnZSK0J5aDNH?=
 =?utf-8?B?YXFHaWs5YTE1SEVCRy9GT2x4ZllTUlNsS3psOWo1UU9UaGZJcDBTR2pRMk1G?=
 =?utf-8?B?SjhoV2FwQ0FKcWZka2QvcFFpamlwRTNHZzVLNlpRWFZJYjdrOUU5cDdmdDJk?=
 =?utf-8?B?MGVkdHk0VCtNN0tlY2NDSkNCTlYyY294dXJJRHhYbE1GRHV3NVVRdUl5OVZy?=
 =?utf-8?B?bW9wVkRHd2NtV0V3STdDcmdkYytKUGgrbnlEYkE4cGQ0eG1uVk9uWjZQK2ZN?=
 =?utf-8?B?bldjaUF1cXd3VDBXelFYYnZCT1R0WVAvalVBelRNYXZOTjBPTStrWGc0QVlE?=
 =?utf-8?B?UXJIK01CQWVnNlBBSDMxM2FWd1NIanRwS2Y1VDJpSEFjWHFzaVlqenpySEtu?=
 =?utf-8?B?dGw2Q05ieVNwQ0cvR085dlJoTTZhTllBNEFLeFpITjVjdHE4NkFRckJTWXdZ?=
 =?utf-8?B?UUgyVm5qWXZqaWxsV01DS1UyL2xZaXBiUG11QkpScW1tcnBybUNXMlNDYjhO?=
 =?utf-8?B?TXVRQ1U1RWdkSGJmRTA3azBtTDFzNU05OVlkMlVFU2tuSnBFSVJPVU1iMVFI?=
 =?utf-8?B?QlZxYWd1UHQ5MHBwejNRK3h5RVptUHBmTkpDdWJEeFhtYnU3dE55V2V0TnpG?=
 =?utf-8?B?eHZaYTk4QWpQRDFkUllhOUMrcEVVUHhycFBkNE5kV3lFNTVlc1ByNTNBYVpW?=
 =?utf-8?B?NGNxaHNsbHF1QmRmaVA1dTFXSkpjWjl0cDRBUzROckdMSHREYzdBQ1hpdGlC?=
 =?utf-8?B?RDZPVWZMZFZVZUlvNUNjWnpEeVFGRGl0WlBuS2UrYzdDd0JHMEQzOEZXbkVJ?=
 =?utf-8?B?NVlqcldnSG5reEI1WGZpejAzVWZtR0ZBeVB3cVpLaFNkdHFrc0RVRXFzcmxN?=
 =?utf-8?B?eUhBM0JVREJjdFNYTCs4bHVTaGl5Yzlnb285S3oraXlVZFVJRzZqYUpsTndk?=
 =?utf-8?B?U0lvSlBrZld4a3RFclNDaWFxQ3lkeFladS9jYUFTdFlBeGZXQmlWQUl6TjZj?=
 =?utf-8?B?Nld1M0NJSHl4K0k4WS94N1NjdzJyQ1hRdzhDdXNxTGVVdk1DRFNtb0cvODlw?=
 =?utf-8?B?U3Q1YVo5ekNpTFBENk9rNlJhYk90TTV1ejFpeFB5cXFscU5JWVlYZ3l1UUpy?=
 =?utf-8?B?RElmZU9NK0xJdHc5L0FOcjAycFJxSkp2KzdDT21jQ3gwcjc4bXRPQWNnSWdW?=
 =?utf-8?B?cUlBVGlyMTRxV1RkYlFGcXYwUkRJd0tEeEg4RUg1bFJZMlFmQmdqdHdtbnJ2?=
 =?utf-8?B?U3dBdFRsb0cvK3oreHFSazlBNFpCVVdQMlhyZWVKditvZzF5U2g5MnQyYy9y?=
 =?utf-8?B?WTY5UWxVdUxpNDF2Y1Q2REF6NllYUW51ckh0dlpnS3JZNVNoNnRQUFB1d0ps?=
 =?utf-8?B?VGhGbytweVR5QlA5TnFrL2xkTWJaajdGZnpTaUFMTzBvZjQ5ZVdzWmp6WnNh?=
 =?utf-8?B?a05xTllLUnVjazUweCtGUEVMaDcvRlZjNkU2aG9SNEFLNTZPODB1K0t1Y3lP?=
 =?utf-8?B?UXJFU0xDSE9OVlRsUGF6ZWRVbW9aekRjTFBXcTFoNEtiTzRobGI0RG50TmVR?=
 =?utf-8?B?bVRtQkMwLzF6V0IzNXNHbGJkQk9nZG5wM0dpZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0VPZXJLcHpnakIrckhZbEpPaVVZNTlGaHR4V1hhcmVUaGpaNUVpeDBUMEtW?=
 =?utf-8?B?MTdKVHAyNUJnTFJ2eVFBTTA5dEcranFpVlZWWFpXblQ3OWlHZnhKSjB2b0dy?=
 =?utf-8?B?SGtCVnJ4S2ZzcGlIY0J3clNBcHU2N2Y4MzdwMG5VUGgxdzJDSFl6cUEyNzZj?=
 =?utf-8?B?WmlxWllIN0l4TW8wbnBRWXBJYjNiVzZzTHVRQXJSMkQrblV2RXhDUWpCQnZM?=
 =?utf-8?B?OEFTeGVtTnh0MlM4QmJmd1h3K2pVNm5ERUZ1RlN1T1VOQW0ranlKZDlxVmEx?=
 =?utf-8?B?YUY2NlJtdnRDWTVQVWdXT2NzeUxWV29HQjZWOHlqM1U5WjVVU3JKcVFaeUFT?=
 =?utf-8?B?T0UyUVdCZHcvK0FwcC94SWp6b3dpS04zYzdoM1gwVWFxTUZUeWVkbjFqZHZh?=
 =?utf-8?B?Mkx6b1N5aVIyNWRlUk1JcUs2N1hzZE40eVF2bXBnNUVVU1pWU3RhSWVkVXgr?=
 =?utf-8?B?OGwxZkFUUFcxbDlqMHdEN1pHRDBjdnpCQ3pudkw1T2dSUDNTaFN5VnNtLy9u?=
 =?utf-8?B?TXBHUk5lMk5Uc3Uwb3k2SXJkY2M1RGszQ0k0ZU5CQ0M5eGI0S1oyLzRLTS91?=
 =?utf-8?B?Uk9tTndFOEVnQnZPSVZMcCtJc3IwWXhGL1pjYzN2SFROV3FzRjFNOEFCL1hi?=
 =?utf-8?B?ZVpUeFRLVFZxUXRyL3hra1hWUGFGSTdsMUQzZzJYeWhTY0dHY3UvVXBpUnYz?=
 =?utf-8?B?L2hkcDZXT09aaW93SEt4TE5YWGZqRnZJNFpNak1rSlkzb2pJdld1TzJLdERX?=
 =?utf-8?B?ZUhINmJmU0I0eUFoNU8rdVQwY0s1NWpoT3NxZnZwVEg3a1hJMnBtNU01U0JM?=
 =?utf-8?B?WVJ3Y0hCLzFrS3RmdjcrUlp3YktaeEJLTFdzNlZEUFgwS1RLd2xqWXBBV1Ez?=
 =?utf-8?B?dFJGRUYwcE5zd1RGUDcyTWR0UUZBdDJ5a1dOdjlicTJoRnN2ejh1c2VTTXZs?=
 =?utf-8?B?OEtaZG5za3Rhb1g0N2xaN0JZWkNWVko2UkNyMk5ZTDZwYktKdnNKL09URDZC?=
 =?utf-8?B?R21URjUvcDNrV2VBM1FLc0V3Y0txKzM1NlY5RmNka2IvTkMwNDA3VEdZaHk1?=
 =?utf-8?B?OU5WSTA4RHE2Z2l5VEhsV2dVcllwTTVxc0FWNS9XeE9tUkMyQUtEMVcrMHpo?=
 =?utf-8?B?SGdRdlUyZGhZZlFiK1BBZk0zS1UwN0k1d1NXL09DVFkzbkJzVXk3UDlSbjJv?=
 =?utf-8?B?N2NPc01IbldjQWRUV2VBcTBpKzQ2dGNxVEMwa1Y1SnVtNUVGVXRjSnZ6a1Zp?=
 =?utf-8?B?WHFHdGp6cjk0VmZ6cExzNlowNDNXeDJSRjZoNFJ0NmNvUlhYekdTVnZ6V1hK?=
 =?utf-8?B?QzUvR2NZQ1ZFd3V3OWFJL0FtQkRNZzdGZDNNUG9tbXNnd2twdkJkVktPMnVD?=
 =?utf-8?B?THIxV054cDd4dTNGVkExTE5tVXhFSWhvempzb3gyMHFyRnJVU21FL2dvTkJm?=
 =?utf-8?B?d2FIVzVnM3BkeGE0TE5xTUVoNldJSXZjU0JENVQrN29CQ0ZLeUwzbDRhS1I4?=
 =?utf-8?B?QlZUOTBYVmYyT1RBK0VvYUZhaXlycTJnbm5Rbis5T3lYOXEzSUJRbkxtSWYx?=
 =?utf-8?B?U000TEVmelJHZlBVWlQzVW0wMlJyZ0dNSDduL0g4cXVHOTFkUThuVGZKV0RZ?=
 =?utf-8?B?eTNLTGd1WEs4QkRDcW92U1I2Wlc2clMwL2owNXBkLzN4cW5XTU03ajVPeHNO?=
 =?utf-8?B?Y1Zud21vQ1ZZYWdaZVVPaXJGcnNlb1lmeUd6TkEraWhseHZYUGd3ZGdLdTNx?=
 =?utf-8?B?eGNmcktFdHQ3djE1Rk5DcjBrT0RIRG01Q3p5YSt5M3lKeU92ZTdEVmo5a1pC?=
 =?utf-8?B?a2IvZXFsQzdUb0RsVWEyZVFMRkR3RXU4R0ZQWTFFOW83eVVSeW9QcEw0Q3NP?=
 =?utf-8?B?TVhXUXUzMDFzcGtJZXJNZVFLNmJDTm5vNmQyWmFBR0hBc1U1WGNzekhQRmlr?=
 =?utf-8?B?OFlzS01FMGpNNjllaVM5WGovRkhZZFdCS3pGckVoZ091eE81WVJUV25YNTc2?=
 =?utf-8?B?Wk9Ca0VJclV1c0JvS0NwR01CNUJub1ZoMXF5bUtqMHgyZ3ZDK0ZJNElra04w?=
 =?utf-8?B?ekt4LzhsRTRRTzJGV3pyWTFVa0lXR2FtZmtwQWdtdVpNbWQvSXRObkNSWFJZ?=
 =?utf-8?B?V081T0xrQjJKZzJkbGpCdlZqUnZsYkxBb0FMT3h4eFlpN0pqdHNveE9WMXc4?=
 =?utf-8?B?RUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D04930C85C7FC4DB69328CE78C6AEE6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e8d3920-7bca-4582-7831-08de312a713e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2025 22:39:09.0957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n3So+Yy/RbmaGrnky4DsUijyaUj9cLqid8dMQ3FdadGXIk7wt/EjWAJU2atLXK6JgmcvNrBZGkSZtKwKWcpNy2LQhEAwiiFpR4v2vb4rBjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5782
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTExLTI3IGF0IDE4OjExICswMjAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+ID4gKy8qIE51bWJlciBQQU1UIHBhZ2VzIHRvIGJlIHByb3ZpZGVkIHRvIFREWCBtb2R1bGUg
cGVyIDJNIHJlZ2lvbiBvZiBQQSAqLw0KPiA+ICtzdGF0aWMgaW50IHRkeF9kcGFtdF9lbnRyeV9w
YWdlcyh2b2lkKQ0KPiA+ICt7DQo+ID4gKwlpZiAoIXRkeF9zdXBwb3J0c19keW5hbWljX3BhbXQo
JnRkeF9zeXNpbmZvKSkNCj4gPiArCQlyZXR1cm4gMDsNCj4gPiArDQo+ID4gKwlyZXR1cm4gdGR4
X3N5c2luZm8udGRtci5wYW10XzRrX2VudHJ5X3NpemUgKiBQVFJTX1BFUl9QVEUgLw0KPiA+IFBB
R0VfU0laRTsNCj4gPiArfQ0KPiANCj4gSXNuJ3QgdGhpcyBndWFyYW50ZWVkIHRvIHJldHVybiAy
IGFsd2F5cyBhcyBwZXIgdGhlIEFCST8gQ2FuJ3QgdGhlIA0KPiBhbGxvY2F0aW9uIG9mIHRoZSAy
IHBhZ2VzIGJlIG1vdmVkIGNsb3NlciB0byB3aGVyZSBpdCdzIHVzZWQgLSBpbiANCj4gdGRoX3Bo
eW1lbV9wYW10X2FkZCB3aGljaCB3aWxsIHNpbXBsaWZ5IHRoaW5ncyBhIGJpdD8NCg0KWWVhLCBp
dCBjb3VsZCBiZSBzaW1wbGVyIGlmIGl0IHdhcyBhbHdheXMgZ3VhcmFudGVlZCB0byBiZSAyIHBh
Z2VzLiBCdXQgaXQgd2FzDQpteSB1bmRlcnN0YW5kaW5nIHRoYXQgaXQgd291bGQgbm90IGJlIGEg
Zml4ZWQgc2l6ZS4gQ2FuIHlvdSBwb2ludCB0byB3aGF0IGRvY3MNCm1ha2VzIHlvdSB0aGluayB0
aGF0Pw0KDQpBbm90aGVyIG9wdGlvbiB3b3VsZCBiZSB0byBhc2sgVERYIGZvbGtzIHRvIG1ha2Ug
aXQgZml4ZWQsIGFuZCB0aGVuIHJlcXVpcmUgYW4NCm9wdC1pbiBmb3IgaXQgdG8gYmUgZXhwYW5k
ZWQgbGF0ZXIgaWYgbmVlZGVkLiBJIHdvdWxkIGhhdmUgdG8gY2hlY2sgb24gdGhlbSBvbg0KdGhl
IHJlYXNvbmluZyBmb3IgaXQgYmVpbmcgZHluYW1pYyBzaXplZC4gSSdtIG5vdCBzdXJlIGlmIGl0
IGlzICp0aGF0Kg0KY29tcGxpY2F0ZWQgYXQgdGhpcyBwb2ludCB0aG91Z2guIE9uY2UgdGhlcmUg
aXMgbW9yZSB0aGFuIG9uZSwgdGhlIGxvb3BzIGJlY29tZXMNCnRlbXB0aW5nLiBBbmQgaWYgd2Ug
bG9vcCBvdmVyIDIgd2UgY291bGQgZWFzaWx5IGxvb3Agb3ZlciBuLg0K

