Return-Path: <kvm+bounces-60052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A658BBDC053
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 03:47:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59CF43AE2D3
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 01:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 942462F7478;
	Wed, 15 Oct 2025 01:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pm1ajW3c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048993BB5A
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 01:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760492855; cv=fail; b=LUWhS6c4wZmMkJNkLc+fDE1qZMzxqe0Ma9HMLlb5Mb7rc8h8iArGLyX+AxCfeFPDDQDSDNix6Tkxlq6efMDL9prDroLCBe56ITLVtieSsaCtkvYNceGr5Mv/Pxgfq8LZ5xIAYqHB7eiLljsohDEvP5fOeSb9/PUWZKotaj6RLP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760492855; c=relaxed/simple;
	bh=AWFoJ1rcdh+K1ZZaa6bYQ2JeTtkboHEnZP/GZOeYMfU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YxZto3D2+1EnLfjej9GBup+vaeABn1/Q/kxVqJbbdvN2Zc7I7CurcyA7Vhu3KYOWroqlM6v94sZCxHCXeIUZDNHM3t/jkgTEIOxiUHoj5sBfLqfcPFwNxq5l1NqPrW0J3dj0cbtHzw+fhFtSsUnADBLx21V1NtodGcSj/AfP0/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pm1ajW3c; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760492854; x=1792028854;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=AWFoJ1rcdh+K1ZZaa6bYQ2JeTtkboHEnZP/GZOeYMfU=;
  b=Pm1ajW3cjdzIzmanGgpmr9svbG07gUwfNAyzoLUi+eqIE8NNWr3eB4oF
   JPMB315M2K2jHlW6gDtWzOBcclvFYNgRJ0xlIycvY8J56g5trdyUREE/W
   8zluOTolzIcwkbCbazgjbcNkOBaGw9e4XzSggIxRchX7s7laxjAlrAlVb
   bUsEjei9N2ihFk+ye8wpFoJ0DD7IObw1iTdXhslo63jggUfSR+2yxWLx1
   jf2o3xxHxcIOrUmocPYH35W+Ue27wCtce+PUsXkoSEoW/by/POPA6XnxQ
   8/vPX1QPwTI38jLqkneqtIjE/8D6ZSMEtCHTEZbRnn20ZNHc9odkxG19d
   A==;
X-CSE-ConnectionGUID: fOuEZVW/Rfy2/bHcSaObxg==
X-CSE-MsgGUID: 2S7KQVNBQk+3792nCOzeLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="61868434"
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="61868434"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 18:47:32 -0700
X-CSE-ConnectionGUID: mf6UrcgaRDaqhUePCaQC/A==
X-CSE-MsgGUID: 4Uczs3sKQLCHJMHi6TPY1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="181712470"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 18:47:25 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 18:47:24 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 18:47:24 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.32) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 18:47:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g+Jx2QwCtcczqk3uPfTGuxl6+vPlAluwItRJiO/GjjnK/7SzOVKfrFqjdujKitZILanXdXkNTUo2Mka5xJSlV4fRaVIwMu2lxTaCSnKZbloQbvTbb7Sotz8e7NFufuoEmrd/WFLXG09wRgYRv7W3sB4O8ckySFQCkTa8fsPxNDlExyehmy/RPpmfhJ+WZn0QS1d5u80qP5bnt0MX+nZPPI/BYt5qDSKAhh/ZP6Y5dD4WOgf9OxrAQgXTo6Jzm8m8lFZ6aDQbpzTueIOOObEEzGg4VXTaPnIrk0O5hJG0YEm9e3NPoirl7ngB32ykwWrDEoWtfjshBPaEQ0k9Q6ILgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w31skozPQwyeDm85OgVjuu/YKpso/V8jmotywn45DzM=;
 b=bvGfnEx91AoQ4kqCeWyLsg4TGI9epTptgDXDkpshV0Wz9TRV5Br/mWWefR9A4+Sq2ZHKKOpmehkYRth1BdgPkAI7fBuy6u+pS1x0Ngq3aL/+15iZkuwecQV0EHibqVS5hafYvS4WSq9K4/6/HcXdIcae2CbXutkLe9fyVMWXd/bdI1WSYCyaj7LX/Honlwo5SyfJsTbGdV+w+RJ1D/zOcKgPwzoJyQ+pogY9w/wnypn8dddpHDgd8mx4/tRYK5F1qfB00Qghp9j0UR5bHzY6y01L7IJSdZoH0QcptqDYkbV3g52OgBkIv9rPjKcWrN6/HRzuaUmB2tv7+Q1fqN2Yww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB6322.namprd11.prod.outlook.com (2603:10b6:208:38a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.9; Wed, 15 Oct
 2025 01:47:22 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%7]) with mapi id 15.20.9228.009; Wed, 15 Oct 2025
 01:47:21 +0000
Date: Wed, 15 Oct 2025 09:47:14 +0800
From: Chao Gao <chao.gao@intel.com>
To: Mathias Krause <minipli@grsecurity.net>
CC: <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>
Subject: Re: [PATCH 1/2] x86/eventinj: Use global asm label for nested NMI IP
 address verification
Message-ID: <aO79InNMh/5tp3ih@intel.com>
References: <20250915144936.113996-1-chao.gao@intel.com>
 <20250915144936.113996-2-chao.gao@intel.com>
 <a8c4d415-a23b-46f6-89fc-28facaba0a44@grsecurity.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a8c4d415-a23b-46f6-89fc-28facaba0a44@grsecurity.net>
X-ClientProxiedBy: SI2PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:195::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 59994980-bc66-4450-b7cd-08de0b8cc83d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?i8p9wfqnObU3GpLrMZyL0fk+7HNgFg3R+4uU69pevzDYhyrKRkMz+VbCBJF7?=
 =?us-ascii?Q?xVNVMpy2iYftGGWk6IOjG7DHRhv7yyBNbhpRmlwAvPdUyCZGSLBVUtJ8HvDc?=
 =?us-ascii?Q?+HkEQ4J8TouXuahxXPtcxqugc/KRQrmviEiaZKT3GyGhYioyWW4FFhgNarkS?=
 =?us-ascii?Q?idRBSkdZ2mSyqJnyd3T5d+2t5pF5RAGnPFpKUdPx7YHW/zUVfUq9dcqwShKj?=
 =?us-ascii?Q?8b7EYIVZ9Qduu8qblJtjw0FGm3CwtQtf449rP9DoXfNzs99ILdQEhxB3p+Mc?=
 =?us-ascii?Q?WHPg6jIR5DEDwTuqVajfpWClJiaW95gWeT/ifVWXNFIE3bHHy7udmcbbuQMJ?=
 =?us-ascii?Q?yYuQdCHg9Kk2SwbdKTFCzsl97dFnRceNJFLBva1yvKlGXtOUL4kQSxynZ+Px?=
 =?us-ascii?Q?aUfi71AXhhj/V2GFSnqHPmxVtf7l0ijUOuunSx91PR+hS84+QW5wtmi6iLwi?=
 =?us-ascii?Q?gocT0PUd1RYWHsgGfR7xHJsHgPClLOiQCJyj97gFsfPH7WqGnLjjDIk4vCpv?=
 =?us-ascii?Q?NgNaHB21C8VNM1VC57bLjPFUQEQPQ8iDPWjWo+rtshzQkwy/P9AFgQtTWfKz?=
 =?us-ascii?Q?ZsGjnAyJwjp7q2i202mSHJ86vJeHzVvtxvums5DDKABby5/WXxyib9OGSCiy?=
 =?us-ascii?Q?m+sHE3a5nj1il0YbskcunAWmv9EgmGVaJ8ve3tVqgdVYVa+Y5XDbGqfB0DG8?=
 =?us-ascii?Q?Ih9B+yOVKMeX3F3/mMBJzP4WcoGraLZ/DotlHJ0WztE3mx8y8rtIyidL9h3A?=
 =?us-ascii?Q?qEw0wu+ZOqvRqlF8PQkfa4GSAHxH82Lgjb+0ScPBh5PkS4KXyOXbcp57OjiI?=
 =?us-ascii?Q?zS3IDNrwRF6xfUyQevqM1poeS9WeSl1klZr82lyO7vIEuV4mttoxZknWui2E?=
 =?us-ascii?Q?cg+U0oBkI7QT9hKeQGeZs4n19YtxgOwckC463HO94ATnMaaz0PCGlGWc51w5?=
 =?us-ascii?Q?H1TLNkZN+v9xQ85/Qdr/zCobPvZFradD5kLVN8Yt0Y4IGCnr3bZUm6VFUOPV?=
 =?us-ascii?Q?oOn6A7/MPRODOLJdhqTHM8uPHCbQSlpkNLOxXc255IFpd/WoXGDQJOvZKbLw?=
 =?us-ascii?Q?onxc1K0niy0Zk1CVDEyIe9wiP3hJLzPlMhFDXEZqdSQhJ+F4z5TL7uZ6PMU4?=
 =?us-ascii?Q?6JkRXacf0bT3PKssPc3kem4u8YepEkVmJLwBsuAPRyh6sNN8IgWdWAjofgpX?=
 =?us-ascii?Q?Qy8GEcSfKoyrvUJTKgIFtj6WSkCYWgGo2su+aAANo9tE2+YE6DVTwRFFRHUq?=
 =?us-ascii?Q?EkWzhra5UI760dhspYm7kBsOsaZWNLf1mGEIGKW+RXemPIZT9B+h5Tj7WVwn?=
 =?us-ascii?Q?NC45tnA4v8qhIbCBjZAbBHrVApAahCrYb4WieNoU2pX6rRNvpiRInzKDp8gN?=
 =?us-ascii?Q?o8sehbfUKlWvVhjrQcOkN9men4xAqb5abnjv1sLmoNMtO1VJ/s8aIcyd0UB/?=
 =?us-ascii?Q?FVN1sMCVzTAdrkI6+dEJaRilYx8+CnwM?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ktNVQ6QMj18oBmvFHjH+9/x4DYO2iH1qZu6xiQpY10dg8pcfzgsPQCI4JVjx?=
 =?us-ascii?Q?4iaBuHft5s2abghzSPtaeMPw+2KX7ndOHAe5D36vlUiLw/42fjSBSZOXTMZt?=
 =?us-ascii?Q?qsN1Lj/fAa/rxcQjO0xtDJ2vtJ7Ww7OQoUPLDnHsLAkX57mp2c9hbtzPXoaM?=
 =?us-ascii?Q?Y9BgB0eM2Ytqx023timV7gaj6vHuHWXbuIkZdR3s3FXOI8OQWU+/LW7sh/2G?=
 =?us-ascii?Q?HTIpgJsnaYvmfuWQk+LUCiB/1AD1oV5Q5ckprWT2pSqnqGp6hwFL5EIJgP/B?=
 =?us-ascii?Q?3RlCRqf6WQhr7oVVCwFef1f7AYqy3glw9hgJ7Lk+oU0iMRx69XIG5+UV8XS2?=
 =?us-ascii?Q?CINJgp3WRTfQDfYy7dYsCfBhJsF0mXYSlN+Ot05DO0q/GIGoQpGnQOkYIT+4?=
 =?us-ascii?Q?3LNJFPqvRFVfgEt7jOVzXUM2HMGG0Q88EFsCqKGK9Qwppm+LlhHqIC3Wpjdy?=
 =?us-ascii?Q?YTl3Yi0vjyQPfbfGFrf6H2Ow/URVmkQDm5WsAdM9Wp8/eNO/x/YC05SiJmH4?=
 =?us-ascii?Q?HKilKzvi9iaYFZvtNvPMKL1NO8Co/HgspNS+hP2uEjxJwhZNVM06RoKE97vS?=
 =?us-ascii?Q?iHc+4ZBFbxO6zwrT++gzGyg+vuBAAsQ6pC9InZyzyceNqdcTWiMwlStISqip?=
 =?us-ascii?Q?bb8J5QM42XJqaSqf+tXfPQtNKCNfciSlB6M4ing/bCV0ryEZw7ugdpkjARWV?=
 =?us-ascii?Q?XtjcifQev72OCmkM2NP5zfoVwbb1AMBWAESUlw2zGci/+MWykWGaGgZDx3Le?=
 =?us-ascii?Q?BMV9cOQWiY84E3tjZ9KGkrZja4b6lIt4mm60AajF5fktV1DWlAY/KBZmvI/e?=
 =?us-ascii?Q?xv+GAUPsCeJzLctgRT1cvnrPF7rkoFuDNGayoZPI/zpyfEg1Q0763KMAURsr?=
 =?us-ascii?Q?L+uj73Yr7DQd0Vpn8/+86YEk5SsUzbt97d5pVT9a/IkcfKmouF1q7pwExJJo?=
 =?us-ascii?Q?cG77EwOn+HK01igbuWuZtLlzJxPPPSGRkMr1bVbiCjLq65OdizE/xcAF/jST?=
 =?us-ascii?Q?6BH+MpeG51QfJAxF/2RVv2oDBQui+KAEUS0dQ0EQVRa3ust6XvDmDm9vk2tB?=
 =?us-ascii?Q?evntB46EnsYT7iwmyDFLl3bIQFM5ICsy/R+SmAcdTLtbZRIDBMCxBfZ4jma3?=
 =?us-ascii?Q?2+Pvkh+KgO9vtdQAeXX2ce/JQimqMQ4Y9E3DRiM0DbZjTT0s46V5FZXN72rE?=
 =?us-ascii?Q?a2DOdaXzz95GmxgjWGC7fnGTRssHIpsw1dEhq8QwiZyOmiN8RbC01YEdeNOl?=
 =?us-ascii?Q?paWrRwhVNl3KckX15Qa1og4/uEoQNWY/P3tri89ULf3+bgAj6MtUaiGGxfkQ?=
 =?us-ascii?Q?iftGzKo9oX9iN7qVR1UQOVJstKWEMVZdALQ4ncKJY8OIZ4yG12nyeZl//qG9?=
 =?us-ascii?Q?2TBfUBgqhTS+eg6HHF/4vkr2ain4AStvGQrixGAJWGUmFWqBDdideYrUfvvL?=
 =?us-ascii?Q?lRu2rf7Q0Wua7xT/KMrpQIPK/tEEJdNaugkFG2pTEjK4us2sVPd/EkBe1T6y?=
 =?us-ascii?Q?WmlUtQ8wZA0U9I/VYSkwVf4NhTfbu4Xaihx+zqtfpKIjMa1/kt2OyWz753cD?=
 =?us-ascii?Q?3QtZ58tB3cIrl/X6zNo5RZYotYC+b4RBGma+fvuu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 59994980-bc66-4450-b7cd-08de0b8cc83d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 01:47:21.8351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uyq6+oe9l2MXHFCMB82ts+7zQaOqwosgwkUcuvp1Vuex6eotfn9B3ahi3ZAZXqLXn7+dC/diTgSlprv6QLUfoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6322
X-OriginatorOrg: intel.com

On Tue, Sep 16, 2025 at 12:10:46PM +0200, Mathias Krause wrote:
>Am 15.09.25 um 16:49 schrieb Chao Gao:
>> Use a global asm label to get the expected IP address for nested NMI
>> interception instead of reading a hardcoded offset from the stack.
>> 
>> the NMI test in eventinj.c verifies that a nested NMI occurs immediately at
>> the return address (IP register) in the IRET frame, as IRET opens the
>> NMI window. Currently, nested_nmi_iret_isr() reads the return address
>> using a magic offset (iret_stack[-3]), which is unclear and may break if
>> more values are pushed to the "iret_stack".
>> 
>> To improve readability, add a global 'ip_after_iret' label for the expected
>> return address, push it to the IRET frame, and verify it matches the
>> interrupted address in the nested NMI handler.
>> 
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> ---
>>  x86/eventinj.c | 11 +++++++----
>>  1 file changed, 7 insertions(+), 4 deletions(-)
>> 
>> diff --git a/x86/eventinj.c b/x86/eventinj.c
>> index 6fbb2d0f..ec8a5ef1 100644
>> --- a/x86/eventinj.c
>> +++ b/x86/eventinj.c
>> @@ -127,12 +127,13 @@ static void nmi_isr(struct ex_regs *r)
>>  }
>>  
>>  unsigned long *iret_stack;
>> +extern char ip_after_iret[];
>>  
>>  static void nested_nmi_iret_isr(struct ex_regs *r)
>>  {
>>  	printf("Nested NMI isr running rip=%lx\n", r->rip);
>>  
>> -	if (r->rip == iret_stack[-3])
>> +	if (r->rip == (unsigned long)ip_after_iret)
>
>This change basically eliminates the need for the global
>'ip_after_iret', it can be local to nmi_iret_isr() now.

You meant 'iret_stack', right? if so, sure, I will make it local to
nmi_iret_isr().

