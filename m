Return-Path: <kvm+bounces-63102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id F02B3C5AA53
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:39:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 11D124E8268
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B820D32C931;
	Thu, 13 Nov 2025 23:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WVU/4j0Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2103446B0;
	Thu, 13 Nov 2025 23:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076738; cv=fail; b=D35+el1ZJarjmDy/eKLIW63fVbjNYN7pNHkvrpkixKGGeUddWOzbNIEHAQenZZluhsgFoYQdlZZuGj1nFw4nBO3f81gIra4Y09fFUNdUf3wmDj6jqPiwle3wLIZLGWg16jSPDO33JWvJVsdPZNX7fzt7X6FGDI7UbHSl63KQd0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076738; c=relaxed/simple;
	bh=1G/z89Tc8rjIPbKk5MDP8DhpYy30kvMRf6CfU7qq06s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ek898VYn7sPfUDogY8ClbYCaaXRSt7ElETn2K9ACggTHfezwjCskJ0bILEKHCexkMuAXvE33Xu+jS5bAJ2YFOEyTs1YmfLMtV2xwgbASxnVCevsJt3HIRq8PaCcnzF4JxlO2DyUg4tAOkqz3a66TgBeo3+XBmadk+BFzT9uSW88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WVU/4j0Q; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763076737; x=1794612737;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1G/z89Tc8rjIPbKk5MDP8DhpYy30kvMRf6CfU7qq06s=;
  b=WVU/4j0Q396S95BNCCa5UIdu/2zO5CpsB5Zce9THO3+VNWXLWMFW32/H
   aBK8Da5l1c/kFBXTQyL4glBmWf/Xv7/T8Qo0VqQqS/PdW2BXs2BMbJdaA
   lSmEi+qtDpZ/BULnU8zdBeggZ6MrAR1eTsHCKR/eIiktINRKwLBZocyWS
   hnmQDqNgv/Tonzh9O2uHjRUsIIpxjWLUu8J7IthDRaxBwm/OaHznhW5Ud
   UkibQEu/Q37tIfFtJ3uX6zvzsCSvFEwJ0aTy9v5YSnR2YUiLa9J96JNUQ
   P1oikMiwYYJWOr2r4xeEyeaDH6HHjStrJ3h/eHqDghMQrBVSKCaBfgO4o
   g==;
X-CSE-ConnectionGUID: +r56QRZYSda4O7AqDZkjUA==
X-CSE-MsgGUID: /3brB0YzTJqfdFGxAF0A4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="69036169"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="69036169"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:32:16 -0800
X-CSE-ConnectionGUID: uLXoD1KVTZmqc2btPr44UQ==
X-CSE-MsgGUID: Y04WLKh3QPeg/ckvRn8bNw==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:32:16 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:32:15 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 15:32:15 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.1) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:32:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mOXL6O8oSVSdBnjAUHGN9faSmYunajBVqUwchMZQq5XImnBkUX6pLDS0qjNHFojbnef5ub5eLTIZMb4+/Z2OvQ+2aYwk627qjttafPonJEQDLzXd6n+bYoqaZRSMauBldM9rtnYZKG83+GyBZmT2wJnSowPtiUPkJR47F9yscGG+n3R0R+kOPQvj3EsQhineW2WciWV6a8KfYSu2QWhpRHuHdZaBdmpTTL+WJmdb9Tia9EW3sZWEELzRC71J4U0OWsMpNAmffIS9cni4UYixkQYYf5Xic1VHIFUvmg7TU/H5zSkBDZNqQv6AeEGj8SoDWq6gEbose2hjkcIIbuDF+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fB6g4ibHBJLnOvwSVHsqO+GKhzJOV74smnV4CGZBmPA=;
 b=v/ERt0VB9xz9Kp0+Mkh0a6mwuAb6bKP7kCYEGXmAZ2C2lnvGsSx2ZGKOQbVv65mzYIrVPdUfdpdK85wUSn+STyIe8aPONUtRzvTlOuIvN+mcU3yfolDF0DNalkhmBfxrKR9b/DFCRzCeCu4fFGYUnwak9VQeyy0p+8ufeaLSeeUOdRP2iZmV1tmXLkmO63eeifnslzcgv+yRyC3dy4scJcebKhn1I8bykpIdtSY4DuaNVbOyXcKdkIGRCUTOws6574ypK3QEr3G33MtSEfi0WCtTfnepisIxgNcEOV5fAqgEkC2pjK9Luws+zktVlS7EbtbpecobuzXwDe/8NOI5ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 DS0PR11MB8050.namprd11.prod.outlook.com (2603:10b6:8:117::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.16; Thu, 13 Nov 2025 23:32:14 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 23:32:13 +0000
Message-ID: <7e964169-192b-4f16-944a-65b268ef7696@intel.com>
Date: Thu, 13 Nov 2025 15:32:11 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 17/20] KVM: x86: Prepare APX state setting in XCR0
To: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <seanjc@google.com>, <chao.gao@intel.com>, <zhao1.liu@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-18-chang.seok.bae@intel.com>
 <ab3f4937-38f5-4354-8850-bf773c159bbe@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <ab3f4937-38f5-4354-8850-bf773c159bbe@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0343.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::18) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|DS0PR11MB8050:EE_
X-MS-Office365-Filtering-Correlation-Id: 01b7f287-ba1f-4375-bb72-08de230cdfeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R09xaGNEMloxVVRWOWdvR2FBOWcyb1l5WWVwYlVSbTZwQ1VaR1VrQ1NkV21u?=
 =?utf-8?B?b2V2WHB0V3Z4VDdNV1luRnVPalhpcHV1U3RvaVZuVTgvZFZhUVpwY2RQSHpz?=
 =?utf-8?B?WnpncS8xMm1CNWhtS002WmsvVVlzZWFsR1BZK1dvNlEzTHVTZ0pTRlFDYWlt?=
 =?utf-8?B?NWZ4akRscjVPSUsraUpUZkhvRllKVWc1c0VmdE9USCtLa0ZvQjlwbHFFMHFD?=
 =?utf-8?B?RUxwV3FlcTlnaGZLQXc4cFdORUpNSldiMVdYOStRQTlWN2lwK21hYW13eTFo?=
 =?utf-8?B?UTBDSEJhSU1wYXViRk54TmVvc01SbnBmMGJBczh3aDRRRHgxdHFBdEtZTDlt?=
 =?utf-8?B?S1BlenZSa3ZubGtwQ216YTZIUThYOEFkMW9vNmhEczdJTlJZVWZXTForWHpi?=
 =?utf-8?B?bjhaSUhHUDRwRmZLNUpIZElaaHlBa2t0OHBMUW9tK0ZvazFlWnBDTlNUdHo3?=
 =?utf-8?B?YTV5ek5BZ1VCWnFlOTlCKzEwRVNkZUZPZXFDQ2IwaWFOMjlEYVFlMTVKelE3?=
 =?utf-8?B?TG85ODB5dTZXa0VicTBEUGNDM3VHMy9TQ0dqTHhrV01wcndOdWVsZ0E0Kzgx?=
 =?utf-8?B?c0h4NklCeEZ1dUJEYVA5T2llYm43UXh0K0xiaUdRWm5RNzFrMEpVZ0UwODBT?=
 =?utf-8?B?cjNjVFVGUUQ1TS93ZTU1YmpEbldrUU50VThSZlZGSXoxdUNPeElkRjQ2ZFBY?=
 =?utf-8?B?QThTL1djL0pkb3RYamgrSHhUVEpYWFJCUG1zRGYzY0lEaFcyeUYzazlKbGQ4?=
 =?utf-8?B?VzR3NzRCa0ZDdmJPWS9CUDhxVFNFNXFaaSsvR3JXMzdUaGF5WVQ1czU3eUJh?=
 =?utf-8?B?ZTB6U1BvelFJa0dhelJlNnBFZ2J4NFhrb0I5Y2R6VkJkNlhCYkJ5OUtyWVN2?=
 =?utf-8?B?U3hFaU5xaTFFK1J0T0JsZFY0MjBqR051OE8rWkZIQVY0endmbDEvUm9RK2Ja?=
 =?utf-8?B?em9Nenp1OVlKM1ZtaUNkNVNuMHoreVdYeDI4SXdGdlF6VytaRTJGRytDb2tx?=
 =?utf-8?B?THlVU09kNTR2WHlLdy95ZFllYlBBWDlaSTJPbWVZUVFqaEhpMU0ra2F0Wm5s?=
 =?utf-8?B?N29wM0R5dmFmRVFkWVZyQlNFOHlZVEJnUXRYQ3BNR3k2NU5DOHFOWklOdlNK?=
 =?utf-8?B?TGhaUEdoL0MyL3B6eTczMnRqRHM3U1VsYzhnRHAxVDI1KzJENXZONFBoVWxu?=
 =?utf-8?B?YXhXRDRIeU95YnJxR3JIL3lneEcxRG9SRlV2Sld0aDlpY2ViSEkyUFlWOSsy?=
 =?utf-8?B?OTZ4SWJ3SCtKZjN5RXhvbzBmcTRjZSt3cEkwaElWejN4UE9DVldxd2JaVnhM?=
 =?utf-8?B?NFBOMEdGc3VCK0RpWlY1dEVscU9LYmJRNnBQVE1vbnpXdzlOaTZnQkMxelZI?=
 =?utf-8?B?WW5EM3h0WXFmMVZLb0lTVitzN3dTNVo2OHR3b1lnSWJ0MFRnRmFDUVhkUXNG?=
 =?utf-8?B?dm9VdE9yTU5PQnd3MjRYajlvT09Dam10RmprS1Y3ck56U2dnMVN4dDFXcmNk?=
 =?utf-8?B?dGNzQzU0aFZucFRFNlhqQVRpN2dwb0xjQ3NwQ083TGMyYUM4Nk9na0p6VHVa?=
 =?utf-8?B?WWRuOGdYejdiRmFMc2ZUajl6WGgxT1ZOTnkyY2pSRTFqS3Z4Qi9BQVVXcXFx?=
 =?utf-8?B?bUtYQlBGdWlvTE0vNDAxU05teXc1d0tGcnhDVlFxVzN0VXp2SjZQY0svaDRv?=
 =?utf-8?B?dXAyTm1SSkJ6cG1aU1lUQU41ZzM5cy91eWM4TG9oT3F2Tm5vS2Rnd08vNms5?=
 =?utf-8?B?Qi8xbTJYbnVvUVgwR1k5UElNMkdtcEUyNCtYWFFzQWRhczMwZWVDZWZ6enRh?=
 =?utf-8?B?VFA0SmNrNGpXNGdNV3ZJbkJBQnc4R0JXZ3plQ241OU5DNVpoVXBnejJsUHVW?=
 =?utf-8?B?VHc5VEU2Szd1akJjVlZOdFBiM1RBSU9vWVR3U3lTSitQdFhtSjRLZEsvNjhv?=
 =?utf-8?Q?C+3itZaqcLW0CSbn5A5tfog6evO0tuwZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VE5nbVZIVTlXTlJYdUFQZkNoSmF2SGp6cmNwMkpoa3V3aHVyV0JjT2YxNkNR?=
 =?utf-8?B?UXFrL0xqVTZkekZwU09IZ3hJY2NTdmdxT252MG9yTmdseStoYnQyOHN2NUZ0?=
 =?utf-8?B?cFRwdlZwcllTZldYYnhHck9jM01sdG1KcXBvdjIrMDA5eERra2VwcFJNRG9I?=
 =?utf-8?B?YnZpNGtudXBiYzJCTk00MUlhOStKZWg0SGd4NCs0bFdiUlNSRjBuc0h2MEtB?=
 =?utf-8?B?OWQ4aG9RWTF3ZVhjUDdZdnpJUE1paTB2bU50VnJMRGcvaWlRRzF2aWRqVnh4?=
 =?utf-8?B?cklycmlOUWNHUXVzbUt4elhKdlJCb2R3RnBpUzhQMkcrcG0vUnFkYUpBVW1L?=
 =?utf-8?B?TTdBUWJialpkQzJ4OTMvd2R3UFUvcG5xdHZIRm1PY3VjMjRJREdOR2cralo1?=
 =?utf-8?B?cWJOdGtNVE0veGJwNFB4emFpekZwT01pckZRN0xDSkhTVjZrRTdJbGV5WVM3?=
 =?utf-8?B?bVVMMkxyTThOQlhsMXRUZ1ZhUTlQdXNXVktTdXJSaEV5b2JGVFc4SGE2dFVX?=
 =?utf-8?B?NUt0bnkwZEZiaSt0RUhkN1BWUFlFb3hvT3RCWHBYY1NoYUZYR2oxNGg5dkNj?=
 =?utf-8?B?eG54UHZCWWFvc0J3cWljNTNYcDA4Y3QxLzJDZ1BxQlZZQ21yZjdWcktlblJW?=
 =?utf-8?B?d2RYT0Vyd3czVDZaRTgrYTFhR3dvcWp4VnoxQTBKMFJTaDNhVGZiVE5Obk82?=
 =?utf-8?B?REF0ZXI4V0lzL3lvZlVxaHFFVDJmUFZlRDVZeTg2RmVsY2NidXJzRXhsMnN3?=
 =?utf-8?B?WDNUcEl3eXFzdjEvZDM0S1RQZ3dYaGMzeVY4UWgrUXNIVzhkNzdzTjhTcG5w?=
 =?utf-8?B?TW9VQWpFb3ZWQXlTdGNZNUdNV29xMGRiL0FqRGI5UHpmandRenhQSnQwdVY2?=
 =?utf-8?B?UkM1SWFHQVJqckJLOWFmeDBkeUpHMnZVSGxEN1VzMGY2cWs2a0tOS00rUTVr?=
 =?utf-8?B?Z3daMkIxeGdubTROY1c1cHppbXBZdzMwYUNYUXk5eklGYS84QUZiYjhVVDJO?=
 =?utf-8?B?K0ZLU3pHSEpJQm4zT3hidXVHbkJTT1FLWFE2MmtpdXQ3UzFGcTlIVmwwZ2lj?=
 =?utf-8?B?N2NlVDBCQnMvVEVHcUo5Tndwb0w2Q3NpVFM3MDMzYlJYc1lQTHNnOVBBVHBW?=
 =?utf-8?B?UVEwa0NOQ0g0VTBlSmpIZ2ZHQ2xBeFFSMkswNFpxK21qYXhucDBEblhzeCsw?=
 =?utf-8?B?S213V2tyaUZTUHVaV1pSSnM0OEoyYTRHTjM5L3h0MDZEbVIzVVZ5dUFXOEti?=
 =?utf-8?B?NVpTYXkyTEJndVNWN1h3OFcwcS92T0daR0ZwSUVseVJ4QXBiMVNaNzgvZ3Uz?=
 =?utf-8?B?TDJ6SFJmSURHODRvQW1ueTRWMUI3RFJpTWh2Z3pucUUrdzMzVjJOZ1o4RkJa?=
 =?utf-8?B?cGE0d0xxZHRNSjhQOGF5aytaUzQ5Q1c5QkIwenNsdHltakczcDJLUDM5b0F1?=
 =?utf-8?B?eFR2eHlZVUkxKzc2aXhDcjlPVE8yQy83SW1nRlg0MkNncFNpYzRaVU4zN1RP?=
 =?utf-8?B?Y0xEVFp5c1R1ZVFSRTliWVVrRU9manY4bDFMaEs0bzRsOHJIOE9ZMGdwMGZu?=
 =?utf-8?B?M29RazVibmVXYjdLVU1kbDlnaGJxSnJkQS9NMEFrWk41eDN5eUI3UVJGbmJj?=
 =?utf-8?B?TWFvZnFsT29FK21hYTdja3RwWDVSaW5zWDJUcTMwblBySVZIczZUNlFXVmZY?=
 =?utf-8?B?Q3Jib3NTZlBYVTNrNFB5akp1cGx1eVVueUdnS2hzeXRRRzVKZ1JPTmZDcDgz?=
 =?utf-8?B?Q0FKcWNjK3czNlpvYm9Dazcrb1l1eG5WWXhBYnZUb1B2d1FaZDdHQlRXUUtZ?=
 =?utf-8?B?V0hHS05YMGRZTXB2bkZncm1ZaFI0b1hneTdkN0tzelkyTnIralF1dW1xV0ZB?=
 =?utf-8?B?RDJISnFkemJxWDVYVTRvaGlvVTRNLytqaHFXMW8zU3kvdkpHMDFOQmMrUzNK?=
 =?utf-8?B?TXJXNGlYbEcremhnd3lGUG9SNWhBVEl3dHlFWkgvUmE4djg5T3g3Uy9JQkFS?=
 =?utf-8?B?bnlCSGRjd0ZORGhYWnpYanRER2thamduc2dkaW82cjUzdUU4YU5YcWttTEwx?=
 =?utf-8?B?cGRyZm4wMytqa0E5RzVWQlpPejg2RXlKd0dIRlRlUVdIMXk0bTlYemI3Nktw?=
 =?utf-8?B?MHJCaGlsRCtNcUN5YTZ2YUU4TEsvS2wrOFhmZW1QdlltVUF5WUtWbHhEYnFn?=
 =?utf-8?B?SVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 01b7f287-ba1f-4375-bb72-08de230cdfeb
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:32:13.9025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tvJZ3qlw30uV+5BeB694iuhKGUITiVxjaVcaXnKWFuA17coF6xHqWNuFCcllkD5ZHkANXKlgxVYOOCVJQOgF+An5In6evcLLStkXuudIBFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8050
X-OriginatorOrg: intel.com

On 11/11/2025 8:59 AM, Paolo Bonzini wrote:
> 
> You should also adjust set_xcr to reject setting BNDREGS and APX 

	/* MPX and APX conflict in the non-compacted XSAVE format */
	if (xcr0 & XFEATURE_MASK_BNDREGS && xcr0 & XFEATURE_MASK_APX)
		return 1;

> together (QEMU should also reject MPX and APX together in CPUID, but KVM 
> doesn't care enough about invalid CPUID configuration).
Zhao, please ensure this on your QEMU patches.

