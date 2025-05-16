Return-Path: <kvm+bounces-46781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2E4CAB985F
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 11:10:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE2021BA389A
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 09:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149EF22F386;
	Fri, 16 May 2025 09:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bH5PXdKZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64031A704B;
	Fri, 16 May 2025 09:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747386603; cv=fail; b=lOgIVm4uzrwVNEMWdrkPlkRf3xKxpx0Ifx1gceDU+fRdqoKg+LG47S2tpmLAnwe0i2FVDANMjzOIfMr6hSnP99IRjK4vGU3QnU6EiGrAL7BKk3e39p4a4Cq+w9JrpMBtsrQyLTwx7pWzjWM+EziaHiQAk8v/HKcw/CYejoUSduE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747386603; c=relaxed/simple;
	bh=oLcbfcOi4yloHV+EQoey8kBzKQ65mokW0jWBgNgMjcU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tOthNSoR3YVJD0zRys8nJYvsNBXxFN1B9Qx8DECegnhvvn1EfEgialEtcBlbxpn9432Ea5ur9Tupge2oDFfT8/TPPnjLDDlZ6R8r7a1PXw4qpalRxeqfghS4tnD1aqElHAaucnBuRDUQITmdS9CDQtNPlGwAJg9zBWXdBzNnl7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bH5PXdKZ; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747386602; x=1778922602;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=oLcbfcOi4yloHV+EQoey8kBzKQ65mokW0jWBgNgMjcU=;
  b=bH5PXdKZEsYg9E+LsGbtzPGgUD3ftJmmy8R2VRLVm79pRxEX335psusW
   HCBewnqffpCrI0R89/Cc/py6HGxDtek3c7AoPSjUWvlJ0vzi/uqB2CiLO
   y0kh03gfK4LzxplUskE504X4uYjFBAzaTEGkjNFbWhqM2Ptp9zKFlUaVt
   C2TbiwpU9bmBan+MzqOZFDDh8YWSKv/FeE4idkIkBw5czZzwUrHhUm6MR
   /AGF78x4AQrOL8vis1+ri38t20LUIoyAmtNvzFVMpIqI5Aaf7wOmy60y4
   ljhH2bO1C9wHj8n7RPgSjmfV0hx9hQpoe/lUqya5go9PJ95iLI5y7cwdV
   g==;
X-CSE-ConnectionGUID: yGsPrsnRTLORa2W+VWWfRQ==
X-CSE-MsgGUID: 9GnjrGSzT+GdPWhXDCFpxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="59991147"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="59991147"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 02:10:01 -0700
X-CSE-ConnectionGUID: HPp45T0CSNem/6UEqYT7fg==
X-CSE-MsgGUID: L1rVfjjsS8OS0xWPC1NW3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="138555371"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 02:10:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 02:10:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 02:10:00 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 02:09:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iDdV9aBWHtzpv2MXUZ0tQn0OTRiRps1/IBrtpbzReUwp7QtNUOGxHhKQ/34a4bta8WygCWqqNES7mbHZ9FN6wvUn3dRjZf7Y5By79FEiCN6bfDdLkM7ZGllJvseg3T/NrWPC4hGpCMrb40YkRAbRaE5PrXui6orOmbjWwFXem82QvawNdsidXgYRCM6uxgkj/C1FGYLjkj2vJ90SKvXFbbb8bcLCVcAEJ76qqdQtcOnK92c8BMiq0G1En2IW9uocC4g7zBA3vpDuKG1fptgy4OwGePvmvXu+ozTJcyKj99wPI1hrTuUqCMrP2pLEGWStdMGlGrV0NMEDZ1pQBOHGlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pQkxW59ZMhASukJnUtHFaE7OvZaN7EwQZi2vBg6mxmE=;
 b=yXejcvhTCRU/T1Eq3B1DSHGdrfkwc8EAiuvFlko7WSkglzM1ZZUUPeJOQnXGC0XK5wgVuhboGNzO8QCfRfhujXogyS70w7U+JwHy3yEehV840tVYzPE4jb2JcKgyJtkGWMrQHvzvZnB3Fz0KtfxTHGVPbeRuJeEHhHJassZTAz4NiI8BntGvPQ0N40z3kBTZXUGqAeDg09vUNktRT7N7HKpPVOJAqq+224bfMkIoWGmsZrm5g2PEMwFKYiO/bOPaEhjLTTdGibFUzwfK/eMfg0tSv4MFkx6mNcTAoQ1+pCykleh4fvxow9Dpyod8JnumopjAcMujDY3n10GVWKJFYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH3PPFD114713BA.namprd11.prod.outlook.com (2603:10b6:518:1::d50) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 09:09:30 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 09:09:29 +0000
Date: Fri, 16 May 2025 17:07:19 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Chao Gao <chao.gao@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vannapurve@google.com>, <vbabka@suse.cz>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Message-ID: <aCcAR4oK6ljOSCdu@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030428.32687-1-yan.y.zhao@intel.com>
 <aCVOmp/tlpgRuAF4@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aCVOmp/tlpgRuAF4@intel.com>
X-ClientProxiedBy: KU0P306CA0049.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:28::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH3PPFD114713BA:EE_
X-MS-Office365-Filtering-Correlation-Id: be1f0ccc-333a-400a-ed45-08dd94595d61
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?gSh81iz478+C5+B9FsAS24zD/4p8aVum//HtjH9z7QITzJS8pYwlUHAU3x+P?=
 =?us-ascii?Q?IHevmUsilum/bk8UB6a82FaBrwUivRm8nKv38Lk9muc5W6Y+w61epLfmIV8W?=
 =?us-ascii?Q?VKyXayFWN5ZW20HKEZVBIAGnRAEjQItoHv1OvL8c1jNqLxa0Q88x+GNJUG7F?=
 =?us-ascii?Q?Ymdw452aHMOVr9ohiKDMsAW+La/bm3A8BwkbNTjA/z/xgkk4awnWjZbtNoMz?=
 =?us-ascii?Q?mMfa4kVCVmoleAOQDzSyC5gQfkIG4pt5oWxTywia1wQPh98ZmdYntio7fp1x?=
 =?us-ascii?Q?W25LFpwsqi2Ubge96ay+xP7oVA47P/FlDUooC7F7LLV9KLEGOaLo420nUBCL?=
 =?us-ascii?Q?E5phx3KRMMaWHJYUSXzDVk8v96qMoi88/bv2CIdRbniaK3+f5m7bbRTWh5Pw?=
 =?us-ascii?Q?ZpBl5u7gltbSoc5dqxne+vEf82I6xryfMBkfp67PjeCEcuaFd0V8W3yIDXkC?=
 =?us-ascii?Q?bNOcQVA/DlWX5fhEB55QHh6lHckLIekQZY7Qi5cNjstauONSFHaPaAasOGY6?=
 =?us-ascii?Q?nSOgeqrVPK+EC3tMPo7tbguLMugSniTj+FsAm3wes/pYKy5dFcRPPLPYpSrp?=
 =?us-ascii?Q?pV5/2I+DsR41N1yk5agEY4f5CLnFk/8QQcxO+nAOhyQoSGvN51vinzjzz/oQ?=
 =?us-ascii?Q?M9G2QKUGq8toPv6u+BbxKD9br3mcFBR+Z9/HxTT0LVGbzbERynh+KrBLMD5G?=
 =?us-ascii?Q?Y1Ppe+oCeMJk7mQ/+M7wEgKXRlNFJq08IJUoTVXAnbqYUjydk5sPnC205UwF?=
 =?us-ascii?Q?eT69DwEvvtD1avgiWoW67HQ0omNvMW3s59w+GQH1t9f7NbZ3EOdELfFzSd6r?=
 =?us-ascii?Q?hQHhW0YMgsJiaqgesk0sFM1wuprRcGOidjLcXADI1TKoj4VAhuIrf2X5MMaA?=
 =?us-ascii?Q?uo4o0VEMhhdKvLTL+uMTE+X9lNivmBD3VGLlWDAv3ZN7HsSRNWAOsvg0rhg8?=
 =?us-ascii?Q?CHBLDN2aolNXi6z9OeFf1SlCSF5ZtFqe1QyHqxsXsmqJLE2FCJek8QtZe4/p?=
 =?us-ascii?Q?LMDEJ8zGHeenp41kKtpnovXpoZVXIXw3BkcjNbK0pdH7xFFWRHQQls+CHBp2?=
 =?us-ascii?Q?ZzXhfSSIrvltkKEplNYODfC9gnlj9aDW86QhcnnPcPWzPleqkV+oUi6K1LX/?=
 =?us-ascii?Q?uaRi7RcMWGpiCY0L9xcej3MtPDXo9iWhvLUjU7rQZgXY4V8Hg3TTk125EGjS?=
 =?us-ascii?Q?SDAC/ItV954wMb2Awuruc+tODZJWb4PfW0F7gnaWO7D/NZ7JbFIaKvdVntKC?=
 =?us-ascii?Q?QA3Vrn/N7eW264MOs4oJXZbZ3zAVKfoUi+2AcMtXccYPZUdaokyjV1ivJIWo?=
 =?us-ascii?Q?EbH+lXgQRl3oF3pxxFLBwsIZK6Zw8E0rgf734N9s32wDBzo+4+XyqN1aw8MQ?=
 =?us-ascii?Q?Z2CZnhcbYkEKhj7J9LrK3ONP1vok/Ssypipk93mT3Hy9xjkvfm/barHI0SX4?=
 =?us-ascii?Q?eyZR+pjyNfE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+CUw9USWcLZk7t5drcdiZuZ5xdXwFzwnlK1tGRFT2T/ndE6pe4mTSc0DB/ud?=
 =?us-ascii?Q?wQL2jph5l5w6bFsok48BbHYNsuXUG0TI1/3oQP1ilptL0FxRJeAi4pjT8Yic?=
 =?us-ascii?Q?Ndul28LW0Xa8zQMlLYbTvNs9kvtumT8f6vtZ8wUDRZpnyYYVasnvoz5fGg7g?=
 =?us-ascii?Q?gn2+WYyx2zX1WL4okOH95Zk/DzXytfLn983SB+JYdRxwOV+lPXpZYBg4rT+k?=
 =?us-ascii?Q?3OSzmJJops4oRHUMPkAkN4U6zK/HAR2H7okHnYwtxDLYtyaTObZaMZ52XuZ5?=
 =?us-ascii?Q?pMLikb3+m+ZsQwCPi0xpNh7jfNSOpDF+3NdAPXilCZ0+i7NYbJRft/mY+YtX?=
 =?us-ascii?Q?V03EpeQVdN+Q0iALgelvXcnFf3PVE6d/RKs8WBUHo06X6HiQs4rm4ra2okda?=
 =?us-ascii?Q?UvCEAdEFy6Ve0e+s4OXoM0Fx4sEg665Jt6eo+i/Y0Pfv7XHvCcILmwOJqHnT?=
 =?us-ascii?Q?v2A5LxZv+20fBpQa57QEvjQBaEoF1RAT7xJNa3ogBJTtytLaB7LcxbhZDWsq?=
 =?us-ascii?Q?5awzHGfUQJEw6VV1zKBMNBhBgXyLEGBM2Le8JiJ7IiwAICRz2ag6es6xCTTb?=
 =?us-ascii?Q?pnyqP8coCS7b2+7X3NE1tRx6ybnimtqiNWaoErEpFiIXvatYixsgdRY3e6P3?=
 =?us-ascii?Q?q+/l7IGVooM8gAI5+2djLsNw973NnCDe7lNPCk35bfsJUlbhlochSsOvAbbL?=
 =?us-ascii?Q?wnGsSxM8R8Es74tIvC7UQSw0O8gx/nVMqXy310kpqdPTHCLQewwyQSCexWB7?=
 =?us-ascii?Q?ZmNZdGZqdGWlNAetqUDFJUqXu8q0H4C76knXKxWXsBnSV/mTWsc9hxsL86Gl?=
 =?us-ascii?Q?qKbDIK1YMoL5D+OqTcyi97qi8lNDW490SflrhPrI3MkmtdLSuJyI0wQsQfB5?=
 =?us-ascii?Q?cbe88RGa3w3SqKv+JnmsMt5tQE69HSktjikLtWcnJWgRgcOh0MOJwl/jbvqX?=
 =?us-ascii?Q?GjW5y/T52ZoyFxxex7d/+7aIKYqMEY0xyRwoxXAsPuDIggtUCDMeh6wqhRwK?=
 =?us-ascii?Q?51WkeIom5yvtfMhOckAvb+Ja4rtBxvjvYLz6pgA2/Nt0aPhwdo5iTZWejaFk?=
 =?us-ascii?Q?fe9bX1lyl3IOCTt4eg0CoJlnNEx5Qe/IQWnEdRPgXdufnsRnU5AYSUlsDpQV?=
 =?us-ascii?Q?OKM2nhtFGX+O3DCcqePlv5lx+f8uweLA8HGOIO4rg8KosOqMxcTqWXgsqBwf?=
 =?us-ascii?Q?IzRHlt9b63fsLLJDfbIZXWIjv3Avy7Yn3bFi9pvVHPmSINmxWfHfrwOlmmMK?=
 =?us-ascii?Q?Nur+AynCpq4e2iumkXS+3IkGBhhE/9HnRHj3ajGK/navA4QzJLrIJaIFqZb1?=
 =?us-ascii?Q?i3RXLRLtP7AUrQ4x5Rt29L8+yXAxgHrwjRxfJVw4Izx/aNqXXNEFAVXVugw0?=
 =?us-ascii?Q?opWYH1HUOXPVzwZI8XHY/XtWy7rt+r+anoKM+B07DWQiUcFkbjzJp9NE/JNM?=
 =?us-ascii?Q?1jfL2Kq/LU3acMGtx+U1rUHF/kMGezk5ped3AJfhKJ9xyfp4uV4yatakLM3V?=
 =?us-ascii?Q?yJ7eJu0o3dVU/2GJjY4LXyp0I+fVvCA5PUeo7rMuEqbmRNnGyx7x6Jjv36bC?=
 =?us-ascii?Q?pdtjvKWKw5gDCa07JeiusINBLmgjuV6g9bGl1tAg4Rk6qr25XmIR/Z2dATno?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: be1f0ccc-333a-400a-ed45-08dd94595d61
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 09:09:29.7938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vITTBOTA7muVW/wCa7/E6B3hGCIouqmCPA6oTeKJ3oxNmdHP1LHpCnhD94qac1hg97ES/5TM6A4XElbhlcHsbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFD114713BA
X-OriginatorOrg: intel.com

On Thu, May 15, 2025 at 10:16:58AM +0800, Chao Gao wrote:
> On Thu, Apr 24, 2025 at 11:04:28AM +0800, Yan Zhao wrote:
> >Enhance the SEAMCALL wrapper tdh_mem_page_aug() to support huge pages.
> >
> >Verify the validity of the level and ensure that the mapping range is fully
> >contained within the page folio.
> >
> >As a conservative solution, perform CLFLUSH on all pages to be mapped into
> >the TD before invoking the SEAMCALL TDH_MEM_PAGE_AUG. This ensures that any
> >dirty cache lines do not write back later and clobber TD memory.
> >
> >Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> >Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> >---
> > arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++++++-
> > 1 file changed, 10 insertions(+), 1 deletion(-)
> >
> >diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> >index f5e2a937c1e7..a66d501b5677 100644
> >--- a/arch/x86/virt/vmx/tdx/tdx.c
> >+++ b/arch/x86/virt/vmx/tdx/tdx.c
> >@@ -1595,9 +1595,18 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u
> > 		.rdx = tdx_tdr_pa(td),
> > 		.r8 = page_to_phys(page),
> > 	};
> >+	unsigned long nr_pages = 1 << (level * 9);
> >+	struct folio *folio = page_folio(page);
> >+	unsigned long idx = 0;
> > 	u64 ret;
> > 
> >-	tdx_clflush_page(page);
> >+	if (!(level >= TDX_PS_4K && level < TDX_PS_NR) ||
> >+	    (folio_page_idx(folio, page) + nr_pages > folio_nr_pages(folio)))
> >+		return -EINVAL;
> 
> Returning -EINVAL looks incorrect as the return type is u64.
Good catch. Thanks!
I'll think about how to handle it. Looks it could be dropped if we trust KVM.


> >+	while (nr_pages--)
> >+		tdx_clflush_page(nth_page(page, idx++));
> >+
> > 	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
> > 
> > 	*ext_err1 = args.rcx;
> >-- 
> >2.43.2
> >

