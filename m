Return-Path: <kvm+bounces-68095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C18FD21A5B
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 23:45:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B7304302DCA7
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 22:45:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB703AEF37;
	Wed, 14 Jan 2026 22:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dlkUTRh3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03BF3AEF49
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 22:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768430692; cv=fail; b=KJ8GWeJlDLPxsti5k+4FopyvdalrptMsVe3RYsHlJhbA8jgyykBrilzJ7q12VRPSpYK47jsKwtI5nsuMCJeVDmxNrmy7hPeDG/+Z0rg/XVYLGI+fCniGhxDw7o1IF/vx99mF7lvCZ26RyuouGt7NfyhTtbIWvcocC0C3dpCZdYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768430692; c=relaxed/simple;
	bh=qRpDPycYLPv9nIlV3umbMgTWB33uVHu1TAaUEMd0Jjg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X/YI3P5hwOmJnEARyuVKFM++G18H/KiYzciMi07r3J7fl+AKLQr2zEn5JUUWTsJwG/CtSR8bjqAzclJXSfjB4GGJp+UkWU6OKhoJ8P2ZvV1F0z6qmGzNTXlam06xomlCq3oUXJ2l6odbMlCiZPwtlzPh3F1ZNB38J9Kork1j8c0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dlkUTRh3; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768430688; x=1799966688;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qRpDPycYLPv9nIlV3umbMgTWB33uVHu1TAaUEMd0Jjg=;
  b=dlkUTRh3jVwxpoW5uEDEqase219WwwILEUXhRgACztW1yHNNRAY1iD8C
   okOme8TkAprzAaTQr64lxUpG4vES73wHl5SWu4HbsCtLC/3hBPlegXgOL
   ImZhcV4xNIwrKeyjEPDFbjmLyltAfFG2+dxgpOe4T7YtOBC/8Psf4Pk4E
   5NYzCa4ipyT68iNsuoRO+XAbAQYb/hFpyjNs2e6ebq2P0NhhugttK6zTX
   /w8VJKY3wi1zu8Dd7X8KTHQJa/GG6D7trw/TeO0O7Auca6EMh9xa44Y/3
   SG4vmJHeF29qGfOQBQtVZgxRWJr4OSwTMM7gPbh2/Pb9KYtb1xF8Xdqia
   Q==;
X-CSE-ConnectionGUID: bfngfiQbSaWUkXBTIyVCcA==
X-CSE-MsgGUID: 7LH0Ld3sQ+qPjIfPcYiNyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="80848482"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="80848482"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 14:44:40 -0800
X-CSE-ConnectionGUID: npQSEhCqTi+X0Dk634U0qA==
X-CSE-MsgGUID: 09LYF6f9TyupdFVHR+UMJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="209263297"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 14:44:40 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 14:44:39 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 14:44:39 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.70) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 14:44:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=scgfr/qAFQijpmOjSSEd50tR8gNOpZBlMCcBpMaCPvbYJqvAegLPMvO2/VhaN2V/LTbYiUH3C1CvImEm+K7K5IefQjmTYQpM8Nv1XvEPQNqHYbX0AYwlIsdzmyHaxUEWd1VbDh5f07czetW+0XH1mtZH6XT7CQg0wPCxfInCszPmfGuHJM98WjdhBAcPWnXF0OJY9YL2h0va08ipckY94d4JlvzmrXEOrghTZKgvYU346rkgAlJ4KR7vwTbNyFQxsCgUuAXyoM2R4hUTy07rEiDAC0RBj6fucB5xyZ9ThhOLfJCzLdfNnYncnvq8yxiT5dqZMgpJZHvkayR9to/mUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qRpDPycYLPv9nIlV3umbMgTWB33uVHu1TAaUEMd0Jjg=;
 b=XPdPBATBaKk89y6qHVIICHO0EqJXE7QenQEKDmcMWxlzhgCQyJfDy9G+NwsZbLhQvCsY/1GDqNxswbsUQcX2uKsz0M3YO1e+m08y5/eVJG/F58Zy4/l9CbV67V96bpXsGXSvR6m1ener8nZfP+/J89udfvR8mSSiwy4R2hgiBDdnG81y2gNRkTZJ7L59xxFuco84JPS2+Jch2YYeeO06/27MxnPZkcZgcn/4c8RL+pXoyWsAgEmMyhWVv+ZcgoYfwfEiIIt9rUEO5t4/X1D3rB8Os1u0Va5LlnBT6FQ7drX+alY/3qYHdg5sHaQ/ecGLVz2gehiMOGDRGch1U3i3Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS4PPF708A6BB3E.namprd11.prod.outlook.com (2603:10b6:f:fc02::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 22:44:31 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 22:44:31 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>,
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v5 8/8] selftests: KVM: x86: Add SEV PML dirty logging
 test
Thread-Topic: [PATCH v5 8/8] selftests: KVM: x86: Add SEV PML dirty logging
 test
Thread-Index: AQHcfg3Ksg3b7MbuXEKHnzTmKR2E4rVRmA2AgAAvnoCAAIrnAA==
Date: Wed, 14 Jan 2026 22:44:31 +0000
Message-ID: <76d16ce0d02a61ac8482b189ba0c811aa4b2cc67.camel@intel.com>
References: <20260105063622.894410-1-nikunj@amd.com>
	 <20260105063622.894410-9-nikunj@amd.com>
	 <d035cbc079a777d25863b78e9583c238fff03f9e.camel@intel.com>
	 <6b2c88b2-ab73-41b2-a467-ee8f16a714b3@amd.com>
In-Reply-To: <6b2c88b2-ab73-41b2-a467-ee8f16a714b3@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS4PPF708A6BB3E:EE_
x-ms-office365-filtering-correlation-id: b12d7068-a95c-4abb-9759-08de53be7b91
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aXpIb0RvaUJ4UytYUVQ0cFd3UjAxUUphZzBON0ZVTXhGcWxaQ29xN3g4Qm81?=
 =?utf-8?B?Nlp4UDF1SUhjbk03LzlwLzBCcWdtcmNkaS9DcUJyYXJFWjVweGhmbDF2eGZB?=
 =?utf-8?B?Zm0ydzRBRVhHemd5d1ArTFpqVHdDdXZCcm5rMjBHWG1RU2tmYjY5TENRNGQr?=
 =?utf-8?B?NHh1Wk00emR2TDFtUTByZVhIVkFSazZiRFhzVWFZN0VaQ3BOb1BEb0dua0Ez?=
 =?utf-8?B?S3VHY2FFUFAvaTNpNHNRWjg5ZmNzYUIyMlk4TG9VSGxCWDZKUDlHTUszU29q?=
 =?utf-8?B?TGZOZFczMHpyWWJqdSs0aXd5WmlmcUtmajVTRkxVRzlYTVU3SVN3VGtOUTZk?=
 =?utf-8?B?SW9TZHp6WjZHNkhQaXlONStGV1Iwd05iK28ycUVWekpjcStDaHNrUTFlWXlJ?=
 =?utf-8?B?VENtWER1SXdoYy9VRUxZeXRCQ083RmlXaVgyTk1LL0VsbUsyMHI4UFhvTTh1?=
 =?utf-8?B?ZjdObE1IOU1vQmRnMDliN0N3MFByWVpzSmozdEZLUzBLNXhOdzRTU2FnTmdR?=
 =?utf-8?B?TytxVVR5MnlLZmsvNXNtVmVFQktGb1p0WjhTZHVzYVo4aEgwTy85SmQyVmNi?=
 =?utf-8?B?RVhRTVRjZ2FuVEZDVUJKcm9rYlEyaS9LV3U3MHZuc05QaFhxWUh1dTFFb0wx?=
 =?utf-8?B?QzJBbHlHOTJZemlkYXdqUEIySnVCdnQzbThjL3EvR1RHM1VFY0ZTVU1hMHpR?=
 =?utf-8?B?NWV0cFIyQXFpWWNSVWIwSWIzYk56a1JtMGZaRnZkUzE1K1FYanU0WjNvSGFi?=
 =?utf-8?B?ekJNOTk0NEp2eXFUYkFhcVAzZXNMMFlnWDBOQUVlWWdXUVYvVnNjK05oRmlj?=
 =?utf-8?B?Z09TRmVJUHZvODZ4c0JYUFoyV3BCd1Q1Z1VYMi8yN29IajdvZkxQVlNCT2VL?=
 =?utf-8?B?MnMwNWpUWWVTVk5XL0h5RlJVckYyS3YyaTRLUG9WbjFQOGN4YVBjZFcwWkZk?=
 =?utf-8?B?OEFrWGl5WUJUY0Fqb2hoV3U0OUo3dUVyNHYvSUxNZldLczk0UEt5MEdQS0Zy?=
 =?utf-8?B?TG9LWjZIYjJrL2ZJcVF2bG1kQUgySzFlN3E0VjhDSm1IMmFtSVRtRnIwSG9I?=
 =?utf-8?B?amxselR3QldJV1MyQ1dBaUp4VERuTzFRRDBOT3E1dmNFVjdvQ0g4ZC9lSUNx?=
 =?utf-8?B?NFV2QUdrdXF4V0hlaUlkVWxQWDZVaGFEUE1XUmpjRmFWU3RpQnRBaEdnRUtx?=
 =?utf-8?B?MWYzZ2M0enA5aDJteGNhaFExeUF1eTFNS2xweHlINjZKMkNvTEt5U0pjTXJQ?=
 =?utf-8?B?TmtLcmRIUkxLSnBOOG00YXZlNUdaYXF2akQ1ZHBDKzlMczlQSmRNY1VRSFpw?=
 =?utf-8?B?ODhHNU5JbXR2YTBBOVYvN1Y4Qy9WVXUzQzVQMFZVVlJBaHRxQkNjYkIvR21Z?=
 =?utf-8?B?NEswbmlXQ1RpY2kzRlhNRDZsbC94bWgvaUJSdDRmTFpqRXhFTDFOcEt0Z1kx?=
 =?utf-8?B?dlc3ZXFLNHVPR1V3bCtBb0sxMmNaY09YeDhiVENTV3FpV0RVMEhPRFRXWi9I?=
 =?utf-8?B?d0VnWTlKMExQWStOWjZlNFI0QkQ2NDJlMjNPbW8wQzV1QmdIZExHd2hGd2RI?=
 =?utf-8?B?Mnd3MitIVnV5d1VKb2NtMXNKa25YQ216OXBSL00yS0hNMnlZL3kvVlE1SG1L?=
 =?utf-8?B?NDZ6MzRLZ1JEeDFLZ1NjVUJOclhMSUVmWlVqMUJsT0k3eE5oUEttYjJIYk11?=
 =?utf-8?B?cTkzNE41UmZnNCtZRk5SZk0zUlc4eDNUejV6cDA4cXNMYnNBWnh2WDlQTkdO?=
 =?utf-8?B?c1NuQnlzOHNIYmlnZkUrWk8reEVDekoweXlaelNuN05ka1B0SHFVV3M0TmM1?=
 =?utf-8?B?VFNLUndpUVFrZ1JYNnAyZC9YSDVlR092L2toSmdDZkNJR2xvUWlVSFdsYTJI?=
 =?utf-8?B?akFwQWJOWjdvNkhEYnE4OW9FWng0UnJCTHBpN1VOWDZMdTVyOUxIenA3RnFQ?=
 =?utf-8?B?QmZMQTBoM1ArK3NpbVNJblVweExjQTZxQTkvamZrK1VmN3orZXIyQkhQMVFw?=
 =?utf-8?B?NTZ4T05lQjRMNVIzRFJQbFYwWHNVc3RuT3JKbHp5NE5pNFBHMi8rUlRqUjBs?=
 =?utf-8?B?OUZqb2FDSGl6MzV5TVBoTk9yYXZzblNrWUpRNDZ6K0VCYkxPdWRaOEZvQ1A0?=
 =?utf-8?B?R21hMytrdTE1cFFLVmh0ZEhUSGpNSXFheC83b0d2aGlxczdIdnV5bXRMM1VJ?=
 =?utf-8?Q?bGwH0HbxmmK2A8YxHwu17gk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWtzbGIrQlFldlV3dVZ2c1RzQmRkQ2Y1bnZsemhkMEdNM2NyandkSG9YaW41?=
 =?utf-8?B?OUU2aFZIdk1pZVZuWUtQOUNSQlAvcDFPdTJ6RUZLeU9TWmdSUFFYOVhsTlFZ?=
 =?utf-8?B?OUpTYnNDQXhkdG5pWFl0bEtuUkRTckt3bmRyTnBCNGp1SG9DWnJWTVYycDIw?=
 =?utf-8?B?VFA3bnVhZFA3bWNrdHk0ZDZuMmZ0V1RsTFRoVFpWSmxXQ0svUTNKVCs1UUtI?=
 =?utf-8?B?ejRrYmUxRWZpZkNXWWdaalNLd2tGditpODBPZmF6dUM4MWFMbGNMamhMcFhI?=
 =?utf-8?B?ZmFBZWNqcWRXLy9KeEkxR1F2OXhXMmtIWEY4VzRNbnR6ZXZ1bUdWeEF3ZFlK?=
 =?utf-8?B?SlZNc0J5TER4bG5Kc2wxRVVwWVZXcWJSVGdyN1lpMWdUVGVZUWJJQTduQW1o?=
 =?utf-8?B?R2E2OXBzZ2g5UmRzSFNKN3ZkOC8xYmZYTzBPN2gzUW9jWEVmcTRiZW50a1FJ?=
 =?utf-8?B?QnZBM09vWGJiMTRXREVZenVIVFZxN3dNNDZGNlRza2Nsc2t6VzJ5OHBPMW1J?=
 =?utf-8?B?d21hdE0wMW5GR0dmTkJ0LzdVc2Y3RytpdzVnRkVudUwweEswL3VrUlR4QVpn?=
 =?utf-8?B?enR2aWNKVkNpVmtHRXJFbWFQc1VqODhqT1VaK2dCWUdSOWZzdFBDdENDZGl6?=
 =?utf-8?B?MDBkcjBqT2hvSVRDQ1RqRThIckJTVEdYeUUxR1ZjSmduT1VyQVh6b2lqdVla?=
 =?utf-8?B?c25DSTkxWkxFV0I1aHZtKzlxWDVycFN0d0dGdzFxR0RDdjBJY3dpaTNaTG5G?=
 =?utf-8?B?ckRTY1E3cG41Wm0rSmg4aE5TY3hoSjdKcDBBNzRjZVU2SHJBNDk2VkNSU2hj?=
 =?utf-8?B?OTMweVBSTXJkZTlJck80S0ZlV2RlTE8vTmRTdXd4bWd3c2crT0pnL3Eyc2Vw?=
 =?utf-8?B?UjBGUWJCZU56WTEyR3doeEY2Q3gxSE40VE96NjFXMG1GSU00eWVtN1hQKzhT?=
 =?utf-8?B?QWtWamh6RDVPNEc0NVJZZnF1QjlIeWoyQ0wwNXJLSFVKZ2diMzZNMFZ4UlQ3?=
 =?utf-8?B?NDJZYitYVEZuNWk4UU9lTXpEenhCRTYwYXB5VXQzUnJPWVFiekZpYkhwSFMv?=
 =?utf-8?B?WUtXUDhRK2crbEVvQU9JNUlHRC9pbkhBZi9QdFdUOGQ4R1NoUkVMMjFSWUEz?=
 =?utf-8?B?NHhVWFlDVDR3Y0d0cExJWUxXRE5zNHpGdnFDcFJsdkV6R3UwOEpHelpndG12?=
 =?utf-8?B?WVQveFF3a1lmblhHdHhIZVBGQWRWZWRNMU1yTTlYNGN1SGtNNmlKMW90bFZW?=
 =?utf-8?B?TUZaMmh3R3NXRDl3dHhRbUhnSFZKaFF1QWNrK2NITXdYS3g0TXNreldYc0RV?=
 =?utf-8?B?NnllakQyMCtoUitXcmdKNmpocWk1RUpYa1VUS29vYXhwUUEwTGFYM1R5L0g0?=
 =?utf-8?B?VzA2ZWt3cTB4N3Q0UUJMSkJBK0wvZXhuMytDL3BwNjFRWkRYT0tIQTBBd2VR?=
 =?utf-8?B?NktEdkYzWWgwNExTWXdGWEZCRVB4UWhGbjdpK3NDblNuaU5BQnFJd0Y4c2R4?=
 =?utf-8?B?UzU4bHlmaVdkcDlTUU9ZcmMvVUJvd09kbkgzTnVkRkpnU2hOZGVUK3M5VEVt?=
 =?utf-8?B?MTVvTUt2MEJxeVg3NjM4djJZTTlKd1hiVXMvSG9mTDNyblRncTlLQkpSL1Qx?=
 =?utf-8?B?OUtib04rK0VDS05tNWxORGlBMnFQY3h0YlE1VmZKUVZzUUVNMGFMMHQ0MXRi?=
 =?utf-8?B?QUU1K0hEeDNjZ0pSWWdCcUpxUjF4N2hjb1p1TlZ2WFp2V3RucnVneS9vVGV6?=
 =?utf-8?B?Y0N3NVZoVG5Sb0ZoS0kwaUxqb2tJM1g4ZVZDNUFaMmNQUDQ1MW9ETkg4YXFD?=
 =?utf-8?B?N3RhdFRXdUIyaUNoZE1YK2grVlF0aFNsQU5MRWYrbFUxQnVLZnU3aVluWHNC?=
 =?utf-8?B?SGFDQS8rcFVjWVFrazlWVEYweFpKQnZoOFdKVXgwR3pnZVF4bmJqU09TRkZo?=
 =?utf-8?B?cCtRdndUbjh2aTBzZm10cElPTDVyK09laWEzR1NoKzBhS3lGUVIwTEh6cGFC?=
 =?utf-8?B?VE4wRC9uRTdHWTQrWkxhZDZNWkExdWVyZ0RGWXRYWFFVclhBQ1J3Zy9sVk5K?=
 =?utf-8?B?aTI2Nmk5S2FaU1doVUJhTlVvd2d5em9SMEI0YkFoU0prcC9iTWZWTlQ3TEVR?=
 =?utf-8?B?aGNaaE9WWHU5YmttY0xnL1ljcERDbFoxM1diR1R5SnoxcnlEMW8zeW4yMXBR?=
 =?utf-8?B?VzFITVQyZk42WDIzZFV2Q2lKTWFMeVE3QTIrQ0QyTzFJUDJ6bmtDTFRhTWI4?=
 =?utf-8?B?YU9pUGtpVktDb0hkeFN0ZDhHaHE1VWdNWWJYaDM5b3YxV2tZQzNGZFJXNjYw?=
 =?utf-8?B?L2V6dFNYZVlnVFVoLzBYbFNPSmlQZDhoMTdwSVFDR1RwQjlURUU5dz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8BCFA1408FC73A48B87B05CD6E99413D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b12d7068-a95c-4abb-9759-08de53be7b91
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2026 22:44:31.5086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BdkQaB4MD/K+6mL4CnudEOZxkidN9vN1BDC/dlcf6bxsNO/X7JV04boHG7VXgk5wFvQmiAfUP6ZlmLw90frXFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF708A6BB3E
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI2LTAxLTE0IGF0IDE5OjU3ICswNTMwLCBOaWt1bmogQS4gRGFkaGFuaWEgd3Jv
dGU6DQo+IA0KPiBPbiAxLzE0LzIwMjYgNTowNiBQTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBP
biBNb24sIDIwMjYtMDEtMDUgYXQgMDY6MzYgKzAwMDAsIE5pa3VuaiBBIERhZGhhbmlhIHdyb3Rl
Og0KPiA+ID4gQWRkIGEgS1ZNIHNlbGZ0ZXN0IHRvIHZlcmlmeSBQYWdlIE1vZGlmaWNhdGlvbiBM
b2dnaW5nIChQTUwpIGZ1bmN0aW9uYWxpdHkNCj4gPiA+IHdpdGggQU1EIFNFVi9TRVYtRVMvU0VW
LVNOUCBndWVzdHMuIFRoZSB0ZXN0IHZhbGlkYXRlcyB0aGF0DQo+ID4gPiBoYXJkd2FyZS1hc3Np
c3RlZCBkaXJ0eSBwYWdlIHRyYWNraW5nIHdvcmtzIGNvcnJlY3RseSBhY3Jvc3MgZGlmZmVyZW50
IFNFVg0KPiA+ID4gZ3Vlc3QgdHlwZXMuDQo+ID4gDQo+ID4gSGkgTmlrdW5qLA0KPiA+IA0KPiA+
IFBlcmhhcHMgYSBkdW1iIHF1ZXN0aW9uIC0tIFdoeSBkbyB3ZSBuZWVkIHNwZWNpZmljIHNlbGZ0
ZXN0IGNhc2UgZm9yIFNFVioNCj4gPiBndWVzdHM/DQo+IA0KPiBBcyB0aGVyZSB3YXMgYSByZXF1
ZXN0IGZyb20geW91IHRvIGNoZWNrIGlmIFNFViBzdXBwb3J0cyBQTUwsDQo+IEkgd3JvdGUgdGhp
cyB0ZXN0IGFuZCB0aG91Z2h0IHRvIHNlbmQgaXQgYXMgcGFydCBvZiB0aGlzIHNlcmllcy4NCg0K
T2ggZm9yIHRoYXQgSSBqdXN0IG1lYW50IHdoZXRoZXIgUE1MIHdvcmtzIGZvciBTRVYqIG9uIGhh
cmR3YXJlIGxldmVsLCBidXQNCm5vdCBhc2tpbmcgYW55IHNlbGZ0ZXN0cyB0byBjb25maXJtLiAg
U29ycnkgYWJvdXQgdGhlIGNvbmZ1c2lvbiA6LSgNCg0KSSBoYWQgdGhpcyBxdWVzdGlvbiBiZWNh
dXNlIFREWCBndWVzdHMgZG9uJ3Qgc3VwcG9ydCBQTUwsIGFuZCB3ZSBuZWVkZWQgdG8NCm9ubHkg
c2V0IGt2bS0+YXJjaC5jcHVfZGlydHlfbG9nX3NpemUgZm9yIFZNWCBndWVzdHMuwqANCg0KU2lu
Y2UgeW91ciBwYXRjaCAoSUlSQykgYWx3YXlzIHNldHMgY3B1X2RpcnR5X2xvZ19zaXplIGZvciBh
bGwgQU1EIFZNcyAoaW4NCnN2bV9pbml0X3ZtKCkpOg0KDQorCWlmIChwbWwpDQorCQlrdm0tPmFy
Y2guY3B1X2RpcnR5X2xvZ19zaXplID0gUE1MX0xPR19OUl9FTlRSSUVTOw0KKw0KDQpJIHRob3Vn
aHQgaXQgd291bGQgYmUgYmV0dGVyIHRvIGNoZWNrIHdoZXRoZXIgU0VWKiBndWVzdHMgd29yayB3
aXRoIFBNTA0KIm9uIGhhcmR3YXJlIGxldmVsIiwgb3RoZXJ3aXNlIHdlIG5lZWQgVERYLXNpbWls
YXIgdHJlYXRtZW50IG9uIEFNRCBzaWRlLA0KaS5lLiwgdG8gY2xlYXIgY3B1X2RpcnR5X2xvZ19z
aXplIGZvciBTRVYqIGd1ZXN0cy4NCg0KPiANCj4gPiBJbiB0ZXJtcyBvZiBHUEEgbG9nZ2luZywg
bXkgdW5kZXJzdGFuZGluZyBpcyB0aGVyZSdzIG5vIGRpZmZlcmVuY2UgYmV0d2Vlbg0KPiA+IG5v
cm1hbCBBTUQgU1ZNIGd1ZXN0cyBhbmQgU0VWKiBndWVzdHMgZnJvbSBoYXJkd2FyZSdzIHBvaW50
IG9mIHZpZXcuICBTbw0KPiA+IGlmIFBNTCB3b3JrcyBmb3Igbm9ybWFsIEFNRCBTVk0gZ3Vlc3Rz
LCBpdCBzaG91bGQgd29yayBmb3IgU0VWKiBndWVzdHMsDQo+ID4gbm8/DQo+IA0KPiBZZXMsIHRo
YXQgaXMgY29ycmVjdC4NCj4gDQo+ID4gDQo+ID4gRldJVywgYSBtb3JlIHJlYXNvbmFibGUgc2Vs
ZnRlc3QgY2FzZSBpcyB3ZSBwcm9iYWJseSBuZWVkIGEgQU1EIHZlcnNpb24gb2YNCj4gPiB2bXhf
ZGlydHlfbG9nX3Rlc3QuY1sqXSwgd2hpY2ggdmVyaWZpZXMgUE1MIGlzIGluZGVlZCBub3QgZW5h
YmxlZCB3aGVuIEwyDQo+ID4gcnVucy4NCj4gDQo+IFlvc3J5IGhhcyBhZGRlZCB0aGUgc3VwcG9y
dCBoZXJlIFsxXS4NCg0KVGhhbmtzIGZvciB0aGUgaW5mby4NCg0KVGhlbiBJIGRvbid0IHRoaW5r
IHdlIG5lZWQgdGhpcyBuZXcgc2VsZnRlc3QgY2FzZSBzcGVjaWZpY2FsbHkgZm9yIFNFVioNCihh
c3N1bWluZyBbMV0gd2lsbCBiZSBtZXJnZWQsIGlmIGl0IGhhcyBub3QgYmVlbiBkb25lIGFscmVh
ZHkpLg0KDQpBZ2Fpbiwgc29ycnkgZm9yIHRoZSBjb25mdXNpb24uDQo=

