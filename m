Return-Path: <kvm+bounces-56951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA51AB4691F
	for <lists+kvm@lfdr.de>; Sat,  6 Sep 2025 06:50:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61F265C57DF
	for <lists+kvm@lfdr.de>; Sat,  6 Sep 2025 04:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A629D279DB0;
	Sat,  6 Sep 2025 04:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XNNlRGaS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C69B277CBA;
	Sat,  6 Sep 2025 04:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757134234; cv=fail; b=IDDysVEWWj4CoYSR+N2p76B6nAcVaztLd+uNgIHmfLfgylNvCcwDE9bfDWnUEmLqnQMUYfqG3rQ2oxAocb8aiN6bX6RHFchp8E6H21TbpkeCD/4I/ghGctU97Hr2kxRBdikJtjjTTx5YWAXuiSTk+DW09BZkHZv96knJjGCJXHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757134234; c=relaxed/simple;
	bh=Uqgootvlb4JATFxfxBuBKL3ygNT5zg8i8dlQP6TDRNs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LrOUJ7q0uiE7l0IWMBX2ABIPeJfBpwoksf0NKM57FVQCgb4vbosDcnLgh112W5ohIbszMwjJZJryvRr6eOXaFYOL+hp5a4JqFwI6m6HkR2CwWXZxqQkTGAtY1tz2BhO0CmBuNBoUNveLpoP1+7CCgXe6bb2HHxPSHfyTbm32C1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XNNlRGaS; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757134233; x=1788670233;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Uqgootvlb4JATFxfxBuBKL3ygNT5zg8i8dlQP6TDRNs=;
  b=XNNlRGaSfCz9/oYQ3u0+oobK3oM0sRN69KP8lzliOkTogtHoYizyPR2U
   A3+P1mY9J+wNYwbCjIVss7zYjFdHeBSh/nek4+Glru6Rbo7gn0FcAq8xn
   RkeSR0lMeFEy/FCNP6PW0Nb1bwScPD/yD7EETzP5LC8+AbcahC76i5sK9
   b1YqrekI+8FJS0Gn7WhQxzQhmuKUa3NIoDIyPWFfrBHxn/4/n8RyaItUu
   z972jya9JBAKM10gY6E4Qf7NJ136Jgbiu9bmyItXJE4uyQCPn8KcqiC6d
   0k8x361vdXXl+frFk1oap4nNxew+oDl3HSgNYbXWz/Fj4noSRs/Oxsobt
   g==;
X-CSE-ConnectionGUID: dohtGST+RtKpUIbXniyUPQ==
X-CSE-MsgGUID: ry82469SQYW1Os1n1bt39Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59548577"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59548577"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 21:50:33 -0700
X-CSE-ConnectionGUID: MlOELorPQOqW5EG695U8Lg==
X-CSE-MsgGUID: BTDzgbZyRcaR1m3UKRUmDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,243,1751266800"; 
   d="scan'208";a="176654988"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 21:50:32 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 21:50:31 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 5 Sep 2025 21:50:31 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.56)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 21:50:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ikGSJi8OonsySdNwXGbI8rA1HzWqQ0PTrkBUZ8H554n7bV99MkD8RZihAZK/lUereLj1Fo8r6b+J0/Gc2EeO6PoxbW9COpT7zYb3H3r1/3m1DK5hcXnh8DO/81X5wREAF19fmAobViRKplmtdfHHZpDVTiCAcQinN8Z/GUarN8Mjb7lJBXiwQ2of85pdcbLnyMSnn3Jjql6l+KqSx1AT+DooFyqnmkAOWQx/+loGb4GMj6N4LrYmeMXxrXnH3ZT6+5toMUJfuXWUcmu8nCH+wSKFlrA2C7dVFu951nTDnWS8/CvQRyXoy0X92T80iR3tkOr0X9RJTuSTS1TuQTt5iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uqgootvlb4JATFxfxBuBKL3ygNT5zg8i8dlQP6TDRNs=;
 b=Du1DGBebB4e7laQtOXK0AMvsuppUUDhpX1l10yCuFar3ZImO1fGhTh5mN16bWEIAvVwW0VZjrAH0AQL/w1W7OIqd1qd/1VJsGav6bRK7szCv7fbmy7owWpkhiLiSMMrJyDaL+DKjJ373AEnhNPkCRDwKzacXOoorxFoHE72mX2RmoCRSbvBBwfWKW1bCi2l/7SqlwNB8reBd9xEyZJ+iEgp0gTIKoXlUGADlKCbJTkfcK5fTFAedkJOayyzhhpQi47NFWkcXvhUCY6JbeTho58l9YZSSKf6K6r9msVQozVUJNjzyC5BXIXeGv2kcSlIncALtCgEwPVx4/or254FbnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPF46B98A11D.namprd11.prod.outlook.com (2603:10b6:f:fc02::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Sat, 6 Sep
 2025 04:50:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.016; Sat, 6 Sep 2025
 04:50:28 +0000
Message-ID: <e892b955-fdbf-4f5e-bcd7-c566ab747c54@intel.com>
Date: Fri, 5 Sep 2025 21:50:25 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 29/33] fs/resctrl: Introduce the interface to modify
 assignments in a group
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <frederic@kernel.org>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>,
	<pawan.kumar.gupta@linux.intel.com>, <perry.yuan@amd.com>,
	<manali.shukla@amd.com>, <sohil.mehta@intel.com>, <xin@zytor.com>,
	<Neeraj.Upadhyay@amd.com>, <peterz@infradead.org>, <tiala@microsoft.com>,
	<mario.limonciello@amd.com>, <dapeng1.mi@linux.intel.com>,
	<michael.roth@amd.com>, <chang.seok.bae@intel.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<peternewman@google.com>, <eranian@google.com>, <gautham.shenoy@amd.com>
References: <cover.1757108044.git.babu.moger@amd.com>
 <b894ad853e6757d40da1469bf9fca4c64684df65.1757108044.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <b894ad853e6757d40da1469bf9fca4c64684df65.1757108044.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR2101CA0007.namprd21.prod.outlook.com
 (2603:10b6:302:1::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPF46B98A11D:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c4f4923-a7ff-4c7c-d2d8-08dded00e6eb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aGNoQXA0aHVrd1B5SHJoU2xMRlo2NUhEQXhoNmpZNEErbG50ZFBxYWFpMXVa?=
 =?utf-8?B?MW42aUFiUEU3OHJ5RW9SdkNkVEdZUTRRVHQ3VGJRQWdVVDFsNnEzZU4vaWcw?=
 =?utf-8?B?Z1VFYUw0L2lRYWt2K0h6MjlHU0Y5YXJGZDlYa1gwbE1OWkVkQzk5blQxdmRV?=
 =?utf-8?B?enBhS0pxQkV1TVdENEh3MmpRVVJrUHJIOGZhbndFVXd4a2U5Nm1SaWkzeTFi?=
 =?utf-8?B?SVY5cnZFazRZWEJiQUVYNXp6RTNISDhTZGEraHFRTmYvVkNUV2N3YzZtTGxK?=
 =?utf-8?B?bWVJYzVUcENDUlJpTFM4S2pHc01BSk84NHpzalZYZzN1UkM1b1ZwQ3BFNktM?=
 =?utf-8?B?MGFMTEo2bmR4RnQvQ3NHLzFTdCtQV2dIc1RxMS9aKzhXbG1pdkZ1SlRvRzFk?=
 =?utf-8?B?eGZmai9QTStFdW5EajBSNDUxVTJCVisrNlNlS3hrS2ZVdnlxenhaMmF3anlQ?=
 =?utf-8?B?dnVUUnV5cTFKUTRjQzk4UlI1KzJnRDBJZGYyU2NhdVgyaXV5MlAwMUt4Ykxj?=
 =?utf-8?B?TkYzZys3OFFwblFyZENoWnVSWEZEenlMWjV2YlpkNWVOeTc1dDUvZ0xhRXFo?=
 =?utf-8?B?VDVwUjNWUnp2TjdVMmkvSllwVGtDK29waDNNTnlIaENRYk5FRVliZ0VNT0hm?=
 =?utf-8?B?a2p5VjJaOVRKRHNxSGNpbUtxcU00T0hYVEFiMWs4T2QyKzM0QlNmWnEvVE1Z?=
 =?utf-8?B?TXZtN1Q1Szk4c1FWaFFOS2F5SjVzbm1oa2QxV2pVMWJGcDlOTVRlc0JwSmFQ?=
 =?utf-8?B?eHIvajNEVmRrZVJSZEwrZWJVeG41cXROc3doUm5HYmd0M3VycEM3SFg0c1BV?=
 =?utf-8?B?eEJXazJsdUJqcGlpRTU5NWxKUTNxRjEvQUZLc1V4cGlReFJxMUNhdUFzUjRt?=
 =?utf-8?B?WHJpb1VzRWNZS2FCRENFdXRwaVQxL2JlZWo5OVRtcE1DcTl1dllFRmhTRGRU?=
 =?utf-8?B?dFpTUHNUaDBPNjNuTjNmUXdwdDVuQWVwUkpWMUFpZXRRdEVxcVJRK0xIeUc1?=
 =?utf-8?B?ek8zaDQ2d3BCUWdBYWM2bFZtWUJyN2IxRzQ5R0JuRXBjODNqMUwzYmJHY3lu?=
 =?utf-8?B?Tlo3Z3Z0dHU2NG9jUDROamFIZndyYWNTZkhMaVNiRDZ2VVNLbm5Ea1h4eExt?=
 =?utf-8?B?c1RkNkxZY1VSZlhJT0NLdWduUWg0YlV3aDZxait4Snp5VUthQ3NUOW0wcVpC?=
 =?utf-8?B?MkxObVd1eHhRd3MrbWFja3Q3em4rcHBxYzBYVVdmaHVsUy9Rd3VJTXVJaTFT?=
 =?utf-8?B?bnRBOTNXdWhSQVNXQ0VqRkVVY1hNQlVXbElEV1Y1a0pwRUhLNm5xWGVOeXpa?=
 =?utf-8?B?d3hmeDdWakR5Wi9zZGhJSVdGZnNXbjBlc21mcjVVOENpR3BnbjlrZDZvV05s?=
 =?utf-8?B?REFpOXFhRlZsb2drby90aVVFb1hWQlFyWUtkN2VoUkVZNG1BMVJ3QWpKZEhx?=
 =?utf-8?B?dGZJck1tSW96VFNRNUpYQUlPSUN6Z1NmTVZQRFJTVXZvaEtjb3U4V2pGRzV5?=
 =?utf-8?B?Vjh6QnprM1pMaUZjWmthdzdPbDZmWVFjVlI4NU9uUmZGMmprQTVxTXZDTnRu?=
 =?utf-8?B?Z244WkRBaVYraFpIK0JtNzArbk16WW9XdmRsL0ZnTUR3eWpidXprV2tqelo3?=
 =?utf-8?B?VnhWanJHSzVnS0dUU2JnbG9FNUcxcW1XM0duK1Z2N2tEekZBdFczTWt1amdC?=
 =?utf-8?B?eGp0VjBrS1JzL3dpeTFJV3kzTmdQYmtVdzVLMyt1aUs5cjAzcCtpWklxVnRr?=
 =?utf-8?B?REN6YmFGZzIvUVp4YzNzNHEzUkkvM3JjYUFRNklFcjErSEoyaklZM1pkRzNw?=
 =?utf-8?B?Q0FtdC9xcVZ5OUhtUkxKNS9LcGo4U3hSSmNOZDJ0Rm0yT1JudDdsaGdtcTRM?=
 =?utf-8?B?WnM3Y0tUTm9CRjBVMEVuMmY1eWZKODN6Y0tzZ1p3UHV4ajlrbjhJcE5uemh1?=
 =?utf-8?Q?6P2Gkqpx49U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVo2TGozdzhjK2lENlRPbzJHNWxNMiszMUJaZHdMQTFBY2lGemUyR1Y5L1dK?=
 =?utf-8?B?eDVCQzlnWVY2TjBDZG42SHZQeEtIZnJCdGhwdzhjbzJGVEFwRW51aktJWWJp?=
 =?utf-8?B?S0FTL0dWMDBycnlmNGUwVUplZEphbnhoSHNlREE3aDFIRWd3ZnBaUjIxdUh4?=
 =?utf-8?B?L1hDYTZvbTh5RFZlaEw3MGh3YlRRT0RTdHZmeTh4b242VWdtRzFEemxjbVpm?=
 =?utf-8?B?TEdjdnBkY2x0bFVqSW1IMGxYcDNGRTB5TDlncTRlck10MXZLTnRjZjd5UXZX?=
 =?utf-8?B?Y3FHbktZcWxkN1pZU05tWGZuY3l6dGxZUUZ3ZGR1bTZNUzVHWkxZOE80Ymow?=
 =?utf-8?B?UVRJQzM1V1FiVDdlTlJGNE1PRmx2bGI4K28vWXJvbkozT1UveXZDUnBFSHJ1?=
 =?utf-8?B?UzJzODlPaFNod28xR3grRnUzMGZzT0FLdFBVWDFVcU5xa3NMOGxjV0ZxQWpu?=
 =?utf-8?B?ditYeDhpMk4vY0JGdTg2NjF5UmhUV2xZaVE2RFRROTlJLzRsYnh0YVBpMThp?=
 =?utf-8?B?ZjB2Zlh4RmJ6RjkxVENXVkI3bFVGSmcwNzNOMFZSVVdIb1FTeUo0QVEwU0U2?=
 =?utf-8?B?L25XSkpFWDVuN0w4REFMcHBiZk1wUG4ycXVNQndyZEVMWnhaTHBvbnc4SXAy?=
 =?utf-8?B?Z2EyNTBTWmt4eDNONDFmOXdubXJsOGM5VjcrYjVxVUFWQXYybUVqT1ZsbDU2?=
 =?utf-8?B?ZlJSaW1BMDZndEgwUC9KUnJka2xoSmdJRmh0NWtXbXByazVsMkYrMGkyZ0JT?=
 =?utf-8?B?K21FdTVpQklYOGtIM1dnWmNHZE9QSFlLK2pvUk9Qd0hPblF4TnNWb1ZzTzhG?=
 =?utf-8?B?TzlZNzBtR2d4amVEeVg3TVFwSkFtZWovQ2ZaOHlER2Z3UThlUldBU0NBTC9F?=
 =?utf-8?B?NTY2dlNZd1Q4SGY3Y1FiczlxUU9HNURsMEEzdEt5eFJ4RExTYjZKcDJsZkdQ?=
 =?utf-8?B?OS9XSTNXS0M5RFRhRVZxZG84am5yNVdhMWVBV1dyRjRtRFEwajFaYUpzUjB0?=
 =?utf-8?B?dnJxekFzdlF5YjE2YmhPU3dhS3NscXVDY3pEbW1DZSs4aVpXS1hoSFZBZkhQ?=
 =?utf-8?B?ekhOZERKQXRJWHBwQjVWTXIzNmZOOStaSEkreE1lSUdnSWNOSFdGR0h2WmlE?=
 =?utf-8?B?ODlCY3RRWVBjSmZreFBCdVN3VUxaUkFTeXVQYnRmTEtYR1dZbURxeTVWUUVl?=
 =?utf-8?B?VjBJR2dUQVhqbXVkT3hPWGR4QmgrN2wwT0FNMTh3Y1dUTmV6R0paSTRxMWtt?=
 =?utf-8?B?cTRENkxITjMvWGZYQ05DSEZaS2VsUGliRnE2dk1tRE1TNW5uTjFMSHJ3LzN3?=
 =?utf-8?B?emkrRjBGdTlGM0RpYWg4VUJmeEgyR25SWmxQVFhBYnphMTlvMEttek9EQ3Qv?=
 =?utf-8?B?Zzl0dmtUbEg3OGt0eXprVzdDSnRpbGFpNTFCWGpoc3pTK2M5aTA2NWxEL1NU?=
 =?utf-8?B?cDM3NzJ4ekREa1M1QlJkNTdySDRGcCtOc24wNUVyYjZoZkpFL2xwWjgwTWFv?=
 =?utf-8?B?cUNQbXJ3cFUzMUdna2FyVmVWMVl0U25pT3VLMEYxRnYzbHAvWHdjNUlEM0ZV?=
 =?utf-8?B?a1NwVWNLREpzY0hRTzIxbEgwTitWUm1xd3FxUHpDMExST0c2VS9EdWpTU2RV?=
 =?utf-8?B?YWVYUXZvWUlnaVlSc3paUVhBWmY0NlQ4UG9VaXFMbVhOWXRzdlh2MlJWRExK?=
 =?utf-8?B?NDR5dHZWOTkwTjkzaE4rcnZ2THc4YW94Sk9pVFd5eC9lNGlYcmI3NUpNMkhY?=
 =?utf-8?B?RHFlNkpxRDQrSTRxWnIzS05rQjFxb2Z4QlY5L3RyUldJYVlwYkxWcDB1QzRn?=
 =?utf-8?B?ZGJnR0FqeXFDVTRxNGE5akVkaHFEOXpzdHovc2dqQ1BES2dWYXEySFdBNlVB?=
 =?utf-8?B?c0VyaGQrYjc1NEl4WU0yV1d5ejJIbGl6a0EzSEVkbVRUbkdXMm45a2FqQ1lC?=
 =?utf-8?B?VWRQcFFjSFlPUVRwek10MXA5MzVPM0o3ZWNpdmxadFRPblpac0M3cldhaThS?=
 =?utf-8?B?ZjRlY3pnWTFvQndiQzZGZmcxVFFZanY0dzlHOUNWM2JBQ1hIazA5WjZ1Z3J6?=
 =?utf-8?B?ODRiSldtbFVZNVJkdXo3bFczZjZyTnZzL3I3eUdWVk9JekJRYytDdDlzWlVU?=
 =?utf-8?B?ZVpHUlRiT1dxb015aGUzelY2SkJkWkFTVE0rV1crdDJ1K1plUDNaNXBHUVRy?=
 =?utf-8?B?bWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c4f4923-a7ff-4c7c-d2d8-08dded00e6eb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2025 04:50:28.7960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YZbKLbdNcqHKBQNULfYwBCs7OkyppxXT26NEeDStLvjkvdoODVuBQZf2JxOI8ZozUeVXVBgy3mP5RVftRAZG/EmW9dt36yoWYAdO+BlegHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF46B98A11D
X-OriginatorOrg: intel.com

Hi Babu,

Thanks for catching and removing that stray hunk.

Reinette



