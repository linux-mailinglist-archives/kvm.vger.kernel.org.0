Return-Path: <kvm+bounces-22078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB5C939867
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 04:49:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B39C71F21CE0
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 02:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26A6C13B5A9;
	Tue, 23 Jul 2024 02:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QlRodz5o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8594501E;
	Tue, 23 Jul 2024 02:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721702931; cv=fail; b=QSLgw1XKUB0MVgHowxyQwLqdObn89IfmoKwxgu5QxkFD9pcQh+N0yf9IGKHyIWIeIWLEEpYK8FzXjtPWXXS43wjlj10Y5ESCjeqmzFt8NGr2XaJigm64SDCAOH2jVKMkEF7CvMqAaedHCachCdjrNjD4jGXu1hjmHy3hmQXLhcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721702931; c=relaxed/simple;
	bh=YMYO77ClZH7wyCJWJLpcXGOgCioJWmutupCZTOEyKao=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IAZFCgBfOMUELE73ojyW2TVWjcQZYqmA90Dq08PaBfXbGRNG7u1aDV5oh3zbNoJjDy51paBl6EL4nIKK2FaKb7x1eeRa0qYDjlE7Xn8+Slv20uCdSX3kcgaWSiniUtxu1lTI+LRMwUeaEdc354WG+fSjUhsn71tRBe87KqJemmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QlRodz5o; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721702930; x=1753238930;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YMYO77ClZH7wyCJWJLpcXGOgCioJWmutupCZTOEyKao=;
  b=QlRodz5oYqY/d/5x9nhf90ChkDwig7l7ZEvAj2vYIkLgXjeoPIbkdZmO
   jGD62w9M3jxWWIi2jqdYKntwqYz5yzc6sCkCWF8ZHoNdGXxtRcNjaRQKZ
   cY2sAWdr2kF5tWx+IspINm++bPJSEcCLhpvmznKvsWmrNo85b8ZintVQ+
   /AKCu7D0v0bNlRu0VPO/pj1HHGiFVTLODEXp6ajRyJNfGNNtlRK6HOzJX
   8kHj5OWZn0L2xY2/14jv6nlCFmN6awP2DN+hveik8+BwJNArp+SzXtngz
   8NguXtIKGNeGz4j1ThO+otkBgOScfNgZl7z4Q8snsoTX5i1TVxQ+Rny1/
   w==;
X-CSE-ConnectionGUID: jPQZVpdYRh+6bVdhgRKy3w==
X-CSE-MsgGUID: AOK9V6jyRV6n6uNo5Ymkww==
X-IronPort-AV: E=McAfee;i="6700,10204,11141"; a="19179680"
X-IronPort-AV: E=Sophos;i="6.09,229,1716274800"; 
   d="scan'208";a="19179680"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2024 19:48:49 -0700
X-CSE-ConnectionGUID: IKM66s7+TRmB/mM9XRgnSQ==
X-CSE-MsgGUID: fe/NqoMUTdOH6saCQwpXHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,229,1716274800"; 
   d="scan'208";a="51737229"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Jul 2024 19:48:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 22 Jul 2024 19:48:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 22 Jul 2024 19:48:48 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 22 Jul 2024 19:48:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qu0fEpTGTF2ShNkMRpkJvaInAZvpR0jomEWP4B2aFp/O0N2LAyZ78WCvjYhK+zccOvHr1QY5TjKfRug4EBmrzy75X2xkaeBavT+wLjfcK6LCAse8Ebc+uHQPDFDkkwbWWAFsl/bMewW9vfllYxCGEkc8i2VQmIMcKBOsc0a3lxQv1OOcvSgB83hT4IUFJrL07QiNRri/c/lADyMhRcj4uKXPNu4jjEr24qdGfJMfqHrNu5NL+n5S9nOB+eUvdyuJ6dXNnT9NUdbNO+IxvgSzvKY5MbqHu8EmLamIOEcTLb22QhaUBBZr9YYb3qA83RFhqkTdG9mOaBxPQNKMncX3uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2YWnQLjur0AbnqOeNwWUYeqK+m1LuHV2DEeqvTGmA/g=;
 b=mWzg0o/xSG3bQaqds0X7+D4OSyXzkwQEzf7jRuY+SBnXGaUQOvVk6xDVAF9Dfqvx3pUFN86VI+5Vwrh2/kL5ah4ybWXG73dUMtlSHQxnEDX6DzNRpovPbUINTo/Nu0bkdNYsdWyqAlanVIyvYIw9es+CrvCcGC54l++d+xeGd237zSwx9lud6X0yB+XX2V17Z05NjQ81j6CG2rKwAoS/LvNB7NTiUn5y9FZCPWkm8kpoPip1quW2bTIjmAxAE1UK08GCItOBIWz8t3nbpnoZnoeP8Ns9YRMrfXmODjGHEdJHFiW+3ZRAQVfy4j3mKP/fSGwvB5RBnQExSef37sTPKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB8377.namprd11.prod.outlook.com (2603:10b6:208:487::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Tue, 23 Jul
 2024 02:48:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.7762.027; Tue, 23 Jul 2024
 02:48:46 +0000
Message-ID: <36021c91-44c6-48fc-9a63-7ff2301e200c@intel.com>
Date: Tue, 23 Jul 2024 14:48:38 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/mmu: Check that root is valid/loaded when
 pre-faulting SPTEs
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<syzbot+23786faffb695f17edaa@syzkaller.appspotmail.com>
References: <20240723000211.3352304-1-seanjc@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240723000211.3352304-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0024.namprd10.prod.outlook.com
 (2603:10b6:a03:255::29) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|IA0PR11MB8377:EE_
X-MS-Office365-Filtering-Correlation-Id: f42b1460-b28d-45a3-19ac-08dcaac1f919
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WEprZ2pkcVp1V2pKTFRKKzMvendTZy9zTVA0YXJQbzNCNituLy9qdElMcFdt?=
 =?utf-8?B?UitGenFPcVRJYnNuL0Nsd3ludFB5a3RTNWt1L3lvejhKbFJlQjdSV1RkTDJz?=
 =?utf-8?B?Yko4NU9Dd3hPd3ZSL1RXY3R3cCs4Y0ZDYzJmbWVHM0o1M2hyNEpnVHJVVDRM?=
 =?utf-8?B?V3g2blF0Tk5CeU5tUXJGeFEwODBtWlRjaXZyelhCWCthVXpkdXBzaHZJN3RX?=
 =?utf-8?B?THYwOEsvaVJLV1h5SDh5N1M4dnd3TFhNK3k0c3IwM2RxRTVYU2xiaWo4MXBt?=
 =?utf-8?B?NHV4c0VxRk1XaW1kWTlLMCt4QzY4SFdMczNhdFpTTDhHTzJIZ0Vsb0JEZW0v?=
 =?utf-8?B?UENPR0VpTnFWOGp0VzMyZENXR21adXU4NHNWekZUM2QxR3JOTTNNNW4yUVNt?=
 =?utf-8?B?bXhvTHQzUzBtQ2l2TGJhdVM0Qm5lbUt1TXE5UWdxdWNFR1p4TVkyRFo1Rnht?=
 =?utf-8?B?c2NZcUcwQTdROXJaSU85dU15Y0JIZFh5SjRmOUxETDRta1JBYk9RZjNocUhn?=
 =?utf-8?B?bnJGeXFWWVNwaUY1TDVFdWJSNlhvOWVmYTlZSm9PSXRaNUlsbmdQNlQxSjA2?=
 =?utf-8?B?cjNXVnlyTFdWNjl1dnpTTy9NTXR0N2xTbFA0c2tsWGV5VUdiOUR0L1M0Qzli?=
 =?utf-8?B?bEtNWTRWWHpzam1qbDJOb1FYRkQ2NS9lMlZVTHNtZ0wvNC9iSmpiclc3ZEVk?=
 =?utf-8?B?RjkxNlRKeHBrZGoxdGQrejNhak9vemxGNG51Um9GVDBPTk5SQUlObEl3dXNh?=
 =?utf-8?B?eHV2RTEyay9tSDdxY1hyQ3lVQlJkbk9XdzJLdTJwcUZGcEhWekZiMSsxRkdQ?=
 =?utf-8?B?U0xWc0xCdlJ5VGtscGhJMmljb29EV2R6OE9HK3Q2Uzh6aE40dXJ2KzR1WVls?=
 =?utf-8?B?a1YvTjNleXFlSWZDQVI4ZEhHZjdpaFR0YUV2Zjk0MU9IMUsreURRWHRCeGFK?=
 =?utf-8?B?SCtIdFlWT1gwaU9VZTFNMlZ0WG4wa2lYQjdIeUFVcXk3VlZOWWFrTzRxMEFN?=
 =?utf-8?B?V0dyb2JkQXNMandGYXlpWlNhc2FzeHdpblM5bkw3MXZFUHVrdGRFczBXWU5H?=
 =?utf-8?B?QlhXV3g2Z1FvbE5iUlIvRHZVYWJlWS9vNmlHcTZMdDJBQSs3SVc0QXNCOHhX?=
 =?utf-8?B?YlpRN3BPa3ZHUUNaUGU2WkVpVzFKK1dWSTV2UDBRbEtNbHNRWWtpb0Y1dW0r?=
 =?utf-8?B?VXppNGFOckRGblZjMFExcGFmUHhyUldoSHRVdmoxU0JUeUd2ODAxNzZRdTJk?=
 =?utf-8?B?TndaN3EyMmRleVJYb2hsV1Jsc2hUb0Q1RmpRTmw3R0EyalhIRG95Nitqc2w2?=
 =?utf-8?B?eHloRkRiQnZ1dUJTUEl4VStxMzFpbzEwM2Z0QmZiaDZFWjlhdFI3Y1pNMnNQ?=
 =?utf-8?B?NUFpRlNwaDdkUjVseGRubWR2S0hPdjFrby9mWjBjTEdqSEJZNm0wOFhlalFl?=
 =?utf-8?B?Y3p0R1hyV3UyTmQzUFpuM05NTTRaUWNKVkoxS3JuZ3NlcUpFMDZIL2tzazlB?=
 =?utf-8?B?SjYyRFExclJTWkhjaG5Zcld0VlU0WjhaQWtoQkVVR2s3V01jUHFXaUU2WERD?=
 =?utf-8?B?K2MxdXQvTjlLSVZOZGMvdUljV3RIaExpQmdFV2YwSTVxd1UybnVrY0VEVnVy?=
 =?utf-8?B?b2pieWIzNi9ndFBJMkxISERPdGQ5d1hOU0pubHRqYWxkN3JzMGZxdnZIcFlj?=
 =?utf-8?B?SUo5dkJtdlRzeHlpVzREaHZPNmpnYXd5Z3kreG9UcjJhQkdlSmM5RURzazFU?=
 =?utf-8?Q?NA/mSaVkdfiMcAliKU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ri9zdFRILzA4V090S3ZuL3NzS2EyWjJYaDF1c2dET2xpeEZLa3lHdU9CLzV4?=
 =?utf-8?B?NE02SEZBL2lIaHU3NVhUeVRaYmNpTnU3SnV1alkwa0xIVGN4WFhJalFJNnpC?=
 =?utf-8?B?N2FiVlo4eXNLMjZrTXd2Zmc1WHZyc2trLzVaOGlGdmdlKy8yUklVdVBsRk8v?=
 =?utf-8?B?dTRGekhja1NXSTVNa1E0R2ViMnB2aUNDekpmY09nc282MEdQS1V0Mkt0M1Nv?=
 =?utf-8?B?SHBhVElzM2ozZnJ0TVB5aXloTU5XWW05emdKcGh2Z1dRUmN0NWhISmROOEtt?=
 =?utf-8?B?WDYvOW1aOTRqQVAybTJRcVRLaVZOWG5KS1ZrWDczU2hZZ0JpR2NlbTBSNGN5?=
 =?utf-8?B?QndqalRGU3l6Mm1YTzUxMWdhU0RzeTViSmFlTlhhK2h3QnVhRGQ1UVVmdUoz?=
 =?utf-8?B?M2UwelZZTkcvaGVMZFU1WmlQYWdSQlRMR2tXN1ZpTzFnbEZUbm5VR1YyZzRo?=
 =?utf-8?B?OWo2ZGZvbEVBbUpwVElMdFZraldBRmxvdUQwWXNnT2ZQWGVzQ3NlaWdEL1Vs?=
 =?utf-8?B?VktsWlNYaFRSMDRLSCtVVHdCTE5NSFVESUJTRGNDUXhQeDJ0UjA5UkUvVVFH?=
 =?utf-8?B?K2xmejZJSm9yOEdIaVRXZjB1V0Q0QlQzYlhrMklrVW5acWx1dDRrN1J6M0t2?=
 =?utf-8?B?Z2FYVElKSVJqaWpIcDNkdjhKUlAyc2pWb1hTZkxLengrbllNQ3ZZS091WWhR?=
 =?utf-8?B?VzJDM3hTaHRtcmVvUGJPSmFIM0FxWHZYQmI3cmpYU3BvM3E2ajluUXk1QmxU?=
 =?utf-8?B?di9iR3RYb1ZVcS93SDBSUFZJWEtuOVJROWkvbDNvb1dRN0lzeFowMVEwdE5C?=
 =?utf-8?B?NVFEY1ZIZUhGMEEyaWFlRnQzL1ZYc0tQa1hDcjF1S2VGcFNFeCtMZE44WWxr?=
 =?utf-8?B?NjZxK05aNzExaU82Z3libXg2OWdDTWpMdmpPZFlsYWJFTkxDeFNKSCtlVlNS?=
 =?utf-8?B?RjFjeHhlT09zbTV5NWNvaFVER3dLdEU3clNuQU4ybk1tcU43YjBPREIrL1Iv?=
 =?utf-8?B?TjBQb2dVMXQ2QTdlQlp3a0tOQ0ZkNVdJME5zeHBsRGhrYjllZk9xcGRaR280?=
 =?utf-8?B?R00yMVBaQXFCRkZLdnpxaFB1enphcW5Wem1lNjFSTGEwdnZDYUkvdG1XQzQz?=
 =?utf-8?B?UnFHbmxrK3cvT25ObU1WcXNSRFNxQWc2S3E0bFJkUVc4YmxkQjJvUWh0cFhU?=
 =?utf-8?B?RkxUMkJZbVZqYlpySS93dTJsbnRCbTdJS3E1MnRLVW9HL2JXbEdmaFJXNmpl?=
 =?utf-8?B?WVg5b2h4N082OFB3L0dqbHRaaURxZUE0dmpZY0VvNENOR0t5Q0YvYy9lQXlF?=
 =?utf-8?B?KzVoRE5FWitjRUxtTGdlbjJ2RUM0M3dpdU4wYVE3TzRFcGJzL3ZKaHUraFJi?=
 =?utf-8?B?OVVmUTJ6aTBtWTR2V3VJS3c1L1lFWFd1blZxNmVLMVF5R1pPUmx5SjRHL1NV?=
 =?utf-8?B?S2xSTHFLQUVuWW9weEhkaXRhbGpxMTg1SWw4VWEvRWxwYm9RdkovYnN5S2Vl?=
 =?utf-8?B?eERndHNnRjZIdjJId3gzaUR5Y1RRVlBFM3VvVklxWUxoMTlRM3p3QlA1VUFu?=
 =?utf-8?B?clM0SGFXekY5Y1JoZjV4TE5NeEo1TC9uOFdYZG9ObnVXaXg3TEIxMVVqeXRy?=
 =?utf-8?B?c2hNamZ2Z1pnbWJFaUhMYjhMVVR4REFOcEgvaC83bkYvL1BUTCs4SWNYOGhS?=
 =?utf-8?B?QzVJN0pJN2tSQ0tGR092cHlkS1EyN1RqWks4MXFtUWQ0TVdEenpjdFYwL2JS?=
 =?utf-8?B?RmdFZ0ErSEY0T1YwK1lNZWMzQXJ1NHA1eUVGTnZnMXV1VzEvcm5Xb3RaU3Ez?=
 =?utf-8?B?QmZlb3RyM3JpdklUWDJUMmlOY3pIelEveWQzeFZQNkg3WGlja0FoY0I5Ulcr?=
 =?utf-8?B?eHlxaHJ5cUtzMGVEb1VienVmRllVcHZYSVB5QnNmeDREdU54OXBHTjBhWVZB?=
 =?utf-8?B?YnVGQTQrQm9VMGtFQ21QZnByUUZHL0dRSTVxVTd1Rlh2REJtZVg2TVRkSHpM?=
 =?utf-8?B?V2YrVm55RGVnY2xLV2NPWm5oRi84RUVOVGpPU2Y3MStHUHVLNUR6SHh5YzJY?=
 =?utf-8?B?TnFNNytmSGtQSmpmay9jSEhKTDdYSWwyU2krL2xrY1dKNzEwQmhKdnhZR3pm?=
 =?utf-8?B?SXJYaXhsWTN6R0hEV1ptaFdIL1FybTBKSjFWNEpIek5TbXhuMDlzVFJLenZt?=
 =?utf-8?B?Z0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f42b1460-b28d-45a3-19ac-08dcaac1f919
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2024 02:48:46.5630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DlZh0sRt0B3a76IfvL768sLWP4GhPHjlR6nEswD4bKhKgH2fQ20Nnu3sCGDoN9RRUGPfrz/+f4y8SA/aM23rdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8377
X-OriginatorOrg: intel.com



On 23/07/2024 12:02 pm, Sean Christopherson wrote:
> Error out if kvm_mmu_reload() fails when pre-faulting memory, as trying to
> fault-in SPTEs will fail miserably due to root.hpa pointing at garbage.
> 
> Note, kvm_mmu_reload() can return -EIO and thus trigger the WARN on -EIO
> in kvm_vcpu_pre_fault_memory(), but all such paths also WARN, i.e. the
> WARN isn't user-triggerable and won't run afoul of warn-on-panic because
> the kernel would already be panicking.
> 
>    BUG: unable to handle page fault for address: 000029ffffffffe8
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    PGD 0 P4D 0
>    Oops: Oops: 0000 [#1] PREEMPT SMP
>    CPU: 22 PID: 1069 Comm: pre_fault_memor Not tainted 6.10.0-rc7-332d2c1d713e-next-vm #548
>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>    RIP: 0010:is_page_fault_stale+0x3e/0xe0 [kvm]
>    RSP: 0018:ffffc9000114bd48 EFLAGS: 00010206
>    RAX: 00003fffffffffc0 RBX: ffff88810a07c080 RCX: ffffc9000114bd78
>    RDX: ffff88810a07c080 RSI: ffffea0000000000 RDI: ffff88810a07c080
>    RBP: ffffc9000114bd78 R08: 00007fa3c8c00000 R09: 8000000000000225
>    R10: ffffea00043d7d80 R11: 0000000000000000 R12: ffff88810a07c080
>    R13: 0000000100000000 R14: ffffc9000114be58 R15: 0000000000000000
>    FS:  00007fa3c9da0740(0000) GS:ffff888277d80000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: 000029ffffffffe8 CR3: 000000011d698000 CR4: 0000000000352eb0
>    Call Trace:
>     <TASK>
>     kvm_tdp_page_fault+0xcc/0x160 [kvm]
>     kvm_mmu_do_page_fault+0xfb/0x1f0 [kvm]
>     kvm_arch_vcpu_pre_fault_memory+0xd0/0x1a0 [kvm]
>     kvm_vcpu_ioctl+0x761/0x8c0 [kvm]
>     __x64_sys_ioctl+0x82/0xb0
>     do_syscall_64+0x5b/0x160
>     entry_SYSCALL_64_after_hwframe+0x4b/0x53
>     </TASK>
>    Modules linked in: kvm_intel kvm
>    CR2: 000029ffffffffe8
>    ---[ end trace 0000000000000000 ]---
> 
> Fixes: 6e01b7601dfe ("KVM: x86: Implement kvm_arch_vcpu_pre_fault_memory()")
> Reported-by: syzbot+23786faffb695f17edaa@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/0000000000002b84dc061dd73544@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Kai Huang <kai.huang@intel.com>

