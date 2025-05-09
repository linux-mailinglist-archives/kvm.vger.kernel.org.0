Return-Path: <kvm+bounces-46051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BFBEAB0F9E
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D63FF5051BE
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73E5128DF3B;
	Fri,  9 May 2025 09:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jK+e/oiy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CAA28DF06;
	Fri,  9 May 2025 09:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746784355; cv=fail; b=Z5HuBkg03xTnQRGEZMTz28ZEKUw5g/wTILxGfNw5Lmlqww8dSNPcJ16qJhbxc2+aWywJ5tsbWQUZR/9Wl6iOu6+Dd3zDlC8tyz1Kst72Y/g3AY+c9ArVBkgZ3i20YV6sBNXCVKiQYeD26k0N+IhbXnb4/EJts02JyDtaB/ZloX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746784355; c=relaxed/simple;
	bh=S6mg4wzADWTNuc0ipLjv4sGoGorio6qBzL4VI3BgBDU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lkzGyLVbsKLR6SYqvodNNpgBhBpc47GOjmqdzJ07mUR1xYNMpFyxfQLN2sLaxIyx6NWKFC4GH/GQqtq1VTxcd9aU5s2ePgI0oSZJln4uCWQMWmha+Yr9hymJ/oVyyGBI5GJBXb0darCHvCFgVzQEuvCQYZaHuKcMQPzQzFMJgmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jK+e/oiy; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746784354; x=1778320354;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=S6mg4wzADWTNuc0ipLjv4sGoGorio6qBzL4VI3BgBDU=;
  b=jK+e/oiyJMxN1UhV5WnEL7860oY8R7Bysjeb9+GdpebFhD1KArt/BfyS
   342q7ZnSLVJFdRJFffi9IIj9OszPwIPJFlnvz1e/jf9lVPMcnI6vXvGW7
   +92nZzyIy3bGVI87fX09vRdUokd/pOX7sgA7rNmsYybgr+HjRLjyz3xwK
   Yi3RCq/K1dfrOyMNBwSVQEXHZhe1EMZcvnO/4rMXSldi0b20VgTbzWwCt
   6wz6x4jKLkLyFh29uHUvdQjhPdTvw2nyQJHk1Dtc0yjyWl2HZC0rdLHkJ
   2zvs/0xuKppNPgc0g6DWVZBUMWMvDW1QBY9TudnFqUoP2qISr/dPVjAOS
   w==;
X-CSE-ConnectionGUID: xnsWRQbYSe6iNA4UyxyRTA==
X-CSE-MsgGUID: 59OFo1v2Q5C6JI63uusYTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="51261853"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="51261853"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:52:33 -0700
X-CSE-ConnectionGUID: ecLRt3hIRVKNYdw0ijhEqg==
X-CSE-MsgGUID: X86a0hkoRoGf92i0gpcPzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="141523716"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:52:33 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 9 May 2025 02:52:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 9 May 2025 02:52:32 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 9 May 2025 02:52:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X/6rc8iXv0y6oz7yX6ZxLrHIh8fti9VaGKr4kgxnw+6ZeVfzL3odabJdHvyrEIFqNjt2ytFdEQQniHseeqs24UQIBD/t++V6SH9+5R17LbyZuJ9pCDbgazt9KUK+6Yfty/x3XArYJdRkfsaNanUgL2/Ac3iKydMi7cTMUMi1GjJn2o+zQ9njO8wfyH9IdsjaZDo1zSyuV5hgiN8Crn78crWEZKQYpEr2mnZ6TRBUXUwOjDsHGbL8b581nx2kjZfBM54yCjftMhDANKy19/f/OLZywE39EjLZRl7l6i9QhB3mpcTbawA2NzGEGshQC6KRSWMzHamqEdsNEoBeSZPvrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34UMahARd3Xtz8Al2++79PjaOvm7/zWFDc5HL2W0aFY=;
 b=eIK7cW3uB6iQJ87jVed9O1cmOSnT5sqJoFzyU4C6OasCA+30ss5+uvx8TZY8kqw7q29Rfpd+sRU2yzAZ5ylbzS6yxowzeEW8RIOC9QK+fsvZtqNf0d8jrWWFBGIj9k+cve6W9H3BsN98NurwF4rE0tv6ECfI1MKZgS/r9R0xXEE3bgVYeMElj5Lly6oiXU4s83nifZb5ALfan/YYWFljxqFaj+reMsYByGGCb7nh65pDI23zzLAfYFWfAFvgPQ8nMQ4zPkQwQCpX18WvzwfGIEXI0WOKiZpjZ5aHUUKQlH0RwxuFIMztDw3ZrtyjMiisbcP7PgrdojtmWqtynEkM9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM6PR11MB4548.namprd11.prod.outlook.com (2603:10b6:5:2ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Fri, 9 May
 2025 09:52:29 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Fri, 9 May 2025
 09:52:29 +0000
Date: Fri, 9 May 2025 17:52:16 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <rick.p.edgecombe@intel.com>,
	<isaku.yamahata@intel.com>, <kai.huang@intel.com>, <yan.y.zhao@intel.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 02/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Message-ID: <aB3QUKanj5KajTs9@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-3-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250502130828.4071412-3-kirill.shutemov@linux.intel.com>
X-ClientProxiedBy: SG2P153CA0008.APCP153.PROD.OUTLOOK.COM (2603:1096::18) To
 CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM6PR11MB4548:EE_
X-MS-Office365-Filtering-Correlation-Id: ba720e3d-1140-4859-ab3b-08dd8edf35ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?gcj+/zKlLR5xXWL6E3y2jYV1graR73VSslM+N58jea6Laa1h92CpF+lKe1r6?=
 =?us-ascii?Q?qmBihULaw16uP0RoiFt0nXqIZ0FLko8TybPjgG/upBBAMWAd6lPp95Nk44Ed?=
 =?us-ascii?Q?1lDRqgOJPrTnmKKYPd9tWtZR4gDPTtaWdVhHRFKvwSV1oJ7Ms1im9VGiPWMv?=
 =?us-ascii?Q?sul2UzreJVnaUClBtTmkeMuCN2kpC42CUJAdFMsAVDwNF70/BbwtgiIcOphZ?=
 =?us-ascii?Q?ke9dk/hhgk/L6F6IS6Fhwuymejw/bNJECtvbkhQGZaK519zV/3BFeCcd/Yd0?=
 =?us-ascii?Q?ULdFLWDbootJ6q+jUDIkmw2hwaE6jXQtW/JXVnO6JkkCsQ4htQMftYXL22ku?=
 =?us-ascii?Q?WS+29NlqVhJL/xSzDWpvQD1aaztwMUVtRUs0/0koCdtzBaTDr0m+pLtG9UHQ?=
 =?us-ascii?Q?iEg4+JAeE6IPp6ZXd97lNcR/ykqlG2Cc0iIVoUSHLiMGZ9G8hEbhPOmjtORA?=
 =?us-ascii?Q?51vyYpNIvMHDJ8yh6a83SG0DCWoQcL4aCL6ii/rqjRsuSyhiIUYCAJeI4uSC?=
 =?us-ascii?Q?y3Ux1CUqXFN/pzt+jKNw667rb8Za9MZ5M2OqtwtS6ebrNKJlxuzFrIIAG31Y?=
 =?us-ascii?Q?niGlhVdaKaPftldT4Db+zv9kWLG9psYrBrz8EwazDI5mO+OOGWpPdowp0Lx5?=
 =?us-ascii?Q?JriW1etSsrJOwXPAsgpXZ0kT5GC4qt7c9DMxx9svoLtO8n0M/GZBL1RJl0G3?=
 =?us-ascii?Q?K0n5O4s1ONs3pruuWytTK5WxA03ynFomiPZ4NGdBhJVKuz5maksBS/V5Qv3r?=
 =?us-ascii?Q?3SRUCpDziXhLsnFl+0Rr2FVk24CNkSrUSFjMY8G3fd9zMmAv60kCoce27n19?=
 =?us-ascii?Q?huEWbDRE2aST67AQbkenvbOaTV0gbCbtDUSpuB7y3Zw/Y8ZKIWA6L5bjr5W1?=
 =?us-ascii?Q?k7QHEiQ7Y3XhpDinqRplNm0mRrYVKR/3LIs+54BFFPCnu9feEkveV//Y3AJT?=
 =?us-ascii?Q?pGobethtyzTee9kWFJM+UJCj3haugsbAbHH4EDk2tj/CyVMOsLg5NDznozAK?=
 =?us-ascii?Q?cHqKUbUoPeyfcoSGzYpCXU31T08fB40viBVHG+H4hw+0zqmX/GV90dXMZ+Va?=
 =?us-ascii?Q?iGQiBdoYppxJIkv9XLstU03DQQjXqdbdwHYWxgkZmICoNLjRV91LRT9BedpG?=
 =?us-ascii?Q?yljD/TETDd5VbBwgZDg+R0Bk0csdajRdeA8CaaBNxK5omuE/WZ1MYU/2IwU4?=
 =?us-ascii?Q?U/Ha2oSBQrLny6cULBJ0aTxMRosxYBiqaLG0NEZ5ic3d+XsKXzY4VeBkQgx3?=
 =?us-ascii?Q?2Cx0luRaHfxwNBn926KbUsnPAR3A6iJdlLPTBxwuPOyWxCjAD7B5wfeFpQxL?=
 =?us-ascii?Q?LsdK5o1WmrRJrdqMACiR4kmOnrE70qSVA4sny2QnB43bD+mjU/YBZD1NWpGZ?=
 =?us-ascii?Q?mFUNDzMgdqGCO5607F0toO5PrpHtwCsthXNKmouJVE3MHEpN0Mbc2coRtvnK?=
 =?us-ascii?Q?SRTF87b6IGQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0dCQ4uE+8cVhHIyxJqRs2WIANRdSBWnR8ecg27v94spJltSRo5OlaZ3JGHnV?=
 =?us-ascii?Q?JTpJ1dTC7NLOJ98Y3DF5zMmx7INPVjOqg3Vcowu6UYfYYVrUjSLQeJ2phHyp?=
 =?us-ascii?Q?ED08yosPoFPqY8jWjT117gAlI9ajdnfi8TkftgbKv4kh9fKhB9517hPm8nT0?=
 =?us-ascii?Q?/2ssgYTLG2c6MpsOYmM6egH7mb/dIKVL8np0N0XkXXHhd7P7WbF0epl8+myz?=
 =?us-ascii?Q?b5sbqeP+bUgdb+4PBmGtUkwI9qJw3pvR4eumSZw8p+jtjQPeTvv0wdB8p0iV?=
 =?us-ascii?Q?iDKVtyWWmPN80MXAqvzpQ7RiYPN5HolaoX2UGuNgwWnBuIxzUCkCT00bJf50?=
 =?us-ascii?Q?lgBUJGbg641NIRe7jlaRlodX+HD9mpMfxXSa96BuPeKH3XWLh1A56LqARGka?=
 =?us-ascii?Q?lt4a8hSA9nOHWPllGTGZ/obzC4p8keVkF5yblKOvl7jba7bGdaNQ0D0hnTqY?=
 =?us-ascii?Q?WRt/atwEHbii4VmN290wDKKAOgqOUtnnMVY88AUZZHqMmQkmGsK58YGvRmGQ?=
 =?us-ascii?Q?wBNnAUUWVNz7QLI9WItxuWcQHg2iSBJH7kJ/oZ/xVNtekwxH6T6tHQeYZ6re?=
 =?us-ascii?Q?jVNLu8nJPApk8/IozytMOsP1dKl+g1xCXqHxUOu0vYlprUSP5b+w/3hj6Vq3?=
 =?us-ascii?Q?AEzvxfby3nJ37fl3uc2mjUMmSg/uwHyyN4kc1x5aN7Y+gugUUmSPFFSimJPp?=
 =?us-ascii?Q?UDYbLUw6UFAazPsPnfn5D8stVbfKSY1SugNIXEKbMqajvGOEC7xGRRFIODI1?=
 =?us-ascii?Q?diy2urwJlj7aXldL7FgJUfDwDld/dIxiMpY9FFtUr+XGSkd0bNNShdt9Aeri?=
 =?us-ascii?Q?dmTgFZIiSyxlB+WUot1/LNVkh7167FKXngcwOzFMCe5wEI2xu5qYD3HDe7UC?=
 =?us-ascii?Q?qOZ+6Tv+sR6B+R2GWHcWeZHY2CqkSfj1CpEveAjbXPzbCOxExL9simfddHmp?=
 =?us-ascii?Q?SUrjRQhxuxS5lHleFOhANgtGktJoIG7Qmx3U6j+1bU/lBNuv73N4+VIH+rJ/?=
 =?us-ascii?Q?ulvmptwYZy/K2WhYdmXDvaDX3Q3E1MNy+ligAWomt5cTEBfettUVCiNOf5Mi?=
 =?us-ascii?Q?zGa3skiom4WlGRc1czCJith0OtWyhwFTVpOUZ6G4Qe2+KkW8uo6WZYiZJ41u?=
 =?us-ascii?Q?ACoOKhitrlJeE+gpF8e6OZROEJxf9ojtWJtHRAmiJiRA46m7ZJgrOXYhupwq?=
 =?us-ascii?Q?CTtrYJjhZ464bjVaQzofFDQ9g7tCFTRF7u1pAyXmExKeyQe/LuxWHPW65b1b?=
 =?us-ascii?Q?n9Re7N0PAfSJ/M54YNkoXYW2i+7y4P2kiLXYGKMvkjWPKik7pdqf6J7Xj9wd?=
 =?us-ascii?Q?qapVlzo6gJRG+p7ObxEmFXHBXda3Ubk2y/gaO01cZMenxnxZtkANIMuzraVt?=
 =?us-ascii?Q?owof1Jdw6Ur2PJJO/iLRHnXQjU+K3w/2eFyBf/5hXNhs/xu2IJ8/KgXwB85N?=
 =?us-ascii?Q?6iBXtJzuV+5/941gVsvcGXRgfEVCOuNTU13Yu3M7SgxnTPRXtoxukScEQKZg?=
 =?us-ascii?Q?43qzn8EJDcJbJ4mzAzmjmq9XkUgko46AAHZeEuUrzhTW/jIFKNvzgreDR220?=
 =?us-ascii?Q?CsByXRQmvC5+0T3OEkEC5fE7dn3b4k25mmGknBEJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba720e3d-1140-4859-ab3b-08dd8edf35ce
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2025 09:52:29.1667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ay9ACXi3oHVxeg2p5H4Xw1AJfflx4Xhk7GzO5KhVA7vnMO6Drh6SsYAhFwOG3dLozE0kQUthS6ifyrUTuYZj/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4548
X-OriginatorOrg: intel.com

>+static int init_pamt_metadata(void)
>+{
>+	size_t size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
>+	struct vm_struct *area;
>+
>+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
>+		return 0;
>+
>+	/*
>+	 * Reserve vmalloc range for PAMT reference counters. It covers all
>+	 * physical address space up to max_pfn. It is going to be populated
>+	 * from init_tdmr() only for present memory that available for TDX use.
>+	 */
>+	area = get_vm_area(size, VM_IOREMAP);
>+	if (!area)
>+		return -ENOMEM;
>+
>+	pamt_refcounts = area->addr;
>+	return 0;
>+}
>+
>+static void free_pamt_metadata(void)
>+{
>+	size_t size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
>+

Shouldn't the free path also be gated by tdx_supports_dynamic_pamt()?

There is a possibility that pamt_refcounts could be NULL here, e.g., the
TDX module doesn't support dynamic PAMT and init_tdmrs() encountered an
error.  I am assuming that apply_to_existing_page_range() below will cause
issues if pamt_refcounts is NULL, e.g., unmap mappings set up by others.

>+	size = round_up(size, PAGE_SIZE);
>+	apply_to_existing_page_range(&init_mm,
>+				     (unsigned long)pamt_refcounts,
>+				     size, pamt_refcount_depopulate,
>+				     NULL);
>+	vfree(pamt_refcounts);
>+	pamt_refcounts = NULL;
>+}
>+
> static int init_tdmr(struct tdmr_info *tdmr)
> {
> 	u64 next;
>+	int ret;
>+
>+	ret = alloc_tdmr_pamt_refcount(tdmr);
>+	if (ret)
>+		return ret;
> 
> 	/*
> 	 * Initializing a TDMR can be time consuming.  To avoid long
>@@ -1048,7 +1150,6 @@ static int init_tdmr(struct tdmr_info *tdmr)
> 		struct tdx_module_args args = {
> 			.rcx = tdmr->base,
> 		};
>-		int ret;
> 
> 		ret = seamcall_prerr_ret(TDH_SYS_TDMR_INIT, &args);
> 		if (ret)
>@@ -1134,10 +1235,15 @@ static int init_tdx_module(void)
> 	if (ret)
> 		goto err_reset_pamts;
> 
>+	/* Reserve vmalloc range for PAMT reference counters */
>+	ret = init_pamt_metadata();
>+	if (ret)
>+		goto err_reset_pamts;
>+
> 	/* Initialize TDMRs to complete the TDX module initialization */
> 	ret = init_tdmrs(&tdx_tdmr_list);
> 	if (ret)
>-		goto err_reset_pamts;
>+		goto err_free_pamt_metadata;
> 
> 	pr_info("%lu KB allocated for PAMT\n", tdmrs_count_pamt_kb(&tdx_tdmr_list));
> 
>@@ -1149,6 +1255,9 @@ static int init_tdx_module(void)
> 	put_online_mems();
> 	return ret;
> 
>+err_free_pamt_metadata:
>+	free_pamt_metadata();
>+
> err_reset_pamts:
> 	/*
> 	 * Part of PAMTs may already have been initialized by the
>-- 
>2.47.2
>

