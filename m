Return-Path: <kvm+bounces-51831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8586AFDD75
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 04:26:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2185A16C5C8
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 02:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E0721C1F02;
	Wed,  9 Jul 2025 02:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Owwux22c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3860235968;
	Wed,  9 Jul 2025 02:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752028004; cv=fail; b=sNQ5t6i6DMU+zPFMoWNTdLfJvXTXl61SuJa8iT2m2BGG8U6Gp2bJctYlH8Mvgaa8n5auWyG4mEgZVcHMIxIqIerjD/edcJTYZXREu3FRD5PZQLOtU4AwCM+Y8d1EDsG/qZP7v6MenbKw0texkxINmn8aPzVuM4Omjc3Fy93Jz8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752028004; c=relaxed/simple;
	bh=zDIivIg6PEzMsnFmX1VC/TMieJ7ldOxWb3IJxMA4xhw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=C2ItnvmM5DyGSsbDNUta3K9NOVCMsChGai5/skPuK7MpUdrphpk7AG2cp6njoQY60GFvtAycE036tTxnXNdCFlHrOG/HPihcAj6u5qUV4+L4/wvoNy6CsSD0t5G2kUbE4/ZohCk8b/I5dfWze4DKcG49p+NsupUrqx2hSxqHv3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Owwux22c; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752028002; x=1783564002;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=zDIivIg6PEzMsnFmX1VC/TMieJ7ldOxWb3IJxMA4xhw=;
  b=Owwux22cmD1+/v2QAnFgalbRR12iqRrozeyuLugThujJE+JUYpyRGGGF
   f6hWu/2PXXo+7L1CJLAXmhMYjt8ZBGPGTzV03MKZiwhXDmPBPgT7NbcHq
   GpGWb39nd6dDpA+wKmFYUydag8ifEcb0nySLP11jF9B1dg4EZKkkg/gmj
   CbxZyHW/uVUREDcoFThv8ZdtrBXOu3ss5waJB1/oKHf8NaWld8VCkTI5S
   EcSSUKiyEFRplItL3iG6jlj+AIV9f8NQJ8PoYByNZNWfUGiLheEj/+xzS
   cDBA0oU1cVFJ+ODp+raca+JmkIkrmeT0T0nEbkW5v4elXXKDA5NyAlGse
   g==;
X-CSE-ConnectionGUID: ZUS4iBnkTGOeam0cRcRx0A==
X-CSE-MsgGUID: TUc3FwpOTYSq1NObq0nUjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="53998724"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="53998724"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 19:26:42 -0700
X-CSE-ConnectionGUID: Jl4MyUX6TmCv5rbn07713w==
X-CSE-MsgGUID: doQtjxd6SlOjGz6TcIJQ3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="179332604"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 19:26:41 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 19:26:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 19:26:40 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.64) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 19:26:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xnCYestmWZIxKLiiY+RRRe+2XM7cBbo9e0b1JAJcRLrcF4AhpVhX403ePhkG6Uxk8PsNSrKCK2LvwlnpZuw6GsIoYo1yuDo+DSG2wG0Uu60Bg7w7Q53FJmc96Qpxn/K+T2oAke7+hfkm4H5YRzLATMwBPI1bWHeHWoQC5lZUYBMW+iSCkk8rDuqqmffr79cWDxV2VtyHdqe1lzfWdjdrFOexuHJjQQnAgtiKiJesq7BYosRYnP/1CzAeah8tnkG5BM5jHmGhZAhc9SduJA+POGjXCEDm2akvPIdMF+r97KJUEZJk1nXJoLfK5Rx1a7jKAjqdDyP3Z62SHtqd92WyZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dow2RpOOJTzZ1XbiaUEcH3eAt4wo9ONbsGSM28Bf3ys=;
 b=Cfg9s8eWkSOd00smHsdPTTV6+b22rbhqziQ0medKD7E4FPsFBAFndnqnyUuwMAOYRS+/gnJpJ6pfKgehUG62/JJaRirOJ/3OdtOS72RG0Def8pZ0+7M8KXVE2TaeCxErA2C2QXGjFch7h+RHdvN5hZOUSmVGdKB+CkbG5UTNr0aCeUpe6xW8nAzjqLqQkZMIfcuHL4caOUcN/UGnYLFAM9315XxfTlGG0KqbH+oqFxwFbVLUO8itsL5ZbjNkAWRT8MN00uXnqDfAFjVfmapd1ocXg7w/99s+0VUBf1mBfuWuzllBZKkjVDTGbD/NjXRpCXARmiCnIm46nt81RqTe+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4598.namprd11.prod.outlook.com (2603:10b6:208:26f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.20; Wed, 9 Jul 2025 02:26:08 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 02:26:08 +0000
Date: Wed, 9 Jul 2025 10:23:25 +0800
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
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Message-ID: <aG3SnUUwFnIhiBp0@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030428.32687-1-yan.y.zhao@intel.com>
 <aGzbWhEPhL/NjyQW@yzhao56-desk.sh.intel.com>
 <9259fbcd6db7853d8bf3e1e0b70efdbb8ce258f8.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9259fbcd6db7853d8bf3e1e0b70efdbb8ce258f8.camel@intel.com>
X-ClientProxiedBy: SGBP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::19)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4598:EE_
X-MS-Office365-Filtering-Correlation-Id: bb0295ec-b45a-4e33-922f-08ddbe8ff653
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nKtaNOb0NLSTlXa8LZFEG4dqvptuqTYK1TfDCCITV5J4P4ATBHZUMFAEVC4l?=
 =?us-ascii?Q?fnWoVxmU80Ym03URu4UMQdA4uAIT7ygp4OAe1NEIfmmCM42CKrCtahODT3lx?=
 =?us-ascii?Q?eQKXqmHRmHVhTsI4jKxVz/+bFIes/vEGNllspzktfsD609VSRSTS4pi/RGEQ?=
 =?us-ascii?Q?VRIzkPVu8f6c9uoyLQf4PblN7oy8vRpuk5ZNJOiBevVMDz22UNKgHIk6m0EP?=
 =?us-ascii?Q?7YsEREDDg09D9DilysaMN3XAFue67Zjiz/fsSx09DQ2zW96ubhFCF647yzDB?=
 =?us-ascii?Q?ZaGUCaGaK3lYwMTgboQ7HBWdfznHJWcaARXpKhpCnafPmoTtUStKp0MHrax/?=
 =?us-ascii?Q?sYIXNFW01qbW9vkUujoBzam9JrzG7FB0+tyuDji8xIFy7I+YkWmaafo8IgBP?=
 =?us-ascii?Q?sMQWRambHRIBzafiLTP/7v2L0aYvqZZubpmRPbDsee6UCRjAOHDjKaD8PCM3?=
 =?us-ascii?Q?LhG+ggF3f6zkXHBWi0soPzux+VH/hrSJQQ9NZyJHS1RNC+vBUfLDUzM6Ps4I?=
 =?us-ascii?Q?zc5z5Dx/HsjjCYdYOeZnpp76QxVW6Y1n+h2DdNkBJEkhank0mqHHqQRK/kBJ?=
 =?us-ascii?Q?p785RZT/Prkl0WDGqg6uBpRyd9mj+SwEldQkm2dmix7qEKVAUOaw95JJM7P2?=
 =?us-ascii?Q?OBCJdVZavo9LBxBWwto3UP74Yyx4/ubmzJiVvnOs6qTwafM6jP5YJenhE1Kv?=
 =?us-ascii?Q?6OEt5X3OR3TNsZeX/7D5hlwft74zxDtqTpwrLijat7XtO7IKIQcwePb0j3We?=
 =?us-ascii?Q?tbNkN2Ji8CsdymMG7dsfgmEAZ0Va3FJMKdL34Dqsg4JzrnTnnS96PGxH5yYX?=
 =?us-ascii?Q?ENXPnWH0zYq4IcNKhxyUaTkEmJnFVnVLXE1ajqNeHSW4LNaNmBtXqRv/yequ?=
 =?us-ascii?Q?CTqIzy3d4YWW22NTW5SY46MnTdDBK9WHAFlits2XDIHZAHv3YRPOfW9GfzrV?=
 =?us-ascii?Q?a/rPcnOquVybzMH8AzjWiY6tjvkCzIM3GWmd0BSrLLb1bdgA596VAtX7Fe0E?=
 =?us-ascii?Q?cl+oJhKOVTbiMN+VYk6cVierb+B8BnnxFV0wPZuz4em/3Xpw8g53N+wXFXMd?=
 =?us-ascii?Q?shknso8pKtdNILQFy+ESwMYZL3/4piMT4jFhZUwiJbI43JXqnDUTk0c3VttF?=
 =?us-ascii?Q?8f/7ngaw+HtAnqp17c1wyCWOZtRd4MV2kmGdfENdSxWe1LZ1Oe83SDx+Q7B2?=
 =?us-ascii?Q?7DS51FOBZY4kU5o/wujdKW1QFt1DStofn6RFbbYuuqRXY9jid7yqZvnj7btr?=
 =?us-ascii?Q?xFCOf1ZRT4PjzkVlNky8F15+oVV3Jid0gO6cA3XIusIQawJed9RPInCbUXL+?=
 =?us-ascii?Q?7JwoimTumr2WA8k8OlMCJ3Ys+zU5Mfup9f2qgTUyV+ytCG+8rWEg0vsNmeuM?=
 =?us-ascii?Q?nL14pXuW5eF1jcDDK3d67tFiIM8+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gjGhE02qCkoNZfxOulgOeU3PJNij1aeIHk4E7almCpDkTRHP0d7Gv2ckUJ1/?=
 =?us-ascii?Q?us52ovtzaIlCfYzJZvJTq+1q0+mc8gA1LN+L/61xpeOu8419ew8GmuR7OJpa?=
 =?us-ascii?Q?ILbGGXj7S8GYS8KkF5ksdW1eqZxUwYSITd4wdcsPNiRc+LGoRGmyIrY1TqIf?=
 =?us-ascii?Q?gg8eb81CSM1182oS1+5lPHAaj37g36Ai2WmD0UOKQzWv5BaVuWPI5GrkVyF8?=
 =?us-ascii?Q?7Ws05vJMHgmsyQ+MJcUOr2f+rMJ3kcJc6swMbG20zB8QO5eS8RU66M7bAu3z?=
 =?us-ascii?Q?DYVZ/vlSmrxGW97FHGdgsEkUpa8V/81naDQBG5UjsbDNXyc/KELhf89sQ8f0?=
 =?us-ascii?Q?/Z4DFdtaXl9xkZRKY/jPOg7RH4UDDo3HXjmG+Em1PFxcH3T5OAuCiv0eGJ8j?=
 =?us-ascii?Q?D5p/Co00o8SuvdJwMhFt/G7jNz3XFcEChvtay5AkXgHKmbn/KW/lycoW3Ci2?=
 =?us-ascii?Q?/rg2I0lnIJCA14FYWxCT6wgWE5wZTiw9o/+PnuNqLpAZDus/OzKD8nb8s5xJ?=
 =?us-ascii?Q?IbtqjC+8HiMfDeJ6E2YJ/0d8EriiurRu5I2DsWBh1wL6YvwoEvnqx5RJapa2?=
 =?us-ascii?Q?n967vQi2xmlwxdyD0qur4J+ctAnG8vjVE/HGx3ffTQ/3WYNkWnaF4khJyXdd?=
 =?us-ascii?Q?dc16RiiUg6hFL1WRZKIsTqzAoM60lt9Gcevk/EnjNyAWgo5Zvl/z5RxywWPh?=
 =?us-ascii?Q?xiSSn4J3UzZ4O2T8dEOPgcC4Y5eZaVEfr1QoL/xoAoBqGQbmS0krl7NG0qBe?=
 =?us-ascii?Q?97528V7+yk8qjfB/9g8tU2Z3D1JVD0EAiu5wgh9DEQ8mOD0EgoLI4Dms1NJZ?=
 =?us-ascii?Q?DP1Z8c9mSfLCRzvRrzaVOo0uO0ieFN8b8ZaVGywQOYkqanhBY/OF9nQ5jd6r?=
 =?us-ascii?Q?7VEbyIKjpCSVWog2zxvtbfVPJMRCpEab2GfUC4eKK3XtBwieudwwUfCWNrsk?=
 =?us-ascii?Q?Ca72hL0q88a+yZiD6lGGA0KNdKojKCBMbzwxW2Vj7Gtz+Blgipdn/Hh+gl+D?=
 =?us-ascii?Q?/UO3mOHZcjKAIXV4YVpHO2lpqfG4/5Ket26zKpgw5Y0ttrsxu/gbzHWvMyVP?=
 =?us-ascii?Q?pR3FIWA7nG0vl60+r9Bq6VCNZd5YzzFY3SnKWh6fDF03SXMN7+ol5X3Pst/N?=
 =?us-ascii?Q?9zdi2H73wrL5BGWSxlKMNHosHSMDkQEjkHHAjw/+ld+bvoV4my8NwjD4K4A5?=
 =?us-ascii?Q?BOlBRjcV2HvC2Lf1JSwUhgl4iAllBUXCCUN1UVPyM6fPKuGpXo+M4+Dg9p+K?=
 =?us-ascii?Q?RaWSodzF1MAZcEDMAw6k4FiPjNoi7fiBfygniiPK1gNTkY2uGE1bFON2e73d?=
 =?us-ascii?Q?bD3bt/Te8ylFSac5g/2FamYHliSMvnW4eVMvc8EDVJcYuTq+raCOFqx6Tjez?=
 =?us-ascii?Q?1dJK3G/PvSOhbQFkr2S+NjTHbe5wMOi4Wd1n46e8gfwih8OIFssCmvoHrNY5?=
 =?us-ascii?Q?AgojtbOtkFXWR17sM9SMrBH5m0LrHrRxQjrWKIcF+5Zfqt9bbfY3Dsbc5Usz?=
 =?us-ascii?Q?N9jnh9rIInIcSRKZk93OsrIwcTcnfE3rWP0B/+NmelpL32DoMfcL0mgbw0f6?=
 =?us-ascii?Q?bmMyfvcOg0cHd8Nw5q8ZZM3Pwm/E6e440GIhdSr1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb0295ec-b45a-4e33-922f-08ddbe8ff653
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 02:26:08.1058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6H9JK++6eN4gcwlnAxPCLXWJBdSrymDRSMOggdONQBYf6BJrtwdkE5qrcUm5dh94rrMq0XQzOM8zl0XZh+qxXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4598
X-OriginatorOrg: intel.com

On Tue, Jul 08, 2025 at 09:55:39PM +0800, Edgecombe, Rick P wrote:
> On Tue, 2025-07-08 at 16:48 +0800, Yan Zhao wrote:
> > On Thu, Apr 24, 2025 at 11:04:28AM +0800, Yan Zhao wrote:
> > > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > > index f5e2a937c1e7..a66d501b5677 100644
> > > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > > @@ -1595,9 +1595,18 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u
> > According to the discussion in DPAMT [*],
> > "hpa here points to a 2M region that pamt_pages covers. We don't have
> > struct page that represents it. Passing 4k struct page would be
> > misleading IMO."
> > 
> > Should we update tdh_mem_page_aug() accordingly to use hpa?
> > Or use struct folio instead?
> > 
> > [*] https://lore.kernel.org/all/3coaqkcfp7xtpvh2x4kph55qlopupknm7dmzqox6fakzaedhem@a2oysbvbshpm/
> 
> The original seamcall wrapper patches used "u64 hpa", etc everywhere. The
> feedback was that it was too error prone to not have types. We looked at using
> kvm types (hpa_t, etc), but the type checking was still just surface level [0].
> 
> So the goal is to reduce errors and improve code readability. We can consider
> breaking symmetry if it is better that way. In this case though, why not use
> struct folio?
I'm Ok with using struct folio.
My previous ask was based on 2 considerations:

1. hpa is simpler and I didn't find Dave's NAK to Kirill's patch (v1 or v2).
2. using struct folio, I need to introduce "start_idx" as well (as below),
   because it's likely that guest_memfd provides a huge folio while KVM wants to
   map it at 4KB.

u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct folio *folio, 
                     unsigned long start_idx, u64 *ext_err1, u64 *ext_err2)      
{                                                                                
        struct page *start = folio_page(folio, start_idx);                       
        unsigned long npages = 1 << (level * PTE_SHIFT);                         
        struct tdx_module_args args = {                                          
                .rcx = gpa | level,                                              
                .rdx = tdx_tdr_pa(td),                                           
                .r8 = page_to_phys(start),                                       
        };                                                                       
        u64 ret;                                                                 
                                                                                 
        if (start_idx + npages > folio_nr_pages(folio))                          
                return TDX_SW_ERROR;                                             
                                                                                 
        for (int i = 0; i < npages; i++)                                         
                tdx_clflush_page(nth_page(start, i));                            
                                                                                 
        ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);                             
                                                                                 
        *ext_err1 = args.rcx;                                                    
        *ext_err2 = args.rdx;                                                    
                                                                                 
        return ret;                                                              
}                                   



> [0] https://lore.kernel.org/kvm/30d0cef5-82d5-4325-b149-0e99833b8785@intel.com/

