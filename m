Return-Path: <kvm+bounces-53322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E14E5B0FD88
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 01:30:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B43DAA62ED
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 23:29:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C88752737E6;
	Wed, 23 Jul 2025 23:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fajmvRsT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4312586DA;
	Wed, 23 Jul 2025 23:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753313204; cv=fail; b=X15viGPeDFmsPGnEhO3o7a+0ODgHVMRksS+h1IKYXiUmwk77+RjHQq98Q6Al50rifCDZXRgbrRW9wSj8TPc/HeBF/IsUyPhg2MejEAHZoQVv+b6TxMEzBabMn8rnQarmtxDv+Qa1qMa8YMAgVP4X3H59PxrYXg9YptSd6IxuBL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753313204; c=relaxed/simple;
	bh=MgO7HA9v78qwEQlXh+ILDdmVi6PlIIm/aeJ+dS/QEk0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RMMKnbxV9iYLTkvaHLx7hOqMG4H6olVBbiwvczLr7VUfh6+gAmPDg/lauUZ1WzBHWmJF3deyd/E3o9LIqOyrUuesm6TGZqK+3HLtoXcgBtwl0bnhFuCZgO9ZuyeJuAjz6i7gF7i68dASSmwBNu7i8lj8WU7vj7Y22g8VHTHMoCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fajmvRsT; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753313203; x=1784849203;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MgO7HA9v78qwEQlXh+ILDdmVi6PlIIm/aeJ+dS/QEk0=;
  b=fajmvRsTcdvzoXWcsQv2zCbimAtdxnna5HG0FXCFBR+sNNSai5v1GhpV
   Z4gN9BcYrY7JKmZroQw24dBXWORAprDBQ3R/v2Na21IvsFFOrAGYrRxLo
   NNgKW4RkxthsorhkaMTySFserkwOO8dDDmJJfzdMNTIiahmSlZGz3mi22
   lehZw0lTIjLLmPuDWaOSFLzGxQRIVf1f5EZ9VvZltKFQkE+QJ62hk8NnI
   dkKkjQXGop50aqCA9aFCLmufracpd72kpyxGwfWbbopeTtk59q1AIRxS+
   OMlYpUvaTDyZdSS3fSmG0Rkz7tJ5i8nKMrKz7maTWHcqDnG2hFDLwAeF3
   g==;
X-CSE-ConnectionGUID: +4LPxNrvSziUorcTg23SXQ==
X-CSE-MsgGUID: N02RxMdSTn2SfwW3mnwJYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="78149840"
X-IronPort-AV: E=Sophos;i="6.16,335,1744095600"; 
   d="scan'208";a="78149840"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 16:26:41 -0700
X-CSE-ConnectionGUID: AatYwwWoRb6ZLuDT2X4tkw==
X-CSE-MsgGUID: AQEvBn7LTA6nei8Hwy0pUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,335,1744095600"; 
   d="scan'208";a="160362824"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 16:26:40 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 16:26:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 16:26:39 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.81)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 16:26:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N0CJIopjxHSl8w25011uzV6qbhNrLnUYcK2wuhJXTJQ0RmBdiC33mjJc+qSnAqeyTAneBhZNhz/GUu15ZXOTH3Fbk87bUI2rDsdbEvai/wIuTfn01Qs9YAD8zgMdGi0QHJrWMKoB3XKppMBSeXoVZQDTSemBfLH8Buj0eqICNLz1M4ARFnDs9IgMDdypjtAT761ZlMmrxOXrmC5ownJYSz5dPmWeM+Ncmr7AlzaAn4QWscoBYI1Om4aVqtcYjrpYH4bX5TAQ1pugG1jKhaTGm+Y6qHY61iErEB7AiK0Bb+hT5K+YxudpeHWi1Q9UsftD/+reTU7tTm3h7NP77dk7zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MgO7HA9v78qwEQlXh+ILDdmVi6PlIIm/aeJ+dS/QEk0=;
 b=jyazVrTavdaRFj7cji2OcIvh81BA30EJwy0rZQmya7RaCDUIwVwP0oK860uS9dfGssgqM/P1t92maP3PXalVmgzQ6sRvaj5rzIZSA7k1Yopxa/jf5AHseOI2YAsVuchveXihpUOO6z4vfXPiPn3Gt0piiFyC9kBdpmweXcf8LnxQu3IDrHkSO0KNOYMly/1iNq9r14LpxStZWkJ/W2z5tdb+RUu0x+tqaOwr/HH9q1zEmXHGu7LjRPFou4jxq5seLsc8ZLQOJrXroEUXSG/WJSbXFa1XR2erpBsYpoaCMkojzSf5Akes/y6eLnE5mEbzb7+lOX42HEyez8ezWq8u6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN2PR11MB4662.namprd11.prod.outlook.com (2603:10b6:208:263::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 23:26:36 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 23:26:35 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Luck, Tony"
	<tony.luck@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "Gao, Chao" <chao.gao@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Topic: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Index: AQHb+8ovx0yLPSIy6USdKkSakZSGBrQ/vkCAgAAI0oCAAAHTgIAADQeAgAB92oCAAAcaAA==
Date: Wed, 23 Jul 2025 23:26:35 +0000
Message-ID: <8da9c9c9c53707ec805ccd1b7f8091081e3455e6.camel@intel.com>
References: <20250723120539.122752-1-adrian.hunter@intel.com>
	 <20250723120539.122752-2-adrian.hunter@intel.com>
	 <f7f99ab69867a547e3d7ef4f73a9307c3874ad6f.camel@intel.com>
	 <ee2f8d16-be3c-403e-8b9c-e5bec6d010ce@intel.com>
	 <4b7190de91c59a5d5b3fdbb39174e4e48c69f9e7.camel@intel.com>
	 <7e54649c-7eb2-444f-849b-7ced20a5bb05@intel.com>
	 <10af9524189d42d633b260547857516b49f9dc8e.camel@intel.com>
In-Reply-To: <10af9524189d42d633b260547857516b49f9dc8e.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN2PR11MB4662:EE_
x-ms-office365-filtering-correlation-id: beb3232a-de40-40d0-09d3-08ddca405ddb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZTAvWm1QaERueS8rQVFFNjlMTExpbnM1UUx5a1dlZ2xGTkY3dlN6SDRRWmgr?=
 =?utf-8?B?RHRjaHVmcTFCN2lyK3ZIeHVZa0VUL3BWNTMraGxKU2RPVTJuS3pXR2diQTlx?=
 =?utf-8?B?RllWL1FyTnQrZlY1QW8xa29tQVlQREhKc0RDK2phVFBrcFJ1Zk5sSnpPUjlJ?=
 =?utf-8?B?ZUh1NTRBSVpxWXU5MVJCWjNQMVhzY2RpUDhyQ1c1Qk1WSGtqSWY5VGg4aUl4?=
 =?utf-8?B?NDBaUWZzdWQ3eDBZbTc0N3lxb1A0U24zUi9HSDdnMGxsa0cwVEJlVXQ0VzhM?=
 =?utf-8?B?SzIrWS9RWUFnMEd5WDkxY0FpdGV5bkJ0T3lKYWd1aEYwTlFiRzhzSm5yVk42?=
 =?utf-8?B?T0V5NEw0clptYzFxYmduZG5TNVhodFhGT2s5ZFlIY2xTOGxsYVpCZ0tIOHR5?=
 =?utf-8?B?eTdyYlVtVTlDNnMzRlRJZmV4b1NTeUJJVENOeGg0Vm1rQjl0TG5GRGExTVli?=
 =?utf-8?B?LzNOeWZTRlNRaURsRDcvOXp3d0ZHY2xRYngzQ0FQWGhIcVA4YU1LR1VFTncy?=
 =?utf-8?B?OXUxTVBsOUNkZTBHaDF6ZjF6WUhLaFJXSjh5d3Y0WXFWTUJJVHhYeEltK2tH?=
 =?utf-8?B?bzZKWEZIdzdnb2I5ZG9xc1lsVnA0TVNheU4zaTRhRHk0S1diUFUweUltMmQx?=
 =?utf-8?B?MzN1TE1oOVNSZUYxRXlhTmdFaGVaeDlQSzB6WVpscGhncVBjV2Y4U3Y5OHhO?=
 =?utf-8?B?YWRndkx0VEk3RlJJa0Q5L2NLU0Rid0FVTEhzcVg0SHROYnhLNERNeEhUSWF2?=
 =?utf-8?B?bzZ6R0lzcmhySUVtaTRBOVJubVIrSHJpNFlURjRhZXRkY1Q5RXdOWjJraFo2?=
 =?utf-8?B?TEI5aGFaQTRsTGRCR0FSRkpRR3RhQzRZSUFqamVFN3JHczE5ejZESEwrTWQw?=
 =?utf-8?B?UExnakdpSjBsZHljTmszNDdIVTlsSHZFcHJXdWFMMGgzT2lNTmt3VTNNTDNI?=
 =?utf-8?B?TFY4YjMyR0pubHBYWmRiL2ZqTDlzVXFVejE3T0YvbHkrQTJDaXpzOHFoUWhn?=
 =?utf-8?B?TDdBbjJmK21wck9vdTJhL3pjZngwQ25heS9ESklQekpCU29lWC9CcXdSQWFC?=
 =?utf-8?B?V1EvaEh3WHg0a3prUHB0N1I1OWw2THllTVhWcnpzZm8xQjRlYTZXZlhoZFMw?=
 =?utf-8?B?K1EwSG5OYWM5UlpDNVBhL0FxaUU4QWNmNmlwSzlRSk9TOHUwdEZOM3dlMTVU?=
 =?utf-8?B?YXVSeERYYU5aWkl6ZWhwRndqR2JFS2taOFZSbExHVWpvQmJubEJFSEgxNVF4?=
 =?utf-8?B?V2hrV25Ta0kxalZ0SU1LT3RvM0ZwZFRiZGwyTU92d1Fqd3k3MlBtdEJ4ZFZN?=
 =?utf-8?B?MVY1VGsxQk9yMEtXS3hjZXFYekpYc3dDc3YvcnprNUdzNllsSlJnSWpZbnVE?=
 =?utf-8?B?K0xjTHZSUTdpZXQ1V0Nlc0RaZXlzZHJiWEkxRHFhS24rUVE2c2cyS21KS3dM?=
 =?utf-8?B?T1lQRW0raWd3VCt5WEU4eU94bnY3UFFtekU0MHBnZjUwUmpnR0g0dUZLc1hM?=
 =?utf-8?B?WUFMbmhsakRuYTFLTkprQnN3VmNzdi84bGpKMVZVZC9iSG0rUVJTekF4QWZt?=
 =?utf-8?B?c0FCV3dLNXdlcnArWm00WWRUOFdOUUZKWWZuQ0NvL29VOEQvdTUyb2hOUEN2?=
 =?utf-8?B?aUp4ditUL01kUmozNlNnaXNvZjBpckFDZDRBSUF2c2RSUkNMYXRHM3lxdWZF?=
 =?utf-8?B?YnRTZ0dyWDk3TWM4OTlYZmFkRThWOTdONDFUN3hqRmU3QUxKcTZmUkJ1cUdo?=
 =?utf-8?B?RWJPRWJXeEN4SDVLU0VkbmZvU0xxZ0NGUkN1RStmK3U0MlJvZnhzK1dRM28w?=
 =?utf-8?B?NTd5Mml3ck0reEMrUHN3ZUF2c2ZYbis1SExseTBtQlJRYm1CdVo5QkJSNU5w?=
 =?utf-8?B?N2J0bmxQVGo1UjJyTTIyRzBhL2FjOVhyaDU4QllOT0YxblM2aklNRVkvZXdn?=
 =?utf-8?B?d3lZNmtDOEF3Ulp1bE51NDczL01CdDEvd3JuV0J2TmwwN2tQaU40d1d2bUJW?=
 =?utf-8?Q?E03mgh/2iIi8TtVuT6ItYPG2zmE4FE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnduTFBGQ1piSFJvekFLUXpuUjFIdHlZZnN5YWJhKzI3YWhVTWZhOW9SdTlq?=
 =?utf-8?B?S1hiNmlydS8vZlB1RUN6SDVJZ2llUlV3WXNNUXNXRXptN21qdmhFbGQ4WEhu?=
 =?utf-8?B?T2lvOHRhRWcrVFBaL3p4dFp5Y2NQYW40bWQrSDkvbTM1Um9ldG1UMC9XY2V3?=
 =?utf-8?B?endTY0RCeGFBcXVuYzZNLzlyM3FWU0RpTWVYcm5sZWcrZm9MYjdESU5BUGZq?=
 =?utf-8?B?Z2FsdE45WTJPOWtkTU1PK1AwTnlKbWxNVmFzc3ppT1BRNUttU0doQzlYR0x0?=
 =?utf-8?B?SUY2ZVIrL1dLRjdhbkYybjlmaUVPV05NL3d3bkJSUytxN0lRc05JSGhRN1FH?=
 =?utf-8?B?MlprVDBMZ2ZXQlI3eHpyNVk3OW5hZ3RNN2pjNVgyRVhBOFI2YmlPZnIrczdN?=
 =?utf-8?B?M2l6Q0Q2ZWVDV1lod3pDazhZRnRmcmpWQUw5SUc2TmRNNHgvS1k1Wmd3bWJx?=
 =?utf-8?B?Q0Z4NkVMK3ozbjZBWDJBMWRJcHNEeFpVazA1MTJQQ3BGeDJoanc0Sk1oUFll?=
 =?utf-8?B?WWNrc2lONlVhVms1OVplUFVyckV2RDA5SFJSTkRBQStPcVk3bFJObHFBWWFn?=
 =?utf-8?B?bWM1aGdkYm5xQ2dReDRhZUtRZ2U0S1d4cnA4WnpTS3dIV2lURkhKU0h0ZGhy?=
 =?utf-8?B?OEp6L0lKcmNVNVJxWUczWDUydGZVQTZOYXA2S2dJaWovSUJWQjVOMkt2NHdL?=
 =?utf-8?B?dmRnU0NRYW5nRlVjbThPd1VlU21iRjdJK1hYYm9ZaVNaTDhvV05mVlBrd3do?=
 =?utf-8?B?ckR1OWZNMVdjdUZOblZGZTE3S3NhQ0NHRzJ1dGwxMENsYWszRzJLREVMOUhq?=
 =?utf-8?B?T3dHeXZ1V0xlem1TbDRWQkJzbGxidm1OU0ljTjVyUmhYSEQvWmdXemNwd0M1?=
 =?utf-8?B?c0x6UGtZV2V1dVNTaGk0SE5XcWRuOUpOM2UwdjlkeFZrdUY4dytGMFIza0Ny?=
 =?utf-8?B?Yk9DNUVTMkIxTDdrSzZvcXphS1pXWEpIQlZTWG5teVYzUExZeStGSlpmalRr?=
 =?utf-8?B?d25ITnRoWlNYV0FDZlhHNFFKMjM2RUpnbTl2anM1Ny83VmtuRTVwVXlCR0hO?=
 =?utf-8?B?b1JiTGVFTDdpZ0Z5aWRVSTFkUURMYk9Pc0Q0Z0VBeUJmZitNVmN0TXZFQ1VH?=
 =?utf-8?B?VS9hb1FUbHFNY21RZnNibWpZMkFJYktXaUE3UFptWDRGeUZQaTJZQmpuMkls?=
 =?utf-8?B?SGphQzJ0TzBSTCswdjNsNmhtZkpZWHFpeUxrUXlCUHBBeHN1VkJLTGU1ME9H?=
 =?utf-8?B?ZjZIbStJckUwdllaaEhGOW9DUFNaeUdxdStlMU9aY0x4V1VUNnN2ay9zNVBw?=
 =?utf-8?B?bGdzdWhuZVFSc1kwQjRWQmhDUkxSWWV4SGF3aGtCYk51ZzVSMGRWTHEya0M1?=
 =?utf-8?B?d1k4SHB1UldDdkNrMm5RQkpxTEdYZUdZYWtCUVZjSHJjcldiNGFWcmw4UFZ6?=
 =?utf-8?B?SGhaV0tmTnVaR3JjZktNVVdxcUU5TVA0aUgwZEgrSUM5aVgzcWlKc0dkOEVj?=
 =?utf-8?B?UHNPd0Y2TVNvTFk0TjBBVkVudElCNlZBb2x2LzlsNHJBQTFoZmZEcy9SN2NG?=
 =?utf-8?B?Z3NMclNaOVZzdFNONVlTSGQ1ZTNTWmFRNWFIR1o5VC9mVEZlS1c0VGNJdGFv?=
 =?utf-8?B?UHk3alBrYXNNZVpFdU82Qy9oQnpPL3hvZXpUd1VIb3FPM0pQYzJHajNBWWxz?=
 =?utf-8?B?YVU5czIzQ1lReXplTmRWMklWb1c4cFdaNk1WWlIxdXFzSjY0SlNDMktmYlNY?=
 =?utf-8?B?Wll6OXlLWGd2eTJkWUFwMDhwVGtpMDllekRKc1FDZmZ4a0oxa3dQeDN6WWw0?=
 =?utf-8?B?cld0QUZ2N0gzRlpTVVFneUVScHpjb3JMcngrZlJ2U2lnbVBXN2gwdmQzcnlF?=
 =?utf-8?B?dGhyU3lyMU5pQzhVQ3RCakJyMG5hcndKdERJUXFBaVhhTFhLMTJ2K0tST3pU?=
 =?utf-8?B?M2NCa0hFclBCV2NRYmhkb2lIUHBuYWI3bEFBclRtU0YzTlRVZWZVL0pFNzVS?=
 =?utf-8?B?K3NiN1U4TXBhVWxlNzR6Ny9CMkh2aWxHeXFyMTNzTXFZNk9yekFMMnppZ2hI?=
 =?utf-8?B?SDVORGd5amZrNlAxdHhITERUWERWYk9XaGtGdWI2U25HTG5OaXBWdmpCVzFY?=
 =?utf-8?B?Y1Q2UWhjM21FSktpN21NNnZXenRuc3NidGxsYURkMldjdWxZb2psZFFMNGRH?=
 =?utf-8?B?QUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1BFE82803198BC4EA1707632EA947C3F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beb3232a-de40-40d0-09d3-08ddca405ddb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 23:26:35.7206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saLJ8fhGWjkIcqmNoZ1jddDGDK96vz26MertsEF7iysK1rRPmgxC7kpDJAqZmfIgVfc1N4K2QrkSUtFZB8S1Ax35qGgx7aHO3x6ZiAlq2Sc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4662
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTIzIGF0IDIzOjAxICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBT
dWNoIHJlbmFtaW5nIGdvZXMgYSBsaXR0bGUgYml0IGZhciBJTUhPLg0KPiANCg0KSSBhZ3JlZSBp
dCdzIG5vdCBxdWl0ZSBuZWNlc3NhcnkgY2h1cm4uDQoNCj4gwqAgSSByZXNwZWN0IHRoZSB2YWx1
ZSBvZiBoYXZpbmcNCj4gInF1aXJrIiBpbiB0aGUgbmFtZSwgYnV0IGl0IGFsc28gc2VlbXMgcXVp
dGUgcmVhc29uYWJsZSB0byBtZSB0byBoaWRlIHN1Y2gNCj4gInF1aXJrIiBhdCB0aGUgbGFzdCBs
ZXZlbCBidXQganVzdCBoYXZpbmcgInJlc2V0IFREWCBwYWdlcyIgY29uY2VwdCBpbiB0aGUNCj4g
aGlnaGVyIGxldmVscy4NCg0KQXNzdW1pbmcgYWxsIHRoZSBjb21tZW50cyBnZXQgY29ycmVjdGVk
LCB0aGlzIHN0aWxsIGxlYXZlcyAicmVzZXQiIGFzIGFuDQpvcGVyYXRpb24gdGhhdCBzb21ldGlt
ZXMgZWFnZXJseSByZXNldHMgdGhlIHBhZ2UsIG9yIHNvbWV0aW1lcyBsZWF2ZXMgaXQgdG8gYmUN
CmxhemlseSBkb25lIGxhdGVyIGJ5IGEgcmFuZG9tIGFjY2Vzcy4gTWF5YmUgaW5zdGVhZCBvZiBy
ZXNldCB3aGljaCBpcyBhbiBhY3Rpb24NCnRoYXQgc29tZXRpbWVzIGlzIHNraXBwZWQsIHNvbWV0
aGluZyB0aGF0IHNheXMgd2hhdCBzdGF0ZSB3ZSB3YW50IHRoZSBwYWdlIHRvIGJlDQphdCB0aGUg
ZW5kIC0gcmVhZHkgdG8gdXNlLg0KDQp0ZHhfbWFrZV9wYWdlX3JlYWR5KCkNCnRkeF9tYWtlX3Bh
Z2VfdXNhYmxlKCkNCi4uLm9yIHNvbWV0aGluZyBpbiB0aGF0IGRpcmVjdGlvbi4NCg0KQnV0IHRo
aXMgaXMgc3RpbGwgY2h1cm4uIEthaSwgd2hhdCBkbyB5b3UgdGhpbmsgYWJvdXQgdGhlIG90aGVy
IG9wdGlvbiBvZiBqdXN0DQpwdXR0aW5nIHRoZSBYODZfQlVHX1REWF9QV19NQ0UgaW4gdGR4X3Jl
c2V0X3BhZ2UoKSBhbmQgbGV0dGluZyB0aGUNCmluaXRpYWxpemF0aW9uIGVycm9yIHBhdGggKHRk
bXJzX3Jlc2V0X3BhbXRfYWxsKCkpIGtlZXAgYWx3YXlzIHplcm9pbmcgdGhlDQpwYWdlcy4gU286
DQoNCnN0YXRpYyB2b2lkIHRkeF9yZXNldF9wYWRkcih1bnNpZ25lZCBsb25nIGJhc2UsIHVuc2ln
bmVkIGxvbmcgc2l6ZSkNCnsNCgkvKiBkb2luZyBNT1ZESVI2NEIgLi4uICovDQp9DQoNCnN0YXRp
YyB2b2lkIHRkbXJfcmVzZXRfcGFtdChzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yKQ0Kew0KCXRkbXJf
ZG9fcGFtdF9mdW5jKHRkbXIsIHRkeF9yZXNldF9wYWRkcik7DQp9DQoNCnZvaWQgdGR4X3F1aXJr
X3Jlc2V0X3BhZ2Uoc3RydWN0IHBhZ2UgKnBhZ2UpDQp7DQoJaWYgKCFib290X2NwdV9oYXNfYnVn
KFg4Nl9CVUdfVERYX1BXX01DRSkpDQoJCXJldHVybjsNCg0KCXRkeF9yZXNldF9wYWRkcihwYWdl
X3RvX3BoeXMocGFnZSksIFBBR0VfU0laRSk7DQp9DQpFWFBPUlRfU1lNQk9MX0dQTCh0ZHhfcmVz
ZXRfcGFnZSk7DQoNCg0KPiANCj4gRS5nLiw6DQo+IA0KPiBzdGF0aWMgdm9pZCB0ZHhfcXVpcmtf
cmVzZXRfcGFkZHIodW5zaWduZWQgbG9uZyBiYXNlLCB1bnNpZ25lZCBsb25nIHNpemUpDQo+IHsN
Cj4gCS8qIGRvaW5nIE1PVkRJUjY0QiAuLi4gKi8NCj4gfQ0KPiANCj4gc3RhdGljIHZvaWQgdGR4
X3Jlc2V0X3BhZGRyKHVuc2lnbmVkIGxvbmcgYmFzZSwgdW5zaWduZWQgbG9uZyBzaXplKQ0KPiB7
DQo+IAlpZiAoIWJvb3RfY3B1X2hhc19idWcoWDg2X0JVR19URFhfUFdfTUNFKSkNCj4gCQlyZXR1
cm47DQo+IA0KPiAJdGR4X3F1aXJrX3Jlc2V0X3BhZGRyKGJhc2UsIHNpemUpOw0KPiB9DQo+IA0K
PiB2b2lkIHRkeF9yZXNldF9wYWdlKHN0cnVjdCBwYWdlICpwYWdlKQ0KPiB7DQo+IAl0ZHhfcmVz
ZXRfcGFkZHIocGFnZV90b19waHlzKHBhZ2UpLCBQQUdFX1NJWkUpOw0KPiB9DQo+IEVYUE9SVF9T
WU1CT0xfR1BMKHRkeF9yZXNldF9wYWdlKTsNCg0KDQo=

