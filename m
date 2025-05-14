Return-Path: <kvm+bounces-46548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28D5CAB7805
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:35:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A60984C748B
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 21:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43369221727;
	Wed, 14 May 2025 21:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y/KaleXK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82863140E34;
	Wed, 14 May 2025 21:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747258503; cv=fail; b=HAuyN3garDk8qbuK/+TGnQ509EfMW/h0sGlVc4m/iXOo45rfUQHo3Vg2mmIbXjXcBZ1/a+iq3TzrlQXI12R9JJzTEjiU4O0VP5PShXOL3rGWso9Xs/5MEdHasiSkPPJXpfo1OZs+cxRd7VEzt/ap38AG+Lyvklxu5dM278VtJbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747258503; c=relaxed/simple;
	bh=/+2+/a/Sk6LNjFr4CEm3cFYsKDwVJ7grE5UGh+2DW28=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TkFoi9CYp2Sa2lpDOV2evpPNiW8sT1LAHgGcrpBYIRFnHfIbae9+C1CTsggDJmPJJSHksDB2ft2LOtV1OnUn3G0ak8o4d335P21poi6rX+1GT7RaBb2uen+wxhAhh52O+uq2AWlIjoHd4IGAQWel9nIbIFSLYjtdkHP4ZW7aosw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y/KaleXK; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747258501; x=1778794501;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/+2+/a/Sk6LNjFr4CEm3cFYsKDwVJ7grE5UGh+2DW28=;
  b=Y/KaleXK/IsGx59gn6scWQ2tNtMfZTBgOjHH3gJ47W5qGz2YHN9cFDZd
   LNBob3sWmyDaJr74C5mQAlYbYu5ix1if2Gz9m0J195FA4JAOw8XDoh/M1
   s09nHGsMAffFkS1LZiEgNmT5OFn1bEjBW7CeQGib3FLupzPGvSZuHwuWX
   37HICm57cXdZMCcAOtmGrDXB3nkC+wE2YoN4lz1o15UKzSwEKxJZf5Nyy
   9rhKT8Zh2OvcE/bwNnxqUopCShoMwSi6Mpj/Cz6agrG5EhvjvqQCLymys
   hWomc6A8/EiqlPTDUXs065rq0RzWfnqU52K9OekRXJXasFOzSZ/SLeyhK
   w==;
X-CSE-ConnectionGUID: RjxACrj8T6SengJSJr4t4A==
X-CSE-MsgGUID: acA/WWcxTtecEtCXhmGQbw==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="49043554"
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="49043554"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 14:34:59 -0700
X-CSE-ConnectionGUID: hCCoxrkKQZCQ8cknKSLtpA==
X-CSE-MsgGUID: 5AKAItF2S7yNLW253I7YYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="143358836"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 14:34:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 14 May 2025 14:34:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 14 May 2025 14:34:57 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 14 May 2025 14:34:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dbm2ETlsXLDgmnQQUFR2fD/L7rVZo0bKo5IgJ4H/cZlxP0j7z5BUO+pnq+8r4rNtwCYBZx+ZKto1Bt9qpSnMOXh/ecFVHT3iruqBIxqcji9x0W+CootIOOSDGwkZjA9gWxOQOdBSVMOpjv5NWstgv5CKlz/rHi+nFgz/dS2Yvsb0ZeMfnMAtNc7wFP/KwQexI8afi5veA4LJVIsWP72CibOcj2hA2uKONWeDwi9qBj0IPzv88f5upwR+MFMs98z0e6vAl5o7uhnDTjQWMKfQ9nqqNQxc3woqKy2uAOmaeutghDYnbsLtFHKh783Ge/V9+1ZvfGJ0tmoV1lOuak1UjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I3yJuNkQCrcjXxHcuKBesOUtWnDZhxLush+DNsQGMVI=;
 b=Jy8O24YpzvTXkF/jAyAJnGxPZ4ITYKOkpUOYxNB36vchESnYWUTrtVIYFJsdSQDUWdyDEsN40jny/Ux3Ld9u6WFv7SZlzW4e+SEdfVjE08n8hecr/wrEF1pU+C3Yes4ALZIYujP+KmymOWqF/mtjQ1TMj9whP2rsO2a0vt2yJTrdle1e/mjr+Z1uSbjs5vYQXHhqMfdwDp9c3LfH6Hh20/MR1bdSANIf/jUVmCJHdyodKmvlIZxcUCeF9VacHzNXckR6WUJi/2BUY45uTr/a7Z2GqowYIDWF5OP6QQ9ytNYogg3AlNlvlsH+35d68mIdFvpB5gkMv+3PuDPj2zhfRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by CH3PR11MB8441.namprd11.prod.outlook.com (2603:10b6:610:1bc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Wed, 14 May
 2025 21:34:51 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 21:34:50 +0000
Message-ID: <e12abcca-b7b4-404d-b379-8636e5b68813@intel.com>
Date: Wed, 14 May 2025 14:34:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/9] x86/fred, KVM: VMX: Pass event data to the FRED
 entry point from KVM
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Peter
 Zijlstra" <peterz@infradead.org>, Adrian Hunter <adrian.hunter@intel.com>,
	"Kan Liang" <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
	Zhang Rui <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew
 Cooper <andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
 <20250513203803.2636561-2-sohil.mehta@intel.com>
 <aCSljsvI0A-HC_DT@google.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <aCSljsvI0A-HC_DT@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0072.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::49) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|CH3PR11MB8441:EE_
X-MS-Office365-Filtering-Correlation-Id: 78238ddc-9466-422e-c6b1-08dd932f285a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MERucE0wRGhQSnpON0RmS2t2YTRlZFAxUGlFNzEydEVmNTdXdFhpQTVqLzlq?=
 =?utf-8?B?SW1wZldNYXY5cDkyWVEyWXBXYlFlUVdQQVpSdGtKMGV3d2ZidFRLQWkvVlZJ?=
 =?utf-8?B?UlZiNXFxdEZGVGc4ODRMOC85TjRkY01HcXZsT2FWb0lLWTlTb3BkNmFGWkJR?=
 =?utf-8?B?alJLK0k4UXFSK0J4M203ZWpWcVlNVHZUWW5wYithOHpaY3VLUGt6UCt1UnVn?=
 =?utf-8?B?Vml0OFR2QmtVUUpGcGZBRXd4SnlSOTkyN2MrcVFITWtCb3pudjQ3UEJSc1A3?=
 =?utf-8?B?MmlpUCt3WTJ0MFM5c3ByTlNpbkVkRUxJOTNvV2Y2U1BVcTNXbWxGMEF0cjND?=
 =?utf-8?B?ejRDWExrQkdHVUhwbm51enpoTHhnUVZlQVJPd2pDWmdRcEJaVko5blFYN3gx?=
 =?utf-8?B?R3YwaCtrUWYzUFA2WTM0aCtxajhOTndrdDlib1pRaytkTUJoVGRNVUNxbm1H?=
 =?utf-8?B?Y2JybEhTME8yQy9CMXpZRnY2NWJUa0tlYkZMWWNoWmNPUEFnOFhTbExISW10?=
 =?utf-8?B?N0t4emtZNVV6L2ova1daUUdRVXoxSEw1S3hOSk5KVjk4ZFlPSFFhWmJCeC8v?=
 =?utf-8?B?ZWtIRjdxL2tkOVJubnJxRVpiT3pZR0gvRWFvTjhVUVBJdFBIYTZwR0s1Mm4y?=
 =?utf-8?B?WFdlZk5QWDdLYTFlMXJtZC9scGlVYWtzQjVzOFN1Z2JpbVRrb0dIL0ZLeWJI?=
 =?utf-8?B?ZTFVTlJYcFlmNE4xOFRMWUNRbXpVc3h6VW0wM043YmE1UXFIcWhWN1pMemFP?=
 =?utf-8?B?RkkxYlpvY0pQMlVWYjUxaDVlNkpiSVV0S2ltNnFZeWVxUzZIaHZpMHZOQUI2?=
 =?utf-8?B?ZU5IU05MMnBwTFUzR2dabTBLMUJBRENFV2xqb0VEWHlONjVXYldaK0ZuZTJX?=
 =?utf-8?B?dHFjRkFzMEhDWTlyelM2U1QzeVUrUCtwazVBSVpoQVExMVFQSUVyL3hLLy9C?=
 =?utf-8?B?Qm40V3B6UUk2dytjNUR2NVh2b0sycWxROWpHbVZUY0F3Yy96Q1cxdklYeFlJ?=
 =?utf-8?B?ME9BTlhFYTJZSTFnUm4xQnJxOE5KelJXelRLOUViRitjaUhyRVVmTlduY3Fk?=
 =?utf-8?B?NWVUdUJwR2g2bEorUzUzYW1ndHdlY3FLRjRsQWh3YzY0Z3UzUnRsTzlibE1u?=
 =?utf-8?B?M0Q2UVBFMWh4QnlnVlRpZmt1S0JNRkZPZGd5V3ZGQXEzelNZbDhVaHRoVTkr?=
 =?utf-8?B?b0NENTIyNXJ5YmF3eFJuY0VFdnlBMk1KRE9mWjBJZk9MdDAvK2dod2lvTkxO?=
 =?utf-8?B?TlZDTkJXcFBXSnN5azVSUjFqbDBwekZLVU5vN2xtUUphcENjeEpyTmdpSERX?=
 =?utf-8?B?YlJjTVBIZEtDb3Vnc2xCSGE2NDhON2xEZ3dIcnQ4Y2Y1aWh6d2JIT29mYjlQ?=
 =?utf-8?B?Z2YwaEhvL2w5cFlSV2xabC9lQ010c0NocXJEVThSRmRqeDk0M3J6SGpvTnlQ?=
 =?utf-8?B?MjRjQ244ZEFzWWNuNVhTK1A3bzJOamFMYUJQWU1wNG9hSllJOFY3V2VHRmZ3?=
 =?utf-8?B?OUdzUFNXcENMU0s5eW1mUGx0VG9nQlBwSU02V2dqblFLQ0hQdzhJM2FYMWcw?=
 =?utf-8?B?R0ZpTS96bk1lbWlCYnh1aFRxQ3JiVkMzVEFJU1VvMVZBTnVJN24veHFIMUtt?=
 =?utf-8?B?SjdKWnJYc2REOEN5YzhqM09qalk2amd4VWsrMC9xNTRIeXVsMk1wNkFxYWM2?=
 =?utf-8?B?WmltQXVyT3NSV1o5bFFFSFFhYkROQmYzeVZnRlJYNnVDU0FKN3dGeEx6REx1?=
 =?utf-8?B?eGdRb0hEYXlMcGFJdjdLZk9hZ08wS2RQM1gyY29lQXFDN0RIalNYejg5aXBG?=
 =?utf-8?B?dGVsdlRtMGpuKzVHUFV4dVdhblE3NlhBSVdhckFVTlhxa2pkNjdRQ2pLZEdW?=
 =?utf-8?B?WWNIM0QxWU4vay9oSmhoV2FpZ0RFUTgxOEY5Z3NXclN5Ym1XMEpiUy95ZC8x?=
 =?utf-8?Q?SR7Zg18GnHM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0pjVVhmbnJDRnJDd2w4OEFXakdocnI0V2FuaTNBOTBIZW55MnY0UkhEenRE?=
 =?utf-8?B?NHVhelBsR0RVaWFzWTU1M3V5bUl6OWdTQithMDFqclk3alRWOGhSTEVudTRu?=
 =?utf-8?B?bm1Sei9NTFoxaHltZ2dBZGJocWpFVHlwMnNDTmc0VTdCMjh5SjZQNlhQZ2F5?=
 =?utf-8?B?UlFTOVFJZC8ydHZHZUpEMmJXdm9ydXdqM3N2aUN3Y1RkVjFxTHAvRTUyaTNn?=
 =?utf-8?B?Q2hyc290aWo2N1dQN1MvTWxkV3FmTlUrVm96YWcvV2dyZ1RFZG4yU2d0dFl4?=
 =?utf-8?B?Vjc3WHlQTCtzRGVXcy9YVUhHeVVId2g5UFNtYjFiWE91c24rRlFwR29OWEJl?=
 =?utf-8?B?Q0x5MlJpQ3k0NWpRUzVSVWdYMGd2YjhYQ2F4TW5BandSaXN0V2FaV1lBQjAx?=
 =?utf-8?B?THg2NEtYSjNheEFlMU5jWG5VRVY2L09zazZaekhtdmJSc0JROG5pcHE5ckND?=
 =?utf-8?B?cG5LSWVWczdtYU50cmk2NkRwS3NEUXZxVytyZURFcXFZeE1IcmxJQWN0YmFl?=
 =?utf-8?B?L2VlNW4yUDN1aWdZT3M2VEJsbVFhRnozRDFwblBEMVVhbVB4MUxINWtuYnpa?=
 =?utf-8?B?S09DejdDWDhUQm9DdE5XdUJ5UDUzOXdHV2xRNjJRY1R1UEhXcmJpajFIY3ZD?=
 =?utf-8?B?anMvUTJBaTAySmVhUkkrYnJ4WEMxUGN1eXcxZDNHMVExSVdNWE9Ta1hOaitC?=
 =?utf-8?B?MlJxNFhPTUZYK2hWZWU5WkJRZUlKOWFQY3JjcTZ6KytsMXVkUXhCNVVoNU5L?=
 =?utf-8?B?bnY1c1VWd0Q3N3A0bXNIMEs2Z3ZqUVlkV2M2aXl4UzM1THozYlphOXVyOWJ6?=
 =?utf-8?B?M1VHSThrRmdxTFlML3drUkszL0IzbTNnUEEyNmRwWGVmc2IzMmFyaWI3RHRR?=
 =?utf-8?B?SjZXa2V6MG9CUGtvOG12TmNyL2FlSkh2UTBhd2RIRFJLNHZ6THpxZzJWaHJn?=
 =?utf-8?B?NkZLSmlYeU5QMzJUVk9qM1BCYyt1YkdTb3pOVFVHWVJYaG5ET3VGQjd4MXVL?=
 =?utf-8?B?dlBaa0VxbXpydzA4azhIT2plUnhuNVdZT0h1dGNIUGl2UjVmb3lRZjh4Yjkv?=
 =?utf-8?B?aWtrQXVzQU04YXB0UlpPS0I1L3B4RGN3NjZ3cHltaitESHJVSVJJamprME1Q?=
 =?utf-8?B?MkErQWJTeWVsVjI1Q3JSVzMwVGNyWnBGYmpjcThYQ3hqMjl0RDBiOVgyYUpl?=
 =?utf-8?B?S0ZNWHVwRzJRV2ZTMk9qcWV3Q3dxeXhSbTFMMURObXAzRFFaWFZ0SEt1QXk0?=
 =?utf-8?B?U1JFUFRSU1B4eGx3eFoxT3MxYkRZMXFNSXBjS2tKVDI1eE9obGg1bzloZExR?=
 =?utf-8?B?MW9wMWpvaEVxNHNLSjVsSFBOV1EvNFg1YnlPU0ptTnRVcVdVM0tMZjRQWlV3?=
 =?utf-8?B?M0xSRUUwazRzMklrOGhDODhUbTdXZkN2QzltM0NJTUZtNTdDaXEwNXMxN244?=
 =?utf-8?B?ajYzRXJFYU92eW5lV254UUZSWWdSa1BSWnZjM0U1MGJtRG5jbERVdVFQWTFj?=
 =?utf-8?B?Z1V2RUlzbU9oNjhGZEgzZ1NvQmZESVFwNU9tU1RaUlBCMU9DLzFWRnFQT0Zl?=
 =?utf-8?B?Z01hVXkxOXpWU2dwdmdvYXpkWFVIQ0V4YWtkT1l3R0JQbGNNM2UxRE0yYmJI?=
 =?utf-8?B?N1FzVUgyMXN6dDBMRkFicVNYUkJnZzkzVk5QOHR2eVFzdlJ5cHk1OElQN215?=
 =?utf-8?B?NFhScnFuVE9BTjBMcUlvcjBlc2FWK3l5VXZyWi9URG5FQ1hoRTArVVUxMU1r?=
 =?utf-8?B?TUl5ei81YnJncDdMT21ZVDJhdTEzbmgzczdzOTRSSEZMemI1bTluYzczNXYw?=
 =?utf-8?B?NGRGa3hJancrMEFVbUNjWEVCa1JQaXFSeUxOQ0hrTWFnajdHcDJOdCtiNGNZ?=
 =?utf-8?B?N3V3cmFteWJKYTY2V1JZUFUzZE0ybURCWDRVaFhkdEh0NGtVZWpvTlBnbEZG?=
 =?utf-8?B?aW04LytvQjF6eFpHdVZlS0FTRko2a29vSDF1eEwwT3luSlpWVVd2cUplQ2pY?=
 =?utf-8?B?TWxHaUtDK01zOFVTcjNiSkZzOXFSbTVvMWxObXR6QUZPTEhpbkRvQ0xyZE94?=
 =?utf-8?B?WXMxLzVWdDIzQ2tTVWlkK0Y0enlWMzdUaWhFdmI4MjJndXdJYnZHaFJPaE9E?=
 =?utf-8?Q?NuDwGvdiaa2mfd3ZovcuJLBcj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78238ddc-9466-422e-c6b1-08dd932f285a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 21:34:50.7906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dngSyp7bzuMpnMxgLG2ECf+/lRlTmQoN9OQ5DTRR4tSCJA9MtniRA58Rj2ldtmp2OxY3sZfOFgRUMPWQNyZkPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8441
X-OriginatorOrg: intel.com

On 5/14/2025 7:15 AM, Sean Christopherson wrote:
> On Tue, May 13, 2025, Sohil Mehta wrote:
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 5c5766467a61..1d43d4a2f6b6 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7079,7 +7079,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
>>  
>>  	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
>>  	if (cpu_feature_enabled(X86_FEATURE_FRED))
>> -		fred_entry_from_kvm(EVENT_TYPE_EXTINT, vector);
>> +		fred_entry_from_kvm(EVENT_TYPE_EXTINT, vector, 0);
>>  	else
>>  		vmx_do_interrupt_irqoff(gate_offset((gate_desc *)host_idt_base + vector));
>>  	kvm_after_interrupt(vcpu);
>> @@ -7393,7 +7393,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>>  	    is_nmi(vmx_get_intr_info(vcpu))) {
>>  		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
>>  		if (cpu_feature_enabled(X86_FEATURE_FRED))
>> -			fred_entry_from_kvm(EVENT_TYPE_NMI, NMI_VECTOR);
>> +			fred_entry_from_kvm(EVENT_TYPE_NMI, NMI_VECTOR,
>> +					    vmx_get_exit_qual(vcpu));
>>  		else
>>  			vmx_do_nmi_irqoff();
>>  		kvm_after_interrupt(vcpu);
> 
> As a prep patch, what if we provide separate wrappers for IRQ vs. NMI?  That way
> KVM doesn't need to shove a '0' literal for the IRQ case.  There isn't that much
> code that's actually shared between the two, once you account for KVM having to
> hardcode the NMI information.
> 

Seems reasonable to me.

I don't see the IRQ side using the Event data anytime soon (or ever). We
still need to pass 0 to asm_fred_entry_from_kvm() for the IRQ case but
that would be contained in asm/fred.h and would not affect KVM.

> Compile tested only...
> 

No worries. I'll test it out. I am assuming you want this patch to go as
part of this series.

> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Wed, 14 May 2025 07:07:55 -0700
> Subject: [PATCH] x86/fred: Provide separate IRQ vs. NMI wrappers for "entry"
>  from KVM
> 
> Provide separate wrappers for forwarding IRQs vs NMIs from KVM in
> anticipation of adding support for NMI source reporting, which will add
> an NMI-only parameter, i.e. will further pollute the current API with a
> param that is a hardcoded for one of the two call sites.
> 
> Opportunistically tag the non-FRED NMI wrapper __always_inline, as the
> compiler could theoretically generate a function call and trigger and a
> (completely benign) "leaving noinstr" warning.
> 

If this is really a concern, wouldn't there be similar semantics in
other places as well?

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/fred.h | 24 +++++++++++++++++++-----
>  arch/x86/kvm/vmx/vmx.c      |  4 ++--
>  2 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
> index 2a29e5216881..dfb4f5e6a37a 100644
> --- a/arch/x86/include/asm/fred.h
> +++ b/arch/x86/include/asm/fred.h
> @@ -10,6 +10,7 @@
>  
>  #include <asm/asm.h>
>  #include <asm/trapnr.h>
> +#include <asm/irq_vectors.h>
>  

I'll move the header insertion to keep it alphabetically ordered.

>  /*
>   * FRED event return instruction opcodes for ERET{S,U}; supported in
> @@ -70,14 +71,26 @@ __visible void fred_entry_from_user(struct pt_regs *regs);
>  __visible void fred_entry_from_kernel(struct pt_regs *regs);
>  __visible void __fred_entry_from_kvm(struct pt_regs *regs);
>  
> -/* Can be called from noinstr code, thus __always_inline */
> -static __always_inline void fred_entry_from_kvm(unsigned int type, unsigned int vector)
> +/* Must be called from noinstr code, thus __always_inline */
> +static __always_inline void fred_nmi_from_kvm(void)
>  {
>  	struct fred_ss ss = {
>  		.ss     =__KERNEL_DS,
> -		.type   = type,
> +		.type   = EVENT_TYPE_NMI,
> +		.vector = NMI_VECTOR,
> +		.nmi    = true,
> +		.lm     = 1,
> +	};
> +
> +	asm_fred_entry_from_kvm(ss);
> +}
> +

The original code uses spaces for alignment. Since we are modifying it,
I am thinking of changing it to tabs.

> +static inline void fred_irq_from_kvm(unsigned int vector)
> +{
> +	struct fred_ss ss = {
> +		.ss     =__KERNEL_DS,
> +		.type   = EVENT_TYPE_EXTINT,
>  		.vector = vector,
> -		.nmi    = type == EVENT_TYPE_NMI,
>  		.lm     = 1,
>  	};
>  
Thanks,
Sohil

