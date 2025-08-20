Return-Path: <kvm+bounces-55212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42452B2E78F
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 23:35:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80A52189C57C
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 21:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22EA532C304;
	Wed, 20 Aug 2025 21:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I+FNsjw2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9644C27FD78;
	Wed, 20 Aug 2025 21:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755725674; cv=fail; b=SglFE6qCn42i1Y3riDblK25Qax9UcbmGHRVQsAhn2fT1nLe61mWzZ2PHkqEhNxsGI0SHALJa030YejsUI3bu6YQsm00+yV13kaUzl6mlPYPKibWyIS1Z5DFjWgNVmqa8FQrvyNfYtGdfJzEN6PvQsTX9f/RQTlp0aF1TVKJ6vN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755725674; c=relaxed/simple;
	bh=3Z95Q3JZdn+rmh/oTlTfd3ZlRVxd6NPyFT+6kyLJFpE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UdjhpWiklHrjbVeR7C4ZnwaFzF7KkW9OJNFEDD6BHeVjcpNIO7W30t+22G8rxVTRco6Jyq14eDG7Hy6n+RHmrKi+GXhbXI8sKbcr5cy+2+JcIrWHTW7H6BTXIvIeN43ThVO0/sZrWgykF5HPj/diTT0Hz+dintXwmKyQjjqG+DE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I+FNsjw2; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755725673; x=1787261673;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3Z95Q3JZdn+rmh/oTlTfd3ZlRVxd6NPyFT+6kyLJFpE=;
  b=I+FNsjw25eLAlzU6cMvS1upxJGRFR5bYNXX4D+Bo2kqeG0QRWxGPFBsk
   GwR3rdDsrTfcDf6OJjxVurim63+bzJYIuk5NkEcTePsu3Z2hgvs1QQl/1
   4o9UYg9aBG8D+2UU70ni/XjS5Viov46eX84bU1jBnhR8Tj1m7HdxStTL2
   P5vzPtr1XZ+83zN/afgLnzh+BL22B+1EmVQcCPKBfD6Q10wOzujDRBmmp
   b46P+sEs6y5FUeyI3VDKhzBBaxjFpLP2HZCwdxyEw1c7G4m41xFn7rRTK
   xD0TnbDCE6eZYm5DkeTtbUud8cwaOrKXb0x/bvp7rLgMQdt/gJAeip9ZM
   Q==;
X-CSE-ConnectionGUID: Ki/STDNfSBulrsuhSURQiw==
X-CSE-MsgGUID: BsfoAQegQ8G+gDmr41fhVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="58074889"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="58074889"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 14:34:25 -0700
X-CSE-ConnectionGUID: qL9kKBK5Rv+3FWIdYEzmKg==
X-CSE-MsgGUID: VsUUbfyIRVCEPYd3rEbvbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="172657805"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 14:34:24 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 14:34:23 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 20 Aug 2025 14:34:23 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.53)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 14:34:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nP91ZrdrjCDUV1G35Q4PtqBvcNw2TMAt/1LB2tfrBxWDOzOtJEMhMj8j/M5ttLdIroQMKob7+91nQqfwj0vyr4iVO0Pu0WJ5BOspx1tfddyOT5kdSs5Qnd4AozFCGxrRryREmbdtyyO2kb0nKR+weXGTCNQEunCTO7tpGX67LlAnVeD7ORQFGvdeUG+GNW4wPd34F/gTquVjG9YD8kZv/9nP/JU2v60+x949YFqDMWAM0Mvvzf/q5ZryD7I37AZ4/pTDk4uxPqdfH05Ffh3If/znYy8jDCaTfXOqfe31bj/oyLm0GflZz/5K3NTaEK9GHQUlPrAs7FBlk26UzoYiYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Z95Q3JZdn+rmh/oTlTfd3ZlRVxd6NPyFT+6kyLJFpE=;
 b=pIfBYiAMA55vqiu6NzJ9VP27RsZOHjsEC1k5oGnBiicaBG5OAziXFgXW0kgsCYW39JOnJnX2ZDHiC/2jfcWwVexTkMUFJSq5O/LbLSdVtvGnW1eBUNlPymgxd9HwSG0eA5AjyO9KRD3yXHH652LjLyOcjaTRGNhaSElTRKWjQHmt2KTtehyPg5/xT6IGH/Jk3kK04rHi0TsGKP5LmgKfhDVJD6ES8KBckqUQfk0etTpWX34mAG8SCean/ANh+lFSBt+Xag63yl5WypUeG22p2RedPnItAnSeMRfEfABjJDBy4yMRNOkEmj90htCfV4RbdBhZS4r3TnPIf5fmlGWwfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA3PR11MB8046.namprd11.prod.outlook.com (2603:10b6:806:2fb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Wed, 20 Aug
 2025 21:34:20 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9052.013; Wed, 20 Aug 2025
 21:34:20 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "x86@kernel.org"
	<x86@kernel.org>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>, "Hansen,
 Dave" <dave.hansen@intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "dwmw@amazon.co.uk"
	<dwmw@amazon.co.uk>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Topic: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Index: AQHcDKj0KRQjWZhTjEidjLxSJo7SHrRiLIQAgAAdHQCAACfSgIAASCAAgAAR1ICAAAqVgIAG+YkAgAC+koCAAMiWAIAAGUsAgACahoCAABCMgA==
Date: Wed, 20 Aug 2025 21:34:20 +0000
Message-ID: <c8f58736bd8a5184c6dede90985bfe940558bfb0.camel@intel.com>
References: <cover.1755126788.git.kai.huang@intel.com>
	 <d8993692714829a2b1671412cdd684781c43d54a.1755126788.git.kai.huang@intel.com>
	 <aJ3qhtzwHIRPrLK7@google.com>
	 <ebd8132d5c0d4b1994802028a2bef01bd45e62a2.camel@intel.com>
	 <aJ4kWcuyNIpCnaXE@google.com>
	 <d2e33db367b503dde2f342de3cedb3b8fa29cc42.camel@intel.com>
	 <aJ5vz33PCCqtScJa@google.com>
	 <f5101cfa773a5dd89dd40ff9023024f4782b8123.camel@intel.com>
	 <acbcfc16-6ccc-4aa8-8975-b33caf36b65f@redhat.com>
	 <a418f9758b5817c70f7345c59111b9e78c0deede.camel@intel.com>
	 <78253405-bff8-476c-a505-3737a499151b@redhat.com>
	 <c736d2040f5452585e670819621d3bae5417fff4.camel@intel.com>
	 <CABgObfZSKoT5xLm9XUR9wweU2MgXj4xww1irL8KZRBUze3vDFw@mail.gmail.com>
In-Reply-To: <CABgObfZSKoT5xLm9XUR9wweU2MgXj4xww1irL8KZRBUze3vDFw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA3PR11MB8046:EE_
x-ms-office365-filtering-correlation-id: 475684ed-67ca-462e-70d1-08dde0315303
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WlUzYXVvRStMN1dNeGVXL0s3aWJOaVg5bU1NRy9uWTFwbUhldEdHekRrbEVK?=
 =?utf-8?B?bEpJUEpBU1NFYXJsd0hlSk96YXM2L1I5RGJUL3ZPeUtFd2tmTk9OVDZBalZz?=
 =?utf-8?B?cGpXQ3BWamFFUWZzK1FVVDA0NGRYTGZnVnp2OFBHUTk1NWNvUnplVldPNDNJ?=
 =?utf-8?B?YTB3S0UrdFpuMThHNDBsMkpQUUloUnIwckNhM1ArMHlydVdwZXBPd3kwY1o4?=
 =?utf-8?B?VWhpeFB1S2F4YjEvdTcvai9tL2pyTExtenBrUGhBQ2pVTTdVMGlyOFJRRUo3?=
 =?utf-8?B?NTkrTVRpdC9vdk52bStwSGNPOWNjYmY0SkVKeHI2bW10VnhQZGtRUFdOenVV?=
 =?utf-8?B?b2FDTjJRR2gra05ITXVvNjRHbHhuWk5COTdJckUxeDJ2Z2sxanZFeVlIaUF1?=
 =?utf-8?B?K0E4TEFBSm5EbnZBRUY4bHpFSk04YzU0akFnTkQ4Z291YVc1aUJOSDFqYzJ5?=
 =?utf-8?B?L1llc1A2VUp0b2p3cWd1NlZOakM2UWU4cERuV3VSQ0pLb1FzY2E0N21xNnc2?=
 =?utf-8?B?OWdXODJjMXNuWXZiL09GL3FUWEJTci9YOGdKZHgwcjRmNk9Yd3JNbHRkTWR4?=
 =?utf-8?B?N09TT3J0Qk9kaWZKYStFaE50Zko1dXRxTm9pU0g5OG1keVczUFV1MXFJdVQ3?=
 =?utf-8?B?TnF0LzIzdEpsSGxJTXIybnFFaWpJd0d1UEFtZTJyZE15eDVVamN5Z0k5VXI0?=
 =?utf-8?B?WVRkMmlyYng5MHM4dTZ2R29qMllqYWR6QzdiWmdWUStQQ0RIWFpZZnVMU0lL?=
 =?utf-8?B?M3NhY2haaGdFWU5mU1VYN2FubDlPQ0wyZEpyWkRmRE04bnlXWUI4Z1gyVnVY?=
 =?utf-8?B?RHVVbGRpT2JWdDFjalo1SlREZzNJaDhkYm5BUXFzcjRueGtrY1RLUlFpZm9o?=
 =?utf-8?B?YlhKb3pUNDR5VzJSU0hhU3QvdG5kK0s5YjZIZ2hUYTNEczYwc09kTmpEeTRC?=
 =?utf-8?B?cDZDVFhjOHpWeU9keFRMeS9CZUxkN2ZBd250NTlUTFdpdTcxVGdGbENFTjBi?=
 =?utf-8?B?RnVNcWZXZXBFRVZSaUJQKzI4OFRtYWlJL3VFSDdFR2llSVJkcXJGNy9SeG0x?=
 =?utf-8?B?SktyelRoUGVxclpLeUdCdGVOVVVPRm5Nc0JPcjA4U0x3NTRRVGZtWWcyRjJK?=
 =?utf-8?B?WE13SmJRQWw3ejRaTHpTMjJQSWE1M2gxSGMxWFJVWThBaURhakJ6ZVFXRHlP?=
 =?utf-8?B?SmEvYkNaanpGSzFMVm04NVNCV2Z1SUpFaGRXUCtaR251SjREUnlEczdTOHRB?=
 =?utf-8?B?bEZIWS9CWlZ0UTRSdFl3WmdNWEE0QXVCZXhScXhzanZpcWJHekVSeTREQTdV?=
 =?utf-8?B?NVNIdlhuQmY3VERIWWlZZ2FxV2I4VkdQMHdCcU53T25wTjI2MzJ0OFExdk1z?=
 =?utf-8?B?TzgxMnJ3U2JFeDBVL2J1eExtWFpFUlQ2bld4WHRPeFBxVjBnUWlHdy8xb3Q4?=
 =?utf-8?B?dkdzcWkzcTdMYzhYS2sxZkx0L2VLWXBhUmMrajI1c1hGNUt2REdpVUZFbzZ2?=
 =?utf-8?B?UnNhKzRnbXhuMWZnYjVIRWlZK0J3eXFzSXRTQmRaazlkWHlzamlpQk5oWXht?=
 =?utf-8?B?U0pvOEhTd1Q5VEZPcjZWN0Fyd1d1cjF3ZTZJajJGUVV1RWlqUkp2Wm9kcXFR?=
 =?utf-8?B?aks1S3k4WlRnSE5OYUdXalQ3Z1Rld0hQWXBkdUVNZWV6TlV3YnVPelZOSEVr?=
 =?utf-8?B?OHVLaE1PT2xNc0xWTmlRb1BMZVY3QTdtTFNkQS9lL0RWY0dlMDVsRTZjcUxa?=
 =?utf-8?B?TVpXby9YN1MyZWFRWGdYck83TFBRdnBkMUtqa29FYzB5Rkdyd3d6RFVEdEFq?=
 =?utf-8?B?NkhNV1ZlMUhZTWQzaVhIdnl0bVRLL2NyMzZxTlZGT21SSVZtY2hHVDQrUlla?=
 =?utf-8?B?Sy9aUHFCRkJ6em94NTRXYkF5R3NsUS83WGY5bWhweExSak9Gam0zankvSGtj?=
 =?utf-8?B?RzUyMjZRVXIyL3RYbjhUbUJiZHUvVWxJYVZvbVhQQmJwb2pEbW4vMGh1WWRh?=
 =?utf-8?Q?IWnrBlR1CGre+FH+kPv1yPTkFDUdms=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVg5Lzk3L3JBL3N1VnFYTFpvVVlOK2ppcEt1cmtmcWh5T3RiQUNpRGFKR2Zs?=
 =?utf-8?B?c1lBeUZuQ0FGcG1nakJuQWpyTG9JOTN1d0ZLMCtCSmRMV1Fta2xEQm9JQ2Ny?=
 =?utf-8?B?akEvUlVCdWt2VTlML0ZjNEE5RDdLdkQ0bm1WVlRtWmZjUEl5anAvc1ZpM3Fx?=
 =?utf-8?B?SGJGVXMrUi91blpONGZab3kxRkxJNno4dDBpZ0ZweGRWU1c1VFhKVXBVSjlI?=
 =?utf-8?B?MDZ3ZVRSbEQrd1JvVXh0cUtWdnNidVNHOEtKY0FZVTk0V0pTV0FqRW9TVEJB?=
 =?utf-8?B?ekp4eGdjT3BhZURzTjhzYWxlbEdNU3VkcVRVK1drakNGcUVBZGZCVVhGUno4?=
 =?utf-8?B?TW9YalJXSEdLNnB6U0tRM1psUmhnSnhSSjYxaGkzSXlHTElJbjBSSHZ6TitY?=
 =?utf-8?B?MVo0b0RmR1NwR3JmVHpqbE5FTTg5TFg3dTJURDEzQkFLc2c2M09VY2prOUI3?=
 =?utf-8?B?UXl4Vi9zbXU4dWR1QWI2NzRlR1VKNzVZOWswWXJaOVVVcUNCaXZqcU9HUmw1?=
 =?utf-8?B?OUxaalg5LzhaU0NpWHFUYlhXSzU2RllQbGJpcmY1Y3phcTFsN29pSHd0Q0o1?=
 =?utf-8?B?bXh6ZE9sUldxblFuZUc0SGtRNm1WRlcvTWZKY0FvaVQyL01lejEvaEdPQ2xp?=
 =?utf-8?B?QUR1THIydVFMVEVwNHQ5Q2RPOXFvL0lZOEhjak1STVFsOGpPQkVLMjFIS3Vm?=
 =?utf-8?B?QStNdC9XWGdXZGdaclQzZXFXWEtRUlF0OU8xVGkyK3M4eFFGM3Z0WWpQZ2sy?=
 =?utf-8?B?N1BISm9salNKY0FlRFhOaTB4NXRNb2l3dDZUei8rRDNheFc4L0ZEWlRsbCsz?=
 =?utf-8?B?N3J4YnpMdXdVaFF1UHZTZTVGNFQ1VFVqd2t6dUJ2VmtpS1V0d3ZMRDVseVJ3?=
 =?utf-8?B?SVNrd09zNXlpbGllVEdnb29wQ01aempjNzNGdjVvYW9pSDZ4S3dFS0ZoY1o0?=
 =?utf-8?B?a3BzdVhrR0FSS0lrdkF2NjJTWENNRkhTUFAwcEl6ZGxvbVBJd0dWaHhUSThN?=
 =?utf-8?B?Umt1Y3NZNUZnVUFWQW1GYUxCK1owQWE0dmh4Q3prMDIzSzhJWHp0TXJqSUE5?=
 =?utf-8?B?QnhLdDBiRUViVkhndVRjdndoUEpJc2c3cjBmUkJFQlNvc2NKWmYyQ3RPRFNU?=
 =?utf-8?B?YzFUc2J1Wk56MzRNQW5BNFZVZWZzeWpmS2kwNmM5cDMvcGFYc3dIRU85SG5L?=
 =?utf-8?B?QXl5dVN1dTFSL3h0ZVFPQjlicFBYUzFhOFEyUWdBMjJ3Ly9oWnl1aHZrdTlE?=
 =?utf-8?B?NVdFdXlhUEwrd3FJRGlMVFFrSWN5VHhZNzkvWFl4ZmU3TXNKOFd4aEJrSllL?=
 =?utf-8?B?dWFwMXRGd2JIMVFWWnFLMHR0MkNkZ3NxTlQ2NHNuQ2Y5Rk1ZekN5bC9XdDl3?=
 =?utf-8?B?Q0VxSkNmclFLUUhkQ3RVTWNvZDhaWjJ3MmZNYkgySjV2eXpJSzNkOENvUjF4?=
 =?utf-8?B?UFFQRHV3ZDNhUjEvcTRJWEdrMndvTnIvaTVISkY3bnN6UFBCN2VJMDIxNU5x?=
 =?utf-8?B?U2ZBUVI2dmxxTk8wdnJVeHU4aC8wQ2o4WGhqU0tSWmdYVWQvZjJzV1B2T1da?=
 =?utf-8?B?ZENwRHVCemcrcm9USlpUckJzakVEMXFTbW1LUWJYWVR6T2hOZHhIN1c0dWtD?=
 =?utf-8?B?Z3BLQVFySHgwVEU1RmVrQU45bk9vZjJ4UUZMYStPdGRDUkR2dkUyTjdqakJL?=
 =?utf-8?B?TC92Sy9OUHIxcUdaVjRjcGpCN2JtZ0Q3YWswU3BPWUxDdHAwNzR3d0FteDFR?=
 =?utf-8?B?SEwvT3luRHYxays2VVBLZkJaL045V2o4LzR5ZmJLd0RhclZXbWFnM3lJd0F3?=
 =?utf-8?B?UHc3bXZaeWNuaVVPWXRoY2YraGlUdEVpY3pzQjU3OHJHWWVwOTBaQU1WRGV5?=
 =?utf-8?B?dGxrTHJJZTlYZWJnQXBkb2hsU2VDVzArVUsrYml2dTNDRGdxMjJtLzFrSzZs?=
 =?utf-8?B?SnFJWGRYcXRkNktNR2tTSFdyeno5aG51a3p2UEVzQWFkLzB1allmSU9MYUVl?=
 =?utf-8?B?Rjl0cFpGWmZoTC9PZ0R5cjE1QmVDU3pZNXZCQlFBMDFpT3pacWh6ZDhRSVBI?=
 =?utf-8?B?TXVMb0c4eG1uTVp5Q2ZhejNIb2k3dVFQdjUzUFM4bVE1TzJoRXlUa25QRk1j?=
 =?utf-8?Q?JgBhf6i6IJexL7SvlalW5I/lq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C93A3A64B43314889CCDAD7FE303C71@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 475684ed-67ca-462e-70d1-08dde0315303
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2025 21:34:20.7033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DEuf+7vN0k617xrrKCJTsPlKZtqEGnzFq+vaUZ2SoZuXdJkF5dHdc7RaCGby79iIob38I8/x83PgmiUB9XnDWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8046
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTIwIGF0IDIyOjM1ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiBXZWQsIEF1ZyAyMCwgMjAyNSBhdCAxOjIy4oCvUE0gSHVhbmcsIEthaSA8a2FpLmh1YW5n
QGludGVsLmNvbT4gd3JvdGU6DQo+ID4gSSB0aGluayBvbmUgbWlub3IgaXNzdWUgaGVyZSBpcywg
d2hlbiBDT05GSUdfSU5URUxfVERYX0hPU1QgaXMgb2ZmIGJ1dA0KPiA+IENPTkZJR19LRVhFQ19D
T1JFIGlzIG9uLCB0aGVyZSB3aWxsIGJlIG5vIGltcGxlbWVudGF0aW9uIG9mDQo+ID4gdGR4X2Nw
dV9mbHVzaF9jYWNoZV9mb3Jfa2V4ZWMoKS4gIFRoaXMgd29uJ3QgcmVzdWx0IGluIGJ1aWxkIGVy
cm9yLA0KPiA+IHRob3VnaCwgYmVjYXVzZSB3aGVuIFREWF9IT1NUIGlzIG9mZiwgS1ZNX0lOVEVM
X1REWCB3aWxsIGJlIG9mZiB0b28sIGkuZS4sDQo+ID4gdGhlcmUgd29uJ3QgYmUgYW55IGNhbGxl
ciBvZiB0ZHhfY3B1X2ZsdXNoX2NhY2hlX2Zvcl9rZXhlYygpLg0KPiA+IA0KPiA+IEJ1dCB0aGlz
IHN0aWxsIGRvZXNuJ3QgbG9vayBuaWNlPw0KPiANCj4gV2h5IGRvIHlvdSBuZWVkIG9uZT8gSXQn
cyBjYWxsZWQgdGR4X2NwdV9mbHVzaF9jYWNoZV9mb3Jfa2V4ZWMoKSwgeW91DQo+IGRvbid0IG5l
ZWQgaXQgaWYgVERYIGlzIGRpc2FibGVkLg0KDQpTb3JyeSBJIG1lYW50IHRoZSBkZWNsYXJhdGlv
biB3aWxsIHN0aWxsIGJlIHRoZXJlIHcvbyB0aGUgZnVuY3Rpb24gYm9keS4NCg0KPiANCj4gPiBC
dHcsIHRoZSBhYm92ZSB3aWxsIHByb3ZpZGUgdGhlIHN0dWIgZnVuY3Rpb24gd2hlbiBib3RoIEtF
WEVDX0NPUkUgYW5kDQo+ID4gVERYX0hPU1QgaXMgb2ZmLCB3aGljaCBzZWVtcyB0byBiZSBhIHN0
ZXAgYmFjayB0b28/DQo+IA0KPiBMZXQncyBqdXN0IHN0b3AgaGVyZS4gQXJlIHdlIHJlYWxseSB3
YXN0aW5nIHRoaXMgbXVjaCB0aW1lIGRpc2N1c3NpbmcNCj4gbGlrZSAzMCBjaGFyYWN0ZXJzIGFu
ZCAwIGJ5dGVzIG9mIG9iamVjdCBjb2RlPw0KPiANCj4gPiBUbyBtZSwgaXQncyBtb3JlIHN0cmFp
Z2h0Zm9yd2FyZCB0byBqdXN0IHJlbmFtZSBpdCB0bw0KPiA+IHRkeF9jcHVfZmx1c2hfY2FjaGVf
Zm9yX2tleGVjKCkgYW5kIHJlbW92ZSB0aGUgc3R1YjoNCj4gDQo+IFN1cmUsIGp1c3QgcmVuYW1l
IHRoZSBmdW5jdGlvbiBhbmQgbGV0J3MgY2FsbCBpdCBhIGRheS4gSWYgaXQgd2FzIG1lLA0KPiB2
NiB3YXMgZ29vZCBlbm91Z2guDQo+IA0KDQpUaGFua3MgZm9yIHlvdXIgdGltZSBQYW9sbyENCg==

