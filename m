Return-Path: <kvm+bounces-67456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 39449D05B3C
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 19:58:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2107730ACE2C
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 18:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A28D7322B61;
	Thu,  8 Jan 2026 18:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MvUqpqj5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9263203B5;
	Thu,  8 Jan 2026 18:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767897611; cv=fail; b=bXe+pmP636gCRwJUhbaE8Z/0ckIgvfiCa60tCVs3EEvevKScQ9SHsf7MdbUGE2Nf/sFmo71D0EzNtCFXEUve+YifXj58uqVUWCqHMWG2yUSzHxk+N0leuDxfXDN/fGVFk6ekD5qymtEAvBapPaqz3yTNGwoz/zLl0+bakGZAwWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767897611; c=relaxed/simple;
	bh=2u/3b735ZOYW1ImP62103D/2T7WgKoSe8p0O6+JEPrk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MnHJ0xgxZXJRvp37fjvc3HbzeayMkIPYDu+8q5HC4xAgo9qjMNXX9RoiW2VGC2eFDcEwcv9a7zQoMc87Fse6uymyEDLWL5OxKC5iS5+9uydz+3GwnJ42omklg4pTmVI7ChoEoWkqk1FNc1ZJ5ZhzQPAw6n1+9efwlzGqDp9/hRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MvUqpqj5; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767897602; x=1799433602;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2u/3b735ZOYW1ImP62103D/2T7WgKoSe8p0O6+JEPrk=;
  b=MvUqpqj5+kxEVpL/rr6g1Jn0+sqhaspDQi3AWmTjdVHGPNjdgD0F5nLn
   rsXY8r4QGmxnDONGAusTEYnaFVvWkNEjdLJsuVlmmLztI334DLs+63a7F
   e5szvDzzdW+1oRN4NUJMBcM9kyuN4Dntjclypi7ugxAYeGFIc9zwc/Bu8
   fMJwU5zb8+aoE8JJJ0UObLr5w+5LXV0I0Lo9zVdxy/htzkvxoHE+esOfg
   D7WIt5yGeLEWFAWLN5hm9uXT6tmagJ4yBQXJkFmfByg9ERUPngSkcgLTB
   1UuspoYpBvZcaa2Hki4nCoZ8X+U5ldR6jRRR1rao9kW/azr2jyZISOiJD
   Q==;
X-CSE-ConnectionGUID: +fJTHxpsQ6yaCeuYK471dg==
X-CSE-MsgGUID: zJkP0BSEQICOjqX3q89yCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="72920211"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="72920211"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 10:39:54 -0800
X-CSE-ConnectionGUID: uBeFf3uXQrmmAuWmg5MmdA==
X-CSE-MsgGUID: VqHsmf1SSlSRgAJg5l5cFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="203298545"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 10:39:54 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 10:39:53 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 8 Jan 2026 10:39:53 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.18) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 10:39:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uy7aEopQzgdTDXv/Ue4m33h6mZxgB3O6Wptxvoc5nEgJWx807m4KurjBA4D7e2twYccXWstcekuuJHivurmJjv9yIXkEiSt174L7yQVK7rjvDPqyZvJNfFqqGTpF2580AGOOj4jjj4PZQSdRiTXQwsableEOMF7zzjwTRzTQi9eoEpg4HTuDe2PyJjkvzMpygoC67O8u5M3h/umLB8Iw71YPdtg+HsFNgcg9jQxZpVBhNMNLUCWm2PE6YIIFBNpY/IO/jjWR+NfBVUZDwzq9fazfl01AoKAuuYbWeEUvyqq80XuYVlI9QVvBVilJLErdafUuIWX2JlNZrXCPZnoxRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2u/3b735ZOYW1ImP62103D/2T7WgKoSe8p0O6+JEPrk=;
 b=b10aEsfyMwhvuM5MX5QoZgNlsI0NI6tjzVTZD2XkF8eLHdGCeYUJEsWFpI93g6fwgZVIQo2M1y4827gdKL1AvjuagF0Q7dWaUvpWcaPP60zRo9LTJHrdtlV4s7wne3VJiyoMeoPuHAj0zSPfA4Nh3S0pKiC7U6eZ/d1THGX1Jz7Rjvo7wZpmAZSBTT9ppzWgpczMNSM4Nz2xOmhGRHLQPTLHWZ0q3qy+xo+7te53UZsOixJWP7dtam5zvvOp5R8WZwBjeuzSr8wO+AGAwHghm+Twp27jO/eXel2BGikDAUbS7ptd9lV+VkH5UaJehGqNGCpcGJAqKidAiSRJSiDL7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by PH7PR11MB6331.namprd11.prod.outlook.com (2603:10b6:510:1fd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Thu, 8 Jan
 2026 18:39:51 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%4]) with mapi id 15.20.9499.003; Thu, 8 Jan 2026
 18:39:51 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "kas@kernel.org" <kas@kernel.org>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [PATCH 2/2] x86/virt/tdx: Print TDX module version during init
Thread-Topic: [PATCH 2/2] x86/virt/tdx: Print TDX module version during init
Thread-Index: AQHcgDYyz4PdRgNJ+E2Gw9ZTxvuIEbVIGL+AgACDLAA=
Date: Thu, 8 Jan 2026 18:39:50 +0000
Message-ID: <261b253ff5bcf593adbddbc34f7a5b4befaa4c21.camel@intel.com>
References: <20260107-tdx_print_module_version-v1-0-822baa56762d@intel.com>
	 <20260107-tdx_print_module_version-v1-2-822baa56762d@intel.com>
	 <orjok4cskwinwuuqkyovqu7tkfygdkiqlxc2sbdvi2jicpygi4@dgg76ojxkhak>
In-Reply-To: <orjok4cskwinwuuqkyovqu7tkfygdkiqlxc2sbdvi2jicpygi4@dgg76ojxkhak>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|PH7PR11MB6331:EE_
x-ms-office365-filtering-correlation-id: caa2d341-a9ce-4e60-28fc-08de4ee54ed5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?M2syaUVDRCtrUWkxOFZZZkphL0lMdmVaMjA3SUFwNkxXM2xoV3RtWHU4ekpr?=
 =?utf-8?B?eHc5aEZWVkNVSkgzbzFkN3dBaEZnbnlJMk9vQ3VVUklyU1V0UEMvL294S1Bx?=
 =?utf-8?B?L0MyYXBUSnE4Nk96WjRMNG5xemRWWGZOK0Q4cnRzTlpzZkljcVJ5Sk95eG41?=
 =?utf-8?B?YWFJTlo1V0J4K2hvM3hPcGZIaklvNGpRMkJZUm5lR1FtanZuWE4rODdFa2xH?=
 =?utf-8?B?djlLcDMxMk1hNUJNRG9zMHVRby82eElyeEhHbWJuWXhKYzFQdm5Sckd0YlJa?=
 =?utf-8?B?MllHeGZoYlpyYjl6TklxbkVKVHAxc09NU25jYUU0eUhvempXK1I2K0FGMk43?=
 =?utf-8?B?eDBMZStwZzNDOGdWU1c3Vk1tWW8zLzdJeDA0RTV2aHFhYWRlRWcwZnpDSERQ?=
 =?utf-8?B?L2s2VWJlU044d3NOTVp3TXZNKzIyVktnRUhwbjRyMWVVcmpyeHZVNGZBN3Fv?=
 =?utf-8?B?ZzhDd3Zpd0ovM1FZSWJON3Z5WXI2UFhncGM1SFI5dHZKeUxKK2FzaUg1OXpI?=
 =?utf-8?B?Q1djU0tVK0VXb2ZCQlJ5U1hrbnVZdERVNnRUQ25VREphRVIrcU9QcERVa0J6?=
 =?utf-8?B?VDRCeUZQbTlxN1VwZG5sRFkrcGkyNFNpaDZZbEdOZm1zSGRkU2dLMTYyZWM0?=
 =?utf-8?B?a1dvWnNwdDJYbFlOQjM2b2V0cGQ2UDQrZkJPNllZVmQxUDZ6TWlGN0RuY1pG?=
 =?utf-8?B?RDNDN3owOXhqRUVuSUgySnFnL0pQM2VPMlArQTVnYXZZbVJCTzk2UFRQS0tM?=
 =?utf-8?B?MFpCbXErTGpNQTVxdWV0R2NGZ2YxVjF2OW5OSXFmaG9qNWloWSs5STVHN0lP?=
 =?utf-8?B?UU9abDdWNnVscVdFdWQvV0RhZldDT0hFTnVtYjBDbG81RERUQTQzWk0zSkgy?=
 =?utf-8?B?L20ra0lVN29FRjh5RFk1amJOTjd5Vk9DTFFaTGFjRjJYakRiVlVrZk82bkx0?=
 =?utf-8?B?NFVwazJNeGdWT0g5RXBoOUtLVlZrYXR3VUIva04zUWJGeGxHSFQ1aDh2cEMv?=
 =?utf-8?B?YytqREhkdWdrbkQ0NEY0Qk04K21mWHRjMGwxMWJ6SjhrU3RCblZhL0hSaUtF?=
 =?utf-8?B?MmpoaFBuRC8xbExONnZqL1M3N2daOWMwOElyNUE0WTBHOUo2NmpBQzRnR3do?=
 =?utf-8?B?N3c4RHFSQ2F3VEZJMFFUQjZud05KVTBkLysrSEZXRExVY2t2QVdRK0Rtb3l1?=
 =?utf-8?B?M3YxRXJNVFhNZUU2aC9jR0NtTkx1RTdlanQwbEQ2d0VvbGVOTTB5NDZlZmV0?=
 =?utf-8?B?MUhKNzhNamNHSk91Nm5jTVIvdE9tRnB1TU56cHBIb2tybFdhWHhtTkN2NFhR?=
 =?utf-8?B?Mk0wUTY3bDdvSW1WQy92QlJkOXdSc0FpcWZLa1RleVZOQmRJMTVtRzRaUG9E?=
 =?utf-8?B?cHdLOVRIcC85WXYxZ0d3K1FpbjFXN0IvZkxRWUJuMUIvc202bnU1RUtHRFdT?=
 =?utf-8?B?dTB3K0lKMjJZUE9KbHRhNFlKbTFKaVVkSHFvNzV1TzJ6VDl0ZStpSDFrVWxJ?=
 =?utf-8?B?ZVhQUCsxWk5CUjBweEthdmtOa3prUWhJZTZENHdSbTJBQmg3eGdlWUh6M29r?=
 =?utf-8?B?RGNHVGlucTBLMHNGdTQwZ1FSczVsWGV1OFNjSVZHSHFxQUVETmZKeVhPTGYz?=
 =?utf-8?B?cFE3VDFvNjYxdG05czBIQTRnRW1sdjVMdStNQXRqbGgvbzFsRHFwa0M4YzY2?=
 =?utf-8?B?aGltRk0zbWdFZDVOZnRpemxhTFVYSlBlZXZGTGFsL3RvRitUeTZxZjN2Vm1Z?=
 =?utf-8?B?SXZSRGpENFpSLzlkZ1N2NjBncGpyaUtzdDFVb1lmV1ZrWC9vTEFSUDIrLzZ5?=
 =?utf-8?B?MEZ6QTVoa3U1RmVDREkrQTIvYUE3ME5Ud2syK0twSEZzRkpQWXRFMldXczQv?=
 =?utf-8?B?a0JPOENFdlB3aHA0NWNKcnhOVlZUSnVJcGN1NklGWEJ6N0dET01CbE10dXJ4?=
 =?utf-8?B?bUlJRGdKWm1HSzJjaHlIZVo3b3Fua2dhY1BUMGN4djNGY3lleDhPaTRPSm0w?=
 =?utf-8?B?WGcxMEFZaHpDYVZzMHFhd1RvZFNVRFNlWWpRcnU0ZEpvWStTU1lqU2o1cFFH?=
 =?utf-8?Q?dPYmOv?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFpFeXJuUXQ3QjZWNElnR3VMUVBWTExZRVRJdG5XVWV0SXlLTzVSa0prclZi?=
 =?utf-8?B?R09sY1NjZm95ZkwwOGlXY3F5R2tuZHBxRVAzaUhCV0t6bDQvTjY4d3dRWDhm?=
 =?utf-8?B?cTBLOStFemhLU0xJdkVmQnQ4T0lHRllZYVI4R0lWTHBNUmpERmJ5cDBuTE1H?=
 =?utf-8?B?OEcyQVV4RGRtUEZYcys2NXRtNUFLb0owZ1pTSk1zZm1xZDJBcVhRQ3dyWG1Y?=
 =?utf-8?B?K1VCdVdGenVreHVsMkNIMzVZN2JQYU9EUXpORlFsRmhicmtxTk9ac2VmYkMv?=
 =?utf-8?B?dHI4TllBMHZJYjFIdkdOa3lhRk50YnU3VVVLVVJKTjBuTm5jNDBmSS9TZUJU?=
 =?utf-8?B?RldITmRld1NEemRUN2lJUVhQT2FmSitZbVgrTUg3NXpBSVZDVGFuYml3dmh1?=
 =?utf-8?B?RFhVcGwwUjRpbVVNc0R2M241TTg2YkFhdW53UFN4S3UrbkF3UEdlaGhVWUlx?=
 =?utf-8?B?d0FjR1VlNlBiUlFnSFRrQ3cxYUJ0Q3MwNGVNanV0Sm5xV1RuYXE3RUhOQnFN?=
 =?utf-8?B?Q1VaRDZ4SWJtaHJUaXIyRTJmN2kwcU9rdmVQek1SWUJROWhKdXZ5UmFCVDhx?=
 =?utf-8?B?UjcwdzFkVXB4Z1plT0hoQkFZbHRLbXcvV3VDRnphaWVZZzNxRUZZS0duTWZJ?=
 =?utf-8?B?WnJ2eENOT25Ebitnbk9FUWJ1dUZRNTdYY0t5c1VmSy9CUWVEZ21LZlR3MlFn?=
 =?utf-8?B?V21WSU91NGxZYlphMTExcnhNMzlnUWd3MkFYcG5icXNveGVrUmpOa3RPY0s5?=
 =?utf-8?B?TXJOR0tiaVB5a3ZTY1NOSUFDZ0M1TU9VMWNac3RTTzIrNTJ0Tk9zU3FSaEgw?=
 =?utf-8?B?eXZ4M0c4TmwxYXp1S3QvK0RJMCtwWWNLcFZlRklnRjdTNnFqUGJKV29TV1Rj?=
 =?utf-8?B?N29ObUcyOTBOOWFTQVJlbFRhU0RBN29id2x1UVYzeno2T3FXbzZBUkw5QUdT?=
 =?utf-8?B?bFdlZklaTFlCU00zN212bWZaVEUzdmdGVHRJeCtPRGxQQmRhQWZkQVV1cExp?=
 =?utf-8?B?RTg4SzN0ZFRaVk1NZXIwNWJoQTd3MnovZ0xmVUIzeVB3VkZPWWpVdGpIWm9U?=
 =?utf-8?B?bU1xUEcyUVFieHlWL1JVQ3IzYVN5OHFVOWVPeW4zVjBOSmhiVHlicGVZY3R5?=
 =?utf-8?B?L3J6bERCYkNIMEYwcWk2d1FNVHEyUjIyM3F1RUhhRzFjWWpZeXgydFlVNEs4?=
 =?utf-8?B?VlZmbnZvRDJza3RNa09wK3RYeE1NV08yT2F6UGc0L3dPOWtOMENKNzE4K3hN?=
 =?utf-8?B?YWFFb0F5ak5hRkxLTHYwczgxbWtic3VEcHJyRjdBbHU5cFZzWGpsZWd4SGVx?=
 =?utf-8?B?YnphdHVSR3Y2SThlVC9RNkIyZUVhOXJoWG95ZkdOamt4SWhwN012WUxoSFlT?=
 =?utf-8?B?eHhRRWJlVlNpMHVWeVphQlFydTJjN1dhd2E5VFhUYWdwd1JrU2NCeWpOTjcx?=
 =?utf-8?B?Tk1aNmlLK1p6Mm9qckZzVUlsSXZUOUt1djJnN2lvak5Ja3hlcmdDRm0xSTI5?=
 =?utf-8?B?OE5TMEllRVRINDVEcHVzRFVxZk1jbCtYL00rODVxRUdaRk1WeGUyWlN0anAz?=
 =?utf-8?B?Z1NUelk0WFRmRHAvdFNzbXcvdjBMOWI0N0ZaZTNnM1pZVDBFbzBjVENmaXFF?=
 =?utf-8?B?MGEvTkorZVdhWVZjQThsdnRCaklaS0djc1J6c3p3MndUeWtlYitmZ2xVR2VF?=
 =?utf-8?B?Y3YzaWk0Y1RmaW5vSERDRGZDeC9tb01FbTArUEViMzBWeGVid2xUUzlINEpW?=
 =?utf-8?B?TEhaUXNMV280bFhKMnhzZE1rcmZRVUN5eTJ5ejNOOFhQV2REdEdWL1oyaHU4?=
 =?utf-8?B?WGhyQnpselYrTmRxcW9GWFRQNzVVT3B1WkVqMHdjTzhIT1BueU1rNmxSeGxP?=
 =?utf-8?B?b0RBOVRaT0Y2RGtvcHZHU1gzUDE0bC94MU9BVGRtVWYwQ2VOaENLVHFobjc4?=
 =?utf-8?B?a1pRTk9lWmVKQWdWeGI3V0J6UlM5SDVmdVdYcnd3Mkl3ZzAzcVdsNjZjSlNl?=
 =?utf-8?B?L1A0RWVTYzlhcWl2RUpETXZaUGVWclhkR1dBaDlmYlEzT2JuS1c2N3FER20r?=
 =?utf-8?B?R0dhTkQ2MUc5S08rSmdDOFFicCtnTUFjOTlRM1dPdmZOL2pCWmp0UjJ5T3Nq?=
 =?utf-8?B?U1pLQmN1VkVuK0xZbyt0SjNBSWVVR2dMYlUzMm1zQ25adi9VcFk4MmluUVdm?=
 =?utf-8?B?T1ZuUmVoZmtSS29vRzg3N3YweTB4eWJQYVlhQlRHeWZRdmhLUE5nVTNzemxq?=
 =?utf-8?B?NlN5UDJ5cUhVVXc5bmVaUGZVM3p1b1I5d29CVkhwSkdTUitEcVJ2UDZnSUlw?=
 =?utf-8?B?VEZlN0I3Y1hkRUVnaStMTS90U2U3cFRYcFQ0V3MvMERYYUx4MlA1Kys5SUlD?=
 =?utf-8?Q?x9Uerm54IubpZY1s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DB90AD683A7FF42B29DF3985FAA052B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caa2d341-a9ce-4e60-28fc-08de4ee54ed5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 18:39:50.9498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8KnXxd9qr0eJ/DfkLQzQMjykUjyp52Kb22FVF+Bn6b8V7iqFrSjZAZ8bJq8kJ+H1qxDYXTSP7TcEWjOVSOSSb5F5+Bl0yn8DqQ714CIg544=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6331
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI2LTAxLTA4IGF0IDEwOjUwICswMDAwLCBLaXJ5bCBTaHV0c2VtYXUgd3JvdGU6
DQo+IE9uIFdlZCwgSmFuIDA3LCAyMDI2IGF0IDA1OjMxOjI5UE0gLTA3MDAsIFZpc2hhbCBWZXJt
YSB3cm90ZToNCj4gPiBJdCBpcyB1c2VmdWwgdG8gcHJpbnQgdGhlIFREWCBtb2R1bGUgdmVyc2lv
biBpbiBkbWVzZyBsb2dzLiBUaGlzIGFsbG93cw0KPiA+IGZvciBhIHF1aWNrIHNwb3QgY2hlY2sg
Zm9yIHdoZXRoZXIgdGhlIGNvcnJlY3QvZXhwZWN0ZWQgVERYIG1vZHVsZSBpcw0KPiA+IGJlaW5n
IGxvYWRlZCwgYW5kIGFsc28gY3JlYXRlcyBhIHJlY29yZCBmb3IgYW55IGZ1dHVyZSBwcm9ibGVt
cyBiZWluZw0KPiA+IGludmVzdGlnYXRlZC4gVGhpcyB3YXMgYWxzbyByZXF1ZXN0ZWQgaW4gWzFd
Lg0KPiA+IA0KPiA+IEluY2x1ZGUgdGhlIHZlcnNpb24gaW4gdGhlIGxvZyBtZXNzYWdlcyBkdXJp
bmcgaW5pdCwgZS5nLjoNCj4gPiANCj4gPiDCoCB2aXJ0L3RkeDogVERYIG1vZHVsZSB2ZXJzaW9u
OiAxLjUuMjQNCj4gPiDCoCB2aXJ0L3RkeDogMTAzNDIyMCBLQiBhbGxvY2F0ZWQgZm9yIFBBTVQN
Cj4gPiDCoCB2aXJ0L3RkeDogbW9kdWxlIGluaXRpYWxpemVkDQo+ID4gDQo+ID4gLi5mb2xsb3dl
ZCBieSByZW1haW5pbmcgVERYIGluaXRpYWxpemF0aW9uIG1lc3NhZ2VzIChvciBlcnJvcnMpLg0K
PiA+IA0KPiA+IFByaW50IHRoZSB2ZXJzaW9uIGVhcmx5IGluIGluaXRfdGR4X21vZHVsZSgpLCBy
aWdodCBhZnRlciB0aGUgZ2xvYmFsDQo+ID4gbWV0YWRhdGEgaXMgcmVhZCwgd2hpY2ggbWFrZXMg
aXQgYXZhaWxhYmxlIGV2ZW4gaWYgdGhlcmUgYXJlIHN1YnNlcXVlbnQNCj4gPiBpbml0aWFsaXph
dGlvbiBmYWlsdXJlcy4NCj4gDQo+IE9uZSB0aGluZyB0byBub3RlIHRoYXQgaWYgbWV0YWRhdGEg
cmVhZCBmYWlscywgd2Ugd2lsbCBub3QgZ2V0IHRoZXJlLg0KPiANCj4gVGhlIGRhaXN5IGNoYWlu
aW5nIHdlIHVzZSBmb3IgbWV0YWRhdGEgcmVhZCBtYWtlcyBpdCBmcmFnaWxlLiBTb21lDQo+IG1l
dGFkYXRhIGZpZWxkcyBhcmUgdmVyc2lvbi9mZWF0dXJlIGRlcGVuZGFudCwgbGlrZSB5b3UgY2Fu
IHNlZSBpbiBEUEFNVA0KPiBjYXNlLg0KPiANCj4gSXQgY2FuIGJlIHVzZWZ1bCB0byBkdW1wIHZl
cnNpb24gaW5mb3JtYXRpb24sIGV2ZW4gaWYgZ2V0X3RkeF9zeXNfaW5mbygpDQo+IGZhaWxzLiBW
ZXJzaW9uIGluZm8gaXMgbGlrZWx5IHRvIGJlIHZhbGlkIG9uIGZhaWx1cmUuDQoNCkdvb2QgcG9p
bnQsIG1heWJlIHNvbWV0aGluZyBsaWtlIHRoaXMgdG8gcHJpbnQgaXQgYXMgc29vbiBhcyBpdCBp
cw0KcmV0cmlldmVkPw0KDQotLS0zPC0tLQ0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92
bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQppbmRleCBmYmEwMGRk
YzExZjEuLjVjZTRlYmU5OTc3NCAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90
ZHguYw0KKysrIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQpAQCAtMTA4NCwxMSArMTA4
NCw2IEBAIHN0YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQpDQogICAgICAgIGlmIChyZXQp
DQogICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCiANCi0gICAgICAgcHJfaW5mbygiTW9kdWxl
IHZlcnNpb246ICV1LiV1LiUwMnVcbiIsDQotICAgICAgICAgICAgICAgdGR4X3N5c2luZm8udmVy
c2lvbi5tYWpvcl92ZXJzaW9uLA0KLSAgICAgICAgICAgICAgIHRkeF9zeXNpbmZvLnZlcnNpb24u
bWlub3JfdmVyc2lvbiwNCi0gICAgICAgICAgICAgICB0ZHhfc3lzaW5mby52ZXJzaW9uLnVwZGF0
ZV92ZXJzaW9uKTsNCi0NCiAgICAgICAgLyogQ2hlY2sgd2hldGhlciB0aGUga2VybmVsIGNhbiBz
dXBwb3J0IHRoaXMgbW9kdWxlICovDQogICAgICAgIHJldCA9IGNoZWNrX2ZlYXR1cmVzKCZ0ZHhf
c3lzaW5mbyk7DQogICAgICAgIGlmIChyZXQpDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92
bXgvdGR4L3RkeF9nbG9iYWxfbWV0YWRhdGEuYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHhf
Z2xvYmFsX21ldGFkYXRhLmMNCmluZGV4IDA0NTQxMjQ4MDNmMy4uNGM5OTE3YTljMmMzIDEwMDY0
NA0KLS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeF9nbG9iYWxfbWV0YWRhdGEuYw0KKysr
IGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeF9nbG9iYWxfbWV0YWRhdGEuYw0KQEAgLTEwNSw2
ICsxMDUsMTIgQEAgc3RhdGljIGludCBnZXRfdGR4X3N5c19pbmZvKHN0cnVjdCB0ZHhfc3lzX2lu
Zm8gKnN5c2luZm8pDQogICAgICAgIGludCByZXQgPSAwOw0KIA0KICAgICAgICByZXQgPSByZXQg
PzogZ2V0X3RkeF9zeXNfaW5mb192ZXJzaW9uKCZzeXNpbmZvLT52ZXJzaW9uKTsNCisNCisgICAg
ICAgcHJfaW5mbygiTW9kdWxlIHZlcnNpb246ICV1LiV1LiUwMnVcbiIsDQorICAgICAgICAgICAg
ICAgc3lzaW5mby0+dmVyc2lvbi5tYWpvcl92ZXJzaW9uLA0KKyAgICAgICAgICAgICAgIHN5c2lu
Zm8tPnZlcnNpb24ubWlub3JfdmVyc2lvbiwNCisgICAgICAgICAgICAgICBzeXNpbmZvLT52ZXJz
aW9uLnVwZGF0ZV92ZXJzaW9uKTsNCisNCiAgICAgICAgcmV0ID0gcmV0ID86IGdldF90ZHhfc3lz
X2luZm9fZmVhdHVyZXMoJnN5c2luZm8tPmZlYXR1cmVzKTsNCiAgICAgICAgcmV0ID0gcmV0ID86
IGdldF90ZHhfc3lzX2luZm9fdGRtcigmc3lzaW5mby0+dGRtcik7DQogICAgICAgIHJldCA9IHJl
dCA/OiBnZXRfdGR4X3N5c19pbmZvX3RkX2N0cmwoJnN5c2luZm8tPnRkX2N0cmwpOw0KDQo=

