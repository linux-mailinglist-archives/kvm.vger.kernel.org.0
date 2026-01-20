Return-Path: <kvm+bounces-68662-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QBwhBbkUcGlyUwAAu9opvQ
	(envelope-from <kvm+bounces-68662-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 00:50:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EFDC4E205
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 00:50:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D565492F388
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 23:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CEBA410D16;
	Tue, 20 Jan 2026 23:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ir9RRbSR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D133ACA45;
	Tue, 20 Jan 2026 23:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768951897; cv=fail; b=aUfXKETtVOIWY85iDB0rOObKoqCIru7R+O8CGtGpvI7L6U7uIeezkrCDU+fnCBjMGRkDyvuKIV5TKBNLWuJ1riW3caNIF2t/hb7eNfKggeftfXvqElL+0dninzXhFrpkuUbkx/KOGj9aCLa2qF6houpL48Q9ypZ44B6oUgng+g8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768951897; c=relaxed/simple;
	bh=2zeTG+Dg2HKl8NsZ7U4ltJFxUt0QenL8i3PqNwJfPeM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QdXeLg5XLieITAvMs6lA+wUSoICCCcXRD/puVMVtxKVvXCAcuW56ql9Q1mdvZqpmefWplVdbsbVJK8ZO8Wd1wiuipAHe4fqPSO1aJgCHyiUwSrzpmBS3WMLQevOh8I5Zter2oyWoVibYdfPuXFmlF0rz+rNwHpEd+N0cLQiaqnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ir9RRbSR; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768951896; x=1800487896;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2zeTG+Dg2HKl8NsZ7U4ltJFxUt0QenL8i3PqNwJfPeM=;
  b=Ir9RRbSRDn6LewDA2f9C//6LSJyu4eNKLWxPr7wYHKWbqiKGSKQPuhGQ
   /vrHVD2+n+2JUlpJwxFjfOGqLOJt8qDp9/AmBEqcI1rpQEPmt5QUgBLe/
   peppqM0iWGXRypLX39wW5vLg2z3IvjYQr//baqDEj3SxMtSClquNpsp7f
   bR3DSfK2HojxjKqpmJ6UYm1AboVJ/k7BYnfmv0bvj2lM6+Qg19gycbTQW
   r/x4NE2ylHF//xTtb048Ro7QIMKpBgDBqwF3bIiRcQLpBFgo+47ZmOyK4
   CyV/wKMfxouKU2Guk4f8e4CMSZYonZ5o43lsc3HKTIlEOw8iJ/dDKcoaO
   Q==;
X-CSE-ConnectionGUID: CapiI+98Ska8MkK7Onm3TQ==
X-CSE-MsgGUID: Av46VfJ9QaynvrQz6n42kA==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="80479333"
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="80479333"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 15:31:35 -0800
X-CSE-ConnectionGUID: 3L11kvLIQyWQ8DG612MjBQ==
X-CSE-MsgGUID: 1Yx8v9zLTMGVS1MQ5GjP/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="211128081"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 15:31:33 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 15:31:32 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 15:31:32 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.37) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 15:31:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nQ97lbYeZTwFyFQH1Xxqq/TUiA/jEAEP5Jb7Rj0PJhRVtq/W/9UmN9O6vLRPHc0cHlyvNQ0IBONfQw0IO8/eqxZD/bsUwWDLkt+fYqYYeq6jd4KqWto8S39kAZJd4ySTrr73Nc0mLj9EBFIstJEp/Xq3bEG1liyyy/yxtZSHJQVTG9wvLbtYbfNXDOjwHqkS0mbXtF8UuxycJLziZDLoWriz7plaHnOSs6kvE9nLUmh523Og2xwv0tG5wTfqEFbEmMaGL7uhYqe5z5DW2uqmzTPY9QN+MI/imkXmRSxtjwGw3wuRzM/l16l78P5Qw0g5z+MKh2QtaRAh4gVQ4SvTVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2zeTG+Dg2HKl8NsZ7U4ltJFxUt0QenL8i3PqNwJfPeM=;
 b=n/IjGpFJ8K9eytqkSLq1Sm0LncQDcdNX4uwTMcHDo9xwX+g1+fwZNZj588KlWr+pKOIJ/LbWfqdmXpIK78DwtI5fw6GWYLpunlq92ipkraetgvCmHXkZAie/g778sdo+5gOkPhvBBWPMl3OqNk4/f5x/sS6dvBrMn+fildXX/CYAWGZGUkhuOVuCpgqfoOlBwNy0XYkWhqz09uRj7xR+FYnoUB38gpJbISA/RLYZ1jFTSFZydNXA4SBHl3FLm4oWMJr/iseIxgnZ7ogo+AHyueadJ0x9YCZPyaYu6RcijHwyXo9PbJl1gnXm/MtfCIZswE0ooNPk2K3eRDeZ52MdSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB8038.namprd11.prod.outlook.com (2603:10b6:510:25e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Tue, 20 Jan
 2026 23:31:23 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9542.008; Tue, 20 Jan 2026
 23:31:23 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@kernel.org"
	<tglx@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>
Subject: Re: [PATCH] x86/tdx: Use pg_level in TDX APIs, not the TDX-Module's
 0-based level
Thread-Topic: [PATCH] x86/tdx: Use pg_level in TDX APIs, not the TDX-Module's
 0-based level
Thread-Index: AQHcikzuwdu34SkkTUq4SHjNF5VmWbVbtSkA
Date: Tue, 20 Jan 2026 23:31:23 +0000
Message-ID: <50dde948f17a3fe1c9c944ced8df48d59d5481b6.camel@intel.com>
References: <20260120203937.1447592-1-seanjc@google.com>
In-Reply-To: <20260120203937.1447592-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB8038:EE_
x-ms-office365-filtering-correlation-id: 8b89a07f-1034-4cda-8d56-08de587c0622
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?WGhHaEZVL3QvSXMyVHBNQ05QSG5tK1p6by95WVBKUXFVU2svR254eUY0NWZF?=
 =?utf-8?B?YjlwK0ltZE5ldnN5MWxGeDF3dDYzZjNvYzNmUUFKaFRyNmttVTZqa3QrUjU1?=
 =?utf-8?B?RktwVk5nMzZBT0JDdE1MU2J6cEpkeldlQW1rVzdBVHUxdzZMZVk1Z1BJUEIv?=
 =?utf-8?B?aWNqalRnS0FFemMybWV3WStqNGNQTGlGMzZNZnNaWXVrZWxrb1VsbTB4Y0NC?=
 =?utf-8?B?VzVFdzZRa09hamFaS05wd205MitvamIzalVzc1dtd0N0dm9STVU3eUc2OUpC?=
 =?utf-8?B?RzhTR1Q1Q1BkV2NjUEp3TXpPcjZ1RGdwaGVLM2R4QkwzTHd4dDJnZlF1V05v?=
 =?utf-8?B?ckpLak9Cd25lZlQ3QzNER3VkV0tDaGozTEx3eTFKaE1YdmozL2RZcldBTnVU?=
 =?utf-8?B?cVJCZ0l6RGwxcS9Hdml3bTdrVDFDVzRoS1gxeVJSa1A2MldLWUVKeVRJZlN0?=
 =?utf-8?B?d0xOVmcyR0E4TjYxRVNFdklOZzk3SVJKOGJaMzFyUXRtd2tnUVRmMFBlNXdT?=
 =?utf-8?B?WVIwQTljTDQ3OWNFOUh2V296c2xNTFZodjh0VWRtbkdQYmwyWi9KZUlVY2hF?=
 =?utf-8?B?dnhmclRzbjdoTWtyVmxOcHlUUzQ4Z0ZyVkVTQ0pKVDFZWitTWTlYOFNLL0Fs?=
 =?utf-8?B?VkV5SWlIODVOMkFRNDRKZEwybDRDb3dPTVRPbU96b3ZaSXlWTXE5Q1Vrdk1P?=
 =?utf-8?B?aTFRdTVWNnZsdXdsbzVkV1hWeERsK0lQRDMyR1l5THZkQU1CUTAvZlVlbGZR?=
 =?utf-8?B?K1NKL1JXN0FXQXhyZmhwbEwyclFTMEl0Sy9xd3VKSVNxN3QvOFk4cVpaZE9k?=
 =?utf-8?B?am1CTFdaRmFybllMUkdIY2tmaWFaVlhwQUprNHVUUjkzZjVuU2NRSVBPL3gr?=
 =?utf-8?B?ZGRta1JZK2hwL3hNaENqSmdEc25vQnVpRHNOUGNsRXg5SEFWTnh0WGx2c0M1?=
 =?utf-8?B?eVdncnoyKzRqeHNQTGQ3OHVHcVJGUHZKVDNpQVRadzkwNXhlLzVXeU5DbUdr?=
 =?utf-8?B?L3NIWVB0cFF0WE85eGQ1Nlg0N2VsbXZMbStBQTE3OUc3a0NjYkVBbDNLN01J?=
 =?utf-8?B?ZThBc3hnODRyV2ZPRFAxWnlYN1V5MlpYRENZcUkreTJIbkFiR2lJUXFYRncz?=
 =?utf-8?B?NVNnR3VKTVNrQ0JnTmNUeGIvaHJ0SEN3U3pXY0pwdTRmMnJvRW5hTUtWL2dC?=
 =?utf-8?B?c1J4cDI3Z2tJMHVtYUNtZm0wM0lpU0xZVWVkMzBGTFRPQStEaHQ0Qit4QlJV?=
 =?utf-8?B?UW1VdmplWFpwdkRtamRtTXpwcXZoRDBTRWhFcnV6MUNmb0drVzhpeEZnc2p0?=
 =?utf-8?B?QjVVbU1LZ3gyc092UWE3cVg5d2ovQWlIYWp6OFgrQVEwZ1FENWx2SlFxaTBX?=
 =?utf-8?B?b2toRGR3QVBiL2svQkJ0SUt1USs1U1luVGkzdlUyeVh6N1cwUldyb0VMVWdu?=
 =?utf-8?B?bTlQOGVUL0d3TjVEYi9Lb0NKdWtoc3ltWFVFT2c0Y2tpN3IyMUh2OWRNV1Bo?=
 =?utf-8?B?ZnhDL3VOc3A2K2RhQVBsVnc0UEkreXRiQUViTWpSblREVGhNRllQVlZWbXlx?=
 =?utf-8?B?TzdyODB5V0ZkaUE1MS9wT1ZRVjhNQmdFTElkUzhVa2dHMXRzMEFESEoyMHJn?=
 =?utf-8?B?QklrRk42MlRKQWtncUl4cEd0cUhPUDliTUNiSHYyOWZla3llcDg4MmxGQWN4?=
 =?utf-8?B?ZFBuUXZYVlRTSmlQNGhXeFRNODVGVEM5dEIvQ2VQaHBra01hQWVzcmdlYnI4?=
 =?utf-8?B?eUhSVmpYMzVqVFZNYytPQnpzUVNLOXpoeU1WcVdVUFg4aWVSYzJtTXZaTjVt?=
 =?utf-8?B?WEpRRmJaTFQ2NmtyTGJjNVV0WWtPdXNxQzNvS3M3MFdoR3VmMnd1cHlqeVRC?=
 =?utf-8?B?d01ZcEhqMFR4Mk9jaXd6WThTUU1SWkVpU1ZPZ041OHA1Y3RjaHp3dTQ3bEJE?=
 =?utf-8?B?dWxCRkZKNVpjd0doUUtmYWF0R1B4Q3BwRkRrNEdHdlJzeW1GeEVBbXZHMXVp?=
 =?utf-8?B?U0tmSTFkTHlhb1dpZWF3TDN1Zk1ra3I4WEZpVHRxZ2tHUGdQQlFXV3NQRVhz?=
 =?utf-8?B?SkJCSW41Q2tUaHlSdGRRL1FvaVhwaVhFSktYK0pjcllSRnNKL2pqQkdKZDln?=
 =?utf-8?B?UTg0cFFnak0vSFM5SkhNRTRodFhCWElJa0RjVksyMjRSUUdNS0xxd3dkVXk2?=
 =?utf-8?Q?zpcAOClYCtm92ohOJTOv8iY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnBYSklmdGRiU3hVWHpHSWhNRWd5amhYcldqN05RQzVSeEsxZ01ESndmN2RK?=
 =?utf-8?B?OElBSldGRHBINzFOSjBQU1hSeXNWTE16aWpLY0tGOGFsYUZBWXR4enF6b1Ew?=
 =?utf-8?B?bjl1Rk5kTWRLSXdFU2U3ejhxSThFSldrdFE1TkVCK3h2YUtLRS9DaWNUaDVE?=
 =?utf-8?B?ZWphQ1dES3Q1QWsvNmhJUWNGdnY0SkxqSnN2S21mV3pRVWtTSk5GRUo3dTZL?=
 =?utf-8?B?aUlURXdYOE1nQ214dEk4MnRncUtYclVWdkZGOFhTN2V5VFp4ODVFeXVyQXVW?=
 =?utf-8?B?cmRvd3FoTXZBNmdSaWNPeVVVVlpxUEJHWHkrWElwMzFBTTBvMHJ4Vmhhem5C?=
 =?utf-8?B?aE9PUW9zNm1WQ29Qamt1V0tXOVU1R29mWG1RdlZNaEIyRldoSGcvdmwvRGhr?=
 =?utf-8?B?QWJ4NXFYR21nVTlhVHptZzJaR2t5c3N1RWFGdlhHbDMvWXFkU3llOXpzS280?=
 =?utf-8?B?RCtsb01LMk5QT3pnUUJqMmVGKzBzVXFmYVFSVjBSK3BYQW4walpUemZPb3ZT?=
 =?utf-8?B?L2NYQ203WVA4R0RCQ25YaGMyVFRWN25FeWdKeDVmSlFjbkE1NEVYMVAwc0RK?=
 =?utf-8?B?K2hTaks3dXM4UVJoWjIzc0JBQUY4VGJHbHp5WWk5SHdyclpmWUxCVk51cmdQ?=
 =?utf-8?B?dFB1cmJOb1JmYUdHYWkxeWFGRW5GNEt5ZTZISWJGb1ZqTTVDbjhHZlpyM29H?=
 =?utf-8?B?Y2Z4aEZFVmZTUUU4ZzVYT0xNY2lMdFB6Z2NjVHg5R1Q4UjcvR0tDT2lWY2Zq?=
 =?utf-8?B?SHVWM2xXYlpScW5ETFFVaXVNWlcxK21kTHJpeTR0SUZ2cHpqbGk2bEFIUEp5?=
 =?utf-8?B?R3ZLd08veElSdXNMNUtLV2JlSGVTV2FlbFB5TDNzRGVFL1lUdE9Wa0NoNXRo?=
 =?utf-8?B?V2tZVU9rVFQ1TUNTUHNBd3p6QXROMFJTMytrSDEyUmpYckFyQlZnQUJFeU9D?=
 =?utf-8?B?eHdEb0hmSEVtV1BwNmJ2b0I4MGtmMUZxNWdXWWozdTVwUlNKK3R1MXBWQXZw?=
 =?utf-8?B?aXIxWXUxUEU1VG02Z24vL0lFM3M3Ync2Y1RDb09OZXllNEZuTnRwTWFUcnJn?=
 =?utf-8?B?Wmo3Wm14eEtscmVBTVZKOGR5NWNvT1hqcVNMVVNzMlVpZlMrZmJpWk4wODBp?=
 =?utf-8?B?Q3d6WUU4ZVoxWENHcG9ObkMvODlxdUQvMEtXajhCMTdIcHBHaUhBRUM0aGFW?=
 =?utf-8?B?ODMwQSt2eFdjdnJaUmRpTFZoU3ZQMmFreDh2R1BmaGdWSWxiUjc1cVVUWHF2?=
 =?utf-8?B?cGg1OUEwZmNDa1lWVzQ1SG5kd1lZQ2tRaUoyTnk2VFk3eDV6WnlxM0xqTXVy?=
 =?utf-8?B?ZlRvR1pteFI2STRKeGtyNVlOOE5kZUdKOVVqdmZrdWtaR0t5MHlza1ZEM1BC?=
 =?utf-8?B?WkxzVXdCUjlBUTdSVUR1cG1XRit6eTdTQkJka2lld3NGM0pwVHNvQXRqNlRQ?=
 =?utf-8?B?Zjl1dTF5K0xRazlYLzZYY2xQTlNad3hwQUdMLzhvMlpoM0cwYW1RdHNoWEJj?=
 =?utf-8?B?aEVURHRGUVVFZzd1SktEclhjZWxRcWExSUpYQ2wxckU0NlNESWh4N3I3YlNV?=
 =?utf-8?B?cnFQaFhETWlaN0laejY1MDhVZnlwaU8yUHhBWWcyOFE2VHliMi83T1A4ZUFm?=
 =?utf-8?B?TVo5VXRiWFhBaXhMRzNvaHlwVWFjT3BUbVV4eG1VdUZYMG5zQUNjVUdpRFhO?=
 =?utf-8?B?WktLTlJHbUxjcTEzbVNWTXhLZmgzMmYrTWNxOERnTTd6bkRnYThRUnJvVU12?=
 =?utf-8?B?VGZ5L0wwUXZQSjFBS2ZqWFpWSFloOWxZOU9iRkN3a3BUTlNxNE8zNTNnRm5l?=
 =?utf-8?B?dmN0RjZMT2FJRHYrQ21ZWFg2UVVQdyt5UnJ2RGZQQ21IRFFGWlZEazJCU2Ux?=
 =?utf-8?B?NFZZaTVaYTRRWjQ0aXNld3p5S0drbnFZSXoxVFUzQ1Vlb1ZjNER6WC82WDg4?=
 =?utf-8?B?S01xb054MXFnd29QN2VPYUgzRlI0K0Q5VDk0M3ArTnVhQ1M2VVN6ajFKbThJ?=
 =?utf-8?B?OGVKbTVxRzFmNkF3QWN1bklPSjNWUmNmaiszZ1VHSzdISEZET0JsMjRDWXBW?=
 =?utf-8?B?cUp0bWlqUFp3c1hoQjdvbHoyQ2pZamtLN1dSRUllMGlKZ3MxNEtzVWhzY2ZW?=
 =?utf-8?B?MXZKY243eEZsblp2dVNtd3NCREN4TEwyV1hqcXJPS0w3UE9ZRVpncXpEYTlH?=
 =?utf-8?B?QTQwWUJKczNRbUhibjdvbVJMMm1sMU9pTWN5RVR4aE9qdHA0V3U0Sm1QcDht?=
 =?utf-8?B?T1NnZ1FadHRweHZMOEZ6Y05yVGlBWmJnMUxmMFdYeHpTeXdCVys4TFVEamVp?=
 =?utf-8?B?RTIyeE11M0pHajIyTU1JcXYrSHMrRVpJSFFBWFhsc0RLVnk4YVlMQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <44C8F48E4CEA33489A46FABD9E3C5844@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b89a07f-1034-4cda-8d56-08de587c0622
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2026 23:31:23.4397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zVqCdN3rNd3MEiB2AD0rxvV3rc3eA0PRrKFbDpuJv7isJue+omY9X97HSqWLjOC+xBfMMpHXIwmBHBU8ZZmykw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8038
X-OriginatorOrg: intel.com
X-Spamd-Result: default: False [1.14 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68662-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 7EFDC4E205
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

T24gVHVlLCAyMDI2LTAxLTIwIGF0IDEyOjM5IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZXdvcmsgdGhlIFREWCBBUElzIHRvIHRha2UgdGhlIGtlcm5lbCdzIDEtYmFzZWQg
cGdfbGV2ZWwgZW51bSwgbm90IHRoZQ0KPiBURFgtTW9kdWxlJ3MgMC1iYXNlZCBsZXZlbC4gIFRo
ZSBBUElzIGFyZSBfa2VybmVsXyBBUElzLCBub3QgVERYLU1vZHVsZQ0KPiBBUElzLCBhbmQgdGhl
IGtlcm5lbCAoYW5kIEtWTSkgdXNlcyAiZW51bSBwZ19sZXZlbCIgbGl0ZXJhbGx5IGV2ZXJ5d2hl
cmUuDQo+IA0KPiBVc2luZyAiZW51bSBwZ19sZXZlbCIgZWxpbWluYXRlcyBhbWJpZ3VpdHkgd2hl
biBsb29raW5nIGF0IHRoZSBBUElzIChpdCdzDQo+IE5PVCBjbGVhciB0aGF0ICJpbnQgbGV2ZWwi
IHJlZmVycyB0byB0aGUgVERYLU1vZHVsZSdzIGxldmVsKSwgYW5kIHdpbGwNCj4gYWxsb3cgZm9y
IHVzaW5nIGV4aXN0aW5nIGhlbHBlcnMgbGlrZSBwYWdlX2xldmVsX3NpemUoKSB3aGVuIHN1cHBv
cnQgZm9yDQo+IGh1Z2VwYWdlcyBpcyBhZGRlZCB0byB0aGUgUy1FUFQgQVBJcy4NCj4gDQo+IE5v
IGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVkLg0KPiANCj4gQ2M6IEthaSBIdWFuZyA8a2FpLmh1
YW5nQGludGVsLmNvbT4NCj4gQ2M6IERhdmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBsaW51eC5pbnRl
bC5jb20+DQo+IENjOiBSaWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+
DQo+IENjOiBZYW4gWmhhbyA8eWFuLnkuemhhb0BpbnRlbC5jb20+DQo+IENjOiBWaXNoYWwgQW5u
YXB1cnZlIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+DQo+IENjOiBBY2tlcmxleSBUbmcgPGFja2Vy
bGV5dG5nQGdvb2dsZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPg0KPiANCg0KVGVzdGVkIHRoYXQgcnVubmluZy9kZXN0cm95aW5n
IFREIHdvcmtlZCBmaW5lOg0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50
ZWwuY29tPg0KVGVzdGVkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=

