Return-Path: <kvm+bounces-58380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D37CB9058A
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 13:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81A44189C128
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 11:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD9FA305053;
	Mon, 22 Sep 2025 11:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UuIVicO6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E34D2F9DBE;
	Mon, 22 Sep 2025 11:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758540452; cv=fail; b=LtG7pOlsm6drepLaTK+2HW/M7opmGVKCBihq9HTZRDpj0uA8giEU7olksA1+3YKPG3KFyO8/pzpPNQAPP9bMarN+CHCy9JYqiYi2Mq9b4dDbmkvkipPq6tTlqTD78stRPIAgSrw6C8S/gY7d0PnMQa0nhrhgYYNfNBWQwTHNQFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758540452; c=relaxed/simple;
	bh=HHk4gDUMiSkJK6ZfZpZLnmy/vMKmUNW6wgG6SzLMQJI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pn7S4l1uVKRovARJUeiLPSA/+ZgF9LIH5F8Ye9nwvA5LdaE6RLgbyerpIHtYPjRWGvL1h1tJYi/rqQ/DnOu+vT/tYCYPvcKcbRTeZDtJgLtVL2TkR7cjQNfOl9BOkAb1weKkGRYOF+reyDfXnjm0PEuqbhCwQhK/4r4O3ts60CE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UuIVicO6; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758540450; x=1790076450;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HHk4gDUMiSkJK6ZfZpZLnmy/vMKmUNW6wgG6SzLMQJI=;
  b=UuIVicO69Dp5+xgFrPIgOhZDaJV81wsGdm1dfuTJXkTgykKC4Emx0g0Z
   KcjF0fYdo9vu2VGxzJViIAMoMnzRQ4yPWowPKZeILViVUjbrmEZKOeBfj
   X/7GZH1ee9zzbn23qPfperSqfN4cVwWBF4JWu10iWSkXG7K8RzFq8ttTf
   rrV8Ypsdjz7pdgpQjLKAAmNx+0Xha9JJ/ipLC/FbsHEaDgneP7rgR9K5d
   /QM0Cynh0+bzRdk8NnwgDXZgMK0OF+TPh0up9Klo1Pe3FXEJlWsY/DHY7
   3gxwbVYf1WGq5E44wrwYj7YQYLYnAm/Xz74kjYpGXbJgqcrGCbYmHR0SZ
   g==;
X-CSE-ConnectionGUID: ILfvxgk0QhidtQUSKfZ5Qw==
X-CSE-MsgGUID: PUGc3pStT2iUHUjnxpEXHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="60016412"
X-IronPort-AV: E=Sophos;i="6.18,285,1751266800"; 
   d="scan'208";a="60016412"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 04:27:29 -0700
X-CSE-ConnectionGUID: M3vIGZWTSauNL367IeDH7A==
X-CSE-MsgGUID: +unmaEj+QjKr28yAOFXBUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,285,1751266800"; 
   d="scan'208";a="181702041"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 04:27:29 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 04:27:29 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 04:27:29 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.30) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 04:27:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IXCLJOYL5M5KAaLTebEMtdb42u65vIv9NiSp3YXSjnkLWOsWcl6CQ1BO3x4KQ5Rd7lINrJWjVVm9tWbURrS8VP+XEmMkRtKcCQnrA18+HEkYf980U9ycAuEtZJOJoBdMv5/GpCKMa3Gwi7GXao0uNRb4MEYshjHHAmWkDxP/ebPfuGIm3m7pU7ts9vit1qdoyXhoaE1ObDhaAEDnjkrlm5BQmxO47svaVyQRW/8pApv5N6QUmBsjFxHNqekwA8qee3rITPxesY0KntY0HD+6KWACXPW6VFc1Atzd1ZUk+wbJeyRS5F/DvwcCOb36JxdtI+EYoqyoxAd+CASJJZVfXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HHk4gDUMiSkJK6ZfZpZLnmy/vMKmUNW6wgG6SzLMQJI=;
 b=O/4qz5+jdUxHWqWuUe/jTsR4mF33giuneoBIjkqYm0mWVKO7yvx6CL2BPePGgK7y1SsF1RfsqB0M+xxKQ9wmB5wOpYLzG4LuplyG1aE5fnlQQbe7xIZihXe5V8QVRdCkLeO5/wOr4zAP60XXuCcYHA9MScnuZM2iG1tQP3FyvrUZW8KntJ/6cfOYPG5UoAkaJvpz6XjfzzeNH9I1C3D948YA3RfJDLab1hsN9+tQoe9dv2LNCUdHP2Qi1vtZ44lDRNZo1bQF+E+qroSQ9M3qzXomGFAaQNzIVnvy2Kzj7LpiyXMY2Uj5chIDmKyudssnsHBKuZD8Uhtgt+XcNofKOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MN0PR11MB6253.namprd11.prod.outlook.com (2603:10b6:208:3c6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 11:27:26 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 11:27:25 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v3 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcKPM1J09++rHOWU6lHVP1iNeXYrSfFdKA
Date: Mon, 22 Sep 2025 11:27:25 +0000
Message-ID: <348ae3abccbead93119ddf9451ef26292634f977.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-8-rick.p.edgecombe@intel.com>
In-Reply-To: <20250918232224.2202592-8-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MN0PR11MB6253:EE_
x-ms-office365-filtering-correlation-id: f7b5f3dc-11c8-436c-d47f-08ddf9cb01bf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dWFyMVVRaWd2dXF0djBLaWp6NGxiM25iYnQyQTJiRSswY0gxV3FiUVFobVBv?=
 =?utf-8?B?T1hRaUErSGxvV1B1UjhKT2IyVm5HcjJKVjM4RERMWEJKb3kzcnAzYkJZRVBW?=
 =?utf-8?B?ZHZnOFIvZkZLRXJjYUU2RitoSnY0S290bHBudEsxWE5SQXFORVNzNUNtNE0z?=
 =?utf-8?B?NjZWSmtyQ0JnOWJLbDh0YzNJbjQyWm5oZTlEVEI3WXF5ZUJlZzdiajEvM01O?=
 =?utf-8?B?aHBMZUxMSC8vNUpKZlJTSWY2REYwMjR2SjdzeGtLSnFiZHdvN1BFV3l0Tjdh?=
 =?utf-8?B?UkR1b3R5ckQ1d0dIalIxTW1hSkdvYzJQcjlPa3g0bW9PbXRsMDVYTVBmR0Vl?=
 =?utf-8?B?T01NclBOTnIwN0hOdUlwNWZzNHp5d0NWb25BdVpMUEMxWFExOWpTVnUyc3dw?=
 =?utf-8?B?VXg1K0N3TTRLY1Z0cFFMRlhRK3BpdlNkeEE0NU5uMkZDZEQ0WVpvVjlsU3do?=
 =?utf-8?B?bDFwVWdIVU1pUXg3ZXRZM1dRSXlTVk9ydWxSWjZMSmM1RGFHK2FaVWpkdkJ6?=
 =?utf-8?B?ZzN1N3RLR0pBd0xyWjJuVlpVSUdNaWN4WTU3N3FpMWdqdzBWMzBvTXVGS0xJ?=
 =?utf-8?B?Slg5S3BQamRHVndFQ2lHZzF3U1J1QUNrSDJ1OW5oeU5HN2JOMmJ0OGJwbjNa?=
 =?utf-8?B?WW5BVWY5MjNrZXp2d2hFdC9kdVJ3UVVOWlRINUpvNXdUMkFQNkZicFJkbGQw?=
 =?utf-8?B?MW1BMlI3MlAzTFI0QmxRMTl1dlJ2T3MyRnFqeTVlN1NvTGxId0N2NzZNNERq?=
 =?utf-8?B?R3hzdm55WU1nV29IY2txR05Qb0JlV3VmTmNkYmdMNlF5TC9ORDUvRnpONVFq?=
 =?utf-8?B?RUZaUE93L3ZHa2tsQ0RyWmNTVlFDb0IrNnNNL2NuVU11SWtHd0VQVnoyNFZG?=
 =?utf-8?B?eFNNVlNsZ1VMRnNBTThYVzRCdExDdmZEQlB2Z0REWjlBYVlBSHNvNzUvMEM3?=
 =?utf-8?B?ajhGUko3aEdjTWNrdVM5WVRDVDdFb2ErNm9KbHlHeXZQVnZ5UDd1K1dOVTJU?=
 =?utf-8?B?dE0ra3FSTk1BSDFsUDBaUkxRek9vUkdVQkc4RWhtcnd6ay8wUnBkdVJPSjJJ?=
 =?utf-8?B?b3lvVzMvV0tIQWlPcGNneXlGMEZGUEh3RnlXbFV1SzFtSDFTc2x6K1psTzhC?=
 =?utf-8?B?R1o2R3cwbkdzdGxLL3d6K1luc3Q0NmFmU2dYRDgxc3djNEd0QlA3S3Z3azlM?=
 =?utf-8?B?dlNBeWFpVXZsaUV3cHdJY3dBZkxvNjVyZzBpR3hDOWRpUWJ3d0lZVG13UTdC?=
 =?utf-8?B?T2V0TjIzK2dTVDJvbHNnRlQvaVV5d01mWGVrWmZlTitSR2Q1ZDA3VE1sdDBT?=
 =?utf-8?B?ZE9ZMjhjdmo1MldlN1FIb2VUMVB5c0JrMWJReWhjNU5vMHFreGsvTkp5dTBT?=
 =?utf-8?B?WXh5bTNpUnI3cG9ZblNzNy9DNlcyUTBpMW1kTWNiV2NVNlBucEoxTnBqV3pH?=
 =?utf-8?B?WmNWcGRPaWgxY1dQYlkwY05UMFpHSFluM2owYndkUElMZEt3T3Awd2IzelBF?=
 =?utf-8?B?WWpaeHhkdGJoSFpVUjNaaE5HaFp3RnVUUUJwQjd5SnpPNzE4WGNVaThINkYy?=
 =?utf-8?B?ZlpjdDVZSVMzNURldXlENDhBWW1NL21KNHJnT3haNHZoNDFnRTZWWWMwcGl6?=
 =?utf-8?B?cExQVkVQa1lRSGVFbmV6THBkT2tWL0FUaFFLWFJVTGhya0p4WGFUNlIzekla?=
 =?utf-8?B?R2NzNmI4Y3B1SE45MlB6d3lnMG04dklTZFNpL2pzSlo1cXptdkdySnZEY1B6?=
 =?utf-8?B?ZWxJckZRVElLVGNYT1pCak1QYXNidWlmRXFMdlZiSlcyb3FhT29HWGpLdlRp?=
 =?utf-8?B?WDNFclNjRTk2czlUTTVFMjNHRlJCWW43c0toaU9GalBpakpRWFFUU3c3R29h?=
 =?utf-8?B?UXM1NUhOdFZucDdsZGxwMjd6eUV0SU9rRGlVZm10amlwL2I0Sjc3TWdjaU9v?=
 =?utf-8?B?UE5uMHdxT3hFZmw1T2JaT25hRlJid2xFL29VTEJVQUxYT1BNMHl2alE5THQ5?=
 =?utf-8?B?OGlLYXhkNDBPVmdVa0hIdUVzTW5IRjFMTEhNT0hpeStQWjdObkdPSkNZanpu?=
 =?utf-8?Q?AkCOzf?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWZtMWkra0dHdzVjY3lUM0JrdExEY1RtZ2VhWTlTcGFNWEN6d1JwVWJhTlpX?=
 =?utf-8?B?UVBHSk5ZSTFURGVqbGFKNm10WEcrVU9pbTRzYVJRa29aT0lCdDhVdmV1Y1l5?=
 =?utf-8?B?SGp0NU5mUkxIKzlTRnhjMk9hd0xIVjRRRkxEcDVmWkt4bW1TN1NZcmtiV2t6?=
 =?utf-8?B?QlZsM2o4S2w1ajBXclUvcVU2dlpubWJ2dFdOeXNXU0xXZE1ZRmNvZitIUWFF?=
 =?utf-8?B?RDBkUlcxQ0VmSnp0N2ZCVWVDMUFpSG52cjhyYTdTcitUU1ZJTmJZRHBDQlhP?=
 =?utf-8?B?K1lqZGNDdmIyNXNrNVlvRXo5T2kyRGdoS2NVaGl6NG5FV09QY0IvbDBGcjV0?=
 =?utf-8?B?Sk1sM0d3M09WMGlKQXJDNkhBYXBkTjI1aHV1ZHRSblA1NndqN09HeHhKam12?=
 =?utf-8?B?clpGQVBlU1BhQUFKRkdCMVo2TEw0dFVMUnF1alM5cHZSN2YvaVVKUFhEdVB1?=
 =?utf-8?B?eTJxMW8yU3JKcTVDM2U4UzNma2dPYjQ4VUJ0RFhKb0xENllVK29Ua2NPd2NV?=
 =?utf-8?B?MUViQXNjem1ocHRlS3hhS3JJZmJ6MkZEQWc4ejErQWkzaXE0Sjg5Q1BQSnJp?=
 =?utf-8?B?STJzdlVPLytmdkM4UkwrNVN0OE9hZEJZdHlDSVlodkQrRkdRYTlnemd5UUkx?=
 =?utf-8?B?OHNUaWVFUXdEVStJdlp6bHNxdERtbWYzdnJ5WTM4UFdJQXBmdkhCazJQT0Fv?=
 =?utf-8?B?YzVIVVU4QVcvZ3dDVVprMlRHR1NFaWdMbytGdnNlWlU3WE9zNVBPOThJVEF3?=
 =?utf-8?B?aGhjdloxYnZmby9mN1cvbDJ3MzM2byt5SjQ1NnlqSllqQjI2ZzRqcXl5cFRk?=
 =?utf-8?B?Rm1jb1lpTzRzOWQ5L3A3bXhSOFdtb29jRXQ4Tk9sMGQ0Y05BNW4vS0VqTTdz?=
 =?utf-8?B?WC9aOEVURzc2R3VwWjZCQTE1OFlRYUh3L0NJbG9JNjlFTUEyMkxDQ1ZpRVJ1?=
 =?utf-8?B?bWdvUXBkUVk2ak9rUDhlUlNqUlU2a3JmSEhCKzkzMW90VHBUejBGSGQyeTRW?=
 =?utf-8?B?cmhlYlNNK1VOckp3Wm1vSFRRUkdmQUV3S29VSnA1b0NabXYvRTJnUU1idy8z?=
 =?utf-8?B?UFN3K01meHJZNjAvR2JST3R2NGRON3lMNWRRMTV5MlFRQlViQXhhWGFxUE1Y?=
 =?utf-8?B?Q0duZDBEZXdhdU1ZZlFXTXhVZHpEb1FuWXhTNmJVVGs5N2pvZ3BKL2haOXRZ?=
 =?utf-8?B?MzE2VUF3a21HcHhpblAySWlCOFZGbFRNeEp5dnltNG5Md0pyWElRbW1OOGlN?=
 =?utf-8?B?N2lxMUFQb1grdDl1b1VsdTJmMUpVWE9mVnUrWTFyTXo2UlNOOHFOQmQ1Qnoz?=
 =?utf-8?B?T25XV01wQWc5ZkJIVTlkSmRBWGJtRzFGY011a1hPTmhacEpEdko0WVoxVFpF?=
 =?utf-8?B?b0ZuL1RWdkFTcFAxQm9xbEtTL0prMllURXJYckdpQlh1SzZqd0Z1L3E0V0Q1?=
 =?utf-8?B?eHo5R3ZTL25yaXkyc1hYU1krYytUelV4ZkJCM2VHTE83YUZkUXFHRFR2bjJy?=
 =?utf-8?B?Z296bENQS1lxcG10SmVaZk1iZHRYb1BMMmNOMVNnbGFtQU5zWXB3b0g4K0NW?=
 =?utf-8?B?NmYra2VSdU1JU0xYLzRvV0VDZ0l1bzhPVldsdnN1U245LzBEUlpWanY1UzIr?=
 =?utf-8?B?QmRraGgySjlWblhOR2lVeXRUb2hrY0lNamE4anBPL2JLcUZDTkRaN1hJU2tD?=
 =?utf-8?B?a2JvdW9TZjB4Q2JuUHY0YmcvaVFiRHpRYUhBUFh1SXhwNWtWVms4NEVEQ21m?=
 =?utf-8?B?dlRKYVp4eXc2SGN2WUlUWFhrb3RDQzJiWnc5dXNkZ1dGemtLczAyTVJ0NWs0?=
 =?utf-8?B?dWdwendrRXZJeEJFbEtkVXY4cWNsTXdIdUdveVhxQWZzV2tsR0lnYnBEVytv?=
 =?utf-8?B?TDJRUXRHTmRqS0FtSVJTYWUwTm1XalF0ZFdFL2NFRE9DaGdlK3k4anQ0b2ov?=
 =?utf-8?B?amhWM3BQNjU5NUpxMDVzWnNlRmhCcDdlTkJiSXhHMHZsS0V5TWRNYmc2N0Vx?=
 =?utf-8?B?eWV0S0hGVXphWkR0YmJhY0UwQmtWSlY1YXRvb213M1lmblRCRXQwRzN2NnQ1?=
 =?utf-8?B?VHF3a1RKR2h5eVMyRnpZODNpYXhKd2JTNFZhOVE0V2VvNE1iUXRwaGMyMEJF?=
 =?utf-8?Q?2tL3YZ0v3puc9LjX/eGBBAAlS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F30D44190EF5D4499B066254DEED6EFF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7b5f3dc-11c8-436c-d47f-08ddf9cb01bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2025 11:27:25.9413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ifK+0IveJW2THLoKgViI1Z2ZZ+7p1zC4m7fMQ7La/NrCRz7p9UbBpxRR7VcGupa55nYJ3tdU2TmFMixWRfwawQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6253
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA5LTE4IGF0IDE2OjIyIC0wNzAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gK3N0YXRpYyB2b2lkIGZyZWVfcGFtdF9hcnJheSh1NjQgKnBhX2FycmF5KQ0KPiArew0K
PiArCWZvciAoaW50IGkgPSAwOyBpIDwgdGR4X2RwYW10X2VudHJ5X3BhZ2VzKCk7IGkrKykgew0K
PiArCQlpZiAoIXBhX2FycmF5W2ldKQ0KPiArCQkJYnJlYWs7DQo+ICsNCj4gKwkJcmVzZXRfdGR4
X3BhZ2VzKHBhX2FycmF5W2ldLCBQQUdFX1NJWkUpOw0KDQpUaGlzIG5lZWRzIHJlYmFzaW5nIEkg
c3VwcG9zZS4NCg0KPiArDQo+ICsJCS8qDQo+ICsJCSAqIEl0IG1pZ2h0IGhhdmUgY29tZSBmcm9t
ICdwcmVhbGxvYycsIGJ1dCB0aGlzIGlzIGFuIGVycm9yDQo+ICsJCSAqIHBhdGguIERvbid0IGJl
IGZhbmN5LCBqdXN0IGZyZWUgdGhlbS4gVERILlBIWU1FTS5QQU1ULkFERA0KPiArCQkgKiBvbmx5
IG1vZGlmaWVzIFJBWCwgc28gdGhlIGVuY29kZWQgYXJyYXkgaXMgc3RpbGwgaW4gcGxhY2UuDQo+
ICsJCSAqLw0KPiArCQlfX2ZyZWVfcGFnZShwaHlzX3RvX3BhZ2UocGFfYXJyYXlbaV0pKTsNCj4g
DQoNClRoaXMgY29tbWVudCBzaG91bGRuJ3QgYmUgaW4gdGhpcyBwYXRjaD8gIFRoZSAncHJlYWxs
b2MnIGNvbmNlcHQgZG9lc24ndA0KZXhpc3QgeWV0IHVudGlsIHBhdGNoIDEyIEFGQUlDVC4NCg==

