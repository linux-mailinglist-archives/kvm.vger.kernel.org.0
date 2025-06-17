Return-Path: <kvm+bounces-49642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1490ADBDF0
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 02:13:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08768170023
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 00:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 329E9E573;
	Tue, 17 Jun 2025 00:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C2FHoEW8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43BE7483;
	Tue, 17 Jun 2025 00:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750119211; cv=fail; b=K54xYzE6bGC0G1vcc1eg90bbY8rQ5GOdylBg0aSliZNuLvm3tADBzE45ScsSKKdo93N4nXpf65MH8iU3dDNuXGNeIki/6Qnmnu33vIdMW+i18JIBElypeiQ8zJBe/Ws5+9/Q41+DeIDliort+NdQg7a9mz8CN6Wvz6uahTKnO2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750119211; c=relaxed/simple;
	bh=+c+1GMDnksC6IV17kD8PAG5mM0w1EjJQftHKfokgLPU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZbO6Yq2rHemx1fymYSy4ZaEZ5fcO9Tdn29V+dMQWkolS4ttoPn5sRdpFtvKMhK32vvJNv3qUeoflxwhvvg7lRqHSqvBrqPId7bN3sHiE4luUmKmqDg+m32cwZmlyNnJJoc6HP0FyYY8JC6Z8V2zShHKCdrvAMykkkdZhAORagu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C2FHoEW8; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750119210; x=1781655210;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+c+1GMDnksC6IV17kD8PAG5mM0w1EjJQftHKfokgLPU=;
  b=C2FHoEW82pxyog0yDvQIwuTQ7vEYncbs6sAOiY7Ry/ESOvmi5le6dh4d
   4+Hjq7SuK7XsZz4WyhU0Orw2ISNoKZHYSdywiAGaCh3JmjkZvjzqKoJOh
   Ea4jjEQXMoJJZeCe0cG5B0qd1q3BhtHMf56K7GJ20m/2r42sfkm+hl/Td
   6ykLh/k/af87w9MjBex5Kp1LF0XVDmjX52LfCuExdDtLWBa1mMcGbnxIs
   yThLL6EUvGEPy0bUcLjBbP+D4MF4jicg76Q/FkWw55pOXFczK3on1JACB
   D+yCj3IQ1HRSiPuNifZgD4klUJhJEnb8YZzFcDTIcBEpcdzM+y0LETCAV
   w==;
X-CSE-ConnectionGUID: 65cmdI7AQLOyLeSBQWdmrw==
X-CSE-MsgGUID: IagvPP83TBuVIdyFHJfPvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="51387870"
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="51387870"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 17:13:29 -0700
X-CSE-ConnectionGUID: iw+CayxSQZefYWvTFVERaA==
X-CSE-MsgGUID: 1whvmZVBQ7aSNukuxjzY7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="149504734"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 17:13:28 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 17:13:24 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 16 Jun 2025 17:13:24 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.47) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 17:13:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BKExLXXshKTHaUA2rpu819Bfsf9EaZbZ+CA9Znjbka8thMHyILEBDFF2qnabxhU+X/Vb5dDkVaqYFrSsyWgct4qM9JgPKQYY3/hJOkNyS6NwFH6Drkz5ayWyvfVPxSD22aY56zu2inVDp4q8wpS3CgPhwxQTGKCsk7qJHU/Qir/ErKBGH7HKCRQ35XbSPNnaRTPTo9o+9IiKJQl2T0RxdzRbjL6NdHXbADM4/2QMjXMXKg0C7EOHTr2hbz2ku3ERe2pYvlc9IzKyj8ZYXVEQmQhvWCrBD18+B1PXgHQFsmf6CnFFum5vePS4PYC8DbD/UbVCqk8di+L1o/eNtkZhjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+c+1GMDnksC6IV17kD8PAG5mM0w1EjJQftHKfokgLPU=;
 b=a/dKEXoBWH8Pk6mYqpe0GH42xLqxYz7sI8FUx3FYmFEwn21OYgQ3k9SR3IuvkSbMQmA/aJGbBmdsQvdlgMMtI2E/yfRz29u239I/UlKfuq86lFw3R26jVbO+xEDW4K5M8d0x9fhJYYIOb56LhntHmDnbbM4/keFmZRwXlQN1hRuLiboOxC2PuZusgY62Qmk/Rkx37Q63eYSO2KGb5Rx0t15+GQ/ioGewr70LOQcScZP9fOL24rzkCopIuTBrDdwKeysXPbrbiqLAHdQAF0O/djxtcwY3GzMrOIdwQfGpUS3InSj5luc6vQVRUGVcGLn87CU5/eTe6Jl/6mbYTZOW4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS4PPF7CFF9C87C.namprd11.prod.outlook.com (2603:10b6:f:fc02::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.26; Tue, 17 Jun
 2025 00:12:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.018; Tue, 17 Jun 2025
 00:12:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Du, Fan" <fan.du@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmA
Date: Tue, 17 Jun 2025 00:12:50 +0000
Message-ID: <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
	 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
	 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
	 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
	 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
In-Reply-To: <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS4PPF7CFF9C87C:EE_
x-ms-office365-filtering-correlation-id: 6bc6948f-1890-454d-6656-08ddad33b285
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RkVuUlJXaTNsNExDQ1lhV3FTTDFFY01acytSbm5yOW9MQWFtbUZSbXVDdzIw?=
 =?utf-8?B?b1VlY01CSW93eFlXMnVOZFBqdDNIQ2k1TWdGMGFmWFNvZU9YNXMzM0RVbG16?=
 =?utf-8?B?M0pwelJLRVRETlEzT3RiVlB0RTJhTlBxeWR2WEZHcTJjQ2wzWXBEaEhnalVi?=
 =?utf-8?B?eDlrNmRVRzJqQ0grYmJ4ZlU0Ujk2R3NTQ045TlEwbkdiNkF3aHpQWExKQzJ1?=
 =?utf-8?B?b2d6UHJGTE52eG5yZjZqN1VJMTJQellNZjJ6ZlhZaEhDM2l0Z1hzWEhka2hP?=
 =?utf-8?B?encxRi9nVW5CRW90VFNwcXdIQm81M2hOQWJuRjUzU0pQUDJiMnVWbGFkRHF1?=
 =?utf-8?B?MlJZeHRZWEt4MjFOeENjSTlKUHFPRXBxdlBBelpiMEEwSUxGdWxWdWtMSE1u?=
 =?utf-8?B?M1ZmbEJkTUpub2d1L2IwQWlvWGt1RUtlYnRMQVBNQ21heHVoU3F6OElhcHQz?=
 =?utf-8?B?WENaeGorT29PZkhnYThuUU00Uy9aeXJVZGVlUHo1SHdmNFkzZ2wwVUdHSnZr?=
 =?utf-8?B?UGtyVEFIRjV6eW05WGNoTU5lYTFCRzhYeUNtRVdWWUQ3MjV6MlB1VkRFTkE3?=
 =?utf-8?B?blkxUWpNd1U2T1g3bzFQSmc1L3NGVDhvcHQyU0MzVnJNdjh4VXFUSWtxWmRr?=
 =?utf-8?B?SUFvbnVrWFFKeVRUU1RBNkcxcHMyUmhJWE5oU3NueU53T2RhdVRoWUZFT1k1?=
 =?utf-8?B?cytvN1h4Um9qcGNVUjliNzBGb0pmWCtVZGdHSitKYzVHQmVMQytFM2JQc3pQ?=
 =?utf-8?B?WkV1TTF0Q0VyNk1ISEFFMzJCK2I5aU5BV2hib3N2QzNvdXlKUTFTRUc4Tzg4?=
 =?utf-8?B?emFBOWNSRHBkSGFEckJUL1g0WXRhS2xCZWd2aFRSdjBtb21oVjdyV1M5ZTZh?=
 =?utf-8?B?MS9ZSm9Zb29Mb0RZelIxWjFZMkJVNDMxVFdjZjlNa040NGptall2Z2dySm8x?=
 =?utf-8?B?elF1UnFQejhiSXh4MVZ3Uy84eit5TDBBLzNVa1dHalBiUkc5ZEpNS3FTR0Yx?=
 =?utf-8?B?WVJGdjl0OVk1NDExd1NVaTRZYzdqdFAxN2ttYk1JYmNPMkdla0tLUk5wVUZC?=
 =?utf-8?B?aE56ZU9lZU4vZkE4OVFrYVhFS2N6OWxuTVRmM21sL250VU9Vd2xkNFl1czNQ?=
 =?utf-8?B?RUoxNjhlYWExS3M1dW4yZ28xSGFKa1JxVFBhTjc5REpDaWU5YWxRTGtHVVlm?=
 =?utf-8?B?b2swOW84RlArZWdsdjM1VE1GUys1c2tsU0FWYjBZaS9kZmV0UnJQK1dRZWZV?=
 =?utf-8?B?VjRqRXUzK084WGdmaURJQjVLbnk1cDh5L2p3RG51SVMzWVBoZEtpR09QSWFH?=
 =?utf-8?B?andxWTJZcG5vSG5xaVBVa3ZNWnpxc28vZ2xSQTNKTlQ2aTh0UXBvVmlqNmVi?=
 =?utf-8?B?c0RhV25OYm82b0lKTjdLTTlKeTZ6QkFJNTE3aTloRUFRZ0labkR3Ulh6eWxC?=
 =?utf-8?B?MFF3VTd3dUtxUDlreGljZEN5Sm4wSTNjNTRreEs4MnVUMXhiZ1BpbFlIdTQv?=
 =?utf-8?B?Q0pBNHZoSEdaTUY0MWI4bEdTTWtNcUxOeU1uTEl5RlpIZURTMUVDVk9aRS94?=
 =?utf-8?B?U3ZTZndXRTZPaEtmUzFoWW1pS2tKeHBJRzdLcWxHcTVFQjhKTVNLYWFpOEY4?=
 =?utf-8?B?cnBXanFSM0tMbXpIUGNKRjQ4MnVGYlIrakorcTNOZWF0ZDd2bWZnbTUwRVly?=
 =?utf-8?B?czBnL0NVYUFpdmcrdFdCU1lKTTNzM1pna2RzWjBWSTRYZ1ZkSDJlRFRLeC9I?=
 =?utf-8?B?SWs1VEN5Q0loZjZROEkrODZFa2ZnQWlNNy96cHVYdjRGQnN3VCtBL3hNbVNN?=
 =?utf-8?B?TW9FSXkrNmlqTXovdzR5d2ZVc3BKek9Qbm1tR0hkNnhIT2JUb3J3TDlJekpa?=
 =?utf-8?B?SVFMa0hFbXZ0MHRSd3VmaVppelczQjBVZjh6OHdYeWdJcGRvbXRHdi9CZkJy?=
 =?utf-8?B?SnhaSFhrQ3F6Z0duOGtpd2tKaXVQeWlxRjlYYTI5RlkzK2R1M04rVm1lSFRP?=
 =?utf-8?B?MktvaHY2K3ZnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ekh3SEk2dlZVV1RNN1g3Q1A2alpFdHFKMlhaVkJtL0Z2R0xFeXJScEI5dmJE?=
 =?utf-8?B?amRPWFhDNkVZUjMxOGZ2UUVMdi9Qbk1QZHE3NXZYM3lKS2RsRnZvT2tIbVNJ?=
 =?utf-8?B?akxvRmhYU1BGbmhRZWY5WEhLSklDRVd4d2FCaXlDYmVqaXcyRHJTY09ReFAz?=
 =?utf-8?B?amJsdnhhS3V6dHRnbGJVYzVFYmwrNlhTN3A4N2tldGYzc1VpL1l3aThxWmJF?=
 =?utf-8?B?cnZZZEQzYjFVNFcxUUxtVlU0YmdvV0l1ajB6MUNEVjQvd2lZdzRJV1VMMndk?=
 =?utf-8?B?ZzRQQVJXUWg1WUdKTzFvbDkzdzVEeUpXd2VERFZkUmxaT056NmZXUlpleFNQ?=
 =?utf-8?B?SkYydW50SzJkRFZXQ093TmptbStITWhzdEx3c0lFMDVrUGYzbERKdTNrVFRO?=
 =?utf-8?B?bDJpZ1FTbW1leHl5ZnlWU2c5L25qVVdiVzA2K3A2cXBCb1FYQWgrRDNZS1Bh?=
 =?utf-8?B?Wm5qdFdsU2RyZWJtcWtwdjhhYytmUnpMaENETDNmN003ZFZlbUdpZU9IZ2xZ?=
 =?utf-8?B?cFRYaElOVWxLZ0RxaFM1MVpVWXplSHcwN1dlQUNYN1BncXp6SkxjR0pmYy9l?=
 =?utf-8?B?UVBYWUFqVTJCb3EweWd1U21ubnp6UlNjdjBUOUlpWW5Dem1adzlwNytVbGNv?=
 =?utf-8?B?WFVZZ2RkaVdWUXNpMWlWK0pBcXRGelBhaHk2Z2FOMjZCR1dQZ1lQc3FkS3Bh?=
 =?utf-8?B?UFcwZHlxY3hLclhvd0ZKSjhCOCtiNWNUOW0yZEpHRktDTG4vell6alFGVG9J?=
 =?utf-8?B?ZnlQcWdlNitYb2ZGMm0yZUd4TzlhUk1MQW5oMFJrNWRadCt2VSs1RDlIRU9x?=
 =?utf-8?B?cFljR25NeUJ2UkMyWkZUVUk2Mkt2R2NXdDUvQ0wybEFJWUNxTjc1TkhDZ1pW?=
 =?utf-8?B?V3NIREE2OFZ5cUtoNVlDcXhEYUJVRmVJN2dScTVzZ0w0MkVmSDBsMnFyZkFn?=
 =?utf-8?B?RVp4eTI1ZjF3bC9TSi9NVEhqT1JyYWtHN0J5OWpIZ0lhblFpcnJRT3pJbzQ3?=
 =?utf-8?B?QzhCSEdlZVhDU1Q4dVdGellVcnByVUpKNHFPcDRuMWdyY09hWEVNem9DbXFO?=
 =?utf-8?B?VzczVnJXVjFwbzJNdWpNZnhSOFVlbmc2NFpzVHdMN2NXODRMcXpIaWpmZGxJ?=
 =?utf-8?B?UFE0dG9wdExmc2hING5FbmkrdTk4WTZOMGl4cS9LR0REQ094NkliRXo3NHJR?=
 =?utf-8?B?UGxOZkQzdGYrT1hldUttMFBXbWVybVI1b3hQWU81VTFEUWpGUExUYzE3QXp1?=
 =?utf-8?B?QlVnQzQzWXN1aGhIR1g0eWpDS3FRdkkxK3h6NERWMnpZZ0plNk5NQWdEMTIr?=
 =?utf-8?B?S2JJQlRkY292bllQaFMxU1pDY0lyY1I1ZWcycDRVazZraFB2NmpNeWJPSk9k?=
 =?utf-8?B?WVBJYklGNHpOam43Sy9qQzZER2hkWUU5Z3J6c3d3dEtiVm81V2VHRU44UGE1?=
 =?utf-8?B?Q1l5ZFlHblpCM0U1dnY0VW11YzZhcko1TGQrUWdwaFVLVEJFVGRpcm5Ic01k?=
 =?utf-8?B?TVBxZFYxK2EwRHRGTDVFL2plMGloT2U5UnZKSEx1RE5ZUGxGclgvNW9MZjVj?=
 =?utf-8?B?NjNrcThSMmhycWZKcm5zRHJLczk3ejhzOVZrcCtXSFozekRCQ2xIWXJFSmhH?=
 =?utf-8?B?YXM1YlRzR0RRT29BSjVmTEFHNU81emZPZ2xyL3oza0YwckZkNVE1cnhYVXla?=
 =?utf-8?B?bmgzaGFiVFJCUUJ5SjNpajRvcGVxS3ZjMVlDS3ZDZUV2YTlSem8vOE53SXN3?=
 =?utf-8?B?Z1J1OWo3Z1duYTh4c0taMWEvZlZJMUxYY3ordmdYNWMrbVNPaGRJS3QzdXJz?=
 =?utf-8?B?b2FVdzNXSmV3MDc0bHpPTzVad3ZTZWFiY2JVYnVpQVJldmppM3BGdUo5Y3FL?=
 =?utf-8?B?NmgrRlJwZHBnRkp0cVhFVnVsK0RFYURwNnM4VE5Hdjk4azYzMXNZTHlJRDRV?=
 =?utf-8?B?U0dkd2UydmxFVUg2Z0U3d0ZhS3lxSHFxenZRL3k1ZlQ2R2JtYlU5ejFNamhU?=
 =?utf-8?B?ZVNlSmRxMTAwcnhodi82cEI1dUZOblpGTW5PMGxxU3psWkxmN01SWVQ4Vjg5?=
 =?utf-8?B?YnNCc2xBM2V4WlJ1NHdtZWQrQnRsVzEyc2E3QXBGVG56eDF2MzJjMmM0cVpY?=
 =?utf-8?B?NmFrZGp5b3F0UEh6SXAzTW5tTGpGaVdzTm9TUTFhMnUyNEhIaVVUK1hSVzlT?=
 =?utf-8?Q?dR18a5lgd82MzjTn4CfHODU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B39CBE2418D9A47A283FF87157A777D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bc6948f-1890-454d-6656-08ddad33b285
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2025 00:12:50.6372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cf8aNS33H6xoShPcyHFAdJcAK6U8UGzVCCdL6dWxihfiyf52fQAAq/c9mMZCoobw7RTAuMy+7MX6U8L1CEIOuKiHNEmv58fqjY9GZoJzKhE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF7CFF9C87C
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTE2IGF0IDE3OjU5ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gSWYg
dGhlIGFib3ZlIGNoYW5nZXMgYXJlIGFncmVlYWJsZSwgd2UgY291bGQgY29uc2lkZXIgYSBtb3Jl
IGFtYml0aW91cyBhcHByb2FjaDoNCj4gaW50cm9kdWNpbmcgYW4gaW50ZXJmYWNlIGxpa2U6DQo+
IA0KPiBpbnQgZ3Vlc3RfbWVtZmRfYWRkX3BhZ2VfcmVmX2NvdW50KGdmbl90IGdmbiwgaW50IG5y
KTsNCj4gaW50IGd1ZXN0X21lbWZkX2RlY19wYWdlX3JlZl9jb3VudChnZm5fdCBnZm4sIGludCBu
cik7DQoNCldlIHRhbGtlZCBhYm91dCBkb2luZyBzb21ldGhpbmcgbGlrZSBoYXZpbmcgdGR4X2hv
bGRfcGFnZV9vbl9lcnJvcigpIGluDQpndWVzdG1lbWZkIHdpdGggYSBwcm9wZXIgbmFtZS4gVGhl
IHNlcGFyYXRpb24gb2YgY29uY2VybnMgd2lsbCBiZSBiZXR0ZXIgaWYgd2UNCmNhbiBqdXN0IHRl
bGwgZ3Vlc3RtZW1mZCwgdGhlIHBhZ2UgaGFzIGFuIGlzc3VlLiBUaGVuIGd1ZXN0bWVtZmQgY2Fu
IGRlY2lkZSBob3cNCnRvIGhhbmRsZSBpdCAocmVmY291bnQgb3Igd2hhdGV2ZXIpLg0KDQo+IA0K
PiBUaGlzIHdvdWxkIGFsbG93IGd1ZXN0X21lbWZkIHRvIG1haW50YWluIGFuIGludGVybmFsIHJl
ZmVyZW5jZSBjb3VudCBmb3IgZWFjaA0KPiBwcml2YXRlIEdGTi4gVERYIHdvdWxkIGNhbGwgZ3Vl
c3RfbWVtZmRfYWRkX3BhZ2VfcmVmX2NvdW50KCkgZm9yIG1hcHBpbmcgYW5kDQo+IGd1ZXN0X21l
bWZkX2RlY19wYWdlX3JlZl9jb3VudCgpIGFmdGVyIGEgc3VjY2Vzc2Z1bCB1bm1hcHBpbmcuIEJl
Zm9yZSB0cnVuY2F0aW5nDQo+IGEgcHJpdmF0ZSBwYWdlIGZyb20gdGhlIGZpbGVtYXAsIGd1ZXN0
X21lbWZkIGNvdWxkIGluY3JlYXNlIHRoZSByZWFsIGZvbGlvDQo+IHJlZmVyZW5jZSBjb3VudCBi
YXNlZCBvbiBpdHMgaW50ZXJuYWwgcmVmZXJlbmNlIGNvdW50IGZvciB0aGUgcHJpdmF0ZSBHRk4u
DQoNCldoYXQgZG9lcyB0aGlzIGdldCB1cyBleGFjdGx5PyBUaGlzIGlzIHRoZSBhcmd1bWVudCB0
byBoYXZlIGxlc3MgZXJyb3IgcHJvbmUNCmNvZGUgdGhhdCBjYW4gc3Vydml2ZSBmb3JnZXR0aW5n
IHRvIHJlZmNvdW50IG9uIGVycm9yPyBJIGRvbid0IHNlZSB0aGF0IGl0IGlzIGFuDQplc3BlY2lh
bGx5IHNwZWNpYWwgY2FzZS4NCg0K

