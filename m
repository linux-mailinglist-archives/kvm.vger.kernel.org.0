Return-Path: <kvm+bounces-65633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DD89CB1747
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 00:54:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C534530BC94B
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 23:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A742DF154;
	Tue,  9 Dec 2025 23:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nM72B2Et"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E60E23E325;
	Tue,  9 Dec 2025 23:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765324447; cv=fail; b=KFHwC0D0TT4OaWXnk6kppgHTbzhtSrZ9YgrgnF5hy2rsXrWWGz4KUolT4MYKCFXIe2s2VTo1edOx4W4wqxs7yxlUXwwmMjKWZBogxCDOnjEmCKQ1eATiMeh11cWf+AHD2pOZsMnyoWoXXuheAcCIEbSwGMRZe+4sOmm1Ljwz018=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765324447; c=relaxed/simple;
	bh=HV1k45tB+DMYwHjg7WdL7CalZ5z8VSLf4BUmQK2eoU0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kpm0uVdf6qT8aia+T5AnDLu+H5oZQ5KH2+L7zSIcarksTOD8o8j1k5WLAZmnfSXJHYl1Gw23VROxbpUMlE0epu5eUWFU9kQuBi0J0dQXWAXQSF5MKMPWTXPbA1oMMMnTGAQ1sHdA2rDqgxyv3Bl/RyS4OC9Uc1m5cfzClCDY+yY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nM72B2Et; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765324446; x=1796860446;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HV1k45tB+DMYwHjg7WdL7CalZ5z8VSLf4BUmQK2eoU0=;
  b=nM72B2Et2yf04PVoh6uAGFn6NayEGlwDOE9fzV0VnU6zFDPYuSR502nc
   i2uhAPHRuyW/4nKoWlVFqnniZ03iYg+5i9lFPNDHhna3/BRXvvhKKQM17
   D1flb4IKgKnS+DbkYjoUg+IegOg1xxMU5GVolYLsCUEUE1sTZbrbKrjvm
   pEpUp0V5l69r0wlOrdCQBkGTVoe9iAlWnpg1lerZATaejpN12wZMV1J7C
   5MZyk9xOWSXIf5cbihN6aME4zafK8Le24T1HahTaYQcoh4+G1SrU19iKs
   6Rwk9uP/lTpvJ5Q1o6GY0Yhp1S2npSOhj5cyh5cVE0hxNmxbQiOuZBWDI
   g==;
X-CSE-ConnectionGUID: OZg+CTR/TJuX1zHiFqWzmw==
X-CSE-MsgGUID: eSEf/Nu8RVKsHQD9UdsOgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="66469489"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="66469489"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 15:54:05 -0800
X-CSE-ConnectionGUID: BDmPa7QKQ6us2ZM6ZKjCMg==
X-CSE-MsgGUID: 7i6No2tVTgOX9S3y4E+sJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="196818158"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 15:54:05 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 15:54:04 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 15:54:04 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.51) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 15:54:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NxLZnsHcRomR+CnnceUTm/lLi/oevATxP7JSGqK8eABEiji/xVzaE6l2X6eGRA7Y16wOsSu7DZnh1DLAZYhd/pmd0zZWdF8Y/+UcDdkCWxdt3OMVkeLWlMS3EPnPEQ9UGn7trN7OFTa5NnPkQrUaDsZmqViBVQxpbepWC1eZJ24xKjqgfqZifSQxQZyLD7zm19T9SDU7KRsXjURkWQgFPL3pM2HoNeHdQVCmt559Er7c2lfq1ITBRAdFvDJhfMIqTa6C261TjDYTTXZrM/Mvy23qeq+46DD1ueHKx+pOZ1W1nkMqF8MGg2fldTuUGm5X8a31FClJWdDnify4KpxwKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HV1k45tB+DMYwHjg7WdL7CalZ5z8VSLf4BUmQK2eoU0=;
 b=hCPzbYUcY2M3SIcKPsHXDghHFINmML/NGHd4d40FjGY0gijGRHbMDPbK9P1zeJ3I1mXP4h1LSH8IwGQ1s4B/vgtiDH6W+UTekdwXkpxy1HkY57HAF93PYj0HVT3KXJCBH0X/+RbkM+tNZbGSBn+DszYJNKK/vXi6rh2iOm/wQAA9U/CcWJkwTuZv48yqMQ91SgD48W/Zc9OKTCq65/hZmc2Ik2J5h4hpQgnusxfeH55HOuwPGDlB6fLKWIpdDZQVwO3a17uyfduUcsI9oOtuRkvCrE2fGTfPAQ6YGZ7Qwo7EM7DTldoBc2Zr5IXwyzTxEbFR55NVIU2hP+u/w4UV1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by DM4PR11MB6477.namprd11.prod.outlook.com (2603:10b6:8:88::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 9 Dec
 2025 23:54:00 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%4]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 23:54:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "sagis@google.com" <sagis@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "zhiquan1.li@intel.com"
	<zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>, "Miao,
 Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 10/23] KVM: TDX: Enable huge page splitting under
 write kvm->mmu_lock
Thread-Topic: [RFC PATCH v2 10/23] KVM: TDX: Enable huge page splitting under
 write kvm->mmu_lock
Thread-Index: AQHcB3/ZS03ZQoIYB0ahTxw/ttjQXrUavfSAgAABOQA=
Date: Tue, 9 Dec 2025 23:54:00 +0000
Message-ID: <5b9c454946a5fb6782c1245001439620f04932b3.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094333.4579-1-yan.y.zhao@intel.com>
	 <CAAhR5DGNXi2GeBBZUoZOac6a7_bAquUOzBJuccbeJZ1r97f0Ag@mail.gmail.com>
In-Reply-To: <CAAhR5DGNXi2GeBBZUoZOac6a7_bAquUOzBJuccbeJZ1r97f0Ag@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|DM4PR11MB6477:EE_
x-ms-office365-filtering-correlation-id: 55213fe5-b9b9-4350-0519-08de377e39cf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?OTJId3VlaGJNK1RlUDBBK242UWFkQmJPdE9jR0s1ZEJLOGwzMDNHRUZ3VEtt?=
 =?utf-8?B?aU9PRVhkNWhSZThRZWwrSW9lSVBqZHZNcnFTRU5aRGNLY2o4YkZyb1c4S2pO?=
 =?utf-8?B?Ym5PUFlPVmRBYkdPTHRlLzVDUDJOK2lCV0o0dWwrdThkSmZNNEVGdDdHRUpx?=
 =?utf-8?B?WWxmUWFBOEdJaWpaVC8rQ1VRVWc4VStPV01JOTRGNGFnZ2N2a3VNcDczL1pr?=
 =?utf-8?B?N1FCOXBwdkRZWlUxNGF5eVpqQUdpYTAxNnhEdzN0TEFJQ0ZSeHdLRzNuZFpi?=
 =?utf-8?B?WXhycXRXeENmazVXYjVoZ2svTmtwdHJCeVRTRGppSEhxa2pIamF3U25LQnhW?=
 =?utf-8?B?RnlZV25MZ0tmMExsUjg4Y2hzOHdFamZicjR3VDM1b0pzVVdieCsxR3MvL1dZ?=
 =?utf-8?B?VW90K1Jsayt4YUpVV1FLVW03WU8xeFhsL0V1cHdUMnZ5OGl6SWtXN08zNDNy?=
 =?utf-8?B?K0FZRWN4bXlPZnREcXJvWUpNaXo3Tk0zYlZrWmJQSXJieUtKY0grZC9wRHFX?=
 =?utf-8?B?L1RObm5kbzlyaTNIZlB2OWRjcjY5b2wvRWFnOTZRblh6bVVhVE83bnVYRDNh?=
 =?utf-8?B?MjBMbmZZUjNqYkpZU2hKSEhrdzlyUnFDdG5IeGYyallFaHNEY3NjUnhHWnZ4?=
 =?utf-8?B?VlN6M3QvMTVGZk5teGE4aGcreDJRUU1SK0dIQloybHkwRDh5MjE5bEVQV0hW?=
 =?utf-8?B?cUs0L05EeDNEbEhyWjZMSDhTTGkrcTMvSGNnYkplc3B4c3FZc2UxUmFYdDlp?=
 =?utf-8?B?SHBYaHdHWGZCNUdhNU5HeDF6UWxodEtGYjNDWHd4V0puM05YOHZDR0ptam1Q?=
 =?utf-8?B?ck1iNk9xUzJmR2NUbGtQOCtNT3VZdGFVUDJPcGdRQkZIbkdnVlFmTXM5dXNT?=
 =?utf-8?B?am9RMU9ZNHAwSnZ2anNzZjFDRElHNFU5c2tBekQ4emR0TFdqMVlXYnhNTHFL?=
 =?utf-8?B?QWt4NGk2Q0NTUFhOWnJKOER1MG0wbGwxamY1ajNXNE84ZUdBTGVLaDh6SGpr?=
 =?utf-8?B?WTlQb2FiUjNRRHJKUy80Lyt0Q0pmQitJRFgvdURQMks1RHVXT0pyQXpIOWxM?=
 =?utf-8?B?Z09aSXZxTGZrbThkMjd6YzMwUGxKNDVQOWgxUHhBaXVjY3RWSHZhMkRVbFB0?=
 =?utf-8?B?b1p5QUJyVUhPc3Z4ZERDRnU5aldHQmxBaVJHK2x2ck5zblZGRXU5UWpZYzEv?=
 =?utf-8?B?ZWN4cVJvTEVqQlQwN3RWTjZVOWVNc2hINTF1dW9MWmpOYWRDSXd3WUpoNWJ3?=
 =?utf-8?B?dUpUcUhrejY1aU80U0xEZUQ2eDJ3Tmk1MFBjQUpIWllVQWtheDk2OFdlSFgz?=
 =?utf-8?B?TGlGVkk1Sm1nZVJ1bDdTUk9sd21lQzd5VGxtNW9VZVB5a1kzSUpKUGliV2lD?=
 =?utf-8?B?Wm1VWmlPVlpRdlp4Tk9NZ1NWUlg3NlhHV2Q3T0tkenh5aDZHOGhPelBsWERt?=
 =?utf-8?B?YnV6VnJlV2NybHI5dUtyTlhVb1p2am92RmRiYThNbnc1UUx6ZU5aUklMZ1JM?=
 =?utf-8?B?NFZsOHUrbmQxMVlWRUpNQjE1cFMrYmt0UFUvZUxJVElnbi9jU0NwTjlPeHJQ?=
 =?utf-8?B?bldXSVM2VzJwYy81c1lIejM4M1dWeWRVWFNGRlJZcno2cU5zMjhYSUhMa1RE?=
 =?utf-8?B?NEhZS0JHeEFmbHhPS0lTdDNZU2VKVlk1NkFuZDBOcW5ySXY4R3gxSkJnVGk3?=
 =?utf-8?B?WHp4QktrcE9GZHZySmVIWGRmK3hFYUFWNTlEK0h3TkozdVRmcXVPYWZWTzJJ?=
 =?utf-8?B?QS9PT1BmdW00UVA0b2lMMTd6SDFxcHUzTE0zdUJtcXc2S2RuVVlVTnhoMFlQ?=
 =?utf-8?B?dkxyZDhxbzhJRk5mbWk3cE1iSjJkK2J3RHozb0Zxd1d5R1Q2dlYrWmorTWtR?=
 =?utf-8?B?M0Y3NGdUQVFPbWtGUEVSbmp1b2RhS09SMEpxZURuTzUvZjVoMldudWNHUVRs?=
 =?utf-8?B?QTlWYjlORjdNVVFveXNsTlBQa0RranM0ZkhpbGFZOTE1T1lGWEs4SUQ4YjNX?=
 =?utf-8?B?ZkJxelFEcUFJSmtPODhHVUU2czArYk43ZGFzUlliVVZSNnorMEczODRrZ1ZN?=
 =?utf-8?Q?g0jw1r?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVlSZmJ6UE11anUwMkVmWXE1MU56ekRwbTV2VXZYZDJYbWlKUURHckFVbk1s?=
 =?utf-8?B?U2RPbEN6cDBueEdXcGRTQTFxdG9ORHcrWmZ0a3pBUEYxWlJ1Q3dIc0g4RDF2?=
 =?utf-8?B?am8vQjhxN3lUMmxJM1prcVJXRS9OanRPN1YwdmpvRXhoVlFKU2Zkc1FCeWdq?=
 =?utf-8?B?Tm5LbGkvNU4xa3QzYTllNE1YU3Q0b3Y4TWQ4blJTOFc0bXRPQ3BZVUtNd2U1?=
 =?utf-8?B?VThQSkpzM1E3QTFTMnhWNnZkWGwwYnN0L0dzd3hpMXkrL3hhMmwxOFJEUGlj?=
 =?utf-8?B?aVYxSFNkSnlFSjY5RUYwOTVQSE4vaGxxaC9YMGlPZ3hqdTJaNXNHNnF0emR1?=
 =?utf-8?B?TTJuSlE1T3JRS3FzZmpJd0lmOWJlWWxsWExLZkpqQWxUYzhVaFp5Z3dTVzM2?=
 =?utf-8?B?bVZsdW9UendCdmM1emlVbFlENWNIbFhzNjZveU1DTktkdGY4WlB2UEQ5VEt1?=
 =?utf-8?B?eUJvVFpxRWNCOWhEd0tnaVU4UXBxNTZla3BodDNlTnhwcW9IUGx0Q2tXYzZk?=
 =?utf-8?B?bVdXdmtHcS8vZDNtbnhLWERZNDZLaHI1YzNINHVxTkxTRittZjFrSWxrdnVx?=
 =?utf-8?B?aXFKOXV0SHJ5d1R5ZGZiSUlMbUR5RWN5aTk4ckNTZFZEb28wSnJRUVY0c1VV?=
 =?utf-8?B?RUpOTXNSeXEvNnU4aW9nMDVBMWVrYUczQXNPMVg5cExZYTFDa25TYzZwNzQv?=
 =?utf-8?B?VlJ2TDhUaDZsa1lpWnFJZGJTZ012bkxNMW10VzZPenVhUnpibHZuT3dLbW1R?=
 =?utf-8?B?RUdaalVSOUJUd0lUSVlmbVB4UTg3RlJkaDVVQlBHeXYxQ3dGQjF5eUdtSktE?=
 =?utf-8?B?NGZzQXBhaU5TdEE5Z3BtbUZKc3JvNWZQYndJUkg2bEFJaml6c1cxK211Yzgx?=
 =?utf-8?B?bjRYY0M4d0pjeVlUWkRVK1J3MHdLUEJoNlFjWEUvbDd3RERzMUFNZjZZeHRs?=
 =?utf-8?B?NnVsbDNDdkRnKzdRTDZBYUNlRDdXbjFINmQ5a05ORklGVTdLc1VwRHdUcEt2?=
 =?utf-8?B?VDJMVzZqQ2hDN05NcWFQcUpVdG9ZQmZoZzhhZmE1ZWFwL1FNdGpCaHNiTEFh?=
 =?utf-8?B?WmVsMmhMcktSYjVyamJEUFpjdU9kZU1sOHhaK1VQZk13OUUrejRRK3dKcXhW?=
 =?utf-8?B?Z096eVdwSzJVTWxVZjM3NkF6ZFZNY0VKenJYNng5YzdWSUUxZjF1MVVVbk5j?=
 =?utf-8?B?ejNva3JqMFNHWkhaVHJKeWxTcXBWUVZ1OTJkSGZldUI2U1RoWTNYa05EUGd1?=
 =?utf-8?B?SzVYQUVvTXZvSjdpVlE2dHhHaUM5Wml1VDlMYzFadHo2SGxqVWcxYVYzTzFO?=
 =?utf-8?B?QWFXK3FYUnVhekppM2c1d0VHSEs5RXlUdEtlNGxKNzE4dzIxeUtsdjNMU1FX?=
 =?utf-8?B?Vysxa3dGMjlXZ0JEaDhYZTBKTHUwQm1DVkVLZy9hSjZKN1JBWGsyVDlsT1JO?=
 =?utf-8?B?YWI3SzJaZkZ0emlYS1NqWG0yUmh0cjlyVWNIVkhlVXFDRlltZnBkT0RjS1px?=
 =?utf-8?B?R0pZejczVHJ1RkJNWVFmek5JVUM5eW54Rm1WNW5vZkR5NFloM1hseWRiUWtC?=
 =?utf-8?B?STJUWmxVUml4dlZKQUg3d3YwUi9sRFVRUGF6b2FNK3BaTXBJbDFsWlQvK2NZ?=
 =?utf-8?B?ZnNiNE1XZzRTeXR5empzVnk3clA3ZjgyUnBtM1lqOHB2cjg2ZEo1Mjh1VG5s?=
 =?utf-8?B?SkczSVNFR2F5aWozMllYK2g2Ly9PRWlBUko5Z1FLeUlNSkFBVEVkcmplSlRa?=
 =?utf-8?B?TlREQk5Da05FYStOYWUzUUltQlRKZ1FTaDVZSHdVZ0k0NEE3eGw0Y0RvQ1o0?=
 =?utf-8?B?OEZhUXJxYlJndG1zZHU2YVkzUUpXV0Fsc1JOUjdRYXBpWjZxVnFUQi9HOTAx?=
 =?utf-8?B?VXZjRGRZZDRBQmVvTkhyVmFlKzA4R2F2ZlI3WHpEZnpGR1RDNnJvNU5LdWMx?=
 =?utf-8?B?S09iUmtBMHpkY0NkQnFNRlR6U2RnM1RBZ0tqd3VVT1RrQlNzaFhOZHZTcENr?=
 =?utf-8?B?eWxIVXoyOE5TSVZwN2ZabUtDY0o5ckI3TlhyWmNmMUpIZjg2M2d6OHphbXRa?=
 =?utf-8?B?eWQzZ0g5Q1Q4cis2TTg4SnpGaUhsRTkzdG5KdHpFL0M5MnlvVFh0SGFsRE9T?=
 =?utf-8?B?M0xJd1RZV3hZTWFUdCsvTHNPN1hpaEV0QjMrR3JzdVF2WDRLMFhUbENDcmFT?=
 =?utf-8?B?Mmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE4414FEC4CA86449BE577E1147BDFB8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55213fe5-b9b9-4350-0519-08de377e39cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2025 23:54:00.8043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mxgibOPHn3q6tIxRcMwIEGXcEJnueoXDb7deIlsrpYernxD8lMnl/n+5dydRH+HKazbrKZYYDxfE0QXKsxs+3YBgYl6M4kzuuPZAD5ZCjdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6477
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTEyLTA5IGF0IDE3OjQ5IC0wNjAwLCBTYWdpIFNoYWhhciB3cm90ZToNCj4g
SSB3YXMgdHJ5aW5nIHRvIHRlc3QgdGhpcyBjb2RlIGxvY2FsbHkgKHdpdGhvdXQgdGhlIERQQU1U
IHBhdGNoZXMgYW5kDQo+IHdpdGggRFBBTVQgZGlzYWJsZWQpIGFuZCBzYXcgdGhhdCBzb21ldGlt
ZXMgdGRoX21lbV9wYWdlX2RlbW90ZQ0KPiByZXR1cm5zIFREWF9JTlRFUlJVUFRFRF9SRVNUQVJU
QUJMRS4gTG9va2luZyBhdCB0aGUgVERYIG1vZHVsZSBjb2RlDQo+ICh2ZXJzaW9uIDEuNS4xNiBm
cm9tIFsxXSkgSSBzZWUgdGhhdCBkZW1vdGUgYW5kIHByb21vdGUgYXJlIHRoZSBvbmx5DQo+IHNl
YW1jYWxscyB0aGF0IHJldHVybiBURFhfSU5URVJSVVBURURfUkVTVEFSVEFCTEUgc28gaXQgd2Fz
bid0IGhhbmRsZWQNCj4gYnkgS1ZNIHVudGlsIG5vdy4NCg0KRGlkIHlvdSBzZWUgIk9wZW4gMyIg
aW4gdGhlIGNvdmVybGV0dGVyPw0K

