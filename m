Return-Path: <kvm+bounces-52810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AD2AB096DB
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 00:15:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 089AA4A1B93
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 22:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67894224AEB;
	Thu, 17 Jul 2025 22:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qk+wgQcL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160B8A94F
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 22:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752790543; cv=fail; b=IYmm9DTEt0iuSv58uqxfF37FvJnlICHzaRbu1ixyZcqkB2z6j2AwvSWMyOTJEhzmNucP3L9zkTZ1Vm+pKABJ/hCznrU5sIt9vigSUT79kctI+9q2DLOoqU26wNkbFA9555NIOEN6uXw6XzXBgd+2VRMcW68MmSHUgGLipVmgPxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752790543; c=relaxed/simple;
	bh=mulLQGIiF5BJI+Z5Dp04LCpka84Qng4CZQ6uV7iC1kg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H1QjQx1GreXych0geUsUMOI/7RaigsrPyBpHpEBLUQ7mO+l3yiOQp8Js+yX9/VHUomEVza1bTOIoF8fG895SLPik1IyXy8+TXfwxiZBRMhzVDIJD+YokXb42w9g27TQlA2UY8ipl4et4G+NqyhI6GRpfYyCvWXogmGKkPz/Ts4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qk+wgQcL; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752790543; x=1784326543;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mulLQGIiF5BJI+Z5Dp04LCpka84Qng4CZQ6uV7iC1kg=;
  b=Qk+wgQcLRR2Z+oiqhwA6jhg9rywbQxsEU9gGSoy78D6dOGEku4VVFk4n
   4mWiuHLiQAvNjNBVkLZsP9LTLR4ffq42MCDSrE1tIOXweb1CbSVj5tF6A
   yZ8XECOUgHXpnwwIRzuKCIoFDyj48KyE/9Uts1NSAhJEJ9GtI+LnrXBMj
   DRzmvI9uQEFZ4HrfEf2ac4LXwoV/gFvoFfvUY5G7MekLQyqb8tyfiU9Vh
   x52pI7Y0t+ggyM46Q37eiAbt8mYATEADZCrqLxxVnHzeO7ucC9AMO6ksk
   uElgQhxi1xSap/12BNLuB5DcMzCpHioNJJxnzu2hz1BiSvU7hWquQsDX9
   A==;
X-CSE-ConnectionGUID: ijRcGzIgQ2GmwDGIIV6O8g==
X-CSE-MsgGUID: KbIk06/MQOehIXmH5LT6sA==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="65338715"
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="65338715"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 15:15:42 -0700
X-CSE-ConnectionGUID: AdpNLql+Qa6sv4CePxgkbA==
X-CSE-MsgGUID: AuuwYOmbSTSq3WIsTtgltQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="188889904"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 15:15:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 17 Jul 2025 15:15:40 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 17 Jul 2025 15:15:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.65)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 17 Jul 2025 15:15:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RAcWCqS9eLqJEQ7gMReMtqLRy0L2JYCsgBiQDRkUsm6EbU7MXVbmCC0LEqoqy4kGQdNja4WFXia3K8XxQ8uzKAm0ycBGd7BQrz7J5BP4mqnvzue3rP0USZjYBOQhRMAviVFH4U3katKK/v9cP1ZP/L+nMEehaT2OiXE4496wtbFfxZUTAXxem1PvvmnnH5nTHLkmQseogHIQHRDW6OsCEqzLsoga9VzmvF+kG2sQV4rhkO+P4vARHsoIl+pW0bKeLoS4qexwziqnkckM4G4TmP8RlZT1LA3Q5wE0C0mXUNMb1cf0mw88/irXfN6BFHv1a5NLbfnHvqo0efXMY4mNpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mulLQGIiF5BJI+Z5Dp04LCpka84Qng4CZQ6uV7iC1kg=;
 b=r4XfDQpmJGOi53Ea80ECcMnGpwhaIoTiiLs6hjwikOYyK0iZVPrw/Wo64z5dvY7hIfhsSrlWkEX291Td3kU+GEKOUTc0qAOMK5BNd7+x7IJl9b1frOY1Ftl18LF34e5ZH+oUID2Wpe1YrLMrJlyHybqTdnS74jTZT9hAQvmW9cyxGTVnivtl0O1glEBdjI2uu4EPlUjuB3CFj6mnx9g/gTAXGiMSHQgkmkKRJJt42Gz3QP0GjuLNgpKbwfvkhGzY4CNmrhqFj81ZiDrx3MDGk9EV4Wzv7eudVk6SIk52mn/K+K4ptzbhJwJhU6QYMWOU6kS8B/XfvyWTWLu6Az31jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA0PR11MB7209.namprd11.prod.outlook.com (2603:10b6:208:441::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Thu, 17 Jul
 2025 22:15:37 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8922.037; Thu, 17 Jul 2025
 22:15:37 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "vaishali.thakkar@suse.com"
	<vaishali.thakkar@suse.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v9 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Topic: [PATCH v9 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Index: AQHb9hgv5JYmLMSUskut2n0HpoTUJ7Q25HKA
Date: Thu, 17 Jul 2025 22:15:37 +0000
Message-ID: <c3f7c63563f2f2c3dedafc496d134ca435c96d4d.camel@intel.com>
References: <20250716060836.2231613-1-nikunj@amd.com>
	 <20250716060836.2231613-3-nikunj@amd.com>
In-Reply-To: <20250716060836.2231613-3-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA0PR11MB7209:EE_
x-ms-office365-filtering-correlation-id: 237fa132-5a81-4ff7-5b08-08ddc57f756e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TVNNSnNQakJuSi9mSm5Jb1BXZFovZHFzdlJueGNRQkhpYmlibzZhVjFRL1Rs?=
 =?utf-8?B?Szh0V1Y4M2RqZTNGT3RVSTNGL2tURnY1SHVYZVlXSldGWEFwWDlHYWNuU2R6?=
 =?utf-8?B?MkZsNDJpVlg4TW9hS05mb3NOQnNJWWtYc3dkaTd4ZjY1bGk2Q0NhSTRsQ1lB?=
 =?utf-8?B?STEyZ09VOEtzb3lKQ056ZUExYnU3dDdhNUNzekdaK3lRUkhuRFJQOHZOVFNN?=
 =?utf-8?B?SVB5WmFJNTlScXdEcGlNekpoU3l2QmlXN0lPNTBmZGcxbEM2WWh0ZG5FSEFt?=
 =?utf-8?B?V0s5RHBUY2syQm13Z3B5NzVhN25Mb3FxeGcwNEJ3allZTnVDN0F4QzB5Rm4r?=
 =?utf-8?B?dWk2OXlMVnlNaDRjLy94R2YxL3pWc0lEZkZGYzFzaGcxT1hjTjVDNS94ZWRC?=
 =?utf-8?B?QnJaUzJueXFvcEpJdjg5T1hLT3JNenNJQ05adTdibktuUWdnL3pxV3BnUUd5?=
 =?utf-8?B?M3d6NFJGZHdJdFhicWE3cnJEOVpkeEtNQkpQSVREMSt6RytsQ2s5UFk4Vmts?=
 =?utf-8?B?RUVjUVNod05zOHUzWHhqNEtYVFhOODhaOVI4RW1HNklWY1IzQlc0ZGV1TDNa?=
 =?utf-8?B?RndwREZ5LzVFSGJsZlJtblNsZkRMa01HeWZReEZvVi9hMGMvbGwzNFFGZU0w?=
 =?utf-8?B?cWJZT09ab1ZLTkpacEszSHdGbllWeERHWmN4bUpScGc2N05WYjFGaU5DMjJr?=
 =?utf-8?B?YWhONUkrM2xya20xa3NGSE1PZ3pZbUhuMVNMTE5DdStaYzhQWnF5ZE1XVWdT?=
 =?utf-8?B?SVRHU05nSGo2c2I0SityVC80ZlRPZ05KSkptTEJ5dUtqMU1MU3hqOExSbXlr?=
 =?utf-8?B?WTVTYzJ3RmtmTU1iVUxiOHBhL25rMVhNejByaUNqUlltV29iQTM3UXZjS2po?=
 =?utf-8?B?NjQ5TndHcmNTcHhtSHBmakU4bzdMYTdYcFRMcm9talhYZ2dtVnp1NGdZTjA0?=
 =?utf-8?B?djZnaWRYaVBUU0lUNWorWVBUNGM4TzhRcDhya3hSRkpMOHBJMU8rMkQvOEww?=
 =?utf-8?B?UDJpMXpLWnlIRmVEZDdkTFdYdS9NclE5NStVbXpvNmRIczlJaWRhQmdrMmVO?=
 =?utf-8?B?bHhsdWhjZUlPZzV6K2hZRURPMFZGaWJnTFFkRXJyaUpSZE4yQlBSTGt5WU1j?=
 =?utf-8?B?T0NJMThWbGUxcjBadVBIUy9NMTA2UDhUWXRqNmdNWmtOaXdpZmRubFo0VUs3?=
 =?utf-8?B?bk9GcVFJb0QwNWFnTmxiM3VzWUhHd1pKYW04SEZqeVJDY0ljTEFPMVBRNEdk?=
 =?utf-8?B?QWVhc0xxWlY3dmh6R2NIUXpBVFpkUjU1ZEpLY2V2azRkT3RPZjVacDBkRGg4?=
 =?utf-8?B?VHR2ZmpwbDJXMEJaR3hqM2dlSm9YK2I5MmdVSDI5TzBPZzdBQjExdWVxZXo0?=
 =?utf-8?B?U01aQzQ4Y21reU01VEtoSUFubm8zZVRsOXpZS1QyUnI5NlR3WXNzNFpOMDJ4?=
 =?utf-8?B?SktNWGVWbDFHRHgzTkZ1ZnRHaW1FQXB3QUxvRXFNVTF2UEsrdHJjVDc4NzdW?=
 =?utf-8?B?SFZ3ZDNsK1dvYkV1QTN0ckFxN2VsaVg4NmxGWnVMaXJiZXRZYmZPYXU3V0I2?=
 =?utf-8?B?TEphRzRlcmRIamFNWEk0dktpZkZoWTVGK3FaWTBPOVRPYUJYcVdyczVNL25M?=
 =?utf-8?B?N1VsTUtOSTNXb2t3SzluWks5RHR5WTVKUUJOWGlkandNSEhKOExLNEFyVGZq?=
 =?utf-8?B?R3BzamhlWG5GRWFpOStPaEo3MnZTY21UVWIxZ1FaRGUxNlIzWTY3WUN6ODc1?=
 =?utf-8?B?eEJrNmxjblEreWdGaklYckF3R29HY2oyN29mb21kRWhTRVJMVDNlT0EzRWE4?=
 =?utf-8?B?ZVJaR29RaWZTRGVyWlEwWVJNRXdCaVR2V0prdlc1cndlVG5UUnBPUThwa2Q5?=
 =?utf-8?B?R2NxOW5icXNqOWtzSG92NmVFc1NoZEZSaWNyclBNdmg2VG1ZL21ZZmgrZENC?=
 =?utf-8?B?RjJIdi96Y3Jrd1Rrd0RZK2VqakQwdjlrWEpDci90TXp3NnJDMW5BM0JpdUg3?=
 =?utf-8?B?VWtFNUhyWVF3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OS95a2hFR3BBdVp0a2ZrNi91dTRPNkYxYjIweVg3NzhUaHdJZ29ESHpiZ1Ni?=
 =?utf-8?B?R1lDUjZWN3RBVzN2Q1UvVm9sdXo5Vjl4cW9XbnUyRU4rMDBNT0JkT1VlQWk1?=
 =?utf-8?B?QWlES2FMVUUzYTZ0SVRhQ3o4cG03c2hQRHBQK21EdHA5L2pGM3ZMMndoeTh0?=
 =?utf-8?B?V0FHZGFiRjVuVnNleHV6UDV0bGIzN1pac3NwbGsra0dKYTJFZkxza1h0NnFZ?=
 =?utf-8?B?YTVPNEp1UXVtRkRaOW81L2RJdUN6WEJ5aEVZNzRPem5FTHJhQXdneE1mdXlC?=
 =?utf-8?B?ZEFORm8xalB3YmpTN0ZMaGE0Z2dxR1FVa2V3YStJdVRUTHBseG9QaGUyZDlB?=
 =?utf-8?B?T0ZhQUhhQlcrVlpYWG9zMmUwZ09MQ21FWE5BdWZJdWpQMktUaUVKQ2JCVXBS?=
 =?utf-8?B?R0orRHJ2Vld1VXFNZ2Vlb3lmMHhiT3RnbGtGbTBvRGpxSE9BUnVrb2w1YXZP?=
 =?utf-8?B?L0VUNWZncmFqa1A5eTNNcGJtRDlKdWZaNzhOM3YvZFVrNWpIN2hHTU1WM0Q5?=
 =?utf-8?B?T1dBcWNDbjFyaFNIYytTU0JDRW5LSndkeVlXOWJEb3dYVWhRNWdMcmI3cGtL?=
 =?utf-8?B?Y2NmMlU4ZFF3YnZDenh3U20vR292ZXZkbHBWcjVyd2xncXdMR0FUOTlTSE9I?=
 =?utf-8?B?bkxHck01akErby9pM2JCT3lId2VPTkJiOHZoeXZkeUFGZmN0Yk9zSGQ1MXRL?=
 =?utf-8?B?ZzhWajRpL25iRklLV1NTYThZbk1mWkU2bExCM3RFM040WVJ6VEpuVVlsUFp6?=
 =?utf-8?B?cGlicVQ1bC9GN3M0VmJuSHM0VEpqbGtRZW0rQnVWOUUwSndHeHJ4VXJNdnF4?=
 =?utf-8?B?bW1ISHB3alJqRklkZFVZVzFuRDRyMW9WcE43YWZCNFpsMFZkWXZodGE5dkZv?=
 =?utf-8?B?cHk2WFNxQ3c0YW1uN2k0VHJ1QW14MFpqREVJWXl2eldxeEU5cmQ4WTFlb3hJ?=
 =?utf-8?B?UEVNd3h3d24ybHZrTXphcUVhdmpOTlRKZG13NG5zdXcvU01XVE5CckQ4VUZj?=
 =?utf-8?B?SEFJbnR3Y2R5anhyZDhvZzFVbmNCYm5uM1BTYktBaXl2UFJuUE14L0x6N283?=
 =?utf-8?B?NG94Y3BhbnQvRnZiNmVaOEd2UGJCQitJdW1UNy9yUzhaMUVaQUU4QzFRRXBE?=
 =?utf-8?B?and5SXZ5M0piNERIeG5VRk03OXRDdzQwZUFZdTBIQWNpK2dhaHNFY251K2tK?=
 =?utf-8?B?V01KdnZwbTl3YUIyU0N6b3B5ckV3RW5Ic1p5NTRkUWNlbFlnTUxhdFFlbEM4?=
 =?utf-8?B?aHExbFhhdVVHRzdVKzVIbGtPMGNnNDdqMzlONFlvZzVWYkh2L0tsL2c3L1Ez?=
 =?utf-8?B?LzBsdzlocFdGN3NGSGtnamJ0VGpvOFBjRkF6U1djRVh3Z2dtUGliZEVhT2pF?=
 =?utf-8?B?WUJrcXhqWXBKeTlVWkpLUTM1Nm1HNURzZ2dOMENNaklmLzlUQVliaEc2WFo2?=
 =?utf-8?B?MG9EMWdTMDNRYUFsMnlBZ2N4Y0pBRk1GVG5pTzUzVytnNTNEOHAwZGRFcHVq?=
 =?utf-8?B?UTNnNWxrNXVmdXQybnRzQlVVSXBaRzkxVjNZRU9GTEtlZ01vdWloTFN0dVV2?=
 =?utf-8?B?N3pONlRaM242Qmk2eG1CSThvbTA1TFZLdU16dnFBQTFpSm1SK1ZHK21uTE9n?=
 =?utf-8?B?VlhHcHlVUndscEtYQjNKQXpJYm9kYUpyMERGUG5VK05MR3BPeklFbThHS3dG?=
 =?utf-8?B?L3d1Q3NscksxdlY4bnhhVnJwUUVUZTBwQjhuNngyaUNxbVFLbzhNbU0yeUFZ?=
 =?utf-8?B?Z21ISU5aUjFibXM2OUxheTZ5eVdmdytrOHVsUGE2dWNmUEFRMjN3VWo3MGsy?=
 =?utf-8?B?bG5QZTdpYWd4SUUzNFdFMGRrT2FrWmZYOXV6Y0hMSzRGYWhTdGhzajhHdGRI?=
 =?utf-8?B?SUdMc0h0YzAwTEtqSFBsYXB4RWFUR1FXUjZ5bVFqSDdlT0FOSXIyaldSM05O?=
 =?utf-8?B?cFk5S0FkWWttZXZnV3lvbjQvNTFCK3F6QmFENCszYVRaQStUUGN3V2Nvd3h0?=
 =?utf-8?B?N1dQeXZlUmVvbGpUT2o2Wnl0cGd1cGRmeGtXWW1SMWZmdERMZUZMblpSWVdt?=
 =?utf-8?B?NFA2OU9qNmdRVXdsM0tVaVZYRTZreWtzbmM4T29qVnZzQVQzRUtWQzRHT3hp?=
 =?utf-8?Q?dSoQrakdgX+JX1hG8SeAf/LA+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2472D3EADB96684887A16208BC26A33E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 237fa132-5a81-4ff7-5b08-08ddc57f756e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2025 22:15:37.7568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xyKWDtb1dYpBdFpfGN7SxNjI2/DcjfgCe0whD7ZdMoL+UDLOY6QF5jdMrf4C3fWx68mm0QmA4J79AZLErjojwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7209
X-OriginatorOrg: intel.com

DQo+IEBAIC0yMTk2LDYgKzIyMDcsMTYgQEAgc3RhdGljIGludCBzbnBfbGF1bmNoX3N0YXJ0KHN0
cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9zZXZfY21kICphcmdwKQ0KPiAgDQo+ICAJc3RhcnQu
Z2N0eF9wYWRkciA9IF9fcHNwX3BhKHNldi0+c25wX2NvbnRleHQpOw0KPiAgCXN0YXJ0LnBvbGlj
eSA9IHBhcmFtcy5wb2xpY3k7DQo+ICsNCj4gKwlpZiAoc25wX3NlY3VyZV90c2NfZW5hYmxlZChr
dm0pKSB7DQo+ICsJCWlmIChXQVJOX09OKCFrdm0tPmFyY2guZGVmYXVsdF90c2Nfa2h6KSkgew0K
PiArCQkJcmMgPSAtRUlOVkFMOw0KPiArCQkJZ290byBlX2ZyZWVfY29udGV4dDsNCj4gKwkJfQ0K
PiArDQo+ICsJCXN0YXJ0LmRlc2lyZWRfdHNjX2toeiA9IGt2bS0+YXJjaC5kZWZhdWx0X3RzY19r
aHo7DQo+ICsJfQ0KPiArDQoNCkkgdGhvdWdodCB5b3Ugd2VyZSBnb2luZyB0byByZW1vdmUgdGhl
IGVycm9yIGhhbmRsaW5nIGJ1dCBqdXN0IG9ubHkNCldBUk5fT04oKSBhbmQgcHJvY2VlZC4gIEFu
eXdheSwgbm8gcHJvYmxlbSB0byBtZS4NCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1
YW5nQGludGVsLmNvbT4NCg==

