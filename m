Return-Path: <kvm+bounces-55801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 180B2B3758C
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 01:32:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE0FF5E13AC
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 23:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09B5305E0D;
	Tue, 26 Aug 2025 23:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OUAA0+q/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE9530CD94;
	Tue, 26 Aug 2025 23:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756251114; cv=fail; b=uSCmCXa0s/xUDNHGhsViu7aHnBcAKvV01dplqVzZt3DuYZWHzQpwTT27FnNcGKmLVhNNPZ5o/MmJ32TWtqIWY1jMBIVQbzLW5yZVXmGYmiuGf5QrQyoGBoF6CVn6VAR1ezuM9M4zJs611x/QML3axIPIO2b8CUa9TxquJmYtb4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756251114; c=relaxed/simple;
	bh=U1zRIT8ivUbsDhaXbrne7TO80kkJZ4lViLJ9NjPjfFI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hc9d3kdhpzlH/pnPZ/333Gjh4yJQRQm0ESoZrNEmIvYe0kcnc4r96UmAahwnio8U0y3LLbbZzyc2rk7zdAKtVJBF5sKhyDyKIKJEMmmTzNQxKot9Uan7P4lahCZj51pIiJ6whHHDpFani+ABpkfCfWrHM6aaLoxZLE3fKev9zIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OUAA0+q/; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756251113; x=1787787113;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=U1zRIT8ivUbsDhaXbrne7TO80kkJZ4lViLJ9NjPjfFI=;
  b=OUAA0+q/7xlyTTR9c7HI1lBjuZiQLEWmo9SbnyNYO+QjFO1g+0b7vo9p
   NA0eGwkupcJyaHqhYmrfb9xIbW/CUKFAXhnbmUi5Z0qFwONnMTA8e7Sp8
   jUYVugiMo3AneaMMJ6C6Vda6Csg7Ujo1O745nOKhl4gsoI6KxRto6GYm1
   kvWPbKPsykqUZTUszURAwxfheADqvHTgP5pM00owZv3NGe6AnvaixjRMV
   p6FXZzgGKplbsdLPaSnwkMk7Z4LvfpGV2fCeMYHqPAhjfpIv/PQa7Gkc8
   LDhsc7iEU4v/HVSJQa/HhEVcoN9PeCUyM0Sqz0paDb/k2UqtSmuRf1+qB
   A==;
X-CSE-ConnectionGUID: 6Stt3JuQRPS8Lda9PyjZsA==
X-CSE-MsgGUID: YGNNoDmlQbG3yTEdkbbFEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58442183"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58442183"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 16:31:52 -0700
X-CSE-ConnectionGUID: C7wKfch2QJSVGDo1WLL+Ew==
X-CSE-MsgGUID: 91spBDg6SVOzHqKbvxyYhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="193355182"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 16:31:51 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 16:31:50 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 26 Aug 2025 16:31:50 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.74)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 16:31:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k+b7R11aR0SN0eFQVQTFIR4mPvh5l6tTgjojODjoWpNp5uh3myqr5lo9l56mWc+5wTeT5wKOXrerO5GfQ4eRSslxaDjbUaKp5t1Uk+lO/4r2m54PU/Wxafw2SS5dVgHqZ9vDuZjVdKcOqVjZl14ghsNMwyOHxzSbt6oxui2Tno2bbqMod/m8KwYAa9lt8zN3o2cVi3UfIZ7Xw90Imvst531lXcupOrSs1t2n6h+QmJfyRnaUJfcIJXDcMLZVz+/ANOc4jobIbKXA/Iolw9IkH0WZuG3E3KXuixuT448UPRsigM+NgQZrmJL/JeZafbsfIJTlGKUvdzhLm28TLRdUDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U1zRIT8ivUbsDhaXbrne7TO80kkJZ4lViLJ9NjPjfFI=;
 b=o+QG/hfIcM28GHiaqCLlnUt82iefx64O/J7ZGJXyhPMoI6xTVmM86Rdd3HtWDBnQ3CEnqvT3Q9Lfukk6qQFLEx7sOruX+VuNphPY/l21IG06xRFonkuDbaOz+SVGHUTchEI8X+CfaxXPyJMCZz2RwwYdbyH8UD/AeB04BAoZwIjkrVORbCyJ/Qr8mZyCdoxLL/gRKFV4bA7fabsGX6ZGMK6RW3kNYx7BfVQ4MCy0VlABVSHfUVpMjC8oS6jXSQA8ck0ZBCQyb6jS/WOrQ69YnVRE4/abwcwKfbqQbHzWIMp9v7vH7TjMpptkdqG3A57amy68FEd8AMuhDR0bDVqX9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM3PPF67FA1A8F8.namprd11.prod.outlook.com (2603:10b6:f:fc00::f28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 23:31:47 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Tue, 26 Aug 2025
 23:31:47 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"kas@kernel.org" <kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Gao, Chao"
	<chao.gao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v7 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Topic: [PATCH v7 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Index: AQHcFhP3CyE99wtnl0a+2a1LRoTPzbR1LHOAgAACOICAAGhZAA==
Date: Tue, 26 Aug 2025 23:31:47 +0000
Message-ID: <95f75d0e10a78537b82d97c1b372a3d6d8d4faa4.camel@intel.com>
References: <cover.1756161460.git.kai.huang@intel.com>
	 <14f91fcb323fbd80158aadb4b9f240fad9f9487e.1756161460.git.kai.huang@intel.com>
	 <aK3qfbvkCOaCxWC_@google.com>
	 <a578e3b5-9fd3-4f69-943f-9415f4047e19@intel.com>
In-Reply-To: <a578e3b5-9fd3-4f69-943f-9415f4047e19@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM3PPF67FA1A8F8:EE_
x-ms-office365-filtering-correlation-id: 98340ae1-f65c-41c6-0f12-08dde4f8b9da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dnBBVnVXY0E3TEtPQmp2V0VqcGZwQ0YxbzBLOCt6cEhVeFZ0V3ZVZzY1YmJa?=
 =?utf-8?B?c1Rka0xTM2ROcUlWWFBseklBRkFIdUQ4L0lIelNZREh5SmNERzAxTHZlRDBO?=
 =?utf-8?B?YlNrZlE4aVJDa05zaE1wNmRRRFZGclZKTFNWZ3ZZaENwdlJJUTVLZW5PYk9t?=
 =?utf-8?B?ZkEzeHZoWmFyc2tzSGthT2ZFeEk1TUVhYlJka3RLOHIyN3FoQUZSL2lvaWJB?=
 =?utf-8?B?YlQ5RUZLeXBMYnpTQTZpa0dSM1MxMytmNFR1M2hYeHFZTnMza0JhL2QyMlQ5?=
 =?utf-8?B?ZVN3MWlneGFCQ1BuQmduOU00OG4yaDdZL1RiUGErdXpIWXFsZHgwNWJjOExF?=
 =?utf-8?B?YVdnU04ySVRVaDlka1FkYWdXYVpiVld5Z2RSUzB0Q3FuZjJQS1hXalhKaWQr?=
 =?utf-8?B?eWNUdThYSk1ZRzRjQ0pFekRtdUdCNlc3djFFakl6cWwyQW9oRWNSSS9pWWRQ?=
 =?utf-8?B?M3MrNDFkUVpUU3Zob0MrWjJlRnZnNWhEWXI2ZHhaTVJkUCtpRWtTdTN3eW95?=
 =?utf-8?B?M1RKUDMwTzl4UUlOOERGNFZLTFlrWG9jbWVaSnBGYkFDZEFiUUMrSHVRZjRV?=
 =?utf-8?B?c3pTWnFDaUhSV2M4MmR4R1YrdE9mamxGVVRjWFJjelRGUTlDb0pZdnk3VFpO?=
 =?utf-8?B?MEkvNDQ1WUlUNTNrelFNV3d0dDR6WGE3amMrNG82NFpKaTNCUGJOZERjakpw?=
 =?utf-8?B?NmxGMnROM3VvY2JNdVFGc3FycHEvTk1naHYyL0hXMlhEcXRCUzJKVmpmTzJO?=
 =?utf-8?B?TC9HbE1WclllQVhtTEVXZDhWaUFJQk9PUnFXSlRRRTk5N29MOUVYOUlTbUdT?=
 =?utf-8?B?UVlxaVNQV01TMGRBQXpTeEM1T3JtVnNDalVHSGVLNnhZTVFXQmJlby9SM21r?=
 =?utf-8?B?bGlDcGZkNHd3RzBJa012WGZZdmVJKzlDWHhudmlpYXF1L0RqVGZRbkw4UThX?=
 =?utf-8?B?OEVmYVptZDBQZmxPeEdwUXlWS0FkSWc4SVQyeHBuNmZOcDlQWDBNekd6R0FD?=
 =?utf-8?B?MFVuS2xhWkhhbGY5cisyU09BVlFVclMxQVk2ZlhPTGlOTVFGZzcvQU1lSEw2?=
 =?utf-8?B?VzZORFc1cWptSnpBTm9HVXpCRmFGK3ZONmFIOS9qNWduLzR4eU1HRWhjRjV1?=
 =?utf-8?B?Z3VBMEFsdm1oZmx0cW1odXBpaVRnRCt4QVNjT1NRMXhMU2RkMXdNMU50RG9H?=
 =?utf-8?B?Mlc2aHlJVnNpMUtMZVR3dGplTnZhK2g0SjRpTCtqVGpaYWh2aHoyTFpDeTdJ?=
 =?utf-8?B?WFQvZXNCZm5tWDA5amlBNnZrOVBYcEx3b0RYbjY3MTJiT1I0TVBJb2I5RGEx?=
 =?utf-8?B?b0p1ODJNSzd3NlYvV0dWQUUrVmJwTjhmMkR6NnliY2ZsT09CSEF0cXBWckxX?=
 =?utf-8?B?SUo5b2MxU0crN1BuYkRwZWhWSVdTcTJnQWt5ZXU3MTcrM1kvWTJORjRMVnhV?=
 =?utf-8?B?dzJVODdELzhTbmZJWlJaaXc5b0RYVGdjN01NUksvSWdJVGJIeHVDeTFWYUUv?=
 =?utf-8?B?dkpJaHFPYVBPZWpzY0VMN09TQmpJc0ZQUGVLYzUzN1FwOVViYTJsN3Y0ZUZE?=
 =?utf-8?B?R0dLQ1RvVlVNcC8wbWhyYW13d09wclhTOUpMMnAzZ1hrYm92MUhJelNCTmZO?=
 =?utf-8?B?ZEVhRGFrcmoyU2l4NHR4YVNaemJSTnpOL3lSOGg4enpIazltU1JQRDZUcDdj?=
 =?utf-8?B?WVpMSjNJcmdBV2NRU1dqeTd3eER5OHBuc1R6TERzMVBGRVh0SW9JQjR0VUlL?=
 =?utf-8?B?cURYMWVWQlk0T2JXekpodU9IaEhxVzhUUklDTmozTUtaVFNKWldVK3doNm1o?=
 =?utf-8?B?SlNPQ0dLNFBTeExwdElBbTNTZGJlZ0tTbUgwTk92S0VhNlBNSGpmczhObk1q?=
 =?utf-8?B?dGMzUXN6Y2o5QjY4NTRUVlEwU2dUd1BSbTYwM2pKMW1YdTVMOG1GeWxRaHJu?=
 =?utf-8?B?S2xyaFhmZ0pGVWJnMUdHempXTzg1eU8xUWMrOVJmOXd0RFpFcWNBamkydk54?=
 =?utf-8?B?Mk9UK3c2VG13PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ektmVFdBalM4dzRoRFc4ZmFLYURLNDh5MkhsQlZTOUV1aEs0bWFLRldxcXJi?=
 =?utf-8?B?dnZlZllGcFJKZmJjTHJCM1ZBN3cwMVpNR0dTYklzQWJ2QnMxSmpqbkRiSEJU?=
 =?utf-8?B?RXYzN1pqdTN2TkxjYVpibVQ3Rk53RVJIOEhyNnlnQkhUb1JJV216YlFDaDNm?=
 =?utf-8?B?YVY2cUZoQjJkekNmVzNxT3hSSmhwbzVXeThHZldyRVk0T2NoUkNNNTVXRFdM?=
 =?utf-8?B?a0VZY1N4cll2TlhHcWJEU2dHbkppeHhiZzg4cG5DU2JFZVhNejlXeGd0Yjg1?=
 =?utf-8?B?Zks0SjY4alYvZ3dGdFB3U244VjBmTU0yU1FJRVlLbmo4Q28xbFEyR0dUVzJR?=
 =?utf-8?B?SW1xYUIrOEJtcnZkOFlWMjE3azA2SmhJKzVOTk1tL20ybTZuNGNweDdNL1d5?=
 =?utf-8?B?bVFVM2wzeEN4R3FLbDRheWtrL2JsTlI1TW1LZmU0SFo3a3c4L1lpVTc4UkNT?=
 =?utf-8?B?cVlWWElNOEZYZllpOWhUd2J1VS9wWW5KVDVmSTJXSnNTOG9ocVc4MTIvNTR4?=
 =?utf-8?B?MmVjUzlaRWQxa00xQW5oUjZhL1hyUGl2cDJMdFA0OURtMndoVWJGVGdXbEFS?=
 =?utf-8?B?RjJNYThSZTlad0lZVzJ3VXU4bVp0Ym5mV21aYUJnTmVmNmlGcjlESjdNV2Nw?=
 =?utf-8?B?d2M4UmtpSGVOblpLb0plWEhTWVhFZTRidmNXRzdHM3dPRFl0SDZhS1JmR1lt?=
 =?utf-8?B?VS95czBZajFYb0JoaFRvUFFjeGdwVHR6NW91TU5LZ2p0SXZuQm42anJlRFVQ?=
 =?utf-8?B?MVprUS9rbW5HM0IxZHRwMENINnR3WmJlNEljZFNCS1QrQ0ttdG5uRG4vaDMx?=
 =?utf-8?B?WkUrM1dHWlVwT2Q0UHFRdC9GK0FRTitJODh5L3FobkxaN2xGNkNKajVpL0hs?=
 =?utf-8?B?OVhBNDVVckQ2WndkYXA0UTFSNzNmY214WkV5Uk1kNVNUOWxibnpqczZ4T2xP?=
 =?utf-8?B?VXdNMU1pUU5zVzAxbU9TVGNsMy9DeXY3d2JGa1c3YjZpNTdDWEZUSHBaM3c4?=
 =?utf-8?B?MXc2SmJyTEYwMUFCU29aZkhTVUNrS081ZGkyYW50Z3BFYzV3Z2Vkc3N3dnpP?=
 =?utf-8?B?SGMweFZYSmp2RlYwR0VOQzU4djEyWE1iV0xBcXJOSUY3U2F5NW16VVJtakQ2?=
 =?utf-8?B?TUU3Qk9LRlJhSFAyRXpzbUdleENZb0pLTVlEWS9Pcm5rTHRWYy9UUENYM3do?=
 =?utf-8?B?RHVQdFBMOUFNUEhYSFZtdi9QTU5xMXZWdGRncXVNMTF6SENRY2VJQlNvc2tI?=
 =?utf-8?B?SHdCMGxUalNOYnF2cjR3SGlBaWlRMkJJZHovZHVpbFdYa3dhdGpsSkhIa3ND?=
 =?utf-8?B?ckZuMjFSSU9mR3k5Qm1LZ0UvRFdjMTV1c3pHN09BTkpKclRrUUNBeE54cU5j?=
 =?utf-8?B?RjBCVGpmU0YwTk9idUlralY4Ry9IUXBIMEpMVzl1cHBWUFNkbmFQVm1HZUhv?=
 =?utf-8?B?VkI4V1pvbkZKQjNXUDh6cFk1cE1xVTBjU3Y0RmlsSmZjUXZubHYrSTNVZUpY?=
 =?utf-8?B?U1Jtdm8xUi9XdEo5Y2tlOG9lY3c5VlhRWnVJMW9KNTVldExuNW42Y1cwbmRv?=
 =?utf-8?B?SWQ3aEhEZ0JxQ3AzN1VhaDhEb0hGY3pKbWFFbm5JdzR2R1lVMTVUSFQzdWl6?=
 =?utf-8?B?YlIvWXJNdEh2WUg3c2J3WlY5SDJPQ0pxZkVqNEQ4NTZLdzE0VnN4aXZLYkZ5?=
 =?utf-8?B?Q2VjeHIvdDVFSzd0R0NQbnhML2RyOFB6aSt0TmJnakorU1ZzcDlIWUI3SUdo?=
 =?utf-8?B?amJSU21USnZvN25LQUUvY3RGbGR0aHl1bXRhb0xRb2V5VzVmRmVlTHByUUtI?=
 =?utf-8?B?UzRXSTN1RlI2NHhscWZpZTU3TzJOVDNObmtIeWtxTitXODF5M3pXcFJTWTgr?=
 =?utf-8?B?TlpDQWs0dG01dmNCT00wL3NvNVUwUytpdzdFelAwR0xPMnFQWGZGUTdwWFRQ?=
 =?utf-8?B?RFd4WTVNdkJ3OTc1VnF4cmtjWUhEUTVkS2w3TmFOb0VYTUd3eHFFOWhQVHdL?=
 =?utf-8?B?aGNXVmZBSFNqLzJiMm11TlpxT09SME1Hbk50dTZaNFhnT1FQcnAzcWMrY2sy?=
 =?utf-8?B?MXJKOExwRmthaHBOK2hldUtCc1B2Z1FxV09rKzhsbVM2WVZLNWV4b3hSWHpo?=
 =?utf-8?B?Tm5maXRlWnMyNEh5RWVGVGhUc0REUVhyY3BjZENDQ1BDTndXUWFCbXVuQVNL?=
 =?utf-8?B?SVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB5A0A9D1A88914FB0808238867BF7BB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98340ae1-f65c-41c6-0f12-08dde4f8b9da
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2025 23:31:47.7266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O7voKXIoOILcZ3QPVb3uRkUIim91Y7C3awzrOjWqTt3fb6cQHs9WEYIDlmsuU/On/2ObjbnZS9b5d8fkZZGwHviA/MLtnzG3fKn5h0UNiEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF67FA1A8F8
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTI2IGF0IDEwOjE4IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
PiBDYW4geW91IGFkZCBhIGNvbW1lbnQgaGVyZSB0byBleHBsYWluIHdoeSB0aGlzIGlzIGRvbmUg
ZXZlbiBpZiB0aGUga2VybmVsDQo+ID4gZG9lc24ndCBzdXBwb3J0IGtleGVjP8KgIEkndmUgbm8g
b2JqZWN0aW9uIHRvIHRoZSBzdXBlcmZsdW91cyBmbHVzaGluZywgYnV0DQo+ID4gSSd2ZSBzcGVu
dCBmYXIgdG9vIG11Y2ggdGltZSBkZWNpcGhlcmluZyBvbGQgY29tbWl0cyB3aGVyZSB0aGUgY2hh
bmdlbG9nDQo+ID4gc2F5cyBvbmUgdGhpbmcgYW5kIHRoZSBjb2RlIGRvZXMgc29tZXRoaW5nIGVs
c2Ugd2l0aCBubyBleHBsYW5hdGlvbi7CoCBJDQo+ID4gZG9uJ3Qgd2FudCB0byBiZSBwYXJ0eSB0
byBzdWNoIGNyaW1lcyDwn5mCDQo+IA0KPiBZb3UgbWVhbiBhcyBvcHBvc2VkIHRvICNpZmRlZidp
bmcgaXQgb3V0Pw0KPiANCj4gTG9va2luZyBhdCB0aGUgY29kZSBhZ2FpbiwgSSBjb21wbGV0ZWx5
IGFncmVlIGluIGNvbmNlcHQuIFRoZSBjb25uZWN0aW9uDQo+IGJldHdlZW4gVERYLCBrZXhlYyBh
bmQgJ2NhY2hlX3N0YXRlX2luY29oZXJlbnQnIGlzIHRvdGFsbHkgb3BhcXVlLg0KDQpTbyB3aGF0
IGRvIHdlIHdhbnQgdG8gZG8gaGVyZT8gRXZlcnlvbmUgYWdyZWVzIHNvbWV0aGluZyBtdXN0IGJl
IGRvbmUuIFdlIGhhdmUNCnR3byB2b3RlcyBmb3IgY29tcGlsZSBvdXQgZnJvbSB0aGUgS1ZNIG1h
aW50YWluZXIgc2lkZS4gRGF2ZSwgbm90IGNsZWFyIGlmIHRoaXMNCmlzIG9rIHdpdGggeW91IG9y
IHlvdSBwcmVmZXIganVzdCBhIGNvbW1lbnQuDQoNCk15IDIgY2VudHMuIExldCdzIGp1c3QgY29t
cGlsZSBpdCBvdXQgd2l0aCBhIHN0dWIgKG5vdCBhbiBJU19FTkFCTEVEKCkgY2hlY2spDQpiZWNh
dXNlIGl0IGFsc28gbWVhbnMgd2Ugd29uJ3QgaGF2ZSBhICJrZXhlYyIgc3ltYm9sIHdoZW4ga2V4
ZWMgaXMgbm90DQpjb25maWd1cmVkLiBGb3IgdGhlIGNvbW1lbnQsIEkgdGhpbmsgdGhlIG9uZSBp
biB0aGUgc29sZSBjYWxsZXIgaXMgZW5vdWdoLiBCdXQNCmlmIHdlIHdhbnQgc29tZSwgaGVyZSBp
cyBhIHN1Z2dlc3Rpb24gdG8gdGFrZSBvciBsZWF2ZToNCg0Kdm9pZCB0ZHhfY3B1X2ZsdXNoX2Nh
Y2hlX2Zvcl9rZXhlYyh2b2lkKQ0Kew0KCWxvY2tkZXBfYXNzZXJ0X3ByZWVtcHRpb25fZGlzYWJs
ZWQoKTsNCg0KCS8qIE9ubHkgZmx1c2ggaWYgYSBTRUFNQ0FMTCBtaWdodCBoYXZlIGRpcnRpZWQg
dGhlIGNhY2hlICovDQoJaWYgKCF0aGlzX2NwdV9yZWFkKGNhY2hlX3N0YXRlX2luY29oZXJlbnQp
KQ0KCQlyZXR1cm47DQoNCgl3YmludmQoKTsNCg0KCS8qDQogICAgICAgICAqIENsZWFyIHRoZSB0
cmFja2luZyBzbyByYWN5IHNodXRkb3duIGxvZ2ljIGRvZXNuJ3QNCiAgICAgICAgICogbmVlZCB0
byBmbHVzaCBsYXRlciBkdXJpbmcga2V4ZWMuDQogICAgICAgICAqLw0KCXRoaXNfY3B1X3dyaXRl
KGNhY2hlX3N0YXRlX2luY29oZXJlbnQsIGZhbHNlKTsNCn0NCkVYUE9SVF9TWU1CT0xfR1BMKHRk
eF9jcHVfZmx1c2hfY2FjaGVfZm9yX2tleGVjKTsNCg0KDQpQYW9sbywgS2FpIGFuZCBJIGFyZSBn
bGFkIHRvIHRha2UgeW91IHVwIG9uIHlvdXIgb2ZmZXIgdG8gdGFrZSB0aGlzIG92ZXIuDQpIb3Bl
ZnVsbHkgaXQgb25seSBuZWVkcyBvbmUgbW9yZSByZXZpc2lvbi4gVGhlIHBsYW4gd2FzIHRvIHRh
a2UgaXQgdGhyb3VnaCB0aXANCndpdGggYWNrcyBmb3IgdGhlIEtWTSBwYXRjaC4gRG8geW91IHdh
bnQgdG8gcmV2ZXJzZSB0aGF0IGFuZCBnZXQgYWNrcyBmb3IgdGhlDQphcmNoL3g4NiBwYXJ0cz8N
Cg==

