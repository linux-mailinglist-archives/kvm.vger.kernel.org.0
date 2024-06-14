Return-Path: <kvm+bounces-19637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64FC490801F
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 02:20:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C8C91C2184D
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 00:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 556274414;
	Fri, 14 Jun 2024 00:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YyIGZtoS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1F4184E;
	Fri, 14 Jun 2024 00:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718324427; cv=fail; b=fblWHNKiLeQkSCa3K4S6eztU5EpoKgV8Q5hg+OhV6WuFqEqte6Fbs0d6A4MWSVU4d3wuo5YWQ65eKuhJP4WnYFVDsK3aPbTco2WjIAnw8UTgWVBVLXdxzLnMMYKFuLVNj4qjdUFVGyP2W0gtXVqHmsRe/h6tB/3P9H0KD0Wg4qc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718324427; c=relaxed/simple;
	bh=Z36wS9Md3jMeBHWi7v1Xpe8C4Dj7NQtoN2BALL+NkMc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ibQ7pK/fd0geP/1dSY7Xwd2zCQjvz2kbmip8O3kJNWYRDQWe835bV7lNa9xbQ5OpVBcqcB8oTHpNQOxTwlF898H7jckRQO8lZDnotp0Suv4a4MVYakkmR/ejCcm7WEmrHBgTo+fvI6LFBvi+fDMKsBk7Lf5HmvApjMQpl8MqZYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YyIGZtoS; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718324426; x=1749860426;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Z36wS9Md3jMeBHWi7v1Xpe8C4Dj7NQtoN2BALL+NkMc=;
  b=YyIGZtoSUIo9/enGA8Uwi2lfnnnWJoKG/pYCgabcuC1vCDkdQPbWqfsO
   qpAwWL0bOLDyqXj+INa0lrV5PzoYskYNvhWiCWdlZUFFYOC7GzqFBy2HB
   kO3lmHLFpnO4D4g+ofaKr2XqeDE47FeRklp8t6PiXxe5KAGj/LiruuO0M
   lSMCeh6a4VdzJg/Ha+jZuFwqMLxVSDryofW+RopLeVcrOb0z2J6qarKp5
   ImHYhJizR0oOtAwVADVCQX9xKFtcHGtBIWPuEiXgHo5ZJP94Sj0PgWF9x
   8e9JHNngI50CVmz8+WNdGgu/11Aq0jcEY/JPFnugZgi9yFIykvJM6bVxM
   Q==;
X-CSE-ConnectionGUID: n7EvLGCtSuWn24B+lx9hkQ==
X-CSE-MsgGUID: lmOtCcq9SzKrSZPWAVNJpQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11102"; a="15422158"
X-IronPort-AV: E=Sophos;i="6.08,236,1712646000"; 
   d="scan'208";a="15422158"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2024 17:20:25 -0700
X-CSE-ConnectionGUID: UfYTrvbWQ9aY1t5FesoqMw==
X-CSE-MsgGUID: 4dlAZzxbSeCJCFuu6NDm7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,236,1712646000"; 
   d="scan'208";a="40251799"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jun 2024 17:20:25 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 13 Jun 2024 17:20:24 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 13 Jun 2024 17:20:24 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 13 Jun 2024 17:20:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNylYwOFEnvEycoM8NR1dc8VE/W1TMuf+cbsMMy2z2GM0c2HkelH8c5cw7QqjIePUTKDmJnc7oMSUeY6k7NGbp/4u03dNOSY2W4nELKqhaVtXXmjXmxl2F5JFzNu/h0+Ufa+ExqnHCBd7qYelh6RZU/bfyBn8OyBiZodT9uS2w9yT8mx0Dppm3+RZ6/hk5Xpy20WqmKcqwEYoHWGr6zHL1UUrxH1VuS29grfEwGH3pfkstjjqzHwyIR/C0UnB0pjOQNSTLYY46nnSZ0Uia3hkY+r/raktyQSFaaAPdbGhUDHmHp7i45cza/RdmE0OOIzzFkUB2XnGiESrXWOW1eIBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z36wS9Md3jMeBHWi7v1Xpe8C4Dj7NQtoN2BALL+NkMc=;
 b=joxhHk4fIbO8tJnSSpu2FkV4UO+fUF2bxxZaSC7Xgo9dhKLrRgOowujiGHJuSbRGuwveERSymfJ0G1ATedyvoike6vPpJOFgPXeIqd/SDHx+MukSJQnZ6YRMXMOOuMfnLBVDydx9JDfu5gBcG0TE34jotGi4WI0EE1to1K9oFMjMyDI5O36qxeG1dmOriTXSJi8GEfFwaJd+fLlyrdcumpiAj551Fmpf6uEbmyFV1V52Ed4xgEMn5w/k1BYNK8qkvBfBjwUvb3pYmS9OOtnM755TUnxxR5vhH93+T2CiGl+DIpK1FWjXa3NLRmtkYbH1MO//nKaC5xFxDKU7rGo5Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB8259.namprd11.prod.outlook.com (2603:10b6:510:1c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.24; Fri, 14 Jun
 2024 00:20:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7677.019; Fri, 14 Jun 2024
 00:20:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Thread-Topic: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Thread-Index: AQHaaI2/dJkfmwuOl0Kzt5Q4G20a/rGPjNSAgABl+QCAAANegIAAB3kAgAAJ9QCAAO1bAIAFfyEAgBj234CAANvZgIAAtdgAgAcL1wCADwerAA==
Date: Fri, 14 Jun 2024 00:20:20 +0000
Message-ID: <405dd8997aaaf33419be6b0fc37974370d63fd8c.camel@intel.com>
References: <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
	 <Zjz7bRcIpe8nL0Gs@google.com>
	 <5ba2b661-0db5-4b49-9489-4d3e72adf7d2@intel.com>
	 <Zj1Ty6bqbwst4u_N@google.com>
	 <49b7402c-8895-4d53-ad00-07ce7863894d@intel.com>
	 <20240509235522.GA480079@ls.amr.corp.intel.com>
	 <Zj4phpnqYNoNTVeP@google.com>
	 <50e09676-4dfc-473f-8b34-7f7a98ab5228@intel.com>
	 <Zle29YsDN5Hff7Lo@google.com>
	 <f2952ae37a2bdaf3eb53858e54e6cc4986c62528.camel@intel.com>
	 <ZliUecH-I1EhN7Ke@google.com>
	 <38210be0e7cc267a459d97d70f3aff07855b7efd.camel@intel.com>
In-Reply-To: <38210be0e7cc267a459d97d70f3aff07855b7efd.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB8259:EE_
x-ms-office365-filtering-correlation-id: 8647bc6c-863d-4068-d1ca-08dc8c07c6ed
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230035|1800799019|366011|376009|38070700013;
x-microsoft-antispam-message-info: =?utf-8?B?UGNUb0VyclNoZ3MwVFB4cE9nZVRodFF6Z0FtNHFXZTdYUVAzZGtHYUdpUEVE?=
 =?utf-8?B?YUJFZVlvYkt0d1J5UjFMNlFVZEdybVJMSHVSNU5ZdnUrYkg2WHJKeHZyZk9U?=
 =?utf-8?B?VTM3NlNXRml3eFBBNGszRnQ1WTEvdDlycFZvbU8rbVdpTi9ReWFkSDNqbUtF?=
 =?utf-8?B?QzFXVGZGbll2d0NMbFBwY251QVB5NENMdWpEMUJ6NjFGQkIwTE1YRkxBbmh1?=
 =?utf-8?B?RHdibjdTTkNKa1BiSTFPUGZtdDRDSUY5UW5GY2NoRWVRYU5yVW5IWjhKOW11?=
 =?utf-8?B?bHIwb2doZDBSYk1Ca1IxZXIzQkJQMnU3Vzl4ZDBWMmRGRG9DT2JER1VYWjhP?=
 =?utf-8?B?Vm13MVhCMGQ5WUk2Qnl4aEtNYkttcHdOWm5MKzJBMy9IeXRZdTVlV05OeHR0?=
 =?utf-8?B?RlYzTlR3SUoyalZ1VjFjeXFQeHRwb1lDbTc4Y1N6NjlwVVAzUzZBQkpaOVJE?=
 =?utf-8?B?R1l6VUovbmRUVkRvakR6UDd0dWphQmpGalBrTXZJNXV0WWg2ZGcvaUZFaEdx?=
 =?utf-8?B?L1lJczNsV2FEVDdwVytnQ2lsUXJtcVlJUVRRU0tYTzVsWFkxU3BwazBjVjBC?=
 =?utf-8?B?cjdQY1RqY0FQOGNEK0hHUWJXWDQ1QVBiYWt0LzlIRE02ZXd3bFFBMkpLUlI0?=
 =?utf-8?B?bExwV3JwTStiT2ZuZ2RMZlhIMC9rcVdKeUFBck1JamRLSklVOVozZGE1NWVa?=
 =?utf-8?B?eGU3RE1rWWQ5RjZJaUk3WnlEaWMvN1JBMzV0UEZRNFJ1RTh1NzdCc0Z4K3hr?=
 =?utf-8?B?Mk5tL25uUE5nSGxBYTFqWkRhYmNsRUw3Rm5ZMThDL3NDdVUrczR5alp2TDZ2?=
 =?utf-8?B?YWkyUFRiQ1p1RWpuN080bGtsSlMxYW5CY3dMOVJBb3UyMVZpdGFhM3FxY2JN?=
 =?utf-8?B?VS9wQmNXQldabXZhVjJGZnJLL25VWmNGQXVGVzdZN1ZTUm55RW9TT1BIZ3Y2?=
 =?utf-8?B?eEQwTjdpK3VXK0JtaTZyRFdCa3dLbzNBN3VkRTJjM01oMWI4NS9CdWZ5YlVk?=
 =?utf-8?B?WmxOZDZjeFhLUWZyUHg3aW5Pa1h5T3hSTENPM1ltUkVGemVXeDJBTVE1Ynl6?=
 =?utf-8?B?ZDhibyt0cmFKWlAzL01IcmJQWHJtbTQrTzZsa3pvMlYwaWp2c2cvU20rZGtT?=
 =?utf-8?B?SUNCSWZkZjJleUJ1OE1PWWt0dGtmbnlSSUVWVFdPUlBRNHpCamRFbER3MkNK?=
 =?utf-8?B?djZlb2U5c051WGl2WFFoeUFROGxRN2VNQzJhczhVL05vSmdCVjRFcWhRenBk?=
 =?utf-8?B?U1RRWlkxRVp6RG9lMzJBbTFVdHR6N0NFejBVYkt4UEtpVFdDdVUrWGdLQnVV?=
 =?utf-8?B?ZTlveTREanFkbGY0a3RjVUZVSlowNXdGMUVzdlZWNmlneXBhVmZiMGd6Y1pj?=
 =?utf-8?B?Z0VHbUx1MkRXMitZaWsrTjV4Y2lxU1FEeGkvVW9INnBCRjRiRVhTMFlna3h2?=
 =?utf-8?B?OTJiNDZ2S0ROY0plQ0I0RUVnTDJQVWZGeEl4NUFVcEcwWGtORXpXQituQ3Zr?=
 =?utf-8?B?RFZEcDRyeG1NdTROQjd0M2MvMVZ4bUlZcGlud3h2NE1tV2hHNWVScDNBT1ZF?=
 =?utf-8?B?VVVDdnhNdDJxV1FUWFBjMmd1TUNwMUwrdk1OTURqTEFGYzhyUUdDam8wNEE4?=
 =?utf-8?B?Y21mUEJCZFIxNngvUXVIUmNCNHFweUNhWTg2WXRFNXQ3Z3lJZnIvekJFb0Iw?=
 =?utf-8?B?QTZlRWJkNlg1SGNIeTRQQ0x2K2VtK3huQi9PRksvdkRQbU5FbzhpelczU0VO?=
 =?utf-8?B?QjlmMFZBOFpEbzRxeUpNOXZKSkdBL1NBamsxRXAxQkE0VmQ3UFQ3dDNxMkJX?=
 =?utf-8?Q?DCBPOdTXmr+BFlADEaCpHoZYZBuz+BIxikHp8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(376009)(38070700013);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vy9QRytMOEVha29qekJDTWpRdGxTMGp5N2gwZU9vYlNsQzgwcWJTbUFkM2tx?=
 =?utf-8?B?NFcwS0dZOWR2SW5IL2NyZ0d5R1d5RlQwRnlVTklTYzZlS3ErOEdFSEp1WjFh?=
 =?utf-8?B?MkRZbi9LM2hPblFSZzI5b3ZBRXVrdjcvcDJTQWRFVjBidy8ra1hpSkN0a25H?=
 =?utf-8?B?UTlwVXJTZWpyeHJGbjA4VlVVb1hSNk9NS1ZGU0F2SDcrOGN0djEvbWlxYnhN?=
 =?utf-8?B?TTI1b1M0OG9sUHNhY3NvL1FNNGNnZ1plS0dkY2xhVk1nV1VNdUNQL2RJeG8y?=
 =?utf-8?B?OUpBVDhvbEVqdzd6ZVI2UHgyUXAwYm5JZzhDYUZzWk1yKzNpN0ZveXlyNG0x?=
 =?utf-8?B?MGY3Q01aL3ZFZFZqK1NNR3JveUNhNHdIMkJaUGdGNTQyd2crdWRTWlVJMlUw?=
 =?utf-8?B?RzR2d3ZpWXYrcHpVSDA5aXlZRHlOSjgwRlpLc3ljOVdjSDNQcnRjdHZCNlJL?=
 =?utf-8?B?UFA5N24xelcrWTU1S241Q2x5NlJHd21OM0YyeFU4M1R2eWJZWkh2eHBYQlQz?=
 =?utf-8?B?Zkd5MnVrSmx4VlZDUU9NY0U5Z2FkVmt2ZmFVQVlmc0dQZGxsNElOKzVkY3Ux?=
 =?utf-8?B?dDNRZGZxVC9ST2s3czFVVjJ1dDZXVFd2ZUxvMHRHOUU0d2lEcWdpWEU1TmxF?=
 =?utf-8?B?dTFMN2pGUEFiNVlWTjFTNGhNN2dmdzVlK0hLdEt6dWYvYUZEWnZsaEVXZDJ2?=
 =?utf-8?B?aDdMWk03TUgxRVo1ejVocEtxdkk0ZlRpTHplbnVGQyt2US9vN1BnMy92TlJS?=
 =?utf-8?B?UnNhaW5KS0Yxa2taSmxQdmlFd2pmL25FeFN4RDdaNjNBUDg3NVBpWlVWOUEx?=
 =?utf-8?B?NnNWUktMU3haMmx2WlVPSjlHWHpQL3kyNms0QVEvdm1IRzJCRFp0dW9RWTd1?=
 =?utf-8?B?UTU1SUxCVm4yM2hOTWdSLzVzNlRuRHZqbkRKWUVybnpZZWRHN2JObVRKZU05?=
 =?utf-8?B?NldsTllnTHNPYm9xNk9BdXZTclRFT2U2Wmc0dUJTRlczWXBiWTNWU1lJcmZm?=
 =?utf-8?B?WEJod2U5N2o4Rm82UkROQTdvZUVMZzFjcVAxYVd2SU5iY3VELzVwM1hiTjlG?=
 =?utf-8?B?dkdrcUpCRVFCbFM2c01oaXB4S2hPUjliRlNnUkQ4bUY4UHdmRm1WcTZnS2Nh?=
 =?utf-8?B?MXQ3N3dqOEtrc3RWOTd6R0phTjFsZi8wSHFHRzhWVTAvNU1pYXh5YXhXUmls?=
 =?utf-8?B?NUdkV24zZUFsVGlmdVdSUnVhWVlRM2dnR0NDbzVFM3ZSYTliOFBCeXMzSkd2?=
 =?utf-8?B?YmtCQXNtTzhiZHlwQTdEUmZmWHoxczZUT0J0dEFlQ3FsRUg2ZmZ2b2poejJo?=
 =?utf-8?B?SjlLWXl4Z2Jxa1M2b0lXQnVaQ2hKczFCSzJrN2VmZWs1SXhtMkpyMkpRTm5N?=
 =?utf-8?B?Q0xUeDRQUk4zRWdSaCtaSHYwNnJpN3RwR3VUOEZBZFJrS2puSmt5ano0MXVs?=
 =?utf-8?B?Q3NET2RBTXpIUEF5NmZUZUxpVXY3M0tidklRKythZ2NUdEVlNCtaK0IzVlB1?=
 =?utf-8?B?ZzU3eWtMM3ZNdkFCSGNXZnBmbmJxTksyaGNGRXV3MDR2cUZiS2xjQzU2OHBu?=
 =?utf-8?B?amlSVU4waGJkdjBSMFpIU0MxR0JtYncwUkdhQnNqb3Y5dGp3RlNEVm5HdGNG?=
 =?utf-8?B?UmZwZHhXZ3hydE0yN0pUY2dJdHdROEpRQk5zTEtYQVNzUzQ3UG1hT1A0b1B6?=
 =?utf-8?B?bzlsUnpmMXdVVERwV1pLSDJSUmZwdngwOHJGSHViTkxkMGNnblFMYzhoaVp0?=
 =?utf-8?B?Zlowdnk2akFGUmkxbWExM1NUb0hEbGdJVS9La0NWZ0lUWTZta2dlSkxOOGps?=
 =?utf-8?B?TlByK1FSTEJsc1FHZzlIVHViQ0crU0V1dzMxNHpSOUZ1eEt0RGl6RHp2MVVq?=
 =?utf-8?B?c08wZlJoL3Y5N3ZTM2N0OWZacjNGcjBoL1l1RzNnKzMvUTFyOGVqdTVqZHNG?=
 =?utf-8?B?VFc0cExBdTlQTDlsc0ZUWWJFemxBSlNjSlBVS3lseEF5M3Z3bzd6Qk5pVGFE?=
 =?utf-8?B?NHJlOStmc2I3WEJCNjdPd2Y5NmtDZkYxeERNNjdleENxdVJkOHR4V3dMT09V?=
 =?utf-8?B?dnhkUFVqb2JmTm53MW1abXlpOU1vMHhpTkxpRUZvUVJKOVJJYXlpUW9xQnhw?=
 =?utf-8?Q?Im+HH81DNFA2jDgTOw3ezmxZa?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E8ACBC536A10A4F8550F9FA6089EFCC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8647bc6c-863d-4068-d1ca-08dc8c07c6ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2024 00:20:20.9403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZZvUNb1TODIi/XyXo8vr1vu0ea6CzPkcs2n647GQxCQ5S4gupynFfqa3zqWsCae2hUm3BZma6YY8lAbKZxeu6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8259
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA2LTA0IGF0IDEwOjQ4ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUaHUsIDIwMjQtMDUtMzAgYXQgMTY6MTIgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3Jv
dGU6DQo+ID4gT24gVGh1LCBNYXkgMzAsIDIwMjQsIEthaSBIdWFuZyB3cm90ZToNCj4gPiA+IE9u
IFdlZCwgMjAyNC0wNS0yOSBhdCAxNjoxNSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90
ZToNCj4gPiA+ID4gSW4gdGhlIHVubGlrZWx5IGV2ZW50IHRoZXJlIGlzIGEgbGVnaXRpbWF0ZSBy
ZWFzb24gZm9yIG1heF92Y3B1c19wZXJfdGQgYmVpbmcNCj4gPiA+ID4gbGVzcyB0aGFuIEtWTSdz
IG1pbmltdW0sIHRoZW4gd2UgY2FuIHVwZGF0ZSBLVk0ncyBtaW5pbXVtIGFzIG5lZWRlZC4gIEJ1
dCBBRkFJQ1QsDQo+ID4gPiA+IHRoYXQncyBwdXJlbHkgdGhlb3JldGljYWwgYXQgdGhpcyBwb2lu
dCwgaS5lLiB0aGlzIGlzIGFsbCBtdWNoIGFkbyBhYm91dCBub3RoaW5nLg0KPiA+ID4gDQo+ID4g
PiBJIGFtIGFmcmFpZCB3ZSBhbHJlYWR5IGhhdmUgYSBsZWdpdGltYXRlIGNhc2U6IFREIHBhcnRp
dGlvbmluZy4gIElzYWt1DQo+ID4gPiB0b2xkIG1lIHRoZSAnbWF4X3ZjcHVzX3Blcl90ZCcgaXMg
bG93ZWQgdG8gNTEyIGZvciB0aGUgbW9kdWxlcyB3aXRoIFREDQo+ID4gPiBwYXJ0aXRpb25pbmcg
c3VwcG9ydGVkLiAgQW5kIGFnYWluIHRoaXMgaXMgc3RhdGljLCBpLmUuLCBkb2Vzbid0IHJlcXVp
cmUNCj4gPiA+IFREIHBhcnRpdGlvbmluZyB0byBiZSBvcHQtaW4gdG8gbG93IHRvIDUxMi4NCj4g
PiANCj4gPiBTbyB3aGF0J3MgSW50ZWwncyBwbGFuIGZvciB1c2UgY2FzZXMgdGhhdCBjcmVhdGVz
IFREcyB3aXRoID41MTIgdkNQVXM/DQo+IA0KPiBJIGNoZWNrZWQgd2l0aCBURFggbW9kdWxlIGd1
eXMuICBUdXJucyBvdXQgdGhlICdtYXhfdmNwdXNfcGVyX3RkJyB3YXNuJ3QNCj4gaW50cm9kdWNl
ZCBiZWNhdXNlIG9mIFREIHBhcnRpdGlvbmluZywgYW5kIHRoZXkgYXJlIG5vdCBhY3R1YWxseSBy
ZWxhdGVkLg0KPiANCj4gVGhleSBpbnRyb2R1Y2VkIHRoaXMgdG8gc3VwcG9ydCAidG9wb2xvZ3kg
dmlydHVhbGl6YXRpb24iLCB3aGljaCByZXF1aXJlcw0KPiBhIHRhYmxlIHRvIHJlY29yZCB0aGUg
WDJBUElDIElEcyBmb3IgYWxsIHZjcHVzIGZvciBlYWNoIFRELiAgSW4gcHJhY3RpY2UsDQo+IGdp
dmVuIGEgVERYIG1vZHVsZSwgdGhlICdtYXhfdmNwdXNfcGVyX3RkJywgYS5rLmEsIHRoZSBYMkFQ
SUMgSUQgdGFibGUNCj4gc2l6ZSByZWZsZWN0cyB0aGUgcGh5c2ljYWwgbG9naWNhbCBjcHVzIHRo
YXQgKkFMTCogcGxhdGZvcm1zIHRoYXQgdGhlDQo+IG1vZHVsZSBzdXBwb3J0cyBjYW4gcG9zc2li
bHkgaGF2ZS4NCj4gDQo+IFRoZSByZWFzb24gb2YgdGhpcyBkZXNpZ24gaXMgVERYIGd1eXMgZG9u
J3QgYmVsaWV2ZSB0aGVyZSdzIHNlbnNlIGluDQo+IHN1cHBvcnRpbmcgdGhlIGNhc2Ugd2hlcmUg
dGhlICdtYXhfdmNwdXMnIGZvciBvbmUgc2luZ2xlIFREIG5lZWRzIHRvDQo+IGV4Y2VlZCB0aGUg
cGh5c2ljYWwgbG9naWNhbCBjcHVzLg0KPiANCj4gU28gaW4gc2hvcnQ6DQo+IA0KPiAtIFRoZSAi
bWF4X3ZjcHVzX3Blcl90ZCIgY2FuIGJlIGRpZmZlcmVudCBkZXBlbmRpbmcgb24gbW9kdWxlIHZl
cnNpb25zLiBJbg0KPiBwcmFjdGljZSBpdCByZWZsZWN0cyB0aGUgbWF4aW11bSBwaHlzaWNhbCBs
b2dpY2FsIGNwdXMgdGhhdCBhbGwgdGhlDQo+IHBsYXRmb3JtcyAodGhhdCB0aGUgbW9kdWxlIHN1
cHBvcnRzKSBjYW4gcG9zc2libHkgaGF2ZS4NCj4gDQo+IC0gQmVmb3JlIENTUHMgZGVwbG95L21p
Z3JhdGUgVEQgb24gYSBURFggbWFjaGluZSwgdGhleSBtdXN0IGJlIGF3YXJlIG9mDQo+IHRoZSAi
bWF4X3ZjcHVzX3Blcl90ZCIgdGhlIG1vZHVsZSBzdXBwb3J0cywgYW5kIG9ubHkgZGVwbG95L21p
Z3JhdGUgVEQgdG8NCj4gaXQgd2hlbiBpdCBjYW4gc3VwcG9ydC4NCj4gDQo+IC0gRm9yIFREWCAx
LjUueHggbW9kdWxlcywgdGhlIHZhbHVlIGlzIDU3NiAodGhlIHByZXZpb3VzIG51bWJlciA1MTIg
aXNuJ3QNCj4gY29ycmVjdCk7IEZvciBURFggMi4wLnh4IG1vZHVsZXMsIHRoZSB2YWx1ZSBpcyBs
YXJnZXIgKD4xMDAwKS4gIEZvciBmdXR1cmUNCj4gbW9kdWxlIHZlcnNpb25zLCBpdCBjb3VsZCBo
YXZlIGEgc21hbGxlciBudW1iZXIsIGRlcGVuZGluZyBvbiB3aGF0DQo+IHBsYXRmb3JtcyB0aGF0
IG1vZHVsZSBuZWVkcyB0byBzdXBwb3J0LiAgQWxzbywgaWYgVERYIGV2ZXIgZ2V0cyBzdXBwb3J0
ZWQNCj4gb24gY2xpZW50IHBsYXRmb3Jtcywgd2UgY2FuIGltYWdlIHRoZSBudW1iZXIgY291bGQg
YmUgbXVjaCBzbWFsbGVyIGR1ZSB0bw0KPiB0aGUgInZjcHVzIHBlciB0ZCBubyBuZWVkIHRvIGV4
Y2VlZCBwaHlzaWNhbCBsb2dpY2FsIGNwdXMiLg0KPiANCj4gV2UgbWF5IGFzayB0aGVtIHRvIHN1
cHBvcnQgdGhlIGNhc2Ugd2hlcmUgJ21heF92Y3B1cycgZm9yIHNpbmdsZSBURA0KPiBleGNlZWRz
IHRoZSBwaHlzaWNhbCBsb2dpY2FsIGNwdXMsIG9yIGF0IGxlYXN0IG5vdCB0byBsb3cgZG93biB0
aGUgdmFsdWUNCj4gYW55IGZ1cnRoZXIgZm9yIGZ1dHVyZSBtb2R1bGVzICg+IDIuMC54eCBtb2R1
bGVzKS4gIFdlIG1heSBhbHNvIGFzayB0aGVtDQo+IHRvIGdpdmUgcHJvbWlzZSB0byBub3QgbG93
IHRoZSBudW1iZXIgdG8gYmVsb3cgc29tZSBjZXJ0YWluIHZhbHVlIGZvciBhbnkNCj4gZnV0dXJl
IG1vZHVsZXMuICBCdXQgSSBhbSBub3Qgc3VyZSB0aGVyZSdzIGFueSBjb25jcmV0ZSByZWFzb24g
dG8gZG8gc28/DQo+IA0KPiBXaGF0J3MgeW91ciB0aGlua2luZz8NCj4gDQoNCkhpIFNlYW4sDQoN
ClNvcnJ5IHRvIHBpbmcsIGJ1dCBkbyB5b3UgaGF2ZSBhbnkgY29tbWVudHMgb24gdGhpcz8NCg0K
SXMgdGhlcmUgYW55dGhpbmcgd2Ugc2hvdWxkIG1ha2UgVERYIG1vZHVsZSBndXlzIGRvPw0K

