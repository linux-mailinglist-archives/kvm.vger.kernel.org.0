Return-Path: <kvm+bounces-46710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B7C50AB8DD9
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 19:34:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CFDC17A6132
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 17:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC278258CE8;
	Thu, 15 May 2025 17:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LF4rhdOL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E88C1A316D;
	Thu, 15 May 2025 17:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747330459; cv=fail; b=a0reEGD6oRdmNQRxQ4IYiYjsSisD/ntTRisseo3ZJNIoNlxv2R78af87dVGKbWNvOaBnPBdOOtYB92oJYBLIB0x5f0IdcvpGoL5vuADIcXfpKHQ8nbSicm4hfBLWcZC7dhk3Xd/egvhrZ6honKIJ/qUdNJLCKd5iYzYCLrpIoeo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747330459; c=relaxed/simple;
	bh=5721/X/jksutx6DpYg8wxA1c7P92IkyOuKUtlvf/Wyg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K7Ddl3TXjnZZwcZiGOp2VPnKGXH8Fp8nyllpiHpx+7EDMKEV1Tkn49M2GsnUvX4lSCdulvC2cINuye3i1KqHfQuK6Qx7etJMT73nxuLElpdFIt1FxZXwmX8sQTWU4QlvVFL54uB5XTOtWYiNkgGJ2hpDFspjOYhmHs4JMxthMHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LF4rhdOL; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747330457; x=1778866457;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5721/X/jksutx6DpYg8wxA1c7P92IkyOuKUtlvf/Wyg=;
  b=LF4rhdOLaeliO3NN7k7ivjkzXbdEPSX1GqPk7knyYRysAJFG7eWYhu5t
   M0PxUs4pHhpQ66ANERLa8geBB79FEGIUydftpolZoQrRX2m04S1jXrmoP
   sp7xCK9KhNO+5Zu5LZqfrWnmLgMxNGIrcPti8is1pg4FaOvbKYzjnrPWz
   k7eD+GMK2ky2g+wTF3GzcfMIxUcDdb6/QuAGd0ZzQQiBZQrUIjOxXohOX
   JXIwJ7Cvqa8BUNzMYhMCMzOwngOoOjs4ZOxoDPgypNRep1KZIz167MM1b
   z4lLw8FtjJU62H7h7LW3GqF95HuQGaqpNtBwdj+hqi4l5zVWc9s+0nISu
   g==;
X-CSE-ConnectionGUID: xmsCUAvbTI+ONlqt+PPCBA==
X-CSE-MsgGUID: dpo+m5QmTuSwQdR3jSNs0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="53082478"
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="53082478"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 10:34:13 -0700
X-CSE-ConnectionGUID: Ir/Sg/fSR36B02EpHFJTag==
X-CSE-MsgGUID: ZAI9wf0ZSl6IFpegDn1XNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="138315392"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 10:34:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 10:33:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 10:33:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 10:33:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tzvsO6utRzxQKwm5CiP9RAme5+zDe3syP0fQv6EfYZZbmiduHvTUy837S8KqL0rQPfh+uce4u+soCPQqoNHsBVdv++eF9juXQtUPyESIMzrcdMLcZDdgjq9plcp9q3ZybibItNO9ZBdBTp95eEl+2socwTpfe+lTXpT20OfbBh7CQoRlWFTtQtxBq4DU+fwF0ZyjdFya7rXwhhbmz99hnTt1+CTjcatZTs7diB9BdJDjdHGoHNtxKTXkKkdYxluVPwdq/2mqOmMzDTrLIABAwyDDG0sMw3DtAKXsnckvHD1itMYKHmtMSTQRN6Fh13daT0NIgaaXEL6xKU74ktE7cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5721/X/jksutx6DpYg8wxA1c7P92IkyOuKUtlvf/Wyg=;
 b=Ohdb4ZVrxSvQ9u05T4/+os9HE+8pTy7ycMjQBrvXa9H49eoUup5ui/DZaxj7CxmW9y41anjZXl1exf8ZJXN4VTmTHjxdPbljD9amswVmkA+zJ9n1DXvUqqM48Eju7lg7kgdEXutRYXzPnq+6FtKrBZvyFEDX/sJMCyL/3n/RK1E5s39ZbBgUPVI6wY95jUwbGy/YNygFQKwREX/szHDqoD/q12xmifxFikac/VxeWW12Of7QpYm9BxPFxXDbXmxvP+va2/ujbl2seEhGA8zwUxSrQh2l0MCe1qbadeBe2fzAgkC/oeFzTqU/Y9kWyXGb/xaoxBKANlUhFS3dhCgAHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB8114.namprd11.prod.outlook.com (2603:10b6:8:129::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Thu, 15 May
 2025 17:32:44 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Thu, 15 May 2025
 17:32:44 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 04/21] KVM: TDX: Enforce 4KB mapping level during TD
 build Time
Thread-Topic: [RFC PATCH 04/21] KVM: TDX: Enforce 4KB mapping level during TD
 build Time
Thread-Index: AQHbtMX0QkZFfhf9pEmrzVEY6ZmWz7PRDEyAgAJ+IQCAAIrBgA==
Date: Thu, 15 May 2025 17:32:44 +0000
Message-ID: <49e708ca4a2777c955ca8780117a78acc984dbbd.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030500.32720-1-yan.y.zhao@intel.com>
	 <45ae219d565a7d2275c57a77cd00d629673ec625.camel@intel.com>
	 <aCWw1lZ+T8AFaIiF@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCWw1lZ+T8AFaIiF@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB8114:EE_
x-ms-office365-filtering-correlation-id: a8f1a9f6-fba6-4360-02f1-08dd93d68088
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y2Q2eGZDYkdsdURqRTg0cC9mUnVkblNPV0xyUG94QUxOcE1RZkZPcVBKNHRh?=
 =?utf-8?B?dVNYTFZoNVp1YzVPR0RiaGhGM21ZOUFyY3RKY1JyQlhqZ2xWWWRscnRIYUNV?=
 =?utf-8?B?cGJXWTJNUlp2RVMvQjlOQkRXZkFvSHhzWHJPWVd1NHk5RERCbWNEZUtJTFBC?=
 =?utf-8?B?SmVHUXJhUXNBelpkd0YwNTBuOVF0U0x0bE1iZjd5aHNwZGt4V1Q2NzNZVEVF?=
 =?utf-8?B?RjRqcEZ2ODdMYkM3SDExTlJsNW1BS0VlNENxVFVGQnljNThMdlBra2Z1dmF0?=
 =?utf-8?B?ZHJRUzNUYWZ4K1Z0bDFIRXp1T0Z5d3RUb2N2a3dSN083UmN6RTdxRG1hZGxI?=
 =?utf-8?B?TVVFZURxa0NQTDVhR1NVWmkrajdJN25jeEVFeCt5ald3MThRYzdqTDJKOS9S?=
 =?utf-8?B?K2RCZ2ZBYmc5dnZ4cmNTZTcrQVN5b2g4ZGF4TGd1RndyWUpGeG9ocVZLdHlu?=
 =?utf-8?B?UFpXRnl3YUdQaG5lRHhab2RQR1BnTGtVUXZEVTd0bXZibmN4RVNNeVhMOVI3?=
 =?utf-8?B?WVdQNEh1cHZpanl0NGczelQvSlI3MTV6TDcydWNGMWVzdjhUZmVPMGhpZ0Rl?=
 =?utf-8?B?Wm5lUmtacEJybVg5WkxGQXVrQVZXaGFYOUJUUWVWN0lqdTgxZkRKYi9TR1JM?=
 =?utf-8?B?bXFRazUvYXpyVGcwQWV0T0YvZmZnM0R0NXRyWDZ2MXNXVjI5K1FpVmp6YzdQ?=
 =?utf-8?B?OEVWbzE2MElORUUyU0JncFF2cmxkYTVXQ1pVL21xck5BcmZodnZGV3BRclRz?=
 =?utf-8?B?NlR2NW5vY3lJaG8zVktsY1RJQklSVU1DWnpSSldMTVdjaTk4cEEzbzUza24y?=
 =?utf-8?B?VVgwVkNyYTZ3eDJaOUVvTEJQK1FqeUVMNkwxZWJjdVhZaXJobkFkSWU0bzlu?=
 =?utf-8?B?bTFQbENMMTZQY3RiNW5sMXlxNUlLSkU1UUdoOVB6bHcyQ1drYkxyTndqQXEx?=
 =?utf-8?B?V0g0TmZzRkoyeWl4RVF5a1lGVUFUSmIybXFNNVFhK25mZkovTnVEdFp6OWNS?=
 =?utf-8?B?REtxOGRqS0UvZGdkUXpya0Y3WXRVS2hjeGo3eUJwV0dCVHhGNkU5cDY5Y0hQ?=
 =?utf-8?B?RTYzTlNHVmd1dkg4OVNjZTExYlpzWVRqOUQyVitoanVGRGdkUmtRS09CcHoy?=
 =?utf-8?B?L254RGxFZkJkM3NySTVDVTVXQjUwdlNjWHdIZkhpa2VSekE4VTRkeTVDNktO?=
 =?utf-8?B?V3A4Z0p5M3NBZm8zRFJmVzJydE1MMTZ5MXJRRnprcHhLYzJoM1Y0Ti9PSStX?=
 =?utf-8?B?WFNEM1Bwd2dJSlNxQmRiUHFUcTl1M0djN0pycVpGeDV2MXBRVEVIdG1pQ0Yv?=
 =?utf-8?B?WEI2MmU5VnlNaWhmMUdkZnBYRlcvakd5RllMRU1xdkt2LzJWa1lGSWdUOVpz?=
 =?utf-8?B?ZlJacitpUExMSXI2V2pFVmlxdWtub2JIZDMrWnhMOUpJRVp0QzV0WVYzTHdq?=
 =?utf-8?B?MWVSODM5MEdaQ0Zoa0xVV3kxNUhrRzlnWFpuOVFxQlJsek15TkZKWlVsaUFx?=
 =?utf-8?B?cFEraDdaVWphQ01XdlZFdUdVNTZGUGVGcnJKUlBRanNOVkJKOERuT20wQlo4?=
 =?utf-8?B?QjFraStZb3kyeGtZV1BwaHFuNm1pdkViY2crVHdBdlhnajM3UFBDS3FZQ1Ny?=
 =?utf-8?B?RzRPYkxLZ1M5clhza1J5UEs5L215SVcvU2gxK2M3MnNxaTRGTkRoTDRFUldG?=
 =?utf-8?B?Y21jZ0FlZ3ZLRncwMHVmUnozVkZPaFdNb1lCanBMZ3BLeUtHZHFTRXk2N2tz?=
 =?utf-8?B?RnF1dG1nWTdSczByZ3lRNzNPYmNMOFlnckRHR3d4NkZ6TEhkUldacE9kbC9F?=
 =?utf-8?B?a0JsZW5SNTBEYWZxZjZKdG1INDBGMi96NjR1aW5ZaTM1SjhDcUNlQWE1QS9y?=
 =?utf-8?B?dExYREJxQVJnaDJBMXMrV1ZXVmg5VmZ0Z0JWa0cveEIwYzRnbkttTXFONzgv?=
 =?utf-8?B?OE53cmhDd0xDQlA1QW4xeDhGcXNTangyWmdLMTZWMFRPeGJ3dFFneG1yQ2J2?=
 =?utf-8?Q?VvdHsDo/XtgNzsKgiWaAfOpCyRuKSs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3ZOSndkbVB0LzlqRTNlamVReVpFZHgzclNRRzdPSXlIZ2J0Y01YUnZ1cEFJ?=
 =?utf-8?B?TXVPdnBLSG93RE85Wk8zTlZicmZVcEVYcmVvQkZmVnhST0JIUXQrd09Pc1h2?=
 =?utf-8?B?T0NSYisySEg3TkY1R3VNMEFiQ1NJTVhpallYZEMwYmpMRXpqZjJQaTdZYWNS?=
 =?utf-8?B?dGlWVy8xekpNZ0V4aW50WlExdWpSWnh3Y3JVRmRITGF6Ynk1Z1ZoWEErZFJQ?=
 =?utf-8?B?VGROMStjM3h2S0w2a3ZvWTVSNkI0MENuU3Nvd0FXVmFmT2VlVWdhZzRGNDBo?=
 =?utf-8?B?RmxST2hmR1ExT3hlRThtaENzL2tWY1g0TEc1MTFqWmdFUnFMTytRKzFWNGho?=
 =?utf-8?B?V2IvR2Q0NGsyODdlejR0TnpaV2xKcmI0R3hIYWtpMUJXZUVQNmo2dTR4OEJ5?=
 =?utf-8?B?SEp1NkUyV3Q0N1djYlcyN2RvQmNBWkJsTHZuU2t6L2o1OWhEZjNsdStIdzh3?=
 =?utf-8?B?RkhyQThkeGFrNDNpTWdlQnRITk1XY2hTbEs2YVh6OW5GOURabzVSUk9UNXFC?=
 =?utf-8?B?Q3hITlBiT29uMXFMZWNuU0Z4VnkzR0FmM09RNjJPK3gzai9oMUlLOStrMVhI?=
 =?utf-8?B?T1JmMGlzOXlLc3NMZnFFWVQ0UC9teXpnT1BvTm1Lci9PSGozNFlrYXNQV1kr?=
 =?utf-8?B?T2wvMmpXOHlHOFNMSENYcmlNaFRlTFlOOHBlL1NxTGNHWStZUGMrWjRWa1J5?=
 =?utf-8?B?UkZ5WHVBTjhSTmY2dDZaMDhDeUxuVVhtNGpBTGJkVnZZQm9rckNPZmNyNUE4?=
 =?utf-8?B?OFg5SVFGTVR5UldHZ1BSVUJ3M01WL05JOHdpSEhMMGM3Z0Y0cFhheW5xcTdh?=
 =?utf-8?B?UXZRZ1Q0eUJjNitPdGh3cXhpQjlYUkFUZ2xFNi9EUDI2ZHp3b0pMWDlITWhu?=
 =?utf-8?B?YUNOSU1Ga1lLQlloOHVvNG94UldsVzB2elhXSE52VHVOZ2I1TU8vdm5Yd2lk?=
 =?utf-8?B?M0lvWGMvTWJLbEtSa3YxWkZyRE56TU85N0tIODZ4eDVHb25WMDNxMlRDRGQv?=
 =?utf-8?B?U0pCd0hhYnpReFBCWTgyc29hOWRLYkZ3R09VNXpiS1IzK2VuWUdsYzZ3OHh4?=
 =?utf-8?B?dFB2Zys5eVo1SzNKY3ZNbUpMcDlzWDBRQ3lSVCtobDJaUXF3WlZOWWdGcUR2?=
 =?utf-8?B?RlVlanQwNmtYMjBlOXhZMmZqMkJQUDlvanJ6ZHVOTWxkSFNSSEhHZUd0UURJ?=
 =?utf-8?B?RWVuc0dJTDdtdVR6TzZObWt6MTVyemRyNnJZSWF3UGZTSzgrY0xoOUYvdEdH?=
 =?utf-8?B?RnlQbjVERTNTdXRqakpkSWovbytCMS9jVzZoeFFXRWhHZlZKaXJkejZmUE00?=
 =?utf-8?B?d0hlWmpxUHlFZ3M0R0Vrdk4wWm91QkR1TUptbWhQSCtkV3l0VDlrOGtsZEtR?=
 =?utf-8?B?UDhIRjM2ZlNNVE5xTHZZSFlsc282bUkxWDVSdDlaU0RFY3J4eTh0bXBkUDFk?=
 =?utf-8?B?bFVDZmtOZVVxZ3UxSjV1Q3M3SjhiZ2dDSlo0SEV0RUdDUUVNSXRqNmNBeTFT?=
 =?utf-8?B?bC9oN1RMeU10WXFER2RMb2FKSzdBZlYyR1phbFZYZlFOMUhGSWJtRG1ncWRs?=
 =?utf-8?B?OUFJQisrMVEvZ0Y2dWhOTFIvdkdzelFGT29jK1ErSVcrK2JEdG9KN2pMNzJD?=
 =?utf-8?B?emo3c1piaXIrUFNNNVpXeWNvazlnWVB3ckFkL1ZIZWVLRjVnWEtmc0lPVWFY?=
 =?utf-8?B?RTBKQUppUzkzeENYb2pWaG40N2FscnIzNytkVDdrTEdLbitMZ0tnaHhuWmZm?=
 =?utf-8?B?bndmUTBSZG5SNGxpd08xTnVZTkJhWlBsUXVDYkx5blIwQzU4UDJoMVBWa2Ns?=
 =?utf-8?B?OEN5V0I4TTd1S3NyVjR4WVZUcXZ2Vmo5N1ZzdXRYL0dzdkJtam42SWZWcGF6?=
 =?utf-8?B?RjhsRmpCSURBQlNWMGdhdFRzb1lMV25oUDVOTERUSnhUZlh3cGJUb2dqdTZP?=
 =?utf-8?B?YU1sS01LQUFSbUQvWVp3Z09SOWVhSnJ6UHluYWN4TmxmaXJ6TUZ3M3ZWVjlJ?=
 =?utf-8?B?bGFOaU03SUpRaThPRTZFZnRJSWxPUUtlL0Q5RXE4clJ4Q3Vpd1lSUmNXZGZO?=
 =?utf-8?B?ZmVZSXdrRHBPRjU2QnRsKzQrT1dVTHM5dnh4RDl1cEQ0b2tlbThVWS9QcEIx?=
 =?utf-8?B?WFR2bmd0b0pCTytjVml3UmtKZ1pHcCttZ3cydXRKb0FEcGxDNFhqV3Z6Y2hy?=
 =?utf-8?B?VXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <56CF7BF95C291E4D9044A0D822BAC723@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8f1a9f6-fba6-4360-02f1-08dd93d68088
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2025 17:32:44.4781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NEhDY5Be1nTBGLkuJBWBkYpt+d21eHrv9FLp6+qRLFq5a9W5i3HKZp+z2X2L86F69uC72Cq/epSEM75QCL2Njkt5tVXoEivPxLrbzLEBYws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8114
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA1LTE1IGF0IDE3OjE2ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
V2VkLCBNYXkgMTQsIDIwMjUgYXQgMDM6MTI6MTBBTSArMDgwMCwgRWRnZWNvbWJlLCBSaWNrIFAg
d3JvdGU6DQo+ID4gT24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA1ICswODAwLCBZYW4gWmhhbyB3
cm90ZToNCj4gPiA+IER1cmluZyB0aGUgVEQgYnVpbGQgcGhhc2UgKGkuZS4sIGJlZm9yZSB0aGUg
VEQgYmVjb21lcyBSVU5OQUJMRSksIGVuZm9yY2UgYQ0KPiA+ID4gNEtCIG1hcHBpbmcgbGV2ZWwg
Ym90aCBpbiB0aGUgUy1FUFQgbWFuYWdlZCBieSB0aGUgVERYIG1vZHVsZSBhbmQgdGhlDQo+ID4g
PiBtaXJyb3IgcGFnZSB0YWJsZSBtYW5hZ2VkIGJ5IEtWTS4NCj4gPiA+IA0KPiA+ID4gRHVyaW5n
IHRoaXMgcGhhc2UsIFREJ3MgbWVtb3J5IGlzIGFkZGVkIHZpYSB0ZGhfbWVtX3BhZ2VfYWRkKCks
IHdoaWNoIG9ubHkNCj4gPiA+IGFjY2VwdHMgNEtCIGdyYW51bGFyaXR5LiBUaGVyZWZvcmUsIHJl
dHVybiBQR19MRVZFTF80SyBpbiBURFgncw0KPiA+ID4gLnByaXZhdGVfbWF4X21hcHBpbmdfbGV2
ZWwgaG9vayB0byBlbnN1cmUgS1ZNIG1hcHMgYXQgdGhlIDRLQiBsZXZlbCBpbiB0aGUNCj4gPiA+
IG1pcnJvciBwYWdlIHRhYmxlLiBNZWFud2hpbGUsIGl0ZXJhdGUgb3ZlciBlYWNoIDRLQiBwYWdl
IG9mIGEgbGFyZ2UgZ21lbQ0KPiA+ID4gYmFja2VuZCBwYWdlIGluIHRkeF9nbWVtX3Bvc3RfcG9w
dWxhdGUoKSBhbmQgaW52b2tlIHRkaF9tZW1fcGFnZV9hZGQoKSB0bw0KPiA+ID4gbWFwIGF0IHRo
ZSA0S0IgbGV2ZWwgaW4gdGhlIFMtRVBULg0KPiA+ID4gDQo+ID4gPiBTdGlsbCBhbGxvdyBodWdl
IHBhZ2VzIGluIGdtZW0gYmFja2VuZCBkdXJpbmcgVEQgYnVpbGQgdGltZS4gQmFzZWQgb24gWzFd
LA0KPiA+ID4gd2hpY2ggZ21lbSBzZXJpZXMgYWxsb3dzIDJNQiBUUEggYW5kIG5vbi1pbi1wbGFj
ZSBjb252ZXJzaW9uLCBwYXNzIGluDQo+ID4gPiByZWdpb24ubnJfcGFnZXMgdG8ga3ZtX2dtZW1f
cG9wdWxhdGUoKSBpbiB0ZHhfdmNwdV9pbml0X21lbV9yZWdpb24oKS4NCj4gPiA+IA0KPiA+IA0K
PiA+IFRoaXMgY29tbWl0IGxvZyB3aWxsIG5lZWQgdG8gYmUgd3JpdHRlbiB3aXRoIHVwc3RyZWFt
IGluIG1pbmQgd2hlbiBpdCBpcyBvdXQgb2YNCj4gPiBSRkMuDQo+IE9rLg0KPiANCj4gIA0KPiA+
ID4gIFRoaXMNCj4gPiA+IGVuYWJsZXMga3ZtX2dtZW1fcG9wdWxhdGUoKSB0byBhbGxvY2F0ZSBo
dWdlIHBhZ2VzIGZyb20gdGhlIGdtZW0gYmFja2VuZA0KPiA+ID4gd2hlbiB0aGUgcmVtYWluaW5n
IG5yX3BhZ2VzLCBHRk4gYWxpZ25tZW50LCBhbmQgcGFnZSBwcml2YXRlL3NoYXJlZA0KPiA+ID4g
YXR0cmlidXRlIHBlcm1pdC4gIEtWTSBpcyB0aGVuIGFibGUgdG8gcHJvbW90ZSB0aGUgaW5pdGlh
bCA0SyBtYXBwaW5nIHRvDQo+ID4gPiBodWdlIGFmdGVyIFREIGlzIFJVTk5BQkxFLg0KPiA+ID4g
DQo+ID4gPiBEaXNhbGxvdyBhbnkgcHJpdmF0ZSBodWdlIHBhZ2VzIGR1cmluZyBURCBidWlsZCB0
aW1lLiBVc2UgQlVHX09OKCkgaW4NCj4gPiA+IHRkeF9tZW1fcGFnZV9yZWNvcmRfcHJlbWFwX2Nu
dCgpIGFuZCB0ZHhfaXNfc2VwdF96YXBfZXJyX2R1ZV90b19wcmVtYXAoKSB0bw0KPiA+ID4gYXNz
ZXJ0IHRoZSBtYXBwaW5nIGxldmVsIGlzIDRLQi4NCj4gPiA+IA0KPiA+ID4gT3Bwb3J0dW5pc3Rp
Y2FsbHksIHJlbW92ZSB1bnVzZWQgcGFyYW1ldGVycyBpbg0KPiA+ID4gdGR4X21lbV9wYWdlX3Jl
Y29yZF9wcmVtYXBfY250KCkuDQo+ID4gPiANCj4gPiA+IExpbms6IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2FsbC8yMDI0MTIxMjA2MzYzNS43MTI4NzctMS1taWNoYWVsLnJvdGhAYW1kLmNvbSBb
MV0NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFlhbiBaaGFvIDx5YW4ueS56aGFvQGludGVsLmNvbT4N
Cj4gPiA+IC0tLQ0KPiA+ID4gIGFyY2gveDg2L2t2bS92bXgvdGR4LmMgfCA0NSArKysrKysrKysr
KysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwg
MzAgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiA+
ID4gaW5kZXggOThjZGUyMGYxNGRhLi4wMzg4NWNiMjg2OWIgMTAwNjQ0DQo+ID4gPiAtLS0gYS9h
cmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ID4gPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5j
DQo+ID4gPiBAQCAtMTUzMCwxNCArMTUzMCwxNiBAQCBzdGF0aWMgaW50IHRkeF9tZW1fcGFnZV9h
dWcoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4sDQo+ID4gPiAgICogVGhlIGNvdW50ZXIgaGFz
IHRvIGJlIHplcm8gb24gS1ZNX1REWF9GSU5BTElaRV9WTSwgdG8gZW5zdXJlIHRoYXQgdGhlcmUN
Cj4gPiA+ICAgKiBhcmUgbm8gaGFsZi1pbml0aWFsaXplZCBzaGFyZWQgRVBUIHBhZ2VzLg0KPiA+
ID4gICAqLw0KPiA+ID4gLXN0YXRpYyBpbnQgdGR4X21lbV9wYWdlX3JlY29yZF9wcmVtYXBfY250
KHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLA0KPiA+ID4gLQkJCQkJICBlbnVtIHBnX2xldmVs
IGxldmVsLCBrdm1fcGZuX3QgcGZuKQ0KPiA+ID4gK3N0YXRpYyBpbnQgdGR4X21lbV9wYWdlX3Jl
Y29yZF9wcmVtYXBfY250KHN0cnVjdCBrdm0gKmt2bSwgZW51bSBwZ19sZXZlbCBsZXZlbCkNCj4g
PiA+ICB7DQo+ID4gPiAgCXN0cnVjdCBrdm1fdGR4ICprdm1fdGR4ID0gdG9fa3ZtX3RkeChrdm0p
Ow0KPiA+ID4gIA0KPiA+ID4gIAlpZiAoS1ZNX0JVR19PTihrdm0tPmFyY2gucHJlX2ZhdWx0X2Fs
bG93ZWQsIGt2bSkpDQo+ID4gPiAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiA+ICANCj4gPiA+ICsJ
aWYgKEtWTV9CVUdfT04obGV2ZWwgIT0gUEdfTEVWRUxfNEssIGt2bSkpDQo+ID4gPiArCQlyZXR1
cm4gLUVJTlZBTDsNCj4gPiA+ICsNCj4gPiA+ICAJLyogbnJfcHJlbWFwcGVkIHdpbGwgYmUgZGVj
cmVhc2VkIHdoZW4gdGRoX21lbV9wYWdlX2FkZCgpIGlzIGNhbGxlZC4gKi8NCj4gPiA+ICAJYXRv
bWljNjRfaW5jKCZrdm1fdGR4LT5ucl9wcmVtYXBwZWQpOw0KPiA+ID4gIAlyZXR1cm4gMDsNCj4g
PiA+IEBAIC0xNTcxLDcgKzE1NzMsNyBAQCBpbnQgdGR4X3NlcHRfc2V0X3ByaXZhdGVfc3B0ZShz
dHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwNCj4gPiA+ICAJaWYgKGxpa2VseShrdm1fdGR4LT5z
dGF0ZSA9PSBURF9TVEFURV9SVU5OQUJMRSkpDQo+ID4gPiAgCQlyZXR1cm4gdGR4X21lbV9wYWdl
X2F1Zyhrdm0sIGdmbiwgbGV2ZWwsIHBhZ2UpOw0KPiA+ID4gIA0KPiA+ID4gLQlyZXR1cm4gdGR4
X21lbV9wYWdlX3JlY29yZF9wcmVtYXBfY250KGt2bSwgZ2ZuLCBsZXZlbCwgcGZuKTsNCj4gPiA+
ICsJcmV0dXJuIHRkeF9tZW1fcGFnZV9yZWNvcmRfcHJlbWFwX2NudChrdm0sIGxldmVsKTsNCj4g
PiA+ICB9DQo+ID4gPiAgDQo+ID4gPiAgc3RhdGljIGludCB0ZHhfc2VwdF9kcm9wX3ByaXZhdGVf
c3B0ZShzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwNCj4gPiA+IEBAIC0xNjY2LDcgKzE2Njgs
NyBAQCBpbnQgdGR4X3NlcHRfbGlua19wcml2YXRlX3NwdChzdHJ1Y3Qga3ZtICprdm0sIGdmbl90
IGdmbiwNCj4gPiA+ICBzdGF0aWMgaW50IHRkeF9pc19zZXB0X3phcF9lcnJfZHVlX3RvX3ByZW1h
cChzdHJ1Y3Qga3ZtX3RkeCAqa3ZtX3RkeCwgdTY0IGVyciwNCj4gPiA+ICAJCQkJCSAgICAgdTY0
IGVudHJ5LCBpbnQgbGV2ZWwpDQo+ID4gPiAgew0KPiA+ID4gLQlpZiAoIWVyciB8fCBrdm1fdGR4
LT5zdGF0ZSA9PSBURF9TVEFURV9SVU5OQUJMRSkNCj4gPiA+ICsJaWYgKCFlcnIgfHwga3ZtX3Rk
eC0+c3RhdGUgPT0gVERfU1RBVEVfUlVOTkFCTEUgfHwgbGV2ZWwgPiBQR19MRVZFTF80SykNCj4g
PiA+ICAJCXJldHVybiBmYWxzZTsNCj4gPiANCj4gPiBUaGlzIGlzIGNhdGNoaW5nIHphcHBpbmcg
aHVnZSBwYWdlcyBiZWZvcmUgdGhlIFREIGlzIHJ1bm5hYmxlPyBJcyBpdCBuZWNlc3NhcnkNCj4g
PiBpZiB3ZSBhcmUgYWxyZWFkeSB3YXJuaW5nIGFib3V0IG1hcHBpbmcgaHVnZSBwYWdlcyBiZWZv
cmUgdGhlIFREIGlzIHJ1bm5hYmxlIGluDQo+ID4gdGR4X21lbV9wYWdlX3JlY29yZF9wcmVtYXBf
Y250KCk/DQo+IFVuZGVyIG5vcm1hbCBjb25kaXRpb25zLCB0aGlzIGNoZWNrIGlzbid0IG5lY2Vz
c2FyeS4NCj4gSSBhZGRlZCB0aGlzIGNoZWNrIGluIGNhc2UgYnVncyBpbiB0aGUgS1ZNIGNvcmUg
TU1VIHdoZXJlIHRoZSBtaXJyb3IgcGFnZSB0YWJsZQ0KPiBtaWdodCBiZSB1cGRhdGVkIHRvIGh1
Z2Ugd2l0aG91dCBub3RpZnlpbmcgdGhlIFREWCBzaWRlLg0KPiBBbSBJIG92ZXJ0aGlua2luZz8N
Cg0KSWYgd2UgbmVlZCBzbyBtYW55IEJVR19PTigpcyBtYXliZSBvdXIgZGVzaWduIGlzIHRvbyBm
cmFnaWxlLiBJIHRoaW5rIHdlIGNvdWxkDQpkcm9wIHRoaXMgb25lLg0KDQo+IA0KPiANCj4gPiA+
ICAJaWYgKGVyciAhPSAoVERYX0VQVF9FTlRSWV9TVEFURV9JTkNPUlJFQ1QgfCBURFhfT1BFUkFO
RF9JRF9SQ1gpKQ0KPiA+ID4gQEAgLTMwNTIsOCArMzA1NCw4IEBAIHN0cnVjdCB0ZHhfZ21lbV9w
b3N0X3BvcHVsYXRlX2FyZyB7DQo+ID4gPiAgCV9fdTMyIGZsYWdzOw0KPiA+ID4gIH07DQo+ID4g
PiAgDQo+ID4gPiAtc3RhdGljIGludCB0ZHhfZ21lbV9wb3N0X3BvcHVsYXRlKHN0cnVjdCBrdm0g
Kmt2bSwgZ2ZuX3QgZ2ZuLCBrdm1fcGZuX3QgcGZuLA0KPiA+ID4gLQkJCQkgIHZvaWQgX191c2Vy
ICpzcmMsIGludCBvcmRlciwgdm9pZCAqX2FyZykNCj4gPiA+ICtzdGF0aWMgaW50IHRkeF9nbWVt
X3Bvc3RfcG9wdWxhdGVfNGsoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4sIGt2bV9wZm5fdCBw
Zm4sDQo+ID4gPiArCQkJCSAgICAgdm9pZCBfX3VzZXIgKnNyYywgdm9pZCAqX2FyZykNCj4gPiA+
ICB7DQo+ID4gPiAgCXU2NCBlcnJvcl9jb2RlID0gUEZFUlJfR1VFU1RfRklOQUxfTUFTSyB8IFBG
RVJSX1BSSVZBVEVfQUNDRVNTOw0KPiA+ID4gIAlzdHJ1Y3Qga3ZtX3RkeCAqa3ZtX3RkeCA9IHRv
X2t2bV90ZHgoa3ZtKTsNCj4gPiA+IEBAIC0zMTIwLDYgKzMxMjIsMjEgQEAgc3RhdGljIGludCB0
ZHhfZ21lbV9wb3N0X3BvcHVsYXRlKHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLCBrdm1fcGZu
X3QgcGZuLA0KPiA+ID4gIAlyZXR1cm4gcmV0Ow0KPiA+ID4gIH0NCj4gPiA+ICANCj4gPiA+ICtz
dGF0aWMgaW50IHRkeF9nbWVtX3Bvc3RfcG9wdWxhdGUoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBn
Zm4sIGt2bV9wZm5fdCBwZm4sDQo+ID4gPiArCQkJCSAgdm9pZCBfX3VzZXIgKnNyYywgaW50IG9y
ZGVyLCB2b2lkICpfYXJnKQ0KPiA+ID4gK3sNCj4gPiA+ICsJdW5zaWduZWQgbG9uZyBpLCBucGFn
ZXMgPSAxIDw8IG9yZGVyOw0KPiA+ID4gKwlpbnQgcmV0Ow0KPiA+ID4gKw0KPiA+ID4gKwlmb3Ig
KGkgPSAwOyBpIDwgbnBhZ2VzOyBpKyspIHsNCj4gPiA+ICsJCXJldCA9IHRkeF9nbWVtX3Bvc3Rf
cG9wdWxhdGVfNGsoa3ZtLCBnZm4gKyBpLCBwZm4gKyBpLA0KPiA+ID4gKwkJCQkJCXNyYyArIGkg
KiBQQUdFX1NJWkUsIF9hcmcpOw0KPiA+ID4gKwkJaWYgKHJldCkNCj4gPiA+ICsJCQlyZXR1cm4g
cmV0Ow0KPiA+ID4gKwl9DQo+ID4gPiArCXJldHVybiAwOw0KPiA+ID4gK30NCj4gPiA+ICsNCj4g
PiA+ICBzdGF0aWMgaW50IHRkeF92Y3B1X2luaXRfbWVtX3JlZ2lvbihzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsIHN0cnVjdCBrdm1fdGR4X2NtZCAqY21kKQ0KPiA+ID4gIHsNCj4gPiA+ICAJc3RydWN0
IHZjcHVfdGR4ICp0ZHggPSB0b190ZHgodmNwdSk7DQo+ID4gPiBAQCAtMzE2NiwyMCArMzE4Mywx
NSBAQCBzdGF0aWMgaW50IHRkeF92Y3B1X2luaXRfbWVtX3JlZ2lvbihzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsIHN0cnVjdCBrdm1fdGR4X2NtZCAqYw0KPiA+ID4gIAkJfTsNCj4gPiA+ICAJCWdtZW1f
cmV0ID0ga3ZtX2dtZW1fcG9wdWxhdGUoa3ZtLCBncGFfdG9fZ2ZuKHJlZ2lvbi5ncGEpLA0KPiA+
ID4gIAkJCQkJICAgICB1NjRfdG9fdXNlcl9wdHIocmVnaW9uLnNvdXJjZV9hZGRyKSwNCj4gPiA+
IC0JCQkJCSAgICAgMSwgdGR4X2dtZW1fcG9zdF9wb3B1bGF0ZSwgJmFyZyk7DQo+ID4gPiArCQkJ
CQkgICAgIHJlZ2lvbi5ucl9wYWdlcywgdGR4X2dtZW1fcG9zdF9wb3B1bGF0ZSwgJmFyZyk7DQo+
ID4gPiAgCQlpZiAoZ21lbV9yZXQgPCAwKSB7DQo+ID4gPiAgCQkJcmV0ID0gZ21lbV9yZXQ7DQo+
ID4gPiAgCQkJYnJlYWs7DQo+ID4gPiAgCQl9DQo+ID4gPiAgDQo+ID4gPiAtCQlpZiAoZ21lbV9y
ZXQgIT0gMSkgew0KPiBUaGlzIGxpbmUgaXMgcmVtb3ZlZC4NCg0KRG9oISBSaWdodC4NCg0KPiAN
Cj4gPiA+IC0JCQlyZXQgPSAtRUlPOw0KPiA+ID4gLQkJCWJyZWFrOw0KPiA+ID4gLQkJfQ0KPiA+
ID4gLQ0KPiA+ID4gLQkJcmVnaW9uLnNvdXJjZV9hZGRyICs9IFBBR0VfU0laRTsNCj4gPiA+IC0J
CXJlZ2lvbi5ncGEgKz0gUEFHRV9TSVpFOw0KPiA+ID4gLQkJcmVnaW9uLm5yX3BhZ2VzLS07DQo+
ID4gPiArCQlyZWdpb24uc291cmNlX2FkZHIgKz0gUEFHRV9TSVpFICogZ21lbV9yZXQ7DQo+ID4g
DQo+ID4gZ21lbV9yZXQgaGFzIHRvIGJlIDEsIHBlciB0aGUgYWJvdmUgY29uZGl0aW9uYWwuDQo+
IEFzIHJlZ2lvbi5ucl9wYWdlcyBpbnN0ZWFkIG9mIDEgaXMgcGFzc2VkIGludG8ga3ZtX2dtZW1f
cG9wdWxhdGUoKSwgZ21lbV9yZXQNCj4gY2FuIG5vdyBiZSBncmVhdGVyIHRoYW4gMS4NCj4gDQo+
IGt2bV9nbWVtX3BvcHVsYXRlKCkgY2FuIGFsbG9jYXRlIGh1Z2UgYmFja2VuZCBwYWdlcyBpZiBy
ZWdpb24ubnJfcGFnZXMsIEdGTg0KPiBhbGlnbm1lbnQsIGFuZCBzaGFyZWFiaWxpdHkgcGVybWl0
Lg0KPiANCj4gPiA+ICsJCXJlZ2lvbi5ncGEgKz0gUEFHRV9TSVpFICogZ21lbV9yZXQ7DQo+ID4g
PiArCQlyZWdpb24ubnJfcGFnZXMgLT0gZ21lbV9yZXQ7DQo+ID4gPiAgDQo+ID4gPiAgCQljb25k
X3Jlc2NoZWQoKTsNCj4gPiA+ICAJfQ0KPiA+ID4gQEAgLTMyMjQsNiArMzIzNiw5IEBAIGludCB0
ZHhfdmNwdV9pb2N0bChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHZvaWQgX191c2VyICphcmdwKQ0K
PiA+ID4gIA0KPiA+ID4gIGludCB0ZHhfZ21lbV9wcml2YXRlX21heF9tYXBwaW5nX2xldmVsKHN0
cnVjdCBrdm0gKmt2bSwga3ZtX3Bmbl90IHBmbikNCj4gPiA+ICB7DQo+ID4gPiArCWlmICh1bmxp
a2VseSh0b19rdm1fdGR4KGt2bSktPnN0YXRlICE9IFREX1NUQVRFX1JVTk5BQkxFKSkNCj4gPiA+
ICsJCXJldHVybiBQR19MRVZFTF80SzsNCj4gPiA+ICsNCj4gPiA+ICAJcmV0dXJuIFBHX0xFVkVM
XzRLOw0KPiA+IA0KPiA+IF4gQ2hhbmdlIGRvZXMgbm90aGluZy4uLg0KPiBSaWdodC4gUGF0Y2gg
OSB3aWxsIHVwZGF0ZSB0aGUgZGVmYXVsdCBsZXZlbCB0byBQR19MRVZFTF8yTS4NCj4gDQo+IFRo
ZSBjaGFuZ2UgaGVyZSBpcyBtZWFudCB0byBoaWdobGlnaHQgUEdfTEVWRUxfNEsgaXMgZW5mb3Jj
ZWQgaW4NCj4gdGR4X2dtZW1fcHJpdmF0ZV9tYXhfbWFwcGluZ19sZXZlbCgpIHdoZW4gVEQgaXMg
bm90IGluIFREX1NUQVRFX1JVTk5BQkxFIHN0YXRlLg0KPiANCj4gV2lsbCBjaGFuZ2UgaXQgaW4g
dGhlIG5leHQgdmVyc2lvbi4NCg0KSSBjYW4ndCBzZWUgdGhlIHBhdHRlcm4gYmV0d2VlbiB3aGF0
IGdvZXMgaW4gdGhpcyBwYXRjaCB2cyBwYXRjaCA5LiBXZSBzaG91bGQNCmhhdmUgc29tZSByZWFz
b25pbmcgYmVoaW5kIGl0Lg0KDQo+IA0KPiA+ID4gIH0NCj4gPiA+ICANCj4gPiANCg0K

