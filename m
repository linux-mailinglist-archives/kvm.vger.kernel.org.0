Return-Path: <kvm+bounces-59023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F00DBAA398
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 19:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F35491C6DD2
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 17:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2BC21A95D;
	Mon, 29 Sep 2025 17:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QkJwa57P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A285533EC;
	Mon, 29 Sep 2025 17:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759168074; cv=fail; b=uJQn97zcw2w0aAKV/6ARQ4tpXM8zg0JJEuNdGAw4PsLar9HIc+aYryg4uYKfjUWKGNy4rPwlr6Ov7uoAduvJor7TYvY9N9/wbWRmepwDHBXnXU1faa7/iTCvNYGy9Lzw1ytLqaJm5AW7xNBULOhF10irgEugcGwE1/Fo9u9kI+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759168074; c=relaxed/simple;
	bh=erjG6rQSyOCP0KxvbPn+H//VBy7wLDTfYbJn2cVoNSk=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OFMGMusKGRlshAqMtPvso8FG9OqoXMDAyvtkfdQHISVussBZQIW8qZGyDmlJSjNSIysV6fEXUT9skF4cLjxPT/xgZVzpfAtpQiVw3Ff2cvxd8TmTpZq+cLyfY7qI8beGAWQVYHpak5qJ7BEPKZY+weLqKyP2Z/pE4h6aeB6CEag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QkJwa57P; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759168073; x=1790704073;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=erjG6rQSyOCP0KxvbPn+H//VBy7wLDTfYbJn2cVoNSk=;
  b=QkJwa57PX/yQHizA7G/NPoKCsaMGzusy16ZVzCzwZPV1uUyXUmRE2iT9
   Qqtfya4Y10p58W5DNt4K5VW8pkrWU1dguzrGnrz2VDsmtM9smQ1lBPxyv
   lAnTplL5jDOZpzDcFxZKRBx2vryqb35y6DKHhjnSqUc2xfVC1ja63Pv6l
   qK2AkkNDgkmWHFIbk3vL+LtdDl2UCNCCflezA6RWo1+DIf8d1m/FDZlR8
   4meXn14s3LsUoSlcIXE0lP6Pwp3OVwU6UG5Sh+ZS1K73jCQHZmRyjArxe
   Xg8MuJgcN/brYtiKQdxU7xk+kGiaOm6mx9XcEGAANcHbDcwlSOC7L4ZJd
   A==;
X-CSE-ConnectionGUID: XZRB1hskRBCaH7hZxzXlcg==
X-CSE-MsgGUID: DfOEbiHXQ4ewWhw5KIw+BQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61329175"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61329175"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 10:47:52 -0700
X-CSE-ConnectionGUID: fqH9bwjaTuelE4hf3l2xcg==
X-CSE-MsgGUID: Ih+HwpF3QZGamppPkPoqng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="177418890"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 10:47:53 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 10:47:51 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 29 Sep 2025 10:47:51 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.65) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 10:47:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ChXT9b4blL94aeBmq1k+bDuHLmYrSLK6iZoSo5xlNUdRlSZYcLBh1oG/mPBlPVaMiwezGzevjzSARuxxbBht6C4sMluadNgCIqJKXU6yF+vvngEPcrhDig00pUGPq6i3PLfqDfELcAAAMEmEDEh4w773PHst4CCsKZfjyg9HDzerRkOFS9/pr15qI7mjg3hX+Wn8INv4tjn2eSIqy+2NiBt/+g+KnvZrv8IjjqUGBZh43mOid5N/ngiuvYq8MYIOFEuJgSBLAvrfet1sBZ1i9Zgs5HYhu7R4wpF4mIyu+v/WguadVJuqIZWqmf6t0Btjc8Yi8cUhL3BTbvuSdF763w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=erjG6rQSyOCP0KxvbPn+H//VBy7wLDTfYbJn2cVoNSk=;
 b=nIKZtfEMM6l3v60/UgUwHvkCVRikF2TIXqEj8uujUgxqoxdXse84JmHG/tzfkzr9s+dIr+baHv1EanD4ecFYvPq5QArI/bDvGHDPSkuDu8zexxRvEta7uH/5yzp5MvubU0zUZUo8k8RJZZc2i5nvRzH/4F6YfkWnaiwumEYrffGRhlU9BwGeUzaQEISNg3dMi4ylpRsaJwldpGWTpV80Wm4Iz6UQqKN7HiV7lTGtGBjUQ396zgQqaP3f947ath5lBMY6Wdgk0PtT/XiIDVOsDUn+2WpTO4ZDiAJk+gTBkqG6RmQCeYZB8Ph2crw8truDhEG6f0aE4NLbLMXa/eaDDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7337.namprd11.prod.outlook.com (2603:10b6:930:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Mon, 29 Sep
 2025 17:47:45 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 17:47:44 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 03/16] x86/virt/tdx: Simplify tdmr_get_pamt_sz()
Thread-Topic: [PATCH v3 03/16] x86/virt/tdx: Simplify tdmr_get_pamt_sz()
Thread-Index: AQHcKPMyjmTRPc/hA0eIYW6zTP3tSbSZrNEAgBBuL4CAAGVrAA==
Date: Mon, 29 Sep 2025 17:47:44 +0000
Message-ID: <090314f1cf49e029b77730f7ead8b028a7acc524.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-4-rick.p.edgecombe@intel.com>
	 <1c29a3fdbc608d597a29cd5a92f40901792a8d7c.camel@intel.com>
	 <d5bfd8bf-2d28-4e79-90c8-bdca581e8000@intel.com>
In-Reply-To: <d5bfd8bf-2d28-4e79-90c8-bdca581e8000@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7337:EE_
x-ms-office365-filtering-correlation-id: 7f7a6421-0234-49d1-2e47-08ddff804bc3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?aEc4K21ZWjY3bFFyeGVqcUR5Tng2ZVNZMnBnMTR6RlFmQkRUVFJTOW1pNEFB?=
 =?utf-8?B?WENMMXk0MlJSR0tNRmNaOG9sTVcwTVErWVhDSDBRUjNzZHJRd1hTd0VlWkkr?=
 =?utf-8?B?clBzNDh0bVloN3dDYlJacHZNNEx0NE5VeVArcEtiTDJMb0pBaFNWNW14aE9z?=
 =?utf-8?B?MTRzcjVkSStTUlZ1ajEyL096UnAzNmZKN3RrTXBRSHlSd01MTTN4RnRGZlgx?=
 =?utf-8?B?U29EQjFGZldHZ0o5eElVZmZENUM3SlVDRk9yQXVLNGx0NzBLaHI2VTM3aDU0?=
 =?utf-8?B?b3VPUzBKWE1jVzY0ZlJlUW12bnBodElFSjdQcVNuUVd3dVFPaUJZWmhTcUEv?=
 =?utf-8?B?ZjVLT2pKV3lkaDFLcGxiNGdCVW9EbnE0ZGxTY004TjV6eERyU2s0Zmx5QWRl?=
 =?utf-8?B?R0wzUERVWHQ5a1VSc1FoVTdsc2tWaWFpbSsvYUJSRkdCQkRyRVlCZk5iSzMx?=
 =?utf-8?B?SEtlQlEvVks1anF1dkZNUzlDblc5V2xiSnFCOEdscTIwUDAzK25ZT0p2WjNC?=
 =?utf-8?B?NmpUMTVJUEg1NHNVVDdweHZucWhMMGZiTTcxZUozSTkyQ2VVOWRTbkxWMDZo?=
 =?utf-8?B?LzZZcWRJNXRrcyt2Q2xtSnZkdWVncFdEZDByQ0owQXFySksxVHkzS1JnaDVQ?=
 =?utf-8?B?a0x6NnRDY3AxUGc0TFBrTlczbm1odHRwMWhiUktEMFRMb2dRUXMwYndoK2t0?=
 =?utf-8?B?NEJQcHJoVytVUUxBUHdscllzWFJJMENTbEx0YkVVY2R4bEZLQTVXalFxM0xu?=
 =?utf-8?B?QXcvVW9sdktHcmhPaVJ2TFRsbmRTQVp3TUo1M1JNVkNNdmtnOUR6SVcrbTZi?=
 =?utf-8?B?MFIvQjBBZ2ZYMGhGQVlPekNTR0VnVjhnOGZXcjdVUlJ1aXZsOHVrd3VXYXpl?=
 =?utf-8?B?OEU1MnNMazI5cm5WYmNTWEozbkpyZnorY1doZmxVaWJXSXQ1V2E1amhDSWlw?=
 =?utf-8?B?UHVYVEJwN3N4aDQ5SVkvLzN6L205ZVdHRk5BTGV0VDl0NHV1OTg1dTlGT2Fx?=
 =?utf-8?B?WGh6akpiYU5hemdwU2xaeDdoNW90UDV1cXVRTFdhZzJ6VCt4N2RvS0pMZHFD?=
 =?utf-8?B?MHJvSG4wNXoxa2o4TkN6dUFLbm9tYU1ZQU5GOUhqTWhSeXAvamt4dWw3WC8z?=
 =?utf-8?B?dExxdWZ0elE4eFJNcVdkUkRLQzduTm5kTVVRMStiSjgzdVlKSmFLbEJnMDFC?=
 =?utf-8?B?Rk1MYmlialVieTRsTi9idEZGSXZJL2ZrOThoQ0dyK0Z5U29jRGcrb1JqZDlU?=
 =?utf-8?B?M0RXWkVjY2ZySDI3RXE3ZGZYY05lV3FMY1FuNnB2TDVWT0phanZkcEZTSHB4?=
 =?utf-8?B?SE5rUVVORnVuclhxVGxUTURubzYzRnpZckdvZ3kyV0xHcVgzYkNGK0hxQjB4?=
 =?utf-8?B?REQzaWhXVEFHRUxpYUVPenc3S1BDZXlOQWptZ2RNMnJCamFtQjRGS0hiWUxl?=
 =?utf-8?B?THpkVzlZL25hd1IvMG9QWVVkNkR1NmFMNGRBSlZtRDM1OTcrbW9DZlFTOEw3?=
 =?utf-8?B?UXFad1NlZjNGTTdCemcwdUhlOUYzdjgxLzlWU1ZZbHNiUWNCN29kalFrZldY?=
 =?utf-8?B?bzN3ZXBWODhwemFsaTRoSURoMXNmR1RPc3hrck5ZM2dZVk5ZNUt6anRXclJU?=
 =?utf-8?B?U0pNcVdSNFFmcW5iOFVPZ1B5cHpQbnptd2FyLzhjYThFQStNNDlKb05id1Fx?=
 =?utf-8?B?b0FhMCtGV1RIM3N4aFVTMDlQM3VZVGkrU2VyS1ZIck5qOHFwcVI4T3ZBeE1j?=
 =?utf-8?B?WkZ2d2p1UFNvOVdxMlRBTVd6emVwWHZCOGZnUG8wVUZ5Um8rY25WQUUxcjVP?=
 =?utf-8?B?bE5lbDVhcXo0aUZmb3JrcWlaYTlReHV4WnRzRnYyY3l1UVJxT1BQcnN5NU95?=
 =?utf-8?B?VlJuWEgrRUlZcStwSVcxVlBiT2JQcFZpR0kxNWJhdXdreDNEOWtlNFlpSit3?=
 =?utf-8?B?OVJ2ZXN5dEtEUEs0NXhGNkN6eXJBMUt0T2RRM0w1ZjBkZ3lKYkEzMk85LzFV?=
 =?utf-8?B?TXloNzMvLzF6d09NVis5NWxzRmY1bzhyREVVYUlDeitRdGhLeVJFalVvWFpq?=
 =?utf-8?B?cVY4OGFTWm9UNGtsbGNQcTE1UU1aS3BwNSs0UT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ekc0U3k4SzhPNFdqelZGajRDNWFCbUNKYUJ1eTNyblZsSFhIdS9GNGdKSTMv?=
 =?utf-8?B?Rks1K1VwRUlOZ3ArVDl2RlgzNjlpNlNsTWtWNk8yZVNtMXdDdUN6dnhLcS9Z?=
 =?utf-8?B?cGhkQ0NsY1IxS2dtYVRtdUZSR2U0RjBVZnNqU2dhalNSQUwwZGdKYUVHRkhp?=
 =?utf-8?B?M1dsSGxiOWZrdU4rQ00xenNKZ2c4ZVdlNkE0dlVueG5Tb0htTTBQZjZvcEZK?=
 =?utf-8?B?UEdJUXRwWlVqdmRBUnBMRXZaL2lTc0hXUFdjZzJCaHhEcVZiUC9sY3ArYVdl?=
 =?utf-8?B?YWxZaGNESnRMMHdoSzQ2NmlNRVhKRmk4aUFseE9NNjBJWVZxUW1QcUJQNFRF?=
 =?utf-8?B?b3FRZmUxbWdrRllsV0IrT0VWNFMvaC9FanJhcWgrU0QrQWkydGJzcm5KbHBZ?=
 =?utf-8?B?cEJQajhuMUFjU2JpWjhtYlFpai9tOUpMQ240OWczRmVUUXVTL0FSUDY2SXFB?=
 =?utf-8?B?QVJpWXhadVdTajErTk9jY3RhSlhhYzBLOEhqQmEvaWlYL2JvYys3aXEyV1Vn?=
 =?utf-8?B?bVFVM3p5Q1ZwbTlJbUVZMG9EOGtVSXJCTGpiSDRQYy9SUWY0cHBwRDkxcm5u?=
 =?utf-8?B?c2Fsc1lzMkViSk9BVG5MSTQ2aDJ3aythS0FELzJxZVRCenVucGpPd2d1c0cv?=
 =?utf-8?B?emRqNmZsR3I0WEpHYnFxSnNMdlJhTFZpUENrbHAzeUpvdXU0bzFzdktUTnYy?=
 =?utf-8?B?dXNEZkFENVYyWHIvM0RxSWpXUDhZcUNJNlNGNjJkemxneUM0MGMwT2NsV2Jz?=
 =?utf-8?B?Mkx6K2RIRGRZa3lxZHl5TFZWUnI2MkxieTRDaVltU1l5eG1KTXdDSnVsTE9O?=
 =?utf-8?B?K09SZy94TkcwK3JERUZ0NHhZOGg0NWxCWXZidGE2b1hicFN3ekJpZFlhZ01q?=
 =?utf-8?B?RXhWYnFNN2ovM1UyaUJUUzFVejIzeFNlN1plNlZNZmhQck9XUlg0c3BvUDJF?=
 =?utf-8?B?OG16anN6WUpEZmhOcDJBZ2hpZTBHSnFBNnlzbVk5c085SXRvTmYzNEpUbVFL?=
 =?utf-8?B?aTBHcEgvNmdJT1BGUU1KNU5lNlc4b1FqdnFLUHdVWC9ZWnkxMEhQM3JrQkhm?=
 =?utf-8?B?S0pzTzE4Z0E5ZUNjRm1SekdvaU1kRmQvMWlXaExzam9NVVFtVlVIeG9aSjYv?=
 =?utf-8?B?T21PNUc1S0IxNXVERTdMNXl4eUJ6bjFrWWhNNWdCMzJyMXJ0NlMvVkhkY1Yy?=
 =?utf-8?B?bEhmZWtJUFJGT3VBczl3MDU5V1hDcU83N3luRlR1RHNhYnVNN0lvcDlzTVFx?=
 =?utf-8?B?RnNWOEhpRGZZOE9zeHhCczJseVN4NlZyd1htb05DWFNJSEIycE5vT2VmY3pj?=
 =?utf-8?B?Yzc4aXhGbGY2d3ZndEpQODUrS01JM1JrZUozekQxUTczOEJzVXhwUmRUU1pu?=
 =?utf-8?B?TGl5eGZjN25lWXY0NzVkejZMZUhlRC9jWjdIcXpoMys4RkNOL2dueHFwRXR3?=
 =?utf-8?B?UDlCd1Y4a2xqSDZtUkNOSzhrREVwUmZFMmtCQzhZa2tOS3l1M29sR0ZqS2Ji?=
 =?utf-8?B?c2NyaWVyUUI4VHBFSXdicEl2aFlyOTh5OXpWRWtSQTZNc2JwUDYxd2Zabm1E?=
 =?utf-8?B?Q0J6TFhiZDEwb2piZW51eVN2Ky9IcGhHNjZWeGh4b25LcGRoSzlNamFyMTZa?=
 =?utf-8?B?aVU2eWkwWmdENTZ1cCtmdVB0bXd4RGd6bGVHS1Z0QzhLblBnSmRNelBzZXRi?=
 =?utf-8?B?QmZZZDdManhFbFJzY0lGUEZUc2luUE51UzhHRk5wako3SVFWMk9TcUNGU3hy?=
 =?utf-8?B?bExuRlh0ajVzS25RVFJhMHk3TlRFRjFJZEt4aWlGY3RYK0tvOHM1ejNyQXNY?=
 =?utf-8?B?ZDNNUVVhODFnSDhQcVZuazZ2MnN3TVdkMVVpV3JsSmpmZnZ4YSs3V1hZdnNv?=
 =?utf-8?B?N1NBR0kxRGZXZzVQZEZsOGJycXJyOWtCYzV0bEtGTHJlT2ZneFg3VTNwWmcr?=
 =?utf-8?B?d0dBOVpCTU5KSnN0TGExNzhCaWRrQy9uYzFhSi9UaWRtbnJTbkRkNlJ6WGtO?=
 =?utf-8?B?Z2pudzF2QzN4c1NDRm1kSlkxc2w3OGVBbFhsR1NZQUh1R1gySUF4dzUzY0ll?=
 =?utf-8?B?Q1pVeVBRczUwNlhyNG9tc3Z2UjBmSmtzMDhQRWdRTmI3K1lJUnpQUVZ0VXZy?=
 =?utf-8?B?aENpVnJWNklrb1RGVTZHNEo3MDk3VW8ySTNiVVJCNzFFTVIyQXpjSUk1MTNr?=
 =?utf-8?B?Zmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E17A42293B4602458086271BF2138DC5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7a6421-0234-49d1-2e47-08ddff804bc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2025 17:47:44.7818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aOJN/fLhJYzDlr/XS1VgaXffjHQjfDOq7n1A/Xc/WAIVloIod8j6x41UpndnbreyN7m7QLxmbOiKyUd1sc6wm9E6Z1lL2t8XIN8Jz73vqVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7337
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA5LTI5IGF0IDE5OjQ0ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiBP
biA5LzE5LzIwMjUgODo1MCBBTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+IMKgwqAgc3RhdGlj
IHVuc2lnbmVkIGxvbmcgdGRtcl9nZXRfcGFtdF9zeihzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yLCBp
bnQgcGdzeiwNCj4gPiA+IC0JCQkJwqDCoMKgwqDCoCB1MTYgcGFtdF9lbnRyeV9zaXplKQ0KPiA+
ID4gKwkJCQnCoMKgwqDCoMKgIHUxNiBwYW10X2VudHJ5X3NpemVbXSkNCj4gPiBBRkFJQ1QgeW91
IGRvbid0IG5lZWQgcGFzcyB0aGUgd2hvbGUgJ3BhbXRfZW50cnlfc2l6ZVtdJyBhcnJheSwgcGFz
c2luZw0KPiA+IHRoZSBjb3JyZWN0IHBhbXRfZW50cnlfc2l6ZSBzaG91bGQgYmUgZW5vdWdoLg0K
PiANCj4gV2hpbGUgd2UgYXJlIGF0IGl0LCBob3cgYWJvdXQganVzdCBtb3ZpbmcgdGhlIGRlZmlu
aXRpb24gb2YgDQo+IHBhbXRfZW50cnlfc2l6ZVtdIGZyb20gY29uc3RydWN0X3RkbXJzKCkgdG8g
aGVyZT8NCg0KT2ggeWVhLCB0aGF0IGlzIGJldHRlci4gDQo=

