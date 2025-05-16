Return-Path: <kvm+bounces-46911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 663F4ABA5F8
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 00:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 815A7188809E
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 22:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ADE228001A;
	Fri, 16 May 2025 22:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dUXF3XWk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF9223497B;
	Fri, 16 May 2025 22:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747434998; cv=fail; b=l//L1dXqFbwO1VnfOo2yYf9ke8yQSBeoo4RFFSovpUgBxfNfGfu7wUnEnzWT8y9I2D0rkUP621pzhZrkmzu5iDZhkTNl6f4TEbBpMhYQ39maM2HtLfavyG3mmgJnlm77HpXuw+KdL6XbFtpil4T2udoKnmlJPpHemL+PzCdkOoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747434998; c=relaxed/simple;
	bh=HWFLIiOMcTaXlTb+mUYjW7NGDbzRslEnGgrS8TJmlhU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VMm/r5YusaC6jigEIZ6QR3/OG3oOoQc3qiO92Rw59TOE4jlnI5dX4W74bK4G+F8bQkmY/q4m3WuAn/y3732NXVvW3WyTjiIi25TNtQd30ao20+DnGN/L+3OiKjBhHCYoHczfN7smOPgMN/vToas+zLpORa1a321YK+w8wANQZkk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dUXF3XWk; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747434996; x=1778970996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HWFLIiOMcTaXlTb+mUYjW7NGDbzRslEnGgrS8TJmlhU=;
  b=dUXF3XWkNnlF5bdFcySCYOsSVHkoy0IOJCL7WExSK31HSo0wGi7ed2vr
   gBAk2a9rNbGvC9zCW9RaSV+2iOf7my/3J25NNhBNSqdNL6RaAW8K//oXR
   UP0uEriruQagJXBVEImV+jmFUnoY5UUazrie1gA+Ey6/1CeDtQQs7EMZp
   CBnzrs7CM1zhkTzbBqJ6WeRRE5onmNg7IIKRE5c3bkLP6OXCY3k2MPxGx
   XTHrfZHfXkhZfC7g/Ji6Mx8YT1ARNlZKC3RG93DOi7is6JlIEO0HyG7yk
   R4rFN+sCw5BOeJXBtPFTim8lOgrBn7qoiTjkvGjkj46RqvdEqs+BCm5kj
   A==;
X-CSE-ConnectionGUID: miguMvmSSk2/sneSk6GjiQ==
X-CSE-MsgGUID: BQsBTX/LQbaoBVACRgYntw==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="60056869"
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="60056869"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 15:36:33 -0700
X-CSE-ConnectionGUID: Oh98XtMcQHOwXcnoLsId0w==
X-CSE-MsgGUID: dxnKn6tGSjWxEpm2nVDhiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="144061360"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 15:36:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 15:36:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 15:36:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 15:36:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tWMwanhL8sso/vTtkBKFk3VQAdeIv2JAFpHQ94/fMdTmkyG9Zd51U1p24DGHqc3D2CSM/Beusuv9ncj2se0w6anstziVP5McYM5O8fg3JrQijfwn5xK1eIiK7+KkAZVQEXRqjrfAF8I2CYjw31tEmvBKZkE2+Wy8cFci8s2YSi7KZ6WTumoJjmocqJ2sx0SbIyAbxp9x0OAuL2Tygag+wZSBtV7HMyleVRTGE7iYvogh+7kbiDtEVUreS9imcmH5iHX8dtxm/+TVErPXOlrpzl0wuHtA/z6blSxsqSu6h/P+osUNF/913A7KQM2puKiUZCAokuG03akxuhCiT/H3yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWFLIiOMcTaXlTb+mUYjW7NGDbzRslEnGgrS8TJmlhU=;
 b=r8x3du4w51Upz1NhstU8DOq9pEHdE9gi01l3Rl2I4BGVXoi5bWRQSCqBWe/2w8oBDpqGZNTptXrG5RVji4mryDmbIaUgDZxC9OzBaML7c6V3xtU6tiwHp6YgU2h0+J/9fnVPEcTrpFQuGFITLVBMx46v19OredFyZl7e4qPB6vCC8RfOOhpxbjpJ4Y3QFND6v+24KQD70NiMPNe/c/2xmm3AtyFG0mfDZdgm6aeZx88qrlZreyNNhcogzAk5k5we4LOKKi2zH5QDh+QmGPQ1Qp9e3ejszL7eoEeSTxAPGV+MBK/0oOwEU4yuFPa/VO/6bbCoXJZo9nJaStTyxvP4DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3303.namprd11.prod.outlook.com (2603:10b6:a03:18::15)
 by DM4PR11MB5993.namprd11.prod.outlook.com (2603:10b6:8:5c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 22:35:58 +0000
Received: from BYAPR11MB3303.namprd11.prod.outlook.com
 ([fe80::c67e:581f:46f5:f79c]) by BYAPR11MB3303.namprd11.prod.outlook.com
 ([fe80::c67e:581f:46f5:f79c%6]) with mapi id 15.20.8722.027; Fri, 16 May 2025
 22:35:57 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"Du, Fan" <fan.du@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"tabba@google.com" <tabba@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMZBhA49+LJMgEuvNu90MMjg/bPRHIEAgAN/lACAAIg8AIAA1+cA
Date: Fri, 16 May 2025 22:35:57 +0000
Message-ID: <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030618.352-1-yan.y.zhao@intel.com>
	 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
	 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
	 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3303:EE_|DM4PR11MB5993:EE_
x-ms-office365-filtering-correlation-id: f1e8035e-867a-4031-5e8b-08dd94ca06cd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UkpRT0IxWlFMWm1RZmxOcFZCOUdKS2QvUzNiSlFkRXpURzlsL29RWXRyMkI2?=
 =?utf-8?B?QmxURlRuSlNDcWpwTE11d2NsYWk2QWU5ZUwwVHhZSStsQTFpb3Vjd0ttanUx?=
 =?utf-8?B?QnQzdk1PVDN3ZUMvSDRsNmhONDBZcW5wWTdFMnhSZEFrYk9EVUxoejFUQkYr?=
 =?utf-8?B?K1BMVCtEWld3VEllNjd3clBjZEdmanFEcmN6bjVzTE1TU3R6SjN5cklSbHU2?=
 =?utf-8?B?TitrTzVKTk0wWmNjcldOZlVRSk1scEdYeXRnU1NZczNDK1E5UGNNMUxuQXl1?=
 =?utf-8?B?SldXK09DUnVhRm1VK0tuSUFpQXZWZVhta1pudmF2UXBFb2ExMkVkT05SVnhP?=
 =?utf-8?B?YmwzMXEwS3FLWFQzZXRxU2haYlh2bDlZTDc5UVI1cUtUVW1US2IzVDc3L1Vu?=
 =?utf-8?B?b0E3U0Fnb2t1cXNXTzBzT0lKUzdVc1BkdDZHOTNtMHpBRzJNL2hYdDVzUnR1?=
 =?utf-8?B?WEt3b1NRR1RwT1VXTjU3SkpPd0lLU0JDbXRHU0MxYkpRKzFWaWViM1g0clJj?=
 =?utf-8?B?ZnFoQkVNbCtnU2ZRUEVZblhLdVVoaU51dDdIeGs1RXI4bGJsQTF3bTZucmRq?=
 =?utf-8?B?RnFiWjZXRXJoRGo0bks0bG9nb1g0ais4UFc3S0c4RndsK1JzRlVWTXl1NDRw?=
 =?utf-8?B?WUNNaUU1VHlpS3Nsb045QTZmdzFXTjJUZ3NyTm0wdlFpa1pEVExOVVhTM3l2?=
 =?utf-8?B?R216bjE3RENLL284elRqajVGalpzOXRyYVE3UUhHRFd4bmw1eHVpWW9vTmVC?=
 =?utf-8?B?c3VyTXVlWlJNZFhvTnV5RVlKeUF2Y3V0S3kyb2FqWVAvZGxFQitHdmhzUlhj?=
 =?utf-8?B?YlNUWlZ0TldBNWI1UzNyWjZlNmRlNVNxeVc1VXBiUVhSL2wzWWl2Nk5acjBI?=
 =?utf-8?B?RmwvdHVLL0V6Tjc3ckJKcEFpZ0VOUFk5cUxZb2tzS0ZONjY5bTRFYUlQVTNL?=
 =?utf-8?B?dUExYklMeWNYWU5GdWJ6ODRSaXZyVEtJMEthQy9zZ3NveE9kaHRmSTRDeHFG?=
 =?utf-8?B?anFnRnhRRUs2NWZZbkFkenVhQnljbTZHRERqR0FaUUF1Y0prSkpoTVZYdGFq?=
 =?utf-8?B?N3ZmOENycUR1eHRGYStua1psSm5VY0lNWGJWTWcwWTVrL2h2MERIclBLUGls?=
 =?utf-8?B?TnZBN0lnOHRWRkxrTUt2aTRkalB5ZGFScEl2NHk1MS8xblhkby9RRGRTYzYx?=
 =?utf-8?B?d0FTMG9RRWdFT0l0M3dVbnRlMUxMblVNS21ZK3RWc2hTejFQdFFhYVZkN1o0?=
 =?utf-8?B?UHA0Q2tmYnpScnhvY3BBSk5VRkxiM0hNREFwS2VScENON2pud09lMi9ZdHZY?=
 =?utf-8?B?OUdoc0lNeUdGWStjSEpGNGxjN001QUhNRDJxL0V5b1RBWStRdGdIZEJTOCtp?=
 =?utf-8?B?SUpTVklCVmIyTHV6bS9jN1J6UjlkdElRajFOU2MybXUrTVFaVHFYZE5Sc0xK?=
 =?utf-8?B?K3IydkdrZFlNNmpMNDRTYlh6ZWZYS2dqNlFWUklOZWRWNHpuL0xBR1VjOWdS?=
 =?utf-8?B?OGkramdlMG5TK21ZaTc1d25lVXNoV2VzZ2pXZVgxNUVMVjFvUGNGVXVLVEkw?=
 =?utf-8?B?eTZISVFGeWh6aEt4S2RNNWlGQ3RXM2gzSXhzNzFORFJpMjVkWkxQTE85MWMw?=
 =?utf-8?B?QXFlNHpDOFZwbEkrWG81aWNtMGVsemQ5bXo3MUxQVkY2ZkdYQ1MyWUhoL0lK?=
 =?utf-8?B?dHhDenJCanR6VkNKSGhBQi9HWVkxNXBlVlUyaHZhVVNhbGduT1F3SzhQYmd6?=
 =?utf-8?B?WU9TeW9QN3VndWt4RHlWSXZUb1dSdkVlMVpmUCtNWi9SemFTVmpUaVZab2Jy?=
 =?utf-8?B?ZDhkM0l2T0Z2ckk1Lzk0eWhFbGcrdWdUb1FtdHlMSkJnSUVISWl5Q1B3a1Rt?=
 =?utf-8?B?RENKdWlJcTQ2aGp5UFNORXhDM1hiK0NLYTNZZDhzNVlmbnlHWko4bVdlQ2xT?=
 =?utf-8?Q?dKpgFjYt2sI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3303.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlJZVXZoTzVmVkJQTWQvd0YzU2hjeXZsRVVnai9pbmYzQ0RBRW55ZkE5UDlQ?=
 =?utf-8?B?TmdxUy9KMU9VQUZZb01YYWFMaEU4WG9VTGlVRzMzVU1DZHJwenRoQ1BGSm1r?=
 =?utf-8?B?ZXZndjJkazVBWHlrZnFUUGtaRVl4ZjVYdjZuN2hlZTliM3NqcXpUZytNK1U0?=
 =?utf-8?B?Wlh6T0E3dzltWkRLVGtHd09teENyMldMK1JJK2lUVWltN3BpU0tKS1FyczV0?=
 =?utf-8?B?d0Ywb25udXkyeGRMT3U3NzZtcGM5OWNLRDdqUndhMHA0cTExcDIvOGg4OWVR?=
 =?utf-8?B?aXR1ZXNBRHIyeHhZWWNqODhrUjFFR0I0QmNxZzMwbFFhdEtrOENMa0c4UXJx?=
 =?utf-8?B?M2xjM3M1dFJuS0JtTmd3a1N1dHlsaUV6ZVdVS3Iwd3hBNkxSTk0zRUxNQito?=
 =?utf-8?B?T2ltc2ZCbHRlRllVZXpNVk0yWFpWcjI4NGIrSTBHMWxtVkZ3c3BoWHE3YlZU?=
 =?utf-8?B?RVp3SGNON0Via21vUzVldjlMQ0JxdlhRRE5mNkpSVlk5aFRiOXBrUjVMS1Zq?=
 =?utf-8?B?RVZWTTYza1Q1cGFSU05QZ2ZsOGpWZmtpVDJLWDBrR29HODF1RHBvR3FUUjN2?=
 =?utf-8?B?anhUUmF1QWkyTkErNTN5QWJ5TGZ5Vkw3SUZjeVFDamhybllOVzdoWVgzR2pI?=
 =?utf-8?B?N1lIMWRwTFVCUndTSDB0UWpRVkp6QWtIaTNoc1ZPZHd3YXVFbEZQb0I0dURj?=
 =?utf-8?B?UmxscDAvVVZPRmdIV1FlSFVxeUw0NW1tYVdtTE1xKzUvczNFL2IydmcxZEU3?=
 =?utf-8?B?K05nTHZDVXN3YkJXalg3REZxVXF6WHhWMElzZkM0WHpJUFhuTHQybHhqUnhO?=
 =?utf-8?B?d21TdTU2S0VzUHI2S3pqTitKQlVESWZPek5tWkR6L0RUbG5rNUlCNmVtdFkv?=
 =?utf-8?B?ZGUzWXRwYXN3Zk50Qnh5cHNFSjF1MVJ5aG4wcU9aMUZjb29pcUFOSWRxWmZ5?=
 =?utf-8?B?NTlLV3hudmhvTHBKOFozUUI5bkVUVEpZR0RxaFhhNEozTkxMQXZQajdiUnox?=
 =?utf-8?B?NjdyOTBvMDkzMWxyelI1cjl5RUloU20vWHdWek9SYnhqNzJ4ZzBDMnhKN2pI?=
 =?utf-8?B?b00vd01XL1UzeUNoVTVBYlZqRFVidmRMT3pGK3k3VGtHSlpUTzB4U0drTUtl?=
 =?utf-8?B?YU0yR094YStBeTFvdnozWldLaEpNV3pJcUNjcnpmK2E3clUxcWpacEprUlYx?=
 =?utf-8?B?VWxML05KelR0Y0FGWEFka25kS1J0RkdDN1pGc2M1VUZCa2hPNDRKY2s1VmRR?=
 =?utf-8?B?SGhYeFF6Yzl1ODlVRU9sQ1dSME9sT01wTW5OalFIU2o5cEp1U29URTN6emQ5?=
 =?utf-8?B?dVFsVHJTQVExZ0tHL1Q0eGhiU3JJWWJZTklVVEVCcnhCWHVZZDFnYXdDdmdP?=
 =?utf-8?B?bzJJQTNWNzQzUFRMTFVzVTEyK1lUNG83SXJZQk5PSkExTGZaalJLYUhjNnM2?=
 =?utf-8?B?QTg3Uk1TaUdRSUxEdncvV3NMQWFDM2IrYk95WEZ3aWRGc01Wb1p5VVZoQnlV?=
 =?utf-8?B?eElCb1dyZHdyRlNKbENlZXlqVXJteUtadnFNdDM0S3lZV29sck4yQmU2cmd2?=
 =?utf-8?B?V01EektGUmxhL2ZZR29PZVVlbmtNTU5UdkZGNW5aWnV2UVRVaTR2elF6NVBI?=
 =?utf-8?B?bXRPc2s2Z2IwazJCZVlSdytMVUVhLytibk1YQk8vYW42R1V1aVRwaUM1OHdl?=
 =?utf-8?B?MC9wbGVxWFJCNXkrQVoxZmFLS2UrYy9BaldkQ0RhOWUzbngwSENMU2FxaVZM?=
 =?utf-8?B?bUE5NEhXVE9zYURpaWRKc1ZyK1ljczdJWmtFZWh6dHpIZW9aUHIrMHNnQWJR?=
 =?utf-8?B?amxhMUpjSVBvaml2QXRXaFkrUXNuNE0wWUpkLzV1NjdBWHFvVk1EZWxCWTc4?=
 =?utf-8?B?RTM2WGNoM2VSZHY2ODR4bWU5cHBGaktmRWZ4T05pZ0VXeWZrUUZweDNyMHdB?=
 =?utf-8?B?NmNQMks2NUw1aWFUcDRndzZscGNuZDR2TTBkM2psMEFOWFlOcnlOYXN5dXZu?=
 =?utf-8?B?Q3lQbU11TE4wZFozdjh5dzlydllweHViUFkrMXFFdEhUYzlFeTZISHAvSC9l?=
 =?utf-8?B?cC9rK21qSTUvMkNxTlFvcTVFZDJ3SkdFd1hhUlB3L0ttL2lPeXhZUUdvRHhS?=
 =?utf-8?Q?jxt93rp7YT4wZY7ndxTxn8gfF?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9D93D633E50964AB8039DC3FA0673C4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3303.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1e8035e-867a-4031-5e8b-08dd94ca06cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2025 22:35:57.4539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /FdF0XWtQsbT/pIC1iyrvdffXVvF6yjKVXFE1e6sePoGBgZ36QH1HLaj0LyZi+14eMHu76k6o3Xyjjqm61MNZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5993
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTE2IGF0IDE3OjQzICswODAwLCBaaGFvLCBZYW4gWSB3cm90ZToNCj4g
T24gRnJpLCBNYXkgMTYsIDIwMjUgYXQgMDk6MzU6MzdBTSArMDgwMCwgSHVhbmcsIEthaSB3cm90
ZToNCj4gPiBPbiBUdWUsIDIwMjUtMDUtMTMgYXQgMjA6MTAgKzAwMDAsIEVkZ2Vjb21iZSwgUmlj
ayBQIHdyb3RlOg0KPiA+ID4gPiBAQCAtMzI2NSw3ICszMjYzLDcgQEAgaW50IHRkeF9nbWVtX3By
aXZhdGVfbWF4X21hcHBpbmdfbGV2ZWwoc3RydWN0IGt2bSAqa3ZtLCBrdm1fcGZuX3QgcGZuKQ0K
PiA+ID4gPiDCoMKgCWlmICh1bmxpa2VseSh0b19rdm1fdGR4KGt2bSktPnN0YXRlICE9IFREX1NU
QVRFX1JVTk5BQkxFKSkNCj4gPiA+ID4gwqDCoAkJcmV0dXJuIFBHX0xFVkVMXzRLOw0KPiA+ID4g
PiDCoCANCj4gPiA+ID4gLQlyZXR1cm4gUEdfTEVWRUxfNEs7DQo+ID4gPiA+ICsJcmV0dXJuIFBH
X0xFVkVMXzJNOw0KPiA+ID4gDQo+ID4gPiBNYXliZSBjb21iaW5lIHRoaXMgd2l0aCBwYXRjaCA0
LCBvciBzcGxpdCB0aGVtIGludG8gc2Vuc2libGUgY2F0ZWdvcmllcy4NCj4gPiANCj4gPiBIb3cg
YWJvdXQgbWVyZ2Ugd2l0aCBwYXRjaCAxMg0KPiA+IA0KPiA+ICAgW1JGQyBQQVRDSCAxMi8yMV0g
S1ZNOiBURFg6IERldGVybWluZSBtYXggbWFwcGluZyBsZXZlbCBhY2NvcmRpbmcgdG8gdkNQVSdz
IA0KPiA+ICAgQUNDRVBUIGxldmVsDQo+ID4gDQo+ID4gaW5zdGVhZD8NCj4gPiANCj4gPiBQZXIg
cGF0Y2ggMTIsIHRoZSBmYXVsdCBkdWUgdG8gVERILk1FTS5QQUdFLkFDQ1BUIGNvbnRhaW5zIGZh
dWx0IGxldmVsIGluZm8sIHNvDQo+ID4gS1ZNIHNob3VsZCBqdXN0IHJldHVybiB0aGF0LiAgQnV0
IHNlZW1zIHdlIGFyZSBzdGlsbCByZXR1cm5pbmcgUEdfTEVWRUxfMk0gaWYgbm8NCj4gPiBzdWNo
IGluZm8gaXMgcHJvdmlkZWQgKElJVUMpOg0KPiBZZXMsIGlmIHdpdGhvdXQgc3VjaCBpbmZvICh0
ZHgtPnZpb2xhdGlvbl9yZXF1ZXN0X2xldmVsKSwgd2UgYWx3YXlzIHJldHVybg0KPiBQR19MRVZF
TF8yTS4NCj4gDQo+IA0KPiA+IGludCB0ZHhfZ21lbV9wcml2YXRlX21heF9tYXBwaW5nX2xldmVs
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwga3ZtX3Bmbl90IHBmbiwgDQo+ID4gCQkJCSAgICAgICBn
Zm5fdCBnZm4pDQo+ID4gIHsNCj4gPiArCXN0cnVjdCB2Y3B1X3RkeCAqdGR4ID0gdG9fdGR4KHZj
cHUpOw0KPiA+ICsNCj4gPiAgCWlmICh1bmxpa2VseSh0b19rdm1fdGR4KHZjcHUtPmt2bSktPnN0
YXRlICE9IFREX1NUQVRFX1JVTk5BQkxFKSkNCj4gPiAgCQlyZXR1cm4gUEdfTEVWRUxfNEs7DQo+
ID4gIA0KPiA+ICsJaWYgKGdmbiA+PSB0ZHgtPnZpb2xhdGlvbl9nZm5fc3RhcnQgJiYgZ2ZuIDwg
dGR4LT52aW9sYXRpb25fZ2ZuX2VuZCkNCj4gPiArCQlyZXR1cm4gdGR4LT52aW9sYXRpb25fcmVx
dWVzdF9sZXZlbDsNCj4gPiArDQo+ID4gIAlyZXR1cm4gUEdfTEVWRUxfMk07DQo+ID4gIH0NCj4g
PiANCj4gPiBTbyB3aHkgbm90IHJldHVybmluZyBQVF9MRVZFTF80SyBhdCB0aGUgZW5kPw0KPiA+
IA0KPiA+IEkgYW0gYXNraW5nIGJlY2F1c2UgYmVsb3cgdGV4dCBtZW50aW9uZWQgaW4gdGhlIGNv
dmVybGV0dGVyOg0KPiA+IA0KPiA+ICAgICBBIHJhcmUgY2FzZSB0aGF0IGNvdWxkIGxlYWQgdG8g
c3BsaXR0aW5nIGluIHRoZSBmYXVsdCBwYXRoIGlzIHdoZW4gYSBURA0KPiA+ICAgICBpcyBjb25m
aWd1cmVkIHRvIHJlY2VpdmUgI1ZFIGFuZCBhY2Nlc3NlcyBtZW1vcnkgYmVmb3JlIHRoZSBBQ0NF
UFQNCj4gPiAgICAgb3BlcmF0aW9uLiBCeSB0aGUgdGltZSBhIHZDUFUgYWNjZXNzZXMgYSBwcml2
YXRlIEdGTiwgZHVlIHRvIHRoZSBsYWNrDQo+ID4gICAgIG9mIGFueSBndWVzdCBwcmVmZXJyZWQg
bGV2ZWwsIEtWTSBjb3VsZCBjcmVhdGUgYSBtYXBwaW5nIGF0IDJNQiBsZXZlbC4NCj4gPiAgICAg
SWYgdGhlIFREIHRoZW4gb25seSBwZXJmb3JtcyB0aGUgQUNDRVBUIG9wZXJhdGlvbiBhdCA0S0Ig
bGV2ZWwsDQo+ID4gICAgIHNwbGl0dGluZyBpbiB0aGUgZmF1bHQgcGF0aCB3aWxsIGJlIHRyaWdn
ZXJlZC4gSG93ZXZlciwgdGhpcyBpcyBub3QNCj4gPiAgICAgcmVnYXJkZWQgYXMgYSB0eXBpY2Fs
IHVzZSBjYXNlLCBhcyB1c3VhbGx5IFREIGFsd2F5cyBhY2NlcHRzIHBhZ2VzIGluDQo+ID4gICAg
IHRoZSBvcmRlciBmcm9tIDFHQi0+Mk1CLT40S0IuIFRoZSB3b3JzdCBvdXRjb21lIHRvIGlnbm9y
ZSB0aGUgcmVzdWx0aW5nDQo+ID4gICAgIHNwbGl0dGluZyByZXF1ZXN0IGlzIGFuIGVuZGxlc3Mg
RVBUIHZpb2xhdGlvbi4gVGhpcyB3b3VsZCBub3QgaGFwcGVuDQo+ID4gICAgIGZvciBhIExpbnV4
IGd1ZXN0LCB3aGljaCBkb2VzIG5vdCBleHBlY3QgYW55ICNWRS4NCj4gPiANCj4gPiBDaGFuZ2lu
ZyB0byByZXR1cm4gUFRfTEVWRUxfNEsgc2hvdWxkIGF2b2lkIHRoaXMgcHJvYmxlbS4gIEl0IGRv
ZXNuJ3QgaHVydA0KPiBGb3IgVERzIGV4cGVjdCAjVkUsIGd1ZXN0cyBhY2Nlc3MgcHJpdmF0ZSBt
ZW1vcnkgYmVmb3JlIGFjY2VwdCBpdC4NCj4gSW4gdGhhdCBjYXNlLCB1cG9uIEtWTSByZWNlaXZl
cyBFUFQgdmlvbGF0aW9uLCB0aGVyZSdzIG5vIGV4cGVjdGVkIGxldmVsIGZyb20NCj4gdGhlIFRE
WCBtb2R1bGUuIFJldHVybmluZyBQVF9MRVZFTF80SyBhdCB0aGUgZW5kIGJhc2ljYWxseSBkaXNh
YmxlcyBodWdlIHBhZ2VzDQo+IGZvciB0aG9zZSBURHMuDQoNCkp1c3Qgd2FudCB0byBtYWtlIHN1
cmUgSSB1bmRlcnN0YW5kIGNvcnJlY3RseToNCg0KTGludXggVERzIGFsd2F5cyBBQ0NFUFQgbWVt
b3J5IGZpcnN0IGJlZm9yZSB0b3VjaGluZyB0aGF0IG1lbW9yeSwgdGhlcmVmb3JlIEtWTQ0Kc2hv
dWxkIGFsd2F5cyBiZSBhYmxlIHRvIGdldCB0aGUgYWNjZXB0IGxldmVsIGZvciBMaW51eCBURHMu
DQoNCkluIG90aGVyIHdvcmRzLCByZXR1cm5pbmcgUEdfTEVWRUxfNEsgZG9lc24ndCBpbXBhY3Qg
ZXN0YWJsaXNoaW5nIGxhcmdlIHBhZ2UNCm1hcHBpbmcgZm9yIExpbnV4IFREcy4NCg0KSG93ZXZl
ciwgb3RoZXIgVERzIG1heSBjaG9vc2UgdG8gdG91Y2ggbWVtb3J5IGZpcnN0IHRvIHJlY2VpdmUg
I1ZFIGFuZCB0aGVuDQphY2NlcHQgdGhhdCBtZW1vcnkuICBSZXR1cm5pbmcgUEdfTEVWRUxfMk0g
YWxsb3dzIHRob3NlIFREcyB0byB1c2UgbGFyZ2UgcGFnZQ0KbWFwcGluZ3MgaW4gU0VQVC4gIE90
aGVyd2lzZSwgcmV0dXJuaW5nIFBHX0xFVkVMXzRLIGVzc2VudGlhbGx5IGRpc2FibGVzIGxhcmdl
DQpwYWdlIGZvciB0aGVtIChzaW5jZSB3ZSBkb24ndCBzdXBwb3J0IFBST01PVEUgZm9yIG5vdz8p
Lg0KDQpCdXQgaW4gdGhlIGFib3ZlIHRleHQgeW91IG1lbnRpb25lZCB0aGF0LCBpZiBkb2luZyBz
bywgYmVjYXVzZSB3ZSBjaG9vc2UgdG8NCmlnbm9yZSBzcGxpdHRpbmcgcmVxdWVzdCBvbiByZWFk
LCByZXR1cm5pbmcgMk0gY291bGQgcmVzdWx0IGluICplbmRsZXNzKiBFUFQNCnZpb2xhdGlvbi4N
Cg0KU28gdG8gbWUgaXQgc2VlbXMgeW91IGNob29zZSBhIGRlc2lnbiB0aGF0IGNvdWxkIGJyaW5n
IHBlcmZvcm1hbmNlIGdhaW4gZm9yDQpjZXJ0YWluIG5vbi1MaW51eCBURHMgd2hlbiB0aGV5IGZv
bGxvdyBhIGNlcnRhaW4gYmVoYXZpb3VyIGJ1dCBvdGhlcndpc2UgY291bGQNCnJlc3VsdCBpbiBl
bmRsZXNzIEVQVCB2aW9sYXRpb24gaW4gS1ZNLg0KDQpJIGFtIG5vdCBzdXJlIGhvdyBpcyB0aGlz
IE9LPyAgT3IgcHJvYmFibHkgSSBoYXZlIG1pc3VuZGVyc3RhbmRpbmc/DQoNCj4gDQo+IEJlc2lk
ZXMsIGFjY29yZGluZyB0byBLaXJpbGwgWzFdLCB0aGUgb3JkZXIgZnJvbSAxR0ItPjJNQi0+NEtC
IGlzIG9ubHkgdGhlIGNhc2UNCj4gZm9yIGxpbnV4IGd1ZXN0cy4NCj4gDQo+IFsxXSBodHRwczov
L2xvcmUua2VybmVsLm9yZy9hbGwvNnZkajRtZnhseXZ5cG43NDNrbHhxNXR3ZGE2NnRrdWd3emxq
ZHQyNzVydWcyZ213d2xAemR6aXlseHByZTZ5LyN0DQoNCkkgYW0gbm90IHN1cmUgaG93IGlzIHRo
aXMgcmVsYXRlZD8NCg0KT24gdGhlIG9wcG9zaXRlLCBpZiBvdGhlciBub24tTGludXggVERzIGRv
bid0IGZvbGxvdyAxRy0+Mk0tPjRLIGFjY2VwdCBvcmRlciwNCmUuZy4sIHRoZXkgYWx3YXlzIGFj
Y2VwdCA0SywgdGhlcmUgY291bGQgYmUgKmVuZGxlc3MgRVBUIHZpb2xhdGlvbiogaWYgSQ0KdW5k
ZXJzdGFuZCB5b3VyIHdvcmRzIGNvcnJlY3RseS4NCg0KSXNuJ3QgdGhpcyB5ZXQtYW5vdGhlciBy
ZWFzb24gd2Ugc2hvdWxkIGNob29zZSB0byByZXR1cm4gUEdfTEVWRUxfNEsgaW5zdGVhZCBvZg0K
Mk0gaWYgbm8gYWNjZXB0IGxldmVsIGlzIHByb3ZpZGVkIGluIHRoZSBmYXVsdD8NCg0KPiANCj4g
PiBub3JtYWwgY2FzZXMgZWl0aGVyLCBzaW5jZSBndWVzdCB3aWxsIGFsd2F5cyBkbyBBQ0NFUFQg
KHdoaWNoIGNvbnRhaW5zIHRoZQ0KPiA+IGFjY2VwdGluZyBsZXZlbCkgYmVmb3JlIGFjY2Vzc2lu
ZyB0aGUgbWVtb3J5Lg0K

