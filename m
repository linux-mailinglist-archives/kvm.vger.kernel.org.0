Return-Path: <kvm+bounces-67470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F80DD061BA
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 21:32:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 835613015585
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 20:31:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB798330662;
	Thu,  8 Jan 2026 20:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pq9myjDC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8E233064D;
	Thu,  8 Jan 2026 20:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767904249; cv=fail; b=QDK/Mfk0RqfpaO56hGV8WhSqxJNDtm26C5nGHrvuZ/jR92oMlLPy4INjNaJigPHlsaf0zhod8/Bp7ggv3nEcSepoLUrEBMTzqI4bc7rZYPC9FW5+J0IrPWbr8hxVjhK+gnoYGoOzctlwmaPStHbzYhxxfBrwhBPftRt4Ldi+VvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767904249; c=relaxed/simple;
	bh=hs4vfvQvOHP/6kKqHglDIEIVHXRyJd1VU5CDD/IZcDU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MH2xDy+u/T/rgy0UefaWBQag7K7wXG1F80RM6EnA203LtgtBXRIsQRBqF8AyIdQzk69b/1Oe78uMGK7pbzGoZLRErkl2jmtEgWc2CPf7XhJU3VF3GfTPJ+yySrQqaYEAKb6BvHDZH2Z1WlJ4zds321UNa2lVzn+4xZ3QgSvVhHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pq9myjDC; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767904249; x=1799440249;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hs4vfvQvOHP/6kKqHglDIEIVHXRyJd1VU5CDD/IZcDU=;
  b=Pq9myjDC3VqfgBupXzN2UZUp+bR3y+StTvi9Mb6BKxqHqJ5OgZsMqBi1
   nceskq7UOlGIPnyDHK62JajfWaGXWEqAPIEeUbr57LukNrwdxUnVUVa76
   7dGzazYp0dmfQ9TYclALI3TD7P8bbQFVv+DwYzIAReiC/ojBO+seOPcsx
   W9aXulIyUCqsjjY9r8rv0DTgzsNztyaKE4gmbsZn4NFJnVGgIWZdLHT4R
   et+VEucrBbsMkTjQMmTXaA+OdRwlRfSX68u2SsDemCmxLHxKEqsbYWmW+
   6qwn/CYLLGcDt9WFt7oSvTxgZUhPr5MuNb4sizhUiWEYJvx4GywoD7I92
   A==;
X-CSE-ConnectionGUID: dpUJanPmRKy7YQIFpjJdJQ==
X-CSE-MsgGUID: jvndwD/TTeGiRs2Kpl23+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="73138681"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="73138681"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 12:30:48 -0800
X-CSE-ConnectionGUID: YyCpIoXmTO6FqLkUU8gk6g==
X-CSE-MsgGUID: PlwXCk/QQ+KrECTZz07RIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="207433904"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 12:30:48 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 12:30:47 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 8 Jan 2026 12:30:47 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.4) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 12:30:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qiZ/bjXgYPi+Xyf68yxIPF775j7nv7CYa9IjDJg8orVELLq1g4IgD83ZNz2l4ukkgJmRBnLBefK2baaHECJRPNWUDRIILjQiIAY5j6BTERzdwazjYRp5BvorfVl/6m/jFhpeTBYj2khR6uA+UJ9ADE0wz6B2d2+AS7SdPd1BEEd0Lf3GH0mWl2VhTZwo6grJJVz/5g6sYL225c9MHzj+9c8bVn2LF5kdzUcg/5fpKxKuNzQFRjSrWD4agyeWZRyc9szx26w0W8jW9DIwnrGrXM0kYQMGz4XvTKK0lHFUNiVQwarsUf14tURsw9GznqqTPFnzFpQCXUbzEyF27MXBtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hs4vfvQvOHP/6kKqHglDIEIVHXRyJd1VU5CDD/IZcDU=;
 b=VGmW5OzcjGYP/YHQcbYqfxj4vg62A9QCss3xDfeiRVMxNH9l2TPgqM/wAOv0N6X45cpnGSeH02mPurrH7N/cN/F7x3kjQQ7oCTpYmkzvxmj76PxkKhqmwRhYu3MYpOhdWdlFfc2RptGmHfb+t2oy/QrGOeQkmVSBBMEmPxNuZyE2eKdYCfr28RwT0ASJTO+dx58sUsRQEW3DleOaTNxGTu8ais+stQBh0Pv3xPuHAFkJxeE0p+DuhIInMe2ALwZXGtmnVC/Zbk400H1rWYm+P06xgJPeq6qLnKVeXtXWipz39CqWo6CIzGjpvbO42dXFlQsyada4ddeL4bWgA9TuDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by LV3PR11MB8484.namprd11.prod.outlook.com (2603:10b6:408:1b4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 20:30:39 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%4]) with mapi id 15.20.9499.003; Thu, 8 Jan 2026
 20:30:39 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "kas@kernel.org" <kas@kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"Huang, Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
Subject: Re: [PATCH 2/2] x86/virt/tdx: Print TDX module version during init
Thread-Topic: [PATCH 2/2] x86/virt/tdx: Print TDX module version during init
Thread-Index: AQHcgDYyz4PdRgNJ+E2Gw9ZTxvuIEbVIGL+AgACDLACAABw8AIAAArkA
Date: Thu, 8 Jan 2026 20:30:39 +0000
Message-ID: <9d0c6505922590655c79d4ef7880f4bae2a39ccf.camel@intel.com>
References: <20260107-tdx_print_module_version-v1-0-822baa56762d@intel.com>
		 <20260107-tdx_print_module_version-v1-2-822baa56762d@intel.com>
		 <orjok4cskwinwuuqkyovqu7tkfygdkiqlxc2sbdvi2jicpygi4@dgg76ojxkhak>
		 <261b253ff5bcf593adbddbc34f7a5b4befaa4c21.camel@intel.com>
	 <aaeda226c7e2d0d81e5b0f767475330e6d9d8bce.camel@intel.com>
In-Reply-To: <aaeda226c7e2d0d81e5b0f767475330e6d9d8bce.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|LV3PR11MB8484:EE_
x-ms-office365-filtering-correlation-id: f8b96de4-dca0-485e-71a4-08de4ef4c9be
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SGpYc2RQRnl2R0xhYjN1RmtaWDFSa0hkM3BDKy9xeHduZDAydnFzWm1UTTFU?=
 =?utf-8?B?Z3BDTE00ZTRwQk9XOGZNcS9ESXk4d296K2VETnl6MHJJMEl3UWNhT3g1OXBS?=
 =?utf-8?B?YWp1QkNVdmlFWWdhYkdJcUw3VVM4TDlGai9ib3l4YlpiU1NhbFdDdlRCMS9M?=
 =?utf-8?B?dk1VcGcvc2t2QmRxODVzNGhDOU5ScHpwUENzT1ZiZ3pXRG55cytmT1MwK0Fa?=
 =?utf-8?B?R05JKzhwcTNzZWdMaDRYMHVlNW8vMW5tVTMraWYzeWcxNm94V29KUzlCVkt1?=
 =?utf-8?B?TzljNjVWOXErbUZmbVBKNCtOeUhabWtwK1pRbEFRQlN4UkZNNHdEUXAvWk1y?=
 =?utf-8?B?UnZtb3NjemgwMVkyaWtUcGFFNTRiNVpRcEN4ZVowalVwWjI3cnArZUFNNElS?=
 =?utf-8?B?SGN5QlRXVEdkcTBjK2NGTktRelBTd2c1cG9qWENWOXlVTlBZdERYQnBGcVR1?=
 =?utf-8?B?UnE3Y0gwc01ReTgvN2RYNC93aVlURVBzRFMrbTlvVi9mYUl0cFoxZFZ3MFcx?=
 =?utf-8?B?QXRucnIyZURTaVF0Q2JzYnluV3ZqTi9EYlpqNzdzSld5c2tFaG9FdXZkMUt1?=
 =?utf-8?B?TzFtVHY3cVJuV0N1UUN4VG5pS20vc0hiV21PK3hEMkpISFRHUGtBM0FETUIx?=
 =?utf-8?B?MVNVU0RkenhZMkFOWTYzZzRzcU0rOHV4SVI2S05tdFUvMjdVNndDMlVQNitB?=
 =?utf-8?B?TVNtY2Fra0FGL1huc0hnb1ZvdzVqbmZqb2NjaHJuR2t6T2ovTzJJODVQNndD?=
 =?utf-8?B?aGRyQ01QNGdneG16dTZNcGpxQ2FVL1VybVNDZ1RKQjVUaVR2MWxqZ0dFd013?=
 =?utf-8?B?TW11YWU4eGtRTDZXNEppVlRqZnZuVVVCQlZuemlTN3JXUnprSzBZcE9yb3Bv?=
 =?utf-8?B?SDFHdFBRYVdlY0NUVzhNdkhsMXNkWE8zMHZVenlPaHA4dGJjdFpCN29nMUp3?=
 =?utf-8?B?TmVjNjJ3dFV4TnBUUHVUSmUzZW5BbzMxZWMrZlNzT1kxUStMaVpOZ3ZxRmlB?=
 =?utf-8?B?UCtKaDJZSVMrY3lFaWp4bmhJVjJCMjdzcFVZNnFCM1VXbWFzbFNtL29Ldk83?=
 =?utf-8?B?SEsvdFpGdlZjK3NUMmQ2eEFZRE9yV0o0WGtXUG1DbkRrcS8rTXFnWEZlWkg2?=
 =?utf-8?B?NmtWWlRFeFM2WW1MclFZREdtTmtZRFJNZ2h3V3J1VDhzZytmbjhxaHpDMlMv?=
 =?utf-8?B?TDIycXdNdkVOdXFGTkN6UWhHUS9SQjZRRW1RT21EZk5VbGx4REI0WUdZQmVT?=
 =?utf-8?B?YVlManVRWFZNVGh4TmgxOTFsYmorNU5vNUFPZ1ZJb2hsek9sYzhCRVFGZUdp?=
 =?utf-8?B?Q0lSMTRrVi9WYW4rY040aVhWcEFJejkxaEF0dGt0dzBCb2dXQlpsemZLSW9S?=
 =?utf-8?B?RC9zYlJKbXFkWjJPVkJEZ09kekc1Wkxucld2eEZwTnBwWGc1ZmJQeS9LaTJw?=
 =?utf-8?B?VldHTEV2QXVTU2N5K3ZJZ2dXSE82aXFHVHlWVmlWY05PTWJLcGxSazRmWHdV?=
 =?utf-8?B?L1VUejlzMENRTVdpUDBieVhFdThCeXorMWhkTFlVZmZWMk9vS0FiWFl6Wk1o?=
 =?utf-8?B?dFJLOUtYbSt3bE5GNFlzak8yK3V2WnpEb0FPV2xyWjBxMUNReFI1QzZDL09y?=
 =?utf-8?B?bHdkZDMxdUQrT2I4TUVpNGFDOUg2cmNyQlhOU1BuL291NzB1VDFEWFpMUzVM?=
 =?utf-8?B?WUM2cHJBY25hN1ZybGx2c1JNY21PSVhIVGV0QllreFM1YmdTUEJwQXBHODZ3?=
 =?utf-8?B?Y2RYUWQ0SnpudS9ZbWh3KzVORHFvMkltRk9SVldId0dqWFZJcWlZSHJsaXpC?=
 =?utf-8?B?Y1BKWGY2NnFzVGJhSDNwc3JZYlpycy8vYjNQbHYzWU9rOSt2YUJNSE5CYWp4?=
 =?utf-8?B?bFZKcGFMVXNHZkltVnkrQk40QXNRMWswUk1lL0tEUko5R2lZWTJLNUJGcW4z?=
 =?utf-8?B?UUlhak8ydmtEK3FoZTJWbkdsYnQ3amVxYUJZemI3MEpTZHBoQzZTSFUwcEY2?=
 =?utf-8?B?bldUT01uVWpoOXlGaXJISWRmSlFYUDBWaExHdERkSlkwdE9VVlBxYkEyc2l4?=
 =?utf-8?Q?r4ZIpK?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWVJcUZ1dk1FOHdUSHpQZnhFSDZEN01RU3VGaHpKR3lkK2FXZGJQOU15Wnhy?=
 =?utf-8?B?RkMzRlFkK2d0bXFQVDNTa2o3RVl2Q2NHOWcrb01BUkFZdTJhZGtmcnFzTTYz?=
 =?utf-8?B?akx2OE4zdFVFcUd0Y3dhTjd3VkEwVWNtRVY0UVUrMGVwWFptbENzZlhGUjk3?=
 =?utf-8?B?WmZzbjdFY1B2VnlBbkM1ODdRaFNDM21WNUpOZkU1WTB1clJndUs2VGw3L1FV?=
 =?utf-8?B?Q3BWa1k5bUNrWkJUeE9aaklDY24ycHplb1dsUE4xbmFaQ1pxc25RS2k1bCtM?=
 =?utf-8?B?SytyTFA3dG1mS3puSXE3R1J2ZWhHbHNaZGRTMVlMY3JtZUpxN1ZQeGhxajJv?=
 =?utf-8?B?SGVyWkV3WG54R2p3akZyRWRXRTFjOUV0Q3BEeENqQjEyc2phbnM5QXplNy9x?=
 =?utf-8?B?Q1FaR0FOSnkrb0I2QUN6clNqbVR4bzFwUnRrM21jbWJxRWY2MHh2dHZOZXFO?=
 =?utf-8?B?SGUwTE9EbWpmbkltNWt0aU4xMFVRV2x4YTJvemovTUMzcjVaTzZyelZ3R1Jp?=
 =?utf-8?B?bVJTNVRwL01PTVV0UU83QU53aU10YWdzL3Rpa1pPRWRXRkFhWWlNcXlIWGsy?=
 =?utf-8?B?K0xwcFRhbWlpRTQxcWN3Yk10T2VaUkZET1dDS20rM1MyQXMyMDE2ek4rK2k1?=
 =?utf-8?B?ekpGRXBkS3B0bmIzWERhODNYQjBOTlRLYkVOTU91RXRRMEtVNExBKytBSi8x?=
 =?utf-8?B?dFhoNWJuRVNjVUU3MGJzVk1XdjdPNU41ekQ3R2VHSTluVXBrSjF0eEFhTjZG?=
 =?utf-8?B?c2pVY3ZUeTRlNUU3UE9aSkNqcG0zRmFHaTBVaEF2ZFpudG5nb1lJT2dXdXdJ?=
 =?utf-8?B?dUdLdDhhVmFTM2MzNE9aa09aeElTQjh2REl5cFBwRDNqaDcwcEVOMyt6aHhn?=
 =?utf-8?B?aWE3Zy9QV05MVWs3RmlvZHQ0UVpxalpFME9PSjhRUzlPUlcyZURuNHBWcFVu?=
 =?utf-8?B?OWl6ZGErYTlhRm0rWC9FV3MrM0tOUUYzL2E3SlA0ZncvT2lnazQyT0EvUURs?=
 =?utf-8?B?ZER0ekFvQXRTMU5iRWNwSHBUcmRZbVNRN0RGSFQxSnZqWHl0a2RYeDRJcWNx?=
 =?utf-8?B?TFhMYzBWQ1pieSt0V1UrMStXeUdoRHV0TnZwenhUcEh3VTBlT3VZWGxxV0dh?=
 =?utf-8?B?RFcybHNORjJXdVdFRFlaWi92MTZnazJYVjhYTkZ5MnhTdkFLeUc1dDUybGE2?=
 =?utf-8?B?eWVKdGcvM09XbFFuZWNVUThOem1ET0F6SnJGczFURXpRQXRKZSthQ0R6bHNu?=
 =?utf-8?B?MnIzaVA3VnpwNHpJZ2pyeDBxM0ZJWnoxSDZrYW5WdVMrUlRrZThpaEtyNFZ0?=
 =?utf-8?B?dEhhcFRmaXc2Qzk3VTVMaVU3dXB5ZWxRSzZJQWd6R2xORjhsMWhPVEc3T2t6?=
 =?utf-8?B?eU1Wb0ZZb3F1dXc4M0x3Rm8xSXk0c2F0WW1QMDluRDd1ZTRLdFZyMDVMaExU?=
 =?utf-8?B?aGwrSEMyQU9naFFmdy9RTHUzdUtYdXhjUS9JbXhKZGtieElGNzlwUXhwOXBo?=
 =?utf-8?B?b0Y2VVU2T3Jva3RwOU8xMjdzWmhlWkdWWENYbVM2b3hnRmlRaFF4UlJONnBx?=
 =?utf-8?B?VEcrVUwwL1Q2eWZUNDhydnBOcXdZR05HMzVEWmY1VU84bGNJNUV1Q2ZnUFVO?=
 =?utf-8?B?bTJaTGQxT3pkRjI0cEZINEVOcTRSb1lGYmhFNGJNYUVEUWVSRVM0QWFEWmd1?=
 =?utf-8?B?bGpSZFJCYTZScVVUYmQ2T1VVU0c2TXVhZWxsaXJYTDZiY1VvSDhIb0hpNTR5?=
 =?utf-8?B?VUVFa3lJRnZQYWozY1Y5NHdMWUR3d0Z5OSttQlJFZm1jZkhVWG5XZExmeEk4?=
 =?utf-8?B?d3p6OGtPaFlGLzY2SWhwV2JWYTFBeWErOGZGcTg1bVRxamhNdlJFdFN6RzFt?=
 =?utf-8?B?NWFMd3dTazJzV044aWRHTHN3YjcvZEhZdHp1Y1lUVjhQMUUvWEQ3a1dSa2pk?=
 =?utf-8?B?TTExbUoyKzJXSVJMN050UGNseVlETkpyaWIyYmd6aXFpazZ0V09MVCtST3pB?=
 =?utf-8?B?UEFPNkdCWE5mRVY3dkpZRllzRWwzNVU3K24rWTFNZ2kvVHBTSC9nMXlzL0Z5?=
 =?utf-8?B?djlRd2t3UjA1QlZaTnk4ODJCNmRENTY4TDl2UGVCYzhxaGpva2EzZkZ6b3JK?=
 =?utf-8?B?VEg5ZXkycDk3QzAweTVUUE5UcjkxdEJ2U1Y3Mmg0Q0xhYTQ0RnhuNllpL3RI?=
 =?utf-8?B?dGp1OHM0QjZEdlFZRlVHZzFhc3B2dkRCK1NPNG5ibXpoMThDRDdPdnVqc2Fr?=
 =?utf-8?B?SkV0aUxSZkxGN3I5czVya3oyTjFSa1owNi83VC95SUR1VXltNVMzMTh3UEZF?=
 =?utf-8?B?aHNkOEZ5bHhBN0Z0T1ZuZDNoYlYxSlNOcHpLZjJDbTNqR05Gdmd1ZzdCVklk?=
 =?utf-8?Q?+tmBMR/vhEBRgy5g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0AC087C54F9614EA54E36618E971B2E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8b96de4-dca0-485e-71a4-08de4ef4c9be
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 20:30:39.6601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MAaYCr1JdxQ8b/GJXGrIpzdYKTPv2v2qGa0QAOXSwAWBbkbj/JUX7ZAECnlueHHgplT9w2eynZveW5wYo3iA7vSxUmSlPRyt1F38Mb9oqSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8484
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI2LTAxLTA4IGF0IDIwOjIwICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gVGh1LCAyMDI2LTAxLTA4IGF0IDE4OjM5ICswMDAwLCBWZXJtYSwgVmlzaGFsIEwg
d3JvdGU6DQo+ID4gPiBJdCBjYW4gYmUgdXNlZnVsIHRvIGR1bXAgdmVyc2lvbiBpbmZvcm1hdGlv
biwgZXZlbiBpZiBnZXRfdGR4X3N5c19pbmZvKCkNCj4gPiA+IGZhaWxzLiBWZXJzaW9uIGluZm8g
aXMgbGlrZWx5IHRvIGJlIHZhbGlkIG9uIGZhaWx1cmUuDQo+ID4gDQo+ID4gR29vZCBwb2ludCwg
bWF5YmUgc29tZXRoaW5nIGxpa2UgdGhpcyB0byBwcmludCBpdCBhcyBzb29uIGFzIGl0IGlzDQo+
ID4gcmV0cmlldmVkPw0KPiA+IA0KPiA+IC0tLTM8LS0tDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHgu
Yw0KPiA+IGluZGV4IGZiYTAwZGRjMTFmMS4uNWNlNGViZTk5Nzc0IDEwMDY0NA0KPiA+IC0tLSBh
L2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYw0KPiA+IEBAIC0xMDg0LDExICsxMDg0LDYgQEAgc3RhdGljIGludCBpbml0X3Rk
eF9tb2R1bGUodm9pZCkNCj4gPiDCoMKgwqDCoMKgwqDCoCBpZiAocmV0KQ0KPiA+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Ow0KPiA+IMKgDQo+ID4gLcKgwqDCoMKg
wqDCoCBwcl9pbmZvKCJNb2R1bGUgdmVyc2lvbjogJXUuJXUuJTAydVxuIiwNCj4gPiAtwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0ZHhfc3lzaW5mby52ZXJzaW9uLm1ham9yX3ZlcnNpb24s
DQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGR4X3N5c2luZm8udmVyc2lvbi5t
aW5vcl92ZXJzaW9uLA0KPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRkeF9zeXNp
bmZvLnZlcnNpb24udXBkYXRlX3ZlcnNpb24pOw0KPiA+IC0NCj4gPiDCoMKgwqDCoMKgwqDCoCAv
KiBDaGVjayB3aGV0aGVyIHRoZSBrZXJuZWwgY2FuIHN1cHBvcnQgdGhpcyBtb2R1bGUgKi8NCj4g
PiDCoMKgwqDCoMKgwqDCoCByZXQgPSBjaGVja19mZWF0dXJlcygmdGR4X3N5c2luZm8pOw0KPiA+
IMKgwqDCoMKgwqDCoMKgIGlmIChyZXQpDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQv
dm14L3RkeC90ZHhfZ2xvYmFsX21ldGFkYXRhLmMNCj4gPiBiL2FyY2gveDg2L3ZpcnQvdm14L3Rk
eC90ZHhfZ2xvYmFsX21ldGFkYXRhLmMNCj4gPiBpbmRleCAwNDU0MTI0ODAzZjMuLjRjOTkxN2E5
YzJjMyAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4X2dsb2JhbF9t
ZXRhZGF0YS5jDQo+ID4gKysrIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeF9nbG9iYWxfbWV0
YWRhdGEuYw0KPiA+IEBAIC0xMDUsNiArMTA1LDEyIEBAIHN0YXRpYyBpbnQgZ2V0X3RkeF9zeXNf
aW5mbyhzdHJ1Y3QgdGR4X3N5c19pbmZvICpzeXNpbmZvKQ0KPiA+IMKgwqDCoMKgwqDCoMKgIGlu
dCByZXQgPSAwOw0KPiA+IMKgDQo+ID4gwqDCoMKgwqDCoMKgwqAgcmV0ID0gcmV0ID86IGdldF90
ZHhfc3lzX2luZm9fdmVyc2lvbigmc3lzaW5mby0+dmVyc2lvbik7DQo+ID4gKw0KPiA+ICvCoMKg
wqDCoMKgwqAgcHJfaW5mbygiTW9kdWxlIHZlcnNpb246ICV1LiV1LiUwMnVcbiIsDQo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3lzaW5mby0+dmVyc2lvbi5tYWpvcl92ZXJzaW9u
LA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN5c2luZm8tPnZlcnNpb24ubWlu
b3JfdmVyc2lvbiwNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzeXNpbmZvLT52
ZXJzaW9uLnVwZGF0ZV92ZXJzaW9uKTsNCj4gPiArDQo+ID4gwqDCoMKgwqDCoMKgwqAgcmV0ID0g
cmV0ID86IGdldF90ZHhfc3lzX2luZm9fZmVhdHVyZXMoJnN5c2luZm8tPmZlYXR1cmVzKTsNCj4g
PiDCoMKgwqDCoMKgwqDCoCByZXQgPSByZXQgPzogZ2V0X3RkeF9zeXNfaW5mb190ZG1yKCZzeXNp
bmZvLT50ZG1yKTsNCj4gPiDCoMKgwqDCoMKgwqDCoCByZXQgPSByZXQgPzogZ2V0X3RkeF9zeXNf
aW5mb190ZF9jdHJsKCZzeXNpbmZvLT50ZF9jdHJsKTsNCj4gDQo+IEl0J3MgYXdrd2FyZCBiZWNh
dXNlIGl0IGRvZXNuJ3QgY2hlY2sgaWYgZ2V0X3RkeF9zeXNfaW5mb192ZXJzaW9uKCkgZmFpbHMs
IGV2ZW4NCj4gdGhlIHRob3VnaCB0aGUgcmVzdCBvZiB0aGUgY29kZSBoYW5kbGVzIHRoaXMgY2Fz
ZS4gSSdkIGp1c3QgbGVhdmUgaXQuIExldCdzIGtlZXANCj4gdGhpcyBhcyBzaW1wbGUgYXMgcG9z
c2libGUsIGJlY2F1c2UgYW55dGhpbmcgaGVyZSB3aWxsIGJlIGEgaHVnZSB1cGdyYWRlLg0KDQoN
CkkgY29uc2lkZXJlZCBnYXRpbmcgaXQgb24gJ3JldCcsIGJ1dCBtYWtpbmcgaXQgdW5jb25kaXRp
b25hbCBhbHNvDQpwcm92aWRlcyB1cyBhbiBpbmRpcmVjdCBoaW50IGFzIHRvIHdoaWNoIGZpZWxk
IGZhaWxlZCB0byByZXRyaWV2ZS4NCg0KRG8geW91IG1lYW4gbGVhdmUgaXQgYXMgaW4gc3RpY2sg
dG8gcHJpbnRpbmcgb25seSBhZnRlcg0KZ2V0X3RkeF9zeXNfaW5mbygpPw0K

