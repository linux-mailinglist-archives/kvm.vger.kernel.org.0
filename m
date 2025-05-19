Return-Path: <kvm+bounces-46967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FB95ABB6E2
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 10:15:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54E67189899A
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 08:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B161269AFD;
	Mon, 19 May 2025 08:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bk+TKVGJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDE4153BD9;
	Mon, 19 May 2025 08:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747642533; cv=fail; b=N9e+R1L9D02LKWANdsyCybqanW+YvJA8tttDd/k4iLv6dQbytDf+5zYVlZ/sgziMcWSthkVMo8dQKMO9F8V3l4zDZtgxpWXK1nEIuMCqM+mTyjC2pAA7Mizh//WbzGWvAkvfiq2HlLnZRjmu1bhsXIyIK7mQ6YrOzPn/ffvfUAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747642533; c=relaxed/simple;
	bh=p8uw1TbJN30yWmH5minDP+sX58ZMTWNm4QZCZSy5XjA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OqFNyctk3xMg9iZvQMRHFNCm6Kwma/PWhMMMdw5SLNhVXUmVbfEfbrX5vs4D+89ufLal3hzrQIRQ+CVhLTW990MGhPDS2uoYl0SHNhphpIeN7rDhnFARNpKPQf3uXj+PCTtPmXNGBT7vzUbcDmztzkyzf9WhZKybSgfnRFixGaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bk+TKVGJ; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747642532; x=1779178532;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=p8uw1TbJN30yWmH5minDP+sX58ZMTWNm4QZCZSy5XjA=;
  b=Bk+TKVGJI3ap1+QfgCqhnddREL2JZd/+Nv6JStKP8wx1faIGIurz3/ry
   66LERaBsFsDDs7bEyoDbZW31iUwjIY9hfVyC2xsq7j1NddMjyd0P3RJ0P
   MhhaGr9gkA2TiNP4HR0u2RBDmwUbnKDJAh4z5W9/jCYgND4TBPxLkP99B
   wh41ZFOtLe6JS4FRb72R1k5GFfhqCQptfyCqgD5PjnrO6qasC8KWvodlK
   x7dULZk9iOYIXrUmr+kVY/JNAXVnQU+zN8Io4FgHGEes3vD3Vi6JHHZUX
   E2dCDqPQrkSsv2mQHa3kE+K7jFilLeJGP5BGV2v1uSxNnSuqb8mv4OPEm
   w==;
X-CSE-ConnectionGUID: bvLsu5dfT/eTCLoWSzTFrA==
X-CSE-MsgGUID: Rfi1yDyuQfKbX5sdPlME0w==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="60924636"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="60924636"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 01:15:31 -0700
X-CSE-ConnectionGUID: NOqdKDmPRCKVz1Tr4xLC1Q==
X-CSE-MsgGUID: Gl2d6bt8QK2plgftTIvBAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="162590735"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 01:15:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 01:15:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 01:15:30 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 01:15:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uVJjYoQ/og0djpNzVpG5KPv4ySR6t+63+PTr6pX4r8Nb4Dk+8YbUuMb6GRGyshwwsd0FvOy8K02NaY6TvH/RMpwXdE8l9I264eM45c5+nJF86+3uYKGiisO2HvQMYwJh5BaoQEl9FpGn9Wu/qtUOHWGmqPLAnoiRHtjPi8brWsCgOkKmWhVnCi4aQkCBb2421F4dO3+elwuTdwkb8fpX1fPyl4t2Nc3XH0WedG7nmlw5nEtmkN+81+xqK6TZwFI8A+lIX0a6lULKxRjJm2EbumIRTJVrkjEoroMam4IKHgXZkKcDNLTmlpKBYPIq6RuPHqgZ4RaVtWT4gfvK/s7Fhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7xbCAtWd9DyXAZOwBsAOFaUD4cq9t94q+xDHgm7GE4=;
 b=Ci8VL8DUxIekPqcyaClEuRQt+Y2Go8K7KEQvtU3oa7+djz0I/susWyORnzvHKzEiF5no+av3tPmwPrXpPMgRHwnGmA3vucFumCA54O+pMnvCqPOObfquUwtHx4cXl7lTpWIC6qS4v0Gh/iGyzEnBG/SCAFStWpXR/4HGsbih1gJbjoJ5GNylD2rToom98rWDDssWIF0w7ac8I64c/TSUKSNMdFrcg0nh4rGaPLw1PtNhXP2splGaJe094xZb1bl0ehXI75SrhWouPM2lwj1yT+72t38Cd3l4l8i1AP4DcwY8rEQatsurTgZrAHUjIWi8kaYlgXUctKnoy2YpUTQzuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB8099.namprd11.prod.outlook.com (2603:10b6:208:448::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Mon, 19 May
 2025 08:15:11 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 08:15:11 +0000
Date: Mon, 19 May 2025 16:12:58 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"tabba@google.com" <tabba@google.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Du, Fan" <fan.du@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 16/21] KVM: x86/mmu: Introduce
 kvm_split_boundary_leafs() to split boundary leafs
Message-ID: <aCroCtBYqhtAgudt@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030816.470-1-yan.y.zhao@intel.com>
 <e989353abcafd102a9d9a28e2effe6f0d10cc781.camel@intel.com>
 <aCbtbemWD6RBOBln@yzhao56-desk.sh.intel.com>
 <aCbxSyLUhjyeB+05@yzhao56-desk.sh.intel.com>
 <39cc767dd2f3792f1b36e224f1567dfb997fc0cf.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39cc767dd2f3792f1b36e224f1567dfb997fc0cf.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:194::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB8099:EE_
X-MS-Office365-Filtering-Correlation-Id: 08d3a17e-fa2e-4bd1-9d50-08dd96ad46b5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?0gjs1bTYo+WFvfYFSUHpLahsthIg1XVZrNnylLS6gZCYFgORwAPaCYyJB4?=
 =?iso-8859-1?Q?O++VgIqoIxbV+Jgkv+yqgai0hchnSEKkrjA+Sqnzb5M8MmIzmUzD7hPSr6?=
 =?iso-8859-1?Q?VnhOb26Z9n66HVTNDOeKpnIQ2qYKQ1YqNED1yQ6UOSbURchPdMncMQ94MR?=
 =?iso-8859-1?Q?faDFtfIgIQeuLFEpmTLGbgSCAMCnqEybKSZej5wd9b/e4tD0KVvF6wU8J3?=
 =?iso-8859-1?Q?KBI1zkbfDPxhcVCySonfyDENuJE6EW6YR/sw5TPMk4XW5pnHpsWunjyD2+?=
 =?iso-8859-1?Q?tsoy6SqgF2+HHM9TvbAQIYIdNvmfKREkvkDx+VTJMGj5L5mAQJB5TVdLz5?=
 =?iso-8859-1?Q?cRdPrrFU/0ag4E34mKcBblU8p/YHObDwwWPmkFn86Hlk02+7cNt5UlTDzY?=
 =?iso-8859-1?Q?WzI5NuQB62+J6ca6wjevnbSozbf+W+nzUzu4B1m0NdU2bMudrIK4D7CiPl?=
 =?iso-8859-1?Q?yLpvzj4xK654zLjYCiDwtgacDgiPyDUNnJwWE1JUnlWvlh3ByIgRSSB88W?=
 =?iso-8859-1?Q?icTQTBQr2syDWMKBC2tHvnKJ8c7Bi295CbQ5C22DMu4QNVVvQxIVcJLUG2?=
 =?iso-8859-1?Q?FsMdKQ/ctOHZneKBbQOBrXB82MLFj6hzBZsUnviP3OOxBNxHiLf9cVNJ63?=
 =?iso-8859-1?Q?reWS34RfUWo0FVuBLUYekruzPv3uvJ+2MqWdhJk+iiTFYy+74FS1jzGLU1?=
 =?iso-8859-1?Q?OhwHgmraDPHxpWSYNXCcethlBFw12uY9Ni5sGnVGV6glVt/1cQZSnOwPYB?=
 =?iso-8859-1?Q?PMVeM8CFc1uzbfR/QTWFkLzB6Pwx3PU484Wdl19jrsOBmftZFgr6EmCPBX?=
 =?iso-8859-1?Q?uKT3NOZg9yO6m5YjoJ1EZ0g0/0TbAy/52XDQbRAoSRA4HH7yvDmnm0hPFu?=
 =?iso-8859-1?Q?Wm1RAwZFpg3E55FDabl9Rap4kXaV21KqpVquM2l9hu9u3XiY3FLlCQ6F2X?=
 =?iso-8859-1?Q?XPIRtonzBshGZO/RaaGiArMAja3qJBTtIbmbqp0GY6p9CHddAioLib7w31?=
 =?iso-8859-1?Q?pabwaHELPhteRSJyGdVqQlqAue28oE54SR9+72uEhzOH0u0aShjTqz+o95?=
 =?iso-8859-1?Q?5C3PUB0XJcjuH43sis29C9g0egNQTxmfcbzRk+/Xh16TXAWH1z/EIxia4f?=
 =?iso-8859-1?Q?TCUu+kczsSSPEK6f2cJ80zvaCPLH0Q1LFH0SWGgf/w6DC8434oMNtXQNQH?=
 =?iso-8859-1?Q?P30lu76SeCuQd8qNMXc+tQeDsiXTv5F0WKcL1udAw7ra+Cm8JJrEkChqpY?=
 =?iso-8859-1?Q?p7v7uk0HP+7K3XLIPa274/lR+NMABV3X5gRSAxfHAjlB2rx38A1vNg4RAL?=
 =?iso-8859-1?Q?m3zn2kHdD5ZDwCTN4ofP36jdmd9lvdmT8F5t1cTeeRcpVQY0wwPdaGX27n?=
 =?iso-8859-1?Q?L/knq+ylyuiYlnScINB7DFJH7yyNyBCSLJvs7cChxAc2Sp3Bk9zSEV7qJB?=
 =?iso-8859-1?Q?KsMRJFMuvLQxaMJA1t/A9THZ8zErCk7xhkoy77EWtp19V6EnxI4xFriJwI?=
 =?iso-8859-1?Q?A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?y2YwJ4VbvjFJSNQaYaemoZvHD7FBPt0cOVRowC3d18hlZsWzfG3HmMlEfr?=
 =?iso-8859-1?Q?6PeIbGrM3CKpGkTgkhx+OYQQgB2cElBqZJlrY91RBCsDJCOET2/LpW2hNa?=
 =?iso-8859-1?Q?yRdtaUI2o1a9/PBQVWwSiF24bgopt2yFNuiFR7YJO2kmnfXmeVi7FNKNaF?=
 =?iso-8859-1?Q?KyTqsTmryA04po13u2k7AA34sfADwoNcp1d0bv2Wt596skA9d/56k03sy4?=
 =?iso-8859-1?Q?n2U1VJM58NlS0Vo/J1/aFzoBIAfXKYmESSkbSZ2KsWMwITavgHV2If8AL8?=
 =?iso-8859-1?Q?KQeeKNN188sUD70WsC49lNyfRBWmEutojE8XO5iFdOzjdY/jHQpzyntUkM?=
 =?iso-8859-1?Q?VL6Wyrs87R3bxejWOvg8h4cr+FePLQsrx0fQs6x/gAxc9q2r3F42twRm/b?=
 =?iso-8859-1?Q?ooTvO/0QPl2UxyDOD38YGL9gostLTqRsBSZY0dSASTlUXI76ETw5bi1fdK?=
 =?iso-8859-1?Q?tshpOBMw9TPiCQwThuQU42THO/SqG/TmoilEgOJ5dg9jZ3xCoU1O62HPou?=
 =?iso-8859-1?Q?TIjz4e+D4mWXXzfT3rvE+EnaX4eKk6////FXAjzJDnPfOXuMWFr2GNP8fm?=
 =?iso-8859-1?Q?PhgUIlTiIEIt0RBqg4FAZdV8+H+SNEUe1b2ZRGq9IROe8ho2GfUG/ENU6L?=
 =?iso-8859-1?Q?K3Cv0RYSVVpAqNY8S8u+pJjcATUhw75SuU88KpNsR5DODie1TF4i/h5GYp?=
 =?iso-8859-1?Q?jAAxNk0s4D/mTMqro8MHBqhsSiUN/jQ42a6ZU+bEWyrcHsESAvP7H1AKj1?=
 =?iso-8859-1?Q?za26jts3/J0eKxzKaeemRxb0vqaHpguMgDs4qAiEwD8rPg6hv4jyygvvTQ?=
 =?iso-8859-1?Q?OjEepuYsViTp2jP1oEh2YGm5v0HifXg3Y9QtPFMUitZMpemh8I9M6o1bF5?=
 =?iso-8859-1?Q?5HM+kFjL2IKLCgX6q+M05OcOPgUT9fK5vx7u3aZQYVo6uapIP7wenhMewE?=
 =?iso-8859-1?Q?yN6LinCip+NOY78AF83OaiQGjfcX73KpoZZTpRiKcyAO0DDHEHEaFIWGYs?=
 =?iso-8859-1?Q?8AY0uMh6kHb8oxpWNKBqT014xp2n5whI3exYsBfVhJmQWa4GniQi9ILjkF?=
 =?iso-8859-1?Q?LgmKnUYoq4LHdoOA9qdJ7gGXr1st2wxusOkSSXMiRedhS4RGvZfnmPBXPS?=
 =?iso-8859-1?Q?1jNKSYwtNlJ7Y/KmCdWBbW66rSqX2cc3X1tTU9iaaSkLGqab2HXw99QRw3?=
 =?iso-8859-1?Q?CTh20E9a/0DvB4J3oUoh4bljG9bJtq3V0U41I0o5PRgK5pa+sXbBFz2mRm?=
 =?iso-8859-1?Q?UVy0XehnJAUwhaRHoQ3suAcqe4VP8XW6PE7+rXK76Yupn4FKju+CTqlCXV?=
 =?iso-8859-1?Q?rwU+Ycn2/T1zhyZSRaDNNksnthKB2AEYrmcHEALOaaT50iyR8vR3ZF4ois?=
 =?iso-8859-1?Q?b9OZiDy7UVehFljsWdZEAr+1/Vzoq6U9+XiVWb6r6qyee1s1XRwdi6Of9j?=
 =?iso-8859-1?Q?xvDBeLOO9NnyA6jGay7Y9VuX+VwJWq/q/gheGUW2K7R7TVDcuEuw0aXW58?=
 =?iso-8859-1?Q?YPs/aVOy7mx908snGf8/AYlHkwrE2yW7Ipz3El9M+XlPZ5bQfsmMfGvxuG?=
 =?iso-8859-1?Q?bda9lXHqECfYS+G5nVMIhMnq40Mv4GiUk8Bs7nrl2/I3nOcDfp3pcTNt7Z?=
 =?iso-8859-1?Q?PZDGLPHkL6ZfwmriN+41zS5ZqtcMITxPY0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d3a17e-fa2e-4bd1-9d50-08dd96ad46b5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 08:15:11.7982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c8lkOnvJBq+a9YpoA4Q2bKs3ZHdpckjS8QnNq9obIvvic2SB9cBPBAVEkHrPcqfqdnEdund3lo64Iz+EoGLDiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8099
X-OriginatorOrg: intel.com

On Sat, May 17, 2025 at 06:27:10AM +0800, Edgecombe, Rick P wrote:
> On Fri, 2025-05-16 at 16:03 +0800, Yan Zhao wrote:
> > > 
> > > > > +int kvm_tdp_mmu_gfn_range_split_boundary(struct kvm *kvm, struct
> > > > > kvm_gfn_range *range)
> > > > > +{
> > > > > +	enum kvm_tdp_mmu_root_types types;
> > > > > +	struct kvm_mmu_page *root;
> > > > > +	bool flush = false;
> > > > > +	int ret;
> > > > > +
> > > > > +	types = kvm_gfn_range_filter_to_root_types(kvm, range-
> > > > > >attr_filter) | KVM_INVALID_ROOTS;
> > > > 
> > > > What is the reason for KVM_INVALID_ROOTS in this case?
> > > I wanted to keep consistent with that in kvm_tdp_mmu_unmap_gfn_range().
> 
> Yea, lack of consistency would raise other questions.
> 
> > With this consistency, we can warn in tdp_mmu_zap_leafs() as below though
> > there should be no invalid mirror root.
> > 
> > WARN_ON_ONCE(iter_split_required(kvm, root, &iter, start, end));
> >  
> 
> Hmm, let's be clear about the logic. This is essentially a mirror TDP only
> function, and there we don't have the same invalid root scenarios as the more
> complicated cases. I'm not exactly sure how we could hit the warning if they
> didn't match. I guess a hole punch on the fd while the TD is getting torn down?
In practice, the warning shoudn't be hit because mirror root should only be
invalidated after gmem_fd is destroyed.

> Let's comment the reasoning at least.
Will do.

