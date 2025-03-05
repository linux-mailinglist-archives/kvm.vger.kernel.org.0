Return-Path: <kvm+bounces-40145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C3F2A4F954
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 09:58:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D3633A18CB
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 08:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5960E1FECD9;
	Wed,  5 Mar 2025 08:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GM9SoYdh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E940B1FDA89;
	Wed,  5 Mar 2025 08:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741165102; cv=fail; b=KBR085u4H9LB8nstYvU5l6hSdhcR6QfXsA4ODrAylsvFMJn6dNmWbp4Ovd2jG2C9Ad2N3h6FtKwRC69Fr3kYZcHVkXEU6Kdd+aW8DvcFf5yMG/S3Ydsu8+M+LAJQve5ORVDQQF1tWoNfLqUxeVI4XVYRuqCcwKbP3i73HIDSLeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741165102; c=relaxed/simple;
	bh=CPLFxevjXmEumvUB00yXSSItUtKX6FXlDc6NT2f9/7c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hiNSiT1BXQbXHnpKXzfS5HWyPx4+Q8cs8nR6+QhzmEek/ZGseRTW6LSH89HUgduziWsY3Q92XeaLBRQgSdyPww1PEYhmBhhyxoZ/J0AJCaqW/X8VgquNxE/NqzUa3xird+si84zIdqyEzZG/Kflvsh9mKX6Pxzrx8pS2vXO3afc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GM9SoYdh; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741165101; x=1772701101;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CPLFxevjXmEumvUB00yXSSItUtKX6FXlDc6NT2f9/7c=;
  b=GM9SoYdhwsAjFi57/HLifj2zEANyMaIfiUpWHmJzVXaB21JKHylGHa4a
   +zeY2IkIjOp3ZxZgoPVD8kYJdXjbdwhUuKcrfTmodXTriRkGRcZBxPLwS
   oau6c8TEffej6AGqKm501SLO6O4FzTFhIg+CJv9of8wfalfurpj33aPHN
   ddBhqOcXJuBvyMtjWcNzT20AAFwBoSxOgKHBtUAM43xtm9NAqerdvGcQU
   dUpYcnRL3vUCi8IE0I4hm6nr+3MCF3SbSdmtirjMstV1cZr9/dSk6ldO0
   3ccGnaWI/wYtonlyRJIh3o9wE53ZEV4o+YONsw5nJaPsT7iUmx8uXwW0M
   Q==;
X-CSE-ConnectionGUID: YyRfV1TWScejIPuDETTTSg==
X-CSE-MsgGUID: aeZFFB2zTWexrEkfxD7SvA==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="41976672"
X-IronPort-AV: E=Sophos;i="6.14,222,1736841600"; 
   d="scan'208";a="41976672"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 00:58:20 -0800
X-CSE-ConnectionGUID: NzNDjgQeS3m69OIT0ajvGw==
X-CSE-MsgGUID: UjAx5Cv9QY2aVdSPEd79KA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,222,1736841600"; 
   d="scan'208";a="141878923"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 00:58:18 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 5 Mar 2025 00:58:17 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 5 Mar 2025 00:58:17 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 5 Mar 2025 00:58:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ll9SFkLp4VhmKJw++L6tKbI9sTJ3oqbfRs8WRPsLXppQu5dFerK9P+L0YVz7z2l8Z4XybFOn5H2J/t6vVUyMpJd4gS+l7a7OY85nSqH4nKGU2QvzHLFZnJ1j394Eml365q0d5TCCYFlXi57Dx8xJ61BG295vCx9ucF2JtSeg0bQEjUtIna10ue1tRYpeeQo7Wi05dO463EwB2w7bB+w0iLM/WTAMTGQpCjO4PQt4zWQlv/m6ENBkd/O0SYQrlowix/uN33fMxyXUR/PSrgtjOT5jsHEPenvSrlW2My2iYIoyduyquG0KnPc53ovenruC++sVWGFF2blHD4qiPxMZOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQ6SmJg9pbC98HbkeB6fHli4xA/UA4TxAnwRsY6yIWU=;
 b=HYZlwQr1vc6+i6P121odfJKz2YtQlLrRjizKZDdYlhTfcPMR+OrjLkq1dkriHff5Nkir1vbuJL5wliCgXDxfSDmgMA1/qY9v35COs47Q6BHCyFPs53YgSuO6y8pqr1TqG+ZeLN0LFKPlO21onBg0BNviUktjwIBgKK6OFBYmBGMpZ5d0LkJhsgtf2lmef8LaXvUSO3+9sPSNXY306Fi1vyyw6uXZqOoNcz35tu74jrSLjY3+E8fHjOPFOLQuaeZX5FBKiq9oz+Rppb1DtdbWdowNGrkyJ+mZzwyprs5fEBS/KPKotVfxCHPsGjGPibn7H5DbLUwe57dshlh1z6d0VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA2PR11MB4828.namprd11.prod.outlook.com (2603:10b6:806:110::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.18; Wed, 5 Mar
 2025 08:58:01 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 08:58:00 +0000
Date: Wed, 5 Mar 2025 16:57:50 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <tglx@linutronix.de>, <x86@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>
Subject: Re: [PATCH v2 4/6] x86/fpu/xstate: Introduce fpu_guest_cfg for guest
 FPU configuration
Message-ID: <Z8gSDhr1ZfIEVVgU@intel.com>
References: <20241126101710.62492-1-chao.gao@intel.com>
 <20241126101710.62492-5-chao.gao@intel.com>
 <ea73a36a-8ac5-462b-a97e-c398f6307f2f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ea73a36a-8ac5-462b-a97e-c398f6307f2f@intel.com>
X-ClientProxiedBy: SI1PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA2PR11MB4828:EE_
X-MS-Office365-Filtering-Correlation-Id: 10ed42e2-da57-4d4c-2be2-08dd5bc3d4c4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uwzcxUc7m72/Uj1JzO/NuBie2DcDnO+KTpXh+FPoyCyEhuIdMtiPG+T8b9Uk?=
 =?us-ascii?Q?uD8H9MV+tvSMrOunQ8lEuiPZ7qvWGDaZ50m+4goX0We9zy8y59LN95Ayo4zx?=
 =?us-ascii?Q?fuCg2tTYtNRXe4gZ5w0+0GYEO3q66gs9hAPIvb18fbM3n9vQc5j5ha6ykegQ?=
 =?us-ascii?Q?i7FXzvGv3wX5I4ewapEkzkGwMqhvSo40y1l93GdTTX9Zfch+roblyC0sHZs4?=
 =?us-ascii?Q?DJD7HnuibHs2Rt0PH9TjHVT1MnBTnRExgpe/j55mf2dkHUo9DzH1voEouvBQ?=
 =?us-ascii?Q?VDiwAclq7Fqe3S7x0omXCQU2tCLfrNBAQBa2Wn4CgEGc1K44H4gAs8YDY7VB?=
 =?us-ascii?Q?Rg9md+kmqSlpQhrt8DaRwoPP0hqT0H8YHyiDkRZ3xW6TkaJHeyptxatAxpZx?=
 =?us-ascii?Q?d3Wis/c+GfUCIfW5YoDdk0q+bV1RlL9VeihOXtoF669D1mCKdKfoRkQwHBHa?=
 =?us-ascii?Q?gfFZUyoai05s4uEuv14JlQsh+aGoq/v+oQq8ikTx+SHlQA2rZsnSVT7XdLjb?=
 =?us-ascii?Q?TV7FbhlN/Kq9aw/k2OUxUB667S2P60fx+SD1DOamR9dVk0mKZf0DIKRVJvOM?=
 =?us-ascii?Q?7a53/ct3AKLCRi8ytJehL6TAsPzjif8KnsO69BNgkJLGwJzav3NoyVwp0OzB?=
 =?us-ascii?Q?hP13BG+fkuX/r8FjLVwGcvFo6Z6dBGlSB1zmOJgnxLXHZ19+odU98mW2DTO5?=
 =?us-ascii?Q?opFSXCp7Hp7CE5kAzTsAMz0FMvweFfN5sm9lYGrLE3moznU4k6p7KIFHMqY6?=
 =?us-ascii?Q?9X95N+DAv7GV+hd8eXyB4QygTnCECoNX9JhWNCjcKsqyUKnWHO7CmTmrvRii?=
 =?us-ascii?Q?NcfJXSDgc2eJkpjA9nUKFn7bKJL9hmZv+guyTQHn2zivYAwSGadlWrdnTXuM?=
 =?us-ascii?Q?WBtGd8dzrOsaNbf30t/nYezYl4gpGm8Ck7hJpomLOK5o0QL0XRn2lD2tSxf1?=
 =?us-ascii?Q?pt6GgSQaTcD1wy3vDq+ODxAZg4KVQr3lWq+KVrDTZAFDhGXMd/lqsM33r7/i?=
 =?us-ascii?Q?g0v6VRiVIEM9GUNphKGEG5euvX1vXhwno8nVMj1vxJsZT3SBRtrddu5PfLCK?=
 =?us-ascii?Q?4c5lP85kYnOtZ7KrTt1ykiAd0nYUKe1qyu1N8fv1Dwqr+AdH3gcecl4rHySj?=
 =?us-ascii?Q?hsXQtIF6O7N61XjUMQ6m/B0AXbzLOF8ZpdIlddRLPfphG1k6xBOt8BH2PDpj?=
 =?us-ascii?Q?aoR/z42AL+OyDpVQlY9hY5gqyUJSeHEX4yGklHTVrUUanzuhW5anaNU79dh4?=
 =?us-ascii?Q?vBAplV2Q077JvfyTkHNPITF89u0lP+gzBoWRtJxkOAQAqquH5+3zhZ8/9sew?=
 =?us-ascii?Q?3HdQxnPb4CnGfGV2Czruzv4Yf+3T0/xcYzw6DZPT4r5Isujs0631DPP8wCf+?=
 =?us-ascii?Q?qUkwYRJlVHEUzFqiRWDWneM9WbQs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aNVApxfcen26pG2+GS9Z3wSEoD7A2G8NJToGQJ/F6kvrtQVuEunJomEWphZP?=
 =?us-ascii?Q?+FmLul4agrqS1nqeUM7fvBTVxvCLJXxxC9UWkNuGy38PWLnhFDcWLmJaDHdT?=
 =?us-ascii?Q?87WcytiCcJ/82VB0iJuRl1p1uWG8CA7ka9SOU30UY8sJ9BA9AXyyiKi449vD?=
 =?us-ascii?Q?6Afrjb6qgS8fa0Wwalpg0sulAy6x97pdwxQ5WZsvfHF7Gt29uLzG6tkaxzpk?=
 =?us-ascii?Q?n/5msOVyoGO92yxl2YWb14wAJXSrwpZP7tY5XqRqp55iVba1PSF5wavGOXrz?=
 =?us-ascii?Q?PS2MfWtPgDPj8NurF+ktyJkt+uEaakR+d1EdGQ7pcwLcu2nugsZdwF1xFQEB?=
 =?us-ascii?Q?BNQwAAWv+BQjeWcWPQY1EkU2TushA56w2nW3Ut55vsKCQc5xUFxwSbNAwC/e?=
 =?us-ascii?Q?t+IFhpuxVjs8wYUMgmqlyXZ8WOG4tmB1MTQTQMI0iAJbxqMc7+vCCEA4so6Z?=
 =?us-ascii?Q?Kcr68FskEm/sNWS5ApMgrS3JmAhPg/WpccTJ5OO3Fd7i8yhk7t+R/LBTxsu+?=
 =?us-ascii?Q?J6UA8jzFppxDLI3eRdywcNc/b9tcnkF2NFzIWVRD/wHFSlsG5fCyOx5cvGSc?=
 =?us-ascii?Q?yjaNhrhZC8aVsgc6c/Hs7WLy2A11OczTllyXy8MHit+ZjCjkNW2bWvx5scno?=
 =?us-ascii?Q?92FjGAofgVdSX3D6RuY/EFEr7M2Kuc8Whsd9UBth9GASbpXacoRWul8rfNRx?=
 =?us-ascii?Q?1wsbR0X7DhjH1Siliqlr1AFd/pmC5BTuTGGysQRQbBcorPD7+7yxiu4107X/?=
 =?us-ascii?Q?dvxrv2T7z8vTbz1vFTK3ElzG98iKcuyEh4DPfnm3pGI+6vGbCubcrE2XMeim?=
 =?us-ascii?Q?9YE4kgOaQSyVKIiaZCpDULEDU0sHdCMJ89lBBf0ItjW2pxLjWOzvkc0fFT7j?=
 =?us-ascii?Q?YUZToojyrYuGfvChqqwg96wfIUJchk/kFt4pf7H3/yqgsXlfWu8R2DWrAb3Q?=
 =?us-ascii?Q?maW/Om4q0vCOeX4O0jeOGw4eXmkOqTmBwWx1kuskOXhQr2HVJlL3B0qqW32P?=
 =?us-ascii?Q?WsjkXTLah8w7bl3cg2LZeMrwJrNyKyNjJNxtFJu0CXYsbVYkQKCbAnSHYjJW?=
 =?us-ascii?Q?R4hVuKO1c8w/9H3pXHi3OEb+FFNTWMLQzYp4W3fsAgOV93EEw7OBozTqFg1B?=
 =?us-ascii?Q?GTPe/YB1VXsGixvq02o8f7qLCm6/Ihh7gNJZ5ZPxjRxgwwjVV1AwpBVJAUh2?=
 =?us-ascii?Q?CYyGSrglFWSelcsa4Kvgh/BruB2MKOKFXP6xmA/y4TDMSFvumk410geJiTYn?=
 =?us-ascii?Q?r4S72AvMLU4p9X4FqNNK5llidYa2iPDrzeUb5/C53mxD9wwElS+nMhLOMmLV?=
 =?us-ascii?Q?XR/scurhssqH+m/r4roBvhye9jV9Vv0aUHMV6O/vCR2nAXmh1doqPdICe9lD?=
 =?us-ascii?Q?9CEcKv+ulzY4E+9/c1dl0c3mL8HMl3JUVhfA4nUsZOibkzjtrRm3GP/ZmcIA?=
 =?us-ascii?Q?moThbRHdSltpJeilwBHXNGQKmJoTMSlc0zQMCv73f6fHe9Bi2vn6c05kRvt5?=
 =?us-ascii?Q?q04Ap8iL9+5U68diARsnkdNbyVqXMVHyjHwG7FNJMGKWe9AQzffwRVhHONrx?=
 =?us-ascii?Q?NxsVZrXam+K9slzHY2hBqnffUKQZWsZB7LF9L/rn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ed42e2-da57-4d4c-2be2-08dd5bc3d4c4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 08:58:00.4218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LZAwadp37NO+41hmeU6wQdxYl08aKkmeE/1x7ROu+s+erIIB7K6RHlRsyjtQQsPQUXqtnHU2ufZ4XMXMGZQOVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4828
X-OriginatorOrg: intel.com

On Tue, Mar 04, 2025 at 02:50:48PM -0800, Dave Hansen wrote:
>On 11/26/24 02:17, Chao Gao wrote:
>> From: Yang Weijiang <weijiang.yang@intel.com>
>> 
>> Define new fpu_guest_cfg to hold all guest FPU settings so that it can
>> differ from generic kernel FPU settings, e.g., enabling CET supervisor
>> xstate by default for guest fpstate while it's remained disabled in
>> kernel FPU config.
>> 
>> The kernel dynamic xfeatures are specifically used by guest fpstate now,
>> add the mask for guest fpstate so that guest_perm.__state_perm ==
>> (fpu_kernel_cfg.default_xfeature | XFEATURE_MASK_KERNEL_DYNAMIC). And
>> if guest fpstate is re-allocated to hold user dynamic xfeatures, the
>> resulting permissions are consumed before calculate new guest fpstate.
>
>This kinda restates what the code does, but I don't think it matches the
>code.

Actually, it does (see more below)

>
>> With new guest FPU config added, there're 3 categories of FPU configs in
>> kernel, the usages and key fields are recapped as below.
>
>This changelog is pretty rough. It's got a lot of words but not much
>substance.

Will revise the changelog.

[...]

>
>
>> 
>>   @fpu_guest_cfg.default_size
>>   - size of compacted buffer with 'fpu_guest_cfg.default_features'
>
>This looks like kerneldoc, not changelog. Are you sure you want it _here_?

No, I agree this should be a comment above fpu_guest/kernel/user_cfg.

>
>
>> @@ -829,6 +835,10 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>>  	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
>>  	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>>  
>> +	fpu_guest_cfg.max_features = fpu_kernel_cfg.max_features;
>> +	fpu_guest_cfg.default_features = fpu_guest_cfg.max_features;
>> +	fpu_guest_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>
>I thought this was saying above that it was _setting_ dynamic features.
>
>Why _not_ set them by default?

At first glance, I had the same question.

XFEATURE_MASK_*KERNEL*_DYNAMIC is not excluded here, so it is enabled by
default. I believe the confusion arises partly from the order of the
patches. I will reorder the patches as you suggested in patch 5.

