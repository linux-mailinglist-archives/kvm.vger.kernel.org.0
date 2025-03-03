Return-Path: <kvm+bounces-39836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9845AA4B5BB
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 02:13:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27C8B3A906C
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 01:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F34E713635C;
	Mon,  3 Mar 2025 01:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oLDZ4oM8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A195684;
	Mon,  3 Mar 2025 01:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740964377; cv=fail; b=CVIdtBe8lPZpqfp6XEsrFaC/Agnk8Ag5+cGX85p29f6pbkBHB/Cg6Ac4SI5ecaaAACusHIObxd5lhXGemCrYpb1BLOlXr209qI2f4Vfv+Z2FCvJu7FuPu1nnF+F/YGPy53Xr6jtt3zcLKhcW7zn85zd6cxULOrlVWDuZDDfu1NI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740964377; c=relaxed/simple;
	bh=r1xlOogWvkyyLxtzZvtwdKQCINmxy2xhUCBmipCpbFY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aOwJbYbsD2JoDP5B3ToCD/+8qICyiQz7WPbhg6Dxfm07JsgFyUY9viRT5dFQnmgacfe/yJ0njm+9KiPfdkyQHrVhw2zBa82yVGLe4d2aYyH4VKt0uglfg5Yix7LDCanilgJQg1GEN794Z9ZHqNL6oZmJZRN7oJ36FF5cJ9a91fg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oLDZ4oM8; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740964376; x=1772500376;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=r1xlOogWvkyyLxtzZvtwdKQCINmxy2xhUCBmipCpbFY=;
  b=oLDZ4oM833NR4/7mDR4DC3NGJeft/OlzLhYL12luJrwtqWPknZhJoKjK
   zE2ntgvLzDH3jiI0hIJilCUV5ApoDWnezhI3kn3/F9NE9tX7LA5XZAyOp
   pX/yFH6qQ7ujRVcfA8QX4+VHG/L3ColNw49QwUF7HIMHO1a/BPm5TFahd
   ENrDaVRKN7tb/1rICSsktBoA9Xel9/OS3lTUD7hRYu31QxGW092vaAkab
   sxLHDX2IRBDCUU8J4/b6utPuhut53g0pj7eOTU4mZjIlej9zQVVY656W8
   ymo/We0xtFwSlpLFyzKvLIR0OJBFA5YbDFU2mxCvIn8/k1w3Fkj2a2xBs
   g==;
X-CSE-ConnectionGUID: 8HOQP+8JSsqQMGo49xe5yQ==
X-CSE-MsgGUID: v661WICUQxe365M4cZZ1vA==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="41741678"
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="41741678"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 17:12:55 -0800
X-CSE-ConnectionGUID: 1Mui+SGSSViXBVOT57PAIw==
X-CSE-MsgGUID: VBAvtgIkTDWLn4iXJ0HEPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="117856188"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Mar 2025 17:12:53 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 2 Mar 2025 17:12:53 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 2 Mar 2025 17:12:53 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 2 Mar 2025 17:12:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cBGZdA7uZFue1aljtHQuwywPk8rhEeqzeaKR9SC9mwZItMLmbTAER8sAdsSTUK/ELUMNtSkDxY34IoTjSoONYf4pn4hPLpPV5dm+jRDm+r2KWb21J9DvEASSjnt31ncmPEHs6srgEGV5URr1RqSHlBDy/m3he3RmFuhidZTR9H9aJiz5oD1UHiHIX7RfzLzFoFcH/J91Cm9aKkRDXRNkoA6pvzbm/nLgEj0BjcHvxX/n5tlX97gJZaJilgctm1fOHHzT1OPjYlNm+FbbsGJXqKVXAAf/IdQ8f8Xt0bA9lqRbDMOHPQ57QsaFwJojIVqavgzSWGp73pjbwM7jsNgBFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cl9Lac2LeB2eNE55hNysZgVnFU/yGHbzWVEp2B0P/q8=;
 b=y2yX1KylIs58SH++sZ5rsuMN0n6x/eVNgnhNecK4e3TadeaGFFb7TyZv3k11ZfrZcJrxiXd/wH307ht+a7oe6Vv214oJb0Eh6zpVh01lxXN7+T7zaR/z6UlQh11Xb1ZPvXLv4xPsen+rE9yNiqx7DTQ35fJRImFYRXc3+Wn+S8AY1Ex058EsRDZpSR2AzEuDDRZhEezT/9wsz1/RIqJLpfr13pdQkAIRexvwjtrckGpr+0nQSopjJofa00l8ITCTlXDZIZ1Ew2Ga2OtRQ31XKyegUocgPxkd8zb0qWq36QfLL5fpzE3vhToQdD7LWwg9Zn1bLBLlPBauDWeaYWeYxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6710.namprd11.prod.outlook.com (2603:10b6:806:25a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Mon, 3 Mar
 2025 01:12:22 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 01:12:22 +0000
Date: Mon, 3 Mar 2025 09:11:00 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <seanjc@google.com>, <rick.p.edgecombe@intel.com>, <kevin.tian@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: x86: Introduce quirk
 KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT
Message-ID: <Z8UBpC76CyxCIRiU@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250224070716.31360-1-yan.y.zhao@intel.com>
 <ecbc1c50-fad2-4346-a440-10fbc328162b@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ecbc1c50-fad2-4346-a440-10fbc328162b@redhat.com>
X-ClientProxiedBy: SI1PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6710:EE_
X-MS-Office365-Filtering-Correlation-Id: dd48ed67-bdfb-47ea-0bf2-08dd59f0739e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1KFKOkTsyUTWImt+e3e1QUYqllWp62OnJ5io1GhrDYJvbhqBzytgF5ztP3yP?=
 =?us-ascii?Q?XFAhRWi52H79xWsGeDuCqwI2PZ25sWuM2g7IonfOXiH/1USwJFZQkrt5e3Nz?=
 =?us-ascii?Q?B1RBt1JH574/wPYYsHaDLwBReEnzUxb8F3OiYeCWfmoR4cN+eLfGvKpfmgF6?=
 =?us-ascii?Q?xrNMc6PordQaBHub6uI1Aso0typtH2S3tw/qRJvJHg9Qt8gOnOfr6QeBUG27?=
 =?us-ascii?Q?h4kP4xNnUMKg6hLBsqR7Hk66f2Lm0h0xnDy7Xws1qhfffehH6TMvy8BXVlLG?=
 =?us-ascii?Q?jXNdBbdoGzMIS0qMXaWNEqVZKzS1Bq0YWNaurPg7YrQvB5liSGYKl0jUhg6W?=
 =?us-ascii?Q?0HAQNCxyYpD9TYd/yKYf+I1k9qIJAOzhBbsheByt8VTro0GeMfyuSiGh1Q6b?=
 =?us-ascii?Q?vsEGIi4MMFn+4ysFGOzPP+ukT0S9mWSLP090qYpB5ZREadPK/wAFD7H3x8CY?=
 =?us-ascii?Q?AOuZwyw8u7N5HE+1YsyWsqyn0QEwsds2RYQ4Xjo6ZmJnKZDaMYG4YbtU/6Tu?=
 =?us-ascii?Q?G6PLJ+vT//wvMihPKjObuSdgXCPPzTOaJUmpPU6WVX2dQgcNhcAnaHcOw3hF?=
 =?us-ascii?Q?4L6WSvXvRkYvS5RoK9ceGqxo9WVE5Sa1fXmkgWnymN8hNCVF0kEO/jzRZ4K3?=
 =?us-ascii?Q?tGwrWn+vnhUvSUvzr1g/PFdowfTLw7VDu06rLV8EDlf5mBUXIKIpTTpWjejD?=
 =?us-ascii?Q?cN7mRI+QjUSRBzk8gTFMrhU7ThNo7/wp3sAIWuvzM+xZmeDE3cfvXV8j/O1V?=
 =?us-ascii?Q?67np0w3Wy3jpPyEMXoqZSlRMpKbewr+7NzRSzn0NC6lhW562xOoPdi9qLQ66?=
 =?us-ascii?Q?jLPiKgxQ1ADr0ZR5ewnC9N4D9YdCCpX/TbKjfZfLmzfqW0wdznrKn4ra/lbW?=
 =?us-ascii?Q?v9SaSnxoZWLVOtDCIKe+EvzWvAtOj9wzLzN8Oyb+TMEHmf3l8/T1WKG8C5EQ?=
 =?us-ascii?Q?Do2ETdu6YbXaeKRaAWOIPDIcHqMc2yrfd1MAsyBfMG8JiPp1K6FIfvCDYOCT?=
 =?us-ascii?Q?biz6fyJJn6pkOMF1LBK0GcbhUfQ3RqqLagA4TTlkUoJM8c2RoHS55nOo685t?=
 =?us-ascii?Q?g+52IhmZwqzq+P15EU0kAwCfDnTypf2tMgbxB7SJtaj/561JJa3kkuLF5E8I?=
 =?us-ascii?Q?1+3lkfksPTHeNT3X06E4zNSRqHQ8e6iatc7DBabDZL6efd8ndJ0/OtL69Y3L?=
 =?us-ascii?Q?u8ZB2zIlxzfdChoLIIPcK1HrDMqR+KVt4woIvWShjBHQbD3nDg/YW8Klz8qy?=
 =?us-ascii?Q?Nh4/lYlioY7NdM1CFYgIXCxNwpy4zov7yLEx4zz//Q1WH7Pvpa3ovlSQ6MUw?=
 =?us-ascii?Q?svXL57WQOQcCG+i/9yi29r+OANeG/FqtduwZR4R1I7LFWCLgniFgXu+Qnzm3?=
 =?us-ascii?Q?MQgCn97Kx6nnd2lRjzZp65p0JI6BlDhpMbY0MaZB47aCTSG0QA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7SB4rYGVGsR5S5xU5Pc09mCvw92UmO6X2awhvN+dMYbw+ZGsSeaKdY+DD11V?=
 =?us-ascii?Q?+BMMP5Z113eF6/WK0QUA4kjyxzx0aUI1dANP+6BULWrJweL+06R5ZU8dp72q?=
 =?us-ascii?Q?6GlR9lh5i8FtmWg9ZPD9saBiIBxVkqZ8XYhZA2KyG3cVy8rLe59s3gu/y06W?=
 =?us-ascii?Q?UCl2wwa4FxYkHzJwhnGF/h3lL9OWejkwVi7z3i4QyWerXDz/oqagkYQcL4H5?=
 =?us-ascii?Q?ePSHTjx6rfKcI+0EnqPIJJi/wRoHbD39J2PcWPyeDCGwEMC+vzhNzQyF8YyD?=
 =?us-ascii?Q?utB3mPRZ9mLIz4ejB1nX1PsxAoSDD7D3qdNSLjQNA+KFMRoYkVghc9lw16Mj?=
 =?us-ascii?Q?HIWfuhw/HBZ1Fi3o23HPdv1bzwKWkMJkQKsZ71BH0f2H0DDyCwL3IaFUHnJd?=
 =?us-ascii?Q?SYnJzBNwRiJXvRcZfZUWp4sCUUEplryqwA2LcDqPNTU7ugxi8VRxyQ42Qf+r?=
 =?us-ascii?Q?8CiMlt/Vp2uyvsIM2xFhXLP4ARzvD3++zjB+qLq6iNT6kfDSTLoZyTjZESgm?=
 =?us-ascii?Q?hTFLH/FElNfb8DzE460OX9VF422dSCgEBQNNGjDUbapzg/QIk5kawzRfwIaX?=
 =?us-ascii?Q?cA8WMeWdb5erW4+RONB+GHjoXQsFRp9M/AXjVjmvsKoBp9xZ8OAd1FSC1QzU?=
 =?us-ascii?Q?vVMDgrfIfjaXE9NcBIQt4Jdo0J+bN65shuaFa9g6cD9IFsE6PvvVxg+nzF/m?=
 =?us-ascii?Q?NZyPn0CuD3iV5DPL8Ax3rSHd3SObNDYUrJKk9fxlZhkvrCYZvDv7eMAwube6?=
 =?us-ascii?Q?jl+zMzzOPhDPWsFi1BjoNXeD+f+xzs/LRU+nI0HPZ0YeHDa4gejAnw2gVB/X?=
 =?us-ascii?Q?bhO99b3uwBuIswxf70XYLe+8OlvedoYdpQFtRFuVZ/aWCNb8Wt2Cf2GrMX5V?=
 =?us-ascii?Q?KcygcgJM7W8ePVTGa8BJiB1iz65wnN0FYDznlM/6zDJhq7PhXTCNxvqDAoa7?=
 =?us-ascii?Q?Ok2chRBsv4zyKLcBgDIyvCDO2+UU9nkBz8k3W3hB7QYm0TgVkSLHlU223ovE?=
 =?us-ascii?Q?wI4tTAlASQK7OU1X4dOjlERJyPXyDGSWwfQc6IkMZT+q+J1wYGYzE5sGMc/+?=
 =?us-ascii?Q?PU3mKN1e86AkoReXv95lWSUpH8V3QtVmSIfATHzETnKNWlP7eOzXKe16hJXo?=
 =?us-ascii?Q?MhVJyimqGj7p5aJNVnVFng/HokmEemVIqsntLhI607e1EzjYSTq/YXLe4mNS?=
 =?us-ascii?Q?leR6kMgmhdm8pqKtSM0k/Ozj4k66kCmC7jHmdd7XEi+vzxG4jcDoRUapQv1x?=
 =?us-ascii?Q?1xKmxrBWg0wXv7ZZCd8aWDOPfiACYaX6oTAAH/TdlStA22T+hFqX5MJZj3Pa?=
 =?us-ascii?Q?Q7tQD2lYTZ2t4oA+LNTQ2Xvu+IeFDM9B77JuJWhQxrthGLO6BVxCq4zRNmc9?=
 =?us-ascii?Q?tCE2SghpvAdksBmtncmyGtDG59U/0sSvWkDE6FiNYlGYI5hEZ02fbf9L7bv2?=
 =?us-ascii?Q?q9hNLJ8OknbVW7rNAPj1T3RjPxgvJkGRC5JNIo0VcbX5QF3cPCXqWEx7drNE?=
 =?us-ascii?Q?sVPce7+UY09nKnn/7Mbu9aZOzGrtKBUd6UHa2ZVPzmtY8YgU4IDKUYohA8Vm?=
 =?us-ascii?Q?EWKAbK1QwSGVd1KyvVq0sgH7lfaOQchxbQlxz/jU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dd48ed67-bdfb-47ea-0bf2-08dd59f0739e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 01:12:22.4455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7w+PcclkCQBm5vLeskkcGQGCl7quwF/M2G99S32CyDaB3Ckj9O0B0AtbWOJ2x4W2kJpTNn0EfBd910PH8rkNZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6710
X-OriginatorOrg: intel.com

On Sat, Mar 01, 2025 at 07:49:13AM +0100, Paolo Bonzini wrote:
> On 2/24/25 08:07, Yan Zhao wrote:
> > This series introduces a quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT as
> > suggested by Paolo and Sean [1].
> > 
> > The purpose of introducing this quirk is to allow KVM to honor guest PAT on
> > Intel platforms with self-snoop feature. This support was previously
> > reverted by commit 9d70f3fec144 ("Revert "KVM: VMX: Always honor guest PAT
> > on CPUs that support self-snoop"") due to a reported broken of an old bochs
> > driver which incorrectly set memory type to UC but did not expect that UC
> > would be very slow on certain Intel platforms.
> 
> Hi Yan,
Hi Paolo,

> the main issue with this series is that the quirk is not disabled only for
> TDX VMs, but for *all* VMs if TDX is available.
Yes, once TDX is enabled, the quirk is disabled for all VMs.
My thought is that on TDX as a new platform, users have the option to update
guest software to address bugs caused by incorrect guest PAT settings.

If you think it's a must to support old unmodifiable non-TDX VMs on TDX
platforms, then it's indeed an issue of this series.

> 
> There are two concepts here:
> 
> - which quirks can be disabled
> 
> - which quirks are active
> 
> I agree with making the first vendor-dependent, but for a different reason:
> the new KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT must be hidden if self-snoop is
> not present.
I think it's a good idea to make KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT out of
KVM_CAP_DISABLE_QUIRKS2, so that the quirk is always enabled when self-snoop is
not present as userspace has no way to disable this quirk.

However, this seems to contradict your point below, especially since it is even
present on AMD platforms.

"we need to expose the quirk anyway in KVM_CAP_DISABLE_QUIRKS2, so that
userspace knows that KVM is *aware* of a particular issue",  "even if disabling
it has no effect, userspace may want to know that it can rely on the problematic
behavior not being present".

So, could we also expose KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT in
KVM_CAP_DISABLE_QUIRKS2 on Intel platforms without self-snoop, but ensure that
disabling the quirk has no effect?

 
> As to the second, we already have an example of a quirk that is also active,
> though we don't represent that in kvm->arch.disabled_quirks: that's
> KVM_X86_QUIRK_CD_NW_CLEARED which is for AMD only and is effectively always
> disabled on Intel platforms.  For those cases, we need to expose the quirk
I also have a concern about this one. Please find my comments in v2.

> anyway in KVM_CAP_DISABLE_QUIRKS2, so that userspace knows that KVM is
> *aware* of a particular issue.  In other words, even if disabling it has no
> effect, userspace may want to know that it can rely on the problematic
> behavior not being present.
>
> I'm testing an alternative series and will post it shortly.
 
Thanks a lot for helping with refining the patches!

> 
> > Sean previously suggested to bottom out if the UC slowness issue is working
> > as intended so that we can enable the quirk only when the VMs are affected
> > by the old unmodifiable guests [2]. After consulting with CPU architects,
> > it's told that this behavior is expected on ICX/SPR Xeon platforms due to
> > the snooping implementation.
> > 
> > So, implement the quirk such that KVM enables it by default on all Intel
> > non-TDX platforms while having the quirk explicitly reference the old
> > unmodifiable guests that rely on KVM to force memory type to WB. Newer
> > userspace can disable the quirk by default and only leave it enabled if an
> > old unmodifiable guest is an concern.
> > 
> > The quirk is platform-specific valid, available only on Intel non-TDX
> > platforms. It is absent on Intel TDX and AMD platforms, where KVM always
> > honors guest PAT.
> > 
> > Patch 1 does the preparation of making quirks platform-specific valid.
> > Patch 2 makes the quirk to be present on Intel and absent on AMD.
> > Patch 3 makes the quirk to be absent on Intel TDX and self-snoop a hard
> >          dependency to enable TDX [3].
> >          As a new platform, TDX is always running on CPUs with self-snoop
> >          feature. It has no worry to break old yet unmodifiable guests.
> >          Simply have KVM always honor guest PAT on TDX enabled platforms.
> >          Attaching/detaching non-coherent DMA devices would not lead to
> >          mirrored EPTs being zapped for TDs then. A previous attempt for
> >          this purpose is at [4].
> > 
> > 
> > This series is based on kvm-coco-queue. It was supposed to be included in
> > TDX's "the rest" section. We post it separately to start review earlier.
> > 
> > Patches 1 and 2 are changes to the generic code, which can also be applied
> > to kvm/queue. A proposal is to have them go into kvm/queue and we rebase on
> > that.
> > 
> > Patch 3 can be included in TDX's "the rest" section in the end.
> > 
> > Thanks
> > Yan
> > 
> > [1] https://lore.kernel.org/kvm/CABgObfa=t1dGR5cEhbUqVWTD03vZR4QrzEUgHxq+3JJ7YsA9pA@mail.gmail.com
> > [2] https://lore.kernel.org/kvm/Zt8cgUASZCN6gP8H@google.com
> > [3] https://lore.kernel.org/kvm/ZuBSNS33_ck-w6-9@google.com
> > [4] https://lore.kernel.org/kvm/20241115084600.12174-1-yan.y.zhao@intel.com
> > 
> > 
> > Yan Zhao (3):
> >    KVM: x86: Introduce supported_quirks for platform-specific valid
> >      quirks
> >    KVM: x86: Introduce Intel specific quirk
> >      KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT
> >    KVM: TDX: Always honor guest PAT on TDX enabled platforms
> > 
> >   Documentation/virt/kvm/api.rst  | 30 +++++++++++++++++++++++++
> >   arch/x86/include/asm/kvm_host.h |  2 +-
> >   arch/x86/include/uapi/asm/kvm.h |  1 +
> >   arch/x86/kvm/mmu.h              |  2 +-
> >   arch/x86/kvm/mmu/mmu.c          | 14 +++++++-----
> >   arch/x86/kvm/vmx/main.c         |  1 +
> >   arch/x86/kvm/vmx/tdx.c          |  5 +++++
> >   arch/x86/kvm/vmx/vmx.c          | 39 +++++++++++++++++++++++++++------
> >   arch/x86/kvm/x86.c              |  7 +++---
> >   arch/x86/kvm/x86.h              | 12 +++++-----
> >   10 files changed, 91 insertions(+), 22 deletions(-)
> > 
> 

