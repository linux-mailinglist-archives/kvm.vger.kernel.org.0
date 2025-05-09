Return-Path: <kvm+bounces-46100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA585AB2052
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 01:45:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 766023B88E9
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 23:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A6C26563F;
	Fri,  9 May 2025 23:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jePbtod+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD13018DB14;
	Fri,  9 May 2025 23:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746834319; cv=fail; b=cYQVIPulDvUKbTv8bAYTLYO1bJEJo2kf1NQ2/51/YNcrMgkLa1NvCMRAz7se7UzA2Zi+wRZgZGV0BMHKCz2R0E4JDWB+eey9T77WQYvgF2toVbciBcnFTlBZfohLmgPc4POm79seOkE+k6Z8H4gcFLTdfhJcYkqUB1xdJNKkGSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746834319; c=relaxed/simple;
	bh=IrnH4f8HmeWO6uEpp3n6xPGqqWrpjkpdT8UVlvQ9kDc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qwkiDSjMQBOLQxYz9AtJaDP7HefMq37Wsuhpq6LMCJgM7cjcXJnkqt4QcS04GPgZygEj28pLwUgZfkgv/XKBIdZAQiANtuq1+H9IN0MTuEtzdvCTuDuEWA9oUQFjSScAiPcbqUPgBbutdACrHsvhLXU1VWXdsYNKQWZQ/8ZukHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jePbtod+; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746834318; x=1778370318;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IrnH4f8HmeWO6uEpp3n6xPGqqWrpjkpdT8UVlvQ9kDc=;
  b=jePbtod+z2cG//9OQlRHIKhe1Yt0g/zDASiXTvE5p5IjkgUwrAMY+SJd
   DyljpPhWNkBWArtpsH/ChS+/IA688Wr+hb0jaNE24y5oRda3Pi4DCe2uV
   3wh59ImjWP9oun6xQXgZfiDUCMFbz0yFwlirP03cmcQDGbTsWVhXr3kxL
   aQOxZA/swbhZFecLWnsU+7c1N0SS11K4+6vh/sEOlgarCT3M+YSwPXPlf
   c5NmSs0Gqke5Y+qC1pz2ZAokyl4HAdjuUphs1E+WVDFoHr86BLNuVC6Af
   k4WAi2Vvx47DaoGjufB04iulrXEttPTFwsZPQJ+UHMU1L2fnTi8RhT+SN
   w==;
X-CSE-ConnectionGUID: sCtAkZgVT+2H9Hycx1j9CA==
X-CSE-MsgGUID: Gvrl0ysHTK+6gctwcC15ZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="51336225"
X-IronPort-AV: E=Sophos;i="6.15,276,1739865600"; 
   d="scan'208";a="51336225"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 16:45:17 -0700
X-CSE-ConnectionGUID: XMJDTzwYQv2z707NhynSyg==
X-CSE-MsgGUID: 1o8yhdPhQpqwoy5Js6COpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,276,1739865600"; 
   d="scan'208";a="140829155"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 16:45:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 9 May 2025 16:45:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 9 May 2025 16:45:16 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 9 May 2025 16:45:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KWhr44eDsAX7Bh68cZgHZP6yY6m5vVRk6aWWLIlqJpsvOgLjPPmcyq45QZpWmFi5P0nw5KIiTbPC3N2NWOhDX+cgmQa8yXDbYtsv7A6nUgFAPppnNuqGE0Bfxzpt63q29+0Hi7XU4eApHymhVFF0IbzRVjgOAZiVRUEFklg7yi32L+9L9gb0MXthx/l0+kYOEz+HIjVfumEALti8AqfltqaNYVgQF9jeRpCQ5iLmPoSIHBWtQLs21BHiJup7tnFs412P9xvIth8R4Rh7ZlnLQuwSzqbBxr72WuialZr3YpaitKSOps257iJSVHYEy1IVCjOIZ3VMFeF3cbS/JPHlJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IrnH4f8HmeWO6uEpp3n6xPGqqWrpjkpdT8UVlvQ9kDc=;
 b=v4lAP9Cz2TTt4SH0M4Xkt4szvn8AssfB3eJ4+2VIRIl+0XlgDM33BwUylzUdaX1VR0ZuBXIvNvObsghScPOdiryOetLC7TQreOalU4/UJAiQyj4FGtM6SGh8cxctty9LG0bz/Ci9M5sPYnWVvzZ0x/hOFbNqxDsoDnumgP93F4MIoWy6Tl0vpkpbzFDIEMoj/fdJQ8MkfNuKEMUyn3dHv60fnv1s64o9VkdfWScIoDUxPyPoWw9Ifiz+hns2rWAIiOgX8ZV5G7JvVl5IcBBtRpuyUPW54QVNXHjuuqtWRAmcBAWpWo4z5NrUjj5IInq74XJ1aD19PepgZ6xNg/xJDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB8109.namprd11.prod.outlook.com (2603:10b6:806:2e0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.24; Fri, 9 May
 2025 23:45:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Fri, 9 May 2025
 23:45:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Du, Fan"
	<fan.du@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHbtMYat5kS3vWoBkCnVGDzEELKMbO5zpMAgAAI7ACAANlQgIAKKDEAgABHPQCAAA/NAIAAeT+AgAEy5oCAAHqYAIAAsR8AgADUaYCAANzJAIAAuGQAgACdt4A=
Date: Fri, 9 May 2025 23:45:00 +0000
Message-ID: <8d8f4d0ec970fc7c16341ee994d177d9e042c860.camel@intel.com>
References: <aBAiCBmON0g0Qro1@yzhao56-desk.sh.intel.com>
	 <CAGtprH_ggm8N-R9QbV1f8mo8-cQkqyEta3W=h2jry-NRD7_6OA@mail.gmail.com>
	 <aBldhnTK93+eKcMq@yzhao56-desk.sh.intel.com>
	 <CAGtprH9wi6zHJ5JeuAnjZThMAzxxibJGo=XN1G1Nx8txZRg8_w@mail.gmail.com>
	 <aBmmirBzOZfmMOJj@yzhao56-desk.sh.intel.com>
	 <CAGtprH9fDMiuk3JGSS12M-wFoqRj+sjdtEHJFS_5QfKX7aGkRQ@mail.gmail.com>
	 <aBsNsZsWuVl4uo0j@yzhao56-desk.sh.intel.com>
	 <CAGtprH-+Bo4hFxL+THiMgF5V4imdVVb0OmRhx2Uc0eom9=3JPA@mail.gmail.com>
	 <aBwJHE/zRDvV41fH@yzhao56-desk.sh.intel.com>
	 <CAGtprH9hwj7BvSm4DgRkHmdPnmi-1-FMH5Z7xK1VBh=s4W8VYA@mail.gmail.com>
	 <aB10gNcmsw0TSrqh@yzhao56-desk.sh.intel.com>
	 <CAGtprH8=-70DU2e52OJe=w0HfuW5Zg6wGHV32FWD_hQzYBa=fA@mail.gmail.com>
In-Reply-To: <CAGtprH8=-70DU2e52OJe=w0HfuW5Zg6wGHV32FWD_hQzYBa=fA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB8109:EE_
x-ms-office365-filtering-correlation-id: 1b63a968-4fb8-46f0-cba3-08dd8f538355
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TG5yb3lJR2ZjbStXOXBFaGR1YkZaakVuSXlCZGtDTWpzbzBVOTFLVU9xQnFF?=
 =?utf-8?B?VFhyYTZ6SitVSWUvOTZKVi9RWkU3WHYveVplTFI0UnhqeWRiK1FEb3hlS2pr?=
 =?utf-8?B?R1FGdnNVZGdzeEtBS21rSkZUOHloM0R4YzlhM1ZldTQ4dUw4dDA3NS8ydytV?=
 =?utf-8?B?aExqMTNlVm80WHpSMWhmYTVhWmxwa044ZG9VOTFjNmM3OGlpU1FOWUxDdHh3?=
 =?utf-8?B?VTJXWTZENXZSTWM1R0Q5K0p1MDVRVW40NkEzUmtDMlk5QjRIL3NVMW53bVZy?=
 =?utf-8?B?UDlySmpOMFV6SWdmUDBFa3BIYnpGVStUSVRIMlgwaldKZTVKREx5M0l1KzBV?=
 =?utf-8?B?L0krNlB5RFdydXVDMkdYSzBnT0lnQ3ZBelhSSnVVWnlMMkFMY0cxZ3ZSYWd4?=
 =?utf-8?B?REZRSVBzV0pRbGFyMUtqTGlHN1dGcUJBVk5ZTm9kTnZPRnhIankrMVJKT1Jr?=
 =?utf-8?B?ejBwd3NHS3UzTmdrUUZWdFlack5IUlV1VUhuZE9SVmtXOTBRalBRcE5IYTNF?=
 =?utf-8?B?Z2VkUCsvRVVKQ1dUOWVIOGVSc29GVGR5cy9MUkdNNnBKZnBBeFdoc08zRUsx?=
 =?utf-8?B?SXcrb0pqZG9uQXoxZGhUUE1JTm9BY3ZZdzEvaFE3S0NkaDUzS2JtT1ZNZHd1?=
 =?utf-8?B?NmhSSmFVN3Ryb2xwdVRLRC9MZzl3b2dqcTB1RDdiaXlhOUZpNVBidG9EazZk?=
 =?utf-8?B?ZHVONXdPUkZyS3lSckVkWEJ1Ly9ROVN5ZXdUZWRDbFhqOG0xNDBnQ1BFTzJw?=
 =?utf-8?B?NmE3SEp1R2VteDdOOXNJY0lkS29maDVUL2xVUk1QaDJYejhhZVdKMWFldDQ2?=
 =?utf-8?B?WG91cnIreldFTGxYeGUveUcyN0NoUjJLOG44OGh3eXEydStpSmFjclU2b0F1?=
 =?utf-8?B?NG5VbXB4b3VZQmhHdFF5ZEY0cStBdlZKZ1hRcEdJL2tQekcwc1lDVW95ejBM?=
 =?utf-8?B?MC9LNTNMVWp0andGZnpMeW1wQUpXeW1xRUVtazRxN1F0ejRGUzJKT3MwcEcv?=
 =?utf-8?B?S2dZeU1EVXk0OGYxUnBWcVJvT0tRNDdCSmZHWGxNa25BVnNPaUVtVVNLTlZ1?=
 =?utf-8?B?VkcvaHQ0S0xaWFpnYlVnNkpPaE1PWk5WTWZETTBiMm9PRGFQRC9HaUNXTEZG?=
 =?utf-8?B?L3d3VHpDbTk1dVlqSkdZOEtvRWRhMTlJYk0yTWhkc01vREk1dVcyMVJtYTFT?=
 =?utf-8?B?bzZNcGx5bjNrOTNZR05Ea05KTExnemoyT01ZU0szNnNTZnJhSDcydGtrdlFQ?=
 =?utf-8?B?ckhiWGoxSHlMZkx1VTR4VWtQelRaQnhURnNUSllpeTloZ2NabTNSdG92bmtF?=
 =?utf-8?B?OVp5N291dEJkMUFOdXdPMWNkRHc4dndlOWU0emlvTTZ3WGNhSGlKQUtYbnA1?=
 =?utf-8?B?TDVGWlBJamFIWDFCdnVrZk1xNThmdStyVHk3MnU3Y3Uvb1JxdEg2dm9zR3oz?=
 =?utf-8?B?dStCMURFSXJNbm5VaEhFUFZEOVNISU9BblFVbDlleVpLRlhEQ21iYlk0SDVz?=
 =?utf-8?B?TVZTb2VkTFRWdGJWaDZxcU1SM0s0ZTBON3RlalR1elFDeE95OEwrb3VLZnM5?=
 =?utf-8?B?cGh4NzdQV091RmU5dTVDRzZHaWpZYjQ2L21lMFVKeWQrNkVRL1RjN0dLbjl6?=
 =?utf-8?B?cWlPM2llZ01OeDg4QTJORjc1Z1ZoNCtDNUg4UDZGb0JFUUdEQ09BQlIyZURl?=
 =?utf-8?B?c1d5d3h2ZTRsbmlGR2VTUUwycUFReWhzWGNtMTV1T1lLazdQTjRMMHlaeDRN?=
 =?utf-8?B?aG1nd1NLd0xLcGFkeVo2alQ3RnVQKzN5M3dSOGwxNC9qM0hDeElySTlpRFRZ?=
 =?utf-8?B?MGtLMlFUSnhzVXJyekFCcjF5VDBFWWRheGNVbTVqR2tsSXZzeWNBVDdjdDFK?=
 =?utf-8?B?a0lDMTJ1bFk3SzZhdEJTRFo5Z3cxRklRdVM5M1VSMFMzRi92V1BUYWhtU2Rx?=
 =?utf-8?B?VHlqMXliU2lwNUhMMHVRdGxIUktSR3BjOVNJOXlWUU1CMVh6V2pUYTJYT1FM?=
 =?utf-8?Q?w5pYw76d95YchBvGNAtbkZb9KJ8Q9c=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b0V2c1BwOWdBNVZTQngyYXFpaFVZajF6Wlg0enFURThZOUVwd01zMHZGSnd0?=
 =?utf-8?B?V3FrcUpmWVIwU29yTEgwSWhWNG9LRHlFOGVvNUJIZjBtd3pvS1Y4eEszZ1FW?=
 =?utf-8?B?V0o2aWM1ZW9sWGJ0UWNFSTFKVTRES2M1akdsamZzVGdQbVBpdS9kL1ZXblZX?=
 =?utf-8?B?YU82YkNOdWRpZ29BRENzdGZzQW5BV3RSYmh0NDRnMDY5K1NhQVdYZUpoNGRC?=
 =?utf-8?B?eFptbUNzSzVNNWtRZmUvclFLNTl6TEY2SW1JQWcxaFBKWGZRTWQ2T1RhTGZq?=
 =?utf-8?B?a1lGMk9MQWJZWFdxV2xmam4wN01XZlFUaEtMSGQwL2diMDBKRGk4UEdmalBO?=
 =?utf-8?B?YzlRb3lDT1U5QnI3blQydjdFM3NPNXVYRzhUTU8xOFp2NFJzNnpPa095MWNT?=
 =?utf-8?B?eHpWSmMrRG00NG5ySVRBVDA0WTdpWnBEVCtESG10TDFjUjFDNXJJeFJ5Nms2?=
 =?utf-8?B?NjRqenFhTmIyZFhNMkpra0ZrOGp1aVpmbVdOTVB0OWV0R2xtRWRKdzMvQlVX?=
 =?utf-8?B?T055OHJUU0hySVdyK3p6cnBiRy9mV05FNkZBMHB3MGg5NWJ3VnJORVhlbWMv?=
 =?utf-8?B?ZzZROUZKK01HZDhqMzNGNjEybDdwZkt2ZzhwNThaaVl0R2xrSHdpaE1GZ3l5?=
 =?utf-8?B?WWo4UXVUUmJIQUs0bm5MOGZDa1RlNnc0NVd2TU1SNzg4SUpYUjdDS0g1cnBE?=
 =?utf-8?B?VFlTOW91SFR6VnQwQzZFUWtPRkhneitBNFFFQ0w4c1pzd2lsbmpYbjQrT04w?=
 =?utf-8?B?U3Q2WE5JTzZFWVVIMjN4UldYcDhpd1k3SWR4dmdjM1htdlFMQlFaaVdwbEox?=
 =?utf-8?B?dFZCQXZ6T1VISC9kcDRjdjdFdk4rc2JEcDZGWElpYVhRaU9LVkVmQUV3YUFL?=
 =?utf-8?B?Qkw4YTh1aTh1NGN5cHNCaGxWa3ZldDE3SWNhUnNpRjM5Q3ozcjJVVnFxM1cy?=
 =?utf-8?B?WktQYmJ0N3V1Z0duU2VMMC9HQkZwVEtiRlNxUDBOcG8rVG1jTWlkZVdPY1ZO?=
 =?utf-8?B?dTV5dVl2aTVaM2FyZHZhcm84S1BHT0Qxek4vN0JZTnRZOXpNMTFvSTMvVzZM?=
 =?utf-8?B?dEdRZTFrRTEyUWI2dTcwMStoMWdQYWVRbEN0Vnhva00yaWZURnRBYWx6R0Ew?=
 =?utf-8?B?ZDZRY0RlVzlNNHpwVHdqYUp5RXI2TmZMYUR0ZG12cnh6VjlZTVhmOWxjckh5?=
 =?utf-8?B?NGJUb1FyamRsVVgyMHJFQWpzUGxLTUpnU1crZHhVU3JQOXhOTWo0OW40bzdH?=
 =?utf-8?B?Z2xTSGg5b01XUXFoZDQydW83L3YrQ2VmeXlJUWx1OFJKU1lCSnZ3UU9tQnAr?=
 =?utf-8?B?VTd1UGJpeFRUYW9RNE0vTDNpTlhOUW9IbXBJck9zRlNXY1pwdlkxSUs5dkR6?=
 =?utf-8?B?Q0ZkbVlQNXA2czBzT0xJN09vWjd0cUJ5YkdBUFA0V3BmZUJuK0lnc01XakVB?=
 =?utf-8?B?U2d2bCtlYU5FUXRIN2JoRVUrdm1TNzNnK2tVNFNVNmJmSlJIQ3BxYm14eHRy?=
 =?utf-8?B?OGw0S3RrNnhsYURVQ2FvTXBzRFgvOG9Ya1JRd1dWVm9TcGRQNkZlVTRUNVFh?=
 =?utf-8?B?THozU0plRklpamhoWkduTElSa29WT2NJRmJSaFpOQzNGYk5xOUNtTnpyRmZa?=
 =?utf-8?B?RitvM0tqMTY1ZWRoZy9rU1Y4Nno5Qk9jLzFaY3N4OXJySnNjT0pYMXF5ZTNW?=
 =?utf-8?B?YUN3K1FLOE5BZTJoZEJ0anMxMG5TcXM0NExoS1MyU1pMNzh5Z0JCMVNSZVhz?=
 =?utf-8?B?Qkdtb3lJYVZwakRvRlgramM1bGZodGtZNUpITTJ3Y0lnR2JjdzZpR0FhaGc5?=
 =?utf-8?B?VzhRNWhSVWdVOFRIRDdJblRRQTQ4ellhWldSbkMwNU1lei9CZzNObnZ4endF?=
 =?utf-8?B?R0lxTjdlQ29OV3RuMGdHVThsY0dKd3JiQzVjdnpSanpMbDM1Y1JFaGdXQ0pZ?=
 =?utf-8?B?NTRCWGdxVTlSSFFJUU5HbGxxcDJvZ1Y1b1dDbkhRK1lKbVkxU1UrV2hXZHZO?=
 =?utf-8?B?b1ArQ3NkN1dJYkNIaStsdmR2Zkx2NE5uNUlQR1U4c1FwL2s2VkpMdmV4ZWl3?=
 =?utf-8?B?R3hvL2ovMy8vUU40OHhDUHlCZGJYVzgwcllTUGVtbUhodVFYUDFtZm1tWXlM?=
 =?utf-8?B?bXE5UkJnWTdkSmxpczJKbnZyTTFXUmpUWVJnUk1zdVpraGwzL1RJclArVGNu?=
 =?utf-8?B?akE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D21B4FD0CED4F54585CAEA1F7697EFFF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b63a968-4fb8-46f0-cba3-08dd8f538355
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2025 23:45:00.4522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XbHUjNnTGwCWm/cthAUgv3Ql3cPBSSHVmbvblSSNs9xmmENXK0xNcty0csS3MCpC10BseFr0lPd9rp92Ici72A6fZb9AbR3WRenpcc6n/ps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8109
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTA5IGF0IDA3OjIwIC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiBJIG1pZ2h0IGJlIHdyb25nbHkgdGhyb3dpbmcgb3V0IHNvbWUgdGVybWlub2xvZ2llcyBo
ZXJlIHRoZW4uDQo+IFZNX1BGTk1BUCBmbGFnIGNhbiBiZSBzZXQgZm9yIG1lbW9yeSBiYWNrZWQg
YnkgZm9saW9zL3BhZ2Ugc3RydWN0cy4NCj4gdWRtYWJ1ZiBzZWVtcyB0byBiZSB3b3JraW5nIHdp
dGggcGlubmVkICJmb2xpb3MiIGluIHRoZSBiYWNrZW5kLg0KPiANCj4gVGhlIGdvYWwgaXMgdG8g
Z2V0IHRvIGEgc3RhZ2Ugd2hlcmUgZ3Vlc3RfbWVtZmQgaXMgYmFja2VkIGJ5IHBmbg0KPiByYW5n
ZXMgdW5tYW5hZ2VkIGJ5IGtlcm5lbCB0aGF0IGd1ZXN0X21lbWZkIG93bnMgYW5kIGRpc3RyaWJ1
dGVzIHRvDQo+IHVzZXJzcGFjZSwgS1ZNLCBJT01NVSBzdWJqZWN0IHRvIHNoYXJlYWJpbGl0eSBh
dHRyaWJ1dGVzLiBpZiB0aGUNCj4gc2hhcmVhYmlsaXR5IGNoYW5nZXMsIHRoZSB1c2VycyB3aWxs
IGdldCBub3RpZmllZCBhbmQgd2lsbCBoYXZlIHRvDQo+IGludmFsaWRhdGUgdGhlaXIgbWFwcGlu
Z3MuIGd1ZXN0X21lbWZkIHdpbGwgYWxsb3cgbW1hcGluZyBzdWNoIHJhbmdlcw0KPiB3aXRoIFZN
X1BGTk1BUCBmbGFnIHNldCBieSBkZWZhdWx0IGluIHRoZSBWTUFzIHRvIGluZGljYXRlIHRoZSBu
ZWVkIG9mDQo+IHNwZWNpYWwgaGFuZGxpbmcvbGFjayBvZiBwYWdlIHN0cnVjdHMuDQoNCkkgc2Vl
IHRoZSBwb2ludCBhYm91dCBob3cgb3BlcmF0aW5nIG9uIFBGTnMgY2FuIGFsbG93IHNtb290aGVy
IHRyYW5zaXRpb24gdG8gYQ0Kc29sdXRpb24gdGhhdCBzYXZlcyBzdHJ1Y3QgcGFnZSBtZW1vcnks
IGJ1dCBJIHdvbmRlciBhYm91dCB0aGUgd2lzZG9tIG9mDQpidWlsZGluZyB0aGlzIDJNQiBURFgg
Y29kZSBhZ2FpbnN0IGV2ZW50dWFsIGdvYWxzLg0KDQpXZSB3ZXJlIHRoaW5raW5nIHRvIGVuYWJs
ZSAyTUIgVERYIGh1Z2UgcGFnZXMgb24gdG9wIG9mOg0KMS4gTW1hcCBzaGFyZWQgcGFnZXMNCjIu
IEluLXBsYWNlIGNvbnZlcnNpb24NCjMuIDJNQiBodWdlIHBhZ2Ugc3VwcG9ydA0KDQpXaGVyZSBk
byB5b3UgdGhpbmsgc3RydWN0IHBhZ2UtbGVzcyBndWVzdG1lbWZkIGZpdHMgaW4gdGhhdCByb2Fk
bWFwPw0KDQo+IA0KPiBBcyBhbiBpbnRlcm1lZGlhdGUgc3RhZ2UsIGl0IG1ha2VzIHNlbnNlIHRv
IG1lIHRvIGp1c3Qgbm90IGhhdmUNCj4gcHJpdmF0ZSBtZW1vcnkgYmFja2VkIGJ5IHBhZ2Ugc3Ry
dWN0cyBhbmQgdXNlIGEgc3BlY2lhbCAiZmlsZW1hcCIgdG8NCj4gbWFwIGZpbGUgb2Zmc2V0cyB0
byB0aGVzZSBwcml2YXRlIG1lbW9yeSByYW5nZXMuIFRoaXMgc3RlcCB3aWxsIGFsc28NCj4gbmVl
ZCBzaW1pbGFyIGNvbnRyYWN0IHdpdGggdXNlcnMgLQ0KPiDCoMKgIDEpIG1lbW9yeSBpcyBwaW5u
ZWQgYnkgZ3Vlc3RfbWVtZmQNCj4gwqDCoCAyKSB1c2VycyB3aWxsIGdldCBpbnZhbGlkYXRpb24g
bm90aWZpZXJzIG9uIHNoYXJlYWJpbGl0eSBjaGFuZ2VzDQo+IA0KPiBJIGFtIHN1cmUgdGhlcmUg
aXMgYSBsb3Qgb2Ygd29yayBoZXJlIGFuZCBtYW55IHF1aXJrcyB0byBiZSBhZGRyZXNzZWQsDQo+
IGxldCdzIGRpc2N1c3MgdGhpcyBtb3JlIHdpdGggYmV0dGVyIGNvbnRleHQgYXJvdW5kLiBBIGZl
dyByZWxhdGVkIFJGQw0KPiBzZXJpZXMgYXJlIHBsYW5uZWQgdG8gYmUgcG9zdGVkIGluIHRoZSBu
ZWFyIGZ1dHVyZS4NCg0KTG9vayBmb3J3YXJkIHRvIGNvbGxlY3RpbmcgbW9yZSBjb250ZXh0LCBh
bmQgdGhhbmtzIGZvciB5b3VyIHBhdGllbmNlIHdoaWxlIHdlDQpjYXRjaCB1cC4gQnV0IHdoeSBu
b3QgYW4gaXRlcmF0aXZlIGFwcHJvYWNoPyBXZSBjYW4ndCBzYXZlIHN0cnVjdCBwYWdlIG1lbW9y
eSBvbg0KZ3Vlc3RtZW1mZCBodWdlIHBhZ2VzIHVudGlsIHdlIGhhdmUgZ3Vlc3RtZW1mZCBodWdl
IHBhZ2VzLg0K

