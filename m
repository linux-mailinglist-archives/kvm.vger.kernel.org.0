Return-Path: <kvm+bounces-51290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F39BAF13D3
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 13:27:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 217253AC10F
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 11:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AAC92620D5;
	Wed,  2 Jul 2025 11:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WNljf7WH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899A112CD88;
	Wed,  2 Jul 2025 11:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751455625; cv=fail; b=bOSjPMxYAE03Em95r6Im848I/YqwhG3Zz/9MT0Sh2Rqx7TJwDdeo0KMKDjNqea0DFRQamVC9nndKG+x2wfZwWUYZYG2AX8k7q+epx0gRt9YSNIdlzi9FMukT0ubZs9iHRv2Fxfpx0iUSc5ytVLYKf6mW/JZ1KsXhhWCMWdt1OiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751455625; c=relaxed/simple;
	bh=5SlkUZa24j9x/u4XcYjId1v4MeDwI/hEUr4KsjlHwGs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=h5VUjsQY3v77ggBilhFDCFP1F+SuSWghsUWQp6/W2hf10gaIh2NlEvBkcITJOkDjTGUO0F8QpGdXN/oIPTQ4cEET+70h/NcueW/X89VMBZAkkXr2186dg3C5f5X8y2NLcpQcr4Wt8rsQyyEhbYXfw8snQAYnA4/51kIV6U450O4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WNljf7WH; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751455623; x=1782991623;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=5SlkUZa24j9x/u4XcYjId1v4MeDwI/hEUr4KsjlHwGs=;
  b=WNljf7WHPwSXenZBBI6nhHXY3/1HXZesR1xJtkCLPrUw/s2Qi4ou/cE0
   r+Ia8dPf8Ga9cP6se8rQOGd5BFp2oREbGE71SywhzUkU9Fv78zRV8khfG
   bBWUkvXQsIjd1uqTZr9JMVq6Lney+P0533rMfcESWKWkRQ9uicVAaqSva
   fUs0IwbVkY47kNBBGiRRHryn1GTgLMIb0tkpVhJuGVkCKy99qwmRDxKpL
   l5Sduf30MDOyOxZzO7x+MVEXGtxw0YtA3//EguwV7HGTHkSiy84Q9TCJm
   U5ddKoe1XLHR2rur941xFDcaDAwbiNClWly/aLYoGgNDLzqlNNuRXBvvW
   g==;
X-CSE-ConnectionGUID: uwb7vhMXQpm7naZWVZOMOA==
X-CSE-MsgGUID: vG4i5OxgRdaPf8nHs8laPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="64439339"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="64439339"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 04:27:03 -0700
X-CSE-ConnectionGUID: tWEg9fsCScKWh1aYsGlgXg==
X-CSE-MsgGUID: wn661eNeT7iyg8X+T52D2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="177726540"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 04:27:02 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 04:27:01 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 04:27:01 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 04:27:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pZwa4JtBI9ibiUld3mUsp8Sg5H0RFo8EGdNIsNRkdxRfs7cJZKkYRKT/BVMrBJDbO+0K2eoaDjvu1Ea7wVyLToUBNNWY6oVd7OEbtxaU1Ymt69iP2KVRvZs7HSu3bq0H1vd4+nRT8gtYCJrBZDlIL/cVNbaDoHQQotm5HXQF4YK+SWts5uiLW0R8h8Iornp72ftgW1evjDAOedUA14twlzy30eACug7BeXyA1s1N610lNoxwNUrVQn1tGo0/tk+3oYjNt7t9q304MBxmg+MmJLYqI56rrSrCSfp00VhePSsNrFAHk7ovYVMxXnRfZynCzBpxC3tO/E3LgSna869cnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zD1v0IIFy5KVp+G/sQnZDZJ0rJacj8U9RWhvXJuR23U=;
 b=F2xU1Rydfe8QtKdtKTLnFPPzBs0g8f790XMJfjMKWgUnUIlFUEQcjSjDHX1bi7deZmE4r41s/PoQourF7uK5cJ/IKLCLdS0XK3wpTLlDySJugz83xq6JeRxjMuPB+M4szMl3NTRfkN5Jng3HEZ/oKLdWJ/yeKLViPH4PcQeD0CjLVre8CNLM4kpe3IJAf0txrLWmJnrUlmrdmVdw3P1KLiVQ8RWstzUU1zx64OY07T1FhYsJKMC9CBgEqLbMd7pOCYB/t5uQEqEknypHfkTRUuZfCdMmiaQ3J0ntWaRqz9e2oO3jte1n8Cu2kURbZJst2lKgWVs4yz9LgyLD58tRkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA2PR11MB5068.namprd11.prod.outlook.com (2603:10b6:806:116::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.26; Wed, 2 Jul
 2025 11:26:59 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 11:26:59 +0000
Date: Wed, 2 Jul 2025 19:24:20 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: Vishal Annapurve <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "Du, Fan" <fan.du@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aGUW5PlofbcNJ7s1@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
 <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
 <CAGtprH-csoPxG0hCexCUg_n4hQpsss83inRUMPRqJSFdBN0yTQ@mail.gmail.com>
 <aGN6GIFxh57ElHPA@yzhao56-desk.sh.intel.com>
 <diqzms9n4l8i.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <diqzms9n4l8i.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: SG2PR02CA0029.apcprd02.prod.outlook.com
 (2603:1096:3:18::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA2PR11MB5068:EE_
X-MS-Office365-Filtering-Correlation-Id: 58d68f75-4d93-4d72-6f7c-08ddb95b5bda
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TnlTR3dXb0tEVExmQnBjdGdJOHFrZGN1djB0azBLUkpxREtzME4rNUdXMnlQ?=
 =?utf-8?B?UllGZHg0UWxOTlJXT1hPcGJsMFVVdGtEK0dLcXFzWWhWUittbkxsNTZWUVl6?=
 =?utf-8?B?Nng2TmZlYXdNUWhxRUdUb0pkTlFnNjRMOXdMTUlSMTE4VlhGOUFqVk1XaVpL?=
 =?utf-8?B?UlF2NjQrMllhQ3BKVXk5TWh4YTVodVRXRnhiNFdmZlN3bzZCV3BPdTZiSWE2?=
 =?utf-8?B?NFNncW5oVUloRjI5ZENNcVhKWXdTd09Ia3NJTTlzWnU3VE82RHprbkVhOVFp?=
 =?utf-8?B?L0ltTkZZbnR3YW56bk0vVmN1Q3RHeitEWDhGK0xvRWdrNkVXU0puaTIwN2pn?=
 =?utf-8?B?ZWU3M1I4S0h0b0VKVGkyTkExd3JVOEEyOW0rK1pqNHcwTGhtZ1VRMFV0RDRQ?=
 =?utf-8?B?ZXNOOVJocG5pSTNIY1VvTjdrei9TV0FJTlhHZjFEQmR0KzlSTHBJTHJXckRy?=
 =?utf-8?B?RURabjJSdlZSVG9zcHhnNGw2SHhmMWpYUU5HVUlCV0JhWkpacGxrZnAyQm94?=
 =?utf-8?B?STUvbmtRSExvaFM3eDhCRTNoeFczWHI5S2tNa0lmejlMNmpjME9VSjg0V2VY?=
 =?utf-8?B?OUtmOUVBcXVTazNibUhkZ05qZEEwdTc5bFhCQ0hlZzlCeHhrZk9hNHkvYytD?=
 =?utf-8?B?VDBMYm1iUnFnZ09vQVFGY21WSnc5ZTEvcmtYVDRoRXJUNmEzTHg2aGQ1ZGRF?=
 =?utf-8?B?MnJ1bXpwV1F0UFkzOWNJTFdlbjAzbk5JTzhNRkEyV0d4VThwSWZHVDdUUHVY?=
 =?utf-8?B?cWV0V3kzZFg1aDNtanZKNEtlMURTYTJndHFiSElyQjhtVzRVbnQyaTJPNFNm?=
 =?utf-8?B?S1ZwZTBVR2dkbFgvOUdmM0VPQmdDc2NKQUU3Q25PZk5sbUxRaWVDT3VvRExK?=
 =?utf-8?B?eXpxOEtVWm0raDk0OHNMeGNTcmFsOXBQZGl3b2g5Q20vbGRJWm8xWGNvU0pX?=
 =?utf-8?B?ZzRuY2k0QXc2ejlmNXVhdmwyMVo2djFYU0xxZ3hVT1B3eFBRYzViRDR5TGY0?=
 =?utf-8?B?VXpWTHBZbWcxMThRNGpoSjZLOVpidlRRT25PZTFUbGR1azVrdnc2ekE1MHVj?=
 =?utf-8?B?YzlOZzNBS0c4RXMxQUNsUlZXeW93SXhGd3JyeE96TW5VK3ZTM2RLcyt0b0Jo?=
 =?utf-8?B?Y1VyeWJVeFo5MjE5Ym00ZGpubllTVTJUTEhGem1POWdUL3QwNGJtSzdVcm02?=
 =?utf-8?B?Qk1iNkJOWElIYUtqcyszRU5jS3dDUmhiK2Mrd3dFRXBPVHFld3FveHBBNlFW?=
 =?utf-8?B?MGc1NFdJUHdQSld1N0pPMG42VlNKZXpaNGpJSE5pUENrek96NjJKN1Awb1V3?=
 =?utf-8?B?N3VqSVp6NEQ1Vk12TWZlTmpHKzF0dGgvazFsSTFnQ1Fidk9iTGFiSE44dm4w?=
 =?utf-8?B?cTZidnZpTHB6UU8zK09WK0dhT2JDVnNud0NkTmc1NmhqUFJzYmxYS1RQdHA2?=
 =?utf-8?B?cG45NTRMYTBmRThFU2xLOEVCdnhqVG5kNExER1JGMExPZHVERVlleVpIOXFu?=
 =?utf-8?B?VWZqa2ZZaTlxSjVGTWIrMWdEN3doTEV4bXk2RXVuTVZ4OHpHZDBibXZPaEtJ?=
 =?utf-8?B?dG85TjFBNWNFaDdJMGpGanlrazIyaktKWnhadjVhNDhSRm9hOFdnT3BRaldr?=
 =?utf-8?B?UzQ5cmFpcjV5QUlwQVlPL09XR2JzeG1uZTlrZUJmaTFvR0RpNmlnd1h4dHNN?=
 =?utf-8?B?Mk1KWnFBZW5qNkY1THF6QUVZRy9HVnpCVFJwZ3grdGl6c3d5WElrSEI5M0Fq?=
 =?utf-8?B?SGFDektyeGZoTjFRdi9wbVErWEUyMEVROXhzRHprenJxVENySHdHK2FRbFlk?=
 =?utf-8?B?Ym9lb3JjRGZsYkVCU2NUdzF5aWRmd2pwRHd0UXJxcjh5L3FBcmNrMDJuUHdP?=
 =?utf-8?Q?CDOqK6EPZaqpW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTRLWDcyL291UDVMTVJ1azFvOTlUMGo3UkxvVTdxK3l1dkxCTXR0SWFpTXhq?=
 =?utf-8?B?Y3hpMjdGaGE4ZjRsRnhtU2RsYWVHK3dTQjRtakpkQ3BvU21Mdm1xZVZVTWVM?=
 =?utf-8?B?M3lpTkdsOGt3citISnhwRHc5b01EaGVGVDBtK2JIbDhGaVV2L1RCNkF6cjNO?=
 =?utf-8?B?RWk4dlFsNjlLVk1jODFwVWNVY1pmRGNILytVRHEva2ErY2R2bnV0TnBGaUpK?=
 =?utf-8?B?Z2ZONEFjOFNoSC9wUnhLM0hHbnpVMFNiYXdQY3FoTVZFcTJ1WVZzVmtLOHZ5?=
 =?utf-8?B?ZFE4ZHIveFJxdEhkQ2QwTW5CSXZFdGFscFh3V3RsQlpPb21Dd1ZySU1TWklh?=
 =?utf-8?B?ZmxDZGxtUHRJS014ZS91ZkFqMnk0enp0NTlLaFhuOS9ra2NYZzlQbFBFZHJp?=
 =?utf-8?B?T3hScnN1dk9uY20zZUcydENreGtkY04vUDl1dmk1K0FtaGdYbzkzWi9JS042?=
 =?utf-8?B?Y0thY3NsMkx0MWh2WWkvUFFkZHVmUzhkMUZ0My9IejZTeitaUXlRSTl6bEp6?=
 =?utf-8?B?SktiZUtBM0JtT3ZvbWFJK1dzc1djSkRBbEVVbGtvVHhKU3VHcXhqK0hIa0dG?=
 =?utf-8?B?QlUvR3FRZVY2c2Y5YXJRU3pjdDJ3cDcwNC9WYWROdEpMUm1YSy9wMHZJR2tX?=
 =?utf-8?B?RjJnRW1PSHU3bGdzOCtDQVFXQ1V1aGVMNXFvakw2R0JwLzgxN0hjZ1FyVXp0?=
 =?utf-8?B?VHdoQnVzbTlmK3BaTzBGY01MN1J1S2hZWkx1KzRqK3dRYVppZXNIUFY2cG1j?=
 =?utf-8?B?VEdKdldZaERwaDA2emlpRzU3SHFFZmRzN1pHcjhsZUZrNC92NmlFZFNtczVT?=
 =?utf-8?B?QjMrcU10SFhnbWpOTnFPelVUc0E0cjY0QzNJTWYwcFUwNFYxanNHS3cxaGJE?=
 =?utf-8?B?NnVRVjlYQzhBQVJmOEJ1VGJ5cjlPQWcwSC95L1pFUE0vdWZDVVE5aHZRbWtM?=
 =?utf-8?B?OHYwUzRSU3R1WjdPbzF2UGJYU0RrWWVkSjFyc3dyYUNTUWNWa1I5elBGaU5u?=
 =?utf-8?B?RWxpNHR6RE5pbm9xd1dFTjdZbURWbTJlVzNmYmhyTzdwQmRuSXlndzJHMDdp?=
 =?utf-8?B?Vy9sWTR2clZuS1ZXZEZvRFI1UHBEa2RHQURmdlFKN0tDdld2aVlUWkVKT1pD?=
 =?utf-8?B?VlQxU1ZOMWdicFlUakJsdUZpVkZpZHBwN2YzdDFKT0VaZkU1ZzVTaERsQ1lm?=
 =?utf-8?B?SEV5YzRsdlpmRGhRZFgvdTJZbFhYUm85OURkd0JPaVRiOUtuSS9iUzg4OHZL?=
 =?utf-8?B?L0lOOVo0MW5lWHNIZFFhWnpuWWJuTkc0Tmw5Z2JGNjZld01Ea2ZCb0RvNmF3?=
 =?utf-8?B?bVFXUGxzNGcxd0sxcFZWR3NPUzcxRDRQTnZXMWxPSVRuR3FnTjVqVUp0WXV3?=
 =?utf-8?B?bUl3bkZ5ZUtDWWV0bk5rS1RGQzExeUlKeDhRblNBRnAwWmtHNVRZanNSQUdJ?=
 =?utf-8?B?ZDFVUnFBYlNYQXhKMkZuRXZCa2JDVVJ2dUtTemtKOVpQanRocDJLWnI0d01t?=
 =?utf-8?B?d1hxTUoxRzI5QXZyU2JJYXV0VXY5aWJkYXZ5NEhKRmo0Q3QzRGR1UHZMam1I?=
 =?utf-8?B?QXNVOGR5blNvOTU1OFhjRU1XSUxFNnNvMFRrUmxyc2ZxU05zSjBVSTFBNEZE?=
 =?utf-8?B?ZVlVTVdtYXdFUkJudE5oZHo4L0VBR1JaWVJXZUU3QzdOTUxGYlFTRW8rY0xy?=
 =?utf-8?B?Z29TMVNLZUhyRFJkQzBIOE5vWTNJNEZLOVVDQTVoaW5ocXN2WE4xbUtvSXJP?=
 =?utf-8?B?THEyRXM2QkQvdWlFNjFvRjZRMHdndmJraEdleEJkSjhENkZEeHB5dC9IOWdr?=
 =?utf-8?B?SlJ6NUh1OG9YRlcyQnhUT2J2WXJBUjlNTm5wU1RLbTlvMEhxR0VDbk9oRHFL?=
 =?utf-8?B?cTNocEtCQU5yTlNTZ1MvaFUrdDFKVDFiaDBqZHdYUFlXR0FiTDBJR2lIdTFt?=
 =?utf-8?B?SVB5Mm1HakRzYzUvTFJYMzZhWUNSeDBqV1kzcFcxQlJublVham5aVFc5WURL?=
 =?utf-8?B?ZGJ1MGY1d1JJUVdIZ2V5eG1OenFSWWptVmF2V0Z2a2V4SzhKb3FJcFhsY0RD?=
 =?utf-8?B?V2NIMXNKenZZRVM0SWRTSzQ0S2EweXE5TDg4UHNXK2pLU093c0tkcE51cldL?=
 =?utf-8?Q?GoDvKZd6ryCYebaBI5mIz7Lho?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 58d68f75-4d93-4d72-6f7c-08ddb95b5bda
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 11:26:59.4134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: liMeIeTo/sjkWh0zno0phNRWpJwshdcCyVoN+YQLqZZSI5HnDa7Sh9f/JQPfy9NtbZUTqgjlKPoK3siu1IjQsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5068
X-OriginatorOrg: intel.com

On Tue, Jul 01, 2025 at 03:09:01PM -0700, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> > On Mon, Jun 30, 2025 at 10:22:26PM -0700, Vishal Annapurve wrote:
> >> On Mon, Jun 30, 2025 at 10:04 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >> >
> >> > On Tue, Jul 01, 2025 at 05:45:54AM +0800, Edgecombe, Rick P wrote:
> >> > > On Mon, 2025-06-30 at 12:25 -0700, Ackerley Tng wrote:
> >> > > > > So for this we can do something similar. Have the arch/x86 side of TDX grow
> >> > > > > a
> >> > > > > new tdx_buggy_shutdown(). Have it do an all-cpu IPI to kick CPUs out of
> >> > > > > SEAMMODE, wbivnd, and set a "no more seamcalls" bool. Then any SEAMCALLs
> >> > > > > after
> >> > > > > that will return a TDX_BUGGY_SHUTDOWN error, or similar. All TDs in the
> >> > > > > system
> >> > > > > die. Zap/cleanup paths return success in the buggy shutdown case.
> >> > > > >
> >> > > >
> >> > > > Do you mean that on unmap/split failure:
> >> > >
> >> > > Maybe Yan can clarify here. I thought the HWpoison scenario was about TDX module
> >> > My thinking is to set HWPoison to private pages whenever KVM_BUG_ON() was hit in
> >> > TDX. i.e., when the page is still mapped in S-EPT but the TD is bugged on and
> >> > about to tear down.
> >> >
> >> > So, it could be due to KVM or TDX module bugs, which retries can't help.
> >> >
> >> > > bugs. Not TDX busy errors, demote failures, etc. If there are "normal" failures,
> >> > > like the ones that can be fixed with retries, then I think HWPoison is not a
> >> > > good option though.
> >> > >
> >> > > >  there is a way to make 100%
> >> > > > sure all memory becomes re-usable by the rest of the host, using
> >> > > > tdx_buggy_shutdown(), wbinvd, etc?
> >> >
> >> > Not sure about this approach. When TDX module is buggy and the page is still
> >> > accessible to guest as private pages, even with no-more SEAMCALLs flag, is it
> >> > safe enough for guest_memfd/hugetlb to re-assign the page to allow simultaneous
> >> > access in shared memory with potential private access from TD or TDX module?
> >> 
> >> If no more seamcalls are allowed and all cpus are made to exit SEAM
> >> mode then how can there be potential private access from TD or TDX
> >> module?
> > Not sure. As Kirill said "TDX module has creative ways to corrupt it"
> > https://lore.kernel.org/all/zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki/.
> >
> > Or, could TDX just set a page flag, like what for XEN
> >
> >         /* XEN */
> >         /* Pinned in Xen as a read-only pagetable page. */
> >         PG_pinned = PG_owner_priv_1,
> >
> > e.g.
> > 	PG_tdx_firmware_access = PG_owner_priv_1,
> >
> > Then, guest_memfd checks this flag on every zap and replace it with PG_hwpoison
> > on behalf of TDX?
> 
> I think this question probably arose because of a misunderstanding I
> might have caused. I meant to set the HWpoison flag from the kernel, not
> from within the TDX module. Please see [1].
I understood.
But as Rick pointed out
https://lore.kernel.org/all/04d3e455d07042a0ab8e244e6462d9011c914581.camel@intel.com/,
Manually setting the poison flag in KVM's TDX code (in host kernel) seems risky.

> In addition, if the TDX module (now referring specifically to the TDX
> module and not the kernel) sets page flags, that won't work with
Marking at per-folio level seems acceptable to me.

> vmemmap-optimized folios. Setting a page flag on a vmemmap-optimized
> folio will be setting the flag on a few pages.
BTW, I have a concern regarding to the overhead vmemmap-optimization.

In my system,
with hugetlb_free_vmemmap=false, the TD boot time is around 30s;
with hugetlb_free_vmemmap=true, the TD boot time is around 1m20s;


> [1] https://lore.kernel.org/all/diqzplej4llh.fsf@ackerleytng-ctop.c.googlers.com/

