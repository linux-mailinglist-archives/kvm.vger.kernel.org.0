Return-Path: <kvm+bounces-49069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0481AD57FB
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:06:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6CE61E17FC
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCCA628C028;
	Wed, 11 Jun 2025 14:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JjhS1OgA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2366B2882A0;
	Wed, 11 Jun 2025 14:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749650686; cv=fail; b=YgEMIRzfpM+q62yBb63utn25bLxDS3KdTcwIbcVT9x03grd5xzXf7eyAC3krH1kTf3XdAJsfLEWAmSpVnOpadJwADPWShVacXLxFBJfl7TsHxemUJjn0AqAYwS0iLz5TabBd4VveEaSLTQwBq6AUwG7Ka4E6IcD3z5M3rdj4iDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749650686; c=relaxed/simple;
	bh=0F5nF1zoEQ1JzqVaeXEAy8/sPPqyKdI32bSRjqzLdks=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=muW8HhEPH0U6T0GUXTIsHUJ+R+bcz3uzEFP8YjqGLVWykgYJfEdtsApno7UKijxss+42F2yOOD4tuKXQxXrhk3ULQJgwoKlyrQCSaGyBgRQKpz1V+Y21YQ+FZWLeXyWMH1SnEcE5tuA8QWSDO30CfGJH37UMWnf01Rbve5eFYO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JjhS1OgA; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749650686; x=1781186686;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0F5nF1zoEQ1JzqVaeXEAy8/sPPqyKdI32bSRjqzLdks=;
  b=JjhS1OgAWXPZevSWGxR+PUwSoAZFM6vioGxwl/YNSDvs3oPGZtCHXtnU
   3589xLePTRk+OkLAwmvYQsTRjqyb1T7LeIl9fZ1l2fYsVoNoXkYDv6g2L
   5Z1nbiaR9ESuoMlncvjnfeo4+aC4UcQznt4/ixL7Cdpreot2aWzjSiFpk
   29tPfxCEijngCpF1uqKDpr597VHfQlR+GmQ0oUEHTJOhMjtC2XTrUPjtL
   ABNWwxGrYc0kmOWMqwoE3qOmcpIpxTIklsJZppR6iumE1s+qUQTxAEC/d
   lSMmI9rlyy8c/GYrwJdgz7KFHcMp8e07TBEGZGtBnhUTWHvYabMbp1E4o
   g==;
X-CSE-ConnectionGUID: Lqg4cAPnRWeBZa7vPeyfRA==
X-CSE-MsgGUID: gnJ3JJYWQBawmv5JaCL7eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="62074943"
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="62074943"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:04:45 -0700
X-CSE-ConnectionGUID: bLCmyy0vSXCSolEZp7Cvig==
X-CSE-MsgGUID: QQrXmH8wTTys81gd8BTKsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="178152722"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:04:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 07:04:43 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 07:04:43 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.59) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 07:04:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=egX5f4G+ZSgz+kzo319zfqpzdDrsTMfYmKbOra4S+XNbuX8lDZ5T5y8XbuN9bLeTy8xv+yuz5lPfOmL5g/FZ7+ZB0BVPAhnJOcOIaQKE3D8SznTSHXTZQ3bKvuwIFesuzQ4lcVYelQHCUsOsz800JJFb2i3elV4Tl0y/+KM3F++HW7n9UnPlWF2OPFHbXZWrYQo+4X8WnVrMMrZomPXHRVKhscDZIhPs2GH+lg1ZFIVhtsRzksG55k3Btavq659IJoenw9NtBPRiyrOfpEu9WZdIhNqfase5biNI54Vx6k08rEXkqC7GGI/wPYv/HS8KqlrldN5Upkwv9OnSm1yfvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0F5nF1zoEQ1JzqVaeXEAy8/sPPqyKdI32bSRjqzLdks=;
 b=aYByGR5mqtM1xbHvoyWlVAuwQKIx7zJ8iJuncr4Rke1FgKjNdTBZ9uZ8fDffdvvp7KSuNnHDXyCraIPdc0e4htETRghyOFDvJXLHz9gF3LlTer0aADFO1U0u3+sirYxgKFRbqD1oKl5GdkMGpxSO8ryuO4eXUjHzyIHHfuLTxiUzIIx+D1Cq/sjUX9sYJujdtHBlZRGjkBR3RtensIZxnT22gcxEBLzr2zoeyK7Hz02gd+yt/8iHUrefBP//BvLE2HJBznpxBNRvosa32yv+AdhVHtWBrcwnhzjxWNGICfKqsPGkxvQcVfmoqbhmvq+aPYl0vLs4j5TXkpOtHHW8Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA3PR11MB8022.namprd11.prod.outlook.com (2603:10b6:806:2fe::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Wed, 11 Jun
 2025 14:04:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 14:04:40 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Lindgren, Tony"
	<tony.lindgren@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>
Subject: Re: [RFC PATCH 4/4] KVM: TDX: Check KVM exit on KVM_HC_MAP_GPA_RANGE
 when TD finalize
Thread-Topic: [RFC PATCH 4/4] KVM: TDX: Check KVM exit on KVM_HC_MAP_GPA_RANGE
 when TD finalize
Thread-Index: AQHb2a1VoiRYv/QhxESaZ6OCWq/RP7P8n1AAgAAxTgCAAFqRgIAAzQ+AgAAG9YCAAAD8gA==
Date: Wed, 11 Jun 2025 14:04:40 +0000
Message-ID: <f0d42c86e0b2fbad3fa3fdcdce214059b0581573.camel@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
	 <20250610021422.1214715-5-binbin.wu@linux.intel.com>
	 <936ccea77b474fbad1bde799ee92139356f91c5f.camel@intel.com>
	 <aEh0oGeh96n9OvCT@google.com>
	 <31c4ab96-55bf-4f80-a6fd-3478cc1d1117@linux.intel.com>
	 <aEmGTZbMpZhtlkIh@google.com>
	 <ac62541b-185a-47aa-86a7-d4425a98699d@intel.com>
In-Reply-To: <ac62541b-185a-47aa-86a7-d4425a98699d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA3PR11MB8022:EE_
x-ms-office365-filtering-correlation-id: 93f6a13d-6651-4e9a-61d3-08dda8f0e868
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZW1xWEl5YTJFc1pXUFM2MUdhU240U2o1cUgzMVZzcVF4RFVCOElUcC9nTlU3?=
 =?utf-8?B?cXpFU0UyQlZ4ZEREU1pNSS9zM25WVHlETzhaTTRJSjdHZDNlOXErdmU2dHRi?=
 =?utf-8?B?K2hFa1VxNFMvSGlvbXJDZkMxVG80NEVwRko2UWVKekdQL3pDbGtwL2Z5SkVJ?=
 =?utf-8?B?NlQ0YlpaN05WUFl2N0N1eXFCWFRNcGQ2QU9OT3FiV2Zydm5aV2RPVlVSTHdG?=
 =?utf-8?B?aHFKNHRudk1Mc0kydFFydzU1VzN5K0UwSVpmMGR6cWFEUW9VMmdBRVMzRnJM?=
 =?utf-8?B?eG5LYUg5MGpaS2svZGJMMlhXd3BINXpiSm9JS3B4aTI5YXg0N0tXRkIzaVg3?=
 =?utf-8?B?MVQ2SEYrTll5dHhBNzlQTkI3OW1uZG5uS0plM2dIRkphMnJNcDdXRmJEVCtW?=
 =?utf-8?B?OW9jYTZzKzN4c1ptNTk5YUlsZGs0ZUJwUCtERTV2YVVibnd0ZDMzMEQ1ZTRJ?=
 =?utf-8?B?NC92RXYxcXJnc1hJQndwSmdWbDh4NFI4SDBiRVZ2cmZVNDhERDhIeTArdVBQ?=
 =?utf-8?B?YVZ1a2JkZFB3NzM4cDNiaEphNlBaNjNQNlBoRVpEMEpUTCtvdk9DZlZFQ0tP?=
 =?utf-8?B?d3FueXlkUEpzM1pjMzRveXhpSGJDcWJkQUFTQmFmSEMyWFY4UUxXQUtETGFo?=
 =?utf-8?B?Mlh3QVJaOXFuajJwUzYydFZSa3JDVm8rT2tvZkZNZVRhOTJtbTc5SWNRdkpN?=
 =?utf-8?B?cHhORnR4bXFRNmo0VTFEUjFiV0tEU3JvRUpDUkR5bWhiL1JnVHgxbnE4ZUlQ?=
 =?utf-8?B?cWJjQTJLWXQ2bHpEOXF5VUY3SzB6SVZUZEt4TEhKdnFuNzB5blMrc2hNZ0VJ?=
 =?utf-8?B?aTlrVWUxVEIwZWdRbGw3OVFkSy9HcjB3VzVvcW00MmI0UkhVc2tad0k4N1hz?=
 =?utf-8?B?Y0FpcjVCZWZSV0xrRkNvSHN3ay9mM3lUYjRpOTQ4aGcyWXdrVUhrTmhQTVdB?=
 =?utf-8?B?MHdsV3BiZ1Naa1JBSUxrWXA4cFkyK2NQMlZxdFNDM2FzS0tpNnZkb003M00v?=
 =?utf-8?B?NjF2cndlQkRkRTZsYnUxRlk0bklReHFpM3VReEZwZjNRWUt5Q1E2cEtLcEli?=
 =?utf-8?B?cmw2NDl2ZlJGVXVWZVYyQnBQVG91a3hGeGF6NVh6ckVQeEpnVDJqYmZuNngr?=
 =?utf-8?B?TndOZVZ2eVBJeUxHc1FWLyttaTBjc05ncUF6djJSc3JWNGMyVnFwdmZ5Nzhr?=
 =?utf-8?B?OGg0dTN1aW9IbXVxNEJzOFBxMmZFbWVTZGtnR0ZmUWtxY2lDSThnVTVxcWp6?=
 =?utf-8?B?dkQzN2Z5Kzc2aDk2TUJYR055YTFTY01IbmtMRlRFUXNtVW4zNGQ2cERqZEpP?=
 =?utf-8?B?SWZRMmxsVi9iM0NJNkhKR3J4LzVHZmYwSUVwNFRMVGdmcGUzTk1LS1hZNHl0?=
 =?utf-8?B?dzA3dUhQN3VDWTZjc0J0YWRJcGt6bkR1MW16aG4xeEZ1WDZyNFgrdEdCV2U0?=
 =?utf-8?B?Ly9rNHNlaGNxNjhEVFY5RDNFaGJGRTF1am9KNzZPK2VZWWZNTkhaSWJxTVhj?=
 =?utf-8?B?QXdoZEpwa1ZnU2h0dEdGVlUyZUVHMmtESlNLWXVJd0lRTzhVbE5SZGlTUm5T?=
 =?utf-8?B?Nk93dVVrcmxUZG13OGZ2S2JoM0VUZVYvQW00VFhpNEk0dlRTS1RYZGFMTkxE?=
 =?utf-8?B?V1RqMER2OC9NOVZyRnBta1FNdUxveHJTcFNBY2paeUE2R1hyZGswVklkQUMz?=
 =?utf-8?B?TExEanNxTkdGSTR0RW5YeSswV2VkZzNLK21hNjRBeXF3U0oxUVlKRTZRRkNJ?=
 =?utf-8?B?aVYvNmcvL0dIZkZRZE5Tc3paUjFsTmRqTHdMUzBlY2ZZbmVVM3dXWXhFeFow?=
 =?utf-8?B?bkxQd3ZhSmNGczd2QlJnVjZqekJaSVh3b3BKbjAzTk5LOEd0MVdGaHJhelBt?=
 =?utf-8?B?WjFKeFFocXdNeXNWeUlnVmF5Tll6SnkrZFBRNFdqZm9NN3VBNG8ycDU3NVdK?=
 =?utf-8?B?U2tYVXhCOUJnWkpKMmRobjMrMStWL1R6Yndia1ptUGtWRnBhTGlLaXVRMlVJ?=
 =?utf-8?Q?AhAQ5+CnlvWihFgZgxtPpZzk0MNzvU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGtuYXdKWjR6c0U2OUQ1eEZDTXNkeEkxSXZCblBZbUpSNURYMVRMMW5LRHc0?=
 =?utf-8?B?SmxpRzIrK2R3R1YvQ2FXR0ZpZEhlZEFKWmZhL0l0eGFiOUlNRE1sSDJaZzZO?=
 =?utf-8?B?SnJ1M1lnQlVvWkhBcGtZVE43V0ZmZllCcEFTb1o4SDk1ZmdlT2x2YkRpSUlD?=
 =?utf-8?B?NzBoUTJubDVoU0x2TVRTVzkvTUV1R1JLKzBGSTZnYnJxUVFoMFBKN0hia3Bw?=
 =?utf-8?B?dys5U0lsNzZERkRzV0hWN1Q1R0lPN0lCUERIMC96NXRqWFdEb1phcE9XTUdK?=
 =?utf-8?B?V04zSmlxTDVRL2s0cTBvRFpJdCtWdUFSS0ZGSTUrUkttYlBRZ2FmV0U1Mk5o?=
 =?utf-8?B?WDFmR0FLVUpWNmxvOWR3TDJBbEtoREpBSEFSQTAyTWQ3VnRIY1Y3S29sUnM2?=
 =?utf-8?B?cElNalhjcm1ubTYrckFNVzc1OXFVT1QxS2NCL3BMczJrN0dNbWQyRWRJc1VY?=
 =?utf-8?B?Z2txeFMvYjl6ZDk1SG15bjg1SmFmTTI5T2pSTnhDN2o2VVNaSlZ0Ky81R0h5?=
 =?utf-8?B?cVgybkxtMEpkMUxibTk4akx4RmV5WlVpajcxU05wWUd5N3JFTHFFL2w3aE9u?=
 =?utf-8?B?MGVYcHIxalhTTER6ZXQvUVhBOVRxdGxoYVkzUytFTVR6NVZnZGxHdElsU2JV?=
 =?utf-8?B?bCtmTUsxT05TUzR2eiswRUYvcStPenVIT3hkZjhaWW9jSncxblFKYytEWFZs?=
 =?utf-8?B?QnBhSkFiekp6WGx3QnNNTHhOSGQyS1EvbW94eHlUVTE0VVJlS1BBL2tvd1Ra?=
 =?utf-8?B?UTk4elNvMkVHTnhFMmxRbThDb1J0aVY4MFpqYk1ic09iS0wyVEtXanIxUkc3?=
 =?utf-8?B?SG93NUV3NllmK1JrbDNyWUpSekNyaVBHL3dzZzJ3WVRDNGN5VTV6T3JWcUpC?=
 =?utf-8?B?WGQvRUdEYUVBWWR1Z3l5dEllclJRWTBaKzlmcDBzeUcxUXgxUkdrNE1KT2lr?=
 =?utf-8?B?MUp0elp6aUpWcUoxbE13QTRCRU16aWFpYjErYm5LSzc0N0VraVdPbHlVamF4?=
 =?utf-8?B?WlBCZDR1Q0k2ZVhicFBPeHZBSWljRmoxNEFQMUU4NlJrSHFnN2tPK1ZxdGpY?=
 =?utf-8?B?V3FGaVRacEovbnhqNmFhdnBveTRZZ3RWNUZ5bEZPbEVoQzBwZUxmSnJGSSt5?=
 =?utf-8?B?bHlOcHZqWWVLMXNrcHJsQU1qRGdLNEUyQ3o5TUhQWUx2VlIra3lnWklwdk00?=
 =?utf-8?B?NkZxY3d3WGIxaE5UZTdkdTIyWG1UWDREdGQ2K1kyQ05kQjZTVzFpaFIrZGdU?=
 =?utf-8?B?a2dMcU00T1IzUzVSRnhpVlRINFdiOGJXM3M4YVVGM2gvd21RdDlKZXlTbFEw?=
 =?utf-8?B?UHJUcXdzUnBZQnU4UGtubG1Zbk1yTURIQlFCamZWL0dsRmhKY0NNejdNTXBT?=
 =?utf-8?B?WFZFYWtaWFZqT2dKQUUzdDdKcHpjVWZnQWNld2NxOHlTWnpIRjMrUEdlc1pE?=
 =?utf-8?B?TlNPV2taaEZ1OWk0VHFVNGlybUR1d0FQMnhuVFpPMHpIRmdhOWlIcExyMm9M?=
 =?utf-8?B?aFdMN0VsTXB1UnliK1kyTkg2VC83dmovM3JUYXo1OHFxKzBkUkIyc25WbDh3?=
 =?utf-8?B?Q0JTQzdMUEJkMDZYQWZWbGo0NWtGRmJSa0g1UW1VdjJUd2p0b29KYlFMSlRG?=
 =?utf-8?B?aktIc2N3akwzdGM0R0ViR0Z5Y1VkSzVSY1ZzTkF0WklmNXJwV3MyMEx3ajFT?=
 =?utf-8?B?eTBQbi8zUXhXdnhaR0p4T295eGNDQ1RFcVdBY05mSmczUVBBY0lXZVQzZUhI?=
 =?utf-8?B?OWE3b0VvSXVLUGdqZGo0RHFQbGl1TnptdjU1M1k4TjZpeVdhQUhZTU5QM2py?=
 =?utf-8?B?MUN6QkFVTm56NGlvdXNYZE8xYUgwenNGRCtyYW5CbmszNytVWTNxMDhQRHdT?=
 =?utf-8?B?V2hvcFoycWlBcXh5REw3dndwMG9DZWpnMjQrQzZrbE5jZHZsSUhydm12ZnZq?=
 =?utf-8?B?bytkSiswaHRSdlZSdWVkYWpzUlhmaEJ2OWV3V0s0NnFrMi9pL05mZ284MnpQ?=
 =?utf-8?B?T2g1UUlrVzk5VDdxV2tlWlNvbmx5Y2N0dHNlUmdLWkdRbWdKT0NIZ0pKdTk2?=
 =?utf-8?B?NzQyazlNdXlqMTRBRTJFUlFOSWUxV3M2V2ZDYmVHdVVvY2d3UTFnRG5vcVlN?=
 =?utf-8?B?VVNEck93bEc0NkpnSm9GL2NUOUxHMHVRZXk3K0NtQis2WUZMTWlWMTZKdHdN?=
 =?utf-8?B?eXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED504A7642F8CD4B8E812E4DCDD2CA78@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93f6a13d-6651-4e9a-61d3-08dda8f0e868
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2025 14:04:40.1014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sFbextcUjDBrn3fSFgZ5kEzs84RFVIJ8vDMesAlPI0rBeKzk9/okYYoILX3q0GlRBUTR2lqFfWPFbkC4jV/eGzcFOousgcQknKUVx5L0pwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8022
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDIyOjAxICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
ID4gU28sIHdoZW4gdGhlIFREWCBndWVzdCBjYWxscyBNYXBHUEEgYW5kIEtWTSBmaW5kcyB1c2Vy
c3BhY2UgZG9lc24ndCBvcHQtaW4NCj4gPiA+IEtWTV9IQ19NQVBfR1BBX1JBTkdFLCBqdXN0IHJl
dHVybiBlcnJvciB0byB1c2Vyc3BhY2U/DQo+ID4gDQo+ID4gV2h5IGNhbid0IEtWTSBqdXN0IGRv
IHdoYXQgaXQgYWxyZWFkeSBkb2VzLCBhbmQgcmV0dXJuIGFuIGVycm9yIHRvIHRoZQ0KPiA+IGd1
ZXN0Pw0KPiANCj4gQmVjYXVzZSBHSENJIHJlcXVpcmVzIGl0IG11c3QgYmUgc3VwcG9ydGVkLiBO
byBtYXR0ZXIgd2l0aCB0aGUgb2xkIEdIQ0kgDQo+IHRoYXQgb25seSBhbGxvd3MgPEdldFRkVm1D
YWxsSW5mbz4gdG8gc3VjY2VlZCBhbmQgdGhlIHN1Y2Nlc3Mgb2YgDQo+IDxHZXRUZFZtQ2FsbElu
Zm8+IG1lYW5zIGFsbCB0aGUgVERWTUNBTEwgbGVhZnMgYXJlIHN1cHBvcnQsIG9yIHRoZSANCj4g
cHJvcG9zZWQgdXBkYXRlZCBHSENJIHRoYXQgZGVmaW5lcyA8TWFwR3BhPiBhcyBvbmUgb2YgdGhl
IGJhc2UgQVBJL2xlYWYsIA0KPiBhbmQgdGhlIGJhc2UgQVBJIG11c3QgYmUgc3VwcG9ydGVkIGJ5
IFZNTS4NCj4gDQo+IEJpbmJpbiB3YW50cyB0byBob25vciBpdC4NCg0KQnV0IEtWTSBkb2Vzbid0
IG5lZWQgdG8gc3VwcG9ydCBhbGwgd2F5cyB0aGF0IHVzZXJzcGFjZSBjb3VsZCBtZWV0IHRoZSBH
SENJDQpzcGVjLiBJZiB1c2Vyc3BhY2Ugb3B0cy1pbiB0byB0aGUgZXhpdCwgdGhleSB3aWxsIG1l
ZXQgdGhlIHNwZWMuIElmIHRoZXkNCmNvbmZpZ3VyZSBLVk0gZGlmZmVyZW50bHkgdGhlbiB0aGV5
IHdvbnQsIGJ1dCB0aGlzIGlzIHRoZWlyIGRlY2lzaW9uLg0K

