Return-Path: <kvm+bounces-60575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AE9DBF3F8A
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 00:56:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B967B3AFAC0
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 22:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 040AA334C12;
	Mon, 20 Oct 2025 22:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vkc2AH8E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9EB74C14;
	Mon, 20 Oct 2025 22:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761000953; cv=fail; b=T3GA+ujj7JR2+t1BtZYdE9kghwdD26dbEpMPbXua2/4jl1XqQphBDi4xHxY5x5yT6w/fJZLFtodJZN6kA0lmtJ8Uk+EmOh/DvZt7zwvBpiVO7M1cWbe/kZUH8kl1twvFeh6WfgWHG9uLsvLqeNQExkVk6lKY2tct3GT78DGFzGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761000953; c=relaxed/simple;
	bh=ZZuk+d7FtLfE+M0SkKb3WRdounupoTe+C/isQnWPQ90=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V3VySMHYbU6Rhpfbip8JCV8liZcTVvAICIhuge/n5pom272PwikuaZK7cSwaHzgBcTWky3zh5mtyjAb88NqfLuFApcYfwI4YcA7EVmRl8UG+r+4NRBKyJxqC56CiQwzRPc3u6HkoS4lp8Vn0urvKHWaDaIfHryq3jG+EeTvMAE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vkc2AH8E; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761000952; x=1792536952;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZZuk+d7FtLfE+M0SkKb3WRdounupoTe+C/isQnWPQ90=;
  b=Vkc2AH8Eynfn7RYmPaKQeLSa1gQPcNIqVjFO8hzVtDBeaN6rU48IxRrz
   WPMMekhKY5MBZbOtWAoSHmr5Q8Vkl20qvc1uIlhgWWRXajYEtCLMKxI0K
   +fq8BxgeQW193CM6Z2zTJks3T3FRcW4AnfdSy65OiNnMZZ34C+/AvffZ6
   P9UlHf8Mq3AaW9uZGS+hiNbo0VeRfuzi+4F3K4t68g0hCyKvQFbwmkwN+
   KYoKxRFt1dQ0a7s9OMxFepVXMwAN0Tggyaw/VGQGHVTxMkqpCHdjiCnqa
   a2ScWVO7xhSxG3QgsdUNeJQrwQcd4zO0VJ4JCnhJYfhDFzxUNc95P+miN
   w==;
X-CSE-ConnectionGUID: PbdHnMDXRzuJdGQT46JpuA==
X-CSE-MsgGUID: NDLpM1F7RumEm1H/SLmBhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63164190"
X-IronPort-AV: E=Sophos;i="6.19,243,1754982000"; 
   d="scan'208";a="63164190"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 15:55:51 -0700
X-CSE-ConnectionGUID: m3vrmvP/RYuOBUZ84zLXHA==
X-CSE-MsgGUID: ccaXiiHxQJyWHseMNVvwpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,243,1754982000"; 
   d="scan'208";a="187465345"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 15:55:51 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 20 Oct 2025 15:55:49 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 20 Oct 2025 15:55:49 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.5) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 20 Oct 2025 15:55:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h82BBtwNczXmkEg3WTpcQ2UjSsFTRX4KUwBDd9ijuG8AxnDPlbsGTqaROpk4CHAEVMdIL2QJM9hmX53n3MOvzvgmetNRLNxzTKYLA19zrmt6HAIQ0S7HRQ/SH9Z0jKA508ZlEaksyFC62Iy7zNpQ0TjLlWucemFslmjzomf/wLLSJQmgu2v2KpyjNUen9TXha6wPOZc5U4W6n5J3X9xlY9TteHUs7plTslhcMy5QD6h4s5NR5vNBQ2OSDoMGjAPaNfOYqyAPqsEJuhYVtQULNpJlC2Y12jdbDVb2xSeacrMpAX2905zcB1OGIUP+IbQO/zHz/H6R2RDJbaUWBbFrUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZZuk+d7FtLfE+M0SkKb3WRdounupoTe+C/isQnWPQ90=;
 b=W9OeouFw3RQFRT2O/VZmRe7ub5Qwd5XvB+yiqKiDLWadrYJTRzXQ/eOmklGrGc+wPi37dPNpWoD51oMgX+h6oekNB79P6tBtJvGqaOzj/K35V/OajzxYxph0UzN1lF0qUrJ2HXmNJquNRvE5CBOgiIc1eRAOwD5AtN4FWsrmW3fbWauog3C1XKFml66fJ+1PVsw1qVKbbsWCsnhf+3/7D5GlIhH1jLDsnX/ppbLrAglL9F6B1v6twDyQ34GRICpXAfxqb6k1VbVUmgdgvKu71vUqINTKfTyZTsCI0vJPRCs2yoXfzLISAHNiiQYguqSVuDPrERVx7JvOAuXxNQ1wvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BN9PR11MB5290.namprd11.prod.outlook.com (2603:10b6:408:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Mon, 20 Oct
 2025 22:55:47 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 22:55:47 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hou, wenlong"
	<houwenlong.hwl@antgroup.com>
Subject: Re: [PATCH v4 1/4] KVM: TDX: Synchronize user-return MSRs immediately
 after VP.ENTER
Thread-Topic: [PATCH v4 1/4] KVM: TDX: Synchronize user-return MSRs
 immediately after VP.ENTER
Thread-Index: AQHcPuw06cyBS3K2dkWWncH6yXNOTLTLq32A
Date: Mon, 20 Oct 2025 22:55:46 +0000
Message-ID: <e16f198e6af0b03fb0f9cfcc5fd4e7a9047aeee1.camel@intel.com>
References: <20251016222816.141523-1-seanjc@google.com>
	 <20251016222816.141523-2-seanjc@google.com>
In-Reply-To: <20251016222816.141523-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BN9PR11MB5290:EE_
x-ms-office365-filtering-correlation-id: 5dd492bd-ff76-4111-8f7d-08de102bcea0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Q1UwaS9vcUFRZFZYc3MxWTdycUlGY2ZjNGxiaGdjNHp2YkMvQTl1MzYrYXZv?=
 =?utf-8?B?aktoMjZwb1k2RkdvU3BITWRDQUk2YUErcVhNM2F0UTRoYkVRLzdBbGcxTkVi?=
 =?utf-8?B?L0xCRW1LTndQUDBSRUdJY3UxQ1JWd0I1ZEFYRndYZittOEJBY1lvSk4xb3lO?=
 =?utf-8?B?MmZmcmRCK3c1RVJTdkljNTNGOXFOTktscWNiY056TXpGUGdPcUlYdzc4T3hY?=
 =?utf-8?B?KzJJcFhQRi9HMWZIYk1IZ3RWWjdMSWM5SENsSituS3hBeVU4UnNCUTVrUXlv?=
 =?utf-8?B?MDVQVHNPNUR0czlaeDJXZTkvdUFnVVhWTVdVRFZpcVpuQkpaeDBONnQzbUpw?=
 =?utf-8?B?WmdRd2pRU29wL3R2ejRGb0N3WVdYbTkrTlYzeWsyNXlMMGZJcEFyWGpkL3FE?=
 =?utf-8?B?R2lEMWxIRkZLcVJpU0FyKzlET0NvNmlNYXpPajNCN2FPNk8xMnh3a0Mzb2lF?=
 =?utf-8?B?RitwWkVvWFh2em5YSUNic25NQXpDUHg2TjZYNWhqQ2pDNEpXbm1wREVOYnFX?=
 =?utf-8?B?WWpCREViS0xkNmMwbERmS3ZnL0ZDNm5RRnkzNjFkSHoyVXY4VSsrOHhNU1du?=
 =?utf-8?B?OGlUTlFON2szN01KanZ4Y3VHMmtKbUNPOEtuU040ZUk5KzVQMzA0dGpzOXZr?=
 =?utf-8?B?VDVqeWNBeERjU1NERW93ZVBRbmRKbmFLMUdZVENzZnR5Yi9OQUVoYklpZVMz?=
 =?utf-8?B?Kzg4UjUxRU1tNWpNbXhkUjdydzBRNUk0Qjc0bE1hL1FKUTJSQmdJNStIZTZZ?=
 =?utf-8?B?eWNwR1o0MGRTMGZ6M1VXYzlneFJoS0xTWWF0eDRCL1JqNCtzd0RtWk9hUmxI?=
 =?utf-8?B?T0NHMGZHQkYyK2d6MWVLNndGN0QyWk5WY3A3eVdIbUpnV2VsSXFWTnhMVm5t?=
 =?utf-8?B?K3VlbzY4ZXhTSlg4bTAydlNiTHFyMVNwQjFtYXFNVmxyR3hJekxZVzBGM2lk?=
 =?utf-8?B?L0FLaUhFVE9UMktHYzI0cEdMeVlQZG9EMHEwWWRFQjlCNHlWaytLZWt0OWpX?=
 =?utf-8?B?a3VBQTNxaUNCa2IvU3daTEVWcjRoUHdhQkRaY3htM1M0bWFTUDhtZk1uTSt0?=
 =?utf-8?B?bHNoM3lYY2xsaFlsaUN6T3MxV2ZwWDFuS0U3aDRKbXptSUFLaUcyZDY0SW9X?=
 =?utf-8?B?bUhteHdpY0J0L2pZMTVGRzhSY1l5dWg4RWlYaHFsNmpDQXJEeENuWWVCR1ZX?=
 =?utf-8?B?R05WNHM1aU1SNkxyTFZJdlYyTUgvTlBlWHFkcW9BV0tmWkZZWVA5WmdYUTZz?=
 =?utf-8?B?L0FqYlozTjk5cCtSM1BEZG5DbnByakhaYVc3bXh6VkQvWHkxNkdmdFRuVVFL?=
 =?utf-8?B?aEUzc29kVXVvVUZNblZKWXNvK2ZvWmdmQmQ3L2NtYW1ieURJbHNXSVRIa0p4?=
 =?utf-8?B?N0ZxU0xYdGVaTGErUDc4cE1MRkR1MjdsVGR6SXJJNVRsZVY5N1A1VGgzYUF0?=
 =?utf-8?B?akVKVzhucU5jUHh0dHErNXE2TGhXYk1OTjRtQkdJajZ5aEJMdlBsbStYMFJO?=
 =?utf-8?B?ZkoxTEJhQ1Y5RkJ3ZEl4UlE3MjFldXVnMTgvSU5tV2Jsa0I4N0VwdUl4VE5P?=
 =?utf-8?B?akZOVmZpY1MrUEFHbVBOc3N3bTgwMmpvV3MvdHhrWVpqT2ZTUW4wZm1DOWpq?=
 =?utf-8?B?azVrSys1RTVQTkpTaDA0c2VVZ3U3Mm9zTkhGWWJnTEx5aHVlWTZTcFRsUkdM?=
 =?utf-8?B?dlMvdDBva2g4aEpDS0lINFhTS3d3QzlIVDA1c2JIblJvakdXTVBxZTY5WVJi?=
 =?utf-8?B?ZEgrUHErZWF5RThVcUh2bEZCcEt3V2VwamU1WWlwTi9zTi9jWTlidE1oMXpy?=
 =?utf-8?B?VXNkcjBhWExSOWtBNXdrTCtyQ0orZVFwVytCcFNpUXpYcWNEclloTEthU20y?=
 =?utf-8?B?Mkp0cGQ0dkV3c0RaYWMvb1QzRXdwaGYxTXdGMjVCU21hZzFKRG41cDlkZUJt?=
 =?utf-8?B?b29uOTdxRGZERlFnK3ZFeE53dThZcTVxUlI1Ujh4QkVJclpnMnZwZXNON3Uz?=
 =?utf-8?B?Szh6azRvWUpxbXdYRUt1dC9vZllqd2xEQnB2RDlQWCtvZXg1YjE4MGJpZkdQ?=
 =?utf-8?Q?8iPX6U?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWtQR2pVQnpTcExUa2xNcFJkaGpOeVJvUTBTc2taZjk5cUlUUHd1Vm9hMis5?=
 =?utf-8?B?Qy8wSTQrN3o5RzB0K0JPaFVmcFlmVTkyVzNaRDFtc2dHVnB6VVVQa1l4OUZa?=
 =?utf-8?B?cGZCa1RhQnhwbktmSVljTWdvSndUSENzdGhZQXFjdUxianhweERzNXdpR0RN?=
 =?utf-8?B?aExsVDh5T3hGNWRnWXhNeFlzU3E0cHRGVEMyL2xwMjhqMTVwMUE5U1ZYeDMr?=
 =?utf-8?B?MHF2QnFyTE5VVTZSTDV6Z2ZJZFBtOFRyTDliWDl6cFh3aHJscWNoZTZ2ejBz?=
 =?utf-8?B?VEdxbk5nUmNTSUZOVTlQSWNnbzFwV2hOSEFvTmNjenE3V29rOFZvT09NZWVZ?=
 =?utf-8?B?YUhTc1R0RkRhMThvbGJoSWJEUHFrbnRSbzl6bGpjNTFGZ3F6ZjJxby9FOTZk?=
 =?utf-8?B?ekFmLzFUTGNpd0hrTGxIcVlvckJKaFpES3JlRndtSkZEQWxMK25QckNkN000?=
 =?utf-8?B?dDhkRE5lNno1dkQ3LzRlSndBNTYxL0hDbitKWUFJZmc1c1hnMldqRnFuNXcv?=
 =?utf-8?B?K3huaFczYWRPemRBeS9vU1l5djdyQmlBTmVQcVpyWDFPYmR5Wi8wNGUrQXly?=
 =?utf-8?B?VTNwYnRBUEcwajJVUmwxUnEyam9GaS9pOGoxZ2VPL0VtVVZwSjBLRHJ4ekVW?=
 =?utf-8?B?a2wxMy9Fd3YydlZ3cjh0cUp2ME1rYlI5ZEttVmNNVDlkdkFzdkRCY1hzbGo3?=
 =?utf-8?B?L0c0cGVlZVJLQXR3Z3pmSlY0dEVXSlRLK01LNXBwcWRiTVNTUEFHeStRY282?=
 =?utf-8?B?QUk4cmRQN1pUbGYrTzdQaUtOdXl1YzJ2M1hLcjJtVXFCV2cvUTNEbTZ2WXBr?=
 =?utf-8?B?ai9ZaklmWW5VOGY1bFJUS3dvWUM4T3NGS3RGYlFKWUZzRVFubHhZQnFDWmFw?=
 =?utf-8?B?bXJTV2k5VE5GaDdxN2RSNklLa2xybThFL2VjaXNuVlBIb3Y5Sm9tQUZOOFVw?=
 =?utf-8?B?NEk5d1N3SDZ3RU4yTVhjcVVrQW5IZ1JScVFtaU1XUFAzaWY4VWRpT3pDakFr?=
 =?utf-8?B?VG5tRWxzR21LSTQzZmRCTGZSeE1DSEZ2TlkvQnE1Y29rNFVKQ0Y2UUtTV0h6?=
 =?utf-8?B?TWd6bitTTEFjaUJRY1AvTzdoR1I2MWJwZDlWN05MaTRhYS9DNjJHSVVVQU9W?=
 =?utf-8?B?QUZJZUZNb0wyd1V5ZWdoSms4SEZBQy9kNmVxclRKVjVCUm1CV2Jxd0I4Tldz?=
 =?utf-8?B?cDA0RGhyd2dGTGNFOWhpYVdZeGp1MGxTbUx6cE9FNTVoSjgyazBUbHNvQlRU?=
 =?utf-8?B?aXRrZnlJaVhEWFZ6dklWSGx0VzhHTmY0QU1MQVVNYlYzUUZGVElTYy9pOG96?=
 =?utf-8?B?Qk13S2h1Z1h3a2sxNmJvUTI2WENoMmlGWlB4ZTdXWDJFdHBYVFJaUDhWNHpY?=
 =?utf-8?B?WmR0UmwreG8zc0VERGliNjR3bHRGczJuRjhweEZIS1Q4MkIxSndPYk5KMEdj?=
 =?utf-8?B?czluY25ka3hLdDcwN1dXdUZKZFRvVVgwaDc1YitxK3lHMm05dGY1Yy81cjRl?=
 =?utf-8?B?c01RNXBCU0ZRVENBQVFaWUIwejJuMGtraDE0T0FQMkVXM2REY1VMMVZ0VVdh?=
 =?utf-8?B?SzhNZWV5aUViNkorU3ZPUlVMUFFwcEFWNDZaMW9yWVk1T1o1SnI5MEU0NVlU?=
 =?utf-8?B?OUFTNTM1bkR0NVpmTTMvQURWV1QvZXZtRVgvT0JoeDd1Q3lPQVpqbm8rZlVa?=
 =?utf-8?B?V1MxN3FUSlpVMndOZU1wNWdhbUNvSWZXVjI4U3pIK0N1L2VWb3Zsd1UwLzZT?=
 =?utf-8?B?QlhBY01RYThmNU8xWHlUYU1Mcmo3cXA3S0owS2NwSitjc3FxcUVmV1k3N256?=
 =?utf-8?B?OUU5TzBKUGRHTm1JejBoLy90R0VSUXdIQW5ZQUdqYndGRmpkTnV3MDdoS1VR?=
 =?utf-8?B?U3dpR2lHcHdLY1h5UlN0SXFpUHBvSEtseWE4VUtrR3RXKzkwTzVCM0k0UThP?=
 =?utf-8?B?SFNwblRhUWh3UzFMQUl0dW5hY0NvckwwVE9EN1lSQmRPY1MzanRlYzlHeklV?=
 =?utf-8?B?UUpkTEZIdjhkRkxjR3NhMHcvRE1iOGM3WUhCZnZlSU1hRXgxdlQzVjBSNDkr?=
 =?utf-8?B?MnJ4NUovbTZ5TmJyT1poYnN2U2hzY0VHZVc1NFg4UjFhMlI4cUxBd3RUT0dT?=
 =?utf-8?B?NDJaUENiMk9sN2ZtaTlKSXJ3TEcra09DdTlBenBLWEhzSU5KeWluRHpmTW9G?=
 =?utf-8?B?Wmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25370D16C0BC03498CEDEB989F33CADE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd492bd-ff76-4111-8f7d-08de102bcea0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2025 22:55:46.8840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zbPmXrbwoQDsdCOevK8Q2w4rkZb4ovCzY5dwfsj/MjhC6IwpVLsB4HBuBtJtkilX4d+NIK2wLHc1WkO0oJTq7OPwOCEpVypb5x3jEsepUDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5290
X-OriginatorOrg: intel.com

K0FkcmlhbiBmb3IgVERYIGFyY2ggTVNSIGNsb2JiZXJpbmcgZGV0YWlscw0KDQpPbiBUaHUsIDIw
MjUtMTAtMTYgYXQgMTU6MjggLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+IGRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jIGIvYXJjaC94ODYva3ZtL3ZteC90ZHgu
Yw0KPiBpbmRleCAzMjZkYjliOWM1NjcuLjJmM2RmZTk4MDRiNSAxMDA2NDQNCj4gLS0tIGEvYXJj
aC94ODYva3ZtL3ZteC90ZHguYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+IEBA
IC03ODAsNiArNzgwLDE0IEBAIHZvaWQgdGR4X3ByZXBhcmVfc3dpdGNoX3RvX2d1ZXN0KHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSkNCj4gIAkJdnQtPm1zcl9ob3N0X2tlcm5lbF9nc19iYXNlID0gcmVh
ZF9tc3IoTVNSX0tFUk5FTF9HU19CQVNFKTsNCj4gIA0KPiAgCXZ0LT5ndWVzdF9zdGF0ZV9sb2Fk
ZWQgPSB0cnVlOw0KPiArDQo+ICsJLyoNCj4gKwkgKiBTZXZlcmFsIG9mIEtWTSdzIHVzZXItcmV0
dXJuIE1TUnMgYXJlIGNsb2JiZXJlZCBieSB0aGUgVERYLU1vZHVsZSBpZg0KPiArCSAqIFZQLkVO
VEVSIHN1Y2NlZWRzLCBpLmUuIG9uIFRELUV4aXQuICBNYXJrIHRob3NlIE1TUnMgYXMgbmVlZGlu
ZyBhbg0KPiArCSAqIHVwZGF0ZSB0byBzeW5jaHJvbml6ZSB0aGUgImN1cnJlbnQiIHZhbHVlIGlu
IEtWTSdzIGNhY2hlIHdpdGggdGhlDQo+ICsJICogdmFsdWUgaW4gaGFyZHdhcmUgKGxvYWRlZCBi
eSB0aGUgVERYLU1vZHVsZSkuDQo+ICsJICovDQoNCkkgdGhpbmsgd2Ugc2hvdWxkIGJlIHN5bmNo
cm9uaXppbmcgb25seSBhZnRlciBhIHN1Y2Nlc3NmdWwgVlAuRU5URVIgd2l0aCBhIHJlYWwNClRE
IGV4aXQsIGJ1dCB0b2RheSBpbnN0ZWFkIHdlIHN5bmNocm9uaXplIGFmdGVyIGFueSBhdHRlbXB0
IHRvIFZQLkVOVEVSLiBPciBtb3JlDQphY2N1cmF0ZWx5LCB3ZSBwbGFuIHRvIHN5bmNocm9uaXpl
IHdoZW4gcmV0dXJuaW5nIHRvIHVzZXJzcGFjZSBpbiB0aGF0IGNhc2UuDQoNCkl0IGxvb2tzIHRv
IG1lIHRoYXQgaWYgd2UgZ2V0IHNvbWUgVlAuRU5URVIgZXJyb3JzLCB0aGUgcmVnaXN0ZXJzIHNo
b3VsZCBub3QgZ2V0DQpjbG9iYmVyZWQgKGFsdGhvdWdoIEknZCBsb3ZlIGEgc2Vjb25kIGFzc2Vz
c21lbnQgb24gdGhpcyBmcm9tIG90aGVyIFREWCBkZXZzKS4NClRoZW4gd2UgYWN0dWFsbHkgZGVz
eW5jIHRoZSByZWdpc3RlcnMgd2l0aCB0ZHhfdXNlcl9yZXR1cm5fbXNyX3VwZGF0ZV9jYWNoZSgp
Lg0KDQpJIG1lbnRpb24gYmVjYXVzZSBJIHRoaW5rIHRoaXMgY2hhbmdlIHdpZGVucyB0aGUgaXNz
dWUuIEZvciB0aGUNClREWF9PUEVSQU5EX0JVU1ksIGV0YyBjYXNlcyB0aGUgaXNzdWUgaXMgbW9z
dGx5IGFjY2lkZW50YWxseSBhdm9pZGVkLCBieSByZS0NCmVudGVyaW5nIHRoZSBURCBiZWZvcmUg
cmV0dXJuaW5nIHRvIHVzZXJzcGFjZSBhbmQgZG9pbmcgdGhlIHN5bmMuDQoNCj4gKwl0b190ZHgo
dmNwdSktPm5lZWRfdXNlcl9yZXR1cm5fbXNyX3N5bmMgPSB0cnVlOw0KPiAgfQ0KPiAgDQo+ICBz
dHJ1Y3QgdGR4X3VyZXRfbXNyIHsNCj4gQEAgLTgwNyw3ICs4MTUsNiBAQCBzdGF0aWMgdm9pZCB0
ZHhfdXNlcl9yZXR1cm5fbXNyX3VwZGF0ZV9jYWNoZSh2b2lkKQ0KPiAgc3RhdGljIHZvaWQgdGR4
X3ByZXBhcmVfc3dpdGNoX3RvX2hvc3Qoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiAgew0KPiAg
CXN0cnVjdCB2Y3B1X3Z0ICp2dCA9IHRvX3Z0KHZjcHUpOw0KPiAtCXN0cnVjdCB2Y3B1X3RkeCAq
dGR4ID0gdG9fdGR4KHZjcHUpOw0KPiAgDQo+ICAJaWYgKCF2dC0+Z3Vlc3Rfc3RhdGVfbG9hZGVk
KQ0KPiAgCQlyZXR1cm47DQo+IEBAIC04MTUsMTEgKzgyMiw2IEBAIHN0YXRpYyB2b2lkIHRkeF9w
cmVwYXJlX3N3aXRjaF90b19ob3N0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gIAkrK3ZjcHUt
PnN0YXQuaG9zdF9zdGF0ZV9yZWxvYWQ7DQo+ICAJd3Jtc3JsKE1TUl9LRVJORUxfR1NfQkFTRSwg
dnQtPm1zcl9ob3N0X2tlcm5lbF9nc19iYXNlKTsNCj4gIA0KPiAtCWlmICh0ZHgtPmd1ZXN0X2Vu
dGVyZWQpIHsNCj4gLQkJdGR4X3VzZXJfcmV0dXJuX21zcl91cGRhdGVfY2FjaGUoKTsNCj4gLQkJ
dGR4LT5ndWVzdF9lbnRlcmVkID0gZmFsc2U7DQo+IC0JfQ0KPiAtDQo+ICAJdnQtPmd1ZXN0X3N0
YXRlX2xvYWRlZCA9IGZhbHNlOw0KPiAgfQ0KPiAgDQo+IEBAIC0xMDU5LDcgKzEwNjEsMTEgQEAg
ZmFzdHBhdGhfdCB0ZHhfdmNwdV9ydW4oc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQgcnVuX2Zs
YWdzKQ0KPiAgCQl1cGRhdGVfZGVidWdjdGxtc3IodmNwdS0+YXJjaC5ob3N0X2RlYnVnY3RsKTsN
Cj4gIA0KPiAgCXRkeF9sb2FkX2hvc3RfeHNhdmVfc3RhdGUodmNwdSk7DQo+IC0JdGR4LT5ndWVz
dF9lbnRlcmVkID0gdHJ1ZTsNCj4gKw0KPiArCWlmICh0ZHgtPm5lZWRfdXNlcl9yZXR1cm5fbXNy
X3N5bmMpIHsNCg0KTm90IHN1cmUgd2hhdCB0aGUgcHVycG9zZSBvZiBuZWVkX3VzZXJfcmV0dXJu
X21zcl9zeW5jIGlzIG5vdyB0aGF0IHRoaXMgaXMgbW92ZWQNCmhlcmUuIEJlZm9yZSBJIGd1ZXNz
IGd1ZXN0X2VudGVyZWQgd2FzIHRyeWluZyB0byBkZXRlcm1pbmUgaWYgVlAuRU5URVIgZ290DQpj
YWxsZWQsIGJ1dCBub3cgd2Uga25vdyB0aGF0IGlzIHRoZSBjYXNlLiBTbyB3aGF0IGNvbmRpdGlv
biBpcyBpdCBhdm9pZGluZz8NCg0KQnV0IG90aGVyd2lzZSwgYXMgYWJvdmUsIHdlIG1pZ2h0IHdh
bnQgdG8gZG8gaXQgZGVwZW5kaW5nIG9uIHRoZSBWUC5FTlRFUiBlcnJvcg0KY29kZS4gTWF5YmU6
DQppZiAoISh2cF9lbnRlcl9yZXQgJiBURFhfRVJST1IpKT8NCg0KPiArCQl0ZHhfdXNlcl9yZXR1
cm5fbXNyX3VwZGF0ZV9jYWNoZSgpOw0KPiArCQl0ZHgtPm5lZWRfdXNlcl9yZXR1cm5fbXNyX3N5
bmMgPSBmYWxzZTsNCj4gKwl9DQo+ICANCj4gIAl2Y3B1LT5hcmNoLnJlZ3NfYXZhaWwgJj0gVERY
X1JFR1NfQVZBSUxfU0VUOw0KPiAgDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3Rk
eC5oIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguaA0KPiBpbmRleCBjYTM5YTkzOTFkYjEuLjk0MzRh
NjM3MWQ2NyAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC90ZHguaA0KPiArKysgYi9h
cmNoL3g4Ni9rdm0vdm14L3RkeC5oDQo+IEBAIC02Nyw3ICs2Nyw3IEBAIHN0cnVjdCB2Y3B1X3Rk
eCB7DQo+ICAJdTY0IHZwX2VudGVyX3JldDsNCj4gIA0KPiAgCWVudW0gdmNwdV90ZHhfc3RhdGUg
c3RhdGU7DQo+IC0JYm9vbCBndWVzdF9lbnRlcmVkOw0KPiArCWJvb2wgbmVlZF91c2VyX3JldHVy
bl9tc3Jfc3luYzsNCj4gIA0KPiAgCXU2NCBtYXBfZ3BhX25leHQ7DQo+ICAJdTY0IG1hcF9ncGFf
ZW5kOw0KDQo=

