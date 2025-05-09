Return-Path: <kvm+bounces-46099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B4E0AB204C
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 01:35:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F68C1BA4206
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 23:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF565264F81;
	Fri,  9 May 2025 23:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eCRZaiXp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E97023D28F;
	Fri,  9 May 2025 23:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746833715; cv=fail; b=Om12v1NbEfgfyLPWLwJ5syd6/KuSDazIrzx+h17dF7z+7NzS2JPv/Y/khZtGIjfe+fddxoSvd+6CC3QVqhDqqQSXF7+AJ2c20JBNauueSyqDq0/b3/GCHqRdTlA0LZeoK28/AH9J5d22Tr7u6WQQ+Zr6b1CidzL5SOspMIJ4pwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746833715; c=relaxed/simple;
	bh=NFXB/ASEEwS2j5xFqS2dj6Zl4SBPQqCyyI9Q/XJ5HmY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZrCdSh5zdWbdtstbDWkDnWq8sKN935V68qGo7Yn8nU1iavtKrYW/4LSpVhroUSONtC1L6q1CqNj17dR/+QY61LG7hX/q/DiA0xhdTgh2lwk1cw/xkcDsr3/1/rbQj7ovv4AKiotrXBkVBlUMLre//tM3k6/bfQfUhQyxktHkBb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eCRZaiXp; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746833714; x=1778369714;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NFXB/ASEEwS2j5xFqS2dj6Zl4SBPQqCyyI9Q/XJ5HmY=;
  b=eCRZaiXpqg013WoEQc2F6c0vqlBbRLJZ6UITALhq7k/OZPT6XWB6pD1H
   Liq4P5AhbrB6oN6hWku9awc8ZnV7zXqBI7BTt0uGUbiYlJU+jn9kM7yNm
   dzKkdysMBaR4dJOI1/kyLviEAnULtVPrBgmtvVTgzjXp3EXr7x4sVzoiL
   slS539e/2ON6x9lOHm1M82te3FR7oNlWmGVTRmJstX9EGaAAlP7BdL3vJ
   muo8l2i0Y43pjjqvEgB0qR8f+ervZdD9kf05JH8zspBMN030DoOKSLhaq
   5Kvd1VFMBRiBca+GDGvEVBEnvHrvEvZYDlcdXtYCIo2TJXKKTDGJqujEg
   Q==;
X-CSE-ConnectionGUID: FPOqc5EwQaCupdmRS9hyBw==
X-CSE-MsgGUID: mZj0TS/yQ7mM42pX6YOs5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48683868"
X-IronPort-AV: E=Sophos;i="6.15,276,1739865600"; 
   d="scan'208";a="48683868"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 16:35:13 -0700
X-CSE-ConnectionGUID: IpZ1NKddSqCHSN4ZzI9ddg==
X-CSE-MsgGUID: dJE6dX+5Q9OqYjjYafrKeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,276,1739865600"; 
   d="scan'208";a="137740464"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 16:35:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 9 May 2025 16:35:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 9 May 2025 16:35:11 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 9 May 2025 16:35:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cNa/D6aGl3dI7+D5Lc7QQdVUGVnfZzD3BavsmsyqPA/OEwrx1rXPBDD/Tei0qlz2tnK4qD+HZazkxLenkQxs5wji4N/WYvOPRjT/RFB/hCprtyWZ5MBnUWI9mJFRnQU6L9p/ggEGf5eCqgcpUFE+DZzAtaHCl2ojMoK1nPqPoVaSZ0wp1Apbk3P7ODv3/wOgYGwkmrLaEmgg5IFPAyJGTxuNssxQmw1rk0eaSLiCZ3KHxi0J196Vx13PfmeB2LHgpxG21KPLjxMxS66B9HiqNBZ/watRl2uI54qVknJb+NtwYNylfonsu1ieLrgyM557aIQboBWVQRuuHKjsoqgRZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NFXB/ASEEwS2j5xFqS2dj6Zl4SBPQqCyyI9Q/XJ5HmY=;
 b=Y+HQYwiXK3BQlzwSESpDtYXxXlHaCmT0P6Or9GI12kFlmjcl//90iYFT4Voqur+zQ+SWAL7Y6HF9Zhig3iLz2RIASHpMxv+1jplMZoHa4cQ809kKzl7KiplyTZXQ19X73KujhHGgg0bpW68tCNGsv+CbfW1nIk9+y8EvnwpNEjt0qGv2VQzmhYnRu94I+8S7S9Hpx34wxXlBUmbs1KFsOfmD66qW2MJmyC1y+AqIqI9iGBPRyiO91o3o6Vv5GJex3GY9BaKNF/uYIGdy53CZdOEoytCkZbPukgvTEqpnBOvkU1jKyg3HODWljJ/dJ2Vg9YZS3oiRoNCoOerefxuC7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB6471.namprd11.prod.outlook.com (2603:10b6:8:c1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Fri, 9 May
 2025 23:34:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Fri, 9 May 2025
 23:34:39 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 18/21] KVM: x86: Split huge boundary leafs before
 private to shared conversion
Thread-Topic: [RFC PATCH 18/21] KVM: x86: Split huge boundary leafs before
 private to shared conversion
Thread-Index: AQHbtMZ+14Tf5LzGk0+2X6kh0KPzFbPLDE4A
Date: Fri, 9 May 2025 23:34:39 +0000
Message-ID: <fa85ac0cf3e6fae190dca953006d57c02fac6978.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030844.502-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030844.502-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB6471:EE_
x-ms-office365-filtering-correlation-id: e285bfec-8b37-4cf4-657f-08dd8f521163
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dlRHU3VwaW9HY2RpMmIveFdsMDhJNGRVR0FQYXI1R09sVTloSkVZbm51K3ZQ?=
 =?utf-8?B?NzA4SGh3TWhqcmZkMStYbHhNVXRvWUg2Y0dISDN4NU1hUGh2YkRJOW9iSENR?=
 =?utf-8?B?c0J0SFF6S0VLMTZNNFJsTkN0NWNsY2lnc3dzSy82bDNjT29BeDZ5YlorSFFq?=
 =?utf-8?B?UTB3Q1V2N2RGSmROcmFRZE5CNHVzVjZIa2piNVFuQ2ZEcWwveDFOWEV2VnEw?=
 =?utf-8?B?RUhuRjFJbFE0S0tFVVJaSG5neU5ONzBYK2wzQnVHUjZGbHZnWk5vdmZFY0pL?=
 =?utf-8?B?UktzMzVoN1MrbUdiaGJGQkJkRDEvdEh0bkVVUWtUcDV3WTZQbFVWdmF2eWFO?=
 =?utf-8?B?OUtmcUFzVUxSMEgxR1RBQ2Z2djdWUno3OW9CSGc2ZjhHNzl1OTdFeFNVNGk4?=
 =?utf-8?B?V3pNTyt0N0VaRmZSN2FLTkxMcHg5eE82VUdHR2lwWEIvQnU3bkx2RG1JWlcr?=
 =?utf-8?B?dHZoUXJFdlNFa1JxblpKeWJ2ZjFHRFNQVXgzZEwvR1pCc2ozbUpkMGdGNGpO?=
 =?utf-8?B?dDNlUGp4YTN1ZCtJcFRQTTUxNGtJZnJ6aEFZRHQ4UkwwQTZCMnRCdWNZb1ZO?=
 =?utf-8?B?bFVlOGFKbWtkU29EeHgyVFhvTWdiSGtWc2cwZW1BUSsrandONktDSE1TRUNq?=
 =?utf-8?B?cWQ0Q2g5cEw2ZnVaQVpXelh6WWJKSE5yUGpSTGhjS0xuNFRLQkZVc00zU1Jt?=
 =?utf-8?B?NUZyRnlteG1LNmY2clFaWTF3VDVQdzVSSVNxaklpMkVRQ2xFQkV6ZU44RnhO?=
 =?utf-8?B?UWlVa1R1RXZHYWNMTWVURGNIRWszWUtpS3dvNEJHb2dsdmJDamFoS21KVDMr?=
 =?utf-8?B?ajZIZlBGclE4VDUyWXE4L0JER21mRng3RUY3d0lYYXdSeFdCOGdoRG4xUUhI?=
 =?utf-8?B?eTBSdkFYM3ZoYnBUbTVSUE94eHFnd01PdFFKVU9BZHJBK3M2bjZMdjhURDVy?=
 =?utf-8?B?RVZxeUh0ZERHeG10RzQ2cU1QeTd6eVR1SnA3MktuT0Vqd1RPVWZtK0ZMaGRB?=
 =?utf-8?B?YWtnWDZFUm1IZWQwM3cwN1JSaTcxV2tmWDJ2SndPL3V5WG51eVRLTUFaVmV0?=
 =?utf-8?B?QUJ5N1cxV0lsOTRlQkFlb1czNVpoZVd2b3RCbDlvQ2ZrUVNoWHFEcTh5RzR2?=
 =?utf-8?B?V3E1MjB5UTFzektWVzBvdHZQYXErRlpCQWFQUmxScmkrMWs0Y1EyekV3QVph?=
 =?utf-8?B?NFFlZTZyVzd1ajYzY3dYZFBHZVlZOWtKR0ZXL0t3cXB6TG8wNGtyWm9sS2lE?=
 =?utf-8?B?ZGhZZUMxN1lvTkVxeDM3WUxET0pneVo2UjRlTXhuQVhneFdzcDNNOEkzSWJy?=
 =?utf-8?B?aGtiQUw0bVVQbXI4OXlRT21Dcy9yZmwwOHZzb1Foa0hROVpsTkVyemNQUWUv?=
 =?utf-8?B?Qng3ektsdENSK0ZGaGtObExLM0p5YlROYS8xMUFib1V2WjlFVE5zV1RONFpK?=
 =?utf-8?B?bklOMEZFTk9ES2dzZ2dDR05BOTJxT2RZdCtlSmhhcU1UN1o4WUE5R3Z3MVJv?=
 =?utf-8?B?Rm1lWFI2SERkT24wUVhTL2Vna20wQ08wZ0xhQllrN2o4ckljM1pJQnhMRndr?=
 =?utf-8?B?ZzlJQzhRZVF5MlFXaTRHcTlFbDM2NUlUbWhlOWtvRWFIcUdaQXpsd1dUM3lj?=
 =?utf-8?B?aHVkVmpjdERHdFJic2IyNVZSbmV5WkNWYlcvYTFONEloT0FTWXVocEVVTnpJ?=
 =?utf-8?B?QjUxTzA0cUYzTmowUnRzTFFKRzRYOEI5bm1SdWdKSWhMZHBiRVZkN3YwTUJR?=
 =?utf-8?B?RlE4VnBPUGY1TlVvcEoxWHN5WlIzMU1raWxhYkc3eTlVSkpHaEJGUHBtcVFS?=
 =?utf-8?B?MGFjOXVrVVJ5dGpNaVg3K3loalhhL25qUnpBcmVWOG5rRmtVTkJxdnF0a1RJ?=
 =?utf-8?B?NkFZMWhONmVJQkY4eWNPeVB3NnFhUUMyNytGbGxXdmFzbHhjb0VzcFZCQUlu?=
 =?utf-8?B?ekl0WUhwZzdaKzFRRWN3WU1vVTF5aVpHY0kxZklCRHJrRksvdGJPVktKNnpK?=
 =?utf-8?B?N3hFL2E0bStRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2MyQkdsc2Zzcm9QZnQwWUYxR29aclpZbmM5OVE3Q3hJZkdicnVNT3RzWkJO?=
 =?utf-8?B?SHJPWk1MeUlTZzJLN3VmdU9wUGhnT0h1K1NmbkVTT2RGVm54SUNLbHBZTzlj?=
 =?utf-8?B?SE55bURpZ2g0QW1WRVNkM0VQVmlvdVhnUnZ3L010djlBNzZlRSt6K1pxUEZH?=
 =?utf-8?B?NXRHVDl1NE9XN2tNZm5IS0FyenFJMmJMWE1vTHFxU2pPTWF0SnpwZmQ5cVdL?=
 =?utf-8?B?RzljVkRGb1BqamhsN2M5SC9OLzZ5Ritmem1KSTYxZGNpNUwyS3p3TmVUMVln?=
 =?utf-8?B?TjNvTDFTQVptRU1iOXdLMGR4NVQ1RDZoOEJNZ2pzYTQvYmRjL2ErQ3ZWSXEy?=
 =?utf-8?B?QnFnemp0TWVhYUliS0RMakhxTTJVQnc0Yy85RmRRc0J6YXoycjk1U2NNclZU?=
 =?utf-8?B?cTdZZEdrZDQ4UC9PS1Q2ZFV5NkhYMlJYRjUydndQK2ZFcFc4cnFWRFovZXFC?=
 =?utf-8?B?bHNkMTRCcXJFaXdDeVlBRHcwbkR3dTlZd3FscVcyNG9ScTZ6L29iM2Q3OVV6?=
 =?utf-8?B?VXZjVmhBR2FkcmFreHE0SlNHVEp1d0h4SjdpY0NnOEg3T0o1UllSd1gzVWcz?=
 =?utf-8?B?a2s5MVRsY0tkcVUyeVo1aURFNFQ5cERhc0VhY0dKVG8zNXdCY0swTmt6aDI1?=
 =?utf-8?B?T2crL20vcCtKSVEwckRwQ2pDQmg5Ylczc2QrdytGMnBXbmUvZnpmdmNpUHdK?=
 =?utf-8?B?THZ3YzFyblRobTFTNkpydXRPTFFBOHgzcnQ0RWtIYkYxM1g4dEoydEE3Zzc5?=
 =?utf-8?B?ekZWeHZFSDJwVlNWb3oxYkRvck1WaWZuNHVuakRkLzVZbHNiRHVvZ1UyWGJM?=
 =?utf-8?B?VW5HMEg4OEdmVWc3b2t5dkppYnlyRlJ5RlVFWWxYUTVrZllBM1ZLcEo0bnNq?=
 =?utf-8?B?aXNFd1pDc083UXI4RXU3ZUtZSlFrOXl1SDFSSXQzL0pCdUwwSmk5bUVldFZW?=
 =?utf-8?B?dGVtY25sSktBZi9wVjc5c0dnZ2hRZVA2RkJWTTBlUEkrVDNZNUlRZkpFNEtv?=
 =?utf-8?B?VnJnTjY3UFhBaXgxWFNTdDNpMXh5eUR4MnlEcmFxaklEWEsyRVZ2amZpYUM1?=
 =?utf-8?B?dDRCTWtYcldTeW5LcEpRMnA3U1JBaEhoR0M4UlRhd2N1TlFBSjM5bTZNci9m?=
 =?utf-8?B?dVRxb1ROdDl5NW43NlFCKytiZUFXN1IybUZkNGFLYlZhT25EZlhRRVdBYjZ3?=
 =?utf-8?B?c2NwUXE0S0FvdytNM2wvOVFrUlFKN3BiQlNRZjVBMFFuL05oWlJFeTR1OW04?=
 =?utf-8?B?SnVobTJyVmVIeUU5eEswTXM5VzZxSVRYa0Mxd0UrdE83aFY2RkNnR3h0WXNk?=
 =?utf-8?B?M3Y1RFkvTXlkaG1WamdmK2lTZzk3ZXJRd0ZZbkxiVE5hRWljQUFsUkYvQU1z?=
 =?utf-8?B?N2pnZXZpTmx3YWp2MlpJaVkrdjBueUU2RGRhSmQvbHhveG52SUU4WkZMRnYv?=
 =?utf-8?B?cTBFR0RPc0pLUkJOdWZERHZMd2NRa2JiZHRDUGJRa1lWV3N5d3dSQVN1UVZs?=
 =?utf-8?B?UDJSRjhKL0Q2a2J6UktvWkk5Ky9OL0tmNldXUzB2VGdKM2R5SExpRHNpSjlw?=
 =?utf-8?B?VjhFUXpQR01CekJTTS9aNGRHQjU4RDJDL2s5dXRwemcyalBVenR0VDJRNHcv?=
 =?utf-8?B?bUpneVRhUjZld0djdE9JYm01U05KQUlrQk1uNzFqZklZMVN3UlFsZkZFTXlH?=
 =?utf-8?B?emIvdGh2dkVLODU3TVNMOTFrcVNoamhvVkMrcE1vaU9XOGlJRzlqQmJmc2dv?=
 =?utf-8?B?UVdQWWlKcWdhOUpOQjEyYTB1eEtlUzBjaVVmdDRPSE5nbk9veTdYSlprMndr?=
 =?utf-8?B?ZDcrSHVSNk1ya3k0VEptOWM0UEwzRUR4YUhZN2M1MmpMcEpjbXp3TkpCSndj?=
 =?utf-8?B?RTlXVEpFNVU2QWlXdWhveUd3bk9HN0t4UlBJRGY5K2pKUGZrdFhwUXVTRVht?=
 =?utf-8?B?NjN0Wmtob00xSjF1RHExS0tEVE9aSUhXOG9xeHBpTXhCTlh1RDRkTzlHMDBW?=
 =?utf-8?B?c1ZCcWxUNDUxdWhrSTZtR3BiczdFUzdpMlFhaVlieDVQZTZQYktNTjREczNK?=
 =?utf-8?B?S3VFYmZCclMraytFNTBqTkdpQUJJSjdna3MybWpnZitEc0x3SHVnLzFaakRi?=
 =?utf-8?B?VmZGZGIzaTVjUjJiWDBhTWI3OXowMXBJQ2ppL0gxdFNvcnA2TVorM1NET25S?=
 =?utf-8?B?MEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <08C30B8DC223584DB7FA0BD2EA05D8FA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e285bfec-8b37-4cf4-657f-08dd8f521163
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2025 23:34:39.8235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BZHgINikYqJXSh69q9rvpZNoHzIVPmK6xd9GiFIUPlvyQEMBEhgMMGWYfnHMmlz3Z6Y4IMpsrDfYktdGxw9E8K4gB4m1uz0rRNiKOsuwHmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6471
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA4ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gQmVm
b3JlIGNvbnZlcnRpbmcgYSBHRk4gcmFuZ2UgZnJvbSBwcml2YXRlIHRvIHNoYXJlZCwgaXQgaXMg
bmVjZXNzYXJ5IHRvDQo+IHphcCB0aGUgbWlycm9yIHBhZ2UgdGFibGUuIFdoZW4gaHVnZSBwYWdl
cyBhcmUgc3VwcG9ydGVkIGFuZCB0aGUgR0ZOIHJhbmdlDQo+IGludGVyc2VjdHMgd2l0aCBhIGh1
Z2UgbGVhZiwgc3BsaXQgdGhlIGh1Z2UgbGVhZiB0byBwcmV2ZW50IHphcHBpbmcgR0ZOcw0KPiBv
dXRzaWRlIHRoZSBjb252ZXJzaW9uIHJhbmdlLg0KDQpGQUxMT0NfRkxfUFVOQ0hfSE9MRSBkZW1v
dGlvbiBmYWlsdXJlIGRvZXNuJ3QgbG9vayBsaWtlIGl0IGlzIGFkZHJlc3NlZCBpbiB0aGlzDQpz
ZXJpZXMuIEkgbm90aWNlZCB0aGF0IG1tdSBub3RpZmllciBmYWlsdXJlcyBhcmUgYWxsb3dlZCB0
byBiZSBoYW5kbGVkIGJ5DQpibG9ja2luZyB1bnRpbCBzdWNjZXNzIGlzIHBvc3NpYmxlLCBpbiBt
b3N0IGNhc2VzLiBLVk0ganVzdCBkb2Vzbid0IG5lZWQgdG8NCmJlY2F1c2UgaXQgY2FuJ3QgZmFp
bC4gV2UgY291bGQgdGhpbmsgYWJvdXQgZG9pbmcgcmV0cmllcyBmb3INCkZBTExPQ19GTF9QVU5D
SF9IT0xFLCB3aGlsZSBjaGVja2luZyBmb3Igc2lnbmFscy4gT3IgYWRkaW5nIGEgRU5PTUVNIGVy
cm9yIGNvZGUNCnRvIGZhbGxvY2F0ZS4NCg==

