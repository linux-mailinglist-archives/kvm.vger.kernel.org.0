Return-Path: <kvm+bounces-54560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ADF6B23D57
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 02:51:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0A111A2228B
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 00:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AAC41311AC;
	Wed, 13 Aug 2025 00:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VzPcQxNz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51B9249E5;
	Wed, 13 Aug 2025 00:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755046278; cv=fail; b=o5m/gTXKWykNZbI/cYevWaNZ5e9CLg3kT5Txlc9zV0KCfwh0jqKuweGCMmho+3IlaGfpF0RNocyQYxRGbKVM3dubQLqgAz0WWI5FVsxG3/FWH81t+xorJovdrc21kEwloYbTQuGm2uexrVd/5+r0KowUZge8ctVyAo2oJtEBYCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755046278; c=relaxed/simple;
	bh=MuVCnXXeaWsB2gSalkTi3IPwMOxYy1Nt+pdfwj/Xj7M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SeizWiN75o5rXaP2vdgajxveJVfL9MecaEEDVlt9H/FqrQ33XRrrJqmdLi+YDn8NDS8BU6fC9RGppnAGxa+J0aWQ0Vta5FRWXklFoD/bGo4pS938BXzqLQ7160do8xr3jqAnuD3hgoTzhcer/HqTguPTY4e5qCo83KN1zhWISYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VzPcQxNz; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755046277; x=1786582277;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MuVCnXXeaWsB2gSalkTi3IPwMOxYy1Nt+pdfwj/Xj7M=;
  b=VzPcQxNz735zFLWViMUnAy1hf7PCCY0RPHzGbZHEyg3/I2A3MSqS/AeT
   rIwgFgXciSg4wRWeN/xwm1muekXrP9t8X1u4WnREaqUcsCQGpk/QHmr2t
   G9E93dEAX7YlMWUBqQ2VEKYde+59jH2bNtuPeuqRttJtQ7r4ZVBehXWx0
   61ETL+lcA/szfFZgnZSKAcWpladwCE2EmKavldxH1A/uU2rQoqEiMrvSG
   SJtxegt6I/X2cvMLAbIO8y3XuAlhSVSJOWhJItYlmx1w5VtF1s5d81JAG
   mYkfaWoXRiztVYVx6/7f5l0o02nfM1MfYRNoeOx09qja3P8qkFfV7U666
   Q==;
X-CSE-ConnectionGUID: EG2xfxqQRqOpwt7yWq+V/g==
X-CSE-MsgGUID: JN+kxsdcRSGInf8NHTFvWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="67935647"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="67935647"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 17:51:15 -0700
X-CSE-ConnectionGUID: prgjvP7nTBaAprmPhBGmDA==
X-CSE-MsgGUID: tKQ/1MndRUG3WIik0qIMLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="197324613"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 17:51:15 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 12 Aug 2025 17:51:14 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 12 Aug 2025 17:51:14 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.75)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 12 Aug 2025 17:51:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NImz6SEaqAYJad0orSjwHCgh9W/mMCL/pZ5g2pDqalGUOZdgo9QS1059sUcCAcBwkAsxJeGAFUw+Uvbrx6tF8aFpywvSbiT3jHGQf9bRbDc59GL5uoxGNb8NWrmO1exGnUjorR/CCzFYUsyb3u9/XegNBBg5d8VHrGe6KwxPIQxQ0XrzaI1jcYa62zZPT4xW4VlAGQwJwAY6fzdMe8AR88WhVoRtyRdYdt0VZlvoZTKfn/RenmVpOixs+h1Em9me8Xz01213nloDMSOoVp7AycyeeE2vnp5D/q2TChCNisht2KTj1eIuKr7ybgjyZiJkjKWY+uvCA8FKgeoqnpveJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MuVCnXXeaWsB2gSalkTi3IPwMOxYy1Nt+pdfwj/Xj7M=;
 b=OI+V5TSJ4Wb90sTVjddbb7RiOfawEu7HeEZnhFZJdIgOrrjLUAFKnQuLot7SjL4cZnMGpI0SmfyQ1xyYCwYAPp5QFxdHGSvOfwT8PXHnRhlMU35lTgYmcY4Twb8k4pfMSP5ZPUONbZxMvWAsfP0caD3PwlJts8Q2pj02YjK4La6XMbnaiuSi6FJRwnhkQVJlWgZGxiZ5ghmUhMU85GGp6aCYZvXiV2w7f6qDODzrFoIARB9qPzsbQw2EiaeuYCA95jewTQPt/lmSX9ToMl+sZ6ad5KkHVc/y7h0RyIRBst+1fAYEVROFXJJ7vIl5s5PLnwYzgUieN0LDuk5m+d4Mpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by MW6PR11MB8309.namprd11.prod.outlook.com (2603:10b6:303:24c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.14; Wed, 13 Aug
 2025 00:51:06 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%4]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 00:51:06 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "kas@kernel.org" <kas@kernel.org>, "Huang,
 Kai" <kai.huang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Index: AQHb2XKrCJQDYmgN9EmkL7mVJaZZf7RZwqaAgAOdgICAAQwrgIAAOwMAgAAILQCAAF0hgIAAd5yAgAARcACAACgtgIAAOFiAgAAaVQCAAAxCAIAACQEA
Date: Wed, 13 Aug 2025 00:51:06 +0000
Message-ID: <b2d7227f960104f4bb53450c9820c1046589a049.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
	 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
	 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
	 <aJqgosNUjrCfH_WN@google.com>
	 <CAGtprH9TX4s6jQTq0YbiohXs9jyHGOFvQTZD9ph8nELhxb3tgA@mail.gmail.com>
	 <itbtox4nck665paycb5kpu3k54bfzxavtvgrxwj26xlhqfarsu@tjlm2ddtuzp3>
	 <57755acf553c79d0b337736eb4d6295e61be722f.camel@intel.com>
	 <aJtolM_59M5xVxcY@google.com>
	 <6b7f14617ff20e9cbb304cc4014280b8ba385c2a.camel@intel.com>
	 <CAGtprH9x8vATTX612ZUf-wJmAbn+=LUTP-SOnkh-GTUHmW3T-w@mail.gmail.com>
	 <b5ce9dfe7277fa976da5b762545ca213e649fcbc.camel@intel.com>
	 <CAGtprH8Mdgf_nx4qEN3eqp4KqmrW9OvxYHHDJDV2xa7nmBnGbA@mail.gmail.com>
In-Reply-To: <CAGtprH8Mdgf_nx4qEN3eqp4KqmrW9OvxYHHDJDV2xa7nmBnGbA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|MW6PR11MB8309:EE_
x-ms-office365-filtering-correlation-id: 59ae17f4-24ef-4d62-35da-08ddda037c41
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dUppY0EvL1ZPZHJmQ1lWY29pSFgxL1RMWnp2NDk3MHNpYitOUm04QTdjU1cw?=
 =?utf-8?B?TS92YkhYSmZraDJtQ1plbTBuOVUwc3FwaXJITUtic3Z5QWMyNTN4cnFielA1?=
 =?utf-8?B?WXhSbUNkNjZ2a1o2RW5sdnFYVkJRdVhQUGthRm1ONUswVG1mTmY0NzBhcXFz?=
 =?utf-8?B?WTFzMUVQRkFVRlo3YldKbEFmcWlWT09HNTBZTDNTeXdMNWk1Zk9WRHpUaUFT?=
 =?utf-8?B?VGxFTVZZTHorblh1Slk5WjBCSWNUcUNGRlNDVTNGY1UvSzlHUHRmRXE0WUV3?=
 =?utf-8?B?aDFhWldGZmJBWkhyY0Zpb0xDWFRoQXZOUkpFV1lJTUNpOVNrUVJyTnRHZmE5?=
 =?utf-8?B?ZzRuTS9kS3hkM1RwVGZGQlhibzlIanM4ODRGOVFRZHJTYnBpenNPTlJTQXVS?=
 =?utf-8?B?WStiQkg3ckpBM0RtRnhKcDdDMkNlZy9HLzJObzNDcFFRSGp5cjhXQzZYK0cw?=
 =?utf-8?B?OFczMTlUMnU1cldBWldabzRUNGYyUFBiVUtqUTJFYnJYT1Zob0dmVVdVM2Yv?=
 =?utf-8?B?c3A3RGZmUnAzUjdtYzRRU0JCSnJlaDJkcUU4cEF0Y2YrVE01bWhzZGV1Z1g3?=
 =?utf-8?B?VzlHU1IvM1dKMldzZndBVjFxZ2pteWlHTW5VL3ZyaDhac24wZ1VVeDZzZ3U5?=
 =?utf-8?B?U1dpU2xJUkZqZ24wYkVrVVZabFVSRHVpMEpTclBTd3JqSG4yNXhDc1pVbk1I?=
 =?utf-8?B?d2FHS0x6N1JLVk5ibDVtR3N2WjM0TUhJYTY4M0lSR2VNYVhDa2tiWWRwZjZq?=
 =?utf-8?B?VFNHTWhJZ01HK1hlQ25LQllUNHhrY2tRSTdOa3RYVGduUHl6d1Y4dStvWHFu?=
 =?utf-8?B?S3FjOWU1a2JQMWN6cmZSRFlXQnJpSkZNOG1vZnRTUmdSYUtWOS90Z2pnQU00?=
 =?utf-8?B?Vlh3bEptZ3MwbmhMYlJZVG5ESHpHdFJ6Sm52MklybTRCR1BYNnNIbzhRZEdk?=
 =?utf-8?B?Nmp6UitVaEhLeG8rVExDZzVLbU5RaTgyWUxUT0hLNFVqeWZudEF6ZFFSZGNP?=
 =?utf-8?B?dzdneG50b2ZONGd1Z2NOYitob24vanZ0VktsMEFiS3hYa3Via3pwVzJvVll4?=
 =?utf-8?B?SE9nVGFmWGNzV2p6MUYyZW9WUXhpYWg2TVFnd205ZnJFUENFSE5iRkpoblNm?=
 =?utf-8?B?R1dBRXlteEZSek9XcHhDOGcyZXFndDJUQ0puT3hKRlhRUHBKU1FhUlRQL21h?=
 =?utf-8?B?dmdkMmlxa1Q3ajNqcTh5K0RaanRHSDgvV0FGSmJyMHRmRFVlZlR6QWxsbEFz?=
 =?utf-8?B?anFjL29rSmIzSTQ3Y1ZDZU5TUHBwMlhzVXhtbmhWRGZqTUZ4ZDNkYjRWTVAw?=
 =?utf-8?B?TnRVVjN0d08rSXJGRFZNbnZMUHhPOG9tYlNZT0pYRTFGRm5ncldqeGhzYUVl?=
 =?utf-8?B?REVUQy9OV090cUcvMlBzcXpnUkg4Mk13YjFMMmdYM3g4SWhyeFRTaTNOaFc0?=
 =?utf-8?B?MWdSeWRJcUZEQTRPbTFIUURjblVaSkhVd0ZUT3NRTUo2cytCa0FaakhWdGpO?=
 =?utf-8?B?c21PaWp0cGxtQkFPUGNpWDFuSzNxTUs0c2w2bm5OQ29wbXVkYzlBelIzZVE1?=
 =?utf-8?B?aDFJdWFhZGlSMTk0R1FuTnhoeiswVlV3bVc4UlpFTU9DWkdoaUpNbVh4NUNX?=
 =?utf-8?B?NCtSOXRWSUZDSDMrZFJtZStENGRib3drNmdDWUtxcFY0K0c4bUl5SVdWTTVs?=
 =?utf-8?B?NmhxeEY4VDkrSDZqYWs3WVlqZ1RMWWs0d0hJQlQ2cTVEaGtHVUdndVE3dkpo?=
 =?utf-8?B?N2lLMjhuM1poVUhCZ0syTXA5VllMaWtmdWYrTDJTbVc1bStpbEpWdHlPNTJG?=
 =?utf-8?B?R2NENDVXTnpVem9RM2czUHc1VStidm5JSWR5WEtXaFV3NTYrZVRWSmdWeXIz?=
 =?utf-8?B?cDVnR2grb3FzR2RTOU9CMGljUCtnNXlJQmNWVEg4Q1M1QzBzbTZIYlFIc1VJ?=
 =?utf-8?B?ZDJJdXBURWVwejdjWEJKLzhCMzlYU3M0b084c1g1UWRWZE5SNmg2SkxsR25o?=
 =?utf-8?B?b3V6Vk5nMk1nPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YktudUFSODVWR0Q4SWRmVFYzU08xYS8wbVpta2JIemx3UlhjWlpVU0NxT0hB?=
 =?utf-8?B?Y1dQRlFxMVZ2RWFReVJNSGhPQ0hMbnp0YXpPTlR0N3phdmJyOUxIMFhRTEFE?=
 =?utf-8?B?NEwvaTBtZFNHVGZRZ1lTdkI0a0NoZE1ROHVXM0NXeU41NHlUK0w3bnZCbjNo?=
 =?utf-8?B?THpjdUx6UTRVS1l2V0ZOMXFyZDJkZjFTeGtqRWhqTU4rSDJNTVdHSmYzdzhZ?=
 =?utf-8?B?VmR6L1EvUWU3SUVBK1QzSVlOU3pSelMyeHBDeUtERlZxSHZFVkpkblpYMkhN?=
 =?utf-8?B?ejJteHlDc0RPMkxqMzY1b1ZMbnIyMjB2RTRnWVdJK1BWRUZXREJhWHhYbWlJ?=
 =?utf-8?B?SElVelFTUDkrc3cxdHQ2d0lQZVl0Z21KODdqbnQ1ckxTNngrakxwT3VNYnZV?=
 =?utf-8?B?Q2IycnlvbmxyUFFFQkx2Ri9YWUNzZHZFaVpIZGlqaHM4ejBka2FueGdRbTNC?=
 =?utf-8?B?ckppUkN2M3FOQk5yVXBuZ0Z6djFZeTJkSWg2N0JnMUo5Q0ZyRHUvamVxREZt?=
 =?utf-8?B?SmJ5bUJkN3dTcGdqRTV5eE5WK2xWZTAwRXpuT0RJenVRTFAvVVZXeWE0MjE0?=
 =?utf-8?B?eWdIOHhYcStid0JkdlZLRnJDL2x3aDk2ZGRYNmVoWEU5eXRYYmtNQWhtVTds?=
 =?utf-8?B?VDg5RXk1cEI3ZUM2Y3pKb2JnaGNPQ2VyZVJTVTBNKzVqRGd4OFNleDlOL0pm?=
 =?utf-8?B?Vk1SSlFkVTNrREdrandicTZyeDdWMHNBNXRpbmUvZ1BNYzl2SXVENEdBd0Rj?=
 =?utf-8?B?ck41SWhrMWNHZmFOM25oM21WL3lqcjB1MG5TajR4dC9Qb3VOUlJ0bTg3dUl2?=
 =?utf-8?B?d0tVbzVvSDU5enA4WlZEK2htOFA4SnduVTArckljZDNZVXhYd0RmVEZBdXcy?=
 =?utf-8?B?U0xBUnZTNFZDdUVYU3ovaDBqdjNiZDQwMk9nR2lWL2Z3V3gvdHl0bklNOXV6?=
 =?utf-8?B?NFdVYVQ4SHRuUm5oZmpqT296UHlCOXJhK05mcEF4UWQ4YWZQZ3pMVllRcFFn?=
 =?utf-8?B?ekNkUE5pMXRHMG5rUXpFR0VGS0NJeEtQNU13OXNlTktqRFZxcmRHK0pKdkVx?=
 =?utf-8?B?RGplV2s1SkxNRURNVGlkd2tGM2lKeWVpdUtZRUNRYnV1d1dMWVRYdlhJWUMw?=
 =?utf-8?B?UnNBY1FhVGQxR0hUckNSSmNZZzhCcVVPR2dOWVcxaFdxNGF0Z3JmV3ZQMmVq?=
 =?utf-8?B?NzRkUGNaL1p6UTR4VExpeUFWd1FFcVdWa3lheFFNc09DZ1dLV25iNXpLT0kx?=
 =?utf-8?B?UWZ3QXBnSklvTmJYakNQWWJyTGZ5dUhtdjlRVVNqZ1M0ZThKVCtmSTRzbWxo?=
 =?utf-8?B?UnE5dmVqUnMzKzErUFBNaDcyZU1WOEZ4R2NqVWc2d2Z5SnJSWXNOUlM1c01w?=
 =?utf-8?B?MFJ2VjNkdWtHQUFDN1k5enlnajRuVXp6cUREQVo4NytvdkEvRmFGbDNvYWRP?=
 =?utf-8?B?WGw4L1ltVmovSGowdFJqQ2ZxTmJFdXJNbTRLVGF0VlJLNk83Zkh6RUdkVVNO?=
 =?utf-8?B?c01zcUlHK28yNmFyaG10MmgySmhQTkFwTStKMUJCazU3dEFRUUJ0TThBVm01?=
 =?utf-8?B?SjRMMk9QSVdWd0V6a0xiS2R1bDdmcVh1UEIxOGtPUCtjSHg3TXdTeThhQ0pT?=
 =?utf-8?B?c2lacEozSElHbkVOcUpaTDhlbHVneCtPSWM2Umxub0NaUEFaS3pvSmdDM3NY?=
 =?utf-8?B?ZngyaVNyRFF6VGZRcktGSWk3TWQ2dzc5Q3RwNHRpeTJrdmZYMFFydTNYcC9M?=
 =?utf-8?B?SUJNRG9IWUVPU0dESUNsVnpXSEtxTjEyRXVHalI2eUxsdmVEUlJOTGFMYlk4?=
 =?utf-8?B?THpaOCtMWXB1Q2lUZ3ZlRnBtcVhHZUhKOFExeFA5R3hPK25jMFVsOFFRTHd2?=
 =?utf-8?B?U1hIR0ZpMzJjbFFuQUxQTjF5MExaNEVRcmhlWWdIVE9HRUJHRk45aEJ3MG04?=
 =?utf-8?B?UXBibFF4cU1zZU1pZUFHVDVYbHNjNi9GQzkwbGd2bVRPOXAvaHdpTVE0Nlll?=
 =?utf-8?B?bWpyZllEcXVMcDV4KzNXTTJRR2cyaUk5djA2eUNXMzUra2dPZEJmRWlmOG1H?=
 =?utf-8?B?MFFRbHhsdkFJNThBZktzTHdxVTBlRVhnZWlUaEdyT25EdEZ2MGhLNEVNbnRu?=
 =?utf-8?B?L0E1bjhVWCtOVUp1dmV0NVp2b0lBaE9vZkVLTEkzS0Jsd090V0dwWWZCV21S?=
 =?utf-8?B?OGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C0FBAC8D0524740AC4ED130D3045015@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59ae17f4-24ef-4d62-35da-08ddda037c41
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2025 00:51:06.0287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s+hYiBCyjfioCooxZLZ7Mf3Ib8FtH6XdVCZ716dbLxoZvJChTB1ZRu45WQ9EjKYFj/a9Eft1cJAJNh6ygASahaTdNkZSL9ESQCZR0rVOZtA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8309
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTEyIGF0IDE3OjE4IC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiBPbiBUdWUsIEF1ZyAxMiwgMjAyNSBhdCA0OjM14oCvUE0gRWRnZWNvbWJlLCBSaWNrIFAN
Cj4gPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPiB3cm90ZToNCj4gPiANCj4gPiBPbiBUdWUs
IDIwMjUtMDgtMTIgYXQgMTU6MDAgLTA3MDAsIFZpc2hhbCBBbm5hcHVydmUgd3JvdGU6DQo+ID4g
PiBJTU8sIHRpZWluZyBsaWZldGltZSBvZiBndWVzdF9tZW1mZCBmb2xpb3Mgd2l0aCB0aGF0IG9m
IEtWTSBvd25lcnNoaXANCj4gPiA+IGJleW9uZCB0aGUgbWVtc2xvdCBsaWZldGltZSBpcyBsZWFr
aW5nIG1vcmUgc3RhdGUgaW50byBndWVzdF9tZW1mZA0KPiA+ID4gdGhhbiBuZWVkZWQuIGUuZy4g
VGhpcyB3aWxsIHByZXZlbnQgdXNlY2FzZXMgd2hlcmUgZ3Vlc3RfbWVtZmQgbmVlZHMNCj4gPiA+
IHRvIGJlIHJldXNlZCB3aGlsZSBoYW5kbGluZyByZWJvb3Qgb2YgYSBjb25maWRlbnRpYWwgVk0g
WzFdLg0KPiA+IA0KPiA+IEhvdyBkb2VzIGl0IHByZXZlbnQgdGhpcz8gSWYgeW91IHJlYWxseSB3
YW50IHRvIHJlLXVzZSBndWVzdCBtZW1vcnkgaW4gYSBmYXN0DQo+ID4gd2F5IHRoZW4gSSB0aGlu
ayB5b3Ugd291bGQgd2FudCB0aGUgRFBBTVQgdG8gcmVtYWluIGluIHBsYWNlIGFjdHVhbGx5LiBJ
dCBzb3VuZHMNCj4gPiBsaWtlIGFuIGFyZ3VtZW50IHRvIHRyaWdnZXIgdGhlIGFkZC9yZW1vdmUg
ZnJvbSBndWVzdG1lbWZkIGFjdHVhbGx5Lg0KPiANCj4gV2l0aCB0aGUgcmVib290IHVzZWNhc2Us
IGEgbmV3IFZNIG1heSBzdGFydCB3aXRoIGl0J3Mgb3duIG5ldyBIS0lEIHNvDQo+IEkgZG9uJ3Qg
dGhpbmsgd2UgY2FuIHByZXNlcnZlIGFueSBzdGF0ZSB0aGF0J3Mgc3BlY2lmaWMgdG8gdGhlDQo+
IHByZXZpb3VzIGluc3RhbmNlLiBXZSBjYW4gb25seSByZWR1Y2UgdGhlIGFtb3VudCBvZiBzdGF0
ZSB0byBiZQ0KPiBtYWludGFpbmVkIGluIFNFUFRzL0RQQU1UcyBieSB1c2luZyBodWdlcGFnZXMg
d2hlcmV2ZXIgcG9zc2libGUuDQoNClRoaXMgaXMgc2F5aW5nIHRoYXQgdGhlIFMtRVBUIGNhbid0
IGJlIHByZXNlcnZlZCwgd2hpY2ggZG9lc24ndCByZWFsbHkgaGVscCBtZQ0KdW5kZXJzdGFuZCB3
aHkgcGFnZSBhbGxvY2F0aW9ucyBhcmUgc3VjaCBhIGJpZyBzb3VyY2Ugb2YgdGhlIHdvcmsuIEkg
Z3Vlc3MgeW91DQphcmUgc2F5aW5nIGl0J3MgdGhlIG9ubHkgdGhpbmcgcG9zc2libGUgdG8gZG8/
DQoNCkhtbSwgSSdtIG5vdCBzdXJlIHdoeSB0aGUgUy1FUFQgY291bGRuJ3QgYmUgcHJlc2VydmVk
LCBlc3BlY2lhbGx5IHdoZW4geW91IGFsbG93DQpmb3IgY2hhbmdlcyB0byBLVk0gb3IgdGhlIFRE
WCBtb2R1bGUuDQoNCkJ1dCBpZiB3ZSBhcmUgdHJ5aW5nIHRvIHNvbHZlIHRoZSBwcm9ibGVtIG9m
IG1ha2luZyBURCByZWJvb3QgZmFzdGVyLCBsZXQncw0KZmlndXJlIG91dCB0aGUgYmlnZ2VzdCB0
aGluZ3MgdGhhdCBhcmUgbWFraW5nIGl0IHNsb3cgZmlyc3QgYW5kIHdvcmsgb24gdGhhdC4NCkxp
a2UgaXQncyBtaXNzaW5nIGEgbG90IG9mIGNvbnRleHQgb24gd2h5IHRoaXMgdHVybmVkIG91dCB0
byBiZSB0aGUgcmlnaHQNCm9wdGltaXphdGlvbiB0byBkby4NCg0KRGlzY2xhaW1lcjogVGhpcyBv
cHRpbWl6YXRpb24gbWF5IGJlIGdyZWF0IGZvciBvdGhlciB0eXBlcyBvZiBWTXMgYW5kIHRoYXQg
aXMNCmFsbCB3ZWxsIGFuZCBnb29kLCBidXQgdGhlIHBvaW50cyBhcmUgYWJvdXQgVERYIGhlcmUg
YW5kIHRoZSBqdXN0aWZpY2F0aW9uIG9mDQp0aGUgVEQgcmVib290IG9wdGltaXphdGlvbiBpcyBy
ZWxldmFudCB0byBob3cgd2UgaW1wbGVtZW50IERQQU1ULg0KDQo+IA0KPiA+IA0KPiA+IEJ1dCBJ
IHJlYWxseSBxdWVzdGlvbiB3aXRoIGFsbCB0aGUgd29yayB0byByZWJ1aWxkIFMtRVBULCBhbmQg
aWYgeW91IHByb3Bvc2UNCj4gPiBEUEFNVCB0b28sIGhvdyBtdWNoIHdvcmsgaXMgcmVhbGx5IGdh
aW5lZCBieSBub3QgbmVlZGluZyB0byByZWFsbG9jYXRlIGh1Z2V0bGJmcw0KPiA+IHBhZ2VzLiBE
byB5b3Ugc2VlIGhvdyBpdCBjb3VsZCBiZSBzdXJwcmlzaW5nPyBJJ20gY3VycmVudGx5IGFzc3Vt
aW5nIHRoZXJlIGlzDQo+ID4gc29tZSBtaXNzaW5nIGNvbnRleHQuDQo+IA0KPiBJIHdvdWxkIG5v
dCBsaW1pdCB0aGUgcmVib290IHVzZWNhc2UgdG8ganVzdCBodWdlcGFnZSBiYWNraW5nDQo+IHNj
ZW5hcmlvLiBndWVzdF9tZW1mZCBmb2xpb3MgKGFuZCBpZGVhbGx5IHRoZSBndWVzdF9tZW1mZCBm
aWxlcw0KPiB0aGVtc2VsdmVzKSBzaW1wbHkgc2hvdWxkIGJlIHJldXNhYmxlIG91dHNpZGUgdGhl
IFZNIGxpZmVjeWNsZQ0KPiBpcnJlc3BlY3RpdmUgb2Ygd2hldGhlciBpdCdzIHVzZWQgdG8gYmFj
ayBDb0NvIFZNcyBvciBub3QuDQoNClN0aWxsIHN1cnByaXNlZCB0aGF0IGhvc3QgcGFnZSBhbGxv
Y2F0aW9ucyB0dXJuZWQgb3V0IHRvIGJlIHRoZSBiaWdnZXN0IHRoaW5nDQpzdGlja2luZyBvdXQu
DQo=

