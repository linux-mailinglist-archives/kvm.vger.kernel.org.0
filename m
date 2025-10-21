Return-Path: <kvm+bounces-60697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE510BF7D01
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 19:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4395048894A
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 17:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D77334C19;
	Tue, 21 Oct 2025 17:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RVCmSEZ9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516341373;
	Tue, 21 Oct 2025 17:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761066221; cv=fail; b=YnvX/xmHeBoTHv6JInfZ9BW5OjxweVZFWfFMJP2frWyT8CpIurEyNUfvAnCAgYVt/qeAMWwWNsjW6OuaDfXBMfnRSpl0W+QKFRaB0QOvMEpBH3RFGjm5AvuylKl/H3B/lQiTPYmu3mBgP4R9eEDeGrIhqND/CVQqpwEZz8CPT/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761066221; c=relaxed/simple;
	bh=N+xHsl88FE75k73PAbTMolS/UYeZKc92LEG1+O61gQY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sZRKMAIuc1u+cYRgdAVONiR3++RQON4QpDyF0zulCjKMLTAZC5KC3qCEwAtD7TeagcsgcEu5zzOjDLP57Y6xe04Pbx75Wqmgd0PJm02Tg8xZSiQV48rW2ao2e+FgaZVJu2QFQLYj4d4Bo1E9CLpQiBAnG3bsz37VfLGXVetWPY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RVCmSEZ9; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761066220; x=1792602220;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=N+xHsl88FE75k73PAbTMolS/UYeZKc92LEG1+O61gQY=;
  b=RVCmSEZ9VpCgju57uZVBGwcr+1B2nnTkcjr0nB3t2RiclDMJ1y9Was/X
   QQGTadyLWrW8FJjnjDVmYjsEGkD/mp0zoc+G1cKitJLWboiq4jd8vWM5g
   bioKq4UZbadwEKvErgYsPrydRwUTFu5ZWlqt4W1Khgps4lEPwsB3Dyj3c
   E7WjVI9XE+lKPVDPpW+L5bHwhJZTBj+SNj/GWZKzKTCiit2iMaQPj6seX
   6MVoD38ocU+R5gm4PXvoeUHin178x2eUJmfPpI8DwF9ioUQ/GdisVLSYr
   5/0DpnCL6m16pzl67h4FLceSWFj+srQI8Zxx2jciKWbsz03YD7PxnjanR
   A==;
X-CSE-ConnectionGUID: 0U7/X+/xTku7P3v0+N6IcQ==
X-CSE-MsgGUID: Bg4dwaijQL64MR1AwXSv2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63240039"
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="63240039"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 10:03:39 -0700
X-CSE-ConnectionGUID: P+fCQnpYRzW5l0GXyKGzZQ==
X-CSE-MsgGUID: 2NyIiC+zTi6GGHS0VWqgag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="182803706"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 10:03:38 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 10:03:37 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 21 Oct 2025 10:03:37 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.55) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 10:03:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ipiqBx9sgc+bK5gUpLuW1V/NJJn3/hfsa9a7e5JtQ+jBRiywutg8xnUwHBAq9hL1Ty0Cpw0yOB1Z5fiDGMgLbX3dgSrYpgcclRbuJg+uromysGCekmQ0UhklQEjJPjeRFAeHem8HG3wpCk8MRlNrlDgTaF0MGlW+C6pUyGXQs+ismr0Fae7napcnKelrUwQYYbRPKx++IBgyIa9wdfuniNLXcrUmuO1kgrXWFge0k4L6trqaracqF1mBseSGriN4xNlDQWaKodtCmObxSYBo5OfteZsbNy2Mpe+8EN1E5tnom5Vmf6u3akXF4zfRO1mWif+BpPxrGIxmX4rvh6RhNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lXJuTFhcXY1ceBq3Igo4x2cbLTfeKej2rBsbb/jHyw4=;
 b=LWEA6yi0olsmKidv0d7za9ff/fTDSaT87TD5IDel2opxRUPlRCwcB4+BWrqNSGzzK2LzflVa4HBRdgDGvtYFOi4ENtuUY95ttTtBAfaLKOhg5f7kUBPH82WYj6YPc7elhfpUqzdgbo1ADJUbSgd5/+XyTP5oh5GIuwtGIpx1kCuTwqqXG96psfRm1GnWtcmsTxkfp+DEn/3IWDqfErogungwNxUPNEd4pWW9aI4YeuJs3duH17+AbYUmUhd18JkTU5W9d3+2SVGSyIXbzd2S5jKMcVke06qdd62wkTx0JuNn6jSf3LmGrtgYDwnvMs44oibWgnUrmBlPx0ZqGHHLMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by IA3PR11MB8894.namprd11.prod.outlook.com
 (2603:10b6:208:574::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 17:03:34 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 17:03:34 +0000
Date: Tue, 21 Oct 2025 12:05:44 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: <ankita@nvidia.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
	<jgg@nvidia.com>, <mochs@nvidia.com>, <skolothumtho@nvidia.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
	<guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <alex@shazbot.org>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
	<ira.weiny@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>,
	<u.kleine-koenig@baylibre.com>, <peterz@infradead.org>,
	<linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] mm: handle poisoning of pfn without struct pages
Message-ID: <68f7bd68b1056_1668f310046@iweiny-mobl.notmuch>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-2-ankita@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251021102327.199099-2-ankita@nvidia.com>
X-ClientProxiedBy: BYAPR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::36) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|IA3PR11MB8894:EE_
X-MS-Office365-Filtering-Correlation-Id: c0095299-b5b5-4106-bb7f-08de10c3c4db
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?g/Nmd+mLTvz5Z5URJZ9PB286GTPdGNWrUfhzjKTssIFuhmG2Y2I1CQVCSIhb?=
 =?us-ascii?Q?Xq2H85bL2HOWxemc3/QVAADomEOHLINzZ2tmgH19D2vHEFciBY1fW6M7fAEF?=
 =?us-ascii?Q?KUvQ2UpfLu8lbuG7GG4zg9Latam6MR+md7hhXy+oc3PLvT70w28AXphLtcfH?=
 =?us-ascii?Q?6EFqjYQWCrCW6xwnBCHyDjaIbG3LWIK7y2KwdsHyY594Ewg+DIAJFJt3fZh1?=
 =?us-ascii?Q?W2UjUYQBFyvsxI+vbbRpNJ/93CH1PrMwKtvStgCUxEgODPKtSzl1Iy7YE2wd?=
 =?us-ascii?Q?biSzOXSD2xi0JVamzSm6Sywb/lGTF7TxK1kaU1JCdm/trTpduBKTW1AgsMue?=
 =?us-ascii?Q?egRULSw1A66OCk0JY56WGJRj1GD8d5eaIBsz009Ej8pg35A0OOeMY++JMi4H?=
 =?us-ascii?Q?87r2wDS2gSciSg2RK3/FcBmBhVeG8MVqZh2yuMlYzaf0a6R+dIiNnFpOSb+j?=
 =?us-ascii?Q?DUNcL7U3PObeZGcBid9MX5C4g0NpJZfAvjVWIToROEYFzEMBI+y4K8ghi9IW?=
 =?us-ascii?Q?XDfbITUpebHpF0qypJC3VVrjk8sKb+Sng+ndkxOMjq44C4tmYw+xg18aCSQG?=
 =?us-ascii?Q?et1CvYn4FpO/BAoWRlUdQ+rPlrx4NRrPC2CHlfafUIbd3PQo8lt+ycvQ62O7?=
 =?us-ascii?Q?sZdoR1F4eHGqh9rmR9gZTFXYIM3wcny7KqpxoB8X4YnYk2xMjfW7yXWzmgms?=
 =?us-ascii?Q?qXkTtgbt+s4fko5Et7gpU3mLFQYbVz7TpnGRKqZNTyzRwPXCMafm1rEFQNQz?=
 =?us-ascii?Q?xlSbti9SySrhAIZQXCi9lxA4bHS/x4DmY//N71YqgDJY9Q6lQt9+e4dgTwfp?=
 =?us-ascii?Q?dDzO7MvvUwlab3W4Ch6Exrm244qF8ETXB+O98skCnn9ssfr8BsTllGUBDdNt?=
 =?us-ascii?Q?svAx3gtatfQeBl1HFtuyhvMT38/h92fgt6a5CD76Wx6gQ3f+xbB21XSOjLSB?=
 =?us-ascii?Q?MmVwbpRoR3oTAOELy/mszSR/4z2Spcu0ou4QsXiAX+MIhu/77m6Fqq9hOlDs?=
 =?us-ascii?Q?/1qHfRRJsCKf4URvC7+TrXE0NnI9jqPj0EPIKjPg6cHwGd9cVB2jBD2gC5Fh?=
 =?us-ascii?Q?3BAZ6LQ9x8gtfRZbLxjxMPz72W1k4kNOsuwW5/PViKNP8xSLCPLWZBNmD6sU?=
 =?us-ascii?Q?z92HymHQ7c5UrvtoYfw4o+OHvuXnEaV6jPNQ/wpKiCSntFtiC/LHXMXskWcs?=
 =?us-ascii?Q?csh6jhTCtQUaGPaBYJJ8Nzqec+CXtqL58nx96WY3T+YRrhMEV8lPRuR7Hhs3?=
 =?us-ascii?Q?Pp6V4xHnWjIYasHgjwY04sNdAb4q3NI2452Je9/IN8EE4T4jP8Q6KGCcfSwZ?=
 =?us-ascii?Q?ijMlLQh/g2OPDjnUV4V8u/D0dIbdziV/wKcDUc3n2IVQhpyNlWCJLH571Jop?=
 =?us-ascii?Q?qbkzwl5UbaJjbqnFuottz0RJRVAjDTRUY2fC9ASokbdi5PuXK/1vGZ81Iv8b?=
 =?us-ascii?Q?FkwjOwbiMEDdrADBlMqBjUVu4gNUr5QWIfDe/2CK5NcIVoyY4Jl0F3sXV0Db?=
 =?us-ascii?Q?rS0J4XLJZIXTVz2ZJDWvhw8kQTQyZfAkQ7Mw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0tc9IIzjEJ6nqt7N8ScasaxlSQW87dWNKnTbJMHqcJ1vC2hfvYBgvRjev2Qr?=
 =?us-ascii?Q?G/VvRvRb9ZVfmjFhXSHmJkY5PJcbGWJMmv/fk0Aoz8xlmcIwA3IaOeDYp1GH?=
 =?us-ascii?Q?18OOSgB6WN8qV+F09WE360i0NkdeBg9wbSpZYsmgYbgQiPON3Chex45zweT/?=
 =?us-ascii?Q?SswdjpXLPNeWc1p7UlEZnVmVkURwDof+wwbiGsztirELQnSXnyOASu/xN7lN?=
 =?us-ascii?Q?/G3tH+QOpYBcB9z8Jps53bEwkpdn9jXi8QNp2eqyryECD4QIrDzewvMZFmTg?=
 =?us-ascii?Q?hWK0P6/tq4uylU0tgE/VOyWg+pdX1B6wTxftp8i0ytZgN3GlOcZKEfj3fliF?=
 =?us-ascii?Q?fw4qxg2Bxm+SkwPmCviaC7k5SzFrFN0EmFqD+UrTCjL7wBisO59rlc8h39hz?=
 =?us-ascii?Q?2fORdZhMUUI0ZdcIgci6czsY9sMG8/tRujxJYBnXNoeaHJAu/2JNVNirbzyA?=
 =?us-ascii?Q?jLspHowEIlNwTon9qsHWAu4UbcYliVuEQIoPcJieoMEi22jYX8p5WdSqDYjs?=
 =?us-ascii?Q?YDyDf8MUNiUihJD/nSyEE8JpmAqhQIco5z8IoT8MguODAhZmIRjb9TBs9LMT?=
 =?us-ascii?Q?loadibS/I78KWxfFX111tv5onyQM79qqIF6AUteuzodhz6G51N42X8TacYgU?=
 =?us-ascii?Q?Ay+aGSEO7NLS6bAwevNtrgYJj6ZEJfBTAjzGAHZj8dFWYCAqmfcL6uiTxlw2?=
 =?us-ascii?Q?Cv6+3zPwWTKPPmPMsSdaLysNAMHJEKLqdYxlXTonuVtrHfmYzqAG3YpsS3l/?=
 =?us-ascii?Q?BybHSNDfP/MfQJK2kU+YkQ2LthAQjqOX+tkhCbnpeHB7gjrtkLGNKwgD/g5e?=
 =?us-ascii?Q?ZvevLYdSMC2rofKT7tbF/OiA3ujRSa5MdzC24UvwMF5GC/rJM6c1hoEPXNBs?=
 =?us-ascii?Q?h0HfSqmmebx8+hjxHn47XrDnDXvgQYr1uFcDSJHsmY+nge2erEYO3ojpTbTc?=
 =?us-ascii?Q?xU71eIcZ9gYFvz5QFO2UU7kwWKNF/jeQDI1sTVmFIMtFOqUXrwfhThEE79e7?=
 =?us-ascii?Q?RUot4nL9Lt7qkajA0Mz4Lx1GRqVoDZN0KkqEmM5zVE6MYljZjXJzGnQTmfr5?=
 =?us-ascii?Q?EbxDKLpq3XdAnnAeswplNk2pkPTjdTOFM4JJzYisdiEIgir6C5a96F37SuoH?=
 =?us-ascii?Q?tRGQTF/TijlO+wAn2NzVTGrvrXzqAq7LDh2xaRpzuh9jn51CRqyTlLpEP2c7?=
 =?us-ascii?Q?ghhbit0dLGuZiZfPshb/OMCkbTQX22Yd1Krudru7Ckz/pSHUH0VaqqPoV0KX?=
 =?us-ascii?Q?laJ226FpmVu0JXyZjamWQVEHPQU7/Qj2tE29n15KMKarm3e+coH3vDGzca8H?=
 =?us-ascii?Q?fve1fgeXWVgdERsfzhhq4vhQrf6Ee3z9j+GaWSfIq74f7gcdyfiEuJPhB/hJ?=
 =?us-ascii?Q?6UqSE2Fm/14njhTk51z9jSpSdX6wOkSBXXPsxAi/LhYnToBrsZp6y/XxwOcF?=
 =?us-ascii?Q?n2pNLkD9zXIIb6LStb4DDO/80gVhM9X3pMemmawalUxlkV7JTGIe1+fN8qpv?=
 =?us-ascii?Q?uRuK1qTrxBz8mUT0F0SZtxsLhRuBBFPBO/y17M9v2P4Se7d3zeX/KX+FglZ+?=
 =?us-ascii?Q?XEs53kqlJfhjmvf4oC9Tq6NPAXTj3e9ZzLIg9P7b?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c0095299-b5b5-4106-bb7f-08de10c3c4db
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 17:03:34.2865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KX1+OG9ASrkO60tsOqsBbyyU3OSPoXlPuOT98f15CEvg0seNdQKfH9v5aLLiItFhtp+DBQWr89dcCKYp3in5oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8894
X-OriginatorOrg: intel.com

ankita@ wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The kernel MM currently does not handle ECC errors / poison on a memory
> region that is not backed by struct pages. If a memory region mapped
> using remap_pfn_range() for example, but not added to the kernel, MM
> will not have associated struct pages. Add a new mechanism to handle
> memory failure on such memory.
> 
> Make kernel MM expose a function to allow modules managing the device
> memory to register the device memory SPA and the address space associated
> it. MM maintains this information as an interval tree. On poison, MM can
> search for the range that the poisoned PFN belong and use the address_space
> to determine the mapping VMA.
> 
> In this implementation, kernel MM follows the following sequence that is
> largely similar to the memory_failure() handler for struct page backed
> memory:
> 1. memory_failure() is triggered on reception of a poison error. An
> absence of struct page is detected and consequently memory_failure_pfn()
> is executed.
> 2. memory_failure_pfn() collects the processes mapped to the PFN.
> 3. memory_failure_pfn() sends SIGBUS to all the processes mapping the
> poisoned PFN using kill_procs().
> 
> Note that there is one primary difference versus the handling of the
> poison on struct pages, which is to skip unmapping to the faulty PFN.
> This is done to handle the huge PFNMAP support added recently [1] that
> enables VM_PFNMAP vmas to map in either PMD level. Otherwise, a poison
> to a PFN would need breaking the PMD mapping into PTEs to unmap only
> the poisoned PFN. This will have a major performance impact.
> 
> Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]
> 

[snip]

> @@ -2216,6 +2222,121 @@ static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
>  	kill_procs(&tokill, true, pfn, flags);
>  }
>  
> +int register_pfn_address_space(struct pfn_address_space *pfn_space)
> +{
> +	if (!pfn_space)
> +		return -EINVAL;

Is there a reason callers may be passing NULL?

> +
> +	mutex_lock(&pfn_space_lock);
> +
> +	if (interval_tree_iter_first(&pfn_space_itree,
> +				     pfn_space->node.start,
> +				     pfn_space->node.last)) {
> +		mutex_unlock(&pfn_space_lock);

Register and unregister are good places to use guard().

> +		return -EBUSY;
> +	}
> +
> +	interval_tree_insert(&pfn_space->node, &pfn_space_itree);
> +	mutex_unlock(&pfn_space_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(register_pfn_address_space);
> +
> +void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
> +{
> +	if (!pfn_space)
> +		return;
> +
> +	mutex_lock(&pfn_space_lock);
> +	interval_tree_remove(&pfn_space->node, &pfn_space_itree);
> +	mutex_unlock(&pfn_space_lock);
> +}
> +EXPORT_SYMBOL_GPL(unregister_pfn_address_space);
> +
> +static void add_to_kill_pfn(struct task_struct *tsk,
> +			    struct vm_area_struct *vma,
> +			    struct list_head *to_kill,
> +			    unsigned long pfn)
> +{
> +	struct to_kill *tk;
> +
> +	tk = kmalloc(sizeof(*tk), GFP_ATOMIC);
> +	if (!tk)
> +		return;
> +
> +	/* Check for pgoff not backed by struct page */
> +	tk->addr = vma_address(vma, pfn, 1);
> +	tk->size_shift = PAGE_SHIFT;
> +
> +	if (tk->addr == -EFAULT)
> +		pr_info("Unable to find address %lx in %s\n",
> +			pfn, tsk->comm);

If the pfn is not in the process why is it added to the kill list?

> +
> +	get_task_struct(tsk);
> +	tk->tsk = tsk;
> +	list_add_tail(&tk->nd, to_kill);
> +}
> +
> +/*
> + * Collect processes when the error hit a PFN not backed by struct page.
> + */
> +static void collect_procs_pfn(struct address_space *mapping,
> +			      unsigned long pfn, struct list_head *to_kill)
> +{
> +	struct vm_area_struct *vma;
> +	struct task_struct *tsk;
> +
> +	i_mmap_lock_read(mapping);
> +	rcu_read_lock();
> +	for_each_process(tsk) {
> +		struct task_struct *t = tsk;
> +
> +		t = task_early_kill(tsk, true);
> +		if (!t)
> +			continue;
> +		vma_interval_tree_foreach(vma, &mapping->i_mmap, pfn, pfn) {
> +			if (vma->vm_mm == t->mm)
> +				add_to_kill_pfn(t, vma, to_kill, pfn);
> +		}
> +	}
> +	rcu_read_unlock();
> +	i_mmap_unlock_read(mapping);
> +}
> +
> +static int memory_failure_pfn(unsigned long pfn, int flags)
> +{
> +	struct interval_tree_node *node;
> +	LIST_HEAD(tokill);
> +
> +	mutex_lock(&pfn_space_lock);

scoped_guard()  Or probably wrap this part in a guarded function.

Ira

> +	/*
> +	 * Modules registers with MM the address space mapping to the device memory they
> +	 * manage. Iterate to identify exactly which address space has mapped to this
> +	 * failing PFN.
> +	 */
> +	for (node = interval_tree_iter_first(&pfn_space_itree, pfn, pfn); node;
> +	     node = interval_tree_iter_next(node, pfn, pfn)) {
> +		struct pfn_address_space *pfn_space =
> +			container_of(node, struct pfn_address_space, node);
> +
> +		collect_procs_pfn(pfn_space->mapping, pfn, &tokill);
> +	}
> +	mutex_unlock(&pfn_space_lock);
> +
> +	/*
> +	 * Unlike System-RAM there is no possibility to swap in a different
> +	 * physical page at a given virtual address, so all userspace
> +	 * consumption of direct PFN memory necessitates SIGBUS (i.e.
> +	 * MF_MUST_KILL)
> +	 */
> +	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
> +
> +	kill_procs(&tokill, true, pfn, flags);
> +
> +	return action_result(pfn, MF_MSG_PFN_MAP, MF_RECOVERED);
> +}
> +
>  /**
>   * memory_failure - Handle memory failure of a page.
>   * @pfn: Page Number of the corrupted page
> @@ -2259,6 +2380,11 @@ int memory_failure(unsigned long pfn, int flags)
>  	if (!(flags & MF_SW_SIMULATED))
>  		hw_memory_failure = true;
>  
> +	if (!pfn_valid(pfn) && !arch_is_platform_page(PFN_PHYS(pfn))) {
> +		res = memory_failure_pfn(pfn, flags);
> +		goto unlock_mutex;
> +	}
> +
>  	p = pfn_to_online_page(pfn);
>  	if (!p) {
>  		res = arch_memory_failure(pfn, flags);
> -- 
> 2.34.1
> 
> 


