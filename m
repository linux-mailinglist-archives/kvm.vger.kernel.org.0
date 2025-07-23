Return-Path: <kvm+bounces-53269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51ACBB0F749
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:42:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8AA297A327E
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6391FFC5E;
	Wed, 23 Jul 2025 15:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kT8Hn4LH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7571EB5DD;
	Wed, 23 Jul 2025 15:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753285330; cv=fail; b=MtRFEJzPEkHhoo2OwHuskSdtTrKYu24szHDQfl4VFSg4MRjtZ/1rlhDoJ74UyaHukGhneNsLX6L11F9eYgduPn9gAiGQboSO47+AD5TE30+vvlz4zMae/PdgkF//1mwVvMO6aDc8o5uNbYWHBnegv8SlxT4srv6+FXVowQ1LjHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753285330; c=relaxed/simple;
	bh=av2gQ4qqNKOeGUF+wlfFVpjegl3tDYkBEwGUJuwyVHU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O/sVcrN/AHiOgATmKS8gmgLv5/PbZmVQQksydHsdUgM1KOlIMYaKDD99BYkqf6+EtAv2Yy00KHtRnJ3rrLXLSGaxod2Yddqrok0iAXLKv0J1aY4VeGj2mdgrAh0HR1cZHeXmkkzMa3dd1ytGY+FhMPOuFjgHthLGAkkuAUEe4sQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kT8Hn4LH; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753285328; x=1784821328;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=av2gQ4qqNKOeGUF+wlfFVpjegl3tDYkBEwGUJuwyVHU=;
  b=kT8Hn4LHf3fzOWfWGvWwqpKSsumg0Vw8kF+V8prABziehCKbASlEvGNA
   XP7FJl4gNj/x/SpBt62SCj9VrAYHCVY3L7fKuAkVYl/lReZELSIZGWGPC
   IN20aHISYl0Gk7SCv/8ebJkCFIt2G7UwS3XtVDKeEjICLkBAwQvbEYA+j
   PgFJK+eTHk7jzDhJFKWXwDwx4bRK0C5WwxkrhEVgIEyrXDrZ5N0C26Qqm
   61zNHFkBy3iBsELfMBBBHQPxlMIctNW8OhJ2SIs3p6domDJOq7EvHQFtt
   eSbTxB7Gkr9TNpbSdyNaFTtD+29KuAMfR/lkwR65F6Rr4MBdBuy4H5MpE
   Q==;
X-CSE-ConnectionGUID: xVk8XFvWTreNLBibdiumlQ==
X-CSE-MsgGUID: ORcNrqTyQV6HRjnbrHie0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55727144"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55727144"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 08:42:07 -0700
X-CSE-ConnectionGUID: gtPTJQP8TwaWbip6rizZwA==
X-CSE-MsgGUID: 2pMHwlyKQ+6F7RuZXY5kDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="160325392"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 08:42:07 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 08:42:02 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 08:42:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.63)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 08:42:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RCq2EWPM6EVk5lw/YXuwWWT0KPxC3oDGs5QX4s9DcFcGDFtQ1+74CZ2iyRjvssA1wTlyAPTR/fItxFKz1W5/6ioAVuHWVi2kPPbwLgEoBQTvJ27gMrccUXAo6B/ZNPEQ91FkcCiEqIrraYJjeLpv41eTHOLlJv9U1S/QSOa3Nve0bRPf/3ayhC98106mVuZvJAZWNqyjdaH/9FzovZkL7iH+r6UHT93pr8svnC15aSbXEIv1lAvtAQmuNwAuh0qB+CxniQK+px21kuTRdGNexhRSDMVUnKggcd+FWXsYLFY/ytH+dpZWWqOmaZmozLy7Vn8j/ao194pJhVDazPOt2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzM/uI6VRyzup9Ta2mjJa5NBx4eG+T3A03QJu9ZQTM8=;
 b=GA8Ve+ufpETGuJPhtGmvaoLlX+6Nd1si12+juohNlSbLNR83fyYKX0daH2nwHTxmedECfuxemnTqZUaGMJCWBVb24f402ysGeyWO7BWoSYsg7m9YxVlOjmYjn9L5lzRZp8wbO68+WM8wL2KZRkjfN1gLDEz5FeUz2nQqim+Fa//r/1fzxpguuTe8XnJjkSXEkR4U01N5YbadSqOyS9K1KFkY4rcffBHXat0iXf3A4hOn1aJWRMzhtzijk4huigJ4iyKvnNxAnFmML4WPQT2dcIMqR70lOOooVckNJqin7YJqFS9Db8uUJGV/ORd1bxgTBLrIz7XlAzbpAg4AQh2WDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by PH8PR11MB7141.namprd11.prod.outlook.com (2603:10b6:510:22f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.32; Wed, 23 Jul
 2025 15:41:57 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.8922.037; Wed, 23 Jul 2025
 15:41:57 +0000
Message-ID: <d51c28a3-bbaa-470f-a07a-5706cb5a4b90@intel.com>
Date: Wed, 23 Jul 2025 18:41:51 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de"
	<bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>, "x86@kernel.org"
	<x86@kernel.org>
References: <20250723120539.122752-1-adrian.hunter@intel.com>
 <20250723120539.122752-2-adrian.hunter@intel.com>
 <f7f99ab69867a547e3d7ef4f73a9307c3874ad6f.camel@intel.com>
 <ee2f8d16-be3c-403e-8b9c-e5bec6d010ce@intel.com>
 <4b7190de91c59a5d5b3fdbb39174e4e48c69f9e7.camel@intel.com>
 <7e54649c-7eb2-444f-849b-7ced20a5bb05@intel.com>
 <6d91fc951cd39110db8f9b5565e88dba39eecfcc.camel@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <6d91fc951cd39110db8f9b5565e88dba39eecfcc.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0158.eurprd04.prod.outlook.com
 (2603:10a6:10:2b0::13) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|PH8PR11MB7141:EE_
X-MS-Office365-Filtering-Correlation-Id: 67198c45-6986-4aa7-1116-08ddc9ff7505
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZUYvOGtNZEZZVGdYL3NBRlEwcUNSTTF2T0R2aXEwTG5sbk1ydE1CQkRsdDJa?=
 =?utf-8?B?WXlvalJtdkVoWHR1Y3ZTanBmRUhIWExaejlOYVoyQkIzbnlTNGUwcFpwcGNo?=
 =?utf-8?B?YWxtSHQwSzdMRDZ1dnErWVRNNzdLK2Y2VDhNUGo3VGxaWXF3MnYrZm5uc0VC?=
 =?utf-8?B?M3pTbkhTRXhqVERyVCthaElFV0JjRDZlMDJQaUp5ZExhbFhtbTlqYnMvK3ds?=
 =?utf-8?B?NTJIajY4SWc4OHRHM2FVM0RwM3lURVFDK0l4Q1ZPQ0ZlOWJ3ZzBHVG9ZMDFH?=
 =?utf-8?B?Z2s2blNFSEpHcWh5cVdnWlRPVlE5Q1lqR1Q2N3ZUMVRZT3RrY2pNelpiOWFF?=
 =?utf-8?B?a1FwTEk0ODVFa1pWb3l2NmluMklKMnNyenNuYTl1MzloWW5wVXluUHNaTWNN?=
 =?utf-8?B?bWJWdWczN29iWnNKZjlwVWIrYjhnNGlEbjJuWk1wSnNOSXQvRHFLNGFZcmFh?=
 =?utf-8?B?Ym1Hd3hla3k0bk0zWXFBclU3Z1NPTTk1ak0rTXl4cTJJSEhmZVBPRFA1Qjdo?=
 =?utf-8?B?TlNJd3VzQWN1SUpaMlpiTjUrU2k2TWlsMEI4cEVDUDhaQjhuNVhzSGgyOFZO?=
 =?utf-8?B?UE9hY3M1cG1VcnF0bUNJa3cxVUQzRFBCTGh1S0x3b040OTQvVFpMYUR6R1RM?=
 =?utf-8?B?ZkNGQTZLM0xlcU1wbnkxM3F1K1VsZXJ0Y0FPOENwd1N6byt3Tm1zVXNjSVJm?=
 =?utf-8?B?S09kZTlEOWZ6ZmpKSEx1WlUva2JPMlFoWTdQV3pWRkdPUURjUitNSy9Nd05q?=
 =?utf-8?B?ODgzK0NlcDhZb2ovenV4M0szSHdVOVNsWU9lRU1uUEI4U2JyS01iYnN6NnhV?=
 =?utf-8?B?bDIxcHlHVXpYSVRtVFdSZUxHSzM4KzF5N3NsQ1g5NGMrbWFacmdiVXkrVDVz?=
 =?utf-8?B?dEZTRXNMUzZPRHdsYjQwd1pjYTdUOW9pUlc2V0FQMGs3emtQMy84b1NpZVhl?=
 =?utf-8?B?Tmc0UnlXVEl5NFNqNk9pcUk1V044YklQbnhLY2dFMG9BRkJKVHB4SDltOHlF?=
 =?utf-8?B?RTNZaGJvR2hLTG5KWmxpaEpkeExURlRtUnlTZEpRa2FCRXpuaHZPZ1JuSGJi?=
 =?utf-8?B?L2R3REE5T1FTTFdzdExvOFRLSW16b0drVnpBM0xsRThxSnlSZGJrK29Ndzk1?=
 =?utf-8?B?WmlST1pMWVc3MUpRSEN3SWxoVW5INUdldWlyMENWN0o4QkNNdG9GSHNLdVU5?=
 =?utf-8?B?dGRLUW01MTRMd0lVbGpkb0p5UHdqb1psdzd4UUpDQnJTN2RWMk5tK284aGh5?=
 =?utf-8?B?c3hoUi95eEo0TFBHSlcyM1JoRTNOVGs5QkU2QUFZV24xa3k1OWJJU1hHMW54?=
 =?utf-8?B?akt4T3NPdTh3M1VPQU1PSWd4R2RYeXgwc3V5WWpBL3BlcFZjRUthQ2VxWHQy?=
 =?utf-8?B?dXZYdWlWeHFQdTViaUVLcUNkN0haYzNKRVJYaVkxRGlYRDlHeFAvR3BrV0Zy?=
 =?utf-8?B?eFN6amZ4Z2RiazNxSjhRb25RWkRHL2p4ZHJmNFR0QkRPWXB1WWVubXBlVmp4?=
 =?utf-8?B?QkhoK1NPSUhZSGhWaWlLNjRyZk16Vnk0R2cyZ3pPemYwWVNvT0dVTU1EWGtZ?=
 =?utf-8?B?cEpCRUt4b2ZaRDRaZjRmeVYzRXU4SlVQcFAwM3pZeVVRTGo5cjR1Zi9waDVj?=
 =?utf-8?B?c1VjZjFYeG5BNWJQS0c3SmluWXY2UDJvTGorQ0VhSTFvbW51VVUvQlNmVjdp?=
 =?utf-8?B?WWtpZElObm9YVDNrSXVtNk1YNlJZYk9pWGdpMXNsTUJvMlBmTWZqS0JCOFhS?=
 =?utf-8?B?cXQ5MG14Njk4Mk81STdPcEYybndNL2Q0WE5FajA0NEEzSzVLc1h1NFpjWi9s?=
 =?utf-8?B?ejFCZ2pGUjhCTkVRQ0ZIY2JyaGRZTHEyOGR5UTFWbERORGorWU5CSm5wL2hm?=
 =?utf-8?B?clYrQStSOHhFQVJ5di9zdjNydzJTaUZ0bDBmZUlkLzRLTEE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEFRaVhRWlp3U25sa3RVVUNWcVFqanlOTFNzaDF6dmsyWXBMN0pJQjVxd1pU?=
 =?utf-8?B?V0lraVNCN1EzanovaFZnNU5DVHhqaHMwZzdYREFzbEU4NEp6M0xiNnZzME9J?=
 =?utf-8?B?NXhTRkZYZXErQ1RMWVRqZ3JpM1d5elNCMHM0RUxYdW40VS9kcGJOZVc2YjRK?=
 =?utf-8?B?Vi9RQ1VBQzNCdHl6R2tqV0dzMks5OEZIMWx2MThTbFdsTk43YWFSbGYrWEZB?=
 =?utf-8?B?aU9qWFNKV1VMaHhXVEhwSis1dmN2Ty95NlJPZkxhQ2Jjbk01ZzBFK0doc3h5?=
 =?utf-8?B?S0p5d1RMN09MdEx3eFVlQ1Btc0x6Tkw3cHBTRDJZTjJwcHI5YjhmdVYvVnkw?=
 =?utf-8?B?U1h5Y3Y1MnovZjY3dFRYMEd3T2pCVXlCRHBzenlSUG9JVDFZMXB5QkZDditB?=
 =?utf-8?B?eWtLV1YzUDlKVmxPTmJYNDlPdzlKYmM1K3YzR09GYldSQU9JMzd0UVIzT0F6?=
 =?utf-8?B?NG96M3E1V3RHS29UOFlodDExQ3hpMGF4YVJydHZVeEdtR3NnOFUzT1REUG54?=
 =?utf-8?B?Y0JiM1dBZ1pPYk1zVm9TMkNhOE1OVUo3Nm5ueUpJeVFDN252OSs5Q2JscjFy?=
 =?utf-8?B?aGdsTjJydFRYM2JhOENXYXVhNGJNVk5JNS9VNGt6a2RXVFk0aXNycWVmMW80?=
 =?utf-8?B?RHhkRldVZVhsNG9NM3Izdk91MFVhRGVIWit1ZWFQOEk3Rm0zMU12THZMa1dI?=
 =?utf-8?B?WXBjTDRLb1JNNE10RzBtWkFaaklOZ1hiWGJvVmw4NTAvNVNuQWU3NmZ5NEhD?=
 =?utf-8?B?MlZJZUE4WUs1S0l2RzJKUmFlR3MxcWt3ZHQvaWlLdkdhT0drejdwcUYxYXJX?=
 =?utf-8?B?Mmk2T0N5VmhRbUFsUWZkLzUwelA3SXFmc1UzSGhHQ2Q1NmZBd1VRVUM3NlNE?=
 =?utf-8?B?dmRSazMyZ2VxNEdKemlPVDhsOU9WV2JhOHdkbWcrWUFIT1JiTXluZGJTQlVH?=
 =?utf-8?B?YjQxVi8rcVQ2SEdsblRzNjZDaHpvOUpRN05CVndJbXVMNFgreXlpY3cwZnVH?=
 =?utf-8?B?Wk1TbmZzYU9VVm9DMFdvMlVyODd2ODJaMGlwZFZGQjdjdllZak53YnJlWEZY?=
 =?utf-8?B?QlJ0dThiSkw2aG5iaDlwdHhyU01zcDd5TXFWRFlWbUxVNlAzUnVvVFBva0Mv?=
 =?utf-8?B?Y1hZU2JQQklscUNPdFdvMzZUcUxONFpQN0lkeVZlMmNvTkxZU0dPQXR1eXJz?=
 =?utf-8?B?eDdBVTYwM29IUGpuN0JoLzVQVVFZWkxuWmVvRE5vSXFIRVRLazM5bWVucVcy?=
 =?utf-8?B?bXhHWm8xNmJzM2c2SHZORXMyRUpzZmxUeVVHT1BIeGxEZXpXWDd0OGpTdDQ1?=
 =?utf-8?B?SHJMOE1GbEFPL3Jselhxd1RtRUdYU05KSFlaZ2c5cnQ2ZGpGYlo1azVqeCts?=
 =?utf-8?B?VHp1MVVtRzBzZC9xaHAzOHkrcFI4K2pzcVZPNG5VQ0I3TWdMSjVqSy9Jelk0?=
 =?utf-8?B?UUZ0eStCNDBqN0dXVDJ1ZjlGZDRzeTRHaWtJWWc4YzVkSUdJcGJXWGxnZitU?=
 =?utf-8?B?V0d5MlJYWHVpWUZka0ZJOU1rYVZoREdmVEpzZDBsMjloTjQzVC91TXZYcEZD?=
 =?utf-8?B?eEc2OWFwc05HQnNCekU4bTkzRnJObDRaUWgrUHZwdlRJTi9BVUFsRWU3d1pk?=
 =?utf-8?B?UWQ5dXdod2s2aDhKZXdBckFDSTZ0cEFYUFpQK1JUVXlwRkFhTmM3VkZEOGVP?=
 =?utf-8?B?SDhIcUZXT0xhTjZyTVBFdGlyV29iVS9NU3FERTUzZkIwUFhpQ0ZLVmM4L3NX?=
 =?utf-8?B?ZVpBNTd2S2VXMXF3NWR5aXU2Z0ltQ1N6QjRwbndvVU1USGZYUmxJSmd4YVZN?=
 =?utf-8?B?SldLQlNic2hEVHl3eTRhbGtVeUUrOGdDZGw5WS9DYjJucnY5bzdKWkU3TTQ4?=
 =?utf-8?B?UEVJajBPQXBSYmhjNUlSc2RDUTRoUm4wQnpVZ1VtNWhXbTBuQy9Xb1lFRDNI?=
 =?utf-8?B?V2xKNHI5VjZvOHJFYzlVVzJ3b2ZnY3JES0xuRUIxWTVQU21QaEVpQmhYZDlW?=
 =?utf-8?B?d1A3NHEvTE9NTUkzakVqUTFsdUNXa3c3Q1YrTTJKbjRROW1jUk5JaVh1a3By?=
 =?utf-8?B?YnZIaFFKbkQza09ubWNYNHNaYVVvNjJWb1NZZHBxWDJCRDd5K1EzN1BGMXQ3?=
 =?utf-8?B?enlBZFk0R3JaaU9ybzB4endQTllnblVFYnBIU2RNM3F5TDMrMUpmT0FaeHBt?=
 =?utf-8?B?L1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 67198c45-6986-4aa7-1116-08ddc9ff7505
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 15:41:57.6062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zgPxV/eXUgeNllNLl3slQXM6O+YonpJ+NQvC78M1xcemHL4uF614yVYVe/coz44B5gAI1oTTfJJmMJm4DSTMmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7141
X-OriginatorOrg: intel.com

On 23/07/2025 18:33, Edgecombe, Rick P wrote:
> On Wed, 2025-07-23 at 18:30 +0300, Adrian Hunter wrote:
>>> The log should explain why it's ok to change now, with respect to the
>>> reasoning
>>> in the comment that is being removed.
>>
>> It makes more sense afterwards because then it can refer to the
>> functional change:
> 
> Cleanups first is the norm. This doesn't seem like a special situation. Did you
> try to re-arrange it?

Patch 1 only introduced "quirk" terminology to save touching the
same lines of code in patch 2 and distracting from its main purpose,
but the quirk functionality is not added until patch 2, so the
tidy-up only really makes sense afterwards.

