Return-Path: <kvm+bounces-43232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 480B3A88199
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 15:18:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8AE617A48E8
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 13:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153B32D1F6F;
	Mon, 14 Apr 2025 13:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fdiKlXhx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0252C4C9F;
	Mon, 14 Apr 2025 13:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744636728; cv=fail; b=bC7CkJfH8HSuG6BHV8mowkpJzI5HTYIZoQDls/pdo+3rlLoYqCW7j3r0v+LFaDUqjy9txoq28YYMFFf4iINsHqGsyUh7KXutnJYkcAjVqssRcP7eU1mN6uAwfgdsD2aEURPeiJDR1oKnwEmg0Zf2iEonL/wIxAlR1P3wpnhrPko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744636728; c=relaxed/simple;
	bh=dF13+II7wWqCy3zDA2jX4aGzAR5sx3Vl7Oy2hYU557g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gBoUCwZSg9Z0NSdYzya7g2/qBmL2x02Y6oxbSBhHkeAboxsWFwoXYg8NQhytdCO9+vj0BfuNhKRxyNgDBw+sl1z0Xec5znmMjRK+YZ6/XqtOB4afDdAyqZbvBeWpW9qPTiFWmCSwdBXZuRfmkgSXIxtR449yPVMutGHhD2P3KVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fdiKlXhx; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744636726; x=1776172726;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dF13+II7wWqCy3zDA2jX4aGzAR5sx3Vl7Oy2hYU557g=;
  b=fdiKlXhxTbpPG5RwZU1pa2GBQrmHy2JSBiJlxMulWyMpXUQiW+FXxEVj
   UiG4pG2JXefQySg1emrqluhdN/47uThzn1WwhMHjfyJ3K1Hn0HjphRTtS
   Nmaa2v17x7IYVAIR+QQbITZxzcNiy6xLasw6kPDdEBheqye3kLS76/9u0
   oLsRIX9wgOXgezLRgg4o8ZY0wBrC+knClRUKTJRdMqNqQkNYqBOhD+kQi
   GpW8X1pGjgUj1HBaTl6VfXbqAqrvuZTwVzSKl13/XO46UKDp9go+256nG
   xXC1d7QUF5XfjqvINAuT2ZcWA7GimpXESuk+Ez97WAR0kOIUpcPtw1wvP
   w==;
X-CSE-ConnectionGUID: nq9LcmExTxKyTBvzux51Vg==
X-CSE-MsgGUID: n65A3KdRRSyDf6y1TYe3oA==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="63508816"
X-IronPort-AV: E=Sophos;i="6.15,212,1739865600"; 
   d="scan'208";a="63508816"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 06:18:43 -0700
X-CSE-ConnectionGUID: U2/Ic/kRRqe3O/rZxAYtEg==
X-CSE-MsgGUID: u6MvxNX3R6OSpUEPOdzXVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,212,1739865600"; 
   d="scan'208";a="134863091"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 06:18:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 14 Apr 2025 06:18:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 14 Apr 2025 06:18:42 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 14 Apr 2025 06:18:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XV0s78ErFgX4lXBotuBFopDJyEPOciwA8Na3U1HgUel9fI58aisjA6u4TjIBNmc0LYMg5STmeRQQnz9ftzg4sOU2aJyD4zSiTBTHz3zzYrmAuQPZeitwOIhwf3DmiPVAwG88DKJYtb6pLKw1CQHYBnZ9y08zH91NRJdnJVnND8Bpik4nh+9nFsfNastCV+wa8KtubGnyh3/4dDpSRjV3bvWoK505sZ7CjwsM4G/kC3lRuv165ViiTzCLW120TVTBFARAI8p3k4S7pBGyht8lSNuxaUr7DcPqdr9qTCycKdBNwipUU8N2OaRL0vCxLX5AsctT6jZHtdrQVAPbQVIv/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Rohrdh0fEn60EtdTZTZGdF7tuV1f2zLz/4tVjVqM0M=;
 b=aQ6gm+Drn3K50qdVEUTS6fkc//vZ43QPVVD7NqTet+lzZO/5gvW6I4YqJfhrBcyyrzo+Bm4nTrK50qELAbuGCPcA/LC4Kyq7034ixnJgXAQ4VoPhqVR1FDoPyPKTeAnfxebg77TqWqB2PmoCQV3XIu3ITFNp+Dj9/zDo1Uz+tOvjJFI2k7+52bcy1SddrkkwYzT8m/9ddUiuSi/2/+YGiZ9ttC0964zNExR0j33lSH07+4Ru1EcjTLEY67vSQgmepINHhHTnMX22FBGFDE9PpN79RN5G9I2MrRb9ZleuIkcpDDojKBzOrr6w95o5zyTvlfOW/qkC50Nibe2fh6v0vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM6PR11MB4739.namprd11.prod.outlook.com (2603:10b6:5:2a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Mon, 14 Apr
 2025 13:18:39 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8632.025; Mon, 14 Apr 2025
 13:18:39 +0000
Date: Mon, 14 Apr 2025 21:18:29 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH] KVM: VMX: Flush shadow VMCS on emergency reboot
Message-ID: <Z/0LJTnNCsQ3RIrR@intel.com>
References: <20250324140849.2099723-1-chao.gao@intel.com>
 <Z_g-UQoZ8fQhVD_2@google.com>
 <Z/jWytoXdiGdCeXz@intel.com>
 <Z_lKE-GjP3WQrdkR@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z_lKE-GjP3WQrdkR@google.com>
X-ClientProxiedBy: SI2PR04CA0004.apcprd04.prod.outlook.com
 (2603:1096:4:197::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM6PR11MB4739:EE_
X-MS-Office365-Filtering-Correlation-Id: c6761e59-8501-4e05-469c-08dd7b56deca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?X7Xuh8bTS+djsaCFexQoYU1gIPcTVY8cWPJ6NaDR+QXKtiXyK14hP8R8kBgR?=
 =?us-ascii?Q?FRcl2yqqighiCGhgG2AlpAmn71kscC1W8jkurIFMcz1XVJgfVDed28SfOtcu?=
 =?us-ascii?Q?N85vPzbHJcy1rLva5yvxOPhtMskuCtOq+Svb4V7OlTzqixqrdg2P9dHiXU7h?=
 =?us-ascii?Q?Cvqg9pYwTYKENQ20L8+ghCE3ozsQSQ0Bsx3NsM2dYee4lAutgiRgfmWE4qL7?=
 =?us-ascii?Q?NO8RBWJ/yc43wprP9XBRTFSRty6CO99AIF/YX2W+JkZrHLzibY1m6rTtQG4r?=
 =?us-ascii?Q?xqpWcIrC7gZMjHSoSKvAzeQccLxQ3jSjw8CYilWZHsaB3t1qKEuLDdQcNOF8?=
 =?us-ascii?Q?YP1LXK09T1MLNrHoC3/VUwGpexe9VxirMdn1Sd4VbO0QIZxFyEnOdfIRtbsb?=
 =?us-ascii?Q?bFMwmjXdLyZz8PWVUhpUWmmSt2q1TdQ6DdS7PJLWacfj2NghJnzba2YehbRu?=
 =?us-ascii?Q?K0sPLICHXJZbt7X9yoIle0e8Xi0qKx8OM+A5wyLhcS8DZnO8yVxVnFWV7foF?=
 =?us-ascii?Q?wvMPqZy+UvuQDiW73UHXtiU5oisQf7upfawUwcztQNDg8bFC4iiBpNfWDVBO?=
 =?us-ascii?Q?QoeSUFC6kRMYkBYaJowFkGH/i9W2tz6AK2U0XSrBuy4vXVcvV0gQ3q344iQN?=
 =?us-ascii?Q?DpBbZodlVpbXibHjNbVIIXQ+rpTJWDbuSG/j1JN4GUdUtPbmwPLoCgF1LkJU?=
 =?us-ascii?Q?554iS8c8+0LqXqz8McN9LP3sLvBKobFHvbmHDVPoACjEc7ynyPCTUZ+BhLez?=
 =?us-ascii?Q?jaq/KA8d3DHPbdC6EemE2aXKu6Xue/PZ0ykcKxH1+fRUDcLiTtued18vcTgx?=
 =?us-ascii?Q?Pwi9mC1T4lOXaR6K1jp7xDCxvjJvk2OHNb9//Wb7EZ/Ry2mlFDnaB3OZ+BVW?=
 =?us-ascii?Q?y8vZEzOQ53Ck9d2+7aEAHYCBfEH3Z2BV0Wya2uTDay2B7DeGHaMC20llYGBS?=
 =?us-ascii?Q?a4Br6MCeIqNh3z5BdsX3U27yuvcWL7DyXYrB1/cN9fzRKCxq+wqOE8ObG3kE?=
 =?us-ascii?Q?k+sbmpdzegdJ5lfGqVtjiIW/jr3k0+zyruxSv/2Yf1GuZ9b3tNoGuMBJtOvI?=
 =?us-ascii?Q?bWoiknhuBtpQSvTkfNwHhCKzIHOh1V/zJTZ9mOtdBRMADDZuD1C+uNKJm/Th?=
 =?us-ascii?Q?QUbuSoRjs0AzGRt0TRU2vioieMZqD+06bH6ql7WRV0xQKF4BVNmFBnsUnQ2v?=
 =?us-ascii?Q?79+NAdPq2sa43O85nbAaGj6i0FMTtAb91PjatdXyVC+rfzVn+uBpUiNr0dTt?=
 =?us-ascii?Q?6OsPoN0kzQo/aFiAYsUi2RIyhzX+zNQbXWVgcxWZ4vKZhcUulsZzDB1fhGHG?=
 =?us-ascii?Q?Pac/OZzdPY+fqhExn1G9iZS5aAUmBcHWfpXywTAJoaAoZHJ0GoF03nWqF2BR?=
 =?us-ascii?Q?dMysVOPS0s44toqT7KGgT52HBQobiMajWlwQxWkH35FnxYxtp1Y+DIZ65q8x?=
 =?us-ascii?Q?x3skNjUxQ5M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qTUuqv9baZVe1OZXKapdmFDsYn1bHwVJmUFnojX/0QYCS3tmdZk8MvaE+sUj?=
 =?us-ascii?Q?Ugl5Aatt/g+m5s4G+HuKcKIQ5AxBt4Ogwj0TGYMfCgohcd3xujLLWpgdsOke?=
 =?us-ascii?Q?0GeQrWBPLOo1LM/ooTqt7IY4VPLwXanljzNhEp6EmaPSumv9XDKinhu3UZF0?=
 =?us-ascii?Q?2nMAtDicirvxsrumcltTr/WgA1dhoBhozMtoQsbZ0QUYhYWsz+IXrHXGTwmb?=
 =?us-ascii?Q?BxZwNEKSfsLH06HshlbsDhxxCGYwgncwt0g+d263v+/m4JaoHBUHMVnPxKDb?=
 =?us-ascii?Q?5zTIwnZ0tQireOQVV66adQyVUBbq6V38oQpkGxbxmLy8ASRlsw6XV/NObGh5?=
 =?us-ascii?Q?V0nV2DdX+IZi8mg9mvWGO5w5iWNBfXOveyDVZBdJbVK/LEC0aQE5D6/bhHC0?=
 =?us-ascii?Q?rmLFCOhwULRtbkbmd1/MsOwqCTRgk6irqvO7ZG8+68WHvWRs5/sKKvzIFqif?=
 =?us-ascii?Q?a9pNytwqSDYP7fRFqrwbRQUiBthiv+Y4ndXuNku1dHs80SBrX272tMSIYOck?=
 =?us-ascii?Q?YuwSDF+tPKBTvW1vmHM7XCdU1V7WrZ+XrZCkt6cs3W7NkTh54nWWKWblmm/u?=
 =?us-ascii?Q?G0F8FWjD2+cP19GaQ+jlJr61xEVgBDLaqZJDJ8b7Yj+g64v3Oe03JcKnl0x2?=
 =?us-ascii?Q?GvqX/S08s0az9c8hjt3a1PcOUGxr3xoM6f0klHW1gZV7n5s47JU8x+fkK0Xi?=
 =?us-ascii?Q?9RO7SQNR7G7KkP+vuvqY1MQGf5QXs5dqXA9aEgYwtqx0cDQ6nqkBnur6Kx/9?=
 =?us-ascii?Q?VH+P85NXkSNV0tb7W1ORMV8p8y1BxWvrCcfpEz4za5F3a34zZforl/PtL8VW?=
 =?us-ascii?Q?VDCK6CgqT4pUGAEO177fTjxHtrSLv56BB/Ubbz0CepGZRCC3jqthY0ehaDjt?=
 =?us-ascii?Q?FgRP/VxYOc3uhF8mzUHKWTzxe8rh2U1NsX+Ql4Kf9Y5/8IqwJkVZHAUKINFP?=
 =?us-ascii?Q?hjBQfMco+1HxfMMoxIjUfsud45p7jZTXAG5b6i23UBacCwoj7VO1FaAiWknx?=
 =?us-ascii?Q?ytgNyZPW48Z+mUVyRnviFjlQlN/jwZwFQ0O/ynyF5O8UZkR2NY87L81cH1in?=
 =?us-ascii?Q?fELCjzPfr2nvnKIzT5+kzG5KxBH5CdbeDkp5jj3sodF3pKe8xKiarLTqB+dN?=
 =?us-ascii?Q?qitnRCDNditpXc848mNjmNWQaHNFeuQn8wtIroW/nH+dAxasFRDCE+5aejkS?=
 =?us-ascii?Q?yl5lDwGItjtLgV21xaCUZH6vSk8D0iVVa3MMn/542xLwHnq9GG52+qLSPJh3?=
 =?us-ascii?Q?hi1dQERjiUUccSGzpRfKYz25CxVVem0aF58U5T0qKO+fgR7TEqdRbSX7gu6m?=
 =?us-ascii?Q?+LMWEzlTloC54+cX6wIahD/BbDfDM6jc/YGLhtmfGknB82fGA8x4ILIRsbfz?=
 =?us-ascii?Q?Q6CcsQyL/Htx6sB4qK1cCnA4mgt1tCX/FDLxzOriSFE2asi5gCyCuQpwNJ/E?=
 =?us-ascii?Q?RMHQQJudwOq4m2Z6/23/psNspfhcbOFWYNcVFd4sbwKGCf6MYd9snri8AqDR?=
 =?us-ascii?Q?1xjtDTzdA1qz7Xh+5BdGjb5Ewl4p37ehP5olGoFa6Sth5Ay/vhetDgsGJgfF?=
 =?us-ascii?Q?83HnEstt3+XNr7f0mw/SOHbGOTs0IcubUAHksR+r?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6761e59-8501-4e05-469c-08dd7b56deca
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2025 13:18:39.3514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XN5I6bPtlyloqRKSztiJxhk02rAHHX+4J2qZxTQbzjjTxf13DvAG3hVmIkSXGQMq8VIlsWzOlglIHi4rlyuEHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4739
X-OriginatorOrg: intel.com

On Fri, Apr 11, 2025 at 09:57:55AM -0700, Sean Christopherson wrote:
>On Fri, Apr 11, 2025, Chao Gao wrote:
>> On Thu, Apr 10, 2025 at 02:55:29PM -0700, Sean Christopherson wrote:
>> >On Mon, Mar 24, 2025, Chao Gao wrote:
>> >> Ensure the shadow VMCS cache is evicted during an emergency reboot to
>> >> prevent potential memory corruption if the cache is evicted after reboot.
>> >
>> >I don't suppose Intel would want to go on record and state what CPUs would actually
>> >be affected by this bug.  My understanding is that Intel has never shipped a CPU
>> >that caches shadow VMCS state.
>> 
>> I am not sure. Would you like me to check internally?
>
>Eh, if it's easy, it'd be nice to have, but don't put much effort into it.  I'm
>probably being too cute in hesitating about sending this to stable@.  The risk
>really shouldn't be high.

I've raised this question internally and will get back once I have an answer.

>
>> However, SDM Chapter 26.11 includes a footnote stating:
>> "
>> As noted in Section 26.1, execution of the VMPTRLD instruction makes a VMCS is
>> active. In addition, VM entry makes active any shadow VMCS referenced by the
>> VMCS link pointer in the current VMCS. If a shadow VMCS is made active by VM
>> entry, it is necessary to execute VMCLEAR for that VMCS before allowing that
>> VMCS to become active on another logical processor.
>> "
>> 
>> To me, this suggests that shadow VMCS may be cached, and software shouldn't
>> assume the CPU won't cache it. But, I don't know if this is the reality or
>> if the statement is merely for hardware implementation flexibility.
>> 
>> >
>> >On a very related topic, doesn't SPR+ now flush the VMCS caches on VMXOFF?  If
>> 
>> Actually this behavior is not publicly documented.
>
>Well shoot.  That should probably be remedied.  Even if the behavior is guaranteed
>only on CPUs that support SEAM, _that_ detail should be documented.  I'm not
>holding my breath on Intel allowing third party code in SEAM, but the mode _is_
>documented in the SDM, and so IMO, the SDM should also document how things like
>clearing the VMCS cache are supposed to work when there are VMCSes that "untrusted"
>software may not be able to access.

I'm also inquiring whether all VMCSs are flushed or just SEAM VMCSs, and
whether this behavior can be made public.

A related topic is why KVM is flushing VMCSs. I haven't found any explicit
statement in the SDM indicating that the flush is necessary.

SDM chapter 26.11 mentions:

If a logical processor leaves VMX operation, any VMCSs active on that logical
processor may be corrupted (see below). To prevent such corruption of a VMCS
that may be used either after a return to VMX operation or on another logical
processor, software should execute VMCLEAR for that VMCS before executing the
VMXOFF instruction or removing power from the processor (e.g., as part of a
transition to the S3 and S4 power states).

To me, the issue appears to be VMCS corruption after leaving VMX operation and
the flush is necessary only if you intend to use the VMCS after re-entering VMX
operation.

From previous KVM commits, I find two different reasons for flushing VMCSs:

- Ensure VMCSs in vmcore aren't corrupted [1]
- Prevent the writeback of VMCS memory on its eviction from overwriting random
  memory in the new kernel [2]

The first reason makes sense and aligns with the SDM. However, the second lacks
explicit support from the SDM, suggesting either a gap in the SDM or simply our
misinterpretation. So, I will take this opportunity to seek clarification.

[1]: https://lore.kernel.org/kvm/50C0BB90.1080804@gmail.com/
[2]: https://lore.kernel.org/kvm/20200321193751.24985-2-sean.j.christopherson@intel.com/

>
>> >that's going to be the architectural behavior going forward, will that behavior
>> >be enumerated to software?  Regardless of whether there's software enumeration,
>> >I would like to have the emergency disable path depend on that behavior.  In part
>> >to gain confidence that SEAM VMCSes won't screw over kdump, but also in light of
>> >this bug.
>> 
>> I don't understand how we can gain confidence that SEAM VMCSes won't screw
>> over kdump.
>
>If KVM relies on VMXOFF to purge the VMCS cache, then it gives a measure of
>confidence that running TDX VMs won't leave behind SEAM VMCSes in the cache.  KVM
>can't easily clear SEAM VMCSs, but IIRC, the memory can be "forcefully" reclaimed
>by paving over it with MOVDIR64B, at which point having VMCS cache entries for
>the memory would be problematic.
>
>> If a VMM wants to leverage the VMXOFF behavior, software enumeration
>> might be needed for nested virtualization. Using CPU F/M/S (SPR+) to
>> enumerate a behavior could be problematic for virtualization. Right?
>
>Yeah, F/M/S is a bad idea.  Architecturally, I think the behavior needs to be
>tied to support for SEAM.  Is there a safe-ish way to probe for SEAM support,
>without having to glean it from MSR_IA32_MKTME_KEYID_PARTITIONING?
>
>> >If all past CPUs never cache shadow VMCS state, and all future CPUs flush the
>> >caches on VMXOFF, then this is a glorified NOP, and thus probably shouldn't be
>> >tagged for stable.
>> 
>> Agreed.
>> 
>> Sean, I am not clear whether you intend to fix this issue and, if so, how.
>> Could you clarify?
>
>Oh, I definitely plan on taking this patch, I'm just undecided on whether or not
>to tag it for stable@.

Thanks.

