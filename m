Return-Path: <kvm+bounces-34982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA9FBA08661
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 06:14:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D994B3A64C4
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 05:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15A591E2602;
	Fri, 10 Jan 2025 05:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ax1dzwHI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5B529CE7
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 05:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736486036; cv=fail; b=Z1NVyyCtocnRltQKnCM9AF/4p8YjeEKUmz1e9i0VXHHo/Tp21NaX/Yuyte3ZeRdPe6LQwq0aLIGHxIWopYqdTP7gT/oQHTzVZLj2UdD8cQsTnSx+AmBFskGeMD9VweKWR/ohdot8nmEHcRrearzH53QtSTK/HJ74BPbyRONV938=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736486036; c=relaxed/simple;
	bh=qYoYxElefS0ZWEFS6FJZOh2Zb9l5SsN108QPTC2BUMM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S9f7QkukZ8rGuoxzDfmpdVMrub270iRRNtatOZsj8Y9OYPViZJ3i+PMhfIUIcmn5ayZgh7N/uAQTSID1CzJzxtqSAZjRsGXpwv2QtSplBR4GwvVyPSijBMv0Ccjt6Lb77TGYUA9arWBSlh1l9w900+O3+myPe/yNZYVcUrIajoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ax1dzwHI; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736486034; x=1768022034;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qYoYxElefS0ZWEFS6FJZOh2Zb9l5SsN108QPTC2BUMM=;
  b=ax1dzwHIJKFOdtQu/f5CXrUf6FCYW0+h3C89WeEWCIsHFBiBh1qaKVDE
   nyP7X7wNHZPkfkAtYjgg7Bq7KHkGonGfAB+JLNZmR3Onp9ju6MpEBa1CD
   fNNV8Roa1GBLB3B+RRObA/6DpbAejawkqOxGt4WmtN+HisWz9VBlOI+CB
   qz2ujuMaif1Enmsmz/Wt5QHfNHllwm7yNwNdDKwHQbMTOet2PTRErSTMP
   FT1o9Y2Aao58tKb3AK4pRfeFo8N4w2SryCxxPWhPkM8oHtQ600wxG5fh+
   vwX4W5LP8b46Q84d8Bhds97yHPHAgy5lF3qbpQPYxbH9zcJJJcmRpk9PA
   w==;
X-CSE-ConnectionGUID: synDgfIwS4SaNrqO8t1Sbg==
X-CSE-MsgGUID: VoBzxPY9TeKkRTdt+uku3A==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="47436187"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="47436187"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 21:13:53 -0800
X-CSE-ConnectionGUID: EkHKXEe8RQqHD4ceNuwmhg==
X-CSE-MsgGUID: txSZU37sRqCwrK5ZkcS+ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="104175623"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jan 2025 21:13:53 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 9 Jan 2025 21:13:52 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 9 Jan 2025 21:13:52 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 9 Jan 2025 21:13:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZMLMi1LDHpzA1x8uStbwg8eiJ71ZKOgWkHsBdKbHNJI3cOYm4/tlCgOKue0ao6zfpBBQZXhihOxELw1gVphIAetGSJmGxA40c135iQL40sTyyDnS8/xCAULa+a+38B70GP4deLiaXh6Zjg6xCj9/mJAO+IA8oAsz7AvjK2GXYMFZy4xdIZ2+U7A5PFFQI8sgiOoMf3CQtfrJeVy/SaG61pahSlsyi59Gf+MyXufX8pQVuSb7NeP6u9iPxHFSDV19kyPpCGP73ylaX4mjSKDVInPW3BPQf+gnffGD+SOonrM0AhE2j/in3E+vbZUa0ot9XmX2jge7gJDli0QlFjMdvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XGAnF2B0cMoWCFiHn9SBtZbzK/M+xZ/XCHqvfobj9Zo=;
 b=OVSNt3OpmxFFaJgXJGiezyyMDbyyoF1Sctiu+vXUG8CxyxJxwVqj5oYPpFGZZQwqeSQnfg09naygEQrhqIy6GYbTNqciNxKfo5NLejU29CUS8OjyyulSdGPSkHXMOJvPsNIHiFc9C77b83iZycJclIS8QslRisXSg+u69wieE63mZhvrreB15wU9SGovrC79Lqx3hTwys4rqQ9Kwi65p+SNWqGwpq5AlWVjb48PQnWWneY9Rh5tzZWtXZDyiADCXfheiDOfPi3A/RRN7jdNP573qACQzD27hObRjn1J9pDcqz+oY4UoC81ml4tZZ38RamMCARs7scFDZb0pPmGcx8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 LV8PR11MB8488.namprd11.prod.outlook.com (2603:10b6:408:1e7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.13; Fri, 10 Jan
 2025 05:13:37 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 05:13:37 +0000
Message-ID: <13b85368-46e8-4b82-b517-01ecc87af00e@intel.com>
Date: Fri, 10 Jan 2025 13:13:28 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] memory: Register the RamDiscardManager instance upon
 guest_memfd creation
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-6-chenyi.qiang@intel.com>
 <2582a187-fa16-427b-a925-2ac564848a69@amd.com>
 <5c999e10-772b-4ece-9eed-4d082712b570@intel.com>
 <09b82b7f-7dec-4dd9-bfc0-707f4af23161@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <09b82b7f-7dec-4dd9-bfc0-707f4af23161@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0169.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::25) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|LV8PR11MB8488:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ab41eef-e725-41e5-c329-08dd313589d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Ly9VTFBjM2RGR1d5djl1Q3JGRklrZitCTWpIcTgvVEZGbWRWZkw0NG5EczZo?=
 =?utf-8?B?VlpCMExydExGUzE5K1YyVGdGMlpKa0ZNTm44ZGxVL1NJRGM1UDdaMitHa1lx?=
 =?utf-8?B?RXVrN0RkZmpnQk40SzlMWFBnUnh4Z3RacUhsMi9Ydlo5UGNoc2hseVJUeDhr?=
 =?utf-8?B?RllBM3hIN2VtWHBtM0RvVVRzd1ppclRkeE1IczIydFduT2ZZNzVMSXlwc1dJ?=
 =?utf-8?B?L1hrOGhKZURBMHVTakNLQ0tOQ3BISHQ0MHJMU0RHdlNiZUpIQTI1MkE0T1c2?=
 =?utf-8?B?N2RoUnlVdEUrS1JjWTZNbnY5Y0NMYjV6RnRhMmxJQzl1MWdRMDZMR0VzQ1BP?=
 =?utf-8?B?ZEhyd0pKbVQ1VHErMjZwdzA2cUQrbGVkZG1YN0JjNmNlWWcxaVR3Q2VuZnJy?=
 =?utf-8?B?Vkx2V2VKaUdYbHpXQVgwWTFqaWpCTmIxV0R4NmkvZ0NIdTVqbmdsdGdNWFhK?=
 =?utf-8?B?RHdhdFNKcmVaNEpBaGpZMS9kRVZUd283ajBhK2ZhSWo4SFY5UkFLeWhubURz?=
 =?utf-8?B?cUZoZW9sSGRMSDNzYWgvc0h1cmt2U0lwK2NoMXlza1VzSU0vNndhSVU3K3Iz?=
 =?utf-8?B?RGF6akphdXZWYmZ2bkZ0U0d1Ykh2bGZYR2lkOHNTamN5UFhUR2U3cEt5TzFL?=
 =?utf-8?B?RWtSSktnNSt3TUZLd2FVVEcwTDR2SXpQM1NTZTlxZDZSVTNwSVUwV2ZSa2tM?=
 =?utf-8?B?eFo1a2xDRTRpa1prZHJ6bUx1anpIYTZobnljbVE0ZzdZVDFSRUJiT3VwM05a?=
 =?utf-8?B?QTFoNHhFeVZkRjRPZmljQWVzcUtUZGtueWtVS2NXRU5UWkxTU283VWQyMFhp?=
 =?utf-8?B?N083Z1RMK3Z1L2RTRmhVV25yRWFXSHBVOXN4ZWhQQjd5bC93azI5WFA1VWhi?=
 =?utf-8?B?SUVTdE91RUVwT2NCRjFwNkhKaEovT3Y3dWFDMGM5bjh5TkpCcjBwZFNDZ0pa?=
 =?utf-8?B?WUNNL0ErLzhES3k0WHBiK3VYNnhMTEJoVUNWYmNSM1JGU2JwMk1qZDBtUXg5?=
 =?utf-8?B?N0RocHVPb2ovbHlrdlBVNmcwQ1JRdm5CYW9FS3ZiZlhVa0NZS3dDc3JFQWlx?=
 =?utf-8?B?S1VVSEJEbTZUQ3JpNEwyWmVTcDhoZmk0ZTJjWll6YjdwWmRNMWcwR2xSSm9Q?=
 =?utf-8?B?SDFnRFhMWEJraDNMWW9NTjVxczFuRFJHUjYyQ3lSZnlNalpXb2YxdG1SVHRx?=
 =?utf-8?B?UUFlRDc0RlRYa1pIcWNwT0dTL1NRdHp0MC9xYVZ5UnhqYVJuTUpOSWFlTWZC?=
 =?utf-8?B?Ynhib280bVkwRGJaNlkxOFRQdXpNNkpybnVqSVNMNjVzZzcvY2xwelJCcDNx?=
 =?utf-8?B?UXhsM3VTN1NUUDZMY1dBdm9oK3VUNjV0eERuQlRLWS9HWmJNWStVSm4rRGFx?=
 =?utf-8?B?RTNKL3ZENmt5SUpwdDh2d25kQXF4SHhvSjNvRTUxSzNVS1RqaXB4SW1hc1Zs?=
 =?utf-8?B?bUlRRndCYVYvbi9NTElkSlFESUhsaUhpemtHL0FVUE5ZVEJhQVEweHZlMHFL?=
 =?utf-8?B?VHRxazcwV1pPZmxYcnNNVDJ0WkR1ekJ5d3ZYM0FwVUhzMjB1c3hhR0VnMFNN?=
 =?utf-8?B?b0JhWWV5TnVnbFdsNlFoZEUzMWJiZERqanQ5ak1qRUFIRnNTM1J6SjBmYitN?=
 =?utf-8?B?WXNsZnBrazN6azlwQ05oUnZpVElWdm16Q1ZMQnN1bkREaUxadnhMKzVHZTJs?=
 =?utf-8?B?VUNna0hHUHNCR0ZSaDRpU09rMFIvTjJobGRLRGpiYjY0WjJVOUJtUDc3VWlo?=
 =?utf-8?B?L2Y0VHFqaDFqUFZJZDBkVnFzQ0MyTzl0bmJzZGI3N2llbEJPOFp2bURqUTJ1?=
 =?utf-8?B?Z2o2RzF1M2VjZFppVHZOYjJ4c3lFZjVQUnVNZWdrNWgyV3hrZjlMc3p1R0FU?=
 =?utf-8?Q?ee7OhTj2KZg6P?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWdPdHowRVdkaVhMeXptelljVXdHVDZRTWdLZmcxRkRTMW1tZUcrUVZoOXlX?=
 =?utf-8?B?U2xlekhtM1MzeVZFNysvMmZVM0JmVUh4cCtLbnBwejFCVUQ0bDMzVnNZOHo0?=
 =?utf-8?B?T2xEQjVFaCthM21sZ3NMMWtOc0UrNElRTTJwY3c0U0swSUFYWEQxeC9xSmpP?=
 =?utf-8?B?Y0NTYjBPRy9yR3RYeXZHdU0zMUU0YUk1OU1zajNjdDAvRXloc1l6WFVmN3dO?=
 =?utf-8?B?THdjRGxZRXd2S3ZqeGIrUFhpRzlaWGJWbzFWS3hDUE9lSnc5dFAvZFlzclpN?=
 =?utf-8?B?MkpCMmlBME5PYmJCYWtZTWtEN2JjZFcxVGthaFA0SWhRNHJ3MnZOSlBuRWY5?=
 =?utf-8?B?U3dMSThsV1dFL1BrZmdNRlVvajgvYUhHSUtLUGkzbzRIQ1VlSHZOYW9OVXJn?=
 =?utf-8?B?cXpiMzh3QzJ4WXVKT29SWVN1OWRsc2o4cEhFY0xzbEdYUFphckk4SnZYdG04?=
 =?utf-8?B?Wmx4empRS2MyKzJVYXpsRll1UHdTYzhMRzkwRkJ6OHhqV0J0RXZRT2t3d0wx?=
 =?utf-8?B?SjBEbXZLR1RJSzVEcml1QVo5aWhIWlIwYTFYTkRBbHJjTnBmTlJ4dHFtb3ND?=
 =?utf-8?B?VUd5OFV4SmtQeDgyL2ZPazhvN3VzOTFNTGt6NEtHQmxuYVZ5WEZLNXVFU3BP?=
 =?utf-8?B?dm55OXJUWUljVWpBRS92bDRVSzJMQXJaamlqRHZyejl3T0N3UTJsTXBaUlJT?=
 =?utf-8?B?QVV5Z2NQNWVDaVdVZkR0dFdlTnkxTHVLdFBLM055MUpQci84bUxrR2RUa0hv?=
 =?utf-8?B?by9nczRmQ0M4MGJWdGdpOUFrK3hCN0xLN0JzMWhqazMyWkNlbWN3WGw5NDlu?=
 =?utf-8?B?Wjg5SFF2dEd1REhLclFvaG9PS1cvVk5aeWhTd1FmMUFoU1ducUpZTjdOd1d5?=
 =?utf-8?B?czM3VFFaUlM0Nis4WlZYOHZmUGt3M1EwYVByb0xreVBjTlNpM1kyemFLM3Yv?=
 =?utf-8?B?WEhxZmwwTnp6MW45TFZlWDZJRjBSVFJYbnNMWHJ1UU5ydS9MMGlWelhnUzNG?=
 =?utf-8?B?K3h6cE9ESUZFM2V5L0c2OFluNW9IMzBYMFdFUEN4QlFwdE1WQ05FQTJaamVi?=
 =?utf-8?B?TXBQWmt0Qm9nS2RwVEw5azkxQmRwQk52TkN1ZE40WEUxa2lYSWlvSDNOdEZL?=
 =?utf-8?B?bW9FeDZlM2l2VDdjT3NYRWZDTTVLRzNKOXBZdkZWRXdjc2FtRUNxNjJDUjM4?=
 =?utf-8?B?VXBqQ2RQdHY1UWFyNjA1bm4vQ1pCQ3QxT1RGUk01YTdiZndoSUw0SytFRFBL?=
 =?utf-8?B?SzNwVlJhRmNZK25QbnVkeGI2d2UzbmU2bkhwR1ZBQTdGSzNwQnFoZWdUSmlr?=
 =?utf-8?B?TCtoellaLzYwNm5LQWRoM2VIYThpUWU4Zkk2VENqM1htOFRWWXBhTWw3NEtl?=
 =?utf-8?B?NDQzUnVUQzg0SzNuTlFWTXdHNk1jRVJQZkdncmpKaDg3RVJUbFNRclR1NW9q?=
 =?utf-8?B?Qms2Sjl5RE9BVEZCTHA1K2ZSam1zTTA5VHBaYTJwRHltdGxRYzR5aHpjeVBi?=
 =?utf-8?B?dkdiQ1dCNU5COFlGUzc3QlZWK3JnU2pkRWpGeE1Eb0M3WkliSHBPQzRyeGNH?=
 =?utf-8?B?MnFubUZGQk40dnp4M2RSeTNNTnVKOUJpaWx3eEU3N2hac2srLzBlZ0xZYlpl?=
 =?utf-8?B?SHYzd29uMnRWODhmZlh2cGxuLzFCSUFyMGF4Y0psWDlTMWJhQ1ZWMU1IcUs5?=
 =?utf-8?B?NFJ1VFc5ajA1a0pld1hXa0xzeXRhN1cwb1FyUlJIRmh6UzJIMU5ISnFpZUk4?=
 =?utf-8?B?Z1NHRVFWdlduVjRuV0VQc0JwdW9vTGgrWUdRQnUrV3I4L3JOcXNTT3dOQ3A1?=
 =?utf-8?B?cEdyVzRNV3c4OEF2VFRRT1JDU29XbVdaOE9KbWxZanFUZCtrTmNxSmU1MDVC?=
 =?utf-8?B?VlhtR2xMVklubjBOMHJ0THluRzY1MEtRVzFhRjlRNWtMSkhFMWdndzlhMzVv?=
 =?utf-8?B?b09RVkZPRkQ1d0Vub2VuYStETUFkcmp1Qzg5ODVSVllMTVZ0WHkyTXRzOEhw?=
 =?utf-8?B?NXlmWXVOZzJtZTV1TU4zNGJJVTNqd05XZHpkRXJndmswVTB2aVJXdUZRSGJt?=
 =?utf-8?B?MzFtcDdjcHdRNnhwVDRsV0VoeGNjUmRRS2hjblFTM2kxQmdlc3VmcEtBQ2Nr?=
 =?utf-8?B?RUg1ODVYK0pXZ0ZRWEtlQVR2K1BJRFV5Y2VtSEE1U3RFbEozQ3E4Z1B1d3BC?=
 =?utf-8?B?UWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab41eef-e725-41e5-c329-08dd313589d1
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 05:13:37.2950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GJBVVRg8i7erptRdVsNxW6aZOi78Z7UA3wT6ojLe3SgQfCeKr9MCUweuJ55a6a0pJBUybE3Cg2duVIbJKw/RNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8488
X-OriginatorOrg: intel.com



On 1/9/2025 5:32 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 9/1/25 16:34, Chenyi Qiang wrote:
>>
>>
>> On 1/8/2025 12:47 PM, Alexey Kardashevskiy wrote:
>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>> Introduce the realize()/unrealize() callbacks to initialize/
>>>> uninitialize
>>>> the new guest_memfd_manager object and register/unregister it in the
>>>> target MemoryRegion.
>>>>
>>>> Guest_memfd was initially set to shared until the commit bd3bcf6962
>>>> ("kvm/memory: Make memory type private by default if it has guest memfd
>>>> backend"). To align with this change, the default state in
>>>> guest_memfd_manager is set to private. (The bitmap is cleared to 0).
>>>> Additionally, setting the default to private can also reduce the
>>>> overhead of mapping shared pages into IOMMU by VFIO during the bootup
>>>> stage.
>>>>
>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>> ---
>>>>    include/sysemu/guest-memfd-manager.h | 27 +++++++++++++++++++++++
>>>> ++++
>>>>    system/guest-memfd-manager.c         | 28 +++++++++++++++++++++++
>>>> ++++-
>>>>    system/physmem.c                     |  7 +++++++
>>>>    3 files changed, 61 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/
>>>> guest-memfd-manager.h
>>>> index 9dc4e0346d..d1e7f698e8 100644
>>>> --- a/include/sysemu/guest-memfd-manager.h
>>>> +++ b/include/sysemu/guest-memfd-manager.h
>>>> @@ -42,6 +42,8 @@ struct GuestMemfdManager {
>>>>    struct GuestMemfdManagerClass {
>>>>        ObjectClass parent_class;
>>>>    +    void (*realize)(GuestMemfdManager *gmm, MemoryRegion *mr,
>>>> uint64_t region_size);
>>>> +    void (*unrealize)(GuestMemfdManager *gmm);
>>>>        int (*state_change)(GuestMemfdManager *gmm, uint64_t offset,
>>>> uint64_t size,
>>>>                            bool shared_to_private);
>>>>    };
>>>> @@ -61,4 +63,29 @@ static inline int
>>>> guest_memfd_manager_state_change(GuestMemfdManager *gmm, uint6
>>>>        return 0;
>>>>    }
>>>>    +static inline void guest_memfd_manager_realize(GuestMemfdManager
>>>> *gmm,
>>>> +                                              MemoryRegion *mr,
>>>> uint64_t region_size)
>>>> +{
>>>> +    GuestMemfdManagerClass *klass;
>>>> +
>>>> +    g_assert(gmm);
>>>> +    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
>>>> +
>>>> +    if (klass->realize) {
>>>> +        klass->realize(gmm, mr, region_size);
>>>
>>> Ditch realize() hook and call guest_memfd_manager_realizefn() directly?
>>> Not clear why these new hooks are needed.
>>
>>>
>>>> +    }
>>>> +}
>>>> +
>>>> +static inline void guest_memfd_manager_unrealize(GuestMemfdManager
>>>> *gmm)
>>>> +{
>>>> +    GuestMemfdManagerClass *klass;
>>>> +
>>>> +    g_assert(gmm);
>>>> +    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
>>>> +
>>>> +    if (klass->unrealize) {
>>>> +        klass->unrealize(gmm);
>>>> +    }
>>>> +}
>>>
>>> guest_memfd_manager_unrealizefn()?
>>
>> Agree. Adding these wrappers seem unnecessary.
>>
>>>
>>>
>>>> +
>>>>    #endif
>>>> diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-
>>>> manager.c
>>>> index 6601df5f3f..b6a32f0bfb 100644
>>>> --- a/system/guest-memfd-manager.c
>>>> +++ b/system/guest-memfd-manager.c
>>>> @@ -366,6 +366,31 @@ static int
>>>> guest_memfd_state_change(GuestMemfdManager *gmm, uint64_t offset,
>>>>        return ret;
>>>>    }
>>>>    +static void guest_memfd_manager_realizefn(GuestMemfdManager *gmm,
>>>> MemoryRegion *mr,
>>>> +                                          uint64_t region_size)
>>>> +{
>>>> +    uint64_t bitmap_size;
>>>> +
>>>> +    gmm->block_size = qemu_real_host_page_size();
>>>> +    bitmap_size = ROUND_UP(region_size, gmm->block_size) / gmm-
>>>>> block_size;
>>>
>>> imho unaligned region_size should be an assert.
>>
>> There's no guarantee the region_size of the MemoryRegion is PAGE_SIZE
>> aligned. So the ROUND_UP() is more appropriate.
> 
> It is all about DMA so the smallest you can map is PAGE_SIZE so even if
> you round up here, it is likely going to fail to DMA-map later anyway
> (or not?).

Checked the handling of VFIO, if the size is less than PAGE_SIZE, it
will just return and won't do DMA-map.

Here is a different thing. It tries to calculate the bitmap_size. The
bitmap is used to track the private/shared status of the page. So if the
size is less than PAGE_SIZE, we still use the one bit to track this
small-size range.

> 
> 
>>>> +
>>>> +    gmm->mr = mr;
>>>> +    gmm->bitmap_size = bitmap_size;
>>>> +    gmm->bitmap = bitmap_new(bitmap_size);
>>>> +
>>>> +    memory_region_set_ram_discard_manager(gmm->mr,
>>>> RAM_DISCARD_MANAGER(gmm));
>>>> +}
>>>
>>> This belongs to 2/7.
>>>
>>>> +
>>>> +static void guest_memfd_manager_unrealizefn(GuestMemfdManager *gmm)
>>>> +{
>>>> +    memory_region_set_ram_discard_manager(gmm->mr, NULL);
>>>> +
>>>> +    g_free(gmm->bitmap);
>>>> +    gmm->bitmap = NULL;
>>>> +    gmm->bitmap_size = 0;
>>>> +    gmm->mr = NULL;
>>>
>>> @gmm is being destroyed here, why bother zeroing?
>>
>> OK, will remove it.
>>
>>>
>>>> +}
>>>> +
>>>
>>> This function belongs to 2/7.
>>
>> Will move both realizefn() and unrealizefn().
> 
> Yes.
> 
> 
>>>
>>>>    static void guest_memfd_manager_init(Object *obj)
>>>>    {
>>>>        GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
>>>> @@ -375,7 +400,6 @@ static void guest_memfd_manager_init(Object *obj)
>>>>      static void guest_memfd_manager_finalize(Object *obj)
>>>>    {
>>>> -    g_free(GUEST_MEMFD_MANAGER(obj)->bitmap);
>>>>    }
>>>>      static void guest_memfd_manager_class_init(ObjectClass *oc, void
>>>> *data)
>>>> @@ -384,6 +408,8 @@ static void
>>>> guest_memfd_manager_class_init(ObjectClass *oc, void *data)
>>>>        RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>>>>          gmmc->state_change = guest_memfd_state_change;
>>>> +    gmmc->realize = guest_memfd_manager_realizefn;
>>>> +    gmmc->unrealize = guest_memfd_manager_unrealizefn;
>>>>          rdmc->get_min_granularity =
>>>> guest_memfd_rdm_get_min_granularity;
>>>>        rdmc->register_listener = guest_memfd_rdm_register_listener;
>>>> diff --git a/system/physmem.c b/system/physmem.c
>>>> index dc1db3a384..532182a6dd 100644
>>>> --- a/system/physmem.c
>>>> +++ b/system/physmem.c
>>>> @@ -53,6 +53,7 @@
>>>>    #include "sysemu/hostmem.h"
>>>>    #include "sysemu/hw_accel.h"
>>>>    #include "sysemu/xen-mapcache.h"
>>>> +#include "sysemu/guest-memfd-manager.h"
>>>>    #include "trace.h"
>>>>      #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
>>>> @@ -1885,6 +1886,9 @@ static void ram_block_add(RAMBlock *new_block,
>>>> Error **errp)
>>>>                qemu_mutex_unlock_ramlist();
>>>>                goto out_free;
>>>>            }
>>>> +
>>>> +        GuestMemfdManager *gmm =
>>>> GUEST_MEMFD_MANAGER(object_new(TYPE_GUEST_MEMFD_MANAGER));
>>>> +        guest_memfd_manager_realize(gmm, new_block->mr, new_block-
>>>>> mr->size);
>>>
>>> Wow. Quite invasive.
>>
>> Yeah... It creates a manager object no matter whether the user wants to
>> us    e shared passthru or not. We assume some fields like private/shared
>> bitmap may also be helpful in other scenario for future usage, and if no
>> passthru device, the listener would just return, so it is acceptable.
> 
> Explain these other scenarios in the commit log please as otherwise
> making this an interface of HostMemoryBackendMemfd looks way cleaner.
> Thanks,

Thanks for the suggestion. Until now, I think making this an interface
of HostMemoryBackend is cleaner. The potential future usage for
non-HostMemoryBackend guest_memfd-backed memory region I can think of is
the the TEE I/O for iommufd P2P support? when it tries to initialize RAM
device memory region with the attribute of shared/private. But I think
it would be a long term story and we are not sure what it will be like
in future.

> 
>>>
>>>>        }
>>>>          ram_size = (new_block->offset + new_block->max_length) >>
>>>> TARGET_PAGE_BITS;
>>>> @@ -2139,6 +2143,9 @@ static void reclaim_ramblock(RAMBlock *block)
>>>>          if (block->guest_memfd >= 0) {
>>>>            close(block->guest_memfd);
>>>> +        GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(block->mr->rdm);
>>>> +        guest_memfd_manager_unrealize(gmm);
>>>> +        object_unref(OBJECT(gmm));
>>>
>>> Likely don't matter but I'd do the cleanup before close() or do block-
>>>> guest_memfd=-1 before the cleanup. Thanks,
>>>
>>>
>>>>            ram_block_discard_require(false);
>>>>        }
>>>>    
>>>
>>
> 


