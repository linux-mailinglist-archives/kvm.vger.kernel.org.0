Return-Path: <kvm+bounces-65541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FF00CAEDAD
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 05:20:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9585C300E81A
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 04:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 419F623A58F;
	Tue,  9 Dec 2025 04:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jneD2k59"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FEA2620FC;
	Tue,  9 Dec 2025 04:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765254051; cv=fail; b=mV2kedn9e9yI6RB2w7q0o6JC25uZ8WFnUOhFLiajLEMaTGGZ/xM6EzWCnF5oNUMB9Dol0y7LevDlC3q4TpXZJ3NPpK+P85xJp1/SR9UchCBxqNmtbaX2pXBXQxwuOok1f5ogze7VkMGmXe0h1RU58JfRiaHHFPmscPuyQsrkCpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765254051; c=relaxed/simple;
	bh=FrXX20E5SZ5OnLthMgKLtBiqJHLWkneFQoGDrsTeV/M=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=MDIZvP8Q05/bXYXOMbmlPu6nUycHZy0awHFuvYxqb405BLDwUxu4qNKUGrkBkwt3HJMNcql+viotn08rF9YaLDW8DJAluG1fbiC7QAG9NCLpTab5y7GvfgvvdweF+3DBqdBjSMS3JHGlbJ5kvbB1KLyEWiLrWysU1jncJ26LrmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jneD2k59; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765254050; x=1796790050;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=FrXX20E5SZ5OnLthMgKLtBiqJHLWkneFQoGDrsTeV/M=;
  b=jneD2k5951I7FBloEb74oOUjo/cPvW14jdCssBLOkAK7YYrl43GR47aE
   zHGzHxFZc367QDzHOokTwNVui/aDLirqoknfvo12o94bIbSkFCJcIwGdZ
   aQbz9SIrwDK0RAy9y8Gj6KtmtdBBnKCaoynjuLilkqiCjUF03EpoYWZua
   2k3tUVpJG82GjUopEjoBTaiQV9ATz/8TDuqMmNoi+NhNzfT9o3+OQudMi
   TE2CSAO8cQITaJDOqEIBZqDOidXxutS3JAinozAD42fWUb+hChOLn7RMi
   +KP9W+f69l9sz6W3GpoP9O7PbaRmMa1Mb8SSbIsJgLiFM6LEZOGZ19O7/
   Q==;
X-CSE-ConnectionGUID: f+eIceGjQhSsgMqVA1Eecg==
X-CSE-MsgGUID: 5uXraBLJR/iUjcvhaQdBiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="66213513"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="66213513"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 20:20:49 -0800
X-CSE-ConnectionGUID: 903vzOrFTledgkcCZwBHBw==
X-CSE-MsgGUID: 73j8AW6oQLi1l0KdHdaTIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="226784683"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 20:20:50 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 20:20:48 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 20:20:48 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.20) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 20:20:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G5hafoZsJb6QqIuLyLY55TZPcRJu3G7B4vbGLYtCsbbHm2sgWQuwQr+CsAVWU+CJ8u5ea+xBfomwTgjN+z1tROV99A6AdLVoOtxKX+isoUnqXV+tsrXjKOqQVKhkdurzdCvINw8SqZy6yZYpdF4Lk/LPn3TmN+5DO7sLF3rNoVVhgzHDAnZkas/cjPBBLocq3sRb7ioftx27cKlRoy3lCFa/YVmO5dVAojBv9TOaJVdlmAei2DiQtel6Wl13AP4nQXttjcnYfxNNDXBZDmZtfzCGAQ/h75douEu1x7G8QHNZybj8rSASR47Jm877Fr3kgcGvsyp0l42YwTgUMVDDtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vBlosykQ+lr0Mh2eUulASGTK4YsbBFUk6Gshz6+i5mY=;
 b=Lf2C2miNN8IFFFWLKgABs/LJkQGnPCdr6FEZz0Ufzmy2jOB8VTGvZ3jP0RLuSJPIIBazHGCHrn0gqhvPY0Ltb3kosLLjljiU2lgLh9TL6XbBtUdSg7RxeaRtJXHG5hkZhMVSVUMBWOjSxo3HZWHmb2X95PriiCGWDk4Uc2nHC38F/ZW/VO3pbcq5ZkpHBwbmgMukMZQC9Szm+eHGd7aTqGq10fcKVCoqKoWBh6dmX7yGXuH+JZQy1KrdyAHTJz4dKzMXpRYjz5IJfGQ4yE8VDFwHilFJJkU/0TV0c2d0piaHfRrdc2Wk5J2qRyRfKx/DL4WG0gF/b1W8ANpQfMg/Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB6285.namprd11.prod.outlook.com (2603:10b6:8:a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 04:20:46 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 04:20:46 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 9 Dec 2025 13:20:42 +0900
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, Chao Gao <chao.gao@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
Message-ID: <6937a39af3315_1b2e10021@dwillia2-mobl4.notmuch>
In-Reply-To: <20251206011054.494190-8-seanjc@google.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-8-seanjc@google.com>
Subject: Re: [PATCH v2 7/7] KVM: Bury kvm_{en,dis}able_virtualization() in
 kvm_main.c once more
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0246.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::11) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB6285:EE_
X-MS-Office365-Filtering-Correlation-Id: e3e34e2e-a990-4d49-d4cd-08de36da5366
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MHZ0UktyUnljUEowRFBRMEdLNmU3Z0NMT1Z6d0xpbnVOUmNOV0VlUkNZVVdP?=
 =?utf-8?B?VWpCeVloeFlTYzF2NVpjNWdBbXBNa0oyV1l5cEZEempjVmlpWVdHeEkwOGhz?=
 =?utf-8?B?NWgzZ2RSaUFKa3ZvbEZzMXdIaWNKVy9kNVFwdHhnL0RZTG1TNjRTOHVta1dE?=
 =?utf-8?B?eWFsK2ptT044YWQreUFjRG1hT2dTcTU1N0trOXVHenB6MUladFFjaWdmdHZT?=
 =?utf-8?B?YkxSMEpJdFZnN3pMTHNJQStIL0Evd01OSml2TS9CeWlpMVp2VGpSSE5pY3la?=
 =?utf-8?B?NGpzNGZwaFpsbHYwa2p6WS95TDNkK2ZTVjE3cEFBWVlrVlppVjZWTWJwZWYr?=
 =?utf-8?B?dklVLytwRE1vd281cEJxMWxTQWVzaXRzWmtwY1dFZVZlbG9OK2dGSWpOa3ds?=
 =?utf-8?B?dHpMRG1WYWZtM2tPUUNhUUhSUlV6L0UvVWQrVUUySC92bjRWMG9wWmxyR0V2?=
 =?utf-8?B?QkkxcE5UMm0xNlpJTm9TWmtnL3lUMDNIYnRLNXdnM2dZMTlnV0NmbG4wM3cz?=
 =?utf-8?B?VXRCdm5hTUZKQ1dkdHZ4Q3prZHFNenVoSFdQK0tQMGY3djU3STluRDkzSkk4?=
 =?utf-8?B?NXM5ZnFEMHJ3d0tySmJpQXVrTW5kM0g0Z0FheDQxeUI5alZuNUpxK2RHMWoy?=
 =?utf-8?B?VGJIcllRMGVsenBQZ2ZianhYWGhHbFl2VjBpWkdKdGxwT2ZsTUgvWkxJYk16?=
 =?utf-8?B?VzJmOHJxb2JUSEY0VVBIdHllTzJvMngvL0RSRGdONmc4OXJjSDE1dVlSR01O?=
 =?utf-8?B?Q21lQVlvN2RRVDRKOE5KeVVJT09BSjE0clhoaHpLQ05OdXR1dFExOEYwRisz?=
 =?utf-8?B?SkM4NGROOFNOWEtFVVVXaWFEK1NXc0Fma2dPVkRHWlhFVm1SdDlWU0JySitx?=
 =?utf-8?B?Y0wwVUZzeEZLTHlLMWFWVHo3MjNWNFdYMEptWHNUdDM2UHVGc3g4OGtvTHE4?=
 =?utf-8?B?Y3VrRUVKM0ZqejljZlhWTGVjTTBwYWFIUXpQa3ZFandOUUNHdGlFUHF5NmFN?=
 =?utf-8?B?V2xURkVRWGZvYjFrWlEwY3NnOEc3ZHRqcGdWV2dwRi8rUUF4VHU3bFNzZits?=
 =?utf-8?B?a0VUdk0yckczbllUNXpUOXkwZy9SbzRIaThjallDRlVkMU13MGpQSG9BODF4?=
 =?utf-8?B?cUZMSnExUFNNSHZIcVBrVmZzS2FERlh4TTZhNHVEZkJJOWxQbmFBZVhVanJm?=
 =?utf-8?B?VHFhMmphdkEzVTRZTkJkV0c4d0FOWUN4aXJXS0dpYUZWT0hpSDkyV2xGd3lB?=
 =?utf-8?B?ODdRY3BqaW9vMUphckF2K3NhT1ZuS29PTHNncHJ0U0RFdmNmd2NQLzVWcklu?=
 =?utf-8?B?QnEycXU5Q05VcUhCU3RJTjhaTzR0bFlxYTY2MG5MYzd1dFFHYVJaemt5N1h0?=
 =?utf-8?B?SnAraEdFRWdmb0RSU1lNazRNbU95Umk3dk8rZGYyYWZHVzZVQWVlWlFQbXZZ?=
 =?utf-8?B?WVVlRUw5dlYydE1PeFdVd0RhRXMwMndsRVdaSGErRnpwUXFuUTQ0cXVicU1Z?=
 =?utf-8?B?clVBOXoxZWNQTEZVMnAwRDl3RGgvM0tjMDl0azBJSDJPOVhNdFpsWU9RQW8y?=
 =?utf-8?B?cG5TZGdxUStNMG9Ra3ZOMW1vaU1CRXdtSnRrUGE1VS9ENmJBdjJ3VjZFbHRV?=
 =?utf-8?B?Tm9xSkVEVWJPYjR6ZE5PM1p3WEhnSWhoeGZqTlJmTDRTUTNYcWl0MjJ5NFJ0?=
 =?utf-8?B?bVpKczJDc2hXV3hOOTFpdGErd09rRHBkN2EyY0lzL1BZZlRZNmFlcTdKU2pD?=
 =?utf-8?B?djJOeGFXMFY2M1RHdmkyVjl4RVluNG4yaXI3ZDlNbGU2elptSyszeHdTNHEv?=
 =?utf-8?B?M09Od3ovTFc1akd1VEVhcUlEdDdtMHduQUJhSGpHYXJYZTRQSFJSM3NtTXRa?=
 =?utf-8?B?ajNHWk1NQVpwc0szcFg0Z0hPUnBVdTMvSE1MOUliZjhkNWVVQ2ptOG9XM1F3?=
 =?utf-8?Q?XaYcyQKYyib5jDAHacbtbnHE9WkfmWk4?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dldQWDlUT05wSkk2TVdPb05Mdkl4SHlPMmk2bFNqSE44N1F3R1ZQNjFqSjRJ?=
 =?utf-8?B?MlcvdXJPSlpLR2txNmIxSVM1MHpqcGlxOTNJZGIyWXdMTnFDNld4NmJ3WXZT?=
 =?utf-8?B?UHhGZ0RHR2h4Uk50dDVONnV6L1NWYUd0OWt4L05nb09TY2puUlBtd0piQ09N?=
 =?utf-8?B?WmJQVkhrc3FJVG5pTkV1dmZxOFNvMzNaaG9LcURqMm00NjQ1RzJNZzdFb1B5?=
 =?utf-8?B?SFdYaktnZFFIb2tMNk9GaXdmTCtCditYYi8yZmNPcE9uT1V6OW91d3pMUVNY?=
 =?utf-8?B?T3hheHUvOFlFVnJuUzhGMjd2Q0pZTjdCckg1MGQwZUFUOGN1bFB2d2JoUi9G?=
 =?utf-8?B?RTRkRE1QUDVOVUhZWmlWUUpVVzYyMW4zL2F5Q3dNWko2Qi9FRUJjQy9hYlU5?=
 =?utf-8?B?K1ZPZi9KVEszdTRXZjBPMjhEQmQ3MjBwUXA5UXY3bWN5RzJJRzIvdTk1dzdY?=
 =?utf-8?B?QndsUVoyUFVKemZiWEQvbnk5RkpCRU96TkF5bXNxdElYcXBjbEFrVDRKR2Ry?=
 =?utf-8?B?QlZIYUtEdkRhaGxvZjBvUktNdzVSR25QZmpmNzBKT3pIUU9vQjk3YlVsNUFJ?=
 =?utf-8?B?NmlKbEZwRTA0dXBKcDJ6NmxxdURUWlJwRHlWcy9scEc3NXhoKzFIbitKNE9k?=
 =?utf-8?B?aVErekNnK0c1aE5OZzBVeHR5YksyZjlsbTV1aDE0VXBxT0FodnBSUmk5Z2Ew?=
 =?utf-8?B?WTBTM3Mzb0xlTFd2bVprbFZYWWp4NUZiTDdiazBMQTQ2QlRaeEM5aWtTZThL?=
 =?utf-8?B?RTEyK0xON3hrdllqS1dmSCtZQjBKL3ViM1lUNklrVk0yWStPTHQ3SXBHRXln?=
 =?utf-8?B?MU0xM1dBNmZOaHorWHk4cnlabUxGQjhITmFKTnVTY2RPeStiUEFlNzhTY2VU?=
 =?utf-8?B?YlovY3IvT3djcDZ4ZWhsaDlpd0Vza0NtTHdESDVuVGNwaEZCaTJxVENpcDFP?=
 =?utf-8?B?RFhzNUJhMW9lVll4dWRpaHFES2pvZFVWWjR1UFNnbkJvZzJrd3B2M3RpVVhC?=
 =?utf-8?B?SitiY3d4MWNZck9LQ1NHQm5MbEpqRklkYkNvb05sNmlvSExNNTB3OXRkaG4x?=
 =?utf-8?B?OTMxWjEyeFF1VE9XdkRRcDZ6MUpVNUltZVlPR3oxNVJTclB0a2dlUFBzYThX?=
 =?utf-8?B?M21TWVZNNVd0VFMzd1ZlR1g0M2N0R1lLNzIvdHNqbGNaemNlVkQ0amdkWHBO?=
 =?utf-8?B?N3hHdWJPNXpqb3o0L1RudzhkWW5jYVJEZ1lCWFlWYTdYbkg1UnVvRkRZbmdN?=
 =?utf-8?B?RjYxNE8vOTM4SVV0L09Lc2xpUmdEUmNscU9PaW0rQk9aY2EvZ2tHYnVSRmN3?=
 =?utf-8?B?YWVITSsrV1lmWExqWXBlSkxidkVyK0tsRERrWHlyMjdBNVZ0cFNGWENBSlU3?=
 =?utf-8?B?ZTRnbStYYWozbG8zSFBTZVpoZXdVb0UwTTdheGFRZS9YYWpZdlpNSVExVG14?=
 =?utf-8?B?dHh1bktDYk1hY0ZWZnFobWdyeFRsUkhFVzZONUYvWEMzalUzalhibDRkQVNk?=
 =?utf-8?B?SjNZQ0RrM1JjWUJ0VVdwYkRKQThHRzZNN3ExdG9ScEE1TTY2a0lWK1J4cHRC?=
 =?utf-8?B?aU94MUdKemFYMDVac3QyTXhFR1c3N3BlRlRVV01CSFoyVk9RYzZTN2hLTVo0?=
 =?utf-8?B?MHJvUm0xWTVpUFJTUGpBcW53OFY2MGt5dlFheWpNZXh6Um1HNmNpcVp0bzZL?=
 =?utf-8?B?T3VuYzgvRDJDMmtOWGhRcVZ0K3JqUHlLTDJWUUFNbFhrQVFub28zVk1vU0d3?=
 =?utf-8?B?YUpDOHdLbTZMQkZBNnY1M2d5c0llMGkxanYxRWM3emJWcUUxZlFnU29tT2pt?=
 =?utf-8?B?YjQ4dkRDbGtPKzFEclJOMmM0MGUrWm9IU3lrRkxIZGNvQzI4ZEpvdUlDYm5o?=
 =?utf-8?B?cis1YUJEVWFUMXRIMklGTENyU1h2K0J6eEZDNGVnKzU1bVBnaUM2MHBubGxX?=
 =?utf-8?B?Mm1nL3IvY0ZIY0dzQmFyVnpPMWhHSFp0TWg5UVB6WW1yZ256YWw5aEZWZzVu?=
 =?utf-8?B?Sy96QkdUNzREOExuWGo4QzNmdDNCV1BHeWlHRmp1Mm9kSmFRNktCYU1wWFps?=
 =?utf-8?B?NjZYUm1Ta3Y1emEvd0VRUFRTRmJadG1JOWFmbjFNRWo5aGg2ekJOUEVaTmgy?=
 =?utf-8?B?dGdpcXY4d2dUSzNKU2xldDZLSmdNSGRmQW1IYWgvL0JoRDdmVE1xSjFQZGxJ?=
 =?utf-8?B?QXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e3e34e2e-a990-4d49-d4cd-08de36da5366
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 04:20:46.4939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zWERJxG3WvUx8j4Y37WvsccPCoX/0sFoQfKLmt6TURF8ZX0z5P9jB6i1ugcXZW/r29XT6fNoJCqbo8KFevR9dAqbofRdhuFRm9p5ZIS6hxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6285
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> Now that TDX handles doing VMXON without KVM's involvement, bury the
> top-level APIs to enable and disable virtualization back in kvm_main.c.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

