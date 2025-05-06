Return-Path: <kvm+bounces-45555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 566C9AAB9CF
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE80B17B431
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 07:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79F3D2163B9;
	Tue,  6 May 2025 04:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="abYuXqBs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC2F28A1EB;
	Tue,  6 May 2025 03:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746502213; cv=fail; b=Bs12cSNYGlViBzxLGc59bqCgPydysBBf2Qkt3G9GW4K2T0bB45W7oDfyGMD2Z+P05GlBy6sNoxQHdaPSjMonCRJUrRch6+l6vqu0er9fyjqO7te+TYEOU5yCfoZr0PQqtwyUfIwxJdjnj+6s3s0xluJZwVJBlRSu0jhb/miAacQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746502213; c=relaxed/simple;
	bh=+1oM2RLgU5Y5SzX/iL8ikL5J6nuUzXS7t1SXe2hAOyI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RAfCjXnYEKaGRPWPaiXf9OgM/l6UfdspmrutoU0ms3I/TLLYs0xXKS0uNb1JI0Mp+OrXhyfKqdtnTnMNx1BTRWPvhf8L//VQYpBIzPeXz0qhBKo2xmmupgZyyv9tYpk+vUFv+cigdl72Eh0KpM5EzBs4cG7dmp/B8aERC894koc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=abYuXqBs; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746502212; x=1778038212;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+1oM2RLgU5Y5SzX/iL8ikL5J6nuUzXS7t1SXe2hAOyI=;
  b=abYuXqBssHT6HgiFC2tVIUfIBP/KeJ2wdhKYB4I08aDFEZfiK89c+nf5
   yszVm6YkukekOsYOYO9+Gwk5K+TEr1LTGy/w5zq0bfCs3FG0SAkfyK3Tc
   RLnYJk0m729G7eOs52gmiC/sC30QmfOlmxvjTgOB4QOXr3DDWcq53g4Ap
   WAU0Z2KAecCn+2v/sV3j1aBXsMvlQuWPilz2suPsix2dvQGOZZKO2FHLb
   Rz+WFy5YKrl9x+rFruLDZOi7PGNy2xuzafy/yY7nRJ9l4IbUg14Mlfd6x
   KglrpIaTBodupBpcGEJ1UyvBDSPnAheDDVker+WidhFetDLPlMg45cWg1
   g==;
X-CSE-ConnectionGUID: xFYnTCf2Q02w/DzASQXqgQ==
X-CSE-MsgGUID: 9GaKyB/NSjSZUaedntrfEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="48051519"
X-IronPort-AV: E=Sophos;i="6.15,265,1739865600"; 
   d="scan'208";a="48051519"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 20:30:11 -0700
X-CSE-ConnectionGUID: AsVq4w7dRGq0rR48NNH8Ow==
X-CSE-MsgGUID: PCmDarBGQPyaxs2B04ozFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,265,1739865600"; 
   d="scan'208";a="166533540"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 20:30:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 5 May 2025 20:30:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 5 May 2025 20:30:09 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 5 May 2025 20:30:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NnGGoMKrZe0ZoHGCgBEGM265XJWApvzRGv4nlIHQk00ufPnf5UAfligXsTIXuxU5FVS+5Qsl58sZfCMI7SEai869eCXGwdRw590a0OCOQBwj8dgIlhiE9lD7RUaK0l7XD6iUtnQ+FSkalKXKv249UNl0E493yLmySGirG1KyPwSJDMOd/rZewFEqNZZ/g8XhsTYjs1+wRyTCpW/GcE3zmZPl5h7+6QPSsfG6YhQT83I4iSoxcsUduaagLMjmBZpUf+nrWLlBSrfQxHa48VhjSb/eULdSARIolAzAwcLk/evn1DJQoo000OyuGQOWde33YQj3qgP+mTWG1W7ANT8Hmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oI8KJmDQ1GL0EvrbHpZOrytmClmHgGTS9FguPyl25Vo=;
 b=ylT2nHrIL8sCsNukLjqbsV4rA1izH5jK7cneT14vMFpBMKWk5cW0pvgFZ70sR9RuAiT/o2jBgGQIsvip7XK/zQ3PmfZ0FfnKpQJeXEi0czjcYUcwd4DO1ihvrIxFqVIvzsN6+onJcprLYxwCflGmD1SRVACAGqy8qbnmqvBG/ORujgD61nh26d2NAgCn+vNJe8U0niZqKcwPe/5+h9BXQ50l5kVxhi7SyKDD9c84TVr0BIWJx7DF51KJaSw+XHLaEiv1MGO4pk/Fbt1vrPo24u6B6LA+9TuJG+dJMJ85HC8xMZYnJozI6DBEibvzlD6/0A3y+OglfSVqvwxtrTJmwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA3PR11MB9086.namprd11.prod.outlook.com (2603:10b6:208:57b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Tue, 6 May
 2025 03:29:30 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Tue, 6 May 2025
 03:29:30 +0000
Date: Tue, 6 May 2025 11:29:16 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<tglx@linutronix.de>, <dave.hansen@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Samuel Holland <samuel.holland@sifive.com>,
	Mitchell Levy <levymitchell0@gmail.com>, Eric Biggers <ebiggers@google.com>,
	Stanislav Spassov <stanspas@amazon.de>, Vignesh Balasubramanian
	<vigbalas@amd.com>, Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features
 for host and guest FPUs
Message-ID: <aBmCDCZNX+mddOSM@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
 <20250410072605.2358393-4-chao.gao@intel.com>
 <3c4cc319-feac-461d-a846-7275b0ebca4b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3c4cc319-feac-461d-a846-7275b0ebca4b@intel.com>
X-ClientProxiedBy: SG2PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:3:18::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA3PR11MB9086:EE_
X-MS-Office365-Filtering-Correlation-Id: d67a9eff-be59-4852-a343-08dd8c4e3635
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?eMq+UiW6L1PzbmSlNohJmvUnt6UjHJzCzA10+kB9EpENWOSRUEZbEHf0Hprz?=
 =?us-ascii?Q?KBBqMBMhYuCVwfpz532nKDSCxnTqYe5paI25cvSPoO6ycM0rSkvd1dGipLwl?=
 =?us-ascii?Q?cJZG11QYdrctP7XfzWXZBCfCTJVBP3+jZN33N/xkOdpgotxGwqlybZJ0TAeg?=
 =?us-ascii?Q?CrXVS8QihEgCfZRyhVAyH/TFqS8ndxTe1UGH1+7JZIddk+hDC45dcvuqGorU?=
 =?us-ascii?Q?W1YIMZVsAtuE8SzMBfIk0gR5ojvAn8pu2QLIn3uhPUuFD/rcPgwESOKdoO1E?=
 =?us-ascii?Q?5jbYRo8NNXsRBMKmft4MqPIZX1BFPTDs4BryNJJAjsEIwuBK/XdxOGlPDwtH?=
 =?us-ascii?Q?WLN8GrV6EOVBu0jSWxR9XDLmWrJy2UAVq7y0GI847lTj8C7nSgUKLBNHuqL/?=
 =?us-ascii?Q?oHPZJWknf+drmoyN3anfooMtSibumlcp5/FvV2WY+8ODniPNUfP8WLYPlAph?=
 =?us-ascii?Q?8KgV56Q39efW1/AqDxb3UzQxzNdMjcB0fyEIO6IiE/sb/pLW2+f4NrpvOmkF?=
 =?us-ascii?Q?/7RdwIyYiULymSbdTftkrwpPdETiVGv/niUKDrLZlaTlrykusU+JCqRmEMJ5?=
 =?us-ascii?Q?LkgNCn7FKHmKCkK2JJW+FtJ+8cDs+xmjAMbMWucJJmRqOYmVB3ZoD3Wki7dE?=
 =?us-ascii?Q?cDn0Urt1pQyTzen9oeRSKhV+ooxuZQgGpzQjWt1zb3WmDkZRDAkd+cWQ6D+W?=
 =?us-ascii?Q?jSt4YMkaLCCoasCOAOuPF0LhgLsYIe4ZYN/h1iv/7yjJJomOkQowOtqRx189?=
 =?us-ascii?Q?NrhHmIv6GcgfXTWwZdfzFOaLq71Q0FlbL33zGugQ4WFauvnHGu6Yk5eISHiP?=
 =?us-ascii?Q?exeCMIjIKfhGTt6q/5DqfPkKk+Do1XbuYdPe4+sPWB9jKOvsmessOp68Pc6u?=
 =?us-ascii?Q?zXLn9BN7KftU5qcPuK857DKc9HH4nkXj0OcUIGXzOK03GlZf6+dgEbX1V9cT?=
 =?us-ascii?Q?ePLSiTmz5WZGD9bXiREQHUsvcrzirkYJyXHzJHeZjV4MnLe638ntYC/mpuvq?=
 =?us-ascii?Q?WGEF2JO1Tm1+Aa6A5Gh9+XA8RaVGcP0VqA4e/h4UTO9l/T7qsDYGc14foHJW?=
 =?us-ascii?Q?h0L6Miaa5iJongNpaEOSE3g+mzBQvk5qp9b0wh/HY+o8uNy0qsaXToJNMXbu?=
 =?us-ascii?Q?CtoNzivmPfu6g4FlpyH8dsD8bG6+H/cxUd1lACKxEi1LYs7pYrSmgz2pUDmW?=
 =?us-ascii?Q?SY8NYGQYsw11uiAVHZKSMQ5IBsIXbyMDfLGt8LmNbjfv29eqrbAon6QjlgDo?=
 =?us-ascii?Q?eYFO4mUhlUa4JkjZj4fdUXMMfqyXoLRyW08ZwIj4y1fmc2sVTYbP7cA7RvUw?=
 =?us-ascii?Q?Ut4VDlelvXFE2s/O8jdS5qCjvaiIKXrchejjexvTtixzv+zIVFG4Enc5g8yW?=
 =?us-ascii?Q?jXrp1p6yuUyAJBB3Hj/8JVq2Hp4BKgHif4k4PSEICeOzglpHMDzlpqydgmFz?=
 =?us-ascii?Q?VAKhKZlne1k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?14kRX+sRX9qcno3x2nNj4Hd7HSs3l5ibiZGWvW7GRBDOXCd/QNHnfEWlOM3O?=
 =?us-ascii?Q?vTR9zMBmFprFQI/F33hUeR0Kzt6hNoM/t8RoU2TpvIn3M0/bjEqkc8QVUiD/?=
 =?us-ascii?Q?tU6J1pePWyR5M/sQpPtvJhZdzJJCAcvPpdgEELjVhfzqNtll+VStTno7efl/?=
 =?us-ascii?Q?y1cWBCtu4UJ57GzGFhhRAnLuCMODpkSa6F0dZCMhGnj898dz5kcksodF+aoz?=
 =?us-ascii?Q?nmfOYj8aMsL2aPZ9BYdXPGyB4NkvlKR/2C203+x+qCi2CADHNrcEefkdYpcZ?=
 =?us-ascii?Q?n8hwULIJnCWU4cZDdmMnVTqTFBzD3trm6LMt8YM4vTsiT7GauTlKn9Bq2Idy?=
 =?us-ascii?Q?yWO1z+EKMOFePSZr5sM4JS20CI5f+AuANr2qw0ft3zhbKMmc8Yp7KMdDQiEa?=
 =?us-ascii?Q?P0G6ksQxV1LTYTD5xjWMOcDf3SuCob/UyhxmMhyRZkw3zJvQ4X7AuXN56SbG?=
 =?us-ascii?Q?cRtFALQP1esxmErkNAjRtkhnA8CgHyYMBrmNvzz9ZeMpmpzD6MYIk1pri2Rx?=
 =?us-ascii?Q?TYi/cBlgCgsi8TlBnLw17QDjbUR3Gd5zUvtdsENpEfcleFWv4Pql3/iqe5wH?=
 =?us-ascii?Q?iVSxELRdYucz/HmRZv/UfdapAFnoRGB6JTkI0ONO30R9QPRCahZPQqS9asKV?=
 =?us-ascii?Q?aqZ88eXstLPcKNcXyPLw/nG6CY+sRvCNxPVzCE3G5WNJ9KFCBrqmhO6gbuQu?=
 =?us-ascii?Q?q/L7UKJwi6slka8kSKJEITv/TqNsTFtpmmjuxbYH5zRoSttQNEmlIptyi+Hz?=
 =?us-ascii?Q?UGu7DF97WmWCMKohOhL4EFQe9IFpDPvYUfVoi8Rg9qq49OAepQEt0rSKRKNX?=
 =?us-ascii?Q?l9xF/Wn19TsSDuKjY/s2WUbUglTTuIA1MqFQjgDG+3MsdyQGT3exbScByTNz?=
 =?us-ascii?Q?zddIyirPr3lW3z91yGFutsgZxnp8nITplBdT8LTIIWdYBjQVFzSbi+SRyna2?=
 =?us-ascii?Q?b1dK4Zd+ecIg7rvmbMEoX2KFDfH8AHmRgAvpnUjVjHbNsp1qBKINOfYLKYgL?=
 =?us-ascii?Q?SMTCQIzg7aGkMLhZQp2QAYTB2w6fP5kvKQk1sFY+L5YWG5SO+DafNqbf/Ugo?=
 =?us-ascii?Q?JCz4Qbbz/DOxFcCLUwJd44x60LkB67k28tMmO9z3qFyK3RrgzzGH5kLfF5/m?=
 =?us-ascii?Q?dQstegosT+JEZALrL+GNr8uofRTbfY5q0pl6FRpeWmt24k6rQ1Cqzc2zvyhR?=
 =?us-ascii?Q?6QKW1YvnDXjBeCZsUqZvvM946fMlFCVBc7TSttpmvi7eC35UZIi9zFC20sL+?=
 =?us-ascii?Q?ALQcI3qlrJDZaFm/jRlY16qaRo5h4cEm2uk7p3bYFl2j9e01c1EZHbiNJA5+?=
 =?us-ascii?Q?+RYcBmhhsZ9gOHP7r26k0nsaC6UrG85fR3VdjnXzrwMqDuAUHF8oFmDG9fQn?=
 =?us-ascii?Q?0bIrdpkR6teiQMPqF2vLH4FQ4bIe6p2JYTE+ZYrR44VWMI6oEsPxSWdOwVGA?=
 =?us-ascii?Q?PnR0D/ofHenZaLhr9hw424y/5cCG0uXaMWjEkNsIvQKgRCzqpega2wRhxMda?=
 =?us-ascii?Q?PhLh6m9fkcbqagVTTwTlXIO0OU7NW7UOXaiPkGj7+E0GQBAvA/1vgkPCWl9z?=
 =?us-ascii?Q?oyums/PGR9XuRu7BTvjwsyQFe0LnBKIaK/IesHg/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d67a9eff-be59-4852-a343-08dd8c4e3635
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 03:29:30.3009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nq2oCpo+6SEgIHTWTM+QyqYZrsS76vgX8fkX1Nw6XjP6HiilGgn40c7KRk9o1CHNtyR5w9Y0Bw1+Wg3TRXVQeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9086
X-OriginatorOrg: intel.com

On Thu, May 01, 2025 at 07:24:25AM -0700, Chang S. Bae wrote:
>On 4/10/2025 12:24 AM, Chao Gao wrote:
>> 
>> +struct vcpu_fpu_config guest_default_cfg __ro_after_init;
>
>I just noticed that the patch set is missing the initialization of
>guest_default_cfg.size = size (or legacy_size) in the following functions:
>
>   fpu__init_system_xstate_size_legacy()
>   fpu__init_disable_system_xstate()
>
>Without that, it looks buggy when XSAVE is either unavailable or disabled.

Good catch. Will fix them.

