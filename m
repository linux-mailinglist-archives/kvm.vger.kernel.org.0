Return-Path: <kvm+bounces-45178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6847CAA65A9
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 23:37:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DD551BA6284
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 21:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F94251790;
	Thu,  1 May 2025 21:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RLJZmK79"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336691DD0EF;
	Thu,  1 May 2025 21:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746135439; cv=fail; b=uybVZopN+v34l2axnucaNWgFgGDPXqb18lXmfPcrDXSqgXL4dmYApK1l6+6+TtfVRWJOPnUqh8Vm6yyDjyqFaVTX4C6k0CvvzrZxPWNbQkwtvIznVOVoxRGla+gq6BHJkBWhC2zpjNAJ+ERCC83Zk0U2ULxGyw3mPapAq4GCu1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746135439; c=relaxed/simple;
	bh=aw2q3YuypjO0R+0Z7q4EfvMp2fpmkzbrXUOWBc7nMBA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=e7lIZY/4de+14j3El/ripijQZ9vzDocG7uvTyz76cUGO9kdQP1LGjmqthXbcGTBImwoHGRYo2cEuz+rCQ97waRnmSOWzB8bIgBhB/exPSfQnHi5p5qvGu5Z6w6o9PafEM5kwpvivF3gRjwkeHrpvYjrYvb/Fsme5io9zjsFNvgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RLJZmK79; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746135438; x=1777671438;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aw2q3YuypjO0R+0Z7q4EfvMp2fpmkzbrXUOWBc7nMBA=;
  b=RLJZmK7944RUB588k4Ep+tcsouwxfkmkF4PYmx0aGn7WZUGrhtcM9DVA
   K2dtntA+Di3kFNPd3BKohA874WVvuisuOnrtlvuzSKdgnhKyeHkWMht/a
   RCZvpyhJgzBi7CbHMjmZ7eg2O1orCgbjbS58itudPrBXuspmj5/zDDuHl
   DiGBQE2ZApuLW7/cYNBX75+YYgNPGYOBpWdl29zR79/Zbktvbku5FbhT2
   nNRbnhuRhqqM7to6Z4AJ3rmbWVfkESFOELbRxMrxuL1hKz5T8WkSuA6ei
   f6iBVHTUiwZ+iRoZfu6h2KwmXN0m5zJpAhVkalfs6M1AZSf70Nx4A2BHP
   A==;
X-CSE-ConnectionGUID: jlqhGfIdS6qbY3B/9PiBQA==
X-CSE-MsgGUID: gIBnGgG5RgiXLMOAsKFZxQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11420"; a="47962409"
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="47962409"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 14:37:17 -0700
X-CSE-ConnectionGUID: vlwWOio2QiW5gMU7trYu1w==
X-CSE-MsgGUID: kJwZr9jYR4aoHAlTno36Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="134434288"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 14:37:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 1 May 2025 14:37:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 1 May 2025 14:37:14 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 1 May 2025 14:37:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f/6hj4CM9P2pCW7SLkRUy3sRlzdSrxlyxw50b0u+lGzEb/WuYY/5vWQZiedfyYdkbEAy+QFm4AG/mtRVouG/Mhg47yYnyGuh/L+Ri6pgW/9mSNpWnPcxF8M+XyZtudebxwOszubP8VW2t2RC9ByzqZuvSscncq3Rga5zz0HePgS/aKl8rsdLgxxuTlC+E/M2dOpFb1bD+yLLVjBFMuPojB/UVnVZ/K8zTwLXr3iDBc5BYJqNM1XYNpaRjx542KwWOPJH7KDmqiDhAALZc1r4nv1GIYWUUPzW2MaQBP17IosBxuwG5BeMUJ9XTiwqbWBXeF7Yg41WWo2KELefHBQ3rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRUHO4gAwugcR4AWEgJAJNu9Mdek9OEk1VPByczZZwI=;
 b=BxXVK5EwAo1VFapv052C47CrZJwox12Q3dlMuL+F57Y3pDyKNnW4pqSwLt9YkONW+ZznnaPaenAnKYQnx9ATwCTccjeCA97KUiD2QNyTfJftQYKx/bBgFbqLhnC0gSHKrXy+sZTz5VPGYEsq4oLp6h8lQHUZzjV1wdJHAuNSzYoxua7fiQxh8HYNPKyVhau/MTpFNml/oq2/4Y6xUWc/BtdZUmJiIvzuv7dsDZYyvw+kTfHihkKnuZFw8IgEeohplUBP24sz1wnlPAT1tD1PuYGP8lUCryJms4d9lBoXF1VwVoya8vGzWzNCn9i1AX+dtkcWxz7Zz0uRInEEK7u2Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SJ2PR11MB8537.namprd11.prod.outlook.com (2603:10b6:a03:56f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Thu, 1 May
 2025 21:37:09 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.8699.012; Thu, 1 May 2025
 21:37:08 +0000
Date: Thu, 1 May 2025 16:37:38 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Fuad Tabba <tabba@google.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>
CC: <pbonzini@redhat.com>, <chenhuacai@kernel.org>, <mpe@ellerman.id.au>,
	<anup@brainfault.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <seanjc@google.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <willy@infradead.org>, <akpm@linux-foundation.org>,
	<xiaoyao.li@intel.com>, <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
	<jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <mic@digikod.net>, <vbabka@suse.cz>,
	<vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <david@redhat.com>, <michael.roth@amd.com>,
	<wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
	<isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
	<suzuki.poulose@arm.com>, <steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <roypat@amazon.co.uk>,
	<shuah@kernel.org>, <hch@infradead.org>, <jgg@nvidia.com>,
	<rientjes@google.com>, <jhubbard@nvidia.com>, <fvdl@google.com>,
	<hughd@google.com>, <jthoughton@google.com>, <peterx@redhat.com>,
	<pankaj.gupta@amd.com>, <tabba@google.com>
Subject: Re: [PATCH v8 05/13] KVM: Rename kvm_slot_can_be_private() to
 kvm_slot_has_gmem()
Message-ID: <6813e9a2976a7_2751462949a@iweiny-mobl.notmuch>
References: <20250430165655.605595-1-tabba@google.com>
 <20250430165655.605595-6-tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250430165655.605595-6-tabba@google.com>
X-ClientProxiedBy: MW4PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:303:83::23) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SJ2PR11MB8537:EE_
X-MS-Office365-Filtering-Correlation-Id: df4db95e-ba3f-4c41-20b9-08dd88f85341
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ywx2yCDl9KaiotIfVzB+d9L6a3wEW2112dSK/GOwMqRhVgf11cC7DT6LgpDW?=
 =?us-ascii?Q?p/cXy5LQ358RyqAqR6bgYtJQhHNmhGVbxLHo7YmpZZtif7OI7ete7li7diFl?=
 =?us-ascii?Q?P9cFdSV1PuKevPXUoG9pBYhfIhsPgegGte/3P5u/NyKgUkhHvtR7qd98XeCN?=
 =?us-ascii?Q?gaYHg4eL/19ifcxcUGrXVdZess5m+OHiJZCNBAdatOIrd9qo1cvdPiDJH/MX?=
 =?us-ascii?Q?dyPaE6FH0/leino526eIo/OonIG7W429ipWnmjb6Wvr5wWqxQilliQxUGLli?=
 =?us-ascii?Q?d7ekXXGqGls0tB9Y1HG7SLn1eyht5JBP+dqfIlrwwa4Z6+ufNBHZF9lc9WV1?=
 =?us-ascii?Q?3mGYaxZbjVkSEZdEO+Ihbmrs0r/GUqM+4ch71h0/MXOuBlwlNHn3DCaJnyNL?=
 =?us-ascii?Q?TK+QO4f1k6HJJWWxIRkA92vbiN6moAT5Yknp4XSSEh1gibtWY8Ed5YUCR2wV?=
 =?us-ascii?Q?fMMneXoAom6d0SKuAqZwseyGL7nHtULh//o/lWfU8dlpYD5t2HeZNQkR3jGi?=
 =?us-ascii?Q?pfKcy2inMPd3VOqRqs9M1YjJvzH3SN7ZC42yewSeE8b+eOaG7FHhlzL5r4my?=
 =?us-ascii?Q?ESOugc2AQSKMc1IKPNygqrOx42Dj8J7hZuCIV/qv3hoX2IGo6+GvuA79sZ3I?=
 =?us-ascii?Q?O+3t+DEaRvd9RGvNk8WsEehD+j8w26PW3nDtn8lpyDnHy44DqSa8auPm3PfB?=
 =?us-ascii?Q?l+puDeVIOaBFenLSK864QCkh1orjUzpC2sTygHQMMAVSsFKfmPeCfamQsiWZ?=
 =?us-ascii?Q?VEi3oTrk8nxt6xQDybu6MrcK/zg6412JApYRWJhAc10F7BAoK8zljAwutQTs?=
 =?us-ascii?Q?2mqlTdn2xXEkME+/Rq25TpRj4JwdMctqq7GIXF0amW3LfG/AW5Jw6jh6cmoZ?=
 =?us-ascii?Q?8kNBhC8rm67qplrrlclz6OmakFBqKUEs1/TDCbaOhsjHeP6/wNT6QlRm7D8P?=
 =?us-ascii?Q?WTBwYjAylL+jTtYu9GMxDoGleFbZmtpG2yygguEt7s781OJQK58Im2wLNeIc?=
 =?us-ascii?Q?Fg3S1XbLpDVKqI1BNe3eWVsQe3z7qGlNReII342K4BZa2aL3DYSC27oUbm15?=
 =?us-ascii?Q?wl42QLnw9u3CnUkv34J5NK+Hetn849aBh2sUHRU1ylvgGCtFlYqwNcC5o26r?=
 =?us-ascii?Q?YvKwLt2E5XGipZOVaYj1q9iTTPIfKNB01NCNzY9XO3xv0WONoUw0Tg4aztWM?=
 =?us-ascii?Q?n/aVx8VCuOGw8ELzdhXDqLVCDe4rSzbnV+u8YZraQbJ6jOk7lOkrxLc7MTYJ?=
 =?us-ascii?Q?wbhuI/8ZZ+4PzylA01qb/CxWg4BbEdx+Yzr0qramrVMYjHATFHOaaNi6kUNU?=
 =?us-ascii?Q?siwkAy+N/V2yXyvV4lzCXK8rxAHu7+bEl8adgKDo1jQjH7m+iLF7M3XV8c/s?=
 =?us-ascii?Q?NmIbW8dYMT5nQ1A9TsSesb5a2ksygwsD2cSKxnhBSIudS5svlcebJs3TzivG?=
 =?us-ascii?Q?ens3gpBKy+M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qiagjYx4NEkqqqMTJcj53yFg9J1pG1BvLn8bf0pgISC/zsXX7fc8/F24CwvG?=
 =?us-ascii?Q?fmIN+mfGCkSLMf1lpgXcr8xsO1nc78fzUUmZZckiZavWq6p+DJvHtl1+zmvh?=
 =?us-ascii?Q?bqOSa5HQn0Ssbe657l2FLf4REj0n3n6RLhUJHOntweovCzZhmLOmbz2FUe5c?=
 =?us-ascii?Q?zLEyMz1DwLeszIKdVZ0QkecixXoMRsfgXBaigV/XkQrqMEC+KI0LFxggWDRe?=
 =?us-ascii?Q?Qt5g2HemaO2zNIy5wJ5uXkiesnOvN8tP+yAruq0FX7jdCnFETFWpa5tE99Dy?=
 =?us-ascii?Q?sKwPV4U5si8DA3QHUe3IXcykabzK4wKYkBXgcMDsF6VOBaQYcp7iPAmZ8L9g?=
 =?us-ascii?Q?PDbI5gBS1kZDYW5nGjZeDW8JVbIWlJDrJRZLot0xM7PrP6NRhcoj4jLDZRLm?=
 =?us-ascii?Q?mAg23PxQjVtcIaVDn2j6ShWjBERcB4OHKPJdoeiSQqWxB3VpBYCFkbslvwnG?=
 =?us-ascii?Q?Mfln/ZP6LN6YC1zYBKK+h5K5j6+B2ChocaZfBkUsW2L1so6cA2SAiucyZGE7?=
 =?us-ascii?Q?wswQG41bsLQVUbtNdA9tqObfWSQwky5V2qRi1QcY/YZOj9K6e3QBDOpM8e5H?=
 =?us-ascii?Q?gaCYMWKL4ATRAwwH3SkMQGDbacBSRA0akGNj5+HSI6h3YDbtE/F/CtwsB3xl?=
 =?us-ascii?Q?QCFEOJsdb72/VopZXEx6b7WirLiRYM8zff0y2YK2fORJ6EyIjXuYG5nN6M8o?=
 =?us-ascii?Q?DKXDV8t6mKKeaUWATmnRA7Ln/e/RC00yw7KBPB5DGa8n/HbBspk0jLpXm3Sz?=
 =?us-ascii?Q?VvrB0j4vjinQvv2QZt19jPDjuQj7Djz4KLLMy/pgCodvxatXfik1XMmgKRhI?=
 =?us-ascii?Q?7KrkG61439aUkvjvSX6rdTwoREzTbpipiXAISryOw71+zuiTRHc/ZvtQVkay?=
 =?us-ascii?Q?C1NI3Jgb4E/yhZroU2nkMWBgIO7ciU9uGuFxfNKjxJTgQr7g1L9MHsPlf0rk?=
 =?us-ascii?Q?vBrhF+cHVgfi2sq1rjIZOykKYAATbqFSGz9qmqkoDQABV5e6v5y+afn/zAHc?=
 =?us-ascii?Q?GyIvZxuHP9uhI+Gw1BTUdS+HthlQ4qAdfNrByFn2gFO+skoTUzqh+j4khbml?=
 =?us-ascii?Q?md0WQVJcCWaSE7Uu+GzX0hERNeDFGf2dSPbW4kW99qRUBy9SBm5fpYSvdLbH?=
 =?us-ascii?Q?qgdNV9rbWW5PP49aYPcWmmEjvlzFsSD00ms4muRuq9/Q7jPizXQ+QcjajxYq?=
 =?us-ascii?Q?Bala2f0ib+1ph7TYoaxWT1zRG2qkn4ca8dOOoGnaZuPhm1ZCJ1f7tRXLc3j9?=
 =?us-ascii?Q?wsTPUppmeGBBgZ+GgCyxhHBYhTz7ISlJLPrsJm1PgW/YjV10vVwArXKdFAfh?=
 =?us-ascii?Q?qazzcsL8IE0rz9TlFAlrvAQmuby7tASzHd1SJ0sQO+e189Qt3lQPDx9upc4E?=
 =?us-ascii?Q?TyD9gnsP4AkQMrRARj+soVcMYvVhnjOBU/jJyT58wpxZ/Dq2DcaTR46ZoKb7?=
 =?us-ascii?Q?uYTf0Kkz611/YJLy9Cyi3gP4DvmijZUMQOSrjITIWQmWU5SuyKRT9hsWslQO?=
 =?us-ascii?Q?itiFA/b4kizDMHpeW0A1DISDZN0DwYMFDw9hxVh/8YKDQBJ+ojHnNU8jwINw?=
 =?us-ascii?Q?cmYNFqkGQT3vv2ARcEaiJNgJQgtrmhTsVeEnEAz1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df4db95e-ba3f-4c41-20b9-08dd88f85341
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 21:37:08.8288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b+5Tapef1q7D4u2ETwJ8Rv62HvhczPdd/gBaouMv9Rxdn+QXqJ18sC3N4vZ+jy203/l+OGwfYy2t6CTSlHcOSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8537
X-OriginatorOrg: intel.com

Fuad Tabba wrote:
> The function kvm_slot_can_be_private() is used to check whether a memory
> slot is backed by guest_memfd. Rename it to kvm_slot_has_gmem() to make
> that clearer and to decouple memory being private from guest_memfd.
> 
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]

