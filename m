Return-Path: <kvm+bounces-42515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5548A7975B
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 23:13:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25239189394A
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 21:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B2A1F418E;
	Wed,  2 Apr 2025 21:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DVc/kUY6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3F02E3360;
	Wed,  2 Apr 2025 21:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743628401; cv=fail; b=E3Agsp6hVeYO1jjUkLiDADbHjcXLzjsIdW3iorlzpW7j0Evz2PGQhtDrUjYk+7y1lRsSOx9wK2OSmpMWELf5pGDuQ7ewrRAoVOR4k1dZrTAWJKNhh2m8i61ugtgK8gbUInyhrQQa5P6vOSFWFwsVF+PQh/hIC9mSSxsvcEGHtFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743628401; c=relaxed/simple;
	bh=gOv4hkh40kacuscFWbLLLxTYSHRaS0q1U+ge3VGopRs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=keDqTWCWzTVWGxEdimO3D6KKeJhQTg38cUH72eR758CKHB0xiuYy0UnhzSCH/pQR1QslUwBzM/rjNqjjvN3kdP8czJZbltKidVqLu8jLOaApOh5Cbw1mq2Fr1eYNRcYMezxMnfSgoDIv+SNUG8FpjdR5W81qFWxo/+9IS4W7s/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DVc/kUY6; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743628400; x=1775164400;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gOv4hkh40kacuscFWbLLLxTYSHRaS0q1U+ge3VGopRs=;
  b=DVc/kUY6zRjyvqFOjYd/QIDJFqH6ndnI5TRPR14nVlhVb1TqsmskXTI3
   yR9YEXrSdK3tS2xfx+rxm3V7bgMkQRjGo+MO/qawd2Dt+ZC/OhPDRcs3A
   133c0IRWVo3f5r1OvTH639TwWWWW1jejqsuAsMeFzZU7u7vBZgWsTCHpF
   E8x+Ao0/mhyxGdvNDr83Lg0LllBY4oAnhECaSV4h2v6tVt/Ssqby5ZGWy
   x7w1cU84wd2lvyItzL/G/HanINPuCGum+WaPDvdPi6KU7sQMCv6OaLACO
   2JN1l3WE75sDtisGLV2qnS+ZJkklFJJ1lsgTmnrPryofBiJ4M06AIYxOi
   Q==;
X-CSE-ConnectionGUID: XgZcSWoDQTCf4L3hIGIurA==
X-CSE-MsgGUID: yTp5nwcvQgWkzZmnP1Y7Yg==
X-IronPort-AV: E=McAfee;i="6700,10204,11392"; a="55643475"
X-IronPort-AV: E=Sophos;i="6.15,183,1739865600"; 
   d="scan'208";a="55643475"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 14:13:19 -0700
X-CSE-ConnectionGUID: 0N7Evj8aQDC4IR93INKCcg==
X-CSE-MsgGUID: 4fUsJx7zQKOGP8bfEzFPDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,183,1739865600"; 
   d="scan'208";a="127304987"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Apr 2025 14:13:18 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 2 Apr 2025 14:13:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 2 Apr 2025 14:13:18 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 2 Apr 2025 14:13:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l+1Tt3uNnDvK4BOfloQ2rQRI3vbG1XlDepam6HhQ8ZflNs1p1SWq8Aw6s+IlXmlwfXfVb5mj/98piqr2XLzrZu83p170Bn3hk04c2doFmVEi581nSy4hZ/njNwDqvYoNRiAKCY1qSqg/PFVcPQ8jdG3LNnOc0caScFygiztGLSYITkOM7X2IfyT8y/nJ6mO+hKOghnoTcgB/9wPw80OAFey1D7lyKhLQuhYt+qoP8k1W9JjeKQw/ADkOnurka46V3zZfkccj+E3aohCYoiHLqXAUAN6/k1WDq5mzC26yECkGdL+G1aOz2k0kClcFG3nEQeFuXYkeiI5rbBni4cvgVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOv4hkh40kacuscFWbLLLxTYSHRaS0q1U+ge3VGopRs=;
 b=lh88Dp5ysHSR3zVWgVU2RQrM8Exv9AeDdfvn+G/zCtnTm80kW3T6FDeVc96QxZXM6qoEiAWtQxSAwxvRYFVYS1KGkxwMlBlq1/9WFE30LOqqnb4IVuCqgDGchJk/GuI6WmJwvFRFnrvbi0ZHWmk5hZ2AEEJg/8ZYp3GfQQQwomTnCaNahUDDD+7NcQGdsSIzcJXOroUqw2WYnrw2FMWCQPE9qN0tkcVi9bh3siIeTgM23Fts9eCWhAHI83Y/y6yEbp0a0+B69dY6NzuGzSPKGvmGCtifepLLtlQm69Jj4xGbfa/kEqcEq04IDx5stIMwLIcIuIHMBshu2/dOXCE00A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by DM4PR11MB8225.namprd11.prod.outlook.com (2603:10b6:8:188::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.45; Wed, 2 Apr
 2025 21:12:45 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%4]) with mapi id 15.20.8534.048; Wed, 2 Apr 2025
 21:12:44 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "vigbalas@amd.com"
	<vigbalas@amd.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Bae, Chang Seok" <chang.seok.bae@intel.com>,
	"levymitchell0@gmail.com" <levymitchell0@gmail.com>,
	"samuel.holland@sifive.com" <samuel.holland@sifive.com>, "Li, Xin3"
	<xin3.li@intel.com>, "Yang, Weijiang" <weijiang.yang@intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "john.allen@amd.com" <john.allen@amd.com>, "Spassov,
 Stanislav" <stanspas@amazon.de>, "attofari@amazon.de" <attofari@amazon.de>,
	"Li, Rongqing" <lirongqing@baidu.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "aruna.ramakrishna@oracle.com"
	<aruna.ramakrishna@oracle.com>, "bp@alien8.de" <bp@alien8.de>, "Liu, Zhao1"
	<zhao1.liu@intel.com>, "ubizjak@gmail.com" <ubizjak@gmail.com>
Subject: Re: [PATCH v4 0/8] Introduce CET supervisor state support
Thread-Topic: [PATCH v4 0/8] Introduce CET supervisor state support
Thread-Index: AQHbmBq75nonr95zXE+IepwGCqQ0t7OQ97WA
Date: Wed, 2 Apr 2025 21:12:44 +0000
Message-ID: <bd391db213179a52d68bb84531775117805d6932.camel@intel.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
In-Reply-To: <20250318153316.1970147-1-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|DM4PR11MB8225:EE_
x-ms-office365-filtering-correlation-id: 1bdd7cf3-1679-4168-89ad-08dd722b1ccd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?ZGpiMTVBbWpGZkp0RFJJRkJlU1JzdnBnSHBJbEgzbnI3dzJibTh1VmNyM2dG?=
 =?utf-8?B?bGNmMVRRSEZ1MHJ0TVQrSzkwc1ZtQjVTU3hEZGF4MG12UXNScjhaa3Q1Sk9l?=
 =?utf-8?B?T3RXSEJMMjlYNHpGUE44UE51L1JoMGVPWU1kUWxsQzdPZEU5UEJZbnRnM21H?=
 =?utf-8?B?RnVkVElHa2l6bklaOHVyQTlDZUhYQ2lKWXZLUDJYT0E3REJVUHpTRkNKOFcx?=
 =?utf-8?B?UTVyRjdYMjJwVmJIbGkwYVdmaFVBV0ZCcWM3SEk0MXVvak1ZUSs1TStXa3hk?=
 =?utf-8?B?SnU3ak9QalV3dGxTTUJSTnJKNjQvY3ZRUENoR3NzZmN6YWZ3VUR5aWJ4TWFF?=
 =?utf-8?B?WC8vSklQSXk3N0duM01QVEhDRVAvRE9vdWdhd1htQ0NkZlZteXZiU3ZHWFFN?=
 =?utf-8?B?bEdMQVNwNDhwTWQzUU10bUNSbmtIOVNMb0dIRjN3cytFandyekN0dklGNnRj?=
 =?utf-8?B?YjAyMVAraTdKOFZQbXVHbXpuZVBGVDlWM0tEYXVZazRvWEtMQUQyTGpDWlZ1?=
 =?utf-8?B?UGlBeEF6Mjkzb0EycFpMbE9FdzVPbklKN2JqZm10OEhBNk5kRlh6ZmRZeGxY?=
 =?utf-8?B?Y1VhWm5MUzl1MmVFUVlMOUlVUjl5VHd0VDVwUFFBbHFRU0tGejhseUdyZEpx?=
 =?utf-8?B?ZWhGSVY0NWVrb1FCWVJmMEh4UFFUcGNKV0JhbThZcHk1eTdZSnFaZGV5a05V?=
 =?utf-8?B?ZnVPd3V0RjRZNG5YYkh3bW50WnRjOXFWdXZOTHovK0ZQRGxjcWFwWmxsRnYy?=
 =?utf-8?B?WDFESGVBbEZwbHBDb05UTXVlcER3bmdDM1dBS0dCOGlHbTA3TnZUMlF4cGZY?=
 =?utf-8?B?Wm5UNVJGVnFZVllscDBmUGdoYkUvUFo5YlV6dmZvazViRWovZmJVU0QrcS9s?=
 =?utf-8?B?MDE1LzlGZ25BWnNRUjM4eExVdVRscnB5Z3VCUXdaWVJqZXZSWE5BcGZRVUdD?=
 =?utf-8?B?ZERiOCt5K2J6bEY3dGUxNWgvcER6aWFzRUxLSmpUSjdkdWgyZWw4YTE0RVNm?=
 =?utf-8?B?UzRXWUpEL0gwZjh6TlVuc3VyUjZ3VHdnRUJ6dEw4SXo0V01lcFV0TUkycGtw?=
 =?utf-8?B?M2Z2cWRUaFYxbnFNcjhaaUdGSm1OanYrTFNhZlBSQlJPYkN0NGhvUDBDL3d5?=
 =?utf-8?B?eFJWcGlCTE5YOWFucFh4WjBrWDBIcytUUDVuc0lOcHNmZFBTYVEyR3VwSlYz?=
 =?utf-8?B?d3Q0bjRCL1NZSllhVXgxc1FlQUxQbGlGNE1wOE9XRHplUkxOZTlwcUZ0N2J2?=
 =?utf-8?B?ZmxRd1hveFhiZWV4aERsRjJ4cFFJcmNzNkdqWEdmVjI3K0VPMllUSm9jWDE4?=
 =?utf-8?B?NlNmQ3FYUHhwSTlXdzN0elZleFJVbXRwem5QQVc0R0VWM2hnYllheTFWVFFs?=
 =?utf-8?B?VU9Zc0E4V2JBbEFxMksyMlJ6b3VpSkhBVFlIa1NhQzd0MXluQkhKOHdkQmNO?=
 =?utf-8?B?Z1NuL3N5MnplTmlaTlZLenRLVWNTcHgxMkxrZjdiSnRSaCtCOGFIQ1BML2xI?=
 =?utf-8?B?K1RsU1BYUCsvUE84YWZuQlZlRjhobS80T0NIZmUxb0Q1QXMzclBiL2sveFhw?=
 =?utf-8?B?dHcxYVhybUxuRUlXMGdud3BBT0VGS2M5b2p1eWdZaFY2akFpU3QxSWh3WHNJ?=
 =?utf-8?B?VmJINnE1T0plcXlTWXVwVkVsQzV3MGFQcGk0M01pejViSER0QUFkOXB0OGxQ?=
 =?utf-8?B?UldNcWJ4Y3IvVUM4dVpQWWluTkxpeHp1SUl4c3RPOFF4ODlzVVRwNjlPa00w?=
 =?utf-8?B?Y1FwdktGNFRJYWlzWitRcTJDWEQ2ajBtd3JBVWVxeklTbDYwSkgzQXJod2tl?=
 =?utf-8?B?Rm5LNVh4QmxFYkp5NEZzamVLRTBkVW1mbmRkSjYwMVJBVm16OHZVUXNGOTd2?=
 =?utf-8?B?ZW9TUTVtQVpjNlp6UFAzdUNzOVlhclBzL3c3M1lBOUtZTno2cHdZNEFONWl1?=
 =?utf-8?B?Tzg5eFR2SmJ0U1J5MEpUNHFjenEwaDQwV0I2M3ZpSWlwYURBbW5YL1lObkZq?=
 =?utf-8?B?bC9uUHhUSjJBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Si9RdGltcitudjFWd200NVpNUDV5TVNqRFFXK2ZBU3FYY0dFblZ6dXg4TXk2?=
 =?utf-8?B?Zm80T1V4SDcyZFp4SHZONEJXM0dnZmtJTVVNYURnbGFCc24vRktxYVFQc0xG?=
 =?utf-8?B?a3p2OTBlRldISWtveGtoVWJ5STVTb1NrYzFHYk9DekJnTWlleFNMV1VNS21S?=
 =?utf-8?B?TjM2T2tpQkhSNXNCdzI5bjRoeWsvWGR6VWVSRkVMNklsS09aRlpzMlhmS3Fj?=
 =?utf-8?B?ekdZelplNzV1TnpjU2JMWDFwSkxBWENPdGtDOFRqMHVKUFpUR2RjSnlLaG1J?=
 =?utf-8?B?eWNQckhkNEFINDFKSDF4ZnhLWkhmaCt6MDFUNGl6MVJKZ2pGMTBiOHFwM0s0?=
 =?utf-8?B?UDY3S0FvaUlhZlFFRUZqRjhVNldHYmx6Sit1bW91ZEl3WUFXYVNmNWhqM3NJ?=
 =?utf-8?B?U3NsazhBYjBrUFpmUUhSQ1YrOXBDeUFmNmNCSjJnMUhVcU9JOEhia1NzYld3?=
 =?utf-8?B?RXIyMmRhc3pneVFpRDdRUEpjVjIyeGk4TzVhR2h2SmUyZHpxTHE0TFBnNFRl?=
 =?utf-8?B?VUlRaUlkbDVFdkdvRWo1TUx2b3V2MDNIczZTRk42QzRzN0VvbzlaWk42OFpF?=
 =?utf-8?B?VnFBNlUrTnl0Q0xucEV2R3cxRmxXR1B2aVlRblQyUUJqMlFkdXcvNjYyeW83?=
 =?utf-8?B?LytoVjYrNWEvN3ZPTzBOaEQ0UDhIUmg2eEQyTjVGZE1WemgzTVRVYXVDOGRC?=
 =?utf-8?B?bzVDeW1JMHhsSVZXSGZ1VDVQbHJISUpTWWY3a0NmSGdWNVhqb05XTWNlREZL?=
 =?utf-8?B?V3JyMW5ZUlZ5R01lODNPQlN2WWl3VTNpMUhBWUFjSHRZUGd5LzA0b1Z4anZn?=
 =?utf-8?B?akQ2NGlsTUVlcUdoQWxXcktXTjJUM3FEQk9QVE43MTNheUJhTjZidyt2enh3?=
 =?utf-8?B?YXZvdGpTbm9QN1E5K21aM243aXdlKzdXNDlwdUx3UXArNjh4RThzbUd1MWEv?=
 =?utf-8?B?VkN6K1Y5RExWVzZaZHpTbnRMNklpWTJOc1E0VnA4dWxCNVFId2pPY0pqNEo5?=
 =?utf-8?B?ZnJtT0NHV1Ura0RGbjhaMkxjTjRXd3hYaWdWc1FsVlMzQVpIL2RrNUpnTDh3?=
 =?utf-8?B?VlJ3Qi9SeGZIRzZZTjRxU1ZoekRGeWt3SkhraWVlSmltNnA3QmJQOVNOcUox?=
 =?utf-8?B?TWlrVEo0enJncUcwenlJTU41citGc1RMN3ZTems3TFZtM2hKRHJ1TzBlNUc2?=
 =?utf-8?B?YlVjUGgrYTJxRndTeFFteU55UllVQTd4Lytza3dCdGxZbCt4UytQb1JieVc1?=
 =?utf-8?B?QU55NUc1Qk5sNFBSVGZpRnRNZnpqTHo4UnNkYlN0cHgwS0llb3FLVDVXcjQv?=
 =?utf-8?B?S0Z2M2JuQkhkYjBIcXM4RkdIWXgrclF5YU5JTC9JSVRhaVdnOVRHRlZiQlJX?=
 =?utf-8?B?RFYxTHh5RC9YUGgzRUdjOEVSekJ5bW93dWczNDJKQjdPMTFKVEhVc3NZT3RF?=
 =?utf-8?B?dUpXVklBNDBTZ1BMK2FLYjgwNmFaYm1FdjRISnd2T0RaV2VCb2I1RCtTZHJ4?=
 =?utf-8?B?bEIwNzloeFRsVHUyK3ZLcU1DZnZrUWpoNXhLVThXVEJFOVFWbjdmaU0vL3hi?=
 =?utf-8?B?bFZ3a2t2YitMZmVRSjR2V3ljRVNMRnRWRDlYVi9WcjdaVEUwKzE3R2VyMWVI?=
 =?utf-8?B?MWpRVTdrMU1vODRrZEtQSjdzUlV5MmZDRWlScFlLb2kyZ2YzNjdQYXRaU0x5?=
 =?utf-8?B?dlNCdDVlYWo5bkV4L3VPd2tVTCswdFpvdENJRm01Y0dzRWluS2dUanN2bFlX?=
 =?utf-8?B?ZFAzQWxxT1VpYUdLVGxJeFhZMWVnd1VlZnhWMmc3QmdzUUJDcUh2RFpsVlJa?=
 =?utf-8?B?Ym5hKy85bW5YOEpUbEhVYWxrNGZaVHlLTXpydE5CZTBCcEdveUVFS1VMSENZ?=
 =?utf-8?B?OWtvT0JtOVNweWxDR3NuTHF0L0lyVThrT0lSZnh3eE9CODl6VnZ4SXA1N3BG?=
 =?utf-8?B?a1JkK1NheCtYditGdkdja0I0dkRFNmhCWGdzSlMyb1cyTFlXM2NSbWZJN1Qw?=
 =?utf-8?B?ODRqUDE5MVlQZmVTVmUraU4vL0VQbnRGcEhBZWc4eVpQaHFYcWwyM2w5TWFt?=
 =?utf-8?B?VFhkM2VpTVduQ3l6MHEwUVNudVBZWllMaklsU0J4ZEdjemliWW1VaWdhbWxt?=
 =?utf-8?B?VzQrZnVteVVGQ09INVhOTS9qWEVsb2ZRL25FMzZhaDA0NURVVHd5QzVrcHN3?=
 =?utf-8?B?NlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F530C9F1B27118409325A55BBFDA00D8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bdd7cf3-1679-4168-89ad-08dd722b1ccd
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2025 21:12:44.8337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: opKqHEHz5Ul8upXBlSijn8++TqllVsbGs8BsumPxVv6OgukJKXqrkW4PcZdyPZ/dZZoQOP6ymcJozzfmnDYBW525ccFkKJ7Ow/sia/H8IsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8225
X-OriginatorOrg: intel.com

WGluIGFuZCBJIHdlcmUgZGlzY3Vzc2luZyB0aGUgZGVwZW5kZW5jaWVzIHdlIGhhdmUgZ29pbmcg
aGVyZS4NCg0KRm9yIGFyY2ggcmVhc29ucywgQ0VUIHN1cGVydmlzb3Igc2hhZG93IHN0YWNrIHdh
cyB3YWl0aW5nIGZvciBGUkVEIHN1cHBvcnQuIEFuZA0KZm9yIEtWTSBkZXZlbG9wbWVudCBwcm9j
ZXNzIHJlYXNvbnMgS1ZNIEZSRUQgc3VwcG9ydCBpcyB3YWl0aW5nIGZvciBLVk0gQ0VUDQpzdXBw
b3J0LiBJdOKAmXMgYWxtb3N0IGEgY2lyY2xlLg0KDQoNCkl0IGxvb2tzIGxpa2UgQ2hhbyBoYXMg
cmUtYXJyYW5nZWQgdGhlIHBhdGNoZXMgc3VjaCB0aGF0IHRoZSBzcGFjZSBzYXZpbmcNCm9wdGlt
aXphdGlvbiBjb3VsZCBiZSBkcm9wcGVkLiBJdCB3b3VsZCBqdXN0IGxvb2sgbGlrZSBzd2l0Y2hp
bmcgdG8gdGhlIHByZXR0eQ0KdHJpdmlhbCBwYXRjaGVzIDEtMyBJIGd1ZXNzLiBIb3dldmVyLCBo
ZSBkaWRu4oCZdCBhY3R1YWxseSBhZHZvY2F0ZSBmb3IgdGhhdCB0bw0KaGFwcGVuLiBCdXQgdGhl
IHN1YnRleHQgc2VlbXMgdG8gYmUgdGhhdCBpdCBzaG91bGQgYmUgY29uc2lkZXJlZD8NCg0KSSB0
aGluayB0aGVyZSBhcmVuJ3QgY29uY2VybnMgd2l0aCB0aGUgYm9uZXMgb2YgdGhlIG9wdGltaXph
dGlvbiBpbiB0aGUgbGF0ZXINCnBhdGNoZXMuIEl04oCZcyBqdXN0IHBvbGlzaGluZyB0aGF0IGlz
IG5lZWRlZC4gQnV0IHNvbWUgb2YgdGhlIHBvbGlzaGluZyBuZWVkZWQNCihpLmUuIHRoZSBsb25n
IGRlYmF0ZWQgbmFtaW5nIG9mIGZvciB0aGUgZ3Vlc3QgY2F0ZWdvcnkgb2YgZmVhdHVyZXMpIGlz
DQpkb3duc3RyZWFtIG9mIHRoZSBncm93aW5nIGNvbXBsZXhpdHkgb2YgdGhlIEZQVSwgd2hpY2gg
d2Ugd2VyZSBwbGFubmluZyB0bw0KYWNjZXB0LiBTbyBtYXliZSBpdOKAmXMgdHVybmluZyBvdXQg
bW9yZSBjb3N0bHkgdGhhbiB3ZSBleHBlY3RlZD8NCg0KSW4gYW55IGNhc2UsIGF0IHRoaXMgcG9p
bnQgSSB0aGluayB3ZSBuZWVkIHRvIGVpdGhlciBkb3VibGUgZG93biBvbiBwb2xpc2hpbmcNCnRo
aXMgdGhpbmcgdXAgKGJ5IHBhdXNpbmcgb3RoZXIgd29yaykgYW5kIGhhdmUgYSBjbGVhciDigJxw
bGVhc2UgZG8gdGhpcyB3aXRoDQp0aGVzZSBwYXRjaGVzIiByZXF1ZXN0LCBvciBkZWNsYXJlIGZh
aWx1cmUgYW5kIGFyZ3VlIGZvciB0aGUgc21hbGxlciB2ZXJzaW9uLg0KDQpJIGd1ZXNzIEkgc3Rp
bGwgbGVhbiB0b3dhcmRzIGtlZXBpbmcgdGhlIG9wdGltaXphdGlvbi4gQnV0IEkgZG8gdGhpbmsg
aXQncyB3b3J0aA0KY29uc2lkZXJpbmcgYXQgdGhpcyBwb2ludC4NCg0KUmljaw0K

