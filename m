Return-Path: <kvm+bounces-67718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B992D11BDE
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 11:11:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6DEDA30365A6
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 10:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C00D528CF5F;
	Mon, 12 Jan 2026 10:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hpThHDbz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB07D1C84CB
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 10:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768212456; cv=fail; b=twjNDcMhv/WQW4pSSmG7YSFbFMNTCAkTF+V8zausvWCG5vsj+J/QcM+RY3frkUAjx6uVFWFr7maebuUAnYsxhm/95ii40KRcRLCk9RjM1IBBEMBnE0aQZAXvOv7/00rIo+zlRAKzpNd/89WMtQrN13HHEoj6QNANhzkInGJ2Ou8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768212456; c=relaxed/simple;
	bh=BGjLeE3rwRecPu/p/mWD6TMv0VNejXIj1jr0zvS/JVQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t6cuXT5yetkw0hir83w+UrE/HKS4IDLYWEwCmQTm5qETkqqPBFDoJs3CLjTkXw5rskUZbuS2jdrHBZYlOTZFVEJrjN9JfA2l74ETFnhJQ5nhK6KRGMzSuiW/kR2Gi9i6dkRLI/HHzx0DL4frEixsPjc8VIAjhV5moL6NhjzTjxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hpThHDbz; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768212455; x=1799748455;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BGjLeE3rwRecPu/p/mWD6TMv0VNejXIj1jr0zvS/JVQ=;
  b=hpThHDbzhvGSgfwINMDC198LaBNn2OaiTaCSeGs3Hhr2yu9lNQVk31hD
   B3mDOrGX8Ehi2lAskXR1E2wuHSa4ASw0jqxopYv74+mXCFaoX53nGhkzH
   eOObVcLOwpy+8gLMCUfFi07rImuYumMXG9lKK7kqsH5/J5VknQKkNqEoY
   NV8vyWb78P2Qh+uE7jytw2Mdp4tCLQCntVmoNhwbTlA6nDeqgvL0/cWWm
   jL6McgjMYaaHQoxvzrFskzQYPtnkYMQTl5Bq3S7dih4AQTrqjec+xPicY
   SRRymONa27qrXLWIOAoVG+wbV+pqzFpQXojueh7/4zHNkLpSCpN2f47ll
   w==;
X-CSE-ConnectionGUID: LIyQ+J+VROi4ZdThoT0oxg==
X-CSE-MsgGUID: aHopOddNR4Gih+603giKeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="79778041"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="79778041"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 02:07:34 -0800
X-CSE-ConnectionGUID: TROzIglrTjChIH63yXBROA==
X-CSE-MsgGUID: JhaoujJbRn2t7Op1DGP3Tw==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 02:07:34 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 02:07:33 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 02:07:33 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.4) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 02:07:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kdBI38DyhmlwDLFcbfBk1ch/QN9sQaW1t/6qN6bLHzTMbYoBvA30B1vWK/g9adn9wu9C4EKSQjUoAValgP5Gfq2uI84tu1PT/pBVSqgCIc1u7EqYGFXBuhxyNnMIRpHc6AKour1iwdHj1KgQ9pVVRnWJiITeMctzKcb/vq9QaM2Ed1WeK0x/pXxolRWOfd37cTc9HR2G1g584rfOoCHmVFCNf/D+x9fqGKfLAoIKADWHhixdkepc6G7mW8PBzRWaw95CE/xaQI9VkeTfaFQ43F9IEeZTUAsLukPQY20tABdUMkZwiieP/DyfugVpRR9IOR9fjEfNdTxM/ZBIrXZwzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGjLeE3rwRecPu/p/mWD6TMv0VNejXIj1jr0zvS/JVQ=;
 b=AtBkR9GaxdtGf457ArEZTG3iPB3CTmttJAFK/PexvjxqlgERLNKKxk0lQyz14ZvJjQfNp2PSQHBvCNBB7hyDze2K/zFfDu2lvKs88E67fhkxaKNQDpHNPbkev9v0nV5XNWIOgOlsvjWzcU8YQvxcI4ku0Pm+x208mxrDZ+lQYXrq/ONkw2jWqxOKDD5gkNN4hEtWBvxzg7Dj7dYi0Ob1YNp1+4k68y1bBHqinkQ+hn90bWkwGfLfm0rOWX/5bEJBYneB0KVvKgZBFwOb8n+AFh/v0EdVka9KkJAP5Q2lvLUbxuBHt9C4Ne0winLsIskSAHkm9cSbLVSYMTQAAmK0+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB7117.namprd11.prod.outlook.com (2603:10b6:510:217::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 10:07:31 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 10:07:31 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v5 2/8] KVM: x86: Move PML page to common vcpu arch
 structure
Thread-Topic: [PATCH v5 2/8] KVM: x86: Move PML page to common vcpu arch
 structure
Thread-Index: AQHcfg27kcSI0oiiU0eUKWflF4thhLVOWmmA
Date: Mon, 12 Jan 2026 10:07:31 +0000
Message-ID: <6c242dc13ed4d5e9a5d686e26d375613ff8af3f1.camel@intel.com>
References: <20260105063622.894410-1-nikunj@amd.com>
	 <20260105063622.894410-3-nikunj@amd.com>
In-Reply-To: <20260105063622.894410-3-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB7117:EE_
x-ms-office365-filtering-correlation-id: d1f3b5ff-b881-4d30-5d06-08de51c26645
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SCtQMU5nQlRCcHJidHpJNXZNY2RqOGR5UERRMXV5TEdUdGZvWVIzNWhobmNz?=
 =?utf-8?B?b0lIWDc5SEREeHMyT1NiSEpTRnBzZ1QzczEySEMwVlJTWE9jUjg0TDJFQUlH?=
 =?utf-8?B?Nkk1S1JoZ2JIV1JtZ1lXMlJLUEQvUWR6QnlkckxGbWtOSjArRjJoekFCdTJw?=
 =?utf-8?B?bGlDZ1pCakYwRCtVcGRHU09HOENFT0UrbVJEYXZnR1hSZG9GSGZTN2pzUytF?=
 =?utf-8?B?bnBaTTlhenNvSjQvVkpjQzJWYjNmMTduVTdlTUk4WW5jY2ppdmRhTm16SlZT?=
 =?utf-8?B?Z1VnaUtjUGFCL0tKbnhkMnhvTE9VcndzSEZ1L1lIajNzNHp1TkNYUzlOODFV?=
 =?utf-8?B?K0FwSnRTaXVZcC91Mlp5VzhBTVZCN0o1bHNCb1J0cHBrTzNaWUdoajlNZ1Q0?=
 =?utf-8?B?cnU0ZWFoY3NocElyclFLbHFTT1o3TmhNY3hiQVluZlhCY01pYy9XQ25XeWk0?=
 =?utf-8?B?c3UzYnBiR1k0NHI0c013Ty82NXhBOEhPRzllanN6UW0zUHRFQ3M4K2NCREsr?=
 =?utf-8?B?U3ZQdkY4cVBUVXFMbWUrTjZoNnpSQVBHU3NZbmpUclRQc3JDQnFIZEFURXhi?=
 =?utf-8?B?Z0dlMllXZjBNTXBvUVRaQW0wRVpweDNUWkZRbjQ5eitVSENFR3dqQk54dzJ6?=
 =?utf-8?B?RnlkdGhxQ0JzZ3NxK3puMlM1UldDT2hWL0lYUWtRNUdtYjBuejVEaEw4NVhu?=
 =?utf-8?B?RGlkaWFFZzZ6SVNZd0EyemRnVHFRQlUwUllUbjNma01GVE9td0N0ZzVROWgv?=
 =?utf-8?B?SzhVVWpKOThkSjByVUNYWWxzd0s4SVd4NXAyTmtwbUNpSVdxUXRDUktqK3A4?=
 =?utf-8?B?VEIyLzdjbG5aNThjeWYxNU1SRmdpWUJNWitndDV4YVBVQ2RzSnltS1N3Mm5M?=
 =?utf-8?B?dXNNQlNiYktndTlPVUZ6ZzlXUmNKVGRaZk5ndE9MVmM3bkZMVWc3dmw5S0wr?=
 =?utf-8?B?SWc4dXF3NGVqckNHSU9sTE1KQ0IwRnhOSjlmbkJCTzNRQ3hNRFlNUnRRY1pJ?=
 =?utf-8?B?dEVnckRlMEJFbUpwMTVRanE3SlkrS0NBbzNFMHNheUM5YS95NGY2U3l2ckFR?=
 =?utf-8?B?TDRhL0FWOWJUd2NZOWlkTy9vMUc0Y0JPOHA5a1YvRGZIb0lWY1lkcFZFSFdO?=
 =?utf-8?B?WG1LVUNsbjZyQ0dvYjYzUE9lVWc3Tm5KNHdLR1dRZWh6NDZ2TjVTb2xubjlI?=
 =?utf-8?B?OEkvbTBwSUczNjl4MlhNV2cvYUhVSzlmWTVlYVNQcEwyclRBL2pmWUpTMWR4?=
 =?utf-8?B?YUI3akxNLzYvck5NaTFLb3hNcjgybStyNWV2Z0dzWUs4VjMrVmo0akhaWUw1?=
 =?utf-8?B?bHlIRlg2R3hCdDQvQVBsNFhwNE8xd0pnK0lkVlJuS0VmeW54SzVqWEpGRmNJ?=
 =?utf-8?B?TDgvYUFULyt0dGN3ZndsZSsyLzJaeGxWaGJMMUVYYXhRbWpDYnArYzQ2SEpo?=
 =?utf-8?B?S1BxYTVhTmRXcHhGN240VWVYcEFHQUZldi9xeGRNMmNEckJPVjl4QTF3WkJR?=
 =?utf-8?B?cXJXUE5FWHF2R3AvaTJ4MFh0RkFsbWhqZDhXYy9MaDlVSmFTVE5PUkRPZG9n?=
 =?utf-8?B?K0RlQkovVU51QklxZGQwS2F0b1R6MWVZN3drdlMwT2pyR21ucWUxZGlGSi9j?=
 =?utf-8?B?QUNYemtKaDBQMzVvemxYV1hwSmdwMlZjb3JERm5XTjM5VzZRWnVyTElNRysx?=
 =?utf-8?B?eEtIU1pzdDZ5ZTYvYnZwNnFOV05zaDdWTE9zcGV5OWpkRXl0NlBOQXlzWm5R?=
 =?utf-8?B?NUVYSitwNkhVOU1pZ1V3cnA4S2k5SDQxbFhhS25nVHVhbHl2NVhUdGxVby92?=
 =?utf-8?B?b3RvU3dCN0szaU03MzNIZ0VIVHh3QUpXYm9yTThvcXJrUWFwSitxRVByS29y?=
 =?utf-8?B?OHhGTmMzZTc0TmRtRDgvSWFpODVucGpFVDVMSFdlOWpvVXo2T0hUczBFdDkv?=
 =?utf-8?B?MHJ3cklXU2ZzcGZEdXB1UFBTZ2NPNStzM1doMDhoSVgzR2I1b0trTno0MFdO?=
 =?utf-8?B?b0t6M0tDMXp6ZndTYyttc0thRXlNeTkyakx6a1BRMXluaCtmY2N4eFJ4NlZ4?=
 =?utf-8?Q?4mVpTJ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGdLQjVUVmZobWhyZXE1VWl4eDZLZytRSEFHMm4wZnpBemFBUDgyNHBBNjRn?=
 =?utf-8?B?R25rWTVEN3JaQzVhaFZ5ZU44VkpRcnUzS25KcThrMFhHNm10U1V2dk5Hdzha?=
 =?utf-8?B?MThJQitYUEIvQlN2T0xZSncwZ2ozWEMyMkcrczdpL0R4aTQ1Ym1Hb1dLZ3hs?=
 =?utf-8?B?NXZOTHpCZ3ZCNlN5Rk1YR1F0ZzNnTE9HN2FLeTg5elR6cXA2VHNEU1VsNDlF?=
 =?utf-8?B?WkdBSStDR0dvZ28xZlZ4ZTVVMm51MkdkVG1WSE9BRUNYRE91elV1M09UQjky?=
 =?utf-8?B?ck0zd0F4ZGFQb3pkWVljVmp5WUtxRW5JRlpZWHUzdVVZVzE2ZUw4L05TMTZa?=
 =?utf-8?B?WnQ0M09CSi8vZ2Z1Z3JYKzZXc25oTXhwb0FOOTNMZkZXbDRCaDVWa1hxRFhZ?=
 =?utf-8?B?a2NzZ0xNaEJVd0hHQ3ZlVkhuY21MVEUyMkF5VFdHOE9ZN3I5UXJEWGxmUlRC?=
 =?utf-8?B?ckVmYmtON0dyazFaKzg5NVM2R0FMaUFmaU10STh6cmMwMEtOMytWMkVucXp2?=
 =?utf-8?B?aFlUT0xZWHdjZEYxY1hqYmF6eFM4MWMrTkh5TDgxWXpGQTFqaWJ4clBNT0pl?=
 =?utf-8?B?UU1lVVlBZ0ZBL1lDeWpKTHNQYkVrSkVTVVZOTkEzRnlDUk9JK2diMXdWYmRk?=
 =?utf-8?B?UG84UzRjRHlHQ1BXcHZFNmRHMjN3N2c0VTNoa29GUjNKbWFxc0hNY3FlZFRs?=
 =?utf-8?B?NE54clc4K25BUmZrV095bkc0eENTQzF3c2VpaDljZTdIRmtzbWM4WklQeEp3?=
 =?utf-8?B?S3p6dDBFQndzV1lVK3ZRNXc1Qk1hZTdHdUhwcTlxSlZ3L0MraXJTcW11SGp5?=
 =?utf-8?B?TnZWam1KelVKZnFsTjdpUE5NdzhGUjZmNXVFK2d2V1FRSk1JMDg0d3NkQTlk?=
 =?utf-8?B?T01raVYxVG9wY09aSTZNSUxUbGZuUEtVWnRoaWdwN0pFSzFJdHpSTkQ4V2dw?=
 =?utf-8?B?THl4SnQzRmt3T2EydUx1anY5RmRFSS9QV2I5SGpxL2FOcUtTbWZQWXJGMksv?=
 =?utf-8?B?MXVYSmVTTStadkVieS9ITU1yTGxYNnBzcEdNcHFlaEJBZ3pSR28zb3F1MUM0?=
 =?utf-8?B?RkpmL2JwaTZLd2ZkOUVQS2NNYlR6NE54MmZadlpWVHBnWEdiUjZxYjNNOWlv?=
 =?utf-8?B?SEwvUVhFKzhQSG1qTjRORTF2aC9YYzJZZzFnR1RzbUdrRDZBaDgvNWdXWFha?=
 =?utf-8?B?RnZob1U1anN5YUIvLzZHUElMTnNwNlJqUXd6NWVldTUvYndueFBFc052QWJG?=
 =?utf-8?B?aENneUVrN1UzV1pwOGxPendlVlFRaE9JTFEwZTFhYWc2L2UxQWcvODlzYXRB?=
 =?utf-8?B?Skx2a3UxSnNab29sZ1g5ZTlIMElia0NkVml1ek00bUY1L2dqeXp0OWJIbWor?=
 =?utf-8?B?d2YreCs4RVRkaFNYcE12TFhhRDhLMHhsNExHMDYralVjcEllcEE3YUJuOWVl?=
 =?utf-8?B?MzZzdkhuYmhoZWxqbERwS2dPWjh3RkFFcDlWNnRPRHJkOXcwelA3ZDkyMkIx?=
 =?utf-8?B?bzQ1UmVIV3VLU1I3SWVWT0tBOFAvaGhpQ1VUVFlKb0hLQ1B1Y3hNUzErT05L?=
 =?utf-8?B?ZUptYzhUVGVmN3hucnpDaERTNWorOHdQYXUveUZpdWtBS3dCajhrMCtaVDY3?=
 =?utf-8?B?dCtNMjVzRjZOeGNhQSt4ZkJPbnAveEZGSnJLZi9WdXZySnFoV3BwOXp0NmZV?=
 =?utf-8?B?S2hyMnU0ZUFnbE9HK1Uvdy9vUjhkZSszby9QaGlTakRnTkZzczcvamtuc0tX?=
 =?utf-8?B?d3VUZ016THhrNFJLUXBWRUlBQ1lOUjBLdCtOU1FBb0NXOWN0eTMzMXRqUFY1?=
 =?utf-8?B?Q042dGlyZUhsQmoyYzJvQTNWZFYzaHg0cHM2NG13RVNLbmdVWFZwVmpYSTg1?=
 =?utf-8?B?Zy84Z0E2Q3kybThZS2ozeW9aYldNT0lxYjhIOU1kNFVKZVpBaDhvT29vbEFK?=
 =?utf-8?B?TkVTRWZmaTZrc24yMEpKZTNvYnNwdWZSa2tuYnRTTXFpMWovblNnOXZjOFNO?=
 =?utf-8?B?cEVFNVhuSWUvaXpVVXJlUVBqQXFDZWpRaDFJK1QzUmZwNUdYakg4a3lidDVG?=
 =?utf-8?B?cHF4bk9UeEltbllsS2pRWDVOZ0JWRDNPTGQ5eTJmMEh1YkJTYit1bVpqNzFL?=
 =?utf-8?B?UGRud1NYTkxkTFp0SXlKN0VNV0tuSG5GTWRuVjdZa0J5K0MyVThGcllpb24y?=
 =?utf-8?B?aWpiMXpOOE1BcVB4amlOeUFJcGNJYTBGaHllcEl6ZDh4eWtDZFlvWjdMd2Ex?=
 =?utf-8?B?bW91MkJkeWUxL1pqcEQwaS9oTDRWS1krSDhZREtBWmUxaThTQVJ6UzRjc3Jh?=
 =?utf-8?B?d2FaSVN1NjlLeGEzYzFVbGJ2c3ZFYjJHZFVzOGd2azA0d2Q4Q1F3Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F2E37C0D5F66E47BD0CA73ACBFBDA4E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f3b5ff-b881-4d30-5d06-08de51c26645
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2026 10:07:31.4130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8K2ud48RMxDbE7sq9evrKZvsixC4AeY75fLcw+TNEZDBI/ueQAGGsMpTKytwaNTo9eSYjDDX09lewRmlzw6Dgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7117
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI2LTAxLTA1IGF0IDA2OjM2ICswMDAwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gTW92ZSB0aGUgUE1MIHBhZ2UgcG9pbnRlciBmcm9tIFZNWC1zcGVjaWZpYyB2Y3B1X3Zt
eCBzdHJ1Y3R1cmUgdG8gdGhlDQo+IGNvbW1vbiBrdm1fdmNwdV9hcmNoIHN0cnVjdHVyZSB0byBl
bmFibGUgc2hhcmluZyBiZXR3ZWVuIFZNWCBhbmQgU1ZNDQo+IGltcGxlbWVudGF0aW9ucy4gT25s
eSB0aGUgcGFnZSBwb2ludGVyIGlzIG1vdmVkIHRvIHg4NiBjb21tb24gY29kZSB3aGlsZQ0KPiBr
ZWVwaW5nIGFsbG9jYXRpb24gbG9naWMgdmVuZG9yLXNwZWNpZmljLCBzaW5jZSBBTUQgcmVxdWly
ZXMNCj4gc25wX3NhZmVfYWxsb2NfcGFnZSgpIGZvciBQTUwgYnVmZmVyIGFsbG9jYXRpb24uDQo+
IA0KPiBVcGRhdGUgYWxsIFZNWCByZWZlcmVuY2VzIGFjY29yZGluZ2x5LCBhbmQgc2ltcGxpZnkg
dGhlDQo+IGt2bV9mbHVzaF9wbWxfYnVmZmVyKCkgaW50ZXJmYWNlIGJ5IHJlbW92aW5nIHRoZSBw
YWdlIHBhcmFtZXRlciBzaW5jZSBpdA0KPiBjYW4gbm93IGFjY2VzcyB0aGUgcGFnZSBkaXJlY3Rs
eSBmcm9tIHRoZSB2Y3B1IHN0cnVjdHVyZS4NCj4gDQo+IE5vIGZ1bmN0aW9uYWwgY2hhbmdlLCBy
ZXN0cnVjdHVyaW5nIHRvIHByZXBhcmUgZm9yIFNWTSBQTUwgc3VwcG9ydC4NCj4gDQo+IFN1Z2dl
c3RlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5
OiBOaWt1bmogQSBEYWRoYW5pYSA8bmlrdW5qQGFtZC5jb20+DQo+IA0KDQpSZXZpZXdlZC1ieTog
S2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

