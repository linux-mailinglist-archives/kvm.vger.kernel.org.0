Return-Path: <kvm+bounces-51202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B887AAEFE9B
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 17:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 600D1188EDCA
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 15:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A08DE27A101;
	Tue,  1 Jul 2025 15:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GIKAJsXQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471AD26FA62;
	Tue,  1 Jul 2025 15:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751384568; cv=fail; b=ls0RdGbfePJjA/oQ01tbqB857HloH0nirp/ccSTLF654OEuyh7gXmC+fqhSZsGFChaCUnBQsHAaeIWYnp6FavtCNMSX3cCvdloOu6vHLN47bDylBzsNWaoPJU8Xv8go0UiTqDpO8tQe/pZQTboztaYgzpuDVwfx6WuvV06OG3Rc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751384568; c=relaxed/simple;
	bh=btky+qKM82xwByAMb8BA+QMhvKyo24ASO980dDtUwF4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qWslucIgNPTwGvDJINE4AvK/nnZ0Me8QiCk9b0VY0l8n6rogK1qc+k7+Ldc+3H+fn5rV+w/Gt+rgQKt1k1Q6d7Py1L2zRgvxLoAb5iRf4m35Ra40piya7WcV8pULMmvbZMDNJKtbbGPbLT7vdwB+1g+VVJR4guvrqhHhpLVoplM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GIKAJsXQ; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751384567; x=1782920567;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=btky+qKM82xwByAMb8BA+QMhvKyo24ASO980dDtUwF4=;
  b=GIKAJsXQfgi1uU+D2AQTGZZLuQtMS44sDKCri830WIJ+taBwMUt+Ir9z
   df+25TecTBU57EjCvNS94dfqg8FuI4SR9eNIg+ajkMeSzlwlRukKBSEw8
   dro5UvFUOT+OAr9ArLlOXYhUTfe7Qae2I3E+meKQMPyRwq9SCsl99WOw8
   NbF3sjIAdZcvT7QrDKCsaPdGx9CJQ5DiO7zLEWnS6TYOO5E5MLaX2jTz3
   oWTqgucqF1XnaA0WWIbQq8PrtwkqhrNDzmeNzDw8THMb6XOeqnqqWy0n+
   1paEvTlr7hSBDSB8YMkjphCEr4cHkq/Xe75ohNMY3svOZPbe9lrEsNPPv
   A==;
X-CSE-ConnectionGUID: /LkTPcyMSBq69ND3uWAFNQ==
X-CSE-MsgGUID: gWduWCV0QMOB9aAD6ulf3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="57468150"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="57468150"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 08:42:46 -0700
X-CSE-ConnectionGUID: DKAYZXU1TD6IticS2WjY8Q==
X-CSE-MsgGUID: COJuLhjHSpSNeMJSTfsnJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="153965588"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 08:42:46 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 08:42:45 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 08:42:45 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.78)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 08:42:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F9VBwCQv8cdZN5Jw7zIrXFKu6nrfuMNdGkZtjgRW+PSLs6yGvDObFvwUXBV/WbEG7YU+064HgXFtfYS550XC9cdXLG28lT2zpjt0QrezR9m74W2Tia6j710VfYMwV17rr82EEs7kAdjq/NGsGFuJIYCOLp0ydeGK6mrToEz7A7DaSrWs5stgYMENxnO3xA2u5X1OubGotUYoMf1QoGZc2QCyEC9eWV6CpJJdeiTWkUU/bsBUn1HplRnU7dsqLNArUayHtIlTX1P5Gwd6RxMmpF+oGt4eFopOir6pviKuX68ITw1g+QLkxYgASlJ4Ha2lHJloyH5rsiBq3MHFicV91w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=btky+qKM82xwByAMb8BA+QMhvKyo24ASO980dDtUwF4=;
 b=ElT59HwFokamVRHfHH8SZh5aytmYkl4tcp/HUWoOK4XjZXfFpQWk2KnSDJFZTNb9YSiGI0VlgLyV/GqJ2jd7HYk69aSL1IlNB80Okd8XBcFPBBD8Hu6mfqmDeFWtQR5L6KJxUy2/yH9ngUUhmXNsQjVFzibGaFBkPQvj2seWoEigaisKjV3BalLkmKNXIoqt2dNJw1XmbkENRsUg4GCb/TVEJXUoJhXczDaZy/Rvj1FFPQ6bSaAf+GPttARcPgci4l+3MXbymptzAXAi8cSsj9yQly8+wBCPBWIPDUayisPq7C/dH0IDNqIIPTfwfjYvFG21rjQkx/TRLzLE9xePTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB7608.namprd11.prod.outlook.com (2603:10b6:510:269::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.20; Tue, 1 Jul
 2025 15:42:28 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.018; Tue, 1 Jul 2025
 15:42:28 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAABkngIAACJUAgAGDrACAAALngIABC0kAgAB2RoCAAUnBgIAERXKAgABwaoCAAQargIAAQigAgAAIcwCAABvRAA==
Date: Tue, 1 Jul 2025 15:42:28 +0000
Message-ID: <69c4b586bf6f6b1e13ad59113730548c84424ecf.camel@intel.com>
References: <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
	 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
	 <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
	 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
	 <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
	 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
	 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
	 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
	 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
	 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
	 <aGOr90RZDLEJhieE@yzhao56-desk.sh.intel.com>
	 <CAGtprH86-HkfnTMmwdPsKgXxjTomvMWWAeCuZKSieb5o6MvRPQ@mail.gmail.com>
	 <CAGtprH92EddcAi6YgfT+Z0LjduRm7=sG-xWwdSudUCt18i=VSw@mail.gmail.com>
In-Reply-To: <CAGtprH92EddcAi6YgfT+Z0LjduRm7=sG-xWwdSudUCt18i=VSw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB7608:EE_
x-ms-office365-filtering-correlation-id: 06b9b8f9-ce17-411b-dd22-08ddb8b5e254
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aU9MbmJiaGNXL0tLZlJQNW9zQUFyeDRpNFBkS1NIeUVxRUgrbmxoUzJlRlNr?=
 =?utf-8?B?RWRqM1E0T1MxM083TEtxNVdaSW9PTHpqVjR4cFY2NWNIcDQ0THJQc1FwUjNO?=
 =?utf-8?B?cHpqZ1FvcTV6dG1FemVBZ3pldXgxa0o0N0FmbXJKUHF2cXBzb3RjRUMzcUR4?=
 =?utf-8?B?d0hEZURQQ0dqVXlPZGhHSzA3ZitnT1NSQ2lVR2NvVGNwOFNqQXRSa0hYbm8x?=
 =?utf-8?B?UldNQjBVT0RxZm9nQmdHVUFpMHBtWDZXSS9UVThhaHgvOFBxaGErSWJ6Vjl6?=
 =?utf-8?B?YjNlMDdzY0pYTmh0L3FiM3R6eG0veUYvTzUvY2ovbUR6QWNValVPR2pmejd1?=
 =?utf-8?B?UFQxMEFrVjhOODdRaW9RV3NmbndXZmJnUFk5Q0dnRU8wVVREV1UrUUR3Q0dw?=
 =?utf-8?B?UDNVTXorenlUZnI1RzNsaUQwN2wwNkRsemwzUVlBUmhQejc3OXcwUmpQWmhu?=
 =?utf-8?B?Sk5idjhGQVVURWJMaDFiZ0Z0WDEzNXVCQ1dUWU1FcW9ONXFCb2ptemJOSnNm?=
 =?utf-8?B?cktGZVFJYWRqVkFlbUtwNWRSbEF4T0RnZHpnYUVudjl6S0RCTDVseTFZU2V1?=
 =?utf-8?B?NVBDMEJ6cnhRUWFpanRLU3hCMXBacStxd3EzRk1Dc2VNcENZS2JVTzl6c3lQ?=
 =?utf-8?B?bHJGWEdSVDFoU3ZSVHd6MHJtQ3ZrdEFtMkFiM0VCK1AxYzJwUTVWYStaNjg5?=
 =?utf-8?B?MUd5Rno4eUlDc3NVd3l1cEFPOHdBTDlFVU5nUVZwNGFJdFpWQlVHN0MzYlJw?=
 =?utf-8?B?Sk42aDNHenJrWlY1WTVlcGVTQkg3dkVkVS9DWkpoY2t0Y3FBQkdoWjNNTDdB?=
 =?utf-8?B?S1pmR05ac1JyQkxESXBZbUFhM3U0VHV3anQ1c2RRRlhMRkhWR1hDWG12MW5X?=
 =?utf-8?B?am5nRml0R0ptcFNFdVN5eGZYL2VVRERNbGhoTjAzWXNsUmx2VjlwUXpPc21K?=
 =?utf-8?B?M3pvS1BKQms0R0UwZW9xMFhpMEsrczNKUVlzN2xHdTZuQ0RWTGVFanVNbnVC?=
 =?utf-8?B?dU9keEJzSjlENVpNZzR4eHdRKzl1ZXllSlZrY1VoMS83WGhZZWZvOGh2ZllJ?=
 =?utf-8?B?K0Q0U3ZqRlhnMFIweWlVSk91aUNuNkJpdHhqT1hibGRRQkxGQ2VOR2Nmb1Z3?=
 =?utf-8?B?cmFkL3M1M1BxSEtwWGR6Rzh4R09PMmpWNW1YQXRVYkp4SkUvK2ZVc2ZzUUZX?=
 =?utf-8?B?eWE3NXQwSzgzeVgrVGlBZlIxYXhhb3N0eUVvYnJPaTNpOFhkYWpSbkxMQ1ZL?=
 =?utf-8?B?WHpCcUV5RHM0dG91ZzJDOTFYdlNBaHd3ZWl6Z1BsVE5OVzJRVEZZWUR1cmh2?=
 =?utf-8?B?N1huZkdDMk90NEl6b2ErbVpTUFpva0dFQ093Vk40eGNiSjNVQnVTOEp1UFhp?=
 =?utf-8?B?SlNPcXYrWUpVMFBkOWltUlgvTDRFVlp4bDEzNXE2WENwQkJYd0xrdlJpbjFW?=
 =?utf-8?B?amJOSDd5b251SUR5Zmd5cEI4S3J1cy9paDhUb0V5RUk3Nm90NU9XT1Y2RUd6?=
 =?utf-8?B?WU0wamhJTVlkTW5QRnZtMm1JaitpMmRkaWtZdC9nK3VWa245S3R6Y0tmck5O?=
 =?utf-8?B?dVRMUnh6ZHQ2eWgvUzlueS9ZQXErTVpTb1BhdzRGZ3pMdjNTR1B6cHVUc2FF?=
 =?utf-8?B?Y0pEbGNGOEZ5ZHlncC9NM1dxR20wcUl0d2lTek9CRzhKVFF1S3E0SnBIRjFz?=
 =?utf-8?B?bzJDa3hWOUVlUThLRGpMdUtLUFdSUy94cXB3Sk0zalBoUXBIek42Z2ZzS3p2?=
 =?utf-8?B?ZEtEejhHSFppN0I4ZmlwUUJ0Z21zM1BGVkUxR2RTK2ZENFVZc0xiQzgxcFZF?=
 =?utf-8?B?QTBQTmdCM3RaenNmNzYzOXlGKy9vQXlOSHdRZEMwTEZTdUVOQjFaTmpoNmRZ?=
 =?utf-8?B?R1lLMmp4RSsrejFJUWFGQ0EvZmJNRW9ZdmtsSHB1M055aVkva0pBVjN2eHd0?=
 =?utf-8?B?YmJDQmxhamE3ZmZTbWFyZ0owWWFHTjFRQUNsL1JJNFFGczZwMDNLK1VDYjVJ?=
 =?utf-8?B?RHlKaDQwUWVnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rk5yMk9WU0RhNTF1dXdlMjNONDd2MjczSXgzcTlvd21KY0FPNmc5YjFHV0Nx?=
 =?utf-8?B?WE9VOU82eVdXRHFsZ25HaGxES3V6UFozTXJ4aG1zUURudmRWQlZKZnRFcmtj?=
 =?utf-8?B?S1g0MHg0ZnZaY3BJbkx2cWxxM0tjQzRSNHJCTWI2V2FUY2RqL0dabW5aczRu?=
 =?utf-8?B?bUFpbVI4MjNyTlo2aUR2WDF5M0lNblNwTFBzWkJ6bEZtRytSUXhOV0hoS2Fy?=
 =?utf-8?B?S05Bc0EvUG5FaXFYUTZFNjFNL1gzNUxmSnlJK2ROaG1EM0ZhR3BrREtxVFRW?=
 =?utf-8?B?NSs5c2E2V3BaZXZ5N3hFc0ZIV29qc2dYUVlqTGNpYTNEamVXeWJLUWxSVHF4?=
 =?utf-8?B?UW5Tam1BWVY4RmYvNEUwejZGSngwSVh6RDBkNDVJZzArQWJaV0xmR1dxNjA5?=
 =?utf-8?B?ZEVxeDJoc1JPZGl3a1FQZ1BDZkw3b3ZlaTB1YTlvWXRXdlRtYWN2TG1vNDQw?=
 =?utf-8?B?dXNkdmc2NnlCVXBudFVqenl0dFNOOFlQOU9IM2RQcHpqNlNlaE9JRWZiVFZB?=
 =?utf-8?B?Sis0NFNIWWdDNldTUFdaN3hsbWU3eHZxYkJxaGdiN25UeG9HdlBYY3AyZ3Va?=
 =?utf-8?B?OThGZExxY3p1bWY4VHN5eWJIVEhMQTYwZ1JiSGxhMGswQUtxaVVBc3czL3FP?=
 =?utf-8?B?a1J2cVpWVk1Bb1haTkdsNm1zVUJLZzI1SWhxWEVsSEk5aXFLVGh0QlRGenRQ?=
 =?utf-8?B?cEFnd2ZpVm9FRjNwdFI1RHhrb3hRWEY2enM3S3VJQUpZWHNrUk11ZWdCUUp2?=
 =?utf-8?B?eWtGZmduWHRPWHJuNmFnZUp4RGZoRG4rdmpKYlF4Wm1PR3hURTR5SXZSa1Zq?=
 =?utf-8?B?blpESEtIK3daUWFpMkwzeGd5WEJmVGY4bzVVcm9JTUw3cmZaRHlXSGlTNkor?=
 =?utf-8?B?Y1hsdVNIRE1jdlFkK05QeEZ3N3JiZVEvSHY4a1RrY2ZPMmRWQVFiTFIrZjRF?=
 =?utf-8?B?M054bzZaRW5hOC9UMlVkdXJvNlhnN0ZNVjFzK3I4UFFtRWFxdkE3d1ZqUXpq?=
 =?utf-8?B?RXFkY2oyZllscWtTQTdkcEFEdzlJZWZwSHR6aVNTb0ZnNGEvUEl5QjZIZmJ0?=
 =?utf-8?B?TWR4VWhYejl2R1Y0MUhiNGhEWWhIUlBneXFwb1FHNVJpeXhBcTR4Y3lXdnk5?=
 =?utf-8?B?SnhXbnhoNG5pazRLTW55bmVoM1R0S3dwSDFCb203eDZMZnl2ZmgrNjNHbjlO?=
 =?utf-8?B?T0dtZ3BLYXZLNVRBZm1JazFPVGswK0JHSHUxUDZFZ1RXYjFGcW5tMUZjckZi?=
 =?utf-8?B?aWV4ekZoVU5OSGEzb2V6Wk10U3dVYkVBY0lCZzRhMVoweGRkQzRrS0cxcGNH?=
 =?utf-8?B?cGF5Q0twZlNKNEJnNjZQaGM2V0ljUzRKajk4a0p2QklORVFnODN5Z0NrK2px?=
 =?utf-8?B?RHhZRlEyc0JsdjQ4MWFJdTdZWi8xWnVrbFJ4QlNMditacjRPNENPczJuandH?=
 =?utf-8?B?S1FOV2JGZlhpVHFtalhxTldKVTlERmVEQjBoWjkvdUF2RGxhSng0V0tVenM1?=
 =?utf-8?B?ZDB1OFlVZkdseGtDaHVXL0tWMHprNnlvSmE2WHREUFo4cmpIaUpDUlNEZUQ1?=
 =?utf-8?B?NkZqWE1Pc29EZWlRK1c0MWtNNGRldVpNbkN1cGZQc0w3b0xKQ3lTRTFSU0NQ?=
 =?utf-8?B?K2NGRUtCdUYxcHNpQmlsajJBTDJsSnhDY1V4eVNuc3ZXUWdDdUc5d2dlSkhV?=
 =?utf-8?B?TysyZWF2dEFWVHhES3hYVVUxTVVhQmhQWE11Z29lb0hPaXUvY2JmbEwwZkc3?=
 =?utf-8?B?YjBYeDR5aVpLNTRtZENPM2g3cXlON05WRlFhWGFxeGFVT3Q1RnFZcGNOTUZu?=
 =?utf-8?B?U1grZ2NTY2xCZUJzSzN2cUIyRnM0ZmFkVFhhQ1F5ZmZSK2R2SU9NbzcreWd0?=
 =?utf-8?B?VjV5TkVhMlZsR2JKYlNZRDl2b3d4UEZHendzUXhlTGsySEZweEhjMTk5NXhO?=
 =?utf-8?B?ZEx1dlkzMVBoUWd5RmRhd2xMb0hJbDNCTDlMN2xjVDBIRnZ6dWV2bE96eE5p?=
 =?utf-8?B?RURCSFdYK2gxV2ZKRHM5OUtqUWo4bnFVdGowUkhJc0xhL2J2WEJKS2JiUVpu?=
 =?utf-8?B?cTU1K3FxeSt0TCtlb0libU1XQmY5bkdWYmJYaHlDdFNSTWswWDJPd3plMjNp?=
 =?utf-8?B?eUlEaTNNOWppWDNmOHZiR0YxYis3bEVDQ2VCc0Jqd0Nub01DSkdXNzI4NmRz?=
 =?utf-8?B?Zmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDB87DB75AD202428E1252F3B1545D4B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b9b8f9-ce17-411b-dd22-08ddb8b5e254
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2025 15:42:28.1896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fvpNOqvabyjZAuVWmesfJlCnnXZOHBtMAvkr5Zx231zl7mSMuNjUHFfy00yp5UgsZvVfZy8kTCSUUU2bQ8R1UkKU9K3kMoqNf2JyFQphPYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7608
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTAxIGF0IDA3OjAyIC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiA+IGd1ZXN0X21lbWZkIHdpbGwgaGF2ZSB0byBlbnN1cmUgdGhhdCBwYWdlcyBhcmUgdW5t
YXBwZWQgZnJvbSBzZWN1cmUNCj4gPiBJT01NVSBwYWdldGFibGVzIGJlZm9yZSBhbGxvd2luZyB0
aGVtIHRvIGJlIHVzZWQgYnkgdGhlIGhvc3QuDQo+ID4gDQo+ID4gSWYgc2VjdXJlIElPTU1VIHBh
Z2V0YWJsZXMgdW5tYXBwaW5nIGZhaWxzLCBJIHdvdWxkIGFzc3VtZSBpdCBmYWlscyBpbg0KPiA+
IHRoZSBzaW1pbGFyIGNhdGVnb3J5IG9mIHJhcmUgIktWTS9URFggbW9kdWxlL0lPTU1VRkQiIGJ1
ZyBhbmQgSSB0aGluaw0KPiA+IGl0IG1ha2VzIHNlbnNlIHRvIGRvIHRoZSBzYW1lIHRkeF9idWdn
eV9zaHV0ZG93bigpIHdpdGggc3VjaCBmYWlsdXJlcw0KPiA+IGFzIHdlbGwuDQo+IA0KPiBJbiBh
ZGRpdGlvbiB3ZSB3aWxsIG5lZWQgYSB3YXkgdG8gZmFpbCBhbGwgZnVydGhlciBTZWN1cmUgSU9N
TVUgdGFibGUNCj4gd2Fsa3Mgb3Igc29tZSB3YXkgdG8gc3RvcCB0aGUgYWN0aXZlIHNlY3VyZSBE
TUEgYnkgdW5iaW5kaW5nIGFsbCB0aGUNCj4gVERJcy4gTWF5YmUgc3VjaCBzY2VuYXJpb3Mgd2Fy
cmFudCBhIEJVR19PTigpIGlmIHJlY292ZXJ5IGlzIG5vdA0KPiBwb3NzaWJsZSBhcyBwb3NzaWJs
eSBhbnkgb3IgYWxsIG9mIHRoZSBLVk0vSU9NTVVGRC9URFggbW9kdWxlIGNhbid0IGJlDQo+IHRy
dXN0ZWQgZm9yIHJlbGlhYmxlIGZ1bmN0aW9uYWxpdHkgYW55bW9yZS4NCg0KSSBtZW50aW9uZWQg
dGhpcyBvbiBhbm90aGVyIHRocmVhZC4gTm9ybWFsIGtlcm5lbCBCVUdfT04oKSdzIG5lZWQgZXh0
cmVtZQ0KanVzdGlmaWNhdGlvbi4gQXMgbG9uZyBhcyB0aGUgc3lzdGVtIG1pZ2h0IHN1cnZpdmUs
IHRoZXkgc2hvdWxkbid0IGJlIHVzZWQuDQoNCg==

