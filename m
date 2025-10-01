Return-Path: <kvm+bounces-59373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E21EBB1CA8
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 23:19:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07F2F4A42A2
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 21:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E71311963;
	Wed,  1 Oct 2025 21:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dMxxQ/P+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB88730F935;
	Wed,  1 Oct 2025 21:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759353567; cv=fail; b=UH1ag9B2KnG+ZbAI11O3WWee2u3QPL/8d6PQovk2p8MancFRLgWejNT433FVBjAde1IMgHqDi9m4mnLN+7KeWFvBfpTjIXXGb8PyZmz8uOb8C5RtM+bTmyKCcDi53c+Fuf0JW7LA0hEUm+Xs4EAsde/8vSYHT5xVJvMtN3piCeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759353567; c=relaxed/simple;
	bh=e2wksSMAOiKbSVZFERJHnD5iaHkJhTjRZlwioyELPYw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E0aoZsapzRUf5eY11q5ygXBLglz5CdGuPOA5WqrioGIgb2kkjD0khQnOaWj3thiHcAAiVS8pE1b92DUipDf8Y7bKBNp9tjY7YU1K1aUTPyWuiyXoskoeQb7oJ8jgCGfkVMRlRLmbN5VFHiqZcEMMLA4shdiThpwnNIbK6CLMFfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dMxxQ/P+; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759353565; x=1790889565;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=e2wksSMAOiKbSVZFERJHnD5iaHkJhTjRZlwioyELPYw=;
  b=dMxxQ/P+72vUwyC3lw5WSFq6/g3xGQv8ArcR4UvQimUf3ZVszcv+t2y9
   dSA2qbThX9rOkLrq3SoRWkslUOkhS32ekFhNxcE4wbHLch1c1WIM916Wp
   ua0/pSqaIYzbbcUEcngHKfy2kAEmLdKmtmTCQ+isPzTVHPBe1kXv2rLEy
   2gsD8IwV4DM54FtmRA/Jnyn4bT5al3xVPgaePX3PwnnlhRjsuztMdZfr+
   V0KapBAEZr1izxG2J6dcdBBeFm5qbtbtDpoWQbbzPoDUyv4W/jts3FFB3
   mwQKjRlEp4BJ4IIEFBW+E04nmJjsvq7OylMxj0heHfG45lwRI8n1hOd7R
   Q==;
X-CSE-ConnectionGUID: fGJSbDJsR6Ca8jlPNo9Kng==
X-CSE-MsgGUID: puqbwhAMQNGiNZOcpDfT1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="60854547"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="60854547"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 14:19:25 -0700
X-CSE-ConnectionGUID: zcsKoLD7TkqT+qE8lhyobg==
X-CSE-MsgGUID: oCDnrZMbQ6i5pOu1zI/BUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="183285185"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 14:19:25 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 14:19:24 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 1 Oct 2025 14:19:24 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.47) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 14:19:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dt+gqGQwFFyszd3NR7utobV9Xwq9LoNxgjM5tdpInkEuy8MlIE9z/BKcE/I3qjYV76WSiKFkODiIPmyLdsyVsnXn5PDdlA7/DyLmqODB9fJlqOZpR4uHeMcUEgzJjDUL2MP80iw43ivYqPe361xZ9PoKId09GGsFftWbnpj5qxvddBcilVt4LmeLKjiqvf6ptbRB7vyS/2Ji6LCppLMt6S7Yd/a1YQ1qeZYNAOP68opYPKNFfkXEved5/MJXAe7Y4GRY8kAtqdRRITobo7XzhGkTog4kwQoj169qJskl9FIMNRJ50HkWjB1XZxJmLaQtxBAclayTA1xd+prRz05JlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e2wksSMAOiKbSVZFERJHnD5iaHkJhTjRZlwioyELPYw=;
 b=EaSoMmV0l1dG+eXCZ+Pkrf8Ne5x09UCqv7NSih4bRSorQsAmROrSsJYBbSvNPEjiLzAKf7ethwQ/iPugRdzFM4h4mUFf+lEyi8LY4tUIdQRKbFkU8NOdPVIskAVhnKq8uE9UhrpYLblrjN8Rm4LoP/u8AChGuK0GDjvZzbwExR8ihdLuCB95KNl9JxDqYTiQeOWEBAVAQLsIIFyedkYlp3Uqm/WOE/2jVBrTSkoMc3e7SZv7xLovUvUib4qGCChBlHvJ2J7DjpsccJvq46kT8S00L4QBJiGVVUoa7KDFSRnakSYdDHC40sxY45EAj9mtggC1f/eQrkDflu/mY4F46g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS4PPF399DBF572.namprd11.prod.outlook.com (2603:10b6:f:fc02::1e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 21:19:14 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9160.017; Wed, 1 Oct 2025
 21:19:13 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "dwmw@amazon.co.uk"
	<dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com"
	<sagis@google.com>, "Chen, Farrah" <farrah.chen@intel.com>, "Edgecombe, Rick
 P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Gao, Chao"
	<chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Topic: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Index: AQHcG1rj8xzFenegOUSY8voF4LzMlLSrHy0AgAFNloCAAExKAIAA0KGAgAAuMwCAAAvkAIAAN5SA
Date: Wed, 1 Oct 2025 21:19:13 +0000
Message-ID: <bbad67640018eccc023d2afce313f3b5bc806cfb.camel@intel.com>
References: <20250901160930.1785244-1-pbonzini@redhat.com>
	 <20250901160930.1785244-5-pbonzini@redhat.com>
	 <CAGtprH__G96uUmiDkK0iYM2miXb31vYje9aN+J=stJQqLUUXEg@mail.gmail.com>
	 <74a390a1-42a7-4e6b-a76a-f88f49323c93@intel.com>
	 <CAGtprH-mb0Cw+OzBj-gSWenA9kSJyu-xgXhsTjjzyY6Qi4E=aw@mail.gmail.com>
	 <a2042a7b-2e12-4893-ac8d-50c0f77f26e9@intel.com>
	 <CAGtprH_nTBdX-VtMQJM4-y8KcB_F4CnafqpDX7ktASwhO0sxAg@mail.gmail.com>
	 <2cbf11a4-fe92-483c-8ab7-182284720700@intel.com>
In-Reply-To: <2cbf11a4-fe92-483c-8ab7-182284720700@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS4PPF399DBF572:EE_
x-ms-office365-filtering-correlation-id: c2924d0d-134b-48f5-14f2-08de01302bd8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bDV4UThLMG16ZmthWkJkY1Z2UXh2ck9tR1g3L0RjUGhOL3hGRlZVUDFnQTBI?=
 =?utf-8?B?VTByK091NUgveGJHVzJ4NWtWUkZEWXhObGJ5NFVyaHFvcmVzdnJYWXp0ZEJO?=
 =?utf-8?B?TXIybmg2Q213OXlWQjVWRjhDR3pqTDhQVkhFNVcydCtaTDNMazZvZzAyOEF6?=
 =?utf-8?B?NmhHOHpYQmxuUEFYcE1VZkNQaTZML01ueGhicUYvbkV3TnlmL3ljbmJKS1pJ?=
 =?utf-8?B?THlDN2FIS2FHOEQzT3NJbFN2T2lIUjNxc09Wa2R0ZmF5dUR0YjNvVUpacWtj?=
 =?utf-8?B?bzh1OTVtRHdOOEZEZnZtTjMxLzFPdjA4TTIzNzNEakxNM2NZQUVQVW1tRVlq?=
 =?utf-8?B?dDlOc3RlZEdOblFnVDVOcG0wMmcvd0ZOMFI5MDdpZExNS1NvanN3NTFYQVM1?=
 =?utf-8?B?TE9KbHBVeHZpUkVRTStUVVdVdGZRVUpRNXk1eXZsRTRiK29xRWpzVUFvRTRz?=
 =?utf-8?B?QzBTL0hEK2lIbVpLY2xWZWZhSjNBV2dmenNwb2hxWTBpOGs2L0ZCNm5Kc2Jv?=
 =?utf-8?B?NWdaU05adlBiTVpad0JTVk5UOWg0TnVaMDlIbm1sZ2JJQXJ6UWJiZVJ3UlNv?=
 =?utf-8?B?clhURDNIRXg5R3M1RzEzTXJxcU9uU25DZWFiY0NIMWxHYloyS3NWUEtHY01w?=
 =?utf-8?B?dFlBcmZ5bi9BS1dOdGFRZ0FVdmtDNFVsYUJrajVxM3dnSWM4YXgzUXk3aEZw?=
 =?utf-8?B?T2RCa0J0L0ZUM0VmbXlMcHNuckZJaTlhdTJGdUd4VUsyNkowM05Qd2NOZGln?=
 =?utf-8?B?ZG85Wnl6MFNkQVBWeTEzSHNkTExua2tsYm1rb0pQS2RtSE9WcHJhTGRwSzZK?=
 =?utf-8?B?ejFXRGdYQ215c0d1ZTYxd1dyc0Y2eTNJNGU0VElXWHVpakYyUHBsZWlEWlhx?=
 =?utf-8?B?RFQzWUdRR0FSaWNiUlV2NVFnQUtGL2xHWXZ6d1RRVUtxU3drZVJMYW9ZdE16?=
 =?utf-8?B?RTE2RVU0dFl4bGNBKzJpTnFjNHpYZldjcGRhR1k5NStvQUppK0VEUlFMb2Vi?=
 =?utf-8?B?NmdRMTlZUnBtWkZiS0tkNWhmbnJQSFB3NUZtNWYydFc1bk1RNDBkWFhWbmtZ?=
 =?utf-8?B?cXMrWVVYZWhqWlVCS1hHWTM4cmhHUU9TcHB0c1R2aXRsMVoyaU1paDR3bkNi?=
 =?utf-8?B?NCt4L2FUQWZDTlRYcW1UVTlwL0xyOForbVhkSGwraXkvYzRMTEVBUXVnajZJ?=
 =?utf-8?B?QWRBUStBMUdzcWxRREhwTk5oWGRzQ29DQ3lUcGwrbW01bHI4c1htSGRZcmEy?=
 =?utf-8?B?eTE5OTJPc0tpaGpMYlNCNWhmRGh4UFV5MEd5NzFMNFFMaGpUU3NsN08zY1JQ?=
 =?utf-8?B?RXZXMHZXSWhheHlqT2VZM0RqdTZla1dOTU1OVDNHVlk2aXp5RGdKbXVuQzRW?=
 =?utf-8?B?VENNU2hGZ0R0b1loREE4TjN6RkNkazgwWjBISjEzeFVlZHVHSUQxVXdmYzdH?=
 =?utf-8?B?VlVsNnM0ZVRncEMxQ1h3VGFOWmJ4c0FHTFN0MmgzdHlzTjVSNFlPak04Tmxa?=
 =?utf-8?B?YVhrZTJBRVR3Y3lYWDZtbEpNNzNzdTVkbC9zMXRqU1k1Z3lNVWtKYklKZlVZ?=
 =?utf-8?B?YVZON1VtWVg2aUdmOVBpT3U3U3JudS9OMGc5SWd1OGdYc2lYNENlRHdOejFH?=
 =?utf-8?B?MFBJQnBJMm5NNGtXbnZPYllOUlQ3eGNyV20vbnFzaDdGVGJ1MUMxWkkzVlQr?=
 =?utf-8?B?WnhpZm9iemNzRHNvTmtEMVVFOStoVlU5NGtOZEM1MWFQc2I1ZVFYSUUrSnZD?=
 =?utf-8?B?K0JjOFR0cmFQSkovVkpDZUJhZkYwVHMyRGhuL2RPalkxdURKV2g1MDE5YzFP?=
 =?utf-8?B?dGVEL1AxQ3pScW5UcUsxL0Q4VW80ZlZseFNOa3pIRUpXaUZNUlNnbHhxMVZq?=
 =?utf-8?B?a3k4SWg4WDhCbDVYWXJ3SmJWNzUrRk9NbWgzL1BPZzVGbTFDUFc3dExFN0Fw?=
 =?utf-8?B?WkhWZDhYTWQzdUhWZXcxNlBZcXAzeTYyTW9DZHVzbTh3b3hpa0dTeHhLZ0ls?=
 =?utf-8?B?OUw2QS9YMVlBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXBZblJmR3VCeDVTYUxtM2dNTDA2YkQ5OTQ0OEN5ZU9aNXV6cDFIWlAyUkJM?=
 =?utf-8?B?VjFqaDArWVFtRWE3UVdzbStXWFYvd3AycjdGdlIrb2JiK3RsODM4amYwWnQ1?=
 =?utf-8?B?SklUeWNDYXJRL2lQY3BLcUpvaFZLVkJPM1duc0RIZm8zaUtqMFVLa0JtS3VK?=
 =?utf-8?B?QVRYaHVBYW9RUzBLWGhhMVp4YXAwZUdIVTNSQ2Y4SkhBS0s4VkpMVTkzRnNv?=
 =?utf-8?B?Sll5Q21MaEZBeUZudGQ2VDRxSmlYNzBWeEFoMk5SUmhWMWEwc1huSlRwbVBQ?=
 =?utf-8?B?aU54T1dYQmZCeFdjRkhWYllFVUdjMDhRb2dDcU9vYmdiNHgwMzl2ODJhS2NV?=
 =?utf-8?B?M3ZqZFpXWE10S3I2aEFGUUlTaUJ1OEtJcDhEZ1RPaGRTa0drUy9RMjc3Nk1Q?=
 =?utf-8?B?NzBPazRmNC9HT2JoU3RUZzhGcWJJdno2VUdrM25EYWRXeHE1ekpieWdqQjVh?=
 =?utf-8?B?bXI5SWxkZHNFK3U5VEN0QkpOSFdnRjNxWHVic0htVERDZVk4UGEzcC9mMk5E?=
 =?utf-8?B?c2tyNHZ4NlF4Q3dVaFNEa2FPN0p4Ri9DdFQrWGs4bXpaSWlLQzdLR0JlczZW?=
 =?utf-8?B?S0JYWlJNUm10VGx4UHZEdGV4ZDV2NnQvdVY5QkpSVGpHZFFUVTFRWE9wVVU2?=
 =?utf-8?B?TTJGRE5aZTU1eDhuVkx4Z1F3VTNuQkZYQlU0bFRVK3VvTTU1VCtaY0RpaHZZ?=
 =?utf-8?B?aHEwZ2FSZTFEdDU2VEhhaXhSMXJDbEp4S3JrZHpyOFIxa2FibUV6NURlS0VF?=
 =?utf-8?B?dkdyTjZCLzk4eElBakIwZkY3ZHI0NWJ6ei9pcUtkVitPVElZQmxvVG5kSTQw?=
 =?utf-8?B?S0dpM1dDZnB1NlNlZS91aGlBdUt4cW8vRGVCMkltVm5OMkplKzdVNlQ0RWU2?=
 =?utf-8?B?L1ZzYWUrem5jTERPRTNyeFY3K1BBNjBBWlZ1eVh1UkJUTHRPQU96L215aHZx?=
 =?utf-8?B?T29PVElTZVJvTlVLWDBxZE90NitIRHcySmo0QkhlVkxCS0hnclRoaWR3cHpj?=
 =?utf-8?B?Mnk1UTJvQm5oWk9IOW55UWZLbDdNenRSaGQ4a3pyVk00dThWQ2hYQXM2MVdU?=
 =?utf-8?B?ckRWQ1FsV0FUZm9JeGVUQ2tUWHZrK0kzNUViRkwraE1RRVFISndQYjZUNmpJ?=
 =?utf-8?B?a1ZtbGFrS3c5TXFCNm54QmVteXEwT3ZzMERUVTNsUmVKODhpK201cEg5aGo0?=
 =?utf-8?B?dWtVWGloNnU2aDNWaitiU0lVN1pXTkJWcjh2ZHBvT3J3V2UvNG1VRHk2THBK?=
 =?utf-8?B?d2RVYUI5eGtHdGtDQXNTL1B2YXVSc25WdnZZWnU5dm1SVldxa2hVWUNJSlBv?=
 =?utf-8?B?SVJrbDlzZzRDRGEvK1lUS3EvSlRIT1UwLzZzWEVWRVorN2lmU205OFkrNGox?=
 =?utf-8?B?Y0V3S09Vc0k3Q0dPU3VFcUtsZFcxK0FjaGUwbjcvc2hEUjJjNUIwSmkyWWFu?=
 =?utf-8?B?UkZIUUkrWEs0enZPbFp5NkVDNXVwM2dNZXVBY3BTZU1JQ3dBcGI4VTJGRHc0?=
 =?utf-8?B?bnVFV0hWSFV4WGtxQXNmQUJmMTRpQzc4NjMwS0NPUUYwMVVFdGUzeFBRb1k2?=
 =?utf-8?B?NlMvTm1Ubmt2Qkt0bkpkS2IxYVAwbVVzakZiWDlFT0YzVGRMdFVwUXlYaThM?=
 =?utf-8?B?Q2I3L3lzL1d1NDBOdi9FQVhLWW5ybm9oN1pFL3pIYitqQ2JMS2VvV1BGdHNP?=
 =?utf-8?B?S3htNzg5cTh0anl0QlZjcHRxT1d1YUFrcm5oT0FzcG9tL0R0ZnNhczBuSUd4?=
 =?utf-8?B?blN4TE11TURTSjcxZUlQdU84RDY4Q3k0Skw4OXoyNllNVlp0RHRnZGVFbDdN?=
 =?utf-8?B?V0c3VTRyOHZUU1pTT1E0MU10am1xU2svR0s4WmFycUlkZ01vRVhUbm11cStV?=
 =?utf-8?B?cjYvMjBKQlhaRFQxQjFHTW02TUZ2TzI3VndoaDhteTErRDF6VkFvUkpiU1FN?=
 =?utf-8?B?dUhZNE5ZMWVoSTBpSGc0Qit2L1RNNFpSNm53Y3pnV2lWQmZtWGh2ck5ZS3o2?=
 =?utf-8?B?dkdCN0h1L3hBVnVQdFBYVU9zMFNqL0RKSGtGaG5xeTg3NmZmTll3ZytlRHBX?=
 =?utf-8?B?V2J1ZENKNFdyakZZbk4zSGd6dDUzRWFaa2hla1ZiMWE2TnBNVTRxWlRVdGwr?=
 =?utf-8?Q?R+zTKML83sRHcW97s9ZD8kxCX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7046625CE564B4FAAD11C998E872FE6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2924d0d-134b-48f5-14f2-08de01302bd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2025 21:19:13.8595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 35MNicJJiI6/ArCNlmlgKH+hOrC/F7KFt8l0W3tLDqG4hw8J/pR6JPzrlej695UYniyousH+dlx/9dWLsqjElw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF399DBF572
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTEwLTAxIGF0IDExOjAwIC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDEwLzEvMjUgMTA6MTcsIFZpc2hhbCBBbm5hcHVydmUgd3JvdGU6DQo+ID4gQW5kIGFsc28g
bWVudGlvbnM6DQo+ID4gIkFsc28gbm90ZSBvbmx5IHRoZSBub3JtYWwga2V4ZWMgbmVlZHMgdG8g
d29ycnkgYWJvdXQgdGhpcyBwcm9ibGVtLCBidXQNCj4gPiBub3QgdGhlIGNyYXNoIGtleGVjOiAx
KSBUaGUga2R1bXAga2VybmVsIG9ubHkgdXNlcyB0aGUgc3BlY2lhbCBtZW1vcnkNCj4gPiByZXNl
cnZlZCBieSB0aGUgZmlyc3Qga2VybmVsLCBhbmQgdGhlIHJlc2VydmVkIG1lbW9yeSBjYW4gbmV2
ZXIgYmUgdXNlZA0KPiA+IGJ5IFREWCBpbiB0aGUgZmlyc3Qga2VybmVsOyAyKSBUaGUgL3Byb2Mv
dm1jb3JlLCB3aGljaCByZWZsZWN0cyB0aGUNCj4gPiBmaXJzdCAoY3Jhc2hlZCkga2VybmVsJ3Mg
bWVtb3J5LCBpcyBvbmx5IGZvciByZWFkLiAgVGhlIHJlYWQgd2lsbCBuZXZlcg0KPiA+ICJwb2lz
b24iIFREWCBtZW1vcnkgdGh1cyBjYXVzZSB1bmV4cGVjdGVkIG1hY2hpbmUgY2hlY2sgKG9ubHkg
cGFydGlhbA0KPiA+IHdyaXRlIGRvZXMpLiINCj4gPiANCj4gPiBXaGF0IHdhcyB0aGUgc2NlbmFy
aW8gdGhhdCBsZWQgdG8gZGlzYWJsaW5nIGtkdW1wIHN1cHBvcnQgYWx0b2dldGhlcg0KPiA+IGdp
dmVuIHRoZSBhYm92ZSBkZXNjcmlwdGlvbj8NCj4gDQo+IEkgdGhpbmsgaXQgd2FzIHB1cmVseSBv
dXQgb2YgY29udmVuaWVuY2Ugc28gdGhhdCB0aGUgZGlzYWJsaW5nIGNvdWxkIGJlDQo+IHRocmVl
IGxpbmVzIG9mIGNvZGUuDQo+IA0KPiBJIGRvbid0IGtub3cgb2ZmIHRoZSB0b3Agb2YgbXkgaGVh
ZCBpZiB0aGVyZSdzIGEgc2ltcGxlIGVub3VnaCB3YXkgdG8NCj4gZGlzYWJsZSBrZXhlYyBidXQg
bm90IGtkdW1wLiBXaGVuIEkgYXBwbGllZCB0aGUgdGhpbmcsIEkgd2FzIHByb2JhYmx5DQo+IGp1
c3QgY29uc2lkZXJpbmcga2V4ZWMva2R1bXAgYSBtb25vbGl0aGljIHRoaW5nIGFuZCBub3QgdGhp
bmtpbmcgdGhhdA0KPiBmb2xrcyB3b3VsZCB3YW50IG9uZSBidXQgbm90IHRoZSBvdGhlci4NCj4g
DQo+IEthaSwgZGlkIHlvdSBoYXZlIGFueSBvdGhlciBtb3RpdmF0aW9ucz8NCg0KVGhlICIvcHJv
Yy92bWNvcmUgaXMgb25seSBmb3IgcmVhZCIgaXMgbXkgdW5kZXJzdGFuZGluZyBvZiBob3cgdGhl
IGtkdW1wDQprZXJuZWwgdXNlcyB0aGUgL3Byb2Mvdm1jb3JlLiAgSSB1c2VkIHRvIG9ubHkgZGlz
YWJsZSBrZXhlYyBidXQgYWxsb3cNCmtkdW1wIHRvIHdvcmsgKHNvbWV0aGluZyBsaWtlIHRoZSBk
aWZmIGJlbG93IFsqXSksIGJ1dCBkdXJpbmcgdGhlIGludGVybmFsDQpyZXZpZXcgd2UgZGVjaWRl
ZCB0byBqdXN0IGRpc2FibGUgYWxsIHNpbmNlIHdlIGNhbm5vdCBiZSBzdXJlIHdoZXRoZXIgaXQN
CmlzIDEwMCUgdHJ1ZSBmb3IgYWxsIHRoZSBrZHVtcCB1c2Vycy4NCg0KVGhpcyB3YXMgcmFpc2Vk
IGJ5IFZpc2hhbCBwdWJsaWNseSBiZWZvcmUgYW5kIHdhcyBkaXNjdXNzZWQgaGVyZSAoaW4gdjMp
Og0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vZjhkY2JlMjU3YjM5MzFhZWM5ZTE5OTEz
MmI2NzhiZDc2ODFiN2VmYS5jYW1lbEBpbnRlbC5jb20vDQoNClsqXToNCg0KZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2tlcm5lbC9tYWNoaW5lX2tleGVjXzY0LmMNCmIvYXJjaC94ODYva2VybmVsL21h
Y2hpbmVfa2V4ZWNfNjQuYw0KaW5kZXggMTUwODhkMTQ5MDRmLi5jN2FmNGFhN2RkNmIgMTAwNjQ0
DQotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvbWFjaGluZV9rZXhlY182NC5jDQorKysgYi9hcmNoL3g4
Ni9rZXJuZWwvbWFjaGluZV9rZXhlY182NC5jDQpAQCAtMzU2LDEwICszNTYsMTEgQEAgaW50IG1h
Y2hpbmVfa2V4ZWNfcHJlcGFyZShzdHJ1Y3Qga2ltYWdlICppbWFnZSkNCiAgICAgICAgICogT24g
dGhvc2UgcGxhdGZvcm1zIHRoZSBvbGQga2VybmVsIG11c3QgcmVzZXQgVERYIHByaXZhdGUNCiAg
ICAgICAgICogbWVtb3J5IGJlZm9yZSBqdW1waW5nIHRvIHRoZSBuZXcga2VybmVsIG90aGVyd2lz
ZSB0aGUgbmV3DQogICAgICAgICAqIGtlcm5lbCBtYXkgc2VlIHVuZXhwZWN0ZWQgbWFjaGluZSBj
aGVjay4gIEZvciBzaW1wbGljaXR5DQotICAgICAgICAqIGp1c3QgZmFpbCBrZXhlYy9rZHVtcCBv
biB0aG9zZSBwbGF0Zm9ybXMuDQorICAgICAgICAqIGp1c3QgZmFpbCBrZXhlYyBvbiB0aG9zZSBw
bGF0Zm9ybXMuICBTdGlsbCBhbGxvdyBrZHVtcCBzaW5jZQ0KKyAgICAgICAgKiB0aGUga2R1bXAg
a2VybmVsIHdpbGwgb25seSByZWFkcyBURFggbWVtb3J5IGJ1dCBub3Qgd3JpdGUuDQogICAgICAg
ICAqLw0KLSAgICAgICBpZiAoYm9vdF9jcHVfaGFzX2J1ZyhYODZfQlVHX1REWF9QV19NQ0UpKSB7
DQotICAgICAgICAgICAgICAgcHJfaW5mb19vbmNlKCJOb3QgYWxsb3dlZCBvbiBwbGF0Zm9ybSB3
aXRoIHRkeF9wd19tY2UNCmJ1Z1xuIik7DQorICAgICAgIGlmIChib290X2NwdV9oYXNfYnVnKFg4
Nl9CVUdfVERYX1BXX01DRSkgJiYgaW1hZ2UtPnR5cGUgIT0NCktFWEVDX1RZUEVfQ1JBU0gpIHsN
CisgICAgICAgICAgICAgICBwcl9pbmZvX29uY2UoIktleGVjIG5vdCBhbGxvd2VkIG9uIHBsYXRm
b3JtIHdpdGgNCnRkeF9wd19tY2UgYnVnXG4iKTsNCiAgICAgICAgICAgICAgICByZXR1cm4gLUVP
UE5PVFNVUFA7DQogICAgICAgIH0NCg==

