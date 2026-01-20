Return-Path: <kvm+bounces-68643-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sDoWGL7ub2m+UQAAu9opvQ
	(envelope-from <kvm+bounces-68643-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 22:08:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 14EBF4BF9F
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 22:08:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BC56568E58A
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 19:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D77503A783C;
	Tue, 20 Jan 2026 19:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="myRVnrxb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F92B3A4F22;
	Tue, 20 Jan 2026 19:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768938806; cv=fail; b=BiXmkbvlBW/EXgzMsdDydTW1RDEhdbF0mKzYtIOHdyp2uoXz7yrx6NRkhPjBR2OkJTve7eg2qOMBsg72rGNwPKcAqBO4PkMwpsU6JRlNzuN48SDMugK/AN/JYrXsqiJh9FVuUyeGUurFhAks6wd69QWeib8zdP6n30EHr6xvTiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768938806; c=relaxed/simple;
	bh=oPeI3Ph5/nkcbYN/8v2tBFULVyog4aVM7O93PBtXPWo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jRldLsoBOKoWAK+DS3WRyZPM4sZ57vMETlMTcnPEJEtyQ6WFFEXLwFK0OZ0HfSZVGI9GZBPlr0Y5MY6JraAQfN5K9QdN+Js8kufL78skuwTHxJqlAScfoqTLVRGu5pnVvRQkC9oRx9Oac4USvrr0JwUoU7AngUAllCgxVPqpmjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=myRVnrxb; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768938804; x=1800474804;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oPeI3Ph5/nkcbYN/8v2tBFULVyog4aVM7O93PBtXPWo=;
  b=myRVnrxbPygbwy0j4B9N1Tb2taRV7ygLllu6ayXeE5bJzm24MbOOHNSC
   WEEl6KhxlVlYIyXbJNd75ijPgN/JPgWgMxYKOeNz+qEooYpJEZeGzJKOn
   sbh5whoCO/93DWHM6FbucH+v4MoAiUQ0fng9exXLoI1ijGU96TWQu0yEB
   d1dg5eaAn8S8alRSOwhvknwNVlMHsZMVANionnQvdQB7MbW2DLEG1bEQX
   IQ+N2zG9kyA6L6v2Yz9GS8PqR2KPZ75kWw+KSawnyiInQkA6MU/ETnxVE
   UIBUmWJSA4/RAqQ3MG7YQq9V8gWNfhrh9eYdOdVCHn5pItRQuUGUMq20N
   Q==;
X-CSE-ConnectionGUID: 0mC2om4BQFi/IeUr6Z3VYA==
X-CSE-MsgGUID: 0BjxT01QRpKFn2gfseO0iA==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="80881316"
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="80881316"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 11:53:23 -0800
X-CSE-ConnectionGUID: j+wh1Li9T7+8jA0661kvbg==
X-CSE-MsgGUID: kWSKJ15bTq+xuhpKgjFWOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="206130545"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 11:53:23 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 11:53:22 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 11:53:22 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.51) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 11:53:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c4Xr1YqVgA6WYHdawflQH9taY8JE+BaAeHzH5nFg919PmW09flFFQ8GFsZymCmADRGmXaFKHnx0nwWGaKXe0jD4TepU1CENkM5OCPA+XRBT1PdxAsa+aiCHdBVf2yE8khZkDUcuN/7gumi2bC167wd/dwTT4j1Yy166Fo2LWmOgLxCQUFi1LjWLnlodxr9az+Jpyy55xz0g66OYT+vJhhJQsnHxUcyRnUCAbzb9njF4VKBBggyN1BKnVDMMs+elkehs+T7heqkBgLMO+OUUxVYhd2mOZQkdo8tSL0wP6xO7BglJVk5GpEig8lmxhsAOWNIfL+eaq320CS4ARNp0k3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPeI3Ph5/nkcbYN/8v2tBFULVyog4aVM7O93PBtXPWo=;
 b=yC7V/gd5qV0X5UhNPh3KgFfcgR/YwIk7BfbQzvjiukcw0mFeXdGUy+D9YX5fRDSP4RU0Wo967CNVA23AA9uMWVDd5WlVpbhVerhFI59b1EJiKQk2nwWOjVk5fbdS2kkwr2pbTFk3k/fjI/o64Wr5lLJYGfpJA/3DZ+NRdlysM7PCHMFtr/TlpzW7uJ+EI6ZKykhH0obcy9XIuDYSkvF+0z5bhTG/OpU5+817HzJi+g4XoGvoQjkPM0On1oQLvODGYDJovNwlX1FW2BB0SOtRF7FGrDof52O5OXvODlAlR02GB4743UaUth2F/qDmtNIQIs76AJTyai9dOX46UhUOjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA3PR11MB7488.namprd11.prod.outlook.com (2603:10b6:806:313::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 19:53:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 19:53:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v4 11/16] KVM: TDX: Add x86 ops for external spt cache
Thread-Topic: [PATCH v4 11/16] KVM: TDX: Add x86 ops for external spt cache
Thread-Index: AQHcWoEJBgBbBG6UnECVQd/2Mz81/LVV4oKAgAX1VAA=
Date: Tue, 20 Jan 2026 19:53:19 +0000
Message-ID: <24665176b1e6b169441c9f6db9b5d02d073377a4.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-12-rick.p.edgecombe@intel.com>
	 <aWrdpZCCDDAffZRM@google.com>
In-Reply-To: <aWrdpZCCDDAffZRM@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA3PR11MB7488:EE_
x-ms-office365-filtering-correlation-id: 5100f327-b1e6-44bb-dd64-08de585d8f8c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?WGJoaDgvWFcrZ2xHVk1TT05zQ0RDclNGRHNFTGZaSnRRTWc1Z1NKWXJNdUZ5?=
 =?utf-8?B?NWxKeHFPUTM0OWtqRXJ3ampqN2dtUks4Ni9YRjMwSjB6MHV2VFM4Mjhaazhx?=
 =?utf-8?B?bDJveUthZTJFdjhXY284aGJqZ0R4RVYzQXBZdXR4em1sakhqK3l3dGJPUGYw?=
 =?utf-8?B?ZTFuRVdKR1NEOVNSMXppdVhKZkVYQ0RMaWRnbWVhNUtNcXJmS1Y2VC9PbWRo?=
 =?utf-8?B?cCtBN0pkbjFUQjcwczdVRXg2Rnkya1ZXY2xydWJWVzE0bUNUNmNZVlJGWUY1?=
 =?utf-8?B?NDJ3aUFub3A5MEc3MmRsRzg1RDQ4V2x5U0d6Z1NwdUJhWlNyUzM1SklZblNn?=
 =?utf-8?B?THJScEVDQ1p5M3V3TUxqYVRVdUZWQ0trQ1h3SHQ2R2tEeWxQbVVUa2ErZEV4?=
 =?utf-8?B?WjF4UXQ3cEtzTlQrM0lJelZlRGRpb3d3bDFGM0tXejRTcHhGTmlnTEQyekVO?=
 =?utf-8?B?Nlk5MW1zdUhTSDl6cFNFaXZMWmFEbytLS2lCUkxLVURpNjhvd3MwbW03bkVE?=
 =?utf-8?B?WndpSVR1cWtFU3FTV1lsTFE0RjZMcXBmQzBsQTYzalo2c21mYXZJVlA1eXlv?=
 =?utf-8?B?QzNaVS9QQnFRV2UreWNoNitWOGx1QzliWXd5QUxUaStFVjRLWkl5Y0tFVmNU?=
 =?utf-8?B?R3hqbW4rOUNOMmp3bVlHMzRobDNwUndSMHFTNWMxUUJaVGV1REM2ZjBOVUpP?=
 =?utf-8?B?Myt1RmZtSWtpZGdhTHcycVlmK3J2NFhjUFRFOTE2RElQWmRwYkM2VzRMU2Rh?=
 =?utf-8?B?d2x1VHQrL2pqbUhPR1ZjZXVoQzBqTTZGTVhXdDNROS9hVXhKVVAxQkg3emhr?=
 =?utf-8?B?aXRNWlpta1pDVEZFenhBSnNHNWVHNlo4U2czNm1JWlJlRlE2aXBJa1ozdVox?=
 =?utf-8?B?S29oVVFPdFlqT1ZqcXhWdUxDUCt0NXZ2RHZWdmJYOGdHMFhkNTRXVVF4THZ6?=
 =?utf-8?B?QWloZytjeWVwanQyQURPVzR0Ti9vbm9ES0tibW5iSnJ5aHYxODV4YXV3cVdh?=
 =?utf-8?B?ZFk0eE1pN1BpUk1ma2xpbmhrbUZsNWdLZU5GdmlEeGJXZjdPWFYzY3c5M25r?=
 =?utf-8?B?emZVd0hLOWdvcURmRm41S0NSNm5UUHY0MDJQaks0aHBoY1M4QW5uVUhZTDJF?=
 =?utf-8?B?R3JWYUtQVTN6NWFSenlaS1BIaWxmMTV2NWZvN1JubWxjbjJDWUovMXV4NzFJ?=
 =?utf-8?B?V2VUNFVLeHpCVVlaSmxrbGV4N0I1OFJRclVwZ1ZzVFNjVTNnR2ZwSjQ0OFBw?=
 =?utf-8?B?ZS9oS29Ed2ZQQ2t4TWlTdkFmd3ZGQmhMejNTcGZMZjhRekk3WmNtQXFFUzVF?=
 =?utf-8?B?MlpESkhhZVdPRFdNRFBuQmhBZ1R4ZVZkbWdyQXlIR3VWZmswbjIvSDdGMmYz?=
 =?utf-8?B?Y0hDL3dPK0hlSUtHNzRoRWpUd3pRallKQzlEVTNrMEJpdy8yYlpPL0ZPN0NJ?=
 =?utf-8?B?TFNlWDNRUysxYzhpM2x6czBSb3p2bVZ6TGlCU0pSR3JmYjdOalc5OUtVSzdJ?=
 =?utf-8?B?bS9aamhZNG1JQlhpOURjYW40anExTFFwejNYbXVCc0lLWGloS2pzZVhHYmNi?=
 =?utf-8?B?TWNHRGtocmlWaGV2dEU4UzVUSVROdzZ1ZVNSaXpvb1JSbUNYVFJyeDJkbmpF?=
 =?utf-8?B?cTgyTFFYRFBnbVRnQmdSN3dqMWRIRzlabkN1aVg0U3Y3VUk3TFVWSVUrSlFT?=
 =?utf-8?B?NDRtei80VlRKS2lyd0x3QmhZQnAwKytodzYwVHkyQWlsNGNHR3NlYkVCbnFQ?=
 =?utf-8?B?L3lSQnVkVU5MdnhqVXh5NmE0cEpzeWpDcjJHcEd6SlRia05heksyaXRBSlhR?=
 =?utf-8?B?enpFTzU1SmlOcCtJQmFiN1lvdXIzWnJrdXZlQVV3ZlRSWitzT3NVdStOSTd3?=
 =?utf-8?B?c3E2MGU3RXhncFRZRW9WQ2tEZDZJUk5NTEJvd0lBd2RuYi9ucGlDM0tWd1I0?=
 =?utf-8?B?U0ZBZVRqWTMySi9zZzBmT0prRzNYUldkS1UyR3hINGZZODd1RWEvSFQrVlBj?=
 =?utf-8?B?RlhJZkROZ0NxWHBBTDJOZFJyZGcxd0xlN3FxUDNRQ0Y4aEM4SlBXNlJVZVhw?=
 =?utf-8?B?WDF1NloxQjVpUHZKYkFSaXY5T3VqakFHMFhsQjJ6TEw1c3l5N2wvc1ZMdCtz?=
 =?utf-8?B?a2RYVmo5U2pBMENNMDZhZXgvV21sOTJQVUoxMFVWbzBweitaSnpPVEwxQ3FQ?=
 =?utf-8?Q?B/T8esA3gPusgSUKQ9L74lc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWxXL1EyOFZNZVFhWk5pV2NBOVo5c21xWklFRVRwc3pxNVFORnVnMFdDY0h6?=
 =?utf-8?B?Wllodkl5VlFyWmRSeUZEd2hIL0hrMnlycy9qV1JMV3l4YzNURWtCVHJRSVJn?=
 =?utf-8?B?dTVLVkY5Z2ltdThwbE1pdmx1VmE2Z2xjaW1BeTFqYnIzcFExa1NyNjhzTysx?=
 =?utf-8?B?OTR6MHdvNCtveVJhaFEvTDF6YitibVF6d1lBc3Z5RnNCcjNucmtLWWlUWElF?=
 =?utf-8?B?ZkovcVUxNWFOOHBGZ3lOOGppVngzaXRSOUVTMCsvZGRhQ0EwOHp6VHhWSFJs?=
 =?utf-8?B?QUdVcnUzSVpyenphdHhtc0VVZENSSWVFeDFMUXNXWVBEallOV3AvVVFkdnV0?=
 =?utf-8?B?VlNqTm1rTENQaEE1aWdUcXZielEzUGhDbUhHNG0xRXNXU2pNd3dwZzdCcURW?=
 =?utf-8?B?TnBoRlBUZStlTUVUeE1jdUFrajl6ankzV0hVUXNoanlOR01JbXpsN01UR0U0?=
 =?utf-8?B?VzB6aU5Ld2tQUlBLTE54RjZpMXFzZmh2WjJ6Ry9iekpIOWJ2UWZUdTZXUjdQ?=
 =?utf-8?B?SEVXM21DbTR3TUh2K0xuekhsWHpOS2s4RVFqU2J1Q3d3OUJUVE4vWWlpdmpJ?=
 =?utf-8?B?ajNOREt4TS9JdTk2RlZJVUVUK2RGS1M4dnE4U2RoM1k3N1dLWWlEVDNjS3BH?=
 =?utf-8?B?eTF4K3dwNzdvSFhkMzBuNHpiN0RRc0dmSkJoeFRuZTdRajh3a2lEM3VwZ0FB?=
 =?utf-8?B?bUU0MHI2NHRNT01hSlloUHVjek9pTmUzU3VnVjdBZ2dab3N0YlFGVEZrb3VU?=
 =?utf-8?B?dGpBVzhqY2MxZytyTHlrMm9BL3Q2dGFrNnRuR0VLZmp4cUJla2dPZWcxOW5y?=
 =?utf-8?B?bWZUR2xpaWxXdnhtL0tySG9uWW8wdUVaeXYxbVh5cUVsQW5xSldMcVpVUEVa?=
 =?utf-8?B?VVcwU3hsUk0wZU5TMnZiN1A3RUZVTHFxelI2dUlJWWFBSXRyN1VUTFJZK2xQ?=
 =?utf-8?B?eHFaT2NQbnJEcGVBajdGVjRiUGhpOGp5ajRKY0xnZThrQ2hZalJWY2kxTnkr?=
 =?utf-8?B?K0diK1JXMGNTb3VlQTlhSWppQ3lRUHhKYkRES3BOUWI4blBja3FWWEQ5NDJy?=
 =?utf-8?B?SVJaN2cwSHBRSktES2hQOEtsdkR1cW5YWXhlQ1RlNmIwYzF4N2hoZlNSaXRp?=
 =?utf-8?B?cFRDUy9waitLVzZvZGlkZ1dIZmZtbldGTTQwSFUvT1g0SkFPR1RHc2Q1ZFBN?=
 =?utf-8?B?aEw2RDRGdlVMR2l5OW12SDBobUY0aVNQMjVpUFdNQ29ManZ3L0NJMHlMcm45?=
 =?utf-8?B?T0tXdHhpbEhiZ3E4VWZlMlpMY0RMSlQ5ejJXdy9PNUxWS2JTWGtLRTNyVklj?=
 =?utf-8?B?ZGorYW9hN2xUVWJnazc4VWc4Y2N6T2ZtWkVJMW4vVzdGZFBIc2xwaU5DUkxS?=
 =?utf-8?B?TVdrdXhzaUU1UnBvM01pN0J3S21IZWUxdStmTGVCYU5ya3Z5SUNDWG9Kallw?=
 =?utf-8?B?V1NsbTBMVlp6djh1NUNUNnZhSUNWazE3MVVSNEVhMU9wUmg4dE9oQlA2TUpI?=
 =?utf-8?B?TGZiSXNQYUhjN2twUm9TN2VKUCtHWHlzalZDZjQzZDlFYjhmQWdxOHdkVXVi?=
 =?utf-8?B?Vi8xU0hDNmM4TXg5cHJxd3RNOFZjYTZtcFZJOGNCdVFndnE3Y0dIVlRwUGRy?=
 =?utf-8?B?aitMbUZTaDNRVjRab3ZhdnVVYU9XVEpXOHM3ME56NCt3ZWVoZnpQaERPV0JI?=
 =?utf-8?B?eUhOaFlnZjZkTFNza0dvUndvMmdOYUtsWmdNVjNOdUxIQ3hiQUN6cDgxTXA5?=
 =?utf-8?B?ZU5ucjNhTkRTRGFBdHE2VExkM2V5K0ZXNy9USVFTejRPUHNsaHN5bVhVZGFP?=
 =?utf-8?B?a0dMU1BjcGRnYmxwUGJRMGluZDNBSWZIajczTGxRVkJTd0daQmNQSmJHbWdu?=
 =?utf-8?B?NkdaR01QZm1sZnVtSnJjT2NFaVc0NVM5ZzRkalZxNTRpTElKc2FCNVh5S0Ni?=
 =?utf-8?B?b3RwNEpDM2l4R3VaUlFuRnFvVWcwczJrTGQrQW8rd0FPNGZCeWxGTlhtQTdl?=
 =?utf-8?B?V3JXdVRMbnpCL3VWcHhGVHhDcnRFejRsVkp6cFhpbXZvQzNFb1B4TTI5Mkg3?=
 =?utf-8?B?SlpCRnZ1R2pCcFhod2l3ajZvY3BKMHZ2WnZReGZob2ZURk04Rk92ck1HVlpY?=
 =?utf-8?B?RWJjR3pSM21FdGs4aU5sMzhmMFUrSjRCQ0V2TjFNRVNLczNtOERNaHZFd0Fj?=
 =?utf-8?B?M21IQ2llTHRQbUhBdDcrK1ZTUjlwampnRDZyenFTQnpzTkJXem5BZHRTNFRq?=
 =?utf-8?B?SXprM1ZjNDJOWEJDT2tIQ2V3TTc3T2xYK0tzMmkzV1RIS3laeEtQVUNwamZL?=
 =?utf-8?B?eEVjT0ZYMXgza08wd2tOR3d3VTc2L1g4MTBxR0V3ZkJ0ZDJ3STdmcGZSOWlt?=
 =?utf-8?Q?PgILg2PlBhm5tMnU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <543B571959A7084693603B844062AF2C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5100f327-b1e6-44bb-dd64-08de585d8f8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2026 19:53:19.3503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IJ+fZO2YyCejmuDXKKNzeZMwNU7s1w/VmyFth4rf78WGew1LwZMrAXv++geYXjoDPeUZOt4J3npZddCG4/dr8A6OFK+pRsFtzmaWbGlT9D8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7488
X-OriginatorOrg: intel.com
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	TAGGED_FROM(0.00)[bounces-68643-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 14EBF4BF9F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

U2VhbiwgcmVhbGx5IGFwcHJlY2lhdGUgeW91IHRha2luZyBhIGxvb2sgZGVzcGl0ZSBiZWluZyBv
dmVyYm9va2VkLg0KDQpPbiBGcmksIDIwMjYtMDEtMTYgYXQgMTY6NTMgLTA4MDAsIFNlYW4gQ2hy
aXN0b3BoZXJzb24gd3JvdGU6DQo+IE5BSy7CoCBJIGtpbmRhIHNvcnRhIGdldCB3aHkgeW91IGRp
ZCB0aGlzP8KgIEJ1dCB0aGUgcGFnZXMgS1ZNIHVzZXMgZm9yIHBhZ2UgdGFibGVzDQo+IGFyZSBL
Vk0ncywgbm90IHRvIGJlIG1peGVkIHdpdGggUEFNVCBwYWdlcy4NCj4gDQo+IEV3dy7CoCBEZWZp
bml0ZWx5IGEgaGFyZCAibm8iLsKgIEluIHRkcF9tbXVfYWxsb2Nfc3BfZm9yX3NwbGl0KCksIHRo
ZSBhbGxvY2F0aW9uDQo+IGNvbWVzIGZyb20gS1ZNOg0KPiANCj4gCWlmIChtaXJyb3IpIHsNCj4g
CQlzcC0+ZXh0ZXJuYWxfc3B0ID0gKHZvaWQgKilnZXRfemVyb2VkX3BhZ2UoR0ZQX0tFUk5FTF9B
Q0NPVU5UKTsNCj4gCQlpZiAoIXNwLT5leHRlcm5hbF9zcHQpIHsNCj4gCQkJZnJlZV9wYWdlKCh1
bnNpZ25lZCBsb25nKXNwLT5zcHQpOw0KPiAJCQlrbWVtX2NhY2hlX2ZyZWUobW11X3BhZ2VfaGVh
ZGVyX2NhY2hlLCBzcCk7DQo+IAkJCXJldHVybiBOVUxMOw0KPiAJCX0NCj4gCX0NCg0KQWgsIHRo
aXMgaXMgZnJvbSB0aGUgVERYIGh1Z2UgcGFnZXMgc2VyaWVzLiBUaGVyZSBpcyBhIGJpdCBvZiBm
YWxsb3V0IGZyb20gVERYIA0KL2NvY28ncyBldGVybmFsIG5lbWVzaXM6IHN0YWNrcyBvZiBjb2Rl
IGFsbCBiZWluZyBjby1kZXNpZ25lZCBhdCBvbmNlLg0KDQpEYXZlIGhhcyBiZWVuIGRpcmVjdGlu
ZyB1cyByZWNlbnRseSB0byBmb2N1cyBvbiBvbmx5IHRoZSBuZWVkcyBvZiB0aGUgY3VycmVudA0K
c2VyaWVzLiBOb3cgdGhhdCB3ZSBjYW4gdGVzdCBhdCBlYWNoIGluY3JlbWVudGFsIHN0ZXAgd2Ug
ZG9uJ3QgaGF2ZSB0aGUgc2FtZQ0KcHJvYmxlbXMgYXMgYmVmb3JlLiBCdXQgb2YgY291cnNlIHRo
ZXJlIGlzIHN0aWxsIGRlc2lyZSBmb3IgdXBkYXRlZCBURFggaHVnZQ0KcGFnZXMsIGV0YyB0byBo
ZWxwIHdpdGggZGV2ZWxvcG1lbnQgb2YgYWxsIHRoZSBvdGhlciBXSVAgc3R1ZmYuDQoNCkZvciB0
aGlzIGRlc2lnbiBhc3BlY3Qgb2YgaG93IHRoZSB0b3B1cCBjYWNoZXMgd29yayBmb3IgRFBBTVQs
IGhlIGFza2VkDQpzcGVjaWZpY2FsbHkgZm9yIHRoZSBEUEFNVCBwYXRjaGVzIHRvICpub3QqIGNv
bnNpZGVyIGhvdyBURFggaHVnZSBwYWdlcyB3aWxsIHVzZQ0KdGhlbS4NCg0KTm93IHRoZSBURFgg
aHVnZSBwYWdlcyBjb3ZlcmxldHRlciBhc2tlZCB5b3UgdG8gbG9vayBhdCBzb21lIGFzcGVjdHMg
b2YgdGhhdCwNCmFuZCB0cmFkaXRpb25hbGx5IEtWTSBzaWRlIGhhcyBwcmVmZXJyZWQgdG/CoGxv
b2sgYXQgaG93IHRoZSBjb2RlIGlzIGFsbCBnb2luZyB0bw0Kd29yayB0b2dldGhlci4gVGhlIHBy
ZXNlbnRhdGlvbiBvZiB0aGlzIHdhcyBhIGJpdCBydXNoZWQgYW5kIGNvbmZ1c2VkLCBidXQNCmxv
b2tpbmcgZm9yd2FyZCwgaG93IGRvIHlvdSB3YW50IHRvIGRvIHRoaXM/DQoNCkFmdGVyIHRoZSAx
MzAgcGF0Y2hlcyBvcmRlYWwsIEknbSBhIGJpdCBhbWVuYWJsZSB0byBEYXZlJ3Mgdmlldy4gV2hh
dCBkbyB5b3UNCnRoaW5rPw0KDQo+IA0KPiBCdXQgdGhlbiBpbiBrdm1fdGRwX21tdV9tYXAoKSwg
dmlhIGt2bV9tbXVfYWxsb2NfZXh0ZXJuYWxfc3B0KCksIHRoZSBhbGxvY2F0aW9uDQo+IGNvbWVz
IGZyb20gZ2V0X3RkeF9wcmVhbGxvY19wYWdlKCkNCj4gDQo+IMKgIHN0YXRpYyB2b2lkICp0ZHhf
YWxsb2NfZXh0ZXJuYWxfZmF1bHRfY2FjaGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiDCoCB7
DQo+IAlzdHJ1Y3QgcGFnZSAqcGFnZSA9IGdldF90ZHhfcHJlYWxsb2NfcGFnZSgmdG9fdGR4KHZj
cHUpLT5wcmVhbGxvYyk7DQo+IA0KPiAJaWYgKFdBUk5fT05fT05DRSghcGFnZSkpDQo+IAkJcmV0
dXJuICh2b2lkICopX19nZXRfZnJlZV9wYWdlKEdGUF9BVE9NSUMgfCBfX0dGUF9BQ0NPVU5UKTsN
Cj4gDQo+IAlyZXR1cm4gcGFnZV9hZGRyZXNzKHBhZ2UpOw0KPiDCoCB9DQo+IA0KPiBCdXQgdGhl
biByZWdhcmRsZXMgb2Ygd2hlcmUgdGhlIHBhZ2UgY2FtZSBmcm9tLCBLVk0gZnJlZXMgaXQuwqAg
U2VyaW91c2x5Lg0KPiANCj4gwqAgc3RhdGljIHZvaWQgdGRwX21tdV9mcmVlX3NwKHN0cnVjdCBr
dm1fbW11X3BhZ2UgKnNwKQ0KPiDCoCB7DQo+IAlmcmVlX3BhZ2UoKHVuc2lnbmVkIGxvbmcpc3At
PmV4dGVybmFsX3NwdCk7wqAgPD09PT09DQoNCkFoISBPaywgd2UgbWlnaHQgaGF2ZSBhIGdvb2Qg
b3B0aW9uIGhlcmUuIEthaSBoYWQgc3VnZ2VzdGVkIHRoYXQgaW5zdGVhZCBvZiBwcmUtDQpmYXVs
dGluZyBhbGwgdGhlIHBhZ2VzIHRoYXQgd2UgbWlnaHQgbmVlZCBmb3IgRFBBTVQgYmFja2luZywg
d2UgcHJlLWluc3RhbGwgdGhlDQpEUEFNVCBiYWNraW5nIGZvciBhbGwgcGFnZXMgaW4gdGhlIGV4
dGVybmFsIHBhZ2UgdGFibGUgY2FjaGUgYXQgdG9wLXVwIHRpbWUuIEl0DQpoYXMgYSBjb21wbGlj
YXRpb24gZm9yIFREWCBodWdlIHBhZ2VzLCB3aGljaCBuZWVkcyB0byBkZWNpZGUgbGF0ZSBpZiBh
IHBhZ2UgaXMNCmh1Z2UgYW5kIG5lZWRzIGRwYW10IGJhY2tpbmcgb3Igbm90LCBidXQgYmFzZWQg
b24gRGF2ZSdzIGRpcmVjdGlvbiBhYm92ZSBJIGdhdmUNCml0IGEgdHJ5LiBBIGRvd25zaWRlIGZv
ciBwdXJlIERQQU1UIHdhcyB0aGF0IGl0IG5lZWRlZCB0byBoYW5kbGUgdGhlIGZyZWVpbmcNCnNw
ZWNpYWxseSBiZWNhdXNlIGl0IG5lZWRlZCB0byBwb3RlbnRpYWxseSByZWNsYWltIHRoZSBEUEFN
VCBiYWNraW5nLiBUaGlzDQpyZXF1aXJlZCBhbiB4ODYgb3AgZm9yIGZyZWVpbmcgdGhlc2UgcGFn
ZXMsIGFuZCB3YXMgYSBiaXQgbW9yZSBjb2RlIG9uIHRoZSBLVk0NCnNpZGUgaW4gZ2VuZXJhbC4N
Cg0KQnV0IGlmIHRoZSBhc3ltbWV0cnkgaXMgYSBwcm9ibGVtIGVpdGhlciB3YXksIG1heWJlIEkn
bGwgZ2l2ZSBpdCBhIHRyeSBmb3IgdjUuIA0KDQo+IAlmcmVlX3BhZ2UoKHVuc2lnbmVkIGxvbmcp
c3AtPnNwdCk7DQo+IAlrbWVtX2NhY2hlX2ZyZWUobW11X3BhZ2VfaGVhZGVyX2NhY2hlLCBzcCk7
DQo+IMKgIH0NCj4gDQo+IE9oLCBhbmQgdGhlIGh1Z2VwYWdlIHNlcmllcyBhbHNvIGZ1bWJsZXMg
aXRzIHRvcHVwICh3aHkgdGhlcmUncyB5ZXQgYW5vdGhlcg0KPiB0b3B1cCBBUEksIEkgaGF2ZSBu
byBpZGVhKS4NCj4gDQo+IMKgIHN0YXRpYyBpbnQgdGR4X3RvcHVwX3ZtX3NwbGl0X2NhY2hlKHN0
cnVjdCBrdm0gKmt2bSwgZW51bSBwZ19sZXZlbCBsZXZlbCkNCj4gwqAgew0KPiAJc3RydWN0IGt2
bV90ZHggKmt2bV90ZHggPSB0b19rdm1fdGR4KGt2bSk7DQo+IAlzdHJ1Y3QgdGR4X3ByZWFsbG9j
ICpwcmVhbGxvYyA9ICZrdm1fdGR4LT5wcmVhbGxvY19zcGxpdF9jYWNoZTsNCj4gCWludCBjbnQg
PSB0ZHhfbWluX3NwbGl0X2NhY2hlX3N6KGt2bSwgbGV2ZWwpOw0KPiANCj4gCXdoaWxlIChSRUFE
X09OQ0UocHJlYWxsb2MtPmNudCkgPCBjbnQpIHsNCj4gCQlzdHJ1Y3QgcGFnZSAqcGFnZSA9IGFs
bG9jX3BhZ2UoR0ZQX0tFUk5FTCk7wqAgPD09PT0gR0ZQX0tFUk5FTF9BQ0NPVU5UDQo+IA0KPiAJ
CWlmICghcGFnZSkNCj4gCQkJcmV0dXJuIC1FTk9NRU07DQo+IA0KPiAJCXNwaW5fbG9jaygma3Zt
X3RkeC0+cHJlYWxsb2Nfc3BsaXRfY2FjaGVfbG9jayk7DQo+IAkJbGlzdF9hZGQoJnBhZ2UtPmxy
dSwgJnByZWFsbG9jLT5wYWdlX2xpc3QpOw0KPiAJCXByZWFsbG9jLT5jbnQrKzsNCj4gCQlzcGlu
X3VubG9jaygma3ZtX3RkeC0+cHJlYWxsb2Nfc3BsaXRfY2FjaGVfbG9jayk7DQo+IAl9DQo+IA0K
PiAJcmV0dXJuIDA7DQo+IMKgIH0NCg0K

