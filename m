Return-Path: <kvm+bounces-68590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 34C33D3C207
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:28:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 82B475C96FC
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 08:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20EB23BF2F7;
	Tue, 20 Jan 2026 08:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VVFN+816"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4312E54B3;
	Tue, 20 Jan 2026 08:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768896461; cv=fail; b=WAzFwkmb/rUxEWe8anaCfjlBDyRkZxoh4XIuGV09MaXu1qiyc2rL2h7KfpQHhPhIbPoXURl0qwz+TL2pP9J9hjM+H5G82OB0wyQQQ4LVyCChBjTRVdrGE9xz9etL4vl7dhLz5jPMpg21S4RlzkL1JIP/5JNL1DPqAQ5W5+UrzxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768896461; c=relaxed/simple;
	bh=CRi0f3DuzHrMGz0A+I2rDZgLTodJBi1DXGJkqQxCiRo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AslN8ii92xEOYOLi5yUoa7qM/QOitqCQL/3dDBsMIciySsM1uvnb5SZ1w9QWqfWZWpUNhlpax2Pe1/XhTjqoUqROrrTVHXvvBsuPuIyCQ4LWB2+QMv8NXTR4z0VC7mu/vXuq9IJDv/ahUVjDmV5+YjxpJelUxNbj8JghFyidSHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VVFN+816; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768896460; x=1800432460;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=CRi0f3DuzHrMGz0A+I2rDZgLTodJBi1DXGJkqQxCiRo=;
  b=VVFN+816HiTrIPz5wSMlu2pUATc3Il1FeGDbjuKFwSRJzdFXHYTvw8Su
   bGrtnl19As4PgjacbIUQ5Jp1DegLkB/0skEJNOl5MYMq8WZiib8t/PfDk
   niuaKJ+hezunoIUQwyeX8hrLOk6QzJvImJWjbPxWpBs+q9oD2UIKR2hXp
   Cao+EpZH7BnMO6fImEX/ZroEMRyOA/uVuDt4peg8X3Nj011lr2JemRQww
   K/xPduMX+SNRrJ3aJEib568jTUg/zbHfExRtJ0pDFsJmkHr+YQGyBFn2z
   goWx2TZ4dIzjt1SrlvfYrrBWVvMYcY0lxI9de2lv7HbB6sIp5Iac1E+GT
   w==;
X-CSE-ConnectionGUID: a12YSPRRQRSVKwkjclci6g==
X-CSE-MsgGUID: QrpXXf4HSvGHL6w27CRhJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="92762243"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="92762243"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 00:07:39 -0800
X-CSE-ConnectionGUID: o1JzIvV2SfSMHSMeEuHfIA==
X-CSE-MsgGUID: +ySEhNZKQBScF7d05MXDKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="210901138"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 00:07:38 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 00:07:37 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 00:07:37 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.68) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 00:07:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sRo4M9eE2J8d6tLEgfIWk9vhOgWGSLqE8IjAc1qpFEMRctXh1SxVTFZ2KrwZXoF7ROA71UJPtAcG9rfwvDBkmFAbLuMg6wZJJNIKLT+eO1Th5UNSwAPQoI2VVqiqz0+tv37dGOjJ47gzYT8FOmBTrZrz9yf6Mb7lAHa+XHL9SSVSnVdJE276JbPXpYTxSVAm4KaOC7zYseosNhwfITqnV0hUnjPJAwRBopt0KTjK3eqzMLkTBemtL6ykWLkPACDZ09QkQqBmakQDBW8jWK4iIHUelSXee8Hfo1vGj5E297HJeLDJebRSV4Wmc4KlMl+pdcXfrSdFJeQcJv/VNl9VBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=htePmQZxDiRb3bTwuTWbZZE9RQauJ5w9vDD7nvai2+4=;
 b=QWk64GF0YjdEgB0v5Zv/IUQFTXmSX26xuTaY+B2A3i0Bd+/ewElSKZrWC5ZNq35oqKzk5f0zLKKSGA7JD6o9q7Jr0Eieoxtf7FovhacvX7m9I9o9SJnfYyM2o+TcJGlxyLE/voYpMWbgx3IpafAwmaT8BR308KXhdv2amN7uGK2Sna2DE3QxigrRn347FQFmAWVjLgAIG5eoCg//CwUeMxeeEVXhm/zPMq6vnGFtXoqt9UZK6dg4UjZIXR3IwEOzqrZk1MWeyqSh+/IRZHEauNnOnDwUAYSKdG7d9Ph+4ppgp5SdjHkPr9KsnRbbZWBDder2JENof3SNCQHElgzBkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH3PR11MB8563.namprd11.prod.outlook.com (2603:10b6:610:1af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Tue, 20 Jan
 2026 08:07:35 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 08:07:35 +0000
Date: Tue, 20 Jan 2026 16:07:25 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xin Li <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 17/22] KVM: x86: Advertise support for FRED
Message-ID: <aW83vbC2KB6CZDvl@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-18-xin@zytor.com>
 <aRQ3ngRvif/0QRTC@intel.com>
 <71F2B269-4D29-4B23-9111-E43CDD09CF13@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71F2B269-4D29-4B23-9111-E43CDD09CF13@zytor.com>
X-ClientProxiedBy: TPYP295CA0029.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:a::6)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH3PR11MB8563:EE_
X-MS-Office365-Filtering-Correlation-Id: ac24b5c4-a47b-44f2-66ce-08de57faf860
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dVlzZTNvUFAvQ1JDM2p0NjYvNFBON0RrOU1jUXIzTkhxNjVDRVZya1BaVGEx?=
 =?utf-8?B?WDJuWTRrN21YTzZvOC8ySTZldDBod1lXQitBWlo2WVZSYWJhcWtTWEQ5R1hR?=
 =?utf-8?B?R2J6ZVNOelJwODZzZ1hVSnMvbENDOStkaTJ5WEVSbFIvWW5EZHIzMWZocVFJ?=
 =?utf-8?B?ZlhQSnEreU1hUWxKZGl0Y056cmZMdzlBOG16Q3NldUxPcFFPTHVUZWl2SmNR?=
 =?utf-8?B?WjRheXlOY1BBQVNJVXlQV1FqTzFncHIrZDZzTzR4Nm82YXlBbWFWVTBjdTU4?=
 =?utf-8?B?eWxtaERqa2hrMkNaZkRjeXF0WjJyeHdBTnhabmJlblV0d0NvUFlucnZmVFhW?=
 =?utf-8?B?UjBVK2M1SUFOeTl0cWd4VW9Da2NRRU9PbStpeVovTmFZU2tBY2ZXY3k0NDNL?=
 =?utf-8?B?bzZvVmxHU05OSVhnemV6bzA3RHp6b3ZRZ2JGVGErR1JsZ2xhbjdvWFNWeFVx?=
 =?utf-8?B?Y2JQd3E5V2lFTEVSalV5a1VWc0tFcXNwUVFZNkE3ZTNPdEZIdG5mWk5lWURM?=
 =?utf-8?B?Z0lOd0lFZEYyZkpxbEVEQm5wN0VTaWYzT1dUbWVpaURLYTZ0dE9hZEdBa2dq?=
 =?utf-8?B?eEFtMWlvNU9kaDhacXhzY3lJdVBrRFAwU042V211SysyOFE4cTk1VFNzZzFU?=
 =?utf-8?B?YTZROFZMbWxDbFVQYUhrKzAyVWU4Mnp0WU14a29YVk5US01IWFM1MnRlSnpu?=
 =?utf-8?B?MEp4R1d4ZzdpSDJsanRaemN0RlYxb1RIeVZDRWsvd0NwcExEVHVhWnVxUWk1?=
 =?utf-8?B?RVNuVzM3bVdSL0xmNHR5Z3BoK3IzOTJYblM3RWVaTzdaVDFXeXlhMmFibFAz?=
 =?utf-8?B?cFZXWVJvMFFFdy9SVGlzZzJyRVUrYjJLd292cWtJQU5pbXRSSWRGVE4wOXpD?=
 =?utf-8?B?RlFOMElmdGtrbFVyNGV6RmhjcVladDM1a0lMdld0QlYyREVZUCtCZ05hL1hY?=
 =?utf-8?B?eDhGalc1TTgvWXB0WVlhSDF2RDJFamZhVW54bWM1L1prR2U2ZmppN2h1d0hB?=
 =?utf-8?B?eHNEdW1uak9vUUFXVjd1U1pDYVRjR1d1Zk9PSnBybitOUTQ5dStORTFkdnJS?=
 =?utf-8?B?SHhUL0xRNWUvZUdKTmt3a3ZQeGUzY2tUT1F5TXNhdkdDUCtyV1ZDQ1lVaHE4?=
 =?utf-8?B?TlEzbTZiQ1hDK0kxb0wvUUxZcTlab0s0S3NLMmUvZGJUZEdVa2R6OGFnZHRS?=
 =?utf-8?B?dDhyQlRsYXpZQ3V5WmsrWWhpcGRTeC9NR3lMNUk2dFM4aThyUHB3YnhpZkhN?=
 =?utf-8?B?QXJUTk1SQVd6MjEwNGVaWlZyTzFxTDlXWjJEWkpFNTJHdGU3MHAwRjdJY3dG?=
 =?utf-8?B?OWZLVEdqRFBpSnFrY3g4Z0Z5U0RNaVc0Qk90SlFqdUtEQkRXRlpYajRJM2Q1?=
 =?utf-8?B?QTZiTUl5Rm8rVlA2SE82N0xnN1M1RFhOQlh4a0RpVDhLa2cvN3l6SVdHc0Fx?=
 =?utf-8?B?Tm5vOXFLQW5DdGxwVWxPYlpWMWZrOGJyRDVSTHFsNnR6WTNSdlVGTkppTlI2?=
 =?utf-8?B?Q0FwdTR4cnAyRWNNWnN0SHJoQUFFMjFWcnJhc3ZvekhvU1hKMm0zTGwvYjA5?=
 =?utf-8?B?S25PZWxOeDh4dE5yZ21wOWUzMVlWakM3ODgybnZFN0RNdkIvcFFHWk9JYVp4?=
 =?utf-8?B?amwyY08xZEpUR21vTWVmVEpUdVVUUy9mMmVnRnNta1pVcEtXNFZCRHVOa2RG?=
 =?utf-8?B?ZkVJQklwZlNqWDZyTG9EdnZYUzJXUmVIYW40WUhYeW4ya2x2TmpIZGhzMEdR?=
 =?utf-8?B?OUkyQ3lMYXd1bWhEbzdrTkxDa2Y3SVFtcEtlRDNOc0RpYzdVOXVXclVGa1Bw?=
 =?utf-8?B?MmJHSWhZUGZKRlM5cVVGR0p0UlYvb0JCTVd5ZHBKcjdPRHM5Ly9MSGN1NHo3?=
 =?utf-8?B?U2FOM0YrdmVISkJ6bDloZE00dy90NS9pdEt3OFdJVkh4T2VIbk9iNUorMUNv?=
 =?utf-8?B?MTI3OWk0T1Vjb25aRldmWWRBOHlLdkx6NHpLaFdOOVZzUWYyOVQ0M1hobFM4?=
 =?utf-8?B?UWNPM1RsSHFQL0RxRk9mdWMxVmlvRFY5bmdDcHNPdmp1SDNROTlLWmZ6dGtz?=
 =?utf-8?B?b2p1VDEvSlY2QXZsclF4c2oyWVplV0NWaUcvaTVGTU5KYUc1N29xdm83SERa?=
 =?utf-8?Q?zSok=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDRzNWQ2MVd3bVFOVTBtWHB1emtCNExPY09KWjhZTEJpQ00ybGNZUVdKWVNu?=
 =?utf-8?B?MTNvSlliWTZkRlJ5aGFVQWVKeGJpRzZHZTlLeTgzdGRSSVhEQ2V3Z0c5ZFhS?=
 =?utf-8?B?Z295dFZRbkNDb09SVlRaOVVzdmZQaWVYdXVDVXlBbkJUeDBidmovRjI4U0ZR?=
 =?utf-8?B?cmdrTUozN1VIVURWallDT1RZU3pMZEVPa2YyYk5LVERPaUFsNWY0SzVFNzJV?=
 =?utf-8?B?a3pqTzJsYkwzMC9SNVF3UFhBYUNKYUx0Y0Z0K3Y3dnd5VklJbmdWS1hKQVJ5?=
 =?utf-8?B?elgvSGFzTzdWNnpFWk5kV0NDdkU3ajNQeUpFbVZ0YUIya25pMlFjdWhnRzRD?=
 =?utf-8?B?U25VL1B5djYwc3FuN25FUnVCamlEUW4renZDMWh5SVdWM01ZUWlLZnBKNnk3?=
 =?utf-8?B?c0xZMklMd0xsZitycHFmSFF2bXVsdUZ4Ym5qZFdBSGlkYWQ5OVFiTElTYmdS?=
 =?utf-8?B?ekl5Si8wOEFyWjZMbFBoOStkTDM4SFovQ0xxMk1qL0dKRzcxYTZkRm1VZ2F5?=
 =?utf-8?B?ZkxSM0laN1Y4R0k4cDZVaExuQU1WSjM4c09JcUpSQmdseUh4YjRFVTFWeUx2?=
 =?utf-8?B?YXNsNUZGTWIwZEV1a0VPSkQxZmd0enE4ekVpTjFBcXVQK3FJcFlqQ09TWDRk?=
 =?utf-8?B?RGpPTUZhMU1PU3FQNDJadHZDOUZFaVQvYzd5R202YkwrbFN2YndoekNjd3Zl?=
 =?utf-8?B?RkNFaC9lUURTNUV3RFlnNlR0NGNrTEpodXoreVhWaGk3dlM3L2VZRDFiMXlH?=
 =?utf-8?B?WnJZdkVtQVBiMFdPdkJic0NoNzdGdFAzbmdvZ1V5ZzYrNUdlMHkvZnE3OHU2?=
 =?utf-8?B?cHZRTk5DYlBZc1U1YUcydHZ6azZ6WDVtT1JBbG1DM2I3N3EyTEl2TWRvTU0z?=
 =?utf-8?B?M2ZxZURRWi9aVWdjZkxibFp6MFV3OXdyUkw4UG4wc2hQa2R5TWQ3aHlxZkQ5?=
 =?utf-8?B?aGhVR3Npejd1S1c2dVoxZk9HeXlLckVrV29xMU9iZE9CSTlhN00vMll3NmJo?=
 =?utf-8?B?b3A5aFpZZXBHMnVNY2ttQ2pVd3Z2cm9OTGF0OHdsdnFtd0dLNlVhbEd2eDBR?=
 =?utf-8?B?cUIwL2xHU0NuKzJrV0ZndWlBWjh1Y0VSeVltYTB5Z20zNzBlMjZodmFlL2hy?=
 =?utf-8?B?c2QwVzBHdjJVUjFCUWdqVjBYaUN4S09yS2ZBcVNQMnhuamF6c2xZMnluanov?=
 =?utf-8?B?U2pVSTR5OGpuSEtwa1VtMGtpYjU4UE92SjlGVWpSMU9qS1pEbWtTUk85TytP?=
 =?utf-8?B?ZGJ2dm10VEdiSmxYUDRIM1J6VTBjYVcyNFdhMGJ3M2lQemRCNDlpMFlZN0ww?=
 =?utf-8?B?N2cxOGFvc3ZjNFhjelZRcjgxdG5Sb04xRzd3Zkl0ZEVSZUdyRmNYVWRGM1kz?=
 =?utf-8?B?Rjl4SWUwWHpuVXNkNDZ5L2JxdTNXM0Y5V2RQRmRxZTNUbXdBVWJNL2RMTG1S?=
 =?utf-8?B?Z2ZnVEIzMjRQNzB4cmVGcGlGWWhLMWZZYkhwcGhBQzR1bnNVK0tzOEZCQVVs?=
 =?utf-8?B?M0FxdWl4RC84TS8ySjFGRzJhWXk2aDBhdTEyc3B6WTE0MDZlUkpHcjdTRzc2?=
 =?utf-8?B?Z1pSdVJsOG9HUlczeCtuVTBhYUFHRjBodUc0UWloemx6RTVqN1MyNEUyQjhW?=
 =?utf-8?B?dVFTZkZkOWZobVdLZjhwOTJVdmQ4VnBhTS9qMDQ2U05SQUt1YXNlTnRVbHRP?=
 =?utf-8?B?L1ViR1dRdnJqdnNKS1Z5NGM1SXdXQ0IyYmxJOU9MZ0lqSE9rTm5lSFh0cDZN?=
 =?utf-8?B?Zm5OQWJKMUFHTjZvbFY1cGNNeGZMUWVsN2VGSlBjUjcrVndBd3VGaVI1Q3k3?=
 =?utf-8?B?ZWpaWXpGbmZVb3JqQWwxSHhqc0tGbS90SHRjV1Q2WEhrYnY3c1ppS05jNEti?=
 =?utf-8?B?UTkzeDhmak1oa2tMK28reEtXWTFOZTBwUHE3RmtoVUpKcEYvdUFFMXlIa09w?=
 =?utf-8?B?cjM0L1ErQjNsUTdZaUpVQWVxZzZML3FWbm93YjJ0SDV6UXUvTGpiTWptTm1m?=
 =?utf-8?B?NVgvUWI2N1R2SVUyVlpoNnhlOVF1bUZVa3J5NnU1QURwOWw3NlQrVHpuSDMr?=
 =?utf-8?B?RVlIdXExdTVIY3hCZjVRNzBvSVB6Slp3cWIzbmdwb0dZUHNPVWQ4eThpa1FB?=
 =?utf-8?B?bWFUcndEcXd5OXRGUVk0ekJkU3hjeTVpTW5KcVhKWHhUNU9leStzYlQ4SjND?=
 =?utf-8?B?QlZSQytXR3dlM1IwRndKZ2NxU3FNK2NobEtZQWpORGJWOFE4Z05wdHNRSUxt?=
 =?utf-8?B?eVlHeStzQUdqT3pxV2FmZ2NMSXl5bGJOLzkvd3JYc3gxaUVQdmxXL1RDSDlI?=
 =?utf-8?B?VTMxM1c1ZFN2ZWE5Tkl1MDJ6elQ4R3o3SmZWWmdWVjc3T3RUT20zQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ac24b5c4-a47b-44f2-66ce-08de57faf860
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 08:07:35.5370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EYUUWdR8ShA1ArSCCKV7Qtq5BAd0+kGDQp+2wkbQjNLARironx8t3krMwT+YmQ3ihH34CRfHfC/xFxeMSjAP3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8563
X-OriginatorOrg: intel.com

On Mon, Jan 19, 2026 at 10:56:29PM -0800, Xin Li wrote:
>
>
>> On Nov 11, 2025, at 11:30 PM, Chao Gao <chao.gao@intel.com> wrote:
>> 
>> I'm not sure if AMD CPUs support FRED, but just in case, we can clear FRED
>> i.e., kvm_cpu_cap_clear(X86_FEATURE_FRED) in svm_set_cpu_caps().
>
>AMD will support FRED, with ISA level compatibility:
>
>https://www.amd.com/en/blogs/2025/amd-and-intel-celebrate-first-anniversary-of-x86-ecosys.html
>
>Thus we don’t need to clear the bit.

In this case, we need to clear FRED for AMD.

The concern is that before AMD's FRED KVM support is implemented, FRED will be
exposed to userspace on AMD FRED-capable hardware. This may cause issues.

