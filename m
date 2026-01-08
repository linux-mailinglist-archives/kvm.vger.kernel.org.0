Return-Path: <kvm+bounces-67466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 86B07D0608E
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 21:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AFBBA3011EF6
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 20:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD5432ED29;
	Thu,  8 Jan 2026 20:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XzuP9pP5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9870E32E752;
	Thu,  8 Jan 2026 20:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767903894; cv=fail; b=L4zII3/gqDATh0iYdAdSWXgyxg2BTHNCCA9Wa2Ms4p9lTXdTx53SLyD2eIJA8/c/dvt1ovSzTlkicKiS5LxQsJqi5zN2YPEGs3QIoh6N9tVCOucqsFxZZqyRsyoIScU4aO+qjsMYEiYyZr9d+YG1t+6Uv5ZxZg22s85kd97UywY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767903894; c=relaxed/simple;
	bh=nQsKuPo+fYe0NUE5IkN7n8fiRm83tlFXb6R5mNE6nd4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Uz+NaYThlIoOlw+IenMiYOe+Mmyz1+hM1QUtPmrjTfB+tRQ1a082pRl7qWEYizY2rVjurXCnaGriIh2lAg/DR90gm0+Jo5KwVjScaBDK5Al7GK61109isFmWz4RMI+8SdSaUpLfqLeDKbGcCJF0gmcyHXpmnngYe75vFjidgho4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XzuP9pP5; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767903892; x=1799439892;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nQsKuPo+fYe0NUE5IkN7n8fiRm83tlFXb6R5mNE6nd4=;
  b=XzuP9pP5qIwO7gMOMWOIpudRqj8DXIHKUn6f6qu2B+4817HCU5zr9P4J
   mGwORKPaB9LrH4UwdjdgeIHhn+5lxeuB/CvFTIaClLfq67HH1wp2k4Xx4
   My0jgSA5l94SJghl3kndOLSkd7Fk++teHeG+S31f1pU43D3ipapjXvhaa
   9Jdw2aWnvmavtw8wYGliz4IK1MbrMVbo3Wr1xKrhvxaLgoMtbyAnWBV4q
   92ZOs89k1ycwbtzrhUQ+pVaGHGtcxU0h2VoYS9G32XwIkUvmoVNL9LMQJ
   OYGAa3iW3vwQF3Vfhd/pbcBfuwMZjSko96CFfx1r6PXg2dqGkyrZk6MnE
   A==;
X-CSE-ConnectionGUID: lGScr8MfQGW1lHpHGxrm5g==
X-CSE-MsgGUID: QLlkWrFjQJSiPF/Wf6egTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="69335121"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="69335121"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 12:24:51 -0800
X-CSE-ConnectionGUID: GhkHHZNpTT6yF2w6oTAaYw==
X-CSE-MsgGUID: /kjUe08oQweVtS9ckxxoYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="202421442"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 12:24:52 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 12:24:51 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 8 Jan 2026 12:24:51 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.58) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 12:24:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v7cjxrM1D7ajqUn4M/TGuzQJ61+1yFbyfrHXsPFfofnH7h2yYZtaTu7EJRlOix91N1OMoPmqRqRarOEdJW7TotXyai8hLNB9qhVoqApg1NHYjPCONmRV7ELHSw8WI+sXPYHgmpEjAVZHPUfSmiUKLRDLkc1KXtTVcy3kph+v+9sy/ZgelblR7eGiYJnXlMGtb3heRv2iM667cnhJZp1tZ3iTU8ghhW2DndFuwXNd/hZTKBryq0dgnVU/+48dSmeysPtwFMG2uhtacqDyOqIRzzfaYr3r++AjM459cVfKnMiQXJ85HnJ2R9TdN4GmFnp2bO0OwTR809eFMppwvGCceg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nQsKuPo+fYe0NUE5IkN7n8fiRm83tlFXb6R5mNE6nd4=;
 b=G9V9stE5kFoKE7NiEQ1ojOwV29nsRRE83EXanAXLGdbuZjwwtt3OBr6mwHQZYmBqAnukjq2SMYADDm5zcSJJ/gf+Taym3+euQPhVZ8g34S4Z4GQ4xtmq9oHHydUW6an2R5I6DhysyLlCR1UR1Cl2UIwQIRuo1sBKzmi/8JuMzoeQ0MUtij2rZEVj52M0pGiz4iTtiASN6nW7h3vwVlZs7F1d4i0MOv0BPZmNDKvymUevkYrHoSWGlOxIK0+jqJps7oN8yyw+9cZBLZnc3PezaSdyZTEsYC1EcQ3RqDm9qvzu3iYu0JqwtjCfErxf9PbWE8BHRriflHNx1OOqY0lYUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB6661.namprd11.prod.outlook.com (2603:10b6:806:255::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 20:24:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 20:24:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Huang,
 Kai" <kai.huang@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/2] x86/virt/tdx: Print TDX module version during init
Thread-Topic: [PATCH 2/2] x86/virt/tdx: Print TDX module version during init
Thread-Index: AQHcgDYy/ai2v5cOskehiugVnnJnEbVIuSWA
Date: Thu, 8 Jan 2026 20:24:48 +0000
Message-ID: <d939c09969a30300ed1faa86361f956809831fa5.camel@intel.com>
References: <20260107-tdx_print_module_version-v1-0-822baa56762d@intel.com>
	 <20260107-tdx_print_module_version-v1-2-822baa56762d@intel.com>
In-Reply-To: <20260107-tdx_print_module_version-v1-2-822baa56762d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB6661:EE_
x-ms-office365-filtering-correlation-id: 8e9bb838-4635-4e83-cabd-08de4ef3f84b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?MDNtdFJYK080dUh4a3d2L0p5S21pUHhmRS9aWElUUjNUSVZXZE1aRUVBR2hh?=
 =?utf-8?B?Qy80OGtDaFZmNytNNHA1VFZZTHFrYjBEdmlacnhEbmVGR2MyaUpjbStYRXVX?=
 =?utf-8?B?TSsvWTBuSlVreXJvQVpDZVA2L2JIbWtKWmd1cGNkVlZVcFRNcHlhZllRaHM5?=
 =?utf-8?B?RHY3Z1JCQ0ZQWjczQkZtbjEveG5wQ3p0cWx3MnphWTBKV3Fwc21LdVhJQy9W?=
 =?utf-8?B?eFBrSndTVVRKVnRGVitqUDlPUkkzUzhFZ2JSVkRVSXhQejhRaG5INmJpTUFu?=
 =?utf-8?B?UkRZT3NrMzhNUlFGLytMcGtybHh4NzVIM29abDlwQ3ZDWERDV3JGVDNFajVE?=
 =?utf-8?B?WGFQR1N2Mk0xelZmdWsxd3pycGVUUTdpQnd2b0lBNXhYTlhJY2RzL3lqVTIz?=
 =?utf-8?B?cU5YMWM5SE5iUk1USUIvSzNGVm51ODRpckx5VTdJQjVxUTZ3QXlyMnRPZkdK?=
 =?utf-8?B?R3k5aEtWY0JEekhmZzF2UmpGSjU4ZzV1V1JlTExrMElVaHJrM2IyaVRpOW04?=
 =?utf-8?B?aU9Db0Qvd3FDb29Ya3psRkYzdmgwZGFoYm1BOE1uUjJOajhhRTQ5WW5DdDNz?=
 =?utf-8?B?VTNaemduT0ZXVkNGWVVoNTlBeWtwNFZiY3Q3R2k3VCs1SVlsZ0JWZHZtWlFO?=
 =?utf-8?B?N0VKZGZGZDFjVTloUTBldTh3WHlCNUhUai8vdHBhNG5idGN6VzJ3c0p3dTl0?=
 =?utf-8?B?ZjQ0NkRyTXAxNWNmOCtCWjF4UHQyb0pXUlhsN21sSkFVYU9wVW02WGcwRWYx?=
 =?utf-8?B?ZGQ3V29JdlN5elgxeVRKTTc5SzY1dDhXVlhFd0tNTkZFUUlEYUdkQnVzUnVM?=
 =?utf-8?B?OStRUnNLZHhYWjlmbmtUYW9TUk9nQjlmZVB0Z3F2NURUSWZJVkE5QVpoaGxM?=
 =?utf-8?B?M1VsR0ZDN1dBNFQraEVvNXlNRjFCb1ppNUNuY0NJZERzSFlMaFByNlBVTXdK?=
 =?utf-8?B?Tk5IWHlYbmhSOWJtRWh6ZG5IdGJ3R1ViZzlpNEkvUmNKOHNkaHhjTCtkUFk5?=
 =?utf-8?B?TnhYSnJaNlFPZ0ZFNk9ydjFSQUc4OWFaNEIrQ1U2RUNJL1V1K3JlUzBHam9i?=
 =?utf-8?B?MW9aSm4wSTJUcTdseC9wZGJsYUUyTDh0SjAzQ0JvY0YvYTB3REtUZHpXTjl0?=
 =?utf-8?B?aEwxNkJWdE5lVFNqaVYzSzBlUE0rNWlaVlkrbjl1Y1E5ZlY4cGRiVitGMDBP?=
 =?utf-8?B?N1hrYk55dnVFMzB3ckdHV2EwNEhicEFBcjNwV1RETUw4U2twRU1tRVdWV1Fh?=
 =?utf-8?B?Z3VobzM0S25YcE1JSVhBMytubkROcGF3N09LQ1NSb2t6aVRHWGtSRG9GVTNx?=
 =?utf-8?B?NnJIT2xrMWpLeXJ1a2Q5bjJHamFrYVFPOG1CdmEvYytRZGZ6amF3U1lkYUd2?=
 =?utf-8?B?OU9ZQ0FpNklnOTdnalRsT3AxVmZ3aytIMURTaTMwVEQxOWxvSThpZmRvQTRp?=
 =?utf-8?B?SjExWVoxZmY0VkZiSlJjd0w5RGtPMzNoMGhITVE3ZXJ3Q2NvYUVRdU9YMU5w?=
 =?utf-8?B?SnBKdkQ2ZjZsZTF4MjFleldkMEptd0tZRkZoWDZpb2JUUFZ1cE54cTM0RS92?=
 =?utf-8?B?RWJrb3JIeituK3JPMEx0dzZqeWRubDBNd2Mvb3g3a0ZoQ0xsaXJvYUl1dlZk?=
 =?utf-8?B?dThvMmJPMk1Qc080QWNjYjNzRTFNYjdoaGljNjZOckIxRzVlMWJhUDhXa25Z?=
 =?utf-8?B?aStRNVAvOFNZM1pLSHhKQU1YTDdJWE5MZk9LcW9hbXQ5MWFYYXhGY2cwV05j?=
 =?utf-8?B?amtwSWZaUGZNRmlodmZGTC8zU3Z2UGdOWlJLUmlJMkJhak5lUzFiYlJnMDJ2?=
 =?utf-8?B?eTM5NWMyckR3RDlVNUQyUzNLcGZ2WFQ5bmZFdHNNUEc5Vk4xNkJhRDh4ZFVU?=
 =?utf-8?B?YzBVaWFLVUVQTzRpYVRDOXVPczJYNW1iNGRRV1ROV3RBakw1NmRpOGljWlF6?=
 =?utf-8?B?TzA5bEJ2Q3JySjlEK0dNR0p1SkdYcUs2RHJ2cGw4ZG1tdkgwa2VHSWp0L3pC?=
 =?utf-8?B?WjNmclk4Yk9FMGtIRVlDc1IwK0ZoTXpoOXYzMDBNTUdIY0h4dFowNzFZcUtJ?=
 =?utf-8?B?MGdjSHhRZVJPbXBlbkh5bStQeitnQzZhK3NqUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnZqWHZ3WnZQLzEycVhvYWZCY1pGeVpQdFI3aDVGMTBVQlRqTXkyR0NNMWgr?=
 =?utf-8?B?d3dLbjk0aG95WkkvRXVrU0w5Z1BFTHptNW94VzcyVFRmMWs5Qi8zMG52NlRm?=
 =?utf-8?B?TFYxYWRyWSswZTNVbm9SVGltUkRGYXVUbGJKdGt5VXkxbU51M2JZTTJmMGwy?=
 =?utf-8?B?dmlYdWptb0FnTit1T2JEa09jZlZER2w2L2xoeEpyYVVNTjZZb1dHQmk2aGhm?=
 =?utf-8?B?U2xxVkJ1b0ltMjhMOG54ZXlRbnV2Y0JMZUVXMnJSaWZkeFc0YUpudi9MdnRv?=
 =?utf-8?B?VGsvVDZkZzRjTVVteUl0b2NNWXZ6SldiMTBkbjI0UUdqMW1ocHRFQWVVVEZh?=
 =?utf-8?B?Vnd5U3djS1Myc1I4Ym1pYnR6Y1RQc1RTeHFDQ2RKRE44VzJFOWIxZWV5Ukwx?=
 =?utf-8?B?S0VuWk1pU3lKUE5Sdkt3ZlBxZ0toK3RTQmNOQnZORS9sWTRFb245eE83VXFW?=
 =?utf-8?B?aHhXWURIa0R5K29xajVyVFFIRmlKTzdQbkJleWV5YzR6SjFjTTRWTTlHQU5J?=
 =?utf-8?B?SkJzRDQxRnNWc0FNNGwycUJIWnlLTlZDc2tZdmVmTlJaYTJOd05wMDNyMDRD?=
 =?utf-8?B?SE5Hb1FGWGFyYUd5Ri82WGNaL1VCNHdEUFJ4SDE0Y3B2eXNaWE5sVG1UUzRG?=
 =?utf-8?B?Zldta0Q2TkVVRVZlVVhiWUZaaFRYSm9yZzd1eHVlT1VlY1hibkR3Z04yL3Ru?=
 =?utf-8?B?YUZWcENOUUFnR01iaXBRN3FVQ05vTmkwTVJoUmdJeCsxYTJCZ2NJVEwyRFdu?=
 =?utf-8?B?YzVDM000TGZKaVEyS1M3bFY1VlBmekU2cW1RWFUwNklHL2ZScUVBZ0VFTWpG?=
 =?utf-8?B?MkRxd1U4bU9aVjZpZStJYWVMR1hpWDMxTXJ4YkxudmFVTzRhcFdnbnBUNGRj?=
 =?utf-8?B?alQvSDFXMURyMTdvQmRiSVZNNnRHTUJuVFZUa1hQZHZGak0xV2w1QVNRNThE?=
 =?utf-8?B?ZEtNQWJoN2Q3QXdaQ2M0UXF3UmlGUm5PQXk0UVlZL1YxOGxvVnJmN1Q3bFcz?=
 =?utf-8?B?N3h3cFNxUHRDanRFVUFqdWpQZFBUTjVNSjFtNmdoaWpnMGhoa3VDUVRQazd0?=
 =?utf-8?B?bFFpSDlnQ0JLVlhRNHJYRTNOZDh0NW9KUDVzbzBRZlJ6OGp2emFsUmY3VzVk?=
 =?utf-8?B?M2JmcjVLUjJUbmIyZC9hVi9zMmp6T3BKK2gySmQ3TGUvL05sWmFMalhkNlFU?=
 =?utf-8?B?REhmRG9wQ1FRaWJmL1VhcGs4czJ6cTBDRittbXFMcERFQ3lTK3g2SFJSTHpj?=
 =?utf-8?B?VHBXczk1MTk4Q0RmN2UzNldTRlpDVFU5aVpOaE5idkZyaTQwMExzUlFOUU01?=
 =?utf-8?B?ZmNJMmpPdjNORnRkcXo3OTlzR2ZlSmNCRVFSVTBVM0UxYjdoL0twRXEzbG53?=
 =?utf-8?B?MmdVSS92aVFRczRxMTh4Z0cwQitDTXdDSmFxMVkxVS9SL3RmQXk0eTRseDZU?=
 =?utf-8?B?bnJlNTUrU0I4MHN5c2lmZTZ6eXdsdEJGTTFaWStZUURyTXhUVzNBOS8xV1c4?=
 =?utf-8?B?WHBIVkc0bjlReXRrZjBOTVIxdVl4azhldFpoMzBCazYrSS81VFk3Yk92citP?=
 =?utf-8?B?ZnljWHJSK0lNRk15TGNFK25tZkpZMCs0QVB3VkFwOTBnRlZDdWd6M1FjSnR3?=
 =?utf-8?B?cDNTalBYc2w0RWF6czJpUFZyTmNNQnRDZ0JTQlFYa2g0VmNXSVRxSTVJaFVt?=
 =?utf-8?B?VmgwTS8xd25IVDZ2eUkyRnVFbGFZUnBnaU9OSlNuMWxZNkdlZFJHeURvMlpE?=
 =?utf-8?B?YzlpcXhwMjNidU1BOXh0RmE4Uk5KTVJuSWY4ajZyeDBCWGgxQi9NY3JqUXBY?=
 =?utf-8?B?bS93RWU3STh2am5sSk0rTndQbS9sNlpTNDdCc2VGUExVTnNJUDJaTTdKc29s?=
 =?utf-8?B?M2JwUTZxbjhlVzdDUlNTUTluSk13Z1p3UDV6RWI3Q25LM0xockEvRm9YenZW?=
 =?utf-8?B?UmtRY3RsSWdYbzBmckpxT0FrN1JFK05hTGxRaVlWMStqQTBHRFI1MG5IcE1t?=
 =?utf-8?B?cWw0MmNDdTdrZlBpbSt4NVFQa3lvNVo0MXdHbEpOeGZDOExXVktHZC9DNnFi?=
 =?utf-8?B?Q3RhL2dXYkZtWG5NNHNPaWNSalV3ak8xK2FpdXBUZXJNcFVGT2g3aDRGa2xB?=
 =?utf-8?B?d1FYTlkxYmVNU0lxZUxhREgvNkZmbXdDbjJXbDlqOXBEcXY2ekxGY2VyTmwz?=
 =?utf-8?B?UHZ2MHRGdEhZaXJYZVd6elFDVEJaUmdVQ0x2cTRYUlBVWlJVUzZ3TmRJaFBs?=
 =?utf-8?B?Lzk1WWVrdGU5RnAySFhqaGM2WkRNdWhQaHU1MzZIWEowS3FkTUxtdlBSUlhv?=
 =?utf-8?B?dm9FNkU4akg0eHNBR01rdVUwbDhCNVg5SitCejNCb3BMQm9XckNpcjVLeGda?=
 =?utf-8?Q?0iFkPuEnC49N252A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA4CF3F3BD4D3445977F596245B06A19@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9bb838-4635-4e83-cabd-08de4ef3f84b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 20:24:48.2403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BGqFssQRwl6TsXfjDaOq46PUXFIB9YdDh+lUk3ef68TKS3tLh/gpWiz3j5kfSZnY9smbQS0+ZLBdEqi4PbzGE7HssKz3c8r/5nV0UEtB6MI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6661
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDE3OjMxIC0wNzAwLCBWaXNoYWwgVmVybWEgd3JvdGU6DQo+
IEl0IGlzIHVzZWZ1bCB0byBwcmludCB0aGUgVERYIG1vZHVsZSB2ZXJzaW9uIGluIGRtZXNnIGxv
Z3MuIFRoaXMgYWxsb3dzDQo+IGZvciBhIHF1aWNrIHNwb3QgY2hlY2sgZm9yIHdoZXRoZXIgdGhl
IGNvcnJlY3QvZXhwZWN0ZWQgVERYIG1vZHVsZSBpcw0KPiBiZWluZyBsb2FkZWQsIGFuZCBhbHNv
IGNyZWF0ZXMgYSByZWNvcmQgZm9yIGFueSBmdXR1cmUgcHJvYmxlbXMgYmVpbmcNCj4gaW52ZXN0
aWdhdGVkLg0KPiANCg0KSXQgaXMgbW9yZSB0aGVuIGEgc3BvdCBjaGVjaywgaXQncyB0aGUgb25s
eSB3YXkgdG8ga25vdyB3aGljaCB2ZXJzaW9uIGlzIGxvYWRlZC4NCg0KPiAgVGhpcyB3YXMgYWxz
byByZXF1ZXN0ZWQgaW4gWzFdLg0KPiANCj4gSW5jbHVkZSB0aGUgdmVyc2lvbiBpbiB0aGUgbG9n
IG1lc3NhZ2VzIGR1cmluZyBpbml0LCBlLmcuOg0KPiANCj4gICB2aXJ0L3RkeDogVERYIG1vZHVs
ZSB2ZXJzaW9uOiAxLjUuMjQNCj4gICB2aXJ0L3RkeDogMTAzNDIyMCBLQiBhbGxvY2F0ZWQgZm9y
IFBBTVQNCj4gICB2aXJ0L3RkeDogbW9kdWxlIGluaXRpYWxpemVkDQo+IA0KPiAuLmZvbGxvd2Vk
IGJ5IHJlbWFpbmluZyBURFggaW5pdGlhbGl6YXRpb24gbWVzc2FnZXMgKG9yIGVycm9ycykuDQoN
ClRoZSBURFggaW5pdGlhbGl6YXRpb24gZXJyb3JzIHdvdWxkIGJlIGJlZm9yZSAibW9kdWxlIGlu
aXRpYWxpemVkIiwgcmlnaHQ/DQoNCj4gDQo+IFByaW50IHRoZSB2ZXJzaW9uIGVhcmx5IGluIGlu
aXRfdGR4X21vZHVsZSgpLCByaWdodCBhZnRlciB0aGUgZ2xvYmFsDQo+IG1ldGFkYXRhIGlzIHJl
YWQsIHdoaWNoIG1ha2VzIGl0IGF2YWlsYWJsZSBldmVuIGlmIHRoZXJlIGFyZSBzdWJzZXF1ZW50
DQo+IGluaXRpYWxpemF0aW9uIGZhaWx1cmVzLg0KPiANCj4gQmFzZWQgb24gYSBwYXRjaCBieSBL
YWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+IFsyXQ0KPiANCj4gU2lnbmVkLW9mZi1ieTog
VmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+DQo+IFJldmlld2VkLWJ5OiBD
aGFvIEdhbyA8Y2hhby5nYW9AaW50ZWwuY29tPg0KPiBDYzogQ2hhbyBHYW8gPGNoYW8uZ2FvQGlu
dGVsLmNvbT4NCj4gQ2M6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNv
bT4NCj4gQ2M6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gQ2M6IERhdmUgSGFu
c2VuIDxkYXZlLmhhbnNlbkBsaW51eC5pbnRlbC5jb20+DQo+IENjOiBEYW4gV2lsbGlhbXMgPGRh
bi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
YWxsL0NBR3Rwckg4ZVh3aS1UY0gyKy1GbzVZZGJFd0dtZ0xCaDlnZ2NEdmQ2Tj1ic0tFSl9XUUBt
YWlsLmdtYWlsLmNvbS8gIyBbMV0NCj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxs
LzZiNTU1Mzc1NmY1NmE4ZTMyMjJiZmMzNmQwYmRiM2U1MTkyMTM3YjcuMTczMTMxODg2OC5naXQu
a2FpLmh1YW5nQGludGVsLmNvbSAjIFsyXQ0KPiAtLS0NCj4gIGFyY2gveDg2L3ZpcnQvdm14L3Rk
eC90ZHguYyB8IDUgKysrKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykNCj4g
DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgYi9hcmNoL3g4Ni92
aXJ0L3ZteC90ZHgvdGR4LmMNCj4gaW5kZXggNWNlNGViZTk5Nzc0Li5mYmEwMGRkYzExZjEgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiArKysgYi9hcmNoL3g4
Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gQEAgLTEwODQsNiArMTA4NCwxMSBAQCBzdGF0aWMgaW50
IGluaXRfdGR4X21vZHVsZSh2b2lkKQ0KPiAgCWlmIChyZXQpDQo+ICAJCXJldHVybiByZXQ7DQo+
ICANCj4gKwlwcl9pbmZvKCJNb2R1bGUgdmVyc2lvbjogJXUuJXUuJTAydVxuIiwNCj4gKwkJdGR4
X3N5c2luZm8udmVyc2lvbi5tYWpvcl92ZXJzaW9uLA0KPiArCQl0ZHhfc3lzaW5mby52ZXJzaW9u
Lm1pbm9yX3ZlcnNpb24sDQo+ICsJCXRkeF9zeXNpbmZvLnZlcnNpb24udXBkYXRlX3ZlcnNpb24p
Ow0KPiArDQo+ICAJLyogQ2hlY2sgd2hldGhlciB0aGUga2VybmVsIGNhbiBzdXBwb3J0IHRoaXMg
bW9kdWxlICovDQo+ICAJcmV0ID0gY2hlY2tfZmVhdHVyZXMoJnRkeF9zeXNpbmZvKTsNCj4gIAlp
ZiAocmV0KQ0KPiANCg0K

