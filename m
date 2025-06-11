Return-Path: <kvm+bounces-49110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0503DAD60E9
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:16:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDFC51BC256D
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87CE4238D53;
	Wed, 11 Jun 2025 21:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nTAT4hDH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10871B4132;
	Wed, 11 Jun 2025 21:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749676585; cv=fail; b=AVSPLS09FxqkIeuVaMdi8OoEfmriM9KBBxQqDa+zD5pXZvg6DAFjhIU/3SJDe7ss8McitzkjgE4vxW9PKPSkm5c22AYKejQeBHuLaXjn5MeEH3w9RenNAObyfcuIOZ2+BDbTyZSvxLSCSAxhektZha1BnVHW8BVh0OfkqXuFP8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749676585; c=relaxed/simple;
	bh=nz6RTRbnE4R8wMx6zQo+y/4QCGAUCQvw286VJf69B40=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YJiVxNxfIAVBhd8vEmDq5ZmYqsqtXI/Vh7ER0iGYvbpoDr8YWcO2LiF1txioMF5j1jGmGQKzXGQZiknS+yg3MyOUY5Reg0rQHToGMNc4Hr7BjjjH2nLjK/PpyfttGXNQJiYZgJ9ER05SqYRJ1spRTvfkh3Va61FOPxU2Ykk1EgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nTAT4hDH; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749676584; x=1781212584;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nz6RTRbnE4R8wMx6zQo+y/4QCGAUCQvw286VJf69B40=;
  b=nTAT4hDHZwHD3KnaKvH9d/tyAsXYQoAE011IMNN8aSreNpdNp6jjYY7B
   BuXcku8Ev8KGLC5dYw+ja6vro66s4nA5pVn2aDuhzE7eHitakCUXmA9n/
   Ol9C3oO8Jtr5opioVzc78Dv/VKduKNJfwCUPNhQXyL402NlJOjZrAGdeR
   KNyOIwqnsvIUxa6hmmF51f2Kwt1qoV7qIy2/SFbKdh+JNpRKnqVoRlGIk
   6fLV+5IlEnjJrHjDasTt5O/q0OxTme/ABazW7oqQFYWqrqsO2/pWbGZPj
   erf/c7te7Cy6SzrBqwLKxWB2AtfzptV4IaqAHV2hMiOSdOf4uu6Gk/fMF
   w==;
X-CSE-ConnectionGUID: dKUljOfXQUK9GgwmzqyUWw==
X-CSE-MsgGUID: PjIvyUEVRYyu/90ywMUKTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="55632052"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="55632052"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 14:16:23 -0700
X-CSE-ConnectionGUID: aHt9Po8uS/uUpxgTndYP7Q==
X-CSE-MsgGUID: VB+laGoET9y75y/KJPzN5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="147207572"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 14:16:22 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 14:16:21 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 14:16:21 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.42) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 14:16:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fdNCOlNSlgg6X5s7/Bd/zyCTJfdoFlg4elP5hOsEGImKefA+Av2wneZFYlLsD6axS260xUJGlMaOrXq5Gz+QZfqpTvWaPsC1aYjoOGuThn4IZo6Mg46oFDPOHME9zkms42a5i4oTonPpE+HV/g1Es8FXjIIHVgPnkSZYq4MZzOvz8yXvyRUsnjMQCM8kpZnjoutzo+GJ7+S1SnRV5LtREzgYNX+qqyp/+3OBkYgqjpr9UINJqTebbCst1Kpr+p7/MLjNYtOV+EU1dIqgFjUmkCFAEs3XaG1n+off58TCWR6e7z+8aZQxQZKHnPsDg5USITrt6bCuoEdcyv4WPWdXqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nz6RTRbnE4R8wMx6zQo+y/4QCGAUCQvw286VJf69B40=;
 b=iGgWeHEp+ktJwJz0AtrnlPCtWkG4wD4q23oWzxOZJtcwf3EdndJwQDCM8UnXCzTV1nB62qSkI8ApUZUcn4EfxfyjxNZ54ADiiliPP4wPjfplGDyKEHqgXUJr90Ivr5GwaGrMvscv1szVeDNSfcMu5WgaSvdojRtlefniwShKNa6VybqvG+heeqcNNzlh3mnUd4YCf3nteaKk6Sds2cijuj6CGuUBQZG0bOv71rCxT3+MzZ0aEzUBA7K/8WUZ75t0kgl5GVSiZ5TnDfRuW4Q36T7qypLbj1QWQZAe9VpJ8tGAuimYGbMRgdsIYX0igSeBOIS08nvjBah43Fg7swVHSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7736.namprd11.prod.outlook.com (2603:10b6:8:f1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.31; Wed, 11 Jun
 2025 21:16:06 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 21:16:06 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for
 KVM_PRE_FAULT_MEMORY
Thread-Topic: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for
 KVM_PRE_FAULT_MEMORY
Thread-Index: AQHb2mYn9dWQDgvWTEqusObPtA6y57P+Q2SAgAADDACAABVmgIAADVSAgAAE/oCAAAkggA==
Date: Wed, 11 Jun 2025 21:16:05 +0000
Message-ID: <2ea853668cb6b3124d3a01bb610c6072cb4d57e6.camel@intel.com>
References: <20250611001018.2179964-1-xiaoyao.li@intel.com>
	 <aEnGjQE3AmPB3wxk@google.com>
	 <5fee2f3b-03de-442b-acaf-4591638c8bb5@redhat.com>
	 <aEnbDya7OOXdO85q@google.com>
	 <7de83a03f0071c79a63d5e143f1ab032fff1d867.camel@intel.com>
	 <aEnqbfih0gE4CDM-@google.com>
In-Reply-To: <aEnqbfih0gE4CDM-@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7736:EE_
x-ms-office365-filtering-correlation-id: 53f28e12-0fd7-49ff-c062-08dda92d2d9b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dGs3Wk4zT3JCQjZBZ241MExQd0VrTTJCaEJKNUUwRlY2SEhocmlIbGNWTGVj?=
 =?utf-8?B?L1V2dHRmcXRvNTAwUThvTlFEcHpLUzNDOU9CRmxBbllzdlZFYW9aWFEwb01D?=
 =?utf-8?B?RTZhMm1WbjhPVDZjS0gzUlAxYVAvNFJvNmJkSmZPbEtSeGlWbm9iTU5BSGgy?=
 =?utf-8?B?SDdjWGtndThNbmpWMDZWSysyd1JNb0NpYzN4RnF6M3BQYU9PZnd4N2l3RUty?=
 =?utf-8?B?U1N5TTZLci9KY0pUQWpLV3lsKzJnMjMvaFFvRGtyS2d5dy9RYW03akZUV3lR?=
 =?utf-8?B?L3BRaWpUb0hGVVNuYXpSV0tWVGUxcFgwS0cwZE9WQmRVaytqb3hTT2h0dnhm?=
 =?utf-8?B?UTNNTlNYcTFMUjl0ZytiY2QxdFRZY1htZ0hVQzFRdlB5UllBd2xQQTdtWjVm?=
 =?utf-8?B?R2lld3RsWE1MY3gweGJBTjBiTkNuaXlYejQ2ZzNzTXQwZTc0OEM4bVpBUVJ2?=
 =?utf-8?B?TkpLSENUZ1J3SzFBc1h3YWQ4U1pzY1F2T3MvVWprSjNyNUdPNmZZZ3VLS2Uy?=
 =?utf-8?B?WFFGblhCL1labGZaelhaaUozZDg2MTBIeUlBaEpxQndpZjJ3b2J2ZXlQU3NS?=
 =?utf-8?B?Y0VUQS9FVmxqZi9XWGdMVGhoZElsdlpLalcwdkhuZFMwbkpHUkV4cUw0TmNo?=
 =?utf-8?B?R0pVeXFzT1l5N1h1K2I4Q3BLQ0NCNGw2MHdtUWk3Nk1wZitjeGM3VlJsTDNP?=
 =?utf-8?B?L2thL2JtT0tGUzlEQm9ldE94Y3E2YmcyT2xieVk0cThGcHIxMUlrcWNsUnlj?=
 =?utf-8?B?NzZLTll5eXBIUXFOMWJvY0VWOGU4MFc2V2hUYTROWjJMbjRDcENPbzNIdFFM?=
 =?utf-8?B?ZzRHQTU3T2J3OURsNlh5NlBNWVpNajNFRG9wWm5qa2VMUHhmSnBzbFdNbWtm?=
 =?utf-8?B?Ukloa0FoSXBiOCtBdkdhcXFvUTFLT1k5cFllZ3JCM0FjazlzU3E3K2FtMDZF?=
 =?utf-8?B?UksvYWxqSkJkalZtaFpxN3Z6Q1pPTExFYjdhNUZTM2JlRitPendPYk5uaCtU?=
 =?utf-8?B?MUZsWTUweEltcnM5NFU3dHl6RmFVRVo4L3pJQ3ByV0VISzR4cXN3RFZzOWNs?=
 =?utf-8?B?d2UwclloRmtHTzFuUFZxVlA4T2IyYUgxZUtuL2tIRWtoV3NhSFpBQ2xpQlNy?=
 =?utf-8?B?QkdmalRHbmZmb1NoREVCdjVTdEZobk9Ga1krdmpHckhwTnAxS3ZWMjFXeVBW?=
 =?utf-8?B?bWgxeWZRT0JyY0FsVndmVXMzUjJjUUJRUzcxWmxmSE55OHF1YWJZMWRnc21z?=
 =?utf-8?B?aEpZS1ZiTTArUzBSSW12dkdUcWxzUElaRThDWmVJejE4b0JOUnl0bXRXcnd5?=
 =?utf-8?B?bzNrM0JGeVBSbnptazRvL3lCYVlnN1NRZXRkdCthNzVLK0dPcHl0aG1pMnFv?=
 =?utf-8?B?eW0zdDR4K0ZJbERUaWlLUEtaS1BtVGRWeEtjUHdIalFGQjhPRDR2bE1lRE1m?=
 =?utf-8?B?MXk4NFRuOTRuL1F2WDUxWFNiWituK29keW1UWC9Db0pTQlVlL3hoZzQ5NktW?=
 =?utf-8?B?SFhJL2tuS2lybUFvME4relpWNGdub2dGUk1JN2Ryd0JETXlqM2ZybjVlM2E0?=
 =?utf-8?B?eU1NaFdnc2RBdVRZYnpFSklaa2dkczN4MjZOem9PdU9iS2Y2V2J6eHdGV3cv?=
 =?utf-8?B?TkJhTFFJbVJuektQcitodEFzbGJmRlNoK0RMb1FXZWNqSGx0RnFzRjhSZ3E3?=
 =?utf-8?B?R1BxNytTRlJuSHB1emN3dXlJMHRTU3NKRHJHZms1RndkWEdMVk9Qd3hzY0Vj?=
 =?utf-8?B?MHJ0WmpKMXdUQ2graU5WYzNKWVZPeG5TNWw3U2FCVkd5eEEvdGZSWWlxcEE1?=
 =?utf-8?B?VlcvbzVUSzFUVTRKOGtlaitRcFhKN1g4YjJEbVk2K0RXYlA3YjZHb2xFOXVn?=
 =?utf-8?B?OGdGWWtmQ2locHdqSEdEUXp5QW9Wa01qRGkwTXdla1NHTVJZOTFPZFU5R0wv?=
 =?utf-8?B?Z3c0UHl5OElKWW1ZQWU4ZUZydldUaWo5SHpITnY3QjVZWWcycGY2d2tYcHQ4?=
 =?utf-8?Q?pF9YAW22mQJKaQJ3bC/2Ez4ZyiTOM4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlY1Yk5MU3JPdHMvc0ZRMjVwRnVQMUhBcUMrUFduM1BZNWh6Tk5CRmQyaHAz?=
 =?utf-8?B?eGNxaUdrWU05blAxelhZa0drU3BJVWNtN1N1TEk0VTFUZTJpeWRyZ0lEZ0ZY?=
 =?utf-8?B?NjdvRitIWG5XRC9McHZRSVloT0NTZFJweFFyTUVGWmNXb25FREh5N29qYjBT?=
 =?utf-8?B?K3RwZjRDSFFXY0Z0eUZhaE5zT2pQSFFQM3RVS3d5M1hwdjJzNVFVNUdSMlhM?=
 =?utf-8?B?UXlIdHg0SC9vazBoZGxFanVmQW5CUFZSUUl1aWxTM2Fsc2h1cis3ZTdmU29u?=
 =?utf-8?B?TEhValk1WkdUS0xmSHJsM0tZdEJGRmVwQ1g1dHNqUlQ1N0xFeHQxeHMxc3c2?=
 =?utf-8?B?OFFLbGw3ZHk0a1AzZ3dKY0VxeW9leWx1bXhRRTRUaXNUeTE2Sml5QVY0QjdL?=
 =?utf-8?B?VEVtQWlFTTF2TUk2ZHZMcFRGY3dwYzN5ZUxINkllRUZKWEtFT0Q4WVpKeW4x?=
 =?utf-8?B?bGNtWjcrSWZ4S2UvOWpaUXdqWlFQWW5kWW04dFZPN25OanZvb1Rib1N4RlRN?=
 =?utf-8?B?dkE1QUFTWUtrWW1NazZ1Zm5SYnhPNmRkNUZEU1BwblF6Q3NsTWhpOVEwTGpa?=
 =?utf-8?B?ak9xSjFvc0ZHZ2tpbExqVG1DeUpDb0REbDhDUWtOcFkxYUxNdy9KdUJnbXhI?=
 =?utf-8?B?VGZqWFlvaUhzQUk4a2wyenE2eFlkTk1TSWE5dStmM2hxcElLYm5GMFp4ODNx?=
 =?utf-8?B?OGxJWm5vMXpxVVg5M1ZQOEFsTGxJREFkeUZIUC9mSm5hYjB4bytMTFc0ODR4?=
 =?utf-8?B?NXBuMWZBQkxWNEphTnRxbnN0bUlDR3Avenh0aFkwcmIxOGgrdHlsMzQ0ekVt?=
 =?utf-8?B?OUY3RmsyUmpvazBydTlrajBwSlZIVE5DL3NEKzFtRTdKYlltamJ0YjEyZzZR?=
 =?utf-8?B?VWZTeFRMQ1ZLWCthRHJCam9FUnFUemhValh3d25FOGpxSUFmaGNIN0Y0MXcx?=
 =?utf-8?B?ZDIyQWZrN3RSSmZ1WUtvd3QrN3hhRGczSXEwUDB5a2ZobVJ1NS94RFhvNW9P?=
 =?utf-8?B?UlJtZC9lUnA2S2t3Rmd5QVM1SHlvMk5zY0ROcUcyN0Y0ekgxeVFzeXo2RmJp?=
 =?utf-8?B?VHpMRVh3bkpEazNZeFViajlMN3lJaGN3ei8xR0p5MlRvUkhJRitMWEVBU3Bn?=
 =?utf-8?B?UjZJYnVKV2NkTjBPQzRVSTV5ZjhlRlJlUVRKSVpNRDcwbUpHTHo0emZrVHM3?=
 =?utf-8?B?YzYySUtveTdIUFNqa3kvY1VYbFlaQmlpZDcrUWcrUEFYNnA3QXJoRjJhRXhU?=
 =?utf-8?B?a1g5Zzd3VVlaOUJVNDBKdjAwVEdBQXVSaXNINTJyUzNZbjEwWDA4Vk53Uko5?=
 =?utf-8?B?L1BzTU9tbDBadEdrS2orNjBjQzk0b3VMcVQvbHZrQW5kejUrQlBMZ1NjQjFM?=
 =?utf-8?B?b2NRby9pYlhzbFpOMG4vZ1VkbFVPOU9MMjhWZ3NPdkpDUkh4U2I2Nk10aXcr?=
 =?utf-8?B?SmRkTTFJdTNpVFFVcUdMNXV0d29tRHQ5ajF4aFdMOW8wRVd1T0d6MWo1S0V0?=
 =?utf-8?B?WDdhZVJvMzFoQldJZkpTeG1uL3R1YW1mcjhybUh1OVIycEZiMU9kcWg3SEkx?=
 =?utf-8?B?LzNIdVVHMUFndmtvblRTd2JIa1dNN2EvQ3dWODA2QzVjQVQ3QUdCZFY3dFNE?=
 =?utf-8?B?d1FQM3RKY1pER2tXU2pHK0dwRTVQSFcwa2VBL0pDSXlwUTdTRXBhMzFaY1dX?=
 =?utf-8?B?bVVVamJwNHV5ZUliRmN3Q3F2SGRROXMzeGhWQ05qNzFRNVRJTjdZMEhaVXZZ?=
 =?utf-8?B?cmVQUnA5NjlBcUNnSFZIMkdFeE55Mk83VDI0KzlVMlRrZ3dCVFFkV3B6VzB0?=
 =?utf-8?B?aVB3enp1WW1qckgxN0lYV2Y3T21vakVxRVZsWDJrRTZEcHVWN0dWcXpMQ3I1?=
 =?utf-8?B?QTlqY1dxdWpvOFBHNmUwMGIyZUg1WkNxUHJ3WFcvNTRKNisxVzl0V2NZbGhV?=
 =?utf-8?B?Q3A4S0ViN1QxQTVxYmtaSkdCM1Z0NGJtTjRYck41dWlUMDN2SkNFdGFSVEZS?=
 =?utf-8?B?bUxUR1l1VllsTzRzR002NHdUWVViUkdzbG5wMXNlcytIeWl6cDlzVFNNNTU2?=
 =?utf-8?B?UEdyQU1NZjMrbHNndzUyN3U4eFg5MWtBV1d0cDhYTlpPUDRqeVZCSTB3ZmtT?=
 =?utf-8?B?UGlPVU9NbWlHdGJHWDZtWW1Fb1V1S2hBQk1rK2Z6c2dPdjhiZFlZQ0FURUlm?=
 =?utf-8?Q?EJWB2EUwPsHkh93rb5naAU0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <735879C93E5C094E85380AC9D438F25A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f28e12-0fd7-49ff-c062-08dda92d2d9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2025 21:16:05.9840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dEYob53JFavhd4tSsEB4OL3hh5KHEGWDE/SRimLjK5PlUB10bxu9Ie3AYXRO178Y6Y5CFrS2SNOIO06Yy6WP35ghHjmeUgHrG74YBffw2KE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7736
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDEzOjQzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEZ1bmN0aW9uYWxseSwgcGFnZV9mYXVsdF9jYW5fYmVfZmFzdCgpIHNob3VsZCBw
cmV2ZW50ZWQgdGhpcyB3aXRoIHRoZQ0KPiA+IGNoZWNrwqBvZg0KPiA+IGt2bS0+YXJjaC5oYXNf
cHJpdmF0ZV9tZW0uDQo+IA0KPiBObz/CoCBJIHNlZSB0aGlzOg0KPiANCj4gCWlmIChrdm0tPmFy
Y2guaGFzX3ByaXZhdGVfbWVtICYmDQo+IAnCoMKgwqAgZmF1bHQtPmlzX3ByaXZhdGUgIT0ga3Zt
X21lbV9pc19wcml2YXRlKGt2bSwgZmF1bHQtPmdmbikpDQo+IAkJcmV0dXJuIGZhbHNlOw0KPiAN
Cj4gSS5lLiBhIHByaXZhdGUgZmF1bHQgY2FuIGJlIGZhc3QsIHNvIGxvbmcgYXMgdGhlIHBhZ2Ug
aXMgYWxyZWFkeSBpbiB0aGUNCj4gY29ycmVjdA0KPiBzaGFyZWQgdnMuIHByaXZhdGUgc3RhdGUu
wqAgSSBjYW4gaW1hZ2luZSB0aGF0IGl0J3MgaW1wb3NzaWJsZSBmb3IgVERYIHRvDQo+IGdlbmVy
YXRlDQo+IHByb3RlY3Rpb24gdmlvbGF0aW9ucywgYnV0IEkgdGhpbmsga3ZtX3RkcF9tbXVfZmFz
dF9wZl9nZXRfbGFzdF9zcHRlcCgpIGNvdWxkDQo+IGJlDQo+IHJlYWNoZWQgd2l0aCBhIG1pcnJv
ciByb290IGlmIGt2bV9hZF9lbmFibGVkPWZhbHNlLg0KPiANCj4gCWlmICghZmF1bHQtPnByZXNl
bnQpDQo+IAkJcmV0dXJuICFrdm1fYWRfZW5hYmxlZDsNCj4gDQo+IAkvKg0KPiAJICogTm90ZSwg
aW5zdHJ1Y3Rpb24gZmV0Y2hlcyBhbmQgd3JpdGVzIGFyZSBtdXR1YWxseSBleGNsdXNpdmUsDQo+
IGlnbm9yZQ0KPiAJICogdGhlICJleGVjIiBmbGFnLg0KPiAJICovDQo+IAlyZXR1cm4gZmF1bHQt
PndyaXRlOw0KDQpPaCwgaG93IGVtYmFycmFzc2luZy4gWWVzLCBJIG1pc3JlYWQgdGhlIGNvZGUs
IGJ1dCB0aGUgd2F5IGl0J3Mgd29ya2luZyBpcywgb2gNCm1hbi4uLg0KDQpURFggaXNuJ3Qgc2V0
dGluZyBQRkVSUl9XUklURV9NQVNLIG9yIFBGRVJSX1BSRVNFTlRfTUFTSyBpbiB0aGUgZXJyb3Jf
Y29kZQ0KcGFzc2VkIGludG8gdGhlIGZhdWx0IGhhbmRsZXIuIFNvIHBhZ2VfZmF1bHRfY2FuX2Jl
X2Zhc3QoKSBzaG91bGQgcmV0dXJuIGZhbHNlDQpmb3IgdGhhdCByZWFzb24gZm9yIHByaXZhdGUv
bWlycm9yIGZhdWx0cy4NCg==

