Return-Path: <kvm+bounces-51767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E8748AFCD73
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 16:24:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6421B7B54E0
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 14:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F862DFA20;
	Tue,  8 Jul 2025 14:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kNU0yL/c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041121E22FC;
	Tue,  8 Jul 2025 14:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751984429; cv=fail; b=dCn9VbEnB4qUGZusUgq3KdDw1yzcGX2MyXonSyV9UVP4nKPc0mXmRZmwHBlS0XnYwXnqMQPz8BdqvQRgecBHv7uMMWj0YTC+YIxbjf6i6vOombc7zvMcVqd3GcduNe8Fc5ye9dXYrH1XniYL6oeD73QmzIpmMCAduqjI6MA+Qf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751984429; c=relaxed/simple;
	bh=rDe/zlHj/6ZzE5pg1gd3Ax/apyIcsJNffFVLJEpdQcM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DQFBpLeik8W2Capq8QsJY5NqoZfc+jB/5iMCIMmkhbOv+4/cYqC7A8QV8JeyeD3EnQISBR4l5QC4JTXkbgEoE33mdVy6brX+x29pl7DDixsIH439xef1VxpOBIhM6ldLFryBMaG5O3KnfHYDQ6r6L9lgyLbuwsAVSvtnH89ajX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kNU0yL/c; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751984428; x=1783520428;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rDe/zlHj/6ZzE5pg1gd3Ax/apyIcsJNffFVLJEpdQcM=;
  b=kNU0yL/cLmdPNyjnVnY9lSudeD0w4Fsw9TM7sJTXP1ACSh9eC4b9FObV
   uNPt3OndkV97K8A0yMuZHAn10rg0yOdspbRHy8klTNi/5Z4vOAWnV15lk
   nkHZvyMFfGusWp7QUmX+d3jlFEpjL0sbOMUKml843cvCyo+qgVqNv4V0o
   MbAT+IgdqnLIRZEKnWW1qiLp7NJUYhI33MDpC4n29++Dmxk4kLOaw6FgG
   ZP/uTzkLMJmEfyglAXjPERiNlJWkpRNIVHRgIXCeCA4jQSgKJlL80B2ps
   atLlOBWjp+P/jjHppap+Horq4iN6m9O+Cpa3zlsVHAOaJ64vw0MfPPT3L
   w==;
X-CSE-ConnectionGUID: qsx1LIChToaDH9PhwFlZEQ==
X-CSE-MsgGUID: 6Und6w8qQ06rK67GQLkvLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="53431692"
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="53431692"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 07:20:27 -0700
X-CSE-ConnectionGUID: keWqaKP5QzS0tE2VrLwsfQ==
X-CSE-MsgGUID: U5NLKbSOSbGOEYn958cpiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="154919152"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 07:20:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 07:20:26 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 07:20:26 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.49)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 07:20:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DGlIf3zLbMpm4gby3+S3IqPYxVmI/y7q2ASWifH7f3pj9XFbN3TEQP4UJC9uUksp/9wMG+TPfuxILf2MpGJa58F/C/UM1TrcVsmvZMVGoiJEY/1uEKZE6aJ7z54vfm9XNnrlVy91UQ0AY2PkjeGvWHscqKQx+CoTbLD15w94i1yOTxm0josaJuEuL/eRUhE7qkHZTcBj4FfpwjwYUsAHRUgd4YBjmK6aNQXrjIXcT18IbBk0sdpeuxirF0Hnjb+9paQZucGZT9AMesuzh9p2IsDruaQFjSJn6KisZHlMSk5SQNUXpBCC/A1L3BMeiAULbJ4KaSayyh20RtbqVgnxnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rDe/zlHj/6ZzE5pg1gd3Ax/apyIcsJNffFVLJEpdQcM=;
 b=k5/tLSueRPr04T6iaG1gt80dcp9ErWI3y/ochk28RMQ8jTJ7P/DfzhMmsR0zQJSG8t2jRVkB/OkG1iRmrd6tBW89ohZhUElPhkcfTPAb3exD8nsYB+pHHZRLNKXoS0wh46rdzUdfxzqi4UGqCuRgU6oHPSUHTPBIDkZGxcVEl7g7DxrSz6wdcbBCAMzmS6iPUzdwpPjYIHicBeJRP8pCm5qQc3LWDI0yAj02eFT8UDOsdAGWRbJT16Qllxy0e0aKux8wsEEUyD+kCkSemXIc5WMiL1xu70bi2W2D6mSLpF/QBVfA1gFUsi2hqLhkNSxNjgU5y89Q0R7MMLmpFigVcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL4PR11MB8800.namprd11.prod.outlook.com (2603:10b6:208:5a7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.21; Tue, 8 Jul
 2025 14:20:23 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.023; Tue, 8 Jul 2025
 14:20:23 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "Lindgren, Tony"
	<tony.lindgren@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH 1/2] x86/tdx: Fix the typo of TDX_ATTR_MIGRTABLE
Thread-Topic: [PATCH 1/2] x86/tdx: Fix the typo of TDX_ATTR_MIGRTABLE
Thread-Index: AQHb79/jwEuxVfWDcUuN6kzA+Q/wH7QoRyEA
Date: Tue, 8 Jul 2025 14:20:23 +0000
Message-ID: <a1bd44daa452356f4e763e4a980d075a831e2290.camel@intel.com>
References: <20250708080314.43081-1-xiaoyao.li@intel.com>
	 <20250708080314.43081-2-xiaoyao.li@intel.com>
In-Reply-To: <20250708080314.43081-2-xiaoyao.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL4PR11MB8800:EE_
x-ms-office365-filtering-correlation-id: a2648e02-4a6e-49bd-cd50-08ddbe2a93bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UjFuR3JKbEZwUkF0TlFHNXNYSys4STR2cmo4MFBRZUh5SlU4ekZmdGV4bVQw?=
 =?utf-8?B?eWpiNmRXKytOVkg4ME40WGQ5SGkxNnA3Qm1ESzR2NGJhTVNkaXh4SGtQa1E0?=
 =?utf-8?B?Y2toUGFFakt3VGJSWU1oNVJZczMwdXVoOW01STdqMGswQ2UxNWtLNkVmMnpJ?=
 =?utf-8?B?T3NBS2hvMHZzNGUzZ0s2N1Bzd1VSTEJ5QnhWYzV4RUxmSWUrN2pYZ2FQajd4?=
 =?utf-8?B?bkNtRFRwV1JVZUhESHlKdHhxL25mSDJvekRhMkVXZTZNZXJOU3duSE8wMTRD?=
 =?utf-8?B?TlIvOTJvaDV0UU5KOUFLZDNobElRREJUa2YvVlYrYWdZMlJWT0xqTERuWDlj?=
 =?utf-8?B?S3hXK2VOMzFkL0hjS2xnUzNjdFl3SS9IVG56M0VMbHh4S0xKQ1N5OEEyMS9Y?=
 =?utf-8?B?RFZaYWIyWjRnKzBIOVpTTGxDSExGWmVob3dWTlgzM25uV3NDendZbGJwRHdJ?=
 =?utf-8?B?c1NYd1ZQUWZRTW5JSmZ6cm90OVRocVJhaTB5MEU4UGxnQ0E4dWN4UVVXYXA2?=
 =?utf-8?B?RjE0aWxuNXlqblRHVGVlWGdjWlV3SWZURFRRQ0FCR1I2ODd2cTA0SmFlREtD?=
 =?utf-8?B?b2lFdVk2UDU4NFdZdGtLTGtSUGwvZVlhcU9XMk1ISEs4Q2tKQUJOQjAwY01u?=
 =?utf-8?B?Yyt5SExsbXB4OFloRWJwNHdCRHRWZnlqS21lM1gyK1YwVVRVSTJzdjhHaWdi?=
 =?utf-8?B?bk9SU1hVY051ejA4VlZYNVg1SlFlanB3V2FEVnJYeUdNemlLbDlIbVNkTTFQ?=
 =?utf-8?B?QTRQMHJseElPaitTTUhsSXptN3lLQ1Y4dmV4Q0NEbDVsdDBKS2FFZlg0MWJH?=
 =?utf-8?B?S0ljZmJ3NkN3ZmVOMkZPQ0xId2NNSEY1b3MvODlUZmpoYzFvQjR1MlE3R21B?=
 =?utf-8?B?dExGd3FjK2RwbjgxZW1pbTFjek5XMTBjUSs5bUkxK0RCSXRUOVA4MVhoSmEw?=
 =?utf-8?B?YXVDcVRhSWJxWWdBMnVUUWxoNlI5dlNCeDNnMW1PelNBNVVDRFNuNUVEbWNY?=
 =?utf-8?B?K01yS3MrYTFET2VYeTl6VkVSR2k2S1hkNzVoektKVjVLY2wxSWNhalkvcHli?=
 =?utf-8?B?WkNJSmFzMzBjcFFzWEhpTFhVM3RFcVFDdHBwL1lVUUs3eWdLZmJrS0FFZkNh?=
 =?utf-8?B?OVpRL2FOdXhLejgwejI2YXNIeVE4d3VYeHVjNHhhTHhKenFSVGV6cXNPaVNy?=
 =?utf-8?B?cVV5QnYwTVl0RjNLQ0NVQ0dSUkxCRmt2RGhLYUhIbkp3ZDRHay9HeEN2WjE2?=
 =?utf-8?B?dGNvS3hsNTViYWZVMTBIeG1JeXQrNSt0QVRRZnhxNUQzL2dTa01wenl1VUZk?=
 =?utf-8?B?Yk51UzhxdFVXc09EUVg5Ykk2ZFl4bVZsVncxdThNVzlxTTlNQVpGZ0h0aUc3?=
 =?utf-8?B?eGNhWStJeG1xQUZOeTFJNzQwNlIybTJHZ2VBem5GLzg5NFkyNmovN2V5ZFRj?=
 =?utf-8?B?bDZRcEJHYTlCZVdPWjZvcXRzYSszZmgxanJxcjRtemlQa3hpU0x3Uk1rSmFP?=
 =?utf-8?B?NFlHQzRoenBWZFAzT3hkWUJvT3dVdmFnVGJJTitMVnQwc2NkSkJvd3RQWXhz?=
 =?utf-8?B?R3ExTEZTb2FBemcvb1VPM2lNeHdOOEgwaEdpallyS3RIdXd1WklMMkR4UXYz?=
 =?utf-8?B?Ly9tUVgveHhuYTRPWG83WEVHcHYwZG9YZmRhL2l0a2xMR0Y3ZWpMOU5CNEdu?=
 =?utf-8?B?ZldybE9mQmd3S0wvYk9LM0dTNkk0dTQxYTQ0TFUxbnZKZ2QyYmMwOU9yREQw?=
 =?utf-8?B?K21GWGVacDJPcUkwOVhURzAwZFhtTUdYdmFjRG91MG4wQ2RZckZWOEdESit3?=
 =?utf-8?B?S0cvNzFCQitWREtZYU0zWDZYQmVXbmFCN1lSdzBucnRaT2FJaWNMOVFZaDhG?=
 =?utf-8?B?OG9PRHdXaXRUR2xkb2NIYVhLWEtxSCtFSHFVTHVIQUF5aUJFeGd5K2dEbmdD?=
 =?utf-8?B?aWVZN0Z0amt1bmpyK1dqWS8zUXI3RDZ4SDRhcTR3bG0zQmgzbVlxdVZqYWJm?=
 =?utf-8?Q?q7MI0WNcNRI6f1LNvX4k3FEhkmbyJE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWwwcmc4RW03SWVKRnI1MlJtb3NEbmo0eGNFcXFlUUZib0lhR25uTzFYaUFT?=
 =?utf-8?B?ZmZSaHVpemJ2MDFsVVJ2OFBzRW93UitsZzh6WWwrWjRIUzlWZ1hyR1JXRGdZ?=
 =?utf-8?B?SUFyS0d1YVJTaEhPcnBRa0FEV3BQT2RQTS9QVGkrNUlwZGFCNERzaW5ZeVRI?=
 =?utf-8?B?SFdnYk8zTjBSUkpNdlFOYjJnVCtzZk5xSzR4cXFNVFJKY3dKYkpkTXNEU2VM?=
 =?utf-8?B?c0tLdjU1NjNUeEJ5Z1U1cCtzY3RObFFkOVgvR0c1UklqR3RtVlhpVGVQeXg2?=
 =?utf-8?B?VGRjRWVCbHd3VVluUHFoMGZ6am5GOFFUdnBiVTlYajZybDRTMXpHUWswdWpx?=
 =?utf-8?B?MXhtclVYT0ZMSFlqc0dMM1NrRTI0VCthclhnZmkzcDRoT0FIUzJQMS8zWlNQ?=
 =?utf-8?B?dFhpcTR4b2pOQWhzVVNtY2VHWHVPTnBobXlGeWZNMU4rTWl5NTVVSTJkdXM4?=
 =?utf-8?B?MnNKZTRhWENqeEdCcC9iNldBQ3pDNnhMbEFxUmRONVFmOVR0c3JWa1Fza2pM?=
 =?utf-8?B?SFQvQWdvRzNyQ0VDcFhIMUhBQkJHWk1oMmlQZktYbmpDT3FtMmlwRFJGTXlp?=
 =?utf-8?B?U0ppQlVib3puQkN0Mk9VYld6NkhIODRtN09ESGFqTWE5QStlQ2crekwxTDVl?=
 =?utf-8?B?NXdVekUzVGZDMEtmc1VSSEw4aXZqWkQrTFdZQ084dzJHZ1c0MUtsZlhMY1cx?=
 =?utf-8?B?UURCNlZVVGpCRmxJenVNSWhGZEtQZjN3aEgyMzdmL05ZOGlmWndHV0RGVjdx?=
 =?utf-8?B?TnJCeFJob3d4eEtYTkJWd0ZJNWh5cWtmbHpJSlF4QUpicSt0bnhKL1RIcDBK?=
 =?utf-8?B?V3FGTXFZQ29CQlRpNnQ5L1RnRmJTTnRxU0FUZUgrb2VhM2ZvbWtLNU5xM2ts?=
 =?utf-8?B?VXZubUVNN2ZoQTF3QzU0QnRaY3hjbGc5Qkl6SDFHZ0QxMUxCb2dkK0pDa1Js?=
 =?utf-8?B?Z2I0d0c1N05IaUVhT1BCYW9OQ245YXRVS011aVRDUHVCbjdHT2JpenFIckk1?=
 =?utf-8?B?U0xnSEJCa0gwT1hTbjdiR2pRaWdHd1AvT0YzTWVZRjUwN0F0dWZUZFNtUlNa?=
 =?utf-8?B?cWR4RGJNWWJES3p0TFk2L29uN0EvMVVkOTdIcUtCcUtuQlF0Y0hyZzRqNGNM?=
 =?utf-8?B?U1IvcnlCQUxiRURLbGlPaVY3a3hEUkxyK05GQmlOdkNiWC94eG01ako5d1V1?=
 =?utf-8?B?YWNnSXkzY0c1N0hlSG8yay9wRzFIK3JLOTJRRUg4cEFtUkc1NjROeU1CTE54?=
 =?utf-8?B?YTNEQWRPR3FrSjl3dVQ0WDB6RjhISTVUbXpoSmJTSUN0cnBJK3VsLzhUNDNI?=
 =?utf-8?B?Ly9EMTVzdEUvL3pJeEVzTEVVN3NzeXFQS0ZXSkE1L1cvS2psTCs0WTNnRU1D?=
 =?utf-8?B?TVpjcThHQS9zaHhpSTl0c3FmUEowc05EMUFkc2tYeVBJbVJHaDZQQzIxMGto?=
 =?utf-8?B?RmhVdVlkRXpQdzRyY3BrSUVMVzVTWHhpbmVsM1RXWU1sUVd3a2JCVzUvVDRS?=
 =?utf-8?B?cGpPN09yTk9MZUlwWCtoVlA1Wm1LSlFlQXlpZkJDYWJTb2pZZG04aVNOM0VK?=
 =?utf-8?B?ZXRJcitKTEZBbjB3Unl1S2tIZ3VZR29Ba1VMSGxnNjN0dHdxT3BXUEZNVGpK?=
 =?utf-8?B?UEQ4REVlbUxLN3paZWFIOEt3NmZ0RU14UFBiWWFQZkJiaVV1ZkMrOFRsTGl6?=
 =?utf-8?B?QllrdGpWUVphQ0tBNStyT3dBSDJwNlo1OUJzS1Q4V2FFelFVN2hSNXBtK2Mv?=
 =?utf-8?B?V2JSNTRvZlc4WGE5c042K0R5MHV5bUpoWGlYdzNzQ0tIaTVLSDBWYURYVVYx?=
 =?utf-8?B?NHgrNFk4dXZ1VFVTanBJaEk1eEVXQzNCRjhNNHZXbVlxUFJVR2VzZm9pU2N5?=
 =?utf-8?B?LzF4Q21YOTAyZzJtZ0dZdnBXejd3eTc2cnhSNkpRSm81MmdKSWMxR2N2Qlpp?=
 =?utf-8?B?NURKKzRPdVNVcHhaWlVUc0M2SEptV1lxTHNLc2NIWTA5VFNNaVFlVmNibi9O?=
 =?utf-8?B?bU9qRmRBamJReTZNL1hLd2djd0w2a0NvOFNuQnROcElleW9NZFh3cm43b2po?=
 =?utf-8?B?YW1EU013Zi9INkRaYWJQVGJEUGpSYVAvR3F3YitWenJaM3hac1VINEc3RnNw?=
 =?utf-8?B?YnRXR3R1a1dGUWU0MWM3UU5JVzlPMkgvOWNMQVpOS1hKbGEyQ2xrQmRWUHJv?=
 =?utf-8?B?M0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A77153B68CDA2C4892AED62A99FF6397@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2648e02-4a6e-49bd-cd50-08ddbe2a93bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2025 14:20:23.2311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H152Y8nFhG4ww1xEf/bzhYUxQ/PjfBgFkBnS0J5KilDbf4nK+NjM8a/cwI7+dZYfhA4lrvKVuv3Yxr5F0Gwmawq9oO8CY5lJq+RvzWdPhOE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8800
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTA4IGF0IDE2OjAzICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiBG
aXggdGhlIHR5cG8gb2YgVERYX0FUVFJfTUlHUlRBQkxFIHRvIFREWF9BVFRSX01JR1JBVEFCTEUu
DQoNCkNhbiB5b3UgYWRkIGEgbGl0dGxlIG1vcmUuIFNvbWV0aGluZyB0aGF0IGV4cGxhaW5zIHRo
ZSBpbXBhY3Qgb2YgdGhlIGNoYW5nZS4NClRoZXNlIG5hbWVzIGFyZSBzdHJpbmdpZmllZCBhbmQg
cHJpbnRlZCBvdXQuIFNvIGl0IHdpbGwgYWN0dWFsbHkgZml4IHRoZSBkbWVzZw0Kb3V0cHV0IGFz
IHdlbGwuIEJ1dCBub3QgYW55IGtpbmQgb2YgbWFjaGluZSByZWFkYWJsZSBwcm9jIG9yIGFueXRo
aW5nIGxpa2UgdGhhdC4NCg0KPiANCj4gUmV2aWV3ZWQtYnk6IEtpcmlsbCBBLiBTaHV0ZW1vdiA8
a2lyaWxsLnNodXRlbW92QGxpbnV4LmludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWGlhb3lh
byBMaSA8eGlhb3lhby5saUBpbnRlbC5jb20+DQoNCg==

