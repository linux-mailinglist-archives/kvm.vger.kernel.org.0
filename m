Return-Path: <kvm+bounces-62759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB8EEC4D155
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 11:36:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7150F4A1A0C
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 10:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386713491F4;
	Tue, 11 Nov 2025 10:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NJCMU7eU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F3C347BC1;
	Tue, 11 Nov 2025 10:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762856447; cv=fail; b=jCW7Jl3xoIgNWMKFJYAWDED6Hl1fGpFD8IXokzl5OSXHJ5YJ6vdxqrPQnV09DsKQdr1fWGIFVF0HCquFDm+ae6tyuzEfuWfvC0MxBMxeNVBXVGN+lupwSvEwvuMaYbI1uyj0pa6vjgxiNaerS9gW4op2I0Yqki9oTn0Q78wtfd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762856447; c=relaxed/simple;
	bh=FUwMVyORz7KFU41G1mJEyY8GRZgTcxyNiHfl8shQv9Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nuI0IMgE++ST+3S4/MByFSAvb2UPbuMSOQvdXcgB3SO36lrmX0aFEcMU8WaNkW7aVOOpU/iWONr+X3yqvX73sVhGo8bGTOIsfsMO2w4YRLQuDcxpFCeKUlLc+T1EEe5ghhSCF3M6C+pWuMKPkFrPlvZM7ugNZSzeukL1I7Lmauo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NJCMU7eU; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762856446; x=1794392446;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FUwMVyORz7KFU41G1mJEyY8GRZgTcxyNiHfl8shQv9Q=;
  b=NJCMU7eUwlRy9x2GS5nDmiRFUTjOMGWB+ukusnR1dNm62Vtlc6h0Udxj
   5jNDmYY9DTHg0dds5mlvsTDOm4DuTlbV4+O7rKlIXuThPfPRnhERr6oBV
   2VNSwI6Nm84BFXKoxDSUOJf/Ewz9UbjLw4cVgb/itCnLKcV5OrVQLZcD/
   QtFOcyK92c7Lowd7j+QutfLc5kjuUHqEHKUUj8bbQUuDm5RG2W/ZoznkA
   rXbel/vJOep4HqcZ6oSNMuXBknRV4hszI+PO9GBRF3chukVVu68tWdxfY
   PCIC2aMKAYtHyBkB92FA4Sma0VvlLeuWHweNKbHPKcGqW4Q4H9v/x2Otr
   A==;
X-CSE-ConnectionGUID: AJC5M7rjQ6K3TeGVWhh2BQ==
X-CSE-MsgGUID: 7jaCCP6FSLSnLpICGBfjug==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76018482"
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="76018482"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 02:20:45 -0800
X-CSE-ConnectionGUID: 7fhkZ9QDSmuOGyd0z0XUDg==
X-CSE-MsgGUID: ly4TV+7HT0OUG7uxNybaXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="188764688"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 02:20:45 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 02:20:44 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 02:20:44 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.41)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 02:20:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NvzvpJ0Os0uFSAVA9BsrQW88ctdFN/FrGHSHHpXHYmoMnVDPm9UnK7S7/AwAUxyhMp6aK8e0s6coDIH2DhH8IRYSC6E/mWJtGDF1mndsUm1LpA04dYRr5rsF2sqDMEbUd/xo6i/JT6ETU1yY3bQTa426ssrEwlkuWzC8nYZtYeWUdP8ITDS+gvfzQd9WwY6abl8q9KN/haEhKUcSXbAv70YlU9Xrb4a/78XTU9T5mg/eqHrdB6gmha6RvY0S5YS16PMRNLwLz3zy71qdm1axk47KJZ1wEUsALMPHzdEeyMP0WQuwTQyuGKKBw6t5dphr8xilXI+IV5AhSzXAbSXRqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FUwMVyORz7KFU41G1mJEyY8GRZgTcxyNiHfl8shQv9Q=;
 b=r4vE6/pRNXNfzegWn//ogwRoTz6TiQO2gqNl85EzgdHvZmP+tJFaHUNT2wI7F0gRYAwW9I+sceCTBbl0UpHsyUShVl2JKK7KxQFnnG4bj+x4HqpRs1lQc/Vmi1vt6hi+8OJl19X+IRRbZ/bun2QED9gwXBIiWYM50LMksFlXJC3kQRQhQ+T+1Z3/Yc3a9bmJKM/sH/yFOEEYJhvRBDCV3DqZuD8D4v/XyOV4eHwIoMRAnyAyCUim9u16nJ7iP14P+JtcPfcjF3+nRZE2mkxCJcipTReBwZ9cyCwoYV0yMQyiL9rYYO4YfOWygx4Ri4VEzrWEwQm42hBS2vVZlV3Vcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CH3PR11MB8707.namprd11.prod.outlook.com (2603:10b6:610:1bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 10:20:41 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Tue, 11 Nov 2025
 10:20:40 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "zhiquan1.li@intel.com"
	<zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "pgonda@google.com"
	<pgonda@google.com>
Subject: Re: [RFC PATCH v2 10/23] KVM: TDX: Enable huge page splitting under
 write kvm->mmu_lock
Thread-Topic: [RFC PATCH v2 10/23] KVM: TDX: Enable huge page splitting under
 write kvm->mmu_lock
Thread-Index: AQHcB3/rKIb+ole/SkaJF+qBZcYhF7Tt2qYA
Date: Tue, 11 Nov 2025 10:20:40 +0000
Message-ID: <9aa8b3967af614142c6d2ce7d12773fa2bc18478.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094333.4579-1-yan.y.zhao@intel.com>
In-Reply-To: <20250807094333.4579-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CH3PR11MB8707:EE_
x-ms-office365-filtering-correlation-id: a6329a64-bbe5-4ec1-132b-08de210bf732
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dHRiVElMNjJxM0xXdXBkMGc5bEVnWWtCZG91Vys0Vzdvd0FvZCtJR3JadFdP?=
 =?utf-8?B?OUNwZHRHMTZVYzdGS05HWURqZXpMS0Y4T0l6YkZLN1FBUktnS21Kd3VlWjZt?=
 =?utf-8?B?OVZDRjY1dm5WVzhBdHcxeCtZNFNTUEZ6SHAzVU9hUXVWMEtZdGp0Z0dPeXRX?=
 =?utf-8?B?WU9hSStoMFl6UFdvbjZzNDQ4ODc1Z2d2Ymt5N2ZkY0p5emROZFp0bk9ObG91?=
 =?utf-8?B?TTA2bVREMG44dFJldVlqZ3poTzJvOWVkbUlweUUvQi9YUVlyQVAwOERHQ25k?=
 =?utf-8?B?SVIrWHA2Rnc5OThjaW9LanlmbGIyTDBBRkdnZEhJdEV6d0szbUltSEdvQXpa?=
 =?utf-8?B?N29ZS1phZEFBMGxHd2ZCM01xcWRtQldFK3BLck9ySEl4cnBkZWF5bTdOeWZq?=
 =?utf-8?B?ZjIwa0o3dHlreXMyQkMvbStRMmlZV0pnckF0V3Brdjg1Y084R3k5eGxKd3JE?=
 =?utf-8?B?Ump2Unk3TXE3YWVINzBKN2J5MG9qMkgwR3VoYktiTTQ3RHB3MjBLbG40UXQr?=
 =?utf-8?B?U2JsOFhOWVRyMFgvbVQ4T2VocDVBOFc5OG90VU15NTFQNGZyR1p4RWZOWGpv?=
 =?utf-8?B?cE5IdjMwck1TaElldG56WTYxUno0U2hUNVFxcFp5bHNmdUFPV1pjdVl4b3pF?=
 =?utf-8?B?UXltSFE0SU0renJQZ1lvTDN4OGh2MFZweVk0Y0NEVkxkenZLY2dpc1BqeFdy?=
 =?utf-8?B?NWFCdmNWSzJEVXZsbE9HMjk2ZU5nb1hobnFCbDFuWWRaYWZFVjQ0MWtBTi9L?=
 =?utf-8?B?M09IZGV4VHR4WXg4YWZZOFlMdnI3YVdrTHFsektKVWpGVWlJK3o0Qlp0R2Q2?=
 =?utf-8?B?dWVONEx0VVFabE80V0RFRTZCZ3cyOVcreHoxYzVmYlYvNDE1TG4ycGtETGhK?=
 =?utf-8?B?eGRKRnpkcjJGckpNWnF4VWYrOGg1NmNYNEwwYXhwZlZ6T3h6MVFlSjZ1dTlG?=
 =?utf-8?B?NDJWUnZuSmZXWERseFBvbkhoaHkvbS9TNEdUeE40UGRTWVBzOW5ULzB1MWpq?=
 =?utf-8?B?RkkzL2lpRkhqUVdtK3pkNzI5Rk5FVnE3WUhOdTdQVkFLaXhuMm9rUzZKTE1R?=
 =?utf-8?B?cDF5TWxNVlgzbHRLUHRGVEpaS1RqdG1MbGY2TWp2cnA1SXA1dWk3VHp5eXFj?=
 =?utf-8?B?ZnZuMmh5VjRpcFpEdzlORFdyenhpanNNRFBwTUU1dVZUWkhINVBSRlZqYUFv?=
 =?utf-8?B?Q2E1clBIcjREY2txN1BjZFE1VjFZVXpad2l2YWtYc3h2VUYrWUpQd2NtSFpN?=
 =?utf-8?B?YVkzTzNIUjhJc1RlZWprRjZHVjZmay9wbzE0TkVjc1JqZ09oOFVwcGdWR2dY?=
 =?utf-8?B?cjlyMnZJUEp6ZnJtNlFFczZIcTF4YmxPcEZZZm5UUnlEWXc4eFYrd1MyRUo5?=
 =?utf-8?B?MWhXaDc5M1NJbW80QWRxajZsU0NtTnM5aHhHa3Npemt3aU1rUHhZQkpFY1NF?=
 =?utf-8?B?SE80d05RNFVZWVZmaHR3MGVvVHNKbGdnRmFMSVVocVFMM3VYelQxOC9SQU8x?=
 =?utf-8?B?WFEvUklWRUNBdEtzQW5YT1cxNTQ0U20zWVhDa1BXYzRxNExtdDA2NWxZTXJz?=
 =?utf-8?B?ZytKemp1T3pDWGFWTDlqZGtWWVJWTmdHWFAwR2pNSkxaeDcza0xFbzZ6Yllh?=
 =?utf-8?B?TnhJdnUyZURlMTFpWEpJbjhGbElJWFgwdTIxMGN2ZXVvQnZuZGJYTTRBKytC?=
 =?utf-8?B?Qk9RSGZUbTFGVEJ3Y3VyOTA3VDZqbzNxWndOOVU0NCtBTWhpK3pSeEVXK0pZ?=
 =?utf-8?B?dWZHWnVNd1ZCTzdzNGY2Y3BTNnNYQ2FINzFDR21Tc1g4QkY2dUhtRU4xZXRT?=
 =?utf-8?B?bGdOZDFnYkNDQTdwNEhaNFB3bU44aUFrMVIwTEMydVV2cUx5K2QrTGtKT05N?=
 =?utf-8?B?YXdZUDByZWlsVVdMcmxhRWlFUE83blJ0WmFqNU1yVkM5U3V0TjlTbi9lWE1M?=
 =?utf-8?B?SU5oNUN5alFIYWZzeWVuVUxVNkE0RGVDMEIvK3FZcExTWTNwRVRrV2NIZUdo?=
 =?utf-8?B?OWlxeXpPalc4c1I2ckhWUnlOR0taMVZjajR5TW9oTHdoN2tmUVpud0tnNmJo?=
 =?utf-8?Q?YMcK34?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dURuSm1GcEpkSTJYSkdTMUxoYTVHeXRnbUdOSkp2ZmU2bG9KU0RSdWExZWlE?=
 =?utf-8?B?eXVxVnl3cldJK1pFVTZWeHJtb0hTejdyUXpQVXZ4aC9hb0t5c3hmRWl2T3Ft?=
 =?utf-8?B?MVRpV1N4a3Q4alZpcnJYY3J4MjN0VVVlZHA2Mkx5dEpxMm4vMDBra0U3anZy?=
 =?utf-8?B?OXVybjJyVXhCcUorbDBWQ2NDNXM0U0JmbUVaTkVTeXdsa04wdGxlSjNpY1F6?=
 =?utf-8?B?ZHljdzhyV0lNQWF3QUJlVC9sZytMY3lBSHV5L1Z2ZDFLSnMwRWkweEJQN1hj?=
 =?utf-8?B?TGR0WDAzbWlLMGVlYjRNN3RSSUhuN0NVMWRja0tMNXBMV3pNR2J6MkthalJF?=
 =?utf-8?B?Nk02T3RYcGtMZnpPTFBpOVJqMEZ0bEFQQUduRXE2WVBNU2tlYjUyRmFpSFFF?=
 =?utf-8?B?dXNuWnJOclh0SElPbmErYnhtVGJUME5IODIwdG5rZFZiNlJRWnhSVTR1b2lp?=
 =?utf-8?B?Y0RWTWxCR3pxNkFLZVBHMExHS0RCdS9tYzZyRHVBMkIrWDNQcGp1WHNldHR0?=
 =?utf-8?B?RDdyWWVsOE8yendOeW5xSTNtLzRSVzEvK1B0S0srNVZqNlYyZVJWZXl3OHNK?=
 =?utf-8?B?RGV2bXdpRTdJVHI1ZEFDdE1IRDdrb1YvdUVkWXI2NXZmcmlPVk9UanRXMkRZ?=
 =?utf-8?B?T2ozLzF1YVByRndKN1pLWktqQTJ2TkRBeHk1a0I1elhwMXVFZmFlMVBGS3pJ?=
 =?utf-8?B?ZEw1UnZkNVd0cVFUZHl4WDZtK0ZvcmlpNFZFZEV0bDZnNzJhTE9tUlBYSmNS?=
 =?utf-8?B?TjBGeUhtOU5WSFhXRnBlNXYrd3hLY1AyN3RlYWRONlNiQVNGcVN3d0NLdkQ0?=
 =?utf-8?B?dnhwVEVRaFl4dGlZVDhGQys0Nzg5ZXRmNkgrZHYrZC9VVWQ1SG1SeGMzMVdG?=
 =?utf-8?B?Qi9QTW9rT2Q4UnY0WXhaUkFtMzdqRys3ZytHREExMEZBcWFhSGpKaUlJTnBB?=
 =?utf-8?B?RFY3bWI1TEppeTN4eVZSMFQ1RkRjN29Scm13ZVF4Y2wvYXBkOVo2ZDBmZ1Y5?=
 =?utf-8?B?bEdndmdxV1AxZDdoZWFOT2x5ZWlhV0FJcjNuVHEyYSswdU1qbHRlSG12MENw?=
 =?utf-8?B?V29WbnVYVGovZFlQTXIzTzZlVCs1NHZncnQ2OWdYQzMrTjRtcndWbjNYT0Zm?=
 =?utf-8?B?dkE2ajgyNlN6OHpsM2IrWVBmMDdXbThqR0JhOFNPVWdzMGtPVUcxRHhhUml1?=
 =?utf-8?B?bWFQUXJad3A1T09oaUhtQnc2VlRrckpBdmtkVFdvYWJYSGVyZndoYjZuWGdV?=
 =?utf-8?B?K0pJdnFHNkNTdXg1Nys5Q3F1N3kzNVV2Wmk3ajh2K3Y3bVp2YWFKR01Rd1pD?=
 =?utf-8?B?cWVuWElPcjNqaXVjV2oxQmVpR0VvR29VamJ4Vzg3QzQ0cXVuWnNQT0t4OVRR?=
 =?utf-8?B?bmkzb2JkZExOKzZqc2hkZGNvQU1RR014SDJYNVQ2d3cxU0hPdTJkVm9HWmpQ?=
 =?utf-8?B?cHNnRWs0MWdKZmVqcDliUm0zeXhNQVFzQVdQbXM1TXF6UHVyb2JrOTBGMjNN?=
 =?utf-8?B?MzlmNUozcDZxbFVHeXJldlh2Q2tFaVJXZEdtOUR0UXQxYzJrdTVPUytJdVVX?=
 =?utf-8?B?ZFozT25rdzhzMFdvNXdJQXRiOGcxZ0JMd0VhWkdGOWR3d3Bnd0dLaHFLVHJ1?=
 =?utf-8?B?T1ZKWFd1UnNmL1N2SGp1akZ5c096K0NicDdleU8yT0ZsbG1pKzF1b0ZDT2JP?=
 =?utf-8?B?U29RNmdnTkpNYmxMeG5najk2dGpSZ21JeENDY3pKQ3pZM3paRXMrWTIzODRM?=
 =?utf-8?B?aG5XQ1dvV0V0KzZVWlJ3bzRncTQrYTN6SkFUYVNQV0tzaVJpc1gwZzQyQTVt?=
 =?utf-8?B?U25Xa2hENnVybmxkQS9iSjZrcng3bUZHM011czd0UzlJMmVSSkhjcjlScjND?=
 =?utf-8?B?eWhJNWdGTTFCQWhjL0dkRlZHVmtuckluL0FlTDhHYVRtckZIcGhLQWRCekIz?=
 =?utf-8?B?RmZNWlRQemtDemI5OGdXV0tMV0lnMzB5clVpaUd3Si9uREhRTzFZQ3hLZ1Jw?=
 =?utf-8?B?OGlaTVVqSThJRU42ajFodUFlK1NEYXNOVitFd3hyUlhVVDErazUyU1ZmZU9M?=
 =?utf-8?B?UW1tOGFqMkVSdTAzUk4zTFdnMElxQ1FrTzFmeWtRTmxSdjdjcWloYnBsNVFB?=
 =?utf-8?Q?xupYthLpQD8kQyqdwR/UBGu3r?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A920A2ACE622C41A0907372C7DCD1C2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6329a64-bbe5-4ec1-132b-08de210bf732
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2025 10:20:40.8633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kl6ARVVssmEowTmHe7mutkd+WRlqJ7YoJTBDoPQh2/ei+8y3S5OYaNIZNf6FioJ6V8rLlO/o7oeukqdCFbfF6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8707
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTA3IGF0IDE3OjQzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gSW1w
bGVtZW50IHRoZSBzcGxpdF9leHRlcm5hbF9zcHQgaG9vayB0byBlbmFibGUgaHVnZSBwYWdlIHNw
bGl0dGluZyBmb3INCj4gVERYIHdoZW4ga3ZtLT5tbXVfbG9jayBpcyBoZWxkIGZvciB3cml0aW5n
Lg0KPiANCj4gSW52b2tlIHRkaF9tZW1fcmFuZ2VfYmxvY2soKSwgdGRoX21lbV90cmFjaygpLCBr
aWNraW5nIG9mZiB2Q1BVcywNCj4gdGRoX21lbV9wYWdlX2RlbW90ZSgpIGluIHNlcXVlbmNlLiBB
bGwgb3BlcmF0aW9ucyBhcmUgcGVyZm9ybWVkIHVuZGVyDQo+IGt2bS0+bW11X2xvY2sgaGVsZCBm
b3Igd3JpdGluZywgc2ltaWxhciB0byB0aG9zZSBpbiBwYWdlIHJlbW92YWwuDQo+IA0KPiBFdmVu
IHdpdGgga3ZtLT5tbXVfbG9jayBoZWxkIGZvciB3cml0aW5nLCB0ZGhfbWVtX3BhZ2VfZGVtb3Rl
KCkgbWF5IHN0aWxsDQo+IGNvbnRlbmQgd2l0aCB0ZGhfdnBfZW50ZXIoKSBhbmQgcG90ZW50aWFs
bHkgd2l0aCB0aGUgZ3Vlc3QncyBTLUVQVCBlbnRyeQ0KPiBvcGVyYXRpb25zLiBUaGVyZWZvcmUs
IGtpY2sgb2ZmIG90aGVyIHZDUFVzIGFuZCBwcmV2ZW50IHRkaF92cF9lbnRlcigpDQo+IGZyb20g
YmVpbmcgY2FsbGVkIG9uIHRoZW0gdG8gZW5zdXJlIHN1Y2Nlc3Mgb24gdGhlIHNlY29uZCBhdHRl
bXB0LiBVc2UNCj4gS1ZNX0JVR19PTigpIGZvciBhbnkgb3RoZXIgdW5leHBlY3RlZCBlcnJvcnMu
DQoNCkkgdGhvdWdodCB3ZSBhbHNvIG5lZWQgdG8gZG8gVU5CTE9DSyBhZnRlciBERU1PVEUsIGJ1
dCBpdCB0dXJucyBvdXQgd2UgZG9uJ3QNCm5lZWQgdG8uICBNYXliZSB3ZSBjYW4gY2FsbCB0aGlz
IG91dC4NCg0KWy4uLl0NCg0KPiAgDQo+ICtzdGF0aWMgaW50IHRkeF9zcHRlX2RlbW90ZV9wcml2
YXRlX3NwdGUoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4sDQo+ICsJCQkJCWVudW0gcGdfbGV2
ZWwgbGV2ZWwsIHN0cnVjdCBwYWdlICpwYWdlKQ0KPiArew0KPiArCWludCB0ZHhfbGV2ZWwgPSBw
Z19sZXZlbF90b190ZHhfc2VwdF9sZXZlbChsZXZlbCk7DQo+ICsJc3RydWN0IGt2bV90ZHggKmt2
bV90ZHggPSB0b19rdm1fdGR4KGt2bSk7DQo+ICsJZ3BhX3QgZ3BhID0gZ2ZuX3RvX2dwYShnZm4p
Ow0KPiArCXU2NCBlcnIsIGVudHJ5LCBsZXZlbF9zdGF0ZTsNCj4gKw0KPiArCWVyciA9IHRkaF9t
ZW1fcGFnZV9kZW1vdGUoJmt2bV90ZHgtPnRkLCBncGEsIHRkeF9sZXZlbCwgcGFnZSwNCj4gKwkJ
CQkgICZlbnRyeSwgJmxldmVsX3N0YXRlKTsNCj4gKw0KPiArCWlmICh1bmxpa2VseSh0ZHhfb3Bl
cmFuZF9idXN5KGVycikpKSB7DQo+ICsJCXRkeF9ub192Y3B1c19lbnRlcl9zdGFydChrdm0pOw0K
PiArCQllcnIgPSB0ZGhfbWVtX3BhZ2VfZGVtb3RlKCZrdm1fdGR4LT50ZCwgZ3BhLCB0ZHhfbGV2
ZWwsIHBhZ2UsDQo+ICsJCQkJCSAgJmVudHJ5LCAmbGV2ZWxfc3RhdGUpOw0KPiArCQl0ZHhfbm9f
dmNwdXNfZW50ZXJfc3RvcChrdm0pOw0KPiArCX0NCj4gKw0KPiArCWlmIChLVk1fQlVHX09OKGVy
ciwga3ZtKSkgew0KPiArCQlwcl90ZHhfZXJyb3JfMihUREhfTUVNX1BBR0VfREVNT1RFLCBlcnIs
IGVudHJ5LCBsZXZlbF9zdGF0ZSk7DQo+ICsJCXJldHVybiAtRUlPOw0KPiArCX0NCj4gKwlyZXR1
cm4gMDsNCj4gK30NCj4gKw0KPiArc3RhdGljIGludCB0ZHhfc2VwdF9zcGxpdF9wcml2YXRlX3Nw
dChzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwgZW51bSBwZ19sZXZlbCBsZXZlbCwNCj4gKwkJ
CQkgICAgICB2b2lkICpwcml2YXRlX3NwdCkNCj4gK3sNCj4gKwlzdHJ1Y3QgcGFnZSAqcGFnZSA9
IHZpcnRfdG9fcGFnZShwcml2YXRlX3NwdCk7DQo+ICsJaW50IHJldDsNCj4gKw0KPiArCWlmIChL
Vk1fQlVHX09OKHRvX2t2bV90ZHgoa3ZtKS0+c3RhdGUgIT0gVERfU1RBVEVfUlVOTkFCTEUgfHwN
Cj4gKwkJICAgICAgIGxldmVsICE9IFBHX0xFVkVMXzJNLCBrdm0pKQ0KPiArCQlyZXR1cm4gLUVJ
TlZBTDsNCj4gKw0KPiArCXJldCA9IHRkeF9zZXB0X3phcF9wcml2YXRlX3NwdGUoa3ZtLCBnZm4s
IGxldmVsLCBwYWdlKTsNCg0KSSBkb24ndCBxdWl0ZSBmb2xsb3cgd2h5IHlvdSBwYXNzICdwcml2
YXRlX3NwdCcgdG8NCnRkeF9zZXB0X3phcF9wcml2YXRlX3NwdGUoKSwgYnV0IGl0IGRvZXNuJ3Qg
bWF0dGVyIGFueW1vcmUgc2luY2UgaXQncyBnb25lDQppbiBTZWFuJ3MgbGF0ZXN0IHRyZWUuDQo=

