Return-Path: <kvm+bounces-64333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A7D5C7FA7F
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 10:34:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B32273A71FA
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 09:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C302F5A14;
	Mon, 24 Nov 2025 09:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D3WBl0L2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F44F263C8A;
	Mon, 24 Nov 2025 09:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763976845; cv=fail; b=TUPIiYt/LHZjftyGweVPWjz+K+ltmSF35n63PB9qqdQ3cHJwCAnn/wzw7PtEbuxkEbd4aFqBUMZ0EeOxTOBXIdYuZngWg71oblPO4hz8yNdrkHfO8OOnaNinu4+o1twNtmlk5941YtLElVVNxa0SpzUXRx8pt1nnfBSElovKshY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763976845; c=relaxed/simple;
	bh=8jF/1EIuMWmsmL9IIW+gL6fBGy3Ejw8VcR3Ysaeph50=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=g1ZbLCI0y+hf6eCAg73wH5uGhsUQ+0fH4K0gWAhgVARKPnsYyWCMaUr8rwcr5ILyUbLxMG1g6xXUgrPmO42LWiB25iIx6ym5Cx8UculwRbbrd6UWCFn1stz6SGlJY+DP7NShi22MWzrWlXuyrw9W/FP5mbrh+HiIKHMhl2Ey06U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D3WBl0L2; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763976843; x=1795512843;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=8jF/1EIuMWmsmL9IIW+gL6fBGy3Ejw8VcR3Ysaeph50=;
  b=D3WBl0L25Luf3OIsMC2Eyv5EX+tvVyuWuDemDTa/sNmrBkHY3V3VM12T
   es9/sN0UVue/4HO1uvZTBRNq7Je5pnpd7X9D4FKs+cV2Fx91cd1U0dCz5
   lrewYaH95znJEwKAZVOjGwzUzb6Cx9d5moi2AXt93U996qGA6+iMK8SqE
   LAcVdEvPQWnO8shcZ7uzMxtCv1YRJqgcyON6DdTq/u2W/01zqJ6gFJ06q
   /52HKX9/5N/kHBiIGfHjAV1423AOwpA2bv+zyUgnSQE89T2MafgNb7V3c
   gnBDMwIuupXAaEDeSSK/rpCHuWsHOvH22zjXDoxP4ue8Q9zH8FdWq0S1L
   A==;
X-CSE-ConnectionGUID: ym2ni733SVukfx1fin7K9Q==
X-CSE-MsgGUID: 2l60iQ4kQRi+yAanLDDbhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11622"; a="88624049"
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="88624049"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 01:34:02 -0800
X-CSE-ConnectionGUID: fbU8yIebTQGqMkRLLZ93hw==
X-CSE-MsgGUID: JhZaraUZQdqgZkSDl8fvhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="197211296"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 01:34:02 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 24 Nov 2025 01:34:01 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 24 Nov 2025 01:34:01 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 24 Nov 2025 01:34:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vVid7Cce7NDR5e0zUaufcJPqhxEKA7OtXS7AwDxPv4Zd9Gt9KOdMqxcpv4G7tkvLFCwbcBG5iNKsmOeUX1oVO3QqRj3Kn0UrDxmhYfXLKqq2nedROFr4GFQVOgnwNr2enN2JLEC0N2mKHLzGpMszHBn85rUmdd9n5eECyyw6H2EjBEX4rKIwpQk5dxFP+CUP3xrkT8Aifzpo54gGKQbfQEQ3BSR/wV3klhr+N5cLyzhkDcAxu32/gwzwTtvoFcmP8uw45RJInYhBm7tuhz7Pi1gRVAjgvlsLdtBYTY2q118cBXTlYo83dFFg2P8tEftGK8+HWEwER4vCc3ILNmuXLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YF0rIX7xtIR3jObRnuKuAuvnkV8gnjduQQIOZqIDVP8=;
 b=pn3KiHjh7b4P5abJUSINQcQEUAR1OiTiq+PzdnG7ki+bu840NgO4glKGcXA50YXjdjQ4spKiGi58JkN51wrDpxHAqSzQnoG5lJCCdeHCWjkiubyc9TDG2ejRGXyINZ8M+OkOUbZgHS2tJLGBefjJnpT3zaE3JJwHDJusHaMYASRQ3NYZHatfpjXKFA1gf72XiMDzqg3hjTe3OW25Q/xKUeZ4aGrb5URoMY/mwR4FxlkzsDi3bBQmpgeKxqAkriWgLE+QyPVb88PyD+vp2/nrw/89ZylXHRapK+Ro445bMCDa3Pi84qitXTgpE+5fHeZlYZr0MZbnoYffFZJLFE4O5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7346.namprd11.prod.outlook.com (2603:10b6:610:152::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 09:33:57 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 09:33:57 +0000
Date: Mon, 24 Nov 2025 17:31:46 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com>
 <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251121130144.u7eeaafonhcqf2bd@amd.com>
X-ClientProxiedBy: SI2P153CA0032.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7346:EE_
X-MS-Office365-Filtering-Correlation-Id: 621fdb85-64d3-4863-9ef1-08de2b3c9783
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?r/yhARB4dDFWU/N5EOVBXGsP2oT5TMuW/9FCaebkigvZA3xHsRNVnNfV+Oau?=
 =?us-ascii?Q?Evy61mLpgjfl6OBbIBsbSF2qEdfIflReMSEC0k6kUNtMduh+jfKdr+ZTj10f?=
 =?us-ascii?Q?Qz5iL4jIO7X9uecUBoRSm0/aNRL5VlPiUvVLNYl5g7xQwVUInAw5YWAnVMV5?=
 =?us-ascii?Q?z8JyorPPsrSXDRf0JmglWwlOCxUNayy4o9o75BJ1GeqIFgFLEbvAEDbKxy8D?=
 =?us-ascii?Q?ykH2mYpuY3PDJ60nyzD6LfdlVl64ubd2Ne09/bx3NMCUACH12gbXKVfJDIwT?=
 =?us-ascii?Q?AwKL3biwviE1/aY1+jJ8tiGvsrz80eI/HgMeB19sCTZ2gGFCUSLAjZkbR3sF?=
 =?us-ascii?Q?M40Mao0uBWPNYgRMxfrVUSFf3K2sfvHNw5hZ7YEWXLU89xPF8ShckO8s/GQm?=
 =?us-ascii?Q?SNjJFtSmgAHiz61MzLy9gkFmQKuO8p9XB6GsX/q9yVCZl2s2E0Bk4gKcVYOY?=
 =?us-ascii?Q?3Idi7xuBrHRn0Br6tjpuCPMGYkkeoRSqr3VsLHW7sIN2FrG3gmTJhC0tpl5K?=
 =?us-ascii?Q?Vp7mcPBJwgG9cYkBg/Cxr9FEBCmNBzlOp5A+kpq5PmcsB3PzuwobC5170A/q?=
 =?us-ascii?Q?5tqkNEyyPLfW+d96Pit6/ToqgWscPRnjbNS/EUHMX+OnGrZArtq0uzuP6Ep5?=
 =?us-ascii?Q?iU6ZgK/SpAwt03/pV8A8zOAeDp0yWUU4sjq89M+PMHPHMpKFnJSd0YCjp1Vc?=
 =?us-ascii?Q?MQOD9t0ermIvpHLxGthh+3+1gVsCDLQX/X1bw8y8cVWjEt9j//warOKcL3jI?=
 =?us-ascii?Q?1gYBKmtsqm9um+tKkdXAXLhHBgVdl1GNOvZ2vigxywDiY7dlez40L30LjtRn?=
 =?us-ascii?Q?/NMk0JLU4mMya7M9Edwf/PfXBY7L953G9B7PsGFB97VVPxYKl8qEWrqSbPf+?=
 =?us-ascii?Q?dyRsG7CfqVXOntKjxFT+i14bprIDG1Vt+eMmbM0aYLe9RfBC8OzonOgOOsWw?=
 =?us-ascii?Q?uiObD/WwXo6JG8wgmkw9nQpcAzN4x+hfwQlgH+ewwvpqBQK3ifCXVVKwl/kx?=
 =?us-ascii?Q?zvrgJHfGtNHpUpcI9RFvIuknIpMPGYCAE3hVCCYsCZehEkMdrjuhCVtM7Ogb?=
 =?us-ascii?Q?FOEdnCJdcm710ZRO4fmFje/bcVgZrxOuihKlNrlLmEVc4SQnN7Sna1ZhN6Ff?=
 =?us-ascii?Q?urybM/Of0zqxRN5h/PAATLY3CSsEDypy9ZO8sjSl09BuguC5qeUdqCJ3FC00?=
 =?us-ascii?Q?O8Lvdt4CMxAUxcB+QcNnwciUQPv117rPuzt+dBkYbvG4op/vOefuH078yiSB?=
 =?us-ascii?Q?ijR7SeKJ7fHWBQV3ordSHyBaOXZkPJ1zbssHwHsgJ5bqiSh4ke7yWTOJsjRd?=
 =?us-ascii?Q?JqgX5nb+qDUR2BZAFSA6E3ITe59x4k/Gl9R5gV0gcoXSW8OkWgPk63e1/cdP?=
 =?us-ascii?Q?tX/xTC4ZqnrbpUVLQY/0k2hQs0zdwouNumHWYFhlOHoaGh2tnsVN62ZrwaY5?=
 =?us-ascii?Q?ne5U1/fb1+TYv6aPQifKwJsdCZrYF2ygnJqxzxTUhxIakSl7xOgY5Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+DTDBPg0QJ3gAxnjaM6sqSdD7OMigD2Bq5Xe8ZlFaE7qsu0Nv//si3C7rpm7?=
 =?us-ascii?Q?Xb0/8zFu150u17yWBCbFxU48FJyeEUEGKtA/qYIp7kIDL6vmrsv264cs5dx3?=
 =?us-ascii?Q?4uhRatxwvkH11+Zk8us4eskXi2fjxOdbAqsbi6sOnewXkWB1iZDt+VegeKm2?=
 =?us-ascii?Q?L10doHv4eGJw/bEXDJ9lud8ICnv2O6aR1cxTu0A/+jsd5PvuHf1XMaTnHcTv?=
 =?us-ascii?Q?xEleZRXozncq5j5oPvMID3rOG4QSyTGDsF3qbYFq1uPiN8Vkeb05j0NyBxy2?=
 =?us-ascii?Q?CS4MQkxoRc2FlWoEfB2dEIYruqgDpSSihTGd1nnF5YKWzQhUtUdyEFNhtxEi?=
 =?us-ascii?Q?/Lpt1DW0RkjJUzTbtQs2eBZSIiAYX37QzT/zpHij9UZbaJXMcuSrOvGdne+x?=
 =?us-ascii?Q?um3V2oqqzgZZGBrRjW09EH9foQrQeXQY3xMqdmvfI3YZoAsXrd8y1UgI/9ZN?=
 =?us-ascii?Q?XJDwVKBzZMpx0DWGKE2PEGSKQY7OEOXkbt4ZfIfFtAOiSkXxFYCCepyL81XV?=
 =?us-ascii?Q?UreMFDMlpdb0FZKV0coOpds8gJTTbkj0jDLdWwwTfU6agzIpI82k9mroOuTG?=
 =?us-ascii?Q?LLy6EsqBDltUCXCZ1WiP7FxwJ3slpNz04vbD3v1pKfBSWjA87XZSoaKOyP6+?=
 =?us-ascii?Q?TGSBPJDOMCTzKjx15lVlL1R6SSiwbCa/wPJ9JMCwUEKAjRoUSsMLqRG6d8HD?=
 =?us-ascii?Q?8kzheC64Cje4lYibQhtTnbc2ptmKDkQVypyO/tSPQC/kodNi9nxQNXqlAJ+C?=
 =?us-ascii?Q?3vQOPbY40mijwdGYAz6W9ySeacFCI2OWjGC84tO2QNt5Qglok6bmEd+nd5iy?=
 =?us-ascii?Q?sYJ18SPPxDezVNOlFf1mJ9I2I2nD5A32c7opQXxrwNbtLQ05cGD1JB9dD4HC?=
 =?us-ascii?Q?piZxOa5zC/B7RovRKxEi0yyGeOFMtpZmwFm4OU9Z9699eNxY8sM3En+YxePq?=
 =?us-ascii?Q?eBfJIRIY77YaM0bVA1PGQ+KCUQGIVBXktfsdgjYicx2ZUsHVJ8p67KerJisq?=
 =?us-ascii?Q?eMLGl1bg26Ds9VcxL5Gq5p6YgtDjTlvK0jdsB8uR+gw+U5OmzNO+qOqCEAbu?=
 =?us-ascii?Q?C4RsV5Ed/OVQy7y+Ot/ZvFyo68hlnIZwaiiTi1O9HtfIIWkFRzRnzfi0xhfv?=
 =?us-ascii?Q?YwI0OR/vbAq43+Plz/YrtUGVTvuLT1RQfRQISkF3/X9HTMT7Hzo3PSOb51mY?=
 =?us-ascii?Q?GYQ6HtiOaoXoKJbIyPIKQztSjei/55cBOs4+Ixk79AReW6gFElJJ7aYCKY+c?=
 =?us-ascii?Q?SDRaQu9r79GUUWE4TdD2tr74F39UfzqTeieou3DqeSs1AZLnC/0tmRne9dj2?=
 =?us-ascii?Q?J3CZPIoa5gqLMrVSfB+jp4hnZmplGM0LH7XE4yXUL0WKXo/DQbt5vgSN/1Wn?=
 =?us-ascii?Q?ya1H4CLDgndHb4YoLmqgTDD6xxrzb/329QSxnu7ddyPY0CcxfZRMUUoxBTwb?=
 =?us-ascii?Q?ho/ae5e2bhdf0RtYKYA9XSJ1KO2Jw4+sZJsa2sCFW0drETQrOFmsoP7t1Ehd?=
 =?us-ascii?Q?YZKZEm5pAVeG24aa+pgdtgFTirpHLJZ+fDqM7e0Uycuz1EBeXyKjdhZg8YV5?=
 =?us-ascii?Q?zj2v3smQ63nCuijN7tIDKBcjtXKFlR2SBLoJJRhu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 621fdb85-64d3-4863-9ef1-08de2b3c9783
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 09:33:57.5741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nOsTQbx3ZFsJTdxlSkwEvqNSD0ErOkbX/MfNWKiZlcL9HTTjBhJiK7wU5zfUCp3iFOX5BdEeeWXzuQ3y9ZGLZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7346
X-OriginatorOrg: intel.com

On Fri, Nov 21, 2025 at 07:01:44AM -0600, Michael Roth wrote:
> On Thu, Nov 20, 2025 at 05:11:48PM +0800, Yan Zhao wrote:
> > On Thu, Nov 13, 2025 at 05:07:59PM -0600, Michael Roth wrote:
> > > Currently the post-populate callbacks handle copying source pages into
> > > private GPA ranges backed by guest_memfd, where kvm_gmem_populate()
> > > acquires the filemap invalidate lock, then calls a post-populate
> > > callback which may issue a get_user_pages() on the source pages prior to
> > > copying them into the private GPA (e.g. TDX).
> > > 
> > > This will not be compatible with in-place conversion, where the
> > > userspace page fault path will attempt to acquire filemap invalidate
> > > lock while holding the mm->mmap_lock, leading to a potential ABBA
> > > deadlock[1].
> > > 
> > > Address this by hoisting the GUP above the filemap invalidate lock so
> > > that these page faults path can be taken early, prior to acquiring the
> > > filemap invalidate lock.
> > > 
> > > It's not currently clear whether this issue is reachable with the
> > > current implementation of guest_memfd, which doesn't support in-place
> > > conversion, however it does provide a consistent mechanism to provide
> > > stable source/target PFNs to callbacks rather than punting to
> > > vendor-specific code, which allows for more commonality across
> > > architectures, which may be worthwhile even without in-place conversion.
> > > 
> > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > ---
> > >  arch/x86/kvm/svm/sev.c   | 40 ++++++++++++++++++++++++++------------
> > >  arch/x86/kvm/vmx/tdx.c   | 21 +++++---------------
> > >  include/linux/kvm_host.h |  3 ++-
> > >  virt/kvm/guest_memfd.c   | 42 ++++++++++++++++++++++++++++++++++------
> > >  4 files changed, 71 insertions(+), 35 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index 0835c664fbfd..d0ac710697a2 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -2260,7 +2260,8 @@ struct sev_gmem_populate_args {
> > >  };
> > >  
> > >  static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
> > > -				  void __user *src, int order, void *opaque)
> > > +				  struct page **src_pages, loff_t src_offset,
> > > +				  int order, void *opaque)
> > >  {
> > >  	struct sev_gmem_populate_args *sev_populate_args = opaque;
> > >  	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> > > @@ -2268,7 +2269,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > >  	int npages = (1 << order);
> > >  	gfn_t gfn;
> > >  
> > > -	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
> > > +	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_pages))
> > >  		return -EINVAL;
> > >  
> > >  	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
> > > @@ -2284,14 +2285,21 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > >  			goto err;
> > >  		}
> > >  
> > > -		if (src) {
> > > -			void *vaddr = kmap_local_pfn(pfn + i);
> > > +		if (src_pages) {
> > > +			void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> > > +			void *dst_vaddr = kmap_local_pfn(pfn + i);
> > >  
> > > -			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
> > > -				ret = -EFAULT;
> > > -				goto err;
> > > +			memcpy(dst_vaddr, src_vaddr + src_offset, PAGE_SIZE - src_offset);
> > > +			kunmap_local(src_vaddr);
> > > +
> > > +			if (src_offset) {
> > > +				src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> > > +
> > > +				memcpy(dst_vaddr + PAGE_SIZE - src_offset, src_vaddr, src_offset);
> > > +				kunmap_local(src_vaddr);
> > IIUC, src_offset is the src's offset from the first page. e.g.,
> > src could be 0x7fea82684100, with src_offset=0x100, while npages could be 512.
> > 
> > Then it looks like the two memcpy() calls here only work when npages == 1 ?
> 
> src_offset ends up being the offset into the pair of src pages that we
> are using to fully populate a single dest page with each iteration. So
> if we start at src_offset, read a page worth of data, then we are now at
> src_offset in the next src page and the loop continues that way even if
> npages > 1.
> 
> If src_offset is 0 we never have to bother with straddling 2 src pages so
> the 2nd memcpy is skipped on every iteration.
> 
> That's the intent at least. Is there a flaw in the code/reasoning that I
> missed?
Oh, I got you. SNP expects a single src_offset applies for each src page.

So if npages = 2, there're 4 memcpy() calls.

src:  |---------|---------|---------|  (VA contiguous)
          ^         ^         ^
          |         |         |
dst:      |---------|---------|   (PA contiguous)


I previously incorrectly thought kvm_gmem_populate() should pass in src_offset
as 0 for the 2nd src page.

Would you consider checking if params.uaddr is PAGE_ALIGNED() in
snp_launch_update() to simplify the design?

> > 
> > >  			}
> > > -			kunmap_local(vaddr);
> > > +
> > > +			kunmap_local(dst_vaddr);
> > >  		}
> > >  
> > >  		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
> > > @@ -2331,12 +2339,20 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > >  	if (!snp_page_reclaim(kvm, pfn + i) &&
> > >  	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
> > >  	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
> > > -		void *vaddr = kmap_local_pfn(pfn + i);
> > > +		void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> > > +		void *dst_vaddr = kmap_local_pfn(pfn + i);
> > >  
> > > -		if (copy_to_user(src + i * PAGE_SIZE, vaddr, PAGE_SIZE))
> > > -			pr_debug("Failed to write CPUID page back to userspace\n");
> > > +		memcpy(src_vaddr + src_offset, dst_vaddr, PAGE_SIZE - src_offset);
> > > +		kunmap_local(src_vaddr);
> > > +
> > > +		if (src_offset) {
> > > +			src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> > > +
> > > +			memcpy(src_vaddr, dst_vaddr + PAGE_SIZE - src_offset, src_offset);
> > > +			kunmap_local(src_vaddr);
> > > +		}
> > >  
> > > -		kunmap_local(vaddr);
> > > +		kunmap_local(dst_vaddr);
> > >  	}
> > >  
> > >  	/* pfn + i is hypervisor-owned now, so skip below cleanup for it. */
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index 57ed101a1181..dd5439ec1473 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -3115,37 +3115,26 @@ struct tdx_gmem_post_populate_arg {
> > >  };
> > >  
> > >  static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > -				  void __user *src, int order, void *_arg)
> > > +				  struct page **src_pages, loff_t src_offset,
> > > +				  int order, void *_arg)
> > >  {
> > >  	struct tdx_gmem_post_populate_arg *arg = _arg;
> > >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > >  	u64 err, entry, level_state;
> > >  	gpa_t gpa = gfn_to_gpa(gfn);
> > > -	struct page *src_page;
> > >  	int ret, i;
> > >  
> > >  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
> > >  		return -EIO;
> > >  
> > > -	if (KVM_BUG_ON(!PAGE_ALIGNED(src), kvm))
> > > +	/* Source should be page-aligned, in which case src_offset will be 0. */
> > > +	if (KVM_BUG_ON(src_offset))
> > 	if (KVM_BUG_ON(src_offset, kvm))
> > 
> > >  		return -EINVAL;
> > >  
> > > -	/*
> > > -	 * Get the source page if it has been faulted in. Return failure if the
> > > -	 * source page has been swapped out or unmapped in primary memory.
> > > -	 */
> > > -	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
> > > -	if (ret < 0)
> > > -		return ret;
> > > -	if (ret != 1)
> > > -		return -ENOMEM;
> > > -
> > > -	kvm_tdx->page_add_src = src_page;
> > > +	kvm_tdx->page_add_src = src_pages[i];
> > src_pages[0] ? i is not initialized. 
> 
> Sorry, I switched on TDX options for compile testing but I must have done a
> sloppy job confirming it actually built. I'll re-test push these and squash
> in the fixes in the github tree.
> 
> > 
> > Should there also be a KVM_BUG_ON(order > 0, kvm) ?
> 
> Seems reasonable, but I'm not sure this is the right patch. Maybe I
> could squash it into the preceeding documentation patch so as to not
> give the impression this patch changes those expectations in any way.
I don't think it should be documented as a user requirement.

However, we need to comment out that this assertion is due to that
tdx_vcpu_init_mem_region() passes npages as 1 to kvm_gmem_populate().

> > 
> > >  	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
> > >  	kvm_tdx->page_add_src = NULL;
> > >  
> > > -	put_page(src_page);
> > > -
> > >  	if (ret || !(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
> > >  		return ret;
> > >  
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index d93f75b05ae2..7e9d2403c61f 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -2581,7 +2581,8 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
> > >   * Returns the number of pages that were populated.
> > >   */
> > >  typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > -				    void __user *src, int order, void *opaque);
> > > +				    struct page **src_pages, loff_t src_offset,
> > > +				    int order, void *opaque);
> > >  
> > >  long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
> > >  		       kvm_gmem_populate_cb post_populate, void *opaque);
> > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > > index 9160379df378..e9ac3fd4fd8f 100644
> > > --- a/virt/kvm/guest_memfd.c
> > > +++ b/virt/kvm/guest_memfd.c
> > > @@ -814,14 +814,17 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
> > >  
> > >  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> > > +
> > > +#define GMEM_GUP_NPAGES (1UL << PMD_ORDER)
> > Limiting GMEM_GUP_NPAGES to PMD_ORDER may only work when the max_order of a huge
> > folio is 2MB. What if the max_order returned from  __kvm_gmem_get_pfn() is 1GB
> > when src_pages[] can only hold up to 512 pages?
> 
> This was necessarily chosen in prep for hugepages, but more about my
> unease at letting userspace GUP arbitrarilly large ranges. PMD_ORDER
> happens to align with 2MB hugepages while seeming like a reasonable
> batching value so that's why I chose it.
>
> Even with 1GB support, I wasn't really planning to increase it. SNP
> doesn't really make use of RMP sizes >2MB, and it sounds like TDX
> handles promotion in a completely different path. So atm I'm leaning
> toward just letting GMEM_GUP_NPAGES be the cap for the max page size we
> support for kvm_gmem_populate() path and not bothering to change it
> until a solid use-case arises.
The problem is that with hugetlb-based guest_memfd, the folio itself could be
of 1GB, though SNP and TDX can force mapping at only 4KB.

Then since max_order = folio_order(folio) (at least in the tree for [1]), 
WARN_ON() in kvm_gmem_populate() could still be hit:

folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
        (npages - i) < (1 << max_order));

TDX is even easier to hit this warning because it always passes npages as 1.

[1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com

 
> > Increasing GMEM_GUP_NPAGES to (1UL << PUD_ORDER) is probabaly not a good idea.
> > 
> > Given both TDX/SNP map at 4KB granularity, why not just invoke post_populate()
> > per 4KB while removing the max_order from post_populate() parameters, as done
> > in Sean's sketch patch [1]?
> 
> That's an option too, but SNP can make use of 2MB pages in the
> post-populate callback so I don't want to shut the door on that option
> just yet if it's not too much of a pain to work in. Given the guest BIOS
> lives primarily in 1 or 2 of these 2MB regions the benefits might be
> worthwhile, and SNP doesn't have a post-post-populate promotion path
> like TDX (at least, not one that would help much for guest boot times)
I see.

So, what about below change?

--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -878,11 +878,10 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
                }

                folio_unlock(folio);
-               WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
-                       (npages - i) < (1 << max_order));

                ret = -EINVAL;
-               while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
+               while (!IS_ALIGNED(gfn, 1 << max_order) || (npages - i) < (1 << max_order) ||
+                      !kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
                                                        KVM_MEMORY_ATTRIBUTE_PRIVATE,
                                                        KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
                        if (!max_order)



> 
> > 
> > Then the WARN_ON() in kvm_gmem_populate() can be removed, which would be easily
> > triggered by TDX when max_order > 0 && npages == 1:
> > 
> >       WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> >               (npages - i) < (1 << max_order));
> > 
> > 
> > [1] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/
> > 
> > >  long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
> > >  		       kvm_gmem_populate_cb post_populate, void *opaque)
> > >  {
> > >  	struct kvm_memory_slot *slot;
> > > -	void __user *p;
> > > -
> > > +	struct page **src_pages;
> > >  	int ret = 0, max_order;
> > > -	long i;
> > > +	loff_t src_offset = 0;
> > > +	long i, src_npages;
> > >  
> > >  	lockdep_assert_held(&kvm->slots_lock);
> > >  
> > > @@ -836,9 +839,28 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > >  	if (!file)
> > >  		return -EFAULT;
> > >  
> > > +	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> > > +	npages = min_t(ulong, npages, GMEM_GUP_NPAGES);
> > > +
> > > +	if (src) {
> > > +		src_npages = IS_ALIGNED((unsigned long)src, PAGE_SIZE) ? npages : npages + 1;
> > > +
> > > +		src_pages = kmalloc_array(src_npages, sizeof(struct page *), GFP_KERNEL);
> > > +		if (!src_pages)
> > > +			return -ENOMEM;
> > > +
> > > +		ret = get_user_pages_fast((unsigned long)src, src_npages, 0, src_pages);
> > > +		if (ret < 0)
> > > +			return ret;
> > > +
> > > +		if (ret != src_npages)
> > > +			return -ENOMEM;
> > > +
> > > +		src_offset = (loff_t)(src - PTR_ALIGN_DOWN(src, PAGE_SIZE));
> > > +	}
> > > +
> > >  	filemap_invalidate_lock(file->f_mapping);
> > >  
> > > -	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> > >  	for (i = 0; i < npages; i += (1 << max_order)) {
> > >  		struct folio *folio;
> > >  		gfn_t gfn = start_gfn + i;
> > > @@ -869,8 +891,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > >  			max_order--;
> > >  		}
> > >  
> > > -		p = src ? src + i * PAGE_SIZE : NULL;
> > > -		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> > > +		ret = post_populate(kvm, gfn, pfn, src ? &src_pages[i] : NULL,
> > > +				    src_offset, max_order, opaque);
> > Why src_offset is not 0 starting from the 2nd page?
> > 
> > >  		if (!ret)
> > >  			folio_mark_uptodate(folio);
> > >  
> > > @@ -882,6 +904,14 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > >  
> > >  	filemap_invalidate_unlock(file->f_mapping);
> > >  
> > > +	if (src) {
> > > +		long j;
> > > +
> > > +		for (j = 0; j < src_npages; j++)
> > > +			put_page(src_pages[j]);
> > > +		kfree(src_pages);
> > > +	}
> > > +
> > >  	return ret && !i ? ret : i;
> > >  }
> > >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
> > > -- 
> > > 2.25.1
> > > 

