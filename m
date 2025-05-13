Return-Path: <kvm+bounces-46384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D3CEAB5D93
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 22:16:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D0413B6DAA
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 20:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23BEF1F30B2;
	Tue, 13 May 2025 20:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XiJnCYyC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A85D53365;
	Tue, 13 May 2025 20:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747167353; cv=fail; b=fBMx+6dSGDJCd8mnEtBY3+1aOdI4j0jcODIrnucobo8rCluWdZIMqr58jz0Z0Q4NHszV8uHBenn7ugSbqLAj9zDUyltMGxlFsb/uGWNgEdDnHKH2Vs+9vOe1Auw+XHJTS7xVDYabpU42k0xx2hQf7NLwuSFhlt0QbPV9F3mKhwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747167353; c=relaxed/simple;
	bh=fMNUI/0dxw3obaWBg92US11q264SKzPC9ZxhHOS2wVY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QhM7m7mlYl5Yno+IzCdPJW0h8vmsQt9blndbRVsU6bVVH12Mq17pq7ZsJhGlXCJqtvxLGmw/Qp4Zk/qdg8AsCscqbnuVD9MVM1QI/mRFuCAUVXM6WigV2XMM1A5gxyaHgNlhafwSwHN6UB0dDGx+UWfNQuMT4qu8C8J+y6iGbes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XiJnCYyC; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747167352; x=1778703352;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fMNUI/0dxw3obaWBg92US11q264SKzPC9ZxhHOS2wVY=;
  b=XiJnCYyCIbrsbmm7rJiVPk0fUbtHGC+oUaWTrKacGNg4E2ZbNfboXAzC
   SXGCHZZ/eqrelS6sNMBN3jIRfz3RQhTXyEeDJtgRN75+w+4o2NXbmUSOg
   e3AALpRoo9e6zQh2NZBRydcHto1awUSYj5y7F74myBebP666PCLawidrm
   H5IxTpDrclePAsubHA3mDvczQRdIa0KbKLFfBKnXRP1+AHV9bNIhM8Yxz
   Qd+UkJqofwApmKXILl9U86pbyZKdI7HBIcZGcUXmijPQ3NM7AiFGnr6CV
   y0o6MYb7t1uBZvgOH55aZFCSdNwJVUyQF9+u7g/lbDGHDYpi6b9KpawgR
   w==;
X-CSE-ConnectionGUID: GUD4Su8lQOanJJKlzK8VDg==
X-CSE-MsgGUID: ytN9eJVrSWu5z6rnTDnKrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="60374946"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="60374946"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 13:15:51 -0700
X-CSE-ConnectionGUID: PZ63ahLvTPyr56GEca6eZQ==
X-CSE-MsgGUID: 0XHCLQG9THqEKA8DKw7PTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="142570510"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 13:15:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 13:15:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 13:15:49 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 13:15:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yd53tq1YRfOTnghxaW6BNdb++3NGgFgBM+hyZw4MQW8SHSV5B/EGKb5TuhgYZV+r1RjD/aOjNS742Is8/4pJFYfAmSUPEj7y/0irIItwzfrvDz8G/UmO0sCRfnWFpc0hDKyAF1HRiqFmd47+2mhTdA+DWXdw5DK2SExjOfMXRmgG3XxpFrwq7uTxKC/S9B+NuLA9DyNhHmYBiXKmbB/pYLQcLsya4x5SSX9oYiGYbq6yG7slp8B/RvuYR3/et46jUkyLr+CGbLoYkt3njXCIHTNehRLSjvyRepWyPG7FqKhtTw0M0wjWbd7pcj247RePcZHaI95RdziF6P6aIayjmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fMNUI/0dxw3obaWBg92US11q264SKzPC9ZxhHOS2wVY=;
 b=pqmnBJkMpL9LgXKCk/PwZyjRzLk6gBrLj2nQa0xpE2H3TCFtPWeajgQQmlFdlsIh8KjFSYfLbc+Gl4TtS4Yb3sznWF1VvpkyN31nwHG8QVCv7nmsnZW8Ta10OB98TQFOzQX0+PmXlFIZpm4kGr9WPIwLf+haf6GnrFJXni5Ov4EM13pK+gfgaNaOX6cBmRzuR42K0Ragk8vq/6gN0z5hJLSoM92WFyVuLUszlrcCWXrzpc7RLQgVsjtjZiF8kpeBXrk1vkuMVG2aY2ywWfATgi2MksjH4vQLtv9sDpbq/lk5n4JnCgGTtQ/C9Ifho+KHHihSBiGYpedXeZr62cSIJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB7032.namprd11.prod.outlook.com (2603:10b6:303:227::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Tue, 13 May
 2025 20:15:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Tue, 13 May 2025
 20:15:14 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 10/21] KVM: x86/mmu: Disallow page merging (huge page
 adjustment) for mirror root
Thread-Topic: [RFC PATCH 10/21] KVM: x86/mmu: Disallow page merging (huge page
 adjustment) for mirror root
Thread-Index: AQHbtMY0fWGadiEOpUminaJ+lP6+0bPRHeuA
Date: Tue, 13 May 2025 20:15:14 +0000
Message-ID: <9d18a0edab6e25bf785fd3132bc5f345493a6649.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030634.369-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030634.369-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB7032:EE_
x-ms-office365-filtering-correlation-id: 0eae9813-6b20-4326-61e7-08dd925adef8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?STFFalQ3QXN1WGhrd0dNeXB6UGU4NXhpUFJKNTFicStCUWQxWnFDVklFUkpz?=
 =?utf-8?B?MCtQMzk0MS9MZ2NSWDRlWTd1UFlsYlV1L3MwMlZrLzR1RGw5V254Q3o4S1Y4?=
 =?utf-8?B?SDA1QkNQYzhWMERBeWo2TU5KTnFxVWI0MklMZkM3MG50TThQdmErSXNGMVcw?=
 =?utf-8?B?Y0JkR2UxRm9DUG1CUktBV3k4ZFNucGlFWTlsU1pNcllPc3NvYjkrMTdwYytV?=
 =?utf-8?B?NTRlSlZPVjYzVk1QdWlPa2c5VjUwYzd5WVlVZnpHSTFMZUZscUp4bXdCay8w?=
 =?utf-8?B?QVk0bE9sTFM2S21TRDFRL3Zoc29KQzdKZDRvWWRneUs3MEl3T0tHd2ZTZkVo?=
 =?utf-8?B?Myt3aDdmRUN5SEJIa3VDN2VGcnVxblNBMmZ3ekc3QU44OUMxK0NuVFM5NnRM?=
 =?utf-8?B?SENkNzhrcDhoVjZkM200dnBHME9SY0w5NlRla1R1Z0ZLZ0lwVEVNc08vRHBn?=
 =?utf-8?B?NzZHRTBOWmd2dXUvT2xzT3VTNlN5Z3ZCbHlKZERKbGYwM0J6a0xDdGs1eGhu?=
 =?utf-8?B?Q3lGODVwTURPQTBZQ09ZcjFVbW9mUVZ1eUY1Z2xMdE54N0FmYS9MQmRwNEd0?=
 =?utf-8?B?YTlicWpLUmJiM2JxVnkxNk5XbmQ5U3RWdERNRmVVQmtvMDdXZTlFa3kwclhG?=
 =?utf-8?B?cWZXMmY0NldQbGdKZDdlbnJ1eXF3UUVQeFp2VnlyRloyL21FUVZUTXZlZnFj?=
 =?utf-8?B?VUdrcUFLRU1QZjlWdytyc0FyREhBNWoxTXh6MEMzQUlNMjVQdXNOVk9rbVFu?=
 =?utf-8?B?UHdKekkrTGtBMDhOS3MydDRKb0oyTjJiaW1DL3ZOOHV3Qm5rN1p3bHI5NEQ3?=
 =?utf-8?B?bHdYZzZWb3JWUzRaSGllTmdMWWQ0VFQrSzFKSTE0bjAwbnVQWG04VldCQmJp?=
 =?utf-8?B?cjJJaHArODdQRExYY2hNeFdRZk13ZENOc0FrelNabEozakQySUgwemF1YXRO?=
 =?utf-8?B?SmlxRHBmN3kzU1M5UzhERmVOY0kyOVpGcUIxQUNRS0NxT3N6Um9hUVBKb0oy?=
 =?utf-8?B?M1NPNDhXU0grYm1xL1lLbVZDVHhFTHBBRldtSGo0enYrcG4zMU5MQkJjYkRm?=
 =?utf-8?B?MHdudnlRUTc0Q0JqRlBIeXZKTlJWNmUyc1ZHZ21EYlVKbUQwK3d0Nk1PTS9m?=
 =?utf-8?B?UjVFbDR5QTNCWXZuZEpqRmJvZ3BuMkVzY1pQcVhGVDBKR0xWVGNja25SOERU?=
 =?utf-8?B?bU1SNmorRWJrMXgrZzlTajVzVE5TbWRSb2Y0Wm5zaWp6d3lZMmxnY2tFV3cx?=
 =?utf-8?B?UTlzUDdzMENMQ2IvUnIxMTIxajR5dmw4bFhwRWdaVTg4MnlFbEUrbTBCQ3JM?=
 =?utf-8?B?RndEelFGQ2o5U1kwZnkvMktLTUtOdEZDZGMvWUV6aUZvQTYxMTNoNkRDUk9j?=
 =?utf-8?B?N1JmWXJ3M0dWSmxWUlF2bUg0YWYrT2R6ZHltOWwycGg4MGowTEJ4Q1dvWVZj?=
 =?utf-8?B?Unp6em9XRDBFK3FWd1kzWlhhcTJjR0ZGdjZVOEVER05hV1UxL0dXZUduRXE4?=
 =?utf-8?B?MTRvdWRlcmE2OFhNdmpSY3htUTFBS1ZKRnpIZFZJSDhQYUxDV2J1bkVYV0tS?=
 =?utf-8?B?Z0syTlRFRmNIMjhCYmpHS0FvRGw4QW5OQWdyVGhLR2hBS1d5bG03RngvZ1Y3?=
 =?utf-8?B?ZkRNeTAvdTAydERxODVvek5EZkRtS29Dd016bUQwN1RIR0YreW8vMURuVkh5?=
 =?utf-8?B?ZW4xZHNWM1hNQjRpUWpqdnFvRlJHcVpzRmQ0U0ZSOFF1clN3V0VLMC9GZ3lM?=
 =?utf-8?B?U254QTNXNmZQNW5KT0VNNDFLcDdIWXZkZnMyWU90YUJkaTZsNzFVN29leWhH?=
 =?utf-8?B?aHdRUW5nSk5WV3gvYjdxSCt4Z0dLOHU1a1RINWhVa3RjdHFBQ0Q0WnFkRkgy?=
 =?utf-8?B?REdDUS82d041WHVITFY1N0U5a2NYUUJBaFFid1QwT21NUTBPQVVEd2FjVWhV?=
 =?utf-8?B?cHdyWHZLbGsrK01hQTVpMDIzYmk2NUlqbmVwN0wwZlF1ZUk3SzlVYksvbDJP?=
 =?utf-8?B?aVFRTDZzUUlnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXV1QlFFd3hZU3pRSU1Lc1pFNWlTQ2c0NjUwRlpmUEtmSFYxeERnUlZrNzUr?=
 =?utf-8?B?NGl6UEZxQmpOUGd5c3Z0aCtSWEJVQ25FT2FST3ZvUWVPcUhKcXdyS1llWkxP?=
 =?utf-8?B?VmtvU0dRbXk2UVZnQ0FLQjV5Q3NJRVNGTWpJWTF2RHd2QTArcUdHbHhSQ1A1?=
 =?utf-8?B?TkUrbFRKcmg3Vm1VNHMrdlRsQ2JhTy9rWlEwTENiQkpnNmdqZ1BDeVpBeFBt?=
 =?utf-8?B?YWxPY1JNVjNuQ1pCT051dTREd2N2MHBIQUlLZTdsVGdsTWZkY1BMb1NHSmVN?=
 =?utf-8?B?eGYwRFMycnJQazdKOHBEdzl4QWFCek9Mb0p1T0JocG8wdDg2bTU2ZWZldGNO?=
 =?utf-8?B?UHdDa1JaY1Jrbm1jLzJRc3FjM0NXZWV0anpCMzJxUlo0bElmTDM4bW55bm1B?=
 =?utf-8?B?aHQ4U2txNkFwOTBpT3o0RkFhczZYUmh4SzkvRkhlYW9hN2tKZ1dtL3FsM0pZ?=
 =?utf-8?B?b2dqY21tRWVKOEQzWkpRWVk0b3FOYTlsaitQcHpTQ3pHaTE3TGVQcUt4VEhr?=
 =?utf-8?B?YTdZYklZNHZnMjJCUy9qZkx4a2trdWVsZEFJOWhCWVJvdzVITnpDWms2SHZp?=
 =?utf-8?B?T1ZHTGN0ZGNkSWM0UzRzcGl3bG9aV1JXaW1XZ2YyWVg0b2tPUlZsSXk5cmVZ?=
 =?utf-8?B?QytTRm9EcCtaWFQ3aXA1ek50amxOQzFvRkU1bTZnY1VLRHJkaDB4bzByQVRa?=
 =?utf-8?B?TlltQmdoRzc0L2ZSSUVqaFZyRnJBN2ZNdCt2c201aTE5dDNjdXgxdVdBNnF6?=
 =?utf-8?B?eHJhWHd3TDN5UnpCR3Frb01FRFNrcG5XQ3BqbjVTTEdnMkJQeUNqNmVTbE1V?=
 =?utf-8?B?RCt3Vm1EK1pMeWE5N3hQNURZUERLdUF3blhQVll0dTA5bVpVZTMwZkJJOW8z?=
 =?utf-8?B?YmN6ZWNPcWZQL1RLbXlEUmRCa08xNzVocFM5c05JcThka2pIM05UQUhyMk1T?=
 =?utf-8?B?dUFpZk5JclVFVU9HcnZ3WWZkMjNVMVhOQXQzTUsxQ3Z5Qk9hZ01UWFVqek9o?=
 =?utf-8?B?YXFKbjBNNVVTNCtlUTJHbGd1MXRmMDB0UXhtNngzSFExVDRhU1NkSERqdkx0?=
 =?utf-8?B?TjhrVU4rTDZYVGIrR3dYcnVzOXdHQWJaZ1ZlUFlBQjY2Z0wvRU5yK2lmTzYy?=
 =?utf-8?B?QXNwZmJ4NHUzSGtjeklWSDhHdlUxL0tXb0w0dWZ2TG9pbm9IWnNjb1R5K2RN?=
 =?utf-8?B?UUJLdVl4LzN6K1JXU2MzUm9QOGhkREQ3Y3BrRzNHN2VXRWg2NCtweitSZFFh?=
 =?utf-8?B?U0dmbStVZ3k1NDlLVGxPdzRuZ2ZwOGtRbkhKUCszNjV5TlpqZXVyeFNOTmhH?=
 =?utf-8?B?UFI1TWRWV0hkeWhrZ0lzOWZhcUpoNTZEWjZrQjd6VmhTY2hnUnVDTi9veDZT?=
 =?utf-8?B?US9DR0UyNUt1S0htMENMRDNsOWZ0eUU0d1g5bEpCQjVyTUdxZnZraStnUm00?=
 =?utf-8?B?aG9hRU9RMXdzMVo0WWpiWml4WkZlZ0Q0THFJSE8vWk96L1RIVlBHaVIrdHo3?=
 =?utf-8?B?Z0ZBSkwySW1yVWRLSlptdHpHNWFFbUZUVEdJWWQySDdzNkxuWndlNUhjWDFG?=
 =?utf-8?B?QkJSVDlWaHAxcVV3dE5nTlA4cVRVTXFtKzF5ZjdCMEYzRS8wRFIvLytMVlgy?=
 =?utf-8?B?RFdhUCtUaU9RWERNZHcwMEZFWnRiNXlEb24vTkNwT0ExVG1lOC9VTk1la25J?=
 =?utf-8?B?T01hSGwzT09oL2g0MThacE1EcnFWUEQ1T3NvSVZhcUt3Yi9DcVFuMHZvS1po?=
 =?utf-8?B?S3prOEZiN0drbkxkVWFLN0VZMWJ4cFZDbTYyb1RPUm5EWFJua1dwZEpBc0w4?=
 =?utf-8?B?Mmprand6aURZREp3bUs0Ty9mSHJWQ2FpWkQxa1dvR2dzanB4ejZXVERSaW53?=
 =?utf-8?B?bTQ1MjZLMnFuZTRFUTZxM0N5T3dzZDRsdmNXN0UrdUk1MU5JQ3BjNkpyTFI3?=
 =?utf-8?B?K0N4cVRrSmRGVUFhMjR5THFoSVVoTWRwZVA1dnNqVk92UmVYVGZrRk9oc2o4?=
 =?utf-8?B?d01HT2t4dVJrdHhlMkdMU25Ib05IeXhPVldRRm81NStPY0dNUjlmcXlEZmxE?=
 =?utf-8?B?cHhTNEtoWDFSZ1JpZHpjYkpucHRmVjdrOUJxTTNCVjZ0S243RFl6QTJZdEJX?=
 =?utf-8?B?a2JBYjJIaHkyNFp6OVZJbG9LeUVRU3lZWkhNdEZWaEx4MWFKQmFjUVp1NE4w?=
 =?utf-8?Q?LZDsdStkbcHTntH5iHU28P8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F6CAD8C539CB1E4BB9817EEBE09B4543@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eae9813-6b20-4326-61e7-08dd925adef8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 20:15:14.1857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XFEv1u3aCXmz9NINiXWHm/z632TvZdc0FT10LZ7F6zWP5f/VyLFY/zTvtOE47hYVRwXW+f4aGEc5iQ7lg0+Z5GkaKLAXk17BgdkdPKDS1IQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7032
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA2ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gRnJv
bTogIkVkZ2Vjb21iZSwgUmljayBQIiA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo+IA0K
PiBEaXNhbGxvdyBwYWdlIG1lcmdpbmcgKGh1Z2UgcGFnZSBhZGp1c3RtZW50KSBmb3IgbWlycm9y
IHJvb3QgYnkgbGV2ZXJhZ2luZw0KPiB0aGUgZGlzYWxsb3dlZF9odWdlcGFnZV9hZGp1c3QoKS4N
Cj4gDQo+IFtZYW46IFBhc3NpbmcgaXNfbWlycm9yIHRvIGRpc2FsbG93ZWRfaHVnZXBhZ2VfYWRq
dXN0KCldDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBFZGdlY29tYmUsIFJpY2sgUCA8cmljay5wLmVk
Z2Vjb21iZUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFlhbiBaaGFvIDx5YW4ueS56aGFv
QGludGVsLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vbW11L21tdS5jICAgICAgICAgIHwg
NiArKystLS0NCj4gIGFyY2gveDg2L2t2bS9tbXUvbW11X2ludGVybmFsLmggfCAyICstDQo+ICBh
cmNoL3g4Ni9rdm0vbW11L3BhZ2luZ190bXBsLmggIHwgMiArLQ0KPiAgYXJjaC94ODYva3ZtL21t
dS90ZHBfbW11LmMgICAgICB8IDcgKysrKy0tLQ0KPiAgNCBmaWxlcyBjaGFuZ2VkLCA5IGluc2Vy
dGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3Zt
L21tdS9tbXUuYyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gaW5kZXggYTI4NGRjZTIyN2Ew
Li5iOTIzZGVlZWI2MmUgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4g
KysrIGIvYXJjaC94ODYva3ZtL21tdS9tbXUuYw0KPiBAQCAtMzMyNiwxMyArMzMyNiwxMyBAQCB2
b2lkIGt2bV9tbXVfaHVnZXBhZ2VfYWRqdXN0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0
IGt2bV9wYWdlX2ZhdWx0ICpmYXVsdA0KPiAgCWZhdWx0LT5wZm4gJj0gfm1hc2s7DQo+ICB9DQo+
ICANCj4gLXZvaWQgZGlzYWxsb3dlZF9odWdlcGFnZV9hZGp1c3Qoc3RydWN0IGt2bV9wYWdlX2Zh
dWx0ICpmYXVsdCwgdTY0IHNwdGUsIGludCBjdXJfbGV2ZWwpDQo+ICt2b2lkIGRpc2FsbG93ZWRf
aHVnZXBhZ2VfYWRqdXN0KHN0cnVjdCBrdm1fcGFnZV9mYXVsdCAqZmF1bHQsIHU2NCBzcHRlLCBp
bnQgY3VyX2xldmVsLCBib29sIGlzX21pcnJvcikNCj4gIHsNCj4gIAlpZiAoY3VyX2xldmVsID4g
UEdfTEVWRUxfNEsgJiYNCj4gIAkgICAgY3VyX2xldmVsID09IGZhdWx0LT5nb2FsX2xldmVsICYm
DQo+ICAJICAgIGlzX3NoYWRvd19wcmVzZW50X3B0ZShzcHRlKSAmJg0KPiAgCSAgICAhaXNfbGFy
Z2VfcHRlKHNwdGUpICYmDQo+IC0JICAgIHNwdGVfdG9fY2hpbGRfc3Aoc3B0ZSktPm54X2h1Z2Vf
cGFnZV9kaXNhbGxvd2VkKSB7DQo+ICsJICAgIChzcHRlX3RvX2NoaWxkX3NwKHNwdGUpLT5ueF9o
dWdlX3BhZ2VfZGlzYWxsb3dlZCB8fCBpc19taXJyb3IpKSB7DQo+ICAJCS8qDQo+ICAJCSAqIEEg
c21hbGwgU1BURSBleGlzdHMgZm9yIHRoaXMgcGZuLCBidXQgRk5BTUUoZmV0Y2gpLA0KPiAgCQkg
KiBkaXJlY3RfbWFwKCksIG9yIGt2bV90ZHBfbW11X21hcCgpIHdvdWxkIGxpa2UgdG8gY3JlYXRl
IGENCj4gQEAgLTMzNjMsNyArMzM2Myw3IEBAIHN0YXRpYyBpbnQgZGlyZWN0X21hcChzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fcGFnZV9mYXVsdCAqZmF1bHQpDQo+ICAJCSAqIGxh
cmdlIHBhZ2UsIGFzIHRoZSBsZWFmIGNvdWxkIGJlIGV4ZWN1dGFibGUuDQo+ICAJCSAqLw0KPiAg
CQlpZiAoZmF1bHQtPm54X2h1Z2VfcGFnZV93b3JrYXJvdW5kX2VuYWJsZWQpDQo+IC0JCQlkaXNh
bGxvd2VkX2h1Z2VwYWdlX2FkanVzdChmYXVsdCwgKml0LnNwdGVwLCBpdC5sZXZlbCk7DQo+ICsJ
CQlkaXNhbGxvd2VkX2h1Z2VwYWdlX2FkanVzdChmYXVsdCwgKml0LnNwdGVwLCBpdC5sZXZlbCwg
ZmFsc2UpOw0KPiAgDQo+ICAJCWJhc2VfZ2ZuID0gZ2ZuX3JvdW5kX2Zvcl9sZXZlbChmYXVsdC0+
Z2ZuLCBpdC5sZXZlbCk7DQo+ICAJCWlmIChpdC5sZXZlbCA9PSBmYXVsdC0+Z29hbF9sZXZlbCkN
Cj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvbW11X2ludGVybmFsLmggYi9hcmNoL3g4
Ni9rdm0vbW11L21tdV9pbnRlcm5hbC5oDQo+IGluZGV4IGRiOGYzM2U0ZGU2Mi4uMWMxNzY0ZjQ2
ZTY2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L21tdV9pbnRlcm5hbC5oDQo+ICsr
KyBiL2FyY2gveDg2L2t2bS9tbXUvbW11X2ludGVybmFsLmgNCj4gQEAgLTQxMSw3ICs0MTEsNyBA
QCBzdGF0aWMgaW5saW5lIGludCBrdm1fbW11X2RvX3BhZ2VfZmF1bHQoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1LCBncGFfdCBjcjJfb3JfZ3BhLA0KPiAgaW50IGt2bV9tbXVfbWF4X21hcHBpbmdfbGV2
ZWwoc3RydWN0IGt2bSAqa3ZtLA0KPiAgCQkJICAgICAgY29uc3Qgc3RydWN0IGt2bV9tZW1vcnlf
c2xvdCAqc2xvdCwgZ2ZuX3QgZ2ZuKTsNCj4gIHZvaWQga3ZtX21tdV9odWdlcGFnZV9hZGp1c3Qo
c3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3ZtX3BhZ2VfZmF1bHQgKmZhdWx0KTsNCj4g
LXZvaWQgZGlzYWxsb3dlZF9odWdlcGFnZV9hZGp1c3Qoc3RydWN0IGt2bV9wYWdlX2ZhdWx0ICpm
YXVsdCwgdTY0IHNwdGUsIGludCBjdXJfbGV2ZWwpOw0KPiArdm9pZCBkaXNhbGxvd2VkX2h1Z2Vw
YWdlX2FkanVzdChzdHJ1Y3Qga3ZtX3BhZ2VfZmF1bHQgKmZhdWx0LCB1NjQgc3B0ZSwgaW50IGN1
cl9sZXZlbCwgYm9vbCBpc19taXJyb3IpOw0KPiAgDQo+ICB2b2lkIHRyYWNrX3Bvc3NpYmxlX254
X2h1Z2VfcGFnZShzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fbW11X3BhZ2UgKnNwKTsNCj4g
IHZvaWQgdW50cmFja19wb3NzaWJsZV9ueF9odWdlX3BhZ2Uoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1
Y3Qga3ZtX21tdV9wYWdlICpzcCk7DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L3Bh
Z2luZ190bXBsLmggYi9hcmNoL3g4Ni9rdm0vbW11L3BhZ2luZ190bXBsLmgNCj4gaW5kZXggNjhl
MzIzNTY4ZTk1Li4xNTU5MTgyMDM4ZTMgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUv
cGFnaW5nX3RtcGwuaA0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L3BhZ2luZ190bXBsLmgNCj4g
QEAgLTcxNyw3ICs3MTcsNyBAQCBzdGF0aWMgaW50IEZOQU1FKGZldGNoKShzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsIHN0cnVjdCBrdm1fcGFnZV9mYXVsdCAqZmF1bHQsDQo+ICAJCSAqIGxhcmdlIHBh
Z2UsIGFzIHRoZSBsZWFmIGNvdWxkIGJlIGV4ZWN1dGFibGUuDQo+ICAJCSAqLw0KPiAgCQlpZiAo
ZmF1bHQtPm54X2h1Z2VfcGFnZV93b3JrYXJvdW5kX2VuYWJsZWQpDQo+IC0JCQlkaXNhbGxvd2Vk
X2h1Z2VwYWdlX2FkanVzdChmYXVsdCwgKml0LnNwdGVwLCBpdC5sZXZlbCk7DQo+ICsJCQlkaXNh
bGxvd2VkX2h1Z2VwYWdlX2FkanVzdChmYXVsdCwgKml0LnNwdGVwLCBpdC5sZXZlbCwgZmFsc2Up
Ow0KPiAgDQo+ICAJCWJhc2VfZ2ZuID0gZ2ZuX3JvdW5kX2Zvcl9sZXZlbChmYXVsdC0+Z2ZuLCBp
dC5sZXZlbCk7DQo+ICAJCWlmIChpdC5sZXZlbCA9PSBmYXVsdC0+Z29hbF9sZXZlbCkNCj4gZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jIGIvYXJjaC94ODYva3ZtL21tdS90
ZHBfbW11LmMNCj4gaW5kZXggNDA1ODc0ZjRkMDg4Li44ZWUwMTI3N2NjMDcgMTAwNjQ0DQo+IC0t
LSBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS9tbXUv
dGRwX21tdS5jDQo+IEBAIC0xMjQ0LDYgKzEyNDQsNyBAQCBpbnQga3ZtX3RkcF9tbXVfbWFwKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IGt2bV9wYWdlX2ZhdWx0ICpmYXVsdCkNCj4gIAlz
dHJ1Y3QgdGRwX2l0ZXIgaXRlcjsNCj4gIAlzdHJ1Y3Qga3ZtX21tdV9wYWdlICpzcDsNCj4gIAlp
bnQgcmV0ID0gUkVUX1BGX1JFVFJZOw0KPiArCWJvb2wgaXNfbWlycm9yID0gaXNfbWlycm9yX3Nw
KHJvb3QpOw0KPiAgDQo+ICAJa3ZtX21tdV9odWdlcGFnZV9hZGp1c3QodmNwdSwgZmF1bHQpOw0K
PiAgDQo+IEBAIC0xMjU0LDggKzEyNTUsOCBAQCBpbnQga3ZtX3RkcF9tbXVfbWFwKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgc3RydWN0IGt2bV9wYWdlX2ZhdWx0ICpmYXVsdCkNCj4gIAlmb3JfZWFj
aF90ZHBfcHRlKGl0ZXIsIGt2bSwgcm9vdCwgZmF1bHQtPmdmbiwgZmF1bHQtPmdmbiArIDEpIHsN
Cj4gIAkJaW50IHI7DQo+ICANCj4gLQkJaWYgKGZhdWx0LT5ueF9odWdlX3BhZ2Vfd29ya2Fyb3Vu
ZF9lbmFibGVkKQ0KPiAtCQkJZGlzYWxsb3dlZF9odWdlcGFnZV9hZGp1c3QoZmF1bHQsIGl0ZXIu
b2xkX3NwdGUsIGl0ZXIubGV2ZWwpOw0KPiArCQlpZiAoZmF1bHQtPm54X2h1Z2VfcGFnZV93b3Jr
YXJvdW5kX2VuYWJsZWQgfHwgaXNfbWlycm9yKQ0KDQpNYXliZSB3ZSBzaG91bGQgcmVuYW1lIG54
X2h1Z2VfcGFnZV93b3JrYXJvdW5kX2VuYWJsZWQgdG8gc29tZXRoaW5nIG1vcmUgZ2VuZXJpYw0K
YW5kIGRvIHRoZSBpc19taXJyb3IgbG9naWMgaW4ga3ZtX21tdV9kb19wYWdlX2ZhdWx0KCkgd2hl
biBzZXR0aW5nIGl0LiBJdCBzaG91bGQNCnNocmluayB0aGUgZGlmZiBhbmQgY2VudHJhbGl6ZSB0
aGUgbG9naWMuDQoNCj4gKwkJCWRpc2FsbG93ZWRfaHVnZXBhZ2VfYWRqdXN0KGZhdWx0LCBpdGVy
Lm9sZF9zcHRlLCBpdGVyLmxldmVsLCBpc19taXJyb3IpOw0KPiAgDQo+ICAJCS8qDQo+ICAJCSAq
IElmIFNQVEUgaGFzIGJlZW4gZnJvemVuIGJ5IGFub3RoZXIgdGhyZWFkLCBqdXN0IGdpdmUgdXAg
YW5kDQo+IEBAIC0xMjc4LDcgKzEyNzksNyBAQCBpbnQga3ZtX3RkcF9tbXVfbWFwKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgc3RydWN0IGt2bV9wYWdlX2ZhdWx0ICpmYXVsdCkNCj4gIAkJICovDQo+
ICAJCXNwID0gdGRwX21tdV9hbGxvY19zcCh2Y3B1KTsNCj4gIAkJdGRwX21tdV9pbml0X2NoaWxk
X3NwKHNwLCAmaXRlcik7DQo+IC0JCWlmIChpc19taXJyb3Jfc3Aoc3ApKQ0KPiArCQlpZiAoaXNf
bWlycm9yKQ0KPiAgCQkJa3ZtX21tdV9hbGxvY19leHRlcm5hbF9zcHQodmNwdSwgc3ApOw0KPiAg
DQo+ICAJCXNwLT5ueF9odWdlX3BhZ2VfZGlzYWxsb3dlZCA9IGZhdWx0LT5odWdlX3BhZ2VfZGlz
YWxsb3dlZDsNCg0K

