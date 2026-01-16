Return-Path: <kvm+bounces-68294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC7A7D2E1F8
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 09:38:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B453C300646E
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 08:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D5EC306B02;
	Fri, 16 Jan 2026 08:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hzkmu9/A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A32307AF2;
	Fri, 16 Jan 2026 08:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768552682; cv=fail; b=kjdyLWgo/JfIT767YdooS0w1iCIzdTFWaCVmCOrUZ9vncOABWt34g77RXdQMtheN30Ho+AR2nBpdY5o4lVvVGSJewRUhh+XD1CzpQ/MB3/8dq2uXuVwTzI4Mb5DF+wLphmuQLOszA5GJ9U/JpohY3QaEy+Ivf5lbtI9xen4i7NU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768552682; c=relaxed/simple;
	bh=FI9XUS6hOqCXosZJLB37psxrVONZrDXLUUbsEvDGJnY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ktUYIcXPRBO90Y5aCWKeMmEycteWkCCxP/h8PJnSmNJ5cwkxaraMdxESCmRxHzNBZEzRZrNE0R6dJ7npdw9+xw6UvrGOn97LZ8WFpWXgYEtlS27ishzdNmlLKZTl070PmO5bkNxoUCZ0IelE4CF6r8N0gQhPwk8t0yePM9vTX3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hzkmu9/A; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768552679; x=1800088679;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=FI9XUS6hOqCXosZJLB37psxrVONZrDXLUUbsEvDGJnY=;
  b=hzkmu9/AgN7FV26WAtgZ3gwds+VVR7zw+HUH/78ysU/JyL3k9IkRUHWy
   5pr+/pqXjA9nbF8DKtmpz2IR4eyvt9MuhjXpLEQzmP4j8+eh1UXQreQTs
   hVE5Vd/BfnCncLA2ynOrXxReWZ/B7C4Z0SODzWwXUQpWU4bpr79verwXa
   DkdDqbB6jagJCHFMdezzxRD5HT3DyHfweq0ylt1jWJiI7S8wCoL4kSqiO
   rz6hfMu7TLnKh2307D9cMVU8YhRlmRg4jWyJZ9XKoqVdlgjRQNHZWShRA
   4T0O8tMM6LCJUc116jxQy9o9tjOn2nORaJSSQ05UdAXiHRA11UxeL8mjs
   A==;
X-CSE-ConnectionGUID: 6VxBzUhwTlayzbOToQIW2g==
X-CSE-MsgGUID: MhPJR23DT5KwBwkp5E8zwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69957380"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="69957380"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 00:37:58 -0800
X-CSE-ConnectionGUID: l1l0gLX3SmObs6a3/+qvGA==
X-CSE-MsgGUID: oQHMuT1qQ1eBpVFC5BsCrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="204333272"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 00:37:58 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 00:37:57 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 00:37:57 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.33) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 00:37:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WX0YiPz4sMCYb/aMoCD612RkIHxy07lCgO07cKHZBQkNl6+5ulJqRemF8sUZOlU3UcmeVT54FTksQg8+y/VUaSKG5lCO91bbIc/OyfTlLwsaZELwNwCtScr6Rtr5dR0L2V8ona2QtsCow2qi1LxakghGwjZmbtitgt/4KxG7Hd/Y7jYyabMAqAGCWoZu55AbbWjGfZ9wOneZTpfkxgPGHZ5gSZwUS+TND7R4raljVK9LeRyoAorkmit8zrE6qW9or15nBK1QNKm2nbzAoiGmOrq2qdJ7GCgG3Dj9WGApCDi7bN++MISUH3vKXeXYai9uY7HZbxDJrEXC6TsjMvXCSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7TcYbBuSpxbYEak1OT7D6BkAB37OSPoApei5qm2Q+/Q=;
 b=QEckqM3CpkxZGBp7VjTVZCeHONyckBv4q1s6t6fzsuCj0UaTCxxCwiRuarNjxvUwejjaknw/Fgon3fi4V6+M9rAhcvJtSAK2B7Sv0nY5JHpc3O2H09beRnC+fTAnkeG8Mrp8uOlTfk9e2S0IgiDJcM1ySIQHWkIjrQxkYOJoyBonHpnzv+GU+GPDv9xctoM+oqTOEfVQRrYfgoI8s+32WJvbEAvylGpZd0+Yng9y4crSJMj/GRRqJU51JYRJKsbDhyQu1j7FsouuBdoLUUG0i5XrmCCve/m+LE2mfPbiZXrq4sSNRbCFLlQyAcphtPx0+1X/UAZ7yMehLB4O4LyOCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB6494.namprd11.prod.outlook.com (2603:10b6:8:c2::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.5; Fri, 16 Jan 2026 08:37:54 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 08:37:54 +0000
Date: Fri, 16 Jan 2026 16:35:11 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Du, Fan"
	<fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Gao, Chao"
	<chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "david@kernel.org"
	<david@kernel.org>, "kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Miao, Jun" <jun.miao@intel.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 02/24] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Message-ID: <aWn4P2zx1u+27ZPp@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106101849.24889-1-yan.y.zhao@intel.com>
 <ec1085b898566cc45311342ff7020904e5d19b2f.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ec1085b898566cc45311342ff7020904e5d19b2f.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0058.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB6494:EE_
X-MS-Office365-Filtering-Correlation-Id: edafad83-d466-4048-fc32-08de54da8ac6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?lUgGEIy1WXzJJizk1eQc/QOM+1BBydwB4WIZHk+5SUZD84rQd80/yuxGd4vn?=
 =?us-ascii?Q?CtepgqqXotm5aB52Pun2EreNu3jFGovevNieVEypswZT8Nlcj+/UA/bUh1Xk?=
 =?us-ascii?Q?NsvA1UbtjPA8I+NAJGkdkCKDr29GWAFl618SXXnxwpPkj+Jiwk4/qSh7AEzj?=
 =?us-ascii?Q?Z9RjmeSSSy4I0aark7MbxfNa8y44Se7hQtUfl+VHTgJ5VB9veR2waQlu7l6q?=
 =?us-ascii?Q?rs4XhHGIvRnYLtMT9IPSTCQ9CpjZhd+zhIzkD64SWNFOVHqWl8SsxbY5tt+s?=
 =?us-ascii?Q?Jw45CKLXomp8OtlExZ7oYONSeG4LY105Bua9iHySD23foNsFbjmIJLCu0f41?=
 =?us-ascii?Q?XlQHx/JbrEZVrvNhyGahqom8J0Ezq+I8FrH6AC8aRkgDEXrFtdpAB7xof/yz?=
 =?us-ascii?Q?WYJPrHSerMsavene0gWPgUWEx23GjSYUXAVGyQwLmNaw5+YL3+VnQzqhMoHb?=
 =?us-ascii?Q?pB6E2rlhWMCMd9DUgM701nFZUborNqjjR6AL9/yBKYzKYxU5tHMDjRZ93pQg?=
 =?us-ascii?Q?M/QLUGhCEo+wzEEiqmY9viU/gpacQMpfRVB6gazUX1/oG0c/4GJ9/q1gSzy9?=
 =?us-ascii?Q?2lAjPsgW4UrMCyUZezk+Sq7h9VHkTqWjkRv4UKQQ6uFQM/tdflYqGUHxKYW2?=
 =?us-ascii?Q?Uovbpsp2KWRJvQcf0+H67yxr7eNv1injGmN+KJwcP3dfxv6OCflleAHC/Pcn?=
 =?us-ascii?Q?30jXl7TkW6ujHalZegGOm0GSYVwK4nqHdA+7GFW3NaV+ewFHwYA6HIXQs+l3?=
 =?us-ascii?Q?8Vp9Cy83NY3nrQWCthURH++GVnZ7GLbpowP6dwAnK7fHAXeqX3J2rBeRiz4O?=
 =?us-ascii?Q?690YSvGd4eMAGEHg1Ssg5lNYuE9YqFQJ4oqMJ3wn87TBb0Di6D3XYlcAK9hE?=
 =?us-ascii?Q?lT91I6eUM5gk1J5SurZilD7O5NleZe9eki5m04ZM3uJzRQlERSM+AfaSUINt?=
 =?us-ascii?Q?vjjQRQwtXDm6/gg6uUE12GLefjqptpbPukq7yHpp6A6UmiuqFGmV+nsbd8tW?=
 =?us-ascii?Q?HJZZ7xVRvsLAls3sll+Orhod+qzJunde5HmS1kpxzOjjxXTANBDp9y0OCnCM?=
 =?us-ascii?Q?UYGQmbLvWbuBzI6j2jb5+Npgqr1iWVifaNMTxJQa7lY4lx8IxVfn+fUyHh+p?=
 =?us-ascii?Q?g2WdGyFA568pGDWhdMKWEoGKp4B5vNHLyBa0QRnXYt9/ihjstE5lF38wZoNl?=
 =?us-ascii?Q?JLJAwGwEqA2nWxq7hv/HjcVa8JDAqv0lNj5wUMfEWAaSAe1OmOjVSFqzaVZ3?=
 =?us-ascii?Q?EtDfR71c87mOQw7Mul6nq+iWcjVyob8wjI7DM5ldJDQfRkpU1Id7rskojUq0?=
 =?us-ascii?Q?rkUzyY5cvojB9sNjRzWqxmR/wTaUSdyxCbm8Yo5kf/7cbasau+3ZEg6DfEc7?=
 =?us-ascii?Q?5f7nPtsht8sXSV0PAhcuSjfjzJyZUrKStKg5MfQxKKvFmn8UoxGv9+BayhPA?=
 =?us-ascii?Q?NEl0ASW0YILL7TEv6peQF2ODEA/ikcbWy0q2A2WdyXXQFOZFtT4p58TVi8LC?=
 =?us-ascii?Q?N3B6zJ/6Aha+vWAX7YxgBZiarRhl+B8wlUzRnM816MgO/2c+hoy5C7XnuWQB?=
 =?us-ascii?Q?AlMqhGBR+0YoLVqB4SU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Gkmrun8eMXoXd8wpDPZH3ioUarveeJsA5u2GUrhtEiGkTZXTDfsGCadFYGy?=
 =?us-ascii?Q?MCtkWYYoUZvDt7mU294HMYc73oQKB0bO++pK5CWMytqWVT6Fqj8RQIe+SO/o?=
 =?us-ascii?Q?QZPqfXYOIN25X5OmGq3CJVmlY3/PCk++afyb/8sfySiFsWm161eTkiFWTj2L?=
 =?us-ascii?Q?L3cDR95jEID7tzR5BwXD8pyOQyZdVcVoMuUxRSv0X9RiXLBHMoyS9r0I2B51?=
 =?us-ascii?Q?9wqp9hPUfTXQ7XGpTJD0eoKzEc/WdhHqnwMR3Qrx3usNet7uWx1UbLtzxx7D?=
 =?us-ascii?Q?3DoJmZL3woLWYFI8Y1klRI0C40n8A3nvRXTea5aH2uGFBvImypAJ8zwboGgM?=
 =?us-ascii?Q?7tOeYD+9uKQ/eHwH16FJy0QxUvH2S2Mc/31RpsbhjJh/pn0z5L4F1nObmssU?=
 =?us-ascii?Q?H1r8dP0HX9GHXw8tyUM9zHvOMl58FVg3eA/0KnEaW48vNJrZ5mO6o5rjyq2j?=
 =?us-ascii?Q?/drioxYZJWulRrLBY1U0AG/hiF9JT0QPI7vgslJ4Fe/eSdFf++a2KXrM+8X+?=
 =?us-ascii?Q?s+ofGQmyM1RPBSoYHhvJd9YG+nBQdILkUj5vhyg1BXnfUmJH1d++E+BT1YHN?=
 =?us-ascii?Q?mvhx4vVblN+ClEAkx2g4unkQSqz29ndQYe596lH8BPX/DnXqf0K/W9bpSNgN?=
 =?us-ascii?Q?LHNiEcnygtOZgtIeW6a6HflAGS4aeNfwPQ0x8Z49HhC21+OQxYRWeSOVQQou?=
 =?us-ascii?Q?4t+DJYMZyVYbvkEbxLjPso89UQKFA5vfkFD7Prgp1zjf06KohNQvFTk6IliW?=
 =?us-ascii?Q?u87krdi1hBrcKJU9+JTQYfJJDSQGjjt7W+k1dbeSVNBb4gdn6IyNOa+12kE5?=
 =?us-ascii?Q?mooB+YgJe9z3fK4mJsJcnA1btEhv8Cl4GUV9aPUWgDI0A85yK5x/MVFAOMZ6?=
 =?us-ascii?Q?oBlSnbZ4uIEyiV2AO6gzBB0xUlsQ4k92G0o3jxjni0oUKYB+C+c2S3sFDXbK?=
 =?us-ascii?Q?EgT1KIGNKIvexU465OmBFXutQs0DMkl+Pdl0xxBKZviqlWYb0PPArYxpOMgQ?=
 =?us-ascii?Q?3mceoGbL6jLF2V75MY/x7pZdaW4YxLujHLnsPIKeYWzF5z/u0lH7QM0d0J7o?=
 =?us-ascii?Q?FB5KyzxGFn6ri/B4hW7exMG7aw7+4G8AZmtlSmk1XlyIz30hppBEN0BTGdgf?=
 =?us-ascii?Q?S7YNECbtzG5XlpE2nNOK2SGQBjFTTPgjpO+hpvcrWshsomt6GnA0SdNKpIXI?=
 =?us-ascii?Q?Woji4GFq777ussTf2HjvtghXPU61LutmGNNctWn0ilcHzQV26XsmAALndo+m?=
 =?us-ascii?Q?dKk3wdiFNt+Wk6e+Jn9UnGTelPTAZoBp7EYg2+AqRS2RoYtsFJf89HQ5SwQn?=
 =?us-ascii?Q?oK6ahU6/+utZ1t2Ugx3sLXuiaJFiVSG4GEsagjoPOqayCq6QwCL90tlnyyBt?=
 =?us-ascii?Q?6yy7sRsjCCYfsXKOvP1x6x2KKW1B9bo57btlCrXzAjJ2bzkeMipmHarky1jd?=
 =?us-ascii?Q?g0JO+UvTQO8Q2PqfVVHkhxYFOIWgv+iVjB8CIRHfA3SMqDOSJXraKYZc5g2i?=
 =?us-ascii?Q?PRXcn6/dxZhkrCPTKCsOKJ/iwk74fHfINtfCFX4ysmFXzvMzbYkzRkj0AaJq?=
 =?us-ascii?Q?YHnoKvondQvD9Kt9Yip+Pf+2Yea+49gjmDJ3QoYi9KxQXDb2AvXW9KH93nrK?=
 =?us-ascii?Q?vSIGhljRtpUUzSzvIBfyJLFhRuWRDSBBM96rhDxDMbINU0YZMXBurYBupG+W?=
 =?us-ascii?Q?uQC7t04AKosgU0vxPwvZc7K37Et+dMNil5guJigu7hXXAF4wxvCsjvz1Cql/?=
 =?us-ascii?Q?f1dSP1a2YQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: edafad83-d466-4048-fc32-08de54da8ac6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 08:37:54.2876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WuryPXtuAFzvKkqPjKA+jJod7L+02VJna02GmEf26yU2WMUxaa/ZRDdeg+3pmDmsFVxDdAUrIrtbG6wWRfxlCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6494
X-OriginatorOrg: intel.com

Hi Kai,
Thanks for reviewing!

On Fri, Jan 16, 2026 at 09:00:29AM +0800, Huang, Kai wrote:
> 
> > 
> > Enable tdh_mem_page_demote() only on TDX modules that support feature
> > TDX_FEATURES0.ENHANCE_DEMOTE_INTERRUPTIBILITY, which does not return error
> > TDX_INTERRUPTED_RESTARTABLE on basic TDX (i.e., without TD partition) [2].
> > 
> > This is because error TDX_INTERRUPTED_RESTARTABLE is difficult to handle.
> > The TDX module provides no guaranteed maximum retry count to ensure forward
> > progress of the demotion. Interrupt storms could then result in a DoS if
> > host simply retries endlessly for TDX_INTERRUPTED_RESTARTABLE. Disabling
> > interrupts before invoking the SEAMCALL also doesn't work because NMIs can
> > also trigger TDX_INTERRUPTED_RESTARTABLE. Therefore, the tradeoff for basic
> > TDX is to disable the TDX_INTERRUPTED_RESTARTABLE error given the
> > reasonable execution time for demotion. [1]
> > 
> 
> [...]
> 
> > v3:
> > - Use a var name that clearly tell that the page is used as a page table
> >   page. (Binbin).
> > - Check if TDX module supports feature ENHANCE_DEMOTE_INTERRUPTIBILITY.
> >   (Kai).
> > 
> [...]
> 
> > +u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *new_sept_page,
> > +			u64 *ext_err1, u64 *ext_err2)
> > +{
> > +	struct tdx_module_args args = {
> > +		.rcx = gpa | level,
> > +		.rdx = tdx_tdr_pa(td),
> > +		.r8 = page_to_phys(new_sept_page),
> > +	};
> > +	u64 ret;
> > +
> > +	if (!tdx_supports_demote_nointerrupt(&tdx_sysinfo))
> > +		return TDX_SW_ERROR;
> > 
> 
> For the record, while I replied my suggestion [*] to this patch in v2, it
> was basically because the discussion was already in that patch -- I didn't
> mean to do this check inside tdh_mem_page_demote(), but do this check in
> KVM page fault patch and return 4K as maximum mapping level.
> 
> The precise words were:
> 
>   So if the decision is to not use 2M page when TDH_MEM_PAGE_DEMOTE can 
>   return TDX_INTERRUPTED_RESTARTABLE, maybe we can just check this 
>   enumeration in fault handler and always make mapping level as 4K?
Right. I followed it in the last patch (patch 24).

> Looking at this series, this is eventually done in your last patch.  But I
> don't quite understand what's the additional value of doing such check and
> return TDX_SW_ERROR in this SEAMCALL wrapper.
> 
> Currently in this series, it doesn't matter whether this wrapper returns
> TDX_SW_ERROR or the real TDX_INTERRUPTED_RESTARTABLE -- KVM terminates the
> TD anyway (see your patch 8) because this is unexpected as checked in your
> last patch.
> 
> IMHO we should get rid of this check in this low level wrapper.
You are right, the wrapper shouldn't hit this error after the last patch.

However, I found it's better to introduce the feature bit
TDX_FEATURES0_ENHANCE_DEMOTE_INTERRUPTIBILITY and the helper
tdx_supports_demote_nointerrupt() together with the demote SEAMCALL wrapper.
This way, people can understand how the TDX_INTERRUPTED_RESTARTABLE error is
handled for this SEAMCALL. Invoking the helper in this patch also gives the
helper a user :)

What do you think about changing it to a WARN_ON_ONCE()? i.e.,
WARN_ON_ONCE(!tdx_supports_demote_nointerrupt(&tdx_sysinfo));


> [*]:
> https://lore.kernel.org/all/fbf04b09f13bc2ce004ac97ee9c1f2c965f44fdf.camel@intel.com/#t

