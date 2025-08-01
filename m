Return-Path: <kvm+bounces-53827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 878AAB17E3F
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 10:24:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4ABC584A9B
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 08:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1C621ABAD;
	Fri,  1 Aug 2025 08:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GBoxi8Zt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5B320E03F;
	Fri,  1 Aug 2025 08:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754036674; cv=fail; b=P5zz6h28OmOon5Pl7Ku3Joh4ifklJd545P1pSXkq+HujLKtJxyOVN0tIwUoc74k9NhhlbTc2ffme++upd+wBR3GjYlpRfXfyDJ/dkUSm9qBuQs0EdVgZCC4D90nJDfwPEvaIb8t6YT44Zf5nr8OJI/DC83hDnogAxPnYQIon1qo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754036674; c=relaxed/simple;
	bh=YLdTEqIL3HaffgoHdoZKbZsxeqZvXzq2WdZDysdmqJI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Y43HiRNJy28Qgc1DWHNFgzzpD7BTUNWqb47ePiCCs4sV8sGmQVydz8DhrzBUXTRib6BJ+tfJXlzLHirrahJUH6dZ1PPuhw9xuxb3xVt5Y3riZAjlkLwJB2L1gjcPSEp3ABbKqgcRYo938ZtlGH7AdlZRDrO6O/NrtzSZlycJ6TQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GBoxi8Zt; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754036673; x=1785572673;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YLdTEqIL3HaffgoHdoZKbZsxeqZvXzq2WdZDysdmqJI=;
  b=GBoxi8ZtmyeDl5MsiIekDxiaksUaPmoj4yykd5FoXNyZmSFoKdr6Xd4v
   PGv54o1PI6BG9zo2423fPb2bruvpyLn4JBrwx+Gqo+18ZPpM1IP8klcsi
   yG/4/SOWMKo4NqvsRqr6Ml/VUQq7LaT/qW1eBgEjaqCfC3XX+0Tvwi23R
   Pr9VVU6hj7ndjLRWPfTylfi4552rmAtxPGAtAsFunbrscurCgX3yQeGHY
   sKN0TAXzVZDzTACO2CTs8O1rg2DLbF/vhskRKz6I3N3dlq9X/T/VPMLS9
   MKww+b3s5rihplNZB1QfnlDbcdboJvaeBki+X9tC54vp1TzxF1vI5XRhe
   Q==;
X-CSE-ConnectionGUID: pT0jABKUTzi5t5KxtqtPZQ==
X-CSE-MsgGUID: FFe/8WoDT8qQbbItAWE96g==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="56521458"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="56521458"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 01:24:32 -0700
X-CSE-ConnectionGUID: i4Fazpk5RQqRGi9V1Dz5Mg==
X-CSE-MsgGUID: HDm3+myBQz2owYM7yE+nYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="168786463"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 01:24:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 1 Aug 2025 01:24:31 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 1 Aug 2025 01:24:31 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.49)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 1 Aug 2025 01:24:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wiAgPIFjPswcdsWnj1P+t//c0lxwDGC12WNyF6vfGxQ18IhKItsuV9IuxlrkxYY/HllxMlF3q3MbnHpeCVnoVX7yzChuNLYJKL4RJfHLylfhtymXFJST0+O3qmrdjAUnVrVuRHlLLSyrbMh/KG4hPX2HScnHgAbt+t1u4NOzX3TxvzkknkUC78LF/axl+4QhPM3RIMdajjl6cBAPBQ5qclPPcrxepv3j9K4/7PkG3Y2hEaRkjcCYuNX6exsDdcdnYybokirMKMKboobW1orvUW7g50B1iCqxtHcPLuvpj4V5bAF46KQGJPI2Jrr11Revm/axO84qTSbjQ2FDNE8WPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XkhU4OwvGf1mtY7e17gg9PFYyw2TmE9z40bft/NXlpc=;
 b=PqCJfzlCsbkNqF4Aj125zrbUdaN9dPjguvghIIdbYpXCqsk+N9D0czDOgPlW6dVrFSGcWB3dXoMCI6R1b62PEPrDKR3btIJ4fbSSdyWwGpV70omRIij4ggfl2Av9+xiI3AFiFi8l6uUD4ODSbKRjx7Bb0dL88aNBrIH02YSE3eMARQzPwjW/a/cXhjpaijm09DMdaMukxFOzSGTbnHlhkdjBn7Svga5EkkHjgpYIxYUvxNLoUUpW0/THLb0WoNYNX7ofjsYwFl5zqDc4R7dVpjxS4Q9Odk2DikKGmaRaPB/dHjI5r7nvvmlnPaweDizSvV41zIzeG71uqi/fobkyXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB6890.namprd11.prod.outlook.com (2603:10b6:930:5d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Fri, 1 Aug
 2025 08:23:55 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8989.013; Fri, 1 Aug 2025
 08:23:55 +0000
Date: Fri, 1 Aug 2025 16:23:41 +0800
From: Chao Gao <chao.gao@intel.com>
To: Kai Huang <kai.huang@intel.com>
CC: <dave.hansen@intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <x86@kernel.org>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dwmw@amazon.co.uk>,
	<linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<kvm@vger.kernel.org>, <reinette.chatre@intel.com>,
	<isaku.yamahata@intel.com>, <dan.j.williams@intel.com>,
	<ashish.kalra@amd.com>, <nik.borisov@suse.com>, <sagis@google.com>, "Farrah
 Chen" <farrah.chen@intel.com>
Subject: Re: [PATCH v5 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Message-ID: <aIx5jcdZ32mjOfXg@intel.com>
References: <cover.1753679792.git.kai.huang@intel.com>
 <03d3eecaca3f7680aacc55549bb2bacdd85a048f.1753679792.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <03d3eecaca3f7680aacc55549bb2bacdd85a048f.1753679792.git.kai.huang@intel.com>
X-ClientProxiedBy: SI2PR02CA0031.apcprd02.prod.outlook.com
 (2603:1096:4:195::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB6890:EE_
X-MS-Office365-Filtering-Correlation-Id: 61023bcc-0c6e-4aaa-a61b-08ddd0d4c12a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ZcpfUc8HXaeGtgVoYGQgd6UI0BDhfx1KY2n+Ss6eX8NBQWpLiRQC4qE6kHEZ?=
 =?us-ascii?Q?gb3Wo8s6Bxsgdc13XzI/ZA62y6MlqJNBuokGkAzJETRcSwD2AWIrNppjFiB8?=
 =?us-ascii?Q?VvzW0/KFAjK0CELniuqH2k16i8RevPxKoDsVrW3WL8ZL/KyChR6QsXYQRwu2?=
 =?us-ascii?Q?qLoenDiIDvwPXljnJiVOD1rhxcFoajlCh3/+ECYkKdG6oQ+280ZgvHU6H2t4?=
 =?us-ascii?Q?WYRKCL+9sdSHCu/xSbhgsXKlzp2vt+a5gzqhLbPskcQ4wic0vEivoWjEcBmv?=
 =?us-ascii?Q?DaIGw9GQ0aekiEOhOOW7kjptdPG+7/fIiNM3VCBKU7+f60TSG+xk/m+srNIX?=
 =?us-ascii?Q?Jde2MpI5aocpVtVaYFQMMSaatOO9Fl5exQwe5w1Y0waiZiURlPM0VQIoUEsU?=
 =?us-ascii?Q?K+c2dVGUQLjC/16NN6xHVN0G96HuiN4W2Kziz4/Pr6LUlb11Tbmc7VX5dc7H?=
 =?us-ascii?Q?fr7xUFWITsUt529PK6fbkmCxR6AI9x+MolzEia3qjNUB6wv+CtQiWBzd7/hO?=
 =?us-ascii?Q?LVt76FC7yx6IaHY8nRoh7rCJNzqq5vNWzBAY2tS+Ijg+LCbWEuEcRA3IcpNV?=
 =?us-ascii?Q?BNrI/plkYT1vC9XhSvKFIxnETlJr62yRpBmPnV5tcoJXzitMoZX8fNCj+UM1?=
 =?us-ascii?Q?iZfvRPg2F++fsyTQCE+lmt51MXIBX2h08EDCZWnKeJLCLMrWv2gRLW/QFpqm?=
 =?us-ascii?Q?rYpTMU17u4sBLmR0TdVj6Chslp2tXyTpg5BAbipmzYQlBjVZawCMxLVLcKKj?=
 =?us-ascii?Q?fj0D01XOXR1X3ld3pdn3Yy1ImgnSKbPceFuEv+JuydPV2isEsldRcAHhXKIy?=
 =?us-ascii?Q?FEg5zXxMxYzTjcfrxb5DYGZPCM5CYJ56yP1r90/FJueGZ4325llQcaAjgM2g?=
 =?us-ascii?Q?gDes+h0bb8dAW2Iw2hdpAViFzDhlfsCwOspW90nJjNYBu/8LaZrhOJJadz7F?=
 =?us-ascii?Q?qzrcfsuJBSYgPFYiM0ayeYjqYvCbycMVUKGLPNFxIHgkz/PhUTrs+1R2SxTS?=
 =?us-ascii?Q?hmP7lr56Uofs2YDq7PudSEvP/3Nv9GGqT5r1J1oFyNPjWsmY3sYfZ+aVlnId?=
 =?us-ascii?Q?DHX0LHSRMKfTI0GbS+QRYnLpb388bUrSomx211B1IP84BV0A6VoeiOExFBdo?=
 =?us-ascii?Q?AK4oN3HfdPnKIPO3Z4Kn8lLOHerYQhzctgmYkzxF1Cfg/o5Fz24Inm99QtkE?=
 =?us-ascii?Q?nFJQInPsVYtUKR1O3LapByOvX/GYkdPEh2gYn+hmu/ZtvS8HH9U7OOdCF7d7?=
 =?us-ascii?Q?FrAIqzhWvE2lySBvICc7ZYRM3fDnYZxJ7y7L8QTjnX/iyFpWrSQ/5vVLxmD9?=
 =?us-ascii?Q?DbQuOf30WVmcSfLimaxTIsgF36AD6rEU6AA9kK8MphJF2Jj3JYeXsYBGvfuh?=
 =?us-ascii?Q?dzfk5bVddfDRCR6lAftHXjwEtvJ7W6N83mHvNsk+0/Ax5ej2R9wHjdEBUmVD?=
 =?us-ascii?Q?NGTYF18z9o4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cNM8qSSrOBtKn+qSAGMLZZvzUmGe8l+0zOXDQkvvw/vbwe1fX9f/jRlKWrUB?=
 =?us-ascii?Q?tWaSNl9IGsYBQndqJS6Fx7G5j0227BfOT09QaEomdOUoe5FA7nh4xtgBJF6F?=
 =?us-ascii?Q?dAY9WUQbaiyup8X8ASyUw7l4z5xh8GDc3eNBTj+D7YpN5fM9v+oQtc6o5M6a?=
 =?us-ascii?Q?sXGtgN0D4PI+k25uxM9qj9QORJzRrN6nTtGmLo3WmCrFUNjcmfPy4+2MFbim?=
 =?us-ascii?Q?x8PvRzcMhm/GXV9XtN/iNB4AE2hkO/OZ0nEtupJsVfnArkUwngBgpp3tKpPp?=
 =?us-ascii?Q?4A2/u3ZXNiqTd4JGLFKYxxQUTGorLJRIBRGRueWg/3sUTsa+CL9rp4Ltm61U?=
 =?us-ascii?Q?YWZ2SNAssG+LqhBSxqhX5JV+Y++625d26VkVjQTl16vGvIegL6lHa6tMJtd0?=
 =?us-ascii?Q?IecouheIbZR/nHsgTQgLssYFpa68hF7mh74BGS4T3szsdf3OBnNRLlQyAqlN?=
 =?us-ascii?Q?HtJl/iBrYjkO27xtNJNSyqKDeKHeHjad5Hd/f5A3lYNZDa+twoN+j8qXqRh+?=
 =?us-ascii?Q?JEmcwp/T33Pj1RtzHOiKQKpLkNq6G8bzqSGuwamxkGs882vHdyRlyAkjWvXG?=
 =?us-ascii?Q?4diV9Xy+iCzI1E2QznScJIXAsHYiaUSRaP94zELQBvTTztWMVAKf1d6gq1oW?=
 =?us-ascii?Q?6YdpNpmlFiLnEWZE/VY3JT+vtQbJ98HXq3m3gHuIUcuSqgm6FOM66c6rPG1X?=
 =?us-ascii?Q?PPbKNAp8fxFo4YcfhYdi7veF/JXjPTr8VHcG3W0Dne12yMjbA7R81Fvoj3AN?=
 =?us-ascii?Q?QBAxR0uymqLS0rjgDtMcrk5OgGx5g16MHMv/d5TbLxvRmotO9uu2YkMMCCDX?=
 =?us-ascii?Q?NlDQWidK4QmUh0L3FUvKd9BAGNl14c/FWEz79qlCWauZHcOOPgSpYMz197Cz?=
 =?us-ascii?Q?8qLpsdW6XFrd/D/w7IN+BjAAas2K66OxS85LSv5BWh7P+JfNqmqErASFLdec?=
 =?us-ascii?Q?d5p4Yovlty9eXLKm5Jqx9j77jZhEWMAeQHnVvrjJT7YqIyAgO/fJqEOUX9JJ?=
 =?us-ascii?Q?v6Jq5pvSYyXrNfgxYNUyEr+HpUDu7XNuHfh0xVaMNArrHtkxGCwiICFaCU7s?=
 =?us-ascii?Q?2jtbuXVMwxEG+1OxDmbeDQGgYtOMJT9bNGFLv7hDoB1bPWcIwIP2ILrXUm4N?=
 =?us-ascii?Q?+A2Nz2DG9cGqRkZ4EZT9BWsc+r4pi8aoN9bkH4XWD2NkPqnjnsgvj77uOXDn?=
 =?us-ascii?Q?yj/cjeDYcd+r/fs27qxjVitzRnt1qgEurGHdDI+bzfrOJ7OZp4o6lLeHFIv5?=
 =?us-ascii?Q?hb/mVBe94OfRdQGk9K+AVfn5aZMIeTB31ONGnV4pbYZCdNC7JWSgK5PePze8?=
 =?us-ascii?Q?s/96UvrJ3IqTzSC1Gu9mts8KtxrC/i/zcsI3kRRA5hHbWLl2LWJdY4ovRxyG?=
 =?us-ascii?Q?6EEy/kOsrBUAIIlE2DfrZEgqIWRZbRwT87nRETsoX0jmZvUqpz5GIDpz5Vga?=
 =?us-ascii?Q?K2KPBVna4iIW7soKQtFmFCVoidBNcQ52zLVwcfS1WDKhVoeGeD8mTgJbOTD/?=
 =?us-ascii?Q?dQDUFY1cvPeOBu8VpQZC8Dib07BuKN6aAu9HrHXgfd27CB3HDL4yI49mvUD5?=
 =?us-ascii?Q?uuXKIRKoS024zZL8Gp5LUCzpG+xXMMb8ejbSui6y?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61023bcc-0c6e-4aaa-a61b-08ddd0d4c12a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 08:23:55.2080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4KVnzJa6YKXwP5JaCwmz4kOcJAxboFL/HeqclVhAY+9kk/fEYVvhL2rB6MkFuf/dHXy0QJJBFHV27P3V8fC45g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6890
X-OriginatorOrg: intel.com

On Tue, Jul 29, 2025 at 12:28:37AM +1200, Kai Huang wrote:
>On TDX platforms, dirty cacheline aliases with and without encryption
>bits can coexist, and the cpu can flush them back to memory in random
>order.  During kexec, the caches must be flushed before jumping to the
>new kernel otherwise the dirty cachelines could silently corrupt the
>memory used by the new kernel due to different encryption property.
>
>A percpu boolean is used to mark whether the cache of a given CPU may be
>in an incoherent state, and the kexec performs WBINVD on the CPUs with
>that boolean turned on.
>
>For TDX, only the TDX module or the TDX guests can generate dirty
>cachelines of TDX private memory, i.e., they are only generated when the
>kernel does a SEAMCALL.
>
>Set that boolean when the kernel does SEAMCALL so that kexec can flush
>the cache correctly.
>
>The kernel provides both the __seamcall*() assembly functions and the
>seamcall*() wrapper ones which additionally handle running out of
>entropy error in a loop.  Most of the SEAMCALLs are called using the
>seamcall*(), except TDH.VP.ENTER and TDH.PHYMEM.PAGE.RDMD which are
>called using __seamcall*() variant directly.
>
>To cover the two special cases, add a new helper do_seamcall() which
>only sets the percpu boolean and then calls the __seamcall*(), and
>change the special cases to use do_seamcall().  To cover all other
>SEAMCALLs, change seamcall*() to call do_seamcall().
>
>For the SEAMCALLs invoked via seamcall*(), they can be made from both
>task context and IRQ disabled context.  Given SEAMCALL is just a lengthy
>instruction (e.g., thousands of cycles) from kernel's point of view and
>preempt_{disable|enable}() is cheap compared to it, just unconditionally
>disable preemption during setting the boolean and making SEAMCALL.
>
>Signed-off-by: Kai Huang <kai.huang@intel.com>
>Tested-by: Farrah Chen <farrah.chen@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

One small question below,

<snip>

>+static __always_inline u64 do_seamcall(sc_func_t func, u64 fn,
>+				       struct tdx_module_args *args)
>+{
>+	lockdep_assert_preemption_disabled();
>+
>+	/*
>+	 * SEAMCALLs are made to the TDX module and can generate dirty
>+	 * cachelines of TDX private memory.  Mark cache state incoherent
>+	 * so that the cache can be flushed during kexec.
>+	 *
>+	 * This needs to be done before actually making the SEAMCALL,

...

>+	 * because kexec-ing CPU could send NMI to stop remote CPUs,
>+	 * in which case even disabling IRQ won't help here.
>+	 */
>+	this_cpu_write(cache_state_incoherent, true);

I'm not sure this write is guaranteed to occur before the SEAMCALL, as I don't
see any explicit barrier to prevent the compiler from reordering them. Do you
think this is an issue?

>+
>+	return func(fn, args);
>+}
>+

