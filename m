Return-Path: <kvm+bounces-70143-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EOrIN2TrgmnqewMAu9opvQ
	(envelope-from <kvm+bounces-70143-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 07:47:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 69BBFE2681
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 07:47:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F283D3055979
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 06:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 043AA3570A4;
	Wed,  4 Feb 2026 06:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Os3uOv4D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0173859EC;
	Wed,  4 Feb 2026 06:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770187556; cv=fail; b=sTK4cov1zKgu/HQ6H141uJqT1XVhiP5eBqvq4yZTFxkn5vo8O+hvNygdCrlt4Wb45red7AKr+PHOv0Fj6CYzTEVoX3p9ynHGdxDywrM6DDnX4pLfe1giQ+qB4jWpYUpsxMJXpRx5RQ3sl3ey7CBtCBhrIoOm00A9RnYGh4xRQ/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770187556; c=relaxed/simple;
	bh=rpkAEhetkCB6VJ+9ctlQB/fRFpp/O2op9JzGmyatggE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RsCyKXed6FasYg3QJ9e8dIq2Vt1XOvd1hrGxkdRbMhUjFBVvV5R0GfcjVetzGrPp0NWS+M04TCf9/gPgDyW6YBC7vxEGXtYrMdlI8e4egDgMrruO0cWd2rqWtt4JfpkRsAaxVfzTQ46gU4oZRr2whgF8e/v2eKylBknYo/eBCfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Os3uOv4D; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770187556; x=1801723556;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rpkAEhetkCB6VJ+9ctlQB/fRFpp/O2op9JzGmyatggE=;
  b=Os3uOv4D2Fks+39hXsvDg6gcMfq5Pf3O8b0lp77GbVWCO8oReV8W89Un
   lwnFTLLy3e9Wv5c5HEG/36M4vnlJUSrjTwZyv8NBuAW+GT/Pa6aklgJiL
   rctj//xDWXJpmnVGiIi+AyG3if0X/DluwfSVYdaWjdEb/yQbBPYtQtbTl
   mnidj8EAx+SYFW8myo1sSo7LOaRePuOZL1SYeAinRzrrmzktqyaM79XK4
   PC4HiOPTvfTDs7IxZAnV9+D92NScAHQ2TI5IXFuXzINOP/t0/aRa1Cdkn
   DoqJVX+rR96pi3ZtAOU2Z3gmYcfAS0IYRnxmwK2c+lrP40xR0LblcU1gd
   g==;
X-CSE-ConnectionGUID: U9brg8TDS32XDXzZALeNkA==
X-CSE-MsgGUID: NzPDLLY9QZK43xjsVLUFqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="82000382"
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="82000382"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 22:45:55 -0800
X-CSE-ConnectionGUID: 0n6c9o5LQsi9wMqw1rZ7Mw==
X-CSE-MsgGUID: OKdG7UyOQGy9FaubZ3rjTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="247673944"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 22:45:55 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 22:45:54 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 22:45:54 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.23) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 22:45:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xgytRXE2kJZ47Pfbk3SoQxSujQ01Hdtd53+TI6KmabygEZCHG/shsVg0aXALUvwU66EQ2clSoLLrhbC3rf7Ik8K6e+i/VhsMBTsMWZia/nN/8WG46+wzxL8OTaDQmJCHxFps9l1xGrw3oUgdkK+ev6Y+RJ+7JROqb2UrxKS1JJ+KMIzomcnUq6wJSyBGkP7L5SX6Qgt8OKx4sM/LFEEGiJGniLfHWUdgjoVyBnVaw8rVt4A400ksM+sibviHO14qx88Lm6+G7ldV80uSdnhBYrYoFzhiKZiSGiPvIB2KO0XGrDCGypyvE91YlaR1fAuHmQBWLwGgcAtLkX9jH7GfvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rpkAEhetkCB6VJ+9ctlQB/fRFpp/O2op9JzGmyatggE=;
 b=XxTtnTSZaKQ7toHhUmyY/aW3NB8q1kpRRPwx6jQIYLCOVE3lxqIEhBkU8hKHIfGYqNvMCTKFEK527dm/Wr73w68QFzrxdXUrN9f/q1lG5wCNyE3q+puzT+6YK+4u7RHBJENUaj/NZBrBTMtdA0+OEURp2aI1XFIZnRyxjY1EGLaYSOQVqJauQ+b3BAxll9xdJ6XKt5D8fgxIafd3SUjZwc/C6Ylc/tE0hZrbmS6cAzi+CySru4yX1vWf9geLFPrHAoyGke0XUnRit62dfHYvwomW6CJb+eTKOqabFyKSHn9IkKfMWii563D876zzxujEWMG3ma5KtgTc28lJMSe12A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by PH0PR11MB7421.namprd11.prod.outlook.com (2603:10b6:510:281::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 06:45:51 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9587.010; Wed, 4 Feb 2026
 06:45:50 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "tglx@kernel.org"
	<tglx@kernel.org>, "sagis@google.com" <sagis@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Annapurve,
 Vishal" <vannapurve@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v5 19/45] KVM: Allow owner of kvm_mmu_memory_cache to
 provide a custom page allocator
Thread-Topic: [RFC PATCH v5 19/45] KVM: Allow owner of kvm_mmu_memory_cache to
 provide a custom page allocator
Thread-Index: AQHckLztHxU2OO4T/UW0cV8EUajfk7Vw1fCAgACbfwCAABWLAIAAUASAgABLUgA=
Date: Wed, 4 Feb 2026 06:45:50 +0000
Message-ID: <d79b72fcb1bfb2015420c61b8b5f0c563154ca3a.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-20-seanjc@google.com>
	 <de05853257e9cc66998101943f78a4b7e6e3d741.camel@intel.com>
	 <aYJWvKagesT3FPfI@google.com>
	 <a2bf6a8d9f9b61ae7264afc37d9925cf2e1f3ea9.camel@intel.com>
	 <aYKr7XODY-p6YLYa@google.com>
In-Reply-To: <aYKr7XODY-p6YLYa@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|PH0PR11MB7421:EE_
x-ms-office365-filtering-correlation-id: 2ad12cf5-209b-4cd7-20f8-08de63b90948
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SVNRZnNFdXAxMTV3b2V5RjM4dlZMbUVTVnBiY09hSG9XbWNjOEN0bmtIT01v?=
 =?utf-8?B?VE8vUkNnM2lnT1VTdVBLQ1NTalVIS3U1K05Ka1dCbGxsWTZ0MklVd0NtdStE?=
 =?utf-8?B?dHJhblJINUdUSUJ6VGNjQWJPYW5xa3VyWGtKZjRYbWdZN1ZVU0xRbVJtQ2ZV?=
 =?utf-8?B?dytXNDlNR3ZkdmxqM2VBRlBBL1N6SXVCMm1RR3NDWkpjK3Z2bnc2Q0EzRTFT?=
 =?utf-8?B?Nk1Tci9CbE9XaVhOWVlPYUk4ZmdSWGZDK1JQQzlzQ21DM1BhQ3R3WmZIemxD?=
 =?utf-8?B?Ym45R3A4Q0ZCYVg5TEtucHIzOVZFd1pWb2Y5Q051ZkFxZ291UldoUm9DaU55?=
 =?utf-8?B?RHJPTTd0b2pxWDRwN3hsZzJkblVhTytWQmtjVm8wc24vTVc5M0tBTlhHSVpn?=
 =?utf-8?B?bWVLaHhIdjdQMW5mN3ZlaHJpUHlTOGdRRVIzZVhnQWxQQ2tvRVRwWlAxak9z?=
 =?utf-8?B?ZkdzaDZIdlJ2UHlqa0c2ZGxmY2t2bWc5Uk56Q2J2NE9ZSFpSeHJsTkhEUFE2?=
 =?utf-8?B?K08vZXFQekU2SyszemF5MnRQeG5aSW44SXlMYzFlWjJkK3hGSVNzQ3FJYktF?=
 =?utf-8?B?L3AvMmJuNVVQTkU1NjBHbUtLaHdSVnFNQWF5QjBvQmUvL29LNSs5NUM1Ni9K?=
 =?utf-8?B?UW9STzk5M2k3clprTklTUFRIb1NiMzlzdG4zdDVLU3BQSXBmY0ZoL2tJVFB5?=
 =?utf-8?B?dkpuSlhqY3d3QW9SczJveGhVWW11S3VhQ1VINTBKQ2tQYWxVcVpQMXQzWG5Z?=
 =?utf-8?B?UURmdnpYSitPbGFGWERsTE04NVZXMFlFQ0lublRleVhMY1ZjZ21Mc2d0UkRn?=
 =?utf-8?B?dTVTcXpydS90RVhUSnBmM3czSU5XaHhUU0tNajc0enA5aHZEU2pTb0RBSzZZ?=
 =?utf-8?B?ZkFaQ29GOXM5NWJja094VzJ1SmpHMmhSaDRVeFJwSG5JZitqdC8zVW5LTVJX?=
 =?utf-8?B?TFljTXNEL2V6cEtpbTIrVkFDejh2WVQ1UUVzUFNIazFGZ1BIQm1XOHhqSWky?=
 =?utf-8?B?WWVxdmNYdzdNN056R1BXWEFhNlVhR2U2dEZ5dGwyRnN1Qkd6cDBGWmEzRm04?=
 =?utf-8?B?V1V6TW5hbWJsbkwrM3RLNTVjUWNoa0MvNUpTQlRCVVlud25DbTZtc2pxSm5x?=
 =?utf-8?B?SXdTcUZzcXF2U2hYaUU1Vmc0WTV2VVduUktVU05PY3FTN25WU3F6U2o0bE44?=
 =?utf-8?B?RmF6TVNnUVQzV2gxc1hxZUpmZTY0NGs5M0hYMzZaMTlzVXp4bGsrUGJEMEM3?=
 =?utf-8?B?eHlvcmlXYjlsbE9XY3JxaWdNV25vZUl6TzBMYnVGR0ZKOTFlQmdUY01MRjFu?=
 =?utf-8?B?NkNJd0Q0YVlNeko4Ym5qR3UvcERXc2I2L1FxdkxLalRDMjY1aHlRVVNnUEJq?=
 =?utf-8?B?Qlkzcm5lQlNrUStCUDF2aERQdEZTK1VHVmZuRmg0ZUhMU28wQU9Zd2FEWkd1?=
 =?utf-8?B?a3lRcmRFa080VW9QcVV6WmZUdkdDZkM0cmpwQkovSHJMcEt0SE1lbjFKYlBO?=
 =?utf-8?B?dk5zcWdhU0NZZjJRUldoQVVuWTVrOGg5UEZGVml2TTVpZGpVY2pUZmVtWDRr?=
 =?utf-8?B?RG5LZkIvZkI0YVd6TUoxUGRoVnFtUnl2dzZFem5BQTgzVTdnazhsd0F6ZFp1?=
 =?utf-8?B?cWVTQlkwY1hVUEgvbldzTVhZNjUrMmZrZFZCWmdaZkJmODJsYVNsWWFiY2FH?=
 =?utf-8?B?TkhmVmVVbm5sbGkySit6eHhIeFIvUEVOdWNCRkJ3Z0xPWGE4YzQ5SmpPYVVl?=
 =?utf-8?B?QWdBS0dZWkdpWWFGYzNVdEdFTFZxYjR0UFZrVnpMYXY2WkE4eTE5b0hVQW5V?=
 =?utf-8?B?MXE4UlIyQkdYOUk0SWY0SlgwVGZESnY4TzlJVzdNV3BLWjRqV05NWFF6cWFY?=
 =?utf-8?B?STRSR2duc2ozN2NFemI3VTd6Q2tKTDdJVTlWUlA1aUJvSm81c2FEQVdFT0dY?=
 =?utf-8?B?RDA0bXRuZU9XMURXc01JMXRXMU1hd2NUQ0FCYmxmeHZ5anU1cEM1aWZ3TS9h?=
 =?utf-8?B?R1M0N0xXaEhtb1cxRW50NUhTUnNoQndLdkNpczhLREU5NkVFS1BrNGhxeTBE?=
 =?utf-8?B?eFZ6ZCtlaHpGZ3EwcVR3U2pKTTVLWnZEczFTYlpSSTU1VElTTnVEYWpvN3E4?=
 =?utf-8?B?ZGowMENvNjUza1llK1B1TUY3RUwzVXJFTnMwRmZrUzdXRXh0bzEvemVJeUhM?=
 =?utf-8?Q?mUlJ3vu8cB4Ro1lAo5r0LZ8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OXBDRGhIMkNFNGl4bFYrY3lNK1Q3K2tZeW9sbFdpdmxUVVZLYTA4U2JSa2JK?=
 =?utf-8?B?MEhJOGx2QnVZbE5zaXZjM2t1ZVRTTFdibkg4SzlFMEdHT2ZnYTc5MHlMRkJE?=
 =?utf-8?B?K3BGOVhIaExnZGZlNVBRSndCaks2OGRzQk5SNW9SNmNmTHdxWS9oMndCSHFy?=
 =?utf-8?B?Z05xcHRKZFdrMWRMRWxCZUlPTFhXNExmenArcTNOU1Zva0d1RlNZTkg4Mlo0?=
 =?utf-8?B?NjZxbkZ6MTFHVWFPem1PRGpQV1FUb1NhWlIxdis2dUFmK1BpTHQ1ZHFKWWxT?=
 =?utf-8?B?UmZQaHFVY2lYSnZtMmZZSGRaUTdQamMrZGRLY0laUjNiR2xYNDlsOCtlZFNP?=
 =?utf-8?B?OVpqb2xhUDdSeEtqQlg1RGZudkczN21VOFAvRk9ONlBXNEhnRkFRa0hHUGM5?=
 =?utf-8?B?aUFGTzBBNjBtcklDQUExT0UvUGFudUNjdVJWQkhTZjBQQTlyNmoxa0NCbm5z?=
 =?utf-8?B?TEtIdkhsdCt6T0srUHZ3QnUyaGpsTGEzOWpYV09VaW1KcTk1enBQMitoVFpu?=
 =?utf-8?B?Q3Z3aDNUa1gxMGk3cS91cGJ2YkFEblA4bit4MVh3Wm5rQSs2YnJtVkhBTnNu?=
 =?utf-8?B?RXVGbGVxVDZmaENGNkI5U3dXNnRYTlFFWTNlSmRSZy9jYU1WOWFrQUVsdnlY?=
 =?utf-8?B?TzZFdG9PaG5QbGRmNm14ZCtvelBIdGVMWHZSZWE5OHRlQzR3MlF6akM2ZkF0?=
 =?utf-8?B?THFyZ1U3SmM5ZWJYL2JBVTNscjBYLzcrSjlDZUc1dzBVM0JLL2QvRTY3NGhh?=
 =?utf-8?B?dVAvcW4yR2Q4emZWbkFsZHQyTndwN29KcGhoOGZ4M0tPNkVVVGE0eHZpcXNU?=
 =?utf-8?B?UnhOd2ZZUEdZamt0UWI2MjIxK25TWTBOVU9NRk9uYVhncHpPWTlST2YyZmJi?=
 =?utf-8?B?QmRUMHp1eWhtNFFwVXU2bE05YmZaM2hxZTZOL2RxQTZIdzA3NkJxaWhDbFdo?=
 =?utf-8?B?bDNIT3RxeGV5YTJkeTMyWU90MmZScDR6MVVOaHNoR0MxV1lvMjdwS2l2b2px?=
 =?utf-8?B?SFU3Njh1aVJQY1ZYZDJKMTMxaVJkZ05EQUhpZmpZN2JmTWVWZXd1c0FhMmlk?=
 =?utf-8?B?ZnJGY1ZWTWlHdWhqb2lxRFR4Ym1Tb2xDb2hWb3hEcFEvZ3JZY3k5amlnR1Ny?=
 =?utf-8?B?bGJET2pGQXVTRExxOGxKZ3I4dzRxMXk0LzlucDdiR3E3MHQwRm5ZRUExenpl?=
 =?utf-8?B?TVlQN1ZEcFN6MmN2Y2FYWTNtdW5SYXF1dVZISnhCTG45czBianlJcm5nZEQy?=
 =?utf-8?B?WHhSTGNKanVyTW56TG85WTZUT3pPSFRpNVVVMnJXWTlYMmxKZnhOdkhwbHcv?=
 =?utf-8?B?QzJzOUQxRXlLUFJUUTZCeEZIRG1kM0xwbHVGTXB6M3M3UWZtK285d3RUVTl0?=
 =?utf-8?B?blNINVdmY2IvTVZGV2MweE15TjZMSnd2ZnF1dHE5d0VXck1pVzBVMWgwTVE4?=
 =?utf-8?B?YndZbWZ4anhaMEl4WE1qN0hxZHF1TisvRithWUFRYXVJcXd3VXcvQzNMWDNu?=
 =?utf-8?B?VW1zd0o2ZHhvWTNLc2N1WnphSmMrcUF1UkNoQ3hCeUwvdGpVNFEwZE5NVEg0?=
 =?utf-8?B?NENoV3lNVmI0V2tvaVZhM3pRTnFHZkNFbzdJSEpMdktHSFpNRzZLQmR6Vitx?=
 =?utf-8?B?SWk5dTg1NXFDaXhLankrd0xOVmhDZExqMDJMVG4xQkhUVjRleGFDc09scytD?=
 =?utf-8?B?Wk5mMkhoVk5GMk0zNTNqSkVWTHkrc1FvNWx2VUhQYmlzbXJUb2hyTlV0Q1NO?=
 =?utf-8?B?N0tmY0Q5VzZQRnM2ck5zUHBmbWI4UkdJajkxRjV6bEI4K1VTaU13UXVxZlpy?=
 =?utf-8?B?UURwZCtRR2puYU1BTC9McUdxeGl1T2FGT0phVVNxL1JuY2M4YURvcVFGRGJU?=
 =?utf-8?B?ZjVELy9ES2tuckhCZmVrcVJIRTlqcHNFYTV0dkpoYzhLMVFnTkttdmxtWmpE?=
 =?utf-8?B?eXo0QkN3L0hoUjBRUVNlVjJSSG12NWpZeElOMGJxR211QnQxWkw5ZlBPSDFn?=
 =?utf-8?B?MmprZmpiZWhicHRGT2VCQkJrbUltY1pRaFhYMS92V0U5azM1ZGFoVWFVTk0x?=
 =?utf-8?B?UlV3Rk5GNXhmMG5qeDdKMjRwZTI4Q0NvWjJrekdsTUhqeFEzSEFFK2xrSjR4?=
 =?utf-8?B?U09aZkI5ZHJLd3dEK1UwR0IzT0tZTFNENnNEMDV6dHJlUnh0ejZuZ1JVbzV4?=
 =?utf-8?B?YzI3Mk1oYlBQVnYwRzEvb1YrRUx0TVFVSXAwaWNET2JKN2NvQmRLbVVOS3A5?=
 =?utf-8?B?QkcyaUhGOXNRY09ibktrelBGSnRGd0dhQVVQd2lvcFp1eExwSjV0Mmdndlh5?=
 =?utf-8?B?M3VvNkxFb09DZkQxN2ZCMUhtU2w0NDl3NUxCR2NyTjJFZ05kSGVpZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B9D74E063C6378408A758DE78FA4EB56@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ad12cf5-209b-4cd7-20f8-08de63b90948
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2026 06:45:50.8932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qMXFWDSnC7FGKQr3OWBowCN786ORoiK7rkXmMlSDsiIWk3CBhDM0mFFA/tP2GskIq2NMKB0aqNKEhg+8Dg4eqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7421
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70143-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 69BBFE2681
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTAzIGF0IDE4OjE2IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEZlYiAwMywgMjAyNiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFR1
ZSwgMjAyNi0wMi0wMyBhdCAxMjoxMiAtMDgwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIFR1ZSwgRmViIDAzLCAyMDI2LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiA+IE9u
IFdlZCwgMjAyNi0wMS0yOCBhdCAxNzoxNCAtMDgwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90
ZToNCj4gPiA+ID4gPiBFeHRlbmQgInN0cnVjdCBrdm1fbW11X21lbW9yeV9jYWNoZSIgdG8gc3Vw
cG9ydCBhIGN1c3RvbSBwYWdlIGFsbG9jYXRvcg0KPiA+ID4gPiA+IHNvIHRoYXQgeDg2J3MgVERY
IGNhbiB1cGRhdGUgcGVyLXBhZ2UgbWV0YWRhdGEgb24gYWxsb2NhdGlvbiBhbmQgZnJlZSgpLg0K
PiA+ID4gPiA+IA0KPiA+ID4gPiA+IE5hbWUgdGhlIGFsbG9jYXRvciBwYWdlX2dldCgpIHRvIGFs
aWduIHdpdGggX19nZXRfZnJlZV9wYWdlKCksIGUuZy4gdG8NCj4gPiA+ID4gPiBjb21tdW5pY2F0
ZSB0aGF0IGl0IHJldHVybnMgYW4gInVuc2lnbmVkIGxvbmciLCBub3QgYSAic3RydWN0IHBhZ2Ui
LCBhbmQNCj4gPiA+ID4gPiB0byBhdm9pZCBjb2xsaXNpb25zIHdpdGggbWFjcm9zLCBlLmcuIHdp
dGggYWxsb2NfcGFnZS4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBTdWdnZXN0ZWQtYnk6IEthaSBI
dWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBTZWFu
IENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gPiA+ID4gDQo+ID4gPiA+IEkg
dGhvdWdodCBpdCBjb3VsZCBiZSBtb3JlIGdlbmVyaWMgZm9yIGFsbG9jYXRpbmcgYW4gb2JqZWN0
LCBidXQgbm90IGp1c3QgYQ0KPiA+ID4gPiBwYWdlLg0KPiA+ID4gPiANCj4gPiA+ID4gRS5nLiwg
SSB0aG91Z2h0IHdlIG1pZ2h0IGJlIGFibGUgdG8gdXNlIGl0IHRvIGFsbG9jYXRlIGEgc3RydWN0
dXJlIHdoaWNoIGhhcw0KPiA+ID4gPiAicGFpciBvZiBEUEFNVCBwYWdlcyIgc28gaXQgY291bGQg
YmUgYXNzaWduZWQgdG8gJ3N0cnVjdCBrdm1fbW11X3BhZ2UnLiAgQnV0DQo+ID4gPiA+IGl0IHNl
ZW1zIHlvdSBhYmFuZG9uZWQgdGhpcyBpZGVhLiAgTWF5IEkgYXNrIHdoeT8gIEp1c3Qgd2FudCB0
byB1bmRlcnN0YW5kDQo+ID4gPiA+IHRoZSByZWFzb25pbmcgaGVyZS4NCj4gPiA+IA0KPiA+ID4g
QmVjYXVzZSB0aGF0IHJlcXVpcmVzIG1vcmUgY29tcGxleGl0eSBhbmQgdGhlcmUncyBubyBrbm93
biB1c2UgY2FzZSwgYW5kIEkgZG9uJ3QNCj4gPiA+IHNlZSBhbiBvYnZpb3VzIHdheSBmb3IgYSB1
c2UgY2FzZSB0byBjb21lIGFsb25nLiAgQWxsIG9mIHRoZSBtb3RpdmlhdGlvbnMgZm9yIGENCj4g
PiA+IGN1c3RvbSBhbGxvY2F0aW9uIHNjaGVtZSB0aGF0IEkgY2FuIHRoaW5rIG9mIGFwcGx5IG9u
bHkgdG8gZnVsbCBwYWdlcywgb3IgZml0DQo+ID4gPiBuaWNlbHkgaW4gYSBrbWVtX2NhY2hlLg0K
PiA+ID4gDQo+ID4gPiBTcGVjaWZpY2FsbHksIHRoZSAiY2FjaGUiIGxvZ2ljIGlzIGFscmVhZHkg
YmlmdXJjYXRlZCBiZXR3ZWVuICJrbWVtX2NhY2hlJyBhbmQNCj4gPiA+ICJwYWdlIiB1c2FnZS4g
IEZ1cnRoZXIgc3BsaXR0aW5nIHRoZSAicGFnZSIgY2FzZSBkb2Vzbid0IHJlcXVpcmUgbW9kaWZp
Y2F0aW9ucyB0bw0KPiA+ID4gdGhlICJrbWVtX2NhY2hlIiBjYXNlLCB3aGVyZWFzIHByb3ZpZGlu
ZyBhIGZ1bGx5IGdlbmVyaWMgc29sdXRpb24gd291bGQgcmVxdWlyZQ0KPiA+ID4gYWRkaXRpb25h
bCBjaGFuZ2VzLCBlLmcuIHRvIGhhbmRsZSB0aGlzIGNvZGU6DQo+ID4gPiANCj4gPiA+IAlwYWdl
ID0gKHZvaWQgKilfX2dldF9mcmVlX3BhZ2UoZ2ZwX2ZsYWdzKTsNCj4gPiA+IAlpZiAocGFnZSAm
JiBtYy0+aW5pdF92YWx1ZSkNCj4gPiA+IAkJbWVtc2V0NjQocGFnZSwgbWMtPmluaXRfdmFsdWUs
IFBBR0VfU0laRSAvIHNpemVvZih1NjQpKTsNCj4gPiA+IA0KPiA+ID4gSXQgY2VydGFpbmx5IHdv
dWxkbid0IGJlIG11Y2ggY29tcGxleGl0eSwgYnV0IHRoaXMgY29kZSBpcyBhbHJlYWR5IGEgYml0
IGF3a3dhcmQsDQo+ID4gPiBzbyBJIGRvbid0IHRoaW5rIGl0IG1ha2VzIHNlbnNlIHRvIGFkZCBz
dXBwb3J0IGZvciBzb21ldGhpbmcgdGhhdCB3aWxsIHByb2JhYmx5DQo+ID4gPiBuZXZlciBiZSB1
c2VkLg0KPiA+IA0KPiA+IEZvciB0aGlzIHBhcnRpY3VsYXIgcGllY2Ugb2YgY29kZSwgd2UgY2Fu
IGFkZCBhIGhlbHBlciBmb3IgYWxsb2NhdGluZyBub3JtYWwNCj4gPiBwYWdlIHRhYmxlIHBhZ2Vz
LCBnZXQgcmlkIG9mIG1jLT5pbml0X3ZhbHVlIGNvbXBsZXRlbHkgYW5kIGhvb2sgbWMtcGFnZV9n
ZXQoKQ0KPiA+IHRvIHRoYXQgaGVscGVyLg0KPiANCj4gSG1tLCBJIGxpa2UgdGhlIGlkZWEsIGJ1
dCBJIGRvbid0IHRoaW5rIGl0IHdvdWxkIGJlIGEgbmV0IHBvc2l0aXZlLiAgSW4gcHJhY3RpY2Us
DQo+IHg4NidzICJub3JtYWwiIHBhZ2UgdGFibGVzIHN0b3AgYmVpbmcgbm9ybWFsLCBiZWNhdXNl
IEtWTSBub3cgaW5pdGlhbGl6ZXMgYWxsDQo+IFNQVEVzIHdpdGggQklUKDYzKT0xIG9uIHg4Ni02
NC4gIEFuZCB0aGF0IHdvdWxkIGFsc28gaW5jdXIgYW4gZXh0cmEgUkVUUE9MSU5FIG9uDQo+IGFs
bCB0aG9zZSBhbGxvY2F0aW9ucy4NCg0KTm8gYXJndW1lbnQgb24gdGhpcy4gIFBlb3BsZSBoYXRl
IGluZGlyZWN0IGNhbGxzIEkgZ3Vlc3MuIDotKQ0KDQo+IA0KPiA+IEEgYm9udXMgaXMgd2UgY2Fu
IHRoZW4gY2FsbCB0aGF0IGhlbHBlciBpbiBhbGwgcGxhY2VzIHdoZW4gS1ZNIG5lZWRzIHRvDQo+
ID4gYWxsb2NhdGUgYSBwYWdlIGZvciBub3JtYWwgcGFnZSB0YWJsZSBpbnN0ZWFkIG9mIGp1c3Qg
Y2FsbGluZw0KPiA+IGdldF96ZXJvZF9wYWdlcygpIGRpcmVjdGx5LCBlLmcuLCBsaWtlIHRoZSBv
bmUgaW4NCj4gPiB0ZHBfbW11X2FsbG9jX3NwX2Zvcl9zcGxpdCgpLA0KPiANCj4gSHVoLiAgQWN0
dWFsbHksIHRoYXQncyBhIGJ1ZywgYnV0IG5vdCB0aGUgb25lIHlvdSBwcm9iYWJseSBleHBlY3Qu
ICBBdCBhIGdsYW5jZSwNCj4gaXQgbG9va3MgbGlrZSBLVk0gaW5jb3JyZWN0bHkgemVyb2luZyB0
aGUgcGFnZSBpbnN0ZWFkIG9mIGluaXRpYWxpemluZyBpdCB3aXRoDQo+IFNIQURPV19OT05QUkVT
RU5UX1ZBTFVFLiAgQnV0IGl0J3MgYWN0dWFsbHkgYSAicGVyZm9ybWFuY2UiIGJ1ZywgYmVjYXVz
ZSBLVk0NCj4gZG9lc24ndCBhY3R1YWxseSBuZWVkIHRvIHByZS1pbml0aWFsaXplIHRoZSBwYWdl
OiBlaXRoZXIgdGhlIHBhZ2Ugd2lsbCBuZXZlciBiZQ0KPiB1c2VkLCBvciBldmVyeSBTUFRFIHdp
bGwgYmUgaW5pdGlhbGl6ZWQgYXMgYSBjaGlsZCBTUFRFLg0KPiANCj4gU28gdGhhdCBvbmUgX3No
b3VsZF8gYmUgZGlmZmVyZW50LCBlLmcuIHNob3VsZCBiZToNCj4gDQo+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYyBiL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jDQo+
IGluZGV4IGEzMjE5MmMzNTA5OS4uMzZhZmQ2NzYwMWZjIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4
Ni9rdm0vbW11L3RkcF9tbXUuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0K
PiBAQCAtMTQ1Niw3ICsxNDU2LDcgQEAgc3RhdGljIHN0cnVjdCBrdm1fbW11X3BhZ2UgKnRkcF9t
bXVfYWxsb2Nfc3BfZm9yX3NwbGl0KHN0cnVjdCBrdm0gKmt2bSwNCj4gICAgICAgICBpZiAoIXNw
KQ0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIE5VTEw7DQo+ICANCj4gLSAgICAgICBzcC0+c3B0
ID0gKHZvaWQgKilnZXRfemVyb2VkX3BhZ2UoR0ZQX0tFUk5FTF9BQ0NPVU5UKTsNCj4gKyAgICAg
ICBzcC0+c3B0ID0gKHZvaWQgKilfX2dldF9mcmVlX3BhZ2UoR0ZQX0tFUk5FTF9BQ0NPVU5UKTsN
Cj4gICAgICAgICBpZiAoIXNwLT5zcHQpDQo+ICAgICAgICAgICAgICAgICBnb3RvIGVycl9zcHQ7
DQo+IA0KDQpJZiB3ZSBsb29rIGZyb20gInBlcmZvcm1hbmNlIiBwZXJzcGVjdGl2ZSwgeWVhaCBp
bmRlZWQsIGFsYmVpdCB3ZSBwcm9iYWJseQ0Kbm90IGdvbm5hIHNlZSBhbnkgcGVyZm9ybWFuY2Ug
ZGlmZmVyZW5jZS4NCg0KQnV0IG5vIG1vcmUgYXJndW1lbnRzLiAgSSBqdXN0IHRoaW5rIGl0IHdp
bGwgYmUgbGVzcyBlcnJvci1wcm9uZSBpZiB3ZSBoYXZlDQphIGNvbnNpc3RlbnQgd2F5IGZvciBh
bGxvY2F0aW5nIHRoZSBzYW1lIG9iamVjdCAobm8gbWF0dGVyIHdoYXQgaXQgaXMpLCBidXQNCml0
J3MganVzdCBhIHRoZW9yZXRpY2FsIHRoaW5nLg0K

