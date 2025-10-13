Return-Path: <kvm+bounces-59894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC296BD3107
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 14:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10F3C189CE24
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 12:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5255C2C21EB;
	Mon, 13 Oct 2025 12:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GkFmS+Hl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29FD26E714;
	Mon, 13 Oct 2025 12:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760359794; cv=fail; b=hHSOZz296FOD64BQVTq2B4f4jyq4d22Vaqi29U6Jcq9S7rEG1/lnYt4xhTk7LZlLv2anTlaMiYmOhLc7sSmMqtaKkysNbBnfc/lg80FBit89gjAvVEMKtqXziIQJeJR3dGtkEeG80JIkOzPBhf/j9gtErYUxHzX3ZFRvBKPFF94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760359794; c=relaxed/simple;
	bh=+YswMjsy4Mw8T4DYb7Xn0YFy6O8VLC9/8eR31YAwVQQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jvfbY3zl6YhxU0wcG7pp26wAuNtxbdCe6B68dws0E/1YWvTMkM5VkZ+NWAVUueykPufpwCwPFq8DNwAL7yjh0gVn4klHEDxBsF8tevwbjyJ/DbY2L633hspA2TMfZI6nLY84E4AfvYsQeHM31njRe0+szkFN6SMs4Z2Ci8WQwR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GkFmS+Hl; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760359793; x=1791895793;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+YswMjsy4Mw8T4DYb7Xn0YFy6O8VLC9/8eR31YAwVQQ=;
  b=GkFmS+HlxQrYWEr3g8pfT8hj7JEqX3IRX9Gkt65+XSEmN48NQiqj+jnP
   va/yvPjvHnX8AylwKJsFTUcu6bDcVi6UeKvzby5rGElBrVDQ+sDVoSQKU
   MjmIhAe173gqx5va3abDfJfZHsejvdzNpxCudx5h5dyR8uKu/mlSVmvm0
   1rYQ0eZ6ToQDoIFd79jccSyisu3NF3FvtkANQiJfIZn71lQ1fNlbJsEq0
   jVX2PNwXlpEpgjgFGleFEeVfe1WcQH4tjgApZkX0aFHWcGa8MKct+87l3
   ARkHuA5F4vzJhX9ro1e2SSRKrD1QV+c7/XWxpnaJc1reprtyb0/eZ5+L4
   A==;
X-CSE-ConnectionGUID: Dcp4GBxnTeKNaVlLOF67uQ==
X-CSE-MsgGUID: e3+AeGmNQpKUQramEw2GbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11580"; a="72756794"
X-IronPort-AV: E=Sophos;i="6.19,225,1754982000"; 
   d="scan'208";a="72756794"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 05:49:52 -0700
X-CSE-ConnectionGUID: ULdlln+JTl+B39wYTGR1gw==
X-CSE-MsgGUID: WLP4pa12RZ6xcrA+Uar0sA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,225,1754982000"; 
   d="scan'208";a="185601582"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 05:49:52 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 05:49:50 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 13 Oct 2025 05:49:50 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.35) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 05:49:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VgvSQbTU92H+CgLcyK2rNd13SIPNYzt7yjX0atRFS1YEZk3QF8a0Ez2XdF5eVylC24XyEXW9d7NNlFORvROwwNgwF6l7tRuDSGoSOJKqlkaWDRQYgGM4mnDnhCRdGMkQykB1KvnM+GYqFe4OHDoMnzDY8Amm4I+ZoC1soelmRuK5FFkZQt0v/YPu7jBBCR04jnBwEFhpZqPvuL0pOQCRHBiKsTFnetztZe8UNtcBP+4BGawyGYW/avmEggn1nituFWrz/6OsSNMWfjLpeFkZkwqL2jZP01sd2ofPyUm0FI2cfldU513tJwqyShOM40XE7IZiNl7PIil+VeHOhm6Htw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ig2FLHf3F2OZyMVhIGGY0tosPsL8zFg2MP2pZlyTcWc=;
 b=sA+nCznEFzgMr+hrAcOj6yFDoCAiFMzLo9Ernr8f2z+mZKDWVgW5q8IILQ/h9dMmEex09tvAE0wbDdy1RN91ZhEhr2uhXHMVo08ii94mOfSgbEGn2yqZb9LOeywJlCckzd/G/NEDGjvJjsumd6CzPX/fIZcaTSdpLktvqKHrMtfLLvVKIr+TgtyNlxXDbBeAVul2L0JMz82JnVdCtdXIcPDMbp0L5fPO/r0zXEcmfaDyAE5jurEwi5O6hfhmMWP0TRtsTeN8UJe34AYtM8vq/nVfVyPZ6kHfnIFqn8I6MuRHcorZajylbcatukKj32MF6AaU7r8eMOyuEy/WhsJ/MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB7788.namprd11.prod.outlook.com (2603:10b6:8:f5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Mon, 13 Oct
 2025 12:49:47 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%7]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 12:49:47 +0000
Date: Mon, 13 Oct 2025 20:49:35 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "Kirill A. Shutemov" <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Xin Li <xin@zytor.com>, Kai Huang
	<kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [RFC PATCH 3/4] KVM: x86/tdx: Do VMXON and TDX-Module
 initialization during tdx_init()
Message-ID: <aOz1X4ywkG3nG2Up@intel.com>
References: <20251010220403.987927-1-seanjc@google.com>
 <20251010220403.987927-4-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251010220403.987927-4-seanjc@google.com>
X-ClientProxiedBy: KU2P306CA0070.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:39::10) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB7788:EE_
X-MS-Office365-Filtering-Correlation-Id: f6b31cdb-2535-417b-73a6-08de0a56fda3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5D9X4e9gYt7UqV+5sU6MCGVFRnI1YsbVWVkLcYYqhohi6vh16w2luh7ko8nC?=
 =?us-ascii?Q?rvyiMa3XiKxPVI011SShtM5ml4VfUkQMkWFgs+v3swe0DXn1CN7GOnEMBPYg?=
 =?us-ascii?Q?g+K+bKfYN9rHke5uSSp3gj6iIjj5arxYmk4hxW3mZQYsshVqC192dI7fC+jr?=
 =?us-ascii?Q?/WggHhzlRrEe48VWK4y7M7H+1t4nHcmyP6I0mp+bSFIiHBZTSFMGVs+7b80S?=
 =?us-ascii?Q?nHTHWQkJP8Zi0rgJFsZD/GPMwJSVuJxD9hFC25e6FWEIySgynhLWvSM36pdX?=
 =?us-ascii?Q?hHu8Fh+ARun/DP270geDU5DVpUDvH5aa5SJ2f2yy9an7raOStt6a3H241v+K?=
 =?us-ascii?Q?kDFAKG/rSrW3zuFi/lSau0Kqi9zk3e4FBYfm9f1uWMRUCHjr7WnoAsXO7zJr?=
 =?us-ascii?Q?5Yfe+8LdiJuhPD1sNsJkPP8ZtBEg2C0iSjX6uXaXoLgIXTdvasiu/7U8gBf2?=
 =?us-ascii?Q?clU9YwpQMhdH4CudtaeuXQuSSPJGQoqi5DpCnr1CKAGwm4xvuMc+/IZgfWu/?=
 =?us-ascii?Q?jf2D7BTyk09cvamBYNEERF7+RPzbXot97DYFI1GnvC7Ei7wb+GtAsCGVqFbW?=
 =?us-ascii?Q?JvWVFC+9MfaOB0BVQCTZfmqv8dk8ra2kqNdU6EVAqbxdnivYsIwRZt1oa9GX?=
 =?us-ascii?Q?vrHKlpNLsvXVuHUtGLiupXWhv7pLbbu3kgEiuTmgZi5Zk+HxCg/v382O2Tra?=
 =?us-ascii?Q?4lJFzb4mz5cVP25ArODuO6TxRtBVCcbB5a/nKz8XCYWhJhcMNjCEWc2kip2C?=
 =?us-ascii?Q?K0jhtNTiIKik5OtR4Il1TMbzhHdikvkv/gl72lteAcI7Q76xza5YkrhcyLdJ?=
 =?us-ascii?Q?rFlgGZtPiPWpX5926FhxHQOHzhsBYyImNzc3cH0KxglbulVBddxpH0s2QPAR?=
 =?us-ascii?Q?ylIxzHAC0xhWmd1o05msWeJpRW9liP65GzUg+5aIVF5laiCUgVftULOZA9Su?=
 =?us-ascii?Q?jsrDm/5TaM1oiHDZeCIQXbG2u0w++EbZe1xpih4ooGeS4E+B2hGzxHzKgFwW?=
 =?us-ascii?Q?SHwy18vMbFQhvXTMjz9ZhwS37ZomC6RnkoMXDjpxbsGPO+NdwcyHSbpffJs7?=
 =?us-ascii?Q?Bb74IbpdUacwuOQYfIGh0wXuorVq79oShEWWDmBX7A87+/Ju+hTGQh6pJK7Y?=
 =?us-ascii?Q?mtobyiwm4h3wfML1pmIctnhwjsyXcbraEBDAY9uDUeS3JRnmQ28wOZNqXC1z?=
 =?us-ascii?Q?bkLZkHbZVUAqkwpPqvXD/Nb6LvS0t9nFaNgrnhGXeEq57J15kPs+xpShOR3K?=
 =?us-ascii?Q?su8ecrX9GrfxeAqZ+oIZbWsGXhRwYylAwgMAnkZ2QVtt1K0abL+bylfxLhyP?=
 =?us-ascii?Q?5+AOrf/znKZrCkPBjw49bfX9jh09GR2U+F11H+Y+pIfu9wOkUPxLtBJAFJJP?=
 =?us-ascii?Q?tmGREa6ymqDoDVRNU31llc0xy6HduR9DE7Fo5m20K6tfNKC3U1OK5ebueeJA?=
 =?us-ascii?Q?J/vi74HPJ4Y3TYjPDmRVDqtt12WOFiUs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SY6+R4PfLpAv1F4POv6Q4V7mhC4O5/+HwXHRf+CMmwLEH8e2uAS3r60Y4PqA?=
 =?us-ascii?Q?DM/6wtJngVHBG64wkD8qaZG7mJGoSVL0VN6aWLSwlVi/XV/6lXNvGruj0Gw+?=
 =?us-ascii?Q?jwnl06F35nGU/P+xu4hwaBrnG677sl14DDySF/0aLQX9rwOlU4z+a5oCeM8i?=
 =?us-ascii?Q?WiFmbg9tsyPk4g2SXgQaJHh1Chiid2+9YG1wZau+L9dUhKwG8jhIyUAym3BN?=
 =?us-ascii?Q?61DbjCVhXu98U89IkcTzIJpT2HBQpMwnc3osfmpdoup6xUpZdXeZKZ5BsHN1?=
 =?us-ascii?Q?1gRouZ0nTnz2eUKmu0SXMlxAsyg1WTOl5mHXHeelLv5ZZW3pRkhBKoOdH5gd?=
 =?us-ascii?Q?DSLNtoheLdxV27vluAkk0rQvqVgn/yqR9MIpVmQwQAbimP29Tjn5+rJwAT/a?=
 =?us-ascii?Q?6RtDuuylHg4Ofkrznu38pCNTn0A0VTVGImHsMwXCOeAX4NwwVCH/d96mlUsc?=
 =?us-ascii?Q?JWXOByKv5hkcllZELTzbEvX1fr+lmS8uVNzTpq36UxnERvfklDUufOsDC09p?=
 =?us-ascii?Q?awOD1Pok/sup9yLp/cKho5nln+LcW9FMkyG6vmC0vjx76EzJM5phOeON9uwd?=
 =?us-ascii?Q?GzTYcrJheCurh/kBCdGtQfdErszd2n2LkvelzBEdfCvOAS2PlWCVBbGcTYnN?=
 =?us-ascii?Q?sDVCoH1ZudsdH8tjKAj9sQsVtcICFDLAvT6EttTaqv6qOKlrdtJgoZY4BrjI?=
 =?us-ascii?Q?8FAFYlu220xe1yFTwRT5XPLaRnOeoTXHVmFkzMe32A/Zl0uUaaPmPUhrNEoU?=
 =?us-ascii?Q?Qva7Z7HH+kWujco9QC94zqsUCI3pvXG2fKaO8d+T4mRPxdAJhOrbhy/GJ4IB?=
 =?us-ascii?Q?bhwS8McsfmX0ZW5NQLDA47sMbn4zTUgivhHJivi2ZooGj36B0Z8yw3F2YWFQ?=
 =?us-ascii?Q?MgLaeVfeAD6sUzfZ4LmJbMBW01qxVUtcupFb4PtX5DJhEcqBUAUfvtOXf7+A?=
 =?us-ascii?Q?0+511o3edP9WrGH7eytT66VF850btPcJBPyZ0xMyJgDpGSD2eK2feYGxHlFz?=
 =?us-ascii?Q?Bgdr8Q3enQxPonvZe/1QVvyeK1NWvAYk3GMvkjm1d6Mt+cfi4cmezCJlwP2G?=
 =?us-ascii?Q?gkmK6p9G0m6SRT1Au2g9a4vsSu9GzFUH8CAqsUGrd7NZcNmLrOib0jERuhAN?=
 =?us-ascii?Q?vt2a647ixQdAfzjweSXQRT3y51FZdJEkquFtfuRi2dFnGsWrrf6qG0euCVS1?=
 =?us-ascii?Q?kXbiJHz2NcCU6NfDgv2zvFqEzrYyWb7sC3QSCLUrSwzOQK0nna7Q/CtEXJjF?=
 =?us-ascii?Q?OiGu1M/0ayOLJnHmu9Bvf6KWiAA26SikFfit70gwfdgnpfiBs1v0lYvZ3Rd4?=
 =?us-ascii?Q?aSN6FPVtCO6K/1xdmAe4F3wd/bsLUu0LagVBQUwaFZV1CufIP75FFiRAkkh8?=
 =?us-ascii?Q?ZHHEWiByge2nCX5i0QvCj7KjDNMhJY54IsgeUm1a2MAFD3+10FJvh+506C7O?=
 =?us-ascii?Q?6CLXTuCvXTFODXOxEXG5emK3P5dG5Lc5kHAtcQdkFWqWtmuOe8FZXUR3rRo0?=
 =?us-ascii?Q?UX8JE6eKsgn5W1cUd0TeY6kafWdbMbdSI9EEyzW4pzfyyXKaHF9ZNm1EapDR?=
 =?us-ascii?Q?YVQHhuaHTliLOgaBtAe958JDI9XgKAR0SPGIDdCW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6b31cdb-2535-417b-73a6-08de0a56fda3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 12:49:47.4431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VIDk7C+T0WOq+Mu3R9+76z/nNofl3dpV/C4M3lstxNu+2/cGVfbWTY7Z6Xy02bldbdDlIH7c5IW4ozV/9F6WUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7788
X-OriginatorOrg: intel.com

>-static int __tdx_enable(void)
>+static __init int tdx_enable(void)
> {
>+	enum cpuhp_state state;
> 	int ret;
> 
>+	if (!cpu_feature_enabled(X86_FEATURE_XSAVE)) {
>+		pr_err("XSAVE is required for TDX\n");
>+		return -EINVAL;
>+	}
>+
>+	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
>+		pr_err("MOVDIR64B is required for TDX\n");
>+		return -EINVAL;
>+	}
>+
>+	if (!cpu_feature_enabled(X86_FEATURE_SELFSNOOP)) {
>+		pr_err("Self-snoop is required for TDX\n");
>+		return -ENODEV;
>+	}
>+
>+	state = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "virt/tdx:online",
>+				  tdx_online_cpu, tdx_offline_cpu);
>+	if (state < 0)
>+		return state;
>+
> 	ret = init_tdx_module();

...

>@@ -1445,11 +1462,6 @@ void __init tdx_init(void)
> 		return;
> 	}
> 
>-#if defined(CONFIG_ACPI) && defined(CONFIG_SUSPEND)
>-	pr_info("Disable ACPI S3. Turn off TDX in the BIOS to use ACPI S3.\n");
>-	acpi_suspend_lowlevel = NULL;
>-#endif
>-
> 	/*
> 	 * Just use the first TDX KeyID as the 'global KeyID' and
> 	 * leave the rest for TDX guests.
>@@ -1458,22 +1470,30 @@ void __init tdx_init(void)
> 	tdx_guest_keyid_start = tdx_keyid_start + 1;
> 	tdx_nr_guest_keyids = nr_tdx_keyids - 1;
> 
>+	err = tdx_enable();
>+	if (err)
>+		goto err_enable;

IIRC, existing TDX modules require all CPUs to have completed per-CPU
initialization before TDMR/PAMT initialization.

But at this point, APs are not online, so tdx_enable() will fail here.

