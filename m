Return-Path: <kvm+bounces-48710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC66DAD16EF
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 04:38:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC41E3A7FF6
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 02:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E60B62459F1;
	Mon,  9 Jun 2025 02:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m0vCLPds"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8BC2451C3;
	Mon,  9 Jun 2025 02:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749436683; cv=fail; b=pGkT0AdkGNR394TOgSZLwXP2Q6P2H/I9o3h1CQVFsbRv/psp9hc5R3ZvmepMETIgTOPwRePGfioGucOPfWXMTKrRAw3/YtU6NgZmZG/UP27dgcJjMUHaGxETHvSQsgKcLiYjCpiOKsI5PO7JuafxgX6o6yUMnsrBkw4uAYY3E7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749436683; c=relaxed/simple;
	bh=utXCIWDUm4e8ru25lqh/XziBy17DiYsp+fXJ3aSgR6c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UGWvZorrRRdGrTJDFXzGYbBP729SrcgPOTFC9HxJxaTe+p/vbDbE6aAK8cAgkl4AA8cfGFxinYzDgPdMYVNmgOqhoMq/8kAqex77UaBwVIEWho1BhAm9xDzu5sZOD+5WeTbZ+iMB5qOKvYksqskLGJjFHPp0FFBgt5IwLXLjxIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m0vCLPds; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749436681; x=1780972681;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=utXCIWDUm4e8ru25lqh/XziBy17DiYsp+fXJ3aSgR6c=;
  b=m0vCLPdsYE0zoOzJzzHJ21/OXu0IQIrCkIndw8w42mBccX8PTBQ60cAX
   eN+9Nid5RZAHhD8ZnivHqyhEsmyxNe1H3yDzo/yB3QqylRg9OnLonJN7x
   Hpdkwt9sbH7STJeEjs6WVBy6amfUv8S4QtOptICnq76jR/jQJ+Wn3gQEN
   Vq51Eh+iNGdw/nvYbc8OebePsYI3M4nN/JOa2H/Vtde+1es8qiEHNHZj/
   FR0+KZ1lPzslq+2BdBPxHl+mAlF2YZCN23aenlFu56EpV60Jo6spenQj1
   XPWT7ALUCiVaqH6oX8lTBVvdbpjwRgnLMKIRYU7HSNiRX7RG7C1xHC5el
   Q==;
X-CSE-ConnectionGUID: Yt3XaJe9S5K4gaEIA4XKNg==
X-CSE-MsgGUID: CUBKnRn2TUutKInbUqzlJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11458"; a="51602580"
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="51602580"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 19:38:01 -0700
X-CSE-ConnectionGUID: dnn/IQbxRTuNITElRGRtVg==
X-CSE-MsgGUID: cha4TQR7SIGIdtOyCMLkKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="146286139"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 19:38:01 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 8 Jun 2025 19:38:00 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 8 Jun 2025 19:38:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.75) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 8 Jun 2025 19:38:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p3Aom+TWxNKP09smAzyFiM2+oA1ryY8oyuPy1UmoSLZOFSehwCAYyiRLkhp6zY1p1NBi2v4Z8+O9BVCb7l6xI2b4dNEmbcJ3cRthpQfnsUK+dSF5h72sX7B87cdiqOMILh7YBEidqW4Kptdsh3csCAmEeZfY3oDQr66FVymus6PnbiJcQRwy5K3fGVlu60uSsr8fEqLtKSqBIdHBWQUaaRK71xW68d4wE/hux8XXf1jLunnVc6Yc8aYlPdo6TubgOtUADC1QG1ArakUWgXRCGYw9F/vDaWkeGbjmpZ2Xs3CHdzNjM8cC2QK1qN/X1UzfLRUbLtL+lPJm25p08/vZug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQAha/u0cvSWPTuTY3FgeVKUzpX8y0+7GNsUxb3MI7Y=;
 b=G+JrYJGn59xCAYNWOzIOM32LqmxRhkzn5CsPFr+/BJmpKt4LIPw54sBLPodt+KIjVzBCNm/JtmzPy825lLPPpXP0kn94MMejgRj+2H9I1vhaVmI9bUr4uc0ovC/xqp30XMn3gQxBGiF0dxB00EJDoUiuOW9hSnkxsxyIxJpX7Qq+mlc58JU9WYYRG3d4r2TLI4XeNJ6l1lu74oLQCKr6MDCGYJ86r/AR7A/N8Gi8F5KA0KOKAXmowWjkxA7GuWNAUwmh824BLB39hE0tSOl1TuDubrxFGJTU84TJ8oGAMWomDVTpC9k/HBBKRV3XMe/JAykRI5zLiJs/RXi0bLZoNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL1PR11MB5270.namprd11.prod.outlook.com (2603:10b6:208:313::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.30; Mon, 9 Jun
 2025 02:37:44 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8813.020; Mon, 9 Jun 2025
 02:37:44 +0000
Date: Mon, 9 Jun 2025 10:37:31 +0800
From: Chao Gao <chao.gao@intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
CC: <linux-coco@lists.linux.dev>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <eddie.dong@intel.com>,
	<kirill.shutemov@intel.com>, <dave.hansen@intel.com>,
	<dan.j.williams@intel.com>, <kai.huang@intel.com>,
	<isaku.yamahata@intel.com>, <elena.reshetova@intel.com>,
	<rick.p.edgecombe@intel.com>, Farrah Chen <farrah.chen@intel.com>, "Kirill A.
 Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 11/20] x86/virt/seamldr: Abort updates if errors
 occurred midway
Message-ID: <aEZI63RZ3t28G/Ft@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-12-chao.gao@intel.com>
 <a845370c-a1f0-4d02-9144-f199ca845d59@suse.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a845370c-a1f0-4d02-9144-f199ca845d59@suse.com>
X-ClientProxiedBy: KU0P306CA0053.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:28::6) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL1PR11MB5270:EE_
X-MS-Office365-Filtering-Correlation-Id: 331269ce-cba1-46c7-f329-08dda6fe9cd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ZYPlmcMzDqDhOvUuLiJ2dL0YiMTadTTZHg4KHUASFcfV8/IUX4bi9KxKdx7R?=
 =?us-ascii?Q?ARBJjXgaoD8OqVY1ylMCggMLK+H5dAvUmNb5nWPCSvFtOkf+zFa6EK+seToU?=
 =?us-ascii?Q?f/ssRVD6g3mza03p75wU4nZ5rnxuYH+a4wRywsCtDSAicszGpDs5c9X5UvDJ?=
 =?us-ascii?Q?mRhCWobsGF7tTxcWY6drXnuH8LxbnqPYllLs96XH/e6vyK93ModWJrhx9FZh?=
 =?us-ascii?Q?QqYflg+s30wb7ShM73FFOK2WMRlwa4SdLncknTWhqyfRIHcdAlMC1AfSzv5U?=
 =?us-ascii?Q?pfL+VNUf1JLkS1saQn/NXcB8ikwAjZfDlqFvHPblTCNLwxNE664OqUuXWfiC?=
 =?us-ascii?Q?mXO83wtnZnZNN7WUDGXObfnRNNZ7JDwHnlgFf3c4k3+3etl1ZaUBIxDz30TY?=
 =?us-ascii?Q?CSRdee8TvxJk71slFDHix2Af36KYZNNQbJMyTKcc6sLEvvMMZZHnGefiw0Ts?=
 =?us-ascii?Q?uuiev198IO5IUVbFNMCTmlbyX7cGOZQLnGEyjHEb44utv8fBu0B18MsYW1YS?=
 =?us-ascii?Q?U7c/qE9jTOMtEM8uHWiytG00zFz3u1DFA9hYISwTc+9Pt7R+yEbHNT2gKiAD?=
 =?us-ascii?Q?5/bLCjIXHT64q7HxDmN0jGELUZ00ETTFOvCGVjYmQdZl6uuLcsxz5b7MtSXy?=
 =?us-ascii?Q?W+9JEkXJWhWFKjOadPNwSrgXfte/Ys+owRnKaS9i5+osDmNEViQxC2nWbLXv?=
 =?us-ascii?Q?2lYoQcNARLwmtScSDoQuM1Aj73rj+qEvHJICpla9GqtssPnhzCikH0z3vIR4?=
 =?us-ascii?Q?ocQP4eGXlsAuAG3DBXrqvNvCsxo0CBXvOn188fBi66mhPial0wlupltaF+gO?=
 =?us-ascii?Q?jloJUB/+hpSWyedM4ykTXAy3FkqfhW4R3EIzAec+gXIBG5mafARN0HcHTnk0?=
 =?us-ascii?Q?PTsD2/CzNCe73//FsC2hP9BU4u1xuBE8Bx5ifnIPQ8ioFlA8Ze7OK88WWXAm?=
 =?us-ascii?Q?JC1I7XcYW5FeQslk84rIkC6jpcqORGiBVerpuCVGIvj/DilwAXHlEWgz7f+p?=
 =?us-ascii?Q?gMHFT5YMisGsMjA+tNU4c5ROm3v/qgA4QG526VtJDEs0JMomwekuSSWF+UVj?=
 =?us-ascii?Q?RRwV3hP4ZflliQI8fby9SoJh3th0dczj7gUxTkKAarqX/pyAjSrunsCJiYxb?=
 =?us-ascii?Q?2LkuSwu9t+zEvAeWXPU/YH+XsGKOPI/h0HK70J/jYsw7wW4M+VCYvSx7RgJT?=
 =?us-ascii?Q?o7bMtAdS5TEGwleKajQ6424RRDzhWnqY5jfFn+qwTXRyWiHaCNXu17vtVzEM?=
 =?us-ascii?Q?5BqIQ0Qj0LW/lcWAuVx9Mtz2YY+x8i0qsYEjrmmVxLUNaIFuBxsI2mKi+tKl?=
 =?us-ascii?Q?yQ2Zk9Kw2N+M9SnZ6eLtUuMmlYJMd1h6VeDPGbv9gT8kFc6X49JpqUhhk+V4?=
 =?us-ascii?Q?hZ9KcYB8DL10A+lNsy+Q42GszBlqgWnie73bk5gFHBWt8wq+w6pNmOc0IMSx?=
 =?us-ascii?Q?VQFvNeqoCHQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qxWhIs1vEegn7nRRNxDs2Gg8wsMWD+1La93jlwDHr5jGHJDC/vZ6CpzHv9/1?=
 =?us-ascii?Q?UMrcXaaxR47LAI6Hw0B6zJjl4LeE0ABEdFKEp72pWTiIMm71W+W4d5nl6G3B?=
 =?us-ascii?Q?AmMt3LyeIiY2E7CCus5a534GI2x0pmc74mNCzfbbsQBQaP2xDlHIUSL946Wu?=
 =?us-ascii?Q?e0YO7dLFo0tS/LhTD9Kf+itGIMowfyTNhJpjOZPLgi0tB6rYwjiJ4Raw8RfQ?=
 =?us-ascii?Q?kR96+svQTESouizj68lzMeGkv4syHRq60fr5Y9biUM07LUqOAbXHhvFBOcBn?=
 =?us-ascii?Q?8mWDO56Lxj15qhlD8w1ZP4K7ByWkUXmtErYi0Ka7WmXWZkyczUHN2Sg5jyeX?=
 =?us-ascii?Q?eE42E8tYXNkpr6466eS4MK1LXi5sKme7XPFBgzv4sFVZ9vSPdx0G9Xq3fHul?=
 =?us-ascii?Q?pS1rSwe+EtTa/L1JG35k42xy/yTJ9OPvgqxKBl9w0uaLtvEU6xdf9vTKQAKr?=
 =?us-ascii?Q?fM0yOmPWooePD+sdoelejIHNOXxqlH3uaqXi2UG5NI55ItpozODCVcn3Fg9Q?=
 =?us-ascii?Q?JmhwqFpkwspjCw/tRRILUFLGvIKTbwQFHk1vm/Dzc/74M7Yfsc19Vwmh9vJ/?=
 =?us-ascii?Q?iTfsCFzZcvkNJ+I8AU86gOivhbRI0SuA+4zS0jDKfQ70HktNycSd6vuOjUxO?=
 =?us-ascii?Q?OUaUakPjRkR04X8LaGrjtRVQ6RM2j/tquLCLC858aC4zPUDTWWasO1Z9SjBG?=
 =?us-ascii?Q?Ndxju5JQzix06s9FbrgjsNyI6oGG/KGneZr8AvlXC6l3XFPqGhG+Tp4EAZ2M?=
 =?us-ascii?Q?9WjPLtg/MDJwdtuz28SXNiRKVLtcp6bETMMwYOJ7kULXzz5sPIo07LWz9/Hr?=
 =?us-ascii?Q?cxEOgwZCkvt9214PPdq8VOC5xxeav7skY4PRIa6OzDAkqwW6mI1OSth3yGco?=
 =?us-ascii?Q?mjKJNK0Aw+iGkC3QkkZ0lrX/fV1no2ASEx60u2ur9DmtlJQ1aBEK86Vt9ff0?=
 =?us-ascii?Q?lyaGMQ8+s2Bnu9uLT8K+FOTOm3IKiP0vYTEIwz3LAorNCUKrKgtSEmNj9K6d?=
 =?us-ascii?Q?IkoLr5Atr9BxJEUtSCpP07DaXk6xElzXsaQM1a+5uwItXcAs/UASQk4aBeX1?=
 =?us-ascii?Q?WyDNrur05IVBJgesf9YzerbipO9SDAJ6B+tmlwPhtWIDttBX+HLVilkenZxf?=
 =?us-ascii?Q?SEJaHezf9C94E4nzBgtQWMIJYgnGWGEt0xklNnT5WZ5Ae2TbPyD1YAo++m8e?=
 =?us-ascii?Q?EVx2vSJJRGb4MpELXlFR6EuKPLXlEMnF0Fc5m/GnxK/Xwr86uXixM4FhM7UT?=
 =?us-ascii?Q?z/nPVQmzSInvM2ham9EN6v/g8CaJ6FQt8npMBNtqnoHyaMB+VMDm2oDmFfZ3?=
 =?us-ascii?Q?noaaX0OtlTdD2DPhjXdxpZp6HvlJ1nvUq+T5oAvo1g6RPpaG1Qk5CV45hDK0?=
 =?us-ascii?Q?sBo8FYAgG1r4aVSr53SSmpbikoa5hQ3rWuKLu9hIsGv8bjD0SKowH53ARn/9?=
 =?us-ascii?Q?77uzGxytKOiGsJbAbLcmEKiQcPgoAiqo9p1m3wIHbHhrWFnHptbWx4td0woR?=
 =?us-ascii?Q?aXQZFpYeLS5Ao45e0oRXcNUdih0a8dDzk0mJoUoRYhGiNb20uWqMI6GcaxrF?=
 =?us-ascii?Q?5gfVdkN/kDrmYBy+heH7iV5aU1Q/A+vTXtb0U1Pi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 331269ce-cba1-46c7-f329-08dda6fe9cd7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 02:37:44.3928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FUHqj2Km4drkMgmTYEU2VxUpaONJjw+EgURhPxuC2CQX72Oa0gXKGkdm46yJFyMHnKR8PFii6Zz5uxcCvsysXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5270
X-OriginatorOrg: intel.com

>>   static void ack_state(void)
>>   {
>> -	if (atomic_dec_and_test(&tdp_data.thread_ack))
>> -		set_state(tdp_data.state + 1);
>> +	if (atomic_dec_and_test(&tdp_data.thread_ack)) {
>> +		/*
>> +		 * If an error occurred, abort the update by skipping to
>> +		 * the final state
>> +		 */
>> +		if (atomic_read(&tdp_data.failed))
>> +			set_state(TDP_DONE);
>> +		else
>> +			set_state(tdp_data.state + 1);
>> +	}
>>   }
>>   /*
>> @@ -285,6 +294,9 @@ static int do_seamldr_install_module(void *params)
>>   			default:
>>   				break;
>>   			}
>> +
>> +			if (ret)
>> +				atomic_inc(&tdp_data.failed);
>
>Should there be some explicit ordering requirement between setting an error
>and reading it in ack_state by a different CPU?

Only the last CPU that calls ack_state() will change the global state, either
advancing to the next state or setting it to TDP_DONE on error. so, we only
need to ensure that the last CPU can see the error. This is guaranteed because
the error is set before the call to ack_state().

+			if (ret)
+				atomic_inc(&tdp_data.failed);
			ack_state();

