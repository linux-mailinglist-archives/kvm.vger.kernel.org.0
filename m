Return-Path: <kvm+bounces-67708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 66AC9D119CC
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 10:50:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 249B130AE2E2
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 09:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D688F34B41C;
	Mon, 12 Jan 2026 09:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WeL0XxMo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E36834B1B2;
	Mon, 12 Jan 2026 09:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768210948; cv=fail; b=i3JEHYmMaSwjez/eYnJNDnLubGOFzI5T3Mo9hcyzsbyvfYpPossRYe2brhalPv1SeyNkDzrBbpxcR29d3IO/D0owF+dep9HmaM6zA9W5jhmEUv/sQmG028K80ZknXA9vUNIvFFM5Okdvzz318dkxa3GjDVK8x7tV1wspXIDgkZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768210948; c=relaxed/simple;
	bh=2Z+NEpSuyzSdWBsA87Bn7i395z6FNttSxtvyHCHw2sg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cSSB4PcRr4VJIz8+AwXzsweP+qFTtpjZtf3TPfc9qY7z2iPxQKP3A1AKZFY0L0Z+5oEBIaQD7ca6lK5HxsU62eviudGpGK0T67SPXPMUVQZvFZOgR/uVcCOKDKGqLw8Bm6ZFIdUQn9gs5B8m8vKsgMWyped+6/e8P2ljYQbxBo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WeL0XxMo; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768210947; x=1799746947;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=2Z+NEpSuyzSdWBsA87Bn7i395z6FNttSxtvyHCHw2sg=;
  b=WeL0XxMopVH4EhyICh6A/DyxsxQewAy9OM6JuEQVk8oWal9wNeoOr/Vv
   eHgti3ii8IrWmW3TacDUupMW5OBqdNaJqn+puivEL8CY080pM+gKSQ7id
   QSR38IiyziJIDsG0xHkQgI16Xq495psg0j+asm29kPt+IhNh4b8wTAtWv
   +F9B4GH1BFfjeqAth90lfthyA1itj3fvMZ5AY2un1ad435fAU7/LxtfnW
   ksmq5sthNRFaWTkM6Zz6vb32dH/h0Az4PWrtTZJDWaKzQzEhGCcDJ7yAS
   8Y+KLigkVzBUsmRKms5jNbV0aRKpDuoO+zyNqiJZ7yJfZMu0tnRKCP48X
   w==;
X-CSE-ConnectionGUID: aRtoNAmzRGuS5MP5MGQtog==
X-CSE-MsgGUID: wuJK/g14ThigXD02ldwhSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="80848347"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="80848347"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 01:42:27 -0800
X-CSE-ConnectionGUID: o+yPJDpkQjSif+k3ZzkenQ==
X-CSE-MsgGUID: cUFsp6dTSJmQT7w17gTRvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="204328691"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 01:42:27 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 01:42:26 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 01:42:26 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.25) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 01:42:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r1FTywgmJJBP2cpaNgye+qoBZ46XmLq2z/wV2qlN9ZXZpdQrujktMh2zsEOpJmhFlxBRSqbexc5GmFda2cuIIGZ84/Uu2CXZpaxNWEm/EwsEhbA2iMH263ulomjBZfT/UttKcEpZ2pa4P//WXpdWuHo8npDdZCfH2E6MPbBGfzO+p/f7BD3vzUQu/DQUoOqq27EZ8iXLaTQnleQmmzglbI+mLbpn6vrKUNld+vCCvBKHWLQ/LYmfRL6nIliE/UUyKHr54+BjoQ3LCoDLWPPenrHxuAPFNahD0zlpd9b8ikmPkCOpaeqWSuUX2gaarjf142aTjaDF0OfEJwHrSGCi2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8oYpTCB32W38JZO/ckhbaZJ+EuzJDlJstGkmv8313I=;
 b=Sc1MVZX4wfuilPaZaCkNxyt1YbegQ3e66Wyzmkd+SYoQYMdn6TTu8GOe450/nZXQFfS+/poayj7PpKGZaCEegydvfskwQR0WBnAt+eUKNAPR4H0gRpdZ8Wib6irpnMHCRZF2l1qHExB0UmP3K3Gtsnk+tn7cAawMgkWNvgxCMHQTUQjiOjKhn/YKERhqKInIn29wHeUdKONdkSLSuRZsELzDfHwP4FMsuw6VqCCga4Hxmm190vw1UdH6t6n/k8/oQ+qXB2E16yXXuQlPYktMvYTGfcpXvj0AtnZ5bzlqbz+Sahjfpu4MUqx111Nmm2vyy9WsS0JfNHNYyOiZugceMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA4PR11MB8914.namprd11.prod.outlook.com (2603:10b6:208:56b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 09:42:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 09:42:23 +0000
Date: Mon, 12 Jan 2026 17:40:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <pankaj.gupta@amd.com>, Kai Huang
	<kai.huang@intel.com>
Subject: Re: [PATCH v3 5/6] KVM: TDX: Document alignment requirements for
 KVM_TDX_INIT_MEM_REGION
Message-ID: <aWTBfjVEHE5HC5gn@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260108214622.1084057-1-michael.roth@amd.com>
 <20260108214622.1084057-6-michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260108214622.1084057-6-michael.roth@amd.com>
X-ClientProxiedBy: SI1PR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA4PR11MB8914:EE_
X-MS-Office365-Filtering-Correlation-Id: 1929acf2-6007-4dba-3015-08de51bee37e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?B/PMO5HLxVMWH2WGir7M27bmNSaWi2r6iSwzsiLMzeHXHYeRC4V8X1/6BGHe?=
 =?us-ascii?Q?tT3LKFh+2VL0+QbqnS01tA3N0OhIkAtRVeWgH/t33OHp6A35AIGM68e5R3kt?=
 =?us-ascii?Q?OHI7V3Q82YWW3QGm178QuYORzPYhOvSZByh9Rr6nJGegp9itch0m/C8Hta3H?=
 =?us-ascii?Q?Qc4zhejfBVI5wR9uzRe5ocCkdcBmP46V71pYkAl6wrc71xnlLfrmNhns16pv?=
 =?us-ascii?Q?j65s77Jv7gqxfT0SICjn1SCEBIYjN2qizjquYXxWwR/7SDoF+h3lIqzD/lxk?=
 =?us-ascii?Q?+82sofSM4NjHOokBmg8olnKg5s5gdUZSHY6kEGYXNKZid9Abc0RbisBStRdJ?=
 =?us-ascii?Q?MsOb71sZRtJmPem1rV9VHf0+7abvZS6PEFc66Ix/3liW+bLpBT72XOxTsKz0?=
 =?us-ascii?Q?OVbOfNTI7I6OoDc93XxGorGFsWr5xJ5B2zeXFWK+EedsOlF+IHbB+hHYn/sK?=
 =?us-ascii?Q?7Yn+rGFUZh38ZYncLcVTZ/yI+Bn+ff2NpZhA5PbdtbXGdmlgvzVYCWvTfwD3?=
 =?us-ascii?Q?+Ya29OOEWjBcy7emYzqOEdwMovE/hCq/hEVJ73Qgvi0/JUul2jnsw7lCOhGW?=
 =?us-ascii?Q?vIMy53+vArhO4qsUG+AEA97Bbu9NYvDo6j0I7tmsVTPapxbQYeTR+CMix5rD?=
 =?us-ascii?Q?Q1WB3SGakgyNn4UbVW6xr2mMaeAvPnxJDnxjquQSL/aYXF0RZIEmuugd0k7O?=
 =?us-ascii?Q?2kUmq+5bxjp2cB0x0SB55GDDOyVgHmzIwGVDjODGStcvTJHLhlDcMHthHNCg?=
 =?us-ascii?Q?lPXeqtRuLcJSJPyR8a/d+Q/hPz1YJ6bumRj1pJD1vmF05axXYZdBFtweTEpo?=
 =?us-ascii?Q?n+W6qIbiLGkJ3VsyQayI9DNQxrNEOT6Mg/iCnx212lf0jGuGcUBFA981cIpb?=
 =?us-ascii?Q?4UivC9odQ2pUPqV8jPHLRR6qmWcHfPufRt4HwgAnF5wbfmlJFn8FOvlHyr2W?=
 =?us-ascii?Q?46/5KVKqcY3ILGE0MMqiUHPMaLja6G6nSA/PqDLRyNMSBgntW3bRZl9mQWrv?=
 =?us-ascii?Q?CBUl4Hr4WjbI57z17ZceJ2XjR905El5Xsxr8bY2iA3zetvLVTdwcMK+XKoaz?=
 =?us-ascii?Q?D2ZD7UQVGEG+QdXU6+1Mypi09Kgn4Y+Z2fTla48TdeGFXN1lWe1A4m4pXn9L?=
 =?us-ascii?Q?emwcxdNT56Q3SUS4ZRyv/qrYXpjJvncC1gbXwPJhqiQihQtoX+NT4NYjVFF3?=
 =?us-ascii?Q?9JWJDkj0VS9QDue9jssY34ssRTGWL3fpmjPpLnafwmJVh6IlCuk3/wjKm0Hj?=
 =?us-ascii?Q?UzL/e9b1P7SOkAaSSmKHS1plH0d7d6GeuwDUbGhjkSGL+xoZIVPPETPurRLl?=
 =?us-ascii?Q?dbc4HEeYzOSpvT6EcyWJ418ZHWrlnxgJmlQh4iQu4CDhPmj+VpMXvRcnI/Zl?=
 =?us-ascii?Q?1LHHvQ8UT5qvAD2u04Hbqchz0rmDhFrLo2nG9ls/ILTuGYpP+Mqn+7KOs/yC?=
 =?us-ascii?Q?ZDBoBQpHJ07OdahmXTaenIKtiGfPUyhP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8rC27cAdFcq+al9xzX1xevNw+B/XKdf8/j78h+MOlUhUILCKovZJYwbuekJl?=
 =?us-ascii?Q?KFSGrhO/fLCytSZQlCiz8HntIN/xH3UqvFDP6dXJsX5APo6pz7/xj0OVoMW8?=
 =?us-ascii?Q?ZR37F/x7NVVghV/BgYNmm45hI087ugYirmgwrThjS18w2dMnDJbGKRxQwUUM?=
 =?us-ascii?Q?LXWMbZls+NCsnTMGxR3utR0qkDPhbtXdl8hTsfZ1iazSLEFgg+49XutMCfg8?=
 =?us-ascii?Q?zmKH/bXMM8JxNpkPbfyId5m6ixo8rclT86sVIwkozg3UEi27vPPRU9nqbRBV?=
 =?us-ascii?Q?DMkeP4Q1LwKXu0JTsVkfJYhG1wk9DwuoK4LOKedePW67sw9NT4iC6YQkC0IS?=
 =?us-ascii?Q?bWD5wwuFprVZmUBEydjTBU1liMhONMggqzcAzvfi/GKkjXRp5SSPXkrz3h5S?=
 =?us-ascii?Q?lbYYDf/1Baq7LAq+D+Of92ze2ksQWXRSXxdoPEm7w/4oZuAIzGv2JuQjos86?=
 =?us-ascii?Q?Kr1qnd5s0GRUYsB9L1VcEFK88rawQWMjRGG8Jf/SrfNhSNAL4Y5obq/H2d0N?=
 =?us-ascii?Q?d+WrSNUnNr1gcoZfaanI144NAJ5Sxqo1LC5vubMnJsYM7ATjzWbD/xKqZK0b?=
 =?us-ascii?Q?vXl0xsf3qxlv5GAqpT3m0CXEMw0EKWl9bbt8MfwsLQ+EwUsmyNRDUmoisMOP?=
 =?us-ascii?Q?SUJMN8YVj5w/QpAz7YXlrcaZg3ULYhRAe4FKckrEseQYBgzM4fZ4G6LQfXNp?=
 =?us-ascii?Q?nOb2NyOPSbu9hZiB2dwXet6/zpQXn9jKwaMpfgGNh2PAbHWF7DO+3XEUVBL1?=
 =?us-ascii?Q?3ZbtcnhnVuPXOs6BMugYaVNajiWjp6X6A3OY3v9UB+DDZK3dIVl0EWzEiqa5?=
 =?us-ascii?Q?z+6/ShezqIAiBgb1biNVhYFhd1f0gYs/Dey+N1jZzar7iB4IBwfaSlcy/uOY?=
 =?us-ascii?Q?xg7h7jw4W/+8q4DRMS6DZaUeuB3DmJBYb1d7H9WqumKdkecBdeGGzVFFyS3f?=
 =?us-ascii?Q?NhSRdGhVu3ncp7LMvbGoN5FF0W5icP+tOIqDq8pa4RmRB5hAMV5DeFnlVTRa?=
 =?us-ascii?Q?RkoWJnC8MBiqI3XEOSNidzrM767fadf2fZySVcnIaJdCQFnN/U/gN7JrrjBC?=
 =?us-ascii?Q?F5ad8ahxMiLLOUAAMSG/vTjmQd7qqM1cuKvECDiRz6tPRTAgDxupTq000/B8?=
 =?us-ascii?Q?/N9mpsuBiFTSLY98MYOb7q9Ycwlg7pb0JredsrHzzI0OCPYlLyF6ASaz4dyD?=
 =?us-ascii?Q?mCh3NoxLhahsPj9MARKUeU+Oiw3S5tD4qwS+TNtWxx+ETzzShpUTu3N8AF85?=
 =?us-ascii?Q?0Pmi7LYHlWdWHmiL7yZr5f5IDbumI33i66N35d/z7X/+SrruU6gBIvaT8y9y?=
 =?us-ascii?Q?Z+b5kDjSXivYLqxhDtC+D0hgsulQYqEhhlqbGcIddYTTtmTqjfYHOePo1h3a?=
 =?us-ascii?Q?qm6d19uDO/H+goNEKmPomFswEnSzL+Dg3Ww9goXtqw4EFSguNvLP9BK4lS9E?=
 =?us-ascii?Q?c/vyzeyUAMm25lV+2M3cpGHphWMSyUjpAv+AQyx43z5/et8MBFuEGlTK7vjp?=
 =?us-ascii?Q?oriPNikaWGmfQuY6uaWVEtgUojdg3iDQatRVbhp7F3yttjWyS164pehlZ2dZ?=
 =?us-ascii?Q?KGdm6pj1aH8coqi93LEIg8ru44wPSmqZIRfNKrsZhz3Ypz+KH594q+xXLeII?=
 =?us-ascii?Q?oKsXIWo01Ls84qBeIHBPC5LUZqw+vf1zo+hWotsQZnRe1TI6iHY14pAdeMl+?=
 =?us-ascii?Q?9u45ruoD0e9BJsnjhIxZXtKhweUo9fX9el0pxxJ9YtgJIpKB4Dj0EZoX5X4L?=
 =?us-ascii?Q?bYxlytzEtQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1929acf2-6007-4dba-3015-08de51bee37e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 09:42:23.7182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PAkLoEzt1DCz7du3X7L8P/G+hV8b6UCDLtJtUPAcTA849H29iQzX8j8/yrhOaws/Kw3npGKq0COfHDAa1EibHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8914
X-OriginatorOrg: intel.com

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Thu, Jan 08, 2026 at 03:46:21PM -0600, Michael Roth wrote:
> Since it was never possible to use a non-PAGE_SIZE-aligned @source_addr,
> go ahead and document this as a requirement. This is in preparation for
> enforcing page-aligned @source_addr for all architectures in
> guest_memfd.
> 
> Reviewed-by: Vishal Annapurve <vannapurve@google.com>
> Tested-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  Documentation/virt/kvm/x86/intel-tdx.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
> index 5efac62c92c7..6a222e9d0954 100644
> --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> @@ -156,7 +156,7 @@ KVM_TDX_INIT_MEM_REGION
>  :Returns: 0 on success, <0 on error
>  
>  Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
> -provided data from @source_addr.
> +provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
>  
>  Note, before calling this sub command, memory attribute of the range
>  [gpa, gpa + nr_pages] needs to be private.  Userspace can use
> -- 
> 2.25.1
> 

