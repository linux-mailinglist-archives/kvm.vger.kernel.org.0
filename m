Return-Path: <kvm+bounces-61802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C5C57C2ABB6
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 10:29:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 87BEA4F0838
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 09:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DE7C2EA727;
	Mon,  3 Nov 2025 09:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DL2Rgkcp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D55B2E973F;
	Mon,  3 Nov 2025 09:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762162008; cv=fail; b=qGfmhf/Ta1vSSkeEu1SSqRQToF+WskzrIzl2drFsDJU1PEO6EqIUBW4rFETRijEoETm6fn6/q9HU1vax3hj6vqeSqkp39rfK91l7eBthI5wd+FgFJdxdejd7/I6dDMwvSaDHGUWlaaInF6L06t45KeC64nVAJF4rmcrXYn7CpHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762162008; c=relaxed/simple;
	bh=JLDoLO7iFMpV9mP+2T4I8rtednlCX2A/C3cJDAP9Q4o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y5aAkDc9LvCaYaRKuTKpnAXLZYNVTr1qCV70lxpPn+Dli32tgESco/GlCfvXIL/FvmuVBdsNBHEYnMFdHFE/CBSpgMxNyjoItF3KwIAgV2lZMaifJMICPlanmSN+IM1yDvk5UplfjWFvv0RBcs/hBZy54R9l7FGknPdEbKudz2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DL2Rgkcp; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762162007; x=1793698007;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JLDoLO7iFMpV9mP+2T4I8rtednlCX2A/C3cJDAP9Q4o=;
  b=DL2RgkcpIIW7KLxI633z3rILB15GAuFd1hrjQtR3bBWApVAkpr3tzS9J
   6iZQNnhydNYOg1UHcGULKExIfIae+kcJlI0XsftnbT25qgXSjXK9nVSo6
   ivHfHS71UdvY1uphEBEfMXfxCHd3akq+ltNzap5rzUr7Oou7R2M6POjeh
   pxQmOOWeDPkwzTTMXV2V0fs072pisCdOg+pnp43r7tbg+U3X0/We1k1JU
   pjXNo8I8UjVpIrSzfBGchwbN5tSeQCVCAHvy0S6U/eVZG1ddP6n229qu5
   Vmg7n/tKI/XIByHskxcNUUTAff+ArBTD5gcTDcm2fKM0iTlvKwV1e/kT+
   g==;
X-CSE-ConnectionGUID: SshQ+9KBS1ioGwyGk0Gx7A==
X-CSE-MsgGUID: x1whjb3sQGKZyUCzULPwag==
X-IronPort-AV: E=McAfee;i="6800,10657,11601"; a="51803190"
X-IronPort-AV: E=Sophos;i="6.19,275,1754982000"; 
   d="scan'208";a="51803190"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 01:26:46 -0800
X-CSE-ConnectionGUID: IUIdfHYjTQOjUd+Si861Iw==
X-CSE-MsgGUID: DkRuLY5CTwOPLbfgZsjiiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,275,1754982000"; 
   d="scan'208";a="187543948"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 01:26:46 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 01:26:45 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 3 Nov 2025 01:26:45 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.48)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 01:26:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XM5w6RWMoLgqWGetP0cPQVlnhxnxncHi8zH9HcPKEEcDr7Q/6JaZIguzZTdGjrJ9ioFF4/NG5DGaoJCMuAh8YL7PK1DR9z2XW37VoHqzHDRHlNMQ8gPBXxcBfU+kFdogBNX57j1f577etydzxYRxktourXmq9ogY4akB+PDwI4ihG3BQjnfeC0OgujDKX0GJEjP2Kc61sIlXkmYXYe5imsxK+DuaXbkczffD/h3NQ+sBylZmJF3MZfX4t416BgSkUW3wLf2rG3t7dVExQeemLJhrwfKfhrEOYTgTmhHrH+6KN41OQ/VPJCiokV2zt87ZX9s1aEFar6biC29UKUS5Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLDoLO7iFMpV9mP+2T4I8rtednlCX2A/C3cJDAP9Q4o=;
 b=v7YYThCWG7doqYU1v/8KcACJAzks5khUacxfFM1vdNe8rlVEu/hT7ycdiRWatxjM+bL4fFf2dp919hOKksLMqCT1dL/wz9akM4s2lTRnNFjHNJiaGr3JO6pRGh3x1SAqSCEbZd612u+8DMynelVhuwTn4cMldtN+6XXN8THJzR7nqvXDH5A65/BOUZcqK5WJMosM7FPsrXV1UPLkX7H/ic9l22nnZ48T8gXaAFk4nPZ2VCXLtCtLTk7EljtKkMex1KNFkRxBd0sc2HxWc3707utQZf4V74V3mQ1F2nETHi2k5t4PUNMyxNWpdRX++VXGQgByQCjH2j3VuJIgl/Rlhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM3PPF1CFCD9AEC.namprd11.prod.outlook.com (2603:10b6:f:fc00::f11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 09:26:38 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 09:26:38 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "sashal@kernel.org" <sashal@kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "alexandre.f.demers@gmail.com" <alexandre.f.demers@gmail.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "mingo@kernel.org" <mingo@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "coxu@redhat.com"
	<coxu@redhat.com>, "Chen, Farrah" <farrah.chen@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"x86@kernel.org" <x86@kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH AUTOSEL 6.17] x86/kexec: Disable kexec/kdump on platforms
 with TDX partial write erratum
Thread-Topic: [PATCH AUTOSEL 6.17] x86/kexec: Disable kexec/kdump on platforms
 with TDX partial write erratum
Thread-Index: AQHcRcumqtsA743H90KS4YZNwnQICrTVAvYAgAu5WIA=
Date: Mon, 3 Nov 2025 09:26:38 +0000
Message-ID: <e15710b10ff4a5ddb62b4c2124700b1ab1c6763d.camel@intel.com>
References: <20251025160905.3857885-1-sashal@kernel.org>
		 <20251025160905.3857885-288-sashal@kernel.org>
	 <834a33d34c5c3bf659c94cefc374b0b7a52ee1a6.camel@intel.com>
In-Reply-To: <834a33d34c5c3bf659c94cefc374b0b7a52ee1a6.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM3PPF1CFCD9AEC:EE_
x-ms-office365-filtering-correlation-id: 2a69b3e7-dfb3-4b83-c474-08de1abb1715
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VHpBUHBwemswRElZOW15Z2FsUkoyMWJxWHVCNSt1eVFwWFFMNVBWaFpCUk90?=
 =?utf-8?B?NWlzSlBtVE5raDJyQlQyWHZEMFZqWnIzb0FLK0VxKzdXbnU1N1k4Q0ZEMFU5?=
 =?utf-8?B?UGtmWUlvU2pibW5OMWVwckQ0ZTJDR25ZRUpMVlYxK0NMZFVkSmJxV1Z5S0R3?=
 =?utf-8?B?SmxRbEE0OWFscGNZVmZZSXNDU2VoakNaMkFsQW11d05hRFpvQmxJb0ZiejVO?=
 =?utf-8?B?Nk9KMGN4TkR5aGwzNy9nTHYzYkhJMWFHNkVOTHlUVVVmdGJmMkJaOUp2M1Fx?=
 =?utf-8?B?Z1pwYTV4UzlPelRiSjF0dDdlV05zZnRoTEFKQmwvNElXWEhrUlgwbm5ESG1B?=
 =?utf-8?B?RVBVc3oyaUtQZEs0dG5LaVRaMXEyQjVTRnU0ZnIzV2IvcDVZek15bFlvN1RJ?=
 =?utf-8?B?ZXlZNHhsMHE3b3JqWFJsR3JkbisrcFpRRXk2bStnSHFXbU9WaXpBV0NKSit1?=
 =?utf-8?B?RnNxTjRaVDRrTytUMUZBVWROditWUklKN0dWbTFHUG9SN01PYjJKTXlubHhU?=
 =?utf-8?B?dU9mcTM1eDZDclViTVZWSlpBYkxiQ0lEcFovSEhwMUJDT2NFaUMzSzZBcmNs?=
 =?utf-8?B?Z21HSmVpQ2NrTEtkTFRBb1NmdFZMRS84cXgzN0o5K2RCaHJ5K2pCOXBvNjFE?=
 =?utf-8?B?RHdVanl5bVViY3Awa3U3b1BCREV5S0JKcU9nYnA0ZmlBeWt6UEllRHdLZk5D?=
 =?utf-8?B?TXdVUDJ1bFYrWElIZmE1WUdjUzQyb29WZWFWQ3plRGc1czhmTkpaa003czJu?=
 =?utf-8?B?Rm5FSmVRemdTUGNyVnArUXJkaGo2cUJtRnJ1OUphRkhTZVJlNk5DNFJSKy80?=
 =?utf-8?B?UW04dlU4MHVqb0pZczlFN2tHNGxyQlpRM3ZmSnJMQlVkTXdRcnAxNmE4LzlN?=
 =?utf-8?B?cUFad1RSeHV5SVc2TWtWc3Q5M2l6azJIQisxYmpjaGtvQm9qRFd0ME16RHNj?=
 =?utf-8?B?UjNHNzBjcEdzV2pYanlCcGYwdDZaVXU4VXJBMU92VGYxSFpmRkpYZFVBNlVz?=
 =?utf-8?B?MXljeWNIcVhoSTdrVnVFT0RhM2ZiZTJOdUFvS3Fqc3IrY3AvSWZPK3FZNkhv?=
 =?utf-8?B?amdSS2o2MUtEQytTbVRSQitjYjBRNlRNOVgvNk5ud3dnN1lCZjRhdDgyVGtD?=
 =?utf-8?B?bmEwK29pVFZDUDdSTnFVWTRpZ25FY28wVWRvMjVoUkJaRjR6NGpnSW9taE9k?=
 =?utf-8?B?OFdvYjh1MCtyNVF4WGRyWFhJRG5XNHJsRkg1S0xwQ2JrNnFNUGNnNGMxd0l5?=
 =?utf-8?B?eG1LNy9nV3RVOUN2Rlp4b1k3YVV4Yk4rb2kvb2JhbFFRVTRkajUvbzVRWkRX?=
 =?utf-8?B?VkVnSWlTQU5YK3krOUVMeEsrdFp5WXN3VEQwckRXMDNqNHFGdDNpV25zZTlr?=
 =?utf-8?B?eDZrd0hjVlhDT1NUY3BHQ1lSRW9zc3pGY214a3QxY05tdzQ4Zy9GNHBFMllo?=
 =?utf-8?B?RG5uLzFQNGFwQVdkeU5PT202YXQwRUc5cnZjMGRKS0lhaDhsdnVYKzJ2bEt6?=
 =?utf-8?B?djcwQ3NOczgzL242cGJpZVM0NXhTT3huQUNhcHkxY3BSOXBpbW9CM3JPQk00?=
 =?utf-8?B?RUQzUjVFZWh1bXp1TWRrQlV2YVkwejcvRVUxSDN4bkFQbDFySysvbklLa1ky?=
 =?utf-8?B?QjlTRWw2T2xyR292Y2V5TzlWdHNybmNVY01ibDU3bnc1cHdMNU80aHFIUGsv?=
 =?utf-8?B?RVgxUE8xWWZ4RllhY3VIRTNGRGp3MldxcWpYUDhaQmJvdlRlckJiLzFvcWdD?=
 =?utf-8?B?Yy9oTm1WTmkwUEppQ3Q1cFFPWEgzRzhBd3BPUm8reVB3ODdMRGlwK2trT0hz?=
 =?utf-8?B?Q3d2ejZLNzRNZTF2QU5ubDVaVFp2SXY2aHd6OWhPalZ1dnFMblU1M3gxK05a?=
 =?utf-8?B?YzdnVTBYdXFqOS90MWhId1QyTTd1dkdySWpqL0xLaUZRdlBhWHdIZWVvYVFH?=
 =?utf-8?B?QUc2NzVDOUFFa1JrZU1URW56MjQrdjV0QmxIREN3Tk5wYy92MU91bDljNE9i?=
 =?utf-8?B?UXR5UGRGVm52QUhsQVAyTlVXR01kVHJrUXZRVXN0dVQ3eEJXZWUyYW5tNWpz?=
 =?utf-8?Q?CDLDU2?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akQvd05JTGs2ZTdsYjhEd0lhSWFOQUV0aTl0M2tPbHdsOGZSNU9QWFlEVkpn?=
 =?utf-8?B?MlljSlh1cTBtcXNXMm5WNHpkSGErQWVZYUJ5aWsyNVIwLzFVbm9PMmtRcU5z?=
 =?utf-8?B?Q2ppSE1WZ0hVamp4eWRUVlRYeHBNTWZIeTBxbTRYSS9tbGFmN1dDb2oxWFk4?=
 =?utf-8?B?ZXFtejdBbDMxZ05XQUdFME41SlF5VjhRbkFmWVRad0FBTWdoU0Urd2JPbTIy?=
 =?utf-8?B?b3NnVVpjT1FxRWFIb09oeXJUbGVQbWpNY3p6SzluRFdIVHFSQU1naStubTR6?=
 =?utf-8?B?L085RnlNNXpOMHRNeWw5WEJEWFRNSjA5RFc0WTl1K3V2NEZCRHk1R3YxaTlo?=
 =?utf-8?B?dFgveU5QdjE1Y3Yxa1d5dlhESXlHT3BERHUzT2xzRXVqVGs3Q3dlZHRDZHZC?=
 =?utf-8?B?VE1OMkR2QlRXRCtzbGlFZjVRcEJibXBLRFFYTkhpZDhOekdGVWQ4SStabG0x?=
 =?utf-8?B?VS9IdFBNRTZ3bXAvMjZqVHR0NC9RQ3puclVZNm1PdDJaZE1IcUU3MmZHV3Bx?=
 =?utf-8?B?UXh4aHdsZGxQRnlta2g4VjVyOXNCalNhQkhVS1BtZkhnV2ZMRi9OY1NEUHNa?=
 =?utf-8?B?U0tMZW11bzhXY0VzMUwvNGt1SDVNUTB4OWwrc3VIVmNRZkdPWXFuWlRqMlNB?=
 =?utf-8?B?eSt3WDBNM2dYWkdLdS9iYXVqRkJyRTBQdDNwbmlxUDh2UFBNVU1GS2J3ZUc2?=
 =?utf-8?B?U2hTZmF4T2o5VkcvK2RFeHZiSytCRXRRVHJXVytQdk5IRHJ6VC9UZ3B1c3R5?=
 =?utf-8?B?aG85NlhWaU5kNHg3YXYxOTNwdXNNYVh5NTk4WWloTEJQRTliL1VXV0RtUmZY?=
 =?utf-8?B?Qlczd3BidzJjSnNGZkF5c0d5ajV4QkhlcjdZWFEwOEV2LzRYVEE1N2ZzaUV1?=
 =?utf-8?B?QjhmMjF3RWEydThoSDlZKzBhK3dTRmdoTDJpaGdaYU9wSDVwV1VKYWwzRi95?=
 =?utf-8?B?N2NQMjc4TkZ4Ymc0WnhWZ3R5UDNtWDhERWtKL25VaVY0V0RDQlNOWE1BYk4w?=
 =?utf-8?B?aTFqdk12VllVYjAyRUpYb3lBdEJWb3RCdnNJQ0VCUDVFV1hvS2tybk83SlBX?=
 =?utf-8?B?b2dhL0Y4VGhKL0dpU3hUWE9xL0t1WWtxZ05xSzRwUTdwS21ZQ0hRcGl2VGhV?=
 =?utf-8?B?ZVgvbUNHSmFUWk1zN05FakprbFZoUUdpQ0NHeWtGZUErUXA4eGF5L2lhRHB5?=
 =?utf-8?B?cVg1anFyRHBQeVVFTVU0SG1TM0FkbEdWbGorQjdTS2dHMDdLRkVUeW55NDgy?=
 =?utf-8?B?K1VUTW9hZjM1bjJaRzRSMndoNy8xVzk3a3dCc1FJTkF5dzk1MEU2SThOY0Nt?=
 =?utf-8?B?eHBVTFZEZ2NoZlBYaU1QeFVYbC9iZUNweFl1N3NrWHpnRll2WVN0Z0JRTXdQ?=
 =?utf-8?B?MkhMV3A3STJMaFpEWlZjWDVvWFpSSG5pcHg3L0oxVXZuSnU4bVVCOEN2WG9q?=
 =?utf-8?B?cHZKRldwTkJCVGkweWxGMVNkYWxlS3lja2Roc3VhV3EvWEZCVXc2blltUmZX?=
 =?utf-8?B?K0YrTTJ1MjVxQWZTc1VDT2VETFI3TERLVnc5OE5JNFVRMkQyWkl6bS9nZ2NB?=
 =?utf-8?B?bUFTSDdmSUFNUWRIWnZMaE4wYkRCL3g4OTNFRkM3a0hqRnlpZlpkSHdhRFRV?=
 =?utf-8?B?dlorL0FpYlRyK3J0L2p1Vlovd1kyU2ZDZlNscUxUWGxBeUxDSmFicm82dlBU?=
 =?utf-8?B?OGRxN2VqRCtPUXlSbm0va3pPV3dQazdReXFzWlRxMDNiVWZRQndQSXVCNFBj?=
 =?utf-8?B?Rld0ZWg0U2MzL1dTTEEzYXBWWHprR3ZkZ25zay9kMGlUWmRidFJyS3ZhY0tl?=
 =?utf-8?B?WExwNlZJcnU2S256QnhYcldGbmpCbWtHYzNwUTI3M1BMQnd4QjdGWC9JYnUr?=
 =?utf-8?B?ZGhYKzU1SGl4OHc2MHlVczh2YWVuZXhndUxYWURpcEdHQkZwVlpaNTNORk5t?=
 =?utf-8?B?dXhUUXFaQXBUN1lDWnJKSmV2a1ZOZGgwbktoUzNUenRPYW83a2RvOXM2Z0VK?=
 =?utf-8?B?a3A2RDZsVklsRXhoQnYveEpwcEpJNDYwakpxZUNDMitjUzFySU1mSkRDQ3Y1?=
 =?utf-8?B?T0xsTWhYclM0MldaanB3MHhIYi9vajdQRXNZMXMwNkpkYTc5WWxOVkIzeE5z?=
 =?utf-8?Q?pFTMuRgM8kXtCZWhVupSgH7vs?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC4F557A6C6FE94CAD3071A756264B0B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a69b3e7-dfb3-4b83-c474-08de1abb1715
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2025 09:26:38.1573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M2GyfxGnXlofmJ3Z7O2x7DTK9IVPOH9upr/hZGHCCEnw6hLO6P73EGZe7q0fbQy+/Q5cOxSxWK2McnMYPKRjmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1CFCD9AEC
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDI1LTEwLTI2IGF0IDIyOjI0ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBTYXQsIDIwMjUtMTAtMjUgYXQgMTE6NTggLTA0MDAsIFNhc2hhIExldmluIHdyb3RlOg0KPiA+
IEZyb206IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiANCj4gPiBbIFVwc3Ry
ZWFtIGNvbW1pdCBiMTg2NTFmNzBjZTBlNDVkNTJiOWU2NmQ5MDY1YjgzMWIzZjMwNzg0IF0NCj4g
PiANCj4gPiANCj4gDQo+IFsuLi5dDQo+IA0KPiA+IC0tLQ0KPiA+IA0KPiA+IExMTSBHZW5lcmF0
ZWQgZXhwbGFuYXRpb25zLCBtYXkgYmUgY29tcGxldGVseSBib2d1czoNCj4gPiANCj4gPiBZRVMN
Cj4gPiANCj4gPiAqKldoeSBUaGlzIEZpeCBNYXR0ZXJzKioNCj4gPiAtIFByZXZlbnRzIG1hY2hp
bmUgY2hlY2tzIGR1cmluZyBrZXhlYy9rZHVtcCBvbiBlYXJseSBURFgtY2FwYWJsZQ0KPiA+ICAg
cGxhdGZvcm1zIHdpdGggdGhlIOKAnHBhcnRpYWwgd3JpdGUgdG8gVERYIHByaXZhdGUgbWVtb3J5
4oCdIGVycmF0dW0uDQo+ID4gICBXaXRob3V0IHRoaXMsIHRoZSBuZXcga2VybmVsIG1heSBoaXQg
YW4gTUNFIGFmdGVyIHRoZSBvbGQga2VybmVsDQo+ID4gICBqdW1wcywgd2hpY2ggaXMgYSBoYXJk
IGZhaWx1cmUgYWZmZWN0aW5nIHVzZXJzLg0KPiANCj4gSGksDQo+IA0KPiBJIGRvbid0IHRoaW5r
IHdlIHNob3VsZCBiYWNrcG9ydCB0aGlzIGZvciA2LjE3IHN0YWJsZS4gIEtleGVjL2tkdW1wIGFu
ZA0KPiBURFggYXJlIG11dHVhbGx5IGV4Y2x1c2l2ZSBpbiBLY29uZmlnIGluIDYuMTcsIHRoZXJl
Zm9yZSBpdCdzIG5vdCBwb3NzaWJsZQ0KPiBmb3IgVERYIHRvIGltcGFjdCBrZXhlYy9rZHVtcC4N
Cj4gDQo+IFRoaXMgcGF0Y2ggaXMgcGFydCBvZiB0aGUgc2VyaWVzIHdoaWNoIGVuYWJsZXMga2V4
ZWMva2R1bXAgdG9nZXRoZXIgd2l0aA0KPiBURFggaW4gS2NvbmZpZyAod2hpY2ggbGFuZGVkIGlu
IDYuMTgpIGFuZCBzaG91bGQgbm90IGJlIGJhY2twb3J0ZWQgYWxvbmUuDQoNCkhpIFNhc2hhLA0K
DQpKdXN0IGEgcmVtaW5kZXIgdGhhdCB0aGlzIHBhdGNoIHNob3VsZCBiZSBkcm9wcGVkIGZyb20g
c3RhYmxlIGtlcm5lbCB0b28NCihqdXN0IGluIGNhc2UgeW91IG1pc3NlZCwgc2luY2UgSSBkaWRu
J3QgZ2V0IGFueSBmdXJ0aGVyIG5vdGljZSkuDQoNCg==

