Return-Path: <kvm+bounces-42388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 768ACA78148
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:17:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B486188D2A2
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C23D420E704;
	Tue,  1 Apr 2025 17:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BLvXoWEL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A949205ACB;
	Tue,  1 Apr 2025 17:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527797; cv=fail; b=L2RueX7/KVgKDxXY/4ezsfIsON43FgmfJsm4IIysa5YUctT8n5KqO9KVOK+zUPgvVj6c9Y35B5G+VIO8QTq3lc4M1F66qie+Y3t34ifKpKIZ4IiJdNtbSSmFIkAUF0ZrLoIu9mQG9mXUXWV5aB3cb7yI9ZcJ9I0jBRcf3Vk9o/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527797; c=relaxed/simple;
	bh=NY3JcimvDq/UXMDeiX8XzMZohN/E5SkvuRsyvj9Frzw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F6povZOHYR/0JcbEifaH3ss3qh23pz73EP7tGkghk70ojHafs7qKfwpannVvX8EpV3KRLsKOkgsQsbe9S8pGomOZ+4bDPZ/ZgyEotsiS2wZEAJWPY+1gV8novLr6hWGgzHlhWdB127eZLdRUtpmxDfRkLO5waBqyxwb8L9Ghijo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BLvXoWEL; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743527795; x=1775063795;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NY3JcimvDq/UXMDeiX8XzMZohN/E5SkvuRsyvj9Frzw=;
  b=BLvXoWELhOFzoU5WsSp3NF7A6JNSkO50gZl/4C5soPYBhlYO7AccCtB9
   4R7ivvVeV+MRhQwus7TdJ6o2w5q1XHG6uBsq7zPJlge2HFSmM4J1yfrtq
   kOIyUezFaTJWXKI9uMhSK6xZLUmOST2Brz+etIrfI3+PUA3MHU30oalr9
   APfyJdWB3Q5/MI58/eUxXoyCLb4MYW/V0nkgXg9A05Z3U7OfTfDlyX6H3
   2PSgBWvTqektIWJhM1Q26QQvEx6kn3iTEjfocKmOGErY3vDZBdZlz/0RD
   +JgJ2MlOFZBMG9SdintJnJ54Z/wZwgIZ/y9XieIe16haYXuOtpo+XaQ1N
   A==;
X-CSE-ConnectionGUID: 2r/vDmhyTo20km0rW52TuA==
X-CSE-MsgGUID: JcX/f8DlRE2hFAF0LB6T8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="62265487"
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="62265487"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 10:16:34 -0700
X-CSE-ConnectionGUID: 0eA5Du1xQ0iXltEM1L3ySw==
X-CSE-MsgGUID: EPT5W+63TAGBTjLazrE03w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="149625028"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 10:16:34 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 1 Apr 2025 10:16:33 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 1 Apr 2025 10:16:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 10:16:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KtUCDBXeSukZDjqtGdVHn/e8LhUy9GBGj6gN+l7v6Y4Yjj2FIz0P57IA36LAfw5ZK1tIVL8pYsvU7iqHCFV+HG+r/H8j4KMJmvGY2+XIGGV2UQH+xPBaVJcRBF3AmvfMV3YZYTWFibEtiZesopHJtwv143/QfjVYjIs8oCWUT0LbLtOc7m68nmvLRo3WkEHawJvZWAhi1FXG5kNbLhuZUlhJyRF5VWjczNe3yD70LKYupr69GWz1wU2feMW3syTX3XBbDoqkypVsxmfgk0RipdiSWYiZ+gHeQJr6ttffahgU7sQd/FNQePDsizVehDkx6miixayJxpg9yzLAFVmhLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bJyCm1r33zSiOos27NeCa4u5Ng89c8C3lUyYALiN3nc=;
 b=AIuR4c92MCq2VG22ojqlX6kLEH4qb8zYoTLcrFlHcspfTyOh9Efn/tQg9383hHG9yaTvPX5Zc4JdkLGFdMysSwgDY/0CL58DEpJ+ZekHr6qObE0jMQBGG9kxsWzuNMKhQWl1P/nzB92mNAwNlEy/28biPwUrN/NMBl50Sg328gV2iqzrNGHDs5LJCafEf+qTp3ZmuJvbQJ6F+/fTT5jz+0wUAGq9OYRBc8h+gV3hKE6TwZCijtZUQ/1GjTXrCUy3EAeY8Uf9h3c1ZnaY07NmLnyZP7+O1IKlVEvIobfeKl9V7d2JSdax5Crh3sKQIWDylkwhXN+zkr7Mj0oF9rIgIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.47; Tue, 1 Apr
 2025 17:16:28 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8534.043; Tue, 1 Apr 2025
 17:16:28 +0000
Message-ID: <bb8442f9-4c43-4195-a0a8-4e7023a10880@intel.com>
Date: Tue, 1 Apr 2025 10:16:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/8] x86/fpu/xstate: Introduce "guest-only" supervisor
 xfeature set
To: Chao Gao <chao.gao@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <tglx@linutronix.de>,
	<dave.hansen@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Samuel Holland <samuel.holland@sifive.com>,
	Mitchell Levy <levymitchell0@gmail.com>, Li RongQing <lirongqing@baidu.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>, Aruna Ramakrishna
	<aruna.ramakrishna@oracle.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
 <20250318153316.1970147-8-chao.gao@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20250318153316.1970147-8-chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ2PR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:a03:505::17) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|SA2PR11MB4860:EE_
X-MS-Office365-Filtering-Correlation-Id: b33ac57c-3bf3-4392-b818-08dd7140f095
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RlhBd3QvQ0VUNmVIU1dsRFVHcVZSMVlnWFZhRTJUdHlOYUxVRFhaWjdFUTQr?=
 =?utf-8?B?dkpEdHJzVEk4b3h3Y2lLZlhSZzc1MzVuOEV3Sy93U1VjWDBKQVpLbW11L3dl?=
 =?utf-8?B?NkhPM1h4dXlQSHdmMFhpZTdQNFNPWmVKZmovM1d3ZXZFUHVnYVVvTmg5ZTQ5?=
 =?utf-8?B?ZjlaY0hyS3NJZ0FmbkJzRWxiTTVoUk91RWpENTNvZllJUEdmRmZHbUdXVVZL?=
 =?utf-8?B?bWRJbWdTTndBUkd0WURaNUc1QktiUG1XYXQwckJHQjdZYmQ3UWpITzlJMTRp?=
 =?utf-8?B?Tm9qK3dUd05QRUt4YzBZRTdKVWtodlMyVGpPTjhGTjNnRUc4TGtleUYzbzdk?=
 =?utf-8?B?cWNxWUI3U1VwL0p1WlhZOWdhcXlIbUVJbGdFbEcyL0NFc0JYQS9sT2NqWkJJ?=
 =?utf-8?B?Mi9Wdkp3V01qRGdTcUU2NUpDNlZvYlo0ODVIZG1LZkpKaW9KSkxxeFFzWWxm?=
 =?utf-8?B?UVBTVy9wdmc1cG01djN5M2VtUFBQWW9SNUdHdThxcDB1eTFaSUhITEJ3ZHFD?=
 =?utf-8?B?YjRSaFBVdFFBK3ZCREJLa3liRHl0WStGaURTdDIzMnFFcEk3NWNJdU92VnVZ?=
 =?utf-8?B?NWMzT21NNnlNMlhFWUxseWlFeU1QaHYyR3dVRHIwRzUzMmhQWXgxc3dEaTZx?=
 =?utf-8?B?amN1UW40cVlkU1FTUGQybGYrdVNqNUtPNzNWSXg2ekwzZVVxc0ZPMFJmOGdi?=
 =?utf-8?B?MVVSRjVkbmd2S0pLZ0x0eVNjMzNLL2pyZ25YSnlUbytjM1ZPZHpHc3g4R3pl?=
 =?utf-8?B?NkwwQmZ0b3JML3ZZcmFUeVRtUFJ2dDNzT2pRNk90QWFVNndRZkt4RVlpTXNh?=
 =?utf-8?B?Rk9tNmdoRmIrYXduY01BU0NXYUxaSjFTOXdRSFRxTUl3RFRwdWtXSWZITCta?=
 =?utf-8?B?TkxVTmtCYWtYV0pSSWo1VjBFNndyM1JXVGZhdEFkUThSSUwxbHRET3AxaWNW?=
 =?utf-8?B?VWFWcG11eUJ0Q3VLZ3hCZTFhM1pkTHFJUUY1cHZNRFVqN0crV2htY0l5eUZq?=
 =?utf-8?B?WmlZaXZOenp6akwyQ0ljeDkyRmNaVGE0enZ2Tzh5MzBpVDN1cG1Obm1uUWtY?=
 =?utf-8?B?RjkzOHZib25BUFMvcHNLSXpveXVReElEZE5HVW9LOTc5elg5VnhscEFHSGdi?=
 =?utf-8?B?bkE5d1E5RnVHNlJiOGpsOTFoRXc0eGVnaWN4S3YyYXcxU2x3TlBRUlBVaGxk?=
 =?utf-8?B?SHR5Skx6dlZ0K0UzT3JQVlhUajVRT01McnR0VTAvL2ovbFk3S2lPVVNOaHUy?=
 =?utf-8?B?RlVHN1J6WTJEVTBNdTVxVWhHKzBkVllVUG5JNU5RRzEvUGhJSXE4c21xZGVE?=
 =?utf-8?B?OG4wcnNRN2FFNmdZeVVRcDM4SUNkU1l3N1h4QlYwaTc3aExVRDhUVGM4b2Vt?=
 =?utf-8?B?b3lqK0ppakFvK3lsQ0ZwSExUVC9ZcS9IdWxVbllIRHlwVjlqZ1RWZlRiRHdE?=
 =?utf-8?B?ZVNYN0hjUGZTMmJlRm1IYTkzZTY2NmNoSkJteHExbEVnNmcvazVNWWlSVGJm?=
 =?utf-8?B?a21hMXczNC9PM0lkNGJZSVFXSzRtY3JpL0Nrdmc1R094ZENHTlc3VjZjR2Jt?=
 =?utf-8?B?YTBSNDZMVHB0NkNNbzRWeFh0K0o2eTMxeVN5SUhwTXFhcW5ENnZjUW1wZlZZ?=
 =?utf-8?B?SlFOeE90eFgzb3VDVU5WdElUTGpMWmM0VllzOFp6YVNjYUFUbnZENjh0MjNz?=
 =?utf-8?B?UjVrQy85WVo2dEw1MjJNYVdLdXp4VzdzRnN0ekdKRVY3cTVuVVp5RDIvblFl?=
 =?utf-8?B?Ymo1UGJEQ3ZmTy9wTWFkRlA2MGlYOHFTNHozM2dLbmh1ZVJ3U0RORE5MK3hK?=
 =?utf-8?B?NC9lU1ZvU0Zab2E5Rzk3V1dhOXA3emZNYzR2bzQ1cnZkMm5ZY0xEK1pyd3BC?=
 =?utf-8?Q?MIVqxhrwq3eNy?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWJUVTRiZk1McS9BMnhrRFN5cWxJMG90OUI1cDlpZlRsUG5ORnUyRWxTSnVY?=
 =?utf-8?B?aDcrSW0yQzZOV29vR3o3OHc5WjZtRTNnTVhCdlM4aVJ3Mk1vdXdsd1c3djBD?=
 =?utf-8?B?YkFmYm92ZldHMDZ6QXQ0VTg2WE15WU52RFhvRW02b0xKMWFpMnFOb084N0d1?=
 =?utf-8?B?K3drdS96NmZybVZ6K2tBMnV5bGdzRkVqbHRxRWhkMHZRR1d1NnFYSVZaY1RF?=
 =?utf-8?B?NHVENk9HVmJ3VWFUdEYyazhMTUtVN3lMSCszcWJhUCsrejZCcWZMSzFGSWpr?=
 =?utf-8?B?aUo4bm5qT1RsV2c2Y2ZzVjBvK0o0QkJCaEdFUitiNHJvZE5Dd3JUenNqV0U3?=
 =?utf-8?B?VnNlU3pMeVJKMkdCWUxmNSt2ZWo2TjM4UjFqbHBhdVE0bExKdWVNUXNqL2J1?=
 =?utf-8?B?Y0hQMXNrOFp4dTQ0MVZ4c0hNZGtZQS8xcWFmcFBOeXVjQW9oS1hJV01OYVVJ?=
 =?utf-8?B?c2ZJNDZwSUxUM1ZRSXZzR1RXb2JEdk1NN0xSL203bzJyKzdpRXVUVDgwaTVk?=
 =?utf-8?B?ckx6ZFVPSG1pZ1YxdTNtRll3cVNYSUpLTThGUENWZEZ5ZE55QTZFemxWRkRN?=
 =?utf-8?B?VklSb0twTTFEZnArekU1SGNFVEpjY2N0UzNoT001djVMREhraERJSi90dkhI?=
 =?utf-8?B?Zkdxb1hCdHcxUVVBd2cwR3BDeFBzRDQ2OGg5czBER0ZvTUg1UFFmTU1ZblRM?=
 =?utf-8?B?YVVEaDNBM3VkODRDRG0wdU51YmhwT214T0pzK1I0Z3ZKTFJFUVZQbTlibXVL?=
 =?utf-8?B?c0t1MEdnMDRNQzFXdFY0eXZGOHhwSmpOVmZHdVhtT1Y4YjZ0VjFLMW5uczRl?=
 =?utf-8?B?c1FWbTRUQURpdmJYVFByc3ZPWWdCNUEySDJvK2E4LzQyWjUwcERaNHpEWGF2?=
 =?utf-8?B?emEwWjZZVlNSVU1wQ3FKOWJvUzQrUFh5ZjhpR3dnc2VmSytWMGp2Q2ZmY040?=
 =?utf-8?B?eXIya2J0b1lFdWFJUlcxVDIzeHJ2TVNXeEExNVRpRzA0ZXVhYnF3ZTdKT0ti?=
 =?utf-8?B?ZlJ4cE9GQlU0ekxhTjdGM3FjcExLdUh2eGxacC9XOU5vSUcvaDd4TFJaNDNY?=
 =?utf-8?B?ZUx6UXRvOGZydFh4WnZGOVdZYmZYVWJnbmtqRlpJUm5WaElsWVlxWWZSdkNQ?=
 =?utf-8?B?UVlqSUZCZ055SjA5ZDVib1FXVEdqdnhwTHJkS1NFcGFPRzlGam5NQ0cxbm9I?=
 =?utf-8?B?aDM2dGpjbnQzSERrZ3lKZzNZWStXZno5b2x1QUsyMWVyVGhnNDJmTXdSR1N5?=
 =?utf-8?B?QVZCbkdhcitlSzBGZkhoVWkyZHFlalR2cGxTUjFYTlNBUmtqNDdVb1laK01L?=
 =?utf-8?B?djFXRE1YcTVNTG53VWFxdHduQlV0eDlWNDByVHh5c3U2WG4xcWlpdFhXeGhY?=
 =?utf-8?B?WHZpQVE1b2Izc0ViOG8yNGFsYm03dE1JYnJMTmJ2Zy8ydWk3SHBORXZHV2JT?=
 =?utf-8?B?OFh6OW5zeWpZU2o4YTcrSURKbTdoS0RPaEw0clJLaW9UdVVpWGpqNktXcHhG?=
 =?utf-8?B?d1JPU2RZajRVS3E1dGMxMnBha2R2WFBYWFg0QzVWZWYzR1ZlOExRQmt3QmpU?=
 =?utf-8?B?OE1RQ1BzWVpETU1ydzVCb1BYamhDTGtxRzFkSTlEaGdZSUpWZ1p3T2FuTXBk?=
 =?utf-8?B?aUNUVktJYjdTclZTb1pCY3dLNlk2emRWTzJnbHZBQy9ON3d5MzdJQTJENEt2?=
 =?utf-8?B?OXlRWVUrNEJNbndWU2VCdEJhSnhCSUFZWXBhMVZHZWpzUWlSbWR5dXNpR2Rh?=
 =?utf-8?B?K1ZPYmpBQ1VHTVVuUEkxZjlVTE1FVkI1TzZkOEFndXFhNXE5VUtQQTdLOXNs?=
 =?utf-8?B?eDZ3YVFrRkowSlhGdDBMdUl2cWZQVGJONHpBMGJucE53Z0JpWHdSTjJtcmNz?=
 =?utf-8?B?d3pVVmQra1RJSjJBaGI5bTZXZUdTUWdMdXVuTjV3Mlg1cXRCMlJkajRrS2Vy?=
 =?utf-8?B?aGlxYVQyZkpNb1ZhNEdNNlVKcmp3L0NjdXExQk5DSXNFYm1GWk9FcGRZNUxP?=
 =?utf-8?B?cEpLT0NTSmNSd21Mc21GeFo5RytrYlZUY3hWaGpNTFRLNWhUSUdGTU9rWTRh?=
 =?utf-8?B?Z3VUM0pDajFIQ2VOSGdJSEFaRzJEM3p1ZzZ5bmdRWi9qL0plckhWOUtQcGV5?=
 =?utf-8?B?WlNGcHpJQ2xNeWw5Y1YzUGxQc1VaRzJadWc5RXJldDlCajc4OG44TU9aUVhu?=
 =?utf-8?B?MUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b33ac57c-3bf3-4392-b818-08dd7140f095
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 17:16:28.6510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wCap/5fes8iV4B8QobEd0Ne7eoSfX9IPU0Cn4JgiH8PakFB7LQYZMGBjZCEvLVyvnscpbI30I3gbTx/FUMf6Lc4l/kYWA3LF0uVmTDh2Z3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
X-OriginatorOrg: intel.com

On 3/18/2025 8:31 AM, Chao Gao wrote:
> 
> Dropped Dave's Suggested-by as the patch has been changed significantly

I think you should provide a clear argument outlining the considerable 
naming options and their trade-offs.

I noticed you referenced Thomas’s feedback in the cover letter (it would 
be clearer to elaborate here rather than using just the above one-liner):

 > Rename XFEATURE_MASK_KERNEL_DYNAMIC to XFEATURE_MASK_SUPERVISOR_GUEST
 > as tglx noted "this dynamic naming is really bad":
 >
 > https://lore.kernel.org/all/87sg1owmth.ffs@nanos.tec.linutronix.de/

While Thomas objected to the "dynamic" naming, have you fully considered 
why he found it problematic? Likewise, have you re-evaluated Dave’s 
original suggestion and his intent? Rather than just quoting feedback, 
you should summarize the key concerns, analyze the pros and cons of 
different naming approaches, and clearly justify your final choice.

Thanks,
Chang

