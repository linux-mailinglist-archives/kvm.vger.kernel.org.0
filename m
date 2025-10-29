Return-Path: <kvm+bounces-61422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DAED9C1D613
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 22:09:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0355189966A
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 21:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2CC3161AA;
	Wed, 29 Oct 2025 21:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NlKua9O6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F4C314B93;
	Wed, 29 Oct 2025 21:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761772011; cv=fail; b=WU9yiWycPe0B4n/K8VyiAm63Cf+HTyav2k+tssbLtp3Pcf8ojVaLBjRzw/p2NNx56VyDV9nN4ySX8VJbDHGgHXWkFEaCVOGpNarCXuVIsS5MeB0MSLLEcWZXV9i0Y8mOidsyh6V2puH38g32a+1XycE0fEurxWt+SlUyWj8CHQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761772011; c=relaxed/simple;
	bh=zI4/Gr9g0C1F4uKhEb8/BI2qj0tr+joBGVmkRWsbzog=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a4pUhW9VfOpoVCuK1P152QT0TYJ7znVRE5M7GNv8UMZoWZrJkdVsiuupF7rowD6o66uRHG8c8ErkY/nyEthizYEeIqcvUgzQs4cJQ6dYkwdwMLPJ7wnRvyZl6MBz9HdJrFPe7doKcBRYbpO8+2gA1YBGMdC2x9nRJTZFWNQ2ny4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NlKua9O6; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761772011; x=1793308011;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zI4/Gr9g0C1F4uKhEb8/BI2qj0tr+joBGVmkRWsbzog=;
  b=NlKua9O6bAjqphQ8iLD0wb7ZlPfoY9DNAyNmmBJtfx00CTyXc22SEI5K
   4tSOJck5Q5TQjAtP1jH6MQYT9W5Kufdol/y3oJGaCtgBpKbvV6TTFlYiL
   gN/snKkh91n+UXmg6qIm56MhLceLv3/Re+c0xOGycQv39gpr7FUstIcvy
   musdTOrU9xQD+aEEB4UwmQbSkaASX9E7rCo1ZV8ln2NLxpemUeiivK4cJ
   hP4ImSUU8C+GMQzJunrvEz1bCa/FGsTP7Apq1Jq4xOlfgFeOJW3S95829
   Gtp5IKbRuQbAi3P9rJ1qShFlnhO+5JMFijQmip0o1kX5kQVKIbMGKh7FZ
   A==;
X-CSE-ConnectionGUID: sRH3QwIVT8iXzo+fgiUe6Q==
X-CSE-MsgGUID: USyfMVtES2ugVoPUW4r05A==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="64054698"
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="64054698"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:06:50 -0700
X-CSE-ConnectionGUID: 61VF1bOQSbe94dUzA1RPvw==
X-CSE-MsgGUID: pt2luEmkRzqbYOtXypb1JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="216631043"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:06:49 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 14:06:49 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 29 Oct 2025 14:06:49 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.54) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 14:06:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DHTRNVxxWFivy22uh8ZBRpuIQ6UPgLTWe6JTIxZEJyFDaENmSQJgYlwlWkhFnIWGHbEUzngTNCLtwdxU8X6FxA+MwNePg2IWQxsu8TrjR1IUtDfmefOSmZTjIZcH+tB/JQsZst+yprfbwp1Mg+xOCzZhTJPUocWAN+ZnfsFN7KtE7yiohl4Uio80DqiyN1amH1aRYfr9Hzr30y5qcKoM+OIIuby3A8nQq41veYSWB7lEtpe8ingdeKpi0UnYH+eZYD/O7atEr3jTZMt+e5l8pAqXETGZGAL1Al9cHphwD1sNkcB0WmrOHefzdLRyAZaVWNwqNvvLuU28WvbpUXt/5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zI4/Gr9g0C1F4uKhEb8/BI2qj0tr+joBGVmkRWsbzog=;
 b=XVj/YbslyO/o57yzdGasoxkW7e4vpPHDqDLfZjC5Ia1VUaSJV0CkEEijR7k/NHshxBYDaxmObKmiL84Q3SOE6y0G5BKwe7tvIjsttwonvRo9NmUdOJIYAv79e6eqRAtXkzfz5i8msKIfrSZhseBW/8OX7oJ8fLGIlMIon8qLjIg14HLxYChWKTiDnfLqEew1avGBOQSgzTSfsk8Rsl6vkdrVH5GQB+FUkiiufrjgUelMkvZ/CSip/0S+R2tebsAC8JouS6j3ovW5eNmgk7jVo412A7EGBqWK4BwEpf0s03Aplm45jg9+2/VBR5xXTwG1yIFWP+qzbe0GqO+EumZkvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB6791.namprd11.prod.outlook.com (2603:10b6:a03:484::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Wed, 29 Oct
 2025 21:06:46 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9275.013; Wed, 29 Oct 2025
 21:06:46 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>
Subject: Re: [PATCH 1/2] x86/virt/tdx: Remove __user annotation from kernel
 pointer
Thread-Topic: [PATCH 1/2] x86/virt/tdx: Remove __user annotation from kernel
 pointer
Thread-Index: AQHcSQ0H51MgOsZw60KbSdU9hLqTKrTZncOA
Date: Wed, 29 Oct 2025 21:06:46 +0000
Message-ID: <6bfe570e35364bd121b648fe8475f705666183d6.camel@intel.com>
References: <20251029194829.F79F929D@davehans-spike.ostc.intel.com>
	 <20251029194831.6819B2E7@davehans-spike.ostc.intel.com>
In-Reply-To: <20251029194831.6819B2E7@davehans-spike.ostc.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB6791:EE_
x-ms-office365-filtering-correlation-id: 820dba45-65f5-4e1d-3e66-08de172f11db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dzl3UHhPaCtFeVhBL2ExV01qMDdNOGNCcHNaTVh1eEJlWFh0V2NIMERqUmhJ?=
 =?utf-8?B?dytPTzRvS1crUHE3WGlJTTZJaDJHRHYzR2s5TjRTUWY2YldzSWYzWCsvdDFU?=
 =?utf-8?B?aXpIS1V0bDVqc1ExWEJsM0JMNTNDditDdElET2xIeTlHMksyY2dySEdnMFFs?=
 =?utf-8?B?bUVUU2xNTXBwZmRMSWsrZ28yTkZnTDEvWEN5d3ZDbU9FSFcwdWNNcTVlTE9s?=
 =?utf-8?B?SENCbC9ENDI3WnVmSVNwZ1lYVkpyMjkzVjlrMVU3WEtreG0zdmpRTEduQVFp?=
 =?utf-8?B?cC9hUlBXM243eng5ZmN0MWRJU0s0S1Z3NDZMZEtLckhUUmpTUVBRNVlCR0ZC?=
 =?utf-8?B?czlZeGQ0NTMzN0gvR1l0M3V5MVMzVDl6dWkzNmhrS2R1anNLVk9ObmFVN3E0?=
 =?utf-8?B?b201WTBKTDhBbnFpKy9DQWVRUDNnUE5XNFZTdFgwcDNuNlZFSW0xYzhUZG9o?=
 =?utf-8?B?M2FPUmJLalg0dTI4MXFGUGJPdm4rSUd2aTRBMmhEVkIvdXoxY0VKakNKenFt?=
 =?utf-8?B?a3Q4UWZ3Y25NUTJiTVJYMUFsQ2dsaXhUZFVMVEtqb05XaDB3SjN3MUhaVFlz?=
 =?utf-8?B?RCs3akxzNUFDZlI2Q3Z1S3c2SmFzZEhhbTVJaDBiVlFSZ3dGYmw2QTJJdTc0?=
 =?utf-8?B?WHRzUkF0WFlMZVdMdkVOeTRJR0YxNkp4MkN2dTZjeStUYTRhRkpQanpKUjd5?=
 =?utf-8?B?QlR4dHZHRXBZdWswTzlsL3h2MmQ3UlFXUVpNUVh2VjNnUjJEaUx2Z09ZWlNE?=
 =?utf-8?B?SGExNnM5L3RPMEVwSmVldjNCOFQyRldyVFMwYU43SDNEb093bUJmbGppYzBK?=
 =?utf-8?B?b3ZiZW9sdFMxWkxmUzk4WkNTbnlaYjIwdEMzMThVMEtsMy8wMXNPR1J0WnNl?=
 =?utf-8?B?Uko1RFJ1dVp5QzNiZjlYM2NQN3lSaGhmOTd1cXk1b1M3ZjRvUjdkY1JSMUVW?=
 =?utf-8?B?TnROUnYzbW1FTGxINEJzSDlBWkNsRkxNaHdSZ0NmQi9pWElzK3pKVjRoUTRL?=
 =?utf-8?B?STdna2lFMXlRVU1rK3BIenZMcHYyb1BjQTNzbzFSWC9VWmYxY1JpK25kMzhP?=
 =?utf-8?B?cVprc3p2cXNkcnlUSTJqM0VkeGdrcjNRTUhFUC9ucjR2OGc5NXhjeU53NHZ6?=
 =?utf-8?B?dm1WZ3hzNmphbHhsVzB1REUvdnBTYW9va0NLVkRENXVHd2V6WndibFExK3pl?=
 =?utf-8?B?emsybVR4bks1c0x5VWdXbC82UlRsdXgva3QrNmhkODRNOWhUb2wyYjk1TFFO?=
 =?utf-8?B?K2ptYmcvKzZpK1I4Rm1RS3FVLy8vQTFlZTV0WlByL1JLVWpWR2F6VFlmbFNx?=
 =?utf-8?B?VWhnRlo1NGMvYldlS0N0Z2xDRjdweG15ZjVKYW50RkJuZkhjcDJ2SGU1VG5G?=
 =?utf-8?B?UXJpRjl6UW9NOFR3RmdpNGtpNGpPQ0Y5L0xmSVJ4UHhibDQzWG5DdVV1WHNx?=
 =?utf-8?B?ZlAwZ2draGREZmlqMGlobitxWEZkWmFKOFVEKzZlUWtGY21sTHI1dW1EMkdV?=
 =?utf-8?B?MElpSHJmMVd2N1FXOVdnM21ZSExiMndCZTMwT1gyUFFzemRzY0VoZnNhbFBt?=
 =?utf-8?B?M1prNDY4WFErVVI1K3JhVUZPd2ZiMUpKaWxkWUtWdTVSWDhqZkNPVlVGdTJT?=
 =?utf-8?B?NU9OVFRFV1AyaGdjdWdWNVZWaWpGNmc4eVRyeTBEMXBDN2M3ZUtmUW05dXRB?=
 =?utf-8?B?UVZ1bFkxa2t6RW8xL3pLVTVvbWtlRWpkcFJKSDc1Y3AvS2xSaWo1K0x6WW94?=
 =?utf-8?B?U1dYN1BYUm1NcFExcFNSRXFEQ1lBbUxUTXpxWXN0MWo1VW1qeDRNTTY0cGdG?=
 =?utf-8?B?NlpZeENrdlBhWnJienhnaHhZaGt6aVNTcW9xU09adUtCWFBQdldLeUJpMjVI?=
 =?utf-8?B?dlJ4aGxNSmd2WUkzVkpGMkJTWGhmUTRrYUdGZ1orZENrVnJyY0tzSGRkRDVK?=
 =?utf-8?B?YklML3B3anBvTUtQYndSNEJVSDRBOGl3Wm5FQlZ0L2FXVGNCL2FoV0owNk9s?=
 =?utf-8?B?dlQxcHFSaVdvUndRN0w2bnF1R28xYndwM21lMmlkaWN5SDN4UGpYanRtTmV2?=
 =?utf-8?Q?jLxMIV?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkExZlJmaS8vbmJqZklOVjdiK2pJRmFiZVoxM1Zyb1hKbnh2UDgweFR6K01J?=
 =?utf-8?B?QjRMVHpJYW9pNVZNOXRZV2dJQ1JVTksrbUhJTXZhVjZ4a2YvSkVHSUg4eEJY?=
 =?utf-8?B?VTRpdGx0NXZuVmJGZW50UC9FK0pSRnZwTjFsU0FpMThaYzhwMWhRbXNpcjFt?=
 =?utf-8?B?aHByRlNnN2tkRzIzVTQ1bm5ZRTd4UU9tNHo3NGd0UlZvbVhLYmtpOGU0MmhZ?=
 =?utf-8?B?ZWlkcm53dzlVODAxNEw5OWdxQTJUS1lEdVlDeTRYUFRiOUM5NG0zeWFZdklG?=
 =?utf-8?B?TDZMcDdDb2thbEhnYnFBOGtydmtXc0RIdDh2KzA2ajdnQzVWam5Wci9YM3Ru?=
 =?utf-8?B?cFVCV2tXVHRYYzBISEkyN3BsdXV2NldlcXZuRy9CWW9pbWJOc1krYXhBVzc3?=
 =?utf-8?B?cFVhZlRNdTVicDRmRHRFMjJjZ2o4V1dDRW9kRTlvRmZsMUFwU3dzK1Z0L2VN?=
 =?utf-8?B?MXpsU05MRFhkdEpYd1dQUjNIZWF4SXlMSEpYNXRYZnJmT004WENpSjNaR2h6?=
 =?utf-8?B?NkNyVG9oT090YUJ4ZXdVdlFPLzlUU2hDdU81VTlHR0pyK0xHS2M4S25LUHJI?=
 =?utf-8?B?c3RvZndMdU1OZ0l5TFBEbER1bWlra3ljemwvMktPejhUVkF5b213QUVNN29k?=
 =?utf-8?B?Y1ZESHRZeVpjQUdsNDBXWnV2TlJQT0pVdXh6M0JqbHFFYU5wbHlLRTlQTG9N?=
 =?utf-8?B?WWlRalJ0TlhIdlA2SWx1aWxSeEtYMWhoeXc1QTBYcU41eUQzUjZmbnlBUkMv?=
 =?utf-8?B?WnR3LytJSjkwaFRZRnpnTWgyMWpRU2xCTzUwYmI4UmhwcDJGczZkMEpSMUhL?=
 =?utf-8?B?V21nYlRncU5DQ2JRdmU0dzUvTXRXbmdhUFRHSTFXWFloZGZuWWgwZ0xPTjFq?=
 =?utf-8?B?VnUyUkIrSEF1NjBrSmVWcll0bVJFUE02TVBuUDNRRmpoOTRDSCtsNFh6NDUx?=
 =?utf-8?B?RC9jcmhFZHVMSllTTnV4SFlaNTkwNEk2NkNTMmxzSmlUV3dGSFFvZ0hhV1My?=
 =?utf-8?B?emZaM3prSDlvYmt2ajBXV1h6NzlNN0VRWjBIMUlwZ2hkZEllTTlmT0w2SGNw?=
 =?utf-8?B?MTRCNjZyZTBxd0lwc0gzR29oaURPaDBXMzl1MlFLa1hTYjBBN3FqcnZTSWZj?=
 =?utf-8?B?U0RyUkNTbE9WaXBFR2kxYWZsanJ2R3ZvSWdLRWxmU0diOU5ZT1BSM3hRNkRY?=
 =?utf-8?B?TTBkQXhxakUrZUduVzllOU9BUnoyRHp3WWZhT2VnbFhEUENzL3Y1Q2NmMEN0?=
 =?utf-8?B?ZnFOeUlzdEFTTWVEdGZQVThEYmJLVDNHdUlXL0lyWDlsVEZNQmV3cEtWL2s4?=
 =?utf-8?B?eXloa3RpV0ZaLzg1SS9YVGxES2RqdzBZbU9XYWNNZzlGNjFKT0M1NzgrT3h6?=
 =?utf-8?B?UHdsZlA1RlpyLy85OW5YdVZ4MDdYNHhXekFZUnowdEF0eTcyeW1tNW5SdGZ2?=
 =?utf-8?B?V3pNRHlEeTNKMHlDa0NmV0JUc3M3RE90WkhLVDlSQVVHT2FBd2VXWjU4R2FI?=
 =?utf-8?B?NTluOFM0OWw2VFRJOXQrOVFVem5hS1FmbTBWK3pleUprQXNRd2h4bDVmTmE3?=
 =?utf-8?B?clgyT0dnbWJPSktDa0diRTFuZjVqdW5HM0ppejltcGREYmNOY1dub2FTekFY?=
 =?utf-8?B?cEZqV0wwUG5RTTNYUUl3eDdSdjVUdHNhWGN2SVNYdExOWThmSlpBRGdjTFJt?=
 =?utf-8?B?MFh6MzZKSkdwV2VxM0JsM25wOVZFUm5pKytxOUdJV2xHZVFEZ3lHaEVsd3E1?=
 =?utf-8?B?VVc0MTVLOENGY3VFL0dBY2szQUhTbEdhM0grYzk2U2J5UjZOUG53aWRBUkVr?=
 =?utf-8?B?cU9MT3NuVkRYbkh3Z1dBYy83WGV0ZVNwaW54MWxvd1d3bVZFTWZiU2Nsd2J4?=
 =?utf-8?B?NTcrMHFLZ3J4ai81bzZ0Uk5NYUlrV1B4VThMNHE1ekNUVXNFbk5yazh3ZWtx?=
 =?utf-8?B?ajFvaDk3QjI2YVZOZXB0a3VuK0lrR2Y1cGdiVVgzUHc3RkEydGx6eEpIQW1G?=
 =?utf-8?B?aDdkL1oyVFpEV3pxanpiWEUrZ3Z0UHBOQzYzNlBJMFJxakJ0SVR1SlR4SUJv?=
 =?utf-8?B?YmtZbnU5QXhmVGtOY2l4cTkvbDVHSnU3MnUwMVYrL0ZJNWlGY3h3ZldidVRX?=
 =?utf-8?B?U3hYSU5tRTl0V1FvSlgwaUFqUFdrVWoxakpsKzlXWmFqSnFXbFJDSWQzL05Y?=
 =?utf-8?B?R3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E48C664C07FCD24B884B723E3A118C83@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 820dba45-65f5-4e1d-3e66-08de172f11db
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2025 21:06:46.3120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AjwLJgWtuFB3Km6ziNxd4XKJLFrP7CGYhgHQp+y61KfwHmTTQcZUCWy2uy2H1t5Gu/SNg9JEV1GZvgBsZ8XVG2Kz91Kb5bvvPluEoimqtNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6791
X-OriginatorOrg: intel.com

Rm9yIHRoZSBLVk0gc2lkZSBvZiB0ZHgsIHRoZSBjb21taXRzIGFyZSBnZXR0aW5nIHByZWZpeGVk
IHdpdGggIktWTTogVERYOiAiLCBhbmQNCiJ4ODYvdmlydC90ZHgiIGlzIGJlaW5nIHVzZWQgYXJj
aC94ODYvdmlydC92bXgvdGR4L3RkeC5jLiBJdCdzIHByb2JhYmx5IG5vdCB0b28NCmxhdGUgdG8g
YWRvcHQgdGhlIG9uZSB0cnVlIG5hbWluZyBzY2hlbWUuIEkgZG9uJ3QgaGF2ZSBhIHN0cm9uZyBw
cmVmZXJlbmNlDQpleGNlcHQgc29tZSBjb25zaXN0ZW5jeSBhbmQgdGhhdCB0aGUgbWFpbnRhaW5l
cnMgYWdyZWUgOikNCg0KDQpPbiBXZWQsIDIwMjUtMTAtMjkgYXQgMTI6NDggLTA3MDAsIERhdmUg
SGFuc2VuIHdyb3RlOg0KPiBGcm9tOiBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5zZW5AbGludXguaW50
ZWwuY29tPg0KDQpQcmV0dHkgbXVjaCB0aGUgb25seSBkaWZmZXJlbmNlIGJldHdlZW4gdGlwIHN0
eWxlIGxvZ3MgYW5kIGt2bS94ODYgc3R5bGUgbG9ncyBpcw0KdG8gbGVhZCB3aXRoIGEgc2hvcnQg
IndoYXQgaXMgdGhlIGNoYW5nZSIgYmx1cmIgYmVmb3JlIGxhdW5jaGluZyBpbnRvIHRoZQ0KYmFj
a2dyb3VuZC4gTGlrZToNCg0KS1ZNOiBURFg6IFJlbW92ZSBfX3VzZXIgYW5ub3RhdGlvbiBmcm9t
IGtlcm5lbCBwb2ludGVyDQoNCkZpeCBzcGFyc2Ugd2FybmluZyBpbiB0ZHhfdmNwdV9nZXRfY3B1
aWQoKS4NCg0KVGhlcmUgYXJlIHR3byAna3ZtX2NwdWlkMicgcG9pbnRlcnMgaW52b2x2ZWQgaGVy
ZS4uLg0KDQo+IA0KPiBUaGVyZSBhcmUgdHdvICdrdm1fY3B1aWQyJyBwb2ludGVycyBpbnZvbHZl
ZCBoZXJlLiBUaGVyZSdzIGFuICJpbnB1dCINCj4gc2lkZTogJ3RkX2NwdWlkJyB3aGljaCBpcyBh
IG5vcm1hbCBrZXJuZWwgcG9pbnRlciBhbmQgYW4gJ291dHB1dCcNCj4gc2lkZS4gVGhlIG91dHB1
dCBoZXJlIGlzIHVzZXJzcGFjZSBhbmQgdGhlcmUgaXMgYW4gYXR0ZW1wdCBhdCBwcm9wZXJseQ0K
PiBhbm5vdGF0aW5nIHRoZSB2YXJpYWJsZSB3aXRoIF9fdXNlcjoNCj4gDQo+IAlzdHJ1Y3Qga3Zt
X2NwdWlkMiBfX3VzZXIgKm91dHB1dCwgKnRkX2NwdWlkOw0KPiANCj4gQnV0LCBhbGFzLCB0aGlz
IGlzIHdyb25nLiBUaGUgX191c2VyIGluIHRoZSBkZWZpbml0aW9uIGFwcGxpZXMgdG8gYm90aA0K
PiAnb3V0cHV0JyBhbmQgJ3RkX2NwdWlkJy4NCj4gDQo+IEZpeCBpdCB1cCBieSBjb21wbGV0ZWx5
IHNlcGFyYXRpbmcgdGhlIHR3byBkZWZpbml0aW9ucyBzbyB0aGF0IGl0IGlzDQo+IG9idmlvdXNs
eSBjb3JyZWN0IHdpdGhvdXQgZXZlbiBoYXZpbmcgdG8ga25vdyB3aGF0IHRoZSBDIHN5bnRheCBy
dWxlcw0KPiBldmVuIGFyZS4NCg0KSWYgd2Ugd2FudCBpdDoNCkZpeGVzOiA0ODg4MDhlNjgyZTcg
KCJLVk06IHg4NjogSW50cm9kdWNlIEtWTV9URFhfR0VUX0NQVUlEIikNCg0KVElMIG9uIHRoZSBz
eW50YXggYXNzb2NpYXRpb24gaGVyZS4NCg==

