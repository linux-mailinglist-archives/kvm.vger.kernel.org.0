Return-Path: <kvm+bounces-66695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A4AACDE36F
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 03:03:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B45FC3004CDB
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 02:03:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 268BB1F03C5;
	Fri, 26 Dec 2025 02:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jYyEoODD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DA63A1E77;
	Fri, 26 Dec 2025 02:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766714607; cv=fail; b=bq+YwoQtrUgfVUoV0b1/f0LN29B5NMTu3cSz20KUT9mA60MVz1s6iu/F7OkSN5iJFQrAmIl3cBUsuoG2wc3//e4/6KO+Kw837pDSb1Tol7/kPMcDNUQZPGczOwxwn9wkFPscjANN/rlcxlagumVkTRf5dxM3W2w8djpOMCAoPxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766714607; c=relaxed/simple;
	bh=8GPLpdNuH+TiLX+eoHM9W4xTM+IX0xyw7yS7JK7R0Ek=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bVWvedZn+yl89tkSH69EtufgBB1viInRXDdgRvw3GsMmaMvfoKlgUd99JOH0RBVXDleaAO8kHqe+jQA3Ywv4jvdh0IngONJx9t9NeKE6/TQuPDZHTxRxpRt8kr3TgiQLdf4vcaXq1VMjXqayn4qir3SEKpThxUs0LhiJ8ozhqCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jYyEoODD; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766714606; x=1798250606;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8GPLpdNuH+TiLX+eoHM9W4xTM+IX0xyw7yS7JK7R0Ek=;
  b=jYyEoODD9plqfQ/ITuZcD92eJAPaX2PCXtCadGlSLClUvATc2kC9PmQK
   85tD+Oy0Vv+yquAdp3BHZ0/nfPh7uw+ciUmg23JBPvzmVRg921ShP/kqd
   NZeM+g3ncMfWGtJORR4Co3dEVGU9qkBIX7ZIUn4ibujOVBlj8Tky4QwDK
   aGntrCiJJKMV0HV6QyVKrYIyZO2FsBrKCbYJbSy1udiRnMK1R6V9puO9s
   NgOn/oOv4yxZgTuwjfYertkPrDcKaMS6BtWbzHp5ISxKPsNOXVIaei9Dm
   XJZt1dh/q8RhIsrvbBfbGWqoEju/3rLIUlTxXDvzkn6IbPKMTuuBWHBuQ
   g==;
X-CSE-ConnectionGUID: VpVkcxxGT/CMAaHu6FitYA==
X-CSE-MsgGUID: 3birLnnaSa+BBx9WlAvujQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11652"; a="79124862"
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="79124862"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 18:03:25 -0800
X-CSE-ConnectionGUID: gU4doSxfRmmo8kz9mZpLmA==
X-CSE-MsgGUID: XYUJM+1MTyCYyDdsRTf3Cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="230965879"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 18:03:23 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 18:02:34 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 25 Dec 2025 18:02:34 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.26) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 18:01:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EiTHVbCDldy+wq0Fl74527dRNcAvnxhFdiO9Waae3Awp6sMRSYB6Wfnk982AsH2RYfFk3gjOqfMflpKaXG97jPXEiXNiHpwHe3SCuFP3nSva3a9j8xztcFId9OJ7W28ePaiadDDzzCs+evw+439IyhTZlPZB1lZhx/rk9vTkjcPeUnmgDJMtW/HOGMdLfSioSNqRw0U9HxAKq9x3yve2COn1Z2b560oLV5cUBSJfKIOfuvfxjZP4MhlB2sf84gKFlzTHgy6KdDRC343kZApMDZOxTr45ExGk03IUkM4kTb+D/7T0e4A5s2MZXwrKNLk3twg6MK5al7J4l5bhELpgQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKnCOnnVC4iVAZgUSDt962lCooy62qA3WgoyvKriFSk=;
 b=UKSQjlNzQwhacjVMRe0ePOXcqaDqCNlnm7F9w+xxs+TqtrYw5qX6eztklDBgSaiUDJPS4FvUtphxOVz0cZaZK0oJ3mmU9KB7sKB4uDp9blRuIzTgs34EPLsJw7+kqNNYeUC20VYAd/UChiVNE6LttanSwaiLzezDqgiJezMEKh2W6luHJFHa9zHpDR3GSXM5LBhQJphEcNEFgB8VLA+gwzGltex4MpK7mfH5RqoORFk7oElvtiCNyNjwoKk/Q/gsbdfr1uaUruKDT8/IOnO8CYOrgwviIf6kCzxhftn9L4IN9UARuF68aWZZPc4bO+r1kM/GH01o7JxUmY31O+uQiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB6556.namprd11.prod.outlook.com (2603:10b6:510:1aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.12; Fri, 26 Dec
 2025 02:01:33 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9456.008; Fri, 26 Dec 2025
 02:01:33 +0000
Date: Fri, 26 Dec 2025 10:01:24 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Dongli Zhang <dongli.zhang@oracle.com>
Subject: Re: [PATCH v3 08/10] KVM: nVMX: Switch to vmcs01 to update APIC page
 on-demand if L2 is active
Message-ID: <aU3sdIMFi1iKvTYY@intel.com>
References: <20251205231913.441872-1-seanjc@google.com>
 <20251205231913.441872-9-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251205231913.441872-9-seanjc@google.com>
X-ClientProxiedBy: KU2P306CA0040.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3c::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB6556:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b97841d-89ea-4eb7-6a7a-08de4422b178
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?VpLNe2lVnHNZ5RxmZUwGjWSywqS0ealr92x3RHSA3E3Izt57F4l1WyTzITpU?=
 =?us-ascii?Q?HApX9RtrJfwanIaX3mtpB+5pNVf8QC8b5Oa6w1UgVa91MVKs5IZ/W77F2qpz?=
 =?us-ascii?Q?5Ga8rV+6iwnHJcPsAzX9Yr0vTx9ktaYMlNKORyhn4ROJHg/mT0cI2w1uexyO?=
 =?us-ascii?Q?8FVqAAhT3fbXnvOmcp+F89QuR3wCc2jqvqpNFAnPx4lEJpepNQWoxXTwWd7Y?=
 =?us-ascii?Q?g3zBlLAxc3YrzE4q8u+3A0B//8AX4Pwzy5151toloJ9ZVdI9xnjMXh2m9mOX?=
 =?us-ascii?Q?lhDe8zQxuqt1bO1Px1p2uKCG3X4P+hbp4VR+1YDalRlOYHQscAQrOtoFCGeK?=
 =?us-ascii?Q?AC7eSb/5Poj8iBYBjXJXZINYbBtpo5b4hrAntxH4uZJGLAPBnTERlGVneE8Y?=
 =?us-ascii?Q?8zgXenF7P0DRI+ljDFkrWTqpXdReHIzj7ReFj34/D5/yXS1e2718QMn/eFeR?=
 =?us-ascii?Q?anPiBuQCgNJ8Vrd6K/TIDl/eFUavOe2p6Jjss/NbVTKPV/ZPaEMTFbixMPZl?=
 =?us-ascii?Q?hs3dbbP1OwxDJQHHqj/dJo2c1cWzpJhCGksaICXHk15Yxj1JjrhR5+N656QJ?=
 =?us-ascii?Q?+yo5EGJNcFjTJm16KWpjaDt4V0m4rVI3M44Zmtx8g3AdZn+A0HRioRlvbgnE?=
 =?us-ascii?Q?n3Goqpnt1w4S5/r+Ofy4rq4v1cQi4jpoIWxsywiT57Ma7lKv3Z/cZwyxYSUv?=
 =?us-ascii?Q?jRvcnkNWI0Ub4nsZmZDzUWWrn3fJ+b+KCN6tosRL0H8mDqW6Y+L17HWfBNlu?=
 =?us-ascii?Q?y2h/Jp+TbRzzybAi/F/ZImM7ODKyuaZ+8UopVNvO2KY/Se+VoD8vgEm5kdDl?=
 =?us-ascii?Q?SAYa/VJOS4a04THwZia3NoL3phxOtF+hmMtYxHU89f34V6tmRMF83Oljvlbu?=
 =?us-ascii?Q?6F2Lp0xccCxXzGxucWzOj5fv/zlaXGcur6UZjZDuKvscInVKziNVxlnYE2LF?=
 =?us-ascii?Q?S3/rDJSK5KKugGdm9oMLUXBifBGzU7nM1Fb9YywK7NBPOmHZXDyzSR+xc2Wq?=
 =?us-ascii?Q?7jH+xr/kgrCTVkqGwBa/2xSxrGaxOdq3XorgLwcR0bXygZbq1zS46eBIDqP/?=
 =?us-ascii?Q?sYvu0nRiIh7wiErOFVBCQf68CITLDA+7ESazn//LiMCZP/5qXxuNIZARExpb?=
 =?us-ascii?Q?SFQbRr05axdIZBuaDeO+kky80KyED9oH4+9w82s4PTWh47mvSTPGSgUuFQaL?=
 =?us-ascii?Q?wRxDA7h+CQnF+ZqLoPniwaSzrr5UyoyeGuQZfoSnQCTQ8ThKJvZufN/h4kyQ?=
 =?us-ascii?Q?+e71bNWNFp4yFFVxR37NHaT/ALdiZkt1LN4nu907Y3guBe5ah4OBtoJ1RIet?=
 =?us-ascii?Q?igdFQHH6qCeDfCLURheqyTqwrwLeS0SzuJCP967FZJjSnB7uEEYWfOyKJ1vN?=
 =?us-ascii?Q?L4zz++BUMygbCk0adr0qlnuoPmI1E/kk75P9AubnDfKC+1eNz9ssIvd4Iswc?=
 =?us-ascii?Q?0czY7oEoL36FKCT4CxFsTVCYmImjoDnd?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?It03D79/WEdNIpEGEUOUnY98TrJmWt1Od0lpOePTOnFdKJSTfR9SLWagibqB?=
 =?us-ascii?Q?mmrs4CruLir+DvVZlyBsoJESSEWMyYWTQYW7XsndKfL2cjQGkrje0TBNSr24?=
 =?us-ascii?Q?xcszTTTgeUt6/ErSKb3dm+E+Wn2UOtH81p8mMn1CYp6qiYIRsQRMpGxSFBTf?=
 =?us-ascii?Q?+Bm6ssntSRg8NdKVtjoPnqdn5sfK8LbjsG12JuYl5mrNgksmGUSSbVPBf5mt?=
 =?us-ascii?Q?VJdbmvddaoZTfypVQay0iQRDwaKLgIALJEPWwRkfbyHrpcdI7NFOHBTxRcL8?=
 =?us-ascii?Q?gNmseB/PnSODiiB29+6Vq6Z6mlsi+ZCgGOiDlLlm2JGvjKZWeP2RhH1HFNBg?=
 =?us-ascii?Q?jRVT4OmVHa0o8J+6Shr76CWKEjfqFq7tCH4G7UqwtRzcmQq9mv6qHylDj9AE?=
 =?us-ascii?Q?ffSHrfXz/zrzz46qj3HIBhuZ1aexVIL5xwj7MK0N5brJN8ro2vjnGXJOHgLA?=
 =?us-ascii?Q?0FqKTZu3Fpkt4GSe/uUT95RhCz5Re9TSkokZx1dFHcqOo/ge8Cm3WTou1Okk?=
 =?us-ascii?Q?P8Kii9nratYlc8yKG/luA3A9bPOnZqz9prbzl5W6+aQl3IAF0ucIPMtWs8AN?=
 =?us-ascii?Q?uR2qukKxbn9zTmq3mkWJV3tf96T1dq/sSEMtGnGbcFoURGdjSdOW9CoNZ0+4?=
 =?us-ascii?Q?eYbX2xXYPU8/EMTurU/uojYCeUD39FRQFicqJgc9Qg4B1BxrhmP7zBdUT/e5?=
 =?us-ascii?Q?+6+y/GM8gcCYxecMcojnu/StV5n/GkDlB4sDUrUgiqw5EXs6cRvg5BZg86XZ?=
 =?us-ascii?Q?j577BrZhPan2ZgJKLYZGnywTmFWVCmja/EI6tK+msyS0/qq15NmO1hEqdws8?=
 =?us-ascii?Q?f+tFR9Hm9dt4aERBPiYjb4cNFPN4sDjp5fFrslHyud1RWFw3Z20SPHNLsCTS?=
 =?us-ascii?Q?MOA7bO3xlHleHyMDfXb+ZJjF+W0YwfesX85N5xsLcVNZN+6xVNzpcFj10Qz1?=
 =?us-ascii?Q?4VQjE4W2Gd0XudgrOCH7SwwPaccfrA3D4V7eyFTiPGqlMlNT6xHPaxAZ0M+p?=
 =?us-ascii?Q?sK2g0U3HX+tMGP7mrMZPiYpWM85s+Xgqwq6QsAddLZ8OU7e6HHRmeudKRMX1?=
 =?us-ascii?Q?Z7042MvrvN4bU+NZx2EA14MWmMbVywxcRAcvzCxMTIC0gP9oKDeg2T6GVOav?=
 =?us-ascii?Q?3dte1LkIzKDpiTdA4J12V6/KPvZhogQoz2Ab1JCmzsq4/oCyUdDv55OGGmBI?=
 =?us-ascii?Q?U4ZRrh8HH6F8PRj0VzlbdRODh9ySzYTkSq/h4VoLPWszD8DX3iBZpSpGznaO?=
 =?us-ascii?Q?+SRUPHXLgYR5tC4gUdNeygbWcPp/gfntAG7uhLdEej+B3XBalQQ23YVlPmnI?=
 =?us-ascii?Q?2nl4Comen7rMd28LK+qq1bRwnT6YExT1fJgNPtHIg0RHVLQn8rOUt+GmnRQO?=
 =?us-ascii?Q?rPJzTZRTXQqt7IVcMaApqeYv2ulX5k1eR79CVaK93ij7jD+Ey9AD2dV3FBEg?=
 =?us-ascii?Q?y39nrlV6ZlqzbmmKRAf/HLMmAIWjGduny0cj57Zjs1ZBhRRfqsQ4zdLwrd0z?=
 =?us-ascii?Q?Mj+TvZanWN0vOHVFoHCuf5oSQtGR3ZUH5jwunbSBIkTZ6WyyCnF8oQwemr7V?=
 =?us-ascii?Q?etMFllJa45yFUgxH04+fTUbKvvHSu1qHQnyuftWkTlOy0kM1uqB7snBhyGVJ?=
 =?us-ascii?Q?dU5wzViqAO1KAMt/1KHZyKCryKlESo1InTAF69Sq5bFqcI8SniFA3/4+fb5U?=
 =?us-ascii?Q?Sd/r/9+mKaoZFeF3FTyZyk8LouT5o7IDXEUWM1y4JVL6euip8z4y+vFQ24ji?=
 =?us-ascii?Q?lNnGse6fnw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b97841d-89ea-4eb7-6a7a-08de4422b178
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Dec 2025 02:01:33.1555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BTGfvWvh6CSC1gwaJcruTdd1+G9sFh+0Szb/pjaOaaK8h+YCMIm2VKd77QliKCO1mv8lhOHmZrck2VYR0O1opw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6556
X-OriginatorOrg: intel.com

On Fri, Dec 05, 2025 at 03:19:11PM -0800, Sean Christopherson wrote:
>If the KVM-owned APIC-access page is migrated while L2 is running,
>temporarily load vmcs01 and immediately update APIC_ACCESS_ADDR instead
>of deferring the update until the next nested VM-Exit.  Once changing
>the virtual APIC mode is converted to always do on-demand updates, all
>of the "defer until vmcs01 is active" logic will be gone.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

