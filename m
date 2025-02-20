Return-Path: <kvm+bounces-38800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CEC1A3E722
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 22:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2135F171A0E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 21:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44D192641D0;
	Thu, 20 Feb 2025 21:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PcGW65sy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50C91EA7ED;
	Thu, 20 Feb 2025 21:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740088770; cv=fail; b=RhIPkn3jgyb0jBVDJHVo88qCFiCcdlXmkCWFu53WfiDwEwjF5x+fQqK0z8s8b+Dy8wpKXqwtJwraIr62/FsFcLOE9XSH5vM0NmGsBxY8+pYgYC5sARXdrF3Z90hmTaf7S70DKu6u9/pQ0ZeaS3F5Gp35ZZpRsAQwNeI0wi7fn9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740088770; c=relaxed/simple;
	bh=JnZrqXqInqtMQ70wuYRSbPJy9uCDyGw7ZODBmHRukGs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sgoOrhVZH/XJjWlJNlTfhCqiBzrdebsFZ+/fmih7C660qwA2QE0ayYNB0+AYh+F7crjAuK6GFvq7WOJWZPFr4zC5dWVxy30SZqbn69CTx3Ty84FoHImiMe74MczlQ/07Pyfnl1B4M6pUJv6OwRTFFF++Xseujf/mYVxFIAhYzZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PcGW65sy; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740088769; x=1771624769;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JnZrqXqInqtMQ70wuYRSbPJy9uCDyGw7ZODBmHRukGs=;
  b=PcGW65sysBuIoi3bRhdKUVvr/HthZUvEhR1KXMAQSJNr1XGCILI1tSGm
   DKs7I9d3Tf1cW8FEC1SW2gBhjgxjGkjVLtOC82uO5hwLtmuM0L7iQ8dNl
   uzm2K9NbKFDZJZnOooLknn8Wdk34hYwo8oh1092p14eyxC41MzedbZpcV
   80SlapR75SSHgdz3gZdYKdiYPXvii6P818ANNolXm7UO8SFK9pWluaCdH
   T03oK2fSxpigbxc9azNX0v4p+QoCHq+3+kUCioEfKPwd4ijugXUa00sha
   pY3B4IvzAfBAFvTXCHOcg/hKiYaTC4/jNPsHCosXRXigN63U8QOAkMvSU
   Q==;
X-CSE-ConnectionGUID: wSKqQOslQsqkP0QFmqh8Uw==
X-CSE-MsgGUID: ALpoD94DTOyzxBT2oqdCjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11351"; a="41014461"
X-IronPort-AV: E=Sophos;i="6.13,302,1732608000"; 
   d="scan'208";a="41014461"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 13:59:29 -0800
X-CSE-ConnectionGUID: miy03/XHSNaVhfa6IOjN+Q==
X-CSE-MsgGUID: OEzxKO1wSiaPapySfjq2MQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="146073021"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 13:59:27 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 20 Feb 2025 13:59:27 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 20 Feb 2025 13:59:27 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 20 Feb 2025 13:59:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n2qwzY1StCafm7ZasSzsTtV5XzsNJvkZWaqW8e0lVN7vHoLxkVn/7OVPrv3L9/W8QSRv9CcThEmUNzR9iUp2GmscJlNHT0avhD2yJYMUH18NxiFQ8CzNxWO7/ua0sQx0vvP4WQjafVGOJGuy9tje+0/6xBA95wOoWBPuTSDO9m/2QoC5EKeK2t0bDrjdt4DGyyCdWKflSw2Ac2ad+87Toasu4I2Uy4dnjHZAsudkL+7ES+C+tsF48RhntOu8/vJgZvtXCjAWCK970DKCTKDxAIqwrslToLdZUMs/lpWNivge9tnsJVyILeF3emIS13JN8kw4g11Hj2nqjytfkEPQlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JnZrqXqInqtMQ70wuYRSbPJy9uCDyGw7ZODBmHRukGs=;
 b=LZ0tTriKWQTk6wqtEiUb9vNZaY0qCmOdGu0++x+CPkuponLs3Y20WoRBpsypbxy/V5NPm6cGBPkR/51/5/Zw25sldZXwGyzmRn5W5S8b33nnYneG1FWnmunuXvHPIlo8XN7UwU8qJHYN8ZD8Mn9uA7AD9lvXy3h7DRHVfXPJRQkiy4NZ+4XGoDG6Ywl9KXP54NbClwv1sFncZyQ0p/CofW71PocU7mBs90VbpW2pG8FuHGmk4DxQId1hRcy5D3ksDYxpbioCii50uKE/GA/3NEkknLMbQhH0dwrjlV+tRCBzsqvQ8OEn0MGhhepxBVgpNff7ysNqZ49vBQQkm3G2Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6798.namprd11.prod.outlook.com (2603:10b6:806:262::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Thu, 20 Feb
 2025 21:59:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8466.015; Thu, 20 Feb 2025
 21:59:24 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 07/30] x86/virt/tdx: allocate tdx_sys_info in static
 memory
Thread-Topic: [PATCH 07/30] x86/virt/tdx: allocate tdx_sys_info in static
 memory
Thread-Index: AQHbg7sVaA9DylmGmkirS7vRts9W7bNQve8A
Date: Thu, 20 Feb 2025 21:59:24 +0000
Message-ID: <36bf1015b85686993dba659d5070c2696466f46f.camel@intel.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
	 <20250220170604.2279312-8-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-8-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB6798:EE_
x-ms-office365-filtering-correlation-id: 6879879f-77d8-483e-b375-08dd51f9d6c4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TVlEOGJzcFVJVXVKb1hSemZzbUxiYURjOTBOL0FlelpLMjlCSFFURnZGNjRL?=
 =?utf-8?B?Tkl1S2MzRlYrUC80eDNrNUhPbmpubFA0MTV5T1pMeU9MS21ldDJrQ3JHREFJ?=
 =?utf-8?B?Q2NxbkZBR3o0YmVvM2lsMGJ2ZlV4VFBvQ2pxRjhpdjZPMHNEMittUkZBbE5w?=
 =?utf-8?B?ck93RUExZFp0QXNGa1NpbWQxdnZlUjhTRUhJYmh4bnAwcmtjRVkyckJCM0VW?=
 =?utf-8?B?YnNzbWRRcUx0VndNRURyZGxOQ05mVis3R2s5ODNsSEZ3a0xhRFBVZ0RKYmpi?=
 =?utf-8?B?VEVuMEpFenVweXplczlWdmNsa2dtdFEwaW5YVzZvcFkydXBPOC9OOUhZV3k5?=
 =?utf-8?B?Nlc5K2VPdHN6QWtzbXRpLzRTMzdkaE5sT2diM1NEdVhyVXpkeUVkTXhrVTZD?=
 =?utf-8?B?b3A0Qytta05JUVVzS1luczlTSUwvdzIyMFd6TUUxRDlURnJUZC8rcEJYSm5F?=
 =?utf-8?B?c3FMMGxzclVUY0FIMXdIbXlTKzRxeWNUMlNqR0JFRkVEenJydTZBQmUxZFVt?=
 =?utf-8?B?a1pBc1oxTVg5ZitwY2pyMlRrazVJaTlyeUlYRnZFMG56cHJ0UmNjcDU4ZGdG?=
 =?utf-8?B?US9ZbG9vQ1lJdVMwaHJ4QWpzVDNnOU1xUDdvTzVBWVU3TDl4Ryswb1J4OVVp?=
 =?utf-8?B?SzZ3MzZHZkF2YnU1amlhakNteGJSMHRQOEtSSUFaZSt6MGpBMWh4TTlyQkdq?=
 =?utf-8?B?em50Ynpjcnk5UGgvMUJJc3lNWklyN2FTL2hyRmd0b25henNMUnJ0eEtLTitk?=
 =?utf-8?B?N3BnVm5reUViQjNEMHVUZExHbTBJZTJ1UmdPY3BlaklRdVpaTjh6TW9VSWs4?=
 =?utf-8?B?NVkrUFFpTGo5WHYyY1VTbWdkOU9KYnRyWEVQM3h2N0RSV2lnWU03dTdpRVVE?=
 =?utf-8?B?ZXpHdWJZZVNkV0tiVEVpcGxXdm5zcUJEb0VOWkZnb2p4Q2c2MmEvTWFUeXZn?=
 =?utf-8?B?YWJPWmpDZ3Z1ODhTMmZmWUdtNzFLVXZDNDJSSStWZW01b28yMEhuRFo0UjFF?=
 =?utf-8?B?eTJZRmJyV0JyZi9seGp1ZGVzejI0VlcwMWo5bUora25vRHYwNURmS2hlcUta?=
 =?utf-8?B?aWlIaWdSSzQzSTBQZnpQdGJKK2pIRll5ZDh4SlBBNm5KRlRKVWZQL25TWWRF?=
 =?utf-8?B?WjNVMitCYVNyMVBsSm9uZzhVNFFvU3JHUUVXVFlhM3lvMXlqVm1WajBIYlFt?=
 =?utf-8?B?U0R2cExvMXhXRFp1aDg3OExPTGcrdmlSV1NTQlFwUnRZTlFtS256ZEVTVEs3?=
 =?utf-8?B?dlN5SlpqL0ppUTdqZzVlOXBxa3NPYW42ZGM0cGZLWDYzYXVzaENWdFF0RWhU?=
 =?utf-8?B?U2RvdUtuUjMzTS9iQlk5cEdwK0tPVTgyRStvMjNjUFVtdmpjZGJXNlBSeWRQ?=
 =?utf-8?B?Qys5MVhKRldaOXZrcjUrbkQ5RlIzWUNxdFNvRU14eXM3VU9LS1VsVXZMaTZz?=
 =?utf-8?B?TU9VME8rNWdva1NZV01YTVE1K1orTDJSaUxPcmE5SElFSjJMQTJvOWpISzNG?=
 =?utf-8?B?aVVkeFhXYUpocU5yM250a1JabFY3K3lkdTVwbStoeUtiMGhNMjNoL3ZXYzYy?=
 =?utf-8?B?NStJUTUwMFVmcWJQYkRqUkRmTjg5RHc5QjZ4K3hRWTQ3VUN5cDBoMUtwVm1h?=
 =?utf-8?B?TUdraDJjeC8rNUJBcENURTdacVA3WjhKdldkMVVOc1lSUWdpSjRlU085ZktV?=
 =?utf-8?B?czBHbm50Vkx6VnlpU0VXdURzdHoxYUttV2Q3VWRmRzRoVTVtTGpuK3huVWww?=
 =?utf-8?B?aUF5N2xuTXFycFBUTTNjaXdKMStJU2J1L3JiYzMxNks1ZVhqRGVXN3N5dnhy?=
 =?utf-8?B?cmthcTFGRFBiUERhVkQ3NzkrU1hEVHFwM25VNC9pWTZJSUhjTkZrQVpBbFd1?=
 =?utf-8?B?TERsRWYvckx6aGdnK0RPMVlFdkNGYTg5SXVCUVBpZmo4K1NZQ3QwN3YzSTBP?=
 =?utf-8?Q?/J66A1o2JRq+NrsHTl0dVjgWHaICYCCA?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXpBM0Z3UDFvUnBhL0lITzYzWU9rMW5oNlExdyt1a2pGeVVaajdnYjNLVXZs?=
 =?utf-8?B?bkNQdDRQcDI1TXZDSGN1U0JFSFhjRG5NY2JhUnBFSzdXUi9OdUFtOFk0TzNJ?=
 =?utf-8?B?dmlSR2Z0L1dOOWF2LzcvNHkrQXNmK0t0di83NW02UzVGa241OE15NXdRNU84?=
 =?utf-8?B?emdnd1hObGRLUWxpZlVOQlF1MnZOTWdicnA1ZndwMUVJL1ViQ2RxampISUVy?=
 =?utf-8?B?MHZsNnRCbUkxZTB4N2VoQkN5MEZkd0hjemlLSTMzeHVRZjY3cEhwQUZybnJT?=
 =?utf-8?B?VFF0VyswQk9GN2pCcFVMWXRxMGwwNy9SU0ZlRGJUc3F4WDREbUtMekJvMDA1?=
 =?utf-8?B?eTdhMytDWU84cXRSMktxUW9xOGMxdTVkTDMrN25oaFpxb2o0ZnNMVjFqamVG?=
 =?utf-8?B?dFNOWUt5QTZmOUFZS1lXRHhYTEZ1cGtiOGE2SERuN2RqVUxqRzhIVVRvMHY4?=
 =?utf-8?B?K05JeXlmb2dOSWxkdGRNY29jQis1ekpIdXVZdGRDNi9YMTI1MGhHS3BrMjAr?=
 =?utf-8?B?YTZyTEZQV3hRRE02SnFIcGhPUjExbWNCMW1yNXREbTRPMmk1eEZaOHd6T0Yx?=
 =?utf-8?B?OWh2QWdsRlZPUlFSZ1BrTW1rbVNpU01SZG1JdWFhYk5XMmN1ajl3ZDM3Zlhz?=
 =?utf-8?B?TTRLQmt6b3BGYnZJNnNOUllTa2RRZmZVNk9ySmlLdC92U3B4Ny95bWFFMFhI?=
 =?utf-8?B?OCtUa1NjWkFtUDIyNUhxdll0SksyNGt6TnVKZmpQU0FDVWUvL0d3ZEJ3Z0pF?=
 =?utf-8?B?bDVRUzB2eVRZemFWQzQweFFlYlZDNWRSUVJpNWhvUFd3STB4ZitsekRWdmxn?=
 =?utf-8?B?dDVHc0lzaWxMcGQzN2tqMjNPVzVlU1hiUHFxd1d4RDBCQ1ZlZ1BrZ3l5RG10?=
 =?utf-8?B?K09qMzhyTDlLcVJmdTRCUzFFb0ZJL0M0WHBVc1Y4clQ5elE0MzZqU01icUJP?=
 =?utf-8?B?eGt4YlJPWEJXQ201Nk1Cdld5anpLSFg0QTRJdXM3OHZqMVFxd29XU1I2alJW?=
 =?utf-8?B?QVovMm9teGRZWHViQW1uMjZXWVFycnNQc3hNd2ZsT2dNU09DSmNzSUxtcVR5?=
 =?utf-8?B?ZEhPd25GV3M2YlNKd2t1WVZYa29JaFFub2srL2R2cEVlbHNPMW50czdPQ0Fw?=
 =?utf-8?B?MGZEOEF5ck15M0dQUlE3NTkza1FmRlpUZUNZZWJPMlN2QWJkTzl2b0hkSkxM?=
 =?utf-8?B?amZ3M2Rac3lLWVA3STc1K1ptc1lDL0VITUQ3Q0hWOWFYYW9MK3pOWjl3K2xV?=
 =?utf-8?B?d1R5MkZ6Mzgxb1dTNWhINm5hRWhwaWNpTER3bjFOTFF0Q0RaNEdmcU1MV3Bq?=
 =?utf-8?B?ek5GaDdpS0RnZ2ZCajNKZlZaTHpQdUdoYTRzL1h5cGpMNjU1RDY1ZVFnUUtY?=
 =?utf-8?B?OGlRMFNIbmpaZmsyUVhnRmhIZEFIeE0yUFFvS2JISnBjKzNHQUtpRGszc3g5?=
 =?utf-8?B?UzB6WDNpdTg3eFg4Y2IyRm94WXM4aEUzNUJXcitJYW1iNE95LzFTSDVnb0VL?=
 =?utf-8?B?NW1CUWZpTmhTc1IzcmxzVjgvRE9xTkVvQi9ISUIrUUg4ZW5Xb1NDUUtrMS9y?=
 =?utf-8?B?Q0haRDEwRHBZYU9EdWRUTWoveHptRlRoZ0ZtMEdVcklPYndOU0FPaE8zVWZJ?=
 =?utf-8?B?ajZiYlc2R2l1VTZyZHZuM2Y3Y3paNEVaRSthdnlBUTd3TG1VN25kMHFMYTdD?=
 =?utf-8?B?WGNVdzd2bWdzUVBVRFFTbjlZL2c0WlZJajdjWWR2NFkxSTVmNmVsdnljWWpt?=
 =?utf-8?B?bnlDZDlVM0x1eUlZRWVnVFhOTDNuSnk5V2FpZ3RZb2U5SjczSjJ4aFRiTzZw?=
 =?utf-8?B?dm1GWWplazZROUYrcmpqQXBpU3JENldNalExU3R4ZlB2dkFaY1h3OXR0Rm5i?=
 =?utf-8?B?aXVRa0NxK3IyaFZ4SkM3b0J1TEU4Yjd3anZkb1NQeUtIR3lZSFVnVjBPc3Iz?=
 =?utf-8?B?c2hvMStQd2FKVTU0a1MxS3YwMFI1eHp1TDB6Uk1RanJoZm5CTm4vbEk4RC9V?=
 =?utf-8?B?UFBOUXNncUhBTm9vYXo5V1JLdW81d21uQjJ5ZVpUcjIyL1NVKzhaT0o0dllm?=
 =?utf-8?B?L0xaRTRnb3g3KzFFWG1kYUhiOEpGMllEUEw1SXkyTFl0eVV3ZUJmdjRyOXBC?=
 =?utf-8?Q?6Lwf4L6s9i2eFK6ZDAUQsBlRx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9110458F0A1EF241A4A8E35C76BE51C5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6879879f-77d8-483e-b375-08dd51f9d6c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2025 21:59:24.8314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XzVOrT5Naop5F2DJPCJU+LXOUrnbrfKwg3TUGwYEQFwl3Ma6e8xCo9VoKevQzpjWPUs7aTptFmYSOh5fHKxm6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6798
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTAyLTIwIGF0IDEyOjA1IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBBZGRpbmcgYWxsIHRoZSBpbmZvcm1hdGlvbiB0aGF0IEtWTSBuZWVkcyBpbmNyZWFzZXMgdGhl
IHNpemUgb2Ygc3RydWN0DQo+IHRkeF9zeXNfaW5mbywgdG8gdGhlIHBvaW50IHRoYXQgeW91IGNh
biBnZXQgd2FybmluZ3MgYWJvdXQgdGhlIHN0YWNrDQo+IHNpemUgb2YgaW5pdF90ZHhfbW9kdWxl
KCkuICBTaW5jZSBLVk0gYWxzbyBuZWVkcyB0byByZWFkIHRoZSBURFggbWV0YWRhdGENCj4gYWZ0
ZXIgaW5pdF90ZHhfbW9kdWxlKCkgcmV0dXJucywgbWFrZSB0aGUgdmFyaWFibGUgYSBnbG9iYWwu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29t
Pg0KPiANCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg==

