Return-Path: <kvm+bounces-52399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B96C9B04C09
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 01:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 274CC4E291E
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 23:13:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F56D28468C;
	Mon, 14 Jul 2025 23:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oHwiXUDn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788F524679C;
	Mon, 14 Jul 2025 23:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752534673; cv=fail; b=m9OXjJqvosYh8UcwZ5OOI8j/h3hkkCwZpAnVlS4k8GvfHyYgiTeS8l3U72DPzTeZEBMqAVgpos6t5ImZW1BeYqd5kf+AJf26fKRZSLGAwphzLZBFX4qfDNCv7tHcWjLdRpFvFxbiygz/z3yLFjzV5ODtZmoHmQo6tAE2aGAtsb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752534673; c=relaxed/simple;
	bh=De8PNZgEEHQ4mI+5T04iH5M2AL5f4AsyJQIR7f9vqfs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H4cmEwIEgDx1ri99DRiyNg08Ap0VWMvrzIUlVFFhYFlL8J3IwM1MayNh/asRQjN7+54sqcQstnLJznuxm0TR67qdn3hQ58lx1CP9hPgHNsiiKoNRrug4rLqrArUqquWQhwDTqXwRRqQLikYfDgVDGdfo4dIF/+tdwHgFtOZ1X4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oHwiXUDn; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752534671; x=1784070671;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=De8PNZgEEHQ4mI+5T04iH5M2AL5f4AsyJQIR7f9vqfs=;
  b=oHwiXUDn3zupj1rm0MwE/Yw9mttItXgwKn3YNrxcQfTTDRKY0NHabi9i
   iAW3fYMsaIp90DDJypPvhxnlBut+xgoJDuu0rvys9oMjSa+k2Xd80Eojt
   IGML4mHVxv4KP7EhU6vfqHq26x3df+swbvjj+2Z6xwUm5HnnMxGEk1+Pa
   xvyFsBSkXlkOHTvZMipcuvmtvec9Umtoik08M9mYONBPzIgZvlfc6dAau
   GRfQHupwhI7y4ymne3if0ufRYc4ey+mVZgd1+bGT9bC/YaOg4oK+MZma5
   H0XUQYVVYlf0uxxpVhBMuPxLz/QpGvz9TX6zacc++PAW+QlIjoMDV8Gss
   Q==;
X-CSE-ConnectionGUID: WGNVRGbsQwyGb0lk1VoC3Q==
X-CSE-MsgGUID: P5rn5vT+TvyOStFFBbgIfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="66099060"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="66099060"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 16:10:51 -0700
X-CSE-ConnectionGUID: ERbktgD9So+Y61UvTFagUw==
X-CSE-MsgGUID: 2WO0M4LFQ52Znw9jAdd3VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="157156717"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 16:10:49 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 16:10:48 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 14 Jul 2025 16:10:48 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.78) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 16:10:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T6919pgDfh1yEdy7hYtzUI0vDth1PJE5wXzFSTVySWMOUQDRbtiVR6mZBSKnOxrmVTOGtigimel3Lv9Qa26fnNJk7lWOsdbb0HzBeEmFtnksRLcbNFykn3TE3vPmi2jQHe5pDf0Jtw+bqDIWOBaP21Jqb2EIRX7UCeDLTNmc9WyGwkO7T8uLtNe6hhLRYYROlOrkAHRlHob2dh+pMZVcXFISnchN5YJfv26UuAybinPfhp6MnWhBMFlJwCmmC8VfUV1LzQXx/6Y6wmljEqWzpK7w12wtP0p9fwFd2ovV1h0GhtlfWDcIE3yU+b/Ae1SdEllQlFoUn87ddrA190B88w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r/1UzA8wbNSxLjh1HU4R8t/IbGns7OIHOc9WgWrTx5s=;
 b=j4L4bJOY584bI5fAY4rKz7XJ+dZVMKNjdedyoebV5LqFfdj7Tx1CQm5fFZW0HjBWkTspR8NfbihyUj7VISA65w3FGhJ0lhjzYJj+hHKFA50m2slyQk9MIhS+2GwCq0LhI70vfb++D8utBgpzeZSo4mkxJFY8PggcOKlGroMMgDHFRsgc2IDz+TVEpWlE1gHn7Zotwi6/izger+HR6EP5IJnuT8WDZuf0VRH52mlfo9JxSjT7JoOFHPslOuMOt76VT8TZ70czAKkv5IfSmVtOhMmUpxi0gmIB007qMyVjJ3+tPmIj/YSXeXE+zrjUCBNpbdgQyXRHgGOP88+eb3EwOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by IA1PR11MB7755.namprd11.prod.outlook.com
 (2603:10b6:208:420::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.29; Mon, 14 Jul
 2025 23:09:33 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%5]) with mapi id 15.20.8835.018; Mon, 14 Jul 2025
 23:09:32 +0000
Date: Mon, 14 Jul 2025 18:11:05 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Annapurve <vannapurve@google.com>, Sean Christopherson
	<seanjc@google.com>
CC: Ira Weiny <ira.weiny@intel.com>, Michael Roth <michael.roth@amd.com>, "Yan
 Zhao" <yan.y.zhao@intel.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <david@redhat.com>,
	<ackerleytng@google.com>, <tabba@google.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <68758e893367f_38ba712947a@iweiny-mobl.notmuch>
References: <20250703062641.3247-1-yan.y.zhao@intel.com>
 <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com>
 <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com>
 <aHEwT4X0RcfZzHlt@google.com>
 <20250711163440.kwjebnzd7zeb4bxt@amd.com>
 <68717342cfafc_37c14b294a6@iweiny-mobl.notmuch>
 <aHGWtsqr8c403nIj@google.com>
 <CAGtprH8trSVcES50p6dFCMQ+2aY2YSDMOPW0C03iBN4tfvgaWQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH8trSVcES50p6dFCMQ+2aY2YSDMOPW0C03iBN4tfvgaWQ@mail.gmail.com>
X-ClientProxiedBy: MW4P221CA0028.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::33) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|IA1PR11MB7755:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e035718-2d40-4499-574d-08ddc32b7e5a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QlFsWmNZYVAyOG4yU3pTbjVrSGJ3OVBkdWxadlJRQ3Q0QVlwTkt3cjNkcndW?=
 =?utf-8?B?UE1ua2p1S2VsNC8yNGhmUHhFa0hRUHJ1UzVGSUc5Nm1xWmh5LzdVSHNDNEhz?=
 =?utf-8?B?cGV1d0syOVFNRGEwcnFseFJ5ZTJRK2lIa1VweGptenlWdlVlc1JGNmJIOTYy?=
 =?utf-8?B?cE5SeWhVakxMY2U0dXhCeTgrem9WTkdPYXhjK1NPc1NMcUJMYkdkMWU3K0lD?=
 =?utf-8?B?N3MzMk1OUUFXcjVmTWRqZmJOMXBaNTJCVSs4czJZdHQwUzlRSXEzWnUwQXFm?=
 =?utf-8?B?THhkcW5lb3MzS3dIUHBUNWdSdDZYY0JyWHJ6VDdlL09mVFZPNjVTbWVCaUMv?=
 =?utf-8?B?a0dTWU4vQy9DeTNZbmtzb20rUG1KR2E5YSticnREckhVblptSlZQK3dGZFY5?=
 =?utf-8?B?QkJ3V0tSRDN5ckx0R2ZGR3BmL3lobUtmcGdMWUtKNU9BZ3U2TUZwai9SU3JB?=
 =?utf-8?B?THJIQlRROUVaOCsvR0REQ3c4aG1JSWt6b0dHMnRsWGZWTmE3RDZOMU1DRkQz?=
 =?utf-8?B?YVVPYitIRy9IeFJYTHA2QXFBb2hhTndpZENqOFpDVFJ4TDRrSHkyVUZwME1t?=
 =?utf-8?B?ZE82YmxlRURIbUhRMVlJZGJieDBjVm8vdWFVT0FadDJjMlkzVWFYaitMT2gy?=
 =?utf-8?B?Z2lUN1creDRhVEFFUDA0RHJpQVZrZER4S2RkS3ZzMk5Xam0yTGljS2JBTkIv?=
 =?utf-8?B?a3c4VzZkZitlWnltRDk3Q21ZcWdvOEt2WnUvMzd4TWNEaDdWN003SmowYy9h?=
 =?utf-8?B?RURHNEZLSUk2M0VnckVIcFVKdUl4SFZVYUhYZ1ZOTjZrQUZvTC9ZMG1CMHdk?=
 =?utf-8?B?bkFwRUJIbUFEQXpHaFJOZVh3YlEzR1lyY1V4bGJHWVhrcGF3VEdjM3QzUHRB?=
 =?utf-8?B?enBQdEtWUHAwazlrN1djWnJETEt6WnJ5YUx1REZsUC9qNzhVMTE4UHEzNHcw?=
 =?utf-8?B?SE1Cd0YybnUxWFZaTVRVbWRibENvRnpYTWttOVBQeGRNWjVGWFlENEdTb2NO?=
 =?utf-8?B?S0pBVWlXOVQ5Sm9LaFVmTTJjWEo4NjlsQUxNemlpL3ZLRVRoS0E0aEZEQTFx?=
 =?utf-8?B?UVNzQndWWXJROUY3QUppajlYbFhRU1AwS2JOSUt4SE43Tk9sNm51VGFMRCt3?=
 =?utf-8?B?cmtBVUtNK1lNUlJpWTVFSkFGR05nVkIwenp1dWREQ0ZWaTAwbTdWZmtGSGwv?=
 =?utf-8?B?WWVyUVZwM1JwM0hZMGllQ1F1Nmo1YXR3TUplUDU5Q05UV1VKeVdKU0Q0aDNy?=
 =?utf-8?B?NEszdTJiMDE5bmFvTTBxd1g0WmRadGsrV1lBdVJMZ3FTT1BqSGtGK0ZBL0NU?=
 =?utf-8?B?UzdsMFVSVkFtVWUxN0NUb1VLaWtxWi95bUY5eXV2RjgvWGdXbTFyeEoyV05G?=
 =?utf-8?B?L0dRR2pBcjcxLzV3Z1B6OVJUZ0ViZHVqNGVEYnZvd3pJb0UzS21UcHEyWXZj?=
 =?utf-8?B?MVJMSFZHRFdYZFp3Z2Rrb0hmb2k0RnNud0tJaXgxa0Nhcm9jbFZ0Nk4xYW1k?=
 =?utf-8?B?L3Y0eUsyOUxZbEk5UUJuS2JoQnc1TWV5eDlQYlA3QVc3M2JzNWUrQWUvd2sv?=
 =?utf-8?B?SWZGU085b0gxWkR1am0xOWg0eGxiblU5eEE4T012cjBOUlJTV2FSRjNITU9C?=
 =?utf-8?B?Uko0T3hpa2lmenpNVDNyT0dKVGFqWllMN0ZBc3ZjeXgxZk9WZEd0VkRJbE9z?=
 =?utf-8?B?SVFQc1lqV1YyNUluZXlBZ1pZTjFsbmsxQzdoSStXaHF2NTlKUXZub1I1WHl5?=
 =?utf-8?B?MFA5ZFRqQ0RGcjBrRjN1M0tnaFNRaUg5K3psT3FzRm1MZEd1N3k1YzNqN0NL?=
 =?utf-8?B?MlRlNmJ6YUpzbTlLRXZSNFNKWmtPOXBvbEIvenZhSkp3SUVJQ3lCS1BMUW9M?=
 =?utf-8?B?WEQ5aFA5S08wL2NSRWZwSUVSOWQyd250OG1jallJdHNGMzBCMVc1YTBJYitF?=
 =?utf-8?Q?oNtsigvZGrU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?elYweDlicEkrcEJGTFg1dVFYZXlWQ1pEOUFDcVRIdThsV0FyblBMMUs5WlpN?=
 =?utf-8?B?RnF5QnBlMGJsMDk4UWVwdE5VWVBHcXQ2UzhCeG1NQXJJdVdOTEZJQkxrdzIz?=
 =?utf-8?B?UWpPNEZEd2p4NnN0U29oTWZDTGZVWGc0clhTcTZoL0tOOGhHMDlGRmZLMWZP?=
 =?utf-8?B?dzkvbXdsaThGMk0zQ0Y4NmtGRkJMejBWb2J2amV2cnNJVEJkM2lHb0JNM0Jk?=
 =?utf-8?B?MThMT0ovMzRZTkY2QkcvSzRQQXdHYnA0OGxlTjJlWlN5Wk9aZXpURHArV2Nu?=
 =?utf-8?B?OUV1VytXMit2dlByZjdCVnZHZ2hsbS9xdER6U0ZvbGxkWDEwQXljNTJUNHZl?=
 =?utf-8?B?VGpvcjRvTVlVT21DSGRWYzRUTXV5Qm1UMkI4QkFaZG9Xc2w3UGJhN3ViQ3Y5?=
 =?utf-8?B?b1BXaENTWmgrdmtDclhjUXRyYlhyMS84N1Rwdk5qY2k4MGYzWW5lWkwyMnhK?=
 =?utf-8?B?OXhWQXZ6azFiem5VbDFzQ1l2MUpjOWc1NjN3N05BbFozc1ViUy9jaXdhNlJl?=
 =?utf-8?B?NisvcHpLejZqb1hrN0liTFo4L1QwYkx5Z3FhOTV2V3NBVzZkeDRIVXJUSWRz?=
 =?utf-8?B?dVNaVVBzLzFGVDNJSVU1SFNFU0ExTWpBMmlydXRBNW9BTGkrNnoyVWNCNWZv?=
 =?utf-8?B?aGg2THFkaXh6SHY3UmxGRmx4MjgrUFZ0UGRlK01lQW1KdWptL0pnNmZabkVK?=
 =?utf-8?B?U1UzaC9RY0JBdWlORncvZXdncGZWTG1LMDI1SVArZGl1bGE3UHJsVWRiVUJZ?=
 =?utf-8?B?b0xkWjhPa0w1UzhKMHlJb29YZExZSTArRDVDVU5FK2tQVE1zOFo1TEVleGx3?=
 =?utf-8?B?NmdqcFZ0bmNYZnp1VTA5NTI0SXZKTlNUYVFGRXg0NVlLNDEzOUQ2MCtCS0p0?=
 =?utf-8?B?Q3pWTE5QUEVLbDlaUDBycVNtTHN6MmN0Q2t3aWlQN2JUNGZ6WS9qdkV0aHlS?=
 =?utf-8?B?bGlPMFZ1UCsweWszMU0zMHJFNzA2MjhBRUpVR0lSU2RDT2NkR3FMZnpCMXJ1?=
 =?utf-8?B?MGVLZC8vQWM2SUhhSncxRklMd1BzdXY3TUhTVCt5Nm9aUDMydFZYUE1uTnNW?=
 =?utf-8?B?RnozNmtiZ25JdHhlUGRObTVtaGZDaFhlbllSNUdrb0ZZN0h1N2QzKzNjdVJs?=
 =?utf-8?B?aWM2eEhiMmthWVJaRW5iSUdkb3ArUUFlUUV6aVg0VU85WFRVVDMwcGZJWjlK?=
 =?utf-8?B?T2MvOTQzYkwwMGt0RDZwWnNaVHlqWTh5bUZ3akxaWW9jQWVZRTVJVkZrVkRB?=
 =?utf-8?B?cDFiZ1JsNU5hUTIySXluN3NoTzdUdTB1RGpkWDFRNE9EVlBuV2IrZFEzM29H?=
 =?utf-8?B?dXg0VWpWalRoZmJHUllUZ1V2TEYwcEJNUjNZRVZVaFdXMnNZYzA0VHBnQWxu?=
 =?utf-8?B?T1U5OE9XNURJeC9ONG9YbVV5dmxWSTl3eEV2bWRCWFhJOUQ4cHZ4N2ZHYmh4?=
 =?utf-8?B?YnpvQ1N0N2hQZXJnRTEwRjh3L3dvWnVNVWY5UTRZK09CTjZHMVZMNzBaV0FE?=
 =?utf-8?B?YTBvSys3ZHpDZXp5QldLRk1mMWhPL3I2S0V6RWZ4aVpYeXlRVC92UzQ1aE9p?=
 =?utf-8?B?cHdYb0l0dmV1dUxnelp2TEp3cUlOSVloVjQrdGtlRGhxR24wa1VRRFk2WUU4?=
 =?utf-8?B?QUVFZkQ3MnFFc2VSUnlJZnhDK3hXcHZ6b3hVazNDZUZvaEkvZm5QamVwSDY1?=
 =?utf-8?B?bkhQWmM0Zk0vTVl5RzlsUVFTWTNGWXljalgvRm5ZVzRtY1IzM2prSlVXY0U1?=
 =?utf-8?B?aTR2cE9FVCtQS3VreXhOWU9OVGViS21jdDlkSmJ6b2hjR3lJZE94bkZkSnow?=
 =?utf-8?B?QkgrSUEwdVdtUVRvSVYxeU9ncTE2TUZnbXVxbWt5MmZROExyaWVNYm9JbUta?=
 =?utf-8?B?clRaY3JSbXNEQ09DbW9BL1VlcklNcFU4MzNoY0ozVExKY2IrMWJ3dWRpSTFW?=
 =?utf-8?B?eGhmUUVyU0FuMEQ1citlYmRiWlhsMnFPVFQrcGQyV1BoSTdaN0FVMjA0UWFZ?=
 =?utf-8?B?Qys0OERpWDBDVmg3bEY4b1U3eGdZNjh1K2JpdzduK3pLZnZ3SDl3TnBXVklB?=
 =?utf-8?B?VWNrSWVpeVNFcWthQXpPcWxNUkgwSWY4MHR5eWNxS2ZkejhrU1cza0c1TlJ0?=
 =?utf-8?Q?Yv3y05mu9MFopWoy0+VYHp7le?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e035718-2d40-4499-574d-08ddc32b7e5a
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 23:09:32.9014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Zeu0BHbcp9nZt5ytoQGIvp6VpykYK5OKNp7SDBYJ+H2vUzFkJrniWa8PbvyVuzYwhRKocMnqbsKjDxMTiQM/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7755
X-OriginatorOrg: intel.com

Vishal Annapurve wrote:
> On Fri, Jul 11, 2025 at 3:56 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Jul 11, 2025, Ira Weiny wrote:
> > > Michael Roth wrote:
> > > > For in-place conversion: the idea is that userspace will convert
> > > > private->shared to update in-place, then immediately convert back
> > > > shared->private;
> > >
> > > Why convert from private to shared and back to private?  Userspace which
> > > knows about mmap and supports it should create shared pages, mmap, write
> > > data, then convert to private.
> >
> > Dunno if there's a strong usecase for converting to shared *and* populating the
> > data, but I also don't know that it's worth going out of our way to prevent such
> > behavior, at least not without a strong reason to do so.  E.g. if it allowed for
> > a cleaner implementation or better semantics, then by all means.  But I don't
> > think that's true here?  Though I haven't thought hard about this, so don't
> > quote me on that. :-)
> 
> If this is a huge page backing, starting as shared will split all the
> pages to 4K granularity upon allocation.

Why?  What is the reason it needs to be split?

> To avoid splitting, userspace
> can start with everything as private when working with hugepages and
> then follow convert to shared -> populate -> convert to private as
> needed.

I'm not saying this could not be done but seems wasteful.

Ira

