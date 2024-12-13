Return-Path: <kvm+bounces-33679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC2E9F0180
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 02:05:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74B1716B21C
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 01:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF49179BF;
	Fri, 13 Dec 2024 01:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ddN2ZPLJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7F117BA1;
	Fri, 13 Dec 2024 01:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051900; cv=fail; b=psP0LM7dkmxZWRH+RyYkKJRzPCBpavqalOE03nPI+HGvL2K1tUu+Lm7UysTEZ/b7TmB9BRKv7njeFwXQxynWyfgr45t/B1i2yIBRzLAsJPxR4VAsLETIxr7eKvN+MaLTqud3N1edwSHOIcnZ5r8ZenwgVeBGXURKJzsZdU3vQzU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051900; c=relaxed/simple;
	bh=CXYE2Y6UCHUEno8H+lZTIzJiqssEIn1DeKpCxfGak9M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ulq7jeXTeWXw7uG4zC5iJj7hP4xSavu0HaE7de8r0XbEDNQgWzkwQk2yGJ34JZSonUgBGM/QcoR72XcSYYNJg34vMlZXtSRkaehn+Y4j2f5eW5zJfUA7vCIeTc0jD/yrIfBOK+olNqPKaxY7H4TOsFZ6cXqdK3LQc9k5hNkhPeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ddN2ZPLJ; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734051899; x=1765587899;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=CXYE2Y6UCHUEno8H+lZTIzJiqssEIn1DeKpCxfGak9M=;
  b=ddN2ZPLJeb/e1ROGMv41LPI0Ve9OjCEqo6H1P2I3PORBkSFRL/+3hO2t
   +FlWBot1vZmZWZG1mZeugEViqtOjevZlS+ddN1vZ3xqW9RMOAmNZWGFMu
   Q+WWKa+bI7jkAEdFo8F4Uud+dq71VvbXJaT5WOqilyZ1BQDgCIFWeqR+H
   BgyULtdagSHUVAy7stA2ECcK4pVrafZ8AWsMSUaWGoy8foGgozlf3dFPy
   lre4oqvwMNPVq5sr5bTWjAkAkVLjxY+IPG6o0bkmYfziRa3kCIzgDW97H
   XtpkeGj4hca31+VBBzvWlfwEDbnQhldwXrmBpuByzmXsQWvDUtoZ5RUue
   w==;
X-CSE-ConnectionGUID: 0BRuXv35RiKSV3NvjcRoTw==
X-CSE-MsgGUID: pss+q7MGTwKNjtM9eSbm2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="34628073"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="34628073"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 17:04:58 -0800
X-CSE-ConnectionGUID: ZMh/2N/LT125kJUoJ+AfiQ==
X-CSE-MsgGUID: xyqt7ATVRBGIqvi5KGcF2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="100555479"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Dec 2024 17:04:57 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 12 Dec 2024 17:04:57 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 12 Dec 2024 17:04:57 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 12 Dec 2024 17:04:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=weJ4I9FWpJri1L1mLigEb/3JBy3tfBdGeDL0EZn7GWRERnDGWxT7j3CDQigEMsuPrIhqCI6fb2OIjIovE8POclOfjcjuJnvV0NcVAFCMyCnlbcjUEMhDCNBl3Ij0Bnjhhd/wX7NrwuVFH9736AYONEY8P0hl/KXQD847rHXE67sVXgtNhpD3Tgf/SFj8IPwKnTxQQxmGcj8YbjY0sK9/FpqGK3JxSNiXLGmeH23auVrvq31HcZdTD5rz8tLhzdZ+/71FESrgmpZrqEtiAcCmnUdjsU2ZaIa8Yd2Cb8uV4rT1qYZIEMnuwE4X6t+9Iy7KnMrQ8qYzVf5Oax5fA2+M8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wJvTH9YzvHjq2RhQFuyiKZGU3pFXacA3nNuO7F3ZXxo=;
 b=c00JPFMk7CCCWi6njRiEAdrI2M7c+CB0OCbx8B8SDoez0SPf8lHWzeNuTgcBkupuFQlEvKMHFp2PUWgQJlboxKaPoPb0g79wucDU7FukMK0GkchVmEyJISTb+JzCUriIZyHt7E7sNvvVHMpfuMM5VLN9Rq6epg+DzfLBgjB4z7F5bYO1aOdSDIKaWFKfP7eGqr4htacytR/+UPzSg8aDRNNiitfrlnEZNOX/CFtJ5BknjzkljviHXxcfaqw/sRRmVW4BaJl0nvE6zjm/NNa5aYjezCZn7jDJR90blgFL+cG1QyuMW7ciPm9YTv8Gs6RynIQ5mHRrcZMrjvnxFpPP1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB6194.namprd11.prod.outlook.com (2603:10b6:208:3ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Fri, 13 Dec
 2024 01:04:26 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8230.016; Fri, 13 Dec 2024
 01:04:26 +0000
Date: Fri, 13 Dec 2024 09:01:34 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>
CC: <dave.hansen@linux.intel.com>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>,
	<isaku.yamahata@gmail.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [RFC PATCH 0/2] SEPT SEAMCALL retry proposal
Message-ID: <Z1uHbl0AeGsjLf5K@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
 <20241121115139.26338-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241121115139.26338-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: SG2PR06CA0216.apcprd06.prod.outlook.com
 (2603:1096:4:68::24) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB6194:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ad23246-8089-4e71-8ce4-08dd1b1216bb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|3613699012;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?G81piytwT+pyFHbpfz3eJWaMQsyAq1nHxiBYfBvQCs3S8T1WSGemS5WqWHBU?=
 =?us-ascii?Q?qA5LfXUblqies5gY02gbncfnyv8WeGtJ9rnfWR3CQF3XOpBtiePIZ4e0E7U1?=
 =?us-ascii?Q?YzTjW/16FuLzMf6Z5VmrA8xqzAj42y8KJ9FKxZjPiNX+oSubVCx3qn0ApCDr?=
 =?us-ascii?Q?bIJqqAf5WaMSOWp6JEhDgpU5d71MFy85bQvzwlNPXgpt3IUFSFi4CD7FlKSd?=
 =?us-ascii?Q?W6xSBuRIPOduo7w4ha1LBwdlf6adVD70vHlgwxuKj2OoRODmPm1y1uY8PdSi?=
 =?us-ascii?Q?jTC3PORJYasi/j64zoEqsmTlMPlGyC4rlpFjyjiMSKyh2YRrlgmw7OemQjAo?=
 =?us-ascii?Q?zQlwvMLhgy1y7vjsQmnz20ll0kSp8t6mKrT6e+DBowt7pa5zgU6nOyPjD3mi?=
 =?us-ascii?Q?EYCiHvZqjdiUoSiLBLGG0eT7Aa+VpRF6bw0qOARxvaVPc50CEKXfylKOzhXE?=
 =?us-ascii?Q?idvp6USu+nK9OrzdZbzsxpTegWx2eiZne3kbNh5rXqME0ylNBMMwQBl/vE5S?=
 =?us-ascii?Q?jlgzc39Io4mR/lWlXIjnHPwCypuV8zXTJdQ9uU0BWXp2/RNwiKXCTidwhggS?=
 =?us-ascii?Q?tN/nox23jX5YVD0qyzUnCEsBcRL5hbmFVdPDnlyUpP7+0Y7YjtbiYASU5nbA?=
 =?us-ascii?Q?b++2G85/wSb/0tVuDqRRHCxTubvhuEXGoMvVRrAk+9eVCEPtYS2OQ9gZ8mBl?=
 =?us-ascii?Q?yO+doDtnfAByXUY2sLiwaO2SO8F8VTvRV0QPRw157FISb2CpPohg6H6FX2ii?=
 =?us-ascii?Q?5yn66LkuNKQI3HFDtJIpxWsWMVPeL3CKYhjTBJ6otaU8Jm8KbsaEkUkOSU2B?=
 =?us-ascii?Q?T1DvSxUB2KEHXZfmRYjzUkQ91NLxekbM9ms/zogSFrQjyagW6lqqZFvsTN8A?=
 =?us-ascii?Q?wtB7pMf5X/FJxPpKdiAZOjqQcYXGS1uhDGAQhdXzz8xcWm3aKGHIf7CHIa7B?=
 =?us-ascii?Q?hJF3gh5Ce+7LKLGF6v0lcRzMELVDsvW8lXmCqgyG1gTazbxVSDAhxkSzxVMs?=
 =?us-ascii?Q?foJVtTHsDRZw5Sy1tGDnjLh8vVKXwuhf3nUN2bS7M0t6ufvDCoCvI1jWzIVw?=
 =?us-ascii?Q?+2VObZGOUWUCTwTg/60iTMfwaZfnnLuDFFF3Q1NzH7jR+4szPyFr7gKarG5R?=
 =?us-ascii?Q?g/oZ4ppXu9fEsKMDlXvPe+x9khvhpjc3QBJTr03/aVAx+09cm0DjA8yisi7p?=
 =?us-ascii?Q?jc6v5ShohVG0vula3DKzGgXKf8JEDvCksACqkWOMehONnUt8nIpGJqrjElJ7?=
 =?us-ascii?Q?o8O5WgIqCThxn/h0p5L2wFzkI4NxF1Yfbx7RgZN7LUf845L0thnDx8wZwTtX?=
 =?us-ascii?Q?AJEdGxtdf1Q1EEGHd2TieSPQudQLCJ/hxIgw4BrMhdqILCdVlvVhwkdq9ktS?=
 =?us-ascii?Q?OzfAVW8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DUfZ9BmVXe3AzqQR35un401ISByZDThxjj/nFq20J+33Dx9fWFSTwwTs167d?=
 =?us-ascii?Q?ISh5ARmJIrqPik0iLv5v2kfK71DvZ62HYAMikosbyMbuJe/1XJ7VlKO99ljk?=
 =?us-ascii?Q?W82mBn9T+MAl6Hk1zNjt5SGZg9NrPMZZzXx62/dM2ZCf5gBea+q18f02SZdl?=
 =?us-ascii?Q?BlRdaMw+DO1GLK5svMP2lZ3pO2r2yYgRjpKpITEdCXESNmK0M4guBSxnn4eS?=
 =?us-ascii?Q?CuLt0NHB05AX25sXXkIJOXnsg5yYVtJdHoz7PFN+IS/R9uRId4kvs3GHFv1b?=
 =?us-ascii?Q?fNcsPAozjMR31UPwXFFBbEL2IdgbYu2CfJpORWNCxFKdNCSOAiRSe6ou/EUJ?=
 =?us-ascii?Q?uNkMaaCrAU9euZiaYDoJKVOyQgzHV2Nrx8bc+TO4yLgP/q+RZDWC+4yBc/+U?=
 =?us-ascii?Q?75lWIoPNmZ0tSNq+umqhmC8WD8MSzJNeR96eO55qCOwfiQNFB0JU3HXzmM8N?=
 =?us-ascii?Q?HRVqFy7PkHYhIPQ+Rph0bY12iwgsvQScYdb0uIt/EEIWSJWta93EZWyMUdzd?=
 =?us-ascii?Q?2bxpbPZBbKYMDgmVuBxtNVMF6h/sD7R9knzZSg43wN9c3mjRCgdrktSOyhuA?=
 =?us-ascii?Q?wb0OL4pDBnU/DNknXGt1XJCGFexfU98IqyKU8I3XK8ksknRZs1K5nJ+4eO1b?=
 =?us-ascii?Q?g18CxZy8Gzk7v54gcmQgid4jDA3lh6OlfbgXWLxB55hy122TvqtwK6q7tCjK?=
 =?us-ascii?Q?YuevconZFo5Ull7Z8mOP0ZfTGKLHd6urobfyprR6W6x2J9Vrdp8Thu/sbVcm?=
 =?us-ascii?Q?2f7b/XYl2XHKsjGHF0XDrvIiTsCgwk7HQ2WAKKkNTwU5pPrim3uSyuKYvqZn?=
 =?us-ascii?Q?OWvKDX9c+20yo3I42ENklhPl5M+VMAuZZP9bJQQ4aoMRRS0VKyqyXQDjNBZE?=
 =?us-ascii?Q?MQtU9ZOSbKYeJI17gQ08H2ZKBvFGzCDwndT44hxaDuDAp873KCzn2DWp1eY8?=
 =?us-ascii?Q?Kdk5AJYbDgGFwu14tydWC6Ju4sOy5RiCN3i8I3Mn/6x1eEZL5h+kQ0bCN5v6?=
 =?us-ascii?Q?HdtfEWz2inMu0QGdU/LjRgTANs1bJCQgcx0gGEAnCcRFLiveBgUYa4+XiI+O?=
 =?us-ascii?Q?Ut6ewOI/URMYQoTYVGBpwloF2EtKHgK82kMUi/JIIoWjsKFPLqNSh4A2r++r?=
 =?us-ascii?Q?NdDGOI6ujWifmGgyJ6j5gyrYQ8MfIY5SuPug51KFyTdtcK1qKmhd3zxR8uBm?=
 =?us-ascii?Q?zPr3MpTCKxkPkz4yMcP/89FNfFOxnqD2CHX7jV+Gj4demvDKZ3CPASyZvMvN?=
 =?us-ascii?Q?PWmT7U0JmltZOVVYziGzMIORR/Agoa3rZwdmMmgXQmihLt/y+tJ4wA79YIgn?=
 =?us-ascii?Q?BEYnpIOM7A7OgmJklKX5tOu8ITpb3c0tdxb4HGaMJ3g02uT8Yt3+gjEsC9Ww?=
 =?us-ascii?Q?kr7HaKl5YjLJyM/83XZ7AOUcFJCfhR68d4hciDUq8n3IV7jTCum3VlP+EBbp?=
 =?us-ascii?Q?6IjJRWaoD0KYwfTD4yTybMDAkygprfnhZplax3rI1USe8dHGec2FbAxOj0+N?=
 =?us-ascii?Q?XVAsDn4MNl+LKHs/4G3nMxYfOU1iESpK5/ebxeR9odPIWjvNfCeCoyJtN0Y5?=
 =?us-ascii?Q?GxsapU8buy3PO75c9xwDCYx0DvhKgZace8Y+ASNh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ad23246-8089-4e71-8ce4-08dd1b1216bb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 01:04:26.3164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XbXsif2LyZMD0P6dfNvZLk9l6BgfLqDQfxiMke2KbnoXSgiYn1CTloX2gddpOBAPk9K47QfX/T5A1vtYghSEaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6194
X-OriginatorOrg: intel.com

On Thu, Nov 21, 2024 at 07:51:39PM +0800, Yan Zhao wrote:
> This SEPT SEAMCALL retry proposal aims to remove patch
> "[HACK] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT"
> [1] at the tail of v2 series "TDX MMU Part 2".
> 
> ==brief history==
> 
> In the v1 series 'TDX MMU Part 2', there were several discussions regarding
> the necessity of retrying SEPT-related SEAMCALLs up to 16 times within the
> SEAMCALL wrapper tdx_seamcall_sept().
> 
> The lock status of each SEAMCALL relevant to KVM was analyzed in [2].
> 
> The conclusion was that 16 retries was necessary because
> - tdh_vp_enter() contends with tdh_mem*() when 0-stepping is suspected.
> 
>   When the TDX module detects that EPT violations are caused by the same
>   RIP as in the last tdh_vp_enter() for 6 consecutive times, tdh_vp_enter()
>   will take SEPT tree lock and contend with tdh_mem*().
> 
> - tdg_mem_page_accept() can contend with other tdh_mem*().
> 
> 
> Sean provided several good suggestions[3], including:
> - Implement retries within TDX code when the TDP MMU returns
>   RET_PF_RETRY_FOZEN (for RET_PF_RETRY and frozen SPTE) to avoid triggering
>   0-step mitigation.
> - It's not necessary for tdg_mem_page_accept() to contend with tdh_mem*()
>   inside TDX module.
> - Use a method similar to KVM_REQ_MCLOCK_INPROGRESS to kick off vCPUs and
>   prevent tdh_vp_enter() during page uninstallation.
> 
> Yan later found out that only retry RET_PF_RETRY_FOZEN within TDX code is
> insufficient to prevent 0-step mitigation [4].
> 
> Rick and Yan then consulted TDX module team with findings that:
> - The threshold of zero-step mitigation is counted per vCPU.
>   It's of value 6 because
> 
>     "There can be at most 2 mapping faults on instruction fetch
>      (x86 macro-instructions length is at most 15 bytes) when the
>      instruction crosses page boundary; then there can be at most 2
>      mapping faults for each memory operand, when the operand crosses
>      page boundary. For most of x86 macro-instructions, there are up to 2
>      memory operands and each one of them is small, which brings us to
>      maximum 2+2*2 = 6 legal mapping faults."
>   
> - Besides tdg_mem_page_accept(),  tdg_mem_page_attr_rd/wr() can also 
>   contend with SEAMCALLs tdh_mem*().
> 
> So, we decided to make a proposal to tolerate 0-step mitigation.
> 
> ==proposal details==
> 
> The proposal discusses SEPT-related and TLB-flush-related SEAMCALLs
> together which are required for page installation and uninstallation.
> 
> These SEAMCALLs can be divided into three groups:
> Group 1: tdh_mem_page_add().
>          The SEAMCALL is invoked only during TD build time and therefore
>          KVM has ensured that no contention will occur.
> 
>          Proposal: (as in patch 1)
>          Just return error when TDX_OPERAND_BUSY is found.
> 
> Group 2: tdh_mem_sept_add(), tdh_mem_page_aug().
>          These two SEAMCALLs are invoked for page installation. 
>          They return TDX_OPERAND_BUSY when contending with tdh_vp_enter()
> 	 (due to 0-step mitigation) or TDCALLs tdg_mem_page_accept(),
> 	 tdg_mem_page_attr_rd/wr().
> 
>          Proposal: (as in patch 1)
>          - Return -EBUSY in KVM for TDX_OPERAND_BUSY to cause RET_PF_RETRY
>            to be returned in kvm_mmu_do_page_fault()/kvm_mmu_page_fault().
>          
>          - Inside TDX's EPT violation handler, retry on RET_PF_RETRY as
>            long as there are no pending signals/interrupts.
Alternatively, we can have the tdx_handle_ept_violation() do not retry
internally TDX.
Instead, keep the 16 times retries in tdx_seamcall_sept() for                    
tdh_mem_sept_add() and tdh_mem_page_aug() only, i.e. only for SEAMCALLs in       
Group 2.

> 
>          The retry inside TDX aims to reduce the count of tdh_vp_enter()
>          before resolving EPT violations in the local vCPU, thereby
>          minimizing contentions with other vCPUs. However, it can't
>          completely eliminate 0-step mitigation as it exits when there're
>          pending signals/interrupts and does not (and cannot) remove the
>          tdh_vp_enter() caused by KVM_EXIT_MEMORY_FAULT.
> 
>          Resources    SHARED  users      EXCLUSIVE users
>          ------------------------------------------------------------
>          SEPT tree  tdh_mem_sept_add     tdh_vp_enter(0-step mitigation)
>                     tdh_mem_page_aug
>          ------------------------------------------------------------
>          SEPT entry                      tdh_mem_sept_add (Host lock)
>                                          tdh_mem_page_aug (Host lock)
>                                          tdg_mem_page_accept (Guest lock)
>                                          tdg_mem_page_attr_rd (Guest lock)
>                                          tdg_mem_page_attr_wr (Guest lock)
> 
> Group 3: tdh_mem_range_block(), tdh_mem_track(), tdh_mem_page_remove().
>          These three SEAMCALLs are invoked for page uninstallation, with
>          KVM mmu_lock held for writing.
> 
>          Resources     SHARED users      EXCLUSIVE users
>          ------------------------------------------------------------
>          TDCS epoch    tdh_vp_enter      tdh_mem_track
>          ------------------------------------------------------------
>          SEPT tree  tdh_mem_page_remove  tdh_vp_enter (0-step mitigation)
>                                          tdh_mem_range_block   
>          ------------------------------------------------------------
>          SEPT entry                      tdh_mem_range_block (Host lock)
>                                          tdh_mem_page_remove (Host lock)
>                                          tdg_mem_page_accept (Guest lock)
>                                          tdg_mem_page_attr_rd (Guest lock)
>                                          tdg_mem_page_attr_wr (Guest lock)
> 
>          Proposal: (as in patch 2)
>          - Upon detection of TDX_OPERAND_BUSY, retry each SEAMCALL only
>            once.
>          - During the retry, kick off all vCPUs and prevent any vCPU from
>            entering to avoid potential contentions.
> 
>          This is because tdh_vp_enter() and TDCALLs are not protected by
>          KVM mmu_lock, and remove_external_spte() in KVM must not fail.
> 
> 
> 
> SEAMCALL                Lock Type        Resource 
> -----------------------------Group 1--------------------------------
> tdh_mem_page_add        EXCLUSIVE        TDR
>                         NO_LOCK          TDCS
>                         NO_LOCK          SEPT tree
>                         EXCLUSIVE        page to add
> 
> ----------------------------Group 2--------------------------------
> tdh_mem_sept_add        SHARED           TDR
>                         SHARED           TDCS
>                         SHARED           SEPT tree
>                         HOST,EXCLUSIVE   SEPT entry to modify
>                         EXCLUSIVE        page to add
> 
> 
> tdh_mem_page_aug        SHARED           TDR
>                         SHARED           TDCS
>                         SHARED           SEPT tree
>                         HOST,EXCLUSIVE   SEPT entry to modify
>                         EXCLUSIVE        page to aug
> 
> ----------------------------Group 3--------------------------------
> tdh_mem_range_block     SHARED           TDR
>                         SHARED           TDCS
>                         EXCLUSIVE        SEPT tree
>                         HOST,EXCLUSIVE   SEPT entry to modify
> 
> tdh_mem_track           SHARED           TDR
>                         SHARED           TDCS
>                         EXCLUSIVE        TDCS epoch
> 
> tdh_mem_page_remove     SHARED           TDR
>                         SHARED           TDCS
>                         SHARED           SEPT tree
>                         HOST,EXCLUSIVE   SEPT entry to modify
>                         EXCLUSIVE        page to remove
> 
> 
> [1] https://lore.kernel.org/all/20241112073909.22326-1-yan.y.zhao@intel.com
> [2] https://lore.kernel.org/kvm/ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com
> [3] https://lore.kernel.org/kvm/ZuR09EqzU1WbQYGd@google.com
> [4] https://lore.kernel.org/kvm/Zw%2FKElXSOf1xqLE7@yzhao56-desk.sh.intel.com
> 
> Yan Zhao (2):
>   KVM: TDX: Retry in TDX when installing TD private/sept pages
>   KVM: TDX: Kick off vCPUs when SEAMCALL is busy during TD page removal
> 
>  arch/x86/include/asm/kvm_host.h |   2 +
>  arch/x86/kvm/mmu/mmu.c          |   2 +-
>  arch/x86/kvm/vmx/tdx.c          | 102 +++++++++++++++++++++++++-------
>  3 files changed, 85 insertions(+), 21 deletions(-)
> 
> -- 
> 2.43.2
> 

