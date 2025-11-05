Return-Path: <kvm+bounces-62037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 30075C33BA4
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 03:04:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8963918C3E80
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 02:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A59622157B;
	Wed,  5 Nov 2025 02:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nBrdKKpM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8E2EACE;
	Wed,  5 Nov 2025 02:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762308256; cv=fail; b=UqDwYaGLC3C8Z0ZqZOHuqTT68odOCUfraOQJ45mhZoQkzlCGLeGTPhyfD0dQyEgPd1sBWa7CZb4rriZcPnMpWCzwyfh6Ev1ZsyS5Ue1qUhFqjafhi3ObgXE/yCrFd3Vg4xSQTO8cZnl61wdrzqrmD6e4An5RK3dusuHw/nCv9SU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762308256; c=relaxed/simple;
	bh=CKlMmlw5zfYjDSLz9GaHILLe1r2ol42M65xaGGjFC7U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SxJO1y5znrrPAzONOkd+qqOHGptKPnwTVuIoN5iG/4H1vjndW3/FHFJTXEIwxrHxBjBl3c8odDvQCkT/7gWB8K885mm1c2duEVXa3F1e1jddt8cnP4rOXfz6Rnnt4o3HfkVb1FNSYidopfIIK9xtq2jM8LZs/0xSZCXgmxWCLCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nBrdKKpM; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762308255; x=1793844255;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=CKlMmlw5zfYjDSLz9GaHILLe1r2ol42M65xaGGjFC7U=;
  b=nBrdKKpMUak/VONADri8JqJlwBmlTOtvpIgQeKfAHGyhCcX9G7OfMKpD
   JnIyoZ7A/fPqMMxwsT/TXwMBZ1lteJkAjGx2a2CVUW0OihCPdcwaA/YsJ
   aRsQ3fB6Dis8+GQPW0xTd2cssXhVdG8pVThCS+m8bxhfwQpRUXVyZm+qK
   ryYOG15/9F1QMYZegOLvIzquBqt+Drd1GNryJzdQde6mn7FHhKIgxxTvI
   k59uA/LkUe4BrQryStCB9NlRgItJYI/OAQUzxBTAgNvfQP1oD0byku1DP
   O9RjsfE6t2VbJkdIG97pJyH3UQefxaJh8YwhGJ2nWRKigIahlFveic/Sb
   A==;
X-CSE-ConnectionGUID: 6i5uD5n5S7OXrE+rLsdSBw==
X-CSE-MsgGUID: /9pHQEfjT9KR4/jyaBB1BQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="67031013"
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="67031013"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 18:04:12 -0800
X-CSE-ConnectionGUID: UO+bN20MTuSoUr851LWvMw==
X-CSE-MsgGUID: UdkpQXUqR36qA3jXhzNXLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="217965944"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 18:04:12 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 18:04:11 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 4 Nov 2025 18:04:11 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.40) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 18:04:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l1LEdOMRVa/kPT9UmF4q8t0kOkTWwIYSgknrxOru6TLhBj4kN5Roxvqg+0ErFL0WBNHTFmpHp0XRBJqO+XM19ew6e2VLc+HhNHDxFTJaVJiPe4XCrL2NIbe8ag5nwNpRgKFDYx9fTHUAelujsBq43AgkqtOb/DtFl28hvnSzyqWapF7bZLsW6dY1nXZrf8i6OxZ66v1d6RykYhvSv07C8O6b4Xf9FRMdV4eRTZOzIK3aYBpJALcHRUdUjP506RwrL+Exur0RLvavaXJgwqvAVi8srYJ9nXJZ1vkL/btg/Xx2xIKzB+VMdAYs9QftUmCazqqOUX4sk5tFR/rhmJ79Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EI0E18hH5aUkf+mcjw2w3NcH3q1QnaXAoFeN2E/q95A=;
 b=IM1jLgMFi7ZUMIruSYNmClEiPvoJm+2AaBiC0Klv0YkStiSMuKOc1JzZCehVey4+l7ccF6+bWmoSz5gN+yPrcgAWz+CG9xrbFHpvPwA6uct8gjlhr93+XpfyTEkWLjypTKovwwIK5hauI+7t+Y4B+KmeUUGFbExhREQwnVY7Zwa+q2zO5r6pEJcUHpoOKdAq+SDmLD6IlODlFCPjvUwaPtsnCpTL9f9XWPVlCW6NxVG3lk8uREviUK7hRMKuxIRi6F+FjjkSWJrRp9W6C3W2wsMiJPyS6yXI+ipUl2/66cjXbgf1C+gpCE/Fk5ZpYrB2zMhPJ8pD7jfAQSUWS+iRhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL1PR11MB5256.namprd11.prod.outlook.com (2603:10b6:208:30a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Wed, 5 Nov
 2025 02:04:08 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9275.015; Wed, 5 Nov 2025
 02:04:08 +0000
Date: Wed, 5 Nov 2025 10:02:40 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Use "gpa" and "gva" for local variable
 names in pre-fault test
Message-ID: <aQqwQGleh1U8UP7y@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251007224515.374516-1-seanjc@google.com>
 <176227807716.3935194.18291135386554722106.b4-ty@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <176227807716.3935194.18291135386554722106.b4-ty@google.com>
X-ClientProxiedBy: PS2PR01CA0062.apcprd01.prod.exchangelabs.com
 (2603:1096:300:57::26) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL1PR11MB5256:EE_
X-MS-Office365-Filtering-Correlation-Id: bdf03d2a-a951-437e-5577-08de1c0f9aa6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DYwrMV9fQuPGOqfWLM36N+XQVCxspU/58Sw0xuF0VpQfVy/PW5qsTM+6K1kU?=
 =?us-ascii?Q?HQ3ac40Cp24lA9nnTAQeAMl4Pf0wISaTcZ2vn66Em4//3N7xdwa3pANmWA8Y?=
 =?us-ascii?Q?nvyn388RV5lZMjEu+aSrDOwGwRxTlQ+MEK3Q3wZ11vBAIgEALNe5zj3KTW7P?=
 =?us-ascii?Q?fZ6Tp4YKIiYL5Wz37CS/JpFAMOPthQbR8wxuZNb7UsxJdJxODCDrXPMktxeN?=
 =?us-ascii?Q?WpTTHZWRePx2zUPP8hiqaW8/lw9fhC9W74lL+aQvMEgD8L3UB8QeQCCBJywK?=
 =?us-ascii?Q?kJrKLIxusB2YE4/tJEhC+iUFDgjCCt5XbJAMBRxbVOkeaV6Nt8YVAEQOxaGU?=
 =?us-ascii?Q?s3lFVnnhBEUL88VcJj8tAl47bijUu2md2otnVnOeCzWlgv+j9nfJOGeS7Eyw?=
 =?us-ascii?Q?7plXF4DlScfGJROBnSTXtCooFXnHaCKhOmMeh9pG1NLvZLsdB9mn+BHZLC6K?=
 =?us-ascii?Q?Be8MZh0FiiGjFoV1lJuuSDoV6wS39czcQuIBwSj+hOEy6pyrxGBLYC+VgDx4?=
 =?us-ascii?Q?KcRIvvGHYyb9HcSTJqbULn7V5l5X8Y3tVit3b93P0bXo0N/HLt5nVlXNXXPr?=
 =?us-ascii?Q?aLb5bV/fmKBg704zhOtS/YJutvFnj+ofm0afrMy1dvaZJj91TtsB1d62n/51?=
 =?us-ascii?Q?tNcUeokjT6ZZX4KQ2XC7zjmd/xoL0z5t6JhGzO/Mkcf8trw3qoC99TNPlvSD?=
 =?us-ascii?Q?kSyTZDXKTELKcuCWBVHuQ77ftM6qTvixtq6Lw64jEv6pmrnqKVFHh2Lv4aDK?=
 =?us-ascii?Q?px3epy4539xiAiubXOhx462ThZD0gwyUUG9cMddg9RADqPFd8D6FScYx8RA7?=
 =?us-ascii?Q?7LYBEPjD09dG83UOsjjWqNlYMNlAJgsoG2yNr35zIuPutIPQVy/cny0aRg/B?=
 =?us-ascii?Q?Ww8zLyMNu0+qIMsoAjZ9jROfPosCeTM7ncNLVj3pD0tfK49gz5vcE5AnPxLA?=
 =?us-ascii?Q?s8vxFCSlq1WwTjKhAP2SqFXCLruaX/eI7/fIinGWXyAKbstxuc1Q4fcDxeNf?=
 =?us-ascii?Q?wqhjet+Q3rf0UlRP6Rzvkr8+orWT8fJpj1SmNsEXv+PEfYY/A0T7F7MeKi9M?=
 =?us-ascii?Q?KtyPCZ+rLljpKb1fTxvwqarRsVAQ3FzDJPdCYK40/eAK8WcMUs0F6iMlV1Tv?=
 =?us-ascii?Q?A1IDauLd/MSsjCmsbIVCdiTaAt0E/wCkCbfLAshTfbFz0+244Dd1MoOC5qty?=
 =?us-ascii?Q?1vERz5wU/9OLX8lfxHlPoMLypiLIMRMPAcq1ZpFFVBeZOHh9y3Q5rBqfU+uf?=
 =?us-ascii?Q?KgjycijIxZxuKgzigKAYizgf5xdYWnQBUYqhwLifKIgbK6SjnY3NLkQKy3Yi?=
 =?us-ascii?Q?bc2k+MNnBr5yIf3bIgJ8sB3G4Umol2anvqmzSFXdcLBL2s+P1GbeTbAzqFwR?=
 =?us-ascii?Q?W+MHmUH3Q5YpDOj9/4rp9hYNxazeDGbuk1jXQ6rr6Cq3TCfyPtrhc39XA8BG?=
 =?us-ascii?Q?oBbFip2bj6IvqTMprbzlqMMwIOnh/AqKrgdYU2k0crFtZKqhZUqYxw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cKa2iL1HYm3Bi03/9m2/mRG5dQz5qLVJtrx9IrCROSGmL5eONR8W6bWPP/A4?=
 =?us-ascii?Q?4809UFjBZQWGglFZt1wRnkvY8KuUx7lrtTgjX41ZjKgELadswbm7fAIYlSg2?=
 =?us-ascii?Q?zvLjAFfPRCOZWehZrouxxftQZFSArIuVhHMeJCrJazG3zLIBXjIs95Eurg/d?=
 =?us-ascii?Q?SLR0PJrJyzUCy0mWozlvy+74k+Qev2BGDXoVi/ez82drVbpGfiOmBKf0A4WZ?=
 =?us-ascii?Q?1fl1mqBIEeZ7cAFvXj9mlUhgs3ue49legeSqWkGmg5otMjFgF3wxQsGoNyx5?=
 =?us-ascii?Q?9a6TPfv8GSC+Z2JxNYUU9/OVeh+fqA22kuy/4kQtZP2oykm5z3qAd1PsZ6Lx?=
 =?us-ascii?Q?d1qFT+YsIju6H8X6YluuLljN3K/+iOkyr9vffM9N8aW5SoQcyQmibw4ZM0Zm?=
 =?us-ascii?Q?eGYqZEYunlXGHKeCCuRlcj19UFzYfmCSFhYDnmhpcAtJ5TUqQzV9c/tpszKo?=
 =?us-ascii?Q?gqh3INKYYObCiB/hWuHMEwu4vEbZtnPw8EKj1jpYXyW6DxDu23lZjZH4sgHv?=
 =?us-ascii?Q?wGYCRo3c40ZgWKT+YYqPTjjCLouam3RIa8lo0m3pQknjtJ8z+ua+NeuuTwwT?=
 =?us-ascii?Q?a0TjQqqsgUJryc1nyCyyUIR+5eL//3NcirlI4MsPi4BqBSdMFcqzbHy7C+Dp?=
 =?us-ascii?Q?CDA7UQKaMUkaJol9xWqK/3kSivcZWd2fetpWm+gUOu4YfXyZKwahGGFk2V7x?=
 =?us-ascii?Q?DrviYJLkLGbSt2s8BHEVU0lzH5YKaI6ctljluzdHPt6M5GmEbtZaqggmt5me?=
 =?us-ascii?Q?FHK0hmtgq7/teEqwXZKO0R8KSqAJWlpaWjI4mv9eBeyMLYilGv25s1mIw0g8?=
 =?us-ascii?Q?iVEEVI/7T5+C4wsLClSGoHlrTDyGiiAZeufboLh/8iEbmEFUk78wqUPoiQq2?=
 =?us-ascii?Q?W4uEAFn9gHkwiRmAkZTafr3ovF6VghMOzFavqGjDRW9gSXugdZHvaUxyUt49?=
 =?us-ascii?Q?ljQ7SMQ85jNlQBERvXkWaJXUn49P6pItLsD+N/i2MAuWIEzMF6pCvPUkyeYb?=
 =?us-ascii?Q?/2HsYXsq2Uvd+on/n7ZQ23pZUw2BG2qLpfQqzreWYq8GSgyuln1w2wB0+Jlm?=
 =?us-ascii?Q?eM/3Z9kMNFXxUw94ggP1yjlpLX/Lo4CXbU8ptMJAUAFJfKL/uBl6e4DUlO81?=
 =?us-ascii?Q?jsf0IXnZby6gy8MgtuVO/LEnohRVW/Cq8yIcuZLUc2YV45QNbLgtObox13O1?=
 =?us-ascii?Q?8CdWwogQiSkwIsepy2nmQvEVBR09IuSVwMIFqaVyIBGqJvZZRV8dvWfrRp9t?=
 =?us-ascii?Q?8ORoxxIv8eQxGtmbY5CPMZwEPh3R4+m2h2DkEXEQeOGVC+le8mG1qdQP3/JW?=
 =?us-ascii?Q?fpYC9s6H8ImGYLqCZn9x/7j+MZuF0V+eMGvbdxE2aAJMPfVHA7kgNCJBM8G1?=
 =?us-ascii?Q?z4acPptupB0bh4yMLw1sRFc0JBEsGLRrDu3FI2i/9QufFjcuDzeh1mWRzICH?=
 =?us-ascii?Q?mfotJ4p0acyVwOXqf67sfUrOB1vOvGJr8KGn8WV3hfn98h9XX4fWlXzY1hSA?=
 =?us-ascii?Q?DaPT4NPGh35b8T51bfYW1WFBmhm5Yl1T5wGswWsYcN9QOJqy0CAVhUmqf22c?=
 =?us-ascii?Q?jZwmooJKmzH5AqgeyzcLxoMhNQSzzAcPLJ4v/Rpe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bdf03d2a-a951-437e-5577-08de1c0f9aa6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 02:04:07.9622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b+gsC5tNyij0yG8hKsj6we8jK2uObj8iBIlJom+YTnRxiF89DoabeWg8s0F//JHmmFWERePVbBvrKzkIdPpr+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5256
X-OriginatorOrg: intel.com

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Tue, Nov 04, 2025 at 09:45:14AM -0800, Sean Christopherson wrote:
> On Tue, 07 Oct 2025 15:45:15 -0700, Sean Christopherson wrote:
> > Rename guest_test_{phys,virt}_mem to g{p,v}a in the pre-fault memory test
> > to shorten line lengths and to use standard terminology.
> > 
> > No functional change intended.
> 
> Applied to kvm-x86 selftests, thanks!
> 
> [1/1] KVM: selftests: Use "gpa" and "gva" for local variable names in pre-fault test
>       https://github.com/kvm-x86/linux/commit/9e4ce7a89e0b
> 
> --
> https://github.com/kvm-x86/linux/tree/next

