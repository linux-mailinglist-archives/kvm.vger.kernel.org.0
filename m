Return-Path: <kvm+bounces-41170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A24C1A643C6
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 08:32:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1089318936C9
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 07:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A46A021B905;
	Mon, 17 Mar 2025 07:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F3SVCmqM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D7521ADD4
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 07:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742196751; cv=fail; b=ZVxYQYPtzn1RDyFmIxgeEk7scTSsvmdTwxmPLXpa0A1cIRhMEeRFLhyXjP/ye2vW5glgdUwaLiqp2Kwv2lSyhbQBvnzu1D7ZIQoVhuUZZOj4CMHDlRw1qkPDyOhxf54cdW3yHc3eX6W8m2JHVsXL93d2RlkLT4EPCGnk1xmsIRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742196751; c=relaxed/simple;
	bh=Wehjnmov28yZBzPdyResB+2tTv2KlSwhkyDEwLWosLQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eW+NiYI/HeK754ILiie7BJdoI7UOhDZrNfUSZQk52s2NQAKiDEUIHfn7rLKeceG5LQG0ytBUjgwoEH6WFtZEBDEf5SJWxEFDb5gK4GiN5YYgLvlmOQ/lbPZF2F2JQc4xVdeAgSE2u1KsCe6uFztRBLWEeYBdJ9mMp8AfJP496MQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F3SVCmqM; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742196750; x=1773732750;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Wehjnmov28yZBzPdyResB+2tTv2KlSwhkyDEwLWosLQ=;
  b=F3SVCmqMS4C2kBcT6XOpRMN+gSY7h0XLNV/7yEdu389zNgtfC1yp6dNZ
   /H5b2kv35GkGWgMXAn554TIpQ8Ay+Wwl4g8ufXE82bm6L6VuP4CbNXnaB
   ge/KnEz3/i4aTk2wKAGHgJHU/XEqUdknA0a2IRIQ5Yn6ByxGMbGcO+5cI
   XUUjsQN05IToFQ19sJSFIY9MrmKD9dgTgR9XdEH+MhydXRxRnTvjgdXJF
   vZWlKz2VGdQLBW2Ia/L1zn6bxEqqTgtQhl3F14QkxjiXS+QHuaU1ObvWM
   xIKQLU5j8A0vrn6V9n9iVVQhx14cQJb+FlvoDZpzfBZFXxQ4DURRIFj33
   A==;
X-CSE-ConnectionGUID: 6rgp3Pw3T6+WJRX6VqE3kA==
X-CSE-MsgGUID: 23P4K0k3R9ShZ7s66/9Vrg==
X-IronPort-AV: E=McAfee;i="6700,10204,11375"; a="54656842"
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="54656842"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 00:32:29 -0700
X-CSE-ConnectionGUID: D+1TgPnWTTeZELoE6wBxDg==
X-CSE-MsgGUID: NIudDcuhRomqSdmqJXTkrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="126056121"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 00:32:29 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 17 Mar 2025 00:32:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 17 Mar 2025 00:32:28 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 17 Mar 2025 00:32:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yWgIavBOPwGE7rTUGZZO+TvGiTjK9VPKEr3BZ4cSo72L5IbOaIv2VJ+2Fdje+Qf1porM8e6RNAIgw0QMoS8Mc9NaVOdg47o93d5oeP0zd1xe4MLaz1f1sepyii+9wYo/C+e409wK2YYYx7UJwNY+xwxaWNOIji94MbfvwFf4H7oUGp8YnD1KHv7n55D0wYLR6dKXzlI6+72Ev+r/bZ1GM1JI2ob+08W198okOz0ly6JBY7JBZ+FEkHbKlvUfkdF98kVweDrdezbjPGYsz5By1DFbizjPFsAd69711je3gqO7ccNUJ/AD45dDVa8U2hITYPu8fKZ+w4H3ag5dvWMApA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjXYdj0LwG/HkSrY/1s5OVOPPNVVaE14rA2i1UpAsH8=;
 b=LKWumabuC+ZLZQ5g8zPnl3gpjyMkKzlhsSY+u+cXfJY/r0d5FdaA101TBZrdTHhyuco0sdBKBoKC/kDZcC8xZX6p0iMuDIPVBXGefo54lrUOzDugq2q3D/2PfiJGXD1HHmG8fEF9ynU8Z2GsNRdXk884pYKCCNzmxQgwgo9uPItKkBLbXKal6lG921aVjafQuE5zvUyQ+s8AJepB7RiRxbujZehk9KB5mnqD/q7OuhqNvkwRnbNyZdn8RYtS2zQhityVv5TUz8IkNQU1lUaeAPemjgwgustluGHUiJWKnUaD/on+YwsFQ07ZfVUmOFRY3/PIZJJRdZ8SEtG3XSFJtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH0PR11MB7167.namprd11.prod.outlook.com (2603:10b6:510:1e9::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.33; Mon, 17 Mar 2025 07:32:25 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 07:32:25 +0000
Message-ID: <b158a3ef-b115-4961-a9c3-6e90b49e3366@intel.com>
Date: Mon, 17 Mar 2025 15:32:16 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] memory: Attach MemoryAttributeManager to
 guest_memfd-backed RAMBlocks
To: Tony Lindgren <tony.lindgren@linux.intel.com>
CC: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	Williams Dan J <dan.j.williams@intel.com>, Peng Chao P
	<chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>, "Maloor, Kishen"
	<kishen.maloor@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-7-chenyi.qiang@intel.com>
 <Z9e-0OcFoKpaG796@tlindgre-MOBL1>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <Z9e-0OcFoKpaG796@tlindgre-MOBL1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0189.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::15) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH0PR11MB7167:EE_
X-MS-Office365-Filtering-Correlation-Id: 706d583c-479a-4975-ea58-08dd6525dcfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WlRKNXdlc21jeUo5RzVEYTRNcW9CTElZSFVqS25GRmYvdDAzd01IaWQzaFNh?=
 =?utf-8?B?aXpBYVI1TVJSTFM3M09vN254K0lkaFR4SDlQYWJwZHhUNFlqdGNsMit5LzRJ?=
 =?utf-8?B?VEpqMWZSVTU3ODN1cFpBREt6ZDNmM3Q5Tm1WVjhybTJFRjFxdml3bXF4RDJK?=
 =?utf-8?B?NjRRQ3pQeVJ5OUp6OWNxN0thNWF6WENlOHI3RnZiVkErSWEwdVU1Wk5USEl0?=
 =?utf-8?B?Z25UK0NRS3hDYktqcGROTjJhWCtrdEZRNlFwUGF6cUpuZ0lKUjVoQTNQM0RO?=
 =?utf-8?B?dHVPNmJWZVZlNEdPckVqTmlFNXUvaFgvZ2cxN2lEZWtrblNZOVNqRHB0ajU3?=
 =?utf-8?B?TmdHL1ZQYm1ldTlGQzBwWUJqOER6a2h5M3MxVE42UVQxQUxZdStRenN3dXhi?=
 =?utf-8?B?bmJlNHUxbmg5TnRxWW9sTlJIcmZnTGpVbjhRYU1lUVBJUTlMVDZ1MGpzallr?=
 =?utf-8?B?WGFiaXo0ZEZZRkt4bkhTUzdKNHBvajlOVVp2bU5aSVRGRm1QWktnSlRFL1Vh?=
 =?utf-8?B?ak8rRGV6RkNlUHdyaUdZbzZZOTh5RGhvMlpwWm1CRFZkUVRhVGlId2g0MEJU?=
 =?utf-8?B?WGczMkw3QllWQzNoMkhVWi9peWNqcWFrUnZmRGRKeC9tQWdyZk1sREtKUnVG?=
 =?utf-8?B?NEJUSE45Umh2V0Y1bmVYTlhjU0VXUHlhdXhTQTQ0OFRvSS9oMG5ic0VPUkxQ?=
 =?utf-8?B?Y0tEWEtlaDFEV3Zham9zYVFIUGJLd1NnNlhaMVFWcnZCNHduMXZxWElGV0NI?=
 =?utf-8?B?Ynd5SS9peCtIQUJKczV1ZHFxdWNLYUFpWE9rS29kQVc5WFN2NVBvTmpKSkZm?=
 =?utf-8?B?SUxoTERZS1FyMlUyNGpocEkzRStOVzBOcHo4LzdqNDl6cGVmRWpVWGo5a1VJ?=
 =?utf-8?B?KytjYmJnVjhZRytxcE12WENpQU9tQ1YxSmYvd3llV1BQOW5iSUpBVExuMlcz?=
 =?utf-8?B?bU8wSHQrQUZEZE81ZkhDalc0Mm1OV2tyWFJ2NTNiLzNyMzdHMnpBNXJ2ZTlF?=
 =?utf-8?B?emtBTkFYN2oxRURuRWRKQzFMcTZmZjhDYjZBelptOFBETzB6cGhUVEVyYmN5?=
 =?utf-8?B?KzNSejBpeFRnMGo5ODdaNXdneHpNZWFrelNjQ3hONDRiQ3R2SkdSZUFGVzlJ?=
 =?utf-8?B?dlA5WVI5UUxrRFhtcGJ4YU9aeHBuQUw1VUJ1bUNYNU5kZkJjL2Vsa08yS3M4?=
 =?utf-8?B?eGFkTW1mNWlLSGkrT2Y5MDhDdjJReXI5VjBaUTRDdEJVTE9BcGQrei9mTlQ1?=
 =?utf-8?B?MUp2eTBDTjVrdVNvdjZyUGhUWE9uRXcvQzM3b09TaVFOVmcvMTdrbThmcVZT?=
 =?utf-8?B?RDQxVXA3S2s1M09QN3g1RTR5c3Q2Z2drMitXbHJ1TWd4YnVzbk9JeU5IeXJY?=
 =?utf-8?B?VW50MlIrQ2ljQlBhL0hTcXhxWjB1dWRnVEFvUDNjNDY5TXJobWk1S2ZubVEx?=
 =?utf-8?B?d25BS21DcUtpaHZxcEYvY3hqUlJoTlZ0a1JqcHRvakJoVVJMUytjMTZDVHdH?=
 =?utf-8?B?cFU0T1VLaTlrVzlGdVZEeGs2bzUyRG03TGZRVStzQVhaRkR4MWlhSkxrdFFX?=
 =?utf-8?B?T0ZTZDV0ck14VGtESS83ZWR4UlcwMUlIcDZqR0hXQzQ0QVJXa1grTDE0K3po?=
 =?utf-8?B?Q3ZRNmVuVENvR3gwSytTaHAvUytqb1pYNVF5eTFOR2U0dUpWQ1VPWDV5MEtR?=
 =?utf-8?B?RlRtd2lxbEVJNlk4RlhqTVFuMGtqNW9uM1VMZ2pCOEoxV2tEc3ExUFdINnoy?=
 =?utf-8?B?Z2ZSZEpnS3dKUGpsSGxwQ0wvY3l1bm5seE53Zjg3SGYvN0dUSlVwb3RnMjUw?=
 =?utf-8?B?UjFWdHFtYW5yU0lkVElEOWJnYm9PcXVhaTdNUkNJajVyVEVlSGtJbmZXN2Fi?=
 =?utf-8?Q?iCnsuwT9DXew2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zm5LRFNJc0toM2ZyYnRwSURqaVZ4WkJGamx1M0ZRbXFVbVZYK0d4V0hiTXZt?=
 =?utf-8?B?bnQwTVN3UWZOR2pyS2pYZlhIblZ5aXFlV3hzWEM4WUhtcnd6WlRSOXM1N0NZ?=
 =?utf-8?B?VGx1blNLT1h1ZExFM0JuSnlHMHpTb2J4M2FVaGxGaWxDa1JPbUxMU1E1OW5F?=
 =?utf-8?B?T1ZRN3dkNnpueXRKeUxhYm9UdGZwNk4vVzhRdUJNOXF4czdrb3hXV1FwMzlp?=
 =?utf-8?B?YmQzOVZwNFhVTGw1LzdSRVVLRUtrclF4SExuRXoyZHMzL2wrTW9neXlHclRI?=
 =?utf-8?B?VnllZnRGTS9RNmhMc3o3cGhXMzcvaXhoNjZ0TmJLNWRiYUdrN1BlZUoxTDgr?=
 =?utf-8?B?dHlYTlhKREN4VTRINXJuY2xSMk5ybHN4VXV6OG1aazhJY01GeExWWUsyRjJr?=
 =?utf-8?B?QVhDVmdIMTl2bk5qYWhFbEtpQzl1RVN2OVBwOVpreUEwOXZXTWZlZnBxR3dK?=
 =?utf-8?B?MWZtMzVIMkVBOFBXcHBERldqMVZLeW1JZWFjRHdaK29RY1lSQ3NoalFSSi9M?=
 =?utf-8?B?V3hjUldyejMrRXdmZTQ3NG0zMmRIb2lmWk0xQVBMQU9oeUdDcHlLanNGd01p?=
 =?utf-8?B?V1FlMWExekJtMlVwTW95cG0wYUpJN1JvUGlpV1Z5aUVaNDV0QTFyTEUvUFJS?=
 =?utf-8?B?ZlNZT0pHKzZLUU13ekM2WDV6MEFoVmorWG14M01kTFhhbWorb2lCZEhzS3RP?=
 =?utf-8?B?TmpvTGdOZmFidHQxVHRVaERHMXVHOVlnOWVWN2hjK2xYZWl6ampNcHRSclV1?=
 =?utf-8?B?VWtEV1V1WUp4c0hEZ0Nyd3VrSHRtclo4VWZMajdoOThFNkMrNVducU9Ga0ZX?=
 =?utf-8?B?aUlvY25DYXZyVEI4bWh4cjZyM2lzYlk3bjFTeE5qVW5aeVdOdXhjdkUweEdz?=
 =?utf-8?B?ZzF3Wk01YjhnMTZ3bFVuQnV0Y2FVclk4Mjlrd0hleVlRVHRrN04zNXBtVDlo?=
 =?utf-8?B?UXpaMFI5OWtXMFI1YjRmT3JJak13c1hja3lwQmZKeE9iWkRZdUNQcm95RldU?=
 =?utf-8?B?UytHK000dGIvaXFPWUREN2U3dGNPNUNhNlBsL3AwOTExdW9Pb0s3dGVDRVpi?=
 =?utf-8?B?N2l3bWlkYnU1RTliVCs2Nm83VFljSXhtK2tzUGtQU3RFdS8zYmRPUDRrRFVp?=
 =?utf-8?B?UkhXWDkyeEViRTFpL3luc0NxNW9qZ2xIdVdjM1g2aCtjcHByckl1YTlWbzh0?=
 =?utf-8?B?WWZnZUkzL3dtR1hJTmhHQ3Y3NDB0YlNiQ1JxMlp5T0c0TFIvRzg5QjNnN2l1?=
 =?utf-8?B?STkzejMzMWNjK2pJSm5haUR0TDg0M1ZxQVZlM0VJYkFhNFF3ZUFaVXUralpa?=
 =?utf-8?B?UjF1ZmdFMHJvS2NIS1V2OEp2L2FyWWw0M0dIM2JpWS9YY0x4YVZ5c0hLZzBm?=
 =?utf-8?B?M29vQ0tIZVVwUFYrdzhjb3dPQ0pJQk52MSt2dE9iR21lSmJkblM4MmpTTVNF?=
 =?utf-8?B?eTUrKzRhNGw2ZGVYSEFSTHdweFMwV1ZXV29jRW9zSy9kQ295TWJ1WnRnWStp?=
 =?utf-8?B?TkRCOUtDL2duVkpYa3J2ckpUcklsWkU0Q2haN3JvcFQxeHkyM0o1WllEQmdL?=
 =?utf-8?B?ZldZMHdOK1JFeHNManU1VGEzZmV3QmpaQmtMUGJjOFdMRDh5bno5elJRSDQ4?=
 =?utf-8?B?eWVjekJHTEx5OFJoQTRDazFqQnhQc05WN1BWQlZjUG1RTmI4aEpmMXA4MVZw?=
 =?utf-8?B?cFlRbkJKalExSUFaK1pJck55UkpJd0Uydmg2WnlOQk9rNUY2d2ZUdHRMZDRh?=
 =?utf-8?B?WG5nTHVsUENZbjlxSjVSdTd1RmdnUi8wM0FOQ2hHby9ROHprVDg5dmE0VTlZ?=
 =?utf-8?B?M2d6NUV1bExCQ1YwRHI0U2ppZ0IvVnIyVGZQUkxzdStKSmNYY2d0R0U1dzli?=
 =?utf-8?B?ODNCNEt5dlZmckcreDZMck9sYWpxMWc1ME5Sakt4L0M5TmlqakFBck84NHBu?=
 =?utf-8?B?T040N2NER2p5aGx3dW1DOUdieVpRSHlNazVJSzJLQmFrcjZJajFzL1VWOWVj?=
 =?utf-8?B?N1Q2TStWdDk2dVk2blJmZit5RFhObEYrQlkxc2dLS29FNHlEbWNmRHQ3Q21N?=
 =?utf-8?B?R2hnb0lTVVR5c1gxY2lOSlUzdE8vV1NxYkNPT2VNKzFBdDBrWTNWQTFwUXpJ?=
 =?utf-8?B?Y2F6Y0d1VVd4Szhvampxejl1cFk0NmlEZ21pTXdmTHF1ZFN3dDd3RUFKazU5?=
 =?utf-8?B?L1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 706d583c-479a-4975-ea58-08dd6525dcfe
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 07:32:25.5875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BQ6HwwMB/V3UKtsC6LYwZUjlCwXUMIvv9BTDaJ6YZxLwV2cGF6Xdk/qDD8sYqv63kq1FghVhhbvjpog6iQV/Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7167
X-OriginatorOrg: intel.com



On 3/17/2025 2:18 PM, Tony Lindgren wrote:
> Hi,
> 
> On Mon, Mar 10, 2025 at 04:18:34PM +0800, Chenyi Qiang wrote:
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> @@ -1885,6 +1886,16 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>>              qemu_mutex_unlock_ramlist();
>>              goto out_free;
>>          }
>> +
>> +        new_block->memory_attribute_manager = MEMORY_ATTRIBUTE_MANAGER(object_new(TYPE_MEMORY_ATTRIBUTE_MANAGER));
>> +        if (memory_attribute_manager_realize(new_block->memory_attribute_manager, new_block->mr)) {
>> +            error_setg(errp, "Failed to realize memory attribute manager");
>> +            object_unref(OBJECT(new_block->memory_attribute_manager));
>> +            close(new_block->guest_memfd);
>> +            ram_block_discard_require(false);
>> +            qemu_mutex_unlock_ramlist();
>> +            goto out_free;
>> +        }
>>      }
>>  
>>      ram_size = (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS;
> 
> Might as well put the above into a separate memory manager init function
> to start with. It keeps the goto out_free error path unified, and makes
> things more future proof if the rest of ram_block_add() ever develops a
> need to check for errors.

Which part to be defined in a separate function? The init function of
object_new() + realize(), or the error handling operation
(object_unref() + close() + ram_block_discard_require(false))?

If need to check for errors in the rest of ram_block_add() in future,
how about adding a new label before out_free and move the error handling
there?

> 
> Regards,
> 
> Tony


