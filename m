Return-Path: <kvm+bounces-53031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B890B0CCC7
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:39:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E3BA7A4F84
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 21:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDBC124292E;
	Mon, 21 Jul 2025 21:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="baw6fI7n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620F0242910;
	Mon, 21 Jul 2025 21:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753133831; cv=fail; b=ei6eQ0u/BvIJKUM1VaLkOA3JHlxK8+0sFK9q+lFzsHB9BlOdoNAFKRK4PB99RHF4Yc3PDY/4/iqjSxyhh3Dw/ZnLXVm0YWX1oq7xmAOFF/ne+y+gWM7Yoh9/8WHzff+yZWGnr8LyhdlNmC5wcAMLoACTsiLgOWfv/k/IJHZg2nU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753133831; c=relaxed/simple;
	bh=nGLeilw+vPzCXhmKkQWwNG20iTXp93pWMFQUx3rxIvk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UGN2uVjXHCd8FDeeawzTc55BQuYUrCeZ6WBvQJAS4JhJ6czFAaHtAcjUVUBGetHLjCednNWpBElzG5SbV/GjHMaw2DKJiBTR7nSd8weTYXwSRrNDmYCTPPaoHlbgHFcJOF97Ym2hREpitMsGGLdj8ABFV3b+0s8YO8EzAQIzaP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=baw6fI7n; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753133830; x=1784669830;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nGLeilw+vPzCXhmKkQWwNG20iTXp93pWMFQUx3rxIvk=;
  b=baw6fI7nBOfh0ldJlGFq6j5onObnYxz2s6ofb3vWvdsOTtBc5k6cY473
   N2l7ERLCYoXwg1HKBuvE5Mr+OSzkUGqhGRGSIcZn80TrzI9I60pR5y8Nw
   GLGFYj7aS9by0Y8EMkEocuMp6d8VjFJ2kG9MdUd8nCFOJM/iUERgXLMzJ
   7uB5u+EkbpGnrLScn9iJf7T+SIlkAoFL6h7JOb43xh+vXlNV4T1SA+dNc
   hNg85fXl27+FVWeedxXrrXBHW/P/2ORJ9iguuWWNq3ajjKmmwBvO0HzYI
   zYFcI7SXAAugmoVrhi839RKFtXWvCMWbsm9nR1XvcgSFNDJmBT0EEiCPO
   g==;
X-CSE-ConnectionGUID: XV+G+dhrSkaOayUaofYBZQ==
X-CSE-MsgGUID: JdLkwsMsS/KYSP+2HUgnGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="55522508"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="55522508"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 14:37:07 -0700
X-CSE-ConnectionGUID: SmRnGj2DTcOrP2sAeCBZJQ==
X-CSE-MsgGUID: 0KTeRONSTVuUsTED39/vvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="164441713"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 14:37:06 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 14:37:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 21 Jul 2025 14:37:05 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.89) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 14:37:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NJg32ELQcWQcV5ebgypiOc5oEZblw0VEZHOwp1m8wQ18y5gD2jgkgmlop5L8OOjvOc7uWERS34RzJQ7x8NHiyV/2/PbG6pea/3EejIjPa+DmaZcCVt38Yxy2hUW6XiSGdVMbmxerE400nAbyUaNelk1SPvqrglUU3mvwbAaQcJH32tnOtShl78RZsH1gHxg6DwzRCgNMfwEnQN1LCDPeQo5cR3BLHozeGMnh/diZKdzWtdTNOdWXCcHvm874yKGt+xeJzTIrFc/9fs9DYCKKU8SVqyigZgAycQagrehLFd2w0oiaPpocSJOsrrfdDj2g8oVyhoY4gcCfNQhdyQxzAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nGLeilw+vPzCXhmKkQWwNG20iTXp93pWMFQUx3rxIvk=;
 b=TzTWfwrFxJe0+kH4uzxhoOV1NB4bFdHri8FrO9ShnpX+Nn4XELqGBUQgQhhrp+0iIKqSDrwNeqmSLsNDxJqbmkQgCpnqOwSu5+F7WKXrGHe39yg7CPDhwQyEA2UwZPtztJGt5AI99zn/asOZ24Ao/p7/t2wvjt0UcxNaY5WOVFkXnMYhVVBaU/aWcvam6DUs9bXEZcPoQJjFzZ8PeEAHdllQ8PrkWcUMm4M+B4JaslM1ojgU5KXbZOtYmOiXaXCzpv5VFdcBI8Z26/RLEmSZfhAtOFX7L3XzQaHPLZSIiyF2JACX26Wp5RAHxXAIZ8JBSeFYTwa+iDLq/N1D2+o7RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA0PR11MB7308.namprd11.prod.outlook.com (2603:10b6:208:436::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 21:36:48 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 21:36:48 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "peterz@infradead.org" <peterz@infradead.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Topic: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Index: AQHb92MJH4Vi4bs6uUOSkG2OAWH7LbQ8rCmAgABvgwCAAAIgAIAAAokA
Date: Mon, 21 Jul 2025 21:36:48 +0000
Message-ID: <1d2956ba8c7f0198ed76e09e2f1540d53c96815b.camel@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com>
	 <c7356a40384a70b853b6913921f88e69e0337dd8.1752730040.git.kai.huang@intel.com>
	 <5dc4745c-4608-a070-d8a8-6afb6f9b14a9@amd.com>
	 <45ecb02603958fa6b741a87bc415ec2639604faa.camel@intel.com>
	 <7eb254a7-473a-94c6-8dd5-24377ed67a34@amd.com>
In-Reply-To: <7eb254a7-473a-94c6-8dd5-24377ed67a34@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA0PR11MB7308:EE_
x-ms-office365-filtering-correlation-id: 308b4978-7ece-4549-7dcc-08ddc89eb29f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MGJVRW9yN0FPK0EzUG96ZFBkQlh3enFOUm9FK0hUcjlodWs5RU5YQWtIK0ll?=
 =?utf-8?B?d3hrTVhBb2VYcm11T3UxaVVmaXRrOVlydGxLMTBhTG90OHhKZnUwOHBjcFUw?=
 =?utf-8?B?eWpINjNCZTc3OXZlby80WEV4dUwva1ZWV3NOcFpjODVoWkNuRUcwODFuT2tv?=
 =?utf-8?B?TktzeVVTR1BiTHlzck5ZVFRweVdZNzVnSDFYaHR4OTNpSklDTDN0b0ttZWVk?=
 =?utf-8?B?d2hpUXdXR3NadmFhV2pVcUNyQ2w4RzBLaitIMFZXZWdqb09GVWU3NWE5R2Jl?=
 =?utf-8?B?RjN1L3RhWnVTVGNzaVRiRU5nRHVOOU1hdGdsNTRIdnNHOWRMUEozL2lWY2NG?=
 =?utf-8?B?V2RYeWkyczI2eDhxQy9UVzBvV3VuZDAzRHplTDlJdFVCY1R4bUJmQVpNbm9T?=
 =?utf-8?B?M2R1dGpOV2M4OEhOeDZ4SFkyS3RIVU1DaXMzRlk5cVd6V1I5TEE2TU5hV083?=
 =?utf-8?B?T1JZK2JIT0FTbGtTL1MxUHRHNlVYazhMcHVsckZVVnpGY1BTbC9YeGRqc1Vr?=
 =?utf-8?B?V1M0Y3RMaXNzbk12ZEczVmZ2N21iUGlKSnFUaHRtMlpxcmxDOVV5RkJSUnkv?=
 =?utf-8?B?Z2tEVzBuckpONEk3dXM3RFJDby9sSGttVFc3d0ZTWWxDazFJSkVYUXpvcUNF?=
 =?utf-8?B?VXh6N1phZTd1eTZxai9yNUlvWkQrSmdZMDhua3NzbFoxZkxneWxrcERXQ0dr?=
 =?utf-8?B?aDl2QVpNTFp2UFpiZGI2YUlUWEsrRjB6VG44d05vSWFhUU1wVDhrMEYxWmRQ?=
 =?utf-8?B?NkNNb0VVMUJSZld5ME5jbnRoK1RQVXZrTGdBY3lCZHNEYVBiWjNzT1Z1L1ls?=
 =?utf-8?B?cGN5NGhpTnpPU2ZETWFQMU14WEtPanQvSlJCR2tYUWF1Rk9KTklraHN6bU0v?=
 =?utf-8?B?NGNXVENGVFQ1cFRncS9KcVAzT3kxeWQyUVdUREFJclJZZUlic1hKUStKSWNt?=
 =?utf-8?B?NC9KN2JTSG1NWDkvSXVrZjlXUkxzVHlaWnRkRzFmZUxQeFQ0VFZrL0RubjV4?=
 =?utf-8?B?UEp1ZXQ3RjVRT1FXeHNiZlBpRHhPQm9iTzRwZWxDejdqVWlYeXZad3hJQWw5?=
 =?utf-8?B?eFBHN0RHV1VJbzZManJUWmdOTitqNjZ4VGdSeFFBd205QVh2TzJiSlExQ0hk?=
 =?utf-8?B?NEhTcS9SbEdmYjhsUzI0TXFwdktXSXNsL1JnditpczlFZThxRkVkUmJTcSt4?=
 =?utf-8?B?THVyUlJWVWN2SUYyVW1Ga2RSTkN3K2craE1icmpzYTg0WVdrMFgxVWVKUllr?=
 =?utf-8?B?cXlreU1PN1JJb2hWVmpSYVJpakVhbjkweS9DOWE1bzg3d0NlVms1K0pjTWov?=
 =?utf-8?B?NUVETytOYlQxQ2RWRmpwM1V0OHVKemwzQnJNdVREK01wWmd6Y0huZnZLazcy?=
 =?utf-8?B?Z2kzTFhCZ3g0VnFFclRESTlLRW9McEhXYkVSYkRndEowTWhVREEwRHhlUUl5?=
 =?utf-8?B?NGdGeFdLWjJWRHNQOC8zdnZKSWtVUE5Nc213VmRXSVBpOWl2c0VzRmlxbzhE?=
 =?utf-8?B?WnBzR1l5Z2ZJMHNuczFONGdKZ01oVmZEOTlXUXF2SHRpdnVDZXVGQ00yVldP?=
 =?utf-8?B?eGcvbi9rRjQ3UXk4ZmpuTWNYVjJ5bDFlbjNheXd1MFJpeFJuMSt2WGtHclRx?=
 =?utf-8?B?aEhsR0ptNEszM1lZeVdvc0pIdzRBcTJUUzhvZHpURkNTZEtnakZYU1BuU2lI?=
 =?utf-8?B?ckNSOFlpNjZmd3pOVitnVzJ6R1gzUkVtTThrcWkrL3l1ZnRlQS9XNGgyMzcx?=
 =?utf-8?B?dG41eTVYTVF0SDJiY28zQ3pJRGFKOHUyRDZJYVJlYkdwY05FZGQxVUtWTGk2?=
 =?utf-8?B?VkJIQlJhUzFZQURvWGUycld1ZUF0Y0RMbmVmQm9VNHRWVE12YmcwMFRqWHdN?=
 =?utf-8?B?MFVuUnF6dW9NVU1xUHQzVmtJSVJwZ3l0TXFtclprUFppODVLY0NTYUxENERa?=
 =?utf-8?B?UmY5a1J5aDhhZFB0NlM0cWdwbDFib3F5eTJzbkFMUHRIUjh3OFhCc1BPYmJl?=
 =?utf-8?Q?AteJwjaK5FU0W9lWBa3ria/3/o1VzM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WktPOTVneTJOMjVHVk5iaUhNa0xSYkdvVG81MDgxU0RtWVNuQXU3WE51ZEpU?=
 =?utf-8?B?UkMvMm94aUluU3RkK0VKd1YyZnFmeHZFcjZKVDE3THNPY0EySkdFdll4R3M1?=
 =?utf-8?B?dnE1TDJvYndMSUZPY1o5aTJ5M0tTOFlMdG9tT1d4WmVYUHVqZFVJdWZnMTE5?=
 =?utf-8?B?b1UwdkkxcHVIdHdiOFdPWmh0bk95VFV1VjhzOXg4L2RsdWVMbGdZU0F4cWhI?=
 =?utf-8?B?blZIMGMwYzJsUEQ5Zlh1RG80bGN4d1BpSjJFN0o0dTM2VUhTbHVwR1RuYzJw?=
 =?utf-8?B?eWFDbGhmMXd4eHBJZmNmQkNxTkFxQmJpaVkvRUgyRmRQbjBmWDAzekZmRW1G?=
 =?utf-8?B?N0lrakNCZXkxOXZ0cHQzUjhtYlB6QUM3MVltVk9Mcms4ditVbmlDRmFlM2tL?=
 =?utf-8?B?Ym9oci94Yk9reUE5QmQ4UVo2YWVWeFF1NHk5a3FQdUJxdEhXS3k4ZmFYdHM3?=
 =?utf-8?B?ei9uMlYrNVlLODEwbFVNMVJKVWl1REVoOUtYWDNMTDYwR1ByV3M3STR4VmRE?=
 =?utf-8?B?OFRLUm13M2JWM0p4Y3plaUNGeFh4ZnFFSlRaTTluR2lrN2djR1NmNzI0dTVU?=
 =?utf-8?B?SU1lT2xBam5Zdm5sOEFKdVFqYllCcHVMNW9KaFZlY2RyZHU0THgzZ1k0cjA1?=
 =?utf-8?B?TXhFeDU4UTNDOHVqN0dLcWVTblp2d1I0M0VGckM3eTl1cmd5WnB5b0gvRGtI?=
 =?utf-8?B?NFRGNkt6NnY1ZFlDTTJDQUx5UmpIL3FaOGo3bzNLTWNEbU1Mc1V3TWNCVWNM?=
 =?utf-8?B?cUhoMmpNU2FXV2RGT1VIU2tuQmY3TFlOT2tzV1FxTVl1dVdlU1dRam95aVdL?=
 =?utf-8?B?UUczempOZU81VHp4Rml5d2Z0aC85SHBZYTNtRStZVHZhWmppVGxhR0JydlFT?=
 =?utf-8?B?REFEZUZoTGJMMnhtMGVKbk5VMWRGTEkraThkVVBmRkl3RUlURUJacUg1NFlZ?=
 =?utf-8?B?NkdOdU9Ra1pHMjB5NExtZWZzY21EdEZSemhXb3E4RVJEU3JHdVhjcFVudG9F?=
 =?utf-8?B?ck81T3JyY2NjcFhyaldtdmlCeFNibm5xM3VKRHk3Ny93SklDTlY1R28xQVNw?=
 =?utf-8?B?NjJkcW5wU2dxRnk3eTk3NmZERmgwdXdxTmNaOFR2Yk94em42YjdFRXNKUTZz?=
 =?utf-8?B?S2FnRm5zZ1JGZDY5R1I3Mk9wK3NUaU52V1UzMml2Q3g0bm1iUVpCbWl4Q3lY?=
 =?utf-8?B?YVRGbXJyTlorQWhNWG1IWWd1SWcrZk9YViswL3R3a1lNTmYvNkd1QnlnalM0?=
 =?utf-8?B?YW9vd0o1cHZKejBsVFZrYkJjY1VxV2xMSDA5MnJFblJlNXRLMVlvU1lUd0lu?=
 =?utf-8?B?anRLcUFUeDZsV0lZTUR2RVM2L1JCc1E2U2t5NHNkZmw3T2h3OEErTjQyMVJH?=
 =?utf-8?B?UG44UzJZcEMrMkFPNS8wdjlqckxESyttaDRyeDd3V1Iwand4bzVNY05EbjNK?=
 =?utf-8?B?aGlSdmNBVUJ1eEc3bGtGS0gxdmhzU3N1MFUrQ0QyYTAzajNnaCtYTWN2eW1i?=
 =?utf-8?B?SHBRUXd1UlpreGdvTlVPUE9XM3VjWW5CeHlUT1ZvaDByMTJwUW84UXh5RWlD?=
 =?utf-8?B?K1dERlVYbkFnQzlLTVRjUUt0Y0J1V1VIYTVpSjV3TEdhV0hWWXlaTE5POWUw?=
 =?utf-8?B?TmJQbVVlVjFHdUU0di9qTnpGM29lcnBlbmZVaDM2clg0cERMeWRMQktkcVI4?=
 =?utf-8?B?RUpjREVLdll5OVRJRTgydTFNSXRUL2c0YnJZNU43Zm5hd242ZkhNaGRCVVMz?=
 =?utf-8?B?SlA2SmZTSUdmQ0pHbFFJS1FFTTFKVkxaUGZwZk5PaXV2RDV1UkluRjZjZFV6?=
 =?utf-8?B?WkZDTEwyb1lMS2tDRm9WRVRYSDZrZ2VQNW5UL3pFb0x6TUxXZ0FGMm9GL0p3?=
 =?utf-8?B?S2pXdkRTNFQ5RHd0SWhWQVRPOUZUSVhMK3BpRGhzT2hjbUt2OVZ1eHY0QlpY?=
 =?utf-8?B?c0EvSkl4UnBsd0lUZ2Y3c1dJY2g4STB4YnMwZ2UxbnB1L1Q0eHBQVks0aXA1?=
 =?utf-8?B?S2VFR3NXZXNvbGEwN0hFQjhTSXFTaTdRazZLTlhKV0YvQ2Y2dWxOK2p5L2lK?=
 =?utf-8?B?eXp6RGJudEc4a2tlV2RDbzlXQmNtZ1h6WTd3bm9qNDRmUWlEMjdUcW5DbXVI?=
 =?utf-8?Q?YbHLpp1xsS/OZTuNlc01w5vkQ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DAD5ABD3872B694C9BF86E2991CC2603@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 308b4978-7ece-4549-7dcc-08ddc89eb29f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2025 21:36:48.3140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B7JM/Q9YcB0RR2ceSyTlFl9wcpYZxZh0s7Gl5J9jSUclYeyAmbVjToWMF9Rk0IrrPfhWw4NrKCImhB8DwmyGDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7308
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA3LTIxIGF0IDE2OjI3IC0wNTAwLCBUb20gTGVuZGFja3kgd3JvdGU6DQo+
ID4gPiA+IEBAIC0yMDQsNyArMjAyLDcgQEAgU1lNX0NPREVfU1RBUlRfTE9DQUxfTk9BTElHTihp
ZGVudGl0eV9tYXBwZWQpDQo+ID4gPiA+IMKgwqAJICogZW50cmllcyB0aGF0IHdpbGwgY29uZmxp
Y3Qgd2l0aCB0aGUgbm93IHVuZW5jcnlwdGVkIG1lbW9yeQ0KPiA+ID4gPiDCoMKgCSAqIHVzZWQg
Ynkga2V4ZWMuIEZsdXNoIHRoZSBjYWNoZXMgYmVmb3JlIGNvcHlpbmcgdGhlIGtlcm5lbC4NCj4g
PiA+ID4gwqDCoAkgKi8NCj4gPiA+ID4gLQl0ZXN0cQklcjgsICVyOA0KPiA+ID4gPiArCXRlc3Rx
CSRSRUxPQ19LRVJORUxfSE9TVF9NRU1fQUNUSVZFLCAlcjExDQo+ID4gPiANCj4gPiA+IEhtbW0u
Li4gY2FuJ3QgYm90aCBiaXRzIGJlIHNldCBhdCB0aGUgc2FtZSB0aW1lPyBJZiBzbywgdGhlbiB0
aGlzIHdpbGwNCj4gPiA+IGZhaWwuIFRoaXMgc2hvdWxkIGJlIGRvaW5nIGJpdCB0ZXN0cyBub3cu
DQo+ID4gDQo+ID4gVEVTVCBpbnN0cnVjdGlvbiBwZXJmb3JtcyBsb2dpY2FsIEFORCBvZiB0aGUg
dHdvIG9wZXJhbmRzLCB0aGVyZWZvcmUgdGhlDQo+ID4gYWJvdmUgZXF1YWxzIHRvOg0KPiA+IA0K
PiA+IMKgCXNldCBaRiBpZiAiUjExIEFORCBCSVQoMSkgPT0gMCIuDQo+ID4gDQo+ID4gV2hldGhl
ciB0aGVyZSdzIGFueSBvdGhlciBiaXRzIHNldCBpbiBSMTEgZG9lc24ndCBpbXBhY3QgdGhlIGFi
b3ZlLCByaWdodD8NCj4gPiDCoCANCj4gDQo+IERvaCEgTXkgYmFkLCB5ZXMsIG5vdCBzdXJlIHdo
YXQgSSB3YXMgdGhpbmtpbmcgdGhlcmUuDQo+IA0KDQpOcCBhbmQgdGhhbmtzISBJJ2xsIGFkZHJl
c3MgeW91ciBvdGhlciBjb21tZW50cyBidXQgSSdsbCBzZWUgd2hldGhlciBCb3Jpcw0KaGFzIGFu
eSBvdGhlciBjb21tZW50cyBmaXJzdC4NCg==

