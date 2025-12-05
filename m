Return-Path: <kvm+bounces-65311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CBDA3CA60F0
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 04:56:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CD49D30BD25B
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 03:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A342BEFEF;
	Fri,  5 Dec 2025 03:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DDwB4nGd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A272828751B;
	Fri,  5 Dec 2025 03:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764906993; cv=fail; b=IiTJb83XujMw6rCeB9SiWS05zvj75vwulk+buON935N4SJPJOKLh8zj4BHJf/1KCKN3W9DLqmk4slOEynJ+LoTluhCoxPXhLMQgY24SuIyzH8wFqwsLBXzXrkPs6bdDxA8VRxp+gzmqaCzlKdcLa5ypU2z/hL36Lrho8socLb+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764906993; c=relaxed/simple;
	bh=HCdyT6D4nvagVf41fyYCEmIdFMO5HtfTFOLdc0IfaOY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mgIjISCLQMUsiwCSnkitmDrvECuRC82CJd23acW4/VznvTEqXZBRvC8qQwHLzEM8/U7aDzQ7mSlVXkqWiyZskE65/vctxidab3wJiTp0c4eQ82pYEQfZSCPs9j6dohZQ3wT71ksJzbNzOf5ja+FingMsAMb7BCioZaG4148EK+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DDwB4nGd; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764906991; x=1796442991;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=HCdyT6D4nvagVf41fyYCEmIdFMO5HtfTFOLdc0IfaOY=;
  b=DDwB4nGd/H+Jsd05ytptNk6eR99Pfs2pzLfemefDnStU+XykoYi7eeQ0
   njGWqvvX8k8AwWUNKOFUBvEE4KNxsErvMW6aVsCSggzVrrdePpqPtjFqd
   IDMie6PJNht+QRg1+evkkr4I1fL/MCCm6thNoEiqW80cbzshr18cltc7h
   /9e1quIqobUG6jKx6eMt9lXNgbAKS5j5mtXOSwGAz8oTn6P4lWCrjBzUb
   LSwhsL5F4R1mbsJpkYoLV360EO+s9XBdxT+4At5AWQ0NwM7JQLRSDsncw
   amWBYhFpL/Ho4TASg/q8cTmZckq1sRXMBcLT1fX+uYBj+0ST6MlAntOMs
   Q==;
X-CSE-ConnectionGUID: /oCxEcGLSX6YCt4QcKTlrQ==
X-CSE-MsgGUID: oLogigs0Seq6ZqB0mBiQDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="66128104"
X-IronPort-AV: E=Sophos;i="6.20,251,1758610800"; 
   d="scan'208";a="66128104"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 19:56:30 -0800
X-CSE-ConnectionGUID: p3nVXuDWQZmMzws5S+rK9w==
X-CSE-MsgGUID: 4igxOPVQQKSFpWdcQq5g/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,251,1758610800"; 
   d="scan'208";a="199366135"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 19:56:31 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 4 Dec 2025 19:56:30 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 4 Dec 2025 19:56:30 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.45) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 4 Dec 2025 19:56:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VypOEhBqYt5W7nszST6VTslN2JJPthyFXAcZxxcRwKddmdYS+uqnXJrEELCqtpzYFMihtlPCEpnMZVsZKkLRmsTov/EDcRTcRgi19shilIPGoQqRskywlap2DBIWiMs1jGE+XBmsqgOseLQAggMr3gxIgFF3N2lfKYBrWQoobS+tWhU8CXwXaYlAmsWLChe/h4iUz5OcwpVKTYEE5skh1H9FKGPnxEgLKHxZKsPZG1Tmyjxv57V+BavlELcllIGYmV7fzMMUXHGJETPIBK/YKhSAJHdDcejtmWM3mnqNgvq2hYkM+IpzRhegPbgVRtjqaNUZDf/vi1uAH23+Xcrftg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jfifJ+5rJ3lUzCjSN3E9VHK7Ui3sc/IrDBixCK7eWOk=;
 b=lD6b+Lt3wi+6y++zHC3t4YOlNnINfQHnQi9uFRv2U/pwpsaAeb/d7BOtyqA4B/I7sZ6dW2Uu2iRjUqelPk1r2yKbv4GYbtID3RGhQFcNRe9zMK5bVxCRAkYIbrWm7qGFx2QxYxDXJc9AHs5usdH01EVykCLd49pFC1CcgffHvjYsQ1w/UJtTmiigjhSNVre+/mm+I2vK1vSDtzHAtFjB0hJK+YSlBJDd6pb3z5ITwqa3ATbRvdmDPsG0AXF5WOqmfoVmrXP0zsVSxFkPdtUNfzl8cquzY9OeHjGGJMgK8L27E956nKLKuujYSAXzqRt6hyIGrMyLbfuu+XrTw6E8IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB5311.namprd11.prod.outlook.com (2603:10b6:5:392::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.9; Fri, 5 Dec 2025 03:56:22 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9388.009; Fri, 5 Dec 2025
 03:56:22 +0000
Date: Fri, 5 Dec 2025 11:54:04 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
Message-ID: <aTJXXMKtfcud7ctn@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com>
 <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
 <20251121124314.36zlpzhwm5zglih2@amd.com>
 <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
 <20251201234447.5x62vhlg3d5mmtpw@amd.com>
 <aS6uoFyqF+SdGWlI@yzhao56-desk.sh.intel.com>
 <20251203134717.475azsubs26pj2x4@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251203134717.475azsubs26pj2x4@amd.com>
X-ClientProxiedBy: SG2P153CA0042.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::11)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB5311:EE_
X-MS-Office365-Filtering-Correlation-Id: 34c97cb9-a038-4aa2-05e0-08de33b240e4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Q0GbJUgtEOwRcqGMGnA9s/AWPp/LIw+bvl+bLIjHMLIQvyzCl/p/9HkX4K7U?=
 =?us-ascii?Q?GLJ0MD0t02nWrzi6Y+ygnqWvnGOjIlVgB5qHi87nGd7Y1Ki4yxOqjYdSWm2T?=
 =?us-ascii?Q?iRAWntc3+y/9rlf71OziJ0CCCpiBbIMgrn2HLw1LYCZOqFRXuD+zAL26wR5h?=
 =?us-ascii?Q?lc8rBRyjuoveA+XWZDSOfVA+UQ5qCZQJud7R21QcB0udrpPk2mllk32FcWd+?=
 =?us-ascii?Q?9vTW3h3vjkF/iqOiR94cDNzS9zZ9svG9oaZqxAtKpo1hqWzRZsylP0fwVCsQ?=
 =?us-ascii?Q?pFAKtRh2Bs9nFphbBtimK8lIo4ymvEd3m2d+0KR3HAA9gPfmjqsqT9utX30a?=
 =?us-ascii?Q?7Pn7MZnqEXboqqNiOugTUyKzlCb7iEiLAD2eeTGAuwF/7HbqC1xIgBZBMj4w?=
 =?us-ascii?Q?Kfy7F387O9Mj74yyXMWTgVJiOonK2qTB6hkLSlhWPE6ZenGzFmUK4pmyZA+V?=
 =?us-ascii?Q?p1wfbT5e1GOx5WxcKoSDqZt9PBsjm5B8FarGsvpi3RhgI2GECZodTT+IiZOX?=
 =?us-ascii?Q?4yeaSf515HH4aOQe5ZdbMOFcpNTu1wJ9ctZND+mXCeP3XX8LMdPPuas2nCY3?=
 =?us-ascii?Q?/ck0eihOBbNmOx8PSvUArUPAUpMR+nXEtZxf5/D52P/ZBGadblhjyTUgwglo?=
 =?us-ascii?Q?GuGbJLfRHBDZHDedpZH+i+S7XKrUJJKeRn3v97agL16+bllx5P2N/XEydYeD?=
 =?us-ascii?Q?WEMsVx0t5FFyd6fkfuhdRqyUYXm1pMx2jon0HO9Pzhz5g8rIM3Hd+4QN3pIM?=
 =?us-ascii?Q?TulsyuIghJOTH4iihbAyyZqwMuPfx+rqzIBubqwYkFOg4l+hDUrDFzEuyh7X?=
 =?us-ascii?Q?6H+Sv+RgYrfYxS0dijIQOuil4jrzwKnhLJfCQ5SHqdLgEA3Il8U+QTFL/gjP?=
 =?us-ascii?Q?kPpLI3+1NglE+HluMN8ll9tzoRAsTvwbATLzbJPS6a6p28uqv5uVgrgtVaJp?=
 =?us-ascii?Q?BxSYwjbRocP1xCQXIG/hapI0ajzpEH0xYa0mQiqDgp3xH+3hYHrfe1TCn6iF?=
 =?us-ascii?Q?tsAn90CShKlpRQV72Bef3k1ysc3pbFPnrkGwhJJP+3Sp20lQbGVqCHgIfAOk?=
 =?us-ascii?Q?EpOI8u68y9uNgkxJAyDnYdjN3KfbOrazNkDVofKR4zL1MTqtRURq6dBpIOJd?=
 =?us-ascii?Q?JdhdUMTOz+QZFRlSSBH4c/StFsxZy3oJ9a4AXbF9pEU5GQndqST8Y3/8hbVe?=
 =?us-ascii?Q?zQvuzKvrdjcFL1cWrJ8e6AYBTq1YojdKU8vnz23sqZ6TXlCIrI64IpyoReA3?=
 =?us-ascii?Q?x/ZM9g3GTrq6mVKg0LJWnea1U857vlO3y2BC7kiTHV66JO9PE+OQvzqakw1w?=
 =?us-ascii?Q?mgyeVPN0IZBVTdltyL6N0Zm1LJCSoalMDtNer7RvCtP8hj2aA6pvcb9s7cIV?=
 =?us-ascii?Q?hTNBuAzD8rpl39v7gB4FBlXNX3HPKu35ZeCWltGbfF+kz2ztFw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OOf6WArgNBMIUm2qRZO+1iacSMCMvgHu6Nfw/hTxo6Xl14wpZCT4fi78gXFT?=
 =?us-ascii?Q?1GsQWahMHryYHzNy15byR/kRrEJnFZehq60gGgjSfYcQ1FqbhClhdY1eHr3u?=
 =?us-ascii?Q?9a05yucJ5otTeKiRNrqi1o99keWcEq6KnN6lQKlCiEu4jmCqeAiL5wSiFRAx?=
 =?us-ascii?Q?1PVl3+PFh6AtKy7AP8lRUovZ/tZZLG6vMo/jSztCZs93b+nzjsLnKuTjxcV7?=
 =?us-ascii?Q?FDTRVeeLIpWk9ISWk2RWAmwnBMPVEYcQrPz0n8Qpex5JkN9ew2VrtIMgz7VM?=
 =?us-ascii?Q?7PgutgzHUQQdw5REY8IsJVNjRtNbppyZtotDhTEMh6/oYfSyA+h93j6cVJxA?=
 =?us-ascii?Q?c8fsCAeFjIAyK5PpdqwRD0+G9HGfyW93kikSUy7j8HClIa7oserHlfiJ4mHZ?=
 =?us-ascii?Q?hXp/i5oiY/t9qkSjcbCLpYAonyEwun0wx3vQLDOvNaIFikuHMgMdzp/u373h?=
 =?us-ascii?Q?71tHvYpz0YVeIu7gNvhommX3LpWz/JEGcP8+ZX49jnXxSl9sQIQp26OiGlhX?=
 =?us-ascii?Q?zcBV4vTo7fVpF8I64R1RugOe8pQr3TKRDGO52I+Hh7pJy1vhLVsHaQK/6wOM?=
 =?us-ascii?Q?VH6jUNvpOEjRPGx+49yEw6lWRdvaefT/WR1lycn61FFHT9rqapHLUbFF3Ub6?=
 =?us-ascii?Q?EwRURYlU/Aq+543LYSttDt8jbrflzkh8dWKQWu0aDfFOZpqTVrh0vdAjCsA7?=
 =?us-ascii?Q?6nBJSgxOTUhtXrKZS11YruHfExjttMtTAF6AyiI4JJFxU7ilTzYcStTv5n64?=
 =?us-ascii?Q?H2MXs/gF7cFe3r89tIzKFdghGGfnfRQ35wLXULTtoLaHVDkgJ39vniNTnjZf?=
 =?us-ascii?Q?+jL2lxThpy2wJGGvYbOMbzwmtAvQoVRMpD64HpsA8xdYO9omHQiIDZBFLaLx?=
 =?us-ascii?Q?+8brH8M6EtDPQAB6Wsz80EKpAzPnROndvS36zoFU3VP3gYritx7jXliGVgWO?=
 =?us-ascii?Q?AOeSeotJKm6q4eXiHw1P65sV/z9v5yapW3QZR1ZpjIahdq/JxTAoAuG+T64L?=
 =?us-ascii?Q?aeOW8EU+r9lxQ102W27/Lve9BjMBdn8DJztXo5Qt6teTWjAVLkDL+WawrS0k?=
 =?us-ascii?Q?DmDBfLjVv948wWSOkKVQ3jhm1YiUTocVvlgLb9fDthehm4pSj4EzLeE27AGn?=
 =?us-ascii?Q?Bjm7y+TdqoocXrg4NQSjzpoYzpUz0ll5F5dlRQuR9I3m9buEgNGgBGB/S5ih?=
 =?us-ascii?Q?gFUDdYy5pG8T2WSKpg3af2Sud7rSSG4Lzo5uqBr6Y070kNtFGPlx92Q10MES?=
 =?us-ascii?Q?m4O88THR+qDi910ZguDqqkAdTlkSoaAQJQjXa0dNx7XU6LEP2Sl6sWQI1Dnk?=
 =?us-ascii?Q?/WDfvboPk4OiIwcHFHHQ709wHXCJCex05zlV7+sbgbcqcsZnbIQcrynz72aA?=
 =?us-ascii?Q?bzQv03mGi+tw/OXznPN7WPUlSGwo2abQRMnFGeo97RiWefwzNieO6FvdnAlI?=
 =?us-ascii?Q?GEqx3bjVdvLujqxvl5gdJ60+bBJV9ckRAhtBvR5bencElfTFY+se3ZOshn/N?=
 =?us-ascii?Q?AEfshqv6Mx1l6W/h24BvifEwFFjkVFFwWu+/TEUu7aoLRnQllNbDEfsVtJJQ?=
 =?us-ascii?Q?wACBy5cHCUlVXKg3SWvGtwR71A88cpuwpK09GK8y?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34c97cb9-a038-4aa2-05e0-08de33b240e4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2025 03:56:22.0405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EaJxDjWQd0xah0/LZkmy6pKy4p0pmp+JaJOlJkzSJMoVmjGNCaXY5T+AcamUOQagoZSJ6McKkdpO9YH1KzXUBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5311
X-OriginatorOrg: intel.com

On Wed, Dec 03, 2025 at 07:47:17AM -0600, Michael Roth wrote:
> On Tue, Dec 02, 2025 at 05:17:20PM +0800, Yan Zhao wrote:
> > On Mon, Dec 01, 2025 at 05:44:47PM -0600, Michael Roth wrote:
> > > On Tue, Nov 25, 2025 at 11:13:25AM +0800, Yan Zhao wrote:
> > > > On Fri, Nov 21, 2025 at 06:43:14AM -0600, Michael Roth wrote:
> > > > > On Thu, Nov 20, 2025 at 05:12:55PM +0800, Yan Zhao wrote:
> > > > > > On Thu, Nov 13, 2025 at 05:07:57PM -0600, Michael Roth wrote:
> > > > > > > @@ -797,19 +782,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > > > > >  {
> > > > > > >  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > > > > > >  	struct folio *folio;
> > > > > > > -	bool is_prepared = false;
> > > > > > >  	int r = 0;
> > > > > > >  
> > > > > > >  	CLASS(gmem_get_file, file)(slot);
> > > > > > >  	if (!file)
> > > > > > >  		return -EFAULT;
> > > > > > >  
> > > > > > > -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> > > > > > > +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
> > > > > > >  	if (IS_ERR(folio))
> > > > > > >  		return PTR_ERR(folio);
> > > > > > >  
> > > > > > > -	if (!is_prepared)
> > > > > > > -		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > > > > > > +	if (!folio_test_uptodate(folio)) {
> > > > > > > +		unsigned long i, nr_pages = folio_nr_pages(folio);
> > > > > > > +
> > > > > > > +		for (i = 0; i < nr_pages; i++)
> > > > > > > +			clear_highpage(folio_page(folio, i));
> > > > > > > +		folio_mark_uptodate(folio);
> > > > > > Here, the entire folio is cleared only when the folio is not marked uptodate.
> > > > > > Then, please check my questions at the bottom
> > > > > 
> > > > > Yes, in this patch at least where I tried to mirror the current logic. I
> > > > > would not be surprised if we need to rework things for inplace/hugepage
> > > > > support though, but decoupling 'preparation' from the uptodate flag is
> > > > > the main goal here.
> > > > Could you elaborate a little why the decoupling is needed if it's not for
> > > > hugepage?
> > > 
> > > For instance, for in-place conversion:
> > > 
> > >   1. initial allocation: clear, set uptodate, fault in as private
> > >   2. private->shared: call invalidate hook, fault in as shared
> > >   3. shared->private: call prep hook, fault in as private
> > > 
> > > Here, 2/3 need to track where the current state is shared/private in
> > > order to make appropriate architecture-specific changes (e.g. RMP table
> > > updates). But we want to allow for non-destructive in-place conversion,
> > > where a page is 'uptodate', but not in the desired shared/private state.
> > > So 'uptodate' becomes a separate piece of state, which is still
> > > reasonable for gmem to track in the current 4K-only implementation, and
> > > provides for a reasonable approach to upstreaming in-place conversion,
> > > which isn't far off for either SNP or TDX.
> > To me, "1. initial allocation: clear, set uptodate" is more appropriate to
> > be done in kvm_gmem_get_folio(), instead of in kvm_gmem_get_pfn().
> 
> The downside is that preallocating originally involved just
> preallocating, and zero'ing would happen lazily during fault time. (or
> upfront via KVM_PRE_FAULT_MEMORY).
> 
> But in the context of the hugetlb RFC, it certainly looks cleaner to do
> it there, since it could be done before any potential splitting activity,
> so then all the tail pages can inherit that initial uptodate flag.
> 
> We'd probably want to weigh that these trade-offs based on how it will
> affect hugepages, but that would be clearer in the context of a new
> posting of hugepage support on top of these changes. So I think it's
> better to address that change as a follow-up so we can consider it with
> more context.
> 
> > 
> > With it, below looks reasonable to me.
> > > For hugepages, we'll have other things to consider, but those things are
> > > probably still somewhat far off, and so we shouldn't block steps toward
> > > in-place conversion based on uncertainty around hugepages. I think it's
> > > gotten enough attention at least that we know it *can* work, e.g. even
> > > if we take the inefficient/easy route of zero'ing the whole folio on
> > > initial access, setting it uptodate, and never doing anything with 
> > > uptodate again, it's still a usable implementation.
> 
> To me as well. But in the context of this series, against kvm/next, it
> creates userspace-visible changes to pre-allocation behavior that we
> can't justify in the context of this series alone, so as above I think
> that's something to save for hugepage follow-up.
> 
> FWIW though, I ended up taking this approach for the hugetlb-based test
> branch, to address the fact (after you reminded me) that I wasn't fully
> zero'ing folio's in the kvm_gmem_populate() path:
> 
>   https://github.com/AMDESE/linux/commit/253fb30b076d81232deba0b02db070d5bc2b90b5
> 
> So maybe for your testing you could do similar. For newer hugepage
> support I'll likely do similar, but I don't think any of this reasoning
> or changes makes sense to people reviewing this series without already
> being aware of hugepage plans/development, so that's why I'm trying to
> keep this series more focused on in-place conversion enablement, because
> hugepage plans might be massively reworked for next posting based on LPC
> talks and changes in direction mentioned in recent guest_memfd calls and
> we are basically just hand-waving about what it will look like at this
> point while blocking other efforts.
> 
Got it. Thanks for the explanation!

