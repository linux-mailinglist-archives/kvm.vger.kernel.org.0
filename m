Return-Path: <kvm+bounces-55492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D4D4B3116F
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 10:17:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E4F43B11B3
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 08:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C402EAB94;
	Fri, 22 Aug 2025 08:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dZUPzv0n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300572E7BDF;
	Fri, 22 Aug 2025 08:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755850368; cv=fail; b=UGRVaNAPB/CamtCSC89yRdNehCKJMrwFOTnNl+mGR3PYInvapohOB8KG0S5+TUmN5MBNVSFO8RFW7S+UZEv6mkwAQYXjCCPOjZUgRA3ttwxmCXVUAPTloHtYc2cnf6kwx+GWE+1jetol6ydpa6aaBLbxHcbmDy9R2MiZMGMMWe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755850368; c=relaxed/simple;
	bh=nPklTviUAYX+BzG+LZTtERorehkp25bnRp+YE8Z1E+I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sX5p4tVnjvxKvxguiSaEY0O84bvpMQaYmvcEh7OonxD3AMBA9oabITeYwp+yLhE/LjOJnboaIIeKkJq4NyuXEJAmW4tltG/21QNQPgdF9IqauDVhSP6fLfhi8jjDLmQ7zLRKFK0tJIFyx5c6naHFpRqTio8YHHkgck6ONSVk0Fk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dZUPzv0n; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755850366; x=1787386366;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nPklTviUAYX+BzG+LZTtERorehkp25bnRp+YE8Z1E+I=;
  b=dZUPzv0nXit2kkh7bErb2Duoeqftg5O+lXKmLDiGPgWvQ3yUbOikcFsC
   ps7WRHCG85Mvkd260gFb1UsaFn+1Le4RcZ1NYoCprKZ/XkTzK9gh16GcJ
   3TTsaFalpOHKPJtOYsQPHA9oLrWkJMmUgJMxywg8jCHHejX7T7GXXMyS6
   wpn0NXRRQnXwvAsgFgSxROBzG0kmkzXCthZv0ulMbUmUR48/aEdHFetkI
   aycGJvaqlXqu7sGn+wwTZLQTWEufIDWppR9RL5o74zhNXf6NemIdUZY4M
   xhQQGgyvFGT2TdjxaXhAhdYfKm3q/W/NuC9C0keNrkKc5NwefXAvrBI26
   w==;
X-CSE-ConnectionGUID: df8+4p5UTgSGg7Vuz0mSvA==
X-CSE-MsgGUID: k5relYOKTlamGBKyqyLmhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="58079166"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="58079166"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 01:12:45 -0700
X-CSE-ConnectionGUID: PWmxt0mjQE2KwWMrCGGV4A==
X-CSE-MsgGUID: KVrhCH15ThSzt0DmHedKGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="173970423"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 01:12:44 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 01:12:43 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 22 Aug 2025 01:12:43 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.67)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 01:12:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RhfTswLqI9Oe8gHXJWl7mHcGEYVGMQ/61Tvyil1Yp7mqeGClvQRRc/Pi2umE3QTSaKecEv2rtwBFit104ebJbvkESPcoR5nENm5ucNem9i2ZLEHxH3tR/Zh7iUbTIs1T34DHarjHIGEv9E8VrQl8WdTt9RcuYbsu26WznXW+nQ/wI7yczIQtZfLvmQvsylTDzWg7SqjSAAOwDsOvVepF3Pdzydemi4eCjwEynPesLcFU2q4M5AtVyPlNxa1dhi1abqaf0D9W+YTS02YjF/AqF6wJH4Adv7MJ8ciyIzTIEqVkVRRnXjVjmupQ63D85bMFItWj7KRy9zalczdXWC5LuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ygl8mifUqK7aBmlEYHRDjsf925p9qoDvosC4ucBb66s=;
 b=WgWZu5zHqAsDRF8l4/+JqT+x3b0xY/TuzDzRnw5Bezjog/4U/z77FNqCZqXmB7M2/FtRXoKlBZz+KKt4e+KKvFHfCrErLAs/FYlN7PzL3d/IOG2sJdbk2R4QPZQALBPqVns21rF6Ce2ZBhtdnMvgpJMNb6ASH3Eq37VE/XIEBVWxgS50xbM8GjmHYT47Fg+v/YI0+b3xMUiETAKtfg3YDzBPSHRQ2bzj8q18IpNkyEq8yn700TGFzL05Mg3sPCTVOtslZ7IKQ79gq24a4H2fAeZqB5xbN/VRcxdfqVVbG0vGVUOng3G89jN3CP8vx29lDrSQ46tcl4X+zbAEpqxSwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH0PR11MB5265.namprd11.prod.outlook.com (2603:10b6:610:e0::19)
 by SJ0PR11MB5917.namprd11.prod.outlook.com (2603:10b6:a03:42b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Fri, 22 Aug
 2025 08:12:34 +0000
Received: from CH0PR11MB5265.namprd11.prod.outlook.com
 ([fe80::62f5:6609:fce5:d57d]) by CH0PR11MB5265.namprd11.prod.outlook.com
 ([fe80::62f5:6609:fce5:d57d%4]) with mapi id 15.20.9031.023; Fri, 22 Aug 2025
 08:12:34 +0000
Message-ID: <0849841e-74cf-4548-8943-b11388782103@intel.com>
Date: Fri, 22 Aug 2025 16:12:19 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/44] KVM: x86: Add support for mediated vPMUs
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
	<zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, Huacai Chen
	<chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, Paul Walmsley
	<paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, "Arnaldo Carvalho de
 Melo" <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>, Kan Liang
	<kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang
	<mizhang@google.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20250806195706.1650976-1-seanjc@google.com>
Content-Language: en-US
From: "Hao, Xudong" <xudong.hao@intel.com>
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0127.apcprd03.prod.outlook.com
 (2603:1096:4:91::31) To CH0PR11MB5265.namprd11.prod.outlook.com
 (2603:10b6:610:e0::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5265:EE_|SJ0PR11MB5917:EE_
X-MS-Office365-Filtering-Correlation-Id: 6111e1ba-4eb3-4f99-7ed4-08dde153a605
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NzRDSW5pTkl5eTJ0SERPdEQ2cFZPcGNtWjUvZmpKdnpHemNiSzJ1bnVBbEdN?=
 =?utf-8?B?c3BwSFZiclBUV3daU09WZ3cvTjFSeGRxS0ZlNG9Fb3pVdkQwdDZvcVk0S1hq?=
 =?utf-8?B?WmdZUGRKRk5XV2hUVkUwWEhweEpVVGttS0d6TzRta04ySzNlVm5kV1hPTU9C?=
 =?utf-8?B?YnUvMWlMb0FUSW16RWk3QXZVNkRXKzRjaHBYK3RJWU92ZFNxbTVFUXhwUmRD?=
 =?utf-8?B?c0dlNEdwMitMNjMrU3JWTGNWWDVPQ1V6d2hCOWNQdHdpblNZNFJuQktMYzc4?=
 =?utf-8?B?MWdpYTZLZVhMZ3lHRmk3MCs0VWR1bUkrT1AzUFlSQjJpajVaSTJDOFFLNFMw?=
 =?utf-8?B?RmhSMHZxdXVneUZDejVRaFFySitHZDBBL1pqdGZva3JIZTRGQ3hzVnc1QmRE?=
 =?utf-8?B?ck5pbzkvdTF2QTdGVEJCT0RhVVp3QjJBUWVVb1h4VFUzZlNFd3B5UWdxNk9F?=
 =?utf-8?B?aXRSdEw0VEt6ZlU1Rks1M2tyZ0cxRTlsdWNZTHBxWHNrYXNybWVURXdncmRG?=
 =?utf-8?B?THdrTFpxS3BtVlhlQ0RYZkwvSTQvbzhaM2owMFBIdEtham9WZ2lwMEhpSWNX?=
 =?utf-8?B?enI3clJQazlkTWRwSEI4c08vcko2NGNwWnJDR0ppQXpld2l0WjcrZUVRTXNK?=
 =?utf-8?B?ZldROVhtZ1ppU2xSaVZna0ttOUExdklYV3dObXlVT0t1WEhrSEt4N2pHOGpQ?=
 =?utf-8?B?Zk4zaG9EbW9mOU5HcHhPZWtGSzNXNjk0UDdTaHR4NkdUdDgwWnpzZjhEVmVr?=
 =?utf-8?B?M1RoTWRmTm5tbjhBUHNNNkZwZzUyUFBxaVczS1c3TXM2c2FUTk9va28vZ2x1?=
 =?utf-8?B?Y3d4Z0dOZ055M0VuWXltRzNZRGRHQlRMZWFkUlhUajZ6UkhxRy9hT25uZjZC?=
 =?utf-8?B?M1dWdmREL3JxNXNFYmg1aGVxT0Z1TlJoRTNUeUtINUptVGxRWnFDUFVMdmh2?=
 =?utf-8?B?ODJ3M1A3WTkyLzJpOXVNUUM1QThpd0dKRTgyREJENUVMQ1dtVVl4dUJDTjVB?=
 =?utf-8?B?YjhpYkw5ekt2Rm16QlFjM2VKTElranRRVFFOM3FxMWtvbzdvNmRXendZeURz?=
 =?utf-8?B?aE9xZy9YUFA4MkFLaVlabGw0SWVvckJMdkxzQzZscE0rOXBzQzlVdnhlaXVk?=
 =?utf-8?B?MVl0NGRYTldNcUZ3NS96bkxyUzVIY253S0VtZ2tmSHQ1UTRrbTZkVEVPVXV4?=
 =?utf-8?B?c0grYit0alNTTm90T0VGeWx4bTI4RWRCUTNrZ0ZyQnVBUy83WjFIdU91R0k4?=
 =?utf-8?B?WEFzWDJLZTZrQ2h2ajlJME5sdmtCTUludmZCckM3T24xMEphSmFhRStGejdD?=
 =?utf-8?B?SGYzc21oOGtnSUtzWXBhZ24vYmpranNSU05vWUJTSmVROEZhL21xUUxLOEZn?=
 =?utf-8?B?VEhRbHRwTVBaa0JKZGVEeFhpZUV6RVFSNlZ4eWhnaEN4YmcxM3VPMHovTUdP?=
 =?utf-8?B?RHFNVjdYaElnSjBObTBjcWlERGVNVHRMUTdMTDB0Qmw5eHJDQjJqdllMbWRN?=
 =?utf-8?B?YXJUU01Sc3BiSy9MdnAzQ0JLRGIxd3JSc3EvekJQVkNFeDhuZ2t5c2VWQXRS?=
 =?utf-8?B?OWRYVmp6VnpnbUh3QVJwbDcxM2hVSmtnTFdyVTdQZWNyMk9BdDlEbkpueGtH?=
 =?utf-8?B?czMrejZrdmZDZzlkWUJNRkZXZTE5WVVoYmNhOUZlRDZEVmEydGtzY21Dc2Z6?=
 =?utf-8?B?UEQ1ZnFrSjNWai94ZTB5dzZVWWRBQnhnQUlFcGt5ZVVsUGhQbTBsODFmK0RM?=
 =?utf-8?B?WHl3c3NURGladHAySTFveXNsZEFPS2xQYUM3TlRMVEpGZllBVjFJS3lHUjlz?=
 =?utf-8?B?Wk9Ra1d2M1Q0WXE2THhoRlVIQk5KZllBRTVMSDI5UGc0UU5wMEZNNWI1VmZZ?=
 =?utf-8?B?SlEwNmI1LzZNY0JwNFlwTURQS2RZVDhFZDVDRFRUbTI4ZFFaWG8vK3BCUVdC?=
 =?utf-8?B?N1JLdno1TExNRGovMzA3K1VOcEhzZTlEaGRZQ2J0RU1XbmFNdUE0ZW55VzBG?=
 =?utf-8?B?MCtwWGNqcEJnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5265.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVN5S0o3Z1ZQWjlqYkd1NHdHSU4zVmI5dHV3NktPQlUwL2NCQk9oYldRWFd2?=
 =?utf-8?B?RDA5Q0VDR0ZoWHRwS2tJVFNvN3pBT0FZNnlxclVwUzVvdXJLSDgvQVI5eHNh?=
 =?utf-8?B?TUNHUXI0c0p4QWJXalZyVllza1lHYzQ2Ui9FRG1YVEo4RUVuUm9NdnNSbzgz?=
 =?utf-8?B?RXM1enlHU3VFbldkU21hd2dlRGE2SWJQRzdtZXpCa0c2Q0tMWkFjMk94TS9p?=
 =?utf-8?B?M2xIdVdlWHNnbnZ6VGljL1RHOW51MFRheG5SQXVWOHJzQ2pmVHFBMklUMWZS?=
 =?utf-8?B?aWZZb3lscXBCMTNERWFuSFRRZWJ0ekRzdExLdWRkYlFVV095YjJFZjJPemE5?=
 =?utf-8?B?YThCeWk0Z2hrWHh2RVVId0FMeC9KNnYzcy8xU3lPMTRtZ0xPb1M5dGd1Z1JC?=
 =?utf-8?B?a0pZc1QxSmxGNldyOEpFQXlPRTBqN3pPb1k4ZlNmR1hwK0hlM1p6MnVGWXNK?=
 =?utf-8?B?UC9WTFR2anNaN1VIbjVQeDBJL3ZBWS91STdqWUhyeEFWUGpvNmhKSUgzZkl1?=
 =?utf-8?B?YW1MNlBJa1pGbHZpNzExendiNUw0dEM0aFlMdUI0OURVU1d2YXFKQU1xOGlM?=
 =?utf-8?B?eWpDSGFpM1QzbU9BQUtoZ2luNnVydkFISDBkOWVOUUloakNkUHNFamQxUGVH?=
 =?utf-8?B?M2JYN3VhU0M2R3l1aDkrNnZWWUk1Y1IwcE1OWm03K0d1WWg2djVDUXVjbnNY?=
 =?utf-8?B?TVdIODArdlo0cndzeXc1TXVrVTVqSEd0bUs0Uy9BQmh2Q3o0VElNVVhZbkRU?=
 =?utf-8?B?QlFsajJGN1g1dlFRQ09HaytRVzU3RXYyTm9YYkJlREkvc3F4Slg1YjQ3TzFY?=
 =?utf-8?B?R2xGdmdRTmVtZkl1ZklGUUZQdEpIL09MRjBKNkwyaFpVaWF3L00vaXhpcVN5?=
 =?utf-8?B?QlNWYytFdE8zay81RUt1WlhET21wYnd1OWZIYVIzbnZvejVOdG14VThSUG4w?=
 =?utf-8?B?d2NVSnVOSFpHeCtEYnQyQVlkcFNqczRWQzhWK0pXZW5MUnp1VHlyeVRQY1Zy?=
 =?utf-8?B?YUNsTlpXaW5tTmgweG9mejAzclIyKy9pQUxGZzdnMkthZ3NpWWVEcXJzQkpn?=
 =?utf-8?B?VXorckgwT1pvQ2tVZEYrdmlGR2xDUFZHd0k5TGZqTzZ2Rmhlc0JKV01vWm1n?=
 =?utf-8?B?a2FXUk5KUFVUTkZWS2lCUXFLS09FZzhYOTlLVnU4LysyWVZ5MmVCclFMUDJY?=
 =?utf-8?B?RWhMeVFNekFQQURLajFWcVFoWXEyK3FjYlJwV2NGK2wrZzRDUGxlRFBGNklH?=
 =?utf-8?B?M1dHNndzZ0YwSUo1QlI2MEpqVkNoTEdKM29YajBEQmpiYmNFeEhESzM0WjY4?=
 =?utf-8?B?Y2Vza0hPeHdyTW1Zc3oydW93YzdGYzBrd1ZRV0gvdFZ4YVBFM2xVem94NnhJ?=
 =?utf-8?B?WExzd1BCZlV3Zk16Yi9GcktvVlVnekJJNFcwQ0cwZjFWaWFRT1pVbFJpZ3hS?=
 =?utf-8?B?dmtCY3R4aUdoUkZ6NHhsQnpxNVJHSXRPcW04dHFESVVuMllvNE1rRmtZZk1V?=
 =?utf-8?B?RWpYWlFQRkt0aEpVenN1MnkyY2dzSkVHTTErZWpuOCs4T2g2OUkzWDlwMGRG?=
 =?utf-8?B?Z3FIcVFyaEVQUmpBQkFMTlNQSzVMOEFOa3FGMldHcjlFdkh5a1orU1RjUmdx?=
 =?utf-8?B?bVR0WVZva3YyZlhpZ0E4WS9MSXd2c1hsenFPYVRCU3NmV0RJbVBWaGE4SWVm?=
 =?utf-8?B?TlFzczVCOXlIQjBlazVmanlOV2xIdXE0bS9tbEQwV21Yc2ZhcjB1aHhIRHVK?=
 =?utf-8?B?WnBBcVdQMW9ML05aWVh1b0NZMW9YL1hEaFVxaDZZL0hjTjNxNjNmNjFkQ0cr?=
 =?utf-8?B?S05uRFFEUXV5RHVzVUhZQytScHpIS015c3RwWTBTT014WGt6S0ZOQ2dEdXNG?=
 =?utf-8?B?dmhsUHlCNkhDVzk5ZXBmNndhdWxMNU11V0phY1lDWkJPMmY1d3pNNm1VYWgz?=
 =?utf-8?B?dVdCM3hBQXBVWEUvL0Z6aHJiZ1lmZmJEOEE4TXYxeC9ROEZMbUhIeTM1Umdy?=
 =?utf-8?B?U2NsWjJITEFHSzBBUW4yQ1JXSjR0M3JlL1dMTUQzbXFSQlZCMmlOUkQyaGR2?=
 =?utf-8?B?dEs3bWlsSjZZUUlTdjhBcDNzdkltNWZVSzVYcEo5VXUreGpSNEJYVDEwdlFk?=
 =?utf-8?Q?Wr/qebhzCBRreonUCfp9T361D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6111e1ba-4eb3-4f99-7ed4-08dde153a605
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5265.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 08:12:34.5997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iD+VYQptlzSaCdWNQ94qb69pakN/QC9NCIM9sds8J38KbGWm79Qo6H14Rc3STFIGS/EVBnBJqUhd1M/GDWHzUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5917
X-OriginatorOrg: intel.com



On 8/7/2025 3:56 AM, Sean Christopherson wrote:
> This series is based on the fastpath+PMU cleanups series[*] (which is based on
> kvm/queue), but the non-KVM changes apply cleanly on v6.16 or Linus' tree.
> I.e. if you only care about the perf changes, I would just apply on whatever
> branch is convenient and stop when you hit the KVM changes.
> 
> My hope/plan is that the perf changes will go through the tip tree with a
> stable tag/branch, and the KVM changes will go the kvm-x86 tree.
> 
> Non-x86 KVM folks, y'all are getting Cc'd due to minor changes in "KVM: Add a
> simplified wrapper for registering perf callbacks".
> 
> The full set is also available at:
> 
>    https://github.com/sean-jc/linux.git tags/mediated-vpmu-v5
> 
> Add support for mediated vPMUs in KVM x86, where "mediated" aligns with the
> standard definition of intercepting control operations (e.g. event selectors),
> while allowing the guest to perform data operations (e.g. read PMCs, toggle
> counters on/off) without KVM getting involed.
> 
> For an in-depth description of the what and why, please see the cover letter
> from the original RFC:
> 
>    https://lore.kernel.org/all/20240126085444.324918-1-xiong.y.zhang@linux.intel.com
> 
> All KVM tests pass (or fail the same before and after), and I've manually
> verified MSR/PMC are passed through as expected, but I haven't done much at all
> to actually utilize the PMU in a guest.  I'll be amazed if I didn't make at
> least one major goof.
> 
> Similarly, I tried to address all feedback, but there are many, many changes
> relative to v4.  If I missed something, I apologize in advance.
> 
> In other words, please thoroughly review and test.
> 
> [*] https://lore.kernel.org/all/20250805190526.1453366-1-seanjc@google.com
> 
> v5:
>   - Add a patch to call security_perf_event_free() from __free_event()
>     instead of _free_event() (necessitated by the __cleanup() changes).
>   - Add CONFIG_PERF_GUEST_MEDIATED_PMU to guard the new perf functionality.
>   - Ensure the PMU is fully disabled in perf_{load,put}_guest_context() when
>     when switching between guest and host context. [Kan, Namhyung]
>   - Route the new system IRQ, PERF_GUEST_MEDIATED_PMI_VECTOR, through perf,
>     not KVM, and play nice with FRED.
>   - Rename and combine perf_{guest,host}_{enter,exit}() to a single set of
>     APIs, perf_{load,put}_guest_context().
>   - Rename perf_{get,put}_mediated_pmu() to perf_{create,release}_mediated_pmu()
>     to (hopefully) better differentiate them from perf_{load,put}_guest_context().
>   - Change the param to the load/put APIs from "u32 guest_lvtpc" to
>     "unsigned long data" to decouple arch code as much as possible.  E.g. if
>     a non-x86 arch were to ever support a mediated vPMU, @data could be used
>     to pass a pointer to a struct.
>   - Use pmu->version to detect if a vCPU has a mediated PMU.
>   - Use a kvm_x86_ops hook to check for mediated PMU support.
>   - Cull "passthrough" from as many places as I could find.
>   - Improve the changelog/documentation related to RDPMC interception.
>   - Check harware capabilities, not KVM capabilities, when calculating
>     MSR and RDPMC intercepts.
>   - Rework intercept (re)calculation to use a request and the existing (well,
>     will be existing as of 6.17-rc1) vendor hooks for recalculating intercepts.
>   - Always read PERF_GLOBAL_CTRL on VM-Exit if writes weren't intercepted while
>     running the vCPU.
>   - Call setup_vmcs_config() before kvm_x86_vendor_init() so that the golden
>     VMCS configuration is known before kvm_init_pmu_capability() is called.
>   - Keep as much refresh/init code in common x86 as possible.
>   - Context switch PMCs and event selectors in common x86, not vendor code.
>   - Bail from the VM-Exit fastpath if the guest is counting instructions
>     retired and the mediated PMU is enabled (because guest state hasn't yet
>     been synchronized with hardware).
>   - Don't require an userspace to opt-in via KVM_CAP_PMU_CAPABILITY, and instead
>     automatically "create" a mediated PMU on the first KVM_CREATE_VCPU call if
>     the VM has an in-kernel local APIC.
>   - Add entries in kernel-parameters.txt for the PMU params.
>   - Add a patch to elide PMC writes when possible.
>   - Many more fixups and tweaks...
> 
> v4:
>   - https://lore.kernel.org/all/20250324173121.1275209-1-mizhang@google.com
>   - Rebase whole patchset on 6.14-rc3 base.
>   - Address Peter's comments on Perf part.
>   - Address Sean's comments on KVM part.
>     * Change key word "passthrough" to "mediated" in all patches
>     * Change static enabling to user space dynamic enabling via KVM_CAP_PMU_CAPABILITY.
>     * Only support GLOBAL_CTRL save/restore with VMCS exec_ctrl, drop the MSR
>       save/retore list support for GLOBAL_CTRL, thus the support of mediated
>       vPMU is constrained to SapphireRapids and later CPUs on Intel side.
>     * Merge some small changes into a single patch.
>   - Address Sandipan's comment on invalid pmu pointer.
>   - Add back "eventsel_hw" and "fixed_ctr_ctrl_hw" to avoid to directly
>     manipulate pmc->eventsel and pmu->fixed_ctr_ctrl.
> 
> v3: https://lore.kernel.org/all/20240801045907.4010984-1-mizhang@google.com
> v2: https://lore.kernel.org/all/20240506053020.3911940-1-mizhang@google.com
> v1: https://lore.kernel.org/all/20240126085444.324918-1-xiong.y.zhang@linux.intel.com
> 
> Dapeng Mi (15):
>    KVM: x86/pmu: Start stubbing in mediated PMU support
>    KVM: x86/pmu: Implement Intel mediated PMU requirements and
>      constraints
>    KVM: x86: Rename vmx_vmentry/vmexit_ctrl() helpers
>    KVM: x86/pmu: Move PMU_CAP_{FW_WRITES,LBR_FMT} into msr-index.h header
>    KVM: VMX: Add helpers to toggle/change a bit in VMCS execution
>      controls
>    KVM: x86/pmu: Disable RDPMC interception for compatible mediated vPMU
>    KVM: x86/pmu: Load/save GLOBAL_CTRL via entry/exit fields for mediated
>      PMU
>    KVM: x86/pmu: Use BIT_ULL() instead of open coded equivalents
>    KVM: x86/pmu: Disable interception of select PMU MSRs for mediated
>      vPMUs
>    KVM: x86/pmu: Bypass perf checks when emulating mediated PMU counter
>      accesses
>    KVM: x86/pmu: Reprogram mediated PMU event selectors on event filter
>      updates
>    KVM: x86/pmu: Load/put mediated PMU context when entering/exiting
>      guest
>    KVM: x86/pmu: Handle emulated instruction for mediated vPMU
>    KVM: nVMX: Add macros to simplify nested MSR interception setting
>    KVM: x86/pmu: Expose enable_mediated_pmu parameter to user space
> 
> Kan Liang (7):
>    perf: Skip pmu_ctx based on event_type
>    perf: Add generic exclude_guest support
>    perf: Add APIs to create/release mediated guest vPMUs
>    perf: Clean up perf ctx time
>    perf: Add a EVENT_GUEST flag
>    perf: Add APIs to load/put guest mediated PMU context
>    perf/x86/intel: Support PERF_PMU_CAP_MEDIATED_VPMU
> 
> Mingwei Zhang (3):
>    perf/x86/core: Plumb mediated PMU capability from x86_pmu to
>      x86_pmu_cap
>    KVM: x86/pmu: Introduce eventsel_hw to prepare for pmu event filtering
>    KVM: nVMX: Disable PMU MSR interception as appropriate while running
>      L2
> 
> Sandipan Das (3):
>    perf/x86/core: Do not set bit width for unavailable counters
>    perf/x86/amd: Support PERF_PMU_CAP_MEDIATED_VPMU for AMD host
>    KVM: x86/pmu: Always stuff GuestOnly=1,HostOnly=0 for mediated PMCs on
>      AMD
> 
> Sean Christopherson (15):
>    perf: Move security_perf_event_free() call to __free_event()
>    perf: core/x86: Register a new vector for handling mediated guest PMIs
>    perf/x86: Switch LVTPC to/from mediated PMI vector on guest load/put
>      context
>    KVM: VMX: Setup canonical VMCS config prior to kvm_x86_vendor_init()
>    KVM: SVM: Check pmu->version, not enable_pmu, when getting PMC MSRs
>    KVM: Add a simplified wrapper for registering perf callbacks
>    KVM: x86/pmu: Snapshot host (i.e. perf's) reported PMU capabilities
>    KVM: x86/pmu: Implement AMD mediated PMU requirements
>    KVM: x86: Rework KVM_REQ_MSR_FILTER_CHANGED into a generic
>      RECALC_INTERCEPTS
>    KVM: x86: Use KVM_REQ_RECALC_INTERCEPTS to react to CPUID updates
>    KVM: x86/pmu: Move initialization of valid PMCs bitmask to common x86
>    KVM: x86/pmu: Restrict GLOBAL_{CTRL,STATUS}, fixed PMCs, and PEBS to
>      PMU v2+
>    KVM: x86/pmu: Disallow emulation in the fastpath if mediated PMCs are
>      active
>    KVM: nSVM: Disable PMU MSR interception as appropriate while running
>      L2
>    KVM: x86/pmu: Elide WRMSRs when loading guest PMCs if values already
>      match
> 
> Xiong Zhang (1):
>    KVM: x86/pmu: Register PMI handler for mediated vPMU
> 
>   .../admin-guide/kernel-parameters.txt         |  49 ++
>   arch/arm64/kvm/arm.c                          |   2 +-
>   arch/loongarch/kvm/main.c                     |   2 +-
>   arch/riscv/kvm/main.c                         |   2 +-
>   arch/x86/entry/entry_fred.c                   |   1 +
>   arch/x86/events/amd/core.c                    |   2 +
>   arch/x86/events/core.c                        |  32 +-
>   arch/x86/events/intel/core.c                  |   5 +
>   arch/x86/include/asm/hardirq.h                |   3 +
>   arch/x86/include/asm/idtentry.h               |   6 +
>   arch/x86/include/asm/irq_vectors.h            |   4 +-
>   arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
>   arch/x86/include/asm/kvm-x86-pmu-ops.h        |   4 +
>   arch/x86/include/asm/kvm_host.h               |   7 +-
>   arch/x86/include/asm/msr-index.h              |  17 +-
>   arch/x86/include/asm/perf_event.h             |   1 +
>   arch/x86/include/asm/vmx.h                    |   1 +
>   arch/x86/kernel/idt.c                         |   3 +
>   arch/x86/kernel/irq.c                         |  19 +
>   arch/x86/kvm/Kconfig                          |   1 +
>   arch/x86/kvm/cpuid.c                          |   2 +
>   arch/x86/kvm/pmu.c                            | 272 ++++++++-
>   arch/x86/kvm/pmu.h                            |  37 +-
>   arch/x86/kvm/svm/nested.c                     |  18 +-
>   arch/x86/kvm/svm/pmu.c                        |  51 +-
>   arch/x86/kvm/svm/svm.c                        |  54 +-
>   arch/x86/kvm/vmx/capabilities.h               |  11 +-
>   arch/x86/kvm/vmx/main.c                       |  14 +-
>   arch/x86/kvm/vmx/nested.c                     |  65 ++-
>   arch/x86/kvm/vmx/pmu_intel.c                  | 169 ++++--
>   arch/x86/kvm/vmx/pmu_intel.h                  |  15 +
>   arch/x86/kvm/vmx/vmx.c                        | 143 +++--
>   arch/x86/kvm/vmx/vmx.h                        |  11 +-
>   arch/x86/kvm/vmx/x86_ops.h                    |   2 +-
>   arch/x86/kvm/x86.c                            |  69 ++-
>   arch/x86/kvm/x86.h                            |   1 +
>   include/linux/kvm_host.h                      |  11 +-
>   include/linux/perf_event.h                    |  38 +-
>   init/Kconfig                                  |   4 +
>   kernel/events/core.c                          | 521 ++++++++++++++----
>   .../beauty/arch/x86/include/asm/irq_vectors.h |   3 +-
>   virt/kvm/kvm_main.c                           |   6 +-
>   42 files changed, 1385 insertions(+), 295 deletions(-)
> 
> 
> base-commit: 53d61a43a7973f812caa08fa922b607574befef4

Tested KUT/kselftest/Perf fuzzer/internal perf test suite on 4 Intel 
platforms: Sapphire Rapids (SPR), Granite Rapids (GNR), Sierra Forest 
(SRF), Clearwater Forest (CWF), no issue is found with both mediated 
vPMU and legacy perf-based vPMU.

All tests can be classified into 3 types: Bare Metal perf test, KVM 
guest perf test, and Host-Guest concurrent perf test.

* Bare Metal perf test
1. Perf Fuzzer run pass on 4 Intel platforms, SPR, GNR, SRF, CWF.
2. Internal perf test suite run pass on 4 Intel platforms, SPR, GNR, 
SRF, CWF.

* KVM guest perf test
1. KUT and KVM kselftest passed except for unspported features with 
result "Skip" [1][2].
                         | SPR      | GNR      | SRF      | CWF      |
legacy perf-based vPMU  |          |          |          |          |
KUT                     |          |          |          |          |
   pmu                   | Pass     | Pass     | Fail[3]  | Fail[3]  |
   pmu_lbr               | Skip[1]  | Skip[1]  | Skip[1]  | Skip[1]  |
   pmu_pebs              | Pass     | Fail[4]  | Fail[4]  | Skip[2]  |
KVM kselftest           |          |          |          |          |
   pmu_event_filter_test | Pass     | Pass     | Pass     | Pass     |
   vmx_pmu_caps_test     | Pass     | Pass     | Pass     | Pass     |
   pmu_counters_test     | Pass     | Pass     | Fail[5]  | Fail[5]  |
                         |          |          |          |          |
Mediated vPMU           |          |          |          |          |
KUT                     |          |          |          |          |
   pmu                   | Pass     | Pass     | Fail[3]  | Pass     |
   pmu_lbr               | Skip[1]  | Skip[1]  | Skip[1]  | Skip[1]  |
   pmu_pebs              | Skip[2]  | Skip[2]  | Skip[2]  | Skip[2]  |
KVM kselftest           |          |          |          |          |
   pmu_event_filter_test | Pass     | Pass     | Pass     | Pass     |
   vmx_pmu_caps_test     | Pass     | Pass     | Pass     | Pass     |
   pmu_counters_test     | Pass     | Pass     | Pass     | Pass     |

All failures above are known issues, which run pass with 3 patchset 
[3][4][5].

[1] Mediated vPMU based arch-LBR support is not upstreamed yet.
[2] Mediated vPMU based arch-PEBS support is not upstreamed yet.
[3] kvm-unit-tests: Fix pmu test errors on GNR/SRF/CWF 
https://lore.kernel.org/all/20250718013915.227452-1-dapeng1.mi@linux.intel.com/
[4] perf/x86: Add PERF_CAP_PEBS_TIMING_INFO flag 
https://lore.kernel.org/all/20250811090034.51249-5-dapeng1.mi@linux.intel.com/
[5] Fix PMU kselftests errors on GNR/SRF/CWF 
https://lore.kernel.org/all/20250718001905.196989-1-dapeng1.mi@linux.intel.com/

2. Guest run perf countering/sampling pass with both mediated vPMU and 
legacy perf-based vPMU on 4 Intel platforms, SPR, GNR, SRF, CWF.

3. Nested, L2 run perf pass with below combinations: (Mediated vPMU 1, 
legacy perf-based vPMU 0)
L0   | L1   | L2   |
0    | 0    | Pass |
1    | 0    | Pass |

Mediated vPMU can not be enabled on L1 guest since KVM still doesn't 
support vmx VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL yet and mediated vPMU 
depends on it.

* Host-Guest concurrent perf test
Host and guest run perf stress (record and counting) in parallel pass.

Tested-by: Xudong Hao <xudong.hao@intel.com>

