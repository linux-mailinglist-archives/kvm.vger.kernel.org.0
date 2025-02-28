Return-Path: <kvm+bounces-39724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A44BA49929
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 13:26:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 217257A9DA7
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 12:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00F5726AABA;
	Fri, 28 Feb 2025 12:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hE8TzneN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C9E26AA83;
	Fri, 28 Feb 2025 12:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740745563; cv=fail; b=UWo1Vx5RJZbFvCEDtj9vig81E5zBTWs2kRnOGQ3UKm7NZb9Q4CnZLw+4X63Y7agYRPJD2G8QAEemtz5ePE0/V22O1wBqexVukKj9aXukK3WPV9VJqMzFVAi1sz9MtnDAvpAnXTrlXkxJ98+PmJCET7bqmQ7FqOnzILHth6hcJ9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740745563; c=relaxed/simple;
	bh=IsSklzm6oBMMAV+asAnLo7JOb4nwc84Mc7zaWvxy+4Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bVOqAVczifXmwpV1fAymwA6ea5C73s6YSwphMpZfYbCKHQIYOtv26PALHXocyTAuykq2bWdrbzbOubD2EhsUeGL6Me10B1R3BhlGThfN+UMGEj7j57OCRXTwTa+lNvK2RGCo/eRb/2btuveDOHWEYIyGb+EIsMSgi6H1pq4vK3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hE8TzneN; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740745561; x=1772281561;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IsSklzm6oBMMAV+asAnLo7JOb4nwc84Mc7zaWvxy+4Q=;
  b=hE8TzneN2SPdDxAitn++fIvQAKknRpghc/k0DFs37kQVItCqZlMHmmBf
   /t9RIqtiKWv6HGzcJeHMfo7mdZ9pEtKBdeGJE5QljsZ2+dlIa5Di4UGl/
   NWRZHG0GNnqAy1PS4h2ApIbSgxzGm2Rw0EcTj5V8UpYyMoikq6os6j7ai
   vu83xG6JPBT6bYfMc843oC5c1vL58yDiOmt+NOw3q/VB3O2ga5l4mC0x9
   Oj2jBEBjIIiHZau1cYjHjiV46v/Xc3VkWggce2JLdR/ocPyuFZNx2gPOQ
   nHf1mvtXKZYNXxaQtBgYvz3EN3UJ4sfL1B5AejWUTLCzbx17XgFYvmKRP
   Q==;
X-CSE-ConnectionGUID: Nz7SzgdaRHGsVeBJDjepIQ==
X-CSE-MsgGUID: weoTXKUjTXG1U9BGGwwzhA==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="41699205"
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="41699205"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 04:26:00 -0800
X-CSE-ConnectionGUID: vWZ+eT5uTbykN9GL7uUMPQ==
X-CSE-MsgGUID: 376Hze2+TKuOURWBOt1+hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="121448691"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 04:25:59 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 28 Feb 2025 04:25:59 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 28 Feb 2025 04:25:59 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 28 Feb 2025 04:25:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vzBE3kTGv8aKZYp1zXe2CAhkcq7eIxJEJYGjKMFEOKuiVP7CXMdRmoe+0rjt2ybivHrg3yKEFfc8FYY8BBkLVQ6dOpX0gQZhTGx+ltw/Yq7zhW3hZDE5vLplV5FXGvIdCog3TiSlLP+SEGZUqom5z66FN/qJm46IkpP9weetlk7eFC8UdrZVpLg9eClNKvebXXFcH9r+LTD+aoXWnumiElSNaqGC375ZBjWH54GlHqH4HAv5pbrGUWqc39fZ2GZ/F/ozlvRtBVkwFrIjNBF/yaez27jSVbebyCplEp0YApuL3X4ne7n4jr0OGoY5Mc2o85ZD6EEBpPif2vBKMCpl7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IsSklzm6oBMMAV+asAnLo7JOb4nwc84Mc7zaWvxy+4Q=;
 b=Qz8XXJlV0f+FxkPQoxXS2p7jGtqP6RyEKm9QHIdL3TlQ3VkDmuhFdRpXDaNmgI0zubY8LDrSLNg87KHoM0thjzkO9Mwx0OfsY9g46lTL6D0hyNQAaQsq8R6vs0XrSPN9/UG5CZWI7Se+IKHgPrfOUJvWIGK2+9+p3sNMxjKmlAnAdcT876BMPoHefMNS/TXoFoNDvu6eLdjA0YU2ZWnItgvhqoiHuB6xiTOyE1LLRfsYSh74TrHNve8r8wgQSqhz+Ux4wXpwG1Sw25qt79o0xaj3ULrQDJyZBWLVJiSsR1CXl1CGH4vD1Tt5MFfUNxWTTWi0FMB12I3xnbNmcwvprg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5815.namprd11.prod.outlook.com (2603:10b6:a03:426::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.17; Fri, 28 Feb
 2025 12:25:29 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 12:25:29 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "zijie.wei@linux.alibaba.com"
	<zijie.wei@linux.alibaba.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "xuyun_xy.xy@linux.alibaba.com" <xuyun_xy.xy@linux.alibaba.com>
Subject: Re: [PATCH v3] KVM: x86: ioapic: Optimize EOI handling to reduce
 unnecessary VM exits
Thread-Topic: [PATCH v3] KVM: x86: ioapic: Optimize EOI handling to reduce
 unnecessary VM exits
Thread-Index: AQHbiYak+KeCpJN/mU+vMCOndQrxaLNcpKKA
Date: Fri, 28 Feb 2025 12:25:29 +0000
Message-ID: <9553f84e3a4533278e06938a4693991cf23cdfc3.camel@intel.com>
References: <20241121065039.183716-1-zijie.wei@linux.alibaba.com>
	 <20250228021500.516834-1-zijie.wei@linux.alibaba.com>
In-Reply-To: <20250228021500.516834-1-zijie.wei@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5815:EE_
x-ms-office365-filtering-correlation-id: 6a7e340c-808a-4e2f-2b9a-08dd57f2fcfa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?OWJMQnFxeU9FSEpYUlhoVTU5S3FITm5WLzRSeWlMcEs4WW15ZWFsV3dlQWNT?=
 =?utf-8?B?T1ZlUDhvczZ1U0hlV3FSeUFFNW80V1hiK2RkUWxLWWNzdDVDK2Y3aWgySlpD?=
 =?utf-8?B?TFFPMUFSU3o3aGxUS3pjaE1NOVRDQWZVT0hZdkJCbDVhMW41QjJmNzNGdVNa?=
 =?utf-8?B?ZlpZYmZ2WUpPQ3h6a08rTEs0LzEzMWFpVGp5c3RDeW5XR0I4SUVoNk9QMlZJ?=
 =?utf-8?B?YkdWZ09hNDg3dXM0MzQ1MVVJV2Fxd3E3WlRTb0JSMWFFTGdISWdnRGMvNGlk?=
 =?utf-8?B?cUNpZzhMa3k2ZkIycWsrY1JaQkpwTWJLZ0EyV3RQbmtwTHNNS0pjdEhubjNH?=
 =?utf-8?B?Q3MzN0F0L3I4SFF6d1FwRmhUMWt5aXhDci83TnN0MFRQQmx1a1NwTGhqM2RE?=
 =?utf-8?B?RnBTSGtxckpsdmt0eGNJVlJSaVY0RG0yNXdzOGw2RTR0UVYxdURPWFVwclhw?=
 =?utf-8?B?WmhLUk5qV1M0UFQ3ZUQ5TUN5M1pZR09lWVN6azUrMkNuY2lhMnllUTNDdUdW?=
 =?utf-8?B?TWYvQVQ1UVpwVlRhM2RFVmJUTUdnZ0JMQ1l1b3V4NVBnZGFyRkZJWUlyWGsw?=
 =?utf-8?B?NFQrWnN5b3NEQ2htQ0RvWC9KUSt1Ry96RnVkQkM1Sm42eHN4NDlTV3B5dkR4?=
 =?utf-8?B?cEJOOHZOM1VDRmJjc2RpdjF3WU9sSVpxL0R2MWhBT2ZONzZmMlVaTTdUV1ZZ?=
 =?utf-8?B?VzJ0VStJVXExUVM5SHE1S0txWXlHSVdVc3kwYTloS3AxS1NZeFZUZlloclYz?=
 =?utf-8?B?UTdkSWRuNEM2TVdpZUJ3NEZFTnlabFE4M2t2Z1pVcE95WGpzc1RsNjZvdWpV?=
 =?utf-8?B?b2RrWVBGWmVNSHYvY0piUm5CUy8xRFpIVklTc3NGQTdhNFh6SnlTckFhSFBR?=
 =?utf-8?B?bFNLVW1nY1p1WkpQb2dOK1h1U0pIZ1FQcmU5NmFPNG9kQlVuci9jNVo4bVkz?=
 =?utf-8?B?UFBOVEpmc1NGcThQd3M2SVdqekpueCsrVTFENjJTODlITzVySUowWjA2L2lJ?=
 =?utf-8?B?K0NMczBLakY1czNVNTZ0Tmh4ejhxUEx0MnR2UTZGYkRvSkRSTjB3N0dkOTJY?=
 =?utf-8?B?Z0J3YlN2a01yZHF1akxRZG9FYWorVVA5TXlFa21VYVdrS3I3ZUVaMGN0VUJC?=
 =?utf-8?B?RFlYc0tkVmFiY0pHZlBKSzNveS9jU3cyZXR6cDR1aHJGdVBNdWVSQmJZQzJU?=
 =?utf-8?B?YXZBa0Y1VzR1Vkt2M2NVb1dOUnd0RkJlR0kwd0VtUWtSTXVxcGZOODhKZ01E?=
 =?utf-8?B?TVpIYjhPaUlYY3hGNHF6OHJRZEgwNEhrRlR5RHFsSzNYYTF2Y1BRcEFINHlx?=
 =?utf-8?B?bDFoMWxCSmg0ZHAxZ1JRWU0rQkdPWHJwdVFYOVlJdTRRc3ZxY2N4UUR5VHgy?=
 =?utf-8?B?alorUXQzRVlaMlhZeWJybHkxN0ppUXI5aFMrbFlBNFZzUFlxUmxhTnI5WlNH?=
 =?utf-8?B?R3d4VGMxeDFLM1FsSTZZNG8vbDBYR1A3TjBtRHUxRlcyU2VSbFlnQ0R6amVY?=
 =?utf-8?B?UXk2UjJvVS9GNE5MS3dPOE01RW16TUJmVG5aQy9qZittdkZlMHVkeGt6amZM?=
 =?utf-8?B?OEpRejBiQU8xbTBwVThhcWZxeEN1ejdOWmtNMFJuWVZiNmhieW5rMEwrYTZM?=
 =?utf-8?B?UVMzZTdDTXEzakplNWR3OC9hVWIrc3cwdlc2MzQ2bGMvK2JlZjZUVXFiazBM?=
 =?utf-8?B?aXVRWUZCbUR2VjRzeTZqcTAvTWpGREtwd0ZvYWc0anFTZ0lwNUhqekoyUm16?=
 =?utf-8?B?OEpUcUV3U01VS3U4TmI5Qnl4amtvV1hpWEZaUmtOU01nMzBMcS9BaUI5UVdD?=
 =?utf-8?B?cjJNbWxhRzNnbW1xVTBTSCsrYTR0MnY0QlAyUnhxNTVUaFFocVpvQXlyTWI4?=
 =?utf-8?B?WlNPYndpem9qY1hEeVE1MXhkNEFFclRwcVl1emhGNDJEbC9XS3p2Vlc5NUpW?=
 =?utf-8?B?RGJqeEFGeWR2RTdTeU41K3hxaWwwdDhpK1gwM2JDQVM2OHdXK2V0YVZjT2Zl?=
 =?utf-8?B?RENHL1hBN1B3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SHFQcUZYNXE4a1ZUNlg0RWVhTjFkTDhKMVVVQysveUhKYkRQMjZRL0lPaXVE?=
 =?utf-8?B?M1R3UnpWU0o3L3NPVDR5c2F4SGlTY0NpZUhsNVNXV0VrQkFsZWM5RHo3QjVw?=
 =?utf-8?B?MzdYbjQyNHdydlFQalA4dTlHaG1iWWZtb01aZDQzdHcxTWlzQ0ZYN3pVUkNh?=
 =?utf-8?B?RE1Wbkh5Rlh3cUlxVG93THdJUDgyakdFUjErV09SN1JnMjc4ODZtNy9pZXFE?=
 =?utf-8?B?S3lkaWk1WklTRlY5QTFBRm5lNHYxYkkwcnhWVzVDNS9KZlUvS2NpcVBuS0tq?=
 =?utf-8?B?VmlQdm03eUN1WkU0UlcrKzFUdzlNK0tKUzAwNk5wclF6WmlvTjg1c0xIdHBH?=
 =?utf-8?B?bW13ckc3a1J2RFJjS0FmY3N3OUp3YitoTzZCTVMrRzJ6K2hGUW4vY0thSFRI?=
 =?utf-8?B?MytOc1ZSNzZ3THJjcjRNM2EvQUdLSmdubUZIQzFHU2RIb3B0VlJJTG0yd0Vm?=
 =?utf-8?B?cUk3MUV1L2JxVi80UG0wWmE3YTRyOUM3ajZNa2hSYlY0SGtSVzZkRTNYTzVN?=
 =?utf-8?B?SVQ5R1lqOENuMzh3cDBFdFh6d0M3eWtaVXN6Q3hJYlplNHU4TDlLRGZEMWpJ?=
 =?utf-8?B?enBObHFYTUFsVkpBUmc3R3pqL2hia3B3clNlV0Q2RmczUVZGQTNLOG1DaC9I?=
 =?utf-8?B?ZVVYZnpjNzk1L3NtWjRXeDFwYVZkQVpTckFQcmh2Y2VSZXFiaWVwOWl6SS9w?=
 =?utf-8?B?cHJTMGtiZWZYelQxR3czVFlDY0VxZDd0ZE0wL01ieHFJaWNkZHAvSzM2QjdJ?=
 =?utf-8?B?K0pHR2ZlNTExaHdYZ3h4UVUvUFBDZGd2Y21iUFc0YUtEbW9IZFdWSjlOTnA0?=
 =?utf-8?B?UzA4QVFJY2hTbTdCUHVUUTNwbEoxNlluT0l5UmxRVDIzYVArQWI0ZWRxR3I0?=
 =?utf-8?B?blM4U0hrS2pnQUs5QzZVTTVXK0IwZjJXd3RNd1hRcFVBUmJycXV5bWVPckYv?=
 =?utf-8?B?VG9PT1BkRFREOFNuVXFKZ21NNXNENHViUWtSVEoxcUVHdXhnOUFkdDJ1L2dV?=
 =?utf-8?B?RmhFS1VhbytodXZyL2NYcUhORXZSMGN2WUQvZXRFaTBZQ3dieE8wa2RWcFAx?=
 =?utf-8?B?WC8vVDcxY3Iya0JGYTVxWWtHWE14WUYxMWQ1cmpWbDJxTzhxNE5YejZ4MFB1?=
 =?utf-8?B?SndVSG9vbUowemJsUk9zS0NhOHgzbCsxNW1Pc0d5WXNoa01BRXdRZmlqUzgv?=
 =?utf-8?B?WjZJbGN2THMyc21JNlIzbWpyZHBjTTVHUXIrWU50QTBLOWg1bGlFY2p6dzVn?=
 =?utf-8?B?dGpyWWNvWXhoQis2QW5GcjdsUDlJR2gxcUFVbEFlcHJoUnR6T1hZY3BmTWpn?=
 =?utf-8?B?S1plZmtXVlExUTcybXBkeWR6REw5amY5R3pYdEU4UGZ4NnBTeUhNZjFaYVA2?=
 =?utf-8?B?VjlFSzV6bU9oNEhRanFjcTlIREx4WkFzQ1FrUi9yODhac1hsemx4L3JhY01l?=
 =?utf-8?B?TlRFWWNsdncvc01qR2dWdnByS3kwV214WjhmN0xtL1BGUUZ6c3BzVWVYOVA4?=
 =?utf-8?B?aEkxUTdqRDRaS0l4NGJBNW5LT1hiN1NuTUQvRm9MSDFPbVZaVHRQaDRvV0Y3?=
 =?utf-8?B?TDN0R2IyVmMxTmhoQmZVUEsrdTFrak1GeUw2RzNNZTFTODdIRmZ5aWFSaUxw?=
 =?utf-8?B?TjFiVXdWQ21PQXUrL1Q5eXU0OFNSR2hsZ3BHU2VYTlFrbmkyVjgweTg0OGlR?=
 =?utf-8?B?VTk0QStJaFF6MVpqMHpaaEd2amF5ZGgzU0lZa3B0N0piT0gxcEJxWUs0eVdC?=
 =?utf-8?B?ZzRZcjdMM1V3eHZoYVhxVHBwS1pkam1wN2Ntcm5hWU9XN0Y2UUloNkVlVElO?=
 =?utf-8?B?c0tWOVo5UDdpNUYxOENsRkpzOXkxbC9oRGJSYnJVTXpOU3p4eG4xVDRqOFZm?=
 =?utf-8?B?c3E1WFltWHBKdnNoVGR5OUNURW45RWFsZmZZSktjclZkMG5qWGt2R0pHc3ZJ?=
 =?utf-8?B?VzVYbHZyYlp6OVV5aUttQmVFdlVRbk5reXg3dzU0NnM4RmY0K1htYW9uRzU3?=
 =?utf-8?B?NmhKUmdNd2Q2b0NIUWFUaDE2eklMakFOcElDK0tLcUE3QjJqVzczaXZETDhH?=
 =?utf-8?B?bjNYd3JueVNDai9SMUNqeWt0blgwaTBrSzBqYmJpWURzTCtrVTdiVVpSRVNt?=
 =?utf-8?Q?A5OR9Yg4V3jsWiLejpdLA9Z/J?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C43B7A17005EA4291AAB972D9BE20B2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7e340c-808a-4e2f-2b9a-08dd57f2fcfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2025 12:25:29.3829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zPu4hD6t+75FzU8ZScRNmH81HYrSs3q2mDDCTlIRWqMp4qFJNT3ry5DHWsio7GjLjPpzRXxXGPTL2tDYRfdl0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5815
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTAyLTI4IGF0IDEwOjE1ICswODAwLCB3ZWl6aWppZSB3cm90ZToNCj4gQWRk
cmVzcyBwZXJmb3JtYW5jZSBpc3N1ZXMgY2F1c2VkIGJ5IGEgdmVjdG9yIGJlaW5nIHJldXNlZCBi
eSBhDQo+IG5vbi1JT0FQSUMgc291cmNlLg0KDQpJIHNhdyB5b3VyIHJlcGx5IGluIHYyLiAgVGhh
bmtzLg0KDQpTb21lIG1pbm9yIGNvbW1lbnRzIGJlbG93LCB3aGljaCBtYXkgYmUganVzdCBuaXRz
IGZvciBTZWFuL1Bhb2xvLCBzbyBmZWVsIGZyZWUNCnRvIGFkZDoNCg0KUmV2aWV3ZWQtYnk6IEth
aSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0KPiANCj4gQ29tbWl0IDBmYzVhMzZkZDZi
Mw0KPiAoIktWTTogeDg2OiBpb2FwaWM6IEZpeCBsZXZlbC10cmlnZ2VyZWQgRU9JIGFuZCBJT0FQ
SUMgcmVjb25maWd1cmUgcmFjZSIpDQo+IGFkZHJlc3NlZCB0aGUgaXNzdWVzIHJlbGF0ZWQgdG8g
RU9JIGFuZCBJT0FQSUMgcmVjb25maWd1cmF0aW9uIHJhY2VzLg0KPiBIb3dldmVyLCBpdCBoYXMg
aW50cm9kdWNlZCBzb21lIHBlcmZvcm1hbmNlIGNvbmNlcm5zOg0KPiANCj4gQ29uZmlndXJpbmcg
SU9BUElDIGludGVycnVwdHMgd2hpbGUgYW4gaW50ZXJydXB0IHJlcXVlc3QgKElSUSkgaXMNCj4g
YWxyZWFkeSBpbiBzZXJ2aWNlIGNhbiB1bmludGVudGlvbmFsbHkgdHJpZ2dlciBhIFZNIGV4aXQg
Zm9yIG90aGVyDQo+IGludGVycnVwdHMgdGhhdCBub3JtYWxseSBkbyBub3QgcmVxdWlyZSBvbmUs
IGR1ZSB0byB0aGUgc2V0dGluZ3Mgb2YNCj4gYGlvYXBpY19oYW5kbGVkX3ZlY3RvcnNgLiBJZiB0
aGUgSU9BUElDIGlzIG5vdCByZWNvbmZpZ3VyZWQgZHVyaW5nDQo+IHJ1bnRpbWUsIHRoaXMgaXNz
dWUgcGVyc2lzdHMsIGNvbnRpbnVpbmcgdG8gYWR2ZXJzZWx5IGFmZmVjdA0KPiBwZXJmb3JtYW5j
ZS4NCg0KDQpTbyBpbiBzaG9ydDoNCg0KICBUaGUgInJhcmUgY2FzZSIgbWVudGlvbmVkIGluIGRi
MmJkY2JiYmQzMiBhbmQgMGZjNWEzNmRkNmIzIGlzIGFjdHVhbGx5wqANCiAgbm90IHRoYXQgcmFy
ZSBhbmQgY2FuIGFjdHVhbGx5IGhhcHBlbiBpbiB0aGUgZ29vZCBiZWhhdmVkIGd1ZXN0Lg0KDQpU
aGUgYWJvdmUgY29tbWl0IG1lc3NhZ2UgaXNuJ3QgdmVyeSBjbGVhciB0byBtZSwgdGhvdWdoLiAg
SG93IGFib3V0IGJlbG93Pw0KDQpDb25maWd1cmluZyBJT0FQSUMgcm91dGVkIGludGVycnVwdHMg
dHJpZ2dlcnMgS1ZNIHRvIHJlc2NhbiBhbGwgdkNQVSdzDQppb2FwaWNfaGFuZGxlZF92ZWN0b3Jz
IHdoaWNoIGlzIHVzZWQgdG8gY29udHJvbCB3aGljaCB2ZWN0b3JzIG5lZWQgdG8gdHJpZ2dlcg0K
RU9JLWluZHVjZWQgVk1FWElUcy4gIElmIGFueSBpbnRlcnJ1cHQgaXMgYWxyZWFkeSBpbiBzZXJ2
aWNlIG9uIHNvbWUgdkNQVSB1c2luZw0Kc29tZSB2ZWN0b3Igd2hlbiB0aGUgSU9BUElDIGlzIGJl
aW5nIHJlc2Nhbm5lZCwgdGhlIHZlY3RvciBpcyBzZXQgdG8gdkNQVSdzDQppb2FwaWNfaGFuZGxl
ZF92ZWN0b3JzLiAgSWYgdGhlIHZlY3RvciBpcyB0aGVuIHJldXNlZCBieSBvdGhlciBpbnRlcnJ1
cHRzLCBlYWNoDQpvZiB0aGVtIHdpbGwgY2F1c2UgYSBWTUVYSVQgZXZlbiBpdCBpcyB1bm5lY2Vz
c2FyeS4gIFcvbyBmdXJ0aGVyIElPQVBJQyByZXNjYW4sDQp0aGUgdmVjdG9yIHJlbWFpbnMgc2V0
LCBhbmQgdGhpcyBpc3N1ZSBwZXJzaXN0cywgaW1wYWN0aW5nIGd1ZXN0J3MgaW50ZXJydXB0DQpw
ZXJmb3JtYW5jZS4NCg0KQm90aCBjb21taXQNCg0KICBkYjJiZGNiYmJkMzIgKEtWTTogeDg2OiBm
aXggZWRnZSBFT0kgYW5kIElPQVBJQyByZWNvbmZpZyByYWNlKQ0KDQphbmQgY29tbWl0DQoNCiAg
MGZjNWEzNmRkNmIzIChLVk06IHg4NjogaW9hcGljOiBGaXggbGV2ZWwtdHJpZ2dlcmVkIEVPSSBh
bmQgSU9BUElDIHJlY29uZmlndXJlDQpyYWNlKQ0KDQptZW50aW9uZWQgdGhpcyBpc3N1ZSwgYnV0
IGl0IHdhcyBjb25zaWRlcmVkIGFzICJyYXJlIiB0aHVzIHdhcyBub3QgYWRkcmVzc2VkLiANCkhv
d2V2ZXIgaW4gcmVhbCBlbnZpcm9ubWVudCB0aGlzIGlzc3VlIGNhbiBhY3R1YWxseSBoYXBwZW4g
aW4gYSB3ZWxsLWJlaGF2ZWQNCmd1ZXN0Lg0KDQo+IA0KPiBTaW1wbGUgRml4IFByb3Bvc2FsOg0K
PiBBIHN0cmFpZ2h0Zm9yd2FyZCBzb2x1dGlvbiBpcyB0byByZWNvcmQgaGlnaGVzdCBpbi1zZXJ2
aWNlIElSUSB0aGF0DQo+IGlzIHBlbmRpbmcgYXQgdGhlIHRpbWUgb2YgdGhlIGxhc3Qgc2Nhbi4g
VGhlbiwgdXBvbiB0aGUgbmV4dCBndWVzdA0KPiBleGl0LCBkbyBhIGZ1bGwgS1ZNX1JFUV9TQ0FO
X0lPQVBJQy4gVGhpcyBlbnN1cmVzIHRoYXQgYSByZS1zY2FuIG9mDQo+IHRoZSBpb2FwaWMgb2Nj
dXJzIG9ubHkgd2hlbiB0aGUgcmVjb3JkZWQgdmVjdG9yIGlzIEVPSSdkLCBhbmQNCj4gc3Vic2Vx
dWVudGx5LCB0aGUgZXh0cmEgYml0IGluIHRoZSBlb2lfZXhpdF9iaXRtYXAgYXJlIGNsZWFyZWQs
DQoJCQkgIF4NCgkJCSAgYml0cw0KDQo+IGF2b2lkaW5nIHVubmVjZXNzYXJ5IFZNIGV4aXRzLg0K
PiANCj4gQ28tZGV2ZWxvcGVkLWJ5OiB4dXl1biA8eHV5dW5feHkueHlAbGludXguYWxpYmFiYS5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IHh1eXVuIDx4dXl1bl94eS54eUBsaW51eC5hbGliYWJhLmNv
bT4NCj4gU2lnbmVkLW9mZi1ieTogd2VpemlqaWUgPHppamllLndlaUBsaW51eC5hbGliYWJhLmNv
bT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIHwgIDEgKw0KPiAg
YXJjaC94ODYva3ZtL2lvYXBpYy5jICAgICAgICAgICB8IDEwICsrKysrKysrLS0NCj4gIGFyY2gv
eDg2L2t2bS9pcnFfY29tbS5jICAgICAgICAgfCAgOSArKysrKysrLS0NCj4gIGFyY2gveDg2L2t2
bS9sYXBpYy5jICAgICAgICAgICAgfCAxMCArKysrKysrKysrDQo+ICA0IGZpbGVzIGNoYW5nZWQs
IDI2IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJj
aC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9o
b3N0LmgNCj4gaW5kZXggMGI3YWY1OTAyZmY3Li44YzUwZTdiNGE5NmYgMTAwNjQ0DQo+IC0tLSBh
L2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVk
ZS9hc20va3ZtX2hvc3QuaA0KPiBAQCAtMTA2Miw2ICsxMDYyLDcgQEAgc3RydWN0IGt2bV92Y3B1
X2FyY2ggew0KPiAgI2lmIElTX0VOQUJMRUQoQ09ORklHX0hZUEVSVikNCj4gIAlocGFfdCBodl9y
b290X3RkcDsNCj4gICNlbmRpZg0KPiArCXU4IGxhc3RfcGVuZGluZ192ZWN0b3I7DQo+ICB9Ow0K
PiAgDQo+ICBzdHJ1Y3Qga3ZtX2xwYWdlX2luZm8gew0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
a3ZtL2lvYXBpYy5jIGIvYXJjaC94ODYva3ZtL2lvYXBpYy5jDQo+IGluZGV4IDk5NWViNTA1NDM2
MC4uNDAyNTJhODAwODk3IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vaW9hcGljLmMNCj4g
KysrIGIvYXJjaC94ODYva3ZtL2lvYXBpYy5jDQo+IEBAIC0yOTcsMTAgKzI5NywxNiBAQCB2b2lk
IGt2bV9pb2FwaWNfc2Nhbl9lbnRyeShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHVsb25nICppb2Fw
aWNfaGFuZGxlZF92ZWN0b3JzKQ0KPiAgCQkJdTE2IGRtID0ga3ZtX2xhcGljX2lycV9kZXN0X21v
ZGUoISFlLT5maWVsZHMuZGVzdF9tb2RlKTsNCj4gIA0KPiAgCQkJaWYgKGt2bV9hcGljX21hdGNo
X2Rlc3QodmNwdSwgTlVMTCwgQVBJQ19ERVNUX05PU0hPUlQsDQo+IC0JCQkJCQllLT5maWVsZHMu
ZGVzdF9pZCwgZG0pIHx8DQo+IC0JCQkgICAga3ZtX2FwaWNfcGVuZGluZ19lb2kodmNwdSwgZS0+
ZmllbGRzLnZlY3RvcikpDQo+ICsJCQkJCQllLT5maWVsZHMuZGVzdF9pZCwgZG0pKQ0KPiAgCQkJ
CV9fc2V0X2JpdChlLT5maWVsZHMudmVjdG9yLA0KPiAgCQkJCQkgIGlvYXBpY19oYW5kbGVkX3Zl
Y3RvcnMpOw0KPiArCQkJZWxzZSBpZiAoa3ZtX2FwaWNfcGVuZGluZ19lb2kodmNwdSwgZS0+Zmll
bGRzLnZlY3RvcikpIHsNCj4gKwkJCQlfX3NldF9iaXQoZS0+ZmllbGRzLnZlY3RvciwNCj4gKwkJ
CQkJICBpb2FwaWNfaGFuZGxlZF92ZWN0b3JzKTsNCj4gKwkJCQl2Y3B1LT5hcmNoLmxhc3RfcGVu
ZGluZ192ZWN0b3IgPSBlLT5maWVsZHMudmVjdG9yID4NCj4gKwkJCQkJdmNwdS0+YXJjaC5sYXN0
X3BlbmRpbmdfdmVjdG9yID8gZS0+ZmllbGRzLnZlY3RvciA6DQo+ICsJCQkJCXZjcHUtPmFyY2gu
bGFzdF9wZW5kaW5nX3ZlY3RvcjsNCj4gKwkJCX0NCj4gIAkJfQ0KPiAgCX0NCj4gIAlzcGluX3Vu
bG9jaygmaW9hcGljLT5sb2NrKTsNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9pcnFfY29t
bS5jIGIvYXJjaC94ODYva3ZtL2lycV9jb21tLmMNCj4gaW5kZXggODEzNjY5NWY3Yjk2Li4xZDIz
YzUyNTc2ZTEgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9pcnFfY29tbS5jDQo+ICsrKyBi
L2FyY2gveDg2L2t2bS9pcnFfY29tbS5jDQo+IEBAIC00MjYsOSArNDI2LDE0IEBAIHZvaWQga3Zt
X3NjYW5faW9hcGljX3JvdXRlcyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ICANCj4gIAkJCWlm
IChpcnEudHJpZ19tb2RlICYmDQo+ICAJCQkgICAgKGt2bV9hcGljX21hdGNoX2Rlc3QodmNwdSwg
TlVMTCwgQVBJQ19ERVNUX05PU0hPUlQsDQo+IC0JCQkJCQkgaXJxLmRlc3RfaWQsIGlycS5kZXN0
X21vZGUpIHx8DQo+IC0JCQkgICAgIGt2bV9hcGljX3BlbmRpbmdfZW9pKHZjcHUsIGlycS52ZWN0
b3IpKSkNCj4gKwkJCQkJCSBpcnEuZGVzdF9pZCwgaXJxLmRlc3RfbW9kZSkpKQ0KPiAgCQkJCV9f
c2V0X2JpdChpcnEudmVjdG9yLCBpb2FwaWNfaGFuZGxlZF92ZWN0b3JzKTsNCj4gKwkJCWVsc2Ug
aWYgKGt2bV9hcGljX3BlbmRpbmdfZW9pKHZjcHUsIGlycS52ZWN0b3IpKSB7DQo+ICsJCQkJX19z
ZXRfYml0KGlycS52ZWN0b3IsIGlvYXBpY19oYW5kbGVkX3ZlY3RvcnMpOw0KPiArCQkJCXZjcHUt
PmFyY2gubGFzdF9wZW5kaW5nX3ZlY3RvciA9IGlycS52ZWN0b3IgPg0KPiArCQkJCQl2Y3B1LT5h
cmNoLmxhc3RfcGVuZGluZ192ZWN0b3IgPyBpcnEudmVjdG9yIDoNCj4gKwkJCQkJdmNwdS0+YXJj
aC5sYXN0X3BlbmRpbmdfdmVjdG9yOw0KPiArCQkJfQ0KPiAgCQl9DQo+ICAJfQ0KPiAgCXNyY3Vf
cmVhZF91bmxvY2soJmt2bS0+aXJxX3NyY3UsIGlkeCk7DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9rdm0vbGFwaWMuYyBiL2FyY2gveDg2L2t2bS9sYXBpYy5jDQo+IGluZGV4IGEwMDljOTRjMjZj
Mi4uNWQ2MmVhNWYxNTAzIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbGFwaWMuYw0KPiAr
KysgYi9hcmNoL3g4Ni9rdm0vbGFwaWMuYw0KPiBAQCAtMTQ2Niw2ICsxNDY2LDE2IEBAIHN0YXRp
YyB2b2lkIGt2bV9pb2FwaWNfc2VuZF9lb2koc3RydWN0IGt2bV9sYXBpYyAqYXBpYywgaW50IHZl
Y3RvcikNCj4gIAlpZiAoIWt2bV9pb2FwaWNfaGFuZGxlc192ZWN0b3IoYXBpYywgdmVjdG9yKSkN
Cj4gIAkJcmV0dXJuOw0KPiAgDQo+ICsJLyoNCj4gKwkgKiBXaGVuIHRoZXJlIGFyZSBpbnN0YW5j
ZXMgd2hlcmUgaW9hcGljX2hhbmRsZWRfdmVjdG9ycyBpcw0KPiArCSAqIHNldCBkdWUgdG8gcGVu
ZGluZyBpbnRlcnJ1cHRzLCBjbGVhbiB1cCB0aGUgcmVjb3JkIGFuZCBkbw0KPiArCSAqIGEgZnVs
bCBLVk1fUkVRX1NDQU5fSU9BUElDLg0KPiArCSAqLw0KDQpIb3cgYWJvdXQgYWxzbyBhZGQgYmVs
b3cgdG8gdGhlIGNvbW1lbnQ/DQoNCglUaGlzIGVuc3VyZXMgdGhlIHZlY3RvciBpcyBjbGVhcmVk
IGluIHRoZSB2Q1BVJ3MgaW9hcGljX2hhbmRsZWRfdmVjdG9ycw0KCWlmIHRoZSB2ZWN0b3IgaXMg
cmV1c2VkwqBieSBub24tSU9BUElDIGludGVycnVwdHMsICBhdm9pZGluZyB1bm5lY2Vzc2FyeQ0K
CUVPSS1pbmR1Y2VkIFZNRVhJVHMgZm9yIHRoYXQgdmVjdG9yLiANCg0KPiArCWlmIChhcGljLT52
Y3B1LT5hcmNoLmxhc3RfcGVuZGluZ192ZWN0b3IgPT0gdmVjdG9yKSB7DQo+ICsJCWFwaWMtPnZj
cHUtPmFyY2gubGFzdF9wZW5kaW5nX3ZlY3RvciA9IDA7DQo+ICsJCWt2bV9tYWtlX3JlcXVlc3Qo
S1ZNX1JFUV9TQ0FOX0lPQVBJQywgYXBpYy0+dmNwdSk7DQo+ICsJfQ0KPiArDQo+ICAJLyogUmVx
dWVzdCBhIEtWTSBleGl0IHRvIGluZm9ybSB0aGUgdXNlcnNwYWNlIElPQVBJQy4gKi8NCj4gIAlp
ZiAoaXJxY2hpcF9zcGxpdChhcGljLT52Y3B1LT5rdm0pKSB7DQo+ICAJCWFwaWMtPnZjcHUtPmFy
Y2gucGVuZGluZ19pb2FwaWNfZW9pID0gdmVjdG9yOw0KDQo=

