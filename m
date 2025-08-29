Return-Path: <kvm+bounces-56380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ADD50B3C586
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 01:16:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A43B5A4648
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 23:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C43B5311975;
	Fri, 29 Aug 2025 23:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f7TpyWhb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FBC256C88;
	Fri, 29 Aug 2025 23:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756509352; cv=fail; b=htgbePJjx5oYx9rrZvYoylda1ZH5QOxtVZVnl3reJbR60qZU13rfLmU59TsJ1fGF7Tu2Uldvh7/dxsq+rEQLn7a+oKWgjzdEs/yzdCmBGbp+fni493UIh9maTGNnbLnvg6qMe2HRNdSCub/TLggnJ2GunD+VBcSNajqAoVzhGgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756509352; c=relaxed/simple;
	bh=IgaMvx/zrh6YjfADj3DOL2tMmft66qTCGQoOokAbwak=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g4b5BO/fNgC4LYK+RGp2vOQXm46RycrJbRS1ZTRPxY1HxflJbc0r1ZnXE8EdkYcPQ3vOT7IbXUUmVUCVE3m6am9/hHiloo5aN/jgSqQ7G4Qn7zJTigpB3xJzh+Y57uvJewws4hLMgr9d6I4TXzo70mwzv899yOAGVlWHJYxlpf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f7TpyWhb; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756509351; x=1788045351;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IgaMvx/zrh6YjfADj3DOL2tMmft66qTCGQoOokAbwak=;
  b=f7TpyWhbaAp44gQnqFPbNAK92uasPvgyTOhFdIJL0Tg4v+hwfC3+ESLm
   B7Ns4N5FZEw9zI5UlDkBTrw2COL9c8tcIsiSBmYUWxlG/UD3njmbQN4FG
   Y1oFrH+eZJLKjxZC6DzlfAZVe8MtM0NC1P3Qz19w0AimYMSeuaBX2veEG
   DLcF78J/6r1TzzzxrHCgwY0hMTdwiCTnL3cKX7z83120rnn223m0iQhZj
   QuluNBZqIQKF6Jdd+nj9jlgtBBXgwb0iWQ5uzXEyIDdVAhrjhmQPKeK4H
   1jeb8BeGOkaZGlIdU5XORFqW5v8M5m7CoGied47sPcj09tRJ9i19bv5lG
   Q==;
X-CSE-ConnectionGUID: fmgmq70rTUGSEoA+8OM+Ew==
X-CSE-MsgGUID: 4hAaAVc/SRaStG9qM5SPKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="58733103"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="58733103"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 16:15:50 -0700
X-CSE-ConnectionGUID: BUnZrJ+/SPiEM3W8eW9hHw==
X-CSE-MsgGUID: v/kpoHqoRoOkIX0fLH2cVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="194160336"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 16:15:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 16:15:45 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 16:15:45 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.75)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 16:15:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bv0ofu/oMKUEvspd6EVGSuqPEAmkI5tdrlCvUN2ssjRR3uE+HYIyWNxDmUvjSJ0DDL/2YLleGsORKC2fr4hxtNTvUIqO6dTTzgis1aNOWjhjXgPrRs4gTSoOwkY+d0Ld8At9kbhZEOxYwXrWI904ldlVXZQyJy795twQOBx1m2z+9A9wJ3ppnKvkMV9NgOPdREe6OuP+IAhwDN91tqIojazihE1pdEb/0UJZC1kp9MPN8XDRnbMwPIsfaEEUwGKa8+exibpvxco4x5xe6RmSHsDnAXcfMgtR+7frWjMN9qKm/zl+R+LjCpPUPbWX1kGnl8XAQOdT+qw7l9TFi+goEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IgaMvx/zrh6YjfADj3DOL2tMmft66qTCGQoOokAbwak=;
 b=hijCd1AR6XWJFXb/7SD1nvgYcdkO/7aLbdB7etp9AraS2YapLVscAhRenyZG0HQZpCeYK2nZaVuoOM3uFSsEhvUYL0kxzKffBNtk38tk7t7aBdNbM4TTGn7KUV43muajqRRXCiP7U2AYUSNcBKal6gk5jTgSNVt9nxHeG115ILOQa8WmJ8jnGbtC57miwgPuRhorgWAydpLl8kxctbxot6OtgRziKJpfp4h1uScOOj8Yu92biEWXUzLdPiayedl3EwM75Yyvv+i2w3tbUxwWK7nP9hLE9fOLUDAiobOyx29G+5HUAcpKoJj9UHC3QGwLFTQQPVef+lrojG7VCv9iyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB6325.namprd11.prod.outlook.com (2603:10b6:8:cf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Fri, 29 Aug
 2025 23:15:37 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Fri, 29 Aug 2025
 23:15:37 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the initial
 measurement fails
Thread-Topic: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the
 initial measurement fails
Thread-Index: AQHcGHjSRjNmRiPKf0OfM3rq5B2s2rR5SfIAgACnMICAACApgIAAKVYAgAAKFAA=
Date: Fri, 29 Aug 2025 23:15:37 +0000
Message-ID: <b47e08bb6105a94bc88ee91aa7bdd055893eeda6.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-13-seanjc@google.com>
	 <aLFiPq1smdzN3Ary@yzhao56-desk.sh.intel.com>
	 <8445ac8c96706ba1f079f4012584ef7631c60c8b.camel@intel.com>
	 <aLIJd7xpNfJvdMeT@google.com>
	 <c8352e1a76910199554bce03a541930914ff157d.camel@intel.com>
In-Reply-To: <c8352e1a76910199554bce03a541930914ff157d.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB6325:EE_
x-ms-office365-filtering-correlation-id: ac5c7f55-a69e-4a48-b8c6-08dde751f696
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QU9nemJvSUovb0F6YTREOGpRUjJndEhjdStCcmRXckF3bmJXdGc4KzYwa2FM?=
 =?utf-8?B?MXl3QmQvS3JnL2VZSnNzZ2FRL3FTbGtjVEREekhyM053ZDR5M3kzSndWT0xv?=
 =?utf-8?B?ay9rYzRpbXlxTTRpRll2eS9UYy9mbFpLb2lhV3JKWVFrMUpWc3FxY0ErUFVY?=
 =?utf-8?B?d2JITUhrZ1Vaem5ZdDdzOGdHeW9mUUwySlVuQVFKRWdleUVCTGdqQVNCTTRu?=
 =?utf-8?B?N1M4SVNCQytnUXFJRFE2eHNJUE5HTlFkR0JKSnRKMHBZV2lQRFF4ZFc5dFNB?=
 =?utf-8?B?bERkYzFYKzNkaHFodFNUdVZXZ2VnUStscHJOOHIxQWJ1ZEtoSEh1dFRoMnI2?=
 =?utf-8?B?bUNYZFVtbGk3R1NyZmw3WXBHS2lLMEJJM3J5N3JOeEJ6WTNyR3JHODN3SzV0?=
 =?utf-8?B?S0hxclB6NlhxS1hoRUFveFVFbHRWY25MTGllSHhuZGNaZ0pMTThPa2Zyc1p6?=
 =?utf-8?B?ZjFjNVk5YXZWdkJuTUlyU3BjNlkyNTRYN081VGR5UTM1SEJFQW1NNk5TZzJK?=
 =?utf-8?B?U0FsQkk2M2FEakZ2Z3JycG1zN054czJ5WTB2cExpM0pkZW4rbzVGOVUydDF3?=
 =?utf-8?B?QVZZZTZRQ3I5cDhiZXJwR2NOMTkwT0NHZmFiazZNMWFpdHhCZ3QxUWgrOVRq?=
 =?utf-8?B?bWZTVytsd2lIVXdQbktIM1NxMmhRNmxleFV3NXphTlJPMDMxZTFkTXBVbVUv?=
 =?utf-8?B?b3I3UEJKV3Zva2psYUlGWnhSbjByNjNWdXV3bGNZQ3pIMmV5MktUQVRLdXZ0?=
 =?utf-8?B?b2tKQWw1WTNKUUN6SzVJT1JERkFxU2t1cnlaRzRhOGhPajF1eXpLNmgzeWhv?=
 =?utf-8?B?KzExZEdmaHJnSW0weXo1RnlQNTZ2VTJmT3g2ZWEyeWJzcXVHZENCY2JoSDM2?=
 =?utf-8?B?QzJUVHphMWdQbGpzTitXZDlUWGsvWURFc2VuTUhQMUlnQ1FJMlpBUmxJWWJD?=
 =?utf-8?B?VXlQUjJpOUFoMkljNWxYeGNSRXh1UGpvVzJWeTVtOW5vbndpMmVJUUx3aG9T?=
 =?utf-8?B?eHJQOTFUc0Z6RnMxd20rY2RMWXVtSjk2SGI0aU0zYkdLVVFCOEtoMG1MUjR6?=
 =?utf-8?B?NWI2bytERUN1YWIzWk40bGNHTFZ6eGZLMkhVaXhCVCtleWNLMlhpeEFyQndM?=
 =?utf-8?B?ak9FMGRLZjdjZHUyMEswRWlzNTI2dnlKcE12Q2Y1T2JGL2t2cVdnMS9iZjNh?=
 =?utf-8?B?SWYrRFc0clhuL1VTSmlJdERObUVIVnpqZ0lpSEJtTTFkN1dFSFJJTGovRHpW?=
 =?utf-8?B?NTYvQXhmZjlxTG5FczNVdTNjSDI2NFZZSnlNRzA1ZWtNVTgyNnJVMFQ3c1Bu?=
 =?utf-8?B?eVJsNzcvRG84bUxPM09SUFhqZCs3OHI5Sk1Za3VEam5DR1lKOTFzbGxXamJI?=
 =?utf-8?B?SWM2dGFPbjEyS1FINDZHQXVrcVpuWjZGM0kvTEIvTXdCbnAzdFpMMDQ5L09H?=
 =?utf-8?B?bXFyQWMxcDlKVWNoc0NDY0dlU1RBRm5vRTZwR0V1ODN3cGJNdkc5a0hIYTRT?=
 =?utf-8?B?bjRhUk9BWk84bmRNRzd5TE45WWNwOUVPSHBjaGJZL1laSWZTKzBnRFhpYWp5?=
 =?utf-8?B?bnlnTU54RFN3NHFkK2JjOVNFUS9nOTFxQm1FVVg5a2xNNUc5Mmw2TGFqdC9i?=
 =?utf-8?B?eDRrL1B3VEo5MysxaGo1ZFpSR1BxUENJa3daQ2E1T25qcW9Yd3FlTjhFbTBn?=
 =?utf-8?B?V2h2V1Y1b3ZyNG5SQzIxbVZWTGxvY0VGVEp2eVROYmJSbjNySDFaSlowZFRa?=
 =?utf-8?B?dzFGZUFqSm5XTHN3eGZpS1dNRTkyV1g5SlcramZpZEJjeExEM1ZtY1U5VXpr?=
 =?utf-8?B?YXVYUk5iVkU0Q3MvdTI2YXN0S0V1VXpocFZHcEJWSzlwZTcwLzM0WUFFOHUx?=
 =?utf-8?B?eXFtRFJGelBFNlEyanVzZUZpY3dweHVoL0YwMGVGbnByUWVjdDM0K2lJSnc1?=
 =?utf-8?B?RFV6WTAzSDFBR2RvMmRhV3RJdERFLzBSSU0xK0tQMEM0RTg3YURXcytsbFdS?=
 =?utf-8?B?Tkt0RnBvNnJnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UmhqNkFiWVQ2SmZFZXdPZGhIVGxKM0lvMXlmbkdzSVpxdENuRzd2aU1uTnky?=
 =?utf-8?B?SHVFSi9JY0JQd1hhZHhrVERrYU9OeHQ3b0pHUGx5d3BGeTdRV2ZiT2JDa0Fl?=
 =?utf-8?B?ZlBoVkhZdGlDaUZKTmhTV0x2dGZmN2lJUGRvbVN0dFlVVTZmWkhUMURXMjFJ?=
 =?utf-8?B?bVRicEtBQUVheWxqZ0NYUlcvWHpQYXkwN29zT1JiTlRqNndPTjVrWGxOOUk4?=
 =?utf-8?B?SDh3eXNJbjM2RWFKN0FHSW5pSEZZQjRESWVsS1BZRWQ5ZDhUdHowMGp4Mmth?=
 =?utf-8?B?OTk5SzYyOWN3ellyS2EzV3I0UHhFZzcxWWZMZmRSQnh5UXBqMmpnUjY5U3px?=
 =?utf-8?B?bmthdTd4UElueVdqd3pLZ294ZE1YT3VrK2o2RE1SM2dvQkFXbHlLVmN4c3pk?=
 =?utf-8?B?UHZFTFJGQzVwRG1Vdnh1Vm9MWDZXc1kvQldJOHNXSXdDcDNLb2NJVExRek1G?=
 =?utf-8?B?eVNzTTRkUlhxektja2xEZjVZaS9aUzRZU1JKNmxiYVFNcXY5NWV3N3p0OEs3?=
 =?utf-8?B?R0psdFhKYkpwNnhnYiswaFFDdXRBNkFBaHJ4T3ZYMmNJekk4TENSN3JkVklK?=
 =?utf-8?B?bXl0TkU1OFAzMnRWMGtwcytKRDV2R0lHV291dGJaV2lybnBidkRqQmdmbWdQ?=
 =?utf-8?B?UHZTNUkzenAzSUVnM01RcVY5ZE9ldEduOEZLelN6WUVlNko3dk1YUjVpYTgx?=
 =?utf-8?B?cUFHaTZBYnhFNE9RdFFlZUlQRnVpRWNoWE03aWtVTWRUdmh5NVlaMlFBZ0NN?=
 =?utf-8?B?ejNmNkVJSW5kV1ZDc1J3eTl6a01XREVocXROT0pHZFp5SmNaVUZrL09JMkp2?=
 =?utf-8?B?WmVjTU9HMms4RXhwTXRieWlPcmQ4bjF2dDI3YWdrZksyTU4zSCt2RU1FVXU2?=
 =?utf-8?B?dGw0cldTQ0ZnRXhnZTVhNGpzZm1jNkxGT3E1WGxXdmp0MHBsdjZBdzkxUUpJ?=
 =?utf-8?B?elN2UEx4Tnp0bDNvM0p5NlVNUEw2VnJ0c2ZQUSsybUprT2ZwY0ZlSFRDK012?=
 =?utf-8?B?UXd6Slo4WGs4aU0zOTQvcGJsblliV1dxc0EwUFlVWFFIK25NNHpITVFEakZ1?=
 =?utf-8?B?WmFLMTJlUnB3WmZHNFNwVi8wOXRKUjRtRFY2dkRrWTJKbjRwUDVmM1hqd2py?=
 =?utf-8?B?eEhIM2tGQ0cxTTljV3BFVys0cEJOMlFpQUlET09FQmlpMGlXUFl1RmdwNjgz?=
 =?utf-8?B?N2xjZXo2aGZFNHo1YW5VRGVRUUhZY3IvQTlzbjAwanNrbmUwb2orMnhYaGMy?=
 =?utf-8?B?WXAvUUVKU1BRd3M0VDI5ejdCeHlJaXI5aTl0b0dqZmxQTVRybWZ6RDhzc0VE?=
 =?utf-8?B?YkRwYm5MWElwYTVZQk54ZWVNQTZXSkcyUk14OGhUUTlQdXhaQlBQZGhxemMy?=
 =?utf-8?B?Snhld0ViQWJxTzFEL09qNWxLdTZBWTFmSDVMd1ptbEs5SmUrREFQNDdNTllR?=
 =?utf-8?B?N3c3TzlqcndNMHo2VFJoTFQ0WHNQN0NzaUFpWHR4NEtYK3NxVnVEb0ZjcGZQ?=
 =?utf-8?B?ZWxoN3RzSTg0U3ZhK2RBMXduOEtZeEJKRlhlSFdKUTI2NzlXTmNhdWo0MWpZ?=
 =?utf-8?B?aUdBZHh1Mml4Q2ZlQ2lkRnFVWFV1K29UZG1YWXIrbUxHR1RxZWswMWJsZFpJ?=
 =?utf-8?B?RkFwbWdUd2lqM1pGZlY5R29IclY5KzRGbEhyQ0lCOTJ1c0FvbURQWnJ2V0pi?=
 =?utf-8?B?NTByYnZrYnlKZERVekZuekN2cXdEdGRMcUFOWmlkMVFhTWErSHNCNlFQalB0?=
 =?utf-8?B?QjRLY01FOXhMYW91WENnRVJmZU1jd1hyVHZydVJQKzJZUmxZRWZVK1N5Y250?=
 =?utf-8?B?L0N6YUxjeTRITVg2YjdjS3Fua0R4Q3RCaFhocjZBK0JtdnRnSjNoWVIvdFFz?=
 =?utf-8?B?bUdiVjBkNkV0T0F6cWtmZ1NsRXFkaCtnUk1kOXVrQzBCc044L2kwdWJqL0My?=
 =?utf-8?B?VStTWkJvU2t5OUdFZjhPRUg0MXM1S0YvOENFRy9Oa280YnBReHc3elVwTGpO?=
 =?utf-8?B?bXhHQ1dPdG13dnhNMlZlR2hFRllBS3JVeS9IOFg4bUE4UTA5SUlCOWVwNGlq?=
 =?utf-8?B?OHRjamVaZ004TlVvNWtPdVc1NVJxRjluZ1lObE50QnYyVEFqNStlMEc0YTFn?=
 =?utf-8?B?MFJoTDVaaHY4N0tQdVZUdGpuc0ZvTnBUWnZmUUNZU2xaYnpYWW9nRHR5SDBX?=
 =?utf-8?Q?NRytRydDHKdYZekgmdgMrq0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B9C02399ACA5B44E9B75F24B5D8B0290@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac5c7f55-a69e-4a48-b8c6-08dde751f696
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 23:15:37.1458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: upIluVrKoZGvc9A8tagoGUOlI8+4lQEvzCraTLONqddMACi4+lQ/mnxHoKSqtJAFxGRq9APZXvf1jSmkCago6e6Fj1KWW8XX4jWf9fpUr+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6325
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA4LTI5IGF0IDE1OjM5IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gPiANCj4gPiBBbnl3YXlzLCBJIHRoaW5rIHdlIG5lZWQgdG8gYXZvaWQgdGhlICJzeW5jaHJv
bm91cyIgaW9jdGwgcGF0aCBhbnl3YXlzLA0KPiA+IGJlY2F1c2UgdGFraW5nIGt2bS0+c2xvdHNf
bG9jayBpbnNpZGUgdmNwdS0+bXV0ZXggaXMgZ3Jvc3MuwqAgQUZBSUNUIGl0J3Mgbm90DQo+ID4g
YWN0aXZlbHkgcHJvYmxlbWF0aWMgdG9kYXksIGJ1dCBpdCBmZWVscyBsaWtlIGEgZGVhZGxvY2sg
d2FpdGluZyB0byBoYXBwZW4uDQo+ID4gDQo+ID4gVGhlIG90aGVyIG9kZGl0eSBJIHNlZSBpcyB0
aGUgaGFuZGxpbmcgb2Yga3ZtX3RkeC0+c3RhdGUuwqAgSSBkb24ndCBzZWUgaG93DQo+ID4gdGhp
cyBjaGVjayBpbiB0ZHhfdmNwdV9jcmVhdGUoKSBpcyBzYWZlOg0KPiA+IA0KPiA+IMKgCWlmIChr
dm1fdGR4LT5zdGF0ZSAhPSBURF9TVEFURV9JTklUSUFMSVpFRCkNCj4gPiDCoAkJcmV0dXJuIC1F
SU87DQo+ID4gDQo+ID4ga3ZtX2FyY2hfdmNwdV9jcmVhdGUoKSBydW5zIHdpdGhvdXQgYW55IGxv
Y2tzIGhlbGQswqANCg0KT2gsIHlvdSdyZSByaWdodC4gSXQncyBhYm91dCB0aG9zZSBmaWVsZHMg
YmVpbmcgc2V0IGZ1cnRoZXIgZG93biBpbiB0aGUgZnVuY3Rpb24NCmJhc2VkIG9uIHRoZSByZXN1
bHRzIG9mIEtWTV9URFhfSU5JVF9WTSwgcmF0aGVyIHRoZW4gVERYIG1vZHVsZSBsb2NraW5nLiBU
aGUNCnJhY2Ugd291bGQgc2hvdyBpZiB2Q1BVIGNyZWF0aW9uIHRyYW5zaXRpb25lZCB0byBURF9T
VEFURV9SVU5OQUJMRSBpbiBmaW5hbGl6ZWQNCndoaWxlIGFub3RoZXIgdkNQVSB3YXMgZ2V0dGlu
ZyBjcmVhdGVkLiBUaG91Z2ggSSdtIG5vdCBzdXJlIGV4YWN0bHkgd2hhdCB3b3VsZA0KZ28gd3Jv
bmcsIHRoZSBjb2RlIGlzIHdyb25nIGVub3VnaCBsb29raW5nIHRvIGJlIHdvcnRoIGEgZml4Lg0K
DQo+ID4gYW5kIHNvIFREWCBlZmZlY3RpdmVseSBoYXMgdGhlIHNhbWUgYnVnIHRoYXQgU0VWIGlu
dHJhLWhvc3QgbWlncmF0aW9uIGhhZCwNCj4gPiB3aGVyZSBhbiBpbi1mbGlnaHQgdkNQVSBjcmVh
dGlvbiBjb3VsZCByYWNlIHdpdGggYSBWTS13aWRlIHN0YXRlIHRyYW5zaXRpb24NCj4gPiAoc2Vl
IGNvbW1pdCBlY2YzNzFmOGIwMmQgKCJLVk06IFNWTTogUmVqZWN0IFNFVnstRVN9IGludHJhIGhv
c3QgbWlncmF0aW9uIGlmDQo+ID4gdkNQVSBjcmVhdGlvbiBpcyBpbi1mbGlnaHQiKS7CoCBUbyBm
aXggdGhhdCwga3ZtLT5sb2NrIG5lZWRzIHRvIGJlIHRha2VuIGFuZA0KPiA+IEtWTSBuZWVkcyB0
byB2ZXJpZnkgdGhlcmUncyBubyBpbi1mbGlnaHQgdkNQVSBjcmVhdGlvbiwgZS5nLiBzbyB0aGF0
IGEgdkNQVQ0KPiA+IGRvZXNuJ3QgcG9wIHVwIGFuZCBjb250ZW5kIGEgVERYLU1vZHVsZSBsb2Nr
Lg0KPiA+IA0KPiA+IFdlIGFuIGV2ZW4gZGVmaW5lIGEgZmFuY3kgbmV3IENMQVNTIHRvIGhhbmRs
ZSB0aGUgbG9jaytjaGVjayA9PiB1bmxvY2sgbG9naWMNCj4gPiB3aXRoIGd1YXJkKCktbGlrZSBz
eW50YXg6DQo+ID4gDQo+ID4gwqAJQ0xBU1ModGR4X3ZtX3N0YXRlX2d1YXJkLCBndWFyZCkoa3Zt
KTsNCj4gPiDCoAlpZiAoSVNfRVJSKGd1YXJkKSkNCj4gPiDCoAkJcmV0dXJuIFBUUl9FUlIoZ3Vh
cmQpOw0KPiA+IA0KPiA+IElJVUMsIHdpdGggYWxsIG9mIHRob3NlIGxvY2tzLCBLVk0gY2FuIEtW
TV9CVUdfT04oKSBib3RoIFRESF9NRU1fUEFHRV9BREQNCj4gPiBhbmQgVERIX01SX0VYVEVORCwg
d2l0aCBubyBleGNlcHRpb25zIGdpdmVuIGZvciAtRUJVU1kuwqAgQXR0YWNoZWQgcGF0Y2hlcw0K
PiA+IGFyZSB2ZXJ5IGxpZ2h0bHkgdGVzdGVkIGFzIHVzdWFsIGFuZCBuZWVkIHRvIGJlIGNodW5r
ZWQgdXAsIGJ1dCBzZWVtIGRvIHRvDQo+ID4gd2hhdCBJIHdhbnQuDQo+IA0KPiBPaywgdGhlIGRp
cmVjdGlvbiBzZWVtIGNsZWFyLiBUaGUgcGF0Y2ggaGFzIGFuIGlzc3VlLCBuZWVkIHRvIGRlYnVn
Lg0KDQpKdXN0IHRoaXM6DQoNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jIGIv
YXJjaC94ODYva3ZtL3ZteC90ZHguYw0KaW5kZXggYzU5NWQ5Y2I2ZGNkLi5lOTlkMDc2MTEzOTMg
MTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQorKysgYi9hcmNoL3g4Ni9rdm0v
dm14L3RkeC5jDQpAQCAtMjgwOSw3ICsyODA5LDcgQEAgc3RhdGljIGludCB0ZHhfdGRfZmluYWxp
emUoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3QNCmt2bV90ZHhfY21kICpjbWQpDQogDQogc3RhdGlj
IGludCB0ZHhfZ2V0X2NtZCh2b2lkIF9fdXNlciAqYXJncCwgc3RydWN0IGt2bV90ZHhfY21kICpj
bWQpDQogew0KLSAgICAgICBpZiAoY29weV9mcm9tX3VzZXIoY21kLCBhcmdwLCBzaXplb2YoY21k
KSkpDQorICAgICAgIGlmIChjb3B5X2Zyb21fdXNlcihjbWQsIGFyZ3AsIHNpemVvZigqY21kKSkp
DQogICAgICAgICAgICAgICAgcmV0dXJuIC1FRkFVTFQ7DQogDQogICAgICAgIGlmIChjbWQtPmh3
X2Vycm9yKQ0KDQo=

