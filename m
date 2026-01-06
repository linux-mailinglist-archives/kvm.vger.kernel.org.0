Return-Path: <kvm+bounces-67120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 77F85CF7D23
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5DE9310C2FA
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32E3932E721;
	Tue,  6 Jan 2026 10:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n2de7d8X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B86325704;
	Tue,  6 Jan 2026 10:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695023; cv=fail; b=AOfcNHebo8mCZSUEHDWFXA5mR9xZxwr74Y3HPcZM2Q9Vy3WVSmS84YfkO3cQe+JCPmQi6LFxiLz2cdV1yXYeIDPp7LdUbsJK0HhpY1gYbktqSwDmZgz3WpidrWuRMmfRaHr1wWuWyjkgbuWm7W09SRu/YU3druMxDdWE/FOwXmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695023; c=relaxed/simple;
	bh=E8VaEl0g3tttcjle370ewJ6f0QfxdhFjAB5hsiVybek=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XNFL+0KOF+dZNEmJZgtB+J2cLWITlnYjXtf1gua9wi6Poy1ecVOM6qpIXuuuvuxg6wMyNgCdU+gEaD+IQFzY3k2cw6FyMaweSdiyOGBT0R11Y5T48FQHJkG9ELEESaAQC4UTEXYpolNCMcQVI8reY9keSeR7OaHvBCHIkArE0ww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n2de7d8X; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695022; x=1799231022;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=E8VaEl0g3tttcjle370ewJ6f0QfxdhFjAB5hsiVybek=;
  b=n2de7d8X+OYIXSEwO0F9q+GrgNb9L1Dg4ZK+onpl3qeriGcCnD59/Ncb
   MIFt3gQ/wq6GJEWcInRDqHbNzegZWUQcnQyMdn0tj8WWpRzKZggGU+TGp
   amkgF30v8pps0DEsGPDK3ZmbICPQbS8fpSBrGZ7dd6dXHPRRehnVHEaBi
   xgOTYkSiKNgxPV+xUUAKPbJc2f+/7gJ/DPieYdQubpwOu8WD06oj0LfFc
   nPo4L6+KVnOiXxYxJ88p+5l1nREclCITEbAyz7WIiYiSRaMqP7rYKFGLT
   qWcFWNA1UrmFBpg1bNl9Z7SO6vg1mctXn9TMrvMGAWUuwR3ZblUaCFp4I
   g==;
X-CSE-ConnectionGUID: 648G++9zQ96L603RsMk6zQ==
X-CSE-MsgGUID: 6kc0Ld0dREK0O3qgRIL10A==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="68801940"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="68801940"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:23:41 -0800
X-CSE-ConnectionGUID: C9WdeMqBTf6D1mY0I0CiWQ==
X-CSE-MsgGUID: 9g7O7DuDQvy5zJ2IA2x4Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="202397437"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:23:42 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 02:23:40 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 6 Jan 2026 02:23:40 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.29) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 02:23:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GJQiJOK5J/Yvp8khp46KirdiW8r3qDyi14O2zeX2DysiOBdDOoplOuOTmhzHvnIpkPBOhu8gI30xSKVdde3XxKIkaRX+iKlUBF3nd/4dbuIxRf/cc2fTRPJRjeOqOD/FWc7iZ4iHCWQbRxl2oo9V4fnKSWTcYEVI7p+0XnpXioUlJFDPUC4qAbi6d/PzN7XWBkp+nsx99CWe1wQIPf0qz/q6yz+rhocdUAJvhr0Pziwgil9ssoO8srMHIHJFUcxxrm0pyRDfVTbskqoDPxQQtAI9BTGzaATrR4LjgMx8igd7e49PUBLQUjVm4dQkT6Af2Z6RvNSol0Hy8gz8JsX57Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AyNq6Nmczc3F7dYur9zX9m8SaicCpobcKcx6MmPLUr4=;
 b=kF/UQm6r+sD5ySl3//y/I7pfEfPWX6Od72i5tI9r3+QY2Gzf4L5bJaM+ycVD/IkRySMbW5trBPu/hyRvbh3ONAPoCYhM1MatOP4Iw6xS0pStA+TzuWay+ZuUO6SJjz9pcnd29Dag0RAbZvRQuQRdFQw6SItGI32kNzquS1hSnZBekK165rWIdLPNfAhF6/6hrK97IFO3hkjxuCSYDKRa09tqhJzy3OeUz/ArzNr0LmfMB450RKjT6lcJfOL3DjxpMu+B61i7kVkiJCgf0qydE9QJA5XG2VhmCRnnreVA+JZ/YgieyZZ/abhtL2z8uKZwhqQvZj3Uc0Ok2OGWm1ZOIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB7880.namprd11.prod.outlook.com (2603:10b6:8:f3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 10:23:38 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 10:23:38 +0000
Date: Tue, 6 Jan 2026 18:23:27 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Kiryl Shutsemau <kas@kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <vishal.l.verma@intel.com>, <kai.huang@intel.com>,
	<dan.j.williams@intel.com>, <yilun.xu@linux.intel.com>,
	<vannapurve@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar
	<mingo@redhat.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/3] Expose TDX Module version
Message-ID: <aVzinyLe5rxkJXUu@intel.com>
References: <20260105074350.98564-1-chao.gao@intel.com>
 <dfb66mcbxqw2a6qjyg74jqp7aucmnkztl224rj3u6znrcr7ukw@yy65kqagdsoh>
 <d45cc504-509c-48a7-88e2-374e00068e79@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d45cc504-509c-48a7-88e2-374e00068e79@intel.com>
X-ClientProxiedBy: TPYP295CA0001.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:9::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB7880:EE_
X-MS-Office365-Filtering-Correlation-Id: ce44c8b1-5f40-4752-a1d3-08de4d0da7cb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cnpXNUg1d0xDN1NJdVFFMXYyRUo3ak1RR3NrK0J6eUtORFAxbVZlbkdBRkYx?=
 =?utf-8?B?cXQwR1lqbTRvQ0VPYjU0Rys0dmg2Y3UzUmhNeXI0SjBiN21lRHVTb2hjeFo0?=
 =?utf-8?B?M0VTZUsrbVNHMllIMlFSY0lTSkcvL1hWb1BGQ2drR2ZxdVhwUHR5dXZsZ1J1?=
 =?utf-8?B?dUZNWXVieDIzS0cwU241Tkh1MnB0b1djSmV3emg1NnEvOXlabkxsRmEwNUsr?=
 =?utf-8?B?Vkt0QTdrenRkZ0ZjUkRWQ1FiNkdDakdEMlJUWDJpYXdRV2lydkFZNlMwbnY3?=
 =?utf-8?B?K0F3UXFsK21pbmg2SE84Q21aMmJTZWFiVXowNmxxUEZweDRjUUtFWjJMeGxN?=
 =?utf-8?B?NURiOHo2cDNtR0k4b3ZLSk9mK0grNVNjc2VaRmE5eHlpUE1Qd01oUjhudTg0?=
 =?utf-8?B?SVNlai9MVGtwSm5ZUGR4ZWFVTHVaUlZNZUZGeHNwcWJWWXMvUThuMFozWXpO?=
 =?utf-8?B?NEZ0bVJTWG5GL2F0Q3dKQTArQWdpZ2w4WGlnWFdKWDRnN1pzT1ZCRXlhR1NL?=
 =?utf-8?B?bWs4T3N3eFhFa0hKaVc4MzZzZWlDclBIRCtYSit0WkNJTlZHTlNzSngzcS9Y?=
 =?utf-8?B?b3hHWGdjUVdLYVJ0N0RFcGFvK1FZbXRPQTJOTWJ4L0RLMDh1SThZeDRhTHVJ?=
 =?utf-8?B?U0QxM2pDR0N2ZzRtdkRqTkZUUEhheEtsUnlYQXUvUElpbHQ1YW41Qm1CL0o4?=
 =?utf-8?B?RXpmaXRvKzNuNlRES0x5VXBQckFmdW9ROUNHSWFWeVlCenh1LzY4VHlIM2FJ?=
 =?utf-8?B?Vmw1aStTTE05WjgyTXNINnhmU3JZZHNVb0k5d09BUWdrRkRoa2htT3luakNO?=
 =?utf-8?B?YXRPSkdybWUyMldjVXBXNmZNN2lGdjllOGhNRzM3cWk1WkYvQndLMXppN0NN?=
 =?utf-8?B?dWZkV1RyMC8vYmp0Z01Oa1JzUTQzSjg3VzRWNUEwMVFBdmlhTG4wcXBuZFlz?=
 =?utf-8?B?ZXhNRjk2M2RxVGFZUWFsd1NweG9TcVdjL0U1YWpTa3dlaXVEeHVBLy83YlJr?=
 =?utf-8?B?ZVNiT002bDNxNDBxb3pCaXdRdytMb0xpOS8yQVlaOFlYL00wRlNiSXNSVUsw?=
 =?utf-8?B?TGIzZXNkVzFLOWh6UUNCbzNWc1RqR2JGbnRYV1lHQzRUcWRSMjVJdEY4NGw4?=
 =?utf-8?B?TzJLb2pNSVR3eG9GV2VQaWJHTkdHUjl5RkJqVWxZY3Nxa1VnV3JBa3dxS2hm?=
 =?utf-8?B?NXByR1VHam1TbmxsbU5DMWhaRGhrQ29BYlg4SXQzL2dLRm03dWVBdWdhb01Z?=
 =?utf-8?B?ZWlTeVpuUm80cFdaZmQ0OHQ3bU5jcmYrVE9YYWhnNWFocUNZWlNMZFcyRytT?=
 =?utf-8?B?ZU0vc1ZpalZRSWhudDUvdTdHeVF3UHRzK3JHUHFrUmdxNG5FTU5TM3RmTUF4?=
 =?utf-8?B?TkIrVDA1amprcGIyMGdIZlBydURoOU0vVmE4MlhXZkxIbEw2amdzb0VEdTdH?=
 =?utf-8?B?ZXgzYmVsaUhiU3NROWoya0lTZUV2Q3Z5eC83emVIeTNZeS9KREh4cXZFTFpQ?=
 =?utf-8?B?V05CSWFoeHZyOFRibHFZT3lITUdock9FSGZxeHVTRk9iT0dTV2lycXY0NWpD?=
 =?utf-8?B?VHFoemdzUkpJNWs5dHNKazJoU3AxUzR1MDFUSm51OGlGdDFEb09SbXAxeFBQ?=
 =?utf-8?B?WVBpcDFWNGx6S3BueERhRGxudFgzV1ovYTBzSEdpWk03S1dGbzk2VDMrbWNE?=
 =?utf-8?B?a3I5TDhjVk15WDJKTllaOUxoZnh5bmtkNndHMUUxY2JtUHhwMVpaYjNQaDlG?=
 =?utf-8?B?bG1GazR1NEJyU202MjJtVTVhSzd0c2lRRS93cVlEM0lVZFRybUNYUERJSTFJ?=
 =?utf-8?B?MHBOalNiaVh3dXcwRVA3Y2h0d3BLVmo5c3dOTmNQOXV6aDYvcjFNb29MS3NT?=
 =?utf-8?B?Z0ZHYjBUclQ2b3ZKVEhTZ3B4MGJYekx6SzdoODZvRzhsTUIwdzJvdkV2bVBN?=
 =?utf-8?B?cjc4N3NvVFRIVGpRU1lKaDBmWkg0YjhSM01TOGhpKzhGditmUG9lV1RyNUsw?=
 =?utf-8?B?UExLTDBzQ2tRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFY5Z3cwc1dYRWpUd3FoNlFlZVBJa2xVZlRKVnltaTRVeDQ0WTAyS29GN2gv?=
 =?utf-8?B?SWUwL3NTNzQ1WFQ4cHdMTVRyVHdLV3BReVhKeXVUZWhJS0YwM21LK2c3NE15?=
 =?utf-8?B?RUVRRm5sOTFGY0FKR3o4WHlCbjNOWGM1YWFMRFVxY0R5d3lid3VYdjkvY1Yy?=
 =?utf-8?B?SkcyZ2ZNUVh6OG1Venl4QituVmd1OWdSdXFBQ0ZMQUVwc3V6YTR1UUdrcldu?=
 =?utf-8?B?L3A2T0kvSnAyUHlrR3I3OEliL1NsZG8wd3R2RlcxUmt5elhNNHkyalEzNmJm?=
 =?utf-8?B?MGs0YVFMcEFNY0NzMkFvVGV3YThrY1I0SU9oLzVqVHI0UFBVSks3L2dTd1pM?=
 =?utf-8?B?NUZNZXZwRmNWOXFhRCtuMVQzVDhYRjNvMkdhWHV6c1l1dWcwWG9RYXR3Umdz?=
 =?utf-8?B?RXJDMDBoQmpZMGtCcU1saXJjTTVhaG5lUFRtNTNMV2t2SklVM0N4V2RjRi9T?=
 =?utf-8?B?WUxKQWlaMzc0ejRZMnVpWGtmekNJT05PWmFKNnppeXgvQm5za01CT3dmamM3?=
 =?utf-8?B?QnlzVXhFdk1BcGV4RVV0ek00YUpHT0dXZE93NWVaclhXNGN3MktKNXdlWW1l?=
 =?utf-8?B?YkwzRWUyNzlEUnlBclJBK0FqT200SUpKaHVRN1VNazh4UTdUU3JieHk5T3hp?=
 =?utf-8?B?UzNxSlNQV3E1ZVo3KzNxY0FIMWFEMzFmTEQ0SzZPQjBRRlNqVytXMTcxV1pz?=
 =?utf-8?B?aDRybStmZ2tyK3hhVndBMGJlN2tuejNUUlUzWmhsdUxvaUVoalhPcjVaZk1S?=
 =?utf-8?B?TWVIeXJFZFVURVQySHNtZzFkbW0wVHQ3R2dHWjV6NkpPcWFTd2JOZEl4a2lm?=
 =?utf-8?B?andJS1R6dzIyTkZlSkZJV0F4ckdEbkZFdkdpTXNnQjlzRnZSUnp1U0kvOHd5?=
 =?utf-8?B?QUo2YTUxcHBKNUZLcFVtbG40emNNVkh3a2phZGRDZ0t6bGdFclUvakJYWWxn?=
 =?utf-8?B?QlVJRzVtaHB4dmZYUGxXTFAzU1VUWDYwRzVWRHRUU1BOaXJZQXUwa3h6R2dI?=
 =?utf-8?B?OG5qZFo0S0hxYUJXeEs0TGpHQ3YwVnY1UmErMUE0SWpJSmJSSm1TSGFUQi9Z?=
 =?utf-8?B?bUhxMWIzNkEvclJMUk9SRXp0REYyc09CbERyZnhHNEsyOWZoZUZmUVNRRWhl?=
 =?utf-8?B?VFpNQUx6Qlhaa2kzTmhnUmtFc3NURjZCdVgxV3lOY011RjRad24zOWI1WmFZ?=
 =?utf-8?B?QmRjRXI5dnFzakIzbEJrUXVLbWh1Y0VKMGN3MTZYd3hKQ3VoekF0LzNYTXNS?=
 =?utf-8?B?czBodkxXek9qb0dpTHhSWXd5Z0k4Tk9qUkVWWGFYY0pNMVY1UlMwQnIydUNl?=
 =?utf-8?B?TFJkNGlCbE8zWE9wMHQ2eGNkaDdLVWlsbWpwMWdsaGZ1bmppSzhtVXZEcFVu?=
 =?utf-8?B?cFgyUGd0MFNocnRRQUpkdmlablVFSWNSUU1OMkh2ZDBFVnN5Tk1MblJoVWcr?=
 =?utf-8?B?aWZZUlhsZ0gzODNKcE5SaThnSDBWa3U3M2hmd2htT0FMMTZLWXdqa0ZEZW9p?=
 =?utf-8?B?dUttclhBRG5jMnlubklMRVZEZjBlTHRyUkxFUkhITzVmNnVpalNnZ3dMRFRK?=
 =?utf-8?B?SlFKdlYyUi9qRFpkWi9UaDBsYUcvaWlKeGpPalcvRnhmSWQ1N25pTmRGNjBm?=
 =?utf-8?B?cXk4MTFVd1ZBNktzZkFIbW1WbmREdHdqSVlIQUFMNjNyeWFJZGFRTCszbXRT?=
 =?utf-8?B?U255NmlCSzgweHVzbWdpZDJvMWc3RitCT0pJdGVrSU83RzBwRzE5MVMveXVN?=
 =?utf-8?B?T2x4L29zTGJnQkU3elBBaUZXeDVBR0tJVGRhNDJJK2Z1Nm8rbzlUWXIxOUpO?=
 =?utf-8?B?L1YwTzJmZ0wrZ3FwdDJlVU4rY3hDZld4b2dwL0pka3dSK01IUlh3d3dURnov?=
 =?utf-8?B?dUtRaEdySUNhUXJlZG10Zy8xMVlOTS9CRll0d0U5NGVaaDdmTkMzempoVTIz?=
 =?utf-8?B?ekhSTkt1dEE2RE1TSmxuREduK01MalZaRFdlVHplenpoQklJQ29vd1lhZ3hk?=
 =?utf-8?B?WkRpOGl5YTh1UEJ5Nzc2cEVOemhaM3diRjh3QkdPdGRTWFRFWXdSYW40bWFL?=
 =?utf-8?B?RHRTY0xHYkFSNGl5MnpCVHpyK3VFSnd6RUxtaG9laHoyQjd6STJVWWlQNWVT?=
 =?utf-8?B?Sm1nZzFoVFZBNGFQVFhjMFl6enovcTNoSTk1UzUyOXoveHhaOWxHYVVpelJq?=
 =?utf-8?B?c3pOTnFJampOWWg0ajlIWjJQOUJwWjhBZ0FzYzNNZkpCdERETWdmSWNXWjB4?=
 =?utf-8?B?ZWxLbkhuaFJzMTZVc2ZGb3ZoQUtaeCtYQ1VSaEJndkRiNmpMaTEzdTJOU0ZQ?=
 =?utf-8?B?M0hsaTFFUTdNaVUxQURrSS9IazViNDJzL29MLy8wV3d3TTMvdXBBdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce44c8b1-5f40-4752-a1d3-08de4d0da7cb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 10:23:37.9486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Uu2Ba+pYUV9i3KwFfjQvEHtz9wUhOKZ2zM8khk+2rc1Ulv6Pxd8dai2bAmqbMgrPTOlzeYJYx7drQMZip2S+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7880
X-OriginatorOrg: intel.com

>Generally, I find myself really wanting to know how this fits into the
>larger picture. Using this "faux" device really seems novel and
>TDX-specific. Should it be?
>
>What are other CPU vendors doing for this? SEV? CCA? S390? How are their
>firmware versions exposed? What about other things in the Intel world
>like CPU microcode or the billion other chunks of firmware? How about
>hypervisors? Do they expose their versions to guests with an explicit
>ABI? Are those exposed to userspace?

First I don't think we should expose TDX module version or hypervisor
version to guests. See my reply to Kirill.

Let me connect all the dots to explain why we use a "faux" device and expose
version information as device attributes.

Why add a device
================

SEV [1] employs a PCI device while CCA [2] adds a platform device. So, we add a
"virtual" device to represent TDX firmware. As illustrated in [3], the device
actually serves multiple purposes:

"""
Create a virtual device not only to align with other implementations but
also to make it easier to

 - expose metadata (e.g., TDX module version, seamldr version etc) to
   the userspace as device attributes

 - implement firmware uploader APIs which are tied to a device. This is
   needed to support TDX module runtime updates

 - enable TDX Connect which will share a common infrastructure with other
   platform implementations. In the TDX Connect context, every
   architecture has a TSM, represented by a PCIe or virtual device. The
   new "tdx_host" device will serve the TSM role.
"""

[1]: drivers/crypto/ccp/sev-dev.c
[2]: https://lore.kernel.org/all/20251208221319.1524888-5-vvidwans@nvidia.com/
[3]: https://lore.kernel.org/all/20251117022311.2443900-2-yilun.xu@linux.intel.com/

faux vs "virtual" device
========================

We previously implemented a virtual TDX device under /sys/devices/virtual/ but
it required creating a stub bus. As suggested by Dan, we switched to a faux
device to avoid this requirement.

The previous virtual device implementation was at:
https://lore.kernel.org/kvm/20250523095322.88774-5-chao.gao@intel.com/

As you can see from #LoC, the current tdx-host faux implementation is much
simpler:

before:

 arch/x86/virt/vmx/tdx/tdx.c | 75 +++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

vs.

now: 

 drivers/virt/coco/Kconfig             |  2 ++
 drivers/virt/coco/tdx-host/Kconfig    | 10 +++++++
 drivers/virt/coco/Makefile            |  1 +
 drivers/virt/coco/tdx-host/Makefile   |  1 +
 drivers/virt/coco/tdx-host/tdx-host.c | 41 +++++++++++++++++++++++++++
 5 files changed, 55 insertions(+)


Why expose version to userspace
===============================

SEV doesn't expose its API version (which I assume is the counterpart of TDX
module version, since it doesn't have a firmware version concept) to userspace
but only prints it in dmesg.

TDX Module version is exposed to userspace because:

1. For debugging purposes, the version will be available to userspace even if
   dmesg logs are cleared. Like microcode version, it's printed in dmesg and
   also readable from CPU virtual device attributes.

2. A userspace tool needs to read the current module version to select
   compatible module versions for updates. This is a unique requirement of TDX.

Why expose version as device attribute
======================================

Once we have a virtual device to represent TDX firmware, using device
attributes is the natural choice. microcode version is exposed in a similar
way.

>
>For instance, I hear a lot of talk about updating the TDX module. But is
>this interface consistent with doing updates? Long term, I was hoping
>that TDX firmware could get treated like any other blob of modern
>firmware and have fwupd manage it, so I asked:

TDX module updates implement the firmware_upload API [*], just like NVMe firmware
updates and FPGA firmware updates. This results in them exposing similar uABIs
to userspace. If NVMe firmware or FPGA firmware can be supported by fwupd, it
shouldn't be difficult to have fwupd manage TDX modules as well.

[*]: https://docs.kernel.org/driver-api/firmware/fw_upload.html

>
>	https://chatgpt.com/share/695be06c-3d40-8012-97c9-2089fc33cbb3
>
>My read on your approach here is that our new LLM overlords might
>consider it the "last resort".

The "last resort" in the above link refers to ACPI tables or WMI methods. But
IIUC, my approach here is the most common approach for non-UEFI firmware -
"sysfs devices", i.e.,

 : Kernel dev takeaway
 :  - Make it a proper kernel device
 :  - Expose a stable firmware version attribute
 :  - Expose a way to trigger update (even if it’s just “write blob, reboot”)

Is there anything I misunderstood?

