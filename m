Return-Path: <kvm+bounces-63538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AA55C68E8B
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 11:49:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F17DD4E6F49
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 10:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70F83191C2;
	Tue, 18 Nov 2025 10:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LNAtzGkl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEBF311C3C;
	Tue, 18 Nov 2025 10:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763462977; cv=fail; b=jEov/5DJNbzuXq52w0QARMOPeaA2zDUcAb1kK5lnlo4VgeF4TaiB63EOuDyekQCFDn/LYEFV6sG4MqzmU4CGwHkeXYpBt7QhriCT3k95dlfHImNbNB/LhDEonnnkhQkEiZT5zJOOpvefElK3cgi5+PNV3YX3VR+6jF5ydvvWkuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763462977; c=relaxed/simple;
	bh=4oEx736E3pOrfW7upjMBct45eM4YuyxZiHyy12N60EI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cN+Tm9fzh+4XzyHbIZeY4RZiESlqQmgdrtfLHezBRc+vywm8Hw2sgrI5bhJaRrOUpe3p/d5MkGPGbFknrPKdTQiM5Dh7TfpLmU3Ok7Uwiv6Ao3mFjAJ6x1syH7OtdCRU2MJtWpVFSBhRr5YGUaehN+vi+eawYUONqI4qGlxWCYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LNAtzGkl; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763462976; x=1794998976;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4oEx736E3pOrfW7upjMBct45eM4YuyxZiHyy12N60EI=;
  b=LNAtzGkl8ESj/aQozwj5OUQxb6uaihamGzBllz8CRpfMtLIkMmse5eNn
   OmsbyR7FIQdNFA6Px48yPi9TIFBTsSR4UUHcI9dwMWk8zR+yTNu9k6y4G
   iyYezIbR+WQkI2KnJgLF2w3MphUisXqFDUU1p3iynjIi3m5gYHkdBIu1H
   6Y1+vHRWPKU8/Iw8dMZCSvMPqLo9umIvdoJICpKF1hbL2cLsySXIb4ufb
   gj+dDxALaQbwxRc1I8apY0fG3q0EEPQGT6qeTS1ErfpOEYQLkP5NI5Ezv
   4m3u8Ho4LVxdiI3Mc7duL+dOc0kSXn89vMFeiGsQJ5SyLRQkDp2bBSwg5
   w==;
X-CSE-ConnectionGUID: mxVa+hgkTbOTNcFFJH/2sQ==
X-CSE-MsgGUID: CRBDTAAhRfWrrhOOygRO7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="65380949"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="65380949"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 02:49:35 -0800
X-CSE-ConnectionGUID: IDypdrcGSRe5qefK4W3NfA==
X-CSE-MsgGUID: 4MJBlgiXRZCXTFs/ALYnWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="228063973"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 02:49:35 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 02:49:34 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 02:49:34 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.21) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 02:49:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tdVTf18WTfDqHF6cflly5L33QAINlG9mgDgbWiK+JdZgKakEnpI9PAUDDwhxc/zQfZpbxLlULyzLBcc1ST5bruJRaBJ4QzocilNfNicTsteuQVcBENyfYFB6Y4i6jyzugAxQtN4HLGUh5kf3RvWsRD8bOTKNdkUbqHh9G+8mxMTTnAQV953hPRP0sb/xtZmPqG+OBg1FhRzJcoZwzD/LtHTbUKsKUCWUlsUnjxtek1ipieZ0P55y1KlF6XTC3j52ySNFV0j4v0vAzogVX/1vXYvjg6Plfj6VnEp3BROewvZ302DhJnmxC7lHlLLth7+mi0BcM+lu/VZsieMqaC2T1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4oEx736E3pOrfW7upjMBct45eM4YuyxZiHyy12N60EI=;
 b=bdEJCTzd76bwxAsgsRVKpOwlXMnjXnRDvJ0H8ki6VREY8UQdphmEmuj9cJKY2keY9iAeCDikbRlKh36a9BW8Ji4NWy05YtJyR89YeGvEwVH6zAi7OpURP6h9SaGu9LxayrXRxd46wZzhk/g9AylW1cD/kIY40tD0gO+fQF3kEmHaB6WPbONbkfMy9povSxH7pWTDnm7raYpx/66Q+co4VmTDfhZPz8+XTxRYCTS5DvvaNxAvKtfSDJuIyVdMH1QwknDLK0Il8kmMpy/k10iP164MQhr6hBYoJHJ4qIYS4AHVDf+Kb8hwNullAtlj7Kha+dyhrFNpSY5xiu7RLM58HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA1PR11MB9517.namprd11.prod.outlook.com (2603:10b6:208:5b1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Tue, 18 Nov
 2025 10:49:32 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 10:49:32 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "kas@kernel.org"
	<kas@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Topic: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Index: AQHcB4AQJSSoQW12Bkmtr+PwbHPEybTt4N2AgAMGZYCAACPdgIABQHwAgAXl7QCAAGkwgIAASE+A
Date: Tue, 18 Nov 2025 10:49:31 +0000
Message-ID: <35fd7d70475d5743a3c45bc5b8118403036e439b.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094358.4607-1-yan.y.zhao@intel.com>
	 <0929fe0f36d8116142155cb2c983fd4c4ae55478.camel@intel.com>
	 <aRWcyf0TOQMEO77Y@yzhao56-desk.sh.intel.com>
	 <31c58b990d2c838552aa92b3c0890fa5e72c53a4.camel@intel.com>
	 <aRbHtnMcoqM1gmL9@yzhao56-desk.sh.intel.com>
	 <f2fb7c2ed74f37fdf8ce69f593e9436acbdd93ee.camel@intel.com>
	 <aRwSkc10XQqY8RfE@yzhao56-desk.sh.intel.com>
In-Reply-To: <aRwSkc10XQqY8RfE@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA1PR11MB9517:EE_
x-ms-office365-filtering-correlation-id: 0186d292-62c7-4803-d999-08de269027e6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?N21pVDB1azA3MFFjcTkwWlJKbjNBUWlwcWo2R2NwNnVwVzBidzFzMDArRDRR?=
 =?utf-8?B?bWxYTm40UWt2N3RwMTZxZ28rMTZUcWhobllFS0MrTUJDVWQxMUdERXBjYnh5?=
 =?utf-8?B?SytPOTB0bklLZm9QQ1phaUJMNnFBckNDTFFZMzVOWU10KzVXVXJ4dmdrQ0Ux?=
 =?utf-8?B?WGpycmVYQlpvRWNYRjE3cGdndnZ1a0RnbjMzbEYvdy90S0hEcjVyT3lQclRO?=
 =?utf-8?B?OUlTSGpDZ2hQRWdkbTlXUEpLTzNld0UzVmFpRlhaYnJlRlNNNXFTVHZvek5q?=
 =?utf-8?B?NzNaSmt3VEM5bmdQcy9CQWMrRFJoNEQ4WDE2UjFJTDRoc1Eza1hIWDVEK0Yv?=
 =?utf-8?B?N3BFZS9DdnlIMUsxQko0ZjdwSXhROVRKZS9WRGlnRm1EVEhub0N4SzFJS0dX?=
 =?utf-8?B?ZTJRY0J5RTY2dGFOeWNhbDM5bDRBRGs1SzBOQnp0TjAvZ2lSK040SGVHVkpw?=
 =?utf-8?B?K3hqYmhsSjQ4ZmJCY3NxbUloVDVibHNtNDZBb2ptTXl2bEFkSU5WcTFqSlNV?=
 =?utf-8?B?aG92Tjd5ZExjaExSYVhENmVrQzc5ZFJRdVNlb1dKSjBYZmZETitReGlLaFRO?=
 =?utf-8?B?eUt0VjJzNDBjc0xJenJDYmRlckcwcnZZU29sdzlqWklGZFN2YmdHOWhnaEIw?=
 =?utf-8?B?S21KYW1tWnVNRmYza3JUN0l0QjAzNlVRQTNrNEFqejQyWlpmb2RtVDRjZDlK?=
 =?utf-8?B?eUhKQXRkMHBqQ1pwUXhhbXExRDVWd2FOR3A4VnR4dDY0S0JDbjB0MGNXMHdj?=
 =?utf-8?B?WS9tVnZaanErZ01Ld0hFZWwyOWJsb1hSQTM2dncvRC92cnplMDdpK0JUdXZ6?=
 =?utf-8?B?ZFB2blhma1I3bEpYNmd4U2JBT29YU2RpTUpNUTJacEpPYmozcWE0b3hKVGdE?=
 =?utf-8?B?dzNYUkNjbW1GMFp1dU1jaVJHOUN3K2ZGeU43Q2RVd3orbDBtVEhnTi9KZzBi?=
 =?utf-8?B?YW5Kd3RSazJEZ244enFNTGV4YzVCZFFRWmNuUm5heW11M0RZaDN4c3RRNGw0?=
 =?utf-8?B?dmhTdksvdjJoaUVBVDlEd2VnMmYvcTNrVXVkWHRCZHloVWo5d0VFUjIxWjMz?=
 =?utf-8?B?MTBmSGV3OTlLMVYvWjRNWjcyZGZKN3Q1b0VLSVBFRkJPWWhrRXhuOVNHaUor?=
 =?utf-8?B?enpsNkRaK2lreGZFd3dMUHNHOHo0VWczTXJ2ZHE0Mzc4bUdlVW5YRjdmRHJ2?=
 =?utf-8?B?dVhaMFJVbHdjeHd5M1YwM2VlVEw0MERvRzRYV3lhcVAvZW9RL2xwazA0bUNX?=
 =?utf-8?B?bE91SHVXQWJKeE1zcmk3Umg4WS9Va1VMZkVOdzhudjNndW9QeU5RSFp2eEVR?=
 =?utf-8?B?UzlEWmJkeTExRVRGSGlPTXJWS2ErNEhhRXMzL2V1ZFN2Y3ZYNDF5Ryt2OGFn?=
 =?utf-8?B?akFrODVuejZOS1FRRW00ZXdQYlp1cWdYWC9zK3U3OUhIZnNUKzdVQXVWMGlG?=
 =?utf-8?B?eGhxTCtsQTM0dE9VdVhTMko2Um5IQ1NRZi9ldDJvM25sTXorMysyRFUrRUI0?=
 =?utf-8?B?Y2lNdG1qcnNGR2ROSVhEV0ZtOFh5UHR3Z3Z3c1hxLzlOU3ZtMzdhU2g3L2Y3?=
 =?utf-8?B?NmxhRUlON3dLcitBQzNoTjlqL2RzbTQzRW52Uk1WaTYvQjNCWFB5NTYzZEpD?=
 =?utf-8?B?S2ZZQWxiOUVrS0tZTkU1MmEyaHZOMEJxTE1oMldQclhZYTlJRWl5bnhBUkhI?=
 =?utf-8?B?VGZTdmJZOHpndkxpaGtLYjZFczlOalhUSnpoWm9RekN1RHFBQlRTOUxrcUNx?=
 =?utf-8?B?RkZxVXRNVG4wZXZ6bktrcUJBR0VUQ1lvS2NtUTBuUHl6WG9iZ2tKVDRFVlU1?=
 =?utf-8?B?WGV6OUJVZWcwNWgweTlFdmszb2VzNzJ6ekdmTzVKcWxuUnZ6V1VlRmdxb1dY?=
 =?utf-8?B?VnRFNlNkKzFQNThhemtFdXg5Q2FxWnJya3pDUTBHck5NOUcwWTNoRHhKRWlB?=
 =?utf-8?B?VUk4dXloRFI0VW9ZZXhMTjdYL0QrbmxGc2dKSDgxQ2tZMUhuem1iMXlsazB5?=
 =?utf-8?B?WDZwTzVlQ1haRkpRcm8rQlhRSlhhVFBobm9EMDl2UWJCcUlMYWlBajRPcG1u?=
 =?utf-8?Q?HRMNNE?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SStVQXl3NWh2Q2VodTZKZyt1WjFVRmdHc0VNUEU2ZC9pRC9JRUlSSHRiM3V2?=
 =?utf-8?B?QlJhaTMzZXpnZkx6Zi8zaHBUcUJ4dndMOW1TdXRuQndlUlg5OUI0U0tTMDBI?=
 =?utf-8?B?Y1lhK1o4c1FSZDlHbkZoalQxZFhQRS9JSWNtT0RsTURoS3NWanVhRkt5L0pq?=
 =?utf-8?B?L25yZi9rdU44STdoOTZ4WmpCRGZkRjdSZ1gwYXlUeWNsR1c4amlmTEhnazFR?=
 =?utf-8?B?bGRZOFJlbHluZEhMRm12V2c4bVZNaks5M0g0Zk0yNm5hVllrYTBTTjdXaktY?=
 =?utf-8?B?WHdaM3M2YkRsZjNnREdvaUtjZ09CbmtkY2dRWTlDTWJETTVIUUxQQVhMZnRz?=
 =?utf-8?B?ZlkrNzh0d01tRjduUmQrdGtJYTJUNFZMUXN3RENOdVZJNFRLUTlyb01UNHVO?=
 =?utf-8?B?dlB1SnRGcVZGbnlxV2hHSmNqQlA2MVUyM0ZUMkVRUnVLYjBSdmx4bkFkSXdq?=
 =?utf-8?B?cDF4TGV6Y2xXZXFxaUwzUXNSUytzTXhLdlhHaEdwUEZ5U0lGNnpRQ2FmYTFa?=
 =?utf-8?B?cmhyaElzZ2FCY1cvUTJvTml6Vk5pZU8yaUMxQjlVeFl3Q0Z1K3FmM1J1aHJt?=
 =?utf-8?B?ekdwb1ZZa3BDMDRKcTZ2a0hUbnp6VnJFaW9sbGJKeWUrTTdUSFpBQ2dNaC9S?=
 =?utf-8?B?d3pDUUJud0tuUzkrbERlN3NEeTdlc0hkWXpnMi9wRjBPTmNad3FRZUMxd2Rw?=
 =?utf-8?B?MHJXT3N6QUE0LzJBRDBmTnZxeWlEbjNGbC9BUFcxUmxKZGxVYUlOeE9TbXRJ?=
 =?utf-8?B?UVhON0JUVzAyamgrRmtRN2tYQXVqcExQcGxhUmI3L2VBSkdLK0hRc2xPNHI1?=
 =?utf-8?B?dmZiaUp1aHRkOFBMQnhXbGlQSW1vUlg0OFF0ek5qdERXRlhwa2FSWGZRU2ZT?=
 =?utf-8?B?blZUb21pb2RLcVNUVGRuLzVrR0JDYjRqYjdWekJVWGw4cXBQOXdROTV5aEZq?=
 =?utf-8?B?TnMxQzRTNG1DbUcxcndxV3kxY2dMN3JYOVpFcStCMFR1a2k2bXFUSXliZUJ6?=
 =?utf-8?B?OVd4dUcybE4weXNiZ1o0bXEvbkc5c0x5UVJnSkpFVm1ya1VKVEMwRHQ4YjNj?=
 =?utf-8?B?ZFBvakF2N2FBSlVvR0EwZnZZYW5vbi96aXJ3VUNPRkltM0VtRmg3YjV0MmdJ?=
 =?utf-8?B?VkJnSWtZelljZkpsQXZXUE1JOEE4KzZDR0pKVkJkL05LTE5yTDNMUUlVSnl6?=
 =?utf-8?B?TVlSTVQ2LytubFQrMkY5R3lseE1wVXBaVWJJMi84eFU1aFYxWEw2WU9YdHJw?=
 =?utf-8?B?T1lQUHl0UlRFRkIrWG9rSm5VSlJSdTZVSmpPc2RKZmQ2SVhiU1JyUU90Q1o5?=
 =?utf-8?B?bmhIZ0Z5ajFkSENzTHhMRzBSTXBFaG1EL2x5VXdhZW1GVU9uVWNBQjBFOEpr?=
 =?utf-8?B?VDc0ai92YkFieVRnaFBBcHRsRHA1dGhBUFlDcU0xeCtSZ0laZ2MyUEp0eEEr?=
 =?utf-8?B?ZVNBTkJkcDFDcFhldXg4cFVDcVBPSmhPUGxWQ3ZqNjFmL1RPcks2Y0lnWTRH?=
 =?utf-8?B?TUlqM0F1dFlUd00rRTlCbW5OTUl2VjJiTHpvOUJ2T29yRFZkOTBqRk5pU3gy?=
 =?utf-8?B?bUorYzI5R2ZGMUwvS1lNbGd6ZmRNYmsydjdQOVFxbDlSY1gyTmx4cEVSVVdx?=
 =?utf-8?B?K1JrdTBqNkZZQmN6K0d4ZnQycFBSTmtad2FDSVh3N2JPR2hNeEV3aFo1eDlU?=
 =?utf-8?B?REc2dzZPdlpPYWNVc3dtdUZVMVpJZzU3OTRaQkIxRXRjbkUvbC9KZjM4Qy9E?=
 =?utf-8?B?cXNtU3k5SUxZYVVWZmMzTXBIYVhaSFRKcW9PdG1FVExWNnJOWUpsemhaNS9h?=
 =?utf-8?B?VUpqT1hXcnFtcStRWEFnbDJaQUp0Vm04VXRkcGVBT01ZOWlDZk9HclQxalQ4?=
 =?utf-8?B?U2VCY2pJNnhvQ1JwSFRkNmZDUXdOa0pvTzRPb3hPaGowSFBlUXM0VnVkRVpB?=
 =?utf-8?B?WW5vNzdoajVoNFZvRGdvZC9OQURBWFRDSzRLYnZQZVVYNFIzK3ZkR2xBWUdh?=
 =?utf-8?B?YmdwTGVRQ2s1Q0gybDFOOUlxZ2JUbE9QUGg1Nnphb1p0NUhFdkx1aDNiUHVQ?=
 =?utf-8?B?OGJpVmdCRnNyWUd5cXNwTW1OMk1BR2dWSThRSk9XYmdsV3NWWVlzYVRRUWQz?=
 =?utf-8?Q?FN1aCZCWliXTT4TY1D2SUU6qf?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <44EB6AE7A180004C928BC46A7216FC7D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0186d292-62c7-4803-d999-08de269027e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2025 10:49:31.9180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s2epQxVTeLwrp+mAWUNqPwCLbRF5NXx3JQqQoGnLvA/OlmRI8LYvDDi8mkzKlev4hyx5dmgBJ27cATvfHVvw2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB9517
X-OriginatorOrg: intel.com

PiA+IA0KPiA+IC0gRm9yIG5vbi1URFggY2FzZSAoJ29ubHlfY3Jvc3NfYm91bmRhcnkgPT0gZmFs
c2UnKToNCj4gPiANCj4gPiBBRkFJQ1QgdGhlIG9ubHkgdXNlciBvZiB0ZHBfbW11X3NwbGl0X2h1
Z2VfcGFnZXNfcm9vdCgpIGlzICJlYWdlciBodWdlcGFnZQ0KPiA+IHNwbGl0dGluZyIgZHVyaW5n
IGxvZy1kaXJ0eS4gIEFuZCBwZXIgcGVyIHRoZSBjdXJyZW50wqBpbXBsZW1lbnRhdGlvbiB0aGVy
ZSBhcmUNCj4gPiB0d28gY2FsbGVyc8Kgb2YgdGRwX21tdV9zcGxpdF9odWdlX3BhZ2VzX3Jvb3Qo
KToNCj4gPiANCj4gPiAgIGt2bV9tbXVfdHJ5X3NwbGl0X2h1Z2VfcGFnZXMoKQ0KPiA+ICAga3Zt
X21tdV9zbG90X3RyeV9zcGxpdF9odWdlX3BhZ2VzKCkNCj4gPiANCj4gPiBCdXQgdGhleSBhcmUg
Ym90aCB2b2lkIGZ1bmN0aW9ucyB3aGljaCBuZWl0aGVyIHJldHVybiB3aGV0aGVyIGZsdXNoIFRM
QiBpcw0KPiA+IG5lZWRlZCwgbm9yIGRvIFRMQiBmbHVzaCBpbnRlcm5hbGx5Lg0KPiBBY3R1YWxs
eSBjYWxsZXJzIG9mIHRoZSB0d28gdm9pZCBmdW5jdGlvbnMgZG8gdGhlIFRMQiBmbHVzaCB1bmNv
bmRpdGlvbmFsbHkNCj4gaW4gdGhlIGVuZCwgaS5lLCBpbg0KPiBrdm1fbW11X3Nsb3RfYXBwbHlf
ZmxhZ3MoKSwNCj4ga3ZtX2NsZWFyX2RpcnR5X2xvZ19wcm90ZWN0KCksIGFuZA0KPiBrdm1fZ2V0
X2RpcnR5X2xvZ19wcm90ZWN0KCkpLg0KDQpZZWFoLCBJIGRpZG4ndCBjYWxsIHRoaXMgb3V0Lg0K
DQo+IA0KPiA+IFNvIEkgYW0ga2luZGEgY29uZnVzZWQuDQo+ID4gDQo+ID4gUGVyaGFwcyB5b3Ug
bWVhbiBmb3IgInNoYXJlZCBtZW1vcnkgb2YgVERYIGd1ZXN0IiwgdGhlIGNhbGxlciB3aWxsIGFs
c28gcGFzcw0KPiA+ICdvbmx5X2Nyb3NzX2JvdW5kYXJ5ID09IHRydWUnIGFuZCB0aGUgY2FsbGVy
IG5lZWRzIHRvIHBlcmZvcm0gVExCIGZsdXNoPw0KPiBTb3JyeSBmb3IgdGhlIGNvbmZ1c2lvbi4g
DQo+IA0KPiBDdXJyZW50bHkgJ29ubHlfY3Jvc3NfYm91bmRhcnkgPT0gdHJ1ZScgaXMgb25seSBm
b3IgVERYIHByaXZhdGUgbWVtb3J5Lg0KPiANCj4gUmV0dXJuaW5nIGZsdXNoIGlzIGJlY2F1c2Ug
a3ZtX3NwbGl0X2Nyb3NzX2JvdW5kYXJ5X2xlYWZzKCkgaXMgcG90ZW50aWFsbHkNCj4gcG9zc2li
bGUgdG8gYmUgaW52b2tlZCBmb3Igbm9uLVREWCBjYXNlcyBhcyB3ZWxsIGluIGZ1dHVyZSAodGhv
dWdoIGN1cnJlbnRseQ0KPiBpdCdzIG9ubHkgaW52b2tlZCBmb3IgVERYIGFsb25lKS4gIFdoZW4g
dGhhdCBvY2N1cnMsIGl0J3MgYmV0dGVyIHRvIHJldHVybiBmbHVzaA0KPiB0byBhdm9pZCB0aGUg
Y2FsbGVyIGhhdmluZyB0byBkbyBmbHVzaCB1bmNvbmRpdGlvbmFsbHkuDQoNCkV4YWN0bHkgd2hh
dCAiZnV0dXJlIiBjYXNlcyBhcmUgeW91IHJlZmVycmluZyB0bz8NCg0KV2h5IGRvIHdlIG5lZWQg
dG8gY29uc2lkZXIgaXQgKk5PVyo/DQoNCj4gDQo+IEFub3RoZXIgcmVhc29uIGlzIHRvIGtlZXAg
Y29uc2lzdGVuY3kgd2l0aCB0ZHBfbW11X3phcF9sZWFmcygpLCB3aGljaCByZXR1cm5zDQo+IGZs
dXNoIHdpdGhvdXQgZGlmZmVyZW50aWF0ZSB3aGV0aGVyIHRoZSB6YXAgaXMgZm9yIGEgbWlycm9y
IHJvb3Qgbm90IG5vdC4gU28sDQo+IHRob3VnaCBrdm1fbW11X3JlbW90ZV9mbHVzaCgpIG9uIG1p
cnJvciByb290IGlzIG5vdCBuZWNlc3NhcnksIGl0J3MNCj4gaW50ZW50aW9uYWxseSBsZWZ0IGZv
ciBmdXR1cmUgb3B0aW1pemF0aW9uLg0KDQpZb3UgbWVhbiBub24tYmxvY2tpbmcgREVNT1RFIHdv
bid0IG5lZWQgdG8gZmx1c2ggVExCIGludGVybmFsbHkgd2hlbiBzcGxpdHRpbmcNCmJ1dCB0aGUg
Y2FsbGVyIG5lZWRzIHRvIGRvIHRoZSBmbHVzaD8NCg0KQW55d2F5LCBhbGwgb2YgYWJvdmUgYXJl
IG5vdCBtZW50aW9uZWQgaW4gdGhlIGNoYW5nZWxvZy4gIEkgdGhpbmsgd2UgbmVlZCBhDQpjbGVh
ciBleHBsYW5hdGlvbiBpbiB0aGUgY2hhbmdlbG9nIHRvIGp1c3RpZnkgdGhlIGNoYW5nZS4NCg0K
PiANCj4gPiBbLi4uXQ0KPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gU29tZXRoaW5nIGxpa2UgYmVs
b3c6DQo+ID4gPiA+IA0KPiA+ID4gPiBAQCAtMTU1OCw3ICsxNTU4LDkgQEAgc3RhdGljIGludCB0
ZHBfbW11X3NwbGl0X2h1Z2VfcGFnZShzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdA0KPiA+ID4gPiB0
ZHBfaXRlciAqaXRlciwNCj4gPiA+ID4gIHN0YXRpYyBpbnQgdGRwX21tdV9zcGxpdF9odWdlX3Bh
Z2VzX3Jvb3Qoc3RydWN0IGt2bSAqa3ZtLA0KPiA+ID4gPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHN0cnVjdCBrdm1fbW11X3BhZ2UgKnJvb3QsDQo+ID4gPiA+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ2ZuX3Qgc3RhcnQsIGdmbl90
IGVuZCwNCj4gPiA+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBp
bnQgdGFyZ2V0X2xldmVsLCBib29sIHNoYXJlZCkNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBpbnQgdGFyZ2V0X2xldmVsLCBib29sIHNoYXJlZCwNCj4g
PiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBib29sIG9ubHlf
Y3Jvc3NfYm91bmRhcnksDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgYm9vbCAqc3BsaXQpDQo+ID4gPiA+ICB7DQo+ID4gPiA+ICAgICAgICAgc3RydWN0
IGt2bV9tbXVfcGFnZSAqc3AgPSBOVUxMOw0KPiA+ID4gPiAgICAgICAgIHN0cnVjdCB0ZHBfaXRl
ciBpdGVyOw0KPiA+ID4gPiBAQCAtMTU4NCw2ICsxNTg2LDkgQEAgc3RhdGljIGludCB0ZHBfbW11
X3NwbGl0X2h1Z2VfcGFnZXNfcm9vdChzdHJ1Y3Qga3ZtICprdm0sDQo+ID4gPiA+ICAgICAgICAg
ICAgICAgICBpZiAoIWlzX3NoYWRvd19wcmVzZW50X3B0ZShpdGVyLm9sZF9zcHRlKSB8fA0KPiA+
ID4gPiAhaXNfbGFyZ2VfcHRlKGl0ZXIub2xkX3NwdGUpKQ0KPiA+ID4gPiAgICAgICAgICAgICAg
ICAgICAgICAgICBjb250aW51ZTsNCj4gPiA+ID4gIA0KPiA+ID4gPiArICAgICAgICAgICAgICAg
aWYgKG9ubHlfY3Jvc3NfYm91bmRhcnkgJiYgIWl0ZXJfY3Jvc3NfYm91bmRhcnkoJml0ZXIsIHN0
YXJ0LA0KPiA+ID4gPiBlbmQpKQ0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICBjb250
aW51ZTsNCj4gPiA+ID4gKw0KPiA+ID4gPiAgICAgICAgICAgICAgICAgaWYgKCFzcCkgew0KPiA+
ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICByY3VfcmVhZF91bmxvY2soKTsNCj4gPiA+ID4g
IA0KPiA+ID4gPiBAQCAtMTYxOCw2ICsxNjIzLDcgQEAgc3RhdGljIGludCB0ZHBfbW11X3NwbGl0
X2h1Z2VfcGFnZXNfcm9vdChzdHJ1Y3Qga3ZtICprdm0sDQo+ID4gPiA+ICAgICAgICAgICAgICAg
ICAgICAgICAgIGdvdG8gcmV0cnk7DQo+ID4gPiA+ICANCj4gPiA+ID4gICAgICAgICAgICAgICAg
IHNwID0gTlVMTDsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICpzcGxpdCA9IHRydWU7DQo+ID4g
PiA+ICAgICAgICAgfQ0KPiA+ID4gPiAgDQo+ID4gPiA+ICAgICAgICAgcmN1X3JlYWRfdW5sb2Nr
KCk7DQo+ID4gPiBUaGlzIGxvb2tzIG1vcmUgcmVhc29uYWJsZSBmb3IgdGRwX21tdV9zcGxpdF9o
dWdlX3BhZ2VzX3Jvb3QoKTsNCj4gPiA+IA0KPiA+ID4gR2l2ZW4gdGhhdCBzcGxpdHRpbmcgb25s
eSBhZGRzIGEgbmV3IHBhZ2UgdG8gdGhlIHBhZ2luZyBzdHJ1Y3R1cmUgKHVubGlrZSBwYWdlDQo+
ID4gPiBtZXJnaW5nKSwgSSBjdXJyZW50bHkgY2FuJ3QgdGhpbmsgb2YgYW55IGN1cnJlbnQgdXNl
IGNhc2VzIHRoYXQgd291bGQgYmUgYnJva2VuDQo+ID4gPiBieSB0aGUgbGFjayBvZiBUTEIgZmx1
c2ggYmVmb3JlIHRkcF9tbXVfaXRlcl9jb25kX3Jlc2NoZWQoKSByZWxlYXNlcyB0aGUNCj4gPiA+
IG1tdV9sb2NrLg0KPiA+ID4gDQo+ID4gPiBUaGlzIGlzIGJlY2F1c2U6DQo+ID4gPiAxKSBpZiB0
aGUgc3BsaXQgaXMgdHJpZ2dlcmVkIGluIGEgZmF1bHQgcGF0aCwgdGhlIGhhcmR3YXJlIHNob3Vs
ZG4ndCBoYXZlIGNhY2hlZA0KPiA+ID4gICAgdGhlIG9sZCBodWdlIHRyYW5zbGF0aW9uLg0KPiA+
ID4gMikgaWYgdGhlIHNwbGl0IGlzIHRyaWdnZXJlZCBpbiBhIHphcCBvciBjb252ZXJ0IHBhdGgs
DQo+ID4gPiAgICAtIHRoZXJlIHNob3VsZG4ndCBiZSBjb25jdXJyZW50IGZhdWx0cyBvbiB0aGUg
cmFuZ2UgZHVlIHRvIHRoZSBwcm90ZWN0aW9uIG9mDQo+ID4gPiAgICAgIG1tdV9pbnZhbGlkYXRl
X3JhbmdlKi4NCj4gPiA+ICAgIC0gZm9yIGNvbmN1cnJlbnQgc3BsaXRzIG9uIHRoZSBzYW1lIHJh
bmdlLCB0aG91Z2ggdGhlIG90aGVyIHZDUFVzIG1heQ0KPiA+ID4gICAgICB0ZW1wb3JhbGx5IHNl
ZSBzdGFsZSBodWdlIFRMQiBlbnRyaWVzIGFmdGVyIHRoZXkgYmVsaWV2ZSB0aGV5IGhhdmUNCj4g
PiA+ICAgICAgcGVyZm9ybWVkIGEgc3BsaXQsIHRoZXkgd2lsbCBiZSBraWNrZWQgb2ZmIHRvIGZs
dXNoIHRoZSBjYWNoZSBzb29uIGFmdGVyDQo+ID4gPiAgICAgIHRkcF9tbXVfc3BsaXRfaHVnZV9w
YWdlc19yb290KCkgcmV0dXJucyBpbiB0aGUgZmlyc3QgdkNQVS9ob3N0IHRocmVhZC4NCj4gPiA+
ICAgICAgVGhpcyBzaG91bGQgYmUgYWNjZXB0YWJsZSBzaW5jZSBJIGRvbid0IHNlZSBhbnkgc3Bl
Y2lhbCBndWVzdCBuZWVkcyB0aGF0DQo+ID4gPiAgICAgIHJlbHkgb24gcHVyZSBzcGxpdHMuDQo+
ID4gDQo+ID4gUGVyaGFwcyB3ZSBzaG91bGQganVzdCBnbyBzdHJhaWdodCB0byB0aGUgcG9pbnQ6
DQo+ID4gDQo+ID4gICBXaGF0IGRvZXMgImh1Z2VwYWdlIHNwbGl0IiBkbywgYW5kIHdoYXQncyB0
aGUgY29uc2VxdWVuY2Ugb2Ygbm90IGZsdXNoaW5nIFRMQi4NCj4gPiANCj4gPiBQZXIgbWFrZV9z
bWFsbF9zcHRlKCksIHRoZSBuZXcgY2hpbGQgUFRFcyB3aWxsIGNhcnJ5IGFsbCBiaXRzIG9mIGh1
Z2VwYWdlIFBURQ0KPiA+IGV4Y2VwdCB0aGV5IGNsZWFyIHRoZSAnaHVnZXBhZ2UgYml0IChvYnZp
b3VzbHkpJywgYW5kIHNldCB0aGUgJ1gnIGJpdCBmb3IgTlgNCj4gPiBodWdlcGFnZSB0aGluZy4N
Cj4gPiANCj4gPiBUaGF0IG1lYW5zIGlmIHdlIGxlYXZlIHRoZSBzdGFsZSBodWdlcGFnZSBUTEIs
IHRoZSBDUFUgaXMgc3RpbGwgYWJsZSB0byBmaW5kIHRoZQ0KPiA+IGNvcnJlY3QgUEZOIGFuZCBB
RkFJQ1QgdGhlcmUgc2hvdWxkbid0IGJlIGFueSBvdGhlciBwcm9ibGVtIGhlcmUuICBGb3IgYW55
IGZhdWx0DQo+ID4gZHVlIHRvIHRoZSBzdGFsZSBodWdlcGFnZSBUTEIgbWlzc2luZyB0aGUgJ1gn
IHBlcm1pc3Npb24sIEFGQUlDVCBLVk0gd2lsbCBqdXN0DQo+ID4gdHJlYXQgdGhpcyBhcyBhIHNw
dXJpb3VzIGZhdWx0LCB3aGljaCBpc24ndCBuaWNlIGJ1dCBzaG91bGQgaGF2ZSBubyBoYXJtLg0K
PiBSaWdodCwgdGhhdCBpc24ndCBuaWNlLCB0aG91Z2ggbm8gaGFybS4NCj4gDQo+IEJlc2lkZXMs
IEknbSB0aGlua2luZyBvZiBhIHNjZW5hcmlvIHdoaWNoIGlzIG5vdCBjdXJyZW50bHkgZXhpc3Rp
bmcgdGhvdWdoLg0KPiANCj4gICAgIENQVSAwICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgQ1BVIDENCj4gYTEuIHNwbGl0IHBhZ2VzDQo+IGEyLiB3cml0ZSBwcm90ZWN0IHBhZ2VzDQo+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGIxLiBzcGxpdCBwYWdlcw0K
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBiMi4gd3JpdGUgcHJvdGVj
dCBwYWdlcw0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBiMy4gc3Rh
cnQgZGlydHkgcGFnZSB0cmFja2luZw0KPiBhMy4gZmx1c2ggVExCDQo+IGE0LiBzdGFydCBkaXJ0
eSBwYWdlIHRyYWNraW5nDQo+IA0KPiANCj4gSWYgQ1BVIDEgZG9lcyBub3QgZmx1c2ggVExCIGFm
dGVyIGIyIChlLmcuLCBkdWUgdG8gaXQgZmluZHMgdGhlIHBhZ2VzIGhhdmUgYmVlbg0KPiBzcGxp
dCBhbmQgd3JpdGUgcHJvdGVjdGVkIGJ5IGExJmEyKSwgaXQgd2lsbCBtaXNzIHNvbWUgZGlydHkg
cGFnZXMuDQoNCkRvIHlvdSBoYXZlIGFueSBhY3R1YWwgY29uY3JldGUgcGxhbiB0byBmb3Jlc2Vl
IHRoaXMgaXMgbGlrZWx5IHRvIGhhcHBlbiBpbiB0aGUNCmZ1dHVyZT8gIEUuZy4sIHdoeSBDUFUx
IHdhbnRzIHRvIHNraXAgVExCIGZsdXNoIGFmdGVyIGIyIGR1ZSB0byBhMSZhMiBldGM/DQoNClRv
IGJlIGhvbmVzdCBJIGRvbid0IHRoaW5rIHdlIHNob3VsZCBkaXNjdXNzIHRob3NlIGh5cG90aGV0
aWNhbCBwcm9ibGVtcy4NCg0KPiANCj4gQ3VycmVudGx5IENQVSAxIGFsd2F5cyBmbHVzaCBUTEIg
YmVmb3JlIGIzIHVuY29uZGl0aW9uYWxseSwgc28gdGhlcmUncyBubw0KPiBwcm9ibGVtLg0KPiAN
Cj4gPiA+IFNvIEkgdGVuZCB0byBhZ3JlZSB3aXRoIHlvdXIgc3VnZ2VzdGlvbiB0aG91Z2ggdGhl
IGltcGxlbWVudGF0aW9uIGluIHRoaXMgcGF0Y2gNCj4gPiA+IGlzIHNhZmVyLg0KPiA+IA0KPiA+
IEkgYW0gcGVyaGFwcyBzdGlsbCBtaXNzaW5nIHNvbWV0aGluZywgYXMgSSBhbSBzdGlsbCB0cnlp
bmcgdG8gcHJlY2lzZWx5DQo+ID4gdW5kZXJzdGFuZCBpbiB3aGF0IGNhc2VzIHlvdSB3YW50IHRv
IGZsdXNoIFRMQiB3aGVuIHNwbGl0dGluZyBodWdlcGFnZS4NCj4gPiANCj4gPiBJIGtpbmRhIHRl
bmQgdG8gdGhpbmsgeW91IGV2ZW50dWFsbHkgd2FudCB0byBmbHVzaCBUTEIgYmVjYXVzZSBldmVu
dHVhbGx5IHlvdQ0KPiA+IHdhbnQgdG8gX1pBUF8uICBCdXQgbmVlZGluZyB0byBmbHVzaCBkdWUg
dG8gemFwIGFuZCBuZWVkaW5nIHRvIGZsdXNoIGR1ZSB0bw0KPiA+IHNwbGl0IGlzIGtpbmRhIGRp
ZmZlcmVudCBJIHRoaW5rLg0KPiANCj4gVGhvdWdoIEkgY3VycmVudGx5IGNvdWxkbid0IGZpbmQg
YW55IHVzZSBjYXNlcyB0aGF0IGRlcGVuZCBvbiBzcGxpdCBhbG9uZSwgZS5nLg0KPiBpZiB0aGVy
ZSdzIGFueSBmZWF0dXJlIHJlcXVpcmluZyB0aGUgcGFnZXMgbXVzdCBiZSA0S0Igd2l0aG91dCBh
bnkgYWRkaXRpb25hbA0KPiBwZXJtaXNzaW9uIGNoYW5nZXMsIEkganVzdCB3YW50ZWQgdG8gbWFr
ZSB0aGUgY29kZSBzYWZlciBpbiBjYXNlIEkgbWlzc2VkIGFueQ0KPiBlZGdlIGNhc2VzLiANCj4g
DQo+IFdlIHN1cmVseSBkb24ndCB3YW50IHRoZSB3aW5kb3cgZm9yIENQVXMgdG8gc2VlIGh1Z2Ug
cGFnZXMgYW5kIHNtYWxsIHBhZ2VzIGxhc3RzDQo+IGxvbmcuDQo+IA0KPiBGbHVzaGluZyBUTEIg
YmVmb3JlIHJlbGVhc2luZyB0aGUgbW11X2xvY2sgYWxsb3dzIG90aGVyIHRocmVhZHMgb3BlcmF0
aW5nIG9uIHRoZQ0KPiBzYW1lIHJhbmdlIHRvIHNlZSB1cGRhdGVkIHRyYW5zbGF0aW9ucyB0aW1l
bHkuDQoNCkluIHRoZSB1cHN0cmVhbSBjb2RlIG1vc3QgY2FsbGVycyBvZiB0ZHBfbW11X2l0ZXJf
Y29uZF9yZXNjaGVkKCkgY2FsbCBpdCB3L28NCmZsdXNoaW5nIFRMQiB3aGVuIHlpZWxkIGhhcHBl
bnMsIHNvIHRoZSAid2luZG93IG9mIHN0YWxlIFRMQiIgYWxyZWFkeSBleGlzdHMgLS0NCml0J3Mg
anVzdCBub3Qgc3RhbGUgaHVnZXBhZ2UgVExCcywgYnV0IG90aGVyIHN0YWxlIFRMQnMuDQoNCkJ1
dCBJIGFncmVlIGl0J3Mgbm90IGdvb2QgdG8gaGF2ZSBzdGFsZSBUTEJzLCBhbmQgbG9va2luZyBh
dA0KcmVjb3Zlcl9odWdlX3BhZ2VzX3JhbmdlKCksIGl0IGFsc28gZG9lcyBUTEIgZmx1c2ggd2hl
biB5aWVsZGluZyBpZiB0aGVyZSdzDQphbHJlYWR5IGh1Z2VwYWdlIG1lcmdlIGhhcHBlbmVkLg0K
DQpTbyBpZiB5b3Ugd2FudCB0byBtYWtlIHRkcF9tbXVfc3BsaXRfaHVnZV9wYWdlc19yb290KCkg
aGFuZGxlIFRMQiBmbHVzaCwgcGVyaGFwcw0Kd2UgY2FuIG1ha2UgaXQgbGlrZSByZWNvdmVyX2h1
Z2VfcGFnZXNfcmFuZ2UoKS4gIEJ1dCBBRkFJQ1Qgd2UgYWxzbyB3YW50IHRvIG1ha2UNCnRkcF9t
bXVfc3BsaXRfaHVnZV9wYWdlc19yb290KCkgcmV0dXJuIHdoZXRoZXIgZmx1c2ggaXMgbmVlZGVk
LCBidXQgbm90IGFjdHVhbGx5DQpwZXJmb3JtIFRMQiBmbHVzaCBmb3Igbm9uLXlpZWxkaW5nIGNh
c2UsIGJlY2F1c2Ugb3RoZXJ3aXNlIHdlIG5lZWQgdG8gcmV2aXNpdA0KdGhlIGxvZy1kaXJ0eSBj
b2RlIHRvIGF2b2lkIGR1cGxpY2F0ZWQgVExCIGZsdXNoLg0KDQpBbmQgdGhlbiB0aGUgJ29ubHlf
Y3Jvc3NfYm91bmRhcnknIGNhbiBiZSBhZGRlZCB0byBpdC4NCg0KQnR3LCBhIHNlY29uZCB0aG91
Z2h0IG9uIHRoZSAnb25seV9jcm9zc19ib3VuZGFyeSc6DQoNCk15IGZpcnN0IGdsYW5jZSBvZiAn
b25seV9jcm9zc19ib3VuZGFyeScgd2FzIGl0J3MgYSBsaXR0bGUgYml0IG9kZCwgYmVjYXVzZSB5
b3UNCmFjdHVhbGx5IG9ubHkgbmVlZCB0byBzcGxpdCB0aGUgaHVnZXBhZ2Ugd2hlcmUgJ3N0YXJ0
JyBhbmQgJ2VuZCfCoGlzIGluIG1pZGRsZSBvZg0KYSBodWdlcGFnZS4NCg0KU28gYWx0ZXJuYXRp
dmVseSwgaW5zdGVhZCBvZiB5ZXQgYWRkaW5nIGFub3RoZXIgJ29ubHlfY3Jvc3NfYm91bmRhcnkn
IHRvDQp0ZHBfbW11X3NwbGl0X2h1Z2VfcGFnZXNfcm9vdCgpLCBJIHRoaW5rIHdlIGNhbiBhbHNv
IG1ha2UgdGhlIGNhbGxlciBjaGVjayB0aGUNCnJhbmdlIGFuZCBvbmx5IGNhbGwgdGRwX21tdV9z
cGxpdF9odWdlX3BhZ2VzX3Jvb3QoKSB3aGVuIHRoZSByYW5nZSBjcm9zc2VzIHRoZQ0KaHVnZXBh
Z2UgYm91bmRhcnk/DQoNCkUuZy4sIGZvciBhIHJhbmdlIFsxRywgMkcpLCBpdCdzIGRvZXNuJ3Qg
Y3Jvc3MgYW55IDJNIGJvdW5kYXJ5LCB0aHVzIHRoZSBjYWxsZXINCmNhbiBza2lwIGNhbGxpbmcg
dGRwX21tdV9zcGxpdF9odWdlX3BhZ2VzX3Jvb3QoKS4gIElmIHRoZSByYW5nZSBpcyBbMUcgKyAx
TSwNCjJHKSwgdGhlbiB0aGUgY2FsbGVyIGNhbiBrbm93IG9ubHkgdGhlIGZpcnN0IFsxRywgMUcg
KyAyTSkgbmVlZHMgc3BsaXR0aW5nLiANClRoaXMgYWxzbyBzYXZlcyB1bm5lY2Vzc2FyeSBpdGVy
IHdhbGvCoGZvciB0aGUgcmVzdCByYW5nZSBbMUcgKyAyTSwgMkcpLg0KDQpJIHRoaW5rIGlmIHdl
IG9ubHkgY29uc2lkZXIgMk0gaHVnZXBhZ2UgYnV0IG5vdCAxRyBwYWdlLCB0aGVuIGl0IHNob3Vs
ZCBub3QgYmUNCnRoYXQgY29tcGxpY2F0ZWQgdG8gY2hlY2sgdGhlIHJhbmdlIGFuZCBvbmx5IGNh
bGwNCnRkcF9tbXVfc3BsaXRfaHVnZV9wYWdlc19yb290KCkgZm9yIHRoZSByYW5nZSB0aGF0IGlz
IHRydWx5IG5lZWRzIHNwbGl0dGluZz8NCg==

