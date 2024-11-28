Return-Path: <kvm+bounces-32650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BD479DB09A
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74DA0B228A4
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6CBF18E25;
	Thu, 28 Nov 2024 01:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W39sAl1j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C002C847B;
	Thu, 28 Nov 2024 01:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732756023; cv=fail; b=mcg0exZZq5SMeCFbnT19g5qLKy5Fmklxp7IkuZc+YVh2A7iN6qiLYM7nbC5bbrcHNr9Om/mix/eYUlypL2cf6KWtK9Q56je15MvHK64m9T1vSZCw7ooY/AqwZi6oN1ZEg9yELeTkmnTxIj+9Yx8CiKmZpby93kJVPgTXIxkI6DA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732756023; c=relaxed/simple;
	bh=ugEztsEu43434Bm6UUOEWRCQRvtsDEMiYGmmrkdK3NA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iijTNl/in6Ma2AiQGKmpQFt+Lbu5qEJwmOYiyg8LJSsUZSxJOEc5Hj2EWN/OR3OSRCqmmNiIDUrdwClsgul13Gy5+1jMLjJUGv75POSDCrXo9seLzToyhxJOUR5Qlefg3/7Yz7JoLsaZeCNb0w6PcCSRGpvPIeuROfpTNKjW4uM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W39sAl1j; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732756021; x=1764292021;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ugEztsEu43434Bm6UUOEWRCQRvtsDEMiYGmmrkdK3NA=;
  b=W39sAl1je94Ru8RQFBb804r07aiYFtEpbgtdm2xVn5EcMIIRfOQvS8rc
   tEgnqtFZcx28vBKalmZj7z0KWTW2xhOHZKx7YGBQGdq9QJog0HAvY1ot6
   Oy1WrNaha+PCtLsSbRQrNi4Q9yN/sWHqiVXu00DLtlpa1MwV/H6yaBHsb
   RjXuiM+AImh31akGW23cIJh4HO7E3reE/yh3QJP1ZcTj44APvenDvWuOy
   +q0Aa+PWypQXr+BSE3KtNwZ7bC9WPqMc2YoMeQ9HCVLqIWFJxG5tbtxNP
   OHBJ+tlnVzpZ3sV3tPz0ot3H0kmZnkmMBBXB2gE4/A6hyERYf7vnk2no7
   A==;
X-CSE-ConnectionGUID: Mvezbiy9RVuLkGGX2BHcQA==
X-CSE-MsgGUID: 8M6+fJcwSkiLrai942whtg==
X-IronPort-AV: E=McAfee;i="6700,10204,11269"; a="33123766"
X-IronPort-AV: E=Sophos;i="6.12,190,1728975600"; 
   d="scan'208";a="33123766"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 17:07:01 -0800
X-CSE-ConnectionGUID: 6grxH3k+TwWDSjHHEPuXzQ==
X-CSE-MsgGUID: SXZshIMuSAWCHpEB954kRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,190,1728975600"; 
   d="scan'208";a="92416049"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2024 17:07:00 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 27 Nov 2024 17:06:59 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 27 Nov 2024 17:06:59 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 27 Nov 2024 17:06:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=scXqFtOyUpE9LaS/eEaJpsSjbIiCSB01b/9VD7l2F/UnKyGwpsvULOTQSEVHWMbHr7h19Z8x7l0gLF5zkF+Ky/1CGSg7SRPbqcDS2FU+hQ5fHylw5JHYJoDY3j0ADyWd0mpbmY4ar2tPksO9wsPkvL9IQ5ir6fkcyduvfe7evmHoRcy8YKQx2v7hzf5uJelVUuC6QJSG72kSTgI15604ejjckARueC5sps5MMS1F9Atb9byMbEzm3BWa8KF7zoERWq6DyQWSThssTbrG//Izfp5shw7YIzNDQ8su4FMm7vkqlHraDfeG3IBWjR2uk54Rih5mzlHJVfNGLLNIe9muaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugEztsEu43434Bm6UUOEWRCQRvtsDEMiYGmmrkdK3NA=;
 b=R+JEmuTSLehpoZAbaNlToYBdmNWWsqX4x3M0kZKchbBIYxRTvGWVtLeVxFkTHqVj6FmYjzluamuNVSchBqh93iRTX7t3XPW0os2AYgM2q6sYhXFILh/wxCaiK8+8L37cygVVWYjGOKhVQaJfPt6n1nw4i/REZJkOqzJpY+59rCs51ODlajVga1KKVKQnpP372+i90XpphtJOkHzy8ogoNa6q2b7BWGdg+SmZOxZBGrZhhxIdp8WrFWexbstbyZs+Ayix4aPEEKJr18Ms3KEGhmu2Cplt6juCkGzGQDiMIzjKTz4+Z9SxFgi1rApAPGcWY5pwCPK21PRpgc6Kdm+sOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB5121.namprd11.prod.outlook.com (2603:10b6:303:98::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.14; Thu, 28 Nov
 2024 01:06:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8182.018; Thu, 28 Nov 2024
 01:06:56 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH v4 0/6] KVM: x86: Prep KVM hypercall handling for TDX
Thread-Topic: [PATCH v4 0/6] KVM: x86: Prep KVM hypercall handling for TDX
Thread-Index: AQHbQS6ZiBJbljzi7U66FqEJbZHzRrLL4T+A
Date: Thu, 28 Nov 2024 01:06:56 +0000
Message-ID: <9fc1bc289254af9953e1a65ea7573facd0b54ac6.camel@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
In-Reply-To: <20241128004344.4072099-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.1 (3.54.1-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB5121:EE_
x-ms-office365-filtering-correlation-id: 13dc30ad-9ba0-4094-af76-08dd0f48f404
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WFpqZnVpZTVzTWFMRVpidUtVb251djkyVkhoN0JwSjRBaHlVSkhJVW5SY1kx?=
 =?utf-8?B?NHFaY28zYjQvWHdTczlwNzhHVlU1VlZnMWE5VWVEemtmb1RWemsyVW1BbFJC?=
 =?utf-8?B?SnIwNVFTLzNzeDVpcFVaRnNpenA3NE4rUEs3T3Z4MGRRVUc2amh3TEV6Tm93?=
 =?utf-8?B?Mk84R043dWFXWVMzYzJZOWRqVzBtb0F0TFgvOXV0NlJCNWR0Y2tnN3JZV0tD?=
 =?utf-8?B?KzQ0bS83RzJESWl1dTZtalBHVXZPc1FzQ2M4ZmprSWtNWnU5eU9NOHk3YTZ4?=
 =?utf-8?B?UG5CbnpzNWoyTDd6Q1J1akxnWkpaL3NTTnFKanZWNFZWYTR2TkxhWFluNzlM?=
 =?utf-8?B?RWRhb3RrTzBySGtBVTczQ1hGWGp2NmJjS2JBUVNYb3FJMFBKdytrOEY0NDls?=
 =?utf-8?B?MzZVVmJFRkZ2ak1WYnhnWDBCOVBobzR0STA4dFZEL25Sa2JxcXl4WFczNFFL?=
 =?utf-8?B?aXJINlROblNaL0FGZkZzZThtN2EvTGJpbkdOVzlyS2RRZElweGU2MnZZdVcy?=
 =?utf-8?B?KzB0YzJkN09ZTFg0YnVFYktHak5FTjl3Y1ZUWDExTW5jRVBKV29TeUhuaFdu?=
 =?utf-8?B?Y2t0Q3F0UzBLQlBGSzlTN1pEaE9McHhrRU9kV2dwWGYwaFZ1eDhLRHk5bFZF?=
 =?utf-8?B?cVhla1JlaVZ5ZGQ1aEV0N3JxaUduS0Q0c1B2azdwWVlPd1hjNXM0YlFzZ1ZH?=
 =?utf-8?B?UlRmVVJuS2RLbDFkS2FYT3JxSXYzRitjQnJaWUUvNWVGakE2d09UNDlTVlha?=
 =?utf-8?B?SHp3V3pKb1JEL1RqaUI4TW5nQXRmTUdWaVVMUXFQQW1HS3BCQytJaGpVSHhh?=
 =?utf-8?B?MVMyQ1lZR1JKakNyaUwrVkJ3SGVDK1FTRGhodGg0YlQ5OTZnKy82Y2RnbTE0?=
 =?utf-8?B?bFQwUExvUEdHVHd4NC8vbExCNXFmQ2FQNU9pYnFnN2lnaHBSaWgrUU0rMmNr?=
 =?utf-8?B?VzdQdmFDNjRIcC9uRXUzN3hkZjF5RFZlMk8zY3N5QWJ4Z0U5Mm84ak1CcjAy?=
 =?utf-8?B?ZjN6bHdNV3Q2VFpJV2FNdTN3MGlaNWhWTXdtWWJXbjRHMytkNE02ZXpkamlx?=
 =?utf-8?B?bnZnckgxdFp0WDYwTXZtRkthK25NbEN3YWY1WWlPanBQeXdRMEtPYmZIR3lP?=
 =?utf-8?B?VVRjQUthc2pCVkxOUmJ3czg4US9lL2puSlZJeVd5dVNOT0pHeitSTVJ6KzFl?=
 =?utf-8?B?a3FXMzErc2JuUG9UQWFONE82ZmZnS29WRUwxZDhPYjZSVDdUU2ZkMWovWEF5?=
 =?utf-8?B?V00wdFVqRUk5dno4WG9Nd0Q1MWtFRFk5UEY1QlY1Nm9vZ0NQbXMzT0ZJMHEz?=
 =?utf-8?B?Q0NkTHRhWlhlK1hHOXVUV05mdmJoVjlRL2ljeHpPQyt4U0dDdFNIOVFINlZJ?=
 =?utf-8?B?RVFlK3lOK1hWbzNhOTVYRC9VYmRER3BOWFNVcTNxTXhmMm05R0RaMU5yMVNJ?=
 =?utf-8?B?TjBCL1JGNmh5c1NDWFVWWWNhY1pjeHZFalNVQzNDWU5XbSs5YmFteFA3RVh4?=
 =?utf-8?B?OTRlZXZQNkFnTFlpSlpKNTFlMGwyVnhWWXIzckg5dkp6WmxYUktTeklEcGti?=
 =?utf-8?B?N1JPM2R1dGVOaXhVQlNzUkkvTHZPSUFmQ1RzOFdFeWR3UENET2NoVG5lcFhl?=
 =?utf-8?B?OTQ3cG04ek9OKzNLcW5TVGNnYzdza21UQStxY2t1TVFQbHpleGpGRTdZMFlv?=
 =?utf-8?B?dlVoamFycnhERHVQWmFDRDBTTE1lazVmZ3FndFp0K1Uzdy91UXFjOFVLUElp?=
 =?utf-8?B?RzMzOXRidkhBY3dpcnM4WVVZOHdKS0M4dGplRDYzQSszK1I1SGlwd1E3WW5q?=
 =?utf-8?B?cVVTaFRFMDhOMFRmRTc2c01yVHB3K29OenI2ai83YXlSVXJhSjZoVFBSa0tC?=
 =?utf-8?B?UFg2ZitwYWpORU9GTjFENHNGTmlNNTIzeStMa3RkWG1LNnc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0N1Y3UwNVY0VDcvbnNlQWVVT2VJa0tTT3U4V1NUbjJwVm43QkV0cmtFb3Bz?=
 =?utf-8?B?ZXFKMWZhaGI0ZzFKenFXalllWmVQeWRZN2IvOWZ1MmpHdmdqOU1welV1b1dz?=
 =?utf-8?B?aWRDb3AxUUVQNlNSSk0zTTFwN0RGV3FjL0ZBVmlDVUx3b00vbGFhVDNkRWcy?=
 =?utf-8?B?TVV3aU9YUEVmQ3ZzMEVKaFVzM1gwNVgvT3c2bVpoYlArSXErc2lzRS8rUWR3?=
 =?utf-8?B?YytJUzRrVHFyalVmY0MyUzJjT3hrVEdQMVM3cm9pa1NEZzVKMTFTZm8wRHM4?=
 =?utf-8?B?cmNnQ2hoTjY3YUZRQStMNVJoUkovak8yWDl0cmhZRTc5NGZxaVF3Wkl6SFhE?=
 =?utf-8?B?eFFQSnZUS2N5TU1JSmYxSWs3WnRpKzRhQ1hKbHBYMXdJT0lLWFkzUXMzbHJu?=
 =?utf-8?B?aitKeHJyd2t5MkdUdVJzbTc4WG9mQlNLUVVnZ2pma01kdVRYNWxYWXBTTDhl?=
 =?utf-8?B?RWZyZGFjaWEydENDcmtJUDcvTk9nS2wycFphaExJZzd4Z0VZNWJSbEwvd2dv?=
 =?utf-8?B?WkZzdFZUa2pMUVRCZVRSTGNTekZZM2lBOHN3dUI5NHUvNlllVFp3UDFRSi8v?=
 =?utf-8?B?V1hYZkRBdUdWWjBHcHU4UmFhOWd6RlI1MXFVaDdwNDV2TEtmbEVSNURsLzQ4?=
 =?utf-8?B?QnBXbVJwZXllNzcrWnpsZkdyNEVQVlJCdzNra2h2cHJEWEMxZmRxVEQ0L3NK?=
 =?utf-8?B?M3UxRjdHcjJaWDFuNTJCZGpmalVaV1lKY0RVSWMwMkhtZkhpRFlJYVJWdjdN?=
 =?utf-8?B?cTAwSm9uUUd0M0x3TFlPU2xMTkF2T0xtcVJDamdPU3FUZWhuZy9ybXRDa044?=
 =?utf-8?B?elEyaHpaUDZJZ2tuVkswZVU2R2Nyakh5NGhyZmgvYklta3RoUUpPWmxabm15?=
 =?utf-8?B?cWtEM1pFaDRRWWtQVmhXVHhyU29vQXFkTVlJbGF4a0pxdDN2bmV6elU3akYy?=
 =?utf-8?B?UkNXT3dqSnpISzZlUFpMY3Z3aUQvZGZybXUwa0xYdURJUXBMaFFOZXdTZkx1?=
 =?utf-8?B?YW9ldFdLKzB3Z1VGWTJ5SXB4YlFxemtSZi9MejNPYlFIcU4zbU9TUHBxVVRN?=
 =?utf-8?B?Q3NvRHk3YlkvMHVqSXVwM0FtVnl6NkpQQWZyUGZ4Y2J0d1p4b1NXUWwvM0xk?=
 =?utf-8?B?c0J0bHhrMmpIckF3TWFxOEtyUXk5RUl2ZEQrU3o2ek5WaHJiNTBmWnVocjFR?=
 =?utf-8?B?c2Q3Z3hMVEkrNHhlUGgrK3FqdmVZL0NhSU0vZWoyZ2hGeHpOQkhTSzNXRnB3?=
 =?utf-8?B?OWRma0dHZzlBYUFYdkFkSE1wbHpDQmsvanlKN1VtV0FQU2NrSnprczRjRXVq?=
 =?utf-8?B?dTJKSE5HNUVXajFMQWtkQUJwUTR6TmsvZDBXZ0R3QkZuZlp4UU9XMG1XdGRI?=
 =?utf-8?B?dmRleGlYVXU4K245T3kzZlBDbkh3UlVvSXpBMVpXM01uY21KKzBTYzFueVpL?=
 =?utf-8?B?aTM3R1FsZlE0emtPcDNNYkxLMytuNUVMakVHZXAxbHZnMVJ4bWl5OUhvZDBD?=
 =?utf-8?B?ZDNmRW5MRnM5QXBJcmpvTzhQQUNyWEVOdlh5OFhzbnlYdGE4b3E4Z1phSk1Y?=
 =?utf-8?B?ZUpVSTJCSWdaKzZ1b1UweEFjODNyazdKaTFaUnU0SEttMDZSTngxMFZtNElm?=
 =?utf-8?B?bUZIN3hMMzI1Q3lVRzhhcmE3SUN5Vkhac2FaZmdXS1RhNFBmZDZMdmR2MXdK?=
 =?utf-8?B?WkQveEZRaG45TjNWMWxUMEZOSTRCTXlHd2pZS1M4dnluOFJTdnhkc05DY2xi?=
 =?utf-8?B?STdvYkFCUVBMcSs0TG1pZnNoZ1UrYzYyUUQ3cDN2N2RSd3NCenNmNGRITHhz?=
 =?utf-8?B?ckJFNlBZb1FKSG1zZnhTVDZ3aXROdVA1ZTFTN094bDVHc2ROOXBlakVRUVo1?=
 =?utf-8?B?NjFZWlRNanA2Mm44MVlGZG82bkxNUXloYUpNQ3lieUdiZk9Udjl3eHVYOEtG?=
 =?utf-8?B?eEFwbExhYWNwTC8rM2dacWErWnNyUWRiVC9EcTNhTFVNUjB5L01uaHNQRnpL?=
 =?utf-8?B?VTFNYVFaS0dua2JKcVRiZUR2cTBpNmtFbHdmV2JoNExhNXlUN2FyMjVON2Vl?=
 =?utf-8?B?QkJYSnJrUW11dlk1VlVYeGlHa1VBRDRNMElwRGIyVDgyNUVDOWJnVGdreHV4?=
 =?utf-8?Q?gJtKTUBmN7rKm1ETatTaB2lGQ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3768EBA48E067545A0A2C87C4B986F90@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13dc30ad-9ba0-4094-af76-08dd0f48f404
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2024 01:06:56.1866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 97+tGz2BPzDZHtyyukvaz4OYs4O77zK9Wv7U3RRqLIZ02oRARSn0Vg8bfTM9MS1H5NPeaPUCTa6Yn36uAIzCfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5121
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTExLTI3IGF0IDE2OjQzIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBFZmZlY3RpdmVseSB2NCBvZiBCaW5iaW4ncyBzZXJpZXMgdG8gaGFuZGxlIGh5cGVy
Y2FsbCBleGl0cyB0byB1c2Vyc3BhY2UgaW4NCj4gYSBnZW5lcmljIG1hbm5lciwgc28gdGhhdCBU
RFgNCj4gDQo+IEJpbmJpbiBhbmQgS2FpLCB0aGlzIGlzIGZhaXJseSBkaWZmZXJlbnQgdGhhdCB3
aGF0IHdlIGxhc3QgZGlzY3Vzc2VkLiAgV2hpbGUNCj4gc29ydGluZyB0aHJvdWdoIEJpbmJpbidz
IGxhdGVzdCBwYXRjaCwgSSBzdHVtYmxlZCBvbiB3aGF0IEkgdGhpbmsvaG9wZSBpcyBhbg0KPiBh
cHByb2FjaCB0aGF0IHdpbGwgbWFrZSBsaWZlIGVhc2llciBmb3IgVERYLiAgUmF0aGVyIHRoYW4g
aGF2ZSBjb21tb24gY29kZQ0KPiBzZXQgdGhlIHJldHVybiB2YWx1ZSwgX2FuZF8gaGF2ZSBURFgg
aW1wbGVtZW50IGEgY2FsbGJhY2sgdG8gZG8gdGhlIHNhbWUgZm9yDQo+IHVzZXIgcmV0dXJuIE1T
UnMsIGp1c3QgdXNlIHRoZSBjYWxsYmFjayBmb3IgYWxsIHBhdGhzLg0KPiANCj4gQXMgZm9yIGFi
dXNpbmcgdmNwdS0+cnVuLT5oeXBlcmNhbGwucmV0Li4uIEl0J3Mgb2J2aW91c2x5IGEgYml0IGdy
b3NzLCBidXQNCj4gSSB0aGluayBpdCdzIGEgbGVzc2VyIGV2aWwgdGhhbiBoYXZpbmcgbXVsdGlw
bGUgYSBvbmUtbGluZSB3cmFwcGVycyBqdXN0IHRvDQo+IHRyYW1wb2xpbmUgaW4gdGhlIHJldHVy
biBjb2RlLg0KDQpEb2Vzbid0IHNlZW0gdG8gYmUgImdyb3NzIiB0byBtZSwgYW5kIEFGQUlDVCBu
b3cgZm9yIFREWCB3ZSBqdXN0IG5lZWQgdG8gcGxheQ0Kd2l0aCBfX2t2bV9lbXVsYXRlX2h5cGVy
Y2FsbCgpIHdpdGggYSBURFgtc3BlY2lmaWMgY29tcGxldGlvbiBjYWxsYmFjay4NCg0KV2hpY2gg
aXMgbmljZS4gIFRoYW5rcyENCg0KRm9yIHRoaXMgc2VyaWVzOg0KDQpSZXZpZXdlZC1ieTogS2Fp
IEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

