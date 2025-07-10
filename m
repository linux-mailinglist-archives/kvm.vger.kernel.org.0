Return-Path: <kvm+bounces-52008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6204AFF66C
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 03:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15A90585B5A
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 01:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E4F027E1C6;
	Thu, 10 Jul 2025 01:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oHrJm0VN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE16254279;
	Thu, 10 Jul 2025 01:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752111253; cv=fail; b=Rxov7QiG9eoAqNfOBUt4aKty8L1T5L3/xHxVbCE415wMovY8LJQYid5s3g3ENnwiXzqPKEA8mMGkA3eDrAGUi2Milsa4xz2xGGfT1+ad7fK7mHnQiF3Q0v85SCj3JU/hLH3FdygHPyd9PxXLs5Ztu6EocU2Bgg24K98DLX/nsv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752111253; c=relaxed/simple;
	bh=q0QWbTTkB9bPLzC8558n9ssWSWw2MaVtmPz/J8JEwqg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HQi0VNq6VHsl+rEeUbh3Jr8kOmGjorZoHMyqqgPYmjy35wcEfsm++A770uERzHl7ixUhXGYt/+uBPGe0keogNWo0Vgf5s3wyIq/6joeVVQvdGJQiIGFk46EpCmOQn7fr4eSxO3ccnsnQWfMiPV7OniyfjwtO+TMztByuKkaxkwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oHrJm0VN; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752111252; x=1783647252;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=q0QWbTTkB9bPLzC8558n9ssWSWw2MaVtmPz/J8JEwqg=;
  b=oHrJm0VNG7xu3XGd4TIF02BUDDgVASp/I1ORECQ1eKRy9wVMfPIDf99i
   jtQp/hdW6AbZKuHz1g1YHJgtWfrEBW3sBbEwSxUHIEgh3UThYYkKBl97B
   QjGvHHqZyQD5Kk8vSaldGTKPKsVliEeF78Br93gkuS+HIBrUhpcn2KYaa
   +q7nggaEslTZe+FginbMGZW1EFvsRDLbrapeaMnSE/jlyxUXruomesshX
   unBaqeZ3L6g2P7sisHMb3qOP2sQ6oAAVFTJq/xnA0MI+hQUpeU8vB2MRH
   ULpzfl3JVdxoKO0jj/7pON//P7yEV2RIyIJamiah0V4C5g/pUZhNiDu5Z
   w==;
X-CSE-ConnectionGUID: ZIvKk1J3RVaIBDgnQbU2CA==
X-CSE-MsgGUID: E5RTNmuUSXmMEM40uZh0gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="54103510"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="54103510"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 18:34:12 -0700
X-CSE-ConnectionGUID: kEJtpaBKSD2D17eNtSb6OA==
X-CSE-MsgGUID: meRmjpP6QWCfttfynI54xQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="193137955"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 18:34:11 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 18:34:10 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 18:34:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.70)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 18:34:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iQDg5LA4TtqIyGWNURfklS3xEFW0J3CZTrxc4eXe89wMJf4IodAmq30/fG6c6gN7+78AkiEyq9+J/MHm+377myvsBWrU3/B5Cprbqf9+Di5lR85Dz1he/73uycO2N4iH/ebhv7I/B4x2ajT4OfTNz84FnvvHBPYHg5x32xblF5AGPnkkrDGOKpjutltHIipfwnNscizzy2H0pj7s/coyPAoQrgNQCgdNsIB84nGlVF8xIClLXRWeK0sUOV6cBxlTXbdaFnOzh0U8czocq8K5/Z5jKvWCKjx3E7qmoGk+WGkAucmAJLVsgavV7WRxgWOGdU6Q2qpeXUx7tEObA+Flpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q0QWbTTkB9bPLzC8558n9ssWSWw2MaVtmPz/J8JEwqg=;
 b=KlEOX0wKg4quti1lQLvr0wCUlMrLMqW9DRBb3jweWFRSDloA4JadP6XbboFfZ2mgsjColZH5gmdyF+2JlEvOkb0q3GcU/qsZgpByJtnQq76hyBpiXrxGP9q4Lx7gcHZadLWqfNZgkaBiTByx6DCGRqkA2059y5bL1FfGvcOuMLK0x2W8somOpAr1oiSdgyOWfawRuJmXBBgaQTj6hRFttwDUp36n+rsOz92YW5g4qoQ6zQxHLjhPjhQ4M8gz+K3s+fvdf1wR80CfwxuD/0EnByLScbGhlwF/afKnI23e7xaIh8zRYWZNXqlTA/pGeq3IfvXiNQMI4zBH76UXDub2Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8155.namprd11.prod.outlook.com (2603:10b6:610:164::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Thu, 10 Jul
 2025 01:33:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.028; Thu, 10 Jul 2025
 01:33:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Huang,
 Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 08/12] KVM: TDX: Handle PAMT allocation in fault path
Thread-Topic: [PATCHv2 08/12] KVM: TDX: Handle PAMT allocation in fault path
Thread-Index: AQHb2XKum6lt6z+w7k2vHggT003XBrQqwm4A
Date: Thu, 10 Jul 2025 01:33:41 +0000
Message-ID: <5c0b2e7acbfe59e8919cadfec1ab2503eec1a022.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-9-kirill.shutemov@linux.intel.com>
In-Reply-To: <20250609191340.2051741-9-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8155:EE_
x-ms-office365-filtering-correlation-id: 280e2a4d-97f3-4886-dc5f-08ddbf51cd6f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?c0dUQUhaUTVFbk1mbStKQ3BXb2ppN0cvYnN2UVBFdGpzZTZrbnQ2SXlMS1RL?=
 =?utf-8?B?dWpVSmk0RGhIdXBNT3JSRVZiOHZMVjViVGsxQ3hEcFpzRHg1U0k4cFd2VXl2?=
 =?utf-8?B?NXc4S2orMGdRamhYYlF2ZTRZa1ZYYkJ3SEh6aEk1MmYxU3p3eDNlQzVMOUht?=
 =?utf-8?B?UmxlZDdRN2JwR1AwZ3J2d3N2ZE1TS0hxZTF2cmNJWHZnM09sSU0zM053clJ2?=
 =?utf-8?B?YWMvY1FmYng2ek8rUnZsdjg0eWx5WVZkWm1URGxSWWRNZ3BvWDJHTVlXSWZI?=
 =?utf-8?B?RGViaEtNdFd0SWx3SENxMmltWkwySnpKVktGS2JlZ2VSVFhlQ1NOZm4rNG4r?=
 =?utf-8?B?U0tIV1BDSTdQVEQ4QVU0NndoM0R2SUNGQkZyZGxzUDFPbmtNbHZWSnErUUpw?=
 =?utf-8?B?MXhXKzR2LzhuRGxPNi9QbmtiNUlBV2tyTjRwdTN3MTNDalQyNlRhTjZLdjFO?=
 =?utf-8?B?SGc2REljcExkU2hHZkVmL0NOeTBld01ibE5SdXV5ZmpBai92WkVBaVZGT3VC?=
 =?utf-8?B?YXhack9Pd0t2NjBOTnBlWHYwclNxSXgvSEVGbFNxOTZjQkRLVlp2Z3J1K0pC?=
 =?utf-8?B?MWROVVdKTythUnhKQkx3VmZ2bVo3RnFHNGhXUU1kRnBSVWhrM25mb1BBMWkz?=
 =?utf-8?B?OE9sekpqWVNQNHBvcWFHSmYweHU5Z2pVUm15ZFlhYWdFa2RSc0NiZ3cwazg1?=
 =?utf-8?B?M0tueTFCWkE1U2Vid0Q0Z2VRZ2twQXp4U2dTY1p4TkNjUnJ0dEJwZ2p0dndU?=
 =?utf-8?B?VE81aDhBV0lzWW4xcWZ4L3JmVC96NWhubFhYNG5RYnN4TXlZMEtJd0tSN2RL?=
 =?utf-8?B?U3FDbEgzdTIxOVpUcjQ4eVl5SUsyZmpob0g5Mk5salBQLzQ1ZGtlb3RXVk1M?=
 =?utf-8?B?YzRlNjd2bm04blQ3Rk96aUlZUE14b1dnK3k0emE0bmxVSjBNSFZ1dllUbkVE?=
 =?utf-8?B?bnc3dU43NjIyZzNyYXMzcDVrNzJKOFZJUHhLNHhpQzhLT0JmVDZwVnk1VWt5?=
 =?utf-8?B?L1k5SXpLalRJVkhmZ2VlQkRLVTM1Q2JJZk9Ic1Vsd3F2STFBenE2ODNGdG5p?=
 =?utf-8?B?U3dhL0RicWJOQzMxdHRRbXh3b2lJR01jcHlhRWNnWWRMdDZrcThUM29Ld1Rv?=
 =?utf-8?B?RUVSMzV5SEhrUngwOFIwbmZZQTJpZHhGU2ZUMHdMTzFsd0ZSdUdQTk4ycy9F?=
 =?utf-8?B?UjBMc09yYTQ4aldBVHIrRHpKaDJ2NVg3ZGpIWlVvNXNzTUVNTzZkcGhEenE1?=
 =?utf-8?B?OElPYU1XUDZCOC92aHVQeFhHd0dGbEs2dTNtZFdjOUFlaVl4SlIrUGR6VkZn?=
 =?utf-8?B?NTlUU3NNYmk4c0liUVU2emRjS2lmSGh3ckp6bGQxZEtMWkpEV1BDZHo1Sktu?=
 =?utf-8?B?SEVGbWVtY2Rsa0xjRU5YZkMwdVBNalRsb1JoUWRaaW43VnpDVWhhamUrODkx?=
 =?utf-8?B?SEVtOGhtWkE1Q0NYTXI1R3FWdURNZFJCZ29EbE14Y3E5TnZTLzB1ZURWczFL?=
 =?utf-8?B?R05qdWRkOGM0UTRCb0Y5NituMU9jZnBLU2pmZ21nSXNhU1FMN0pZSUwxSTRr?=
 =?utf-8?B?TlBMSXQ3MmxSNndBQXRIR3owMU5GR0p1Ym9wMFI0M0FMMUhzRkdrQU8zU2NV?=
 =?utf-8?B?NTdmSHVxWCtSYnFrelJlZW4vdTFRUGxseWpoUk5SNkdGVEk0RlVJdUVvRUtt?=
 =?utf-8?B?MlFtZHNMQjBoc2hRYUJ0YUd2RDhGZmNxSG1OdzY0V3JTMHRmaU5UZE1zNHNz?=
 =?utf-8?B?WThMdGhiVVRub2N6aGhrYnJ1T0pobTRNU0NwOXpBNHJUc1RrMVBnckVlT3VF?=
 =?utf-8?B?UUpUeU5vTzJaUWZtNnFwSzBON0I3cGhMS1ZUWmZINVNtbE55QlkvTEpmSHll?=
 =?utf-8?B?eTloem5RejJIVUMzSGhsOEJXanN6cy9IeEJTWlRiZHk1eDdYckNBTExnSnQ4?=
 =?utf-8?B?ZGlvV3U3V1VnMSswTXNSa1hiRFoxL0lwWm9EM05TbzdEeXZiK01SNkQ2L3cr?=
 =?utf-8?B?MVd3YS9xUkF3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2s1MjV6UmVQT0M2YzVnY3pMRUM4S0t6dUVHcEdsNzdxT25RTW12dVpacGtH?=
 =?utf-8?B?cGlvOFd1VCswSUZhNk5kS2hmSUI1Wk9sbjJoV25qazIwZHFSOU1lc0d5Skli?=
 =?utf-8?B?YW5oUkNqZERDSXJZa0hFOVp1enlkWCt5QnhGQ1dRZXVsMDk4NFA0Vm53Rlcz?=
 =?utf-8?B?NmZQS054aE84M3RWcUtXcGlpanFJQ2hVOGlMeGQ4NldvUUVEdUgxMEdIZzBs?=
 =?utf-8?B?bDduR29Uek9NZnhoRmU4dldKcHRzSU4zQTg5MXBab2dvRnhDUnJ3WVc1T3pk?=
 =?utf-8?B?b0pGamdFWEdkU3NIdm9TR3N6Y3IzcDJHamxaekllbC9PL0ZaTXg4b2tNR2FW?=
 =?utf-8?B?OFNaNExmSW8yL0tIWm5VdVpRcUtTdDcrMXhsVmNKOFpWWU5nb2Vpa0huclhZ?=
 =?utf-8?B?YzNjaWlDSXF1MnE2cVpObHI5bU9haVYzZ0J2NzA4TVhmRWJHdVVBUWxoWkVG?=
 =?utf-8?B?cDRrcVVNeFNETGFETmNxWVkvVEhMS0lSNEh0bmY3UzBIRm5Lc1dMZHFrQkl2?=
 =?utf-8?B?NU9CNzNYdzlNcXY4N3pIb3k0TkZkUy85bThBaVFOWFdnVUI3L3RWVWs4czNB?=
 =?utf-8?B?UHExd0xqR0t5REpnSy9jazJIRXRCYzFRY1NWa25DckNpdnBrdmh2a2t6bExo?=
 =?utf-8?B?c0kvTTFBWU5TNWRiVzMzdGhwTWYyUnNaRTBIYzBZUzFmc1k2TDJaSGdWMmd6?=
 =?utf-8?B?M29uMlFFT1VGODMrN1gyYmgzSjllTWE4TW5KSTF2RFhza3FoanlYUTVHVHRQ?=
 =?utf-8?B?RjMxOUJGTVBtellOclVNMk9ydHZSdE0vUnZNWTFGcCtPRnBGTi9BSlJWQkF6?=
 =?utf-8?B?ZTdYd0wxWDBVYTdXMWdlL3ZXdG9GY3F6cGJkRGlaem80Tm5GUDltR0J4aGFJ?=
 =?utf-8?B?NGs3eUt5aDd6SkZINXNFVklPSUxDNDVvT1paZ3o1NDlnOVczMWRWcWxtR1N0?=
 =?utf-8?B?QkpWTlVGb29nVXNwUG5xRXQvUmdMV29EQnRCVVhqY1hWUkJPRmtNMitiemVj?=
 =?utf-8?B?Y1NvZXh4YTRwamNGZy9WQ3FybHl5OTVCQUNZVVlFdDcrVU43NTFHQ3RYRTZJ?=
 =?utf-8?B?ZVR6eVJTYm94UDI4SGhzM09BY2pvcTVTUlZ1TFl3NHduM0tLK2FMSkJ3bGJJ?=
 =?utf-8?B?cXN0ZEZzT2NJaWhpMmFEcHZNYXZSZHBmRVZOY2FTTC9tb0dhS2E2djErSUJz?=
 =?utf-8?B?NkV6ZjRLV3JaYm1Bb25FVExpUDBZUVZidFFPRkxkK1lTdDN4VTB5SXo4U0NT?=
 =?utf-8?B?WnFLQ055RC9zbU1YUXdnNHBUVjhkUUZ6L3VnUXdZUmp5b2tWamUrT3JvSTlu?=
 =?utf-8?B?bWsvRGNvOFdIVjJod0ZjdDN5QWdxK0xxNCtxbnRkRnhnc2xVWjVTendLa2tn?=
 =?utf-8?B?RDZ3Qk9uTDFnTjZGanVkSXFZUlQ3eUNyRGlZbVBxNXpIejNPK1I0TzFWaFFI?=
 =?utf-8?B?QVBwQXRpSG4zOVJZa0RXMTFRMy9qVjVzenlmbGtrd2pzcHZESW9KMk5WamVI?=
 =?utf-8?B?TjFmSTBWaXcyYUdoM3lEN3hkaUtqUlE0SVhNc0N2d1NSa2x6RWtRbGZCZ3Zk?=
 =?utf-8?B?UXVNSUJ4TnI1M3hWdzZMYkVORUsvTC8yblU2R0sxdTMzQmxSd2dQMy9TWXBo?=
 =?utf-8?B?VWJiOGl6VTlMMEtNNWozbnhmMWwxZDErWUZtLythaXBDTjBDd1pQSU5uc3cw?=
 =?utf-8?B?Q24yYVpmQ2xIbzFpeW1zbjVoRm9xU21vRlh4bGRXLzgzd05EOWw1VjZkNzA0?=
 =?utf-8?B?LzEwYWR6VTFwV3l1aUs1cXBMQ29heW9CaTA1V0RpTm5EMlJ0Nmt1TXIvM2I2?=
 =?utf-8?B?cUtFSTZpKzVhb01nSkFYdWh6M3RjNk8vODZ1Mm9wMDRrdFF2cXh5MXF0L0xK?=
 =?utf-8?B?Qjgwb2JSaStqWHFPSXpqT3R3Vk1rZExsSit2RkJRSnJleHRZRTBxK0ltN010?=
 =?utf-8?B?VDVoeGQraHpFNllzWmkwVVkvTC9TdXN0UGVKbHVVWDZiRUZuNmM0eVpCU1ZU?=
 =?utf-8?B?VXhVQUx2dkQvemszUXRLTlB5RGNYRWFtRHZsNHBBNlU5M014Q25WaWE0UEpD?=
 =?utf-8?B?a0dVWHZYL3pOazNGTWsvbC9uYkFHYlZjSUdPakR4aENWN1hQNmU1c3hmTVgv?=
 =?utf-8?B?WDNaS3NBanM0S3ZRMzUzb1M3cURXUWdPMTVvTms5ck9wT0hSeStvNmRvOHF2?=
 =?utf-8?B?V3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CCA44FD22332734084EFA0ACE71595BA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 280e2a4d-97f3-4886-dc5f-08ddbf51cd6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2025 01:33:41.5752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qd/1cmtikXY4d9Iv8+ck1Zd7F/fJ0VjerH6QtkpooqPS11rQWXRUOAwriXb0QOzk3TyWKIHpfaZQEho9wPeZVmTLBUqlO+kAg0BTKci7Alw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8155
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTA5IGF0IDIyOjEzICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IMKgaW50IHRkeF9zZXB0X3NldF9wcml2YXRlX3NwdGUoc3RydWN0IGt2bSAqa3ZtLCBn
Zm5fdCBnZm4sDQo+IMKgCQkJwqDCoMKgwqDCoCBlbnVtIHBnX2xldmVsIGxldmVsLCBrdm1fcGZu
X3QgcGZuKQ0KPiDCoHsNCj4gKwlzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUgPSBrdm1fZ2V0X3J1bm5p
bmdfdmNwdSgpOw0KDQpUaGlzIGlzIHVuZm9ydHVuYXRlLiBJbiBwcmFjdGljZSwgYWxsIG9mIHRo
ZSBjYWxsZXJzIHdpbGwgYmUgaW4gYSB2Q1BVIGNvbnRleHQsDQpidXQgX190ZHBfbW11X3NldF9z
cHRlX2F0b21pYygpIGNhbiBiZSBjYWxsZWQgZm9yIHphcCdzIHdoaWNoIGlzIHdoeSB0aGVyZSBp
cyBubw0KdkNQVS4NCg0KV2UgZG9uJ3Qgd2FudCB0byBzcGxpdCB0aGUgdGRwIG1tdSBjYWxsaW5n
IGNvZGUgdG8gaW50cm9kdWNlIGEgdmFyaWFudCB0aGF0IGhhcw0KYSB2Q1BVLsKgDQoNCldoYXQg
YWJvdXQgYSBiaWcgY29tbWVudD8gT3IgY2hlY2tpbmcgZm9yIE5VTEwgYW5kIHJldHVybmluZyAt
RUlOVkFMIGxpa2UNClBHX0xFVkVMXzRLIGJlbG93PyBJIGd1ZXNzIGluIHRoaXMgY2FzZSBhIE5V
TEwgcG9pbnRlciB3aWxsIGJlIHBsZW50eSBsb3VkLiBTbw0KcHJvYmFibHkgYSBjb21tZW50IGlz
IGVub3VnaC4NCg0KSG1tLCB0aGUgb25seSByZWFzb24gd2UgbmVlZCB0aGUgdkNQVSBoZXJlIGlz
IHRvIGdldCBhdCB0aGUgdGhlIHBlci12Q1BVIHBhbXQNCnBhZ2UgY2FjaGUuIFRoaXMgaXMgYWxz
byB0aGUgcmVhc29uIGZvciB0aGUgc3RyYW5nZSBjYWxsYmFjayBzY2hlbWUgSSB3YXMNCmNvbXBs
YWluaW5nIGFib3V0IGluIHRoZSBvdGhlciBwYXRjaC4gSXQga2luZCBvZiBzZWVtcyBsaWtlIHRo
ZXJlIGFyZSB0d28NCmZyaWN0aW9uIHBvaW50cyBpbiB0aGlzIHNlcmllczoNCjEuIEhvdyB0byBh
bGxvY2F0ZSBkcGFtdCBwYWdlcw0KMi4gSG93IHRvIHNlcmlhbGl6ZSB0aGUgZ2xvYmFsIERQQU1U
IHJlc291cmNlIGluc2lkZSBhIHJlYWQgbG9jaw0KDQpJJ2QgbGlrZSB0byB0cnkgdG8gZmlndXJl
IG91dCBhIGJldHRlciBzb2x1dGlvbiBmb3IgKDEpLiAoMikgc2VlbXMgZ29vZC4gQnV0IEknbQ0K
c3RpbGwgcHJvY2Vzc2luZy4NCg0KPiDCoAlzdHJ1Y3Qga3ZtX3RkeCAqa3ZtX3RkeCA9IHRvX2t2
bV90ZHgoa3ZtKTsNCj4gwqAJc3RydWN0IHBhZ2UgKnBhZ2UgPSBwZm5fdG9fcGFnZShwZm4pOw0K
PiArCWludCByZXQ7DQo+ICsNCj4gKwlyZXQgPSB0ZHhfcGFtdF9nZXQocGFnZSwgbGV2ZWwsIHRk
eF9hbGxvY19wYW10X3BhZ2VfYXRvbWljLCB2Y3B1KTsNCj4gKwlpZiAocmV0KQ0KPiArCQlyZXR1
cm4gcmV0Ow0KDQo=

