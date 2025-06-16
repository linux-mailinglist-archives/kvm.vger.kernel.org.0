Return-Path: <kvm+bounces-49594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CDD24ADADAE
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 12:46:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 888CE188CD5A
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 10:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5277F29826D;
	Mon, 16 Jun 2025 10:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E81+jIDA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84CE13B7AE;
	Mon, 16 Jun 2025 10:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750070788; cv=fail; b=jr/iyXruZa10vzxrXaY0IsB+jLR7RVMDbCn6eodO8NkX6Sqtrwgdkji64+Hn44CUHqmmdxlZgcS2GGH7zeNEhmbJ+3o5nm6NehUTyXwlSh5GbwtKvF1C5wy8tD7JGRURI6mcgF5Kq0EgVNBqsgdveOwZVZObHr3U1GSPyyh0PdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750070788; c=relaxed/simple;
	bh=4YIlCSWcrm4SgVEeyIlz15xwwYA7eZOH4GXuFba9ArM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o6gQPfdAgy2WYWaQcyDsAAed7C/POFk/0NxjblH/Dc26kVBBYa39LdDQktRGm64XQgY9V0cH9mzhWdf8b+q/tgClgkaxBLN7mQO2zGwIMDknth9AQbeao2Sx80cDfkTFi9pJgxVbn3sF9DK6IVrGz5M+ZXQ3+/cKLN1TB7duM/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E81+jIDA; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750070785; x=1781606785;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=4YIlCSWcrm4SgVEeyIlz15xwwYA7eZOH4GXuFba9ArM=;
  b=E81+jIDAy8P8QiKvRtwJEXkbFxTWurCaLF1VIts7RjQWy2j034qyPiAP
   HPy1FhiqNGsq/a1FGOd6yJziIDJz3NS89CV14KqIVzixlu0nnX7xOAKET
   hGcY5A1k+6DOIeZ7qWgi8Zc30tsh3tSqgBIiYq7DObkJEPQGoldoavcQf
   z8ESace57UMdicp6BoLw8B34Jokr8LnLqvbA6VScr/UlVaOkjk86hq226
   MLx/AZOjRkdnnzRBPrnMY6keEvNrUQDVjc4HgwO6vrWD/nK2Ppay871qg
   hH/HjbUKSnX2RESgrrl5GCXZxV4mKN1jRQp0xn4sOaZENESzSyDXUakNy
   g==;
X-CSE-ConnectionGUID: Q0Ayhv9LRw6FVJpqnIEHRA==
X-CSE-MsgGUID: JNfOpRKDTe+CfhTDnXuWbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="52190238"
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="52190238"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 03:46:24 -0700
X-CSE-ConnectionGUID: 1WC2n4n0SWCCooxSAQUHgw==
X-CSE-MsgGUID: nMFlRS1TQ6KPPMbJ9X+IjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="148810531"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 03:46:14 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 03:46:13 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 16 Jun 2025 03:46:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.56)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 03:46:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HYyTBrZiF9EwDdUW+KwRAX3isegqzTKPLS1MZ/XyJGqseDzetp26UgSzoKGmr+t/HIBXqLkxwdS5JgR/v8jXTjN25ci/0Vpi17qh7izjcovRx12nWyqtIq69JIZUjDcW3S8ZXd3+cMVR5ILys2RxpA340h1B/CY+A4/9dK7/QkWqS2hzeuYwWKm93rkVicrgo4ag86gNbaKnvQqReG0ejqtnA+cn08iWhvCpvYMDbjWDUOERR0K3pd+PKo2krzxdcqh0kOja0dn5HTpMJSSAfE0SG2DoMe0vAgGGEiefitDAB/5ZYtCqhLds8UY8jwc8otDNQKPy03AhU6wa6M5s6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DhsVprAnSx7HGmi4QX33a+/ZgtEr91PXPkgC6W8uwsM=;
 b=tE3T0/ARBXUS5ocxlEROgKjQX3Ue2e/1RjWYO8xXsbvy/39kVRnk3lqY4hbGKh9iSRk8E5ekRzgNAfr48OIgO26HRC3mCfegP5aCzFzQSCNa/ZoN2xrLYuQerygT5F+KjVOHFK/s4VKnWzJJT51X+rECziP4QQA3a73WtbbCKi57aWKT/dXT0QfBFw4i+EMfCp04B6KsPzUNzbN4TVKEZlwSArRqYbC0fX1FzIdEQgdOm4QuxRvKhSEeSCRQNz8EInFQOThsfKcQ/zL8UjAxEUysDUmI8SFQ8rM2dSF6zo45s99fGLna7KkNMXyK6JvdxJou9sTjkdpe0XCBtA+mwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7849.namprd11.prod.outlook.com (2603:10b6:8:fd::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.28; Mon, 16 Jun 2025 10:45:56 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.027; Mon, 16 Jun 2025
 10:45:56 +0000
Date: Mon, 16 Jun 2025 18:43:26 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <vannapurve@google.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aE/1TgUvr0dcaJUg@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
 <diqzldq5j3j9.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <diqzldq5j3j9.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: KU1PR03CA0019.apcprd03.prod.outlook.com
 (2603:1096:802:18::31) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7849:EE_
X-MS-Office365-Filtering-Correlation-Id: 573a43c4-f23a-4500-bb3c-08ddacc2f907
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZEtGMmxLaWZxcjNoaGsvWU82NTFyMU0yN2UvVGJFZTF5QkFEblgveHdVc3Ba?=
 =?utf-8?B?Znpmd0lDQU5oQktFNm1Zcjc1bW9GQ0R1QkcwdWUxSDFCQ1dnMmVQMWJoWmxq?=
 =?utf-8?B?Z29memtzcEdVSXd4aVBkRGVKSzRWZ2ZnUGJBQlQ2K09HRzc3aG1XanBiYjVN?=
 =?utf-8?B?VnlkRVMvR0E2Q0hHMEtjeXBJZHZpalNjWFV2N0NOY0Z0OWF4dXJZOWJWQk5N?=
 =?utf-8?B?QTc3ZkJOdjB2M2JDb3ptcXR5ZGNQNk1NV2VlMXRpcmNuSjhrVmk5enQ1K2hz?=
 =?utf-8?B?UWpMbmRoOUg1dWpURW4xUjR4WlhPOTFETGJOeWpGdk1HZWp6RHRSR3dicjZp?=
 =?utf-8?B?aDFPenplWVdMbzRlWHJoeXRXenlRL254UVR4ZTVFWjk4NEd3a0thcVlsTmFs?=
 =?utf-8?B?VFdwUjlmeDY2dE1Ga3NIVWpJeUs0ZFhtQ251M2lzMmJ6SWVNV1pIZk5VdEFj?=
 =?utf-8?B?UHMvcGcwdkc4ZjNVUlk2N2U3QnRwQ1VaM1NmYjJvc1hSUmdpT3VhTWdNd21r?=
 =?utf-8?B?aFhUY3dvVFNtU1R3RTBtcWpDM2xVank0VjVhMjU1c3NJbVlkaitUd056NDBP?=
 =?utf-8?B?U0VGOHhvKzRsZFp3OFZ6U21odjVtU3cxZ0JjREFYdXNqRTFlZFJucVBrUWdZ?=
 =?utf-8?B?RHNKNGt5bzhZVDJ1V0NGRFRSVU5kSEtKNmpWcGlPSHQxYlpmVjZmSCtOTTZS?=
 =?utf-8?B?bnFYZjFHODhFRXcrZmVvRFJSN2tCYXlPUmR6Szh2VXdZSnd0R0o1ckN6aGlt?=
 =?utf-8?B?NHp5RFlVeVBpR0NUZGg0REZXTmQzd01xbklmVHFEUU1FZzlqZWZlS04ranR5?=
 =?utf-8?B?NUZrbmFPQVEwWjdhalRxYkNOSS93UGdHSFk5RlppK1RoOEtNd3I4b1l4d21l?=
 =?utf-8?B?c1hQSlZybXNQRU5FbE1IVG9IMHUza0dxbGR4anZlcXoxT0hmSUx6UnNPUW80?=
 =?utf-8?B?b2s1ZzNybjQ5ZjA3aUg1WHVOM2JyNUpIQWh3T3BZTmQ3U0UwM0VPakU4Zlhu?=
 =?utf-8?B?K21ObmlsejdJWE9yUlFhTzEvMTlEa0hJUHlHNHY1Q2NCWWYwRW52Y1J6SE0r?=
 =?utf-8?B?UkpicTBsZW0rTysveXRkbVBTaFg2UHYzRGFxVk01YXFreGlYclhQeXNQSzVI?=
 =?utf-8?B?TmZHWTRwbkF1QkZCZDcwa0xwSm9PWVVOaVlGaHFQRGgvMVgxMld6REkrNVph?=
 =?utf-8?B?dXZSWm9scWdPT1h3YVI3Z2UvL1p0RlRmZW13bU5YUnhtK3FubGRVc0RpTTU4?=
 =?utf-8?B?eG4veFVZUlo4ZEU0ckI5YXBqVXcreEEwcitzbFlzNU05bDJSQTZsZXpZWDcy?=
 =?utf-8?B?V2RkU0pHdklORko3aG5RUjNiQml3M1A2OFZXQXJvbURON3RWSTdrL3ZrNm81?=
 =?utf-8?B?WEFEZy9XTEJxRFdJbnJFTnVEOXcrNm1RaW8rSG04VFNqN2NnN2c0anB3SU1W?=
 =?utf-8?B?NGt5K1R6cnFuak9QU2pHNTVMT3o2Uld5ZWZIQnBvQVV0VTFocXZOVU54YVJY?=
 =?utf-8?B?MUdvZEZZVWhDVkdNdml5Z085eFdYeGZxVThvU0lzN1pJcHF4eUlYTFAwcGxX?=
 =?utf-8?B?cVRqNHBWSU1hOEF0dTFaNVlobkl1MjcxMGVjQ0tlYUhOMjRWRnpSNFBrUXpP?=
 =?utf-8?B?N01Mc2lZRkZVaHp2dGFiRWt5ejdubVlyMW85TWZ5TjZWbXl1OXU5cHFmdlR4?=
 =?utf-8?B?OWRKN1dEWkltRmF5VEZhODI3YkhUZENvTEJma3hjb1FzQThpYXV6UnFuZ2l2?=
 =?utf-8?B?Wi9sczNTTzZPcVhKdmxRNnFxTEFkVVhsb2FhWkFYbVc4Ky9wQmU2aFBud3RR?=
 =?utf-8?B?TGE1TG5GdlRpZXB0dXFKR3YwbFI3cW5rWWtVNFVUdlVlbit4UHNpS2tSRytv?=
 =?utf-8?Q?crES8CU2fld/S?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkFBakpMZW84L1dyNEFkWFo3eDRFMzdEb2NMSDVUb0tqbUloWWR2Qm9xaXp1?=
 =?utf-8?B?QXJuOHlXTU1SUHo0Ykw5ODJVN3BJS2tPYnh6QjRVZ0JNRUV6T0Q0OTlKUWRK?=
 =?utf-8?B?OWlPT0ZMZThzQ1NXS3RCYy91aXk0dEoxeHRZUVhXY2pJWkJPREtJU05YaHFZ?=
 =?utf-8?B?SS9NTFlSQ3dDQ0FCWmVnQnNVWmt3cHdNZmdGRTZGS1JUUXlGcENsenJQYnlE?=
 =?utf-8?B?VjB0aUFCNGVSZ1lOUlcvMWZ5eFJubzNUZjYvS3FNcGM5alVic1B3U2t2RTlJ?=
 =?utf-8?B?QW90bjQwaW40MVpUdjUxZW9xMExHNnpSM1NTb1pUUjdlZStHdjJSVTBRdWVt?=
 =?utf-8?B?RXZPK0pOZnJ4ZHFsOVpQWlE2cExDUml2Qnh5UUhQQmdSNWgxRm00WTBtUkJy?=
 =?utf-8?B?b0FhWjBlVDFDYktrMjdRWmdQTXAvSFFpYmpEd2cyb3BkWmdGaG9Oem5wZUxs?=
 =?utf-8?B?MFhINEd5Tit6b0V1MmJHTEtjSHdRNkJBYkt2UnhzNUl0NEl4dE9iQ1MxNmxt?=
 =?utf-8?B?OFVnUDJUNzVPa29NUlhvNG1HN0kvbWRRTFpKU0VadzJrU1lJTTRwR3Z2czl3?=
 =?utf-8?B?cGNjcHlRR29ob1F2cUxMVE13Z1RKQ3kvVWJaN1V1QWEvYTFkN1FIWUI3Y0xS?=
 =?utf-8?B?MitkRkI3dU5ETEs3a0RVc2xmNEluUDBLcjcvcmlReVUxNW9uWmxlR3Y3R2ln?=
 =?utf-8?B?YlUxWSs0a0RaVUIzd0dtR28wSm5tWlJwTWNzd1FIcHZUM3E5UXZwcEZpb1Zi?=
 =?utf-8?B?ZnRsckozVlNIWGZSbVFFR2xsdDFDdEFqUmhhdzlFVDBnclloVWlVbGlDaEQ5?=
 =?utf-8?B?WUgwNDY0TExWYXQ0aWVpOStYMndIMGdwODJ3R2VUN09pWXB4VWhUZEtIZkw1?=
 =?utf-8?B?WDRhM0NGTHJLb2pZc2FHRnB2dmxaNDhvSE1zYUVWcjBSWnJENVExeTNTQlFw?=
 =?utf-8?B?aURDeDkvUGZnUkRxWS9BaHQrQlFxSVV3SEpoUUpPVEYxUHJQZTNmbFo1SlJx?=
 =?utf-8?B?TmRaTGtOc29INC9VSzJsblRrUG1BWiswUjdYODA0UWhZQm82dXJ1QVN0SUkz?=
 =?utf-8?B?T2dDbHJJNmphMFpma0dMNng1aU4zU3hJSUs2azVrWUV2NEZBc2JHQWxmTzdw?=
 =?utf-8?B?R1FROXdVdlNjYTVaeEcwR2tscVdjTWUrTGpPM2hadmZmZnlLUzJPU0RTNDF3?=
 =?utf-8?B?UHdRYkpNeFYxRktLUmxYTnpWQUxtRzRuK1hTR2hmS01VL3VGRDVRT3lyLzBk?=
 =?utf-8?B?WHB0OG43cG5PRWRMRStrRU1XbHdYSGFhN2o1QzRRNUtRRFFBVVdneWE0TC83?=
 =?utf-8?B?RHVWMU1xeGU1aW5KbXQveWNEaUs2eGwvYVB3V0EvWTQxZFgwNWhUSEd0TzFk?=
 =?utf-8?B?RGlSK01pTmtoQ0N2UVA0UkFLSStCMVRZY2RCZW42Y3JCSEtENk4vaW5JaW1a?=
 =?utf-8?B?VlFCNkhiUUlOQWxZS1hQWkRiTStENFZwK0R3NUtVdkhhMGZWbTh1SzRXb25J?=
 =?utf-8?B?eXR5WjFDcUxmL0NqQVE4Rk9uSml0djlmZkZzeHVpM1BEV1lkVEJNODVVNzhm?=
 =?utf-8?B?b1BRWmpHN2lUQTB1YXZEQTdaYVc1UkdYQXZlOEsyMnZja1kxWEZoSVJFVlJI?=
 =?utf-8?B?WmhkM1JtWGxERnd5azlVVm1mU05IUEpWb243NEhSK055eFhxQkVPVVNwVWNq?=
 =?utf-8?B?OEJ0M2x4eTNvQ0t0c3BPL3hPQ2FZcHJVU2RMWWQraWRPUG9COUVLUTBLQ1gx?=
 =?utf-8?B?b0xYTVdKRG5xaVllczRvUE1rc3dCQkdPMG1CTGxrckUrQ2o3TkxuaFJ2V0Vv?=
 =?utf-8?B?RFdDZ1B2ejFweUFwRThaWXozenEwc3VocFFmOU1UOURKNHBsYTYyNG1PeWF3?=
 =?utf-8?B?dlRKeFl0VlhlNWFjK3ZNUWpFeklheklkTysrZlYvMjltd09oalp1bVI4WEhZ?=
 =?utf-8?B?b3RKSkRGNEkvNks2allwU3E4dnQ1QXJNVURPR3EwRU80d29EdDZId1JTUzVP?=
 =?utf-8?B?aFQwUExHb0FpcUxHY1NDL0R3TUkzWG03RHpMY01tSVJKWjFQY3FTM0Zoc3kx?=
 =?utf-8?B?anRva1NERUFSOUswNXdzNXdxK1BLc0VtL01xMjUyQ1NpZzk2WEdQUXFaK1B5?=
 =?utf-8?Q?w4/u7z0JZ2RST9Cds+5l0AOdu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 573a43c4-f23a-4500-bb3c-08ddacc2f907
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 10:45:56.1966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MqUqEfC8NDXQF0pHeW1b3zVsYxUmGZswUhZV0iZnC/eswf/vpN1GmCA4Nv+As06zKG4rPE0PTHBfA+5g4De+1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7849
X-OriginatorOrg: intel.com

On Thu, Jun 05, 2025 at 02:12:58PM -0700, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> > On Wed, Jun 04, 2025 at 01:02:54PM -0700, Ackerley Tng wrote:
> >> Yan Zhao <yan.y.zhao@intel.com> writes:
> >> 
> >> > On Mon, May 12, 2025 at 09:53:43AM -0700, Vishal Annapurve wrote:
> >> >> On Sun, May 11, 2025 at 7:18 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >> >> > ...
> >> >> > >
> >> >> > > I might be wrongly throwing out some terminologies here then.
> >> >> > > VM_PFNMAP flag can be set for memory backed by folios/page structs.
> >> >> > > udmabuf seems to be working with pinned "folios" in the backend.
> >> >> > >
> >> >> > > The goal is to get to a stage where guest_memfd is backed by pfn
> >> >> > > ranges unmanaged by kernel that guest_memfd owns and distributes to
> >> >> > > userspace, KVM, IOMMU subject to shareability attributes. if the
> >> >> > OK. So from point of the reset part of kernel, those pfns are not regarded as
> >> >> > memory.
> >> >> >
> >> >> > > shareability changes, the users will get notified and will have to
> >> >> > > invalidate their mappings. guest_memfd will allow mmaping such ranges
> >> >> > > with VM_PFNMAP flag set by default in the VMAs to indicate the need of
> >> >> > > special handling/lack of page structs.
> >> >> > My concern is a failable invalidation notifer may not be ideal.
> >> >> > Instead of relying on ref counts (or other mechanisms) to determine whether to
> >> >> > start shareabilitiy changes, with a failable invalidation notifier, some users
> >> >> > may fail the invalidation and the shareability change, even after other users
> >> >> > have successfully unmapped a range.
> >> >>
> >> >> Even if one user fails to invalidate its mappings, I don't see a
> >> >> reason to go ahead with shareability change. Shareability should not
> >> >> change unless all existing users let go of their soon-to-be-invalid
> >> >> view of memory.
> >> 
> >> Hi Yan,
> >> 
> >> While working on the 1G (aka HugeTLB) page support for guest_memfd
> >> series [1], we took into account conversion failures too. The steps are
> >> in kvm_gmem_convert_range(). (It might be easier to pull the entire
> >> series from GitHub [2] because the steps for conversion changed in two
> >> separate patches.)
> >> 
> >> We do need to handle errors across ranges to be converted, possibly from
> >> different memslots. The goal is to either have the entire conversion
> >> happen (including page split/merge) or nothing at all when the ioctl
> >> returns.
> >> 
> >> We try to undo the restructuring (whether split or merge) and undo any
> >> shareability changes on error (barring ENOMEM, in which case we leave a
> >> WARNing).
> > As the undo can fail (as the case you leave a WARNing, in patch 38 in [1]), it
> > can lead to WARNings in kernel with folios not being properly added to the
> > filemap.
> >
> 
> I'm not sure how else to handle errors on rollback path. I've hopefully
> addressed this on the other thread at [1].
I'll reply [1].

Please also check my reply and proposal at [2].

> >> The part we don't restore is the presence of the pages in the host or
> >> guest page tables. For that, our idea is that if unmapped, the next
> >> access will just map it in, so there's no issue there.
> >
> > I don't think so.
> >
> > As in patch 38 in [1], on failure, it may fail to
> > - restore the shareability
> > - restore the folio's filemap status
> > - restore the folio's hugetlb stash metadata
> > - restore the folio's merged/split status
> >
> 
> The plan is that we try our best to restore shareability, filemap,
> restructuring (aka split/merge, including stash metadata) other than
> failures on rollback.
> 
> > Also, the host page table is not restored.
> >
> >
> 
> This is by design, the host page tables can be re-populated on the next
> fault. I've hopefully addressed this on the other thread at [1].
This is not. Please check my reply to [1].


> >> > My thinking is that:
> >> >
> >> > 1. guest_memfd starts shared-to-private conversion
> >> > 2. guest_memfd sends invalidation notifications
> >> >    2.1 invalidate notification --> A --> Unmap and return success
> >> >    2.2 invalidate notification --> B --> Unmap and return success
> >> >    2.3 invalidate notification --> C --> return failure
> >> > 3. guest_memfd finds 2.3 fails, fails shared-to-private conversion and keeps
> >> >    shareability as shared
> >> >
> >> > Though the GFN remains shared after 3, it's unmapped in user A and B in 2.1 and
> >> > 2.2. Even if additional notifications could be sent to A and B to ask for
> >> > mapping the GFN back, the map operation might fail. Consequently, A and B might
> >> > not be able to restore the mapped status of the GFN.
> >> 
> >> For conversion we don't attempt to restore mappings anywhere (whether in
> >> guest or host page tables). What do you think of not restoring the
> >> mappings?
> > It could cause problem if the mappings in S-EPT can't be restored.
> >
> > For TDX private-to-shared conversion, if kvm_gmem_convert_should_proceed() -->
> > kvm_gmem_unmap_private() --> kvm_mmu_unmap_gfn_range() fails in the end, then
> > the GFN shareability is restored to private. The next guest access to
> > the partially unmapped private memory can meet a fatal error: "access before
> > acceptance".
> >
> > It could occur in such a scenario:
> > 1. TD issues a TDVMCALL_MAP_GPA to convert a private GFN to shared
> > 2. Conversion fails in KVM.
> > 3. set_memory_decrypted() fails in TD.
> > 4. TD thinks the GFN is still accepted as private and accesses it.
> >
> >
> 
> This is true, I was thinking that this isn't handled solely in
> conversion but by being part of the contract between userspace VMM and
> the guest, that guest must handle conversion failures. I've hopefully
> addressed this on the other thread at [1].
> 
> >> > For IOMMU mappings, this
> >> > could result in DMAR failure following a failed attempt to do shared-to-private
> >> > conversion.
> >> 
> >> I believe the current conversion setup guards against this because after
> >> unmapping from the host, we check for any unexpected refcounts.
> > Right, it's fine if we check for any unexpected refcounts.
> >
> >
> >> (This unmapping is not the unmapping we're concerned about, since this is
> >> shared memory, and unmapping doesn't go through TDX.)
> >> 
> >> Coming back to the refcounts, if the IOMMU had mappings, these refcounts
> >> are "unexpected". The conversion ioctl will return to userspace with an
> >> error.
> >> 
> >> IO can continue to happen, since the memory is still mapped in the
> >> IOMMU. The memory state is still shared. No issue there.
> >> 
> >> In RFCv2 [1], we expect userspace to see the error, then try and remove
> >> the memory from the IOMMU, and then try conversion again.
> > I don't think it's right to depend on that userspace could always perform in 
> > kernel's expected way, i.e. trying conversion until it succeeds.
> >
> 
> Let me think more deeply about this. Please let me know if there's
> anything I missed.
> 
> It is true that a buggy or malicious userspace VMM can ignore conversion
> failures and report success to the guest, but if both the userspace VMM
> and guest are malicious, it's quite hard for the kernel to defend
> against that.
Hmm, expecting userspace to try conversion endlessly exceeds what is reasonable
for a cooperative userspace?

> I think as long as there's no point where the guest can crash the host
> in a fixed way, I think it is okay to rely on a userspace VMM and guest
> protocol.
> 
> IIUC the guest can crash the host (original point of having guest_memfd)
> if the guest can convince the host to write to private memory. For that
How to?
Unless the host kernel wants to crash itself, I don't think allowing guest to
crash the host is acceptable.
If you happen to know one, please let us know. We'll fix it.

> to happen, the memory must be faulted into the Secure EPTs, and the
> shareability state must be ALL for the host to fault it in.
> 
> So to have this issue, the conversion failure must be such that the
> memory remains faulted into the Secure EPTs while shareability is
> shared. Since unmapping from secure EPTs happens pretty early before any
> shareability is changed or any rollback (and rollback failures) can
> happen, I think we should be quite safe?
It's not safe if unmapping from the secure EPT fails while the shareability is
changed to shared.


> If unmapping of private memory fails, this is where I think guest_memfd
> should get an error from the unmap and it should not proceed to change
> shareability.
Please check if my proposal at [2] is agreeable.

> 
> > We need to restore to the previous status (which includes the host page table)
> > if conversion can't be done.
> 
> Most of the previous status (shareability, filemap,
> restructuring (aka split/merge, including stash metadata)) are restored
> other than during rollback failures.
However, error during the rollback is unacceptable.


> As for presence in host page tables, is it okay to defer that till the
> next fault, and if not okay, why not?
If the host page tables involve only shared mappings in the primary MMU
and shared EPT, it's ok.


> For presence in guest page tables, is it okay to fall back on the
> protocol where the guest must handle conversion failures, and if not
> okay, why not?
Hmm, whether to roll back the guest page table or not after the conversion
failure is the business of the guest OS.

However, KVM can't rely on that the guest must assume that the page state is
shared even after a private-to-shared conversion failure.


> > That said, in my view, a better flow would be:
> >
> > 1. guest_memfd sends a pre-invalidation request to users (users here means the
> >    consumers in kernel of memory allocated from guest_memfd).
> >
> > 2. Users (A, B, ..., X) perform pre-checks to determine if invalidation can
> >    proceed. For example, in the case of TDX, this might involve memory
> >    allocation and page splitting.
> >
> > 3. Based on the pre-check results, guest_memfd either aborts the invalidation or
> >    proceeds by sending the actual invalidation request.
> >
> > 4. Users (A-X) perform the actual unmap operation, ensuring it cannot fail. For
> >    TDX, the unmap must succeed unless there are bugs in the KVM or TDX module.
> >    In such cases, TDX can callback guest_memfd to inform the poison-status of
> >    the page or elevate the page reference count.
> >
> > 5. guest_memfd completes the invalidation process. If the memory is marked as
> >    "poison," guest_memfd can handle it accordingly. If the page has an elevated
> >    reference count, guest_memfd may not need to take special action, as the
> >    elevated count prevents the OS from reallocating the page.
> >    (but from your reply below, seems a callback to guest_memfd is a better
> >    approach).
> >
> >
> 
> Thanks for this, I've tried to combine this into my response at
> [1]. I think this works, but it's hard because
> 
> a. Pre-checks are hard to check (explained at [1])
Please check if the pre-checks in my POC [2] is good.
I tested it for the case of TDX unmapping failure. It does not change the
shareabilitiy if splitting or zapping fails.


> b. Even after all the checks, unmapping can still fail, and those still
>    have to be handled, and to handle those, we have to buy into the
>    userspace VMM/guest protocol, so why not just buy into the protocol
>    to start with?
In my POC [2], the outcome of unmapping failure is to leak the pages.
Please check if it looks good to you.

> [1] https://lore.kernel.org/all/diqztt4uhunj.fsf@ackerleytng-ctop.c.googlers.com/

[2] https://lore.kernel.org/all/aE%2Fq9VKkmaCcuwpU@yzhao56-desk.sh.intel.com/

> >> The part in concern here is unmapping failures of private pages, for
> >> private-to-shared conversions, since that part goes through TDX and
> >> might fail.
> > IMO, even for TDX, the real unmap must not fail unless there are bugs in the KVM
> > or TDX module.
> > So, for page splitting in S-EPT, I prefer to try splitting in the
> > pre-invalidation phase before conducting any real unmap.
> >
> >
> 
> Thanks for your detailed suggestion.
> 
> >> One other thing about taking refcounts is that in RFCv2,
> >> private-to-shared conversions assume that there are no refcounts on the
> >> private pages at all. (See filemap_remove_folio_for_restructuring() in
> >> [3])
> >>
> >> Haven't had a chance to think about all the edge cases, but for now I
> >> think on unmapping failure, in addition to taking a refcount, we should
> >> return an error at least up to guest_memfd, so that guest_memfd could
> >> perhaps keep the refcount on that page, but drop the page from the
> >> filemap. Another option could be to track messed up addresses and always
> >> check that on conversion or something - not sure yet.
> >
> > It looks good to me. See the bullet 4 in my proposed flow above.
> >
> 
> Thanks again for your detailed suggestion.
> 
> >> Either way, guest_memfd must know. If guest_memfd is not informed, on a
> >> next conversion request, the conversion will just spin in
> >> filemap_remove_folio_for_restructuring().
> > It makes sense.
> >
> >
> >> What do you think of this part about informing guest_memfd of the
> >> failure to unmap?
> > So, do you want to add a guest_memfd callback to achieve this purpose?
> >
> 
> I will need to think the entire thing through, but I meant informing as
> in returning an error to guest_memfd so that guest_memfd knows. I think
> returning an error should be the first cause of action.
> 
> As for whether guest_memfd should know how to handle the error or
> whether the userspace VMM should participate in deciding what to do with
> the error, I'm not sure. If you have suggestions on this, I hope we can
> combine the suggestions about the conversion protocol on the other thread.
> 
> Regarding a callback, are you thinking something like not having the
> unmap return an error, but instead TDX will call a function like
> kvm_gmem_error_at_offset(loff_t offset), and guest_memfd will then
> record that somewhere, and then immediately after calling unmap
> guest_memfd will check kvm_gmem_was_there_an_error_in_range() and then
> determining whether there's an error? Something like that?
> 
> I guess it could work but feels a little odd.
> 
> >
> > BTW, here's an analysis of why we can't let kvm_mmu_unmap_gfn_range()
> > and mmu_notifier_invalidate_range_start() fail, based on the repo
> > https://github.com/torvalds/linux.git, commit cd2e103d57e5 ("Merge tag
> > 'hardening-v6.16-rc1-fix1-take2' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux")
> 
> Thank you, I appreciate the effort you took to enumerate these. The
> following suggestions are based on my current understanding. I don't
> have time in the near future to do the plumbing to test out the
> suggestion, but for now I want to see if this suggestion makes sense,
> maybe you can correct any misunderstandings first. 

Sorry, I realized that the below enumeration brought confusion.

Listing them was to prove that unmapping failure is not expected by the kernel.

Please kindly let me know if any existing kernel code allows unmap to fail.

> > 1. Status of mmu notifier
> > -------------------------------
> > (1) There're 34 direct callers of mmu_notifier_invalidate_range_start().
> >     1. clear_refs_write
> >     2. do_pagemap_scan
> >     3. uprobe_write_opcode
> >     4. do_huge_zero_wp_pmd
> >     5. __split_huge_pmd (N)
> >     6. __split_huge_pud (N)
> >     7. move_pages_huge_pmd
> >     8. copy_hugetlb_page_range
> >     9. hugetlb_unshare_pmds  (N)
> >     10. hugetlb_change_protection
> >     11. hugetlb_wp
> >     12. unmap_hugepage_range (N)
> >     13. move_hugetlb_page_tables
> >     14. collapse_huge_page
> >     15. retract_page_tables
> >     16. collapse_pte_mapped_thp
> >     17. write_protect_page
> >     18. replace_page
> >     19. madvise_free_single_vma
> >     20. wp_clean_pre_vma
> >     21. wp_page_copy 
> >     22. zap_page_range_single_batched (N)
> >     23. unmap_vmas (N)
> >     24. copy_page_range 
> >     25. remove_device_exclusive_entry
> >     26. migrate_vma_collect
> >     27. __migrate_device_pages
> >     28. change_pud_range 
> >     29. move_page_tables
> >     30. page_vma_mkclean_one
> >     31. try_to_unmap_one
> >     32. try_to_migrate_one
> >     33. make_device_exclusive
> >     34. move_pages_pte
> >
> > Of these 34 direct callers, those marked with (N) cannot tolerate
> > mmu_notifier_invalidate_range_start() failing. I have not yet investigated all
> > 34 direct callers one by one, so the list of (N) is incomplete.
> >
> > For 5. __split_huge_pmd(), Documentation/mm/transhuge.rst says:
> > "Note that split_huge_pmd() doesn't have any limitations on refcounting:
> > pmd can be split at any point and never fails." This is because split_huge_pmd()
> > serves as a graceful fallback design for code walking pagetables but unaware
> > about huge pmds.
> >
> >

> Do these callers, especially those with (N), ever try to unmap any TDX
> private pages? guest_memfd only gives shared pages to core-mm, so for
> shared pages, there will continue to be no chance of errors.
> 
> If we change mmu_notifier_invalidate_range_start() to return an int, all
> of the callers that never invalidate shared pages can continue to safely
> rely on the fact that mmu_notifier_invalidate_range_start() will return
> 0.
mmu_notifier_invalidate_range_start() is just to zap shared pages.

 
> For the callers of mmu_notifier_invalidate_range_start() that may touch
> private pages, I believe that's only guest_memfd and KVM. That's where
> we want the error, and will handle the error.
> 
> Another point here is that I was thinking to put EPT splitting together
> with actual unmapping instead of with invalidation because we will
> probably invalidate more than we unmap (see explanation at [1] about the
> race). Maybe moving EPT splitting to unmap could help?
> 
> > (2) There's 1 direct caller of mmu_notifier_invalidate_range_start_nonblock(),
> > __oom_reap_task_mm(), which only expects the error -EAGAIN.
> >
> > In mn_hlist_invalidate_range_start():
> > "WARN_ON(mmu_notifier_range_blockable(range) || _ret != -EAGAIN);"
> >
> >
> > (3) For DMAs, drivers need to invoke pin_user_pages() to pin memory. In that
> > case, they don't need to register mmu notifier.
> >
> > Or, device drivers can pin pages via get_user_pages*(), and register for mmu         
> > notifier callbacks for the memory range. Then, upon receiving a notifier         
> > "invalidate range" callback , stop the device from using the range, and unpin    
> > the pages.
> >
> > See Documentation/core-api/pin_user_pages.rst.
> >
> >
> 
> Do you mean that we should teach device drivers to get callbacks for
> private pages? Are you looking ahead to handle TDX IO on private pages?
> So far we haven't handled that yet.
I tried to show that device drivers increases page refcount (by pinning) when it
maps a page into IOMMU page table. It does not decrease page refcount (by
unpinning) until after unmapping.

If the page hold by the device driver is allocated from hugetlb, and if the page
has been truncated from the hugetlb, the page is still hold by the device
driver until the page is unmapped in the IOMMU page table.

This is similar to TDX. As long as a page is still mapped in the SEPT or tracked
by the TDX module, it's better to hold a page refcount even after the page is
truncated from the file mapping.


> > 2. Cases that cannot tolerate failure of mmu_notifier_invalidate_range_start()
> > -------------------------------
> > (1) Error fallback cases.
> >
> >     1. split_huge_pmd() as mentioned in Documentation/mm/transhuge.rst.
> >        split_huge_pmd() is designed as a graceful fallback without failure.
> >
> >        split_huge_pmd
> >         |->__split_huge_pmd
> >            |->mmu_notifier_range_init
> >            |  mmu_notifier_invalidate_range_start
> >            |  split_huge_pmd_locked
> >            |  mmu_notifier_invalidate_range_end
> >
> >
> >     2. in fs/iomap/buffered-io.c, iomap_write_failed() itself is error handling.
> >        iomap_write_failed
> >          |->truncate_pagecache_range
> >             |->unmap_mapping_range
> >             |  |->unmap_mapping_pages
> >             |     |->unmap_mapping_range_tree
> >             |        |->unmap_mapping_range_vma
> >             |           |->zap_page_range_single
> >             |              |->zap_page_range_single_batched
> >             |                       |->mmu_notifier_range_init
> >             |                       |  mmu_notifier_invalidate_range_start
> >             |                       |  unmap_single_vma
> >             |                       |  mmu_notifier_invalidate_range_end
> >             |->truncate_inode_pages_range
> >                |->truncate_cleanup_folio
> >                   |->if (folio_mapped(folio))
> >                   |     unmap_mapping_folio(folio);
> >                          |->unmap_mapping_range_tree
> >                             |->unmap_mapping_range_vma
> >                                |->zap_page_range_single
> >                                   |->zap_page_range_single_batched
> >                                      |->mmu_notifier_range_init
> >                                      |  mmu_notifier_invalidate_range_start
> >                                      |  unmap_single_vma
> >                                      |  mmu_notifier_invalidate_range_end
> >
> >    3. in mm/memory.c, zap_page_range_single() is invoked to handle error.
> >       remap_pfn_range_notrack
> >         |->int error = remap_pfn_range_internal(vma, addr, pfn, size, prot);
> >         |  if (!error)
> >         |      return 0;
> > 	|  zap_page_range_single
> >            |->zap_page_range_single_batched
> >               |->mmu_notifier_range_init
> >               |  mmu_notifier_invalidate_range_start
> >               |  unmap_single_vma
> >               |  mmu_notifier_invalidate_range_end
> >
> >    4. in kernel/events/core.c, zap_page_range_single() is invoked to clear any
> >       partial mappings on error.
> >
> >       perf_mmap
> >         |->ret = map_range(rb, vma);
> >                  |  err = remap_pfn_range
> >                  |->if (err) 
> >                  |     zap_page_range_single
> >                         |->zap_page_range_single_batched
> >                            |->mmu_notifier_range_init
> >                            |  mmu_notifier_invalidate_range_start
> >                            |  unmap_single_vma
> >                            |  mmu_notifier_invalidate_range_end
> >
> >
> >    5. in mm/memory.c, unmap_mapping_folio() is invoked to unmap posion page.
> >
> >       __do_fault
> > 	|->if (unlikely(PageHWPoison(vmf->page))) { 
> > 	|	vm_fault_t poisonret = VM_FAULT_HWPOISON;
> > 	|	if (ret & VM_FAULT_LOCKED) {
> > 	|		if (page_mapped(vmf->page))
> > 	|			unmap_mapping_folio(folio);
> >         |                       |->unmap_mapping_range_tree
> >         |                          |->unmap_mapping_range_vma
> >         |                             |->zap_page_range_single
> >         |                                |->zap_page_range_single_batched
> >         |                                   |->mmu_notifier_range_init
> >         |                                   |  mmu_notifier_invalidate_range_start
> >         |                                   |  unmap_single_vma
> >         |                                   |  mmu_notifier_invalidate_range_end
> > 	|		if (mapping_evict_folio(folio->mapping, folio))
> > 	|			poisonret = VM_FAULT_NOPAGE; 
> > 	|		folio_unlock(folio);
> > 	|	}
> > 	|	folio_put(folio);
> > 	|	vmf->page = NULL;
> > 	|	return poisonret;
> > 	|  }
> >
> >
> >   6. in mm/vma.c, in __mmap_region(), unmap_region() is invoked to undo any
> >      partial mapping done by a device driver.
> >
> >      __mmap_new_vma
> >        |->__mmap_new_file_vma(map, vma);
> >           |->error = mmap_file(vma->vm_file, vma);
> >           |  if (error)
> >           |     unmap_region
> >                  |->unmap_vmas
> >                     |->mmu_notifier_range_init
> >                     |  mmu_notifier_invalidate_range_start
> >                     |  unmap_single_vma
> >                     |  mmu_notifier_invalidate_range_end
> >
> >
> 
> These should probably not ever be invalidating or unmapping private pages.
> 
> > (2) No-fail cases
> > -------------------------------
> > 1. iput() cannot fail. 
> >
> > iput
> >  |->iput_final
> >     |->WRITE_ONCE(inode->i_state, state | I_FREEING);
> >     |  inode_lru_list_del(inode);
> >     |  evict(inode);
> >        |->op->evict_inode(inode);
> >           |->shmem_evict_inode
> >              |->shmem_truncate_range
> >                 |->truncate_inode_pages_range
> >                    |->truncate_cleanup_folio
> >                       |->if (folio_mapped(folio))
> >                       |     unmap_mapping_folio(folio);
> >                             |->unmap_mapping_range_tree
> >                                |->unmap_mapping_range_vma
> >                                   |->zap_page_range_single
> >                                      |->zap_page_range_single_batched
> >                                         |->mmu_notifier_range_init
> >                                         |  mmu_notifier_invalidate_range_start
> >                                         |  unmap_single_vma
> >                                         |  mmu_notifier_invalidate_range_end
> >
> >
> > 2. exit_mmap() cannot fail
> >
> > exit_mmap
> >   |->mmu_notifier_release(mm);
> >      |->unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX, false);
> >         |->mmu_notifier_range_init
> >         |  mmu_notifier_invalidate_range_start
> >         |  unmap_single_vma
> >         |  mmu_notifier_invalidate_range_end
> >
> >
> 
> These should probably not ever be invalidating or unmapping private pages.
> 
> > 3. KVM Cases That Cannot Tolerate Unmap Failure
> > -------------------------------
> > Allowing unmap operations to fail in the following scenarios would make it very
> > difficult or even impossible to handle the failure:
> >
> > (1) __kvm_mmu_get_shadow_page() is designed to reliably obtain a shadow page
> > without expecting any failure.
> >
> > mmu_alloc_direct_roots
> >   |->mmu_alloc_root
> >      |->kvm_mmu_get_shadow_page
> >         |->__kvm_mmu_get_shadow_page
> >            |->kvm_mmu_alloc_shadow_page
> >               |->account_shadowed
> >                  |->kvm_mmu_slot_gfn_write_protect
> >                     |->kvm_tdp_mmu_write_protect_gfn
> >                        |->write_protect_gfn
> >                           |->tdp_mmu_iter_set_spte
> >
> >
> 
> I need to learn more about shadow pages but IIUC TDX doesn't use shadow
> pages so this path won't interact with unmapping private pages.
> 
> > (2) kvm_vfio_release() and kvm_vfio_file_del() cannot fail
> >
> > kvm_vfio_release/kvm_vfio_file_del
> >  |->kvm_vfio_update_coherency
> >     |->kvm_arch_unregister_noncoherent_dma
> >        |->kvm_noncoherent_dma_assignment_start_or_stop
> >           |->kvm_zap_gfn_range
> >              |->kvm_tdp_mmu_zap_leafs
> >                 |->tdp_mmu_zap_leafs
> >                    |->tdp_mmu_iter_set_spte
> >
> >
> 
> I need to learn more about VFIO but for now IIUC IO uses shared pages,
> so this path won't interact with unmapping private pages.
> 
> > (3) There're lots of callers of __kvm_set_or_clear_apicv_inhibit() currently
> > never expect failure of unmap.
> >
> > __kvm_set_or_clear_apicv_inhibit
> >   |->kvm_zap_gfn_range
> >      |->kvm_tdp_mmu_zap_leafs
> >         |->tdp_mmu_zap_leafs
> >            |->tdp_mmu_iter_set_spte
> >
> >
> >
> 
> There could be some TDX specific things such that TDX doesn't use this
> path.
tdp_mmu_iter_set_spte() is used by KVM generally to update the SPTE when
kvm->mmu_lock is held for write.

TDX uses tdp_mmu_iter_set_spte() to further unmapping the SEPT.

Converting tdp_mmu_iter_set_spte() to return error is a huge work and I don't
think it's right or worthwhile.

> 
> > 4. Cases in KVM where it's hard to make tdp_mmu_set_spte() (update SPTE with
> > write mmu_lock) failable.
> >
> > (1) kvm_vcpu_flush_tlb_guest()
> >
> > kvm_vcpu_flush_tlb_guest
> >   |->kvm_mmu_sync_roots
> >      |->mmu_sync_children
> >         |->kvm_vcpu_write_protect_gfn
> >            |->kvm_mmu_slot_gfn_write_protect
> >               |->kvm_tdp_mmu_write_protect_gfn
> >                  |->write_protect_gfn
> >                     |->tdp_mmu_iter_set_spte
> >                        |->tdp_mmu_set_spte
> >
> >
> > (2) handle_removed_pt() and handle_changed_spte().
> >
> 
> Thank you so much for looking into these, I'm hoping that the number of
> cases where TDX and private pages are unmapped are really limited to a
> few paths that we have to rework.
> 
> If we agree that the error has to be handled, then regardless of how we
> let the caller know that an error happened, all paths touching TDX
> private pages have to be reworked.
> 
> Between (1) returning an error vs (2) marking error and having the
> caller check for errors, then it's probably better to use the standard
> approach of returning an error since it is better understood, and
> there's no need to have extra data structures?
However, I don't think returning error during the unmap path is a standard
approach...


