Return-Path: <kvm+bounces-62761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8631BC4D4B6
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 12:07:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B5FA420C45
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 11:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5892357A4A;
	Tue, 11 Nov 2025 10:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gWpJxzX+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3C335502B;
	Tue, 11 Nov 2025 10:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762858554; cv=fail; b=TcAd8dzDSKrRzo6o82WJSxpnY8koMeVGN+dB6doRDrTcyXdwBSB3GZkdv9Y+hDWf3X08DpWqBRxwDE+6oW33c60UjH+ghQ56nJY+Mb+6OQrtMDFNmOQhiNBWWzXbx3ZAkcqhHWhkw+EzFyd+pz5CRGOvKlTo8dZsQBCaI6cwIlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762858554; c=relaxed/simple;
	bh=uxDf4Wx9n1Twio20Xn+f2/HphuvQgvMoX37O0rLeuJI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BOa3ymz2Ue1ZN5ud92B/yqNTnTXWajzk+bkQrSrfWJaeypKKpGecHbI5hGP3pVsJeOJfGRhqhs72VFsQqCK2pub8pabiGG3QelpdyW1IaGgXc7GoGTAjaOxIDjhH1BhfbHXQfY7Ly3N2DOU4nHyA9XPjwdkCaEXDFbQS9BO0ap4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gWpJxzX+; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762858552; x=1794394552;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uxDf4Wx9n1Twio20Xn+f2/HphuvQgvMoX37O0rLeuJI=;
  b=gWpJxzX+t6J0TBaDXQ8d1brxK4BPLSchwNf/Y0Yw6uujfO172cWWyhUG
   eKN4VQSNQ7qA2gpVXp9xackvxjHAdmNeDXCIS1h3KmKr397XMUDRHBJKF
   aBvQ4ZvUdnYBjOCE/F+G8QN2n+vnHnbTivZ09DcSadTkb0LXzgVFkrORJ
   RLh2xIhJvQdUS6j/+zOCa1ZXq3UDSQkAH+G0vkskF5eCTTCqHP2foCpmR
   6eISNgdWGbFd9mkrY+6WtUG6EOSxet77hA+Uezj1hM58i6DNjp1+8hosU
   GE7QEuWMn7/8DnLabj+jLylHYflGK3Hw+8rS7CgmVcTGuaGFxbNsXwOvM
   Q==;
X-CSE-ConnectionGUID: h+z8fHm0QbCe561T7cittA==
X-CSE-MsgGUID: pMOp8xjSSVqg9QVhzfLV6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="68778812"
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="68778812"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 02:55:51 -0800
X-CSE-ConnectionGUID: Zq1OdJE7RdizWkxhz9ZA0w==
X-CSE-MsgGUID: IZkYAfY8RiSp5OzoazehEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="193049781"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 02:55:52 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 02:55:50 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 02:55:50 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.0) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 02:55:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HsVnNdquvPyYvc3mxooDLS3iOiIW1c7ryaku6LLTPzoWv4jPdT69VhXiJGUu9RhFsdMHV+EnexQb2401jCCpY73bT/1zXf9tfHhUaWQaJlBHHJ2QTDm+vpFrXXVPcYLYunqvCZCjLh+QG3IBwYB8kSv2gnmpB/T7j5qt8tBbF8ZYt1Rj1U85+q6sV3SzXIVz8no2KWNUeSG93jK7F1wHKOvWQ560uBw16HbXwoEfwoj5Cn1s/7Rk2nBP8sCI1nglwur6y0e1iWvZFq7UHoMCFk9nK+qa+Ocx1IvTxzebWF8uFYtO9amD/BY7JAXxtsJ6w0FxYukUgBN1QI6VVoBV5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxDf4Wx9n1Twio20Xn+f2/HphuvQgvMoX37O0rLeuJI=;
 b=s1ImqdsoEhPnYHAQhc6fhvYjETeaI1erITj9xB7iN4t+3sAurmi8hHRsl0tKWItAAGhANI9IS5Jb3TcW6es2/RTkYOL+r5xy3sawfSMJ0zGI4j3DY8qEtaVmAlwu2evQRD9+Vo4pi3ViYFjuq9pgWJxfgbg325W8nGIbyXoP20DcklM7QjgQdLq2R9hJO33xEuiw/8v6LySqCQ832/e5bGmOtW95sM7wr+ax7aTqPoqtMrv6CddPkt2H+W2V1Sa0FfspcQjofm37s/zEnUrGjSaUXfVLvFnbTlE4ibJ18edMcTmpvr1QLVP3IakNH/j1c0nPwuyN2dJ3NFSR+nJXFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM4PR11MB6501.namprd11.prod.outlook.com (2603:10b6:8:88::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.16; Tue, 11 Nov 2025 10:55:46 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Tue, 11 Nov 2025
 10:55:46 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "zhiquan1.li@intel.com"
	<zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "pgonda@google.com"
	<pgonda@google.com>
Subject: Re: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings if
 a VMExit carries level info
Thread-Topic: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings
 if a VMExit carries level info
Thread-Index: AQHcB4ATc43XQ6PqxUuwXAgCtykiwLTt5HOA
Date: Tue, 11 Nov 2025 10:55:45 +0000
Message-ID: <183d70ae99155de6233fb705befb25c9f628f88f.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094423.4644-1-yan.y.zhao@intel.com>
In-Reply-To: <20250807094423.4644-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM4PR11MB6501:EE_
x-ms-office365-filtering-correlation-id: 2f29bd3e-e457-4d44-d5e6-08de2110ddef
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RmZsa3N2dU9OSGhaNTU3MXpheVVQM1Z1dG9nODBMNlkxcnQ5Z282RjVRYjBy?=
 =?utf-8?B?b2liSnVjMERQbEpXU1R3ZU5HemUrVnNSSjllVkVxb1poWThzSzZRVnBFV3Vq?=
 =?utf-8?B?N1F4SDZRbUNmSTJGa0NPbjVPaGJWTk84SkhiRHk5SXBrdisyRmpQaEZvcSto?=
 =?utf-8?B?dEZXMTZGWkNIM0FZdEtGUDcwMDRlNnFxMDVqVi9CUUdWYWpXQmNoMmp5MUwy?=
 =?utf-8?B?bnllbWI2aEdiWXZDWTBHNHY2RHltbGtTSTBSU2ZIT1VSZUIwQkk3R0NNd0RY?=
 =?utf-8?B?ZmxxbzJqNlNTNjM2MUJFWnhwYmNJMGI4d29NajJTQjhqYzlUMzlmWmJOVzZi?=
 =?utf-8?B?UzdBeEN0ckQ5QmQ1aG9veHljdHNtNU95b1lnU09lSUhST3JlU3hSTjlZbmU2?=
 =?utf-8?B?NGVPRXFUdDZBK2NIUkF6aFhoZ2llRmNadDNYRFU1ZGM0bkl6WjVLU3luQ2Vi?=
 =?utf-8?B?d2JJTjNRb3VqT3o2blBJdjd5cGF4ejFRTVBRTWtUOEZWblRKVFpwWmxSRFM1?=
 =?utf-8?B?ZFFRTWhhREV3YVNVUXZmRDZCNTBaOXdHS0xKWXVUVDdkM3hoWGs1NVA4VWtM?=
 =?utf-8?B?MklOTlUyWFBpOTlmamRLc2RLWTZROHVFeUhzWmNMd0hJR0QzSmFMNTVBKy9P?=
 =?utf-8?B?SlQ1Q21VL1R6eHp4VlNxaDJxTTExWDhBZnpIL1FCTWYwbWZHVCt6MzE0UkEr?=
 =?utf-8?B?MzFibFVTL2Z5WGs5RUcxS2JlVkVXcnZvZGFGV2J0ZWFRZjVSN2lVaDhlU01V?=
 =?utf-8?B?Tjc5NkdiL0VEQ2NWZ2IyNUpFVmNTdUJtTUowSHE4RGx3VDRsQ1NZemE2Y2Vw?=
 =?utf-8?B?MUJ2WGhqWTlzbXcyUDV6RVNnT1QzME5FRzA0aDNOTGJTWEppWnBwV0xoWUhK?=
 =?utf-8?B?KzU1eUZab1luTjFNV2lVVzJnMDBFbDlvT3pEUndvMStab2NMMXV1T1JXM0Zy?=
 =?utf-8?B?WHJ3SzBHNVZGZ0pQRi85Vzh4dUZ1MkhqOFhCaC8wRDAveVozZTFtaGhHRENG?=
 =?utf-8?B?YWdOZkxOUDI4WXpDQ2QvUXVoYXd0OVNRNENkZWovaytaZSs1ZUVENElETzBi?=
 =?utf-8?B?a0lXdFBnWGVyUXp0YkJQd0pkY000N094UlFkTVNzVWdyZTg5dnlIU3IxZ2dw?=
 =?utf-8?B?ZnJNenFBK2FBalBUL1pjQThFSkFGV0RNaDZFSnpZcC9SSkhsUHpPV3hhYWhl?=
 =?utf-8?B?L3I0RDhsSW9rQW5LWklBQkdJMlF0TnFsL2MybVVjL2h0ditJdzdjSC9NQnJl?=
 =?utf-8?B?RHBXWlErMW9zMmd0d2hXR1g3dzBjTmVqQXQyRFFwbkoyV0NYN2srVmpFNENy?=
 =?utf-8?B?VXMxaEtJMm5iVGczMW9EZVJkZlVMdDJNUTVJWGZ6WTFZVG5UakJkOGZCRnFN?=
 =?utf-8?B?cnYraFkrcXhDN0R0VnNGTUk3QjB1TCtrcTdtQllnbUNFakVIUnRZS1hQMDBm?=
 =?utf-8?B?K01MVlRyMWR3N3Q1K2psVTcvK1NyWElTMk5xbDdSMS9MTWVVYndCV0FVYWhx?=
 =?utf-8?B?djcyQmVkZjRVUFp2R2cvdU1LZExxWElPT2YreTZxZDlMVkdiZTVTTGQrMWFv?=
 =?utf-8?B?YnovYU9od0ZPcy84ZWgrWHI5bVVpN1VUZ01CakIwWFg2c0JrVlpYZzJ2QVZn?=
 =?utf-8?B?SXpzeE0xTHlGcGxldElZQzZhVzczRUkvTEtaT0pYK21IaUU5NXdEMmdNNFhG?=
 =?utf-8?B?aThpUVZpYUxlQmlaOWN0VVlXS3pIT2pReVYxSGhxWTBxTU5TK3NnUHg3ZUtB?=
 =?utf-8?B?aEhmdnpVOTlpblA2c1gwRWFyc3dPOGpjSFNOTS9zeWZhSkMvZW56akUyQWM5?=
 =?utf-8?B?Q0pUanJ1cUE0ZXVaamltL01IZDdJWVZDdXk4aW1XZ2pqZmJtKzNCUGR0eEJX?=
 =?utf-8?B?alp3OTNjb2wxSjNsNmk0WFl1MitrcHJrR1MxSTBhZDd4eU42OWpXcVk0RzJY?=
 =?utf-8?B?SU5EN256Sm0xS3dsN0pkdEpSdUxLeGg1Qnh1WUExUEdSZE5laE5NYVBhTmsx?=
 =?utf-8?B?bm92emQySTdrWE1mQ20vVkJLSGhRcmlMOUxrSDFYZElxcHBGZDVYSWFiNWhZ?=
 =?utf-8?Q?Mu77qT?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmF6dFU2UG5VcDR0M2puL1BVZFNQeS9kd3QyV1UzSExZQ1kwT05za2JKYjdz?=
 =?utf-8?B?V0VsRktJSWYyelBtZS9PVUw2Rm16ZTg2TXl3ZFBPUUI3dEhkS1RPRm1QUHNn?=
 =?utf-8?B?ZGhzWFZQejNOLzBQTFNLalhZRWhFN0UzNXNRRjJ1RlRLYlRiMzYzY1N0YVY0?=
 =?utf-8?B?NUV0a2Z5S3RRSlZPa2dObWF3bUkzemg1K1ZHN0hYUnkvTCsvUGY0SmhzSzlI?=
 =?utf-8?B?b0tzd0RzeGlGMlIwaDJZU1VYN21ocXZqNGM3UUV3RUZDVjJGSHFQYnZSckVs?=
 =?utf-8?B?Y2NwZDNqQ3pvQ2FlcUpwZmJzbmR4dFBIU1p6WnJhcXNmYWNJMnpHR0RYQTYw?=
 =?utf-8?B?NGNrNVFLNW8vWG1YS1RaRHVHbDBibnhDOFRiMUF0clZIL2Fuams0Q0tCalJn?=
 =?utf-8?B?bThUcHhVZ25ZamRJUEhOUlEvUlFwMU8rQkt0R3hUQXBvblhFMndud21UYU10?=
 =?utf-8?B?dytaQkt6cmdaeG9sSmRQejhBK2NxYVh3OHV4QzRWNnpMNGZHNEI1WFZTMlhs?=
 =?utf-8?B?ZXVmKzFUb2IzRktlNXhwSzdvZzdEZGF4Sy9FMktjK3VwM0dQd0RYVHpJSkJl?=
 =?utf-8?B?QTBlUmpnVzdTRU0yNDlXc3VubUFMWnhDMUt1eks5SHlsLytMeXo4Q2w3ZE5o?=
 =?utf-8?B?cHBQcHM5VmhqUjU1eUhlZVg0SEpxL2I1R3F2K1QzZzdiRFowT0c5ZkFIMlhL?=
 =?utf-8?B?SlpZVXVKbEhzVUR5dHBobHRCNUo5a2h6YXFZMERjeTFRdE9ZbGduMmI0V25t?=
 =?utf-8?B?ckVCZ3lOMXYzQ3pONkt4cmVpRkx5M3dVYzB5QklzdUJiVDhBcXlveWMrYlJo?=
 =?utf-8?B?QmkyNW1VbzB5dXhGMTRHQU5ZVWNuVnJnU1l3TlZtSHZ6VDczQlZxL3hvb3Jl?=
 =?utf-8?B?MU9CM2w0aTYyeXNDQnVMSis4WWdLZVVTWFpRS1JPQWlPYllXQk4rMWg0M3Z0?=
 =?utf-8?B?UnBMODcvSXk4M0FucHlqYmRMQUVtd01WRXM0citxUkFteTJVajlSSCtkMXlM?=
 =?utf-8?B?d0QyeW40RGRPQkI2OHVyTGhHWENSUWFWWWVYYms0eUsxTDRzRW1zTHljVjZX?=
 =?utf-8?B?R0xmVVkxZHBjSFVadlJScGtQdUZTRENVTDZMY0FZbVZIeGw4cEhRa3o4L2xP?=
 =?utf-8?B?aXFvcCtKWmZIdWhjbVVMN0hncjFHZWpJQU1EWjNlSkFhaG41WTcvVGxTZnNV?=
 =?utf-8?B?WW1EVWpyQ2U5bHFoMDEwQ042ZnNEYzAzdlpwczVVdFE2OWRuUjJRT3RnbWR6?=
 =?utf-8?B?dHdQTUhNdDVxYmw3TVNOM0lZcjlCMWdJWEkveFB5VndYM3drMHRPOERQekUz?=
 =?utf-8?B?eTNpN1VVMTBNU00rR1pIbURXZ1BYYnIyS3AxOWJwOUxSOExFQVdGczQvdmdO?=
 =?utf-8?B?a2JxYXpRaDZSMG55U08rT2l0NEl5LzlvUjVXb1J6NjB6TEtTSHpNQ1dBbEk2?=
 =?utf-8?B?ZWFyeXV6OFRYL0pQVHdIMDRCa2M1NU9hWWRDQytBM1dabndtalNKK2dsUzFx?=
 =?utf-8?B?NUdMRVBKVTFKcEU4QVVOSkV3MksxUVhSVUp1UjNiZzZmSTV2dU1FUDBpVGxU?=
 =?utf-8?B?UzRIb1l4aHdBaEh0OXpBOTd2dGFBcUtPcWhvVFZjc3oyZXhkMFZrc3NVUEpB?=
 =?utf-8?B?bHh6K3hNTko3ZXdKdWNPUEx0WXlnTlJMZUhYRDllRXBDeGRaWnJUdDdwMWk2?=
 =?utf-8?B?NGV0aXBYS2dua0txcktVQ2ZvRG14QTY1UGZNeXBzWFJza2tJRDdHMHFPbFdx?=
 =?utf-8?B?VS9IVUVrNG1TbUFOb2g0cERIRVczWHZQQ0Nwd3FscnZXaEJiRmpqK2loUmNF?=
 =?utf-8?B?cWo3eXNIZWUvZllnakN3TDRMTGZMSHQ5SEQzQjEva0Z2M3dzYnBma0Y3RVB5?=
 =?utf-8?B?aFZwdmFzL2NHUXlMZDYzbmEveW9maUxFTi9hbFk4ejZmajhYNGEzdHQ1U0cz?=
 =?utf-8?B?TVNncUdTZDB3SUcxeVBQeWFJakJTZEF0eWI0bG4ra0docW9zWjQ4SGltMHFL?=
 =?utf-8?B?czNkR2t4blFnSUNxRHo4di8zTm9KS1JvWDlIOW1rZnBTS3dsbk1IN1dPdXJi?=
 =?utf-8?B?SjY2SmkwRVZyZmo3ZlFDZGpvYmFlejBHZHQ0V0IwcWlScDJQNmdqMnAvdHF0?=
 =?utf-8?Q?e2NhXtaybtkZ3BZpnHy5I6vIu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <111FA1B802CF494BA077B50E258F918B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f29bd3e-e457-4d44-d5e6-08de2110ddef
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2025 10:55:45.9689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2eVp/5yQF6BMzygO5Y9uNptS79H9lqiZDHtUZmd3ldg6lyD91L4yNevZv10Z3T+Azrzm40nXdDiPlgCutAVs6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6501
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTA3IGF0IDE3OjQ0ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gQEAg
LTIwNDQsNiArMjA5MSw5IEBAIHN0YXRpYyBpbnQgdGR4X2hhbmRsZV9lcHRfdmlvbGF0aW9uKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gwqAJCSAqLw0KPiDCoAkJZXhpdF9xdWFsID0gRVBUX1ZJ
T0xBVElPTl9BQ0NfV1JJVEU7DQo+IMKgDQo+ICsJCWlmICh0ZHhfY2hlY2tfYWNjZXB0X2xldmVs
KHZjcHUsIGdwYV90b19nZm4oZ3BhKSkpDQo+ICsJCQlyZXR1cm4gUkVUX1BGX1JFVFJZOw0KPiAr
DQoNCkkgZG9uJ3QgdGhpbmsgeW91IHNob3VsZCByZXR1cm4gUkVUX1BGX1JFVFJZIGhlcmUuDQoN
ClRoaXMgaXMgc3RpbGwgYXQgdmVyeSBlYXJseSBzdGFnZSBvZiBFUFQgdmlvbGF0aW9uLiAgVGhl
IGNhbGxlciBvZg0KdGR4X2hhbmRsZV9lcHRfdmlvbGF0aW9uKCkgaXMgZXhwZWN0aW5nIGVpdGhl
ciAwLCAxLCBvciBuZWdhdGl2ZSBlcnJvciBjb2RlLg0K

