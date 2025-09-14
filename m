Return-Path: <kvm+bounces-57503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8379DB567D7
	for <lists+kvm@lfdr.de>; Sun, 14 Sep 2025 13:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BFFD17A6AA
	for <lists+kvm@lfdr.de>; Sun, 14 Sep 2025 11:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F292367BF;
	Sun, 14 Sep 2025 11:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m3D2QHNl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D938DF71
	for <kvm@vger.kernel.org>; Sun, 14 Sep 2025 11:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757847960; cv=fail; b=DESvBlFG+t43w2tTT9zYIXjs+9+E9kaQNsuvE+Kwm4Clpq7WEVtU9vCtfwJcA23blNE3jIkiJfX0r5R3DL2B5imjU71m6B2DU8MjING+LeVxZtOqVVc1GpS1DrXflaa7GTGHMk4BOSMbFswsyGNvCHfQ1W/EglDO9BMcn9G/L5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757847960; c=relaxed/simple;
	bh=VHFjTGXM2A6JgkDV6EikbGzTw39B88x4owYg7S3MJzI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kHpe1iBObFs3/u9eVzzkyC83UFvKJKtDmg3vduCgAwVruIwZNuClbTHvwAEzDc3pPViYqVhGLwhepGv+5WEw2jq7ggDgwFEqp1Y6zy4sgY1iEOlq1613q4cebJEn53bOXqY+Jjzqo1apYk5QnDzemasspD+cXXFgejsDoJ9jEDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m3D2QHNl; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757847958; x=1789383958;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VHFjTGXM2A6JgkDV6EikbGzTw39B88x4owYg7S3MJzI=;
  b=m3D2QHNlYR+j8m7Ix5LXr2NlZ38HFO9OjHSuorQxFfxZJHQFbKKgHf0I
   65n+RY699ONT2InI9Sfr5Z6t90Th/6sWH5ZIKy8sqfVd1YUd6vufh/0p0
   dS4Pa6TCmZMKTSUgr3TRBo3xxI1pY2pxv4lijtFruFSWkq596JBd8QQTy
   S21vOSto5elX5B/3ZSz8RidX5hAlYYp4HNj9P79Eh9NgnKzSWjieQ9Eoe
   7lJHKoceMQUiOjTGbWProm/z7xt7MRlUFqJmBeDraD7eBGHZ1e5j0co7O
   xMyCAOYCbP3kMT0mDCYwhmtpgV5/D8r3d0fg17/JzZmYEDU2Cmxp0RtSf
   Q==;
X-CSE-ConnectionGUID: ObZDeU4zSEmJH93mPwmzDQ==
X-CSE-MsgGUID: Qr3b1haHRUajSQmuOsJk3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11552"; a="59821687"
X-IronPort-AV: E=Sophos;i="6.18,264,1751266800"; 
   d="scan'208";a="59821687"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2025 04:05:57 -0700
X-CSE-ConnectionGUID: xcTwNfsAR9ak1Gum9gbiXA==
X-CSE-MsgGUID: 83+o3hYpSOCrNg4ZX2t3Eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,264,1751266800"; 
   d="scan'208";a="178735778"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2025 04:05:57 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 14 Sep 2025 04:05:56 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 14 Sep 2025 04:05:56 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.57)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 14 Sep 2025 04:05:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X4a/sPfaTOVwg8Xbj+S+yIyo1/4bVZ0/v0o+FkG6GtJ79FA6xn3wZ1gj+i3uIDqqHikavmedXQmuAEVkvulJBGUjqRyafpJ+W9C91BBFu19qeqh/cwbGUmOZXEw4g98X3DlVou3aYJObnmY06gxQ13WhwjEfj98Q35JdcKlvGE0MroTuSoJzLIBIELpJTk5otJ3or2n1GLN00dQopf5fDQroAumGMzUbh0u50QgcCoNQJZ6iVA/2hmC/eQoYrJ+VE+DAm3rW/OVCDaFvQMLbW+MDIFklI7VHKJKtE8QdBnqrFpoLAqziHMkfy2WdiWesF2Nnsz3Nt7kyqVLRwRTNoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDAj0/h9WPinBg8Q2SBZw6Y2+yZfdHg9MT3gdv23l4c=;
 b=aPjkVl4fUjqsccNbaYxy2a53oHr/rTsxj6Y1dV+P7yOH2ol/2ae06iaIJ1wSFrbW14CwQ7BNop1f3HWyP05Y+b+6bFgo6A/BNp2DLBMCSWlD8ehlFf5+/asQmTgXrQR29jX5hty7BaoAJmimmGNHUIDChuuVBiqClvj5qMm4DL24S+G2E4z7kA73GIq2pYNhc3NyKWTNnnvS+1p8JwuzAFxhE+PjlNzbkWgMieCPuIIFygfTd6I8zaC6LDOX0BnZGADEKXOC0dS70LHephVaR7giAm9rdAqwHKkuSak8Cwrhb1O3PH8oasvMK5QhwhHHeQFFsu10DjDbPgfhzi2fRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA2PR11MB5033.namprd11.prod.outlook.com (2603:10b6:806:115::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Sun, 14 Sep
 2025 11:05:50 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9115.017; Sun, 14 Sep 2025
 11:05:49 +0000
Date: Sun, 14 Sep 2025 19:05:34 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Mathias Krause <minipli@grsecurity.net>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v2 13/13] x86: Avoid top-most page for
 vmalloc on x86-64
Message-ID: <aMahfvF1r39Xq6zK@intel.com>
References: <20250626073459.12990-1-minipli@grsecurity.net>
 <20250626073459.12990-14-minipli@grsecurity.net>
 <aMQwQnGpNzutdr-q@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aMQwQnGpNzutdr-q@google.com>
X-ClientProxiedBy: SG2PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:54::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA2PR11MB5033:EE_
X-MS-Office365-Filtering-Correlation-Id: e0cb47d4-1e09-458d-624f-08ddf37ea9ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ih1eTOwZ1xT0kImxGOwwmLGKwzPFJV+RnWRAZXX5Xbsz2OCNRyu0di4ZLEef?=
 =?us-ascii?Q?mPyYyMOS1ZPQHuWlQ8mGEOl9gS3HKOoNyctG9FlhIgoulfv8912CSZAAbPMA?=
 =?us-ascii?Q?rWRMwhAxBMFD35AakN7fZV/mG/0z5uGWY/56Z2656eBpc9VrGRyBfOJBOIvZ?=
 =?us-ascii?Q?TgXolhmMy1rqc8u16b4sw7cYBDdWiygPQS/IKg4wQl9K7iKLqQGOeRVJXtQL?=
 =?us-ascii?Q?hwfsD/H1fZUfhKtQA6Nt3kANyUqSDOLisKTaT2ocMwW2/VCm6DMVLRG1MHTz?=
 =?us-ascii?Q?k3td92M43aD+cTRQ1o+cZzckQj98tgt7kGJx38csMWonb6ASNTyUExVWy15e?=
 =?us-ascii?Q?Ow95bEvvi90EXDWzUgaUYWn/wY+E0WP9pOBYJYI43jI0yKeMD6DmdTUPZpzl?=
 =?us-ascii?Q?4847SArSSb+eUF+bgYst/V7JI+3n94TMWMwFeO5YhraoQDCMbGXO1Z8fcnBt?=
 =?us-ascii?Q?f9KyOvgKRyGYlfKocWK/3YdKHA54Rq16jKj691B2sdD0ZV91cLAC6XxABQJq?=
 =?us-ascii?Q?vF3tofaq+LogBMzC4U/DC/MCxD1iaFwMCVK0Pdvh2rbG3OVDV5e5/+VLt47t?=
 =?us-ascii?Q?KVYeRHZpG9odHF/Gc/tR7sjcYmm5tw9umxfqHpwtxlNqVhAIdsZeoEE47WuR?=
 =?us-ascii?Q?Fh/2ZR9eI60fenYa5c2mb0Uo8LVmrNXBnBocEQfBPYH4S34+kng4IhFf2Qk+?=
 =?us-ascii?Q?fWu2sQqobM4WPtr1xWI4N3tDouLQ+hST/U6dLHqu88V7xNagkpCRFnNr3DI1?=
 =?us-ascii?Q?a2j1+OxmjAu825QNVMMKRvWCsrHT5iPDbRQgwUxjJ0K/ogEoqaEDmztmXapL?=
 =?us-ascii?Q?uFUhC5+TpFnnrZAASXnmwX0HnznHvp654GHQ2RcaH04Pr9hSwKbBA15rCHmQ?=
 =?us-ascii?Q?NGWZ5ArTceKVcB26MEDOVdrVYm4ZMoUTF50X8v/Slhc9Uu8hu6Uw6MI0zIzr?=
 =?us-ascii?Q?YbLErSLjlZUY3e5NHMVTL4heMvzNZfe22S1G5Ylr+oYzWphUMt/FJXQRSgdC?=
 =?us-ascii?Q?Yxpiwz6MLc+l/hBlIjKSuudP8eitBE5891co742eJuSo2I29xla9Qh+6ji5p?=
 =?us-ascii?Q?T39sG4WRCYUoTWEfCR9yxq6c0YK5o9IlP+KBLhrfFINRgBfKx5Y6QNFYxwQB?=
 =?us-ascii?Q?cpd3tzN8ZovLIsh/7vSoaD2QYpFSQOhboRxzijQwSyu70APjrUeBIFpqZ66b?=
 =?us-ascii?Q?I8FqBRHLOBvt6K7VInylud30h8pE+80iAtXRpGE2pYW5tMWP+MtmV8DizpBe?=
 =?us-ascii?Q?x2jBkxWgnoTgWEAWhjESd67zc+Zg7mnDiCPIL8xi/cnJKFDevHcLpd5FUjGq?=
 =?us-ascii?Q?55lZvR3Q6u08Zu5TtyMmcSqWPMkuqvFg5WUof23pxwgW1PvWsARGWHGCl5u6?=
 =?us-ascii?Q?HaiOIPJ8cgYKShegwD1DS+iTACvUR8hmBacvVIFgKdrLK0eZrQg6yZifHvlb?=
 =?us-ascii?Q?od7q+1hyUhg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gzSdwQ/4WAVKLlypU5eCbM0mJayGd3FmG83vSspU2HP+8BeL2Vb8s99Zmo7B?=
 =?us-ascii?Q?DOLkHZRAQntHUvaZa4eYqExV//x/+cuGYhe1c+7s856bFvnYI+OJnkmlE01p?=
 =?us-ascii?Q?3wgxafHzqwQZFHdRFz8JHEQUBuBS+ibe63qTbHBZPmQr+E8nyK07kTVHl8yX?=
 =?us-ascii?Q?yjPDG164ZhBfhuEYL0pYMaoLq8RcE40aTu3LnnfcikwIcjvKbmBq3751Dhdc?=
 =?us-ascii?Q?iTgShP+jLU+FTXd+0Sfl+EhYbL+lk8tnmXlqy3lWsnxZa0m59I0CUSFp9Pnv?=
 =?us-ascii?Q?lcIaP8hzF2UpViZZLWkFKtvycYPhx4np1Q2kQO+tFxUWZjH29gdUKKNbO1UE?=
 =?us-ascii?Q?DOZe1vp322/fFrD3VSZuxULCJYf8/YjprIOiHaWusz4s7HDiK5V7imrNIA3t?=
 =?us-ascii?Q?PVm4WO6OJduUskiUfpqWnZxxPzyn0qAzk2ykQPBljYp1AwS2jN0ZGB20JXCG?=
 =?us-ascii?Q?Q5K3zRe3g35G8YjqRD1N9XW0G363pmHNzHb+WtKHAKBoAcKn4mCwKm97oMjk?=
 =?us-ascii?Q?1D25ThPLR/HJxNe2Qdo2iCovc1D4Hk2RQ5AjmBee0ThtChR+H9PfOicrhtsC?=
 =?us-ascii?Q?22HahiF/KY2BPjQehn2uk7mSNSJ4MGMmdgRsbqYRBHxFwtdqCWCOqAdJ+XjF?=
 =?us-ascii?Q?QHSmZ++ss4bergl4IrmAPXQfM/Go/S6/OTvUsQMXNBDbyXDx3bgduM/02XvS?=
 =?us-ascii?Q?grHIVzPY6u6F/xuNOjqGJF+dgmSDH0ndF+3nEkwASsoGCkblSSYBrBQQyX0v?=
 =?us-ascii?Q?UfIxxLMHUaNMuU4rY6b24SUTBsXIcYCY79q6rPgh6vbeqIBzVeUzo/O+R18B?=
 =?us-ascii?Q?YnJDw8edTL0OGC8Eo3bs56xLwaZjWnRCrhTxhlyXjePCqSi1RnA66ANwyTxw?=
 =?us-ascii?Q?+vEZ7qCFTGB45BnHIkuOCuHtFIRNme+TB76jc0dr3nT06xu7vfzSDw6HsXZU?=
 =?us-ascii?Q?qn1hrasBqdDeZr+gFsZKnlomg1rVf+h0SlIyf0kdZq3PudwJpSGgPm/GowOZ?=
 =?us-ascii?Q?NVyLJfLG37i/xJyyCIm3CPDweMxjTk4XsJCfukVwr8aGoY5cGZh8TIysZSc8?=
 =?us-ascii?Q?p8Mte1Gl1diYhzxmN+6xJpGyyGUGvgqDEUhvZHEYd0vDnLmVJRL20XQl2rPR?=
 =?us-ascii?Q?IOiqGZGjTwqNMcbMHL9Nme1zaXHDgqAmFSmoDK4OOV+frRxprwQXASuttSF0?=
 =?us-ascii?Q?KZ+DZnPz3hJdJDvXJZfvvV6GIFfrYYTzISKExdFwQYeet1D1pnUye2SVyDzW?=
 =?us-ascii?Q?2d7/peSROphdYDB0qVQ4MDhkdUYcrU/Mv9cPGts5NV5aOfz0iw0gkDBPZAu1?=
 =?us-ascii?Q?/N+OfuRgOaDNRatQdzCkt6ves4MswQAT+IkG+fb8WIzFxVhkhxrqm5HWkJmg?=
 =?us-ascii?Q?WzCYonS3GDWC629ylxLDxBDHGReIiVqUI+I9ep8TFNcDZAWOoFQdjE0u/OFS?=
 =?us-ascii?Q?Ib3IcB79mhtf4xDDLfVqFCuZAWrxBNoaNgIMoURVPggaxahQqtX8T5QsKzhq?=
 =?us-ascii?Q?Ni1K7NI+xjQbF2GUmddR1H9oZajl4TE+0k0fiLMxGSZC7rVSp9F5U6RLekQN?=
 =?us-ascii?Q?FsfLoUYgcNz5RvSWfTg6M7ncCm6KcW8gKw5HxWAX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e0cb47d4-1e09-458d-624f-08ddf37ea9ae
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2025 11:05:49.9282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c3NiNjuNMyzOFTn4GWX8pdyh0oeno/sEdWFp1AdfqJJUHm/b6Tq//2xp5g5mQZUOco1XD1Yc1MtdIcNIpDxojg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5033
X-OriginatorOrg: intel.com

On Fri, Sep 12, 2025 at 07:37:54AM -0700, Sean Christopherson wrote:
>On Thu, Jun 26, 2025, Mathias Krause wrote:
>> The x86-64 implementation if setup_mmu() doesn't initialize 'vfree_top'
>> and leaves it at its zero-value. This isn't wrong per se, however, it
>> leads to odd configurations when the first vmalloc/vmap page gets
>> allocated. It'll be the very last page in the virtual address space --
>> which is an interesting corner case -- but its boundary will probably
>> wrap. It does so, for CET's shadow stack, at least, which loads the
>> shadow stack pointer with the base address of the mapped page plus its
>> size, i.e. 0xffffffff_fffff000 + 4096, which wraps to 0x0.
>> 
>> The CPU seems to handle such configurations just fine. However, it feels
>> odd to set the shadow stack pointer to "NULL".
>> 
>> To avoid the wrapping, ignore the top most page by initializing
>> 'vfree_top' to just one page below.
>> 
>> Reviewed-by: Chao Gao <chao.gao@intel.com>
>> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
>> ---
>> v2:
>> - change comment in x86/lam.c too
>> 
>>  lib/x86/vm.c |  2 ++
>>  x86/lam.c    | 10 +++++-----
>>  2 files changed, 7 insertions(+), 5 deletions(-)
>> 
>> diff --git a/lib/x86/vm.c b/lib/x86/vm.c
>> index 90f73fbb2dfd..27e7bb4004ef 100644
>> --- a/lib/x86/vm.c
>> +++ b/lib/x86/vm.c
>> @@ -191,6 +191,8 @@ void *setup_mmu(phys_addr_t end_of_memory, void *opt_mask)
>>          end_of_memory = (1ul << 32);  /* map mmio 1:1 */
>>  
>>      setup_mmu_range(cr3, 0, end_of_memory);
>> +    /* skip the last page for out-of-bound and wrap-around reasons */
>> +    init_alloc_vpage((void *)(~(PAGE_SIZE - 1)));
>
>This breaks the eventinj test (leads to SHUTDOWN).  I haven't spent any time
>trying to figure out why.

do_iret in eventinj.c is buggy. When crafting an IRET frame, it just sets
RFLAGS, CS and RIP properly, leaving SS and RSP as 0. So after IRET, RSP
becomes 0. Then, a nested NMI is injected right after IRET and accesses the
stack. If the stack (i.e., the page starts from 0xffffffff_fffff000) isn't
mapped, the NMI will cause TRIPLE FAULT.

The issue goes unnoticed because w/o this patch, the handle_irq()->malloc() at
the beginning of eventinj.c:main() allocates and maps the page 0xffffffff_fffff000

The issue can be fixed with below diff:

index 6fbb2d0f..945f7d11 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -132,7 +132,7 @@ static void nested_nmi_iret_isr(struct ex_regs *r)
 {
        printf("Nested NMI isr running rip=%lx\n", r->rip);

-       if (r->rip == iret_stack[-3])
+       if (r->rip == iret_stack[-4])
                test_count++;
 }

@@ -152,6 +152,7 @@ asm("do_iret:"
        "mov 8(%esp), %edx \n\t"        // virt_stack
 #endif
        "xchg %"R "dx, %"R "sp \n\t"    // point to new stack
+       "push"W" %"R "dx \n\t"
        "pushf"W" \n\t"
        "mov %cs, %ecx \n\t"
        "push"W" %"R "cx \n\t"

