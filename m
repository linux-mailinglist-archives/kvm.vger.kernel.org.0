Return-Path: <kvm+bounces-58346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02F1BB8E946
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 00:53:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B249A17AEB9
	for <lists+kvm@lfdr.de>; Sun, 21 Sep 2025 22:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D192C285047;
	Sun, 21 Sep 2025 22:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n8O2rCsM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A8E1D5174
	for <kvm@vger.kernel.org>; Sun, 21 Sep 2025 22:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758495175; cv=fail; b=hipxYI2JVr9GeVF++X/7yeCQsQDtCmb2knbB9ZZyEv6PWOoVosPt0K7/rGzG/vf23om2YbGFLRtb7cY96W1yG1YMRoTJAvVms2HgwRnRbV785Bz/fh92s98QvbSCzeYPIHyM5LoJAWXMKCb0iw5/TEgb1I64KcFW/qPyzmTSTrQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758495175; c=relaxed/simple;
	bh=7tqy9+/cLCB5kU1NUx429LzwCyxgpsHP+aHCjfF8UkM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IwvToGmCJb3kYKrPU/x6CGE4BMUayQnYy/t4xGRAkD/VGB+6taBlYYZmKpKCr9i1u9tZSpv696HPMuxg+Pq26uEidXBeciskV1+TQCKaHR1jntdN98Xuz1R6sO3hTJtuJczkaVOVWCsiIXOgZrgtL9rlnWE6bML2YWyoCU2Nh1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n8O2rCsM; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758495174; x=1790031174;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7tqy9+/cLCB5kU1NUx429LzwCyxgpsHP+aHCjfF8UkM=;
  b=n8O2rCsMaT6wd2sy+cxYM9/O4V3k0HqpMiMIqJcgqmgBxmb49IQKcGVP
   dm4TyP30wsOoLhKkb9mNaYp+u7FKezEplcrGE7DZXdwNs+RNGCdJfwilr
   /uvdyg0tOdES5e9XiOvVaHWYlEPcXDLXbz7r2pymRByob8Vdv8R7TnoqQ
   BvsEmxjJ5yhmgKMl8adhERzCrixA8xAT9xDBTY6b5atuJqXVyoG7znGH/
   DJOcAjCeWGy72j3+FTv7fRST2uVSlkU+su68KbIVPrKNCqTcN6kVtImio
   JImsHDZYJ843uhTyJMgLMMwcK1Qf0/zFicFWGxxYnKTFi42UdEni2iSdV
   Q==;
X-CSE-ConnectionGUID: 8Rnq+bKlSwKR8WH5dVujdw==
X-CSE-MsgGUID: RiAe1f//R46vmi23ER6Nmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="72182675"
X-IronPort-AV: E=Sophos;i="6.18,283,1751266800"; 
   d="scan'208";a="72182675"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 15:52:54 -0700
X-CSE-ConnectionGUID: fmazNEZwSROEvpy+TPeKvA==
X-CSE-MsgGUID: W1O8d7G9RsGF3Z9LsX2Q9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,283,1751266800"; 
   d="scan'208";a="176154028"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 15:52:53 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 21 Sep 2025 15:52:52 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 21 Sep 2025 15:52:52 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.36) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 21 Sep 2025 15:52:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vOtd+97obKzd2kNkFKDR/1LyjV6FPF3CbbRPoSlskNI3r0FK0QD0fyfl+g3zC8sdBgRQSsojEW/7+qmGfl1xF3L7BmV5QPz0xJZcRs3EKBLcx+9cE7B5NuODxhJQY65aBIrUfdHW5K+3ioort8STi2s6DYlBm3AsJFqLaqY+osYsrWICVhVfaxpzJm+/JmBoOWJRrQ62G5xxBKAUwTMiOt32HWfF4XpdeDvzGNiHWxuCbaIMF2ZaSWMrE0ifg0DtlN15ArhB0YYyACaCPbpZ+ZZVctz2c8geN2pu9CkfAuxg1bjscQCOmKM7sx0hQYjS5Ft8KX1Dy4JoH7SRrwiZmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJ11VCYFDbCdI5VgPQH9S57dvUiE2YdC7o5U5jAeBYU=;
 b=Xy+B+Q+Md2J612FlcYulYpEXdVtyvdnj0/jR902sXswu4pzqaQXIS1amKu9okbEn6hEjW/TY+mIbGKDVs/AzrF5Mb1D8mOtDKlmV3fWTmOJPtSBX8fNF94dQozjnsWF1f6NsqYLjMBKoDzxC1kNvRluv5JFUtwHcE4hjfs+kiBGUvgHa1tR6rX6HIkjgexJDCiATy0IIEiF8wlxE5kaGul5LmaT48ycrAYgXRtKLhoP3mxYI5lxRY/LU27rJDu3IKphec0Puath4bS8SZ2J2F2qnK3+5npCIUjX7Y8OP6qsHwM92sBQMFz4wgRAeDvIHKM9SgT5wJwH0bo0QvTE7NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CH3PR11MB8548.namprd11.prod.outlook.com (2603:10b6:610:1ba::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.14; Sun, 21 Sep 2025 22:52:50 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9137.018; Sun, 21 Sep 2025
 22:52:50 +0000
Message-ID: <ca1f0d63-1b8e-4632-b37a-5c88b236ba02@intel.com>
Date: Sun, 21 Sep 2025 15:52:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [Discussion] x86: Guest Support for APX
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, kvm <kvm@vger.kernel.org>
References: <f388d4de-4a16-4ba2-80ff-5aa9797d89ca@intel.com>
 <CABgObfaHp9bH783Kdwm_tMBHZk5zWCxD7R+RroB_Q_o5NWBVZg@mail.gmail.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <CABgObfaHp9bH783Kdwm_tMBHZk5zWCxD7R+RroB_Q_o5NWBVZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0026.namprd10.prod.outlook.com
 (2603:10b6:a03:255::31) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CH3PR11MB8548:EE_
X-MS-Office365-Filtering-Correlation-Id: 5095d8f2-0748-4fec-8a31-08ddf961970c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WG9rMWZURmVBKzhUY0ZjR1ZjQWVwZmdDekhQeXhHMnVlVGlYZm9ZRWNCN09m?=
 =?utf-8?B?bmNhVDVTOFpZREk2dFNGTlJXK1BITFB5b1ZVK2VHK0N2TTBaQXlTRmh1WW11?=
 =?utf-8?B?NU41ZG9PblFQVzRSNGVFQnpqazZZcWo2WXFnbjJEOXp6NUFUTUhueGNHcFFl?=
 =?utf-8?B?cmVXeVFGY2lwRzBQUzJvVkxDRURpNHM3MlAwalh1OGtWd29zOGU3cjIrdW12?=
 =?utf-8?B?bU9sbGpDdXNnNDZnb21ocWg3dWI5ME5rakRpeW1aeWhreGk2Q3FpclA5OUox?=
 =?utf-8?B?WHB0cXJKR0JJK1JFNTRtUjRBaE5iSjdtdnFTUllkMlVlN0JlaTBzSXhtUzVa?=
 =?utf-8?B?a0xnOTM4U2cvUnpGd3g3WnFhbnI5NmJTczhITzA2b3BaNzJLaXhPdGtZc1pM?=
 =?utf-8?B?a0VYY2hHUGN1cG1rTEMyRm5Zd3RFN2krRFRFRHdvb1NoTHBPY1VGNW9mZDU4?=
 =?utf-8?B?Nlc4dDZKY2hKbmFPZUk1SkpZQ2RuV3dESmZsalY3TTNpYythdGpaNHhFbVpX?=
 =?utf-8?B?bEdUWFo4bU5JNTdGcXZDbFRZbUJGeEVoOWdVMzg3TUxtME9oaXlQSG9WWGk0?=
 =?utf-8?B?K012KzN3OHNCVkZoYUo1STEyTmUwanRiMG5lQ1E5M3FhdEJhWWZGNlVOR2RJ?=
 =?utf-8?B?LzJCMHJvSWRKUm5jcnU4d1VCVDlNM0M0WXltUGhEVklOLzZHUEIwbEVHRUth?=
 =?utf-8?B?WGttRHlvR0x4RVMxSk1Ob2ZJNHJ2bU94OVpNWmc2Q3VRaFBLTlFJVVUrVnI3?=
 =?utf-8?B?OXR4TVdHNG96ODZaRWw5MG83cVFmd0tqbXNuWlBJeDF5dzU5RHVjTVg3aDdI?=
 =?utf-8?B?M0xWWnV4UmtPc2NpRnA2bHNTTHM3V284VTRDWDFuOTJNd2FoTUpvTTU2bGtQ?=
 =?utf-8?B?M3E0WHdvV3NZU2psNW9NVmIzWk5IZkgxRWpXazRpbFg1ZG1DcW1VdlU4VXJN?=
 =?utf-8?B?QjN1eVBqRHFjaytRMXQ1bjY0aklYclZOR3dSYkhzR2dycmlUS3FMeXBlb0Fl?=
 =?utf-8?B?THFwZEFEYUZoWGJ6OHlwcDJCZU9yU21NMVczMXR5UTNNdS9Ua0k3SUJ0VEdm?=
 =?utf-8?B?WU5YK0RzOHo1R2JOaDRtZk0yajVMR3g5cFNySkNOd3hvWnZBZkNUK1JOL2t1?=
 =?utf-8?B?NWJ6ZlBCZ2FzNFdMTVA5ZVRuVml3M0hHTWRUTEdzdmRuWGtXYmhDOFRIckVT?=
 =?utf-8?B?RUVpaXlaalkvVkROWlRwNzRCdCs5WUNHanlKU2lrdnA0cnZYR0xnNm5HeWcw?=
 =?utf-8?B?ZHBhVjVHdmNsNUVUUXJCbXNScy8vaXBsdWdNRHg1OFlWYWFxQXBXY2MxeW9v?=
 =?utf-8?B?alNFcVg4SG9jSUVjQjZOblB1UEF4Z2dWWkZrUUl4ZmNIWTBLak0wUkx4OUdM?=
 =?utf-8?B?ejBzQjZHckY5clB4QS9TS2xobUUvaXJXdzcwMERIYkJiVUZZYSs4NHgzTUFr?=
 =?utf-8?B?Vk9MTDgxYWZRTkFpZ1BXWGRTYUFGYzI4YnNFVWdqS3RsZ3FpQVJvZm1iNmpV?=
 =?utf-8?B?akZ6UytqNkpHZWVhRm1PTTRFZFNQOVNxWnExc0lzT0pZQTAxTm1JcEJWSm0v?=
 =?utf-8?B?Tkl6am5qMnVyMmVTdEQrUGxmenhJZE1SYkxvWTh5OWxIWUdURENGRXdtb29J?=
 =?utf-8?B?M3F1N3h4dVBkcGZ5RzdOSGxoVlhHQnIrK0phTWxLZUdlcDg1QXlmY3ZEYzI0?=
 =?utf-8?B?eU5BMTk4WmN1K1B0UnVhdlRwVEQwdXZ0VGprS1ZOdGRSZzR2SDJkNmJsWjgv?=
 =?utf-8?B?aUI4aEY1ajNDS0R6ZnpuWEFNVDhuRlI3VE1Nc3Q4cmZpUDZWWHMvUGkrY2Jv?=
 =?utf-8?B?RkhhTGpLa1hzem5kYVBTaEZzRWVrVVdqZ3hhVUNmRnhyano1QlRUZDB0dXpS?=
 =?utf-8?B?RC9LV3d1T2FyS0t5MWRoR3M2eWI0OXk0VUJWTy92emM0cld0QTVoQ3ZHVDQv?=
 =?utf-8?Q?MhS8kODBuZs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L01mSEFTL1Q3aFZjRksySDJ6bHdTNlhjUkdBK0czdGxWYnlLVEhNeDFRVmo1?=
 =?utf-8?B?c0VoRko1VnpuQmlNWlUvREJMUjZranFSb01ZZytQbWhNV1VpMVo3QVBoOHFo?=
 =?utf-8?B?RGNLbXNIWUY1TkROQzZtckkyd0ZlQm1jSTVaOEoxcXVmMWl5Q1BIRmtVYjU0?=
 =?utf-8?B?b0llZERhN3VwK1dDTXZHNVYyRXJsVldDZDZjTiswKzlmWnR4M2lMdkNkU001?=
 =?utf-8?B?a0ZYc0JzZ2lkZjFXRXlzRldzbUdsTWduYVFTQVVFQ0dkRXIxeGpEU3FXNVJr?=
 =?utf-8?B?MHBBMUd0T01zc1VOOGg2OTZJWVFpcGRJMzZMZDRtbHMrQnNCOU0yRGtqenR5?=
 =?utf-8?B?VHY1Rk01amJKYTRGcEZReXVsa1ZBUUFDa2wzVllRTFlZeDZhMkJBc0wvYUhH?=
 =?utf-8?B?Y09XWVN2MmxlQWhVbjk1R0k0bXRUVEJCdjV3S3o3ZXNNN3RJanlJdFg0TkdL?=
 =?utf-8?B?ZnhyQUhHcFhKdjJwT1QrQzRuVStLVTMzNXdKTXFyaE1zaXdtRU5RWUdzaU0y?=
 =?utf-8?B?UWVoc0hvTXJKYnlXbVpoNEY4d09XTTY1WGk5MkFkSDV6dWV6aHhTb3hKdG1l?=
 =?utf-8?B?L3dGSWZPM2dCZGV1VnJCQ200TFdvMjRWbmhBNkk1WG00WEovWlF1WlJuWmgw?=
 =?utf-8?B?VHp5QzFWdnoybkhIdkFNZFJYUDgyQzFmS3hZb1I4T2VtWUpFV2h0NjYwSnRW?=
 =?utf-8?B?dnUrQ1ZHOGVkMDhuU0M2UzBaYS9IeHhXTE1vMzl6UTZTTXh3c05RbjBYWUlM?=
 =?utf-8?B?ak1jd2hSREJJUmpkQlh6QXBsbnkxemdjVVVtTWxuV1p3YjBnelBwSjFaSjBT?=
 =?utf-8?B?RXhVdC9pM1dKUDdaSDNWdDJ6R1FFVC8wejNMbFA2VjBzQ3pZTnphZjZnMHhV?=
 =?utf-8?B?eFFONldrQWs1UGZaUkpnV00xZ1pDbEQ1aUM3OG9MRDZsbEE3TVYvL2VsanlC?=
 =?utf-8?B?ZnY4b1YrV2UybzY3SWtBMGRGVTlvbTc0bkozSmNhak1QTTExNlFQall6cU5W?=
 =?utf-8?B?cTRCWmNRL2JqUno2U3I2SWZPaER2UmNDQy8wL2RuR0tZK09RZEMra2w5Ky9J?=
 =?utf-8?B?S2lwdU15UUxUNFc1T1VSZ29nWnBFT2o5SWUybGhiUk1KY0pQY2NRa3VaVzZX?=
 =?utf-8?B?T01YTDE0eENYV1NCMkV3VUJzbklacFFLaFhEeE1EcWlJS2tpTm9meEE5Ly96?=
 =?utf-8?B?MEN6Wi9GSGVMelVWYmN0SXNLYkx6QlVZQU9XbWMvczU1RHprSEJJYXZUeXVt?=
 =?utf-8?B?dm9PYWFoaHVDNXc4MSs0akw0Z2k0QzVCNXVLNXVWWGp4OGFweWIrMnRMT0Vs?=
 =?utf-8?B?YldEL3BLeG9QTDN4a1BJS1RLSVdRUy9jRm8yNnJnKzFvTjBCNndsWTNBbGdG?=
 =?utf-8?B?MEF6TkdDd3NuMDVWZmV4TkEwRWs2Z0lKamlmcWlBcmo3QzlBTURQaFp6SDNO?=
 =?utf-8?B?TXg5cytvU2RXaTdJc0xaM01Ick5tcmJZTFlQWVdvWTdvTEJtektBL1ZSMnpp?=
 =?utf-8?B?S0J1dUgxOXUxc1pFS3Eyczlqb2FtL2VWcmkwNktGYVBSRkdtTytodHNycFZq?=
 =?utf-8?B?L3VqdEt0N0w0bGlqUmZVQ2c3WkJPOTh0RDRTR1UxTzFHWVBRZVBRaTZOcDFl?=
 =?utf-8?B?Uy8rY0Rva1BEMDQ2MkM2RW1KUGRaT1ZWSWc5b0djRVhyVHBOWmxLN3lyU2Fz?=
 =?utf-8?B?dUVMQXBFVm54UTlqYW1RMUZtTmZXYmtBUTdFSGpKc1FNZnBqRnRyWUhuTzZO?=
 =?utf-8?B?dExOSjVHK0theFUwSHdBeUFyWFJLMi9ERWZNTzV3OTNCeDRKTlA2bXdXaUg5?=
 =?utf-8?B?OTdQd3RHN04raE5URVFicUtFNjJvVWV1WHRBaGdrQ1pJMkp2K2ptdGFDOHF2?=
 =?utf-8?B?RWJCaGpvNkF1S1VnTzd3a2t2S0p1M1JVK3BIOXg3OXdkYStBREJabEVrdU5j?=
 =?utf-8?B?aFNBTHB5SDJFYml5STExM1Q3cC9yVmdLakhiVTFOM2YrbnB4NjhPL0g3UUEv?=
 =?utf-8?B?STRucUI4T3ljcXRMZ0xIZlFkRk51OFZQQzBQbDVyVGwwb2c3Z3YxR09sVlBP?=
 =?utf-8?B?dGRTR0dvWklGUXZEVEpzOFJlT0lsQkNyNi94Q201aDI1OUNjUHpVL2dneGgw?=
 =?utf-8?B?bUU5YmE4T2Q2SS8zdDY5S0lVWTZGd3lSME1ZcHNRU2xBV2EvblBFMjB0bHI4?=
 =?utf-8?B?S1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5095d8f2-0748-4fec-8a31-08ddf961970c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2025 22:52:50.0717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 72pubVWp2SL/sAoQtIE/7L+VyyJv0n9MgXmjaRtuBv64PK++Xr3Zv3ZquJwblPQi/VchenrQOIO7CG3BMKuqQ4f8ozIlw8hNkS3IUW20TPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8548
X-OriginatorOrg: intel.com

On 9/19/2025 3:13 PM, Paolo Bonzini wrote:
> 
> You're right that gets very complicated quickly, while most cases of
> MMIO emulation are for legacy devices and R16-R31 are unlikely to
> appear in MMIO instructions for these legacy devices.
> 
> However, at least MOVs should be extended to support APX registers as
> source or destination operands, and there should also be support for
> base and index in the addresses. This means you have to parse REX2,
> but EVEX shouldn't be needed as these instructions are in "legacy map
> 0" (aka one-byte).
> 
> At this point, singling out MOVs is not useful and you might as well
> implement REX2 for all instructions.  EVEX adds a lot of extra cases
> including three operand integer instructions and no flag update, but
> REX2 is relatively simple.
...>
> I think pragmatic is fine, but in some cases too restrictive makes it
> harder to track what is implemented and what isn't. Again, see the
> above comment about implementing REX2 fully while limiting EVEX
> support to the minimum (or hopefully leaving it out altogether).

Thanks for the guidance. This makes sense to me.

I think the high-level direction is clear now. I'll prepare and post an 
RFC series, once it's ready, to walk through the details.

Thanks,
Chang

