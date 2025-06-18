Return-Path: <kvm+bounces-49923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CE84ADF9F4
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 01:58:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFEF21775F7
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 23:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BFF12E7168;
	Wed, 18 Jun 2025 23:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JLe7a7B2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4153085DF;
	Wed, 18 Jun 2025 23:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750291100; cv=fail; b=EKinJ7Q763A/u/H4yrScoB7QxlhoLrG7VorGPr1EkpLStbsJdERTfJFrfZCt7nqYTpNT9MCqix1hXuRYq+9v5vzLVW2KsxMA1yneYZgA89A0SMCSW7wGngIgAsMnZSb2u27S2um+WuP+7wIK1bDlk7N39gkb45AB2UYSaklzhDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750291100; c=relaxed/simple;
	bh=1Je5f/Fo60kgqvZooKWX2RDX5hq3TSS2ImmAKeiPt+o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fITmiaa+GdonHpkeKZLB5KKIYVqL2hUSf842N6Y9keSRtoG33cU1252DhbajHun3V/03vDNDb0uPJJzjOhvDFwMWLIh6xlEyF4DvNSl5wZHSAt5ETrBeZMR5KPDYZq3qOHA9ov4Ohbd4IY9yt33ob7+CmpHOqwFddRvqIA4RT8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JLe7a7B2; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750291099; x=1781827099;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1Je5f/Fo60kgqvZooKWX2RDX5hq3TSS2ImmAKeiPt+o=;
  b=JLe7a7B241rSfAqnHTxYxqBkkMAS/VtNODF5sShJKai/63Ne9ta/so4w
   /fXwgcajN7KXK0HEz6E+7LAolC+8NSX2HeqMeW9B5H8em4DLw3xlMQ7AW
   4A/eZ6tcPaowt8phBhMBL/tS+P8DUUdV5khKhZDTZU/2QFAJ9xsTUJNYl
   +AA83LltnAVEwgERpFTTmhevKXfxr1xmYW82q3YLQZ9A79E9Djx1oc/9a
   HHKGxwiJ8jhQsU6YiusfOVFAcAXui63g+htJnp5g6dvKv9bq8shgd/6sm
   OujPuQnAtzf4u3PCF71bLbr4Fa4X7FdUyIMCmL0tYOy7/TChezaKH+kZV
   w==;
X-CSE-ConnectionGUID: 7jIQ+IkDS3aKS0VDBqgj2w==
X-CSE-MsgGUID: isehjAl0QC6X1Tw8HhET6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52678155"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="52678155"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 16:58:13 -0700
X-CSE-ConnectionGUID: jaZVhYwvTXuOTpawh9/w0w==
X-CSE-MsgGUID: TjIrZY/VRZ+/hq+ejHVrKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="173919357"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 16:58:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 16:58:11 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 16:58:11 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.88)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 16:58:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WJ8QzJImkzntzW1GeFkwdvxG38yRqZHUGpFZs5IVl346PCH2/rK11HYC15ePdXqI0qsTYH1Sm6MieUFyNPBOFYVBzYY60II5fkL0Ziyw2u0mRRKTmFH4aPvjUERgqayDrRJyIJORlyVYV4ELM/U1PPaWWdm1+RTsVM4tHrvzFxvfrxVLsZakBknIys0bb8Rwy+kNpBfIn7viiOSZrIdJTbYSI5A1Jth4sv4+pHwXpaJfkoyYEvTVQNrB2zcGhxFB7221ob+AlLtWZyVnL+N452VqRs9MOmajgDWjulfqlfmQEqy52fU8tKTDwhNH1yBXNGmLHdl8ZGUnIOqhCS1wSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Je5f/Fo60kgqvZooKWX2RDX5hq3TSS2ImmAKeiPt+o=;
 b=Ocw6ZgT665kdpIjLHhOVFIVXYPACnSr3REskINcToNpxLucc1xhPSloigcD6HvSbuB1KbU0ywNMezN+Nw1zfJIGiSn50PGws1JYdzmCe6s2waNbxzCUp0WIDvfP6V3z4lxBpAfaZGtvYXFITHLMgiyP2E9Cy4Va0oj9zilu6x9gLyaaeweDREGKTSuwupfvxBYFzs/nJwJ6UI/Q556V5IvDe2850lZBt9KBPk9npA24mTUm9YVo1ccCAFfoEfMcKqXhCuibb9Ue2QkCJUHQ2GOo4X6wsPOsB+ebclX+jRjCvGSQRhkC/J7H/OjpfeNYh/5J6cRpDUiLdo/478XOUEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH3PPF383C22AA3.namprd11.prod.outlook.com (2603:10b6:518:1::d17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 23:57:56 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.020; Wed, 18 Jun 2025
 23:57:55 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Gao,
 Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Topic: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Index: AQHb4Em/yMlXy4vBpkewoE3shZA4ALQJjo8AgAAFPgCAAAIegIAAAxkA
Date: Wed, 18 Jun 2025 23:57:55 +0000
Message-ID: <96d035a19e04e2711d67716b9548a40793d549b2.camel@intel.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
		 <20250618120806.113884-2-adrian.hunter@intel.com>
	 <32c01f03f4971a76f1b7ef3634ee4e6c0ee5d899.camel@intel.com>
	 <SJ1PR11MB60831B85840BD194CBFA6CBFFC72A@SJ1PR11MB6083.namprd11.prod.outlook.com>
	 <SJ1PR11MB6083E80CEE14BA99F7A0E237FC72A@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB6083E80CEE14BA99F7A0E237FC72A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH3PPF383C22AA3:EE_
x-ms-office365-filtering-correlation-id: 02beddc6-411b-4090-c82b-08ddaec3f1ce
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MHNLQk9EM2lVOUloQnloTlA0bWxPOHRoVFRlU3ZuYU9EV3BQcEExNW9WK0Ev?=
 =?utf-8?B?RGI3UFdaWTh4Y2RTK21DcDc2MDVNbUkzV1BUTmlRVFJ6NzVIdm1wRXZIZTFs?=
 =?utf-8?B?eEdLUTRSV08rTEVTcThQSmVaaVpWdSs1cDYxdzJ1L3hPeE11ZFFKWnIvc3lI?=
 =?utf-8?B?Y2hST0VVY01OSmxqbkdrNG81aUpiQ1ZnQzltM2tqVC9lUU9kZTlFcUJKQzEw?=
 =?utf-8?B?elc2V0taM0lrVlhiSFA1TURlOUgyLzlOanFpZTliNGptQktOemlRWFkvSXdl?=
 =?utf-8?B?NTMvU094UkN0d3dWQVFnQVh0OW85N01wSTQvUEF0UUlIWGZnQ3Bzc3UvODdE?=
 =?utf-8?B?UE5nNksramxVYlN1bGxWaVFET2Q4endmbjErakc1K25BWFc5ZTVXVW1YMEJo?=
 =?utf-8?B?dXgxQ3dTWEZKRUNrYU5qQzd2YW0wTlkxT2dqVHI0b3g4N2hJTHdBUUhNalMz?=
 =?utf-8?B?MXJxQVQ5N1pyMm1SaURKdklxczQ0QXE3aHgwVWZNcVNZUmxsOGdRVDFvdXBD?=
 =?utf-8?B?a1llRUgxdFprTDdIeVN1UXRlYVdhdmc4RzhMeWJIKzlCV3RidlNHNkNhbDRz?=
 =?utf-8?B?UHJ0NU9ZZkVGSE5iY3VmSjc5OEtCSk1xTXYxb3p5R0VwYVdJY0F4T21MaXFT?=
 =?utf-8?B?UHRKUE9LZnZHajdoc0xiR1MyZHI4ZUU1UEc3T0RnWnU5UTZneVcxcG9HK2lv?=
 =?utf-8?B?OC96M2FTdE1Fa09yeHpaNjMyMWZURHgyOHFHZTZGamx2dUVsa3NlRzZaTTRC?=
 =?utf-8?B?UTBGK1FMek9ONkJuakJ6OW5FSkFQdTl4OTN4dGV0L1RQU3FKeUN3TXR4QkZ3?=
 =?utf-8?B?T25EQmJmTHRlTTVhMDVnMzR4TVR1VHVqVU5aMjZQMFRxeFJWcTZ6YitzL0w4?=
 =?utf-8?B?cEVtTEpkb3hqdkpnZUY4YlZXRHlteUlUSzhYd0R4OXdLU05Ja3h5NEFyZTJL?=
 =?utf-8?B?cXJaWE5Vb0cxM1ZubmVqTUR5VmV1WUNPdmZXS2VVUEEwY0ZKcGpTTEtESHNB?=
 =?utf-8?B?bGhWZkE3SFUrZHhUTnczYXR4b2JVdm9qaXltaHNrTDVMNlcrVDdoMXhVUlpH?=
 =?utf-8?B?MTJ5eEttYVRWMlIwSmJPNzJpeTQ3aENNSXJraktMSDhnYm1xcnZWaVphUzZI?=
 =?utf-8?B?UWhpR3pZSkE1bG1WdWRlQkk0WFN5SVFOZU91N3U5L3NtNmtIVmxWZFl2dG4r?=
 =?utf-8?B?Ukdndi9YUW9jcTZVTnQ0eTdlc0RTYktZSURkWWMwb3hRd2FtaUtjZFlBcDZs?=
 =?utf-8?B?cnRGdE1ENTRMb0h2NHBMck1oVkF1elhIZlA2aThhcXhBdnk1Mk5ZVDFWd2lQ?=
 =?utf-8?B?TW9uNk91QUtIei9BSS94RUpCL3VNVkRpL09xMXVNV3hPSFJqZnBqRzNQVzIy?=
 =?utf-8?B?WFdvMFFwUVV6bnZwQUNZSlUxZ3VOUHdxZEhFOUlDL0Fsek1VKzdEWmZudFJG?=
 =?utf-8?B?bVYvazhnVytRUjBkVisxWnZMaWVRSHNaL28zRnJ6bVhTTlpSZTFZMXdsNHlD?=
 =?utf-8?B?ajNHc0lGT0pqbW9QRjRJN0ZuSzFCS3JEQisvT1E3TnFsNVV6MXFNNXc2NGky?=
 =?utf-8?B?aW5lYUFTQ2Y2YjVrV2NwbE8yZ0U4NS9yT3JRM0w5VjgxY2RVMDVqdnVzYVZu?=
 =?utf-8?B?RUNPanFWVUR2cWN6UE5MMFhPdzVxTE40RUdLQ1MweG90aUlVN0ZIa0k2Zytp?=
 =?utf-8?B?elcwYnZtNGZzRWExKytuV3FPRGhFWWIrS1B4VU4rRHFUamRnb2MrQmZ6eks5?=
 =?utf-8?B?VUZuRitvYzg0YVRJWGhZOHRCUHJFU2N3UkNyM0c0L1hJWmRaWjR4UlN3TG1H?=
 =?utf-8?B?T3hUSU5nRGVJZFhpZy9yTE5hU29Kek5CamlmK2h5ZUhCQy9WODhtVGk3bzl4?=
 =?utf-8?B?VTZ2bk5RQk9WcW1jOFhuKzFxN1BTM0RLeHFTOFhlZjMrSDA4NnZ3azlMM1hI?=
 =?utf-8?Q?QoFHMypmHC4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3FCTGl1bWtSZmZrbW9TQ3BTL1VwdnBIUUVEQWF5MUFoUStyc2NRWDBJcHk0?=
 =?utf-8?B?SHg2R1ZuUWxFZ2RXZjVxeHErakdxckhTMnFIQ25wWnNSTERNY3AzN2Qwd1RV?=
 =?utf-8?B?NkgrRlZib01veitYR1cwTy9qeHBNbjBFRlJrVGVQNGxWZldFYjZ2TllvME5o?=
 =?utf-8?B?M1h1OWc0T1FxV2E1bFl1UlJoMUdIM0JETGMzZ2wxSW9nNEJ2RFYzV0h5d1JC?=
 =?utf-8?B?RUg1WGt5b2UrV1I4WWVrSC9FUGFSU0Y5ZkY3Vmo3c0cvQlY0V1JVTzJSdlJF?=
 =?utf-8?B?NUMxWHovWXZvR3V3ek8rdXBKNU8zaGFZVVVJc0dIQTZmOXp3N3Q4ZS8waVVm?=
 =?utf-8?B?WHhBaUkvNnRDOG9GNmRXUHBPYW96QlZVeVlFdGpLbjFtWWdENytrU3pMNkdF?=
 =?utf-8?B?d1p3T0tsUktCVjN6U1lxOUJOZXcxNm9kemh6MUZkZHlLdlhwRldrVG9IYkxv?=
 =?utf-8?B?UXoxUzA4eXJrSnozanorQVkrckluZUZQYU1iZXRmOHZYOGxtVjQxeGc0N2dP?=
 =?utf-8?B?WmZ1a0g5NTlpOG1XUTRGUWxySTd1eEtpaTFKM3FnK1E1TWJFN1d4a0VSMStQ?=
 =?utf-8?B?UUY5dEFHV1ZUMXZFREZNTy9RSWV6THg2aGUzQXhhUEFiMkx2NGprWXU4VVlI?=
 =?utf-8?B?NVc0d29DTkE1OWFoQmJ2eTh0dGxZU09TUlI1QitIbWx6VXFsdVk1Ry9teGwv?=
 =?utf-8?B?TWJadnluUDl0QjZMVXJHekpoV1RuUWcrTHYwSVBWNHN2elZhMzdrMkNURlBQ?=
 =?utf-8?B?cklPeksrSVdPNDFJcG9YQTc0QlhrV09aQVh0TnhiZnVtVGRoSEpIYmtXMWZy?=
 =?utf-8?B?TFIxenhrckdQeEtLbTdyQ1UxOHMwbXVoWWVBczNyOWVEWHhKWi9Id3RjL2pW?=
 =?utf-8?B?VnQ0di9Uc3ZBMWc4RmYvRm9wcURlRm1WNWpOWFVUd0FEWFZ0c1pvcnVHWmdY?=
 =?utf-8?B?NlNmS29waW85enNZOGxTdnlpSlRHM2RORkN1eFpLeWVHM1IrNytBUUNYR0RR?=
 =?utf-8?B?b3BFcnd6WWF6aHpQdzF1cUNVU2JqZGhJYzhkWEl6em1XajBybVZHbnQzMEo4?=
 =?utf-8?B?blhiVmhqbHVlQ0VCR0laYzA2RHRCa3ZRMDRpdFd4bzAxK1pIWWRKUHQxRk9K?=
 =?utf-8?B?SGlGdmtZaUpDYUFOUVcyNThzU0x1RVlybWszMkFueVlrdENqN01mRkFZM3ZO?=
 =?utf-8?B?b094dnlYKytZQTZJV1U4cmErdTFhcDFORkgrbjlyc0RZOGs4bUEyV1pEUDlF?=
 =?utf-8?B?QUFMNGN3VjkzTGpoUERPUGNhRS9CQi9ib1pad2pseWxhMlZId2RnZHRUL1I3?=
 =?utf-8?B?amZmeGN1TWlFbVlBZGtPVFhtVnVmaHpGWHB3ZXJ3b3JITEdHQUlmd0lsQVZB?=
 =?utf-8?B?M3ZRdU9oTUkrMHhta2ZwNGVlYUd0aXdTL2hhRFRjRzloTVBpdndoajBJclNM?=
 =?utf-8?B?M3VqMkFhN1laWmlQSGtBQ0FXTFBVb0k1Z25rWll1eTBtZld6VnppVy9haE9n?=
 =?utf-8?B?WitDYzFjOTY1QTcvK2J3b25Ta0JJQ2RqL1hxYmNkMjRFazNiRTJDR0kvMGNM?=
 =?utf-8?B?QUk1NmI2b3ZjL28zS21MamlNVzUxY1JGTGErY2J5OUhRUjBWZDRlWDhGbTI1?=
 =?utf-8?B?Vms3Y25pNjZxNExDaytzZFZrSGd1TDFpYWtLN3poa0t2anl0dzlSalJJMEpE?=
 =?utf-8?B?eVB0aU9yaUxIaGJlbUxrbEk4b1NLOFJ3YVhtcStJdVJPWnEvaWFST29MRFJn?=
 =?utf-8?B?NHZib1pBcUlYZTBXWGpheXBIUUYyZnpPMTY3N3d1eDlYUGZhcGtSZ2o0cFp0?=
 =?utf-8?B?RVlwR3c4c2RYdzRoOTFXTCsxWHZyQjllQm1Va1E2azRkcExzcFBDczBzWG5D?=
 =?utf-8?B?eFIwblA3M1VYYURpSG1ETHRkU2lqQ2lydlBERjNOUko5Q0FHWStqcGJJc0ZF?=
 =?utf-8?B?dlBZY3pMOEliNitUYXVieU5KSzVicGdCckpxUG40dzBNTk1kN3BrOW5PN2Ri?=
 =?utf-8?B?RHg3cnM2Z3pnK01kbHNTQzg2L1NkYU12alVsVFA5d20vVHBNbTQwNm9rT0Y3?=
 =?utf-8?B?RU9wU3RHWFEwY045NlFuYXIvREdaN2U1Nmx2aEl1aVBQKzJOK1JYSDNOb3g0?=
 =?utf-8?Q?ZSL8umTXKMKJci0AYEnPM0TQp?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5B6C0B5399B6F419C58B988AA1C4C43@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02beddc6-411b-4090-c82b-08ddaec3f1ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2025 23:57:55.5134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EtRUV/PJdScCVuFr9tnKthvFY+mCi3Rb1RjDBwl5Sx5Zzj1B5Kbd/ymi4GY+WB2d+xz/C+tPkX6EFgLca+XC3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF383C22AA3
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTE4IGF0IDIzOjQ2ICswMDAwLCBMdWNrLCBUb255IHdyb3RlOg0KPiA+
IEl0J3Mgc29ydCBvZiBoaW50ZWQgYXQgaW4gdGhlIFNETSBWb2wgM0IgRmlndXJlIDE3LTcuIElB
MzJfTUNpX0FERFIgTVNSDQo+ID4gd2l0aCB0aGUgZm9vdG5vdGUgaW4gdGhlIGRpYWdyYW06DQo+
ID4gDQo+ID4gwqDCoCJVc2VmdWwgYml0cyBpbiB0aGlzIGZpZWxkIGRlcGVuZCBvbiB0aGUgYWRk
cmVzcyBtZXRob2RvbG9neSBpbiB1c2Ugd2hlbiB0aGUNCj4gPiDCoMKgwqB0aGUgcmVnaXN0ZXIg
c3RhdGUgaXMgc2F2ZWQuIg0KPiA+IA0KPiA+IE1heWJlIHRoZXJlIGlzIHNvbWV0aGluZyBtb3Jl
IGV4cGxpY2l0IGluIGRvY3VtZW50YXRpb24gZm9yIG1lbW9yeSBlbmNyeXB0aW9uPw0KPiANCj4g
DQo+IFNlY3Rpb24gNS4xIGluIA0KPiBodHRwczovL3NvZnR3YXJlLmludGVsLmNvbS9zaXRlcy9k
ZWZhdWx0L2ZpbGVzL21hbmFnZWQvYTUvMTYvTXVsdGktS2V5LVRvdGFsLU1lbW9yeS1FbmNyeXB0
aW9uLVNwZWMucGRmDQo+IA0KPiBzaG93cyBob3cgdGhlIHVwcGVyIGJpdHMgb2YgdGhlIHBoeXNp
Y2FsIGFkZHJlc3MgYXJlIHVzZWQgZm9yIHRoZSA6S2V5SUQiDQo+IA0KPiAtVG9ueQ0KDQpZZWFo
LiBTbyBJIGd1ZXNzIGl0J3Mgc29tZWhvdyBpbXBsaWVkIHRoZSBLZXlJRCBiaXRzLCB3aGljaCBh
cmUgInVzZWZ1bA0KYml0cyIsIGFyZSBhbHNvIHJlY29yZGVkIGluIElBMzJfTUNpX0FERFIuDQo=

