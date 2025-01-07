Return-Path: <kvm+bounces-34665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA3DDA03850
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 08:03:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B79E716327F
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 07:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE161DED6E;
	Tue,  7 Jan 2025 07:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h8SH5H2K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E224339A1;
	Tue,  7 Jan 2025 07:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736233407; cv=fail; b=HUKDCpWZASW1EmhpqBvnwcFDGwNutWcItZiWHGF8cnp7ESiWubbq1Iy5zs5y2WzvUjk6Udj6ECgfz9e+J8YcrSxebcDTycLkQOvsE9uoA2u7dovqEBCqIbfHpGJVbfNY0fA9TABVaCv4omAoF/rVOOIzlHIsgAN+FSyoeG7Ti5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736233407; c=relaxed/simple;
	bh=+iyVkGKEN6deuPCnqDJFOC4ngus+iExSBHWaZfDnWus=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dk9qx4zyANu+UmfhLy5sVmS+GVyNQ0C8RuTIwJ0Pzo19BDsC2PNn0XbY2Jb1+Yy8yvJ5b+f2LrR9I9Acign4CJ9xHjk3Hb602SZ6iigL/lzwSyq7eSCsCgICueQNaF750h+bU4Iy3hV6f+UwuBlcvy2k6TGWrVMGULf+EmV4xqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h8SH5H2K; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736233406; x=1767769406;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=+iyVkGKEN6deuPCnqDJFOC4ngus+iExSBHWaZfDnWus=;
  b=h8SH5H2KrwT0Fkou24bprRcVketcaeERjmqXru1fgP324lg5JUzPvE3d
   bs5yVWui2PXeh/winLrPwlaS3Ue+SmQUizOBR9MzPKLjuxlFFZGg/yUNh
   cdsjfexCKXFMr8zAjfM+CgjLpkWDP7I9KRLLThMoZJFl8NtOPPcWnVodA
   //lsMNrzR7ExWxcUC5N3XbYWpCRAJs8QmA6IZNU4coi82RseUu5UBTR0n
   R7LCEX28f5GGe+PX1Dc3+ivq3sLdsLDj9DzjpCncxiGr2GOtGkvit0mpn
   a6O83Fiaf31EOhjZITn8mDhAkuWEjtorCjykC1amDaSfHX+b0CJYMEaWQ
   g==;
X-CSE-ConnectionGUID: fj78PNfDRjSjt1+bwUHn1w==
X-CSE-MsgGUID: J/NO7XPHRdGWyhwx7qC5KA==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="36622687"
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="36622687"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 23:03:25 -0800
X-CSE-ConnectionGUID: M7jEbOGkR7u56jhR9o6/7w==
X-CSE-MsgGUID: yJtCCrueT1WJKWNhqVbwcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103173172"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 23:03:23 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 23:03:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 23:03:10 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 23:02:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HyX3BUnCbJZpx8/S2zK100B66NSkLzV/sX0JHJ2DTEeDNNQiLKb4jx1hrF76r+dHC12pfT+Lk5qOvVLjcL3gXzlmeQW6CPc/9z7CSajlUZ7nGQrgN13w2FkCEqhzfkQtur8HHoDQZusuWo9TXPRjLhe2A8l78Vx15SGSRxdxjtqmDWIr0UBKfqC+oxbwaGoOU9Cxi2CxW9YkIdXljkHnavsIzMnxtGVnIhePKqUc5qffIcyrfmrI3nFh+bRj1yb6L7Lyd2kT2q05T1w63PXRz9ZJUUWLdzHedECy7P5CEQpECyGZaYeBA7b6dNMjaNBPCoywUhogd/z6nhzKjHx2Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oibaboDLaKhyBdBT5vNI/tIb6Gd8pa/n9LzAyxZoQyk=;
 b=HdtsCvcjtPBkQak2TU9Q/hBwxoLyrahYkJftjt1pQa+aFLHTfk0+0KMUw7hIU+Sc+gKYHJf26GgYv1ddmUyeo/VULIH7KcEIHUL4npI4H7ea5fN0S6l7MRQAQKLn5otTdZZsQRFV/Jv8UDmwi3fJPldKxjwqnD3TlR1ljCVOYzjRWlplzixvz6NsQtWl4t1wLjFhOhG6x0U3kCz5x6rL/JyzOssyYwM77BKA4hVKBRZUFuu/vfzYtgN1DvevBPBSwo4Eh98rMfpiDtkUTRPgyQuG8WaFa+V8mOtYGcRgdTB1ZLW/ka5tZKckW6qbTzw8s2sySi8oaJvmMBPAIXkWpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by MN0PR11MB5987.namprd11.prod.outlook.com (2603:10b6:208:372::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 07:02:25 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%6]) with mapi id 15.20.8314.018; Tue, 7 Jan 2025
 07:02:25 +0000
Date: Tue, 7 Jan 2025 15:01:29 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>, <rick.p.edgecombe@intel.com>,
	<dave.hansen@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 11/13] x86/virt/tdx: Add SEAMCALL wrappers for TD
 measurement of initial contents
Message-ID: <Z3zRSbq4Ueboq/Zv@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
 <20250101074959.412696-12-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250101074959.412696-12-pbonzini@redhat.com>
X-ClientProxiedBy: SG2PR01CA0126.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::30) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|MN0PR11MB5987:EE_
X-MS-Office365-Filtering-Correlation-Id: 49aa888a-fea4-462d-e846-08dd2ee93d81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/Fyf7npYyZcGVv+v1XftVWQbn8OZr4Zy1ioSETz6nVY3UxxE/Q795+eH2kuo?=
 =?us-ascii?Q?m0ltPG8TQKGrelgACaLu8il83EaKYmhi3zbaPZ7IC2Fxo/C3EPJ33aHsVC1r?=
 =?us-ascii?Q?1GA8Agzq8juIqFL+8V0YPwLl8E96/i8NTCoHJridDB4bALbqzjF4fTWMY7uO?=
 =?us-ascii?Q?0i+rQ2d2k1HPF8QLqa3wyRb0KuE+VPpqMT0XtGhbAYgTo0xsmYN7MiOpkKnT?=
 =?us-ascii?Q?PJIiDHQojUZfSMjAYuZc+FVhqx1cBhqYnUT59nS+j4oHeNS+Vejhe/OYuZMf?=
 =?us-ascii?Q?lY/DP5l7ZlX5pBXEs9E+/csEUthXfLF6ToAioq10ClknvXm67E/z1nWZAN91?=
 =?us-ascii?Q?fGMIyMWMJJtDs2lJLKkZJKBXQX6Qqkyp1ltXsEZTRvQInT44PlmevaoU8OZ9?=
 =?us-ascii?Q?+46pFzxzRjD05jk6FTpwj9OYL6+9oW0hGzkqo8n5OS8qdLznKawM50OozVNO?=
 =?us-ascii?Q?4ekc30ljV/YJ28VD0phPJMq975e2ob+HczDHjp8ILQLS+mqkYIbWJq9EIW66?=
 =?us-ascii?Q?2keBEwJngQpWAi+4SRxDexYmIIzFsQP5NwdoXq9SFJq0ziTk90WueqKt308L?=
 =?us-ascii?Q?PLrgtc5CVJv/ULuduBU1AcjynlbHOSC6miZ/mXc/sT0z1zJXVuR0kQoOSgU9?=
 =?us-ascii?Q?EYVcKUVUDwXHBwq1bIim5ViZItYiwFtbbp/Yis44fv7lhPiII530bifGdB6X?=
 =?us-ascii?Q?j8eiqjHYGi9UnNjx2phOBA3urZhVCiKr+bXyIHmQQhIbK1+xUWhODL5CTkw1?=
 =?us-ascii?Q?6vsq5TsZPo4Y7ZEO3mZPyS13nkpsxukvPm8pCuVsdfr47Pw9glrwxnf/h4PZ?=
 =?us-ascii?Q?FRa5qi9eprKjUBFHuQyz5Rzx2BriR42LYNFbIJmxuZWHxZlmQfd1280Lgd0w?=
 =?us-ascii?Q?3Ai6nndJODDmuSimrFxsE74yEKQ04a7JTXjm3VqOx2OqH7E5LF2cCHWEfZ+M?=
 =?us-ascii?Q?e28/ZhzjmqFqZWydLt9GLtRmNMu/P+JkLSNBWfb5ID4qsBJomlkbpuW6RsYy?=
 =?us-ascii?Q?WWQJ4MzUcrse4NpCPCv60LCGBH6oK8UqWGBq1v1N4pLpqRawaLaE37GnMm99?=
 =?us-ascii?Q?4wHwSTE3UHsQI7wySsEJLIHLXsxosdoAEWVALfGpp99Cl0Vpq721Mg9W0sId?=
 =?us-ascii?Q?HSr/t08Ipm/kAFaNLho0sPLH37Ff9CqtnbjtEjefw8WVWJ71honEeED8QLIy?=
 =?us-ascii?Q?1TL88gEisg7ym1rrG1exFO0iLIGkdtfOGLTAV6HJPvMi2WrA0TAkcBmkEqcX?=
 =?us-ascii?Q?ztrim4nTmCGWNOraSU+Pfd2o7OnCifjw+IpgMD6Gt8CZCwlg3T89D0Afg87P?=
 =?us-ascii?Q?FsbBNYMAeKeBzTQ2FyG3uk1UH+tn0AeUWynA89iAgNzVHo1k97PvKzLBEIBc?=
 =?us-ascii?Q?sQXKhyWAXDvGe3YaznQUxM+q4nru?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8qsU1W5RlNUMhu2gD9jqlP42zXwTCP1zC0RIVe/qlQ1+h6ptyvCJsIj+bJIM?=
 =?us-ascii?Q?X5CIuYSfIuCS0M/f4t6MT9Zj0ab58Z2+ZN63UknEfLDVo6EDN0wpytqEJMHN?=
 =?us-ascii?Q?cZoigcDyxX4Yb060YPrSbYXtjaQX3hb37hkdpUXOwv0YnTh222EGMITRRDJE?=
 =?us-ascii?Q?4N0YQEPCGe9j8t/HQpAnC0KvpQiHEdkCZC6DUMRkPed55HGcZHlbjmUTR96N?=
 =?us-ascii?Q?A9P0ULAH5tIj7DiCuhRvfIh/X57diolTZPQABIDwbVACYlBxSj3UVCeMLVdg?=
 =?us-ascii?Q?RurowuPSjaXtwCIobxhiF+WwSIz7OzY7kdkbI/Ni3Et8Ktm7xWIPLKKp3gcj?=
 =?us-ascii?Q?DCvO4jn8YjC1rlQaF+X+FRGNIFaDuTexyQH6wH8nQKD8Bxfm0AOaoXXAUo5s?=
 =?us-ascii?Q?aPe10SuQ4DcvTOCjnx2goUzEXvvU2bSsSynddhSjJiVLzkxcgiyz2Ok8eVz4?=
 =?us-ascii?Q?AUU76Y55XoevqhiwoxX6oahKwkuOSPbXyKIcvtVypM5+jjUoGJ1hFZxF3lb/?=
 =?us-ascii?Q?CxK2igOenfChLZiz/Wwb7ypyrwny7ilcUxPBqtocwSrtFV6fnpP5z42DLl+d?=
 =?us-ascii?Q?jjDrBKpDmWozIT33L/sZfSy4u7wN0S1wA96LNhCPWEqHwyRIxBW60o1GtiJ3?=
 =?us-ascii?Q?xgLzYl2cuqxNnDnr+XyEyPUFvWJXCILW9qfPsgsucd5wVmMxr9dPaEU/H8Js?=
 =?us-ascii?Q?DBpJYCBsBkIAD+ijzJnWJ9vevwABtAbbAO3kVhtWKNYWQql38XaeWgJ+jpek?=
 =?us-ascii?Q?yLmE00ZxYPmyGXB9RBmnWp5qwhA7xDKNHo0jViAJiREgKalGrzANsFLzTa6u?=
 =?us-ascii?Q?UIHwW5nXsLhxhP+I6xZXDhAwwNH8SkszSsVC8CcW+V0OYsZcY4G21zXE3Kgj?=
 =?us-ascii?Q?kwp0SDWRbS0xhD2fUBHMBOSHf80F+hURiLyjG1WNg8SffBOW583fy+oHYjb2?=
 =?us-ascii?Q?B9FJdP+2ni/6ATZ3xq8Chmlc1QELNN6C731wRHEkHZeX/4C0FLeuQoc9bIub?=
 =?us-ascii?Q?HgF+RU/rE6E35OMd20N4mUqPDYkGylIW7GPwF/purXE9+x2PHBYUIFSKsQrt?=
 =?us-ascii?Q?/TplfbMggYxBWn5u6maKAxhqcfZNW/LpqiJFNcub3uot8MJNn53YE841v2xV?=
 =?us-ascii?Q?0DG1Gmc/aMxMPByqAjncETZ8CUOFImkI8RCWz6JH5yg+I4sg9mZi8SeVikDu?=
 =?us-ascii?Q?X81wxuj/8vIRftGAY8Q4GmJEXZ40/7VMBVuG5rfrWPQLQoNjw8N3KLN++RAx?=
 =?us-ascii?Q?34lrHZJ7CNN8WUGCA5lhGIASOQLf2rHcDdpjureUgaLiIlCDaQ1Xbx+D61zV?=
 =?us-ascii?Q?Y6F44/HDoeaFvP0lbwThom/SYwjRm2nY9eo+lH9LeAFTxH39sg1asgY3fwhE?=
 =?us-ascii?Q?HnUpGZJnwyWlt6TzrHhSbB81rEGIBM0OF8buxrO8NrXOeQsmv+/iFNDFNzQH?=
 =?us-ascii?Q?KlnH/UjT01MFTdz6rb/D5Z+1LUFhocZLSuhh8A/kdOtTMBb1H3ioJtXrXsqh?=
 =?us-ascii?Q?Od6eySOzyz8ZUYcDG2/v7LNuwe3VVSfMKBKenNwDcs7AgYm6QGO04kngKM13?=
 =?us-ascii?Q?wkcrmwOLFhkVyDv8Np4rZK+GCU6T/Vma5D4/6BRb0T/YU5xjQ+ybNmTzn90N?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49aa888a-fea4-462d-e846-08dd2ee93d81
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 07:02:25.1992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2lh1InHZWdsSGV//d0VU5jTkyvQm4mLq2UIRIgtgmef/0zruio2SRgqvOYee64UvCrq0NIVuqRLV6cPHOidQpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5987
X-OriginatorOrg: intel.com

Here's the KVM side fixup for patches 7-11. (attached in case you want
to take a look).

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ced4d09b2673..c3a84eb4694a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1606,13 +1606,11 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
                            enum pg_level level, kvm_pfn_t pfn)
 {
        struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-       hpa_t tdr_pa = page_to_phys(kvm_tdx->td.tdr_page);
-       hpa_t hpa = pfn_to_hpa(pfn);
-       gpa_t gpa = gfn_to_gpa(gfn);
+       struct page *private_page = pfn_to_page(pfn);
        u64 entry, level_state;
        u64 err;

-       err = tdh_mem_page_aug(tdr_pa, gpa, hpa, &entry, &level_state);
+       err = tdh_mem_page_aug(&kvm_tdx->td, gfn, private_page, &entry, &level_state);
        if (unlikely(err & TDX_OPERAND_BUSY)) {
                tdx_unpin(kvm, pfn);
                return -EBUSY;
@@ -1687,9 +1685,6 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 {
        int tdx_level = pg_level_to_tdx_sept_level(level);
        struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-       hpa_t tdr_pa = page_to_phys(kvm_tdx->td.tdr_page);
-       gpa_t gpa = gfn_to_gpa(gfn);
-       hpa_t hpa = pfn_to_hpa(pfn);
        u64 err, entry, level_state;

        /* TODO: handle large pages. */
@@ -1705,7 +1700,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
                 * condition with other vcpu sept operation.  Race only with
                 * TDH.VP.ENTER.
                 */
-               err = tdh_mem_page_remove(tdr_pa, gpa, tdx_level, &entry,
+               err = tdh_mem_page_remove(&kvm_tdx->td, gfn, tdx_level, &entry,
                                          &level_state);
        } while (unlikely(err == TDX_ERROR_SEPT_BUSY));

@@ -1734,7 +1729,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
                 * this page was removed above, other thread shouldn't be
                 * repeatedly operating on this page.  Just retry loop.
                 */
-               err = tdh_phymem_page_wbinvd_hkid(hpa, (u16)kvm_tdx->hkid);
+               err = tdh_phymem_page_wbinvd_hkid(pfn_to_page(pfn), kvm_tdx->hkid);
        } while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));

        if (KVM_BUG_ON(err, kvm)) {
@@ -1751,13 +1746,11 @@ int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 {
        int tdx_level = pg_level_to_tdx_sept_level(level);
        struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-       hpa_t tdr_pa = page_to_phys(kvm_tdx->td.tdr_page);
-       gpa_t gpa = gfn_to_gpa(gfn);
-       hpa_t hpa = __pa(private_spt);
+       struct page *sept_page = virt_to_page(private_spt);
        u64 err, entry, level_state;

-       err = tdh_mem_sept_add(tdr_pa, gpa, tdx_level, hpa, &entry,
-                              &level_state);
+       err = tdh_mem_sept_add(&kvm_tdx->td, gfn, tdx_level, sept_page,
+                              &entry, &level_state);
        if (unlikely(err == TDX_ERROR_SEPT_BUSY))
                return -EAGAIN;
        if (KVM_BUG_ON(err, kvm)) {
@@ -1773,14 +1766,13 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 {
        int tdx_level = pg_level_to_tdx_sept_level(level);
        struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-       hpa_t tdr_pa = page_to_phys(kvm_tdx->td.tdr_page);
-       gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
+       gfn_t base_gfn = gfn_round_for_level(gfn, level);
        u64 err, entry, level_state;

        /* For now large page isn't supported yet. */
        WARN_ON_ONCE(level != PG_LEVEL_4K);

-       err = tdh_mem_range_block(tdr_pa, gpa, tdx_level, &entry, &level_state);
+       err = tdh_mem_range_block(&kvm_tdx->td, base_gfn, tdx_level, &entry, &level_state);
        if (unlikely(err == TDX_ERROR_SEPT_BUSY))
                return -EAGAIN;
        if (KVM_BUG_ON(err, kvm)) {
@@ -1817,7 +1809,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 static void tdx_track(struct kvm *kvm)
 {
        struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-       hpa_t tdr_pa = page_to_phys(kvm_tdx->td.tdr_page);
        u64 err;

        /* If TD isn't finalized, it's before any vcpu running. */
@@ -1827,7 +1818,7 @@ static void tdx_track(struct kvm *kvm)
        lockdep_assert_held_write(&kvm->mmu_lock);

        do {
-               err = tdh_mem_track(tdr_pa);
+               err = tdh_mem_track(&kvm_tdx->td);
        } while (unlikely((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY));

        if (KVM_BUG_ON(err, kvm))
@@ -2756,7 +2747,6 @@ void tdx_flush_tlb_all(struct kvm_vcpu *vcpu)
 static int tdx_td_finalizemr(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 {
        struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-       hpa_t tdr_pa = page_to_phys(kvm_tdx->td.tdr_page);

        guard(mutex)(&kvm->slots_lock);

@@ -2769,7 +2759,7 @@ static int tdx_td_finalizemr(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
        if (atomic64_read(&kvm_tdx->nr_premapped))
                return -EINVAL;

-       cmd->hw_error = tdh_mr_finalize(tdr_pa);
+       cmd->hw_error = tdh_mr_finalize(&kvm_tdx->td);
        if ((cmd->hw_error & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY)
                return -EAGAIN;
        if (KVM_BUG_ON(cmd->hw_error, kvm)) {
@@ -3029,7 +3019,6 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 {
        u64 error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS;
        struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-       hpa_t tdr_pa = page_to_phys(kvm_tdx->td.tdr_page);
        struct tdx_gmem_post_populate_arg *arg = _arg;
        struct kvm_vcpu *vcpu = arg->vcpu;
        gpa_t gpa = gfn_to_gpa(gfn);
@@ -3068,9 +3057,8 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,

        ret = 0;
        do {
-               err = tdh_mem_page_add(tdr_pa, gpa, pfn_to_hpa(pfn),
-                                      pfn_to_hpa(page_to_pfn(page)),
-                                      &entry, &level_state);
+               err = tdh_mem_page_add(&kvm_tdx->td, gfn, pfn_to_page(pfn),
+                                      page, &entry, &level_state);
        } while (err == TDX_ERROR_SEPT_BUSY);
        if (err) {
                ret = -EIO;
@@ -3082,7 +3070,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,

        if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
                for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
-                       err = tdh_mr_extend(tdr_pa, gpa + i, &entry,
+                       err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry,
                                            &level_state);
                        if (err) {
                                ret = -EIO;

