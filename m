Return-Path: <kvm+bounces-46126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0863DAB2D71
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 04:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFD1C1890C97
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 02:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91436253933;
	Mon, 12 May 2025 02:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P7ZNDHFv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFB0253926;
	Mon, 12 May 2025 02:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747016315; cv=fail; b=WKm/ZNpXsyqlULsFAQdIfUR4Z7Jk+imRJ+leSLvlDg2U0ggfnJKIJgmRGXV0rAZC8zdFyts5DP7Ftk7awCAQAr2FI3YBa0haXYWgCQmYLLgKWXwDlJQ22snoLyY0ABOz0D4Q39Zc4vy8WBJfsEw8jyuVftXI3SesV29HXuGamp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747016315; c=relaxed/simple;
	bh=vkGjJyzKL9W97m0j9WO8muoRyMzx3V/bVEBk+TScVUI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l2PBBg9k1SBFFs92j+74OlTCSMJZ+2frjj5i7LIVGkRruP6iQMefmdeQ8ek4Oicm8oed4os17uS4z9LZQSjrrxkKfPKT3CJQuCjTIaTVHjbC/JcqgJuYH7sblixbiLJ36OQQZJhYE2gx9XXC5cshI2nepmppDvqmFCphxXRSmJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P7ZNDHFv; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747016313; x=1778552313;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=vkGjJyzKL9W97m0j9WO8muoRyMzx3V/bVEBk+TScVUI=;
  b=P7ZNDHFvyYFDQmeVTgx6tF3PrPKytrwrKPrYJXFHNtJCKv6Fdsso+HPf
   hyjCxgD3OzKAx3QungBYHBaGeFf8IWNv5MKyStsogmLPgcwZew4JZNEm7
   GsFx70c0sjSfiL3aYVlR6OB+ub3MykvE0naPw4hnmXzDGUk2Z9uRk2GGC
   7ZS9I/HHVszJeDjTGgHxz3x8BCHqjwXuD6HyThPWWkRE1CfwQaCKgXm+7
   K3CGDbLa/3WrPG4EMNn1oeLt2uLls2VM5tydH/4Z/yRZij3G/wPpDXF+L
   R2q1fYI5O1kvLArSzAE2f/OUhBqREUFT//3efc4UYnVbz1fCQtf5Es2OL
   Q==;
X-CSE-ConnectionGUID: Kn72xe6VSum8FK7v8YjDpA==
X-CSE-MsgGUID: i2YZDAiOT8OmP9ZxSJ13Ng==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="59024239"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="59024239"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 19:18:33 -0700
X-CSE-ConnectionGUID: LtQsGjuNQvmfuWkHLNn3kw==
X-CSE-MsgGUID: 7mNZskgaRJKsZAHuB9Sf3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="137624642"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 19:18:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 11 May 2025 19:18:31 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 11 May 2025 19:18:31 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 11 May 2025 19:18:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i8fO9tkOakppdrPt2NL+q+wcU2JsAryacwuFL4O09visqpjvZIgSkHlIhXJS+F0BJDejVDexEUri0DoYKRTiiPNZSELk52cSNtP2wZ+imdiLUYiSpPFZsNu0yLw5y2+dGm/8iR3Uzhoue7k2t8ELY66mUCIzdXrkfv1E+LWDvWV0EEet5qCuJB3ojJKtyOA3seL21tYMK0CfnqUDmXNUTUN1hDCOytb7cn8aTFwdN5r8Db9qi4ZzZr+6LHAtl/y8o+kaRrQJo+aycGUQN+7/EBBK46jv68jcZDNBmRrP9WEEYJK9HM3UPXVXTq24oFeFOOMKWaY4IUmoA3sTeA0zNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KyssepPmIPtEppOswpwuvLLilcieTEY2LJOSr2wFvac=;
 b=H2xEL9hlCqOGVFIOxJVtwZF4vY+EhzDikK1zTToFDuJdF1HC/grBJe8KazGY9aZRh3YXqnt0L/Riz13ou80ICstgkQlF33FUghjmDDJFSSkDiuOmOU2c5kc09kswmeItjh9+tMRMZ9dqNhcGoLTq6pnuKpQEwm91yVcfDG0B5nen1j+D6zuSWKkNYYYsnvXwe9CDeF3FpugmkEfhuSpBuEVMqfO+9VzRhlG1fLh3ggXWr9yQgTOjSSHuwvbNfmHzGmJi628uKj74C0O3tBSjSMajRakhqStl0M7bNXbKjx1zNSgbS540fbyIeiVwKvqLGcQwx+aAKGC/svN3mTBwxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7034.namprd11.prod.outlook.com (2603:10b6:930:52::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.25; Mon, 12 May 2025 02:17:57 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.027; Mon, 12 May 2025
 02:17:57 +0000
Date: Mon, 12 May 2025 10:15:49 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vbabka@suse.cz>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pgonda@google.com>, <zhiquan1.li@intel.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aCFZ1V/T3DyJEVLu@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aBldhnTK93+eKcMq@yzhao56-desk.sh.intel.com>
 <CAGtprH9wi6zHJ5JeuAnjZThMAzxxibJGo=XN1G1Nx8txZRg8_w@mail.gmail.com>
 <aBmmirBzOZfmMOJj@yzhao56-desk.sh.intel.com>
 <CAGtprH9fDMiuk3JGSS12M-wFoqRj+sjdtEHJFS_5QfKX7aGkRQ@mail.gmail.com>
 <aBsNsZsWuVl4uo0j@yzhao56-desk.sh.intel.com>
 <CAGtprH-+Bo4hFxL+THiMgF5V4imdVVb0OmRhx2Uc0eom9=3JPA@mail.gmail.com>
 <aBwJHE/zRDvV41fH@yzhao56-desk.sh.intel.com>
 <CAGtprH9hwj7BvSm4DgRkHmdPnmi-1-FMH5Z7xK1VBh=s4W8VYA@mail.gmail.com>
 <aB10gNcmsw0TSrqh@yzhao56-desk.sh.intel.com>
 <CAGtprH8=-70DU2e52OJe=w0HfuW5Zg6wGHV32FWD_hQzYBa=fA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH8=-70DU2e52OJe=w0HfuW5Zg6wGHV32FWD_hQzYBa=fA@mail.gmail.com>
X-ClientProxiedBy: KL1PR0401CA0010.apcprd04.prod.outlook.com
 (2603:1096:820:f::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7034:EE_
X-MS-Office365-Filtering-Correlation-Id: dc6d6e6f-798c-4d24-716d-08dd90fb35dc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TG14VElvbXpWaXBYaXVpdUIrMUZ5TDY5R1Q5ZVlZYXI5QUUyeTB5WEs0NkQz?=
 =?utf-8?B?L2FXUDA3b0gvTmN4L3g5L3hMKyt4QWJrVWxTSFpVSmdpT0o4YkFNaXVNTjBY?=
 =?utf-8?B?aUVncEF6VDU1WXVJWTFoUWxhT25PclFJT1BxZ1pSRHlJLzE3Z3pHd3dlYjlo?=
 =?utf-8?B?T0xHYjdQTjlzS0FNdURhdUpxbXlOQVV2VVNpMjFWWFpaQjlpbGs0ckJ6bS9Q?=
 =?utf-8?B?eFVuSDh0OTNNaG5iOTNXUHlUZlVYZVNLTU1LSXhFYk4xdDFQY2Z6aEtGOXVS?=
 =?utf-8?B?czFRM3gzK2xkSnY2MVlEVEp6Y2xNeDcxei9aTGNKb0c2QkNRQ3FSbHhIb1pI?=
 =?utf-8?B?MlZ3WEZLa3c0NzBETXFNTkpOMUt6VG4wY1B5TWJMOS9JM2EraEdIQnp3V1lw?=
 =?utf-8?B?Smk4KzhxMEZhNGtSdVU4MVd5QlZhRXJLVDE4Nll0a1FpeEsvTlZkUllpVURq?=
 =?utf-8?B?UHUvd1ZTOGc4dlozbkpjdHRLRlVENVpuV1NBN0NabEpuRmJDeFVNZVEraU5Z?=
 =?utf-8?B?bjEvczNPYVlJbU1iQ0RkbjRtRktqT0Y0dmIrbVFhMXgzakpKMnFvWnBFajln?=
 =?utf-8?B?WTd2QmVzc3paK2h5R0tkK2RXSGVrTWRQV3hBcEsvcVpOcXJiQk1EVXBURm5X?=
 =?utf-8?B?cXFuanRwRGxFUWtMNGtmV1BVN3JmRW9IdGtTbm1hbjZPWHk5UDR4S1lkejNX?=
 =?utf-8?B?UkFVQ0VSYytGb2pKS1NhKy9GaXk2ZzNPamQwRmRzdFg2bFJhL2lraVBJVHA3?=
 =?utf-8?B?YW5jOFpnZmtwbE5rNWtDM3JwVWFEZlZLU0hSYlhIM2JNWlVIaml5b2dScElP?=
 =?utf-8?B?bytTWit4SEN3Z0dVUXdDd2gyY2FVR0RXVGFsTExtVGI3czZndi9LVjdhSUpx?=
 =?utf-8?B?dmhub0FReit0OW1xTFF2K20rN0tGdExib3QveEdIb1lhczNhT2tlMGo4MlNL?=
 =?utf-8?B?L1NOWC95ZGlZZGFXK3B3S0R0SGxBeXRycWFKSDZvRFRDQ2xrY2xOQmVrZzM5?=
 =?utf-8?B?emRPR0xLcVE0RjN1WEpUVkVFRjZjdXM4VGVYUm9HVmcvb1QxeTVhSFhSSVVr?=
 =?utf-8?B?TXA4MDk2TjVJT3hPNTk2ZlNobjhWcTBLZnhld2N1MkxoRjE4Tmw1Z3dkbm53?=
 =?utf-8?B?ZjYwYnZpdVJoZjRkK2xZVnlqaG5Od2RKM2V1SFRUeEtibkllL0l2MldvMWVK?=
 =?utf-8?B?TlRLeTVmcWdmbVcvSWhXWktWcFRpT3pKRkduaVZOM3U1Mzh0MVpQRmZXakpS?=
 =?utf-8?B?UFFoZnI2VEpQTmtFU3Zhc2VYYTVCTmV1MngvUUl2Mm9XSTNkODdzYi9VMmFu?=
 =?utf-8?B?WWYvNjIvblFWMDJjbmxtYmxkdXdBem4xbFhKdkNHeWZxWGU1ZGV0MVFkSWQv?=
 =?utf-8?B?Z2VzK0dacFFiUVFtM1IyMkNGRzlOUmZGVC9ZOWMyRkhwR1ZBOWI5UVVndjJU?=
 =?utf-8?B?NHowbHN2anRnbnFGRWc2WGFsU2ZkR0xBd3lWbVkxN0VrU2YxT3BpeVBiMGtz?=
 =?utf-8?B?ZTcxNTFBdWxZdklKVEhnYmRqblQrU3pvcE1haHlxNmRpbjJVMEowdmdaR0U1?=
 =?utf-8?B?RjBEZXBTK0lWZGc1NlRYS0JFeUlIa01WRzExS0gxNEhlb01Hb0lXRjJNLzZC?=
 =?utf-8?B?SEwvREJIUWY4QndKTzUySHpobVdnSHo4bU1wYklKR1NnckRUbCtiS2xLdUtG?=
 =?utf-8?B?dllOUTBFZ1FDd0NjWUYxWHBPdmgyZERYVkdFTk1MZmUwY29kWGVEemI5bTV6?=
 =?utf-8?B?ZGkxc05ucDE2UitVajFvNXZCWGovWDBzL0VZbTUyb2dKZmU3eHNJL3VRaGNx?=
 =?utf-8?B?N3pYN0VJU083U0w0aDhPWitKQ2phNEJKSGx6aXl6dUxad2RjU1NzSDJ4eDl4?=
 =?utf-8?Q?/Tok7b2krdwsm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnQ2MGVEY2RDNGdEaVgxdnBnZmgwR3dYNzEvSDVMZU5ndHpmNmg4ZmQwN0tS?=
 =?utf-8?B?SlZXYnlZNjY2QUZJbnBGRlZ5eGZuSlkyZzIvOWdtSENiU0hWcFBMNFRFVkpx?=
 =?utf-8?B?OUVORkYzblVVUExPQ1hyZEdEVy9JbVVqN3AxSzV3S1I5Y3UyZlkvYk8wQ05z?=
 =?utf-8?B?SUpWWFRubndDWjEzSlRPOHgxTUlnZkhKRzlZL05TTDkxMmpxbVNjaGRudGNV?=
 =?utf-8?B?S1FQamM5SUNuNUFTajJ6OGVLWGk0WTIrNDhMZHREOXhockhVWVRuOW1pc1ZU?=
 =?utf-8?B?YTN0MTE1OU1EdXlHdnRoT1d1MW54VW9sR2xxQmJ1TEdzOEZVZ2N5SkNlMzlF?=
 =?utf-8?B?M2hjRDllUVJhNk1IR1JheHh0cmJBSjEvNVFpS29vYWNuQm50Z2UzZTNSaTB3?=
 =?utf-8?B?NDFIQlFuZ2l1T25vc2xVOU9RbkliK3BiS1BZSG5WVjRqZ0FnOUlrTnlac083?=
 =?utf-8?B?eDRBV1N3dm1tMG1UcGQxMktpT1J6T0FTZjF6ejlVa1NjWDYzczNGak14QmF2?=
 =?utf-8?B?SEY3UnEvQW5CZTlvaUljeURWU0F3VWduQWlVeE1tUlZqSHlZbnl5UVRWalFS?=
 =?utf-8?B?OXdiUVh0RmlWL3hQd0V5bFNwQk5NcG1wK2tpdS9obkltTFpGakdsU1NZbzhv?=
 =?utf-8?B?ZEVVQjlLdU9ibGdjcHpiRjJoTkNUZlZqa3FlNWFLU0I5dU8vb3JvendLcVVP?=
 =?utf-8?B?SkJOSFNqQm5xbXQzNkc5ZjltU2E2cGdSaytLU1liWFdJSkFTeXkrNjZCNnlv?=
 =?utf-8?B?RE1MWFZrdmhKb2xTTy95MkExVmN1clNEeFpOTlk0VWJRcDRHdURGVmpXdngy?=
 =?utf-8?B?SElPU0JweTBaK285RVVDcWNmN3RrV3l4ejFDM2VtRlMyQ0RoZjFqQWFZOCtY?=
 =?utf-8?B?ZmdET3lBQk9BU0tZck51R3F2MVpRTFBHSUEzVGtvVS9FVUU1Z2tSQlpGRjVh?=
 =?utf-8?B?U2gxaUN4Nk0xNGp3a3R2b0xjNWRibzh6Uy83UjFUV3VTYlRBWThSOHJtUEVp?=
 =?utf-8?B?VFdRUDlyMUcyZUMvRTJRNUo4YjdQRGtsWmRLaGZXWXk4L2p1OWxlYU1raGhw?=
 =?utf-8?B?K3FjamtJTmhEdWwrYk44TG1rdVRnZGFXU0ZiUDhYS2RhZHpVY25MeWI3bHlL?=
 =?utf-8?B?MjYrZWIwdnFQSDRRbjVUVURmSjhlWDErNjhPK1lNSmY4YXFqUmdiSDFFSFJx?=
 =?utf-8?B?VTA0dCsxSVM5U0UrSXh0U0tKL3VNRkR4WGtKNUs5WGp3TExVZG5pU2ZGYzNJ?=
 =?utf-8?B?RSs1cWw5RWpHSlVWS1YwZmlCZ2V0NlhOYTNjR1ZlQ0JlVTh4eFhMQmtFSk56?=
 =?utf-8?B?ZW83MEdKWnN5U3R0ODBLelB3VGJDRUl6YzloanJpbFdlTStmSnlxSkhFNW14?=
 =?utf-8?B?QXc5Q1pkTHhlT0VhckUxSUV4ZFdGRjI2R0VqSktlOXZMTFVnZDhUbXY0ZzRX?=
 =?utf-8?B?UitTNlZjcmx6SFFaR3EvUmdqYlhKbEtML0I1SUtIbkROOGtYRWFBUnIwM3Zr?=
 =?utf-8?B?cTRXblVlUmNZdnNmZk5hYXMvbDd6WFJuamlEWnhHVzVDMTBnZzZjZXFzVGkw?=
 =?utf-8?B?c21mQXByTnhwUmUwTWJVWkZXWVpPUjI1R2J1VDlTQzhJMXN2c0hKellKdlZj?=
 =?utf-8?B?SGhLOVNnYUw5elMvR24wTFVLVjFudFZSL2RqMWwvclFFakdWK3VkZlozN3J0?=
 =?utf-8?B?dDVzS2JoL01pK250UGxweVlPZll4eVJ6YTh4R0J4U0VBNzlDam1Rc0RFcWdU?=
 =?utf-8?B?eTM0S0RHTnlsZ2xPMDgrOEZtT2dzbGx1NUdPOGowRHlZUnRadEticHBrTXNK?=
 =?utf-8?B?azZWWkpxcElXeGd2Y2M3dldxaENad1JtNzBRbHZGN1pHa0pkWkhmZkRJeFpG?=
 =?utf-8?B?L0lYZnBCODhERWVSYm9NajJEL2NyRU1kSmdPRFVQaWw0NU5OT0RYcnpld2F4?=
 =?utf-8?B?ZThxNzAvdlBlWnBYSnpYdWxMTHRVUGVta0pHR2ZlRWcrZ3ljYjVJN05IcHE0?=
 =?utf-8?B?TXJ4TmNZcmUyTlpwU0lYc2RidU9qQllUa1d4RldueG4yT2kzU0NjYTh3RjR5?=
 =?utf-8?B?UzhwcDdzSVBUUE53T1oxZ3c3ZUNwdHdlYTVIeXNkeDdxSGRrMmpXWWtmaEdM?=
 =?utf-8?Q?L+7QO/tEZ4pNzeM8UxVWaN3qx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc6d6e6f-798c-4d24-716d-08dd90fb35dc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 02:17:57.4694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUF4tGQY+62i0GPDwEcFCCpt9ZUZ9xn0zaL2hPSOnvS1woA1sqg+B/Pvlo0NZxMHGqy20oO/No86I2+AiffzeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7034
X-OriginatorOrg: intel.com

On Fri, May 09, 2025 at 07:20:30AM -0700, Vishal Annapurve wrote:
> On Thu, May 8, 2025 at 8:22 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Thu, May 08, 2025 at 07:10:19AM -0700, Vishal Annapurve wrote:
> > > On Wed, May 7, 2025 at 6:32 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > On Wed, May 07, 2025 at 07:56:08AM -0700, Vishal Annapurve wrote:
> > > > > On Wed, May 7, 2025 at 12:39 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > >
> > > > > > On Tue, May 06, 2025 at 06:18:55AM -0700, Vishal Annapurve wrote:
> > > > > > > On Mon, May 5, 2025 at 11:07 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, May 05, 2025 at 10:08:24PM -0700, Vishal Annapurve wrote:
> > > > > > > > > On Mon, May 5, 2025 at 5:56 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > > > > >
> > > > > > > > > > Sorry for the late reply, I was on leave last week.
> > > > > > > > > >
> > > > > > > > > > On Tue, Apr 29, 2025 at 06:46:59AM -0700, Vishal Annapurve wrote:
> > > > > > > > > > > On Mon, Apr 28, 2025 at 5:52 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > > > > > > > So, we plan to remove folio_ref_add()/folio_put_refs() in future, only invoking
> > > > > > > > > > > > folio_ref_add() in the event of a removal failure.
> > > > > > > > > > >
> > > > > > > > > > > In my opinion, the above scheme can be deployed with this series
> > > > > > > > > > > itself. guest_memfd will not take away memory from TDX VMs without an
> > > > > > > > > > I initially intended to add a separate patch at the end of this series to
> > > > > > > > > > implement invoking folio_ref_add() only upon a removal failure. However, I
> > > > > > > > > > decided against it since it's not a must before guest_memfd supports in-place
> > > > > > > > > > conversion.
> > > > > > > > > >
> > > > > > > > > > We can include it in the next version If you think it's better.
> > > > > > > > >
> > > > > > > > > Ackerley is planning to send out a series for 1G Hugetlb support with
> > > > > > > > > guest memfd soon, hopefully this week. Plus I don't see any reason to
> > > > > > > > > hold extra refcounts in TDX stack so it would be good to clean up this
> > > > > > > > > logic.
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > > invalidation. folio_ref_add() will not work for memory not backed by
> > > > > > > > > > > page structs, but that problem can be solved in future possibly by
> > > > > > > > > > With current TDX code, all memory must be backed by a page struct.
> > > > > > > > > > Both tdh_mem_page_add() and tdh_mem_page_aug() require a "struct page *" rather
> > > > > > > > > > than a pfn.
> > > > > > > > > >
> > > > > > > > > > > notifying guest_memfd of certain ranges being in use even after
> > > > > > > > > > > invalidation completes.
> > > > > > > > > > A curious question:
> > > > > > > > > > To support memory not backed by page structs in future, is there any counterpart
> > > > > > > > > > to the page struct to hold ref count and map count?
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > I imagine the needed support will match similar semantics as VM_PFNMAP
> > > > > > > > > [1] memory. No need to maintain refcounts/map counts for such physical
> > > > > > > > > memory ranges as all users will be notified when mappings are
> > > > > > > > > changed/removed.
> > > > > > > > So, it's possible to map such memory in both shared and private EPT
> > > > > > > > simultaneously?
> > > > > > >
> > > > > > > No, guest_memfd will still ensure that userspace can only fault in
> > > > > > > shared memory regions in order to support CoCo VM usecases.
> > > > > > Before guest_memfd converts a PFN from shared to private, how does it ensure
> > > > > > there are no shared mappings? e.g., in [1], it uses the folio reference count
> > > > > > to ensure that.
> > > > > >
> > > > > > Or do you believe that by eliminating the struct page, there would be no
> > > > > > GUP, thereby ensuring no shared mappings by requiring all mappers to unmap in
> > > > > > response to a guest_memfd invalidation notification?
> > > > >
> > > > > Yes.
> > > > >
> > > > > >
> > > > > > As in Documentation/core-api/pin_user_pages.rst, long-term pinning users have
> > > > > > no need to register mmu notifier. So why users like VFIO must register
> > > > > > guest_memfd invalidation notification?
> > > > >
> > > > > VM_PFNMAP'd memory can't be long term pinned, so users of such memory
> > > > > ranges will have to adopt mechanisms to get notified. I think it would
> > > > Hmm, in current VFIO, it does not register any notifier for VM_PFNMAP'd memory.
> > >
> > > I don't completely understand how VM_PFNMAP'd memory is used today for
> > > VFIO. Maybe only MMIO regions are backed by pfnmap today and the story
> > > for normal memory backed by pfnmap is yet to materialize.
> > VFIO can fault in VM_PFNMAP'd memory which is not from MMIO regions. It works
> > because it knows VM_PFNMAP'd memory are always pinned.
> >
> > Another example is udmabuf (drivers/dma-buf/udmabuf.c), it mmaps normal folios
> > with VM_PFNMAP flag without registering mmu notifier because those folios are
> > pinned.
> >
> 
> I might be wrongly throwing out some terminologies here then.
> VM_PFNMAP flag can be set for memory backed by folios/page structs.
> udmabuf seems to be working with pinned "folios" in the backend.
> 
> The goal is to get to a stage where guest_memfd is backed by pfn
> ranges unmanaged by kernel that guest_memfd owns and distributes to
> userspace, KVM, IOMMU subject to shareability attributes. if the
OK. So from point of the reset part of kernel, those pfns are not regarded as
memory.

> shareability changes, the users will get notified and will have to
> invalidate their mappings. guest_memfd will allow mmaping such ranges
> with VM_PFNMAP flag set by default in the VMAs to indicate the need of
> special handling/lack of page structs.
My concern is a failable invalidation notifer may not be ideal.
Instead of relying on ref counts (or other mechanisms) to determine whether to
start shareabilitiy changes, with a failable invalidation notifier, some users
may fail the invalidation and the shareability change, even after other users
have successfully unmapped a range.

Auditing whether multiple users of shared memory correctly perform unmapping is
harder than auditing reference counts.

> private memory backed by page structs and use a special "filemap" to
> map file offsets to these private memory ranges. This step will also
> need similar contract with users -
>    1) memory is pinned by guest_memfd
>    2) users will get invalidation notifiers on shareability changes
> 
> I am sure there is a lot of work here and many quirks to be addressed,
> let's discuss this more with better context around. A few related RFC
> series are planned to be posted in the near future.
Ok. Thanks for your time and discussions :)

> > > >
> > > > > be easy to pursue new users of guest_memfd to follow this scheme.
> > > > > Irrespective of whether VM_PFNMAP'd support lands, guest_memfd
> > > > > hugepage support already needs the stance of: "Guest memfd owns all
> > > > > long-term refcounts on private memory" as discussed at LPC [1].
> > > > >
> > > > > [1] https://lpc.events/event/18/contributions/1764/attachments/1409/3182/LPC%202024_%201G%20page%20support%20for%20guest_memfd.pdf
> > > > > (slide 12)
> > > > >
> > > > > >
> > > > > > Besides, how would guest_memfd handle potential unmap failures? e.g. what
> > > > > > happens to prevent converting a private PFN to shared if there are errors when
> > > > > > TDX unmaps a private PFN or if a device refuses to stop DMAing to a PFN.
> > > > >
> > > > > Users will have to signal such failures via the invalidation callback
> > > > > results or other appropriate mechanisms. guest_memfd can relay the
> > > > > failures up the call chain to the userspace.
> > > > AFAIK, operations that perform actual unmapping do not allow failure, e.g.
> > > > kvm_mmu_unmap_gfn_range(), iopt_area_unfill_domains(),
> > > > vfio_iommu_unmap_unpin_all(), vfio_iommu_unmap_unpin_reaccount().
> > >
> > > Very likely because these operations simply don't fail.
> >
> > I think they are intentionally designed to be no-fail.
> >
> > e.g. in __iopt_area_unfill_domain(), no-fail is achieved by using a small backup
> > buffer allocated on stack in case of kmalloc() failure.
> >
> >
> > > >
> > > > That's why we rely on increasing folio ref count to reflect failure, which are
> > > > due to unexpected SEAMCALL errors.
> > >
> > > TDX stack is adding a scenario where invalidation can fail, a cleaner
> > > solution would be to propagate the result as an invalidation failure.
> > Not sure if linux kernel accepts unmap failure.
> >
> > > Another option is to notify guest_memfd out of band to convey the
> > > ranges that failed invalidation.
> > Yes, this might be better. Something similar like holding folio ref count to
> > let guest_memfd know that a certain PFN cannot be re-assigned.
> >
> > > With in-place conversion supported, even if the refcount is raised for
> > > such pages, they can still get used by the host if the guest_memfd is
> > > unaware that the invalidation failed.
> > I thought guest_memfd should check if folio ref count is 0 (or a base count)
> > before conversion, splitting or re-assignment. Otherwise, why do you care if
> > TDX holds the ref count? :)
> >
> 
> Soon to be posted RFC series by Ackerley currently explicitly checks
> for safe private page refcounts when folio splitting is needed and not
> for every private to shared conversion. A simple solution would be for
> guest_memfd to check safe page refcounts for each private to shared
> conversion even if split is not required but will need to be reworked
> when either of the stages discussed above land where page structs are
> not around.
> 
> >
> > > >
> > > > > > Currently, guest_memfd can rely on page ref count to avoid re-assigning a PFN
> > > > > > that fails to be unmapped.
> > > > > >
> > > > > >
> > > > > > [1] https://lore.kernel.org/all/20250328153133.3504118-5-tabba@google.com/
> > > > > >
> > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > Any guest_memfd range updates will result in invalidations/updates of
> > > > > > > > > userspace, guest, IOMMU or any other page tables referring to
> > > > > > > > > guest_memfd backed pfns. This story will become clearer once the
> > > > > > > > > support for PFN range allocator for backing guest_memfd starts getting
> > > > > > > > > discussed.
> > > > > > > > Ok. It is indeed unclear right now to support such kind of memory.
> > > > > > > >
> > > > > > > > Up to now, we don't anticipate TDX will allow any mapping of VM_PFNMAP memory
> > > > > > > > into private EPT until TDX connect.
> > > > > > >
> > > > > > > There is a plan to use VM_PFNMAP memory for all of guest_memfd
> > > > > > > shared/private ranges orthogonal to TDX connect usecase. With TDX
> > > > > > > connect/Sev TIO, major difference would be that guest_memfd private
> > > > > > > ranges will be mapped into IOMMU page tables.
> > > > > > >
> > > > > > > Irrespective of whether/when VM_PFNMAP memory support lands, there
> > > > > > > have been discussions on not using page structs for private memory
> > > > > > > ranges altogether [1] even with hugetlb allocator, which will simplify
> > > > > > > seamless merge/split story for private hugepages to support memory
> > > > > > > conversion. So I think the general direction we should head towards is
> > > > > > > not relying on refcounts for guest_memfd private ranges and/or page
> > > > > > > structs altogether.
> > > > > > It's fine to use PFN, but I wonder if there're counterparts of struct page to
> > > > > > keep all necessary info.
> > > > > >
> > > > >
> > > > > Story will become clearer once VM_PFNMAP'd memory support starts
> > > > > getting discussed. In case of guest_memfd, there is flexibility to
> > > > > store metadata for physical ranges within guest_memfd just like
> > > > > shareability tracking.
> > > > Ok.
> > > >
> > > > > >
> > > > > > > I think the series [2] to work better with PFNMAP'd physical memory in
> > > > > > > KVM is in the very right direction of not assuming page struct backed
> > > > > > > memory ranges for guest_memfd as well.
> > > > > > Note: Currently, VM_PFNMAP is usually used together with flag VM_IO. in KVM
> > > > > > hva_to_pfn_remapped() only applies to "vma->vm_flags & (VM_IO | VM_PFNMAP)".
> > > > > >
> > > > > >
> > > > > > > [1] https://lore.kernel.org/all/CAGtprH8akKUF=8+RkX_QMjp35C0bU1zxGi4v1Zm5AWCw=8V8AQ@mail.gmail.com/
> > > > > > > [2] https://lore.kernel.org/linux-arm-kernel/20241010182427.1434605-1-seanjc@google.com/
> > > > > > >
> > > > > > > > And even in that scenario, the memory is only for private MMIO, so the backend
> > > > > > > > driver is VFIO pci driver rather than guest_memfd.
> > > > > > >
> > > > > > > Not necessary. As I mentioned above guest_memfd ranges will be backed
> > > > > > > by VM_PFNMAP memory.
> > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > [1] https://elixir.bootlin.com/linux/v6.14.5/source/mm/memory.c#L6543
> > > > >
> 

