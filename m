Return-Path: <kvm+bounces-29908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0376C9B3DFF
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 23:48:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F0F61F2230F
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 22:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCA151EE012;
	Mon, 28 Oct 2024 22:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OIFc6yrf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697B318EFEC;
	Mon, 28 Oct 2024 22:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730155680; cv=fail; b=IkbonPzgQfqtARzIo0PcvuIatwVS4W3Hiy8J0+MNyTaTa/Nv3mlkaWXCpRJOuC3YqVxUidQab1XFA27OZmCItW/fdBu6JLeJnBsXtBziu8ZIyL3Gkm5KyyV0yaoiTdB53LjFuAEHlWStgOus58A+D/CvNDA5NJEAGhwJosdu3pk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730155680; c=relaxed/simple;
	bh=Fsu0a6JrameoJMhD0EiplKnb0nOwGU6vUR4rv+eAGxk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E0WbzDVz4uzEWRlCKKjfE6Z7+OneCuTNmCypLDeg8y9gE3xaw3bc5Y9AmMWGBI8aGZaIs9AVI4YgRvda9Wh8M/eiSKtAl78ewK1XM25XTFakbIw4ptVgaNWkhX8I2I7qCT23v6660LQEYctYPDJupeVSwOQ/27Ps2Q8NDk1uS6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OIFc6yrf; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730155678; x=1761691678;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fsu0a6JrameoJMhD0EiplKnb0nOwGU6vUR4rv+eAGxk=;
  b=OIFc6yrf9DwhEE8zQfzapfP1/GNxypdGd7j3vY/zYiayO1PQNsSf5P9G
   p4LAAGghhCPFVX6Q8EDmlsf5nOha1NuFtceP1kXTqwcQl7upbujihMdER
   2jT+8wPMpgu235yL3fDXVUyuw4nNvd7mK5U3Fc0PngZA5c5qfjdbUu5v0
   gIN2SQYyA0bza7hBnM4fSy4nKIkzcTr+ljRathIC9Vydko1MXjDJp8RV4
   fCFKfIbwCHwEqMLvszjGFUB2bmJweu9Gn7hmt383ZjvYhVm5nMovxP88p
   +JQ0LTlFEpZgYIZRmqmB/9fis5pjNiBVEog/ypytB6BqKhHSZJcQxlFFx
   A==;
X-CSE-ConnectionGUID: mExyudH/Q92/pEEXLFx+3Q==
X-CSE-MsgGUID: sCqRpf/mSSmBJr7lr3DCQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="41170432"
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="41170432"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 15:47:57 -0700
X-CSE-ConnectionGUID: fijGS3PYT+i09d2vxcDtJA==
X-CSE-MsgGUID: y0469/8mQPuVK0ccimobhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="86318605"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 15:47:57 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 15:47:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 15:47:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 15:47:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k1gHFoTgWCyWepiSKm+bS70ThDCdzBVpFdzIZZtcfHPB5lka08OINqivT58P0e+BcpJhvgA5h3tC8r/haCm5q4/q3t5ZNfDGZe8vkmQlbkl2WRGFK+cRrx9Z5PICEpkHQvD9epUQ6w5EH7qtU7lZgJJwKRBzk5QxsiKDScMvaicKW1ZUNQHqpH/92VPVjf8ZFAC/kRJ8ZlVgCmWBrsysBOKBihyncvM9p7yHzObVrsUsUD+o8tFrkdjS4p/AqT+9ZYzyAJQK9kJSMBkZNb2ff08xth++suBuZaDymUrfaEGQZ+BxW2mWGrMu1w37iucJokrvQRCiU7+ZMs+wBQdiug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T1laV8jE7Gz4O/gCJF6Wh0UCD+sspzYFsD/dwhC499k=;
 b=Hmi0TU/IwVcG/oxPnW7OJFuvgLQy+4EVQBWBHaPEexdOc6r6exjNsCHsv3hXZ0orjMfhXnK1juilc26gKa0vpIVvNv5I8JYHRk9s+IUMzr7AH8Q6VCdm0bjV68z3PtozEDjgh9JJdfdGP51vuV6AJv8HAku7xG7iLEb+L53Agz8K+ORhFCZ2siA9LoTXXClBaJNsraUErZE3q/g6iQgVSaSSplKsQgjRaAMgesBeqL92xtgfMFHMUvzEDr1sSEjWk4ZnuMY1aBLuOI/7Q/lc8fvRjnFn6Ks54BD9/iItYT3U8al2FmuM1JhN4a2c/5dWoaC0pKBbEqR9X02ckC08eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by SJ0PR11MB4799.namprd11.prod.outlook.com (2603:10b6:a03:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Mon, 28 Oct
 2024 22:47:53 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad%4]) with mapi id 15.20.8093.021; Mon, 28 Oct 2024
 22:47:53 +0000
Message-ID: <554e098b-f640-4dda-a829-5bcd3f6ea2e2@intel.com>
Date: Tue, 29 Oct 2024 11:47:46 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/10] x86/virt/tdx: Use auto-generated code to read
 global metadata
To: Dan Williams <dan.j.williams@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<adrian.hunter@intel.com>, <nik.borisov@suse.com>
References: <cover.1730118186.git.kai.huang@intel.com>
 <8955c0e6f0ae801a8166c920b669746da037bccd.1730118186.git.kai.huang@intel.com>
 <6720064bf2c69_bc69d2947b@dwillia2-xfh.jf.intel.com.notmuch>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <6720064bf2c69_bc69d2947b@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::22) To PH7PR11MB5983.namprd11.prod.outlook.com
 (2603:10b6:510:1e2::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5983:EE_|SJ0PR11MB4799:EE_
X-MS-Office365-Filtering-Correlation-Id: ce0b357a-38ae-4aba-5e43-08dcf7a28ea9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MXhsTUJJOVlFUkhXaFd1eVRMQzlsa3ZqQlBDQU5Xd20xM1hxSWVVd3ByMi9J?=
 =?utf-8?B?ODhQRE1kTlVGeitsOG85dmNuZnVQcmg2L3ozTVZjYnNsclJGU25RamlDWDZD?=
 =?utf-8?B?UWd1dUp0RVVlWjV5SjVpMVAxOHpoWlZnRkh1bzEvczIzMGtjcURZa2NSY1c2?=
 =?utf-8?B?cmhzVmhtTnlwUFNhRUFEaFMxLzIwZ0NkUDVuWDRQVTJKc2EyTjB4ajV2aS9D?=
 =?utf-8?B?VE9ZS0lFT2V6RFdhVVJ0V1UrTHhDY2djeGFkbkZNZzNBc29pTktqME43UmZ0?=
 =?utf-8?B?YVV4OUFiQTVSRjRWS0FGWnkvdkh1Nml1Y1hYb3Y3a2FOMGkwQktnQTEvdWI3?=
 =?utf-8?B?aU5LZkZwcy9hZEdzclRQSnZBOXNGSGo0c2dFaitaeDMxNExsZjhaY21aNHN1?=
 =?utf-8?B?UnBrSVhxTEMxWVhHaVV3aXZZeUtwQkNqNzVXdld4M2pRbnZsSnAyYklQOVd0?=
 =?utf-8?B?TlNodm1DS0FSeG5FcVhVUXloT3Q2NnRpczlvWVpxVytxZjNuamJ3RHNNWUd1?=
 =?utf-8?B?ektUV0Z3TlpKdHlPNk1YZEVRWnUzM1l6MnZiMGI3RkQwbkZoSjA3Mnd0RDk3?=
 =?utf-8?B?d3Z6VWpMcmpSSThyS2o5eDg4N2VSK21aalpDZnN4d29IWXBNSFp2d0VLZGhn?=
 =?utf-8?B?TUxQbHBRTG95d0tsZDk3ZzZLYXNvdjhDbUpibUpNb1k0cjc1M2VRNVR0NW5P?=
 =?utf-8?B?c2N6K243OE82RWdBeHdhMGY1NzhxOURwSytEMXFmTGx5V2haMzRHMldwZHBx?=
 =?utf-8?B?Rm9rOXJIbVd0MTNZa2o2TXBpMmRkNElnQXN6ZE1OaWQ5ZFlvbG1PTDdnYnpH?=
 =?utf-8?B?WWFSYXJUSXd5bG9YSEovaUtuQmtpcDBqQnFSS2lNOUlrZ2lMY3dsZlhRbjFU?=
 =?utf-8?B?a1RkNjNJOHdDajNhOWZpVjhlZ1FIa0MyZ2VWZEVkeEEzVzU5WHJwVHN2NlAx?=
 =?utf-8?B?Y3BrSmlzb2l2dnIrdkMvNWZZbmRIblo2VG9UR0xzN0hySjNzSFFOQitQdThy?=
 =?utf-8?B?cWNiR084YkowbjRvd2VETitid1BBTTgrMzQ2cnJ4RVJtZUlSbVlqb1VnMUhq?=
 =?utf-8?B?dTcrWjNZamdkd3IrTWU2NWdMUnV5ZnI2ejRlQkFWT0RSZmttY1hVd1BuRlhl?=
 =?utf-8?B?WXFPTmIyT0ErckllVWtaS0VuRlBNMnVuRk0xSlloNjhZa2NUQmltdWQxWDB3?=
 =?utf-8?B?ay9kdjdsOGIxcEpkaWlzTkZzb05WZExHM1k1ZkkvcGZGTEZtanYxZHN4alVK?=
 =?utf-8?B?SkNqdTV1MjBramc0ZWlKOVpkbmNNTkxGMzhhdndnZGNaUDRBMXVJb1FwdXJT?=
 =?utf-8?B?dTFkTTZLdytIMGc1YjEyM2NhYVJROFAvemlKdjAyb0ZmcXFsak5wU2dOT2Ew?=
 =?utf-8?B?dWJBdk44SEt1Yi9qblV6enlFcFRKTlRyNnFhUFRlWkM0RnZ3RCtJM04xM2NL?=
 =?utf-8?B?RmhBZG0vNkFDTDdZTDh5bnQ5M0FxMFF2VVNzL0xJbzk0RFlMTmh5THlVV3VB?=
 =?utf-8?B?dzJHUDljOW53NE1nMGQ3WFJCblYxTytTLy9EQ2w2ZGxMZDBRanZVNEQ0dHN4?=
 =?utf-8?B?S3NRdVd6S3RZREZzUUh3R0Era2UzVU5zVzE4MnFxSXFyMjFiRmQ5eEhoOHph?=
 =?utf-8?B?RWNiZWZuT0k3ZHZiTnNHWCtqS3JsaWc1aHlFUlhqNmlHN3NqVWNoYmhYYTUw?=
 =?utf-8?B?UXFnUE5VQ3ZEb0UwUFNSRVFYNEdQejJIRFF0cm1CdUJjSmhnNE1NMnVzZVcx?=
 =?utf-8?B?REFKb2tqVVJIQjV3YXRrY2lGVE9PVHRzdnRyRWJSV1Z5eEdPSTZDUVZZeWpr?=
 =?utf-8?B?djVDVnJGYnlTb1IzalpQZGt6QlhJTWlXL2FxcVdIelBwc21wL044NzhGcE11?=
 =?utf-8?Q?M4rTBY5IvqaJq?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWJpVld0ZkhOVjUrdU1nUStWOXMrdUF1azdSQStFKysyR3pRNXZQVXovZU51?=
 =?utf-8?B?cGFmSVRncnR6N1BYRmZoTlJNUTkzMWMreU5mZndzeXA3M053bkx2VmtnTlJ0?=
 =?utf-8?B?aU9BKzJqczFzV1c2SUtOMmVoWU5qUlFXNy82WU0vbHY1ck5lQmxROEo4RS82?=
 =?utf-8?B?UGV1aXA5dHRyMElNSnRXS3EzbE42NVZqVVlIVjVIUzJBV05Hd25EbTFiV21N?=
 =?utf-8?B?U09UL3Jsdk1Nb0pjbUUrQ3dHaFNLdlBBTGlTTFU3Q3hyYUYzNEV1ZVpHeU4r?=
 =?utf-8?B?ZnJwWTlvVVJCa1FuYTEzNVlFdVhqUVJxc29UTGZKVFZGV2wyL2wwMGEraFAr?=
 =?utf-8?B?Vm9SVTByTm5aOE1yRUpRdVRpbFRPRndzdURSS05lbnhRQlUxbGFLcHUxUWJJ?=
 =?utf-8?B?NnVPc2ZOVDFQNUNHRlFhaEdEUklrQi9oMU5TR3ZDdDBxZmRkbkdJelpyVkhW?=
 =?utf-8?B?VmJiWnhTTkhrRURJR2ZyVDNKcEk1Y3NnTUZHNmRUNmpkTXZ3d2xXQkVkZGhs?=
 =?utf-8?B?bTIvN0NNZUtUS0NCZmtsRXg4eDdoQ0RkS1pnRFh0S3RyZFhBTTZ0SG50UCtw?=
 =?utf-8?B?c2xraFhVK0NHMjRYalhGQkowdXp3QTYrRUwzR3lvY2FBMXh2T1RlVmgzWHRs?=
 =?utf-8?B?ekc5a1RoZmlVSnhjZXQ0T01NYTJYQkU0cit1Q2JxclJxWE9NMWIwOHVwejNl?=
 =?utf-8?B?b1VSdTZqY3pENXl6SjhEQXU5cm9uMkkvcXZqZElJRzIvVTU1anRLUDlEN0Ew?=
 =?utf-8?B?TnduamNkcE1kUU5qT0JqZGl5dHA5NDFuSm0wL3NTNFlKWEt5U0xRYUZaT2tB?=
 =?utf-8?B?YzBPYTM2QThHWVdJQlZ1QTNONzJXSlFyMVpYcHJrV1pUcHVDRXUyMi9wcVQ4?=
 =?utf-8?B?aUtvS28ySFl3clJzaDJFQTRSd1JscEhsWFBkQkFxV3RyS2hrQ2ZVaEovQWp2?=
 =?utf-8?B?a2djNVhad3lQMHpYZ0hRYVZXeDBOMWVRRG9uS2pjS2lIa1NkbDhlYjJ3cVhw?=
 =?utf-8?B?UWo3a21FNHhocENhNWpDdGdqMHo3RVE1VjhwTFlBZ21XbzZIbzBXQXl6aDEx?=
 =?utf-8?B?ZTVKZWRSVlBHOXRRMW1USUt2YkJZbGNJeWlSM1RwN3FNQkRqUWhnazNxWUND?=
 =?utf-8?B?UzdDWHdkdENJelMxZUFjZVRPTDg4UEl5WDhST2tzUlBxam5tbFZNVmptQi9V?=
 =?utf-8?B?MTBhMlA5V0tSVWcvY040bEViaTJMZjI3c2JzTnpHWmpuKzVGVWxBbUFzaHNN?=
 =?utf-8?B?TDNVTGo1V2cwK1dKK1JDbXFmVTl1ZXloejBreCtTMzBBVjBvNmdpK01nQzhE?=
 =?utf-8?B?RWlGdW9CNUVOVVNURTFON3lZdHk3ZlBML0lKSEh4NkFLU1RDQmx5Q3ZvVmNw?=
 =?utf-8?B?T1BDRTV3UmFIcmQ1NEpCZllZYkxMYVlqZXlxRHpwcWorRFBLTnZtYVhtbTQ3?=
 =?utf-8?B?WmphcFU5ekNTTEFYdlU4OEo5QklDcllmc3BsZEhwUDBPVXFxRnYwUGNEUXha?=
 =?utf-8?B?RmR6NDU3bEtyMHBJWkVYQ1BrNEozQmVTSE1mMGZPRSttTklkc3B2OUh3N1Zk?=
 =?utf-8?B?U0JTbFV6UUtzVTY2M0lkYjBnSi9DaHF6ZlZ2c25pbWVDWDRHWkNzb2dvaFQ0?=
 =?utf-8?B?ZElVTHFDcFhEZ3h1cTNVYTBGQmRFMUpqUDRoQTNIQjZYajRuWkZGNHgvMnlO?=
 =?utf-8?B?TEUxaHFJYjd4dXk5dS9FMEhRRFVUaWtOUjdocVFaUHVQZU1BTkc4SjBiR2h6?=
 =?utf-8?B?R0dmV3VEb1VCblRnSENLQWh0U2ZxZnJwSVNxSzJHME9CR1hEK2VjQjRRUm9r?=
 =?utf-8?B?MWgzMHBISVE5VFI4TWpZMlEvL0FTOTBMWmJxYnJzWVRDT2ZMSm1WdFgzNmhJ?=
 =?utf-8?B?ajNMUnBMUXQvRGIvbnNpc1RuMjVDNnNSU2cza21Sd0NnRTVmV0gzVHJocGcv?=
 =?utf-8?B?WXJ3bDdIMVdYTmNyelBWaTRhK1RtdW14QWl5VmNCM0VMTEZpeU9WT0hOcVEw?=
 =?utf-8?B?TU9GdXhJNVpNcC9rbzlTL1NyS0srVXYyNXZLdXlkbXVhaHFDRWZKVlYvTXlG?=
 =?utf-8?B?ejVLUWpGa2xKdzRreEhKbEN0VmN6QjRPdXZCVndMWUc0Q2xvdHViRHh1V2sy?=
 =?utf-8?Q?YGvKvC8oZ9L2r5I5krCnGcFAq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce0b357a-38ae-4aba-5e43-08dcf7a28ea9
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 22:47:53.1835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wSsOnd6f4ccn0E8WP6dMtcVnlxlDZP65zfALbCSlWqLRnrbZXPerrhN49JEkYo826u1HrN8IcM1guG3IGLrafA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4799
X-OriginatorOrg: intel.com


>>    1) Using the generated C is simple.
>>    2) Adding a field is dirty simple, e.g., the script just pulls the
> 
> Probably meant "dirt simple", but if this is fixed up on apply I'd drop
> the idiom and just say "simple".

Yeah "dirt simple".  I missed this.  Will just say "simple" if a new 
version is needed.

[...]

>>
>> Link: https://lore.kernel.org/lkml/4b3adb59-50ea-419e-ad02-e19e8ca20dee@intel.com/ [1]
>> Link: https://lore.kernel.org/all/fc0e8ab7-86d4-4428-be31-82e1ece6dd21@intel.com/ [2]
>> Link: https://lore.kernel.org/kvm/0853b155ec9aac09c594caa60914ed6ea4dc0a71.camel@intel.com/ [5]
> 
> Just an fyi, that lore accepts the simple:
> 
> https://lore.kernel.org/$msg_id
> 
> ...format, no need to record the list name in the URL (127734e23aed
> ("Documentation: best practices for using Link trailers"))

Thanks for the info.  I got those link by clicking the "permalink" on 
the webpage, and then I just paste.

Yeah "https://lore.kernel.org/$msg_id" works, but if I open the page 
using this format the like is changed to:

   "https://lore.kernel.org/all/$msg_id"

So I thought I just don't bother to remove the "all/lkml/kvm" in the 
link.  I'll change to use the simple format in the future since it is 
said in the Documentation.

> 
>> Link: https://github.com/canonical/tdx/issues/135 [3]
>> Link: https://cdrdv2.intel.com/v1/dl/getContent/795381 [4]
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> Co-developed-by: Kai Huang <kai.huang@intel.com>
>> Signed-off-by: Kai Huang <kai.huang@intel.com>
> 
> Looks good to me, with or without the above nits addressed.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Thanks.  I'll fixup if a new version is needed.


