Return-Path: <kvm+bounces-61249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 78EF4C12293
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 01:28:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 47F444EB5FB
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C93A81E2307;
	Tue, 28 Oct 2025 00:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WB0fStvu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9D33C0C;
	Tue, 28 Oct 2025 00:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761611308; cv=fail; b=iGg0/WeJEeSz/ejSzT3klGJGewe4PeS0oFX4RMBTnKCNJIWQuMTZNb9Vw9YSUxONMGJJe/q+j66t507YwIrwAHTtiPYvWRRCzVoNnF0P0SdkyAL3CpEIY+8MEEe3elhqRyjozFj+mN4tmKYG9ySJ0+qHSTzqoxH6m9j61WpZ45c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761611308; c=relaxed/simple;
	bh=bPWSp7XC/xr2saCxW/Yi25O9klYmkOiKyImOIF5Cch8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ixVxtOv7QHu7kqQImjIcMD5qAyE/iYrzy8uQ8HJ5KM+uUbSw1LZM0YB3oSctW5/Z7c5bNheHR2uAiUUVsKMe5GOG8hRItB+O9kb+Z6jJV80O850wbD7i1f2pG0DtoJVclBNLRWMSFo+JlE/q12I1ulGk0n4ZRHPHPxk2f6KI6Lg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WB0fStvu; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761611306; x=1793147306;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bPWSp7XC/xr2saCxW/Yi25O9klYmkOiKyImOIF5Cch8=;
  b=WB0fStvuCz4KUZgoO/MRTYRZX+B6pBsZcD4gC9Bm4dZcDfuy3zD7+/Hf
   vPLm6Q6MNjRa4DF5mbd3y7VtFGuRPBY0BKpntKaOqfE+ZgRJ7EFijH1fW
   L2+XQS9ICgFqyoklEqKML0Dx3SNseX4E6US8CzsKNPmCCgptyYK1dKEah
   NeZnreULgGDvwHnqnkQxIhTWu55pb5uywgooDRqvvyPM7nfLqkoffUHy4
   YKzNYJkcjkwn64kLy4dw+tnHCDjxUpTShr+R9jyMeI7w0BTT+T0ckDHy5
   v6zV8ETJV2qkM2vzTeYs2/xJbp60+DYLMEvFWTSV9/WL7dHrBjf1hZkaW
   g==;
X-CSE-ConnectionGUID: QJzcd7weTMOJI9lHGTBFJQ==
X-CSE-MsgGUID: jvI7Ku2rTwK8R2ObGHbD+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74823424"
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="74823424"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 17:28:25 -0700
X-CSE-ConnectionGUID: ng+Qgn8rRVGDLOE5uKLfQg==
X-CSE-MsgGUID: QSomKNdpT/+U6TWHG4G2hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="189558851"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 17:28:25 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 17:28:24 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 27 Oct 2025 17:28:24 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.65) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 17:28:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wZatyu5fUZvbwwhVFkEmwY8wFduxHT6RtM0KfuEP3bQ2UG5+NG4LCGD8BVAjnQ5xh38pCrpeLgYocsbXdHlFPz51rfnEba3a3DB6HdzC4le7WO5fI8RCi+3shQkZmpEJu84nYaKPLr7TudSn94J7hkjAZTe3ebmrnmIYr6+g+oy0S71GOaHLDIHOKzPgkj6IRySwkmVHoHJjyIwDLOQbGiNgrzUEEUzdNfCEbCs5edP4vXB3QCXKzMLFGCmi6wpdsw6/MI5Ok6cbT3okwzPTJ57g8koWnI1LCXxAO9siAckoMJKT2qPTralwxVL2vJ2MYTbbcTijd/yMzrixOMqC3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bPWSp7XC/xr2saCxW/Yi25O9klYmkOiKyImOIF5Cch8=;
 b=bLL4k6RVTWO5gwA5Ron+crw0KpbHyUeND+w2IOL/t/nwDnWnbw4ApOV/7+iMCJG+AxnuYIl3FJfrJtkc2SkAgNKYndm+UzLNrxx29D5ZsDA98NWbQo6rCG9A9dD482VlqgrRGD9+OlrJQBywZt7p08BshxYyu3kMXh3kYRs/nuZFFA4kIxSzmBN+Zgp7ORTalZRmD60iRNa4dM4UmEz/7dyR3+ry+2Vktt/8f7hQ/caX09/riUg7HjaZ9E6nDWcysa9ccCcZhYVbc+Ogj3E80T40zlN/Hxl9isaYeO5nygBhCdsmGUvgQhej5LsWisouYYhA8rg8e9zlbgzlnmfOug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM3PR11MB8734.namprd11.prod.outlook.com (2603:10b6:8:1af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 00:28:21 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 00:28:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "frankja@linux.ibm.com"
	<frankja@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "pjw@kernel.org"
	<pjw@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "imbrenda@linux.ibm.com"
	<imbrenda@linux.ibm.com>, "zhaotianrui@loongson.cn"
	<zhaotianrui@loongson.cn>, "anup@brainfault.org" <anup@brainfault.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm-riscv@lists.infradead.org"
	<kvm-riscv@lists.infradead.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 24/25] KVM: TDX: Guard VM state transitions with "all"
 the locks
Thread-Topic: [PATCH v3 24/25] KVM: TDX: Guard VM state transitions with "all"
 the locks
Thread-Index: AQHcPv2zs83Y32BYWUWhhrWchNoLBbTWxYgA
Date: Tue, 28 Oct 2025 00:28:21 +0000
Message-ID: <55461c549803e08db97528127c29e092c597adc5.camel@intel.com>
References: <20251017003244.186495-1-seanjc@google.com>
	 <20251017003244.186495-25-seanjc@google.com>
In-Reply-To: <20251017003244.186495-25-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM3PR11MB8734:EE_
x-ms-office365-filtering-correlation-id: d88dfa2e-438a-4730-5d87-08de15b8e678
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?NU1sYjBvV2oxVXBLRjNkY2RLY0o3V2RsUnVTbEVpbFRrbmJ0SkRmWkFFYVpm?=
 =?utf-8?B?bXd4eTVjMzJTdWd1TnFYNkM3L1BXTGRFUW1Md0VoM0xrbEl3MGFrb0l1VFZl?=
 =?utf-8?B?UkpjV25yNTBVVDc2bUJkdGFCbUt1RHU4RjVJUDFSN2I2VjVUbXcvMGtldHlx?=
 =?utf-8?B?WUFGNlJrZUgyOUZYd2tFS2hnY1VJWjExYjgrSmwvYlZoWUs3UmJ5b01jOTVS?=
 =?utf-8?B?QzlZRmkvMnFTRGVBL2I1aDJ2eGhyMmJMTUN1Mm1EMEdrWU1raHc0Q2hkaDAw?=
 =?utf-8?B?OFFmVXpoYUpHZzJzRy80U29lU2dVMmRON2piM1RDNU44aXhFaFdnMkRoZDhY?=
 =?utf-8?B?cGg5YmNJYzJFZDllc3Z3dkpxeE9SKy9ncTBGdnNRQmpmRDhsYzYxeEJqaVpr?=
 =?utf-8?B?dmlqRTdqQVVXQW9CdW5UN1g1TXVRc3RzS2d0bGVwVnNLeDJIQzdzMWIvOWZU?=
 =?utf-8?B?dDlDTXR2NDAwcldyQXFHallrZFRqY3pjOXBNVHpOZG5PWkFVb29QYi9ISHZL?=
 =?utf-8?B?LzhobnZSTGIzY0hZUnR1eDZMNzRoREZOR3ZMRnJoLzM5eHoyUy9Pb3FFUVlN?=
 =?utf-8?B?RUZQN3N4RWVMUCtmQStKWElTeUF4MGpQSGlGNTJRcElZeFdtRmlHdFJ6TXM0?=
 =?utf-8?B?N2NlTU10bzB0SW9McmlYc2hqbnppV1Q3dGRFNFhxR25tRUFVYU5HMnBwUlRh?=
 =?utf-8?B?Z3JlUkwvbk9zWVBOMDNJSUI0Nm1wZ1JkbzFENmlKUFdkVkFsQ0MyWGNYKzlL?=
 =?utf-8?B?OFNQWTZxRjhTckJITnhiSkFldzNVZ21FV04wZG5UbDNPSUdEMGZyTUc5N1dG?=
 =?utf-8?B?a1pDSVFOTXVDak5lalkyQkFPRFdBRkpJMmhyS2Ntd0hmNzhKcTMzSnFzVFhP?=
 =?utf-8?B?L1Jkc0dxYno2UlRuK3lVMWtFcHZEd1kzWkRaM1c2VXVsMmd2Y2RmSUsrNm80?=
 =?utf-8?B?MkJCR1VFUk0vSDVqQVlpRFVyeGxiSldMRE54Q3JlaUtDc3lIK3dDdkEwQ1p2?=
 =?utf-8?B?L0RpRHI1L1c2ZTU4bThGeGlITHZZbDVRSTUxbFpYVDRXYUtBVXNWZmNPaXFB?=
 =?utf-8?B?QnNVNEF6M0lIUW5oamJNYVd4NXEvc29aSCtBWHczdmdhdFMrOUpSa2pJQ1R3?=
 =?utf-8?B?QWswV0EyQVdob2F2Wm56WXdLTWs4UGpEaHcvb3AyWllhUlVBclJKQXVZNk40?=
 =?utf-8?B?aW9ock9OVVJZUUlSOWpuMVZ4NThoMkhoSzNuTHR4bEMvaUR3NzZBam9pU3di?=
 =?utf-8?B?c3kwL2RYek9jckJTOEhNd2tzdXR3Z0xhVmpsQnJ4QWk4WE1SWDVIYTFoajhs?=
 =?utf-8?B?REl4bU9iYXR5djJpRGRuTUpxaW43S3B1QVBJSW5EQ0thWnNaYW44V0pxM3U4?=
 =?utf-8?B?MHdheTU4d0lzM1l2OXdyc08rbytBeEZxNndiWklkbmc2MGVXOHRVMGV2VFdN?=
 =?utf-8?B?U2F6djNXS0VZU2VVdUJ3bmVScHg1TFFBVjBFWWpHQ1BnVXMrZUkvVFErakkz?=
 =?utf-8?B?ZVgzdEl2cjBsMHZOTXVJSERyakd2YUZ3U2xkSXlhUW9zVjFGUkRzcE9nZWNB?=
 =?utf-8?B?ZzUyWjh4MFgxNTBYT2c0aXpVcnRicDBsRFh2elVQbDNFbDNrd0JvT1FENGRU?=
 =?utf-8?B?NWhpdk1rZ1IrZllwODQ5QnUrRUVLaER0L3VnUHRwTVVxYjhaTVVkNFNDMHdE?=
 =?utf-8?B?anVqK2lVdi8vSnlFVG51NUlLc0pFSU5jMnNoUER6NTJ0WkdzS3g5NDdSUmV2?=
 =?utf-8?B?ME9wWmJORGhpalI0MEgxY2d5TWZnL0svb1FxMEZaL2thZStQd1pKSU41T3Zl?=
 =?utf-8?B?US83MG82dElMZFkvVm5yaTFUK0lRMGJzcnEyWGxhMzNqVW1uZUFDMGxJMnRu?=
 =?utf-8?B?bzNCT0RjQnRyblNTTEZjODVwekxjbDVIa2tFd1J1bDUvckNsRThYQXdtVTdI?=
 =?utf-8?B?OGFEbmxtK2QzSHdDVjRpd003ZzJaSGpjajZ3UjF3bmNxK3h1YkpCczZ2bFZV?=
 =?utf-8?B?VEh2VE1waEpmb29NOFdnVCtSWTlvcHMxVDhKOHdoQklTSnJuZW9BTVhGUjI1?=
 =?utf-8?B?VUJ0UzBTTjdzMXdZU3BHSkZRcW1JS2VjZkU4Zz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UC9ZcmR1ZncxVHBVeGZ2TFNqZTJUVW1JWkZGVHdmTE1yazkvY0xMV1ZpVEQr?=
 =?utf-8?B?bHFjNDFTSGZabUFLejNmeVE5d0F1QytPRHFNR3FmZ0RCNGs0WTdkb1BZNDRB?=
 =?utf-8?B?aGR6b1dkRTh2dFplVk1zQnpCWkFMRExCeUlHWU5pWlZKWDJCSXg1WmhKY01F?=
 =?utf-8?B?TUt0dktuYjJvb2RIV2treWxTOGxCRmFDWG5tT3libllHdnlMcEFYdHptZGxv?=
 =?utf-8?B?cVpHZWxVbWRNT0VUVUozZ2Q1WUVlRXB2VVVOaGtNdWptZ3dJdzd3TlFEa1l4?=
 =?utf-8?B?dS9ESG5rd0FLZ2RuWnZ5TURxNU5uKzA1NkVwMFYwRW1RTjhNSlBUZlRNcGI2?=
 =?utf-8?B?elBWSHJjclJuVTV3QmRYZlJ6enBtb1Zpb0JJVXhlWE9ROCtSLzg3TDlwaDA0?=
 =?utf-8?B?QUtCTWt4bVpTaUFSdTBDQVVFTkE4aStNK1gzbnRhN05OcEJXbTM2VUE1WjNm?=
 =?utf-8?B?UGRwcWgvYy8zUjJkT1NuZ2xpSVp5Zi9UL2RvdHJTc1RPQTNJTUxRU3kvN3BF?=
 =?utf-8?B?UVpXSTNmTWt5b3dReDRlaitYS0xzZDlHZkRtVFBLVVlKbjFpV25TR3ovUXFy?=
 =?utf-8?B?UGErdEdMcDNRR2FhallyVzNMYm8yUk5zbDFuUDI4Ly9iVXhKWjJROEV6VThm?=
 =?utf-8?B?YjNBLzEyWmZqOG5RbGRKdjNpUU1aNWhBWk5GVFdWNmhsY3FRVW02UjJ1UFJU?=
 =?utf-8?B?ekkrS3Mrc2xJOE81N2w3TzV5OVhUbmNiOTFCQkNHZjBKQUZWVFFSUGZGRzlv?=
 =?utf-8?B?dVFaMGo1YnNPSWg1cFQwb2traFR2NGJqM2ZaQ2JvamZwaUloaUtRemx1MC9r?=
 =?utf-8?B?TVlVSi9NQklDYUNlUmU2V3FzQXo2YjJzaHJQVENLRzMveGdTU3pSdG8zcXJo?=
 =?utf-8?B?a251NFV1U0hHOU1mR1A4Ym5lNlhnSW9XVXB6dm9mYjdXcXp4bTBmZ2hacUZZ?=
 =?utf-8?B?MGQ4RERCODI5RVhsZnpyUDJZeldueUM4MXd1ZFU5RTgrbXhScHlqV2pMeGJT?=
 =?utf-8?B?bzc0MC9jalVuNVQ1cHBpalpFcVZMWkNJaEdxU1BaYnNWeHpUY2xzYmh6YWlv?=
 =?utf-8?B?UEpQM1FrUjF1U252QjhqbXFjcGNXclpzY2s5TDdMSTNtZk9LR1J6endFejZP?=
 =?utf-8?B?TVl0OWFsTEZnbHhWT2hRSXVhemkwZitLNHptVkgycUFTWkREeEFmdTd3M25t?=
 =?utf-8?B?ajdRTTNEZm9TYUwzTVhqbzZ6cnZHY1lLSzdWT2pML0xyYWYvcVBwS2k4SXhn?=
 =?utf-8?B?L2gyNGZuWjhwVFJGelFaSzBhd29xcElINUxxc3ZaSy83Qnp2MkZpV0VTdjNl?=
 =?utf-8?B?MTZEUllDTXNSSjRiYW03UXJXUVpLL0JXUXd3VEM3QzMzeUd1VjhpUWl3N1FI?=
 =?utf-8?B?bnlhMkZKYmZNaVB4MVc3YnJaSzFFa1N0ODFSbW9GUEpZb1JyZEQyeUV4bDdL?=
 =?utf-8?B?eVpQb0JtRk5rS3pvdTVjT0dEMFFDQTFuUjdYRzFNSzU3NElQaFNvYUF1TnlP?=
 =?utf-8?B?VENjWXlCQ0JWUCt1RHFWQkpwNjVDTXpWbWFwWm8yeVI0Z21SNWF2Q1BzNnZ4?=
 =?utf-8?B?RWNVU0pNRzRFZmVMa2JEWXBEQ2hzRjJpN2JML21JNkhtRVZhVXdJMFpReGRa?=
 =?utf-8?B?cVNXSVBNaHN5U2NvL3dYYU50eGd6ekdIMkNiZlNFNmM2ZlpRMXpOWkVOUHFo?=
 =?utf-8?B?azFEQ0tsdWcrTVFkeEtYY0ZkWWxQZzVka0ZRWlpWMGNtS2dGaTl3SmxOamov?=
 =?utf-8?B?eTA1RW9QN015akRhZHpDalRPTkxxMEJ3REs2bWlXYVFINE12cXlwMXZEVzJF?=
 =?utf-8?B?WndXeFo0WWhSVUtSV0E0MXRsZTBCcTRuZ2pRUk9ONUxZNjh4OFpxbEZyd1RT?=
 =?utf-8?B?WkVQWFRBUUNrbXl3QmZDNkJaTTc2djQwU2dXUitielpmMHB2Z2QxSVRpTU4z?=
 =?utf-8?B?SElRSEs1SFdKdEU3d1FkaDlvWXRDbmVMWk5FNmEycktHdlluOTJOU1pPaFU5?=
 =?utf-8?B?Q0hsTFJpMElRR01qQjRyNXZleGJ1SnlRT0hyUFVSNFdJK1ZXZDlFc2JqenhV?=
 =?utf-8?B?WVovSmZ5TkduRnZORE9VV1kzZEM5VjVlSGgxRW80QWxWT2E4cXlpQ0pwcEZ0?=
 =?utf-8?Q?bGkzTnCdXfZ1PGe79+QTWQBeM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35B5F115630E60449993B83C56B15920@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d88dfa2e-438a-4730-5d87-08de15b8e678
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2025 00:28:21.7815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pm/UP0vqp+LTGiGaqGitIsfdYQHYIhAo9Do+fNfmlYBPegCbNBWmZZmKmJpBWqc8g38gGjb2/AZqvBqueqWPfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8734
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTEwLTE2IGF0IDE3OjMyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBAQCAtMjc4MSw4ICsyODI3LDYgQEAgaW50IHRkeF92bV9pb2N0bChzdHJ1Y3Qga3Zt
ICprdm0sIHZvaWQgX191c2VyICphcmdwKQ0KPiDCoAlpZiAocikNCj4gwqAJCXJldHVybiByOw0K
PiDCoA0KPiAtCWd1YXJkKG11dGV4KSgma3ZtLT5sb2NrKTsNCj4gLQ0KPiDCoAlzd2l0Y2ggKHRk
eF9jbWQuaWQpIHsNCj4gwqAJY2FzZSBLVk1fVERYX0NBUEFCSUxJVElFUzoNCj4gwqAJCXIgPSB0
ZHhfZ2V0X2NhcGFiaWxpdGllcygmdGR4X2NtZCk7DQoNCklJUkMsIHRoaXMgcGF0Y2ggcmVtb3Zl
cyBncmFiYmluZyB0aGUga3ZtLT5sb2NrIGluIHRkeF92bV9pb2N0bCgpIGJ1dCBvbmx5DQphZGRz
IHRoZSAiYmlnIGhhbW1lciIgdG8gdGR4X3RkX2luaXQoKSBhbmQgdGR4X3RkX2ZpbmFsaXplKCks
IHNvIHRoZQ0KdGR4X2dldF9jYXBhYmlsaXRpZXMoKSBsb3N0IGhvbGRpbmcgdGhlIGt2bS0+bG9j
ay4NCg0KQXMgcmVwbGllZCBlYXJsaWVyLCBJIHRoaW5rIHdlIGNhbiBqdXN0IGhvbGQgdGhlICJi
aWcgaGFtbWVyIiBpbg0KdGR4X3ZtX2lvY3RsKCk/DQoNCk9uZSB0aGluZyBpcyB3aGVuIHRkeF92
bV9pb2N0bCgpIGlzIGNhbGxlZCwgdGhlIFREIG1heSBub3QgaGF2ZSBhbnkgdkNQVQ0KKGUuZy4s
IGZvciB0ZHhfdGRfaW5pdCgpKS4gIFRoaXMgbWVhbnMgdGhlICJiaWcgaGFtbWVyIiB3aWxsIGhv
bGQga3ZtLQ0KPnNsb3RzX2xvY2sgdy9vIGhvbGRpbmcgYW55IGxvY2sgb2YgdkNQVS4gIEJ1dCBJ
SVVDIHRoaXMgc2hvdWxkIGJlIE9LLg0K

