Return-Path: <kvm+bounces-68415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B33AD389E1
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 00:26:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 12893304434E
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 23:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E92E31A81F;
	Fri, 16 Jan 2026 23:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oB0MqNSM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C5A2DCF7B;
	Fri, 16 Jan 2026 23:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768605957; cv=fail; b=hGOYxFInJFNpgMRMm9phNnFlEhrqZUOzSlRF7X7dtqkLLrvknD3gs0tzyX0f+C+KRdRyMwKeR2lwnwVvCPpn4AQIICTPEdFnMQsc8Cc2FcGUxbrsHxZgbZfHMUfhdI2Ov55WmiHKctqjKfp8Pi/9vTCVvELSTp88Z+FAxJ9IQI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768605957; c=relaxed/simple;
	bh=OwpNUyPvPHcBN+opENN4IW12QO39pqu9HTDG6zg/H78=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q9gg4P0kVskh+BE+T+BnLZe7abswEVIQBHlmkSGl3wUsa9fHdDxcm9bZDSLCvhPtOOYHq7j2dpiGe48Y58YSd+evLcvTlsk3cm2oEib9ypZMegrbgiY1Fkbi36blw4CGzhsApFH0S77LKJDYbUekLQgKOf3JvPgD7wLmLkG+F+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oB0MqNSM; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768605955; x=1800141955;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OwpNUyPvPHcBN+opENN4IW12QO39pqu9HTDG6zg/H78=;
  b=oB0MqNSM2dM7RuJSk/qCLyzio8Nkoyz9HClpvXEuOy+DSF3jngwHguZ1
   9NS6jZkKdlDkneDPYx1LCSNUWtRcK7pL7yVxQh5BN+hC/m0LoKiHfu66S
   0SuVHqB8gIPDoS9iYJSdL6OBQBcmmQV5Rg0vidMYwMeUSd3U1eGEoJEUY
   elA6zXAy8BJqEK7sczOyU3qyuQtoYPWzS+8h4CmtRNoD5hKSM5MIk+0+K
   ynEIDQscDTML6imYgtwSgoWcGeGHJRJ/wg3Ey1uP4KwtOoXN0j3M22q2L
   MJMzEwaNfXQGfB2MK/BCcEOxLfpacPDq7zC+f4ZR3G+5n6RAp0seWA1Ld
   A==;
X-CSE-ConnectionGUID: tWMoefprQAGvR7b0Z7dEaA==
X-CSE-MsgGUID: VB9zsLIjTIiUoipXI/BY3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="69837381"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="69837381"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 15:25:54 -0800
X-CSE-ConnectionGUID: vn2m6zVHQvW7Ng0U9XoxtA==
X-CSE-MsgGUID: z2LfDjxdTy2DweFkf4SlLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="205418815"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 15:25:55 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 15:25:53 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 15:25:53 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.3) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 15:25:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aOekBWEuKOTFPpY2Hg6sijgMjASwhWMjOYimJpyRytY7GsaxCmJl6NgtItuw/EPdkYnuOOagh5+vae+atxhBbBM1hq/echZUZWgXawqISkSk6q4hnsI2HN2/kTq0Lb3guHqz3CWjkB4wkbAh+CRiMFsLT5s+vR0j9UiL/xHJ140NfRrJH7RWrKdFfYaU77XrtY9C79C3rYdUP9LXcoZXUSiqA54LDRkqOnUl6Qp8w2Q2XyELCWer0rKhXqyohyBpipHNVM7Rnvq85t1XzKqUg1X0ItoHfeWhJnaagFkaCnIb+9h2p1JLSsOuk0GeCC2R8DSxy9+icBAllEvwGu394g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwpNUyPvPHcBN+opENN4IW12QO39pqu9HTDG6zg/H78=;
 b=JXkv3RUn9VcG6rlRYW01H1AtDzMP0WLs+6wOgAD+RfnUv4wrjz790gTk+tNmgKb1x8V6BKUdYrSWUeOyHdYtDweWIjBYZwHXX76AcpZm1/Te1Frm2g/8Z1GZzF6IPiIB0TtuhQqcuDHdJm0KnPtNdv4s8Fx+S4z9pZ9BDK7x9UPnx1QNDOLL0JMbAS0oALEHyMRVtMjHT0Ase5U+0kNM0ty+v7aPhXqoq6xHu809OnjTdwU6W50K1dN/IUQbMXTurhRNL4cESm9qvIyS6BCsL7njzb/x1Ar9X14RxZ2iwFxthVT6yp3f5hnnfuHkiKXCKW2I3ByZxwlOucgD6hfsyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB7670.namprd11.prod.outlook.com (2603:10b6:a03:4c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 23:25:44 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 23:25:44 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcWoEIh3ODz6GbaUW93Yfuwe0KJ7VVx4WAgAACVQA=
Date: Fri, 16 Jan 2026 23:25:44 +0000
Message-ID: <1840e1dba9e25c9d913926b28f6d7569c74f9d92.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
	 <aWrHAeMcjDpVnTBp@google.com>
In-Reply-To: <aWrHAeMcjDpVnTBp@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB7670:EE_
x-ms-office365-filtering-correlation-id: 9795d13a-2ac2-49b1-0e2c-08de5556927a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aDVCazhXVGkySm9sc3VucksyejRiSThBeTVYQjRSWmlaV05SRWI1N3hjMnVk?=
 =?utf-8?B?NWJFQWVDVUNzK1hNaytxNGJicmowUm5PSVozd3JZQjlaL1NJOW9IT0tzSW9n?=
 =?utf-8?B?Q0RTNUVPNUg2Znc5NmZuQ2YrREZzUS9VTXlDOWVMbEhJUEgrc0tNK1EvV2Fv?=
 =?utf-8?B?L2lHWWZ6ZEZsWDdXdHU0ZmtoSG1udnlXQm1LaW1uSVA3YnJDNUEwQ2lWbDll?=
 =?utf-8?B?N1R5SUhKY2ppTytGYjA1VEYzQzBTOWh4TCtwRzdCSjI5V1o2c05jMFpaTUFt?=
 =?utf-8?B?SjBVOXVhS0dpYm1zQkVMVEJpV1djN1MvamhtZ0tFdEFlNVFPZU1POTlVaS8y?=
 =?utf-8?B?UktBMExBV1UwNjhudmVSUjdxWnpSSFloa05UU2dONkdxbjFNTCsycXpQZncx?=
 =?utf-8?B?ZlVwODN1d2JrUjBTTDJsOTgrTThZME5vRm1ucXJVenVEZnFmQ2FVcE95TUNF?=
 =?utf-8?B?K1krbnlkeUdJVUZtUDNDV1g0bGIrWGt4aGJzYkVaSjJuaWNWb2ZIc3h0bFU2?=
 =?utf-8?B?WlN0RGZOQitYOFRUTisrOG05V1BULzJTbkZEdlBDYlEvdXlEWVVtdTdneUE1?=
 =?utf-8?B?RkdJdjZtcjBrNUlJdjYxQUV5Q0NCS2VXSDVNT0xGT3k5VXB3c0tZVTI3SVpk?=
 =?utf-8?B?TEpmYVlmU0VUeVpWbkZXZXFOcTR2blo3R0xYb1l3RDk1VlBHeHY3dG01bTFl?=
 =?utf-8?B?Zm5jL0RFZ3JnR3lGZjVIZ1U1cDVPM1RNL3VFd2NxWGpHTHR6NXF0d05TKzFX?=
 =?utf-8?B?OUw4TW9lb0ZtUXpWSkowdXM3T2FuTWlkc0djSUxHRmZpMEFSSjdnMXZyeFQw?=
 =?utf-8?B?TWhMS3pIWkswZzFqVmRaMHY5OGVrQW9nVGovek5kSDlPSlV2b2RHbG9jazFt?=
 =?utf-8?B?QTJFZlV6dm5yMjVmY0FsbUVtSENxRGxqTGJGbElVUVJuMXZZWk9FUzBIVXFl?=
 =?utf-8?B?cEF5NXA3dDNHd0xDSVNmd3QxSUY1K3hkTDM4TE4wRGo4VDQ0bUh0bGlqcDVm?=
 =?utf-8?B?N2ZCT244VFpmS1ZsbmRqR0I0bzVNYmxJZDZGTmZFRkRhYXhyam14dnpIVjFJ?=
 =?utf-8?B?aUR4dHFWcDVTTWs1ZW1EZDduQjRRc2M3VUg2OWNYUVp4dUZXeWFtVTYxbUFi?=
 =?utf-8?B?eU5sY1daWTZMUjFIQ0pmaTQ4RDFWVGUzSjQraXZFT1hXdCtQbmJpNFVTNzRv?=
 =?utf-8?B?QXc3eUt5YkdmNWZLOFVuZVFtNDNHN2xPOFQ1ZVdkQ0FIay9lRVpFeDlXM2Q5?=
 =?utf-8?B?MUt1VHlrbWtJZFJGZ2NwKzU3dVp3MmpUQ2pJeFJEeWNZR0dzRXFtMVlESngv?=
 =?utf-8?B?MGtXbVRiWi9sOGs0ckNldFBML2xybWdjWjl6S09mc3QzMEUxMWpXRFMvWkdp?=
 =?utf-8?B?MkhOU3VPMU5oZWtIN2NxT1k0d01qWjNGcHdsa2hnTHNWZWxJZGk4NnAwc1Ur?=
 =?utf-8?B?Rk54ZmRROXN2OHFkWkdUQjJnTW9Ka1FBNW5JdWJkdVNWSmdVenZVYk51ZFFn?=
 =?utf-8?B?QnJKcXFGaXVRcDdDNUlOYnZFNVFiU2JabHhuQVBENzllYUtVMDBQRThTSkRB?=
 =?utf-8?B?SDQ5ZFBadFEzdEdKaUoxaUZTRkVOQ3lHNjFlcE1wVllUWXJDRldKSEhvbDJ3?=
 =?utf-8?B?YVZmeWo2MzhzQ0Q3djhDUXNqM2k3RzJqcjRHamdONkFwcTlyNGNqUW9jVFhi?=
 =?utf-8?B?UDc1aFZxeENIb1F0cExsQjFkQVVGQlJEQWhndTExb0V4YkxFZ2JDMnhmSVcr?=
 =?utf-8?B?UUwzc29WRnhIa2dtVEpCL1BObVcvRXM1amZzcUM2WUI2WXFWT3lUcUlHUDc1?=
 =?utf-8?B?RHBMMitBcDhHRlBhK1NjV1lXdTNuQ3dpbllwQXpCd2tBU1FsSkJVUnFHUys3?=
 =?utf-8?B?L0diM3J4eXhSUGRvUUQrUGNEMmhvWnJxbjUrVEtHQ1ZEcm5pcEJBR282SEY3?=
 =?utf-8?B?NzBEeGRkQmZ6QjlkR01hdURpc29zNmJTUkg4em9PTEZkZ3J2M0tabklvdEtL?=
 =?utf-8?B?QWFrbU5wUEhSWHhmVHRSem9QcGtJYTBoZ0VuZUVaZTUvaFhHWXZ1WUtsWjRZ?=
 =?utf-8?B?NFJwSTVDRXlFb3lqZ3lKMnpoZUFsQXlJeGo0dDdPSCtYYlRNc25CQVA3WEFJ?=
 =?utf-8?B?ZVJtb2ZKVzRhUmljV1lDd0diUk9KVmJGKzZVMGhNK2h3KzdGMUtEeTNnaEZJ?=
 =?utf-8?Q?WaToCE3s2bOutvS3pJ02OoQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGJlbTJhRkZWeGt3dXUvZitaNG5ZTklUaWt5ZEJMeXBXa0JYZVBhckl4ZURq?=
 =?utf-8?B?Ym5rQUdXdW03akNxamRWZThTODArSENqRGRjRm56M2x2L1JRZTNFdVB3Qzdy?=
 =?utf-8?B?UVJQaXBCbFBueTZSUkQ5VTNKWjlBU2VaQ20vTXRaaFZSL2lDdDVTSWpYVVVo?=
 =?utf-8?B?SFJNNVZKZnY2WE1iYWVBQ284Z0Rsdlk0VTYzZWt4bGhPbTJOdXNITjBKWC91?=
 =?utf-8?B?TnA2aDdGME1VTkFXUnpROUw4azBRSlpVdUVxc0xBaFdZSkxsZEtyNU40THNK?=
 =?utf-8?B?UGpyZ21rOE5QeVZWRGxZQ0dtVEhHU2FmTHo5NkVjUmxDWUJpL2FvUWJHVGNT?=
 =?utf-8?B?czNUUENEc1o1aUJTeHZ0MjUxREp3bGpTNGErT2Z4VUY3U0tUWm9kVXhTTzlz?=
 =?utf-8?B?ZUxUVlc5TjJMU0xTT3ZYWnhBdG8yZS9WWjlCWDZNWWZJR0hKNGt3cGlJTTJE?=
 =?utf-8?B?ZHI4aDloL0lmMzZjT1diVjZIUnhBZ2VQRjRiV0JvY25EdlA4NWtGSEtDNkpF?=
 =?utf-8?B?TS9CeURPYXZoaVd2RXJjcy85cm0yOE9rQjZsUmFVK2cvQVVUS09jUU5BMmdh?=
 =?utf-8?B?dUZsbTRtQzJkRkx5Q21UNHRqeWRablNRL3ZXZDUyKyszK1BoQnRwa2srOVBz?=
 =?utf-8?B?aVQraUVCTml5K0VkMWRvMkYzNWhBNDZSY0liNHRsZDROeHY2a204MjBtMnhm?=
 =?utf-8?B?VXJ6SVBvY0VFUEZPZEw3OVFtZUhKaU9Ca0lCZk1nVytVOEhwNk96TmllSWtK?=
 =?utf-8?B?OTAxQThVTnFYcm9vWjdYWDJnSGRNVjJjQitiZndZWkR4THJlc1dERlkzWlpN?=
 =?utf-8?B?RnRudmtBWXlTaDQzcy9xWUVBc1NXV0tqclpCYjB3a3J6RjBUWmg0bTFFV1FR?=
 =?utf-8?B?VjhVWXNnM1NOZVpPMmJxY0hHVHIzeEg1cXQwNnlWLzhPaEUyTWtUK1hBQkYy?=
 =?utf-8?B?ZE45TjNRNVA1cGJHS3M4bWk5OEx2YVdjQ25YNmNOVEx4dE9TMXBQRnhxL3Bl?=
 =?utf-8?B?aEdTZkhVdSsxTWMwRXdCSFhPVG1GMUxxendncElxaG5UOGYwdWxTa2ZIeHE1?=
 =?utf-8?B?SUgwQnBTUm00bTZUYnZsNE5qczJudklKUGprRWlpTmJXTkRVUDZUcXhWSkhG?=
 =?utf-8?B?Tm1SQmdwampHZnVLaXJNUUMxTEhiWWJhcXRMcVNWeEtYdnJhTTFWaTUxQ2Mw?=
 =?utf-8?B?UXhMLzVrYkFiS1V4ZENQeGpMaENaT1lGcm5OR1dUZUhWV25WVlNGZ04wNC9C?=
 =?utf-8?B?eDQ0SFV1QlRrTlFHQ2tpdDIzTE5PNVBwZlNBcWdKcXVUWEY2VTFFOEF5QTZj?=
 =?utf-8?B?WnQ3VW9sYVVvdTY4QWJOVGlib0Z6T3F2ODd5WHNKblBwV3dvZVp4L3YyR3NT?=
 =?utf-8?B?WEZKK1NqaEdmWlh3bE5nZ2sxTTJnendWMUJGZ3RUeHNsN3BjNVhHaEQxRjI3?=
 =?utf-8?B?clU1MWJBRExIbFplVWNPbFl0VTk1bTZ1aEttRGRIenBndmg0NW9OR3kwd3Bj?=
 =?utf-8?B?alpoOWhVa0xNa2dRcW9nd2RVcjNhWkNaVFlvVHBHbnNYK0J5Nyt6bGpndWRx?=
 =?utf-8?B?ZTJEbXYwU2lpT1JaWjlHMGtSb1dYc1hvbnRQYW83SUxMaHJUMDEzMjRHQnJO?=
 =?utf-8?B?V2tvWlpWam92ait6QXRkbjBqYWhwdExjSUxiSzJta0FFaFF3N015eXhTMXpD?=
 =?utf-8?B?SXNNWkJ1Zy9zcVZUdHJuSldsVFJGaXg1WUhEbjFGQml2K29WUnNoVWhteDN6?=
 =?utf-8?B?cFU4c2xJU3Z4cm8xNlFIS1dmMnVXZXFrbXd2SCtYaEZwblpIemNPQTNpSng2?=
 =?utf-8?B?TjYyM29WSXY0TWdubzk1S29aMjFnY1dJeUhQOEgrajc5aW9aRndrU2xjbFNR?=
 =?utf-8?B?R21BcnRFYkdLUXNma0tsaGJzNjV3UmYxY1o3WVlzM2R0RGppVnFpUkhncVdz?=
 =?utf-8?B?cFd3Y0ZzMTVETmRNZ0xXY1hLbk5qNFl6YWlJcjJtOTRZZ0ZyNmJSVkc0cktz?=
 =?utf-8?B?Qlp1Z2owVUx6aGJvNHo0WTZmdFRHbTU0cFJXZGVXYW51MFMyYWlRZG5VUnpM?=
 =?utf-8?B?ejhvYzFwbGNBbzdySE1FbFJJL2hIOThmNzlaSU5INEU2ekxqVms2dW1mbVph?=
 =?utf-8?B?RXR2UWJqZFlJWitza3FOYVZ6ZlR3VnNjay9UNDdReEtyNVY0TkJlWGwvZDdl?=
 =?utf-8?B?ZVBuOHA0ZHQ1UnNqdk43d3pwRmdmV3lVS2Zla0ZSL0krZEwvVFNva2FudXN6?=
 =?utf-8?B?R2IvQjdRTHYvRURjZ2FNMUlmdFNYSFlLTG9kbTRwbUZFdVYzWU00cGVYekJo?=
 =?utf-8?B?T3JSbzM4aDJ3QWZvUmFpR3FuQ1JCMFpQbk5nY3Z2ZjhObUhqWkxCaHFldWg4?=
 =?utf-8?Q?mWrZM8sg+ZjAitQw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3C4CF2CA647D04ABC854BA40FE24CCB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9795d13a-2ac2-49b1-0e2c-08de5556927a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 23:25:44.5791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aIE/XgFuHR1ViWeAA72rhLE7if44Xidgccrbr3Ai3t+CjgUYLK1JqbHDAIqWkasY1ujbq2cqdmpbLu3lsvHCk7X6ZefbZ8Ah5MgGzltqDGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7670
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI2LTAxLTE2IGF0IDE1OjE3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIE5vdiAyMCwgMjAyNSwgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4g
Ky8qDQo+ID4gKyAqIFJldHVybiBhIHBhZ2UgdGhhdCBjYW4gYmUgdXNlZCBhcyBURFggcHJpdmF0
ZSBtZW1vcnkNCj4gPiArICogYW5kIG9idGFpbiBURFggcHJvdGVjdGlvbnMuDQo+IA0KPiBXcmFw
IGF0IH44MC4NCj4gDQo+IFRoaXMgY29tbWVudCBpcyBhbHNvIG1pc2xlYWRpbmcsIGFyZ3VhYmx5
IHdyb25nLsKgIEJlY2F1c2UgZnJvbSBLVk0ncyBwZXJzcGVjdGl2ZSwNCj4gdGhlc2UgQVBJcyBh
cmUgX25ldmVyXyB1c2VkIHRvIGJhY2sgVERYIHByaXZhdGUgbWVtb3J5LsKgIFRoZXkgYXJlIHVz
ZWQgb25seSBmb3INCj4gY29udHJvbCBwYWdlcywgd2hpY2ggeWVhaCwgSSBzdXBwb3NlIG1pZ2h0
IGJlIGVuY3J5cHRlZCB3aXRoIHRoZSBndWVzdCdzIHByaXZhdGUNCj4ga2V5LCBidXQgbW9zdCBy
ZWFkZXJzIHdpbGwgaW50ZXJwcmV0ICJ1c2VkIGFzIFREWCBwcml2YXRlIG1lbW9yeSIgdG8gbWVh
biB0aGF0DQo+IHRoZXNlIGFyZSBfdGhlXyBzb3VyY2Ugb2YgcGFnZXMgZm9yIGd1ZXN0IHByaXZh
dGUgbWVtb3J5Lg0KDQpNYXliZSBqdXN0IGRyb3AgInByaXZhdGUiIGFuZCBjYWxsIGl0IFREWCBt
ZW1vcnk/DQoNCj4gDQo+ID4gKyAqLw0KPiA+ICtzdHJ1Y3QgcGFnZSAqdGR4X2FsbG9jX3BhZ2Uo
dm9pZCkNCj4gDQo+IEFuZCBpbiBhIHNpbWlsYXIgdmVpbiwgZ2l2ZW4gdGVybWlub2xvZ3kgaW4g
b3RoZXIgcGxhY2VzLCBtYXliZSBjYWxsIHRoZXNlDQo+IHRkeF97YWxsb2MsZnJlZX1fY29udHJv
bF9wYWdlKCk/DQoNClRydWUsIHRoYXQgaXMgdGhlIG9ubHkgdXNlIHRvZGF5LCBidXQgYWxzbyB0
aGVyZSBpcyBub3RoaW5nIGNvbnRyb2wgcGFnZQ0Kc3BlY2lmaWMgYWJvdXQgdGhlIGZ1bmN0aW9u
cyB0aGVtc2VsdmVzLiBJJ20gb2sgY2hhbmdpbmcgaXQsIGJ1dCBJJ20gbm90IHN1cmUgaXQNCmhl
bHBzIHRoYXQgbXVjaC4NCg0KPiANCj4gPiArew0KPiA+ICsJc3RydWN0IHBhZ2UgKnBhZ2U7DQo+
ID4gKw0KPiA+ICsJcGFnZSA9IGFsbG9jX3BhZ2UoR0ZQX0tFUk5FTCk7DQo+IA0KPiBHRlBfS0VS
TkVMX0FDQ09VTlQsIGFsbCBvZiB0aGVzZSBhbGxvY2F0aW9ucyBhcmUgdGllZCB0byBhIFZNLg0K
DQpZZXMsIHRoYW5rcy4NCg0KPiANCj4gPiArCWlmICghcGFnZSkNCj4gPiArCQlyZXR1cm4gTlVM
TDsNCj4gPiArDQo+ID4gKwlpZiAodGR4X3BhbXRfZ2V0KHBhZ2UpKSB7DQo+ID4gKwkJX19mcmVl
X3BhZ2UocGFnZSk7DQo+ID4gKwkJcmV0dXJuIE5VTEw7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJ
cmV0dXJuIHBhZ2U7DQo+ID4gK30NCj4gPiArRVhQT1JUX1NZTUJPTF9HUEwodGR4X2FsbG9jX3Bh
Z2UpOw0KPiANCj4gTm90ZSwgdGhlc2UgY2FuIGFsbCBub3cgYmUgRVhQT1JUX1NZTUJPTF9GT1Jf
S1ZNLg0KDQpTdXJlLg0K

