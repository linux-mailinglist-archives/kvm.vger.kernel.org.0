Return-Path: <kvm+bounces-33294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93EAF9E9211
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 12:22:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61C8E1882655
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 11:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E753219E83;
	Mon,  9 Dec 2024 11:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UiejVeUq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C31217F25;
	Mon,  9 Dec 2024 11:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733743330; cv=fail; b=C2U68t1vTNYxszDCsZVoNpr2gQTaKZRpQvceeR3fzKcvRv/vvBCLK+MiQZTKnG6RIE/T8+1J5Z7NXymjgh2THAadegZTSE7fXI4NR9/Exn63Wre8e6o03/xFOc7CFmyyGr2BK5X0hbaP8hqc0XHa9snpmqbPPluXpeqZNfbjeoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733743330; c=relaxed/simple;
	bh=DpWri4XgTM3s3NVyDp5tvLNaO5jOnDlT9wMtGQuWVhk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gj02fShJMZlFgnaUNptTxBZg4RAcM9TX3pajO2COzHuCJOMdn3sr7Ibmv6d6x33FLIIp8aCImGLlWpyMq6EcdXz1+1Z8fhPndeGyvBIGgwZHvA6YUIAk0OBnXHvioC803z5Z7ALNujUWMOllSjVBnlZFGBEu9TeVajfa+nH3hLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UiejVeUq; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733743328; x=1765279328;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DpWri4XgTM3s3NVyDp5tvLNaO5jOnDlT9wMtGQuWVhk=;
  b=UiejVeUqK8Qniqx+M7NMjzPXgwjCS5vB0wrPtBa9pkRVgiNYrtvfcujm
   E8j20vWvlFxP5arGvPFLigzNsdlXqkuSYm2cwdksLVRmvJfZmqDbZXmVi
   MnmQLgj2hLmr7NL731JUI8wZoWgK3B/u/6IjMmqwAvOOMrsVHHJsuTtG6
   YCkURzUiJSr7oIVucXC5+4spieYWhU4d4eATon3Z/0RIE5MPwhTc2cdve
   xKr2RPi8vZ+NJ64X07yr0nJ5ogVoKFjkcK6XsHVEmozz4uxGlNvSeV1Mt
   FNVD5ndByVBdQMWS0hsfShGKoyInwxy92d6JKZVxbLA2nLQKC3C3LDquA
   w==;
X-CSE-ConnectionGUID: RXS9VryIQMSQ8jKVTLrf3Q==
X-CSE-MsgGUID: 8ZSEhQqOTzeM1W1gTS1G4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="33959091"
X-IronPort-AV: E=Sophos;i="6.12,219,1728975600"; 
   d="scan'208";a="33959091"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 03:22:08 -0800
X-CSE-ConnectionGUID: wUzz5CugS8qccnfA70Tcog==
X-CSE-MsgGUID: laV/AfiwR6Kpn/Fsa56ubw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,219,1728975600"; 
   d="scan'208";a="132422203"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Dec 2024 03:22:08 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Dec 2024 03:22:07 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Dec 2024 03:22:07 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Dec 2024 03:22:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uBt7LCX+wj9y0JGLvq0fG7fvW6OGv+My+0FanZWByH00ealgU6q/B0TABkn7XXbNFdDc3jl8nxkOcC3oo+Aj9v/h2WONQ8ngJhdzMw940yCga4qPeWOaQUS7s33TaRtmTR+oMCVSZq+bg8kVAz/Yry76ggHPw9FZTjG5eIuQO5K4nAnucIboK6jvRk85+OUDM6JjdZK3Bay5VYTvgfZ3qmA8EPT13EooUK9b/djWezQFTlzny+1OgSoj50NYNMPtZuvzz/ppREPtLe3xcjoOyk01MF4Z8bWxCKz/WcU/jUgez0V9OsEFLX4pOZnebQ754UkRTsXWJSKlB8Byt+sgGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQuKITi62FAmldBmZxx7nnKv3DsDm2yOrP0JIpSalbw=;
 b=ddsr9qGM8RH6vMP/5qmcJp6hvLEj+dd0e5I8xhmXyoEA7T4TEwL5TTQP5V6DEBN4SOzgcTAKD84BwKuXkYWlWnYmpAJVQZQKzUmuv0A/zmIm3wuvHVPNBgrBxeHXKQv+OQRG2Zac8EssxRkXsi+Mm4bS4pWdpG9VPE1tluM+xgJ00oQTnMvKDQb5NRut6f/DtvGBT+v7JKOl4w0wXfjy7uEJOsHYbLgtO7TtzZmMI6Pi0fNlO9Tr5vT+K/VgoPKdBiw1RaHwIDtC73tY3zPWQ3dhaM/hklrSz57CIXu8NG1mn5vRdGCKyCAfitPQPOuFJr/HN5kzMcMD+MZMEPY1PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB7169.namprd11.prod.outlook.com (2603:10b6:930:90::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 11:22:05 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%2]) with mapi id 15.20.8230.016; Mon, 9 Dec 2024
 11:22:05 +0000
Date: Mon, 9 Dec 2024 19:21:54 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <michael.roth@amd.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] KVM: TDX: Add a place holder to handle TDX VM exit
Message-ID: <Z1bS0sWkPjsaf33b@intel.com>
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-2-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241201035358.2193078-2-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SGXP274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::16)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB7169:EE_
X-MS-Office365-Filtering-Correlation-Id: 98796f89-c574-4318-03ec-08dd1843b5cf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xoeHkkuQKn9C3oR+V0Ei19HD5deYpcwT5yqbFY1NGqBMRldKGomv4VAE/Kwd?=
 =?us-ascii?Q?L5qPg6y1ugD+RopaxsPC6LTgycIfHfx3FSBYFFcB3+HUoaqOxCESIphSti7w?=
 =?us-ascii?Q?aGQbbBQ+0Vu4BYyjdPHt8k+XLyJl01vSggolEKHuoLJH6r1BYsih3u0B5mt0?=
 =?us-ascii?Q?3oPiuZZcXKosatcNkxPqosyWkhZkov+oauMl3I7FSvUoXoNF5itU2nf6cE7c?=
 =?us-ascii?Q?cthM1qgkvI72FEy+7e50cWWq/hCmVonFHIZd8NUF2lh83WUZ7Ar4SOlJWftM?=
 =?us-ascii?Q?mEuWICPAo9M7BrNqIWJDeupXSplVl/60opsa8tjxRcbQmzJVPgmoRqRXpqsf?=
 =?us-ascii?Q?GxOPOEyy49YZxlSirmTILk7+46hA6BckCetoMzTMr0OuY8yfF/rGKLwN1ANI?=
 =?us-ascii?Q?0ePOO3NpSkSv3PnJzxt4Z3dyrOYHXrI+AJyCUBgfpue7/uchSzaq8sjlD5pb?=
 =?us-ascii?Q?ucYnRjAXLwlYqvULHx1Vuey2Cs1jyfKGttcD35tQcHZcubweNjqkQOb2kA9y?=
 =?us-ascii?Q?7t4izUk9h5BrDcEAn31SEmQq78Em6DJuBzd4c9tsmi94RMQ7SbNVuPcGYpo0?=
 =?us-ascii?Q?erYG+LBdcdHBQ6GB4c5VwoRLf1HOa3lAOfNjhDNoxdQd6j/Ro5cClVQ1yTga?=
 =?us-ascii?Q?Z5ZmrtEgkXEg7kN1nqhF97Kyi8pf8mitUJRhmhRVAEJCDMiS4cyzQYYatcHJ?=
 =?us-ascii?Q?dsO91LUsuHvGKVKVUkn8YZC3dyN5qlug3I+Ef8pdXlAxUNOgKyYz/nYCYskf?=
 =?us-ascii?Q?lmG0hjAJdZVmTkeQcTLpqwD0lFeUhZ4Wbq6/oqkPMfV5bPcTeNAqBktLOZXu?=
 =?us-ascii?Q?PJu6PqGJ6sji3/eoN1fZ6iS2RdU7oP3nVtdXd9m9gkesHSSPhiQQCgIOCjHa?=
 =?us-ascii?Q?f7FgDgk0/jTOXBh8W5vBT4n5RehpDZJsOxQCL1FKzDJX+cgjehAqlrlmhbx1?=
 =?us-ascii?Q?JDP1EAZPu/CfLEF8yjpxqSHLWNSIV4thD4RyoFVXZqCx0RWDxyNR8C/NkDJ1?=
 =?us-ascii?Q?A5TAVpanoNBbQ0jE8HmAs3hvlCkaVHDj1+etg6onnDUElmNakdvaZkngI/lx?=
 =?us-ascii?Q?xFUazg0/HFNPG3WrUGBbpLvWdCj8BKRlSCStCXc8YWsr2sRiiFjfs3q48tKW?=
 =?us-ascii?Q?snN4BVIM5DwbjxQnB/D6T5zMUL1VxoAqONxwM88WxcLD/GwfuV4eHdVMOkN/?=
 =?us-ascii?Q?QuCCkVaQzro3KvOA5Apzkw0S4m4RHVAvdQjRkZm1qY6LB8NF4LackL1EE5dM?=
 =?us-ascii?Q?Fx98b/8O+tbas3jo9e+U4tSXpBy+KFkd/4GYWho12SgVq7KKxmao04JMiUc3?=
 =?us-ascii?Q?bFiyzkEmZFzLpym5pOPeGAGF1oG3E6xm0q+0J0JGhhoXsA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qvq3YIj16alQe4w/WtiqQEfKeJC78UabAoKXfcNTyNW/C4sbTQvR6zvUJnnE?=
 =?us-ascii?Q?y2vk4ArznuSN7CtPzX5/WlR6JyQzHODBWsQCaUOmQp1xFd/iXrXfD7vifw0o?=
 =?us-ascii?Q?l9+m7ZC2lfXOe5GknFTnOiLttWVhH07EO959LiNswjs/G7ufOumNYEwMSoO4?=
 =?us-ascii?Q?wpwOSFHmeBmtGhsW9G6/WG9JxZuwRujPPchv4bsQE+edOFg8ODFIm1r7BvEa?=
 =?us-ascii?Q?eAZF2ktXdVsa1R8XSVmRd+SbuXo8f0WMawhwOJQxZw1eOR10YHRFSBPM7SYj?=
 =?us-ascii?Q?qdMcjEaqiZI1L9WkKYeWUjCk3qwsCB5AeI1zkwhCPokYDfPkBgp0cASjjD+1?=
 =?us-ascii?Q?whONKQIQDbHH4IqwPOEIONoISWWdD5ES+SSR179kO1Y3DjCyCl9fvvccgpib?=
 =?us-ascii?Q?65YWnWnXF0/lf5vkIyjKmZhKe9kvIU54DbxgzmlHlaDmNQhuUTwe67RuVLQ+?=
 =?us-ascii?Q?RHnA7ReGgVjTnEAoMK8c85IEJRO6V/B9UUlht05BeJVzfg90c1cbBXxbfafQ?=
 =?us-ascii?Q?ivif1dbrQPTIwk9ECpeSy18AzarusWUqoiBCqU+simTLD1R8gKm4prxyrcL1?=
 =?us-ascii?Q?quD1K/LqzoSD7BPHzBtd27AxeZWZQA05UPWRkTVqtxCjCG6FhbxvmUUcyTXT?=
 =?us-ascii?Q?4RdCjmOl1ATujd+vCq1sW/CyiTNqSBgH8rxdKu5u1+yLXRbPNhehilS41ZhM?=
 =?us-ascii?Q?tp+/LDPFUYZbEnQsYFh8B7J283VLbhPZU73LZIBtooqqBgjpdAo238aRutTB?=
 =?us-ascii?Q?EY7N6GZhmjg6FAfbEaX6ji8182bTRBTXXeB4jvAJ/xRTQp1tFtz3FmugKiiH?=
 =?us-ascii?Q?qTSFIjDPQ56dTWJB0YiA+r9tUl8KfU4eN8EdhEDzHoFdc3kNbogE8gie8Lej?=
 =?us-ascii?Q?p7wC/V+pi5f66piLu7iHugXVg9Wx+xTUYwHbZJuvjv9MfLV0y1BVQ6DOrMRu?=
 =?us-ascii?Q?apFNvBisQ3PTwjP7+YZ7Z4Pgrrb7qIqaBklWC34cVnvn68MIR36ei5RpnoRN?=
 =?us-ascii?Q?4acFL5P2YhxbMY/lc5HY6D2nG9hB8ClHjKMOoFccQS+tVRVw74vTExLnpSRu?=
 =?us-ascii?Q?eZOcF0aBMK2sbO7VE5N4YBxfEp+3/5GsWiZ3/GCYnR1qNNaQrIy9Chf7JcBr?=
 =?us-ascii?Q?juILC2fS5JMm657MnXNJ0kJYbLI9jy4G/YCJxgUduFFuvCqSo0BstVywUM8u?=
 =?us-ascii?Q?EQdnK6Td1Nkv++kP+2f9M9QPioy7TJnTLyWyr1l1zqbgSs4SHrFaAY75q2iQ?=
 =?us-ascii?Q?PrhZNgmO99DhunZL8GAgRo6iIxiYx5kOe2k9PCi6scCFxVr9/0c0n7bk9/6S?=
 =?us-ascii?Q?2F8soNCNagEfG1YitMZ0DpXhf9c3sq+OGsgP0ZbZ9rrULy4ZsBhf5pUuOHLx?=
 =?us-ascii?Q?SRvvy+ztxWXpLk0t6MAswUnFy33TINcTseqCqVT6v73lC45AdOZslGPwWejL?=
 =?us-ascii?Q?+NwBvyWYtghhNYonH1Zsy06Aaz1sqUjxEB+Y9LJUdf1UOMAeMPt7PQpHoysV?=
 =?us-ascii?Q?Q/YueChOrmQS8Gh46tYtAK4PBCbAwEGxEmRy7qTNuuul3gdFzZLVDxgbqmeL?=
 =?us-ascii?Q?O5NUw7U+g4zZ+OuFFovOVy2djBEdgneOe5Qf1u/8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98796f89-c574-4318-03ec-08dd1843b5cf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 11:22:05.0466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nHoM0nVhR+LXtzPysO5ODI4wByWu8zBRF4VIpehgDBVaLyMHQiupJefbgXfZtY9e/mT+GeNqF6ibBQiEdnsTXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7169
X-OriginatorOrg: intel.com

On Sun, Dec 01, 2024 at 11:53:50AM +0800, Binbin Wu wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>Introduce the wiring for handling TDX VM exits by implementing the
>callbacks .get_exit_info(), and .handle_exit().  Additionally, add
>error handling during the TDX VM exit flow, and add a place holder
>to handle various exit reasons.  Add helper functions to retrieve
>exit information, exit qualifications, and more.
>
>Contention Handling: The TDH.VP.ENTER operation may contend with TDH.MEM.*
>operations for secure EPT or TD EPOCH.  If contention occurs, the return
>value will have TDX_OPERAND_BUSY set with operand type, prompting the vCPU
>to attempt re-entry into the guest via the fast path.
>
>Error Handling: The following scenarios will return to userspace with
>KVM_EXIT_INTERNAL_ERROR.
>- TDX_SW_ERROR: This includes #UD caused by SEAMCALL instruction if the
>  CPU isn't in VMX operation, #GP caused by SEAMCALL instruction when TDX
>  isn't enabled by the BIOS, and TDX_SEAMCALL_VMFAILINVALID when SEAM
>  firmware is not loaded or disabled.
>- TDX_ERROR: This indicates some check failed in the TDX module, preventing
>  the vCPU from running.
>- TDX_NON_RECOVERABLE: Set by the TDX module when the error is
>  non-recoverable, indicating that the TDX guest is dead or the vCPU is
>  disabled.  This also covers failed_vmentry case, which must have
>  TDX_NON_RECOVERABLE set since off-TD debug feature has not been enabled.
>  An exception is the triple fault, which also sets TDX_NON_RECOVERABLE
>  but exits to userspace with KVM_EXIT_SHUTDOWN, aligning with the VMX
>  case.
>- Any unhandled VM exit reason will also return to userspace with
>  KVM_EXIT_INTERNAL_ERROR.
>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

[..]

> fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
> {
> 	struct vcpu_tdx *tdx = to_tdx(vcpu);
>@@ -837,9 +900,26 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
> 	tdx->prep_switch_state = TDX_PREP_SW_STATE_UNRESTORED;
> 
> 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
>+
>+	if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
>+		return EXIT_FASTPATH_NONE;
>+
>+	if (unlikely(tdx_check_exit_reason(vcpu, EXIT_REASON_MCE_DURING_VMENTRY)))
>+		kvm_machine_check();

I was wandering if EXIT_REASON_MCE_DURING_VMENTRY should be handled in the
switch-case in tdx_handle_exit() because I saw there is a dedicated handler
for VMX. But looks EXIT_REASON_MCE_DURING_VMENTRY is a kind of VMentry
failure. So, it won't reach that switch-case. And, VMX's handler for
EXIT_REASON_MCE_DURING_VMENTRY is actually dead code and can be removed.

>+
> 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
> 
>-	return EXIT_FASTPATH_NONE;
>+	if (unlikely(tdx_has_exit_reason(vcpu) && tdexit_exit_reason(vcpu).failed_vmentry))
>+		return EXIT_FASTPATH_NONE;
>+
>+	return tdx_exit_handlers_fastpath(vcpu);
>+}
>+
>+static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
>+{
>+	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
>+	vcpu->mmio_needed = 0;
>+	return 0;
> }
> 
> void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>@@ -1135,6 +1215,88 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
> 	return tdx_sept_drop_private_spte(kvm, gfn, level, pfn);
> }
> 
>+int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>+{
>+	struct vcpu_tdx *tdx = to_tdx(vcpu);
>+	u64 vp_enter_ret = tdx->vp_enter_ret;
>+	union vmx_exit_reason exit_reason;
>+
>+	if (fastpath != EXIT_FASTPATH_NONE)
>+		return 1;
>+
>+	/*
>+	 * Handle TDX SW errors, including TDX_SEAMCALL_UD, TDX_SEAMCALL_GP and
>+	 * TDX_SEAMCALL_VMFAILINVALID.
>+	 */
>+	if (unlikely((vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR)) {
>+		KVM_BUG_ON(!kvm_rebooting, vcpu->kvm);
>+		goto unhandled_exit;
>+	}
>+
>+	/*
>+	 * Without off-TD debug enabled, failed_vmentry case must have
>+	 * TDX_NON_RECOVERABLE set.
>+	 */
>+	if (unlikely(vp_enter_ret & (TDX_ERROR | TDX_NON_RECOVERABLE))) {
>+		/* Triple fault is non-recoverable. */
>+		if (unlikely(tdx_check_exit_reason(vcpu, EXIT_REASON_TRIPLE_FAULT)))
>+			return tdx_handle_triple_fault(vcpu);
>+
>+		kvm_pr_unimpl("TD vp_enter_ret 0x%llx, hkid 0x%x hkid pa 0x%llx\n",
>+			      vp_enter_ret, to_kvm_tdx(vcpu->kvm)->hkid,
>+			      set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid));
>+		goto unhandled_exit;
>+	}
>+
>+	/* From now, the seamcall status should be TDX_SUCCESS. */
>+	WARN_ON_ONCE((vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) != TDX_SUCCESS);
>+	exit_reason = tdexit_exit_reason(vcpu);
>+
>+	switch (exit_reason.basic) {
>+	default:
>+		break;
>+	}
>+
>+unhandled_exit:
>+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
>+	vcpu->run->internal.ndata = 2;
>+	vcpu->run->internal.data[0] = vp_enter_ret;
>+	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
>+	return 0;
>+}
>+
>+void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
>+		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
>+{
>+	struct vcpu_tdx *tdx = to_tdx(vcpu);
>+
>+	if (tdx_has_exit_reason(vcpu)) {
>+		/*
>+		 * Encode some useful info from the the 64 bit return code
>+		 * into the 32 bit exit 'reason'. If the VMX exit reason is
>+		 * valid, just set it to those bits.
>+		 */
>+		*reason = (u32)tdx->vp_enter_ret;
>+		*info1 = tdexit_exit_qual(vcpu);
>+		*info2 = tdexit_ext_exit_qual(vcpu);
>+	} else {
>+		/*
>+		 * When the VMX exit reason in vp_enter_ret is not valid,
>+		 * overload the VMX_EXIT_REASONS_FAILED_VMENTRY bit (31) to
>+		 * mean the vmexit code is not valid. Set the other bits to
>+		 * try to avoid picking a value that may someday be a valid
>+		 * VMX exit code.
>+		 */
>+		*reason = 0xFFFFFFFF;
>+		*info1 = 0;
>+		*info2 = 0;
>+	}
>+
>+	*intr_info = tdexit_intr_info(vcpu);

If there is no valid exit reason, shouldn't intr_info be set to 0?

>+	*error_code = 0;
>+}
>+

