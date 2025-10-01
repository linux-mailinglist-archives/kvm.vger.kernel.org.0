Return-Path: <kvm+bounces-59280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A59E8BB0082
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 12:41:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1A561893EB5
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 10:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C7F32C0286;
	Wed,  1 Oct 2025 10:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WYNn2IPX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CB3296BB7;
	Wed,  1 Oct 2025 10:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759315261; cv=fail; b=Ity+rwO8xZPpclOsI8zHAi0sg9m60PCgmtBKevF/EOlxo6Z56pVyR0LIvyyLbeByTapS9bm6UWbMWkE4x5/SXzKX05huZk7TNv2ThGzFc0tPPU1999izD7y5WxT59AbMSb07JpcTx1LE0n3wrmFUam6C10In/RF378Mc9p+QGQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759315261; c=relaxed/simple;
	bh=n1MSOBc3Xt+2RNbbPuRVMxPJ9VxQYpFAlFM5ETS0YUA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UMR1SJ87cqikcouvz0dr6csMadpOSxCSnqauTazNb5k16xHkcj8wc2lu74nLgtoaRdxOx1a85yxTYaapaG7/be6CgOdkngRhGIyz5Fdm3nCM8m2VAQAFboUdtFxiqq6kChb2FiqvbDMKX73HEtlsfX4CXEtRwCRFeglyqU1o6Lk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WYNn2IPX; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759315260; x=1790851260;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=n1MSOBc3Xt+2RNbbPuRVMxPJ9VxQYpFAlFM5ETS0YUA=;
  b=WYNn2IPXWzIs5xQmnVnl8MsE/QeKQzwM8DzN+zhEHQA6tpw4PY1ux8G0
   zyNZYmeC5PU3TcgVCGQmNv7hNM7eL+fSow3VKdFbSpH7eyUZQs7xHWd/M
   0N2n+xbTLKsoIBvWvrtwGRx1BW7umzOMHBMUZMars0tmHy9VfLC8qMhch
   vBGY1IBz5WyySVuCMWwGnni5PereaUvE86B6GywRSIKsMjmACmNBpeRMO
   Aq+BwCf6KoafDmr1awN8BvMb5BEE8HiFpCnaFETBAL8CI32fq4HJyt844
   SPog3Bgb1YkL6QI0d5AxSq9ubdpbXv9XTYFC28HOkFvcUADYEmOZkV7bw
   w==;
X-CSE-ConnectionGUID: YWtLDV8TRieoWfBiCiZFxA==
X-CSE-MsgGUID: Y5i2sQCyRMqmHv+VAiseKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="61477624"
X-IronPort-AV: E=Sophos;i="6.18,306,1751266800"; 
   d="scan'208";a="61477624"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 03:40:59 -0700
X-CSE-ConnectionGUID: aeDxnrOMRDmw8V5p7sk+JQ==
X-CSE-MsgGUID: 5uHBFEiGQ4OBvbc4GrqpVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,306,1751266800"; 
   d="scan'208";a="183167702"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 03:40:58 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 03:40:58 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 1 Oct 2025 03:40:58 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.54) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 03:40:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ezMxvOr1ozVg/adnMVREy7AWEQjXh0/3yzi9xIpB0bC58Tvl9/ptmiUSqPKtZATyMLEFjwJQidGB5Zat0QSQ+eLCbii917p7A6Ui+11x1HSdqNyFYlNmFC6GnBKu81+wp4pStBKM7pCi2JeguO81PYQp3c9+GkWZvvGpM8bIPbS08U1XUOkWnuJo+qYpWZOyV8HTnXVskg3pbXb+W8+GbC4NIlz/1KRPt76xuAL0gOQ02Rcdlb93xRZXxfsAFhnWaPNcs9QFMSjCo2/g6vseKDFyrRdVA6jCNH5fOZVmkmi/7IaJS1C3LCFoxokYL79WuHWp/5SO0VtMRKxvaQFbfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n1MSOBc3Xt+2RNbbPuRVMxPJ9VxQYpFAlFM5ETS0YUA=;
 b=lEQ/VJYs/NWWnMhfp/l2tarf/fQ4FatWMFOVE4jkdb49Y44CNSxzgYiVIbSHHYtb9p+FauWNTs5NXG4rIt9Sjmakss6Y+cQrtqenM+4JiHuwHXgi4eVUCLsNrL+yHcXe9M7G+9eMkigF9QzKMlFaSt5TqdUSF3fbZvVb7uf2EF4T88WfrW+dRxhtBGOs3ElSRJO/kcs614I3TynEXwtL6GKpyXf4R7AnjwddAV51ux2/DAGzJJ1R+s8ux/PMhHJAV6D80yIbmSE2AitfOF8Vs4uEG1cx4orwKe4kVBbL19QPovmTwHObNsO766hBSE3+6Gy/b9lh5BRK+JQg+/whEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CH3PR11MB7275.namprd11.prod.outlook.com (2603:10b6:610:14c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 10:40:55 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9160.017; Wed, 1 Oct 2025
 10:40:55 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
Thread-Topic: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
Thread-Index: AQHcKPM0s1whGFHeVUeSuikKt1/NBLSaGz4AgAZuegCAAWNMgIAAI4YAgApzb4CAAKnXAA==
Date: Wed, 1 Oct 2025 10:40:55 +0000
Message-ID: <894408f8987034fcbe945f7c46b68a840d333527.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
		 <20250918232224.2202592-7-rick.p.edgecombe@intel.com>
		 <f1018ab125eb18f431ddb3dd50501914b396ee2b.camel@intel.com>
		 <e455cb2c-a51c-494e-acc1-12743c4f4d3f@linux.intel.com>
		 <7ad102d6105b6244c32e0daebcdb2ac46a5dcc68.camel@intel.com>
		 <19889f85-cfd0-4283-bd32-935ef92b3b93@linux.intel.com>
	 <ca13c7f77f2d36fa12e25cf2b9fb61861c9ed38c.camel@intel.com>
In-Reply-To: <ca13c7f77f2d36fa12e25cf2b9fb61861c9ed38c.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CH3PR11MB7275:EE_
x-ms-office365-filtering-correlation-id: 0d628e5e-bdf8-4625-532a-08de00d7001a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SFNKY29CS1FUalFudElHdk8yekx2aTVPVFRQWWxqMElqQUdoWEFxY0MxQ2NB?=
 =?utf-8?B?d3Y2ZFgxcXZ0bTlTNEJmTURETEF0aXRHRHF3QjFJNWdtQmxCS0F2SnMxRnhx?=
 =?utf-8?B?QnRWZVlLZFhVOTBWYlJiTzNCQXlrYnBxMDBIVjd0SHJwMTRYM1ozQmlBbW1M?=
 =?utf-8?B?SlpZZVFlUVhudGFyb3kxSXM0TmdrV0lZcmNnN0pQOSt5dVVFOWdtZEhjQW9w?=
 =?utf-8?B?eE13YkN4andMZmtmSlE4YzA4T3JjQ1hpRitxdThSTExjUkgxazhjK3E3anJ6?=
 =?utf-8?B?QUpMMHN1UWNNd1pNTzg3ZlhVblNQMzdFZ3FPY0JOS0NaVVl1S3JLVDYwQTlQ?=
 =?utf-8?B?T1dGc0o4Ump5ejlBYUVCNHVYWXV5ZDN6amdGK1RNWGlkTWQ3MUxjQnBtYnpU?=
 =?utf-8?B?ZzQwNkNHZGJOUHV2MU84b081UFFScStCRkFZWkdJS2VUU1M1dnhsQkdFaTcw?=
 =?utf-8?B?M21LazA1RTBNN2pvOWJaYldBRDdVdnBsbHRSZlEwSWFRNzZIWlgwZkpJOG0x?=
 =?utf-8?B?Qm56NWhsOC82QTMwbmxHczFFdTl6MCsySU5INUFTRzBCYVducXFpeEtjMmxT?=
 =?utf-8?B?aU52K1FvclBVd3JYeG94Nk1BNGlTUnhhWU1XYnppMEhxUkx0UUJqdnZHSVZk?=
 =?utf-8?B?WmxsOS8zWG5KNGFUL0FaSjBRWjZrdjVBUFNHOGtBVGxVekdVU0FBZWEvYkdB?=
 =?utf-8?B?TjRzVGpIOEUxVlZLUTlyOFBDZFJNNUVIM0NlTnBGSTVyZ1BEOVQ5T0xQNHBq?=
 =?utf-8?B?aTZsZlloTkRBSGZWYjhXNVoxRXIzZmtnUEt0NFdpaGt5OEMxNzZ6OHZqVmJ4?=
 =?utf-8?B?ZmtqUllNbFNqWG1uSWdxM0o4TzI4M3RPYTlyR3VqejVQdXprckxuSXRvcEps?=
 =?utf-8?B?SUFJbFBMVUZBV21OWGhPYjZPZjJjczZRQ1RNa2FBczY4TmVKeW9yMjNCQktn?=
 =?utf-8?B?RnpRaW8xNlc5TGdXSmc2eGNKa1NIVFBkM1BteGkwbHd4TGgzSHFScWo3SW5p?=
 =?utf-8?B?OTlWWWF3N0szZkM2bjV2SlJOTHlnK2dhRG5WamtZLytaUDlvRTBYUFhUc1RU?=
 =?utf-8?B?dytpT0lLQ0ZHY2I0VktjRm94bnBXNjZDOFQ1SjZQWm55UFVGZWY0UmIxcUlV?=
 =?utf-8?B?cXJhL1dkTDdqMjBINEp5aFlyVjVIanhuTW9XRlVHNjlCVHBXL0I0elFGVFlY?=
 =?utf-8?B?MFFOUmhPek44QXhNdXZ5dEZxV0NubC9TUGtzNU1Fcm1Jd1VLMGp0eldTNlhI?=
 =?utf-8?B?eXJRZ2poV2dJd1FIempBSEVIdUlxSWRxS0liME10Y1Babk80RUJNUXE3WlFT?=
 =?utf-8?B?SEVWUlpzRkNIL0Y0ZVhjOHhqcHc5dFpEendjMHppMnZ4YlZBSHppbjRrbmN5?=
 =?utf-8?B?Wm9OeVFxVmRmYmxwZTU0bnl0OVV3eUxFU0FnVU45L1BSN1lDeFliaWFuZHd5?=
 =?utf-8?B?WEdLRmFyL084TUJUZVdETEJRcTl3VnpvOVdueTZGYlFFTVE0UWh3SzYrRkZI?=
 =?utf-8?B?T2s1MmVqZEx0eTMvaUcyL2x1dXJGVkNVdHNxUm5FdDQ4QzQzNkNDcThDdGZ2?=
 =?utf-8?B?SWV6Ny9xa1VmZnI4OTJ4VGxLS1ljeVRaWCt5SkFxQzArTmhHd2JWS0lDZWUx?=
 =?utf-8?B?TVZIR2Vsc3p5UldRTjJuRFBtQjZHVWxvMlJVS3JKamJKSktxWDdBMWlHUE9v?=
 =?utf-8?B?NUhSdUlCbWRZWVhPcXQvK2xWVzI2SDVtUGxXTFZOamFmbDIyNGZhQ1ROd0RM?=
 =?utf-8?B?eENDY0taQ2tjQnRHNHBvSW8vOUl0RmRlNWc4OW45RWc2ckl2WU5aSzdMYno4?=
 =?utf-8?B?YnNISWYwVUpGQnFvVk9LTGlLU1A4cEYzd1dJRXdCOXpxQlM4eDlrMmkxdkR4?=
 =?utf-8?B?ZE1XeGw2Q1V5ZlBXQzZMSU52K0d2OEpFK3RrcDZ4emwzUEM0d2dxVGFxSmcv?=
 =?utf-8?B?QlhhYVJwVGxkRGcweXFMcFd6K3NyUHpxZnBBQ2hsaEQ5SFBDTzJTa0FVWnc4?=
 =?utf-8?B?S0EyQTlHUWVheG9EKzRJU251NlRIS2xvdmJMTXAwUmNNV2gxT3QyLzVGWldj?=
 =?utf-8?Q?kgwDwr?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?enYyNjA2Nks2QkJDYzcwZy9lKzNvcTY3VTZlQVFlWXUyRWNrVHc1VExEWWl3?=
 =?utf-8?B?ajdTdTk2ODJ0d056NkVMNWZ1eC9weTB3aStubEZMNnAvYmtOd1RoRTVvMzd4?=
 =?utf-8?B?eU5QT1czTGNRendSQWphUnNFaDAranFSNVZkeVNQaXBYd0JhVkt5ZFczWDg3?=
 =?utf-8?B?UzJWbzhweHBxeXlTcUpzZXlkU0Z0aGFWaHZtc2J2cHZOaSs0aE0weDJ3QTRW?=
 =?utf-8?B?c1gvUkpYR3diL1ZrSzZ1Qkl0YWtZUGZlTmtjS0ZJbElWQzlQcHZZTVZSM1ZZ?=
 =?utf-8?B?SzhPQWx4WmFYVG1OYmRtWlNEZm5yY0xwU1Y1eXR2UnpWM3kwZEc1czRoN1o3?=
 =?utf-8?B?QThyd2R1UEhNdzIyb2FWK3VCNjhGUDZpRkcxWm5YTURGcXZTd2hGNUhQVlY0?=
 =?utf-8?B?RDdTUWxzQkthaXlVeGdTRitOTWZCUXhUc09PVWxRcytpR291RXBCcGpqK0d5?=
 =?utf-8?B?dmlNeG92Zi9DSEZENk1IVHIrTk40SUw4Yi9iV3NKMHp1TUltM2RIOHIvVUxC?=
 =?utf-8?B?MzFvV1g5STEwWmU4ZW43WHN6UmxJdm1xaU9rYlNwVndqdGc3amszVkxWM3Fr?=
 =?utf-8?B?OGZ3MTdhOGt1aDdrTTR5amZ6ZEdVd3NyMS9JVzYxa05VQUJONG54cWRyQ0tQ?=
 =?utf-8?B?TURNRzVsUkhpcmQwcEY2Vi9TeTR4Yksyc1RlOVVYV3FoWDBOUmJNSG9FOUZQ?=
 =?utf-8?B?US93TmV3MElpRUI3VHFpMnRrcFF5SDhHN0praFZnZTlHOUVIS20zMjJsZU5i?=
 =?utf-8?B?cjRGT1RkWFBnMzdzc0ZLRThDTHllMjExOGZUZ0pZd25DU0haaTE4V0gxREc2?=
 =?utf-8?B?V3dDMVpERnQ3RzAwU2lLSFVIa1dOMmJiY3Y3UHhEUWJMczBrM1VMTGEzWjQv?=
 =?utf-8?B?aTRpTjBySWFjQm1Fd3JZTm9hWUR6Uld6MkIzNzU2QVkvSEVHZGNoa3JLQjc5?=
 =?utf-8?B?MVNZaVFIQ2NSZnJSQmFnRmxBSEdkQ2pPQVhoRi9kWWIvdUY1Wm1YcVhuZHVt?=
 =?utf-8?B?a2U3ZzZCOVBPNWRjV05LVWNGdTQzVjIrbnFWa284aitlZkhxbEtnWkJ4VktT?=
 =?utf-8?B?VTc0ejNuejRaYlltQ3AvQkk2K3ZEelk1YnZRdTdFRi9FWjFJR2tqaHBUUWlU?=
 =?utf-8?B?b3J3K3ZRUnlnZ0tRMmJYS3Q5QUFnN2pIaHdMblIyOUhvalhFdFBzODR0a1BB?=
 =?utf-8?B?YXBaakpPNU11eVluNFN6SXI2THFuVWFVZEtWbXJRTmwxbnRTY0JrM1pEOExh?=
 =?utf-8?B?ZG1ucUNhQ3RkNmdVZ1JkbHVxemEweHpiMmdMbkhwaE45dUxnczBpVUZoWkJk?=
 =?utf-8?B?Z1EwUUh6MG9LYkZKYVVpQ2VRVzBKMm5YMDluL21zT01mR2JSNFdCVW9aa2dS?=
 =?utf-8?B?SjFOVnQyYUVvN0ZiSnVLd1RWUlZIcnptdXQ2WWN1MXZBRVFoNmxrZ1EyTlE1?=
 =?utf-8?B?MTY0SmhZYm0vTTdqdnYydzZrWDJYY1VIcGtkNjhmckJwcVowZWdCNno1czdG?=
 =?utf-8?B?YU8xb0Z6UnQ1OFZhWXJwdm5sVVdNN05iQm1EaUJLanFidmtNKzRSazN5cUFY?=
 =?utf-8?B?dFRyRTlubGM3Z2R4d3MyRm0rR3Bjb0hjZnJtcFlNUjlFWmxkTGFlR2pkRWsw?=
 =?utf-8?B?c0J4NEphN3Jsd1dlUVFqOVlHQStiS0lIUThxbVlKZXJLdUxEaVRYYi92STBP?=
 =?utf-8?B?K2FIMU1zQW9vNGh0NUdFNjF0OWxhLzdWcmpYZ1JGeXd0ejJGZHI3NC9VVldk?=
 =?utf-8?B?SHIybmR0SEpyeVNmWWNxWFFlWTFSUEtKcVgvcXQzRGlzZVNiU0RGVCtDZmVD?=
 =?utf-8?B?bHFWUTdkSGNaZEdQUGVCWWN6TFlMMmdodFh2RndFZ09tSHRTRlhQUmtiRGhj?=
 =?utf-8?B?V3BqWjJ3V2ZXbHhKUkYyWFFmbld3MERuMU1yT05SS3BhQlh2d1M4VnU0SUVE?=
 =?utf-8?B?M2R0NmkvMTRXS3BJUi9zblRjMnM0Z1Erc1l2NnVCd1dFQkxxME12Ky9DWDN2?=
 =?utf-8?B?MFlSazQ0eEtwU29BZlpMMk5UOStaelFma09VTFVvQjBIaW9tb1VoWGdzM1dm?=
 =?utf-8?B?ak40Y0NXeG8vNlRvYWlpc1lFYkxuOGVnN0JNeTZtUEx4WCtVdzVYRDdBb296?=
 =?utf-8?Q?FoLMI7r/d0XvRWyIvH4YpsVyT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <32B768C6EA520642AF3839275D7DE284@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d628e5e-bdf8-4625-532a-08de00d7001a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2025 10:40:55.2783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0nfQhIXbYSmMEapfbwQyvGiSjyKsNI6uOftbpOSn/4fV1e3AY1odnM79g67Yz1veIJ32N8TCgWScNIdbniFFMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7275
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTEwLTAxIGF0IDAwOjMyICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gV2VkLCAyMDI1LTA5LTI0IGF0IDE2OjU3ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6
DQo+ID4gPiBUaGlzIHdpbGwgcmVzdWx0cyBpbiBAc3RhcnQgcG9pbnRpbmcgdG8gdGhlIGZpcnN0
IHJlZmNvdW50IGFuZCBAZW5kDQo+ID4gPiBwb2ludGluZyB0byB0aGUgc2Vjb25kLCBJSVVDLg0K
PiA+ID4gDQo+ID4gPiBTbyBpdCBzZWVtcyB3ZSBuZWVkOg0KPiA+ID4gDQo+ID4gPiDCoMKgwqDC
oMKgIHN0YXJ0ID0gKHVuc2lnbmVkIGxvbmcpdGR4X2ZpbmRfcGFtdF9yZWZjb3VudChQRk5fUEhZ
UyhzdGFydF9wZm4pKTsNCj4gPiA+IMKgwqDCoMKgwqAgZW5kwqDCoCA9ICh1bnNpZ25lZCBsb25n
KXRkeF9maW5kX3BhbXRfcmVmY291bnQoUEZOX1BIWVMoZW5kX3BmbikgLSAxKSk7DQo+ID4gPiDC
oMKgwqDCoMKgIHN0YXJ0ID0gcm91bmRfZG93bihzdGFydCwgUEFHRV9TSVpFKTsNCj4gPiA+IMKg
wqDCoMKgwqAgZW5kwqDCoCA9IHJvdW5kX3VwKGVuZCwgUEFHRV9TSVpFKTsNCj4gPiANCj4gPiBD
aGVja2VkIGFnYWluLCB0aGlzIHNlZW1zIHRvIGJlIHRoZSByaWdodCB2ZXJzaW9uLg0KPiANCj4g
VGhhbmtzIGJvdGggZm9yIHRoZSBhbmFseXNpcy4gSSBsYXppbHkgY3JlYXRlZCBhIHRlc3QgcHJv
Z3JhbSB0byBjaGVjayBzb21lIGVkZ2UNCj4gY2FzZXMgYW5kIGZvdW5kIHRoZSBvcmlnaW5hbCBh
bmQgdGhpcyB2ZXJzaW9uIHdlcmUgYm90aCBidWdneS4gQ2xlYXJseSB0aGlzIGNvZGUNCj4gbmVl
ZHMgdG8gYmUgY2xlYXJlciAoYXMgYWN0dWFsbHkgRGF2ZSBwb2ludGVkIG91dCBpbiB2MiBhbmQg
SSBmYWlsZWQgdG8NCj4gYWRkcmVzcykuIEV4YW1wbGUgKHN5bnRoZXRpYyBmYWlsdXJlKToNCj4g
DQo+IHN0YXJ0X3BmbiA9IDB4ODAwMDANCj4gZW5kX3BmbiA9ICAgMHg4MDAwMQ0KPiANCj4gT3Jp
Z2luYWwgY29kZTogc3RhcnQgPSAweGZmNzZiYTRmOWUwMzQwMDANCj4gICAgICAgICAgICAgICAg
ZW5kICAgPSAweGZmNzZiYTRmOWUwMzQwMDANCj4gDQo+IEFib3ZlIGZpeDogICAgIHN0YXJ0ID0g
MHhmZjc2YmE0ZjllMDM0MDAwDQo+ICAgICAgICAgICAgICAgIGVuZCAgID0gMHhmZjc2YmE0Zjll
MDM0MDAwDQoNCk9oIEkgdGhpbmsgdGhlIHByb2JsZW0gb2YgdGhlICJBYm92ZSBmaXgiIGlzIGl0
IGZhaWxzIHdoZW4gQHN0YXJ0IGFuZCBAZW5kDQphcmUgdGhlIHNhbWUgYW5kIGJvdGggYXJlIGFs
cmVhZHkgcGFnZSBhbGlnbmVkLg0KDQo+IA0KPiBQYXJ0IG9mIHRoZSBwcm9ibGVtIGlzIHRoYXQg
dGR4X2ZpbmRfcGFtdF9yZWZjb3VudCgpIGV4cGVjdHMgdGhlIGhwYSBwYXNzZWQgaW4NCj4gdG8g
YmUgUE1EIGFsaWduZWQuIFRoZSBvdGhlciBjYWxsZXJzIG9mIHRkeF9maW5kX3BhbXRfcmVmY291
bnQoKSBhbHNvIG1ha2Ugc3VyZQ0KPiB0aGF0IHRoZSBQQSBwYXNzZWQgaW4gaXMgMk1CIGFsaWdu
ZWQgYmVmb3JlIGNhbGxpbmcsIGFuZCBjb21wdXRlIHRoaXMgc3RhcnRpbmcNCj4gd2l0aCBhIFBG
Ti4gU28gdG8gdHJ5IHRvIG1ha2UgaXQgZWFzaWVyIHRvIHJlYWQgYW5kIGJlIGNvcnJlY3Qgd2hh
dCBkbyB5b3UgdGhpbmsNCj4gYWJvdXQgdGhlIGJlbG93Og0KPiANCj4gc3RhdGljIGF0b21pY190
ICp0ZHhfZmluZF9wYW10X3JlZmNvdW50KHVuc2lnbmVkIGxvbmcgcGZuKSB7DQo+ICAgICB1bnNp
Z25lZCBsb25nIGhwYSA9IEFMSUdOX0RPV04ocGZuLCBQTURfU0laRSk7DQoNClNob3VsZG4ndCBp
dCBiZToNCg0KCWhwYSA9IEFMSUdOX0RPV04oUEZOX1BIWVMocGZuKSwgUE1EX1NJWkUpKTsNCj8N
Cj4gDQo+ICAgICByZXR1cm4gJnBhbXRfcmVmY291bnRzW2hwYSAvIFBNRF9TSVpFXTsNCj4gfQ0K
PiANCj4gLyoNCj4gICogJ3N0YXJ0X3BmbicgaXMgaW5jbHVzaXZlIGFuZCAnZW5kX3BmbicgaXMg
ZXhjbHVzaXZlLsKgDQo+IA0KDQpJIHRoaW5rICdlbmRfcGZuJyBpcyBleGNsdXNpdmUgaXMgYSBs
aXR0bGUgYml0IGNvbmZ1c2luZz8gIEl0IHNvdW5kcyBsaWtlDQp0aGUgcGh5c2ljYWwgcmFuZ2Ug
ZnJvbSBQRk5fUEhZUyhlbmRfcGZuIC0gMSkgdG8gUEZOX1BIWVMoZW5kX3BmbikgaXMgYWxzbw0K
ZXhjbHVzaXZlLCBidXQgaXQgaXMgYWN0dWFsbHkgbm90PyAgVG8gbWUgaXQncyBtb3JlIGxpa2Ug
b25seSB0aGUgcGh5c2ljYWwNCmFkZHJlc3MgUEZOX1BIWVMoZW5kX3BmbikgaXMgZXhjbHVzaXZl
Lg0KDQo+IENvbXB1dGUgdGhlwqANCj4gICogcGFnZSByYW5nZSB0byBiZSBpbmNsdXNpdmUgb2Yg
dGhlIHN0YXJ0IGFuZCBlbmQgcmVmY291bnQNCj4gICogYWRkcmVzc2VzIGFuZCBhdCBsZWFzdCBh
IHBhZ2UgaW4gc2l6ZS4gVGhlIHRlYXJkb3duIGxvZ2ljIG5lZWRzDQo+ICAqIHRvIGhhbmRsZSBw
b3RlbnRpYWxseSBvdmVybGFwcGluZyByZWZjb3VudHMgbWFwcGluZ3MgcmVzdWx0aW5nDQo+ICAq
IGZyb20gdGhpcy4NCj4gICovDQo+IHN0YXJ0ID0gKHVuc2lnbmVkIGxvbmcpdGR4X2ZpbmRfcGFt
dF9yZWZjb3VudChzdGFydF9wZm4pOw0KPiBlbmQgICA9ICh1bnNpZ25lZCBsb25nKXRkeF9maW5k
X3BhbXRfcmVmY291bnQoZW5kX3BmbiAtIDEpOw0KPiBzdGFydCA9IEFMSUdOX0RPV04oc3RhcnQs
IFBBR0VfU0laRSk7DQo+IGVuZCAgID0gQUxJR05fRE9XTihlbmQsIFBBR0VfU0laRSkgKyBQQUdF
X1NJWkU7DQoNClRoaXMgbG9va3MgZmluZSB0byBtZS4gIEkgbWVhbiB0aGUgcmVzdWx0IHNob3Vs
ZCBiZSBjb3JyZWN0LCBidXQgdGhlDQonZW5kX3BmbiAtIDEnIChkdWUgdG8gJ2VuZF9wZm4nIGlz
IGV4Y2x1c2l2ZSkgaXMgYSBiaXQgY29uZnVzaW5nIHRvIG1lIGFzDQpzYWlkIGFib3ZlLCBidXQg
bWF5YmUgaXQncyBvbmx5IG1lLCBzbyBmZWVsIGZyZWUgdG8gaWdub3JlLg0KDQpPciwgYXMgc2Fp
ZCBhYm92ZSwgSSB0aGluayB0aGUgcHJvYmxlbSBvZiB0aGUgIkFib3ZlIGZpeCIgaXMgd2hlbg0K
Y2FsY3VsYXRpbmcgdGhlIEBlbmQgd2UgZGlkbid0IGNvbnNpZGVyIHRoZSBjYXNlIHdoZXJlIGl0
IGVxdWFscyB0byBAc3RhcnQNCmFuZCBpcyBhbHJlYWR5IHBhZ2UgYWxpZ25lZC4gIERvZXMgYmVs
b3cgd29yayAoYXNzdW1pbmcNCnRkeF9maW5kX3BhbXRfcmVmY291bnQoKSBzdGlsbCB0YWtlcyAn
aHBhJyk/DQoNCiAgICBzdGFydCA9ICh1bnNpZ25lZCBsb25nKXRkeF9maW5kX3BhbXRfcmVmY291
bnQoUEZOX1BIWVMoc3RhcnRfcGZuKSk7DQogICAgZW5kICAgPSAodW5zaWduZWQgbG9uZyl0ZHhf
ZmluZF9wYW10X3JlZmNvdW50KFBGTl9QSFlTKGVuZF9wZm4pIC0gMSkpOw0KICAgIHN0YXJ0ID0g
UEFHRV9BTElHTl9ET1dOKHN0YXJ0KTsNCiAgICBlbmQgICA9IFBBR0VfQUxJR05fRE9XTihlbmQp
ICsgUEFHRV9TSVpFOw0KDQpBbnl3YXksIGRvbid0IGhhdmUgc3Ryb25nIG9waW5pb24gaGVyZSwg
c28gdXAgdG8geW91Lg0K

