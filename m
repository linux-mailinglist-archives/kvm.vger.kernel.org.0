Return-Path: <kvm+bounces-63672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 36E31C6CE1D
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 07:14:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 36C644ED026
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 06:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA80315793;
	Wed, 19 Nov 2025 06:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="myM4TP1G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19095313525;
	Wed, 19 Nov 2025 06:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763532857; cv=fail; b=CW/vgOxDD4V0xwDL53h0ZI+Z6osM31VjYgrGuJlIRCLRwEKzqiI0KBE08rRMRewOqh9fl/hedXU4hAKrv0vXLZsWc6hNgMnqkOttbXMHHXGS4Py92q+vCqrcrpQWy/V3OI1egKJB0GFJ2BCua8mKJbmUcaXoAkLrChXIFi0Zgq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763532857; c=relaxed/simple;
	bh=/AekqzzMbluT/Y/Z+RKzXlFt6gZe+sqOZi1evh8ogHo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UJjylTqoZ0v0LC5dQr+24Z+eHZB/kbq2sQfPX5wiP5wuURa28kBbjigGmmm/VxnZi3NNJDj9jrpUw/4rxjd/uwWHFf4CVE3eGMBlzaI80k5uLRvxQvzxPetsykooiji6Qv5Y6f/9s4AMZ4iugnfGTomooOFqRTquUXGwmPZi5wY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=myM4TP1G; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763532855; x=1795068855;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/AekqzzMbluT/Y/Z+RKzXlFt6gZe+sqOZi1evh8ogHo=;
  b=myM4TP1G/4g6pNrkbBB07PbzKE/Hu5OoX6ULrOwg4Dtqtc19ORgruK2D
   TNjv/gOeVB6mbwr1aW77Q+n+CJZvmX7s68djHCug+RUDZk+0PNFuIVJ2e
   bzAIvEfP9HGRdfhC6/FCGETNOsUE1db6yJKrT0wOBxs5Gytn6Ib9ZTKvx
   hHA8uxOWcs2C0+FolK+nAL6LcZw10VWfM1IT3MPx3WJLfdaICoou0uJmD
   kuPTiuZbofByDy9At1+s7pzR4PmTJznzfNyk9Yz6ono3I8tM0Wh4xxGSg
   Gxu+3t1dMVIAzD8ZIEK4RyZAAzIxI0koHxkN9KSk8C5EFNyk/Pan4zHx1
   Q==;
X-CSE-ConnectionGUID: nD6kzoRJQeW0yavpsW7buA==
X-CSE-MsgGUID: 6hLZpTghQ5GEyhuOtUy3XQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="76920951"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="76920951"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 22:14:14 -0800
X-CSE-ConnectionGUID: DcjMNhI7TUG0OnpvN7VZ3g==
X-CSE-MsgGUID: 2+lv0wFqSG+k6U3Xfg6xeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="190761535"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 22:14:12 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 22:14:11 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 22:14:11 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.65) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 22:14:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JZwwP0DSxUcFB1CM9SYljVCbd2wuVxbT6GbT1pukWYfWHBxxeWNva2CZSWyCr0/N2+gKKiHUUyMpc1Owv5dhEmy3nHuPSCG5e3M5PM1TH8jIVGeo17SW/GY+81IQ/5TlSLShBAFWm6KTxtt7aaCr8rZftBFfrevRcqkXRxVMlQZXbwV42t7ydzPNO/z5FSw0NaiIuOa255mw+kSGIK6B0BFDrWtyWS4jHw0QuByv/mV+QQ04aLdqi7dO7sawAJAQdD8HnnYW7I28iiFVGeB1I/48LXecQBnvTaD5Y7uSM49Lpo903oZ2EE0bzjb0VZeADY1GHDwIn8nc7WtzHmr4dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/AekqzzMbluT/Y/Z+RKzXlFt6gZe+sqOZi1evh8ogHo=;
 b=tn8caQ1FUdjj2jpADSOsr6j+rVT2oJUSnsfiXxh7y9+U01XXnPYbYufE5uMwK7VBGRXmHNUXLYF2RThXqMs1/ZhRCy4k2VlPpz/jUn7HuAgwREnW72iwt3851x9nFkFJDhRLF3FFS7s1axrT6AgZwRfVKeySPK7E0OXh2Xp7CgPcoeLQTd88ucRl4W3EhSD0INKZrddkvSgh/W8nwDkYbwX2Ze6R1tn7a4TnDA4MMbSNzaltnONqZ6RYj+FxP0E/nJiwAJw1S5niQ4Pxxsrp4GrcqDYNhaC3Itj/1gpyKvGJ3Sdq9oq22k3hTokT3a72o6DgTpZ84iNEqQeiK/KOrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS7PR11MB6222.namprd11.prod.outlook.com (2603:10b6:8:99::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 06:14:08 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 06:14:08 +0000
Date: Wed, 19 Nov 2025 14:13:56 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 14/22] KVM: x86: Save/restore the nested flag of an
 exception
Message-ID: <aR1gJLQNykeMT4CR@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-15-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-15-xin@zytor.com>
X-ClientProxiedBy: KUZPR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:d10:33::6) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS7PR11MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: f3435889-1673-4f9f-a12f-08de2732d988
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?bXykwUqphvLiKtHUSY33k7dFff21m0gp34YJmtUFmaUxyQzvxMMXlVXn/BDX?=
 =?us-ascii?Q?gCFA/ddF+Hyuhy2vCX8KtTo7SHYg7w7GQYsJps14+BlLvhvZQXfwDfLzDVOs?=
 =?us-ascii?Q?7sdGqxCdmiEo6VLn0CgP9h+wY5FSBnL0BzEDtiGC40T2ZbNYiBQagULtymHY?=
 =?us-ascii?Q?CoPWQKxqACkhBFX/LML3MboSVx/nZjhDPVBHXu0sxIbdCE4SE+VJYU3W5TsF?=
 =?us-ascii?Q?Q7lAJoHaJI/mBX/XDMJhkHZV0SsXZA0B23Ix/BLzrUX07CBGrIVJCh+kSog3?=
 =?us-ascii?Q?Kp2TwojexWXBQ5lD7iWXEcBRVhcl3TWrO2BuFx2/KUBRKfC4jyVwunB087/D?=
 =?us-ascii?Q?7s9k/3vmL9Lu/X3FVBgsSAPzslVae7uLpeGQP1R50jVK2I0bxGgpjr7B4yGX?=
 =?us-ascii?Q?iz6wz+Eb8JLox6VNOyeEHa1+DUQ4BxKSgjDI8A/5gP8eV4AfZNIQTQfsnx2N?=
 =?us-ascii?Q?HWkLFpgSSOEtYyA76L/gmHN+CO6Kub4RcQ5puakqeqzJHFQQ61YJZd3Mok5I?=
 =?us-ascii?Q?FC5272FCAhbo0nmb+0uQ/aWgtzEjMTrDch2cqH1zGvToZSWOpWAdNIvQsT3N?=
 =?us-ascii?Q?RIbnuuALJQP6cET6V1/GsxqrEmGEs0QOHDnlmmTErWgzx0sEGXTBdZRgE9Kz?=
 =?us-ascii?Q?MA0FPtohqxu80Rt/p+lhae8pe54NKmuZnzlsqZ/pet9RpzQ3lY6QiDW7MofF?=
 =?us-ascii?Q?3vdJY2A9BE1ZDrjysr7vmFaQJlo+dkd7807PiDI8xZGKumuLXyPrWcoQvs6I?=
 =?us-ascii?Q?yD2bfAE8bOpJAh7+1vWORrydYwxqerms6sncKJWgx00MXJu3eSS/okszBNcR?=
 =?us-ascii?Q?3Oyg1OLIno1daouk8K9Ex3SpgXXxP8g3T6lS8X2leshR769sUl+0I4vb5lAm?=
 =?us-ascii?Q?Y+Hpyl5BJsZKHFOGGvKBoeOocA1KiD0DBBastVicyEdGYfRInDZr+YZR3HDg?=
 =?us-ascii?Q?cbGJOdQ/YWpVflPxVX5U8/GU8UesbXGFIwtG2+v8Y+x3on3/FyoStt7vJNLy?=
 =?us-ascii?Q?eUagLgc4bid9sAqm7cmUgCSH7kbe9U0VtzN8xLOc83+sEdaEJKCRCrGCG0W/?=
 =?us-ascii?Q?BIX0Jxds2U7WWkETZL95GwCeBdM+rQj8pVePuX8BwrslZGu4ybNEvh+8OQiB?=
 =?us-ascii?Q?w1u2Tzs1lRHYaVC0OVqR6yZReICjk+hGFi4jpj8oLPi80tXM1G0xmRrWuYZS?=
 =?us-ascii?Q?I43CEcZzjMsFnUhZytqh7hpLdRqsCvlxl5/S5NgGQEhp/4FOu5tNF75Lmmfs?=
 =?us-ascii?Q?UZfCpkXqkCjnGNy4ipQxL6qxHhLVd+FkWG/FTct7smH7jeGsfo4pQwzx1v8j?=
 =?us-ascii?Q?aTzY6CNR7Apwjrj/8tfcxP2hJzGFHAa40vfUC1r/Q3VOxAW/2fyweOMF7pL3?=
 =?us-ascii?Q?Ia2RL4A5dQe1TVS2akU61fwyJTPvYsUHApvCkF128112KzB8GYULv9fupw7u?=
 =?us-ascii?Q?OfqfdfqtLAxZLOOswDE7cXup7DQQ1HqD?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UG8/zjKjXPfDjXOYCfqcqM5l9gjihQgw5XVtufL8Pwut7aPwcbBaQE5oFfLG?=
 =?us-ascii?Q?2Dy9v0FwisbKoDXVVQMPpi+N71KKw2j5eArhgESoYHNjf6gQdq3E4idvA70h?=
 =?us-ascii?Q?SBYj0/5Po+tppF0MaDn4dfZ/cjbX2quNW8wrqAlxFlc4G93omcHTtehK74jA?=
 =?us-ascii?Q?XNoN8brx56vR/IZfX3dC4OZjXztkLi39y8wOpgRUairjkEyvsoVvdWgF8wv3?=
 =?us-ascii?Q?tvpwV4JXtwe2BcprRMNB8hVTCvwmqzAt/HHWiYi0Qg/sll12JwxcLfn2jWo8?=
 =?us-ascii?Q?3TMqgA6356p5Q/a1heG0Nt52AdwUc/9gEDbzRBufDDMsiCtOf1wLxvIzlVcE?=
 =?us-ascii?Q?0Um1y/mlBS2iRaj1bwGeJPH6Bw/tXfqkWmUK+wc3XjjGehDe6w0Rfpw9wW4r?=
 =?us-ascii?Q?iQJ7oFcs8Tqibm6ILPXsOiqF7ZZqawW1mFP1vHufV4l9JgWdKbF9tkSjbgV9?=
 =?us-ascii?Q?u2SlOuFnmyiZHZogoibOZQROlq6plX1A2250ZTi5QrdhVtY97DPZuFys3faG?=
 =?us-ascii?Q?JU9MRgqnF1knMmJntkhbtEXDal2VVUwwUpKEhmBA8XDMabW86hzGhGgdXaY8?=
 =?us-ascii?Q?sIQ0pX/s2/XW9coV3NTio07LeJ3pmWTNNCK8JFeSYuy89+zSpPO7P4t8UUis?=
 =?us-ascii?Q?zf60aQB2zqllZ/HkR3cMObitKF+2c/jhl5PvDMrjIpVNGIKvbxvjENl/O2hP?=
 =?us-ascii?Q?/HHrrPf1FvbjaoS79V+oJsCo1OukK6qwRRQHzpuuBkIQGzMqVmSG295K8ZiU?=
 =?us-ascii?Q?3S6Iv8/DdaGY/RsfIFuaooTLQDeJ7Rep3+txjx1cQzAzoywvamVCHKqAx5MP?=
 =?us-ascii?Q?+2Xv/KUbH0krwKHa47Ui996SCtUe/H8FeiywB8DYDyb8PJiJBzAthexgQSoA?=
 =?us-ascii?Q?D3rT7fs4KFQZgvWam2OL1uVM0cotnkRW9PUXr8umV5S/4UU/H9vIdYxZpR6b?=
 =?us-ascii?Q?RRB0GAQG0OfZFo38+c28wh3/KgnqGz3Toweid4XJd0HDGukWh0TL1xTvCCCd?=
 =?us-ascii?Q?c+XKuk6SouTHhb+SA+gUZKDjfSDczASJbw2fqx3G5XhjZdMl66x7wLadOc/1?=
 =?us-ascii?Q?ReRVkmeoDq6QJBX5po6VGn0/3t4CAkUkcjMmgztfaVRKQaApBhOV0gdbDWKp?=
 =?us-ascii?Q?oHU5vPUmdWOxas2znDTICteR/1VF9X6D0EpUp8HnNxNF1kccylK5IUB0mZxB?=
 =?us-ascii?Q?2pMXAcxHt2fHmKEYGEsn3w1Bdj5zvwsjwvInKuXY6rCeFVwQ13jK6X7QKm69?=
 =?us-ascii?Q?A+avesaASO2pK6Lal8+rrsw0O8USRZjlvNjVYADFIpSnlYYMSYsHKxCEvW/i?=
 =?us-ascii?Q?BrMkmF6NrWKlgWSPKQVkG6IpoRoN4cfVqiY0wkr2S1FItPbVX9ubcUWr74CR?=
 =?us-ascii?Q?Z8nQI+sOhVMZZaYHCsA5M7ZISUWGwiF2N4+gi96a5opJFVL20z+2Co82IpEC?=
 =?us-ascii?Q?vXygtZ7e2uynmk0/HQPAvYiWgrSUEiG30eyhwZkb6vjuVTAt3kb5dW1DBiK5?=
 =?us-ascii?Q?I0dqAv+fvO3Ifmu1o2NF0xjO/M/UC+wrQTlTy7OZU4V4bzRpcqyUWT9C6bml?=
 =?us-ascii?Q?ntvww5zc/DdxTVix8jJgr96zghwuttbJm9QWZNmX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3435889-1673-4f9f-a12f-08de2732d988
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 06:14:08.6433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ExiRnI4BgoeQcR5rTSGA0pGDRBEi1UW28dHMwaQUHT2N4L/O4NOKyRgn91d+NSCdCDRFmZwJ1mN6GmFHk6bFgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6222
X-OriginatorOrg: intel.com

On Sun, Oct 26, 2025 at 01:19:02PM -0700, Xin Li (Intel) wrote:
>Save/restore the nested flag of an exception during VM save/restore
>and live migration to ensure a correct event stack level is chosen
>when a nested exception is injected through FRED event delivery.
>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

