Return-Path: <kvm+bounces-42582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB81CA7A3AB
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 15:27:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56085189592A
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 13:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A17B24E4B4;
	Thu,  3 Apr 2025 13:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XaCZU2ol"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1812D1494C9;
	Thu,  3 Apr 2025 13:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743686790; cv=fail; b=YBaQ1FMiKKlU/iJG8WLc5Ws5YtBopILOrapF36KR9FBP17hAQwW46O2JytiMbzsb1fRCZ0QXfiRwOLlyl3CnQQpYb1S/JmhQFmsLmYvNbajfzRt/HL1EMCRxRu3xPkjS4WpMBAyn/H8CSna1++qm2iDSM71DB4+htgQJmhCHQGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743686790; c=relaxed/simple;
	bh=oOBPooVwjUKd72Uc0SNcmd7VhR2FdGYgFjOG28I0V/I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=stRvTU5exSDJopqR6vNOtb1zMlY8qMJQ/k5cGizpNIsNkFfGtkd7RyYEd4/36zIyvZI6s4rVyzleJLU1hMNjPJVIFQD/OrLkT5EZn8j/xeouVInnzTmcArvJCpUBapZRNRV7D/hO5O4ILcsBxWYhpPzvl0EZhWqlvaGbSi4Hoc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XaCZU2ol; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743686788; x=1775222788;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oOBPooVwjUKd72Uc0SNcmd7VhR2FdGYgFjOG28I0V/I=;
  b=XaCZU2ol4K2shW+9Q1lLZ2hgSlV3WWs974jGQfxodrdHBGSbyGz1nwA9
   KbsVBQdlBEX/PxJPul79SvRWkKRsPGBKoa9oLyzzbD90Am+lsatcPuWl9
   40Ha5CCqGKiwDWBW5gg9aI+uTMt46ZtTWXjZkVqNt/tAa1omqt1jm1VtT
   MrQIExFNVvka50fJZm1JLQWvr3DO6H9ycAwxsvruEN5JvgJHMTWthFE3U
   FruPML4yEcl5j2bFm4G4phCrejcsnvY/q9RRvn0yuT/JXoPkhlJKHGNCQ
   6O0JmoqD6yYqj6TmCZTvDfV8fXnyY485vrDny5+poAY2igmqtFOf8egV1
   Q==;
X-CSE-ConnectionGUID: 5p+hbWWTR2K8Yq8rngWmFA==
X-CSE-MsgGUID: qAIKGw8sQQGu9jAQU7PHKg==
X-IronPort-AV: E=McAfee;i="6700,10204,11393"; a="45234164"
X-IronPort-AV: E=Sophos;i="6.15,184,1739865600"; 
   d="scan'208";a="45234164"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2025 06:26:28 -0700
X-CSE-ConnectionGUID: 18sgd8T+R0mAnaOUB9c2JA==
X-CSE-MsgGUID: 9QN2YDM6ScuAQJket352lQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,184,1739865600"; 
   d="scan'208";a="127519182"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Apr 2025 06:26:27 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 3 Apr 2025 06:26:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 3 Apr 2025 06:26:26 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 3 Apr 2025 06:26:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FU2399Rx0+5jhNI65dZ3okXIio4hitHrR0BvfH/3GIWgU2d2b76zKIltC1jXJQsuvoJKEwALrEzyQAH3kCswYpsL4wAPHwvHtlVo1QEJjjO7oLtr+oZ11pD14BhUtOgn58hmgO3MqJR8QI2bmZHvTbaobDMFL2i3uJuzjP/adxZV37x1LieBCsnLbkv6DUUe/oe98g1vuJamchvIdgrn9KXl1I8Ty7exICRPfJZWMyNT+qw29XShxZmAN0S3p6kh6CwHq0x+vIz6RxgelChndcfogW1Q0ndXvuonarfFcZgTCKAcGWEKRaDo47vZhfcaG2rZtttvhmPhlehDgnXyCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A2K/VHX8rf6gzZEuZG+gEH5fwtcFZh62TD2HGOn2QFE=;
 b=gGWZCdCaupeXTD+1L/A7Vq0S73qUF5+q+k00e8wo/5g5p42lQNrp9YMlX8vV6Be8znHmPRKDR6zXYXuR3twKg5/fE2jAjFXHdOAHzM451T2As1E1+VhmEHHx1B+FYe+/bsCv+/ujkyTl+USI4iaevq/3k11fNymW7SraJx8+hnzkLrEVGKmP157S2RCR/wbPXVJqmcZKFp5yRhuC4sIadB8FMwj1lH/sPUTBx1PK97iZVlhHoaNbqsjYZPwlKElY+F859a+22xYOxMloraMfCCiWv3kyukDMx5U7fzttYC0ZQzoeNSLrd/O/JgZBxgbVlsoH3XTlITK7qzSbblKX+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ5PPF82E3BEA84.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::83b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.45; Thu, 3 Apr
 2025 13:26:22 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8534.048; Thu, 3 Apr 2025
 13:26:22 +0000
Date: Thu, 3 Apr 2025 21:26:08 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: "Chang S. Bae" <chang.seok.bae@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <tglx@linutronix.de>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <weijiang.yang@intel.com>,
	<john.allen@amd.com>, <bp@alien8.de>, <xin3.li@intel.com>, Maxim Levitsky
	<mlevitsk@redhat.com>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Mitchell
 Levy" <levymitchell0@gmail.com>, Samuel Holland <samuel.holland@sifive.com>,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>, Vignesh Balasubramanian
	<vigbalas@amd.com>
Subject: Re: [PATCH v4 3/8] x86/fpu/xstate: Add CET supervisor xfeature
 support
Message-ID: <Z+6McMRYjHM8aUXI@intel.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
 <20250318153316.1970147-4-chao.gao@intel.com>
 <d472f88d-96b3-4a57-a34f-2af6da0e2cc6@intel.com>
 <a287cfc1-da35-4cd4-9278-4920bb579b5c@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a287cfc1-da35-4cd4-9278-4920bb579b5c@intel.com>
X-ClientProxiedBy: SG3P274CA0014.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::26)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ5PPF82E3BEA84:EE_
X-MS-Office365-Filtering-Correlation-Id: 732b7274-f189-4f45-8c7e-08dd72b3200d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dPDwxPS+MpEzwIVnXXmzElKRHZUZENEpNp0nXMBihXWeJH5+m7z3SF/swvmh?=
 =?us-ascii?Q?ZEzlV8fCJM14w3Mb86jl3ImG/7hO6Tf1slDRaFZE+Poa1wJKqo9sYtiqZYKR?=
 =?us-ascii?Q?pMwML8LNDTeLMaQUCqpY4KzD7juacRzfbJ7rciaSB59Pwyjy8YfZIb/s9Slw?=
 =?us-ascii?Q?CP8ApncvLChJly3kHDhPKsCszOJy/wdB/lhX+lPotP+uqaqEkzzGpsBxhI/p?=
 =?us-ascii?Q?emFreV5X3fAzDeK/k3K1YePxcjaGQh5Bhc9Mn7aWck80k67x3gKo2LOTbi4S?=
 =?us-ascii?Q?7ZK8tReTBeQQkHYKscKBDXmZ8kD3nez6mcBZS+BQvB4cW7xdl55ejle1eNwO?=
 =?us-ascii?Q?kqrp/eZgb5/2h3x7VK7dNf3DYv8DO2Zr80+75vh+j/2kzxUrGZFR+POPSbDd?=
 =?us-ascii?Q?8Zbx0+nI/mQdqeHRMBoy3zlBuzbQL2ikBaaQFwsgUno8yGeeiKcsOPq04J1o?=
 =?us-ascii?Q?OMklT6rP3Cd2HVdTPJtKBHQ8iU01YecW6zK17w8d2MUPclb3djLurYKcSFzT?=
 =?us-ascii?Q?mIf/otOFpaLrYPCJreQoRxRsnXtnvnitDdyppveEl3SAadCut46+7IryQvEa?=
 =?us-ascii?Q?lkNtu+uJJUlp3XUObv1pJ00ytqzZnctEnlbDJxkhvvQkWPR9FyRHo9ks+XPT?=
 =?us-ascii?Q?dkcdBx/LdJbxdjIrPfBhqcN3RN6e1Ag1bsB/GDesPKDVh6R2rDDdyrUVTv5B?=
 =?us-ascii?Q?kkCredaWOScSl+beyU0zXWfzPygu7EbJbshFhmIhcZsPW1SjeMaX9SGvIt/4?=
 =?us-ascii?Q?UItHuONlm80dLchH9jtrcWQrNI5Qx8X7uBCHnD2UIl2BJELhgW7sE8TU6iON?=
 =?us-ascii?Q?o6sq/hlR5AZHoQwJ/HRm0v9n/XtTARHpUKcYInwwLdMpz3dNUjmvyA6sAkdq?=
 =?us-ascii?Q?i2gkTLvGbbUxucuXM5G3BEpAtoZqZR124aYpUL9qppv7d6oDHVQhKXpw1ls3?=
 =?us-ascii?Q?+TD9Ad2K6Yew5oTYoxCko74olKaR2aWHAtaRa0aKZlOomRBGZVcd8TkbQxBl?=
 =?us-ascii?Q?t8bYe24y6hxZUviJIDpuzgvPTysLpAqWlKYuJP2oveBb7Z0HssGDaGBMQmS3?=
 =?us-ascii?Q?A34h6DdHQKxOytd/DrSyCArpyZ4/7STywTvMSEUYqd5Fz8ZgvGe99M5T7f3J?=
 =?us-ascii?Q?AF+Y6xQPfjZ5Sob2RNUc/Mli1N4bNNu0TVKOCPap1A30yxIzBGqrFnqUPaDu?=
 =?us-ascii?Q?5iNPIFbX9xP2VCFrCoBaENd84JYNgxWyzy2OOZDjPQEalwvZgb4XrnVLgR9/?=
 =?us-ascii?Q?w/XbKgUsjXTZifMn/wcwyjflBpHHDi6O7OVhwSseEKrxZnFyAc4UYLVdDRR5?=
 =?us-ascii?Q?7i9NU0+/wDpP0HdvhaBP0CvFwIMNf9tNqnMr29qK2F+DDAH1URoxFUruq2vc?=
 =?us-ascii?Q?FP5kngzADab3yCLK96hprTEdauDc?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IAu6bIhq626ISTdJcT7fM3cB8ZOoOQJWM5yC+OnkY3yX8EAA/dxf//hhuQ5U?=
 =?us-ascii?Q?CE5NKHSHXPs1K8JMaW3Nfk/URSPpxAPhsSiVSJq4W9HlCk1sue/tsvuEPbrR?=
 =?us-ascii?Q?ggS8eLOvLekF5wWrm7PdQUTPvHkT/38s608PWk2t27B1AZcCzz1s9egJw4F3?=
 =?us-ascii?Q?yVyp3FPG6dE/5fyXkfytxWDewtqumnVj6UdqCtBHGBqR85cvJRADEbnaAfsi?=
 =?us-ascii?Q?WxXE0SaDXNdbEXoK8qiTUGOq0tFnPFUrtE1LjKZlL4pPhfJEDZinsqYtXyTE?=
 =?us-ascii?Q?1OBUbIl8j69JOk0G+aq/zPPUEtBK83w9+M/5N99xSQPoraaCkp1W7wPPTTEW?=
 =?us-ascii?Q?kmgDPXH3x6kR0NmudbA8/aL376eEVP9pB9Y/q+WyTxq9QHlrtFGIr6SsS74p?=
 =?us-ascii?Q?MuHDwKqZiVR8fi/T3U70M1oCNIhEaAibQxiCWh3y1LC53dunP+wBV8t1bH8u?=
 =?us-ascii?Q?vh0XvY7iUZ7pvjKqSEkVPXNWB/GgKCN3fInJzMTqL9nw38SuSWaASNGdXcgr?=
 =?us-ascii?Q?ngDxD8oxEt57dKYAipXY6oloQw5NojGFvbGw+av0koL/RUaifes7kBoPVABo?=
 =?us-ascii?Q?CtAPRP6wD/r5G7LtlRwwEEpWiu6JMpZbUveiU8ckRh/+Uu8o9d/ifcRLAANu?=
 =?us-ascii?Q?xE0wcXgBzQH9A8ChyHCtegkNzvwFZgKhZ11uBbuUAwfHr8jas4HyQb+rBPwz?=
 =?us-ascii?Q?O44nRxPPJuP6Lpt504QXufQ4zvMoa8q6P6gNFmhcA3WZMZEDl+EHU+H/yF4k?=
 =?us-ascii?Q?kg4zvKe1zoCy8aBBZ7abeprwVLJnRJ+3Hey8CyL2nwDRtORv63f9lXiuUS7E?=
 =?us-ascii?Q?fJRb6ypORM62MrHb0+mUyAs7l2ljCxpBSl3OTStZWjkRNgmdjfbu2qmcLPYm?=
 =?us-ascii?Q?v45umQcUJiBi5SmCt10x9BPAfOwxZ3CJl/ns1XN0pAyHBTmtFxtuU6n4fc3P?=
 =?us-ascii?Q?yhfE+UyGKcePUfPNH7OyQf2iV6Y1IFgrsWa0FvecF+R5MqKBkvskGUk0EsoF?=
 =?us-ascii?Q?b6K7Xe9aSlSguajIbu40xr7Hpm81zADBbMgHZAcT69Xupv7vIp3fyu2y2Fzl?=
 =?us-ascii?Q?8v/ho9Ccsa3/vbk9lg006rwMha3twW/W/NWYBRUh9ff0uqUCvsKjQ3eRLR9s?=
 =?us-ascii?Q?7YGZdtRUFid/t9aDNvjcgtwwrb+JnwoHOJFG5eNyqTEc7hxmN+K4rs7Nko4X?=
 =?us-ascii?Q?KE2gbVkRJfUYV+hYEgyPziarHUHmLr7HYfNI/chY+ZowJ0uXuGkhCiBQMtZY?=
 =?us-ascii?Q?3i1rGA9trwSkfr3L/g1sB0bDKL0Gw3p+ku7gPLAPpmbssrPAy+fJfKtPOJsE?=
 =?us-ascii?Q?mr43TBHFitb1fHrotEDQqStcRC/WGSDKNG3sriEm7xEpOlLqzsEzaDva9PmJ?=
 =?us-ascii?Q?2iOFQHCsplZ+KCSM1SsXgYkpqRB0FXcCRre96QpiwsHVCvMZbXCzQ4MvLkn2?=
 =?us-ascii?Q?Fk3xiAKyhYe3NIzqtIF9t96QkGX98m4FXs3uVuRWCOGpFRvBlRG6pj38ZVKw?=
 =?us-ascii?Q?04I4QnYeAXcnIarTOE7K2vA2MZJ1fI2yYZH9jlzu70LQowAg+mE2SqgjW6+8?=
 =?us-ascii?Q?AtazLOPx2BCNHCv2hNRF9YeFhqcsWgPUHmHwoV5v?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 732b7274-f189-4f45-8c7e-08dd72b3200d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2025 13:26:22.1057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A6jJUtL5bCbpocTXyBZzCpguB5Hw+szM2ulXN7FGFtPWgGfp3hbNIkxS20+mfQldxcb1PD3lOBO4QmMk2qDKGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF82E3BEA84
X-OriginatorOrg: intel.com

On Wed, Apr 02, 2025 at 02:37:32PM -0700, Dave Hansen wrote:
>On 4/1/25 10:15, Chang S. Bae wrote:
>> In V3, you moved this patch further back to position 8 out of 10. Now,
>> in this version, you've placed it at position 3 out of 8.
>> 
>> This raises the question of whether you've fully internalized his advice.
>
>Uh huh.
>
>1. Refactor/fix existing code
>2. Add new infrastructure
>3. Add new feature

Okay. Then, Chang's interpretation is accurate. I will organize the series
in this order.

Thank you both.

