Return-Path: <kvm+bounces-16676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B68C8BC841
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:22:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FA121F21B17
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3314128369;
	Mon,  6 May 2024 07:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kas+dt1v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C731EB36;
	Mon,  6 May 2024 07:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714980115; cv=fail; b=DqVdBVitZClj7Jsq+cHwIlOURZ6rjogL+p2spfwWxfIvxDBmJ5A4Iq1FwhjtkTdSeS1l1ARZjt9RUwV9QBIcoizXP3rrSDoxcuEE+9F4uPmfd+mw1jccMHFKqSusz7M0X8UiRIE/IBLH2FadaxlT//x347kBxCRYitSFYf08WV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714980115; c=relaxed/simple;
	bh=xy3EAJ5Sy6sMCHGjLYPvLRFWbYklG9/l8/4uTHv8erI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VsCpJKuP1yNEpskAZZvMJeliPZgcDWL//JkLgoiWLYgiZufMk7IuJC+cX67mok7PigRCx9c0FvNCX/gLOgRRlPE9Mc2UH113Bh2AtKpKfTPrTmErBHEGbMemQBAanLg6ezObbK+Fpd7SHeTNihy+sQhKicKSQCXZAyg5gCkGLjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kas+dt1v; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714980114; x=1746516114;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xy3EAJ5Sy6sMCHGjLYPvLRFWbYklG9/l8/4uTHv8erI=;
  b=kas+dt1vFqFw4L49n4FUiBlKppRUR8CGLf88HC7bOr0u74ba6FdHdUpa
   qncC/iXsjSGAjuwF02HLrb2TNKDDZh8X0Wp4zDdhS9AuKKGyGKcGcYnje
   TWkcehTwnAzJ0UjhDIIJNn0jHf2FefLGNDVWX6N+ueJK0VIG7TdQdLRph
   kVxb6v0RJr71g0tCW3dZfwQSlMGyNwpAPi79UDwnGItFKvl1qNY9fPjQs
   B0gjoiKjWr/8qOZ7vec6WTHucN0MnQTla0TMzzjc+HzniK0unXW7+oLgN
   6oxaN+O+fl0ZxOnxVdCCrRK4pC5PcpqIg8imANdsFye5rAvCoGTTIFe2Y
   w==;
X-CSE-ConnectionGUID: MjFuEh3RSDCrrqsBOiZu+g==
X-CSE-MsgGUID: 1qBRKMy7Q1+wW66GzCtiOA==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="13657328"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="13657328"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 00:21:53 -0700
X-CSE-ConnectionGUID: Z7VYopUER36wUzZjpTSk7g==
X-CSE-MsgGUID: Et7LLT9QTBOu2LzFmk+DfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="28163712"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 00:21:53 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 00:21:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 00:21:52 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 00:21:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OT2a7PT+CaSuIVrk3Ur+XXNxB9rfzVAj+ccW5ZdB5zoDqNIN0Ii9JA2jhOSSJ2/8E2vQGPQxUF/FWnQXuwfzcDo2f5hwum4cBaMOH/vXbXt7eOXwaGFeDN4p2SjE6qOQGP+/rWK1bAIyDqAzITbW3kVZ9ul3J3DmKWoOFGmmmeSyP5mQHUh8Htc4TL4DppYgcnwncC0kZBCx1fIuHAARFu8pswrsjxLaiznYYUaro4sZ/cNPXpa+UylwqzpiOTdBzAVysGuzkNFdlm/7NEiWWHi9hApKsqEzNKJrspcRzY5MwSTpLiBYwveViyDDIfBzBtQpTvzwLsNFK73Gadf0QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RZaQin7Qs2xtaZNlIObImCJpSBlvDcBMk329aZuyvwk=;
 b=a7EnjKJ4gOF0R5m7BtapYN9G3W3K8rAg6mis3GI4LLbHI5rNpwCUr6qy2NJiKwHoYLkqthC7ScDyb8ULkXi4gKxHHI3VueuSqu7OxTKqT9H2n0LKhnZifhpOjASzZJhzNln/GmGd2oYaWCwhmUxK4ZEVeMFPWSqN3xnyzTrOFC+iCgo1HoHslGekvHqSSfn0RCI+g46bqOjhscMBWocIcISu3nwZl6cf8UblouAXYmF/pwFqdmSZA1oW3YQwXZn5TyM0VX3If0CM1LXM6nXkuI/fOKM5m/7CFeIos7AsOhUR0pAZ8ruFh9El+Z52q18BU1QbloRs5R23LMZulclG/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 SA3PR11MB7582.namprd11.prod.outlook.com (2603:10b6:806:31e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 07:21:45 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::e2ff:bb0b:e1cc:b58d]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::e2ff:bb0b:e1cc:b58d%6]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 07:21:44 +0000
Date: Mon, 6 May 2024 15:21:28 +0800
From: Chao Gao <chao.gao@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Isaku Yamahata <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <erdemaktas@google.com>, Sean Christopherson
	<seanjc@google.com>, Sagi Shahar <sagis@google.com>, Kai Huang
	<kai.huang@intel.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>, <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 101/130] KVM: TDX: handle ept violation/misconfig exit
Message-ID: <ZjiE+O9fct5zI4Sf@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f05b978021522d70a259472337e0b53658d47636.1708933498.git.isaku.yamahata@intel.com>
 <Zgoz0sizgEZhnQ98@chao-email>
 <20240403184216.GJ2444378@ls.amr.corp.intel.com>
 <43cbaf90-7af3-4742-97b7-2ea587b16174@intel.com>
 <20240501155620.GA13783@ls.amr.corp.intel.com>
 <399cec29-ddf4-4dd5-a34b-ffec72cbfa26@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <399cec29-ddf4-4dd5-a34b-ffec72cbfa26@intel.com>
X-ClientProxiedBy: TYCP286CA0138.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|SA3PR11MB7582:EE_
X-MS-Office365-Filtering-Correlation-Id: 926e6271-6615-49c0-5f54-08dc6d9d2aa0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Uyv6n1dpxWPb8sxCTCssge8MNd+s0DDFD3IIuRjN56wvy7lpau9v7wUkio7V?=
 =?us-ascii?Q?/NcCffC7QmkerrB19GVpZhOcsE2BhsYgYwydF0PjGJ9xnEoczoH6DcRlkmmG?=
 =?us-ascii?Q?aoGMDx76dnU9Ei7lEQJNi/fPDb6ezGJKBiDaWGrEwwznjQgrAUvwdZd5wflQ?=
 =?us-ascii?Q?CdwqpfRAcGjpE+9PlORzY+fal679QqE/1VcX/yPx4t10cfgaS1dKXygIvkXV?=
 =?us-ascii?Q?fwXdwTgpz/qOdgEVP4mF1im4MQMnk3zkp5mS74tQX2j8H6csq2E5/NhXHaQu?=
 =?us-ascii?Q?f9gDpqo6ddtM+NhUeJcovpS8wWxBc05tawdc/jtakJjkMTIXEYVKQsAlOAjY?=
 =?us-ascii?Q?gZk5+yKPgP/2QGr/rttVll0WQppo9f9tzALp1LTWwU5ZEQhVOqoCd3c2DItT?=
 =?us-ascii?Q?Eqb321+2gx4B0HoK+mIIeGBi4nrkihLDUgivfOpLUmJYUfAX0qlQsmxMyRcq?=
 =?us-ascii?Q?lArm/AFitdELVEj2kI4rXNkO3bc+id8jTiyYnX19dTccpn+1X3jqk/HVHy68?=
 =?us-ascii?Q?4kUWYK1r0JWFLsGDEA62mgvOzJVonnn/VKHxErECk8j/WBrsU4id6GYAz0X0?=
 =?us-ascii?Q?T0GYjHoX8JxpvzjPFmqMPzD05P41DrLuXeiv3PMq6Y6xoK1uLTYt613IUNk6?=
 =?us-ascii?Q?Zp0kfbJtmAcvfp17wGXc+tmCJhWI6YgFaKavN1emyy3KwYI8HhD/9yrolFjx?=
 =?us-ascii?Q?mY6DVW3B+bmj2mpZ8zz0ag1rjKqeCtFIKm2RCLZfjARVE2XgKOpPTwXzkH0G?=
 =?us-ascii?Q?wgdxl26K6u1aHTRbEiubGf0u92zxjGotJBmqKp0753IUQT/JYRkSkR015ejy?=
 =?us-ascii?Q?+WZfZMiVazuXiLUuw2C0ZsAf6sDZ9n40zBZWfNTAGY8K+LSXJIgd1H7PZHU6?=
 =?us-ascii?Q?w4/x5glxJsxapykSBjlaVc15vfQfMb5ktGAQ7EtVyt1RbmWr37trbhZWC6oM?=
 =?us-ascii?Q?AXa5IhYsjs1vRBSSLFXtL3pTR6OqAUB3oBIANY8MrwK9k1tKuYSJYd7TDL/s?=
 =?us-ascii?Q?tF7JTxyoX/a8eUsEgUU5NbXV+refR+f6NN6f2CIyW3WtBKfmIza7knzRkP2B?=
 =?us-ascii?Q?6qLj5IT7IDzwueBZQWwTW1kZU/yfYm1x0WQ3FKjBVOkHG5BHRztNKoMkh0Bm?=
 =?us-ascii?Q?vaAT0QQfADFgC+JH78ZPTHnClMRK8RVu5fHia6xSSEU5GavLIAA6Ch2L9T8J?=
 =?us-ascii?Q?QCPRfg4ikcjK8QUjeCwKUrk49+37lV0+wwarVKD6FyuPB4OvtpIKcAHnx/U?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qyxF7beS2NJjnX0pVUGLoLuMiO8N+v8XUPzkutb5MsfAryGMfiaZouHsuwAu?=
 =?us-ascii?Q?Oxdhm0XJbksU1OJ4N9pKk/ep4oFmmNGnn8Gpmr+Ie8U2u/hJ4VqCT96gtUom?=
 =?us-ascii?Q?OiROTlmjKZdRTigQmNjm6DyXpmAbp/NKpVkIZEMpfFZIi1WN4gI0YS+XsWfu?=
 =?us-ascii?Q?+DVb67JKBo0TCax6oJ1ZXEBk2SPBPLJs/Xiy3RKLpUCpIFRMl1ZSr9WMQ/Mn?=
 =?us-ascii?Q?2sKc7V9KfPAarszYswHwwsNTCNeqP9936D0JH1D/l08E3jnJVZMltHHhY3JI?=
 =?us-ascii?Q?VIKCrSqZE934AMPfOnvQ0RozF2yWscT8zT3IrKF02Fc8W0duLSX//+cSi4Hn?=
 =?us-ascii?Q?+6hXUTKAaH4gfUOStF3Xy0cif82cJ7pQ/7j8GFCoaEiuUx6VvAQiFRb8v7tk?=
 =?us-ascii?Q?RuauzK6xvzrZaeR7x+0nUezLJApzKqX+mOEuRRLpmcvndHDLAr7ewV71C5UP?=
 =?us-ascii?Q?AHp6Kx+mZFI0acJ2fdiox9z4cPLXQHsF+Taai04Y8j/+NL5CSGvn4djl4a/3?=
 =?us-ascii?Q?t0jsbsUo1OkNia1BE6ODzTIxfnppsDKakHtYkeu128kd9SvOL/pbc0bBQ8Ne?=
 =?us-ascii?Q?J7NRCwBMyAvE1YxGR/mfGLnNhblwqYLldUXEaIRO9oNBKmgT/flUmonHWMd+?=
 =?us-ascii?Q?bz9R4+zRRJ/qobCs3whaCO2jft/fkPkkSjVfrYtitPE7Q+xX5NZtVEnWIcp7?=
 =?us-ascii?Q?wYqOHaeedDRkNRyC92l+H4+kuTGa/Hf63voy02tDu0NtTbIwDSMrnQR+W5D0?=
 =?us-ascii?Q?0LmGO15GEgbrN8a4feG+YchYTUs9zbvqyI7MMrVAcf+9Kl/BPsYRjcnNxm5m?=
 =?us-ascii?Q?OuwLSP3L8gSOpwOzcq816Cf9s4Blx4SlqA9+kC1lQG+UbV8RGCWAQVptKN5b?=
 =?us-ascii?Q?D/8CWsfoeFz3UKfS/DfDNF5u4RFZY4zngnDv7o0DqN6ZnPxkWT2P/jM6thrc?=
 =?us-ascii?Q?RsYc7opJJpn3XpqN3ITYGD2KfR5PQDRUMngzGa0NSUAN3xGipMG+ph1ZsofV?=
 =?us-ascii?Q?U6vwsrlnfJqgMKPD/h06uto028f090GWp0NgEM3eGIpeGTlBoHY3So0BhAsr?=
 =?us-ascii?Q?Kc/XpWWGoT0uKfFtPwvJ/n2nHhVdCY+7LP+DkqsRyt581cYhn+zt1NwNooZm?=
 =?us-ascii?Q?uXuVlOqsWVnwt7SP83s24ol+bQ1/NqviOl8e8xAWUhwquIHByiFVVIK2ri1n?=
 =?us-ascii?Q?5AsRzcXzflv5ywp4YUdzRcE7yzWf+50cjB09tZV60B6QoTcsAzTzLra+ICn1?=
 =?us-ascii?Q?9vjfnnKD3t5iEEP+Tr9HqJ4sdhq3V97w6noP27kSdAd3XuktHrKn7xl7wTkE?=
 =?us-ascii?Q?fWehiYPkHDnrcyBDYuO+MU4whPPAVJq5pez0ZkxUm9v19yxpqFIAcdqcl+wq?=
 =?us-ascii?Q?n2WrvJkjhxzXRzeOInHvbHyIfHMcT39eJ6p7rGtSXJgr41P6HWLbJMCqTOQA?=
 =?us-ascii?Q?orCsq9tKiunm+gxc8ceLn+Jg825EQuED5u1dTyMgNJwH28t8CL0/JcPZC2wB?=
 =?us-ascii?Q?hilGVmdzcajobT3MjUDi2HsgH0lmgux9CKhM+QKUe9JXrYQ8MSNqK9gUaVkh?=
 =?us-ascii?Q?P55h7w/UskcB9vFTOJUuWsfS826cj4EhK9EsJHp/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 926e6271-6615-49c0-5f54-08dc6d9d2aa0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 07:21:44.6623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xm+DpJ4v13wO1hzpoSI5X/Lupbige1hzUTemZ0hsHiLix3LtXi/FroD1DcESbQY1l3u6G6ecN7aTx5bCgowbLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7582
X-OriginatorOrg: intel.com

On Wed, May 01, 2024 at 09:54:07AM -0700, Reinette Chatre wrote:
>diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>index 499c6cd9633f..ba81e6f68c97 100644
>--- a/arch/x86/kvm/vmx/tdx.c
>+++ b/arch/x86/kvm/vmx/tdx.c
>@@ -1305,11 +1305,20 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> 	} else {
> 		exit_qual = tdexit_exit_qual(vcpu);
> 		if (exit_qual & EPT_VIOLATION_ACC_INSTR) {
>+			union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
>+
>+			/*
>+			 * Instruction fetch in TD from shared memory
>+			 * causes a #PF.
>+			 */

It is better to hoist this comment above the if-statement.

		/*
		 * Instruction fetch in TD from shared memory never causes EPT
		 * violation. Warn if such an EPT violation occurs as the CPU
		 * probably is buggy.
		 */
 		if (exit_qual & EPT_VIOLATION_ACC_INSTR) {
		...
		}


but, I am wondering why KVM needs to perform this check. I prefer to drop this
check if KVM doesn't rely on it to handle EPT violation correctly.

> 			pr_warn("kvm: TDX instr fetch to shared GPA = 0x%lx @ RIP = 0x%lx\n",
> 				tdexit_gpa(vcpu), kvm_rip_read(vcpu));

how about using vcpu_unimpl()? it is a wrapper for printing such a message.

>-			vcpu->run->exit_reason = KVM_EXIT_EXCEPTION;
>-			vcpu->run->ex.exception = PF_VECTOR;
>-			vcpu->run->ex.error_code = exit_qual;
>+			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>+			vcpu->run->internal.suberror =
>+				KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
>+			vcpu->run->internal.ndata = 2;
>+			vcpu->run->internal.data[0] = exit_reason.full;
>+			vcpu->run->internal.data[1] = exit_qual;
> 			return 0;
> 		}
> 	}
>
>Reinette
>
>[1] https://github.com/kvm-x86/linux/blob/next/arch/x86/kvm/vmx/vmx.c#L6587
>[2] https://github.com/kvm-x86/linux/blob/next/arch/x86/kvm/svm/svm.c#L3436

