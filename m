Return-Path: <kvm+bounces-42280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C56AA77148
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 01:12:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BF9316B3B7
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 23:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 392F921C170;
	Mon, 31 Mar 2025 23:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SQOzbIEr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54383232;
	Mon, 31 Mar 2025 23:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743462711; cv=fail; b=Cz3TLUXV1g8cEXfco4rEZyCUjHXIMlEU166f5YlGtl6uOaaZogbw+R+XZ1x3LyU3laTvBjNDzEdeJTUFEM7ew7aOuctt6SWOq8t3SgfKb8vfwSw9MhttRKiCFfcunGnN8Vrra3KEMNeqlFSsgHZHRPtUm0wsK6HXsIe3q+JjIr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743462711; c=relaxed/simple;
	bh=r9NwjPdtDjBaEsZsjLQeO7Hux72pyk53JUAORYaTSI4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oj78JeGnLeAhnqrf2dPrsXcxX7+/rk4kJwikAoElK36uv9dEiMr6djN0TaMTiCmnnR7VnOfokmrd1WzmY48BHhHnAEZ8a4TSKZdr04srMcOAOvd8Is8AcFPreT6kA3MclD9zopIuOkudvR63dfcgH70KmPJSZ8B6kcZ1WL101Bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SQOzbIEr; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743462709; x=1774998709;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=r9NwjPdtDjBaEsZsjLQeO7Hux72pyk53JUAORYaTSI4=;
  b=SQOzbIErTCD6+H4gURukXz//L1qAb1noF7umBmuv5x2LlDL+7mbLgaUy
   +1o4pIQzTZVAhZiQy2jW6plzxALEmXOgrayKJrgLRc5bMQlrXSDHoCbCe
   /ZXw8ok2hv3nUc5+Xu6va5XdREYLjFgMGJq+EBIngGYhEWx7m4QnkrBwx
   fSXKQI7O1HdaRjHmUml5VYuGU3CXK70IDWUeKtVELpk/TwvGkhfER/3Tu
   0uDkYVP/jpmh6u9/+Ubez9lz6tJBAlU67x5NcQ0JtxKPfpbu9iXGSHUZE
   J5PVPyNUb9ho9wGQpbQZ2STLqqJrFvM0sJmGUAZxpUGxRomcuVoLCsoQB
   A==;
X-CSE-ConnectionGUID: JxgibUQQRKqT7Knx2KybgA==
X-CSE-MsgGUID: p6PzD54ERBaiHQje0nPaIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="48554983"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="48554983"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 16:11:49 -0700
X-CSE-ConnectionGUID: m/0HqqnbQnmjZjVdoegt2g==
X-CSE-MsgGUID: AcZKME6NRMOYZM+DpuMLwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="130325643"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 16:11:48 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 31 Mar 2025 16:11:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 31 Mar 2025 16:11:48 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 31 Mar 2025 16:11:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VaJHbi5BWTdzd4OVMr/OLGL6rXjCwkwITJmj0tGZghZZuyj5AskaMAFjVvMXHYl+gMB6f4GsOo2nHhWpYMNRE5XK8GhfxRMt+LNhln3Tzii8lWgY6R2s3kI+qFPuuHA2NW6sXcK11e/3t3e+gugTFcoat3KbPicpKbMGBpU8KfmLF7yVJotips35wYUPIKuEMIpw791oMz7wDO1G3s5NZrV2qhUApewcVfCo7Re4WjGY6LS0yZH4IlbKXdK0qkNLW9+g1CdYMtums6fk8UNnTTWv6rjlfnSyVkHUMFO0sJ2v+qYUMpBgWeGb0cpFir3iPIp7L035rfeudvLBO6KCdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9NwjPdtDjBaEsZsjLQeO7Hux72pyk53JUAORYaTSI4=;
 b=deT8ABDRrv3dwqXOy9X5Qfq8Tf1Zmpw4fuScIP+f+2o+hVmxu94vNnukAV2Z8+sdQYIRdVNRaNPgzCC2JcNyE5BHIuI9OG8JEe6REccRaqHttDesw2XuNt5+LuWKqyNYBgdT87QzMzvepGAJR0rkHSgs2sN17oWN/vRl+WcF8KkLPS4jNPC9fZ3oBuQHl1r8ItYysy+5NryI3b8rWPnFA0LxgzHV9VD4PGq2BLVXV6XidjQ21OF8z+fYmP4MD+USnMeBhC/LarGsbIzAZv1dZoqwKbECaiiT9xMAqiGpu1sBpnwFhgrk9E16pQtx7ffeJuU87vUZuUHg73xxH7NUAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4835.namprd11.prod.outlook.com (2603:10b6:303:9e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Mon, 31 Mar
 2025 23:11:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8534.045; Mon, 31 Mar 2025
 23:11:45 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Use kvm_x86_call() instead of manual
 static_call()
Thread-Topic: [PATCH] KVM: x86/mmu: Use kvm_x86_call() instead of manual
 static_call()
Thread-Index: AQHbomqMP5WFhkIetkiV3qFAWjH+dbON37IA
Date: Mon, 31 Mar 2025 23:11:45 +0000
Message-ID: <693d024b9a866a3456fac7f05ee235e6686c859d.camel@intel.com>
References: <20250331182703.725214-1-seanjc@google.com>
In-Reply-To: <20250331182703.725214-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB4835:EE_
x-ms-office365-filtering-correlation-id: b4ea2b76-e7de-4f67-580d-08dd70a9680e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SjBYckMxTlYyVGtoMmZ4cFBlVzdVZlRTNXRVRmpLWGk0c09WMGVIb1VLZDRR?=
 =?utf-8?B?Yzk5M3NMVG9jQnkwTHNqbzZDaCt4L2Rxdm5pd2hLeWVDTHU0M1JpWTBmVUhJ?=
 =?utf-8?B?SXZKcWI3L29rbXA0WDl1dDBHTEdoYlQwOVFLK25hbXhKYUZIayt2US9SQWdh?=
 =?utf-8?B?azlKblY0Uk1SVXFQYXo5NmFBdGpEZVZLVGp6U1hHWk1GMlhsL1BwMGFiK01C?=
 =?utf-8?B?MHVNOUV1cW8zd3RBYTM5d2ZpS1l2ejlaQWJTZHlCZzlpbEJPWnhMWTQ0U0FT?=
 =?utf-8?B?TVBIZ2F4TFVzQ01GQ3ZNbzgzaExrQTI2Ulh3WVBhcUNCQnpNM2hOUUE5a2hr?=
 =?utf-8?B?UWFndFBNR0l5Y1I5NHJKRU5mNUZBbWdaTndqMzE0NmpPWSt3WFkra2pjQnJt?=
 =?utf-8?B?U0dzZW1WZ015SlhDZXR1MWNHTlNXbGZubkQ4ZFlhRm5iNURsN3FFUTV3UWtN?=
 =?utf-8?B?WmFFdzlmbnM2TXJ0MkF2VFRwQ3hYMEkvdCtSUEVIaEpwU1dkY01nSklrV2Vy?=
 =?utf-8?B?cEFxS2JjVytMK25JWmxneWkyTUo4THBoL0ZVR3RxcG1oTG9PaWtCUGhWeFZr?=
 =?utf-8?B?cWVJOGl3S253OVF5WS9HdGQ0cSszUml1VTZ1RDI4Y0xOeFMzbWIrTW9uZ09U?=
 =?utf-8?B?TVdSRHpROW9KNlZOVHJnY3BBOWxIcVZFM3A3TTZBdHAydkNsMU90YzMwNmNl?=
 =?utf-8?B?bStEZTdkSml3UDBSSVFkTkZKYVR3Zm1lZ2x6bDEzK1pNMHljM3JBa0VveElr?=
 =?utf-8?B?akY3U1AvMDhWWW5zcDNrd213T1lDNWxDejBCWUZIUmppRnhqcDFpb2Y0TUVW?=
 =?utf-8?B?M2p1NnRESUx4dDArcWFkZEtOV09ULy9DVU84RTlGeWdNUzcreFV4UlRmT0Rw?=
 =?utf-8?B?UHc0VktKcUFuYTRCQW11NnNxMGRNdDFpU0F2NlBwdnhJQ0hVZVBNamlrYlNR?=
 =?utf-8?B?dHhqTE1PL3pnblpVQXlBdllMYWl0T3c1L2haUEtuTm1zVmVUbFl0Q0NtR2JI?=
 =?utf-8?B?UnlvVS8zcERRaUVlRUNTTVpNeE14emFYb1A2dFRmZm54ZVVjRk92d1FraWxq?=
 =?utf-8?B?R295QWtnV0RRd01vN0h0bFhYaHFuN1JGMEk5NFlaZ1c3N3ZTWTBhUTVSK3B6?=
 =?utf-8?B?L1dUckFvNldmQ21ZN2lNN2VuaDBndFBQdWdGUW5lVEcwMU9HRzBGLzA5aWlu?=
 =?utf-8?B?NktiNEhneUlyVVQwSUorVGxCTnJSeTF4UjZ2ZlVDdnpCbjJuUldvRTcvRjUv?=
 =?utf-8?B?TzBFckpoS3NUWndIdHEzbXlBbW56YVMwOStWeTl5YUFFSFBnZXNTSmpxVzZt?=
 =?utf-8?B?S3o5R05zaTAyMjU5cnJHR1Qza202ZGc1RHhVQzhBK3Q3YWwrbmFEalRYVHJC?=
 =?utf-8?B?NjQrQldZT0ErYkNUb0FhaHkvL2NyUDk3a0dKVTJKNlJEM2lmbzdQVDUzNmJN?=
 =?utf-8?B?U1g3THI5UEFCTTFjUmwyOGNaWGNHYURIckRuVGtVUzhmeFczRGg5cHZkdzhy?=
 =?utf-8?B?ZzlaSEppS1h4WVdzOW81aHJwZnFDSy9Uelcwck8wc2UxYWNBUlFEQ2xaazlD?=
 =?utf-8?B?TnNHai9Rd25adWVycUFia0JnNndMenB1TlFFYlpKMWVHZlBFQ3N3K3NHY3Zp?=
 =?utf-8?B?ZFZBeXIzcGdqWm1tOEFzWm5PRUZKNG9VaVl0Qlo4VUFvS25PNW9iK2pCUTBh?=
 =?utf-8?B?cFordlBMV0xobUlXQ2c5aWRsZzhSaDQrRUdUQiswcmxCUVB6dDJ2VE05WG8y?=
 =?utf-8?B?eUxmWjJWTUsrdlVNb2I0UUduZ05TVVpnQ0tHemdXNW5Qa3ZFME50SWoySTlF?=
 =?utf-8?B?MGlxSmV2dSs2TWpyT3JVQlIwa0N1anh5Nktpd1FvWHFkWEFyYzFIbWZZbWhE?=
 =?utf-8?B?STVBT2M2dURDeEFEVHVDK2lPYUNnZGlEejFXdWhseDB0NEF1d1F4TTdhTmIx?=
 =?utf-8?Q?DcfIf9J6iiByrohqGPJg1yndJGinGkjI?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXRGMTN3NUp4b1F4REZUYStIQ3g3TmEwWjlQajdYNGF1eUIxOGhZQkFSaE5x?=
 =?utf-8?B?cGtmUnJQWERWRTNCeGoxTzRXS1dsb1dsRURkZlFwY1pKZXZBWkJLT0k2Yi9D?=
 =?utf-8?B?RXE1UWJMUEpDYWJobDRqQzk5RnZobTVJa3VUU0huMjlVcFJYdEl4LzY1aEZB?=
 =?utf-8?B?MysyaXN5RXhYMlIvZ3NKbUZOQmJhQlBtbUp3UUxvcW0rREdiZFc1ODdQcFdU?=
 =?utf-8?B?UmlKcnFRUmpvbVEvSkg5cFlTdllTdWJja0tmVU1JeGI3QnFvK0t6V1kvMGx5?=
 =?utf-8?B?UTVhVWdjbGp5bXBFYUVPRFp2QWFDZ3B4VUlYOVUvaWhQZHNCT3g0ZzlVeFJP?=
 =?utf-8?B?eDhDY1ppaW54VWZvMStEZHE3QmVjRnozOTBUVmxOSDIxdXBDT1AybDYrbC82?=
 =?utf-8?B?Zm9aK1VRVWFBLzNpWHBDbDltTzIzVnFrTXIwUi9vcVhsME9udlR0TGRBR2ZU?=
 =?utf-8?B?NmhtTGdxckIxZ216NG1hcldqanZKT0crcXJVMVBtSVp5M2xEZjJGa3hpNFhL?=
 =?utf-8?B?cjcyZUlONEZoeThSa2xXT0kwV0dNT3RscnRvNFVMcy9IWVZPRGVEekUzaVZx?=
 =?utf-8?B?V2hRb2xKOUFHRG8yY2EwRCtFbUdOODEyOGEzMXFyZWNmY3ZNaVVldlJqcEpD?=
 =?utf-8?B?YnFna1Rpb0N3OGN4VWhsRmxhZVRXUDJmV0krbll5REtMU0tJZ3p5TlRTNWZw?=
 =?utf-8?B?L1hWVmRjMDlnVS8vZHVwOXc2R1V3TFVJVTVqTjF6Qk5xVHRlN2tMQ3NKZEN1?=
 =?utf-8?B?bUVYcnplQ3JFMllLSGpkMnBSTDA4ZE5hdWw5Mml1MDFsYWZRdHF2eTVzdUxj?=
 =?utf-8?B?akJEM2pOaFZtUS9LUEZWWXNSdXdMTmlWbGtlRjZRby9hK25JRHg0MjRtUE1r?=
 =?utf-8?B?V2RQbXRZMjBXNm15MzNOaTN4K2NHMXJNTTVpaUhBWnE3dkFaL2xxMDVJb2xT?=
 =?utf-8?B?S3F2V083NUVkb2ZMN1JJSFFCS1JSR283NVZkRW1zSW9sOUdsS2tuYlhvVSt4?=
 =?utf-8?B?ZmlsV1Eyc3A4WnUxR2hoL1psTVo1TWFPR0kxS3p2bmVFVks5NWx3bDNGdFJu?=
 =?utf-8?B?bTBZYUtSRWIzTDhGMXZsTVRBOXZzdDJZczMxSSt1TDVadUh4bno2b2NNL01I?=
 =?utf-8?B?dFFnYTVyL0ZNcTFnaXN1WmhtSVhTUDhLbm5YdWdTalpTWWhQbHlrc1dIRWto?=
 =?utf-8?B?WjM0SzFlT3JFNXZTUlo0U1JWc0RnZXR0ZVVHbVQ2UjZyTEFtbXV5S2pKdnpO?=
 =?utf-8?B?MVRreFdkb2k2dFlsK0RydXdGWUZpUUl5TWhJWmlJUjJmRG1QRFVOOFVMQnhx?=
 =?utf-8?B?MkVjSWlOV0FCQVpmZTZQZUNQM09od0Q4em12dGI5d1hLUGMyR3JISmJGRS9Z?=
 =?utf-8?B?TDdqZG4zT1RsYXJLTjZ6TEhTN0JES1BGT0NuWWZPVnNFZ0ZsTmVxUnVpVjB3?=
 =?utf-8?B?eVlqd2lBbVVpNVZwRC84OHlFNjhRMUJ0MnFqZFZoc1Vnc2RpQk5uaFUvaXRH?=
 =?utf-8?B?RnpFUnBaOHpNQjErS1FBWXZ3djJyUk1FcmZVYjRuY09OWXJ2VDZtMnMrd0ow?=
 =?utf-8?B?bUpONk1wR2crb2JlNzZtRFllV0tLUGIrZ01QSy9ndUwzbnlNY2w1cDlCMFNE?=
 =?utf-8?B?cFhEUUZsckVIczJzbFZNVTVkMkk2TTJtSVlrejltc2Y4MDNLMXh0ZEFFcVY4?=
 =?utf-8?B?OSt2OWR5TFZ2eDJ5Z3FDRlBVY1RBZ1BUYWJiNzNtTFh5VGtuSWpjNHQ4RjEx?=
 =?utf-8?B?clYyOGlPLzY2dGlxcENPWUlKTVFWbU5GZExKWGludW1mNUVpMUl3VXJQODZk?=
 =?utf-8?B?NFY5QVZNZUZpbHltbncvaTRuL0xBYnRFcFBOeXVjdjUzMmgyNy8wM3JKNk5y?=
 =?utf-8?B?blh3Y0NwY2V6K00xNEdrR3liRkRzbUhObFYvNmpSWGl6Nkkwb2RYa0FjOWpI?=
 =?utf-8?B?TVNldkorVnl2YWw4RmVGcGNhQW9PbFlCZ0lxL3NGN3Rkc2V4cjdXaFh5REZ1?=
 =?utf-8?B?dzVkZFE2R1cyTmh6dDU4cHBrZVNXdVVHQmxnZHNoS2UyM3FsWXh6YS9DTEdN?=
 =?utf-8?B?eDAzRW9NWVVpMUZHN3RPM3pRc0pEeDU4OHNTWVVWUk16S0Y1VVVHb1hHQ3NM?=
 =?utf-8?Q?CVCxAM7JUmyTi4AuYyV+isU4x?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B648CA79D246044DB0136D91081E6FFA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4ea2b76-e7de-4f67-580d-08dd70a9680e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2025 23:11:45.4010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: doJN46CHdpQQIDDGHoNrVrc9w8TJacfJsRahk+V6mzO6uC6e4Jmw41SUi+2Cui/gdc5IeOamfRz1ZwuZgMSzgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4835
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTAzLTMxIGF0IDExOjI3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBVc2UgS1ZNJ3MgcHJlZmVycmVkIGt2bV94ODZfY2FsbCgpIHdyYXBwZXIgdG8gaW52
b2tlIHN0YXRpYyBjYWxscyByZWxhdGVkDQo+IHRvIG1pcnJvciBwYWdlIHRhYmxlcy4NCj4gDQo+
IE5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVkLg0KPiANCj4gRml4ZXM6IDc3YWM3MDc5ZTY2
ZCAoIktWTTogeDg2L3RkcF9tbXU6IFByb3BhZ2F0ZSBidWlsZGluZyBtaXJyb3IgcGFnZSB0YWJs
ZXMiKQ0KPiBGaXhlczogOTRmYWJhODk5OWI5ICgiS1ZNOiB4ODYvdGRwX21tdTogUHJvcGFnYXRl
IHRlYXJpbmcgZG93biBtaXJyb3IgcGFnZSB0YWJsZXMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFu
IENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEthaSBI
dWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg==

