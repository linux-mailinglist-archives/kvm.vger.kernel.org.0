Return-Path: <kvm+bounces-33099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F9199E4A20
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 00:52:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE3EF287779
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 23:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F7411B2196;
	Wed,  4 Dec 2024 23:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D/7d/Poy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BE419F49E;
	Wed,  4 Dec 2024 23:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733356290; cv=fail; b=DvsH0CB+QjDwukTYNlRVEizJNO9TTNU91DnygFEp3g7/ebEBDopHkqtffPZfmI5JrDD8gCMYHc99yHn9aACb/5vRLd3i4YNSzq04hsr3R5EoTJ05fwhmLxvkSt1CHeLdoelBsqKxapMJaz5lh5ea+oGfG8bigzlYfINQi1juyeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733356290; c=relaxed/simple;
	bh=2sqPdV9t+DLrkvja8VYI0EeHnmWW/hhdVU8T5U8nQBo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FpXLoZ5SPzpotiABNk3g1/uG/6KSbGxcPi1naoDuk7RubwAGnsx16GRVcGHw62MKJSeSR2ni0UmmOjPxb6LuCd3tERlFexSyczCoiIIyHlel9IvRpSTll6ZK1tb3LBqM8Uy3bJ8y6J8d7P6IycP+4YVcz+JVLwNJpfo1naSCeAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D/7d/Poy; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733356288; x=1764892288;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2sqPdV9t+DLrkvja8VYI0EeHnmWW/hhdVU8T5U8nQBo=;
  b=D/7d/PoytK2lYwdHxeN+bgMMPa5FWnOHLMt+Q5icDABog/xymeVMQkeo
   il+Drp1WHjqCyJWFo+RnqUgAkSn9Dc5lcPpNobwNJpqQYV5FalBk3CSvb
   KdE/P5FXr8HMjIUYq3fvorKJvAXkrM67D6wX7Q/Ik+SQ5JWkaiCuxyPeF
   OtOyTzxg2mo6Ayhfwmlq76+h/nKccQ6NVEjnBZVrWQTmKH1wBeWCth1/6
   jSvh1YkoH7TxYcye6Hc7CcWthQjQl3xxRaq/yhScpYtr0qCSli5J0vQ4/
   SukAOd7FGVt+24j5CYth0ct+WhnzGyKFd0LIIyaYzufvfJC3yEkYvapFP
   g==;
X-CSE-ConnectionGUID: i+3Ese/CT/uVYYDvRMYiiQ==
X-CSE-MsgGUID: UQq9tuwWTB6iSsuU5RDKtQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="45024473"
X-IronPort-AV: E=Sophos;i="6.12,208,1728975600"; 
   d="scan'208";a="45024473"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 15:51:27 -0800
X-CSE-ConnectionGUID: pE1RgxyqQ+mSvFqySJZCGg==
X-CSE-MsgGUID: 601FOzVxR8eWYRSQSr6jLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,208,1728975600"; 
   d="scan'208";a="93791965"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2024 15:51:27 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Dec 2024 15:51:27 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 4 Dec 2024 15:51:27 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 4 Dec 2024 15:51:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mjwrMNZOa3gHsqEsjd5EeD0hLprm7GBw3Y13+4vHRacVKbL/NeJwnylkPr4I9dyMa+NeQvyUr57nBPb/TmkQBdR0ZIvsv/Q4LaSHeDWGKGQuXQO2JRJo3Ccgw1msxiX48Xliwb5AZqbzL1SiGu8F2vI0fYPHr2TJFu5ourjJU/iwc+RtASPRm8m+Xeo9UUlZR6aHHjP4y5C4XnIoTXQ2OEi5tnIFPPL8CI5/d8yeJwZaWQ9HJ4ykhpHB367/bh9H/N8R554T2PF7D74rGfsQkk04Hl+RA4gylZw3muwKkY+iFsvzWzI9y2xGKLcFO10MpRLnvjo9E2ZxsQHhoHWT+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2sqPdV9t+DLrkvja8VYI0EeHnmWW/hhdVU8T5U8nQBo=;
 b=EYG+w12U6rXx0tz3y47Kc2cMUKy2omJxNvQJB5RJZLS4WCQJMFaPpAviV0XoIfhlk45UZJq+B5YMDLlEzJilo3KjdPGd/ramRSMfCjz/uf0WVtu+aaGovMmRTDOxqTSLwK1tgLkCUkPcbtsmIs8bdsuLGx51eTFaro4Y3PIQuVVNslbdUrMuf5/TBrFzwk8HERaJlXu3yxkwAGjtt5CLOj447b3gTfA9cVWMKF3ch6hMSZvyGIGT94VZd97/6065vWqgK+INqmmmfLa0GLZ+ZT4TeFnFj5eYOClHPnKGMl2uxM0369Jcc+rSu+rwh9RdPfsXqsjtmiKZkIPgUy8tCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB7098.namprd11.prod.outlook.com (2603:10b6:510:20d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Wed, 4 Dec
 2024 23:51:22 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8207.017; Wed, 4 Dec 2024
 23:51:22 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Gao, Chao" <chao.gao@intel.com>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"dmatlack@google.com" <dmatlack@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Thread-Topic: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Thread-Index: AQHbPFI1CpXUe0dtwEa1D+tl1lrdQLLCpF0AgAiMhYCAAv0xgIAFNDOAgAAEoYCAAFbIgIABHPqAgAAckQCAAGbYgIAAUfgAgAAFaQCAAAVygIAAR3GAgAAL3oCAADzZAIAAiyWA
Date: Wed, 4 Dec 2024 23:51:22 +0000
Message-ID: <44c67438cf3b2b1ce63dbc8f21fef18614805ed8.camel@intel.com>
References: <b36dd125-ad80-4572-8258-7eea3a899bf9@intel.com>
	 <Z04Ffd7Lqxr4Wwua@google.com>
	 <c98556099074f52af1c81ec1e82f89bec92cb7cd.camel@intel.com>
	 <Z05SK2OxASuznmPq@google.com>
	 <60e2ed472e03834c13a48e774dc9f006eda92bf5.camel@intel.com>
	 <9beb9e92-b98c-42a2-a2d3-35c5b681ad03@intel.com>
	 <Z0+vdVRptHNX5LPo@intel.com>
	 <0e34f9d0-0927-4ac8-b1cb-ef8500b8d877@intel.com>
	 <Z0/4wsR2WCwWfZyV@intel.com>
	 <2bcd34eb-0d1f-46c0-933f-fb1d70c70a1e@intel.com>
	 <Z1A5QWaTswaQyE3k@intel.com>
	 <c9b14955-6e2f-4490-a18c-0537ffdfff30@intel.com>
	 <a005d50c-6ca8-4572-80ba-5207b95323fb@intel.com>
In-Reply-To: <a005d50c-6ca8-4572-80ba-5207b95323fb@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB7098:EE_
x-ms-office365-filtering-correlation-id: 0ca73bac-aa60-488e-6398-08dd14be8ea7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K2FwbnRPSnhTVmhVNHBHVnFCZHgvcnh0empQRS9ha09kWW05OVJscWU2aDRq?=
 =?utf-8?B?VTZvNUpydG0zN2JmUDVoUSt3dHRhWjk4QVNrejl6dG9wTTRtZEtJTFRNWEhr?=
 =?utf-8?B?UDF2Vy9xTmpmWVBOZU1KSXRxODlKNkMxK1F0R1dYVm5tWWZKVkdoZjV6eGVP?=
 =?utf-8?B?RHh2NU1MUzJnYWxoYTFsKy9oeUE0YVY4eU40bDhVRHQ0cTJLV1lRT3B2Zkt2?=
 =?utf-8?B?M3ZNUWIzdnJ2a09DSFhyV0E4VU9uTGx5cTVvdFpvMzV4YVJsYlUyTCtHQVhH?=
 =?utf-8?B?eTZSaExFNklNc2MxMDZYaDJFNjFuTS9icXk0NmUvNzBtT3ZjdkNEK1BFdkt6?=
 =?utf-8?B?MmFUWXJNUndua3NIeDYrTER2UEkvYlo3OGJkWWFRMENjRGFEZmQ2a2pYNkNz?=
 =?utf-8?B?cHFQa0tlMXg1Q2JOeGdoTlZlT0dDTXFMZjVyK2hjNlBRWnBJTDRTQlU1dnoz?=
 =?utf-8?B?c1lPRW9hNTJpR1N4My8wYm9yVTdwY0xPQ2lIdlBKMUpkUFRGbWhXZjFPY1ND?=
 =?utf-8?B?SGhxemE1Yml2RnozYitwUU44YThxZzJCdUptSGdYTXlmcmJHR1YwUlUxREUy?=
 =?utf-8?B?QWVmVUcrejhCK3FhcTJTcUk4UHo4RVVzOHZaeVh5ci9vcU9RaTZhT0UzRXFR?=
 =?utf-8?B?ZEY4UXdSU2NlenV0S3ZrMWZzbW1jWnN1c0w4ZFkzM3BDT3pzSkgxWm5vMEw1?=
 =?utf-8?B?V21hNFUrZFVQb1hmK1R6YTBBTWdEYk9ONTZvM0NZeXBNaTVBbXplS3JRTS9O?=
 =?utf-8?B?dlpwNVNvTlJDQ2RNYjkrcjd1Uzhzb3NaQmYvTVN4NHhpbFdnQ21BQUlBWmtJ?=
 =?utf-8?B?NEt4ZVllNzlxWENjcFZjazVQZnFFelJqTWhMbnNQUS92N2tQZEtiVjh3dEdZ?=
 =?utf-8?B?QWpWR2xMWmRzN2tPN203aDB5MDBXSTBuNFk4YlgrVVpuRW5NcFhJVDcyOURD?=
 =?utf-8?B?SFFxMVB3KzNsdmNWNVUyUmRVZWJYV3RuL0xhbGNocWJCdnBmam1idTN4eHF2?=
 =?utf-8?B?c29GU0gyU2hhaWJkYnJCK3NKYjJnUkV4NWVMNDVzOG92bkFRZkRybVJiMWwv?=
 =?utf-8?B?UzliQlBTRm54SFA5SU02bTIvZ1Y3MWlsRVF5VGZ2NzJURFRWTm1Yc24wWEcv?=
 =?utf-8?B?THFuVm9xRTRPQ1hiWG1nb1RWMjNUQThuVHcwenk3L0ZqNjh4bzNGNWRSa0Ru?=
 =?utf-8?B?N3d5QnpldUV3TDY5OTZwVWhFZFVNaTZ1c3FPTnMwaUQ3K0dHSXVkTVBsN05O?=
 =?utf-8?B?cGpqeldIcmxmWDRVdGFnd0JEVDF4WnNQczAxeFR4MkhHV2hPMXQyc3ordHhn?=
 =?utf-8?B?ZWJUdC8yRUM4VlFDOGIySmYxN2IrSDdpU3h1UmVseTNtNnhmakliSTBIMnFZ?=
 =?utf-8?B?WUF2dGROSXd1dTBaZUNDMENaMDExMzFLWEZ3VURVV21COTdVUHVaRWxOajBm?=
 =?utf-8?B?YzcvbVVTcFNicEJRdnVTcDlJWGRZNEZoOWsza1JXNkR4QTJuYlQwOHZUSGN3?=
 =?utf-8?B?QUkzN2ZnNXdpTjgzeHk1dnNaTkMwc01XNmhIN0Q2djF0T095VFB4K0R1MnQ4?=
 =?utf-8?B?NzJVb05BNklIejdnTnN1V21OakNrOVFZZDRIWTB1VlVFZ04vRmh0WHFKVVA1?=
 =?utf-8?B?cjRrVWw3OXNITXlQRytrT2d6ejRkVWpNNEFyeTBES2tGUDhqaEsweHRISEE0?=
 =?utf-8?B?TEgvclhKbkJwWFgzWUprYnlJUEh0SGlSUCswSTRlaTV3STlEOXJ3eUJ2OUZw?=
 =?utf-8?B?cUVKdnd3dnFPUXZRcW5xejN4SWNaUFFLS2h1cUpLSmdPRFJ5eERRcUdLOFN5?=
 =?utf-8?B?ZktBaFUrZHRVMjljTnJWWHVkTjdzMUU4T1dVNlFXUS9KM3J1ZzNzVWpBVG5o?=
 =?utf-8?B?SlpiU2Q4bHJTdllWcjBTaTZRLzN3ZzYwSGtjOFBBVUtZQXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGp2d1BRRUR6RVhYMGhMeFh5K2NRTVFEQWlDQW9FMHRhYmcvZlhNekhDSXBS?=
 =?utf-8?B?RzYzVU9ybk16blpwSHBwNnl4cktDSlhUaVMzVkV4V09HbUZXYUN2KzZVZkh6?=
 =?utf-8?B?alNobzdUUmNwd3ZoYnJDV1pFcmgxWURXRkNYTDI0UG5BRUVqNkFxc1J5MEl5?=
 =?utf-8?B?Z2xPMTR2NDlGUXRpbU42OXJXRW1NQ3lON0RxcXYrMHNiYWE1UlZOdmpNL3U1?=
 =?utf-8?B?OWdBVVBlbzRZU1BXWnFmb3dQSkx4MGQvQVRESFFzM2pJZ2xZalZiNW91Z1p5?=
 =?utf-8?B?dXRDeEVpTGowWVhhMlo2cm9CK2paMTVSaTdJMmZIQnlaOU1OLzYxOHFzK1Qy?=
 =?utf-8?B?T1VYT05FR0FnMTczbGdvSDVyeW10d2cyL0hMUGdnQXZrcGowOUZvUHVrOXcz?=
 =?utf-8?B?RmVBS0h0SGdaY1JKMzBpcDQxV1VOQXVHV3UreUhSNUdTYnlsU3NUdVEyMXVw?=
 =?utf-8?B?YUsyc0t1VG16bmQ5Y1A3QWgweUNEcGRVWFQ1N3FxZHVOVE1HKyt4R01VRk1P?=
 =?utf-8?B?SFdjYnRpWkFpL1FLUE9jNm1iNlI1bEFSUDNBV0x5OEw1M3ZXYlk5S0tRRC9x?=
 =?utf-8?B?akd4ZGJwYm1SdWlJbk1ZdSs0VTF4OFJjQ21wR2dXT3JxYk1ST0hoYUx5YTdq?=
 =?utf-8?B?bm9YTzF5Mm1kejRUN21CRkkvSHVLSGtyRE9yQTdBWWR3OU5nVlNJSm50R294?=
 =?utf-8?B?VGl0OUxpOUhqZXMxQzIveURRdUNBVTBSQ1d5Uy9pcVNZSzlPWlVoTEw3K1pv?=
 =?utf-8?B?ZFk1Nlp6U2Q2TjZQcEtEbjI3bkVsaStIekhnVGNKMys5UjlIa1g1dmc4QTZH?=
 =?utf-8?B?aWRRQ2tQOVJVdEpKMytVeEV6OWtmRWNPVmV1bCtZZTJwcWx1QStSUW5UNWJj?=
 =?utf-8?B?b0VsWW41TmlTY2dxZGVLNGtZeG1IeTB3aDZsMi9jeXVVWXNhc0doQktISXVM?=
 =?utf-8?B?VVBVWk80eHVRS3pKYzBJaERDOTJwKzhxSmp3dWR6d29sMHhFWmpUMlBxd25R?=
 =?utf-8?B?a0ZQUmdncmRXNnpXVDZ3YktxYmdjYU5aMy93QmFVZXVWSHVwaUx0N3VZMGpZ?=
 =?utf-8?B?Ky9BWUw0d1dGMzVhSDA4ektsN25ITmQ4WHBqZzU1amFHY255SkM5dVd2STda?=
 =?utf-8?B?RXAzeGVnRkpzaDJsM0lsRXBZU0FXN1VnNkVjUVdrQ0lOR1dSRGord2VzMzFH?=
 =?utf-8?B?UGs1VlBQSUFKWngzSW1NcVdWejUxdytQQ25LME05UUFiVEgvZVJYQzd2NnBq?=
 =?utf-8?B?ckp5NlJQblp1dWNRMjVRbXFoQUFmTzd0TXY0V3lBSFE0RVo1WGtQQW40NG9G?=
 =?utf-8?B?K1JKNWNtNGRWNXl2ZmtSOFlBcDE1dXBUMnc3RXV1K2Uwc0UwSThzUVBwUVEr?=
 =?utf-8?B?R2RjRlZPWDk3UUlGbklmaFZ2bmM2eEJqMXdHdzNuZ1RuRDN3K2tLeVhpeUZw?=
 =?utf-8?B?M1I2OFVoWmw0ektEK0RDbGxNYVdvYkpEWnA5RytNV01meEtwcHhaMzM1d2sw?=
 =?utf-8?B?NXQvNnI0dFlTRXp1akU5Q2k2ZTJGakJQMFdFQmtIQmV1R0hXQTVhY0Z3NjdS?=
 =?utf-8?B?c2pUOVNGS2hpaGFNTFl3N241OWtCNFg3V3RqRW50V0xCaERDV0FTZHJRTDV1?=
 =?utf-8?B?dm55SzFzcFpHVVoyRWNlVGFGRXA5L3NSR0cxdFlsSGcwVHFGeTF1Rk1hbHgv?=
 =?utf-8?B?U254b2ltUUlTUEY1ckkyOVZNWDBvQ2MzNUdhTnZOR2xGN0dMTmd2RGR4Unc5?=
 =?utf-8?B?bnMwam4xZ2JPTnRIc095WVVUclU3dzNlMS9OS21LNlNtRVpKOXRYcVFYYTky?=
 =?utf-8?B?cjg0TnRNcTlNNkZQQk1ENUVReFpuMkRTeXZxU0c2Nm42UkRyY2RFRm9za0xu?=
 =?utf-8?B?TzN1NnU5MmhXd1JvZndzYUJONmxKUkl6cGFoeUw5OVprUElQc2JtUk82M002?=
 =?utf-8?B?dkltWUtOMGdOTWdBYlF1b05SR25CdGF1ZDFWUm0vYTRGZUF3Ykw4TnN6UVdJ?=
 =?utf-8?B?MHp1UURQU21rd3lmcUtGTVQ4ME1wRDZySHMwZEtSUGJXMElDSGVBQ2hsVmY5?=
 =?utf-8?B?SDhhWElkQkdaNG1TWmw0WFdqRTdOZC9iUmNIV0U0cm5wSzQ0ajMvL1FCZWls?=
 =?utf-8?B?UmtkVWxrTFl5MEpLWDN5K1NuZHdob2xpUmVSK0xSY3RmRE1GU0RsNkhxNmdo?=
 =?utf-8?B?V1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <92E2E18A89EDB04F8C3EB3070F82A59E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ca73bac-aa60-488e-6398-08dd14be8ea7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2024 23:51:22.6075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9dTFfASGxSok3i5SdnA56dWek2ezNSX8uLEfkRo5+elisfK9HdR3svREAag1bmC8Mn/ligweJLZoaWagLZbpm5rKGHxfkrM97LJseaeNkQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7098
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTEyLTA0IGF0IDIzOjMzICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
IA0KPiANCj4gVGhlcmUgd2VyZSBkaXNjdXNzaW9uWzFdIG9uIHdoZXRoZXIgS1ZNIHRvIGdhdGVr
ZWVwIHRoZSANCj4gY29uZmlndXJhYmxlL3N1cHBvcnRlZCBDUFVJRHMgZm9yIFREWC4gSSBzdGFu
ZCBieSBTZWFuIHRoYXQgS1ZNIG5lZWRzIHRvIA0KPiBkbyBzby4NCj4gDQo+IFJlZ2FyZGluZyBL
Vk0gb3B0IGluIHRoZSBuZXcgZmVhdHVyZSwgS1ZNIGdhdGVrZWVwcyB0aGUgQ1BVSUQgYml0IHRo
YXQgDQo+IGNhbiBiZSBzZXQgYnkgdXNlcnNwYWNlIGlzIGV4YWN0bHkgdGhlIGJlaGF2aW9yIG9m
IG9wdC1pbi4gaS5lLiwgZm9yIGEgDQo+IGdpdmVuIEtWTSwgaXQgb25seSBhbGxvd3MgYSBDUFVJ
RCBzZXQge1N9IHRvIGJlIGNvbmZpZ3VyZWQgYnkgdXNlcnNwYWNlLCANCj4gaWYgbmV3IFREWCBt
b2R1bGUgc3VwcG9ydHMgbmV3IGZlYXR1cmUgWCwgaXQgbmVlZHMgS1ZNIHRvIG9wdC1pbiBYIGJ5
IA0KPiBhZGRpbmcgWCB0byB7U30gc28gdGhhdCBYIGlzIGFsbG93ZWQgdG8gYmUgY29uZmlndXJl
ZCBieSB1c2Vyc3BhY2UuDQo+IA0KPiBCZXNpZGVzLCBJIGZpbmQgY3VycmVudCBpbnRlcmZhY2Ug
YmV0d2VlbiBLVk0gYW5kIHVzZXJzcGFjZSBsYWNrcyB0aGUgDQo+IGFiaWxpdHkgdG8gdGVsbCB1
c2Vyc3BhY2Ugd2hhdCBiaXRzIGFyZSBub3Qgc3VwcG9ydGVkIGJ5IEtWTS4gDQo+IEtWTV9URFhf
Q0FQQUJJTElUSUVTLmNwdWlkIGRvZXNuJ3Qgd29yayBiZWNhdXNlIGl0IHJlcHJlc2VudHMgdGhl
IA0KPiBjb25maWd1cmFibGUgQ1BVSURzLCBub3Qgc3VwcG9ydGVkIENQVUlEcyAoSSB0aGluayB3
ZSBtaWdodCByZW5hbWUgaXQgdG8gDQo+IGNvbmZpZ3VyYWJsZV9jcHVpZCB0byBiZXR0ZXIgcmVm
bGVjdCBpdHMgbWVhbmluZykuIFNvIHVzZXJzcGFjZSBoYXMgdG8gDQo+IGhhcmRjb2RlIHRoYXQg
VFNYIGFuZCBXQUlUUEtHIGlzIG5vdCBzdXBwb3J0IGl0c2VsZi4NCj4gDQo+IFsxXSBodHRwczov
L2xvcmUua2VybmVsLm9yZy9hbGwvWnVNMTJFRmJPWG1wSEhWUUBnb29nbGUuY29tLw0KDQpJIG1l
YW4sIHRoaXMgaXMga2luZCBvZiBhIGdvb2QgZXhhbXBsZSBmb3Igd2h5IHdlIG1pZ2h0IHdhbnQg
dG8gZ28gYmFjayB0bw0KZmlsdGVyaW5nIENQVUlEIGJpdHMuIEl0IGtpbmQgb2YgZGVwZW5kcyBv
biBob3cgS1ZNIHdhbnRzIHRvIHRyZWF0IHRoZSBURFgNCm1vZHVsZS4gSG9zdGlsZSBsaWtlIHVz
ZXJzcGFjZSwgb3IgbW9yZSB0cnVzdGluZy4gS1ZNIG1haW50YWluaW5nIGNvZGUgdG8gbGV0DQp0
aGUgVERYIG1vZHVsZSBldm9sdmUgdW5zYWZlbHkgd291bGQgYmUgdW5mb3J0dW5hdGUgdGhvdWdo
Lg0KDQpJZiB3ZSBrZWVwIHRoZSBjdXJyZW50IGFwcHJvYWNoLCBpdCBwcm9iYWJseSB3b3VsZCBi
ZSBlZHVjYXRpb25hbCB0byBoaWdobGlnaHQNCnRoaXMgZXhhbXBsZSB0byB0aGUgVERYIG1vZHVs
ZSB0ZWFtLiAiRG9uJ3QgZG8gdGhpcyBvciB5b3Ugd2lsbCBoYXZlIGEgYnVnIG9uDQp5b3VyIHNp
ZGUiLg0K

