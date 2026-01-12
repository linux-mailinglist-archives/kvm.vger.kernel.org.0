Return-Path: <kvm+bounces-67716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C3196D11B74
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 11:07:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5CAFA3059340
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 10:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1ED52868B4;
	Mon, 12 Jan 2026 10:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LkhKvl9g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC56D2777F3
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 10:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768212171; cv=fail; b=NbrJ0HJnAoJyfQV4PUx0zzeldCyV/4fkDI2g9gtgQm6QBgYvFApOfF8p2GlzyS57tHdNTIzhSfOnE40lLluf8NVViaTpXH2INeYAD9CY3MHynbW85z6DlPmIuaerIH6PttOLdiZv+g90lcR2ANaKu8HKb4q/x344PlcFlm5NIIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768212171; c=relaxed/simple;
	bh=TVPftMsiOgT0Lzqib8/AYxFzNc3jPACHyTxoGCVr6VE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HKgsT4Ki7P88YF5EU58+rF3Ckg4dicly5LKejLSMwpzZ1/qCGqbzEDKighHum/wfcNq0PLFvlC+gSPKTBAWc2Ajjl2GlDt9b/RA7emux+rNRV+OI5EHDAdE2wutPjEVscihJBYZJadJJNJqu0gJQCmM9Y6rpf1E7/UUuxecTKVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LkhKvl9g; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768212170; x=1799748170;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TVPftMsiOgT0Lzqib8/AYxFzNc3jPACHyTxoGCVr6VE=;
  b=LkhKvl9gJNp5MHR9MvKAutGzUvU1KRkiSHvPwlE00P8Y5drdgqLA/7pq
   iKjXllGdUaEj/mqmizYy/qQyODsIdE2d2KVt/XhfvnyOEeAa6L/orWriD
   adm0v4dmGywZ1Kk2OR/ovrXA7a6gzDHoCDIx+HzAV8ztOYUBnMjyFtYad
   9mn9fkMT4XDDc66SI4ggRrekNZB1+4I9zaheaKbiKIJMUPnJubQh9XtwQ
   /H6lN0I9Ts9qJnHbtu0ZKrtTWvN8HLmGvHlxMwaXfN7iNFdfkddkBkMmV
   5HCy9NeEg+Z6tM7yvYD0mpEdjp5hMUwGkTVPGThbHO1SHQg64h9W83Srw
   w==;
X-CSE-ConnectionGUID: YOUpn5VeR++jBrpyaiK8kg==
X-CSE-MsgGUID: WjrkLsW0RQWH5gUuKANfrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="73335297"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="73335297"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 02:02:49 -0800
X-CSE-ConnectionGUID: g76GW7mcRVaqTMrZ3wVqvA==
X-CSE-MsgGUID: G7dHirtyRYSiuHmVo455EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="204129577"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 02:02:49 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 02:02:48 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 02:02:48 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.68)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 02:02:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eoWfT/FuKdGQqc65yzt6DaBfCVs7eaT6yO3+FpTACjNgVfpjatXncWwANhRlAdi8gbLruVyvjT1w0XmzFfK05hRbdRz92YhwlKa9WQvwdicFUbLyhq8+hG4WliSDGu/XbjUQgG9Br9EybSYQFiaW6ccBtgZPMH/b6Ft9HgQmy5soF/vQ1KwHHK3CQ4VdanUd8DvHAISw5mLxAnzAuMjKEkGE2kdZ9IFWLVtuVA22JT4miYTdSz8a13A2nlbZ5pmgQRX7ApWV61Z3+q+3AkYJs7+Go15I4fddwC5f6R+EH/3kJWR1q8fEr3R9haSs6vptkeuW97uOhiLwSFLKiuTV4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TVPftMsiOgT0Lzqib8/AYxFzNc3jPACHyTxoGCVr6VE=;
 b=IrMzic7o4hhP7Uc4XrjEODjXdsf7CbHFW+FImG0EiAMq0aUk8xvP0BNr9sBigv5dsnGL2OIyg0psqher30B8IF38TMRoPY05ThJvbmGbJuuYrAaWuwbSuFURsggs22Tt0Dt1xXIOUyosudPAePc1vCayG423eIuEJULMWyFNp7m+Zd2ioH8MtOKcqZyQogBIRhtR5N0FVoKZ7YYr+0fjZL1pGaDDxjbFwMZyybJMvcIrGcEqWitMygoBnTxK+ZHN+20VUQWPNRuCH5cN1XPxYQ9gNcDFINnPsy6PR4f2gigT6b3keKrnRqMpPHhRUJIq5saLZKoDGSVrWLqNc4/eMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB7117.namprd11.prod.outlook.com (2603:10b6:510:217::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 10:02:46 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 10:02:46 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v5 1/8] KVM: x86: Carve out PML flush routine
Thread-Topic: [PATCH v5 1/8] KVM: x86: Carve out PML flush routine
Thread-Index: AQHcfg250LO8SkZVkUyK7ACs+Lg2w7VOWRSA
Date: Mon, 12 Jan 2026 10:02:45 +0000
Message-ID: <b62a329fafa824c7a1475dcdd81852ddcb269be8.camel@intel.com>
References: <20260105063622.894410-1-nikunj@amd.com>
	 <20260105063622.894410-2-nikunj@amd.com>
In-Reply-To: <20260105063622.894410-2-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB7117:EE_
x-ms-office365-filtering-correlation-id: b944e837-ec92-48f7-0a99-08de51c1bc2e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SlBVS2hubTMzN2RBNmQ3bUdHcUhuWE1vaU42VTVPMG55eU1tcHF1bGhwSEI3?=
 =?utf-8?B?dzZsc1R4Q0kzRjltSkQxemR4cXoyaDFETVNhY2dwQjFMd2xiNkJ5c2FuVDFJ?=
 =?utf-8?B?OUJ5RDVZOVVNbHNNSGlFdDdUYUdQa1pqcWF6OVhWZjRyayttY09IeFdoYWZa?=
 =?utf-8?B?QnJqTXJMRTR1VFgyL0swaEI1d1ZJQVFKYzRhTklvdlp0ejVNOW9IdG9PWnRr?=
 =?utf-8?B?NnVuQ3ErbkIxRU9GaUxrZTF5WUswdmtUU041MnRsNTBSRUFvbFN3V1E2cmZV?=
 =?utf-8?B?NVdET2FpSGdnS0k0Slg0czZtdXlWT3Bxa1htTUYvL2FrM3NiUnZSVlB1dnNs?=
 =?utf-8?B?WVh4WURMRzQ5Nis2S3NlZWM1cjdZWk5zVVdiRXFudmhjdXRuT2dsb3JvVVJY?=
 =?utf-8?B?aEZhMTg3cGpHNytQUm9GbzhvRkVXaGpteEFlcVA4SFBoMGZXM3EzWkorVzkr?=
 =?utf-8?B?RmRBNmd2NE92TDZIZWtiWC9GaWZBMHNsTWlkTXdUcVJjVlU5UHhETmR3QVVL?=
 =?utf-8?B?ODdvRkRBdUtEL2NIRG9mWXUrMWZaSzFYWDRleDErT2p3MDVmR0JRVEdsM2t6?=
 =?utf-8?B?NEZNb0NRZTFRM01uVGlxcTdRTnNJSCtBWllJaWdSWHFsREpsRGdIcTlhd3g2?=
 =?utf-8?B?NXVaeklMV1RYcEtRQ3d0aEVwVGd2L0JvQlJIZUt0RnlJWDlsYzdNS00rNDEx?=
 =?utf-8?B?MXYwckRUK0xvbC9ZS0FRcUt6WUwxOTV4eXQwVjdId04wKzQxZXlVVkNRbTZv?=
 =?utf-8?B?S1g1MU12NG1EOWtXL21McTlVSVpWaldKQnhEWWQ2MWwrR2FhWDNhUmRCc01P?=
 =?utf-8?B?NWVFOGZVSE5RbzVkYmNlNUxJa1hQUHFTWllHZHAvc3NaTDg5Y1JIMGxOMGFB?=
 =?utf-8?B?QTY5UTBUM21qVno0Wit1S1RFaWlvRy9BK0xDak1zeWlmclpHQWhLeG8vdXhq?=
 =?utf-8?B?RWRyMkRiN1Jxb0ZNU2lWZkxJOW5WOUxwTExKQUpqWVdXRHVNWFpIa3pKSG5s?=
 =?utf-8?B?aElwUUR1aUlaTXpiMjFJdUQ2QUZmNUlkMTJZV2FuMUx6RWhsU3J0MUx0MlN4?=
 =?utf-8?B?UUs0ZUdNNGNhaG0xSUxzWkJHUDB2eTJXRTYydDVabzZGWXU3UVpWaTNSd3Zr?=
 =?utf-8?B?b1N2dk5XOTBYUzFTVmNadzN0YkFnRmFaNEYyLzJ3TUZaSjJvZGF2N1ZDQlNF?=
 =?utf-8?B?RGh0Q1JNbGNOL29qNnR4NktKQWFnUTcyZU9udkNNTnZhaTdCeHZtOHYzWk1O?=
 =?utf-8?B?a2drTXRIWHZCL2dlb0ZDdWt3SXRHZGFKYURZanBuZkVTT3BQeHpFc05ySUQr?=
 =?utf-8?B?UVZsKzM3UTI4QTF0ZHFwWGp5SktTUi9oSWxrcFl1eGZ6NWdnSGRsaW5yUGJE?=
 =?utf-8?B?VzA4MXI4b0NDV2FZa1pOM1lPNUdJZzMwQkEvVFhRVXQ5R3RyRlk0M2xVMWhs?=
 =?utf-8?B?eHJlSXVGSkVxbnlhR2tWUFRwZ205VW5YdHRQdEd2b0dOckdhSUg2YUlCY3NI?=
 =?utf-8?B?czRseFE0VjdqNERlYmtnaWFsRzVjekQ1YWI4dFM4YjljUTY4U0dydnZhbTQ3?=
 =?utf-8?B?YURFWTdzUVRJZFY1QzRMQncyWVR6bU9vWm12Mm16Vm9GQ1RrNXhPRDFUU2RW?=
 =?utf-8?B?RDZRZG9McWtFWEMrM2p5US9hYlU5MGJNTjB0VFdqUStWUThqenE5akR5akds?=
 =?utf-8?B?NHdwVWFsenEvVkNxWEQ2WTJINkZYakNJd2V2QnNEbUNMZjJuTCtjcHFkYjFh?=
 =?utf-8?B?WDNrMXY2UGRCWWRBT0xsNTN5QU91Y2t6ampjWlFkbGNTc0hveW9IQ2JCOHd5?=
 =?utf-8?B?Y3RvVmZMWUlEOGFCR0lhWUNrZUxNVXdnU1cyUCtKWUVTaG9weW0rRThoa2xJ?=
 =?utf-8?B?b0c3RUJQOXJhV3U3aElBUXhBbk9qSEJNV3hDdnoyaDljRWg3Zk5xZzNiaDdm?=
 =?utf-8?B?eHFVckxKMjhwdE9meW5WOVoxNjZVb25BOFMraWN5NkgrY0gyU2ZtcFZWZTZU?=
 =?utf-8?B?emFNdVFUUW4vSnVuRG1LUDdxZTRqSTZHbWlPVFZFbzY5QitBREIyZXhHWU1y?=
 =?utf-8?Q?85sbza?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c05aeHJyZk5FSnRMeThjazZlbzNEK2Z5TjZjaTk4V25HYUMxb281V2J2MUZx?=
 =?utf-8?B?SmpaZHV3Q1V4QXJ0aEZBRHhkMC9kdUo5bVdIT1hpZkpCaCs0bE9KdWl5ZFhG?=
 =?utf-8?B?d01xVG5vVXRPcWlKT1NQV0FoTkdTQlNPZ2J5dit5aGRZdHRxTS9XVFc2TWdw?=
 =?utf-8?B?cUNXK3FoVFVsTXczOVYxUDdENUo2b1RPLzhCSng1YVVFNCtVTHJ0VUdFcnhG?=
 =?utf-8?B?SDFOcysxUTBoZFo0N3Y2eG5iSUFsUkRmWnBqTzN3aGpkUFdFaFE1K2ZJN0Ja?=
 =?utf-8?B?YVhhMmZkVC9iTzJWLzdIQ2xqbElVVkZ6cDdYdS9uTTVITmdPY0hQdm5xV2Vk?=
 =?utf-8?B?VEg5eGU2Tmt1b2p0Rk5FTjZQY21Pb1ZYbVk4R1RyOHU5TUVZTTMwQ3ZrNEdt?=
 =?utf-8?B?M0Y1OS9GbDZSWEFBSW9RaHRzVWRFWHVGVEdveWNHd213YUU3am80SXdheTZV?=
 =?utf-8?B?WnFHZEhESngwNW5YQzhSQXFaNmJ0WkpzVlB3Z0YvaFUwbGJWYjRJWXZNdXp4?=
 =?utf-8?B?VGxZa1NSY0s1ZXBLNFIwSWd1YjBsanhJaFFXWFhUUjF3d1k2L3UrV3ptdXFl?=
 =?utf-8?B?d0huSFBaUm5sMFBvc1B1Smo4eW5ZZnR1K1VrcjlNQXZXbXhSK1VKN2h6VHg3?=
 =?utf-8?B?UGdOWUlhZUVCSzdOencyM052ZVVEUHZhUEVjbHo5dTVvaGdyblVvQldnMlFJ?=
 =?utf-8?B?a2pUeXRUQ2x2UzdwYTRGcTd1M0l4bHRMa3k3Vm1TeWhTYkxiVnlId2ZSZ0ZR?=
 =?utf-8?B?aFlGajdoUGxKbFdHTEg5YXdzcEVMckM2S3YrQU9oRG1ySzIxakx3U3ltRmVx?=
 =?utf-8?B?M3JHRUg0QUJkYTNxUWFDQTM5eUppVEdDdjdpTEJSQWc4VUdqUTl4TnJtaWRC?=
 =?utf-8?B?c0liWGhEUmNab29KRVFOZGIwVnhqMy9obkViMjloQUFVODQwZmgxVVVlS29N?=
 =?utf-8?B?NFpWNlFkUGVObElHUDdZdVVOMmhpN2pHeG9JVWkzS1c2R0NUYXRrOW9rYS9q?=
 =?utf-8?B?SUFhY0pWdXY4YUEwYWFid2kyS1RkcFRoTGpuZDliZ09tNHU3N0g2QVFuNE9Q?=
 =?utf-8?B?eFY5Y3VJZm11cnhXUkFMQ3gvSjB4ZXQxM2tod0daK2IycTIwZGw4ZHNPVGdR?=
 =?utf-8?B?eHNKTjFDWldTL1NhYkhHcExpcGlpRjlqVHNORGtmR29VZGVvV3JKczVsVmZD?=
 =?utf-8?B?VE5aU01iOGNkLzZLR21SenFpV0hISURWN0hGUmNXZWM0enRuRkIvSmt5WE1W?=
 =?utf-8?B?UitxdWx3T3hOMW5Xd3FFa0QvV1JkU01NeFEwU2hwUm0zdndCc0RNcWlCRndI?=
 =?utf-8?B?YW8vTGZ6T0liVERMMTBadnVnSDlIRU9zRmErK3BweWgvTWJnN0pxN3lESnZj?=
 =?utf-8?B?ZG1rODFqcU1sQjBPMC8rbzBOaVRFVHFUQ2pzSEt6N3pIR2VPcnYycG5BMG5s?=
 =?utf-8?B?bGhMVnNpZnZ2Y2dtM2Fock9iYnZzM3VhZjlPU21ZUkNKclB2eS9DQ1E5MG9B?=
 =?utf-8?B?R3JnTElpUldSQnFCR09EWXVUY0VpbVlOL1VEeUZJU1JLR0NCOTVwb1VyQXBk?=
 =?utf-8?B?eVFsdnZJZzdjNEw0WXpOUUlyV3BrQ0Q1Zk1tdk9DT3MwQVhibm1EMDZ1V0p5?=
 =?utf-8?B?MjBLUitOdGovbnQxWW1kTmZoRWhseHlERUpUMUZXNEFrMk43MHowTXVrR0Y4?=
 =?utf-8?B?aVFOYnNTOXZHUjlrZmU0MG1yUWFtaldPMloxalczcmUrN3pNQzU4MVRVdzFL?=
 =?utf-8?B?WU5pVktzQXc2b0JSL2VEWm5YVTBYZVpzN2VBUVpPRkpHZUxtTkFFWkx2eVo0?=
 =?utf-8?B?OWdXNWRBVXhsOXhWNVZ1QUdMdmFNZGpKWUt3WEtYTUFWQldleHNicndUT0FB?=
 =?utf-8?B?T2dEdmVBOUxLYjlickw2MURVWmNBT3g3WlptZ2hBK21xTTZzVitpWnN4TG91?=
 =?utf-8?B?aHNYTnhvZUFTcnBaZXJFR3VpZlZSd1pMVGtxd2Q2UFc5YjVjMk5LYld6Qi8y?=
 =?utf-8?B?RFB5c1pzRW9rYjJ1VFdjN1d3amQvVTNURXRRbmk4LytpeFJLZDhKbWxZNXJX?=
 =?utf-8?B?L29YblplbDd5OU9zZDZXNUF4NGV6Rk5EaHdqTjgwYWVNSlNGSTYxZytFaXEw?=
 =?utf-8?B?WnhUY3FuWVZua0JLTlg3anBGcmNRR1cwZ29lSGZrV3VxRklCUkVnMWxCOUwz?=
 =?utf-8?B?Nmt0S1VqQ2wwNmMxeFFXRGFPODB3MDduWDZGalEvM2R1RjluTnBmSVBPVmdt?=
 =?utf-8?B?NE11bnIxcnNMYTJuYXduYVlFYlJxWmVzUS9XZ2YyYm1HclNPeTdyNkh1NkRM?=
 =?utf-8?B?VWx5ZTFOU1hJZVRlbDV2bUN0dng2MWJRNVZNV2Y1blpGRFF3NDdjUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E9C70BBFD02CC4DB3DCE387C2898087@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b944e837-ec92-48f7-0a99-08de51c1bc2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2026 10:02:46.0472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hk0xAmUA9OsR6s/s2c0OYgxNP7iWxw8xwQmkG6sx0LzHLB/gXY+zQsm4TBAsdMxA3eQY7d9plw68T9waLmRYiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7117
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI2LTAxLTA1IGF0IDA2OjM2ICswMDAwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gTW92ZSB0aGUgUE1MIChQYWdlIE1vZGlmaWNhdGlvbiBMb2dnaW5nKSBidWZmZXIgZmx1
c2hpbmcgbG9naWMgZnJvbQ0KPiBWTVgtc3BlY2lmaWMgY29kZSB0byBjb21tb24geDg2IEtWTSBj
b2RlIHRvIGVuYWJsZSByZXVzZSBieSBTVk0gYW5kIGF2b2lkDQo+IGNvZGUgZHVwbGljYXRpb24u
DQo+IA0KPiBUaGUgQU1EIFNWTSBQTUwgaW1wbGVtZW50YXRpb25zIHNoYXJlIHRoZSBzYW1lIGJl
aGF2aW9yIGFzIFZNWCBQTUw6DQo+ICAxKSBUaGUgUE1MIGJ1ZmZlciBpcyBhIDRLIHBhZ2Ugd2l0
aCA1MTIgZW50cmllcw0KPiAgMikgSGFyZHdhcmUgcmVjb3JkcyBkaXJ0eSBHUEFzIGluIHJldmVy
c2Ugb3JkZXIgKGZyb20gaW5kZXggNTExIHRvIDApDQo+ICAzKSBIYXJkd2FyZSBjbGVhcnMgYml0
cyAxMTowIHdoZW4gcmVjb3JkaW5nIEdQQXMNCj4gDQo+IFRoZSBQTUwgY29uc3RhbnRzIChQTUxf
TE9HX05SX0VOVFJJRVMgYW5kIFBNTF9IRUFEX0lOREVYKSBhcmUgbW92ZWQgZnJvbQ0KPiB2bXgu
aCB0byB4ODYuaCB0byBtYWtlIHRoZW0gYXZhaWxhYmxlIHRvIGJvdGggVk1YIGFuZCBTVk0uDQoN
Ck5pdDoNCg0KSWYgYSBuZXcgdmVyc2lvbiBpcyBuZWVkZWQsIHlvdSBjYW4gdXNlIGltcGVyYXRp
dmUgbW9kZSBmb3IgdGhlIGFib3ZlDQpwYXJhZ3JhcGg6DQoNCiAgTW92ZSBQTUwgY29uc3RhbnRz
ICguLi4pIGZyb20gdm14LmggdG8geDg2LmggdG8gLi4uDQoNCk9yIElNSE8geW91IGNhbiBqdXN0
IHJlbW92ZSB0aGlzIHBhcmFncmFwaCwgYmVjYXVzZSB0aGUgbmV3DQprdm1fZmx1c2hfcG1sX2J1
ZmZlcigpIGluIHg4Ni5jIHVzZXMgYm90aCBQTUwgY29uc3RhbnRzIHNvIHRoZSBtb3ZlIGlzDQpp
bXBsaWVkIGFjdHVhbGx5Lg0KDQo+IA0KPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZCBm
b3IgVk1YLCBleGNlcHQgdG9uZSBkb3duIHRoZSBXQVJOX09OKCkgdG8NCj4gV0FSTl9PTl9PTkNF
KCkgZm9yIHRoZSBwYWdlIGFsaWdubWVudCBjaGVjay4gSWYgaGFyZHdhcmUgZXhoaWJpdHMgdGhp
cw0KPiBiZWhhdmlvciBvbmNlLCBpdCdzIGxpa2VseSB0byBvY2N1ciByZXBlYXRlZGx5LCBzbyB1
c2UgV0FSTl9PTl9PTkNFKCkgdG8NCj4gYXZvaWQgbG9nIGZsb29kaW5nIHdoaWxlIHN0aWxsIGNh
cHR1cmluZyB0aGUgdW5leHBlY3RlZCBjb25kaXRpb24uDQo+IA0KPiBUaGUgcmVmYWN0b3Jpbmcg
cHJlcGFyZXMgZm9yIFNWTSB0byBsZXZlcmFnZSB0aGUgc2FtZSBQTUwgZmx1c2hpbmcNCj4gaW1w
bGVtZW50YXRpb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBOaWt1bmogQSBEYWRoYW5pYSA8bmlr
dW5qQGFtZC5jb20+DQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5j
b20+DQo=

