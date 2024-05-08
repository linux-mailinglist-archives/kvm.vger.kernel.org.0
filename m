Return-Path: <kvm+bounces-16991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2367A8BFAA5
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 12:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F1DF1F250D2
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 10:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C102480034;
	Wed,  8 May 2024 10:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OLsMND1i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E4778269;
	Wed,  8 May 2024 10:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715162805; cv=fail; b=Q4aCkYaWOf3ILOefmescLeoAtZbEE4mQPZYVJM6YUOlChMniwu7VvDxydMiqcg6gCHfBVc8K4+jhCTPHkwzgz2a91WZNh+BqFj2ThJAYHxFJ4rDJiYe5nL7anqtvR53kW6eUI3UMgpNmeNwRPDniVQjyAqQtYUuSI4BNOGucZ1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715162805; c=relaxed/simple;
	bh=+iWZAPMnIjx5cwZubweCF76kBeF+8u148CKKHrh2Zdk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AVB1wmOmjwpq8Ux73/XSiP67nmHjxhDYQuOUpijc7D1JoJbWGHSZ90qdFAj1pp8Ofb6G3Q5i8I1OpN6rlKU1xRb8UAqplTEMNqWG8MXQvBnq7/NYNb8CScip2CpaWDEg/swDZHw2iNRPct4W+NWuRcmemSuW2qT3eZawP4+srVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OLsMND1i; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715162804; x=1746698804;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+iWZAPMnIjx5cwZubweCF76kBeF+8u148CKKHrh2Zdk=;
  b=OLsMND1iKbrYzh6yr5cBzGm4pLKNnmkSm24XinZKbLGlqlGh5oQFgRLf
   jGcjZG6Gm5VD4tiOmobghhlkKiv1rIdmsclTZbpHaHa8lhSM0luq7Vatw
   vmZ0IqvcJRH1+6LLrDClXuxOM0yzstdgzocOGmtfPuceE8kxQUsfZx1qs
   5zFK1rSXYRsIr3FZvEoMHsapt/FEFTzvo4jCnktkcnFCYJgM1LSbQoSEj
   YJLDIbc/VeKV0ZI3wL5/+pPQg6F02fkr0j3qPD18LwHXsnx02KsDRCoBX
   0mxlp1AAT4XcKuio7xITagORf7D4zy7Li87LCwDaq4yt127u7pqEs3Olc
   Q==;
X-CSE-ConnectionGUID: Rnldj5ivQ5uv0wgKtMv6EA==
X-CSE-MsgGUID: bTf60iXITwSmioi3ToYXLA==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="11167231"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="11167231"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 03:06:43 -0700
X-CSE-ConnectionGUID: ZvzOEmu1SFy0wMOBsxJcqA==
X-CSE-MsgGUID: H1wIHUi/R1CQSyAYIaBzQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="28896719"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 May 2024 03:06:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 8 May 2024 03:06:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 8 May 2024 03:06:42 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 8 May 2024 03:06:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYUXpSYaflIOw6mXoYUcqKlyk1SjM7kWP0QHOkGP+qwZ5gRq6B9p7CeHsmt8UsEZxMBJXYfLbe019x4yeKpiLKOMY5vsXhy7mIbV+6L6DVp5EjzgOgC0QdVcnRs3njBOVicNJ1ibK+B9WbRxqSW/CnHXLwALftSpwL/NlBBDQMld/zGNMF54ExWsDksxyHaGnr/ZPFRNT41WdP03RNmOSbwLg9/r/ZO5MFDeVMjCwMGZxUeVRSuFPSloTcRWXMNOGZ8HyMKClR1YFqH7qmX8n73w8fkNg2487ZvVzRWzXTpZQEKbWgw/VpY0HA0PMCp76N7Za74L8zDb8LzGCdlbVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FDDT6Sj2nfsZkIf1YsBRGlGQR39fiuFwl59oysPt8jA=;
 b=nkRBqx+B2dNpcf3c53FYEaldFS9nmi5ntqChKYS8+Gv6kfGn9f9QRSZtDCkQbMp1cLsKxDNQdXgEXp8Mz4BAfHdxoNWOmhmgURfAmMv2u1C3oLLVC8yLsa9Bh8Fs9iDsn+o0DcA2KI530yMFLibIg1D09Ii0elwlwkVFAluECP1UrFYCtImWk848hAhJRUm7kvxmebf/V+TeVFPt8n/qH3zCvR//ldpOZAYAzkoztZj/GpIB+Hyh29IqglBzzISL1pL+n3PArNcpCccJXkzky33JIi7L2mFOnOf+nos0/sOa88gLzBlG7huxYDH9MBFIgO4DoylwCeUqjvnTSTLPyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB7110.namprd11.prod.outlook.com (2603:10b6:806:2b3::19)
 by CH3PR11MB7868.namprd11.prod.outlook.com (2603:10b6:610:12e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Wed, 8 May
 2024 10:06:39 +0000
Received: from SA1PR11MB7110.namprd11.prod.outlook.com
 ([fe80::48e0:2fb8:7d8f:4a67]) by SA1PR11MB7110.namprd11.prod.outlook.com
 ([fe80::48e0:2fb8:7d8f:4a67%7]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 10:06:39 +0000
Message-ID: <b851b865-427e-4a48-b3e9-068dc9130fe5@intel.com>
Date: Wed, 8 May 2024 18:06:27 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/54] perf: core/x86: Register a new vector for KVM
 GUEST PMI
To: Peter Zijlstra <peterz@infradead.org>, Mingwei Zhang <mizhang@google.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>, Zhenyu Wang
	<zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, "Sandipan
 Das" <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, "Stephane
 Eranian" <eranian@google.com>, Ian Rogers <irogers@google.com>, Namhyung Kim
	<namhyung@kernel.org>, <gce-passthrou-pmu-dev@google.com>, Samantha Alt
	<samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, maobibo
	<maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
	<kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-10-mizhang@google.com>
 <20240507091252.GT40213@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Yanfei Xu <yanfei.xu@intel.com>
In-Reply-To: <20240507091252.GT40213@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR06CA0045.apcprd06.prod.outlook.com
 (2603:1096:404:2e::33) To SA1PR11MB7110.namprd11.prod.outlook.com
 (2603:10b6:806:2b3::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB7110:EE_|CH3PR11MB7868:EE_
X-MS-Office365-Filtering-Correlation-Id: eb7018ce-49e1-4b18-eb36-08dc6f468d57
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d3d5ZVpnQ1RWbFhILzRDMG1vcjZwcm0zcEhJRDdZUTNBd294UmwzNW5lYk8w?=
 =?utf-8?B?cVNvejFQeGNVRnpJVTVyczhBa3pIdWowTHpCR29UalZJQVl1UE9jaFFySVJZ?=
 =?utf-8?B?RVlMdkJsc29PVzI0L1FxeXNPaDlHR0dwUlNrSEFiWndGUGFqUmxZSW8zS0tY?=
 =?utf-8?B?a0N5ZVloeEh4a2FCQ3MwL2poY0F4Lyt0YkVHMlNBckdHZG5pVmIrcC9pa1B0?=
 =?utf-8?B?UDlqWVAvbTJwdE1GM0xaYjRONTQ0NER4UUp0QVF1YWJoQ2VHUU5nREJheXpu?=
 =?utf-8?B?OW9pblh2UW52OUZ1MHJ6VzAxVGJYUHBLWXJGSzgzdmtsUXZUQkN2NzBkUzRz?=
 =?utf-8?B?bXMxOWVzU0VLdzZkYzhzYWxYeDY5NVhCbHA3bTBmVUg2bUFUTE5IUWRHTG9F?=
 =?utf-8?B?eGk1cHgyS1p5RXM0cUhKa25Oc1pGQlhGbmo4R3o4ZGlxZldCa01VOHk0YVk4?=
 =?utf-8?B?Z3NhMXpwVkYwbXpWUmoxN0hIT05yOWhuRHoyU3JCVGt2dE5nY3p5SEQ0UG9r?=
 =?utf-8?B?MWU1UENVQ3E5U1ltL1BQYzVvL0FxeExITVd3NVFkTmxveHh3LytBRVZialhs?=
 =?utf-8?B?RE96TFRnak1FT016V3dheHg0VGRESXVaS0QxNXZqT2xNUmNwOC9xdGhBeHll?=
 =?utf-8?B?b0E2UU5ENUkyTWpQVi84Tkl6dUdEeGdsVTM4NjZKNThJWE1TVjBUYWVKT1VB?=
 =?utf-8?B?eVlaa0E1bjhSMFlYWjU5MlRwbGxBUE81YjdYYXNaZi91RTBibzNsVUtrVjI2?=
 =?utf-8?B?NUtLOGQzT1luaXlZam5OWm1GYmpiSVUveithbi9UdG5YZEdaTW1Ra2Zzb29H?=
 =?utf-8?B?WkRVNnZkRFdSNHhKRWp0NFFaYVp4M0RmUCtmME0yR1EvcW5qNW5rQTVDY2sw?=
 =?utf-8?B?WW9malYrYjlpNnNCZmFHaU1vZEE3MDRpNlZCdVZXeXo5QlcySzQzcHA3MEIy?=
 =?utf-8?B?dFFSTE5GVGxxd3IyNlEzd0hiSytWWVJQZmFQS2o5UUlQNTdhK1JySkozUTlH?=
 =?utf-8?B?RFo0eGFQTVJpdU1PbllIRHFKd1REbmpYaHhDaHJTcThxa3orSjNGcklMUXNL?=
 =?utf-8?B?Y3VxbEVJY2htbXRJRXB3MVV4RnZsTjN0OGY4TWVJdWJEaDhxK3QwZkdNMWor?=
 =?utf-8?B?Qlk1ek12V2RaTTNUMHQ1d21vUjNQWkZwQkdycUFST0ZUYkhJLzg0MGIvZ3NN?=
 =?utf-8?B?dGVQcktKcHVjS0pNRVZCRkdsay9uWlE5SHUxNTBFeFRLeHYzSThCd3d4QjRO?=
 =?utf-8?B?R0kwTmMzcm10VzJ5YjMyaGxoVTNMRWtSazlLK3prK2EvLy95UlhuWHBvVXQ4?=
 =?utf-8?B?eVNvY1JxbUVXRU1iUXZVeXpFVyt6V2UySmorWDVFTGk0YTU0NWRscmlvNWp5?=
 =?utf-8?B?bEVNK3ZlT1dRQzRJZERCamM4RitsUnNhMG95RjBkUVZWamZ1TGJldkxueXJm?=
 =?utf-8?B?MitKTVpCS2dObldVc2Z4cVViZzBNZis3NjlJQ3RsWmc4TDlMRjNPeXFuVVNv?=
 =?utf-8?B?dDYvb09yQkZKTXI0VFk4VUdic25DWWVyRWJNV2xMbnVBOXpVQmw0OHBBU3FW?=
 =?utf-8?B?V3puTjJsUHN0VTZBTlVJbnFQRjA2S2h3N0xxcFpmcGlyTWp4clpSeVlqMStT?=
 =?utf-8?B?RXVWOTlMRHZJMXhWTmNzK1VablJpQlczaTd5emNUeVJuTGtUL2xZSm9PVFYr?=
 =?utf-8?B?bFRMV0lzZkthUy82dk0zU0NqQ091VmplcHlOQWZ3MDN1bUxuNXBwN3FnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB7110.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MG0yaURCVG50blFMSEpYZlFQWlZMNnJvUkdqeHlGOEx6VmNtWFluZzlwamc0?=
 =?utf-8?B?bG5mVys2YlY0a0NRWVFPTUxtSDBZOS9DM1hFaC9XZVFUUWlLdWN1VS8yRmk4?=
 =?utf-8?B?d1ovS0V0YzZDdHEycGlPNWVRMWszUm5UcnBTaGpZR0MwbzAyL05lY1J4Yy9t?=
 =?utf-8?B?U0grbW0rNnpqNVNkZS9yZ2FFVng5c0hONDF2VFBYSVJTdUhmd0lkMzdySCtJ?=
 =?utf-8?B?VllCdjlUN2FFWmlHbHJYMW0veTRscW5CeUZQU3hFZ1ZudTMxUGdlMmR0YjA2?=
 =?utf-8?B?ZUd6SjAyRlRBdHFtcm1TQ0FOeFhnMEhiYnowM0JMU2gxR1U5OTRFSW8wY2Vp?=
 =?utf-8?B?VXo3SkdEQzVrUGJqR0Eva1o2YTI0TnByYitJRUdNU2hTb295MklSWWp3ZjBZ?=
 =?utf-8?B?N1VPaFZqbytGci9IUHV3anVjQ1RRSjVaWk9wOWdBR3ZjUG1IbHR1NXQwME4z?=
 =?utf-8?B?Z3c5dGF6ZXAwV3VlS0Z2K2tOZUJhc3VnUjM1cHhWY2dPVTN2ck5iVFcwOEFY?=
 =?utf-8?B?dTNWWHhydk5Zcm9Sb3pINDBVSFAyZ0loMmxSbEdIM3JDa1ZIZWhycGg1YTRQ?=
 =?utf-8?B?UWpwaWU1MnRaMitaZG1oMDZ2dWt5citmSFl2dUsyci9mS0NKTWwraThFcThK?=
 =?utf-8?B?YkErZGtudVk1MGlhVXVqa2gyRlZ5MElrbHRXcmlIKy9jV1NsMktVVnVKSWxK?=
 =?utf-8?B?Zk1NSXdUUXZaSUlSWEU3Z1drdnJtSksrOUN3TmkvNlYxZmsvaEVHaWFRU2Fr?=
 =?utf-8?B?OEx2ZjRLdWY2MGVFV3ViRnpPR1JIMEJKRFlhRFI2dTRuL1RzeVZBRjZaT3dB?=
 =?utf-8?B?RkliVFZQdlcyRXp2S3FIVE1HdDFFZTI0MTBBb0R4YjJxMHhWeHZIcEwxSDJV?=
 =?utf-8?B?WG1CaDVGRW1lNFN6M1krcW5zWnBQK1V2cUNCei9tcHRva0l5cFJRdGhUSktH?=
 =?utf-8?B?SndDNFpqbjltVGRsb1pkWXBKei9HWDBXT1BYOEFJV01nNkZiSjhzRlNBeDUr?=
 =?utf-8?B?VzRoYnRIRTUrUHFSdTJiV0JoS0ZzRW1jVUtqd3VwZkRPZjlZajhOd05kVjZx?=
 =?utf-8?B?ZENBOExYOVVSWGdoRCt1YStTeTVPOHVTc2tkS05KVUgyTlUrUHA0YS9GaXdP?=
 =?utf-8?B?TEc0QTVmUldGd1RlM0JvWUhwdDF2cEFXZHhpMTkvS0g1RlMxVURRRW9UZG1a?=
 =?utf-8?B?UnRHSkVUY01VQUwzN3FGZXUvQ212cjFDSVdzSi8zelExN1ExQWl2RTdyanFF?=
 =?utf-8?B?OU5NRjczV01aTGJ0UG9wV1BxR1Q1c25PRWFXMWR4RVZHWTdzMzVjUmw0THpw?=
 =?utf-8?B?M2tITnYyYlJ0RGVqenZ4MkFzY0wzY09yTTBteENnSzRza0F5SzRwd2xaZU04?=
 =?utf-8?B?dzdFNzlDclFOazlEdFZMc3NjU0tBWHpaOEhTUUlmWXFGTXVtSzh5MVZ1RGJr?=
 =?utf-8?B?L2c4ZEtaQlFRS2VlekEwWURpOHpNaFFXR1Zwb1U2ZzN5MlIvU21aNDNLZmhH?=
 =?utf-8?B?bUZIUllhZjhPUE1pQ2kvZlcwU0s1SW8rWkprNElNQVRQNmx4bkhtZHprbDdV?=
 =?utf-8?B?eHRIeThidWErKzFkanlmZHZIcFlGcFdEUE5oakJnajZnNm1wZjJXTlUzWVgv?=
 =?utf-8?B?TW1jZC9aeHZ4TDlNb0ZmYVV6Nm9QNWtzY3htSlRsTDJJc25Fck9pVlFpZ2Zj?=
 =?utf-8?B?TklzWVoxZklZLzk2S0hWWklhVjdWK0swYVZBblNybW1HeHdwK09mVEdiSUtL?=
 =?utf-8?B?V0xhd0hJblZzRWtidUVybUtqN1Rwa3Fzbnp2eTQzcnovcFp1U0ducGN2MVQx?=
 =?utf-8?B?T09ZNGdvZ3MrcXdVdG10Y05VMjNMOFVCTXhjQTdPMkxHek1OaExkRytMcTA4?=
 =?utf-8?B?YzlqWFkzMUlPT1Z0ZERJcU81TlhPRmxLT1N6Y25RYVFBQm16VVd0YjdYRnZS?=
 =?utf-8?B?RjBBLzlQbW9oTlBEM2hiL29rV240MFhvbHBxSXgwd05QRXFzTGRsTjA0L2RH?=
 =?utf-8?B?cTBjcnBYK0FoOHlQa0c5aVRlbnZXejNzVmdEM1kxRzcvRiswMmMxVTJmUDR3?=
 =?utf-8?B?NXJVSElGcm5Cb2JHY2FlbHZmZzdSaU5Uc3NxNXRVT3piU2kwOGw4eTg2bVRn?=
 =?utf-8?Q?ige+Js15VQuyHIHllvW+9yVpN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eb7018ce-49e1-4b18-eb36-08dc6f468d57
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB7110.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 10:06:39.1856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dUxXHpOxtb9zRmJwdrXgl+hLkAriscUBuWi0R12mzxQw7QiZ/TqldmlpKCx3Iy7qZK8c5jxfNQFz9p9R0swn2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7868
X-OriginatorOrg: intel.com



On 5/7/2024 5:12 PM, Peter Zijlstra wrote:
> On Mon, May 06, 2024 at 05:29:34AM +0000, Mingwei Zhang wrote:
> 
>> +void kvm_set_guest_pmi_handler(void (*handler)(void))
>> +{
>> +	if (handler) {
>> +		kvm_guest_pmi_handler = handler;
>> +	} else {
>> +		kvm_guest_pmi_handler = dummy_handler;
>> +		synchronize_rcu();
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_set_guest_pmi_handler);
> 
> Just for my edification, after synchronize_rcu() nobody should observe
> the old handler, but what guarantees there's not still one running?

Interrupts handler can be regarded as RCU read-side critical section,
once synchronize_rcu returns, no one accessing the old handler lefts.

> 
> I'm thinking the fact that these handlers run with IRQs disabled, and
> synchronize_rcu() also very much ensures all prior non-preempt sections
> are complete?

Yes :)

Thanks,
Yanfei

> 
> 
> 

