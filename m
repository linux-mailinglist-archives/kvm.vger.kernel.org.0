Return-Path: <kvm+bounces-30814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5A0A9BD74A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 21:56:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 753CB1F23B31
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8CD5215C5B;
	Tue,  5 Nov 2024 20:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BamgNxGQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE543D81
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 20:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730840187; cv=fail; b=Hdx/zuxq5dkCPAin4St1rmbhvDQ4P1Dc9uAhO/vcSDyzAUypZtp6Rco/t4j7Ia0d0CnwBO5cJ356FSBMqj29uQfofTF3gRU4wR2obC0iZqW685iAL3LWzT5xTuoG3mqwjMXX7lGB1RaP8NpklVGWLmOpc0Isfa0CtF+Vq8iWRUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730840187; c=relaxed/simple;
	bh=YDArNcV8oTkoeg5PMmA9ssNpSsXEr0KCNOQjx1sHl7U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FzeHw3gxcYZFpLtAQ/bz5TBDLqPp2J6MHQoYPxODMkmxs8GtY/ErnBD98JIAxFXFNTdS4a56B6pPeYb1SME/r297jGgJxVJI/2ROybrC2EKKxud0LZNnksC+ByuoHNUZR+fNy6a/WhbjCza3Yr7tjp5MrYHm7AYDLfUbVG7NZ9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BamgNxGQ; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730840184; x=1762376184;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YDArNcV8oTkoeg5PMmA9ssNpSsXEr0KCNOQjx1sHl7U=;
  b=BamgNxGQvm1MtpS9q07FtuEibyxGfLEPqVBjlLnIspeQ0Sz64p5sH+Oc
   qmQ1R+w2XL0oVexjHCk379sjVKOhmKVwXW5xNcN7LaNtuz3g7yzWAmL1x
   1KYX5sYtEIHOywQBGUVNwlVbBbFdJOusYp7oFUVLE2/i0TOpn2fQzrWsk
   6fVDgEechQX3/O9DWdyRMIdoI8BEoKDGr6KdT3XWfMZiemsaB4Q8vHLoU
   yM6ePow+1H5PzT5KfqmiOCjXqsbM569qb2jVYL1bkGa3gDoPbZruXIKqT
   6dz9j3gh9dh4g18Vm5bvzl+gqYHUCf+y58T9OT/IVc4yM6v3ycKGPnG1F
   Q==;
X-CSE-ConnectionGUID: kAjFyqO8RiCwhKjzxRhqsQ==
X-CSE-MsgGUID: +hhOL+auQdGLn1OltqzJzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="48118924"
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="48118924"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 12:56:24 -0800
X-CSE-ConnectionGUID: r/FzFBzoQZa517qC+fIoJQ==
X-CSE-MsgGUID: wHNcM7EGQlWuJx8mut3qkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="83821810"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 12:56:23 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 12:56:23 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 12:56:23 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 12:56:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WB0oXbtPnWAfNKLWe0DSs7XwQT5t4+III6s57RG/w9b9e5A9x7z1S+cdnArLeVlCBfco49kuwH5ARh/RQq6+K4M+jCwOKw8PTH3ILimd7GHS45ctm3z+hA2wztUpMgfMVeNF49fzIemtxK2stYD9GyMWDNTKt5gOxbi2Y3Hq3m27jYnSqZHXa9GnI032va3NQfMvV7GLxFaGED2NCdmVK5B/vrR9ukej3DpwCaSqiYXZJug75DZPFKYwexPacVq/KcLzmfIA7wX/tdeX02eKn/tC3oJNEGQ5M3MTEtfmyuABAtl29cUHKFOd+w24e22D0pN/XH77+MlIIDasz9n3Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDArNcV8oTkoeg5PMmA9ssNpSsXEr0KCNOQjx1sHl7U=;
 b=BZ/+y6koZe9D9yS3BHCVBuCzGeNxyT2uM9bmwlSpkHsKegI7/sSSp1mdIEfBRZvlKUTnackz2V1JCyudBxd1OoUEPLUK7p7vmh5J0Fw3+e/QddW+G2imHT7JcN/YFuJ8Cfa1bQH0GX+NNpB2fWV4eSoNDO8wwOUb0X0krdyf6SF3W2Joo9oO04LL1F4hljG9jxQCRe3jToNuFtyPMxIn1bFHDQe6oGC3MhUADtz+PFjscX6hwr+nRj1EQvcrghEUyDANqPsFLjqf+3LzJ6R478Cq+FNku8WrldTwm9lmFIcPV5NanQj5PShptHqS9hRaCL4IvVSJ4RFGC7aSE1GOdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB5971.namprd11.prod.outlook.com (2603:10b6:8:5e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8114.31; Tue, 5 Nov 2024 20:56:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 20:56:14 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "riku.voipio@iki.fi" <riku.voipio@iki.fi>, "imammedo@redhat.com"
	<imammedo@redhat.com>, "Liu, Zhao1" <zhao1.liu@intel.com>,
	"marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
	"anisinha@redhat.com" <anisinha@redhat.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "mst@redhat.com" <mst@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>
CC: "armbru@redhat.com" <armbru@redhat.com>, "philmd@linaro.org"
	<philmd@linaro.org>, "cohuck@redhat.com" <cohuck@redhat.com>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>, "eblake@redhat.com"
	<eblake@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "wangyanan55@huawei.com"
	<wangyanan55@huawei.com>, "berrange@redhat.com" <berrange@redhat.com>
Subject: Re: [PATCH v6 13/60] i386/tdx: Validate TD attributes
Thread-Topic: [PATCH v6 13/60] i386/tdx: Validate TD attributes
Thread-Index: AQHbL00vhNLMY39W206bPyVvq4Gej7KpK7IA
Date: Tue, 5 Nov 2024 20:56:14 +0000
Message-ID: <1e6cd4c21496452c7dae254ae80fe16a712d0d21.camel@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
	 <20241105062408.3533704-14-xiaoyao.li@intel.com>
In-Reply-To: <20241105062408.3533704-14-xiaoyao.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB5971:EE_
x-ms-office365-filtering-correlation-id: 6e73229b-d7aa-4b9c-727c-08dcfddc4984
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?THlIZTNLNzltdzNoR214MnRMeWRiZjdUV0RoYUQ5REowdEQvcWtON3ZZTmgz?=
 =?utf-8?B?MEpPK1FvMVk3cFFVVVFZRU51aEpiRzJBRXlreUM2MTVleEFnYzJYanVrcGpZ?=
 =?utf-8?B?SWFweWxHSDF6dFVBeGFBVHIxeTkwbUdvdWFGVEFFeEZzdmZ6aFR2aytlaXdw?=
 =?utf-8?B?OXlKUlA0cEM1T2MxVkNIRDdnb3RrblM4QTFhK21keGN2MFlaZVZuTDl2NW1Q?=
 =?utf-8?B?aXNoaWhiQXdPK290TzJ0WnZFcElXczJQaW9qZkxRUWNCeFJQd2ZJRmQ2R2F6?=
 =?utf-8?B?TTFibmxpcHNFdzZCazZHMWVFT0QyU0t1Zkl6c2N0RmhhV1p6cHl6ZG84WnlY?=
 =?utf-8?B?akNCU1RaMksyTjRaODZXTzZUQmYxNDdtd3Nnc2ZoVkI0bXlYQ1RPcEttdnl5?=
 =?utf-8?B?VG9DRlcra005dHVGUGo0ek5wYjlhV3M4OVQzbVpDeVlLUW81K2RIK3BhVjJt?=
 =?utf-8?B?MFc1NFFOQjdJSHhIalJkbEUvN3FmaUVmRzhhcjB4eWNadU5yeUVhU0NsUGtD?=
 =?utf-8?B?UjUyWlNzOTlCTmQzMGZyejQ3QlQ0S3VTQWVXQzRhNGJyR3A2NndhRUNWSmZj?=
 =?utf-8?B?dDFKenlEWVEyZXJ2ako0czlYczBlNFVEKzJpaVFyRk9ub0NPNnJoc2hnWXpm?=
 =?utf-8?B?RnMrby9PU2hhMloyUnZxTVQwQnVaMC82OHo3VUQ0YllQUi9lMU1kVVh1SFgz?=
 =?utf-8?B?d0xRSDh5MU5PSnRKcmFWSmNzd20vZ2dsMlVIVnp1ZUlJVW5sQkFpOEtVQXl5?=
 =?utf-8?B?dkEyRDY3cCtPQXRXS0RpYXkxYkFxczlCNGpmYlpqajR3ZDR5S002SmN4em5D?=
 =?utf-8?B?NitINFBrRGV2cXhxa3h5UkNKWEdrbmJSWDRWNkFwN2I2TmIzM2pQbU4yRGx2?=
 =?utf-8?B?Z0d5TisxczV0MU12ZVZKUndYeENWRjNUTzlGTXJEd2VVMXdvamRDbzhnN0ZE?=
 =?utf-8?B?Yk9KbmFFMlNKVDJxYXUzeWp4WDQ2NVh2WEwrb2pKbnZ2RnVOUlJwbTVieVBn?=
 =?utf-8?B?SVFsWEVWbjE5OU4rRU5vUXYvWWYwMTF3cVBzWGY3Mm00UmYzMnllejVwaktw?=
 =?utf-8?B?OHpGN1poVlJLQU1wVHBVSnZCUmJRTlRiV080aUU4bVlvYkNBWkJUUGlYQjBG?=
 =?utf-8?B?eWtSQ1dSUGdxaG9ESFJpRlBxUktEZkk4SDg3bDh3T0c0OFJFNC9BYUJqTnh6?=
 =?utf-8?B?cENPK3c2OUpmd3FkTTdkSGY5NHR6RFY2TFU3SEpxOWlYSkNQUTI3YkVHeTZu?=
 =?utf-8?B?RlR4NVFISWRnRkdtejJ2ekVOL2p0QStnWThlZnYzcnJ6N1FFYU9uM3M3M2xP?=
 =?utf-8?B?NjdVS3lyK21lOWFvZU4vZkRhaStGeEZUVHdhR2lEOERTRUU3M1BKQ2JCbGtH?=
 =?utf-8?B?V1hHMHZPdldaOVFRRGJreWhqVWJzL3JLR1c5VldTV2tMUzluSGZKc29hSkFK?=
 =?utf-8?B?aXQzd3JOQ1ROYmlnUHVGS2Y0cUEzVDJUQmM0V3dUbkpOc3J6Uk8yME8zbzRI?=
 =?utf-8?B?UGFRb3A5anBJcTVjaWN2QUI4Wmp3ckN4d0F3WmNLZFUxMHhrblI4OEI5bGJ5?=
 =?utf-8?B?MHNUSVpheGZQVlB6Mk1LRGQ1d0d0ZVdJRksxMVJzN2craytSdERZYUMzelBS?=
 =?utf-8?B?WGJmNE5peWhrRUxxV0ViT24rNWJXS3E1dytIWFkrVk1TS092eVY1emJvS2RR?=
 =?utf-8?B?MU16ejNPRnFqNlhDQTZLNkN3cFJBRE0wK3VHZU9rS1phUHk1Zzg5c0kyWXBi?=
 =?utf-8?B?VnkzdklhLzhPZUNtRHpQRFJ0QVlRTUxGa3JPTGNCb0x3OVdydUk5N2FvUkg2?=
 =?utf-8?B?Zy83YldQMDJhSGtWSkNTSk5qbDhmNXdWWktOTEllQVl3T2FPclZUVnhQWmI3?=
 =?utf-8?Q?S5bhWQ+UflLv/?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3V1RDJZb0liTDBFNk8wc1VrMlc3WkVyQzBUR0kxYm9KMXdXRWdFSGpXbThX?=
 =?utf-8?B?NlJxODlxc3VEKzY0RGVPUkRmVGhOQzBxZjFxTjRDMWhIT3RDb1NVdTI4ekJL?=
 =?utf-8?B?VjBjTjZhZzBXK1BCNnE2bzEyMEV1UytvUWp6czE1RXgwaDJkVlJQbkJFK2Y4?=
 =?utf-8?B?OVZUVzR0NzBPLytqK0pvVVlka1oraXBQanFPMEY2VU1ZUzNORm5SV3B3Z3BN?=
 =?utf-8?B?aDVsc3J4bFFOVG9pSndsTjdicStwUEhUTHlmTUNhR3hJTkliQ2JhU0xSY0JO?=
 =?utf-8?B?M0NsOEk2MTV4eGxTWTBlcEVGMlhOcUJmRUU1SlNvN0pvQjIrb0ZIL3oyckFH?=
 =?utf-8?B?VU93U1lMdUhEWXVoS2dTeXBNYjUyeFZ1Y1J4amRNVkpneXcwc2hkY3dGNkJt?=
 =?utf-8?B?RGVJdjRtMHdSNWpjbU5HdXBtcDRDLzlXSzBnaUNFQTVWbmJra1FGVTNFMlhq?=
 =?utf-8?B?SjNGN1JBZEY5UFhaeUJvTk1XL1JEWndIUHNVWW9SbkZxcy9Kck9jM2w2WWxI?=
 =?utf-8?B?VDdQeENkUkg4V3YzSUJhU2dsMTZjQ1ZJc3U2R29jdDc4Vyt0dlh1UDFIV1py?=
 =?utf-8?B?cVFIdlVTcWdQYzgzbjdVQU9vakE2U3dFaGNpcHRHZmlnWWxKeGVKTjIxQ3gr?=
 =?utf-8?B?R2lUckhGcStFZlYxL1B0MFRZZkNldFp1eWp4SnMyaUFCSGpaTS9IQTUvZHZn?=
 =?utf-8?B?dTdrSWF2eFhvL1NFWU1xdWpVTFJhK0htUmJWaEFIVXpkQ0hwZDZSS2pnQzBs?=
 =?utf-8?B?RjNNNnBkZlhtdW9PSlJhQjJKRW9sL1VnUGFiVWJ2dnQ3Y3hWTGNVb2dtUEtv?=
 =?utf-8?B?azRiRnNsN2lQYkY5eXBqZVVsaTFHL29LOVF4STBPSjhUVWhFNE9CelNoc0ZB?=
 =?utf-8?B?WmU5NTEwaWMvTkdTajdocEppT205aVFoS05VV0txTjNaSUZUWWd6aUc1STl3?=
 =?utf-8?B?MHF6ZmRvQ3c0VEwzajc2dUg4MWVWMVpDR0M5U2t6YWtyUkVXa3FuN21wS3ll?=
 =?utf-8?B?Q0NyaVlKbjhDaW1QazVwZjJSaUE2ZHBHbk1haUk4VTdCS3RQalgrc2VmS256?=
 =?utf-8?B?aWJOSnhCZUVMOTBLRlpyZEljQkpBdTBuKzJFNDBueWRJalFIaGFhLzdyV2dB?=
 =?utf-8?B?SjhGMzlERll3UnFaWVVVblJDZmRUYjkwLzNVVXY3MDZBUEdBU0lqOGZwYWl5?=
 =?utf-8?B?OStuRWIrZHFKV0RscmRWbDNSblkxalRDRC9zdUFkTU9qMkpacmc0VkJsVzdn?=
 =?utf-8?B?NkU0a0IwODFPRlNjSjljOG9wQkdtam1FUGl2UkRnRDBpNDBaTDlJL0R0OVR1?=
 =?utf-8?B?ci9haVhibHZ6VnZtQnlmRC9Qc2cvREUxSTdZRnNhclo3YnNEM0cxdTFxV0ds?=
 =?utf-8?B?YWxFQVNyaXkvTDFQV1NpWnFOL1R3Y28xWnpTRFllREJYUmtTRlpsekZtNUtJ?=
 =?utf-8?B?SGhWTTQ2NnhLK1J0a3NpbXNhdlNnendJejN5cUl4ZU1NelhwdHhxMnlkZ0hj?=
 =?utf-8?B?QjJqdDFaaEh4a3MzcUNJRUhya29RQzdVaFNJMDBxeHYxUFlGQUh6UFFacy9h?=
 =?utf-8?B?L1RlaldVaTM4WGpVbmxMUHBIbGg0TDhDZ0pzREVQTlBVSG9aSVdSWWRab1dK?=
 =?utf-8?B?TkFDQ2t1Nk1DL0N5NWtlMElBdUJlS3dFR25kcml6bnpqZ3oyVkp0eVNEenBF?=
 =?utf-8?B?ZFhDcjFjZDdNaG9nZEZ3djVockNlYkZycHRzK3ZiUHlvZ3E5WFd0SHVrS01t?=
 =?utf-8?B?NWhINnRqb25zSkxBTDEwYjBZcllHSUhHM3hrTXpQSjFRb0F5cnE4WFZLVFpq?=
 =?utf-8?B?STJ0akFpQ0h1RTRtYTZjSE9HU3BSajduNVN2ZVB6dm9vbkh6ZE5CTEs5c2M4?=
 =?utf-8?B?aUJZdGNsL1pDcDVScVlVdENvZGNWUzhKVDhSRDNSbktsb2dGeUlUTWx4b1Bn?=
 =?utf-8?B?bCtVQ2dDWjNTS3ltRytGK3RIVnZkWGNYVU51RXJGenVreEFqRzBrRENzYXhF?=
 =?utf-8?B?U1Z3aGNPVVRLZzNvUHJlWjNoY3JCRXdlWjhCZWRBU2pqWGZKUGVNOEl5K2xl?=
 =?utf-8?B?ckFJcTdIQTlaQTc2QUxPdStlRlVkS1g1RTViRkdEYVBPWG5sbGVrR3lVOGxj?=
 =?utf-8?B?R3lnZkNzU2ZIWXhjUTFzMElUUXA2empUODRBSGR5VjlSazFFUGt1bHNudFVm?=
 =?utf-8?B?Y0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FD8C926AE656A4E812D3FCEE4A9B932@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e73229b-d7aa-4b9c-727c-08dcfddc4984
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2024 20:56:14.7372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MmB0o03qChiqir+ZOWpbCRCxZaHJS+Eom5vKCet3WRJt/SFvAvn5b8/Ppqd0qsgpt9yUr0ePTX9TSLvbJWAshvSPsvKPoJaiNqCZV4dR7xY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5971
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTExLTA1IGF0IDAxOjIzIC0wNTAwLCBYaWFveWFvIExpIHdyb3RlOgo+IC1z
dGF0aWMgdm9pZCBzZXR1cF90ZF9ndWVzdF9hdHRyaWJ1dGVzKFg4NkNQVSAqeDg2Y3B1KQo+ICtz
dGF0aWMgaW50IHRkeF92YWxpZGF0ZV9hdHRyaWJ1dGVzKFRkeEd1ZXN0ICp0ZHgsIEVycm9yICoq
ZXJycCkKPiArewo+ICvCoMKgwqAgaWYgKCh0ZHgtPmF0dHJpYnV0ZXMgJiB+dGR4X2NhcHMtPnN1
cHBvcnRlZF9hdHRycykpIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlcnJvcl9zZXRnKGVy
cnAsICJJbnZhbGlkIGF0dHJpYnV0ZXMgMHglbHggZm9yIFREWCBWTSAiCj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICIoc3VwcG9ydGVkOiAweCVsbHgpIiwK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGR4LT5hdHRy
aWJ1dGVzLCB0ZHhfY2Fwcy0+c3VwcG9ydGVkX2F0dHJzKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCByZXR1cm4gLTE7Cj4gK8KgwqDCoCB9Cj4gKwo+ICvCoMKgwqAgaWYgKHRkeC0+YXR0cmli
dXRlcyAmIFREWF9URF9BVFRSSUJVVEVTX0RFQlVHKSB7CgpXaGF0IGlzIGdvaW5nIG9uIGhlcmU/
IEl0IGRvZXNuJ3QgbG9vayBsaWtlIGRlYnVnIGF0dHJpYnV0ZSBjb3VsZCBiZSBzZXQgaW4gdGhp
cwpzZXJpZXMsIHNvIHRoaXMgaXMgZGVhZCBjb2RlIEkgZ3Vlc3MuIElmIHRoZXJlIGlzIHNvbWUg
Y29uY2VybiB0aGF0IGF0dHJpYnV0ZXMKdGhhdCBuZWVkIGV4dHJhIHFlbXUgc3VwcG9ydCBjb3Vs
ZCBiZSBzZXQgaW4gUUVNVSBzb21laG93LCBpdCB3b3VsZCBiZSBiZXR0ZXIgdG8KaGF2ZSBhIG1h
c2sgb2YgcWVtdSBzdXBwb3J0ZWQgYXR0cmlidXRlcyBhbmQgcmVqZWN0IGFueSBub3QgaW4gdGhl
IG1hc2suCgo+ICvCoMKgwqDCoMKgwqDCoCBlcnJvcl9zZXRnKGVycnAsICJDdXJyZW50IFFFTVUg
ZG9lc24ndCBzdXBwb3J0IGF0dHJpYnV0ZXMuZGVidWdbYml0IDBdICIKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJmb3IgVERYIFZNIik7Cj4gK8Kg
wqDCoMKgwqDCoMKgIHJldHVybiAtMTsKPiArwqDCoMKgIH0KPiArCj4gK8KgwqDCoCByZXR1cm4g
MDsKPiArfQoK

