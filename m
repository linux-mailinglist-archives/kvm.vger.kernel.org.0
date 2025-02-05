Return-Path: <kvm+bounces-37307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59145A284FE
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 08:36:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 978A93A5F2C
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 07:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C8312288EC;
	Wed,  5 Feb 2025 07:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mlXyp+7Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E113325A649;
	Wed,  5 Feb 2025 07:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738740957; cv=fail; b=lHEKE6bUeDL/hQgB7EDAr9lL7Y4ZvyHQocUzk+D//O0XSEJ7YbHnCVFvUPVnQXJvK6b1FtEcvRhP1cvZQ2fCCU2OUa5ZN2EQVp065zVm+m/UjdyxMZCnBhCPXwF2LsEHz5D8zvWYL76UsAiks++GnOsU7ZknrjLxtgRKya6/bk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738740957; c=relaxed/simple;
	bh=7D0DOl2ZjMN0+1uFUqKM2ix6nbQdpnUPYmuqbutM0e4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HhpDdGRksFSs7E3SPQu6evUzixdEkvlAONTqoYsVKDtxtjZMaVfJtkXmGqXOPZNZULA5vul/7AcyjMn1TOiQScY89yKIW9ZF4SR4C312yxyVfuPcthEcHByMVdfVEDU5lrAAoptld9mbVAHy/gHOPDeY4ZfAz1VJSguIAvnc3yg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mlXyp+7Y; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738740956; x=1770276956;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=7D0DOl2ZjMN0+1uFUqKM2ix6nbQdpnUPYmuqbutM0e4=;
  b=mlXyp+7Ypo8Kc9IQO3N0NSuJFjNGqaM17yH5P38wueov0U16ehYQjarm
   9rL/6vfiZ4m7kqGB7IihtrygLJVGMnFgV53fgMZmaLofIpsNKNAJ734UL
   +QJDUCyy8cfoShl4Eis0f+yZNKHyNMy7ML4YylI6pPaMYVm0+uV7uh45U
   5gjXLQ9elhOo09XHtcLR3Z+LmYcd+lMiqkLw7cYB7fPv+PcSV7c4k66Kg
   OklMhHaRAE6ASg3K5Kxxo0tV+bP4f490AgGaRCVbumKSj/hMznt5BaaeC
   YsOj747E/5Cq1e5A/QWRUjx+cGobl2zHQmhXz2P8CE4LrKOwpD87o5e1M
   Q==;
X-CSE-ConnectionGUID: viMRxXGLRH+qG09onbj37Q==
X-CSE-MsgGUID: 040zG5tnQn+viMfqBY/+2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="43046701"
X-IronPort-AV: E=Sophos;i="6.13,260,1732608000"; 
   d="scan'208";a="43046701"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2025 23:35:55 -0800
X-CSE-ConnectionGUID: 7M2YZ5XcRuGImwWTYqIZsg==
X-CSE-MsgGUID: AiuBXyg+QfCbM5Hai1VLVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,260,1732608000"; 
   d="scan'208";a="111358774"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Feb 2025 23:35:54 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 4 Feb 2025 23:35:53 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 4 Feb 2025 23:35:53 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 4 Feb 2025 23:35:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fzZ1MBBThJ8braaYSbgAS1OkvjtG4JBpNEdRULiZmah88v2+VHkULjOGN4UTIkFor6aj2AjJIhMU12Hn8WMhYEsM5j9j4TY3nEH86dcyx0K21dUwGBAKTeLB4TX+R5xGBctQRRy+uLOeYfZDM0w9rleaFVsb4Mi+//B7Tgc7ufYudkrVNZ0yErSLrUlRAmLyfkJ3/PyrVEWWvq1ccA4UK7MW7FOi19mWNDYRQjYGUluVMeOwuQdhJTpRCcY8hlLPHZl6UakRWeGyhd9tJNeqepC37gMNzLtoNCwk9MtQfUVQmbUrq3FAO9TTQBDYl20/wzY45O0r0FroYrmfj6yJow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BcIrYCCPziNzL5SQoCQV7i+B0jODyEcx5O37tGuhhCA=;
 b=mWVizCYwz8cJ+WLIbLQ7vdKn42wo6fR1wCMkQ0CN5fLeluMa1FOKDC0c8dnT9UiH+m/m7u8W7KBSmx7/ipnj3fAlwY78+OJ8qcrjC6izbcIo+162H6Nc6vF+0XaKiQxgcx3hJtC56KNYj/Tv3UYs9MNNGNIyyt0xHX+RVYV/1NNbE7Ns8J6Bee5V1Gu7RgIRvsV7x1uYIq4VYpw9cDWuU7fqVWFWuMLGccFKIgOS89Ny31nCgxJu0Fu8WwlLFD9AUvWhyABLXI66YSakTENy+Ao94KFQrdwPR0iclaX9HSmfa19pkWzuiXlQurVb3bkp8ycmz9Drntj11LBJ8mCSeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7368.namprd11.prod.outlook.com (2603:10b6:208:420::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8422.11; Wed, 5 Feb 2025 07:35:42 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8398.025; Wed, 5 Feb 2025
 07:35:42 +0000
Date: Wed, 5 Feb 2025 15:34:33 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 3/7] KVM: TDX: Retry locally in TDX EPT violation handler
 on RET_PF_RETRY
Message-ID: <Z6MUiXxYeTvX0QFm@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
 <20250113021218.18922-1-yan.y.zhao@intel.com>
 <Z4rIGv4E7Jdmhl8P@google.com>
 <Z44DsmpFVZs3kxfE@yzhao56-desk.sh.intel.com>
 <Z5Q9GNdCpSmuWSeZ@google.com>
 <Z5dQtuVO2mQfusOY@yzhao56-desk.sh.intel.com>
 <Z5e8uycCzOlMwP_t@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z5e8uycCzOlMwP_t@google.com>
X-ClientProxiedBy: KL1PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:820:c::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7368:EE_
X-MS-Office365-Filtering-Correlation-Id: 887b88fd-91d1-42d8-1cbd-08dd45b7b226
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?C93YQFwqhGgL+o+ChcJZVuBUMUrqw/pN9QMwuQ4g+RUfDdEGdOUmkTRrJ5/F?=
 =?us-ascii?Q?bGsXy9/c8wWe4cuH54BtxxoANGm8xk68FU26rxSWPzTXVwetK4aT9l+/YIPl?=
 =?us-ascii?Q?j0JtvCwKWiItbNceyBzy5A459aEQwB/f6LZcYI7GXqMBiMDLR5USeQAgTfeH?=
 =?us-ascii?Q?lFyvoE6SSfEC4wLiu9tmZeKMvTeyuCoy19ZIztkirHJJ4pfsFi7Ax01hxRca?=
 =?us-ascii?Q?80v7S8LEXNHtdCoetCwAnYiuDl7lPl/QN3WbVdbRx4IKBaZt8xOkdN/vPufV?=
 =?us-ascii?Q?dL8Jq2GYPFCnzM/FuZG8Hom1wJXb1sSQNBk3STqZ1fFM1wFij0woceOn4AAQ?=
 =?us-ascii?Q?vIi0YncugtLAzu7PcoaLDhjdH44vVZd4NI3ZEXfv11wj6S3JrE6gbDWqxPoy?=
 =?us-ascii?Q?Hg5s3ZvDgFFMdOmAWIyRG+9jhpNgbbVlfaL6TAcTq/AHXpziH9GTgF8tGylu?=
 =?us-ascii?Q?hv9xTosmKFJDwJL6w5ee6TO97IJcklYdgboa2RbDpdaBNdQqNkZKdfWpOeK4?=
 =?us-ascii?Q?xJ94BjiVmLWp/1ahj1PeEWESNUiU/ZJKI5aATA0g6VKkisZZjYZ2rnGYnhAf?=
 =?us-ascii?Q?Ck3AI7+koGk3aF6FPbo3AbCVZTPrSQDav7dK9jYBU29uyiBvTm+5FWDRto9Q?=
 =?us-ascii?Q?Zj/eK3e12/fO9sb38Z+5Cuhn1QTJGuUbGTSmBrHx4A0X4fUCqUuLgqe999O8?=
 =?us-ascii?Q?0H/vUf6esChFCA+Xhp3DFkruxNbBgXLHscAO+CXoXWc/wxUujiwVZw7gW6xu?=
 =?us-ascii?Q?A/piYWCp9bh0ptQT8Sgm7LWv9VcCgyQ6zdrQByO7R1m70BTT4mMdTl4oLu6g?=
 =?us-ascii?Q?KEle2IwhVKbYiTzPr97XSZeV3uDhM0srJ7wHLlLrF3Yp3oPXBSKcmwxvatFf?=
 =?us-ascii?Q?fOOWVqPb+RwJL3Al7R4Cja8WLcYHFw2S237VsgFNdmtJ4gbYsQfuwAvPhq2w?=
 =?us-ascii?Q?oekRugNIOAd/mO/tCqtpl0NghzsYK9ukXK0Pn5ApT89FL8obcjV7QFSu4Gla?=
 =?us-ascii?Q?MzmZYvBYU/CcJvL8wS17O6l36DeSKTIvwgc7RJ0NJ1ErHehwT+g75BVPZCjm?=
 =?us-ascii?Q?rkw83C0Bx0cEWO8jvnzfNES77EIDGqTx4o+XxO8TM3OcZx33ZxSjDG/mwoL2?=
 =?us-ascii?Q?JDT1DgkRwiloLjBFBN+doca+pRmrEUp2P3EMK/buW/f77Bz2hF4zcsnX/Bzi?=
 =?us-ascii?Q?3QpjJkWJpyxFRWUezg6V1dk7/ow/mOYJMZczQ6BJLh5Yk72dwlHcYN/340pO?=
 =?us-ascii?Q?CPgXUIuIlCyx0DC9ZscoO7D9UHsDmTmUU89MpE0la9wLfz6m8nsUOooWhR1H?=
 =?us-ascii?Q?Nd1zs+Gx3aNwRSAb5Sxt2DvL6sPiUzvAvwroT4axloIfnf/p0MOYJ4mafYpF?=
 =?us-ascii?Q?uzJj+cuLYCPvK8SYYWYKVn6PXf5X?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/RZlxtIH9/pZUgkNNBLPtzCeiJ3/mhgcK/TL9ilLNSSX/eLKx21cY77+gVn+?=
 =?us-ascii?Q?mnBoAiSZNc3f46+f1TNCdVXl0BQUUDQbM8/8QEyJoLIJx1tV6uKSXJiriuwC?=
 =?us-ascii?Q?Ay37ei8AuiNn9oJ5Pz6TzdfGFSMcDpK3LkkKu1XEoJYBxJv3jJ67CPDGe29M?=
 =?us-ascii?Q?FxJKllFnRDYo/PEDr4DIbAr3/i+AAURilu+/2kp+wPHt3w6ogPOnTvkCL7bg?=
 =?us-ascii?Q?Kvg2HrON8rIQHyfsNXwNcVlqqStqoMOEhwBJLy87XBW2vZeyKI+Y6N1Dj5wn?=
 =?us-ascii?Q?qz9WD9mTK8uA4Bwm+TuYgUd/+Z5y9yThXANfaJqs0YGaqkG+spwFcuz0PQIu?=
 =?us-ascii?Q?//RrIUrDX8yBIHEDF/tcZDMYhMhX2OU8i1LWANDbJZMrHHRBhugwxyKLKpHv?=
 =?us-ascii?Q?2MlVZI0QsGs3rJXnxiqXt+snp6kl1VKN4Qz2T73qhBropaVu1gHhgUfDCsTZ?=
 =?us-ascii?Q?u/m9u0nCBLZ79l3vx80y/lFGhLcVGgBF0AwkTB3UJreVGEMRPMm6YLLwr7ZA?=
 =?us-ascii?Q?ieJmFvHUj2nItx09Z5pt32ZY4nqdij1hCvrN+YPTevHoNG45HWrbxLmP3HOw?=
 =?us-ascii?Q?enfAkXb2c7EQWX7zpWo0+0FOwsGI31G4DUTzTWnAJiby2YuJkHTaJz5riv07?=
 =?us-ascii?Q?Q4Oxjrps/q2tn3mdBvzWni2rinkaDBMLFmEILaI3vC72evrCaDmTa4ZMVgBp?=
 =?us-ascii?Q?ldx8NlpgSuXf5OPA7i2i6Rrp6OtVQc1x6XJJm4UWiPPyytERLp8a0Ut6l3JU?=
 =?us-ascii?Q?8aR0qZqDMThv42wctpEQl/dXv+PghfZUy08gUzFDADZecMllaUrzZCo+quT9?=
 =?us-ascii?Q?S6blIpn/f7g4YjzPQo3e3FdXoLlPf+doCfoa0ulzrFVNHRiL95/h2xcP2KAr?=
 =?us-ascii?Q?bSf+paARrrLwVluEog9ApYeqgYyPh19toELe8/hJL1A8mIdqIOczZpCZXjk2?=
 =?us-ascii?Q?L+tHuoSmIWiqoAFy8VEGX+j97sgpijLaLC1I6dFjuzwAN1PxneYyY84Sf8hF?=
 =?us-ascii?Q?pQ4kQly4sZZMJpOdkoyZ2thnrYZc6KiZs2T5yqtd6tPj7ur73usjcvnm7Xyl?=
 =?us-ascii?Q?xyYQ48kF8Mguv2zjD9yMQcNtumNDm1txONwHYXnvfdTcUf+TSwhc+V07Gajw?=
 =?us-ascii?Q?7ojQyrpReRiBaLYBndjDW50nK3f1Q2ZBppJl80ULtwPULLwjokNpSIv6X6RY?=
 =?us-ascii?Q?sfVwoXy6+loitMD05LUqGRKEGbTn6nQPiTceBC5rb7CZv5Ksnwsrlm2krM81?=
 =?us-ascii?Q?W4b+fNFfMqJdvhQVgcm+c86ZnkVMnvaOipJWUq4qRcdw1SUoKiq4YkchXdKE?=
 =?us-ascii?Q?LXzIn4WsKOSIQzq1aFsxeyMIu8h5I/yMk3B5Z5c5JgoyH30Dt9xuw5aNpKZ0?=
 =?us-ascii?Q?QCNY3+ni9d6RcEYSyOjfjr7gS4VWzS4b+n0dHUh7LHEVT7Ch92U+O1qAhER9?=
 =?us-ascii?Q?3ogpT4ELcFsU2Ipza60Q0VaZRpuFKVoRX37FclurqCvkj+J+y1Z0lLjgWK1M?=
 =?us-ascii?Q?Ffrn68Ts1LsDBP5WYZ6D45vqnYEjjk9m4Oi5MmKl+Knwv9jzowsZ1lQOi7Pr?=
 =?us-ascii?Q?bgZJ2ixWrdzjqk0X1RqpDv+rWcwI5yM9KOraTdtp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 887b88fd-91d1-42d8-1cbd-08dd45b7b226
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 07:35:42.8339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IydTx5+7v5Hz2rrL3XuTeGLGIAGkaVUQIthzrEPDEjdLBynfuxSkQ+1Ab+kocC4h2/TcqJ3T5E8K3rCTIO9BRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7368
X-OriginatorOrg: intel.com

On Mon, Jan 27, 2025 at 09:04:59AM -0800, Sean Christopherson wrote:
> On Mon, Jan 27, 2025, Yan Zhao wrote:
> > On Fri, Jan 24, 2025 at 05:23:36PM -0800, Sean Christopherson wrote:
> > My previous consideration is that
> > when there's a pending interrupt that can be recognized, given the current VM
> > Exit reason is EPT violation, the next VM Entry will not deliver the interrupt
> > since the condition to recognize and deliver interrupt is unchanged after the
> > EPT violation VM Exit.
> > So checking pending interrupt brings only false positive, which is unlike
> > checking PID that the vector in the PID could arrive after the EPT violation VM
> > Exit and PID would be cleared after VM Entry even if the interrupts are not
> > deliverable. So checking PID may lead to true positive and less false positive.
> > 
> > But I understand your point now. As checking PID can also be false positive, it
> > would be no harm to introduce another source of false positive.
> 
> Yep.  FWIW, I agree that checking VMXIP is theoretically "worse", in the sense
> that it's much more likely to be a false positive.  Off the top of my head, the
> only time VMXIP will be set with RFLAGS.IF=1 on an EPT Violation is if the EPT
> violation happens in an STI or MOV_SS/POP_SS shadow.
> 
> > So using kvm_vcpu_has_events() looks like a kind of trade-off?
> > kvm_vcpu_has_events() can make TDX's code less special but might lead to the
> > local vCPU more vulnerable to the 0-step mitigation, especially when interrupts
> > are disabled in the guest.
> 
> Ya.  I think it's worth worth using kvm_vcpu_has_events() though.  In practice,
> observing VMXIP=1 with RFLAGS=0 on an EPT Violation means the guest is accessing
> memory for the first time in atomic kernel context.  That alone seems highly
> unlikely.  Add in that triggering retry requires an uncommon race, and the overall
> probability becomes miniscule.
Ok. Will use kvm_vcpu_has_events() instead.

> 
> > > That code needs a comment, because depending on the behavior of that field, it
> > > might not even be correct.
> > > 
> > > > (2) kvm_vcpu_has_events() may lead to unnecessary breaks due to exception
> > > >     pending. However, vt_inject_exception() is NULL for TDs.
> > > 
> > > Wouldn't a pending exception be a KVM bug?
> > Hmm, yes, it should be.
> > Although kvm_vcpu_ioctl_x86_set_mce() can invoke kvm_queue_exception() to queue
> > an exception for TDs, 
> 
> I thought TDX didn't support synthetic #MCs?
Hmm, it's just an example to show kvm_queue_exception() can be invoked for a TD,
as it's not disallowed :)
Another example is kvm_arch_vcpu_ioctl_set_guest_debug() when
vcpu->arch.guest_state_protected is false for a DEBUG TD.

But as you said, they are not possible to be called during vcpu_run().

> > this should not occur while VCPU_RUN is in progress.
> 
> Not "should not", _cannot_, because they're mutually exclusive.
Right, "cannot" is the accurate term.

