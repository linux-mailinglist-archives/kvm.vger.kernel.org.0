Return-Path: <kvm+bounces-42448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 24E5AA78744
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 06:29:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A90F47A2A6D
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 04:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34540230BE7;
	Wed,  2 Apr 2025 04:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SqE/NDKJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D31B1C5D59;
	Wed,  2 Apr 2025 04:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743568180; cv=fail; b=PKPpvGb2JIgraQvpD7vgOuJI6uoH3nxLc/KFTXRJI8c+pZYx/zvzPAdWSqpWuk9kSiOuKgvsjM1mCey4iGQYQWegZQO7LsHSIgNHSIRzeYVHRWzzwP9AtzdUtustiM2UE3CxFnVdlzRhdkbCYhka2EcVa4KwlpNSqcLwgyNrlas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743568180; c=relaxed/simple;
	bh=5TZ4YEEUt9ylLZzZXmf5USZi4OjaZ2awEf64l4Esg68=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tcpXyGY9UKHxsSDLi9FeFXHsYF2svR6EzdoG1P7ir6W4WEmKMqsbpnDr3V79UG0Fec6zhh3ewjSPBluurSL8Fv0vY2kUkJBNpziNgETmv+V4wqRR7aAdJnzGASMiiDCjYhlJ2T4jraYqSFf2qMu+ex9MCse9TxUgdd+qzgZKNeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SqE/NDKJ; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743568178; x=1775104178;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=5TZ4YEEUt9ylLZzZXmf5USZi4OjaZ2awEf64l4Esg68=;
  b=SqE/NDKJjiyCZskwxmNS585i7/t57C7E65ZsBevz4OVMK3bthbjaLtlu
   4jOJMV86VvtjshB5WxtbheNLKGtJ29YrrIKO+SXXC5ohm+FIFnwb9DPKT
   89oPb0pt+U2b6BywIZkpIHiUsd1TxeyMyQdsbEu/V2rCo0hV2FdC0BAWT
   +QCHOfeXKpIG5qVqEX4OnO//hWzCK2adZkkDaj5Z77BR7o+8wl+YHsOTj
   xAOshKW+M12b34R9mNUxyr1TvGmzgV00WYbGPHrHgIIEry2iSOSZGl6BQ
   CQBV2sVZlGc8gNi0WoOwfHfaqiNI36a6tb4eEoApFC1Zfx4hqZtzo/4h9
   w==;
X-CSE-ConnectionGUID: rq5MBQq2Q6yrZj1gECe2hg==
X-CSE-MsgGUID: vKlzw169TDKcwT0mUfzeOw==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="45037290"
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="45037290"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 21:29:37 -0700
X-CSE-ConnectionGUID: GN6wYO2UR5yOc0P1FUK9hw==
X-CSE-MsgGUID: laB2iYEXSu+698lLCnzp9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="127095048"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Apr 2025 21:29:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 1 Apr 2025 21:29:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 21:29:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 21:29:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bcCNu1zZx9C3UTLRB6xv/Qk0H9SOaFqtgdbcZeaf8XQxBZmQNhDqht54Qayo7J6LE+Uz5wecP/B2u0DtXea/Mm+MZGg+02Df2oZzAPsIcj7Im7AdTUjZ6fzsnAZREQQomFGXOeBNRr5kfCRtrAetBgCKfljccQ/Bvrg5H3K4H5NLzi/TRHziHd9Sv3uA+0KayXy4Wx1/qtkukmPXnEpY6icHAkXmwAtQtsKQdNQFfYdkFUBFNhIqSm0b6yk83MwIpI5KM7Kpra4oSAWNYjDNYq2lP6Z1SFyWGU8qi0ykAocmH1ocRzalrF1FCZzn57BpBV7S0a5sSkq40PcvQ2Y8sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IYfDCOG+3eQyz5Tt2ueW8VcBS0iL3XAu02HWEImJSkw=;
 b=PKwDkDcStI3BX8K/d7aEXQDp9/z1/Rg4v9XAsNbsVA2l1n84Bi23f9BH648caTx2R4KxvondF/upyTeu66qJCo+IbXRlCM2vnd702nADu8wdMwNElLmKGXXvYJc3R4qs/54bxpCrp72h64Zwr5vcCznY07fzJhj75pXlbYb4J0IL6RrHVSGdtK0cTV+TF46LT+SW0ps05V/r/PWeEvrzfSBVgvJiTyHM+cPJIe6UZdP9ffWcYjLGQATz65P4qms5v4GitBuilOuia257pKnMVBZ6I+q9aUyTiZH8jwi+ySub2AUhiMvOjWi+v8msFSQQ+Ezfm/K2jfWrMG9wAHMHuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB7697.namprd11.prod.outlook.com (2603:10b6:806:33a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 2 Apr
 2025 04:29:33 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8534.048; Wed, 2 Apr 2025
 04:29:33 +0000
Date: Wed, 2 Apr 2025 12:29:20 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<tglx@linutronix.de>, <dave.hansen@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Samuel Holland <samuel.holland@sifive.com>,
	Mitchell Levy <levymitchell0@gmail.com>, Li RongQing <lirongqing@baidu.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>, Aruna Ramakrishna
	<aruna.ramakrishna@oracle.com>
Subject: Re: [PATCH v4 7/8] x86/fpu/xstate: Introduce "guest-only" supervisor
 xfeature set
Message-ID: <Z+y9A+rbAwZWJMVT@intel.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
 <20250318153316.1970147-8-chao.gao@intel.com>
 <bb8442f9-4c43-4195-a0a8-4e7023a10880@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bb8442f9-4c43-4195-a0a8-4e7023a10880@intel.com>
X-ClientProxiedBy: SG2P153CA0050.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::19)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB7697:EE_
X-MS-Office365-Filtering-Correlation-Id: e79ed305-fa74-4efb-ea35-08dd719ef7b6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?enRNQnRZUkV3c1NuRG0wQ1dnZVpwQ3lBL3ArT3RaUkQvS3p5aDJlVFl5M0lz?=
 =?utf-8?B?QUVYRVhEbFhXL0JjZFpXY3lSNDZKU0FVVkJZSGFFK2VhREUzNmMzMnllVjhK?=
 =?utf-8?B?Yk9UNlhIREw1eTZ2TVpyZDY4bWttUERmQkVjVUMzQkNaTjZ2YWV6MldxZ3dk?=
 =?utf-8?B?bGVhRldyMk5ZSUpmcVFZSjRjc1VMQU9MNGNxZFdhb3RhSHNOUlZNWG5ieXdP?=
 =?utf-8?B?a3A4YTFaSlVlM1F5d0VncHgxTFZtdDI0czhRNk5Hdjk5MjdFK0p1ZTlzdnQ2?=
 =?utf-8?B?QWtYOTB6c3crR1ltaTIwdzJWR0VQa1A0bTc5eldVbmhXQlNpSm5EYnM1dGs3?=
 =?utf-8?B?ajh1M2hkRUYxczR4RXA2MDFJRW9rM3U5UVVUZ3p0dERtdkVQSkFNQXFzWFQ0?=
 =?utf-8?B?Sk5KQ0JYYUhLWkoxaUZWVTdNUHcyYmo3VnVCY2hWelByZUtUUlg0NmZiZHVC?=
 =?utf-8?B?d1RHc1djOGV5TzQvSXBTSkVqcTNFVU9aR1YvQXYwSU5RMEhYUTBDN3NsSFZ1?=
 =?utf-8?B?dWpxM3crVVhOcWNmaVFzNjlESjQvSm5NcmFyaEZFM1pUTlIwY3Y5citIWHJF?=
 =?utf-8?B?U1N4NGNYUVMzM0YxRzJMN2dMN2RtaDBHYUorempqcWZONUh3UVloQ1VtYUEx?=
 =?utf-8?B?b2pMTjRIQ3gzamNwc25tcDVCYk45VzRrbVI0MC9LdkdzN3RNbFlpRk1NOERi?=
 =?utf-8?B?dE1KbXJYUEg0RHVjdDZkZzV2ejVvV25PMFBrdDVjZS9peC9heURTWUV4QkJO?=
 =?utf-8?B?VFcvRkc2QXVZNUZLUHlPbDB3NFpZd1N3YmVBd2NZdUpOS09lN1pkMW9NL0lp?=
 =?utf-8?B?NU1BQURDUEFlS2hyR3BnQUFydE1OWHNSOHFqTXhFSThvU0p5U1VXRHdkZXFy?=
 =?utf-8?B?OVVsZjVXRmhtM1p1KzBscXpkOGRVM2JPNDhJaDhwR0ErUHhNVEd0Z1JXbDJS?=
 =?utf-8?B?T3ZWNmNBSkxEQlBqaWR2VDRKOWRER3JveWJ1UjBtKzNlc0FSS0x2b3JrYXFk?=
 =?utf-8?B?NTQyelZGdWtQV2VtNEZEMmk0YmNUNkhnRjhLUnM0YUVjVXNKUitTSWxoQUlj?=
 =?utf-8?B?RnZmWjFkZVkvYXBVQ1pqT0tmTUVaQko0R0Q0Y21ZZ00rUHVBazVVVjlPbllr?=
 =?utf-8?B?M3Z0V0NpT05SWURCd1lCb1F6WTNseWNxdGdhZjlsdHo5V0ZKeTcxNEQydXlS?=
 =?utf-8?B?ZCtXRlU2MlNab3VVZGg5RjZhdHI0VW5MUStEZDY5Q2xnMUYzb3VtZkZnYkVT?=
 =?utf-8?B?UW4wYlpmQW40N0cyd1dPZlptc0ZlSnV6MXo2T0hMbG5GSVZQK1htdFp3Rk42?=
 =?utf-8?B?SzNSL2Z4V2xjT2RvUFBmaDUxQytIeWZ1S0pMQnU2ZzVYYUdDZFJxWjBsNXNh?=
 =?utf-8?B?VWNyb1VyOVJFTi91NUhrNnFSanNIaVBqUzlyVkVlRFdxVE5vVnZmMWRBRXNi?=
 =?utf-8?B?eFZnc3RKTXd2WnhlcHFNb3RCRFc4dE1DeUkrczdTN3NOZVhHNFlPQTkvRDJw?=
 =?utf-8?B?VTJOeWxvcTV6WWpHa3N0SWxTU0xKVGVpbHpNWmVQb3ZoSmdFRGMxS09tSVhi?=
 =?utf-8?B?ekJhVVlwSStEdHNCVEJmNkhyWnAydkU3VFQzeTlZOFJiNjdWNHZhVGk4Rkgr?=
 =?utf-8?B?NG1aNk4xM3F2UGtjcTdoeHo0NWFVSFcxSHZQaEdQcXVKR3ZJRG9nSlBlRERX?=
 =?utf-8?B?OWl0NHZVdUJ0dVU2Sk16eDRmN20zR0d2SFBFa2w3Uk5FWlBxQUpZeSttMHE2?=
 =?utf-8?B?bzFvYmpLaVgyR1FpMmdmNzA2WWpQWVUrK1JYOFI0NmpJMzhlZ2RRb0FxN2dY?=
 =?utf-8?B?dWJQOG9KeVRoZHpOUlFGc1VuNDRBeHdIdWR4WjY0TTdkMHA5Q21XZjNpbWQ4?=
 =?utf-8?B?ZlVtSld0ai91aE9pV0lHdHRyVXBiZnE2Yml0dE9OQ1JDOEE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dytOVzFtck5RNG1VRlVjMkFIeXdUcEZ0QUV4ajEzU2xrYWkwL1gzeGtOSWNZ?=
 =?utf-8?B?U1QxR0RZbVFFVkFzVEkzcDhGUWNPYTNxS2FPR2VmdHpVeEwyQXN5S082NmJ4?=
 =?utf-8?B?QU8wY2Q1UWVpNTluYzNMYUJOZ2ErTysrSVlXMmg0Y2tDYVBHMTBES2VHVVp3?=
 =?utf-8?B?V1krU1ErZXMzeE8zbzJlSGxzNVViYmk0R3hRdUJaaHZjS3NDZG05aU1nYStS?=
 =?utf-8?B?ZzZlNDYrcWF4SG9QRmEzMEJBM0pvd25NaERYenE4azNRMnZ4RG8zYXJlQ0Fl?=
 =?utf-8?B?aXNNQnVJVkhGUXJjUHhoOVBmRmN4VHRFUjBVeEFlaUswMGdQS1lTVWoxT2sv?=
 =?utf-8?B?Z1VqMUk1cjI2ZHFReGJYSEhoaVRwU2d0UjdiM3ZIY09MdUs0UW1ub3JuNytR?=
 =?utf-8?B?RmkySkp0Q0xCSmhvUVowUkRPNEhSZkxHelp2ekF5eGgzays1VlFVdHh2SVg5?=
 =?utf-8?B?WWZXVjVYeW0xMFFQcktiTWw5d3V3ZndSVkNycjZ6aHE1bVJ0WXYzN2J5VDJZ?=
 =?utf-8?B?RzJwaE81c3Bwa1k1ZTJ6d0VLVHhpM0hHNDVuQ2ZLK2Ztc3FQQXg2RjhDUTdC?=
 =?utf-8?B?WVN3ZWxFdjE0UXJUMCtrdnF5R09hWGdvQ0NmbGlEdlZlbE5ON1VJLzEwNUJo?=
 =?utf-8?B?UmtPUmFtaUVOQjgxaGFvZitBbm1FdSs3MHZQWGlYc0VPWHJhVXZVSVRIM0xI?=
 =?utf-8?B?eEtEeHA3UVpMaEVDU1hhSTZnSXlXa0pmQmtsam5MeDZoL3JjNWtDUmNBZ3Bq?=
 =?utf-8?B?Mk9vdFJoa0xOZlpnaWVic2VSQ0p3QURPTFpuU2dMcUFac2xSR1VXK0tnVzBh?=
 =?utf-8?B?T1hJVDlHVTR3UWpKUnhUK2JDR3JYenB4N1pvY21QRE56RHB0aENGYWxPeVVr?=
 =?utf-8?B?OXIxdVlGWTB0eVVTUFdjKytWRHAveUppcDBtZ1BzTFEvREdKSUpCUGMvaG9t?=
 =?utf-8?B?akl3RksyWlowem9mS0xKYnJDbDB6ZzA3dmJ4cGc2enRvSUdIMkJqMitvOSs5?=
 =?utf-8?B?U0dWdjFkbTB3cWJQR3M0WFdTbDJlV0J0cWszVE1SRXhSQmhkVUtiR0RxaUR2?=
 =?utf-8?B?MVR4dG42U0NnV0lWYlMvTWUyY2lhN2syNkVKeDNTT28wYUE2dHFaVnFIZTdF?=
 =?utf-8?B?cHJVM2k2cE1iUXpVTXQ0aEJ6OCtpNkJITkVnQUhvSkQ3SWNUMGlpbXFhdXds?=
 =?utf-8?B?Q1pJM2VjczZ6ZXlnakhJN3oxWmNuelZnNndpbnduUWxoVmZxaGNJUGljRmxU?=
 =?utf-8?B?eUYwSWlGQVVOcXQyaTZ2emlHc2ZnbWY0TWdyeFlCWUlwL2l6a2N5OGVwZFg2?=
 =?utf-8?B?cGY2bHBGVkJmeEp0V3pRYU9GbjMvT3FleWhqTHI1Q0U2dlpHV29WM1lJbzk2?=
 =?utf-8?B?dE5kcFBuQXJDMno0SnJjTkZ1K0p4Sks0NzBaN0ZId25MZkNGZnFEODVEeTVX?=
 =?utf-8?B?bWZuSjVxaStaK2x1T2Nsdkkreks2eVFQOXQ2QnpQSnFSZS91Ly9VRHIycFJ2?=
 =?utf-8?B?LzArRWZJcUUvbmFQNXZzZTZzanUvSDdXZjlHOGVqbnFyVTgyWFVURnd0ZTh1?=
 =?utf-8?B?Zy9YU1JnaTljSDgvRlpqQkxNWFMvV0pTQjRRZHhld1B4YjZKYURPY2FObWdp?=
 =?utf-8?B?bW5SU1dQdllldnZUY0I4cG1tQ1lud2JmTUxTMXMxZ3ZlSkFBQTRycW9kS2oz?=
 =?utf-8?B?SmVlS2MvcW00d0M4UFFXVjNvT2xSZ3pWQ1RDMXR1aCsvV2ZIY0RmdnhGZ2dG?=
 =?utf-8?B?dGZNdVFtKzZpZU1nNXp4d05UVFVLRXg2Nm9IbnZOSTFGM1VVUEhxUFk3WE1x?=
 =?utf-8?B?NzBLSW5ua2FkTFB5Sm5nYmJuNEJya1Mvd3ZvMk80anlQVmk3cDRTd1IrUWds?=
 =?utf-8?B?L1dFbUIzTmdlTXd4NzBmNHZQRTYzWWxkcWZvS29KYTM4c2pFeERSWENHUlhS?=
 =?utf-8?B?SXVVTkdHaDFBTDJ3N25pdWp4T1JQMkttdy9yZytRSUVTUUc3KzQwb3RJNlhV?=
 =?utf-8?B?UHhrRTQyellaUWcrMWxMVzdiODBOSzBsdm9PbGx2VUVqRUJKYWJrR1BLSVBm?=
 =?utf-8?B?b3NvL0lmbFRQMzRyNmdMTzV0ait3QkFoRW52cUR3VFRCbDIxU2JUQit5WlR2?=
 =?utf-8?Q?3IEOa4bx6MZ/f1n4BVMrUqblf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e79ed305-fa74-4efb-ea35-08dd719ef7b6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 04:29:33.5069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g/kzkP6xoNLvrWU1aZlWE5BL8y4QxkVdLw8kYrEY0ZBqKN4rg4ySWzGqfJsmMf6IpMlcrRdw4xaUXya+ew7T6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7697
X-OriginatorOrg: intel.com

On Tue, Apr 01, 2025 at 10:16:24AM -0700, Chang S. Bae wrote:
>On 3/18/2025 8:31 AM, Chao Gao wrote:
>> 
>> Dropped Dave's Suggested-by as the patch has been changed significantly
>
>I think you should provide a clear argument outlining the considerable naming
>options and their trade-offs.
>
>I noticed you referenced Thomas’s feedback in the cover letter (it would be
>clearer to elaborate here rather than using just the above one-liner):
>
>> Rename XFEATURE_MASK_KERNEL_DYNAMIC to XFEATURE_MASK_SUPERVISOR_GUEST
>> as tglx noted "this dynamic naming is really bad":
>>
>> https://lore.kernel.org/all/87sg1owmth.ffs@nanos.tec.linutronix.de/
>
>While Thomas objected to the "dynamic" naming, have you fully considered why
>he found it problematic? Likewise, have you re-evaluated Dave’s original
>suggestion and his intent? Rather than just quoting feedback, you should
>summarize the key concerns, analyze the pros and cons of different naming
>approaches, and clearly justify your final choice.

Hi Chang,

The 'dynamic' naming was initially slightly preferred over 'guest-only'. But
later I discovered new evidence suggesting we should be cautious with the
'dynamic' naming, leading me to choose 'guest-only'.

'dynamic' is abstract, while 'guest-only' more clearly conveys the intended
purpose. Using "dynamic" might cause confusion, as it could be associated with
dynamic user features. As you noted in the last version, it is quite confusing
because it doesn't involve permissions and reallocations like dynamic user
features do.

I'm not entirely sure why Thomas found "dynamic" problematic. His comment, made
4 years ago, was about independent features. But I am sure that we shouldn't
reinstate a name that was considered "really bad" without strong justification.

And Dave clearly mentioned he wouldn't oppose the "guest-only" name [1]:

  But I also don't feel strongly about it and I've said my peace.  I won't NAK
  it one way or the other.

Therefore, to be cautious, I chose "guest-only," assuming it is acceptable to
Dave and can prevent Thomas and others from questioning the reinstatement of
dynamic supervisor features.

I can add my thoughts below the --- separator line if the above answers your
questions.

[1]: https://lore.kernel.org/all/893ac578-baaf-4f4f-96ee-e012dfc073a8@intel.com/#t

