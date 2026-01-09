Return-Path: <kvm+bounces-67544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 56A9CD0826F
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 10:21:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1C351300D93E
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 09:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05552357A50;
	Fri,  9 Jan 2026 09:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lmG2HuR2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E278350D4C;
	Fri,  9 Jan 2026 09:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767950490; cv=fail; b=ODyefujGltQ1ueuecSxkyuNTKTFw8EuB7xtRaOuwl3NnimpTFJnmtYlQjn8w3t9SeHyEPQemb/w8rw1lA+Z3ykZWYcMGwwmb9HzFEKwg+SsKSQLUn9ndbF8Xi8Frr7Ld2KX5Uwp/V+2DRcVr6Y26mFO4cmpkvi1qqnaOwWtZ2Es=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767950490; c=relaxed/simple;
	bh=maX7JAj0NazqvlEJYCzYTi0cRuuOLCawzhLvzU1BoAU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=luT0UOqNV2uSUEnorpVP9/1L7qA07VpLUXqEqoc26Q/Hmkp3c5Vm7qldfL8CJEc7VmR8sM+0h8VIFCSS6q5oZoglioR9bB37VVthkaVNr0UcnKyASGWUxA/9LE0SgRyRCBrjc1B79q2YSqW9vINwyMWRslhWmvCG+Tsyf/idnwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lmG2HuR2; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767950488; x=1799486488;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=maX7JAj0NazqvlEJYCzYTi0cRuuOLCawzhLvzU1BoAU=;
  b=lmG2HuR2ocBa2k01XXKfzgt7epdlrxKOtrwSQdqXaU4v5N3/CqjAepLm
   RdnlH7xtro8WwyNT+8TNsFtrQeWuW38/JZ5yMpB7Y5+f3eO8qQWlXET2n
   sQ3vy8+jQ9Aig/beiVSJNRn3SESj8fusDTP+23ZpDmTZfO9l+zumre1dW
   NqPhAO1jlJckei2g4gIkOdYZTuAz8sDbKfCmBos2qw6E5WD2+rJXJxACK
   R5/KPGT8rm7zdtLYGIQMeh2nRuYWQgry5AvTi7SgQQ1zSDSMk6YJpOtXc
   Id/oTc2oLCxeduVvelNwztdFr3gLhdjbBLiSPjZtHUF2KhIz23Kpj8XhD
   g==;
X-CSE-ConnectionGUID: mmnezJN6S36i+VtJdRYYtw==
X-CSE-MsgGUID: WuY+AzetS9C8/Y0l2teMxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="69380038"
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="69380038"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 01:21:28 -0800
X-CSE-ConnectionGUID: pCIKnUEkSKi1ngcewMKMFQ==
X-CSE-MsgGUID: D0Vq3hIBSCiwbqTDOsnwDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="203705317"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 01:21:28 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 01:21:27 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 01:21:27 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.57) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 01:21:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZQIOBZrNUQBsXa8hSPuOcgauXrnC+sRHv33Ts9cMGkyd8bKgy/c6qlt7iXOd9TvqHAvrbwmh5bX/RMJMtODxDmdi2NK4CMXcKwacQCXKhOXp6v6THmEvjP8oyIH4HQr7SW4p9kzPIeTv2vLHqDDDqPRQj3Xjb0mPXPEf1DlYChDuthiw0L9+fYQF9w9W7u5qbgFlM3kpUBiKhKCc+WcIlqO5SbaZ7n2DtS0AHS+Z5v6O6EfxjR/nnJDt71c2Y8pmjpADQW8JQMLCfTrsDYE6jZgT9vqulMzDysAcZxO0R164O23fSW7dJt+raDovdU0d7bwOhfXHvFsEEyGMNnkhrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NxHMDkUJ2Z+vrQ47th+oD6qWPYnNOfvlTKV1tM02W44=;
 b=QZOBmIly8D+E9iqPDcJ6VYDYl5qFApTruhq9KHnJlL9dl83MkUWRi/5uBV72NdXEv8YFVMBgwv1bFCmmLN/XDExukxiDtf/3fznW/2VgoR74mTk1lBINMLSpzndw5wCBdC74FwkcmgY1HQ4jurc2Qxi15axaOPE2Uyz9/OHvd7l9zJCz0AHSPICHqKxkaQHazd0pM8DgJwLPDeOPRKBCSQJZkhakWO6a5wuzzjPdOnqhyRZprBcH+FLDQPZMuEJ5E81tBt284aVENVboViook8QaRYULW1oK/aMZToMmhnnsZGDCnSQJyfODqXLXld9pHN2YMNacqc9lTAwPY4L4UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS4PPF6CF7B12C6.namprd11.prod.outlook.com (2603:10b6:f:fc02::2c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 09:21:25 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 09:21:25 +0000
Date: Fri, 9 Jan 2026 17:18:21 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: Sean Christopherson <seanjc@google.com>, Vishal Annapurve
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
Message-ID: <aWDH3Z/bjA9unACB@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com>
 <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com>
 <aV4hAfPZXfKKB+7i@yzhao56-desk.sh.intel.com>
 <diqzqzrzdfvh.fsf@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <diqzqzrzdfvh.fsf@google.com>
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS4PPF6CF7B12C6:EE_
X-MS-Office365-Filtering-Correlation-Id: 2724b27d-ca77-48f9-a177-08de4f607611
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R3BrU2tFeWdHaTJJcUxLazkvN0xNdkhaaGRFS3FKYWVaYUNyYUsrdTRraTcx?=
 =?utf-8?B?ejhYb2ZlcmNQbU1zMVNqUWY2WGIvWjZRZlNUMU5jRWNRZkZUem9maEhGYzBQ?=
 =?utf-8?B?VnhRL1RoeUtwd3dyQ053dDkreTRYWXQ5dHNGMHdmOTZIQ011VGZNbG80RHpH?=
 =?utf-8?B?NUdHbFFjNGtoeGF5eTJaWGZzYk8zZ2YwamFrL3V1NVo0RVZmWjU0RnZML2xY?=
 =?utf-8?B?VC9zeVRaYW1Ub3ZyWDFuY0NnOGdnZ0xueDAvZ2hZajdUV2JoQUNNWlJHakxs?=
 =?utf-8?B?ZkcwR0VOR25iTmovcXJyaUc0cTN0UTIvVjdQN2R3WmtSRktSeVBEMFpUSUh5?=
 =?utf-8?B?M3hMdzdWekxPem9IR2Q2NW9PSVlQOHo1ZW9LOTV6cWd0bjlFN21uamhoaW5k?=
 =?utf-8?B?YXRLWElRejhIbkRVSDRKQ3p2VzhsUURYUTZWQXdtK01kUzhEamN5eTBSL1o0?=
 =?utf-8?B?SFozdHBQRmttWk81bTlYOEZ2VHNYTFdXeTlCdHJFeVhTWXhGdU8xRE9PSmJl?=
 =?utf-8?B?QzYvQ2dHd2NCL1RGZWdUMzFZd0R4THZ1M1JZMC9HQTNqY3RPUVFCWlZ6SSs4?=
 =?utf-8?B?QXFBT0lrYUpickFQRGdLSUlRYlpYenZFcW5pUjVaZDhrdmU1NmwyRlEwQTBq?=
 =?utf-8?B?U2p6MDRmSGFsUkdabzZ2NVQ0UlQ5ME04QThyc2xEaTRqSFU0bENmb0hSakNS?=
 =?utf-8?B?Zmx3b3F0bmNPYjlMdnhqaFdpV2hhL2U3czArTlA2dmg3SUpMd1hTbzI3cjR1?=
 =?utf-8?B?eUVxM3c3ZDlLVHJheGIwQlQ3Q0FpUTA2U09XOExWbWc0N3E1Y1R1OGhQd1RL?=
 =?utf-8?B?MS9JalI3N0QxNnBYck5OYkJwOU9zTHpkNUlnczQ5bEswT05KRjlnUnh1Skd6?=
 =?utf-8?B?TlNDZkdURlZBTG1pS0NuY1dsZE1GYllRenB6dUFNdHZpTkllNGt5ZFlIUmJC?=
 =?utf-8?B?b1dpY3pMWEdxR2NvcFNqYTNKMm1XcW10RHJ6TnhkbHV3V0F3eHJMbUhzamVr?=
 =?utf-8?B?eFZuWllJSE9wR1N1SmlsZy82cUhvQjVaQU1Ob3pyV0pLYUdXU2s0eHRGY1JW?=
 =?utf-8?B?QW1yR1gvR1VvMjN3c01MaGJjODdkeEZtbWFRTnBFelVzUUNyaTdQRTBIZW93?=
 =?utf-8?B?dDd5d1Ura2dVR1pqS2I3RythdTdzRTdyWk0yeHErWEhSTzBQYXVwYVNUUWZl?=
 =?utf-8?B?OWVXUDMvdHljWnVsYU5JcU9XY09yRVhYRUt6d0M4VlBJZ1lWeHg3Y1NUVzNr?=
 =?utf-8?B?ZkRrejVVd01LSW1mN2h6cjR3YUFPT1cyVXNHQ3lMOWxGQnhWRmtIRGZuWmtC?=
 =?utf-8?B?Zm5hejRZYTlpQ1M3cmFlcUhUU1lPUGxCSGdteHdMZ2NQQ2EzYUxYT2phSzli?=
 =?utf-8?B?eUN6NEdRaEZodFpEMzUzM0RXekxLK2NuMnc5Uk80M1NmbGlIUkM1MXNDNXM1?=
 =?utf-8?B?dEt4Y2prTk5lMUZPamxWNjJUS2NtNE1yZGlQUFNCTGIzc2V5SHNTZWNIdWly?=
 =?utf-8?B?T2ZSd3RGeSthYUFMT0dONDZJZEwvTjNBRGN0b3FCNTcvOHp3WHFwMkVwUnZU?=
 =?utf-8?B?KzVhWVREUzdQRFpDQW5nMmR5MEZLdERpY0RJZklwcWJ0VlVpVERiVzMzdTVa?=
 =?utf-8?B?dDIxRVF3ZllaTVZlQlViZG5lQ2FyK1pQR3hxSEtrUjFvTjByYTJFWTh1azlX?=
 =?utf-8?B?R2duNVAwMFlqZStQRkVNamw1VkYyclZFa1VNdXE5Vkk4NkhiN2pkb2tEU1dJ?=
 =?utf-8?B?a0ZTZEFLbGs2dUpyY2owS1JxUnhacUFUU01zd1VVSnpmZmxVaC9qU055WkVw?=
 =?utf-8?B?a3J2N2NoTWdjd0JlbzVCeHZrNVZVNWorNitHUmZFS056REVtK1owVklSRWdY?=
 =?utf-8?B?dldjOEQxbGZYYzhZSHQ0TE1oNVM4OU5ScGZETDJhbm9RL1BNNXhFY3B2Si9F?=
 =?utf-8?Q?k8peUx9GsWebvglpsvE1bpTphxLN3+rV?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmpBUkJsbXRnV09KTDVFUlJ0ajUvWExzdEtHUWtWaFdYaEx4Y3dPckc4YmtL?=
 =?utf-8?B?Y3hRd01qL21wcVZHa1FsM1F1eDBMeWFKNEpMZHJGZkdta1A2THI2UHNNQjRU?=
 =?utf-8?B?T2czbnI2WFN1Sk1JYjl2dGZvTHdMK3psRG9TaTFKT1MzamFWVTlYWW5mMmQw?=
 =?utf-8?B?dDNweGlyL1BuOTkya2laaVJ4eGIyTVpMNzJLdGJzVWowNmlnblc4ZSs1eEVj?=
 =?utf-8?B?Q0ZnalFUYWx3TTN0bkNxK2E2YUJoc01KSG9ld1I0cUpXWkhtSml0ejlRdmhK?=
 =?utf-8?B?V1BFVTFITDVSQ3BTUU1lUFppZDh2ZkkyRUhjZ0pkOVJNY1ZrUXBZWHRpanRH?=
 =?utf-8?B?RXlqUDh5cEhybi9UcXF1elozbUJDaFV1KzBEME9nVFlZL2RURVVuclBNa2pt?=
 =?utf-8?B?TjJpR1hIc29iQzZpZHFTSU9HZlpOS1JtbXk0THYvYWlPMEF6RjV6cEVvU0Z0?=
 =?utf-8?B?bUVBU1RTMmc2YmRRTmtaRlJmdlFaLytjQTRucnJmc3NDSVBKbDR6MGRmOWVw?=
 =?utf-8?B?MFdjbDJiSnpqSzFzSmVVbWFQTm1ncUNHdjJyamloMloydWl2VVNIcnRFKzE0?=
 =?utf-8?B?S0c2ejdVQ085djhjUTk1dXhZV3ZDTVMzdCtXQ2luc0dIQW1Ueko1cXVQc3BY?=
 =?utf-8?B?cW1CdmxMVUtpeThhanRqYlhQMHF3cFo5QzZiTjk3TUk1SHdudlJFbndKWHVQ?=
 =?utf-8?B?Z1JLZ2dDQ2llNnRvNW44dFlnVTBJTklsalpOZ215QUpYVFlDa2lMY3hIUWhG?=
 =?utf-8?B?bWFEdWdJcTJOMlRJTGdTRTBnMzFQbGh1MjZRNlVxdU1SS3ErSE9SeGN6dnpU?=
 =?utf-8?B?TnpSeWlaNGpUNDFQbFVnUHJlMm5MWllKSEZMVjVBTi9pSWNQMFFBUElwdGYw?=
 =?utf-8?B?b0crbjRsVkxyQVRZOWpyOTl3MFVET2NmaTA5V0UwdXdMTmJLcUVwTFdWQmlD?=
 =?utf-8?B?RjE1QjZ4dFQyRjFvTVEzamF4bThLeEdOWXRLWndyWHM3U3F1MFZUeFQvMktV?=
 =?utf-8?B?YlF1SG9pWEFqcDZ0bmdpam0wTVVycWV5SlV3aWxFU0p4a2ZsbndWdlN4azgz?=
 =?utf-8?B?TXdRVzNCY1ZxbHBnd3ZlM2Nmamh6Q21hWWI1aUFJYmQ3ZHcrTkFTTEZLVnFU?=
 =?utf-8?B?dXBLWDlhWE1XTHd1bkNkdStpTXd3S0tqd3loNWxuTlNqRmthd2tlNnNOaW40?=
 =?utf-8?B?QzZHU1BINnN2a2F0bE4wanM3bXhJVFhFWlhsb2o3aVhHNXpDNUZFSkp6eUJZ?=
 =?utf-8?B?and2NGhuazVBaGpBaDhUQ1RlS0JiMWoxWGMzVEllQTZlMy9STUsyUVNkMzFC?=
 =?utf-8?B?cllQUklIQ1pTb05mbUZoYzhrQm9mZnVaMHRwd0xSSXBYZExwVlZINU5YeGdE?=
 =?utf-8?B?c0xyRmFjUHpiVlpOdGN0SHlIWHdlOEY4VmFXYmpPZ2ZKR040UVZkTUgrMjFv?=
 =?utf-8?B?UmlRYVpGNVJENXM2WWlOWGhldzl1Z040THVXazhXKzl5em43eUR5WnZ2bDRU?=
 =?utf-8?B?aUJmbG9tUDNZWnN0OHR4emY2ZllRdldUcTR0TGREL3NobWpNM1JYbGNJOU5t?=
 =?utf-8?B?U2Q2VjZNUVdwRDBBZWJXcHVIMUtFV2d4TFBYZFhyUWpPcjUwUEI1V3RtS3I4?=
 =?utf-8?B?d3g2WjhVY2FraUdGSFlEYTVWR1JRZ1JDVmNPeVc2aHFONFAzMXBMYklQYUt1?=
 =?utf-8?B?N092QVEvUzZBZ2NkQ0JNeEtPNW9TVXh0MW43MElhMENRK3NpQjIwRGk2YXht?=
 =?utf-8?B?VkZQbkQ0VmpqeCtvQllMYXJGRkhLVXpmWlQ0OW5YTzdScVo3dnlvSWJVbmE1?=
 =?utf-8?B?SENlNU9NVDFmbEdYQkt3Q0xnYmJITVJOaElERVNDV3p3SnFuOUk2dHRMOVp5?=
 =?utf-8?B?MC9NQ0JycTJuM2Nud2tqT01KQnkyVStaMVdURnBQNHJyY0dZYkFhWXFWbFdW?=
 =?utf-8?B?blVUSUZ1b1doWWRDQkIxa21ibFlFQ0lDVHBRTW1SUGtIY1duZSt6N3VYYTUr?=
 =?utf-8?B?L2NwUFR5YTV6OE9lb28wU0hkR0M1RmVScDErQUpuRmNsWUFzZmY3Vm92ampj?=
 =?utf-8?B?K3NEaFJyVm9PSFJOSm50TStmZ3Y3VTFxQVN5NzZlbjVvVUZRWWlWR293N2hh?=
 =?utf-8?B?dU5wUm15eTR4TXB4c2x5N1dCZG10M29qUTV0YUZucC91TE5xaUt3citibGN5?=
 =?utf-8?B?WW94cjNSVzF1N0VQallyaGt2am1laFlUaCtOS3dmZy9VQ0g1Z0dSVGZkeTdH?=
 =?utf-8?B?UkhPbjdzTGdLaGRCaW0rZUhZYlN5ZXJja1JqT2dyNzFZVGdsMHJacGsrd0lS?=
 =?utf-8?B?ZmFTY0ZON1hUamxVRmM0U09BbGZ0STVNMitWL00rZmhJdzJFNUdCQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2724b27d-ca77-48f9-a177-08de4f607611
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 09:21:25.0931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /CGh+Fr3BH4RyR0Vf+w9CFJGHuTgbBlZKWB7uVu2OQUL8fVFQ5QJ7YDx+d35lk76+DuDpgl+Lv2OAa6oXMA7PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF6CF7B12C6
X-OriginatorOrg: intel.com

On Thu, Jan 08, 2026 at 12:11:14PM -0800, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> > On Tue, Jan 06, 2026 at 03:43:29PM -0800, Sean Christopherson wrote:
> >> On Tue, Jan 06, 2026, Ackerley Tng wrote:
> >> > Sean Christopherson <seanjc@google.com> writes:
> >> >
> >> > > On Tue, Jan 06, 2026, Ackerley Tng wrote:
> >> > >> Vishal Annapurve <vannapurve@google.com> writes:
> >> > >>
> >> > >> > On Tue, Jan 6, 2026 at 2:19 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >> > >> >>
> >> > >> >> - EPT mapping size and folio size
> >> > >> >>
> >> > >> >>   This series is built upon the rule in KVM that the mapping size in the
> >> > >> >>   KVM-managed secondary MMU is no larger than the backend folio size.
> >> > >> >>
> >> > >>
> >> > >> I'm not familiar with this rule and would like to find out more. Why is
> >> > >> this rule imposed?
> >> > >
> >> > > Because it's the only sane way to safely map memory into the guest? :-D
> >> > >
> >> > >> Is this rule there just because traditionally folio sizes also define the
> >> > >> limit of contiguity, and so the mapping size must not be greater than folio
> >> > >> size in case the block of memory represented by the folio is not contiguous?
> >> > >
> >> > > Pre-guest_memfd, KVM didn't care about folios.  KVM's mapping size was (and still
> >> > > is) strictly bound by the host mapping size.  That's handles contiguous addresses,
> >> > > but it _also_ handles contiguous protections (e.g. RWX) and other attributes.
> >> > >
> >> > >> In guest_memfd's case, even if the folio is split (just for refcount
> >> > >> tracking purposese on private to shared conversion), the memory is still
> >> > >> contiguous up to the original folio's size. Will the contiguity address
> >> > >> the concerns?
> >> > >
> >> > > Not really?  Why would the folio be split if the memory _and its attributes_ are
> >> > > fully contiguous?  If the attributes are mixed, KVM must not create a mapping
> >> > > spanning mixed ranges, i.e. with multiple folios.
> >> >
> >> > The folio can be split if any (or all) of the pages in a huge page range
> >> > are shared (in the CoCo sense). So in a 1G block of memory, even if the
> >> > attributes all read 0 (!KVM_MEMORY_ATTRIBUTE_PRIVATE), the folio
> >> > would be split, and the split folios are necessary for tracking users of
> >> > shared pages using struct page refcounts.
> >>
> >> Ahh, that's what the refcounting was referring to.  Gotcha.
> >>
> >> > However the split folios in that 1G range are still fully contiguous.
> >> >
> >> > The process of conversion will split the EPT entries soon after the
> >> > folios are split so the rule remains upheld.
> 
> Correction here: If we go with splitting from 1G to 4K uniformly on
> sharing, only the EPT entries around the shared 4K folio will have their
> page table entries split, so many of the EPT entries will be at 2M level
> though the folios are 4K sized. This would be last beyond the conversion
> process.
> 
> > Overall, I don't think allowing folios smaller than the mappings while
> > conversion is in progress brings enough benefit.
> >
> 
> I'll look into making the restructuring process always succeed, but off
> the top of my head that's hard because
> 
> 1. HugeTLB Vmemmap Optimization code would have to be refactored to
>    use pre-allocated pages, which is refactoring deep in HugeTLB code
> 
> 2. If we want to split non-uniformly such that only the folios that are
>    shared are 4K, and the remaining folios are as large as possible (PMD
>    sized as much as possible), it gets complex to figure out how many
>    pages to allocate ahead of time.
> 
> So it's complex and will probably delay HugeTLB+conversion support even
> more!
> 
> > Cons:
> > (1) TDX's zapping callback has no idea whether the zapping is caused by an
> >     in-progress private-to-shared conversion or other reasons. It also has no
> >     idea if the attributes of the underlying folios remain unchanged during an
> >     in-progress private-to-shared conversion. Even if the assertion Ackerley
> >     mentioned is true, it's not easy to drop the sanity checks in TDX's zapping
> >     callback for in-progress private-to-shared conversion alone (which would
> >     increase TDX's dependency on guest_memfd's specific implementation even if
> >     it's feasible).
> >
> >     Removing the sanity checks entirely in TDX's zapping callback is confusing
> >     and would show a bad/false expectation from KVM -- what if a huge folio is
> >     incorrectly split while it's still mapped in KVM (by a buggy guest_memfd or
> >     others) in other conditions? And then do we still need the check in TDX's
> >     mapping callback? If not, does it mean TDX huge pages can stop relying on
> >     guest_memfd's ability to allocate huge folios, as KVM could still create
> >     huge mappings as long as small folios are physically contiguous with
> >     homogeneous memory attributes?
> >
> > (2) Allowing folios smaller than the mapping would require splitting S-EPT in
> >     kvm_gmem_error_folio() before kvm_gmem_zap(). Though one may argue that the
> >     invalidate lock held in __kvm_gmem_set_attributes() could guard against
> >     concurrent kvm_gmem_error_folio(), it still doesn't seem clean and looks
> >     error-prone. (This may also apply to kvm_gmem_migrate_folio() potentially).
> >
> 
> I think the central question I have among all the above is what TDX
> needs to actually care about (putting aside what KVM's folio size/memory
> contiguity vs mapping level rule for a while).
> 
> I think TDX code can check what it cares about (if required to aid
> debugging, as Dave suggested). Does TDX actually care about folio sizes,
> or does it actually care about memory contiguity and alignment?
TDX cares about memory contiguity. A single folio ensures memory contiguity.

Allowing one S-EPT mapping to cover multiple folios may also mean it's no longer
reasonable to pass "struct page" to tdh_phymem_page_wbinvd_hkid() for a
contiguous range larger than the page's folio range.

Additionally, we don't split private mappings in kvm_gmem_error_folio().
If smaller folios are allowed, splitting private mapping is required there.
(e.g., after splitting a 1GB folio to 4KB folios with 2MB mappings. Also, is it
possible for splitting a huge folio to fail partially, without merging the huge
folio back or further zapping?).
Not sure if there're other edge cases we're still missing.

> Separately, KVM could also enforce the folio size/memory contiguity vs
> mapping level rule, but TDX code shouldn't enforce KVM's rules. So if
> the check is deemed necessary, it still shouldn't be in TDX code, I
> think.
> 
> > Pro: Preventing zapping private memory until conversion is successful is good.
> >
> > However, could we achieve this benefit in other ways? For example, is it
> > possible to ensure hugetlb_restructuring_split_folio() can't fail by ensuring
> > split_entries() can't fail (via pre-allocation?) and disabling hugetlb_vmemmap
> > optimization? (hugetlb_vmemmap conversion is super slow according to my
> > observation and I always disable it).
> 
> HugeTLB vmemmap optimization gives us 1.6% of memory in savings. For a
> huge VM, multiplied by a large number of hosts, this is not a trivial
> amount of memory. It's one of the key reasons why we are using HugeTLB
> in guest_memfd in the first place, other than to be able to get high
> level page table mappings. We want this in production.
> 
> > Or pre-allocation for
> > vmemmap_remap_alloc()?
> >
> 
> Will investigate if this is possible as mentioned above. Thanks for the
> suggestion again!
> 
> > Dropping TDX's sanity check may only serve as our last resort. IMHO, zapping
> > private memory before conversion succeeds is still better than introducing the
> > mess between folio size and mapping size.
> >
> >> > I guess perhaps the question is, is it okay if the folios are smaller
> >> > than the mapping while conversion is in progress? Does the order matter
> >> > (split page table entries first vs split folios first)?
> >>
> >> Mapping a hugepage for memory that KVM _knows_ is contiguous and homogenous is
> >> conceptually totally fine, i.e. I'm not totally opposed to adding support for
> >> mapping multiple guest_memfd folios with a single hugepage.   As to whether we
> >> do (a) nothing, (b) change the refcounting, or (c) add support for mapping
> >> multiple folios in one page, probably comes down to which option provides "good
> >> enough" performance without incurring too much complexity.
> 

