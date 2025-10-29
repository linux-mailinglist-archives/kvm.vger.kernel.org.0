Return-Path: <kvm+bounces-61420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DFD61C1D519
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 21:56:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E714189A1B9
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 20:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11478314D2F;
	Wed, 29 Oct 2025 20:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DQD7GJFa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B8C30DEA0;
	Wed, 29 Oct 2025 20:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761771241; cv=fail; b=J8mDmal1SJRquzISLU52o/O2ZSQqXB1+d8g881ocpYY3nh4wUJ2tcONZsxymVXr0BYfxKZxrIrpR693c9fdAz/vc3WVnhLfdcxYWKIO6YqHmLp9GvcrFFITk0WcxslSgt/bU6Qq5jtI6CMf+QlhtzY58SKarIDuvdXdeX4e5yiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761771241; c=relaxed/simple;
	bh=wgkpduxRsjD+OSH8gukPD/adKICeCzc05HCfecu8XJE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JEsdO7rL+VWoQCW/bbflPsvx95ryH6/tC2/HQFqXHLasBBlq/tyDiRxTGjKtNc60GEYM9mq2wJfHw3tH0eDCqeFS2jusl2jKbAiUvnFlfdnqEg8avB4C1+NjyG4DSTPMyVSMq1RpYsW4QMOCM75jj5PovqPTP95KCXAObAtEw6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DQD7GJFa; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761771240; x=1793307240;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wgkpduxRsjD+OSH8gukPD/adKICeCzc05HCfecu8XJE=;
  b=DQD7GJFacWmp3YCBKv2DAiKYuUEqwcKrXoJquwg8Wp36rJHhOzqwU+p0
   +WSePoVs81yKuIsYo3TrbMJRCd0Yeazr+V4KTYwufbsdeLm46qzE++vqC
   GQ3GRb4uTYL0JUMoKzY5Pt9frvR0lJhaoHp4pWwBwXrz+EIAHVvRq2BgB
   6Qm5ED5+yIV3Z1Q8XbGS+fc579LYum0U3AiTo3gYu29VSRcZ7B/DYJcYN
   YGSlTdvIGXRw6bICBReKT/WLs5zCtu1qH5rHpacgqxkYbOe0tXNUxEbT9
   EgxuNXMqkx0zIS63te2L5IImR5wEz9dDX6O+1sXSVwOgGgJB3Jn8UoNvY
   g==;
X-CSE-ConnectionGUID: jjeRB8x+RZK5OKUX7rSTbA==
X-CSE-MsgGUID: d65ZhcdHQemKrByL5blj1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="81534017"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="81534017"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 13:54:00 -0700
X-CSE-ConnectionGUID: cUMA2w7YSM2wHyQaOdBBWw==
X-CSE-MsgGUID: BexrX2bdTOuPd/ouad6CoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="186219239"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 13:53:59 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 13:53:59 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 29 Oct 2025 13:53:59 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.10) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 13:53:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XWsR+sAxbqd+T/WwksbYTPeQMdRl8y3KD1cptCgEyOo5WZsedMueg2uP8yson1UN7ynSbfKqDKBaDNb2g9IV5UXNm929krnzgYH5+yTiqaX+mzZmt6XuNJ650b5L8/HmOTxPxBEpMezMkJh4VePHnkyRLUFNtpWOXN7fBQEdDnj42GPKoL88BC/hxxOX53ItXD5hSJsaU0kOUmoxSZRexA9vqO7nrSLMens/9pBxG3JMCTtJQXfIv0ixNJmT6hXkuX7u4ddn8G46eKtKdn/46YJ4DXwyT5xcXy7kUtzSHu+ze5fzZPRbgCkKcPBLEZxMRkQlSibs56HrhP654bdrYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wgkpduxRsjD+OSH8gukPD/adKICeCzc05HCfecu8XJE=;
 b=ro2EYfcyR/hrg+g/RE7fUpTZlrZjF1NaAjalJ+p6anpPT9Uc/M4Nvi55pnkuts1irUyJ+RqoWMO9h8UNylkEqpQtFwfhHFNb7MDx8f3xiKTzxxpGdnH27TyGn+dXp7Rb8UsBo6+KDTSjjtBY4IAcDNeNtCwwWKKH8d4tnGndax/nJlEgwqowf4SPRXMj1kvU96on5QSaWX8c2876kEOEbcrT2N03kHdMBDqGf1fdmeHNTUp1uEzYZBrvYu5HLoayaZZaYvxeO9V/V2e99Fmy2QZ70bbaMIGLfBPe+Mb0uyq3HOKmDXhwpyrszCE4RX0OrwbKQ6h7DicvbXd2dHqa4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5160.namprd11.prod.outlook.com (2603:10b6:510:3e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Wed, 29 Oct
 2025 20:53:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9275.013; Wed, 29 Oct 2025
 20:53:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>
Subject: Re: [PATCH 0/2] x86/virt/tdx: Minor sparse fixups
Thread-Topic: [PATCH 0/2] x86/virt/tdx: Minor sparse fixups
Thread-Index: AQHcSQ0Ih0h9zzbNYE6943t1KFKbXbTZmiiA
Date: Wed, 29 Oct 2025 20:53:52 +0000
Message-ID: <22422512e68eb6a62b137379ff3f25436d75af56.camel@intel.com>
References: <20251029194829.F79F929D@davehans-spike.ostc.intel.com>
In-Reply-To: <20251029194829.F79F929D@davehans-spike.ostc.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5160:EE_
x-ms-office365-filtering-correlation-id: e3af2565-544a-4dac-4286-08de172d449c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?K1ZHSjVNME11NjZtdm1MckR5ZDRvNFdyWE1vaHZRTjNpK2EyVGhxZWpRVDNW?=
 =?utf-8?B?UFc5cmJrZHY4SERvOHhqUWR2d0dkTjBCaDEwVXBwZE5qOFhCdDF5NXdTSUFM?=
 =?utf-8?B?VHhjYjBBd0pPWnl4R1IvLzlRTFVYR0hleUo4dzRaNjI2dnVXNWFWeCtOWFhB?=
 =?utf-8?B?enBVQU43a1Nibng0SEZ6NTQwUURnSUhBZ3puOEZLUEs3YVpSZ1RVWEo5cTRT?=
 =?utf-8?B?MjZRWmpjZ3I0dnZ6QVNtcE13OWlnaUYwaXdYOXVyQkVrK2VSMW5NaDBpTkpu?=
 =?utf-8?B?bnJWNkl3b052eGVyWmd1SGZUZFRBSGxKV0p3QWUzTC9KcFgrd3A5QU8vNUor?=
 =?utf-8?B?NlBVWEJNc2g2dEhTN1ppMzdjUjhZdFVYRXhIblVHbGZma2ZqVzU1MVhJZjY5?=
 =?utf-8?B?MXVDMzFZam01eDdJTjV5elg2NDlnNzR1L1E3Q2NoSWJNNFp0ZVNpRFNVbERG?=
 =?utf-8?B?bnJadWZEZHc4K010T0pyN2JIRlViMm90b1dISVRMMTAwZDByaW03UGlqWnJH?=
 =?utf-8?B?LytvZVJiU0pNUFZGWmg2VXdsM055cnBidHRLMlhCZ0xNdlBGUWJ4aVJGSExs?=
 =?utf-8?B?NFU4MlUwV3J5VlFBbDBydzZtUDdEZHBMZTFteVZMQ0tmV3NHWTNjU2hiSzFK?=
 =?utf-8?B?eWpmOWZNMExKOHk5SmxHYnF6WXlMdGNSWkF3MGRiWXVINzdDODRYN242Y005?=
 =?utf-8?B?elY2VTIyOWZaTDMvcFRtcUZ5ZTdMMnprWUVnaWc3WXdocEhvb3VkenMyMTdS?=
 =?utf-8?B?WFphRE5iUHhIRnRwR3k0M05pNEI0VXVvUG8rNEFXaG1zQnc2WTFUYXBab0lr?=
 =?utf-8?B?UmtZa0lOdFJwb0ZIRzl4K3dtZGgvMDkzSVVKd0h4Ni9qVjY4bnRIek9jK3pF?=
 =?utf-8?B?Q09rNFVqSHZLZXgvc0dpYTZXWU9HMHMxSmhia3FlTCsrc29RT1dpTXNKdjJu?=
 =?utf-8?B?aUo4a0g3ckc0eGl2aUlBenc1bVVKR1VuUDdhTFdVSnBYdWhKZG1PWUpPQW9D?=
 =?utf-8?B?eDlYdGlrQXBYZk9sb3h2QmdJdDROWGl6MVFpVVhyVkhVVzViem9JZFVzTTdo?=
 =?utf-8?B?N25yY0NRcnpRVkZ6dmFnM2lBamtWNXpLcFVnTUJXRUFMWFo2QXc5bElHakRv?=
 =?utf-8?B?RU40RzVhMWgyck5FNS9XdW1JRDJZeHY2bG9DTVpHOGRUV0UyUk1UTndLOC9D?=
 =?utf-8?B?SnptekY4OFpZeHRhc1NWZVFqWDlieXZ3Sjd2SmFUSlA0QU0yaTJxVmRJSStJ?=
 =?utf-8?B?aXlhOGNFZUkvbjBFQmphS1VMMFp3SzRTOG5MNHVKT3ZJZnhLWFdiL3lqZU4x?=
 =?utf-8?B?UVh1eHo2K01lbVFPSFEyTTl2dDBZZnN4dW5DRm4vVGFZWDN0RnRzTnVEU20y?=
 =?utf-8?B?bVJkMGdhSHl5YXNWUW9vbHU5UFdDeWhQK0pTQU1zRENjOXlWTFczMFJUSGtq?=
 =?utf-8?B?Y2pIWmsvcU1sZ01CM0VjMjNwU3dqcERWTXBiTzlNYitwbmMxdWtXRy91OEh2?=
 =?utf-8?B?S2xpcFdLbEhWR0VWNTdiU3dtOWh4aTU0VDV1UDBMTDRLQUVEc01HeW1aU3Az?=
 =?utf-8?B?QmJjTGxHVVBGeC9JVERTbjBXK21DelRObjVtWmFoS2ZDWTk0WXEwd0FyOUZ5?=
 =?utf-8?B?Z0JYU0t3L2t1WlVjM256TndzN0lldDBkQ2t1aE9oN01QNXpJRUdNYkRYamNk?=
 =?utf-8?B?NUZKK2d6YldqTVRtVnVRejdTUFgyQy9DUCt0eHhaK3FBWnQ1eWlxSW1LVXIw?=
 =?utf-8?B?ZWY4WnZQZW5KeDlRZnd5cDdUeVhhNFlOZWdsc3lsbGJJU2lMSWN0SGR0OGVy?=
 =?utf-8?B?ZWZQcWM5dEZSdmtUajUxNEdKb3pKWWpjYzhTT2hnUUl2dVUwV3hVSlpXMDkx?=
 =?utf-8?B?aytQZzI3UTMyRmY2a1cvRE9HdjJjd0RyT3FEaURWUmdTUXFHN3ord3czdnRX?=
 =?utf-8?B?VEpsVVFmWDFtUnRaajZ1aGZXUEZpenowUkxMSHhYdkpJUGx5aGFoU3A1K2xj?=
 =?utf-8?B?T2h1YXk1TTFQdjh5RVVHMGhPV1BPZEZ6NkZrQVNybER5QUVscEJoVUloRGNn?=
 =?utf-8?Q?Ivbnxq?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VnhlZmRhb2xmZVhBWE5FWktEQ1lmQUxIQXZ6TEMwSCtKWHBGcGZPeXZWNVVx?=
 =?utf-8?B?SlBRbnpuQkFSMUJMak9QYlI1ckdDcmNyUmd6L0RkOXl0bi9EdENtN2lIc3hH?=
 =?utf-8?B?b2RDMzJJZ09Db3hPajdvdDROMFJkd3d0TExpQjJKVnhrenBKamhhTmZxUldV?=
 =?utf-8?B?eUlIV09UOWRPRzRhaE1aakVqMko0QXE5VWp5U2M0Zm5nWUVaMkVzQ2FvbWdq?=
 =?utf-8?B?VFpJTVdGVE9pRzkySVlzYkhjVTZkUWJDcmZhNVgyRG1saE03RUZXOE9ibzRT?=
 =?utf-8?B?Q3NwYXdBRkNLUHdFa0RLR0VtVkJiN3NodW14UzdtV3Jvei9Wbm5keENUK1Ez?=
 =?utf-8?B?UHRzTlV3ZjBLZjZyUHFUeElIdWFJbkswcExyNlJNSTNPVnJGRU9lc1hsSHlF?=
 =?utf-8?B?SUZTbmZweXFPTDNmcDQ0K0dGb3RjYUFwWVk5T2FWQWJPQ2c4UkZGUkpxME9y?=
 =?utf-8?B?Y05LYzlkN1Urc1NQY0ltQy83OTlYcmJqdXhvOU43U1laT3ZTVUhia2hDSlBO?=
 =?utf-8?B?YnFySjFKVTl6WWo4R0dUNlU4M2VIdElNdnllbVZGeis2UGNDNTVCODFNRm9o?=
 =?utf-8?B?TDE3LzVkeE4zdGVzOEgza0U3TC92bkRmRW9KcXlnbFo1NTJRcDRhOStKRXJV?=
 =?utf-8?B?UE9qTG1nRlF2Ky9BZFZJRXAzVnRneTFyTmgxSTJDSVpYcUpSenk2aXRvenNl?=
 =?utf-8?B?dGlYdFdRRHQvaGJNdHJiaU5NY3N1Rm8yVWtobXhzQm9TWFdMSFcyMFdLTDB3?=
 =?utf-8?B?MVVSdWZLQjRDWWpZRjhWejI2V0dKMVY2ckRDUEsvdXRyRUZqYjNWSFhEVGdQ?=
 =?utf-8?B?UVBRVnFXd2N5QW1FeDFZS0lPTGdKbE5jK1I3b1NjanpFazE1RHV2TmczTmZo?=
 =?utf-8?B?a1RnSTc0RnNOV240WmpEZzE2STRiSmpyUmRRRmZ6QngyblcvMVBPUWs1TEts?=
 =?utf-8?B?MktLcU0rS1JiODhKTmpDWWRSVkVaRkZQZ3MyeW1XYjMydE5sNW1PSjRaNlZ3?=
 =?utf-8?B?V0doU0VleVErbjhGRkV0MGk2a0ZUWU50dTVRL3VIT21pd3hnRS9jZFZtcWlr?=
 =?utf-8?B?cmFTcHRONlJKaXYydW9tYjA2Z2hxcXI1U1ZGSldZMW1YdVVjVlFuTmdCYm53?=
 =?utf-8?B?SjVLVXE5bHZhaTllWkQ1MEFZWDQrUWV4cnkwTVI3L3RFcEtsZUhLdUpPTHdN?=
 =?utf-8?B?dW9tQ1BVNzR2S21kZE9lVlVwNi9xa2wrQk9ESVFjeEpNb1RmL1UvTEx1RzMy?=
 =?utf-8?B?Y2tUTzhkS094NEFHTkcxQndFa1g5SHJqaDZrZ1c4bFpBblJTaTVWNldQaFVP?=
 =?utf-8?B?ZHh3Z0lIaVQwQWduYUxUZHZuSXh2KyswL3pLVHAvVUxjWE9BQTRJcThkb2lX?=
 =?utf-8?B?cjh1L3U3cnpRTWVPd1hEZmRzOG1wVnRYYWQ1VkhaU0RvalovL1hZV2txeWpD?=
 =?utf-8?B?bmRSalE2QkM4ZVlsWFZTbS9IblhGd2hkeU0vdElxNk5vS1BsRTVkOUZLY2wv?=
 =?utf-8?B?Z3FhamxrMzY0MkRoZ0ovY09LQm1JKzFOZERtUE85NU9QS0pLNmZVMnhVVmZF?=
 =?utf-8?B?S2lsbXVOcGd5NDRMbGhRcG94V3Y2S09ESDBvb3BWRkZqam8yS1JHcjBZenZ4?=
 =?utf-8?B?NUpMRU5TQ0RyLzVycnpzSUg5d3pJTjdlYlliYVhhUGF2SjlBeWlJMERmaU5o?=
 =?utf-8?B?TUdRa3RzLzFjY205Zlg3eVc3SlRHQkt2cmQwd3RyMGJvcEViZVRITFdtN3Uw?=
 =?utf-8?B?a1p1dHlSVDVKa2txaExpRnlrdnFMY3F2WDNFRXA4UTZpaFI2aGNpZkdpbGhJ?=
 =?utf-8?B?YmVwdytuSitQeS9lTE8zcWtyMVF4RGdndzhQb0grdXArUTdQRzFTMytPLytM?=
 =?utf-8?B?SWd1VTlpWWNadEo3b3J2K0NUWk9sb1ZBc3Y2WGZETUkvaEQyaW90cU9nc2t5?=
 =?utf-8?B?L2dBWGhsaGJlMXJ5Z01ocW56cytqWnVQNEVmUmNCUXAwTGRrNnR4ek1raFVu?=
 =?utf-8?B?Vlh1M29HSUNWTW5PbkxLcjJDSFNqODU5ak5vbWJGb3JTSDJQWi9PN1NCcTAw?=
 =?utf-8?B?eHN6d04xcTF4UEhkanBzdFRadkZGZldNbHBrMFpncUdYV0pIUUdUMkl5b29I?=
 =?utf-8?B?aDhVa2NtVW4vR01tWTFJNm5MUGlGVWxxMEZTTkp5d3pTT05pbWN6QWZNcGZi?=
 =?utf-8?B?Vmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA093762BE054F44BD9ABD1F116624FA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3af2565-544a-4dac-4286-08de172d449c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2025 20:53:52.4880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ujE+/oeMjHlEJTGKH453z0dNPOlIM0sGkgixMfHQxxf8PjJekxvtIDocAhRptMpLKNz8aW6EdjVwakN069RgqmwDnWuhyuYW3ZT27ZidYmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5160
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTEwLTI5IGF0IDEyOjQ4IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
U2VhbiByZWNlbnRseSBzdWdnZXN0ZWQgcmVseWluZyBvbiBzcGFyc2UgdG8gYWRkIHR5cGUgc2Fm
ZXR5IGluIFREWCBjb2RlLA0KPiBob3BpbmcgdGhhdCB0aGUgcm9ib3RzIHdvdWxkIG5vdGljZSBh
bmQgY29tcGxhaW4uIFdlbGwsIHRoYXQgcGxhbiBpcyBub3QNCj4gd29ya2luZyBvdXQgc28gZ3Jl
YXQuIFREWCBpcyBub3QgZXZlbiBzcGFyc2UgY2xlYW4gdG9kYXkgYW5kIG5vYm9keSBzZWVtcw0K
PiB0byBoYXZlIG5vdGljZWQgb3IgY2FyZWQuDQo+IA0KPiBJIGNhbiBzZWUgaG93IGZvbGtzIG1p
Z2h0IGlnbm9yZSB0aGUgMCB2cy4gTlVMTCBjb21wbGFpbnRzLiBCdXQgdGhlDQo+IG1pc3BsYWNl
ZCBfX3VzZXIgaXMgYWN0dWFsbHkgYmFkIGVub3VnaCBpdCBzaG91bGQgYmUgZml4ZWQgbm8gbWF0
dGVyDQo+IHdoYXQuDQo+IA0KPiBNaWdodCBhcyB3ZWxsIGZpeCBpdCBhbGwgdXAuDQoNCk9vZi4g
QnV0IG15IGxvY2FsIGRpc3RybyB2ZXJzaW9uIG9mIHNwYXJzZSBzcGl0IG91dCBhIGJ1bmNoIG9m
IG5vaXNlIHJlbGF0ZWQgdG8NCiJ3YXJuaW5nOiB1bnJlcGxhY2VkIHN5bWJvbCIgaW4gImluY2x1
ZGUvYXNtLWdlbmVyaWMvYml0b3BzL2dlbmVyaWMtbm9uLQ0KYXRvbWljLmgiLiBJdCBhbHNvIGRp
ZCBub3QgZmluZCB0aGVzZS4gQnV0IGNoZWNraW5nIHdpdGggdGhlIGxhdGVzdCBzcGFyc2UgYnVp
bGQNCmZyb20gc291cmNlIGRpZCwgYW5kIHRoaXMgZml4ZXMgdGhlbS4NCg==

