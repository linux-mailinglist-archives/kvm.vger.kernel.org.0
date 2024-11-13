Return-Path: <kvm+bounces-31817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 202DF9C7E0A
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 23:02:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D32922850CF
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 22:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E39F18BC30;
	Wed, 13 Nov 2024 22:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ymd8ZD7k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2594D15AAC1;
	Wed, 13 Nov 2024 22:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731535308; cv=fail; b=Dlg5CNN49VBxNx8E+Hkf6WX1/oF9MZ+bX+rQZDeUUowiqSTy48UzJ/qnHKLx+8KIB8KN4VxTGABBzp3ZYWG2QC+6iwsB7rjduIiqzV2pjaq7r2u8NVSoKjsshFHjcWP7Y0trQzaFg0salWxAcWJnAYephbIyaC12VrxuCpMaVgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731535308; c=relaxed/simple;
	bh=DixmlyccnUOVHzc3vLiu3ZfP3jJvEudWkHj7IRmuA84=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ML5EetqMt/oXBbP1cfti+D//8PVM7nBHy7GJ2d5MCqsbCy1o509AvAedxEXWreXMIuiJtFKyI5qrWnTRJ1n4f2+AdeoB2eYrNHhQ2OZyjFMgMi6E4clCwqvaU4/9Bl1TR4WeKJFeoEprhaxD3klr3IJ/MKQh04YFRQbWWHchlmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ymd8ZD7k; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731535307; x=1763071307;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DixmlyccnUOVHzc3vLiu3ZfP3jJvEudWkHj7IRmuA84=;
  b=Ymd8ZD7k69XdHfV/R+8PX102c5ksX6Ue/etHGMNQkS+oIoOs1DBFzJBJ
   6crzbB0qi1BMMTg42vuSeHevkKWufWzP20EVDcLNgrKgy5Z7v3poJVFXi
   yKcnIb5K5GjGxufoQ/khCvfzuPEQEyyiMzpSFMkeGV04Kp0N9NfO44Nq7
   xy+lP8YHAxWT9E+k67QLRS/C7raYVe+kQTmpqMumcJGIq4GNs+wtfbJpF
   EoOl5MTKA9t1gYmQaTAceYI6QxsP/mw716njVZmEmhxyPz6Vk2hKGdWH3
   lrp7AdRDOlrYdt1LUi4bMXjuDmdtdcsaiB/VQGB3g1d9q3WmIBJ54Uv/a
   w==;
X-CSE-ConnectionGUID: L2kNdmQVReGXr0QbQ6mUQw==
X-CSE-MsgGUID: xozTnuiRRM+/BJ1bGztQpA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="42012049"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="42012049"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 14:01:46 -0800
X-CSE-ConnectionGUID: nGdccK02SOa/7GWATHih+g==
X-CSE-MsgGUID: TJuDB4t4TlSvU50/RtSiFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="87559286"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 14:01:45 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 14:01:45 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 14:01:45 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 14:01:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YZZQb6J0pKGIc4HEWsIVwZZqjjR6Q1ibzHnfd0mccbUzFGboFrcqwCSq8fSzboxNW15rGXvnobuxcTb6M6PQ9UJ5EtRS1IgSOwRD3SafXFoaCOfnjOcwVG8yIyNvCrKpORFwuxPmJ0zwD6ACwmEcnmX/cuhXBe9jaNRoHpzre6SFD9yMhMA80eWlOizlFGTn/Fx6coxP6HjfjLAkppsBzSC6fs2ShqajQQ2wgxR9J4/dGu5QZUvZCj3SQfd4yTfFLMfIMPu8AJr1ZgFQH2wZDycGrJzawNOSK4tBPf2zGQJAIXe0S7KUjfSqnROoa1T8HZHkvWXjSGdlBw2yxL8rPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DixmlyccnUOVHzc3vLiu3ZfP3jJvEudWkHj7IRmuA84=;
 b=INLzXCGxUvKbfOuRP29E44KZSGzl2tZyibkOgaHRwwuu32aMiMCN0YIhVlYCeMp4yePxmXEjMrab2JFx31DrmaP6JmGSZ3jjQkBB6glcmthZjDyJP3yoE7vmYjSGk488eBAU0XDIy2h+oDgDbfBLnNrtPlJy5AbVBA6sVvHvPXpfNerG7yBYbB2DFgwbe7LxJ2IHV/OKLMn/fStRQul00g1D7RZASQSBQybNjOai/7e5Y+O7qk21UsYUY86YoJnvImoVwLA9QY2qHyM3WXWR6ruAL02uSGVQnrzXd3bVDmMm7VoQJdjmixykYo6hx1sEnCOxUzZD0Hasy/kaR/dl4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by SA1PR11MB7040.namprd11.prod.outlook.com (2603:10b6:806:2b7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 22:01:41 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%6]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 22:01:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>, "Huang,
 Kai" <kai.huang@intel.com>
CC: "Yao, Yuan" <yuan.yao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX page
 cache management
Thread-Topic: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 page cache management
Thread-Index: AQHbKv4rca7tZFwUNEOLKBi110Inj7K0baeAgAFX54CAAATNAIAABOMAgAAKAoA=
Date: Wed, 13 Nov 2024 22:01:41 +0000
Message-ID: <092b78ee1dea89728d79273dd9fd0f499db71347.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-9-rick.p.edgecombe@intel.com>
	 <aff59a1a-c8e7-4784-b950-595875bf6304@intel.com>
	 <309d1c35713dd901098ae1a3d9c3c7afa62b74d3.camel@intel.com>
	 <ff549c76-59a3-47f6-b68d-64ef957a7765@intel.com>
	 <94d0ded0-0291-4a1b-ba8f-d0e5484447da@intel.com>
In-Reply-To: <94d0ded0-0291-4a1b-ba8f-d0e5484447da@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|SA1PR11MB7040:EE_
x-ms-office365-filtering-correlation-id: 1e23a31b-d916-44e2-0a9d-08dd042ec187
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Zzc0UjJyR21sN2wvWEp1TC9HcVF3OExBblZvaGRhYTNEN3lXd3BLZ09IWVhC?=
 =?utf-8?B?VzdxM2Fpb3RaUGUxTjhPOEkvQmUzK3R3ZStGRnVKRDB0QmhmVC81Y2EySVZ1?=
 =?utf-8?B?dWxYMDIrTTVjQ2tsMlhWaVRwN1BsUWpWSjVpemsweUE4czBkcVZTc2xTdXlU?=
 =?utf-8?B?eGt4ZzNTMldCZkZ3QlJIMWVrR0c2N091Q3VZbjlOakFPNHBTQWpTQzVGdTFZ?=
 =?utf-8?B?eFJaUkdzcXI0ZXhWK0NwVzBkclVGSGNwUjRxRFAxRW85d1FrVzdZcmx5SXgr?=
 =?utf-8?B?RlVBN2NITENaN1R2ZUZucjRoRmkzN2JUV0FMZDRLNGRVWnJDbnZpeDQ3RGRL?=
 =?utf-8?B?ZmtFeG55N0FwSkRZSUwzR21VS1lHUVBXZGxOb1J3M2IzN1lkejVoNVo2Y1pu?=
 =?utf-8?B?R0h5azdPVmhIT2ptL1RZTnZRYW9aVkI5b3JmWmhjTDNMenBWY1FSb2k2TnpM?=
 =?utf-8?B?YXdXN3BEa1paZnp0WG5wY1I4NFFpbXh0aWN3M3JXRkU5ZldXRjJ4RTRwdkV6?=
 =?utf-8?B?MmZhQ2J6eTF1b0FQSDZ2Z3drRzFqRVAxY3haUmRCc3VSVk5IRXdVMlAwRkpY?=
 =?utf-8?B?ZHZXZy9neHpVSDFyWTVFd3JQRklBYmVEeWduZmorMGZ1TkYrbG0wVVFyZzF2?=
 =?utf-8?B?QWdudzh5T2pMV0s0NSttSWRVdEN6YTltbjltWlBxUklFV2RLTjJGc2ZUUkxs?=
 =?utf-8?B?OW81bHE3RHhkTEVILysyUm15LzN4K2lIWWQvclF4RzVLSU5POUZPMzFGSWlO?=
 =?utf-8?B?TDBuSldnZHh5ZzB3VnZ0T2RDVTR4YzA1ZjdKSHZoMmlGUldMVEswR0hqcXB5?=
 =?utf-8?B?R0RJSis3Vk52aG1xMGFvUENMNWV2SFdueWhqaSs5Qkx2TVRxc1Z6MGxqdmpO?=
 =?utf-8?B?bjFPVnRZNm1xZW5XMTVFWmN0Z2R5WEdjOWNDWThxRlFGUEdudEZKOFFYZVlN?=
 =?utf-8?B?SGNpNWF2NlM0RGNLdnF1SFI1emxEYXRJMWdLTXZXUkg3bmQ2QTBtRnVIQlpU?=
 =?utf-8?B?TEppTEpXMlRhanVuMWh6M1NiZDBXdnA5aThtSU5zUnFrSTBYRWl4b2VyTjZW?=
 =?utf-8?B?NjY4WTR6NGZmNWg3MlEya2VkcVJrazIrWjRPK2VrRElqK0pVOGVDZm9QKzBi?=
 =?utf-8?B?SWxPYTdJK0JnYWl4akpMQndpYWdYempLL1Vmakl2a3R6TFlncUF1QytFVGtv?=
 =?utf-8?B?TDdTTThsekpZa2h5UkF4aGhZbmExVTlSb29BaVBIYWxyUXZQSnRqaVRBVmgr?=
 =?utf-8?B?d0tzQUdYdzc2dW93RTlyQUlHNmIvaHp4OWpVbHNuNnNxUGJQREUyNThSK0NC?=
 =?utf-8?B?M3p0ZEJsTGt0dGhaM0JLUnFVNy9saGpYQVlsSnRaWUgwRERZd2x1ZGdqaXgr?=
 =?utf-8?B?NFp2WkMveGdrZWFoZ2FqWlFGajNvYyt6WGpXQUtsbXZJUk9WMDJBTDAwSVor?=
 =?utf-8?B?MXh2TDlWRmQ1Z1c4TERUZ0FhTERLKzhiQ09pZ293aHBNempKaGx4WnZuVmYw?=
 =?utf-8?B?Vm1OR3pPS2VUNk9xWjFhZ09BWEJSSmQ0UVJiZnVhZ04xQm9XWmU3NWtXSnE1?=
 =?utf-8?B?Zk9seUVOVi80MjQyMlBGL1BOU1N4cDRsK0ttRU9xMm1aUmlaWDFLYmdVaXll?=
 =?utf-8?B?M0N5SWYvTzFPb2Irbit0bi96Um1wWkhEZFg0ZURaeTdjb05oek85WnlmZVBa?=
 =?utf-8?B?eTV0bzdoc053S2xnamljVzB2NHdxVE5XeUlRS2VKYXd3OEpCOUJ6ZzB1Ly90?=
 =?utf-8?B?ei9RaVFibGNpRDd4VEdPekJteGl4b0F3ZDR6Q0RLTnFOTkViSXRWQm9MSXVL?=
 =?utf-8?B?SE9GbnREQy9WMllYQVpXY25UTDltN3U3Q0orQS9OTXlGVDU2RktRKzIrOTR1?=
 =?utf-8?Q?PubfPYCNaaPs/?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVNSOEdDcSs2bDdzeE5FWEV3bWJ6S2dOOHZkeGFSWUIxVjgxeWV4NmlCTjZh?=
 =?utf-8?B?S2FQRm8wTlpNT0tUQW1UZVM1MmZjN2locFhZSVJhdWRRcnRZSm1qOHJEMjhN?=
 =?utf-8?B?UktRRDVrdHhESDYzMHluUUNRdTVKcHVnaFJtcFhKVTV4aklCUVVIcUpwaEdq?=
 =?utf-8?B?WU9VTUVwNmFkSUxRNWNtWkZPUU16NVJGeVd4am9SRjdiVFBnNDliVFB2RXRk?=
 =?utf-8?B?bW5XOGR6akd2cnVFTUxwaGsrcWhrVzZ3dVQ3cXZKOGFCbVQ5YSs3TXhhWWNM?=
 =?utf-8?B?YnhHOGpKM1lpdVNIcjlRUUd3Rm1TY0llcVR6emJYdEorTitINUNMbTJ2Sk9i?=
 =?utf-8?B?V09hRFBxbGlBRTZtQ2xvYTBxdzRWbmNyUlFyQVBGN3VTQkRtVzlIUkErb1Zo?=
 =?utf-8?B?YmZkeUcweVo5UjBjT1lmL29nUWp5QWl0SC9RMnZkOURTL2l6UlI4NDFBb3lk?=
 =?utf-8?B?d3hHR1NnRGZZb2oyT1I1dmE3S2F2V1hITUZFWmk1NEk5Vis4bDZ1TWQzcVhx?=
 =?utf-8?B?KzdyYWROdnRHWlBDNGNtbTdZaG9mZy8wejM2MmJTV3M1ajZwb1dXOStGNFBz?=
 =?utf-8?B?KzNNd1VENzZWZFNpS0Z6djhaWXFnaWNsLzZhZXNvc0lBcUxPcTVidy9KdDlD?=
 =?utf-8?B?aURRWE9KNm8zYTRheUxPNng5VlZuN1M1bjhtQmhBODZ5bXNTOE81NTYya2VX?=
 =?utf-8?B?V3FTSUVKRHZWbnJlcVdGd1FrRjJBU1JZK2srSzVmMWRUVmpTU05wRS9MUWZ5?=
 =?utf-8?B?eTZBdVRJM3lBRWEvcVQwMjFuODF1bG4wV093QlltbFpEUWRGcVFhYkUyYTdk?=
 =?utf-8?B?elhTdkRtblRaU3Bweno0OEt0UklXWWtaQ0ZqSG40ZUFwVUJoNlN6YkdzQ1Fq?=
 =?utf-8?B?azcwRzZka3lhMitJZ3V3aHlMVytuaUpsYzllM3R3T1ZLQ05zZEVCSTZpdXly?=
 =?utf-8?B?UHJhWFN2UUlJeFRmK1dXTEFFS202cjZURWNUekYzZnkxMlhGd3lUWGJBeWs3?=
 =?utf-8?B?VEwzVUE1U1hqcWRMT2diekMwcUlXNVoyRjBoVWlFdHI0bjJXN0J6QTRqMllJ?=
 =?utf-8?B?K1BKR29ET3FaYU1SZUdMeTNINkFEZjJ4UitwRFhxNlB1Qm02TFlPVmJDMDJ1?=
 =?utf-8?B?WVVuZzVrOGg4TGVlYWhWOUFzYk1UWmkxVytqQld6T0tYdUxQc0tjM2tvSWFn?=
 =?utf-8?B?VWdRa29zMWFCU2w4MkNXeVlzcWgyS2F3RWV1MGw3UDhsV3Q3UTBrcm1pRUNW?=
 =?utf-8?B?NGV1MEVVVGtqbndjMThidENzcFFzUjRWenRrVjkycUI3TUtid2g2VHhCUW5z?=
 =?utf-8?B?ekticVBtQVlONnhSUE5vcXluK0ludHlaaW44Rkh3MHRnTDRWM1l6bjFBUTVN?=
 =?utf-8?B?OEh3Zmw5SFJiRzM0R05NTU91NXZBVi96b3VTS0o4WFVJeWxMY29VMFpGUFdE?=
 =?utf-8?B?SVRGT0kwY1FNZkVtV2cxMFNFeDZiQXY0UW5WRmdsWVFieWhkdXRjNm4xS2tn?=
 =?utf-8?B?ZEF2V3NTSzMzNnllZ2NjMFRCNCtPQmZvcUtnc0NqOEFxa2VrSU0yZVpHUlBR?=
 =?utf-8?B?bTZJK3B1bnV2SHdpeGt0dG1TMnRWMWIzNDZoakVOZytTbHpMcjVJRERxUTRD?=
 =?utf-8?B?cVM0aHY2QkdRZ0xsSDVSckFLK0Fab0NWZEtmckZlNzdCWTB2eElkQms4RlQ0?=
 =?utf-8?B?WnQ3QVNJdjVCUStNb1hOOFhLUWgyZXNmVmFuTWp4MHlHdjMxSllJa1JQaVdr?=
 =?utf-8?B?YlljbXcvWVhDUzl1OEl1TkxCWUZOZ0U2Wnk5c0pzSUp6SUNzb1hveFhma1pl?=
 =?utf-8?B?YU1JcGpCS3huUzFJMkRLdE5WSjd1UU1PR2g2b3NXczB1WHZpUE5pNWpyaVZz?=
 =?utf-8?B?NUFJTHptMmdjcHBQQXlpU0E0bGNVS040cWhFQkxKcnh6R2dwcnBpeG1TWjZC?=
 =?utf-8?B?bTJmWWl2Z2RvUy9TdmVQVy9nT3M4ZmcwM21xaUtlN3BqWmhBL3JEREM0QmI4?=
 =?utf-8?B?MGFmQjBLS0VGUk1XZjIyM1JaUTI5RUdTK09yeWxycXhxVGduUlhLUUluaklm?=
 =?utf-8?B?MkwwM1RwOHJlQWcxellTUDFVZUFuaXpnbExtOWVRcFlhdUpiLzg4WHNrZkZW?=
 =?utf-8?B?a2JRQmRvQXFaakhqNm9lTHVvRkxlankreGtuMGNwZEVzMjczMkd6UytWNDlj?=
 =?utf-8?B?WXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A9FAD06EC0A25408A1588430CD31502@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e23a31b-d916-44e2-0a9d-08dd042ec187
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2024 22:01:41.7761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4xgwPSOYxvMQRo/jeEYdnTFJLYFsgNMNATuwCMZNp40EyREnZYktbUS888tBJCWRQ/1uWIKT4P1nQE89m/5tfnljdc5OaR58wyLDna7czh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7040
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTExLTE0IGF0IDEwOjI1ICsxMzAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IA0KPiA+IFNvLCB5ZWFoLCBJJ2QgcmF0aGVyIG5vdCBleHBvcnQgc2VhbWNhbGxfcmV0KCksIGJ1
dCBJJ2QgcmF0aGVyIGRvIHRoYXQNCj4gPiB0aGFuIGhhdmUgYSBsYXllciBvZiBhYnN0cmFjdGlv
biB0aGF0J3MgYWRkaW5nIGxpdHRsZSB2YWx1ZSB3aGlsZSBpdA0KPiA+IGFsc28gYnJpbmdzIG9i
ZnVzY2F0aW9uLg0KPiANCj4gSnVzdCB3YW50IHRvIHByb3ZpZGUgb25lIG1vcmUgaW5mb3JtYXRp
b246DQo+IA0KPiBQZXRlciBwb3N0ZWQgYSBzZXJpZXMgdG8gYWxsb3cgdXMgdG8gZXhwb3J0IG9u
ZSBzeW1ib2wgX29ubHlfIGZvciBhIA0KPiBwYXJ0aWN1bGFyIG1vZHVsZToNCj4gDQo+IGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyNDExMTExMDU0MzAuNTc1NjM2NDgyQGluZnJhZGVh
ZC5vcmcvDQo+IA0KPiBJSVVDIHdlIGNhbiB1c2UgdGhhdCB0byBvbmx5IGV4cG9ydCBfX3NlYW1j
YWxsKigpIGZvciBLVk0uDQo+IA0KPiBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgdGhpcyBhZGRyZXNz
ZXMgdGhlIGNvbmNlcm4gb2YgInRoZSBleHBvcnRlZCBzeW1ib2wgDQo+IGNvdWxkIGJlIHBvdGVu
dGlhbGx5IGFidXNlZCBieSBvdGhlciBtb2R1bGVzIGxpa2Ugb3V0LW9mLXRyZWUgb25lcyI/DQoN
CkkgdGhpbmsgc28uIEl0J3MgdG9vIGJhZCBpdCdzIGFuIFJGQyB2MS4gQnV0IG1heWJlIHdlIGNv
dWxkIHBvaW50IHRvIGl0IGZvciB0aGUNCmZ1dHVyZSwgaWYgd2UgbW92ZSB0aGUgd3JhcHBlcnMg
YmFjayBpbnRvIEtWTS4NCg0KVGhlIG90aGVyIHNtYWxsIHRoaW5nIHRoZSBleHBvcnQgZG9lcyBp
cyBtb3ZlIHRoZSBLVk0gZGlzbGlrZWQgY29kZSBnZW5lcmF0aW9uDQppbnRvIGFyY2gveDg2LiBU
aGlzIGlzIGEgc2lsbHkgbm9uLXRlY2huaWNhbCByZWFzb24gdGhvdWdoLg0K

