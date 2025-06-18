Return-Path: <kvm+bounces-49918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C163ADF9B7
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 01:21:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6021E189E923
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 23:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87CC528152D;
	Wed, 18 Jun 2025 23:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="il1NY7Pr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EAF213E6D;
	Wed, 18 Jun 2025 23:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750288869; cv=fail; b=ghbuBR/VURkeUjUl8wZcjtB2tYncQ/v223SViZZzc0j5Rp0Htdg9nAF7hb8kxf92n+dJeucb2FlJ25atJtTrTJB7azU0oX4AZHJYOzBcX1FBKgQ5El9uh2/m5n5dLQqgFhR4Y6EeEyEWGIOjesUOuJc9hVSKOsw1WrgBED3KADM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750288869; c=relaxed/simple;
	bh=maF+V+ToxaqemVTAlk4O+Uh0WqdYu7r5MK1eqhfqNzU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BS/oFpznbrjcoRNGLSnN0E1zJTZMAhV5PEFni4+NiC0NrtpicD4WntkKniZpJLdpjmufMjjuicFOUfT5jkPUJlJFzqAgOQ2CZr101O3NnH7SCWa0ycX2/i129sIcltLqe6KfCMExX1mm60RtDuexRYObMP9NZsPYbl5ki7r9hnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=il1NY7Pr; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750288869; x=1781824869;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=maF+V+ToxaqemVTAlk4O+Uh0WqdYu7r5MK1eqhfqNzU=;
  b=il1NY7PrYN3YVp8TGxR/72uJ6mqBR74MAppaKg9sqo0jypjrx1oACixz
   uYNPAptxBfKhfGvz0KRQirjKT7lMx1RwgwJX8LXm20N7ag1bSsKMODaTV
   JODzuBdO6+sOk8gE4SuALQ3iCAtoyi9pPrsRZXlVcmBX34aGpAoo86Aiv
   2EL0Ym17F6mRO4SJFb4TWP34XAsCmD67JX+Q44b+aUbSgtzv01/JmSNR/
   2xWo6CIymcS1enppbKgPgExaoHLaDFXlhBoJFydNngZPH0tSqXVs84PBS
   ebtLCaD6gwKcXFU8G94ZiJeyxEV+kAuWuSxi6He5dE/Klu9Bw8bBpVCe6
   A==;
X-CSE-ConnectionGUID: fT48XwJOSCaPhMlHXjHdkg==
X-CSE-MsgGUID: iY63Ip08SzmHD/3QFcODBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="63572797"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="63572797"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 16:21:08 -0700
X-CSE-ConnectionGUID: zDdTtiohRNqaUCGN6mlwQw==
X-CSE-MsgGUID: 9ZhUYwzERLycslNMdAAcXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="150972286"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 16:21:07 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 16:21:06 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 16:21:06 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.56)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 16:21:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fULKp/hYDkcCaO/TkmixLSZvS+ZChMaByPMYeE1xevMdsvQzjVnoGut8CFyN9pKJD1dinE0kFzVB5P6wNlkiYRxZLQhCh7iJbGMxvwOhJwHfuW1FRrnwH4vJqu+fM9RTWECXFdq0CoOQhrHUYR7BJDnHA0ghVnnsRVM9q5wprkKTnbuNugtLEoKES2TAbBLESqGjWMyPdXCaP1bQKjpRBlEPgoGMhFGBAzOk9X8hHs9juVnmE23uw4p3Smpu/xNXvo+zV1f+AgPioffaypKtNOHgeAVfJ0ccm7zJafOb7I8fPSilQ/ri8EeQbJGMcFt/ZZoE1xQrZWlbS3URIHPwFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=maF+V+ToxaqemVTAlk4O+Uh0WqdYu7r5MK1eqhfqNzU=;
 b=YIR31sK9PhatRSsoUpOeOUHYKf7tBvHp2BKs+FL3ivumn3cYA6bNy3mIAPfzvar7M5GvOEIkjiR4HRTXEe3Enx0Rpl9ZDHDW7zi28s6rhoUsyuRc/AYAvaoldRfwLG5Ee/X3DVqo/U8EfkRfWwMWFN0LEO4h9Wfmk82ISD5J//zP6TxhEiYgWvhRr3fekoQyM4GCtNtz6X9/frDjtnSSp18HNrXgYpsrSR/QD7PMfl2R9odEspU6aW4tZ2ReY4OZa2XOc2j41tFI2TtPmpHEz4bdnfvdWQ6FmdGC+41ObKy3UUmr5/jTNaI2keybH2X/8LnftanH5ATK5ER4lU3/oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH3PPFD6B8A798D.namprd11.prod.outlook.com (2603:10b6:518:1::d51) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Wed, 18 Jun
 2025 23:20:30 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.020; Wed, 18 Jun 2025
 23:20:30 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Gao, Chao"
	<chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Topic: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Index: AQHb4Em/yMlXy4vBpkewoE3shZA4ALQJjo8A
Date: Wed, 18 Jun 2025 23:20:30 +0000
Message-ID: <32c01f03f4971a76f1b7ef3634ee4e6c0ee5d899.camel@intel.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
	 <20250618120806.113884-2-adrian.hunter@intel.com>
In-Reply-To: <20250618120806.113884-2-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH3PPFD6B8A798D:EE_
x-ms-office365-filtering-correlation-id: c23249e5-72b5-45b7-b7d5-08ddaebeb7c7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cFJzNGlrNFpaU1pkTUZXdzhRdWduaHFmWGRDb2VTK2tRdTZHL0dRUyt1YkdV?=
 =?utf-8?B?SC82dklUK1dBSWhlWWtRcFRnT01DR2NHam9HMHVSV3VROGM3Z1Z5aGlVT2hZ?=
 =?utf-8?B?UGc3WEJLVEpsRXR3b3RuVDg1Uzk5R0oxMW96d01haXJYcTkwelhPcGFyYlIy?=
 =?utf-8?B?WnBQZC9LaHhIZkdjcDZSMVphMGluZEF0Z0dKUUc4K0JKNzNtZEcvMVJCYWtn?=
 =?utf-8?B?TVhiRkxnK0hlNThpV1FXK3VJZDBEaVZnZEN6TUdZaHZRcWl0RmtrT2p4Uzl5?=
 =?utf-8?B?ZU5ROHByVUJoVXNsUmozWmltTEVDYVg3MTY3Njc4R2xXLy9lVExpU2VEK1BS?=
 =?utf-8?B?NFIzOFFQQ0lxM2NJRVdQbDJEd3pFam1DUU84OUxodHRFd3VhdS9xaytzL3Zy?=
 =?utf-8?B?QUVQakNkVzVDc2Z1cExoUksvS3FGSWhlbTFIOWtYdWVHOXU5endlSXB0L3B2?=
 =?utf-8?B?Qkp6NGd3Nk1EeVkzeWFtRWJtcm1aeHNPNGpWMnRxVlVDL3pTZFRPRzd5SE8w?=
 =?utf-8?B?cSsxaGRyNzBlV3hIaTd4WmZsUWtjdHhmZmQzV3ZhdkhBbnY2OFpRWFFUTnpP?=
 =?utf-8?B?Yjk2ckM0V1M3ME9Lbkh2NFdNUVlJdmFocVoxU0tXNlYvS2FNSW1MbkZvREc0?=
 =?utf-8?B?VUlsS01takluVUxuS3B2RTBCSUlWQ1FFKy9yRkpFOVRHbkRKSW53THpuTkI3?=
 =?utf-8?B?ZE55NzQxclo1U1FCbnBzUlowTGJLdFUyRFpDQVZXbU9tZmlySWM1WEprRlNY?=
 =?utf-8?B?ZnZDaXM2dHkzc3BFcGJ4OFlqNkpldnA3Nm5pM00yWjQyK0ptTkNQSDA5dm1u?=
 =?utf-8?B?cHpuTWpMQWpCcjZVOG5Dc1FwK2pSQ1EramoyU3ZwZUtMZzlZL29WMVFYcXFP?=
 =?utf-8?B?WUNKcTVBZ2c4V1dXaGJ6eWNKd3NQQjZtWHdFWXZSa1gxbndDVEJWL2t3NkNG?=
 =?utf-8?B?RFBDM2pKUENKT0dJcUF5bEhIWHN4UDNEY3J0RHhRR1pyUUk3aENweVg4dVdu?=
 =?utf-8?B?RkoxNUI0WUdLbXcwMmxuUFZCZmo1U3FqcTRpZkRyZFFPdXlDRVRDT3BpdXNJ?=
 =?utf-8?B?MTAwajNBN0l1cnFsWncvb28yVG5CdkFyQXZObHpqZGlvYUJyL3NSaHNvT3p3?=
 =?utf-8?B?d2NXVzE0ZWlLYnJHZnI1Q3g2bHVoRE1uTVVEbFdJNHJ5Z2YvVDNObURURWZ2?=
 =?utf-8?B?dWkwbFJJdGo1L0gxSEQ1R0RKOGhKREFDZFZQa0VCR2NnVStLT1VULzJkdzlu?=
 =?utf-8?B?MG85MC9hVlhsUFJsSE1tc0s4SzNZTGg0aFozK0pxbFhXWGR4MEx0Mzg3WXZi?=
 =?utf-8?B?QlNQcUV0U0RnM0dpNVRvTHB6MWU4YzB6K0JaM21QbUVrcEcvZUhhTTZGaU02?=
 =?utf-8?B?d1IvaFhSd0FoQm83WWFzS1MxODMyZE0xSm5QSDFmUW5ZWWc5ZFBQTEdhS1ZN?=
 =?utf-8?B?bHUzSC9UTFQ3akJoWllpZnZsa0ZqalorKzVxQzZiNEl1MWNLamZxeGMvRzJB?=
 =?utf-8?B?OURIYW1KQmR5L01UR0lvY1d5N2RnaWYrQW9ONEVUczFDZjVJck1lcjBERUt2?=
 =?utf-8?B?SHJqcVdwUGVkdncwQ3NkVk1TMkppUkJqcTkzbnFqSnBwMTk5T3VEaTVHem1p?=
 =?utf-8?B?UWhGUnE1b2tHaXNWUjRnZXRnOGRGMGdmSWVzTFVQaHlUV3ErRmUvZHBmVlBW?=
 =?utf-8?B?M3l5bkJveDBROWQ3SlZDZW92QkFYZlJKQnVZTG95SmFrS3ZpTUcrRDczUitD?=
 =?utf-8?B?V3FWY0NjaVNRUStYUm5zUUY0WnAxcWhKMU1sSVlaNXZ0ZlViM0oyUkY0MG1y?=
 =?utf-8?B?aXhWeEJQa1gvZ0ZvK3kyZ1d6S2tWRVg4b0tLUmRZZm5neWxkM3hqNktneWVj?=
 =?utf-8?B?eWJKb09nRjR4VGJoNWprdHYvWW13bTBKYXZRS0thNTMvVU96WTZpNVpXZU8v?=
 =?utf-8?B?eHBWbGc0UnllM2p3cFlCd0pWQmZvRmExaVhxVCtnZ1dYOE1FQ2hpTHpGNnBj?=
 =?utf-8?Q?KhiNNxEn8oFBzNokYLjoFICjJIILI4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VE40N3BLWnhPTUZFTm5LOWhaNVA5TDhpWURZTFlRWFc5UHRLYk5Wa3doMjVj?=
 =?utf-8?B?MGE4Y3RvTjBHMGZ1T1lTdWc4M3poYnZuTjFuek1LTjZYUGRicy9MUHdEeTAx?=
 =?utf-8?B?dllhYnk0RXBETFhDQ241d1BOaUNlc21LMmFJNjFRcWc5a05lZWdmYURqT2Z0?=
 =?utf-8?B?dmlOaEw5R3pXSlJUVWNYTGRsL29QYkVrVmZEdG1NaXdFS2VoKzk1ZWNvcm5U?=
 =?utf-8?B?cFpMT0ZIL0JwUUg1UTdNS1o3LzdaTkxPTURxaFU0UHFYcVNZRDhtOFpHRkI4?=
 =?utf-8?B?dHpnbGVzdGRBbnhYN3NQeG1OU2xjV0Q1bmh3ZTVrMlQ2Q3FWWkU1MkluVEhR?=
 =?utf-8?B?Y28yN0ZWQnpVYnBlcjhlcE1uQlV5TjE3QzJZaUttMEJPRms3QlpIR1hHNmN6?=
 =?utf-8?B?Z1FkK255bS9SMHpzeTRpVEtTN3kydCtmdnkzMGdmOTM3TkFmNUEzMnFmRHha?=
 =?utf-8?B?K2dDMDVick9xN2FjRTZpaUR0eUlpSnR5azFwUjUvdFl0M2Z2OFJpQkR6RWtV?=
 =?utf-8?B?OTNpcXRqVi9BS3U5eGpqTG9SYWE4Q3FCYnQwSGVUNEtycXhTUnkwN29mdFdh?=
 =?utf-8?B?QlB4L01pMFNPWWlsaFp3cHBYeEJtbDF4a2dRbGpJUkQ0bmU3TSsrL040YUhS?=
 =?utf-8?B?UnpQSXpDNGpKd21QY0lyeTlUa1BiMXdkME5RUDdwZGRlbCtzUUhYRjlkRkNj?=
 =?utf-8?B?aWVDZC9YVjY0MUNmR29iLzNYRGV0WmFVMytObXlmeXh1bTMxNmI2S2M5QW9X?=
 =?utf-8?B?bldHUGtNK1Zia01lZFY2R25UUDUweFhtYkxmVzBYZXh5R05uWDN0enNNa2Fk?=
 =?utf-8?B?aEo0SW9Rck1rWUZEOHhEN3JCT0hmSThqYkdhZWM5cUVLb3E2aVZMaWdSdUhn?=
 =?utf-8?B?eGhSblp5Y3lzUFQ5SHE0VzhuREtqay9UcDFwSzBPR0VoQzJtVjRySjlIVkFj?=
 =?utf-8?B?enZVNmJDQkpiN2xacjRzV0cwQXZEN0RqZlBvdnlsRWV4K3ZpTnlvMnlEVjRn?=
 =?utf-8?B?MHF4cVF1SHlucGd4bzRuS1FQdWVmZ1F3NU9ZTG1TaCtNeWFBeDZMMTRuVk5Z?=
 =?utf-8?B?THMrTS9ScVBlUU1OeXE3ak9ycXEvcjdDbVMrbExVWmhTVTUrUCtMdU1DY1hH?=
 =?utf-8?B?aDZRNURpMkNkRWFYVEJEbUpvaEw0S1k3Wks4S0c4YmVPV25BN2dKQVYzSGIr?=
 =?utf-8?B?dzUvWDQ1ZG5vcEsweDVvNzhnYmpsT2ZRQ3NaeHFKUER2eTVKR05yc0x6dnZj?=
 =?utf-8?B?dDhqSk9xVVpxN1BoTzlPbUZZZzY1OXAxZVFJdGliY0Y4VCszS2p5NzlWVkhL?=
 =?utf-8?B?bTcrOC9nRWx2UFBKVWhuTE5aNTdzeENkZE9GL0hycTloSXhyOU9LK1RLRHVF?=
 =?utf-8?B?QXI4bHByWTVhemZjZTkxNjNRVzdzV3hlTVFHY1dpUzY0b2hDRHZodEdmdFA2?=
 =?utf-8?B?aGlSSENleVcyK0Q5bEdBT0RTd0taMnVzM1Y1dk9DenZ3eWJ6S1ZzQTFPMFJa?=
 =?utf-8?B?RlNqUWlFM2JFcWt4dnY3ay9GMVlnRzUrUlhydW9UdmwxQkl2blVEaDFHdFdJ?=
 =?utf-8?B?T2ZLVmhkMG5uUEsrb0JKRW4zY2pHN3VGbngrODE3Nnh6ellXQzhhbDBnY0VK?=
 =?utf-8?B?TDRDbytqSXFrQVJqWnRvaXRoeDV6TWVzSlBPUkhqQWtlUWQvTCtGWE9aS2pW?=
 =?utf-8?B?dkNXYzJMeCtISTVMbEovbStCd050NFZlZ3VCWWdVMlBmMU02OFE3SktocWRV?=
 =?utf-8?B?eEx6OWdTeEwyRFNZMnI4dUV5M0VKSHZHcmNLbzNCaEQ1UXRDaEd2djBOQ3Nx?=
 =?utf-8?B?c1NXd2NhbFQ4c2Q5ZWFkYU8rL3NWeHdYdFFhM1RkcDdUYVRJZmM4bmc1YzhD?=
 =?utf-8?B?OUo4KzhFL0VFTm0rZHRnOGlqY3RvV3BTZ3FNWitPenBUREg5L1kyNzBBdENy?=
 =?utf-8?B?dTUvYUg0ZnFuYXhVZHBjcXFwZnVXd3RLTE9BazMySDBJRFpnVm96QmhoSDJK?=
 =?utf-8?B?RUt6V1krd09xbUxRaEtUb0IrU3NVengwM1lVWDY4N2l1YjVTeVdidjkvWEYz?=
 =?utf-8?B?dzhuYjVRajNpWkRmWDYzUVlEYkljRzVwK28vU1JLTHBkVThWaW0wVll5NDgz?=
 =?utf-8?Q?6aZqiNxB+r0EnuDLaqKbFUqD4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F022394C73830841A6552B16225B3F72@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c23249e5-72b5-45b7-b7d5-08ddaebeb7c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2025 23:20:30.6783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t5oOSoh/qrrfpTSpASbovj1g/GkLZUN9iMkFfzCQp/V069LSoSZ/3ADRy+ARM3D1N/hAyhb3c5ky0c4gzCl93w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFD6B8A798D
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTE4IGF0IDE1OjA4ICswMzAwLCBIdW50ZXIsIEFkcmlhbiB3cm90ZToN
Cj4gQ29tbWl0IDhhMDFlYzk3ZGMwNjYgKCJ4ODYvbWNlOiBNYXNrIG91dCBub24tYWRkcmVzcyBi
aXRzIGZyb20gbWFjaGluZQ0KPiBjaGVjayBiYW5rIikgaW50cm9kdWNlZCBhIG5ldyAjZGVmaW5l
IE1DSV9BRERSX1BIWVNBRERSIGZvciB0aGUgbWFzayBvZg0KPiB2YWxpZCBwaHlzaWNhbCBhZGRy
ZXNzIGJpdHMgd2l0aGluIHRoZSBtYWNoaW5lIGNoZWNrIGJhbmsgYWRkcmVzcyByZWdpc3Rlci4N
Cj4gDQo+IFRoaXMgaXMgcGFydGljdWxhcmx5IG5lZWRlZCBpbiB0aGUgY2FzZSBvZiBlcnJvcnMg
aW4gVERYL1NFQU0gbm9uLXJvb3QgbW9kZQ0KPiBiZWNhdXNlIHRoZSByZXBvcnRlZCBhZGRyZXNz
IGNvbnRhaW5zIHRoZSBURFggS2V5SUQuIMKgDQo+IA0KDQpKdXN0IHdvbmRlcmluZywgZG8geW91
IGtub3cgd2hldGhlciB0aGlzIGlzIGRvY3VtZW50ZWQgYW55d2hlcmU/ICBJZiBpdCBpcywNCkkg
dGhpbmsgaXQgc2hvdWxkIGJlIGhlbHBmdWwgaWYgeW91IGNhbiByZWZlciB0aGF0IGluIHRoZSBj
aGFuZ2Vsb2cuDQo=

