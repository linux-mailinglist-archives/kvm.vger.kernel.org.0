Return-Path: <kvm+bounces-68857-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4GHbI0nFcWnfLwAAu9opvQ
	(envelope-from <kvm+bounces-68857-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 07:35:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F37916246C
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 07:35:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 202C14F5A0B
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D2134D38A;
	Thu, 22 Jan 2026 06:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZiWD2yAx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92B03803C5;
	Thu, 22 Jan 2026 06:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769063740; cv=fail; b=dq4r7ILu1Sx6Z7SUtDj1wqLsVH0WOKHZPhhhdtUyylu0CBypwF899L6xx72gd5sKSolEl1m3H88stJva40d+qxX5ZiGgSui/cyTbbhW0sHIsZHf3DwMKE8H132BuHzVY0ulEF0g6jqEE0ZrEEAUY4YmEPNtusALIPNv5M+QHMx4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769063740; c=relaxed/simple;
	bh=Oz2uToLwXOztCz1Zw68TH3+RBAX0YbVgCOnPeCCG2t8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FhEXwnaEk3EykVTpPPmny3x5vx33XlF0MyQguUYsSgi8PnE4FYrqzfVc4atXftzju8vBpBSfsnwSqymfPwjYjUHTsR2T1LPzOYUpJQLb7gWTbCRmg3iabwSRw5d2Gm47WobRD7s/0/WlVkvLnBKo8i+ieOri5ql03vqV03EuV/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZiWD2yAx; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769063739; x=1800599739;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Oz2uToLwXOztCz1Zw68TH3+RBAX0YbVgCOnPeCCG2t8=;
  b=ZiWD2yAxJwOKiEBdvEc1IpacMfhdj/WGzXYBTl6ArbJRgXyekxobPYqj
   4qxaMtCACxeECGexhhsBsQ+Ai4tjZYE/vrgs4PlYkTzD6CZhkqJfV/N5v
   lz4otJgsCMjQb8zF4eo/bynW31fA7WuDfqhlyONHlH5bn8lxqewxGZSck
   fV6eckvyg/pVPAf9KvM6RDTefNyPum27qZ+77IDQTsXCa/Nrr/1bARq8B
   foVBHHVweYe4xiv6dLJD94oRnkbba5CAYjRoZ0h2GR85MwY3fjGKpXW1c
   C3SBaTKuhOpr2Cb6Pi9Pdo+J8rN6c6kaZMWsByyw3RSC6BEAKjSZHi4wy
   w==;
X-CSE-ConnectionGUID: VElZ/MaIThmA8pk1PrDJSQ==
X-CSE-MsgGUID: CA0Huz0PSNuTN7NVH5ebUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="73928747"
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="73928747"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 22:35:38 -0800
X-CSE-ConnectionGUID: T161RUheRCyrXHi9cyqXQg==
X-CSE-MsgGUID: hEZpJ6Z8Qs6u7+w1OSm/Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="206464662"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 22:35:38 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 22:35:37 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 21 Jan 2026 22:35:37 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.50)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 22:35:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aHYOs38jhuDIX/j5m0dMnTU4zT0n5SjCbtiC/0nIdiUz3cqol03jJwl0OuMyTaTq9DYgp3M0FjJeRJr55vVY5Su40eLO+FGA1AKLVKpemhS+Wjg9Sh6Hk5lFwUpH3MtzPyP9D/e3eZakdyPDzvOp8vaLJQ2yEu1Nj0qAhymV8yasV5bpUwxrRIdGY8ZB24Z/2mWZR4mxN8N9jB9ATXlK/rwOXK015QgvVFlmpKuhroD8Rl6K03lnCG1/1s8goxzcdZgsQFR3XWMyuem7ZPHRCdgwp75igb8AxLOsWfM04ZEQ5drHfR6DmxjBXJhEqckLLk+bhOyXfZwXI/92F9oKQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=54ay76HxdIXZ66RwkABlOT4/nVwZ6RUgxhBOF+V/DiA=;
 b=x1zcw8GS7moCG7Wj3wboWYK8fhVREVwG/vP5+HGT9j4jLh4evWzaVXRHoXcguBsnf9aDA3Dw6cWOsNnw82lt0zDoyK6ulO/i+pnCvoifCGDbHsFmSnp6Uc71LVqF+WpsjzT27aqQ6yZ2SsWY8VdpQvefA6NscDPbmpjQVP5/jjlXUN2FJD3hAeQx2iwj/sw6b2Q18TWUmUxle2KRti9fldi7vnd1/ZLya1VefFc1u5npJl4a/9aMI7PCCjwTcjSKHBVRasgXIxy7QEO71+fE/9ZWSiSRZBeC1IbbLIbcuhocb7MFMft51vHu96JgEVpIlt3dG+NPqom2H8Pl9lDwPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL3PR11MB6529.namprd11.prod.outlook.com (2603:10b6:208:38c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Thu, 22 Jan
 2026 06:35:28 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9542.009; Thu, 22 Jan 2026
 06:35:27 +0000
Date: Thu, 22 Jan 2026 14:33:09 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Vishal Annapurve <vannapurve@google.com>, Kai Huang <kai.huang@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Fan Du <fan.du@intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>, Dave Hansen
	<dave.hansen@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"david@kernel.org" <david@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"michael.roth@amd.com" <michael.roth@amd.com>, Ira Weiny
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>, Chao P Peng
	<chao.p.peng@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>, "Rick P
 Edgecombe" <rick.p.edgecombe@intel.com>, Jun Miao <jun.miao@intel.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 11/24] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Message-ID: <aXHEpfcyHtaMcqPz@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106102136.25108-1-yan.y.zhao@intel.com>
 <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com>
 <aWrMIeCw2eaTbK5Z@google.com>
 <CAGtprH9OWFJc=_T=rChSjhJ3utPNcV_L_+-zq5uqtmXm-ffgNQ@mail.gmail.com>
 <aW_DQafZNMQN5-gS@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aW_DQafZNMQN5-gS@google.com>
X-ClientProxiedBy: SG2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:3:17::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL3PR11MB6529:EE_
X-MS-Office365-Filtering-Correlation-Id: f7df91a5-6559-4270-0c2d-08de59806e64
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dHZGRDR1a3RtY2hiWHJreExienRTUlBYSVJqNVBoU3Q0SzBrZzdIRVhRZWpE?=
 =?utf-8?B?N2hYeGsrSU1yNkRVWFA1REs4eENHM0YrRUY2cDVDNHd0VVp2UGN3QkdNQ3Ix?=
 =?utf-8?B?MXo4YThlQXV2Y3hyOFdxTFM2TStsZGZ0RkZtTk5BTU9SVUdQQTRLbUNmSEVt?=
 =?utf-8?B?cE5WdXVGOGdVZlA1aXVMK0NvNjRmRlpQTHZ3MUkrSVZ4aFRpTWJ4UDVSeWZz?=
 =?utf-8?B?TitOTDM4QlVsV1VDelY1dk1Ialc1Q1BPVzZ5THhjZmN4SDRhWVBObVUyaTk2?=
 =?utf-8?B?SzAwOUttQjUwRkxZZU9LZjg0Qnp6QkE0TGZuS2g1YlN1MlBOVSt0YUhHSW5k?=
 =?utf-8?B?NGlFcTFvZDYySVNBSkZXNkdUM2lpL042eUxCb0NOWEI5Zmk5SDlhcWVDN3pB?=
 =?utf-8?B?NktES0QveVBjNnJXQmU3VEVENFY4TUhmMVp2SDJ3TklaVVNlRWFCOFVCb2ZT?=
 =?utf-8?B?UnQzZEtiNkgvZkdPNG01RXowbk1sZU9rTHU4TmcwVWNjKzNxdy9kc2UxRXBj?=
 =?utf-8?B?eGxIRWVDRkN1bGRWS2dKdEZmd0orbkV1WFcxUWRCcThiK3hQTTRGR1FsTVg4?=
 =?utf-8?B?WmZzc29DRUNwaUFaeURaR1Q3MWtIMWdQUGwrSG93dzZIUk13eEdBSVVPR1k3?=
 =?utf-8?B?dTViTS9SaE1VTVhsVzFKbmNDOFNnRlJMYTVLRmtKcjVIV2RSdktZVEZjZ1dh?=
 =?utf-8?B?ZlBRL0pqWTZNRmV5YnVqT3ppZ0VGNExrOFRqZlJBVEVwbHNYQjRCd3FBYmNQ?=
 =?utf-8?B?d3R3TTZFckpUM2FHWWR3b1dWNFFPK3UzcEhiQU5LWlB0VXJ2S2R2bE9LMjZq?=
 =?utf-8?B?aURoTGtYcHFhV2w1czg3MCtCL0RCV2w1NEY0bmEyczBzQWlQMGI5NUZwbTRJ?=
 =?utf-8?B?ekkyOVlEZ3lyd3VmelRuWXplY2V0VnZMVzI0RG9qTmMwRHAwNDVrb0xrVC9M?=
 =?utf-8?B?c0dnZHVvdVVCY0RldnRYLzdDckpTSEdXR1NPZkd6QTlRaWlxRUhUKzhIeDlQ?=
 =?utf-8?B?bXBSemhXYmJja1ppb2NnOVhJTTh2YmkyVUZKZ2M4SXlCb3dWM1ZwdXc2RmpY?=
 =?utf-8?B?OGprbmh6VSt0NkVHaWh3cHdmdmFWRjc5UW5TZHZXa3JQeTZvcmVvNG5vcE5j?=
 =?utf-8?B?TCtRTnJPN0JKRnVsZjFubUdpWGNYTTY0TVlrN1F3aXNUbzFuemkrdDN6OHBE?=
 =?utf-8?B?OUkrMmVoc3FYR1VmTFUvQitBbEJyZjBXc2FxSkQwd0hlMzlpVWdJWXdJa2Vm?=
 =?utf-8?B?QmdsV1AvWG9wb1krTVJjUG5Ra3BtZzRYekpJS2pUamxMWmc1b2JRMG9FWVNo?=
 =?utf-8?B?bjJuekswakZ4MStXZG5UUGlZL1daKzNUTER0bitEdWVUdXB4Z2FPd0ttblhz?=
 =?utf-8?B?M1JOK3lZdHMwLzlPcEo5ZG11UmE0WUZZdWMyT2M3RUF5Wm0rTks3M3V0My8x?=
 =?utf-8?B?aUtQbEVxZy9RNzJkRmYyUUhBYmlQUzlxT2Q5N09UaGVuOEUva0YxcjdQSHJa?=
 =?utf-8?B?TWU1R0pLZnpNYWN3clM0dHk3Z0s1MWF6N0d3Yk0wbGJORXZqKzQrNDR6NHNk?=
 =?utf-8?B?Wlpmc0lQRlFOZVQvck5aSk4wbWpPN2xlRGN1ckg2VWhMajJKc3U1OUprY2Ri?=
 =?utf-8?B?b0tqUjlydHlRU0VVQlJkYVN1bFhCS3RsZ1ZabkpPMUdwaVVnODFEenpvT09L?=
 =?utf-8?B?Rk5wd21PSGZrbHEwRlpUdlFUYWdWTWhlUjJWSFdzYktib1lRancva3ZSQUl5?=
 =?utf-8?B?NVN2MGU5Rm1sU3I1NDQxaVh2Z3VDdTNQOTBPMG9SWVBZUWFjSW9jUnNCbTlw?=
 =?utf-8?B?czlZWU1IM0tENmJQMW1DNmYrTHl0Sk9KKzd5ejZ3UERPUXVvWHZOdlZSZHN0?=
 =?utf-8?B?MG5Yc2Y4YUh0b2lsT1M2UjYxbURDNlBQRmFYb1k0L1NQYytaM0oxQjF1SEpO?=
 =?utf-8?B?NG91ZUtOT3EzM3A0L1NMODVESXR0b0Jtb25aeFFPeVAwVDZTM0RYT2RlM0ZZ?=
 =?utf-8?B?NUh2ZWdaU1hhTm5nSXN2Q1J3cUl1Y1NCQTFJb2s0aDBVa0JnMm1LbjhlM1No?=
 =?utf-8?B?TEdNSnJkekNBbHIyaFhUdlhCMEMwb0RXTThuNm1pOWs1TUxlaTJ2bWNPZVJ3?=
 =?utf-8?Q?WZYM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVhWZDdXTHB0NVRiYUdmb0Uva1NlWG9hbHdmRDdlUzNHMSt6dm96M0d5Rmxp?=
 =?utf-8?B?Z1NXQk12NVRvZ2ova1pjeVVGTFVtd3lJOGpBSXdWZHE4Q1FNK0IzYzEyaWhk?=
 =?utf-8?B?aDN5SFp3QjMzSENYVUtINENLeGk2YStKcjJueUFoM1MvU1dSa3JjdytpcHFJ?=
 =?utf-8?B?YXcrUmpTdWl6TjQzVk9jL0ZWb2RGT3h1MzQ1aHNjNW1aaTdLZ0UvbHIveGJk?=
 =?utf-8?B?eGVCdDBsY3FXa1RVTXdaNWdFM0dadlp2blBpWUpWWDJlYkxFWWJRTmJYdnRl?=
 =?utf-8?B?OXR1UHNGM2hTQ1VzNklBNkZrUTBaN0Q1bG4zenNYM1Q2L3VEVUprNkV3d0hx?=
 =?utf-8?B?UVlOOGNtRTJGcjh6VythNkd0dXVveUFZd1d4RzA2L3BwVVZ2L1Ixa2lCTW91?=
 =?utf-8?B?aDBSZTYycU5wZHdsMjV2eGlzT1JXdEpwdTFpS1M0UERHZFlGU0tIc1NFMDdx?=
 =?utf-8?B?cXBRK1lZeEw2WVN0RC90OEdCVDIzdHBjYW9abThjNEhuaTdyNFlFVU9oU2l4?=
 =?utf-8?B?My9KSmo0aklNQ2VwSm11QnJYQnlqRWQ4V3Uva2RQZzAvYlp6MVlxR2RRSmZq?=
 =?utf-8?B?YlJEdkRFbHRoanVCNUlYMnIvTmFMeE9vNG8xL28yeU1qcVE3bCtQQTE5OE5Q?=
 =?utf-8?B?eFoveFNVZkdTR0cvMGJCR2ZxK1VGeUpoTWU3SVA1U2ZuRVNNRjRUb3l3L2Zx?=
 =?utf-8?B?UG5vTVFESnBHcEIzVGYyN0wxNEQ0NTJ4NTRXSTNCMUZVdGdEYUFXRis1endX?=
 =?utf-8?B?TG8wcDJzK2QrcXBIS3FVWGgxbzBvUTl3dmFkZm8rbXBWYjVRUXJScy9XNVBl?=
 =?utf-8?B?eHM5RXVPNmZYdmhUV2tURVAxM1BVak10YWh5a3FhK2tKM3hlT0o5T20vZEoy?=
 =?utf-8?B?TFM4VFg3YWxuYTVqYWplSGNRaXZZbE1ySm5jRXlFWjBsdjFmd2w5WGpPUEU2?=
 =?utf-8?B?TzB4eWlKTE80dVhHanFsMTliVWY1K0pBWkt2Q3RTRmlIVVZrUlREMENNczdw?=
 =?utf-8?B?TmpMN09xR255VjBGUVQ5UUVKRzY5TmM3VS9sbmovRmNwcEt1WFlCNDVjRklE?=
 =?utf-8?B?bkJFdFlZbkNtSnliQ0dYaTV5MTJJaGtwUUg2THJCTmFLZWRTNjdZTmVZMXJa?=
 =?utf-8?B?U2lCS1RwZDQ3SmgxM1FiNmM2TkhBeDVBL0dJYlo3SW9hRzhyNzMwR3FTQjh3?=
 =?utf-8?B?R3I3M0kzanpQQzcvMVp2OTlFTXdoeTAxUm5iZXdWaC9PRGtvS2dRQmhhSk1i?=
 =?utf-8?B?aWpuK1BZdXBGLzl3TTEyc3Z6NlFZczV6Tkp0eUtwYm81NjdxSndCTG82anRV?=
 =?utf-8?B?ZkNvUm5ZS09KdzVTTG5tOHA2eExBNlVJSUpYLzlKdS8yYVgxbktSb1hIeW4z?=
 =?utf-8?B?N0l1N3RHN3NMOWxLYlRrWkZqcE55aExSRFJCNzhuOVRkYlhTcEpnajFXTjYw?=
 =?utf-8?B?QnkxMDlEVFJOSlRjV1d4SEhUSnJWcDFxS05zQVl3Zkk3Y0w5Q2I4dnZlK1pi?=
 =?utf-8?B?QzhaaG5MZVh6cEp2b09lelpTYWhJbkpmdzRqZFRQNGdkTi94SzVva21rdHBr?=
 =?utf-8?B?Z254VnRuSmtxdStMYjhBc2JNUDU5bkFYWHJjWEsxU2R1SUwrNDgwTEdXNTV6?=
 =?utf-8?B?S1JxTmIzaHBkRlh2RVUvOC9KQlphZzBVSzNMU0VDRFo4VUt2R1dNcWZSQnNW?=
 =?utf-8?B?TllRNUtVd2l2ZG5oREo5cDRQOU5UVkZxVVV0NUlaZWl0RUJ1QVZBNjlPM1hE?=
 =?utf-8?B?R0VmQnVaSit4MkhGdEl6Y1J0UytEUVQvRVJNS2o1QkNNeG0yZ2YwYUZBRGlo?=
 =?utf-8?B?R0ZMdm9BN0tuZ2dhRjUxYjBDbnl4VkZLNHM5N2FBMHFRai9FZUdvTkE5R1FP?=
 =?utf-8?B?SWRGTHFyaW5qdEtVR1p3TGVEUUExS2JYWkpGaHA2NS9pVkRlUTVQUG12alNl?=
 =?utf-8?B?dlg5Zm1Cc0szcWpTMWNZbWZyVDZFWGFhWWN2K1ZCWUxYQWFETGU3YWFYdmpa?=
 =?utf-8?B?WFRXRW1Yd1lJdVVyc2l2aTBUTktDRDFlRTJKMCtydjVZNmZjS09iNG5JUEtD?=
 =?utf-8?B?MXA2bFBhZWNsSGxTamxJbGdXbWNFdjlqMGo5RDdFU0R4SGhPYnNGOW5kb1NN?=
 =?utf-8?B?bG02VGpmMWNucURpeTUzNHZTdGZ6c2tlOGhFaEw5UWNacER6Q1NXS29jOEhp?=
 =?utf-8?B?N0tIWERZTkxFWHV6ZDRvMzlURUYrOXMrNVd3QXIrS0xtcjJCdmtCanVCUW5Q?=
 =?utf-8?B?eXZ5bExYdUF0Y0FJcS9LMjZ4SGJVQjhueU1FZ21rZGg1eVBjK3dveXB3K0lK?=
 =?utf-8?B?MXpoeGl4OUVLMWtXODJhNjN3L0FuTEsxSjF6K0NIenZvU1hxVm9aZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7df91a5-6559-4270-0c2d-08de59806e64
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 06:35:27.7795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xLeVNlI6WxGK96lLvMemJSr9XFsircM+eFP6HDAJTuZBk9RaGBnDNV7Y1m4b5T43CzYRCk07xHWUODl+vIWemw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6529
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[google.com,intel.com,redhat.com,vger.kernel.org,amd.com,suse.cz,kernel.org,linux.intel.com,suse.com,gmail.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-68857-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_COUNT_SEVEN(0.00)[10];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[yzhao56-desk.sh.intel.com:mid,intel.com:replyto,intel.com:dkim,dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	FORGED_SENDER_MAILLIST(0.00)[];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: F37916246C
X-Rspamd-Action: no action

On Tue, Jan 20, 2026 at 10:02:41AM -0800, Sean Christopherson wrote:
> On Tue, Jan 20, 2026, Vishal Annapurve wrote:
> > On Fri, Jan 16, 2026 at 3:39 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Thu, Jan 15, 2026, Kai Huang wrote:
> > > > static int __kvm_tdp_mmu_split_huge_pages(struct kvm *kvm,
> > > >                                         struct kvm_gfn_range *range,
> > > >                                         int target_level,
> > > >                                         bool shared,
> > > >                                         bool cross_boundary_only)
> > > > {
> > > >       ...
> > > > }
> > > >
> > > > And by using this helper, I found the name of the two wrapper functions
> > > > are not ideal:
> > > >
> > > > kvm_tdp_mmu_try_split_huge_pages() is only for log dirty, and it should
> > > > not be reachable for TD (VM with mirrored PT).  But currently it uses
> > > > KVM_VALID_ROOTS for root filter thus mirrored PT is also included.  I
> > > > think it's better to rename it, e.g., at least with "log_dirty" in the
> > > > name so it's more clear this function is only for dealing log dirty (at
> > > > least currently).  We can also add a WARN() if it's called for VM with
> > > > mirrored PT but it's a different topic.
> > > >
> > > > kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs() doesn't have
> > > > "huge_pages", which isn't consistent with the other.  And it is a bit
> > > > long.  If we don't have "gfn_range" in __kvm_tdp_mmu_split_huge_pages(),
> > > > then I think we can remove "gfn_range" from
> > > > kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs() too to make it shorter.
> > > >
> > > > So how about:
> > > >
> > > > Rename kvm_tdp_mmu_try_split_huge_pages() to
> > > > kvm_tdp_mmu_split_huge_pages_log_dirty(), and rename
> > > > kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs() to
> > > > kvm_tdp_mmu_split_huge_pages_cross_boundary()
> > > >
> > > > ?
> > >
> > > I find the "cross_boundary" termininology extremely confusing.  I also dislike
> > > the concept itself, in the sense that it shoves a weird, specific concept into
> > > the guts of the TDP MMU.
> > >
> > > The other wart is that it's inefficient when punching a large hole.  E.g. say
> > > there's a 16TiB guest_memfd instance (no idea if that's even possible), and then
> > > userpace punches a 12TiB hole.  Walking all ~12TiB just to _maybe_ split the head
> > > and tail pages is asinine.
> > >
> > > And once kvm_arch_pre_set_memory_attributes() is dropped, I'm pretty sure the
> > > _only_ usage is for guest_memfd PUNCH_HOLE, because unless I'm misreading the
> > > code, the usage in tdx_honor_guest_accept_level() is superfluous and confusing.
> > >
> > > For the EPT violation case, the guest is accepting a page.  Just split to the
> > > guest's accepted level, I don't see any reason to make things more complicated
> > > than that.
> > >
> > > And then for the PUNCH_HOLE case, do the math to determine which, if any, head
> > > and tail pages need to be split, and use the existing APIs to make that happen.
> > 
> > Just a note: Through guest_memfd upstream syncs, we agreed that
> > guest_memfd will only allow the punch_hole operation for huge page
> > size-aligned ranges for hugetlb and thp backing. i.e. the PUNCH_HOLE
> > operation doesn't need to split any EPT mappings for foreseeable
> > future.
> 
> Oh!  Right, forgot about that.  It's the conversion path that we need to sort out,
> not PUNCH_HOLE.  Thanks for the reminder!
Hmm, I see.
However, do you think it's better to leave the splitting logic in PUNCH_HOLE as
well? e.g., guest_memfd may want to map several folios in a mapping in the
future, i.e., after *max_order > folio_order(folio);

