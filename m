Return-Path: <kvm+bounces-71945-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gE8KK3ALoGnbfQQAu9opvQ
	(envelope-from <kvm+bounces-71945-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:59:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5593E1A305D
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:59:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EB14C3070BE9
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E281C399020;
	Thu, 26 Feb 2026 08:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pyi7IbRR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B533C396D2C;
	Thu, 26 Feb 2026 08:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772096196; cv=fail; b=swN2w3SifSnpML+rqCnYCytNJeadnlG7KdhPDdmu1aDK7CzhBRpc7rWv2AFpDOEphKUWaoMaXtmu0GMddwq6YrxDYhn6kwb+9sIsBkRLOerkg5t58STGCraL7O35pRTSV84rIOIkOh8CuNHkHhjDKkYiWOfRJ0m7cgyVJQh7QrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772096196; c=relaxed/simple;
	bh=EdtHAAblgZZFmDu0ci2cfNyzDiAvjflyM/bu7elOdIw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R2qGajT7jx/fKUHa3a5VV6EsyosdHeigJWDphf/ZOc/6kDZmtups0LLJxIex9FK02iX6IAewsQMYnSQVXQZaP/zp/8mHDXmx/svVvJvr1c1rwFnyX8Sdoemta8yhiYw910x4wsS5BTAD4gdtAiUVUfkhRtLZUpee8Fh7MO6EMfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pyi7IbRR; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772096195; x=1803632195;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EdtHAAblgZZFmDu0ci2cfNyzDiAvjflyM/bu7elOdIw=;
  b=Pyi7IbRROooFFRpFNJozka+GPM8Jn185rCtB4qXIyKenDw91Tv+IfBhp
   gm4qSkv7KKfpf86PFcihnZ51vt05yrS6QwqFkZz0OAbv0INnVD1AyF+Fe
   fR+xVGf+xWZvKrqyyqcZrFaWvXJetYqNaORlsD9NRK+3Y3o57CLLzQ4Kg
   DgJZJYWKbbIQPxmb2ppMX7mtcDDmypUjnKaEJAWjGwVbonqajDkNGQ1cq
   HpBs38+TI802H+l+xmWX7hFYnraTK95mYpL758lfwsXJbwVvf7DLrtFvP
   7UygxTyuKtTJ1cjqY6K0gvx73h989iqSrZGApMaEOUTZC5/157HfyGFs3
   w==;
X-CSE-ConnectionGUID: AF7C00abS1uFB8KY0TYwEg==
X-CSE-MsgGUID: A6zhMv5vS7edYw0sGOioUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="73023732"
X-IronPort-AV: E=Sophos;i="6.21,312,1763452800"; 
   d="scan'208";a="73023732"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 00:56:31 -0800
X-CSE-ConnectionGUID: PAXtDzZ5Qtib4H2WlhFV+w==
X-CSE-MsgGUID: Pzk9mGUyTMSdIwe5MmFKLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,312,1763452800"; 
   d="scan'208";a="239498313"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 00:56:30 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Feb 2026 00:56:30 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 26 Feb 2026 00:56:30 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.52) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Feb 2026 00:56:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pcgcPrwsW5961veRrJceaK0tp3AVdxSlbLBLbaJ9eUrlEQ0LGrUPBR/t2OjXt+L87+C24km2qXp3ewa2xi+Y8sFY3tuP3+ZLnH6MYyN0plibjAKxOVdudXl1M0hK5ns4h9Br/f3w/hNII9IwhhtB/s/ZKz+etbz5WwZ502Sp7zlSfedaEU5a07AZ/pnQcOOCujcxaUoHE0r1V1ePWVvwdychW4d5yCLJ72yvLtlSlCm3ttQxSHAMkeYSp5m7Ire28AqTNSBvZGPY5FdbaM7esUJTYCiZpDO+OU3bIdkplQeAkP646hU3WKqNRWLkUumBd7/xqWsG40fFxGE87rtktg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Uc99xcn5lDEynUTgCciC7nq5eTD7z1Gbso11nAjZ6A=;
 b=p5CHji9KacxXpk4T7gqTP7KhKEHt3qtiFRRmXeCZ4pg7B7wjRS7+EG9QN4iO76kVvJcNd5SyFDxzt+1pSjwFLswCFi9qSMX5GR33biNd+LELFfdp2p5etfo2e5zq8B5Iazn5+bCoBfKDzU+jT5ULFAfjSejFUv18cM/VM3YjwPRwsRW9qtYYeDlMteN43LLBlNDRwF+ZxW1PHIzfxKpQWcWEceOJg7tFCUYYhlQpS0DPtvMnfl/o7KXzCJrkyrGxeBsVUyZJeBYXrv3lBDZk3LQ3fgvgkME4Ae7bLBnyXzib0+USQhE4zS7fu4dLX9tSNOV3XBzj0Slh1fAOvl4HtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS7PR11MB9452.namprd11.prod.outlook.com (2603:10b6:8:263::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Thu, 26 Feb
 2026 08:56:05 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 08:56:05 +0000
Date: Thu, 26 Feb 2026 16:55:53 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, "Namhyung
 Kim" <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>, Xu Yilun
	<yilun.xu@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 08/16] KVM: x86: Move bulk of emergency virtualizaton
 logic to virt subsystem
Message-ID: <aaAKmdrKMjKFKM43@intel.com>
References: <20260214012702.2368778-1-seanjc@google.com>
 <20260214012702.2368778-9-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260214012702.2368778-9-seanjc@google.com>
X-ClientProxiedBy: KU1PR03CA0042.apcprd03.prod.outlook.com
 (2603:1096:802:19::30) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS7PR11MB9452:EE_
X-MS-Office365-Filtering-Correlation-Id: 943bfdfe-3eba-4e10-fbd3-08de7514e058
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: NCnoWPpEOyaCTEsB4l7h1Oez024FxAv0iZGoqhqiHXoZlPSc1m5hSMohWe3IFwgTnKl6AA+gTp4Vu3UmcSSNM8vh9h7qgYWCbt8hcgZOKhPlHlscxII3gVArtyeaA+sUKCN1N3qR12sizFq8CfUQvOYI7zzetlu2hM2r6JqrVx1swB+JlQ9T1tebW8hMDfaAY9k403PWV2DzjM1NJ/r52oU9h018AmtFcT5YgMjOzszf54/lhJKhNkRl29Fd3rjuxpXocciasf0vc/eW6Rs4bRnxlHRQqSVefZ6wPj7EDn8+Wkm1hBipCAEPXaasBU3rhbd18BgC5bB6IFvlRMVifahL1iJ2tHrOiYaDpMI85RQfOyHXmbaZcuj6Txu19khQPf/4TeWz3fE+R8G0DLFvKoWeta5EMT0b/U2l3TbD+r7XJ/ZJb958gFiuuj2j8WV++ayqmENPSgiijIFv6hLRaXDAUztLexkuwQR4la13awXw3PzFjYiHPzMlLXlo93MCKbbWS8Fq4Ek5MeqjMszAbM60vazcJgKiA+KYzQtCkOS9xriDIw1m+UT9sG3OdWExk/lt/adXfwRvuYB/FvLpzVceEzxWtIN7uUj+5ZOytT00Sad5dOJ+dkQ3cKyeqEy+ktLBmCpEq1+5Dz9CRDl4Kcy8TfIn9VHpYT8GH/0OCJ6RqsYSfMwp9FmE9ML3ddZqRT50mMxqQPT+tJaQfdm/Q3w0m1wWwfu5xbgvNZIU0rw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q7j8fd+ANp6PSjDejd9u3gSHIz4RezbUE/ys8MOUbUvlQmy8fizAyXCmGpqU?=
 =?us-ascii?Q?DdMp4Y/Z+TBdkZu5RUSz84K8NxwVCwoORpkLLtIe8+CqpYyPSSA5Y3r4wKBk?=
 =?us-ascii?Q?ewc9Wryg8WyeQtVhp22PDNpAA1O+IrmXnzbqiN/JDBYnb8tVqs0xIBlMC20X?=
 =?us-ascii?Q?/3cyPE5h4cpBoBglQLBlkfWTX/yODxGGAkQoGurpkcZPenIasYDf0ue3qi5j?=
 =?us-ascii?Q?scBfuC0TCsTkAvh3ZA4B/j1JQAwnYEWFoVok7GFJUDv9wDxCFkq35qziDkNm?=
 =?us-ascii?Q?FwnzSxn9G6FupQrb1aCtLmT727dI64BZsVFvITBKvLMe+VCJ3scizEh8Ox5D?=
 =?us-ascii?Q?4U348tkajhuZ64fhNV/QVIa5STCA8rBdLD7yB2TvfGkrme/L0HeCLJA8HeAu?=
 =?us-ascii?Q?K8ggB5e+BwRR9pHHZmIgQhI3VrVJ3+VQy0CugoNPiXbl/T1RbW71lchU5Hu7?=
 =?us-ascii?Q?X6yqC9CYnSHh1yFQHVvgUA5S0b/NhPciID0HM+P+oQhZ5dSxTo9wAgpCHRal?=
 =?us-ascii?Q?X2GF1aws/gNFpW4T7k/UC17U/WXsxi6+Qck8ZWVlBSPg2FHF3O5CqbS+ZNaO?=
 =?us-ascii?Q?Q34PQoBDAddyTvcAkfg7D1kbNOSBzviWpvHCFBJaTnKSSr2xdefeWFI8bTH+?=
 =?us-ascii?Q?7FzCY0rC30LBUac7QHKLAT7LyHjghCtI5pHgyrl21bfgCD3Ypyw5ORszQB90?=
 =?us-ascii?Q?cwLNeDC8T0BHHD/bVlw9wr8QPcOSbxGq8L7/h4mp/V2a4XOQ8mRvv+zMEdTe?=
 =?us-ascii?Q?JJ+yT2OqYd2jIerueXHFt0vh7e43DZDnQhA1uYnG6RKrtfFxtK0AM3IbfUl4?=
 =?us-ascii?Q?PuO67K7FFCy1oHDeh1cj5z3MwG5VnzEcW0wC4fYj3tJhU67j11arsHqoWeQC?=
 =?us-ascii?Q?IuGmZvN5ftfJ9Erv+aBHNFjZdHM/YGOLCp/o0GaJe8rpQNHhhOO6q12mi67X?=
 =?us-ascii?Q?YOVJFU17+tGwnKFPm2aoZm8yS/V30jXVkoLQsNWBWccQ5S6jdMb6WZfGr8Oi?=
 =?us-ascii?Q?tR9DNC0LwsfypCSznJzhKeHQigf0K+k4pmNJRGeIyjNofX3ML5mhFHgVs+g5?=
 =?us-ascii?Q?yMams/KulbV333+fb7CtM/w+qHxZ+zpm3RVtODBnwork39+L6Ai6bzadoDKX?=
 =?us-ascii?Q?tAGI7MAq1YPzgcPdWVXWFp4kiCtBAMyykTWbkF/sKCHuHjZ3fN4j/HI0C//7?=
 =?us-ascii?Q?2kPppI8usfjB9iFFLLiEX8png5ilHN1GmzClqIbgEQlMeGLfiAOdXVQDCUsU?=
 =?us-ascii?Q?02ki9fU8jNl76gH6NOnjKbGQF9sNfVVt8krikFsnsHfGmwWpj5QFSTcZPM8B?=
 =?us-ascii?Q?6swibcK30XjiMrnw13hu9PQnQ+8oQC3UajgBPAl95PVP7C4xFTmnmftl4YBe?=
 =?us-ascii?Q?8FyxTXTU36Keg3X5i1+4p7WlfOLeFAeD/pDRWoMKHEuXkdXB77roaxSWdfst?=
 =?us-ascii?Q?xJb68VBoEwVHc6USvFAE341QcSSwBFSrZEM+U+wX7PH5oumAZ9m/WzmlsLYS?=
 =?us-ascii?Q?ex+5LoYDyevTczaTg9Q9SOrb8eCiMoQxPY7uIblINVnyzJXGWSC7DH2P3yLM?=
 =?us-ascii?Q?W0/p4UBHwuewnSIWTfhHkomPoaewkGfVESELJYOtGHu0PdStUwtHH1weMWV6?=
 =?us-ascii?Q?ollFdR6YcRx5YN3h4E1cjcQ/zPSzcHNtp+kZ0XjzLYsPHz9g2cJipV/ysQcp?=
 =?us-ascii?Q?Jpb02xSoHdpHKMI6JRro7jd3bePultHN5oB9kgb250z4N+GMzaXfIhP0DxBt?=
 =?us-ascii?Q?bgqmPr+vJQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 943bfdfe-3eba-4e10-fbd3-08de7514e058
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 08:56:05.7907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IEhLyq8RkaIPPc1ipTZV0DD/cxcm3Sx+pkJ37pt2NzjzvrZMlLDmUt/uVkp3jm3rRF9BtXM/TQsd+rGMgpOEaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB9452
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71945-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,intel.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 5593E1A305D
X-Rspamd-Action: no action

On Fri, Feb 13, 2026 at 05:26:54PM -0800, Sean Christopherson wrote:
>Move the majority of the code related to disabling hardware virtualization
>in emergency from KVM into the virt subsystem so that virt can take full
>ownership of the state of SVM/VMX.  This will allow refcounting usage of
>SVM/VMX so that KVM and the TDX subsystem can enable VMX without stomping
>on each other.
>
>To route the emergency callback to the "right" vendor code, add to avoid

							     ^^^ and

>-void cpu_emergency_disable_virtualization(void)
>-{
>-	cpu_emergency_virt_cb *callback;
>-
>-	/*
>-	 * IRQs must be disabled as KVM enables virtualization in hardware via
>-	 * function call IPIs, i.e. IRQs need to be disabled to guarantee
>-	 * virtualization stays disabled.
>-	 */
>-	lockdep_assert_irqs_disabled();
>-
>-	rcu_read_lock();
>-	callback = rcu_dereference(cpu_emergency_virt_callback);
>-	if (callback)
>-		callback();
>-	rcu_read_unlock();

...

>+static void x86_virt_invoke_kvm_emergency_callback(void)
>+{
>+	cpu_emergency_virt_cb *kvm_callback;
>+
>+	kvm_callback = rcu_dereference(kvm_emergency_callback);
>+	if (kvm_callback)
>+		kvm_callback();

The RCU lock is dropped here. I assume this is intentional since the function
is only called with IRQs disabled, in which case the RCU lock isn't needed.

<snip>

>+int x86_virt_emergency_disable_virtualization_cpu(void)
>+{
>+	/* Ensure the !feature check can't get false positives. */
>+	BUILD_BUG_ON(!X86_FEATURE_SVM || !X86_FEATURE_VMX);
>+
>+	if (!virt_ops.feature)
>+		return -EOPNOTSUPP;
>+
>+	/*
>+	 * IRQs must be disabled as virtualization is enabled in hardware via
>+	 * function call IPIs, i.e. IRQs need to be disabled to guarantee
>+	 * virtualization stays disabled.
>+	 */

The comment is stale. Since this patch just moves the comment, it should be
fine to keep it as-is and fix it in a separate series.

>+	lockdep_assert_irqs_disabled();
>+
>+	/*
>+	 * Do the NMI shootdown even if virtualization is off on _this_ CPU, as
>+	 * other CPUs may have virtualization enabled.
>+	 *
>+	 * TODO: Track whether or not virtualization might be enabled on other
>+	 *	 CPUs?  May not be worth avoiding the NMI shootdown...
>+	 */
>+	virt_ops.emergency_disable_virtualization_cpu();
>+	return 0;
>+}
>+
> void __init x86_virt_init(void)
> {
>-	x86_vmx_init();
>+	/*
>+	 * Attempt to initialize both SVM and VMX, and simply use whichever one
>+	 * is present.  Rsefuse to enable/use SVM or VMX if both are somehow

			^^^^^^^ Refuse

LGTM aside from the two typos above.

Reviewed-by: Chao Gao <chao.gao@intel.com>

