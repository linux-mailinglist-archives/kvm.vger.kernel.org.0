Return-Path: <kvm+bounces-34663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 814C8A03818
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 07:44:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3E943A514F
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 06:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D3641DED66;
	Tue,  7 Jan 2025 06:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C4B26xLp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B09155335;
	Tue,  7 Jan 2025 06:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736232255; cv=fail; b=AVXtpXJsdDdoJh0933Cn26g4YJJAxFYr0+5VPtOwX1+beXRrWFI9nNeeFssj43cW2Ybq5WBs+ZgDqAMWFbzp/ORNwAco/MK+9raaSwuxIZ/S0kHi5oIn5frPM0ZjtKfVZ5D2m5D1cDqyxFB/WykFhYNFyFXGomKpe2ctqJMso8M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736232255; c=relaxed/simple;
	bh=fVbF7eOmY2Grk0TIPw0XuFA/r2Xnm5lz7CC2MeVg45g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dmAwCeqJX5X281cMnPANM5G7amEsfowoFw4UYN7NC2TAlJFqAFqhmT6Kzjx/R36M8kcpoA1sj3IrOYS5HokpXulcVqg2l3VMyPmA/vUf1owL/p2Y7bbOBqUpMAOerr3RSFgGIlc6Bc5iYxFVFaNcjz6FVnaEqdl3cX2LeVfkPVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C4B26xLp; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736232254; x=1767768254;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=fVbF7eOmY2Grk0TIPw0XuFA/r2Xnm5lz7CC2MeVg45g=;
  b=C4B26xLp6uZsLYAqB2epigbq0KSFnOp1NZAA8mkIBdWTp/YfxN0eq+JS
   GGsgBW4QHZp4pxg94BDt7KrgScb0ANUdoXSrwh+/thPH6rbOQGeq0kJCr
   6ad6FZqWnBTPTlO7hiFT2HNK4bcDDTXJJxVPj1f8K+K/u0vpwriqhOJ3K
   oz5ubFzWgmoCqcP+f7YbH4rDiOF5hytmfqfEgk/JcnIKS+t0TkaZLBa9Z
   +Bn9NczFPrhaAf8pIamxukfP/PUDfVP9xZhZUKCDlIgrbdOAfQteevSZO
   wunOcm9UvZRl+EtM10AKDjiGuBn5SInBZiiRle9DgVly8FoBKBZGVdP7e
   w==;
X-CSE-ConnectionGUID: yWhqVcFFRMOu8Mi6WAT8yg==
X-CSE-MsgGUID: 4F6jHLUjRMSNLc43xbO5cA==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="36278898"
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="36278898"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 22:44:13 -0800
X-CSE-ConnectionGUID: TGYzdHvQSgKNmW/PXOOEfw==
X-CSE-MsgGUID: 1LbnCn/8Rg+aqtLqICbPdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="102566945"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 22:44:13 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 22:44:12 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 22:44:12 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 22:44:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=grVaaJvmdp/TugyScOKRm9Iy3MS9pxJXj7/8bo5KftST31Dw3JBYTjk5/cjGlgWHwATBxI+l1Mgs4ldZWCZtb5m/P71ZYG2kSKTCbkbaalLCUx5RS04yOQKMWtrJZ24R2q8VzcW32FiEwAqudjsPfZziowRPbk18OkffxeqWKArZwHD09Sr+EAUcbW+lgUNvcA/ayz93DH3SU2JBRknRzbxHpBlSNtFnzroxTmE92YX4XrCI7jwpiCxHcKJEUTq8LAvpDEfuQ7qu8b6emprWWxnaEZhr2vfRjohNcJJl0zHzfl4ws/fsV+33Y3V1z1LUdNQ8rMVJUVYXyNPTCER6ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNI68hgwlLXj1aZ5C40v1Lfak89SrtxfrvhMuXQtRno=;
 b=qfPFjMB1aXVfq4NuJI4Ie3gQrMuIjL/AU8kujwaTyXi4lHIKZ9fh8TDaPCUXkXB5NTcdUHoNCABRFYBhKfgAKEU5kIo59wk0I16q2MIfjnSI7W8CXZ5/5KwZleK5lhQU+1uvdedmapV39yxOT21HDv7ggmUuKbT/FyEgm1tOIYrhZ/lwXDJoOlp4EVtPofkbOivZNxr1NF8sZXjMs9C+dPL1e2L2MjXJOyUeHDL32O8NdHTdd6qT3bT/7biS8hMtCLTLBxMDZ6aSybdaUNe1r2Ctb5cs5pDPK9rQ+cWRX91JIPVj5ov/YQAj5+OUyiqnQrJRc1y1oqo/YauLei6aaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by PH7PR11MB7596.namprd11.prod.outlook.com (2603:10b6:510:27e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Tue, 7 Jan
 2025 06:44:06 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%6]) with mapi id 15.20.8314.018; Tue, 7 Jan 2025
 06:44:06 +0000
Date: Tue, 7 Jan 2025 14:43:11 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 10/13] x86/virt/tdx: Add SEAMCALL wrappers to remove a TD
 private page
Message-ID: <Z3zM//APB8Md0G9C@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
 <20250101074959.412696-11-pbonzini@redhat.com>
 <f35eff4bf646adad3463b655382e249007a3ff7c.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f35eff4bf646adad3463b655382e249007a3ff7c.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:194::17) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|PH7PR11MB7596:EE_
X-MS-Office365-Filtering-Correlation-Id: e8f481f9-293b-4536-91fe-08dd2ee6ae82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Pv79s9YkC175tewuxIcmTquvsClyDfwaik78eE+zTuQGwalBaN/Mv6JNSyyj?=
 =?us-ascii?Q?nkekfIcJ4VkBm+kX6s+bqUIu0cF2ZEOaWVZHk582oiq0Mbg4WeyORR2ihRAG?=
 =?us-ascii?Q?1xhREWNsP33k5CL77ffbtyYJe/k20JZlHBNiWzd1qpSEuXbCp/j16w2626OS?=
 =?us-ascii?Q?KPwmAWvUr4Yilxhhg/Uod+zu+JiR5QcEvN+ruwchPHVTSnhMcg66fvPs9zQF?=
 =?us-ascii?Q?pIZpw4qDZd82PsJDtBCkRd2qiHBC55rexvxko9NLsdgS8zXyLe1URrZN5KAB?=
 =?us-ascii?Q?gP0HhA1w6UN367gDakhXnAQCvb+pjvT5FBlsGRxtVedZGu93bRxs4SQY7xeu?=
 =?us-ascii?Q?Cs+BPaJEJgvAmmcuhm7FB4O1Pj85ZyVDUyzime1ybORk+z+uc9YW/iaDKFsz?=
 =?us-ascii?Q?nq6s6jwJp42s9UVdwKZti7jxiRTB6il+45m54aZ6RcSVEdkuvsJBt9jAWUvI?=
 =?us-ascii?Q?SAqAxpGVWNw79VJHRf4V8B78P+D/dgqRSowlf5KJI2TyPBCJhCZPXD5WVRx4?=
 =?us-ascii?Q?Lp7MkjZclnECXV6pKMVHpxq5s5fT2LQlRziofFbI7dSY9oyycR5e7wI5UTCk?=
 =?us-ascii?Q?suwzyIKLJlMIz23qcpPt9zS5zAGtjbWnWc0ounuYokig4dkVaxRXKd0H8T+5?=
 =?us-ascii?Q?vSKkCuglvlMtwIrVIeIW8KDMfjREkyQwMMUpvjBnv6sngM79OejvIcGpUhPk?=
 =?us-ascii?Q?TaZo/lsmA76WpnUjoaHuRmrx2IeU+ehoPDJW0P4iJCZaaQoFnuuzFNqMZczh?=
 =?us-ascii?Q?lVBUuRPTQ0qIoJyNLzbmN4AeQ/QZdw02gVJq0GlKx9MngXo2JZPlSGJf6AeF?=
 =?us-ascii?Q?E3X9qEp64W8b+4cEoLHBT9CKq6YEzttSGYvyodpH4jGp5gb2L5vTpRW76vjw?=
 =?us-ascii?Q?YLpAOFJiHFkkOtHAbazE4jmGMgOYJn+QTlhRgAy8IkYD1EHKnH0Yt4UWL/hH?=
 =?us-ascii?Q?GzP29ficulTxZoA1hTd6wWp5ssN50tSVLO6ThDsyxBl+4ZUqOBnL50awZ8oV?=
 =?us-ascii?Q?Mj1RwcfHBoMvQSHJASELpXhO0hCc5BBcKGt8Ap255OL/VX9+t6OpSLSPSqI5?=
 =?us-ascii?Q?AdK3mi1Kd6g4ap1W+kN3mW495vf0Q748sIHLIeKjwcm7h0boI33BI94nLo2l?=
 =?us-ascii?Q?UfQRe8U3c81cv9+v0rIra1am/X5NF8jlEVyApT/v+favClO4B2WvALTa7BEb?=
 =?us-ascii?Q?pmpvZFp8JzmccDAfGRNFEBJgxClHgxnLFKNDo7rXDK9PqRqJ3UXN0l8bnpfy?=
 =?us-ascii?Q?6cv7/juRjVN66mCRgnadpM2abqKrf9ymI+QXmIp6as+t73q7ywYYxVGl5V23?=
 =?us-ascii?Q?I0hDDDucPSgTkG+9wKYylkK+TSjqXuRR3SYqsw81OcIejKlvLvUt7PcchB9X?=
 =?us-ascii?Q?XGYsHJS49PrZ5zXFpjggeUl6OSMK?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cJJtpT8olwBFvN72kk6Xg4aM+wwkXuApCQEAHCNWzMHrcpdp7skft9YXgNIB?=
 =?us-ascii?Q?dNOHIn9b4/MaQhdvRTu6mdIJ1VWvXgEeVNeeznSM2t0PaXowQOy26Jp0jiFB?=
 =?us-ascii?Q?OJVafO6j9DfOhCaQ9j+TJipuX3wLSsUZ/CbYzxH29zsEvTPqBim5vi1Zo5Zu?=
 =?us-ascii?Q?CA/pNrsBtSCqdz3DXKQMbV2ag0ZBu+C/bp+Cg3q87D1cS1z17C2Sq+lkzrAX?=
 =?us-ascii?Q?iaLiV866Ew4B9sJ/TsSRHiNtulvKwseMzMoGIIp5mJlBn2a1tWlaVPPC3InS?=
 =?us-ascii?Q?cIymT3xetUxgRgWkRchJDPhBW70LlT4I/Qd+i3dLdWaqE/A2DnFUBPvXPjgM?=
 =?us-ascii?Q?0ju/QrSNvP07CWzTh0qoCO7a2fdVVTTsGGC4XdE2sa4rig/3x5ER5YBmnkvi?=
 =?us-ascii?Q?KCFCeBcRBNSoPWUHJrrS+N8tfvCPUGxI+NnDpMVreOCws1DnHm/nt/UWc87T?=
 =?us-ascii?Q?OfrjJKYyuCpdphH+ftUe+23S6LWkTf1xKh0U/CCqYKnzgFjvf5JhCswI+HIf?=
 =?us-ascii?Q?Mp4ixHl8wHQ+lFK9ZW2mPLtEIQbx3kmK9rUEnmj3iY9IVT09Bwyf4v4bDKCf?=
 =?us-ascii?Q?12CAGAI1s5oewkrknyIJ6kWhalr/5iq7jR1SDQLrjEJMJeQCvIUgMXCsSD5+?=
 =?us-ascii?Q?qhBAp+pG9zJLV2mzYr9GTlyqR/xqukAbTGb5NI9TBCn/gl8XjWsmRDo8Vafd?=
 =?us-ascii?Q?+MrVBeZcNO+AACLvaDvrGFPJozVHQ2RahOO5BUy6mBCdmNzLTWwGUKdVp644?=
 =?us-ascii?Q?ONou/GanmIVgBa0+xAzevceT86zPxlp6vgipzVQh8f67WgNhpUEwW5jOqOoZ?=
 =?us-ascii?Q?VhIlEdOCmqf3upVWDGV2Xdkpj7JYnp/6QvqpE9NRRvrVEMvDG1Fws3DHXrA2?=
 =?us-ascii?Q?PWLvNVL/VAi+r7xgKY3u1SlfsorkqGppDvJWeMSSbpiso04QTcjP2Qc/j/Zw?=
 =?us-ascii?Q?4mzQJ2WO48VIvolsvMbMXfZiG360nZuWHUek3UWGW4FnWyJBZy1IqkZMdhRk?=
 =?us-ascii?Q?YhXIeOnxZuq6uH+PmmdcYYFi2sex1IRiaXCo7p8rTAQ8kxjRKU/obEyPfriv?=
 =?us-ascii?Q?jBnKtmvmT55Wjtsc09KG0fZr8vJqAB1MiEOBui4gY+I5zrgvEM9yrldYJ2wt?=
 =?us-ascii?Q?kRdSVDzBB3Lrq9R6DfNKRvn/Z8V3HC5FV8Yi62KhCLnM/whKvS0y/bykXBU8?=
 =?us-ascii?Q?zbd0AR+CPP57rzdurBNDbk93RoxZoKQY+Vki2QWURIN5J7URCXrNd1TmieUA?=
 =?us-ascii?Q?sJDhhSb/IUP4wBuOLP4+L7m5saOy+XkGEkonqnZObw/7q2uzrK7qFqb8SYjY?=
 =?us-ascii?Q?GSy9Q1gOIyRkxGg3qjZrWxl7w3lfVD9WHB5C3U2DQbC7ZxArBqmMxAhTMjbB?=
 =?us-ascii?Q?cPDo4/fx0SegDhEA4X8bHXyC5YVcepj/yI0BFetUEhfArKQ2Mq590xSFFpet?=
 =?us-ascii?Q?GBkOHPITDLwcg+3RChpCT/ys77RXu2/53SUdAhzsfihwJdsJczk5vnE4YplR?=
 =?us-ascii?Q?ZaWKGgsmnlvVSX5FPqegUEDydPRkuWOEtzWiVr+SChCHuS2krdwk9awNIxXw?=
 =?us-ascii?Q?YL0IqkBM8fdGJgANZMv7jfEYI25hPWG5mlzduy12?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e8f481f9-293b-4536-91fe-08dd2ee6ae82
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 06:44:06.2479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Apab7quSn9NXGAY5c8xUY/QfqHJPPL+uxN4R19AuTVD0GkI54YxnWGGc0A86jPJVyZLvhehDf1b7q8+ubEMbSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7596
X-OriginatorOrg: intel.com

New diffs and changelog:
SEAMCALL RFC:
    - For tdh_mem_page_remove()
      a) Use struct tdx_td instead of raw TDR u64
      b) Change "u64 level" to "int tdx_level".
      c) Change "u64 gpa" to "gfn_t gfn". (Reinette)
      d) Use union tdx_sept_gpa_mapping_info to initialize args.rcx. (Reinette)
      e) Use extended_err1/2 instead of rcx/rdx for output.
    - For tdh_phymem_page_wbinvd_hkid()
      a) Use "struct page *" instead of raw hpa.
      b) Change "u64 hkid" to "u16 hkid" (Reinette)


diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 980daa142e92..be0fc55186a8 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -168,8 +168,11 @@ u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
 u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
 u64 tdh_mem_track(struct tdx_td *td);
+u64 tdh_mem_page_remove(struct tdx_td *td, gfn_t gfn, int tdx_level,
+                       u64 *extended_err1, u64 *extended_err2);
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
+u64 tdh_phymem_page_wbinvd_hkid(struct page *page, u16 hkid);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 120a415c1d7a..b4e4cfce3475 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1862,6 +1862,25 @@ u64 tdh_mem_track(struct tdx_td *td)
 }
 EXPORT_SYMBOL_GPL(tdh_mem_track);
 
+u64 tdh_mem_page_remove(struct tdx_td *td, gfn_t gfn, int tdx_level,
+                       u64 *extended_err1, u64 *extended_err2)
+{
+       union tdx_sept_gpa_mapping_info gpa_info = { .level = tdx_level, .gfn = gfn, };
+       struct tdx_module_args args = {
+               .rcx = gpa_info.full,
+               .rdx = tdx_tdr_pa(td),
+       };
+       u64 ret;
+
+       ret = seamcall_ret(TDH_MEM_PAGE_REMOVE, &args);
+
+       *extended_err1 = args.rcx;
+       *extended_err2 = args.rdx;
+
+       return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_page_remove);
+
 u64 tdh_phymem_cache_wb(bool resume)
 {
        struct tdx_module_args args = {
@@ -1882,3 +1901,12 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
 
+u64 tdh_phymem_page_wbinvd_hkid(struct page *page, u16 hkid)
+{
+       struct tdx_module_args args = {};
+
+       args.rcx = page_to_phys(page) | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
+
+       return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 24e32c838926..4de17d9c2e8c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -35,6 +35,7 @@
 #define TDH_PHYMEM_PAGE_RDMD           24
 #define TDH_VP_RD                      26
 #define TDH_PHYMEM_PAGE_RECLAIM                28
+#define TDH_MEM_PAGE_REMOVE            29
 #define TDH_SYS_KEY_CONFIG             31
 #define TDH_SYS_INIT                   33
 #define TDH_SYS_RD                     34


