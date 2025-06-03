Return-Path: <kvm+bounces-48346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B96D1ACCFE6
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 00:33:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1696D1886C61
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 22:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F67C253951;
	Tue,  3 Jun 2025 22:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g80YqjSO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DD42236FB;
	Tue,  3 Jun 2025 22:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748990021; cv=fail; b=SFS9390BmtE+1nSeDbNOC6WIiyvjyllk2/TTfu90xZxyvaarNiu35z8ZM4U6zNP9y12H5beEytBwnM2OVrJR3BCWuZGpA7oorxWFo8MQiWlxYM/U7sl9uJaZI2t/Vq515S5jXHN1vkBM35I4uGDIb97yz5qm04KwUBtt3iEfjt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748990021; c=relaxed/simple;
	bh=/mkhDXuimt92Xw2brwIZSDHYekt2gXyN6NdlOOeniEs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MBLTb1a3IjXGOzbL9i3z8xSUxXHjDiee20X2mGhD7aMk/qgWM7I5XuXAbEDfboYFiiWXe6mXXlOPuYvlkOMVKVUbFo8FpHYkQPPkdkQqEzKZzWtGMxqdYAXh2lIQn1Zq1+UR3Oqc7nqe3OdJxbIuP6HyFTwGDidh/E2EO2IrDpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g80YqjSO; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748990020; x=1780526020;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/mkhDXuimt92Xw2brwIZSDHYekt2gXyN6NdlOOeniEs=;
  b=g80YqjSOeXKgS9pWPkQSeoI8sN/KblF4zOlhvc52Y+0Nk7YkyctHmd8a
   9mNFwwyxA8IfPnhF5lwBSDYz1iUOnHkQJavfWjx+nMPOyechi14fmP72g
   djmS/QFLSk/aUWONAh2aZS7CodPr5Tr6la5z6ti6b57gXqJTfjdK0g2+L
   GFQWU87BEF24cApvMoE4PuzaHsZrNbZI3ttaD45jMVli77DgXnZDu2eEo
   lJHD9gv6SlZtTS92GFiewjKkZ+09jU6+Jw+F6YD5ghoQajgwTuL2BIFLj
   Yc88Kze7iqysdDwafBRVdJZx+c2m1WnhBBgM/n7g8WZIbW6gbkxXuHU4g
   w==;
X-CSE-ConnectionGUID: L9cO7LxTSvCvrMkaLKr6BA==
X-CSE-MsgGUID: hj+5T/fwQJSQbEJkGGbqEw==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="38680239"
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="38680239"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 15:33:39 -0700
X-CSE-ConnectionGUID: 1tEyIpsiR4iYSloyLw8dbA==
X-CSE-MsgGUID: kbPAzJkAQIO0WcdjGKHK+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="145968514"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 15:33:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 15:33:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 15:33:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.57)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 15:33:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=syMOD2LaCu18qzM4eQ7QWjM/n/WuxexblxxuLwk2oMarxg8ZCb4CAXTW6XCqEMJYNHTzYEGl3ZNd9mjFB8b44w94MnKQIKJCG+wvjJaJ6xRAZSjLh+XGqyhhooc5+ZXaRJhio5Dn8sLXYjvTDZhdKfj0bdLfiyriBNYcUAcRtU8tA0oDQQe9vr6IW8qPE2m2RxCxIF2gWaGvlJUie2QWzpF9oV7vu0PbRqnDLbXLmJY2c1a+egsYi/pshmHtVcCJiHNNmCLMSeQsQcyTJyfq5WkmaVuItS0lg4LyfSpGYZVP3TE8wLA5glXwSGBShw+qcXO9NsDEaqwBHp5Ns6OFNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AbPBUhBq1CGJicRD/9XC95a//INW4EhlZAHfKPvc/yM=;
 b=RgKhPs5nbWpBz8k5GAmo7/zC2J2yiXH3bm/xNH2SsCxB4X2KfaS8l4zj5Zm6NOvnX7S8/KVBzFdQgK7Y/lgVorUnNG/9WZo846q+YEFPRVItiyJNh8GxJ3ECjGBw5DX0cjp0gG655E16MqIqifCP8VZV8xxkAcEatngBcFkTaaaxme2HIZc3hdM4tmsM6JQKlOHj028L0P7aHcuvNJdzt1s2hQY25uru+uiOe/XhGECVys48OuruyOsnPhC6G1RJgxYxO+8B8KCiGDt3hlEuaEsZPycTPOFw0WKg5StjxeOxhh2FlI15CDpqxKvc/TlTwfQlU0u4Gdlvt1rZcsY8DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by BY1PR11MB8127.namprd11.prod.outlook.com (2603:10b6:a03:531::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Tue, 3 Jun
 2025 22:33:35 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8792.034; Tue, 3 Jun 2025
 22:33:35 +0000
Message-ID: <232ab16f-218f-4c33-9a6c-1652eea9d444@intel.com>
Date: Tue, 3 Jun 2025 15:33:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/9] x86/nmi: Assign and register NMI-source vectors
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Xin Li <xin@zytor.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski
	<luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, "Sean
 Christopherson" <seanjc@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
	"Zhang Rui" <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
	"Andrew Cooper" <andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
 <20250513203803.2636561-5-sohil.mehta@intel.com>
 <e978e1fb-d88e-4789-bd33-367281dfa0ad@intel.com>
 <67683e00-48fa-4aa8-91ff-8726a5374675@intel.com>
 <58556be3-0516-4204-b19d-11cba7b21423@intel.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <58556be3-0516-4204-b19d-11cba7b21423@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:a03:254::21) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|BY1PR11MB8127:EE_
X-MS-Office365-Filtering-Correlation-Id: ba706eb2-1932-411f-00b7-08dda2eead68
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NEp1R1BGUGRCVGRFZTJ5bmRBVkI4V2hKcDVTQ1dFL2tSdFY0RWE0OVZJMFFH?=
 =?utf-8?B?Yy95ZVo4dnBaY3ZURjI5dVQwbTAya1p4V0NyNEFLMlhNc1YzWjhHRjBzYlNq?=
 =?utf-8?B?azEwZUVqUG5ocFY5N0NVdlRxNnFKaTM5bUlrWExBL1RybUZ0dzBPU3FaT2NY?=
 =?utf-8?B?RHlSMVdyOXVkeVFodW82OEFsMkhuOTY1NlJaNUV6U1N4M1FjK2c2VzFENXh1?=
 =?utf-8?B?Q1I5UlFOM1F5cVllWjZiUjhpRTlHUXJmV1pzRW43Z3c2ZmluUEZMV29ITUJC?=
 =?utf-8?B?bVBkSlBURk5tMVBDSGVrckk1b2c0UTlNTEcwbGJUUlVDOFM3TjNmMk5YM1FU?=
 =?utf-8?B?MVQwSmJUVzFVckxvWlNyTjBMYVp3ejAzUms5Z01NVSs2YWVCY2duZTd3UU4v?=
 =?utf-8?B?Tk1GOEdSMmQ5TXdjS1VxOGhTS0VyNi9aeFp4REZnZVQ5OFk0Q3lJWkR0VnJL?=
 =?utf-8?B?NHRwdGNFUGFZUDIwV1NZTVlGYUpsVit1WDZCWFdmMklZTVgwQnF1emExSDN0?=
 =?utf-8?B?bXdvM3c1UjVQZzM0eGtqUWVqUFAvSnlTR21NeE5uTDBrR3FPa0oxYnQ2cXlv?=
 =?utf-8?B?K1VhL1k4S3ZrbXBRSDhnTGc5aTlyU2J1dDlENmZYNGU5aDZKc3Yvc21FREFK?=
 =?utf-8?B?NmxXdWovcmMzYkNMcU5SVER0a0NnWE1Ccnlkejc5RVppdVpZRVB1b0REMnln?=
 =?utf-8?B?NmIzQmlDL2o5ZWNoK2xyRG5oWHdmUzhhVEtxR2QvT2h3VHVzWXpIMldtV1hy?=
 =?utf-8?B?Tm54T3pCclFOV2YxSHRneVhHZmJqN25OYUtJU3pvQzhaaEpZSkV4N093eTNJ?=
 =?utf-8?B?Yk42eWJ0S0x1QUJ5dkpUUjZBQW10QnNCWW5mN1RuWFJCV3JHMklnUFFnb1J4?=
 =?utf-8?B?WDBCZ3ZoV0NtQUY0N2JEWElSRS8yRVcrTzgvMzlSNUtSbjg3cFhJcWtuUmxP?=
 =?utf-8?B?MlJwVWdJRE5XdCs5bnVRaUZqZlNWaFVlV0pzNUd0TjA0bUR1b0htbUw1MU5M?=
 =?utf-8?B?N0Y5aVRzaW5FUHBrVTUxTEdsbTJ5cUN4K0lWaXVUY254WXFqaCtuNktDVWhj?=
 =?utf-8?B?bFNKa0hiZjdid0wrd3RROHc4NEQzM1BMdHJIWTFBaW4reHM3eXVGbUl2dEZQ?=
 =?utf-8?B?WjVLenFnQmZ2WGlqUjBmZXY3OXY5M0JwN2NraTU4VTl6bUFYaHFXK1FyK0Rl?=
 =?utf-8?B?ZU5EZUZYQkwyMmlxd056VTVpWTF2UStHRStKYW0wd1pTbElLMjZCQnhVNGlT?=
 =?utf-8?B?bnk1WVBrK25OK1JRbENtejVZZC83K1Bhd3E0Rkh1ak1xVERURk5lUm1wSVhP?=
 =?utf-8?B?bGU1Y2FOQWl0T01TMk1yWXNKWDBvREpINEJRNElKL1V6cE1VRm9RRVB1eWg1?=
 =?utf-8?B?OW9oanUybmFxb0krSHRrZDFSa0dkWC9iYmxFRm1hZkpwQURXVnVESkg2OHJO?=
 =?utf-8?B?TmFjV3VndWQ3R05XblFyT0MyRkFkdCttWUZXZjl4WEdBRmNVZmNNOTVEZFBu?=
 =?utf-8?B?eG5pTHF6TXNqQ3Rrdld2OEdhVDk3TUxySERRRHZaYzUrcU0vTWJ0WG5CaVRy?=
 =?utf-8?B?bDRHeDljUFBSbUJvZFRHN2NGTEhXdElNOVdncDV6UHZoNzBXUFVGc3VxUE5K?=
 =?utf-8?B?eEsyNFJoQk5XU3RRQXJ1S0ZjeTJZa1FOUnlwOXZuZHFYWmFYSGFQYXRPdlEr?=
 =?utf-8?B?V3J3VXpJOWlKSlFvbm5WVVcyajhsdzRaeitrem5OeXIveFhCZnZCOGNnUTlH?=
 =?utf-8?B?UTl2a21sNE5wc3NFU0VwRHRPeURyVko3UHNseWFpaVZUM2R3NFVBamlkc3FU?=
 =?utf-8?B?bFgwUGd4VTNkOHNKeTZHaVZIdVpGcHcwbnpQYUJxUm9pcFBzOFZyQXpMeGYv?=
 =?utf-8?B?aDZuWkkwTXRhT1ZjVkNPZUFMRXhSTnlXYTdiVk83S1gwaXlPZWJSdlZhaGFq?=
 =?utf-8?Q?/7o2hG3Euis=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tms4YWxWNWxvZnAxTm8rOWVpMFE4czdiTHlwUFBvbTZYbFhJTXJsTDdFYS9S?=
 =?utf-8?B?S1pGWjJsUGRBM0JpVS94YlFXanNYTkp2STVGWXB2NEhrRkIwYUJYS3poejVU?=
 =?utf-8?B?VGllUHZObXNQQ3VSOTkvN0daYWJ0UVptYkJqRXBNL0tzT2huVFRyN2pxak5q?=
 =?utf-8?B?Wko4ZXgzT0taR2lRd0tOMGU3MkJKamJNdXdnQWFpVkpKSG0wRUdsVDBlM21H?=
 =?utf-8?B?cUUzRFhMcmUveGxHV1M5bDdQbHlOSTVxQjBTTUhzTndORnhCclI0OU92S29L?=
 =?utf-8?B?NWJVM2xvV0o3ckNSQ0gxQjllSHV1N0syb0dDNjVqZkJMc2hOYURmamFBckVD?=
 =?utf-8?B?K0l0RjBNR2RNV2JMNENSd0RweE1vWGRMVkVMZUJ1Z0hSSEUyWXVmSHVmZXBR?=
 =?utf-8?B?cU1qRTJTSmZhdERMN3lZelJQWFQ5Q3pnTmFFZEQwYkpnK1hlYjV0MVgzeVoz?=
 =?utf-8?B?RUhpRmxKcVNsTVJaNndKenpCQ3E3SkE0R2YvZDZEa2RvYUdHMmxxYkJDNG5K?=
 =?utf-8?B?eXlyKzBtdlZjVWJ1TE9NdTNNV1JOdkltQ1NIUURiNkc3MkkybElLMHBrQ05L?=
 =?utf-8?B?ejRVblRmTGNxcmxadmc0YjlSTjh4TmZIdEJJUER5cUZnUFJuTk54dm12V0Qw?=
 =?utf-8?B?OFJVNmg4ckkyS3gwZExEZEcrL1ZGOWpJcGpFeGl1a1Z2V1VHVDFNaVhiVHk5?=
 =?utf-8?B?dGNTN09KUEREeWJNZVc1YVJxRXBORUh0QkFCa2pKVDF6YndGNEhETXI3UTBN?=
 =?utf-8?B?bWFiRCtxV1dzQzNEYS9YOUpLTUtkSGJxeFJZS0QrUXM1QndkWVQ3bFk0LzlI?=
 =?utf-8?B?MFJIeDhZOTlXR3g5Uk8wWFRiM0R2TERJWVpRS1pWczNGdzNDYWF2cG5Mdmd1?=
 =?utf-8?B?MnpBM1hzT2dyNU5GZjVVdVB6T1dac05tRkZsRmx2RmhRcEVnNHltN3kzczFZ?=
 =?utf-8?B?VFZCdlhWenRWREdpSVpCWjQrMmtBeHhIVVBKajhUczdIYkg5Q0N2UFVNcXAx?=
 =?utf-8?B?V1RudE1vdXVkQTRvWVQrWFBnWm81QzdOekRVc1VYb0hBdStkMkd6ZUpYVTdV?=
 =?utf-8?B?U2NtQ2JQRi9ZUHJEejRtZVRDc015c0tuNkxpazJRMFhibWhpQjM2RS9EQzBP?=
 =?utf-8?B?dTR2ZlVZaXFkMzRwZ1l3aHk2U0tSL3BOVHJzZ1hwRmFyaUh3cGh6R09jRjho?=
 =?utf-8?B?RVR1L2pLdjNwR21zV3ZSUFd6QTVOcUtCajFGdDIzTHdiRTg1RXNqenY4cEk2?=
 =?utf-8?B?UnA3cTdSbDF1ekxPYVpRUFNlTEtyL0tEY0Z4cTJNU3hGNFFyZHZVNTJ0NVh6?=
 =?utf-8?B?V1Z2SEVQMlZYREgySzJDQmV6Q1QwTGdNRjBkc0FyMFFKYW5Xd3hid2xjVDY0?=
 =?utf-8?B?cWFSRWdhRXR0L2t1anVabWJwZVhwd1NXUHBmenJmK0E2VDVLQXZoUWdRK3k5?=
 =?utf-8?B?UmZHR21RMkUrT3d5dkNPQnEzRUY5UXNlVXlQSmQrM3NKMFNDR0xhcE53eUlL?=
 =?utf-8?B?SVNWQkVXVHJ5REk1THNiZ3VzTTFTdkNiMUZnVGJaZWhaVHJlN2EvYW9KTWlT?=
 =?utf-8?B?dDZVTDVmYy9rNkliR1Q5VlNMdmJhQmJhWnE1UWpQV2sxcSt1QUJ2aUQxQ2pm?=
 =?utf-8?B?UmxESStqdlNkdm9rSy8rUHQ2NkVybWNiZHAvUmZHcGtaODd3L2hBNDRpU3Ar?=
 =?utf-8?B?VHM0SXord1NTUzNUMTQveVZxcitkQ250cFRsaXU0N3lwSFBwT0FPcEdjbHRN?=
 =?utf-8?B?blYydDZCN3ZFa0tKRk1BcnNTVjhUdStPcjd2SzBmRU5TQVpOUlI4MzYzVzlx?=
 =?utf-8?B?L1NxMFhad0x5b3JkcWQrZ1IrNVltREtQSUZFakNnSDlHLzF0dlRRaStzeXR5?=
 =?utf-8?B?TkQ3Ulc1aWhMNVhHL21QT0JFd0VpSkVrdVNacjEwVG9mZkZjTXRidzFVVXlG?=
 =?utf-8?B?SUFPN2tYcUlnVWNSNGZDWGtJbkpNMFVITlhvcnBiMjlMMmc5cVRCS1hVZ0Q4?=
 =?utf-8?B?anBsb1pOcU5qazB6QUNEcEgvY1p5czJEM01QU2prTmpDYkUveVhVdjNjb1NZ?=
 =?utf-8?B?Qkx3MGR5eDl2bVJpMm9CUnhucHlMZUZIRW5rMlJCTWh5R2tiYmlUS1dZSjI0?=
 =?utf-8?Q?/u18eo+dqNuPDAofa/19787SH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba706eb2-1932-411f-00b7-08dda2eead68
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 22:33:35.2775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gKd2IhLR3nLuuM7Ah82R8TkMhpZqgfnsWzK1rgF2WDxHzTS6B7DcDZ6N8jlc1o656oKlaYoOvPA4TVOhal5WhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8127
X-OriginatorOrg: intel.com

On 6/3/2025 2:54 PM, Dave Hansen wrote:
> On 6/3/25 13:22, Sohil Mehta wrote:
>> With an enum, it's harder to figure out the exact sources when let's say
>> the source bitmap is printed as 0x0090.
> 
> Uhh, then don't print a bitmap. ;)
> 

Ah! Didn't look at it that way.

> /proc/cpuinfo doesn't print out CPUID leaves, it prints out bits mapped
> to strings.
> 

Hasn't that caused more pains than gains :p But, point taken, I'll give
it a shot.

> Look at the kmalloc trace points:
> 
>             Xorg-4589    [003] ..... 1568557.823993: kmalloc: ...
> gfp_flags=GFP_KERNEL
>             Xorg-4589    [003] ..... 1568557.823993: kmalloc: ...
> gfp_flags=GFP_KERNEL
> 
> gfp_flags are a bitmap, yet they're mapped out with strings and symbolic
> names.


