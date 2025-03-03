Return-Path: <kvm+bounces-39847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7FFA4B66A
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 04:15:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C562E16BC9B
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 03:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE68F189913;
	Mon,  3 Mar 2025 03:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IffHjtdC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430E0190468;
	Mon,  3 Mar 2025 03:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740971750; cv=fail; b=hv1xXLvH/1s58wAkcIOB8zIq5gPRuWTLivEAkpksK3ZyorRw4vrDgpTQBOwpJUgsr9aTam8CmMgTMmmP46VfryEuMLeMa8zL6aL67UHjaVCYtOu++w3/iO5n9rhzr7JudH9RBnuiRuANr2Axs0jtGPTmpG0yswGSaQ9H5ALAqHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740971750; c=relaxed/simple;
	bh=J3AYae4TMgBSKQRElnh3XS4CsAXWJIuK1Yfz2DTkUMo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=b44zQnsSA4efQjF0CaiGHMkwOXll30wYsfYuL9ScRpkuxG2nR/syiTT7uopT8OIOPFMWGo43Cnx/2qcgetzju6jyeB6wi0JPwACoRbnPYKeB0A74+ys8b8VyghTFsdr6aSa3VcpvzQhR4BQHr7yvFAxCzS/yQZzl7KD0gUmFV6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IffHjtdC; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740971748; x=1772507748;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=J3AYae4TMgBSKQRElnh3XS4CsAXWJIuK1Yfz2DTkUMo=;
  b=IffHjtdC/5xDh941KolBV2ia9d+r1A7BeXU0/7X/WZE9qy2R4XJUTzfN
   I6V9QNqZvxx8HVbDFOCCWDpyA62Cie0YLk+DJjxDozpZ+GORHde4LzcIo
   34BJNJZ0RaSrQPvDYaTE9JH4+DHbRiAr7xhqb+EBP7Moy869UIwARxO48
   6XXAvYg1ykJQ5R5D6R7rujkiMtz9Gd4l5irCJlWYXTf/3Hd2IHuoU0/OA
   Ani2wd6HaNWgHkFh3/vmvEp6387C7v5VdcspK6DIctBd56kdiQiq8Ud9g
   GCnpneHAs/83g5E9UpT5v9HLY8gKoqHvCmqNfVIKaPPVq9hsF+Gb1eeyQ
   A==;
X-CSE-ConnectionGUID: rmtq82eaSAqrnk3DB5v17A==
X-CSE-MsgGUID: NEuVChnZT5ec7NPDXVaW2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="59247426"
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="59247426"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 19:15:48 -0800
X-CSE-ConnectionGUID: WqdkWK+QSfqIZc4mWwNFIw==
X-CSE-MsgGUID: yb2E4wU/SqOrDDcMoodisw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118414298"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Mar 2025 19:15:48 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 2 Mar 2025 19:15:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 2 Mar 2025 19:15:47 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 2 Mar 2025 19:15:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q4MPFFSkt0DzIFrIN+HZ2/5FJS9gTebpMJ3IiReKBtF94g9YJluZork0fuIf7bW/zHoZOwFfreDg4MhlJUja8nRLitCViEynigjivIqOG9+8TWQwwmHPUGgn7UYfGSBCzCbowAqGTylxd/avTROUfuiqjITlLAdqL3bDdx/+Rxm0WWjDowzk+iRE62FxnZvc5an9N4rP5BcYqzDnVeJrjIi7u1KMetawEzncH9vpYoGGh60rNDm0DfBtGjMa2bJ4/X3yvVBC54EZUrGmE61dy9NJ5MlLsQF5FqBycc5ZU7iRhERFScOJ5k/jMT5Zcl2Fj8t/TNIfM98KuewLj770Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7QlaKhSHGWvak7OrAcCQ2/jNllNDQAliQAVhBZ3nnSs=;
 b=uXK2LMJGC6/sobBHTXqAMzTRDs33YOfKiXUKa7PVHDZkeqbp66gnnGp1BpCLl2Mo2/Re4KDCgvN7eDHUJZwPYcPJQvKAYt9/GhoGeuHMopOwvGlyTD9ILLcpDUENCcKH4I9NrrzU3uZMJ+m5W5ouMN5l/9SZPFMmMUcvmwgVAgki6w1AmlSOYWRZ6Wn7KtpkZld7TjlqP8UrRbRG6LV5SBGFElvXTM2XuPwdsviDbhmbIldxVZ9tskoXN/o7ArJee+2Ui+PSG3h2opmrTP1Gj61JNH9QVQfOX/s/R/y0BeJC66XQGArlyb/sv8SnddeW9xaM6C+KMnHQpwM7HiuQIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM3PR11MB8684.namprd11.prod.outlook.com (2603:10b6:0:4a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.27; Mon, 3 Mar 2025 03:15:39 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 03:15:39 +0000
Date: Mon, 3 Mar 2025 11:14:20 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Ensure all vCPUs hit -EFAULT during
 initial RO stage
Message-ID: <Z8UejMz7YXV2mQ6A@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250228230804.3845860-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250228230804.3845860-1-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0018.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM3PR11MB8684:EE_
X-MS-Office365-Filtering-Correlation-Id: 896a0826-7524-481b-6941-08dd5a01ac93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?OWoBJgqDLUT6yPRF1yjT3M52D9Cf1x8U9ISQ03JWVuJwy8bUQRLzXEwuygQA?=
 =?us-ascii?Q?g84CDIa+ZmjPeJwudi10ONQtVDXg/sGhJEvLVOOGiWWKDWjaNMEcFGoSPBs5?=
 =?us-ascii?Q?cGFvR41UpXd0LipXJMRlL5DCkShz+tYFh7voQ2XqhL4ePgdOHnRj+cX8ck+j?=
 =?us-ascii?Q?UxbAXi1LaUbyYBUwb8lXSvxbgsoYHn5WHGJ8PbH8kd8Hb+3roeR04rDt3mhH?=
 =?us-ascii?Q?iyavXhRkvBp5M6EA0YABLRD2CycfbEbkL1hnAw+PFo8XC2FriWB2kx25zKaE?=
 =?us-ascii?Q?pqzWfgXMPNacfmRQpYRdfmgV/xQQa8nODj/DePYN7sgUIC4To128IMIwSNa7?=
 =?us-ascii?Q?X7ZUsUpqZJhueJI0v0331piHsVTjqXTa9oPluXBySmaXayX4s0vVOJ8+kLWg?=
 =?us-ascii?Q?iHd7Sc6W7FDXWVfc/fDMnaTTmtxlF/zVO6uKi1gnkS7AMvNvFou6hiGHIDsi?=
 =?us-ascii?Q?td2P7/blLXyWRZn1lrVlltEzEG2dR/R6f6+Wpv1z60bfM8v1IF490HNeon2j?=
 =?us-ascii?Q?Z8lE1Z/zHEkHJuECoYNe5bKGzHV1m906drhMOWV/714jBIVPXQ5oGd3YjMCU?=
 =?us-ascii?Q?GnBGJ1oXt0StresW0V5B/ziRyWEbhIf182aU61SSx2kYJgbbZYqxOY6GR85h?=
 =?us-ascii?Q?UIf9g5zmIOP3DvaxAh8kECKq0hkxiFD3V1kTUxsF+6IECtEb5fFhFzcjscs8?=
 =?us-ascii?Q?ocrMgSU1TdbjFdRaUyaNihyA0cGC9NqacUgD7R9bIMRHBKCotJ6Q64U95Vbo?=
 =?us-ascii?Q?BHITAdVdX0+Jssaqaedssw1rKp9FqwKAqF5dafiLAnZxCu4bhrvAH35hqzcW?=
 =?us-ascii?Q?N5EyIiRGx1ft2ONAAj1x1XVAKehwPIzn0+kGyaK+Sct1mVX3r3Pp4K7cRFqW?=
 =?us-ascii?Q?73LNgn29/sa8JGv05ixVZQGfHJi4WiwhDz52ifXyVd5Uu9pPzDFP/rkK5VcG?=
 =?us-ascii?Q?4CBd4XJ7cbCoUhuXRdhpkf/Qw5mz4h+eDziXa9jrrIHLFEFpd6Xii9kBR9u4?=
 =?us-ascii?Q?N9TmF33BSR4ppAQG4Tl3z4++KZORR60cQWagPXBS08zIQ8liZCeJu6s9QpUt?=
 =?us-ascii?Q?iBMGtUp3yseqgj1DPHQf1tL/6Y2kaNGTuWwBJaP0t4Bnz5JMoGHFdJjRyRxO?=
 =?us-ascii?Q?ym/52mi9KP7usjvxwSSrl6mHCNbwH2n0QjCPm+P6WnKH6d6ONm8tUaj+diGU?=
 =?us-ascii?Q?dgh9rUzi93Kul8xLY0ib5sJiU3/ij2iYq+dvvHyB8CRzqUDNOyq9LX+0MiX+?=
 =?us-ascii?Q?ZqRiPnBgg8jKreB1MPpL9DGqHcrzophL6UXPFwqcZ0xaT6DB0OY7Jn4IuXO4?=
 =?us-ascii?Q?X9+YzlqsWurJPpBaausUo7m/pdxa2rImzbhuZfuWFBk5OG5cdik8qgjnYwcD?=
 =?us-ascii?Q?55sw/0OiKd8HwfnTfaLMJb9aknQ2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TSK0dbZ96Pzj6M1fJaSNCbn4NFavjeJkc+o1ImIjmBsF/dqRqKXlOnR9vaUP?=
 =?us-ascii?Q?K2AdXDNfR8PkHxKrSkv8T7LLDDGd4whCsIwefttCV+2dfGJcrKwZEda807UC?=
 =?us-ascii?Q?EeIoKGXcMW3YFFlA1VuGWh8cZihsoyrKeihxj3okhIJre1gyHtxSi7JHtjWz?=
 =?us-ascii?Q?TfBrX6L1O8Inp8TSIjEocyTaK3M+wmdU7MK4FycXsDO3CW6Z4vJB/53mNGH8?=
 =?us-ascii?Q?TuvHotjG8lQzWQ1hwp8CMvhdEa6g/J/yLfY2te+g+T4A+DtyE2pQAvi07KTY?=
 =?us-ascii?Q?qBdJAybxTtORZwMIGcpFEzguca9p9RXwv6kvuO0lWegSJE/di3lYPgilKc+O?=
 =?us-ascii?Q?IiEuFhgL9ApCtGwEVsDQftFWiVTJkw6xbMcFYAZEmK2zYVfQFyvOIQG27Du9?=
 =?us-ascii?Q?6zGJJnPPXY2yM9bODBh1qyKZzVojzs20sXtQjIUML4Qhs69bhxHe3CGjSXZe?=
 =?us-ascii?Q?JRzYfcmlwxh+jWmXQggrGJOYdSguIDeEWlKtWzEp/VjI7mkq6YfNB+8GbP25?=
 =?us-ascii?Q?CdW94iSOXScmDPkhhnwUzAyAA+38Nz/uKiix2fPPXTzVdDUyzjaVQimkRVLT?=
 =?us-ascii?Q?UeL/iCAIEK8iNGC7XIgqO7Ji9NNJxS2ecIPb5mcDZBPA80pAs/vEIfPcUqkp?=
 =?us-ascii?Q?MoP5J6xZN8Qa2ywGk9L5tVfBO476aAQK+oJfsxHP5T+wIc3VxinlEwmjNT0W?=
 =?us-ascii?Q?xlwaNpVzvIP7ksE/8qcmG05DZw0YiNdE9iswZzmF5qgugb9VJOkj31oCXvQz?=
 =?us-ascii?Q?poCpSYspxklEuaGx+8ADX/FJTfdHeu5dEmbeWpJF+j/JlsFtne2RwQPw+49M?=
 =?us-ascii?Q?I6kt/PnQsF+ZebJntxZEJSW1UN9IzIe/Pu9mr3o5hHBE9JyzJ9IrJotyxFU/?=
 =?us-ascii?Q?+fjeMkLNa0TiBL6CVYU4YFEL4GZ/vgoAwlvWg6bIAaK6buwdpZbSJeyDOCrO?=
 =?us-ascii?Q?l3hIW0Pbi5NgcX5AZd6Xz2aIu+YRF8vIVU96FVe/Tc5Wa1D5b5nE7VpvxqqW?=
 =?us-ascii?Q?AfNmUSF4l2O9ZyuM13+SK2n1JX79eDA8PmH2+wS21kME4GehEt/exzCuutoo?=
 =?us-ascii?Q?2qNeGvJrYMlgqYqL7dNNw3Rahn+Uhl+gYZcC/GuS7KNsDpmIfVdehWOoWXKI?=
 =?us-ascii?Q?Jj35TbukMEdmozuXmdd2zT2zinr7XwcPOUKJidFBVWNu+zpQ6EJKHGh1MmJZ?=
 =?us-ascii?Q?d3jzXlz2yWuvCJARe1RJV9L8PVZ0zAcluIRag1gr7UJINMKJSxqOuY5tevCx?=
 =?us-ascii?Q?66lw/Ba1fOYPWVnx8HinHII6/K98kOw/LF8R/9mFk3pMdPLebSn+uObOjL0F?=
 =?us-ascii?Q?6eXQ4XX2Tz8qKsEMatOPmk1tpYPerOciNnOFmEkjBnOjaD41GXQS5yOCc6Jx?=
 =?us-ascii?Q?ZbaF2sjy7bSUWQYMxbIBtLhu/icHYqCkdwlzmZjjEsTZkKs/W5YQWpBc1v9c?=
 =?us-ascii?Q?hPHrnWpUwcSBD/PwyqEiqEE/mE0N0vp3VtavelSW2ZhgpFsc1OxORHx+TzHe?=
 =?us-ascii?Q?BhDwk5geN+9laxNsjcrNOVssDDD2+dhNisVg2PngNxUcWTkgojkebjgV00DB?=
 =?us-ascii?Q?2tFpddCKy8ga42pHd9AQolXH5f/9X9cAFmOiVDJ+xh1UbBHL1s+fGH11gB1r?=
 =?us-ascii?Q?dQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 896a0826-7524-481b-6941-08dd5a01ac93
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 03:15:39.4323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s31kwtLj6SBbkgoYa9htKW24f9plUP7nuIXDdUM601vb+O52u5oHXiZ2tbmn3gNUb4N/+g4uVF7gjLPXH8cshg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8684
X-OriginatorOrg: intel.com

On Fri, Feb 28, 2025 at 03:08:04PM -0800, Sean Christopherson wrote:
> During the initial mprotect(RO) stage of mmu_stress_test, keep vCPUs
> spinning until all vCPUs have hit -EFAULT, i.e. until all vCPUs have tried
> to write to a read-only page.  If a vCPU manages to complete an entire
> iteration of the loop without hitting a read-only page, *and* the vCPU
> observes mprotect_ro_done before starting a second iteration, then the
> vCPU will prematurely fall through to GUEST_SYNC(3) (on x86 and arm64) and
> get out of sequence.
> 
> Replace the "do-while (!r)" loop around the associated _vcpu_run() with
> a single invocation, as barring a KVM bug, the vCPU is guaranteed to hit
> -EFAULT, and retrying on success is super confusion, hides KVM bugs, and
> complicates this fix.  The do-while loop was semi-unintentionally added
> specifically to fudge around a KVM x86 bug, and said bug is unhittable
> without modifying the test to force x86 down the !(x86||arm64) path.
> 
> On x86, if forced emulation is enabled, vcpu_arch_put_guest() may trigger
> emulation of the store to memory.  Due a (very, very) longstanding bug in
> KVM x86's emulator, emulate writes to guest memory that fail during
> __kvm_write_guest_page() unconditionally return KVM_EXIT_MMIO.  While that
> is desirable in the !memslot case, it's wrong in this case as the failure
> happens due to __copy_to_user() hitting a read-only page, not an emulated
> MMIO region.
> 
> But as above, x86 only uses vcpu_arch_put_guest() if the __x86_64__ guards
> are clobbered to force x86 down the common path, and of course the
> unexpected MMIO is a KVM bug, i.e. *should* cause a test failure.
> 
> Reported-by: Yan Zhao <yan.y.zhao@intel.com>
> Debugged-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Nit: consider adding Closes and Fixes tags.

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>

> ---
>  tools/testing/selftests/kvm/mmu_stress_test.c | 21 ++++++++++++-------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
> index d9c76b4c0d88..6a437d2be9fa 100644
> --- a/tools/testing/selftests/kvm/mmu_stress_test.c
> +++ b/tools/testing/selftests/kvm/mmu_stress_test.c
> @@ -18,6 +18,7 @@
>  #include "ucall_common.h"
>  
>  static bool mprotect_ro_done;
> +static bool all_vcpus_hit_ro_fault;
>  
>  static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
>  {
> @@ -36,9 +37,9 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
>  
>  	/*
>  	 * Write to the region while mprotect(PROT_READ) is underway.  Keep
> -	 * looping until the memory is guaranteed to be read-only, otherwise
> -	 * vCPUs may complete their writes and advance to the next stage
> -	 * prematurely.
> +	 * looping until the memory is guaranteed to be read-only and a fault
> +	 * has occurred, otherwise vCPUs may complete their writes and advance
> +	 * to the next stage prematurely.
>  	 *
>  	 * For architectures that support skipping the faulting instruction,
>  	 * generate the store via inline assembly to ensure the exact length
> @@ -56,7 +57,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
>  #else
>  			vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
>  #endif
> -	} while (!READ_ONCE(mprotect_ro_done));
> +	} while (!READ_ONCE(mprotect_ro_done) || !READ_ONCE(all_vcpus_hit_ro_fault));
>  
>  	/*
>  	 * Only architectures that write the entire range can explicitly sync,
> @@ -81,6 +82,7 @@ struct vcpu_info {
>  
>  static int nr_vcpus;
>  static atomic_t rendezvous;
> +static atomic_t nr_ro_faults;
>  
>  static void rendezvous_with_boss(void)
>  {
> @@ -148,12 +150,16 @@ static void *vcpu_worker(void *data)
>  	 * be stuck on the faulting instruction for other architectures.  Go to
>  	 * stage 3 without a rendezvous
>  	 */
> -	do {
> -		r = _vcpu_run(vcpu);
> -	} while (!r);
> +	r = _vcpu_run(vcpu);
>  	TEST_ASSERT(r == -1 && errno == EFAULT,
>  		    "Expected EFAULT on write to RO memory, got r = %d, errno = %d", r, errno);
>  
> +	atomic_inc(&nr_ro_faults);
> +	if (atomic_read(&nr_ro_faults) == nr_vcpus) {
> +		WRITE_ONCE(all_vcpus_hit_ro_fault, true);
> +		sync_global_to_guest(vm, all_vcpus_hit_ro_fault);
> +	}
> +
>  #if defined(__x86_64__) || defined(__aarch64__)
>  	/*
>  	 * Verify *all* writes from the guest hit EFAULT due to the VMA now
> @@ -378,7 +384,6 @@ int main(int argc, char *argv[])
>  	rendezvous_with_vcpus(&time_run2, "run 2");
>  
>  	mprotect(mem, slot_size, PROT_READ);
> -	usleep(10);
>  	mprotect_ro_done = true;
>  	sync_global_to_guest(vm, mprotect_ro_done);
>  
> 
> base-commit: 557953f8b75fce49dc65f9b0f7e811c060fc7860
> -- 
> 2.48.1.711.g2feabab25a-goog
> 

