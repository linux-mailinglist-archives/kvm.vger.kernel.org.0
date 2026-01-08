Return-Path: <kvm+bounces-67463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A10CAD06052
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 21:18:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ABB55303CF75
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 20:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE1BE32ED27;
	Thu,  8 Jan 2026 20:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JdF00nWf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE46272E6D;
	Thu,  8 Jan 2026 20:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767903497; cv=fail; b=GQV+JLwar/+9yNWvtSctITsliusgJIXUpfeKKOnoJVyG3HdYssGa6SmJ7YVuLPfRuFnMaEeSExDLBDZVelejNpOy/wcEU+ekLSBBybodqD3BHvm+gWpZUBX0MQ8IoumxWMGr+z+dFaMs/x4QJf87jY8SyMmQA4gI0jxO5785wz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767903497; c=relaxed/simple;
	bh=LeD+ys4NEMqGZ3UG2kP5LAMV6mTwYcFADviv65hHFEQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nNeAq6HeTzrRqoJEOXRjwAGLsQtQ5HQHwIbOp09J6o/IP9yt/dG2xyzgaK64XWcL+mxKHP326d5KDJXeXKLM3fK/NnZ9MEskxCs33k/gSpUtb4dG2WniX9ZHDVd0V4cVCditB+NGGn8Jc+/zZkmAVu0zgEsxHtW4mMcV88TQFCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JdF00nWf; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767903496; x=1799439496;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LeD+ys4NEMqGZ3UG2kP5LAMV6mTwYcFADviv65hHFEQ=;
  b=JdF00nWf3dlp1cz0tOAZa9jCjD381BaRIU29/TIIwffYHsX8BWTxbNBx
   PxptimPmr/o2nmXgcyVET86tOEI/VtgphEGNft6ZJV4fNouypnT/Ldv/R
   2JmV0N9jjxSQUoB3VF+gpno0Ujju8WfcAOofqKeLkWyv8IvIZblT2lLaN
   AmFqdSRTRTiQwcZZYNx8fbPm08+xSA/ISnQccOT+XErrJ9liy/w0ZB/Xf
   4D7eYACV7yF2URjfN6W/d+U/2oA8e1skC4jZhYnfPVyNpjhuvOI134GCD
   Jc7dqB0G0oTqT2Av5nSiBtxq6Db9+KfDKmyteJPc4shyCETDnqiYbg6Iy
   A==;
X-CSE-ConnectionGUID: fgIsbH50QaKmG//iNDG8jg==
X-CSE-MsgGUID: 7SQDcBGnTYqX3cMtt7zSBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="80011704"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="80011704"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 12:18:15 -0800
X-CSE-ConnectionGUID: us6QQoZIRrG2gQfSsUC3BA==
X-CSE-MsgGUID: VT5EjthVRg++PewA/td3OA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="202500549"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 12:18:15 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 12:18:14 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 8 Jan 2026 12:18:14 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.5) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 12:18:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DJ/ITov+YDlLnP3woxLpuIolAIyqrzXcwHohb4MCeDCO2QT9BRFd0MED/iEu6FMWVIncxQzU8SRwqJVMfy5k5Ymvrhci9+I6QDx8HVe1qLnv5iKOeV+RZsMDZ6h+aIgpIcOm8FGg0Ao/8BOOZYduGX3aoKA3RI9tQH/0zQxeVUK6qK5HLtXGZbDVP/cdOipCirWI/kd39q+Sk8bBf/ZusR5cw10Uyf5cvd3/vVfsbO16zeErjNwh0mRwn7vH2vn+6xaykljazUDzOSze8fMHMj7msYZvOC13nFwRVCQpUlsYRLOawx0blkItBA/gE2JJIooABRvLorTMOJSv57HMdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LeD+ys4NEMqGZ3UG2kP5LAMV6mTwYcFADviv65hHFEQ=;
 b=RnpXY9Wnb/NZ2PkUSJBpJJorbkyhAC5CR8YAW1BqVnMulVLYgfeVvu9qyCiBpYxEW53bt5o7El4OoVyEtrggT1qambsA54Lt7Az82vg1wZgCffwlzWqbtLXWMyd/UM2EwglttQTZ/omUO6DTNhRBCTW8EEvDJJGZG9t57Nx2mhzmwZzv9flqfUNh98ArB3WdY9b5qGss8Eha2AhyGmhqmsf2NxdrxTWjUffeeChoJNQMm/Zof5M8Brl3nQdTnFg/UizBXj4Iob+4Jx3dinzxybamwdd80N8BYjvr5JoHmSYrZtjQzy4K/rRnLboMPwgmQ8KmdgVX+5/ASMINFCyMQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7721.namprd11.prod.outlook.com (2603:10b6:610:12b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Thu, 8 Jan
 2026 20:18:12 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 20:18:12 +0000
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
Subject: Re: [PATCH 1/2] x86/virt/tdx: Retrieve TDX module version
Thread-Topic: [PATCH 1/2] x86/virt/tdx: Retrieve TDX module version
Thread-Index: AQHcgDYzdbr08Jlu+UW1bkKCyr5eibVIt1mA
Date: Thu, 8 Jan 2026 20:18:12 +0000
Message-ID: <3f28d2dedfb64e66a97f07411b10a5db93a73342.camel@intel.com>
References: <20260107-tdx_print_module_version-v1-0-822baa56762d@intel.com>
	 <20260107-tdx_print_module_version-v1-1-822baa56762d@intel.com>
In-Reply-To: <20260107-tdx_print_module_version-v1-1-822baa56762d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7721:EE_
x-ms-office365-filtering-correlation-id: 4bd4db74-b23d-4484-47a8-08de4ef30c42
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Y2doRGFZbDRzTnpBQkpDWDdLNXJ3TEFJTnF1T3NGNnBabXlwWCsvOHZ4UUZq?=
 =?utf-8?B?Q1pXaDFnS0Z2UEpiSGoyc3UyZjMrcFk4RjhoaFBvNXNYZUFnSlFpcXpoS3Bu?=
 =?utf-8?B?YmdpdElONXB2OFloKzNDM3hOVDZRbXkvN2E3SU1ha29vWWZEVktuSlZQTm9y?=
 =?utf-8?B?QWJJZ2xsR2lhN0JVc2pKczVpSjNjMTFyOGt1QVlQYlRQcy9idU1hQSsrSDZG?=
 =?utf-8?B?ZzRmNnhEWDJZZjZOUHBpcm1IQVZkcVQ4R1NmYjE3aGZFN29xbnoxazBFUVBy?=
 =?utf-8?B?YnA5V2JCVlJOUEt3dGRuV2pxaUFYOG5DenpoYUIyblhSYVRpKy9yZ09tMUE2?=
 =?utf-8?B?WUxzRVp6UzBiZDhxR1hSUkllbWRrTkxhaXY2ODJsQUFMb2pOMFBDZi96UDU0?=
 =?utf-8?B?cVRBTVVvM3dkc3RxV2JVRVhGajhCaDFXRHl6OHhUN00vbDVJQVZGald4YndK?=
 =?utf-8?B?bi82c1ltbjkxQjNLTXVVaUs5UFFvMzFRRVhqMUxrQ25iK1VPb0hGMkU5MU9s?=
 =?utf-8?B?SDlIUjFGd20vMFZDN0pYejdUODI4VXhvZnVQNm1JUFRVNWVUUGRpS0dxUVp2?=
 =?utf-8?B?U2pnQzg4TjdFT0F2ejEzWHYwVDVZd0d2aExOR2JSbGJrdEZqOEZpMWRqZ2tr?=
 =?utf-8?B?UTZTcTlrUnBJU0xHSGNlL1BlRkxaN1NNb1lSSFRHWkpkSHMxWTdma1l0alZM?=
 =?utf-8?B?UXFibjdaSWo3eVNQVnpML0c2bzVTQm1yVEptOEgwWXR4ZW5sSitMTjR1SWVq?=
 =?utf-8?B?OGZiL0R1dlgxcUtBN2FnclNNMkZ1ZXVINFpNZlkzZnlVdHJka0VFWnZSNm81?=
 =?utf-8?B?N3B2S0pMY3d0T2NNa3g1TkhYSHk1WmJPb1dNcGJRZ29Fb1lEZi9tNVhUN1h6?=
 =?utf-8?B?cXJ1NFAzZXdRMTVQQ01jc0dhZDVVZ0Mrdm12VlRIZE9ZaXZPclF2WmtjZ2s0?=
 =?utf-8?B?NmVFVFJnNkMwRHJydVQvZk9SV0c0VVVaQjcyNDRHb0JEU2dhK3BKbFlpZVRK?=
 =?utf-8?B?RTJOa2dpa3pndXlhQkd5OTVoYzJMTCtRRGFhWmxGUW1pZ3hZU0VvY2FPaW1F?=
 =?utf-8?B?YW1melZxYXV3Qk9IVll1NU9sZ25KVkNKZ3dGMXcwbVZnK2xGdERjd0lnYllG?=
 =?utf-8?B?S3FzSytyK1ltT3lPYTRxNTMwOGdqNG5UVVlFUHVzeWRGUVg1UGN1Q3RNOCtv?=
 =?utf-8?B?aWVhOE1jSXhwMW5yVGNsL2JMa2pWL0RPcWltR3RpWDRFbGZVbjEvdytsMGNE?=
 =?utf-8?B?YTd0VUoyeXBhWDFhLzlIVVk5WWZmQnVVczkyV1dtUXhKVU5zZHlBS2lEbStw?=
 =?utf-8?B?a3JPOHFSeTlkT1VQSk9uK0lVNVNpWFJORU1yd2lKcEUwWUN6U0E1bG1VRllY?=
 =?utf-8?B?amxlZWJjWHFnMmp0M1ZyRVdaUHBwTWRNN3JuS1Y0VFBXYVhhOHFxRHdWUVVp?=
 =?utf-8?B?VnhlWDB2bWU3em1HeTkyTXVGM3NBOHBOUERMZTVTeVJxbzE4SDViUFd3M1VO?=
 =?utf-8?B?U3g4ZW8wNU8zdGVONXFmVk5jb3ZzV3pzam1BWXpOSWRIVHFEaXhQUUJ4MmpY?=
 =?utf-8?B?TWJ6Y2lIbklNQW9jK2N2NW16bUlrSkp3UzFFMTg3UmFnQ1lqWFhGbEt5R0Nh?=
 =?utf-8?B?VFJsUnBmSTc3NjFwSG5kRmpuNWxXeGh6dThnaEFFbzVTT0IrWlpLM1UweWdF?=
 =?utf-8?B?M3llb09sa3Uwc3BtdFFjOHNLQlZRSEwvV1VJb3ZxNW5sNnUyTVRBTHZnTm9x?=
 =?utf-8?B?ZnVTN3FFd2xpMW14VFJKQ3V0WFNxNzV3eUc5d2N2NFRkTzJ0R3NnaktxbXVa?=
 =?utf-8?B?ODZRWXB4Q2VpeVNKYUM5TTIwUlhZS2RHcS8rRXRmNGh1WlFyUGlQRWhRa3JW?=
 =?utf-8?B?U3VreDEyZitPY3llR0w0WHUwSzdpdHdWQUFyOFd0eVNONmtFRlpkOHdETUov?=
 =?utf-8?B?cy8rYkRPcXBwZUZteVN5S24yOHNGUzZzWWVKMkx4QktuRGN5ak8vSS9Ma2hu?=
 =?utf-8?B?bEN5dFNhQm9iZHNuU3JIb3QyV05tc0R2MC91L2ZRWE5vN3NhOXUyOCszNU1T?=
 =?utf-8?B?MXlZRkJlQXArMjdjbUxrUS9PVjVwMTR5U1RaUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFhsZWt0UnREeEJmV0pNZ2lIdE5nNW5VL1IvaUthQWtEOEg2N2hUcjYvTmJ0?=
 =?utf-8?B?bVhsZG8rSEVWYTl4YjhaOFZLYm0xNWx3aDZTOW10aWVqbmVnek05K2Y5ZENE?=
 =?utf-8?B?WjRrWkY2UENvU1RBVVJxNG5IVkZ1YS9wRHRoNDBjNkIwSGhEWnJxd2krN0dK?=
 =?utf-8?B?UjB2ZmhqYjNBSkJPbTNLSnpxeHR6a0ZqWHhESHBaS0VTQ2IwbS9odmswc0lv?=
 =?utf-8?B?QmpOdFQvUnFQS2VJS3RPdlBvSG5kWmZzdzQyeFpBSUV0bzViR1hYOERsMkcv?=
 =?utf-8?B?b0dieGtBSXp5YkozUkdkZWJKUUwxL2hQdm1rUHlSY2pyZ0kxMUFObzVJUXVN?=
 =?utf-8?B?NHRlMzYyRXJqcEVoTzdZS2FaOHptOGM4dWhoTUR5LzFtOG5RbFAxbG5VQ2Jl?=
 =?utf-8?B?ZFBBdkpNQkxMMXRweXpqTzdUcFVHaTNPU0xHaFlSbjB4emxkVjZRcEtReFVX?=
 =?utf-8?B?WEwySWc4V0ZNd0ZZSmdlbWdyTS9DcXQ5d0FWUSsrSjhmL3V2WVoxTk94MC80?=
 =?utf-8?B?WG9qOTA2RStCZHN0UXQxZ3pzRkFCSEpvSkpjVCtkZ0JkSXNZWnFObTVCMnAw?=
 =?utf-8?B?QUN4UmQ4bnZnNkhTRE9ZQzFYaEVUSzIxZi94TkVyNjlJdnFGSWVvTHU5V3Nj?=
 =?utf-8?B?Uk04K0JvMENWTjlpTkM4bG5wSjhwTDd0cnZzZHFXNVVTMUVjTWZoYnR3M2Vy?=
 =?utf-8?B?K1lCNWw0WDNaN29pN1BqOVBpZS9SNWlnRlB2OG1NVUlkdXJKSllzZWlvem13?=
 =?utf-8?B?YnM5ZWtLR2E0M1JUeUdpemM2cjRyZWNoSndPMjZsRjR1SHoyTzhONXFHaUtS?=
 =?utf-8?B?ajc2TVVNZk9Sb3hjNTNWYlh0Sjc5SUtWTTdOY1lxdUtMSVFtSVZPVXloY1dB?=
 =?utf-8?B?T3FyTUs5ZTM0MlIxYkJMdFA2OThRK0NmeDNtQUxFSXBWK1VZZEJkYmtCU1Nj?=
 =?utf-8?B?NFFpbEZ0K2Y0UFgvN09Qb3o0UklkOVFXekFhN1ZpeHdxbi92ZUFvZFBzQ3l4?=
 =?utf-8?B?dytKVlBBazJ2N0F2ZXJ0S29xMzFFZFVicm5GRHZHSFQ2OGdTcTg3OWpsVW55?=
 =?utf-8?B?U2VLZU9pMi9ncllMc1FJeDBIRDI1a1NwVWM1SlQ0V2ZIcW9KeUZGeXFsYUgy?=
 =?utf-8?B?czlqOFhobzhDOVlxdlZoYW5PK1h2bEVCeENVZDQ4UW14R0EwT01MYmxxNkJJ?=
 =?utf-8?B?NGZ5bkx6dW5GRHpkdGFBNVJjYW5xMzJBUkkyQm4zMVlwYVMvdThoR3VScFFt?=
 =?utf-8?B?WnNTZHNEd0tkSnBrM2V3NE56TEhjN3hwY3ZjbE80YldKVFl2bms1cURTZXNt?=
 =?utf-8?B?NTk5WGZJUWhaQVBpYnFqZHZwSkdlbFNNTUlZLzVId2xMYXFEdFlXbG1HNk5z?=
 =?utf-8?B?UnlSV0hpbTRidnhWVktCNzAycTRtRnRxYzM5dXVMY2FwODFad2JqdW8zd3lD?=
 =?utf-8?B?UVE3UDBNa0srckhRMjc3aWhJMVpIaGR0MGMwN3JtczRDN1V5M29GcXU2MlFt?=
 =?utf-8?B?Vkh1ZDRtamxpRmlTeEZpZzJ1aHluYnN0OUNrREtnMitKODlDZXRtbG4vTHBB?=
 =?utf-8?B?Tm9xME5NdlJXaVN5cXdEOW5Mb3hNRS9hczRmVVdMZVFSNjhZaXgwVjFrNGZy?=
 =?utf-8?B?anFtTURhazcycW8rckoyUDVjQXAvb2JWbXp0K1lSbDhEL2o2cXNrL0RNSHor?=
 =?utf-8?B?VlNOcUtIZ05BYjIrMFJtWXUrdGRsZXd4WGhWY0pjNU5OcDdScUtOTGVlTDRx?=
 =?utf-8?B?Ny9aUUNiTEtjd0QwdnNPQTV3VXdPZXdkL2pWbVFEcDUxYTBBckVZRTVZR1Zz?=
 =?utf-8?B?V01pTjQyaUh5Qjg3SUM3V2xvUitRNEVBZDRnVUdUVSt3MFExSEM1enAxLytF?=
 =?utf-8?B?SlVsbDBKRXBEOEtkNWlCUEgzamNLYnZTZEg1Z3ZSSGcxNk1ndnQxVTRLM2Fv?=
 =?utf-8?B?SXF4T3V3VzdoVk1sNDZJVzdrbnlLcEhiQWxjQy9UVE9Vd2hsUDJ3Tm9lODVS?=
 =?utf-8?B?R1JicUN6UndzcTYwS3FvWUdJcit0ZVBFRmFiOFBKUVRkWlFUbWYvSmo5VHRT?=
 =?utf-8?B?a3Y3UEdqY2FBNlh6SU5EdnJNcDdwNnYxOHRUVXlNZ2h6d3hMY3VSUHNoTitV?=
 =?utf-8?B?VGRjTkk2RnVsRjVzQk1QdmVFRUNzdGdDZkVpK01uVjYzYTFDUHpvTnlPOE5p?=
 =?utf-8?B?c3RKTE5qS0xFZVZGUVUrc0tMNmg1NUpaWGVhVTJ1S1I4bVhBYWo1NWlhTFlR?=
 =?utf-8?B?K2Z3R3FubDdCdStEQnRxQk5zaUtNY1NsVHVVNUNOYXlNVlowMzZtaVNucmtD?=
 =?utf-8?B?ZEtBbC9XekM0clNNNHJJNFdJbUhGWXZsSFZveWRmMU1PeEhJMStKSWYvLzNT?=
 =?utf-8?Q?astdpfrgjP3U8M3o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81BEAE80D316544C98AA0DBB8058B603@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bd4db74-b23d-4484-47a8-08de4ef30c42
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 20:18:12.2636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MXvFuHF0P9SySmCfex02hlFP5bwigtTXLPnM66RkDFC+ZtsJ3vzyItTT4gKmxb04OjSPaACkTKk1xiawSH/rc5MzRamWaSwmQx0pQgY5nLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7721
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDE3OjMxIC0wNzAwLCBWaXNoYWwgVmVybWEgd3JvdGU6DQo+
IEZyb206IENoYW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+IA0KPiBFYWNoIFREWCBtb2R1
bGUgaGFzIHNldmVyYWwgYml0cyBvZiBtZXRhZGF0YSBhYm91dCB3aGljaCBzcGVjaWZpYyBURFgN
Cj4gbW9kdWxlIGl0IGlzLsKgDQo+IA0KDQoNCj4gVGhlIHByaW1hcnkgYml0IG9mIGluZm8gaXMg
dGhlIHZlcnNpb24sIHdoaWNoIGhhcyBhbiB4Lnkueg0KPiBmb3JtYXQsIHdoZXJlIHggcmVwcmVz
ZW50cyB0aGUgbWFqb3IgdmVyc2lvbiwgeSB0aGUgbWlub3IgdmVyc2lvbiwgYW5kIHoNCj4gdGhl
IHVwZGF0ZSB2ZXJzaW9uLg0KPiANCg0KQSBiaXQgb2YgYSBydW4tb24gc2VudGVuY2UuDQoNCj4g
IEtub3dpbmcgdGhlIHJ1bm5pbmcgVERYIE1vZHVsZSB2ZXJzaW9uIGlzIHZhbHVhYmxlDQo+IGZv
ciBidWcgcmVwb3J0aW5nIGFuZCBkZWJ1Z2dpbmcuIE5vdGUgdGhhdCB0aGUgbW9kdWxlIGRvZXMg
ZXhwb3NlIG90aGVyDQo+IHBpZWNlcyBvZiB2ZXJzaW9uLXJlbGF0ZWQgbWV0YWRhdGEsIHN1Y2gg
YXMgYnVpbGQgbnVtYmVyIGFuZCBkYXRlLiBUaG9zZQ0KPiBhcmVuJ3QgcmV0cmlldmVkIGZvciBu
b3csIHRoYXQgY2FuIGJlIGFkZGVkIGlmIG5lZWRlZCBpbiB0aGUgZnV0dXJlLg0KPiANCj4gUmV0
cmlldmUgdGhlIFREWCBNb2R1bGUgdmVyc2lvbiB1c2luZyB0aGUgZXhpc3RpbmcgbWV0YWRhdGEg
cmVhZGluZw0KPiBpbnRlcmZhY2UuIExhdGVyIGNoYW5nZXMgd2lsbCBleHBvc2UgdGhpcyBpbmZv
cm1hdGlvbi4gVGhlIG1ldGFkYXRhDQo+IHJlYWRpbmcgaW50ZXJmYWNlcyBoYXZlIGV4aXN0ZWQg
Zm9yIHF1aXRlIHNvbWUgdGltZSwgc28gdGhpcyB3aWxsIHdvcmsNCj4gd2l0aCBvbGRlciB2ZXJz
aW9ucyBvZiB0aGUgVERYIG1vZHVsZSBhcyB3ZWxsIC0gaS5lLiB0aGlzIGlzbid0IGEgbmV3DQo+
IGludGVyZmFjZS4NCj4gDQo+IEFzIGEgc2lkZSBub3RlLCB0aGUgZ2xvYmFsIG1ldGFkYXRhIHJl
YWRpbmcgY29kZSB3YXMgb3JpZ2luYWxseSBzZXQgdXANCj4gdG8gYmUgYXV0by1nZW5lcmF0ZWQg
ZnJvbSBhIEpTT04gZGVmaW5pdGlvbiBbMV0uIEhvd2V2ZXIsIGxhdGVyIFsyXSB0aGlzDQo+IHdh
cyBmb3VuZCB0byBiZSB1bnN1c3RhaW5hYmxlLCBhbmQgdGhlIGF1dG9nZW5lcmF0aW9uIGFwcHJv
YWNoIHdhcw0KPiBkcm9wcGVkIGluIGZhdm9yIG9mIGp1c3QgbWFudWFsbHkgYWRkaW5nIGZpZWxk
cyBhcyBuZWVkZWQgKGUuZy4gYXMgaW4NCj4gdGhpcyBwYXRjaCkuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBDaGFvIEdhbyA8Y2hhby5nYW9AaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBWaXNo
YWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCj4gQ2M6IFJpY2sgRWRnZWNvbWJl
IDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCj4gQ2M6IEthaSBIdWFuZyA8a2FpLmh1YW5n
QGludGVsLmNvbT4NCj4gQ2M6IERhdmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBsaW51eC5pbnRlbC5j
b20+DQo+IENjOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gTGlu
azogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtL0NBQmdPYmZZWFV4cVFWX0ZveEtqQzhVM3Q1
RG55TTQ1bno1RHBUeFladjJ4X3VGS19Ld0BtYWlsLmdtYWlsLmNvbS8gIyBbMV0NCj4gTGluazog
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzFlN2JjYmFkLWViMjYtNDRiNy05N2NhLTg4YWI1
MzQ2NzIxMkBpbnRlbC5jb20vICMgWzJdDQo+IC0tLQ0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20v
dGR4X2dsb2JhbF9tZXRhZGF0YS5oICB8ICA3ICsrKysrKysNCj4gIGFyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHhfZ2xvYmFsX21ldGFkYXRhLmMgfCAxNiArKysrKysrKysrKysrKysrDQo+ICAyIGZp
bGVzIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS90ZHhfZ2xvYmFsX21ldGFkYXRhLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS90ZHhfZ2xvYmFsX21ldGFkYXRhLmgNCj4gaW5kZXggMDYwYTJhZDc0NGJmZi4uNDA2ODljOGRj
NjdlYiAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4X2dsb2JhbF9tZXRh
ZGF0YS5oDQo+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeF9nbG9iYWxfbWV0YWRhdGEu
aA0KPiBAQCAtNSw2ICs1LDEyIEBADQo+ICANCj4gICNpbmNsdWRlIDxsaW51eC90eXBlcy5oPg0K
PiAgDQo+ICtzdHJ1Y3QgdGR4X3N5c19pbmZvX3ZlcnNpb24gew0KPiArCXUxNiBtaW5vcl92ZXJz
aW9uOw0KPiArCXUxNiBtYWpvcl92ZXJzaW9uOw0KPiArCXUxNiB1cGRhdGVfdmVyc2lvbjsNCj4g
K307DQo+ICsNCj4gIHN0cnVjdCB0ZHhfc3lzX2luZm9fZmVhdHVyZXMgew0KPiAgCXU2NCB0ZHhf
ZmVhdHVyZXMwOw0KPiAgfTsNCj4gQEAgLTM1LDYgKzQxLDcgQEAgc3RydWN0IHRkeF9zeXNfaW5m
b190ZF9jb25mIHsNCj4gIH07DQo+ICANCj4gIHN0cnVjdCB0ZHhfc3lzX2luZm8gew0KPiArCXN0
cnVjdCB0ZHhfc3lzX2luZm9fdmVyc2lvbiB2ZXJzaW9uOw0KPiAgCXN0cnVjdCB0ZHhfc3lzX2lu
Zm9fZmVhdHVyZXMgZmVhdHVyZXM7DQo+ICAJc3RydWN0IHRkeF9zeXNfaW5mb190ZG1yIHRkbXI7
DQo+ICAJc3RydWN0IHRkeF9zeXNfaW5mb190ZF9jdHJsIHRkX2N0cmw7DQo+IGRpZmYgLS1naXQg
YS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4X2dsb2JhbF9tZXRhZGF0YS5jIGIvYXJjaC94ODYv
dmlydC92bXgvdGR4L3RkeF9nbG9iYWxfbWV0YWRhdGEuYw0KPiBpbmRleCAxM2FkMjY2MzQ4OGIx
Li4wNDU0MTI0ODAzZjM2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4
X2dsb2JhbF9tZXRhZGF0YS5jDQo+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHhfZ2xv
YmFsX21ldGFkYXRhLmMNCj4gQEAgLTcsNiArNywyMSBAQA0KPiAgICogSW5jbHVkZSB0aGlzIGZp
bGUgdG8gb3RoZXIgQyBmaWxlIGluc3RlYWQuDQo+ICAgKi8NCj4gIA0KPiArc3RhdGljIGludCBn
ZXRfdGR4X3N5c19pbmZvX3ZlcnNpb24oc3RydWN0IHRkeF9zeXNfaW5mb192ZXJzaW9uICpzeXNp
bmZvX3ZlcnNpb24pDQo+ICt7DQo+ICsJaW50IHJldCA9IDA7DQo+ICsJdTY0IHZhbDsNCj4gKw0K
PiArCWlmICghcmV0ICYmICEocmV0ID0gcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoMHgwODAwMDAw
MTAwMDAwMDAzLCAmdmFsKSkpDQo+ICsJCXN5c2luZm9fdmVyc2lvbi0+bWlub3JfdmVyc2lvbiA9
IHZhbDsNCj4gKwlpZiAoIXJldCAmJiAhKHJldCA9IHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkKDB4
MDgwMDAwMDEwMDAwMDAwNCwgJnZhbCkpKQ0KPiArCQlzeXNpbmZvX3ZlcnNpb24tPm1ham9yX3Zl
cnNpb24gPSB2YWw7DQo+ICsJaWYgKCFyZXQgJiYgIShyZXQgPSByZWFkX3N5c19tZXRhZGF0YV9m
aWVsZCgweDA4MDAwMDAxMDAwMDAwMDUsICZ2YWwpKSkNCj4gKwkJc3lzaW5mb192ZXJzaW9uLT51
cGRhdGVfdmVyc2lvbiA9IHZhbDsNCj4gKw0KPiArCXJldHVybiByZXQ7DQo+ICt9DQo+ICsNCj4g
IHN0YXRpYyBpbnQgZ2V0X3RkeF9zeXNfaW5mb19mZWF0dXJlcyhzdHJ1Y3QgdGR4X3N5c19pbmZv
X2ZlYXR1cmVzICpzeXNpbmZvX2ZlYXR1cmVzKQ0KPiAgew0KPiAgCWludCByZXQgPSAwOw0KPiBA
QCAtODksNiArMTA0LDcgQEAgc3RhdGljIGludCBnZXRfdGR4X3N5c19pbmZvKHN0cnVjdCB0ZHhf
c3lzX2luZm8gKnN5c2luZm8pDQo+ICB7DQo+ICAJaW50IHJldCA9IDA7DQo+ICANCj4gKwlyZXQg
PSByZXQgPzogZ2V0X3RkeF9zeXNfaW5mb192ZXJzaW9uKCZzeXNpbmZvLT52ZXJzaW9uKTsNCj4g
IAlyZXQgPSByZXQgPzogZ2V0X3RkeF9zeXNfaW5mb19mZWF0dXJlcygmc3lzaW5mby0+ZmVhdHVy
ZXMpOw0KPiAgCXJldCA9IHJldCA/OiBnZXRfdGR4X3N5c19pbmZvX3RkbXIoJnN5c2luZm8tPnRk
bXIpOw0KPiAgCXJldCA9IHJldCA/OiBnZXRfdGR4X3N5c19pbmZvX3RkX2N0cmwoJnN5c2luZm8t
PnRkX2N0cmwpOw0KPiANCg0KQ29kZSBsb29rcyBnb29kIHRvIG1lLg0KDQpSZXZpZXdlZC1ieTog
UmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0K

