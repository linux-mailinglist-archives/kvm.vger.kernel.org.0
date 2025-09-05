Return-Path: <kvm+bounces-56911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94CC8B464FA
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 22:51:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56A90561537
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 20:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E78BB2E11D7;
	Fri,  5 Sep 2025 20:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I9HN62ku"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1BC279DC8;
	Fri,  5 Sep 2025 20:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757105463; cv=fail; b=VKvopS8zUBDNjIzFMnuZik+1QrZaC0V2Z8Mi9UB2aL/DyStoef3Q5CLiH2EKApvfBxatNDK0Bp5CJNc+C2TuQYxdJN7LeUb84+Cj+w0ZBExypyCZxuHZsyuB9m+6QRFoIOC0eUmY9sinBEVH4iPfr5PwqJ/MPMeOrDvCGe3NFpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757105463; c=relaxed/simple;
	bh=GV18EBMolMZk3zwkgaANi9AtHeh34Ss0Xxb53w3BTtU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AKJJtE0U0nkQduYHPDxBYFf3154wx/pmvKgCD6ewAgaK1hmWQH6FpD2lD3/yLgAgkmf+VXKSfgX/stxALVhwSpP9GL/u4/eAt3MvzZ5/YMQVj2H7pz9MJ3dD+9X8C2bepmaY1eWR+V7N3qCDPVFv42l7FjvHgkdcMY87qWoihG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I9HN62ku; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757105461; x=1788641461;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=GV18EBMolMZk3zwkgaANi9AtHeh34Ss0Xxb53w3BTtU=;
  b=I9HN62ku+KHYmRaUj1n7hubWlmM9dfQT2r/7qM9H6HSJxwigKEtP6Vn+
   2eMebiPAoRYQh7FrLdjOvuO3w6HpC/Wepj8V4VJCApyOqGe1INRrZuele
   atObg6s4VcMcaP1Yy5R5AeC91yhzSMEFkHZyYGuiD8qRMIDJkb9eC6ErY
   Ddj87DnUDNOZzpN2HYJ9onWyC6pIe9rbdVdYmmkk87kEkY6wNgxygyJCr
   zXN3dTfCA8MfqcO6HStZn3bZGCbRX+U2X5lwknoQcBHx2WfQd/K/dPTQo
   vYUgCiNAX1Ld9gBhPS9QwPYmK7HpiE91RmHUW33Xpozlh0IMfIZjKmJmi
   Q==;
X-CSE-ConnectionGUID: hhFeI8PoS/u9u2jcjSzyDg==
X-CSE-MsgGUID: 8btKtCKRRsuaf/CabuBK/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59529616"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59529616"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 13:51:00 -0700
X-CSE-ConnectionGUID: 769kfy+sTzeKyt4GgggzYA==
X-CSE-MsgGUID: VcfgkrgHQsii4JFOqwIaSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,242,1751266800"; 
   d="scan'208";a="203182004"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 13:51:00 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 13:50:59 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 5 Sep 2025 13:50:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.82) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 13:50:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Luy4Dj050vxVZzgC05jaaf6aKid0yXce75R1gW6Dfa71jVVNZmit3MKb6qP+cLYvZU8+cVa3vvuP+x+tVcqA00Bo9qWqFbJCPw61Jn9AIgQ4e3nQI/O0bA4z5h4HrSwybw7FA5qurPrjLND8tNzQWgA1N5M/3j8yDdyV4Dm/WObpDcXe9BLcHBmubEOKK24f0q2xQVsETLw/KWSOtin83jQoTfvo9NGiiSX69n2a3zCLkwu7IzHxvyAZvTM070giSqs9nLj1raOLpgwoRkHzNNqpfRpiX5RcB7LHdd2ZyakGmEH9ii6ysnVQW+3cIp3ORajkKY5S24lBlUnS8vWTzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qOigZ1mqAgYLHH9cNNipm0ggfHhZLc4Ka+qtEZ0+KOI=;
 b=IMksXN2DWdImVmZ+/i1FH9pXAbtquTbgJLrlKaDDr3Wzgdnpefqy1FRmUKNENWCzhqnIQqdr7lsk0uGxTyPdsEBDAYqXvvd+wWAVUEj1QRpjySQQ8jpQBS8H0VOiaSCYvz3MQQuNNG8c0ziONcLaw7cLrZSSBYEPzcxWSVDdFLqpH0uTWeEAITn4ZOwkdH19hh+4rp6KNjG3Pa7uYbtMa1OphkI+cZ5rOG8K5JsN5gKbYYHW/1RVo9KTlzc3axajwT/MXJ+hlXnclFxLAQZFxu4OquH8mMgCqwL+1lEWRDsdNv9KtbdXtogQ++GL1kAgh36Rv97GfATbu0fBOJHGxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS4PPF11E6CAE14.namprd11.prod.outlook.com (2603:10b6:f:fc02::c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Fri, 5 Sep
 2025 20:50:57 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 20:50:56 +0000
Date: Sat, 6 Sep 2025 04:50:45 +0800
From: Chao Gao <chao.gao@intel.com>
To: John Allen <john.allen@amd.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 5/5] KVM: SVM: Enable shadow stack virtualization for
 SVM
Message-ID: <aLtNJZo2o/i9AyqX@intel.com>
References: <20250806204510.59083-1-john.allen@amd.com>
 <20250806204510.59083-6-john.allen@amd.com>
 <aKu9VfW0FF5YeABi@intel.com>
 <aLissKgzL8fX+tXr@AUSJOHALLEN.amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aLissKgzL8fX+tXr@AUSJOHALLEN.amd.com>
X-ClientProxiedBy: SI2PR01CA0039.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS4PPF11E6CAE14:EE_
X-MS-Office365-Filtering-Correlation-Id: 8868f3d2-4d7c-4e31-91ce-08ddecbde935
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LNSeE6UfwyS2TTpZJetD+oKQ/Wduo3gLTURRV7t6g9b6D9kh/MvDP+QHD4ac?=
 =?us-ascii?Q?C3j1t9Ne84exY9SlPbHIDZdOBLICv3YC6Tc3IOuDItwojevmSP+hFu7a20RA?=
 =?us-ascii?Q?JvAauKs4RuM5Lbcy9vnJce3PuHxyPQQihv9ma7DY+AS6H8rN/y7TvbAi1sbH?=
 =?us-ascii?Q?76clGJZqUS/lKomQyHyq/BZxiumKdpl7iUOutPQSrNLaBKSDH2fWHpw4VT36?=
 =?us-ascii?Q?V97v5HCbVs3yla3p+9Ebx5cqLk0Hvm7SWvUi1rSIROfNG5Oek6xR2hCYWVCa?=
 =?us-ascii?Q?NpOjMLKHzVEdx6+Rn0p07T6hwQ5U+5DStlljE/UyaLZ6uopSXM6yV7JAzSQY?=
 =?us-ascii?Q?dryqO3DcR6he+AtOTXlJ01TsIX3XQE3zxbSD8O0SVX1mMFvAAZfJ4qge3WYU?=
 =?us-ascii?Q?XD/YT545n7O4yPGhShx+igcs/j8tNIIEBMrCERjN1uvJWWPc5yw6TAj4BwNO?=
 =?us-ascii?Q?01usLaOa4dejElUdIMInCcFm2Mp2fIZsVggf4jgpJo9XT3dALzU7TPChuDHB?=
 =?us-ascii?Q?KpHwNHlJe41gB14jn8JuHuqgwpYUozoTM3CmKtbiC2BjJTAuUI6XFTIFJF8z?=
 =?us-ascii?Q?bPsxemKLDpuctBUQMuU6YSRPmay8Yix4g4v/l3GcyOpcBL76o5orVU0ETHJj?=
 =?us-ascii?Q?gspRzg53oIREhcTn6CpxpXR87fKcBie2yJIzJqZMFayT/+WqfRUM1g/yftcB?=
 =?us-ascii?Q?9rxqrlo4e81JzR8EqL5DKcay1Nm+w6vB2y3cj+lPUXR+CZp4TD81A8sesnOb?=
 =?us-ascii?Q?1ex66WeMa6rjTGtmhbvMqUlVZjONiRUwCfg+9HTIMUDrpbkbgjNdsxgcnVF2?=
 =?us-ascii?Q?lPK/JZcn1aNzKDvu52/VT/JK+wgDa3z1nrtzcpytLj0dimAAh3ofzYvmqc8r?=
 =?us-ascii?Q?Qhw/Lnxryu7+WKoujKInsD116MrZ+OKaQ2RwBfBxdumpzxhyRAn8ySOZ+zk+?=
 =?us-ascii?Q?ljoEL4aQuSeN/6E9nrjdJz6KR9IaOTJlwrd/w4nec1ytz8dENzLKHp5l+R42?=
 =?us-ascii?Q?lDoGR4hKYjNJueNJnTFbsu4b1FfTqx+1/MCBwug1+XUPzIHR+CmrnGUqJT8m?=
 =?us-ascii?Q?focCYKX9miRBkhzXjgBtTQWdYKB2j3twO8B9WiV937IrDZqXrK188r5EbcFr?=
 =?us-ascii?Q?35nIi7DLIK7ndAhy43zAW03Slbx1Rs8GhpeVBW93FOrUalvqVFtwMzRuo7B4?=
 =?us-ascii?Q?I+HKnv5Zc+tn9jbu58SZQQIS7wl+UPYTg7H5LbRCyUnyJL8F2MvkpAywHLH8?=
 =?us-ascii?Q?4clYpxyerp2txoCPM+HC4ECSAgeEx7RO+GCFn4O0tutxDl0TeRY5/Bqr9o6E?=
 =?us-ascii?Q?rfopwCwo4EulgpTa/TzfDJLzav+PJN5hKSAfRsoJ89skvKOmqMzF6+TMez1m?=
 =?us-ascii?Q?kq0ZEkeSBb77qkToRyGATg3bmkoIfYwPvbhSKdY0TVh86mkNzCEEXKW45LOw?=
 =?us-ascii?Q?N8getZgZp9Y=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o2YKyueXCfESpY4j9MWwgW3R9BMThDsdYYUzRZ9CXJhf7e2jha/QmpzrjFZi?=
 =?us-ascii?Q?p9kMdM/4mUz8jEMXbLAFUzO32gAh0E3KLLVWaiSv0DuseCP0iXUj58mQWXHE?=
 =?us-ascii?Q?5GRYfvof0joGbau83xhVRASApLearFr3GWgjlImVPO0ka3VAic4QKhjtPu9v?=
 =?us-ascii?Q?R3voiWw/CmIwhMMb/rW4hvi2Z1Hzz+fbxFl1E4ovIYV2LlX7EKZcdQyGH8E8?=
 =?us-ascii?Q?RgDFRg/Hw6w9dtf/4nNEIlNX6DGZwkhsivehhz0r7TKq5n/NOEkVuIWAp5QO?=
 =?us-ascii?Q?WxKptlZ/4HnGeitpKOq2FANAlFIAAIG8Qwbpd5VzncpGLe7FRXHxdnsVD7Jl?=
 =?us-ascii?Q?EqADdxwGeInfXHO2laYSpUpUcK6QKonCd6Fy4yq0ERIBX+TrGKNDFBKr5Q3N?=
 =?us-ascii?Q?YHFt2Xze9vH7hjFKfKyGcff2xbEb2maPDpPk5beBEAYFlRVeHnrgG2NVLLQ9?=
 =?us-ascii?Q?5HPfvkmVhuC4YP339IDWAt/F4SyEp6XtzAzzosBo2IFWoVfA7SLyu9s2TBhr?=
 =?us-ascii?Q?gQX+DB6Cn/PHqBY7bueiMC5pPN/6RMQDY+csMdi8GbEhdEC1hYygRxsgzcHT?=
 =?us-ascii?Q?ODisdiq8mYAg9eivaLrSr2TnXXRunS+w4Gy8viJ2u18NDS9+QgOos6vENUqs?=
 =?us-ascii?Q?XoxwC3AVpA5UVU0iE8I4JC4CwofObD0ZYXOuYsanrpSH0rT7J2/YkYuDH5Bg?=
 =?us-ascii?Q?DMHObM5vZSMF/+kAZNvVYlYl+z5sPWEhdTwS3qVxYIoUQuNoZRpyzJ4iULF4?=
 =?us-ascii?Q?1IoB+wSPXk3N/3l8rRu/YFCMmOFJMbSSnxKbZOtBEgXPuxQJ6HYP0Igegpk6?=
 =?us-ascii?Q?iq26WT+p185nAXJvpa0XaevwaslCAc7OmIwXVTk8J4QTCi+KiNX9b7cgUMFa?=
 =?us-ascii?Q?yAxYUi7acrr6FqCkPp9BZo/ZKxeP8Nh3qucWcBnNi6MTelPpmRAO4dGgM/vQ?=
 =?us-ascii?Q?iYigq5olZMhW/Vqvt3T86ckans+5Y4xA6A36HRWDlBkT1yO/Nb4dqsmemC/8?=
 =?us-ascii?Q?ntt2n23rhlGyxYKk8DfVk9XyDpUTTHjfgW6TL85RWXM1ZrckkOO8Vg2ee4TN?=
 =?us-ascii?Q?kgzQloSj8BaGgPkRoTTdS5c5r9BheFWVYXlxVbNAiYdtO4gaMaOelnQCy+Q6?=
 =?us-ascii?Q?tumrm9eP3spflExvZaymvxQEoXjSaZIGj5oBbDgLpKnH0lguwWtJormFohtQ?=
 =?us-ascii?Q?q+wm3euWfsg96uiUq0RYghMOzA/0ccmrY3yo1Gdn7fioiNEOLX29RUCJRYBs?=
 =?us-ascii?Q?PBhbXY6M+8QUcpYrGeZmoHsvTbTtDAEiIsux6OsPDDMlhHB/jz3LbubOpG+3?=
 =?us-ascii?Q?PdAaYjeuycebJoMqE3uK7or6x69uTnlyHCbLM3Iz/SSzMWuVL9rKvyc1oRIs?=
 =?us-ascii?Q?W3TH4vYMifZ7mTt+D1QQH/M544zdmbaPSP033iwMdMVZRamefiukP2iCslnJ?=
 =?us-ascii?Q?kqf77ihXlw5A1Scav/ldoTWh1uQE2hQ5pvCRuNV9VlIcNlgkGJVJFhZdAlHN?=
 =?us-ascii?Q?JYXQoOSfUf6HqoXc6z2arHEB00yekoWK7hv6gFxsXTrFJzevnzxNRVGp9pfx?=
 =?us-ascii?Q?0nkoOaM+KAHT47hwyzL/pNROTZM+6R0V972WxoP5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8868f3d2-4d7c-4e31-91ce-08ddecbde935
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 20:50:56.4674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oQOED93Gq6/tgcqWed8po4AHZoH8tdXkG5DFOZETN4VN0g7oj/Rwwx/xuNEouBb+epsBkR6HJcflNvdrBGtvAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF11E6CAE14
X-OriginatorOrg: intel.com

>> >-	/* KVM doesn't yet support CET virtualization for SVM. */
>> >-	kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>> >-	kvm_cpu_cap_clear(X86_FEATURE_IBT);
>> 
>> IIUC, IBT should be cleared because KVM doesn't support IBT for SVM.
>
>Yeah, I wondered about this. The reason I chose to not clear this is
>because we don't explicitly clear other features that are not supported
>on AMD hardware AFAICT.

Your series doesn't enable IBT for SVM. If future AMD CPUs add IBT support,
this KVM running on those CPUs will inadvertently advertise IBT support.

>Is there a reason we should clear this and not
>other unsupported features?

I think they should be cleared if they require any KVM enabling beyond just
adding the CPUID bits. At the very least, we can handle IBT correctly.

