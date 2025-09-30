Return-Path: <kvm+bounces-59051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65E9CBAAD56
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 03:03:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 118ED3C1F83
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 01:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E2A1A0711;
	Tue, 30 Sep 2025 01:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nPNmzt1E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9140E34BA4D;
	Tue, 30 Sep 2025 01:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759194225; cv=fail; b=ZKrH/Zy3xKx3P7HFXvVm2JgysyyTyw55Ns81H/4JQHO7gW+yTKJyCF36349VeLe7mkjY34oeeytMq4oP+xzJWwd5zX8hEWRx9ezht6HNeHHUPjdSUcALtcxLQfIDmXL3SJBJTB0+SDjbYS3yN3KauT5gi0KBsdYtppjzRRN4PZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759194225; c=relaxed/simple;
	bh=ez61/jTO1oTu9mKcMyCDD6jvR6YC3KIMcuBG81XgMU0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dXp68Man6c4Q6BWQnAxGEhMVcgyk998hMKmIvncH7+weYR4NjDhkzOqu2YCgSbn+DMLkKa2oOUnW3rhxlM34H6dT9t8tvKsh9MRJm+XB8VmzmJ3U6Itmm7MBStSEfVfM86h9pXTPDp8yxcICO1vy+O5y5hmk0+1CDeBSBCKHndU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nPNmzt1E; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759194224; x=1790730224;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ez61/jTO1oTu9mKcMyCDD6jvR6YC3KIMcuBG81XgMU0=;
  b=nPNmzt1EF591ahwsDov59AH9bxAakJzTdD2kBeaGdDjabi/ch4TA78Fp
   OCT5Qf+Qwf9JnxVIckuPyMtE/QemQyngD6+vZ8S0D8jJtZDykQXHzKVY7
   xX7q+zo7UBrhnC5dKD00PZN8Cecm+SY6KeV8pRlmw2oWEqpPePo+tqSGe
   xV43AUjsXlN+TwDwD4Alji2rHG+omcTInxMgbvqrRkQRimzzjaITzJV74
   QZokXZdNoVwG4SJkgEmZsgA5oWsSL0ZpPBbjSsLCsblUwUC7MGA0lTm8X
   mZwQHh5pGi5MW3gAFemFJTzBXculkhoIHTVFBRS+XzpvagyHvT75vZNCJ
   g==;
X-CSE-ConnectionGUID: +SiVMzhVQI+HmKNj8Dbqww==
X-CSE-MsgGUID: qsVcvuUIQMqkgbHvoxmfZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="65300063"
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="65300063"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 18:03:43 -0700
X-CSE-ConnectionGUID: 4Ktmcq+wSmKJURPYXsslyA==
X-CSE-MsgGUID: zHfoWx7NR76kB4kqNedJ7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="182665978"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 18:03:42 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 18:03:42 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 29 Sep 2025 18:03:42 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.40) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 18:03:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FWRV4YU/chFXe9AaoQaAsAgj7Bxcd8v1ilpbxKRxPic6kzjiERe+uu0xqhOJIxmBhRKa1N1FMDNki3ox17RWjGU7MZaHW0S+T5NRd5yODVItSLtxck4UTzbUXR9j72kWgRV3Xovr3MeSXMS87qnPQYtKbXy43fjl62CrbKi+fB7VyIAi1WxebngSmvHqyWB9ZjKelgjj/8r/S7HoHzyfkaxKGnVev8khX7IIwT4F2amSukB5/s30gHrdD45TxZiRMdyujFu/0l79MYLjnNF4doL6Jl6SwAnKuzw0t2fajWs8RcwIfl640fTw50ZP91VZix++TYYUq4oZJ+MFnJGXog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ib3pM9TNCe2CoyZZ4rcmdSChrWmJ0L4eeON1VKh6+As=;
 b=d0rI+HTmAM6ungWG6bhNttg2NKIvGt6/fxWviX1psEKVHn2zzmMXyjU1ibGCoCasgN1NgzKJFotReiYLeVwFB8sqJIlfYl/qh1760PkKklAKJK3j4ob4fEyniUvGUC/chjpA1DIJwRadBN2Ek5PpYuewZ5TneleYw6Jq5/+MjOJnfJn+41P8hJ1mlQ43ZZ9JBLVx1tspmPKGnWbHx3DSvX+uOgOop91jzGXxCJqeom1JJZn6ID5yVGwR/X/4L8igwR5uQyMyhJ/vKjv1jFHTnzrSmvqmPt1T2uRwl1yo73/Tm99jrFCSe8GjVYcENDMOKQqZVcLLtzYnG70ro4tMVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BN9PR11MB5257.namprd11.prod.outlook.com (2603:10b6:408:132::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 01:03:36 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 01:03:36 +0000
Date: Tue, 30 Sep 2025 09:02:25 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <kas@kernel.org>, <bp@alien8.de>, <chao.gao@intel.com>,
	<dave.hansen@linux.intel.com>, <isaku.yamahata@intel.com>,
	<kai.huang@intel.com>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <tglx@linutronix.de>, <x86@kernel.org>,
	<vannapurve@google.com>
Subject: Re: [PATCH v3 11/16] KVM: TDX: Add x86 ops for external spt cache
Message-ID: <aNssIWsngqxQCd9i@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-12-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250918232224.2202592-12-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: TP0P295CA0039.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:4::8)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BN9PR11MB5257:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cfd02c6-65ed-4cb2-0e4a-08ddffbd2eea
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?EDg6AQi8YCHVW86Go2LKLlUIHrJaQ3h+RSH5wR99/u9GKWmwG8qPxJ/IJA9w?=
 =?us-ascii?Q?hTnR1/X/zQVU/sQlSL0NEiVjSbH0iN++7rOV1msC3w0mv8JN1aRy0uKwf/iT?=
 =?us-ascii?Q?iM8J29g+mALqTzipPunM9ixuYkAMTSge8X7mMOs+m6KOEiq2Yg0/ti46C/vs?=
 =?us-ascii?Q?/xl4wVJxHmAmodIV/YZYV/MgV/DiwMy45FUn62Wd4/4r6Oa66aC1TSr0YytN?=
 =?us-ascii?Q?9qDu23PPtElOMCw9OftOwh8mfr5U4Erzfe5iP3PcBqj5c3zCyfJ1LCxmO/w9?=
 =?us-ascii?Q?2SqLHmLBw4rX5HeRylmVostgFtL4n7avXaj3WIm3qVZiFaI6o2ctQAG8hMPW?=
 =?us-ascii?Q?ACnnleLhQxUcmvlD9NavHhgezvcR5Mnd/ClCJYDCvbcEwcTpeYtCU8aGP4JB?=
 =?us-ascii?Q?N0oxUsu4xZmzw7HgY2Arzj8TbyLNFmOBEbCA2mSkyG6WGcc+UY8BJZ1QweHk?=
 =?us-ascii?Q?8chjO00WDX8fPUo2WBh1zcOuuDKTto03lhxt12GoA4k8IeGQIpOCvLvejDgf?=
 =?us-ascii?Q?06Yu2VaK9NvmiHEjVZGqVolHtcUW38ycLWDt/oHBp9ocOgvEySqELm13Ml2R?=
 =?us-ascii?Q?Hp/RQkbJTqyJ1JzLmFDz79kYAn3ZoAdplyzgzwDpQrP5pN/lz1oq26rnWm2T?=
 =?us-ascii?Q?N3nNgHjDOs91NIPnoNl3q2MzUN3CpgOAtV/GDC7AwRA6bRe/sIc+axtrGf43?=
 =?us-ascii?Q?EP9fQRGoHLZ5xXUEG2DfS45J1t/FcR7hM3QyuMKHhvUVyC3Jv/5J5x1HdtZC?=
 =?us-ascii?Q?oTulA4Kfc2LFl+N8qqU6ZjfjE0j4imR8IAbAPTr7+bd2TYaLi26Ve9ZjlSG6?=
 =?us-ascii?Q?JVGdNvkK46ThxKqixhN1GGil7q2tiI0MjejaPQ0+sC5s+OMuXMSPPscov/IR?=
 =?us-ascii?Q?OU9z7OTu3iuvQZnDoQnMCQyCdcOiJ/Q8MzS7Elgf/oSGkyuMnUOfgoIySQPO?=
 =?us-ascii?Q?IvKH2VfrrT7HbxhcddXwo46sH5SZcEmqg92cE/ZYk3T5prS0WWj7iS8HLPDs?=
 =?us-ascii?Q?9nG94IUQ1mO5K667CGcHhYgOTDNvqPR4ctOtQK+g3h9EZjiTqCZ3a0MsTEB2?=
 =?us-ascii?Q?ziIvdmNo7sjBFU6hv18LPueXkme4jUaG3AlWtQGdx3SqVNTl+Df21PFYRKIp?=
 =?us-ascii?Q?2FjlxwutylaNi+HZv0rfVgM/lLBjUxyubE4jqVdWqGisd2+RIQEEvKBrSU2Q?=
 =?us-ascii?Q?+Xwn6Bm/CoOY2Bcb0qz68Aqg47k81hE7JDpe5SYa87nEKN0kATesVKphIi13?=
 =?us-ascii?Q?g5wDIx9bqvMOQ3BeVhZf8I8KDg8TJl07ZkNIhtxHjiuZTrcVlpyZwSJvlALl?=
 =?us-ascii?Q?C5JvUcNcOGdpaeJIwgHMzH0e/1LPyu8xnRhq+zdNiB2Bh0vDgLEew3FWlYT1?=
 =?us-ascii?Q?xvO+o1CuZYqeRjc5wzKOVfK8o2/sMLB8vI2xbYbT085rmuFzbhT64PbbV/Um?=
 =?us-ascii?Q?9s8CzS2RKVHd7TOt6DYzitfDiz76I3frTMpUTiKifuMeTflQVunnWw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xejigpsWh16i0e+plnWBcmsTCn3RH9sXXHgJMQfCnf93JFTEYex10wHUofSR?=
 =?us-ascii?Q?QFTG6KTPo0pAUlI5oODUPx6hok+rqCiNtXOo6JB2jZLNcJULMmO/ANaeCExu?=
 =?us-ascii?Q?yusbIXYFvCUvHjJe5agP7tv0IBkU9E8DAb1txg2zqtlycmv9rj6e9bw7MskG?=
 =?us-ascii?Q?uHTrZ5cKf/aPIDNs+cXpZGJyPoM7/3IlqkqvxUxUbcshR7ZXcZV9h1lpDeHa?=
 =?us-ascii?Q?JW6AAoidLZI5giuZriNJ0JGN3JSTGDi23wPOvuUNC4D8nToGfDtEokjq3qAP?=
 =?us-ascii?Q?5gO6ivJfyR7y3VU6/UPJBBfHUPu99pzpS2UfbVjqjRxVFbxKPj9eVUMXNE2q?=
 =?us-ascii?Q?gHBDbJpaFB2WM3EpVFuwBU3j+CRFJMv3Yprh3LrDVRGHyvhQ9mAMBp/m3eGt?=
 =?us-ascii?Q?xzB+yEg3D8R1kaDXHhHNCGVxIunRo1R8kl2isX5Ro33deClXfY74GaAm1yE2?=
 =?us-ascii?Q?ctZ/MjPgn5uRJfEukokvl8cokFXJPP+tnqScLhLoaGqnF2LdfjDNk5TEr53I?=
 =?us-ascii?Q?YEe2X1xKmT2HTvgQ/wwQPoWFnETjMZMmWtGEjxfff4bUtg+34nG+dXUC03cT?=
 =?us-ascii?Q?S4tb0VPK6JnJR8gTQQsPx2Tp0BqzgE5m8BSg8eXUxuT4NnV0IHO1ChIT03Yh?=
 =?us-ascii?Q?mcks1lKTXe7U3YOlVVY14gSjqfg1zXxlVDhMWRTpZ3YL/DQIOJcj9g94lCb/?=
 =?us-ascii?Q?dAjQWykV5YxIgc66S72Qs7youn+XKHvNhvIq5MGfA5zC93nLRmIkKIG5J84m?=
 =?us-ascii?Q?+LMBCA9jt4InR5h+dQWSzVu9n70ju5zTAFm/CjfkuJ1hwJTd1z8tcOaNjepx?=
 =?us-ascii?Q?3bnVPVGCz1ob4Z8GlyTDsLJpVSAmyb3JPoiMG2ON0cf5lzpNUdzWAUlva6h7?=
 =?us-ascii?Q?D4Z88Yc9Q6ruVLq7k2LUjUqvF4Yee2Z+5JHX+gZRpS+jTh1ORqbFvAiIEt6i?=
 =?us-ascii?Q?HqvJ0xFx0Oi1hNN2+2bXKbNdWtq20kaBqkatNUMguvwmdbL/ppP6egK//4k2?=
 =?us-ascii?Q?dF7bxFr6YnLFsVi8Aeoz45S/tuYLhRyKUa51dGhZJLTmYXGhheXl+l0yrJtk?=
 =?us-ascii?Q?k9yBa6vIWkvn4u3dKx6YtXvAiZTuFY2WO3CAb5FNvtmMmW+BCmdoj03V4DBW?=
 =?us-ascii?Q?dWP9l60dMdWM78p9Kxvk2KnjVMXn2bthHdaLt0ZGkkc6BCcpc1/TVec3YJ4Q?=
 =?us-ascii?Q?H1I5ZvODCWfSbrpOjM2Es9auMGy5u22B9A9UHsNVbfq5zHA0We9o7gEkcjaS?=
 =?us-ascii?Q?h6EfPGsxf4YUgQQOhXn5+TidKmMMxGC4x64ERvczDpp5zNwyich4F3zeASEW?=
 =?us-ascii?Q?okqLRszIYR5Aq0J+FMN7y8toInRflcSbrlILYGynok4xYMUyHrUABBdvX44u?=
 =?us-ascii?Q?PJkRGcopu5H6WcYtFjGY4j/fk6qupAYQlRA5IiJrTEz4mMCLoFGqx9DY75oq?=
 =?us-ascii?Q?DB/AEkPwsshjxozQK95T4p9EGhyRa2+ITOOKjm6BxWjEwwFHPXH1YjyPBBQ2?=
 =?us-ascii?Q?Z3rFtdSTHp8nU6k1Jm6zZgvq6NYaNJHY/krl+MYf3Owk7pwwdgkINBlL/FO0?=
 =?us-ascii?Q?rDJqDIUwXXMqSmdI9Tq9wnmFyAEtwnAvX0OnDPTG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cfd02c6-65ed-4cb2-0e4a-08ddffbd2eea
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 01:03:35.9955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S0U1Oe2n5uFyJDK+ddbE5HBbN7ZqNAkw3G8HUWmvHLb8d9AR2E57j/1xIkf1aFN4R+EcgHsCpN8qo6pcHtlnMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5257
X-OriginatorOrg: intel.com

On Thu, Sep 18, 2025 at 04:22:19PM -0700, Rick Edgecombe wrote:
>  	if (kvm_has_mirrored_tdp(vcpu->kvm)) {
> -		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_external_spt_cache,
> -					       PT64_ROOT_MAX_LEVEL);
> +		r = kvm_x86_call(topup_external_fault_cache)(vcpu);
Another concern about the topup op is that it entirely hides the page count from
KVM mmu core and assumes the page table level KVM requests is always
PT64_ROOT_MAX_LEVEL.

This assumption will not hold true for split cache for huge pages, where only
a single level is needed and memory for sp, sp->spt, and sp->external_spt does
not need to be allocated from the split cache. [1].

[1] https://lore.kernel.org/all/20250807094604.4762-1-yan.y.zhao@intel.com/

 

