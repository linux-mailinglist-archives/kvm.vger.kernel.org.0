Return-Path: <kvm+bounces-66681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BBBFCDD623
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 07:38:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8396B301E190
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 06:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE792DAFB4;
	Thu, 25 Dec 2025 06:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qhf+EIAH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED3018AFD;
	Thu, 25 Dec 2025 06:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766644708; cv=fail; b=bBj/kJQF1jR9U1XejAlb3oDTqVVkRhTl5k44kwC+6/nEUXbZByrV2Le+2MU6KIrUvnW40c1ciQ6xfDw50OgvPGTigCAJbm5Rmiv3BpdSp2IltKMqHIWQwdyeuTgvBLYmwIxKLwlijeSCYBmHECI3LXlLBeOh3kreReZWq/bizDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766644708; c=relaxed/simple;
	bh=hyO5gjZFnOaNpeLlFtH/MwnVUyCdnz2ddli4peXyYlE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cXz2di7ip6K1xjNICM2pAVWwIVeCRS1cZQJWqtMUww/41x50Px3RCqCJdLUplO25dsD0EZKivkIIOmQLidRwAV2z6wvgHniguGrtmNbqyTVJ/+JZUuFaPb+KajpMzC57RuSU4ywCEb36ueIwejCHnup28WTcxD3MKhpRQDwHri4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qhf+EIAH; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766644707; x=1798180707;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hyO5gjZFnOaNpeLlFtH/MwnVUyCdnz2ddli4peXyYlE=;
  b=Qhf+EIAH5u6FoGm/n4lNpCN9lj36+L2D+svs4mYdbVOzBZAYVBrv+Eaf
   knmQ0rgS7zjXt+Yg+KqeVjwW2MkXjdnpGqvNU/SCY6toXHxjCKHEYqSBK
   fsrdp1k5Sp1qbtltO+esHjrNNI/qp0R8hG3gVrLAQMlOINiVlZm8jgnoY
   CvMTdVpco0FxFxzzBBBqDoHmI479+w2sdQlIjP5ZQmU0R8DfG0w+O6pBA
   bqamnIrUrAhiQXmN5xnSysXO10bNgr57lMLXREg7WpiQ+S9Ulxjuk9nj9
   p7ann9PJ5F2LM2TBMlSlshw7gVG4UoXrlWOX5DPqjiTLMdeNnx0xawxu5
   g==;
X-CSE-ConnectionGUID: vzwLFu5cQXikKnXr4xC8yQ==
X-CSE-MsgGUID: grVofxPqQYadBhKRMI873w==
X-IronPort-AV: E=McAfee;i="6800,10657,11652"; a="93926553"
X-IronPort-AV: E=Sophos;i="6.21,175,1763452800"; 
   d="scan'208";a="93926553"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2025 22:38:26 -0800
X-CSE-ConnectionGUID: BMnqSC4uSQ6NbHSCQeutXw==
X-CSE-MsgGUID: HzrkMXxsQBWYpzuJMBb1iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,175,1763452800"; 
   d="scan'208";a="230826207"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2025 22:38:26 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 24 Dec 2025 22:38:25 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 24 Dec 2025 22:38:25 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.52) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 24 Dec 2025 22:38:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QTeLqiG5PE5QYi8+REZQhArRKNrXd1xCBuUYw6aRhKI4TfrgiRN7KBUgDYjWJ1Fi3sERmghgz0N1l1e1otiFbu5MGLqt46xlT9c8ZbDKevTuPIohB5akehe+EEvyXKUUVZGaNOpMpZbghV/u8vSlaQQn2nUX96bWlsKnd57YMdYCpLKjBrjSCokuYFpnEuXrGK6wZls99mXOo4QSLk8pBbvs67qAxFrpQeuBLxG2Z3NsaHgZkIBRfVz03TfIKsNJgnzCySenhdRuWW9Z733fzqh2AYAzTIXu5RhbANKyoo0ICjWk1IPRSva0Fa0cREQU2WT5K3tcLEBuNJdkgKiS1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFUXFC1BZo+CojjUi1+qJgaiY1gsozTpvcqk/NaVPXE=;
 b=p3ueuq6J4itKzPhWl1ndkRjSmjsfnCkNaQXFC/iHe2X71uIBi4uNqyWHI95lUlSD37tqU2rNvhq6n15Hs+2nzI+5MOmZfPeYGtEj9mpMIm9gRBIP0e/i1007ndcRiky1HB0LCj3fwIHndCBXQDjU3NxVTkTttqevlXM5usdTtTYPYiru5r8epjTCLjShDT8jhxo19X2Z1lAgOvRsIxvp5dJ3XBPKoHrUc8rbvmPUzCR5w03EJdBT59l6RdmIU+JrMp4w4J2fa0qNSndN/QOsBXR9FERsnTbnVq8htWQ/Do/rcdeYHi1nzLEXnrfT2C8v4XbFTJWQHLMAje5O/sZeLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB7585.namprd11.prod.outlook.com (2603:10b6:510:28f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Thu, 25 Dec
 2025 06:38:23 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9456.008; Thu, 25 Dec 2025
 06:38:17 +0000
Date: Thu, 25 Dec 2025 14:38:07 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Dongli Zhang <dongli.zhang@oracle.com>
Subject: Re: [PATCH v3 05/10] KVM: nVMX: Switch to vmcs01 to update TPR
 threshold on-demand if L2 is active
Message-ID: <aUzbz5u/PHxU09/K@intel.com>
References: <20251205231913.441872-1-seanjc@google.com>
 <20251205231913.441872-6-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251205231913.441872-6-seanjc@google.com>
X-ClientProxiedBy: KL1PR01CA0139.apcprd01.prod.exchangelabs.com
 (2603:1096:820:4::31) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB7585:EE_
X-MS-Office365-Filtering-Correlation-Id: 410b9236-03c9-406b-8979-08de43802fab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tMGPv118Z5dNJs9KoyPsFvEjxwwKb0nuw0bpk8vxvQh3WuYYylwBk7HUItoM?=
 =?us-ascii?Q?oH4noy5b6xkjtbc15OFIq01TNU3jsfkLAA+h9EC05eHK/+VBpKdw3LO01RXo?=
 =?us-ascii?Q?rk5J2j7zBi8/XkCCaoP5iD4W+9srHE8+tACeVVcR08GTf/F0CdMwgCEXy1WM?=
 =?us-ascii?Q?dpMMzUkeTzqy0CMr1wfPTSk9qmUXOgJNBzrnUFeWWZZ7p8HMl/fjtWZU2Zx7?=
 =?us-ascii?Q?V+WCLnSfLmsq9EVirdtyAeX3LdK7yt8U2LnKpX5fxCwYTCLjAZPaOxgsiziG?=
 =?us-ascii?Q?TxEEpKFYsgoRSC297/LpvQ1AgiKBcmuS0yg2EK70S0xKXIF18f2rpKvjAP2K?=
 =?us-ascii?Q?gUNmWjyIgQVpKUdqkD4cgESMuhIGkeeKO0ffoDXLeXhNM3r83e2dfs7rE4rp?=
 =?us-ascii?Q?1KBDTlG0HvAZkgViVTBOzWljTdktzhY6mbsc4WaaHAaURGQAuCoCUYZZDmN5?=
 =?us-ascii?Q?MtHSKGDJzEFCs4xud/N1SbqGjXC1PYlj+3QygP8BuHr6/SrCdD0kZoKCJBhJ?=
 =?us-ascii?Q?Z6/Sw1OjcNX/KZvNYMfvprIayC7RA7DY+6mNap8lFNqTj+l0YK0R8k/OyQf5?=
 =?us-ascii?Q?6g4KRm8Yrf/u4NNTJTNGreIVmrxhW7I5q9T6ToeNPdbSyNRDHD2E02rX3ONL?=
 =?us-ascii?Q?TotLfK99yNnE3+MTQF20HvUtvrZB7pHkd9zOvwT7NrxZf7oxvEDUWOkEo2b7?=
 =?us-ascii?Q?M7gf6h5j2HAaGDykHUMIhWlbneLKjG9as+83yJriFSpmerpW8fSD/OFV8ERM?=
 =?us-ascii?Q?XLNNb6cfxZ6gCIj1JXCFknFAAjVYK7YwCaPbNJbG2xxsAnK3rp6NEyeSQg/A?=
 =?us-ascii?Q?iJq4NWDHCHY+rAoO5k/ssjgUX7FQ4ruQgnVmpas0bgZWfFuARCoYNzh2S4EO?=
 =?us-ascii?Q?d8YBx3s8hW+6vim0hSziHZ0+bJBzJx2bXAf/RKSNBiOoYFQ7KiFrIsQ7bysX?=
 =?us-ascii?Q?/n+ZdHWhqY3oY9ySHMkQX/LpKCepMfKHNKjwu1IRU4ggqz1BGbxsbyjkTAMo?=
 =?us-ascii?Q?pgZX2xXQnDl4hEXxVSCvFd/+H3szgKCqgA4ddURR6aeUgM2qKAtiuLNA72AF?=
 =?us-ascii?Q?1O9r+xAVU7S5gwOeZ2iOzIR5FH1UWwoxvoMbsbEMl1cuXBUSjVTVBWB9PqVy?=
 =?us-ascii?Q?vIZWGyxgyslsAgRFUmAp1VYDqMXkBh3c7hLnukg0MmD6yRgZiJ7T0SFIg7im?=
 =?us-ascii?Q?5Gq/KFy4DmK1y/IRbvB/lprIxu3GUpaFA2POJOXxMVTmYSRGQL5SrvznmVal?=
 =?us-ascii?Q?RNQgLNVWbHMQSjhYRzXdDZSV9QNn4LRtkdQVjGM0ote4Mqh63eOrHBgNqENv?=
 =?us-ascii?Q?fLGxngsgx0X/RX5lD4PPqWHzcYW8vYVYj+e/S+4lHgcvAGpe8gP4MnuUVbbr?=
 =?us-ascii?Q?lcK3OlXYFf6m2oU2EkKw1wxtytKY9lRi2pvsNiu0Le84VAC9mWyyIY+k4IjP?=
 =?us-ascii?Q?EGDCYuunYSM11DT2KJjQeNNusTkHCSZx?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L/EKgnteuG1k27S6GZIJuXP/PiTKhK3iA1fOusIfKLL0wP6QDNfJlj/x8H00?=
 =?us-ascii?Q?T3OeEBixsBqpneHmh3ry2qyrVXsCqL5upfG49mG4nYl5wONz+LSG+Ryj9+Cp?=
 =?us-ascii?Q?wZcgHINdWA9blM/priT7S/o5UrD4Z2kcjhLQBOgJVBscx2/RsRLlhPvn3blG?=
 =?us-ascii?Q?wu5FyiWzZE7l+1537z4Zcj/zoN+eaa3UpmmR8YIp6A7iMAjNenT5lWcTwhDt?=
 =?us-ascii?Q?z8Ft/2UcnfK8RoQO3mDv3sBv4tOjtGCrwF2Ixn9eOHq2nn94HWVtHss3NToT?=
 =?us-ascii?Q?yI5+IGfLPSQ+Ru1PJOF8gFZV2golI618GJao8K0DorkD24c1ehn/qy8hxywl?=
 =?us-ascii?Q?SBtyI2Jm3VN0QUkE7xvKIGZWW2edjm3I9N+63sNDt62H5VOzeRumnTk3AFt1?=
 =?us-ascii?Q?amfjuvpLIqFZqdAsLUT7chYdWPYvtFEAOZHmjBoGC6e6dvDqiDGN/tlOE1JX?=
 =?us-ascii?Q?JErG6ag139VksByV3poH6rCZwJdBdAXsTysC+h+t9iBN7mMU1Uy/BxnO2Hjx?=
 =?us-ascii?Q?m9cQZaJJeV0h3YqvbigXuv/Cpy0gmZmGdC4gI+HWFR4rJf+EOsSdGoAEBQf1?=
 =?us-ascii?Q?oU8Lmwxy9YSmnD6U7papKecLWdX4IQjUj04jAROgK4Z39Ps/ccsg21NfHsXN?=
 =?us-ascii?Q?sWv66qO69Dbvd20WgnrflG1PZvEraKla7Kbt7q+i4wMPvlvGZydyQnA5B0IO?=
 =?us-ascii?Q?3mhZNRmJcpWdDjaTiS5u5YN3vu5NFGjxWPZS0VP7OPPlSJr62LI7h24mdGp2?=
 =?us-ascii?Q?i7Dgd8BKJ9nc6qP2X57nJ7k0jEwi9wYChToaVO3SjS5OeGa/hb3Z3YotNFhT?=
 =?us-ascii?Q?GudkNck4uO9TJmN+qmjDuhbep+DRe703krPf+GU2DFTC0OLwmcD1iFNlywm8?=
 =?us-ascii?Q?1/I9f+2ACHpDoIXqK67/6BW1gWuRHTReuPsC1v3NzBOHGRPoFT2ekA5lrJlJ?=
 =?us-ascii?Q?Kxvc3hh6e8Sdrd5FEkNpnazO60xymJma+JQejbDHgACwZEKTXuMP+bx67I7r?=
 =?us-ascii?Q?CAxbamRoS2+DGkU+QEXtuNbm3+jgZPAVJdwpOPstqyjVMcZAxZ0Abi1Fpe1n?=
 =?us-ascii?Q?7AYmF5Y0BHhX+0ebSiBHsKrCasWaOZH+F9PEKjfA3VLbJb4P7X6g/fCTJa0S?=
 =?us-ascii?Q?4+gcvUzN5O3zK8+CpDsXSOuvhMBdBMYTUZNQ2TG+ElzxXHm9Mfzw/ux3LnzO?=
 =?us-ascii?Q?eSO7HuSxn2XxG3lNuIui5XLf6sn5SZZooBh0P2tvHBD3rZp6Uv7HMDF9E5NC?=
 =?us-ascii?Q?uc5mWGbq/4tdT0beKnRFGdOU6ExFZAVtwjlZJ8K09SWIWRLQFgWF3IpCZCuk?=
 =?us-ascii?Q?6r4g0fD6LpXxxyZGoe7qtA+bxHigmTPl+E9w4d2j8OMHDruNeLHtzaSHhMFe?=
 =?us-ascii?Q?6CRIY3EypDD6pbA+uAySaw7J79o54Xq4YUFsgPK/MAf6oJMgCLS7kWK76naS?=
 =?us-ascii?Q?sPe4vueaWO3Dr3ZI4U9dLJxwwEyPS5/6mYNu9KF+UUZlX/5VCZYiEG1wYp6J?=
 =?us-ascii?Q?5iN19ARMvzL1wc+5uz5BlSYL9q+uSe7CZ+R/ymolCGOaUVrGnqGHe0zYNv/y?=
 =?us-ascii?Q?TTjE6y5hkWf3QZM7xihvhppqeEzwOlKL4ENhzrcNujaWx/u4RMATZMyMa0xF?=
 =?us-ascii?Q?nZcqlaWp4aogZJbHI30bNW3SvA/6iHwLaLX8vhJvy6l2NeCI2Izv/gGTN5oS?=
 =?us-ascii?Q?9HNBpkevSoI6zkLjuEHUh9axBgQjWjxMVufT0xkCjapvjMSqv8U069XXuVLK?=
 =?us-ascii?Q?qBWZPc66cg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 410b9236-03c9-406b-8979-08de43802fab
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2025 06:38:16.9215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kkmvkpd3Dq2ZzsFo9fLfSfNn/XxjgjSmznKLGqkrtaCVpoXm9uErXJA9+EqmUGsXq3o3GUucVHpc1JrjqU+SbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7585
X-OriginatorOrg: intel.com

On Fri, Dec 05, 2025 at 03:19:08PM -0800, Sean Christopherson wrote:
>If KVM updates L1's TPR Threshold while L2 is active, temporarily load
>vmcs01 and immediately update TPR_THRESHOLD instead of deferring the
>update until the next nested VM-Exit.  Deferring the TPR Threshold update
>is relatively straightforward, but for several APICv related updates,
>deferring updates creates ordering and state consistency problems, e.g.
>KVM at-large thinks APICv is enabled, but vmcs01 is still running with
>stale (and effectively unknown) state.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

