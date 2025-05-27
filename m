Return-Path: <kvm+bounces-47826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30A32AC5C66
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 23:47:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE5A4175E2D
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 21:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0DD42135A1;
	Tue, 27 May 2025 21:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h/Caz4/X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767D61FA859;
	Tue, 27 May 2025 21:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748382464; cv=fail; b=dKZpeODOrQEgSXzKxzl/p0PxQCm9OaU/ZK+O/+YkUN/3GvgbAOsYS+YMgondDgj/nnT+N/smUvmd2VPgGAyv7m/rc97Q1wdd09Xx7jOohPpveqovEA9Mb2sWxfpnc9v1OgvGQDr7Pm12WjDMAvRgKsxymcOis6v5CHJM7tLduzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748382464; c=relaxed/simple;
	bh=mTe+NAwD8sGbofYAZwR92K3JRYEmwCfH/b05p/Ycbn8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hwHyGPuO+h5eHe3kmAuQ+lvRiUDEuZvhk24XEeVEy6mHcVINfTXR98K1TNOXN+89mdOgCN1h7bwLuUICaT8OUf6BosJdfuyrSsGerSBCYgd1LVVQ6ZB1aUFP9ggEPh1jBbQ7+O5yx4Jqf5/oaPWOE+y/SrAhICI1Ob1tvt3KsTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h/Caz4/X; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748382462; x=1779918462;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mTe+NAwD8sGbofYAZwR92K3JRYEmwCfH/b05p/Ycbn8=;
  b=h/Caz4/XOoZbka8/+IHXogehRTAUSMxmo4BLodXlQZQTj/kPMthjmPdt
   P1sX3U5IZ42SEZxMXEXaFqb8NeC2kU8/RcKxwIsFKnMqMl2q3BPay7fSd
   L/6mrfE002ZxElSipUchucK2LnRoh3aiL9zy5aWlmsziaQ8kJXP/Tyv61
   s45wyXFst5Hlv8a+D1lsVY1Xh31/ZrjJ0Ydkm8RzCZ9q/sOhalitgXv7I
   jDAgKawgVhjI+o2PUKxWZmK1AD5z6vNLXTqAgc0ZkCx8knAdEourW8sqa
   Hr68yT5se4ACHwMWiPHLPhYC8R2XoVD7zoGw4AN5T+QwBWxHWOEJvR8wW
   g==;
X-CSE-ConnectionGUID: m2Fi3RkWSvuoXbimK/BF4w==
X-CSE-MsgGUID: 4EFXog/5RhGCJi8erX7Y5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11446"; a="50391815"
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="50391815"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 14:47:41 -0700
X-CSE-ConnectionGUID: Qwtg1VWvT2Wfx+rt0dFBww==
X-CSE-MsgGUID: ySJo5lZPRSO6zuOCCzaddg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="166177316"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 14:47:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 27 May 2025 14:47:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 27 May 2025 14:47:40 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.54)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 27 May 2025 14:47:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SKNB/6rqolvD+FN0MPlqe7GRO5xSkwB6QjcyzeaKlVXXTLihWwz8BEjkn6hs5oKYcgr7mcsEEpKtS1C8XCBFDP8y9OjPiXYya+XJdeywKfprrrYRratx++6NIDArjARQ4VwPz8y6Ht5wk3LcyIjnkQL7OAE7Gu7irGDItsBzf4fq5q2pHOQvy+AZpJqWVnrmNxg9fkkxA/o1qRyP3umHl+RpvtdE27OCPv1eIOlNr1Qcxrj/ordTuzQRFM6mTR2zbrhbve7Hsh9r/rPe6xLVoLQ2GdnRH0nnyFgnfV3/J6H+aHluW/jluxrr7MtoyT/zJOKIyrEhIWzU/3CcHQiG/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTe+NAwD8sGbofYAZwR92K3JRYEmwCfH/b05p/Ycbn8=;
 b=nHZ9C+OTNaHYA6kU9zWp/73u8u0T1AYsVUj1/n65DDA+wDSN8gF2tmGcK9zR3udA8+9ZpQutE8G7jugDHDZue4NMqy5uBWQLD+LQSzEZLhY3ihRyKS9ZqXQBPSJDL7+KOI21ISGP/FROO1h0O/Jg87UPBhDxcOOq9Ori4ZRztIT9oKVp79T/t/d/CmHkEw0n0SZb7dHT/v+r4cNX/QZlj5LEEZPCxf1mLs8Oq1axnlRzF99MzjoChSgb6jWKPmh9xPNh1zrESQ0qX2PWLeQfOZWoOxqt8gYFKh4j2G0bYUv/0thPMDmFneSa4lom59A5ZQvOhfvr2wg0/RhnnImfhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA4PR11MB9201.namprd11.prod.outlook.com (2603:10b6:208:561::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Tue, 27 May
 2025 21:47:11 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8769.025; Tue, 27 May 2025
 21:47:11 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "peterz@infradead.org" <peterz@infradead.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "eadavis@qq.com" <eadavis@qq.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH next V2] KVM: VMX: use __always_inline for is_td_vcpu and
 is_td
Thread-Topic: [PATCH next V2] KVM: VMX: use __always_inline for is_td_vcpu and
 is_td
Thread-Index: AQHbzuSWB445QzrMV0+LSRpU93DRp7PmUWQAgAAYFICAABRzAIAAhhaA
Date: Tue, 27 May 2025 21:47:11 +0000
Message-ID: <d5a79a21ea872f22a3e77bcd175b1aa67aff2b53.camel@intel.com>
References: <58339ba1-d7ac-45dd-9d62-1a023d528f50@linux.intel.com>
	 <tencent_1A767567C83C1137829622362E4A72756F09@qq.com>
	 <20250527110752.GB20019@noisy.programming.kicks-ass.net>
	 <5a6187af0c4a73245ae527bc44135d4eb1a9b3c0.camel@intel.com>
	 <20250527134714.GC20019@noisy.programming.kicks-ass.net>
In-Reply-To: <20250527134714.GC20019@noisy.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA4PR11MB9201:EE_
x-ms-office365-filtering-correlation-id: fdb85074-3bb9-4160-773e-08dd9d680988
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RjNrOGE0MGY2cndmS25jcFZqbXQ5b1pneGJXbjdtYVVnS3Z1L0RJQzJLUm9r?=
 =?utf-8?B?ZURxKzlERm13b2Vmc1E1S2laSkZqTldzUUd6WTYvVndGcG9uNTl1S1FFZDRJ?=
 =?utf-8?B?YlJoSjVIemF5VXNVWS9lY2dIdm4rMDR3RHg1RS82dVZteWZESXgrOXJCSi9q?=
 =?utf-8?B?ZllKbXFkL2wwejg2RlFzL3Q0WkZSdVBhTmJMWnl6RU85eEp2bXU5R0o2NHk0?=
 =?utf-8?B?SGgrcUl2SmhvSnNQaEJtNjhzUE4yd2VwQ1lxYm5TTnhQc05hVzJsUE1oZ0F0?=
 =?utf-8?B?cGdIRVZEUWF5TGNjSDliMCtLMmVxN2h6cndPNks3RjJkOWxsMU9GYWszQlli?=
 =?utf-8?B?QVV2S3NVblBzcENuZEplSDVSNzJ6MGNjR2wydzFQNHhKOEZpMmRuenlVRjgr?=
 =?utf-8?B?cjNrN0NZOExGM08vQmFmeFZpZ09jYkFtd0RDQnhia1BObzVIRmhmTUNIVTNp?=
 =?utf-8?B?VkFyQ2RQZlhQODAvbGFpVzNDa3hjWm5hUnROZ0tZYVFZdTdQSDBMaWFOWlRG?=
 =?utf-8?B?d1JYUG55Rk4ySkhFQ0ZjZmdHYWh2bHhaUjc1TTJtT1dVYnZveHh6Ui80YnU0?=
 =?utf-8?B?dXZaanFtNXhtR043OXovalJ5R1VzbFpFNCtPZTJoQ1N1amJiVS9OczlscE1K?=
 =?utf-8?B?eDBrR204cHd3S1dpU20yKzIyemVNUnNYdHYvaFYrRGdzckFEbU82RytkODlh?=
 =?utf-8?B?YWJBeVVwbU94MFJMSStvN2dwblhDQmZJdFhHS00wb3NqYWZLMU5HQWNRa3Fu?=
 =?utf-8?B?TVl1SkRSaFAxalFaek1jTWpoU0xsUnYzSVJzU2JBZlY5V1R6RnRldXNTODJ1?=
 =?utf-8?B?NTRtUEJKcWNoR3BCQVMwNmNVa1hheURzM3kvcE9iWHpXVkNjNEQ0ZXN0M2tp?=
 =?utf-8?B?MlVnaTZKTVpiTXREZGxhcW1qTXlMQ090UHI4cXY1VnU4ZytmUkpWZ29HbHNM?=
 =?utf-8?B?aWpaUytoc1JIc0d3Yy9zSDNiNkZSK0NLenhOSS9JaWx6dHB2N3dHOWltVFNI?=
 =?utf-8?B?V3F6bFBsSGxkU3RjUzRkRWhYS2dtMlNrODlacFNBeXBnT2F4ajhRd0NZYXhS?=
 =?utf-8?B?WmxNbmxzOEJIUnQ3YVdXREtwWkptcldLY09VQVpVMFRXUmJIVFV6azVhblJt?=
 =?utf-8?B?TVp0enc2T25JR0xBWGR3OFlqeWhGckdtOEtSUTZrUlQzclZGTTBZN2lra1pk?=
 =?utf-8?B?VStGWm1MVVlOK0JrVTZOeHQxaWR1TjQ3NmhvOHZ4Tm1KNmw5bFFoaTJxZ1FX?=
 =?utf-8?B?aWIyUkNWRjN3M1doQjA3VndpWW16UVB1VkZqbUlPTmlTSzYyNlVYZENRN3hi?=
 =?utf-8?B?NWhhZFJFWVg2czViVWIyQkNYMUFLcE9uYUx6WmRPUW5KR1JsSG55U05sNkY3?=
 =?utf-8?B?d3QvcDJ6REJFMUZlaTE2Nis2TDFkRXlOTVpWbm16SnYxMUJKUEtyUU9QY1dv?=
 =?utf-8?B?dnA0YWNNdzkzRUMxU1RyN0g4ZFZlT21zRkxCcVNTL25SeWFFRGFJWDFZa09y?=
 =?utf-8?B?WHIxV3NCU2hWdlBXRHdmQWpVTGVoUlhKbkZCNjlLaERMVC84VGtFU29QeWlx?=
 =?utf-8?B?QTFGY3Ywa3hrZjhPekpodzBFSS9LOEhwWVZpVjJyekFJUDh3Z1lLWCsvbDhu?=
 =?utf-8?B?NGxjZUVMaGMrZnVwQlQ2VHRYMWJYcTZnbVBtR1hSMWdzTzZPM0RNSXN3OXdD?=
 =?utf-8?B?S1pYdEFPOC9DYkF3U0l0MTRWZjFpdDZ6WkRkTTZzZzJTbHBqT3VxUTNtenp4?=
 =?utf-8?B?dXdYUkdQcDJ6THZGQzM0UmZ1K1BwV2ZZK0pRRFR0SXF2OFlnSk03Z0JEMTVr?=
 =?utf-8?B?UGs4V3FvWktjK1g1TDNYamxUMlN2Q1p6Tko2TkdvZUNVeEpRb3JRQWVkTTV0?=
 =?utf-8?B?azkxN1BOcVNGSmlXRUR3K1ZTR29GRDN6TWIwbnhZL2FkcFVJRGgySkthcGlm?=
 =?utf-8?B?dXdWY3FEa0IrdlNlNXBNdUVCV3BKbFVBOW1xSnZPM1V0Z1poVmVGbGV5cklX?=
 =?utf-8?Q?b9SPFmq1UuYgDKAFRkre4WT3k4pOco=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SU5jQzhvYkNBbFFaU3hwRDd0dnFSMklNWVZSVjJiOFJKRkl5WlBtR1BsZ2g4?=
 =?utf-8?B?b0g2NnBxai9sR2JPL1VFVE9qdi9PT1hjdURpVks0c2hZckJZdjc3TzJndFBu?=
 =?utf-8?B?a0thUk5zTHpJci9XdlpqemdVVXRrUnhHOFZ1Ui80aHBmUHB4WUIva0szSkRw?=
 =?utf-8?B?T2F1bGVHdCtxVjkvUHZydnBVNzJqYTcvMHNBZjlxSkxTVFZiVXRHd3cxNHJo?=
 =?utf-8?B?djhOVzcvYlphV3hsckdYbHVxRGpVYmw0QlNiV2pvYmFoNENSSjB4QXdaQmwr?=
 =?utf-8?B?aFQrT1ZmSnA0aExMcUpvdWNyL1lEaXpJQ2x2NjdHL0s2VUtDUXBwdnZZMkkv?=
 =?utf-8?B?bFhzVjhQL1JDSWI4c0dyaHZYUE43QitWUjAySDBQUVNIY25kckNPUTBhU2Q1?=
 =?utf-8?B?aXlHTzErTDNINld2L2pXZXFpOFp4bDlBVXN3Nm1QVHh1d1FacCttWm9abGpV?=
 =?utf-8?B?dDJWMWZMY3RRK0J1cjQ2MFljVG1ha2RuWmFSSFJFTVFkTXJKYzI5Ty80dnBl?=
 =?utf-8?B?bnFOb1RpYmtQNW9semdvbm5abjk1TWFGTm1jZVErTU9PRE5tajg4QnRNTGFY?=
 =?utf-8?B?YW1HOE5rMGlZR2piYURLZmtuY0cvN3lvakJNUTl6K0o1TjNIM1ByVDdlZHRn?=
 =?utf-8?B?RkVSajJEYjJldHhMRGtjaXBnenhDVU0vNHN5VjVUQVkvbFNGQi9LbHlpcmc3?=
 =?utf-8?B?RkZDL1Y3MVBiVjFic1RrQjNIVnNSdTlIUzBRVGhJcm1IckdDNDcxOERILzR4?=
 =?utf-8?B?OFREbGtMR3RpdTBxSThWa2ozL2dicGozN2d4NVNxT3FQZGMxaEhhcjQvV1M5?=
 =?utf-8?B?a3I1L0Y1TTNmeEcydmhPdHR3aVdMNXhhdmZ3Nm9xM2VKSmNPTmJ0bWlHNTRV?=
 =?utf-8?B?Q0pjRjBZeFgyM3Z4UDgreWJhYmhoUUkrRUFUZ1kzSWIrSnoxOWJvczFYSUVE?=
 =?utf-8?B?cmNEM0RxblZZRU9DNGNjZ0RSNHVvaEwwVzRRMGpHcWVLMDRNUGJwNXB2REVh?=
 =?utf-8?B?T0JZbWFXaEhnWGdkZFdUaWpITWo5SUMzYk1jUFNzSGN3ODZUVjBaOVpxeTM2?=
 =?utf-8?B?UkRGbEVvaVZWNnQ3ZEVySFB0a2R6NzFNUWsxL1RTQldGbnBLTXluNkFkZHlv?=
 =?utf-8?B?VEFWQWEvektYUWFuZmsvNUxhbXBRMnJGUFlnem5jc0tnRjY4bzZzdXhPUk9p?=
 =?utf-8?B?cE80OUxWMHhRcGZaSmphaGkveDVqdWtLY3FUaFNDUmtVd0d5QTloZXdKZ3pQ?=
 =?utf-8?B?U3VtclZidGd1ZTZ6L2dudXBudTZnZUtLbm5OYkZtMXV4MllsQm1Id1BCcUFV?=
 =?utf-8?B?eXV3a2Z6a1QvYytTVjY4QXJ6NUEwUTJEcSt3Sk9Jc01xUWdQTHYrY3F5SnBa?=
 =?utf-8?B?b1hRWXU1RjkzRm52WGE4c1lWdGRqVlJFTVZrYXp5dnFzRnliSzRESXNycFN3?=
 =?utf-8?B?K0hmdkJmcDJlSXZNYmFOSVlVWTlxWnNzWkpaUXphNEdqRTFJTkdNRE5mVWVJ?=
 =?utf-8?B?YTVxbFBVSHVkS2VJMmVVU1BtazBEc050MFZmTlVZMGZCRGlaT1h2UUw3c3RJ?=
 =?utf-8?B?NU1jZ09EVHREWVNpM0dUVGhqWlh2ZlJVOGFkWStWQlVZMmduK0ltYWdyUWRD?=
 =?utf-8?B?QzBIYng1TDVoUlU1UVlzc0ZYc2ZaSTdUUmx1b21QdTlFNTdCbEo0eTMyVmNu?=
 =?utf-8?B?STBnMEtzVkM2VWdxbU45STVHak1LbzErNThUV01vK3M0aFY0eGV2c3hXdUhi?=
 =?utf-8?B?bjRTcjRvd0Q0OG50bmZrbGxIYkFRN1lpVURsWmQ2aDg1TDdZZks3L0l6U1Jy?=
 =?utf-8?B?dUU4Z2lIRUNOV3dyNGlpMDVLb09oY1lRaHgvQUtHbHkyaC9yV1VMV3B1Z1R1?=
 =?utf-8?B?SVAwbkZkejV3VnlyUXlid2Zsdm9JNm4xaUp3T3pmdUdPRTRHd042M2lxbVZu?=
 =?utf-8?B?ZkUzR1VjcW91VDlkQnRVWVlUb1BIRTVTdk1QR0ppaXh4L0dwZU1iekk3QVJ4?=
 =?utf-8?B?Q0xtVnhDZkJkbm9QQ2NaYXZHV1E4QXFkTHBOSExNMnZFK3VDV0JqeDRLZDZi?=
 =?utf-8?B?SzRSUHVzRU5qWm10eGJqS1JUc1FJTW1VUER1VlN3eFRzVy8wR0FVeWt6a3hx?=
 =?utf-8?Q?SkNdyP5PZtRqJet34tHL//Sk4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <45AABD2B80B69041B83AB33AE975EFA4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb85074-3bb9-4160-773e-08dd9d680988
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2025 21:47:11.8084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HQ2BcD2ELjp7k5gRyPMxoWiT9Ii+1AlSuhgyDFYdhjRWfqpe1HYVhHiAtFnyZetYRNEMhS/uSERSDjqT6lfoWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9201
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA1LTI3IGF0IDE1OjQ3ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBNYXkgMjcsIDIwMjUgYXQgMTI6MzQ6MDdQTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gPiBPbiBUdWUsIDIwMjUtMDUtMjcgYXQgMTM6MDcgKzAyMDAsIFBldGVyIFppamxz
dHJhIHdyb3RlOg0KPiA+ID4gT24gVHVlLCBNYXkgMjcsIDIwMjUgYXQgMDQ6NDQ6MzdQTSArMDgw
MCwgRWR3YXJkIEFkYW0gRGF2aXMgd3JvdGU6DQo+ID4gPiA+IGlzX3RkKCkgYW5kIGlzX3RkX3Zj
cHUoKSBydW4gaW4gbm8gaW5zdHJ1bWVudGF0aW9uLCBzbyB1c2UgX19hbHdheXNfaW5saW5lDQo+
ID4gPiA+IHRvIHJlcGxhY2UgaW5saW5lLg0KPiA+ID4gPiANCj4gPiA+ID4gWzFdDQo+ID4gPiA+
IHZtbGludXgubzogZXJyb3I6IG9ianRvb2w6IHZteF9oYW5kbGVfbm1pKzB4NDc6DQo+ID4gPiA+
ICAgICAgICAgY2FsbCB0byBpc190ZF92Y3B1LmlzcmEuMCgpIGxlYXZlcyAubm9pbnN0ci50ZXh0
IHNlY3Rpb24NCj4gPiA+ID4gDQo+ID4gPiA+IEZpeGVzOiA3MTcyYzc1M2MyNmEgKCJLVk06IFZN
WDogTW92ZSBjb21tb24gZmllbGRzIG9mIHN0cnVjdCB2Y3B1X3t2bXgsdGR4fSB0byBhIHN0cnVj
dCIpDQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IEVkd2FyZCBBZGFtIERhdmlzIDxlYWRhdmlzQHFx
LmNvbT4NCj4gPiA+ID4gLS0tDQo+ID4gPiA+IFYxIC0+IFYyOiB1c2luZyBfX2Fsd2F5c19pbmxp
bmUgdG8gcmVwbGFjZSBub2luc3RyDQo+ID4gPiA+IA0KPiA+ID4gPiAgYXJjaC94ODYva3ZtL3Zt
eC9jb21tb24uaCB8IDQgKystLQ0KPiA+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPiA+ID4gDQo+ID4gPiA+IGRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9rdm0vdm14L2NvbW1vbi5oIGIvYXJjaC94ODYva3ZtL3ZteC9jb21tb24uaA0KPiA+ID4g
PiBpbmRleCA4ZjQ2YTA2ZTJjNDQuLmEwYzVlODc4MWMzMyAxMDA2NDQNCj4gPiA+ID4gLS0tIGEv
YXJjaC94ODYva3ZtL3ZteC9jb21tb24uaA0KPiA+ID4gPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14
L2NvbW1vbi5oDQo+ID4gPiA+IEBAIC03MSw4ICs3MSw4IEBAIHN0YXRpYyBfX2Fsd2F5c19pbmxp
bmUgYm9vbCBpc190ZF92Y3B1KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiA+ID4gIA0KPiA+
ID4gPiAgI2Vsc2UNCj4gPiA+ID4gIA0KPiA+ID4gPiAtc3RhdGljIGlubGluZSBib29sIGlzX3Rk
KHN0cnVjdCBrdm0gKmt2bSkgeyByZXR1cm4gZmFsc2U7IH0NCj4gPiA+ID4gLXN0YXRpYyBpbmxp
bmUgYm9vbCBpc190ZF92Y3B1KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkgeyByZXR1cm4gZmFsc2U7
IH0NCj4gPiA+ID4gK3N0YXRpYyBfX2Fsd2F5c19pbmxpbmUgYm9vbCBpc190ZChzdHJ1Y3Qga3Zt
ICprdm0pIHsgcmV0dXJuIGZhbHNlOyB9DQo+ID4gPiA+ICtzdGF0aWMgX19hbHdheXNfaW5saW5l
IGJvb2wgaXNfdGRfdmNwdShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpIHsgcmV0dXJuIGZhbHNlOyB9
DQo+ID4gPiA+ICANCj4gPiA+ID4gICNlbmRpZg0KPiA+ID4gDQo+ID4gPiBSaWdodDsgdGhpcyBp
cyB0aGUgJ3JpZ2h0JyBmaXguIEFsdGhvdWdoIHRoZSBiZXR0ZXIgZml4IHdvdWxkIGJlIGZvciB0
aGUNCj4gPiA+IGNvbXBpbGVyIHRvIG5vdCBiZSBzdHVwaWQgOi0pDQo+IA0KPiBGV0lXLCB0aGUg
dGhpbmcgdGhhdCB0eXBpY2FsbHkgaGFwcGVucyBpcyB0aGF0IHRoZSBjb21waWxlciBmaXJzdA0K
PiBpbnNlcnRzIGluc3RydW1lbnRhdGlvbiAodGhpbmsgKlNBTikgaW50byB0aGUgdHJpdmlhbCBz
dHViIGZ1bmN0aW9uIGFuZA0KPiB0aGVuIGZpZ3VyZXMgaXRzIHRvbyBiaWcgdG8gaW5saW5lLg0K
DQpUaGlzIGlzIGhlbHBmdWwuICBUaGFua3MhDQoNCj4gDQo+ID4gSGkgUGV0ZXIsDQo+ID4gDQo+
ID4gSnVzdCBvdXQgb2YgY3VyaW9zaXR5LCBJIGhhdmUgYSByZWxhdGVkIHF1ZXN0aW9uLg0KPiA+
IA0KPiA+IEkganVzdCBsZWFybmVkIHRoZXJlJ3MgYSAnZmxhdHRlbicgYXR0cmlidXRlICgnX19m
bGF0dGVuJyBpbiBsaW51eCBrZXJuZWwpDQo+ID4gc3VwcG9ydGVkIGJ5IGJvdGggZ2NjIGFuZCBj
bGFuZy4gIElJVUMgaXQgZm9yY2VzIGFsbCBmdW5jdGlvbiBjYWxscyBpbnNpZGUgb25lDQo+ID4g
ZnVuY3Rpb24gdG8gYmUgaW5saW5lZCBpZiB0aGF0IGZ1bmN0aW9uIGlzIGFubm90YXRlZCB3aXRo
IHRoaXMgYXR0cmlidXRlLg0KPiA+IA0KPiA+IEhvd2V2ZXIsIGl0IHNlZW1zIGdjYyBhbmQgY2xh
bmcgaGFuZGxlcyAicmVjdXJzaXZlIGlubGluaW5nIiBkaWZmZXJlbnRseS4gIGdjYw0KPiA+IHNl
ZW1zIHN1cHBvcnRzIHJlY3Vyc2l2ZSBpbmxpbmluZyB3aXRoIGZsYXR0ZW4sIGJ1dCBjbGFuZyBz
ZWVtcyBub3QuDQo+ID4gDQo+ID4gVGhpcyBpcyB0aGUgZ2NjIGRvYyBbMV0gc2F5cywgd2hpY2gg
ZXhwbGljaXRseSB0ZWxscyByZWN1cnNpdmUgaW5saW5pbmcgaXMNCj4gPiBzdXBwb3J0ZWQgSUlV
QzoNCj4gPiANCj4gPiAgIGZsYXR0ZW4NCj4gPiAgIA0KPiA+ICAgR2VuZXJhbGx5LCBpbmxpbmlu
ZyBpbnRvIGEgZnVuY3Rpb24gaXMgbGltaXRlZC4gRm9yIGEgZnVuY3Rpb24gbWFya2VkIHdpdGgg
DQo+ID4gICB0aGlzIGF0dHJpYnV0ZSwgZXZlcnkgY2FsbCBpbnNpZGUgdGhpcyBmdW5jdGlvbiBp
cyBpbmxpbmVkIGluY2x1ZGluZyB0aGUgY2FsbHMNCj4gPiAgIHN1Y2ggaW5saW5pbmcgaW50cm9k
dWNlcyB0byB0aGUgZnVuY3Rpb24gKGJ1dCBub3QgcmVjdXJzaXZlIGNhbGxzIHRvIHRoZSANCj4g
PiAgIGZ1bmN0aW9uIGl0c2VsZiksIGlmIHBvc3NpYmxlLg0KPiA+IA0KPiA+IEFuZCB0aGlzIGlz
IHRoZSBjbGFuZyBkb2MgWzJdIHNheXMsIHdoaWNoIGRvZXNuJ3Qgc2F5IGFib3V0IHJlY3Vyc2l2
ZSBpbmxpbmluZzoNCj4gPiANCj4gPiAgIGZsYXR0ZW4NCj4gPiANCj4gPiAgIFRoZSBmbGF0dGVu
IGF0dHJpYnV0ZSBjYXVzZXMgY2FsbHMgd2l0aGluIHRoZSBhdHRyaWJ1dGVkIGZ1bmN0aW9uIHRv
IGJlIA0KPiA+ICAgaW5saW5lZCB1bmxlc3MgaXQgaXMgaW1wb3NzaWJsZSB0byBkbyBzbywgZm9y
IGV4YW1wbGUgaWYgdGhlIGJvZHkgb2YgdGhlIA0KPiA+ICAgY2FsbGVlIGlzIHVuYXZhaWxhYmxl
IG9yIGlmIHRoZSBjYWxsZWUgaGFzIHRoZSBub2lubGluZSBhdHRyaWJ1dGUuDQo+ID4gDQo+ID4g
QWxzbywgb25lICJBSSBPdmVydmlldyIgcHJvdmlkZWQgYnkgZ29vZ2xlIGFsc28gc2F5cyBiZWxv
dzoNCj4gPiANCj4gPiAgIENvbXBpbGVyIEJlaGF2aW9yOg0KPiA+ICAgV2hpbGUgR0NDIHN1cHBv
cnRzIHJlY3Vyc2l2ZSBpbmxpbmluZyB3aXRoIGZsYXR0ZW4sIG90aGVyIGNvbXBpbGVycyBsaWtl
ICANCj4gPiAgIENsYW5nIG1pZ2h0IG9ubHkgcGVyZm9ybSBhIHNpbmdsZSBsZXZlbCBvZiBpbmxp
bmluZy4NCj4gPiANCj4gPiBKdXN0IHdvbmRlcmluZyB3aGV0aGVyIHlvdSBjYW4gaGFwcGVuIHRv
IGNvbmZpcm0gdGhpcz8NCj4gPiANCj4gPiBUaGF0IGFsc28gYmVpbmcgc2FpZCwgaWYgdGhlIF9f
ZmxhdHRlbiBjb3VsZCBhbHdheXMgYmUgInJlY3Vyc2l2ZSBpbmxpbmluZyIsIGl0DQo+ID4gc2Vl
bXMgdG8gbWUgdGhhdCBfX2ZsYXR0ZW4gd291bGQgYmUgYSBiZXR0ZXIgYW5ub3RhdGlvbiB3aGVu
IHdlIHdhbnQgc29tZQ0KPiA+IGZ1bmN0aW9uIHRvIGJlIG5vaW5zdHIuICBCdXQgaWYgaXQncyBi
ZWhhdmlvdXIgaXMgY29tcGlsZXIgZGVwZW5kZW50LCBpdCBzZWVtcw0KPiA+IGl0J3Mgbm90IGEg
Z29vZCBpZGVhIHRvIHVzZSBpdC4NCj4gPiANCj4gPiBXaGF0J3MgeW91ciBvcGluaW9uIG9uIHRo
aXM/DQo+IA0KPiBJIGFtIHNvbWV3aGF0IGNvbmZsaWN0ZWQgb24gdGhpczsgdXNpbmcgX19mbGF0
dGVuLCB3aGlsZSBjb252ZW5pZW50LA0KPiB3b3VsZCB0YWtlIGF3YXkgdGhlIGltbWVkaWF0ZSBp
bnNpZ2h0IGludG8gd2hhdCBnZXRzIHB1bGxlZCBpbi4gSGF2aW5nDQo+IHRvIGV4cGxpY2l0bHkg
bWFyayBmdW5jdGlvbnMgd2l0aCBfX2Fsd2F5c19pbmxpbmUgaXMgc29tZXdoYXQNCj4gaW5jb252
ZW5pZW50LCBidXQgYXQgbGVhc3QgeW91IGRvbid0IHB1bGwgaW4gc3R1ZmYgYnkgYWNjaWRlbnQu
DQoNClllYWgsIHRoYW5rcyBhbnl3YXkgZm9yIHRoZSBpbnNpZ2h0Lg0K

