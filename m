Return-Path: <kvm+bounces-45694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F488AAD85A
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 09:39:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 933D716D3EE
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 07:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17820220F26;
	Wed,  7 May 2025 07:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fxZEZCGY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448A37E1;
	Wed,  7 May 2025 07:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746603529; cv=fail; b=iq67BxS3kFMQkSd0O5mjjDixU+T/0TlbtummBpG+JnV0iaAg2gfG4jqMzpajQjtSjXfq5GR5Op0nyKM5IZFIibOjkibE13oq/p2BfzpkHTD3aHdB5dGskchpPkWdxyUp+uT1KjnIVtq9ytiWe3Yeh6+nulSBemihTQpvu83jHIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746603529; c=relaxed/simple;
	bh=h/TGEiRYbhhrJ78tnDGOG0UV93TbZPy3gXVNx2MZckc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dkaPPyk5QY7Kw8aDRCe0U6S2yquCgr9p6GlCejhx+8BOIO01H9arIQ60TnkrAIoLxxFujtrlcFhpleyDRVYirt640POmt+gbhJvZauE4AnGjOl8SQ56+rYHZbwrjvShnCfitzxpnwCOXmU/NKn/u/sT7f8N1Dgy/AvzIa2xLBP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fxZEZCGY; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746603527; x=1778139527;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h/TGEiRYbhhrJ78tnDGOG0UV93TbZPy3gXVNx2MZckc=;
  b=fxZEZCGYog74QoM85kAmEppGdjAFzsS1eNn1NuTigXerTDbd8HSxMYZx
   rzEzCjwh7agYLEpJGAR64XzOoIu7qkIMJwMpXjNXBKo7uY9akDFIPhNoi
   LS+d1cc2RrTsYKnftNhNIyxT2SG+pmSc/KZyrganr+nPRO8Mwn9gRipIY
   kxEjYUaIahE8Z1k9W5ns900Gk8WaPqk0Fb2c3OdeFyqg4+ppTiIkK5FsN
   zfTZsJU1UNNhwR9RqauAN0om5wYPro0n09DZMtaS6V4snHtJKXGrvGMB9
   a4NYMKHp5X8lrswngus/Do7b5jqm1cR5TwS4XDC0cbYte+cbLpsjZO6CF
   w==;
X-CSE-ConnectionGUID: padOcJBqTcyjmIDsmH/BUQ==
X-CSE-MsgGUID: FJDJhAgAT7qMRYqkR5YQmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="52132164"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="52132164"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 00:38:46 -0700
X-CSE-ConnectionGUID: 2LcGFmiLS8qNUhxAowEetA==
X-CSE-MsgGUID: 5ITNLyHLRAiEsZIEWea6Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="135872267"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 00:38:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 00:38:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 00:38:43 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 00:38:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xeLLh89i+M1M1WZhHh/sFOohKeyHGMrAM389hvcOQyPvvKOK9pBv1HHxaYhU5Ka6thMi3Y5O7OAhKshXQQTk0zQ1FwVpp3mndiZAt7lC9Ll+5g9lOGOqQt0h5Ev8xakUMP6m1tn8D1RfDNNlYxAIX+O08mtIpCgMo5Va+NFalrH531AAWAvqPx5PyC+2mChddmmFkavS2Vp1q6oqk4SJLSYWMfV/qGB2j2Ko/ijlHJU77/YBxNb1qktfIcWoI4SqJwE1mY/yokRZg8uyEK0O+nI6KhRpk98zTuNjoKbE+4hTaTO4ZRBraqqub1EoryeNlygO0h0zREQSTkLHSF6EpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hj8eR8gupDjuy8V66Vw/nQbkANSP5Y/oblQVJa+Xcmc=;
 b=PWQZXNfq3uUKqeR7TTRCVv0JgcNYsGD1ksr+rubPDHOUtV58in+M+7YwPdzyOaEtt08JPaZU7V4XgbtNq2WEEm0Yb6CobaIa12s7kz0bOYAT7y3DmY/9BZtlgOWUhRm4xznnupT/pn2tlamyt7hsJQWNscEomwVn8zXWxJwIfhfsi6t2ncWnRPnTjNVIXbAisZDW7LDuJI8v7z6g+hOYPCMKBjanfwm9lZeL56JJIYVU9fMhj8IDa3gjGFejLOVK/zq3d3viRgDAc7oFR34uU4kjly+cxrIZERN0vrf7mOrGxYgR2vhzjdjvMlUo9Ocp+guDyyvicAJsRFF0HzIOHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB7748.namprd11.prod.outlook.com (2603:10b6:930:87::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Wed, 7 May
 2025 07:37:55 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Wed, 7 May 2025
 07:37:55 +0000
Date: Wed, 7 May 2025 15:37:42 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<tglx@linutronix.de>, <dave.hansen@intel.com>, <pbonzini@redhat.com>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<chang.seok.bae@intel.com>, <xin3.li@intel.com>, Ingo Molnar
	<mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Eric Biggers
	<ebiggers@google.com>, Stanislav Spassov <stanspas@amazon.de>, Kees Cook
	<kees@kernel.org>
Subject: Re: [PATCH v6 5/7] x86/fpu: Initialize guest fpstate and FPU pseudo
 container from guest defaults
Message-ID: <aBsNxmHE7UO03iCs@intel.com>
References: <20250506093740.2864458-1-chao.gao@intel.com>
 <20250506093740.2864458-6-chao.gao@intel.com>
 <aBpFvyITMc0WhlX4@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aBpFvyITMc0WhlX4@google.com>
X-ClientProxiedBy: SI2PR06CA0007.apcprd06.prod.outlook.com
 (2603:1096:4:186::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB7748:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c967c29-4182-4c2d-5806-08dd8d3a14a3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?kRZMabdkS5wEYixjg912mFeHrw6Z2a+WTxuBSbFx33cvDMMMxgUgvNKjRo4V?=
 =?us-ascii?Q?XlHpcyRyHyaTPibP9l0wXxEQriSiGNTjNazIUSFNSlaQzKpHnJNyPMFkVHpw?=
 =?us-ascii?Q?3UYlaWWeuiwn0MZdF/aVQj94Z6QqRUMeUzwUGeS1iUgY/Z+2YFiuIscGTtTW?=
 =?us-ascii?Q?HMNy/1ljUGQC4omCwb+z92vH9XV46IFPMoNjeDohsM7Ykn3FzBRFqIRJoHVB?=
 =?us-ascii?Q?bltOls7DLFLUzVAAZdjYh6ofmj7TfVSMxoQeQrv/jK+HpldV8mpoxeY7U8b6?=
 =?us-ascii?Q?2xVIWF+aGnQnWdgWWggP7KkTA39BmCSz20sAJZcMBA2E57ahtffuakyZkA4e?=
 =?us-ascii?Q?YjfT2/THg9IdNf1TGd8EfZnUS0AE6rGZnuFYauwkDooEdKjchAt6gBazhdi6?=
 =?us-ascii?Q?ZHHwQnxgrwUYSSBsBL9Rr8q8PPzCcJGKQu8CgGKb5ZRCdRv60vcqW7tom5+g?=
 =?us-ascii?Q?VnT0uE5VK/OdRL1cJuMPyyNh8uT4fIAZN4858T3ZwdX7rAHx4iORRMeG81cz?=
 =?us-ascii?Q?3Q1M6/Y249GpAqRPKqpUZzsdrERyzBZQNjbsmtPKThZQN69HmA1PYGUtbwBU?=
 =?us-ascii?Q?XnZ1K4O+z/oozLeYbHUiWHvE27iyocwMLPg+nsSx11uG7ybPI+Y7U2LLy5Gj?=
 =?us-ascii?Q?d3PpQ9vOpZftj8LJt++KuN7PeHLy85XijcrY7P1UUaaKmnaXVbvPOmIRCTpd?=
 =?us-ascii?Q?VUrsY+lkCAAPWfhgmCvBMuflmp5XDPnJvUtPfcA/Ww/Fd3nRtANBsAz9CGxj?=
 =?us-ascii?Q?yi7FbI13P1qLCW98HQCsGZ//Hd8cSobVYpUsn37m0jnsktGDiJSa9mEB9kwK?=
 =?us-ascii?Q?EnLWZn846e0SsaUQav3nhaIvyfacZ4YWklBUJiTt/bkxjZxRg1ZcKS0uQjKv?=
 =?us-ascii?Q?RM/jYd5anCB3sjiHnWAL07IIdVI3ElTehof7gsRK5MmGiDwXdSJueNryXTKa?=
 =?us-ascii?Q?l9dvcSJP2AH2VPRv0nPkj/AhxsACVpT61EXEtCWYx+SYRMCGTV+ZNIr+dPB/?=
 =?us-ascii?Q?6zRDOHNbqPPAgkJuMyUq/JfNv8o/O5Y64/7XaMidESDXYGiXZZQizb0+pzYt?=
 =?us-ascii?Q?0ywqSLr9eGUdYFrQfQ/8uPmkgmxlbC5OuiuBdPTa65Vb0eEoQl/AAe8/Z4Q5?=
 =?us-ascii?Q?iYkZc4JfwDWMoG9ZTWMOGckG3+lvuD6YNuaBs1+SM1a9BI+1f44rMlc3KtyJ?=
 =?us-ascii?Q?ezrZRUBJkg8jqNexsdKd5SyXr741PsL9P2wK7twK9ouKszrJj3DMXsjyKvwR?=
 =?us-ascii?Q?5C0bMpmEn8lfMq6oRnn2D5+Q8J59iU7MyEA7vIr3CfHCIPavQo/w5lBf6eDA?=
 =?us-ascii?Q?EbsPD0Ie64m1N2+TdVN4CnhAcaTwU5poKq2jv481PfFFBz636uvBJmdVaIIP?=
 =?us-ascii?Q?HJDTJhm9AR86EV4xV2cdAGOcdhuDrShtvhuYsAPCO3ERV3bBzleR0gGu+ny6?=
 =?us-ascii?Q?TW9GAL+xPsQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9/GfSxqP4U/YkJz9Q5D39JnPH7vt7Eu8fMidMMuLCQHWfumRN7cLmkbrtGrI?=
 =?us-ascii?Q?pvkPjpTh33k08iP+SC9253zexNkSsQJuzHNmE9AFvsapj7eRIrVBg2HVdDkr?=
 =?us-ascii?Q?mb8/ujArtrkcd8+NHVKIPg54OMnvvEVYWc4JUUL0oVP+siqI5KnOarGnx6d8?=
 =?us-ascii?Q?22/speGbsZU45OoCoHPlQGrGpHhwZJ5slMrH8UfuJGMqzValn/XI58UIErIJ?=
 =?us-ascii?Q?MwWwTjeBf2r3yYP1jkYsWzzfDla3RvRpgHgCR0NbJJM4NWqZ7ZjmjZKeYJ6s?=
 =?us-ascii?Q?YTqCORyhbh2evWH5DNfzZOlUF6VVG+AY/1MhtSKAYA//ADrxFyGrurJj/at5?=
 =?us-ascii?Q?PR7xBpRnEvgpML526DPSivQiu0DpXGYa4ZOvVJcMe5UeivtXEJu3Y+/E04m1?=
 =?us-ascii?Q?Nz2f8JQdOyiwqkU6RnV5WkkKQe5cngXy/0drRHAhqLm54Pa2SAKT2clSBRXO?=
 =?us-ascii?Q?D46JAI646CIUE088MPN3Moguf12wBgxQKiVFTm/jdzYNSJpU7dTCxUpsrlRR?=
 =?us-ascii?Q?VNqKnjWbYZalNlXIzuXc9Q+Yje1yHS6zEmn0mzJAS7BFYOpRxSwPVHfFTRHB?=
 =?us-ascii?Q?1ULQ4vQXxsf3qZMShGlR24t5LjBMVdvAyzdGJxPLlS1FO0ZVNLGiy5rdOPfV?=
 =?us-ascii?Q?dEfoWiw6J7C2utj4Zrs97+Do+nJoGMh4UrXeEMsPxqo0g0fL3/jE7JMWiheS?=
 =?us-ascii?Q?LYqOZHu0oJ8lVAIl9eEAr0c4lWyUB9nJbnzvsaRvSYWxjdi+KtN0XBRCmsTP?=
 =?us-ascii?Q?VHhKh8CL16fXwfGPe3vAdLdXXXBUvcLKOyT927P3TcRKXCvLGlfA+LjoygrX?=
 =?us-ascii?Q?MkUVMJGHpDl3pXWrI+wLQ+ifqc+kvqKYBGzvUbRO2MNfO9pNGu2yb9Qi9pDe?=
 =?us-ascii?Q?XZOlvWdSMgg/AmFqah2p1SWmLdSFPpba+r98lDYoGcD5kmP4wII0tdXSKQji?=
 =?us-ascii?Q?eG2vGL0kUb0ywX7sgBDOXHDfsydOxplyDlB9m1GRiSCgND4k9n0gTNhotCXZ?=
 =?us-ascii?Q?05CNYPFxKCXtLSY/ciIl5M4dWJgOG5K62y4cPiHcqm0HDhDnnyC/zrUMnCQd?=
 =?us-ascii?Q?DweDx38DQXg5HIUSKS7w49oUOnOKyJUOplLNFBGpqv3anebAUcPufUrk4OQi?=
 =?us-ascii?Q?Q7lg9IXY3VVDvAEzhprT0ta2f1ddHkqa6Usbr4f58+jznlzDPAtS4+2LwTt+?=
 =?us-ascii?Q?gnZNEafHFOVLhufHdXDst6+cMulWr4B6iQ7i/ax+H0NVzFMG/Htvo7sE9aQB?=
 =?us-ascii?Q?gGmypKgRU2ophfLWjxko+2WR7T9AD3+CcttmdAY2G+J1psyQeHQTLY1ce+fD?=
 =?us-ascii?Q?BDYOLt+ipvKKh432zRajykllSLp/NRtmLER9VO4MkFvf1XgqMVPWmonrdi8E?=
 =?us-ascii?Q?VHWrzHVOax2MR1CmaZ+8NnR7dWeyD57zJ3+vMk+2P+AOPbiZ72qhqwOfGOdw?=
 =?us-ascii?Q?UjwV3k5tXnbMOxiFSo4JyyikhI6aS+ZCGmBvKTaMHT69HVYgLVbJSdnvYm/4?=
 =?us-ascii?Q?nfeVcIc4WjlOjGHgzmY2yE1PGnnrcHU+KMxnT/J79SxBoPPRvF+1CnVe2xqX?=
 =?us-ascii?Q?FKXIaId9QfOw0iOJ3EeM0DlgK5oDt/xVp2MJdsd+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c967c29-4182-4c2d-5806-08dd8d3a14a3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 07:37:55.1954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20AFozTEFgezesM7ZurvmKG/OC4JcpD4bAPeijWB+o0LKDWrkTcqCbph9lf6Xogie6QjxQiuMgWAT8ZLwmOvYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7748
X-OriginatorOrg: intel.com

>>  static void fpu_lock_guest_permissions(void)
>>  {
>> @@ -236,19 +253,18 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>>  	struct fpstate *fpstate;
>>  	unsigned int size;
>>  
>> -	size = fpu_kernel_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
>> +	size = guest_default_cfg.size + ALIGN(offsetof(struct fpstate, regs), 64);
>> +
>>  	fpstate = vzalloc(size);
>>  	if (!fpstate)
>>  		return false;
>>  
>>  	/* Leave xfd to 0 (the reset value defined by spec) */
>> -	__fpstate_reset(fpstate, 0);
>> +	__guest_fpstate_reset(fpstate, 0);
>
>Given that there is a single caller for each of __fpstate_reset() and
>__guest_fpstate_reset(), keeping the helpers does more harm than good IMO.

Seems Dave strongly dislikes inlining the helpers

https://lore.kernel.org/kvm/98dda94f-b805-4e0e-871a-085eb2f6ff20@intel.com/

>Passing in '0' and setting xfd in __guest_fpstate_reset() is especially pointless.

Agreed.

Giving Dave's feedback, how about tweaking __fpstate_reset() for guest FPUs:

From 13eddc8a0ecbd9e2a59dc1caacc7dbf198277a24 Mon Sep 17 00:00:00 2001
From: Chao Gao <chao.gao@intel.com>
Date: Fri, 31 May 2024 02:03:30 -0700
Subject: [PATCH] x86/fpu: Initialize guest fpstate and FPU pseudo container
 from guest defaults

fpu_alloc_guest_fpstate() currently uses host defaults to initialize guest
fpstate and pseudo containers. Guest defaults were introduced to
differentiate the features and sizes of host and guest FPUs. Switch to
using guest defaults instead.

Adjust __fpstate_reset() to handle different defaults for host and guest
FPUs. And to distinguish between the types of FPUs, move the initialization
of indicators (is_guest and is_valloc) before the reset.

Suggested-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kernel/fpu/core.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 444e517a8648..0d501bd25d79 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -236,19 +236,22 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	struct fpstate *fpstate;
 	unsigned int size;
 
-	size = fpu_kernel_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
+	size = guest_default_cfg.size + ALIGN(offsetof(struct fpstate, regs), 64);
+
 	fpstate = vzalloc(size);
 	if (!fpstate)
 		return false;
 
+	/* Initialize indicators to reflect properties of the fpstate */
+	fpstate->is_valloc	= true;
+	fpstate->is_guest	= true;
+
 	/* Leave xfd to 0 (the reset value defined by spec) */
 	__fpstate_reset(fpstate, 0);
 	fpstate_init_user(fpstate);
-	fpstate->is_valloc	= true;
-	fpstate->is_guest	= true;
 
 	gfpu->fpstate		= fpstate;
-	gfpu->xfeatures		= fpu_kernel_cfg.default_features;
+	gfpu->xfeatures		= guest_default_cfg.features;
 
 	/*
 	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
@@ -535,10 +538,20 @@ void fpstate_init_user(struct fpstate *fpstate)
 
 static void __fpstate_reset(struct fpstate *fpstate, u64 xfd)
 {
-	/* Initialize sizes and feature masks */
-	fpstate->size		= fpu_kernel_cfg.default_size;
+	/*
+	 * Initialize sizes and feature masks. Supervisor features and
+	 * sizes may diverge between guest FPUs and host FPUs, whereas
+	 * user features and sizes are always identical the same.
+	 */
+	if (fpstate->is_guest) {
+		fpstate->size		= guest_default_cfg.size;
+		fpstate->xfeatures	= guest_default_cfg.features;
+	} else {
+		fpstate->size		= fpu_kernel_cfg.default_size;
+		fpstate->xfeatures	= fpu_kernel_cfg.default_features;
+	}
+
 	fpstate->user_size	= fpu_user_cfg.default_size;
-	fpstate->xfeatures	= fpu_kernel_cfg.default_features;
 	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
 	fpstate->xfd		= xfd;
 }
-- 
2.47.1

