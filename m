Return-Path: <kvm+bounces-57205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA338B51B8A
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 17:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D0F556436F
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 15:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D79631DD93;
	Wed, 10 Sep 2025 15:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bGG96C65"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D900212FA0;
	Wed, 10 Sep 2025 15:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757517864; cv=fail; b=o6urYK6q2zIo596h/Va4sUEtm8yOIPI3+Dnzv3Yh68+z/MgqAhyEOLmzg+JzKmK0GmKaRs7yZW2xYQ0CwtS7lBBJSWOIUaFi8DZey49Sj4PXO5liwixK0XIpwStm+iUu8BSaQ+78ZfH9s7yjH6sJLTqmJeHE+HQE9/jpa/+i83A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757517864; c=relaxed/simple;
	bh=spF0+7ssA95fkMEsuAXsVF9bIY1QOd2JERrPNSnYieU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rIhJcszBtQSc0B/+cA8SvB2Ex+G5ibm2PKo4zs/tM/RLBPQ+AxjbgEJFK6+bKhtB5cSBMZFi7vDVEY/+j08nvf54Q74ExiCOrc8FsxYAsf1aKPdBQkSLpHa0mm+RzMV8Mws0oY+bRqS13hrftt4MGEnie55Bdmb4EFFk0DvjhVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bGG96C65; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757517863; x=1789053863;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=spF0+7ssA95fkMEsuAXsVF9bIY1QOd2JERrPNSnYieU=;
  b=bGG96C65qaG7LU2YpANJijv4bo9ePyHr3UyiSzqMZLIquNcuZIc4MyJn
   RifOq6MHKf/SM165Y5bE0DP80pttDpjrbsXpr7KBJd172l0tdVWdi8icU
   mwX75ZnD0IErMveBjm0bIxc9Lmdfip+V8ukqExFVJsxdPiU+nDQ/BC4H5
   Df3X1p3hV118FDeYIYUG7MxuRZhbNa26OChBoeq6aAtXYA5dOgl+b/yki
   /5DgUxJIchPDJmbEkiWurGQTUC/S80L4kEPSOuijUCvJ2+IJ0Kbkxeuzh
   ur2V7KBcKYLbFNqiKvuOkCzRccx5+Z3bMX5yYcDB3Ko5U6oHe6F3EDT4y
   Q==;
X-CSE-ConnectionGUID: YsHLiYj/RoSeKCnCT1vt2g==
X-CSE-MsgGUID: BS5p2tasSZCkX+b2IsnD7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="59943112"
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="59943112"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 08:24:22 -0700
X-CSE-ConnectionGUID: ORbPwwBgQhyJ+qNfi8AKQQ==
X-CSE-MsgGUID: lExG/EFLQYOUM4FavmRDxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="173503415"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 08:24:22 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 08:24:21 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 08:24:21 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.65) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 08:24:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XOY3WcMr/GBEB/NxfB5D8whnNULaAMRocZVCD+ziQy/z9FTXAbQqcSqef7iPmFTrSWlgr/suH5w0LW7HJIryUQmouU2XXFo6ZewhMyA0hkwtzxEpwtM1N2vUZPAWWiDAQGwEsZQkIzNS6hqwl6T92gp0026Ko97tX6Claj3w3RRMdaDzcQEtAPjnvsaarEGr6jA1FfAigSRMDYAiDCuP6I19BPVmI9bne2O7b1qTsyQlEHk6rPqX5NbAb1VsZ1ZhFLiYO4biVYzlDNpfRZQsgXrL3sAkrH8vuOqz9Sfth7tDZahxlcvjX0BEEiqi5Ic7Dw9DzhU5yXM3YJHvXZEsbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLB+BF5YR18OAuXA+My9SFV0K3vLFngYzKoYNJRFxDU=;
 b=moSZ1Qy+cS4GT+rZBAtlls91NhfXK2Pa+NcaSeLyqaVdc8vjKf5ejy+765+AI02bnlBdof49Xl0cLUtiojFl5n8BB+T1ATwiFbvQ5RpUlBIQi9sWnnwyFFfDYprvKcEI8omnhq5jzb/rxykKbft3HN927xuyuUcgHpEE2ZMGWe1s8saploKnRN9KELicz18U91M4bNRNE7TsWpIS3WdEly1+JTPY9XiufpH92RY236BcJthIWQq4J1bieI3yDUNv8CqqHyVt/xXhIfQraoD29dBi9RYno9bdrbSPinx3AT+z2cU3sy2wIceZuzkdtRmZlWY8+be6+wtSqbTeSUB7DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB7271.namprd11.prod.outlook.com (2603:10b6:208:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 15:24:16 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 15:24:16 +0000
Date: Wed, 10 Sep 2025 23:24:02 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <acme@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<john.allen@amd.com>, <mingo@kernel.org>, <mingo@redhat.com>,
	<minipli@grsecurity.net>, <mlevitsk@redhat.com>, <namhyung@kernel.org>,
	<pbonzini@redhat.com>, <prsampat@amd.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <shuah@kernel.org>, <tglx@linutronix.de>,
	<weijiang.yang@intel.com>, <x86@kernel.org>, <xin@zytor.com>
Subject: Re: [PATCH v14 06/22] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
Message-ID: <aMGYEvUZ6sg6dPvs@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-7-chao.gao@intel.com>
 <be3459db-d972-4d46-a48a-2fab1cde7faa@intel.com>
 <aMFedyAqac+S38P2@intel.com>
 <5077c390-1211-42fc-b753-2a23187cf8ca@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5077c390-1211-42fc-b753-2a23187cf8ca@intel.com>
X-ClientProxiedBy: SGAP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::25)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB7271:EE_
X-MS-Office365-Filtering-Correlation-Id: 21e8a494-2e89-4713-531c-08ddf07e1a76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9uZuticEutVYX8D5Ts6CcwRFMz0jbJNHBPDc5kyWIFo+oe6e3lBFdPOh0ShL?=
 =?us-ascii?Q?V9WzuVt4zX/Dx6rsiajRPR7oKemeZeAPWM+uRDaZ8+0ngOZsiuTQb9XqixZm?=
 =?us-ascii?Q?J7ayfjEza3Tw1TnZJOi5Yz8pS1xAxAZK77Mj1ti2MPBVyTYZYJ0JG9W1x2WX?=
 =?us-ascii?Q?IEw5heA2qn0DM+ek4+IeeTICVQp7FnMOyEu0WZQZd1RL8uvpnuwiKcYXZZyd?=
 =?us-ascii?Q?YJnuOWT+Y1Maogh4iM5NJXT9l7mu/XPFRPkA5/s01pcNZEAHl+rnlSRYwBmj?=
 =?us-ascii?Q?OEDCMIgfm6ffX0WJcRNji0++55gqMloJbGLkgcxQcSWeeTi0IowpuCV6q/yO?=
 =?us-ascii?Q?xjP6vZGPqKmzPrqEAXqrjvgXgWsHFXjIyYDva4T/v365RyRhG3lHoUHnngkI?=
 =?us-ascii?Q?Vyp056qRMnmcXUykMGlUQhKDVIrB8KR78Kfd5yOIc+1aShG6tmulCcrvGezL?=
 =?us-ascii?Q?68hsh49kob1ex2GiQxlOY5BlKgxROyj4/qIwr1PYGaYhCTJZ5S0pGXIG8Do7?=
 =?us-ascii?Q?WQ/oFnNpJymIsd3TM4W9K7EB+y5dMmGxE6T/+tqEs3KbfdaeMgoRD0me5jvF?=
 =?us-ascii?Q?fPQsOhrVXCDC7etgt4LWuqsvzmyVKnpKjJ6Zwl8I4qmbuEC7Ic0DLBBKlGMi?=
 =?us-ascii?Q?AUAixtiKzexlTPRNLcKmPGv+LKMcud/in/qcUc+cPQyyatGhI6LMKnUua6sT?=
 =?us-ascii?Q?9YviOuzwZeSFg6cZ1vWfkUciVsy0rtQfSI4qRP2YyRKKeEGitVGgSRyvX2G9?=
 =?us-ascii?Q?kg6tLjTaM0pMjP8MSutkkjC5+U9beIoGc/H9w4CB753RAOoatZhehxTq68vY?=
 =?us-ascii?Q?3ej4E5Bt/8KmCxTM+qic//OLs2Mnq9Yu069VeTmMb0MKKjeVb3jVEy+YWnRE?=
 =?us-ascii?Q?mheeJPgFhXMIiiwcPoQd/AFPu5+CKCi28n9RTgta0814wE5Qq6GrUNtYoK3t?=
 =?us-ascii?Q?pZifkk/toLqhXN+zpf0h8fSPjLjhPGnHwd6YWpK3cC4vUGnwQRH+Ljh6M6Py?=
 =?us-ascii?Q?zcRS3NizI+JvpB1x/kVNkz5MK9i0KpN7kz6Ec1U3mIcU7VivaIeSK9toFwRP?=
 =?us-ascii?Q?AVVxW/DIEq4xpkVysn5EsTcx+jBZRmO7kGdPdumHUDkdqCwy+gRNt6mji8J1?=
 =?us-ascii?Q?efUYzRe8kjEzrbpfizwtHtMYHTN+3caz8/29oSpDQ9ChSrIO7UrbLdC+7n8w?=
 =?us-ascii?Q?XdTxLM8xKDYK9q6rEmmR1qs1tastEhhRBixZGpiD9DX7+/ZgxqzLe3HPZErY?=
 =?us-ascii?Q?6OK4vf/8AaCAyibsQi6TaMSgyY131Vp0EUhW22KzFB4xjbytGI4vrtmykIRk?=
 =?us-ascii?Q?ZzhVu2Tt5EvzwhxjGjHrXf4rk0l4AwdKqSeyTwEIg02/uMDZya2/gIW9JZlx?=
 =?us-ascii?Q?v7JsRSfzZyM3FR/vbwqq6jKzTRp48c433KyiV8CQi7GHWLvuQkPC05HnoFHn?=
 =?us-ascii?Q?VN2iRJH9Ubo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pYcmZVAYNvwbttaIWsIxi58s+67GUslS31M+O0RdaAqAfgaDEJJJhzV47MpB?=
 =?us-ascii?Q?QnT4z6c1KXn71sOk8Og/l+Yj6X9Y70HU+d/C0w6iYeStGXoP/1pscLF6xo0b?=
 =?us-ascii?Q?Nmpsvci4Q5i9EboNl8lIij36A/gAEiLXsr8dmKfPq8cB7+NCSb4HdPFtV5KW?=
 =?us-ascii?Q?+wh04aK1HSh93kB8B5TA55C38TFsNUyfP0Hym7J/PDXXVAYMcT58Go6VCZmJ?=
 =?us-ascii?Q?ctqWkxAUS+Xyu/5KAImrzqRsfOEOaszbWPtj6PNsIdp5+Aq7HfLOymwTrtQi?=
 =?us-ascii?Q?Apc4IAyuGOpr0cMQ0SdN4Dqqzz9a5vhJG3ShilLYiTY7uUL/ypgcMVDrsOah?=
 =?us-ascii?Q?HKQihhBM7OcWTupvYreWGyaeMpvPkfDbtRH1S3KSprTIrCvWMJ8RBuh4n9PC?=
 =?us-ascii?Q?kz4qUQ7GXeq70Km+QZxe4MuOKcBUZkYRVEReEDb5O6yWvC420cyhh0uLoVpf?=
 =?us-ascii?Q?emNAaET1zOshbmkXoViqONcT1815+UT8kTzcQgTzTCT5EhyOkFnQiTtVZUKk?=
 =?us-ascii?Q?nFithKRpO0bQtuZ0rCNlR3cRQ87aLDElKdsnckN6+LFQPDHDaaVT93eja+i/?=
 =?us-ascii?Q?vg+KlWH1EmrllAyNUFUe9USTdPwb6169cmyPFUxik/9/OEdvlwGkLaSs6Bk/?=
 =?us-ascii?Q?o69lnj+4vthgAdC+E1iw2E96an9R2Kp0LcY1EbEz6meoGXXwfwbspWmZlmYU?=
 =?us-ascii?Q?dlpOo3SQUq+EGHIKxyAzqKzyCQQjsnz8QXyY4FD4sZHEYnIcn42jH6iB01fN?=
 =?us-ascii?Q?f2Xzug58DUJdSeKCcZyim55V8WTXd+c0n9fInWEkAUR3C31wA8GHUslMxQ3D?=
 =?us-ascii?Q?VOsPA5Kft8xh+YG53qZD3bSPPfsJgpYlNNMj7CcE7xXN2MdxbUcBc2l1wdw4?=
 =?us-ascii?Q?76PAmg7T/g4y9Z3onY8xy246pg8kG6U1o1Al9PxQPB9O2kZRCBpNwsgOP2Lq?=
 =?us-ascii?Q?9MlTdvdaAhS/y8Mh2d+Cu0pjyIhP7FGiQMm9d4FXe6JlHPYRerg2MaYuy1TJ?=
 =?us-ascii?Q?FpykpH84t85GVZo7rFBPGtvoHytykE7BDZROCvi2MTiUHm/9UjtAcH54EDc+?=
 =?us-ascii?Q?dypoTmrmDIHljNSRQruQwdNcbF0jKciO2qEannIhCfrGr2S7EZQ/nhiFPymX?=
 =?us-ascii?Q?jjqBe8Y4IdCSDu5FxpHzvTFZRhBzyERAf5hWyuX3QNy5ak8MMDSdw/v8vrtL?=
 =?us-ascii?Q?IzJmkTMON6ffXaGCZYhLZB58e2Z/MN2NfCURQpiEJSZPwOUm2sMxUlG2KA0r?=
 =?us-ascii?Q?B1OuOw1lY0kvDNHZBm8gGq784JIIMMX1D3U5//w0HtXJiY+CC1psotuJY6CR?=
 =?us-ascii?Q?uvOAmFPwesZFcW8r2hVK5qgydgPjRZXmKzct5Z2RkBvYkjSBgbHkUdP4rapw?=
 =?us-ascii?Q?knsM6L4FJSMVJmIDWaTOVM/s1kNqesSV9FOhG88wm/EIjIxeX7JzccK9va/8?=
 =?us-ascii?Q?tP9ONNGNRrCcteFD6UDJgtUGGVZDwrB2UblYn0EKhOXE7fuJL38b4iT6nsRV?=
 =?us-ascii?Q?KfpNb7Q3xzcnZa8c0rbB8ZPW24VPUv/NApOAgFLmFTovjBWE57vkbHB81NSu?=
 =?us-ascii?Q?VfVLbfwWAllJ1YE0B92yFKSBGCH8IrXUhFu+TqQT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e8a494-2e89-4713-531c-08ddf07e1a76
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 15:24:16.0095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SAUtFhsSEHZp3/dbrEOtlStWJO6QF67vvwFwtJc2vMr/dYgBIjTAaBmwiUfQ7+IywEaArTJXILuFr+EH2CvCHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7271
X-OriginatorOrg: intel.com

On Wed, Sep 10, 2025 at 09:46:01PM +0800, Xiaoyao Li wrote:
>On 9/10/2025 7:18 PM, Chao Gao wrote:
>> On Wed, Sep 10, 2025 at 05:37:50PM +0800, Xiaoyao Li wrote:
>> > On 9/9/2025 5:39 PM, Chao Gao wrote:
>> > > From: Sean Christopherson <seanjc@google.com>
>> > > 
>> > > Load the guest's FPU state if userspace is accessing MSRs whose values
>> > > are managed by XSAVES. Introduce two helpers, kvm_{get,set}_xstate_msr(),
>> > > to facilitate access to such kind of MSRs.
>> > > 
>> > > If MSRs supported in kvm_caps.supported_xss are passed through to guest,
>> > > the guest MSRs are swapped with host's before vCPU exits to userspace and
>> > > after it reenters kernel before next VM-entry.
>> > > 
>> > > Because the modified code is also used for the KVM_GET_MSRS device ioctl(),
>> > > explicitly check @vcpu is non-null before attempting to load guest state.
>> > > The XSAVE-managed MSRs cannot be retrieved via the device ioctl() without
>> > > loading guest FPU state (which doesn't exist).
>> > > 
>> > > Note that guest_cpuid_has() is not queried as host userspace is allowed to
>> > > access MSRs that have not been exposed to the guest, e.g. it might do
>> > > KVM_SET_MSRS prior to KVM_SET_CPUID2.
>> 
>> ...
>> 
>> > > +	bool fpu_loaded = false;
>> > >    	int i;
>> > > -	for (i = 0; i < msrs->nmsrs; ++i)
>> > > +	for (i = 0; i < msrs->nmsrs; ++i) {
>> > > +		/*
>> > > +		 * If userspace is accessing one or more XSTATE-managed MSRs,
>> > > +		 * temporarily load the guest's FPU state so that the guest's
>> > > +		 * MSR value(s) is resident in hardware, i.e. so that KVM can
>> > > +		 * get/set the MSR via RDMSR/WRMSR.
>> > > +		 */
>> > > +		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&
>> > 
>> > why not check vcpu->arch.guest_supported_xss?
>> 
>> Looks like Sean anticipated someone would ask this question.
>
>here it determines whether to call kvm_load_guest_fpu().
>
>- based on kvm_caps.supported_xss, it will always load guest fpu.
>- based on vcpu->arch.guest_supported_xss, it depends on whether userspace
>calls KVM_SET_CPUID2 and whether it enables any XSS feature.
>
>So the difference is when no XSS feature is enabled for the VM.
>
>In this case, if checking vcpu->arch.guest_supported_xss, it will skip
>kvm_load_guest_fpu(). And it will result in GET_MSR gets usrerspace's value
>and SET_MSR changes userspace's value, when MSR access is eventually allowed
>in later do_msr() callback. Is my understanding correctly?

Actually, there will be no functional issue.

Those MSR accesses are always "rejected" with KVM_MSR_RET_UNSUPPORTED by
__kvm_set/get_msr() and get fixup if they are "host_initiated" in
kvm_do_msr_access(). KVM doesn't access any hardware MSRs in the process.

Using vcpu->arch.guest_supported_xss here also works, but the correctness
isn't that obvious for this special case.

