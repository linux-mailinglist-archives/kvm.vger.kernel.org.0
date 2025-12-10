Return-Path: <kvm+bounces-65679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E0DCB3E47
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 20:49:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A904F3055BBF
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 19:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E3A5327BE4;
	Wed, 10 Dec 2025 19:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ksZRXTUv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093C2281368;
	Wed, 10 Dec 2025 19:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765396172; cv=fail; b=SNlwiNSCa3g9ap2rQwHlnCDoRBtrlzSoQCnTEGd4NHVb/vfQYOuzAv+Q63n3xGJ+av8QZ+ZnUuT/6ca8CFYcVDo/gGSsYtZLFYBfbuIbyZywgMRQnfMUG0hZrCQIKKLQQgc0XxokS/f8d6nklPjE35ZNVBFVYOj1rrJcCf4iHi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765396172; c=relaxed/simple;
	bh=3vaPLez4w0Xq1WBDr+/YImHQ5BQaqeyYJhmhcW7l4S4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rd9kx9zw+nMto0MNMeP9YPbhomM8XzarHH9/pt0+ibT1Rzc6Y0ww1P/hRZTfgL7aWwPfaClAtl4/1m5DDkLXwE1AswRtVifIqKVbUn5WGUdjr2+ZmAyQJchyw4nNB5awMVMs8Ih5uz1Cc+cPF2IOKqUgqg8eYMWuF0i56COpJYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ksZRXTUv; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765396171; x=1796932171;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3vaPLez4w0Xq1WBDr+/YImHQ5BQaqeyYJhmhcW7l4S4=;
  b=ksZRXTUvQVRq9fgbczWjSv+DgbD6z6wr6qyfluWgotE8tu16MWP0wlRS
   CWTDcdUsV0+IIq8FGKBMNbi71IGuZn89oC6379ao12o5NFlGiUxh45HN3
   HS9eLSwGpkfbT/ufleAo7RyD7A4+Lmao4TNwi8eaX6IUz7dx+/GJq5OUP
   F90wS4CsDhYUqgWGZnzQPurLixcf3x0IulHda83BBhFuq5haVRP491312
   +Bnpk9pZxtITdjaCxOuIQUiXm0AP/kkH+f794WIIC9I4qOAlg0ZeHcIcD
   /LaLDqXR/Bq2m0Tp42xuZdqyNeRHgP6i1Lb+htO5wYWGNlFZmpEfoO27I
   Q==;
X-CSE-ConnectionGUID: N3S5MQ7eQdu8+C2oUerdKg==
X-CSE-MsgGUID: VQPkpKAcQsyr7/glAjHcTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67424558"
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="67424558"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 11:49:31 -0800
X-CSE-ConnectionGUID: Pk8+/KGCS+ux+2oeChI3zQ==
X-CSE-MsgGUID: cPIAx7cLR8yB5bt/6O+KiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="227261346"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 11:49:30 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 10 Dec 2025 11:49:30 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 10 Dec 2025 11:49:30 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.7) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 10 Dec 2025 11:49:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MFTY8+ijaRljQIExFm64fJORYmbuF5U1fYD7wSR8vYBZJIT6CaL+Z7kupihNWpzFozfXYGRFv1i6SptvtOIclUJqM9HJEFeCsWMkksIFXRZyZ+zTYykW66WShxq7He4S+HO017T/UdHhV7WxSE4VKQJUA5IZNgMrbP/DTl3iMOiXWMLCxGCv9PACyGi2A2XFVvOtDLAVZmkPq8xzY2baxC6vu6pQgtbGEMUAmxo1wFBSsi/6FWAGNl2R7xjgLBZtpFO4nBFkgEdfFlaom50HBMIiZ9PiqXM5TPqDwbvenZnDhV7w6DEEgza51jN5J1en2NNAJaCIQ74AtZnc8Ywapg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vaPLez4w0Xq1WBDr+/YImHQ5BQaqeyYJhmhcW7l4S4=;
 b=UsCU12QIROnYCqMk8Cw3LrfJATtiKOFOWUFzY7XEuXLM/r02Sso7voR1eYRSGEpd2bR9Q09GaTqFQcbocLy8b1vu0guaAa0JOUUJ7DO/1CKWvrswp9UhccGH8a60crjxEV3G7EbA2ltlat6hi6l6j90n5PeQ8zepkcC8svjA6t9AjHuuTqhuyEKl2QGucpBnMaM8tPRXQCPyI7EHzOBP2ssuO0gDAxj+DlMV9qRPOzWB261Eg/AgPfNwd74ocydmK0yMz7BwCljzEk1NmqULUdauEeoR13TN2UykNxp3Xjru3lFu76txeEPjdZK+Fw1toHYlSLH/0+iPsWTeI/WfxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM6PR11MB4691.namprd11.prod.outlook.com (2603:10b6:5:2a6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.8; Wed, 10 Dec
 2025 19:49:27 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 19:49:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "sagis@google.com" <sagis@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Miao, Jun"
	<jun.miao@intel.com>, "zhiquan1.li@intel.com" <zhiquan1.li@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 10/23] KVM: TDX: Enable huge page splitting under
 write kvm->mmu_lock
Thread-Topic: [RFC PATCH v2 10/23] KVM: TDX: Enable huge page splitting under
 write kvm->mmu_lock
Thread-Index: AQHcB3/ZS03ZQoIYB0ahTxw/ttjQXrUavfSAgAABOQCAAAnDAIAABhcAgAETZICAACrBgA==
Date: Wed, 10 Dec 2025 19:49:26 +0000
Message-ID: <2b714bb6e547e2505a83c97fdad79e5dda687d05.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094333.4579-1-yan.y.zhao@intel.com>
	 <CAAhR5DGNXi2GeBBZUoZOac6a7_bAquUOzBJuccbeJZ1r97f0Ag@mail.gmail.com>
	 <5b9c454946a5fb6782c1245001439620f04932b3.camel@intel.com>
	 <CAAhR5DHuhL_oXteqvcFPU_eh6YG38=Gwivh6emJ9vOj5XO_EgQ@mail.gmail.com>
	 <aTjD5FPl1+ktsRkJ@yzhao56-desk.sh.intel.com>
	 <CAAhR5DGPF3AV22kQ4ZVNWh3Og=oiJiaDRgBL5feB6C-AHb=apA@mail.gmail.com>
In-Reply-To: <CAAhR5DGPF3AV22kQ4ZVNWh3Og=oiJiaDRgBL5feB6C-AHb=apA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM6PR11MB4691:EE_
x-ms-office365-filtering-correlation-id: bdd33292-c81d-4646-e775-08de38253991
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?STljR1hvUS9OeFVrUm0yV2JWWUhoOTFQUUN5UGhYU05YMjJnbzlGR3BlOUsr?=
 =?utf-8?B?SVM4dm5EOXZnSnU3ZUFRT3RpQzhPQ2pseXVYc0lwTllSd2t4MUVsRndrK25S?=
 =?utf-8?B?cjBGSG96c2lCMFpVTW9UQTd2SklVUk9rcGxjcEdCSHVsekpVQjlOT3Y5MC8x?=
 =?utf-8?B?T1BHYWZlUTFheXJWbGpjd1JndUVOTG11WExqcmgwTFZjbS8wOWV6VTFSNUE5?=
 =?utf-8?B?TVRxcnpmZ0xJb0IvSlpWV2h6OEtWQWR5NjFUa05qc1RrTkJrUFFrdXR0L25B?=
 =?utf-8?B?cGM3K3YyYTRnUmJPTHpQQy9zMk55NFpmd2FWRjJ2WlUvdVMyeW4zaG51V3pm?=
 =?utf-8?B?L0wyV2JSUmd1aDFJSkRHUWE5VlJreElicXh2TFl3S3N5eTg5L3hzNG5jRXNz?=
 =?utf-8?B?QTVLQUdwbE1zVGtkTXlqU2JCTXdWQ1hubkh1NjFDWHhWSnNBbWtISnZvOG5q?=
 =?utf-8?B?MzMvUm8ySlBSeE5JVHFIVXNuWnpRUEsxN3N2VzVacmJIZW1SMWtHa1NlVDFR?=
 =?utf-8?B?MHVIeTE1cUhwSkNCZ3NMUVZ1VkNlOEt4ZGFYTGlpQmpLT0w4NjJFZWlXNlB1?=
 =?utf-8?B?aklzQVFMU280bWgzRUNHaEc0QzgyZ2dCY1R1SmliRkxFeWhxdy94dHNodGdQ?=
 =?utf-8?B?TVA1NUVNbFNocDUwOTZjRDhzYm5JVnVVSG15Ny9Jdkd1U3hPTzBGQzdFc1Nr?=
 =?utf-8?B?Zko3S0dHTGJPczlPRWFvQkIyUWNDTEhsRzZ5QitEOUU2NTRkN1J5TGJ2Si9x?=
 =?utf-8?B?c0ozVFZsRWphWnFHb2NSalhMM0lobTBkdjhtL1dTVitZVU9TRXJiL2lnNWhi?=
 =?utf-8?B?aVZ3ZEdrcUNiU0lBUDVHYy80ZDdDdTNNU1FhSmNDY0xYQ1Juck8wUGpISnJV?=
 =?utf-8?B?Z09oZkRuUGtaS0YzdEZUU0xqMWExSU91YVRHdFJhdGN1ckdvUldJMDlEOTJy?=
 =?utf-8?B?M0RQbk5qOUpxMmVuQkE1Qlk1UWdoRnZTQ285aWk1NnB0YkhaL0F4ZUliZG1r?=
 =?utf-8?B?MW9nV1hFSXdHUVlyUzFrUGI0SkJ0bE90MXJJL21NNE5nUVBzSG03TzJlUy9O?=
 =?utf-8?B?eGxrMFVsNC9VeVljdmNMdVJMWWIyQWU5VTlpeG5GR0luNmR0MGhhSmdLQjVq?=
 =?utf-8?B?bmVoNjdQbk1mNmxZUlpGZndVdGRaNXFlU0htYVpKT05IRjNiKzJ2eTd5YWRt?=
 =?utf-8?B?blBsNUwyT3RGaWpCRkREcnVqL2FFTUZYb2ovL0ZzUzIreTFMUU16NTU0ZWF6?=
 =?utf-8?B?NmY3U3hpdlc4WUVKODRMMnowRkdtb09hOVZZN3VxQkpkZ1oxZWlGS2NzT3Zk?=
 =?utf-8?B?bjRYK25TMkRHcW11T1NHNmMyZFpYeXBTRUttVGg1N0lhc2ZpUm9WajNKTUFG?=
 =?utf-8?B?K3JBUW4rVEdJRjVSb1FGSG1ZaCtTaHZTRVU3TGI5Ukp1TDFwTVBxdEhnMFZm?=
 =?utf-8?B?M2psTEVRUEIxTlhPRG1MTTgrTjFsQUl2MUlMQk1uTTdZdUNjNzJ6alpjMFFX?=
 =?utf-8?B?T3VMQXJleDZEM2tpUkZCaDkzNlJldnh6Y0trYkE4aitmMUZyUjVkaEVneDcv?=
 =?utf-8?B?N0lIRFlaT1JJNzVTcERlVUw4b0dsaktjQmlKZytlU2h4MndHdDVtMUlhbjc0?=
 =?utf-8?B?ZXJ1d2hmOEFQVkRzZnYrLzNiVTZrZ2VlZEJ4ZzZqdjZWQXYzNThwYi9aSkRr?=
 =?utf-8?B?Z2pIRk1QNFNvdGVDeTA0dXZ3QVhkT2tmN2xBc2JJVG0zMGtaYjc0ZDdhS0Ji?=
 =?utf-8?B?MWFsMHJmT1NkYWlCVUFNeDlxbG5SSThnUVJlTGdVbjFpMkJjVGJ3ZjdkcndN?=
 =?utf-8?B?eFNnVi81Y1pYQmluWENKNy9TcURQVktBV2w4UmtyUHpzTUpyWHorYUZLY2li?=
 =?utf-8?B?WG82RzVEd1M3clFKVHpqeWZZaEpFSW1OdVNPVHl3N2FhdkVrUlBGZkpMb0J3?=
 =?utf-8?B?bVBQTy9NK3djaFprblh4dGtuaGlnQ1dqY20wMjgvdGhNWSt5S3p3NE5yckJa?=
 =?utf-8?B?emY2UE15Y0YvTFgxdUlzaDhXbFducnBwT01HRTNzS3RkTVFZSGJYR3RsOWxE?=
 =?utf-8?Q?6eYcaR?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0tSZDltZVFGUFRFaWtxRzZ1eTVkRUczSVViazlOb2lTS3NNMGF3WS9uWm8w?=
 =?utf-8?B?dW5hNUVOL0huaWVoRzJERHhuaE1BM0RKRk1oWUo0bjc3TGY2eGVQaW4rNWdP?=
 =?utf-8?B?TnBJNjhvTEttZlJEclVBZUVqTUdRc0pUekxGOUI3T3VPVHZKODNVWmRSdjds?=
 =?utf-8?B?YnhTOC85aFRVZGJvcUlLU2ZSOGJ2UytxazJvVUtnSTNRZi8wWng1dDdoeWFm?=
 =?utf-8?B?UHFYVVlGUjdWQ0pmQ2UrTmJRZGwvd0VVTGZtdjJtc0Mzemo0UGNkY0RPQzgx?=
 =?utf-8?B?eWdhYm9QM0VsZ0pndFZQUEV1cGNVbEZJbWpZUWZSMDRkU3FLV3NYU2dUVU0w?=
 =?utf-8?B?OGRZQWt3ZGFEK2JtNnpWQmNKL3p1dUM3RVkzTDVPOVdLSDFNdHljbGc4TnhW?=
 =?utf-8?B?a0cvOHA1YjBxWGtWNXIyQ0w1VUE3N01kK25WK242R1hkbC9pNmdVU0paYXJN?=
 =?utf-8?B?ZUpJT1FrMUZrVE5IZ3hrMVhtUUxweXVmTGViZmkwUnFKVnpja0N6dGRUSjA5?=
 =?utf-8?B?L1BYTW1hakVRK200ZWNyKzlSUmxDejA5ZGJPanhKcG9kL2tmdXI3M3k4Zktm?=
 =?utf-8?B?QjFpYlV0dGhteG1VNTRVOXUwbW5FcWhhcGxPdDNVNlF3L2JBbkVUS3ZkUit0?=
 =?utf-8?B?bVlNMzdhS3p6Y3QrcmkwT204SGhveVdVT1pJU0o3aXhTbzVLRE0zZm9LcW53?=
 =?utf-8?B?VzBtcUJocXIzeWI5WmZML0VrNU5iUlBpcFUvVEpDS2tzSCtOdnVhdnAzNzVE?=
 =?utf-8?B?KzlqdU1vMTR2c0JVaE85S2VXMHo3WmtEYnI0NEIzdE91SGpXS213emhodFRK?=
 =?utf-8?B?ek1HK2NMUGRLUEsyYkQvbWt1Umg4UVZTMXIxVUNqZW12dnJtOEk4bGRjS09j?=
 =?utf-8?B?eE90TmxDOUZmMEVJVnNZN3F3NWhKQ1hubGtDblBpdk4wcHdBN1B0OXRvUzFp?=
 =?utf-8?B?ZkwwZkpBZjdPbld1Y0M1WHNVMkV1cnR4emtSd0l1aE1sZVJVU0xqVnlFV2NO?=
 =?utf-8?B?WVRPaE5jcmZpV1FhU2tkalVNYThvQUc1RlFyYmFHc3J1QjNQSHkycWhNclY4?=
 =?utf-8?B?RWpRelkrOCtrOTBCWFJieWV0T05uVDZ6WXBEajBGUCtORzRVaDlHbkdoTUlr?=
 =?utf-8?B?U2QwSHdRR1pmSVRLQmsxMVhsQlorOHd4VnZUWS80cnlCRk9GY2xtK1VkbVF1?=
 =?utf-8?B?YUE2Ulc0Y1dYQml1WHJWL2RHNEowem0rLzIxWG9uMnpqbUJWbjR3NFFVZ1VM?=
 =?utf-8?B?cWQwVEJpenFqNCt2MGxFcDJGWm9JaktVQ3VzNVZhL0hidW5yczFwRmZPcW5j?=
 =?utf-8?B?YVRocGtlS3hiRzlrSzNoUVZvajZ3V0RPL1FTU2psZmZnSGFtWUFucHlHQUFx?=
 =?utf-8?B?Y1RFWDJBbjN0bm1DcVVqVGFNTGl4TlNvWFkybGljeS80UG0vQ3BJMU1kRGdI?=
 =?utf-8?B?YzhSVms3VE9VL2ZQUE8yMzB0Q3E5eTBrTk1JVWVWM1M2Wk5PT3FyUXBsRjh3?=
 =?utf-8?B?dlRhSHNhQkhSdVdXaUdOUzRFc1dwcVdvWVR6VW1lSmVyeE41dTVzRkRUZHVS?=
 =?utf-8?B?MGRldExDYUF2RnY1VkF2OHFJMmkzTGYrYW1qQWRja01LVTlXT3lvU1doeFVL?=
 =?utf-8?B?L2V0SCt4YXhIekYxVWRQZjdPUmQ3OXBaTVJLVnZidVpLQS9FeWpsSS9mYUpO?=
 =?utf-8?B?d2RVTEpzdElmdU5ra3FUWXR5R0MzTG02OVJ2eTArcXRLSkppYXlqQVdGUUxC?=
 =?utf-8?B?eEdpRnBTTnFCaHNFR3pyUVdHQ3FmVWNIVCt1Wk1DZ0dBbFZsa1lQczM4RFFI?=
 =?utf-8?B?WkYyOHlMTGtoM3lRYnJQYVRBNW1oUHRjMzFIdWQwM0piTThBOEo5eU1iamN6?=
 =?utf-8?B?ME0yNFlUZDJnZC9jMXpxZEZIWFFxSFN2ZnFBL2k5MHRKVW13UzQ3Rmd6cURu?=
 =?utf-8?B?NHQycTF2UkE0M3ZvMUxDbXd5L0VPSm5CcFNnYm82dzBkb2VTd09pOHNCZDhk?=
 =?utf-8?B?TGNIKzVHM2xaMTdHZThGNmlhZmV1L2Z1NmdnWFg5L3JBSlphS2tWV0IwRW9O?=
 =?utf-8?B?RjVtUDhobFVxQ09kKys0cm95TzZyemN1QnpoWkorSU5NT1NxdmdkNld5Z3V1?=
 =?utf-8?B?Y240N2o3NFd2b0FsK2o4M1lFWGNQbGhrSkZKbU9rU0dUVzZTZnF4NlZsaThy?=
 =?utf-8?B?Mmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDD4C8DC25D25442BED03B2382EE39C4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdd33292-c81d-4646-e775-08de38253991
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2025 19:49:26.3676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7RwHvtbMW8ERQb2zzEIJPQWmZXbPhwZ33wulhXr2b4hUzUc4sEQUUczy7PuXf8y9PIE6dcwMJrhyjhtMsFpsYL+GjntbCVIA3oePt9iHZsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4691
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTEyLTEwIGF0IDExOjE2IC0wNjAwLCBTYWdpIFNoYWhhciB3cm90ZToNCj4g
VGhhbmtzLiBJIGRvbid0IGhhdmUgYWNjZXNzIHRvIHRoZSAxLjUuMjguMDQgbW9kdWxlIGFuZCB3
ZSBuZWVkIHRoZQ0KPiBjb2RlIHRvIHdvcmsgd2l0aCB0aGUgMS41LjI0IG1vZHVsZSBhcyB3ZWxs
IGJhc2VkIG9uIG91ciB0aW1lbGluZSBzbyBJDQo+IGd1ZXNzIHdlIGNhbiBqdXN0IGFkZCB0aGUg
cmV0cmllcyBsb2NhbGx5IGZvciBub3cuDQo+IA0KPiBEbyB5b3Ugc2VlIGFueSBpc3N1ZSB3aXRo
IHJldHJ5aW5nIHRoZSBvcGVyYXRpb24gaW4gY2FzZSBvZg0KPiBURFhfSU5URVJSVVBURURfUkVT
VEFSVEFCTEU/wqANCj4gDQoNCllhbiBoYXMgYmVlbiB0ZXN0aW5nIHdpdGggYSBzaW1pbGFyIHdv
cmthcm91bmQuIFNlZSAiW0RST1AgTUVdIHg4Ni92aXJ0L3RkeDoNCkxvb3AgZm9yIFREWF9JTlRF
UlJVUFRFRF9SRVNUQVJUQUJMRSBpbiB0ZGhfbWVtX3BhZ2VfZGVtb3RlKCkiLg0KDQpXaXRoIFRE
WF9JTlRFUlJVUFRFRF9SRVNUQVJUQUJMRSBjb21wYXJlZCB0byBSRVNVTUFCTEUsIHRoZSBwcm9i
bGVtIGlzIHRoYXQNCnRoZXJlIGlzIG5vIGd1YXJhbnRlZSBpdCB3aWxsIG1ha2UgZm9yd2FyZCBw
cm9ncmVzcy4gU28gbG9vcGluZyBkdXJpbmcgYW4NCmludGVycnVwdCBzdG9ybSB3b3VsZCBoYWx0
IHRoZSBwcm9jZXNzIGNvbnRleHQgaW4gYW4gdW51c3VhbCB3YXkuDQoNClNvIHRoZSB0d28ga2Vy
bmVsIHNpZGUgb3B0aW9ucyB3ZSBkaXNjdXNzZWQgd2VyZSBsb29wIGZvcmV2ZXIsIG9yIGxvb3Ag
Zm9yIGENCmNlcnRhaW4gYW1vdW50IG9mIHRpbWVzIGFuZCBLVk1fQlVHX09OKCkvd2FybiAobGlr
ZSB5b3UgaGFkKS4gVGhleSBoYXZlDQpkaWZmZXJlbnQgcHJvYmxlbXMgLSB1bmJvdW5kZWQgbG9v
cCB2cyBwb3RlbnRpYWxseSBraWxsaW5nIHRoZSBURCBmb3IgdW5yZWxhdGVkDQpob3N0IGJlaGF2
aW9yLiBTbyB0aGF0IGlzIGhvdyB3ZSBjYW1lIHRvIHRoZSBkZWNpc2lvbiB0byByZWx5IG9uIFRE
WCBtb2R1bGUNCmNoYW5nZXMgZm9yIHRoZSBsb25nIHRlcm0gdXBzdHJlYW0gc29sdXRpb24uDQoN
CllvdSBjb3VsZCBhbHNvIHNlZSB0aGlzIHRocmVhZCB0aGF0IHRvdWNoZXMgb24gZGlzYWJsaW5n
IGludGVycnVwdHMgYXJvdW5kIHRoZQ0Kc2VhbWNhbGw6DQpodHRwczovL2xvcmUua2VybmVsLm9y
Zy9rdm0vOTlmNTU4NWQ3NTkzMjhkYjk3MzQwM2JlMDcxM2Y2OGU0OTJiNDkyYS5jYW1lbEBpbnRl
bC5jb20vDQoNCkhvd2V2ZXIgaXQgZG9lcyBub3QgaGVscCB0aGUgTk1JIGNhc2UuIERvIHlvdSBr
bm93IHdoaWNoIHlvdSBhcmUgaGl0dGluZz8NCg0KPiBGcm9tIHdoYXQgSSBzYXcgdGhpcyBpcyBu
b3QganVzdCBhDQo+IHRoZW9yZXRpY2FsIHJhY2UgYnV0IGhhcHBlbnMgZXZlcnkgdGltZSBJIHRy
eSB0byBib290IGEgVk0NCj4gDQoNCk9oLCBpbnRlcmVzdGluZy4NCg0KPiAsIGV2ZW4gZm9yIGEN
Cj4gc21hbGwgVk0gd2l0aCA0IFZDUFVzIGFuZCA4R0Igb2YgbWVtb3J5Lg0KDQpJdCBwcm9iYWJs
eSBtb3JlIG1hdHRlcnMgd2hhdCBlbHNlIGlzIGhhcHBlbmluZyBvbiB0aGUgc3lzdGVtIHRvIGNh
dXNlIGEgaG9zdA0KaW50ZXJydXB0Lg0KDQo=

