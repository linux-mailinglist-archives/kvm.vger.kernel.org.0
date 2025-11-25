Return-Path: <kvm+bounces-64456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82786C8332B
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 04:15:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16D043AC00B
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 03:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C358C1FCFFC;
	Tue, 25 Nov 2025 03:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bc8t7jBS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC47C1DDC33;
	Tue, 25 Nov 2025 03:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764040516; cv=fail; b=dWIFk/xYiDDUx/o7s6VRQyi1YP7fk6Kixip99yDwoY3w9apm/3TdwgqDx7rDmPnaItmxjIOhwfis+Svt8NXVY8Xp7OhEqt90j4RoFSKHbr8RmsH/tL1dxK5nzLWTLGxhq/YrXj5CpFZatvN7cxZFFRx2lilFbKKZh9w9HU8rHJ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764040516; c=relaxed/simple;
	bh=BdMJHJj9ia6OK5UnruuFReqsYgFte2tehwwvIy5kkWc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lBB0XDig4caQdbl6J4OSadphh6VSssXdH8wvQVPrNdQIg+zGpRgNZzNGkcr/jjq/Pmr+VVwq1zQYR3MwtLa5z5IluugvlCrQiq5pE8jlKbEYAnD0uhUW9xqytOagc3HGv5NBBhjsi8SR7zaKwvV11mLCZ5AA2B1ZrXBP4XPONCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bc8t7jBS; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764040515; x=1795576515;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=BdMJHJj9ia6OK5UnruuFReqsYgFte2tehwwvIy5kkWc=;
  b=bc8t7jBSsOICvXgG7CAyk6y3HIUFHHW3LqROZFI7Eq0aXx5VE1eQNxBF
   fedYDcBw6QSvNJD7iTez5LCmaW5NLmRhbtS0tqvqry97T9RxgSghRGQLQ
   jvRAoMmHUXohe3Tcf7oWxWI/Mz6NzumMjMZMLBC1myHNYVJK7t6Joh4ui
   /tlrTIGBg4qi8fzdvtnlFUOQC4E8HqopJSNDWhQ1W5+97V7Lh/lSAGclq
   e1BX8Soc7d3OwXPHef8x5lR1uCHjtW+iCVglDJgJahCvIXzdAgSPYmTxz
   E0YjVmI/yiFf1aIc03/PcsjsYuYd53z5GjqIflT7qLyjA2+EW41xcqKGO
   w==;
X-CSE-ConnectionGUID: KCpmTpj1SeaXVJxvNNWIIQ==
X-CSE-MsgGUID: g/z8BAC8SmidRnV8JY123g==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="77163686"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="77163686"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 19:15:14 -0800
X-CSE-ConnectionGUID: 5SBAri3uTGOC0eUoSCiw6A==
X-CSE-MsgGUID: Z7h95KEHTwiiuAip5Juwrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="223487966"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 19:15:13 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 24 Nov 2025 19:15:13 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 24 Nov 2025 19:15:13 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.14) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 24 Nov 2025 19:15:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h2tVT6vj0YgNdBIg1HAHcjqO/h0O9cj65bPL6ABgQJWrDszr83GlrlzoOSs+ixfAISZOdvuMAdU8tErC8M/dazJAf1eNjSSyGV6yDROQWztkRW5OCxqdORBB1EhK0hu+Y/X3JnAg0E4nzbMB+37DQSogefAWuqeiZpP7oFy4207wazeFJDw/DWnBEoPj4XaeP5N8EKluCpAdzl8S+BpQxZg/wVJky1xJcTYrHq82+PUClltQTOnNauO/rM2k25VQtiMdqHxKu7/Bizi3y2+2w+3R9CyTY+H1gkqa+Kx6H1rXdx+xtD8a3HogfJnBY34IOOmt4rsbKfY6ZPJ6j5MeWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XVANLCqSu+K5Y54Iozq7z7mYoFCOUZUA65p4CDuyR1k=;
 b=y5UznoqChbeqctOKyKKiRZY3sXsxNazT+cHX5ZMdb1HCAkF2be7k9haxcQZC2uA3ZZPbAxdD5RNdlAikqte77euS75yvcCAb6u11DUAfQF1l1Q6cZ6N/JXtN51z8gPTk9nIAJkZSfk2e5wW2SfAa64MGUB+IHghQFVCkkpsKxjPm1mj2we3sw0KR4FvvTMQ8YG/T/9eAcMXhgjx5wiAAy+KvThyVy3ZIjCIup0aMOmIAKESO8XfCnRsjRDOqf/VJub9GkSYzOfJfUGFTZv8Qo3vrSomcC1q29z5eZCAZZJnuVGmS4VkU5wVe6L2DvEfTeWVbaZLYtUkXxNFYzxJejg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB6927.namprd11.prod.outlook.com (2603:10b6:510:225::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 03:15:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 03:15:04 +0000
Date: Tue, 25 Nov 2025 11:13:25 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
Message-ID: <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com>
 <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
 <20251121124314.36zlpzhwm5zglih2@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251121124314.36zlpzhwm5zglih2@amd.com>
X-ClientProxiedBy: TP0P295CA0022.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:5::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB6927:EE_
X-MS-Office365-Filtering-Correlation-Id: ea6e3544-69a5-4e5d-0093-08de2bd0d403
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1R438SEfhpsWo6JWx7Bp9TVJeOlGqVekY+wdJjjJxjOoOpYmCM3c3UMpO0we?=
 =?us-ascii?Q?zhDR7ic8zdJZLKAcfkXOOweykksIVgqdbd1xR8wmmBU5DWu5CcIOTNnpxdpT?=
 =?us-ascii?Q?gDmojFJ824gsqiaVBGYUVdtRO1std9YO9S14jHla5V/5+vMiB/xFoZRoOez1?=
 =?us-ascii?Q?VV29koT7qoZvuV0dTG+yaCLPQ+Xwfh+AkIIFsn8F37P+kDT5rfeEd5cHHW9g?=
 =?us-ascii?Q?HcYZdhoeReDwM9TB8QXykiMPq3bpGMNoAj79XG4q/bEP4DvTMDxeGkMdmb4/?=
 =?us-ascii?Q?SUVO1TrgWSxHJDvPHKH2iCDCZyC58LecuWiYimCFdA4wzbT0I26/m2hpi+d6?=
 =?us-ascii?Q?umlE6RYqd7yvlFAH7KwD8WSat1NPw4NDXM2h7GBs2Je+52n5Ou+r3PBWbP9h?=
 =?us-ascii?Q?VZZESo8hc3MyyDUR0CG2dXoasVqU4px5eLvS05VV89NduJ8eoIOXZLaRZF7h?=
 =?us-ascii?Q?VyyxTAKqaNTyfAKB20nj+6TclwJURAPws2hcLPza8TIkn5Vj1+vxmMouASoF?=
 =?us-ascii?Q?e1yV1IeROt7HdXudyEeROf37wETwoJy6Y6hXgwzTKiioWFtmF2pjyGub67Gd?=
 =?us-ascii?Q?9TVhZ6glckwnUm520TrgVuaOu+Yzy8GekTLYC3mowmbsDdtT9oleLYihUX2N?=
 =?us-ascii?Q?6xe9SFDyshZj2S8evTp8edfsnDfvZhQzQz+b/0WH2/fbIpwJb/eBNFS2Mlpl?=
 =?us-ascii?Q?sdmYfg237eR0moLe98Z2XTuKZqLbdGZGUoEGxBmyTQQmnQqX82g/xvZFIa8A?=
 =?us-ascii?Q?2fMXtIOt1Wh4G0UQ3wpRbgpPR6HzkXrC2HsAVZSOr8at/SKdjsaOfVmuEiA4?=
 =?us-ascii?Q?r55TiBAiuBXa8Ai9OBHUk5Qc3wMbb4y1RwvW31xprD0KUO9tFkQc61JntmGr?=
 =?us-ascii?Q?cxl4xblnpSJc21dyTwkPnHG1edX6ENspprNUykDTLbVxKWDhz0uBXRI5ai6A?=
 =?us-ascii?Q?I2ivncyGlJYvCwWpdZ/42eyzi+XnCQoXl19X+1r6DH8Ivp/VJy5+5geZ2c9S?=
 =?us-ascii?Q?UjnYKf+zhVuA2VwCtPdwTT5lC9VskD1PLvFHwJgs4txWKAgprTWTBvJCyN5P?=
 =?us-ascii?Q?DebczMUwh9O3350ghVRrYi1ibTLfajR8xWQwp4BI0AgQ4Dqi8647q0o5mpR7?=
 =?us-ascii?Q?dtN17fWdT67wtxr3k5AUQr4XXADFoayxMv/oqM26gqcK2lhbz+BWqUKDBGoG?=
 =?us-ascii?Q?ryiECNm42717+pD7m8NEEUkTz/zwfLGkCzGQdAU6ACtOjG4jMxIa//IiAMT0?=
 =?us-ascii?Q?rbnGsOO7FV7Q12aS9LlfDL/BbaGcU+dU9PDmnr/lfr3AuOWfWrcD1wUCB10S?=
 =?us-ascii?Q?N/os2Nwp6ykowj2lHTD3oQX2vC6MYmSl/TgsaHjMx6f1x5UDui3hMFNRZ/jS?=
 =?us-ascii?Q?aqFKJnApWSncFJ0tCy5jwFCXpbvEqo28SmyGLivM34qYYrUwpVVjoz46HarK?=
 =?us-ascii?Q?M//PfYLRLvUxPhfzaxvVv5BTFL+ItRF+eHZK0WRmNd3ISjV6+7LpHA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IL8ePmITr98BzmUIqaHoN35i81lq50gxiFD4Y2iP7voM5bS193XXv0T2+To2?=
 =?us-ascii?Q?i1PvsgT4v/eahvmt0GlPLn/wYuEHVGOAxKyicYY/h7Fpz1MHprhNhGJ8BMK3?=
 =?us-ascii?Q?z/+vKSTEmyvuKnexlus7Y2YIcXPskDVBgAXM2jeQHvZE30U2D6ZAqqY37YWe?=
 =?us-ascii?Q?K2IG9Yc7V5kZAQgBQPbPecPVuinP5tH+9FlAWBBz6Ytn/z+cvIQ1N4LiSS0C?=
 =?us-ascii?Q?C+kQJoPIyivCOBXTSKlAGhndigBXeuxdnOBr5vCDkboUhYVgp20dC/NTT/h+?=
 =?us-ascii?Q?gDfsv9xHN3hBqjZHaQxPc6HmP+VsuEj4NTfrukdhenh4TvgbXGn5uFcJJ7uC?=
 =?us-ascii?Q?E55JuvZkMsbVxTPWw/nrLwJbOE2dRn+ecgsQzhqtIi31tA3vNoP2gGn7mh1k?=
 =?us-ascii?Q?qJ3FUmZuRg20pKLQ8Wh6h/v1CSJt2/thAqzUujS9H0h9F8sEjrk+Npj5pVcQ?=
 =?us-ascii?Q?j30iKPy77sRlpZEmNa8v1yUDP+/XoOSMm0xZYOGop1grrcpN5tWdL5EbDGST?=
 =?us-ascii?Q?jcftgfHJxmZzWwbcDJk52EdNT3Amd77bVZX8KXjwfVLF37VorrCdxagnLr8d?=
 =?us-ascii?Q?4HSjGM8M+71+kKwVgmiFmKJzoEdKNUy3O2/qMR8XwopAVHhq9UZRzxaHgjpy?=
 =?us-ascii?Q?7qdZS7Y3B1BNcr9WHofdGyUZ0ZSo8KdoPxidaqfrMNEWiF1LdddxpFvvKcXe?=
 =?us-ascii?Q?18ik7QvLrzcZXB7DoTRkuFOZ510auzuY0xJCa8PxodemGO/x+sz48jue25c9?=
 =?us-ascii?Q?EsFcoJ9mcf/DFH+5u0R2uho0It89Dda0kzD8KUQjMbudru0dEZOZaMikZWC6?=
 =?us-ascii?Q?3+8QwR2qe9H0/cwQvULYU09SMKqK/PS5gCj/bfo7DDRSMrMqHggyMVOqB9Ub?=
 =?us-ascii?Q?Dc1hXWfANPaJqbs1K5AQ8GIjT8rUJ30sL0eoflVyf0XxAZRNuCc+Vv/M/EB8?=
 =?us-ascii?Q?OhyeKizKHe0QRjm7iqhidE6bBcsyDb7odw0xmetpRisjm5yHywRJmIkEXRPh?=
 =?us-ascii?Q?+pZ7XM//p04DDcZsDM2sxnp3uBMJFelW3k8uXU1y6Cg/zqiQ+DMTojjlXYcZ?=
 =?us-ascii?Q?AmNcYf2FYvH5lWxs72Yw8iQNZdVCecKtoi4jNbw172mI43DYtlamEVtrIBqu?=
 =?us-ascii?Q?+Kbi1ukVsqO24QfeLjHDcgvz0NEcKAThMioaxdjE2JWLZGdCRqRIShSMYGjU?=
 =?us-ascii?Q?Hwt7A+6DEChW2duCq8GXIWMjcKocYRm4fUvTRfBHufeImkc4OCEnDCJPPbtL?=
 =?us-ascii?Q?yaOLKy+OYrrccpRDzup8QddEuntD0dEWApVH1076wDCmIbJEBCXxW6vX4f0c?=
 =?us-ascii?Q?Vujz7IKY3lRpsqmWvAfzIl0fZCP3et1MjH92Qia+G2ZPRq9U8Fxmgph8GUxL?=
 =?us-ascii?Q?/UrwzflcEm7fUzXZ4g2E5mGdNX0BFBUQ7F3sGKa1E2PVF+DMzsR3x+iL3LIK?=
 =?us-ascii?Q?mtS8yEMI7kcURILVTZXK4h6FOGk5WGDC89WRPts3EnzUvRljDWUzsorGah38?=
 =?us-ascii?Q?KqzBuCrh9qGeNoP+gAc7zzE/Egccg1S6BqjmJ5SoAwpPpinHKfvSrf702hbW?=
 =?us-ascii?Q?6VkCjIHzNjPfQmqZPaYwntum0qmiAmetAd+VPeoN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea6e3544-69a5-4e5d-0093-08de2bd0d403
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 03:15:04.4733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SMIq3dsVdgIfPnfgYTV3yTHLn31ApDQoiglpVG1tRCnQpmOPz8GHBQcKalIdnYbyNNZPouyzZOgJS8xRFymsTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6927
X-OriginatorOrg: intel.com

On Fri, Nov 21, 2025 at 06:43:14AM -0600, Michael Roth wrote:
> On Thu, Nov 20, 2025 at 05:12:55PM +0800, Yan Zhao wrote:
> > On Thu, Nov 13, 2025 at 05:07:57PM -0600, Michael Roth wrote:
> > > @@ -797,19 +782,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > >  {
> > >  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > >  	struct folio *folio;
> > > -	bool is_prepared = false;
> > >  	int r = 0;
> > >  
> > >  	CLASS(gmem_get_file, file)(slot);
> > >  	if (!file)
> > >  		return -EFAULT;
> > >  
> > > -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> > > +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
> > >  	if (IS_ERR(folio))
> > >  		return PTR_ERR(folio);
> > >  
> > > -	if (!is_prepared)
> > > -		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > > +	if (!folio_test_uptodate(folio)) {
> > > +		unsigned long i, nr_pages = folio_nr_pages(folio);
> > > +
> > > +		for (i = 0; i < nr_pages; i++)
> > > +			clear_highpage(folio_page(folio, i));
> > > +		folio_mark_uptodate(folio);
> > Here, the entire folio is cleared only when the folio is not marked uptodate.
> > Then, please check my questions at the bottom
> 
> Yes, in this patch at least where I tried to mirror the current logic. I
> would not be surprised if we need to rework things for inplace/hugepage
> support though, but decoupling 'preparation' from the uptodate flag is
> the main goal here.
Could you elaborate a little why the decoupling is needed if it's not for
hugepage?


> > > +	}
> > > +
> > > +	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > >  
> > >  	folio_unlock(folio);
> > >  
> > > @@ -852,7 +843,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > >  		struct folio *folio;
> > >  		gfn_t gfn = start_gfn + i;
> > >  		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > > -		bool is_prepared = false;
> > >  		kvm_pfn_t pfn;
> > >  
> > >  		if (signal_pending(current)) {
> > > @@ -860,19 +850,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > >  			break;
> > >  		}
> > >  
> > > -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> > > +		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
> > >  		if (IS_ERR(folio)) {
> > >  			ret = PTR_ERR(folio);
> > >  			break;
> > >  		}
> > >  
> > > -		if (is_prepared) {
> > > -			folio_unlock(folio);
> > > -			folio_put(folio);
> > > -			ret = -EEXIST;
> > > -			break;
> > > -		}
> > > -
> > >  		folio_unlock(folio);
> > >  		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> > >  			(npages - i) < (1 << max_order));
> > TDX could hit this warning easily when npages == 1, max_order == 9.
> 
> Yes, this will need to change to handle that. I don't think I had to
> change this for previous iterations of SNP hugepage support, but
> there are definitely cases where a sub-2M range might get populated 
> even though it's backed by a 2M folio, so I'm not sure why I didn't
> hit it there.
> 
> But I'm taking Sean's cue on touching as little of the existing
> hugepage logic as possible in this particular series so we can revisit
> the remaining changes with some better context.
Frankly, I don't understand why this patch 1 is required if we only want "moving
GUP out of post_populate()" to work for 4KB folios.

> > 
> > > @@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > >  		p = src ? src + i * PAGE_SIZE : NULL;
> > >  		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> > >  		if (!ret)
> > > -			kvm_gmem_mark_prepared(folio);
> > > +			folio_mark_uptodate(folio);
> > As also asked in [1], why is the entire folio marked as uptodate here? Why does
> > kvm_gmem_get_pfn() clear all pages of a huge folio when the folio isn't marked
> > uptodate?
> 
> Quoting your example from[1] for more context:
> 
> > I also have a question about this patch:
> > 
> > Suppose there's a 2MB huge folio A, where
> > A1 and A2 are 4KB pages belonging to folio A.
> > 
> > (1) kvm_gmem_populate() invokes __kvm_gmem_get_pfn() and gets folio A.
> >     It adds page A1 and invokes folio_mark_uptodate() on folio A.
> 
> In SNP hugepage patchset you responded to, it would only mark A1 as
You mean code in
https://github.com/amdese/linux/commits/snp-inplace-conversion-rfc1 ?

> prepared/cleared. There was 4K-granularity tracking added to handle this.
I don't find the code that marks only A1 as "prepared/cleared".
Instead, I just found folio_mark_uptodate() is invoked by kvm_gmem_populate()
to mark the entire folio A as uptodate.

However, according to your statement below that "uptodate flag only tracks
whether a folio has been cleared", I don't follow why and where the entire folio
A would be cleared if kvm_gmem_populate() only adds page A1.

> There was an odd subtlety in that series though: it was defaulting to the
> folio_order() for the prep-tracking/post-populate, but it would then clamp
> it down based on the max order possible according whether that particular
> order was a homogenous range of KVM_MEMORY_ATTRIBUTE_PRIVATE. Which is not
> a great way to handle things, and I don't remember if I'd actually intended
> to implement it that way or not... that's probably why I never tripped over
> the WARN_ON() above, now that I think of it.
> 
> But neither of these these apply to any current plans for hugepage support
> that I'm aware of, so probably not worth working through what that series
> did and look at this from a fresh perspective.
> 
> > 
> > (2) kvm_gmem_get_pfn() later faults in page A2.
> >     As folio A is uptodate, clear_highpage() is not invoked on page A2.
> >     kvm_gmem_prepare_folio() is invoked on the whole folio A.
> > 
> > (2) could occur at least in TDX when only a part the 2MB page is added as guest
> > initial memory.
> > 
> > My questions:
> > - Would (2) occur on SEV?
> > - If it does, is the lack of clear_highpage() on A2 a problem ?
> > - Is invoking gmem_prepare on page A1 a problem?
> 
> Assuming this patch goes upstream in some form, we will now have the
> following major differences versus previous code:
> 
>   1) uptodate flag only tracks whether a folio has been cleared
>   2) gmem always calls kvm_arch_gmem_prepare() via kvm_gmem_get_pfn() and
>      the architecture can handle it's own tracking at whatever granularity
>      it likes.
2) looks good to me.

> My hope is that 1) can similarly be done in such a way that gmem does not
> need to track things at sub-hugepage granularity and necessitate the need
> for some new data structure/state/flag to track sub-page status.
I actually don't understand what uptodate flag helps gmem to track.
Why can't clear_highpage() be done inside arch specific code? TDX doesn't need
this clearing after all.

> My understanding based on prior discussion in guest_memfd calls was that
> it would be okay to go ahead and clear the entire folio at initial allocation
> time, and basically never mess with it again. It was also my understanding
That's where I don't follow in this patch.
I don't see where the entire folio A is cleared if it's only partially mapped by
kvm_gmem_populate(). kvm_gmem_get_pfn() won't clear folio A either due to
kvm_gmem_populate() has set the uptodate flag.

> that for TDX it might even be optimal to completely skip clearing the folio
> if it is getting mapped into SecureEPT as a hugepage since the TDX module
> would handle that, but that maybe conversely after private->shared there
> would be some need to reclear... I'll try to find that discussion and
> refresh. Vishal I believe suggested some flags to provide more control over
> this behavior.
> 
> > 
> > It's possible (at least for TDX) that a huge folio is only partially populated
> > by kvm_gmem_populate(). Then kvm_gmem_get_pfn() faults in another part of the
> > huge folio. For example, in TDX, GFN 0x81f belongs to the init memory region,
> > while GFN 0x820 is faulted after TD is running. However, these two GFNs can
> > belong to the same folio of order 9.
> 
> Would the above scheme of clearing the entire folio up front and not re-clearing
> at fault time work for this case?
This case doesn't affect TDX, because TDX clearing private pages internally in
SEAM APIs. So, as long as kvm_gmem_get_pfn() does not invoke clear_highpage()
after making a folio private, it works fine for TDX.

I was just trying to understand why SNP needs the clearing of entire folio in
kvm_gmem_get_pfn() while I don't see how the entire folio is cleared when it's
partially mapped in kvm_gmem_populate().
Also, I'm wondering if it would be better if SNP could move the clearing of
folio into something like kvm_arch_gmem_clear(), just as kvm_arch_gmem_prepare()
which is always invoked by kvm_gmem_get_pfn() and the architecture can handle
it's own tracking at whatever granularity.

 
> > Note: the current code should not impact TDX. I'm just asking out of curiosity:)
> > 
> > [1] https://lore.kernel.org/all/aQ3uj4BZL6uFQzrD@yzhao56-desk.sh.intel.com/
> > 
> >  

