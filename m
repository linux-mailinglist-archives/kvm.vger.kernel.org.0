Return-Path: <kvm+bounces-57062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3220EB4A4FE
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 10:19:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E0C77AA497
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 08:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D290224A078;
	Tue,  9 Sep 2025 08:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ue43Q/pk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B62A2459E1;
	Tue,  9 Sep 2025 08:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757405950; cv=fail; b=ltfWLZ+4WoAz+qIRpihMUJFvHI2aO86r4WhIoCmqydL2eDFkJ4SoWTPov5fDmPXRFyr/kzHi0UgpY3Xoj/Sqza8FqMNfJXELYJXxBn000BLD0unk7ZRRadNu+El6LgrzqhXvhnDNRvXAzfn1EMeOlS0qmhSoP9lBGk0mp4fkjDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757405950; c=relaxed/simple;
	bh=jWV6X8IaZbc1WIO9kFFr+EBw5Do9wyF8m1Y9KqoRVV8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aGg8GFjlmTNmGsHaQTvBMUeWXf7QWhQjj20aQdc1ILJe3etol+5R9z8x0z+RekFoWcEOS8ZwXGnnvYiv4ZKStGU665mAeBsIuml09NSi4eNfQfdmiSB47IYMupvtxu06lEIbCNRzKji4I5aCXpeE9/T652Z9jO54OWTkfwpatjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ue43Q/pk; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757405949; x=1788941949;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jWV6X8IaZbc1WIO9kFFr+EBw5Do9wyF8m1Y9KqoRVV8=;
  b=Ue43Q/pkOsqRgij9RyiUyI31YKiaNfhe99HwJ6Z8Z/yaqIu9g35xKDRL
   9LxLkCtW5P1m0oIEiXtdfZm7a9JVpCwmy/IlHpCk5+22U289Me9jcDq4H
   VRg44WninQDGarllqPP7yUfjNjFfndHnA2jJETLkfWKgYx73HsPWlEMW9
   jY6GGaZWufOywj565S5+W+3J472dG0v3Xp3QOj8eUvGxHrPJoNGPzPPvU
   DPsas34SfkV1pJHmwsbFxmmIBTawBBXwyCKY8z/Ijnq/0SdfyUqwaEvvX
   tcwB++QcPkSSoYOcJWD5rejPTFWft5R12dNVVZkxy5cPhlAcIrNM3zoTQ
   A==;
X-CSE-ConnectionGUID: FDKf/JUqQBeHyU2t33jV7A==
X-CSE-MsgGUID: wBKBQt4zTFumVYQMu2f+Iw==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="63511465"
X-IronPort-AV: E=Sophos;i="6.18,250,1751266800"; 
   d="scan'208";a="63511465"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 01:19:08 -0700
X-CSE-ConnectionGUID: 2CzeqX3PRgKY5sY/RGp0Qg==
X-CSE-MsgGUID: jf+2IxosRDyiIkMyJeeQ4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,250,1751266800"; 
   d="scan'208";a="178242255"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 01:19:05 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 01:19:05 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 01:19:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.57) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 01:19:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RALWTeSPKseH6mwkN56IjfuEiPFI8Fi06Me0Zp+84KKIAQ2LwsSl9U5SjkilEdbK0q3cEaFWxMhibR7pxhy07zBLPOyWVYGxSKKhOd6Sl2+74S9JcICn/J8d9WNUA9ftuoW8txsYNKggqe3sLnSyF4T3mGo1gR7mu3vMfvm+6f+n72vcViCto0pu6B3QeVGZLgAgdkkqgh43DLD8hQhoCU42ERYITKMbmF7F90SXB39wEQtg3H6sCBx4NOlRUndqFi4q4ryx3RekPxMd58FKeXC0PT41V/p/yem7c3CA9cPOl+IJ9QcJbvQ6ekD1NdTJeSRPvzpYrNNQZn631/E16Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VsLd68xtRB5SZtMIYLpzGu1kqW1aWWvqhiw7kW4p3Ac=;
 b=i1sVlt+zI+G4hh2JiuFgQhKWzUZj2+i42bX2akES5UuUNVtYUvuuQ+oPwHD8PhQPo1SlslJTPaZfVaQbagS6Fj6ZEoCuqvJMVK7WCw+Mn5dhpB8gmBZAlG1E599NCt4A1rAYqx4aXm28CRUxQ9Yz5VUUQgMQpd0zi1xxAWE7cAIXNVkeaLkFYQCTv/Rb31l9oV/MSWQwIpIlsnH/yh7uKzC3STsOAmhlaXW6xOOeswWfacnORrsKnuQdyeJLWUrVuMXE7xav4r9BhJJZeD7pKOMTAqTW0CP885OK+r2wDFEWe7Eq7Y9TCWCkGzrzDfrnEzl5IquUD7dASllsMHEZ4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB6944.namprd11.prod.outlook.com (2603:10b6:806:2bb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 08:19:02 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 08:19:02 +0000
Date: Tue, 9 Sep 2025 16:18:49 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xin Li <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <john.allen@amd.com>,
	<mingo@redhat.com>, <minipli@grsecurity.net>, <mlevitsk@redhat.com>,
	<pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<tglx@linutronix.de>, <weijiang.yang@intel.com>, <x86@kernel.org>
Subject: Re: [PATCH v13 05/21] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
Message-ID: <aL/i6cA6EjjZ1H6f@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
 <20250821133132.72322-6-chao.gao@intel.com>
 <b61f8d7c-e8bf-476e-8d56-ce9660a13d02@zytor.com>
 <aKvP2AHKYeQCPm0x@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aKvP2AHKYeQCPm0x@intel.com>
X-ClientProxiedBy: SG2P153CA0005.APCP153.PROD.OUTLOOK.COM (2603:1096::15) To
 CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB6944:EE_
X-MS-Office365-Filtering-Correlation-Id: a892ea59-71a5-4ab8-9eca-08ddef7988b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?liBgu3CtRCdqgHq00CVEOZmrTrBWL9pGFNdzmqP8etRIhytdXWr7/1kTerhR?=
 =?us-ascii?Q?fWPWYp69bthBZnrGrU3opDzCnx2AoiWNPSMj9DBfzqQN3AX006sX4XEX9o+K?=
 =?us-ascii?Q?EbDe3JU6gze+gmuYi1RxDBP97kFmVMBda0erPJDAU4CShVhvs1p00MDCIqdr?=
 =?us-ascii?Q?LjrenjxM4fLFy/DBtpq6a2KFEzG3SE8Fs2q9ys7jDhtHe6YRNqifh4Ef4hmm?=
 =?us-ascii?Q?u59A6iiy23Ded8/34KuLBxbwAa/nej7L3Ppo1ZUxINtqO8vrIE+Y9bPyGsHy?=
 =?us-ascii?Q?jDut3/FWb5R3bqIAUonz3eT5Im9hjgPI0JMoI9Mwg3cPOgmJ1XpLjAzeZ6fv?=
 =?us-ascii?Q?o3Cc64P/ZQuRyJEeCIbX0NvP6Lu3KxML9fg4Z+fXE9ZJx3x7rLUsvXTU4fF6?=
 =?us-ascii?Q?INPxEsZdvDTvkp99slC/Hca3duVef3oIvB1GA2uoo2LNacYRRbPbbRvh6Suu?=
 =?us-ascii?Q?gGUG79vlJiOd7NrrU1zSJ4EphBcBv9ExNbNXxEDkb/oLLRgY9ysPYRlOgxbw?=
 =?us-ascii?Q?toU6R9Unfcrr7AINtGfXkUc55c9LuKA5s+PFcc7s2QRhFLLsUhnKHhWkUnc7?=
 =?us-ascii?Q?Nc9FzelE4HssMZO5KcvLm99RwDwQKMCUwlOQp5ZzMEbbB3xxR1kv34bxjyMl?=
 =?us-ascii?Q?H/UXC69gPHhuTB8VJz7akWN3I95FpCbVYSizy1Un6NhWYQ7/JuIfCCKocjBd?=
 =?us-ascii?Q?AUs2s91v4lMnG2m4S+0MO9bcIUAoELqILT7O32nwphFUhg9w/mCYJqXvXNwO?=
 =?us-ascii?Q?hY3cmMrhkjfb71o+8zlh0/qonw8zyj/uX4Y8BX4EG1A7WjQ36E+9+EscWs0X?=
 =?us-ascii?Q?SSHptFrLeO6KNnenkR7oiOA45ue3xJUey6BR28WyB5S2SkOE5vVUYPcEC80C?=
 =?us-ascii?Q?NPbb7dQhlSjJKWSd1kyocxG6tWjmt96/rfg3W09FdgHhlkJMf65FaARNAqQy?=
 =?us-ascii?Q?H/woXxyl88badvyGKFu/a5Fsj7r8c39l16NLvdM8iUErhVsJJevlRtQoL12t?=
 =?us-ascii?Q?HcLqY00MQVZFJAw/50T7yAIx+AUHg0sALiD/dY+qJ7x6CYvRtqfFAuC7jpTS?=
 =?us-ascii?Q?7lRivivHt9k3dtZss7TN9OXGvtHhmm/XMFHxZg4WsjExanhvPrx3VHpVNBn8?=
 =?us-ascii?Q?L9Qu45i17HtPMwgTGrKq/pQzofgBGhNcvImIROYcMddnW6umAvGk+aoQ/2ue?=
 =?us-ascii?Q?9esk+AsbYWeFQFZAs+8qkzekyGZfLCyrtB0wJrV/wpsrlsVS5QiwJqP1rl3U?=
 =?us-ascii?Q?eNmwmiZP9GPV2TY3dUlxawhoViC+Mae+GsvgNUE2mc1H/8NSlFfn1NJvHiYj?=
 =?us-ascii?Q?Mq3tn1tRozSNTcZsUZ/L9I2osrAxxBHie8DXxwopaiVg6lkw8TF6c5VvLnjs?=
 =?us-ascii?Q?IAR5PMrn2dzYiIXeW/TjSCgyMYWo9O31AS19xaWktuyxGQUO81RjhjJylA/y?=
 =?us-ascii?Q?fumdRBt/CSI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u4s2VZmILLocZNitXTsn0RCW1i7TnjW3pGSFDf1wKKhEK0qPr+KJF5wqWmcX?=
 =?us-ascii?Q?Sm1ph1iE0UoqhpZVsO46/vK0p40RxElZzXbqbKdzw+ss/bltUQSgzOK99ZRE?=
 =?us-ascii?Q?js2aLvJmKnOb+V+LYI/izjqTigU4TGwd01n767E60ZH7Ogm4VhT4gB51G+xx?=
 =?us-ascii?Q?UwZ01BzQgeYLMjKOYpPKVPcdqTKhPyrWACBIfWe6NMeaTYh76kw0f+LWxfro?=
 =?us-ascii?Q?H4f6EmPhHEPqnnZA1vttNSVQxufZ4szo+WMBthmmw3tAAJbbd1br8WcL3Voy?=
 =?us-ascii?Q?Oz32EUlzZpkQAKmbuuXh0QFGiCZqN47ye6TuyxfahHW5olbOhoLX9xPk+PJU?=
 =?us-ascii?Q?sbR78HVxADANBcS1ktwzN/WSvhwp9VT5OBN2zaIhWQa+PC9ZiCHtOE11vDZN?=
 =?us-ascii?Q?YrATKxvLRLA+fRYnWM8y7wG/4KQT/WoxhY8WnM796s3fSgi8knCrgjutjlgE?=
 =?us-ascii?Q?tvdmf+tSI/9Fs+ckvElI7Ma6lH4YOiM/c116vzEttIYyuMcmHNNzAEvR9e/n?=
 =?us-ascii?Q?f67N6XXXaBlst7nScsla9df4zFRCL6zexzhQNTKlgVLbxfGOEDOIT7m2W96B?=
 =?us-ascii?Q?KXQmE7f+NIyILKwM3B5q5lhwYt+pWJsKppsoFaoGEwnNk9xAlqocWqIAgt0p?=
 =?us-ascii?Q?rf61am5oWL9XxfE+eCebrUnG2o3NPh++tl/TZQylOGRX1dTsiJziHaFjJUVL?=
 =?us-ascii?Q?MXL9E57SANqq2NcVpQ257PHNqDcg04CHFR6YiGU+wk5KNn9XBmcsk7FuC0BK?=
 =?us-ascii?Q?1c9UekOBwAYSr2308IC3yrYJWU6xz9S7Bb0y/Uw6iaSwZmzY9JQZ1MTIb7US?=
 =?us-ascii?Q?Nd4CLHKf9BujzfQm2NlGd/sQsYzzbMKpNwrJAt4tFrNsGnDFpn/3Gc8R4ppe?=
 =?us-ascii?Q?9BsdZlD9HxQfzZMpQCNpQdsSdaSJuJi7DxemRrvd93ysSvtJUVgwQn1Fs+Sa?=
 =?us-ascii?Q?n5VSU5TPSjudtQGFNggtplOJjyRJh+7Og785RB2/NfEKgb5Y1yAnc2LR1cok?=
 =?us-ascii?Q?SUB2JuinzfAI4co1/26CwShxhNCo6NCE3bR/vPJy+PpP9txMelnePAt4mV2f?=
 =?us-ascii?Q?xzQDGz/sZeb1dUmECHSFdIw0ED7XbbnFPXrw4zJwXdJvofrFmrUslbuGSIlX?=
 =?us-ascii?Q?ht6Q8pxolIKqWueeN1HjMv0Cu8zN+8/qv4O1dUHzcfP1fNsmH2C64Aj5yFVc?=
 =?us-ascii?Q?oNnF1whyzPdjN+5ybx0AOApEJlsMEIoCRlkp3LdtJBXbFJbjgwQy87f4zKxz?=
 =?us-ascii?Q?wshm+7oXuX4Uhy3qp7bvtk1oiG68bWttU13XqHdzFbiGooI90DOXrIGXECey?=
 =?us-ascii?Q?//IrqL7x7WPu3B0esfKJPzDdKCWXAO8/I6Hf7Vq1vgZXQSYPvg2zeC46H63E?=
 =?us-ascii?Q?rpf+dmS6HMMRdMp3jzvlbvISlaKWJWq4FtCSBJLksdUPHxQSy7UyoMsFhNXl?=
 =?us-ascii?Q?7mBXjSXWPFQU+6/nG86PCxkyWmlzx54KHsYTOGfppfkHcNn1CtTDaKF5RqR9?=
 =?us-ascii?Q?4gLtSYfjhXHsDHOtuSTfe9pgqSYsiQjUeTFAYMJN1tfC/xTF1uxGDRhZIem4?=
 =?us-ascii?Q?Lj9s6SsYQwBaLl/e27xZj1yuvo0Bg+5ncWrqA8Qc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a892ea59-71a5-4ab8-9eca-08ddef7988b6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 08:19:02.2017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s5p/l4G0tic0cJ1nvtIrUCGs6qI0A9wMmEHBbJH87NLFq6X14A8+YHblWy0/jUHamjll77gIDB7es1hzDIcxfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6944
X-OriginatorOrg: intel.com

On Mon, Aug 25, 2025 at 10:55:20AM +0800, Chao Gao wrote:
>On Sun, Aug 24, 2025 at 06:52:55PM -0700, Xin Li wrote:
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 6b01c6e9330e..799ac76679c9 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -4566,6 +4569,21 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>   }
>>>   EXPORT_SYMBOL_GPL(kvm_get_msr_common);
>>> +/*
>>> + *  Returns true if the MSR in question is managed via XSTATE, i.e. is context
>>> + *  switched with the rest of guest FPU state.
>>> + */
>>> +static bool is_xstate_managed_msr(u32 index)
>>> +{
>>> +	switch (index) {
>>> +	case MSR_IA32_U_CET:
>>
>>
>>Why MSR_IA32_S_CET is not included here?
>
>Emm. I didn't think about this.
>
>MSR_IA32_S_CET is read from or written to a dedicated VMCS/B field, so KVM
>doesn't need to load the guest FPU to access MSR_IA32_S_CET. This pairs with
>the kvm_{get,set}_xstate_msr() in kvm_{get,set}_msr_common().
>
>That said, userspace writes can indeed cause an inconsistency between the guest
>FPU and VMCS fields regarding MSR_IA32_S_CET. If migration occurs right after a
>userspace write (without a VM-entry, which would bring them in sync) and
>userspace just restores MSR_IA32_S_CET from the guest FPU, the write before
>migration could be lost.
>
>If that migration issue is a practical problem, I think MSR_IA32_S_CET should
>be included here, and we need to perform a kvm_set_xstate_msr() after writing
>to the VMCS/B.

I prefer to make guest FPU and VMCS always consistent regarding MSR_IA32_S_CET.
The cost is to load guest FPU before userspace accesses the MSR and save guest
FPU after that. It isn't a problem as MSR_IA32_S_CET accesses from userspace
shouldn't be on any hot-path. So, I will add:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 989008f5307e..92daf63c9487 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2435,6 +2435,7 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
		break;
	case MSR_IA32_S_CET:
		vmcs_writel(GUEST_S_CET, data);
+		kvm_set_xstate_msr(vcpu, msr_info);
		break;
	case MSR_KVM_INTERNAL_GUEST_SSP:
		vmcs_writel(GUEST_SSP, data);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a3770e3d5154..6f64a3355274 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4647,6 +4647,7 @@ EXPORT_SYMBOL_GPL(kvm_get_msr_common);
 static bool is_xstate_managed_msr(u32 index)
 {
	switch (index) {
+	case MSR_IA32_S_CET:
	case MSR_IA32_U_CET:
	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
		return true;

