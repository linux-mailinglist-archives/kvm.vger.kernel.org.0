Return-Path: <kvm+bounces-33470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 054919EC191
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 02:35:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A59A2188B586
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 01:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54ADE17C7CE;
	Wed, 11 Dec 2024 01:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ie3tQo5e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE871442F2;
	Wed, 11 Dec 2024 01:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733880821; cv=fail; b=ESYDU4c//pB3506M4LYb+EPxbWYiK1/vXgc2vZtaikRGUoP3DtfE4w01XUrTpuFsI5dDe0mzQqBVapEDR0R6z9ut1i/1BQxLUzpy79I0LBKhwWPNAaqoob8JT2iTR3gX7IUUGtLG21cLnuMY/AnbjJDcUbl09m0tmm05oXkileg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733880821; c=relaxed/simple;
	bh=e22dWp3iG5l+4M84CzB1HPT0Qnr3J2F7/ZiILoU1Xso=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=popH/CvgXwy575Ge7J+M4sGfvSw5X/Q1t0a+TTP/k/OgFZ2AfjGEzGxDLujWI2rJo4fQEue4s52sUmT3zMHQfJRrL73w4BRW1QPydLIQyqrx1xXIFfuaKd2BXgUzzByO0qZODD6TXJe/qSBqnbQPfNQqqWKmbeHZ6AbSXIOMM84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ie3tQo5e; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733880820; x=1765416820;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=e22dWp3iG5l+4M84CzB1HPT0Qnr3J2F7/ZiILoU1Xso=;
  b=Ie3tQo5efZGf5/LXaDIwfgXvg29iacawvTu74ZUJ26rysJf3FrwFsPce
   g98vVjvEjWtuNg4dY6b5VwmuBcYxplYKXLQWVPtbQHFp9kzBMeruUEgIU
   EcC+nCr4YYFnszfkt+W2mY9SUD1idaGBkTjgGrVGxPkk66v+KDVTOhhQX
   lcx029CT3GWtcALvqwOsY1lecHD3ma1GT2Aw/nLqnzBAYVqrM4j6kjXTX
   ogfaOpV9d297XFf1w3wx/WObA6L9ND6Q4oRkRVOA2IKg34cVU04lpV1Zo
   1LagnZD5gPMaWLnieu9bE6f8I3s+Zms7YlASS1uYcPlvu7QNeU5dkuyet
   g==;
X-CSE-ConnectionGUID: zY0oogU/Qxq7EMKMNLAU2Q==
X-CSE-MsgGUID: vVEDoZKURzaQD679GXJK/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="38029670"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="38029670"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 17:33:39 -0800
X-CSE-ConnectionGUID: XyIJMg7aRjyLnSsugmSwPw==
X-CSE-MsgGUID: 8tSwO63ZTLu/0jT7re/GIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="95801184"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Dec 2024 17:33:39 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Dec 2024 17:33:38 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Dec 2024 17:33:38 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Dec 2024 17:33:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IgD5JQKMw5B/eRTC1XsFG7GqftU9IkAWjNKVPMjoB/x8Q9W6UxdXyNCwx7IWrzR+SM36vQH71Tu0DjTbSkMiVLuN1rgxtmNQJMDLsuhO62G0G0ueAFpvRgogJzVGZ+1kY9B/IB9tS8/bGpLvmgl3ef0yPacE6IPChaQ/golbL0eyGvvUUGavyMvzAkYQP3bF5yHBz4z0NFWkP7EmJpm/9hqdr0AqVoPVOoW58VmjqK273CKdIPa3RO3qaJMxzqFLuE/q34TQYzXaWu7pX8521y29RbfqIQ5NWri4yaIczFsXHy4rwiZplgaFqhRZ9dlJwd2PlVjkQwmTOIYeuUpsKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e22dWp3iG5l+4M84CzB1HPT0Qnr3J2F7/ZiILoU1Xso=;
 b=GpHA3xNgsoQV8DeFQBtzr9yx0qQ6ubglX9O3Wl0EhfTiaVjqC+3+HpvL1DJwac+0jW/PNMzwSFo5T70VMAKx9boDnsEatyr5AU7+g/tMOy1D/zyRL/KcrfE49wDHPa7VJnpjPsmogSs5SzQoreVOA2qazI2lISv9kiI8aAjcqRCWsU7bpea9F2Y8IjeIqpG+zsm2VJ9yg4Y4XZ0vNbXxTa6o2+2SY96mTXM6c0BL5MmsSakzDxcARwckLvn4++Xq7h4jr+QlsiBihAhmPCB0f3MQ39WnCxjshNdfXX3f35HOoqAuIy9IS4RUdk6Xvq/KKLr5D46X1NQ0reHc/1aB0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB8081.namprd11.prod.outlook.com (2603:10b6:8:15c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Wed, 11 Dec
 2024 01:33:30 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8230.016; Wed, 11 Dec 2024
 01:33:30 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"yuan.yao@intel.com" <yuan.yao@intel.com>
Subject: Re: [RFC PATCH v2 4/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 page cache management
Thread-Topic: [RFC PATCH v2 4/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 page cache management
Thread-Index: AQHbRR8+17oG8mcgq0iuEnd+G9S1WbLgTHaAgAACqIA=
Date: Wed, 11 Dec 2024 01:33:30 +0000
Message-ID: <c5c30ac58b3b9ac84ec2b4e77c25a56763e80aa9.camel@intel.com>
References: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
	 <20241203010317.827803-5-rick.p.edgecombe@intel.com>
	 <Z1jpr7baxGJDj7Ur@yzhao56-desk.sh.intel.com>
In-Reply-To: <Z1jpr7baxGJDj7Ur@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB8081:EE_
x-ms-office365-filtering-correlation-id: 3be0b9d4-a64a-4d99-6150-08dd1983d190
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZjkrU0d1bFIyNlBsaFc3bkR2b2hpNzR2bXE1RVZITHpyNHJ5dEk1ZGI1M0lG?=
 =?utf-8?B?bFZUZnpNV1BrV0k3MWhoK2RibUdpdzhvSkdCVFh4WHFqcEJJYlRkMlYwKzVF?=
 =?utf-8?B?U1hybDhsMXducXhsZGZJNGFwUkI3MkV3VGw0eVpEdXkyQUpSR25LRnhJVzUw?=
 =?utf-8?B?dE1JRkNwdnlkeGcvczNwaU1zMXR2ak83MzRGa1NvL3gySVV4aWo5UENyb0xv?=
 =?utf-8?B?bWE1VTgxTkJMYW5UejBWUDNpMHBXYnZCbnROK3E3TmFJd0hKeG0xTGh6b0xk?=
 =?utf-8?B?UExlRk8wQWhIaWNodGtSeWxiQStNWGlyT3drMG5jazZjdFpueTV5TE1qY00x?=
 =?utf-8?B?eTJ5d1JlZEZDeGpIM045aHNDV3lTOHRHUjBUNmRkY293WW1mNzBCcllKTkhp?=
 =?utf-8?B?TmRaS3FhTjVLNDNqaEZQNElnSTltZTYwUncyQ1NjL25RT1U3ZjU4c1RPTUtl?=
 =?utf-8?B?TXpwK2dYNzEwS1RyMjJwbG1USjlRU1RQU2lHM1UwVE05SXlFenQ2WlQ5YStw?=
 =?utf-8?B?WUM2M3QyZTdERGFOeHVEL0MrMFJ6VWFCQ09ycTNPQlhpeGlqVjVWZG52OFd0?=
 =?utf-8?B?NGdvMjZIM2lGNi9NeVpoOXh3ZFVzUFl4bHBrUzNCTTk2d0oyUnNGRnhqU1BC?=
 =?utf-8?B?U0hBdWM2dnBPS3pONDhvTVBhSTBVV0h6Mi9sT3N2dlQwVllpWGxWUHN0VWZU?=
 =?utf-8?B?RkFvdHpUOHN1ZitaSVZZdkJJNC81d3JXNEVxMi83VFBMM2lwOFRzTHZVWUx4?=
 =?utf-8?B?RnpJOFZsNjVGRStNNlozUmw5bkdlK2YwT2RsZE95YTMremJOcHJBQXhzNFl0?=
 =?utf-8?B?ZkdNWUw4T0tPZjdUdkJkOTQ5WW5VUnVZbDZhYUpxN1ArVHRjUmUrWjFaNzVG?=
 =?utf-8?B?ajVuamxKQVZkYVgyVUcwcElMcjFHdEtqY0tSZm5OMzh5N0k5cHJ2dU5Pc2pj?=
 =?utf-8?B?V0FML2tXdVJkdCtGc0tPU3BXR1VXam1BdWR0Sm8vZDFNZ3pRTnZySkt2YzQ1?=
 =?utf-8?B?NjBRdGhKcVBpZ0xRbTViWFAweTdqNWEzOHUxbnpHNVBZVU94b0ErQ254aFp4?=
 =?utf-8?B?RHY4M09wUW1kdjJBM25sVXN1aXQxUE9lWmZCYUIvSlF5eFJER3V0aFltNHdI?=
 =?utf-8?B?TEJLMDB1RGk0eUQvVW1kL2lKYk40dFZpUjBvdkJveWRFZUVlRHk5S1NlejNE?=
 =?utf-8?B?cEo2cFVXSTlsR2I5VDgxT2FUVEpaMTZtbUplRWhPa0pWVEhLTVdsNC9qcHYz?=
 =?utf-8?B?Z1Z2OUczeGYySUVCaXhTK2JjcTUzVUpDWWkvM3lDZFpoSS9DSGY2dk5yUDlr?=
 =?utf-8?B?bGlidUNnY0YwdEtScmNJc0E3YzY1RlZlMnk2dmRJZndMcmMvbWFRNkVOMEk3?=
 =?utf-8?B?cHZwNzFqRlVzd3MrRjFZaTV1cHlNRENTYk9EN2I1WWJqclVMWXkya3VhNnNJ?=
 =?utf-8?B?VDJSNWhoY1pRd2ZwY3JWd08rQXhjc1dJa2VtbG9aTjU5bjJNVzljQ2doZ3lh?=
 =?utf-8?B?V3dYMC80TGN6RE1NcFpGb3ZHQnJkZk8vMm1wdk5rSloxajJVMFNuY1RtbHNn?=
 =?utf-8?B?SHNZYlZIYm82OW5nQ2xtZi9XaUMvY1pyejR0WDFESjQ0VzI0TXdRMDVpZSsw?=
 =?utf-8?B?VE1NVXJyWFpBQnBoV0FJaDBoYlFFc25TN0NXek9aczRBRkpaOWRMMVpNKytj?=
 =?utf-8?B?eitHV0JqN0F5anY4RytST1RBZi9yL2dqYWJ1TDFQYk9lcGJkQVlndEEvbUZi?=
 =?utf-8?B?ZHhSNFVNWU9VNjlZc1VzZENtUUNKM25NczdjeXUrS3hXakZhZU96M3A1Z0tr?=
 =?utf-8?B?TWdKRDBaeTI4L0tPS2h0Q3R0R1ZsVktUbWVUcjRmQnNjcDVWdWg3NElDejdC?=
 =?utf-8?B?ZnQ0VHplTmFyb2c0MDdJYlRFWkV1V1h2RGdTdXlNV0k4UlE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEVrMmJKMGp3bUEyeFdxdlp3THQyS3hyOVUwQXVPVHZIWVlNQUw0eDlnOFp3?=
 =?utf-8?B?b292VzMzbWhHNytVb3kzQVBCNTFaTlhZL1RlN04xSWZoMTg4MGNKSi9rTEx6?=
 =?utf-8?B?WUJGRVdBRWl4K2dsSUo4UjErNWx1WXd1dGtWQjdpOUhNSmoyQmcxTFFRenpS?=
 =?utf-8?B?cit5K0JCTzN2SXJaT0xkQ2xGVzNzeFNkbkVVU2Vjd1B1RHova0w4S09MQWRq?=
 =?utf-8?B?SUxIWlhiK20yclcyeXkzcjhRQldYVE45MXg0am05QUFBQmdrcWV1eHA1aDln?=
 =?utf-8?B?bnBOTk1TY1pQOTJCbm5iVXBxU2hnb0lXcGg2ODZWUjdVbUtPdzBnOTdpcDcr?=
 =?utf-8?B?bC9QdGFpV3pGVjRBTlMvY0pGS0hub1UycEY4SEdwQUtFSExSZVFLZVIva2pp?=
 =?utf-8?B?RVlNV0JwNkZ4aVp2cXJ4QjFJT0xXWVFmcTV4Vjh5M05UcHoyQ2VKMnBiVWhH?=
 =?utf-8?B?WC94a0RxVXE0amd6bTRnVG9mQ0xZeEs3YzJBRkFmS2k2a1ltTEEyMFVxdEMw?=
 =?utf-8?B?VkFpSWE3Q0ZMZzV2SitmcmZNSUYvTXRYRzFocWs1WVV6eENaNjFnY1cycTZJ?=
 =?utf-8?B?ZXhNTVREVVY0RzR0UDFNeFM4V3UyR09QVkthbHhBODNMZDVUc3BSczZHenVX?=
 =?utf-8?B?S0ZTTWtDR1lTWktEY2xsdzZSZTFwQzg2NnB0S3lpSnR0Wjgxek9ZamtnekJS?=
 =?utf-8?B?MERXTUFVek9aU0ZvZWJGZWFMTm11OUV1UUhZT1dVQW5MR1RpVy9lNVVibS9V?=
 =?utf-8?B?cnZ4dlExUERMNTFJOGdvV2graVdLNjFtZW1CZlBIdklvNEsrMEdiZElwcDU1?=
 =?utf-8?B?ZWdxVC9MYU1aNUZtcU0yb3JncGVTN1pyQ25pZWsxbTFZSHlrTy9mVE4yQUxa?=
 =?utf-8?B?a3FObjI0OVFrWWFGS2JQbVpBNDZEUWJGVGdYVWpsZDZQbVZaTVh5b042TmV5?=
 =?utf-8?B?LzRqS0NaN3A4L1pSOTlUUFF1MjYrTERFSmdqamNIWGpSWFFSbmgxY1BkK2RM?=
 =?utf-8?B?L2wzZGNNL0VLRk5tUlQ2bGhZS0hCMVJYY3NtRWhFcnd6Y2ZKdmZCVFpXVEZp?=
 =?utf-8?B?NkdJZWtSSE1nRkRrdXJKNFFmNUVEQUFTMzFHdG5iNTcxeStaK3diMUZ1VlFo?=
 =?utf-8?B?NlJpMDV1akNqajI1TmZqOWtSaGpDQjdsNDhzb09SN251a3luZlBPM1BHS3Fz?=
 =?utf-8?B?MWIrbjZzS3doV0ZsQTJFdVdhUHdZS2lOaHZMem9zR3B5NUtwRVQyRnNxeStq?=
 =?utf-8?B?WlVJS1VWMTRBMlZGZWc5K3lsWXB3ak42UE5icUhCKzdBRXEwRzRHaHNQcEJZ?=
 =?utf-8?B?NUZSRkYzd1VCb25LWktMclA3eDRyQ0hiS2dsMFhCaldWaFJoNXJ2cXFrMitN?=
 =?utf-8?B?bXlYT1VQKzFPMFkvL3Z6L29nNFF3bnlXZkVZWDNKYVVuTng1aFhzWmFEUXMz?=
 =?utf-8?B?ZjVFT2FxS3pJU09YRk9ZQytPU0xDS3U4K0ZWV2FNamxiMUhVb2Y2SSs3M0lW?=
 =?utf-8?B?WXFibjNXaUV5VVdPZlRNUWt0QzRXVHIvc3U3QjFkOU9saGN4ZWtVeGpqcXFX?=
 =?utf-8?B?cS9GZU5TaVYweXExbVU2VDFFMHFHRFlxZ2NyN2RVeHIrYm9kQVdmbWo5RnJa?=
 =?utf-8?B?SnRwZ3pKNDBCWHVjUm9lYU50Y1k3Y2tZRUlOdDdiN1Zxb2lRZTFseUw0SE9S?=
 =?utf-8?B?NGdoOXNFV2QxeHlvclJ5V204MDBFb0tVbHVkbWQweXEyeCtINGVVNkhoVEYv?=
 =?utf-8?B?ajQxU2gzWG00c3Z1OU56Z3Nka1NIcGp5TGtYQ1lFckZzaWNTQUxSNnZ2OXcw?=
 =?utf-8?B?YS92L25yU3Q0SHoyaElsZXkvNW1NVC8zOThSaytIY29uY1RsTnhONEJyL09s?=
 =?utf-8?B?UjhlK20wRmFHcmxldFlGWFhqTWNuUWxBaDRCWkd5WlIzd1dhMk1OVUk1Tzds?=
 =?utf-8?B?SmQ1OHgwbDUwOHk0b2wxalBmSFF2c0FES2doN3JwdVFRbTdtQ0JERjFjN1RP?=
 =?utf-8?B?NUhBbklFWXdDT2FYOC8yWm80YWpnQlVFVDlqeXhOOXRJaFZGOTRyVkNiamlK?=
 =?utf-8?B?LzVPQU5pbmdpTTJPNjhoS3p0a0lyVk1LY3JmRjY5RlhUL3kzR0RwbkdVYk5y?=
 =?utf-8?B?N2pPaFYzL1RUY0FBT1ArczBQb2dQNk9zdVVZQUVCak5OeEZpSEY5UXpYc0Zl?=
 =?utf-8?B?akE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D81238AB3CB8D44867C82FCEA7D32F7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3be0b9d4-a64a-4d99-6150-08dd1983d190
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2024 01:33:30.3255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joKrJsKZJL8Q8Od/lZHe872NDGyjZduUaKelEpp2Me3TfFn+LDismKe/w/kvVaLp0UfH4Hr8usEcXcVMv6wI3LLceAHmiAC3FtbSTaV4Eis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8081
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTEyLTExIGF0IDA5OjIzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
TW9uLCBEZWMgMDIsIDIwMjQgYXQgMDU6MDM6MTRQTSAtMDgwMCwgUmljayBFZGdlY29tYmUgd3Jv
dGU6DQo+IC4uLg0KPiA+ICt1NjQgdGRoX3BoeW1lbV9wYWdlX3diaW52ZF90ZHIoc3RydWN0IHRk
eF90ZCAqdGQpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgYXJncyA9IHt9
Ow0KPiA+ICsNCj4gPiArCWFyZ3MucmN4ID0gdGR4X3Rkcl9wYSh0ZCkgfCAoKHU2NCl0ZHhfZ2xv
YmFsX2tleWlkIDw8IGJvb3RfY3B1X2RhdGEueDg2X3BoeXNfYml0cyk7DQo+ID4gKw0KPiA+ICsJ
cmV0dXJuIHNlYW1jYWxsKFRESF9QSFlNRU1fUEFHRV9XQklOVkQsICZhcmdzKTsNCj4gPiArfQ0K
PiA+ICtFWFBPUlRfU1lNQk9MX0dQTCh0ZGhfcGh5bWVtX3BhZ2Vfd2JpbnZkX3Rkcik7DQo+IFRo
ZSB0ZHhfZ2xvYmFsX2tleWlkIGlzIG9mIHR5cGUgdTE2IGluIFREWCBzcGVjIGFuZCBURFggbW9k
dWxlLg0KPiBBcyBSZWluZXR0ZSBwb2ludGVkIG91dCwgdTY0IGNvdWxkIGNhdXNlIG92ZXJmbG93
Lg0KPiANCj4gRG8gd2UgbmVlZCB0byBjaGFuZ2UgYWxsIGtleWlkcyB0byB1MTYsIGluY2x1ZGlu
ZyB0aG9zZSBpbg0KPiB0ZGgubW5nLmNyZWF0ZSgpIGluIHBhdGNoIDIsDQo+IHRoZSBnbG9iYWxf
a2V5aWQsIHRkeF9ndWVzdF9rZXlpZF9zdGFydCBpbiBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4
LmMNCj4gYW5kIGt2bV90ZHgtPmhraWQgaW4gYXJjaC94ODYva3ZtL3ZteC90ZHguYyA/DQoNCkl0
IHNlZW1zIGxpa2UgYSBnb29kIGlkZWEuDQoNCj4gDQo+IEJUVywgaXMgaXQgYSBnb29kIGlkZWEg
dG8gbW92ZSBzZXRfaGtpZF90b19ocGEoKSBmcm9tIEtWTSBURFggdG8geDg2IGNvbW1vbg0KPiBo
ZWFkZXI/DQo+IA0KPiBzdGF0aWMgX19hbHdheXNfaW5saW5lIGhwYV90IHNldF9oa2lkX3RvX2hw
YShocGFfdCBwYSwgdTE2IGhraWQpDQo+IHsNCj4gwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHBhIHwg
KChocGFfdCloa2lkIDw8IGJvb3RfY3B1X2RhdGEueDg2X3BoeXNfYml0cyk7DQo+IH0NCg0KQWgs
IHllcC4NCg==

