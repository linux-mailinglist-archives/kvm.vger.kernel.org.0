Return-Path: <kvm+bounces-48330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D117ACCC47
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 19:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5356016F4D9
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 17:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E934B1DDC07;
	Tue,  3 Jun 2025 17:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mDfhk1qS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F725539A;
	Tue,  3 Jun 2025 17:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748972166; cv=fail; b=YXJRwiX60qsU71UcZ71t7jd+u7W33Ju8fIJ++fejkIrMd+fi9jI9mwi2cRHqNvMAeRVB3Z8aIiU5wk7NmBtbaDNk+6guySXPJeUmUsNb4L3lnMOz8EFAvzjiQSTb3FmrupF9bOPLsLK4WseCQjfBh/HTWhS1QoB/Ndcb0CjOexw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748972166; c=relaxed/simple;
	bh=K+3bjhf1qFjtUhAzRUhA1QJoMqlzkTcEIwyoV/+39p0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OxNpg4uHnG5AZat2wGGW+j+Fp8mNLNbDuexW6uiRlu8YbIqT3dFNoTBg3bLCrBu0RX2gE+LXmCQDRuUxy+0w8mAIBRE8Di50FV9xQ6+HuJyMNgM+l2G5/bWn/5zwM1cQjBsY6URSLgoBAUbDXv11TfDGJuW8jxcVeOjsw4GO+5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mDfhk1qS; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748972165; x=1780508165;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K+3bjhf1qFjtUhAzRUhA1QJoMqlzkTcEIwyoV/+39p0=;
  b=mDfhk1qSZ25edI1oi/8mhtvGwjoazL6ZwAdEamSl9Zo2jWrOyQ9tr5JB
   vu+OemxZg4VIprf865aM7vF5snVgA58/r1FKS4vVz4RLKar2BbDQXROCc
   XZWibe9wgSieNKv5ulzK46HHRivFwvnIECgeVY7sOSW4sFc/cRiJRsCw4
   Tp1h6X0NAKcbtsoAswpb4WqVrFdEmdiZCWB5fKIVFRB1i2+MUYCWSZqxm
   GV8m21vd513BrwIQqw+aoNnFtJknpshn2aYod64vkjfAtJ1kdbT+bwVrj
   spBdPgSpcpbx4eYDx819onxg723SHrhj3lh8VU/4fIFbhsbA5muGTrXKl
   Q==;
X-CSE-ConnectionGUID: p3CDNQPhQmyqI7g5Uamgyg==
X-CSE-MsgGUID: 5J/WCxq+Sq69Ofpsf3kNew==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="50721365"
X-IronPort-AV: E=Sophos;i="6.16,206,1744095600"; 
   d="scan'208";a="50721365"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 10:36:04 -0700
X-CSE-ConnectionGUID: fmcjhHFbSgueaHaFu/vcUw==
X-CSE-MsgGUID: 7IFufVjQTPOn2VTGsZqEqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,206,1744095600"; 
   d="scan'208";a="149814470"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 10:36:02 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 10:36:02 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 10:36:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.83)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 10:36:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y7V3+SYGEFYKuV8nTnwk3aRBFSJHknsDSz5Gfo3tO5sY1BsxKqKHhMZRtSNrZba3jsEH5KjTdTf5HzZwKdxlrH5gvw5u62DAfK5AvfDdXSowCrDCEPeP5IlOBOvemLgLJs0k4ao3/+rR9mNWKrdp/zWsbKoCLG/lSmdjqwR8333/ZLtaKICbhpkNzGn6gUfrpT/6fNwbeUrHDzKIPWITk4y99728vgHNh5MUoZxYlB3C573ZrgfPeSUAY+WRVi4KDsDw2kUuOfz0VRiGRqF+4KR3W+6k+8k2Q5RkLd+JRnWYhzBd8LhWPOyXNg1iGRE6yjjJeSkn9F/UGegjhRQqUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6J/+1sikRkVg4iSCjJVYf4IUnA/RYdz2zbyNPLfFKMk=;
 b=xqUO96BDtIqqxMY1P9/lCXbXi7xtR1cHVGyWCGPKJc6ozWFGUVAoIx5L/YM85mpn6RJf3QZMHF4swDm9vuTUomrLLoFNM8Ph/azFNCQbMl3x3+gvmf4353MT9AA1GXonXzzWadWaWrR987JBqxXgA6luvqAjaijgfYyVRuZCwDrX35bC1vn9inoDi8NLGTjgewBUIUpVfXjFsdqbVdV5/A54EBC1onvgMf9OnsTnX8BIs5DroWy+vD+uYLLSbaF1UmixEZ0nAvllp0ag3KNSvzBOOvRUZait6vPV0HOwGVDHyzAjNpr8OHK0ZHwBL3Zg9yAOLozAjH/0XQUB6aDTkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by DS7PR11MB6272.namprd11.prod.outlook.com (2603:10b6:8:94::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.20; Tue, 3 Jun
 2025 17:35:41 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8792.034; Tue, 3 Jun 2025
 17:35:41 +0000
Message-ID: <b85964b3-155a-4f08-bb17-9cefbc527a2c@intel.com>
Date: Tue, 3 Jun 2025 10:35:39 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/9] x86/nmi: Extend the registration interface to
 include the NMI-source vector
To: Xin Li <xin@zytor.com>
CC: "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>, Sean Christopherson
	<seanjc@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Kan Liang
	<kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>, Zhang Rui
	<rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Cooper
	<andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
 <20250513203803.2636561-4-sohil.mehta@intel.com>
 <5276d1ff-be9c-4391-ae64-4f7451f6ced8@zytor.com>
Content-Language: en-US
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <5276d1ff-be9c-4391-ae64-4f7451f6ced8@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0014.namprd21.prod.outlook.com
 (2603:10b6:a03:114::24) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|DS7PR11MB6272:EE_
X-MS-Office365-Filtering-Correlation-Id: c1ba874e-daa2-4935-e86a-08dda2c50f67
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YmFPQWVOQm42YXhEelViS3ZLRjFjL2hzOEpEZFp4bTRJUVFJeEtQUWFwZ3Jm?=
 =?utf-8?B?N0FEMUozaFJiRzUrNzY2TEM5bkRYTHdFR1dYbE54ektkT1NwMHU3L0E0NDVT?=
 =?utf-8?B?d1dzczZ3R0IwSDhYbVRINGtmQ1RrQTBwVGthdk1GMGhhOVpmSHErWkV4ckRn?=
 =?utf-8?B?aXJ4WXRSRHZwRy80R09QdnovSnBrWTJGa093N3cwbWJxeTZpenkrVEdHWity?=
 =?utf-8?B?dExhM0VaSXBoUWlqNk13KzRSYW9INTY2VDNqWVNXT01wOXNvcTh5Y0FlNGk1?=
 =?utf-8?B?em5hTDE0TS9iaERQU1hrRVc1U010Y0VGTGN3aGViM2RRclVhcTluY0cwc2ZK?=
 =?utf-8?B?czJsOUQ0NkhrQU1pak9TeW9HZnBkTXRjcGhLSjFGemdrcmZ4VS9pTlhxRG5P?=
 =?utf-8?B?SE5EN09mZnR6ejVIR29JY2ZFaFlKalJuejlBSXFnTS9FTFFaRjE5S3lGWWZu?=
 =?utf-8?B?RmJZMHAyaVNOMytLTnVnam9QZWN2WUZSeDFldnhwUlQ3aWZIdXNIUjVXbVZo?=
 =?utf-8?B?OXlwV1RHdzBzWVN2SEk2Y293YVJobzlrRVdHOG9KTEN1WEZyL0JkNjJDOFVJ?=
 =?utf-8?B?WXhXTmhObU1mQmlTaUozTjl3eEIvZjZoNm1ma2ppbVdwZ3BsQzZSWDFOaUsy?=
 =?utf-8?B?SExyNVRncjFYazdsenFDTTNyWVFYRU5MVkFWOStNZXlJUmNWT1VCYnZyMkFB?=
 =?utf-8?B?ZVdDU0RQd2hXWitjWHc0bmpydjVSem1ybFV0T0hJcklNNlNCd0c1WDBHME9T?=
 =?utf-8?B?T3JpaVlFcWEvK2dlZTlBOEN1Q1FWZXJLc0NXRk5pcUlwQlhqZWhicEVwRGtl?=
 =?utf-8?B?YU1xc2NNdnFsRlZWWjhiZEsyNEF3cmMxRTlBN1lyRUtoY1BuVm5TK254OEdq?=
 =?utf-8?B?bS83TytzYzVYTDNwaWc3YzZaR2NESHlzZWp4eDRLaFFwbFFxOUd4T2pZVGNx?=
 =?utf-8?B?a2NnUVRNa09GTWs1Zjk3dFpWTHpSaGZtempTeVF3NkYrRjl3elViSkpjNXpV?=
 =?utf-8?B?RUNsM0YyQmNSOU0rTWV3OHFNRXBBM1p3YlhUK015THFtTUxmcXVMeUV6UTht?=
 =?utf-8?B?MmhDb1d6cmNiNlJLbzJsUEFJSTR2UTE4V0lnZFI2VlQ5aGJQajBPeHp0K0ZV?=
 =?utf-8?B?ajBudFZseWNldGkveDBGRDJjMnBNa05rOVN5UkxMdUhYZC9XOE1xZUpTbFha?=
 =?utf-8?B?R1drV0RsLzRITWE2cVV2OHl0b3BZZEtDV25rdE9qTGJZWlMrRnMxVit0MWNE?=
 =?utf-8?B?THA4TEJMdjB0Vk5nOWZvSTRCMDhxRTZsKy8vL1JLcmM4NURYY2llUWV0REN0?=
 =?utf-8?B?aFdUY1c5ZTY5amEvZUx5S2lyWXhtaXVkbUlHajZiOWR1VUQ3QzhSUUE3U2Fu?=
 =?utf-8?B?cEJKWjN6LzF3WU9MMXBtcGpEWkFzREhkZDlrbkh2cmlsejVwbFNxamJVZW5E?=
 =?utf-8?B?VDRDTUNiZzFRRklINmNKNUI0Y20zYVZwSmhtcGx6SUVkdEFkUzVEdFRuMWRD?=
 =?utf-8?B?emNmdWswT3lyR0Q0S1NhUVZHT2hKNHZhRU1FVmhWeG94WXF1dVdHRzdtZk9k?=
 =?utf-8?B?UTVQTlNyY1BDRGFkSnFtMXNPaWtLN3lBeDk2YytlUWhXYjA2WjY5Q05pV2pa?=
 =?utf-8?B?NFpHczRJTnppR3ZHa1UwY3A1cHU4dUF0UFRURW5JU3dsWm1WY2xGUVpiTG5G?=
 =?utf-8?B?TVUvbDZvRlY4eFZxajhraTNwdXJwZ3pjMjdBWDBmRmJ4QWNKMnY4QWd1ZnM3?=
 =?utf-8?B?T2dLckQxbUV4a01zbDRRdlIrcXBCcHorOGVzUC9wL1BtSVNtZXRGNCs5K1cx?=
 =?utf-8?B?Ym5aSlBGWXlnUVV0ZGtHR2NUM3JNRGo1WmpGNEVNc0FkaUFLWDJxdU5QeTBH?=
 =?utf-8?B?Q1RpZERKYWQ1YndhZHUxejV5cmcrbHAwM2szd241amc1cGJWSjNaWWl3dDNu?=
 =?utf-8?Q?6F40hEiuSDw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3EzSk9CMndlVVlCRStzbEZuVGF5Z0UvdjRQTnFHeGZLNi9ySFJ2dTQ4ejVj?=
 =?utf-8?B?WmJubHNYZ1FpdnVYQTUyN1pidCtjVTRSaHdQNmNLbk9LYXFqalFyckNTbmxK?=
 =?utf-8?B?UGFUYTFyeS9Mc1M5Y2NFTG52QU0vRm5iZFMxdlcvTDBCZkx6b3QwWnVsYUZQ?=
 =?utf-8?B?K0t3Qk04UmxOQlU2bG5USVE2RS9vbHFPaGI3aEJuOHZYdHAxTmQ2dGYybzgz?=
 =?utf-8?B?cll3WlhMdHlXRVY2aE90dG5tMkplOXBpeTI4NENDQWZkVDNLMUUrazZkOVdz?=
 =?utf-8?B?UWc5OVlyc3diWjlzKy9FeVlyTWhNZmQ5THJsK0EvRWtKWUt5TXN1Z3VvOHlF?=
 =?utf-8?B?bEZZOGJRTTRDWElST0VialVxOFN0NktRZTFqRDFkTmJjY1d5RmpTVTNWS3ZU?=
 =?utf-8?B?eFMvUldwYkU1dlAvRUxQWWwzcG9jNVlYVVArMWtRaDRlNW5ZTXRlRUZxS1JQ?=
 =?utf-8?B?Q0FCSGRXd1FJY0xmMVI1d1EydEJ3Mmg1UVBXbEswTVU4MkpmaE9tb0xYY2x1?=
 =?utf-8?B?dFF5YWJ2UlpvL1ZLV3ZGUFJOMElraXVTU3NXaU1TZ0FrNUN5aDc4OFVnR0R3?=
 =?utf-8?B?cnc4UU9pc1Rnek03dHZuVmVqUnhkYzBNek9aYjVMNG93N2ROMHdlMjhCKzEw?=
 =?utf-8?B?SFZqTnBrMzNFakEreVFEZ1MxdEhwTldMN2dEUlRrTnE4S3BKbmE3UlJmWEVC?=
 =?utf-8?B?aHNPVmxPVGk2RE1ySXVkMHNmSUN0ZFZVbnJvVGswVDhjQ0F2MDBaYmljVVhU?=
 =?utf-8?B?Y2VkRElYdGJmU2c5Y094bUd6S2lRSkNicXZRN2txM2tvZDR5Ni82SFZyOUxp?=
 =?utf-8?B?SHNFRFhFODlLakVrR3Vsc2Fvck14RElRdWFkVW0vb3JoUFJCU0xwREt4dmpH?=
 =?utf-8?B?R3lMVkRtenNHaXQ1WktTNVgvaUhORFBQUHFqU2hwaitJNW5XZi9RRy8zV09U?=
 =?utf-8?B?d2FKWlZJb3dURSt1WndLL1BQbEhkVTBIejM0TFgyYlZwYnc2UTM4UzU4V2NJ?=
 =?utf-8?B?OGVZVisrQi9GeHZmTEVkT0t4UUxKVHF5TDlpMmY1RU9TOU5NN1YvT1BKdFpk?=
 =?utf-8?B?cGI5THZqS0JIaGlmK3VCU3RuTlhjZ0RZQmxHZFE0MTRmRThFc3I5dTlxTEpK?=
 =?utf-8?B?YytQMDRyVnZuK1FKc2d0dVNHUm54N2k0MU9MNWdwR1JuQ1k2YWxENzlzdWl6?=
 =?utf-8?B?L3A1ZnN1U2pZcUprdVk1T0NCY21wdFFxSDhZUmF0RFgwOStsSDZzeVJKVFYr?=
 =?utf-8?B?TFYxeStYK0FWSFFOeUxwclhlNjA0SEtMbzA5bklncnV2Tzg0ZnBVVld5S2t4?=
 =?utf-8?B?VE01Mi9ZUlFGSTVWdm9ycWN6K0taYTdYc25od1JjVmZaQWhUTGtDbEcyTjJr?=
 =?utf-8?B?bmIrWG5wUTBYN05FZHVLTmJrYmdUK2JZMW5RTnlna2NueVpoUXg0eFFtSEpE?=
 =?utf-8?B?bFFiY3JRb3JVTm4wWFBvb1ZGcTZzMnNUbStQQ2VFcHBDamZzYTNnYkw3OGNI?=
 =?utf-8?B?VnRGdnhuekd4bXQwMVRkWUZmVGpRVktibjFzQW1hVEpDVWZhRnlCdWhJRkdX?=
 =?utf-8?B?ZmlrUnYzaDhQY0N1N1lyRmExcTdFZEF6ZjhHOHVNQS8rT2IveFZwc3VCT1NX?=
 =?utf-8?B?Z2dMMUhHOTlIeGE5TGdyZFZJc0FKL3YwRGpEemtoTTFLc1JWNjBuMWN6ZXV1?=
 =?utf-8?B?cW9ZVEJpTGpidUt4OGNrWkd6RCtnMGZLZUp1MS8wRzlnQ05DMlIrZUVBcEI4?=
 =?utf-8?B?REtkdUpPMk50a1M0Z1ZrWVlKT0F4WVNjakF4QlRyR0hxdDR3Vk1WQU16QzJQ?=
 =?utf-8?B?eFlSRy9DL1g0U2k0eXJIUXlOdVpLMzdjcUV5bExJUEc5OWZGek5YWGxMU3VL?=
 =?utf-8?B?UUNkcDRqNHN3Y0F5dkJzMXdBOGhBaXA4MTl0bk84WmU4TCtDbXZ6NUdsZG84?=
 =?utf-8?B?REJTZmJGRjVkUFpsQ2R2cXVOZ3kzelB4SGRvWmFUY1B6WTBaUG8wU2pkenJj?=
 =?utf-8?B?bkJQa0N3M1RZVGEyRnUxWEZRU1pJakhzVFpXdW82TGdmdUU2QWVNbWsxVkFk?=
 =?utf-8?B?YWFkZGpVUmh0SnlleUZWYkNIM2d3S1Y4UkRsSGduak5UMnNWK1ZXZHRtQ0JI?=
 =?utf-8?Q?6u3rbmkZCb304lfRoH0lf1CPt?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ba874e-daa2-4935-e86a-08dda2c50f67
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 17:35:40.8658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RtROm9vam5NNbMNgO+6EDgXmmiRrtOAAHInYmtHYuJmG+tMgEUIzWcB3WHQAcE9Z77vqgcSN+scOKwgUVrsynQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6272
X-OriginatorOrg: intel.com

On 6/3/2025 12:23 AM, Xin Li wrote:
> 
> Just two nits below, other than that:
> 
> Reviewed-by: Xin Li (Intel) <xin@zytor.com>

Thanks!

>> diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
>> index 79d88d12c8fb..f0a577bf7bba 100644
>> --- a/arch/x86/include/asm/nmi.h
>> +++ b/arch/x86/include/asm/nmi.h
>> @@ -54,6 +54,7 @@ struct nmiaction {
>>   	u64			max_duration;
>>   	unsigned long		flags;
>>   	const char		*name;
>> +	u8			source_vector;
>>   };
>>   
>>   /**
>> @@ -62,6 +63,7 @@ struct nmiaction {
>>    * @fn:   The NMI handler
>>    * @fg:   Flags associated with the NMI handler
>>    * @n:    Name of the NMI handler
>> + * @src:  NMI-source based vector for the NMI handler
> 
> "NMI-source based" sounds weird to me.
> 

It sounds odd to me as well. I'll get rid of "based".

"NMI-source vector for the NMI handler".

>>    * @init: Optional __init* attributes for struct nmiaction
>>    *
>>    * Adds the provided handler to the list of handlers for the specified
>> @@ -75,13 +77,14 @@ struct nmiaction {
>>    *
>>    * Return: 0 on success, or an error code on failure.
>>    */
>> -#define register_nmi_handler(t, fn, fg, n, init...)	\
>> +#define register_nmi_handler(t, fn, fg, n, src, init...)	\
>>   ({							\
>>   	static struct nmiaction init fn##_na = {	\
>>   		.list = LIST_HEAD_INIT(fn##_na.list),	\
>>   		.handler = (fn),			\
>>   		.name = (n),				\
>>   		.flags = (fg),				\
>> +		.source_vector = (src),			\
>>   	};						\
>>   	__register_nmi_handler((t), &fn##_na);		\
>>   })
> Please keep the line-ending backslashes (\) aligned.
> 

I somehow missed this. It should be possible to keep them aligned
without changing the rest of the lines.

> I guess you want to keep the change minimal.


