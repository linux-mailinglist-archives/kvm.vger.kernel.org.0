Return-Path: <kvm+bounces-64571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D7EE7C87506
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 23:30:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C44EB4E7593
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 22:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DAC62E7F29;
	Tue, 25 Nov 2025 22:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iTNhBLzg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0633016F9;
	Tue, 25 Nov 2025 22:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764109817; cv=fail; b=br9QzSzmim9P8u94CMzw2xkJemdiDy8+a+R3TugcNeg+lWBm1bZViKXGshEsS7o7n1LypeX9EOvmL7d8psvBBvPCEnt/f8Uha0mc1udI8OwsSoM16FpYBUmnz7bpyKZNZ6eaeVlYcfPi2DHWg4ggLsib4kAQ7wZaqahHSQFnReY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764109817; c=relaxed/simple;
	bh=ztPT/34h2RtTPecxwbhusCAT+0g44n6HKaOzelUMzFM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ut16ioV1FD7st9/hVHTjRJg9O67QeYZKFiyaXC6Hzml6P6xDwODuN5rPuwCluln59XUojuB/B4VKZBwDdLPO1+Sd+v/RtBU21zv9wf8IuVnlGNbcryj2X8ql+RMDqumf87vwvHF3Ddmcc5T9XFV4rbTOO12xP1oNulufkNqaF9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iTNhBLzg; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764109816; x=1795645816;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ztPT/34h2RtTPecxwbhusCAT+0g44n6HKaOzelUMzFM=;
  b=iTNhBLzgrwmF5dX0KyGaN1ayXg2tm52ZA3nTmAM7TQRe8g8chmGxp7Qy
   QxwUzCW0u0QUe6ItpMUXnvC4h57Ujs/Qz8tphDPgj3eh0LRjXvN0Z4jt4
   mhEe/iTrIf4g0EbD5KvoEK2LKc1+cb84tlKVouOlbDVczYZASTnd4nnLQ
   1+zIme3PzY47yBGLS0tlgGF3XkLd5HlvjbiZAhG8tavG6H71sEMhWD4xy
   JdZgBMhQtg9Tr9QZE3SFAHZEyqUXzig2aTW+PORQN42MSR50NUlsoTsCP
   yX7MdZuHtAh4JXp4yXI08+IkxRKZUk4/ZZQV3EsuuTqy0PA3x+uWAgTXO
   Q==;
X-CSE-ConnectionGUID: dKrh1B4sSiqat69WhQ0Hrg==
X-CSE-MsgGUID: KHVLqLguRRq24IXKnQKtLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="65848207"
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="65848207"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 14:30:13 -0800
X-CSE-ConnectionGUID: /j7ucl+qQWWnMJZsNc5s7w==
X-CSE-MsgGUID: WLCisWzzSMSL+4aM59FXhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="192413661"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 14:30:12 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 14:30:11 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 25 Nov 2025 14:30:11 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.50) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 14:30:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m7xuHFqKEM+oLCkuN9LOUCXuZNiDCc/VtkZkIwj7PeMVZ5S0KkmuuzGvhbilZxzFJocL+U1o5NmZUrMFEXpG1OEcbi7f149H5ccyZbfp+WWC9OFsyU0/kliuSTstdaHhpgBomDioplVWMjnnFKpqB+XFRWAQmO/aPsloFLEvhgKghkV0+LzVdGt4JHJCO2LbAZYXUc33ZRwV/zJyH40ifztU2hnGzbW2xHA/7hhH06ZXhPcSVZEjg4F8nzO/MEBuIWyJPyqlXGmIiPG/7S5Rm19Kyxpqfq48tIG6MhiUMGhluRsAxj67y0B1TClBJiL+ioH/2NFh3mg8lAnVEKufXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ztPT/34h2RtTPecxwbhusCAT+0g44n6HKaOzelUMzFM=;
 b=CbJdXTo8ZB9KGGN+XD+wdSEHAL3ADxWgXPplv6plFnZ4fUbt4HButGXUWIIOsoQ9WQ6nVIK3JL5Q2akWcBga0F59BiQzlpExeKeSBR417KXGTrHIzcUPM/iJO7PvWS3J8GoyMbxYmgweSW66bkElcNHFncHhiKTjFNluL9R0RuFLei30hiHTkXdShoANgXvoset9oTgac7JebgqqLRMinlrIQod+i+znaT+iVfxEFnuTAqIPgJZYet3UxL5SdM3EX6gYyWVIB35lVSTcfKPZEzZvkdB1lb9bvN8IErWfid2RFkYMQ8catDv72VQc9Ng4eLOd38GkKYqkPZI3bmSkDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS0PR11MB6445.namprd11.prod.outlook.com (2603:10b6:8:c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.16; Tue, 25 Nov
 2025 22:30:08 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 22:30:08 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen,
 Dave" <dave.hansen@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu,
 Binbin" <binbin.wu@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v4 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Topic: [PATCH v4 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Index: AQHcWoEIAFaZsBBWxE2dTZ5VmBGiMLUEARWA
Date: Tue, 25 Nov 2025 22:30:08 +0000
Message-ID: <6968dcb446fb857b3f254030e487d889b464d7ce.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-2-rick.p.edgecombe@intel.com>
In-Reply-To: <20251121005125.417831-2-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS0PR11MB6445:EE_
x-ms-office365-filtering-correlation-id: 3cc325cb-9b45-43fc-ab96-08de2c72309c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?MjgyOFNQTEwwQVNLSCtsUk9Ba0hFVU1WUTlpV016WlVwLzQyMDNyREZEeEUy?=
 =?utf-8?B?eW5qaTZMeUVaNUtPQnpDaWpTYWphMEVzZUF1eWp2TC9ydVcvbmZQUFd6NDRj?=
 =?utf-8?B?SXhCUkdVbUphZTFla2F6UDVUTFF4SVNGTlhSQ01nYVgvVjY1Q3VBQWMyV2Jx?=
 =?utf-8?B?U2NZS0hEZkZYaVgwcmRwWHh2ang2V2g1M2xJaW8wVHJ5TmhMM0lOWk5NMWY5?=
 =?utf-8?B?T3R6dEpmZkpDeko5ZWFHRjhUZmh4OTZ5OUdaK3krOUVBQThiRFZ6RHdrcURp?=
 =?utf-8?B?TTYxbjhyam52Z0dGbXc0WTc5TVhMRVRxQk9TMWdBTGRkV244QXlaRE9jQlYv?=
 =?utf-8?B?Q1pkNFpuVCtUcTZJVFJSRXA4V29wbXRlT1RNTHp3Q0hNRFBmK1pQVlE0MndK?=
 =?utf-8?B?b09GSUUzQ0ErSE9jaThnQlBBb3dnZ0h0SWhLcTNDZ1dXVldsTi9NTWNXblFL?=
 =?utf-8?B?U3NWTGgvVHcyRThPaFpNY1BHRzBXWmhDZkdPRW5keGtjR05BZjNWSzYyWlhs?=
 =?utf-8?B?aTRGRk9pamV2RUY5RVkxV1JJYU51c0oyVUtNR1FCZnc0YWk3djM0RDZxYXVz?=
 =?utf-8?B?UFV0UitsbCtNMTB5UHVRYklmTUYrQm5JN1F4aWppaCt0Sjhuc0hKbnA0cEJa?=
 =?utf-8?B?NHFZaVlsU0E5ZFZMRTRha3lVTkNpclFvUlZzTmN4M0hHQ29XR3JUNUpVUlZV?=
 =?utf-8?B?ZHhla00ralE0YlFNTHJFdEJJUzBibXhZZ2pjaDhFWHp6YUxTcTNORzBOVFdy?=
 =?utf-8?B?aVBPUzJmTHVYRTZTTEIrQlFsejRmbXd0cVVGTnVxZ0RleUhEQkpPcnpMOUtD?=
 =?utf-8?B?dmJ6T0ZqcmVZTTVUYmo4SlNscUY4VFlmR3IwK1R4NGlMNFY4T2c4NGxrWXNT?=
 =?utf-8?B?UGFib0M0WjJCbURqWVhYV3greFhSN2h1Y2pDSEsxYVRhMUFldERoVlI3RlhI?=
 =?utf-8?B?SW9MWEM1V2NMY2kvOHRQY1RQRU40Ym9wa3h6Y3p0QWd4UXc4Qll3Ym95QnFK?=
 =?utf-8?B?TmF5TW9zdmk1emFtV0tSc3VvVnpuTnRkQjBUcE5kSUdZOE5XYjZwS2x5TnZs?=
 =?utf-8?B?UVA0Uy9TekhTOWZBbWw0UkxpZ0VYQWRmOWV4MFBnSnArSTVwdzdHT1pMRFI0?=
 =?utf-8?B?NFlCeGFIb0EvV3dDNDBaNnMvZk8raU1BUjRhVnVoaXB0c0VRNWJSb3hZWTZY?=
 =?utf-8?B?ckxOWTdsKzVtR3NhU3lTUjdEUzdISFA5d09iMGlneXNYZHAvUjNmbFByWGpC?=
 =?utf-8?B?NTBCdDlwcHgveUN3MlZJRzhvNEhwZC8ya0t6b2NUbUF3Q3FQakIzckdKbmFX?=
 =?utf-8?B?azg0bXFmVkFmR1pCUDI1N0VHODJKUkpMWVJSS0l5TmtWbGpZZHh4TDl0NTQz?=
 =?utf-8?B?b09sVGVRS3lScjRpYWlzOTJJenJoRWZieHI4Y29QZGxlNTMySjBxS2lER0g3?=
 =?utf-8?B?YkFLWHBlZkVqc0s1dXFqVmRjelF1bzU3Z0RzdXd3bVRvWElYVWdVdC9zTGJv?=
 =?utf-8?B?SkV2RVBMbm5hZndXeS9HcnJYTkVJVkZkd2lzc2dhMkkvbk81K3BtYnVoNWNv?=
 =?utf-8?B?ZHFqOVhELzJGZTdyM043OFJWT3ZManMrYXhYdGg3K0FKd0xSZ3NxM1g1NmJw?=
 =?utf-8?B?QjBNQUFReU1pRDZUVmpBVEFIVG9WNEljT09waWZjK3gxYVk3WVZjSUdCbGtF?=
 =?utf-8?B?R3lEcVJtMEM5YkUvYVZncGlIaTZaMTRxV3R4Y2dJZE81RlBoVnUyc0diN0Nm?=
 =?utf-8?B?ZkNubkNmUTZielVuUWpIVEVxNE9TRGhCY2ZMOElIV2w4R09XL1o4UmxGY1F2?=
 =?utf-8?B?YVcwcGVzTXJ5K0NJTy8rY3lnOS9iWDJlMXdSYnFiSmFTaDdmcHhrY1RPblA1?=
 =?utf-8?B?M3dzb3JHelRBMTB1dFhrSzlFdS9SSWxxcEVEL2wybUIvbXhvUWUxaEQya2Q4?=
 =?utf-8?B?dE9YNDZNa0poNjlTTEl5LzEyOHdnanI5Snl1c0VCaWxoSWUydVhwa1JSRXF0?=
 =?utf-8?B?TTRJRm56dFZCdXpxQXpjK2tPbk1rZjlXanBxd2oxdzRnUE9QWERnNkhUYVpx?=
 =?utf-8?B?b3JsMExTQ09MdG5PUFcvVjBpbHJjVWUzVlFEQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTMzT1lYQUdxWDRWVFdNS1hmUkM0M2xCZWdxZzQ1NFhNWGlzd3ljckRNaUlJ?=
 =?utf-8?B?OXZYeGVYY0JtYkt5alNmM3NkaHo1QmU3azNQaFFPc01yNVpYak4vTC9OWUVi?=
 =?utf-8?B?OTM3aE05dkoyaHpEaXVCQ0twbk01R0cwTzVtemZLeGtMM2dKV0F1TDhzRS9I?=
 =?utf-8?B?OHRFeVF6d3UvVkQveUVWZzNVdUtoa0RjQW1OUEpWUnY1akxMUTJiM3NwV08w?=
 =?utf-8?B?QWR6TWJPYklJelZEaHM0NzdZdmk3Q3FYbi9Ka003c2VaRGRzbXc3MWF5QUM5?=
 =?utf-8?B?MG8xRnN2cDRGSUVVWkYyNFpXanozbGREUm94dFJyTWtoM2U0Y3ZlcW5hKy92?=
 =?utf-8?B?YTREajc4N1lZcHRJa1RZMzhvVzUzTk5GMlU4OFdtRy8vMHdYU3dMSHpZayty?=
 =?utf-8?B?YnozTTlvcFVueXlVRjVKaDJvM0dEbGlHMXV4OGFxQjVqQTBUeVYyMXZsSDJJ?=
 =?utf-8?B?RlVxNTlKcDBaSytHNzNGNitYY1VDaWZxcUp3SkNKMzg3T2tVbG5uMFBKT0tU?=
 =?utf-8?B?a202UU1kTVlzTC9VUnhoMGwwZGNOaUsydGNWbDlWRWU5Q0F1UWFMYWN0REhM?=
 =?utf-8?B?SlVkWUF5MFZRbGxQNnB3L3hhYVVjZUh5NWVVKzQvdGhzMzN6aTI4VVQ4UFNV?=
 =?utf-8?B?MHNVaUFlTHpoUDhVeEVtQlVNQytuV1NZNWdtU3pmNVFPUi9SUnMzWENwOHFP?=
 =?utf-8?B?c0l6T2ZibXlqZEFqR1lsa2lucnBPTUoxenlUaWd3cDA0c1A4Y3ErVFdLakNE?=
 =?utf-8?B?c0pkUTMxVlJIRklIaDYwVDVHRTh4ZDdtYWRzc2l6Sy9lc0JBclRDbS9DRjV4?=
 =?utf-8?B?dlB6NHdId0FsNUJRQy9xeVhkdWNKZXJLNjFBem02Nm5vbGJsWC9lVVBpc0FM?=
 =?utf-8?B?cVl0L1locFlHb1FxeXg4aHgwU2JuTWhod3plSmFaWndnL2R0UnF1ZFBtTUFQ?=
 =?utf-8?B?RjdEdEpSU2l2NFdSTHpwVCtBY2g2Q3N0MElhcnJRbE5RRFVJWlF1Tm5KRUw0?=
 =?utf-8?B?d2h1YkVadlNJeTVHemhQc09Gd2FPTjBLWVJLQ1FJdXFkS01GSGZvOUhEb0Yw?=
 =?utf-8?B?cHB3RWVtMTdqUitjZEdGTjd2NjBzd0l2M1dEV2xhU25rc0J3ekJSZVIwTWZh?=
 =?utf-8?B?cjJwR2h4bnRDeXFNR3FrSktyMWxocWF4OEtzekx1aU1NaXd1MlcyR2pFelhK?=
 =?utf-8?B?ZVJMK2tOc2N5SWVhZnF2VzFOMDZ2ZGViRmRsejZmWXZlN2pXUEU0b1lIWVIw?=
 =?utf-8?B?U1J1TTlobnROU0tZd0ZkQzkvOW1YeDVSaVJ1cXkyVnpZQktTN0o5YkpucDRX?=
 =?utf-8?B?ajUxR1Y5cENDU0lxanB3Z29nVGpXWWpuOTl0VnZrTkZsT0RLcGwwMGRCZ3Bh?=
 =?utf-8?B?NlVtMFlvem1BeHF4VkhYWVA2OUhZeUZYMlJaZzVJZVlLeUROSXJYMFQxM1g5?=
 =?utf-8?B?QUVDaG45TWE2OTRSTHE1M2Yyb3JOd1U2M05LNS9VNTVXK0RjNWkwWndYZjFW?=
 =?utf-8?B?MVpzekpaemFvcUwySy9mWjluN25hN3lTMTZ4Y2RMdUZpaXNZd2NKN3hISkYz?=
 =?utf-8?B?bVNqYzZ4dXp3THdlbnRONjQwVkVjMWxRbG9HSm15NjFBM04wbGtlNGhoRG5r?=
 =?utf-8?B?TitkamZXV01KZWtNQThTUnM4TXJURksvdXN5S05JVUNqblVMR2U2V090a3F5?=
 =?utf-8?B?a2UvNWQ2OFR3c3E2VE1iTGlPd2c0ZWNKTWxRZEMvdHBlanZhN3dXOXl2OWNB?=
 =?utf-8?B?bGhjMGFFaUlOejBSM1Nqem5TMEt0c1ppT0g1MGNLODFMc0xjRzRTaEZ5WDVY?=
 =?utf-8?B?c05sa3VNTWtSQzVsRzU2UTJOYWNyem4rVWF3bW9UcDJtYnkzb1FRMllHMThS?=
 =?utf-8?B?WXRJRGFJNnRNdDJoMGppdGM5TDQrUGlqaTdWUkc2T0pUUUxLeG80ak10c3pa?=
 =?utf-8?B?cktyY21ERm0xV0tWbkllSjd3NG15aVFzalc2VWpmcG5kbE55bE4zYWdvUEd3?=
 =?utf-8?B?TFhxOU1jWHBzQXg0WEFLWE0yZVAvNDhsa096WmtRRFBxaWh3L0VTbmVhNkNv?=
 =?utf-8?B?SzE3ZWN5UjBqNEtub081RWJ3TG9wZXkxRFJwZEpNN1pXOVFNSGt1NC9GcUNn?=
 =?utf-8?Q?QNvVnz7iI0Y5vJZJ60y0ydDg4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A30319FA7172C447A1B6E1E23778845B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cc325cb-9b45-43fc-ab96-08de2c72309c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2025 22:30:08.6620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a3a3QQ03A7E3U8pKZcFBtUpOLWHacM7e1Wtdfv1GYwOpcSBjMmVC2bU3+gBDehftIfc7BZaKZlOh7yNZI+vNRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6445
X-OriginatorOrg: intel.com

DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4X2Vycm5vLmgNCj4gKysrIGIvYXJjaC94ODYv
aW5jbHVkZS9hc20vc2hhcmVkL3RkeF9lcnJuby5oDQo+IEBAIC0xLDE0ICsxLDE2IEBADQo+ICAv
KiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMCAqLw0KPiAtLyogYXJjaGl0ZWN0dXJh
bCBzdGF0dXMgY29kZSBmb3IgU0VBTUNBTEwgKi8NCj4gKyNpZm5kZWYgX1g4Nl9TSEFSRURfVERY
X0VSUk5PX0gNCj4gKyNkZWZpbmUgX1g4Nl9TSEFSRURfVERYX0VSUk5PX0gNCg0KQUZBSUNUIG90
aGVyIGZpbGVzIHVuZGVyIGFzbS9zaGFyZWQvIGFsbCB1c2UNCg0KICAjaWZkZWYgIF9BU01fWDg2
X1NIQVJFRF94eF9IDQogIC4uLg0KDQpJIGd1ZXNzIGl0J3MgYmV0dGVyIHRvIGZvbGxvdyB0aGlz
IHBhdHRlcm4uDQoNCj4gIA0KPiAtI2lmbmRlZiBfX0tWTV9YODZfVERYX0VSUk5PX0gNCj4gLSNk
ZWZpbmUgX19LVk1fWDg2X1REWF9FUlJOT19IDQo+ICsjaW5jbHVkZSA8YXNtL3RyYXBuci5oPg0K
PiAgDQo+ICsvKiBVcHBlciAzMiBiaXQgb2YgdGhlIFREWCBlcnJvciBjb2RlIGVuY29kZXMgdGhl
IHN0YXR1cyAqLw0KPiAgI2RlZmluZSBURFhfU0VBTUNBTExfU1RBVFVTX01BU0sJCTB4RkZGRkZG
RkYwMDAwMDAwMFVMTA0KPiAgDQo+ICAvKg0KPiAtICogVERYIFNFQU1DQUxMIFN0YXR1cyBDb2Rl
cyAocmV0dXJuZWQgaW4gUkFYKQ0KPiArICogVERYIFNFQU1DQUxMIFN0YXR1cyBDb2Rlcw0KDQpO
aXQ6DQoNCkkgZG9uJ3QgcXVpdGUgZm9sbG93IHRoaXMgY2hhbmdlLiAgSnVzdCBjdXJpb3VzOiBp
cyBpdCBiZWNhdXNlICJyZXR1cm5lZCBpbiBSQVgiDQpkb2Vzbid0IGFwcGx5IHRvIGFsbCBlcnJv
ciBjb2RlcyBhbnkgbW9yZT8NCg0KPiAgICovDQo+ICsjZGVmaW5lIFREWF9TVUNDRVNTCQkJCTBV
TEwNCj4gICNkZWZpbmUgVERYX05PTl9SRUNPVkVSQUJMRV9WQ1BVCQkweDQwMDAwMDAxMDAwMDAw
MDBVTEwNCj4gICNkZWZpbmUgVERYX05PTl9SRUNPVkVSQUJMRV9URAkJCTB4NDAwMDAwMDIwMDAw
MDAwMFVMTA0KPiAgI2RlZmluZSBURFhfTk9OX1JFQ09WRVJBQkxFX1REX05PTl9BQ0NFU1NJQkxF
CTB4NjAwMDAwMDUwMDAwMDAwMFVMTA0KPiBAQCAtMTcsNiArMTksNyBAQA0KPiAgI2RlZmluZSBU
RFhfT1BFUkFORF9JTlZBTElECQkJMHhDMDAwMDEwMDAwMDAwMDAwVUxMDQo+ICAjZGVmaW5lIFRE
WF9PUEVSQU5EX0JVU1kJCQkweDgwMDAwMjAwMDAwMDAwMDBVTEwNCj4gICNkZWZpbmUgVERYX1BS
RVZJT1VTX1RMQl9FUE9DSF9CVVNZCQkweDgwMDAwMjAxMDAwMDAwMDBVTEwNCj4gKyNkZWZpbmUg
VERYX1JORF9OT19FTlRST1BZCQkJMHg4MDAwMDIwMzAwMDAwMDAwVUxMDQo+ICAjZGVmaW5lIFRE
WF9QQUdFX01FVEFEQVRBX0lOQ09SUkVDVAkJMHhDMDAwMDMwMDAwMDAwMDAwVUxMDQo+ICAjZGVm
aW5lIFREWF9WQ1BVX05PVF9BU1NPQ0lBVEVECQkJMHg4MDAwMDcwMjAwMDAwMDAwVUxMDQo+ICAj
ZGVmaW5lIFREWF9LRVlfR0VORVJBVElPTl9GQUlMRUQJCTB4ODAwMDA4MDAwMDAwMDAwMFVMTA0K
PiBAQCAtMjgsNiArMzEsMjAgQEANCj4gICNkZWZpbmUgVERYX0VQVF9FTlRSWV9TVEFURV9JTkNP
UlJFQ1QJCTB4QzAwMDBCMEQwMDAwMDAwMFVMTA0KPiAgI2RlZmluZSBURFhfTUVUQURBVEFfRklF
TERfTk9UX1JFQURBQkxFCQkweEMwMDAwQzAyMDAwMDAwMDBVTEwNCj4gIA0KPiArLyoNCj4gKyAq
IFNXLWRlZmluZWQgZXJyb3IgY29kZXMuDQo+ICsgKg0KPiArICogQml0cyA0Nzo0MCA9PSAweEZG
IGluZGljYXRlIFJlc2VydmVkIHN0YXR1cyBjb2RlIGNsYXNzIHRoYXQgbmV2ZXIgdXNlZCBieQ0K
PiArICogVERYIG1vZHVsZS4NCj4gKyAqLw0KPiArI2RlZmluZSBURFhfRVJST1IJCQlfQklUVUxM
KDYzKQ0KPiArI2RlZmluZSBURFhfTk9OX1JFQ09WRVJBQkxFCQlfQklUVUxMKDYyKQ0KPiArI2Rl
ZmluZSBURFhfU1dfRVJST1IJCQkoVERYX0VSUk9SIHwgR0VOTUFTS19VTEwoNDcsIDQwKSkNCj4g
KyNkZWZpbmUgVERYX1NFQU1DQUxMX1ZNRkFJTElOVkFMSUQJKFREWF9TV19FUlJPUiB8IF9VTEwo
MHhGRkZGMDAwMCkpDQo+ICsNCj4gKyNkZWZpbmUgVERYX1NFQU1DQUxMX0dQCQkJKFREWF9TV19F
UlJPUiB8IFg4Nl9UUkFQX0dQKQ0KPiArI2RlZmluZSBURFhfU0VBTUNBTExfVUQJCQkoVERYX1NX
X0VSUk9SIHwgWDg2X1RSQVBfVUQpDQo+ICsNCj4gIC8qDQo+ICAgKiBURFggbW9kdWxlIG9wZXJh
bmQgSUQsIGFwcGVhcnMgaW4gMzE6MCBwYXJ0IG9mIGVycm9yIGNvZGUgYXMNCj4gICAqIGRldGFp
bCBpbmZvcm1hdGlvbg0KPiBAQCAtMzcsNCArNTQsNCBAQA0KPiAgI2RlZmluZSBURFhfT1BFUkFO
RF9JRF9TRVBUCQkJMHg5Mg0KPiAgI2RlZmluZSBURFhfT1BFUkFORF9JRF9URF9FUE9DSAkJCTB4
YTkNCj4gIA0KPiAtI2VuZGlmIC8qIF9fS1ZNX1g4Nl9URFhfRVJSTk9fSCAqLw0KPiArI2VuZGlm
IC8qIF9YODZfU0hBUkVEX1REWF9FUlJOT19IICovDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS90ZHguaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQo+IGluZGV4IDZi
MzM4ZDdmMDFiNy4uMmYzZTE2YjkzYjRjIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS90ZHguaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiBAQCAtMTIs
MjYgKzEyLDYgQEANCj4gICNpbmNsdWRlIDxhc20vdHJhcG5yLmg+DQoNCkkgdGhpbmsgeW91IGNh
biByZW1vdmUgPGFzbS90cmFwbnIuaD4gaGVyZSBzaW5jZSBub3cgPGFzbS90ZHguaD4gaXMgbm8g
bG9uZ2VyDQp1c2luZyBhbnkgZGVmaW5pdGlvbnMgZnJvbSBpdC4gIEFuZCA8YXNtL3NoYXJlZC90
ZHhfZXJybm8uaD4gbm93IGluY2x1ZGVzIGl0DQpkaXJlY3RseS4NCg==

