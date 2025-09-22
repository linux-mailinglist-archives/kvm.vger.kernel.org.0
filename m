Return-Path: <kvm+bounces-58379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0072BB9054C
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 13:21:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE6143BE94A
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 11:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22653304BA4;
	Mon, 22 Sep 2025 11:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K3QWLmG+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9E21991D4;
	Mon, 22 Sep 2025 11:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758540070; cv=fail; b=Qa8Vx/tH4aIcAIHYCYAVeBV/9tTv7t1fGTe3e3zEpEpNKk/p6eXQYjrBy+k3SRZl6m2T4i2S3z/3IEpS55MtfjjGi75uMI2aVXvfBNZrGpddDGoOINrxMugwl8MOpXqFduApDoWvF1cvVQZziHBxjXgHVi6aVNH+RDeINQdgzcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758540070; c=relaxed/simple;
	bh=ioiTj6MdhtqO6JnR80nJRr/Rcj5PG2jzusjjyvIHMBM=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=et4w/Pp0++0GutX+JAvd2bO6L9Jn4So3izFl4puqMMYKzp4FvtzOASdXtPdgLTcZoVDkha8RlT1MG7y2I7mAB/rfgnk74VRLHD5BrDnrPByDRUj679Mo6RTUMoE9M3BUTYDzdmIErg77QFghqcfwvEnV2FKAIneA0MTv9FwuM80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K3QWLmG+; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758540069; x=1790076069;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=ioiTj6MdhtqO6JnR80nJRr/Rcj5PG2jzusjjyvIHMBM=;
  b=K3QWLmG+h93z++82jZ9qxr3Q53qO/lqCeERSlcVYqJN1Mcso9JHWlPSd
   PlXA2fyZ8/QgHIZEBH8Cy8dp54Z4FX1EYg8NYYXVaabEMUXoM79dgkvRg
   CsB3QJ68LGvmkHRNe8htepi/dM2iixuxzlCDJa0XIYP5hvW0vcrYgejBT
   b529kqw5ZDrnrxUgD9RmVN0mrpe6FOrXKDEI+dlD0VHBtew1HA3uvWAyI
   hUEi1a7IjiGzrJg9OIdQR3+XNrnxRDKX99hn1zEcNe0W5c1RGLtCCJzXJ
   7BmCtUUJgGCZDwXFN1kEJjZVZLmheA+KqbFyVjgLqL3HZQevHpxWuPT3E
   g==;
X-CSE-ConnectionGUID: y9J1ShvCTFiMVPYr0pUTNQ==
X-CSE-MsgGUID: SR6sY2NnTFShLxxhGIROXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="78241261"
X-IronPort-AV: E=Sophos;i="6.18,285,1751266800"; 
   d="scan'208";a="78241261"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 04:21:08 -0700
X-CSE-ConnectionGUID: rocDoc64QGSExVG+qdBmqw==
X-CSE-MsgGUID: XSXJpIQVTTebEVLaTOIBUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,285,1751266800"; 
   d="scan'208";a="181700400"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 04:21:08 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 04:21:07 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 04:21:07 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.47) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 04:21:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L8aXpZMTFoaU4ukn8gBQwUNCd6+NPTC9pDVHO0vIfty5pdd/mnp8vod/UtjHx0XDIbmUM+K35jtIm5ms3hb3SMZv/5S27tc4l75FLHHbMmsHzaW/k4G2V3rmyHEl9Jnt2ToXHIwYIXRTH13u0K5X4x8BMX6MxqeHeR5NG8ws0LAeB8BTHC2g2NTCXg5pzgu93UolLBD2ESndEePhwBcDO/8oze/bzbYU4PYYumkrN33Ja2Mx70+AgYCNgxsZ37Z19Pnh2NzLGG1T0u5JEna4gDEBeYTDemYHeymQvDId+or1nyGkkGCW6SmWSqANhxmmR6V5WizWXOQEfFK+8EHMCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioiTj6MdhtqO6JnR80nJRr/Rcj5PG2jzusjjyvIHMBM=;
 b=WnGOLn9xnliQL/gwZ9x5LiL/YW1hUUC+EeNS4+X1fHbRb1iBFxWTz/avhoInDYqNHvug7CSB38cJ56yTt5ZG8QB5b/VFKVbkHWEOyiaqYiDltKCcBBNIwbWSAFjDsuBjKtq8j3lGpQS19TAU6zXoAnU2QWB3NK2EZKbtmkL4sI0iBEC8LPzoRVAChRIdsk7HxIKpZM4/oOpbhspC0wx22pGR123uzX71rDRl9oI/wFBWesI1jOhree541RPyyQ25eQscDelbP04Faz8dfUnQNe2ZNc/4px8WjUBHyXpz+qtcfHfIFVnwb2lqU/27shc/26mBPzCybh0UEofdhPonbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS0PR11MB7287.namprd11.prod.outlook.com (2603:10b6:8:13f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 11:20:58 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 11:20:58 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Topic: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Index: AQHcKPM4drSY0pNBrkCcT+2ZM9x02bSfFAOA
Date: Mon, 22 Sep 2025 11:20:58 +0000
Message-ID: <9e72261602bdab914cf7ff6f7cb921e35385136e.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-13-rick.p.edgecombe@intel.com>
In-Reply-To: <20250918232224.2202592-13-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS0PR11MB7287:EE_
x-ms-office365-filtering-correlation-id: bc8a474e-73aa-41af-8f71-08ddf9ca1a9b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?UDMrVTEvZmg4cTJBN1VQc1NZTFo4ZnJrZUhqNHkwRUVOcGM0Ung0TFp6Qi9k?=
 =?utf-8?B?OHZSL0I2c1NCNmI4WWJiQXFwSGNRSjhUT3NWRHJQZFhBZURxVncrdlpYblNx?=
 =?utf-8?B?Qnp3SmRNbmVRS3JRNkd3U0FGQzNPdkJXSkhoZzZmREJlNEhxcHpNaENUTS9R?=
 =?utf-8?B?cnRqOHQ1TmlRUlBhTmNwNEJLN1VpMDVMWkMxckdoTlk2QllZR1lGT1NFOEFh?=
 =?utf-8?B?L2Rxd2I5VmFoOEFFakxzRkpCZkNFb0pHbVlhbUFGeURZekN4bHdpS21nQ1B0?=
 =?utf-8?B?UmhuQ2tMdUFYS3J6RmRkNjFpR1hDRm9vZTRSK2xNMVRoMGptdXpPb1dKb2o2?=
 =?utf-8?B?MFU5VlE1MkhWZGlzRlNPU3pxQmdIOGs4ek5BR0xHMlM4SlNhQ1RjWDFhbzFL?=
 =?utf-8?B?UjVuWWpVQzBQdHd2bU1pbnNqcFM5K09YMDFtd0RRQnZpQkptbkxFL1d4RkNH?=
 =?utf-8?B?ZGFITVhBL0gzWUoxRndVUERrZU00UWxaRjhPUGdiODJVYitDTk14V0hxbHov?=
 =?utf-8?B?a2NsN01sYzNXVVZ2UzJkUWZSSFloOW1MM3poNENyRnVPVU1MRm9SNXpDb1A0?=
 =?utf-8?B?TGFCMVViUC9yc0d5V1d2eU5UWWpycTgxcVBnM1ZRUXc2MlFJVE11alExODBp?=
 =?utf-8?B?RkErQmpzVGxVbk5Xem9ueU15Ym9Na2g2VGoxd1lXSit1c1Y5YXFGdkd2SXhB?=
 =?utf-8?B?NUhzZnh3WDROTW1MSnhraHJwMHdPL05ZQjhYSm5tVXpZakRQWXJTRHpJYVhR?=
 =?utf-8?B?SENucFVETWd0S2VFTHZGQnNCL05EOHBrZ08zNEU0MEYrZzB1MWNTQ1I5MStG?=
 =?utf-8?B?NzFBTTVaVkJnZHd2L0FjMmI2cUtmOE0xN1FXQjVETkl1UFZLRThmeUFtZTV0?=
 =?utf-8?B?eXJLYmFYdXZDMWhMYjRsRzZWMzZkRVIyMlo0UVNYM2I5QU9PdDZTMnRnSlc4?=
 =?utf-8?B?S053YkdBUU9RZi9SbzZzbGxPaWlraHZrbjVrRWd4K2ZtNXY1NE5laUFQdW1T?=
 =?utf-8?B?QzliOFZFa2dqa0ZQK3gveVBVb2NKelpwMEdjZm82WXJocGRDK0kwMFFLY2Rq?=
 =?utf-8?B?SjhGVHRLbjVYeXlORWtHR3FWMnV5SWI0eU9mZHFoc1UzREtEN3BKSCtMWUhN?=
 =?utf-8?B?U3gyTlBBbUsxVG5yVW1XRWs0V2NmVDNpcDIzQURIZUpBVWNXa0hLVzRlSEp0?=
 =?utf-8?B?WDRYd0dTUFluMXVPRHR0VjBPQWZIYU9kaTVDMnFxSnZVVE9RVkdNMXY4dUhL?=
 =?utf-8?B?SzA3a2tSQlh3UkQ2RGRuVStwSUp0d0t5bUdRdHNhQzZXK21OaXRuR2J4RU5S?=
 =?utf-8?B?S0VPZVNtay9QTFJlRHZ2cnNoc29GRkcxdVlRNndMMzVSUVh1V3NRNGFpRVRH?=
 =?utf-8?B?NVk2WmFFM0JEQlRUdk91U0lpZHVpN3NMNEZhYUtiYXVNemNXZThURzgzWXVK?=
 =?utf-8?B?MW8xeTJyYnlqbTJYdDVjZkc0UmduOG5MclBHVnBWMVU3MjE5ZnFNaU5Rd3Zz?=
 =?utf-8?B?em5DajRrUGF3SWxWenJ2MXVBenhVUENxMFNIOWVaMVZVYnRWV1RjV09xQ2JN?=
 =?utf-8?B?RlpkdnJHaHJPLzdqOTVuQnZhbVJ5V2dOcUY2ZnpJVXVWZ0ZvdE9kVjNGWXEr?=
 =?utf-8?B?TlJDWlVqTVBHM09UK2xSRFBPMGg4Wi9QU0dsckU2TmIvUm81OVJuOFFnWnh1?=
 =?utf-8?B?UFNlS3hpcjlwaEl2djlwbGp3cGNLYXdkNlNKek5Gb25IQ09pREV0Ym5yUkhF?=
 =?utf-8?B?QlB5WW9ybVJYM3dmWCtOT1RJUDJ3WUU4Z3dieU5KbFlYb3hoZWU2Q29iMTlH?=
 =?utf-8?B?TGtFbUVlZXZSMlB4TkZVVFNDYzBLbDM5VWczVklvaVZiZ2FENm1xVTFycHBa?=
 =?utf-8?B?Vy9Dc3cwdmNTNkRhMGREaG1JK09KczQremZTN05SaHZGQkFmU0NKV3ZDL1BM?=
 =?utf-8?B?OEFiSzlFMTBPOVJHUHppRG5HNzV1NHlMVGcvUk81WmlyT1BEWkhkWVFZaEUy?=
 =?utf-8?B?Z0Z1VXp2SVU0VFF5NTJ5L1hNR3ltZGxGM3U1bVhxZHNJUE1pd1NmdzZPc3RW?=
 =?utf-8?Q?41ypeV?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUY5eVFuMDhnTDY0dWNlTm0rSVcrbVN2eDJTUE9YVE02WEcxRTBIUXErNURj?=
 =?utf-8?B?VUdYTFYzMjVnNFYrbGdsV2ZQUFV0QXUrdUdzYW5BbWdhZUtyVXpPZ284Rk9m?=
 =?utf-8?B?ZkNnejhIdE5mN0xKMzRVNnFSTkxPdVhGZ0NjcHIrMng4QkozWlVaMFE2d0Fq?=
 =?utf-8?B?YlhVTU9acGhPMmQzRlRUZjBWWTh3S1hwY04xcTlPeVI2bzcrWnloVUtNZjgz?=
 =?utf-8?B?eWIxaER1SGpIaWFBL202QXEzMCthbU8wZ1hRanMrM3RUamp0bU9HQXloNDBK?=
 =?utf-8?B?MW9WTVowcUF4aFRxd2ZlNTNwS0hrdldLak1EbTA3V0FkbExnTFNWYUgycWpz?=
 =?utf-8?B?TzNpTUZrZDdsclpLT2lLdWo0WnVrVnl6MGdmYVNLRzNSOW9yeGZSU0NBSkNP?=
 =?utf-8?B?UFRPbXNTQmVnQVZlTG8zWUMrQngyM08xdTlaYVJVcytnRWpXQmMvWEJvSHNl?=
 =?utf-8?B?cFB6L0t2WWxOd3UycUUxdkp4OGJBNzR3eXNKVy8yZTBqUUF6TTlBMVkrNWhz?=
 =?utf-8?B?Q1NVeVJhQzBzMlhnLzFxbVozMDNBZ0Z4RGc2WDhXaUE3ZVk3ZFBkMnNiM3NN?=
 =?utf-8?B?RW1kaGVucXJHcVJHN0VQdnorYUtSOXZCaGFnakx5QWFIVkQyM2Y5OGttNXB2?=
 =?utf-8?B?RjRUcHFKeG5MVTlEMmJHcVRLTEpLRklHTkg5OFd6aEhrVkJ2c2hMSWJnSEhI?=
 =?utf-8?B?M3BDbXB5eFJYa0hjemdwMDUyRG1kRmVOQVZ6eGFqeUlWeXB6SFl0LzdTd3VN?=
 =?utf-8?B?Zm5MM2RkSTloMHBaYTFqcE45OWJOZy9EUWw5YTg0LzVvdzVMdWNxL1g5MGtQ?=
 =?utf-8?B?OWRjZUx1VXhidlU5YldiUnVzM3FRWEt1RW9DTVowMnZ4MHloenNHNmVodDEx?=
 =?utf-8?B?dDZtZDl1Skx0QUZWVHFwMDJ0OEpId1NlU0pjYWE3ejIxeldFaHNyYmJ2cENk?=
 =?utf-8?B?dEpOd1RSWjR1TDlscXRlRitJR0xBTkNHOVdTUG52OVdxRGMxa3hjQWN3Q3Nk?=
 =?utf-8?B?OVRpaTNEa0pKZDJGUmJLcSs0V1hwYmNodWVySERQUGJ0MDhsMDg0a1c0aUlB?=
 =?utf-8?B?RTNCcEZSUm81RitPUUhaZlRTakdJUlBsYnFYRGd4L1k0a3pSc3kremVraW15?=
 =?utf-8?B?MzVUWkNTcDdGM3JsWW1GVmNRNVhaaWFMMGFoRjN0ZXRySStKL2tlMG5tY0xC?=
 =?utf-8?B?cEtZRnltOHIybDB3ZmovcTdiYkEwdjhHamhkMndJNjEzNFdmQWxUZ2FsN2Jl?=
 =?utf-8?B?d1h0N01RdWx2WFl4bXlUYyt2ZW1BVFVpcm5mR0VOVGRwMTkxb0VCTkNVV3Zx?=
 =?utf-8?B?VThQcGtXTDdVeXoxUFdzUnRhdzJ2VzVoRnl1VmJpdnhwazVUczRyZzI3Snhl?=
 =?utf-8?B?T3FNTGxXQUVlUW04U2hMeWZ0d3pDMnRYUjA2bG0xcnZrVDh0VDZXalgrMjk5?=
 =?utf-8?B?ek93L3J6M1R0UUxyVTBHVmk3d2poRkI2L1M3ZGJwem9kVkNlTUg1MnJvajh5?=
 =?utf-8?B?b3o3allqVGMrZmYyQ1h4Smw4L0gyUFQ3SW5UQndCUjJ2a3pqVHlmalhadmp0?=
 =?utf-8?B?RmlieEhlK2FDRUJVT3lPRXNLcUVnRHhHekk2YlBQTjY1bE1PUEdoNzZLUDln?=
 =?utf-8?B?YWZRVmMwOVRpZExoU3NSQ3pGQzRQMDlDYUl3RjYxdzNVSEJlTkRhVHIwRG9Z?=
 =?utf-8?B?S2V1YTdTdGppbjd3SkxDY0plTzUyVkZvbi9RZkZTaklGVUFNR01JNzE0T0tE?=
 =?utf-8?B?RkJhc0RuZnBOaVZVVG1ZT1JUV3VXSVpVWEhrZlh2ZGIrVkJpNjhoTEQwSlI3?=
 =?utf-8?B?bFdSOHlSVmtsYjZEMTRMUzRSTFVIOW4xNVdNOW5QaDVzcDQwYi9TQ2dyQVdQ?=
 =?utf-8?B?bWdOUXUwTlRLZVRDd1lmSkFTZXl4WUF1VDJCR2VTcHlKU1VFRVd1UTJBanph?=
 =?utf-8?B?OURDN0VOZUExa0RiZnFqQUZIVWNWZ00zZlYvMnB6VDA4UkZHVVp2Q1VrL3Aw?=
 =?utf-8?B?NGJQUDBINTJnR3AzOSsyeGQ5ZG1wRVc0OHZDNnR5aDNHb3pQSUN3cVlhc1J1?=
 =?utf-8?B?ekRyVUhzZHk4Q3hQRVM2YlprNU1mRjFsNnozS3kzRnMrNmxscVZHbTRrM1B4?=
 =?utf-8?Q?nTC5entKWleyNyx05oVTZoI7l?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68C69CFAC086BB458B84556DC911F617@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8a474e-73aa-41af-8f71-08ddf9ca1a9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2025 11:20:58.1275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FXJy3ft2xna3TfkvD+neBzbI8a6Qhkpn4iWQscg9R8Y9xEa4kXSK691aOFZtcKe+MML+4YP0U6cDUHlZEGcplA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7287
X-OriginatorOrg: intel.com

DQo+ICsvKg0KPiArICogU2ltcGxlIHN0cnVjdHVyZSBmb3IgcHJlLWFsbG9jYXRpbmcgRHluYW1p
Yw0KPiArICogUEFNVCBwYWdlcyBvdXRzaWRlIG9mIGxvY2tzLg0KPiArICovDQo+ICtzdHJ1Y3Qg
dGR4X3ByZWFsbG9jIHsNCj4gKwlzdHJ1Y3QgbGlzdF9oZWFkIHBhZ2VfbGlzdDsNCj4gKwlpbnQg
Y250Ow0KPiArfTsNCj4gKw0KPiArc3RhdGljIGlubGluZSBzdHJ1Y3QgcGFnZSAqZ2V0X3RkeF9w
cmVhbGxvY19wYWdlKHN0cnVjdCB0ZHhfcHJlYWxsb2MgKnByZWFsbG9jKQ0KPiArew0KPiArCXN0
cnVjdCBwYWdlICpwYWdlOw0KPiArDQo+ICsJcGFnZSA9IGxpc3RfZmlyc3RfZW50cnlfb3JfbnVs
bCgmcHJlYWxsb2MtPnBhZ2VfbGlzdCwgc3RydWN0IHBhZ2UsIGxydSk7DQo+ICsJaWYgKHBhZ2Up
IHsNCj4gKwkJbGlzdF9kZWwoJnBhZ2UtPmxydSk7DQo+ICsJCXByZWFsbG9jLT5jbnQtLTsNCj4g
Kwl9DQo+ICsNCj4gKwlyZXR1cm4gcGFnZTsNCj4gK30NCj4gKw0KPiArc3RhdGljIGlubGluZSBp
bnQgdG9wdXBfdGR4X3ByZWFsbG9jX3BhZ2Uoc3RydWN0IHRkeF9wcmVhbGxvYyAqcHJlYWxsb2Ms
IHVuc2lnbmVkIGludCBtaW5fc2l6ZSkNCj4gK3sNCj4gKwl3aGlsZSAocHJlYWxsb2MtPmNudCA8
IG1pbl9zaXplKSB7DQo+ICsJCXN0cnVjdCBwYWdlICpwYWdlID0gYWxsb2NfcGFnZShHRlBfS0VS
TkVMKTsNCj4gKw0KPiArCQlpZiAoIXBhZ2UpDQo+ICsJCQlyZXR1cm4gLUVOT01FTTsNCj4gKw0K
PiArCQlsaXN0X2FkZCgmcGFnZS0+bHJ1LCAmcHJlYWxsb2MtPnBhZ2VfbGlzdCk7DQo+ICsJCXBy
ZWFsbG9jLT5jbnQrKzsNCj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gMDsNCj4gK30NCg0KU2luY2Ug
J3N0cnVjdCB0ZHhfcHJlYWxsb2MnIHJlcGxhY2VzIHRoZSBLVk0gc3RhbmRhcmQgJ3N0cnVjdA0K
a3ZtX21tdV9tZW1vcnlfY2FjaGUnIGZvciBleHRlcm5hbCBwYWdlIHRhYmxlLCBhbmQgaXQgaXMg
YWxsb3dlZCB0byBmYWlsDQppbiAidG9wdXAiIG9wZXJhdGlvbiwgd2h5IG5vdCBqdXN0IGNhbGwg
dGR4X2FsbG9jX3BhZ2UoKSB0byAidG9wdXAiIHBhZ2UNCmZvciBleHRlcm5hbCBwYWdlIHRhYmxl
IGhlcmU/DQoNCkkgZG9uJ3QgdGhpbmsgd2UgbmVlZCB0byBrZWVwIGFsbCAiRFBBTVQgcGFnZXMi
IGluIHRoZSBwb29sLCByaWdodD8NCg0KSWYgdGR4X2FsbG9jX3BhZ2UoKSBzdWNjZWVkcywgdGhl
biB0aGUgIkRQQU1UIHBhZ2VzIiBhcmUgYWxzbyAidG9wdXAiZWQsDQphbmQgUEFNVCBlbnRyaWVz
IGZvciB0aGUgMk0gcmFuZ2Ugb2YgdGhlIFNFUFQgcGFnZSBpcyByZWFkeSB0b28uDQoNClRoaXMg
YXQgbGVhc3QgYXZvaWRzIGhhdmluZyB0byBleHBvcnQgdGR4X2RwYW10X2VudHJ5X3BhZ2VzKCks
IHdoaWNoIGlzDQpub3QgbmljZSBJTUhPLiAgQW5kIEkgdGhpbmsgaXQgc2hvdWxkIHlpZWxkIHNp
bXBsZXIgY29kZS4NCg0KT25lIG1vcmUgdGhpbmtpbmc6DQoNCkkgYWxzbyBoYXZlIGJlZW4gdGhp
bmtpbmcgd2hldGhlciB3ZSBjYW4gY29udGludWUgdG8gdXNlIHRoZSBLVk0gc3RhbmRhcmQNCidz
dHJ1Y3Qga3ZtX21tdV9tZW1vcnlfY2FjaGUnIGZvciBTLUVQVCBwYWdlcy4gIEJlbG93IGlzIG9u
ZSBtb3JlIGlkZWEgZm9yDQp5b3VyIHJlZmVyZW5jZS4NCg0KSW4gdGhlIHByZXZpb3VzIGRpc2N1
c3Npb24gSSB0aGluayB3ZSBjb25jbHVkZWQgdGhlICdrbWVtX2NhY2hlJyBkb2Vzbid0DQp3b3Jr
IG5pY2VseSB3aXRoIERQQU1UIChkdWUgdG8gdGhlIGN0b3IoKSBjYW5ub3QgZmFpbCBldGMpLiAg
QW5kIHdoZW4gd2UNCmRvbid0IHVzZSAna21lbV9jYWNoZScsIEtWTSBqdXN0IGNhbGwgX19nZXRf
ZnJlZV9wYWdlKCkgdG8gdG9wdXAgb2JqZWN0cy4NCkJ1dCB3ZSBuZWVkIHRkeF9hbGxvY19wYWdl
KCkgZm9yIGFsbG9jYXRpb24gaGVyZSwgc28gdGhpcyBpcyB0aGUgcHJvYmxlbS4NCg0KSWYgd2Ug
YWRkIHR3byBjYWxsYmFja3MgZm9yIG9iamVjdCBhbGxvY2F0aW9uL2ZyZWUgdG8gJ3N0cnVjdA0K
a3ZtX21tdV9tZW1vcnlfY2FjaGUnLCB0aGVuIHdlIGNhbiBoYXZlIHBsYWNlIHRvIGhvb2sgdGR4
X2FsbG9jX3BhZ2UoKS4NCg0KU29tZXRoaW5nIGxpa2UgdGhlIGJlbG93Og0KDQpkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9saW51eC9rdm1fdHlwZXMuaCBiL2luY2x1ZGUvbGludXgva3ZtX3R5cGVzLmgN
CmluZGV4IDgyN2VjYzBiN2UxMC4uNWRiZDgwNzczNjg5IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9s
aW51eC9rdm1fdHlwZXMuaA0KKysrIGIvaW5jbHVkZS9saW51eC9rdm1fdHlwZXMuaA0KQEAgLTg4
LDYgKzg4LDggQEAgc3RydWN0IGt2bV9tbXVfbWVtb3J5X2NhY2hlIHsNCiAgICAgICAgZ2ZwX3Qg
Z2ZwX2N1c3RvbTsNCiAgICAgICAgdTY0IGluaXRfdmFsdWU7DQogICAgICAgIHN0cnVjdCBrbWVt
X2NhY2hlICprbWVtX2NhY2hlOw0KKyAgICAgICB2b2lkKigqb2JqX2FsbG9jKShnZnBfdCBnZnAp
Ow0KKyAgICAgICB2b2lkICgqb2JqX2ZyZWUpKHZvaWQgKik7DQogICAgICAgIGludCBjYXBhY2l0
eTsNCiAgICAgICAgaW50IG5vYmpzOw0KICAgICAgICB2b2lkICoqb2JqZWN0czsNCmRpZmYgLS1n
aXQgYS92aXJ0L2t2bS9rdm1fbWFpbi5jIGIvdmlydC9rdm0va3ZtX21haW4uYw0KaW5kZXggNmMw
N2RkNDIzNDU4Li5kZjJjMjEwMGQ2NTYgMTAwNjQ0DQotLS0gYS92aXJ0L2t2bS9rdm1fbWFpbi5j
DQorKysgYi92aXJ0L2t2bS9rdm1fbWFpbi5jDQpAQCAtMzU1LDcgKzM1NSwxMCBAQCBzdGF0aWMg
aW5saW5lIHZvaWQgKm1tdV9tZW1vcnlfY2FjaGVfYWxsb2Nfb2JqKHN0cnVjdA0Ka3ZtX21tdV9t
ZW1vcnlfY2FjaGUgKm1jLA0KICAgICAgICBpZiAobWMtPmttZW1fY2FjaGUpDQogICAgICAgICAg
ICAgICAgcmV0dXJuIGttZW1fY2FjaGVfYWxsb2MobWMtPmttZW1fY2FjaGUsIGdmcF9mbGFncyk7
DQogDQotICAgICAgIHBhZ2UgPSAodm9pZCAqKV9fZ2V0X2ZyZWVfcGFnZShnZnBfZmxhZ3MpOw0K
KyAgICAgICBpZiAobWMtPm9ial9hbGxvYykNCisgICAgICAgICAgICAgICBwYWdlID0gbWMtPm9i
al9hbGxvYyhnZnBfZmxhZ3MpOw0KKyAgICAgICBlbHNlDQorICAgICAgICAgICAgICAgcGFnZSA9
ICh2b2lkICopX19nZXRfZnJlZV9wYWdlKGdmcF9mbGFncyk7DQogICAgICAgIGlmIChwYWdlICYm
IG1jLT5pbml0X3ZhbHVlKQ0KICAgICAgICAgICAgICAgIG1lbXNldDY0KHBhZ2UsIG1jLT5pbml0
X3ZhbHVlLCBQQUdFX1NJWkUgLyBzaXplb2YodTY0KSk7DQogICAgICAgIHJldHVybiBwYWdlOw0K
QEAgLTQxNSw2ICs0MTgsOCBAQCB2b2lkIGt2bV9tbXVfZnJlZV9tZW1vcnlfY2FjaGUoc3RydWN0
DQprdm1fbW11X21lbW9yeV9jYWNoZSAqbWMpDQogICAgICAgIHdoaWxlIChtYy0+bm9ianMpIHsN
CiAgICAgICAgICAgICAgICBpZiAobWMtPmttZW1fY2FjaGUpDQogICAgICAgICAgICAgICAgICAg
ICAgICBrbWVtX2NhY2hlX2ZyZWUobWMtPmttZW1fY2FjaGUsIG1jLT5vYmplY3RzWy0tbWMtDQo+
bm9ianNdKTsNCisgICAgICAgICAgICAgICBlbHNlIGlmIChtYy0+b2JqX2ZyZWUpDQorICAgICAg
ICAgICAgICAgICAgICAgICBtYy0+b2JqX2ZyZWUobWMtPm9iamVjdHNbLS1tYy0+bm9ianNdKTsN
CiAgICAgICAgICAgICAgICBlbHNlDQogICAgICAgICAgICAgICAgICAgICAgICBmcmVlX3BhZ2Uo
KHVuc2lnbmVkIGxvbmcpbWMtPm9iamVjdHNbLS1tYy0NCj5ub2Jqc10pOw0KICAgICAgICB9DQoN
Cg==

