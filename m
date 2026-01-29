Return-Path: <kvm+bounces-69598-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ULY5JJ6xe2mSHwIAu9opvQ
	(envelope-from <kvm+bounces-69598-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 20:14:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E6373B3D88
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 20:14:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3544D3034E2F
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE6E63128A3;
	Thu, 29 Jan 2026 19:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J7bxDs8O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72842C11ED;
	Thu, 29 Jan 2026 19:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769714018; cv=fail; b=ry6BoP1N7xnHGW6kUP3rbvvAA2UpvaZ5BO2laJMwK9RDamSM57fQPVVwuDPn+0e4Ohl8vnE74gY673DwmTrWFCW4l7LAsKBV3FNP5apTAeX4JMOU+FF3DScbsOkDZkI/dqaMhdJMLOnl7NZqstofdZQwvo4E7WdXIFF6vLrgUXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769714018; c=relaxed/simple;
	bh=N9R8d64Duzy5Agbjh4Wp/unhzbKyXphdjFXL90+r7a4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ryYlQVey9/FRbAca4QZr/b5S6hYguymsgFJ+fNbE96AUADal9JEb1t+Oxvb0Jy29rZvnWEAo9zw0Mk1NB+xo753CAuPEoHsUesaPzi/K2EF/T0mykEjJoQsrDazyjls/wEeQx494B6U9mbtwF01TAT0CLP40xOM/MYbsFUk5u4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J7bxDs8O; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769714017; x=1801250017;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=N9R8d64Duzy5Agbjh4Wp/unhzbKyXphdjFXL90+r7a4=;
  b=J7bxDs8OOVYfb9Lv7XXstBIJzTfROGFS+cmnNJt5AGrHL343jPpTf0cJ
   27BfPZXDmlRof8FK01cFL8b6iv+EdsnJke2+0TWmvko3THBHJpFA0WzC6
   aB5Fq6l1B6V24V1m/WHveARuiY4KktVIx3eAHICF3Es0OqySS0U/31LfC
   te5SuZkt0tsiKpxDO+eFOH2B/gOFMTCpSJCV0t+G8WKgVdHYicQno7xZy
   tKZrclEtGPeYvhSpwwcJHbvmHg/ImIo0XcnYX24HxIC6viuHxS1azobTn
   thDp/MxU09Gfdk6uTwYCz/5ZTvCpjhucbHrCET/eRVoMwtmISbEX77GNg
   g==;
X-CSE-ConnectionGUID: Xhewv7B0TlixPejyrGK63w==
X-CSE-MsgGUID: EHPzvf0MSKaTQBj9vBm5sQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="70859202"
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="70859202"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 11:13:36 -0800
X-CSE-ConnectionGUID: yO4cSWL2SGCPsBemccgwWQ==
X-CSE-MsgGUID: MCdQggTBR4yKMdn7KfYrlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="213191406"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 11:13:36 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 11:13:35 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 29 Jan 2026 11:13:35 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.21) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 11:13:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V3bQ7m6fsP+2SPTyBs+2dI4z8e9Gp6FtDpCgBy2h7+XZc+6ihhnRomKj8zP0jpY/qms47FnDLXiH3C4H1A/s2MDNjx11oJz63iubMRPU28ch+3+Qe68JfZfIPb+X+Y80MhyFnVlRhG844URFKHdhFP3R7IfBREOsH+VVyUiOFvODcvDtjAOyAOfBb0aTGyE/pe9wl5PJdkUIALCqjpqD2rsj7wLqQ3nBTrvjZSwUBaC4/OqQYM1gBTGc7/cJteUjqTbt41pp5BSP702C2PO+e6EwssOBb4iLI5ycCc8vJnA1QbhnZNojOTfrUowMGMgG985L7VjRUkQ05ZBJLLqSjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wqlSKqor1FnqIfHWF8VBsrgMzrNloknJ0MHyj/6QElA=;
 b=QfB34COVjy0F9GeMlnGlaHyckE8QHJxDR5NNsM84O9hfOVpqwzHGQgS2cqh7bQ7mdw3aNNMbZDLadYVmSkNcfUlT1O7zjPqTYAFD7Buxh2s3bShOv08eXqxSMSK+mvCFr3weWpFORFkskn9isPpBcv6hldAYPQu7b18dgyu3RRCe0bGT+Os/CykpWIw0bs9Qi1eThHbBVKSte9Hr2kid7L5OYxeheYyonlopSyH5GKRlGLEmVnaFp/cMKY46mdPUfhqfeJXk3t7/oMHxuE3ezWWJ+yIchXso84MBbpjyAf8LXuVcXQg/vqjNvQdECb1fwOch0kiKcUHJJPJ7LGwTgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB6834.namprd11.prod.outlook.com (2603:10b6:510:1ed::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Thu, 29 Jan
 2026 19:13:27 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9564.010; Thu, 29 Jan 2026
 19:13:27 +0000
Date: Thu, 29 Jan 2026 11:13:25 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Babu Moger <babu.moger@amd.com>
CC: <corbet@lwn.net>, <reinette.chatre@intel.com>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <dietmar.eggemann@arm.com>,
	<rostedt@goodmis.org>, <bsegall@google.com>, <mgorman@suse.de>,
	<vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
Subject: Re: [RFC PATCH 14/19] x86,fs/resctrl: Add the functionality to
 configure PLZA
Message-ID: <aXuxVSbk1GR2ttzF@agluck-desk3>
References: <cover.1769029977.git.babu.moger@amd.com>
 <84b6ec2a2b41647f44d6138bc5e13ceab3aa3589.1769029977.git.babu.moger@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <84b6ec2a2b41647f44d6138bc5e13ceab3aa3589.1769029977.git.babu.moger@amd.com>
X-ClientProxiedBy: BY1P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::15) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH7PR11MB6834:EE_
X-MS-Office365-Filtering-Correlation-Id: ebe150bb-981a-4402-daee-08de5f6a7b64
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nqhJ+u2S0H1Q5HoTt7PPmyo9AF1bdI+zF2JaZNeHnLH/HQSQoRYTTY4Zzz1J?=
 =?us-ascii?Q?5J3fQAXJ2258kDp3jD2w6z/PdwWMc+e/glWNMGdG94YUX1mwtT0PFnIz4X/J?=
 =?us-ascii?Q?ug2ietnW7UilZ7QJ0vUGMFFZeVYwz9iKfeSjxOpJ/0ZlrqeGJCMrj3NbfkeE?=
 =?us-ascii?Q?I/fzHBz7NdScHc6AFLeSHnvWQKbOSktliIpGI4s4kZ8zdz3A4+j3rl52vPxE?=
 =?us-ascii?Q?PBi2gjGlQ4OaVn0Bamw84yYfjLDf/0ip1OYMPPaG2JHIupAGUlvbyWspzs5D?=
 =?us-ascii?Q?j6miwgSFvlj4NKjGMq9Q0xT0RbUaTeQVepr+u9XQYWfhEhMuftrFwrXTNupZ?=
 =?us-ascii?Q?HBi3pRB82BIz6Lgs+YS+xtfsJt4/ksA0LhNLevDh42+KeiVy1LHCcsLKDaAe?=
 =?us-ascii?Q?xVKLeYgEkrTwHn5wXNXU/T84cIuFvXt2atsZIzUBiS/M88yxVguHInZtGqmI?=
 =?us-ascii?Q?tfCgVaHZhxHQwKRYZH6BCZEen+IKMzEhi2TmgEcrJoE5FfyVXUPQN6Duc5b/?=
 =?us-ascii?Q?xUd8JH3qEk4l182tw47csdiZPsbgcBfJfvDPniKZ73XjV5GeJDABEuMlHVLK?=
 =?us-ascii?Q?4dvnZde6VKNQZ09Q2F8kAFCR9KhRmOdWUzcPreb2FPfc6020H9tZwUP4UatW?=
 =?us-ascii?Q?NVEF7d7yAPj9l/nhArSZkn/pIblyCvX5QoiX5JoSgVe4NDTwgTmL0C8Hr2wM?=
 =?us-ascii?Q?p+5gWydOLY/QNO8fbppE5Iy8niKRvYWNhs78S99lRlYwSqnm4IxpzOKt0+Ch?=
 =?us-ascii?Q?eBExsKqGhSV0ujfsUnn7+KcD6mKRRCXGFm370D2EcHzAXfJkx98GTsi1rklM?=
 =?us-ascii?Q?LKNnUpNrjh7yUaFUDnULIQUENmwx/ERDGDuVHoNW8aN6cZBUVm6c9vaZh+lR?=
 =?us-ascii?Q?/kOuiRYD7qxZHnhmEVUTvrqLvsTAnmoX0yTt1HqXjQyIMzGJTDgFiZ2dJ03O?=
 =?us-ascii?Q?8GROHaGHme3baE1MDauL7GE/HwdtAc0WGRH7uCxXVgpJ7g1r9pCdWx94kGAc?=
 =?us-ascii?Q?u5G2xLGeK8KsThw5UwuVmY9Ul0G+9PZuWc/SYi9vtypov+w2G0tK35X7xsTe?=
 =?us-ascii?Q?iY1YJi6o3jaAAWXzQpFXW1Aqp3c5z1Itca3MvrCfsFWJ4cigPyMFzq9Ny5d9?=
 =?us-ascii?Q?duokhoviJWmbZasq+8FOfa4XGFkZqH4OBeIxR2shAg8QnjmnKBj61Lun5GaP?=
 =?us-ascii?Q?xwaHo1zgJCPSP9GLKUNh9cdwUO+F0rEd0v1+nIMZh3jgpmN/XkKEUEZAcYIJ?=
 =?us-ascii?Q?MEdXueKqmTKvAP4Zosrs2GP16IPJNLMjTv5aQNebOTLssGyBfhmSGxqWsa1q?=
 =?us-ascii?Q?9gJtk4x40DZtBq9OuAFRZ5E2txtzWaiim96cspmoDnXg2wtFJ2BUNJEVIOP+?=
 =?us-ascii?Q?PRJ2mCMsJRAEcGqZFN0znVgBYK3LuXEH7JuF38eQWda3pEONWAXj54aDh+f5?=
 =?us-ascii?Q?eRrKC+vTkOhxjNXC7L5bwhKr8dUGcoCmEU4uXxYtMdRHNCkBGCAPzkzICRqf?=
 =?us-ascii?Q?3FTcuRg1I8FQa+JTHZIRYwMG6tP+JFHClYkShTmnafVqfiVLtHQABVxrzUcI?=
 =?us-ascii?Q?gmXl1dEw2e0uZr3fzO4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gLsMF/Eo9C0Urcu6JbWVxMbBbgdavfdPtYBGo7CnLExR7ChmKvvgFaA1Fsb2?=
 =?us-ascii?Q?jXtBoF2RK/gHIFbKapX1bPtfhLnnvfD1AJVbE/p/wmnEBp2pjZzKP8ZaB2yO?=
 =?us-ascii?Q?VV6kMQx/OOlvMi8pxjbNbmX7SX8lvZPQnaAdp9xI1blar+c3SDsMNcgXRNYX?=
 =?us-ascii?Q?BttZcn5dqWS5dCbhGL/1cJg6sONPTbT+2LscCqKGMGm3OV0CJTxjDc+DAelK?=
 =?us-ascii?Q?ilg5r8AFAmJ68pMIe7ELMngIoYmFTtm9cvbdt7hCSKmm2m9ArjddGbKDyQaq?=
 =?us-ascii?Q?aa+QjvkT5nTEVqjp0Cs38Zu8mkSKU2w83kXnziXEAM5vyPlrYNrpB/zb6UOp?=
 =?us-ascii?Q?wGjLqgDebFA1papd9liRDvQ/Kac7BabtFvjR8MmOpMIqR/2oe2mBIitRtiVv?=
 =?us-ascii?Q?uwnVAOC390hwKcEPVQyNtojCDnloGJ3z28SAfzuz5rEVY2u7KwEq8Uv1coz4?=
 =?us-ascii?Q?6Fm0XXx7jZxyWawXN4VJJlIZaHW/8ujc6YpZc2SaPzBbJyueL3jv+908FZs0?=
 =?us-ascii?Q?xD2gMow37T75RKJLynjK/MUfADnWPMzaRxMIxQlWes4BkaNXF8wNl+jsjI0k?=
 =?us-ascii?Q?kBrxEUOIXMNUUmFS6M3eteI1oY7FnUAry7+ACk3X0s6sToRt3vZ/cN3lb4lD?=
 =?us-ascii?Q?gkd76sV4i8Meez65X47Zcqv7ZX4q5jTTkqBsVFU256tOxK6E/zQ5rDn9xPgo?=
 =?us-ascii?Q?il5q/xmJs54JQOjVnQJTMvkXiRZGO/u7yAet0APC2/UMEhkjdD9EPi1g9rYg?=
 =?us-ascii?Q?ydTtgJLkL1Yk51WqavGd9FA2vCXubb92ribsOffdd2agVaTHFSITSllEkltB?=
 =?us-ascii?Q?3XcQBubb8Q7vBk/b+meoQGbprz6eUyJABiOhhE38GR2cU2pNV0hCzjC9Pxwm?=
 =?us-ascii?Q?x+q5C/Lk4JTv3dWuJJiT+ozKmUY8w/RW+HSJpXSa+u5KZQ/VEulB2zcnf2wx?=
 =?us-ascii?Q?79BiTlN2wPXJtgmyaNMsjkJDlWG9H11+4P8USQ8JddjGgE7y0qeJAVH673Us?=
 =?us-ascii?Q?ARaQXYgWMAkYcMtgdExfnBg4cuY6lgRw9oxkATStrYxbcw76xroy/mxGh/f2?=
 =?us-ascii?Q?D+PiIPcPxneVfWpcN4XonIyCJ24qGOvhkfwnmlPpInS+nzHpHWVH3edNFZFv?=
 =?us-ascii?Q?AFpjauLA4RBFjpN+ZIIgBB7ZodndaXpz+sZO7SnL+0h7vjcVkaZLtnr3J3B9?=
 =?us-ascii?Q?RU0Zt7Lp2OD8R2pZ+nLyvm4KKrv76tRt2hBsEUYT/6VZ2Sxza7yzYKb7Gi9q?=
 =?us-ascii?Q?x3ZNbWOg4C4NlIf5zs5ERuXiIFxNCEEANKW6xrFRDt0su0qFGdpR8ZvJA/0J?=
 =?us-ascii?Q?uqmEESq2hI4N79k9nTGFQ4y9cLPky5/6JNp95B8+RC+fCdNcq5G+ujzLnSGD?=
 =?us-ascii?Q?jkJMk6JHMhUCXEpLrEoPtJUuAVp4K7j5eWlQROWKOZr2ZipU6ILLXblnz1FB?=
 =?us-ascii?Q?L5LNfMeyZKMbA+2Mafsv6VFeQWwf8BHWimSeg2Nt+R38TDimgASqaXkYs2iU?=
 =?us-ascii?Q?xp0T12AeM87cUkJYY9FnS8Jp8JyEHsvV/Ankz3hfqfKcbq6Uf4grYVr28/Ff?=
 =?us-ascii?Q?ZCiE16+gxlVYDTut0C8np3+IRh4X7/217ga8hOCYzu4WJdVbzBOs5wFvzTjl?=
 =?us-ascii?Q?mOEhuig77cyH/TfRBOvsEA7+eFgnreBmN+002qhHYAvtuipvYD0cIu7Sjh2j?=
 =?us-ascii?Q?F8Gl9MsfVoGY+NfQ1JL2Ap3yBoFzMFQy3CiL+4hPTuj5QbwGCqZ/iyks0MUW?=
 =?us-ascii?Q?IOjUfVya6w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ebe150bb-981a-4402-daee-08de5f6a7b64
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 19:13:27.6175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EcoFAQ+rRn4bE2zCXyZGOLbq00cIHv6VXKVlFTgvdJ/8mFv7Rvc0ZpdTBzcKJNkbU6pDUQ4josNK3RsFe+DxgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6834
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69598-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[43];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.luck@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: E6373B3D88
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 03:12:52PM -0600, Babu Moger wrote:
> Privilege Level Zero Association (PLZA) is configured by writing to
> MSR_IA32_PQR_PLZA_ASSOC. PLZA is disabled by default on all logical
> processors in the QOS Domain. System software must follow the following
> sequence.
> 
> 1. Set the closid, closid_en, rmid and rmid_en fields of
> MSR_IA32_PQR_PLZA_ASSOC to the desired configuration on all logical
> processors in the QOS Domain.
> 
> 2. Set MSR_IA32_PQR_PLZA_ASSOC[PLZA_EN]=1 for
> all logical processors in the QOS domain where PLZA should be enabled.
> 
> MSR_IA32_PQR_PLZA_ASSOC[PLZA_EN] may have a different value on every
> logical processor in the QOS domain. The system software should perform
> this as a read-modify-write to avoid changing the value of closid_en,
> closid, rmid_en, and rmid fields of MSR_IA32_PQR_PLZA_ASSOC.

Architecturally this is true. But in the implementation for resctrl
there is only one PLZA group. So the CLOSID and RMID fields are
identical on every logical processor. The only changing bit is the
PLZA_EN.

The code could be simpler if you just maintained a single global
with the CLOSID/RMID bits initialized by resctrl_arch_plza_setup().

union qos_pqr_plza_assoc plza_value; // needs a better name


Change the PLZA_EN define to be

#define PLZA_EN	BIT_ULL(63)

and then the hook into the __resctrl_sched_in() becomes:


	if (static_branch_likely(&rdt_plza_enable_key)) {
		u32 plza = READ_ONCE(state->default_plza); // note, moved this inside the static branch
		tmp = READ_ONCE(tsk->plza);
		if (tmp)
			plza = tmp;

		if (plza != state->cur_plza) {
			state->cur_plza = plza;
			wrmsrq(MSR_IA32_PQR_PLZA_ASSOC,
			       (plza ? PLZA_EN : 0) | plza_value.full);
		}
	}

[Earlier e-mail about clearing the high half of MSR_IA32_PQR_PLZA_ASSOC
was wrong. My debug trace printed the wrong value. The argument to the
wrmsrl() is correct].

-Tony

