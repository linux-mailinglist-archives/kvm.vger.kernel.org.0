Return-Path: <kvm+bounces-25420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1655E9653ED
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 02:13:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB80C284928
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 00:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516212599;
	Fri, 30 Aug 2024 00:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FBgzdfuv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC9B182;
	Fri, 30 Aug 2024 00:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976814; cv=fail; b=B9kkdJouBgB4AyzhUFLeOqmaAQPg1Dczq9mLLx63iB4Ayw2H/+mBy0o58eOBKRObqzWK/Ta/JycCGHusHltJLPA1mqaUPwzdZYq3SK1UkQDPGeSH5nGC6rRcxqHl9HL2a8qyU91P6tQR2gkZwFPS4Xy+KI9dX/PnRUyIUb/iIQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976814; c=relaxed/simple;
	bh=Vr+QV/r5J4OYgasv1rk1ObGkdiwQM7in9OAFomn1MKk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=brWm76KGkjsr0B24jtKmB0aAFdO78mGmBm2td2BLSXnA2xTG1Aycd6GSBa9YRmCc0raFochHb/y2ODEAILnwCgQB+ysmOh4Cv3kCfuwW2gQWQ1y7wyAqXu+Bm+s3Fme2VNF47nGYURVEwCm6aKFEVqb3GV0zPqV188sH/xosMNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FBgzdfuv; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724976813; x=1756512813;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Vr+QV/r5J4OYgasv1rk1ObGkdiwQM7in9OAFomn1MKk=;
  b=FBgzdfuvA8RRW6X2JzBkyajS+FRT0+Fj4tZPhPzuygS1j3Pc3cEH3kOg
   CNNru/fIyu9sggfEhC4forjGXduBYhEApyRU2zLB8YzJuhDxGbDOTQIVo
   ahVEjReSpCzlevTyhZWWfKDrmDHznCbx6eyzT03Y8TPQCMJ2wS4MstTAm
   P5ur1dFtpnn4Ie2aOpq7FYnK5vY6U7NVn5q1QAJq1kU6sbvQH3HJaI1br
   j3PfWXKmF3ulUJM/srjoP1daddLsUAcfrVmmRj7F1bFsBxrcs4P2i3aIm
   w22fBz5UJUlTVSLjeKBzPUhyhCB6hHVr/IkBMYT6sXRSEsAgPZfrun0hC
   A==;
X-CSE-ConnectionGUID: ZLVX/+7OR5i66paxvEATRw==
X-CSE-MsgGUID: N8qStUsuQNO8c2fSIfklNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="27485338"
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="27485338"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 17:13:32 -0700
X-CSE-ConnectionGUID: Dzl2W6NLSoi1WqFiCJ6sqg==
X-CSE-MsgGUID: 7Pe6vAH1RPaiJMx7lo10/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="64242331"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Aug 2024 17:13:32 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 17:13:31 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 17:13:31 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 29 Aug 2024 17:13:30 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 29 Aug 2024 17:13:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ccvf0EoczaLTs+1VaoFYjJFMCJwfzINieok+QZLm6eIsxbBYnRPSQHnJBKBUSmTZUppE0nt3Xc7z2s9avYDgILNOv1OI5vkmNYtXUOYdCzGR5WebJ6YzCR92DQcJ5d04DWXel1sv4hZ1ymgDaim5g2PeYNuEp0cQs+HI1KmzlSwKXGokTC8m4324gB6M94K0E96bhFtyZN4sNv9XBI9ybAE6qHqUXJacrGnPp0qpLhBbnQNaKWOUXIuACd1oZbewjsPy9PW9DhvTLjQBjB52lgF+CYx+bChN+V5j5WXgzlu98SPRj+a4D2frawBBBbcdGgW7sJKbkps26iFvkPuP8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vr+QV/r5J4OYgasv1rk1ObGkdiwQM7in9OAFomn1MKk=;
 b=THJaXk+3zfIxV6AU9DucbGclsO/qw4PKjbIqWoE/0hCc/2c5uYwzjqIduA1H6hUMtDesck7ufF75u2IG2CcGhZqLxUNu1N1knqh67Crl+NCY+7NbzCU6XtLKx7CDN6Bsvkmnl5kTXk2pPIlDNfNSn4APqTzOLfy67GiAMJCT7kXOC3J/1Ym70POGTX9hewjNbuIPI2RGurNTFE8eMc+m8dkLihAYyvwW7pgNV0WxVbq3tVfOPg3mkjWvYTmeuzx5g5FOYt5IjJbH/S55EKi1grVSiT4d/msJ8qfMAALnB7lUmcWJnAX5qzoY4FiFaCsHLiALl/xLqto8OrsVAH0XjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS7PR11MB7908.namprd11.prod.outlook.com (2603:10b6:8:ea::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.28; Fri, 30 Aug 2024 00:13:28 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%7]) with mapi id 15.20.7897.021; Fri, 30 Aug 2024
 00:13:28 +0000
Date: Thu, 29 Aug 2024 17:13:24 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: Re: [RFC PATCH 01/21] tsm-report: Rename module to reflect what it
 does
Message-ID: <66d10ea4d5fce_31daf29416@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-2-aik@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-2-aik@amd.com>
X-ClientProxiedBy: MW4PR04CA0337.namprd04.prod.outlook.com
 (2603:10b6:303:8a::12) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS7PR11MB7908:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bce1810-0437-468d-ba27-08dcc8889287
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?enzoZAhfee8cXROIKbAu4tuYZAlW+nC1CwN/Y9rHpXmpT0/QqWiDo14LUBt8?=
 =?us-ascii?Q?CG0pVrgq74ad5kJbOmnzoOJl9iHktLSF3hTDvv9Sq/ChC6WmOFqFLPNNfbL+?=
 =?us-ascii?Q?+GAc3MeiGw/0lzTpZR1/wl0gLCR+diENxHH1LqngSa0Uq+5SLnXunTgn++mN?=
 =?us-ascii?Q?JsMN3orPx9pIrZEkXIktZP5XEaCbD1y8f/nEfc0cjV4QpPFsfUEKLwgnx/Ni?=
 =?us-ascii?Q?ks+jeW1AaqnhWjb9YnALLwK1Y9rTqj/5crXdouBjSGPwUoTwpHKCBAk+nWMZ?=
 =?us-ascii?Q?Sg98NWcdQK5imxOVbcX0ZrSOLbMKETAaE2z96sm2MyWWrHCqe65ZhFmY+fia?=
 =?us-ascii?Q?0h8OvSqvzZyX3c30hdYLuLGQ4vHIsmdz86KbPpAn4HCGYULv2Tftlg9hWcts?=
 =?us-ascii?Q?yxmvO9Iag3372DB0qIc+30dkQ4GApU3dRMOjPejHo2kzPYF0bFU44ajGjMZE?=
 =?us-ascii?Q?/iCjwYwN27LEr1H6bsR+Yh/5xfIrsoiijObuwWF7MLoqiRw3Z29kV6FJ3w6e?=
 =?us-ascii?Q?HoC8/xyM7NhwE1O1YlwddRFqE7VWEwDj+iJAx8+/wYKL/lRBQnAtlsZx8H0v?=
 =?us-ascii?Q?kNhJ1PLDEwN8xQOodef+eysu+zrC+iEXz4ee1vL/1AdZoXg2S4wb1t6Xd4VT?=
 =?us-ascii?Q?oyCw8FJQySXUK8rexcsSsJsDN/Fx11FtsDamYHn5yTO0Af862ePpe2IVlNSE?=
 =?us-ascii?Q?Wg+fZ1L9w8Cwv/kMCeUmRG/+r0z/F2wHlFlP2yNM5MrUlgqNN9MklGLwiWf8?=
 =?us-ascii?Q?Y3Hltxg4OMYk5l1otCNd/MgYcgjRs285B5wlfZsf6V1sX7mNwOn88C1+Oy/t?=
 =?us-ascii?Q?8MswTNj2RJdolydvFVYOoWV2yxa6Me1bQevNJZC3/DTo6hNwMl5p/cNyheNM?=
 =?us-ascii?Q?DkUB/xyH+dVfJNy4yo9KG457k2nPCoRatt9fqAP3nsvAIMd5gf1M8J0MZCob?=
 =?us-ascii?Q?YJ6d12wgbn1CDm4EGoiohWlXosI5W/s2kXC7ftetwpD3l9mz5pqcLy3lBg3B?=
 =?us-ascii?Q?lVMTkmYZiDknPBZruH66xgPjb2BYZFnPfjhEipuQ76TECxugqQhnG7YJfEEd?=
 =?us-ascii?Q?/uTzLWmWz2AxnRhcW4mUnLOGo51z8KOpuU5Yp2DxVU0V1gNJz1vsHZHCEwXI?=
 =?us-ascii?Q?byzHupdQYg2fYpc0v6Nhyl1i93VJZk4j62ifPzd5eJSVsiJxVCLhREpj1r3p?=
 =?us-ascii?Q?atp3hESrrM4iogmLvzIXUQpqVnYsihH7SYXdnYmTurFJhtSkL9SEtS2eUHUz?=
 =?us-ascii?Q?kQ11PIXBgSDUFca0O9oll9AQrVi1P5EUcoJnqGGR6UOoYK1iKyx7DjaikwCH?=
 =?us-ascii?Q?+G1JFeGghIJB/y4n3KKbIDRsS5cx/sQ1i7Hy5ZeZKFRJW8IfMXwYxDuJ+TWG?=
 =?us-ascii?Q?Xjv/1CA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PAXT5Bt6jSAh4Ooym6UU5UXqKERFJyUmTcr5Lzk05xVIrDER7RbwK3CCN9YA?=
 =?us-ascii?Q?iQzXAv4WfdofMTb+RhRZ4T1UDAAf2BqV73Xb0xLG0X2KRgFWa3ZmZQCUAyt7?=
 =?us-ascii?Q?aLZpyLOf/pGEYlCuUrqDYxTPtTm13u75wluqcwcp9KBo29k8tCWpl8KxzdEF?=
 =?us-ascii?Q?l2nWsqi8tQxWBwERORbwKL1tJw9MhbHMWM7E7WpDvtsiGC2PLV0rbgaif1mS?=
 =?us-ascii?Q?+cyGeleS846bcW7kzJqN428jnQCvdjOm8VVTwnZBEcD46xq7BQzAhYtXyKDS?=
 =?us-ascii?Q?L6lE0HsxtIg3OEM3sItZkba9Rtk+Lxe7DYiPOBL/l+VoWla1PzcHkSueiUhT?=
 =?us-ascii?Q?/C9j9ohZTjrt8rrpoefmAGhpMxfrDjDqTlinaSXU5Ggh9hKRNaP8VpimomgE?=
 =?us-ascii?Q?YPC5VzU/LvknIi0K2HyT2nGpCC7S/wsaWjjK4QJeX/kF3ZXZCI3TBgtSfuLP?=
 =?us-ascii?Q?aQ8xO3P2AZg2cYnq4nBUXqUleRu25kUiKzOu0qwTHYztBlVlpv8jMNpnIAck?=
 =?us-ascii?Q?oF8OQNVdSfgCwzmRzk7nkmdNYHtEvLOwqqWATvl2lklBXk50T7R7CJYThuRn?=
 =?us-ascii?Q?zC9SZaByENkUeZEGehYhmLJfwRZTv2PB1UxelXOZ24tefa6vduK0RpUWDYJ8?=
 =?us-ascii?Q?/JDWekZcMLDcHMqowbBnDhc+Tr2eQnjfx8m8hhheUgXpzk+B+03UwXA6uaHA?=
 =?us-ascii?Q?fujS1nu7bXOTy3LpRk1SUJUmhuWa8PsMdAidpMxdbgo55vCqO/PygO5OzPMi?=
 =?us-ascii?Q?tc+/KqPCV0WsKlvrCBObyCEsZ4M8pQqQUWj9J+/64q0hM+5gZch77Dz0cjJQ?=
 =?us-ascii?Q?/uvh84OBUDXvw/AkU9gsac1pNXfIpJRDxaa681O/3Ok7QDn72KHmFBryPH4M?=
 =?us-ascii?Q?F+pj5JfjBt4+6w3RBfAQ1rHvm+u2A0SwLjF5IVbhVpeI7Evmut7hhMjqrwdl?=
 =?us-ascii?Q?3ycYmdYZSjPnvaREzqr50im7ui0+OQctycrxVYgB5gsAQCuRHYmGx1BSv38X?=
 =?us-ascii?Q?FV6FhLXqUJNA0CtQxiaNH5yRvV9Fg4w3Q3WTTxzbs5mjJhcnSTWKb/xUxFpH?=
 =?us-ascii?Q?iJZITgqCNL0c/3PJ5zE9QMagBrJom69qSmeFM29Sp9/uO11Toc1rct7p0qSU?=
 =?us-ascii?Q?H1tHozKuSxR3D57DvvaUDHb2Ir7L8Z5jjTLi96sGV7sbSyhMmjt3yeHn0tH/?=
 =?us-ascii?Q?a0aiS6kySi1lALcIrr2Ts5eR5TWzEqZ/nvGew0FlUdYNzAI8Yh+/DGChUeDS?=
 =?us-ascii?Q?ItqtiRuOB753BYNrGZbOsaU8zRnADtGstUbIP36OzLUdwX99mv1dJ8AvFlw+?=
 =?us-ascii?Q?cyQ3I+99pcOf6Vi4gsOhUveHedGoJR7QhynmWhlq2UZ7D4+hV0NSWIvCWXI7?=
 =?us-ascii?Q?X0+gez7dSp4etCdJSsxRaIWL7nZehEihPuBZJTZHvZlvHTeBI7ke/ZCq4WlG?=
 =?us-ascii?Q?Ep3jS5qtP6N0Ym/V0PWddeW6jg8AV/Bcikka5dnrKWok3E45ekagxx6dFtW8?=
 =?us-ascii?Q?/ws2PtPVRs08n0PVAVrrmAdDyrd4SLGR7AoRjWpkJI1r/pA8s0rzpR+m8Zc/?=
 =?us-ascii?Q?9+UBnnFNmuSjbDPlma+O8LIMaIBFMdhwPIIqZ7De5u8BpGNFamd7d+I+iM/T?=
 =?us-ascii?Q?Nw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bce1810-0437-468d-ba27-08dcc8889287
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:13:28.0480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rjRlA+sZ+489I2P936ZRRsML5o0ksQOI1ekzCZGyS9lZ66q8XwtAR+WOpPkIsCQ8od+4HxjL/xNHsuW4KvcxLnBYQrjGBJaip0aVeBOEFsE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7908
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
> And release the name for TSM to be used for TDISP-associated code.

I had a more comprehensive rename in mind so that grepping is a bit more
reliable between tsm_report_ and tsm_ symbol names. I am still looking
to send that series out, but for now here is that rename commit:

https://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux.git/commit/?id=5174e044d64f

...and here is an additional fixup to prep for drivers/virt/coco/
containing both host and guest common code:

https://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux.git/commit/?id=68fb296b36f2

