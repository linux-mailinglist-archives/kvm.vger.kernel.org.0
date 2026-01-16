Return-Path: <kvm+bounces-68340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 34B60D339A5
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 17:58:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 975443014E94
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 16:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30B9C389463;
	Fri, 16 Jan 2026 16:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X9EGH2Ev"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22213090C9;
	Fri, 16 Jan 2026 16:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768582689; cv=fail; b=W+c4ytL/pGLMIjaKhb+x6sLmXiHQJxMtnlRRtvjNI+fzn0xNoJI79yyfnA1b1vzQXKtVogJw52RjhCfFmfDySFv4FrR+2zBq2JMpiJvTm1ErVr7C28u7paH5GLXTjnn1FpFP7Zt7F//Fe+35GbHkPM9RQZ2WTG0lh27zr12+ta4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768582689; c=relaxed/simple;
	bh=O+/rKMaXSnbdjky+YPxh9QOJosAjjXiUdZeOCOKRuAw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tnAyy2Tpq29ztIeb6ZIyGO37c8YR9xnRJnmPlNmwjh9W30Mol/ZafL1o4bgeyiXLGmDhCRDzGH7mlbBkOb5Ei7NtSB6Umkte7RN3GQv2Ep00qMrZ/qYpWxxtD//ZpoGp5n0j/fZuI7YeOm6LYaUfsqN6+QXEzWYK+wSDQ5ZqEKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X9EGH2Ev; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768582688; x=1800118688;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=O+/rKMaXSnbdjky+YPxh9QOJosAjjXiUdZeOCOKRuAw=;
  b=X9EGH2EvUSP7pHW09woECqmFSHBpAA4U5NYzfFRz851hvSlsswqmXmqG
   NfWN3JmBhhbQ9+zY/CpMaywp4USrx6o2UH8PIcy9eHTUrnnoQtTc1fCbi
   gprmxA9UVvKOP1A6vW5jJGRmu2KV+HFb69A+2DL4e954ynif6q36v0gM3
   yQXIz4lxHXlB/USkNchsbBIQXLnwcNXZLfA6SPMCzh4ytLaD8QZFyPA85
   Cb73lhfqh68SvCF1rST0Fw144OTGryXrXjO3PczrPLiuxm15mWxNwUPpp
   6FnB2JO6kOMtP85GZbW+o+NYod6+WcWNWI8YG6EentVc7MHqpuaO5lsdY
   g==;
X-CSE-ConnectionGUID: 28j5kLR5Tbq9hQd5TgwG7A==
X-CSE-MsgGUID: li5JbCvWTcWd7lsV3ow4Fw==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="69795180"
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="69795180"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 08:58:07 -0800
X-CSE-ConnectionGUID: dM9GZ4q2SzCjLOTHmYbhUA==
X-CSE-MsgGUID: 5BldClGkQsy2JSh9ErwTSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="228298408"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 08:58:06 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 08:58:05 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 08:58:05 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.9) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 08:58:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ULOu0zqQhPIYoIDSthNbA+Z17FMsi4vRkphJh4B7Bs0rfAO3e+LsRGMiQM2wOkmI6jE61Vcw4CInZzT1eHgyKMQCUjikNvmTyuzrBbNUcoPMxvZ1o17vVgNouYViQLcP4R5upIK62xQpNk5t5kYkOF9EkWw7iRyCTeSzkn1CN3/hiI+PIiPvVo4LfW85GOKMSpFEDoXw3APLKqaofOAoXamOI3luA00mNmhlrjDWZKsPV2D9ksy+BM57tQi4/wVs+ZFRlelM5UyMx4fu5gZbFzY/h9a/UuilKnLC468wxZH+qDVqQ5en7hck5aj5/BlW43UBbTGk+yEa7ijHP+nTyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+/rKMaXSnbdjky+YPxh9QOJosAjjXiUdZeOCOKRuAw=;
 b=BzF/MwyatF5QQUGoY/KQ4eSjPfCf5FnsBzGKJtWqCTpDWJRE1rMZbX+QLHi4ecuZ6xw8F9GiYWQYYkeUr2Nz658Xz+Hz1F6C46lIc+XqjlTQZSPOOiU78erDES44XBdp82PYluFhZ92FxTaO4bug3d4AtnwkHyektNAmF2FJn+jgu+AW78seDFrme2nvPaM2BH2ttfG8h1snzEg8dB3sjXNaOlqgR19rR6fzeEGRb7RjOehvlSWDxEPn7D40+SZ/n/9BCh4tRDoQPhe3GJASEzQiI5r29a3TXlXGF9rOrCYMZvm16AFaF/OtJvNrW3tPNbCgb82Fqrt+y7v7cS7ALA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB9450.namprd11.prod.outlook.com (2603:10b6:8:26b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 16:58:02 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 16:58:02 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"david@kernel.org" <david@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "jgross@suse.com" <jgross@suse.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Thread-Topic: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Thread-Index: AQHcfvXkGzmJNKWdxk6kpDo1zXW6dbVFaxWAgAA9QgCAAANhgIAABy0AgAAbs4CACTPSgIAB2pWAgAAOLACAAIW0gIAAZZYAgAA6e4CAAFpRAIAClUGAgAAMyACAAAedgA==
Date: Fri, 16 Jan 2026 16:58:02 +0000
Message-ID: <6184812b4449947395417b07ae3bad2f191d178f.camel@intel.com>
References: <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
	 <aV2eIalRLSEGozY0@google.com>
	 <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
	 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com> <aWbwVG8aZupbHBh4@google.com>
	 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com> <aWe1tKpFw-As6VKg@google.com>
	 <f4240495-120b-4124-b91a-b365e45bf50a@intel.com>
	 <aWgyhmTJphGQqO0Y@google.com>
	 <ac46c07e421fa682ef9f404f2ec9f2f2ba893703.camel@intel.com>
	 <aWpn8pZrPVyTcnYv@google.com>
In-Reply-To: <aWpn8pZrPVyTcnYv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB9450:EE_
x-ms-office365-filtering-correlation-id: a1420044-b878-40c4-5369-08de552068ec
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?a1hQR2ZXajBxVm0vNXJwNnpFWC9OeWhIY1dSVEEvS2xQN2lyYmk5M2dxaXJW?=
 =?utf-8?B?ZmI5U2JEbWZaZEwrbmtBaldGelp0bTdIUllDQUUxdFJ5QkRMeEhFZ2I1S3Mr?=
 =?utf-8?B?UVNXQk9oNG1NR1k2RzlFSXNsU3g5Z0pETUlGSGpZeXlldlNmcGFuTVZsTTFC?=
 =?utf-8?B?Z0FzeFBhSHZlakRCZndmZTU4UW5YQVNmdy9Fdkpyc1lhbWRrOUs0VlpjYW9U?=
 =?utf-8?B?Mk5ZdVVQY2lEeFpZcmtwbzlqZVdPQ3FxYlhsVXQrd1JSMFJCMGF3NUJvalh0?=
 =?utf-8?B?b05BUkg3alhPV0NCUEN1Y2prTnZqK0ZObSsxcnM0WFhHZFdIRWFlVllEU2JW?=
 =?utf-8?B?eURpcEo2SEtsZVh5QTRKQ1lkNjRsbWJNN1RqYkh2WFpwZ0UvOGZZSkZwYUpK?=
 =?utf-8?B?VitOZ1FFUHFrOWYwd0Q0K0JOclovek9zREtxQXMvcHhHRW1MYnhWLzgyTUxQ?=
 =?utf-8?B?UHJZbTVEQ3dWY2x6anRUZ1NlRGVhMkVvNVI0b3Y4TDc5VjhQbGF0K2UxVlRN?=
 =?utf-8?B?aDJGTnEvMWsveGZIUzRpQVludHZaMFFOSDNCWXRRajljcjdyVDRZaVJKb0VY?=
 =?utf-8?B?YW5DK0NJb3RSclJ4Rk11ZlNvR3VCclJSRWQ2WDJtTDNaVHVtaXZYc0ZzSDdi?=
 =?utf-8?B?NXpPQzJhckErYSt3T3ZUZElsU09CaEoweXhCbWI4SWZ4TDEwZEhBWWEzbitw?=
 =?utf-8?B?VWxrNlVIZTVwTy9JWUpUMFNpQUJ5dHVRd29od05MM2hmVFdjQVZ1dkhidm5G?=
 =?utf-8?B?MDF1M2tJT3M0TWlGL0Vhc0kyaWhvdklvYlhNUTNNTWErZVBVblQ4OXZvMTFP?=
 =?utf-8?B?Mythc1l3K3hGZHdZR1J4UDVjWnRCRUFqc3VtREJJUFAzRVRtdVJQekdyd3E4?=
 =?utf-8?B?bXNjcHV3VWZHbSs2WTZGYnRHWXFkMmxJcUt4ZFlJcUdTaFRXZ1pPR1dwS0ls?=
 =?utf-8?B?cktnZnpEU2RxY0tVYzF3L1Q3QW5objZqaEJXREc0REZ1Zm5GVnFZZmhyS2ZF?=
 =?utf-8?B?MlpPMHBNVUgyOHByRmRnaGY3UDgvSDFZQ3ZlekgrUjFVT0JuRWRhcVY1d1ha?=
 =?utf-8?B?S2pKY05hdDdBT01IVmNwZHZZTkhBZnMyKy9kM1kxMldLR3IxTjZkK3cvQ1ZC?=
 =?utf-8?B?UUJQclNBQ0htL1pjSm1iWUE5RGdiZnlOU3Y3dVhmTDdJMmJabTdybnk1R1Bm?=
 =?utf-8?B?bzBVUm5DZmtPRWl1QkkrdnFHVnhmVTF0azA1ZEdvRHYwaVdvd2xKNmN5RHBK?=
 =?utf-8?B?bDVsZTJaMGM2dmh1SHJFdkwyaVJkWTVaYTJTdDdzSUdVT1k3MW8vOWQyR2V3?=
 =?utf-8?B?V0dlamF3TFhiTmU0S0lLMWQ5UHB1bkpjMW9lRTJWNldMbGpiUDJnMmk5MmYw?=
 =?utf-8?B?QWZyUGRoQjhoVVlHUXQvVU9EdEFaUURteGxKVzRUOExUcE44bEw0MGNaQURE?=
 =?utf-8?B?a1grVzBtc0JGQW04b01VcTZjaWVMUzQ3M1FoS2I2bTFyR1krTEZkQkxzbSs1?=
 =?utf-8?B?SThBNUc0RFNtR3MwQXY3eEtScVlISTNKWThSTWN0RGJ1bXFhQUN4MGVtTmFt?=
 =?utf-8?B?U0tnUXg5TjlCWWt0K2U3a2ZZWlZtY1JvNEdldW9ubGtYWGtEblVtWUcvOHJF?=
 =?utf-8?B?VE9GdzY3dWEwaGsyTjB3WUNKcnNsTzcvQkl2UTBwc2N0dFhWM0lsSWlaS1pk?=
 =?utf-8?B?WnNaUE5EVTJGVGVleTVwTEkxVGhJcWc5d0lGMVpBWDQ5alZwMWJYdXN5SWM5?=
 =?utf-8?B?d1g3dVNHYm1Ed1FyNFNNL3VNQ2hyVGtYb1NMVVJXM3lYellFdTFjejQ5ZDl5?=
 =?utf-8?B?UktTUndrditablpoL3VTeEswcmQ4SmY1bmdJMnhNREEzVFVmZjBiUlVuam9a?=
 =?utf-8?B?T3p6Z1FsNnBiRXloUFZUWDJLVDZwSUVyanpSNmZmdlFQWlBXSUtuaTlOa095?=
 =?utf-8?B?RmlNMVVodG5wWXYwUjYyWDFwb1ZlWUduMUdnYWpvdlRvZDJLbmZPanJNakc0?=
 =?utf-8?B?engrbnRSc04xK1Bya1ovZDFGL1VpRGo0MDA4VG9WNUxRbjRvRFZjQzR4R2Zq?=
 =?utf-8?B?eEhyaWtjVTFIb25xaml0OHNjeHRaUHRuTXdIS1VuU24rVkRKWnJRQ2NKLzlD?=
 =?utf-8?B?K1NwaERVZVlrVVViMzRDUEhZZThUUnlOcVpUUDFwSWdJZ1MyNW1QZkw1SjZT?=
 =?utf-8?Q?Bxaq1BR+AojgWBa/0P1Ym8M=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTc1cDAweS9rS0RCb2llaWhlSTIveTFNUVJBSkt3amVwak9tUDQ0YTJXWnlu?=
 =?utf-8?B?WkFYam1wSlJkaXc4Zm03bzRaSVRHMS9tNEpBSERzR2drbVpkc2gxT3hFUnlV?=
 =?utf-8?B?WTREdHAzMmxXZXpXSzZFSkZ5ZGlhY1NXSHA1U3luT3NZRVRuYzI2OVRiV1Az?=
 =?utf-8?B?c3IrblVkRG5vcEtaRjZGOXRDbEIvUXBxYU54KzVKOElva2NHRFdSM2FvZDNL?=
 =?utf-8?B?dVZ6ZHNNL0N5bWh5aXZsVWZLeEJYUWVYVGV0K0hUaFV0eGdYbmYwdkRSb2h0?=
 =?utf-8?B?YmZ5SzFBZDZjWTNOMDVRYVF6NXd1OHBHVDlzZ3dpNlhrY2VWQjkyZ1F0L2VS?=
 =?utf-8?B?NnBpY1EyRHgrS09tczVnRjdqbmdkTSt1VitKRkQzTHplRExPaXFybmd4cG8v?=
 =?utf-8?B?bjRLMVhWMGZKczRBdFJBc1E4M0JHQVB5eDRwMlROV3VzNjlRbjJCQmVoUnA5?=
 =?utf-8?B?MnEvbXh6ZDBCTHRUTEhDaE1FRU5YYW5VU3VkSjlSdlljWjJPcHRBUEFKUE9M?=
 =?utf-8?B?VitPU1RJVFFNaDFnNTdKUStsYTJTUzVMMEZIdkRjWTlUUUx5VlpLMFl2WThP?=
 =?utf-8?B?WWRzYjZDWEtZU3Vmd1NxeWxxNHZtNmFURWRiOEZLQVNrRC9FazZ3WmFLOFJB?=
 =?utf-8?B?eDM2NEd3ZVh5amJXS2tqb2pNYWU2b3dZcWtTT0xWQkhqenoyNWgwT3MreG5Y?=
 =?utf-8?B?Z000YkE3TEkySUxiWGtzZEhNdVB1cHp5VEIwK215NHVUQnhFS2QwTUNZL0FV?=
 =?utf-8?B?YUE3Tk9NR1pBcHVuUVZjREdjZm1MMmtyQmJ4ZzUxL1ByZkVwWHd0S1BzZjNp?=
 =?utf-8?B?ZHNaQ09PZFlON2NYZzVXdloxbHR0VnZ1RzJjSHNEOUJkMVgzMDN5SnNSdVVZ?=
 =?utf-8?B?eXd3NDVsTkgvck9hNTJwdVVOQldBK29ZU1hYdXdVL1drK1ZySDFyVW5zRHlJ?=
 =?utf-8?B?TUhDNkhXcnNROVF5emE1aHhVTnkxQklySklEeU1GaHh1bEF5NVNVUFZDQ0VO?=
 =?utf-8?B?WisyZkUwWXpZTVFqRDZ1TlRXNU4xdHpUQ0lUWXNJMTlUY2RZZ0FtVzlvRjJj?=
 =?utf-8?B?NVVwVzNtdjJ6Tm1UcGtzVjE5NUVKaW9xSTlqNzhrLzFCMjdrS3FDUFc2SVNL?=
 =?utf-8?B?bVdFYksrZjJoV1lmVHEwb0VyK0h0ZDhBck4wUGRBdzJmYkl1YUltbG9DWXQz?=
 =?utf-8?B?R2NhaUFiSG5tR2d2d0hUNlZMZTJMSlV3bFB2ODQ4RHpYNUVqTlZqN0l0cHZJ?=
 =?utf-8?B?YzhSYklHbEpBZU02NU9yZFJjelBhMEV5U3c4V2hKWnBtVDlldVdIT3ZHamdO?=
 =?utf-8?B?RWdydWF6djg5NXZ0cHFNOVRPZkpCb0NrVGlQekd2b2NRQjRDaEFITk1rbmhx?=
 =?utf-8?B?aVR2R2U3NStWOVFMWE4zY2ZBS1FKa1FBMEw2M25zTVVPZkJMRmVkSjN4enJn?=
 =?utf-8?B?RnBNYkJCZTJWN25qNG4zdE5UNUkwUHlPamUrSERBZnZkZWtjRFAzeU53TzBl?=
 =?utf-8?B?Uk9FQkFHbk92TG5iTUN2aDdyQ25uMjN3VEIveHFwY01pa1drNWNiK05kR2xG?=
 =?utf-8?B?aU5lcFBqMWNsZlNHMjR1bXVDNDdoWnJwQ0Z3NktYVzRYY3JYUU9sWHc0aG5h?=
 =?utf-8?B?cVAwVGViZDE2L29mRGEyZERxMkxxenJsbDhZcWNPaGVBeEQvVkk4aEREWnBv?=
 =?utf-8?B?RldNakRiUDhqSGNJSnlBMnZkUDd1cUg4ZUNkTEhJL3duVEFsQTc1YVhkZlRT?=
 =?utf-8?B?WHR1VnBMZXJqQlVQSGM5WmdneGJwa1NEcXRnSlFkZy9mQzBSSkk3MUl6NGxh?=
 =?utf-8?B?MVVvcU9lYjN5K25pZEJlSThYOE5meHp3VGJCcnB3NXpuc0dKNWFtOHI5R0ts?=
 =?utf-8?B?bVhibmRYUE01eGtGTnpFTytWckRZcWlhZjdIZ2xxOEhma2Y5THovcS9Ub01m?=
 =?utf-8?B?Z1lvdTZkRVVzb0FmOEtDYytpMG94dld2TFpHcmk1Vm4zdVFhdUhhSm4zYzZ5?=
 =?utf-8?B?N0lxNHZCSFg3UVQ0S1BZQWY5Ry9BN3FmQUpUblJSNW1neDZEbzBEbmFVNHZw?=
 =?utf-8?B?KzQ0by8wRjlka2wrUWFHY2R3WlFyKytMNm1FNUlIcVhYbnM2eUVZVVFkdHBH?=
 =?utf-8?B?UnpsK2d0NEhQZ3U1MzQ3U2ZzMExoZ294ditPNU1RdXNBTUpzRVZ0dVZWU0hv?=
 =?utf-8?B?cDZHdnI5d0NJMjNoandsSUZLTXp2aVZwRkJVeEhPNW5pNmR0Vmh2MXVmWU9x?=
 =?utf-8?B?MVFuOVdYakdyaVhwbWlxaWZsaE9qYjhOMGV3RmFCRjJ3R3Q4SEN1WFRINi9K?=
 =?utf-8?B?TDg0bFo4UzltQ0xkY3l6SnJKS3ZTVFg4WElra2VMQ2prWmw4Y3RIa2YwZTQr?=
 =?utf-8?Q?ktLVQX9KPhuks1jk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05CACA5E71B0FE479325C1071EAD9E63@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1420044-b878-40c4-5369-08de552068ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 16:58:02.0567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8LALMyvZTexlv6UH1JVu+x3vfdCPzmOOrLHbtmeDc7eP9fYTOWkWU2bo0ETI/yc9s1QAoI7G8AovWxtiw3OYzkz6633T5gJ+qtJTXkEDanc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB9450
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI2LTAxLTE2IGF0IDA4OjMxIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IERhdmUgd2FudHMgc2FmZXR5IGZvciB0aGUgVERYIHBhZ2VzIGdldHRpbmcgaGFu
ZGVkIHRvIHRoZSBtb2R1bGUuDQo+IA0KPiBEZWZpbmUgInNhZmV0eSIuwqAgQXMgSSBzdHJlc3Nl
ZCBlYXJsaWVyLCBibGluZGluZyByZXRyaWV2aW5nIGENCj4gInN0cnVjdCBwYWdlIiBhbmQgZGVy
ZWZlcmVuY2luZyB0aGF0IHBvaW50ZXIgaXMgdGhlIGV4YWN0IG9wcG9zaXRlIG9mDQo+IHNhZmUu
DQoNCkkgdGhpbmsgd2UgaGFkIHR3byBwcm9ibGVtcy4NCg0KMS4gUGFzc2luZyBpbiByYXcgUEEn
cyB2aWEgdTY0IGxlZCB0byBidWdneSBjb2RlLiBJSVJDIHdlIGhhZCBhIGJ1Zw0Kd2l0aCB0aGlz
IHRoYXQgd2FzIGNhdWdodCBiZWZvcmUgaXQgd2VudCB1cHN0cmVhbS4gU28gYSBwYWdlIG5lZWRz
IGENCnJlYWwgdHlwZSBvZiBzb21lIHNvcnQuDQoNCjIuIFdvcmsgd2FzIGRvbmUgb24gdGhlIHRp
cCBzaWRlIHRvIHByZXZlbnQgbm9uLVREWCBjYXBhYmxlIG1lbW9yeSBmcm9tDQplbnRlcmluZyB0
aGUgcGFnZSBhbGxvY2F0b3IuIFdpdGggdGhhdCBpbiBwbGFjZSwgYnkgcmVxdWlyaW5nIHN0cnVj
dA0KcGFnZSwgVERYIGNvZGUgY2FuIGtub3cgdGhhdCBpdCBpcyBnZXR0aW5nIHRoZSB0eXBlIG9m
IG1lbW9yeSBpdCB3b3JrZWQNCmhhcmQgdG8gZ3VhcmFudGVlIHdhcyBnb29kLg0KDQpZb3UgYXJl
IHNheWluZyB0aGF0IHNoaWZ0aW5nIGEgUEZOIHRvIGEgc3RydWN0IHBhZ2UgYmxpbmRseSBkb2Vz
bid0DQphY3R1YWxseSBndWFyYW50ZWUgdGhhdCBpdCBtZWV0cyB0aG9zZSByZXF1aXJlbWVudHMu
IE1ha2VzIHNlbnNlLg0KDQpGb3IgKDEpIHdlIGNhbiBqdXN0IHVzZSBhbnkgb2xkIHR5cGUgSSB0
aGluayAtIHBmbl90LCBldGMuIEFzIHdlDQpkaXNjdXNzZWQgaW4gdGhlIGJhc2Ugc2VyaWVzLg0K
DQpGb3IgKDIpIHdlIG5lZWQgdG8gY2hlY2sgdGhhdCB0aGUgbWVtb3J5IGNhbWUgZnJvbSB0aGUg
cGFnZSBhbGxvY2F0b3IsDQpvciBvdGhlcndpc2UgaXMgdmFsaWQgVERYIG1lbW9yeSBzb21laG93
LiBUaGF0IGlzIGF0IGxlYXN0IHRoZSBvbmx5DQpjaGVjayB0aGF0IG1ha2VzIHNlbnNlIHRvIG1l
Lg0KDQpUaGVyZSB3YXMgc29tZSBkaXNjdXNzaW9uIGFib3V0IHJlZmNvdW50cyBzb21ld2hlcmUg
aW4gdGhpcyB0aHJlYWQuIEkNCmRvbid0IHRoaW5rIGl0J3MgYXJjaC94ODYncyB3b3JyeS4gVGhl
biBZYW4gd2FzIHNheWluZyBzb21ldGhpbmcgbGFzdA0KbmlnaHQgdGhhdCBJIGRpZG4ndCBxdWl0
ZSBmb2xsb3cuIFdlIHNhaWQsIGxldCdzIGp1c3QgcmVzdW1lIHRoZQ0KZGlzY3Vzc2lvbiBvbiB0
aGUgbGlzdC4gU28gc2hlIG1pZ2h0IHN1Z2dlc3QgYW5vdGhlciBjaGVjay4NCg0KPiANCj4gPiAy
LiBJbnZlbnQgYSBuZXcgdGR4X3BhZ2VfdCB0eXBlLg0KPiANCj4gU3RpbGwgZG9lc24ndCBwcm92
aWRlIG1lYW5pbmdmdWwgc2FmZXR5LsKgIFJlZ2FyZGxlc3Mgb2Ygd2hhdCB0eXBlDQo+IGdldHMg
cGFzc2VkIGludG8gdGhlIGxvdyBsZXZlbCB0ZGhfKigpIGhlbHBlcnMsIGl0J3MgZ29pbmcgdG8g
cmVxdWlyZQ0KPiBLVk0gdG8gZWZmZWN0aXZlbHkgY2FzdCBhIGJhcmUgcGZuLCBiZWNhdXNlIEkg
YW0gY29tcGxldGVseSBhZ2FpbnN0DQo+IHBhc3NpbmcgYW55dGhpbmcgb3RoZXIgdGhhbiBhIFNQ
VEUgdG8gdGR4X3NlcHRfc2V0X3ByaXZhdGVfc3B0ZSgpLg0KDQpJJ20gbm90IHN1cmUgSSB3YXMg
Y2xlYXIsIGxpa2U6DQoxLiBBIHJhdyBQRk4gZ2V0cyBwYXNzZWQgaW4gdG8gdGhlIGNvbnZlcnNp
b24gaGVscGVyIGluIGFyY2gveDg2Lg0KMi4gVGhlIGhlbHBlciBkb2VzIHRoZSBjaGVjayB0aGF0
IGl0IGlzIFREWCBjYXBhYmxlIG1lbW9yeSwgb3IgYW55dGhpbmcNCml0IGNhcmVzIHRvIGNoZWNr
IGFib3V0IG1lbW9yeSBzYWZldHksIHRoZW4gcmV0dXJucyB0aGUgbmV3IHR5cGUgdG8NCktWTS4N
CjMuIEtWTSB1c2VzIHRoZSB0eXBlIGFzIGFuIGFyZ3VtZW50IHRvIGFueSBzZWFtY2FsbCB0aGF0
IHJlcXVpcmVzIFREWA0KY2FwYWJsZSBtZW1vcnkuDQoNCj4gDQo+ID4gMS4gUGFnZSBpcyBURFgg
Y2FwYWJsZSBtZW1vcnkNCj4gDQo+IFRoYXQncyBmaW5lIGJ5IG1lLCBidXQgdGhhdCdzIF92ZXJ5
XyBkaWZmZXJlbnQgdGhhbiB3aGF0IHdhcyBwcm9wb3NlZA0KPiBoZXJlLg0KDQpQcm9wb3NlZCBi
eSBtZSBqdXN0IG5vdyBvciB0aGUgc2VyaWVzPyBXZSBhcmUgdHJ5aW5nIHRvIGZpbmQgYSBuZXcN
CnNvbHV0aW9uIG5vdy4NCg==

