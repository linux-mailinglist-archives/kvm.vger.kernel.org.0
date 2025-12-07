Return-Path: <kvm+bounces-65469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BAB6CAB26F
	for <lists+kvm@lfdr.de>; Sun, 07 Dec 2025 08:22:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 70C36308A95A
	for <lists+kvm@lfdr.de>; Sun,  7 Dec 2025 07:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 727C92D7DD7;
	Sun,  7 Dec 2025 07:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VG/Vhywk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC092D0C8B;
	Sun,  7 Dec 2025 07:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765092139; cv=fail; b=SrkXv7PO6DjOHmQz2eRNktnDFa6NAEKW9T4A0Ws0GbmDx53ybsYy+0y4cX/hgXLSfZgQMah2+kCqm6Iex2rxDMe/uPB3Dp0FNbyz23fbLgKFv1vlzQwipnlNLHe3u0fRWWrq/7JGysg2ki84UWAt0Wp5+hPNfXaGt2ToYfBA++E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765092139; c=relaxed/simple;
	bh=cAur484oF5/T2zZZhtFfTiOhQYQ96x5W70Ia5AxzM7g=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=YgLX24jHFzz5kQuOc99wtgoTkCcsPZJoQJ4P0b57BC505JdVQwe6En2Xm7MWaNbjNrKVHnTMUyKqwW0eQ9tXlDMM3fE2t1nF8MwGbAXTViGXUg43PMj0KIfCqSePRimwsdWCX6+89Y0bdDPjO9Yc0wgRZzCeldZ8leCOwSbMb4g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VG/Vhywk; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765092138; x=1796628138;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=cAur484oF5/T2zZZhtFfTiOhQYQ96x5W70Ia5AxzM7g=;
  b=VG/Vhywk7Fc+s4hZuYsB9wqwmjkfeLgXOyQ8FeCLj7qGg1l8NHE6C4TL
   A2ra5Aaxqr3Cj0fM2fxyKyYiF4JmF//Innf2+4ErxkGd1YSnWL+e1euNL
   UmzLSRLNlMjJubnV4vJU6poG2dwgWYBB3vyF8Rx4jF04IRja8u8mkn2R8
   lmD6ao/Pqg3DA7weTRn0l+qdJ5fBb7Yw/DrWtxWhIglYwiZshrXR32R1K
   Tkz5BRDFq5WxY5ygddiycFWFVptAF4FBJ8Yo0MHnBeiRBbtgQ9k5p0BJd
   FXr0iFQm+SRa6Ky+7zZdkAbL2AvKhTKg8C0XeFjU0H6JzIz3JoVMqNY5C
   Q==;
X-CSE-ConnectionGUID: cOX6jMpvQzmmESkTSMm2cQ==
X-CSE-MsgGUID: NBk092h0RHSZo1OWvomOAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11634"; a="69663156"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="69663156"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2025 23:22:18 -0800
X-CSE-ConnectionGUID: 8uAoKl7TSaObSUlniFbdTg==
X-CSE-MsgGUID: nIqTnaJGRmKIijbvLzdKAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="200785381"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2025 23:22:18 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 6 Dec 2025 23:22:16 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sat, 6 Dec 2025 23:22:16 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.30)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 6 Dec 2025 23:22:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AuqXPg79FGe2kh08Mm/3Xz0hG34eBXAhwNiVEt+uGP1pfe7O647dOXiwYeLVpP0echio/LFWRpuEOh6tCEab/V8Z/2sEsKKogJ2rSHdzmYrqNjFQWIQ4WbID7XCn9WhSoEmQ1TiN3XVrybfUt6Gdd83jEKrhrRsqdHFpjM1qs/0eRSPaHSEziwowV7GuQTNE8zVMeAfvwo2shm6A4hNZcJDcXFZvx8CmVZ5Hw4IyRtKn62h54XwcUUoWzcmFnrLZpGcCAD//7juCGbFhAvcx9Z45WLjZq9W/csr4nj+OuAK+UNBTdCIjtJicnBul9+KMyImf+jzhj8dP+6StCvW8eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YjyOYX/dH+PZprJizK4RAVz9O2gh8y8nK+ubV3kP8M=;
 b=UtZWh0A8ZknX5TzhadYyCpicetmFn5cQzNV66bJ+pH5mrbETt1ExOAu0kWA0i1Bkj2vyOROnK75ov+kNgapOJHBKKra82OsYUfn7ptUUC9OmpN5i7I/7Ji4e3jaQxLjRaJ9c2dDP8tPhBXiwH4EG9yolJHfHNBLAlAblmAc4Sg2TfUdmH68YLDgPMRLILwh+jCQVsjpHLORPFYMt7XewBhIUYDVoQ76aiBgrAQPdBbcR+4FByRT7Q2r0yzo663aQgm+x+oTbsazvfRNsucinPXGa/KyrH82KjfCRptrYZlKnJO+Isxj6uigOpj9KJEfUayslHyfNzUYG68Scw9kPxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH8PR11MB8014.namprd11.prod.outlook.com (2603:10b6:510:23a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.13; Sun, 7 Dec
 2025 07:22:14 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9388.012; Sun, 7 Dec 2025
 07:22:14 +0000
From: <dan.j.williams@intel.com>
Date: Sat, 6 Dec 2025 23:22:10 -0800
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, Chao Gao <chao.gao@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
Message-ID: <69352b2239a33_1b2e100d2@dwillia2-mobl4.notmuch>
In-Reply-To: <20251206011054.494190-3-seanjc@google.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-3-seanjc@google.com>
Subject: Re: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0194.namprd05.prod.outlook.com
 (2603:10b6:a03:330::19) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH8PR11MB8014:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f227f39-4037-4d0a-18eb-08de35615833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WUttWUtQMXcrUEhDdU1EUUxrSStCNkZ6UldOL2hjTHRyNUZQQ21FbnJuS0lj?=
 =?utf-8?B?NDZBYTc3ZUZhWkcyb1JPT2tveXNnYVhQM2xLS3RzTjI2dUpEQUxwZGF2VEll?=
 =?utf-8?B?TDBzWFMrZDQ5MDV6dFNNckVCbzRiMUwybHlNb2NnYlg1eWZyY0hvNEhyc0xq?=
 =?utf-8?B?MHlLQlE4OFE3ZlpqN096VmU3QkZUOURqYkZwaG42UkZKZ29BcUhFSk01dSt2?=
 =?utf-8?B?cHZpR2d3TzN6Z3hlUkZwdDJMeHpGNzhvcmY0TFFGNGphaHFvRE5vWDlvODc1?=
 =?utf-8?B?aWN5eVpBTXUrNnRROC9ja1MzM0NTRStzTTJuT0VmTEJoQlVLMHpPUGQ3Nzk0?=
 =?utf-8?B?WElOY0t1d1ZyeFhlS3dJcHpsbXFERE5mQ2xybDZKdEhDcElZdm9TeXh3T2Mz?=
 =?utf-8?B?U1c5RFYyUlVGK3FpdjAydlNIeXFKT3pyTGpva0FMWWlKQTRPbndZNG1FL01s?=
 =?utf-8?B?MHdmellyS3E2SmdKN3R1TTBIYTE4Z2ZkZ01IU1FlOW5yQ3c3dDVhT2I0a3Ja?=
 =?utf-8?B?YW84bHo2WGhQQmR5MDBuZnJ1eXRMSDZnakl4ZS9HMGZla1ZUMVBTQkdmQUVR?=
 =?utf-8?B?NDVjR0dlL0ZKSEJHSWQxUU1rSDVXMW5jT1BvcU8rS1JtNTFEYVJ0QWRINlZp?=
 =?utf-8?B?eUZzQ2p6bnpPZzZvZlFjemNYeE9NeGNJV3JDWUZRK1c1TUc3cEdTaFZLNkJB?=
 =?utf-8?B?MXhWVHh6a2N6UWk3QUZGZkduT0o3d3E5ZjVwT0NnbGQ5RVkwSy85SXRONGdt?=
 =?utf-8?B?dUZaSTVBOFY3NDVrM1VZZEhRUEo5S1dzMnMyQmxwTHFuTGxROUxWU2tXV3Rh?=
 =?utf-8?B?cFVCK1IxbER0MXBMRDZvaC9DRWFGUVROVjNYamdaclZOb2hHNGs0RHp6aHJm?=
 =?utf-8?B?bHNzS2p5NWVBdTVoQ0VVVjJuZ2xTVk0xSm1pczFUWWVsU1RjaTQzUFNSYU5s?=
 =?utf-8?B?T2ZpN3FQdmovb3htOGU4NzhHQmFKV1ZhVG9Zc2ZYWko4RFlSdGlYZktBc2x5?=
 =?utf-8?B?c0tvTDBMTVZ5YXhJQWthY0UweXJqNk9FQTZWdFdUZDE0YlM4SVVTUGkwcDFX?=
 =?utf-8?B?czh6bkphQW0xaUFnaXZtbEpMSzI0WGpCVmxLZHRGcUI4UUk4RTkzbEVKNWt3?=
 =?utf-8?B?Y0lLM3liR0pKYU1YNWpLZ2VtNVZkZnpWVkdzeTlleStGeVQvdmcvYlpVYm1G?=
 =?utf-8?B?RUxCVFQzK29MdXFsems3Tit5eG1jcm5lckduc05oNVJ1QWQwRVlUdGtzZ1hQ?=
 =?utf-8?B?MVg2S04xeGNwQlhXaWViYUloMW1GYXNXc3RlTWRlaytENmxwM0U2S25wT1h5?=
 =?utf-8?B?ZzNnUXJmOTVIdi9VdDBXcWpqcUxlcHVLUHVaV2RHQ2FsVXJPOXFUSU1Edkww?=
 =?utf-8?B?NHBZRjlpaFZUZjNhamVUS2x5VTdReWdpQmpJNkFtdG4yNU1nK1BDTzhCQzVy?=
 =?utf-8?B?QUdZVzR6dFdwcVV2Y1lxaFFKbTgycGhwY0E4R1RqZWl6ZXVLUDdYa21kOG1O?=
 =?utf-8?B?S2Rnc3pnb0QwTGswYk51S0s0OWFvcGQ0cURQNHhWQmhYK0UzVzFzVUlxc1Z6?=
 =?utf-8?B?RHEwTXpuR0pTZk9aSzdJcTc4T1FZTW9ZdFNScVpPZ0RiTG9YcGVWM3MySWFl?=
 =?utf-8?B?aW9SR253aWkwRHc3VGNQVUxGelBJNnRpNnlpRTVsYlFzczBKV2FPNzRQZjBQ?=
 =?utf-8?B?UWRkNDB5V0VNVlB6KzY0eExEZVh1NUk3Mng5QTJJYkxmZUx1elZIYWtJRVQ1?=
 =?utf-8?B?bkloZUVPNmQ0UmUzRTFqMjdlbHJhNHc2V3lMeVZyODZDWk5Pa010OTBOU3dn?=
 =?utf-8?B?QWIzdy9waEUxMFJTOHM2RUw5RkdxdS8rdkx3cXpLdlJrcE9XRzNOK3g1ZzlN?=
 =?utf-8?B?Ukg2eWRjSE5iSXUwVzNVZ0JQNWorb0lIVGU1S09Cb3d5WFdTbThKclNrbStY?=
 =?utf-8?Q?1vocZUPvm7DU+k6FI+lkajT6MMLqu+Ax?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmFRck8xQ1FkV01rU3dXNzR5eDdhS2ZwVlNrRHVrS3l4T1dOcW54bXdPbkpT?=
 =?utf-8?B?eitHTHNQK1JqUkpQdFEreGdJUkpSWW0vYnQ2TStXWEU4N1FZYVRna1AvM2ov?=
 =?utf-8?B?ZnZWanVBQ2loeE9Oc0ZzbWxqVnJvTEQzZ2xQUWcvaC9QaGlCcU9vTVRHUUFo?=
 =?utf-8?B?RDFvbnY5VjNOU1FMTzBVcWMxSEJNc09sQ0tXWWZ6TS9rbld6eVRNVVFWL1lL?=
 =?utf-8?B?SU1lNW1sU3lhTGV3V1FPcitOT2Y3cndPZHRQaUlRcGZwSGtRZ3V3eHNwQ2JS?=
 =?utf-8?B?cWExWEtCQ3RESjVSS3haRjBiZUhBVSs4dUZPRU1Bb2FoUkY2UllQMDQrdys0?=
 =?utf-8?B?Um1qQmQ1ckN6M1ZsWDVrNDdGWHd1eEEzZ1c5L0s4ZHU1cTUySU5QMmNBRnd4?=
 =?utf-8?B?ODNzamU2ME5BRmFRTUtrQndDWUMxSko5OEJKUHhWK3NJVEJTakZPek5URnZM?=
 =?utf-8?B?anZQK0tZbWtlbVBLQy91aHd6R2Z6ZEM2V0FtVklNKy8rN0RNYnZZOGIvMkxS?=
 =?utf-8?B?NzVSQTdnOThxS3FoanF4WEtYNnROUmFoOUs3VW5mdHRUVGhTZDVzd0FUVitF?=
 =?utf-8?B?T2VOU3hDejNud1BDYmRORkFtMDI2RkNEbklrR3Z1dkNRVUF1NnFzUVVmU1Bw?=
 =?utf-8?B?eEJOWGJVTHhaRFV2Ty83bnFhdzA3ZDhuTTNIS0RrazV4Sll5dGV1MWs5WUpv?=
 =?utf-8?B?VDQycitpb05iT2tMRGNhbUxqVm9lS2E2aGxQZnQzTHlWaHlpa1laVEJQNjZq?=
 =?utf-8?B?UTdQS2VvWUdjaXpqMHY3N0tkWVJ4TlEyTkpIQWdOTUJHUzZRMEs5NmU1UFZl?=
 =?utf-8?B?TWFuZEhDSXgyUXNYMWJ3a09KUFp3M0hETlQ2dWxSUk5DNUZtWmNob25IM0cr?=
 =?utf-8?B?WnY4K3NRWTNhV2ZROVdFaVNJeEh1Q0ZlRHJHRVJydmlnWlk3bFUwdGZ6RWxJ?=
 =?utf-8?B?TXRPV2szNlF4d1l6Sjk1TXgyOGFVTWx4a0JwcEFCbHd0Mk5wb1lINjdKcU91?=
 =?utf-8?B?M1ZsN0YxNGdwRTI1ckZhTE5Yc1IvV2JXWGVuRS8rcDRjeUNpZDl0dnVKZWJR?=
 =?utf-8?B?b3o2TkJkZlBlTkJwc3AvQmFUOE82MG1hOGVpV29WODN5K3JRWjM3T3V4RmR4?=
 =?utf-8?B?L0d5Zm1iVnhoRTl4dXNKMlFSZ1BnajRxeUxVZ0d5aGwvNmFMWVk2dTFsOFdQ?=
 =?utf-8?B?UzhROXJQZGZPZW50dUg4dlFFYkNGbHNtNU5wYnhhRnpiV0ZFTU1ydUp4TkQw?=
 =?utf-8?B?RVBoQ0gxaXZ3OTNuY1lqNGtYSGN5Ti9qaDFqRnZTMUdKRUp3Qi8xN0FiMkRu?=
 =?utf-8?B?L3E5R1ZyWnVLY2tkcGVHNXBlc1Mvc2ZMMmYwQm00UjA5WUJ5bWZlQ0ppbk15?=
 =?utf-8?B?S0ZUKzdhZWEwaXhIT2FHZTgwVndSYWtzczcwZWkycTQvQkUxZkJnUEY3Vlor?=
 =?utf-8?B?UkdZY0xPRWdrb2tNc2lhckljV3NnMXllVTVwTXJDUVJIZnRLcEg4dWlPMUs0?=
 =?utf-8?B?d2sxV2hqaUJveW9nQWFqbHhSZ1pack83bzZmcklTaHFIRi92NlJtalIzdW9H?=
 =?utf-8?B?c053Z28wbHZ0RFJqQk5yOEtBYm9oWUgwL3cweUE0K0trUE5FdGVXdy9Dejdu?=
 =?utf-8?B?ZEd0T3lRWUxjQ0p4ODM5MXA1U1FHcUNWTk1NMzN3RXZLYUg2bGliMHdtZzVM?=
 =?utf-8?B?ZGI0bjVvcDZDZHlrMHovTE9tdGl3dlB2UGcwcm11NkREcmJuM3l4YlBuaVpo?=
 =?utf-8?B?dFdBbElVMS9kMVBxbXU2RXp3YUVma3Qyc2l3LzJTSG9RbWZJWmVKWWtRSFdh?=
 =?utf-8?B?d1VnNWJ5ZTdrbGhxbTNBb3dmREZaek5GV2ZlZk5MYkIvQndNR1dzTFUwbkJq?=
 =?utf-8?B?M2tKZ3ZIT0VxOUo5cmVWc1NWaGxtRE9kVXIva01hcStFTEFvV05nTGNFc3Fx?=
 =?utf-8?B?dG5sbWR1a3cvNWZXOTBkRWQ4ZWZiVmdUSmlLYzVXL2hHL3pCcE43UmYydFhp?=
 =?utf-8?B?bkViKzIzSnU4c0lKSTNwWUFvY3luSGE3N0NCYzJHdkZRbHBHM2ZQTnQ1dlRT?=
 =?utf-8?B?NmJaQWV5cGZIYWt1UFNZVS9ZNkJKdVZwMnI2Z3hBZXNPcWIyZlk4UmQxYVNF?=
 =?utf-8?B?aEdxQ3djVUJVNlpkN2ptSEh2cEtjWEZpRUZJZXl5NkQrL0xRWTN2UmdDd25G?=
 =?utf-8?B?NlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f227f39-4037-4d0a-18eb-08de35615833
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2025 07:22:14.2490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OvF+vEnemEnFnpmxEKDbEO9Gc1J9G1FOygqpR1KxoPuGt63JGA+GMC0LTqofRlI/wvXwu+ebn9+c7y/YIMh6ZcJby8OoLCl/PN9Cz/UVZ1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8014
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> Move the innermost VMXON and EFER.SVME management logic out of KVM and
> into to core x86 so that TDX can force VMXON without having to rely on
> KVM being loaded, e.g. to do SEAMCALLs during initialization.
> 
> Implement a per-CPU refcounting scheme so that "users", e.g. KVM and the
> future TDX code, can co-exist without pulling the rug out from under each
> other.
> 
> To avoid having to choose between SVM and VMX, simply refuse to enable
> either if both are somehow supported.  No known CPU supports both SVM and
> VMX, and it's comically unlikely such a CPU will ever exist.
> 
> For lack of a better name, call the new file "hw.c", to yield "virt
> hardware" when combined with its parent directory.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
[..]

Only patch organization and naming choice questions from me. I only
looked at the VMX side of things since I previously made an attempt at
moving that. I gave a cursory look at the SVM details.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 80cb882f19e2..f650f79d3d5a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -83,6 +83,8 @@
>  #include <asm/intel_pt.h>
>  #include <asm/emulate_prefix.h>
>  #include <asm/sgx.h>
> +#include <asm/virt.h>
> +
>  #include <clocksource/hyperv_timer.h>
>  
>  #define CREATE_TRACE_POINTS
> @@ -694,9 +696,6 @@ static void drop_user_return_notifiers(void)
>  		kvm_on_user_return(&msrs->urn);
>  }
>  
> -__visible bool kvm_rebooting;
> -EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_rebooting);

...a short stay for this symbol in kvm/x86.c? It raises my curiosity why
patch1 is separate. Patch1 looked like the start of a series of
incremental conversions, patch2 is a combo move. I am ok either way,
just questioning consistency. I.e. if combo move then patch1 folds in
here, if incremental, perhaps split out other combo conversions like
emergency_disable_virtualization_cpu()? The aspect of "this got moved
twice in the same patchset" is what poked me.

[..]
> diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
> new file mode 100644
> index 000000000000..986e780cf438
> --- /dev/null
> +++ b/arch/x86/virt/hw.c
> @@ -0,0 +1,340 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/cpu.h>
> +#include <linux/cpumask.h>
> +#include <linux/errno.h>
> +#include <linux/kvm_types.h>
> +#include <linux/list.h>
> +#include <linux/percpu.h>
> +
> +#include <asm/perf_event.h>
> +#include <asm/processor.h>
> +#include <asm/virt.h>
> +#include <asm/vmx.h>
> +
> +static int x86_virt_feature __ro_after_init;
> +
> +__visible bool virt_rebooting;
> +EXPORT_SYMBOL_GPL(virt_rebooting);
> +
> +static DEFINE_PER_CPU(int, virtualization_nr_users);
> +
> +static cpu_emergency_virt_cb __rcu *kvm_emergency_callback;

Hmm, why kvm_ and not virt_?

[..]
> +#if IS_ENABLED(CONFIG_KVM_INTEL)
> +static DEFINE_PER_CPU(struct vmcs *, root_vmcs);

Perhaps introduce a CONFIG_INTEL_VMX for this? For example, KVM need not
be enabled if all one wants to do is use TDX to setup PCIe Link
Encryption. ...or were you expecting?

#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(...<other VMX users>...)

