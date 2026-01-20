Return-Path: <kvm+bounces-68607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 218D9D3C571
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 11:36:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 17BFA7230E4
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 10:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F493D523C;
	Tue, 20 Jan 2026 10:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lq8k07n8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8A53D2FE2;
	Tue, 20 Jan 2026 10:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768903273; cv=fail; b=u1ibIBa2aZZQjOmarVOt/I9oak3DsKBCvDE0IoWAirmRlGlo0SOkgqtbzli/+4Ojka2jMbY8m3umYe5AjGTMgB/Lly7pBoZJVawRHcW8YxX537RQP4NNv2BYlQUmAEwQuVRUIJOb4oRUOwh5FGXjaE4yDfPoNqZV0Ci0N2nUx5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768903273; c=relaxed/simple;
	bh=qZhcvxXAAB3syNhCo20vJcCi5cCAMGzISw0VoFa7fXU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dGy6Z4COLyuvPsJ9U9UKVHO44SqYRcaD2zWKDj/PPCveNheAlVEOpxQ9E8mP53u9whvGRStLcyLJRFt4YucZTH6ggY1hZnoy70reVFU5BDpfb7ASizarDokPHspJpvrGXjUbPpQ+wcmJS6uXf7niDiMg0ymY+N/ykdoN3R1aXos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lq8k07n8; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768903271; x=1800439271;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qZhcvxXAAB3syNhCo20vJcCi5cCAMGzISw0VoFa7fXU=;
  b=lq8k07n85y1sM8BXLu0b/ezVR/PcO4Mv+iwxVY/ZWc4eVtLdIkH/hBh3
   eeZE/SULRl/Y1lmsPOUckXodIJkWr1zi5Yp7P5FRuRhf7R5gtATzYLmUN
   Wv4nScVR/iXcvlJ2VkV0ycaniYFXsPFIB27KXd0+/SgMY77jQ4KDrNXLR
   7UFsALitGlepRZ7mu9jLM0GXEoHUsAP2xJYP8VF9vkb8mI7dSk1dgySv+
   //2ObXxQV8vdk14xEzG1cj/PD71YSJDb6uJiUGH6ncvDxLBeStkJyiZqC
   1OYSTfx/t7tuCCL7pq9BehMUW01O+8Ackpd2FUPtmDf/S1Y9Izg0zGmsw
   g==;
X-CSE-ConnectionGUID: ItySYfhJSQODuqOIXzFPAQ==
X-CSE-MsgGUID: roNQdwKHSB+RPrDgamlM1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="95581473"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="95581473"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 02:01:10 -0800
X-CSE-ConnectionGUID: s4ib0h6wTgysOxfR00s6gQ==
X-CSE-MsgGUID: Gc7uxUTkTdezVy5fDIf5uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="236766440"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 02:01:10 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 02:01:09 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 02:01:09 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.7) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 02:01:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O/EscGeiO7AFwgRZoBv4MRidfqIA7NiiD1Yc32ocOIvDDynYDCqupk2cAnZ0bVdxvK7TyKNOU04uoFinHZjDphe+q2DAyGV6aaqVHJTEhSv6bE6Wj/bhXaOpSIv9xIu/AxEd1knrk9kQFsWVGC7T8kMA2plHt13DD9ro90CAgPzXrRj7uOxxEMsaHedtSARRC3f1H30Qnss+TXCqQm+gKh4BPCD58S66CYUyBW0HwM8/LdgtelwBuR7Dy1nK925P02mPcQQHFw7b/2u139d2AzOOLsq/SQUGorBCfr+HaG+VQ3UirdghQENDxrMeODuZ5EFqKvBkK8A8HAYSy0NQCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZhcvxXAAB3syNhCo20vJcCi5cCAMGzISw0VoFa7fXU=;
 b=nRpw9rEhEF9oLzgrUPD1roYw+xWWn8+Nv3gwSbdoPwmGP5Jrw9uxIPmMQI2oDPL2OM6LUByy2E9sN8VPPzRjHN2Gbno0vXkNnWO9ZwvTN4rhyP885Rrztx1hdE3+EHLEnhbsCZ54iT4Fwreyj2so4+X1eirbtSl+bxMSaWVQUSyWnLu8dKsEjD4O0mt0SP1jUaaXRunXcJEuDzRW4hxkUG7k25xeUNTZQjQh5u/fP0QTk4mqso/4hprLajo+qviBtGGifJGFUvaphG9UwG1TuF/AD0ZtWSS3KrY3f9Yiv4wmOIVoyrbBkBlhal8VA7dzBeLsR3nlsoa10sXrUH3J5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SN7PR11MB6850.namprd11.prod.outlook.com (2603:10b6:806:2a2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 10:00:59 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9542.008; Tue, 20 Jan 2026
 10:00:59 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen,
 Dave" <dave.hansen@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 11/16] KVM: TDX: Add x86 ops for external spt cache
Thread-Topic: [PATCH v4 11/16] KVM: TDX: Add x86 ops for external spt cache
Thread-Index: AQHcWoEJZMe7fqktBUy9KVYPva8b2rVV4oKAgAM/5wCAAfoHgIAACiEAgAALwwA=
Date: Tue, 20 Jan 2026 10:00:59 +0000
Message-ID: <1e4711a1b68e9b5c268a463d5376463ae2978771.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-12-rick.p.edgecombe@intel.com>
	 <aWrdpZCCDDAffZRM@google.com> <aW2XfpmV7FqO2HpA@yzhao56-desk.sh.intel.com>
	 <ecf01cf908570ca0a7b2d2fc712dc96146f48571.camel@intel.com>
	 <aW9IetVmF3pIVFRl@yzhao56-desk.sh.intel.com>
In-Reply-To: <aW9IetVmF3pIVFRl@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SN7PR11MB6850:EE_
x-ms-office365-filtering-correlation-id: 9a2c9e34-aac8-4a93-fd62-08de580acfbe
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?KzBIS3lVMTdENXUrc3Q0TXpYbE9kR2ptZWQ3V2p1OGl4Um5QRnNSSVZCOC84?=
 =?utf-8?B?dWpCME5YcWV2c3gxeGFGanF6ZlcvbENrMFYxME9IVmx1QnNXdzhPYTEzOWZa?=
 =?utf-8?B?eVVUVEtjQVRwR3Vhc29wdzhzY2MrKzQ2dnpnWDkrSmc3MXlXVDI1NFRocUdI?=
 =?utf-8?B?bnJRSy9ib0E5YVRtdW93bmluanlKKyswYUpLNDVyaDVxeERtOE5sMzF4OWxt?=
 =?utf-8?B?SUY5SWdVajV5NExTVDB0M1pjWUI5cVdKMnl1Rmt3VkptR1VDSlJPOHZSdHly?=
 =?utf-8?B?c1JOUHk2UktxRW9lUjNLeStDU0NTcHd6bzJENnhRWlkrYmZCc3Irb2VHZ0tL?=
 =?utf-8?B?ZHFpLzR5Q015cFNrRnA4VVdFQmptL29SSjdlVXhSUWNidndJN3VhNGVFZlpX?=
 =?utf-8?B?NFFhYnNGdUtGa0krdXRyRUlrTytBRXFjNkM2SFQraDVkRThKUCtLRlVVRXk4?=
 =?utf-8?B?QU92VjVrRXNWYU9jV0pIZ2lUNnM3QW5LcDN3M1M5UmE1RWtuYVFoN001Q2Ey?=
 =?utf-8?B?THpScXhHMldOakhjRmpkMiswMGdubWVjcmVjMWl5dEtWbi83YTY2dFV0dGhJ?=
 =?utf-8?B?UHpmSmxINlFJU21rQ1J5V1I2Y1hpa25aUEZEYzNOWFV0VjZyM21lakwwajNr?=
 =?utf-8?B?MnF5ZjdaQVY0bFdzdTRwZ01na1pGaGtZTTcvZmRMTnVsb2dqbGJpdXNBdHFp?=
 =?utf-8?B?SkY1NEFWalhSQ3Q0eGNST29VQ2xqQ3Ftci9MNnVKazdsVGpvbjZzRjBVQ3ZI?=
 =?utf-8?B?bU1EWkdXYVh1SENPZGNRLy9VNHZGRGF2UWtyY3c5djRsVmNZUE9oR0xpRWNt?=
 =?utf-8?B?TE1IYnRLWTgycXZZYTdPNWc5cmlwcG8ydnJjMzZlRjBNN054MFNnTTBhZ0pj?=
 =?utf-8?B?bTh5VXpkSU5pRElUdEtPN2RFNkxOck1oUlpYYlBLMW5ZUTAvOEtyWkF6UCtH?=
 =?utf-8?B?QlNDVWRabTlqUE0ySmxYNHJxdkN5SmVFMm8xTFBsRXV6ajlPelZyeHJGSjFk?=
 =?utf-8?B?aFB0SjlpVFlBODRQNGtJQkt6Z2g2VEhId1RXeEJUZGhXd0YwTGErVGlVSTFG?=
 =?utf-8?B?bklqVzVzWkJsMnp2MlQ4M3VKcmRRbktUak1rRUREK09wRGV5UHFYM2FDYWFP?=
 =?utf-8?B?dkVhZ1VCUkFsZDAxcE9RR2ttUzZmK0lrUDBwN1Z4RGJWNUhMN2pPYnYzWXRu?=
 =?utf-8?B?cU1RcWQxdFhqVmZkcWtLK2hvbFhiZmhESVdDYThhR0dmVHdveXArNTRISEkv?=
 =?utf-8?B?UFNBNnFrSHBUUml5ZzliMVNscUJiaU45RVIyL0g1Z1hyU2JBU3FaUFlrRzdE?=
 =?utf-8?B?N0t5NjNUQndKVGNNRkxvZTNSRExLMGcvcGhGU1ZyVjFKSlRHenlSTnR5QWpI?=
 =?utf-8?B?THlvUzFUKy9EYmdteUU5Yy9KOGpTMW9RclJERXZjMFBvUVVwelVPdk82a1Jt?=
 =?utf-8?B?eTRPZWQxanZMUnBBS1RXNWxTRTk3NVdzK0VOVGF0elloelIrOVhYVUtSSHN0?=
 =?utf-8?B?cGxPQXNWc0Z6Ym1uemFCbFlZMmRFRTM5Yk44alVFUFA3K1RLZjJlRENPYnVY?=
 =?utf-8?B?bXpKNHBFMU5nSnh6VXZYazdHUncrcVAvU09hRXhGdGpIbTMxRWpybFA3M0xH?=
 =?utf-8?B?VUlGbG0xcHEyZXJrazlpTk5naUkvUWt3cWNOWnJsbkhORFphYnJFNXZrMkRy?=
 =?utf-8?B?NFJhd2NtTXJ2OUNmaVZ3RnJvbkR4aVFjODZibkdxdEpBVXpscU1ad0l1SWc1?=
 =?utf-8?B?b3ZZQW9TOTQ2ZE80RldmZTJLRkJ5NXVuTVNwNmJlVjlzV2NnZElOb0FnczlW?=
 =?utf-8?B?ZFRsZzhUbnovTU5KSzhXeGE3UlRMZCtXK0RxczVzWXU4UjhKR29nUVZCL2NT?=
 =?utf-8?B?YWwzQ04yYWJ3NGdMS2o3c0ZOMkdkNHRzVXFSVDhMZkdTbVdReGtFNXlZOUFz?=
 =?utf-8?B?TUptWDRrMFJYcEpkYWxqOGJqNmlhdWltYUMzY09ENDU0cUt1MFJ5UHZ3b0RB?=
 =?utf-8?B?Y2MvaCtoK1dzenR2ZnVBaW5CSkhVTFdONkxTa2ZUeUU5ZE45cmN2OW1NRkJ6?=
 =?utf-8?B?dVMyYVAyOTN1OHZEUVZuKy9nS21lZnBIWVVEb1kySmRub3A5WUd3cDh1ekFm?=
 =?utf-8?B?SjFlM0N3dUwxOEVwMFNGdGN1WnNJUzJDOC8wVEdFL2wyMlRxQlFCMHUwdjZm?=
 =?utf-8?Q?rTmJiNHewuiYFbbi/F+EYos=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cUdYc3VDRGFycmJWOEJqbkhLeVJ2ZzVRdzl6KzdJTjB0YTB3MHlFUWNkZlhT?=
 =?utf-8?B?S3FrMmN6Snl6VWZNcW9qeHNIenlGRThnUEgvYjRmRXBtYnV5bHBncFZGdW9J?=
 =?utf-8?B?S2JVMTU3ZWEwZUwxZ2pjeE5acWRzbENhMlJvcDQ5dFArdUs5aTdrYVYzSGIy?=
 =?utf-8?B?eE1UQ0R3RGhKY0NlMHRNU0FsQ2xnVnlBdnBndVFyZStyZyttdEExcWtMUU5a?=
 =?utf-8?B?WFNEcUxIbHNFaVNHNlJKVFEvZXZSME5NNXpsc1cxYkNkSWRrdXZ5MzRqeHF4?=
 =?utf-8?B?NUQvbTNxMmoyMW9VUFFpTXRTYlk5Q2IyOXdYK1BvMTJoUVBFR3F5VjVMNVdG?=
 =?utf-8?B?amE2OW1SUFVLbHFWaklUMDg5RE9yM29IcS9CTkZSdnhFNm5aWVZGZjN4ZHlj?=
 =?utf-8?B?Y1ZqWTJhekl2UEM1bTRoWnduS0pCNEMrQVR0bm5vYnA0ZVF1Uy8rdzRPTGti?=
 =?utf-8?B?S3hqOHFTU05xeGRwVy82MGhhYktqc0R5cFBVQm1zcnVodnM2NjBZeEdLWCs1?=
 =?utf-8?B?VTYxTVJaSGxwamc0VEV3M3JZQTJXek5zT2ErRno0cnVNOFlRVVl1NTZla0dJ?=
 =?utf-8?B?V2VZVVNyWTc2OTNoQVVFdXpieWdDei9xUWx4TmFZWlQzNWM5VjZjRDQrYVRQ?=
 =?utf-8?B?dEdXM2JaUzEwQUkxbGV4eHZTRzdwSnV3YVdzSzRYUEpLSzIwT1pNVnRVSUFr?=
 =?utf-8?B?MVZvbldobWQwNTQxbGFvbnpIWlR2QndSaDRCMmNRb0hFSUxTZWpjbEg0NHhW?=
 =?utf-8?B?M1VPUVRLZ2h4QXZOdy9TMi9QTDJmaFJucFA1WTZTdm5JbzZzMWNYcHVkYk1W?=
 =?utf-8?B?ZkJKRmQvd2tZWTd1MXA5YkJabkE2MEw5TW9Md2VNY21mL1BRQ05mdlhvbUI0?=
 =?utf-8?B?Qnk1ZnZ3bEVMT290OG9IVVpqWDVBRWt6WUxSeE5tOXZSalh4MnJjRk9FL0Z1?=
 =?utf-8?B?c1RUb0NDbGUrZ2Q5ZmZvZFFXLzdRMW1tRnIyUDVYSGozT2ZFU3Y3YzRVVEdU?=
 =?utf-8?B?bkN3QytFK3luMG1rSHB2ajUzUkQvSjhkVzA4T0dOOWF1QVRmdURPU1laZ1B3?=
 =?utf-8?B?N2lCc3hUcFo3K3VZMGRFd2ppQmRCVlBEMjk0T2wxRGdGajFHWWpxcTJQcC9a?=
 =?utf-8?B?VWx6L0JHd0V3ci9qaVZXMmsvNEVjTGlUSGxaL0JWWS9FSzhzUHd5amxTU3FG?=
 =?utf-8?B?QStZdkZMM3MvdmVuejN1dzdJYmp5UCtENkluWS9vS0VaemtVdzhpOEtZZ3lr?=
 =?utf-8?B?anM4bXNlWlowUHcwSHpwR0h0eXVOVi9mbTkwQXA4cklqT0lBZGJ1N3BpbTRu?=
 =?utf-8?B?SmpJN0p1MzltQkF0TGZUVnV3UENVWGxvMzArN1NReEhlcVhUSjA1aEJ5aFU4?=
 =?utf-8?B?bnh5bE5YVEZkaXRoRy9WMFc4Z2IwOG10Unh4SGZpV1FKbTRaNktOUUlmZGVM?=
 =?utf-8?B?d3htTzBhQmc0RkE5TE56dks0UFlWR21Bb052T1JjOC8vZDdDMzJsYS9HRnBZ?=
 =?utf-8?B?TmtlRWVTZkV3SWRVcEN0Q3g2Z3ZZZ1ZTYUtaNVlQSStMd3BXNzAzSkVGSEdC?=
 =?utf-8?B?SFF0cmo3dVJTWXBMWmoveHloTm4wSThBZDZrWjZNRlFpUU85eFNTY1E1TUEw?=
 =?utf-8?B?cVJqQzE1dmlWZXJCclhJMzd4TmxjS3M5Y0txNWU2RE11dS9xdWxwalZOcG1k?=
 =?utf-8?B?NUVabm82R3U2cUhkS2RUMHVTZkozK3BMSzVZVkN6T3dVa1VTZE11L3B1ZDdu?=
 =?utf-8?B?bVNkcVRVcFhvWTd1emxqcnAyMlhlYUtSdWlyN1hDRlo2eFNBMnhSUWdDQy9T?=
 =?utf-8?B?dmNidk4vdDQwa01aYkpHUzdYbkg1cWZ1eXhaSjJXOSttelpDTU53clNNNEhJ?=
 =?utf-8?B?S251RkI0OGk4MTh1alZ1RHBRYWdtTitNMjZOdGV2Y3RjcWo0N0pqc1ZHSDdG?=
 =?utf-8?B?eG5sajkwTEVaNTJ5Z1hGUXU5bklkL29lM252dkhJelIva0ZBOVAwcC9RYkZN?=
 =?utf-8?B?ZC9XNEV5d3U0VmFMMnIrcWRSZFQ0NkRGaHBoTGVJQ2NmcGlNTFFDVWloNlpt?=
 =?utf-8?B?RFlaQjhpNDB0UzFRdm1QTGU3QkpIbjQrMjhyd01PYlZyQU9FazRJYlhSdTU3?=
 =?utf-8?B?T0RMWEZNank0RnBuMnNYM0ZVYmdjemVieER3R3p6d25EL2tGWnJMS2x5WkVI?=
 =?utf-8?B?YjFsYzdzckMvaGhQZTIwVzRwNytHRzBKS25PMzZZTXVISERYMDhUTTJzUnFt?=
 =?utf-8?B?aTFjRk9DZ0VKNmxabUNybVhFSytjU2dtWWJOZGtIN000Nnk3KzUzeVlYU3o5?=
 =?utf-8?B?cG55MTRrN01jc2RLYkwvLzJ5UzF6dUFwMzNVek4xMU9iRlUvVGNHZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8DD98A6897196C40A9CA80E3D7E11ABA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a2c9e34-aac8-4a93-fd62-08de580acfbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2026 10:00:59.0995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HxxNVt40x1F85R47mTxCB+JlEDGKVLvD2Lcz4Z7vGEcMMsU9G99j124qJNJSDQv4ZobgblcbaonYr88dINix+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6850
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI2LTAxLTIwIGF0IDE3OjE4ICswODAwLCBZYW4gWmhhbyB3cm90ZToKPiA+IFdo
ZW4gc3AtPnNwdCBpcyBhbGxvY2F0ZWQgdmlhIHBlci12Q1BVIG1tdV9zaGFkb3dfcGFnZV9jYWNo
ZSwgaXQgaXMKPiA+IGFjdHVhbGx5IGluaXRpYWxpemVkIHRvIFNIQURPV19OT05QUkVTRU5UX1ZB
TFVFOgo+ID4gCj4gPiDCoMKgwqDCoMKgwqDCoMKgIHZjcHUtPmFyY2gubW11X3NoYWRvd19wYWdl
X2NhY2hlLmluaXRfdmFsdWUgPcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgU0hBRE9XX05PTlBSRVNFTlRf
VkFMVUU7wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAKPiA+IAo+ID4gU28gdGhlIHdheSBzcC0+c3B0IGlzIGFsbG9jYXRlZCBp
biB0ZHBfbW11X2FsbG9jX3NwX2Zvcl9zcGxpdCgpIGlzCj4gPiBhY3R1YWxseSBicm9rZW4gSU1I
TyBiZWNhdXNlIGVudHJpZXMgaW4gc3AtPnNwdCBpcyBuZXZlciBpbml0aWFsaXplZC4KPiBUaGUg
c3AtPnNwdCBhbGxvY2F0ZWQgaW4gdGRwX21tdV9hbGxvY19zcF9mb3Jfc3BsaXQoKSBpcyBpbml0
aWFsaXplZCBpbgo+IHRkcF9tbXVfc3BsaXRfaHVnZV9wYWdlKCkuLi4KCk9oIHJpZ2h0LCB3ZSBh
bHJlYWR5IGhhdmUgYSBodWdlIFNQVEUgdG8gY29weSBmcm9tIGluIHRoaXMgY2FzZSwgc28gbm8K
cHJvYmxlbSBoZXJlLCBidXQgc2VlbXMgdGhlIGluY29uc2lzdGVuY3kgaXMgc3RpbGwgdGhlcmUg
dG8gbWUuCg==

