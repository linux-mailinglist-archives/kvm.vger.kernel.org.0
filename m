Return-Path: <kvm+bounces-67416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 28BCDD052B3
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:48:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A82AA31256DC
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 16:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B194B2E1C63;
	Thu,  8 Jan 2026 16:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DfLVM8mq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BAC2DCBF2;
	Thu,  8 Jan 2026 16:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767891151; cv=fail; b=fK8X8kOnmg8ZHmt5D8Fk95/+Pc9lVEkwmHfVBjPpUDVWf243H7q3dwyLYKtPNGXb65LHDwI2jBG76jnsI4rUeVFgcvaKgBKy3wk+NPRmeA6mOvDgPPjyyhFuyxc/KJJ0LRfyY8f8No/ubAYdA5PVxRPodpest+rdi4mb9Q1HJLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767891151; c=relaxed/simple;
	bh=gERS8+mz22VLl1glA9n9GV6/ITGvv+dccwO61mtCzSw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sLHt/xI+1nYCCsBsPQkhz59HUrokNWRlAsq+X0D9KT7awE/vd8VElMH5ILvtXsXcEBlaGlx/mxKVpd+Ia//W48VAIpjG63w/9560kXXOuWWzj/VcfC0lREMIehRhSS6DcD9acsQy9dr4/eBHj0nXEMVcHsJvBHTs8y8JJ7XC/8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DfLVM8mq; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767891150; x=1799427150;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gERS8+mz22VLl1glA9n9GV6/ITGvv+dccwO61mtCzSw=;
  b=DfLVM8mqOd4OPNd2rr9p0fqLelQOKQw5SAz8D9t1I1C9xUmDmyWpuifz
   sBZqhUCjCn+IuW5EnCsvGt9rGWa/TBeaHjx2asmTuoR2YKkIf7r2OIbDB
   wBdvyKMj4I+0CshImlSYgoYlcFcB/thh6u/Bk3AwmdHjActquAARDspbq
   pVq6hS4l7r6RhS3lk0acxDXGvDtiO1DV/8BvVsc7hhVuNJwL0Vwefe6rt
   HOloY56x/b7mC+50SoqH9mc+BtJNeISGqhsj8eHphcb3SOJixoPjwuTrP
   K+OPFvCSdAOIuS0r0VVTVfLdOTJdhdGNGQM8FucaLSvCBagGEp0LeddGl
   Q==;
X-CSE-ConnectionGUID: E2YJNQQ4SKmseCbIDzYrxQ==
X-CSE-MsgGUID: I+PQgOzlTr+Z00RG25tdsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="86689683"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="86689683"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 08:52:30 -0800
X-CSE-ConnectionGUID: eS5gi2TSRL6eGMMidrejQw==
X-CSE-MsgGUID: uvAts3lCRru8kyTGXeSrCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="240741645"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 08:52:29 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 08:52:29 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 8 Jan 2026 08:52:29 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.43) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 08:52:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e8rFKqGx2V7l1AziTh30Mwpzbcmsr3i4Xu0Wf/d+b44PwST9LQf2+mf2KhnnH3l7lkel3b0th6cuafG94IG494F+pU0XVv0pVrve4p9nY7gSlachtR6F5kafaNoFBuGctBgugB+1SPRYsTXM4DsPpfrfSQGkXdibje+lfzq64NbLGso/hORBDh7ov0JKdZ2FqbH6lEhST+0So9o8hANUvGhuwre+/6J6+3PpYUXIN3+oKz0nWuWEz62NMC/+W3Xr6wkSTMlC1/5wAfo/lkJ9fQ3mj7ZmZjBYu7X/cVzTNC5vw/ex/lEhR7PNmCRwIa0OL0YIOQ1vSiOppUk8Gy89rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gERS8+mz22VLl1glA9n9GV6/ITGvv+dccwO61mtCzSw=;
 b=eERuvwusEarB+n/g+0ZqAOHTeNTwpaBKR/ijU2tCcuEcQP4G+/TKANMVwY2/tgDssoqQs9pbzd/aYF2RWK+FOEh43bV7u84Si+d/Vs+zCXeXRI6bcrx+T8oEgKX5Gv3VxrQVK44U2aNbhyybTd837QoNiB2H1NLLpfk5U00C7trt03MkMbFGgeh/Fdbx3Um+VkRckAGAY0Y1n5XlIdtGQJj21IekxCm5hx3YpWWV9nFpIETl3O3kunNKUsY222QJJXWkP7kLIgG1DGE+CCn0xobYnclul8D9HFDZoM/mUhjje93YTjUpKHtCUreafolYra7aWNIEpx6QCP2BvQxW2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL3PR11MB6508.namprd11.prod.outlook.com (2603:10b6:208:38f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Thu, 8 Jan
 2026 16:52:10 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 16:52:10 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Topic: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Index: AQHcWoEG0U6tpU/nuka5qLmVaBAkzLUwtToAgBO02gCAAGMxgIAA2fqAgADZ3wCAAJGaAIABc+aAgABC4gA=
Date: Thu, 8 Jan 2026 16:52:10 +0000
Message-ID: <b4af0f9795d69fdc1f6599032335a2103c2fe29a.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-5-rick.p.edgecombe@intel.com>
	 <aUut+PYnX3jrSO0i@yilunxu-OptiPlex-7050>
	 <0734a6cc7da3d210f403fdf3e0461ffba6b0aea0.camel@intel.com>
	 <aVyJG+vh9r/ZMmOG@yilunxu-OptiPlex-7050>
	 <94b619208022ee29812d871eeacab4f979e51d85.camel@intel.com>
	 <aV32uDSqEDOgYp6L@yilunxu-OptiPlex-7050>
	 <44fb20f8cfaa732eb34c3f5d3a3ff0c22c713939.camel@intel.com>
	 <aV+o1VOTxt8hU4ou@yilunxu-OptiPlex-7050>
In-Reply-To: <aV+o1VOTxt8hU4ou@yilunxu-OptiPlex-7050>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL3PR11MB6508:EE_
x-ms-office365-filtering-correlation-id: 429b2110-4e45-4dc6-cdb3-08de4ed6441b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bm56cldpZmlOK0lpNE5pajh6RVdXVTJXcWtuTHBjVy9XazlNUlphaHFYbnU0?=
 =?utf-8?B?TStpRlppNUkxV25MbzREdkN1aDYvekZXanZwUkFTZHVONEFnaXpzT21YV2xy?=
 =?utf-8?B?Zkt4NjdiL2VpNDd6VFhuUmlKcURUYmNkekpiUjZhb1A2R2txQ2t2Skt5enFa?=
 =?utf-8?B?V2JDS3lmaGhwemIwYjRmWS9RZ0RKSU1IaUljQjJkZGhjNE9kd1UxbEpNeENM?=
 =?utf-8?B?WVhNK1FXRE1Oem1VWVJwelRIRDVYa3B4UlA0ZWRCekwzeEFaNnNBbXo5Mndn?=
 =?utf-8?B?cUtXUUljZ0xNTllkN3lVUmdYYW9UK3p5dVRQbkJjeWVqekYyT2lGMWJtMU5n?=
 =?utf-8?B?UHFzTy9IaXhLWnpyTTVvdWErenhqbEplTGVNanl3Qk53UXV1TjZ4OXJ4MkIv?=
 =?utf-8?B?RlNIQ3BqTmFjMThLV2ZnUm1wemMzWE9vYVNSTk1rbTFWM3JUQ0E2UzlXK1F6?=
 =?utf-8?B?eHhXSFY0ZTcvTHhnd2VrMStYSzJWKzdDYnpkU2o5TzBzR0ZGQ1hiVklkL3VW?=
 =?utf-8?B?NU4yVkNiUzNPUXNTNU8ycUpuVjJEWFF6U0xlTWZYWGcyUXh5YkwrWDN3NFJv?=
 =?utf-8?B?b3Y0aDArZk5MVm5pMkNGQlp6ZnRNcUhOWUNVcHl0SE1UMUZENlJMWHNEbkd4?=
 =?utf-8?B?SHBOUGk3NDh4czJMMUF5QmIyMldiRGZkK3pjQzEyYUNaRDZsK0hEM3NYTlQ5?=
 =?utf-8?B?bmZ4ZmFyb3lhSTBlOHVqMVFLUWRLelJUSEsvODN2UkZPeWlabGFxOFM4a3Ar?=
 =?utf-8?B?WjA2dVVMcG1NVUNuWlhKUldvRjJJZ2NXYzgwY0dEUFJVVEYvZ3RIY1U3eHVs?=
 =?utf-8?B?QTFRQTdSZk94S2NuOXBJUEhWOGNqc3NtVzRINWpsMS92VXNsQllDVmRLTjRv?=
 =?utf-8?B?d3M1R3A4TkxTRFV6SWRpclZ0bjEvTzJkYXhMNlhWMnlQOVB5bVVLeE5MREJR?=
 =?utf-8?B?OG56RXlXRmZ1am9BVTZqY1ZZUVVPV1RCcUtRVjRtN09PcmJvaFRPeDlOelB0?=
 =?utf-8?B?K2h5WXpvT2xkV1E4b3VpZWVOeVlZQ3J1KzRrMmI1R3RXa3lrclE0TkpVa044?=
 =?utf-8?B?emVvR1IrNFdLODBkNmJDVzRtSnMvTDV3dnIrelQyQmhSdThMUnRTZm9FNExn?=
 =?utf-8?B?N2NITTdsMzVZZzdSeHZ1TEJIZmNFRUFha3YrSzdlWTgzU0k4alVEcXFNS3JV?=
 =?utf-8?B?OWZBaFIzZDdyT2JFNEFCbzRHa3lrOFczRGJOeGJwL243dWlzZ0djNUxzdU9D?=
 =?utf-8?B?TnJkUWxHNFpuNEE4UEo0N3ZmbVJ2eE9Zem9YVGplVjZ1R0h6TEtHcFprMDRW?=
 =?utf-8?B?UHprMDEvbklxa01oY3JyZFdsTGM1T3A0VnFRMEZ2azd2L1pMZzA5M2tvck1r?=
 =?utf-8?B?Um9nVEloL2dEc2lCWllsN2RJaWgzbEk2ajlqQXZrYUJoMFFqdVlZb3R1Uytk?=
 =?utf-8?B?eEc5MDQ4MGc2TkcxNm9BS1NKL0hjRkJDclBsSk1yNFVmWUIzR09KYm13WmN1?=
 =?utf-8?B?emVXM3RRVDJOQTFJMlpCTFBlSk85Ymg0TXhDRGc5M3M5MFlZQ1pON3MrUjA1?=
 =?utf-8?B?Y3BLdStQcmdNMmFxTy9xSEZmaFYzK2R4Rm5kcDZpVXJ6SFRlaFRaWWFIcU9m?=
 =?utf-8?B?RGF4S0phbHBNcE52Ny9hd1k1MTRaWncyVmVlbTZxY3BvejdyUkgwNVl0VG80?=
 =?utf-8?B?L3dpb0FqMU1tTk5NVWlCR2VqWjBJUER4dk50Lzcxbm5TK3djR1pUVWZXNDdR?=
 =?utf-8?B?L3NXVUR1QTdpMTZYUkpIOXBkMjBuMUhuWUswbURyTzNzbEFTcXZTb2NSUFZS?=
 =?utf-8?B?S1RzWlF5MTF2dVorNVlHODR4RHNoWmkrL1BHZzJZdFRvSzhiTTIwOHdYbjNn?=
 =?utf-8?B?NFROOTJ1b3Q4WW9tVk45V1djbExoS3dSVWNaY2xUZXUxVTU4bFV5SW52WlF1?=
 =?utf-8?B?emNvNVArZFJ2eGZSUlV1UlZLL0JvaU5Cd0dNUy9pZ0NWZG9Hcm9RVG9pU3Yz?=
 =?utf-8?B?c3JldkF4ZkQ3OFRjQ1BBMWVOWS9iKzVUeUM2NURTR2ZiQUM2bDhVc2kwZVN4?=
 =?utf-8?Q?GCqHeI?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1RvZzJYdUFJVllMaTk4Sk4zaS93dnZPQU43VEIrNFZxaFFYankyOFd5R2Fs?=
 =?utf-8?B?SWxCYVpDcVRLdFY3K1R3TWRHdUtkQ1RUcWx0M05xN1BZdHdqOGQ2N3krK21a?=
 =?utf-8?B?Ymx4eTczczB0MzlySWxzV25BVVRzeFRLOXVFelU1UFNhTk9WalduMmpxTG0z?=
 =?utf-8?B?cFhydnhydXVKM2NETlhHUTlzZXp1NTFjckxpdzlvSk1qYVg0bzViekdRbnhm?=
 =?utf-8?B?Yis1aytjeEQrY2JidXJZREs0c2JEN0ZqaWtJOUpxcDY1K1ZSbE1DRWovOGcw?=
 =?utf-8?B?R2lwS0JHQndvcHFlRWtZaERWcml3Q1BLeWNhM08wenJySUxJV0E2UG1jZlJj?=
 =?utf-8?B?Ym1qcEhYMlBFZE5rZko5emJ2MUEvbzhZQlFlcFhkNDJnaFN6bVhEVjZqMkY0?=
 =?utf-8?B?Y1JrbU9SL1VnMkRXM3lOV3ozYUIzZ0lrYm1IVExvNjhadVlyVDhNZUZMMFJ4?=
 =?utf-8?B?endxZFhrd2RzK2VpTlU0RGk1UVF1MWF2NzRvd2lYcllDeE01b3ExMm9kM0I5?=
 =?utf-8?B?dWQzNjM2VWVYU2lsQi8vazMrYkh1YjlpKzA2MlN2b0MwQlMvK2xqYXBsTllR?=
 =?utf-8?B?SUxuaWVoUkNoZEIrWmtUeXBpRzFBajJzclNFWWJoSHJSTDVPakZGa3Ayb3J0?=
 =?utf-8?B?MFNCWFVreDFPWDRNNnh5RXdCazZpVEd6YWllVVA4dXlUdjNzSW1uQWo3SFFr?=
 =?utf-8?B?ZzhHekVhdk5pNjdsY1hScE5PRXdlWGlXZWtCMTQyZGRJa0RsYmhsVUo5Z3Vl?=
 =?utf-8?B?UjdlaHJZeHE0bkErcmdPWnZJMC9hOHNxQXpLN1kxZDM4dlByUnlOUWNzaFJX?=
 =?utf-8?B?bnpqMGROUXB3RjBLZ0U5azhJa2hjM0w3R2c0V2JuZkx0NW1kZG10b0Znc1ZJ?=
 =?utf-8?B?UTd0b014dWlJcnhPamFPM2ZqZVNNcEFOZHZJTHUvSTBLOXdWQVdTM2JsdEFs?=
 =?utf-8?B?bzlCRUorNkJuaE5DTkkzakFYTlBpdHNlY2pIeEJZMTczMkdkYnJ5Q255N0px?=
 =?utf-8?B?ek9pNnFpLzc2bVJ3Qk1hWHF3WFpEMDlBL3BrYTgrSEJEaWg1YlB6RE5LOEJZ?=
 =?utf-8?B?bGVnejhiK0c1TlJzQ0g0Q0g4OUtadmROQldlVVpYeHpkamlZb2dwSUlBRHhp?=
 =?utf-8?B?SHZkM0pkYkt2TFNhK3BHVGxmTnZEWkgvb2dabzgxQ1FuRDJlS0tzUGp6Sm11?=
 =?utf-8?B?cGN3RlVNakl5YmovcElUWWEvUEo4ek5nZHNmUGJnOHdSNFp2b09ob3BwOFdx?=
 =?utf-8?B?WDBqajRDR25VdzhtNDl0a2xnSkJhQkpzcDdGWkdDcWplUEVoa21BbThSS2kx?=
 =?utf-8?B?TksyZWhBb0dMaXR0aC8xZDA1OUwzNG05K2s4bjRmeEl6T2NyTVJzcitwQzIy?=
 =?utf-8?B?aG9BUWRjbUpmMUVSenNId3RPcnBMRE5xbHBrYnZSOStWNlJuMnJHYWtoNXpJ?=
 =?utf-8?B?YTk3cUZ0R3BxZUZyV3o2NllVclJZNGJ4YkdNZUtpckdUTnRtZVo5MjZ4VjJh?=
 =?utf-8?B?aG95dUlrbWF1ZE5JR09uSDZzVmhqR0FZQTl1Y3FjWEswak5KMk11ckNBb0xq?=
 =?utf-8?B?UlVMajlxYTJIK0ZadmJPY1hEWGd3c3cxbkR0Z2ltWi9hMm5vS1B3Q1o5S3lw?=
 =?utf-8?B?bXJzYnE5enhjMDhDRkY0RWp6Q081Z0NpQ2lOS0toM0ZVU0NOYUJPNzlNVXh0?=
 =?utf-8?B?WjdrZXdWcEtvMWVBZWhqdEFydTVIcHRrTnBCblNHcFVvdEE5T0RvY1k2SGNS?=
 =?utf-8?B?QWsyRWdKL0xkSHByYUIydC9qdFZYWkFiWlJsbDUwK0t0RDBTOU43UXkzeGlO?=
 =?utf-8?B?MVMvZ1Y2eG9xTnRFdVZnMkI3dmpLMFlFMjNXT3J0NjRHeFpGSkFDNGRCQklB?=
 =?utf-8?B?bnVGSXN2L1FPZ3p3c2VtTC9keWxOK2MvMnc4VzlibWdSQ25uMHBlRStoZTJx?=
 =?utf-8?B?L0NaZjVBZTZ0NDcxa1ZaYnZ0SmJINllCV1Yyc08rdW02K0JSWE4zSlVsbGd4?=
 =?utf-8?B?eVFoSzR4dWdCc1c4T3RKOVRrZXFhYldBMElYdlAzVnh3aUlhWCtlekdFc1VK?=
 =?utf-8?B?YldjYnZlNFdFZStwRC9VdVphdmNYR3VCcERNaVFrWGx5Mi9BdDlsTzhLb2Q1?=
 =?utf-8?B?emxUWVJZbnFlUXg5TFNyNTlrZmp2N3g1UUE4OSs3MUJOVmVsa3MvYm5JMWFL?=
 =?utf-8?B?Ykw4akNaOTlQSFVkS3J3UFVYemovL0ZuVlRmYmdsTEtmT1NQWWZSNmdUYjZP?=
 =?utf-8?B?L2V0YlVyS3IreG1CMHpsam9WSnJRUENqc3FJYlpYRDFxZFBVK2NSOUhseUsw?=
 =?utf-8?B?Nnk5WWdjRzBwblVUa1h4RFEzTWlOaVRCbkI0eDVzc3lEdWt4b1VCbDlTMU05?=
 =?utf-8?Q?DKeW1EAqfUZhd/NE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE31D6EAAB18D447A3FC87D1A56E8194@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 429b2110-4e45-4dc6-cdb3-08de4ed6441b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 16:52:10.5355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nN192D1NN8fi08kl4IQb6XRl5hVEDP8Pkw2gRuVNwrm9JZRe8jqRVsMLeAK3MGRNAv9ihZD12S7AzJ1mjd4r1qbyJe9ewRyroML0wravaiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6508
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI2LTAxLTA4IGF0IDIwOjUzICswODAwLCBYdSBZaWx1biB3cm90ZToNCj4gSSBh
Y3R1YWxseSBkb24ndCB1bmRlcnN0YW5kIHdoeSBhIFJEQUxMIHNlYW1jYWxsIGNvdWxkIGVsaW1p
bmF0ZQ0KPiB0aGUgY2hlY2sgImlmIChzb21lX29wdGlvbmFsX2ZlYXR1cmVfZXhpc3RzKSByZWFk
X2l0OyIuIElJVUMsIFRoZQ0KPiBjaGVjaw0KPiBleGlzdHMgYmVjYXVzZSBrZXJuZWwgZG9lc24n
dCB0cnVzdCBURFggTW9kdWxlIHNvIGtlcm5lbCB3YW50cyB0bw0KPiB2ZXJpZnkNCj4gdGhlIGNv
cnJlY3RuZXNzL2NvbnNpc3RlbmN5IG9mIHRoZSBkYXRhLCBvdGhlcndpc2Ugd2UgY291bGQgYWNj
ZXB0DQo+IHdoYXRldmVyIFREWCBNb2R1bGUgdGVsbHMgdXMsIGRvIHRoZSBiZWxvdyBmb3IgZWFj
aCBmaWVsZDoNCj4gDQo+IMKgIHN0YXRpYyBpbnQgcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQodTY0
IGZpZWxkX2lkLCB1NjQgKmRhdGEpDQo+IMKgIHsNCj4gCS4uLg0KPiAJcmV0ID0gc2VhbWNhbGwo
VERIX1NZU19SRCwgJmFyZ3MpOw0KPiAJaWYgKHJldCA9PSBURFhfU1VDQ0VTUykgew0KPiAJCSpk
YXRhID0gYXJncy5yODsNCj4gCQlyZXR1cm4gMDsNCj4gCX0NCj4gDQo+IAkvKiBUaGUgZmllbGQg
ZG9lc24ndCBleGlzdCAqLw0KPiAJaWYgKHJldCA9PSBURFhfTUVUQURBVEFfRklFTERfSURfSU5D
T1JSRUNUKSB7DQo+IAkJKmRhdGEgPSAwOw0KPiAJCXJldHVybiAwOw0KPiAJfQ0KPiANCj4gCS4u
Lg0KPiANCj4gCS8qIFJlYWwgcmVhZGluZyBlcnJvciAqLw0KPiAJcmV0dXJuIC1FRkFVTFQ7DQo+
IMKgIH0NCj4gDQo+IFRoZSB0cnVzdG5lc3MgZG9lc24ndCBjaGFuZ2Ugbm8gbWF0dGVyIGhvdyBr
ZXJuZWwgcmV0cmlldmVzIHRoZXNlDQo+IGRhdGEsDQo+IGJ5IGEgc2VyaWVzIG9mIFJEIG9yIGEg
UkRBTEwuDQoNCkhhdmluZyBpdCBiZSBmaWVsZCBzcGVjaWZpYyBiZWhhdmlvciAobGlrZSB0aGUg
ZGlmZiBJIHBvc3RlZCkgbWVhbnMgd2UNCmRvbid0IG5lZWQgdG8gd29ycnkgYWJvdXQgVERYIG1v
ZHVsZSBidWdzIHdoZXJlIHNvbWUgZmllbGQgcmVhZCBmYWlscw0KYW5kIHdlIGRvbid0IGNhdGNo
IGl0Lg0KDQpCeSBSREFMTCwgSSBtZWFuIGEgc2ltcGxlciB3YXkgdG8gYnVsayByZWFkIHRoZSBt
ZXRhZGF0YS4gU28gZm9yIGZ1dHVyZQ0KbG9va2luZyBjaGFuZ2VzLCBsZXQncyB0aGluayBhYm91
dCB3aGF0IHdlIG5lZWQgYW5kIG5vdCB0cnkgdG8gZmluZCB5ZXQNCm1vcmUgY2xldmVyIHdheXMg
dG8gY29kZSBhcm91bmQgdGhlIGN1cnJlbnQgaW50ZXJmYWNlLiBUaGUgYW1vdW50IG9mDQpjb2Rl
IGFuZCBkaXNjdXNzaW9uIG9uIFREWCBtZXRhZGF0YSByZWFkaW5nIGlzIGp1c3QgdG9vIGhpZ2gu
IFBsZWFzZSBnbw0KYmFjayBhbmQgbG9vayBhdCB0aGUgZWFybGllciB0aHJlYWRzIGlmIHlvdSBo
YXZlbid0IHlldC4NCg==

