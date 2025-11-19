Return-Path: <kvm+bounces-63684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D532C6D18F
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 08:27:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E366C3526FE
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 07:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8776F324B24;
	Wed, 19 Nov 2025 07:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nSyqFakd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95712322C89;
	Wed, 19 Nov 2025 07:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763537231; cv=fail; b=YiNcEt6HF0p4h5HtNSY6ffHVpA5uufo7QhJe2jNPBE8r2p82RZ2d1g+/MWgGPohdfSqqiC4KZFPwuJemZJ9kMO3nSvBWdXea3pPKBtcZ9sCWWYOPpFhGRfJYjQbvdovTT7C7HRZ8Sc6RIi4ufRkGUnnNDG028ehlj7DD8l275nc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763537231; c=relaxed/simple;
	bh=p9uo4g7tDhDOsO/gf5PwOLo4ty84+aju8mNv78eiS/I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=i/XTI1uyGfyIs+xx3KwAl6++8XsmQDxNMQeO9s0uBCF3e8bX/adDbyvvC91Hqc73PHaIbJu4oeD93Udzyv909GrFMQa14NUDKuKgmsi98m963JD47pkTB0v7zDP9hPcY+zBsB2KDZBb/bSfzgtLixC2CcDkpLMNdQ57zTcHFRHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nSyqFakd; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763537230; x=1795073230;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=p9uo4g7tDhDOsO/gf5PwOLo4ty84+aju8mNv78eiS/I=;
  b=nSyqFakdG72Wv1UQE1vouEkPVbEijFqq/L1zKTSg++ufCm7X9PPIF+uq
   r8kqAORxX6E9zbsFgDWD+TK07uKjLzZgf1p1xNkAW7MePcNgqgjqAV1qi
   pq715Hgu4AMdbm3WNLf/NvbJ319m9rnGTdP8kbZNSmdG4pRAfcZ4agjvE
   nQH5pcKUVDF0p0zNXb3BkWsokMQimAIo6crq+zVLcg93mYYI7G2S3d4FF
   YAYF5qw+H5LI1fcusdNSDnCDM+pTaHMUuvphw54GJmCCfPOpIKEJZ85Tt
   3BTDmyAnPc6tfZaMBBBVP06qjCYq6dCCSJJwRFX6w6Rf55J5Ay9kVxJ68
   Q==;
X-CSE-ConnectionGUID: mFKhCN5XT6Oo9QHNdH/t0g==
X-CSE-MsgGUID: nfFjNfCwQUe/tJp9UbNBNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="88224185"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="88224185"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 23:27:08 -0800
X-CSE-ConnectionGUID: cpyscY2CS465khO/2z+M4g==
X-CSE-MsgGUID: FY/LUt6RQyKHrCsQKW4JYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="190632548"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 23:27:06 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 23:27:05 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 23:27:05 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.8) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 23:27:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lAdJP53aTnRMkGON0+Bl5pFVENyTLfsb518d22vQxmFxM/PcPH6ndNX48xicPT2ZMZ3IlfMYz639mkli8fRQAYS4RC1zVaKfTaWB5MuKnW+vDoxCc9i1+1H2GzXjl6VzzcI2+zDnDtJv+kisg7QvXEcn8m77js0pS1+K8AmiqSkV6Xc9Obx17Y/0SFjlsDgDEC5uHQNQuc7wdvx1lPQe75VBFzlWWZNyu92iqMJpIRYdsLW8Yg3twmAzAQpB9HSlMDQGj3Ct2PW1SAAurmEUV/e9nzlLckHM3acVSXrrGgtcmln0CxFvWDZkpTqYe/3DDDOJDfEundLBXcHxSEncxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQ7f166yU+Eyr3ahUl5ol9TBB7LVL26lRVAGxVDPCng=;
 b=s05anJnWZDCDUPnF32VyTE+CQCe1Mzzkv/XevpzHi//i7XpDCdlrxYOp9dfdKFLc1NK8aKmeh0qUyiua4itYKzOOJBmqCp96XuXyKR0jKqUPvNTh3IIOOoxEeL3je28yuRS5oajOEcNQhSrZc/1SyDRUOTAnISuWxDrXCWUqrCh/oCeeaM5goZ8umXkS0UB19MU/GtmCRQCgbjU2ehkoCpJDV0qdBoukzhuMVOXNDX3EJXV9NBrzmt4VrGWfR5Nl78pGkFZkwvdoN9H11yead6pMateOp+rY6pQiUb7tBfDRmF9osePI2aGNw48uFfFBu4g5kF8uVgUHOMbXUXp42w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH3PPF4B53DB4B3.namprd11.prod.outlook.com (2603:10b6:518:1::d1d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 07:26:57 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 07:26:57 +0000
Date: Wed, 19 Nov 2025 15:26:44 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 15/22] KVM: x86: Mark CR4.FRED as not reserved
Message-ID: <aR1xNLrhqEWu+rmE@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-16-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-16-xin@zytor.com>
X-ClientProxiedBy: KU0P306CA0084.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:2b::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH3PPF4B53DB4B3:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a0451d7-a2c1-41f4-2a65-08de273d059e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?oKjGnZEzYT+Cs8QMj5E/LdMuXfV50tlooXKFdxy5xxkoIUnYGiOqCKQCQ4gC?=
 =?us-ascii?Q?A+mI8aIZ6UBvG+bzC16TxJRvGrq5jhZAG9p02aib9sqwxreg79/+e9TJOyhw?=
 =?us-ascii?Q?paJhxXiURsxkmafFNE1r8d4Af0bUBwQzX/VrCu+b1XCzbLduYiVri2VFSGUF?=
 =?us-ascii?Q?9/UwObr0gSEG383SnyGgcV8nyM7Hk1lkaOPpedqUcoPxg9z6TfpUa709Dnwg?=
 =?us-ascii?Q?MXJ7VfU3fy2PXSNdiAkQVAVv/LBlcnvFnH4ilA+B6WNGPiq/Kv5rCb3lCqpo?=
 =?us-ascii?Q?0eADmWqkPxqkhE4LmOWxTBJCiVuSna5caeoUaMs2l/BiL4kpvi5zJh+CkOHy?=
 =?us-ascii?Q?UBCRx3Z5F7qHOR/2RnawJgN8N0ggc1L7UAZYYfuIOAPI+QfY7bk6IOiAwTIv?=
 =?us-ascii?Q?TrVdEE7GdX7qcbLSC5VAXF/vCg0s3gU6sPxYrW5wlLjFy27dD8NDg1qVHP4/?=
 =?us-ascii?Q?F+XuusODn0mUO/nrzBLp1ENPH2Q4GGgbFTB7xplALZ8QVc6/z2/NwpU86Zbw?=
 =?us-ascii?Q?rpXhWIm+MdFPjZXH408vInlfe2YiRkG0jN4RJkwTqRdDu95cfzM0sGPH8c57?=
 =?us-ascii?Q?p3grMxNMbRZoYHnxJh3UfyVyzGSE+mU/THVctoESknWbHycrBZRwOmfHjBBb?=
 =?us-ascii?Q?1Wp7BoMXLio1QWcgUX5O89gOP5g2Qj/tEvKyIAiSZ6JVrhIsj1pZsS5JbY/P?=
 =?us-ascii?Q?ZhY95K7tYa1gj42F+1/i27V3o7WrqujyDskMUevRW0eAwY5ivF96VHFEYnrx?=
 =?us-ascii?Q?NJCsYffc3H+JOCqxNv/Ft8QfnymPGuyNlhPZpADWqn6z4QayX10z3fIK41aY?=
 =?us-ascii?Q?jo8jUrt4MEV61HNDCe7450S7eSP+zsop1fVhEePCEPI0VVv1G8AwtTiIB+c3?=
 =?us-ascii?Q?CzSC/IpTwo6ZSwY8jbWutx1DUsYRFqPZGlpfAw/6FCP8vgS9YwfciHBlmeXj?=
 =?us-ascii?Q?G2nQY0qc/1uuXSVQnAJ1uvxgag5gJRdTVa3+sF0oB9cANSDlgB4YWcYAzDO0?=
 =?us-ascii?Q?wANI4GQ4d7inlcVzjcAQ5GAG0+7XLYd/Vmai6uGbGBDMElLBBVeKi+RexPTY?=
 =?us-ascii?Q?xD598damWs1xXjgWTQ5S9CoQjyQG83UMUier9Yt/QKC6P78wFkoSHtslT9Tb?=
 =?us-ascii?Q?dq6tKOVkwM/KCftoLl7rsu59QMGU9WWkhzIb0hUmxqlWhbn7vk3FrzqKBMPC?=
 =?us-ascii?Q?jfHHtgNcX+jvBNgWPJAtt20l31xgiBFIS0t9Z65I04Qb28HxkdfSqZpdaQNH?=
 =?us-ascii?Q?atT7BRVtsZh+wSkPv/C/iKBEnXwuXySgvXAAV25xYJQiI3zlYVlxI8E2Hu0b?=
 =?us-ascii?Q?9yjCqOluUwTfiglpOf5O6YBcSRFF/RnooLuWaafrLPnbFC9kxqAtZAG3Xh8A?=
 =?us-ascii?Q?WQf0cSc1MU5RWQ9CT2b+NCvNwCKQjuKwS3uLBaYtJZD5C2XgBQ5iIYDAf6/q?=
 =?us-ascii?Q?4a2xPaRScsMxNyvFkg7F2BDQFH0+lU3o?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u/kTUP7QodAfJHdmAlmutL37l+frZqS7nZk/OX2lADjnkmo2aDDjt9ChsEfj?=
 =?us-ascii?Q?mXQNrqlfYUpDTqbB772SDitif1LQD8Y6Ps7yxmSHnNDeR2KRbiXoXsB6nAGD?=
 =?us-ascii?Q?uJTou9HcBO/y2tIe2mKK7PhxPtRxxDjgjm7uKlQQ3IsmNGdHF67+PZ8n+6Am?=
 =?us-ascii?Q?aULs/xNAIZxsR5oC+NYXY2fw4JSDqosXU5hgAX9rZXNQOlAJ705a8MN9UUAd?=
 =?us-ascii?Q?rNKSu91FABixaS/3kM7Kvk5LHWLiSw+OFwFaGNwdOFCYqdV1SNdwUbe+GmCZ?=
 =?us-ascii?Q?6P8NRmAgUCai335m1ZR5ljxQfMfTvxGQj9ZtqkMRQX+JLXHDu0LMFbIAJJki?=
 =?us-ascii?Q?dt8kovQZ+Tt4Gs3LYAXrG1dybr3697aeBef3Tl/vs7SJTUgayGW02T4VSjmI?=
 =?us-ascii?Q?SH6nvn96HtnQTNt3QwbAmiE59ATJv2XaQmj0uu69giOokqmudgTHn/96Nu7G?=
 =?us-ascii?Q?8k9XRUV44sXxV6NiNPxXllZlNZcJDTnwhnq4uxjOCpU4EDg4MSSWbS5MGUKR?=
 =?us-ascii?Q?3FiHYD/HHWgazJAfDCeKntOTm23OXI3lLoIN2tCcWvliEXW8nwP28qUJBluY?=
 =?us-ascii?Q?sjM9JGo++VLRwA2zydZs4foi0+D8Fwf8F9MjpI/p0FUjEpqm+LNoTHjFR4zg?=
 =?us-ascii?Q?TUyqWp4W+1YP+Y1EZslHaJ50thZ/mE3sZLZcoAOThT0al28JVreXgOit+Ipd?=
 =?us-ascii?Q?K4m6N+5y/9fCZt5eidN+KPro3bbgoGvYkIyvMasJcAOSE+TVhyGn3FaJXi0E?=
 =?us-ascii?Q?V80lcWROJWcpmzPDPf0FIMuBCWMVuxi6vD653no7U5A+uJxqXVj+X35jRz+0?=
 =?us-ascii?Q?iZTo1scwcaOPo850a0ekCDmcHWcfAjBFbQsDuLXCgpX7BoPdkZV+lnB8+CB2?=
 =?us-ascii?Q?DmkqBtucb5cFl6UXSpr+XFwdcoXkF0MLIZZ+nsIQrJtJesc4bLPPH8Ln/Jcm?=
 =?us-ascii?Q?LTkJfUieM/T1tnRJOL+ynKcpXSJsMJcU0j2tq5LZLv23oRLFib8edMR5Z4u0?=
 =?us-ascii?Q?BILEm2QlSzzmQbmlb7qLNh1OijskN+dS+muZ1I+k0zpSxjDyKn9Bz3Z1wF3m?=
 =?us-ascii?Q?nuEaY5UnxaM/fe+rUPFE8QzP6lytqQViIhGPBxdGQ/YaTIvbE84Qk88KnGRM?=
 =?us-ascii?Q?tJGajdxp3ex75FpFaYoFt/ZSTnu86Z5T3GbLbxBpVtEbJAzk5YGIJtmr3bsp?=
 =?us-ascii?Q?4dWnHVYJCBg69w3slRWS0DHkgy31W/ikA5uUEp9/1tOvu8iMYFrU4pSFgjQf?=
 =?us-ascii?Q?mYkqY3hX5oWiw+lwAGrJ1W79ppjbvFW5/luDA29Rq7JMom/3CoteTXGab6JT?=
 =?us-ascii?Q?ED9L05WbzhzvuBLZdjnVBilZe+HulHtwLK0tgG+8H86xj02Fm/7P7mgF1pQr?=
 =?us-ascii?Q?VZhFOivI1dzzpuYcDVxV5JYbMMyeNucDV9TF05lpOAOb+LawyMxGpbX3oiu6?=
 =?us-ascii?Q?G1qDjup21u1WHETOftfDoqXCd5zD907pOnGibU2T3QMnqQerQMA+0r3B6l+H?=
 =?us-ascii?Q?ZG17/oLeWtx0uJm8XxZ7mjRw2rCVMDArV2bIJ/CRUbobvorOy85u6JVt6D+1?=
 =?us-ascii?Q?6gu2EO7qW6NygSi2yZlTRnbwzV579kuWMMDE8W0n?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a0451d7-a2c1-41f4-2a65-08de273d059e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 07:26:57.5236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w1eQPYxKwtsiJMeAN6pniumsXYArKIEw28qFrxCUamYH3O5DBvrstHbkXxNnT1w36cWd0ro4xGeYP+5LdK6G1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF4B53DB4B3
X-OriginatorOrg: intel.com

On Sun, Oct 26, 2025 at 01:19:03PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>The CR4.FRED bit, i.e., CR4[32], is no longer a reserved bit when
>guest cpu cap has FRED, i.e.,
>  1) All of FRED KVM support is in place.
>  2) Guest enumerates FRED.
>
>Otherwise it is still a reserved bit.
>
>Signed-off-by: Xin Li <xin3.li@intel.com>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Tested-by: Shan Kang <shan.kang@intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>

I am not sure about two things regarding CR4.FRED and emulator code:

1. Should kvm_set_cr4() reject setting CR4.FRED when the vCPU isn't in long
   mode? The concern is that emulator code may call kvm_set_cr4(). This could
   cause VM-entry failure if CR4.FRED is set in other modes.

2. mk_cr_64() drops the high 32 bits of the new CR4 value. So, CR4.FRED is always
   dropped. This may need an update.


This patch itself looks good, so:

Reviewed-by: Chao Gao <chao.gao@intel.com>

>---
>
>Change in v5:
>* Add TB from Xuelian Guo.
>
>Change in v4:
>* Rebase on top of "guest_cpu_cap".
>
>Change in v3:
>* Don't allow CR4.FRED=1 before all of FRED KVM support is in place
>  (Sean Christopherson).
>---
> arch/x86/include/asm/kvm_host.h | 2 +-
> arch/x86/kvm/x86.h              | 2 ++
> 2 files changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index 5fff22d837aa..558f260a1afd 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -142,7 +142,7 @@
> 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
> 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
> 			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
>-			  | X86_CR4_LAM_SUP | X86_CR4_CET))
>+			  | X86_CR4_LAM_SUP | X86_CR4_CET | X86_CR4_FRED))
> 
> #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
> 
>diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>index 4f5d12d7136e..e9c6f304b02e 100644
>--- a/arch/x86/kvm/x86.h
>+++ b/arch/x86/kvm/x86.h
>@@ -687,6 +687,8 @@ static inline bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> 	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
> 	    !__cpu_has(__c, X86_FEATURE_IBT))           \
> 		__reserved_bits |= X86_CR4_CET;         \
>+	if (!__cpu_has(__c, X86_FEATURE_FRED))          \
>+		__reserved_bits |= X86_CR4_FRED;        \
> 	__reserved_bits;                                \
> })
> 
>-- 
>2.51.0
>

