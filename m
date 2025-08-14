Return-Path: <kvm+bounces-54696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60EDBB27188
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:19:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB59D1C881E5
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 22:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A396280308;
	Thu, 14 Aug 2025 22:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FJlhXANL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEC6166F1A;
	Thu, 14 Aug 2025 22:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755209961; cv=fail; b=g1XowNHpXwBZ/CE/LAZPktbvjE9vCHDlZ5ivudC9Aic84YPlKvDSu0lUz8nnLzJTtaujr+Au2Dwt0OYx4OWpr0Q1s/zFsb3B6i30taVQfDy0B2qTm4HC8JIi+wjvhQjMFo7+XIgQa7RPMNXYbvP5+e19dObywVP9glzGrvLzh3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755209961; c=relaxed/simple;
	bh=iTzEwTTcx0UtG8ITEhRvjmaSRz4NPfLCLMe33XqWwnI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sdcrcqbGZIG3wI4AByC/hj5eobDmPI7H1smCba10Z5YyoPLt/Afq8nVu0cv1Vd83Tzysj28VmTfjBw5pJ2hipCVV/MaMxqM+6PVadqFBs4EUTezb5RzdZPOrtr2eWFHdTdWRRDeqV4m3qWRjp0GrC0cIDrOmUFL1MHSv8CbWQfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FJlhXANL; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755209960; x=1786745960;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iTzEwTTcx0UtG8ITEhRvjmaSRz4NPfLCLMe33XqWwnI=;
  b=FJlhXANLOXWfFXBaDnHVlhYvgFJWwaI41GW0aJG7YnLsP/EUf7MGnJ8r
   iGZT0gdchseRxskfAcvDblA8jPvuTAXXnDVptrcOAQsz3KcW/aUAp3/i8
   ATR0JtvQyQXf3GiQ0gGAeNzKvfdkA1r4Bi/vtQAlBtg44t7TrrjJ8xqtz
   c3Ry2ZV2z7LEmJu9aTWuuIlMkXxWs392lgzsnu4tWZ4ew2h10tjDaJziu
   y5XyIImhB2HDsJ4vzGsr8lFoeANfTs3mWxAYbbxb9fwtKExBW52iAAxon
   r03XETPbE62x3OuuuqVz+1uJGcF4l1xTdEbAMQXcyOMlUgFRBfO1uJ9ln
   Q==;
X-CSE-ConnectionGUID: JsESzwzrS8+o1DG3WCdt6Q==
X-CSE-MsgGUID: 1zLxGLTzR+yykCLLJyZN6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="68143679"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="68143679"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 15:19:19 -0700
X-CSE-ConnectionGUID: adQ5HtpxRzWwqnftt2FUVw==
X-CSE-MsgGUID: hpSQpCJMQFSguq5hQrTwhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="171000331"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 15:19:18 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 15:19:18 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 15:19:18 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.73) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 15:19:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N98YFn0S2c4tQNBPeALJ+YhrNlrsUSdxMj/er0dUs5aOyd2ivTtBBYMxanLKKTyjr9Py+2GeGru+0l3knkDDpJ6llnjllJMBkp5I5o0RfLKLWULj0Uj2Rny9qLW8O/VSQ9uVWczNqcH0vXBE9y5S+x24rGgO1zPXNMFBz4kamgkRQKR1i09On2DeYVjhdCQQizJfM6vbAeRnO3+zdu65M06yF+KJKCrCdAkjrcWqyZ+pHK++pwCeXaS4GAw0i8quI+OOFIt5kfX6kryNMmIOjng4ZZ9L2lsQR9tKPqrniZIgXSUYVmGz+0Quz8V+56T4pl/JCoQtc2zCcODjw+uBAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iTzEwTTcx0UtG8ITEhRvjmaSRz4NPfLCLMe33XqWwnI=;
 b=zPmDp6KTPY2CPay4v3H/IHq4Ie/cSXP1oP5T9bKBgUAnHxPPx6Ro5dYBAHPlgS7Rg31vM88k3V7X32mzoswGhcHUkSEOvG2c15HiozJqznFClidrH7JHCU7E/DexynhiHgv0Kvkv4y4KssoXSpj/TtBiiR3j/SEtgWmus/KYwNdm/4xmVYDAXOmW8Py6Y9ylsGIaB4xFMZZAnefqzkFFv2QWSM9SF2Bom9i8LmT85rCqFqJgciGt+I2FUgQWqxC9TorthPUbRgxznW5Zq85Rf5XoFiZeAJlYIcvqYDHKzrtEes8g2LOXQuxfFfIdQpgdbtNdtTVFcIYj/CVw3GBFSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CH0PR11MB5236.namprd11.prod.outlook.com (2603:10b6:610:e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Thu, 14 Aug
 2025 22:19:11 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 22:19:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kas@kernel.org"
	<kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "dwmw@amazon.co.uk"
	<dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com"
	<sagis@google.com>, "Chen, Farrah" <farrah.chen@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Gao, Chao" <chao.gao@intel.com>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Topic: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Index: AQHcDKj0KRQjWZhTjEidjLxSJo7SHrRiLIQAgAAdHQCAACfSgIAASCAA
Date: Thu, 14 Aug 2025 22:19:10 +0000
Message-ID: <d2e33db367b503dde2f342de3cedb3b8fa29cc42.camel@intel.com>
References: <cover.1755126788.git.kai.huang@intel.com>
	 <d8993692714829a2b1671412cdd684781c43d54a.1755126788.git.kai.huang@intel.com>
	 <aJ3qhtzwHIRPrLK7@google.com>
	 <ebd8132d5c0d4b1994802028a2bef01bd45e62a2.camel@intel.com>
	 <aJ4kWcuyNIpCnaXE@google.com>
In-Reply-To: <aJ4kWcuyNIpCnaXE@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CH0PR11MB5236:EE_
x-ms-office365-filtering-correlation-id: 54002e85-71db-4171-3feb-08dddb8097ee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?clRtSTRlV01xYmxvc2Z2ZmhjZ1hZaUJSUkZqMXN3cG1nWmVPQzhyV1l0NnlN?=
 =?utf-8?B?ZFNQcGgxM09zNUx6VHhGbmdUcE1UM1BkQVM0MzhqQUV5eXFZOUJsOWJnbFBs?=
 =?utf-8?B?d3dZblJ1RGJaRE14RlNiWTBUTFdDU2EvQnArRjhham81dDJiZ2dPZWlOaktx?=
 =?utf-8?B?R000MHUvYkZRaGNXd3dzbXZ0eDVXL3hZQnFsdnZTbWRkRWJDL3p4MEZnQVR6?=
 =?utf-8?B?SlAzNGJsek5HRjkyZHk5c2NRaVhLcisvdnVxTi9rUE44WkliV3ZsUTAvamJ4?=
 =?utf-8?B?OFlOQjQyRE5kYVJmWHJERGlTZlpwQkk5MVRrNkdsUy8wZE1oL2MzNGRFVXpG?=
 =?utf-8?B?T1ZObU14QmZpSFdvNjJ1bzRSMkVCOWFwVFRQWGZ6RTZvSlBwd1owZExoTjF0?=
 =?utf-8?B?UlQ4ZHRlaXBtaThVbCtwRHQ4em5WbVJjSHYzV21qa1BrOVZqanBlcDBlMnZR?=
 =?utf-8?B?eUpINmk2NS9DcU1rcUcxSGgyTHVlTkJRWUxReHhQaE53L1hUaTBvOVpRcWZQ?=
 =?utf-8?B?WEY5MnluaHo2VDNmeWhrSzFJQTdSeUpRbGlCQUVVNUltNkRJcTRIYysxVXR1?=
 =?utf-8?B?YUxqNTR5VEM3VUxtUFlRVnE5bDNhQUtUQ3VyT2FOZ1Y1QVplcHlqblBQRTNX?=
 =?utf-8?B?SWNXWFhDcFQ1YkdoSDlrUlBBY1pTcVhTSnltN0xaNjFwV21pTmtlWDJINWNZ?=
 =?utf-8?B?RGdLUmliS0hzd2JuY0c4ZWdKNS9zOVVHWGQ5WWpZSjJrWHpSNjVnVXJpa2NQ?=
 =?utf-8?B?UTFpeitmd21ONkxKenR6aW44MGsvTUpBUFVER3MzZEYrcGtidVZabkVWNmt5?=
 =?utf-8?B?dnRuK2dKdTkrRmxjSk0yWUdoWVpYaUpMck9sUGl2ajZiV0ZMd3lkZEUrUy9F?=
 =?utf-8?B?elpLRUc5NllIZTRZdTREYUl4YjZnQVgvYXBCdjByaVV1ODVMUUY3ZzdBZXlL?=
 =?utf-8?B?eWl2Tk9EYy9WRXVnTVRWUkZjblhvbE1BeXRxNTJEcWNpMVpKT3daY3RONDlN?=
 =?utf-8?B?VjJMRDQ0RjlxMWo4V0lWa0pLRTVPTHJEQ0tLTWlZb1RGbElRSDNPbGtlcGZw?=
 =?utf-8?B?M0tQd0l2ZnJYSUpkcFZDb3hmbTZpc2ZjUm4wL2NoK3JJVFgzbVlsTkhacjhY?=
 =?utf-8?B?OGVaVS9WSDNaaEZ5bDFPNW03TFExcU9tUXJUYjlpS3dqcFNSYmY5eUxVRTVk?=
 =?utf-8?B?clc1ZnA2R20ya1hzQ2ZucGp0MVZnNFl3NHVVZngxZHNYSjNXTnRHQVdHOHlV?=
 =?utf-8?B?aWRPS0V5ZThKRmtLZWQ0REV4UHVuT2ZTVU1KNXBSV2VGcVdBZmlHeHhzMkd3?=
 =?utf-8?B?WmhWdWI2VW5mZ0lnZHV1V2t3bmEyVFN0U1B4dVk1MGRUSmRrUWc3VUt4aWUz?=
 =?utf-8?B?YVp5eUxnbWRGZU45VjRpRzdPYzNsNDRSTGQ1b290WCtndlhCL3J6OUZybjM4?=
 =?utf-8?B?eUtZbTJ2NlNrUjA0ZkhIcFVwbWJNMVZHdFEyOWIrK3dqdXcvYTlmSUx1am1r?=
 =?utf-8?B?RGVLd09Zdm9Zb3M5ZFg1T2hycE96ZFJ3N2NadUpBelVCeGlwNHdJeC9GTFpq?=
 =?utf-8?B?bll6Q25IWFFFcVhhVEdseWVkaDNYdlBnaUJZejFVQWtPTUwwOWg4aUQ5a3Jn?=
 =?utf-8?B?Sks2V1dZYUZaQmUwMks1RWl1ZTJNRFJNYnpRdVNqeDRtbzBXUDNZekQyT3E0?=
 =?utf-8?B?S2lTQWVqR0VCcjRxd2JKbnVFdFh0T3ZXTitGQkN1R2NteTAvN01QbzFpUDht?=
 =?utf-8?B?SWMzNlZJaVpCQ1A3ZElkZjJyR3J0aG9DdFAzOHFNOXB4VFY1aC9GY1pnWjBV?=
 =?utf-8?B?Wk4rUWhsdStpbzFxVmNHRXdSWkhwNWQwYmdNN2VSNlRSVVBwWExiTjVYZUhp?=
 =?utf-8?B?cklLb3dsYldnNnp0NFZwTm1NTm5xS0tFSUZwT2ZFR3FDRGJlT0tBQ0k3ckVU?=
 =?utf-8?B?aDd6UXBmSXdwTlhUSkJWMHYzcHNxT3ZEUmhUSHM0cTRwN0wzUFBtRFd0ZGY5?=
 =?utf-8?Q?8pdVuPkruZ5XG9iTL2om30L3MCzJiQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmNFSmx1cUdWbmtlMmVqbVgvbWVDcWI2SGdvbU1qTHMybWZEcURkVkt0QjZl?=
 =?utf-8?B?c2lUWUs5M0RGZW1IOW5uUzZSVndhWVdJSHB0ei9vZzJZN1ZVbFhBUnVHcjli?=
 =?utf-8?B?dnJUUU1DWFFNd1p0RmJ1MlVPWXlpbWd0V0VnUUdaVjExV3lGR3BPeisrSDBW?=
 =?utf-8?B?RWFQM1RmbGlNRFc5dWdhUjVUemh5dEVBMGpuT053Vm5YWkIyWlV5NDB2V25t?=
 =?utf-8?B?TFdHT1drT1FRTVowNzRVaXBpYS9VRUFXbzd5M3pta21SWnV1Qk5BL1FueU42?=
 =?utf-8?B?eUlrTmRyWGZScVFoVzlaSnB6ZUhqamxqMVVzQnl2ZGRObTM4ZmRtOHQ1bEFC?=
 =?utf-8?B?M2RSNTRDY0pQN2h0ZFF5MU00dGRDNTdXQW9qTnVRdFBMU2pqMHprQXdPcDlv?=
 =?utf-8?B?akMvWlNDdkNNSnhwWmJCeTFjazhiSXRxdHhIaFBzZ0xzcTFmclB2OEdhYnJi?=
 =?utf-8?B?ZHk4TnRsY3FVZDdMWXlZOW1qb0UvZHB6QlRiYjlkaGs3b0ZGdUFDQVA5cG02?=
 =?utf-8?B?QTdSTElGeitRQjB2TUF3UVd1a1pQYlJ0TmFtVEdKUktodEFmUE5yRURPMVM5?=
 =?utf-8?B?Tm1Pd3ZIblA1a3c3MVV0eVJiL0NjT1J4NzlzWXhGUCtCazZpQ2NVam9qSjdD?=
 =?utf-8?B?bU0xY2FLWkMxcXZjRWhmYUl2N0t3YUpacjl0MnBrQk51QkM3Sk40dC92SDY4?=
 =?utf-8?B?RWJMK3R4OGJsbC8ybU95Tnl0TGRrMHVUenE4blA2N2hxOVZCSnFqS2hXUG9p?=
 =?utf-8?B?Rkk3OWdlK0daeVl3eHBlNFplRURla1JlUHBSSlZrU0FoOHA4OGNFMk0yNDJO?=
 =?utf-8?B?eXVjV0x1RS9ZdjBiRmhHSnVJdEtCL1hlRUd1M3EwbHVyVDRIaDE2MUVIYTB3?=
 =?utf-8?B?cWF1cVAya1RkTk5SeVU4azhTeXd6d0dKanlyWGdRM1ZMMTR2aWRMNHl0MVhJ?=
 =?utf-8?B?MXBtam8zNWFCQnowVDFESkhmSk9QOWlOQjJjM3ZKTk9UbFZvWlFhTnpRSlJj?=
 =?utf-8?B?bitTTE5zV3g1akY2MXR4bjhIZTNQRnRZeGlNYjBGbVNMbGk0VGllSXVwZVNK?=
 =?utf-8?B?a21YTlB2TkE2VjJSMUV6alhSOTJHcEpvcTlLMjZLSnR3Ris2emlVTWJPWHJW?=
 =?utf-8?B?VVJEYmlFMTVTN0xJblpXNmhJVGJtckRLaGxSc0JJUTdNcmN6TnhrZDQ0WDh6?=
 =?utf-8?B?amt5MHFwRk85M3d6VnBSYnpJN1FNMW5lTG1TSmp2ZU5ZVTkyeHphWXIwZzRI?=
 =?utf-8?B?QURJMmIyMkEybktwUko3bWNWdUZTRzkway8xR3IrWE9EL2lJdG43bDdLRFRv?=
 =?utf-8?B?eDQxVXI3NGJQZCtjbVJVcXpOenY2L2tlQXRWTzdoSXdHYmZlK2VNdjVzV2pw?=
 =?utf-8?B?eXBkcXRpR3d1dUQ1cFVXTThybVM1SEFHam5Gc0dNNUxtV2Q4MzNhajd4bEJk?=
 =?utf-8?B?VTF4OFo4cnhtcElWQ1E0ZEo2VTBJNGhBRDh5QSt3MFRQbFJVdTVZNzA4U3py?=
 =?utf-8?B?REZtMmx4TzZkUUhDTnRodjJjaFVwcHJGUll6WWhGUi94MXJQcUdsTzdXMXBa?=
 =?utf-8?B?Ujhyc3VJOU1KY3hHMWRERHBpSmR2WitkZlFONE1vamdaUGx5QkJteHlqdjl3?=
 =?utf-8?B?Qnh2MXYreTMxeWxIekFzUnovdTY2UTlTQnkrcG1kRGdySVhVcDQvd25KaFJG?=
 =?utf-8?B?MGhTUC9aaDdhK0gxMldUVWFmc2dseW5GS3kyM1cwaEY3dVdxRWJLYzF1STJO?=
 =?utf-8?B?ZERDTWtScU4vWFNRaTV3MzBBME5yZ25kWTJtcGlkZVBuNDRxVllKQStBOXJ0?=
 =?utf-8?B?b29oMjZOVURVZUpHUmNlVXpqSUhVZ1haNFZ6Y1hlODJCOGxxdHRwTUJKWWxB?=
 =?utf-8?B?ZFIydWhrWTJhYjhtcGF1VytLTlR1Ry9KQXlkcHhRTnhQTEI4MzA5a2lzdkFN?=
 =?utf-8?B?Y3NkS0xJR1dmaDFtdVhQVEcxaTllMzVHTnpnMFBKdVNwRUs1TWRLdWN2cmda?=
 =?utf-8?B?SnZvWnIzNzhNaXpFaG9nQTJOd1h4VFlabjNIYWI0UVNuYm5LcHJiY3ptVkF3?=
 =?utf-8?B?RW9DR08xMjdYV3FTeGlqRVpmZXpjbmVxRFlUcGJQb2dweGhwdFhjMkUyMkIr?=
 =?utf-8?Q?BW/fGUAPEor8nd3PGD1tuDyMy?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1074F51B3A06F34689AB150BD39396D0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54002e85-71db-4171-3feb-08dddb8097ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 22:19:10.7272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wgbkRbOWR3x7ljBII0mwOr3vFq27tx2oULyFpJL0mGOPX+pHCanWsS/XvRDIXZCpN2rx9BBP44B12aZLFz2F2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5236
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTE0IGF0IDExOjAwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEF1ZyAxNCwgMjAyNSwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBPbiBUaHUsIDIwMjUtMDgtMTQgYXQgMDY6NTQgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+ID4gPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jIGIvYXJj
aC94ODYva3ZtL3ZteC90ZHguYw0KPiA+ID4gPiBpbmRleCA2Njc0NGY1NzY4YzguLjFiYzZmNTJl
MGNkNyAxMDA2NDQNCj4gPiA+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiA+ID4g
PiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ID4gPiA+IEBAIC00NDIsNiArNDQyLDE4
IEBAIHZvaWQgdGR4X2Rpc2FibGVfdmlydHVhbGl6YXRpb25fY3B1KHZvaWQpDQo+ID4gPiA+IMKg
wqAJCXRkeF9mbHVzaF92cCgmYXJnKTsNCj4gPiA+ID4gwqDCoAl9DQo+ID4gPiA+IMKgwqAJbG9j
YWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsJLyoNCj4gPiA+ID4g
KwkgKiBObyBtb3JlIFREWCBhY3Rpdml0eSBvbiB0aGlzIENQVSBmcm9tIGhlcmUuwqAgRmx1c2gg
Y2FjaGUgdG8NCj4gPiA+ID4gKwkgKiBhdm9pZCBoYXZpbmcgdG8gZG8gV0JJTlZEIGluIHN0b3Bf
dGhpc19jcHUoKSBkdXJpbmcga2V4ZWMuDQo+ID4gPiA+ICsJICoNCj4gPiA+ID4gKwkgKiBLZXhl
YyBjYWxscyBuYXRpdmVfc3RvcF9vdGhlcl9jcHVzKCkgdG8gc3RvcCByZW1vdGUgQ1BVcw0KPiA+
ID4gPiArCSAqIGJlZm9yZSBib290aW5nIHRvIG5ldyBrZXJuZWwsIGJ1dCB0aGF0IGNvZGUgaGFz
IGEgInJhY2UiDQo+ID4gPiA+ICsJICogd2hlbiB0aGUgbm9ybWFsIFJFQk9PVCBJUEkgdGltZXMg
b3V0IGFuZCBOTUlzIGFyZSBzZW50IHRvDQo+ID4gPiA+ICsJICogcmVtb3RlIENQVXMgdG8gc3Rv
cCB0aGVtLsKgIERvaW5nIFdCSU5WRCBpbiBzdG9wX3RoaXNfY3B1KCkNCj4gPiA+ID4gKwkgKiBj
b3VsZCBwb3RlbnRpYWxseSBpbmNyZWFzZSB0aGUgcG9zc2liaWxpdHkgb2YgdGhlICJyYWNlIi4N
Cj4gDQo+IFdoeSBpcyB0aGF0IHJhY2UgcHJvYmxlbWF0aWM/ICBUaGUgY2hhbmdlbG9nIGp1c3Qg
c2F5cw0KPiANCj4gIDogSG93ZXZlciwgdGhlIG5hdGl2ZV9zdG9wX290aGVyX2NwdXMoKSBhbmQg
c3RvcF90aGlzX2NwdSgpIGhhdmUgYSAicmFjZSINCj4gIDogd2hpY2ggaXMgZXh0cmVtZWx5IHJh
cmUgdG8gaGFwcGVuIGJ1dCBjb3VsZCBjYXVzZSB0aGUgc3lzdGVtIHRvIGhhbmcuDQo+ICA6IGV2
ZW4NCj4gIDogU3BlY2lmaWNhbGx5LCB0aGUgbmF0aXZlX3N0b3Bfb3RoZXJfY3B1cygpIGZpcnN0
bHkgc2VuZHMgbm9ybWFsIHJlYm9vdA0KPiAgOiBJUEkgdG8gcmVtb3RlIENQVXMgYW5kIHdhaXRz
IG9uZSBzZWNvbmQgZm9yIHRoZW0gdG8gc3RvcC4gIElmIHRoYXQgdGltZXMNCj4gIDogb3V0LCBu
YXRpdmVfc3RvcF9vdGhlcl9jcHVzKCkgdGhlbiBzZW5kcyBOTUlzIHRvIHJlbW90ZSBDUFVzIHRv
IHN0b3ANCj4gIDogdGhlbS4NCj4gDQo+IHdpdGhvdXQgZXhwbGFpbmluZyBob3cgdGhhdCBjYW4g
Y2F1c2UgYSBzeXN0ZW0gaGFuZy4NCg0KVGhhbmtzIGZvciByZXZpZXcuIFNlYW4uDQoNClRoZSBy
YWNlIGlzIGFib3V0IHRoZSBrZXhlYy1pbmcgQ1BVIGNvdWxkIGp1bXAgdG8gc2Vjb25kIGtlcm5l
bCB3aGVuIG90aGVyDQpDUFVzIGhhdmUgbm90IGZ1bGx5IHN0b3BwZWQuIMKgDQoNCkluIHRoZSBw
YXRjaCAzIEkgYXBwZW5kZWQgYSBsaW5rIGluIHRoZSBjaGFuZ2Vsb2cgdG8gZXhwbGFpbiB0aGUg
cmFjZToNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtL2I5NjNmY2Q2MGFiZTI2YzdlYzVk
YzIwYjQyZjFhMmViYmNjNzIzOTcuMTc1MDkzNDE3Ny5naXQua2FpLmh1YW5nQGludGVsLmNvbS8N
Cg0KUGxlYXNlIHNlZSAiWypdIFRoZSAicmFjZSIgaW4gbmF0aXZlX3N0b3Bfb3RoZXJfY3B1cygp
IiBwYXJ0Lg0KDQpJIHdpbGwgcHV0IHRoZSBsaW5rIGluIHRoZSBjaGFuZ2Vsb2cgb2YgdGhpcyBw
YXRjaCB0b28uDQoNCj4gDQo+ID4gPiA+ICsJICovDQo+ID4gPiA+ICsJdGR4X2NwdV9mbHVzaF9j
YWNoZSgpOw0KPiA+ID4gDQo+ID4gPiBJSVVDLCB0aGlzIGNhbiBiZToNCj4gPiA+IA0KPiA+ID4g
CWlmIChJU19FTkFCTEVEKENPTkZJR19LRVhFQykpDQo+ID4gPiAJCXRkeF9jcHVfZmx1c2hfY2Fj
aGUoKTsNCj4gPiA+IA0KPiA+IA0KPiA+IE5vIHN0cm9uZyBvYmplY3Rpb24sIGp1c3QgMiBjZW50
cy4gSSBiZXQgIUNPTkZJR19LRVhFQyAmJiBDT05GSUdfSU5URUxfVERYX0hPU1QNCj4gPiBrZXJu
ZWxzIHdpbGwgYmUgdGhlIG1pbm9yaXR5LiBTZWVtcyBsaWtlIGFuIG9wcG9ydHVuaXR5IHRvIHNp
bXBsaWZ5IHRoZSBjb2RlLg0KPiANCj4gUmVkdWNpbmcgdGhlIG51bWJlciBvZiBsaW5lcyBvZiBj
b2RlIGlzIG5vdCBhbHdheXMgYSBzaW1wbGlmaWNhdGlvbi4gIElNTywgbm90DQo+IGNoZWNraW5n
IENPTkZJR19LRVhFQyBhZGRzICJjb21wbGV4aXR5IiBiZWNhdXNlIGFueW9uZSB0aGF0IHJlYWRz
IHRoZSBjb21tZW50DQo+IChhbmQvb3IgdGhlIG1hc3NpdmUgY2hhbmdlbG9nKSB3aWxsIGJlIGxl
ZnQgd29uZGVyaW5nIHdoeSB0aGVyZSdzIGEgYnVuY2ggb2YNCj4gZG9jdW1lbnRhdGlvbiB0aGF0
IHRhbGtzIGFib3V0IGtleGVjLCBidXQgbm8gaGludCBvZiBrZXhlYyBjb25zaWRlcmF0aW9ucyBp
biB0aGUNCj4gY29kZS4NCg0KSSB0aGluayB3ZSBjYW4gdXNlICdrZXhlY19pbl9wcm9ncmVzcycs
IHdoaWNoIGlzIGV2ZW4gYmV0dGVyIHRoYW4NCklTX0VOQUJMRUQoQ09ORklHX0tFWEVDKSBJTUhP
Lg0KDQpXaGVuIENPTkZJR19LRVhFQyBpcyBvbiwgJ2tleGVjX2luX3Byb2dyZXNzJyB3aWxsIG9u
bHkgYmUgc2V0IHdoZW4ga2V4ZWMNCmlzIGFjdHVhbGx5IGhhcHBlbmluZywgdGh1cyB0ZHhfY3B1
X2ZsdXNoX2NhY2hlKCkgd2lsbCBvbmx5IGJlIGNhbGxlZCBmb3INCmtleGVjLiAgV2hlbiBDT05G
SUdfS0VYRUMgKENPTkZJR19LRVhFQ19DT1JFKSBpcyBvZmYsIHRoZW4NCidrZXhlY19pbl9wcm9n
cmVzcycgaXMgYSBtYWNybyBkZWZpbmVkIHRvIGZhbHNlLiAgVGhlIGNvbXBpbGVyIGNhbg0Kb3B0
aW1pemUgdGhpcyBvdXQgdG9vIEkgc3VwcG9zZS4NCg0KQW55IGNvbW1lbnRzPw0K

