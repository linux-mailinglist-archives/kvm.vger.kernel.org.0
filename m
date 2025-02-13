Return-Path: <kvm+bounces-38010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 57753A339D0
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 09:20:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DBBE188AF22
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 08:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F315220B802;
	Thu, 13 Feb 2025 08:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jsc/rsc7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A650013B29B;
	Thu, 13 Feb 2025 08:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739434829; cv=fail; b=uEfIjitV6GLr+4B1xLi/Zg+jJI/QWiCMz1c2p5zyj0kodQMsfErt1N74VhEMqwmnFyltRwuE7l/btnsLPRfmyst16qL2o4o8ard3Z2+gi/4X1k4jE1tv1HfRMuaya17cOS6s6t2iMvUSOAyvmoog7Xn9nIu7IbzGC/QiyEoOo6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739434829; c=relaxed/simple;
	bh=AwW2nK9AODqedgB4SgcMA7DiRs/UjnrhUbewxVn+nPA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l+nUSystIZJipXVUe6+m4nfGS0WR1F1625Ba6G3kpTXSWUZuQMK9kapcKxHlT8LBj2eizfuyHGRM4uVenMwrTQUeBKTjbKKSZtVMldMMi+umu6uvMVAiZdO5ZfLievx5dtWv18RMTP8EJbcFkPTRTgOBGDTjdl95NmTBn+JFl1k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jsc/rsc7; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739434828; x=1770970828;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=AwW2nK9AODqedgB4SgcMA7DiRs/UjnrhUbewxVn+nPA=;
  b=jsc/rsc7wD4ebhqgVbBqE/dRWMJKGnTuH94wxWgjUngN0IUy0TrMRGI2
   1aXdxzfTZeL47c/RPVtG2bMI5Rodj6JY0heR/hhHgwJbH/hPraRD96Lba
   JFO0da0qxZMFfMfwf55XhEnj5//b9jjh/0d5lNh1B6uGJe6V5zAQG6FzN
   PwPXCm0+n4IHvLJ14Tzydqoo8toiJFovl2J5vnN3Zxh1Uqg4J2na+4GNd
   rW9k+XAJ7H38vGQLQ9/nSsElWFzHtOFwhJxlHGJUTaBjGRRSW6RBWhsPz
   QUnoIWWVO3RiGZc9T6h+E9K2qHArGuv8roUwK1ytVmRKmyzLKd9uAUB1a
   w==;
X-CSE-ConnectionGUID: SwV+y8IgTaWq9hZ0clh3RQ==
X-CSE-MsgGUID: EDkHVuyaSzWlA7Z3QJArAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="51518838"
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="51518838"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 00:20:27 -0800
X-CSE-ConnectionGUID: bJnLEZCyRgaJQHwCYY8J/A==
X-CSE-MsgGUID: MN5H7W9XQ4Oasd1AO9gPsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118263252"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 00:20:28 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 13 Feb 2025 00:20:26 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 13 Feb 2025 00:20:26 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 13 Feb 2025 00:20:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yJzdSUznHbCp6uBMWH8uxfWdxDjYgWAPK4il2RYYFwlot/jEWK8AQqcfdAG8DVRm+8VmHnrXTWL0EeKUrGZgQNv0nD7bOcQYBemBplJysVPCHscLyCPIOdiQfV3xiM8h6Nd/scTyvjM1o08Gkmd3sPOXn1WL/FVgevT7+160p7hkyBZ3t5Q3FTbrOtyRExmwF3B9flDWguEhteANcNhX8H4oN9Bte28WFrMtDqDuv6wqHnI5AzTUVDXu81lUAI2Kb84of+XBXY6Ynd5rCfexfFUNxeadBy9UJj2M90jOoVQARGwE0M19FLfjFw8EEciEXw0EsS9dVMq1A+rfVcfHgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RzbAIzOehSEFNDuF91P2610cIPyp0YwwHuaoLk5OSQE=;
 b=U63dcHII9vrS8BDyNXnLIzaY3oJjj60ZeamFYAzEg2V+IOopOlKnuSO4QvJMaSo2aCD8QUIURt8lTIn/sYC4AqrcyAX/4YYXWZp6cuQ8eIHuL6aiLRTHwv1f5WpjKIqhUQa0P/9iwDdTAzmrmOkY7YI8aqiVt4U/LoLkY0ZgkzrAspEHrs5/FLaKqQ9GFF1cpNPUWp9qZC2FN5xxnUtbMXrXpRiG4mHJ+P6AyHLwKRUKcWXHQ0wvubKyII0o3W2KTKDQ+hEQazVUTxwK9ExdsmODyULjwKv2z9T4kHrDj6/zsy+kXcmCj+Jm2c+0XrGTLNQPAyCt7OC3g91Kg8+0tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB5246.namprd11.prod.outlook.com (2603:10b6:5:389::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.17; Thu, 13 Feb
 2025 08:20:25 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 08:20:24 +0000
Date: Thu, 13 Feb 2025 16:20:14 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 08/17] KVM: TDX: Complete interrupts after TD exit
Message-ID: <Z62rPgmS2RB/LaC7@intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
 <20250211025828.3072076-9-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250211025828.3072076-9-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR02CA0088.apcprd02.prod.outlook.com
 (2603:1096:4:90::28) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB5246:EE_
X-MS-Office365-Filtering-Correlation-Id: 926d2820-3cb6-4c22-848d-08dd4c074413
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?MQndrmPXsJOxECG0nrGtW5x6FmG8LiOQhNm7fGHLxW+4SR+VZ0RH1R36ymwv?=
 =?us-ascii?Q?qc3GdjU+o2ofzk8QXlex9tO6gUjzRPiTpfnW5N0c86eOX0Z7bC4o3DYL/3ZW?=
 =?us-ascii?Q?BNKPdYBz+4YpoTPZQTi/Ah1UO8y1swSFQQ+SMDAVF1Iv97pk+xB1KnUen/aB?=
 =?us-ascii?Q?6e9h42ES/sqGmc/wmKailHcp0pzVsY2R2xlGrtRQ5uoHgTIDgJCQGV4GJ2jB?=
 =?us-ascii?Q?i3GCPjAiDb61T9a5CHjnqBBBqekMIARK9xkgYTr3RtIMFvXf9tkTATanGmgA?=
 =?us-ascii?Q?CGm6+MlfGH8CYi1ttaPMuyZC7ILTuLeucr6ZEDkE2+KDZOJpYFeXlkJ14snm?=
 =?us-ascii?Q?wttZuqQgGjDmkki86GwN7LSzRRBj5gv7xAgpgWoB2OkW4GlwpYqJhW/I9S3Q?=
 =?us-ascii?Q?ACg5S7oz872Y9O/wASN1j++UL2iiv7hO7wrgf7GCkYRQDsl0Xy70Pi7oKJ3K?=
 =?us-ascii?Q?/kf9/l01sz+q+EBLNXXtJaPYHn7HeTNNdQmegzTAiwOyyS1EydjAz156cEjH?=
 =?us-ascii?Q?TRpXzzkMPTA4Eqef8egUg+LBQw5D9+9UbeIDpViZXPfXDQPuvRXZFVWPthO2?=
 =?us-ascii?Q?+84ZiNbh8mk5EV4VqGOaApiFEZCAZicA0q4RYam2cuA68bhe86J8jqmAw6/x?=
 =?us-ascii?Q?U5Jnu+tRlWRPMI9eYcZstYlrSAGmhMA99nJo+mkS+2q00vn8hQMqyqLvA7dz?=
 =?us-ascii?Q?U8scLNjkhbYjgISA6A+aqxTEHhRccAmGNIz8JaOP3wRYlSPohCQG6KQ/+yx7?=
 =?us-ascii?Q?5J2GD8zy5DSMulKJJjUasjAO+PiJ1e4xskwso74EVl7e0JkIdMsJ/JIX6J+8?=
 =?us-ascii?Q?85lhaiORJ9vfQ3gjJzY7UrCSNBxSc7fqGkbmpfTGsKXrO5VWRWBljeYk2rie?=
 =?us-ascii?Q?RrejTein/JCHf48nAy9uYt6dQfupB/r8OxT4+gTo+R0H0i2fVfMleV52vttx?=
 =?us-ascii?Q?+rtUwtH0s1otX9Vgt+sV18/bpvyoSfW8bkZOwrUnmZiS9uNR+i8MNPxGejZS?=
 =?us-ascii?Q?NUaNaxfWSebSQ9ozW5PsWpW+kvzsX3v2oI/dHqHAvE/UxqO9UfoycTXkiDeC?=
 =?us-ascii?Q?pZyAHed/c8WQ3AwjlimcOezszmBOUn3N8nsci6DAmdsY3egGERUrAahMdUlL?=
 =?us-ascii?Q?XfAb9tz4pIyBqmFUKNXLk5cdcWXmuLUh8mAwquXzP4qt6CjebhHaf+Nn8Knm?=
 =?us-ascii?Q?hfEVty5Nm6rZjyKuPFvWdbozx5bLrYam5qbQ/8DwoarofUIqAU5L2URsJBml?=
 =?us-ascii?Q?rGz60V6JCdEjaut5XBAgnIPCATSkoJFJTsKScJj6xxoHQvQKsNmoiuXQF2IE?=
 =?us-ascii?Q?CV+3sfRyaTKzcmeFFzV/8Drjep1yxfvJF8fO8D8lMDF8mz6qm31v7JRQ+fze?=
 =?us-ascii?Q?gWwnhXa9bS++jO3RyTWWbfO3z4+C?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C+Jv1BtOq9KzbTNYn34fDXJMuFqOhB4v937PVINDFRvgemcEdksr+SYt5Kcz?=
 =?us-ascii?Q?DUM4DtyycBC094Lsl3zOzArFOhsimNtlPbLkYacf9NzrNbzwifl1spxTPAP3?=
 =?us-ascii?Q?0J7G1FfUyIjQ9ErAsu0hnWt2BQOcp3nnZI/URoout0EGxExbFUuYD2g/VaX8?=
 =?us-ascii?Q?ORB0+EZCJ6Ang/QEb96CGns4eF7IJqcqilJqTzKhPelie4q9/YXXB5S32iY4?=
 =?us-ascii?Q?yOcluhj9cVbtL82iq8ipPgziNIvrV9bGHqWbE/z7tlnKKuNVq+yVp/pcpLca?=
 =?us-ascii?Q?9qkrcMWXB6CQsHuJW+qNGm0OII1LrFU7YE4OYpm+3Da0VlP8oRgOctORmazT?=
 =?us-ascii?Q?XEiXJbuNIt2/pTY7Wr4Nu+UuvBDo7uCM6eN7H6/Gb784nr+DwO5bwRexxIXs?=
 =?us-ascii?Q?7G8/tXOnO3j1aVN6Xj1n2om8Hnqf+/xdxYxoii56om4CK8rWwiy3qOJ6Rgbd?=
 =?us-ascii?Q?w/2zN6SpAty1jrYjcFEjmhmRjvujYoqM449k8eAkPHvEuECGnJ0WOtJV528U?=
 =?us-ascii?Q?d1xMesWgHB2rfojMXl0AClImSavoMb1dbyYt2H5GPxfEUtEg4Kg9JLHZC1uU?=
 =?us-ascii?Q?GPsrXGDrVApqtvt9oLHA4wtXkdjsoqG4mxOXEQPAJKfRzuKBX/elVDwuhaGD?=
 =?us-ascii?Q?hS5O/HOafs77ZS95gyBy0biWR3apKl/litLA2FZjOJuafR9r5GSA14StLc05?=
 =?us-ascii?Q?OhUc37/viRtda3l/dVZBzDYb29vFlGHZVu8WUPgSyDQKl3A8NQL3Ph08Q3PR?=
 =?us-ascii?Q?gSstWF3TBg9XH9M6dr04pe2e0qLduCjT1iT1KTrulbFnD6l70YGbNL1rzQ8q?=
 =?us-ascii?Q?T+dv60U/ZSDmkcmrefWDwV+9pEsVNMqGe3LTm+yJ9xDzgzNNfHAoakJ7ToaI?=
 =?us-ascii?Q?fkjePJ/wGf+zufLCOHpP74lj4uW4INS/9cGlZDmFpWeQie1LiKXN1CcrePSY?=
 =?us-ascii?Q?lRp5RBIA1bfJkb6A0xBVqyJc6D1k14fUPP8U7tca/NyNE8LWbYeP3uU+EpLo?=
 =?us-ascii?Q?gs2NQdrAnaqUHExMN3jK93jyYXTNZI0n0uKbF6rG2ahB0ZBYl6FablJONgzx?=
 =?us-ascii?Q?Sc6BpWoteVNjlIeMv4HtAeQVOHR5conChzO6iFVZU0ULzorYtmHYX3+4DbOs?=
 =?us-ascii?Q?h+mlO7O2b4ljTSw+aCsYja3kTndY5t304jHcc1XbdIlRjwcBshdqic3qamN4?=
 =?us-ascii?Q?NPl9cthIfACWMCpdctM3aU1aE01Oky8bzMI5PTOXZHRWij3IYHwGz9LtN7z3?=
 =?us-ascii?Q?Q5YKGgb9A99+7waWfTmBEiC1UVTUHEdG2fjhCzDiA0KIEOW1fH7Wn12z8yud?=
 =?us-ascii?Q?t5wxc2bodLZ5dkoyeSU27niNbc1mFyyhpM/E327g7+rSMpG4PqsIqREJg99+?=
 =?us-ascii?Q?MmwintTiDsX4nLa+Vs0KaHmVBqZim3ASw0Ro/HZkTVz+LCJ1m3iKqIP7Mjdv?=
 =?us-ascii?Q?8+O5p8HrhD0MTt0Mqswb/+Q6yIt4bXBaCqreEzBiNX6vpquACNQvT+rymxDd?=
 =?us-ascii?Q?gdufTFpLluKmnMjcs9RAgmNMgfutS1t0jus0Vy8S0I9dbkQJ32gCDzdj+nih?=
 =?us-ascii?Q?l1OBtTsOJfVrPoMYujXpUMlaxxajzSerHB3j1e39?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 926d2820-3cb6-4c22-848d-08dd4c074413
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 08:20:24.8408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wULj02YWfN6qLpPCZKMhGUI/7C3nk2NWgMTv7Gx/wIohQJfdbF3BcCqWt8UY9rI23lPJZfynsEslTkZtWNVUWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5246
X-OriginatorOrg: intel.com

>+static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
>+{
>+	/* Avoid costly SEAMCALL if no NMI was injected. */
>+	if (vcpu->arch.nmi_injected) {
>+		/*
>+		 * No need to request KVM_REQ_EVENT because PEND_NMI is still
>+		 * set if NMI re-injection needed.  No other event types need
>+		 * to be handled because TDX doesn't support injection of
>+		 * exception, SMI or interrupt (via event injection).
>+		 */
>+		vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
>+							      TD_VCPU_PEND_NMI);
>+	}

Why does KVM care whether/when an NMI is injected by the TDX module?

I think we can simply set nmi_injected to false unconditionally here, or even in
tdx_inject_nmi(). From KVM's perspective, NMI injection is complete right after
writing to PEND_NMI. It is the TDX module that should inject the NMI at the
right time and do the re-injection.


>+}
>+

