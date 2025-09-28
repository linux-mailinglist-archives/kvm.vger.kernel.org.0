Return-Path: <kvm+bounces-58951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 08FEEBA7928
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 00:56:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D1071896783
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 22:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D3E296BBD;
	Sun, 28 Sep 2025 22:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j3maMSYX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57566226D02;
	Sun, 28 Sep 2025 22:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759100200; cv=fail; b=O3Wkl32NoAf74JLbj5/xS49GtiN6ZWLj+qhPutQnQm0v3WtfggUtNQOQBuFmskTn0QDnkyB+2QDv2FNXUooO4vzwEU1tE4ziR0qzgWo3zVDfsGuNtAyqCFCigcG3GgEw8DEXyr2vtelDPMtYWLX2Bm7g96dNYQalnAd+hbx4RFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759100200; c=relaxed/simple;
	bh=HcYWhoRB+ubqJCg4daZtsNfVld1EdFCUrcQNxbIMLic=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mo+xZmTRprG8Ph43sO3DSK/nfVWGeahRPseGRd9gm2p3nsqVx1Ake3KsrrwaALgKDH2d7wr0QTwC3Gp2RfWamg3Dj65aXP4zubF6ETvWr2EWTBhQLy4yOrxRJEjr7fC8LaKN94F9tXskbGY/tNSZs1AJQzo7mZP+sfBxNDzT2vI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j3maMSYX; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759100198; x=1790636198;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=HcYWhoRB+ubqJCg4daZtsNfVld1EdFCUrcQNxbIMLic=;
  b=j3maMSYX1MJey3C0eAIn6UwkbjUOPsywoKz1nGtUyyxV6uoDvZdcUtuS
   WNZvX4CTsyMP7fOrfAlGLsjZbnpUz/WNITLnFP41X2NFv0A7tCrMjOFx+
   eyZfdzscsGwqg7wY1y5ui1BltPq+Kgmm/MC7YLRw2c6V7CdEV2euNaGPK
   KAXvAMoYoL8mXSRZTUylqbKehKYVqql6MkbiFEeLH4WhzdMo2I+Br2U2l
   pygBJg7z7Vhyv2Ys+aZwWm++xIR7fpaY9z03V6gzmekIgNO5ktyzWwmli
   ZEKJjqrwH/d7CTleOM9wjV8pfH1TB9RoqkgLV2mmFaboMC8v4gsze/8Vq
   Q==;
X-CSE-ConnectionGUID: y0+6KdaZQxGBj9bSm+psUw==
X-CSE-MsgGUID: DOoY3Sp3TTWcltZ4fIfV/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11567"; a="60378596"
X-IronPort-AV: E=Sophos;i="6.18,300,1751266800"; 
   d="scan'208";a="60378596"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2025 15:56:36 -0700
X-CSE-ConnectionGUID: MvVSZrQ2TN2MoV8UteThXw==
X-CSE-MsgGUID: c9l0hqYRTxCARFjinCVE0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,300,1751266800"; 
   d="scan'208";a="177209884"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2025 15:56:36 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 28 Sep 2025 15:56:34 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 28 Sep 2025 15:56:34 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.0) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 28 Sep 2025 15:56:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TiASHW6mcRyi9kJGAzVJ7SDLfmBI1YLOD2sEcwPapjXMgdamwFnPCa/tFP19uuZz9fbH7Q4qSJMm1ZIyOmluN1ffvoa9OmV2cHZ78hhJqSBcGo8VgQQSY3QYxLc/mmM17u51Sy0yAr7nj9ItLdryGz89oFmD16mvG5Gr1rM4O82xStJw4iHxgqjwGqBCMJjtj87mZGD0vvIbjMNrCARQ2EwzODaVD2kd5YCZ+A21UVNA0l5Jv0nenz9efIaHELMC0huF8ZST8llGD+WVeXYzEJU31xPcqlfiG4N3krWqembhcyiIntQgj2B1+ZBZ5QOWz0Ixkgb8nrqVaXCvTCTlqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HcYWhoRB+ubqJCg4daZtsNfVld1EdFCUrcQNxbIMLic=;
 b=rRgAu5A7ZgkZ8tcslMgrtVZy+MsF/m80ertCyPpW7FsxAA+UmqtJ1QjeTGzFlhBV1sNNl/I4enEfvjEp6JbKf7iqHSgdKhnKnD5J4c1I18Mq5V2y+zCuRe5xNpFPiyZH+xcs7lqkvxpVo5ddibs7aNscABpGZ2cXMOPEXv8tAl80VWkdauP//8V1u0Ni34WN8/aswhghNmJ45FQt76Dadz4ZfP8EbmBYDTmmcPn4OcMFxUwtx41X17bZtIogLUYM9gYFiLioiUxFvwsEuiBydadUEB6euqvFo815O/rrvCvX0c6aA7XjkCDVa/cTSvZRwO2pZfgDwRNmXV7KwnRRUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM3PR11MB8733.namprd11.prod.outlook.com (2603:10b6:0:40::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.15; Sun, 28 Sep 2025 22:56:25 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9160.015; Sun, 28 Sep 2025
 22:56:25 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kas@kernel.org" <kas@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick
 P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Topic: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Index: AQHcKPM4drSY0pNBrkCcT+2ZM9x02bSfFAOAgAcZ3QCAAxZxAA==
Date: Sun, 28 Sep 2025 22:56:25 +0000
Message-ID: <9018c8629c921fae9ee993cd83b5a189616f51b0.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
		 <20250918232224.2202592-13-rick.p.edgecombe@intel.com>
		 <9e72261602bdab914cf7ff6f7cb921e35385136e.camel@intel.com>
	 <f1209625a68d5abd58b7f4063c109d663b318a40.camel@intel.com>
In-Reply-To: <f1209625a68d5abd58b7f4063c109d663b318a40.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM3PR11MB8733:EE_
x-ms-office365-filtering-correlation-id: c29e431a-936a-4b3f-1a2d-08ddfee2407c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?bWs2bzd2eVhqZHFSaXAxTFA5cUtLeXN6c2hIZkhORFNub1g0aUNyK2hYZ2ds?=
 =?utf-8?B?eGJSZFFkS3JRdWJUNU55cU1rcHVaTDV6OUtUOW4yM2FVRWpkYjloMmFRdGM0?=
 =?utf-8?B?MUZ1OGNENmlkbytVb2RjQUJZV2oxUTgyMWRoY29KOGtCc0w3ZXpOc1FTTlZB?=
 =?utf-8?B?cG5pRmNQR3hubDVtbFlicE9ENktnbDRhZjhTblE0UU1JRFkxc09ERXM4YXRw?=
 =?utf-8?B?dE1yNEQzdEZzMnZMQmNqUjQ5RkJCcUVrOVByL2tVRldNOHdtdGZpdEV2NUpO?=
 =?utf-8?B?RHNNRkJMRWFrZm1OTWRMQWttdlNzU01oRnFoYWJ1cDBxMFp3eE85d2NPNGN0?=
 =?utf-8?B?TEU3OXF1K0ZSclg4NU1CN21ERFR4bFdKbjFvVzh5RE45ZjE3SGFQbmVwam5l?=
 =?utf-8?B?SWNUWG5ZN0RMcHJDYzFzbWs4K0t4aWFxekRGc1RTNWErRlAvS3c2ZHliT25X?=
 =?utf-8?B?TWs2SU5rOWxDWjI5ZlRDUVJqcmo0UFNWRlk5cEV4dm1YQ3Flak04M1Y2SXQy?=
 =?utf-8?B?V0hiUjNpM1R3aE9TTUJabFpvS0oxVUI2NjM4N3hjYlFuejFCbGN1S3JHVHIr?=
 =?utf-8?B?OUtpVllQQWpBcmxxSGdtUERkbVUxWTBZN2RzMFZmYjZkeUQ1SkhWZStIejY3?=
 =?utf-8?B?M01RR2syQ2JvZm9yVmhQc0pvSHdZbWRQYjB1dmJGS3h6TndCVThrWlhvOUlB?=
 =?utf-8?B?MjhuRnVjbmpVUjRPSUZjeFJQeDBsT3ZNYXMrUmlQK3gzdy9BMDdpOXJWT0Fn?=
 =?utf-8?B?ZDNqdW9pL1M5MXNjSXU4ZTBFeG1MeC8wZlFHVDVqM3AyZWRyOXpSYk5PSVJh?=
 =?utf-8?B?QTloQnBqVVQ4MEJxOVRxWE9SYjhUalQ3Y2ZQcFVDRW5pMFgzNFpHQzNxdnIx?=
 =?utf-8?B?THFTYUtHRzRWMHRqOUdUOTNWNXUwMTNocmQ2N1MwdUVGSmVtdTBlRWxIak9u?=
 =?utf-8?B?TUFrZUdmTnVickNQM2lKc2NHaTMzSE8xcnk0aCsxaEFHSXpvYmRsazdnYklx?=
 =?utf-8?B?VFlLUVpWZHdSZWlWZlFSMVd5TTlQdmhaZzM5NnRZYVVEdHFldzhqTmJkMStT?=
 =?utf-8?B?d1VERUgwbE9jNmpBbEdOWWZrcTRRcXpVMmtOajgrUjFZMS9sNCtabjQwM0R6?=
 =?utf-8?B?WFoycTlkOU84a2FjdncySEUyVVVlcDJsNFNSRDJBK0NUZ0dXaHlZUFAvQW5h?=
 =?utf-8?B?ei8xNjI2enExaXk4eFFCQmZvQ050a3dmRHh0MzRxdDlHWGNXcFBiYnE2emkz?=
 =?utf-8?B?WXVTMEJ6cUJWQVAxbWt0QWVHZXN1THNpWG1MamRpQXhsUHk3aFRwTzlPMmxk?=
 =?utf-8?B?Y1dFVENPN3NsKzgzQXNMazZjUnlQaWIxSVdTTjRxOU5vTVlPY3MzdVNjcVZ4?=
 =?utf-8?B?Q3pOZVZ4VXpiQUhxcW5laC8wekZOeEJadi9FZGQvcUtFVDVSV29DTHpXUmVW?=
 =?utf-8?B?OHBzRnBhMWhFenh0OG5GUjlaeEVGYjBuTHVOVWNlQmJmVkRTVFY4QXdiRDla?=
 =?utf-8?B?UWVuU0x5K0QzdXUxMmtQZFlrakNEZzFOeG9Ta0JDUmgvcDZGUUFpUVAwZWdT?=
 =?utf-8?B?dUhTTWs2Y1RJeEQ4VE5ZajZFNnphcVE1dGxpTGNEVUh6MW5zZDRwSFV2OEVI?=
 =?utf-8?B?S3BFNm1ETEtvQ3R2VVZXQmhiTGYyaDErLzc1T0Mwc2NwUTBxeGVUSXZSQnhi?=
 =?utf-8?B?VUJQNnN2YVRiNE8rOUMxNDhZZk90RlJjVHViRkp0OS9nb040bkhweTVOZ0lX?=
 =?utf-8?B?Q3pDSDlZeU0wVFJmT1dJcHNjRGEyaTdEeDZBNWdraFFOQStqMGxkWFZWQ2xT?=
 =?utf-8?B?OHFwdEpnaXJlMzFGL2h2eUt6NUI4TXhUNG1sSlZ0TzN0aGl4KzY1YS83NC85?=
 =?utf-8?B?S0ZxWHE0NTZhaUp4S0xWWTlRLzBZNnVlczkreWx2RnA3OTYxNklPd0IyQjlY?=
 =?utf-8?B?UDVlV0drU21FR1BSNHFqY2pUdTZGdEhFS0pPMmdjODdrYm8vMytiVzVxRW9X?=
 =?utf-8?B?VDFicWFzbDZXYlNyRXZqY3o5eXpVN2c0WHZpWVNVU1N4TmFyWEFMNWdkWXQv?=
 =?utf-8?B?QUNKYi9Bd29yR05zYXYrZVpsVWlqTDdiVEp5Zz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0dDUHAvMmpiSFM5SGF3Y3dCcFducVVXL05DMXp1NlJ2bmNyS1pOQmhmMzZx?=
 =?utf-8?B?V1UrL0lyZnZCTTlkOHRCVllyRUF5OGVDbHVLcmdMZ1VaY0R0T2Z1UlRMZTVM?=
 =?utf-8?B?UVlYdm1BNnhxNmI4bUdnbnVDWmpmMWdtajNMcnZPZEM1R0JoNWthQllpYURM?=
 =?utf-8?B?Y0lxNjNVazBoMzdYcTVZUnVxTUM4WHU1TXl3d0daZThUcitlaEd3RmgwNjZt?=
 =?utf-8?B?K0FHandEeG5LRHRMY2Z2VUZsaFVCZUIwUWtzaXFBeVlyTkd4ZkNzUVN2b3A5?=
 =?utf-8?B?ajJLV0RZL2srYmYvS3hPL2ZrdDVnOGRPZWNTZm5ZQUZxOUlmcFQxMm5DTzBq?=
 =?utf-8?B?Q2JVenNnbS9DcGd4TWw3UmwvcjFSSC9RRTVwMVhBbTAwb0g2K2lZTU0rajNP?=
 =?utf-8?B?bEtxYlQ0MlRtV1JiYkhvVUhaWHNsOHY1SldNTjJPdlBYeXBWSkF1ZnVTckVB?=
 =?utf-8?B?dktTNUNpTkN5TkR4Z0lHazZrYkYxSE9pVUR4d3MwU3FSYTVUc00xVzlYcTBR?=
 =?utf-8?B?OUxWZlFNalBvNmNNL0FCWWRUM0NlVnAzVmpyanY0N3ppeDArRjFpYmFQeVkx?=
 =?utf-8?B?SXRpN1RDd1c1VEJ5MnkzZnRvWU9UV0Z1aWlja1lUY2xJR0VuVzMvZHpnVU9K?=
 =?utf-8?B?aGRROWtsQlI4S3ZuZ3VQSmJVaENtRFljUCtMeU5maHg1MkRKdmV5Wk5JY0JE?=
 =?utf-8?B?OXRFSXd1ZTdCR0NmdGt6RXBPUlNRODFDNW1BcXdnT3pUZ1BTY2ppSnlVN3Jv?=
 =?utf-8?B?SytoYkVRcmtkbVhIS0hZcXhCT0Rabnh4aFpMVVZUZVVQSnc0a2I0cXlWVnhz?=
 =?utf-8?B?SGtubVNnREVvaDZuV0tiZEVmYUJuV0QxOTdCTDY3dGNuNjhLT2IvWEhEbTV6?=
 =?utf-8?B?N1FjUEFNM0cwZkFFOFNtL2RTSVJWUzJtdDgrU0ZYbjR3ZGdBR3ZaMG9KNWYr?=
 =?utf-8?B?TkZyWGJPU0QzbGxZeDlMc2pIb3dFRmdHUVIrQ1ZiWCtDNWtJTzQvYlZYVXIx?=
 =?utf-8?B?M3phUThnQTAxTXovZ0RxZW9qUlJXcVFGMVd4R25NSVJEaFBLNUwwanU1RUIz?=
 =?utf-8?B?RUpYSmRINFAwQ3pXY2lOdXFVWm96N1VveWVvOFludmlER0hZZ2VlYm41aGND?=
 =?utf-8?B?SjN2Wjl3MmFaaXBSdTlSbW0wbVczN0xMejNpWUxOaHl0aE1HeVNBb21LbHZH?=
 =?utf-8?B?UDY0MHh1NkdBVmh2eERMUlZWd1RaT3dOZ05mdTdscDlrQnNrN0ZWZTJxS3hQ?=
 =?utf-8?B?Tnd0elRjR0hyaHp6R2dsS0pXdnAzMEpxRUpwbkhrSlZCVTJaMDVyYkk3aUdG?=
 =?utf-8?B?bWlVU1JNTHF3d05UajlPaTVxZjVDRkIvNG83RTBNazZkaU1pY2JBN0dxMXdV?=
 =?utf-8?B?Z2RjTUZ4dGQ3dGlSNE5RL0s3TDNGVktUTnRqTGpCcEZlM1JqZFNsc0tGdTN2?=
 =?utf-8?B?QlY5QkFSWVdFUGhzTkRVOWxmUE9UbnR2YndMaDl6cEt3WTlqVDdWQUEvanNw?=
 =?utf-8?B?MUY3RHpWVXl5VGZmcjcyOUJEeFNBcm5nT3ZjRHI0UWtxTDlzU0ozMXdrR3NE?=
 =?utf-8?B?T21kSVdTVkh2VUQ2V2djTTVTY2lSYTMrWUVwZ3d0RlIyb3NobEdGZGZpSU80?=
 =?utf-8?B?bDU1K0RaSHEzY3JYYVFlTVI1dktRc1l3aExLb2lhTW5MM3RVVllJczMvZitI?=
 =?utf-8?B?UHRJaFJFNXA3OWRUS0JqRnNjWllBcWhhSStmT3Z2NENxS3IvTWZFU0xSYkd6?=
 =?utf-8?B?VEs4WUZKZjkvc3EvdlR6L3N5dmUrZysrMVR1dzlFU1d4ZW5sbTVGOFNUekVX?=
 =?utf-8?B?MVlWMUl4YWgwWCtSWmVEZHJyUmZUTWtWUHdpdTJ0NDNud0JSQUdrOU1XcE5C?=
 =?utf-8?B?UC9MOE8rNVdrdzczKzUxV0NESCtmWTIrUkUrM0RjdW56M3JDT3d0cEJDRFQv?=
 =?utf-8?B?bjdUTkNxVW9MWEZ3NXNPeTV2Rzl1ZzNvS2V6VzJSemFxRm5kZlh2RnZiZ2tu?=
 =?utf-8?B?aWdNbjRmbjlnbXB2Tm40VS9nT3lXYWZDVlhuL3lESStua1huWVdvMFJXWmd5?=
 =?utf-8?B?L2x2dG81cU1pS0hDRUQyVlUvMWFiT3dybzh4UlEyMEh4RitHV3M3Tk5mbFRZ?=
 =?utf-8?Q?zdEYZJnO02HLM97/LmW8xWgY7?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7814ABEC5E396C4AB5AFA6659420CD5C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c29e431a-936a-4b3f-1a2d-08ddfee2407c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2025 22:56:25.4230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g/Etqtec95lej5NP/rFB3RYqVVTI3cvBnlfcmRv4bCauc9xG0qE84/rFG6O2Xog0iFQWfToXCI9dBU1EIj/IIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8733
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA5LTI2IGF0IDIzOjQ3ICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gTW9uLCAyMDI1LTA5LTIyIGF0IDExOjIwICswMDAwLCBIdWFuZywgS2FpIHdyb3Rl
Og0KPiA+IFNpbmNlICdzdHJ1Y3QgdGR4X3ByZWFsbG9jJyByZXBsYWNlcyB0aGUgS1ZNIHN0YW5k
YXJkICdzdHJ1Y3QNCj4gPiBrdm1fbW11X21lbW9yeV9jYWNoZScgZm9yIGV4dGVybmFsIHBhZ2Ug
dGFibGUsIGFuZCBpdCBpcyBhbGxvd2VkIHRvDQo+ID4gZmFpbCBpbiAidG9wdXAiIG9wZXJhdGlv
biwgd2h5IG5vdCBqdXN0IGNhbGwgdGR4X2FsbG9jX3BhZ2UoKSB0bw0KPiA+ICJ0b3B1cCIgcGFn
ZSBmb3IgZXh0ZXJuYWwgcGFnZSB0YWJsZSBoZXJlPw0KPiANCj4gSSBzeW1wYXRoaXplIHdpdGgg
dGhlIGludHVpdGlvbi4gSXQgd291bGQgYmUgbmljZSB0byBqdXN0IHByZXANCj4gZXZlcnl0aGlu
ZyBhbmQgdGhlbiBvcGVyYXRlIG9uIGl0IGxpa2Ugbm9ybWFsLg0KPiANCj4gV2Ugd2FudCB0aGlz
IHRvIG5vdCBoYXZlIHRvIGJlIHRvdGFsbHkgcmVkb25lIGZvciBodWdlIHBhZ2VzLiBJbiB0aGUN
Cj4gaHVnZSBwYWdlcyBjYXNlLCB3ZSBjb3VsZCBkbyB0aGlzIGFwcHJvYWNoIGZvciB0aGUgcGFn
ZSB0YWJsZXMsIGJ1dCBmb3INCj4gdGhlIHByaXZhdGUgcGFnZSBpdHNlbGYsIHdlIGRvbid0IGtu
b3cgd2hldGhlciB3ZSBuZWVkIDRLQiBQQU1UIGJhY2tpbmcNCj4gb3Igbm90LiBTbyB3ZSBkb24n
dCBmdWxseSBrbm93IHdoZXRoZXIgYSBURFggcHJpdmF0ZSBwYWdlIG5lZWRzIFBBTVQNCj4gNEtC
IGJhY2tpbmcgb3Igbm90IGJlZm9yZSB0aGUgZmF1bHQuDQo+IA0KPiBTbyB3ZSB3b3VsZCBuZWVk
LCBsaWtlLCBzZXBhcmF0ZSBwb29scyBmb3IgcGFnZSB0YWJsZXMgYW5kIHByaXZhdGUNCj4gcGFn
ZXMuwqANCj4gDQoNClRoZSBwcml2YXRlIHBhZ2UgaXRzZWxmIGNvbWVzIGZyb20gdGhlIGd1ZXN0
X21lbWZkIHZpYSBwYWdlIGNhY2hlLCBzbyB3ZQ0KY2Fubm90IHVzZSB0ZHhfYWxsb2NfcGFnZSgp
IGZvciBpdCBhbnl3YXkgYnV0IG5lZWQgdG8gdXNlIHRkeF9wYW10X2dldCgpDQpleHBsaWNpdGx5
Lg0KDQpJIGRvbid0IGtub3cgYWxsIGRldGFpbHMgb2YgZXhhY3RseSB3aGF0IGlzIHRoZSBpbnRl
cmFjdGlvbiB3aXRoIGh1Z2UgcGFnZQ0KaGVyZSAtLSBteSBpbWFnaW5lIHdvdWxkIGJlIHdlIG9u
bHkgY2FsbCB0ZHhfcGFtdF9nZXQoKSB3aGVuIHdlIGZvdW5kIHRoZQ0KdGhlIHByaXZhdGUgcGFn
ZSBpcyA0SyBidXQgbm90IDJNIFsqXSwgYnV0IEkgZG9uJ3Qgc2VlIGhvdyB0aGlzIGNvbmZsaWN0
cw0Kd2l0aCB1c2luZyB0ZHhfYWxsb2NfcGFnZSgpIGZvciBwYWdlIHRhYmxlIGl0c2VsZi4NCg0K
VGhlIHBvaW50IGlzIHBhZ2UgdGFibGUgaXRzZWxmIGlzIGFsd2F5cyA0SywgdGhlcmVmb3JlIGl0
IGhhcyBubw0KZGlmZmVyZW5jZSBmcm9tIGNvbnRyb2wgcGFnZXMuDQoNClsqXSB0aGlzIGlzIGFj
dHVhbGx5IGFuIG9wdGltaXphdGlvbiBidXQgbm90IGEgbXVzdCBmb3Igc3VwcG9ydGluZw0KaHVn
ZXBhZ2Ugd2l0aCBEUEFNVCBBRkFJQ1QuICBUaGVvcmV0aWNhbGx5LCB3ZSBjYW4gYWx3YXlzIGFs
bG9jYXRlIERQQU1UDQpwYWdlcyB1cGZyb250IGZvciBodWdlcGFnZSBhdCBhbGxvY2F0aW9uIHRp
bWUgaW4gZ3Vlc3RfbWVtZmQgcmVnYXJkbGVzcw0Kd2hldGhlciBpdCBpcyBhY3R1YWxseSBtYXBw
ZWQgYXMgaHVnZXBhZ2UgaW4gUy1FUFQsIGFuZCB3ZSBjYW4gZnJlZSBEUEFNVA0KcGFnZXMgd2hl
biB3ZSBwcm9tb3RlIDRLIHBhZ2VzIHRvIGEgaHVnZXBhZ2UgaW4gUy1FUFQgdG8gZWZmZWN0aXZl
bHkNCnJlZHVjZSBEUEFNVCBwYWdlcyBmb3IgaHVnZXBhZ2UuDQoNCj4gT3Igc29tZXdheSB0byB1
bndpbmQgdGhlIHdyb25nIGd1ZXNzIG9mIHNtYWxsIHBhZ2UuIEF0IHRoYXQNCj4gcG9pbnQgSSBk
b24ndCB0aGluayBpdCdzIHNpbXBsZXIuDQo+IA0KPiA+IA0KPiA+IEkgZG9uJ3QgdGhpbmsgd2Ug
bmVlZCB0byBrZWVwIGFsbCAiRFBBTVQgcGFnZXMiIGluIHRoZSBwb29sLCByaWdodD8NCj4gDQo+
IE5vdCBzdXJlIHdoYXQgeW91IG1lYW4gYnkgdGhpcy4NCg0KSSBtZWFuIHdlIGRvbid0IG5lZWQg
dG8ga2VlcCBEUEFNVCBwYWdlcyBpbiB0aGUgbGlzdCBvZiAnc3RydWN0DQp0ZHhfcHJlYWxsb2Mn
LiAgdGR4X3BhbXRfcHV0KCkgZ2V0IHRoZSBEUEFNVCBwYWdlcyBmcm9tIHRoZSBURFggbW9kdWxl
IGFuZA0KanVzdCBmcmVlcyB0aGVtLg0KDQo+IA0KPiA+IA0KPiA+IElmIHRkeF9hbGxvY19wYWdl
KCkgc3VjY2VlZHMsIHRoZW4gdGhlICJEUEFNVCBwYWdlcyIgYXJlIGFsc28NCj4gPiAidG9wdXAi
ZWQsIGFuZCBQQU1UIGVudHJpZXMgZm9yIHRoZSAyTSByYW5nZSBvZiB0aGUgU0VQVCBwYWdlIGlz
DQo+ID4gcmVhZHkgdG9vLg0KPiA+IA0KPiA+IFRoaXMgYXQgbGVhc3QgYXZvaWRzIGhhdmluZyB0
byBleHBvcnQgdGR4X2RwYW10X2VudHJ5X3BhZ2VzKCksIHdoaWNoDQo+ID4gaXMgbm90IG5pY2Ug
SU1ITy7CoCBBbmQgSSB0aGluayBpdCBzaG91bGQgeWllbGQgc2ltcGxlciBjb2RlLg0KPiANCj4g
SSBtZWFuIGxlc3MgZXhwb3J0cyBpcyBiZXR0ZXIsIGJ1dCBJIGRvbid0IGZvbGxvdyB3aGF0IGlz
IHNvIGVncmVnaW91cy4NCj4gSXQncyBub3QgY2FsbGVkIGZyb20gY29yZSBLVk0gY29kZS4NCj4g
DQo+ID4gDQo+ID4gT25lIG1vcmUgdGhpbmtpbmc6DQo+ID4gDQo+ID4gSSBhbHNvIGhhdmUgYmVl
biB0aGlua2luZyB3aGV0aGVyIHdlIGNhbiBjb250aW51ZSB0byB1c2UgdGhlIEtWTQ0KPiA+IHN0
YW5kYXJkICdzdHJ1Y3Qga3ZtX21tdV9tZW1vcnlfY2FjaGUnIGZvciBTLUVQVCBwYWdlcy7CoCBC
ZWxvdyBpcyBvbmUNCj4gPiBtb3JlIGlkZWEgZm9yIHlvdXIgcmVmZXJlbmNlLg0KPiANCj4gVGhl
IHBvaW50IG9mIHRoZSBuZXcgc3RydWN0IHdhcyB0byBoYW5kIGl0IHRvIHRoZSBhcmNoL3g4NiBz
aWRlIG9mIHRoZQ0KPiBob3VzZS4gSWYgd2UgZG9uJ3QgbmVlZCB0byBkbyB0aGF0LCB0aGVuIHll
cyB3ZSBjb3VsZCBoYXZlIG9wdGlvbnMuIEFuZA0KPiBEYXZlIHN1Z2dlc3RlZCBhbm90aGVyIHN0
cnVjdCB0aGF0IGNvdWxkIGJlIHVzZWQgdG8gaGFuZCBvZmYgdGhlIGNhY2hlLg0KPiANCj4gPiAN
Cj4gPiBJbiB0aGUgcHJldmlvdXMgZGlzY3Vzc2lvbiBJIHRoaW5rIHdlIGNvbmNsdWRlZCB0aGUg
J2ttZW1fY2FjaGUnDQo+ID4gZG9lc24ndCB3b3JrIG5pY2VseSB3aXRoIERQQU1UIChkdWUgdG8g
dGhlIGN0b3IoKSBjYW5ub3QgZmFpbCBldGMpLsKgDQo+ID4gQW5kIHdoZW4gd2UgZG9uJ3QgdXNl
ICdrbWVtX2NhY2hlJywgS1ZNIGp1c3QgY2FsbCBfX2dldF9mcmVlX3BhZ2UoKQ0KPiA+IHRvIHRv
cHVwIG9iamVjdHMuDQo+ID4gQnV0IHdlIG5lZWQgdGR4X2FsbG9jX3BhZ2UoKSBmb3IgYWxsb2Nh
dGlvbiBoZXJlLCBzbyB0aGlzIGlzIHRoZQ0KPiA+IHByb2JsZW0uDQo+ID4gDQo+ID4gSWYgd2Ug
YWRkIHR3byBjYWxsYmFja3MgZm9yIG9iamVjdCBhbGxvY2F0aW9uL2ZyZWUgdG8gJ3N0cnVjdA0K
PiA+IGt2bV9tbXVfbWVtb3J5X2NhY2hlJywgdGhlbiB3ZSBjYW4gaGF2ZSBwbGFjZSB0byBob29r
DQo+ID4gdGR4X2FsbG9jX3BhZ2UoKS4NCj4gDQo+IGt2bV9tbXVfbWVtb3J5X2NhY2hlIGhhcyBh
IGxvdCBvZiBvcHRpb25zIGF0IHRoaXMgcG9pbnQuIEFsbCB3ZSByZWFsbHkNCj4gbmVlZCBpcyBh
IGxpc3QuIEknbSBub3Qgc3VyZSBpdCBtYWtlcyBzZW5zZSB0byBrZWVwIGNyYW1taW5nIHRoaW5n
cw0KPiBpbnRvIGl0Pw0KDQpJdCBjb21lcyBkb3duIHRvIHdoZXRoZXIgd2Ugd2FudCB0byBjb250
aW51ZSB0byByZXVzZQ0KJ2t2bV9tbXVfbWVtb3J5X2NhY2hlJyAod2hpY2ggaXMgYWxyZWFkeSBp
bXBsZW1lbnRlZCBpbiBLVk0pLCBvciB3ZSB3YW50DQp0byB1c2UgYSBkaWZmZXJlbnQgaW5mcmFz
dHJ1Y3R1cmUgZm9yIHRyYWNraW5nIFMtRVBUIHBhZ2VzLg0KDQpBbnl3YXkganVzdCBteSAyY2Vu
dHMgZm9yIHlvdXIgcmVmZXJlbmNlLg0K

