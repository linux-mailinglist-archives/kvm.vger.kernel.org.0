Return-Path: <kvm+bounces-71838-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UNr4GJQKn2neYgQAu9opvQ
	(envelope-from <kvm+bounces-71838-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 15:43:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C0063198E1D
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 15:43:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CE3B93198A0E
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 14:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86E2E3D1CAE;
	Wed, 25 Feb 2026 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kysUCwyI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9180D27B32B;
	Wed, 25 Feb 2026 14:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772030341; cv=fail; b=JbpeobnnZz+18Ec2HKuRq4hqYVxbCehcTRdEdj7dGrm/jIIU3rInxJrlhL1vYwHJ/ACxXvM3b0DZldaayGpeub3Cn/cCl6IqNhp9GRbPd2IsGUIJII5FETaqIYPIa0KdLEfciWRrPDLpt7Wwwytw0timQyTshK8vfVIUDX1ZPKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772030341; c=relaxed/simple;
	bh=ZZJztolDx6lcOZMBmTT8gPRLm5nVCH8eX0Ofv5P9QJQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m3SgRNMsKOwGM85dbvLPoxt9mPj9hrskaNuJkA1brM35RD0tsy3n2OxJ73MDTzBALT6I+o0lBKiPNHC+OybdAmCgtI+fSEnJ4hrIxDE7gfsNy4eIA9XuGJKtzm/XpjL/ds7A9KB8JeCOdiRtpQDV9mTbLyRXj69bsv0HrcH35YM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kysUCwyI; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772030340; x=1803566340;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZZJztolDx6lcOZMBmTT8gPRLm5nVCH8eX0Ofv5P9QJQ=;
  b=kysUCwyIHNE+rxIFeYAJ+GuPoVjSPO5PXWhlGMHenQcfXB7aGQk6IwFg
   SuvDxQHCgr7HjjwP6m6+cXf+OmDjsZg1fpS8IC45aUR4kI3vHSmGgQLKU
   N09i7G48DVdKllPAzvtLExnqK3MGTZwwe2aSvlbm5DlZyczO/V2E/cyPU
   SCMSbjCbAMxstdP+9qi+a/sl0i9SUaAydMuH1tRwfvhASPZPxMSbXaje0
   bKGTGQ7wC4XVguy6puWBKNbRb1xXmRdI89/JhHH1Sz+YZ89lOu8iHYEe6
   w29cYJ90Jf6KJGVZ0Ud0G1GFzjQBTzaHso2pEUFyGK7ivNgw86/e/6WF5
   Q==;
X-CSE-ConnectionGUID: c53JDMEZQcy7yVR5MEIWHA==
X-CSE-MsgGUID: TCP1hABdRwi7yfS9kJGJrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="60641401"
X-IronPort-AV: E=Sophos;i="6.21,310,1763452800"; 
   d="scan'208";a="60641401"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 06:39:00 -0800
X-CSE-ConnectionGUID: UDy1iwAeREetid5fsLIfsA==
X-CSE-MsgGUID: 53tMxroeToeMWLxaHNz2Sg==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 06:38:59 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 06:38:59 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 25 Feb 2026 06:38:59 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.23) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 06:38:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xoH0a1FdfQ0bD9phHQUVDeRFJvl0xdxe5QNU7jry2B9JLsbt5xNBZq+CBYSWxxo68haTDHfDiG5Ylh7hz8blp5YJRDUHpmefiXZPQ7JcssUuKF5MxBP0Qvy+TFZ1wyQWlr3aY/LDnPEZIW57/tTeqx5d74zfSVptnbdf1Irid4uad8Ih/rI0JtJP+f7WKiACkTLFClwsEfJ0aUh0BmYQpPN1eGhHskHsppaW+wLqrU8wg2r3WlexPwxHwFesVLo5MnhCq/UaUcDbrwpAhXcmWWFcxTKex+Fh8go8AC+mVgg9GYCqnz2fURNOJI8ojhqrQrrg2yyUfV8mpDmT8EMSlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1c19VSnCvMAJbgZnPKYQ8Sgbde+0SeLZ+mu6RWTZrHE=;
 b=m6L4zA/O694cJ/7Jn2g91wcpvi5VGMzTN8FywqVhQtAYL48ruy1l8jyhMqYEOB+IBKiBA2tlbUgNN54glNstc6pJib1dc7fIMbgNI7MmrSf/AAdGOM5u1JUUrNyDetDtYhDllHvGRR1t9QJ7uycQ67ZvFH5cTtQa9s+I8BlTVj6YNkrhFOUhcAcXIxcwIYqmhrEKeXlhmNpqNxXLpsxD0ZrzzULe8q9W6N/XIsGPDYXtQRDze6jN7d0xXRg+QBixwW4ZvvJnEH4c1HoFR0fjc5tpU9e65nnGlJHq7nIHW4RYlsvfklJAAVaLeBIR/AFfdHdj+uceq0B51ESdzOVl5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB7137.namprd11.prod.outlook.com (2603:10b6:806:2a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 14:38:47 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 14:38:47 +0000
Date: Wed, 25 Feb 2026 22:38:37 +0800
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
Subject: Re: [PATCH v3 00/16] KVM: x86/tdx: Have TDX handle VMXON during
 bringup
Message-ID: <aZ8JbTZ5GXCnNNUt@intel.com>
References: <20260214012702.2368778-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
X-ClientProxiedBy: TP0P295CA0022.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:5::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB7137:EE_
X-MS-Office365-Filtering-Correlation-Id: 64036be6-2df0-4404-9dbd-08de747b958d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: K9A+KX90D5HfuwQHnJdh99fsJDqse3Ri7zcG+5nDPFo4DOIgYyBc6UpBaulVfKHYPpo0fotaxoWnpmmikIHkOUWzpG2Men2Cbo0kVEW3/SzxOBJxQaOMbdeodOCsoU7pM1xHa0iewuc4kpD1W49eJg5tBoS2QHgRu41RLNG30qXq7OgHb14uHRvEjTN/reuDyULgSb6zOJmQPYbh60cJlOpR4Zd6a5Lp1id7Rc4TTjZjfZLKLQeOiAuFY0Hqze1ch8mnVdeq8CBo2N4xTsGIK0oIXLM7pxIeDj/to8gZIaYeKg60WeQqyNy+Fvpa2/I805LFUR9VQ+N7tWgaexy3YPkQLyVF+94eeFTY4f054n8OfAxTj5rAeT6NFRkFBOhTLOaato1M9Bhssp0gqo2bxkcSkddxZf5t73PXIWT6Y0Zua5dWoVCFkAac3dH2T+RkrpdinmgjnRX1nK2n8ZDhdmt8Cb2SJ4lMlAcvUOFh1IiZoKZy69nI/g4Hz4xwcXbkiihl2MTt5EpSIeKKkqR2nB5ixe+HfVhVTeiVWc0GpgIR7eYeie2RcZ0va90AT+piApU0gpYZMsXjai1d/DnrW71s7TmRIWjG0CFEjXJoPTqI7TImQBTdLBYkjaUlxegqmUCL3rTSOaFJ1RnAuaQ27uSGdffAgz3/msgehPWaRh5YNMNpohOFhN8OpELdrLOw0YOOXx6KncSJJL2MGcB2LQl6J/z/kCxF3Zjm+OYUqhY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N+hNLcCOQ7RAdZPpLTcaRDLkDi8rslrf3qtpH/tMM2GYmr1lZdVRE4aklQwC?=
 =?us-ascii?Q?iGrVe3Ldv3pYgP4rKSlW+6AsG4jq4YVjmV95T4hANMNUuSaMIzQxI5+/sjNv?=
 =?us-ascii?Q?NzcHdPajsb7ut4igVwu7yUCxzyWzs5VhV9tiYpmw97TwKqY1lT4JG46t0JdL?=
 =?us-ascii?Q?80/GdNLY91HsDMyoXUtR51M+ry+bldDlgn9+BOS7FlGpDUhKrYNqZr8azY4Z?=
 =?us-ascii?Q?EGIZLl17F4bntT+9cIZzU2xxmMbqYD9XrMaEUhFWWb2QJ0TUTCkpr4T+9N6z?=
 =?us-ascii?Q?3xpOlIx8zHdzY4KyW2bsTfB7Gl5OPcKeIr0C1IuyfwH4U5PTYE15h9rCOBfX?=
 =?us-ascii?Q?rWWeQ2l/Wfswlkz9QXh9zmOguwnwcaJF5Qmvs5YRdZUzr5UWl0Ygwcm8L7Rt?=
 =?us-ascii?Q?WdvD5FPCyE/VST/7Xitm/JWLWlvYOUJb2SyMVmWgDdsyvVSxU4nJReS+Rc5M?=
 =?us-ascii?Q?/2YzPFZ+BnQFe5Zs/j2crRB1YDRXdRr7K+KGPS8P9qg1TNJLmw9rEM+ybUc6?=
 =?us-ascii?Q?PKFDk088+U96Ip34I4lKfpabSTF1IvgWW/3UYrSs2QXjLXDuIAMCr6AiSlR+?=
 =?us-ascii?Q?5kb9VBAojVtRpTsb22EWh+a7olVL6UnlKhjLJlSbilUfZZMQfEJ3hWAGn9zA?=
 =?us-ascii?Q?rW4CV7QWHG3srt8l9delK+2Xd2sBGdboF8sQjZMrR2e1mEMvRGPuJFnbg6F3?=
 =?us-ascii?Q?bz9fZnw+UNmPdSNp8TgnhVgGV7v9mamaT/f602csi5KWeh9/zoSjdr5QZREx?=
 =?us-ascii?Q?0vzk+wnXW8kY7mjFmKQHLjQIxZ2PITpRntZ29bSDL7YQsKS2BkgNDz48Y8gl?=
 =?us-ascii?Q?DYb4X+hA34FoD1OmJqhngZmEMCj0CqTcY90puoLckdPZ2IwjFhf/WF/7PNR/?=
 =?us-ascii?Q?mg0h5lY00pbLuSjqqUGUsNJLfQMUNJkhuLDLWLXT91qe//mrXPSxjwrIwxw7?=
 =?us-ascii?Q?py9pNODYEKq+6m9q1q8fe4N5En5Bz1THmG7U6tMzs1BkYsIWkU1eQJxZkMyV?=
 =?us-ascii?Q?U1SFYRTtNVsGGemknLvx+fjCh7ceXTxFDM98HZR0XNi9koGja61kxMwWId6P?=
 =?us-ascii?Q?lfUftsI1CZom6ysMO4SDdXo/eSQy4bBXDiVQ71C8ohJK/r6rHZLlQ/z9EpWe?=
 =?us-ascii?Q?j/8H67KZMD9rtolTuqLMOi2lzDgCLLLx1kv7FjKFDP8y43tKDu8XwMhPqCme?=
 =?us-ascii?Q?JbnWFsjPoXqi//hu5fodJKfPIsegv2g0tVdbGsq/bqmYSWOxZxV5sUx2pRlC?=
 =?us-ascii?Q?RdVUKQ9oxkg3zQodjHIoV5LI4pFx0MrYOZal5wZH8qpIBwwsIhnxhbL5MO06?=
 =?us-ascii?Q?FPEo6768MGDBjdvUUYYuyNw4NSRFPmHjeRnL0gZ5jLJcdQqtkewHJGTqgCvd?=
 =?us-ascii?Q?KfelXAfrdAMvOifZwcWbx5grYsWbFukQNDF0Atl5UpnAZBITHoZ6Xr+5Em9p?=
 =?us-ascii?Q?zYhGquP/+1WWLNtnmYWHmTzCVjF6bpjs0GL24tSB3oq3MOHb5TQtPLLKZpR3?=
 =?us-ascii?Q?tlIwXL5PWtO6/GN12VFXfPozfc8bby1BXpBV0zubb6heaC+Dl+QeSQqmm5oM?=
 =?us-ascii?Q?FqpqavewCMx1om02eR7BpWncXnqyV2WCgXvEcacrpYoh9IjWckO2jnhhFkjK?=
 =?us-ascii?Q?mdzkiUN1IgY8KWzO8s9RbUWDQJBA6yLey2kJNedhfMlApPx1z5wjjNuN3Ky6?=
 =?us-ascii?Q?sqzRGb834GtLX08jvNKpvH+PbbsyapbcRk2Xbp/BIP0I630SooAM9411ZHxl?=
 =?us-ascii?Q?EQhjU78o6Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 64036be6-2df0-4404-9dbd-08de747b958d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 14:38:47.6551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EpQGLNCCoNzcTFfqKQyddOKJiUzwgmXRy64IdDU3b3OX/mBwF2gl6PMNHB8ITpNq7vFKTfSn09wsjWoVHoS5vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7137
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71838-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:email];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: C0063198E1D
X-Rspamd-Action: no action

On Fri, Feb 13, 2026 at 05:26:46PM -0800, Sean Christopherson wrote:
>Assuming I didn't break anything between v2 and v3, I think this is ready to
>rip.  Given the scope of the KVM changes, and that they extend outside of x86,
>my preference is to take this through the KVM tree.  But a stable topic branch
>in tip would work too, though I think we'd want it sooner than later so that
>it can be used as a base. 
>
>Chao, I deliberately omitted your Tested-by, as I shuffled things around enough
>while splitting up the main patch that I'm not 100% positive I didn't regress
>anything relative to v2.

I tested CPU hotplug/unplug, kvm-intel.ko loading/reloading, TD launches, and
loading kvm-intel.ko with tdx=1 when the TDX Module wasn't loaded. No issues
were found with this v3.

Tested-by: Chao Gao <chao.gao@intel.com>

