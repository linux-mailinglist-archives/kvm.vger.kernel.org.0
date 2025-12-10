Return-Path: <kvm+bounces-65636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B606CB18D6
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 01:53:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F875309F833
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 00:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B43C1FF61E;
	Wed, 10 Dec 2025 00:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BVM/QJqH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454791E1C02;
	Wed, 10 Dec 2025 00:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765327995; cv=fail; b=pIh1GDqBMSVT6mt9IZYG95smXxsVvfkrXhjTsedcZ8GJYjUrE3Dap2KhbQj1MKJ8DJRwGR+LJmBGFirJyAkRXu2sqkWnJFQW4rNK7rUsyFOSkg25/U7tvQJJr6S86EBGTWpMFIOjVMSnjC+A1Q2yUx8V3LihfJE2ez0L/PIA5io=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765327995; c=relaxed/simple;
	bh=cROYyFjFIaZbviWLyV6KPpLN73JkETzQsNyBM6ePCik=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AkT8d0RQQKn+vd76HvQqOFBJuKfqwRI5yQ5B5ncLycGefXwKS4jcBx6qSpzIdSU6FSMn3XxNusXrNe8KLJW1skJ0nfkb2IzaDuF114SBYq1wW8SKPRVg1v8/a+nuxi9e4gq4gNnuVUb6cIPER9YSxDEaGNfwFQWIXkUlgFzYyB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BVM/QJqH; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765327993; x=1796863993;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=cROYyFjFIaZbviWLyV6KPpLN73JkETzQsNyBM6ePCik=;
  b=BVM/QJqHNBDZPw0a8mDgpSsLQ0Hyw/o9VlZ22mLF2GM7/Z6qcaJPYYKH
   94/Hf2bSncoqHMVFA7BoeyzxU5O41tD4lpayPOZ/pziONyY0J9QtIrbCz
   gnwu27M/Zt1Q+cS0t3hhr417RswEl9HMM7RU6t8gSCN1Or+h5qaCmeXLc
   n420zNSGKpFofynRtY3btffE94EUOOkFK57PBfpD9TpbPQ5KRMgzYMWpT
   QYix7UStNP2V/ydz9hGNOidd4T/4GqmKW4PBKMRoxqH2e4ZLGBHNIYOYo
   1EhAudy9jaGSKOVvZ52vQLZOQwlCQ8iFdthPnaWw+Z6HR+ew16kAiowDB
   Q==;
X-CSE-ConnectionGUID: lgKzC3gVSROmGexfoGRT3A==
X-CSE-MsgGUID: k1S3Wl5kTIKX/HezHX4Jkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="67464108"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="67464108"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 16:53:12 -0800
X-CSE-ConnectionGUID: hCAZaMF/T8+Cd2ykfzHTnQ==
X-CSE-MsgGUID: RWx/nJ0mQoWucUPvuy/ksw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="197143386"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 16:53:12 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 16:53:11 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 16:53:11 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.55) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 16:53:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vYJgsXSm3Dj/fu0HsstjJIWq8cQVyQ4zBIh2tEi6gclTmwafHogvodbfBWaOlISV0bEav9bxPGI7egopjx5YpWDXnj2a1aSMdrCQOBvBItWhdWzQnU7L3KiAJqDYLU3ituPMA8QPr7CB6djJwhXoxnEtqDKerlTCVXo2VrvAeNqoaZQTA2Nx1NL+3RjuJDsW34Z5+7w9YzLyrcRWlg17/gWNJpk/XoYqcu+qETSazB8mmohEkkPHropuT41MWyPu0jOeKSXdloR7gKFrWFZTKT4gzVrfY3UOgX+/SEMUZi3672xAuQWaUytvfdyypwt172pGoWu6QE/BLPH5utHWjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hIHxjOQ47Q7VbvM1q1044AeBhguMlc1qridDDDfT/GA=;
 b=KzvemiCxKlQSCULqUmcOvcyS6ypo0gJKKTz6TRN/5/hbKXxc4vFx0s+N+5M3+HAunLUiuP5lSq4IJ5AvGNdjv6+f2AJxDsXCjAyEg0xS0HsJKNdmtPuVqUVb6dqBDfdHP6cm0zs3qiNMc9q4/ZC5kbcpLjBE8878WtWrErNQMNKve8UaRTg2qNOMWTQAr75Fas9+8CsPCkg3s6otFVnmC49pX/Ftr+YUp0B/FteGDiCo4hh3PRY66mdKsSKNuAvffaz8ja4udnxrsoLhf0CuHu+Fo1B9fAghc1XlJacTPZ0KJMy9ulVg25XAuANrX1bzoLzbg1U86uwenn3VoDrdLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB5134.namprd11.prod.outlook.com (2603:10b6:a03:2de::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Wed, 10 Dec
 2025 00:53:08 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 00:53:07 +0000
Date: Wed, 10 Dec 2025 08:50:44 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sagi Shahar <sagis@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "michael.roth@amd.com"
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
Message-ID: <aTjD5FPl1+ktsRkJ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094333.4579-1-yan.y.zhao@intel.com>
 <CAAhR5DGNXi2GeBBZUoZOac6a7_bAquUOzBJuccbeJZ1r97f0Ag@mail.gmail.com>
 <5b9c454946a5fb6782c1245001439620f04932b3.camel@intel.com>
 <CAAhR5DHuhL_oXteqvcFPU_eh6YG38=Gwivh6emJ9vOj5XO_EgQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhR5DHuhL_oXteqvcFPU_eh6YG38=Gwivh6emJ9vOj5XO_EgQ@mail.gmail.com>
X-ClientProxiedBy: SI2P153CA0014.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::6)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB5134:EE_
X-MS-Office365-Filtering-Correlation-Id: d653e047-7f88-4da1-0bbb-08de37867bee
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?c08xN25qQmF3L3VBaVRnSDk1V0haVUpLQlBmRTlNdnpZWlVCMkJVZXBkU0RW?=
 =?utf-8?B?YWJVOFBGb0ROc2RuZDk5UzgvbHdkUnJVa3RscnNFSlJYL1pPSXoyaUNtZi9K?=
 =?utf-8?B?Q0FmcG54N2NqOGFiS3N1Zk53VWRhdW9HM21xWjlqakJYdzB5bVNGV0V3d2Vm?=
 =?utf-8?B?emRGUzZnNVgvSWkrR2NUNUhoTlVrMEovcElkbnZMZlFobDdvd0NaQWZaWlor?=
 =?utf-8?B?cVVnY1VxRG9xdE1SdWU3dytKMjFxUHJYRjBWbFBkUDRCUVNDamJ3S2dVazlH?=
 =?utf-8?B?Q1BvYlphcDZQck9wMjdkeUVZZkdLbXlsRWpXb1kzaGFkK3k3YjRBZ1ZqS2Zz?=
 =?utf-8?B?MERtQkY1WVdVeHZjU2Rpd0JJcDFoQ0ZGWnN3QUptaWJoRTJYbWxLMytzM2pL?=
 =?utf-8?B?alErOE0zajFMYk9HY0M1QWJId2pEK2kvWUlTMzE4SlZZRjBSNFdOMVFzRno3?=
 =?utf-8?B?QTlyZXg5aU9NUjRhN2pCTDF0MGJWMklpNjFYcHAzR3pFSnprbTZzdk5FNW9P?=
 =?utf-8?B?RENwVkpYR1FkQmFsNHlKSHJja1I1WWgxUy8wUnFuY2JwUE1FZlRVVS82bHVS?=
 =?utf-8?B?MkhlUGNpdm9TS2Y1Rkw3Qm5qSEtKNnROZFhySWt4a1B0WVQwdWFsREduZktn?=
 =?utf-8?B?cDd6YTZpSkJoR3dXdHI5U0J2U0RVd0pvUDV1NDVSVmplS1pFMkJCRXF5Z254?=
 =?utf-8?B?amdCVFV5aWV1b0xPR1Z1d1R6eWxMcW95d2tKUVQyMGhrN0FudTcwa09Fc2c2?=
 =?utf-8?B?U3ozbWhEeTN2YXptRjRjUzZ0RE94SkhMbkFpbzNTcjVTYlIwcHkxK1dEa1E4?=
 =?utf-8?B?a2Fudy9lT3NnOTRDUnhPZmdPYzdLYUhYbkRCTHEzYkxvVm1Eckx6dEwra2pE?=
 =?utf-8?B?VUJZUHEzV2RodkJtd1lxV3lZS01TbzBaMFlQRG15N3NBcXd6V0FvMkxqNmRv?=
 =?utf-8?B?d0hpWkZrU2oyeGluWUhMNHpaZlFEUnpiUEF1cUVNSXZuMkpSbTNtdXhYK2VT?=
 =?utf-8?B?cThuTEdNRUw0MCtscjZjN3FSdjZ6SnB5U3RXZVNzKzdURjFsN0Z3emQ0eXoy?=
 =?utf-8?B?ZXhZWFJKY0pSeTQ5TDdWUlBtRE5vZmFjeDN4aGVQT2h2NU5PWVVtZ29VWk5o?=
 =?utf-8?B?VFNMYTVXOGJBYmxMNjQybTU1bE5udkN2YVlSVllEak9iQ0k4TkxKRTF2SGxO?=
 =?utf-8?B?dnRJaU9nRm41L1JGR1gxcGYxaHNmb21ieUl4UDl5QmViSll0NHpDZXVkazZi?=
 =?utf-8?B?MlBxWUg5d0NiTGxmQnVLVVVZbitEK01KdldhMHNGSmp4UHhnUS82b3ZuQkQv?=
 =?utf-8?B?U2JBSnFydUkvb0xjSlNnUVlHQW9IelpHaEQxTkVoMWpHeVRGREpPamlLVEpB?=
 =?utf-8?B?Sm9TTGg4dWloZTBjeGpnNWNNYis5cy9XMWRDc0xKRUk0Wjk2TUxtRzhSU01G?=
 =?utf-8?B?bExFcHovUVo5RTFPTEtMWWsxT1ZEOHE3ZGJDbXRtQit3eGY5eUxGelFYWFp3?=
 =?utf-8?B?Y3dMMnVlZHl4NXd4a29weEZmc2RHOExVdC8vZ2ZZZnNmNU55d3pBejZCM0wx?=
 =?utf-8?B?aXAyMWtCNzh4SmQwbTQ2RUdpUTJkNDBDTHZaYzZxZ2g3dU5FM1NJRWFuVGtS?=
 =?utf-8?B?MzZUWHdYOVdNcU5WOG5EN0x5d2QrSkl2Umg0Vit4U29RVjREM0xKbU9hNWJE?=
 =?utf-8?B?UTJZUXFxd3Nodm9QQzMxYUlCbFNRTUo5cXM4KzV2S0kvdE94OHNIWlNaOGJY?=
 =?utf-8?B?Qmhic0RoaUtBUFpTajQ1elpRa0tIYUNsUW9xc2wxMVQyNnVrK0xneHpkckk2?=
 =?utf-8?B?TFQzS1U5dUU2UjMzYzY3MUplQVBPeXJobzlNNTRpZHdKd2I1NGtoTHhWTldK?=
 =?utf-8?B?ajVWOHJEV09CL1B5azA0ekJQZnFqN2pnVUErbTRYMnM3M1NjWkh5R2kzUERw?=
 =?utf-8?B?ODkwellFZHh4dTJMbWN1MjBqL2VKUXhsWC9JT0RnVGFvY01zcnFzWGw1Q3Rz?=
 =?utf-8?B?dDgxV0o2QU53PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlFYRzJXUXU1TldNbGVybUY3djRZOVc2YnNOVkxZTDA1d09MK0UvZVE1S2Nj?=
 =?utf-8?B?dEhHRzlEY0ZsblVRRTduU2NyWVRrS1NyTHVMMXBnaHY3TnEzbG5UZUVTakk5?=
 =?utf-8?B?MldWYUFCdGN3MXQyY0F6aWh3ZU52VnljK3JYWEpNejRzY0tzQVhWZkc3WHVy?=
 =?utf-8?B?Nit2SUlmL215b0x2Vnpmd3NhMmhFcTRJajRQakpqWjgxNWx3TFFGaHRlRk5L?=
 =?utf-8?B?VmJ2M1lxbHdvNElZZnl1T2lCZTBlYURPSGxPWVpDZm5QN3JVR21UNVlkWEk0?=
 =?utf-8?B?c3NTYkNEKzMwWE1BL1JlS01lSHpZaStMbTB2SmV3SmhLOGEzQjcreVl6L0R4?=
 =?utf-8?B?Q1dHKysvbjZadjdJWkI4d0tldWs0b3J0WTIwQWVCeEcvcDJtWjRoL3RHZWJX?=
 =?utf-8?B?bmRsYjRJL3lDUWdZZURMc0dSMnI4RmhvNGNzdCswalNxWVRPK1RwU0JtR3NY?=
 =?utf-8?B?WGE3cXJhV1pTOHpkNm1kOXhkYjBWT1RYWXd0ZFdBZGxNNXNDeE9FTEFuR0t6?=
 =?utf-8?B?c2E3UUYvcjlYRS8zQUloc0g5RzBoYzM3Z3c0L214RkUyVW5pbUxWYSsyUXli?=
 =?utf-8?B?WVpqUHJSWG5XU3h2aUpaL3doUFZ3NVhJNUl0bUJjRVQ3NlRCaDdTdmw1TGoy?=
 =?utf-8?B?Njl4YkhIeDUvSWVucnEzT1ZRRDdSb29URElhK1NmNjdxRXNaVk0yTFN1cVh2?=
 =?utf-8?B?b24reTdvZ1JhR0ZldnN1SzNMdWRWd003ZTN6OGxwaXdLZ0ZkUHZUby9vbk5C?=
 =?utf-8?B?VEZyRnBXblpJUDVPdDc0WmV5ZjVrZFZZUGlGeFcxNTNkeitoMlp2SXR4cFlk?=
 =?utf-8?B?ZWdGdWs0ZUlhV2Z6NTBqeGhLamZRTDlwbFoybURkeCtiZWJFa2x1ckFSZ3h4?=
 =?utf-8?B?VlBYYWNuMkxod2ZST0pTTkZFSDJXM3hmSlBTSW1FblNMUDExTW9RSm4yL2Jv?=
 =?utf-8?B?ZWNZeG5SZDhPb3UwdW4vNmxMSk9YbUNYd3dOc1lDM3Fib08yVWh3WkJWWkFy?=
 =?utf-8?B?ZFRKcHFkamMyTk1NY1hkVlRZL3R2S1BjNGJnVGV1ZUFxL0pMbWNMWnhWQTlM?=
 =?utf-8?B?TzcyZXhRV3dSOHJ4bWdVR1ZOUFM0WEFWMmxXRytFYjFxdzR1ekYrZUMrMHNQ?=
 =?utf-8?B?UHU0d1hrdEFUa2x0RVBQWElnQXVUL0pyMm5EcXV5MTV2L01BUElZTjdYUDFN?=
 =?utf-8?B?MlpxeDRuVUdCRDRTMzJhTkNNTjNQQkZMeGh5bWR2MCtUaUFvcC9YR0hNTXdR?=
 =?utf-8?B?dEswN3p5U1o0T3NlUUpKZVhJb2tDeHhtS1R3TmlPTVJxNjc1a0VNQVZ3Z2JN?=
 =?utf-8?B?V2xLUHIxVDZ4M2ZSdDhEbjFLUk5jYUtzSmUweGpCbHBBSWRmVWZVMCtTZzk2?=
 =?utf-8?B?dzdKT2lRSjlKbHNhR2FFUHRpZkJkRnl4Q2lWYU5oTE1iOS9CL213aFZsYm82?=
 =?utf-8?B?WlIxYU9PeWpXSkpxcy9XSk1wdVpqdHFITmdaZ3VRekxYVGk2dVpKRjlmdzNF?=
 =?utf-8?B?MXBWL1NzOWV6MlJMYkx3cXBHZDh5Vm05MktTb3JDeXM0ei9aK0ZkbnFocWNK?=
 =?utf-8?B?UjNmK0w4WWdQWjRRUEhBQ0U2M0xKdFNNNG5EWks2QUpYSFNqelAydGNzaUFV?=
 =?utf-8?B?RzZkRmVGaVhjakJDNGlDc1pzVE1FdFBXbmtsejVFQmd5MkhnNkNyWjFmSENH?=
 =?utf-8?B?ZnRNUFpOVXRhNmx1Njk1ZEFpYlcrWTBSZXpkQnRoN3UwbVVreWVMazR1V2VQ?=
 =?utf-8?B?QzNuaXQ3N3FIV1E0d0paT1N6WnZuRHQzbVhiaUsvaXJGMXZFQnRWS2MyVlJO?=
 =?utf-8?B?d2tVZkZIKzN0RXIyVlpDaWNSRDM4aWhia3FOOVlmSnpvcFBiTXF0SGozYllN?=
 =?utf-8?B?ZE9wWFpReUN4Mi9odWpUd3VZMVJQS2pZc1BESEptSmhrMkxUQ3plVVI3RTJZ?=
 =?utf-8?B?ZjFFcDJKdkFGbGIzOEVzeDB1Y2c5RGFmaVIwRzZxVU9DZUxPR09KejhCSjdV?=
 =?utf-8?B?L2UyWUVmQ0dBajBPZkxKdWpoeHBBODJOeFVySyswd1hLYkVzbFIxQWN3WFds?=
 =?utf-8?B?ZEFsc0p1b3pHRzJlcDdwaVZ1dEFRQ3M2MWRxMWJYanVBS21RekVDTGNJRi9W?=
 =?utf-8?Q?CVQBh+Tc5Kejy2G8c0nfGlULR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d653e047-7f88-4da1-0bbb-08de37867bee
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2025 00:53:07.8770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: veg47edAQj1WfH2SVzSR9GBlC2xenV/d2qJrWthiMgHSfHEgeo99bYChisnIc8oPQi9zdqHbaHngfY4xG3ntSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5134
X-OriginatorOrg: intel.com

On Tue, Dec 09, 2025 at 06:28:56PM -0600, Sagi Shahar wrote:
> On Tue, Dec 9, 2025 at 5:54 PM Edgecombe, Rick P
> <rick.p.edgecombe@intel.com> wrote:
> >
> > On Tue, 2025-12-09 at 17:49 -0600, Sagi Shahar wrote:
> > > I was trying to test this code locally (without the DPAMT patches and
> > > with DPAMT disabled) and saw that sometimes tdh_mem_page_demote
> > > returns TDX_INTERRUPTED_RESTARTABLE. Looking at the TDX module code
> > > (version 1.5.16 from [1]) I see that demote and promote are the only
> > > seamcalls that return TDX_INTERRUPTED_RESTARTABLE so it wasn't handled
> > > by KVM until now.
> >
> > Did you see "Open 3" in the coverletter?
> 
> I tested the code using TDX module 1.5.24 which is the latest one we
> got. Is there a newer TDX module that supports this new functionality?
AFAIK, TDX module 1.5.28 is the earliest version that enumerates
TDX_FEATURES0.ENHANCED_DEMOTE_INTERRUPTIBILITY (bit 51) and disables
TDX_INTERRUPTED_RESTARTABLE when there're no L2 TDs. (Please check the
discussions at [1]).

Looks 1.5.28.04 was just released (internally?), with release note saying
"Ensure TDH.MEM.PAGE.DEMOTE forward progress for non partitioned TDs".

Not sure if you can check it.

[1] https://lore.kernel.org/all/aRRAFhw11Dwcw7RG@yzhao56-desk.sh.intel.com/

