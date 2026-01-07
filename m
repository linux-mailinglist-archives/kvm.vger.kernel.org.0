Return-Path: <kvm+bounces-67257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD681CFFDEA
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 20:56:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB30A31BA8F3
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 19:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5A1326947;
	Wed,  7 Jan 2026 19:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TOcqQkDW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CC43A0B08;
	Wed,  7 Jan 2026 19:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767813737; cv=fail; b=WOf5sMyKuXb/ZbQ0CrSqJihwDkCqUOQpw1uQWy3BFz/MQwPhCANonODehlkfy3KRoizIP8okNr/dDVpBw51zJrPdB0ih+A/SKuixfDeAHbZEZVbqOR/usYwyn3hufyWMzxEO7lNnXXblVsTinFo0jwizzUiTfgdT1n+zQYy6dYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767813737; c=relaxed/simple;
	bh=+7qBhPt10viv4+l3r4K5HzOd0lbUBiRfhndyO25N20I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eIVS/OjOKqjRyBnrgDklKcGQ8vRVYHiIomX9iSVp832P/BRyvBjQeX1cFRJVt3lBxW4JKqHAFj0gt8p26cbB+o5HOueJ07BFUiDvIGNCsfh4mjGnFr0ztNja2lgJ40rSBoKWw/89qdjo6bLqgGcLNYfxFKdtYQI7zc3tqZRgGEI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TOcqQkDW; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767813736; x=1799349736;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+7qBhPt10viv4+l3r4K5HzOd0lbUBiRfhndyO25N20I=;
  b=TOcqQkDWR+7DfvaRt4KRokWlsIOXwD2uQXpUwiW39umNAJTtKoXPXA8e
   w7tqj5W8sFK/JfYNBLHNetQpH2TcLJN7zoZwfq+ODJaDMszPxdVRZMjFh
   YfuBxJg+MgPqcWLOJAuBpxeOZ8blyfEdzWbzGtX9vs3U7dPQAJuDCx8hL
   bK1JMcw/9JMqPDzDTGPHW5brId8fQniwAC+XS7ehW1bSehZ2OJ3a39P3a
   oOmKBOLPaJgosj/MHWOL1A3ic5bcdRKLIbzRJiLt6dVMtAnHfnp8DG6P1
   ZCg7qrEUukdunE7q36kKhrBi/cu6nsvONGbEaY04qZMf2kVhZ7+ZdK3Ct
   Q==;
X-CSE-ConnectionGUID: hhIVaWQtQcKrAmK2xvHucg==
X-CSE-MsgGUID: 3CmehKvFQ4WEA2NtAFqdCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="69090122"
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="69090122"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 11:22:15 -0800
X-CSE-ConnectionGUID: aDmVs4h4TwiG6+EWN8KXWw==
X-CSE-MsgGUID: oTbXrTp4QleAA2OpBYtxmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="207536867"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 11:22:15 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 11:22:14 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 11:22:14 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.27) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 11:22:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t7F6BoBdY1M6Tzjp3HXAaC25+EDzPxlEzLfu8nwOouJ8qtNRnfMCushzs5IUd7KVjfzrW5recYxj9BJvezri/hD1LxouNCfdc0LZnm1zu1Jv9NqmFNYt7yhzid2yhCckrAyfHYYy/gqhA+WVlsYl/JvnxwsBSjwijexaJfm05GNGAv3/f26e/6MFzhnap/4xoea4k8msSNoZzxWJcKcR1up0iBdwQ5uTlfkXN04wg0170cX7HGbcY5iEwru3KuRdahrcsQVfIsfRcD2vmkfUZfrtDZXl9KdOfMUhse7Etviy64YqZmWm7StAI/pvfZ2g3geCF3ef0ZLfSdqW149IZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+7qBhPt10viv4+l3r4K5HzOd0lbUBiRfhndyO25N20I=;
 b=Us6hgqCFxQT3LuVRRjcxbURAGW7NkMy0nSaS3Zp+ZY2HCkzR/oBz7yGlv1ede8XsX+peB6S4Wpm5uC9F/rXwAjSb0oyI8r7SXqM+FwSCaYGGyDVp8cGaguwGYTJuIgOniQR5sJidDRf3/WddCj3fvNZRpDr8HiX7cGfyWA1SqpTcRxDeOocfV7r8QrABUU1ZB/JU/qOaaRqi5xrlHsYdp08aoPwhfkFcrYz6MtiwIXDKjJqGGiykwD9DidSIbLZG67Ei3Y6XFvfI/YNbEcs1F/V5USz18Q0NRJvnk8xx11ez71w41trOhcE7dKAHK3FNaabttH3ac6iAZLFTcADZcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB8027.namprd11.prod.outlook.com (2603:10b6:806:2de::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 19:22:04 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 19:22:02 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Du, Fan" <fan.du@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "david@kernel.org"
	<david@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kas@kernel.org" <kas@kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "jgross@suse.com" <jgross@suse.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Thread-Topic: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Thread-Index: AQHcfvXkGzmJNKWdxk6kpDo1zXW6dbVFaxWAgAA9QgCAAANhgIAABy0AgAAbs4CAAUlIgA==
Date: Wed, 7 Jan 2026 19:22:02 +0000
Message-ID: <741984276082955190f9bf9cedc244cb3cab1556.camel@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
	 <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
	 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
	 <aV2A39fXgzuM4Toa@google.com>
	 <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
	 <aV2eIalRLSEGozY0@google.com>
In-Reply-To: <aV2eIalRLSEGozY0@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB8027:EE_
x-ms-office365-filtering-correlation-id: d7b93dbc-d65f-475c-53cf-08de4e22097f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?MGV4K1J5c1Ewalo4UEpHdlB1T1FTRDFFRnM1dng2V1NlR0ppMGxnNFExRk84?=
 =?utf-8?B?Vndia3JHZGs0N0lnMTBleFNqdHR2eWFiM1BYeTZ5cFJESElvVUoxOWNXNCtY?=
 =?utf-8?B?V3ZmV2F2R2ZzNUQ5aVB4Vy9oZHJxeDNOZE4zV1pub0h3Zlh6UWVnamYrV0sz?=
 =?utf-8?B?WUpRMTc1b3V0QjhFOUt3NmQzRXpqbEpJL0x6YmkyKzBIelBxdkxYTFIzQjVV?=
 =?utf-8?B?RFVHaXgrZVFrRlZJOTcrN1h4Z3hGeWczdzZoMHpRNGp4alMwbXZ4em9HR2Nh?=
 =?utf-8?B?Qnh6eGk3UGYyWkZzR28wK29DdVRzb1gydDdxMy9hRWVMS2pwdGw3T29Lb2l1?=
 =?utf-8?B?a0QvTDVraUZ5eERwbVJYZC9hbTN6Rlo3RlQwRkdaRkdEZXNEcE80bGVuaWdO?=
 =?utf-8?B?Q3VkeitBdXljQ1ZEYVYzMWNTdGFmU3drOXRMTUFlbklFNHY0QXZYQ0JNMTdB?=
 =?utf-8?B?d3BuQ3plc2NmRDdqUytVQ3VsNE1yaDFSdmo4WjZaOTBhRWtqRG9aa015UmI2?=
 =?utf-8?B?QXRNRFRUSHZPSGxOVExaNktaTjlIS2lpVzlXak5sWDRxRU1uaEpINnUzL3Nm?=
 =?utf-8?B?eUdXTjVWUVJ3ck8xLzBoa0t2ajdBZWpaU2hPUTlwSXFaZmFzMDBVblJHSkZz?=
 =?utf-8?B?aFJjL1FTanE4VzFBazhKdVpaZVl3c3FUaWsvc2FhdWtoMGVLbWFOYWF1M0Y3?=
 =?utf-8?B?dWsxWTI2NzRkYVFrdXIxcGtzSFNQM25rR0tGRURBNVpFMXU0RFVzOGJpcmlK?=
 =?utf-8?B?Sy85eGRwRnNJVERicnZhYzlOVHVNMEpneVlKRFVuMEl6eXVrUk5VcDBvbWI3?=
 =?utf-8?B?R1pOcmdOTlZQOEp6ekowSnpzT1ZOQnAreDl6RDN1YlJRMlFjUUFheFEwMytU?=
 =?utf-8?B?SjE4blRtREI2Rk0xMCtkaWFVYVYwS0U4allBOWVHUW5RVFNscDdTWnBsakl3?=
 =?utf-8?B?ZEhLWWNEOTI4UHJCRXlEMWVsK3d6bkFZNzFUTGRLT3lUSDY2Vi80NWJIZkNo?=
 =?utf-8?B?MVRvRUpoMUtXZk9LVjQxM0FxME5zMkZSQytNekg5TURPL1VzbjVETHF0akZP?=
 =?utf-8?B?cUF1c0h4WkhLTnc2QVVuWDVxVkEzenVEYXFKcks1R2t4K29rdDA1bGRzU29t?=
 =?utf-8?B?RU4waHdyRDd1eFRrY1l3bUpMdkxZQjR4YlZQOGVoMHZ1V3lEOVhTcHhsTE5m?=
 =?utf-8?B?dlo1M3gxbEl4Vk9FdjVYa2xJOFVTN0ZIZ3V0YUtLTFN6T1RwRjVkdDhQQ0hp?=
 =?utf-8?B?ZEg2cHlnWWJSZkMrdjUxMFdZVUtyMTFQS3JUaXJXOHNGTzJkbHgwdWxaMzZI?=
 =?utf-8?B?N1RUYkZwSTRoZ1ZTcWMvMksySmFrampRMlQrNXFyUDVMc0p2clFIamN3YzF2?=
 =?utf-8?B?SEZNd3drY2lzVE1kY2Znc05md20wTFk4SG81cDNGQm95V3hwcmdFaS95SnpR?=
 =?utf-8?B?VUZhZnlrR2dwQjNUSEM3NmN4N1d2TU44SlJJZUJFNUpodStBQ3U1bU9TWkFR?=
 =?utf-8?B?VzNBNHA4bkVINUJIeTFhRDR2c1ZIZmlxYzVJT0Z3M2tiUVp1UmYzR0lQV0Zt?=
 =?utf-8?B?KzlpdGs0bXdscnkxUDdXVU90SkFQa0xvRzVzQ1plVzV2ZHVJVmZ0YUZTMjFl?=
 =?utf-8?B?SHNoME5WMUppYjY0UU5UQUtiNGNEMDRydXVyVHoxeGRqWWZseUIrZWlwMG5O?=
 =?utf-8?B?NnFKcHVLZGMxOTJ1dk83UmZPYmZsR2JjeUYrOTRXREVRN2RCWnNyc0hKbDh4?=
 =?utf-8?B?QXZrbWg4Sk5IUzEwYWVwOWwvMytOaUhIc3FPbEFRaVI2cTk0THFSOTRaZG14?=
 =?utf-8?B?bGh6N0dRUklVZmNzOGZucXhZQTdJbHFSaDFMRm5rL3VValFPQ2thdVJIa1kw?=
 =?utf-8?B?R0RRUHdCV1pJcmxhWjZ0eWlYN0dMZTNjdlptRjJnaGhzKzBYcmxueUg2MU8v?=
 =?utf-8?B?T2g2Zm4rT1dadk1KZ0J0aiszZXZnSk1RQTZWdVRUUmxNUS9SbTl4K05RNGds?=
 =?utf-8?B?M0ZBR1Z6dHd4WktFc3M0a1EvdGxXUjIrRHpISTJ0RlpZZURQYzJnQkxRZjdZ?=
 =?utf-8?Q?cX/HXa?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YUN1YkJvWFVuWVRzVTNuSk1GV2EzNU1LNlRmWi9Nd0l5eEFTUEJkYkhsVVcw?=
 =?utf-8?B?dDN2N3ZKc2FMQXhsbjgwRCtrSEVqbVRBb3hicUtGV2JjSzN1WDFoSE1xVHEw?=
 =?utf-8?B?dDhGWnY2RTIzYnFyL2hTTXNOL2VTU0dlU2FLWm9ZcnFkczVLeXYxL2F5cHpr?=
 =?utf-8?B?Y0pNazM3amIySS9QbTh1bnpqWDdDaEI4aWs5SFFlTHNPWnhvOEU0eHhOY1c1?=
 =?utf-8?B?QklXUU9jQllBNi9DWE9peVV0bDNQUUhGN09INCtobFQ2emt1MEVjdm9PdElH?=
 =?utf-8?B?NXBxY1RPUFJvRWlScmk4M1hqZzFaS1BJZlJmcWJrOXB6NWg2Q2p2ODR2dXVB?=
 =?utf-8?B?a3hodTBoSlNaMnVvYW5rNlhuc2twYnVLUzJwYjFsYU1MQjR4OXBSQkJyTEg1?=
 =?utf-8?B?U25yZjlWUGxrZVR1a09zQk9maFhwOE0zVE80NGlHazd5N3VFM2pwL24reWZB?=
 =?utf-8?B?VWhBQ3kvSS9RSnVuMHlXTHRzUkZtMXRYbXdhK2dHbStlelI1YlYzWVBjYnFh?=
 =?utf-8?B?NVFGdjFkTHdkQkt0SGJmek84U2s4cUpLb2Z3RWVKN0RTRTk0SUcyWm1OaEtn?=
 =?utf-8?B?aXVrZHd6L0VPUDN5aXA5MDJndnNZbU9xczQxRnh1UDBGbDE4cjJ3V3BXaFBT?=
 =?utf-8?B?NVJURkVxZUFqcitpa2dZZVRJdTh6TlFIU09kblBPNFdjZm02NkJhc0l6K2Fr?=
 =?utf-8?B?VDFNT0I3WXNnOGYwbWtCWm1jT3RQREhUS2RwckhqV2dBelhaTUVzemEwQmdR?=
 =?utf-8?B?UWt5R2JxalduMzdzNTI5QkdBa08zZlJKeXVPRHlnOHYzbzZtSThxY2cyVnp0?=
 =?utf-8?B?ekVJa2xJMk9KNlNmb2Z6NTlBOFVHZjJRdHp5NnFDemdMUXJ2Y2JZaE9XZGFk?=
 =?utf-8?B?MXc1b3NIc3RuaGpITGk3YzJMY1MvSVpXVGloZzl4TWhKSTQzZW1naEVVMzdE?=
 =?utf-8?B?TmM5b0dpM2V4QTA0S0ZENk9wYzRDenlxS0diQmpaQXgzS2l5TXdsbnZwMHMv?=
 =?utf-8?B?T2xUSlZhK0Jzb0V5WXh4Rld4OFFZelhhUkpUa0JCM0VHUGFMeERycEpvSEpu?=
 =?utf-8?B?RjZqeEhGMUR3MVN4MmVWMUJhNWExUGIzbUlEN0NudVFsYzgzZFR4Mnk5bkNU?=
 =?utf-8?B?RTd6VDArc1JmZTJBdmVudVhCemROTXpNWmF4VmhzVklSV3RXU3VMUi9zL0dr?=
 =?utf-8?B?MzNEY2F5YURiM2RwbVp1cEZ1djNoeG1yaktLU2VWYS9qZGVZbFRzK2ovU3dE?=
 =?utf-8?B?L2pXRWQwbzJpbXY5VUJUWDdCNWxpMCtuczVpazRHZDBhSmFTQzBzUG5nYkZ1?=
 =?utf-8?B?NmFNV0E3K1VJUDVHUGRiZ0dQSlVJVXdlcEhHR1MyS1hVTWdtT3QzaVZBSVNG?=
 =?utf-8?B?WmxkNE1xYUN5M29jS3ZPUTU2TU9uM0M4dHBJaEcrTGR0cHRFV1lIUzNiaVND?=
 =?utf-8?B?aGUxMEpEelpEVTZDYlhISVVOYVpOWUdUY1ZGOXBGa1VicDdZaHZiSG5MemlN?=
 =?utf-8?B?NW9GaWQ0L2JWcVB3UEdVdU9KY3YyYXlxbkRDNGo0VUZjRzQ3QW1ucm9pTEd0?=
 =?utf-8?B?OXZDUW0rNHZSMHk4bmpkOEFjdmFQRGlhbUpjM3lJUEw5N0dLelg2QVIyY3Qx?=
 =?utf-8?B?OFBJRTFwZHNjZUd2S2UxMmZUbXNSdDNFaHVuWTJOa3ZvMW1qSm5qalRSVU41?=
 =?utf-8?B?RjJzU1BuWHZ2S3VWYis4V1NTR1A5QkNYNlYxOXl6VVdLNTVOUFVhZjJ0NElt?=
 =?utf-8?B?d2RuZXNhbjFGT2xnM0FhalBwbmYyV1F1OE9uVDRZZ1owOGZuMENoUklhUEtQ?=
 =?utf-8?B?RDJ1TzBsbzFkRlZkR3NHbnRxMFdWWUFIcU56emxDdTR5R0xBVHg1YnNuUnph?=
 =?utf-8?B?bjJVUlVjc3UvVytHOXJ2ZThVME0yM3RRSEVGTy9iakx1U3NwVmNNSTJpRmpa?=
 =?utf-8?B?azVhSnplMHgwdU9DQ0dOcWJGVm52OE4vSllQOFhJckFDUWI5dHhuSlpTc3l2?=
 =?utf-8?B?TTdmS2owQ2tVSkVjWUZMbGZkNVlWTDJMdkk3bUZtNVJ4azVBUVo4cmtWZTRw?=
 =?utf-8?B?U29PRUFVVWZwczUvalBMdVhVY2RLcnZra1pIeGcyY3VMTElCNTMvNzIzU200?=
 =?utf-8?B?UUxSZWk0SGl3cURDQ2lrRW9FTXJFZlg3cVVKZ0pwWDBWOFRlUXY4V01PM0t1?=
 =?utf-8?B?dGpyUVhVaVlHQndaL1lmM0lsT09vNkV2QnZhTnQwSmRRNmRvVVB3TjUya1RE?=
 =?utf-8?B?RkY3ejFlMUFQWGtPYnI1RnB1WlpPRkhMT0lRMEErM2J0NjZHa2JOa2h6a3NG?=
 =?utf-8?B?S1hubFhXc0RQVFg3TXQzR25rZVdJZnA4c3VidVNxRmVwUi85TjNOMjE3czUr?=
 =?utf-8?Q?/sLM1nx44dqYWPe0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DE548740BF37242A80244FDCA22DA8F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b93dbc-d65f-475c-53cf-08de4e22097f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2026 19:22:02.7619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wj8d0tHtdXnJ7WOoMR3lEQDISxSmKcgEabf/RAwcv7kvZFl8KWAS5GKpScTFESDqlUwRSLmtsud4kIrujlVKrMNxG+txai2CmhFXT0lm0Jw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8027
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI2LTAxLTA2IGF0IDE1OjQzIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBNYXBwaW5nIGEgaHVnZXBhZ2UgZm9yIG1lbW9yeSB0aGF0IEtWTSBfa25vd3NfIGlz
IGNvbnRpZ3VvdXMgYW5kIGhvbW9nZW5vdXMgaXMNCj4gY29uY2VwdHVhbGx5IHRvdGFsbHkgZmlu
ZSwgaS5lLiBJJ20gbm90IHRvdGFsbHkgb3Bwb3NlZCB0byBhZGRpbmcgc3VwcG9ydCBmb3INCj4g
bWFwcGluZyBtdWx0aXBsZSBndWVzdF9tZW1mZCBmb2xpb3Mgd2l0aCBhIHNpbmdsZSBodWdlcGFn
ZS7CoMKgIEFzIHRvIHdoZXRoZXIgd2UNCj4gZG8gKGEpIG5vdGhpbmcsIChiKSBjaGFuZ2UgdGhl
IHJlZmNvdW50aW5nLCBvciAoYykgYWRkIHN1cHBvcnQgZm9yIG1hcHBpbmcNCj4gbXVsdGlwbGUg
Zm9saW9zIGluIG9uZSBwYWdlLCBwcm9iYWJseSBjb21lcyBkb3duIHRvIHdoaWNoIG9wdGlvbiBw
cm92aWRlcyAiZ29vZA0KPiBlbm91Z2giIHBlcmZvcm1hbmNlIHdpdGhvdXQgaW5jdXJyaW5nIHRv
byBtdWNoIGNvbXBsZXhpdHkuDQoNCkNhbiB3ZSBhZGQgIndoZXRoZXIgd2UgY2FuIHB1c2ggaXQg
b2ZmIHRvIHRoZSBmdXR1cmUiIHRvIHRoZSBjb25zaWRlcmF0aW9ucw0KbGlzdD8gVGhlIGluLWZs
aWdodCBnbWVtIHN0dWZmIGlzIHByZXR0eSBjb21wbGV4IGFuZCB0aGlzIGRvZXNuJ3Qgc2VlbSB0
byBoYXZlDQphbiBBQkkgaW50ZXJzZWN0aW9uLg0K

