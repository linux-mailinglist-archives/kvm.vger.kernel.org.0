Return-Path: <kvm+bounces-58836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 391F1BA1F71
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 01:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44E8C1C016FD
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 23:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0157C2ED870;
	Thu, 25 Sep 2025 23:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bDme0hAH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F20A2ECD27;
	Thu, 25 Sep 2025 23:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758842847; cv=fail; b=CR2mSQOTu+ed2opj6bSqdmHv1VTIgPRSgCmewc4pr1Bx4NSlHp1uCCgX3ANoQu1jdt5eiTsmt4ZpO9VIe97wp0211hoYoe4F+IUdEY/dMl657G5Nor2acnLfbP2SDeTJj2S7tWBMzzrpngaVsFsp8EJcdurktzWssPwL2SMpTew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758842847; c=relaxed/simple;
	bh=IvuiahBr1dBESxddPXqEk4sgXfXypUQqd+GOnblCByE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HHWdey2PEPHbNc/OKu1WkjENiPwuDmnhIotwTnbrGSCsNOjkjYkzi421GxVf0yxowkvPdTlHMhlSJqqsjMc/TN43yh2bMNL5slT48xHkLH/Oy99fMGQ2MSUFNJeaUOhBciUV/VegrGcNMzWLzZKlXoI6P80viJVZxY/C9RcvOGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bDme0hAH; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758842844; x=1790378844;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IvuiahBr1dBESxddPXqEk4sgXfXypUQqd+GOnblCByE=;
  b=bDme0hAHu1TxyXrd3Zjyp8ejie5u0qhdtgxqzJU8jnTxQgINaUs3F0+Z
   YfDnQ6QOI/dWMOfxCkmTafcoh5dkNp4iIHi0oYkedLgGxZJOZnuhKx5XJ
   sDyMtLalZHlm8QL71VhrXCBfxAUsMhayiGj/uSh+xXZfBoj2aotypSY4d
   lN9VoJ0EoKTQmH9t0Y40zL+uPbPaFaOQLCnVMpexzx0GN1IWsOYthY0hE
   pd12u3rPv0e9n4+ZLXoSU+6qrlP4jxmqhsMZIYKh4nBFWpzUXvIvGmF6N
   D34jwD/YGjWsfGkLt54NG/5saxtWrGtPI2zR8T3mPckCprQhBlIS5/4Z6
   Q==;
X-CSE-ConnectionGUID: lC9278a+R4CXC31udpXoQA==
X-CSE-MsgGUID: lmNf3MDMR6O+c6tmFXhRtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="48739226"
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="48739226"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 16:27:23 -0700
X-CSE-ConnectionGUID: 1vAG45VpTfW7Mb3Vci25gA==
X-CSE-MsgGUID: cWBBleeyRe6uYhHliozDDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="208189123"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 16:27:23 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 16:27:22 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 25 Sep 2025 16:27:22 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.18) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 16:27:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JBjJSzlSy4OBxXrBirdz/kk/KlPAfTlEediPTWACVdhNlREtfBd6ByPdaOQWzTqAIrXT1opwivCtEYMuuaBXhkuPwBRBE8sQSF/hhE4LmxP9T51JTBBcS70WIJNbKt+TwUYHY8ot+9k/ndIezCrl9jUkk7sUof9U8Wyy/JpyFP2itXct0/a2mi5Efq0XcD4JMJWbnutPaXld8a4pRF4gve+aeFMghfrOwvUb8+e4oHCdSsv4s6Iu5H5hlc436dKGmfR7Nh7sfyc4XflZ28mpAKpSvPMY1kmoJStE32Up5bU5zVvLam32cWEH2P531Goqbn2vSaMIvPr4AADb8hHKdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IvuiahBr1dBESxddPXqEk4sgXfXypUQqd+GOnblCByE=;
 b=guVIWY6RCkvkWZ0G0vgimImkfc6cjBn5iJxa/v06iLQQMZmi7rkAZnubee6F7HdW/j6Ebs+GH7YfHIMvD5dr7BLE5SVzRkIT9C3E6Q/aBCihDX3QYe/Df3kKEXwUttdkYHJSNZxyqboLKiN5Kp8KNwoC/Ga3UXYcP8HyCD13dOmtfW73j3FMLXLjxzF6BGvpt/dCExNZgr+c24t0BpBvogfBDMenzAQpdkO/VflIbDwj9LXpfhIW9TZ/iW4neRiyAm6BlneAjNxTOwJUXuq9zJ6Y7LDcg8kkkm+nfD6J8IZader4av4JYJ/qO5m6gx0jJlv2Akv2oBh8y4uqfTe9xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6835.namprd11.prod.outlook.com (2603:10b6:510:1ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Thu, 25 Sep
 2025 23:27:17 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 23:27:17 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 02/16] x86/tdx: Add helpers to check return status
 codes
Thread-Topic: [PATCH v3 02/16] x86/tdx: Add helpers to check return status
 codes
Thread-Index: AQHcKPM0E+1js7qjUU+dZA1L0QEu+LSZtweAgAre7gA=
Date: Thu, 25 Sep 2025 23:27:17 +0000
Message-ID: <4329744271df779da74e0c7037feb41b8ccf2a5a.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-3-rick.p.edgecombe@intel.com>
	 <430fc8f43b049c337b1268d181751280dcb09b33.camel@intel.com>
In-Reply-To: <430fc8f43b049c337b1268d181751280dcb09b33.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6835:EE_
x-ms-office365-filtering-correlation-id: 900bd3d8-608a-45a1-f537-08ddfc8b111e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?QlFtN3FXTTk5ZWk2aUJXc3FIQlhiWWQ3UlFQNVpOZ0NZNjV6VjROVmtkRElP?=
 =?utf-8?B?Yml0Sjk5SVE2Q0s4Q1d2RWdldXltMGptUll3YmMwbUR5UXhib3FvcUlwSk5G?=
 =?utf-8?B?UUY5eldSRitOMWwyNVVwYVB1SWtuRmg5TFdRUk5saW8xOU01L2FPZ0RPODRX?=
 =?utf-8?B?T0ZoKzNvU3dMYWRlZnBNOG5TN1FoNU9TSW5lWks0QkVXYkpyb0JpVVBpV3NG?=
 =?utf-8?B?SHNBYUw2MVlTOXJmY3YzUldGeG9tL2tUQTdHSHNqeGx5THhjekVpRFNmeGRO?=
 =?utf-8?B?TDVOUXk5ZE9zb0s1am5SZWw0dDNuaVorcUJ2Q0FlM1c1ZXF6ZUVYMmVmMGpv?=
 =?utf-8?B?eFc4ZDEzRVJFTUFmcU12WEN4WmVab1BPUUszQ0NhR3o3MVlRTTNQak0xcisw?=
 =?utf-8?B?SUFmYXRKdTFxUEJTczhrQ0VjQ0FqcEFrczBReVlQUXJaRWNqQlNRelhhcGhM?=
 =?utf-8?B?aFJFZG8ydXFyRUw5OGlhRFM4WXh0dlNheHB3TW9RR0xZREgwNzJuOGsxb1lk?=
 =?utf-8?B?Y0R5N3ZKTVBJTFVsRmtQVU5xeVBkdWRiQ0JYWERIMC9KUmJ3L1IzRUlmOXkr?=
 =?utf-8?B?T3Z4TDhHa2k5aUF4bldxOG5VV1lNZ1p5aUVKcVVYMWVzaEhPL3dCbVh3Nnls?=
 =?utf-8?B?cmFaR01RUHI4QW12UDNSZEZnVGl0ZVJsRHoyMThGZnozZVlkV09Jemw4Q3pa?=
 =?utf-8?B?M3FrQmhiK3V2MGJiTDlTZHhvNmJwZUtyWUlsNHdhN0JXcE5qSjMyaWdxZmdP?=
 =?utf-8?B?ZTB1M0QrbVVHdzEvNUtHVGRvbldmRHgwc0kzL1hwMU9kdi9UVXlQeGRJYmZ1?=
 =?utf-8?B?aWZldmJsY1doaXhLN016aEFBY2F4R2dRQm13djdnKzRhL0QydHNWQk5wYWtR?=
 =?utf-8?B?bGJ5ZG5RZXQzSnY0UWh3bEZkOVJKS1dlUnpYTjJoWmZLdlU0aGt0K3FzM2ZI?=
 =?utf-8?B?R0J6Q0J1aXg1eDliRm5wYjRaUDdDSEM3MEttb3lOcFFNM1JIQzdPdEc4S0FX?=
 =?utf-8?B?VURhZlZvYVVjK0pxcHVxanJrNGc0REo5M1h4a0ZDcFJpdFFvZ0JpUWtiUDR0?=
 =?utf-8?B?QnJxZ004cHhTdE52c0Z0aGlvOXhNQk4xTlZLbnVVVzZRWng4VGRKeU5ZOVEr?=
 =?utf-8?B?bHd5YnFnUFRpYzVjUW5ENVp3RzlWbHEzVWpwNXRvb0lvbldWRnZlN2oyWlNY?=
 =?utf-8?B?K0wrSm91NXJ6cEk2bGxFVE5RdGlnQ3Y5MTExWGlzaUJHNGl5MFdhTUN2L3Vs?=
 =?utf-8?B?SDEvMDNyVEt5N0pwa3lURk9RbmRBUEJ1WitzaDNtVEJaYXJ1Y2hBWmlCNkZX?=
 =?utf-8?B?RlpFbHdyWW5iTm5sRkR5ZmNiaHdYdk9SMEhzNlFtelE5V24zYWNtaXRnYXEz?=
 =?utf-8?B?anZNbzRzcyt0RDdmTWNXMm4vTGttSjNMUmlFK1hrUjNMa0VYWWhvREtZanB0?=
 =?utf-8?B?WlZqbWlHUWlHWllNL25IYVN1bXczbDd6MFk1amE5NGRPc01UbGlhMFpnMjZZ?=
 =?utf-8?B?UzRvYXRtR1J3OGZRb3VIOTJxM2ZxRnhQVlJEYlRGMXJncWd2WnNIakJLSGdC?=
 =?utf-8?B?Qy9QMEdxdXN4YzRMRytrbmltdTdpK2VTRFJCLy9UM3ZYdlNnTC9vOEM5VkEy?=
 =?utf-8?B?MW92Uys1VVhPakhvTWlJenJaMG5xWUxHKzdUVWFNUjFIOWRiQU5tbzBxR2Jx?=
 =?utf-8?B?aWFiOElHdFNiSjNnS3k1LzU4WHVWU0M1V1VpdldvQ0lsZ1NOakNJbWdRZ0tR?=
 =?utf-8?B?WmJqUkIvWjNWSFl3Qkg0Z0hMaVdoQWF5cU5VeWVoL3RtaGRybUZjdG4wS2Q5?=
 =?utf-8?B?aFp3bVVRYTEwOS9pOWdtbnZoZTkrU2VmakczWlBuMEtXWVNHUkU2UW0yWmtv?=
 =?utf-8?B?MUtlWFROcElHSzQzR3ErallOaGREM2x1ZkZiVER3UkFnTU9Ic0x5UUx5S2ZJ?=
 =?utf-8?B?Z1ZwYWtSNDJYakRjT1UwR0lzWG5odXM5SE95MWp3UXZFdnB6S1N5ZEFZRDly?=
 =?utf-8?B?T2lla011Y3BOWTJoT25LL3Y4bzJmclRJbDFBVFEyUms3OHhFNUpxeUF0UTJE?=
 =?utf-8?B?KzdCbnRlQXhYVWdqWXBUQnNYVS9ySytRckdVQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eC9aT0ZrSkM3YlJMRUltZEQyVFgwK2lCK0VCdFkzUGdDMmVoYnp3MkVyR0lm?=
 =?utf-8?B?elE5Skc4MVhoZ0xYeEEwQzA3VmZyQ3BXQ1BFditnUUZBbkhtYXV1RkNvblRL?=
 =?utf-8?B?Z1U1K3Evdmhlc3VZZk4veGR3WW0wL3o2RlJZbVBXS3Rxa2ZPcDZUaFJKWjFj?=
 =?utf-8?B?VHBwVjkybDQrWEpUTzF2MHdDeXRhOVd4czJzcE44Q3ZkOGU0a2ZiTUhpNmVj?=
 =?utf-8?B?ZDF0UUZpODJtTjU0RmNMNE1xTVVSSXFyRlJZeG5mcDVheDgzNzVhVFJiU0F2?=
 =?utf-8?B?YTkxd2hvWEQ2bHpPYXJwcFdNbWVLTlZqZ0swczlka0Y0MlB0Kzh3ZktqcUx0?=
 =?utf-8?B?bEdIQU9LVTdMSGhxQWo4Q0kyMWZYSEJSeVkzL0xlTHpnZFIrR01lYWxYWXA4?=
 =?utf-8?B?SDU0VjdNMjdVWVZkdStwdFpqR2RNR1ZJOThzd0NjRFoweWpzZlhnUWcxUTVl?=
 =?utf-8?B?ZzMrZERvNjVZK2lINXdsVC80MjU2Yk43aDlxaHNjL3lpbFpCL2JQQkk3RWFV?=
 =?utf-8?B?ZkMzSStVdC8zdVB2VWRLb3F2dGljcnR3ODNKOEg2YlZTYTRKRjhINThLZmFr?=
 =?utf-8?B?TTFkTEtaU2xEWlpiZU0vaGJGMHY4cFRTRGxwTnVCaDRSYklESXZ2bldyM0d6?=
 =?utf-8?B?ZitzWkJMdy96TlBQMlRIME85anMxZUt3WHYwSzhRaWN1NGIzQVBuT0hleFdR?=
 =?utf-8?B?eTdzRVpiejM2bnlnL1dONWVBSzErbmF6TThtd1E5NVZmQUZOd2pyMjYwbytK?=
 =?utf-8?B?RzRVZWRwK1NKZTcyVUVuc09kSWp2bmZoYnYwVlNCSGtCWHcvS2w3R1B3SjNr?=
 =?utf-8?B?bGlHc2lYWHlGYTRYVWY0MWlxVWo5TmxiTWZuTGRxOElkenlwN0s0anh2MkYy?=
 =?utf-8?B?TStmMGRabjRGVTVNb3M5a3dwTXVmN05BUWtPclNraWRKRlhUeDJxS0VqL2tW?=
 =?utf-8?B?SS9XYXc3UjFUeEJCak9WMXJCeEJoNDU0eU8rbThWSHZtZlFWWHF6dGZmTmRF?=
 =?utf-8?B?OEgrckJvVmV6cDJFR0VxTEYvcDhXNWpiQnQ3V1NzTm9mdkxDWU9YakxCWHk5?=
 =?utf-8?B?NFBIZXcxZVMyL3VCOWV5aXMrTERYdjN3K01vYy8zRlI4S0ZLUjdXTGpPOG44?=
 =?utf-8?B?dnhXbTRvdlhpZnZ4WDl1M2x5dXJ6TFpaTkY1YkpmYlIyRE9GaE5oYk1UYTFB?=
 =?utf-8?B?V2FCdmZ0bG9UVjJWdkh4TXBsbllvaFJNSitFRVZiUzJiUGxwTGltVHBVaWRI?=
 =?utf-8?B?Smg5KytUYzllNkVqRWx5a056RVFjdVV5dVVuaUZoRXZveTRJQVBMaDQzYzRS?=
 =?utf-8?B?R3RqclpPUTNUekErcnJ3aVJ3MjNZSGFGRFpLNmx4bmZ1cm44RUVDVVRia3Bw?=
 =?utf-8?B?b3JyaDhhM25jclBrcXdYVlA3RUNSVUY5SFZuZmNWTlk0MDRoMVlUTTZ0T2hS?=
 =?utf-8?B?Z3Q2cXhMeUhMV2xhb2pvS2g0MW1BWGdKMy9JZnFLYkl1Si82QW5xZzdYV1U2?=
 =?utf-8?B?Z2JDMTM3YmNzcitRUlBSUm5udm1WZTliT2RRVzdkYkpvZFUzZm1pczdNL1FN?=
 =?utf-8?B?ZkxuN0syVlJNTUYvcHI5WEVudjc4YXRxWkVnQXdCMFpDL2tLeFk4ZWpjSTNK?=
 =?utf-8?B?dFprQVBQdW52aEJvKzQwUURHRHZyejRiNndaREdualBIRjhJcXB5TUQwMUpQ?=
 =?utf-8?B?VGZhZDZsSUJ1MWxqRmRiM1I5Z0Q2aHNLK0syTGRDMGtPSTZOc082dk1qRzJk?=
 =?utf-8?B?bnNiUEhBQVhOTWJiMWg4OFdPSHMvUVprejhTbm1Ob0poZUI4N3VWQkJoV0xZ?=
 =?utf-8?B?bVA4NTVjcENaakpsalNZTHFRSUJRRklJT2QzTU15TmRrSFlZNXBFYWNvREdM?=
 =?utf-8?B?eTJOTk1jUlR1S3kwSlN3L2JiS2M0aCsxY1Nkdzh6Y0RxdXVvSlIrNmpLQkp3?=
 =?utf-8?B?S1NRbFpPa2QwZjlDNDBBenRsV1Jtb2VSS3N6THVxQWxGaEFmRWFTdFZsRjYy?=
 =?utf-8?B?SHJrSk4wOW55T1cwU1dUOENFeFlVOVVoRGVJLzlxRGhLdElUeDQ1VVd4WVBv?=
 =?utf-8?B?c3VpWmlhVlIrMXFYdFdSMXhPeG1IbG9vc0krRjZOSDExTC8xMDBXR1ZFdmF0?=
 =?utf-8?B?ZlFMUzNIS2tTaXl0TU1PckczaGIwbDNhSGMwL0kyRk5MbEY2VVptTmNTbmtE?=
 =?utf-8?B?YVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <51B1950BF0C4E84ABD9EF0816DF70EF8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 900bd3d8-608a-45a1-f537-08ddfc8b111e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2025 23:27:17.3923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uYPowQouzhyREs4VNmsJcMeCJRz7LPB416Fnn2zN4Mogit6nSYIAhtYKU5uKyuCunRoJuaHQ0m6xcVlLwdIDcgamcOWbcvqKw8307pjLRL8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6835
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA5LTE5IGF0IDAxOjI2ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
ICsjaW5jbHVkZSA8YXNtL3RyYXBuci5oPg0KPiA+ICsNCj4gPiDCoCAvKiBVcHBlciAzMiBiaXQg
b2YgdGhlIFREWCBlcnJvciBjb2RlIGVuY29kZXMgdGhlIHN0YXR1cyAqLw0KPiA+IC0jZGVmaW5l
IFREWF9TRUFNQ0FMTF9TVEFUVVNfTUFTSwkJMHhGRkZGRkZGRjAwMDAwMDAwVUxMDQo+ID4gKyNk
ZWZpbmUNCj4gPiBURFhfU1RBVFVTX01BU0sJCQkJMHhGRkZGRkZGRjAwMDAwMDAwVUxMDQo+IA0K
PiBOaXQ6IHRoZSB3aGl0ZXNwYWNlL3RhYiBjaGFuZ2UgaGVyZSBpcyBhIGJpdCBvZGQ/DQoNCkkg
ZG9uJ3Qgc2VlIGl0LiBJdCBrZWVwcyB0aGUgYWxpZ25tZW50ICh0aGF0IGFsc28gbWF0Y2hlcyB0
aGUgYmVsb3cgaHVuaykgd2l0aA0KdGhlIG5hbWUgbGVuZ3RoIGNoYW5nZS4gQ2hlY2sgaXQgaW4g
YW4gZWRpdG9yLg0KDQo+IA0KPiA+IMKgIA0KPiA+IMKgIC8qDQo+ID4gwqDCoCAqIFREWCBTRUFN
Q0FMTCBTdGF0dXMgQ29kZXMNCj4gPiBAQCAtNTIsNCArNTQsNTQgQEANCj4gPiDCoCAjZGVmaW5l
IFREWF9PUEVSQU5EX0lEX1NFUFQJCQkweDkyDQo+ID4gwqAgI2RlZmluZSBURFhfT1BFUkFORF9J
RF9URF9FUE9DSAkJCTB4YTkNCj4gPiDCoCANCj4gPiArI2lmbmRlZiBfX0FTU0VNQkxFUl9fDQo+
ID4gKyNpbmNsdWRlIDxsaW51eC9iaXRzLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC90eXBlcy5o
Pg0KPiA+ICsNCj4gPiArc3RhdGljIGlubGluZSB1NjQgVERYX1NUQVRVUyh1NjQgZXJyKQ0KPiA+
ICt7DQo+ID4gKwlyZXR1cm4gZXJyICYgVERYX1NUQVRVU19NQVNLOw0KPiA+ICt9DQo+ID4gDQo+
IFsuLi5dDQo+IA0KPiA+ICtzdGF0aWMgaW5saW5lIGJvb2wgSVNfVERYX1NXX0VSUk9SKHU2NCBl
cnIpDQo+ID4gK3sNCj4gPiArCXJldHVybiAoZXJyICYgVERYX1NXX0VSUk9SKSA9PSBURFhfU1df
RVJST1I7DQo+ID4gK30NCj4gPiArDQo+ID4gDQo+IA0KPiBbLi4uXQ0KPiANCj4gPiArI2RlZmlu
ZSBERUZJTkVfVERYX0VSUk5PX0hFTFBFUihlcnJvcikJCQlcDQo+ID4gKwlzdGF0aWMgaW5saW5l
IGJvb2wgSVNfIyNlcnJvcih1NjQgZXJyKQlcDQo+ID4gKwl7CQkJCQkJXA0KPiA+ICsJCXJldHVy
biBURFhfU1RBVFVTKGVycikgPT0gZXJyb3I7CVwNCj4gPiArCX0NCj4gDQo+IEdpdmVuOg0KPiAN
Cj4gKyNkZWZpbmUgVERYX0VSUk9SCQkJX0JJVFVMTCg2MykNCj4gKyNkZWZpbmUgVERYX1NXX0VS
Uk9SCQkJKFREWF9FUlJPUiB8IEdFTk1BU0tfVUxMKDQ3LCA0MCkpDQo+IA0KPiBJIHRoaW5rIElT
X1REWF9TV19FUlJPUigpIGNhbiBhbHNvIHVzZSB0aGUgREVGSU5FX1REWF9FUlJOT19IRUxQRVIo
KSA/DQoNCkdvb2QgcG9pbnQuDQo=

