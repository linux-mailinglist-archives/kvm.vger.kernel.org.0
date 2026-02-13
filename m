Return-Path: <kvm+bounces-71070-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sM3MAElZj2lxQgEAu9opvQ
	(envelope-from <kvm+bounces-71070-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 18:03:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B3526138752
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 18:03:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9C0373047DCA
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 17:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A90432B98D;
	Fri, 13 Feb 2026 17:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i8QwRXtY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7D7286A9;
	Fri, 13 Feb 2026 17:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771002161; cv=fail; b=NWIji40+64KlMvc3EVxiVtMuRj1TI7I4KaLIulSKCJdXVPZLhC2oHhuikr2c1H3mCxHsyC7yV2uFCQlSPZzA5IxI4XtC+F+fgi8DbuwutWRfeZINCeODEL8UBHwYLTdvl3TY9uW/vUy1lSMqqx4lMOt5eFSn6+p0Nhb+s+nKnos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771002161; c=relaxed/simple;
	bh=DP+aSwx0kufKUS4+mIaDxdigF/Yse5a5yuQESmSJXk4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ox4cpNd76GVQ/AQrC9ja+n9nnj82NN8nlPtW6tMrAespH5EK1sTADsfUptR46Yf7Cjds3JTqH9NCDNAfbZxQi6JwYQ3oNPsmYC5yCwKt+BaLulonRFaNemCocROGjddREiNy5bCJVjfrWt9HlnjzuNIW/ggPPggo5tv2apJJOgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i8QwRXtY; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771002161; x=1802538161;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DP+aSwx0kufKUS4+mIaDxdigF/Yse5a5yuQESmSJXk4=;
  b=i8QwRXtYA8gZwzyPJzJjoxjFHnKJVFoRq/gqBNtc40NvbykMCeM14lcv
   krDYQn3pO9umA8iNvLiBxMsrdmD/+HLxZKthhvY1yIllVnvod8m0jhcx7
   +IqPC01JWrujdskdaaS3QhaXNoGDSb+zi8ARmuzUuHqU0NJALoQG5FOnJ
   Wo5syAR9IFG/lnP53TA7GC3f+5lg56DajHOE9QbUXgNdCmZo3jlVR00Xw
   cIpHAExE+HYaN9crPma2U+r9clJW5R8d4EtsIk+gnqe/ft2BhocKKVc4p
   DeLPhH6aWbH4n2S9LggV6BvGuAnfLzFoLzohTgpMqcc27AHuLqE5t+x+Z
   g==;
X-CSE-ConnectionGUID: 5ga+NoL0R+q5wQtvD0WVzw==
X-CSE-MsgGUID: JGNGXlvoQeWog2a8TDRI+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11700"; a="72084006"
X-IronPort-AV: E=Sophos;i="6.21,288,1763452800"; 
   d="scan'208";a="72084006"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 09:02:39 -0800
X-CSE-ConnectionGUID: 37fb9lqbRiGRrWEz+KcvmQ==
X-CSE-MsgGUID: u9GtqgLlQAGUX+ttEkguFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,288,1763452800"; 
   d="scan'208";a="213072636"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 09:02:38 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 13 Feb 2026 09:02:34 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 13 Feb 2026 09:02:34 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.53) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 13 Feb 2026 09:02:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w0cDfCRZnSbpUU4v9qy0Fu786ogNDYHQzzzNqp1NQxc7Maoz3vl0LoWWBf0QdnkNPwtF5B5ESIFi94eXqTUAeC5dcj7MEVnywfEvE/o108laW07lYl7kJAjAJG9CxEsAmtP4xH9EpX0CRre4TPnFpFOQtxfkBgsLteKJ3BSuqf6Lt1Za7DLwRd1Hph7NqViVz75cQW86m1Vb59L6XjkQut2Yke/IEXmwjI2Cg6N+pimGbELBCMzSWs0RciUrEdXdZvPI4y+VielTvS94NbFcOsG4SYxBXyaOB0qd6SZRwKMdDfmiUzg4Bfjasu9eGD/4my04SdRV9jqnAC96qcXFow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0iMbxYee5mvcvM4q6+HifhBElByjgHWtuSFNcwHQUU=;
 b=gQmaC/ICzPbcsQ8ik2o25Ttq7GbkcJU5YXc1zelmrlHVBBQqvgkm/IxmK6gAr6066YZ/gFcYNTMmIKYuzqDZTVKJuRWqdiTVx/8ma8TBTjXFj/ykfhUxkpUFIsp7lN9sr48dTcPSMyORA8Xok48+j4sAbDs1tVZ/DBL4MWRd93hCamaZVSvAvXouczj5/kv81rwAvyTqgU9p7A2iCTE9hl7W+g0+jYhptT2medovoilt1KDJBxT/ln110zanARcw+JrsVBgMG38gs3PBQAkbyRcxnO4Z2MbT63w1BxnZD9+CH/tErYz2dwthxSHvnxbYG53Ox7PbeE0eQSK1+ZScVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM4PR11MB6120.namprd11.prod.outlook.com (2603:10b6:8:af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Fri, 13 Feb
 2026 17:02:25 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9611.012; Fri, 13 Feb 2026
 17:02:25 +0000
Date: Fri, 13 Feb 2026 09:02:23 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: "Moger, Babu" <bmoger@amd.com>
CC: Reinette Chatre <reinette.chatre@intel.com>, "Moger, Babu"
	<Babu.Moger@amd.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"Dave.Martin@arm.com" <Dave.Martin@arm.com>, "james.morse@arm.com"
	<james.morse@arm.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "bsegall@google.com" <bsegall@google.com>,
	"mgorman@suse.de" <mgorman@suse.de>, "vschneid@redhat.com"
	<vschneid@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "pmladek@suse.com" <pmladek@suse.com>,
	"feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
	"kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"fvdl@google.com" <fvdl@google.com>, "lirongqing@baidu.com"
	<lirongqing@baidu.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
	"Shukla, Manali" <Manali.Shukla@amd.com>, "dapeng1.mi@linux.intel.com"
	<dapeng1.mi@linux.intel.com>, "chang.seok.bae@intel.com"
	<chang.seok.bae@intel.com>, "Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"naveen@kernel.org" <naveen@kernel.org>, "elena.reshetova@intel.com"
	<elena.reshetova@intel.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "eranian@google.com" <eranian@google.com>, "Shenoy,
 Gautham Ranjal" <gautham.shenoy@amd.com>
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
Message-ID: <aY9ZH9YXAfnIKTL-@agluck-desk3>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <abb049fa-3a3d-4601-9ae3-61eeb7fd8fcf@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <abb049fa-3a3d-4601-9ae3-61eeb7fd8fcf@amd.com>
X-ClientProxiedBy: BYAPR02CA0067.namprd02.prod.outlook.com
 (2603:10b6:a03:54::44) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DM4PR11MB6120:EE_
X-MS-Office365-Filtering-Correlation-Id: 92067b3a-49b1-4058-f476-08de6b21a947
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LY/KvDD92s55S1LGilFtGFJJ4Ii5AUBV8TcgxafBuj7jcDvQgfO79Jgf+Q1e?=
 =?us-ascii?Q?4/Wlgh77gNcz4+9EGY5b04URhysTWYNjYTOykm+8iMMplbmEF+o27RdStbz2?=
 =?us-ascii?Q?NO3Bqd0+EmxFUcTHD87kgWnYsSm3KAzjKAhmerAxP74WE47oHjIjougbZt04?=
 =?us-ascii?Q?K9s+VqcDHZw5ZhMYtw2QA5DmDiWsle2tFe+Brfx7s8HUxUp89PXEhZLKI3tk?=
 =?us-ascii?Q?RiBLi0diZ568aT7MXlBI74srprel+aR7LxFaKmG6Lvx3/gfTOcGwABuZYpbS?=
 =?us-ascii?Q?Caq0TPeM9jKpVq2+whoxeYodBUhzyaPjC3HLtaL0HgkpfDvhnMGXAuq9axfT?=
 =?us-ascii?Q?LU/IMHTdx826QVeFpm6yb+1cV0DCMPjdT7RNsyG6z2uC3c8Ev7jeaChweUNy?=
 =?us-ascii?Q?xnEQAQ/6OCYfWtLLmi3mGAftdZfIRuy4LEVybA70NjJ6a+Li//UZudHXHlVn?=
 =?us-ascii?Q?kVsGR6M4jKstTXQfhavGFIbrIENK4CSCb2Ux607f+5MUVVFas8e29WbcnaA/?=
 =?us-ascii?Q?o2VI/RQye5GmKfG6AgvbIyxuDV9k6yX/Bs63xtOdtwMPeQ/wrqkBBcmd3ec5?=
 =?us-ascii?Q?Gc2LkRE9egRhQctIgqIs+OL6KI/1nphsfIxac1IzsJLOn6UgXtWlmZmIQC6i?=
 =?us-ascii?Q?46LiXCDjqW4JrebFFehdteOE/9mjUf2w3d7lDl3ekW9S0hA6J4SLhuQdI54I?=
 =?us-ascii?Q?xeFxKGobRDUx3hGkKlxACzsabinZurGLRaZs8y8AUMX1dQohvkVJKduWwLrd?=
 =?us-ascii?Q?KNndirDlj1lU+XUq5CREfluFMP5v5faDESIGAZansZl4XNVBBL4e0YDIsTvd?=
 =?us-ascii?Q?On4FEjs1gBcmYcknOiDZOaMaTjQQ/bQJ0qpNkQYP72Y5mJTFF18mnEwOybEJ?=
 =?us-ascii?Q?8mOSHzkujcDj6JPDNO5E6tCyFijYDrz6JPQBpsl0VAkpwJvIZeiPS0evCdq0?=
 =?us-ascii?Q?Ekhgnq68NvDWJRghdzRQsaQCeJgrAU+nWYpaCotYgayNERyX/pcGF1HWJVTg?=
 =?us-ascii?Q?lVr2zIMxBmdewg7hyYlFrIpc5krhlYMqtrGdzmwk44TyRtyX0OBwaGRU9/A0?=
 =?us-ascii?Q?6H3nSQsrSfMEEjqztXZvJadvYbY5Kw/6YDq+xgb1iJ9E2aJZbWPk28c6vPb4?=
 =?us-ascii?Q?XEkGEnBkuPMwKQq5ttttzaC2NnY2zR1D3B+X7xvxPBMGq/NGf9uAHhCtYLeJ?=
 =?us-ascii?Q?PfAMcn6myygPI0s2OT3fdUwtnRiHb4kadQq+Us33Nl0x3sYwfBTZBw8U7HwK?=
 =?us-ascii?Q?BaExDZU+ki9xuVGw2lyNQA2Ag1imUC0NkUAB24A0AQ1Ogd+lNzfMELXfOmkC?=
 =?us-ascii?Q?S6WznT3tGXC7xTQlskZI5pz5Zf0nVIB45iVhj3A+UpCLPUk0SOuGk9zFXjL3?=
 =?us-ascii?Q?X5tf3abbAkjk0jCat52hrc6Jz/3mWadYbEgjYgWtlibRk2dxlnn95Rkj7PdE?=
 =?us-ascii?Q?LTNHZVTMISkll0T92N0Xgew6h7WIZRYQN3DJo2NEXD/PFpKwIEVzYKAFlODa?=
 =?us-ascii?Q?avwC39O/TSvvAl84Hf6lyJQeolfo23GD4ruSZeOzW7rLKjFnq3P3u/69NPAf?=
 =?us-ascii?Q?NxJ8vd4y10FcVfXjqPQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3NptQ4jFCDyLYargh8WqTZkIQw3MTJ4hVHCvdeF4834aQ9/mylkdILJqpjp7?=
 =?us-ascii?Q?vST79JI0INoKAPnfblEMuMecbVDmVbfvLChEiLyQAYY24Yym7b+Yqu6IXAWr?=
 =?us-ascii?Q?h8jFRZz4Zr/0mlqlhT+ST1Wfxr/VyRJEaQRZ2/OtH/d349Pdhrdw0PJMNahu?=
 =?us-ascii?Q?0TjpSnLe7CGgQAhdVQOLlrZX8CFmlLtna42cT5bLyyqKNYAvfr/tJb8nyit6?=
 =?us-ascii?Q?eYpZn+romlElxB/gNaiwrp56mFFwu4bDCYiMlgIWwLONBmGot5Zt2ra1yoMk?=
 =?us-ascii?Q?oPNYPey7CI82sehomXpPSy2cdWK/QEl4PvlVrWfvu/eeeAYA06hqAAyN/2dZ?=
 =?us-ascii?Q?wjLlJ8EDxZWDPtomCr3nugHvEeY6wbehhMt5HfNu8SMikbKEYJr8h1bNhGop?=
 =?us-ascii?Q?ptqd3FdN02ssvW/LqL/BOdh6MGbwowv4SDw9Y9K0WVzUgopMnPtxeskKrJsB?=
 =?us-ascii?Q?MYLlYMwy9kIRrF+StE/zFjlhzFfOZq0jXFo6cypQp/91ssrjGq2UmdwTSaWS?=
 =?us-ascii?Q?+6l4ttmWFraUlSJ1hII1hdUxhRT6JZlmFjsP3iJiPd9K23yrdYk5gdO576Kc?=
 =?us-ascii?Q?33zSij1fhOrCk8jqAymmK0PxpKobtGXD7QF9E6z1sUHmcBNV8YD4Q4yiZrMb?=
 =?us-ascii?Q?04k5iSeuK8wPdPhO9qxVboZFzI8xcDfirRa3iXA09kaRDTq9R/xUWCNdNTQ6?=
 =?us-ascii?Q?kQ2kH+zIyDEig+kqr59GuZayuJ2EHnnvzhowDgDqYt0CiyPtcjVgttM4yw50?=
 =?us-ascii?Q?Bgy1PzS0lhDqlWGZdO8DJJslXVg0aMkSj3QITmRMQTBqmYCxfuAOgxGnLYcQ?=
 =?us-ascii?Q?XVOhXeLJTTAjZZ7ie+3lqegocBWctnhRA3x5Xp6vwTM4mKZdj/CpJSyRgkKc?=
 =?us-ascii?Q?YVcS9HOe8MmZ1PcynK8mVY9mFARisGipTMuV3Pc4DmNF5sWvDFoNiwupw8KM?=
 =?us-ascii?Q?eUsN+vVxaWXgw6fm3Vh6T8rUFY5JB6+sM4agKFmamYSEzzyTn1SywMAChurJ?=
 =?us-ascii?Q?MAUl8cx0ITCbZdTzlbsnQ8bOwzQQ27yvZPhAnoYtrIr/nXb6ta07PK5cABF0?=
 =?us-ascii?Q?4hGgCOhO6V9Py2dHRbLDVbWO6Thr552GwnDcPno8JBF1nSQpS1z6z+jz3DHv?=
 =?us-ascii?Q?d73Y0/KF1LOV6sk6L8M8kZgSc9iyGVJu/sGcS3TE/pDopdv04eI/3XShW06c?=
 =?us-ascii?Q?cJewWd47oOa6Qhs2/MT2IZBr7YrOG7RZ+/Kr8Hd3dknrY60r/E0i0+mHNktd?=
 =?us-ascii?Q?CgXiYGmJ5+jIr++WRDQ8aswalHuNQyOc4bNhSXDR4d72L23y+kl3uFE0PG8G?=
 =?us-ascii?Q?/tEMFImZMfwKrGG5goKB5SLuJ96xu4/fXPFSIx2RcSqc1EixiSJEo+IGUTmb?=
 =?us-ascii?Q?kK5OWP3FNdh7UDxATS+Hrx3zDD8RPpVDkgPwuhEG5P5ehfisK0QAOXqRXTsT?=
 =?us-ascii?Q?mYPeLWRrVHndNx3Lf6i65uoFYPjvopWCWCuI6HagDZEnFJW33Duw7KU4CbhA?=
 =?us-ascii?Q?zXG4LanzQs+AWmPfYQJQE99RY0C6ridjWJuMWu5MV9T5zBYTiggMSrv5OhOH?=
 =?us-ascii?Q?XOw+up7jEnbooK83qzFPUa6NGCIuBuV9Mt025mAs8lUepy2h9zJGtgKEkgbT?=
 =?us-ascii?Q?+1m4/GghKXgnQijtkmBPAzKn0p181hy1BR2v4Hpo32Rc7154NrK5IsBbubyq?=
 =?us-ascii?Q?MMHcyCM3P2mBNK4IOl9ef000XjXIg0t0xHey5l04mdMnOvYf+2dUF5hl6jsn?=
 =?us-ascii?Q?XM9phFVNrw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92067b3a-49b1-4058-f476-08de6b21a947
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 17:02:25.3168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AdRdp9R+KoZMS9yCrFfAL1ktYGqed9/rCiKpuzby/izILnQV6vqY/QrtaPofEEvXMmX9X/y8baSAcvDJ+sVyPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6120
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71070-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[44];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.luck@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: B3526138752
X-Rspamd-Action: no action

On Fri, Feb 13, 2026 at 10:37:48AM -0600, Moger, Babu wrote:
> Hi Reinette,
> 
> On 2/10/2026 10:17 AM, Reinette Chatre wrote:
> > Hi Babu,
> > 
> > On 1/28/26 9:44 AM, Moger, Babu wrote:
> > > 
> > > 
> > > On 1/28/2026 11:41 AM, Moger, Babu wrote:
> > > > > On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
> > > > > > On 1/27/2026 4:30 PM, Luck, Tony wrote:
> > > > > Babu,
> > > > > 
> > > > > I've read a bit more of the code now and I think I understand more.
> > > > > 
> > > > > Some useful additions to your explanation.
> > > > > 
> > > > > 1) Only one CTRL group can be marked as PLZA
> > > > 
> > > > Yes. Correct.
> > 
> > Why limit it to one CTRL_MON group and why not support it for MON groups?
> 
> There can be only one PLZA configuration in a system. The values in the
> MSR_IA32_PQR_PLZA_ASSOC register (RMID, RMID_EN, CLOSID, CLOSID_EN) must be
> identical across all logical processors. The only field that may differ is
> PLZA_EN.
> 
> I was initially unsure which RMID should be used when PLZA is enabled on MON
> groups.
> 
> After re-evaluating, enabling PLZA on MON groups is still feasible:
> 
> 1. Only one group in the system can have PLZA enabled.
> 2. If PLZA is enabled on CTRL_MON group then we cannot enable PLZA on MON
> group.
> 3. If PLZA is enabled on the CTRL_MON group, then the CLOSID and RMID of the
> CTRL_MON group can be written.
> 4. If PLZA is enabled on a MON group, then the CLOSID of the CTRL_MON group
> can be used, while the RMID of the MON group can be written.
> 
> I am thinking this approach should work.

I can see why a user might want to accumulate all kerrnel resource usage
in one RMID, separately from application resource usage. But wanting to
subdivide that between different tasks seems a stretch.

Remember that there are 3 main reasons why the kernel may be entered
while an application is running:

1) Application makes a system call
2) A trap or fault (most common = pagefault?)
3) An interrupt

The application has some limited control over 1 & 2. None at
all over 3.

So I'd like to hear some real use cases before resctrl commits
to adding this complexity.

> 
> > 
> > Limiting it to a single CTRL group seems restrictive in a few ways:
> > 1) It requires that the "PLZA" group has a dedicated CLOSID. This reduces the
> >     number of use cases that can be supported. Consider, for example, an existing
> >     "high priority" resource group and a "low priority" resource group. The user may
> >     just want to let the tasks in the "low priority" resource group run as "high priority"
> >     when in CPL0. This of course may depend on what resources are allocated, for example
> >     cache may need more care, but if, for example, user is only interested in memory
> >     bandwidth allocation this seems a reasonable use case?
> > 2) Similar to what Tony [1] mentioned this does not enable what the hardware is
> >     capable of in terms of number of different control groups/CLOSID that can be
> >     assigned to MSR_IA32_PQR_PLZA_ASSOC. Why limit PLZA to one CLOSID?
> > 3) The feature seems to support RMID in MSR_IA32_PQR_PLZA_ASSOC similar to
> >     MSR_IA32_PQR_ASSOC. With this, it should be possible for user space to, for
> >     example, create a resource group that contains tasks of interest and create
> >     a monitor group within it that monitors all tasks' bandwidth usage when in CPL0.
> >     This will give user space better insight into system behavior and from what I can
> >     tell is supported by the feature but not enabled?
> 
> 
> Yes, as long as PLZA is enabled on only one group in the entire system
> 
> > 
> > > > 
> > > > > 2) It can't be the root/default group
> > > > 
> > > > This is something I added to keep the default group in a un-disturbed,
> > 
> > Why was this needed?
> > 
> 
> With the new approach mentioned about we can enable in default group also.
> 
> > > > 
> > > > > 3) It can't have sub monitor groups
> > 
> > Why not?
> 
> Ditto. With the new approach mentioned about we can enable in default group
> also.
> 
> > 
> > > > > 4) It can't be pseudo-locked
> > > > 
> > > > Yes.
> > > > 
> > > > > 
> > > > > Would a potential use case involve putting *all* tasks into the PLZA group? That
> > > > > would avoid any additional context switch overhead as the PLZA MSR would never
> > > > > need to change.
> > > > 
> > > > Yes. That can be one use case.
> > > > 
> > > > > 
> > > > > If that is the case, maybe for the PLZA group we should allow user to
> > > > > do:
> > > > > 
> > > > > # echo '*' > tasks
> > 
> > Dedicating a resource group to "PLZA" seems restrictive while also adding many
> > complications since this designation makes resource group behave differently and
> > thus the files need to get extra "treatments" to handle this "PLZA" designation.
> > 
> > I am wondering if it will not be simpler to introduce just one new file, for example
> > "tasks_cpl0" in both CTRL_MON and MON groups. When user space writes a task ID to the
> > file it "enables" PLZA for this task and that group's CLOSID and RMID is the associated
> > task's "PLZA" CLOSID and RMID. This gives user space the flexibility to use the same
> > resource group to manage user space and kernel space allocations while also supporting
> > various monitoring use cases. This still supports the "dedicate a resource group to PLZA"
> > use case where user space can create a new resource group with certain allocations but the
> > "tasks" file will be empty and "tasks_cpl0" contains the tasks needing to run with
> > the resource group's allocations when in CPL0.
> 
> Yes. We should be able do that. We need both tasks_cpl0 and cpus_cpl0.
> 
> We need make sure only one group can configured in the system and not allow
> in other groups when it is already enabled.
> 
> Thanks
> Babu
> 
> > 
> > Reinette
> > 
> > [1] https://lore.kernel.org/lkml/aXpgragcLS2L8ROe@agluck-desk3/
> > 

-Tony

