Return-Path: <kvm+bounces-65084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F78CC9A55E
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 07:35:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1936E3A4F13
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 06:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00D803019A5;
	Tue,  2 Dec 2025 06:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="isFTN2e9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3865F301706;
	Tue,  2 Dec 2025 06:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764657329; cv=fail; b=pD6V8JAT8W57/kO4YEZY/mmilPwQRWE+lF/95RA1IHerq/eQou27rxLgZthnO8jWMSoQEpNCWNaAn3mjDvs7mVzOHJI0X6e65et0Z8YX4jJ/vYnV+BhcXg3zgCb/UYZcZ9bMSeFunByYIoveoRFUyykaBEkq3iM5Hk6/GwZaHCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764657329; c=relaxed/simple;
	bh=0K+hl92jBjipBZRQ/Q5su1AuGBEXYKlsWgy++kIdFL0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QBA15cuyFP72PFxMPyYjfcFnsE7mouWHjVH3qd++FMxty7DkqQADgt+ORNA91J29h45DUhdKFAy4BdKDmGzgKCLOGTjZs5DhO4ep3MMJNAYfBWXohfA/1WrmYX0Z8mGu6ZBkyamgkTHlxUZ0NwL5t5CqO2h5KlZJea2vcHY7MdI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=isFTN2e9; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764657327; x=1796193327;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0K+hl92jBjipBZRQ/Q5su1AuGBEXYKlsWgy++kIdFL0=;
  b=isFTN2e9l5d2QRDd5RIY7gRwax2g6iitwZ4clW/pJVrVTSzz6FY9Irk8
   F8R1Q5xX1yeBszfuB1ZhlSihtOPlyaD9fkBAjTiR7h0VGYg9tJSZNzAKU
   UBupubxEFwTJIcw+im+taH09BErYeMDC5xE7ArGTbxc6bt17Q5oZOaLA+
   V4Cqe5GfDSGoL3XGlXUHHAbasZKs5JXItQ0G91tAUZX38tauDFNoRqHK9
   rOMCpG+58crZnXmb4VNEYaGR1n3JhEX95LX9uVaZrteru21Y37CjipS/Q
   LEPq9Lmn/OcvJ8heehndakt63xIg34qFK5MPG/z+mH4kFd2Lj/XCAq2jg
   g==;
X-CSE-ConnectionGUID: /Irf1xSgSG23jOb09ViRrQ==
X-CSE-MsgGUID: IaelFYH8TPi2F08j21g60Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="65616861"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="65616861"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:35:26 -0800
X-CSE-ConnectionGUID: BxbGgzYBTai60p6lINE3+g==
X-CSE-MsgGUID: DjxuDL99Qe6oOmv8Jaoi7w==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:35:25 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 22:35:25 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 1 Dec 2025 22:35:25 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.0) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 22:35:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wtNxs9gf0g7u5yirK45ioKe+PtRUxL4kVP1pDz2M2SSiPEyhtgU3Q2L/+Ls/wzLO9nmYP9VKX93oQbbarWmQWoebe/UN8LQR41OHulwSHZ5mv4KVQebPJxf38+UWeyj+XW0t2lQ/0/iTgyKYlWHdVYH61HPT2QxXzUpFfL2gajkgi1OiAtWAUzc82eCrwm6w3UrQJte3nM6wsI4CtnNWkZshBe//c87dfvGCgy2BiZbfo/tindaQpHpMuuslbJo+qnmXZsbn1u91Pas1zsWNKETgYicvLP8c5HdJ6AvcLquAlOAr06Zd3KM2Jx6v9Eg5gVsTQL0oqbYUm+skZBC9YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r1ZRmd5VQHEceF+6taDkP58UVezpF6OvbQsSt6Zun1w=;
 b=SV/9bIv/M9U9Ek8il5GrEM7DuZXUtDN53wH230nFTQN/sjoYcxiP+J4j3ad1s75FdgKsB3kOwHB0gRzxAJx5rxYsGhTGe1R8OjaR+yfjB2e5uaPYvc1En6WftVGhvIdgF2cvAzj5f2bXV9IUy+1cUymcOwSLZDQFcC3UWYQSvBpYkXxymW72vPAh9/Z86C+ISlK7I1oSrkBgAvldCb6N8LmIxMKU0Y801kN0nlRJCKj2CNeaXP6pWZi/3iirxn7lC/k5kbXwgdKYmNMXIKHZUgpvhDT5UFzG1wJEF4X2rRX0xNYY758iLj3Q5Mq01H3i2zUbi2Ht6R9gDniBVXB0pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ2PR11MB8539.namprd11.prod.outlook.com (2603:10b6:a03:56e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 06:35:21 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 06:35:21 +0000
Date: Tue, 2 Dec 2025 14:35:10 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 21/22] KVM: nVMX: Guard SHADOW_FIELD_R[OW] macros with
 VMX feature checks
Message-ID: <aS6InlCSUqeKp9//@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-22-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-22-xin@zytor.com>
X-ClientProxiedBy: SI2P153CA0001.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::7)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ2PR11MB8539:EE_
X-MS-Office365-Filtering-Correlation-Id: 236a61ac-aecc-402e-2840-08de316cf7ac
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4UPdkL72Mkl3M/RRC3TpdfM+3+OSuF5VZf2zolMG74dlBpGeLuJjV8ynBxRa?=
 =?us-ascii?Q?lxukIKWgDnIRx8qshHc0w/LvHA+AYMuwj5pdG1e8vHHOxkSjB3TRmGZYl9sp?=
 =?us-ascii?Q?10xXxkRBWrbRkfpc1SU6+MMo57wcli8vs6wrZVtBgqSGTBhjh2BhnXWpFGe4?=
 =?us-ascii?Q?RyyIb3ZeoJKYJk1R12AMXvdcyOM9MWSr8YxgIEEgjFTxQdl5x/9o7fhydrwn?=
 =?us-ascii?Q?BWkadBtdCy2s1TI0yJUjUWPa0EbD4eBUsTnv0Gw6pQlaP6b4tgwg7BQ/pGcR?=
 =?us-ascii?Q?rsf3Np/LjU9z7WIvlKtYFroh0rVm2Ux9IIJwdwZ1O/KfpfbuRW1QDN8OooaV?=
 =?us-ascii?Q?97vEEQNFOxupmTDmWhgMNRWX4R8Qdvy/JM8WfNiUaFQBPsqxZBhtVyFny7OX?=
 =?us-ascii?Q?2wd3NSL6f/dPp5kv6tDnTxlUjFtaqCERXhjFa2DLP2mKMfnnf82sbc7/mrmm?=
 =?us-ascii?Q?DRetlczCj9KGXpMcgA7NJkrpDPNp6AVnHdkFUG7N34xXVgQcKuQt/5HogsMX?=
 =?us-ascii?Q?XvDUdB1E/yOjae083NPYGUgM1i1lcfkmr44CDxNG7pLAtJS+z/iYdf6hMHZb?=
 =?us-ascii?Q?GZxNfv2ilPZH77XDbLLL7ElQdoiYn1Cqmmhl3MGmQ6ltz9UjsKkNYmfGgLsb?=
 =?us-ascii?Q?ERXgjNQ48ywomysuWbqlD++PWt/uTcUwsiXw1H3JdMQjzNlhQEvQGcEz0Who?=
 =?us-ascii?Q?lhsCC6lj96gZg/0Mie85+5BtZm9404CfUg1fbr7kFoYu1YvgzytpDgGpA6Td?=
 =?us-ascii?Q?8giUKa68eFTF+ysqKUbeZwFYtGScDppK6OIbDHdnVAQyeMswDoGAjD+V6oFM?=
 =?us-ascii?Q?Vwiwgm+BkUMsGoMb0YlNRjPK2+JoHKoa/UlvDdEQSWF+6xM5vBcTy0IKDCuc?=
 =?us-ascii?Q?UG8F90jM4vP5D+QlwmCVgl9PI2YSddMux516ZjE6U1Szdl3BOoDWWwgpbiAp?=
 =?us-ascii?Q?83mYfdXKhnNRaCCu/nd9O0sKwM1GNFn+VHH3kDzqy1haAdjPuDvWEljrxRbP?=
 =?us-ascii?Q?se8OYXpAOkpoo8rxSKF4ceUb8pNxbFOuTYZcrK2SxVOGpjtFcMnSNEmlNiOs?=
 =?us-ascii?Q?MniJMqBQyrCFESqbkrvtdBQuJcu79ARZhVzmiQjJaDsAp7rbPWmzSUWTF1UM?=
 =?us-ascii?Q?pQ3JmBPp8ACQsiowvXrBQdhmoHQnrwOcBGLfzox/Lclp06tYHyGzxazch4Dh?=
 =?us-ascii?Q?8p3M4T5xB/8z0w41WNpYrmAYaMmpiObhBfrsXqEvG1OH1XlolbDaVGTSM8y6?=
 =?us-ascii?Q?E1dYATAaQTRFuYaXgcfR5JVZteAjVSiDuXq5Ls7WaScUWktiPgh9T6yXvLQ8?=
 =?us-ascii?Q?sTwza7Wh5yCMNFN2xYAvaedvuk+Euz3BseqGI+wnmKDSzSrXC4pSibtYy/eU?=
 =?us-ascii?Q?THZ3Ki4tRUchiGeWMlmf+1AHsqtez3o0YzEQcIrqqovPeWhfO23V1ti60q1O?=
 =?us-ascii?Q?7qpvre6AtG8FbcTXTNHFt9qt1zcDvwnT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1HM36rHuM5E1PELnDDZ8Dvmn7+Dp4uxtbtmrJx0o7sBIgk7NumU30ewsw9pK?=
 =?us-ascii?Q?afNAllsbusYVCfweDsJ/KFUwwz7pX5vwJALqt658bCaU9rHu+pRSYD0d4XCe?=
 =?us-ascii?Q?C7fNItYD7hXprZ+Uv/OPGWR1DiUnl7RrNW5wvcBVdNZANsC5dP4vIJmpscTt?=
 =?us-ascii?Q?t7vGxDuMLJpsL0dyW3ePwt5y4f1GPIigfDO6kVz1o0OsX5isQHxUymMHJSZt?=
 =?us-ascii?Q?ScCuxsQkIvqa4z+atZutW7zWjnjCYKy4iNG9NhChbHzlq7k1ewJJODm+huLf?=
 =?us-ascii?Q?oM9dp2Y/55loXVxjmXWCtcRY7LeeRDhSUGkbrYsg4VsPAeWGWI9q1iOUDlik?=
 =?us-ascii?Q?W+JGN8mLdq+0E2Qtbsp5pvmjpvg2Yb8VpNTRD1DyOukyrMZLNyNjsMLgAGxj?=
 =?us-ascii?Q?6JtvtM1mI6USyc7TLvIuSO8vcr59QICJemLnp98CiI2ardMWmsvMXgK+pNaG?=
 =?us-ascii?Q?Zml1/Ul5DLpHtaECE54AoLen60P7BMnL0teSXyvONfw8P5v6DsyzmacVmDWU?=
 =?us-ascii?Q?+GQGXl2HMOQemVb1QSFZYXA7oPsCa5FTqp1zlXabKa9oVEPwz5SrgI3J7dFW?=
 =?us-ascii?Q?v1q+WkUN0tfvDOPk6g+0xUWpNeHF7u+w/2yFvqbK9qTMbdA+BN6gCqPM/bmw?=
 =?us-ascii?Q?pPmuBsWUtJNXzdLd409GQ4WArGMqdCzmgzLlK/U4KnHUYIQQDkBKrD/01tr2?=
 =?us-ascii?Q?cWCBns2/FZe/q0dvob/mw/SsyPlxCiuK71uLPbBc8kIy4bLuceaMkzQzGA5E?=
 =?us-ascii?Q?3omy19/lIDtAl8BpoRLH9zsQbGgIpvvrr4FjTP/irFW85f10T1yN3zTbeym+?=
 =?us-ascii?Q?LllWnpyBXjFUPK2kvggiA5p0spcjSG9oKjfanuaxexbmmnNWndsPRg2hN0Bn?=
 =?us-ascii?Q?bDyGRxxMbI+qmg81Xy8Dw8s9Xo9MB9op4cqH+wz0BU/etqmpGJND7U5mG9Ig?=
 =?us-ascii?Q?osjjh+1/AoDiipLv5+uYyKw3Jag1xL6k8EiKiHay6iH94fCAFNUKP9sDgaKT?=
 =?us-ascii?Q?NnVFtQoyAhI1D4Wip8ZcWIyuztB7FzFgDXNcScAGbgdDT6ew6twBn7cyUxkC?=
 =?us-ascii?Q?g1jRxDqtwRNhrJ32DwnP74GP4hvd5gdNrAZ1KDBjXD1XjPiysIKTbXFgrqqV?=
 =?us-ascii?Q?56aXhqXiVZIRgvWATVKNLFaR0nzI/WQyXHEhy6b/KyDDc48nFKksBaizjCod?=
 =?us-ascii?Q?rV+KvygbvAYHSi404d/Rv55Ibm4SZ9vp8y0R+vGd/aYghaFEqoWt7iFrPLaV?=
 =?us-ascii?Q?1npt+DIxlxBgLbLCYZ6Z4i0hnh9uqVs2nXPGC8RAQMxRqlLqpuHrR5FxjoJQ?=
 =?us-ascii?Q?xcm3R/FxN1qhXt/0YC5QsYnGj/FCe/KxTIbY1JXlHbprcgsQsQoqWwfGad2d?=
 =?us-ascii?Q?aZrbs14c65VSryBn7KNvWNmB02n63BdMxkaUo+kLkNh+RcyentgY+8I/QPZ2?=
 =?us-ascii?Q?P9uOmZQz7QULRsGs/40fTXXcCvccyTMCYA///LmBe83DPgJPgEd9oDkLLDtI?=
 =?us-ascii?Q?YMGJ4xmBphafTTiBC8EFML9EcBlVOCYiqUmWYQQ9FAT9GRRRw4A+ZhFE0osl?=
 =?us-ascii?Q?suO9SVGFlSfEcSgMgD9eTnFRBnaRkEl4zlF+RYBX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 236a61ac-aecc-402e-2840-08de316cf7ac
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 06:35:21.6595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4dH2o+4HyT2ab2MG/7PgMpntm+pEiNYsG9Qa2UlvRHxb3FlIixD2OhSFH/tVgyDkQL4G5zCLKVQuozwIf4sAyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8539
X-OriginatorOrg: intel.com

On Sun, Oct 26, 2025 at 01:19:09PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>Add VMX feature checks to the SHADOW_FIELD_R[OW] macros to prevent access
>to VMCS fields that may be unsupported on some CPUs.
>
>Functions like copy_shadow_to_vmcs12() and copy_vmcs12_to_shadow() access
>VMCS fields that may not exist on certain hardware, such as
>INJECTED_EVENT_DATA.  To avoid VMREAD/VMWRITE warnings, skip syncing fields
>tied to unsupported VMX features.
>
>Signed-off-by: Xin Li <xin3.li@intel.com>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Tested-by: Shan Kang <shan.kang@intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

