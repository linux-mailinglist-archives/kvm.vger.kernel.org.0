Return-Path: <kvm+bounces-55588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 69592B3341F
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 04:55:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F0E63B588A
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 02:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B082367D6;
	Mon, 25 Aug 2025 02:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="msqXhlvH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1701C4A0A;
	Mon, 25 Aug 2025 02:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756090526; cv=fail; b=SjVGBDMrpMGVMxv2R/mEEv9x3SVajHEuuTjfszdtn4S+MpZZ/h/NLq9tIHfwhJSwL+GcYsjhkzojyNtoVJx91U1XCTRt6dLJi6IDwJGIbEE4qvrLdLpv0vG5Srzg+iwJhLLl/Nfy2rKkfmFwpEsvRZt4+Z+WRj2vb74zAQb3Jaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756090526; c=relaxed/simple;
	bh=+wefO3VebnTy114//B6jhmRHZlsYmoQdvdIqcasRAkM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GiOIBoi7r6Y/C/472taKHWSioKnM2qaYiFDAzdePjm25eCug+nh8FHcMuLsftFMDn1jkj6VnrILiKd84QgiCm4rlmz6bgBUhgjZisDe6QJVw/uQ2WJYOTYqbYL33C5YWgFBnhMND55qBsGWY6Dn4rvypN+k3AnYI0o8Y+r1oW5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=msqXhlvH; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756090525; x=1787626525;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+wefO3VebnTy114//B6jhmRHZlsYmoQdvdIqcasRAkM=;
  b=msqXhlvH1hfb0L2vPfcBLBpZl1iShtH1dg+1612/jg6D1SMa8l0r1DmB
   z2GyFStm1CcS9gml2n+B/6QrbrzwJCmX7FWTb7cY9crMfCaPKB3+s6WIQ
   M9MHlGYOccx8mwk0BJ2FyFXqm/BlldBJSqjKITvL7piwVHxaQ/dlT01es
   rg1iB7e6HR6WzCiw7MkG4VH/b13o2JnRITNx4Op3RK7LbqRxUoBKeGQ1q
   ZRPQ2d43bSbmlm9vlHNmwbIkT8QLClTJCdwUBVoNeDaIF8Lt8n5QN6AqG
   BGRTB1F1IXZi5uKpexeqLYuiWmKeujW69WdMManJvvt1GVMVFLkP53rR5
   w==;
X-CSE-ConnectionGUID: YLENq559RU6w7mlLC2bB8A==
X-CSE-MsgGUID: +qdrhDOJRFCg4irvYdD4PA==
X-IronPort-AV: E=McAfee;i="6800,10657,11532"; a="69669331"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="69669331"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2025 19:55:24 -0700
X-CSE-ConnectionGUID: yMqLgbjYTFSzvyGXtrYmqA==
X-CSE-MsgGUID: YZORLQsMSa6zF5X/YzmJlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="174482450"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2025 19:55:24 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 24 Aug 2025 19:55:22 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 24 Aug 2025 19:55:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.51)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 24 Aug 2025 19:55:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WeyCtx2bfMP8nLEUXEbPgI+s/qlUUPsDt4VE7HCqFOcPJq8VyOZEehv8AQn8op/PkBM8Tyd2nPEUe8JWJ75ZoKBRu1vZ3Tj0IpStHFy2GV6OzbrzL0ck6t2qyI+OeQ8qDpcAVquqnA+VzcDHKBom223Hh4aANsgDULr5TweT0DHplbGF9Ck/IHJfPVtrjHzoY2YDsDlYZORaCqho2GOxJjWJOkkmJGwa+rnU0cV3rP0tDsGbNG19j3OAV4TLh2hsrdvKscjntYbXQZeXRYvuyKb/EFG3XNQdNezW6/qLFpO94/afhWSp3VF/AIOlghA/5Dtd3PT++06LIyhXV4LgJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PWWUnUnewjIR244zszSky1t8O71V03vb5yahvUeSf1o=;
 b=zJTgi+Vyz3LsxA2stOgsZmaMBqfuwIbFQdsfFnyE+R7sTCIu0MwW3yQDp9V2VMfFTpoZuCr2ElyW8n43oJ39G1EB12BFRSi12f1JHTqN3jSoiAYeEoTq3Uf4XLeIiuSdCE/HbnSkLIaNsUym3K+UvCO4pyUVac7Fk4xT5HTIEoKGbTsQJWdJRhIX24ALj9/JQ9aolmc9FuorcBZHFCTnKJSZZcHCVzsMW7zHLeGF7OE7sSg+SR3NK9zd3hhqriADFP/cjMcL9iEZ5oCOs44C875L8Y7sCQTwLunjUXI7TgDXzTsKIpWnqCqjPn4U3xhww1uKhGbjrnDEeJpYjW5SOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW3PR11MB4731.namprd11.prod.outlook.com (2603:10b6:303:2f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 02:55:20 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 02:55:20 +0000
Date: Mon, 25 Aug 2025 10:55:09 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xin Li <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <john.allen@amd.com>,
	<mingo@redhat.com>, <minipli@grsecurity.net>, <mlevitsk@redhat.com>,
	<pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<tglx@linutronix.de>, <weijiang.yang@intel.com>, <x86@kernel.org>
Subject: Re: [PATCH v13 05/21] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
Message-ID: <aKvP2AHKYeQCPm0x@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
 <20250821133132.72322-6-chao.gao@intel.com>
 <b61f8d7c-e8bf-476e-8d56-ce9660a13d02@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b61f8d7c-e8bf-476e-8d56-ce9660a13d02@zytor.com>
X-ClientProxiedBy: SGAP274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::35)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW3PR11MB4731:EE_
X-MS-Office365-Filtering-Correlation-Id: 73476d27-0d37-4276-ea99-08dde382d44c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ZqVD50DnsC2RySEIUvJmyyPC4q6x92pZdVZKhGCc9rG4208+qFSgpyHaBq8v?=
 =?us-ascii?Q?QQjjvPBpj4RbPJRyf2/O6HQloy4jGn9PLLFDK3YITcvr3ZqXqNv1ZhrlmpQi?=
 =?us-ascii?Q?QmCPP4xLPQgg4k7ZgogCV11xo+zelxgDWoVaIpC8tBxViJMLVW7Xwd2eBbHS?=
 =?us-ascii?Q?L1V1NChp9WlMb/2M5CvtVua5fCBP6jykF/HsB+SAriM1OkDh7dwi8wXIhvnR?=
 =?us-ascii?Q?R2HeO//92u9ls0OhXKNSav3nGGolW/RWF/Ot6GYNsAWQI6cJrkLgEZnJU9I8?=
 =?us-ascii?Q?ps647t2mlqc1Gmsv8YqcNDtf6Bx9iJ5ixjNuKSb8WS7p3lEHm7M17z+yH0NE?=
 =?us-ascii?Q?uJo8bVNQD7SSHP+Dr1oDSVoMNdVnenD2nPaBRN2n4aiCok71WQ3t2JqfalSU?=
 =?us-ascii?Q?BDrpgYMBiySb39mm8Opyg8mNCC6sA+q/zIIrk5lEx/uSmiPjm2I+w5BIGIG3?=
 =?us-ascii?Q?/K52yG+ETUOzGLcs5TZpmQjh7ejwyiBFa08kKnvGWV99x+fhICNRVVOogglg?=
 =?us-ascii?Q?/V74FeqDaFmOgujLeWD0SoSvMKZR2Lp3ZOUp2D+9+3SRknIvZ2J8NnrKrra5?=
 =?us-ascii?Q?2+xU20BBpWBR57kEAfXEHoKdcx/oKoNEmq5N6UjEZnvZBkHAH0F9V+Mg4sR/?=
 =?us-ascii?Q?i4mnNz89GLkj/Wwup/S/yFGPAe5uZMLjZjZxW9izwT5bSsXfKMWgdGWH1k2m?=
 =?us-ascii?Q?4QB+ve7U5a43Ml7YcebEIoZPkuGDUbJ4YU4NLjJchJhYB+xk6HK9Qh5iUei3?=
 =?us-ascii?Q?Oofdq9GgYHRFvsNqzGQ+C75DEbZrMLzQ4t41v345LE1DNbfUEtjGRIGlwAAY?=
 =?us-ascii?Q?ceF1ftPXyVcJvDw5v6AzpGjjW4e+1qOIbJqrIPxYw1RPTfvomy4qRU4h0rX2?=
 =?us-ascii?Q?xOyQEps9kEYxS6UxM+I6AVt7fMU7bf2GDaH8BzGr4OyBeIr3gxVJLRidiaVH?=
 =?us-ascii?Q?keQU3LXAk8wKwOL1lU2EMNP67PLHMNCdaBXyfqpSHRDJiN9F4HA7xL3s4cgR?=
 =?us-ascii?Q?4wXuHIWkeApKUCganmitIrzC9LwJxS2CNY8sP9fn1ZnoIPXi0ZQ4aWoBEfIV?=
 =?us-ascii?Q?6zRE/0nPElPJDR5vn8ksMT+HLkDLPcLWZOF2o68jav2KAw7/WM8pa7NJ/AW4?=
 =?us-ascii?Q?N08WeJ1UPwl8TpPvuLEXEXp6A8VK1oX/ecZ4ejmGRI9+zpG/beeAxFmhFOOH?=
 =?us-ascii?Q?YbXLrCg0fRnwNyA9+cY0jxSZHto4bKmx89I5oyXRVvWSPrZ/hfOl2/KbGs4W?=
 =?us-ascii?Q?0iB3HhVRi522oQa1tez5h18pYJhleVzbNVRFdf5VX6ZAwrNfqPsS1Isi7Lw3?=
 =?us-ascii?Q?5x7zzXSLkgooCR5czGbgnwoPaDL7yeKhhOVYjlZrnchXYIMnJM4GRt9c8xe2?=
 =?us-ascii?Q?gcbJXZ2O9tCyhJsZLGweM67WynhZJUcL61xVpjHG6tedo0dA196tgqH9OKYa?=
 =?us-ascii?Q?YqIUATXlJjs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jqlImBa+cqzfxX3z2CIdMfOSUimbAMNZFPIXweKCpSyK/7PEEYwYgJFC8NS7?=
 =?us-ascii?Q?z9f5wzwjjHVTku+kwqIzBHQyIBCaSC8tPmR5a7MuWgK6YKaU/6pyQrya2Oyx?=
 =?us-ascii?Q?1JTJgswJP90j6tYnDiAKdOpSF/LWMWwJ4+cHm8HA0jl2B6InbslAG7BF996S?=
 =?us-ascii?Q?CuZ3QVpMgwKlKH2vg426iepqGSWDi+6NmlDZdN4exDqdtdQytsK9KSedRPfk?=
 =?us-ascii?Q?rAx33mDKDt453za2/bLj6A9l6odN0JbzIXAa9dlQ66qRWYvU3Pwd/HCCs3SK?=
 =?us-ascii?Q?moqc5gxL1Zm96BuV7DyY2e1pgUsYLC4SlsVInZfJYPxBIuP0bA5GzdcCwnpj?=
 =?us-ascii?Q?4V+zV0WHRY4I7voHR3MOcqDzfHsbWlv63vMKH7I1JL7I0hFZZZEEQtyCOJSd?=
 =?us-ascii?Q?SgAm6nLu5r1hb3NxZ6Udm2wSwdeICQouwaEc4CEomz7Lvo0cZ118B1AKGTfI?=
 =?us-ascii?Q?W21Tviz8pXDk9T8xZv1OUlkLQvCyMxWvs22/BffAEAT1b5gZEpRFhwQYDXcG?=
 =?us-ascii?Q?cHI8W3MLc9jvv2AE8coNiuAjxuVuqutj1yzI+1u0pjYxg9q24JczHlVAxONg?=
 =?us-ascii?Q?2q5E1qIRZMQw42/hQRFAkZbXBKqF7S18ajuE2tEqXSnJbOpy1a+1GFjkvdrM?=
 =?us-ascii?Q?neJBrrxJecgkIMuHXA+i9MAmNBPl+JPODxceiy2AvIRnvngqbm3bHYcvaM7S?=
 =?us-ascii?Q?akxjy2ZlCE+zm/VG6nf6SA521EPM5js/3w6D7ztzV3ZkraeA/WKCkbhbau6j?=
 =?us-ascii?Q?13MqTsPQ2I3cF3yqH5C2yqMFw+KLUEuo39t2okP/2tPN9BZBzAMBrhDFjqRZ?=
 =?us-ascii?Q?rgt7nSWfRC6Qrd/DKQGiEgKXReXhdt0bgr3E0X3ptg1wUOWLifDTVE2/WUQI?=
 =?us-ascii?Q?3sTL9VF1hOrQFSzlUKvTy3ceOPB4a4jH/dRqxm9b3sJHfm/jWR1lObDv0RWX?=
 =?us-ascii?Q?ehEH8ck880SCMC4Q8yxa8kKJIIN5QpdtuGyhomVQpkBCACkQONPuJsIPjXH5?=
 =?us-ascii?Q?OSAJR6nd6VaR/WzpX8SMt1AC3Qox1TbYQeMZcFyg0JHJElu0pWo/NqYnIWmu?=
 =?us-ascii?Q?FAfaHpNAN8QL5mp2q3PaEmEwr2DEJwsXQzu5Eu4yEakapvjQ+eboLMQkSAVF?=
 =?us-ascii?Q?X/JUUAs59eiw4lB69xrOy/iJZo/lUjE6fHQ4ZjwagPEkw4blMrEeACziPOel?=
 =?us-ascii?Q?S687iunG6kG6BNzPbeoWvDW2y9Fav9zdAlBe2TUyhDo3oUb/0CaFCcXhELEG?=
 =?us-ascii?Q?jr3vjIRhHIoDOc/ZNrfTG+K7eTgAxcx2QM/BP+49RFhPxUEq6xWvmSzXav22?=
 =?us-ascii?Q?71/dMOIo4sTAbDTLSj2/N+280N7fgPPtkoC/72RfQXIZc1fOH8qrwMFd5W/N?=
 =?us-ascii?Q?DFkejlCV/VWSri+ayCaMyqlpAoxEbWqw5xCSaSFhm5jFtA0iCtPgYNjF8wHP?=
 =?us-ascii?Q?FI8zZyXb03VhZuREcCQBZWgcOdWxbGXkrEI2aqpZ1MDSex65bLYrOYIn1NNm?=
 =?us-ascii?Q?S1XCo5lhUwfB50Sq84u9IcpGxzGI+hVViYOkQuEx12qB278n6vVpY7vVjeQ/?=
 =?us-ascii?Q?zMGENVp1QAMNzwxHyJIeZIO9WC+8PKaSrY3bJqXy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73476d27-0d37-4276-ea99-08dde382d44c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 02:55:20.4984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BjjWaik6MWN5scbwY6ALj5CL+kq4mpH9tN8b48uMLpVwq5snXrci39GeQjJzrQPtbnc16mQzkfMET2k9r+wWbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4731
X-OriginatorOrg: intel.com

On Sun, Aug 24, 2025 at 06:52:55PM -0700, Xin Li wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 6b01c6e9330e..799ac76679c9 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4566,6 +4569,21 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_get_msr_common);
>> +/*
>> + *  Returns true if the MSR in question is managed via XSTATE, i.e. is context
>> + *  switched with the rest of guest FPU state.
>> + */
>> +static bool is_xstate_managed_msr(u32 index)
>> +{
>> +	switch (index) {
>> +	case MSR_IA32_U_CET:
>
>
>Why MSR_IA32_S_CET is not included here?

Emm. I didn't think about this.

MSR_IA32_S_CET is read from or written to a dedicated VMCS/B field, so KVM
doesn't need to load the guest FPU to access MSR_IA32_S_CET. This pairs with
the kvm_{get,set}_xstate_msr() in kvm_{get,set}_msr_common().

That said, userspace writes can indeed cause an inconsistency between the guest
FPU and VMCS fields regarding MSR_IA32_S_CET. If migration occurs right after a
userspace write (without a VM-entry, which would bring them in sync) and
userspace just restores MSR_IA32_S_CET from the guest FPU, the write before
migration could be lost.

If that migration issue is a practical problem, I think MSR_IA32_S_CET should
be included here, and we need to perform a kvm_set_xstate_msr() after writing
to the VMCS/B.

>
>
>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>> +		return true;
>> +	default:
>> +		return false;
>> +	}
>> +}
>
>
>Is it better to do?
>
>static bool is_xstate_managed_msr(u32 index)
>{
>         if (!kvm_caps.supported_xss)
>                 return false;
>
>         switch (index) {
>         case MSR_IA32_U_CET:
>         case MSR_IA32_S_CET:
>         case MSR_IA32_PL1_SSP ... MSR_IA32_PL3_SSP:
>                 return kvm_caps.supported_xss & XFEATURE_MASK_CET_USER &&
>                        kvm_caps.supported_xss & XFEATURE_MASK_CET_KERNEL;
>         default:
>                 return false;

This will duplicate checks in other functions. I slightly prefer to keep this
function super simple and do all capability checks in __kvm_{set,get}_msr()
or kvm_emulate_msr_{write,read}.

>         }
>}
>
>And it would be obvious how to add new MSRs related to other XFEATURE bits.

Just return true for all those MSRs, regardless of host capabilities. If
kvm_caps doesn't support them, those MSRs are not advertised to userspace
either (see kvm_probe_msr_to_save()). Loading or putting the guest FPU when
userspace attempts to read/write those unsupported MSRs shouldn't cause any
performance issues, as userspace is unlikely to access them in hot paths.

>
>Thanks!
>    Xin

