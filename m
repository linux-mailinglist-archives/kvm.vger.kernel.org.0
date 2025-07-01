Return-Path: <kvm+bounces-51205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C36C6AEFF34
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 18:14:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7637A3AE98A
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 16:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1785327AC2A;
	Tue,  1 Jul 2025 16:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BCl7BWGe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DD626AD9;
	Tue,  1 Jul 2025 16:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751386460; cv=fail; b=IfVJlbcSV26lBz5/rdJuD89wRdEdSEBqk4mrhGRMBRt8PW4TAygPm2kaWFtvOSjS2Tcte5P5GsQZSmYoAoshcUBcEwnXXczVeldjjKEIx+zYgi1ZkUUHl6AzuTJsKF7h6oB0JGPz4KydJg/4mC1b3jCYKMpZoKEGApXBzLySTOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751386460; c=relaxed/simple;
	bh=TL8lSd6wl4GAle+zF0ux3PXYnK49imRlkE/DHA4Dep4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZmBPuT2x0+hpWTGn8btpFT13tvUZg8iQWdFrFZSFDQiNQhEHOzUEkUlxep4bfJH07/7byaxGwBExvNnJK56J+UKWojABOdMxiFACuMN2azs6pRykiIoyRY2OiFVV+D2o3OXAwej8MA5rjduLevvLHqY/AHzOto6gqhcn7/t54F8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BCl7BWGe; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751386458; x=1782922458;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TL8lSd6wl4GAle+zF0ux3PXYnK49imRlkE/DHA4Dep4=;
  b=BCl7BWGeyzTx6WrpQwa21DwrC2ZHfqsoDu9VbZf9QSSQmtQR2R2aw37X
   geFliYGY63YEZZ3rCjOSZNipRihVhGKpmsL6QG9UnaNWxeo5QaNcyGe8S
   0EFcDb/zNzIAa7gksNtwf5jh+6WZSEBYf8qjZjP6jKZPg6GKOnoC8HUKO
   S/MiGhlgK/LDyyzU4KtgdmovDANSLaDj4GzYzHNW/0row0AbtAttCEQoV
   B6pQ5Qbhw6wBFpBonylw8lX+j9K9BuAiGs4bwAFht5klPRRFbDhcihmSC
   YEMMwSJA6wW8kjcDaNGNh71cvVCVGjtRxRw7RyM+Xi7Pap5aHFYYdZqAH
   g==;
X-CSE-ConnectionGUID: U+OnFguDTxSklqE89UrI7w==
X-CSE-MsgGUID: GI9YQGKWQtaNe0iJ6RniWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="52892550"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="52892550"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 09:14:14 -0700
X-CSE-ConnectionGUID: GlcY8BjOT4W9CefXO/8OMg==
X-CSE-MsgGUID: 5kKmFRlnRyC+6w9J9XNgLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="159327511"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 09:14:13 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 09:14:13 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 09:14:13 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.76)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 09:14:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g/0OgBJeTJCMHEsnLgPk1xB9rHW2JVBSLnv8pET4PXj1L/PGVsJv9FaWqTFdVYztZwyEkfNJjCy3Bv+S7Xu3QNIkUqQyPovqg0M9epEZdaV3oyAmTue93ZU21GmiB3wdbVhi6i4MVyDKO/xW8qmIXWL9sEAhPVJxvrKw1N7RppSWPJmXXCTGRSyBB4o4ASFN4TefL9B0v6Chdjv8CMdJ04mdOBCypOHvnqLo1Z6Ugrra6PW5QurIcMhamBkzshaj8GSUQ9AnkmW2Rta7FJUicFb0RXkVkqTO6QFFe/BLshLyOeyKv0DhKdH972gEDcLiuJ86J135qd/1T0I7m0HpHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TL8lSd6wl4GAle+zF0ux3PXYnK49imRlkE/DHA4Dep4=;
 b=NJ+4OEus/I9X/G3oHmVi8gEnAbpiPy9uCSiKuwZcaqsZa/GVnp3a5kPoc+sFa2q5CkUZOtxW1+yKQySMhVfBz2XkcaYSzGnO2pkKLh1bZUzNM4RuRbQSfMH5OdGULW2esvJmcT1niP0oTolZVXPBHSkZmC1t0dzWRfIGL+AkBbc0GIzwtUk1Ki+nlWlhDiPNF+EwHIUmKEwY+ZE3I+mPhOZ96HFwv5azUzM/1/FiQPAES/7oQDv0B95vOmNeFS5e9MU7FJIaDmgWCXwcWxj+sWy0Ab2mkfvGnRcMcpU7wZ4WgyS2BF1xfSgqCfKb82d3orXd/kamf3yfjReaNv+big==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7042.namprd11.prod.outlook.com (2603:10b6:806:299::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Tue, 1 Jul
 2025 16:13:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.018; Tue, 1 Jul 2025
 16:13:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Peng, Chao P" <chao.p.peng@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Annapurve,
 Vishal" <vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao,
 Jun" <jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAABkngIAACJUAgAGDrACAAALngIABC0kAgAB2RoCAAUnBgIAERXKAgABwaoCAABksgIAAJyQAgAB5m4CAALvngA==
Date: Tue, 1 Jul 2025 16:13:42 +0000
Message-ID: <cd806e9a190c6915cde16a6d411c32df133a265b.camel@intel.com>
References: <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
	 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
	 <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
	 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
	 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
	 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
	 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
	 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
	 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
	 <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
	 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
In-Reply-To: <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7042:EE_
x-ms-office365-filtering-correlation-id: bc4511ca-bd4d-47a1-49aa-08ddb8ba3f44
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZUc3RVRyTGxwRW1MOTYwRXA5c0tWQXpzZXc4Qy80R0FJWjd3cjFlcFc5L1Jp?=
 =?utf-8?B?OVBQR21rQ3pySmlaMkdIdjJaOWRweUhjZU1lcFo3K1RKak1pcWNnZnNrWitt?=
 =?utf-8?B?NktZYWgzK0RBRGczQ25yUWFLeUxNMEova2FUUmVVMkxiYnJ3cmR1U0UwL1RS?=
 =?utf-8?B?MnM1a2FDcGpwL254YUdFSjRGNk5URzkzNmVFR0pNdm9EU0Y2MEhGbUVaQjVn?=
 =?utf-8?B?VnN2S2ZYVDRxVmFaSUtTdFlNcW5STzdncDlsQnE5ZGFLSjFOdWMvZXVpaHBy?=
 =?utf-8?B?cEEyZEdSWmVkdndBb0tJZTJjc1ZINEUrem1iTVh0M0tENmxYeTVaaVBiTUlQ?=
 =?utf-8?B?Q29OeGY4ZmQ3YThwTkhOTTgwby93ajBDVVB5aytwSUtQeTFHekpGRDNwQTRP?=
 =?utf-8?B?c0tmdXNZOFNMOUg1TEROT05CWUtlbFRseXVYT2ZLR2QvbzJNWHNzMGJBenlt?=
 =?utf-8?B?Z0hzR0JsSmtIVlk5RXZ2Tk1QUjlQV282ZHRsZTUrMlQ3RnkvcjI1M2x2MStJ?=
 =?utf-8?B?OEdidHp6QitmZngwempQdEhSRnY3SWVURThadHI4YVV2ck5nQ3p1L3kwZjVS?=
 =?utf-8?B?cktzcEhINlVBeTNHYnE2aUtGUnEvNFV2dEZsY0xvcHA3WXpraW8zVm5uUGg5?=
 =?utf-8?B?OTNKNndaeVVMS3FBK2tVYXBtQWJwZ2JVRnZTYVZPQVlkS00ya1d5YzEzRU44?=
 =?utf-8?B?V0Z3cjlWZk0vNzZ0ZXRWWDZLNUdMdDVkNlRCcDdwTFluQTc5RWdtMCtpL2VN?=
 =?utf-8?B?S2IvRUw3Q094bjBVekdvUUk2eURVMGEremFnbTBQbzdMYWxaeDcxcjR6Z2tZ?=
 =?utf-8?B?ZmUvckdzaUlPVlZsSmFIL3FIYXBRQjRxVlZhUlc5YjhMNG1WM3F4WXZVWUc4?=
 =?utf-8?B?azJkc2tjWGNKQVRtYTRDTnVCUEhaSWh4MEFEUkFabnhzRGhyVVVHa3hSb1lL?=
 =?utf-8?B?Vkk0VHBrWFlvQjljRVcwRGhnbk85U3BHWnExaEcyTnkzVHFqQ29rR1B3UVFz?=
 =?utf-8?B?aWJWYkE4QVRSL0xCbWExK2xsenNLMEN3cHVTRHhYbTNnVSt0bUJWNjFhNnZO?=
 =?utf-8?B?N0lNS0pySlVqUFlhSjA4OE5KcWYxcjAzUWJBcVI5OFQ3UCttS09PNWdIOFBw?=
 =?utf-8?B?ZFBBcmZ1aTcvNktuMk1BZ3IxaHprUUpiR29wSG9XQXFRait0ekZVWG5YMExm?=
 =?utf-8?B?MGhiMmt5OGJDY2JuRXJXRU5PcDloQkVWcUtCSUl2NTlJU0NLTWw4aDdLVmVa?=
 =?utf-8?B?dWNCTEwxQnNab0I4Z2w4NTRUK1dxbGpMeHRFSm0zY0JtY1p3eDZ2NXdVT2Jp?=
 =?utf-8?B?KzhkNEdtWC9weWZ3eHpESENyeGVPRmxGSW8wa1kzNnpaSE82dEtPdkQzYUJ1?=
 =?utf-8?B?Rm82dFRob3M5MUhHajErb05IQyswTjhDMGhSNnc5bG1KZi9iWXZ4NDNFdHl5?=
 =?utf-8?B?MjhuTFZmZ2ZsOE1xYktvRmFBelZhRUtaekNsL0FoSndCVjIvTFdTbXgyWkFM?=
 =?utf-8?B?cU92elRHSmwrdlJCVDA0R2krdkg3Q2Q3YTBVdnpHMzBPekNmVnNhdmdzSlFr?=
 =?utf-8?B?Ym1UOXk1LzdhTlV2Qm9XNldNbWJ4WExDK1kzYU5XWVNoKzdyN1FsQTJqOEht?=
 =?utf-8?B?bi9Gd0lUNW1JUFRUY0tCRlBTT3pJOExaTVd1WkZHSnNVbHhRVnRuOVB2cnVa?=
 =?utf-8?B?b0w2OWRVK042WlV6WXl0MWxZZTdMc2N1RDkyS2N0T3lTNmZBcjhTMkdZOUxE?=
 =?utf-8?B?VTgyOGRzMXltTUdqRmc5cmV2c3FtNml6N3REeGM4NnFsWjErWHpnSG1jbGlY?=
 =?utf-8?B?Uy81N1doUUc3ekRhMkxYUkNLOXk4bDdpMG9WN3RmbmxROElYQXg0QmdlS1lQ?=
 =?utf-8?B?RVQ5R0pIRGtmQzhOWjloSjJIZE52ckpMTlhkWlduN3F0MGIwRDM5RlJwS3pq?=
 =?utf-8?B?WTMxZGlxMTA4OHJSKzBLVjZXdWxQOThKZE5uc1JiVXAyZXBoVXFtV1M5M2lC?=
 =?utf-8?Q?06EDH3t7SidcCFRJ3EY2eJucGqFag4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDdEYm52ZFVVZ1NrYSt2ZzByZEk1bjArM2JzRVBrdEZiMWpaejBDdURnVHVi?=
 =?utf-8?B?ZzVlYkFIaCtzZzRJazBpM0plSnEycG1sYitvT2QyQzBZR2pxMFZuUW1VbVlT?=
 =?utf-8?B?R3ZweW5ZY0F3ZGR5R212Q254ZVR0YVpkQ29iNVJmL0N2aVlKVTQ0YnRsS05U?=
 =?utf-8?B?SU1FTGplcXl4eTZmMkx2anRmSDM3aWJRcDRGbW9lcUZiYlkzeEtVYXFLbHYx?=
 =?utf-8?B?YnI0c09ZTm9ySWNHTHllTmVzemJqSXRGTmo4eDBJRHBaS3VUTkI3amxNTXIv?=
 =?utf-8?B?SzVPQ1dtYTlmdHFZZ0JEK0lwVWJaTDkrVEZrVUxFVTdIYnZlVUxoSVJiQndE?=
 =?utf-8?B?eEdXbmU4b1FKVWUyMGxwa2QzYzFuZ2k5K05VOVZjTkF0SW1Gc1E3SFBtSmZ3?=
 =?utf-8?B?cVpyM242Z0lsNWJ0bE5GclpNQWtZZk5mZGM1cm5CbmhUdHRXR3Zzc1hEcWZW?=
 =?utf-8?B?M1oyaGhDOFdXWitqaXVDQzNHb2RKLy9JNGYyKzRGK1lxTlJUQ1ZIRm1ybkp0?=
 =?utf-8?B?NzJqZmVkQWxWUXpEQVMrU0ZET0xEbXN4YXhqeUJnQ09VcXNBWkhwazFYckRH?=
 =?utf-8?B?QXU2Ui90N1VrL1BtaWcwcnVkTVA2WmxabVg2NmNnWExYSVd0NzE2dnFheVVH?=
 =?utf-8?B?MzdlNnJOSXg0dFJoNzh2dE9uSXZteDFRcEFMMzJSSXo1VHNCdDNkOUhnR0VD?=
 =?utf-8?B?TDR5WWMzZE9qQW5hdDRMNWV5emljVHJkaU9Ccnk3VzljUXJvNTFUTVA3Y1I2?=
 =?utf-8?B?aDBkaFVPR3JwYWZqdVBrYnhsd1ZnNFNmTk1wZHBzTU12VmtaUklvdkhjMXVh?=
 =?utf-8?B?VmMrd3FHUXNhUC9tSEFlbFUzV0lUUktYZGF1K05yRzBEK2J0QXJBL1FIbVJh?=
 =?utf-8?B?T2owM2V3KzdTLzhXV3ZlUkpVM1QyTGxEMVN1MUxpTUJqZnJyYlJTT29EMXdF?=
 =?utf-8?B?M1g3UnZldzhSNTFFMjJ2aXk5NGl4aWtuWGJEN2F1L3ZtV3p6RGlSZ08xeDRR?=
 =?utf-8?B?VXczNzE2L3A1TldaNVQ5dm9FOW1WaW01SWVFc1FxQnpSRFFjbzBSNGVFSXBo?=
 =?utf-8?B?NTlhYVR2VFFOUTUveis0TlN4WmhNVkg0YzRlTWVjRUpxN2xnMUozQzhsMzcw?=
 =?utf-8?B?bTZQZGcxbzZPbFJRU2wvK1BKam9DM05JbFdGZEUvOWVTQnM3bGFoVEU2N0ZH?=
 =?utf-8?B?TEhWZlRqdE9vWjZGQzNMd1BadlRLclVFREdUWWlacERDem93bDNQdkwwWCtF?=
 =?utf-8?B?VTRtVjhYWmtMOUdONWhDOVhxUGowTlJ4K1pBWWZJdk1sT0tRTi9zdGd6Y3Zp?=
 =?utf-8?B?S1RDcUpQL1pFRktNUDdRdXl1amk0VmRRS3dPYzBaZ0VJVGsxNTVic3F1ZWRY?=
 =?utf-8?B?Qnk0WmZTaXVLbndQd1RHejloYkpCVnlRKzB2cVN6ekxabVBOS0lsV0h2U0lO?=
 =?utf-8?B?NjVUYU1VYjNsMUwwVXN4VG1FMHdBYW8zeit5RFdia3ZDaGprd2RBT2ZiWGQ4?=
 =?utf-8?B?QlNPbE91Q1VrT3R5RURlRWo2Tlg5YkVMbi9ydHpGaWMwUmtuT3RDUTlJaXVX?=
 =?utf-8?B?c1FFbGJtRzNiU2Rab0x2Mk0zU0RuWVNaZWxLOXJBN2QzRzhMSW5LbmdSdkdY?=
 =?utf-8?B?R2kweGY1ajdkSndpZ0V6aVBjSzF4ZVM0YVBReUVHR2V2Szg5dTlEMTFaczFY?=
 =?utf-8?B?UUkxNmp3Qm9DdlBCTUpIeGFzSnMyTGxyUU1QMkprRzZmcWoraGdUY01LSVZC?=
 =?utf-8?B?aVRMTThPVVNjNmdYejg3ZlpkL3dyVVFqVFdlTUM2YVM5MjV4OU1vcW53cHRh?=
 =?utf-8?B?QWdweDFQdDVtLzlkWUI3N01lTG5yRjlnMlpzY3hPYUEwMGxqd0loVWRTU1BP?=
 =?utf-8?B?NEd5a2wrN2ZxRldSbHg0a1BEcXlVTEZLUGQ0d2VReTM1elpTQ3RUSURnd2dy?=
 =?utf-8?B?VXJ1YVRmakQ2TGxkWGpHWUp5RzRKOS9OWW8zbHQyQmZlQURQNTYxSGZwYno3?=
 =?utf-8?B?dmNtMUtJZm1zYXpjbC9TTGlyNzVxdysvWTdaTlB1K044Mzh5d1BUT1pCSSsx?=
 =?utf-8?B?VTM3WjZXSWZQSHIyeS9EbCsrVzM2Vm5PZGtFbHpySmptVjAySDdJMU1jeHpy?=
 =?utf-8?B?QmdVQzczVGZXcE9CTHU1NlFVbmlRbHFCNTV3T2hVYnc0RHBsMjlnYTRnZi96?=
 =?utf-8?B?N0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E83E767BD91E094D9B7182FDA7366F6D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc4511ca-bd4d-47a1-49aa-08ddb8ba3f44
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2025 16:13:42.1284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z6dXi6Z2dFWqGOcR1ks0tbXECdY+AqCdfjtaL/jP2bcY7YCpvOi2/BoyDR44dGfD8JGb4eMl/OJpYHU94lik96sFOLDDxIjVuGmUgJ5cHOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7042
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTAxIGF0IDEzOjAxICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBN
YXliZSBZYW4gY2FuIGNsYXJpZnkgaGVyZS4gSSB0aG91Z2h0IHRoZSBIV3BvaXNvbiBzY2VuYXJp
byB3YXMgYWJvdXQgVERYDQo+ID4gbW9kdWxlDQo+IE15IHRoaW5raW5nIGlzIHRvIHNldCBIV1Bv
aXNvbiB0byBwcml2YXRlIHBhZ2VzIHdoZW5ldmVyIEtWTV9CVUdfT04oKSB3YXMgaGl0DQo+IGlu
DQo+IFREWC4gaS5lLiwgd2hlbiB0aGUgcGFnZSBpcyBzdGlsbCBtYXBwZWQgaW4gUy1FUFQgYnV0
IHRoZSBURCBpcyBidWdnZWQgb24gYW5kDQo+IGFib3V0IHRvIHRlYXIgZG93bi4NCj4gDQo+IFNv
LCBpdCBjb3VsZCBiZSBkdWUgdG8gS1ZNIG9yIFREWCBtb2R1bGUgYnVncywgd2hpY2ggcmV0cmll
cyBjYW4ndCBoZWxwLg0KDQpXZSB3ZXJlIGdvaW5nIHRvIGNhbGwgYmFjayBpbnRvIGd1ZXN0bWVt
ZmQgZm9yIHRoaXMsIHJpZ2h0PyBOb3Qgc2V0IGl0IGluc2lkZQ0KS1ZNIGNvZGUuDQoNCldoYXQg
YWJvdXQgYSBrdm1fZ21lbV9idWdneV9jbGVhbnVwKCkgaW5zdGVhZCBvZiB0aGUgc3lzdGVtIHdp
ZGUgb25lLiBLVk0gY2FsbHMNCml0IGFuZCB0aGVuIHByb2NlZWRzIHRvIGJ1ZyB0aGUgVEQgb25s
eSBmcm9tIHRoZSBLVk0gc2lkZS4gSXQncyBub3QgYXMgc2FmZSBmb3INCnRoZSBzeXN0ZW0sIGJl
Y2F1c2Ugd2hvIGtub3dzIHdoYXQgYSBidWdneSBURFggbW9kdWxlIGNvdWxkIGRvLiBCdXQgVERY
IG1vZHVsZQ0KY291bGQgYWxzbyBiZSBidWdneSB3aXRob3V0IHRoZSBrZXJuZWwgY2F0Y2hpbmcg
d2luZCBvZiBpdC4NCg0KSGF2aW5nIGEgc2luZ2xlIGNhbGxiYWNrIHRvIGJhc2ljYWxseSBidWcg
dGhlIGZkIHdvdWxkIHNvbHZlIHRoZSBhdG9taWMgY29udGV4dA0KaXNzdWUuIFRoZW4gZ3Vlc3Rt
ZW1mZCBjb3VsZCBkdW1wIHRoZSBlbnRpcmUgZmQgaW50byBtZW1vcnlfZmFpbHVyZSgpIGluc3Rl
YWQgb2YNCnJldHVybmluZyB0aGUgcGFnZXMuIEFuZCBkZXZlbG9wZXJzIGNvdWxkIHJlc3BvbmQg
YnkgZml4aW5nIHRoZSBidWcuDQoNCklNTyBtYWludGFpbmFiaWxpdHkgbmVlZHMgdG8gYmUgYmFs
YW5jZWQgd2l0aCBlZmZvcnRzIHRvIG1pbmltaXplIHRoZSBmYWxsb3V0DQpmcm9tIGJ1Z3MuIElu
IHRoZSBlbmQgYSBzeXN0ZW0gdGhhdCBpcyB0b28gY29tcGxleCBpcyBnb2luZyB0byBoYXZlIG1v
cmUgYnVncw0KYW55d2F5Lg0KDQo+IA0KPiA+IGJ1Z3MuIE5vdCBURFggYnVzeSBlcnJvcnMsIGRl
bW90ZSBmYWlsdXJlcywgZXRjLiBJZiB0aGVyZSBhcmUgIm5vcm1hbCINCj4gPiBmYWlsdXJlcywN
Cj4gPiBsaWtlIHRoZSBvbmVzIHRoYXQgY2FuIGJlIGZpeGVkIHdpdGggcmV0cmllcywgdGhlbiBJ
IHRoaW5rIEhXUG9pc29uIGlzIG5vdCBhDQo+ID4gZ29vZCBvcHRpb24gdGhvdWdoLg0KPiA+IA0K
PiA+ID4gwqAgdGhlcmUgaXMgYSB3YXkgdG8gbWFrZSAxMDAlDQo+ID4gPiBzdXJlIGFsbCBtZW1v
cnkgYmVjb21lcyByZS11c2FibGUgYnkgdGhlIHJlc3Qgb2YgdGhlIGhvc3QsIHVzaW5nDQo+ID4g
PiB0ZHhfYnVnZ3lfc2h1dGRvd24oKSwgd2JpbnZkLCBldGM/DQo+IA0KPiBOb3Qgc3VyZSBhYm91
dCB0aGlzIGFwcHJvYWNoLiBXaGVuIFREWCBtb2R1bGUgaXMgYnVnZ3kgYW5kIHRoZSBwYWdlIGlz
IHN0aWxsDQo+IGFjY2Vzc2libGUgdG8gZ3Vlc3QgYXMgcHJpdmF0ZSBwYWdlcywgZXZlbiB3aXRo
IG5vLW1vcmUgU0VBTUNBTExzIGZsYWcsIGlzIGl0DQo+IHNhZmUgZW5vdWdoIGZvciBndWVzdF9t
ZW1mZC9odWdldGxiIHRvIHJlLWFzc2lnbiB0aGUgcGFnZSB0byBhbGxvdw0KPiBzaW11bHRhbmVv
dXMNCj4gYWNjZXNzIGluIHNoYXJlZCBtZW1vcnkgd2l0aCBwb3RlbnRpYWwgcHJpdmF0ZSBhY2Nl
c3MgZnJvbSBURCBvciBURFggbW9kdWxlPw0KDQpXaXRoIHRoZSBubyBtb3JlIHNlYW1jYWxsJ3Mg
YXBwcm9hY2ggaXQgc2hvdWxkIGJlIHNhZmUgKGZvciB0aGUgc3lzdGVtKS4gVGhpcyBpcw0KZXNz
ZW50aWFsbHkgd2hhdCB3ZSBhcmUgZG9pbmcgZm9yIGtleGVjLg0K

