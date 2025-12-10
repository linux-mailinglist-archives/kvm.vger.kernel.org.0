Return-Path: <kvm+bounces-65639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EC07CB1965
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 02:20:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5C24D3022B4F
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 01:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF111221577;
	Wed, 10 Dec 2025 01:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jKGtOUnp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C3DD27E;
	Wed, 10 Dec 2025 01:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765329617; cv=fail; b=Gangbj5OLLY3oL23idaD4PnnQCgjn01SLPu5/UbNDMNH/+GVDiwhqesHlp6Ua+JSfo+qbr9ZXS9mLOTlt+DJjWICKZzbX1ZBjuHOzuRb2O3RguVjyRL3kcoY6D59N0E96BxL7L+tJQFNlWr8SxOPDtaiyNDa9UVGhD2k5vTHPJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765329617; c=relaxed/simple;
	bh=hDTdW7tUEVaKotokCutrTq2iJbBrGmoTU0HPz4kv6Zk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T895eAtRWXIfLkNUK3wzyTUPyTSwbAS5f08eP2hrH6UgnM7O0XbuwxyYfeogjzQtbD6tj6a5CdZ51eF4rRV+LZZuHGkhfHO557pzamNSW+mJOSN1POah7Sy2SmTNfCyVpOfIchdgklsn57cIVlev4fvvqCqWJ4JiC6lF3zFsgzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jKGtOUnp; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765329615; x=1796865615;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=hDTdW7tUEVaKotokCutrTq2iJbBrGmoTU0HPz4kv6Zk=;
  b=jKGtOUnpMpGs4ROKKKoyRVYiuj6h8pnSjg/14CkQtxl60OBqXV+S7ywM
   LMEIQ5lLAxtG77Pbt8f6r2+COpZPCnOHN+KADcZEhB1ysT8mj9DsDsD05
   nbTsrc3Yi2Ttec9RzjlSH8dvvzRW067pQH/VFn6e+A9w0kidzN0AUYMmY
   zo/QdjkDGweq34NVPysVVeMagez1fB8yvVEGOrxInuUlDp5lUue81t9Hg
   P3Eag9mTg5EGS/t7gqVhbdZLMK0lE0b+jlHB1GOUUUAs26zZ5T7fQCdVX
   gIhDkX0GT+zb9nVtvqjtumAxR/eYQdJUP9xsk+BRCVMhWtmOGV0QBuFPy
   A==;
X-CSE-ConnectionGUID: q2ldUQFxTSCFLPTwdY0MIw==
X-CSE-MsgGUID: hg/PF3i+RVa63QJ4PifWpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="67022275"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="67022275"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 17:20:15 -0800
X-CSE-ConnectionGUID: lXORhQ04Ts6uNRNAsoPWTQ==
X-CSE-MsgGUID: v1cYLuS6RqWtw1jXXrWQ0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="196278366"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 17:20:14 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 17:20:13 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 17:20:13 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.62) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 17:20:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w9V7GG/YB8RFGE8QIhEGxY3iSggVfrkFOGjMuX0woxM8m4bDXJ42HuwahZAnViYyTbovtvD4uiMCfh98V1ALINrRnVWj0MWdnxY7RzlV7ngcQIBBNme6UUd5oMSPmxVQi+76oZ0wf+X+iMSbE7y9K0RcV/5N5N9G5a0+/gLcvS6SlUhweXeboODQ7Xr9X1qYjfWkiaCtuawH6r6rd8/1vUuTTOAA/hRvx/SHcJ+25sNLzK+kFx564YJXcrjhP7dAR3CY7KQf5ykQVHyWpCPX3/RPKho0NkdIrc78Mt+PQ7Gmgw/0KSRnvkYK27UkuD7e8SflCfiZIH5n/bmjA5QApQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2NbeupdasHnR08AkfOe27GgHAxrXKaziX/63s6cTikY=;
 b=nkl9lPT7LFdjrop8Kig+PLvlIW6imQZ0rHoXt33M2CbH6Ox5QZzjIdwuGQPwLmxVHeZym37khoA9ixLkxxPdX3YFz9cVnoNKBJwWiKlsqCfIRlnWkdGZUx7MMxpX/m6Z/F28OVVlUaUaje981ApdTotmn4UXKDba4H2eoMq0PMUGf6SAxoJwuqlF2YRwlo8CfQeCgVnGT/XoVG26yKPMVdnLiYP4rEfpHhOzef6ErdV4+RGZjb5Hd60g6YJtCvo7+vH8hG/xVYHXudLmA1Y/wE7AYgeJ8E5bOyW4yrOahRtYP84ziTr8GTu59u3G2+U7NW0lc3TaXlFyj9QEgWMSzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS4PPF708A6BB3E.namprd11.prod.outlook.com (2603:10b6:f:fc02::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Wed, 10 Dec
 2025 01:20:09 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 01:20:09 +0000
Date: Wed, 10 Dec 2025 09:18:15 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 03/23] x86/tdx: Enhance
 tdh_phymem_page_wbinvd_hkid() to invalidate huge pages
Message-ID: <aTjKV/hAEO4odtDQ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094202.4481-1-yan.y.zhao@intel.com>
 <CAGtprH8zEKcyx_i7PRWd-fXWeuc+sDw7rMr1=zpgkbT-sfS6YA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH8zEKcyx_i7PRWd-fXWeuc+sDw7rMr1=zpgkbT-sfS6YA@mail.gmail.com>
X-ClientProxiedBy: SI2PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:195::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS4PPF708A6BB3E:EE_
X-MS-Office365-Filtering-Correlation-Id: d3629236-6622-4a0c-4fad-08de378a4204
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UHVFZXUyYTdzQXFzL3ZEOHBRQW5tUHNoYU9ncUJnek5xZEpFSmx6MGpNNy9K?=
 =?utf-8?B?bnoza1hJZCtjMWZtbCtqZlE2UkVLc0dXZWVQcFZ3SlovdkxRRDFEbWQ4MEpG?=
 =?utf-8?B?RWh6QzJXZGtLc1JWR21OTllzNTFhdURhekdZbFVKaDVzSCtiMUJWWk9YbFlr?=
 =?utf-8?B?cDBDREZqWHdoZks0K0IrYjhWY0tITW96WG1HL0xXZmJHaVBaWUlZREd0RktZ?=
 =?utf-8?B?UXJkZEdUd3FmdnRCTG01ak5rSVdGUHZsZ0VnL2NKWUpTREM3aktULy90bUhU?=
 =?utf-8?B?cm5QK0lGUWYvdjJPczNUSWx2N1RXUHg3RC9kSDZoV2xPYTdpeFRWSXhCWHM1?=
 =?utf-8?B?L21xbmdHYUowS0U1R1lleGFmc2FnZm5GRUNoT3d5TlBMbGNQdktzSEphZTFj?=
 =?utf-8?B?eDNMT3BYV2p6TlNleTBGTDVYU2NyVkhTUDF2WWdzZmJlTndNMG5FZ05CQ2VZ?=
 =?utf-8?B?WktWVEJpMjlKMEdXWUtId2tUYW5vbEpaVnBHTTkxbmcrSWhLUkhWM0xOS2Jr?=
 =?utf-8?B?d3hqekdTSmZxZzNiYVFnYmYzNkdCRm9Jc2tMMTh1Y1BySnk4ZFd5cWNlRkV5?=
 =?utf-8?B?OFBIZ1Z2S09RNFNSVUZKdXd5TjhVU2N4ZmFHZTZrYStHZ2NLU1M5TTVPN2Jh?=
 =?utf-8?B?WGVZVkZMS3BRbVJzSFpva1BvRmdGOGNDRTdnN1poMWtSZlBGaE5HeERSOTBM?=
 =?utf-8?B?MFYzSnRwTUVlMHg1Q2tUbWFwWjU1VTIrMmlhUjJkSU9PekJhdjJ3Y0NNY2pC?=
 =?utf-8?B?eFlqMWx5d1cyRXJ1L1htN2ZUbTZLRERYYk9EZ2dKcXFrRWJ3U2l0RXB4NjRX?=
 =?utf-8?B?akFTMFZKT250THdYOXM3Y09yQmpkdTBxWDZadmJBUTlDNy8xdmJtV0NWWmFh?=
 =?utf-8?B?N0VwanRSZHgzZTRVbXBtSzdGK3NyYWZGV3pIVEtHUU1MTkxBbFZ3MDdsM2tx?=
 =?utf-8?B?NFVlRzlPbUtlSmFkY1R6V2MrOWg5NEd1VHNBb0tpaDZNRHN2a0cyVXMvMXdN?=
 =?utf-8?B?RUVSOGZ0UC92ODE5WWk0bjd3VlFPbVFBZ1R1OUd3RFJTaFpEVmt2YkxVdm56?=
 =?utf-8?B?TDlPSGl2NHI4VGt0QkNqQmVOUlkyM0ZhbmlZMXpaK2dQV01DK2toSWJPOGJN?=
 =?utf-8?B?SkxJT09rbEhZd3B1ZnI0dVI4NWlHZGp0WXJIaVZJcmZrMDNOSFJucWU4N1NP?=
 =?utf-8?B?bUpxVkI4NVdzZGsyTEV4eG1mUk5aR05FU0FKZnQyajhGc2lla1NVM1RJYWlZ?=
 =?utf-8?B?NTJxZjl3V2pydHcvNmUzSUNiTmdleGRKT0hqVlpZMndRL1NZbFpWbFZmb3ZV?=
 =?utf-8?B?bE9HdjZBSmIwWTRRbTVFZ0hFYnc5RDltMDlHRW52ZUZTMVZJNDg3QUZQbjJv?=
 =?utf-8?B?MGRlZFJjd0tkeW5maHhMSDRUY2liSDVjd1NZRmU2aDd4Z3ZYY1g5UWNkMGxt?=
 =?utf-8?B?SlUzOFlDN1JwcGhsUDBXNEJDMzRLTk9MdlFqN25NWFlLL0s5a3M1cWxETWFh?=
 =?utf-8?B?YTFkY2xML0pPcTVhRWpyS2YvVExpUG5SVnJaa1NQejlqRTZEdFgrT1E1b0Jk?=
 =?utf-8?B?eitFbW0vREg2ei9ISDFZY1JaM1g2c05ieUJUODFTT2lNTDNTK1p1REw4eHNJ?=
 =?utf-8?B?My9oRnB5VDh4NE1yUzFCV25sSFYzM0tOa3hDanJ5SnpoaHJQNERRMm5neHZK?=
 =?utf-8?B?eDY2MGVxbjVUdGN2cG04WXFORkM4SnhVUGM3L1BYQjdNcDJYT1ViT29XcDVT?=
 =?utf-8?B?TXNQUDUvOTVKV1NJUklzV1ZiNkszcEc5UkxFRkVOQWx3RFJkRzRtZDJDVmV2?=
 =?utf-8?B?NjJyRzMwdjFZaFdrV3UySTFZNXdVcFJYWXVXV1ZiKzZrV1Y0RUxISlgzRTFN?=
 =?utf-8?B?N0FpUzBtV2V4Vkc4SVZ1NzhZcitoRENDaThnaGNhZ0toWlZWekZEeWVjQzB0?=
 =?utf-8?Q?ce4DOzE3ig96wFAVwkagI3Bzeqrrbx5i?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFZBUjNlSVRwV1ZPNFFTYWcvQy9NMTNrbGlNaVlkVDRucklmNmoxRS9yKzYx?=
 =?utf-8?B?Q3orR0NsU3BpU3JVSWZEenhCdEl2Z091QTVVTTI2Zlk0UktOQUFEZHNiczZN?=
 =?utf-8?B?R1Bva0N3Sk1wVkdJVFNQdEcrT051LzFscEdvWGZBUXNhbUNPY3JubCs5WHhk?=
 =?utf-8?B?OVB3cW53NUpGbmI0d1lLdkIvVlk5eHJYTmhLN3Q4c1NGMWNnOWg4RjBEb0ts?=
 =?utf-8?B?dXpQeHJLSm9uT3ZFUmFsRnhuS3gwL3dsK3RxWWR5dUNET09UT1pDZlNQN0Jx?=
 =?utf-8?B?S0xndDFVZXd5ZGpma05KV2hzbVo2YTJKQnhlaDhHRTd3a3Z0QnJVVmRaOEEy?=
 =?utf-8?B?dFA4RXVXTnZSL0JsNEp1ZTJjZlZJOXpvSTBnNFpaS3owOUROUUVkL3luNmpM?=
 =?utf-8?B?RW9tRkNoVk5PN3k1d2tWb0lnYmNxSjVvSDlkTVVqelJSR2FXcVFWbVR6RHF0?=
 =?utf-8?B?L3JyQWRqWk8wT05oVU1Qbm85Z0tEdGVKNzdwRTlScm9pWEREK0w0OTNId1c4?=
 =?utf-8?B?V1poajdDQTRSQ3FPNVpYUmV1ZFQyazBUVHdaQkliM0RuQzBsWklvd2dlTHdN?=
 =?utf-8?B?eHUyNkVDcERWemtIMy9HNG5xTS9mUFhwTjFNanpOSlNXenN6TTZLOWVvZUdt?=
 =?utf-8?B?RjdPaTJna0JLVDB2dnJPdlNtQTQ2Y1ZPSVFXTFVhU2FUS1RjeUpjSmMxb0cx?=
 =?utf-8?B?Q2VCbStxL3lzYUdneDFRb0pBR1VwN2hXVUZTL1lOdkhRYVdFV25CSGtreGtG?=
 =?utf-8?B?aTBNblROeXlWSkc4OTVGK1I1REZxOU9DRWJHaEx4WS8xSktMcStvdFIxL3gy?=
 =?utf-8?B?S2gyMWpvU3ZVSms4VC9NVUVYKzRGa1o4dllqUUdlWmh3UU9KTWNrQTRMNjNy?=
 =?utf-8?B?Q202ZXE0Q2FncExDeWYxWHFPRzlwRk9OK3dNTDU0U2RKU0ZpSWo4d3JDeDdT?=
 =?utf-8?B?V3V4ajkyelhjYTdSbnZRSFdweHM0eWlUQ3R1UWVROWRyOWRRbEs5SmFsMVQ2?=
 =?utf-8?B?b0hZSm0vSFRJMml0UmI0ZTUxMEdiTzhlcDJwaFk5ZyszeG9tZ0VYUnMrK2Yr?=
 =?utf-8?B?Ums3NkhpbHNlcWZNMmpqNXhYdkNlcWtuY3J0alFXSzUvTUNDTGw5eEplT3BJ?=
 =?utf-8?B?anhWT2c5OWovWjlqcXhLcmF4dFR1bExmYUdmemtEKzlGWm1LNkZwTTh6YzFs?=
 =?utf-8?B?WC9laUFpRUtXUmo4ck4rSXNwTVBZY0YyYWhJRTlGSGdsbU1ScjFQSGhPOGU5?=
 =?utf-8?B?eUo4MVBEMXNUcTd1NGVWUHRTMWhlWEhhMjRXWmsxT2kwa1JWVUJBanM4S1k0?=
 =?utf-8?B?VHp5aHpQMXRpMGV3MHpsNjJnOUN3Q1JWbytKSGdNYmMzMmJDL0ZLM3NBNWEz?=
 =?utf-8?B?U01vZU5Qa3ErRXRaL0FnN2JPc28remdTQ1BqVG4vL0ZScGpyTkNvQVY4NGtE?=
 =?utf-8?B?Z0ZqSnY1dlhMNFVVUjNiYVRpY2xlQjBsMjFZbm5pbUJTSlNYaHdQWEZraGw0?=
 =?utf-8?B?MGY0dUwzczJjTGlKc1JuNENhYVMyZzFHR2JhVit6V09QSHZwZkd4bE1UNXNP?=
 =?utf-8?B?RWlHQXhBKzlBdGtTYlRJRmFaOHFpQkZ6MzY5OW4wQ0d6VUJSaC8zbmZDeHNm?=
 =?utf-8?B?aUNPL3phV3EvYmdoK0syNWEydEZUL2g1TUNCSUl2cWhXSTc5MFFENHRCdDRL?=
 =?utf-8?B?YksrdThEejhsYWxFNWVzTnlvZFZCSzFzKzdlMnN2TVBwY05aS3MxN0p4OUxs?=
 =?utf-8?B?d1oyeFU3M3RSdDZndDhvMnZkMVZTZHNBMmJPeE1qczF5MzJOYTY0bFpQcGNp?=
 =?utf-8?B?RHBqbnYyWm1lQWpEeWI4WnEycEdMRjFzSHBTazhFNmtSek5nSFZWS3lOeWhw?=
 =?utf-8?B?Sy9vczRuVnlJWjJkRUVnQTljcmtBRVZoZ1RoMEl5SFRNUVg1NXpNUk1EanYx?=
 =?utf-8?B?R3hKcHR1SnIrMkV0MkJielhidTVqN3liVXlmdVBzZkJhV1JNV1cyb3o3SjRW?=
 =?utf-8?B?NHNaMGxEN0l6MkhVK3cvUFdTL2JEZ2ppblNyVVdPQjdmMUwrOG1ZZyt1c0JR?=
 =?utf-8?B?ZzV0c2pPdTFIN2l4TWVaakcvNWF5cVgrSkprQ2kyeFNzUDZxclc1K0R0WEJB?=
 =?utf-8?Q?UfbOJ7w9C/HA4N10aKMmdT9t9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3629236-6622-4a0c-4fad-08de378a4204
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2025 01:20:08.8479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y1r5XnLJf+CIa1WkAyhcSbTp2BFIazMeCKejel1rmGPkf8Yzk5D5o9e7+Jzb4p0+usH0jVlE3qyl2+xQuoRuog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF708A6BB3E
X-OriginatorOrg: intel.com

On Tue, Dec 09, 2025 at 05:14:22PM -0800, Vishal Annapurve wrote:
> On Thu, Aug 7, 2025 at 2:42 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > index 0a2b183899d8..8eaf8431c5f1 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1694,6 +1694,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> >  {
> >         int tdx_level = pg_level_to_tdx_sept_level(level);
> >         struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +       struct folio *folio = page_folio(page);
> >         gpa_t gpa = gfn_to_gpa(gfn);
> >         u64 err, entry, level_state;
> >
> > @@ -1728,8 +1729,9 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> >                 return -EIO;
> >         }
> >
> > -       err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
> > -
> > +       err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, folio,
> > +                                         folio_page_idx(folio, page),
> > +                                         KVM_PAGES_PER_HPAGE(level));
> 
> This code seems to assume that folio_order() always matches the level
> at which it is mapped in the EPT entries.
I don't think so.
Please check the implemenation of tdh_phymem_page_wbinvd_hkid() [1].
Only npages=KVM_PAGES_PER_HPAGE(level) will be invalidated, while npages
<= folio_nr_pages(folio).

[1] https://lore.kernel.org/all/20250807094202.4481-1-yan.y.zhao@intel.com/

> IIUC guest_memfd can decide
> to split folios to 4K for the complete huge folio before zapping the
> hugepage EPT mappings. I think it's better to just round the pfn to
> the hugepage address based on the level they were mapped at instead of
> relying on the folio order.



