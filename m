Return-Path: <kvm+bounces-48486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD54BACEA1F
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:24:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 605B01784DA
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB161F3FE8;
	Thu,  5 Jun 2025 06:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JHVmx+R8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4601E6DC5;
	Thu,  5 Jun 2025 06:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104689; cv=fail; b=DjVD9l8MUQuj+eQcmdF5RE8V5PD6WD3z59OjW5a5jBMS/A2HKPT/KReOJGZXa6suZIM7neu6JEK0S0cmnWzt9d/qj304e2mDKSIF+7j6loVKGRGZqwx0wYVl7MF6yKfeh//vSQ23kdspmpFNz8pBbclt7gjkVwIHNHzCuDqiBPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104689; c=relaxed/simple;
	bh=j7Shk1Td14ePdoacQGNwE6ky1mhTxaF/jdn+uiu3DAs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KKivYIhmB3KNfBhBY7Bx4rhZp3wDCNSshXc5Yc8bytEWT5WU3ZJKUIBWiq6dV5nMa49kdaNJ0x0X82hDmYoblo7VJR10mrD48ap4rcnHW+RpTjghGSOuMr88fIYfKsidL0ZFagPpBW6qOLQWTorGTLtyc7i8JL743AfACnqEHEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JHVmx+R8; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749104688; x=1780640688;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=j7Shk1Td14ePdoacQGNwE6ky1mhTxaF/jdn+uiu3DAs=;
  b=JHVmx+R8KwjnSdcMSgUWzEPIOHBU7cBmS9o/TQD9am8zbdT/8KV6Vt5S
   DIFVU6qanQuxfmUaQujPo//CtABDFPmYKYHoQ4jvrGHyIsZs7alWU9S2H
   9alan7iMobm562RXRq80Ap3zlp/L6FcgimHJm0JQnz2bDBEC7YjbC4w5V
   PBrUK3xzZNCeu2BPHRVC4d3bQc6NnICZ1CJjElKW3wzI3D9l+iZv4IBMr
   Lmmt4vU/K3K+bbPMrkvKB2JYYhvUCznv08D1u34CeTeh6i3F3hfY+snF4
   Gio0IWu+kKWHbanIMX9nRnWblqtGqb2m68OLtYizUcxdhZ8ElRoFo5CAt
   A==;
X-CSE-ConnectionGUID: wbpn3U6NSXWMXThZK/uxKQ==
X-CSE-MsgGUID: QFOPXYJyQ1yt+lug3d+eGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="51066543"
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="51066543"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 23:24:47 -0700
X-CSE-ConnectionGUID: 5U/thOfNQT6bHtZiAw6pWw==
X-CSE-MsgGUID: fM0R+WvuTzKKE/W5RMPW7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="145910777"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 23:24:47 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 23:24:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 23:24:45 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.88)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 4 Jun 2025 23:24:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sl/gZoG4BIEAeGOb66mPXaupFkE174KkNuumNshOJS6iPBbZS3pWMkpS+uEQaPrZP6iR9Swz4AaAaHlWUGt5DpDCwSqF56kRejGIyfVZE4l8IsTdQG/OcjmN6gmx3jdGUrzO2atdqMn0KvtqFPKem2Drz8B2M4NQ7xlJUVFWIb/BDV1LcHBxFXKcEUq+1cJXU0jX2ooiwPcZAZn+6XCxhBgwXW9naJKzshL1SXNq2rjShJlQgAs3mcAt0GIPkmrRWoNlu66nxyOfb2xVz6rXchIQNp3+T/tCcEiPI3XQCYEear/OcDzpIs4EALM7Tjblvjncc8lk8Ge98QTteNaEng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iX3qq08NRLFiha2wDmv0GlhI6AkE1a+C6M2M8twebdw=;
 b=IKWluwrwMNZxYrFJJmkTCyklKP1B25Z4pTrOYOU/LJSFEi8lTdFuiF3oGYWq+W1i6rl1E6wwejXsJWqF2h8i03A3fIHIdVjZl1hhy1r/iDLr1+o+/QUW19tl6guTvLKpP/VAc78EEz4qPXxAe/W0nDf+98M9ivFgBw/hBSgw8y2wAwVKglYjhvMJueb7VltCKnbmAYRJd4UoYPlIUbhviwaQn38Yy2gum7lxUOaInKVCzWlWm5opQRX1wzCckRYkuYDF15hOpIKhdssLjS2Tv3yG8X95zlcsGgubO+v56/YQcjGqAkdAOUdGjxT1sknJQzUyJVpNPPmkFHi7gp4Z8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB7719.namprd11.prod.outlook.com (2603:10b6:510:2b4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.19; Thu, 5 Jun
 2025 06:24:14 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8769.031; Thu, 5 Jun 2025
 06:24:14 +0000
Date: Thu, 5 Jun 2025 14:24:04 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Xin Li
	<xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH 17/28] KVM: SVM: Manually recalc all MSR intercepts on
 userspace MSR filter change
Message-ID: <aEE4BEHAHdhNTGoG@intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-18-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250529234013.3826933-18-seanjc@google.com>
X-ClientProxiedBy: SI2PR01CA0040.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 47a98b10-9bed-431c-0d66-08dda3f9974e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nfhwF1PmtY0v0B6VDWLQhJX4Vkt3dwoGpZM5aACiO/jSKvw1tJZQ4NvJ4ens?=
 =?us-ascii?Q?AEPHBMrfnJphL4xLvverUfUEzzLmIks+lnGg5pKmKntieUBjSZP6Qq4KMwwB?=
 =?us-ascii?Q?WOi8M7mOTl7VT/DIfBGme7jnW/OpZ/6R5GBXDULjWs9XxCAb/IDQBSZGMo81?=
 =?us-ascii?Q?5x/Et7ZmY/1ctqmcrGqC3PxXiGY9t6Lk0ms8IqYiSBjj0YTVH8LpEOrYiD57?=
 =?us-ascii?Q?UOYgbAsfibd0sHR1v1c4NuUX8/frbjOXLJ1kEpNUay8SRWICprO4RhSFimrM?=
 =?us-ascii?Q?2hWcur2pmu5LOqjaYOzRyPRiQ++MUE2xLaB3uq7PnPdnOcRzLTU9VaPHdYNJ?=
 =?us-ascii?Q?XNTfikNhCPbGUPr8TiQHHamr4VqnSd1L8+5NRpRpviHPd1q8h6rKwtDozgfD?=
 =?us-ascii?Q?/yebjao7lB2mRWPqEPbQHhoS2Jhhqyn4zrDHnB8tmvMO3mNbGDi78JJC8d6h?=
 =?us-ascii?Q?x6gcaB1Ui4kxHnv/LZqoq892E/y26js2tAo0FrumrZCmv5JnsUJ2+NfEQjQV?=
 =?us-ascii?Q?Sh68F4ohvtnVHoyQL8/3Gqutt2dNv894kPLINbwlw3io/TB8kN4l2B1+esXA?=
 =?us-ascii?Q?JC4WPCiYTqhdKXf79BRAuFUv3sbJpnQ9VfhrXMVVwLQ8LcBMM9C3LPKCJYwZ?=
 =?us-ascii?Q?shj8fNGX0ZG1elME/gLghSmSgbF4PO9vzeyJ3fFrTt8pG7XJeVUt8d/vl+3V?=
 =?us-ascii?Q?w5untBdFSI6PXd97/GgQwooP/K8XCXAaSdoZivqDh6ek5RWq7+EQi0LS1iGx?=
 =?us-ascii?Q?5zk7XuZkULys/xSx0RMnp9g+NgtpAOGyRH9Biy3RkEBTJ29zdpxtTrQBhuzt?=
 =?us-ascii?Q?/ylN5DzNZKkDfqPqE/tIoawA8j9jXWEwYdA5hr+4TJImKNKVVZl0Jape1bze?=
 =?us-ascii?Q?hMyeHGCj1fYNLmmITt5Sm5WMTxGwj2ETkRVbrGYbR5DqVv4Xy5lpZziLyxb1?=
 =?us-ascii?Q?uPBTJZ7vypBfejWhZ9tgrW+um1qLKLJ4kl53QytaWJkODsgEnJ3Xxfb7hQW9?=
 =?us-ascii?Q?kF5snfmC0/qjWslFxwmHjEpEI8Ku2c7b7kmEsAQm4tapelCfjzsOmGlnW4gU?=
 =?us-ascii?Q?xmnr1VECLxM9bxZ66Y4lN4quoiAsn5RYi1i5FjZEVU61EcJ2O1JjhwXzkK64?=
 =?us-ascii?Q?mg52gF/1g8C4zsKaETItaVOTVd81oybDSvdmYbbpsH+uYdGcOSfUw/7G7hZV?=
 =?us-ascii?Q?+P2CXWvGR/OFrX4N4y/+7BI6cvpe6ACM8Tw+5xTe/EE4MNy9+lGXX4HNOS+P?=
 =?us-ascii?Q?qzdYW/8qbb2nV0ifUVq7g7SkmoHwzGEUfNz6iSoTWryz1T2+FdaeRnXzvWKN?=
 =?us-ascii?Q?IgGb8zOGfPfsQc9rX3fGuJBDYTvDVEHw58xx/4dkfqS6s5in5gYCrN59nKw3?=
 =?us-ascii?Q?O+Zmhyuus3Xv08Cs8Pzs89iawf4lQUG75EGrqZ+BMOCJnZ/gKw3YQTAZRdEj?=
 =?us-ascii?Q?Ix7gUU+vxJY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7oR06My+6lYdqDh7URyQsjGS6J4RscX2qt8vMf1dB1aR0wrzUBIHmNT/7O2z?=
 =?us-ascii?Q?xhirgm1zVDwnehvmw2GhdRp1g8EgOQzyutjNGZpDhP5D+zR1CkSaeC+Ah//b?=
 =?us-ascii?Q?Y81VqINUntZrD2LRUYELjHu9V3ubSZQrmxh6NojFZUs/KPxXLi6wkzAfLNXe?=
 =?us-ascii?Q?lIyCBTVJ7CaWVRnndnIFwmUG3EGfZhQJENE6HjliqPe28/oDpXK3OsPw7hTj?=
 =?us-ascii?Q?XRQ/IG+Wjr3NwviR1vt0/FzNoZdtvQISIStSYXJVahMPegAScdmdKgkxsDBn?=
 =?us-ascii?Q?WqFmHg5gm6LSv9vfg2s2If7aOR5r6+zwB30n2Q0E9kT9pCp5wC6MwJwCs9Pz?=
 =?us-ascii?Q?iUvE2ke5+YpOXr8qJX/QIBRwTDrvkhYE2fimc0zYY+FiPXrTwaiAKwLtcp67?=
 =?us-ascii?Q?1BvxkNSjwDTtmnVDi2A3JZBaP8CTrcjZBWUgU/C2rnNUgua6vI8Eazy/UOI5?=
 =?us-ascii?Q?PwotmvpQ7ItPAnxP951+3NkpoK4T/4i2Kw7cZo+aCvi+jQSEY5O0VqTEx2dB?=
 =?us-ascii?Q?AGQ8vC1p+7zs9kuPW0E7jU0kJ9yxx0fuYYN8csz6BY0d7nFn54KYGASt8Tck?=
 =?us-ascii?Q?PidTzno2E0pxn1Q+CzdL1wgVlU48T2+QevrzBKor1opVKn5eZX5imTq8rZB2?=
 =?us-ascii?Q?iaSI30vdf7IvncQo1lvlWOg9jC5JdTJJsUa127QQYdm+fqCyMeCKHNTtdoyF?=
 =?us-ascii?Q?B9huaklfheiUm4xyKowsPBrt8DA6EXI8k79Iz4bL8aa22mJygKm0eTqSHV/E?=
 =?us-ascii?Q?DGi6F7CuFqchSsL2Vr3GFZOKUjF0Peff1zTPtMOi5YZCnQIDWRWU3ROk9l9X?=
 =?us-ascii?Q?HoMhBWuOml582VJpN2ZHS0banl4uvtAS/SFZSzkie1cJh5jwj4cmvwubG6At?=
 =?us-ascii?Q?XrEM5RuwEDp6gzfR5wU6Wg5fmrggtZ2jHZJEgrEYpTxjppuYSF5Vicuta/da?=
 =?us-ascii?Q?gGCWQhx94CR0OKJjKN3I95NrKW4d8NUSDJKdHFPSy9XmJkqJ97MPZ8H6YlZt?=
 =?us-ascii?Q?wPBAMQrbZkp7JRuTV5cvToH9OdyaglJ9V25NSEETJ1fCGbSpm9XsdSumiJH1?=
 =?us-ascii?Q?dEW6wBflwN1Io9tenuy+ngPPPh5nVJjABL91y7DiN5xIifOWWf/axAPSKZYx?=
 =?us-ascii?Q?xsCoaxhQNKXz2/VVX68gPER+/pj9rqZ4Mnqljw83hqYB0pJTVA5CjcdL98Ka?=
 =?us-ascii?Q?D+4196R69gcR2AdqXIt+V+nGUlwJayas2uReHKfZuoS8NPZBIfmpr7LGrTmi?=
 =?us-ascii?Q?ElLiqaStkeMLwAeMeariGGsmh+yLk7bskEWbiZDCxMamfNOZGSBdtHPi9G8d?=
 =?us-ascii?Q?zZ7McPqfQseXU97nSCU3JXGyyrY1KiboBVssdAFraNHIa0UnKRe841sDC2rI?=
 =?us-ascii?Q?RJz0saNOUOwVK+XcgCn3RF8bxbQ4gvl9TcEef30gu0apPVaX9sd9VJVRNO79?=
 =?us-ascii?Q?3Weeaf8K/5C5zpZCso9FD0lH7B7qEZxJpH762vdwH3ck3BTGJgoYH7/xDi3P?=
 =?us-ascii?Q?iwBkcVIO3vLB/yJgwb8AP/ZsDRMwZ6hagCOGfPNtbXGkCsyc4cXOfG7uRlYm?=
 =?us-ascii?Q?yhWo0X0zMVvx7qAcj0hfwr1ftkioVypSYKNVsncY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a98b10-9bed-431c-0d66-08dda3f9974e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 06:24:14.0726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vq8h2+k5qza+iaaLU9xweqlpFzvrtJEnDD2Tk8Ed/NSe9+MEbputN7oh9H8PXLSDZi5g1z4QD8Rff/QZR5mvGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7719
X-OriginatorOrg: intel.com

>+static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>+{
>+	struct vcpu_svm *svm = to_svm(vcpu);
>+
>+	svm_vcpu_init_msrpm(vcpu);
>+
>+	if (lbrv)
>+		svm_recalc_lbr_msr_intercepts(vcpu);
>+
>+	if (boot_cpu_has(X86_FEATURE_IBPB))
>+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
>+					  !guest_has_pred_cmd_msr(vcpu));
>+
>+	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
>+		svm_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
>+					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
>+
>+	/*
>+	 * Unconditionally disable interception of SPEC_CTRL if V_SPEC_CTRL is
>+	 * supported, i.e. if VMRUN/#VMEXIT context switch MSR_IA32_SPEC_CTRL.
>+	 */
>+	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);

I think there is a bug in the original code. KVM should inject #GP when guests
try to access unsupported MSRs. Specifically, a guest w/o spec_ctrl support
should get #GP when it tries to access the MSR regardless of V_SPEC_CTRL
support on the host.

So, here should be 

	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
		svm_set_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW,
					  !guest_has_spec_ctrl_msr(vcpu));

