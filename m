Return-Path: <kvm+bounces-45144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6253AAA62B3
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B994B4644F5
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B15E22155B;
	Thu,  1 May 2025 18:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wm9rCVNu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EAA1F03C9;
	Thu,  1 May 2025 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746123490; cv=fail; b=SKf4Dc0Shn8ZVMp+CWACJvW7KSVVafYVepasVZB6tBadRmt5bSsuIDx3U9epn5BbWOZpwlFIi+Qh1xTeDznu+lE7topHjvVeVeIL6ujpdYTjqUa9QkJCQ8GsXcQTb7Dwq2QzWIp6BoILsYYSGlNiXZcGdFPBSBb29H5x4zlgJv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746123490; c=relaxed/simple;
	bh=1Tt6JinP0VBO8+NAxMoIYuBMrKpqr16gO6JTe9tJjpo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GqLYQTgVtrY/ErjlMcq1tRNEKU2IIiiv7Pe0/Sq2zsTRhB2H31ak8XsvYn+JNpy8bvhEqS38zdiibRVruNBItoPM2LC0xayKSwTeMmqeSy2DiGg5bnDlFWOIqgIkBqKMH1PXuo20teCh19LgJ5AO3diHUwhupmDTnILymucIerI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wm9rCVNu; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746123489; x=1777659489;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1Tt6JinP0VBO8+NAxMoIYuBMrKpqr16gO6JTe9tJjpo=;
  b=Wm9rCVNuI0Twa8LDC7OEGW6LClrYrPIeKoL1hENMpzUCyVjaoxqqsO5P
   DD4hCzfg1YqPQmtbSgPOUEYaFWf2CZEHeie+l2zzFZpSY7aQ7HccGv6nP
   8TcwLodQP4NMBdjYLjKUK8JfvW+lVjRVuuwEKBTOB16e2YSh2zsU7zMTX
   w7mDn7Ur47/LKTlYHFI+GUpHQuWBnSWUBs9FGxcnuzDANDY9/8N9WFV4H
   JNbIyYfoSk211D6ra51EEmWAMbhJC7KR/wqCLFBThfHdZ9PIm/Cy3J4xA
   n8u9zv2uUEDtSN++7MkuV6ABYjBt9l8tIEFiJtjYv8Ws8qeQoxRXIT4Fv
   w==;
X-CSE-ConnectionGUID: A6Dzc3c4TjqTJw3hlV2RDw==
X-CSE-MsgGUID: dIeWP8WHRvmBOi75KmP7yg==
X-IronPort-AV: E=McAfee;i="6700,10204,11420"; a="35424064"
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="35424064"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 11:18:08 -0700
X-CSE-ConnectionGUID: hNEUdg3TRAWENfDkWRVGKw==
X-CSE-MsgGUID: QYEroOrXQTmNajlwjNckEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="165373079"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 11:18:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 1 May 2025 11:18:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 1 May 2025 11:18:06 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 1 May 2025 11:18:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jLeGEt/Fn99xHp81y1TW44fQTqmtsLkH/40T6S0Z+JHc+s9VjthzDpfBnLXr3VcCbpBvKEotCtalFqg00Q0D+jjLjtVTsurtnQX9syA304Kf7AdWFKXsF8WzLvlq4r1g40+ksSakr974mtRTsd2e19OWy6hh82nUlsWWD6JyMUloC07UIdd8QEjStIFeP4AFE4tjXqKldzUUzoPcz9jUa/fZ/pmBid+UmrBprusghYeaaKTJsB/CezmVAtoFWOUJidIrupAW6oFd7Zjhkv2qULDga/gaFeWbbjUAaiSDO2R2s6HAxBhtEU+dHI5TEHlDg6jZSqAuer1aqHuxH83ibA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cp2aDt2NT1zZbDvSQblJbfl3rxg7VE1chdPOZSN2HXw=;
 b=DZWGoRmlwVhizSHyirpt1TF5WjoSaE8yeaCURRi9JEOSazoffnc5yEmwKC95cbMCN4ShLzZHo/vo81nGWNeIt/q/KSzakmnIpZH8A38C0vt2AnKhHMNDYO5YCMNjLM9G7p7fLNlBGWA/ckunFfcEFuVSyFYYPaQfYwU76z69AnUHiqs4v25+KPfRU9//p0ynvbFomFJMxETq1Zhyg+Vssz28WRr+pDXDMFReXdief5R76G/i0R8Y89/Ib9KxJpDttgs4VQvlVdl4BG2gYL5cX/Hiidy7YkvQqz2v7hy9RV9nlrV/TuFlW+Xe+UAmUV+epMdqJqvX/4SRjgtR68pFaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SJ0PR11MB5894.namprd11.prod.outlook.com (2603:10b6:a03:42a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.21; Thu, 1 May
 2025 18:17:29 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.8699.012; Thu, 1 May 2025
 18:17:29 +0000
Date: Thu, 1 May 2025 13:18:00 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Fuad Tabba <tabba@google.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>
CC: <pbonzini@redhat.com>, <chenhuacai@kernel.org>, <mpe@ellerman.id.au>,
	<anup@brainfault.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <seanjc@google.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <willy@infradead.org>, <akpm@linux-foundation.org>,
	<xiaoyao.li@intel.com>, <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
	<jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <mic@digikod.net>, <vbabka@suse.cz>,
	<vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <david@redhat.com>, <michael.roth@amd.com>,
	<wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
	<isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
	<suzuki.poulose@arm.com>, <steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <roypat@amazon.co.uk>,
	<shuah@kernel.org>, <hch@infradead.org>, <jgg@nvidia.com>,
	<rientjes@google.com>, <jhubbard@nvidia.com>, <fvdl@google.com>,
	<hughd@google.com>, <jthoughton@google.com>, <peterx@redhat.com>,
	<pankaj.gupta@amd.com>, <tabba@google.com>
Subject: Re: [PATCH v8 03/13] KVM: Rename kvm_arch_has_private_mem() to
 kvm_arch_supports_gmem()
Message-ID: <6813bad81f5b0_2614f129448@iweiny-mobl.notmuch>
References: <20250430165655.605595-1-tabba@google.com>
 <20250430165655.605595-4-tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250430165655.605595-4-tabba@google.com>
X-ClientProxiedBy: MW4PR04CA0274.namprd04.prod.outlook.com
 (2603:10b6:303:89::9) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SJ0PR11MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: d8cd6a7e-78f4-4a97-ab33-08dd88dc6f23
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?iGjEoce6Xn0dTPMSuAhJK57cXsmrOi0bld1GP0Bakk99TgwS+pz3Z8VjMzux?=
 =?us-ascii?Q?3ffcLlUJaePHLkn7iqcm6XzQSlg+6MHplGR1I+z/Nth5osW4Xk1GOWGlmwnw?=
 =?us-ascii?Q?Bis51Kx8yN9mZuMBO1ww1IrdJ61vTvSU+9nKYvOF8MJF26+kN8/17CDpeaoH?=
 =?us-ascii?Q?mFAWW40gnqYXOoIRfxUJhLs+x/nzyQV/RkRLVy7UGdQ5XDJdr9sUFkboTL2m?=
 =?us-ascii?Q?DT9BWL76grbBifItMPAIiGYgJwHM/jUk3a3/iVQdDb7GBYHaCmYzSHwSh/gY?=
 =?us-ascii?Q?1gK9+2POEU21/OEDnWZgPvtjPIB/qyLYpgSzIBt9Nj/TcVhvCpMfB5soB8Kj?=
 =?us-ascii?Q?Z7JSoLsOhlbiPxAooRkeMQ0cTcnMmnLld9BMzHsaJF5WQ1y6hDJkebcJPCqA?=
 =?us-ascii?Q?nZ6KRXUZMNotOJ7yCGmZcfc/D75qnrftts1LqpBBnEQfs6KU6b+8aQ7WtT3M?=
 =?us-ascii?Q?3Eaegsn7vIi8fRK1fuqoqM3YNDXsgMN3KFmRr9CH4DLnWkRA2GbDSoKcS2Gg?=
 =?us-ascii?Q?pFe3cDsD9Nyu8etz5XBPFRMh8IV++6Py6C6Q6V52LDyORokvgVfCB3yI8CBw?=
 =?us-ascii?Q?h0OxHPo9iJwKwU2X2t/pAOx9EroMA9vXeux/fb5HdTLGM0XoINFEAw6I/4U8?=
 =?us-ascii?Q?yUfRN9yjTvxEicdMWryhq2bgTIsMEehqf/2Elv/bSAWUpobZVNuCpwsb0bTH?=
 =?us-ascii?Q?cvfKQl6yfVqQYvvzTu/qqEJBDkB+HS/8JODHcmVjkIssUC7lsu/k3uPZmsJD?=
 =?us-ascii?Q?A3kelLx5+BjknqhWTMKLlFprHqUYNfzI2CUyf5ZD9ORDImWR7U80mM9DAwxp?=
 =?us-ascii?Q?8TjAoKhSmCcMkEPJ7JNL92NnJXK3/haN7jhjIaAMk3Eqy3tK9APGVhaAc0Zm?=
 =?us-ascii?Q?cWJM2qB4KwDAxiAvNOsueZc59XGvZreyYwo4hau6G27sUs7yHXNDKhOzAZIz?=
 =?us-ascii?Q?YCj7/9mDgIPWTrg+ojfNbs4IrWqfjUlL5+Vb12XUkfnG3/QIA/p0/Rf2CuQO?=
 =?us-ascii?Q?uRVwBlPdTBn2s29kBoBPNntMZTJ3xB6CfIAANhAAbmQIRN3wlXBCGVmgmOZm?=
 =?us-ascii?Q?nm14fWyZOnY5PZPd23qdfnuPnLmLraraEPhljL1CictbaR31Ot3zwbMgVMxK?=
 =?us-ascii?Q?dEN4agVdCEv4cdfWwxU8hVAdFyzegC0U+Uyc60MpaBqoZfI1gknw38rXm8OG?=
 =?us-ascii?Q?MVAo6lGXj5Q+EdKjVRjyVq0tspM6n09wct/QqkS3VwTneWlcWi7gCl/uxCXN?=
 =?us-ascii?Q?ZNy7sP6mgLD2qGcFrd+l4QjU7ttvauyxdRwEM11d+jouupyVH6OE8YgAM79O?=
 =?us-ascii?Q?R913Zdytjap1T3uLdrbOSl2AtfvtsYyYSnJcIHuvPwcUzAfdDe6Qcqrix12f?=
 =?us-ascii?Q?RpJkTmBRDF1qCI1Rxl+T7yQF6ZHgzKVvIuBHNxT+bi5AWWWb+Q2hpTNs/M9v?=
 =?us-ascii?Q?3m2NwbiG+eI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BG1k+7BIIIlzL+xUi9r3sf7QnwcmptDOwhUdyZZn6TT4vvMAQhJkq7ll0MHP?=
 =?us-ascii?Q?xVM/4KdWJ6ra7eWNwQA1MxoUGh8xh0F1+t4mgJh6+ZyBozH1+kIKq7dfpuyo?=
 =?us-ascii?Q?7uXQa+Xau3ilsiiKhpCK0UZ7ZsjGBfU7C4OQ4gbKym/jUh4A/8MJImSlkWqB?=
 =?us-ascii?Q?Olk+ETTMSQsgrwNC7Sj7ZqWkrVoHDW8ze+h1sNHcdArYREh0zDs6HfmBG4Mf?=
 =?us-ascii?Q?OEe8rMOsUMs5aDjAecyJLO0rG58nhbgtnUDRlhpsBTrQ70P19nfyXv7xdKyb?=
 =?us-ascii?Q?zSoj4kvsQYEO4LVHXwoxLRPSyKeC7HSD1SUuLuu1mefuMmxxJBDITOcjDm3x?=
 =?us-ascii?Q?wx8oA1IAaM7n/xqkgoSfSImzmkvlx5cj+ZQHopXOJqrt4edTl1jWr0Hx+2D3?=
 =?us-ascii?Q?S7I9AF4wqZ4FKv13gJLdOGc2EvdGqQ/sDUluksOO7HbPta/b7u7LzuxUzJnz?=
 =?us-ascii?Q?poVT6e8iNlENKb5OURq+yRV6FoS8zz9Qlr5ATNS5yr935TuD5loIjh9k0FU1?=
 =?us-ascii?Q?FS2c5nAxGE8ShYsRFVbLYFiioMjhfQQfTlezrkb33f2Ti1s+Yr4T0zLvQMdu?=
 =?us-ascii?Q?pJELQl/ewsCVLVu1Zd/dHeXHChz+pHIa6LJrw2LSj0lJvHUW2KHWqN4z3sYQ?=
 =?us-ascii?Q?tXGQt5MWLXTtBeZWH8t95Iax/jqDdbQ5KLmkAbts+sX2XCCYCaLrULvDWI3E?=
 =?us-ascii?Q?BHuTNkwo3Ip/L8zzP2BcCkMERTu84cYjwKxymJ7koJGWNxor0qjT207t70nH?=
 =?us-ascii?Q?LJYwVjRxgohQiuWgqcUOi/TNm60MPR5BURqssH+/XiLTtonBwynDryKnVsMX?=
 =?us-ascii?Q?6Cs40dckRjLXUM51dYzrum3ALQ29eAEnD5YGkrCeMkoELj3mASJi2XbWGbdP?=
 =?us-ascii?Q?/F0EvBFmk6B26sXPgRWj/2u+WRCYRi05Il5fQ3eZYlDVZQMpFO8Zy9Uc77LV?=
 =?us-ascii?Q?RNa8/9Z+RLF7aU6vFgZM2FkXNY4daJYXXxsEr9cSTs7PC/OhRNC3E6lgAnoL?=
 =?us-ascii?Q?TkiQlJFrgFE8EENIPBXBQX5TSToR8ein8Z8xQjyrY+X1SqNlHP89iN2nuZ8j?=
 =?us-ascii?Q?WKDSs2BiNRO1nDj5nKw90bd1IYjfng5X+vN5XPAwA1Fu/XMZPZ/tuP7MTluV?=
 =?us-ascii?Q?D8g/ZmTKHgwPXnemO1C1NEBgEQkFBGlqy/WeXonh37FGM0kAYhOCpwgDLOzZ?=
 =?us-ascii?Q?EhcA4nBkvIJrYwn90trjRsPqoyQiTRyuwgQUdjL37232jY7JWemfga0TsKGH?=
 =?us-ascii?Q?U1N+RT9ma/0jcV8dJf0KOsitATDbRr5XU1EhFaL+ispiHDDCKb2FRmkEQpHG?=
 =?us-ascii?Q?bSPB7GuIeZpChVWmZnlHb42c5aoiTPyD0jjrpkU79ZRgpvd8yWnMQz/m551W?=
 =?us-ascii?Q?CzDlWKDcVBMEpbgmzKjHi3oKAgqa4ITkVwSRTfENIjnZREmLa3RNuMjrtSa/?=
 =?us-ascii?Q?yftzKpJvlPsliR3BlJZ6kKRptQpzqfwVGmXa06jR+jyVbX3JPXRYH6Flunu2?=
 =?us-ascii?Q?wL+Ft+myzzzIsRKp4kOlTzGYSXPww7ePD+mHEQG2irDcljb1SxgfjYyeUvv/?=
 =?us-ascii?Q?fX0R3zVCJ4wwbJFbidO1i0l5SWz247WJhgcMTjXd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d8cd6a7e-78f4-4a97-ab33-08dd88dc6f23
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 18:17:29.6769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bkolfaGCoBSeFctLmcCh9oaMSanxZvM2lNr3yrPgbV0hzeebnOmLf5m7HwjDxaR413MSSfKiQlrVB8kLoWUEyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5894
X-OriginatorOrg: intel.com

Fuad Tabba wrote:
> The function kvm_arch_has_private_mem() is used to indicate whether
> guest_memfd is supported by the architecture, which until now implies
> that its private. To decouple guest_memfd support from whether the
> memory is private, rename this function to kvm_arch_supports_gmem().
> 
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]

