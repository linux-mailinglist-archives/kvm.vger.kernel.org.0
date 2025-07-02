Return-Path: <kvm+bounces-51247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CF49AF0916
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 05:15:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CDEA3BD91A
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 03:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA741DB92E;
	Wed,  2 Jul 2025 03:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kg54Xv03"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D457418C322;
	Wed,  2 Jul 2025 03:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751426105; cv=fail; b=fZRauL+FRpRpi7HwYZEm/W6NTJWm9tq/46/gZd5nHMlsDT1eihVEcgzwa0tV5s/zUo1/vnUnEnFjys8pEHAGngjM75o3+3/7VGpTB8MHE9El52yG0XpjUmhRNmUmsCZnOIXhNUeAnBancdFOK8HwSCF4jTbiHRWxBHRyxJchxAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751426105; c=relaxed/simple;
	bh=/iOBVUdUDWl1cEs922nB61SmgKHxO2k9D5ZGoAwp7ww=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ijw3YT9fxqSYttioWXVXlpwM/kkrzNhY2f1KYAngp/4dZvcW8KWguKw5PIpz4I+HMeho4O0/4JbeGQR4lQRbRc09c2TChHhA3cCysbgUIIqZTSDf2g7CRMKtyG36uAIEMBA2HAWBJz+ncqeTMfXM8/ZmJmIB10gLk6amXC7IaFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kg54Xv03; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751426104; x=1782962104;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/iOBVUdUDWl1cEs922nB61SmgKHxO2k9D5ZGoAwp7ww=;
  b=kg54Xv03LrwKbr2oX7TRGOiisIpOYdDsnloixYoU1g9dfJDGK8H3A27u
   eEaMYvlYiZ6vObggrvmRv4BYNhn/uX0Ueoig6dHXABD7DXpeW04HfTYUM
   y5EIIIkHsXG2LGMNze1tbfC7nTlG0CUFWVlq4Ja8S5eNEErMC1rysBf7h
   tsFsC4z17zSp7h1VIEyxH2RFCOJ+wh1sDyCvd+R9wk980B3ZAQf2owseY
   Gg6htRLv1ONiQVeR0c1bUx7Y8WTM9XX3wbbbw9w8dG5R1vmt+3F4Wv/72
   JYTzah4nd9Sv94tmba+5PINQDIZY6LEKbgFJd0+/RXck0H53R0W82pXM1
   A==;
X-CSE-ConnectionGUID: Uw99azyNQ5+7hzDjG1BGpQ==
X-CSE-MsgGUID: TIlyvwkySBSZ50ZQkRh3hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="71275770"
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="71275770"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 20:15:03 -0700
X-CSE-ConnectionGUID: syrWdZxcSsaqv/E4zEQ9/A==
X-CSE-MsgGUID: qpQNitZBS76XbaQd+kzBxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="154495730"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 20:15:02 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 20:15:01 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 20:15:01 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.79)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 20:15:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h1qGr5M3H1g1V7ycOOiyYsUpwI/XnmBYWGqiXl2sT0R/UK+PRkeIdG8L4K4MHPzZLo21NKeSwqbuenveq+uaklLLhbX0zhYe4M7VfuG75f0CXpDUOpq7+FlynbOyMQrR+Yqe4n00UTE+nPx66/TZC7gduiAesopyPlbEldovkJP8eVVBbHxUAvAvGvDnDxzuC82KtWnTYYvgJ1LsF0dzF338NB2jF8MA67EFz+F5dcsyJoCtV4KJSe+PAXDCBGgYal6iIvhhG73l9n5Qm8T34UsDHqjYpIJltEPe71Pb/JPGdkspgjnHEeIONbbVtbiqLV44yj+7OZzyZCYa8uYfJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/iOBVUdUDWl1cEs922nB61SmgKHxO2k9D5ZGoAwp7ww=;
 b=s4nYv2XpGVxhmli+zoJxIPEny4UnqNDmPOFF4D+38AhdUuGmCwchN6YquZ+cCDnGyff6ueMymsVGEnRq5617fT4rcLpBzzlCDD/4k/LXLSfUsX+DRYI9VF6bh9ksQ0noAEY+DCd3ixfWL4KiWhxvI40re4dxKdFApjofCCwvP5kqVrCVaMzgF6WtcLtS9EC6XkoZNTn4JjbgoVtbwlVw2qkNGS5mz0oNEmxU6ivgduQNvSdCAx4dxCF1GqD41Zhj0f3Qpxc15utz4J5HMDJncuM+f3OiX3oMhfM95WSjXLOUA6+T2BsPPzihnJj+fOjuu7616UfFaVUNQMup9WIPSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB6999.namprd11.prod.outlook.com (2603:10b6:510:221::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.29; Wed, 2 Jul
 2025 03:14:59 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8880.029; Wed, 2 Jul 2025
 03:14:59 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>, "sagis@google.com"
	<sagis@google.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Chen, Farrah" <farrah.chen@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH v3 6/6] KVM: TDX: Explicitly do WBINVD upon reboot
 notifier
Thread-Topic: [PATCH v3 6/6] KVM: TDX: Explicitly do WBINVD upon reboot
 notifier
Thread-Index: AQHb5ob2sxTequ6YNU2TEnElo1JBELQc0F4AgAFhjAA=
Date: Wed, 2 Jul 2025 03:14:59 +0000
Message-ID: <3dc49aca717ff9ddb090ef276f2ca30eb14ace95.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <6cc612331718a8bdaae9ee7071b6a360d71f2ab8.1750934177.git.kai.huang@intel.com>
	 <2d860bc1-c7ed-4e5e-8b91-ce494f9a8c54@linux.intel.com>
In-Reply-To: <2d860bc1-c7ed-4e5e-8b91-ce494f9a8c54@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB6999:EE_
x-ms-office365-filtering-correlation-id: a551248a-b82e-4731-d9d9-08ddb916a102
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RGlYbC9HNWc3aXQ4R1kvb0xiTkRpeVJOTjdGS2k0STM0MHVNa3pKYnpubTd3?=
 =?utf-8?B?eUE5UGJuQzhIVkdlYXordTgzR2RXc0ZONHNqTmdlM2pWQnFpRWVLVHlwNkdU?=
 =?utf-8?B?SE91Sk5TQ3RxTHlFeEJEZ0RFOFM3SlV3K1VpZGp6Q01hTnRialYxQ01pVXhM?=
 =?utf-8?B?R0J5SWFsQXZreDg4RUJRMURRQlZ4NjFZT2FEeHN5bkNEelpyVjBkRkl6R2Mx?=
 =?utf-8?B?eVpFMmhmKzNwRE1aM2JhREtMbGFUbWZsbm1YNGlLRUM3U0wrcldId3FXaUdR?=
 =?utf-8?B?ZnZwbnVNc1JjMzJKNkF0TkJUS3N0cjJPZFZLeXRyYkRGb05SalN0NnE3TDdD?=
 =?utf-8?B?bEtCVExMUFc4M2JjUGozcUlXT1ZNNGJpZGFBc1ZGeCtCbUJGZWk3S3ErTm1M?=
 =?utf-8?B?bm9NU1hEYStpTERkN1ZaMUZHUEZpU0RVdlFoamFTTjBuS2tEdkZreDZWeVZC?=
 =?utf-8?B?UlZTYTdYY01PaVhabUd6NU5LR0pIbmJGU0YvNEtUYm5BNzFjTC9DK1Z0UWt3?=
 =?utf-8?B?OExFclF0b3R5MlFIRE5lZmtJckMrTlpjZlN0Sms5YWlmT1VIc011SmEwUllw?=
 =?utf-8?B?KytHVVhhNFh6RGcyMHhoYnlGa25XRXBVcW8yUklQM2xON3g1VDVTZ2hzOHhh?=
 =?utf-8?B?aHRyTFJZNE8xaDY1K09zYy8xekt4Rm9VaEp6aklnMXVLNTMxOVJML29BTFdk?=
 =?utf-8?B?d29MLytUZ2xGQ1UwUVhYSXZac1lnc3doVGVGa21GcXdRUlZKQ0J4MmRScEpi?=
 =?utf-8?B?MWFYSmJYZm80ZVlXZFlVSC9wOStwNjgrdjR3Snh5dFBaQkQxRjg2S3E3bTRB?=
 =?utf-8?B?dFRTTEhGeldVZ1JOUTNmVjAxQW9qcjNZTmdtTDlZbWNqbXRJNUlFczVXalVk?=
 =?utf-8?B?VGNjcExjR1pZV0twWUNKN1hzVlNVQ0xMeVpPV0JHU3RYUzU4MlFocW9qM2h3?=
 =?utf-8?B?WEtnSVFvVzhVeGEvNnFrZVZjd01PNlgrbFVMWXJ6aUpnYW5nYTNEOTJGb2Iv?=
 =?utf-8?B?Ly91TDhsK3F0QUZDR3lidGhpejU3cmZ4S0NCU3RJNHZRNXZJVWM1OFkzbith?=
 =?utf-8?B?YjJaQXFWbGMybUx3U2JGMWd0Nm8rS2U2TkRmZERkS1dEWWlUQ1FMcURvS01h?=
 =?utf-8?B?cnFXcTA5QUF6L2ZXYXMwZXNGSE5QR2xtTjY2ODNySDBXT3dKUDl5SjZwc1Zm?=
 =?utf-8?B?RGI4V2g5QmdvNXA5Q2hFWnlJeXZjdEd4dXcxUnFIekZUTTh3eVM2S1p4bEFv?=
 =?utf-8?B?ZmZINUpOY1VNb0NQeVA4bkFUVWdaUWxxdmpWRjhpNnZVSDZXY1VTMk91SDJV?=
 =?utf-8?B?RWF6YWVsWVlFY3ExUWxEVGcveExTQ0YrejNhNk1aSkJZeEFjbDkvQ2RGa0NG?=
 =?utf-8?B?ZVY5NjlDdVJWMUNYYUZWdlc2U3ZGaDJCNnB0UDEzS2pEeU0yNDZQTzNhZ2Uy?=
 =?utf-8?B?YW5SaFJOSkRaa3U4dlBCSG1RRFh5WE10M1dvdU1MbmRlcnkwM1RxQktpMjNE?=
 =?utf-8?B?NmkwSU5WbGNyTXBNRTd1N1hvRzg5alNNaDJpeTZkZVArb2pVSUZNaGl0MVdj?=
 =?utf-8?B?Uk4vTXJ2TGZtMVF1TkVWME9kcXdnMGFURk42RytyTnRTa0RjOTFrUW0reDk1?=
 =?utf-8?B?ZkFvUnZsSzRMbWFTUVZFM3BZT0F1WkRIZjBua0tKdDA5WmlCdGZsZzlrQVFo?=
 =?utf-8?B?SlBkTTB6dWdvRklXWklzRTJXRlhnWldjS0FGQUZxbFBSTU05dldDRkswVDd4?=
 =?utf-8?B?R0I4QXBMR29rbnN2ZkFUL2Fuc0FUa3l5eFRyMVRTMHZBT0pQbkZDMU1TQ24y?=
 =?utf-8?B?cGI4dFdRTVdFdmZ2dDhrWjVWcG8xU3duZDdFZjRmVGMzSGpwekwxbGRNbU84?=
 =?utf-8?B?QzhoVWFWbXRSeHBSdk4rbDdlVVQ2aXRvZ08ybkJjUjRCaE5mbXFmemppUmxJ?=
 =?utf-8?B?N1BxNHV2UElod3ZHVC9MNmhVa3JuaUh0M3h4eGFyY0FLTlcvQUNBYUE4dW0y?=
 =?utf-8?Q?unJu34aAt7bJOSGqH8H5/mypdvuPv0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ky9yVDl3Qk1NVGgrRmo4VmJDaFlhWWF5YThQRTRsUGxLUTFmYnJXSHcwWHFy?=
 =?utf-8?B?OUNBdEJmVHN2Q0hOZWRMMEFsSDlaQ3J1RWdCd0drS09USTlXcTU3bGUxbG9N?=
 =?utf-8?B?bmJzckg3WjJOUmcxSGc3N2tkN0F4eHhuQWZBemt3YnF4aC80cDBNK1VHMnlh?=
 =?utf-8?B?alp2SzJENW9qK2JVZVdLMDBxaHp5MGVqVWkxajVWVjIwNDZJblZxOFBGQnAr?=
 =?utf-8?B?eThKMTREeXN6REZiRDdhQXl0NnZydFc2eHBTNklKNC92RnpKb00vUU1wcCtU?=
 =?utf-8?B?S1dRWXpBVGw0WEF5RWVSbmhMWFlDRHBjWDJDcG9qVkNjdXcyYU90bnBLaE9r?=
 =?utf-8?B?am8zeW9UVkhiOEtMbmxRN1k3bUZqOTdDS2JSOTBMYmJKSVJsakxWMXVacTlo?=
 =?utf-8?B?Y3cxSGIvRzZyaGVBcGJLN2ZxdExuSmlSNndZU3BwUE5MdDd1YXZxSkxXamYr?=
 =?utf-8?B?RXR0a0pYb3NYcFFsZjN2TzhnQjJCZHZiaHdQYnlWdHlvd1orVnNTZWhEcEk4?=
 =?utf-8?B?TDVLSXIwNmlxc2t0S2c1aFVqK2JmcXNrNnVnbWtlTlZLbU1XT0tyVWxTQ2d0?=
 =?utf-8?B?ZzVoSjFMWVJ2blBOS2Y3V1lTSWlrRHE1REhYOEtwTWIrWGJyeHpab2twa0Rr?=
 =?utf-8?B?TzZMWkdaK1FGVi9ITEw4THE0SHBGQzlZS0hCdHBMdzNzeVNhZmZBL0FWSEpH?=
 =?utf-8?B?aUJlTm4yUGJZbnVBdGFiZitLZ1hEdU5EK1FJZ245ZitBamtMcFV2dXVyWXNy?=
 =?utf-8?B?VUdBREJkVS9nOTlLcjdaRGxQczhIQjZsZFJYUUVZVmlKMml5RUFFaDNhWFJC?=
 =?utf-8?B?czN6SFdKeng1aUd4Rk1CYllqR2NlR1hCQlpTWmNQSTMza0ZLQUdDMlFpUTZy?=
 =?utf-8?B?eG1WQmdNaGE3MSs1dzVNMjhObHppbGVIRk9qQWZoay9MeXZDZ29HUzcxMXV5?=
 =?utf-8?B?OTFkNU53d1FZSFBqbUxDR0FBL2pmbStZT1Y4RUJNVUl4R3NoMmVRbGtqWlE1?=
 =?utf-8?B?anNoZUlVVzczUk1qVktRUkEvSmVXc25FYXE5aGZ0aHJTQzRYTlJLdFNsWlE0?=
 =?utf-8?B?TGZST21ON21jZVlyM2JMM0lnS3EzNlA5a3VLaFowbWdGUWVzaEFkc3FCK1lt?=
 =?utf-8?B?aG5tbTMwNzJ2YTNhMFM2ZGtrc0wyZno2U0k3c0lySk1xQlZWbXFubGRod1FG?=
 =?utf-8?B?akJYNytnbkFYZDRYYW9HRWpYSHk5ajZDWFZ5VlU0WTNvVjB4d0lmSHFyRFBR?=
 =?utf-8?B?d2R3cTJrb3libmNWRitaL0VSenMxSGsvQlQ2c3BaYXhHOGZYTlFudmUrTnpW?=
 =?utf-8?B?cU9seUcyejRSUGtxL2tNcDN0cU1OZEpFZS8wbEExeGhoMENWSTJOeTNicEVJ?=
 =?utf-8?B?a3ZYL0pEV0lGSHpIeVBvMDZTUDVtUzRYbTB5NDQrZFVkblB2M2pDcFNXNEVr?=
 =?utf-8?B?LzAxbkpPQVJpL2t0U2lTODFxcXY1UmYwWFZiQ0lPQjNaSWRLQmpNTENyakhh?=
 =?utf-8?B?M3dtVGJvMWE1aXZCZDAydldYZDhvZTFWaXRubXFNVTZCUk1Yb3NhdjJvcEhS?=
 =?utf-8?B?NlF3M0RKbVpEWnRGSEhZemc2RFF1aVpnK0xaVmk0OVNBNXZObkR0QUQ1L1Nt?=
 =?utf-8?B?UTlPZ1luaXdQZGVrMkhnSHRQd1RoQURMZS8rWFdaVW5rbVI5Ym1rYkN6UTZt?=
 =?utf-8?B?K0VKRTFFSTJlWlBMSklWL2N4RUlWOG1PK2pkUndvMFZybS9YRW5aRWVJR1Jh?=
 =?utf-8?B?aFlyWGd6bHRCbkVMaDBRa3NtWVR3WFNuTllJNDhiYUhhdnhPb0hPRmNKbXgz?=
 =?utf-8?B?MG5pd2hscjdlc1ZTNDZHT3pPVG5FblBmMXNUcy94Zk5FZGNSWTZQQ3dJVllj?=
 =?utf-8?B?cGVleWs2eUs0QzdDNGs4WUZCVS96WWQ5OVQzdFRsQ0Q5UVg3MWNnMnNPMFdS?=
 =?utf-8?B?cWhhVTY4TzA2QzFlVmlJUWRFMUl4aGdqaG95NUdqbkZBYnp0MmxhemQ1NVdp?=
 =?utf-8?B?MFFWOUs0VFEyYXdsYlpDU2V4L0ZoVk1Rd1RoenNFYTFYdnZFd0NTL2x4TlNG?=
 =?utf-8?B?OTRncG9kcHRHbGtaUTNCL1NPSmljNzlpb2o5RjY5aUoxSnZVazhkdWtTekFC?=
 =?utf-8?Q?YjKBe57EM2izaAz36rtTZiF2B?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <903EA75B1B47654D89424A0230114D21@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a551248a-b82e-4731-d9d9-08ddb916a102
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 03:14:59.7960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +YNONZ15PP+XeUp9pgREti5OcqegVcRTevdAqSLtA3WjktjuOXSAMApEA+lRLr+wEswc/5lU3k0dbjGZgKsdyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6999
X-OriginatorOrg: intel.com

DQo+IFR3byBuaXRzIGJlbG93Lg0KPiANCj4gUmV2aWV3ZWQtYnk6IEJpbmJpbiBXdSA8YmluYmlu
Lnd1QGxpbnV4LmludGVsLmNvbT4NCj4gDQo+ID4gDQo+ID4gKwkvKg0KPiA+ICsJICogRmx1c2gg
Y2FjaGUgZm9yIGFsbCBDUFVzIHVwb24gdGhlIHJlYm9vdCBub3RpZmllci4gIFRoaXMNCj4gPiAr
CSAqIGF2b2lkcyBoYXZpbmcgdG8gZG8gV0JJTlZEIGluIHN0b3BfdGhpc19jcHUoKSBkdXJpbmcg
a2V4ZWMuDQo+ID4gKwkgKg0KPiA+ICsJICogS2V4ZWMgY2FsbHMgbmF0aXZlX3N0b3Bfb3RoZXJf
Y3B1cygpIHRvIHN0b3AgcmVtb3RlIENQVXMNCj4gPiArCSAqIGJlZm9yZSBib290aW5nIHRvIG5l
dyBrZXJuZWwsIGJ1dCB0aGF0IGNvZGUgaGFzIGEgInJhY2UiDQo+ID4gKwkgKiB3aGVuIHRoZSBu
b3JtYWwgUkVCT09UIElQSSB0aW1lc291dCBhbmQgTk1JcyBhcmUgc2VudCB0bw0KPiANCj4gdGlt
ZXNvdXQgc2hvdWxkIGJlIHRpbWVzIG91dCBvciB0aW1lb3V0cz8NCg0KSSB3aWxsIHVzZSAidGlt
ZXMgb3V0Ii4NCg0KPiANCj4gPiArCSAqIHJlbW90ZSBDUFVzIHRvIHN0b3AgdGhlbS4gIERvaW5n
IFdCSU5WRCBpbiBzdG9wX3RoaXNfY3B1KCkNCj4gPiArCSAqIGNvdWxkIHBvdGVudGlhbGx5IGlu
Y3JlYXNlIHRoZSBwb3NpYmlsaXR5IG9mIHRoZSAicmFjZSIuDQo+IHMvcG9zaWJpbGl0eS9wb3Nz
aWJpbGl0eQ0KPiANCj4gDQoNCk9vcHMgSSBkaWRuJ3QgY2hlY2sgZW5vdWdoIDotKQ0KDQpXaWxs
IGZpeCBhbmQgdGhhbmtzLg0K

