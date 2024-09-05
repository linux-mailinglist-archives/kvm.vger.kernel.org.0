Return-Path: <kvm+bounces-25964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DE0296E14D
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 19:40:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E23141F27862
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 17:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBFBB1A3BB9;
	Thu,  5 Sep 2024 17:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M9cenW1L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3879015350B;
	Thu,  5 Sep 2024 17:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725558026; cv=fail; b=tuNNiL2EVTAC+DXSiAv0Sz2B94wXrSRxxn19mOAPAjlYWAsLezf8BIRNkGDaPjxpbCZ3isrdpX37myVoNbSqVHRmNcthm4t6L0tYR3FJt4I7S3bGIVjRe7yh5IX4aF0ofA1VX/fatshfK4dRVivc4KQeNjzX2pvgS2Mcnr/MdJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725558026; c=relaxed/simple;
	bh=ZTuQjtT2WP5LY+GX/iK5aPKTh3JJ+/zpr4W4CElZQ08=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S08xirQfFt1luniJbLBd8dBq3cZxonaI56RqgzOxcbl+QJV7zV0gog5LJ21uAFEoX6rgCzOkZLjHxWbabnqfWHBg2B0OzHaVYJ4AW7An5IHqcN2Nw9bQwD3TtKqVh638myyXOngj65E8EXD39eY6OXtiZesdTBxp9QP6DuUFJo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M9cenW1L; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725558024; x=1757094024;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZTuQjtT2WP5LY+GX/iK5aPKTh3JJ+/zpr4W4CElZQ08=;
  b=M9cenW1LcCMlaLClSjVHTDVv1gDFYBVswNdxzqgWryV9IfDoOErhgkBL
   RjeNiWHkNDoYM1Pc/rxwKyIHExOg+yUNDc+vR4RA9qrEl5axt0Frl4trD
   hCkKcEws/NCG50+Wznbn1Oc/dXe61vBZOh5D5Zo1oa2AQWigciBmN1+Td
   7tZgLll9zO+xQp1Dvb6w9HqQCckG8eW8j9KRWKf1HOQ02s0+tRI4tbw2e
   CMaRshN1piPKxgHmqDpZx3BtPdDcR2ly+gA9OfXUyrI1BH1NEV73/qs69
   zZF/FBdO2psQgTAmnKFTkvlKZqsNkXLhlAlV/tfz+D60EuJUqRREs+fks
   Q==;
X-CSE-ConnectionGUID: Slsw6euXTLenx2vAS8QmLg==
X-CSE-MsgGUID: 11qL1lamT7+Gq6gbDh55/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="24451254"
X-IronPort-AV: E=Sophos;i="6.10,205,1719903600"; 
   d="scan'208";a="24451254"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 10:40:23 -0700
X-CSE-ConnectionGUID: QRGueCvYQQaOSkJqNbmZWA==
X-CSE-MsgGUID: 0lvacJgMSrCYHpInYEu4tA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,205,1719903600"; 
   d="scan'208";a="88937858"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2024 10:40:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 10:40:22 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Sep 2024 10:40:22 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Sep 2024 10:40:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E2ML3VSKQK6RHfzIJJYiGXNYX7+ecB9Nd+y9E0LNiX4Q3K3qtoTRfa49j1jfZ9C5KMXifOMkPi6ZYytkmPwD7aXa2YU/xk1lThxucYlYxVoplJTjNqOL7EscMaU9+nsPjj+4h/wvSHBB04Ot9To6G0zltyPEqoWXKRsV5PULbG6gh/F+qBVpswZxKWQ/Lp5gpCeSNtDsnOHkpDGSZr/uKqNOGk8AMmV/DLtzto9KA76pM5/A/qXMEopeCXoMz65vupmkPycDzhQir0aauUKgQIbKtM60s5u1lCuYqyflRrDLp5YOhu/W36FPXv5bb+NfR8ugB06Rnem8wXY9204e7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oh6j+tVCWTW6u4H+DwcSU28gw8/ZG6ba9alqflNoNn8=;
 b=RtCcAXSpAvoEJHrTZpV0xjNZe4JRMYqR3JOESCWWSS1RmgPGfC1TrljOfq7QSN5pjaBo2nhCuXYB7HABzutYk9wK3V3+os6LqCZTRJnnFfdCQmiAiXACpwqFTndrixEZsMQT6inTUl4vqHvMj6vTjle6lfV/eomJP/vjTrSF8KUEe2eSo6pnwkctQ8TJDXYWkQfqitu9neu6tBvQ0i7Av9UxFvbOcKKoAJE5JFPsrZSO4kGUDkaqKKcliCC27577JSZmaCE9t8cDBze6xbnJ8Y1H9WzdV1UH/7gkeWE1ztLi0EkcxtZ66iuoSDpBunapjKnBMJttvGfYF5rurTJAuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH3PR11MB7793.namprd11.prod.outlook.com (2603:10b6:610:129::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Thu, 5 Sep
 2024 17:40:18 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 17:40:16 +0000
Date: Thu, 5 Sep 2024 10:40:10 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, Dan Williams
	<dan.j.williams@intel.com>, <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, <pratikrajesh.sampat@amd.com>,
	<michael.day@amd.com>, <david.kaplan@amd.com>, <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 06/21] crypto: ccp: Enable SEV-TIO feature in the PSP
 when supported
Message-ID: <66d9ecfab488f_397529426@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-7-aik@amd.com>
 <66d77f5ec9da8_3975294d7@dwillia2-xfh.jf.intel.com.notmuch>
 <16182660-3eb0-4df0-95a5-d4d2c4598319@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <16182660-3eb0-4df0-95a5-d4d2c4598319@amd.com>
X-ClientProxiedBy: MW4PR03CA0134.namprd03.prod.outlook.com
 (2603:10b6:303:8c::19) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH3PR11MB7793:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c8edab9-32a3-4b25-fafc-08dccdd1cd0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uuhQVF4S0I3go1yBNJwv3GxlA3RkgpZ0xRJTt8+Awyo8a09pBFIIqtfFGF2k?=
 =?us-ascii?Q?oQQjLqdItnKWHiLvoGjKeOlk1/Ts8KBOTYEHFaASiJposqnf/p6EroSzi9pz?=
 =?us-ascii?Q?u2t3/Mzb59VrlYw+uMaCIgPkVUN+bZdL1406gq5KHgQokJovRaV2RLekFJe/?=
 =?us-ascii?Q?4k7NcfAbGrTTQgry/BrZbDLGa/yeli8wOza0u9rjUV0dsNBGF3Jz80Oh+Mf9?=
 =?us-ascii?Q?DHD1+DflJmeCAOOgenoeQh1RCGHqoget/trw8nLCw/813clVAB3iBd2sbd6/?=
 =?us-ascii?Q?6F/Uo0AqH8dkXusGhzKfOy2KxBK7XP5u0i+K+HZfzwc43o86HuJ1p3SztHdw?=
 =?us-ascii?Q?gw/0re2DUbV0lVvF7Ol4AJXkjEDJyttNnpxo3Mwh5VdZ8zN82cYT6xS6F3XN?=
 =?us-ascii?Q?gXM577BaKKR0C79HTggf1+GmQ4pU5lZYoQRqbjwLtcuqBVbKKZBs3O49AHz2?=
 =?us-ascii?Q?pVqDOZJgKKoWVmvyZMcy01vpKYOcFLCSO0BYOqjpzxmyzkfRczKfJouYA0kB?=
 =?us-ascii?Q?3IOJGk3Kp7BuRxwqgE5zTMhf5rMb/UeAXp9C6JptCf9zZY0en/aD/YMjIMwI?=
 =?us-ascii?Q?0FmD5mAgOvkMSCfUnJXjnW21QU5MRzNo9mhkEapsX48Pgyo2TrnWMJbPFp53?=
 =?us-ascii?Q?a5qZ0LkWj3iA5B3OjgpB6Xizwh9GYoApOZR3xL+HAUX4PFYbGeH6RqqZ0A+a?=
 =?us-ascii?Q?LmIuIvd+RjFu2UJkTetN/+Q43I1MX0OoROWEdjSBOCq7XozPjkXqFsThdFqh?=
 =?us-ascii?Q?UPjC4saT52NXCPoLrzfnsR2QI+jDPPyBopoRPYrJPq+cxoe5j7AhYFm776pI?=
 =?us-ascii?Q?x929utjctvD3tHGDpVXVFUJZC3TJA4/hyAFOFUPKTyephMEFEnc2SghYEIpK?=
 =?us-ascii?Q?cjcm8pSBU5PcRlSctPv3TiAo16ZcJlJniBjY8uWOjXDaFCsqkizUza/y/JYo?=
 =?us-ascii?Q?LhPgE3zfLN5wvizltx5yzUXTtv2Xtx6rZoL+euN0xvQOk11auCUp7IEk7BHE?=
 =?us-ascii?Q?3+ZaLpKh0XQsZCe34p30jcaEQfgBZlHZFAt5RQtbrbp52AFY8c/X1uTY/vka?=
 =?us-ascii?Q?HpQaHX5P7aGPFCV79Kb5ZIk+AXy+oOq0+hO3G0mguS1WeURQRTxBzBknQoPa?=
 =?us-ascii?Q?dYI5P/x+mQSgvWjzPoS5FAd/rqmm2xFOqaAPkuBsLpXv8YBFsNyoqSMqH46I?=
 =?us-ascii?Q?+sHMQkFgI/K4eJdXUXCstzDFwzZxIBwM2gFnw5BWOoQ+rLuiblF2/JzLsY8E?=
 =?us-ascii?Q?O1ICJI4LZhWJlbchHDJ5eyVpE/dgSRYn3Yors08KPVOUz9omTQtDFfEEWLZb?=
 =?us-ascii?Q?5aqAssIrNSQ5Lx6xFXsndV9tske617HAuKShfLXWZ3KjjQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lxPtK8ydXy0anmr8Ef4aMbbXzLokSxAmfCSeLMCMJfSwUAjllLC/dkBx7vPU?=
 =?us-ascii?Q?R51m8JREXegJPosLvhgxyP/+cN1ov4SKE/y8Go8BqLZFcuCfdZLRN9CoVc3M?=
 =?us-ascii?Q?FEZhlv2fBMT/0J/XbeE9BWHl0+oF0Gz7m/pkH914/l0+iHHPoYcWj132MPwK?=
 =?us-ascii?Q?C8ueuMfuOF8ER9rX8qRC2E1krsSXJBur6f7QZsXp5jAd3ySTJUv9SMPi497z?=
 =?us-ascii?Q?xeRn+PeTe9NBcCfVxvxuALuaQZvt/tjEIaS0SKRuMjo3HTJVNDWub94B/T/9?=
 =?us-ascii?Q?qrf0oSN0++7irPWWuMpsnyx9cJjK/7b6PYqBCvmInBHBC6VBjL0kmMtR3oWB?=
 =?us-ascii?Q?MiYCwx0wJDRMsea48ol3UYnw52cpzPXPx8JSibfTGhdEXpmBc4uzAsMxMxi3?=
 =?us-ascii?Q?CG5k9QJgR/QgeHgZtCXpr41DNwlv1qflDoXp6sYMUREp8QJCynhsDihWJ5U/?=
 =?us-ascii?Q?L/9QWVzx+okj+07G0pWBSy/UI0IB7Y8CvRDWRgfvtn3Ep2JuIVFiq2ea5C57?=
 =?us-ascii?Q?uL81VCvRugoavssE+5/WjFKn93dbqaFH1Zz6aNb1WKQYsmR/rxeat8q2Krx1?=
 =?us-ascii?Q?PBG0NgI9IXuQgrtd/b7ouJth914MybcMB6lR5p5SCFxQ8/6/bpwbKxlpQMSC?=
 =?us-ascii?Q?VzJPsnoWg6rC+YWvdXJOKUxFYh9nvjzTD1EPaiOaQKN/ZN/amQ7sOzIy2HXv?=
 =?us-ascii?Q?d+gwWxnUpIXzWQP7jRWb0U/zb8spBrur0T6FbMR1gueB+40wd4YKt5/03NM9?=
 =?us-ascii?Q?TkLLiqE7f+O7LRwi6VWfVrdWwt08pm6xR1/jvE76ZDEG9YOD9FSWTC7PHBnH?=
 =?us-ascii?Q?gd+26EzYq+Qsg7zfmUf+qMIQZvf+CrgZ+I6FkFSIG5jaCoNurNMUU6oFg37F?=
 =?us-ascii?Q?uXDUXp5O5Vuu88FkNlaCOqU53gMw1NtMwZ/2RtJXDVD8X32eP7Yam26HS2lx?=
 =?us-ascii?Q?pGyisu/a41z+RdKQaVjRbK/GF8aEZ58J+MDlty2UJtt1toeVEOjNPsI614z0?=
 =?us-ascii?Q?3z1bVsA8Yu4rPFGLpNWDiMs7kyKPYqBCRH0KQdIa2MqmbomepE0beMWR+5ah?=
 =?us-ascii?Q?LaC9WsvlW3epg31wr7nLiYZELNT2oQJodaR9GjmF7qggrkNNwu9rdFvKbPxu?=
 =?us-ascii?Q?qBt77o/1lAE/q0v00QGUSOTgm9yRJlc/AZk00zAAJtBmqKVHXDDmqt5vXpQy?=
 =?us-ascii?Q?acKDyvubsRyDZhdfkQ8YD6Mngrwx+sCj8xw0roqpFFz1l8PDmcqdDQrqtDxE?=
 =?us-ascii?Q?yIZY1aNTqLp4Cq8ECTnajN63ZijfOOVlCmXQqKgQftEOsNpb3UEGE9QRYSHH?=
 =?us-ascii?Q?QN8FEb8ZSOChAmw5xcXNcRs1/0G1CjlrsvQ7IxUs6U7HLi62dkvRKSvcQHDT?=
 =?us-ascii?Q?CxcR8EmxfNmcvoIltCbmoq8ro/yJaJC4s/Aa09j/1N41vAKG9ORETN6Y3KtU?=
 =?us-ascii?Q?u+GaMDpy7SKamm4Jv0PjzUdHr6Wfraj9ffrKpOljtIIbgmVnnObpYkSYI+ZS?=
 =?us-ascii?Q?0fjxLJYh+hjpZ19T/A+MVem4WUxNAhLhvHF2g86l8Nd9P+SkF9p4JNKFFXQg?=
 =?us-ascii?Q?/+7+AbLZU1DvaRV9c0640eXI1rzVt584HLK/0hheirNSOHkt7IK4vARoF284?=
 =?us-ascii?Q?Xw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8edab9-32a3-4b25-fafc-08dccdd1cd0b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 17:40:15.4055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0R4ZWvNc1nikq1kNNrhpYLl7fBDeo2lRTo8DMacbTdCClxMdd4eDZ225Eqi0clrdoxJcwwm7vmyAIJYM3HyU1hB0qL5aRzHCiBHfUZzszRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7793
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
> 
> 
> On 4/9/24 07:27, Dan Williams wrote:
> > Alexey Kardashevskiy wrote:
> >> The PSP advertises the SEV-TIO support via the FEATURE_INFO command
> >> support of which is advertised via SNP_PLATFORM_STATUS.
> >>
> >> Add FEATURE_INFO and use it to detect the TIO support in the PSP.
> >> If present, enable TIO in the SNP_INIT_EX call.
> >>
> >> While at this, add new bits to sev_data_snp_init_ex() from SEV-SNP 1.55.
> >>
> >> Note that this tests the PSP firmware support but not if the feature
> >> is enabled in the BIOS.
> >>
> >> While at this, add new sev_data_snp_shutdown_ex::x86_snp_shutdown
> >>
> >> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
[..]
> > Why use CPU register names in C structures? I would hope the spec
> > renames these parameters to something meaninful?
> 
> This mimics the CPUID instruction and (my guess) x86 people are used to 
> "CPUID's ECX" == "Subfunction index". The spec (the one I mention below) 
> calls it precisely "ECX_IN".

Oh, I never would have guessed that "snp feature info" mimicked CPUID,
but then again, no one has ever accused me of being an "x86 people".

> >>   /**
> >>    * struct sev_data_snp_launch_start - SNP_LAUNCH_START command params
> >>    *
> >> @@ -745,10 +765,14 @@ struct sev_data_snp_guest_request {
> > 
> > Would be nice to have direct pointer to the spec and spec chapter
> > documented for these command structure fields.
> 
> For every command? Seems overkill. Any good example?
> 
> Although the file could have mentioned in the header that SNP_xxx are 
> from "SEV Secure Nested Paging Firmware ABI Specification" which google 
> easily finds, and search on that pdf for "SNP_INIT_EX" finds the 
> structure layout. Using the exact chapter numbers/titles means they 
> cannot change, or someone has to track the changes.

No need to go overboard, but you can grep for:
    "PCIe\ r\[0-9\]"
...or:
    "CXL\ \[12\]" 

...for some examples. Yes, these references can bit rot, but that can
also be good information "the last time this definition was touched was
in vN and vN+1 introduced some changes."

[..]
> >> +static int snp_get_feature_info(struct sev_device *sev, u32 ecx, struct sev_snp_feature_info *fi)
> > 
> > Why not make this bool...
> > 
> >> +{
> >> +	struct sev_user_data_snp_status status = { 0 };
> >> +	int psp_ret = 0, ret;
> >> +
> >> +	ret = snp_platform_status_locked(sev, &status, &psp_ret);
> >> +	if (ret)
> >> +		return ret;
> >> +	if (ret != SEV_RET_SUCCESS)
> >> +		return -EFAULT;
> >> +	if (!status.feature_info)
> >> +		return -ENOENT;
> >> +
> >> +	ret = snp_feature_info_locked(sev, ecx, fi, &psp_ret);
> >> +	if (ret)
> >> +		return ret;
> >> +	if (ret != SEV_RET_SUCCESS)
> >> +		return -EFAULT;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static bool sev_tio_present(struct sev_device *sev)
> >> +{
> >> +	struct sev_snp_feature_info fi = { 0 };
> >> +	bool present;
> >> +
> >> +	if (snp_get_feature_info(sev, 0, &fi))
> > 
> > ...since the caller does not care?
> 
> sev_tio_present() does not but other users of snp_get_feature_info() 
> (one is coming sooner that TIO) might, WIP.

...not a huge deal, but it definitely looked odd to see so much care to
return distinct error codes only to throw away the distinction.

