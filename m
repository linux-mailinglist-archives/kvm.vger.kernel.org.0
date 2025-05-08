Return-Path: <kvm+bounces-45829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 30921AAF0A7
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 03:33:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41C761C24838
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 527291B532F;
	Thu,  8 May 2025 01:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XhywrtKw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A093519F40F;
	Thu,  8 May 2025 01:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746667984; cv=fail; b=tXTMd0g2gujNkz4tWpZd853HZ/UiI7IyL52VVsQC28ToWGK2V7fbWlCRm7ooU7WDktrgkwg23Fmb/KLlh3OxhU4LHy/PC0VnWfU5aCAL7Ug64I5xdWdQQ6RsmkNWyk3NSzzMCSqmuEucthKk3z8VJh/0diFmpNoZ0Kq3UAxyz0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746667984; c=relaxed/simple;
	bh=WyJJNjyo12c007kqovDZGG/EoOX1ChoigqMhfITlLrc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=assqhSjNiINU/fKgZM70z89wv4TiRgwe+eNSwgesP0/glnNvjdXF7ZtQx0jQdUfcmMAeWER1x+RtI67p6b3lTF7OXX6VASDZDgiSuTGdChtzAAQjXiHkdHU++mEkev/F3ANEnU/HraE6a7Psnn5d4ygpBfRCC+MCr8C7z+2lsd4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XhywrtKw; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746667981; x=1778203981;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=WyJJNjyo12c007kqovDZGG/EoOX1ChoigqMhfITlLrc=;
  b=XhywrtKwD7Vl3n1wz861y+0Nl/uhHM9CLIOGYWdPoq9UaSj/1XxNruhb
   rt6rgKWXDe2nw8c6yzVZPvzSpvZ8B4vBpqG6D5LQ2P7BS7ccmtYIf2xTz
   /xtU90yMc4dINbsuFKjvnFeGz4FkIg0ZUFHeVLXbcw+m0lpN/wpJbMKuH
   4tL9m0F4AT+Wen4lFeLFN2iGeGjvy9V0igRwA4M5R35bVBXUNPz3opDkK
   tpeuaAsdLkAReswEwGKm2O6lZVbRi+Yz1JdIO5wGHIKng1+V00teJy3rb
   cXHNp1EWc+awJk26n7pvSD0PxjpQLed96G9Q3YBbQ22FOm7ooq/pVEKyV
   Q==;
X-CSE-ConnectionGUID: MJDw/1Z+SCKNGpNB0+iS0w==
X-CSE-MsgGUID: oQzuTIlzRcyBqoDWwAs17w==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="48575291"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="48575291"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 18:33:00 -0700
X-CSE-ConnectionGUID: i0zhfwlERAaQYOgyigSvNQ==
X-CSE-MsgGUID: 12702So7S6CYeVgofldiIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="141092829"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 18:33:01 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 18:33:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 18:33:00 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 18:32:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ApATh4yckwlkSHahaHi6eI/mZpNb9oqGgBda50HcJazRL4hmRz4NSymBF/H97DnETj4+u6EheAqblNfWoIH/ZkiIMTbv3ll3jQAiqRI7ujx5Q7QANjwsQYkWREGOzwkAYCDOJI1QC+MnFbdqhxR4iADim8PaS2rQv4/XcZWW+jrA6Z8+ongGL1AfXPwwfrCa4VPYJDTFdm+WOhXR8KzyirtydYB+yHJOBEiirBoU9czfpcgwO6lOyKlzle7nem/y97POjQ1hIDvxEOEnm/iGE4TbPYX5RKLBrGVxDv53McihuGK+UnDmIcttsrPhkxq0/lCIz4g5HH+VzCjuCeX+2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NKnTZdjT4sWpNilw9HM4X3YKLTZ3UWz5MYmht7HWjA8=;
 b=H4Bnw4HJiOxTGQbxO8UmtbJgzKrt+mpkq8TLP+/JRF7kAKeDfuymC03cR98sLxfCQ592oLRrWLZjhwJHJ6P4h0SGPf0wlsIUU3283yN4IfZx5Ox+VxumtsW9kqt2algaie4TbXZmHpyflhDwgHV1X8D8iOxDYW0kbjqoL8xrJb/OgBLpCkA2tWZ4dHA157MFkHZyzfQCvz/udAO/NrcVz+/5RLYY2zQcZNtDJzC6FAC3ywIDKHQ7jZYWd8XqbtIUpwnxPSohtDItuv+QAD6/5wkS44WkeNf/pWpqdL7drFXArxuLQdVNwURREOw+8pe333Vwihf24LbRbGofp5JrXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB6939.namprd11.prod.outlook.com (2603:10b6:930:59::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.24; Thu, 8 May 2025 01:32:09 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.020; Thu, 8 May 2025
 01:32:09 +0000
Date: Thu, 8 May 2025 09:30:04 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vbabka@suse.cz>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pgonda@google.com>, <zhiquan1.li@intel.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aBwJHE/zRDvV41fH@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030603.329-1-yan.y.zhao@intel.com>
 <CAGtprH9_McMDepbuvWMLRvHooPdtE4RHog=Dgr_zFXT5s49nXA@mail.gmail.com>
 <aBAiCBmON0g0Qro1@yzhao56-desk.sh.intel.com>
 <CAGtprH_ggm8N-R9QbV1f8mo8-cQkqyEta3W=h2jry-NRD7_6OA@mail.gmail.com>
 <aBldhnTK93+eKcMq@yzhao56-desk.sh.intel.com>
 <CAGtprH9wi6zHJ5JeuAnjZThMAzxxibJGo=XN1G1Nx8txZRg8_w@mail.gmail.com>
 <aBmmirBzOZfmMOJj@yzhao56-desk.sh.intel.com>
 <CAGtprH9fDMiuk3JGSS12M-wFoqRj+sjdtEHJFS_5QfKX7aGkRQ@mail.gmail.com>
 <aBsNsZsWuVl4uo0j@yzhao56-desk.sh.intel.com>
 <CAGtprH-+Bo4hFxL+THiMgF5V4imdVVb0OmRhx2Uc0eom9=3JPA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH-+Bo4hFxL+THiMgF5V4imdVVb0OmRhx2Uc0eom9=3JPA@mail.gmail.com>
X-ClientProxiedBy: SG3P274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::16)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB6939:EE_
X-MS-Office365-Filtering-Correlation-Id: 700e6712-ca32-43e4-2350-08dd8dd0265c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y0pPZlkxZ2xRNzhTTFJWaDZ6RmovNzdUL2h3bUhOVUl6MUkzeWhuN3JCSG1D?=
 =?utf-8?B?Uk9DWGxXQmoxWXFCd2hPam1PTlBLOGo1NFJNOWIwYi9VbWIremU0R1o2bi9k?=
 =?utf-8?B?dlRSMkZ4V3I3cFBTR0w5cHJrTWMxc3Rvd2sxdGNtOUs2eEhBNTQzMVVxMDJQ?=
 =?utf-8?B?WE5MTTJlNjl4SkwzNDFZM1RDam5wVjhlVU5VdHRlaWRzMm9iei9XVHBEanNx?=
 =?utf-8?B?dDlralRWZ01INzZDclJvRHROUkR4QzIySUVuNVRKTzVmemFjUDJRRVNrcHli?=
 =?utf-8?B?NE82cmdIYjdQNjRpanRsL1JLUkdJa3paL0Q3MlBOK2JhbDQrVENoM1VPREhz?=
 =?utf-8?B?LzI4eEtpMHFlS3lHMVkvU3VSYmtRZFA1WDBzcjFKKzIra1B2UUZGdEJHOVZD?=
 =?utf-8?B?dVNkaHRBY0NQcDB6RVdtOFNRcEtrM1F2SGV5NDJJbnpJNUJiRzZzQStKblNJ?=
 =?utf-8?B?djdmOW9GQVdVZjJsY3k4OFpyS3Via1JjWE5wRGlyY1Mwd29KZUY4ZW9USlZs?=
 =?utf-8?B?ZFZNR21OQ0hxYmNVd3YyQ3A4SWs4TzBuNEFtd2UyK0h6aExKbHFFcHJVNnFE?=
 =?utf-8?B?bzFpZ2VIMlUwNE9jdVVIVWJneDZkdnZraEhzZWpHMUl1U21yQlhpOFp4RXNy?=
 =?utf-8?B?b3VscS9oTHhjSU1QSEpWcUJVYUtmM0JtR0ZaMzhiVFN1a3F2MEZSOEpyb0NE?=
 =?utf-8?B?YklSSUVUSjlRUStrbVdmSHAvbTB6QmFLYjl4dlJpL1Bha3QxY0NzU0d1eWwx?=
 =?utf-8?B?UnJxa0Z3M0R6WWpjWGRLY2M0UDFXajlJZUQwNzVBOVlYcW03bGZ1cTRla0d4?=
 =?utf-8?B?KzVjZGJuTDM0bmhnU1BxM0haajRwYmlwRmJuMHJ1VHJqcVRzTmJ6Wmc5ZFJi?=
 =?utf-8?B?V2l0WDlSWkdpQUd4UElYbEdvbFVLMHJwY0U3eGZzNUFtbXNXbUQwaWFka3BS?=
 =?utf-8?B?T3RHV0V3bXAvYVJHMlpJQVl3RVA3WmhPUnl3ZEUyWU85MXV1dVovckN5NFRp?=
 =?utf-8?B?ZnNrUm9OT3VtQXkzMHdlZ3NkSTFWODJlcFNDbkxiUkRweDJ2WUtHSEVVMjFU?=
 =?utf-8?B?VTRKWk9EYXlLTDBPUS9jM09RUVJXUkJyaUZsbkk1UzlnUnM0bTR3V3c1Z3Bn?=
 =?utf-8?B?bVFxeDU3ZVY2WXkxb0Yzdmo3M2dHcG0yS1F2clBBdkhCbG1UNEdUYm1hT1V5?=
 =?utf-8?B?eElqN3BDa1gwY0taVVF5VFFPdWR0NEFqNk0wT0JscUNmY05OTXNWL3ZpTTJS?=
 =?utf-8?B?TEhFVi9KQVY2Zno5dGxESm1yMGxaYzk4bmFsL21RMjROOUV2RUxiT0xyY2la?=
 =?utf-8?B?c2N2ZzBudkZ4cEduMitHNzU3WUpNZXBWbU5ZNVhYeElLbGtBZk05c3Q0TGpI?=
 =?utf-8?B?c0Qzd0xLQnJuVSttWi9nUEpJdkV3SU5MeXYyQUZsOGJQMXpibzg2cnNGaEtX?=
 =?utf-8?B?TTRDS0huV0FxYXFaNlNqNGxTYXRLWmZ4Mkp5cUFic1pLM3pDMUNHQkVvSHJB?=
 =?utf-8?B?KyszSGs0MzA3R2tjVm9XdnR3MUJsbEltSFZsUkVDYytxTThzekFLYnBmRm0z?=
 =?utf-8?B?YzdDVHB6eDRWR1hWMHYrV3RGb0p4UzRkMjZjZWpFczZOdEtyYzkyaElCTTRR?=
 =?utf-8?B?d0ZsSmJwVW1GL0NJejBoazR5WnExSys4KzF3OE5iZ3FCUmFpemVXVlVtSkRQ?=
 =?utf-8?B?S2lUN2oySjFrd21kQ1NFTHRsRUl1RDdjK1A5T3FpTWw0R1lFY0tNTUlvVUx2?=
 =?utf-8?B?VFhnWkJRTUdDME1wejJqYWxWQjB3NUZibW11NGx0UHpnNmI4a0U1NEdZeUov?=
 =?utf-8?B?ODRoLzgrWnNVbmI4NUVSWGdhdmt5U1BRYnBxbDc4S25PeldMc0pDL0RscGcr?=
 =?utf-8?Q?ViBIxnkT8XDhE?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RExrY3d0allFTkZjeklyVlpwR2JjeElQVmJRSUdTS2NteEt4S3l0VEhhSlQ0?=
 =?utf-8?B?andqbGZacGgxSTRIWGQ5NmViQUFqZGdUNkxVWHBodlFycTIwYVNvVGVUWkNm?=
 =?utf-8?B?ZmpVSGd6K2lmYnVHNUFXbmZEMmJxa3g0N3VjZUxZajkwTGNTK09sMXg5OGJB?=
 =?utf-8?B?eCtiN0VtQ0J3SmhkNnJWM1BaWGdPUk1PNm44Vlg2Zk5namY1bUV3UFFaeFlZ?=
 =?utf-8?B?WnpUVzQ1TjEyK0hhSlVPZS9rZ2JoZXlQd1QzNTRpNmwyZEE5TTJGN1RDelRp?=
 =?utf-8?B?SXB5WDlsWWI1S2ZzR1dkTkI3MUVQQTNON0s2bFh4WWZRcDRwblYwQnZ5WWhI?=
 =?utf-8?B?VGlSNERkazJOaW83Q3FlNmNUUndQREgxcGtxT0o3NndYOUE4M1JXMkdqdmtV?=
 =?utf-8?B?cDZ3MlNhaGJRbUZXZmQwb0NTUk05Q05GU0lKQnFqNzVZTGYrQlVBUUc4VG5T?=
 =?utf-8?B?Nld2TE9BRW5FQmtsc2FNSEFYcVlsUWg0cTZRRyswWGEyMUtrQnAwQ0VsM3Uy?=
 =?utf-8?B?bFFHUURxbWVldjNMdUYyVFo3UVZ2Y2NPOVR4L2oyeWVCWEhJSjY1VzRKelZ6?=
 =?utf-8?B?VlRKUXUxNWYwdjBoV1hXcGFoRXBxZzJaNHBvNEtqczk0UUNsTTVtcVc5aWFK?=
 =?utf-8?B?cE5FeWpVTTc4dStPOFNCSkZOWlcwWkJxSGZhZDIrRlVjRWcxWUJac1g4SzU3?=
 =?utf-8?B?UGsxSDlVTmphUkQwSjNQcGlGSDFyV2FzYThoQkNZWGt2WktXMndscE5uNjlw?=
 =?utf-8?B?S053Qk1nVFAxZDkzR0E5S2JWdVRuaUNPbXZmMXgxQUlLclNURHFPMnRmZWJD?=
 =?utf-8?B?UDEvOVVtSGRXRFZIdjNvL0J0M002WWdUTEQyL2Rjd3hLL3B2UnJOMDk1bVRQ?=
 =?utf-8?B?V1lUa25jVG4wV3A2TnNQd1lJWVZsMlFMc1o1S0lNZSt4YUZ3UDNmZ0pOeW9k?=
 =?utf-8?B?WDlGRjd6ZDhGRWhreVZuWmRzTXk3N1RodnhtL0xaaWF2dWgzNWh2VVVtd1ZR?=
 =?utf-8?B?MStFTmlUY2V2TG9FckVsWXJsd2Z1ZkdraFJzaHVWOGZuMFYwWlo1Zis1NzVz?=
 =?utf-8?B?QXpGSDBid0wwTjAxZ3M1ejc1MVF6SVNpVzNySGhJUW5adCtUdmJVdCs5alUz?=
 =?utf-8?B?ZDNxOVAyS0l3VHdQRDl1NmMzYTk0dTBBZ2RrU0xKUmVXLzNEUm8vKzcrcnMw?=
 =?utf-8?B?ajNFUnF1Q1VNVXNlaFRDZlFxMVlMWHBkOTNkb003L21zK294QlBiaWpFTm9F?=
 =?utf-8?B?TVVIdjh3NHJuQWFpd1pNWUdOWjhhZDR2VVVSbHcyckdTN0V1MjBxaEVIRGt4?=
 =?utf-8?B?K3FISWFkSEVFbFdTOWRZck1sbnl5RTg1NzIxcUtNVlNLMGhzdHJHV29STTcx?=
 =?utf-8?B?anhldDR6aTlwYVFrWlIyUEV5bENieDN0YTljQXI5MU9ta0Zoc05OdmljQVRy?=
 =?utf-8?B?cVNXSzQyL3U3Uk11TzFpMWt0VEkxczNKUkdWZ2c1NGJmRmwweGRGN3dJT242?=
 =?utf-8?B?cGxuQzk2RWFVQ0gyMld6SUxZTEZvbVR4RjVSYzQ5U1J6VG5sWmkwZWFsekR6?=
 =?utf-8?B?Z0ZmVVMwUFFIM1BsWGhmUE02NXBnZ1Z0eDlUK3hXc1VkZkduSlRkQStTZWsw?=
 =?utf-8?B?RitLM0FkZ3gxU1pUcmF4RXVXbXRWWmYvYXIrQjNBM2V5UHQ1c1VtcHZSMHBM?=
 =?utf-8?B?TlQ5WEpzMDVicWgwYndwcVA5bElnVXRTMzA5R2lDTUVPOFpFKy9wK0lHdDln?=
 =?utf-8?B?b203ZGtyTjBGVzVPK2tHVndEZWYwK25JelZDSDJXbFRpc2dwL2FPQ1N6S2Rj?=
 =?utf-8?B?NzRPeUpYcUZSUFVXbm0rU0RwSW00eGY1QjVQVmVPYkdyWVZqS1Z6ZGhmVDJG?=
 =?utf-8?B?MmNuS1U0cmRTUWtvT0tlNTdVZEthNnAxcklQM2wvclV6MW1Hbm9kclNDbWFC?=
 =?utf-8?B?SGlaTllGTmJUbml4R3RQMFN3ZlpDUmVVM25IRVBWb3lYZUpFSzNJVlhjRTlL?=
 =?utf-8?B?czdYWUZ5RXE1VUkwNURiRlRCT1V3ZlNYYVhYbm91dnRDczFGTE4rRUpHUC82?=
 =?utf-8?B?a3k0bGFqbks2emN6RUJkeDNEVFIvSVdLeEMzSHhsVjY4LzA2Z1JXNXljQ25Y?=
 =?utf-8?Q?RC1Wdt3O5GxRbGs4D2yEw0Ek/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 700e6712-ca32-43e4-2350-08dd8dd0265c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 01:32:09.4309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ExrJOpDRS5hvoONGEod1JJ+LF6waX8x0iqQNnEmT+RYlC5ibBYw0RLJmNQIgFpD6qo4WE5CkuSTMg2IDYIZTVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6939
X-OriginatorOrg: intel.com

On Wed, May 07, 2025 at 07:56:08AM -0700, Vishal Annapurve wrote:
> On Wed, May 7, 2025 at 12:39 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Tue, May 06, 2025 at 06:18:55AM -0700, Vishal Annapurve wrote:
> > > On Mon, May 5, 2025 at 11:07 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > On Mon, May 05, 2025 at 10:08:24PM -0700, Vishal Annapurve wrote:
> > > > > On Mon, May 5, 2025 at 5:56 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > >
> > > > > > Sorry for the late reply, I was on leave last week.
> > > > > >
> > > > > > On Tue, Apr 29, 2025 at 06:46:59AM -0700, Vishal Annapurve wrote:
> > > > > > > On Mon, Apr 28, 2025 at 5:52 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > > > So, we plan to remove folio_ref_add()/folio_put_refs() in future, only invoking
> > > > > > > > folio_ref_add() in the event of a removal failure.
> > > > > > >
> > > > > > > In my opinion, the above scheme can be deployed with this series
> > > > > > > itself. guest_memfd will not take away memory from TDX VMs without an
> > > > > > I initially intended to add a separate patch at the end of this series to
> > > > > > implement invoking folio_ref_add() only upon a removal failure. However, I
> > > > > > decided against it since it's not a must before guest_memfd supports in-place
> > > > > > conversion.
> > > > > >
> > > > > > We can include it in the next version If you think it's better.
> > > > >
> > > > > Ackerley is planning to send out a series for 1G Hugetlb support with
> > > > > guest memfd soon, hopefully this week. Plus I don't see any reason to
> > > > > hold extra refcounts in TDX stack so it would be good to clean up this
> > > > > logic.
> > > > >
> > > > > >
> > > > > > > invalidation. folio_ref_add() will not work for memory not backed by
> > > > > > > page structs, but that problem can be solved in future possibly by
> > > > > > With current TDX code, all memory must be backed by a page struct.
> > > > > > Both tdh_mem_page_add() and tdh_mem_page_aug() require a "struct page *" rather
> > > > > > than a pfn.
> > > > > >
> > > > > > > notifying guest_memfd of certain ranges being in use even after
> > > > > > > invalidation completes.
> > > > > > A curious question:
> > > > > > To support memory not backed by page structs in future, is there any counterpart
> > > > > > to the page struct to hold ref count and map count?
> > > > > >
> > > > >
> > > > > I imagine the needed support will match similar semantics as VM_PFNMAP
> > > > > [1] memory. No need to maintain refcounts/map counts for such physical
> > > > > memory ranges as all users will be notified when mappings are
> > > > > changed/removed.
> > > > So, it's possible to map such memory in both shared and private EPT
> > > > simultaneously?
> > >
> > > No, guest_memfd will still ensure that userspace can only fault in
> > > shared memory regions in order to support CoCo VM usecases.
> > Before guest_memfd converts a PFN from shared to private, how does it ensure
> > there are no shared mappings? e.g., in [1], it uses the folio reference count
> > to ensure that.
> >
> > Or do you believe that by eliminating the struct page, there would be no
> > GUP, thereby ensuring no shared mappings by requiring all mappers to unmap in
> > response to a guest_memfd invalidation notification?
> 
> Yes.
> 
> >
> > As in Documentation/core-api/pin_user_pages.rst, long-term pinning users have
> > no need to register mmu notifier. So why users like VFIO must register
> > guest_memfd invalidation notification?
> 
> VM_PFNMAP'd memory can't be long term pinned, so users of such memory
> ranges will have to adopt mechanisms to get notified. I think it would
Hmm, in current VFIO, it does not register any notifier for VM_PFNMAP'd memory.

> be easy to pursue new users of guest_memfd to follow this scheme.
> Irrespective of whether VM_PFNMAP'd support lands, guest_memfd
> hugepage support already needs the stance of: "Guest memfd owns all
> long-term refcounts on private memory" as discussed at LPC [1].
> 
> [1] https://lpc.events/event/18/contributions/1764/attachments/1409/3182/LPC%202024_%201G%20page%20support%20for%20guest_memfd.pdf
> (slide 12)
> 
> >
> > Besides, how would guest_memfd handle potential unmap failures? e.g. what
> > happens to prevent converting a private PFN to shared if there are errors when
> > TDX unmaps a private PFN or if a device refuses to stop DMAing to a PFN.
> 
> Users will have to signal such failures via the invalidation callback
> results or other appropriate mechanisms. guest_memfd can relay the
> failures up the call chain to the userspace.
AFAIK, operations that perform actual unmapping do not allow failure, e.g.
kvm_mmu_unmap_gfn_range(), iopt_area_unfill_domains(),
vfio_iommu_unmap_unpin_all(), vfio_iommu_unmap_unpin_reaccount().

That's why we rely on increasing folio ref count to reflect failure, which are
due to unexpected SEAMCALL errors.

> > Currently, guest_memfd can rely on page ref count to avoid re-assigning a PFN
> > that fails to be unmapped.
> >
> >
> > [1] https://lore.kernel.org/all/20250328153133.3504118-5-tabba@google.com/
> >
> >
> > > >
> > > >
> > > > > Any guest_memfd range updates will result in invalidations/updates of
> > > > > userspace, guest, IOMMU or any other page tables referring to
> > > > > guest_memfd backed pfns. This story will become clearer once the
> > > > > support for PFN range allocator for backing guest_memfd starts getting
> > > > > discussed.
> > > > Ok. It is indeed unclear right now to support such kind of memory.
> > > >
> > > > Up to now, we don't anticipate TDX will allow any mapping of VM_PFNMAP memory
> > > > into private EPT until TDX connect.
> > >
> > > There is a plan to use VM_PFNMAP memory for all of guest_memfd
> > > shared/private ranges orthogonal to TDX connect usecase. With TDX
> > > connect/Sev TIO, major difference would be that guest_memfd private
> > > ranges will be mapped into IOMMU page tables.
> > >
> > > Irrespective of whether/when VM_PFNMAP memory support lands, there
> > > have been discussions on not using page structs for private memory
> > > ranges altogether [1] even with hugetlb allocator, which will simplify
> > > seamless merge/split story for private hugepages to support memory
> > > conversion. So I think the general direction we should head towards is
> > > not relying on refcounts for guest_memfd private ranges and/or page
> > > structs altogether.
> > It's fine to use PFN, but I wonder if there're counterparts of struct page to
> > keep all necessary info.
> >
> 
> Story will become clearer once VM_PFNMAP'd memory support starts
> getting discussed. In case of guest_memfd, there is flexibility to
> store metadata for physical ranges within guest_memfd just like
> shareability tracking.
Ok.

> >
> > > I think the series [2] to work better with PFNMAP'd physical memory in
> > > KVM is in the very right direction of not assuming page struct backed
> > > memory ranges for guest_memfd as well.
> > Note: Currently, VM_PFNMAP is usually used together with flag VM_IO. in KVM
> > hva_to_pfn_remapped() only applies to "vma->vm_flags & (VM_IO | VM_PFNMAP)".
> >
> >
> > > [1] https://lore.kernel.org/all/CAGtprH8akKUF=8+RkX_QMjp35C0bU1zxGi4v1Zm5AWCw=8V8AQ@mail.gmail.com/
> > > [2] https://lore.kernel.org/linux-arm-kernel/20241010182427.1434605-1-seanjc@google.com/
> > >
> > > > And even in that scenario, the memory is only for private MMIO, so the backend
> > > > driver is VFIO pci driver rather than guest_memfd.
> > >
> > > Not necessary. As I mentioned above guest_memfd ranges will be backed
> > > by VM_PFNMAP memory.
> > >
> > > >
> > > >
> > > > > [1] https://elixir.bootlin.com/linux/v6.14.5/source/mm/memory.c#L6543
> 

