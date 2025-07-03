Return-Path: <kvm+bounces-51370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20D85AF6A5D
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAEA548235A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 06:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA4A28F51A;
	Thu,  3 Jul 2025 06:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d2Hx0Of+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDEB4A2D;
	Thu,  3 Jul 2025 06:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751524373; cv=fail; b=buyk/VxFKXzQeVP96ma5oD/89XBpn6UlYcO1Zh/qbI3dRgvv/MZjzBS1zbIj9YWAcOQBPihQp3XUrPXYIAyTdVgkT6T7JNExOJg7sFDLIcHHGn2yJvSA6AVHPRdaAW8rCMLP4wHpr4/qvktGCHlAPF2ChPL8L6nmCf7LNHGAKw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751524373; c=relaxed/simple;
	bh=x2M4Xq+X0/NDog8KGQT44u7roNwJs0mNWo/T8JpRqIM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FxF01TWWn9uH6GlQEE1fGVqTDJiQop7R0WlEpBTO3qwyS2DnYNJ0ClQQypUqpiZS1+C8EhbrPhPZQOCGiNs2LpnKoqmzCx/etvvqh41n9YMq8iOxvJxbA4DQpMn1mc115bgr9UyE7ePVh+wdzLYq+Vs8Q6bsyPqkmA+cTxEcVfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d2Hx0Of+; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751524373; x=1783060373;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=x2M4Xq+X0/NDog8KGQT44u7roNwJs0mNWo/T8JpRqIM=;
  b=d2Hx0Of+vQ+AgIf8ZNuS/FaSdcLHyhc5e/pWc9aW8bf5Prkh2QwYCI4v
   YpkIS7ve+kpMSDuUFxE4Y8RfdFsR+wklJLXrgfJIeeBque+PT4owefWcW
   PLd1g35E6XLXv2FZ8KeKLbMomz76FRDhKzs5mUK1yAa+aBdG5PyaYcEap
   ELNk5XJYbxGvWgXhg8p7FKBR0SwhhIQXTW53g/uIhdkZOYwZPS+JAsrbH
   cbuUHrKdf18y/0wPhk8o2e1oAzVqkRs0KXBWHvLJtIu/Jz6AhEbMS6z1w
   ij/ylKRUuy4ADdLNi64HtPFr7Ew0O0uAS5SKO+IN0KAn7gUZaE3W9vV2C
   g==;
X-CSE-ConnectionGUID: PEL/f+GQTc6rFhIw+A2ppA==
X-CSE-MsgGUID: vdDfJ211Q8ufdAbYbmPHuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="53702162"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="53702162"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:32:52 -0700
X-CSE-ConnectionGUID: USeXGHquSMKFRDn2u+N+8Q==
X-CSE-MsgGUID: Hp5CjXjFQ1iZsmCvR0YlwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="158326518"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:32:51 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 23:32:50 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 23:32:50 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.85)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 23:32:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FTM69z+5Wu1gpSfM6MpnwVjRaQzrMHjohKqCHO5BDbIPj4jg30EZMqa/jxEV9aMYCXd1I+No9a1ndu93uAW6orU9pXBYv7nutTmK5kFsNP3njBsowlvD3Chs2guht5S4BxcqQPTvfVm+G2/6BwEhbj4pRHZ52WpWT/ORv6JFPs6sL1waJXMQgGpAHh9+a9KGbEjgqpMNYAgYHFfJnW/E69JrqBtNMQ1rHZfa3OBBc3LciHlSIRrXbzBe/MupbKNDObpqgIDdwSb1yfGtN9nKlloCGcIWiZSyfDtXrnV3+QiDvmnFgF92kmqo+Gdd4JtO/ghlmM8KXkIHtc/j7jxvOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HOCDKo8XlxXBFErh4trSavOccDopBPmBLDmmG/npUPg=;
 b=i32Mo9Qjx8QIBPbHc7oFJCHpOBTfSfshux/IgRK8+bg1PoYDD+o12aiLvq9AgCuIZI1hrxAwzIV7BPM4RwZUEFJUtPTPiqEjNimn7uGCmiSRHm+kljfTq846azZQYsNJZlcL3yWzlJvzhY1snVJTAoVRjyl8514PHWMxNTut1/hIycKxPj/5spKxI+QZcpOQavpfgI0zdcWM98RS/TEWEZ11J2V8QmrulYCYu35ngRjLsOWJ8tLE27nUbSRCx85qLUXfIBs9y4+ZjH0zPpyhJpG/tl/iDUnQDhwU2JwsdKlLuAuttatTILoVP/6wBNReFOQxZpfVxCoMrRtANmWKNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7643.namprd11.prod.outlook.com (2603:10b6:510:27c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Thu, 3 Jul
 2025 06:32:28 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8901.018; Thu, 3 Jul 2025
 06:32:28 +0000
Date: Thu, 3 Jul 2025 14:29:51 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, <michael.roth@amd.com>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <quic_eberman@quicinc.com>
Subject: Re: [PATCH 3/5] KVM: gmem: Hold filemap invalidate lock while
 allocating/preparing folios
Message-ID: <aGYjXwKCypFaiyVG@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <diqzjz7azkmf.fsf@ackerleytng-ctop.c.googlers.com>
 <diqz8qmsfs5u.fsf@ackerleytng-ctop.c.googlers.com>
 <aC1221wU6Mby3Lo3@yzhao56-desk.sh.intel.com>
 <CAGtprH_chB5_D3ba=yqgg-ZGGE2ONpoMdB=4_O4S6k7jXcoHHw@mail.gmail.com>
 <aD5QVdH0pJeAn3+r@yzhao56-desk.sh.intel.com>
 <CAGtprH_XFpnBf_ZtEAs2MiZNJYhs4i+kJpmAj0QRVhcqWBqDsQ@mail.gmail.com>
 <aErK25Oo5VJna40z@yzhao56-desk.sh.intel.com>
 <CAGtprH8U7rKrnPFHrC_ppr0wx+G=tV+LZfYtueDMZy47U1Q80g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH8U7rKrnPFHrC_ppr0wx+G=tV+LZfYtueDMZy47U1Q80g@mail.gmail.com>
X-ClientProxiedBy: SG2PR01CA0180.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::36) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7643:EE_
X-MS-Office365-Filtering-Correlation-Id: e297d0fe-8b75-4b01-ea28-08ddb9fb619d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UXA4ck1lQWliR2RrSkRZaGtTRldESVBmeXdNcnBKeFB4RmJjOG9YV2ZNeTlH?=
 =?utf-8?B?anVKOWxXRVR3elJmdEk0Y0VyWTM4UmVRWUxYayt0dnBodEpkQ2JsdjJQSDR0?=
 =?utf-8?B?OGVpcnFZMjN1Mlo0U0Z0ZkN4MEU3NU9nd1k5TUx2T0p6RUJNb1U0SFhHUStD?=
 =?utf-8?B?UGVXdmhsRjBaTDRWcU11dmxxT2VrcHIwR1FWYUpZUGNOc0QzK0NpOTFaZ3B4?=
 =?utf-8?B?SlJ2N1pvNElJZFJsWlAvVnVYNy95MG9LRHowMmFzT091RC9HMkUyZHorWjE2?=
 =?utf-8?B?N3U3aTc3RUhQaW4xNlUycURUcWcvZ1VSS0ZjSEdkcHFoWFdCeGhyWkRTUkpm?=
 =?utf-8?B?ZnRwTlNnSTJnS0VBWWxKSDYwQzd1aCtwTmFLOFpNenVRRDg0Q0RlZHZja3pq?=
 =?utf-8?B?NmE0VTZzQTZ3STNIeDF4NktuYXl4K1c2UE52QVAzSy9QRllBNHhHNEFMeUZE?=
 =?utf-8?B?b01XUUN3Q0dBM3phTkNGWVVFczNpV0VuNzl4aUxIdlJZVW9mUERZTVBkREJs?=
 =?utf-8?B?WHdjVTB0ajVXT2tvZytsVDAySUMyMWVyemptcS9LelhnL056WlNOejkxc0cr?=
 =?utf-8?B?VXNPSGFzdVdWUTV2Qk9OazdINjQyaVNjRmVxejlZcUFBczFGUllxM0FTWW5W?=
 =?utf-8?B?NFc3a3Qxa3ZJVEFQaTcrUDVQVHd1eUI0TkJ0dGx6NVJHS3k1RW5weXk5czI0?=
 =?utf-8?B?aEVkUGt5SWRaQjB1Rm5GS3JocHVsYzE2U3NvRlovYkg0WS9QZ1U5SUd0SGxN?=
 =?utf-8?B?MDRVWjhwRjFXcFJiV2M1V1AwQ2RsSHVmR0xMRDNDQm55clF2NS9UbHZPdjZQ?=
 =?utf-8?B?WlRSVVZ1S09EeEpPZmwwbEQ2dW90UVNhVWc1Tkl6TkVsaHJCUU1URFZLN1Bj?=
 =?utf-8?B?UWp1Y1VCY05OckZpYjMyTmVSWGx2cFBIdnVoVVRoQk94YnIzMDlkZjhuSTJ4?=
 =?utf-8?B?SUUxbkhDU1p0Qk1aQXcvajh1VU1TRjdrcFJaOEJxNlFqbTlhQTNXVTJqSkZ3?=
 =?utf-8?B?QlA5bGhZMWozS3ovTkREcUd2OW0xdTA3SzdiaTJnNThmVG8xby9zU0M5ckcy?=
 =?utf-8?B?OHBXUkFQcmduQm44S0Q2ckdtQXUrNkZuMGErUEtzckhpSzZiQXhmWHdzbHFy?=
 =?utf-8?B?ZGpmNE51MDdBdGVIMmJHdWlENmJmODdXZ0dvOTBBNjQzUzBFOWM4UlhWNlh0?=
 =?utf-8?B?M1pUekdUaXJNRDNlakZqeURrQlpUL09vSFBod0c5NXRNS1JKU2pPQlQ2TDB4?=
 =?utf-8?B?Mmg2YUdLd0pGZ1Bwd3FTRDVnbUpZZXh5WWs0R1Bac2luS1drNVo4S1E0Y1VQ?=
 =?utf-8?B?S3JjSG5pQ0g3YkVYTW0zZlVPbmFoV2UxMDkzN0EzUDhVbytEbHBmREd4VXV0?=
 =?utf-8?B?bGNMbFBFSThoNVc5V2hGUWs4RHZPZnRqTi9IN09QUnhSTEEyZC9TYitHcHJY?=
 =?utf-8?B?TCt3aW9yakVnSWo3VmN1bzhnQTVzNUZVQUdGZDZFTzFtS3RCR3BOZHFMa1k0?=
 =?utf-8?B?WkFVa1F1b1Z5STV2RWxNNmdlNEljR2VCOEJ4TjM2WVlIckJFRGRVQmJYR2la?=
 =?utf-8?B?M1QzV3dMb0szNVNabjQzNDNSQzJ3SE1DSlFyaDQ1R2N4MnhmY0JPTjJrQVgy?=
 =?utf-8?B?L2NBclN5ZWdrQ2ZOM3U4NVFzWDU1akkwbGhGQStraU8yb1RYTlRFd1dYTFp5?=
 =?utf-8?B?TzhmTFovS3RCcjVZR2Q0UHJNUUdJU0FYOXVMcGdONVNVRDBaWk9oQU4rdzh0?=
 =?utf-8?B?TTFGbThhVllmUmhCTWExVjJ3SitRK2Y1ZCs4NlNXbUd3am4yS1ZXdE8xcFJW?=
 =?utf-8?B?UmFLcGtEeDJpODV4QnlmUStkSUtMWEJzSnpocW1mUkd1M0dhd2ZUWUMwTVdL?=
 =?utf-8?B?RnFWNzd5UWJhZG5LZS9OTnJCS1RnbWpHa1FZd0xKQy9VUEtqOHM5dGZJdUd2?=
 =?utf-8?Q?5d99bXtHdzQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2ZIUU80TVNQL1FwZ0dVdGF6N3BzQkFpejVNaXZJNFlvQ0xxdG0vYk5VOHcz?=
 =?utf-8?B?elY3UEltcWpudmhsR2VuRkF0YWplazhYbjkzMEx4enVKTHo3RDNyajJWMWZi?=
 =?utf-8?B?YzlRSnVnampYVlJHUUk0ZmphdU9CV1VtZ2tOSTNzQTNyMTdDUE5VWDllMy9G?=
 =?utf-8?B?RDZvYU4rbVhnRGtlMndkTEZSSlRsL1d1Nm9wbEhoWENBRThJTGkvKyt5dWhl?=
 =?utf-8?B?RkRMa25KK09jNEZrY040aThzdSt1UVkxZWZ3STVTL1FqcXZoTUd6OG42ZThS?=
 =?utf-8?B?aEdqOUJkVVcvR0M5cWNYc281TTJnZmRKNEFwd1NwaU1xYmhlZVNnNVB4RFJo?=
 =?utf-8?B?R1lONVY5NmUvcE1EUitmb2piYlRkTmE2YXVmcXprOEloL2Z0VjgvcnRWYWt5?=
 =?utf-8?B?ZEduelJGS2U1QnNidWdHK0Jtcnd2cy9wL2Nnd1VvRklxZ2pIeEh4QW8rSWJu?=
 =?utf-8?B?RUhKY28wNzhvMmM3UFdTdlNyWW41SFo2Vzd0RUZrR3QxYTEwWmRFVTBYOCsy?=
 =?utf-8?B?SWVEMmRXdUZOb29TUFB4bmhjcCtFaUcrMEdmaDV5Rk92bklhWjhXWCt2UGlU?=
 =?utf-8?B?Y1hZWnNiaTl6RU5GL3BEdGhwWWdHRFhSYm0vUWJUT1h2YXoxRTF5NVAybzdP?=
 =?utf-8?B?bjJkZms2T1M0OG52cys0dlQxeHRJUjd4Y0o4MDR1VnhFQUpRak5PUmx5UVJn?=
 =?utf-8?B?WlN1WkdscmhWcnJnOUxaOHlIK0NYd1ZEMUt0SGgvV2gxZ3phRExSMW9WcDAv?=
 =?utf-8?B?dDZEblNIb2dLS0FmdFAyajN2bSs1UTJJUkNRcTZjSFZqb2FJM1o1TGpQTVNy?=
 =?utf-8?B?VWZUQjRFamxwK1gxTzNYYm11UytMUFAySzdvcXBjUk1nb2dzbDkwelVwWkZv?=
 =?utf-8?B?Q1lrN2pYcUp3bnFZQ2s0b1haTkxaNW9iMEkrSEFlQlN2cnJBNTRmR1VyRTFv?=
 =?utf-8?B?TE1NNWNXcnBNOWtuUjY3K1M2MUlNQm83aHhucXE3WTRkbWk2UU9ES25wWnBQ?=
 =?utf-8?B?eDR6Z3VoZEQ5dWxEb085VzhvZC9BUWRFams2RksxZzVBWWM5VmFTV3dQYXh6?=
 =?utf-8?B?cWZwNDd0RmxaNmhDdjZuLzYzWG5IVjB3NWQ5ZVUvazFWMEtHQ3pEZFRUN1Zq?=
 =?utf-8?B?dUh5MTkyVDhuRVdNZ21JNFlleS9XbGlSYWNkMkZ4aHJxam44RFVud0lrVWE5?=
 =?utf-8?B?UlRNczJKTkNkSnBwUmN5Q1lGdHZTZVdWWk5pWFJEL2x1bk9DTk9jcjNnTmUw?=
 =?utf-8?B?WVlmUUhjWDNma1R6bGFhRnQyN0s5ODdjNUw4Z2JteG8ySE5YRm53SVdUdzht?=
 =?utf-8?B?RWVQVDVjUTdlVDhubUJXVGt6NkZtZEVxY055RUZkUktNNzNkLzNiVVNWbmd6?=
 =?utf-8?B?VWl5dVVRcU9Nc0gzMHFMdE5CYnRiS3U3b1VYT2RnbW5FRnNGclI5WWRKUkxH?=
 =?utf-8?B?eU5iV2lyU0dDdVkvQXg5dURpVmR5RWYxV2ZIZEZITy9zOG9CbnlDNG1QQ1dU?=
 =?utf-8?B?SVFjaC9pY2l0VWk3Z1hpWlRLRUNBRFZaZG50WUhBem8wMGpWUlk3UG1kYS9Q?=
 =?utf-8?B?M25qYzc4QVFHdlg4cWVtV0tJU0xHb1paZFJwZlBYSDRyRll2TU9yWGZrZjI0?=
 =?utf-8?B?cFh2emdoQUNzazdSWi9jTGxYWlRQYmJWWWZQMGVwUDlqOUg0eGRDMXRoMlNE?=
 =?utf-8?B?VTN3ZXRWak9hN3FROUJYTSs3OTJySFh1OEZvRmQ0VFBlZTlQVTJmOS9HVEhq?=
 =?utf-8?B?UVJmamkxdE9kZ0JjTEJweGhnNzE3U0FoaHNXMXRySUFNNU90MldDenRJRE5v?=
 =?utf-8?B?c3N0S0d4OHI3dEpjT1puQnkrSFRtSXFwRUFNWGNwVjF2QTlScXZOd2M0QzNK?=
 =?utf-8?B?M1U3bld5bS9IUGNpemttMjU3YW1QWnJpcDJBNWhNQThRajM1ZGZiMElQMzEv?=
 =?utf-8?B?Mk01S3YwazBFckE1clpESmYraTNNNFZvcFJHTzQ4bGNVKzZUbzBJOGFJQTBj?=
 =?utf-8?B?QUZRTmF3SWtCekcvcG9oWk1TdkFsN3hianlIVkh3MHRmRTdGamh4TVFXWmxG?=
 =?utf-8?B?eUxub0g5dkRobnp5ZkJMNVNFM2h0Wm82QjFiWFcvaTU3ekU2NXNxYms1Q1A2?=
 =?utf-8?Q?QsX0RDiQuL0e+HFhB8paIrrjA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e297d0fe-8b75-4b01-ea28-08ddb9fb619d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 06:32:28.5099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VRR3aKZVqUiFPCTgP9tiCYA8C6PTJwp0RHmZNz8NMooI8zr5cKtXjPfCzm1WWlyQRX915dGn2ICrnyW3XcjM7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7643
X-OriginatorOrg: intel.com

On Thu, Jun 12, 2025 at 07:43:45AM -0700, Vishal Annapurve wrote:
> On Thu, Jun 12, 2025 at 5:43 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Tue, Jun 03, 2025 at 11:28:35PM -0700, Vishal Annapurve wrote:
> > > On Mon, Jun 2, 2025 at 6:34 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > On Mon, Jun 02, 2025 at 06:05:32PM -0700, Vishal Annapurve wrote:
> > > > > On Tue, May 20, 2025 at 11:49 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > >
> > > > > > On Mon, May 19, 2025 at 10:04:45AM -0700, Ackerley Tng wrote:
> > > > > > > Ackerley Tng <ackerleytng@google.com> writes:
> > > > > > >
> > > > > > > > Yan Zhao <yan.y.zhao@intel.com> writes:
> > > > > > > >
> > > > > > > >> On Fri, Mar 14, 2025 at 05:20:21PM +0800, Yan Zhao wrote:
> > > > > > > >>> This patch would cause host deadlock when booting up a TDX VM even if huge page
> > > > > > > >>> is turned off. I currently reverted this patch. No further debug yet.
> > > > > > > >> This is because kvm_gmem_populate() takes filemap invalidation lock, and for
> > > > > > > >> TDX, kvm_gmem_populate() further invokes kvm_gmem_get_pfn(), causing deadlock.
> > > > > > > >>
> > > > > > > >> kvm_gmem_populate
> > > > > > > >>   filemap_invalidate_lock
> > > > > > > >>   post_populate
> > > > > > > >>     tdx_gmem_post_populate
> > > > > > > >>       kvm_tdp_map_page
> > > > > > > >>        kvm_mmu_do_page_fault
> > > > > > > >>          kvm_tdp_page_fault
> > > > > > > >>       kvm_tdp_mmu_page_fault
> > > > > > > >>         kvm_mmu_faultin_pfn
> > > > > > > >>           __kvm_mmu_faultin_pfn
> > > > > > > >>             kvm_mmu_faultin_pfn_private
> > > > > > > >>               kvm_gmem_get_pfn
> > > > > > > >>                 filemap_invalidate_lock_shared
> > > > > > > >>
> > > > > > > >> Though, kvm_gmem_populate() is able to take shared filemap invalidation lock,
> > > > > > > >> (then no deadlock), lockdep would still warn "Possible unsafe locking scenario:
> > > > > > > >> ...DEADLOCK" due to the recursive shared lock, since commit e918188611f0
> > > > > > > >> ("locking: More accurate annotations for read_lock()").
> > > > > > > >>
> > > > > > > >
> > > > > > > > Thank you for investigating. This should be fixed in the next revision.
> > > > > > > >
> > > > > > >
> > > > > > > This was not fixed in v2 [1], I misunderstood this locking issue.
> > > > > > >
> > > > > > > IIUC kvm_gmem_populate() gets a pfn via __kvm_gmem_get_pfn(), then calls
> > > > > > > part of the KVM fault handler to map the pfn into secure EPTs, then
> > > > > > > calls the TDX module for the copy+encrypt.
> > > > > > >
> > > > > > > Regarding this lock, seems like KVM'S MMU lock is already held while TDX
> > > > > > > does the copy+encrypt. Why must the filemap_invalidate_lock() also be
> > > > > > > held throughout the process?
> > > > > > If kvm_gmem_populate() does not hold filemap invalidate lock around all
> > > > > > requested pages, what value should it return after kvm_gmem_punch_hole() zaps a
> > > > > > mapping it just successfully installed?
> > > > > >
> > > > > > TDX currently only holds the read kvm->mmu_lock in tdx_gmem_post_populate() when
> > > > > > CONFIG_KVM_PROVE_MMU is enabled, due to both slots_lock and the filemap
> > > > > > invalidate lock being taken in kvm_gmem_populate().
> > > > >
> > > > > Does TDX need kvm_gmem_populate path just to ensure SEPT ranges are
> > > > > not zapped during tdh_mem_page_add and tdh_mr_extend operations? Would
> > > > > holding KVM MMU read lock during these operations sufficient to avoid
> > > > > having to do this back and forth between TDX and gmem layers?
> > > > I think the problem here is because in kvm_gmem_populate(),
> > > > "__kvm_gmem_get_pfn(), post_populate(), and kvm_gmem_mark_prepared()"
> > > > must be wrapped in filemap invalidate lock (shared or exclusive), right?
> > > >
> > > > Then, in TDX's post_populate() callback, the filemap invalidate lock is held
> > > > again by kvm_tdp_map_page() --> ... ->kvm_gmem_get_pfn().
> > >
> > > I am contesting the need of kvm_gmem_populate path altogether for TDX.
> > > Can you help me understand what problem does kvm_gmem_populate path
> > > help with for TDX?
> > There is a long discussion on the list about this.
> >
> > Basically TDX needs 3 steps for KVM_TDX_INIT_MEM_REGION.
> > 1. Get the PFN
> > 2. map the mirror page table
> > 3. invoking tdh_mem_page_add().
> > Holding filemap invalidation lock around the 3 steps helps ensure that the PFN
> > passed to tdh_mem_page_add() is a valid one.
> 
> Indulge me a bit here. If the above flow is modified as follows, will it work?
> 1. Map the mirror page table
> 2. Hold the read mmu lock
> 3. Get the pfn from mirror page table walk
> 4. Invoke tdh_mem_page_add and mr_extend
> 5. drop the read mmu lock
> 
> If we can solve the initial memory region population this way for TDX
> then at least for TDX:
> 1) Whole kvm_gmem_populate path is avoided
> 2) No modifications needed for the userspace-guest_memfd interaction
> you suggested below.
Thanks. I posted an RFC [1]. We can discuss there :)

[1] https://lore.kernel.org/lkml/20250703062641.3247-1-yan.y.zhao@intel.com/

