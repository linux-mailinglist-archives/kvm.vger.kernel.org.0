Return-Path: <kvm+bounces-54342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD8D6B1F13E
	for <lists+kvm@lfdr.de>; Sat,  9 Aug 2025 01:19:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 717E31AA7EFD
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 23:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27CB72701D6;
	Fri,  8 Aug 2025 23:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mQ4ofLDT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5857346F;
	Fri,  8 Aug 2025 23:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754695133; cv=fail; b=Ra5SN51feEexa+hvzVClnjsa8095hvFJifbKS0V6NTxcNf5ywMZ3ajtdUqX4EFCgCA+lqaucfcO/8t2Wqak1dFh1IPODQOXdApV/gAP9GaQMi1sGbcz/Cany3DwcqikJ/lW7ddsDERU0u8ZpLlnOAUc9/aALGnpfuf8e/n4mrvM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754695133; c=relaxed/simple;
	bh=s1Vr9GmCq7OAZEHCbO9oj/JURxWaTlp/FM6OiUvsXng=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hNK8rCmZuUZLrugTIfg5rkAAFTxtxdwlrOiGj1w3K52JbB2vToORl7bGaZi26TjBQXOq+a7VuCN42Ww5lIyO05sJyQLQk7CwiycWDPeOkckJRkgk6eyaF3w5dhH3wkig9y00giM5mqTNUNcCw4GarJ+CN7uExxhPrE9EC4dtWKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mQ4ofLDT; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754695132; x=1786231132;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=s1Vr9GmCq7OAZEHCbO9oj/JURxWaTlp/FM6OiUvsXng=;
  b=mQ4ofLDTd73XTNVRi5WTgwF1N6rBndtqK0YF/x9VwvNeJ6wVe8enFzBE
   Ahv9e5pngXf6tMPWQFLtV7fsK0q/MaympG1Pctu9bW5acZX1NpnYoGbuN
   H7Ys4k8+KVpm/ceOW2RJ+2XEvCRRnMcVneMo/pPHf1vq5oIGpZQeoEmMc
   fUVT55wBJWcaHERj8mxq9GF09M6J6v+i6KWNWGhCkuDNrq87oTBgmtSkz
   EvL1J0FBmZevu+3GI2jR8HQ1+vQOboFe4Bfbpj7J9XI5OztKZ6/fu8fWY
   8PCfl8jcq7BnNwUiz1OJyYVqDgHlE2ubvwZx2yKmBz52dwsrUFdgCx4pL
   Q==;
X-CSE-ConnectionGUID: QsWEde2NQ9+sfE773mbm4A==
X-CSE-MsgGUID: BXnRnGXARLGM+BMHCuGI7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11515"; a="82492088"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="82492088"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 16:18:51 -0700
X-CSE-ConnectionGUID: qgoScm0SSnSaeLzr/MPO4w==
X-CSE-MsgGUID: MqG1Hl4sT6+8p39zzplg6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165330588"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 16:18:51 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 16:18:50 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 8 Aug 2025 16:18:50 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.56)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 16:18:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=od9Y2PcF858HadSdpPK9Gu8zUPlnsFX4JgtHvS+qwC3NnYCGXMupryeHfu+FkG2xV0x/TZ/7ZGsypC0ergcQm10RZPauoRTDNIKXGveMyl9wi393FELIHfpysXDHKhmZI/5wF6YRaABCbbq8POmfnffE9/xNY+k6Es7RFTa/GYGkzsZRlJZHbQRk+vyv5FgSqJFti6iDypw/e/0EMuqGcYMnSeDMnI/tL0URIIVxfFtHII4Bqxi/qv8Q7rz3WonoIeo5TpUCbQeolmx8aIooIv2AGlFN6KdUOX9LQmYxQ9IdZxnaVCM7oMxXv2c6QshpThnWTbG85rBuf4LuGKPeVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s1Vr9GmCq7OAZEHCbO9oj/JURxWaTlp/FM6OiUvsXng=;
 b=SPYyKgap554f4b6x8pYIJAXcG9MVM1h4tQTX5a8ULuW4p7SLPHgdL157DkAWxSI1fiLX68bVNaiL/dwWhPkALLTyjAejaQoLKOi82+y/tQiOnChRovtna90kWxMJHxxXRFerd9f5KFkhmRrN4VDvpD0wNbjgTdeTb3TwE470lema+uBTq1n31wzUq5+6vHWNULTvGCoeHI4lgdGvOqC4tbTD1Rt5VGeFgDfnv+5K47ZuH6C3AJTerB/3nkbwSSPvY2P3ZgRqiUjp1tR8pLB8atxPSYiLB9SF1EpU2XOf81iGPFDKnXjjxaeuSXyVGxspCqOZIs5tvn22T3VwfFfTlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB6197.namprd11.prod.outlook.com (2603:10b6:8:9b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 23:18:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9009.013; Fri, 8 Aug 2025
 23:18:40 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Huang,
 Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Index: AQHb2XKrCJQDYmgN9EmkL7mVJaZZf7RZwqaA
Date: Fri, 8 Aug 2025 23:18:40 +0000
Message-ID: <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
In-Reply-To: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB6197:EE_
x-ms-office365-filtering-correlation-id: 01616f7c-4f9d-4af4-2c9c-08ddd6d1e945
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RWdVa0JaU2o1dG1DUW14VEhENXFNbm1CWU4zaDRlb08yc2svaXo0WENRQUdt?=
 =?utf-8?B?SzFRaU9YYTNwTEsvWUtKYU1pYXpkSUZkZUlDUFU4MzlnOWFlVk41dmkzY2Jh?=
 =?utf-8?B?Mk53Q0JUaVVkYUVvNXV6V3VmNG5BQkhzY1NUb2pkRkJCekkwZG1XS3ZZdk9a?=
 =?utf-8?B?SWZGZ3JaOFBsYXpxY1pnWVVvTWNOam5oODFOOG51Y04weGxWOTlOVkthSG5l?=
 =?utf-8?B?eVJoUnNZVHVvTkM3MVFCM0tnbDZlOUNaMHZwUXVOVi9EVUlxOWpad0FuMHp2?=
 =?utf-8?B?QlFVVzRHZkluWGpQZVZ2cWpXaWFaM3NYbVo5UFdvSjBwQ2tRUmxhNkNQSGdr?=
 =?utf-8?B?dklZOHdnakg3UjFMeDVybWxzUkxRZDBNYmMrQkN0K3R3R0dZMndZOWhieW82?=
 =?utf-8?B?aWVsSXY0OGJoS1V0TG1DQ3pINUdaMXY5UmdoZkdXNkk5dHBaZjJHYkt0TnRP?=
 =?utf-8?B?MFVxa3o4cFRuRzVaMzJheVI0Nm1JK1ZPQ2NMeUhyK0ZKV3dHckU0SmZjbW1s?=
 =?utf-8?B?QXR3ek9xS01heCszazFYaXhNTFJxckE5bitydVlsRW9CeTZMYW51TnFLZmVq?=
 =?utf-8?B?aUZLS3Jod3lsTWVZSDR3Z2NvVmZYSTJVcWRUOEJlL2RFMjlyNTg3OUliWC92?=
 =?utf-8?B?dktHelVUWGcvMDd1OTdaaTN0MFFTNnk4b2UwTVA1T0tvYUpncGFhODdYRDhm?=
 =?utf-8?B?WDQ5NjEzV1VScUxMVzdyZVlSVWRJNVl2WERWM0Mxc2RFMmJkTlYyaE1iczVH?=
 =?utf-8?B?QUsyR29uUzFJQTlOSlR5UHJvU0RTNGczUmVPOWdWUVl6c1FQWmlpZ2VVS0FJ?=
 =?utf-8?B?eWRXMjdITEtxVFVuTW5YTDVEVWtHTG1mZVppaWl3Q2FGUFFvbGgrczVWTzhh?=
 =?utf-8?B?cmNaRW84dVJTaXl1NllSQ1liSU1jQnJTMGRLZFFCS1o2dTVLQ2s4S0YvczNs?=
 =?utf-8?B?a0JhNnZKS0o2bFlNbWNwN0pvOERYNlZINi9xbUtRMHVJclcyaWk0T09lTUJ2?=
 =?utf-8?B?TWE4MnFuOTlMYVpNbnUvSkxLS01GK2NHMStBYjNhbHRxUE0vNVlrUU1HVnph?=
 =?utf-8?B?QTB0NzE4UHV4NVJFcVJGZTFsaG5JYTNRRmI0TkE3ZTNjd0R1eTg1dFRNNEhF?=
 =?utf-8?B?RkZqRXp3ZlNtcEZQckJDY1VpVU5kWFptallTbExscEs5OTlzbUJBTUlsbFZl?=
 =?utf-8?B?cXJyaFllRmI4MHZMK0pnSGNBbTY1alBwUTh2RXd0c3ZuUkoxL01QTlRwRjBX?=
 =?utf-8?B?ZUtlbEwva0t0Q1V4MmlYendQUTd1cFJUb0hwUGhsZ0hUbFVlM3dVY1JuQU4y?=
 =?utf-8?B?eVcrdjdWYzdHdmtlTG5mN3M3bC94eWR1eUFvQnlEMGplbHM0VXNCUEpuSFNX?=
 =?utf-8?B?UkZjdkl5emhEdlN6WHZQNUhIZk5wSnorVDNyYXlSWUxVYjE5QmNhOEVyUHN1?=
 =?utf-8?B?bVlLYmFNbERVZDdWM2lrekQ3QW1rZnhqak9wUnduTklLWVp5a2JScFhnSkM5?=
 =?utf-8?B?aHNmVjA4UjlJYVZUWlU2bmV5dW40UW5hZ2N0dkVjTlU3NlV4aFNCME1JNGlR?=
 =?utf-8?B?ZTY1VzREem11RlpwbkYrUFY0NWM3bnZqUWQ4YXFzUzdwZ3ErSVkzdjJKRGJV?=
 =?utf-8?B?VWV2dWxtY2VlbTBZUXgwK3RXS3B0TGZ2MjBjakhLbm82QWhrM09iTFVQSUNn?=
 =?utf-8?B?eDJTYlFrVmlqcTZHSExxOWFiR1dYSEJ2K2o2eCtkWTRDZFNsNEJ6cUJPcEZY?=
 =?utf-8?B?SnBESVZvMHIzV2FXZHJlQVZjakpxV2ZnMzJLQUErQVU1VGxRSVk0ZnhaZ2pt?=
 =?utf-8?B?ejdpTWdSa1U1cGZFcUR3Mkp3cjVnbjdvNlJLVlo4RHZVYXR0aVFiYmZuMmF5?=
 =?utf-8?B?MDhXRFFnNmpFUm5FV3lPeDNGK0RvWmF4bGMxcEZwNnJMUitCc29uT0EzNVZm?=
 =?utf-8?B?dlNLTlpKeE4vUW1YODNRcHJ3SmFtNExhQWlsbDg5K2I1UlZxUFZDQytHNFNP?=
 =?utf-8?B?QW1RSEFKeVhnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjlqL05MQ1FWRFgxbG04TW0xM1hVUDQzY1o1bmpJbXlEdFc0L2gyRHlCS1hN?=
 =?utf-8?B?dUdwUzJPZTBSQWlWdVNFb1dOdHJsODZ2M2dvVm1RL1RlbUw0ZWJLektheTd1?=
 =?utf-8?B?ZEUxbFlJMGhpR2dZa1pSVDJ1WWhGbUVqVFhINDY1L3BsajRGUzVYdlkxNFVZ?=
 =?utf-8?B?eDFDYlVJMjErTElaczZEeTVNRWlYcU9ibEZXc1VtVXZOQnRXSFMwd2N4TklS?=
 =?utf-8?B?ek1uZUZlZUhQb2xyOC8reG1GMXRaL0ZBQ2RkNHE2OFcyNkdGOFVRalJYaUdT?=
 =?utf-8?B?WU5hVkt6ckh3a2FDWVhEYkYwZWZmcnlmWUh0TmQ3N0VrS3ZLV2dleXBwWC9p?=
 =?utf-8?B?NEp6Y3lsSmN0emRIUzVoVDVMRkwvOEMyZThYSm9naUFPbkhvdXZrQTVuRk5C?=
 =?utf-8?B?RzQ3bXdxUUlVTU1NWDZncjFoRXhUVy9RUElZUU5KV0VHaHVtREU1KzRjYnYz?=
 =?utf-8?B?eXRzS1lxYy8rUS9PUWJZZGlWT092aDZzSy9Fdy9MUlVWYWdZVEpGTWJ2WmNO?=
 =?utf-8?B?ZTNIUElVVDdWZmhraWdLS2tzaHRjY1Zqd0RGRkpZU3dLVmJCcmxXZTUwaHRQ?=
 =?utf-8?B?OFVMcTBpRlBDeDA0SDFjNFRkekRoelBkNVZyazFXZEhob3lmb1R4aGh2TlRG?=
 =?utf-8?B?S0tSTW5yU1Y1eHBVcHJ6ckRTbmNhVXRQRjg5c2U1NzZzMjJwT29nK1VTbXg3?=
 =?utf-8?B?Tmk1SkYvMHUzb3hwVHRCSGpoOWp5d0NCS01qU21RS29YUVZvaWlBYXVyVUEw?=
 =?utf-8?B?aUFKTTZHVlBsNmt4SmFrRUNxNndIWGcxT1R4RDVBS1lLcThBRFlvUkJLMVdL?=
 =?utf-8?B?a0ZaWVZnUm5peFUwOFVpc2F2VGx3QjBDc0FVTmp0MkRoVVpjcTUzcERMY1lw?=
 =?utf-8?B?eDlPb0ZtM0MzTWVrRGcwaCsrVmRrR2NtL01uNDY1ekVmbnVnc2hoTWQ4WGp0?=
 =?utf-8?B?clN3WUx6eFNOVFVRajhDcW41YVhsQ0pyQ3lxTzc2TUg4am1yY3FvM3FBdmdx?=
 =?utf-8?B?eFVML283akFhNGpha2VEK3NPM3diRUc3TVBERGVYOUdRYUIvN3JUbzdJdkNw?=
 =?utf-8?B?dFBkTlVxZ3lIQ2YwRGNPdG82TXZGekxRVVpJUnBkK2NmdXgrOC9VTVROOWZO?=
 =?utf-8?B?N1I5NVhTeDY3UFBOeDJlS0MrTENZNDA1VFJGZU1SZjNMMUlsVW94WkJRSlpx?=
 =?utf-8?B?MDM4YzJWQ2Z3MlUzZ2pMZWFZTFBDU25jdzkyZ1lmYU5kZXBBMy9KdWR4ejlj?=
 =?utf-8?B?Q25xTFNiYzRkdWVDbDRlbjFVOWVhZ2F2bC9ldXloMlRRMDZwWmRwLzV3c014?=
 =?utf-8?B?bm5SRERmQ25zVHk5SWkzdGxQOVV1RjBuSDA0YWRiTFY4ZUE2dzVHY3VUNHFa?=
 =?utf-8?B?eTlReEJydkhweWJaSjRndFR1TFBvTjlnZ3ZLQjRaYUE2bmVXb1V0SFh4aUFL?=
 =?utf-8?B?M0cyL2FzOEY2eW1CdmJTSkFNZTV3dkR5eXptUndidFZSc3dFMWhPME9WcGk5?=
 =?utf-8?B?UWQyR01sbkliQnJyem1pRWI1c0lhUURrMmVNMFhRQllwWUZoa1lGd0xwMmJt?=
 =?utf-8?B?bkR0cUFINWoyY0Jxd0RRc2t6TU9YV1E5R1I1aEk1Q204VGFIdFlNakovVTd0?=
 =?utf-8?B?eXJVb0dFdXlKZWpMQWh4UWllZjFVWjBybkRYWnFudXhiOTB0MkFGY0YyQnpC?=
 =?utf-8?B?Mmtic0Z1VGw5eGs0RTNUelBQOU1VOWJuRWgzTEpFOHVzOWphK1d2Njk4b3po?=
 =?utf-8?B?aXFuMGdNMDhlNzh6bCtLVEtlTUJFc01tTUkxeTZJdlIyYk03TFloTVUyVU10?=
 =?utf-8?B?Mm1BcnBTUk1HR1hsOVRiak9BTzlXbHBXWG12L1JGZHRPVXFnZ290QlNvZko1?=
 =?utf-8?B?L0xxVEhkQWpNdkRoYjNvaDVKc1hUb2tHT1Q2WDMycnc0N2k0eld2V2NtUm50?=
 =?utf-8?B?QkNUYWlWWElnNmNaMGJMc3cxWjdmQ1JnZlR6OEtUNEJPSjZPOU1lZlBLM0ZB?=
 =?utf-8?B?Y1Ficm1UWEpBa0VxK2ZyVGRmU3Avcnl1UnJZRURGL0lTcXhRekVaTXVCNkFm?=
 =?utf-8?B?V1M5UnhWcGw2eDdCa0pmZ21JLy9VQTJnYjVaM0VnTk5DakptbnNMUWZ5M05Q?=
 =?utf-8?B?WFJZbDZGWXNBd3VmSWp6VjZFUjBvS2dIVUtxaXI4S1NHZ3AzRml4K2xiejRj?=
 =?utf-8?B?UkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD793492927EB84093A851F508005B73@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01616f7c-4f9d-4af4-2c9c-08ddd6d1e945
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2025 23:18:40.6472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v23tNpM3CTJTSO9CiFN6jmWpD+89XIhmYmebwdOziDo8yT7XzAnbrfbJCxfIH8bImLAJQe601d2fY4vrgvE0Eqqpb8/STkBstvcEjy3su3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6197
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTA5IGF0IDIyOjEzICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IER5bmFtaWMgUEFNVCBlbmFibGluZyBpbiBrZXJuZWwNCj4gfn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fg0KPiANCj4gS2VybmVsIG1haW50YWlucyByZWZjb3VudHMgZm9yIGV2
ZXJ5IDJNIHJlZ2lvbnMgd2l0aCB0d28gaGVscGVycw0KPiB0ZHhfcGFtdF9nZXQoKSBhbmQgdGR4
X3BhbXRfcHV0KCkuDQo+IA0KPiBUaGUgcmVmY291bnQgcmVwcmVzZW50cyBudW1iZXIgb2YgdXNl
cnMgZm9yIHRoZSBQQU1UIG1lbW9yeSBpbiB0aGUgcmVnaW9uLg0KPiBLZXJuZWwgY2FsbHMgVERI
LlBIWU1FTS5QQU1ULkFERCBvbiAwLT4xIHRyYW5zaXRpb24gYW5kDQo+IFRESC5QSFlNRU0uUEFN
VC5SRU1PVkUgb24gdHJhbnNpdGlvbiAxLT4wLg0KPiANCj4gVGhlIGZ1bmN0aW9uIHRkeF9hbGxv
Y19wYWdlKCkgYWxsb2NhdGVzIGEgbmV3IHBhZ2UgYW5kIGVuc3VyZXMgdGhhdCBpdCBpcw0KPiBi
YWNrZWQgYnkgUEFNVCBtZW1vcnkuIFBhZ2VzIGFsbG9jYXRlZCBpbiB0aGlzIG1hbm5lciBhcmUg
cmVhZHkgdG8gYmUgdXNlZA0KPiBmb3IgYSBURC4gVGhlIGZ1bmN0aW9uIHRkeF9mcmVlX3BhZ2Uo
KSBmcmVlcyB0aGUgcGFnZSBhbmQgcmVsZWFzZXMgdGhlDQo+IFBBTVQgbWVtb3J5IGZvciB0aGUg
Mk0gcmVnaW9uIGlmIGl0IGlzIG5vIGxvbmdlciBuZWVkZWQuDQo+IA0KPiBQQU1UIG1lbW9yeSBn
ZXRzIGFsbG9jYXRlZCBhcyBwYXJ0IG9mIFREIGluaXQsIFZDUFUgaW5pdCwgb24gcG9wdWxhdGlu
Zw0KPiBTRVBUIHRyZWUgYW5kIGFkZGluZyBndWVzdCBtZW1vcnkgKGJvdGggZHVyaW5nIFREIGJ1
aWxkIGFuZCB2aWEgQVVHIG9uDQo+IGFjY2VwdCkuIFNwbGl0dGluZyAyTSBwYWdlIGludG8gNEsg
YWxzbyByZXF1aXJlcyBQQU1UIG1lbW9yeS4NCj4gDQo+IFBBTVQgbWVtb3J5IHJlbW92ZWQgb24g
cmVjbGFpbSBvZiBjb250cm9sIHBhZ2VzIGFuZCBndWVzdCBtZW1vcnkuDQo+IA0KPiBQb3B1bGF0
aW5nIFBBTVQgbWVtb3J5IG9uIGZhdWx0IGFuZCBvbiBzcGxpdCBpcyB0cmlja3kgYXMga2VybmVs
IGNhbm5vdA0KPiBhbGxvY2F0ZSBtZW1vcnkgZnJvbSB0aGUgY29udGV4dCB3aGVyZSBpdCBpcyBu
ZWVkZWQuIFRoZXNlIGNvZGUgcGF0aHMgdXNlDQo+IHByZS1hbGxvY2F0ZWQgUEFNVCBtZW1vcnkg
cG9vbHMuDQo+IA0KPiBQcmV2aW91cyBhdHRlbXB0IG9uIER5bmFtaWMgUEFNVCBlbmFibGluZw0K
PiB+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KPiANCj4gVGhlIGlu
aXRpYWwgYXR0ZW1wdCBhdCBrZXJuZWwgZW5hYmxpbmcgd2FzIHF1aXRlIGRpZmZlcmVudC4gSXQg
d2FzIGJ1aWx0DQo+IGFyb3VuZCBsYXp5IFBBTVQgYWxsb2NhdGlvbjogb25seSB0cnlpbmcgdG8g
YWRkIGEgUEFNVCBwYWdlIHBhaXIgaWYgYQ0KPiBTRUFNQ0FMTCBmYWlscyBkdWUgdG8gYSBtaXNz
aW5nIFBBTVQgYW5kIHJlY2xhaW1pbmcgaXQgYmFzZWQgb24gaGludHMNCj4gcHJvdmlkZWQgYnkg
dGhlIFREWCBtb2R1bGUuDQo+IA0KPiBUaGUgbW90aXZhdGlvbiB3YXMgdG8gYXZvaWQgZHVwbGlj
YXRpbmcgdGhlIFBBTVQgbWVtb3J5IHJlZmNvdW50aW5nIHRoYXQNCj4gdGhlIFREWCBtb2R1bGUg
ZG9lcyBvbiB0aGUga2VybmVsIHNpZGUuDQo+IA0KPiBUaGlzIGFwcHJvYWNoIGlzIGluaGVyZW50
bHkgbW9yZSByYWN5IGFzIHRoZXJlIGlzIG5vIHNlcmlhbGl6YXRpb24gb2YNCj4gUEFNVCBtZW1v
cnkgYWRkL3JlbW92ZSBhZ2FpbnN0IFNFQU1DQUxMcyB0aGF0IGFkZC9yZW1vdmUgbWVtb3J5IGZv
ciBhIFRELg0KPiBTdWNoIHNlcmlhbGl6YXRpb24gd291bGQgcmVxdWlyZSBnbG9iYWwgbG9ja2lu
Zywgd2hpY2ggaXMgbm90IGZlYXNpYmxlLg0KPiANCj4gVGhpcyBhcHByb2FjaCB3b3JrZWQsIGJ1
dCBhdCBzb21lIHBvaW50IGl0IGJlY2FtZSBjbGVhciB0aGF0IGl0IGNvdWxkIG5vdA0KPiBiZSBy
b2J1c3QgYXMgbG9uZyBhcyB0aGUga2VybmVsIGF2b2lkcyBURFhfT1BFUkFORF9CVVNZIGxvb3Bz
Lg0KPiBURFhfT1BFUkFORF9CVVNZIHdpbGwgb2NjdXIgYXMgYSByZXN1bHQgb2YgdGhlIHJhY2Vz
IG1lbnRpb25lZCBhYm92ZS4NCj4gDQo+IFRoaXMgYXBwcm9hY2ggd2FzIGFiYW5kb25lZCBpbiBm
YXZvciBvZiBleHBsaWNpdCByZWZjb3VudGluZy4NCg0KT24gY2xvc2VyIGluc3BlY3Rpb24gdGhp
cyBuZXcgc29sdXRpb24gYWxzbyBoYXMgZ2xvYmFsIGxvY2tpbmcuIEl0DQpvcHBvcnR1bmlzdGlj
YWxseSBjaGVja3MgdG8gc2VlIGlmIHRoZXJlIGlzIGFscmVhZHkgYSByZWZjb3VudCwgYnV0IG90
aGVyd2lzZQ0Kd2hlbiBhIFBBTVQgcGFnZSBhY3R1YWxseSBoYXMgdG8gYmUgYWRkZWQgdGhlcmUg
aXMgYSBnbG9iYWwgc3BpbmxvY2sgd2hpbGUgdGhlDQpQQU1UIGFkZC9yZW1vdmUgU0VBTUNBTEwg
aXMgbWFkZS4gSSBndWVzcyB0aGlzIGlzIGdvaW5nIHRvIGdldCB0YWtlbiBzb21ld2hlcmUNCmFy
b3VuZCBvbmNlIHBlciA1MTIgNGsgcHJpdmF0ZSBwYWdlcywgYnV0IHdoZW4gaXQgZG9lcyBpdCBo
YXMgc29tZSBsZXNzIGlkZWFsDQpwcm9wZXJ0aWVzOg0KIC0gQ2FjaGUgbGluZSBib3VuY2luZyBv
ZiB0aGUgbG9jayBiZXR3ZWVuIGFsbCBURHMgb24gdGhlIGhvc3QNCiAtIEFuIGdsb2JhbCBleGNs
dXNpdmUgbG9jayBkZWVwIGluc2lkZSB0aGUgVERQIE1NVSBzaGFyZWQgbG9jayBmYXVsdCBwYXRo
DQogLSBDb250ZW5kIGhlYXZpbHkgd2hlbiB0d28gVEQncyBzaHV0dGluZyBkb3duIGF0IHRoZSBz
YW1lIHRpbWU/DQoNCkFzIGZvciB3aHkgbm90IG9ubHkgZG8gdGhlIGxvY2sgYXMgYSBiYWNrdXAg
b3B0aW9uIGxpa2UgdGhlIGtpY2srbG9jayBzb2x1dGlvbg0KaW4gS1ZNLCB0aGUgcHJvYmxlbSB3
b3VsZCBiZSBsb3NpbmcgdGhlIHJlZmNvdW50IHJhY2UgYW5kIGVuZGluZyB1cCB3aXRoIGEgUEFN
VA0KcGFnZSBnZXR0aW5nIHJlbGVhc2VkIGVhcmx5Lg0KDQpBcyBmYXIgYXMgVERYIG1vZHVsZSBs
b2NraW5nIGlzIGNvbmNlcm5lZCAoaS5lLiBCVVNZIGVycm9yIGNvZGVzIGZyb20gcGFtdA0KYWRk
L3JlbW92ZSksIGl0IHNlZW1zIHRoaXMgd291bGQgb25seSBoYXBwZW4gaWYgcGFtdCBhZGQvcmVt
b3ZlIG9wZXJhdGUNCnNpbXVsdGFuZW91c2x5IG9uIHRoZSBzYW1lIDJNQiBIUEEgcmVnaW9uLiBU
aGF0IGlzIGNvbXBsZXRlbHkgcHJldmVudGVkIGJ5IHRoZQ0KcmVmY291bnQgYW5kIGdsb2JhbCBs
b2NrLCBidXQgaXQncyBhIGJpdCBoZWF2eXdlaWdodC4gSXQgcHJldmVudHMgc2ltdWx0YW5lb3Vz
bHkNCmFkZGluZyB0b3RhbGx5IHNlcGFyYXRlIDJNQiByZWdpb25zIHdoZW4gd2Ugb25seSB3b3Vs
ZCBuZWVkIHRvIHByZXZlbnQNCnNpbXVsdGFuZW91c2x5IG9wZXJhdGluZyBvbiB0aGUgc2FtZSAy
TUIgcmVnaW9uLg0KDQpJIGRvbid0IHNlZSBhbnkgb3RoZXIgcmVhc29uIGZvciB0aGUgZ2xvYmFs
IHNwaW4gbG9jaywgS2lyaWxsIHdhcyB0aGF0IGl0PyBEaWQNCnlvdSBjb25zaWRlciBhbHNvIGFk
ZGluZyBhIGxvY2sgcGVyIDJNQiByZWdpb24sIGxpa2UgdGhlIHJlZmNvdW50PyBPciBhbnkgb3Ro
ZXINCmdyYW51bGFyaXR5IG9mIGxvY2sgYmVzaWRlcyBnbG9iYWw/IE5vdCBzYXlpbmcgZ2xvYmFs
IGlzIGRlZmluaXRlbHkgdGhlIHdyb25nDQpjaG9pY2UsIGJ1dCBzZWVtcyBhcmJpdHJhcnkgaWYg
SSBnb3QgdGhlIGFib3ZlIHJpZ2h0Lg0KDQo=

