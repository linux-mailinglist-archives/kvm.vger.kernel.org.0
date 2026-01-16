Return-Path: <kvm+bounces-68304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CD18D304C3
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 12:22:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B2741300FD7D
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 11:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8957E36C5BB;
	Fri, 16 Jan 2026 11:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bQZgYn8l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82434368275;
	Fri, 16 Jan 2026 11:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768562552; cv=fail; b=T9rUHfDxcTAG8F7VgxPttyCMrUBcfD1E4UXJghdOrE8Eg/yxHapYahvesnsrMgzCRPmQyoX3gjs5leT3WxSOllL39c3dHGKySLX46En0Oj+2LZHG7r17toVMK7VgihluBLcIRAaZIOUFaX6fXH1zXFunj114xywqjEGH/06eBKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768562552; c=relaxed/simple;
	bh=ufTm/1sy8+7lh3qNG0DqqkBjPYfBbMmFABw+XLp7hNM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Do4dIsbZNG1xFUTh1+Q2U/59JzO4skxOTx+OA69JVkiFgqi0HTaLCU7oPMysfsoIMRbmifDMwe/XwEBEf2FQEm2p3CHGb/PgOv2UFhEqeaRRU9mxAXNJlsMRlhj4QDmSkGUzuebrHUBpKs7kM9KKRhANZDBz6Sx2PtkW3Eo1Tvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bQZgYn8l; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768562549; x=1800098549;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ufTm/1sy8+7lh3qNG0DqqkBjPYfBbMmFABw+XLp7hNM=;
  b=bQZgYn8lw76vCh2csrB1jPBlPF/nGQxuto6T82F0P0Twft8pj9WYBQlM
   6LQguAdSj36sRxJlcIATyyGmGAUKrAYVYRCLVeFo19qE3RTQZXGrYQMff
   H7fFzhPMCb6FuchH1Vvl+orto4pzv9v2NU+cgwlCeDatd3fdX8vyYbjec
   8rKfKtZXWiSTUCBc/u37V7bfo8IByeznrx4pJPYfcV9hOT4fi0qrdt3CK
   xDpRXJ7C4vTS0+wZ1wNdBflyuVy1wwUlxS5iPKJ8w6wbiu/POPMiiYElJ
   bfyuDbE10IU6bpNyD2RdgUnhn+3d/iaQQ3fu2PFOMIQUHNhen0imiqWAR
   Q==;
X-CSE-ConnectionGUID: Lfa+UNu/Rda8WUhDO7oT2g==
X-CSE-MsgGUID: Fw/Z01IhQ56Ocrwdx1bMIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="70043998"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="70043998"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:22:25 -0800
X-CSE-ConnectionGUID: fTAghn03R8G9o/JO2KJQsw==
X-CSE-MsgGUID: f7fmWDADSK+23gAz4fNpFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="204832566"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:22:24 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 03:22:24 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 03:22:23 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.0) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 03:22:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DgTtMaUBf+xUOvPhARFMT94lNU47Ul+FA/mKaonv4cflguH3eqPmcTqzUzN0qYzmM1ytFGw+3/tb7wznKaNejAv6tdI3eitinbDQnENgzdqCh98R/OtQbTu2cFnnjooqWvmxIaj+rZsWUtsxJhx2oT2iD4gFTfzOAVb2MET1JMQZq7+c/u2mv9kOUKy6GwshfQ4EWo/EuqvHallTzZ9ryPq8ykPJh9kgn4QYgOf5k90+6NCtlmjKYDBkT6nDQZuIWjKF18n3zo5ojGn7zaCA0eLAhyfXKd6moc6YoKRfpORnXJD9/BSXHD477k7bdGZlW9h60VgEFK1YxE2NIs02UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ufTm/1sy8+7lh3qNG0DqqkBjPYfBbMmFABw+XLp7hNM=;
 b=J0bNQt5DkRnhD5k94YWZ3H9elQDXwL2PB+kUnZ/RsUqPPlhHyNx7hFSOpcxeiaHx1O/VmftRpBG8kB07C0ZOo6YIbJgPZzYuZ/NWuMKDv6Oec+NEqMZYCum2rrtFg9XBSuK/d122XKl8JtBLNEdMgCf2+xonx4qwfcPdWqJg0T3XLdxp7c1B79CtWaBL40N9KTuGHYgkIBL/sgg5wniaZAj/Vtdxwy91n1g93ANjubxTqne7Z/RCsP8l0a4fIobNr2CKKgPnS9QPJkllHbvDwS7VJE+Cfqbj4TdiCVOgSdCVSNkCW0hE1YEdZLYtqJ7l1m8iICMaojZuZdYGiiWeNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 11:22:20 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9499.005; Fri, 16 Jan 2026
 11:22:20 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Du, Fan" <fan.du@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "david@kernel.org" <david@kernel.org>,
	"kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Miao, Jun" <jun.miao@intel.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 02/24] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Topic: [PATCH v3 02/24] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Index: AQHcfvYqSBTaRjpSZEO/4jcRgCnGbrVUttGA
Date: Fri, 16 Jan 2026 11:22:20 +0000
Message-ID: <96f5c9d2d27b151d2d1a753ba303f2ef1f187049.camel@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
	 <20260106101849.24889-1-yan.y.zhao@intel.com>
In-Reply-To: <20260106101849.24889-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB8107:EE_
x-ms-office365-filtering-correlation-id: 5b87ce89-5d1c-495e-4c4c-08de54f18375
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?V2RnblY3Q1UzY3ZTeHU2VVJhSjNsdTd0MXR2L2hYU1RIRHp5WStvS0hLQUV5?=
 =?utf-8?B?K0JzN3FidDcwUHlFcDhIQVdqUkhJeHNQVWhpSWxLaENCemVUOFQ5aEpuSUQ3?=
 =?utf-8?B?Vkp2QWtmUGpXbTloT3FtYlpuNm1mRmlNaXlzdC9TdThpWUdoemllaUxwaXdP?=
 =?utf-8?B?cEUrVHpVUVdFV0ZPNzkxOUdTbkJyOEFNcE9kdHBkS1Z1WjlvYUdiME1aWWZC?=
 =?utf-8?B?WS96b1hZNjEzZUx0UWhLUFZrTFo5b29aM0FEWTNITmhWVll5MVJHaHNDSDdE?=
 =?utf-8?B?U1pocFZES1lLTW14RExPbDJGc0FyRDdIcXh4TzFSd3ViWnNZZjF3b1dMczBn?=
 =?utf-8?B?RDNBdHdhcStGSjdxTkh1K042c1JEZXorTnZwS1dvdnRqaDhycnl0bkJYWVlo?=
 =?utf-8?B?OURLYWI3YWRYU1RuOFZibG1FclpXRTZrLy9LUmdGcUMzWlBMbGtScWltYW01?=
 =?utf-8?B?b1BybHk1aE8xTHUwOFZxWjdLQWFXV01kTnEyZllRcW9VbzhnZHM1TXhKTXV0?=
 =?utf-8?B?dVEyc0lPVjhObU00S1RvNTNsdW5SZDBzVG5pS3pTem4wUmZTYUZHcndoT3A0?=
 =?utf-8?B?aUVTTVZhOXg2SDBIYllvM2FhRFBDcnVwdjhraGRqZjJpSVo0eEQ5NHhXRWFp?=
 =?utf-8?B?YWFDUjZ4Z29zU21RRUJWTkk3TVloZXNPN0F2RFJpaFE2S0lqS25KQ0ZBS3lR?=
 =?utf-8?B?VWlGKzRIZm9Pb09rSS96OXZaYVltMldreXVuYXR5UlNIYUdxWlFKR3N2TGI3?=
 =?utf-8?B?STNCL2JYZGZuTDE5VXpKWTdKaDBCY21DcC84K2RMekd0Qno0Q1dTWTQzM21O?=
 =?utf-8?B?dlNvSVJ0WWljVUVmazBCcmhRUi9VVXFZWko3eXhrb0EyU1VtS3pvVHBneTlp?=
 =?utf-8?B?b1JzV29NKzBjRjkxd1p1dXFweWd5MU5VTitSdTRmQ0NBM3NDVDBGUlpJT1pj?=
 =?utf-8?B?SUhLTklmY2JLZ21oVllibHc4NG9RbEZJMm1QRklMeXNzTXZaM1ZKYmtWamo3?=
 =?utf-8?B?cEV4S3VXalcxM2VFSitnUjd0VXJHcGloSW5pc0NsVFd1ZW1MRlJOclIwVFVC?=
 =?utf-8?B?Y0djam1sczk0UDFrRmdQcC9wZDNnRWtCcFZWK0JGU3owV0RLOUxidDJuV2J6?=
 =?utf-8?B?Z05xeWFvSnZJaUl1UFFFck1YVlBET2VUczN5akF3SUQ1TU5OeHFiS2N5UmNs?=
 =?utf-8?B?MThLVDBPUk5XZW45cDFlQUFQZTFTekNvaGdEYW1Ta3VWYUt5eHNDV2RwbXdG?=
 =?utf-8?B?ZkdwVTVhcFpkbzR0M0g5R0gycGl0K3hjTDR0aThJRDdqdG5aaS95ZEZnZnhK?=
 =?utf-8?B?RWU4NUdoOUdQbDdGRFFUOEl1NjVRZ2J0Nk1HL0krMm5UNE5nNU9CZkFWaHNs?=
 =?utf-8?B?Y1ZOREx4V3J6NnkyakNncVY0MmFXOERsMXZ2YmM1cmhERUU0NlhYdXNnLzFu?=
 =?utf-8?B?dDNpSzd6ZWRCS2U0VTB1REtCRm9RZmlqcTI4WS9KS3JLb3dMQlZPcVNtQzJD?=
 =?utf-8?B?UFBXVW0vWlNGK2llSUI0bXpUS1Y4TytYc0xVcjNCdlY3TjlaQXdTTmcxL3lh?=
 =?utf-8?B?Tjc5YjN3TUd3LzYwL205MTRGQ08xeUdUNTZRSDI5M3ljRTNZb2s4TFdWTnBp?=
 =?utf-8?B?RzZZWGMwUnZwVitiWmU5bUNoOEg2RzlxMnU0RHhiUS9VNTE4MTRuMlRzT3Z2?=
 =?utf-8?B?SEtXK0NQUWJEcmlkdUQvUFlxNFhRQlVWekd2U0FxWSs5S290cDB6Qnl4Z1lU?=
 =?utf-8?B?QnpSM0NVbE9BM285eE9lbE9QYU9Xd1V3akthb0t5dXRmSUhHcXFoVmdRV0Q4?=
 =?utf-8?B?a24yZzArOEVXR1hYbTJtaUlkRG91c3BOdndCdWQwTTN3UEdEaS90QkFnUkVL?=
 =?utf-8?B?ekExRjN0OVpRVVBVcFFEZWs1Kzk1NlpwMFhDMGtleUxDR1FZWC95OU5VL3Fn?=
 =?utf-8?B?YVpEendjRzhmTU80M1krR3Y3UGpCMWQ5WmJWNjV3NnpmRHM2TlZ3NDJheUhQ?=
 =?utf-8?B?SGhIdjZYNzBGMFljUllFVzIzQ0wxRXRDTzZiL0tlRk9IRFVwenIxcWx0TXVy?=
 =?utf-8?B?RW42N1JQdlZ6djJVUkt5bUdZeml4UWlBdW9sQVFKNEJVZ054L0U3ZGlBdCti?=
 =?utf-8?B?VHUwOGdJWDNVMm85M0Fsand5OXN2VGZKd2g5Qys4a1puWjF0S2VodnFyZDVn?=
 =?utf-8?Q?Lc+nNsf/Ki5VdexLkjGyqlk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTQvYkRvZ1ozenpuTnJyemNYS0RRNVhWZTBkamNHVm9TYnJHMDFJUG9HVERy?=
 =?utf-8?B?bnRCTFp3ejkwNjRpb0crWFI5YVI0bVJKNStidnRWTXpDc0FrcDcvTUdXSFJE?=
 =?utf-8?B?aUViSC9kaG14TW1OcjRYTDR0YjZLVThuN1J2OTBDOW8zbGFDWnRkTFBqYnhp?=
 =?utf-8?B?dkVmS2M4TmZLV20zVUZrZ2VUQmtJZzlzRnppZFNoYWxmTWIxMjMweTlyYS9V?=
 =?utf-8?B?NTZubEdCNEdBNjZtV0dDUVlNNmZjYnZWakZoeGRJRFkyK2pqeTRnNGhjRWpj?=
 =?utf-8?B?WGJESjhKYnFBMHlJYk1zR0pRZzNTVHhtUWMxaFF0REQwRmJoSVRLR3kyUHF0?=
 =?utf-8?B?Qy9LZ2IyUndiaGlOWFROUWVxUjBpeS9NZVA0LzJzOUcxSWs3Vmd5d1l4dE12?=
 =?utf-8?B?TWZaQXBGeisxQVdtMUtiZG5DWmwvbFVrVDlza2E2RTM2Q1NMc3NYOTdCUXhn?=
 =?utf-8?B?QjZlT2dhS0wveUI1S2hxNEwrRnIvQXVRcGtudzhkeDhNdENpbnRNeENZM0d6?=
 =?utf-8?B?Q01nZEtBc1J0NytzWkV3Q3hPTGpXZnpBY3QwRGQySXp0dUJUYTBVZ2o5QVl0?=
 =?utf-8?B?OGwyWDJQNDZpT2Y0U3AxcHhzMUFoTE9vQzBQMFF2QmRjN3IzSVdtaTZ1akdD?=
 =?utf-8?B?VzNNcGRGY3NTOURqSmJ4R1J1NTQxTWVGZVlDdlM1QUh2R2t3ZUNub2xWNytD?=
 =?utf-8?B?SVA1V0hUbFo4UW1kQURPbzY4QUJlR01POFRTOHpnVG5sdm1FbG16MmVRK0Vl?=
 =?utf-8?B?R1ltRmpZT0ZsM3RSeUZHZm1tNEpyVk5CMTUxb3ZWZVBqdUJScERCai93OUFO?=
 =?utf-8?B?WkFwMktKWWVRSlRJdlc0RVBzNTJSTXd2cmhNUzJrWGlOUE9HQkp5M1FyNXZs?=
 =?utf-8?B?VVZsY1VmYnBlcU44dWE3aDFraWpHYjhEeDdZM2Q4Q25yMXZXZUxNa1V1akps?=
 =?utf-8?B?NU1XQ0lXSjgzU3U3TlBjQ2k4d1NLOVNBdVpXNWZOT0lGTkkxbGRKT3RRQU94?=
 =?utf-8?B?UU5oSWN5TTRrbXJWZnJpR1FIYUhKVHlFQWdxZFlzckVpd0dDVElLdUljNFNu?=
 =?utf-8?B?ZmRpUDRLV3FJamZyN2lhbmZ2bisyalhoY3l5K0thNDVod2xlUjZ2TjFUUmow?=
 =?utf-8?B?V3F3cHA1Z1hqd3BLOTl1cnEwanc5dmQ2MDZZU2YwNkl5TWdEOW42bG81RzhB?=
 =?utf-8?B?OGxyY2EvQ1hLZXJRTnFMcVd4aHFWVndPSURYRXZuMnN2ajFuWlZjKyt3RVMw?=
 =?utf-8?B?MFJvaHAzVWs4RWc2ZndVREwxRCsyQ3FyckYycmgxOTg4cm5neXhUWkhkUGVo?=
 =?utf-8?B?SVpRRU81REdMNHd1TkVHT2tpQjJyZVhmaUtoQ1BnVTZHb0tSVkVqckZCUGE3?=
 =?utf-8?B?K0thWVgzOU1oS3UwTXYraWNLUG4zdHZ0anhGdWJjTUJETmhSak5wUExjME5M?=
 =?utf-8?B?VXlWdCswUE94RUVQejBiS1NxeDBVT2lqU0xBckE4VW0veGk1SnNhU05pOFEw?=
 =?utf-8?B?NjQzTzV0RjFZK1lHc0FDbDlhNFhLQmVoT1NzZmUyNmpOY3ZBMVVqMzlESmVB?=
 =?utf-8?B?NzFCQURhN2Jnbk52QTVPb1lkN05lVzhQSjNGSUxxNTZ2eHRUWE1XL0RKbHhZ?=
 =?utf-8?B?QVFvenRaVjZtcWM4L3VEUm5aRGZsVXNqM3YycHM1M0Q2elA1WWxZdEVUaU5l?=
 =?utf-8?B?ZmdvWk9WNlViNjY0Q3Z5QVBRZXFMeXltY3hwWDlYdTl6VXdyVi8rdjVkRnIy?=
 =?utf-8?B?eTRFZEFla1pNeGdBODVkMEFmS0l3dW1SZ1lTOHpSNHB6TUlPcElHSWN2cHNr?=
 =?utf-8?B?WFZNWm53V05jbDAySW9kL28vOUZrbUk4NkpVNlNMVFN0MytudjRMWURENmFP?=
 =?utf-8?B?cTF2bnZZUkRIWGIrN05hQVc3S0JJTlp3b2N1WUFzSU02S2Rua056dDFQa21G?=
 =?utf-8?B?UGlmNmsrS3RtMElDcGwrbTlQQjRmUEFwcGU5MG1JeFppMnVKZlNxNElaYy94?=
 =?utf-8?B?QjA3NjAvdU5NNU4zRVphZTIxaXdNWDBsRFZpaytaVWM5MnJpQnFzNGZzeWs1?=
 =?utf-8?B?MkVTN013VTVjd0UzZ3FiaDFaNE9oNWJBNFpDRDUzcTNGWW5CQUlJNUtFa05o?=
 =?utf-8?B?OThjY0tsWHpJMkNRS2FNNUY5SzFNaGF5NERTM1B3Q2xzNzZDMEM3LzEvdVF4?=
 =?utf-8?B?VGc0a1Z1Tlh0MVVLSzlQczJyMjFta3QrSlMzZlpPbEpjVGlhNVlBTnI3NE5r?=
 =?utf-8?B?WXpsRmV1L1lZckFxaXhTekZseEdUcE9Mbm5MMW9ZNk5hdEg5OUNqK015d1pL?=
 =?utf-8?B?elBoVXljYUMrMmRRSVFRT3ZQK28wNEJvY1p5V2VMeXlpRmlaTm1Tdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BE441836D9F1D49A940482FBCE1FC4F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b87ce89-5d1c-495e-4c4c-08de54f18375
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 11:22:20.2169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nrixMx+ZRk/1NIgcLlhR8nEbRJ2pUmhR4b1AnzwHkEoSvVesi6iEdd+kuKtgSbHudsNGLAp6rYG30/9+anZHVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8107
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI2LTAxLTA2IGF0IDE4OjE4ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gwqAv
KiBCaXQgZGVmaW5pdGlvbnMgb2YgVERYX0ZFQVRVUkVTMCBtZXRhZGF0YSBmaWVsZCAqLw0KPiDC
oCNkZWZpbmUgVERYX0ZFQVRVUkVTMF9OT19SQlBfTU9ECQlCSVRfVUxMKDE4KQ0KPiDCoCNkZWZp
bmUgVERYX0ZFQVRVUkVTMF9EWU5BTUlDX1BBTVQJCUJJVF9VTEwoMzYpDQo+ICsjZGVmaW5lIFRE
WF9GRUFUVVJFUzBfRU5IQU5DRV9ERU1PVEVfSU5URVJSVVBUSUJJTElUWQlCSVRfVUxMKDUxKQ0K
DQpOaXQ6IHRoZSBzcGVjIHVzZXMgIkVOSEFOQ0VEIiBidXQgbm90ICJFTkhBTkNFIiwgc28gcGVy
aGFwcyBjaGFuZ2UgdG8NClREWF9GRUFUVVJFUzBfRU5IQU5DRURfREVNT1RFX0lOVEVSUlVQVElC
SUxJVFkgPw0K

