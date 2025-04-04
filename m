Return-Path: <kvm+bounces-42616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BF4FA7B2C4
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 02:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F4911886719
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 00:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C632940B;
	Fri,  4 Apr 2025 00:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MBKZfU8D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE666ADD;
	Fri,  4 Apr 2025 00:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743724938; cv=fail; b=DNzecuoaJgqLpjvUbMAJsvSZeSYm/0sr76sFJqMOt3yWdE+3SObNiMAq1hED/H1NDstqUNkX63PiP+3ZtABV12GQFZvAAgJAxkBVjp+WzyGKoHBrFH9xmHeeeOz4fik2EZ6I20mdF/B1Sk+4ASS/M8uJyNbjKSbgdoct+3qe6nU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743724938; c=relaxed/simple;
	bh=G28ZNO5u+JipqXJbJvjmmCSiftccPNUyefw1ou+NCdw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Yl0ffOnVT2Y4SGGBVL9GAWuXTruvq1vwg6E1q85oH+4OAbZs2vEg8C+FIG1KPOnnUan1OjOJfiDOLoyNxcjuFSJQRbs+4durpnuJE8venTzjo7Gatc1IGzCqA9/NYxYgJb2qJan2i1ClTmB+YdZm8Bt7uSKQhpo75cT6tifx1P4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MBKZfU8D; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743724935; x=1775260935;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G28ZNO5u+JipqXJbJvjmmCSiftccPNUyefw1ou+NCdw=;
  b=MBKZfU8DSHt9gIGHkRcpTs9ae2sS0FeAQqfDnS2L1C8bIhtIPWH7fxkI
   ay1hfD3eMnjsC54JFgkPtjwbdqrCqtUZzH1QDW9EBpCPrjB2vXFs9u2Vc
   Id5XPDd0/+hoX0TOgjo4Ix4VMEzfGoWg70eNEakutqYjfJltUomzF8DbE
   Nt80m880fCtZU2JeJJq9nEGSg4lcJzxJlpwAiL+5XXr69siOcW1YbHrzf
   tMB2/k1zdM/g4kpH7F8FY32OctKFxWzJVi+u3Joei/xXJwP0kA6NuGG7/
   VRUDdDC4fryiu11lGxqUT9GYl3vcd4UzCMuHUsX3IjawWMFge9vSKt5Tw
   w==;
X-CSE-ConnectionGUID: /wMztk/WQMOUlVpwJl3erw==
X-CSE-MsgGUID: Q3ZCS+vaTlW0gkr4W3/fKg==
X-IronPort-AV: E=McAfee;i="6700,10204,11393"; a="45042170"
X-IronPort-AV: E=Sophos;i="6.15,186,1739865600"; 
   d="scan'208";a="45042170"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2025 17:02:13 -0700
X-CSE-ConnectionGUID: 1hSASYluT7itrAL0128OBQ==
X-CSE-MsgGUID: DfiYDfPrTnqd9aAYgEFADg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,186,1739865600"; 
   d="scan'208";a="131289836"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2025 17:02:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 3 Apr 2025 17:02:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 3 Apr 2025 17:02:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 3 Apr 2025 17:02:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uz0C4TtRhFX57FhFB0DSQhSgJ+QliaCKiBgKuKOU9G2KdmXFwJJ9xfsD+FmSl5d4zB/RXJTlFWnXpFzv+C/5SDKBhzeh/aAoJqh2pTvi+Tyx8l9IwO9/D1gCVVo1X2J8aPeK5JAibw+jYGUlKXvfsZ0mmMRQx2fzAe796zTL1q/PPACF8ov6DanAxnLuTpQXGMhFXMKb7Sdgt9+0GmHb/oJucr5UYcg8ydwzjlPbEYFws4ypTESHa7wqQtvR4qXPe3H7AD7UTCrgaHDN3HiPqhzTe4Qrbyo1Ar8L9stmsxRBYFvE2jpi8KquKZdFBJj2laCuQI84tEib105aQFCx1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Tm/cMFVMC/vdD1f0Jn1vC0u2+ynb6tFINR5o6bEUjE=;
 b=q/X1530dVn1TKBxbmpfjdj+JtaYBJYlJuQ82rhBh/gfEA/13lPNQK4gV65piPUoL/IKhA72FpB9zafljcV4MOH1b+KhrwtgmsB9eJVxjlkwBHsuZNuag0iW3CPypJTrF7bho/tgaX3ujNoY1+Uhs3DzaUVcdILuSUFwx+Luil/hGqAjHnf33NarlVwJiZo7VXf1EeD6hRH5PZjnTYGmgmni3nLmpa7wnw5HlYnjnoVO1zO2L9O1yQG7NipHW2nJLmdPgYzoLQcvT/6IqLdZiRBCW/ou5Q6N3zJVcwf7LN444qIGC2zUquokcyBKlkX9zyIyJhr+QKg+DMomME132dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 SA1PR11MB7698.namprd11.prod.outlook.com (2603:10b6:806:332::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.52; Fri, 4 Apr
 2025 00:02:09 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8583.041; Fri, 4 Apr 2025
 00:02:09 +0000
Message-ID: <fe730028-1861-4fc3-8ddb-6b218d5aa234@intel.com>
Date: Thu, 3 Apr 2025 17:02:05 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/8] x86/fpu/xstate: Warn if guest-only supervisor
 states are detected in normal fpstate
To: Chao Gao <chao.gao@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<tglx@linutronix.de>, <dave.hansen@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Aruna
 Ramakrishna" <aruna.ramakrishna@oracle.com>, Mitchell Levy
	<levymitchell0@gmail.com>, Adamos Ttofari <attofari@amazon.de>, Uros Bizjak
	<ubizjak@gmail.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
 <20250318153316.1970147-9-chao.gao@intel.com>
 <ec953e80-a39e-4d42-b75e-6f995289a669@intel.com> <Z+1KBN+s3CWdTN60@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <Z+1KBN+s3CWdTN60@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0161.namprd05.prod.outlook.com
 (2603:10b6:a03:339::16) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|SA1PR11MB7698:EE_
X-MS-Office365-Filtering-Correlation-Id: 2602785e-321e-4141-d539-08dd730bf185
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eUp6MFNuSW04MmNYNjJSeGR0dkJ6U0lmT29reWwxRTR3M2xxUGFBUjYvQW5N?=
 =?utf-8?B?K0YrbWE1VzBtVFNqdDI5Rzl1djBkaUhpRjZhc0tlV25MT2VtcHFoSWJscVJC?=
 =?utf-8?B?MHJabFZTdmNRQ3NZTzhCL0pONGZDVFVlWTFGUmZrTkpPQ1o5ZmlyQXgzRitW?=
 =?utf-8?B?ZlYxc3E2MXhnZXBXZXhDMVRpblo1S05IMWxZeDhlYUU3eExJSkhCaU5UZGx6?=
 =?utf-8?B?L0w5dy90VzNNZjB0NERWTXgvVFFDOGxSMXR5czBOWFFoaGhQVXJDekQ5UUZB?=
 =?utf-8?B?cHF1eDBabTQvWkI4djk2alhkRitBbUJhUmNhU3haOTMzVitEUFgxdzVaeVU2?=
 =?utf-8?B?SHVrZklBNWdOV1pCRFkyMlJtKzZDNWJKU3RneTNqSXRobkc3WGk3M2dnd29j?=
 =?utf-8?B?c1paelRZeUFPNEN3dzM4Smtjemc4U3lKWHo0RjBxa0pCWW0xdDJheHFpbHBP?=
 =?utf-8?B?QjdtdFNNZlRxRC92cTR4aGNBcjA1Q1BzbVh5UEhvelplQVhDaEFnNVBQRWpq?=
 =?utf-8?B?TlNEbW52aFMyWkxQN29DaVZzdTVjVFpiQjVyVGx5MXpPajBlSk0zdG1BTmVP?=
 =?utf-8?B?TEJJU2ZJNGp0SEllVWxzU09TbTJQajlJNE5aY2NCLzVEaUJtTFY4Y2RGd3NB?=
 =?utf-8?B?ZkJWMWxFSGVQdUFyNWNyMXhRVklpNGptTVZOb1NGNENjZ1JabUFRVTZNTjlP?=
 =?utf-8?B?bTRQcmdydXVyZ2drK1A1K2JTZWI4K3VwWk9tWG9QVWdtM3RxTW1TM1A4aWFG?=
 =?utf-8?B?K2d6Y2RXajdvOURVNnc1dzNPYUVNWGZScHRlbVpwdER5WFpXeW1ycVpaaE1X?=
 =?utf-8?B?UmV5NzRYRk04Sk9RVGo1M1haMVVDUmpJdktkM0ZXN2lRWkNRMmRGSTJZOTRt?=
 =?utf-8?B?RzlwblNuaEpxVm14d3hIQWxIN04rU2FuOElDc0wvampnQ1NNNWFlQkdMWUhB?=
 =?utf-8?B?Y0dMM3MvdmJ6SWFMay9paEtjQjRra2w5ZXBkQkFIUWdnTWZvaEd4am11ZTJ0?=
 =?utf-8?B?MW5qMThWMXdrZmkrUDd1TTZHY0dyeFhZR05RSUhnY25kVTJyL1pabEdvMFo5?=
 =?utf-8?B?eGFNaDR6MWtselFRU3daSVNHbTAyNnJnSFZyUTBBMG0rWS9DN09sdzVwNmpQ?=
 =?utf-8?B?bk11d0lVTTR3Qy95aFVFRkJ6R2ZLZ1Y1THJyb0gzZ1ZsNGQ4eXZYeDA4WXNx?=
 =?utf-8?B?Z1djbmw1emNQOGJ1UXNpRnNWMzdIWkN4QW9EcitiZlJkZDR6MElBa2Q1T1RE?=
 =?utf-8?B?U2RRQk9JdDEvWFN4ZUw4TFNGWll5OHhaZmJvalRlRHIrWlRNdmZhaEQ2NDR6?=
 =?utf-8?B?TG9kSmY4THA1TkVXd1pmV1ppZnpGQ3lYN0dUOGxKN0RuNlJVbjcvY1FBRi9I?=
 =?utf-8?B?NFBDM1JqWGNmTk9OcGo1bHdsc1Frc1V0UkhkdUROb1ZuMFhsMjZXVXJadEJi?=
 =?utf-8?B?M0tHQWVkU1NDczE0Rkdjb2s1SFZPV2RsQ0NkS0tKbFFNMnNhanY4alF4TkRV?=
 =?utf-8?B?dUtFZWY3MFBkWU5UUXVySjVHSjI5YlM2eWQvemxNaUdTM3NrM1RXclBzNE5B?=
 =?utf-8?B?VklwVGFsWVF3M0l2TVN5RkVtOS9hQ1dVS3NHcmtiVlAvVE5ybUdtZ3NQU3ho?=
 =?utf-8?B?Nm1nVUZMRFJYRzVVdGpDSVlQUHdZamlsK3hvV05nQUxLbC8yeW5aek9MeGc5?=
 =?utf-8?B?UERaamo3eUlPaHRrdE9Nc0oyQUZ6OUU0U0JIZk5rT1FEWUNod1Q2UnI3T1A4?=
 =?utf-8?B?a0hHbXgwNFFGOG1kOTdsdXduNW8zMXlGRG9TMy9tUW54QkhCdTJtb1pIUkY4?=
 =?utf-8?B?ck50YTlYTGpIRmErdUp1N2xsdHg5MUhmTEZtenpMcHcrTDY2TDk5eTE3RWFa?=
 =?utf-8?B?Smh6QkgvTmNFVXM4WTFsSk8wTGVXZzVuSVlsWGdwcURJbEEreVZHMEpneVd4?=
 =?utf-8?Q?lhAaDIOd15k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWMvU2FLcDl3TXIzUmZibUVwYlBkU3Nxb2kvVGFMd3ROYUM0TlhyUHVBZ1Fq?=
 =?utf-8?B?dEV5Wmxic2hSVzlmdTQ5QU4xQ2llSEhTRmlCeXQ0cmh1bEh3anFraUIzSFAv?=
 =?utf-8?B?WTNEREYzOTJvUFN3SFkxVHM1UVZtMk5FZ0VGYVFPNFFaNStMczJZZ2FaMmx2?=
 =?utf-8?B?dk1YM2F0RnIyc2JXbXVoT0s2S0tjK0pBNXh6Q1FmODd6LzdyR2RSWjZuL3V1?=
 =?utf-8?B?SFphS3ZpL3hsOGplWktnS2FyUVM0OCtkNjBRcHpDZzM2dXZ5TTBJR3JVQ1lm?=
 =?utf-8?B?c0Y2NURRUVF4K3kvd1Y1TGw4OVk0aHZUNHV3VkxtSlluY0dESE9DaVcybmhy?=
 =?utf-8?B?NzU3YzlqcndQRkMvNzdvNkd2OE5BOTBqcVhPeCtweTJpNDVDeTRKY0U5QWFq?=
 =?utf-8?B?K3dqakt3TldUa0ZoeEJrR2xlZEJXVEp1SFJMMlo1dHVVcmJTZVB5WW53U2pl?=
 =?utf-8?B?ZDF6U1oyeFJGNmtpZEtsQ2dRTnlLWkFRL2NLaUl0SkJnbWdFbHdUVDJZSnBt?=
 =?utf-8?B?SElUcnRkQ09Sam5aeklvMWJJTnByRXZZUXUzMUhxVG11TjFXTjNiRU41TFE0?=
 =?utf-8?B?ZFE0bHRwci9TbDlnU21jNDBJYjVIcDF0MldTWUk4SDhGUHU1MWcrY1V6SDg3?=
 =?utf-8?B?aitvcWV5MmZtRXdtREpEUk9HcUNXQzl3Y0NjRzZZV0UwcG0zUFlmQzJyN0sy?=
 =?utf-8?B?Rjk1RmRET2lHVU8rdjNkOHJHbFJadVNnKzMvc0Z0Y050b2M1QXZIbUJEeVdR?=
 =?utf-8?B?M0lDNjRxZjRRdlRYcXJsRmtORjFXa0VoMzZXNGg1bS93YkFWVmNHTlVvTnVZ?=
 =?utf-8?B?bmpXYkhVeVdNNm5NWVVETnprbmtyUkRtMmMyMEZSRzVLVDFOZThBZ0RyR1lH?=
 =?utf-8?B?emlUa2JoWnlIVzc4RjlvYWFIZU5ld0dTRWp0RE9zREUwZmZ5QlArc1FaRnhU?=
 =?utf-8?B?ZXJiVm1DcHc2ZXdZQTA2M0FGVXZOeXdaU3B5RTNaTEIraUc1dVpDSjRCZkN0?=
 =?utf-8?B?RHdhTVo0SG02cytGZDNGY1Y2M01EWXRmOUxNSVI5TWN1TnNZTEpxd2E3T0RK?=
 =?utf-8?B?anpWWTRrUVUvMUs5UWx2VzVoem1yQnhqZFZvYTJZMDBVajFOZWluaEtMK2ZL?=
 =?utf-8?B?YURRdHlkMjJKcXArb05QakdOcXJta3A1WVpmakIxbndOZkcySVU0T0tTV3VO?=
 =?utf-8?B?cTNxeE55NHZUR01MckhqZlFOalNXN0V3bVl4Q1JXc0QyTWs1MzNiRnY3SFF6?=
 =?utf-8?B?elFpdmxLUVlBQ1dzSVBMZXh1ZmdZSGwrN3hMQ0dMeGE2a1p6SUo0ZGt3QVQ3?=
 =?utf-8?B?Z0JCY1JvSUVNVGYxRXRRVTZpUVlFRU03QWEyL1VsT0N5YitLQ2RvSSttZjFF?=
 =?utf-8?B?dHBuZTV2NDhGNHpKNGdwcklwL0xFRFRrSVdGVk5sZy9lMndUOTFlVDVzUnp5?=
 =?utf-8?B?dVduV2thbnZaTUU1WkRYaytHc2dIeVJkSDVDeUpETnhyUXA4eWtLT3JMejFI?=
 =?utf-8?B?WXhLajRHVk9iS1BkVXZuN3FPczBCbEpUN2RLZ0xnd0tBSlVyRzN0SkhmMmRX?=
 =?utf-8?B?REU3cUttbVNJVGZ1WktGL1M5RVpjUStSMHh5aithT2drZDR5RFd4RVdNZGlt?=
 =?utf-8?B?dkJSTFp2YzlGNVdFUjRlQUVIQksvd1hZRkdRTGRGT3BGYjNoeEt6MkZ4VzNq?=
 =?utf-8?B?Tk5RVlcrVGptYldQWmsyRE5zOGRCYzN2ZHNLRXZGQUhpUkZ5TW1QOTNka1Uv?=
 =?utf-8?B?dXlNRTVoOGdHd1RxTDVLd0Z5VmVpUUFtZDk0SkRzWkNhMWpXS0RCUlp2emdC?=
 =?utf-8?B?THAyTWhUSHBxYXR0RG4yeFFXclYyRnJpaEU0NG9aU0N3cS9ZS0FadlplMnpX?=
 =?utf-8?B?bVV2d2EzdC9SWmNrN2pJbHlSNnhDaUFxekxYNFlYYk1JTkg5NmdPY1UrTncr?=
 =?utf-8?B?RmVUS3BXVGd5aU1JdzVlMWZnbW5UclMxMTNrL04vaXJpeGtUV3N3MElMRHJr?=
 =?utf-8?B?aHFCMm1Galc1Y2xPUDdDQnNoNGRGOW00WFpBVFdxOFJRN1gyTnFnYUFoV0R2?=
 =?utf-8?B?Ry9SR3MybW9FbTNmWUJCOS9IOXZ0RGp3TU14c1ZsL0NQclBBbytwTnJZT0Fn?=
 =?utf-8?B?ZGlWTzdIRG9SM1BsZTVSZjFoWlI1WHN3QlB0SzdzaXVINTdqTmdndUFDQ1gx?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2602785e-321e-4141-d539-08dd730bf185
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2025 00:02:09.2450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WOOSvpVdxOC9UfPMKkHbxfhDygZM12Hs+wx+c/0pcmc9gsvOyVM1kzmfMR/32q5jAJe7AwEftf3mJBWOVxa85e+b/GrTHijYSgJNoEs8PUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7698
X-OriginatorOrg: intel.com

On 4/2/2025 7:30 AM, Chao Gao wrote:
> 
> The goal is to ensure that guest-only _supervisor_ features are not enabled in
> non-guest FPUs.

I think the common XSAVE path matters here. The other XSAVE paths — 
signal delivery and saving the LBR state — already handle supervisor 
states properly. Signal delivery excludes all of supervisor states from 
the RFBM, while LBR state saving triggers a warning if any non-LBR state 
is set in the RFBM. Given this, the guard seems good enough unless 
missing something.

Thanks,
Chang

