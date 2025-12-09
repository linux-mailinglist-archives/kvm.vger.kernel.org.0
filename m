Return-Path: <kvm+bounces-65523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E4ACAEA19
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 02:34:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6BDEE30125C5
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 01:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAFD22FD7D2;
	Tue,  9 Dec 2025 01:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wxx0QUba"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D1C2F39BE;
	Tue,  9 Dec 2025 01:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765244078; cv=fail; b=T34cYDISwBHlrSYTMnOzLZuxsuy06WjuVgW9yU12K8iokCOqNJSUcwVGV7M/Xkc9gUcIZUrcd0kUa6Xbvwe3N3+dQ2DAyeuXmLZgIZsa1Jl1nHZJegHJW/RPgIp6ZgXuXytLiLDZTiOf4yBDhE0Gu2nvsOluhasqm11/5/KxZHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765244078; c=relaxed/simple;
	bh=c6odzwQLTfNq1mkkR6Bz/0gIWnmK2AaBnDTyi+BJmM0=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=ofUw4swW7RKosh6xaYAIHA9nR1XKYNezGAd0YkwkOE/3RiqECvnOuhMEroMYDF2nwULp5OaPm4lUlwZHka/OeydcJ0jJ1jlvPwzvCgkcQ/Djd9397kRYWtTI6ySGTEoY/BzxudMNjcj9Zuxo73NZZmQ1XQTFLtKUmvojzw/+ocE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wxx0QUba; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765244077; x=1796780077;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=c6odzwQLTfNq1mkkR6Bz/0gIWnmK2AaBnDTyi+BJmM0=;
  b=Wxx0QUbayPctJ/W/O2YE2YPzPxTUdKEvceUH6px9WVZjbxrSEKiRR9QT
   JN2J8Hcc4gH5yBotTqEUyz+k0Wcmkimu56frUWdVDBeKijeRjyp0EZVlz
   N3qTI/dJvVK7FxMD1K6Q8mpEZz9B+5O/XLYkpCIn9QY91ammjnSGhr8ub
   7COiPyc4K3bKwhY8zbaTdnuH5N03+pszPrk+UUO3FS82wLjqqwT92X5ri
   QumBGGbm70AhZrQ7QtSCO/t8wIjCBRsY+ZM0Sgm5l8vSt+7CjZgpigogK
   WUWaK6DrO3KKhv8fpv6/9reILEdLtSD/CJ/eH2G2HxqLMPNPKiW3UxZvQ
   g==;
X-CSE-ConnectionGUID: VimwiTEQTVqGOAsCg3CTEA==
X-CSE-MsgGUID: Or8kXBmCRS696V10qMZ6jQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="84603450"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="84603450"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 17:34:31 -0800
X-CSE-ConnectionGUID: GE8TTM0oSEyMSQLipWApCg==
X-CSE-MsgGUID: DtRo/QbKRp+os+heKaEBNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="201002317"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 17:34:30 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 17:34:29 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 17:34:29 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.26) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 17:34:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZLovUQ15aoBH1ZSGGlsGfui2ycH4pqKZEkrYIyJ+/Gv1YvHIk8eQ6zqR1tf+pEdG63cUrTvshKG95g03cBd28b0QgHPHDkeBV20NshK1B2iqDmhqDusVHc12s/WH6yyeeMEjvOoAenTd72AIuEKtx6xOoR+y1fUlssHqdrNE6IxH2JnONEFpejDrjRWhd0dHBLqqyjCkpPanMzPl08TE2rBMejgOFRDU5YyqUw0wTNCdqLS+eIhP+gjmKgjXJV4IQodP712s/NOWUbydjxkeb6XVt7v4QbLGZGZYpHBK5g8+oM1e7xggVEaRxq1CsPvsllF64qJL/B5hbNkBjMPu4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DtAIKYylpGqDlg4ol5520X8ni4gmXlA/fEriJF4HQWY=;
 b=FqzXDECgWZFg6HR9sN5DW1XKjuBuyzGHx+wozBTFvqA8Ny832cAp2qkN1FTdzkl3g24zbVOvh7eFcmFrqmnQRMtO05pQX+BiTxmtiP5oMQvJjje4hnFOUHhNJ6GrOseFkg8Dj2EJsGaDaf5q13GgrN4VHpcqxig3rQ9vvGZPx8WU6HGIs0Dj87s39/CI7oq/ddA3/FRtMdBr74JgLKj2NNIgOuKhDig76paexh3dMS3OOlY7QzJmykS6M4JsUS0Nk0TRO2R2tAD2LoTPsGKbS5haB0I4hu16+cEo63XVXjxSd4EJtMSk9w2hGcJO7poXTpSwbEKHL1PFAaGkEg/vdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH0PR11MB5314.namprd11.prod.outlook.com (2603:10b6:610:bd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 01:34:25 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 01:34:25 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 9 Dec 2025 10:34:21 +0900
To: Sean Christopherson <seanjc@google.com>, <dan.j.williams@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Chao Gao
	<chao.gao@intel.com>
Message-ID: <69377c9def3ed_1e02100f1@dwillia2-mobl4.notmuch>
In-Reply-To: <aTdchSmOBo60vbZT@google.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-4-seanjc@google.com>
 <69352bd044fdb_1b2e10033@dwillia2-mobl4.notmuch>
 <aTdchSmOBo60vbZT@google.com>
Subject: Re: [PATCH v2 3/7] KVM: x86/tdx: Do VMXON and TDX-Module
 initialization during subsys init
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0266.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::31) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH0PR11MB5314:EE_
X-MS-Office365-Filtering-Correlation-Id: a2b3db1b-657e-456c-a4da-08de36c3165e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YTlUdWNXNzBuMUlRSDJ0TnVtZ1hmeVlqcjBsN0VyazlQMzd3d1VEVjFGd1Jh?=
 =?utf-8?B?Y2RCSGlxMXFSZUJ0d3NMQTlJMFJvRlEvM0RRRlMyV3FVOVA1Rm8ya1B6clJy?=
 =?utf-8?B?QkNER01WM01LM1lxMmpMR25MYmhVS25la3dWRndhOENTMmVWcXZTWnIzeEZy?=
 =?utf-8?B?SitwOVNjRDlNcGtiSzZVbS8yYnRaYU1iMFlhWHBNc2FFS2tHS3V0Y3ZGNXF3?=
 =?utf-8?B?NXlSRURJN2cybThlWVRzTWdpYWxnMUdMeVp5ekF5eWx5TUkzZU5seEZmZTZn?=
 =?utf-8?B?Y3VzWFNVbU1JYWY4bytQWjVkdlBjdlJEdjBwRllGRHFlQ1VtckJEUkFRS0FV?=
 =?utf-8?B?bDRRcm9WaTFxWWpuQkVLMXhuZ3ZwVlZlTlliYzNlLzVHQmpRazFNaGJkdHRW?=
 =?utf-8?B?a0ErQ3g1czFlQitHTm5MQmIvYnJNMXJHeEF1NTQ0dUNUNTZFQlFzNHNCSlNN?=
 =?utf-8?B?RkNuV1RsWDV1eTM0T0ptdmtSREpYV25COW05bkRlRXB2WnNmYmlhZGg5QWFl?=
 =?utf-8?B?Z0pDMEM1aHNoWWJBeENLYk8rYW90ODB3bk1HYUpEaWV0V3VaN2UwYVRoT202?=
 =?utf-8?B?TElWcmdGTVRld3Mxc2hmVk9rZEhRd0crOSs2R0lpclA5djZoVitIdUVpeGRG?=
 =?utf-8?B?eHpJdTNaVk9aSEk3YnkzWTdZMWFaMGF5dGRzTVEvaTBGRXVVOER6eDgxZnBL?=
 =?utf-8?B?Q3BScFl6ZUY4ZmxQcUxaUmxJTGtUWWM5K2xabktnMkZBelcvZkpLM01rUG9Q?=
 =?utf-8?B?c2JXVjBPSmZxU0s3eE0vaXBhM0JDdGYzTnRLRms2MWdaU21vTzVsak5HZUlm?=
 =?utf-8?B?ZGlKcnBtRUZQY0kwMWNWWk4rUEplaTJHVEdkMStleXBucHRnTmhObWdvLzV6?=
 =?utf-8?B?c3V5UGl6U1JHMCtEUFQvTVNwN01xSm9jdzczRE95VDBFVytnVGRzcDJYWVBZ?=
 =?utf-8?B?ZmdQWm1vR2NzOW0wV2ZWMTVpcW1zS21KOHhXQ1dSdkF4MHVsRlBjL0NuZXU4?=
 =?utf-8?B?akNSMnFPY1VqV2dHc0JKVkFzblBjWk1hcWxqM2R3U1F5ZnJaSy9aTSs2Zlp3?=
 =?utf-8?B?SU1lN3lLNFRlWG9YbldxeXVvR2xyZStpZUVMQzNJNFB0WTA0TFNCWjNrdStC?=
 =?utf-8?B?dnFGUkVsY1hRVFlIRlphT0o1b0xic3RQV1BMS0ZIZXlnZkM0Q251emF3VEVr?=
 =?utf-8?B?aWtTVVZxd1VXN2grYWJnTmx4YnlpbnRmQ1VJUUJFTUcxcERSbTUwMHRoY1V0?=
 =?utf-8?B?MUFCTkJzV1duNFFsNEcxVCsvRnRKcFJEZVN0bVhCbFNFWDd0T2xrbkM2TDIx?=
 =?utf-8?B?Y2d2VUxUU2x1RHVscThTU1E4RUtHMHlxNFlyZFFLQlJuWHF3WmVqa05sencx?=
 =?utf-8?B?eS82SDZKRGNuRnZINU5uWGJQVXIxNUtHa1Z6NUs3OFg3TldGdDBoNlo2WVZQ?=
 =?utf-8?B?ZzBqQVBwQ3NUL2pUQTFndXhnRmFOSVI3cW9xVVEvM3hCWFhiblh5VnpWZzZa?=
 =?utf-8?B?cGl1UjJ2bFBrUDNzczE3QVJmeUMzQ1JtUjBNK0lVNlpQOTNLTW5YMjVPcmlJ?=
 =?utf-8?B?NU5lUHNJZmVKQUtYbm92cUJmTW1aTlVaL3ZOUlVmRWIzY0N2RTB2R0o4QjJx?=
 =?utf-8?B?d21KampBajBaN0o3dE9GRlZOYThiRDhBdFdDc2F0aE5EQ1h6U1pHbjVkeEl0?=
 =?utf-8?B?M3B1bzNPKzduby9XY1ZmNVZWcnZkNVBjNTBBUjZEMURpU3pSK3BiWFhCMVFL?=
 =?utf-8?B?bGhBVWY4SHUrb01JVUVMOUpkZHZTdDRRS1RpVDZFckFlRk9venJyVkgvYXdh?=
 =?utf-8?B?U0R1TjFidS9BbjRhYXBUaHI4Z2ZCdnNpbmlwdyttSXpkYldwQzBicmxhR0RR?=
 =?utf-8?B?ZlV6VHhlQnYvWWRNTnJna0NJWDhXT1dCbHdJYzJRVkNwSjhOTEtZUGVFTGpO?=
 =?utf-8?Q?zXnjisI3RGPGkiJmBf6VZxdMb01XBYYq?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MXEvQ3hDaWxIWHhPTm9hZGUxRjB0ZmdNN2JJZXpwSHZqbCtuNkozR1lMT05P?=
 =?utf-8?B?cVJaT3NRa210eVU2NUJmQ2EyREhyWFpaMGZJaGRoVHVKK1ZvdWJwY2l0eVFK?=
 =?utf-8?B?ZHZJYWQyS2JhU3ZqQ0xPdkJpR1p6aXpBR2JHOGFSN2hVL00zLzhHeTNxNmUv?=
 =?utf-8?B?ZjZJN2tpZ21EVTVkQTNNRkhNNURReDgzQmVIMHVBVUt0SnlvZUdzeXY4ZTBM?=
 =?utf-8?B?blhYbmpEZGVJaGRrcHpTRXpLUmdBeG9FQ0F4TlJzWmZQanRYbE5nWlRETUVm?=
 =?utf-8?B?OWtiQXA4d0ZNK0xwQVR0MXpHMDNpMlZvc1Y2ekV3RWJkZFlQb3ZZM3ZwRlEx?=
 =?utf-8?B?emd1aHoyRlVFRG9uRFFTcDNwdFNJaEVabFRnVHdFOGxTVk01NTRmMkhVc0hE?=
 =?utf-8?B?bzZaeEgvb2dhcTdlWDI3MXpKZ2MxR3IydFg3bk9QS1N0elorV0hqQWVjWWZD?=
 =?utf-8?B?YkZ6UjdjUXJkNEJPZzV1NmxnTi9zK0h0VTkzZzJuNURqTVRsNVVjdVliNFZJ?=
 =?utf-8?B?YU4vOEtZZ3dFc2tzV2x5MC9RcTh4c0pGcTlVNUdrZWtSM0dGTktJeWx6blVn?=
 =?utf-8?B?V2Nyek9LZ0VranROdysvOTJ1Y2IwV3JybHh0bDg1WkRlQTR6SFhHWGJWUkVz?=
 =?utf-8?B?U01rQlA4dFhCd053WFl2T3FLOXhOV1JlOHU0WjZ6dlUyd3h0RnpQZy90OHEy?=
 =?utf-8?B?bFg4ZHpSTmU0cWVQQnZEd0VzeEl5UVBGdnk3S3E3OU1wbyt3VkszNkJuMXhV?=
 =?utf-8?B?U2tyeFpyT09CWHg4RFN1MXh5WDdEVzV0MU1ReEtjelVJdSthcURwTElIZGd2?=
 =?utf-8?B?ak9wSlh1SjVNVHJyWXl6a1FXRk5vQlJ1clFFL3h2ak93UCtKd1dIbkJOaTVR?=
 =?utf-8?B?MzFYbWdlcGhESnlTbDZXVFpyU3NKY3N2T0pVMmRtdVREVlFBdFAxUmtIbkF5?=
 =?utf-8?B?Ly9wb3dKdlZuaUl5a0NPMjVXOGxIOXVyOGhIeS9rUHlPWktUTHFoTXBBejkw?=
 =?utf-8?B?RFRmNjU2ZzVScWlDRHVUSFVhVzVMRWxaZXJibWVPZkxNalhFWDFRaXBmL0dj?=
 =?utf-8?B?RU5OVTBVYkFNS1lSSGhpR1VLMHNyVXQxQjZtR2twVG10YnE5RmxjT1R1N2Rr?=
 =?utf-8?B?dllFUi9IUXV4K1ZycVZQWXFXTTlGbEpib3B1cGVaZXFXRTRoZ2djV3FaY1lK?=
 =?utf-8?B?cXE0aXpXUFRlQWxEbVRiWjJrQ0lETy9hYlpaWCtsZUxpN0lnS0FQd3hjUVIv?=
 =?utf-8?B?cDRTdURYeVZwaEdTSVNPck1majNEaWtQbVdlVDN2NlBhZjU3TkFXdHlQMUkz?=
 =?utf-8?B?MGNHS3V6TStDTVBYM1JZNkxocjh5OVFGQlJIU2pzTmorS1NqNzJwSUJjTXN2?=
 =?utf-8?B?ak9HVHZ2RWtUK0tSZkJVT05QWG5WVjJtZGZRVDZ3MjJwdkRKMDBZNXNyOUp0?=
 =?utf-8?B?MFNRcmtuRXo2Z21hcHNhZXZmOUI2SWxPUmxoMHFuQ1F6UWZCTmhDNjdXZWJp?=
 =?utf-8?B?V3IzMStSeGdyenlLUW00WnNWRThnR3lYRXVJSDV2MllVMk45SmZjcmZsRzlr?=
 =?utf-8?B?TVdVNUxla2dRYmFEYllYaEN2ek1OeFpqTGt6YXArd1krWkI0SEpmRUR0Q2hq?=
 =?utf-8?B?LzhpV29waVpTSU1JUkE0WU1CMUZRcWcrUkNpSkVMMUpsblArakt1RnREQndS?=
 =?utf-8?B?Znd5UHlrM3ltYWR4TVRvSG5IMUxyNGFCTml2OE40cGN5SW85NkhTQTJHMzRz?=
 =?utf-8?B?TW5Hc1ZDQUc1Nm4xMllXeko2YmhxUU5VRDdFSkxwN1VYc0pGNFpOaWRYaHMz?=
 =?utf-8?B?aEx2c0svVTduUndvWE4rT1BLM05IQm5iQ3YzOHZ1T2R6WGxwcEQzNklUakFP?=
 =?utf-8?B?TXZSMnFabGM5Rk5HTzhhbDk5NVpuU3RScGRKK1ZzVkFvMUk0eHU5cE5EcjRX?=
 =?utf-8?B?b2pjUHBkY0pudjBoQnZLV3NGVlBqTVF0bnU4clkzY0NscWRGdzBFU3RqRUV4?=
 =?utf-8?B?bzJCZXdYZUlXcnBHVEU3UW9oSjEvSHdNWXN3ckMrVnZzclpaTktMbXk1VEl4?=
 =?utf-8?B?bFgxc2loTVUzdVkxczIzSHhYdUxIaVpud20vSS9EcFgvMTJmdHlYWHM2ckxM?=
 =?utf-8?B?aHQ3NktORkpLL3JMb3VzeEUwMTFBWHV3ZWJQR0I2a2hqVnBuck5hTnVmMTAy?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2b3db1b-657e-456c-a4da-08de36c3165e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 01:34:25.6454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FEgiT0jGyTgtzQt4rFLSqZxTz/Wb0pnEbq8V0VFD/7DvIBSvRCygHm0oRAzEPgtDYiWYyJuNLUe/Ypyb00iR0YZha1+hk/4m9qKV20mS00A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5314
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
[..]
> > With or without the additional tdx_{on,off}line_cpu fixups:
> 
> I think the fixups you're looking for are in patch 5, "/virt/tdx: KVM: Consolidate
> TDX CPU hotplug handling", or did I misunderstand?

Oh, yes, all addressed there. Should have finished going through it
before replying.

