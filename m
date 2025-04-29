Return-Path: <kvm+bounces-44639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 750B3AA0014
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 04:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C28601A85BA4
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 02:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA4329DB61;
	Tue, 29 Apr 2025 02:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FK25ZR3E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6770727735;
	Tue, 29 Apr 2025 02:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745895015; cv=fail; b=sm0pmnC2LPpibO5UYYE2iHgCbeNWcutV6XTyWqiC5cl9U9snD7WsEtTT+JcSae18CXEJ/Ma9Y9XsE8nDIw3tCQRWKGOOca1jJDfTejT4VUNu07fG4A/hL6nIZoKBcfdpi3+j/WLuDNDh9ZlSaQX8onDX9z+R9E/P6nMlC4xL4qI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745895015; c=relaxed/simple;
	bh=Xz/0+hzbp5BGzXYJV95XhLCDphotuo28haZGL50meC0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s+iY6uJWIVShiHGSGFRtljDnpObLrNGnHq45xV6zB1dIiNCOLlxQZ00Ozyd8qkPekPv4Hngf/XIa1AiMLyv5ZdckLU3Tbb3mvdyoDbKrCBDoVQF52HuybXjX7t1WrOEeB9u7qBRB+gNijdTqoum4p1u/fiCz8y6FZtHqA5VEids=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FK25ZR3E; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745895014; x=1777431014;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Xz/0+hzbp5BGzXYJV95XhLCDphotuo28haZGL50meC0=;
  b=FK25ZR3ELjwx3/edTdjTQ0jp515Xha09VAhb4TsqrHyhcHSPEyyE0qLw
   v0uSIvF08m6DT4MYXu1ldNqiP2d+tZCaT/ZMTDx8ZL9sbTCap2qkihGff
   h8syFfHJeYU2ktxyFaN+h0UZl3ND/tD7mi8Fro0wl+TwMKfFK73d9Q0kG
   YsbNXoYrPh/4nrnsNj4G42sZ2RHH7KQp7zeVgb8mXSdx08Xpx7igACBBj
   UIzF/TrZyFBr+1h4sYgfDJO5A5KPa8f+jRvbxxx2IHqnF5VCEwZDpcOEE
   Wg0Um+iCHF0thyBpi1N8hZcmqEpgLV55Vh3Tt/QbuFU1IOkfS7bi+XuJj
   A==;
X-CSE-ConnectionGUID: B/SZ4GFORe25uthVV/waJw==
X-CSE-MsgGUID: ywEf7rtoSkesiftz/IrEEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="50161961"
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="50161961"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 19:50:12 -0700
X-CSE-ConnectionGUID: +wqg+fAAR3GTowEMdYKVyg==
X-CSE-MsgGUID: ENfJ85dUTo2evWCru28/Ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="133596281"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 19:50:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 28 Apr 2025 19:50:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 28 Apr 2025 19:50:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 28 Apr 2025 19:50:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=INHnZ+GxIfSJGwalaLy5y7Oy5F38KHXdD14rhx1P9LaXSk4JkfaaGbubSjvjdgRwb51pdpfyGL0TDOGSUUJAsDZ+7/vfcItOhyCCAg5MbY2hEOfJtRbDda3X/T+LvOXWHvYAdaskzPqpW5HG5Y/To6xuoLXGg4X0bJ/dI0hrW/p2NLm3u6NCsPzOWHb9A0rn6mPTpGCO05/+YtXxRRzU4xIx5XqFB3nfjsrcQ89j6XhRJiVBr1d9RQW7PuLWrwHDTUd3twpc6gm42qRwLOLEXBrp3UoF42V9xFIAnQ+c3SgsSXrrTfSpIo8Cj7Lu/+qBpJHRUPTPVXKDTp0mITsocg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xz/0+hzbp5BGzXYJV95XhLCDphotuo28haZGL50meC0=;
 b=xOP2H867iz6VGY8wmg6k7y6DHqLzgV6Vj8pPI5OyVXCcKxH7GK3nMScgLWS5g+Vb12q9ap2qtmfA+NrYWm2Fq/ZDVUxO62GJFESZ94FFWYXRbIExMSaMhaR2zGoYLQx9vNQ3SSTvmVXv//qkjiGdndd3P+qnZPZ847GPjkhVL6IxbsmM0dug5zaw8JYmGu7pQpsn74lu7RFFXngICMvvMzFkaYkYxz2OE40sFqZFFcDGtKUwK6oyy60GYjxZ1CZHV6EK7pwGoDWRuLc6as0+wJYT73fi2ERDOUb4BlCpBnTnDkZ8jIMhg74fFxErAqDuTk4bZtq5/QWWIBwhj/w1iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB7701.namprd11.prod.outlook.com (2603:10b6:a03:4e4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Tue, 29 Apr
 2025 02:50:07 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 02:50:07 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Bae, Chang Seok" <chang.seok.bae@intel.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Spassov,
 Stanislav" <stanspas@amazon.de>, "levymitchell0@gmail.com"
	<levymitchell0@gmail.com>, "samuel.holland@sifive.com"
	<samuel.holland@sifive.com>, "Li, Xin3" <xin3.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "john.allen@amd.com"
	<john.allen@amd.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"vigbalas@amd.com" <vigbalas@amd.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "aruna.ramakrishna@oracle.com"
	<aruna.ramakrishna@oracle.com>, "Gao, Chao" <chao.gao@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
Thread-Topic: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features
 for host and guest FPUs
Thread-Index: AQHbqelZqhZU+Oq6j0yiouUZFd9/N7Ozg2wAgACfzYCAAIHMgIAAgC8AgAQvOgCAAJ7/AIAAG5MA
Date: Tue, 29 Apr 2025 02:50:07 +0000
Message-ID: <bf9c19457081735f3b9be023fc41152d0be69b27.camel@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
	 <20250410072605.2358393-4-chao.gao@intel.com>
	 <f53bea9b13bd8351dc9bba5e443d5e4f4934555d.camel@intel.com>
	 <aAtG13wd35yMNahd@intel.com>
	 <4a4b1f18d585c7799e5262453e4cfa2cf47c3175.camel@intel.com>
	 <aAwdQ759Y6V7SGhv@google.com>
	 <6ca20733644279373227f1f9633527c4a96e30ef.camel@intel.com>
	 <9925d172-94e1-4e7a-947e-46261ac83864@intel.com>
In-Reply-To: <9925d172-94e1-4e7a-947e-46261ac83864@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB7701:EE_
x-ms-office365-filtering-correlation-id: 54829c45-4eed-4087-3935-08dd86c88cd6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TW9lQ01lSXQxTG1jWWVlQ1g2ZDB4VjJjQmxiNDIrS3BjNi9JQTA3bGRPRC9U?=
 =?utf-8?B?UTVKVTlvbXQwQzZoV2FERFY2ZGhCNjFNNWtWcFBIV2RXLzlSc0YzNUR5czZN?=
 =?utf-8?B?YTFUUndUcTdiN1hGbGUxZFgwYmdUREpzbEIzNGxEQ1lvRnYwOFFCWkNSZm14?=
 =?utf-8?B?Z25CR1hySGM2dzZEZ1Z4ZVB0bFg5TzBxQmszdnRZUkJiajJhWTFycFljbVJ4?=
 =?utf-8?B?azY2NU9rTXFMODBjaCtWNnRDSmtaVXd0c21NL2JtalFFNXlQQmV5OHpNUnNM?=
 =?utf-8?B?NVRNQ3dKVDVOblRBTS8xd2FHMDZXNklDM054elZQUElzSG1ERG5wL0dQNDY3?=
 =?utf-8?B?UHVXVVd5OUo5R09VQllEbEhCRStlUUthM3p6b3ZXelNGZncwR1hNMjFkaHh2?=
 =?utf-8?B?SjNVdDNZdUsvc3JTYzFjcTBjNDBqSkxNelBHT3hSaTRRT0FNR2hUamhpcG93?=
 =?utf-8?B?NlY0Ryt5ZFZsTEpzQlhuNDVkUUxkb0gxS1Q4T0d1NW9IMWZXb2pPWlhIU1Bs?=
 =?utf-8?B?UFVBY20xR2tSWFAvWGMyanN4Umc2dFdJUkZrdm1uM1lZTXRqVURKWHBzRzJI?=
 =?utf-8?B?bFlsSkZRNlpQcVdPdENXanFqajhSd2hIVytnTWZYUTZ6WWpnbFlDYW1zV0NW?=
 =?utf-8?B?RHY2aGpMRWNxeFFlQm5iZTdRR2hFTHBLekxCNDhheEphSjdYVSt2VGhtT3lI?=
 =?utf-8?B?bGgxRk5MN1VnTk9KanE4VXNHSWJpS0Jibko2dU5JRDBrRlRsS3k3N0tuZm1Q?=
 =?utf-8?B?dGhoT3NuVnIyZ1VFWVU0QW9BNkppZzdxelBaUkFuenhEbVdNMFVIV0dVVHM4?=
 =?utf-8?B?V0hBSGN3c3F6TDJZOHdiWlN6R3V0dXhyckNnclRlRUdlaFAzNWdINVdjc05i?=
 =?utf-8?B?UVFNN3BlYWlsZU9PcnR0N0wyNzFFaGJPODU3bFlKSTdmRlNhaTg1M3R2SUNS?=
 =?utf-8?B?RCt4TXVESkYvMS83ODlUQmVONzNRM1dCM1l2THlZTUhhRjFjSjc2QkxKUThn?=
 =?utf-8?B?T0pzKzJTQmFGWjYxZGY3WXhOY3B4VU1rME5pM0cwZkJFYU11TDkzSFVCd0Qv?=
 =?utf-8?B?MGlaTkxkY2hBL2o0aXJhSW5lMkluSTFWS0FvaEhOQUkrNEtKcUR0bHFyVzhT?=
 =?utf-8?B?eldUNHlaY1l6dktmOXFKWkVxNmtpNGV5cys3RzRHT1RnSjA5c0VNTHhEODVZ?=
 =?utf-8?B?NGFIemNjNGJ2b2ZjaWNoMEU3UzJzZ1llN0x4dFZoN3V3TndvZXdSMXdsS3lw?=
 =?utf-8?B?Tk10Q0ViZ3RJNzFZS0JJOHdSSTZqcGlaNHZKTnpBVlpmU2Z4dDlURWhwc1lE?=
 =?utf-8?B?NzE3VVhUS0I2ZU11NXVvOVptWG1BVFE4RHhzODNyY0tlbUY0VGdXNDNFME9K?=
 =?utf-8?B?elhISFRNRHMxTGRKcGtqS3BxM3ZuTTA3Nk8vVXBqUk1HaUpsSk4rRlVSL1pr?=
 =?utf-8?B?bGIvZ3V3d0NVOW5FMFY3YytJWExlZE5JR1I4SWhpSFdLU2Z6UTFIOTdoRkRH?=
 =?utf-8?B?UEFldkNlSzVpUzZSeWE4ZXJobzBnQURtaFVZbXFXcEVsZGZDYTJRVm56bEp3?=
 =?utf-8?B?V3NYKzM3R3FMeTNSRkRVMHRzQ1JocVNYbHM4U1pielo5V1JHdVBaVk56N0tF?=
 =?utf-8?B?R2tleitLZm9sUGs3QmZLWDF1ZVhuMmRsR3N0aEpBc3A2MktHZ0poVTcyR3NS?=
 =?utf-8?B?RVJrS1c4c0trc3pFRVo5Nk5oOGgwZzZqRlB2VCtMcFdUU3RIaDJLcndYOG9q?=
 =?utf-8?B?eE5VLzhOQUp0RXBlZzhxWDRLUzJZNTdkWmRYWVJFN2l6REI2S21peUtFbjhK?=
 =?utf-8?B?R0R1STg3Y0RxRDQ3azk5bXZrY010SFNZZ0ZEazBvSEFKY2tTTkVhNU9lcnlk?=
 =?utf-8?B?ZG5IT2s2aDN5Y1JwYWRRSXg2ZzlGbTBZVFZHc003NzlRbjFScnlkcFo3dGRN?=
 =?utf-8?B?YW1PQ3YzU2RlYnJzMnRiVDNzdkdFZFp1MUN6US9RYUkrOEIrNy9rR3hNdVZ0?=
 =?utf-8?B?c2EvRlYwUmx3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Uk8zT2ZDWFNaVm5SV0ZLVnJOV3c1cGgvZU5rU1RBYk9xM1VxajVIeXE4NGlB?=
 =?utf-8?B?WWl1NXRRVGV1MEZsWmFZVjFqaUdqN2tVc25NeVptQXVCQU80dTBqVXppc0k2?=
 =?utf-8?B?OTNSdGF1dTMwOXlCRENhS1crSnZ5R3p2TTFxZW9aT2VUY09FQ2NXcnVCalJ3?=
 =?utf-8?B?ZkcvSDB4S2dyMlBwSEx2VG1KcTByYjN3NzVyYldzZERxaTNVdEFPSENpRmgz?=
 =?utf-8?B?Z251alhNWWxMOUFMTWQzRFJGb3RSWGhtTTROa3VHRlk0Sm4yaVhGRnNjWVMr?=
 =?utf-8?B?UTN6eTFGdUEzd2FWSGRvNHYwUWVhTWovWEhmNGswZ1lXaWZhMjhwU2EzTkVB?=
 =?utf-8?B?VGxyVWM0ditLaFpPQzF5VVoxbFNQVzQ4UmltK2JubktCV2xudm5qNTdYamh2?=
 =?utf-8?B?Sk1ObzlvdTVTRGF3Uis2RVdwRWYwTHlkcjFwdWpsRlRuaUt3N3drSHBQZGl4?=
 =?utf-8?B?c0NSUFJDZytVanhIQm1IblVHSDJjd2lPaFRYM2l4Q3FUdnJPOGlnMlJ4V3F0?=
 =?utf-8?B?a0ZYZC9leXhtNk8xeCtMMnZLZ0ZrWkExYS9GUkJOSGd3YmpwMFVaY2VwUXJP?=
 =?utf-8?B?SjRmQ0IrY0NleWVBc1NBeXFScWlCSDROQWZvV3lkcGJPWXZUL2p1NWJ4SFUy?=
 =?utf-8?B?Qy85M1VCaFp6ajVTS01LYW0xVzdxY09UOWFXWVh1NjhsdDUyR3BDNHk3a1ZW?=
 =?utf-8?B?WTRCbThiV01JRGRwNnZybDdGbVp3cUJJQVNNTmx0cldzTmo2VzdTYnFGZ0ds?=
 =?utf-8?B?bmpnOFl0MnBOR3VDVjQ0T25TN0U3UW1yaS9DQ1U2NGp2TDF3bXBESWtLU3Ex?=
 =?utf-8?B?Um1FcXJYUWZFMDBQK290a29IeGE5MGZJdWxQQmJJSU1KZURWYmpuR1o0b2NH?=
 =?utf-8?B?LzAyeDZCUHVpczVNd2puZUk2aGoyaVVWRzV0N3dBalloQy8zMmd2YlBYUzZm?=
 =?utf-8?B?TWgxM2RwRWJXcUpySmVWdzlNZ0s3SkUrWVFLMDN5R3pYekdMZ3huUVlSWis2?=
 =?utf-8?B?MXR0bXpyZTBHTzRTSWFQWGhvaGlRTGNXSW80RVlnK05DNmxseXFaQVhYN3hH?=
 =?utf-8?B?M05Ia1Y0SUNpS3FNRjlwZ1pxQkRRdFB3TU5kRFJ0UndyS3YvektZQUF5TUcr?=
 =?utf-8?B?VEZnd2svM0xjVzhrM3MxTDMyQlFaUjltOER1NGp1cmZnbWNMZ1l6NkVYUDQ1?=
 =?utf-8?B?cVNmMUlrdFo5ekk1Und2OFFFVmIyb1lSUzJtQ3VZaUkwVURrWE5GRnBacFMz?=
 =?utf-8?B?c2UxM3pKakdJTWRaTkgzNkVCQldxdllPRjd2RlJvT3JvYzNabVlscUZMYjFS?=
 =?utf-8?B?dGxsV0NmUlZ6NmtTQk83ekhEOWdKTmgzL2F6bjBGc3ZBdzc4UzZnd2lZd1pJ?=
 =?utf-8?B?cDNVMkZyQmlmdnRHSTgzYlFnbmR1WHpDQnljOU14YWZxekhwMzcrR1VYbkZi?=
 =?utf-8?B?SDdwMUxRY0ZSL2tta1pSVDIvNlQ3WlZaSzBHNzJFOWoyN0VtVFg2SDlkTXF2?=
 =?utf-8?B?RVNYMGYvYVBvWmsreGUvdnIxT1o0MWxwaG0xOW9xZGxDZmJCNEJDMnhwRG9P?=
 =?utf-8?B?WEVFTHBud09NaGNDdm1HUWlWSDhRVE4yVUw4ZjZUL2VCYys1QlZZRFNQK1J2?=
 =?utf-8?B?aEliSXJ0ZmRYdFYxN0Z5MFI4eFo5S2NqKy9LdndMSHVaQzEwdkxROGdBakZj?=
 =?utf-8?B?Zm9iUmhKRUc3MTJTem5iSW4xcUhXTnhwYjBTQzBaNVJXUGcwQW1BSVZhSC9i?=
 =?utf-8?B?eVdzTFhxQXdwVlgvcGFCUm1OS0NvZ3VPTHdKUWEweGN1UkVjSVlsMi9HSFZi?=
 =?utf-8?B?REhaczBMWUUrdC9tbFVhNEdHbVZmOGdYQmc5QzByV2lvMU13ZjNtbFFjZE1Z?=
 =?utf-8?B?Q2VaZ0FwOEVpWE9pWXpGdW1zN0tOVHVIS2pEK0NqcUFOOHMrbEJsYk5WbnJt?=
 =?utf-8?B?WjZFVzN5ckxSQ1h5L3MvdmE5TGVwTmFIRGxpRFQ2bytuaks5RWNNb2VBT0xo?=
 =?utf-8?B?ZWc5QUtSLzBYZTdkcjhZampOalczc3BmVE12RXQxK0s1dkhXVnJ4bzl3UkhS?=
 =?utf-8?B?UDFuaDNHbFpDb1A3UCthN2tDM3pyaU5DZGlWSFM0QzR1endkTnZuRVFTZHlO?=
 =?utf-8?B?eHVyM2ZpOVdZRmNsWlA5OEY0cmRCN2N0VWlONUI4UmNPMng2b2ZEVjExNlQ1?=
 =?utf-8?B?dGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BBA92E682436C54EBE9A40026F58AFFA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54829c45-4eed-4087-3935-08dd86c88cd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2025 02:50:07.0835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BUDoe8ov6PX0pSuoVN1lUcQ/PDA+5b4jxB9lsU8+Afg46VREv+8u/LZXWX9aibh++2Oh8WnHvVJqoIdE9TlphF+XTf5KN56gh2KGDqW5/lU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7701
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA0LTI4IGF0IDE4OjExIC0wNzAwLCBDaGFuZyBTLiBCYWUgd3JvdGU6DQo+
IE9uIDQvMjgvMjAyNSA4OjQyIEFNLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90ZToNCj4gPiANCj4g
PiBSaWdodCwgc28gdGhlcmUgc2hvdWxkIGJlIG5vIG5lZWQgdG8ga2VlcCBhIHNlcGFyYXRlIGZl
YXR1cmVzIGFuZCBidWZmZXIgc2l6ZQ0KPiA+IGZvciBLVk0ncyB4c2F2ZSBVQUJJLCBhcyB0aGlz
IHBhdGNoIGRvZXMuIExldCdzIGp1c3QgbGVhdmUgaXQgdXNpbmcgdGhlIGNvcmUNCj4gPiBrZXJu
ZWxzIFVBQkkgdmVyc2lvbi4NCj4gDQo+IEhtbSwgd2h5IHNvPw0KPiANCj4gQXMgSSBzZWUgaXQs
IHRoZSB2Y3B1LT5hcmNoLmd1ZXN0X2ZwdSBzdHJ1Y3R1cmUgaXMgYWxyZWFkeSBleHBvc2VkIHRv
IA0KPiBLVk0uIFRoaXMgc2VyaWVzIGRvZXNu4oCZdCBtb2RpZnkgdGhvc2Ugc3RydWN0dXJlcyAo
ZnB1X2d1ZXN0IGFuZCANCj4gZnBzdGF0ZSksIG90aGVyIHRoYW4gcmVtb3ZpbmcgYSBkZWFkIGZp
ZWxkIChwYXRjaCAyKS4NCj4gDQo+IEJvdGggLT51c2Vyc2l6ZSBhbmQgLT51c2VyX3hmZWF0dXJl
cyBmaWVsZHMgYXJlIGFscmVhZHkgZXhwb3NlZCAtLSANCj4gY3VycmVudGx5IEtWTSBqdXN0IGRv
ZXNu4oCZdCByZWZlcmVuY2UgdGhlbSBhdCBhbGwuDQo+IA0KPiBBbGwgdGhlIGNoYW5nZXMgaW50
cm9kdWNlZCBoZXJlIGFyZSB0cmFuc3BhcmVudCB0byBLVk0uIE9yZ2FuaXppbmcgdGhlIA0KPiBp
bml0aWFsIHZhbHVlcyBhbmQgd2lyaW5nIHVwIGd1ZXN0X3Blcm0gYW5kIGZwc3RhdGUgYXJlIGVu
dGlyZWx5IA0KPiBpbnRlcm5hbCB0byB0aGUgeDg2IGNvcmUsIG5vPw0KDQpUaGlzIHBhdGNoIGFk
ZHMgc3RydWN0IHZjcHVfZnB1X2NvbmZpZywgd2l0aCBuZXcgZmllbGRzIHVzZXJfc2l6ZSwNCnVz
ZXJfZmVhdHVyZXMuIFRoZW4gdGhvc2UgZmllbGRzIGFyZSB1c2VkIHRvIGNvbmZpZ3VyZSB0aGUg
Z3Vlc3QgRlBVLCB3aGVyZQ0KdG9kYXkgaXQganVzdCB1c2VzIGZwdV91c2VyX2NmZy5kZWZhdWx0
X2ZlYXR1cmVzLCBldGMuDQoNCktWTSBkb2Vzbid0IHJlZmVyIHRvIGFueSBvZiB0aG9zZSBmaWVs
ZHMgc3BlY2lmaWNhbGx5LCBidXQgc2luY2UgdGhleSBhcmUgdXNlZA0KdG8gY29uZmlndXJlIHN0
cnVjdCBmcHVfZ3Vlc3QgdGhleSBiZWNvbWUgcGFydCBvZiBLVk0ncyB1QUJJLg0KDQpQZXIgU2Vh
biwgS1ZNJ3MgS1ZNX0dFVF9YU0FWRSBBUEkgd29uJ3QgZGlmZmVyIGZyb20gYXJjaC94ODYncyB1
QUJJIGJlaGF2aW9yLg0KVGhlcmUgaXMgKGFuZCB3aWxsIGJlKSBvbmx5IG9uZSBkZWZhdWx0IHVz
ZXIgZmVhdHVyZXMgYW5kIHNpemUuIFNvIHdoYXQgaXMgdGhlDQpwb2ludCBvZiBoYXZpbmcgYSBz
cGVjaWFsIGd1ZXN0IHZlcnNpb24gd2l0aCBpZGVudGljYWwgdmFsdWVzPyBKdXN0IHVzZSB0aGUN
CnNpbmdsZSBvbmUgZm9yIGd1ZXN0IEZQVSBhbmQgbm9ybWFsLg0KDQpDaGFvIG1lbnRpb25lZCBv
ZmZsaW5lIGl0IHdhcyBmb3Igc3ltbWV0cnkuIEkgZG9uJ3Qgd2FudCB0byBtYWtlIGEgYmlnIGRl
YWwgb3V0DQpvZiBpdCwgYnV0IGl0IGRvZXNuJ3QgbWFrZSBzZW5zZSB0byBtZS4gSXQgbWFkZSBt
ZSB3b25kZXIgaWYgdGhlcmUgd2FzIHNvbWUNCmRpdmVyZ2VuY2UgaW4gS1ZNIGFuZCBhcmNoL3g4
NiB1c2VyIGZlYXR1cmVzLg0K

