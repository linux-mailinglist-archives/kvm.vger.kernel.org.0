Return-Path: <kvm+bounces-46767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9C17AB9629
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 08:44:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBA46A05F2D
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 06:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07EBA22652E;
	Fri, 16 May 2025 06:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BWgwG5hy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE5122CBFD;
	Fri, 16 May 2025 06:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747377809; cv=fail; b=AOE+V0pC1pGEMCfODai6h+Q9/IPni2NVB8X60Z5z8B3VRUITE3KoR7n7rg+W9/O/hN+6U4bigNYx3p93MZk6HT95pds6d74F2lRVdysyLhX8ofeQ9v/WRmM70d9RME9QRhZ9ooqLSdO0V2kCOvpLS1leddESu6rzazyeRFCKgyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747377809; c=relaxed/simple;
	bh=zzrM3grXjTCu1e2tNn5LyYKycG5utR7UsBpZiBI4A/c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EV3RYgn/mxr9aAgc2Hymb8cTZMiDx3S+w3Ut+SDC29TZscB81SRCChDH6A9K8OCiLHE7KEhYBa6h69HTJ3jrGIWHyVRyPl9Y5HLWjV71w39938TTH0qUzym1+B5R0LIegkKiqVJHwKK6j0Jl20U0UfkHCy3PZrz9Zy6xPBZHNPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BWgwG5hy; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747377807; x=1778913807;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=zzrM3grXjTCu1e2tNn5LyYKycG5utR7UsBpZiBI4A/c=;
  b=BWgwG5hyewzuFv6Pdk1cj+vdDgqHbwQ86oxmQDn1tYkJF3NM39WZzCAR
   gpDQ7XypurIFyWJdylQKwqX0MlbUFZc31IfA5nTQLkvygo1qCTvpMq8uD
   6lsFi+Ne6AiNRxXU3ZHEyVEmIGBeNmM3CkJQwTobhS4L1/gsGUA9FAYNm
   4Mmcu9WXkVClUj9r14CzKkziU5ekrHUc1THF8bW7j8k16KBEVUeJOyg13
   85S9j4Ga3GFA7OY0nZxxRZbN2zsUr/sEs8n2ZPLsSiho1X2PI9iK8VJlc
   98pkfmZQwzkdZwtv731ju2ir+tOO8wlu8ozrueDMZx3GppqchWEt22ixh
   Q==;
X-CSE-ConnectionGUID: kEjJwwqLSp6guDOMTAqRBA==
X-CSE-MsgGUID: z2whsgmSQEeyPIWXCMA/bA==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="59569612"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="59569612"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 23:43:26 -0700
X-CSE-ConnectionGUID: 9ZQxlxVASouvOzQXJOczxA==
X-CSE-MsgGUID: Lxo0CxAOQJ6N2FWoPUlvIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="161905286"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 23:43:25 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 23:43:25 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 23:43:25 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 23:43:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mow+xYvPw61k45rt79PGBSBOE7VCGkBuORihc+bWLYqiUVS+8Y9GOsi2MTjw/dKih2jIkMzkIQkelHQV9TffV4txWqKZ9N+TbUQPX25qKN3pUYJLZ0lUSP3wBYd61lYo1MPz/camSzmNbGoJkOiZ6BZ+CwZPz3/bhBxCoeSDODvppFbVAadJvM71f4FRAesNmjF3YtP4CuTq4qujrwf9+c8N2pjdHfvBhRSd4PLyJIUJFMvWQi2/xPur1aDV4f4cBSoJTN+xsTQSAa215qPhPRkh3M7KSLgmvgOQeJNJ0p+ULEEyIfp+ZBwsZ83tFh/CMTKSS72+qAcvqlOFlWS28w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLMNQAfdJbk+krcKlXzEdoIqmNjU7/fo8YWyPgSZKJU=;
 b=Ern6uF8f+BFS1s480Cavr7EX3hlfFRK4dJ5qmVT0AE5W0HHxzKWUpoEYCXKOpfW5NGPgKK8u+oQrqHA3J68KPdrUHR1GCVCu8x81+nAh7NIKyQXufckOISFmRbX3cyxBsEGqEU4qMvJmJGn4VgDupZ0B6aWJiQJac5DicpTWfh5I+9wHCQSIY+O3+g0U9mMoGfVfctWUOXZ1rCfAh++1+Yi9VSc/qR60mdsquIMLhQMH0hj3/pxNJUGd1JPs7LzlpgTLOtdiLlwqU13vxoH4YYKi0yg9Rd7EGV3p1Cxsrjlp0rVupMdQPLvFWr8OiHjM+juvbF6Woe3gNsjDTFymSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN0PR11MB5961.namprd11.prod.outlook.com (2603:10b6:208:381::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Fri, 16 May
 2025 06:43:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 06:43:06 +0000
Date: Fri, 16 May 2025 14:40:56 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 21/21] KVM: x86: Ignore splitting huge pages in fault
 path for TDX
Message-ID: <aCbd+PPqFWnpIVTg@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030926.554-1-yan.y.zhao@intel.com>
 <f1c4d09b81877bdcc16073afd70a48265ac5230f.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f1c4d09b81877bdcc16073afd70a48265ac5230f.camel@intel.com>
X-ClientProxiedBy: SI2PR04CA0018.apcprd04.prod.outlook.com
 (2603:1096:4:197::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN0PR11MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: 9128c955-72ad-42b5-a867-08dd9444ea4c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8AY9vIz97KK0Ja5m7BrrdlV3tE16PYUa4NEP4tzyk93ti7WB+GFnLNmtVHKS?=
 =?us-ascii?Q?BzMyvjzsIzu1gtaVV84jzdTG966k72XroXr67wAFBBBDArdgtcgJGEg5tXAM?=
 =?us-ascii?Q?XE421de4IGH7taXhDcbKA+DSL98TZpyvBDF37fAQMYvL9iyZnlSXkeoCcRME?=
 =?us-ascii?Q?F4kWwlZVsh7UK3/ClBZw/6jRZCd4PHzsuZgxabjWD1pssP3622mRQjHjNj8v?=
 =?us-ascii?Q?ZtjMv8HKsLS33ste0KIYXzMYejrMNLLyjaB/BTW0fiPKko9F1fOnNu3iLh/o?=
 =?us-ascii?Q?FhGiS7oY4jaB5cPX9LRy76BI+2koC0u5H7tsQ/GPBwhWD584PkU2VpXegp3F?=
 =?us-ascii?Q?iaIQslDgskQLxfhsV+9K8/tFQGvhw/h8J+NxbWnoNKsHH8xqxqhV8eII7hIy?=
 =?us-ascii?Q?dxMXdiM4mm1PH+ZPSe+14clf4GMm7yMjrTt14fQGw5U9+qqLj6RKU8mFff/V?=
 =?us-ascii?Q?/l6gvp+Hu9Y9J8GUsybjF5Rxh4zKPF0xC4+nNgOqMHdz4LOYFK1XmHuI+SLj?=
 =?us-ascii?Q?wZWhzPyMNfc8e2CgEJF20OAEbkU/tQkMEOA1qiov8Gi+gNOm2DehTiqHO1JP?=
 =?us-ascii?Q?wvY+ToYcYZqN2ijymlDtJ1MXLVT7T9KRpW3QnTZXd5EvVmI/Al2pVnB1OebX?=
 =?us-ascii?Q?C21I73KJgc783F+tlIvEIaMXTUoAd91in60/mDadI0D/LIRlS2PhiGv67JuG?=
 =?us-ascii?Q?2NARtGI3+bw94Ytx4TPYEMX5eJ6wags+af7l9nxiua6RxdmwgTzZpFIbGX1f?=
 =?us-ascii?Q?tcinf25pvhyfGGz6SURY7zSmAwuawev8Qd8oQjN9Ti8r9gAmeaaxjG7zmTBy?=
 =?us-ascii?Q?Ph7Fs+yPnxB9+L3OArAyFBXsSpcPgUWkrRretOofp1Cn/MbE9EOG3NLG0DIS?=
 =?us-ascii?Q?ym+HUb682Juss6tm82GiEQLSoHTzArvAFTq9vOEJp8j0f/O2c0iiEqdOtzbf?=
 =?us-ascii?Q?c5LePibdBWzj2QgwzGw0S70r9/6f1m+a+SPZPwAXzQ6nbFimEOwvBqHyTyH/?=
 =?us-ascii?Q?nQUd2BF0HEqukjp+xsyoCk5S5Krz+zsEkp0uMsM8f6O1Zgdp7RK1onzNY61I?=
 =?us-ascii?Q?j3XNvyNogshUC9SM64QVUnwmUMQMhyahC7mUCO42/pvQz34lyhwesr/QPLw0?=
 =?us-ascii?Q?OfimJ8EStypSaSCpeLTWT46Hb3d3+HNmZB2MusmzESpbypnYJbPgNzwjIL0K?=
 =?us-ascii?Q?SQjdhE9Yr56ZnvhDTDrEnkoTRc6EuS4lgjV47IzkNl6tLpAJ5hZbSBy1mBrO?=
 =?us-ascii?Q?4pvSFgYfaZSn57lbZhm0syzU1QvyPtgGXkuFwmntMdz9wwX0RYWIzA9eFmgz?=
 =?us-ascii?Q?gGN2bsCEOXr5f7PMs1Ra5TkRjsrnfeodxd601PkVfJdofIT3WuhvqQZ5mFbs?=
 =?us-ascii?Q?o3SU4iGuFRb5aeS0hSgqyYPimUchjuXzZE/Kps7GDujzMHNacVS/QVMsdTPr?=
 =?us-ascii?Q?5/K6wB6kOqo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q97OX2dRR2+BdQWnSqkYAe/UXMUDJH1z2ztwsoe+SS3YPQEU0A2AyTepJlBV?=
 =?us-ascii?Q?gqw+/7LpbB1DmJuIZ67Nx3tdzmbS65nMcT8kCgFBWWwFi75H47VZa4CaW9jR?=
 =?us-ascii?Q?juh/SjvYIJ4CdIUXL0B9GWxp+/2xZnMGMSVt+WLlqTsx2PMDO2G6jRQMYecH?=
 =?us-ascii?Q?GVC+ZPsFt4JKcJxI3ZT7kI2CB30SUBXtHjPpWf8WtpzbFLGUDoeTly7n89R+?=
 =?us-ascii?Q?WTYupi5Z3DOeOdw5Ghx9SI6buCNCPDSHQ2TmC5fiYi/JlX9P+VpJoYiPMw6D?=
 =?us-ascii?Q?q6Zkq1OUhoiblkv2CNzsCc1ArkcHR6rBa7hhOnXZYAsanyqhJJ/Hs3fVLmir?=
 =?us-ascii?Q?nzS3VIVZhdjOHO34FcZfhx5nrdpHVLXW3nH5q7fX2SkeuCqsgPNO8XiGNrMx?=
 =?us-ascii?Q?rzxjuqut/+s+lIciAsRYC+xs/DSytUHVo2JdLRMWWAaJTMvFSOY/CuDwQR9R?=
 =?us-ascii?Q?r8Qb9mlR5S8d4KBspl5IGkpmsAenIOOsMIVt2NosVnll9fAfqdl/w0cWLzAX?=
 =?us-ascii?Q?pzyBqVQWQ24YUBwgy1+1JkmznXqb6qkLTJ0wIu5oM8Pw7Hfz+HLNqMW7DprR?=
 =?us-ascii?Q?N4r4SjYaaI5vAOYE8LreWoh5ZpQnLQGW9OOBWjBcU7PONxG3LQKlWNYrIez6?=
 =?us-ascii?Q?aQMf++6hQ1fpFwqMwNjh7SYOTmFtMdn2RBv0chnBApx0wq2f0YLrASYuPwfU?=
 =?us-ascii?Q?d/lJXSXMawHAPgSNNMhiTmwzVqZV0bA30xs9D50Ju4xy/maV/bU7wjIlzNyx?=
 =?us-ascii?Q?Djz+ZTt+j4QDZLZHx3ipKLjtuFgP83I2TKgFpeyMCWw17NjVIAxdyBNEON+f?=
 =?us-ascii?Q?9CnzcUAnXja0AtdAsfdUuEPSzdE+oSDPUMUrSYnncmNMlzAVRSHhgchA4lLF?=
 =?us-ascii?Q?ff7lwN6cNaTZqk3++WYMdDLQZ/6y0eiQAJiQvzsomB3jLEglowJy+2MzMAiI?=
 =?us-ascii?Q?X1A0syUCmkt9v58houief4jEUwSADr2dKBbKAv5c0IAqDpNtlxBvkxasyot5?=
 =?us-ascii?Q?QDhrwRUEqObqIEvMZ9XwMV9TjIFs4lNOXrip4Zei6tQHx2VoNzI8B6IyfiH9?=
 =?us-ascii?Q?TSlb8U4aenCSEw2rSe4MMfRYeLZw+6FrOfYBSaceEbS/f7D1U+Aoh2E2+Drz?=
 =?us-ascii?Q?btiFoJRebPRd2NEw7vDTjgf27Y/elQNAgxxhBbelxFhjLcmNCd1TD548maKP?=
 =?us-ascii?Q?ZjYPWFYpICbsDcoNr95Id/ToHW1g17yO+G+0AO8135kPPCmhDitCFFeNSMno?=
 =?us-ascii?Q?/f/pgX8wFLtIQVZaaj7bQkwNPFU1SrRJlJWmP7IETsc0Hi6e1y6pJykAb8Gm?=
 =?us-ascii?Q?hqokFUEDqcBh8xJbq1V6ErGubmPnNQoqTWqoYINliRiT3k3UT+9epmn4kQLl?=
 =?us-ascii?Q?7Kh0qaaQjyGJo+j/Rm4cVCNFMbMndVizBoYbjCl6brg8xw7Ptm84gCC9fYRJ?=
 =?us-ascii?Q?yQVhUIkrbOW6nQMaqVjtW05wJQMAm66BXv9X3UHaT9s7BDso1H/95JVJetav?=
 =?us-ascii?Q?E88bJxW55kVQLre4kSwrhNV+g+BvCK5pVrLpNoexeou4EG/SQOr0kBeGqAQV?=
 =?us-ascii?Q?2cbSEHgOoqPtpmDTvxE+wupnacMfrdhv8AB7El9GacXOdtAhsLIUQpRNj1IW?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9128c955-72ad-42b5-a867-08dd9444ea4c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 06:43:06.7927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +NhkKdug+ZS3SW7PMPzsDArerCwmR/oHpqZYIUrG8V8TVTtPcSkvZsZcMvsWHafLkYMIsY0N1yfkhEl4xLGs2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5961
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 05:58:41AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:09 +0800, Yan Zhao wrote:
> 
> >  int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > -			       void *private_spt)
> > +			       void *private_spt, bool mmu_lock_shared)
> >  {
> >  	struct page *page = virt_to_page(private_spt);
> >  	int ret;
> > @@ -1842,6 +1842,29 @@ int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> >  	if (KVM_BUG_ON(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE || level != PG_LEVEL_2M, kvm))
> >  		return -EINVAL;
> >  
> > +	/*
> > +	 * Split request with mmu_lock held for reading can only occur when one
> > +	 * vCPU accepts at 2MB level while another vCPU accepts at 4KB level.
> > +	 * Ignore this 4KB mapping request by setting violation_request_level to
> > +	 * 2MB and returning -EBUSY for retry. Then the next fault at 2MB level
> > +	 * would be a spurious fault. The vCPU accepting at 2MB will accept the
> > +	 * whole 2MB range.
> > +	 */
> > +	if (mmu_lock_shared) {
> > +		struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> > +		struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +
> > +		if (KVM_BUG_ON(!vcpu, kvm))
> > +			return -EOPNOTSUPP;
> > +
> > +		/* Request to map as 2MB leaf for the whole 2MB range */
> > +		tdx->violation_gfn_start = gfn_round_for_level(gfn, level);
> > +		tdx->violation_gfn_end = tdx->violation_gfn_start + KVM_PAGES_PER_HPAGE(level);
> > +		tdx->violation_request_level = level;
> > +
> > +		return -EBUSY;
> 
> This is too hacky the way it infers so much from mmu_lock_shared. Since guests
> shouldn't be doing this, what about just doing kvm_vm_dead(), with a little
> pr_warn()? Maybe even just do it in set_external_spte_present() and declare it
There's a valid case [1] besides double accept to trigger demotion in the fault
path. Kirill believed we need to support that case [2].

KVM MMU core can't tell if the demotion is caused by double accept or not.

[1] https://lore.kernel.org/all/aAn3SSocw0XvaRye@yzhao56-desk.sh.intel.com/
[2] https://lore.kernel.org/all/6vdj4mfxlyvypn743klxq5twda66tkugwzljdt275rug2gmwwl@zdziylxpre6y/

> the rule for external page tables. It can shrink this patch significantly, for
> no expected user impact.


> 
> > +	}
> > +
> >  	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
> >  	if (ret <= 0)
> >  		return ret;
> > diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> > index 0619e9390e5d..fcba76887508 100644
> > --- a/arch/x86/kvm/vmx/x86_ops.h
> > +++ b/arch/x86/kvm/vmx/x86_ops.h
> > @@ -159,7 +159,7 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> >  int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
> >  				 enum pg_level level, kvm_pfn_t pfn);
> >  int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > -			       void *private_spt);
> > +			       void *private_spt, bool mmu_lock_shared);
> >  
> >  void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
> >  void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
> > @@ -228,7 +228,8 @@ static inline int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
> >  
> >  static inline int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn,
> >  					     enum pg_level level,
> > -					     void *private_spt)
> > +					     void *private_spt,
> > +					     bool mmu_lock_shared)
> >  {
> >  	return -EOPNOTSUPP;
> >  }
> 

