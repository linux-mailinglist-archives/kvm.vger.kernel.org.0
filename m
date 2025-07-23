Return-Path: <kvm+bounces-53180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 309FAB0EA8C
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 08:24:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78C9C189372D
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 06:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C53826B96A;
	Wed, 23 Jul 2025 06:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="alktdscW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1C7185E4A;
	Wed, 23 Jul 2025 06:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753251884; cv=fail; b=g56OgAfyf/wXnbxMPgWm2DHWQmtBUo94xo7a2UVjmKC1HyatdvY5fsKGLk3PGqYk0g85QqQijaPbY2CYQWlF7vYFK3YuJKe+8Y6P628rFOCja/3ytHuAWR9kI+UbNvBgdnYo5Er1wGfNpXFO7v1z52yM5GSYeVpADUCv4VgrZc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753251884; c=relaxed/simple;
	bh=fcnga54aH7yXeSB5UGrDiS9o77AQlFZlhAGqYR8GOFg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DksGApsg06si5NKHrvZ0ATVd/pL6BMLTf/2x3Adf1GRmkNzNocfso6F7SzpBnx5POlGy+Wu3BhyreobSXdoEcAQPb1o5OaKfUaoCDjQvpuedttXPG/Cy0yLIdn4NnO0bes7n0u8N4dEP6Dn5JkPJvrhXiwR9/dyCMSMyVXyR1E8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=alktdscW; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753251883; x=1784787883;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fcnga54aH7yXeSB5UGrDiS9o77AQlFZlhAGqYR8GOFg=;
  b=alktdscWa136al8uacAQR3uK8aAuzJ0hmXorVbj/aruwfuCtCcdvb91n
   ZsN9ESgRCxtiRGeCAoeu6kKWxwHliok1hKLtx6QOgC6je1fQLOeH3dQIk
   HUS0maOukBnLxiWYVIIvqvtldh2HuqQW0OxY4OCqVOQ1zXVlrcP8vFdKI
   HP1FsktnIdAvYoIAZnhxgRLJnaGuvgeT7nlxJALzFneBkm7IkgRXEBFoI
   FycjYT4AHcS2iAsNlNbXFgTRjFz+khGinIMfk4ZZfPzEhcohPxrcZJhKi
   IlsbVwfJ4/5KhuizYXWnsrmEQE3iJSbeEUix3FJ0QNiQ6DHoiuzbbQWwf
   g==;
X-CSE-ConnectionGUID: Gc+hybCyQRC8tt/B5ZHkbw==
X-CSE-MsgGUID: DDyVXHEFSgqjDHhsZkMRhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="55371026"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55371026"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 23:24:42 -0700
X-CSE-ConnectionGUID: mIiIDHoqQzWaN5R1bGHyag==
X-CSE-MsgGUID: 5fJU1IHWSC2+vglkLyX31Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="163387865"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 23:24:41 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 23:24:35 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 22 Jul 2025 23:24:35 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.73)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 22 Jul 2025 23:24:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PXtldG94BVv3OsQ90qG4iAFIWAZGyXu7PGPncXWhz6FXATaSIInNwKvHs6MHq3NqizVYgZwhHtncGCGcaGijtpB7SgTZ+IkOo1E4i4pEwD5hdAhAvR/OgI4v1OIGkTRYmjUxRqxV6q9OGUmgBKbnlz5jqdgQOxmsBAm6L+RgiZDHGNGiQvA43gUqCxODQ7eUt/EPPcyDowfwbP4ldd7TCWSUoku3fFQLTZ7DzVe9285s+i+uZfTgmrrm/7Co+u8qUAX+p0DpBXcQKf4cDQQWddPdczrnr5Ckz4OW/hNYsm1x92U8AtCYxRSj2/Ni2pGaNqUnagCYIMM9S+f6Hc8JzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFwD1mbWye+YpnhfU3XdApCUaTOK6On4hEOaPdntWRU=;
 b=EMEjFQC8cqce9J4+hxBC0Azh8lUFxNTGhCJBD8i5cXNfaiHIIR1XE9U0VA3HXAQyCSe6L1QifSL6Pg3gPjibYwRvulVf2bS7Gv5vQHcPUB+36pFztvyyxAG0VKACtkY6B/5NqY0eAjL2f2Cpax8hIvIQQuzS4PIcVNDl6Wuvs1y2y5hLiv0/nBHzGoDw99BcuK4D7QhRXQjXS07MbAxf6vKPtM7WuFBGz5LC6XtsDGrHqmb5HsTve8HFOXCZnWkiDVYVHSo+NwjwDR9aD4ztqvM657PMf68NzpVRuM+/a0gisTEr9/KbkQivwYACQk4lPyN8K9SqUVazRRQLqxZgfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB8524.namprd11.prod.outlook.com (2603:10b6:806:3a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 06:24:29 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 06:24:29 +0000
Date: Wed, 23 Jul 2025 14:24:17 +0800
From: Chao Gao <chao.gao@intel.com>
To: Mathias Krause <minipli@grsecurity.net>
CC: Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <pbonzini@redhat.com>,
	<dave.hansen@intel.com>, <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<john.allen@amd.com>, <weijiang.yang@intel.com>, <xin@zytor.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2] KVM: VMX: Make CR4.CET a guest owned bit
Message-ID: <aICAEVrblWxL9cv5@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <20250704085027.182163-20-chao.gao@intel.com>
 <4114d399-8649-41de-97bf-3b63f29ec7e8@grsecurity.net>
 <aH58w_wHx3Crklp4@google.com>
 <96a0a8b2-3ebd-466c-9c6e-8ba63cd4e2e3@grsecurity.net>
 <20250722212505.15315-1-minipli@grsecurity.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250722212505.15315-1-minipli@grsecurity.net>
X-ClientProxiedBy: SI2PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:196::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB8524:EE_
X-MS-Office365-Filtering-Correlation-Id: 9856934f-da2b-4366-3899-08ddc9b1943d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?J0KkKkJBiP7HTvlvmgqwhD9Ha2o2tVnwDq5H0/MMT/kcIhu+XExsnUWuH1zh?=
 =?us-ascii?Q?WMfs5kVMN/rC7CtPHs7J3/OA5N6AKatHD+LqMFk0xIa16WgyzWsdzCPI8gSw?=
 =?us-ascii?Q?84y5IGbqHhQT/UGooHvM2mZQ6AgcWrvuVMcXO4Hty7VnDgyukH5JElHe4uTA?=
 =?us-ascii?Q?QSGgXNRGhp0GiK9isegxZ90kp7fjg6LVOK57zC9NXFh/CMdGWx80n/ZNmwZk?=
 =?us-ascii?Q?mkTAQYd/mkXpzkurz2GtW0hzAuHDOqy3OW79f4YHfhpw/j5dSBCqGgmiFTOG?=
 =?us-ascii?Q?EU5gOWnSezb6nsDxdY7LZxmiLzPFPN1iusfzn571vKxTFVCxW3+JJb/80krH?=
 =?us-ascii?Q?yPjbZodEdxHw0mxWJDBLpzaEW8vZdb9DKBMXeKIEKtQCjC2tHxuHe9V305nU?=
 =?us-ascii?Q?qBLAZDP1Owg9Bi2q3OD5Xb3ylJxn38TCTYN2u9HyIoDa34Gz53M9rsjCcUhT?=
 =?us-ascii?Q?1j3sOY7M7AbEsj0piR3mO37gCLTD528dYOqVoaKRDEaA6FZ5ZZXuNi2JUvjs?=
 =?us-ascii?Q?QHo7rOFqlXYrhKEMV+rQcJ5TXWPbjVR08uy1Dzvej5jfM3l4UVobTJWnDEUW?=
 =?us-ascii?Q?DSDFvgR4cZ3RHE/LFFQiIbsJkD2RId68wbDr4pM1kqnwADB6RdodO27t1+/X?=
 =?us-ascii?Q?AcdEds9mEHEZIT3SV/iWJDR3vLM7dAINB3fdEspqV38WZPeY2cOkCxTrQ3N/?=
 =?us-ascii?Q?gCTkOkizZqd5puw40vepzy8I/MicxsuLneeZRzUqnnw7RBGjFVeHRa3LhuPW?=
 =?us-ascii?Q?bUwKzRzsbXQyYMBji6xiPPFa7R/FnABVCouh93Bq+MXh9EPH26mzy04I+XFx?=
 =?us-ascii?Q?xCfcAZzceJshQe61VpovkucPGyOhECnu81NCx7obYHAXfc6q8XwvFALP7Q7E?=
 =?us-ascii?Q?1P+PFo/Xv1NOjnh3f6k3bQVs/HQH6AN1JXnUZ3rIvuOScxPYfeW1Gk5KViUr?=
 =?us-ascii?Q?wOhuw+fpDYgCYKwPGx8VPwAGfKBvo/esXpgWepnztOSMPQUsMwNb2Yqdg+Gz?=
 =?us-ascii?Q?Ud2ZdNUOF6MjOtCQJNSh/b/QCb8c9+Sz/zc44cO4XJGbQyC83pYGkYEYRewz?=
 =?us-ascii?Q?QsZoulDoRmW5OMMOlFJXnRX/RYRLnQA1vigyozv/WVBibPSpKt/GFhKH8O0C?=
 =?us-ascii?Q?l6x3QJgVB7bhHciETYJ9UD05jOc8i0uw3blTPkcM6kylVEMw9QAdEIJGJcFq?=
 =?us-ascii?Q?Ci2w9XBYbSNowTW2yrf8BavZYLpvVtF7SwBu1mOsWCBVq3d+HjhcBH9jitTK?=
 =?us-ascii?Q?o1Lg3brlFnW+ECq2BMG/eoOppDIQYDQU+nzK5m3C7EIpXA6Q0D+1YBl1vArx?=
 =?us-ascii?Q?di5P+3abc/3TwV+A7LDaoLJPaJ4TBAL2DyyI3PRsDHu4cI0s3Dco4cmR33dy?=
 =?us-ascii?Q?aWDZ05qCahWPphbxFUAr/uGxHgyUvi0qIZucigyXsuV03qeFYNLHaQobKieQ?=
 =?us-ascii?Q?MUc7m4+eNX0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QYBk1vRyQdrjA/YA8mO+DQac38U0WVp1s6aCcnKfVt0AYN9baZju3Xvf+7ih?=
 =?us-ascii?Q?WCz1zyuQ5WHuqvUrN7LwZKU1qOZlySTglxaFZVgufaOUrgSYob1Oh+ii7Q0h?=
 =?us-ascii?Q?hwWo9OQVQdAhNzNPyPPmTLGqayvD5MgP0m88aYPS/UP969HPLrywxthDwCtp?=
 =?us-ascii?Q?66CHiVsi6TBhhMks5PVfaJNgVmlrlrPzNpy9dctUN44NoghRYku5cLoHZrsS?=
 =?us-ascii?Q?6CWEstzX05wZ308/dOUsVZwYs2Ikteq0OI5iE06VIX8h1a0GS+MqUZdnr34Y?=
 =?us-ascii?Q?fawt9Cph9GzENNjI7U0wU29/r/hK/2ULQ3eTCyaDdrH2VXbw9NEaFwRzTLOE?=
 =?us-ascii?Q?paIaVBe3NgC+JxOaoC13HjawV+U4wCra7ZZppVEKa0psmgQ4rK+DUPJUBaQ0?=
 =?us-ascii?Q?Sf4ju2hVhUrPRuRv9NeXGFNpiRsHDbKypFBsnldxoEUNnaE7XFllm8SbGFLR?=
 =?us-ascii?Q?wcXGGWz2Wf8I1JBPiGeCIc89C4mzya7FG+SfE9CqVkwyMJQurRE12nXc1/2C?=
 =?us-ascii?Q?avGZFhR6pBpcRsHDYuvHSba3nTcS2CCsH3MNNS9Wl8df4JJMGrPahfPzDSvC?=
 =?us-ascii?Q?zPebU6Csh+51Mv2aIarwIpYjC5FnWO2Mh3VNINKGs8H9KQSfkVvMdZIaBdwD?=
 =?us-ascii?Q?AsW6G1VUPPs8qfUhHWsXdYxKOjNTu/I1Lg6Y897kKFuZ3dRof2/zFJGyqZhW?=
 =?us-ascii?Q?lfEIGsYocOjv6iFa95woX0UWhLojZrisDm8dT1Hkr1RIsz0TzzOx/UuTk/O0?=
 =?us-ascii?Q?+m0liF4QgdKDnmVJT6cdci+o0RfFZZKEONa7uDtQ4H0VxO2jeevx97j8Rt3u?=
 =?us-ascii?Q?FyqcIYzXvVHi4YyRUgkfhBLKk8p+rcWMjPhFpwsXfinxHJP+ykz9HfqJEuKZ?=
 =?us-ascii?Q?YS3+JSWDpOQhwaFD1K7ndqe7/tAKRmVseun0ELSUi7l0j667ZaLQuGwTFCAq?=
 =?us-ascii?Q?pL4UgbJi45AQXDLhYgu5l0LkPGqkBA0FbnKGb155RJ6/w8WZ5MFZJfsWbxQI?=
 =?us-ascii?Q?WF3tb5yBX221lwsnyF8XQmOpTSW3+bIutCLQNEmDNk9rj/cF0yxp4B+jsZI4?=
 =?us-ascii?Q?XlutNO8vGgsA9n9L87n13LV4d1NjDFbAuuF6HvHNU1BNzLZjPyUXwdHJhrTu?=
 =?us-ascii?Q?t4fRgV6oCvVIM6/TXovT3JV3M6y1Whb5eyo6YhS/1GspGvHfrFoHhMqFRFB1?=
 =?us-ascii?Q?KR9QrcrNACPhmAaQ+Ci/HCYh8V+7pPNR1XACq2N9i6+VMoSj9jT3rj/DEGqg?=
 =?us-ascii?Q?cfaXQkH6ZQUQjucGsebsfyUmFP/IprOXgIXlnIk7RXgeTbubIKt70T8mAS0s?=
 =?us-ascii?Q?dnnXBlEFD7QwvRax56XZVNa5r8Cr8PQz3eoYPxCy41QhyMcSR7mQDeqEvyVt?=
 =?us-ascii?Q?WqdiFEgRta1PeblxrP/d9bnYVyjbZq7YSrDFVxcX94ZfRKu7nGjKJRYlWJ4c?=
 =?us-ascii?Q?2iYve1aN2hT7lksECJ/99JIK5gCG5DZpP2JA8UWrL9vHv+icAKvR09gN2Z5i?=
 =?us-ascii?Q?WOJ22VRUJ9hEVb+Q2dwVnl7BkxGfsvMVJ8vEdTdMu8/DlWex4db/f1vdUnrN?=
 =?us-ascii?Q?fB50cBbrnxKVu2IrESDFx6BxsptjfjGghBXn5sO9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9856934f-da2b-4366-3899-08ddc9b1943d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 06:24:29.2759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v68Oivcn3ERFsMxZnwIcsfUTtDB38A5Ce0mA1LGVbCRm6c5ooICr7p/7acUkGK6uj9sEkljm9chGDrGNC7vUbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8524
X-OriginatorOrg: intel.com


It is recommended to first state what a patch does before providing
the background and motivation. See

https://docs.kernel.org/process/maintainer-kvm-x86.html#changelog

>There's no need to intercept changes to CR4.CET, as it's neither
>included in KVM's MMU role bits, nor does KVM specifically care about
>the actual value of a (nested) guest's CR4.CET value, beside for
>enforcing architectural constraints, i.e. make sure that CR0.WP=1 if
>CR4.CET=1.
>
>Intercepting writes to CR4.CET is particularly bad for grsecurity
>kernels with KERNEXEC or, even worse, KERNSEAL enabled. These features
>heavily make use of read-only kernel objects and use a cpu-local CR0.WP
>toggle to override it, when needed. Under a CET-enabled kernel, this
>also requires toggling CR4.CET, hence the motivation to make it
>guest-owned.
>
>Using the old test from [1] gives the following runtime numbers (perf
>stat -r 5 ssdd 10 50000):
>
>* grsec guest on linux-6.16-rc5 + cet patches:
>  2.4647 +- 0.0706 seconds time elapsed  ( +-  2.86% )
>
>* grsec guest on linux-6.16-rc5 + cet patches + CR4.CET guest-owned:
>  1.5648 +- 0.0240 seconds time elapsed  ( +-  1.53% )
>
>Not only makes not intercepting CR4.CET the test run ~35% faster, it's
>also more stable, less fluctuation due to less VMEXITs, I believe.
>
>Therefore, make CR4.CET a guest-owned bit where possible.
>
>This change is VMX-specific, as SVM has no such fine-grained control
>register intercept control.

Ah, that's why the shortlog is "KVM: VMX". I was wondering why the shortlog
specifically mentions VMX while the patch actually touches x86 common code.

>
>If KVM's assumptions regarding MMU role handling wrt. a guest's CR4.CET
>value ever change, the BUILD_BUG_ON()s related to KVM_MMU_CR4_ROLE_BITS
>and KVM_POSSIBLE_CR4_GUEST_BITS will catch that early.
>
>Link: https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/ [1]
>Signed-off-by: Mathias Krause <minipli@grsecurity.net>

The patch looks good. So,

Reviewed-by: Chao Gao <chao.gao@intel.com>

