Return-Path: <kvm+bounces-35602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D26E4A12C34
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 21:06:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF467166788
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 20:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 699681D89FD;
	Wed, 15 Jan 2025 20:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g3E63Qgo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0141D61BB;
	Wed, 15 Jan 2025 20:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736971577; cv=fail; b=b8pm2DzK50bqkJvKWQTi6/DAVFcJmq+yY1fYZZVMbwKipRP5XwPiFDJuTbdqAtIcQ6STW/kCoUBMHRjQwausfMwk8Bs3rnjKn5ZUxaqNTn3ymxq4SgpvpRM69jexbX7V3csYJRfyNYGrnhKI2g9pQJTu6KdhE9S3ZSs7Wb3Bzhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736971577; c=relaxed/simple;
	bh=gfKoMT//lX4M61qiv3J3VflqR0jAT212J1BC7by0uj4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fK5VOduVD4qt4MiffWWvSOrO1kITRxQRG04hgan8ZiYdpYAdw1uSRTMDnO8DYkaYMdR9PAMe0H3rkF5VjsJmXSl//OMIXaRNF+w5QJUKGfgPeQeo5zrZQb9eQGpbXZ68UiNt332yNNJgxdPsPqgouDOr130svky3T75HXgqIFWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g3E63Qgo; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736971576; x=1768507576;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gfKoMT//lX4M61qiv3J3VflqR0jAT212J1BC7by0uj4=;
  b=g3E63QgoJAngIzLzF6jwLDXbHxCw1AQFfm6MRoS/rwapu2jnS262GoMr
   eRjvLuTeqNkFzA3auhB+7l1eCV73VS7Yz7mvlXLekwWkoLxSza853tfAA
   hvIl/ySlQPARifU9jpK8SNuTX5D/+mKy6AdYT+aBHk19DUIlKXE8Cqh6W
   UIICGbNuZfbvN8X8BOq0cGzU3UghiUTS1IFT+a5KLkVWTnTn4J0Xp6Oww
   T3KV/axxE2Jn1ixpuZAjDcJLKYAYbr4vc+SSDbasOzfCNP9S5dZcZjcup
   HJSs7W0S3bMbI1XLwwgZPXl0dYcIC8OCpr/uu8R0fnlAcpenXyCURAvvl
   g==;
X-CSE-ConnectionGUID: o/JKrzVARgeqPT3A5wZnpQ==
X-CSE-MsgGUID: Jt4RCibUS6qJJ081yiyuRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11316"; a="37209817"
X-IronPort-AV: E=Sophos;i="6.13,207,1732608000"; 
   d="scan'208";a="37209817"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 12:06:15 -0800
X-CSE-ConnectionGUID: sGaLiMkITsewLmFdNUCllQ==
X-CSE-MsgGUID: JpewFj1jQCaKZO17UXzSIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,207,1732608000"; 
   d="scan'208";a="105179766"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2025 12:06:14 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 15 Jan 2025 12:06:13 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 15 Jan 2025 12:06:13 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 15 Jan 2025 12:06:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wjus97LceiLc//dmEZ78gGemruPgn/BKBCBcPb2QnH4Q/gtjXQHwOc71/efT/Ch0A38WsaLdgp4FVLCt8XMC1TxIrAdLJdiDfw9MEOp0fmP+G/lnWY56Heewk+Z9rmuxKh+W/b7adfoXhlDLGkyowIxX+f9AvsuzTW7Qv603uuvow0Nk4fetahpSFH99JdglfXPmVtK87zYnnMnVmtFs8TZdGQ75mkALtd3M/dZJQoZ8lCq3NztyL+F3od9PvuKKcYASHB0ylRSUm1R1/JqVaKf6g/vrx6MkJguzRYdWAz39sZGJ0lMRCP+C9kgmfotRze7ai42XRLYlpFn8T64qpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfKoMT//lX4M61qiv3J3VflqR0jAT212J1BC7by0uj4=;
 b=sqsnpr8fH2ywwTABEs/ipOHr5ujI9xi4Isl4ipCLau2144nVTLH26wvJSB/V90utMW0leEGVni4vtUlOLvzYK88hUFgas9VGfpWFJmgUrz2N32HzFgFKhkXXXRyTWfvIaHb9Lwgd83ZV5pKrVzGZ+8X16QW7QP9n9FtbmwKO01qFCEEPy6o8waXIjdWfQGzLB45UEi+QiSzcFRH/u1NqcQteoCGXhcTU/w8pvUt2j/q0CdvVRzR0EJrZG0swDorcZZ/dHaRwTtnF4m9IS5+Uv5PcYSAzw3gqmqNRqH46ozOl6rLll5DRWR29vKabryqJnMJO72SjaqeOQasGsBksWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 20:06:09 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%5]) with mapi id 15.20.8356.010; Wed, 15 Jan 2025
 20:06:09 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v3 00/14] x86/virt/tdx: Add SEAMCALL wrappers for KVM
Thread-Topic: [PATCH v3 00/14] x86/virt/tdx: Add SEAMCALL wrappers for KVM
Thread-Index: AQHbZ2fdmbRdWBZ26kOkd1tFP4ljTrMYNK6AgAAF+oCAAAhcAA==
Date: Wed, 15 Jan 2025 20:06:09 +0000
Message-ID: <b29ae06660e4d6318d69fd4c9f33a148d4a43900.camel@intel.com>
References: <20250115160912.617654-1-pbonzini@redhat.com>
	 <00ff9b4e7ff1a67ca43d4ecd7e46aa59d259733f.camel@intel.com>
	 <e4b2c596-a2a9-496b-8875-4f73ddcfcf26@redhat.com>
In-Reply-To: <e4b2c596-a2a9-496b-8875-4f73ddcfcf26@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|PH0PR11MB5191:EE_
x-ms-office365-filtering-correlation-id: 747742ea-88d2-4678-e7ac-08dd35a00d80
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QjBjQ0EybU9wWEJqcUJrclF1MXdFRlBpcEJMYmJhcDdFVitoeVRBTmc4clNl?=
 =?utf-8?B?Z3UwckRDWXFOeU9yRTg2NG1iSmxndnRkZ1dOb0ptMXBBTnk3YTRuQ3lvNEhL?=
 =?utf-8?B?ZDRKTEhaeUpLVUJLVisvbFhsKzZYaXFNa1U2MjNWMGN2Uk05cTR1bkdnaGRn?=
 =?utf-8?B?d0s2Ukh0K2dhMkwvR0w3SUVic1ppdXpOcnU5ZFJUcGZycm9pV0RzbTRRUnkv?=
 =?utf-8?B?N2tRZW5hSDRFd0wzaUl3MFlqejVZRzJYd01tSFpuZWZ2N1JpYjhadzdTT1lK?=
 =?utf-8?B?TmZKZitzWDJkcllOUlJWZHQ1WnZiT3JpTFQvTmxld0dIaEhJUFNtNDNlcEJI?=
 =?utf-8?B?a2ZwTlUzbkNDeU1lWmVjbXRTVTNxT0VEMG1rVDAxUFpzampTdEx5TStzNWZS?=
 =?utf-8?B?ckNIREhqNzI3Mm4zdGltOThVUlNIVnBUUi9uWGhyOUk3WDRuZjhvZTdWckNF?=
 =?utf-8?B?MWkvVVRPSVIvZ3RxZENLRnExTGZYQi9keW1qeDgvakdneFVGbEJwZ2pnMGls?=
 =?utf-8?B?alFTS21lVi9KQktiblNaeDl6UFB0OXVDS2NsNk82aXpPZittQWVwUDdHbXVl?=
 =?utf-8?B?ZVkwREJ0aGlpRk1TdWlGYWtKSHN4RDRhZ2lhb2xqZkxQQW0xc1A3ZlRBQWF2?=
 =?utf-8?B?MzBwd0dQL0hQY1ZWR2trS1Fxbml2dTlNSU9UV0dDNFp4dk10R00xK2NsWk5C?=
 =?utf-8?B?NTV3Zkg3WnRYbVVLR3RxNlpvdWJyQXozc24xR1drUUdhbWdIdmVJeituZzJ5?=
 =?utf-8?B?NlA3c1hFM2Rta2hRNVRvNHZsclVPTWNuRDZkWFdvZlYvZUhtdU1NbDFnLzFJ?=
 =?utf-8?B?QWJKQWhVY1U0RjdST1lwUnYzakwzN0tmcjR4eWp3RHh5d1pxU2FuSzRCZnVm?=
 =?utf-8?B?aXVyZzliV2JEK3Jub1NvMHVuTU5UU0dpUkx1QitNZVI1bld2SWpMQks3cEdr?=
 =?utf-8?B?cW1PZE4wUWJaT2lOblNqc0RyNUg3VGRId09QNUVHTUo1aW5pS091RmNxelVz?=
 =?utf-8?B?LzRnMEJzakFmZldUSlh1YXRzK2RSaDBwbmtCZXVGY0lETG5NS3pYWXltUG9h?=
 =?utf-8?B?aXAxcEJzNU5NcUpMd3M3S3NTYkdWNU5FcVlWS09jS0YvWEttbG51MGp0YnNF?=
 =?utf-8?B?VFRacmNCdlAweHRtL21CMUZNVFA5b1pJKzk4Tlp2bFkwQnd5aXZudGMyTm12?=
 =?utf-8?B?eVZ3SFBsQWg4UnlUa1AzM3JnWVp5aENtQzBhY0VXZ1o3WHEwVHh5dlc4dzZR?=
 =?utf-8?B?d3dPQlFxNXYxUjhFRlZ1SENpbytsMWtIMEk4aVVHZERuOE54c1VES3hadmhs?=
 =?utf-8?B?OFl6TzJxeWNMK2M0c29zam1FWVBHNlZEVFdnVFhKbno2Nnh6QjFLUWRIaHh0?=
 =?utf-8?B?RkFkalp0ODBITWlLcUZCWUVwcm5uSWZhNTdMOW9YelU0ZVJScXpkVGlJbnRw?=
 =?utf-8?B?ZVR0MURGNnM0SUJZcWxwNmZOWm4vZDlvK1hYTVNqK1VhYlZ1YjYxeWYybnor?=
 =?utf-8?B?SGlRSVY0L3NBbk5oN29sNHZ1Zm1rUTZscUxJSFZSRXlGUGlFbkhLZTlBcSsz?=
 =?utf-8?B?bGsvY3N6eTVWQmJXQXR5VHliN3FPRk0wMVI3bVM3em9ubjdtYThyL2xUN0Vp?=
 =?utf-8?B?MnRZNkJ0SHBPWUttcGw5NEF1ZmRzbmFVSGJHSTR1eTFsdkIyem1hVEZEcGl1?=
 =?utf-8?B?WUtUeWlZalc4UTNkc1FkQlhjZktJT2dWMldqVHp2YVBNNCtrR3NUNFoxTjJG?=
 =?utf-8?B?WHpkKzA4UmtKbEJKb3oxN2JvdWo5RVFSdytJWFhZN3RzaGRNSVBhZit5cGxi?=
 =?utf-8?B?UTc3Wm4xYzRnQUlKQ09zbERtNmRTVmVHc1JlUzFuSHZLMlB4WVhpT0dYUThi?=
 =?utf-8?B?ZlZ2MG94WmR3UTZRcnYvUjZOb1k5UURjbXF6cmNDYWowUVJMZnp0eWROckti?=
 =?utf-8?Q?7qP2XQMtYdx8A7lmbJqudHNO/9nd0bdJ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2NmMERLQXhjaUpKSXN0dEdYd0F3WG11WmNyeks4eGJHZlExbkVzRG1mQlFk?=
 =?utf-8?B?eUNyVWRVRzVuOTRRL0ZKc3g0aEt4N2lDODZ1Tk8rY3gwUGZxdVFCMlJtSGMx?=
 =?utf-8?B?VTBqNnNNZXhWbUNYY3RUQUFQRWwzaDg1dTR1ZElmMjZXaktFNVJwa2UvWE1D?=
 =?utf-8?B?TGpvRlo5U0R0K1NKMm5YNzFwTEFZMzNMVm1TNXpjU1oydnlxT3pBdFFOQ0I4?=
 =?utf-8?B?TDBOZW9HdkRwY28ySzhuOUN1SmVuVWo2ejNrbG0xSXZkZHcyb0t3NkF5T2tu?=
 =?utf-8?B?YnlEeDFuUFJDa1NPK0pSQm52RjNpWDFGaUlSTmpHS2hzb2F4d3d4MVg5bmZN?=
 =?utf-8?B?WU0yVW5aLzlYNjFUNVdjWjBQSjRqU0xBM1FLOVord2ZrSXQ0YlJobzFXY3Yx?=
 =?utf-8?B?VGEwN3JmMGNXVENXNWpuWFgwd0ZWd3U3MkJEZnU4RnZVTkR4NTV5dDRpVUsz?=
 =?utf-8?B?akZxd1A2WDd5Y290Ti9wZGZFUEhrWVR6SjRzejdOU3pDYlBRMkc1b0JmTFQw?=
 =?utf-8?B?Rk1Na0Z3TUJBelRjU0o1N1FNV3IvQ29YQnVoY25RZTFoYUJsZnlLOE4wNVFY?=
 =?utf-8?B?L3dSUzQ2cXdQdDhIakQxQmZTdVlzWUg2SHNUeTJ1UmxQUUkvNXdYQmVZL3h5?=
 =?utf-8?B?MUZoZlRoWmx5bFpGZ3Z1S3JnMXl5T2FyRVBkcFRMTk55SmZmaXlSSUNvc0o1?=
 =?utf-8?B?RkR0TmdlNUNxMllUQlFQRXo4bjJYQVlhYTNuK2VZK29IajJMa2FFZkczYXpx?=
 =?utf-8?B?NkxweDBoNDJKVkRieGFsUk5HSmFRNDc5b2hQWXFDd3g1V0tLNDNZSHlzM2JP?=
 =?utf-8?B?ODVhVFNSS3ltWlpyS0cyNWVrSU44RHh6MU5iTGRhTkpXb0R1SlE2M29WMDFs?=
 =?utf-8?B?N1lmVmJSWkpwMzRWM1hDRENEMWM5STUwTlB6R29WamhwNjJmOFJHYWhDVUNl?=
 =?utf-8?B?Rnk0WEtOZVpLeWVFT3IwcFd3UkVsc1Z3RjN5N0QyU1U3MGtqMlloRG5HSUow?=
 =?utf-8?B?SnhWL041ZVFGbllzcHkzVVhIL1Rta3p5UVRYdFZ5SitYN2FoL0xLSEdZMk5l?=
 =?utf-8?B?eW5WK2NxdTZCZ0NWTmdOaDIwNnRRc015M0VROTBWQklKM2hYS0pNd1pmMVdS?=
 =?utf-8?B?TUVCVVVINEtKS1RvN3B5S1BuNyt3aDA4RTFISGRDWnFYcFhuZFBrcitnZGpH?=
 =?utf-8?B?Qlhyd3JoTW96R0NRQS84ZGlRVjE1ZCs2bW10S3p3Sm1vaTFFYVFDaWNoenJV?=
 =?utf-8?B?WXIyK0xBbW8vYlV1VXdNWFk4VnlOTkoxVHFBbkJPNmZFZm5QVnVReFpXRDVr?=
 =?utf-8?B?cisva2lxdFNrUmRLbWZqZGZhYzM1TWNiMFpuVk5lOVpKMmc4QmY4aTNJM2tN?=
 =?utf-8?B?NlRRb3dNWStNRU91NE9lVE84Y2RuZFNldDBudkhObHlXT0ltdml2bmsydFdr?=
 =?utf-8?B?NEJGTUZuMFZ5bG5IeUtmRTlmTjErVkNmM2Z6bVJINlNaMWN6bzMwWEE5ekQ2?=
 =?utf-8?B?blVsNTRURkFnaE9PU0FTTzVGSXg0V1BjOCtKeERiU3NTbjQ1RjFjRTNCNXdy?=
 =?utf-8?B?eklneGl1Y2kzMkZtMzIzdmpmejkwdWVWZytnbzEwSDZnRGNBVThmMEtVdno2?=
 =?utf-8?B?Q2hUalRIcjdWVm1HVnNXOC9FdzdiZ25iamdHaGJUdmhzdk02ZmFJYlJqRldw?=
 =?utf-8?B?Z1lTdHNQRXBhQjcyMkMyUHFIdlVVdGE4QlVNN0VlY3JMQVIveVdLeDRqaUJt?=
 =?utf-8?B?NXJkcGxhMjdlbSs0ck1NMHNXMWhNV2wvOFVUTkhwVGxWcW9mdXhJZFlzcTNv?=
 =?utf-8?B?QTFJOWo2MkRqcWIzTjVJeUErMUZ5bmVLeXVDNFFHaitON2dWbHY1eEpTQ2s3?=
 =?utf-8?B?WjQ5a1Ird1Z1SGQ4bWl5Qit1V1RSQVhiUVdRdHg5SVdDL0pTRFluMmIxeWpG?=
 =?utf-8?B?N09jTEhaenVtcWVsK015V3RQOVo1S0g3WFI4MjhLRjdaMzdSQTBNdnJKQVh3?=
 =?utf-8?B?U0lUMjM3dGJrbkQyVmUxejF0S3dkODJibmxFd2RyN2xIWWY0djAvckhnbDhM?=
 =?utf-8?B?N0ovYnZKbjVUbTgrVXgydWxmMFFLV1F2YkM1Rjc4VSt1TVFIMlRweHltL3k4?=
 =?utf-8?B?RWo4NWhXby9hMUgvS0JWdGxaZDZHS2NERExpSk0ram44UTc2RVBtbWRlam4w?=
 =?utf-8?B?aHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B50829BE0B585B42A5CAC635E0154025@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 747742ea-88d2-4678-e7ac-08dd35a00d80
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2025 20:06:09.3853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A4Jt2PyynPpuJp2+NyvGbxh0rmCCyakZpjgEqTo/fOOmPln2LD1dI0jJwT4ed1ceSSVtda0POnjfYegxJcDSHHuOc6fnsot2c1BFczRafLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5191
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAxLTE1IGF0IDIwOjM2ICswMTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBXUlQgaGtpZCwgSSBpbnRlcnByZXRlZCAiSSdkIHBlcnNvbmFsbHkgcHJvYmFibHkganVzdCBr
ZWVwICdoa2lkJyBhcyBhbiANCj4gaW50IGV2ZXJ5d2hlcmUgdW50aWwgdGhlIHBvaW50IHdoZXJl
IGl0IGdldHMgc2hvdmVkIGludG8gdGhlIFREWCBtb2R1bGUgDQo+IEFCSSIgYXMgIml0IGNhbiBi
ZSB1MTYgaW4gdGhlIFNFQU1DQUxMcyBhbmQgaW4gbWtfa2V5ZWRfcGFkZHIiIChhcyB0aGUgDQo+
IGxhdHRlciBidWlsZHMgYW4gYXJndW1lbnQgdG8gdGhlIFNFQU1DQUxMcykuDQo+IA0KPiBJIHVu
ZGVyc3Rvb2QgaGlzIG9iamVjdGlvbiB0byBiZSBtb3JlIGFib3V0IA0KPiB0ZHhfZ3Vlc3Rfa2V5
aWRfYWxsb2MvdGR4X2d1ZXN0X2tleWlkX2ZyZWUgYW5kIHN0cnVjdCBrdm1fdGR4Og0KPiANCj4g
PiBPaCwgYW5kIGNhc3RzIGxpa2UgdGhpczoNCj4gPiANCj4gPiA+IMKgIHN0YXRpYyBpbmxpbmUg
dm9pZCB0ZHhfZGlzYXNzb2NpYXRlX3ZwKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiA+IEBA
IC0yMzU0LDcgKzIzNTQsOCBAQCBzdGF0aWMgaW50IF9fdGR4X3RkX2luaXQoc3RydWN0IGt2bSAq
a3ZtLCBzdHJ1Y3QgdGRfcGFyYW1zICp0ZF9wYXJhbXMsDQo+ID4gPiDCoMKgCXJldCA9IHRkeF9n
dWVzdF9rZXlpZF9hbGxvYygpOw0KPiA+ID4gwqDCoAlpZiAocmV0IDwgMCkNCj4gPiA+IMKgwqAJ
CXJldHVybiByZXQ7DQo+ID4gPiAtCWt2bV90ZHgtPmhraWQgPSByZXQ7DQo+ID4gPiArCWt2bV90
ZHgtPmhraWQgPSAodTE2KXJldDsNCj4gPiA+ICsJa3ZtX3RkeC0+aGtpZF9hc3NpZ25lZCA9IHRy
dWU7DQo+ID4gDQo+ID4gYXJlIGEgYml0IHNpbGx5LCBkb24ndCB5b3UgdGhpbms/DQo+IA0KPiBz
byBJIGRpZG4ndCBjaGFuZ2UgdGR4X2d1ZXN0X2tleWlkX2FsbG9jKCkuDQoNClRoZXJlIHdhcyBh
IHJlbGF0ZWQgY29tbWVudCBvbiB0aGUgR1BBIHVuaW9uIFlhbiB3YXMgc3VnZ2VzdGluZzoNCmh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS83NTNjZDlmMS01ZWI3LTQ4MGYtYWU0Zi1kMjYzYWFl
Y2RkNmNAaW50ZWwuY29tLw0KQmFzaWNhbGx5IHRoYXQgdGhlIGJpdCBmaWVsZHMgaGF2ZSBzdWJ0
bGUgYmVoYXZpb3Igd2hlbiB5b3Ugc2hpZnQgdGhlbQ0KKGlyb25pY2FsbHkgdGhlIGV4YWN0IGJ1
ZyB0aGF0IGhhcHBlbmVkIHdpdGggdTE2IGtleWlkKS4NCg0KQnV0IEkgdGhpbmsgeW91ciByZWFz
b25pbmcgc2VlbXMgdmFsaWQsIGVzcGVjaWFsbHkgc2luY2UgRGF2ZSBoYXMgc2luY2UgcXVvdGVk
DQp0aGF0IGZ1bmN0aW9uIHdpdGhvdXQgY29tbWVudGluZyBvbiB0aGF0IGFzcGVjdC4gU28gbGV0
J3MgbGVhdmUgaXQuDQo=

