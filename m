Return-Path: <kvm+bounces-46910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9810DABA5E6
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 00:28:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D6EC9E6564
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 22:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41EE228001A;
	Fri, 16 May 2025 22:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ivkDB8Jl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AF822E3FF;
	Fri, 16 May 2025 22:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747434479; cv=fail; b=POz5OTq3NP6ztwzOb+tGiM6NIb6Smft1ma4e3IL2RV4IfeJq19LfYSqcx3QOR/vdLoLr78ftxvb7W5P0/F4bVmLOhx+smqv0iy+nDZj2BCVSxDsbTwIVWANosCzPOQsYtQdeEvgYg9dWSt3Ml/qe5cn7UKmT0SScHDeNroYiM6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747434479; c=relaxed/simple;
	bh=gQk0Pk4MlXMmg3dVh+IdVrnpS4G+eBeqEcHaVXZGnYc=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PBC8dGjGmfdq6+8GIDNODlaJDcydHPyqEPgMYE+o4sM74+/fWUt80YFUjPgClDEISb0/xtAhaTN5PRHvRtFM4tyF0WUdwpxWAJ7dNjgnlRCJWlMFrpNFPmzaT612t3AM0C9Ofvs59duNc4tqvjF4zO81jMQYdAx1mbG0ltYMKoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ivkDB8Jl; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747434477; x=1778970477;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=gQk0Pk4MlXMmg3dVh+IdVrnpS4G+eBeqEcHaVXZGnYc=;
  b=ivkDB8Jlb5Xd4jkMFRznEyWYXvJ9YsJkOOJ8BF9qSktflh6e6TQ7UGXF
   f1V0H1CpnxYeZXm761VHSTrjxKrSpB3VxwUbKdpt7g1/t8JbZK1PSpCl/
   XGJMtvgVOjH2EZNMRe8+9HwJINsnaR0S7oF2kLF4xXtmL7x2JQIwnt8dz
   +2iFXZLEt8SuMGmEL+J1FvJlCVegsbKMAQHOQ2LVpurVgiLN8NjTxMZHK
   9ORBycWp78FBwTyzFMy/IkRNspD2cOzVpv9D8yxLnnRlnpaZEXUHnH4Px
   xOKwqQWgIFmGs/2kdJXyyHuEWwzKCH7h2r8+uJT0gqNDue61C6Jj6RyfO
   Q==;
X-CSE-ConnectionGUID: GjuH/5d4QSmSsnmkb+hNRA==
X-CSE-MsgGUID: Np6ClmEaT2KGNDRC3F1p2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="60760612"
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="60760612"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 15:27:56 -0700
X-CSE-ConnectionGUID: aUyCKdv6QeqVHV+GSRs74w==
X-CSE-MsgGUID: VCBGomEYTcWYg5aFfu50gA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="143795152"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 15:27:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 15:27:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 15:27:56 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 15:27:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qpXVPh4RwZm6z5n2ZgLQwyfdvda0iEjW4KMhvlwzLm97o+wx2snl7ZBMp0KBYE7o/DkizZVjmIH4VR6cilOZSu16VO3NqdU9Z4sL53XEtqWuSgrfLxfwNlLUnCznsZ1uqr0tzzFRJVjiKEYuAxnKW+Q5tOnthJEcqI+boT4O21q4w8bTQFMUUKho1W58Ez6HazPJuojyoKMa5vRVcph9XdJVWqSbfmZxPZCAO47lFsSi/mLVHLIfPwY/EKAkUBzxXGtA9uMOSGrHIf5yFNdahI2kMpzvIkWGMSbLLxHYHAnUL7gaPwWX25h8LqQ07P5oFLMUddhMsXtXv5Cc91r86g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQk0Pk4MlXMmg3dVh+IdVrnpS4G+eBeqEcHaVXZGnYc=;
 b=OuptMESqYez7InIUxfqwJIIWhWwjmiCjXtSSyVD6PICUuSeypl2J2eAM0uxljFrD8VkCuW5CGIskiPxKrVk2RACD9XENGpDN0QXtWd1o55sehP9fkvPmw97YQ7PI/uaR1L+MJkAnhBgpbQB6ohi71h7Dr6fDd9R4/6PCgjNtx3f9+r73DRPx5yr84on1YgfIT3XPzBj61taNlcd5tr+k9kS9hNU2YhZWfJpVoimZRUK5q45hfhogZS6FBZhEmXXGlitK2yGcpHautLVBV/qqEKHNy7M3PSPpRfG+DE5lwE9O9RxX5sT+ihzXnCnKypzmJo1TLoMVmVIQUoW2J/AwzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW3PR11MB4730.namprd11.prod.outlook.com (2603:10b6:303:58::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Fri, 16 May
 2025 22:27:10 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Fri, 16 May 2025
 22:27:10 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "tabba@google.com" <tabba@google.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 16/21] KVM: x86/mmu: Introduce
 kvm_split_boundary_leafs() to split boundary leafs
Thread-Topic: [RFC PATCH 16/21] KVM: x86/mmu: Introduce
 kvm_split_boundary_leafs() to split boundary leafs
Thread-Index: AQHbtMZq5aOSX6sBB0S9hhJvW+6Xh7PRSvSAgAO44ICAAAScgIAA8VWA
Date: Fri, 16 May 2025 22:27:10 +0000
Message-ID: <39cc767dd2f3792f1b36e224f1567dfb997fc0cf.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030816.470-1-yan.y.zhao@intel.com>
	 <e989353abcafd102a9d9a28e2effe6f0d10cc781.camel@intel.com>
	 <aCbtbemWD6RBOBln@yzhao56-desk.sh.intel.com>
	 <aCbxSyLUhjyeB+05@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCbxSyLUhjyeB+05@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW3PR11MB4730:EE_
x-ms-office365-filtering-correlation-id: b6db78f7-1dff-46c1-ce63-08dd94c8cc82
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?YXlBQTBOVXl2WnEvcU1SM1pkKzZKUjdoVjBtYU1TVGRqM0IzZWUxaUtLaTgx?=
 =?utf-8?B?TzRSREJObllnN2szd2VxemFvVFB0cVR5bDZNdjlLdGwrK01kTDNFcENJVnVv?=
 =?utf-8?B?bXp2NXJuN0FWcVhCOVd1MEVkWVBWV2ZYanIxa2tmQVhleVRqQXZ3Ym1KTUYw?=
 =?utf-8?B?OTBEKzlFbDd3N1l1dkI1Mk9ubTJud2k3dkNpUmUzZ1phWmpLSmtQWUZiYkg4?=
 =?utf-8?B?TEFDRGVCVHdqMFM1ay94ZUw5L3ZyREE0b2FicW1YNllnOHYyOW8yWmRMRjNs?=
 =?utf-8?B?N2ozeDErdDRxUGZJUlA2S3grdGxhTlVnSDczZUI3TkZCemIyTjJlL1d3cWxZ?=
 =?utf-8?B?N0o4WTNaK2tUQWI1TG1wUW1TZ2R1anVrdDZyNjBXNThPMWcyMnVvOS90eXlY?=
 =?utf-8?B?ektPNThkSVhnKzlxcFJlT2drcEN1Z2k4VFdncXNVRk1ra0lGMlR4eUJnOWIz?=
 =?utf-8?B?eXF4WSs2d3gvZDBmR2ZPV1V0V3R6YmZpNEpERU5VclowYkRDaVFqcXVCd1ZS?=
 =?utf-8?B?c1p5S1p6QTRDQ1FjSWZMOUlRYmlFYzdXS0h1VGlXUG5RQzhTVUx0dUZnRnd6?=
 =?utf-8?B?enZMbW02NzZqYWdZcUJKbDlyZUUzOTFtaHM4TWRxSjdvTUViY2tva2U0b2lv?=
 =?utf-8?B?bmVjL291ZHR5RmJ1MUJ6WU1wbE1sOWo1blFDM0dWaTdJSmNKMkNhbFRjWHRn?=
 =?utf-8?B?S2NodU5CUitXbExDeDN1WDdobFRjaERMQlIvVWtBZVVBQ0NPTWU0VlFEa3hl?=
 =?utf-8?B?dnZjSi9lYVdyL295Z0pER2xucWl2R2I0OEF6K3lkVGJvSzBYczBnUHgwcTY5?=
 =?utf-8?B?UG5hS1JVVlIzZDRJT3gvUnJlNGxmMHdkWU0xeW9ZZkl0eS96ZDFtRWZXMEgv?=
 =?utf-8?B?SGJlbmhyOUFMbGZ2cS9tdXQ1d3VJRXhVWkprNGkxdXdqMDNDUEdwVWUrVGV2?=
 =?utf-8?B?YTU2ZDVxMGZCLzE2Y1g3VXJ6a3hscWZwSDUvN0tYMmVIZDFVQWZZcXBrSWRz?=
 =?utf-8?B?RWZvbGR1L3lKN3R0czRJZzJLOW9BYmRNTEtzczJYTzg4WDJENW1YbDd3TmN1?=
 =?utf-8?B?VkNzMHBlUGI2c3Z0NDB4a3Z3aGNSWHpsZDVvdTNEMk1YS2t2VDdOQy91b2tQ?=
 =?utf-8?B?Rkl0YVp0OXhYQnUyU1NjWFVmTitVMWFPY0pJd3Ara0lBalF3RTNIdlh0QmhC?=
 =?utf-8?B?SE5IWS85ZzBsNlBLQU9uMnhOcDVXcnRhM2RLUFhhMVZhVnovKzg4cmtzRDQv?=
 =?utf-8?B?YkMyaGhSTFhpR3ZNRkxMeStUaUJrQlM4M0VrUUZrNzNBeGptUGtEMU9pL3Rp?=
 =?utf-8?B?dGp2TXFuWkNoanBTbHYzVGc3SUFHYkN4b2R0RFU3Mm1RT2VXV0FLNkhxUFd0?=
 =?utf-8?B?M1BiOVVMUXh4cEhqWmV3Vm1yR3MwOFFBcGFrYWxNNU1DckxJMDV1SzhwalMw?=
 =?utf-8?B?ODlPOWFQY3pKU25Cc3BHTTc0c3orc2FKOXo1OFNxV3B0OTVlTVNkYmFMTE9S?=
 =?utf-8?B?SWNlclE4dGlTTU5MQnNuY0RJb1RzK3ZyVXc1aWQ3MDFzQXFLUWV5cUdDcGw3?=
 =?utf-8?B?c256VzFEd2dCczJyTXFSdzFsUEl4MWdUL210NktNeFVmc3B5anl4dWYzajZk?=
 =?utf-8?B?M25QdFZwUzRSbXRnZ2wvYmN0Um5ydzdVcXFLYTg0ZWV0eVptZ0E1NVM5QlBl?=
 =?utf-8?B?MW9zc3ZwaXdHcG5na2V3ZGx1OTRFZHJQeVFEb29ScS93WGVWeCt2bFNmRzZV?=
 =?utf-8?B?Q3grcTBOeEdqUXdFSlhOYjBQUk8yb3ZPSys2bkEvNXJvbVlzWkVjb0M5RjJQ?=
 =?utf-8?B?a3YvQXBVZ2xQTW5TV1ozYi9LNWY0Q3QxL1cvQ0hadlJDRHdPeDNQeFhSTEg5?=
 =?utf-8?B?K0ZuWnRBeUw2V0I4TWZGK0MvQVFtTzZkMzZNWTVkbE41bWxtRERLc1ZkQkRz?=
 =?utf-8?B?MGlCb1lINGFvc2NtTlNTek5DRExDalJ5clVwallGdUM4UHBYQzZ5NVZ5Zmxt?=
 =?utf-8?Q?BTQHjQv11dx5f72me9bVZ7ES7dBye4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVQ4aDZMWHE4K3ZXS1NTa2RIbzBxUUs2U2xjcVFka1VlOGZmdnRaelVoQ2l1?=
 =?utf-8?B?YjNGUmZoeW42U0tTc0RzemM1ZUd6MjhPWExDcVlzb0JZbDl2Y0NZTzlrR29y?=
 =?utf-8?B?Y2JCZnlyTXA2U01FdzN5YzdTS09KaFo2ZXRnNHVjTlpPeXFObWZRNDh3ZUw4?=
 =?utf-8?B?cnIzU0dQbFVnNmZGK09xM1hjVXJ0cmtlWWVrS0pkZEN2QWNkOUlBdWxNbXl3?=
 =?utf-8?B?MXY2MkdwOXJnUFdweitya0VUbWU1a1MrSUE5ZkhWRWMyS2UwV1VReDFWM1Jh?=
 =?utf-8?B?YkY4QmRoeldNWVNQdU04QVBMMU1ZMG9FZStXL2c0UDZsMFoydE5FdHFQTkI1?=
 =?utf-8?B?Mkpua25haHFBUHpuT1BHZ1ppZ2JVNnFGQWpnV0ovMUlBeExNT0RKYURPVlgx?=
 =?utf-8?B?T0pmL0JaRXZ4UjZGV0loZCt1VlZMVW9KLy9QUU5XeDBkaFRhTFdwRUpZZitp?=
 =?utf-8?B?RERZcWk2Z3RkVXp5VDlicGdzQUlhcUU5SHB2ZEpwSEU5UmtTdzdDbVpadnRm?=
 =?utf-8?B?ZEJDbmc1VmpqL0FTUy9yWkJ2YS9rck94STdxaWVPZUdNNklzdTZaaHpEZ2xR?=
 =?utf-8?B?VXdqdnVycVNJd3BSZ2VqWGlwWERQZTdETXVpR0xFUVc2OUlQcm42WDFSVnlq?=
 =?utf-8?B?cWpQRUFGOFIrdDRNaG5JRnJtTEJaMmxTU3VQWTIwVzV4L29tVVV0Q05ZOVJU?=
 =?utf-8?B?dHhZcmEzRElidlphZEhUUkZlQ1ZNWWxHeXpnSDIyYllhbm40elpOQ2M4ampU?=
 =?utf-8?B?aStlRmxaeHQvdkQxdUZNeDNlZkNubVZGNTd6RE5VNUI4WWJ1TXJaaThta1dU?=
 =?utf-8?B?c01YQ1hjRjhUU29ZQWZJclZTdWNseFZ0Y1lhMmJ3ZmkvNVliZkVsbGdIOER1?=
 =?utf-8?B?WFpNTXo0c2kzemc3K0JmUjNHeFFTMVFlZG9HSkxFSWV0eGFRQm4rcGhSTTNj?=
 =?utf-8?B?NlROU05WR2YvTWJwNWhxZ1dWbUI5VmMyb2Z3OStNcVN5c25vUW5XcUhpKzhI?=
 =?utf-8?B?MTVGcWgrMTJYTjROVEE1YW9tckdwVlE2N1FzdHZGeExXY0lOTDR5b3NPeFBn?=
 =?utf-8?B?VkhVdU91VTBOSUdqNUtOSm5Ea2VCNTF6YTJNakxyNW83eG5NV2JWWEpsdnlp?=
 =?utf-8?B?dCtheVhlaTJBZmd4YlgxSzhVNExmeFVRRG1uR3Q2dVVJdzN4QkJ4NGtFSnBC?=
 =?utf-8?B?SmYrR2dkQmd3OXc1NXhRZUxzQ0Z5U2JIOHpkSUFYY0tLZXZVeGdnMkhhL0oz?=
 =?utf-8?B?UVpwRjl6aFJpS0laZlIvci9jc2crSU01NzMyQW1EMTVzZ25QVkM3QWJVakk2?=
 =?utf-8?B?RVFrNGd0aTFwcE4rdmxkOVdxaDlDN1FscjlGbDZlNjZVb1VRSVBwM1M0RVBT?=
 =?utf-8?B?UEMwNk5lOU02ZFBlRDVBaGVPSjRQdGxSOWlETVAxTnJaR2J0VWIzbmtOdk1O?=
 =?utf-8?B?RzdUSVRudkpZbzJjaHlDclptWUZiMlFTWmNYbHhTRmlsSHNDemRDUnJKMEZj?=
 =?utf-8?B?WFM3bWd6ZEdoOXRPMDNMazFLZ1NwMldCK1VYS3VpU29JUldqWVdUMVdTOE5G?=
 =?utf-8?B?UTJkNzZDOG8wUDF2LzV2eHBGeTliUmdFbVErOW5xYWEvcHQ5NnhGSXFNTkxX?=
 =?utf-8?B?NWRqbjV1VTRyWElBNldPT1VMWDduUklwdXpTNFBSTHd4QWRCdEx4cVhmL1Vh?=
 =?utf-8?B?ZVBndndBMjgrdDdSTnliajljMXBBWVZIaDlSa20zTExmT3NHcHdLeWdBNUtW?=
 =?utf-8?B?OE9wTklIWk42elNaUUVONDZNb2dZeGZUOGZybFR2U0ExRUdxMjBSQzN3OWsw?=
 =?utf-8?B?aWVRL3lmVUVOREdoZkJBTUJBYXQzVTNxOU40cEhaRE9jeDNncER4Ukd2UG9y?=
 =?utf-8?B?b3pNZm9QT2IyUEtkSHAwaW9xOVN1ZVV4akY4WmZIbVZYZXNkNVUxMDN6bTRM?=
 =?utf-8?B?V21jNkI0SEpYaW9iQ2NWZ0tvRGR1eE9Va01yYitVYlM2ZGlnU0lMK25ROStk?=
 =?utf-8?B?Vno4ekMzd0RHdWZrSCt0M2V3YmJPYVJZYXZJL1lwWVpKbWNtcDZaR0RHYy8r?=
 =?utf-8?B?QU9JRlNCS0trKyttUXpVQ1hhSmV0TVRaWmt0QzNBdEY1QVhYaEViNTBweXM0?=
 =?utf-8?B?K0huK0c5UEZQTUJqdFpqUFdmRHJiUFlCMWJYeUNUblc5T0dvWmZ6bUxkeVRY?=
 =?utf-8?B?QWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0806EBF47BC79342A3949E1D9D481DE5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6db78f7-1dff-46c1-ce63-08dd94c8cc82
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2025 22:27:10.1505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R1+GDkKtZ0HI+h4Oz0TVAPbza+QkbG9ARyacopNiBE6X7rDxKklb3i4DCqi8fsNHK3qAXAbOYbe2r1k//uSyiFCC8UwtFtpYQYFznzO4Pck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4730
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTE2IGF0IDE2OjAzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiAN
Cj4gPiA+ID4gK2ludCBrdm1fdGRwX21tdV9nZm5fcmFuZ2Vfc3BsaXRfYm91bmRhcnkoc3RydWN0
IGt2bSAqa3ZtLCBzdHJ1Y3QNCj4gPiA+ID4ga3ZtX2dmbl9yYW5nZSAqcmFuZ2UpDQo+ID4gPiA+
ICt7DQo+ID4gPiA+ICsJZW51bSBrdm1fdGRwX21tdV9yb290X3R5cGVzIHR5cGVzOw0KPiA+ID4g
PiArCXN0cnVjdCBrdm1fbW11X3BhZ2UgKnJvb3Q7DQo+ID4gPiA+ICsJYm9vbCBmbHVzaCA9IGZh
bHNlOw0KPiA+ID4gPiArCWludCByZXQ7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwl0eXBlcyA9IGt2
bV9nZm5fcmFuZ2VfZmlsdGVyX3RvX3Jvb3RfdHlwZXMoa3ZtLCByYW5nZS0NCj4gPiA+ID4gPmF0
dHJfZmlsdGVyKSB8IEtWTV9JTlZBTElEX1JPT1RTOw0KPiA+ID4gDQo+ID4gPiBXaGF0IGlzIHRo
ZSByZWFzb24gZm9yIEtWTV9JTlZBTElEX1JPT1RTIGluIHRoaXMgY2FzZT8NCj4gPiBJIHdhbnRl
ZCB0byBrZWVwIGNvbnNpc3RlbnQgd2l0aCB0aGF0IGluIGt2bV90ZHBfbW11X3VubWFwX2dmbl9y
YW5nZSgpLg0KDQpZZWEsIGxhY2sgb2YgY29uc2lzdGVuY3kgd291bGQgcmFpc2Ugb3RoZXIgcXVl
c3Rpb25zLg0KDQo+IFdpdGggdGhpcyBjb25zaXN0ZW5jeSwgd2UgY2FuIHdhcm4gaW4gdGRwX21t
dV96YXBfbGVhZnMoKSBhcyBiZWxvdyB0aG91Z2gNCj4gdGhlcmUgc2hvdWxkIGJlIG5vIGludmFs
aWQgbWlycm9yIHJvb3QuDQo+IA0KPiBXQVJOX09OX09OQ0UoaXRlcl9zcGxpdF9yZXF1aXJlZChr
dm0sIHJvb3QsICZpdGVyLCBzdGFydCwgZW5kKSk7DQo+IMKgDQoNCkhtbSwgbGV0J3MgYmUgY2xl
YXIgYWJvdXQgdGhlIGxvZ2ljLiBUaGlzIGlzIGVzc2VudGlhbGx5IGEgbWlycm9yIFREUCBvbmx5
DQpmdW5jdGlvbiwgYW5kIHRoZXJlIHdlIGRvbid0IGhhdmUgdGhlIHNhbWUgaW52YWxpZCByb290
IHNjZW5hcmlvcyBhcyB0aGUgbW9yZQ0KY29tcGxpY2F0ZWQgY2FzZXMuIEknbSBub3QgZXhhY3Rs
eSBzdXJlIGhvdyB3ZSBjb3VsZCBoaXQgdGhlIHdhcm5pbmcgaWYgdGhleQ0KZGlkbid0IG1hdGNo
LiBJIGd1ZXNzIGEgaG9sZSBwdW5jaCBvbiB0aGUgZmQgd2hpbGUgdGhlIFREIGlzIGdldHRpbmcg
dG9ybiBkb3duPw0KDQpMZXQncyBjb21tZW50IHRoZSByZWFzb25pbmcgYXQgbGVhc3QuDQo=

