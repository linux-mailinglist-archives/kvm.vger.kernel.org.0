Return-Path: <kvm+bounces-26156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C1897242F
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 23:06:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65E2A1C21691
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 21:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D0718B488;
	Mon,  9 Sep 2024 21:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nuccHPB9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E71189BB6;
	Mon,  9 Sep 2024 21:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725915997; cv=fail; b=qZ93s4NFRNPwRThvGWY104iaxTLmmJ2NONAgQSGxsF+CIflMeHuWL4v7MyyedxnfQsIgkrLrEHhDBwsk5VTzoQLjZM7ii+kY3yF/kpaDQSMLconPip7TnHR934/g1EMYtJIajopPlTCNopLh+vV4fmd67+236TIGcQYemdv49qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725915997; c=relaxed/simple;
	bh=Z5K5V9eUfSQ9qiXHAJmWWMggZWSSkok/aFlBr7Ixz5E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UHjZQFnZB0b2A9GGrKT9B0lDocbuF2h6uZE5gi9qtCGztpLmtrCdz3CiqcNOgqrqvPhaQZoVPqx3vUO8TyaQOuQ4h4Hof7afzh32oIP25qdSqcJCToOJ8h09CjXb3kCMT1m6gbyVNexNH7RSvi2rwAbnKo/Hv+Mapbz9nE0QOrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nuccHPB9; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725915996; x=1757451996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Z5K5V9eUfSQ9qiXHAJmWWMggZWSSkok/aFlBr7Ixz5E=;
  b=nuccHPB98osvrOb0YUweMkZLbzXyDCY0CJnv2XKTZ6v5QQhZhsuw/qxy
   SFaK2c+2s7CL3X0qfh0NAomA/7rChA4RR6+AXS0Z77p78UX/zE2ZvFhnz
   +kVjdXTiISVi27jBLezjjySGL8/FxW/LPQb93Dst6vLK1VNXQ3g+hBztd
   U3gQvHkPPQTjWwJjAJ6Kr57d3c/M5xK/SCG5HhkbI33bnse61OhwK9hBh
   0oKgumbL65qhUtuNkqI+2sX9JmURIZtdxaSw2u2bVD5Ys2ceV9We23MDc
   oLF/8IdjWd6nSqcL3AxNKwCbpT4ryplsv3WKxXWwFkxsX5Uem+mZJyTke
   g==;
X-CSE-ConnectionGUID: x0B49+GXSEu1laaiy9QKDw==
X-CSE-MsgGUID: zol1eTxTRTafd9C9TWfGcg==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="28521958"
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="28521958"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 14:06:35 -0700
X-CSE-ConnectionGUID: OWRnzxarSB+j42mDYwvABg==
X-CSE-MsgGUID: sLS/CL1RQ5q8m5c9GLif2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="97603744"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 14:06:35 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 14:06:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 14:06:34 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 14:06:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iaybgVJ8qc92Ylr5AJsFYFIbOd2Fr0tJnGfwU1rxYhqW0g5HYEr5a+kfN4SrJTVb8Vvj6DY16Auz0Qn5uCz+8JbYbTd/SjDa151MtXPeWXFAl8aDX4uss1/y3u2PCtWCiuRL2JwzAHF+1v+mmGFB6oUtY1DDni1QVXOp9NGTaxZsymOw1KYWe6t1QzLFssyuE30s0DRg83Du2gF3Fu1WO9AXHmttl38iuZTfGdxtHelLcoL+hmwMEWzQ4x5k4x4ANsob8j/uNauaXOrYJudGujR/hzhUXq4HLQwGQ6YCZ3c1+lDYsbiDUjuDB1euCn3mOT5u+3Y8GyMu1lBE/UC8ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z5K5V9eUfSQ9qiXHAJmWWMggZWSSkok/aFlBr7Ixz5E=;
 b=xumgMgxt/g3NtkGVU57w8lk39YPtH3Z3zanVW8JVcdP1zTPYS5pPQd3dZAtqdTWeAEdhxNR+zfAiKo9nMXi60eB6Tlw3/0YZVsx797rvkZwZuUoM/pmorqSeMjYjjzHYKkUvmGXJBo8gHHKjT5K0UyQ/5y4oRmRPnzV33P1K0nN74f4nIcNyRbTcoAkPDtM4TsRoPImfsyvszKTNTVCjJdbS0gfB+kHOSrPu1V2XZWcbRxa+hJ2sInFYpIk8PBx1LKRL3qT0myBHEYBmoMl5meJQIIjtFIGNleOBA6sX6gBAB/tO6q7nZp5tu9DOibHNj4nmcYxZ6J1USKPqmAFfXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB7862.namprd11.prod.outlook.com (2603:10b6:208:3dc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Mon, 9 Sep
 2024 21:06:32 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Mon, 9 Sep 2024
 21:06:32 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/21] KVM: x86/mmu: Implement memslot deletion for TDX
Thread-Topic: [PATCH 01/21] KVM: x86/mmu: Implement memslot deletion for TDX
Thread-Index: AQHa/neucVRb6Pn3ak6v16vDJhYLb7JPf/2AgAB7WoA=
Date: Mon, 9 Sep 2024 21:06:32 +0000
Message-ID: <b78f469988ccf14626fc7a5934c9ae96a743af9f.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-2-rick.p.edgecombe@intel.com>
	 <d4e07759-c9fc-49db-8b99-0b5798644fcc@redhat.com>
In-Reply-To: <d4e07759-c9fc-49db-8b99-0b5798644fcc@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB7862:EE_
x-ms-office365-filtering-correlation-id: 205fb3af-eb65-4b8e-970e-08dcd11347e7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZXEzc0N3RzdLOUJMNEZrTDJrbTlWUlhTZ0cxVmM0dldyVm05RUpteTc5TmpV?=
 =?utf-8?B?NVpteFJUWk4vUk83Mkd5NS9heC94R1lkb2tBQ3RKNmdLU3YyS1Y1WmVGT1Qz?=
 =?utf-8?B?ZDBjeVJpamQzclFCR2d2TnZJTW1OUDJyTXRZZGpCWTgvb2FnUjBSSGtNTEZa?=
 =?utf-8?B?VXVWbVdwdEpySktDUUFQN1NaRWNObVN5bkNRQTlMSjc2R3N4RXFObmwwbnZL?=
 =?utf-8?B?S3BxSExHeFpzaEJDSVJ6aUQ1dkJiTDkzdytLaVA2Q3V2eC9NWTNmZE82SWlF?=
 =?utf-8?B?MGFXd0p3MTIrcTdwV1lDNk1EMXZUbWRQZ0NKS0Y0ajJHa3BPL3crSCtzM1RF?=
 =?utf-8?B?NUVUNmRmSHQ5WldBNURwL2pZalpXeUI2OFRpR0Vnd2p2SlFQODZVNDY1YjhH?=
 =?utf-8?B?QzdqMGhoeS9TU005dy92M3VadDRXdjZwK1hTeStvVERsVkpEMUx5MmJOYnFa?=
 =?utf-8?B?RDVCRTdRN0FjQjJBNDc1cWdyeHdJN3FsRG1LRm1XSEpvUmJubktrTGZLcjJ6?=
 =?utf-8?B?ZDczcHRZeEFNQ1dmN2p1ZUQ0bUt6dFk4aHhKWmdLcWk0YkphVDBoaERaYS8x?=
 =?utf-8?B?ZGtuNHgvOUc1VER2ZE1uQmRkbHlobHpTam9icmU2YjVwYkRlTnJ2RzhTakND?=
 =?utf-8?B?YjVibWF2WGtjWUZuVHJPN3Q5RzgrVTJjS3JaVGNHK250dkl4RDBRRmVjelJk?=
 =?utf-8?B?TVh4dmdQYzZFSGdrc3UzUDVZaG9OMVBUS3k2aENSSU9UOS9OM0RaejlnMEIr?=
 =?utf-8?B?cmgxazVhTk5Ldm9BWEtXdDNoN1R4bXdIY1E5M2RlUy9PamRHc0hwYUMvSmE0?=
 =?utf-8?B?MHZIZDl2RlU1MUJaaXVBNFNCdEJBRUQvRkZLWFUwbVN4QXd5amxGQ3VVajFp?=
 =?utf-8?B?cWExbVJFRElNQm93cTN3Um9DZUpUaFdJRGRuT3VrSlFNcnk2T0NQRGIycVVJ?=
 =?utf-8?B?bkpvTC9YWEFvNWpZVDBSUWhoYWp4M3EwU3JvYjVIYzAycVp2TE5LbzB4Q1c5?=
 =?utf-8?B?S0JGbWtIaFNDZW1meWQ3bkZTQ0pLNlR3ZG9FRnpzcWtldWJLWTV4T1Y0cDlN?=
 =?utf-8?B?RmtSMFlMbEl4L0p6WlhHOWhOellWRWVqNGxXNUdaVUh6OXorNVVXNzE2K2Jo?=
 =?utf-8?B?dEZ3WXdDUUwzdVVyY0tHZS9LcUNidk1qWVY5cGFtL1VsYXNvSGM5dThiZE1G?=
 =?utf-8?B?N2RYbTRFQlZQSUZEb2RIQjd5cThnc09DWndGZmcvVjZqNXpJeXFXRDQ3OUFt?=
 =?utf-8?B?V2NtL1dCYkZQQlUrU1VIbzBRemd4bzA3SDA1NEorci8weXJwdzNOdGpwS0ds?=
 =?utf-8?B?Kzg5NGNhZEFxWEFERWVYRWRSdjhqSFEzanhTbjVJc2ZOdWZSQ0RVeG9teHNV?=
 =?utf-8?B?bjdSSDhOa1BQRmM4bVRTYVJuWHZVaTFWbkQ3STdRbWxVaEl6eGdvOUdjMURj?=
 =?utf-8?B?UHV6RDhLeXBoRExQWS9aa1hYVms4UysrVGg0Z3V5QlFta041Tml6WTgxYTBJ?=
 =?utf-8?B?WXhuRkw1SnE3b3RScUlwdnB6QVhhVUNUYjZnT1ZSdEpobitRY1F0L1c3RDZZ?=
 =?utf-8?B?SjUvNXdkSDNWenFzaUNZZm5VMEUzeU1WYy9UT0t5RDBNbmUxNlBxVkpBVXpS?=
 =?utf-8?B?a25LSUc1Tm1ncDhOWC9ocHFEOEU1c1RUZm45VGZ0MVlxbkpwTFkrVStyV29P?=
 =?utf-8?B?ZmFhUGxXc3BOYXBwUitxN0o4dyt4dGRMbjM4Q25Fb3JKRTc1OHFST24vUm5B?=
 =?utf-8?B?djdML2k3dkpkZlVWbE56S1A2REp6V05QL2JQSlJnQW41cUt5RzRlT2hRcjlx?=
 =?utf-8?B?YlltdVcvRjNVMmdTT3ZWWDN0NlBuRW9XV1dvVlFONWxXZi92VGpHakF2a0Fl?=
 =?utf-8?B?alA5WStFaEFDQ3JtZVc5SnlISDQxMFZzQUJxeDFWZHpCYXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1ZxWnB2YTFLbVc3YUlSZS9wampGbEN2aDZBeWg1RE14WVV1OUpUNWxidm16?=
 =?utf-8?B?WEVSbjN3Y2JabGVJcnpBS0s3cHdaZWZwWldPQk83YVd0UEE5SFRRV2RUQ0o1?=
 =?utf-8?B?TlhxaUlSb3cwdjBVUnlWUFVXVmFvdVNvSW5ORzhyaG5uQmRHV295SEgvWlR4?=
 =?utf-8?B?Z2p5Y1RuM0RxM3BnN2w0enFSV2JleldNVVU4SFVSZG4xNHA5K2tsaVRJV3JU?=
 =?utf-8?B?V2RGenNwZzhFZDFscWgrYzdEZEVYNlZkL1Z6VnhabXhmcjR1c2hMWGt2Wktr?=
 =?utf-8?B?bkVjUGp0SjZCc0ovRWdtVUx4L3Y2TjVXeDlFYXN4OFVtMVAwUWJDQjZBSnlT?=
 =?utf-8?B?QU1uVGdUbjhLY2pDTkE5MmQ1V08rMXRoTWtzRGlsRTRnZlVpVzI0MHNUaExT?=
 =?utf-8?B?c2xFc0lBVEFBVTA3NWk4bzh6YS9oL2t2TjhXbHdvdldnWGIxQ1hGTjROVjNC?=
 =?utf-8?B?bUJpMzNTMmhGRzZaNzUvS1JQcHJTcEhBNkdvK2F3MHpoekxtWTFYcTVLU0RO?=
 =?utf-8?B?Q3pWVnUxTDY1YkovUmx2djY0SzB6SXN6UEFnZUlmTk9IZzNtTUFaaDI2VUlJ?=
 =?utf-8?B?SXZ5SmIyZXJZMm9sMDlDVjF2V08zNFBpM1M0ZDNJc0xYRjZDTnVsNngrK0Jo?=
 =?utf-8?B?TmtmTm5EcHBab1IzRkNySGY0THhuSXJ4aVhCYlBEckQxbElDNFphbEJrcHMw?=
 =?utf-8?B?a29ERnhZRmpZMEltRlhhS1M0aTd1QXFIS2ZBZnBydXdDWmdLSjI4RmhERlo5?=
 =?utf-8?B?aDFxa3hVbHIzdlJzbGJqVmpnU25zUitZWVBmN3J2OGRubTQ2OWRtZGFkaWdL?=
 =?utf-8?B?d0lRN0M2cXFtSTEwYWd1YTRIV0lCSDRQd1R5ZjJNR3FKMUR4TTUxaktvTkpX?=
 =?utf-8?B?TzBlaFJ6S2hVZkxaYysraFBiY1ZxVk9vSFc3UFBnekJUMHFjaUhFR2pWaEpo?=
 =?utf-8?B?ZVJXZmNQclhWN29qODlMQ1dGMWIxekRjS0l4OHJNSmVEUHNKZVVOWjFoN3ZC?=
 =?utf-8?B?RXRIK1NOMDdNSTJ6cld6aENpYzFrNHNCRDM2WWl3WjJFQ3Rnc1I4eXl0N0FZ?=
 =?utf-8?B?T3VTWmdtK0krbXhGYUFSdmtlUmRkeFN5MThvK3JlNTVWS0pzS1RFVWdzekNy?=
 =?utf-8?B?N2V1cTB1eVB5L2daSGovdkZoZUNKTmVMY1JVYzJwaDczNnZVZmg1Vi9WeHp6?=
 =?utf-8?B?ODVqSjIxU2E5QWZNeTV2N0IrYTk2d01mWGFXc1h5UGpTdkg5enhqa2ZMSWx5?=
 =?utf-8?B?SUczR2dOcUEwYlZjY3ZnTUVwbFVWbVVWRjBKcE5ncHI1dEdkNlZ0NlVSTkVU?=
 =?utf-8?B?a1hnVFhFZmREajJZR1g2MVlVOTFFMUJGNlRLUXk2d1lJNHRwWXUxZVVBaVFp?=
 =?utf-8?B?YjRSOU5pRy96b0h0WlRSMTZpZDRTeUcwUGVXZ04rd1NFdk4wbEJyK3RrWWV4?=
 =?utf-8?B?YS9TNWhrOXp6dE5xYXNKQkZsVXRqOGxISVdRQ0V0U3FvalhwZCt6dDF0QTF2?=
 =?utf-8?B?NzRibVE0b0VDdmFzbVd0K3dGY2wza3NvenJCWjlXcFZoR2UyNnRtWHdRL3U4?=
 =?utf-8?B?Z01zNGxCNC9VSHVOZndDSTFHSk1vTjMva1ZiaU90WTdoeGw2K2k0SDl3elM2?=
 =?utf-8?B?dnFzY3NIYVcyT0ZQRUVIeDB1cUhvU2sydzNkOU1wZTFBazdCS09QaGpSTUhT?=
 =?utf-8?B?WUFaaHA2RTVvWERGd0tROGw4RzZ4MHdIdmpPQ0VaYzYvUCs3STA5R215eDc0?=
 =?utf-8?B?dzVFNkpPZkhHa2tneFJVNHlTTlg2aDc3YTNFcnhwTVoxaTNod241TXNUZkd5?=
 =?utf-8?B?b2R0d0EvTVFiSDFmSnk3N0dEYUxidjBZOUtQVitXRXltZUY0aHBDaEJyYmtZ?=
 =?utf-8?B?U2J0c2Y4aFJYblZXQWYwYjZ5VE5Qc3lUNUdpUDJxckQzUmtnbTdWcGZpcnZ0?=
 =?utf-8?B?L2RvQSthdStMYXRLa0xEOFNsZWFtV0V6Ynovbldac0ZWVlExaWVDQzNCTWhv?=
 =?utf-8?B?Q0NVaVlNWGdNZHBJUWFqcVRGS0luSEEwc1J1Z0hGb0x5aWxWVVJZV2oyMjEr?=
 =?utf-8?B?aEZ0ajUwWjRUaDJTUXhhTVR4THljeWRaR1dKTE54WklkOUUrQWNVTjFoWU9C?=
 =?utf-8?B?WEpQVUtyQytOZTFMR1krcVo0RElHZXQxc2xXcHorTTlNUUdmVlBzV2gweFMw?=
 =?utf-8?B?dEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A8F7D31BC7B534C875420417969A9FA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 205fb3af-eb65-4b8e-970e-08dcd11347e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 21:06:32.0523
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NS6OWzm6ML35m4H08VGLdxkTpfY7KU0jDMYiNfs2jBZyPlXoKF3olmBa0IQhWT7mrZtyIlM3/eFWEPjENInK52bVXi3VJob1oPjvSnucvxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7862
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA5LTA5IGF0IDE1OjQ0ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiANCj4gU3RhbGUgY29tbWl0IG1lc3NhZ2UsIEkgZ3Vlc3MuDQoNCk9vZiwgeWVzLiBXZSBjYW4g
bG9zZSB0aGUgS1ZNX1g4Nl9RVUlSS19TTE9UX1pBUF9BTEwgZGlzY3Vzc2lvbi4NCg==

