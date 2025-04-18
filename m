Return-Path: <kvm+bounces-43684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D1578A93F40
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 22:55:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A78A7AF5C6
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 20:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE4A23F40C;
	Fri, 18 Apr 2025 20:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nM4Gs4Iy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8494C2868B;
	Fri, 18 Apr 2025 20:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745009695; cv=fail; b=JTF1EvV8CTBANB3Am+2QK7BfZxemcwgfN7Gw651dv9B3cLazwQugoFYv/h+bqoIv7xyl5oL6xupj6b96B1q8SFXUjRiRaxnseyX1MekRJN1W4F5919AYguQq/zC4/q7De6vRZx70KrHCUctEs50A22/LJMyZ0AAjehWphNSoKg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745009695; c=relaxed/simple;
	bh=eC+srkMdornub3EOngAGdQ6QS1dlICo2MhWw/pRtzUo=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gdtEWyXzy3Tt3eUuJDoFpfcYKo8RztiBbHbGqUyIH7pEUo3ORw3jQL8x098oLwKj+H08Eskpkm70pK24JHG1mywnSf+EYMYFv5KYTO9JdyOmebPgS5ge8tmY4qSTg4fW0/0QfN7i+vCNs81h1kMQGUx//sLA4TKP3fU0HOOCBWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nM4Gs4Iy; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745009693; x=1776545693;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eC+srkMdornub3EOngAGdQ6QS1dlICo2MhWw/pRtzUo=;
  b=nM4Gs4Iyg18QUVM/vsfvgG/YY2NueqvmXJrIkoAFN/L+twmV8yizs0wO
   ry8dfHK7KZdbISzI+nkg6DFq5fWz0zQIYJ//k3bbg0/vPVkKMvwmD3Rzh
   f/UoT4Wwq67YiTqaxYoo/hY5q8VvCjV92QmhDXZmyTFhFbBrDk5EsqJvL
   XgC5utjc2Xvzof1M33NYNdumhZTnR0cq7QzpXJRf7dCTj/zLdg/SnEkGb
   G6ZrduZTcPlkat41atIHYbUSBzV6mNLSf5XzUhX9qWRdC3xXRk0LLDbBG
   lqsbEj0x16EkAeSQiRlc2Adai/Lr9vlhXVN75qi3HkZKteqlJHgZ7X7g9
   w==;
X-CSE-ConnectionGUID: OLKH8HlhTnaB/stLmrvd2Q==
X-CSE-MsgGUID: kGaM822bRyG2Zov/NgDDBw==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="46650716"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="46650716"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 13:54:52 -0700
X-CSE-ConnectionGUID: +v+12+7BTmGC4mgXGlm4hg==
X-CSE-MsgGUID: AvYxRf77Rxq1PORdC+/s1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="131501911"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 13:54:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 13:54:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 13:54:51 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 13:54:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PaLGGiCY/ToCGqfnleRvUEzeJPwxr9cQMCCx3Gw7iY/M8ZSmCkee0S4NyBusNfKB1vFnSV1DPqEnlYpzNlX8pQIsj4WqY8WPthtxZAUHAj2WVvDrj2tDoB7Cv9zXmJiR9NusWaLCGw41BWcSy1WC6DoYInvJgz9PaR9qMJQRp6cCikZvU6ZcpzRj8o/4yjgcJM2ws4Y+NH8XO7MbZOwvLI+5zXD4pm6cik7J4PlUcjGzxl9cSELs6f34tsyYaKYomtafR4/PTa+9XV9Pz462BHnRkjNFhpz8b0H4Kf+ES4psm5NIrpA4dGPZRrMtL0Q1Go6EGqjzDFLl5SfCQ0qsWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDpLaro4/qvZGrD1d5fm0V+A/AS31u7vipxNs6WUsR4=;
 b=d5h0JGWXm+th34R5/HXu98uH1LPHrF0T1xBnPVp9AfmxPJ3sVKMt03EIHNAySt9kALmluvnJmhOTbAVuzcCx7iyGYSPZMmvqzJNqPqphyBn8f//06/rzEVC4SbyjqWDixJp4TPNG9poh1Qqk7M+x/AeBBPyrBs2Qm2Ozsb2hbHbT4CfoSdT9eEqQ+AwxT2u63iEXsjiau3b/VpChG0PAv1YTVkbc1gHqchrRyFqmSA30oAGGu8WALBmAKv8gHIX8KfzcNYRzKubXAssaeiV3iHgOkSM8a1IT+FRvyXitDWnjmMX67Hw2Sem58d7/1IAqKn3D3nz6bQXo5PvYD87pnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 PH7PR11MB7569.namprd11.prod.outlook.com (2603:10b6:510:273::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.22; Fri, 18 Apr 2025 20:54:08 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%4]) with mapi id 15.20.8655.022; Fri, 18 Apr 2025
 20:54:08 +0000
Message-ID: <6be7de70-c6d7-41d8-8c68-ece3c3930425@intel.com>
Date: Fri, 18 Apr 2025 13:54:05 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/7] x86/fpu: Drop @perm from guest pseudo FPU
 container
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: Chao Gao <chao.gao@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <tglx@linutronix.de>,
	<dave.hansen@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, Ingo Molnar
	<mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Samuel Holland <samuel.holland@sifive.com>, "Mitchell
 Levy" <levymitchell0@gmail.com>, Stanislav Spassov <stanspas@amazon.de>,
	"Eric Biggers" <ebiggers@google.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
 <20250410072605.2358393-3-chao.gao@intel.com>
 <cd14e94f-dbf8-4a2b-9e92-66dd23a3940b@intel.com>
Content-Language: en-US
In-Reply-To: <cd14e94f-dbf8-4a2b-9e92-66dd23a3940b@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::31) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|PH7PR11MB7569:EE_
X-MS-Office365-Filtering-Correlation-Id: da425881-44c4-4538-6f32-08dd7ebb29bd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bDd1WG4yUU41Z0tBOWM3eVJ2bGRJOEo2YW1ZS0VoaVpyWWM3aWw1USsvK0R3?=
 =?utf-8?B?SEdMVERubEppZ1F1RzhSTU85dTJxTzJLaWQyYUVHVGRPQjlFVExGODVCTGdV?=
 =?utf-8?B?R3Y5WXlXQVNkVmQ2S1FKU1NDNWJEUDlJZWxQZUtKMGxMVzhzSXhMVnlYMng2?=
 =?utf-8?B?RUprZSsrZ3NsWHVJeFF3NDVhSjJiQTJBQ1JhM1VFdjRpclNtRmJiOEM5QmJM?=
 =?utf-8?B?LzVSMkIxNmNOeCtOTWZUQWlBa1ZHME03VVBzbjJqNVlMRW1Ganc5UVMxNEMy?=
 =?utf-8?B?VEtZZWpWZ1ZkNVZSdEh3eFlGSWpoMHNkNnlKZndoTmYxSlNMa3NEM1RBTmRQ?=
 =?utf-8?B?ZlpGWTErVEgrdVBLeWRkNkwvL3g2UzhjWm0yTzNEaFZIcUV4ZmFoK3VPN0F0?=
 =?utf-8?B?NW5IcitteUZFTFVWYzdoYnIvT0ZKeUxDWEY0VWxiKzh2Uzd6ell2YUdjRVNT?=
 =?utf-8?B?WE40RFQrOUxRMEM4UnVjd0M1R2RBY0JXUVlxZWFMUjFpOSs1Tm1zQXdPUlhB?=
 =?utf-8?B?RllsNWF1WjU4YWN5bElCMGRkUGlwaGpQQTJlWS9zbVhHZFpYOFY4OXAyeEF5?=
 =?utf-8?B?aHJLMFhjU09mOGlpc2ZLQStGV08rRTdSS3ZwRkJWRFhqMnEza3didFZKL2pT?=
 =?utf-8?B?WUg2TG5FWUM1c0Q4bmpkaUlQSjZ4WHEvUFBiZkJnRXhtSU9LSnVieGp0OFVR?=
 =?utf-8?B?MlE1QmZiUXZIa3hKTWcwUzhTbm5oc0JuMU8vT3NIaFZmVVZFcVpvNDBtOFpl?=
 =?utf-8?B?NGFLUTluOXg1WXpvZml2MHJEUlhwWVo4ejQvVVJJWHpLK3JwQ1c4SS9hT24w?=
 =?utf-8?B?OGJmUTgyeHJnWGRhcDNEckNqV1JuTlBnNlF5SVI5WU9aOXpWNFhZbHpleGxq?=
 =?utf-8?B?OW9mMXpjTmR3QWtnTHdYcElVZ0poUTd6R3VqZzMzQ1kwakRVWjZxdEJQWS9L?=
 =?utf-8?B?dWlXU28zeUhwZzFOeE5XL3I0cmtQSXVmYVRVQ2lzZ1BKR0x5WkwycFNXc0hE?=
 =?utf-8?B?Y0hyUzBPZmNEbnZoRDdqSDIyYjhFREc2S1ludG9BZmpjUEtzeHoreFlwbllZ?=
 =?utf-8?B?YmJZeS83Z2daWGpkZmtTdGVTdGxMSkZ3M0k5bngrQUJJMHBldEY5M0lyMEQr?=
 =?utf-8?B?YUZYekxrSWFvZG91VHdJZ1QxY3JFQjZURUNIejY0VnBjcFlFU3pkWU00dnBN?=
 =?utf-8?B?RWs0aWprbFNwK2UraEJpeUxMR1Z4N25CakhlaWR0ZnB0K1l3aTVNODA5STVj?=
 =?utf-8?B?RjZjNkNTT2t1Vkw5WHNlZjdKSk8xM3dUUUVSK3ZyMjUwOUlXaGUrc1RJMWh6?=
 =?utf-8?B?VTNxRXAxdmpnL21aZUduMTE5SFJ1MjM3K1Zzb0tJMHJGTW55UnJINjRXd3Zv?=
 =?utf-8?B?enM2Wk1IYUFhN3lkUW1iNGlJdFR2bFZyQmxXTkpVN0lmUFR6Y1ZmQ0prT0hG?=
 =?utf-8?B?M2JrWlMwV1JHbUxNelVYaGZlZUxTL2JQMmU5K1RTWkZkczBhbStIV0Z0YmdM?=
 =?utf-8?B?OGV4RExTU2FPZ0pybVc5MldxOUZIOCtVMzFvUU13YlliVXFTaVBxRllEdGw0?=
 =?utf-8?B?cVBFY2pDMUVuVUJHOTgxS1BwMkRhbjcvSGEwazhGaU15ZEJLYlBnenpJU2l5?=
 =?utf-8?B?VjFNRS9Lc2JwMEFUUUZJZmF2RjdQcnpzL3JHWXFvSWw0WmJsUnNET2c5WCtN?=
 =?utf-8?B?VGR3ZzlnTWhsWmVEZEFRTUg3bTZLQTRvTjRKZ1ZlTGRWOHJwLy9GZ1Vac1BP?=
 =?utf-8?B?M1VQUE5wUXd1M21BSVkvR0NNRWFmUzZXZTFEODA4ZXUxWGJvSlVKNmVWUUNC?=
 =?utf-8?B?MHhWQzRvU1hwUmF5R3MrVDlVSlFneFJxMVRYeWlVU2VGSDdsMWMvejBHOGRB?=
 =?utf-8?B?bVcvZXAxT0kzU284K0JVaEpNQjZoRkhpRjBZYUg4UStFbTVTWUtvb2MzOEJj?=
 =?utf-8?Q?WCIIxVnoGtY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkE0eEVtQXJTNHJOUlRjV0ErblVkWjAxMWdHaW1DWUg5bXJGL0YxQVl2NjV5?=
 =?utf-8?B?TDVkNWdqNWVMcVY4eHFpdzcyRGx4R21WK0NPQ0tjbDc1K0VWVE16T1pzemlB?=
 =?utf-8?B?K3BaYWQ1RjhQRUg1QVppRlYvVmF2OTZBWC9WU1pVQ1l6eDF3L3hLMFdPNUJF?=
 =?utf-8?B?NU5CcGVkNHpWL2FBbjgrRzNrZVV2N0NjWWIxcCtqTWR5YWRrMUY2WmFGNmJC?=
 =?utf-8?B?eU0vRytpMWVkZ2N6SGU0bkhWTit0K3JUM3FtSXdhVWgrOU1WY08yaFBpSkFC?=
 =?utf-8?B?SWNWWEVxclRsQVBkdzlZVlJvRFd4dGNUQm12ZWlEanFFSlUzVnFURFh3L2dI?=
 =?utf-8?B?Tk84TTIzaTRoNzc5cENycWtENGhPWVZacmo5NXMyUjdiQ2ttelAweGx1OFNr?=
 =?utf-8?B?U3lETzF0S0xyb2lzSWIyMzBkVGsvSGtQTzlwQk9ydURZaXp5M2JBcTVmbXBy?=
 =?utf-8?B?eXQ0RU9WZElkU2x0WW5qTnZ4ME9NTitFelU1RU5GZGU4UzhwZ09Ucy9abDZT?=
 =?utf-8?B?ckVaT2VUZEtmRDRtY2pCRlA0Q00rN1B2emx5V0xiSndRaXZyUGg3UGNHelk5?=
 =?utf-8?B?d2QvbkJxd0huSTNSQXNXTmh4dVpoc0pMSEJiZG5tbUlqMVVwM0FkVjdENmE4?=
 =?utf-8?B?bkZ4bnhlYmNjelJxNXp1Z2dYU1RReVd0MjV2NnBrbTlOUkR6cXZ5dHErVG9j?=
 =?utf-8?B?YUVZUk1FU3RibHhlQTVBOHJjOHMySmM2RWN3QnFsODgvVWVnbUtRdVFKVGpu?=
 =?utf-8?B?SkVmQkV6YXlDZEtTRmw0WHFtMzlxbzhGNWlybzA1SEZvZDdmL3ViWDNIMlB1?=
 =?utf-8?B?U1NieUFEM2hWM2FEdGFGVEp4anN3a0o3OEphWllyKzVydENXdkhNRTZTTnNK?=
 =?utf-8?B?SnpXU25tbEtVM3cvUnlqMFJsWGdVcmNNVnliWkVpOXFmYytpS3dtTUNJeHlG?=
 =?utf-8?B?WnBQbk1DVnVTL09sWExlSWxBSTNRYWk4bGlsNzJyaFFFd1ptU2dhRCtTd2RN?=
 =?utf-8?B?L2xndkJCZHh1eTY3WWoxMXBoOVJwNk1KeWJwVEdScWFXWjNKbGRRUWEzWno2?=
 =?utf-8?B?Nm9kSUhzK05HZEd6TUhyN3dpTlZHblovdDBiVXhaajhPbUl2Vnh5RmI0UDVU?=
 =?utf-8?B?ZXRlWmRQbTh1QVc1YnlGRHAwSXluTWh4ZjFvRVpLTTJxcGlvSTNTZkNFTnRC?=
 =?utf-8?B?UmpiTDYva244Q3ovUGZSTUl1a3dGR2VxWU0ydHdmeEF1NnkxSzFKSU5oVlhH?=
 =?utf-8?B?Ykw4VTZTRTJWdkorYWVGUlE0bjNuTHNmM283K2tHSUZ5Nk9vNDVQYVY3em1r?=
 =?utf-8?B?YjBBQ0NEcjUvLzEzbUZUU3A4RS83WEtZbGw4WW1ieE9JNkREZGwrd3gxRHZT?=
 =?utf-8?B?Y0phKzRLaXFqTk40VWp6SG1qRHJxdW1WbjBja01ycENXNS8rSUdDNnE1TFky?=
 =?utf-8?B?MnJ6bUFxZkd1aTZVNXBxRHg0R09oc0dOQXowQlNWSzVGT05HL2NVQU9vQ0dK?=
 =?utf-8?B?STZRNUY5cEJvQkJrRlZuNmZGVXZpb004V3FhaUp5VGhaSExMV3RQMnhTTlNm?=
 =?utf-8?B?SEFITmE3RTJGYmdha3hwZnZKYWhBQ3ZGWjJGa05DRTdBY0tZbVhURDVGbnk0?=
 =?utf-8?B?YjdWNE1WS3M0M0V5OHZ3ODZPcThaOFdnSTVqWithcjhaMjJyOUNzMDdZT2ZB?=
 =?utf-8?B?T09BRHdkSVpUaGVvVUtKR0xLQ0lkYk1nd2ttVXBQL2IwL0l4dzlpN0JLQ3RH?=
 =?utf-8?B?T0xjR244ZVlRVVZ2clFKbkFvMDFyaHNreVRVT29LTjg2anV2Ryt6ak9jajB1?=
 =?utf-8?B?MXZqdGRQRE5mTkRPV1JrUjhSN3VySWlVb2dNVDQwNVVPQThGZWU5ZWFMTmVL?=
 =?utf-8?B?dTVIWTUrOUJCNUpoMjl5S0t6TWtsK21nZnlsVGtWc1JlK3BiTDJNdlhsdTY4?=
 =?utf-8?B?NndYa1c1Tm5FakFoMlY1YzBEQVM4dTdCT09NbFZnRDBVcWwyNjVYN0wyejVV?=
 =?utf-8?B?UEpycFo3c2dVWWFDQmU0bVRnNlZmb0V6VjNUamswQTdKaVRHbjg0Z2hrelZE?=
 =?utf-8?B?WGJmUTlyRG1kaTI0ZDg4UFVwYlVQY1YvQ1pBY0I3VVdZQzU3SHpFT2N1UzBk?=
 =?utf-8?B?WklucXVhcERQcDFJcTB3R3E4b2wvVCs1TzJUbU1kK0w4VC84YU8wTG1CU3RI?=
 =?utf-8?B?U1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da425881-44c4-4538-6f32-08dd7ebb29bd
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 20:54:08.2364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7bWqTZEpGUKiEZ4z7uv5lL+MMdut8mwD4zdExGOAneU9YNWCs+ikOFsoM1lU6eGGiNzwE1PWlGaIFeNph8dHYd6Uvno3LIsDK6+7Roll1yQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7569
X-OriginatorOrg: intel.com

On 4/18/2025 1:51 PM, Chang S. Bae wrote:
>      if (xstate_get_guest_group_perm() & FPU_GUEST_PERM_LOCKED)
>          fpu_lock_guest_permissions();

Sorry, this should be:

     if (!(xstate_get_guest_group_perm() & FPU_GUEST_PERM_LOCKED))
         fpu_lock_guest_permissions();

