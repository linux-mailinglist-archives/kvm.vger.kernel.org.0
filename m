Return-Path: <kvm+bounces-55023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ED1BAB2CB6E
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E91277B9DFF
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B8830DEAA;
	Tue, 19 Aug 2025 17:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y95SZlCQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C28B1D6DB5;
	Tue, 19 Aug 2025 17:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755625877; cv=fail; b=K1U+F1x//eo5u6ZRi5kSz5qpq+iYGwobHkL4jPir3biRFy2NNBD4TSG63qdObRXCtadMJZueQI7Vcr5E+C9BXGdLhVDWJighNf8dwaE6RWSXitEb0fOZmepVyhI9UTHqx0dTBshL1k9e+HV8suBBHzs1fe158Moq+sn4/CYVkT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755625877; c=relaxed/simple;
	bh=oGvhD2Xr9zV3cq2tizuSKLAkurL1Ip6Vr8HjlPvjGJU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OcoXuSFYAUaXhiNPH+B/cE3zSQCaWJbuGp81dX5r42tE5w2TmyRCMIKQP5myG8WmOXoCxwopQq6ID/eEzi52pte3IC2VZvvU1QzwV4I4VL/PyvC0xXQniO8iUMqZVJMeOlbmxo3mGsQVimERV2Aoczgq7CuZtJwWbHXTveDlzo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y95SZlCQ; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755625874; x=1787161874;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oGvhD2Xr9zV3cq2tizuSKLAkurL1Ip6Vr8HjlPvjGJU=;
  b=Y95SZlCQU5BTffA+Aw2QHLIHnl0GsTsThXQRVb/q4PRtgh07CSMMWFJJ
   JcxS7UZpN3Pobg51tRUO7upCScpuMC5BznoiOx/X6VQstWko71I7qs0lz
   fJjgh4vy/yO0365i05La6hib3LwjGM6+fThDkIRi3RXeTLpUjYUk3RrrM
   5T8EM8wD2J4loGh5UzAKeWr0D92sD3BWM7ATKBwL/6N1fd23ze42Lzrc3
   pq/jzdXqpxzsdoCgFNdy3xkSZilZqJppSLAl1Dij+DkHkj2ZAn1EaZnMJ
   dIU+zMcDevJT0YtjoxJoDT2NWwCGePH6yiY08Q+s8XheKvYmUFCP38smQ
   A==;
X-CSE-ConnectionGUID: oNab3AXkR56SsaC5Sjdutw==
X-CSE-MsgGUID: POw46ub8TFSLhQ91V9HMHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57808048"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57808048"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 10:51:13 -0700
X-CSE-ConnectionGUID: YuBhh2DrSkSFylFlhEikGw==
X-CSE-MsgGUID: kGDaw9wRQRaelrH5nxB/1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="198915216"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 10:51:13 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 10:51:12 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 10:51:12 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.61)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 10:51:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jfkzXaMsqO06h8z9aXXfNHvgXzwyODvjl1BL+vcbxkabpKuiIbJ5+ly6VPxNbdWDr75WUkFQPxBegFQAETWCn2gYezdzX56lNzRDwd0BfFjM3jiCy/YI2wKJdM/F667kGwF5XEnjo+KCF4oxky0YZnPUKPdI9+rHagv1AvqgoYoqM0edK1p2Ig7d+p7YuZkOjJQms7EuDE7QZflQcfaDjR41Y1dANXuGBkPp7jZISohn9bSiqJgvtNiWrQvGD1oR05+awMkp+4vtW7f46kopijRUIMe8yrpOMHwPWnJERjdjHp89dq3S1k5cb+USHhwOo6JW9ensAflH0JWTHv7iHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2Qfr7fdfseB94ulG5Cym4KViYCDPwBktiWJRqW7PCc=;
 b=lRxZxTKcVoLGQpk4GU2priCFlRyAjPrywLT/uZ/txBHLpptfLyixL0nkbSkDWkBkL9Ga7fEXQsb086bY9h/WCuDz4sjL8zrEBpU/vhutE6e1JzPVue9Z7iyN2ZTrLwkjFAdpaBqLrtKei+74H5jXwCls/TwzkWDQKa+Dy2cwU4TkOSHk50RcMrSKTvYSDyAQWmXM0lax8pVdaiK41T7eUvv6JHNqCFLRYpbVFUzJOJnq1cRId/bCcX1G4lrUlgYS0OS8wLrT+Dutpu7eqjz6drxNpYWtkwzsWtu20Z0Eo5GGycTtQM0YfhC4RlikO+upeZWO37wKBa5tqKeC2E7luw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB7505.namprd11.prod.outlook.com (2603:10b6:8:153::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 17:51:08 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.9031.014; Tue, 19 Aug 2025
 17:51:08 +0000
Date: Tue, 19 Aug 2025 10:51:07 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Yazen Ghannam <yazen.ghannam@amd.com>
CC: Adrian Hunter <adrian.hunter@intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vannapurve@google.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, <x86@kernel.org>, "H
 Peter Anvin" <hpa@zytor.com>, <linux-edac@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, Fan Du <fan.du@intel.com>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>
Subject: Re: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
Message-ID: <aKS5ixhgtCYIvErL@agluck-desk3>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
 <20250819172846.GA578379@yaz-khff2.amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250819172846.GA578379@yaz-khff2.amd.com>
X-ClientProxiedBy: SJ0PR13CA0194.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::19) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS0PR11MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a63d749-13bc-446b-f974-08dddf48fa4c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?zt70TtDeWCqzDX6alCrUjTIy0N40fiei6WCYsJd4rsFMxalnDA53yGCGEKXc?=
 =?us-ascii?Q?b3ey/4KE63tVii2ih0vv2kWIUaC7j0iYX+14kCl1efMO6Z+Vx69Ryc4fTChC?=
 =?us-ascii?Q?HLH1t3etHbuYXlS/s5gtCCLypBC6BWER5LxbuUID9BZLubAsvE78ERIGxdRN?=
 =?us-ascii?Q?+IR6jaPnZhh+kGkGKPo2oQNKs+w5Q7E3tq1A6UdSMl2uRuLztWrGMKgQISE/?=
 =?us-ascii?Q?Z2CsPtUxRcdOB8hazSvN9DjV5iEsoFHt4mmfH1raCLwGDGZ3FAhSxa0c/R0v?=
 =?us-ascii?Q?zFGPdgRNZNURDdloflXCCypSBjJrX8DZN72BlYAKdQsWLTgUqPLwv/nXwm88?=
 =?us-ascii?Q?FlP1ToFN1APWNJr1wjWoQYyrq6FepJDQ0gDK5O2gc0Pa2mRY/WPVxVRmmG+s?=
 =?us-ascii?Q?GRQYpaLoXk86GHZxv7PXYiLAYcTrxhaRnp7uQMJ4nvjheWVBa1zA06w5g6hL?=
 =?us-ascii?Q?AqGKNb1Z8JofjziDLV9n8x/SQkM6uUsuNyElH6YsaH/sfb34p8uQStG2aqqp?=
 =?us-ascii?Q?Nnnd0b9uqTeN0Ol9MHdGiHCQlienys5XGJraMsAYPpCvFqDp9tWh5XFFfMm+?=
 =?us-ascii?Q?8MlfSGDuTxPNyRbNYOciFd1pbjCkTzoIYlLSi+s9uzVdUnVICYu8awFj0r1z?=
 =?us-ascii?Q?PvHAoI1hVaonSDSRW3uUEuRlGXoIMEFWGALrA7YlVTBHyQJ3dyNYGPJj711o?=
 =?us-ascii?Q?C40ue12Vt9sOKDGyZOKkZ+CcIZhQpr4NeLf3uf3ZLfCWlUVvGkFIbe/O4fPP?=
 =?us-ascii?Q?ifRN+ix/eSGRdV0fWBRMTIENAffBRliVdYBVWFdicqLAc/RhTxxLlSFu8x8x?=
 =?us-ascii?Q?0nmd0S3tRb4K/QQ9dBog1aTDoJ9trAIVop62l9GvsPegUyz49Mwed1vXf5HR?=
 =?us-ascii?Q?YiIiDymVW3LQYDO08p9/a5Y2UgSsMRuE/olu8ukOJ5objpBOBN132lz8MXYc?=
 =?us-ascii?Q?dzgh0TozKXfiROPfM1rCuO7GsoNVuNFl7dK8IAitOGH4k8/ok5Lbh12QDF2+?=
 =?us-ascii?Q?OqwchFl7cnqq1c6AbZh2HQYynjUYlhx0T76F5HkI0W6kLjVimc92Ezxtq6zb?=
 =?us-ascii?Q?BBLHurRgr4bZuV/Pc9affjS8Gy5sus8BB0NbMBbYWK9VLIYxNoRQdo9LOzh3?=
 =?us-ascii?Q?pqdw4MPRsy3GFd31UFiGfvm4wEX9s9h9HaSZwLQfZCkBjDvsARja/HhjKXSo?=
 =?us-ascii?Q?PxcWt9V2t60Jws37RJvwnkDiKEVLqGfF/Z68UigAI/TnEJRju7wuYmVvn5db?=
 =?us-ascii?Q?Fv/KrCDCFnx2yPOxfyv0G9q8ticEgsDtuodNLf5Xy3jiPE7AZP1WFCLSkNa1?=
 =?us-ascii?Q?ISo7tAn/P6tudcoSy2qjwmCyOGC7FORMvi1C2JIfbC7XVMXQGnorrTJkjE4C?=
 =?us-ascii?Q?NgXKHs8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wmZMEktCUA06RYvmn2uQoOBA4i59hU1E1gOh6UkJIFsUrF9Ai2XvuXDLXTHz?=
 =?us-ascii?Q?r/HCTCpxgeATaTw3gZayMghrqTeIv0saR9aRUGe7IahjXlYMUmfjr41bnEyz?=
 =?us-ascii?Q?TDnrTu8YtEc7+w7MQMGMvVS/hID0WDBUiRkoCmxwxI2LJfBYKutMI3W7xQDe?=
 =?us-ascii?Q?LBEAUFsxk+duzTxCecj9NjnGtE8gx1jgPmehJsY4CZkUGA0YLnfuGNuqmBcv?=
 =?us-ascii?Q?NiE20ZXCzqk91SOUa+5P55/Q1RskV6fBxo87UJULps6zxsah8E7A7EaCwsjy?=
 =?us-ascii?Q?mwH8wnqU0u1o6/SZaDGUTdYBRnidmsPbZL73A1VgPkk7FrdzdC58K4EY5BFP?=
 =?us-ascii?Q?+C8EVXhBphmtFJKefzUH7pInnhAaVcKWPYwYCo4UjJbNxLhYzr7NEPiSof8S?=
 =?us-ascii?Q?kqW8H80LArSe1YvSBixYyHh90OIcHbAKyeqq52dqjmtp/feUrv7dGk4bBvXK?=
 =?us-ascii?Q?PWCoOQ5dqT9WjFbxwhxpN31imtvDNDxi/W5U/2/1J5YgpxvzaUaQTpSSY8oB?=
 =?us-ascii?Q?THQQwfzsdKN9ajSxr2Bcb29xgdg1mJV8O27Qb/bve0/bFsElHIjjA/WM88wX?=
 =?us-ascii?Q?mWEgu/mSU3W4kNnF2q+Brkszse7AlTIF2Z6pxRUO5xXThfqRhXsfplpYueM6?=
 =?us-ascii?Q?E1a2LXTF2ZCulXTyRSrE9IPiBs8wUJe4isjkkoJwyYtG1eVM5A6UD5Z+YXeR?=
 =?us-ascii?Q?QsEoEpIteFZUEu4NnhKhNZbUESEmXnynX1RTjMcs1Srg4FGFpqsxLplZEyya?=
 =?us-ascii?Q?Wvy+/OlKi0ennRsGWwDtPJb9K5gHKOr0uqhAc8n1+DfjYkl2/wUC6d6ngFsK?=
 =?us-ascii?Q?U9UDm7hOBC2cdp9qBlgdvRHVYMsqeMqmMq7QA051wmrg6VKTvYgDPcQoRAqX?=
 =?us-ascii?Q?2qvEDumEKSy0SDpe4Q7FdxyGY/XNE6TqmHzY/lCWf37+eTb3+FvG1qne6Nto?=
 =?us-ascii?Q?wNJPhGbaXfiEHrL1dDJI46XDnY/yTpjhqByaSVy9tN6+wzP9e3mPY7IkoK16?=
 =?us-ascii?Q?gPGnlK9lVpZCgO95ZCGrR30kRv9Rvv/CLw/hoXkBdhWn1HJeXictN6Kp/TyD?=
 =?us-ascii?Q?zPzmBMuwKa3RsibbPuYUlBnynh4Npozd7aRTm0Esxmp5+G7Jr3OyMtRLz/JS?=
 =?us-ascii?Q?1oT8KyIuPtaxx2n0rQsfJKH5mWTyNHeFSsPkbXHDojxida5VyAs1OmDJTfWW?=
 =?us-ascii?Q?hbxgf7AzfvBekgARts03kRTPNJrpJ+E8sIheWRL6ZqsmNdUE0ezEMR/DyIjS?=
 =?us-ascii?Q?pJFFljQ5Qdoo/78qu6X3nsTko22BjXgEvTHTLzlsHMQzRQkEJ+UQwjfKBxt6?=
 =?us-ascii?Q?G+g5q53vq1d7MuGySaAcfjY2oMGXbFxpCc81G/YY4V7jvBTvP/t9iaoKK1YI?=
 =?us-ascii?Q?T/hcqmMlXHhKE6rTxhNVcLaqdV4LMOncjQPYFU+ZaBwRuuQQ7tlsG80qr12R?=
 =?us-ascii?Q?dcewqK4A0UDkfntGQRLHMNqiYT2IHDau+Zw1sVIy5xWw5NDWXnyFwoeiL+PK?=
 =?us-ascii?Q?N2aE4TxdBT2kwGSfm0ckaOiDU3kOWkt1IEK64vH1jNTqpmmwgO5QZHbfaycF?=
 =?us-ascii?Q?pJfd+PuNpQempFl9C5bB4Di8n/Q7CMisU7EZw+cx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a63d749-13bc-446b-f974-08dddf48fa4c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 17:51:08.7743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XPDQVACfjhdzuxVN1fq/SLyBqJCOApJER9Qp5v40fbfFhxqAdEaNuPRQ0PbFSs2SLjYlgD29QBAsCrTh0lfySg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7505
X-OriginatorOrg: intel.com

On Tue, Aug 19, 2025 at 01:28:46PM -0400, Yazen Ghannam wrote:
> On Tue, Aug 19, 2025 at 07:24:34PM +0300, Adrian Hunter wrote:
> > Commit 8a01ec97dc066 ("x86/mce: Mask out non-address bits from machine
> > check bank") introduced a new #define MCI_ADDR_PHYSADDR for the mask of
> > valid physical address bits within the machine check bank address register.
> > 
> > This is particularly needed in the case of errors in TDX/SEAM non-root mode
> > because the reported address contains the TDX KeyID.  Refer to TDX and
> > TME-MK documentation for more information about KeyIDs.
> > 
> > Commit 7911f145de5fe ("x86/mce: Implement recovery for errors in TDX/SEAM
> > non-root mode") uses the address to mark the affected page as poisoned, but
> > omits to use the aforementioned mask.
> > 
> > Investigation of user space expectations has concluded it would be more
> > correct for the address to contain only address bits in the first place.
> > Refer https://lore.kernel.org/r/807ff02d-7af0-419d-8d14-a4d6c5d5420d@intel.com
> > 
> > Mask the address when it is read from the machine check bank address
> > register.  Do not use MCI_ADDR_PHYSADDR because that will be removed in a
> > later patch.
> > 
> > It is assumed __log_error() in arch/x86/kernel/cpu/mce/amd.c does not need
> > similar treatment.
> > 
> > Amend struct mce addr member description slightly to reflect that it is
> > not, and never has been, an exact copy of the bank's MCi_ADDR MSR.
> > 
> 
> I think it would be more accurate to say that the MCi_ADDR MSR is not,
> and never has been, guaranteed to be a system physical address.
> 
> We could introduce a new field that represents the system physical
> address, if one exists for the error type. This way we can operate on a
> value without assumption or additional checks. And we can keep the raw
> MCi_ADDR MSR value in case it is of value to debug folks or hardware
> designers. In my experience, they seem to appreciate having the full,
> unfiltered data. We don't give them that today, but we can work towards
> that goal.

Having and exact copy of MCi_ADDR might be useful. I recall some angst
about this code masking off low order bits:

		m->addr = mce_rdmsrq(mca_msr_reg(i, MCA_ADDR));

		/*
		 * Mask the reported address by the reported granularity.
		 */
		if (mca_cfg.ser && (m->status & MCI_STATUS_MISCV)) {
			u8 shift = MCI_MISC_ADDR_LSB(m->misc);
			m->addr >>= shift;
			m->addr <<= shift;
		}

this proposal masks some high order bits too.

I second Yazen's suggestion of a new field. One for the raw value,
another for the massaged phsical address derived from the MSR.

-Tony

