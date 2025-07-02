Return-Path: <kvm+bounces-51271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56CB9AF0E49
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 10:44:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BB20189F5B3
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 08:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929CB23BD01;
	Wed,  2 Jul 2025 08:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F19j7a5z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE7C1FDA89;
	Wed,  2 Jul 2025 08:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751445885; cv=fail; b=AWg6lf/iQT++3EB3gbed9VG053l98dncZL2aqLFLwd7Q/xClyjOsOZ0wmCx7EoBnvvZuy0/UmAN0HnA8G6/tJY6J3asCxsvBr0tR7b9Ekz8Ae5a9yM11VSeSUK9nxqm0nAPUidSwwW5L/CECix37hyWT1PpweBTxph7AWqrEpUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751445885; c=relaxed/simple;
	bh=WpFyIa6lmPMf1nQtxuuVrTfYRfQCKzX80DdzpMCwv/Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UfWCPQ6vS1zxTpLH2HThPdtpveNEuD8qfOks9SZ7vD+hm19ey1LoSLe8jUbly73n79GbcPTyPU/h75HPSCMjkftWnwnvm4sZAkbJrCxCXeU2RBvRNwZd8Gj2mjv6uhzw09M0hoip/R/jElzQW2oatNytFolvrh4qahN7cblVJJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F19j7a5z; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751445884; x=1782981884;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WpFyIa6lmPMf1nQtxuuVrTfYRfQCKzX80DdzpMCwv/Q=;
  b=F19j7a5zUApj2KryzkKtIdKSomMsc18sylsYlOh4O0XCb2iy3hP4L3Zb
   kDzRV1IRpatfJq++2aVStQUlgzeYP7wDA+MKcf6d3WzbOVlTmLktJhj/r
   bTeNULNQmxGFJk2zkbkntrgQchvgHYJ989rzI2LvJ4JTMMqDn9iNtA2A2
   J1hahHLTEA31l2omm0NvR9/qJ13u0P7BMcnhNiTh4K753XbLapQSK/V+B
   dRMtnGo6ZGowe0NIPJ4iQztRBAn79yx+B321yeZQ06hTpeHKsACJUqmJc
   8ha/faNv0g8BO9wq+ZkZIZmDKNDzxO/Ztt22x+EjOmLi7790XvPA/LYZi
   A==;
X-CSE-ConnectionGUID: GmnnsPhUR0WTnucUsw73Mg==
X-CSE-MsgGUID: //hJ3IBvQR6omL9vY6vg0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="65186865"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="65186865"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 01:44:44 -0700
X-CSE-ConnectionGUID: m0YMwLiTQkmrL9QELjQHTw==
X-CSE-MsgGUID: GfNHmp2eSbajysZSJv9c+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="159721412"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 01:44:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 01:44:43 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 01:44:43 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 01:44:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M3gXD+FJY85NZAYbmZkKFzeDm00dXVrUt8CQUpwDaJw3sWv8ZGiN4NehuozkSrM6jdX8hiCEdxqRXSdxQ4Q1mrAS5wJzfCNgw08ROqu+A2sU4NGs1C7fpnMlrlYAzWd4ymFillLUrnCt5fiQ0r0lA73to6sG7hvsxwKh1LPEYsVsgPJqpQh/y4CKhm+qAD4agsnIt25j3Gmz7IWms5fmuWUKyD6igYpoiUuT5R30I3BvTrJCOHoojoCBgXLzJrS9fcD8ipHAAGAcZ+eGuU1f0cz7nSzDh8DFNRH8OII3W4Vxrb9LmgRZIto6KTSFCO88U/xg1/ypPutGiDjQGv5A+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WpFyIa6lmPMf1nQtxuuVrTfYRfQCKzX80DdzpMCwv/Q=;
 b=uModXnhd+N/CUsvNKhNkd7dD2wDzj8i46EaJze3tQfhZcVgP8Iz8YHCpWRRcKMfSkH6vUMWZmAGhnkp1LGFAtjlJ6svwr9lD5YlUqpwnqoTibr4vBr6UGlajjBpX+Req15WfakCyUar4aSWmCENhBHk7S7WSP8hAybp/+Z/V0g69DW0V9pOgJUr4/Kq2y5qVt17qVh9IrDyGB7j2tOV3M2/nSTKqrFGzXH5zOFSxhCL60OGqBj6z48UITMPMRkWVMb+sE78FnMJlRgcVtLwAvM2KJmUZ4HJkE3ijvSm0WiB0XfzACM109Wu86NBq3/MA9Nm1gEoq32JqNcZ7PiEIRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA1PR11MB7341.namprd11.prod.outlook.com (2603:10b6:208:426::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.29; Wed, 2 Jul
 2025 08:43:57 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8880.029; Wed, 2 Jul 2025
 08:43:57 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "Williams,
 Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 3/6] x86/kexec: Disable kexec/kdump on platforms with
 TDX partial write erratum
Thread-Topic: [PATCH v3 3/6] x86/kexec: Disable kexec/kdump on platforms with
 TDX partial write erratum
Thread-Index: AQHb5ob0RE0br3XqzESRONxJOkYqpLQeiMMAgAAFEQA=
Date: Wed, 2 Jul 2025 08:43:57 +0000
Message-ID: <01d96257ed48bba14d9d0f786ea90f11eb9e7c7a.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <412a62c52449182e392ab359dabd3328eae72990.1750934177.git.kai.huang@intel.com>
	 <aGTtCml5ycfoMUJc@intel.com>
In-Reply-To: <aGTtCml5ycfoMUJc@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA1PR11MB7341:EE_
x-ms-office365-filtering-correlation-id: 642bd3e5-2d11-4b02-aa0e-08ddb94495b1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UEh3ejBQTHZUL0xyKzZiMk4wNkMwRFJOSkhHR1NKUzdjMEtkYmlaOXhLMzV2?=
 =?utf-8?B?R2JsYi8wYisraStEYUdDVlRHZ1piNjNkdHY2bGFpNXRUNS9oRVpoekQxUDZl?=
 =?utf-8?B?bkcvUkszNXdBMExXZm90Q1JtQksxekxUV3RueVM3Ni9lZzlPZEtieTZFNTRu?=
 =?utf-8?B?K0lQbm5YQ0txUWpvUGtMeHQrUUgrTWY0ZmxtdnRIb2tVVjNpb1pvMEhjMkdX?=
 =?utf-8?B?bkE3c2M1UE1tU0ovZmpOYnkvVFlzU3drVTJzSjhBdmtVMk92MEVUeUNVQzMr?=
 =?utf-8?B?SkZUeUw4N1RmQ0xFdVB4WHlTRG50dGVnVTBzUDBrRHVYRWg3YTZJbTBLQ1Bp?=
 =?utf-8?B?c05vM05UeFZWOCtONTVzK2tFQ3RBem5KbGdBMXZQN1hPNnBsbmZUVTE2T0NF?=
 =?utf-8?B?TVA2ZG5VL3ZqUVVNTTdRTzhhaUJ1NzI4NjQ2Rkt3WGkrcFh0K3BiYmNnZHcy?=
 =?utf-8?B?NkR3UjA0d1dWRXhOanVDYTlFeFJzMytiaWlGT2NoVGhkUHV3cmtTQ0pFeitN?=
 =?utf-8?B?d3NDeHpRNm5DZklqa3VRM3NRV1VaMWRXVGZGMEVCUG5TUGJZbVhQNzV2K0VK?=
 =?utf-8?B?RWY3SjdCNU5iM3I4QkhodzJaN2FNZHMwWStuN2F3TlBZQlZGMDJteUR3K1lY?=
 =?utf-8?B?UktlZXlUank3aG5KUVczWkpDWkFNeWMveDZ3Wmwwc1B6YnRrb0ZYZUNPUUlY?=
 =?utf-8?B?L2pEV3JxbGZ2eTJnQ25sQUxHVkMzNlFueHYxTEU1SVhOc3pqR3V0a0RGem9D?=
 =?utf-8?B?V3NHTzBEQmtJb3RJOStqVUlBMlBDZkdGR1RmZWRremFHWWpZd2tZcTRpYVNI?=
 =?utf-8?B?enlqVExQVzd5OU0raGMvSXNkazE5T1JVUDJRMDc4S20zZFRDblo2QWJGYkpx?=
 =?utf-8?B?QU8rUzQ0RU84M0haTmlmMFgwWFVaZUVwd0tKZDdPZ0pnalkzbTVyOFFablFn?=
 =?utf-8?B?QXRYN3VOZFE0dFkzTDNMWnZrTk80QmZwRi9qUWgvaWxUV2dEeDZZL1p4NjB0?=
 =?utf-8?B?RHpwTWlhZ3pvVm9OOFNOUTlCTkJoRWZYMkhYZGh3WDR6TEliUm11dXVyNGY1?=
 =?utf-8?B?dDJZaTNxZ3Y3bDRNRjI2dXIwM29Ea01kb1dMbWhaVmtIV0RrZUlRQ3pvcDcx?=
 =?utf-8?B?WTJIdkt6cUQyc0dRSnZCek9xNVFrTnBhR1BVWTBjZ25MVFM3MnQxRmFCVFFF?=
 =?utf-8?B?cnZvcVZyYTdFeUtvanJIU2ppTWVtclU5YWt3aEZLQnJYTlY3U1FhZHJmQVd3?=
 =?utf-8?B?ZWV0V1cxcTg1a05ISHVFZjBqZ0RoTXd4SVQzYVpod3J0WFYyWFg3YlJxeURV?=
 =?utf-8?B?c0VCZkRSd09wQ2FPdVcyZXJXcXd2Q3NBL0JMN1RUbWVxT01vRE1sbTV4WmhH?=
 =?utf-8?B?OUM4ZjFYMWlOekh3MldrUmhTTGJrZ05NRFVDN2hyUE02USsyRWo2bHBLRW16?=
 =?utf-8?B?ZGozaGpmY2hBc2hHOThHbVhteGs2NFZOelVVblBFTDUwVEFBd2ZMVHp2eTVj?=
 =?utf-8?B?WDRaM1RIWDdIR1pRRzg3cmg4R3ZPYU1IaU5kem1JYVNISFFDc2Fad004SU9N?=
 =?utf-8?B?a1EvRnplZ1NpWXNpdEkwWjVWNVVLUmNaRlZSRUQ3N3JUZzFtcmZyS3ZYNURm?=
 =?utf-8?B?ajM0aysxYzhmTEd3WEQwNHR2TjJLdGJDSUV6cFU1aHpiZjZmWUVJSElHNmdn?=
 =?utf-8?B?SXVsVzVLS0llYkR3Z3Vkd3hWRXowazRGVFovaGhqTFdaM3JoTExYQjRoNDVL?=
 =?utf-8?B?dVFjMy9IUDVXdGNRcmpqZVFFbFc1cW4vTUE1Mk0vZzFvTkx4cDNpc0VHUms0?=
 =?utf-8?B?MGJXNC9BODZQRHdpNnFxM3NyZXdxN2EwTWlaOGF2cVk0NGRCWE1TMlpPTXcw?=
 =?utf-8?B?RzRNTUVmME1FMElFUkxiTnRiakFHMWhpL3F6elBybmJPUk9rZzJ1eGZqY2xM?=
 =?utf-8?B?UG1mbUJKT3JkT1pBYkxWK29UOHJGVkZnR2NqUUhDZXZKRnhyOGEvSWtMTFpF?=
 =?utf-8?Q?E1VlP0pPb/RgmAQSd/erzxmteFCVp4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KzRlajhwQTAxbHNqWFYrVnh2OWdmSG5LYUVNbHZNVTVycEQ4YThKMFlZM0Y3?=
 =?utf-8?B?VUYwVFdzdDdVWjF6c29BT1phUENpYTExWUdWMEdhTGYwNER6Snh4SGs1N1pr?=
 =?utf-8?B?YlRodW9yVHBhdVRxR2s3S1l0T25QS2VmdWdMQ2RpY1k2b0hpNkFoZFpIVmww?=
 =?utf-8?B?MHhHNU9yUzZqNllIRlFGVnFFMVoreHhIdWN6V1FZczNhTFpCS2JjRjZhaStD?=
 =?utf-8?B?ZU1sMkZhVk5CZE0rRmRHek9Kc2l5QitlRmVSRzdHNzhCWlBFc2xDenUwWUhr?=
 =?utf-8?B?Y2ZEOThKUm42djZGWWNQK0cyaHhCN1FyTG4zbklRcHk0a3owenZTTENDdG5D?=
 =?utf-8?B?cFNXYU41R09TMllLRldmbGR1SDJPNTFOOTB2bDNlNGh1dTl6WHJCSnAvL1c1?=
 =?utf-8?B?ZlorRXBtZmh3YjdkVEVmK3MvNlJQT0RTMXI3Y1R3ZTdLdFc1ckNLL28vRmpB?=
 =?utf-8?B?WGNEUnJpUkszUlhNWGV0OWFnUHNjSUdLSHJzaVkxN2IyZGc1TGk5SnpIbFhE?=
 =?utf-8?B?NmRxdEkwNFFwbjRwU0NWa0ZNM2hNTFl6OG9tWEhIYWNaWGw3UmVkZnhhd2lU?=
 =?utf-8?B?aGMwbmxTd3FPZFhoZkhvMTBzcnpNcFlXOUQrMk00WEVvZGRKWUtRNHNhRSt2?=
 =?utf-8?B?QTZFRlFOZStJNnkzYWVXWHRUQW1GQjkwVmtTSjF4TnpwQ0VtMGlMMGxYbENj?=
 =?utf-8?B?SUhNdkRRRFV6Z3JIK0hpVTIvM2hvdmlvdjY0NDc2NzBTdlZPVURYYkpFY0xm?=
 =?utf-8?B?L3lxRnlDQmpJTzBoSUpVajlkYXEycWp4Zml3V2VtYWR4NmtCT3pCY1I1TmZR?=
 =?utf-8?B?ZWFmMnllV0x4NGs3NC9RUzlFQWtxbkNFN1R4U2paK1ZIVHFyRko1dnJjSXpp?=
 =?utf-8?B?UVNQTG5OZlFZK1F2OTIxUW16OXpwRjBSSGdRWXR3OEpZazBtb3JzRXdibjcw?=
 =?utf-8?B?djBoUE5TWTZSUElQcVIxejZNaVBmVlZNRlhmdVcxa2s0a0x0Ym56NU5IaXZw?=
 =?utf-8?B?c3FHSndIaFg3RUlXcW45dDVHSUJnWlMrYllaQlhOWUNoQ3hOODVQMjlYcGlH?=
 =?utf-8?B?OG9oMlRMRDhnSWN1OEY3Wk5ka2hNNHQxWWFOK2ErL3g5T1F4RnNKeENqQ3Bq?=
 =?utf-8?B?WUhkL0swSDJWOWFES3NzQU1SMEdVeEUwN2YwcGFnZCsyNHJBa1pucnN0eFl0?=
 =?utf-8?B?dHZvNklzVzFzd1F6Y2p2OVlaWkZidHhGVTl0NUJjb1FrRTJ6d3Z1NHFSZGk4?=
 =?utf-8?B?c2NTL1o2YXFYWWVzYlV0ZWVvdmFRWHc3ZmR2WXFLOTFFUFNvVHM5SVlwUlYv?=
 =?utf-8?B?TlROWGVkemErY3FzS3VjQ0MwMjdWRldieGxzcmNkZ1F6NkVnRWdmdldObXZh?=
 =?utf-8?B?RW1xZjg0c2xNWEY0Y3pFSWg2MzZPaUcvR3VIWWxRZkhkcHhnT0tQUTBHR0pz?=
 =?utf-8?B?QTd2cGdFdW5vQW8yQ2IxTDVocmdtckxDVytQSWI4ZFFkT1NrNlVuK3g5K0hq?=
 =?utf-8?B?d2dOUVJPamZZRnJpY1dFNkpWVnpEY3dsLzFWaC9TemJSSWFsNXZHblZmaVho?=
 =?utf-8?B?NUxCOVpMNU81OERhWEtIRWE2UGxoVGlBcDcyK0szMFlpVDR2R2F6Z29McXN1?=
 =?utf-8?B?WUZidURMRWp4MXRsYkZpS3JESlA5UElWR01UT0JDb0N0MFd1eXhqNXZJV0d3?=
 =?utf-8?B?OERjcXV1NDlNaGd0dnpUTWpDd1FuQWtuTld0NjhXNnlGbWtWYWcxSUF4TVla?=
 =?utf-8?B?bGY1a1haOFJjcnhhWEEzeHl4bERKSGthazNwNkFiSnRUVTkydnpzeEhoakZT?=
 =?utf-8?B?Y3NFWjdMVUlLajQvWFVOZ2M4UWlzbHZWM0ZYb2RoK2QzdW1idENsVEoreXl2?=
 =?utf-8?B?NXozbHAyUSthZmJsZXBQZUk1dk5xdFhJZFhBRXFBV043WFE4akpHRGRheUtV?=
 =?utf-8?B?L2xHa3hFVDFMQkUvK21SNGpua0d0aDQxYjFrT09rRTdFNE5hc1lJNTlOVWNW?=
 =?utf-8?B?a09hOTVkRHYzQk90MmNmT3B5M3NUNkthSmUrRnh4azNELzFoRDRadVdzcVYy?=
 =?utf-8?B?Q3JMNGw5MUhEUlVNcGZiWnErK0Z5TVc0ejBVbEVkMk0rZ1FMZjErRnN4cU85?=
 =?utf-8?Q?Pd33WZ7csYopwwc6w1WHTXQQM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F6CFEA278EB8244812AE6E542EF4C5F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 642bd3e5-2d11-4b02-aa0e-08ddb94495b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 08:43:57.6492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lbF/q6DHzoDhQxsttjYNzHnuFtqLnT/k9C7mma1E8742JkDQHzTywFcg3NRrx9L+IoYQv+C6ktRJ9LD0KoJnjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7341
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTAyIGF0IDE2OjI1ICswODAwLCBHYW8sIENoYW8gd3JvdGU6DQo+IE9u
IFRodSwgSnVuIDI2LCAyMDI1IGF0IDEwOjQ4OjQ5UE0gKzEyMDAsIEthaSBIdWFuZyB3cm90ZToN
Cj4gPiBTb21lIGVhcmx5IFREWC1jYXBhYmxlIHBsYXRmb3JtcyBoYXZlIGFuIGVycmF0dW06IEEg
a2VybmVsIHBhcnRpYWwNCj4gPiB3cml0ZSAoYSB3cml0ZSB0cmFuc2FjdGlvbiBvZiBsZXNzIHRo
YW4gY2FjaGVsaW5lIGxhbmRzIGF0IG1lbW9yeQ0KPiA+IGNvbnRyb2xsZXIpIHRvIFREWCBwcml2
YXRlIG1lbW9yeSBwb2lzb25zIHRoYXQgbWVtb3J5LCBhbmQgYSBzdWJzZXF1ZW50DQo+ID4gcmVh
ZCB0cmlnZ2VycyBhIG1hY2hpbmUgY2hlY2suDQo+ID4gDQo+ID4gT24gdGhvc2UgcGxhdGZvcm1z
LCB0aGUgb2xkIGtlcm5lbCBtdXN0IHJlc2V0IFREWCBwcml2YXRlIG1lbW9yeSBiZWZvcmUNCj4g
PiBqdW1waW5nIHRvIHRoZSBuZXcga2VybmVsLCBvdGhlcndpc2UgdGhlIG5ldyBrZXJuZWwgbWF5
IHNlZSB1bmV4cGVjdGVkDQo+ID4gbWFjaGluZSBjaGVjay4gIEN1cnJlbnRseSB0aGUga2VybmVs
IGRvZXNuJ3QgdHJhY2sgd2hpY2ggcGFnZSBpcyBhIFREWA0KPiA+IHByaXZhdGUgcGFnZS4gIEZv
ciBzaW1wbGljaXR5IGp1c3QgZmFpbCBrZXhlYy9rZHVtcCBmb3IgdGhvc2UgcGxhdGZvcm1zLg0K
PiANCj4gTXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0IHRoZSBrZHVtcCBrZXJuZWwgdXNlcyBhIHNt
YWxsIGFtb3VudCBvZiBtZW1vcnkNCj4gcmVzZXJ2ZWQgYXQgYm9vdCwgd2hpY2ggdGhlIGNyYXNo
ZWQga2VybmVsIG5ldmVyIGFjY2Vzc2VzLiBBbmQgdGhlIGtkdW1wDQo+IGtlcm5lbCByZWFkcyB0
aGUgbWVtb3J5IG9mIHRoZSBjcmFzaGVkIGtlcm5lbCBhbmQgZG9lc24ndCBvdmVyd3JpdGUgaXQu
DQo+IFNvIGl0IHNob3VsZCBiZSBzYWZlIHRvIGFsbG93IGtkdW1wIChpLmUuLCBubyBwYXJ0aWFs
IHdyaXRlIHRvIHByaXZhdGUNCj4gbWVtb3J5KS4gQW55dGhpbmcgSSBtaXNzZWQ/DQo+IA0KPiAo
SSBhbSBub3QgYXNraW5nIHRvIGVuYWJsZSBrZHVtcCBpbiAqdGhpcyogc2VyaWVzOyBJJ20ganVz
dCB0cnlpbmcgdG8NCj4gdW5kZXJzdGFuZCB0aGUgcmF0aW9uYWxlIGJlaGluZCBkaXNhYmxpbmcg
a2R1bXApDQoNCkFzIHlvdSBzYWlkIGl0ICpzaG91bGQqIGJlIHNhZmUuICBUaGUga2R1bXAga2Vy
bmVsIHNob3VsZCBvbmx5IHJlYWQgVERYDQpwcml2YXRlIG1lbW9yeSBidXQgbm90IHdyaXRlLiAg
QnV0IEkgY2Fubm90IHNheSBJIGFtIDEwMCUgc3VyZSAodGhlcmUgYXJlDQptYW55IHRoaW5ncyBp
bnZvbHZlZCB3aGVuIGdlbmVyYXRpbmcgdGhlIGtkdW1wIGZpbGUgc3VjaCBhcyBtZW1vcnkNCmNv
bXByZXNzaW9uKSBzbyBpbiBpbnRlcm5hbCBkaXNjdXNzaW9uIHdlIHRob3VnaHQgd2Ugc2hvdWxk
IGp1c3QgZGlzYWJsZSBpdC4NCg==

