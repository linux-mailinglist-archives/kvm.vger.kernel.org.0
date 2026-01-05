Return-Path: <kvm+bounces-67083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B12BCF5C53
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 23:07:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BCAA73098DE1
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 22:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C18B6311C1D;
	Mon,  5 Jan 2026 22:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kkdfK2G1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA03311954;
	Mon,  5 Jan 2026 22:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767650801; cv=fail; b=Zjk77i+d2NYEyqQvgr+wGCOaDkej3YHEmyhtKAVpufCXPiAfkzsv7IHzyvyw/HcwoB7f4wgp221sUJ/qjjfCykkfnlpLvhyr03tI5Y56agT65ScjhpFuUIA31y9RQVZnSZqr7JhlF3rEfwavQExaEZkfP9eh87NSFXl894+Z9lI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767650801; c=relaxed/simple;
	bh=EIw9k5uDSsc1+T/Zje4jpaszgzwtvbfIpBjVioG5/1k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WqBpHCqwXQQ4pbSWs3G5AMbkhPtQ4PHkRDFu3OfZ0LaaqziPdQ4kOlbRvSvbUhO7Gzw6/23cRZLRhOEDb1ml1vryG+2o6Xk3ETgv2EAleroHggjP14t3obD9ohsUCHLv1GuoJRHn6E5FaCZNUyX5AQUyEcpjQ4wn/pW8TD8DS9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kkdfK2G1; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767650800; x=1799186800;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EIw9k5uDSsc1+T/Zje4jpaszgzwtvbfIpBjVioG5/1k=;
  b=kkdfK2G1MWIsj1BRlWd+4K4NFBczfnSo7Up653mBr9+r/hqpSuZORIA6
   fd1g/4rXgeRCrzFksY3RKCicM9PunRSy/+GLjeKR08QA2/J+yXfTmAGlF
   gWUcdDaz8zYgIRyDFOnIcc+3CgWehYBfq7qQRP+mFQbFV6EL0qwMLC8VK
   ld6P2ISU/WtmgKMiEyqcC0gNZkqdqv1nshaSPDmJEOUjgQbcyOuYLvkzZ
   oE1+OY5iz9MowhtCq2aH/+biRTEFwMuCsNz4Br9kAGLB6+6Y6lubhBWHM
   /DyUH9Q2QgF2i0oaQGpPc68d3TiPLcCSwZtcYelWq4Q24yDfv0+72hnu9
   Q==;
X-CSE-ConnectionGUID: svEW8CJFTx+holis5V+/yQ==
X-CSE-MsgGUID: RpTZhPV1RoK2H0lxAsbYDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="68926339"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="68926339"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 14:06:40 -0800
X-CSE-ConnectionGUID: cSuKSgzaRBmcjoOaQZKm0g==
X-CSE-MsgGUID: PSZ/c1ZsQNiS8rtwDQuGGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="239982022"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 14:06:40 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 14:06:39 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 5 Jan 2026 14:06:39 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.53) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 14:06:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vgOfKuBj/Djb6Se+ztn7EY/UbNUloGw/tMjD3ho4FsEUAQLaIR8n3IF8iw+W3kbRtnn3kgriYWdDyDF90ZKdKVvd/AN+i5gJXXrxMXcfAw9vAJeqrZaQMQYxCyyGKFs7d7XBizyUZI9uJwsI9E4Y5/IY3W/heBrZ/Hl77jzAykMY9RNGQd4NPU9DMpson+TBcYOB9MdENjOdYM34xsSKlJzFVST71W1vkWRHhD0Pn8Nv3cyVj8C97MpG0XKpPt9To+JOs1eY/TWcXQV26yx0+UAoY/iAdiFnDPdsNw3DP0s6WSmXsQ6rsI7rPjrP7NWFwe+eC7zqy/tNprVmMCUTmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIw9k5uDSsc1+T/Zje4jpaszgzwtvbfIpBjVioG5/1k=;
 b=WhNNuIbaWwCkvgutp28zLrlcOdd1nfR9tLsCCESMSMvEewdmvWQ/3N1gLq5NF8YrS6YYTekgqcHmVVTP4WGyiEgB1uAfdmrJZPo5+rYw//h4pbeFm7An6blh0+FWc9g3ftTsQIZYwR3vA++GooeNXaPxyMCIpjIa++vDYY5C2LFsN6QEVYoQBn0CX7tSOFBW3fP4BZBanRweL6C4MxrJUqICCxzouJkef34TtwN+jhSqNZrpqYahGwGR8TQW0L4NZmSnLCp5jOZhGGJYYU+hjYFCF4ztxWCq2wsPsA3+USGqZM3JSK4bY1D6yFErjIJ4z7vKirHfQ0Z9xaOJuVfEdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB7132.namprd11.prod.outlook.com (2603:10b6:806:29e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 22:06:31 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9478.005; Mon, 5 Jan 2026
 22:06:31 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Topic: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Index: AQHcWoEG0U6tpU/nuka5qLmVaBAkzLUwtToAgBO02gA=
Date: Mon, 5 Jan 2026 22:06:31 +0000
Message-ID: <0734a6cc7da3d210f403fdf3e0461ffba6b0aea0.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-5-rick.p.edgecombe@intel.com>
	 <aUut+PYnX3jrSO0i@yilunxu-OptiPlex-7050>
In-Reply-To: <aUut+PYnX3jrSO0i@yilunxu-OptiPlex-7050>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB7132:EE_
x-ms-office365-filtering-correlation-id: 8710667c-b445-4ead-0292-08de4ca6aeb1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?TVpHaTdSTVZGSlV0cWEvUWJMSlhXeWVBTGZOZERhZUJ2T1RlWlN3U0tQTkxj?=
 =?utf-8?B?WERxVHByMEhYUXQ5K05XZ3dxU2d0MzJMOHdtbURhMmhnT01QTUl0amZXcnE3?=
 =?utf-8?B?anpkajhmZy9VbmUvVHV4NW5FYWNoMW9CdUU0SURENjFTcDVLSi84NVc5L0Ew?=
 =?utf-8?B?Qyt6Y1hHdDQ0V2IxSXdqSkVaZUN4Vms1ZVJlY1BqdXpPMlN0U3c4RWZTd1dP?=
 =?utf-8?B?RTRIKzhIRHB4YnZLbmpMU1I4U3JHNmE2WVU3Wi8rSGMxNVhpV1Jwb2pzVGVJ?=
 =?utf-8?B?d2xkN3hWbnA0UjdnYndHQXg2bzA4SXV6QjdYZEYxQnJ1cjQ5Z2ZkYy9aU29I?=
 =?utf-8?B?eVRlTjlvQ3hxQ2RXeFJHT2FrM0xhOCtoTUwyVTNhOTZ0QU1rT092YkNkMk9x?=
 =?utf-8?B?N2hWd09ySU43NVZsbkVCdEFTQkE2TDhxMkNxYi9BMTNvSDNMcEUrMGdkUlpG?=
 =?utf-8?B?Nms5bWxLelorK3NHU0NnZzRyNElKMjJFNEI2MWFvUnI2MmhHUVl6Y2tRanRp?=
 =?utf-8?B?NkprQU9rdnMwU3RXN2lJQUFpU3BjQnd1bDdVWHUvZEVUaSt5SzNUWjA5dVM0?=
 =?utf-8?B?OWczeHpDWEtCM3NwSGNtY0NpUE1VR2lCMEZzQTJ4UXV6bWZwSDBwYThYVEcv?=
 =?utf-8?B?VlJRMERPMUt1d2h1S09yUytpUEk5cGNHTjBZTWpwVytxQXZSS2JOQmFRWEdR?=
 =?utf-8?B?QzJhMUhWVVRiaStzR1ZzbDlOVjZKNEVXNzc1elFDTS9tak9sRGpoclRwZTlB?=
 =?utf-8?B?dENPTGF5eEJ5L1VKRXVXbUFBRVVwQTFMZVpYWDQ2bFFmNGtBMXMrT2ZjY1dB?=
 =?utf-8?B?VzlWN08vT1Z1QXViMXBrS1pMNGpWQUtqR3pWT2t1U2NkQk1nL0IreTZuTjdH?=
 =?utf-8?B?OE5laUhoQjZaSStrVFl1cUEzR0hlcHd4VFlMYzdGT1dHMGxMWVBqcWZVNUtY?=
 =?utf-8?B?dlQxUzZtNjBPQU5yV3Z4MDI5aGtwOGt6WXJjNU8xcVo5QUsrb2VLbWEzTDZ6?=
 =?utf-8?B?QmxiNE0vVlo1aUZURmZIUjlnbTBZMlpaQ2VRaVNMK3BUb0creFRFM3NGUnha?=
 =?utf-8?B?NDJJU1VLTVpkdlBTeSsyS0FrdXlTWlN5UEMrZzhiQytLcEI3SElIUXdISnFX?=
 =?utf-8?B?bXZkczZPdDJ5WGlzOGZGL21GdVVoTm5LbkdLNzNMZnpxdXpCK3UyZjVwdS9O?=
 =?utf-8?B?UFJoZ3FxcXpVVGMvdnVKMURFZVJiV29TUWVkUEo2N01YZktOYVRrZWJnVHNj?=
 =?utf-8?B?bWNkZ2hYSzFGa1BxT2NJZldpREI5MVVSbGFnZVZBVXNVMklZcUs5NERQTkhC?=
 =?utf-8?B?UVZtVlp2SFh4VzlUQUpRaWIwTHdDaTVUenQwZ0trTHNPTldZSDNWU2tFUGRU?=
 =?utf-8?B?K0MzMG1DTWRQa05tbW1UTVVERnBNbTBnUUMrVDNzZkIySFBkcWpIeGpwMW0w?=
 =?utf-8?B?amZseXpQd1RpWU1PZXRiWFpaZmhKb09PaDBzbHFWRGxWK1d1L3RzSFRPd2g5?=
 =?utf-8?B?OVZuRklBU1Q0c25GRStsT1lwZXVIc1RwWk9MTEN1V290bkJUY0diMXc0d0d4?=
 =?utf-8?B?MytLR0ZKdkRMeDU1aEdYWVZ2RXVwUDJYdnowZk1XZVF1aEpkQ1ZzSFhFSHRD?=
 =?utf-8?B?NnJLdkdTbjBUSHZQUGJESXdRMlBTSVF3VlBoMnpwNHc1VGEvZTU1Ymk0MmV3?=
 =?utf-8?B?YjYxWHJFSmRBa1BLVFJGdzQ2dk5KVTBkdWNoTmZHckE0N240RlhyM3BUbGhL?=
 =?utf-8?B?SXd6TktuN3BUMlRWWThUZU50T2YybGsyYnc5cmo1QWJycXdDdHUwOCtiajZD?=
 =?utf-8?B?dVFvRitUa2dVWDRuZTFFa1pOaVU4Q1lQUVVsZkxYWjduTWI5TWJIWisyZ25Z?=
 =?utf-8?B?L3dTcjUvclpVdlgwN0FTcW11VVFERGRCRkYwVjBJTFZnMzk0MGFnRmNlUHZa?=
 =?utf-8?B?a2ZiTTRqNXlFUUMxQTRpUW9zVU9ySkE4UkU5dWhWT1pDWDdjREI1K20rQUtV?=
 =?utf-8?B?UWhmdHFCMnpnU3p3aGVvaDVOTDh5dlppSG9VaFhteS91aXBvMEhXK25xNU1i?=
 =?utf-8?Q?f009/f?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OXppOXBicExwa1dQVnFTMm92U1FCVFVwZE1XZWdPWmpXY2J1YVFlRGRtbnNn?=
 =?utf-8?B?NnNLNFJQclh6cE5OYkl1U1VoRkhsWlFWVVFCUytHZm90OWFmazAxTU9DMEwx?=
 =?utf-8?B?Z2ZYVFRXYVdheUFwa25Td2d6c0wvcEtkL0lReUJiWFJSTFRlM3RaSzFtN0hq?=
 =?utf-8?B?UG1SRFJoZm53VFNOTkN1czg0MmdKZDBuVTl4SDE0b2xWdHVLMFZ2QTI2cUdI?=
 =?utf-8?B?b2JBQUZzWVlaWGtFUW5XcTIzZnY4MGJiWHF4Z1pvYUk1RkhxbkdmM2Mxak9y?=
 =?utf-8?B?YU5MVG1OaHFHN2JwdWRzaFlqVlFnMGZORGdxcG11cnZILy9wM2N5V2drRjM4?=
 =?utf-8?B?a1lMb3ZXUXIyOGdWRjdNKytUMUc5VS9qaDlvVTkyZ2o4WmhZVUJwMitjczNs?=
 =?utf-8?B?R3J1U3Y4Zlh2ek5sTGRabkFubjEvS25CL2MyUUtjbTR3MmZZN0gvN1I4YzB2?=
 =?utf-8?B?S3JpcjNrcXdObmF2UWdCQnVaUmduYlBCZSt1TWQxbGYvQkY1djQySitjTlUz?=
 =?utf-8?B?RlRoakEzQS9teUdKSDJoWmhHdjdlbDV0UlpNbURab0tRdmgydzk4VSt0RWU0?=
 =?utf-8?B?blc0Nzl3Umw3Rm9EZ2RpMDlRN1k0WmVHamttOWlTVXRyR1R4YjFsYjNCSmJi?=
 =?utf-8?B?M05vc1dmcFZvZFp5RDh1dk56NkFaMEYxUUxuS1htZndYdmloSVZBOW9IbFRz?=
 =?utf-8?B?S0cwV3cyV3YxTzUzaGZCZE9CaUZUaVNQRitYZmo0YXVhc05ubW9PRFJFZ2dG?=
 =?utf-8?B?T0tFOUN5QkZVNVlFcFNQQ2pZQVN5VFRmaUlndHVqSDhVWmZSNGdkQU9ObU9i?=
 =?utf-8?B?STZhTURNRnIvc2xORlRzSTZ5TFBYNllMMGcxck5yT21NSWpPU0o4RUJpdFNa?=
 =?utf-8?B?a1FldEZKSVRzczM3V0ptUFhpK0NpcVdVZEZDVXZTUDJQSGRFQnczMW8yMWJI?=
 =?utf-8?B?R0xQMkh4a2RHbkJ6VGk3VGpOd2RMN1k1OGlUMXo4alZtSkhJVnhZclkzU1ZL?=
 =?utf-8?B?UWNvWjVqOGU0clU4YnJWSVB4ck96UUxETUVBaXEzWEpLaHdHY2RScnpYVVJu?=
 =?utf-8?B?VzZXS0V4U05yZzhMUjFabDJaOXlFdXdhM3dYSExTL2Zyd3Zqd3pIUHhFK3U0?=
 =?utf-8?B?Q00va1F2d0xlM3dlVElkTDFqNFlMdVJLVU9oVW1IdTZTRW1nNjZnSzNLeldk?=
 =?utf-8?B?WVRxQXA1aGVaQ2FZU2ptVzM4WCtVa2VXRzlNb1VBMFo0VjRpWEpmN3RRcTRN?=
 =?utf-8?B?WTkxOE04VXlMSmxTWGFuZlYxcVJ0VzFONlpRdWl3eE5FWmlXUFBnSm5mSTNM?=
 =?utf-8?B?VVdjeHNXTUlDdXFhRnFMZXg3cmZzNHVubWpzUmpJTEdQMkRpMDJQc01LK01V?=
 =?utf-8?B?dzRtSVAzeitFd1EvVVZvRnBzRUg4b3dva0M0V2VuTFBxSU80dXF2bzhEREFz?=
 =?utf-8?B?bmNuY3ZaZE51dmMrM3QvVkpyUWZzN0JvL0J0enQ4UWhVWUtlbTd1SCtJcXZP?=
 =?utf-8?B?UTBmd2VOcFdWWnVSUDZBaUN3aUdVRU9IblNZQTQvWUVCYWVXRyt2UmgwbjUz?=
 =?utf-8?B?UE5LUFRZYmQ2Y2NJTzYzcGZZeXJkQnl5MUdzbWpmUTNIZjF3RmkzMC9tY1hk?=
 =?utf-8?B?d3czWXZneFJZLzBsbTduME1PVXlPVFlRdFROQjRJMGVDUExYRmJwclJETzhm?=
 =?utf-8?B?VzI3ZVF6K2FaTitlMGlxRzNqRGhhUzc3Q2FUSmlLdmRhOUlkaUxDSjNiUFQ0?=
 =?utf-8?B?Y1kxdTd1cGhXNVRzdHFmaEpZT0Y4Wkp0eCtmRmxmdWFmd1VKcU1ENzlINTFv?=
 =?utf-8?B?bCs2ZWFVQzQydUVqQXY4Zm0xWTY0UjJFbjNCVTlFMXZ3d3JEZWhPalF4ZjFj?=
 =?utf-8?B?ZS9kMW5ieEQ3SnFBbjQxejRTejl2UXhBSm0rZVJCOUU0dm5zWWN4WTRZSEFF?=
 =?utf-8?B?QnVrbEd0U08xeGdiM1ZtSFloaTVkcHpBNE1TN1lhQ25MNmNSNVpBbzhLamtj?=
 =?utf-8?B?ZUswc2ljNHE5eU1ib2UyWnZ0SmhuUjV5Um14eDc2UjlnYU1PcEdRNWdseEkz?=
 =?utf-8?B?eU1NNGhFYzkyd2Fwc1YrM2hoRXBYS2hDcEtkZmtIVmU4Mnl1L3EvMHN6eWhr?=
 =?utf-8?B?SHZGdkg2Mlg5elJqZ0NubWptNG1taTl4VkN4QjByWlN0ZU1heG5SQ1plM0lW?=
 =?utf-8?B?NDlLaEp1Z0VrNkUzRk5DZ1I5SVhmamdva1NNSGh3YXFIVlVQV2hjaTN3UUVS?=
 =?utf-8?B?NHlWdUdmcGpZZzlVWlV2M0QzeTNyMUMzbWRhbXJ4S1EwTVRLQjFsYUVzcW1W?=
 =?utf-8?B?bHdiODZIWFFsUkQ5dDFvZkNVRUFIUEFXTGhQemdXTkhNaWRaTXhiOTJJMHRH?=
 =?utf-8?Q?DjlQ0s1+Edj/ekAA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A720072C6EEBEC449D19FB6FFD105825@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8710667c-b445-4ead-0292-08de4ca6aeb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2026 22:06:31.2093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XQkvfUo0gW7d0w/CCKfKr2rBgaUFi6a/xHEzPmFzD3xoyUixxkPKW7hwXoOoeRYXSa7T4O4Oh8BDx1OPPrHBqwHwdWrnvbMa4fVB7mhybko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7132
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTEyLTI0IGF0IDE3OjEwICswODAwLCBYdSBZaWx1biB3cm90ZToNCj4gSXMg
aXQgYmV0dGVyIHdlIHNlYWwgdGhlIGF3a3dhcmQgcGF0dGVybiBpbnNpZGUgdGhlIGlmIChkcGFt
dCBzdXBwb3J0ZWQpwqAgYmxvY2s6DQo+IA0KPiAJaWYgKHRkeF9zdXBwb3J0X2R5bmFtaWNfcGFt
dCgmdGR4X3N5c2luZm8pKQ0KPiAJCWlmICghcmV0ICYmICEocmV0ID0gcmVhZF9zeXNfbWV0YWRh
dGFfZmllbGQoMHg5MTAwMDAwMTAwMDAwMDEzLCAmdmFsKSkpDQo+IAkJCXN5c2luZm9fdGRtci0+
cGFtdF9wYWdlX2JpdG1hcF9lbnRyeV9iaXRzID0gdmFsOw0KDQpUaGUgZXh0cmEgaW5kZW50YXRp
b24gbWlnaHQgYmUgb2JqZWN0aW9uYWJsZS4NCg0KQnV0IEkgYWdyZWUgdGhhdCBsaW5lIGlzIHRv
byBoYXJkIHRvIHJlYWQuIEl0IGFjdHVhbGx5IGFscmVhZHkgY2F1c2VkIHNvbWUNCmNvbmZ1c2lv
biwgd2hpY2ggcHJlY2lwaXRhdGVkIHRoZSBjb21tZW50LiBJIHBsYXllZCBhcm91bmQgd2l0aCBp
dCBhbmQgd2FzDQp0aGlua2luZyB0byBnbyB3aXRoIHRoaXMgaW5zdGVhZCB0byBtYWtlIGl0IGZp
dCB0aGUgcGF0dGVybiBiZXR0ZXIuIFdoYXQgZG8geW91DQp0aGluaz8NCg0Kc3RhdGljIGludCBn
ZXRfdGR4X3N5c19pbmZvX2RwYW10X2JpdHMoc3RydWN0IHRkeF9zeXNfaW5mb190ZG1yICpzeXNp
bmZvX3RkbXIsDQp1NjQgKnZhbCkNCnsNCgkvKg0KCSAqIERvbid0IGxldCB0aGUgbWV0YWRhdGEg
cmVhZGluZyBmYWlsIGlmIGR5bmFtaWMgUEFNVCBpc24ndA0KCSAqIHN1cHBvcnRlZC4gVGhlIFRE
WCBjb2RlIGNhbiBmYWxsYmFjayB0byBub3JtYWwgUEFNVCBpbg0KCSAqIHRoaXMgY2FzZS4NCgkg
Ki8NCglpZiAoIXRkeF9zdXBwb3J0c19keW5hbWljX3BhbXQoJnRkeF9zeXNpbmZvKSkgew0KCQkq
dmFsID0gMDsNCgkJcmV0dXJuIDA7DQoJfQ0KDQoJcmV0dXJuIHJlYWRfc3lzX21ldGFkYXRhX2Zp
ZWxkKDB4OTEwMDAwMDEwMDAwMDAxMywgdmFsKTsNCn0NCg0Kc3RhdGljIGludCBnZXRfdGR4X3N5
c19pbmZvX3RkbXIoc3RydWN0IHRkeF9zeXNfaW5mb190ZG1yICpzeXNpbmZvX3RkbXIpDQp7DQoJ
aW50IHJldCA9IDA7DQoJdTY0IHZhbDsNCg0KCWlmICghcmV0ICYmICEocmV0ID0gcmVhZF9zeXNf
bWV0YWRhdGFfZmllbGQoMHg5MTAwMDAwMTAwMDAwMDA4LCAmdmFsKSkpDQoJCXN5c2luZm9fdGRt
ci0+bWF4X3RkbXJzID0gdmFsOw0KCWlmICghcmV0ICYmICEocmV0ID0gcmVhZF9zeXNfbWV0YWRh
dGFfZmllbGQoMHg5MTAwMDAwMTAwMDAwMDA5LCAmdmFsKSkpDQoJCXN5c2luZm9fdGRtci0+bWF4
X3Jlc2VydmVkX3Blcl90ZG1yID0gdmFsOw0KCWlmICghcmV0ICYmICEocmV0ID0gcmVhZF9zeXNf
bWV0YWRhdGFfZmllbGQoMHg5MTAwMDAwMTAwMDAwMDEwLCAmdmFsKSkpDQoJCXN5c2luZm9fdGRt
ci0+cGFtdF80a19lbnRyeV9zaXplID0gdmFsOw0KCWlmICghcmV0ICYmICEocmV0ID0gcmVhZF9z
eXNfbWV0YWRhdGFfZmllbGQoMHg5MTAwMDAwMTAwMDAwMDExLCAmdmFsKSkpDQoJCXN5c2luZm9f
dGRtci0+cGFtdF8ybV9lbnRyeV9zaXplID0gdmFsOw0KCWlmICghcmV0ICYmICEocmV0ID0gcmVh
ZF9zeXNfbWV0YWRhdGFfZmllbGQoMHg5MTAwMDAwMTAwMDAwMDEyLCAmdmFsKSkpDQoJCXN5c2lu
Zm9fdGRtci0+cGFtdF8xZ19lbnRyeV9zaXplID0gdmFsOw0KCWlmICghcmV0ICYmICEocmV0ID0g
Z2V0X3RkeF9zeXNfaW5mb19kcGFtdF9iaXRzKHN5c2luZm9fdGRtciwgJnZhbCkpKQ0KCQlzeXNp
bmZvX3RkbXItPnBhbXRfcGFnZV9iaXRtYXBfZW50cnlfYml0cyA9IHZhbDsNCg0KCXJldHVybiBy
ZXQ7DQp9DQoNCg0K

