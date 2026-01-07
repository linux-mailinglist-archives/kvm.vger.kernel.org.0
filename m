Return-Path: <kvm+bounces-67206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DFF9CFCC2B
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 10:13:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E26E030549B7
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 09:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F5E62F691F;
	Wed,  7 Jan 2026 09:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wwyn7C5V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF49D2E54B3;
	Wed,  7 Jan 2026 09:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767776759; cv=fail; b=QbcMMUl12Qk/X6zd3pV/puytJDzVDJF0cr48Vw5ev2YsNxRarFmMIPgWKarEw8nPQffW+HLsrqcnluH4YS8ZPYZxSIbjXrGy6n+Y+gFchD+TD6j2Mxbxjh1/5NYs9QnUElFj33dvJ1wyYVp6eUxItE0LD0GXbKnSkfa9qNPUZKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767776759; c=relaxed/simple;
	bh=dJDrXRI4bFxUjIujbHkVtnmdwt0FKohwJgU2A1Ax0uE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GigNXdUJQKFnnDDcxtMb899zEDVtHV7nP6bXQKWBjpsj6dDSRcc7fYDZuLLGrScU9D5g1ksVEvNdaX12h7zpTXyAxTOZRGV+FkOsqGQt9ZMx9zwTfCByLh7EP6c1kp6g8PPcVBt5WcJ5XbiRlks0gO2ag/CszFjSAzKIqio8XkM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wwyn7C5V; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767776758; x=1799312758;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=dJDrXRI4bFxUjIujbHkVtnmdwt0FKohwJgU2A1Ax0uE=;
  b=Wwyn7C5VxKv8QYDOUN9zdgX7aX5/PVgsp/KIq/4BnyPG1byFAlaN06Rp
   VzenZ4LmVDGbDYIl6Guvy8xVqcb64BYw29Nh8N4qPfpaPySu1MEV0zuKR
   SkVjLw0iYnf0j1K5RO6lxCrvL1odN+lru1LRVLOEmtt16NA8E7zL0G27O
   L5qdMhfyyN+rRlNe+8gGjW4Rwoi6sJ1PHqvZBrm9GfRVdF9ebDH0ZetCu
   ScMdvARarP4DuwLXQ2k6E7bcdcr+q3CThF6cPWYNnscPOx0NssPa7LV7D
   x2pXBXdEwmcIi7nMyZPrMVSrWlb4gMvbJ+mFEqgLirZSPk/l5vTGcb+z7
   Q==;
X-CSE-ConnectionGUID: s9UT3Q7KSy+IG79i6k5mrQ==
X-CSE-MsgGUID: WRdQ1ZCCQnGm4bJgEVfZMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="72997769"
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="72997769"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 01:05:57 -0800
X-CSE-ConnectionGUID: 49x2yZxnREG8TGhKv4ixdQ==
X-CSE-MsgGUID: jW4lmk+LSGSqYvGwOaaYBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="202934054"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 01:05:56 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 01:05:55 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 01:05:55 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.42) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 01:05:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wK25iygEu4FlyN8fxefqCUbRKcX2p0CDqYZJNA0uN9lHHT3fgpfnDoTi6kkbK7OlV2kEmyjGGcDSf0tGEYozr0pHCZIGH57AsJMb4pKX7jDJJzsCIrsWVFJJUJt3+vcvZXqkv2IiPtQuQhfWSJlAEkQH/KRHkMH/ql6tAyjDaa+HmH+DGis42pAf6/RJok79Hi/3lOfEO7h3KNHXkbSvcF8psbSqVTMzc+zuDhblv9JxsR2b+NHi9j8KJQdAt23V/WvICp3V9cgH57jajXqRsqwq3j/FLeg/VF7RCBh/vpsyURMsk0ZRw/XpcPrjgncf3BdDAx5SDVbBjLNGlA4mMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RTeiRxiMwiVSgxRhgWeJm/1b7YI7VgkeafAXudDAxL8=;
 b=kHTEABF4dMnnAAX9BFWuya2+oh1FnUT2/getJKiV/F+0ijmfYjTGKoyp61bhuyIfJ/kMV7ZmvCjjFuomtNSv7dD0gSajamIpqM3yIPxRsKeIo3JW7DF3ctCu+UebQ9ZSZ4kwYir+wAA3ma6W6WrS1g0TJZBIuqoXmfVSBKGssGSoPQyZuRLHgeiw3TqbQjE2rvxR+19hgz8xLxbsWqd8gdbmGtUEaUqtty2g2oVXPdsGmTyNN2l+KBvZ1b0XT7d3ZgTBDU+C7N2fkgVyVpN+dABWzdIoshxYY6BF/PM88KhZ4THo+4NHy5L7cLiaVv6Xa5DtCeN8AfSOpd9T1M8l+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB6839.namprd11.prod.outlook.com (2603:10b6:303:220::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Wed, 7 Jan
 2026 09:05:51 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 09:05:51 +0000
Date: Wed, 7 Jan 2026 17:03:41 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, Vishal Annapurve
	<vannapurve@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <michael.roth@amd.com>, <david@kernel.org>,
	<sagis@google.com>, <vbabka@suse.cz>, <thomas.lendacky@amd.com>,
	<nik.borisov@suse.com>, <pgonda@google.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <francescolavra.fl@gmail.com>, <jgross@suse.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<kai.huang@intel.com>, <binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>,
	<chao.gao@intel.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Message-ID: <aV4hAfPZXfKKB+7i@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com>
 <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aV2eIalRLSEGozY0@google.com>
X-ClientProxiedBy: TP0P295CA0042.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB6839:EE_
X-MS-Office365-Filtering-Correlation-Id: 99f65421-38b5-4606-773b-08de4dcbf471
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S3VPSHUyL0Z1bSs4RjhLUVQ2VnpvQVJyOENMblpPRFRacDF1QkZxZmpadzlv?=
 =?utf-8?B?SDF3MFFFK3N0V3A5MTVXMTFTNUlhY2hmbXVWMWFNS3pnT0UzdVIwVG00Q3cw?=
 =?utf-8?B?c1k4UHNiaXl4Z0h3aEN0L1VPZXpBd0hHeEd4VWZHSGpYMTVVY0tSamE0QlUw?=
 =?utf-8?B?eDFVS1BJS2dObDdmVGVBV0JlYVJ0WTAxTWZFMzBQMGR0bEsxaEg0MXpXZWp0?=
 =?utf-8?B?MmlwWjBWUTNKeVN2QWpqc2lrS0ZKaytLdTVUaCtjWFE0NC85dkYyMERab3BC?=
 =?utf-8?B?RnVGdE1KYzI3eE9HTjJ5NHVXZDVBUmI3VlloL0M0WEdDcHRZcTd4ZTd6eXMw?=
 =?utf-8?B?SkQxWUlvdVpVWUp1dnBrUWxuMUFMYUJ0R2xRUTRSUkNwZnNIU0lhczJzTnFl?=
 =?utf-8?B?aXh3Q1Z0MnNVRHdyUWpzQVlWbnV1NVFrWm9XWCtybHo2VEcramttZ1p6Ukx4?=
 =?utf-8?B?K2xodC9BbW03YXo3V1lENHp1MVJBQjhSbXRkVEZPWnVSdkF6YXdDUWo0RUJO?=
 =?utf-8?B?VE1IWm9GS01RdGZDTVBtemlXaFlpc3ZYNEZKWklyTFp1SVI1MVgyVEpPQUdV?=
 =?utf-8?B?ZlFUdzZTK2U2QUNkZGJDb1YxZ0JnUTk5aklSdjZlbUFSVFJxQXRuOVRCZTNu?=
 =?utf-8?B?WjlTTUtpTjIzWlJueWszaGhEaktPL2d1a1R5V1Q3RllXVm1zWnIvQ0RQVHJJ?=
 =?utf-8?B?OFlHN0R0ZGFDWWpYWVNwbFdRaVFYeXBaR05JYXFRNUtZNWtnQUlIRFJEMk56?=
 =?utf-8?B?T1JHdWZmMWNIUWlxNmxGaU9zZmFtbXZNbHNqZVdRdTZ6N04xQk0vY3JHbE5G?=
 =?utf-8?B?WXdYbEEyVXZPbWlocElsYWNqUDVSVnNUQ0M5cXdwZjhrSSt6bU0yM1oxQ0pX?=
 =?utf-8?B?d1g5YUxMOTJjMXBkUG0vTUsrSUVqbGlVamJrK1VDVytZa25YaUoxMDB6Rksx?=
 =?utf-8?B?OS90Kzl2N0YxbHNZOHVZWVg5UkJHK3FMY1ozR04rOFRjSnQ4d2tCaVBXdFZY?=
 =?utf-8?B?bEhPTUZTMnQybkxhdzE4TW5BcGNjVFJrSmlMT2hDUmhJTnV3cDZBVEdSaXRz?=
 =?utf-8?B?UGR0SzNJeHE2emlERE92elFqaTYyOXE1S3lHbGw2UlF2MzlZRWV0WFVXVVJk?=
 =?utf-8?B?VFFqUzVOOWIvbDYyTDJRZjBpUW9KT2JwcHgrSWo4RytDc2pDVDVMWkdpVVB5?=
 =?utf-8?B?bmZ1TkFNT2hwWld4OS8rWmwrdTg1MmJLUGUvNnpxTTlTUTZuUXdyT2xVRVN1?=
 =?utf-8?B?RHNURGd3bXhLZ2Z1TUNUYW90TjhnVmNoeXhSbExua21GdW82OTFVYlhvZHB5?=
 =?utf-8?B?b25lYnRMQjd0cUNrV0tjdlNTdi9wMTRvUHNZTkpWM2IzNXFvWllaZ002NmEy?=
 =?utf-8?B?ck8xRkNTZE1PYjFKMUo3UE0veDR3MEduN1BFUkJNTmFxVnZETjZyN0hOL21L?=
 =?utf-8?B?Q3hVRU1EU2tpelJWRlNxd0hjaVFIMFpGYk9OUWFBRzlqbXpwK2x2cmN2ajJX?=
 =?utf-8?B?UkJreVd0S1RIb3BhMjVFL3QxWFVEdVFoL0JrUmtubWEvMEF3V0FUOVUwQlpP?=
 =?utf-8?B?UndmbnhFRVRYQXJJdzJEblVLYmY2RlJ0K2kvOUxNTy96RWRDOHd2L1phb0pG?=
 =?utf-8?B?dWFWd25tcmU5ZzNTMWZMMEIzQWg5Smh0cHdZZVFSYmhoa2QzS1Y5VzZmc1dp?=
 =?utf-8?B?VjY2a2drZUg3YU0yWld6UlQzbFRtT1haUktDTXRQSHVsMEdFaUZRdjE4bVFs?=
 =?utf-8?B?blVHVC9ETmxhNGhGcDFFZmdTUkxKZlNwNUNXOFpiUmltWUpxUUJkTi85T1Ex?=
 =?utf-8?B?SW9vMW9WdWpLclV4SldVNnNMQ1hLUFNJd1JFc2l4OXNsNTlRQVE5V3lmWXpK?=
 =?utf-8?B?OU9JNlV6ZGVvRjQ1akdPdm5PMXlRTUliSStKS0VLN0xucGpTcmRRL1Y4Vkgr?=
 =?utf-8?Q?o75dit/+uvFvroRgcPCXVoRrTsVyOOBO?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXo5MHpGMXZPaVQvRG9pY2pwVmlhZ2dxdE1WeU42eW1VTTJSenNXSjBpVitZ?=
 =?utf-8?B?QXd4czYrMjlQZWhiTnJEeC82bWZ1SFZOb3hQSkF5bVFpcFpkZkdldHgrVC91?=
 =?utf-8?B?TUJ6THpSdmNSTnVRWlNEd0xzdEp1b3o2aVFPZWFRQi9SdmxrSkkwK21RYjFZ?=
 =?utf-8?B?V1NlVDlLUWdkeXd6SklaQ0FUSHJhZ2RORHoyQ1kxMVdiQ3hTenoxUi9ualpy?=
 =?utf-8?B?N3BjVUoxcFB3UmpCaGxiL1ZIOHRjcW53WmVCczAyN0g0V2R2a3FLenp5Yitu?=
 =?utf-8?B?VkswQU16RVhSZy9SVzZ2d1d1RFp5eW94dlh2Qmg1R25GTHhDRVFUZWJML0M4?=
 =?utf-8?B?VXNjVDVKcTloNlZEZzBDWndQYW9mUkI1VnRYLzRMUjk5MUwxNjVwV2U5Zlpu?=
 =?utf-8?B?VmtiWjFHR2daSkNDNDJPY2JkaHl4VTkveW5BQWJxdktTdjdVYmRtcTZNUSty?=
 =?utf-8?B?cXprY1YzN1lKaTJxVit0WC85UERlMjkvN091czVnVUdYNHRuZFJObG9LTUdW?=
 =?utf-8?B?aFBqVmw1Und6RWV4WkNYbmp5MzJMdVJ6cHNncjRpV2J1M0FNeGg2TzBFMzA5?=
 =?utf-8?B?UEZRbTRhN2xuNXJiVCt5NnBHN29LaENPcjlPM2s2c1NPckpncy92MmRoUXZH?=
 =?utf-8?B?Q1pUdERaWmFrYUhMUUE5aUFtekdIVmw5ejlCSTBsbXhZcVNReGZYYmxFemgv?=
 =?utf-8?B?bUpiSmlHN3orNTU3c29PMzExTndHdzdrbWdUNnNZa0oyQ25mcFNpVHdPenJH?=
 =?utf-8?B?UEExTVhQWHNQbXZLY1N3VzJZU1A3b2tHeS80THJMUmUzQnVGeXJtWnY2WWpG?=
 =?utf-8?B?SndDM2ptKzNVMkxLWEtWeHlQKzdFaG82ajE4bTZtalZZM3pvWmUxb0xDQUE1?=
 =?utf-8?B?a3lxV29rcVJwbUZwcUZQZWxEU1c0ZUNscXFvTHhEelZzOXI4MEVxT2h0QlhV?=
 =?utf-8?B?QU9CbXJGRFkrenpzSjA3U1JJK3hsWEIvQkR1RGJyVmFodXE5cWFBQWU2ZkpK?=
 =?utf-8?B?TE8vOTIzSklTOGxaSlJ5Qittb1NqZytUV2FVU1RiZVhSR0FjY1hJRjNSNzV5?=
 =?utf-8?B?bUcvV291SVJCV0RLU0ExbERvZkIyMXNsMnYydlRkZ0xBMk53c2t0TDdubTYy?=
 =?utf-8?B?U3FWVVJBTDEwbmxqTGoveU9mQkRIQTM0RnBqY2NEWXY3OW9aWnJZeXpPcW44?=
 =?utf-8?B?RHdWQzcxbU02TThETWNRemhUb2NXU1BlWUNZYUEwMjlqWGxQOEIvL3ROTE41?=
 =?utf-8?B?blk2a3ZIelV5ZVg1UGtpb05DODFidDNVdlpXVmdYb2NjRTB4V3FaQStYWTJO?=
 =?utf-8?B?TWRwYWRyWElSbCtKLzZGZUJaWTh1V2EzcWlTMkR3QjRhMGRwOWl0NzQ0cldX?=
 =?utf-8?B?SUJUTnRPbW1aaDdBRkpwSnpHTUt2b3A1QzBBZEhrL3V1dXZ6c3puQnNqNk9r?=
 =?utf-8?B?NGFDb3ppcW5pNTRtcVNMcEdxL2UybDUxMzRhcVQ3ZVRPUFFIZnBGcE1MSTkw?=
 =?utf-8?B?N016YTFDeFJsTXhYVk9waDRKbU9tWEp0ZHZhT1hWT0ZyYVlLd0RFUmUya2J6?=
 =?utf-8?B?ek41THVNaXNES0c3bnFJaVhqbS9EZGdNS1F4OEU3MmNDcVppYVR3bjdWbnJr?=
 =?utf-8?B?WklEYjRyOE9DbGRmTU43NmN5QW12TTUxNU9QbTF1Y2FkZUFqdWx5NHRpeDhQ?=
 =?utf-8?B?TEYzYVUrTGpJcC9MY2I4SDFycVV3OVZVOE1mYVYxRFBMZm9KNStYRFRkdUhy?=
 =?utf-8?B?d0R0NkxtbUR1OFBMQmtNcFRHMTRYL0hSWGJKUkNpRUdlSURrWms5OVRPVUVD?=
 =?utf-8?B?UEtaVGJJRWQ2czBzaDBDOEM1cVBYVis5L1BLUXNYamRReWlqOU8wMWZjUFlH?=
 =?utf-8?B?NWZ2OHpXT2IzTCtlaEE0RkJ1MitGL0tDdUNqS3hoMk1QYTJoVFdTa0E2WGkv?=
 =?utf-8?B?Ujd6bW96NjlKQWJzcTNCdUNsUzVldCs2ckc3Z2xSOGprbjl2dGpINTdKK0dx?=
 =?utf-8?B?MlZNOE1FdFVTTDlqQjhEZUYwU2tSOHVRVXZQUnBrbUUrS3Z0YWc5akl0eHB2?=
 =?utf-8?B?aEhpcHNYdTNmNUFzRzBMWm9WdStUSTJDUFlERml1K0s4Qit5djB1b01lanFh?=
 =?utf-8?B?TW13ckQvSVNIMmw3UExvK0Y5Zk5XYkR6VkFtVnc3WHJxZCtzcUtJM3RnVmRQ?=
 =?utf-8?B?eFIzWGhlZUZ1TmFaQUNMdFd4TjhIeUhOelFqc3IzVkFsQVdMSFhlcjVWS280?=
 =?utf-8?B?UEpXQjJ2U1pSck9tRXlydlUxaXFjaHpLZS9RSzBVR1FhRTBFUzhWNVovV2dk?=
 =?utf-8?B?TUQ3SnNKQ0dQSWpxalVlK2o4N2czUUZ4L0FYSWQ1NUFTNFphb3lCUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 99f65421-38b5-4606-773b-08de4dcbf471
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 09:05:50.9662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: effSS+JFwArGMySEGQKM/x7nKfFdwWWjB0PHONO7Ri8mhQfa0nl4ezyTlOZC4cavToufUqD2RGjSgUY8xfvihA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6839
X-OriginatorOrg: intel.com

On Tue, Jan 06, 2026 at 03:43:29PM -0800, Sean Christopherson wrote:
> On Tue, Jan 06, 2026, Ackerley Tng wrote:
> > Sean Christopherson <seanjc@google.com> writes:
> > 
> > > On Tue, Jan 06, 2026, Ackerley Tng wrote:
> > >> Vishal Annapurve <vannapurve@google.com> writes:
> > >>
> > >> > On Tue, Jan 6, 2026 at 2:19 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >> >>
> > >> >> - EPT mapping size and folio size
> > >> >>
> > >> >>   This series is built upon the rule in KVM that the mapping size in the
> > >> >>   KVM-managed secondary MMU is no larger than the backend folio size.
> > >> >>
> > >>
> > >> I'm not familiar with this rule and would like to find out more. Why is
> > >> this rule imposed?
> > >
> > > Because it's the only sane way to safely map memory into the guest? :-D
> > >
> > >> Is this rule there just because traditionally folio sizes also define the
> > >> limit of contiguity, and so the mapping size must not be greater than folio
> > >> size in case the block of memory represented by the folio is not contiguous?
> > >
> > > Pre-guest_memfd, KVM didn't care about folios.  KVM's mapping size was (and still
> > > is) strictly bound by the host mapping size.  That's handles contiguous addresses,
> > > but it _also_ handles contiguous protections (e.g. RWX) and other attributes.
> > >
> > >> In guest_memfd's case, even if the folio is split (just for refcount
> > >> tracking purposese on private to shared conversion), the memory is still
> > >> contiguous up to the original folio's size. Will the contiguity address
> > >> the concerns?
> > >
> > > Not really?  Why would the folio be split if the memory _and its attributes_ are
> > > fully contiguous?  If the attributes are mixed, KVM must not create a mapping
> > > spanning mixed ranges, i.e. with multiple folios.
> > 
> > The folio can be split if any (or all) of the pages in a huge page range
> > are shared (in the CoCo sense). So in a 1G block of memory, even if the
> > attributes all read 0 (!KVM_MEMORY_ATTRIBUTE_PRIVATE), the folio
> > would be split, and the split folios are necessary for tracking users of
> > shared pages using struct page refcounts.
> 
> Ahh, that's what the refcounting was referring to.  Gotcha.
> 
> > However the split folios in that 1G range are still fully contiguous.
> > 
> > The process of conversion will split the EPT entries soon after the
> > folios are split so the rule remains upheld.
Overall, I don't think allowing folios smaller than the mappings while
conversion is in progress brings enough benefit.

Cons:
(1) TDX's zapping callback has no idea whether the zapping is caused by an
    in-progress private-to-shared conversion or other reasons. It also has no
    idea if the attributes of the underlying folios remain unchanged during an
    in-progress private-to-shared conversion. Even if the assertion Ackerley
    mentioned is true, it's not easy to drop the sanity checks in TDX's zapping
    callback for in-progress private-to-shared conversion alone (which would
    increase TDX's dependency on guest_memfd's specific implementation even if
    it's feasible).

    Removing the sanity checks entirely in TDX's zapping callback is confusing
    and would show a bad/false expectation from KVM -- what if a huge folio is
    incorrectly split while it's still mapped in KVM (by a buggy guest_memfd or
    others) in other conditions? And then do we still need the check in TDX's
    mapping callback? If not, does it mean TDX huge pages can stop relying on
    guest_memfd's ability to allocate huge folios, as KVM could still create
    huge mappings as long as small folios are physically contiguous with
    homogeneous memory attributes?

(2) Allowing folios smaller than the mapping would require splitting S-EPT in
    kvm_gmem_error_folio() before kvm_gmem_zap(). Though one may argue that the
    invalidate lock held in __kvm_gmem_set_attributes() could guard against
    concurrent kvm_gmem_error_folio(), it still doesn't seem clean and looks
    error-prone. (This may also apply to kvm_gmem_migrate_folio() potentially).

Pro: Preventing zapping private memory until conversion is successful is good.

However, could we achieve this benefit in other ways? For example, is it
possible to ensure hugetlb_restructuring_split_folio() can't fail by ensuring
split_entries() can't fail (via pre-allocation?) and disabling hugetlb_vmemmap
optimization? (hugetlb_vmemmap conversion is super slow according to my
observation and I always disable it). Or pre-allocation for
vmemmap_remap_alloc()?

Dropping TDX's sanity check may only serve as our last resort. IMHO, zapping
private memory before conversion succeeds is still better than introducing the
mess between folio size and mapping size.

> > I guess perhaps the question is, is it okay if the folios are smaller
> > than the mapping while conversion is in progress? Does the order matter
> > (split page table entries first vs split folios first)?
> 
> Mapping a hugepage for memory that KVM _knows_ is contiguous and homogenous is
> conceptually totally fine, i.e. I'm not totally opposed to adding support for
> mapping multiple guest_memfd folios with a single hugepage.   As to whether we
> do (a) nothing, (b) change the refcounting, or (c) add support for mapping
> multiple folios in one page, probably comes down to which option provides "good
> enough" performance without incurring too much complexity.

