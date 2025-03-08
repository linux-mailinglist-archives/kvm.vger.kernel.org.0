Return-Path: <kvm+bounces-40473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BD34A577CA
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 04:01:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FEE3174278
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 03:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA4714B086;
	Sat,  8 Mar 2025 03:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D3YUyGtw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDAD182CD;
	Sat,  8 Mar 2025 03:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741402888; cv=fail; b=MoO4LW9Cx5Wi+BDPlUSavnOLp8X6yLMelaPg9FaiHOMvVDU0+cFJnYyQmFXxoZMVPGRBTTIfV2wj2ytXFfNLjKUU4ff0tkOsNDe1ChhQ3agZPCckHbFKjjjujutM1xc59F+Qk0zqBgDhO99PkATQhd/Aq1kFa9+ylnJNkHSsdww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741402888; c=relaxed/simple;
	bh=97nWLqGaJloVUyrqtO5pap5Hsi30SR/CFLxh+A4uJ6g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PzrtSbn/IIaYeFmZMhPHS67jspg8X7PfWTrwjsv8lzqT7HDfutcCvsSnGRtvYwtplrT7LFkcaci/PsisVZ6UkndBBwxzZ2zCD+CYzkOpRoUM4mDj/bZn9aKhCiBJYgrk7qrQ37IMWe4acBV9F3zb45ILqzD6p6lRxS71CvieJCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D3YUyGtw; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741402886; x=1772938886;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=97nWLqGaJloVUyrqtO5pap5Hsi30SR/CFLxh+A4uJ6g=;
  b=D3YUyGtwIpE4DiS3ZleVETXDdDppsmoc71LF5vA8HQCqJpJUIh5WDKLh
   MDI10KExEcFAx+aecrbB8GKgbPKmVYenHM5TC9IAqpMaWZ2+c0wPyoi1C
   qYNsDgsKfJNrHCZFlNRvqQBakKya49S6janFNFZl3ASG+Wa7ICjQVGn+j
   SlyubdjnaiOcIwL8rzQWjMLNErev0D80KnRngObxtwTH+GrHWpAubUO3p
   D70tUtdaIok0lHU+Cq4GUaUDxuFHUioQ9fbYAQwBPVxafN4QjSQMJxRVA
   fwOFrw2gyz8st4DomCrQoPJOlB0mrMVoMUw2TEvHHbrFLJMjvIPkHdKU1
   g==;
X-CSE-ConnectionGUID: 3LO0v9M0RPaREflJKYuH/Q==
X-CSE-MsgGUID: 6GUGxgHfQj6+V1AYQhPaxw==
X-IronPort-AV: E=McAfee;i="6700,10204,11366"; a="42661574"
X-IronPort-AV: E=Sophos;i="6.14,231,1736841600"; 
   d="scan'208";a="42661574"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 19:01:26 -0800
X-CSE-ConnectionGUID: Wc64PkbdQHyvzR2EDHef/Q==
X-CSE-MsgGUID: jAI/f1vSTPK8SEp7VY/mmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,231,1736841600"; 
   d="scan'208";a="124565473"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 19:01:25 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Fri, 7 Mar 2025 19:01:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 7 Mar 2025 19:01:24 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 7 Mar 2025 19:01:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HVg4i0wXcKrdUBclC9w99u96lDfYSE2fswPyoh49hUScqqNab3fSpwyw5JCmyK4DEKKWOYgMiCMJUzzUvCFZpVscZSPfljQYa3i6vULRfbmWbTdGp75fTD0eYFyqem3SNlWdteNjv4TuYQj+qkNpHDPeqveEQ8v/1zarfL326S9cV+wFckiNiXAPj2tjVXv3WL4KpaiCSzx77tCAywtDv2TXspk10JQtn9EVQx5qEhYqC4RfBjR96s9hVzuHQyS/wiLXr4fJ5lx6OQq5iUQOrpvYGudDAP+Qwx3QCzuUCgPsw8vtJ5DkCniF8ADfck5X+rgHIQkWlveJ6Kca1PVPrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VBfYzVwcNAaHRRztRlvZXhG5sPUt1H9D8w3HZMmoIhs=;
 b=rxIf7UdnEbWNVN2fnw9qMrW1L71akG4CfgkTwYOUL6vHCyQVeTjX0iKW3ge9muXfg2+wJpdqUgPj2S2dqWdYhWA1ok/buWKr0OoTCbc30d0b5UzsYn2lZy+MO5OoxVqgYDa2NyQMMDHDcIFdPUy0ujAKo7BFFhCwJ0duLG4n1JXXHy43Qzb/MW9uiKp0PwiFzkaKVg1wXGFk/QbPIELBiNGKf8WWx3rLdOUoy04Jtotddqpfdx/Ql6YRmMjoc6ULI1loYHjO/5S78uySechwQO9UwD18hX7KBqnRu4kbHIwP+Nj0h29BIp8mTqSxPCt4kgLCfGVNUa1ytngq1h2EPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL1PR11MB5956.namprd11.prod.outlook.com (2603:10b6:208:387::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Sat, 8 Mar
 2025 03:00:39 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.017; Sat, 8 Mar 2025
 03:00:38 +0000
Date: Sat, 8 Mar 2025 11:00:28 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <tglx@linutronix.de>, <x86@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>, "Maxim
 Levitsky" <mlevitsk@redhat.com>
Subject: Re: [PATCH v3 05/10] x86/fpu/xstate: Introduce guest FPU
 configuration
Message-ID: <Z8uyzKfg0sfcfZB3@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-6-chao.gao@intel.com>
 <cde2e31a-af2b-4236-a5b7-e1119c62b4a5@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cde2e31a-af2b-4236-a5b7-e1119c62b4a5@intel.com>
X-ClientProxiedBy: KL1PR01CA0147.apcprd01.prod.exchangelabs.com
 (2603:1096:820:149::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL1PR11MB5956:EE_
X-MS-Office365-Filtering-Correlation-Id: 91bac335-55d9-4a12-c3f9-08dd5ded6784
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?shN5kfUC/5SheBlO2ShHiSzytxP9HdLu3f5GlAF+61l+bqJkV/Sw2IE0frni?=
 =?us-ascii?Q?BIrOnTMS8Wpuyr3EGL1Qyj4PTRxoTZ7KL83elHuhGEYaF1XmzCmpAGnqLhAh?=
 =?us-ascii?Q?6EOiApN+4xiUarb75Yxig5EiObqcbEzz+B3AL+j+KfWjHtz2xOpeectrTUrk?=
 =?us-ascii?Q?PkkMZ4Etb1jfjBgCBCuXo0ChIhm65NZE+4ArHGs98jWgKFdBIjJfty6JmLPk?=
 =?us-ascii?Q?vNTdfbwaYKoan4iLGeMZ/i3/D3G4pG/NTUMFaRz6HNS9zG67MOpVWJRoZTjs?=
 =?us-ascii?Q?8sB5QlgI+sou80At2Bfi0jTVjK/h8TgX8mLail4b9ECvDID7Rf0v+7QPOMRc?=
 =?us-ascii?Q?wHWvemhxtVW+RYv9GeS3di49MajALHEamuCUKd4gw4svNg/Nqdn+xqXBtzRY?=
 =?us-ascii?Q?SelmOhesQUXs2uK29D48hP7aILaBFwLGhYWQKtOvr6EfK3356Kya4/XJBizI?=
 =?us-ascii?Q?llXOv6t2+E0s2GzEKbCF0Lk6nYANmJ+lqHE7IIB3IQGRddNID0j4NRdxSDJL?=
 =?us-ascii?Q?P9lFfJU0RNB8ZHfZjpp/G+3ETudpKNhf0aqBEOCzIaHVfOY0cbCVVGzKVTdY?=
 =?us-ascii?Q?AZV8rh+7kBRpBKjN2Mj43Vw4wfe1Tt7si4DPX8XxIN9ld95sCtbk81wp1ihh?=
 =?us-ascii?Q?2iNNrFwhud4fWS+JSgGaCi24KQs7fpn1BQQ+Y2Gyslp2ngoK+XcjL0spz+jO?=
 =?us-ascii?Q?idmC4xhFqpW2kf5jSmKEpkQjJjQpWyzKzexmzXIVDWzlimvAYc7myIsTGYj4?=
 =?us-ascii?Q?37XNOBvRgkd5hjTt5btkx76I+s7DuIpJBlPe/8lKlOPNmTigA+spj2ZAI5Ju?=
 =?us-ascii?Q?iSxhU8hHsiU+5XkqLC5C979Bf1W2c9JMRa/zyWqiMZMbYgCWJ90wHQTM2LPx?=
 =?us-ascii?Q?PKAucBYKaW+jxBVbZFQph8o11loRkC6+jxZcxhhzr6cTmPiESl7Vj8/xFKXW?=
 =?us-ascii?Q?5CU9rulhJd1Yu8nUcLIm+BujRKo8tvrC5pYi/pF9YcjP3LgEBwYqf6683Khe?=
 =?us-ascii?Q?uHYOFOxKP0hgLk8yrP+OLDPQCCiv+2IM2ln7yxzck71Tg/O9qzzoAHgdBMMF?=
 =?us-ascii?Q?zl3x+a+8/956HLMMG6UQTIgGcunLUdP5PebiFZ7bMeSTceTH+A/40nK5+PDw?=
 =?us-ascii?Q?2Rs92Weaq56EoEmyLKMPojZnmj99kZMEyjgGyAoxBiqHz1DO/7QU2B1MA8nY?=
 =?us-ascii?Q?P8VlQAXleyOZzeqZdJkvhSeIJSa/uH87z4s2jsU9bpZ6SWqApRE7sjAtWJ9w?=
 =?us-ascii?Q?sC3eKtUHexyjGW1Jdl9WjN00yBJmG15QZRda0zXxRC+c7sSMkRNUiFYDsJKj?=
 =?us-ascii?Q?CK7b3Z2ejRIEhBbHIdI8MbqN/z68bTMnt60WnsgeY9kPBJY4MNX3lihO2Jn7?=
 =?us-ascii?Q?P1Qzi+5U2D9rTysqNM9+k3IiYOEC?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0vZjEQcaelP8sU6ZytazsxPzNdWlSGcrFFnMKEHf2pIk4Hn36vPSYt1ZjNil?=
 =?us-ascii?Q?fOqlw4ZbjUrZXHbtSdbwv+5qrQHqI/84ks42kX7tHfkHVtU+UvYyyt3RcuLy?=
 =?us-ascii?Q?dRmx0/bfBmaMxI+XfPOWqqlKGNLlCMHTmv33RAg8zVrrlrKJ88jh4hZP1Pt/?=
 =?us-ascii?Q?OKBl3GZ04lzcRenBRPJ3Pl3QkmpjWokDjORI7wjg5vOujfikhNSTOhDqDrwc?=
 =?us-ascii?Q?lOpAwx9DsPwVVpJ9sZmqKqnSIqz6J+Aeb4w3RJTYrq6ER4ViGtasTC/2kGgH?=
 =?us-ascii?Q?IJLPi4XiljLoWmWvtyC+tx6vRKv6Mv0Zp+AhAJOnXpluvlHoh+yvFiCZB7A+?=
 =?us-ascii?Q?pMEr1Y13sfCkzCfUR5qn8wkPkjMITjmtpdo7yOCINN4MaHmcgrdkiEWWOWRp?=
 =?us-ascii?Q?Q5gqdo2lwmGXJ9PzHnRAAeqhUwkbzOah12lF5QfG1jAgxw5HPY13uo2cd5vP?=
 =?us-ascii?Q?J0WnCUtJPQSeT1Jc49cvxY/mpnqIqu9HR6UO7m2ZFodOwzcbTTLuUP4iRqEF?=
 =?us-ascii?Q?5ZMuRXo7hpnt2N4eD+eIBZD99t94kxOz8tao6T164tgKT0B7JUq0I5q47TRQ?=
 =?us-ascii?Q?BFLLKve7HR3v1NSDDsdVdPLpkcx9LaWWS3FHzRFfmfgMgIYnsVLueJfF3q1d?=
 =?us-ascii?Q?2qomjEF83ztVUOPnc4kUzP3/7nS306JOuiPf1vN20+GenrjYhpT457pgQxfs?=
 =?us-ascii?Q?d+InntbETdZo/psrpRIS414a99mMKvJLNRxtZQHYFvEzZNm7Bm+SQ/y/AoCM?=
 =?us-ascii?Q?YffBJYG/elpBJdeLIXoGjJ/zUZEBb5qCNgws8jGJ82GlefQ7U2ofJRGwEXoR?=
 =?us-ascii?Q?kgAfxtyqHFzT5HhSd4uO8GPZmAKjmmYYYt5H+pyu5Op0PcGw6wT6ZlaUcy+n?=
 =?us-ascii?Q?ihA8gMowtSgjIpb+iJ4IK0kW41hKmAdrjpxpvbKoTCzSjA1N1Fyi9BbLN7xx?=
 =?us-ascii?Q?KyQ0MKaeomh/+knzSpHuSu3eTLlBjl5iahHz8k/ctedmpQdR+u5UMYWHv+Yr?=
 =?us-ascii?Q?sZ9c+EqYq4cdfB9ekTUlfSq+mJv3moY1p1vR9ADpGVE5l9kRXeSHgHO/8mIQ?=
 =?us-ascii?Q?/MAt46faenfxoXpUzONMOCC/VGgg/vFYXwg/IbKnG5+tJkJPvitnmPqRGYSq?=
 =?us-ascii?Q?wR9L2eAtNgUrC7wMFtjgIfh9RvVX200jf1jp4qkb4GDnZyv4Rj4slvyIZ+zf?=
 =?us-ascii?Q?4IY+EVBxPzYhmRO4C9w2fY5xVjq9TxQQqcaTea4MpVbRmNcmnFc5Q7p3PuG8?=
 =?us-ascii?Q?2G9MXAo61rHi5MfBgwPI3D8Xat3krCofFL5HCFpt8jDRkTjIVXGT49QMyUM/?=
 =?us-ascii?Q?VKWN4fA/oYx0IRsgdfvEJO66nQIIY3lrlyvJsfI6mwwsEwoTRn/z4BOZnsKs?=
 =?us-ascii?Q?LWxZMkFGvtnzBizLJpAEN1tdONT4cF4UZxQ7JkY2UngL9H/8fXHJjl1fh+jj?=
 =?us-ascii?Q?1eWfWT/v22xC5k1cI65pedbAaXmOM+SiV2syahm4Jgcu7Vfw6OxtGe0M2x3M?=
 =?us-ascii?Q?Mj//KPGhQnPbdOxk2LE2GkCsXgTgqKWlgnzE0duYCtM+uxZUgTg3PXzVxizQ?=
 =?us-ascii?Q?qRnDFEmzTiYB4CPzcWLnEY4DwE5N3/875qhFr4Tp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 91bac335-55d9-4a12-c3f9-08dd5ded6784
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2025 03:00:38.2903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OFKhdUwgURtDD1slEoa1Yu8R3L01RhK8ONnGW+abbhMRtNVpDFpY1sK2OY97ajqJlorOb4fllJcCJIr4ExAefQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5956
X-OriginatorOrg: intel.com

On Fri, Mar 07, 2025 at 10:06:56AM -0800, Dave Hansen wrote:
>On 3/7/25 08:41, Chao Gao wrote:
>> +	fpu_guest_cfg.max_features = fpu_kernel_cfg.max_features;
>> +	fpu_guest_cfg.default_features = fpu_guest_cfg.max_features;
>> +	fpu_guest_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>
>Is just copying and pasting the 'fpu_kernel_cfg' initialization really
>the best way to explain what's going on?
>
>Let's say you just did:
>
>	fpu_guest_cfg = fpu_kernel_cfg;
>
>?
>
>That would explicitly tell the reader that they're equal.
>

Yes. This is much better.

>

