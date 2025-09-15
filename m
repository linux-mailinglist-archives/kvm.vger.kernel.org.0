Return-Path: <kvm+bounces-57620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08FD0B5865D
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 23:07:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AC1D200B5E
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 21:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED4E2C026B;
	Mon, 15 Sep 2025 21:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fvsg9P4y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CA723814D;
	Mon, 15 Sep 2025 21:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757970459; cv=fail; b=FyQyGMh3grjG6PjaMXySKuzYHkFuuL2QXS9Axuu46FxtMFRdmZ//RxJxjcCJLh1Vvmx5gI0JgJ5uG9960vIkU9rc60qTa5sdGlkJG1j6xnL21m1xdpvGFkFZja673VgRe0ICX17M8XFrJ7lKuS4RpXhRJxPbapNEGRdgZxuIhHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757970459; c=relaxed/simple;
	bh=9KuAX3hai4vI2bmTBse0QiuJ7bsEk4pcWVJVrX1ovnw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E5w61uztCC81X9yWAcn9JbCkNOYPr8p9/lXlT5NDU27k922+33Y53wfAXr5CqvAeuuozh/c4X9MUCHhhHY6/kDsf9BfpKT5H5LsjGcpoH4eAb8ja3ieRg6rScT4Ni/xPMF/eSpgeXSc8IZtlHivvvcQxtQxss74RoOcbdiD1jNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fvsg9P4y; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757970457; x=1789506457;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9KuAX3hai4vI2bmTBse0QiuJ7bsEk4pcWVJVrX1ovnw=;
  b=Fvsg9P4yO+2INvPnV0o+6iHcUrKjfpsrX7R7MPgcSYgpndrzSptrcMbP
   FNTe92kKv6ytJWfnJm84n2VeMr0UGYc5RyhZhTpSWHmi8P0uAbmQ+clfE
   TmSgmNvCQkSNWrIbL4UIrDJG/hf09IO9aicahpbBbBB/ggidd+bvCSqlG
   OrmpUrR7e8zinH+GJdHoVZhCRJQ3FohIGB5H5hyqa2KM0CiSI8u3D5hvO
   q1qtORISzNRqiQHbJ3w2MxkDthG85hXjJk/Eg0Ui+hBEZWK6obxtxDGTB
   yZaKahKWlmFKYWZ/WNfjvDJu4Y27Jji8rUtk3avTB8ZHpo2VIq33kQui6
   A==;
X-CSE-ConnectionGUID: 8CEwNSKjSQut9s/vA71TNg==
X-CSE-MsgGUID: qp4VLNOBSYqEZK+31Y0PLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="47811360"
X-IronPort-AV: E=Sophos;i="6.18,267,1751266800"; 
   d="scan'208";a="47811360"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 14:07:36 -0700
X-CSE-ConnectionGUID: EM0+sVkZSnqs0iFNGi+reQ==
X-CSE-MsgGUID: GbEXRCyYQhO4gWUWxWyZrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,267,1751266800"; 
   d="scan'208";a="174367983"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 14:07:35 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 15 Sep 2025 14:07:34 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 15 Sep 2025 14:07:34 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.35) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 15 Sep 2025 14:07:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tG36IIP3oxqq14CwHS5Zbh82lWWOdMotjOr08WUpYejOngHuvW/K2Hxcc/dVO0f0vElsssKZWKKAb/ctX0ahkJRrIkJv0IHOYbaIUHpUGJQu3Mqws75nHX9w25kYd1tJLDzJ0cGmuxTy5LXBsisQTxiGGb0bmYx4sQiUQPSGeZK9FYHl73V9oe7+sK+ubQxztKkTvLgJX1HL+ynIJ/06zuDL2zYZlBoNODr8yiuq5D9fvZ7an7yU9cukheRzmJvh31SVPWuOTCHj4C2HV0SLY8FHBQXwULvclBUh4WfIRACrF04RpcZdh0QICBrsfzx/6/iHmVx95md1nlr8Gm0nPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTR5P6SRscKzm1r7X+GdwaneEuS8qJSaWxWQ/LIq1r0=;
 b=EqnfzSZFQlFDObsRowQO7cX577ZQTdn2a8xH6knKe3aAVnQsrPGS56z/uh0jGpvFJF6ElDQf2O+Jyl3Q9I+PFedx+mNoX16+gMhrOhI2Hu/tL4P1bpYnINy2ZV0q5PecdDhC9pjlf9dSTG1UpCbnkoPnhVbslGDE1tgJHd9g4J8upBrxFQbrUXEi4gXAhXmBCTtFdkne8bu5k1tSl6GpqLQh/wnwH3qVh4CoY9Qr1JWCdl0WlqahRSJZM/KdPIuUsFl/DrtfnuUJH9MNvZ/AorFNpLKoyCLJbxQ2/C6oG6uPZk9x2OtpkkgHaTBWbk9QVYXS4GF8kVG2i58GOasP0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by LV3PR11MB8725.namprd11.prod.outlook.com (2603:10b6:408:21e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 21:07:30 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 21:07:29 +0000
Message-ID: <b56757b8-3055-455d-b31b-28094dd46231@intel.com>
Date: Mon, 15 Sep 2025 14:07:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 00/33] x86,fs/resctrl: Support AMD Assignable
 Bandwidth Monitoring Counters (ABMC)
To: Borislav Petkov <bp@alien8.de>, Babu Moger <babu.moger@amd.com>
CC: <corbet@lwn.net>, <tony.luck@intel.com>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<kas@kernel.org>, <rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <frederic@kernel.org>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>,
	<pawan.kumar.gupta@linux.intel.com>, <perry.yuan@amd.com>,
	<manali.shukla@amd.com>, <sohil.mehta@intel.com>, <xin@zytor.com>,
	<Neeraj.Upadhyay@amd.com>, <peterz@infradead.org>, <tiala@microsoft.com>,
	<mario.limonciello@amd.com>, <dapeng1.mi@linux.intel.com>,
	<michael.roth@amd.com>, <chang.seok.bae@intel.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<peternewman@google.com>, <eranian@google.com>, <gautham.shenoy@amd.com>
References: <cover.1757108044.git.babu.moger@amd.com>
 <20250915112510.GAaMf3lkd6Y1E_Oszg@fat_crate.local>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250915112510.GAaMf3lkd6Y1E_Oszg@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0063.namprd16.prod.outlook.com
 (2603:10b6:907:1::40) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|LV3PR11MB8725:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e793509-b0dd-4152-0c4c-08ddf49be16d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UWRpN3Ayb2VaTHVhTkE0MEhvakI3bmc1TjlybHRxVEtnMjVlR0tIUzU3dzYx?=
 =?utf-8?B?K3krLy8rTjgyS0JLakFIeGErbVR3SFdzb3V1RXpmUWlJYlZlNW9WR1hTWHdF?=
 =?utf-8?B?ZndIOUdDRU94MDVqQUNKYWs1bWZmbUFkOTcvQVFKcmFqbEtLdHN2dWxGNE5I?=
 =?utf-8?B?dWJBcnk0ZDFWUFlQbE10NzVWcTlLQ3N3VDJWWWtDM1NJNHYvOGRSOUFneFE0?=
 =?utf-8?B?V253TnpFTm8waEFZOXBJaVAwQnd6SWtrNlBSV0lheGgwSHlVMjhzOUY3MHFy?=
 =?utf-8?B?WWpySnV4RDVjTUQ1RHp5RTZqNmhJVUErcTNoUDhDY2pSTjczZldraE56eWk5?=
 =?utf-8?B?YkRGcDB3TDN5cGwzbXMybUpPRG1TMTZUSlNvZHJnZzdCM1BHL0lnbHcvMU0y?=
 =?utf-8?B?bWdnc1pXRC9Cd2k0QWhRbFpqZWtQV2p6UUJDMmZYOVA3VUw3WWs1cVNiLzNK?=
 =?utf-8?B?M2ZrQzU0Z3RtMjZXclRDNFEvcG1hUmdUQitVZ0NhdTNudUhxeHp4cFliUDFQ?=
 =?utf-8?B?ZEtzZUNlb0wzaGQwZXNJeTFKcTgwbFFrdkpHc3p1T0FURitzRUtMcVJMN0pw?=
 =?utf-8?B?SjlLYkszNis5M2d1TFNScTQ4TlZyMVdRZ2hUTGtNVlNVR2pOY2pyM2pWYVM3?=
 =?utf-8?B?N05kcmsra3VDVW1wZWQ2NHB3YUJYbUVJaDY2ZGcxRVNyMnZzYnRMK3dadjdX?=
 =?utf-8?B?aC85am5mVThYalZlejRmbzFRZ3YvWnAwWHprdEJpaHRvSTVsTVJ0Q1ZYcjJN?=
 =?utf-8?B?ZUEwczh5QlJKRVRFNTl0a0FZazlpay9qMXpsNXBIdy9RbmZsZUxlcGtUVXh5?=
 =?utf-8?B?dnU5QnhwV28ydUdUWHBMaUVpUTlLWnNWSDl5TkxNaTV6ZWo3SWpIV2lJY3NF?=
 =?utf-8?B?ZzVPejBscmNlS21pOGkwSXlkeklIV05sOWd2bGd4QUZBKzQ5YVo3dThiQ0NY?=
 =?utf-8?B?bDQxRkp3R0piOFpqRVYrMTQyL0V1RXdDRnBXZ2tBbEZnQTRtbUttSjZSVXJi?=
 =?utf-8?B?SlFpd092UWg5OXhsbk9HT1k1RGpEVkk1NzVtU3p5MVRlYmRGbHJRVFhqUnlp?=
 =?utf-8?B?ZGZ6L3VCUDV4NUNtenFrT2VPbCtkMWk0SVJJeEkydkRRNjRmNGxwWjlUMkRO?=
 =?utf-8?B?L252MXhZZjlPTnkrZkhLL0xMdzBLK1F6RE51R0RhTFY4KzhpSXZLZUtjSERQ?=
 =?utf-8?B?Vkp6SlkrUVA2UTE5RFlobzgzbDY0NVVuSitEZGRBWWJTVGwwTnVLMmRZa2tu?=
 =?utf-8?B?bDVQTmJodU54QnUxMGVmY2lDaE12ZS9nNEJsMG9ha2tvM1QxODNud3lyc1c0?=
 =?utf-8?B?ZzNUUzdPam1QV2ZEU1A2OUp2cHE1bFNKMmRpL084aFN3R3BaN2IzRWZrSTl2?=
 =?utf-8?B?N1diMGFxT1VFeE10THF2bmh3Y1ZJb0t2YTJSUU1lZERLcU5SRnBjeDFSRE9U?=
 =?utf-8?B?RUZ3d3dJZzJ2bk8vUklFSDIyRXp5MTdnM3d3VVNHTCs2UFI4MXRyd3pOdmNl?=
 =?utf-8?B?R0hLWldyMzFsbXZ2S1NJU0VPN0JNM1dDd2trY0lXR3FGdktWV2JSTEFCOXpx?=
 =?utf-8?B?SXZmL2pQNU5KRWZMbVlINmdTMzB2K2xGSEZvZGw4MitXTDVSY0ptTk9CS2xY?=
 =?utf-8?B?eG5kSWg5R25TK0hIcFpmOXEvSzZjKzJxUEpucXN5THBxMlZ2anpBV2RoZ2I4?=
 =?utf-8?B?a2QxVGNFWmFhOHlLUjA3VjJOcFJoNTBiL1J6LzcxN1FIODUrZlljWXdpNjdZ?=
 =?utf-8?B?aDhFdGpKcCtOVW5BRXhMT2d6NEZnVEZ3V1pSWS80VkpkVFR3QVM2TTZzYndj?=
 =?utf-8?B?T2NCZDZReHRTY1E2VDY4UjYvbVVLbGMwVStUbUJtcmVtbnRRUTkyOGZzWmQ4?=
 =?utf-8?B?VzkzWDdBVE1DRURvcjFQWWlYNFArVGhCUDhEMXJHbEpjRTgzMWpTUjJNOXM1?=
 =?utf-8?Q?a+/MgSuf1lk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czBvNmkyQjdESyt2UjZqT3RSWnB1ZUluYVRCZ2NIOWJmRmdoY2xjUkx2TW40?=
 =?utf-8?B?VTg3K0k1bDErQ3gwMmZKYzBnN1lvVGlxNGwzOEJseEV6N3ZLSEpGdXJQb3ds?=
 =?utf-8?B?c1pzK2xvU1ZkemtOY096cS85dnV1QjZmS0xLNFdoTDREMVVCOEZtb01BNkEx?=
 =?utf-8?B?RytQTEpNelFjNHIyR0NoUWJOMy9ZbVlFUFdVNEFPYmdPMmtsWXRlenZVL0xN?=
 =?utf-8?B?RXJtc3ZEYnFhdCtXRXpPdzlpS1R5RnFSQWtlOU5LcXk4QldLeGZhZW1RZFpn?=
 =?utf-8?B?RjZRMG82Y0FhWjdsdEFOUGJoSzBHRmYreTdPbHVpNkpkQ1BveFc5Z1ZSVmlJ?=
 =?utf-8?B?YnI0NmlsTTFBWXJMVWdTQ1MwWmI5c1htNHh1VU5nL01qbEQybExUQ0piUTNC?=
 =?utf-8?B?RVFnZ1BXWWtndXRHbnQ4czVTQmZUNWEwQ1pXUEhVUjlia0hUTk4rUXMxS2VZ?=
 =?utf-8?B?SGkyZGFjL3Q5dXFFbUR6ZlFRNURkQ3UwRUp5bUI3S1M2a29xcFJRbnVtTEtM?=
 =?utf-8?B?YkhRNXYxbmxxcmV6Z0lPL28ycW9zWHdKV1h2N2JHMXN6TlB0L005THl5V2ho?=
 =?utf-8?B?R1RhYm1TSjl6aVg2RzNRVldkcFRHYmFDZ0k1VWxTc3FYRVRDWjREOHkxWUx5?=
 =?utf-8?B?c1JRWFBvbjR1TlJCTnJQYVM4Sld6SlUyUHV6U3VmMHMwUzBkd2xTU0hYRlJt?=
 =?utf-8?B?T2VBdnhkb1ZrRkU3bXpqNW5GK25ZQzBGU2ZCanNLc2MwNXBQNWRONjFPQUc5?=
 =?utf-8?B?cFZUc2xQRVpmNEtDa20wdGZaYmhCcWNmc01Ma3RUQktJcW5oWmg4QUNraEhW?=
 =?utf-8?B?Sy9Wb29YVHJUSzJYajU2Z2VDUSs5bzdiL0lSNDV0UXRGOFNBZlVObkRjS1Jx?=
 =?utf-8?B?ckRwc3FMUFJMQW8vT0ErL0JvQmVRaW14eXZSZitBTTZDSkdzU0tQV2htYTdP?=
 =?utf-8?B?VkYyOEtyYjAxZzNkblRJaVZHaUhjdG9zemN5T0M5SFRFZll0WGxPZXF2WUN2?=
 =?utf-8?B?Zko4L2xwQjgvUlQ0VThXL2tWaVFhVWVXR0JrTjdkWUY1MUhqRjlkTTNWL2k4?=
 =?utf-8?B?d3I4VzNjMkNUZjdYWXFDeFBlSjNwbzlYVlg4aGpxT2JUVnFhNFo4WnhheXFZ?=
 =?utf-8?B?VWV2bGpzMHZ3OXFLRFJTZDRnS3FMWVRXZVAzMWtiRkdjYmlacW41d0F3UHlC?=
 =?utf-8?B?R09jRzR1QUNBMmY3RWFadGlmWTJnOHBhMU9hS1VhMjR0RDFuMXFWWUZjQkE0?=
 =?utf-8?B?RnRCbUlXK3JLcVdnVmR2S3lYZHFubFRqUUNqUS9Tckp2aDBhSDhlS3o0TFJx?=
 =?utf-8?B?MFM3SHpsMi9Pa1EzejlvalNNS1hTV2dSUjk1cnhNTWtrZnNDaEtqVXVyMmYy?=
 =?utf-8?B?YTRTV1FNVkhXRW44MktnbEpTeE1pdTRsV0hKc0JiUTRLWHBoTW1jbHVsdEp5?=
 =?utf-8?B?eEtjMGpyL1VkUFpyRFpTcnY3eEJ0T3VSR0RuQXdnNXVsb1BEYVdWaWpmenE0?=
 =?utf-8?B?b3pxV054MWVWQU0yRUpiVDJlR2Z5WUFOT2VxVGhkam9TaW1JT2N1bTVzR1hF?=
 =?utf-8?B?SFRFYzdTNW80eHpjYzI1TTJpVS90VldyMmYxUnNMR2REL0Y0bWdwMzVVL1dP?=
 =?utf-8?B?WHRjZEJod3JNWVBHbkNYMnIvbnNJL090VityNjZId0l6bjFqeDdJT2Y5QXVx?=
 =?utf-8?B?L2trRUM5QUM0Z2JsOHFWS0tCYzlNZWN4ajZ4TlRVQ0dRVkh2d0NwOElyZ0g0?=
 =?utf-8?B?L3JzSEdMMDdyNTNoU1p2eGYyaHlQTUpsZ2VRYzdWTzR0TjhSb28xOFhhZm5u?=
 =?utf-8?B?QnppTnFlc0lxcVUyd3VqMno0Y0JNMkdSc1QzNnprOGRRWTcvODhsellWK09L?=
 =?utf-8?B?QUYwd2pteWZoV0pJN0hBUUlaYmRMZUFFczJRKzZHTmZQMUl0eDg2QjNHWU1I?=
 =?utf-8?B?TEFLdm9DQ3JGaHdsNjF5eE1mY1lrRGVVMXJPaFp0WnNZZnE1NkY2TTNpNUNh?=
 =?utf-8?B?OFBUdmJyT0pGV0pyWVJQYWxLUUxlUGFLVHF1NTJaOW9PYmdlN3pFaVRpQ1dT?=
 =?utf-8?B?cHhuVEJRUnZtMGlTYWk2c2hZSXJ2RGpNYUdHTTVKWlVHaXgyZk5zcE1wR2dy?=
 =?utf-8?B?NmFLaTY0QmRia2ZoL2dQZDFHR2JXdXBrS245SmhHMXN3VWdkMTB3S1AwYkpj?=
 =?utf-8?B?T0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e793509-b0dd-4152-0c4c-08ddf49be16d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 21:07:29.7552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kR4LraPpnVo/A0PLbVQ60tR+p9K2Y42Gn5yB6sXuUqEp0ZJl0ZscuXhpX5T0zqvCWIs8e3EjRKxW3d7Hty0Aze4fw2V94j2KgeDChmKxCoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8725
X-OriginatorOrg: intel.com

Hi Boris,

On 9/15/25 4:25 AM, Borislav Petkov wrote:
> On Fri, Sep 05, 2025 at 04:33:59PM -0500, Babu Moger wrote:
>>  .../admin-guide/kernel-parameters.txt         |    2 +-
>>  Documentation/filesystems/resctrl.rst         |  325 ++++++
>>  MAINTAINERS                                   |    1 +
>>  arch/x86/include/asm/cpufeatures.h            |    1 +
>>  arch/x86/include/asm/msr-index.h              |    2 +
>>  arch/x86/include/asm/resctrl.h                |   16 -
>>  arch/x86/kernel/cpu/resctrl/core.c            |   81 +-
>>  arch/x86/kernel/cpu/resctrl/internal.h        |   56 +-
>>  arch/x86/kernel/cpu/resctrl/monitor.c         |  248 +++-
>>  arch/x86/kernel/cpu/scattered.c               |    1 +
>>  fs/resctrl/ctrlmondata.c                      |   26 +-
>>  fs/resctrl/internal.h                         |   58 +-
>>  fs/resctrl/monitor.c                          | 1008 ++++++++++++++++-
>>  fs/resctrl/rdtgroup.c                         |  252 ++++-
>>  include/linux/resctrl.h                       |  148 ++-
>>  include/linux/resctrl_types.h                 |   18 +-
>>  16 files changed, 2019 insertions(+), 224 deletions(-)
> 
> Ok, I've rebased and pushed out the pile into tip:x86/cache.
> 
> Please run it one more time to make sure all is good.

Thank you very much.

I successfully completed as much testing as I can do without the hardware that has
the feature. Will leave the actual feature sanity check to Babu.

As far as the patches goes ...

I noticed that you modified most changelogs to use closer to 80 characters per line,
max of 81 characters. Considering this I plan to ignore the checkpatch.pl "Prefer a maximum
75 chars per line ..." warning from now on when it comes to changelogs and replace it with
a check for 80 characters with same guidance to resctrl contributors.

Thank you very much for catching and fixing the non-ASCII characters in patch #29. I 
added a new patch check step that checks for non-ASCII characters.

Reinette

