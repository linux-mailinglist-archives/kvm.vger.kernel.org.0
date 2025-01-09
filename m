Return-Path: <kvm+bounces-34862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91100A06D09
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 05:30:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 367F27A39C1
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 04:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CECE166F1A;
	Thu,  9 Jan 2025 04:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AxPfX7wr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300A015A848
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 04:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736396983; cv=fail; b=C8r8PTyVxt45xi7Gvyu7MqYlszk0UdXRMZOgAI9QoK8MZEefLJbkMrueqY1lYi2MQmvLUZ66JRk+bHMF6kt8dBmPa3p4uMTHAcglRDGlBLxrUdlv6kCCDaUuSxs1Q/2o7Zl+oiN6J3KLDuNow5aj1yEIdLql9JYb25Sv/WJCmKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736396983; c=relaxed/simple;
	bh=UJT0ABKWrb059mzcTJ2yA6U7gsEp8gdCegcxczFkP+w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E245Z3S8E/RkK5iUe+tKcxKXEXMlCXom4pznf/q4voGP0WSfy8n/W1FstIOLAijTbpnS656S+S5v1JBTUSUt5M1Dzjq9VvBx0gctHGM+3OGjFiktQAm2LIXWzIhK1D36OrGKXHCJ5A1o9OmhdUN+NcJ0kobVORv4wIlMkBdN4zM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AxPfX7wr; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736396981; x=1767932981;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UJT0ABKWrb059mzcTJ2yA6U7gsEp8gdCegcxczFkP+w=;
  b=AxPfX7wrJxf6lHEa7vj19IF+GI2KX6NUY6U+UfUm4d+FAFrBaR/4QBU1
   iybR02jaJn5Du/DrqeT0CrTNeVgt4GQ+OUHrOqYeWnDv9ddVSr58RBVfk
   rmCTW5X2HUZaXkETPhbu06FcuA+x9R/oSrKeQ1mjDIE5LKtXWO61M9ZMf
   rurJhdrSGKXxPWMhpGOhaJdqn7zc93Kvs7a+b4Tx+SNo2lR8Jh4DSPsBH
   yNbfOAj2zESYc6qVu8k8Vfbe1bwiZFMmFziZB8Ik3/bMXrgdP/WRq0Nev
   +I1nn1TistAJqQ0WHSFH3PsdrPcd5aHYlfu8A8UDoOjgFNrGLnr1Hp3xS
   A==;
X-CSE-ConnectionGUID: qyvJ0D08TM+pFKcLRPd0Kw==
X-CSE-MsgGUID: ZI480U4ARdSa4KmPEGdbdg==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="47629486"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="47629486"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 20:29:40 -0800
X-CSE-ConnectionGUID: bvjRAad1RpmZrpPXkb9QPg==
X-CSE-MsgGUID: bOPleLbkRY6XRSVo73IffQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="107333372"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Jan 2025 20:29:38 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 8 Jan 2025 20:29:38 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 8 Jan 2025 20:29:38 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 8 Jan 2025 20:29:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HkS5eZTkzDVNUmDz9TiXX+PPc9CBmEaQ7uyTkIPjdCmvTC6Sx79A9klQ7POy3iBSnOcGNGM4kBoXnV+bNU8vsQGScMkfKtfJs8byWYM5kkwBpC1ElZO924qAW0wOMoWIerFXta5a/0+DiZgdxFpXnNoNURH5kMstN9cEcgY85J8rmmk1ilCja351Jwj/5lCtxBrk3Yb/eaIf3YCoRk3nlkjZOsmxfbwNj2Rn7dZCWxiw4yShsjGrGhLhPlPxLW85vCZ5HCnwNAKZdaN0/MnEnWrlqGXQQdvALdNG/M21dLA+q7pFpKOO7VlahVqJEpSemLNjbNjd1HM4BuzsHgD6wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LDf31OqXQKTUMLNAre4YwKPwxaa5x4KIOPhuAR8p+7k=;
 b=qP/XGIgFYs2MvjsOTuML2Ow/1RuDetZ1S0XYCpEAEuMm+3S9RKsRb5ksxzMItlg298f1rXsctjaSsTQ8ROaasuaI0BA2YPQ08FgZC5TNr56lr2+3YWyk0eCxBNN4MHAZbrsCE3yW610Tn80fbkjxufUrxq2SMIhNKmrv2UXjtuiSVYZg9OzH/mW0+IGVXmJr8ppm3E6GcMHSwDI3mD1EFAn+tXq4xT5hZoprXuDH5yAYURHOON+eLlh9fUvgXUEqqThLb0/cfiiNy1cRMOPm5omojO0PgFK1bCMhdF89pN9F4oazb+GNDPi3Qf4YhxB6RlBL7ojgxN6F91SzC3DpoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SA2PR11MB5050.namprd11.prod.outlook.com (2603:10b6:806:fb::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.10; Thu, 9 Jan 2025 04:29:20 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8314.018; Thu, 9 Jan 2025
 04:29:20 +0000
Message-ID: <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
Date: Thu, 9 Jan 2025 12:29:12 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
 <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
 <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0129.apcprd02.prod.outlook.com
 (2603:1096:4:188::19) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SA2PR11MB5050:EE_
X-MS-Office365-Filtering-Correlation-Id: f34ca631-5d4d-4a2b-2bcc-08dd30662fe8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?c1N4VUtYS3VVSk9YWG5ZSSt6djV3K00xUUJOcGdUMVJxUm9DckhRTkF0dzJD?=
 =?utf-8?B?RTQ1Witqa1FnMEsxdExrUVhhUHZwUXpzL2pQR2F4empxdWpkblRTQXVwWlFo?=
 =?utf-8?B?Zy9neVA5aHVMNVU4Y2srNTU0djNkaWs2Mlc5YzJRMUNFL0xXWURsdzVPamlX?=
 =?utf-8?B?MHl1RldrbWduTVpDWXFhVzFZdHVvMk52Z0dzeEQ2RjRmS0RHVUtSQldLekdL?=
 =?utf-8?B?MEJmeUhpcHFQaytncTdta2U5OGljL01Lek80YlJQKzZtODZ6TnVtMnB0SHJm?=
 =?utf-8?B?TS9aNWl4N0xGTnYyVzBhTld6d2w3MlpPemdnR05OcjZGR3pHZ2RUOWRUblVx?=
 =?utf-8?B?VE1nTnZRWkxmenBVWWNCQUtvWUg1bTN5b1h5Qjd3VlFXWk1sNFZ1WUZ5MjZa?=
 =?utf-8?B?azlvMnIwNjU1azI3TFZOSndrVDJTd2MvVngyMjlZNlpESFBOcjhMcElFME9J?=
 =?utf-8?B?aVNGNnM5TGZ0cmVtcGYzaVdzcXJvQUcya0sxYUN2cDMxSC9MeUcrQXg1RmIz?=
 =?utf-8?B?Ujl5SGc2Rm5tYU9pNVFVOFRrTXc3QXdJMEdIWnp0Q3JOMmhvN1RYSHI0TEli?=
 =?utf-8?B?UnUzVlJ4RzJzN2toMngrRi9YeFNZSGNUL28yRnRkWE5VaGlSNDRTcnFNcWhz?=
 =?utf-8?B?bm9Zb3laMnZrSi95VFMwRHlKRE1CNEx5Z1Q1K2N5Z3F0bG5VdXQ2VW1rL09s?=
 =?utf-8?B?bElSa3dVMy9wTDIwQUR1aTk4WTA5dUEvNDBtMVVxN2Q5K1RDSHY5MmxQaVM2?=
 =?utf-8?B?dUk1VXBEV09QelMycjNhaFFObno3a3R3TmZhWGQvTVkweHBGYm1ONHRxMitW?=
 =?utf-8?B?d1B2aTB6dUVRWlpJNVh5Q0ltU1FLQnRLaWNpdDNvbjlveFZZVGFnQktnUk9a?=
 =?utf-8?B?b1owbkJEWkd3QldyU0hJeTRHaWlTOGpkWEdmMUw5bWYySnRkblZia0tvVFcx?=
 =?utf-8?B?UHdLcy9sdG0zZHJDTWZjamY5cWh6aW5WRTlQQ0FsQkI2ckJxUDRFdmQ3MTkr?=
 =?utf-8?B?ZmxaOWVYcXRiL0E2ZjVvekllVVNtRkVCUk5raDY5eHpuaGtEaTNGV1dNNlFE?=
 =?utf-8?B?RVZOR1RuaXlkT3NQRWxZaThPOEpBWnJneGJ4UWdXZDR4K1B1UHlIdy9Pajdy?=
 =?utf-8?B?V1ArLzdPYTZYODMreUFrMUNVSEFFWlRkUGttSWVtSW9MYWdHbmt4QkMvbSt5?=
 =?utf-8?B?Zm0wYjNnMFdhcG96OWt5cmUvZFhialJOT1dPaWJKSXpjUUNudG1aTWRoSFNE?=
 =?utf-8?B?bnI4ek53UjlmVnhlZ3BvY2ZyeVlJdXBIMW93UE5HbGlvQmkrTVhtbC9qdUtm?=
 =?utf-8?B?dG5DODdMTWVNNTJUKzN1eFUremluYm52RUFjVno5UXFNSklRK3hpeHhZamtG?=
 =?utf-8?B?ano5UWlReHpNMVBHc0p4WkZMRDJwZnAwM3cxMGw0Q1RCS25vTEh3cHY1cG50?=
 =?utf-8?B?ZWM3aXJQWFhoVThOSXhpUUNOYWVMTVNHOHR4RVNsQm5PUHgwclhKNVRQeXcx?=
 =?utf-8?B?YVJmenA2ekRnZFhEU3I1WUQxNkRLWUIwYXlhTldJdnY4bHZuNWJ6UzFvUkRm?=
 =?utf-8?B?aUt1YmF1ajFvWUxjaWcyNW45T2s0cHZlZDIrUk5qdmpDbHVidG1RNDdKclV3?=
 =?utf-8?B?NjZWTkxyaG9EZWhvVmpFd1ZwUE1WV011bEp3ekQ5UjRrWDBIM1hZVWRpNzNv?=
 =?utf-8?B?L0VhdGdTd09IR2d6NVVtdDFEV2lBbENqT3lQRlJOQU9POHh3NTlKMXBERWxW?=
 =?utf-8?B?ckRmQS9FeUZHa1lETklCd0w4SkdBYXlBMWdvYTZvMXdrVHNNRHB2Z3FycWY3?=
 =?utf-8?B?bTV1RVdMbzg4QnFpRnU5NjgvWnNNWFZRcW9hVXU5NFJKUXNrbEFkeHBnWUFv?=
 =?utf-8?Q?KKWqiRuKnIzwK?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0x3amhPa2hMdjEvenhHY3c5SENiUnpsUi9kYU43eXZETkxyWlB3RHRCSDlR?=
 =?utf-8?B?ODA1bVllWkxJVU1RZnZKOVB1SGJoQmg3eHpBZTBTTXNHTlk2Wkg0NHh6M3Fm?=
 =?utf-8?B?R2pIQVFveWJZRExiaVpDOVFuL2Z4dTNTaTUxY1B0M2VDa2ZlcHh4c3E0Wm93?=
 =?utf-8?B?aVY2OGRYWU56SzMxdWt3MnlBVE9MV2lZcTc4Z1JxK0JnT0lHQVpKL1BLSUdj?=
 =?utf-8?B?L0I2SUJtUEUzN09wQmt3UFVZL1FYdk52b1MwM1lvUFNPNitOUTZtTEhzV2Ez?=
 =?utf-8?B?clhUN0VUWXpvTXJEQWdwcWZ2aW5hN2dWVDVCdGFuUU9vZllTWUNHSnhSdTZT?=
 =?utf-8?B?Skk1Ry9DN1VQL3NsYThHRkVUMVlQSTFQdUxYKzlFK3ByYmkxWUFzK2hBYU1B?=
 =?utf-8?B?TmJROHpabFVqRU5xM0EzYnJ2ZnNod0xvRFAyTzRGVzRTYXdIYTJ0WVhSRmpR?=
 =?utf-8?B?bW5xSVhuTFlhTlJySzdDVGp1dHkwVmxSNjB6MENPUEVvZFJQdkphMkxDMGZx?=
 =?utf-8?B?QlZTMnh2WjltcHJLWFpBWFFDS2RZeHd5WWEyNEk5azNLVWhGMjVuNzFDZkNk?=
 =?utf-8?B?V2ZCcXdBM3M0ckJxNkNxM0hzTUdtc1RjQzk2dnhaWlQ5ZlJ3cytYaDFMZTAv?=
 =?utf-8?B?RXBxeWQyRVNmUmoreHMxRGZNUjl6ekc5ME10dWZ1cStUbnRPTGR2R1BYakFT?=
 =?utf-8?B?eWdKZUFlc1I4aWFHRnBoMHRRaVZNdkZ1U2NQN0p0dU5hNmlZMTRCeDlQaWNQ?=
 =?utf-8?B?TG81Q1lhb0RUbnc2bldmTmdLR1JidjI0bVUxaXJBRVhQcEFEQVFKd1huZGxa?=
 =?utf-8?B?UjB4aklHR2tCZUF5QXoxRUo2eTlrMTVFeE1tR0NTcTJqKzZNTW5ZS25GQmhC?=
 =?utf-8?B?M2ZNYzNGWmltZzRBekNrTVpXaWkveCtTb0RiUE4xMzhkeXN1NjV5eEk1SW5i?=
 =?utf-8?B?UmhRRlFXUDJZMm9JcTJldlVEMjdEK2IvUDMyTWFwYU9xMjZRNVZTdHZPUSti?=
 =?utf-8?B?c2J5Yjd4UXk1TFJtdVgwOWRTOFF5L2dHVFNaWU8vKzhRNjkzdDg3OXhEdnRS?=
 =?utf-8?B?VGduYUZuOTFHejNrcE8vZjRMcHQ4cEYxT2I4aXViVXFmYks5SE96cWlIWjNI?=
 =?utf-8?B?K1EyNUliSE9qVTczTGlKeHQzNmxDajNpc3dpZ3hTTUE1emE4U0tmSmlXMkN5?=
 =?utf-8?B?dSsrbzlEdWNZTEtrMWl3YnU1cEUzM2JKeTJBYmNWVUx5N1kyQ25nRjlsY3Bi?=
 =?utf-8?B?dGtuemk3d0ZDQnhUb24rN2hiS2hMRHBhemwxbERZQWVVV0d5WHRLUkFlU0Q4?=
 =?utf-8?B?TURVSGVxLzdHRnViOWZKSkFZY1hGYlVxazAwWjNQVklKMlZBZ3B0aWZaYUU4?=
 =?utf-8?B?ejZyL0J5amhtQUo1QUIxamJHT3I0SitNRWdZNjcrMHdmUXVnU0NzREVhRHhL?=
 =?utf-8?B?YjVQRlBhVGlsZVcyVkxnVFkvSHFtTzlVekEvVXhJMWYycWZYT0lTVHRaM0sw?=
 =?utf-8?B?SW1wUVUyTWE3SEVVbXhpeFk0QmVJVHplRXpOT1Vnbk9iQ3FhWWFJYU5lVitB?=
 =?utf-8?B?NzMxVXdyanJkWXI2RnIrYVhGbURzdGdJc1BGV0Q3OU1XSHRKMm1nNUpPZndG?=
 =?utf-8?B?VlpPcXFkZVJxMUwzYXN6NThXelA1ZzNoYkZkYnc0ZElkbENRQ1ZsbExmUUg5?=
 =?utf-8?B?Y2F4NG5YMlkzOTZzTzBJTVV2YXl2empDRFh2Rkx4TWlpQ1R5bHNlQm1lY1RK?=
 =?utf-8?B?aHYzWEZldlkxakhLZEVrV0VtQ1IwdGRIc0lYZWpnYy9mbnQ4Q1RDS2lXUkZE?=
 =?utf-8?B?MDBsTDlyNkE5QjFhaEM0R21JdUIxV3JVemVwWU11cXpLaGtBdUtraytUWlBp?=
 =?utf-8?B?QmFIeFU2UUNPUFpuQWNHbU5GNHJDWkVGWDJZcGxjajF2SS9UTlhXejZ6N1Ro?=
 =?utf-8?B?c2NSUGdvZXVwSEcvcm5neFdFOWxSVVgwcEp0Y0ZEbWNadVFXcjIySzhhbjFv?=
 =?utf-8?B?NzF0K0NTejFuMnY1RWRqcDd2Tkl2am55cUJpU1E0dlNYK1NzcUEwV2NoZ2o3?=
 =?utf-8?B?ejBKQXlqSlByNTlOc2lqMDdqOGxtR3hkY3pyUjIvVnRRWEYvbGpXajdoRGZD?=
 =?utf-8?B?NzdRLzhBclZ1Y2dBczVyWDdxWlNxSWFmU25oSGFZRnlmaW5BSFdzdER2aDk3?=
 =?utf-8?B?N2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f34ca631-5d4d-4a2b-2bcc-08dd30662fe8
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 04:29:20.8115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ds5lC4h/5U0Q0Jg4eLDMWVf2wWGSxU0fZfe34OQQg4rqq2BNrAS5CP/UyM2yUMIVvv9B7rXILCcmcstrTQ3alA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5050
X-OriginatorOrg: intel.com



On 1/9/2025 10:55 AM, Alexey Kardashevskiy wrote:
> 
> 
> On 9/1/25 13:11, Chenyi Qiang wrote:
>>
>>
>> On 1/8/2025 7:20 PM, Alexey Kardashevskiy wrote:
>>>
>>>
>>> On 8/1/25 21:56, Chenyi Qiang wrote:
>>>>
>>>>
>>>> On 1/8/2025 12:48 PM, Alexey Kardashevskiy wrote:
>>>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>>>> uncoordinated discard") highlighted, some subsystems like VFIO might
>>>>>> disable ram block discard. However, guest_memfd relies on the discard
>>>>>> operation to perform page conversion between private and shared
>>>>>> memory.
>>>>>> This can lead to stale IOMMU mapping issue when assigning a hardware
>>>>>> device to a confidential VM via shared memory (unprotected memory
>>>>>> pages). Blocking shared page discard can solve this problem, but it
>>>>>> could cause guests to consume twice the memory with VFIO, which is
>>>>>> not
>>>>>> acceptable in some cases. An alternative solution is to convey other
>>>>>> systems like VFIO to refresh its outdated IOMMU mappings.
>>>>>>
>>>>>> RamDiscardManager is an existing concept (used by virtio-mem) to
>>>>>> adjust
>>>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>>>> conversion is similar to hot-removing a page in one mode and
>>>>>> adding it
>>>>>> back in the other, so the similar work that needs to happen in
>>>>>> response
>>>>>> to virtio-mem changes needs to happen for page conversion events.
>>>>>> Introduce the RamDiscardManager to guest_memfd to achieve it.
>>>>>>
>>>>>> However, guest_memfd is not an object so it cannot directly implement
>>>>>> the RamDiscardManager interface.
>>>>>>
>>>>>> One solution is to implement the interface in HostMemoryBackend. Any
>>>>>
>>>>> This sounds about right.
>>>>>
>>>>>> guest_memfd-backed host memory backend can register itself in the
>>>>>> target
>>>>>> MemoryRegion. However, this solution doesn't cover the scenario
>>>>>> where a
>>>>>> guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend,
>>>>>> e.g.
>>>>>> the virtual BIOS MemoryRegion.
>>>>>
>>>>> What is this virtual BIOS MemoryRegion exactly? What does it look like
>>>>> in "info mtree -f"? Do we really want this memory to be DMAable?
>>>>
>>>> virtual BIOS shows in a separate region:
>>>>
>>>>    Root memory region: system
>>>>     0000000000000000-000000007fffffff (prio 0, ram): pc.ram KVM
>>>>     ...
>>>>     00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM
>>>
>>> Looks like a normal MR which can be backed by guest_memfd.
>>
>> Yes, virtual BIOS memory region is initialized by
>> memory_region_init_ram_guest_memfd() which will be backed by a
>> guest_memfd.
>>
>> The tricky thing is, for Intel TDX (not sure about AMD SEV), the virtual
>> BIOS image will be loaded and then copied to private region.
>> After that,
>> the loaded image will be discarded and this region become useless.
> 
> I'd think it is loaded as "struct Rom" and then copied to the MR-
> ram_guest_memfd() which does not leave MR useless - we still see
> "pc.bios" in the list so it is not discarded. What piece of code are you
> referring to exactly?

Sorry for confusion, maybe it is different between TDX and SEV-SNP for
the vBIOS handling.

In x86_bios_rom_init(), it initializes a guest_memfd-backed MR and loads
the vBIOS image to the shared part of the guest_memfd MR. For TDX, it
will copy the image to private region (not the vBIOS guest_memfd MR
private part) and discard the shared part. So, although the memory
region still exists, it seems useless.

It is different for SEV-SNP, correct? Does SEV-SNP manage the vBIOS in
vBIOS guest_memfd private memory?

> 
> 
>> So I
>> feel like this virtual BIOS should not be backed by guest_memfd?
> 
> From the above it sounds like the opposite, i.e. it should :)
> 
>>>
>>>>     0000000100000000-000000017fffffff (prio 0, ram): pc.ram
>>>> @0000000080000000 KVM
>>>
>>> Anyway if there is no guest_memfd backing it and
>>> memory_region_has_ram_discard_manager() returns false, then the MR is
>>> just going to be mapped for VFIO as usual which seems... alright, right?
>>
>> Correct. As the vBIOS is backed by guest_memfd and we implement the RDM
>> for guest_memfd_manager, the vBIOS MR won't be mapped by VFIO.
>>
>> If we go with the HostMemoryBackend instead of guest_memfd_manager, this
>> MR would be mapped by VFIO. Maybe need to avoid such vBIOS mapping, or
>> just ignore it since the MR is useless (but looks not so good).
> 
> Sorry I am missing necessary details here, let's figure out the above.
> 
>>
>>>
>>>
>>>> We also consider to implement the interface in HostMemoryBackend, but
>>>> maybe implement with guest_memfd region is more general. We don't know
>>>> if any DMAable memory would belong to HostMemoryBackend although at
>>>> present it is.
>>>>
>>>> If it is more appropriate to implement it with HostMemoryBackend, I can
>>>> change to this way.
>>>
>>> Seems cleaner imho.
>>
>> I can go this way.

[...]

>>>>>> +
>>>>>> +static int guest_memfd_rdm_replay_populated(const RamDiscardManager
>>>>>> *rdm,
>>>>>> +                                            MemoryRegionSection
>>>>>> *section,
>>>>>> +                                            ReplayRamPopulate
>>>>>> replay_fn,
>>>>>> +                                            void *opaque)
>>>>>> +{
>>>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>>>> +    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque =
>>>>>> opaque };
>>>>>> +
>>>>>> +    g_assert(section->mr == gmm->mr);
>>>>>> +    return guest_memfd_for_each_populated_section(gmm, section,
>>>>>> &data,
>>>>>> +
>>>>>> guest_memfd_rdm_replay_populated_cb);
>>>>>> +}
>>>>>> +
>>>>>> +static int guest_memfd_rdm_replay_discarded_cb(MemoryRegionSection
>>>>>> *section, void *arg)
>>>>>> +{
>>>>>> +    struct GuestMemfdReplayData *data = arg;
>>>>>> +    ReplayRamDiscard replay_fn = data->fn;
>>>>>> +
>>>>>> +    replay_fn(section, data->opaque);
>>>>>
>>>>>
>>>>> guest_memfd_rdm_replay_populated_cb() checks for errors though.
>>>>
>>>> It follows current definiton of ReplayRamDiscard() and
>>>> ReplayRamPopulate() where replay_discard() doesn't return errors and
>>>> replay_populate() returns errors.
>>>
>>> A trace would be appropriate imho. Thanks,
>>
>> Sorry, can't catch you. What kind of info to be traced? The errors
>> returned by replay_populate()?
> 
> Yeah. imho these are useful as we expect this part to work in general
> too, right? Thanks,

Something like?

diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
index 6b3e1ee9d6..4440ac9e59 100644
--- a/system/guest-memfd-manager.c
+++ b/system/guest-memfd-manager.c
@@ -185,8 +185,14 @@ static int
guest_memfd_rdm_replay_populated_cb(MemoryRegionSection *section, voi
 {
     struct GuestMemfdReplayData *data = arg;
     ReplayRamPopulate replay_fn = data->fn;
+    int ret;

-    return replay_fn(section, data->opaque);
+    ret = replay_fn(section, data->opaque);
+    if (ret) {
+        trace_guest_memfd_rdm_replay_populated_cb(ret);
+    }
+
+    return ret;
 }

How about just adding some error output in
guest_memfd_for_each_populated_section()/guest_memfd_for_each_discarded_section()
if the cb() (i.e. replay_populate()) returns error?

> 
>>
>>>
>>>>>
>>>>>> +
>>>>>> +    return 0;
>>>>>> +}
>>>>>> +
>>>>>> +static void guest_memfd_rdm_replay_discarded(const RamDiscardManager
>>>>>> *rdm,
>>>>>> +                                             MemoryRegionSection
>>>>>> *section,
>>>>>> +                                             ReplayRamDiscard
>>>>>> replay_fn,
>>>>>> +                                             void *opaque)
>>>>>> +{
>>>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>>>> +    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque =
>>>>>> opaque };
>>>>>> +
>>>>>> +    g_assert(section->mr == gmm->mr);
>>>>>> +    guest_memfd_for_each_discarded_section(gmm, section, &data,
>>>>>> +
>>>>>> guest_memfd_rdm_replay_discarded_cb);
>>>>>> +}
>>>>>> +
>>>>>> +static void guest_memfd_manager_init(Object *obj)
>>>>>> +{
>>>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
>>>>>> +
>>>>>> +    QLIST_INIT(&gmm->rdl_list);
>>>>>> +}
>>>>>> +
>>>>>> +static void guest_memfd_manager_finalize(Object *obj)
>>>>>> +{
>>>>>> +    g_free(GUEST_MEMFD_MANAGER(obj)->bitmap);
>>>>>
>>>>>
>>>>> bitmap is not allocated though. And 5/7 removes this anyway. Thanks,
>>>>
>>>> Will remove it. Thanks.
>>>>
>>>>>
>>>>>
>>>>>> +}
>>>>>> +
>>>>>> +static void guest_memfd_manager_class_init(ObjectClass *oc, void
>>>>>> *data)
>>>>>> +{
>>>>>> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>>>>>> +
>>>>>> +    rdmc->get_min_granularity = guest_memfd_rdm_get_min_granularity;
>>>>>> +    rdmc->register_listener = guest_memfd_rdm_register_listener;
>>>>>> +    rdmc->unregister_listener = guest_memfd_rdm_unregister_listener;
>>>>>> +    rdmc->is_populated = guest_memfd_rdm_is_populated;
>>>>>> +    rdmc->replay_populated = guest_memfd_rdm_replay_populated;
>>>>>> +    rdmc->replay_discarded = guest_memfd_rdm_replay_discarded;
>>>>>> +}
>>>>>> diff --git a/system/meson.build b/system/meson.build
>>>>>> index 4952f4b2c7..ed4e1137bd 100644
>>>>>> --- a/system/meson.build
>>>>>> +++ b/system/meson.build
>>>>>> @@ -15,6 +15,7 @@ system_ss.add(files(
>>>>>>       'dirtylimit.c',
>>>>>>       'dma-helpers.c',
>>>>>>       'globals.c',
>>>>>> +  'guest-memfd-manager.c',
>>>>>>       'memory_mapping.c',
>>>>>>       'qdev-monitor.c',
>>>>>>       'qtest.c',
>>>>>
>>>>
>>>
>>
> 


