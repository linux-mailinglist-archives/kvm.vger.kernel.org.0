Return-Path: <kvm+bounces-42816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B4B65A7D7C5
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 10:27:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6896E1691F1
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 08:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D975227E9B;
	Mon,  7 Apr 2025 08:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LG0jaL7H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0015224B1C;
	Mon,  7 Apr 2025 08:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744014454; cv=fail; b=eecNHmIAthkkTUjXmZV+ouWAibWXJoiozlE/qkWWFtpcBImGhxtTxWC8TC0PgXn9/FQth0FjxO0vm39Kv648E3yb1IjQWHTl8mCo0U5CFpUuzvteHB9c25v87rpMHILWP7IHEpW+OA1vc8G2wJZkA4ovNnM4BML0+FQ12GRLebA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744014454; c=relaxed/simple;
	bh=YIN8vso7LUB8ED4UbHhVg0m5mXuxyq3tKNrJHiFr2K8=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mU0X4WAClH+8rpn33R6B6PC5ubiwUQgOjNU+xcGfMEkycthm06PArzTsYpGMhtp7PyLFyxI30rIkAS37dMUDUxOUlxGnN6Ljf0cF7lpi37KEWfVsMmep5C66XR0TIFbA7l5w4TXtL6tF81347RyoeeV90eT0u13Q9ZW5x5r5nRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LG0jaL7H; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744014453; x=1775550453;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=YIN8vso7LUB8ED4UbHhVg0m5mXuxyq3tKNrJHiFr2K8=;
  b=LG0jaL7Hgr8hZihKUA1pWvCLwsRt5s3NYj8q15WhD8dbyptPO+FFHuMI
   RvNpOkZIhxTh64f5pKxp/XjtcSUdw/lZHQKPWxnP6eSSOU8A9rhkjsnXQ
   57N9kZi1d5ur3Jq+LH8Mg9ROH4TCyExudkeRcn3hKN0Q8JG/oh3fQhPki
   Y6F70XdDO1NgnHm5SEF++IvXld2nGoyFe4jmH3wVDsOESz/1dxg9QxQo+
   IvjDlLFYZOmgq0xs/1r0LCFdXILu2u/MSvosu2lc7D9/tZFDCrWphXJbF
   3eAnrVv8uLO9wT0IvupuZ8DABGQgpPgPuEHShxhNbuZnQ81EKJ2XGU/M9
   Q==;
X-CSE-ConnectionGUID: FJdS9n5nQmuccFM948KGeQ==
X-CSE-MsgGUID: ZVn7ZKIuTXGvCVf4dSps9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="55572719"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="55572719"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 01:27:32 -0700
X-CSE-ConnectionGUID: ZFULQF4HRvCRXjrnlbZLbw==
X-CSE-MsgGUID: R+kls1+tRQiHwapxJ5TchQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128208334"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 01:27:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 7 Apr 2025 01:27:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 7 Apr 2025 01:27:30 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 7 Apr 2025 01:27:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ws6ympRa4JkZxptgR9W6zYYupdLSbSIuXHXm/pAxhXz5HV18Fv9WJjaAvMs9FchbuASFKGIqKfQlx+0lkvF7QmBqCT5i4RwpDLm9ZL6plCaj6vSnxyV6k/p2c3fZuchI2mcRa4IYbAM1cDaDvV7HZLvI1mvVO6Kik/QFhnGjKIh0WxtFdT/lyLyg+MzotJ/zB8AtaGxhOOQKvLh8Vps2RUoQMeOk8KH7B3D6oASkuA0v8uaLnwvEcu1ZaedcGR7YIVKdZZg1tPJHVOgNqZg8c6FLrLgR2LjPnafQxpihewpTf+nh8JrnXV8shco7U/0QikJVUJZTqw8rcPUGXr+OAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cIaKu6WJCga8O8JJv5aEM4FPwIcxqLDyGZh9ZTQSYXw=;
 b=AUM8/1bgAGowHeubrkgDMLnohgz8Y+uN4f+hR4Pa8sVCUswD05uMMGkPEc/MjTRMgKwxzuM1m/a7fEBoHnQ/jIxI5YPFfdvOb3fmjgrS0zkljYfrZE7XTFsMKwsYX32ikIeiLpU97LVkYvndcsvhXqIaKifM2uTjzGYOTsqbeDk4itng5O81p0vw2dsRrBQiaP3XP5PwI3mzm/l3qwcTxbhhXcgrtaFbLQumpm89AeEB+0g/DHIEKTQvIp41QHlxPOEW7CM4UOG+h3bisJfWIwu78b7+lE0mpVSG9wT1k6LrbCt2Iqzsmh/GmVrsKwNm77HSKAhjprCOYjdaAcPB4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6858.namprd11.prod.outlook.com (2603:10b6:510:1ee::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Mon, 7 Apr
 2025 08:27:26 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8583.041; Mon, 7 Apr 2025
 08:27:26 +0000
Date: Mon, 7 Apr 2025 16:25:43 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <vannapurve@google.com>,
	<ackerleytng@google.com>, <quic_eberman@quicinc.com>
Subject: Re: [PATCH 3/5] KVM: gmem: Hold filemap invalidate lock while
 allocating/preparing folios
Message-ID: <Z/OMB7HNO/RQyljz@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241212063635.712877-1-michael.roth@amd.com>
 <20241212063635.712877-4-michael.roth@amd.com>
 <Z9P01cdqBNGSf9ue@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z9P01cdqBNGSf9ue@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI2PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:196::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6858:EE_
X-MS-Office365-Filtering-Correlation-Id: 97bb4dfb-f1ea-4e8f-1c66-08dd75ae075f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ulK3dhOvVzPNTAX0Pwxel7mMkYbUkyG8AdIAjyMkAVXzvmVubAwdzqPmwk8u?=
 =?us-ascii?Q?kYzT3cJB8VyVFwBzJcJAwBDOOEeCJZXp7+XdOkJxu8ZzIjIJyQRBs8mdDbm3?=
 =?us-ascii?Q?7t3lISYXagtfVmd1OB0TZZKQrq4ZCiLiogIWf1uBeB3K8qEUaFk8/X4z5YRO?=
 =?us-ascii?Q?FSNO+pD8lmt1/Svx0FsbkOyRwtZws0WRbJBlmJ9jdepkBfmQPcIuxwGUSGW5?=
 =?us-ascii?Q?nT/M5JgDlTXCODqh2e9y87uY93kxViE+x0sAuWeev/eR5PGJb58xR5k+/ntH?=
 =?us-ascii?Q?udxNDbUFwoLbUHvP7Aiuwu3QJTn8RyRVoD/J5iD5Bk3f4R8yLMNExhmhEPA2?=
 =?us-ascii?Q?vq2ii+iv32wAh08Yq2DwkRnnnBLx2cg7V6jBRfmVzDFuf/iyd8w4lfwOq/85?=
 =?us-ascii?Q?TTZFvK9FGMNR3WdAvyec9p6il9B6i+KRdErrx1QjA1HuVZX1pyMnXBG1Mc7c?=
 =?us-ascii?Q?hTZQM1DyiEnrWCdpUW8bdIcL5EdAU/tbjDQkGWEUfdNlnnL94oPH3UwLCgte?=
 =?us-ascii?Q?ONXhRDNfIoEONz1Rat0REf3WNx4rRtbGuiNoYFV/tQ3a5KdZ/rATWwAqlpoq?=
 =?us-ascii?Q?CBj6YpozObG93+dLnxA6kAbyK6MxlLAH/7OWYMfqVSC0MG9Q7XdXl+3rdHbB?=
 =?us-ascii?Q?cDX2fbuQb5V4lCBDC/ovJCyCC+cz7Ks2FZKy0nlkr/8O+CMhg7tVsCv6mE0W?=
 =?us-ascii?Q?Ic+VWTuQXhfC+kj12tfIzcnt3W/bARZeJ/Ii/gUNnxbuqYv2tNPEjHVlS5UR?=
 =?us-ascii?Q?rxo3zWiRn+Mb99yAwmmckF+JO7EHzTlrUXMkd3ZIIlLtff1YOZGAgqJKTOTL?=
 =?us-ascii?Q?jfUZozqE6x5c6RlW4M/Z486lToMiMLHt3eYu5FH5l/9AFvOug04WST2MENE1?=
 =?us-ascii?Q?BLnPMHb8HJCGHtrc01weU6KPU9wPt9MSsWfkERqRm4j18R4xVcI58TBBi+2K?=
 =?us-ascii?Q?6DMWvRumbVku5B74wuvYuTRilrEE4SBmMv4x+2KcpMjy2RdnDFgyTubmjBFZ?=
 =?us-ascii?Q?OFhSC+p5MhXbJ7Hytx/IMABA/5PjfLKcdyP4IT6CjbZ/3B/0xfp/8bVRx548?=
 =?us-ascii?Q?WqNSBH/rBriwaQE+9RksOmIgQp93RUsAIzOZSL6uRs+Mi7/mqVxM3Mknfrk7?=
 =?us-ascii?Q?Ph7E47E8awTwABEwJhSYxyG6WZQnJZc9XdWOrc2FHs/GxhDrT/coqiD5F6sb?=
 =?us-ascii?Q?0ya3ihlQKviUuVP0COHMbKz19CYerHy3YQPJ1yzVJQkvw09RyLDRBd5ALecd?=
 =?us-ascii?Q?DLXL8XjuajPJOXUxa0n1QZr9d32m2O33icQXdOF5HA921GWBACWCDtmNOJCU?=
 =?us-ascii?Q?dKPn/laz9H/9SiOYNZTWj9rcGAzZdTSLuQ84qvJMK6RcLDtb7Uk4I3h6gSgU?=
 =?us-ascii?Q?KSpFGRCktAR1tsO0QIFKxTFt+tOkEPwCHmUNMGHVK1PrJSnfhgJQpXQLSVuR?=
 =?us-ascii?Q?LfEegRbAdmo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?STEBhmkKHXk6iDQ0TUTUIPYYjS9p3gyVT1B157d2UwNDEluDWT0R+unLYCDf?=
 =?us-ascii?Q?WSvFz9CrLzP1ir8our4UyYGgt1NZbpqdtvPCFBSJjLaQGEzWxHjUb2/fNq0I?=
 =?us-ascii?Q?MTqQLV2nQjsLJxEHKZc5PnKHIEN9ZpcEPUZkmF9NkheYEe6EtJurdfiqGLdx?=
 =?us-ascii?Q?uzqJT7eXZPt2ekcRB9jSF+K1kFkz24U3QF1/kMohrl6oTT3sJ+dQgshYIYQl?=
 =?us-ascii?Q?fZIphAmUtN78gqO2TLuuSug4DclLtrFR4NYwkAO5ybhp7nmytC1gIbO7czLp?=
 =?us-ascii?Q?mf1HJaJGn7FJsIGbAr3RSpWFvWeYR5kYIKGKhB6dbQWyCt56W/PCvf7dXd0Y?=
 =?us-ascii?Q?YblnnmDosI+z+RQ03zZc0jArQPCCWwMfiq0Z/erBm/ecc+bbOZ7CpFAsGjcZ?=
 =?us-ascii?Q?5bmxNVFeC7XopRW5lEM4PExwY9xvRRCVZNEQc2RfVsbJ34dT7M8YUpoP6Jgm?=
 =?us-ascii?Q?T6Jt1PA1RWRwhKioouS0Ka/zIamhWectCOGoba9PnhznyzJMEcKr/pbLhk6V?=
 =?us-ascii?Q?uaO44e7busVY4jBlhna4oG4PASm3QJCKaBQSt0f1LbXdcCjtw9jfeUwPvmE/?=
 =?us-ascii?Q?AsYZXcwIZdUIG6KQwnHUxUNJPMEd8LJLSp5+b7KR4l3PAjIrnT/5NhtedHqU?=
 =?us-ascii?Q?RPDWbNuSumESBZi9/OrpFgQ3Co7Be9Dt1F3rh8b/XCQ5+i4du6YpbFnlTLW7?=
 =?us-ascii?Q?ZOX+wM2nzh1FFmU6rgvllC4ePqcfLsznkxP5gerRjB/0YNTyDJ7g9cUZxD9K?=
 =?us-ascii?Q?WKde3Wc4ISI9+ASCuI1Zksy6tVtvpTM+UfZT8Qo0OpPA3hVrAw3SQCugsdXR?=
 =?us-ascii?Q?xMWpIgaNRV+ti2fNq6g0SOpbpyFOwTjnPx7pDksUwcGcBcLQ82eC57wekUIo?=
 =?us-ascii?Q?/63JNQB8N/2YacB/gs/vXNSnCGDd3Tm7IiuA+c5VVxnPbltpX1cvMcoHB7On?=
 =?us-ascii?Q?tTn9t4di4Eowppsu4c0vLzCGM77z7Ib9M/9wjuya8bugrM1AhUmgDtIipNNF?=
 =?us-ascii?Q?fTb3gbgytNI/duCA7QuYZKH3qOL+OMF3TP9n5gIBn2jQS7OygjCpwLYANvvn?=
 =?us-ascii?Q?lcpWBRuro0mWfdMSj8GOWgfEG4rKTwDcyN6wPkSVbEkjp3hTaVu7Fg+RAt8p?=
 =?us-ascii?Q?+5xk/A6/q9LZguDO/AASPaoMidSmWgR1tutWxm1b/PgxN2IV+VjOWF2SqUU9?=
 =?us-ascii?Q?R5POPN8vQD25348h5fZpk8gmjafRKv7boV/hH0Na9bBmw1sSj5b/IAiNbugr?=
 =?us-ascii?Q?j0dboty5kcUzescCD8p+LtVy1FefqCfKDabzxAiR703NrpFdWas0UwX56N5N?=
 =?us-ascii?Q?Kw9Fx58+Vg+HlHPe3+VBDtz/7UIv/8ph9T9XPWkfmK0sbX9e+ItLq15C2gUN?=
 =?us-ascii?Q?wo7vL7hOGQ+pTgBtTRm9JZG6nOyYFkJ3QrKkJ0TrxwIlqK7+ShZ7ogNgzKoJ?=
 =?us-ascii?Q?cW4Y7yIih/QTFkLc9rNA5TvopYZhl5ALWleu38cg4i277DjBUF0eW2m7x3C2?=
 =?us-ascii?Q?L6EQ0CU/LZA6MJda6T2dY/cYejYlbEcjWEDStHoofinbZtfn3EwyQwO4powT?=
 =?us-ascii?Q?ahCbRc266MxrQXjT/h8fVuV3y0clAYsjABZckBNP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97bb4dfb-f1ea-4e8f-1c66-08dd75ae075f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2025 08:27:26.6394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q3BxTG2R45kaeWWnM+S8WYvneYB7szCTKukOcu3T7pU2Q99Rk7TsfhPk1E/KVpZHGr61WasjP9seBKZctb1C6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6858
X-OriginatorOrg: intel.com

On Fri, Mar 14, 2025 at 05:20:21PM +0800, Yan Zhao wrote:
> This patch would cause host deadlock when booting up a TDX VM even if huge page
> is turned off. I currently reverted this patch. No further debug yet.
This is because kvm_gmem_populate() takes filemap invalidation lock, and for
TDX, kvm_gmem_populate() further invokes kvm_gmem_get_pfn(), causing deadlock.

kvm_gmem_populate
  filemap_invalidate_lock
  post_populate
    tdx_gmem_post_populate
      kvm_tdp_map_page
       kvm_mmu_do_page_fault
         kvm_tdp_page_fault
	   kvm_tdp_mmu_page_fault
	     kvm_mmu_faultin_pfn
	       __kvm_mmu_faultin_pfn
	         kvm_mmu_faultin_pfn_private
		   kvm_gmem_get_pfn
		     filemap_invalidate_lock_shared
	
Though, kvm_gmem_populate() is able to take shared filemap invalidation lock,
(then no deadlock), lockdep would still warn "Possible unsafe locking scenario:
...DEADLOCK" due to the recursive shared lock, since commit e918188611f0
("locking: More accurate annotations for read_lock()").

> > @@ -819,12 +827,16 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> >  	struct file *file = kvm_gmem_get_file(slot);
> >  	int max_order_local;
> > +	struct address_space *mapping;
> >  	struct folio *folio;
> >  	int r = 0;
> >  
> >  	if (!file)
> >  		return -EFAULT;
> >  
> > +	mapping = file->f_inode->i_mapping;
> > +	filemap_invalidate_lock_shared(mapping);
> > +
> >  	/*
> >  	 * The caller might pass a NULL 'max_order', but internally this
> >  	 * function needs to be aware of any order limitations set by
> > @@ -838,6 +850,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >  	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &max_order_local);
> >  	if (IS_ERR(folio)) {
> >  		r = PTR_ERR(folio);
> > +		filemap_invalidate_unlock_shared(mapping);
> >  		goto out;
> >  	}
> >  
> > @@ -845,6 +858,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >  		r = kvm_gmem_prepare_folio(kvm, file, slot, gfn, folio, max_order_local);
> >  
> >  	folio_unlock(folio);
> > +	filemap_invalidate_unlock_shared(mapping);
> >  
> >  	if (!r)
> >  		*page = folio_file_page(folio, index);
> > -- 
> > 2.25.1
> > 
> > 

