Return-Path: <kvm+bounces-40143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7E25A4F8E3
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 09:33:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CA91188D253
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 08:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34A61FC0E0;
	Wed,  5 Mar 2025 08:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i2NEE1Ib"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D43F2E3385;
	Wed,  5 Mar 2025 08:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741163620; cv=fail; b=FxjQ04nvealyTuj66PrjDohc9BEBwiTzW1YHYcxJp8Spi7/XLLQS42UYGPyynuYGjdEbNotG+pT3zCLNtvCZ4YCVDMTTzDzUjlhWUgvhMdhUj4rFb3oZ3my8HJSfK1d/XLkYvks4IysOXAgCkPeQ979cYpvA9i/FSpGjAu3PGqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741163620; c=relaxed/simple;
	bh=do4ZkdMoZCYXfCaaLHmV5bL4uszfxsaIJexRQqTukLg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KmZi4Q7zZF1U1bIL6NXrybjU3xzF+lOY4oKggiOizSF8SENaR2IGshFamTkrSF9vlqLrrH5VQ0pE5Uwng2Epieyk+ml4fdIG6cw2n+fqQrOj9mg3jw40EHFIzXfwNqY8B1e4SSpLhUED1XvLBNwd34otEk1dHuc/BwHGV4nSMcA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i2NEE1Ib; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741163618; x=1772699618;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=do4ZkdMoZCYXfCaaLHmV5bL4uszfxsaIJexRQqTukLg=;
  b=i2NEE1Ib6NyzvkVmzac1mhhvmg3WotBgwjP3At2J0gNUS3JppStYxBn2
   wxm4TQQvQNCWnhnuanDvuzBJdPZJxpY0rkuUayJml1Xu/zXXE+6P93gBp
   RscKN3D7m3hLkBbxkkvJE03RxAfOcby8UJbqmScF3thcCAoDpvgDpe00r
   2shF/sjc+8eC9srKCBdVhaIaPOr0QaZmnQsePOsw9fxRKBVBdT2EEGUtd
   2Mwzyemw5p20BQNtXGMhiQTcD5xNPIdqAmSI61SUB6jHvUfug5k0H4MQG
   aGUGuczT68zulSg4d9VxiU2RthHL3kB2XCqgIfIKkG83fel37MB0xr5I7
   Q==;
X-CSE-ConnectionGUID: oVpd0PcRRB+Zu00/LSSu4g==
X-CSE-MsgGUID: LWpmrBCMSMKoblb+5PF4WA==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="59657770"
X-IronPort-AV: E=Sophos;i="6.14,222,1736841600"; 
   d="scan'208";a="59657770"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 00:33:37 -0800
X-CSE-ConnectionGUID: pb/qzHKySDeXG2laVIerNw==
X-CSE-MsgGUID: ZoU0mWS5SRqCn9f7ZQfeGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,222,1736841600"; 
   d="scan'208";a="118770086"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 00:33:37 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 5 Mar 2025 00:33:36 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 5 Mar 2025 00:33:36 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 5 Mar 2025 00:33:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hPB2f3dSk1GPrfvklabKFpgFRv4dN8v0cLeCHru2ADFBCpJPsU2rHZ0pNvSVmGK3CccrtheC/vS9nfTFmPHYbPrTtiW/PwSVh6YsF4z1PEnQw0qe+trD40jhZTvp+BPKH5qrk3XV3uNIv7EQZIN8+GJy8ii97A5KHa5smVILi8pENrQYXEDls9byShX0UM6MEgM/qwVVnB1gJNed9SorG8z1L9EW6nIfME6gPKPAtBAVuGZnLWBD869n5OWJuxM7QAEwAO4NlE3IW8XjsJ6fl//ESrTNBhaZatvcCO6YlQSLuSfZnEV5FAen6HxPz/puFQSJc1QrJ41BUB5YnHy6oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=do4ZkdMoZCYXfCaaLHmV5bL4uszfxsaIJexRQqTukLg=;
 b=SIx1Sg7mAFHANYUe4uQyjwvZE5rt6FRYzgGGXSYX1OU/YV6OIiD2hKhcPhkJ0/pgbY9AqHGpZ2Tq51yc4zY6fTFzBW//AgMOQv2cGKG+uBypUsV2q28wpJNixSB3q0c1Vo2JfcK/tsPadpN0uGinbYMTOS0HRdvjA6YEcVzV6KQ8DzJRG5VbrPt4glf20Uo8TyqWct96X5GgJDAHdmiCjqIuiYcHF/Z3l6jakqBV98WY64KbN2KQcDaOU/1ygQaUZ4Uifr8hqUrV7pXH3EtavJf++4T5kLbEPHmbgiHUxTrpwjvk44blguwanprEgAF33ILnJnv+LTsZXxm6MfYxVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB7957.namprd11.prod.outlook.com (2603:10b6:8:f8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.28; Wed, 5 Mar 2025 08:32:54 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 08:32:54 +0000
Date: Wed, 5 Mar 2025 16:32:43 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <tglx@linutronix.de>, <x86@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>
Subject: Re: [PATCH v2 2/6] x86/fpu/xstate: Add CET supervisor mode state
 support
Message-ID: <Z8gMK0IMWpLIkgMu@intel.com>
References: <20241126101710.62492-1-chao.gao@intel.com>
 <20241126101710.62492-3-chao.gao@intel.com>
 <866757ec-3a05-4360-b35d-5ab8e66ab6c5@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <866757ec-3a05-4360-b35d-5ab8e66ab6c5@intel.com>
X-ClientProxiedBy: SG2PR04CA0178.apcprd04.prod.outlook.com
 (2603:1096:4:14::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB7957:EE_
X-MS-Office365-Filtering-Correlation-Id: 4930a083-4033-4312-4d29-08dd5bc052eb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+hwUWWP/Haw1zf17WBiwVXxqyBicGmXKFPg62vvdqMyUsdX86uepzgMkP1Jd?=
 =?us-ascii?Q?BIh0YCXQeS619BUQUtLhSL7oH/RN6jmq54kchO0kq2OoQBb2jnbNq3ZzxHaO?=
 =?us-ascii?Q?bE/MXC00RJGY7M2tVac+tSyRYnBtN3voqqJmYvBgfg/eXIlvqZEj4n+hcGuF?=
 =?us-ascii?Q?+TkwY/H7mO9HWpeJs7YrVgHxS43jwXH06cP5qDKBM1lzRsJjwVIt5lcvZ8RO?=
 =?us-ascii?Q?7aTKaAsKXPblPugtbbNtM1qZHFa0HjHkdy/ohqbERnGzF4yWpIY7kJ1opHJo?=
 =?us-ascii?Q?6fPhGQv3lw3sxAzXer59pjJ4VXTo7XZz5Jc6+GOFT1/ECKUa+SzfK0MsmF+k?=
 =?us-ascii?Q?UUP+r1OTcD2QTWN/EYHQ40GL4cz3CPwXxtytENZGwOPhmCx+8f6D3ZfvRY78?=
 =?us-ascii?Q?g6XXcedvK39mAjBu0hjcS+/815l4qydaeWzcZ7ghVROB4/uUbHbCOqVwiNqB?=
 =?us-ascii?Q?X+0n9YXe2+ONhN7FoLD3QaCuj+ItEQGSWDKR3pSF+4SvWB//R7Wi7yMkKvq7?=
 =?us-ascii?Q?WEzdpWGxLZa6SnyYFmwfG/G7SK8xb2LBlRb6m9pGdpGOZIuItSRtwX6mYvpO?=
 =?us-ascii?Q?V+nl5/hUpJwgmjjKGkiei6RmQTtJeUmO9anG3u8CbFzf3Y78HiCVDD+LaWVI?=
 =?us-ascii?Q?SbsRO/9EvNHpiHVp5CqWj4gQU4LhsVNTOPUEeEb5lMf5we58L3llbvI6YYFz?=
 =?us-ascii?Q?LU/2fmtGNA/QPhNzy6WDGBdF0DBPtFk1kkSAYJ/b7nl0+ck8s0g0BRjZ2RZO?=
 =?us-ascii?Q?gceuGwrsjBCKJtDyiXgf5lYTKC6PLHjFu24nht1HD14Mxy4HMCmtN3J6LL/+?=
 =?us-ascii?Q?eK/Eq69Ea8n+Av0dlLUohKaxrc6txgoNeatrBS5pU5+pVWdv8cMWlCS6rNF4?=
 =?us-ascii?Q?m6frW8F8IywoIaTicUonFpeErQSuWDNgbLw+/W1xnLIA0ISSGL3EZAxm943Z?=
 =?us-ascii?Q?1KDRKt0OWD1T17+veskcuNmULU1NAAkzjRyQrgbggJHoALkQRw8LjtxDCuwq?=
 =?us-ascii?Q?tWu5NdCiFeYLxRal8JHTi+Z+CyB+HeIs0aHdkthwnPji0lLW/3eXOe+huLb2?=
 =?us-ascii?Q?yuO9IaZH88bHQnP5hiuDJ1hinY4kDQcWzJsDI0gMiAFFX9RL3F42MeyeVTQH?=
 =?us-ascii?Q?vdJ/o5ngBld3037MAHr4I8PdU3YeJvmK9eCcTa2lbiFkGK3kRrJtrwOFHZMz?=
 =?us-ascii?Q?Vl2hWLkgzyEtO3AIgmPQggf2BX74bE3yx6+quna0GxnDTjxKn5Z2kFoz/sNC?=
 =?us-ascii?Q?ZQH8ofEn2Lc84QWBu0UNMkZxaxNr9vkjdkHUiZPdXuqI7RabOxeNz96sfrBy?=
 =?us-ascii?Q?fAQ+GVv6IyD6cxf8mWWkuP+FT0P7LUSq6AN08JBtsMevRARUFk6ryxMLJN7j?=
 =?us-ascii?Q?bNZ7RGssjqXkdewTUm+lokI0PFdB?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a7htHN/6F3TSOAPlfCUebxjj+8NjdknFJpvtqQYLEKqLyUoKz9Ia20wwr2GU?=
 =?us-ascii?Q?oUx2tV/2yjFcicyyl+B8m+TpF/pPam6hLLViltPxxp0mYaoNdWPg3uCjlNbR?=
 =?us-ascii?Q?5k7xWAJIfJr9+9LvtB9BxvEhWhNCV92XZXT/E6GhPR2JDFcqp7hYLtbfg3mq?=
 =?us-ascii?Q?2pOXFX0ks8/BV3+BUjaoE49ndTFUiqw0suWCSZDUniNKnz1DvzFR65Xx8d1k?=
 =?us-ascii?Q?bb+F4Y7LrgSffweogAr8n20iZ+bOub9lxCHeGgCqcCw6kjwtN9xtOWWnsrZS?=
 =?us-ascii?Q?k2DQYDB6PYdMsy/ohcv1qkJpLpNJRn9VIPxw43KgzTQjEoHiNcikeGyADeV+?=
 =?us-ascii?Q?Ca5YlkKoFDkK31ByneLAQYycBrnUM/h02MkCvA4uoTbtSZVaO+MDik5J/0Bm?=
 =?us-ascii?Q?YV81m3rp5NPAYNlTWvcKQmFOoQqxR/t85rEKkpR4FLmHGwsWhke1CnZ4bqPF?=
 =?us-ascii?Q?H/ggYVXK006LeUj4oPDUFHdNtALl8gEn/1RL4jGni7Wkhbe2XnBEN+oS8wur?=
 =?us-ascii?Q?lFNwm+tt2Od+etk9SFbmHsKuzJ00Fugop+DHdPMUkseRrSaYKwzyRGcR18Hd?=
 =?us-ascii?Q?IGLZcw8lBWWUjV2XcaQp8qjzaHRwOpjQzoCQkLWX/oTvVRls9oWNkmReGvtN?=
 =?us-ascii?Q?rgPcQJzrWUSGhqZpxwiFq1uw7blF/nTYikz5+lUHZF9e4my8E1lf23dqgbst?=
 =?us-ascii?Q?Sf4igMcApbliw25OK7FsyibjXVNfKz2e+JeeEQiwqoMyuBfe9zPt2kHlzomZ?=
 =?us-ascii?Q?ykiwLf/EO292vzGPlG3zfClX4uzFmpDWAMSvEzVWun0RU4Ltz4Mb8ZNPhzyt?=
 =?us-ascii?Q?wrlnUazN7QPLWRhLSm2RTe5jFA+ld/ppXBT4DaT0xn31rQ08WsPZEMB2OEnn?=
 =?us-ascii?Q?5vUiFui3PF6bGkjx+r3PTS/NvTiUZxz3y44KmFtrLEZCWYH8WZYK60UU7v3B?=
 =?us-ascii?Q?ohGuDEJO97lFkSFIZKwfFa1mBNjn+sKNvhFT9s460e/lHLFaG+JGNBvZGToF?=
 =?us-ascii?Q?dh4TIX+qyr+hmv9/M+r4oFhLO7DthXXvGznxI5dQKoAqFYAXUO5JnSEQWWyS?=
 =?us-ascii?Q?fp1M3c1YUNqaT0yffSddhQak2/iogRbdU1M58G8nO9cQK3qtMTbkvTaMpvQs?=
 =?us-ascii?Q?vZXcDvFW6STB3FFJadbnzaFOg3vwcQNXCarWs/N/iU/pCNwst8ngUDyFpc/h?=
 =?us-ascii?Q?XQ/6zBJju2+dG7xNyGCXbbGeBdjsB01zcF9dWYc7Zf4bkW1vGmEZUBEDlaGg?=
 =?us-ascii?Q?wkp5bQCVpWiDvz6M1KRgOrDymw03P6mZUL7+zibkyNvWvzkFT5SMwgGTT14B?=
 =?us-ascii?Q?R7LDO0ZxNqp3I1bUadUtPaCNgJM+1WXMIUOV1s1RC4c69l33//rxsgB5luNU?=
 =?us-ascii?Q?AqmWgCMDmdegT6BiTYXg01vGJthn8DRfKj/oyTkLfU/mxIz+SRNepEp1AxIo?=
 =?us-ascii?Q?1MJ2gYD24Yq+vR1DJ1Hy3+baiNp6Eabbk+I5pM81qCUzEC7yeKQAguTLEeBu?=
 =?us-ascii?Q?JA0OcbIZHktPKltv0PlZz4aoQZuF4DTb7jkjm8LCNRV8s0OOQAdSNpaPJ4gn?=
 =?us-ascii?Q?v+NL4Krtaw7Ov+F4678D9vDvvsrAMeD22oVQiHj8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4930a083-4033-4312-4d29-08dd5bc052eb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 08:32:54.1477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +SfWuyb0L9EzLSJT3pBOTrzCrRT6swPT2wdXBNTl2I9VOOEuVvexUBFz8ISBl5lPnGN3Mggzc45MQIWNgprBNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7957
X-OriginatorOrg: intel.com

On Tue, Mar 04, 2025 at 02:26:01PM -0800, Dave Hansen wrote:
>On 11/26/24 02:17, Chao Gao wrote:
>...
>> The alternative is to enable it in KVM domain, but KVM maintainers NAKed
>> the solution. The external discussion can be found at [*], it ended up
>> with adding the support in kernel instead of KVM domain.
>So, there's a lot of changelog here, but scant details.

Let me refine the changelog to ensure it's clear and concise and includes all
necessary details.

>
>This patch enables XFEATURE_CET_KERNEL everywhere it's available, right?

Yes

>So, this patch at least wastes the XSAVE buffer space and doesn't
>actually get anything. Right?

Yes

