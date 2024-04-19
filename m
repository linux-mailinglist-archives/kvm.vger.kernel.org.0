Return-Path: <kvm+bounces-15286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C485E8AAF8B
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:39:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39BCA1F216DD
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE7012A160;
	Fri, 19 Apr 2024 13:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G8UjI1UH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAE9129E81
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 13:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713533991; cv=fail; b=eKv6E1I7ZYy3nfF/Ga0UH99wc7h5okqvP+qHH1Vdqa5ijuRtU85WIinzrFsqNH5fbHWB7kuoDBBymAF44Z9xMp9TcvYu+k+ub0fot//nKBzrjDz0Iv0S6wV5xOFlvfNUnBooM0nL+cz7uRU8TfOq/kmEHuQ7TmOKjHALwpHC7NQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713533991; c=relaxed/simple;
	bh=VrbGGEa1/Wnz6EJ5rJra0K6DmMYV+DfM9rJUwwasgrs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UVNGLY9rOsVCPVY2Wa1NUIgT9XVdPvwCmOSPKOzVCQxcSrmEp+owAQoxBwvcktIsZ8pIRO3WlLOzXCdHM+K34UhYKwG3ZIjjY9jl5wpyhfAKwZYlaTJT6p7e3WezShB/KLp9tLbKQPHmQKNXb4ARCKs7PfK0G+8dihnZUKkCeDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G8UjI1UH; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713533990; x=1745069990;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VrbGGEa1/Wnz6EJ5rJra0K6DmMYV+DfM9rJUwwasgrs=;
  b=G8UjI1UHXv5DEJiw4Q55a6JX+1aDdDqYr/8Gw94KGwNjpeO2A2yu0btu
   uNsvWgdTdUV9UKzQmCGrMoTr0JwfZIkhelRpUMiOX8vpyfCI000iAyOsT
   vnGgbzJ/UCMNBdk8P9bfOTpQwara0YGnvyDjwPyjchxgtRnUXT5uiMPNo
   5JKQEBTN8H+lslLRlG7AkfHqVY4aSqMrEPWu1x9f6D+J9ljujBbsLLUhC
   mYWwWVJnvZKgLvdCtQgW214l8/MN7wODtbwpblEPjCB43SUM6mI0c+jyx
   +uJ5Iarou6REg9bY4oE5CV5mC1RLFFc81yEK5dElhqBnsr+LYSie89bYu
   g==;
X-CSE-ConnectionGUID: 0cMTJvQNSEmCWJ4rNlhnnA==
X-CSE-MsgGUID: hlX8YH0HTQOU4mah2pu1og==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="12915507"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="12915507"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 06:39:49 -0700
X-CSE-ConnectionGUID: wh/mokT9Sse56RS/y6ja9Q==
X-CSE-MsgGUID: gIuAAU2oRcCwFdKxKstqwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="27879074"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Apr 2024 06:39:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Apr 2024 06:39:48 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Apr 2024 06:39:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 19 Apr 2024 06:39:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Apr 2024 06:39:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcriB8ln48b6r17u3weunAKStgN2nM1MArU8Q4BGp69hBV47DXkCsg9KDSIkpk/ka7Of5YSGtUMK2GDoP1oREPGHWCLeYj+9k5AriymMgOaDIm+vtV0jyF7la7GgLUbhJrDfEfSF6GZgWfU71+AjMD6haxvcPZKXw2YRSxYfjZNeGhgkwvFh0lZ6pV87JX5yBANFQmKicJPZfUi3IwIYMxAoQHm9SaCqlxVdK8CaxrVrAF1KdQYIYCMMt+uuMmyW+kX71nTjwROrSrReNJSyDo68JaECb96BCwlNhilnB3ejYxRU4H9my+SfkZGjO9MCKeWAQ2uKnIbJiQDAYmxfyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4n4DDiRAi7Dazc+tYpoLWxmFEsOCHy6VvqRapaOoG/U=;
 b=kyMgMO8TI+8O9ssD5H6G3kEDJPjuLMSgXbQliSOAZ02GHmR9XXf3Sb3mXuj1WALEJYswJksrsyMQj7arKFYrHHJkkVo/fv9d/AvyxXEQGTF8HPCv8MCX5CFwQZnCqxAkHpuA7mkJmdAM/UUD6bHJ2fIvLmWghhBmTgZVYY7RPISlA8BXO79mGrhHXHiUVWQWxAzOlrtIoIoZjV2E6kjZxubLk/Sw/NbifV0XMWBmzVTIF3p0VCLK7VK8/gffyg/2ZLdt9jD4xb6r9+Uk43v5g9f/48O4tZzVqZojF/ZnBvzbzShECnDJrfSU0yaALktPRoPWgtBmDV5M/JMk0GSMDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB7964.namprd11.prod.outlook.com (2603:10b6:510:247::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.16; Fri, 19 Apr
 2024 13:39:44 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7519.010; Fri, 19 Apr 2024
 13:39:44 +0000
Message-ID: <d4674745-1978-43b2-9206-3bf05c6cd75a@intel.com>
Date: Fri, 19 Apr 2024 21:43:17 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] ida: Add ida_get_lowest()
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: <kevin.tian@intel.com>, <joro@8bytes.org>, <robin.murphy@arm.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<baolu.lu@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<jacob.jun.pan@intel.com>, Matthew Wilcox <willy@infradead.org>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-2-yi.l.liu@intel.com>
 <20240416100329.35cede17.alex.williamson@redhat.com>
 <e3531550-8644-4a7e-94bd-75bdb52182be@intel.com>
 <20240418102314.6a3d344a.alex.williamson@redhat.com>
 <20240418171208.GC3050601@nvidia.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240418171208.GC3050601@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR06CA0012.apcprd06.prod.outlook.com
 (2603:1096:404:42::24) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH7PR11MB7964:EE_
X-MS-Office365-Filtering-Correlation-Id: e834d5b3-e26b-4e97-0114-08dc60762bdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005|7416005;
X-Microsoft-Antispam-Message-Info: F7d+iH6heLnMGsTcqWoiFzXDLlI73dvq6LBz5+bOU/htr/Kz9HoinUL4xo0fqAIVVbBA2K4cjXrSNvA7UGCqHpnufI9sd+AM2Qq83OEWwa+EwUoDWX3rE3cmevCKP4twIdrDbOFbdSxOG9KsgFuEe6+5pm1u5WJYFFP+jQek6iVbVQ3yAXadbbSki0DmByQUR1DX/5X+4qGcATj/F20UJm7iS13gRHuKuyjjL6YwKMzjOqU++cHojv50/iiajaTgwODjpLwuo+1/4PTZ1EGI2qKieDVejfcoZrCggP0T8+6LKBYHs/dkUOoAA4RviWbkLOBQQm5R0FmIsQhtAGBiLG0hz/HDa9kWAMGfYTB91qJudDnlKjL2wjYCqZkH1Jja4z2KMAnYG+4hsPy/aYLnyiqRKLEapdub3xL3GXbWez3CrTcJ0VA+d1Ze8wvBRSQ5rfZRgujhq8Y/dVfKKSQFDDhXQa7Y4+FoKwOYvy/UhKOEmHShe+gDrYf6b2arpVEDqp/qpdYTO25OSCwXNp6hZlHIC1VmzwE319HGeA4dMpZZb27ZU5VD7RD38oPEKGcESKhpJ6/RdWiwPbbk1KuNFsd9CX5NLHIiqmn2H4DGwqYqZ3TlR/MBsKKrhcEKbrFPHKqduME9XnQNhumllNin0AGlylvMvosqNEmQOV+nv9I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3FzeWREQW8vTkdGQ0Z2U0xvUzg0V0NGMklqcmVrenF2SWluRm8rLy9BVDdN?=
 =?utf-8?B?VUVmcU14ODF4WDAxNHNxTEtxREVwS3h3R25EaFpDQ3JWa3FVWDdFNGFoU0VY?=
 =?utf-8?B?Nk1YdnpZUkhuVWdKT0RmZ29kVG02NkdwUDE2RXB2aUhPN20wblRZd3V1ZXZz?=
 =?utf-8?B?am1OeURhR29ub0VBaWpXSE9vc2M5NHZGblZKUWhRdC8xdytqVUo3Mm1BSlE5?=
 =?utf-8?B?VmRJV1FockRWZElFZkJhYTdacHlBVkhTVFk1RDNBejFLRWtuMVlKVGQ0ZmE0?=
 =?utf-8?B?ODZySGxlTVVnNG9ZNElla2k5L1JiWklQdXZXcHZZRy9JR3JDbjJ4alNtaU9q?=
 =?utf-8?B?WDNoUnZyRmZyV0R6bVVyaVN6K2hTSVBCV2lpMlB4WnhNTGpoR3ZudTBFM2J0?=
 =?utf-8?B?ZkVpQ0JSSVRVeFBkTTVQVlNXTlorWUl6OE1WbnErK29LMVdQZldPUVVyTDlI?=
 =?utf-8?B?aXA5U2lWaWMyTU9CWHRaUE9iWnovMTJjeWIvVnB1aE14ejgyYUtPWVJRMHl0?=
 =?utf-8?B?dzBWMmpRUjczK3hWM1h0RHhuUzdqd09Rc3ZQTHkxNzJaS2hUTGdtUVJYU1pa?=
 =?utf-8?B?WW1ISnZlUFB2UTFHZ1h2SWErQjdOTE9va3FKT3p5L243c204KzNPOUt3bXM1?=
 =?utf-8?B?T0dTNzZ3V3V3ZWFmZ0tuamdDNy9NUDJkM25RTk81eGxOWUh2M1hiVFpEdTlI?=
 =?utf-8?B?aFZMLytGMkZvZkZiUDN2T1RVdktYZ2lra3RueHZmZjZoNERyblREV1dmTTQ1?=
 =?utf-8?B?TS9QczQ1dVZ2dVJRYVJqd0JhekxtTE5JZG9kQ1VTSHRmTm42YU80QVkwTzB0?=
 =?utf-8?B?NHJIMzQ4OUgrWVdyMGsrQVhwSVFFY1RTb2VTT2MvRUQ1UkNoVG44VUFndHcy?=
 =?utf-8?B?VWR6ZHdJdGxFN0NIalNQTTh4ZExHQ2xUSzVXdUl4UUhyMGRCVWFHUmVySkov?=
 =?utf-8?B?TFdMVEgzQVhSeldETldOV281YlExR04xY3djT1RIYU1JVi9TWXZLajZlMXZS?=
 =?utf-8?B?akZ3cGtKaEdCb1lhVjJIRHdXRkZ2NTR5WllWOE9UUWUxcXFNMHhJZmplM3dC?=
 =?utf-8?B?SzliNEt5QytKTHR3VnZmelJTUGpnWisxSDVQQnJQM2d2SktrcG4wOU5nN0Q0?=
 =?utf-8?B?SCt2RDVMY25ReTV6VUllcFBTQU83R2FleUxFd0VPaU81VVJZcENDZ29FOUU0?=
 =?utf-8?B?QkQ5TEtxWXAyVEhWT01pZEdueUtkYXhLQUFXeEp5b0ZmMDMyY0lPUUEyUHZl?=
 =?utf-8?B?Rmp6SWtCZlZKVEdLVGZ1dGN6bDd4aG0yOU9aeXJjZFJkQ1FyVE1qNjJoZkM0?=
 =?utf-8?B?LzFTMVhXSEVUR0ZLVWhXSzE2cDBvcUlxNmdPUHJGTGIyWkVnalRLRzIwQTNl?=
 =?utf-8?B?VE1YSDN6NFB4YVcwSitOUGtKejdMOTYyRmJTcy8wN0xXNEhlSFhhbzVsU0ZK?=
 =?utf-8?B?TzFLQTFjY0o3bmlFQ0tOTTZjOVpZQVJteWNhd1hHODV1Smg4YWQvWGJRZFBa?=
 =?utf-8?B?SytqYk5YUHk5K25FWHRuWjc2akZuSEhma2pYM0VscmdtUnN1V0xqSjdkNTM2?=
 =?utf-8?B?TVZKd1VzTWgramZyd3lWTTNVbk02cDhBTlRPRktwcWdyYWtvbGw3UGlqdXMy?=
 =?utf-8?B?VkI1cjEySm1GRE1DOVBIOUx5OHlpem54NHBZWk1ydmJKak5mRE9QbzNvRG1z?=
 =?utf-8?B?Sm4xZTEwYkNwc3VTdnRzMDJUR2ZiL21JM25QeDhJWnlOWnB5UWVwWmxIYlhn?=
 =?utf-8?B?UmNkVWdZSjJuTU8zRmJPdEVUZTZUVmVQZW9EdjdmSEMrZG9QMWFwMEVXKzBQ?=
 =?utf-8?B?ckFpTGV2ZVdMeFdvYnFNSDMzRFE3bDV4RkhQQTlCa1VQcnUwU1ZpYng0eEhE?=
 =?utf-8?B?OEUvMmVZYkcrQTJpa1lBSHNNOUhIaU9KbTMzVHdSVXRhcW1ldXE3b0VXaW5C?=
 =?utf-8?B?TE00LytLZEQ2SGhBZ1JuT0l6VXFFMmRtaUVXNXljZytoZ1Q2djVMSGU1SFFH?=
 =?utf-8?B?VU9SV1c1T2pXTTNOd0lkbDlGWlVSYTc5RGNpMmdEbHpiS2xHUnJ1a1ZYL1da?=
 =?utf-8?B?S1lkRWxVcVlQd2k2ZjFKWnZtTnlYTHo1U3M5RnlScGZ6aldrajdaZzZiMzgy?=
 =?utf-8?Q?baLiHuP8SnEgUHrHlC5NHQ8BX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e834d5b3-e26b-4e97-0114-08dc60762bdf
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 13:39:44.0543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H/bYsMT1j0lEbJTV8zlyN66dc7wSXOC5dmHIA9NSIjLBA0MvZUS6yon2/uVXej3jDDncl9R+6GCrr1LoLbNdXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7964
X-OriginatorOrg: intel.com

On 2024/4/19 01:12, Jason Gunthorpe wrote:
> On Thu, Apr 18, 2024 at 10:23:14AM -0600, Alex Williamson wrote:
>>> yep. maybe we can start with the below code, no need for ida_for_each()
>>> today.
>>>
>>>
>>>    	int id = 0;
>>>
>>>    	while (!ida_is_empty(&pasid_ida)) {
>>>    		id = ida_find_first_range(pasid_ida, id, INT_MAX);
>>
>> You've actually already justified the _min function here:
>>
>> static inline int ida_find_first_min(struct ida *ida, unsigned int min)
>> {
>> 	return ida_find_first_range(ida, min, ~0);
>> }
> 
> It should also always start from 0..

any special reason to always start from 0? Here we want to loop all the
IDs, and remove them. In this usage, it should be more efficient if we
start from the last found ID.

> Ideally written more like:
> 
> while ((id = ida_find_first(pasid_ida)) != EMPTY_IDA) {
>    ida_remove(id);
> }

-- 
Regards,
Yi Liu

