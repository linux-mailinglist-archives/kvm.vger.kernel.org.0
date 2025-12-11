Return-Path: <kvm+bounces-65689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 97F5FCB4830
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 03:13:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0E571300161C
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 02:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39DF52BE04C;
	Thu, 11 Dec 2025 02:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RwQmibwA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB83178F20;
	Thu, 11 Dec 2025 02:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765419188; cv=fail; b=K43FHFjw+WBlMv/WlBHU8d13TdUPIVpKoZ8rI2FYln7A7xPOhx52rYC9wTEvvK0gpPDP8lCXsj64hU0W/r0seCydZoZZaNamFr1uwqcEyAUSgSa0DNmi3lKn/mgqa6mRTRONIu4yK21t/JP4Ax2NDM7L2Qtr016o/U2UOY/XSnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765419188; c=relaxed/simple;
	bh=nD+hmblsAIWlLcMyuRU9SaWsKkpJaC5MKjYdZJnjH/s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IyDoEKR5540kMlqUwBwM36Uawa/ICvxT6cUh5YPxC+Wld64TV6hN/+07WTEqI/+GUh54oFmQxZwWU/PwvvC+du9ZRvdrSWqtuBXpVfMNKvaUvrZMp+eC5B4gOqZXpAHGL16KYKk/bIQXguaHZaOXQkcYyu/HWoOaysezv3tu1As=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RwQmibwA; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765419187; x=1796955187;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=nD+hmblsAIWlLcMyuRU9SaWsKkpJaC5MKjYdZJnjH/s=;
  b=RwQmibwAFuhabjnZpxz19XdYWOWMKTbR7SQo7UPRYS/ENJqMXP77jiyc
   L0UDJwyhBeJ0cHQdo6xs0CSH4oeJMRU5LN1lwy2eAWXsTRhGMn2KAjXw1
   5khEeIMsSEbAVZXL+shnng0hYeOVtPFyWjLwD3mYaruUMz+Wh+4zegJSg
   UMjpW3FX+ZJ1LJTslgejPRhoKTswcON2hMLmpxN/tRD3YkyYq8X5PK2mH
   L8ksY75OKCcDk58KT+mTQXtkUzFNPCJWnk0kayMhHU7WjY6tMsr5PvKOr
   zNoQF/9J06IErF83Qqk07NArh9Icplz5BUonDAc3C2tqIzwb5Fyg5X5sJ
   w==;
X-CSE-ConnectionGUID: hWMNzF62S7eHXt3IySUp+g==
X-CSE-MsgGUID: FVXNw7S1TVW6PAxaGoHOgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67357096"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="67357096"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 18:13:06 -0800
X-CSE-ConnectionGUID: 4lURQUG3TjGm/2ENImuD1A==
X-CSE-MsgGUID: PgMOCEfjTFWK7un5dfVyDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="196440625"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 18:13:07 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 10 Dec 2025 18:13:05 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 10 Dec 2025 18:13:05 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.30) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 10 Dec 2025 18:13:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M2odjT7shJopihkI+J57QiEk2x9BhPN1C9WibCRO+jS3dY02oLFlzoX0gVeJ4xw3zR2GjDQ3DAOFG0n1dj3Wm0Q6ir8m/MmmB1hvRyIKK5ULEvD4tob180en3dyzU7xz0bjfIbAa+jRM9oWu/BJspM+3TxTvOo5NyBr8swa8O/R0odv8+xXkDn9DngxBTO17cjmW6tXqEljOXAH9FBIpNvCS9bBV7354fIAxkDL7t/sG65k4S1aAtlkTZvRCDLehGJxsX7bCUQ22bdilqeH6WexGIy89M2Wwzv3XuUMT44kziYgdJYjSwPGwKyYGvpP21nIrAd1bw1SLvTzmPmVrDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vz78pcq4TrpUc8b8rc+7kiqX71Wkf2RDXcEQiNqIgPE=;
 b=cEHc6vKozm6a+a6oAiosVUVGO51Wyxe5wGbJ2rnoEVQCYtobr2UfFJWHLkFtKeK0HDJ79d5LdcYzyz7jVM2LU4ZWKCTVft7SA9fJ2kX4siGOoWGlHFhDnptn0PZLPMsji79urS2n5NmcPbfoCftVzHhGwLewhlpO8/Cvk2qbmOa7URMgc/RAf9fz/KncxmpYN2prXzr7aFMz/vRFCSURrfwf7Bmb8OxCF9wI1HLRAeTinlDDyISRfdxq8Kh0qrOmM0k1Q+KDwEnXZhnrEIgoNuLODREYBcFJwlJ7FWW0xEYRaCLwFLiDW5TjvSQrG1qd0a+EL8fjqN142HO1HwHgsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB7564.namprd11.prod.outlook.com (2603:10b6:510:288::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 02:13:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 02:13:02 +0000
Date: Thu, 11 Dec 2025 10:10:33 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "sagis@google.com" <sagis@google.com>, "Du, Fan" <fan.du@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Miao, Jun"
	<jun.miao@intel.com>, "zhiquan1.li@intel.com" <zhiquan1.li@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 10/23] KVM: TDX: Enable huge page splitting under
 write kvm->mmu_lock
Message-ID: <aTooGaNq353hlGkE@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094333.4579-1-yan.y.zhao@intel.com>
 <CAAhR5DGNXi2GeBBZUoZOac6a7_bAquUOzBJuccbeJZ1r97f0Ag@mail.gmail.com>
 <5b9c454946a5fb6782c1245001439620f04932b3.camel@intel.com>
 <CAAhR5DHuhL_oXteqvcFPU_eh6YG38=Gwivh6emJ9vOj5XO_EgQ@mail.gmail.com>
 <aTjD5FPl1+ktsRkJ@yzhao56-desk.sh.intel.com>
 <CAAhR5DGPF3AV22kQ4ZVNWh3Og=oiJiaDRgBL5feB6C-AHb=apA@mail.gmail.com>
 <2b714bb6e547e2505a83c97fdad79e5dda687d05.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2b714bb6e547e2505a83c97fdad79e5dda687d05.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0121.apcprd02.prod.outlook.com
 (2603:1096:4:188::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB7564:EE_
X-MS-Office365-Filtering-Correlation-Id: cf007144-ebea-4cff-ebf5-08de385acfd3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HqW3NXjbbVhWhsB2iB2lcM+Xan4vlla2KaZU7FKlrcqE+KPBT9PAlrCjUMzb?=
 =?us-ascii?Q?pCssMcHELTH2akDPdMIrVQuNt3rWhjvVf9dco3FvCA6meGLv5WShcsZEPvAu?=
 =?us-ascii?Q?q/9bcJEOtvNqGKitPGnuIY2K2xsSORsh6IJsFboxY1cAq2he/1AIHhr8FGBe?=
 =?us-ascii?Q?QE2jXqiFiE5plrmCLp0vmLY38AQC2I5b27DuKmiWhFGgBY8J197yXTR2IQZL?=
 =?us-ascii?Q?WVZGXW6QSqIpSAY0swzyBx9VgIbEbHIUWXKRSgUOPdSVeXJ1U/WB74q09Ld/?=
 =?us-ascii?Q?CC6Q2PX6NhDShZzZAPjlPuRuB6IyBM/cCxWUvgV901nhJyPiCW5jxtV2VB7I?=
 =?us-ascii?Q?RJROUuVQk3e5k5Y3y8DxcokTbeFV9Iz9IqqpRAY9pImoyF1knYJ7W50o04RM?=
 =?us-ascii?Q?U+goL465r6xqgV7R9L327UYaDt1JjR+J7A35958M6g29GxQ4aY11kbVgvOVM?=
 =?us-ascii?Q?+GMeKBiru7bu0hViuFccmDANSj6sx9+ZEsYuBsSxkXHLj/T+NytsE3aoWQyk?=
 =?us-ascii?Q?9T/2eXmHvsUChQv5Lgh/c4H3CRXINyBkWCq1GzmXUVNnmfMmTJBiKQjqaipj?=
 =?us-ascii?Q?frCje/gFkAQB11JcGNwxh7ovOL7/9mdXGargGDFGYIN8hm+6vEJYJq9L67oM?=
 =?us-ascii?Q?lzYMBBi3AerffUnMC1HD9/hRXdx91yNAqpPLCPel+xS/a5H2pYBq7CaVL/q2?=
 =?us-ascii?Q?raPE67QuQFMBt/vsuyzrOh3zToaSkzF4vmgnGHvoW6d/rcODJvu8m2Yfx80x?=
 =?us-ascii?Q?OP+b3cCu4M/njLEef4X0CIoSWBmueBA1qnch6MxaGSzF3UQ69pPNkVCgEJ4W?=
 =?us-ascii?Q?XbK0xrAa//48iWNZAgsgdla2D4LKngosBVJ71wrcyEBKtpo3ymZDoeCNVwop?=
 =?us-ascii?Q?43IBz/7UTElzBokl6AjU9g6uUw9dOzZYvVtijeGQ08goB9khVxX+gpNENui8?=
 =?us-ascii?Q?gMSUKrBX3TwaHW/rzkWs/NeySmuVodtAuPGKeVPdIiwqg11slfg9V6MWDwXt?=
 =?us-ascii?Q?qNRUQfmY4CBuZ0TJHEVU+FJGszXIusVAsIw5gTFYVNQQPgt4mAIZs7DPp1wA?=
 =?us-ascii?Q?pwpDNqcHDnr64acLgpjUu9j8AAaKoA8L2ojD+PdeMvYaDEUoH4V7bs7Oojuo?=
 =?us-ascii?Q?yz5ooHGh2HVj2oDsP9R6EUFX2yzby1WABApKJ/hEWbJ0fWqRuRTT+ln8NpnY?=
 =?us-ascii?Q?bwapo7dtAW50yRFcjZI5J6Mz7WLU/dgdEC7CsBmulKUOpr6gbOvmUzmYR/q+?=
 =?us-ascii?Q?MIhUv/JJtm0UexSlwPRo0LlivUCXM6fdU8ctEKkdQwMfsJmAurw7HloKN/AI?=
 =?us-ascii?Q?tBruXimV26rjc9Tw4vrnY9HhMpFwHV0/Om5Rk4Y6Dq5ZDYC3i4lP1IWHZCDG?=
 =?us-ascii?Q?zKR2GsD2KWCub3GSksKGvqe64NVvbcKffVmJ4KcC3nnntxqzZ8gjL6rViM3y?=
 =?us-ascii?Q?bFoIhfN463S7iffqDY9O208dZA/gC3AR?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/13WdzsRS9orKbiUk9Zlv22Gvb1FMN/DAKLmHz5GYFVe5Pm9pgNy+aIofFHk?=
 =?us-ascii?Q?TsE6jXyuABfQ8ABcL9/k5SxLKYVeUQ4lz2thlBjg/Y+hojetJgR2jcXrv20s?=
 =?us-ascii?Q?aVA4UOkkjD8vE35xgMBICE+wensvI3LIjCV21EuI1sBjbMkzTms94h2A/coK?=
 =?us-ascii?Q?a61qm+WhuSUWuV1uf4ljjiWWMePOheTwQ4J30gJNmSsL27SnV1xAUdvjhX6u?=
 =?us-ascii?Q?YMYzlYbs4WTTzyIGTu+0ybawFcJBbDYqFVI+VZ0/hp5OziiosiaOQR90jckQ?=
 =?us-ascii?Q?tSdJV9+FvpxHlkXhriXgGLtl96VBHgW8Gn6KmZqFupLyn8ndt2+cR8nh2AdE?=
 =?us-ascii?Q?Cw0slpRSaifdkgGp1NgSuL7q2m92t/Jrj+fG/JEc4gzdYszXlnPsDlRRlwgV?=
 =?us-ascii?Q?RHPSiFFJy5fAhOF9UjsWpTHzyxLoELwD+mZd/HXD5qyjTax4vD5p9akk2YXb?=
 =?us-ascii?Q?8nYpKmcLZHj69hEaAFKsHKaOkm3zcdiTd935bOOtXO/RGKV3rExpx+mNbqvA?=
 =?us-ascii?Q?V7U7R/iyPFzbce9eMtgUicCZTLP+d2fW2dArl7oXDQ99sD13BNFRKcZd7Ztq?=
 =?us-ascii?Q?A8MQKgI6U747MlM6tNlQyqWfObNVdvczNjK2sC3Sisjiqqe9URjfH4nc/3Si?=
 =?us-ascii?Q?Exrjf52XMvg9Ig/rvkYHTLnm5C3JDAWZTNBudcvk420s2o1VzZJ5RJ6b8orZ?=
 =?us-ascii?Q?he5jItiXJY8zi+4tuMqtlKGETPj61/wecifTGpsegg9Q4GCANhxw8ojqZr3B?=
 =?us-ascii?Q?kSCGZ1eG5Sv5kbXia/pcloCjE2Mn73gmmK7OT3o+sDHLf0WEK47hVblQPJ1/?=
 =?us-ascii?Q?drkDTMK9+dm/mRA6EwX7amE1PoaMD3jBfPr0mEEkkBHJmNB9RgX0dRkJpecN?=
 =?us-ascii?Q?Jn+Gpi8/i0cj9uFeTeEODgfneUDCSQl0xibPthtNlH1nKvuUcVdDNthqubdF?=
 =?us-ascii?Q?CWSadP+LQQrwYz76SSlnMRQYhCepDB5yuFXv/XCmbNKvkZ7cZX9+hcGZBPPP?=
 =?us-ascii?Q?iVMzK/FgbpReEFfT1JAVS4fyvUCtnKuhJNVt6F9lJdG+WSIr+i9Ohe8ogFCx?=
 =?us-ascii?Q?nrlD2OKl/Y/d+Hl/pyW28YjXPcYuAxRpzl6Oy1MSN9KHtrN2zDrr36rQ3d7E?=
 =?us-ascii?Q?aXKw1uppig3O7nQ0yNMkiymVoiqhpswY/RhalCae3XMg2TKH9TmfnOEdeuai?=
 =?us-ascii?Q?xT8ogbDVqTgGISW+jIWCSp6rvcSsEeiI1QEE1QJIfwl0uiJca2cEHAUz9AH4?=
 =?us-ascii?Q?mXq66IChUm/sVmMjDotkJsCSE5ckZr7HIv60mujt8deSkMFtcj3plDfibPIS?=
 =?us-ascii?Q?gRyqBk+wali7RPJviYBt/UyqoKG02oVH0FBnZW/Hz1YgbcpnKxDY+Tgou77b?=
 =?us-ascii?Q?no3ig83PY+9L1lRchfCnJua62/0e/GZmbK6Sso7/pqSx7aXiZgLqHpOm8A+Z?=
 =?us-ascii?Q?lNbOX9pIP970UKt7wT2CtZ080Jmsz/VoQ62AhGUQxwnPyAfmdhCNxJRWWf+P?=
 =?us-ascii?Q?UouImA3vGEWLaUyH5RmnpLMDB0CxLS+JcHia4yHKF4BTtoQa8mlQof/BPTK5?=
 =?us-ascii?Q?lgrEjaOT8O/u2DqptvDKkZ/+HNtPsPeWiWt91NC/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf007144-ebea-4cff-ebf5-08de385acfd3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 02:13:01.9987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9mUzIzHnEKAplfeqnywqfNf6fRiE5TbnHUnrM1On47WtVxHCOhvUv+iP84+RL0RDgGqrF55iXo8IwScxgrlQBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7564
X-OriginatorOrg: intel.com

On Thu, Dec 11, 2025 at 03:49:26AM +0800, Edgecombe, Rick P wrote:
> On Wed, 2025-12-10 at 11:16 -0600, Sagi Shahar wrote:
> > From what I saw this is not just a
> > theoretical race but happens every time I try to boot a VM
I don't think we mentioned that the retry for TDX_INTERRUPTED_RESTARTABLE is
theoretical, did we? :)

On my SPR, to boot a VM with 8 vCPUs 8 GB memory, on average there are
271.4 demotes, with 1.1 retry for TDX_INTERRUPTED_RESTARTABLE.

   #    | demote cnt | retry cnt (for TDX_INTERRUPTED_RESTARTABLE)
--------|------------|----------
   1    |    271     |    2
   2    |    273     |    0
   3    |    271     |    1
   4    |    270     |    2
   5    |    271     |    3
   6    |    271     |    0
   7    |    274     |    0
   8    |    270     |    0
   9    |    271     |    2
  10    |    272     |    0
 
> Oh, interesting.
> 
> > , even for a
> > small VM with 4 VCPUs and 8GB of memory.
> 
> It probably more matters what else is happening on the system to cause a host
> interrupt.
Agreed.

