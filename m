Return-Path: <kvm+bounces-20887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 914A892545A
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 09:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB3B2B214A1
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 07:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFACF135A71;
	Wed,  3 Jul 2024 07:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lHGssBQj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D13482C1;
	Wed,  3 Jul 2024 07:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719990277; cv=fail; b=CsoPgX3bR+ZrWqUIbQQ2eEa5E997uEI20Zc963Uake6rzAR37WgwWZyvz7z6H6Tez8MvoCSkeyNylesyG6A18tqE/2QOy4qFClpMtTWmUcezyrsIJ245wFCdqUleWOQgosiJI1aIWt+dxn71RMleOMNQmRn1yKsEblvtZKrVxiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719990277; c=relaxed/simple;
	bh=d0jKhQWXfOZXUFMiwCiKVRgmkQGjxTLXgLylWLTS3bk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nQDKeAvG/SJDiSAh14L8xguS19vwgEWNCAd+e5i256fWopEZHAw+ig5tUOBdNFhvBbqS1riMQu5RTrOzGJg25qjxDo0wRGBT2ozulumZHNIPbPvUQ6DYpi1DEMA82aFJetZbU9n7oqNhO983agcXXcI82HCAeCuKJ30Zgg0LBHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lHGssBQj; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719990276; x=1751526276;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=d0jKhQWXfOZXUFMiwCiKVRgmkQGjxTLXgLylWLTS3bk=;
  b=lHGssBQjrt7hDKvLHEP86dS6d5ZyDXj+RF3Nv1LwY5HWM4TIWEtZhhyo
   qqcB6pm6beZfTko1w/zvcc/dgZYMPqQcvMgm1eBvDQkQAZObWw6cr0kuZ
   eJQJn22xv3+TXh5R1wxAswOz4ofVxJQci0+x+5/xzoDpfOs4uGikTsKlI
   MH+cCOE+Tcu4JDiKUZNOVH/JqSghxhBQHQolPOwGMgEob/TUb7iio8byf
   DyRmX7BHQ7PRUvQchNgN5fykVb0/kLrM1c86W3h1BPO/u8YXUDf2nGku6
   g0VefS5w41I36u3lPnfBmo8Fv2IZzrqGF5U0AKJTCK7AxZjlyXFxqZMcK
   w==;
X-CSE-ConnectionGUID: GBObVCKVSAaSgqRZ+3vYrg==
X-CSE-MsgGUID: D3vx/bycTJamGgl3jlWLiw==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="27817938"
X-IronPort-AV: E=Sophos;i="6.09,181,1716274800"; 
   d="scan'208";a="27817938"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 00:04:35 -0700
X-CSE-ConnectionGUID: 4RXbnAzoQUeJXprVPEyKXg==
X-CSE-MsgGUID: xiFJz7Z7SmS37EJC4BgbBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,181,1716274800"; 
   d="scan'208";a="46813013"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jul 2024 00:04:35 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 3 Jul 2024 00:04:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 3 Jul 2024 00:04:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 3 Jul 2024 00:04:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 3 Jul 2024 00:04:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOQ8+1u5OplfVWYuPo+t6HrxA1SNIzDG6I6MtdZmWUqCCI4HipRvokdfFo+ttfF6Z3J6ap0mtwCg+OuRS760wgjPSbaKEQP1Rjhp8YdXP/XbzQTkUhRFKU9ctn9yRR8pjAlEF5V4qV6zSxI+ij3WtDcSgz5eFhtPO98+1w/qyyuhekkOSVNmPrOEccG0CgI7h6NS6jKH7CwuW3Ii1nFdL3gPUpZRTQ68KhW/TGQTsw0MgVns+32NMxU5edUCNbMQDeXbe7DF7pSC/ERjGlGPqR7RAr4VtZI5WPI0EVl94UqQXCzHDxi2SIMmQdT3hqaTZWv5ddh7VytASVbwnfnoTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=giT+gaKxGk38JcarvZpfTGfNvkw6sRdJP3b3cWrwq9o=;
 b=m7EKu9/aaI8Zhvt4SVed0roP17Jzrex+0GcMRlTdHbHHAinORg26HkAE57E7+D3p/yQdpdQ9IA3DX3IqYcorQzmA/BNB4FBIYB8vu08X0EW88W/OgkGQtmhL3A+QzlTuhRoNzrIF/5500ASXRH7pUUksEXp5J5lYAOHq1I/pbiahxDPhLY4ePoghGoDm6VW+VgQ7NmQYHmz+M4p/gQtLTxJTUsPOXlHBrdKHMU37cOWBx8kGjnC3D4vHFODQIgrjnT8GtxdHNSMCeacTcODAZEfflyHdhpxRIet8azMazBIYioWxHM2wjzYCjvjLpJdIU2qDWCyy+aaN4z2OWhTfzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6247.namprd11.prod.outlook.com (2603:10b6:8:98::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.25; Wed, 3 Jul 2024 07:04:30 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7719.029; Wed, 3 Jul 2024
 07:04:30 +0000
Date: Wed, 3 Jul 2024 15:03:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>, <dmatlack@google.com>, <erdemaktas@google.com>,
	<isaku.yamahata@gmail.com>, <linux-kernel@vger.kernel.org>,
	<sagis@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>
Subject: Re: [PATCH v3 04/17] KVM: x86/mmu: Add an external pointer to struct
 kvm_mmu_page
Message-ID: <ZoT3sj6m/D7NcqDj@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
 <20240619223614.290657-5-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240619223614.290657-5-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SG2PR06CA0182.apcprd06.prod.outlook.com (2603:1096:4:1::14)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6247:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e2db6cd-bd8c-46d0-2934-08dc9b2e624b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1ALcWpWHGo3CZWDRCoqwH4maxoIakpjSjNJikWNc1NDZjIN1A5LBBNYR8h8e?=
 =?us-ascii?Q?cs/1Wz521E8bxjrvzas1UNcdC3uc7rmsF+fNk7DndpxB5EAzcW8hRIuNCnQ2?=
 =?us-ascii?Q?BERVQJAeC9sTJZEKNJ/62l4cNRFVWa0zf1D9IAvi7K1fMlw2O0O3TvPAngJX?=
 =?us-ascii?Q?OfdUr7HjkZIoR74zirZVT96pse7rCbMKwQ9/lHgqbjXtZ7nSieEo8yOwIy2a?=
 =?us-ascii?Q?4AqzV8yJ9XMdCaDYoq4+cM5vTkyIkjqxqxmVX44oyyJ6WlHybuH7Gi8UIetF?=
 =?us-ascii?Q?BoL++RWqgaJr6pZLN7+JKUVSZqJ5E4DuYFrQuFA1xAjLGEJBpMpwXxKf9O3C?=
 =?us-ascii?Q?6bOTwgGb3SCRPyOYT4p65qwOadeU3QE6nKadZXXoMnNwcBKEsD8w4k7DvWrL?=
 =?us-ascii?Q?0WS+qBvdvJwOeoDGAwTSUGf9MmgxkX8dxmNJPxgEg/ucGiEeqdjHiZRWsX/k?=
 =?us-ascii?Q?R1SmzzWd9P2ayHdrY8eZgIrB3Z0OGoRFYPL3c3O+59e62L6wmasbabrhqwgw?=
 =?us-ascii?Q?bEfBpGOmXBzaSk2buFLD8zKhyXAK4Ybq1NgkpoIjeV2hfrczjWE5FX7rJMdL?=
 =?us-ascii?Q?T4UTTVFUTYxbPmjlXZWzotBRXwxVL/e6gbpO8K/nOZrsSsA/VLoCDj32qTbA?=
 =?us-ascii?Q?gN3bKaNfri4iPqnT4hgGQfVvab/yQxOeQsjhaXml8hgGaBUZ77wMp67VQesC?=
 =?us-ascii?Q?A1mNNdkEelEP/AOnAMG3oS6PHUhSbF+MNTGeFsEXDywb54IFAbFYJvR86uBF?=
 =?us-ascii?Q?dsurbgvYGdLw3CV9W9nNq+pk9eD13ZGOcRKCvxY20UgFmjH1++ZD/2NXRSBd?=
 =?us-ascii?Q?YU30x77t1MDDfXrZhT3kbdz0k03xI0Uw2jXHBq2zf4IZOMj3+gxeUBkbbFUe?=
 =?us-ascii?Q?+c8tekvK57j1tgTYK/WIgzJyIV0D7iZS8gstTro6JktUCV52VWCVABetJgHa?=
 =?us-ascii?Q?fhNbdf+vtKyuTs6FexqwVhzilYaXs0C/fldKHYPpnYDiIRVALq3z6p7jJ89m?=
 =?us-ascii?Q?aJu/wP7T6aexXOO/BzqFYTRrqnlZljaSl94BQoL/ubwlcqCytrwcGtoXsv48?=
 =?us-ascii?Q?r5FDSIdBS0qBV7QA/6yRRt+4sta5yMVjYFnr6b1jC6D9vWBl9jLVtIMACvWF?=
 =?us-ascii?Q?45g7Bvfkw19VE+uMEynTPDXtUigbZF6pQaZunDcGbs1YuPG4Lq9r7Sy+mk0l?=
 =?us-ascii?Q?M05cjqMDMvhkP/lFS/kxYYjRZ51uYecjfQiassgTcfjys7xXKDGB9awTEwq1?=
 =?us-ascii?Q?7ILhDNqWx5JkmWXekH7dfRVf5LuyDC639ohORrQo9l0182L/jSSO7UfaZ0PU?=
 =?us-ascii?Q?EPoQFgOs8DIbfyTcvjdKpEWf17KkMB6kRIH4W0yltaFchA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2HimYJIxmGVGyDDvuUeLU6akvyJQZ9YPIABgytHKn3w9do0GYQGXncipzmly?=
 =?us-ascii?Q?C9TKFtFtV3xyb0pSRxUfz6gAwBhP4v8Rfph3af1TZLOuGCtRPdV6ZhMCvIjF?=
 =?us-ascii?Q?bHHYRZuKbibYXnBQk5a1kAaFmEIlcx+0EV/QlLwmAX5q1BVNZQO1umrMZC7S?=
 =?us-ascii?Q?mhY2yjgdSihFZsdlMlXcymNnZQPd/YrxTaihnbkcwpNf9irygl1RWSIB6GQf?=
 =?us-ascii?Q?SDqeSKr5IV3la+TtdvNyEv9g4BvODOTGO+jsGTwkD5vAxzYumRY2KE8M28UO?=
 =?us-ascii?Q?QvcCDJwnQL+uvPxTUbPRFI7zD9MHGCBdDSVo2qDLoQLETGNdQ78b2guaA0ya?=
 =?us-ascii?Q?UZgzfTtxDcOdf82CFzI5N7OZRd3MRffb79567qs7EQtvWmkh73OXr6eCxYZx?=
 =?us-ascii?Q?Sv7EMwerzGkJJ5oKg36cw18Dc962ys97wpmFVG1+9R8/wwB8rVpSbLadSTnq?=
 =?us-ascii?Q?FhdTijDC2FSjmdH5rRzXYKUyp1W78R0FpNHojlXjT/gCt+gk+k4Xzt4ZTZfk?=
 =?us-ascii?Q?NbdJwZUXj3ki2Y8gqUgrlvXRnfFccQ0qwG2KApxnmM9Oi8que31s+UTTWWzQ?=
 =?us-ascii?Q?Sur9OPLNNDiMFXPKlCQPAPUd7Am3omzSYRvnz8H9B1ZTAqqyhv29Ri+a+sji?=
 =?us-ascii?Q?4ZEY2TLWfF0C75lzCTlH6/rEMJ8hCjBF848GyB4r+6W1jgZ18dpyjNTfcRms?=
 =?us-ascii?Q?cG2JICakNFNHLoGnjI8lokh92Zzf1DbkjRNIIGO/DoPNmnkxF4Le0gw8JqQ+?=
 =?us-ascii?Q?Jr2KiIYt6evCw4oJ1HKclSwoZ7J+PfAhjgwGQqcfdzerLrd/TfObnz2Ql9tr?=
 =?us-ascii?Q?LrDt9jchjo0rw1aoWGXDQACnPR5ryvEsWVWhDbijoQtGy2FS54Qnywawlj8k?=
 =?us-ascii?Q?sgX4MLa/fubCwa7jvy3e+l1dcUrT+G4g8/9eqL6TiqtiY1v47s5oAVpjw7p6?=
 =?us-ascii?Q?pZVcIZtMo/FkEflktJph4UTqPuKD3SFYoiHnswE1bjFvwUeZEVt+Q2rJiOMw?=
 =?us-ascii?Q?PDHx8cNYLDqAAKX+k4+Xsh0HjktjTIEBrZGiUB+ds/Wq4moMviqrTPFbXRju?=
 =?us-ascii?Q?71SjDgVNDQFCOWbg+YaNBoncHoAq5pq+frdtPJlfNb5jYg76qbi8dK5sLgYJ?=
 =?us-ascii?Q?fIhfpLK8jDjtSnB2G1v7rI+fbXKYhaLvfggA21/L7SrPrPhutzvNW3uVzoPK?=
 =?us-ascii?Q?YMx1TxF1JC4IxAzSveIDHY5JDRgsg8Au3e9sILmKAz7elMIfb3P1h2iT/8dZ?=
 =?us-ascii?Q?OWxJ5d4rlfHoCSJ4lQhkyWl0FGyF6e3sw633Uk0MV3pQxqSKXCkH2fKUjVdW?=
 =?us-ascii?Q?YTMMTsdqmEPuUFbnqao3gYOXKsU5CpS4+49Ob7J45Kz7YYOWndCAa1HZFxDQ?=
 =?us-ascii?Q?2uhMrJjE4jnEw2mtuRNVDD5MZiX1yBPb0CvNOILdMM+bMBDOeNVG9/y1uhb+?=
 =?us-ascii?Q?g/btBn5n5dTn1EeE7fHZR/kh/WKDt0vEKGzX82O1JYTmj66RCml51rynMzGF?=
 =?us-ascii?Q?I7lhLnxqKC73rr5PuDZCsTWlrETiSL6zf38UW4egkbYyFEH53Gvgk/FrJOYL?=
 =?us-ascii?Q?Nc28F0rzUjDSPqug+TRTGqmsys8ceg3PH1hALmCN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e2db6cd-bd8c-46d0-2934-08dc9b2e624b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 07:04:30.1461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xsRKxIfd9T2v5A/t+uCZWS6CVxsryKol7yLMS5n/MHGkZFRYFh30wmHZSwUhlvnV3FvS2Um84H726ZEDj2MNUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6247
X-OriginatorOrg: intel.com

On Wed, Jun 19, 2024 at 03:36:01PM -0700, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add a external pointer to struct kvm_mmu_page for TDX's private page table
> and add helper functions to allocate/initialize/free a private page table
> page. TDX will only be supported with the TDP MMU. Because KVM TDP MMU
> doesn't use unsync_children and write_flooding_count, pack them to have
> room for a pointer and use a union to avoid memory overhead.
> 
> For private GPA, CPU refers to a private page table whose contents are
> encrypted. The dedicated APIs to operate on it (e.g. updating/reading its
> PTE entry) are used, and their cost is expensive.
> 
> When KVM resolves the KVM page fault, it walks the page tables. To reuse
> the existing KVM MMU code and mitigate the heavy cost of directly walking
> the private page table allocate two sets of page tables for the private
> half of the GPA space.
> 
> For the page tables that KVM will walk, allocate them like normal and refer
> to them as mirror page tables. Additionally allocate one more page for the
> page tables the CPU will walk, and call them external page tables. Resolve
> the KVM page fault with the existing code, and do additional operations
> necessary for modifying the external page table in future patches.
There should be only one page table for mirror page table and one page table for
external page table.

What about the below change?

For the page table that KVM will walk, allocate it like normal and refer to
it as mirror page table. Additionally allocate one more page table that the
CPU will walk, and call it external page table. Resolve the KVM page fault
with the existing code, and do additional operations necessary for
modifying the external page table in future patches.


> The relationship of the types of page tables in this scheme is depicted
> below:
> 
>               KVM page fault                     |
>                      |                           |
>                      V                           |
>         -------------+----------                 |
>         |                      |                 |
>         V                      V                 |
>      shared GPA           private GPA            |
>         |                      |                 |
>         V                      V                 |
>     shared PT root      mirror PT root           |    private PT root
                                                            ^
Should we use "private PT" or "external PT" here?
"private PT", which is the term TDX uses, looks more appropriate, but a legend
is lacked for it below, e.g.

Private PT  - TDX's terminology of the external PT referred in KVM.

Or just use "private EPT"?
But there're already lots of co-existence of "private EPT", "private page table"
in the code comments below. Not sure if it matters.

>         |                      |                 |           |
>         V                      V                 |           V
>      shared PT           mirror PT        --propagate--> external PT
>         |                      |                 |           |
>         |                      \-----------------+------\    |
>         |                                        |      |    |
>         V                                        |      V    V
>   shared guest page                              |    private guest page
>                                                  |
>                            non-encrypted memory  |    encrypted memory
>                                                  |
> PT          - Page table
> Shared PT   - Visible to KVM, and the CPU uses it for shared mappings.
> External PT - The CPU uses it, but it is invisible to KVM. TDX module
>               updates this table to map private guest pages.
> Mirror PT   - It is visible to KVM, but the CPU doesn't use it. KVM uses
>               it to propagate PT change to the actual private PT.
> 
> Add a helper kvm_has_mirrored_tdp() to trigger this behavior and wire it
> to the TDX vm type.
> 
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> TDX MMU Prep v3:
>  - mirrored->external rename (Paolo)
>  - Remove accidentally included kvm_mmu_alloc_private_spt() (Paolo)
>  - Those -> These (Paolo)
>  - Change log updates to make external/mirrored naming more clear
> 
> TDX MMU Prep v2:
>  - Rename private->mirror
>  - Don't trigger off of shared mask
> 
> TDX MMU Prep:
> - Rename terminology, dummy PT => mirror PT. and updated the commit message
>   By Rick and Kai.
> - Added a comment on union of private_spt by Rick.
> - Don't handle the root case in kvm_mmu_alloc_private_spt(), it will not
>   be needed in future patches. (Rick)
> - Update comments (Yan)
> - Remove kvm_mmu_init_private_spt(), open code it in later patches (Yan)
> 
> v19:
> - typo in the comment in kvm_mmu_alloc_private_spt()
> - drop CONFIG_KVM_MMU_PRIVATE
> ---
>  arch/x86/include/asm/kvm_host.h |  5 +++++
>  arch/x86/kvm/mmu.h              |  5 +++++
>  arch/x86/kvm/mmu/mmu.c          |  7 +++++++
>  arch/x86/kvm/mmu/mmu_internal.h | 31 +++++++++++++++++++++++++++----
>  arch/x86/kvm/mmu/tdp_mmu.c      |  1 +
>  5 files changed, 45 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index aabf1648a56a..9e35fe32f500 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -817,6 +817,11 @@ struct kvm_vcpu_arch {
>  	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
>  	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
>  	struct kvm_mmu_memory_cache mmu_page_header_cache;
> +	/*
> +	 * This cache is to allocate private page table. E.g. private EPT used
s/private page table/external page table  

> +	 * by the TDX module.
> +	 */
> +	struct kvm_mmu_memory_cache mmu_external_spt_cache;
>  
>  	/*
>  	 * QEMU userspace and the guest each have their own FPU state.
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index dc80e72e4848..0c3bf89cf7db 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -318,4 +318,9 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
>  		return gpa;
>  	return translate_nested_gpa(vcpu, gpa, access, exception);
>  }
> +
> +static inline bool kvm_has_mirrored_tdp(const struct kvm *kvm)
> +{
> +	return kvm->arch.vm_type == KVM_X86_TDX_VM;
> +}
>  #endif
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f41c498fcdb5..8023cebeefaa 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -685,6 +685,12 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>  	if (r)
>  		return r;
> +	if (kvm_has_mirrored_tdp(vcpu->kvm)) {
> +		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_external_spt_cache,
> +					       PT64_ROOT_MAX_LEVEL);
> +		if (r)
> +			return r;
> +	}
>  	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
>  				       PT64_ROOT_MAX_LEVEL);
>  	if (r)
> @@ -704,6 +710,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
> +	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_external_spt_cache);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
>  
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 706f0ce8784c..d2837f796f34 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -101,7 +101,22 @@ struct kvm_mmu_page {
>  		int root_count;
>  		refcount_t tdp_mmu_root_count;
>  	};
> -	unsigned int unsync_children;
> +	union {
> +		/* These two members aren't used for TDP MMU */
> +		struct {
> +			unsigned int unsync_children;
> +			/*
> +			 * Number of writes since the last time traversal
> +			 * visited this page.
> +			 */
> +			atomic_t write_flooding_count;
> +		};
> +		/*
> +		 * Page table page of private PT.
s/private/external

> +		 * Passed to TDX module, not accessed by KVM.
> +		 */
> +		void *external_spt;
> +	};
>  	union {
>  		struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
>  		tdp_ptep_t ptep;
> @@ -124,9 +139,6 @@ struct kvm_mmu_page {
>  	int clear_spte_count;
>  #endif
>  
> -	/* Number of writes since the last time traversal visited this page.  */
> -	atomic_t write_flooding_count;
> -
>  #ifdef CONFIG_X86_64
>  	/* Used for freeing the page asynchronously if it is a TDP MMU page. */
>  	struct rcu_head rcu_head;
> @@ -145,6 +157,17 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
>  	return kvm_mmu_role_as_id(sp->role);
>  }
>  
> +static inline void kvm_mmu_alloc_external_spt(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
> +{
> +	/*
> +	 * external_spt is allocated for TDX module to hold private EPT mappings,
> +	 * TDX module will initialize the page by itself.
> +	 * Therefore, KVM does not need to initialize or access external_spt.
> +	 * KVM only interacts with sp->spt for external EPT operations.
s/external EPT/private EPT
or
s/external EPT/external page table

> +	 */
> +	sp->external_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_external_spt_cache);
> +}
> +
>  static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
>  {
>  	/*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 16b54208e8d7..35249555b585 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -53,6 +53,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  
>  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>  {
> +	free_page((unsigned long)sp->external_spt);
>  	free_page((unsigned long)sp->spt);
>  	kmem_cache_free(mmu_page_header_cache, sp);
>  }
> -- 
> 2.34.1
> 

