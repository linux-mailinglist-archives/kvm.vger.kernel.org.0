Return-Path: <kvm+bounces-48709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A548AD16B1
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 04:10:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 99E4B7A4D9D
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 02:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5C7B19E98C;
	Mon,  9 Jun 2025 02:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LVqZDSOZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4818F19ABD8;
	Mon,  9 Jun 2025 02:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749435024; cv=fail; b=PALzwJ6pjmZI6EXgqOWWpI4cchpDdFbG50l1CB4xeOHLrleaILHR3MCmAXKNLYWxpc3R81nezrkiwi5ejpH8XeVNYvOnB2t0SI6AyRCfewISGiF5uUG5RjJWozyRE8LX9bIvewn6Xy6d/BhFOneqDIx4qNm8NtihhuzDVP+Reko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749435024; c=relaxed/simple;
	bh=BXZt2Tz2S1RxwkaWQUoDe31E07ix9DePrmNCZAcj5V0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bokGWu1VxwGAD5OeXcIizUnWMj4h7qEo0Sb9GgsM7loapbFDeS8xRPa/5fy1Vnox2+NxXehx7BkqRw3UwR2Z/IFCfzbe1+l8yTF+gv+mgafHNy6W9omqi0rm5C7vuTUdO1CUlU1XxeHBy3Ke8HZfyirmEpEMdjP9VmBCKH28NKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LVqZDSOZ; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749435023; x=1780971023;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BXZt2Tz2S1RxwkaWQUoDe31E07ix9DePrmNCZAcj5V0=;
  b=LVqZDSOZFyUp0wzk1NvJwNBklIs3eBmjaXEIwd1QjEOmZirpxiwQQSEZ
   D6F9AkyxlW4CK4Cio6fq/dGW6ZqBdWkZ+aWEaayNsdSYM2Z55brKWhGza
   hpXP/8B+O/HQjGeGa6NOxywCJo1xSdxMO7lPO7syZyaGhHQJbeBqRA++T
   sfAzA7xB+1xoMk/rQyPIaFjgSTHksaSqTm82Ft94IAiKXTLYsPyZpQDdj
   161jh95DzaAf/X3DQxLwQWxs6o2Fnl+i5k7VlRPhsslffnPDPp3n+D+Wu
   hnteI7k2m1JLHHdZE5G1MIdCtwgzwwL3iN7taXAkSQq2dENPlS2Mu3la9
   g==;
X-CSE-ConnectionGUID: mu27mEOoQoWPxjixZeDEmA==
X-CSE-MsgGUID: ipi4WLYxTy2aoEBKZZP8bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11458"; a="55166528"
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="55166528"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 19:10:22 -0700
X-CSE-ConnectionGUID: XepETkyHTVWvl3ICngKt7A==
X-CSE-MsgGUID: OeiTR6J1TRuZ0u5Hdc2aOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="169556073"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 19:10:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 8 Jun 2025 19:10:20 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 8 Jun 2025 19:10:20 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.47)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 8 Jun 2025 19:10:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lcU3eywVj42b9NPLIRhxManpOqEnvgyYjd0uTyXGaFNdNFf351H35N0NanKsQzQC1tfFgMivGV84R7COajaLkvTsCApc5x9GcfwMqvtMxPMkqS6V3qZdQHPAgi7D8oZNXO9I20GH4/0MIOU6Z5+lp6Jh9uWfMdlM9CwjCLsEQZwiycSzMo+F10GRJUQslU14gEl6D3nmyRmvDXlSiy3uS3hfgMBD2TrYYD4q03WzFTjEQEuXtIOEe8BwCL6V1kl63Eg5nhPHl7+3lGOrLyK/fzjV6TPUsECBB6djc1Wmoxqj1snsmpkDZy6OGR15RNU6D0SE104EUMaokW2Fm1k18w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QAGTFm+IHtl0p1IOy4J23lHqFC99R12rJr+wy9nsTww=;
 b=ibNUIFnizRPJwaHd2/OF3otmS1BhYkHI41vywOZUE26hiWw4P6WJv6bHal6k2457g+cqOMrsOsqzkLlSBWicqgbYdGsu0Peh5TdCyQuy0eJyFy+r2ZJ0hvFpJtsLgoozCatg5ZpnyFK2qAPvTqRtSk/CT5xISKsU0iqbVkBROzp6Wm6cX7bUBe39h8aHc75L8Myy5S/lPxDLHe3iNHy1hzIVq3bSGhEkVArHlPohh9I/+4xYdD4yK+fss/7M7DpUCyOke0xZLXUUWYk1+tRbJhdHK5gW2mY55Gqgq8u8E/MFrELQiAMshd7L6JprZR4tSxjb9jfNJvVpfQbuETAWwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB7061.namprd11.prod.outlook.com (2603:10b6:806:2ba::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.25; Mon, 9 Jun
 2025 02:10:18 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8813.020; Mon, 9 Jun 2025
 02:10:17 +0000
Date: Mon, 9 Jun 2025 10:10:04 +0800
From: Chao Gao <chao.gao@intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
CC: <linux-coco@lists.linux.dev>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <eddie.dong@intel.com>,
	<kirill.shutemov@intel.com>, <dave.hansen@intel.com>,
	<dan.j.williams@intel.com>, <kai.huang@intel.com>,
	<isaku.yamahata@intel.com>, <elena.reshetova@intel.com>,
	<rick.p.edgecombe@intel.com>, Farrah Chen <farrah.chen@intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 12/20] x86/virt/seamldr: Shut down the current TDX
 module
Message-ID: <aEZCfKW5EDumt9jL@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-13-chao.gao@intel.com>
 <1f6956aa-5fa4-404f-bce4-3ddf87c50114@suse.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1f6956aa-5fa4-404f-bce4-3ddf87c50114@suse.com>
X-ClientProxiedBy: SI2PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:194::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB7061:EE_
X-MS-Office365-Filtering-Correlation-Id: dda2a5aa-c3b5-4b70-f50f-08dda6fac77c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hFtn1ou2Qbg4aDpgAckTw1wT7Z+cXzmnSEOrfVnLoAZksQWlO1SP4Hq3oMSq?=
 =?us-ascii?Q?Hhp1wijnzhoKpIuBKNyUFJAwnga+fCr7p1iDd3+EbtPs+qH+z7JCK7WFKHMT?=
 =?us-ascii?Q?vhfIgsZbI8Xcfroiu/6kC+vxRFD+5HvBA462cm5gXzKFsajA8i/ndS4ph6Gk?=
 =?us-ascii?Q?pKXrpiSioPJCG6E9EeoTM6oi977LCW9jmB7qlxGbHejPCvHuk6+/Lwq+Rjrj?=
 =?us-ascii?Q?oyoHUcrZEs8cSsScm6f6SPJ2gu6BSOlwJ6OkXvHqXX9WO3cE16ntfhCqhgtO?=
 =?us-ascii?Q?AlRmF3eN10wVnpEpkAIbA/RfQtMLfTVEUngX4+kwH1/5POmbYB4M9JkDZ2bX?=
 =?us-ascii?Q?AoJSF4jDcHqAz1Y8N4z7IHfkaQu27jfkVRqrrVhXus+HXbjaEiOsiN+kzFg5?=
 =?us-ascii?Q?sppOyX6HVkL1voYDaib7QwuhO0oUQY6//augNzfM0Vpvvh2aLi6AaCn0qNtX?=
 =?us-ascii?Q?ieEwRJYIDEUvSGro/ImUMBWsiygVHZaoI0SPGKDDW819Qfd+CpNRlM/OyvNm?=
 =?us-ascii?Q?L35uwZtwyDUKjXMNhH9hHeNqZRdqMrq9Pmscno41EGRWode1+m6VAcltXaR1?=
 =?us-ascii?Q?H5pRalQbBRPaxnDa5ddxwUo603UWmmNClpCHj4GLPgwJ4UTsieRbihkMOjEi?=
 =?us-ascii?Q?J7GyjOibbKcdu1LmIuHQp/OPT99rRIYXNg5VUsa6FiXqecGTxdWAqNTdXEZ4?=
 =?us-ascii?Q?3WIQZ/7zlQea68N2NI/c8i4VZop7N2JvTvn0U72dI3KyH/WwCMhU0ZRDsG8r?=
 =?us-ascii?Q?Cuc8qJv6DDo48PBIhH8EiQ4V8ZTWNRL1zoSa+o85kFRw4KUz/rd+UmHcwcnR?=
 =?us-ascii?Q?9fpFwvaGeuqqA63dKNd/smXbCukINuIYDC3yKj84zW7cqUJfdKu8SkxMhNgb?=
 =?us-ascii?Q?9mYvKSjgueYsgx8IvZ07k5FjZe7JTQjJMwv4PHM9SL1rOoj0t7Bn9Bp8dRaN?=
 =?us-ascii?Q?ZARjTi0/t1VQHJdS/ejtISnVZMbpRE+ANka+KtPj9WXCIfbzUJZTEoqYY1c/?=
 =?us-ascii?Q?YNY4peHled4uNsHaTTq4WPtyRYLWC6g8lbroCScFRe4Jk/NH2F8EP8oHN3Q6?=
 =?us-ascii?Q?DKK0vIQaLFt6g5x//XDew50gWnHtSF5/+qH/tXz5opMRWR2+LzPVq2qJYPxN?=
 =?us-ascii?Q?P9ITszC9juqCxJi8mjeegjBtUaIXNbgmVDMVgzRk0x1Oc6hVJ3jIGL3D34fP?=
 =?us-ascii?Q?nIpiewji9UGQUPnW0GEbRz978QTPLwuZPsfwxcmshbsd1mhm2miYg68w1FIA?=
 =?us-ascii?Q?N/Kma7m20qQfWVVb65LJMYEZyHD+6poxI9X+yTiXjqIgcHRyEsr82uJG5dSz?=
 =?us-ascii?Q?+dLmxchPx99CUmVNSbpjfmx2ZyMe9gxIC80oAZBsCr8q4yxWS5cDVC6zWr8w?=
 =?us-ascii?Q?em+SsAfRKX1jjIbTX9X+cqG7o8HfB/Q6ijs8OacK47VFTmhnIAFmQNQ/D1AW?=
 =?us-ascii?Q?9QGBq4ssByo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/8plJgSYexXiXif7W/WQgq36h4gkiUt4Q/vD8SyqFpNm9TyVrQ62c17eg9tx?=
 =?us-ascii?Q?H4p+Y8UynYpu5xVH125lI1Litk/pmFYJjdCknmuTOI8Wib5ezyWBpLRtsipT?=
 =?us-ascii?Q?YIBjsPk+HpTRqKeTpr5VwYgKf6eJ7/h2ATEvFMvMK4vUpK+GAGTaJBNw+bOg?=
 =?us-ascii?Q?QLkHeyFdxGPaPKRnWBAIVqohgmnTKBS4yBcGm110Ip9fatyckvuW6YQ9PZqF?=
 =?us-ascii?Q?tMKeV/LhyQbiS0uxj9Gh07+YerrW56I42TpdjNXNhU+xZMRzoOfSBRmHBuJv?=
 =?us-ascii?Q?3AMuwKA8c/ug5uEP88y8ZVvzttk3iI38fHwVdwBeWHFy8DD29tc6De8VTuR5?=
 =?us-ascii?Q?QFH/69DgSMltZzLsjt0/oK/2ibCP/95vsVE37s27Z9Ja7BGor4rfQ1VoqT8m?=
 =?us-ascii?Q?Hdxr9ERtMoJINO0r0i+PnEYsTikwN08kKMVTtU2xOjRNBzamJNEMxsrZeL+d?=
 =?us-ascii?Q?WK9SPwPxQedZD25gh+EtDA+alGgeqj+sJouRdCXP6F6NZ+439trPLLNQNWn4?=
 =?us-ascii?Q?ZUKlK/Bc3RItbi3rET8NQpE7LbXzy7Dg2WlnrOuQ+HzAyalhbDynqNVryF89?=
 =?us-ascii?Q?NmJ5iOMAVsMZgG9kJGgED/27I9Ette9oE5bQVkmRt1cFVTP4nJ7ApN5blKZr?=
 =?us-ascii?Q?XtZ/yVdYuPDLv607wDiAM5hyZK3Rr8LVSofmtpaL2U1sxSdERFo9tqDvQsdE?=
 =?us-ascii?Q?dGW00pon5dXxjdFaH8BTASjkKCZ775D0/f4qBDTGRqibsG6aEybjtqrfsurW?=
 =?us-ascii?Q?CHBz+LiEIzNhHhTQ91iXidrTObkC2UT147wi8pdH6PEOxgBEmybQmOwpXrrW?=
 =?us-ascii?Q?zCKYOTiOAy9wZWBBdb/2bqk5+rFIZkDi3/2/1b2qQAKyjIM56peQuoP6f7Cu?=
 =?us-ascii?Q?6xR0pYx5DvdbwO3l8Q4YyT78ZqEKZnTKWqy4pD085x+Yvxri6bnhyaDJhA24?=
 =?us-ascii?Q?P2AvvaOsw43vWeFqIcFbte4xScJCJCQ7nkGQQzlsbCxRQXHyUH3Lnk+qnSSk?=
 =?us-ascii?Q?tM8/YHBY0iEPichD5324JIwMFEcIpCXCW0doH4t4zm4ZLxg1dqq68uMht9i+?=
 =?us-ascii?Q?45rXNVKfeB9QoUL+7NM7RMQTMk+JA7otgi1yjRgruZDo/KOPkpIxBepamybG?=
 =?us-ascii?Q?43xkQDBk1zcG9EoY6e2VIuICECAMUAJhTm8sskSTonLSEnc2MVyp0a/fHMeZ?=
 =?us-ascii?Q?JJ9WIIPluTHtofA1M3jU4x3LND9EVY+sU+6BkYQXh9XSNsnC1jq5wr2AxCOP?=
 =?us-ascii?Q?WUcW68fCWcgsm/L4vjyzhb9g9rEVj5vkKQHQO3x6mXETdPuSAFcgogMuYRDW?=
 =?us-ascii?Q?Jg+Wl0AdNWCnmQA+keUrMD0aU/pFK0xw4bnRL+TAMOAo7xSAwTUydAKgjR+5?=
 =?us-ascii?Q?RTav2DTghKwAxPt+y0nJS6yz9zv34AIAyW6kVLW/Vtf2XdkB6Qf/zHSwVSue?=
 =?us-ascii?Q?g7qwJyXKYLr0LJq1rDD8zGMEeDSTDz/kWm54VUvPUb/lfrSjJQemot5Zo/m4?=
 =?us-ascii?Q?xsfY8+D1khU81MuFU3wxqMJGg2JEruHKDLPXA2pyGujTYlw/FODy9wS3MMJq?=
 =?us-ascii?Q?yfgF6zQep4nCR9nFVvcqs0dJb7nKflA2YDuD4CJI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dda2a5aa-c3b5-4b70-f50f-08dda6fac77c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 02:10:17.7396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uI7+/Yvxh/5XsgTqrKO8W+7lW8mBbTQ0SaYqqgfx68Mb5IhJKWM3juvdTVg9q1/Hz+XqIq2lngJknEfli9NogA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7061
X-OriginatorOrg: intel.com

>> @@ -281,8 +282,12 @@ static void ack_state(void)
>>   static int do_seamldr_install_module(void *params)
>>   {
>>   	enum tdp_state newstate, curstate = TDP_START;
>> +	int cpu = smp_processor_id();
>> +	bool primary;
>>   	int ret = 0;
>> +	primary = !!(cpumask_first(cpu_online_mask) == cpu);
>
>nit: the !! is not needed here, as the check is clearly boolean.

Thanks. I will remove it.

<snip>
>> +static int get_tdx_sys_info_handoff(struct tdx_sys_info_handoff *sysinfo_handoff)
>> +{
>> +	int ret = 0;
>> +	u64 val;
>> +
>> +	if (!ret && tdx_has_td_preserving() &&
>
>nit: That first !ret is redundant since it's always true.
>

Yes, this code is generated by a script [*] and other existing functions in
this file have the same issue. I will try to improve the script to remove the
redundant "!ret".

