Return-Path: <kvm+bounces-34569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 40049A01C0B
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 22:33:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78E961884B1D
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 21:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 884CB156228;
	Sun,  5 Jan 2025 21:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h7FTyTeg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268768821;
	Sun,  5 Jan 2025 21:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736112810; cv=fail; b=rOkW6vut31ExbXtMAzQOhXSVGoe8EVZ8wo9l565vecO4/x0qQBTZI2v+u20JocEc4CxmB7n79X7wJwlMJcYBr6NZuILS6ndBGRUt4wNhYZqM/56bFY1d1ltfiXfAFhye4RO45Syw6j4aJwLzqIykxSDIzBUzOxs8f6hzELFlNUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736112810; c=relaxed/simple;
	bh=3MmOqGbayuIYGx1EQXtdga4wU/ym+7LC6X5PfaLs0uk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=miIMfrTsrLqfRJRdl3MCA/dTrTouKNf7EZRtjWRByWNohwJgY6143RcOjMr5yMhK+S5PzddPmtWjyTyhCbhKHqQcqJFhVgmcVTBqkP2StQlbpoCS2G6VU1PuiwbkBCH+le0ej8fWQwHBaxUhGDXFP/JZDaO0G7CCb6gG2VZkS7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h7FTyTeg; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736112809; x=1767648809;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3MmOqGbayuIYGx1EQXtdga4wU/ym+7LC6X5PfaLs0uk=;
  b=h7FTyTegR9yjY0HphRDBSwGBQG4Jwd2+41qPIhSN6Zu6lSiptae2CBCz
   iP2kVGzv7aE5zaAdkctbnib/4FQB2eEN13+oATdmkzxRzaOVXPT2QKdtM
   YHGz4XS/PtMd1mVsz9P4A8LZ1a4e4YOXvaPdn5AR849ydAzdoh2hoAqQP
   FrU8V4zE+1Xp2Y2WWfrw5GlZd42ZPF/s1Peo5KAC+GkQiI7zZ4WAWZhLX
   HKvjwuyUMrvQNWMh8u6qXJB//i5EiIMvYQInCawZtZPihr5IFIHm16IR6
   CgBLq5TYXDmINFac1b26bcJDeoOcwKK7j9U9NXSagBQn7uqX717UOmxr8
   g==;
X-CSE-ConnectionGUID: Nm549sMrR7uYWClpb5Yhfg==
X-CSE-MsgGUID: tgGwRt+MTcKENkSfDqA/kw==
X-IronPort-AV: E=McAfee;i="6700,10204,11306"; a="36419786"
X-IronPort-AV: E=Sophos;i="6.12,291,1728975600"; 
   d="scan'208";a="36419786"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2025 13:33:26 -0800
X-CSE-ConnectionGUID: LUOn4HmgT/eP91Ms5r4aSw==
X-CSE-MsgGUID: 8QIDF4RrSwuSXAVsx28WhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,291,1728975600"; 
   d="scan'208";a="107126630"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Jan 2025 13:33:26 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 5 Jan 2025 13:33:25 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 5 Jan 2025 13:33:25 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 5 Jan 2025 13:33:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qf0H0SN5ZPOH1snow60FXLl9NNwPxV2B28xtGXln3cQSJBZzLS3R+rcNPBCEJP4Lm9Jg+o6v+dHGdi08tUADDoN8I3eYCpbLiRVvbMG7TIRECK1rcjLathHDYo9syoqXcxhBODJ8xxcglafrfIgSLpR1LFb0WyeiDFULvv/Vjzvxs+JGq+MHp7NIRN1LBgABsbWfI3bYeXQ/RBLTixp3Rq5bv4eN0lFzsMvbES2PhXB1kcDghMTDogbJ39BL6zgPdllmoWNS3k6lpCGNTLdMqGPTBkYgDEb6HcZ2HlbjTnVPChkb7omG0ISUl8ZYm61neOyptnBgpE1ry8uFmpHRRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3MmOqGbayuIYGx1EQXtdga4wU/ym+7LC6X5PfaLs0uk=;
 b=xBIG07wA9YVmMm5IULYRa/ctSYiJBOFKQxKz8sKumrx5yHHSjifuctTFO1Ktc82RfproyOUNMkHVskfqemn5Dh+nFa0SDpd9zV8IJdWtbxUPC/FVt+CWCXasf6ukOMCGIvfWHeEqdnyvZPWOHPTHPG/j5Ua2C/hzGAQW8wEA+ge+bVgoPwFOOTHXVVEUP2+xGlmAehsTLX3Kx93GhDP2S2+i/VvHjbzws80tePctUWwhr4BYv6p2eLYvdNkEg4KueNfEcBsMD43LyzCwb8fXBBK7L160lVZv8o5gJ7d6rX4Lm2xXSXZc/u3xj+uKs/z6HyRNttBNUO1GCKueZG/kgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6509.namprd11.prod.outlook.com (2603:10b6:930:43::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.15; Sun, 5 Jan
 2025 21:32:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8314.015; Sun, 5 Jan 2025
 21:32:52 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "seanjc@google.com"
	<seanjc@google.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/25] TDX vCPU/VM creation
Thread-Topic: [PATCH v2 00/25] TDX vCPU/VM creation
Thread-Index: AQHbKv4pmjWV/l0MmUK3ZeVob/v/RLL0WKAAgBHlnwCAAt6CAA==
Date: Sun, 5 Jan 2025 21:32:52 +0000
Message-ID: <9b08c078e9809827718d25ba99513b43ed4f1589.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
		 <CABgObfZsF+1YGTQO_+uF+pBPm-i08BrEGCfTG8_o824776c=6Q@mail.gmail.com>
	 <94e37a815632447d4d16df0a85f3ec2e346fca49.camel@intel.com>
In-Reply-To: <94e37a815632447d4d16df0a85f3ec2e346fca49.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.2 (3.54.2-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6509:EE_
x-ms-office365-filtering-correlation-id: ea8426c4-d904-4671-7a2a-08dd2dd082e8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7055299003|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b09Fb29XaHNkcXlNdC9tWHdkTk9DWjEzMGliVWhSWFFmRjdPakdvWUU5YkVO?=
 =?utf-8?B?dzVQcXhPRkNmSWFNeFRMM3ozdXk3UndDcFFiOEkyQnduUk5MMGNFUVY1ZUFs?=
 =?utf-8?B?VzlEYVIrMnFXMHBETTA2ZEtEbTRZbzBGWStUeUZxUllrV3g2WkYyamx4NElE?=
 =?utf-8?B?SUx4VXVJcFAxVkxtRzlMcmdraFBOT3I5bjlpZ21ZOTVIc0UxUFNiUUxqNCta?=
 =?utf-8?B?L2Z3b3QrNVNpY3QzV2xFTFRwSHFCNWlqSXRSMGNCWkNLUFM1SUdXZ0ZtQlo0?=
 =?utf-8?B?aW9sa3Q2cEk2WE8xZ0NhVkpkTDdHRVQ0WGNsTk9yY2pDc3BZTUlyc0JxNWZB?=
 =?utf-8?B?R3lDN1ZoS0x4bUxqd0tWVXpzdnZBY3NIeFVDQWRwU2ZqTEMwU1JlclhsUEF3?=
 =?utf-8?B?bkltOW5POGhIUS9mTVJ6REJoNVc4SEtadS93WkJpZE9yblh0ZVFSSkRmaXlC?=
 =?utf-8?B?L29OSGhOQlpNMndkK2hlNjMxZHFTLzRobDdPUG1TaHB0aENrd1lzWThNb0hD?=
 =?utf-8?B?UFNlY1M2anh4ZmRsRlppVUlUcDNsNCtEZkFIUnV6cTJJU3J2VnhlYWc0Qyti?=
 =?utf-8?B?R3dnSGZJMmY0SDZnbjF3RGhmT3RZQ3c1VDRsUytUZ2RVcTFoUmdDWDRSempr?=
 =?utf-8?B?SXJPcXNLTVhyRE9mcEIxbzQ1cDFpNURGRkRwa0g1bTJ1NGpieVhweVBhcGRw?=
 =?utf-8?B?TzVpVnFuNnpNQ2lhc0U0bTBLRldrV00xaDZoYm0xOUQrUGNUME9Bd25TNXdt?=
 =?utf-8?B?UXl5a1dyLy83ZXErbENOdE95WkZvZDZGNmRueW1HbHdqeU1UQ2s2VlZVZUVX?=
 =?utf-8?B?dVBnN2FXZGJaUTlUV0UvQXR6ZFJvajlzcEhqNC8yKzl2dUVNclRRUHVkN3dq?=
 =?utf-8?B?TzhVRTdKam8wRStvS3BBSG4vWS85UnhqaW14Nk5NaEpIM0hmaHc5MHE5ZmZY?=
 =?utf-8?B?UXRwanM1MHlsdG5HSHY5bnpvbm80Zk8xOTdyaDFYSlB1alZNdUpVblBpYkN2?=
 =?utf-8?B?VkhhMG5mNnJCRmpQcEJndG93VWVadHhwMGRFZmFIZDBMRm5IWkxsSkZBRXdw?=
 =?utf-8?B?dHp2enNSK09lYVZMUmN1Q0lkbitMZVRpc1psb2w4ZG9PRU5YRGg3TUt1Rm43?=
 =?utf-8?B?a3JqMllPcWdZbHNVeVhseWJ4MUQ4U2NvMWh3bmhrK29ER0RNZnJnbzI4U2Ny?=
 =?utf-8?B?Vk9lemMzZzFlR2JHUWh0MWgvV0VsS3QyNnlrRGhlVDl5UkdhalE4ZDlxNWZM?=
 =?utf-8?B?dmUxM0E1bVk3UFM0SjRpMUM1RXFBM2w3U1NQSHlBQ1VHaS9BN0FqcE5HdnQ3?=
 =?utf-8?B?VXFiMkY2SkFvOWpFNXFiamdtWmlCUE13eGFBYU51ZmQybE1SM1JXMTBoUzFF?=
 =?utf-8?B?cVJlOWlqOEU1aHpnVmszNEtHOHJ2Qi80ei9DeVNYWEFWQ2ZOcndIbEU0c2tH?=
 =?utf-8?B?SEZWdnI1a2hpdng1Vzl0Mzc0UEx1eFRMRUhMQzBNeWFSTFJsRG5iclBuN3kx?=
 =?utf-8?B?TWJwUE1WVVF6SW1TUUo2YWllMzErTnhOb3o1YmY1UExhZFMwc2ZOMkc2QW5L?=
 =?utf-8?B?c1BoNm9hdTlJV2ljcGlvMmkxNWg2L0J4U2ZqcHNYbFpJb3dEZDlBVnZCV2Ju?=
 =?utf-8?B?VzlJNXUrQXpBa3B3MFZSd2crVm5kTC96NFljWCswNHFJNUV1eFhoK1FqeWw4?=
 =?utf-8?B?NTZZWnphSHpkRlZXdllMdFZqRGNRRGpBbkJUT3hyRTNIRmI0SWdaTWdmazdR?=
 =?utf-8?B?bTkzZ1N5RXlVVjEvYmxqRjVQS0NsbUVJK0xqVlhFa25HZDdQRlQrd00zS1Ru?=
 =?utf-8?B?UFIvSXJ2cDJrS3cyWmZkdGx3eTVjc1ZPS3RYMzZnZSt2T3FweGZWWStsaGZK?=
 =?utf-8?B?elZwTzl6UGdJMUhsVU5PckpxQ0Rnb0N4TmZOYzlvZG85eXNvUk5rakpzRWdI?=
 =?utf-8?B?YXBnRnNpQU1OU01ibzVSS3hpeVozSFdIOGY0OWd3b2tUR1cxcWFqc3JsV2po?=
 =?utf-8?Q?pfTz30HvHpePHGbzIOf/bhXgD6i55s=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7055299003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUxPVEZCd3RUY2dYQWt5bjAxeGlUTjNYekFKRGZ4Q29LbU1qeTFkdVFlQmYz?=
 =?utf-8?B?b2tick1FekFMMG5UalpEd0N4M1VBdXRUVnJ3dEczMlV3cTVGOWpBRFhXRjZK?=
 =?utf-8?B?djMyMWFRZS96OGdyQzlONmx2UVRpamhXL1BJejBLcy9JeUR1RVBmUmswQ3BV?=
 =?utf-8?B?TGxuc3dsb2lhZ29qVnhPbmF0ajlWaE5DU01Uekp1SmNMMTVTaVpaMzA1L3k0?=
 =?utf-8?B?aG1uMWxkSkhYTmZiUzV3THJ0d1VLUGtWcjU0SFFEYzBFYno2ekJKVUNWODJG?=
 =?utf-8?B?Z3Z2ZVExKzJsTExZRWRzTnNQVjU0c0QySnRvNnR1UVlrV1l5bUl2Q3djUkNG?=
 =?utf-8?B?N0tOTlAwLzI1Z1kyL0ZtU2U1OWZnQ09TMG1WL21MZ2pHREdmZytKZFhwSVlY?=
 =?utf-8?B?Ly9YTUZjZnVSZTZ5L1VrSDVpQzBLQjk4TXVoK09Gc3c5N2VwLzRVSW1mYWpx?=
 =?utf-8?B?c0pqUGlTUkpKc0kvOVcybHBlMm9CMHVPemY0RWtmUVJOdEE0T2piaDJKanJq?=
 =?utf-8?B?MXhseDBPQVBIbEVMYXJzY2xjS1dJVjV2bDdzYUhSVlFRWmJkQVp6ZXZrbE1G?=
 =?utf-8?B?akxTS1lCR2loSzVtY0NSaGk1UFZXR1lydGoxRVdMU0VrUSt0YTN6NDRzLy9k?=
 =?utf-8?B?akN4TDJkM2VDMU9KcCtPRUkzK04zR285MnhNOWNUWndFYVNsNGo5TW1ZZnQy?=
 =?utf-8?B?d1FvOVQ3QXZiK3MvV3lBOWI4Skg1R2xIbjZOQ3lZTGcyamdnWnhBRWpoUDFK?=
 =?utf-8?B?bnRUNGZnUDUxdWRkOXFaanZJL1Rqa0RHZXVGdGdPVFh3MzBnTUFmbHJSbm9y?=
 =?utf-8?B?SlFLM1dNcUREcXFKR1o3cS9vMFVsdFhvbitCdFl1cVRYTDlybHU1VCtZMThw?=
 =?utf-8?B?NFVaNDRaWDFvbkNlU1RVdUg5S0p3OTFiMm5qQXJrbzZUNWdpaStzbFA5YmFx?=
 =?utf-8?B?Sm5YV1J5bDJNckJqaDFKa2VnMGZCSFNBNHYzczVrYUlocnVWazBtNEpHVkFG?=
 =?utf-8?B?WHlKU1l0THVKRjlkUDBPL0xnK3ZTMk50b1pKOGZJZTBLRURrNHp4eFVienIx?=
 =?utf-8?B?QTVkdFpmcktiVmhlTHhpMlU3ekJCNUZFcjcyZzJBQnI1ZHAzQnd1UTdlVlFT?=
 =?utf-8?B?eFJoM2pveEE1Q3VXeUlzTW9JWnVWVW1Zc3JtUm9wZHlhZ2ZDaVVNczEwbkRE?=
 =?utf-8?B?TzZxSXJoNXdtNjdyS3NaVndUdWVvNFI5MmJ2TkdZZUtSRVpidTBkdmlIZDhn?=
 =?utf-8?B?S1hJWTNmYjY2TGk5Wk82Zk9LK2lKcGUxZ29RZHVaVWp0aDUzV3UvbkgyYnc2?=
 =?utf-8?B?YjZTSzhlN1lwZWhCN1IybjhRVU5PVGphUmVYZ2I2dGtOMU00c0tLemFCVlE2?=
 =?utf-8?B?KytnUHpueE1XVXpCejNiaFZUZUdnWlk3RHBaV3oxWE9yQitQZVl0YzFWREhX?=
 =?utf-8?B?QnF4S2pySnIweDhkZzJBNnNjeDFzZ2M5RU5LNE85TEk0YkFpMFY3MU9WREdD?=
 =?utf-8?B?RFoyTTVHQk5pODh6d2xkMkVoUlRLQmpDUjFOeFJmazFrOUVpREVsYTBCdFNE?=
 =?utf-8?B?OXJCblBaRzcyWmsyT3pvdjhDTHREZy9hT2c0TGROQ0wwU1NlckdlTWtvTmpu?=
 =?utf-8?B?NGVBQ2E0NjhIUG5nN0JvU3FIQnlXdUpHTUxhVnIwWTh3c0NYRkdleDZmOWdL?=
 =?utf-8?B?aVhYK1lxMkQvaWYyUmJLWVJnTVk2bHpyL2JEUWErU2tXOTZSK3l3REcxM2tQ?=
 =?utf-8?B?YXVJNHVicStoTmoyTUppVjByOVVEMGJ1WVdWRWtSMXp2eW1pL2c0Z0VGZm53?=
 =?utf-8?B?Yy9EWVdHelhKWUcwMXdLVDRjVkxxZi9QY2JWcldsbWxmMTc1YVpkL0pFM0ZB?=
 =?utf-8?B?ZDk1MUdlb21jQnNXNUljT2xJTlBJNFJlWlZ4L0h0R2w2WHhnWm81UVlPbysw?=
 =?utf-8?B?cThOMTNXSmE1SFp2aHpEOXJHM3FhdXFlbTZpYXhXUnNsL2NoT3FCaldkSVFa?=
 =?utf-8?B?OE5pWndtVmVrMERBR3J4SDVqcXBzbU80Nms0dlhaR2pFaTgzSWtWU2ZFcEZx?=
 =?utf-8?B?WDR3cENCWDhhTXcwbXJDd2hyY1JJaktZcVhCQ21pc1RtWkpkdWNUTkw5M0g5?=
 =?utf-8?Q?an44VY41URWwFNKhH46r/DM9F?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F7C91C497ECF2B4FA64E1838A8162EE3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8426c4-d904-4671-7a2a-08dd2dd082e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2025 21:32:52.8585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RcccBRtT7C2tcBbTaxfvetIhZQFrT86s0xlf6DYnVJiE0yv1mXRLC7Kc9GmczsJEw39jgBplNrng/K3RsV8CdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6509
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI1LTAxLTA0IGF0IDAxOjQzICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gPiAxODogbm90IHN1cmUgd2h5IHRoZSBjaGVjayBhZ2FpbnN0IG51bV9wcmVzZW50X2Nw
dXMoKSBpcyBuZWVkZWQ/DQo+IA0KPiBUaGUgcGVyLXZtIEtWTV9NQVhfVkNQVVMgd2lsbCBiZSBt
aW5fdChpbnQsIGt2bS0+bWF4X3ZjcHVzLCBudW1fcHJlc2VudF9jcHVzKCkpLg0KPiBTbyBpZiB0
ZF9jb25mLT5tYXhfdmNwdXNfcGVyX3RkIDwgbnVtX3ByZXNlbnRfY3B1cygpLCB0aGVuIGl0IG1p
Z2h0IHJlcG9ydA0KPiBzdXBwb3J0aW5nIG1vcmUgQ1BVcyB0aGVuIGFjdHVhbGx5IHN1cHBvcnRl
ZCBieSB0aGUgVERYIG1vZHVsZS4NCg0KUmlnaHQuDQoNCj4gDQo+IEFzIHRvIHdoeSBub3QganVz
dCByZXBvcnQgdGRfY29uZi0+bWF4X3ZjcHVzX3Blcl90ZCwgdGhhdCB2YWx1ZSBpcyB0aGUgbWF4
IENQVXMNCj4gdGhhdCBhcmUgc3VwcG9ydGVkIGJ5IGFueSBwbGF0Zm9ybSB0aGUgVERYIG1vZHVs
ZSBzdXBwb3J0cy4gU28gaXQgaXMgbW9yZSBhYm91dA0KPiB3aGF0IHRoZSBURFggbW9kdWxlIHN1
cHBvcnRzLCB0aGVuIHdoYXQgdXNlcnNwYWNlIGNhcmVzIGFib3V0IChob3cgbWFueSB2Q1BVcw0K
PiB0aGV5IGNhbiB1c2UpLg0KDQpTZWFuIGRpZG4ndCB3YW50IHRvIG1ha2UgcmVwb3J0aW5nIG1h
eGltdW0gdmNwdXMgZGVwZW5kIG9uIHRoZSB3aGltcyBvZiBURFgNCm1vZHVsZSBzaW5jZSB0aGlz
IGRvZXNuJ3QgcHJvdmlkZSBhIHByZWRpY3RhYmxlIEFCSToNCg0KaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcva3ZtL1ptemFxUnkyemp2bHNEZkxAZ29vZ2xlLmNvbS8NCg0KPiANCj4gSSB0aGluayB3
ZSBjb3VsZCBwcm9iYWJseSBnZXQgYnkgd2l0aG91dCB0aGUgY2hlY2sgYW5kIGJsYW1lIHRoZSBU
RFggbW9kdWxlIGlmDQo+IGl0IGRvZXMgc29tZXRoaW5nIHN0cmFuZ2UuIEl0IGlzwqBzZWVtcyBz
YWZlciBBQkktd2lzZSB0byBoYXZlIHRoZSBjaGVjay4gQnV0IHdlDQo+IGFyZSBiZWluZyBhIGJp
dCBtb3JlIGNhdmFsaWVyIGFyb3VuZCBwcm90ZWN0aW5nIGFnYWluc3QgVERYIHN1cHBvcnRlZCBD
UFVJRCBiaXQNCj4gY2hhbmdlcyB0aGVuIG9yaWdpbmFsbHkgcGxhbm5lZCwgc28gdGhlIGNoZWNr
IGhlcmUgbm93IHNlZW1zIGluY29uc2lzdGVudC4NCj4gDQo+IExldCBtZSBmbGFnIEthaSB0byBj
b25maXJtIHRoZXJlIHdhcyBub3Qgc29tZSBrbm93biB2aW9sYXRpbmcgY29uZmlndXJhdGlvbi4g
SGUNCj4gZXhwbG9yZWQgYSBidW5jaCBvZiBlZGdlIGNhc2VzIG9uIHRoaXMgY29ybmVyLg0KDQpJ
biBwcmFjdGljZSB0aGUgIm1heF92Y3B1X3Blcl90ZCIgd2lsbCBuZXZlciBiZSBzbWFsbGVyIHRo
YW4gdGhlIG1heGltdW0gbG9naWNhbA0KQ1BVcyB0aGF0IEFMTCB0aGUgcGxhdGZvcm1zIHRoYXQg
dGhlIG1vZHVsZSBzdXBwb3J0cyBjYW4gcG9zc2libHkgaGF2ZS4gIEkgZ290DQp0aGlzIGZyb20g
dGhlIFREWCBtb2R1bGUgZ3V5cywgYW5kIEkgZG9uJ3QgdGhpbmsgdGhlcmUncyBhbnkgcmVhc29u
IGZvciB0aGUgVERYDQptb2R1bGUgdG8gYnJlYWsgdGhpcy4NCg0KSG93ZXZlciBmcm9tIG1vZHVs
ZSBBQkkncyBwZXJzcGVjdGl2ZSAoZnJvbSB0aGUgSlNPTiksIGl0IGNvdWxkIGJlIGFueSB2YWx1
ZSwgc28NCkkgdGhpbmsgd2Ugc2hvdWxkIGhhdmUgYSBzYW5pdHkgY2hlY2suICBJIHRoaW5rIHRo
aXMgaXMgYWxzbyBkaWZmZXJlbnQgZnJvbSB0aGUNCiJhcnJheSBzaXplIG9mIENQVUlEX0NPTkZJ
R3MiIEFCSSBicmVha2FnZSAoYXNzdW1pbmcgdGhpcyBpcyB3aGF0IHlvdSBtZWFudA0KInByb3Rl
Y3RpbmcgVERYIHN1cHBvcnRlZCBDUFVJRCBiaXRzIiBhYm92ZSkgc2luY2UgaXQgaXMgY3VycmVu
dGx5IGRvY3VtZW50ZWQgYXMNCjMyIGluIHRoZSBKU09OLg0KDQo=

