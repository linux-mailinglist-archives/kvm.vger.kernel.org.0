Return-Path: <kvm+bounces-58838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 523A0BA1FA4
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 01:32:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0973116F361
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 23:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3CE42ED846;
	Thu, 25 Sep 2025 23:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HRB2JuC3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F61189BB6;
	Thu, 25 Sep 2025 23:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758843129; cv=fail; b=j9YuWoMZGRDNdh5PG7b+xpogtm/5hcvNx6RGSryA49n8xkV/WiXHkLRY20dOqhJme6hao0lEZonVF88O6+3XF+4/HVGCA8R4ehvMJjnRwQR/L/ZpSAfWd3kDnsiqMuC+EdD+zbWMefyg92dS8kq62n4fYRi/wQFwEhGcFveElPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758843129; c=relaxed/simple;
	bh=x2bC1F85K4NxA4G//uoI4dHCwANWLRJ4s2jwAvMBiDE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rVzBuqqu/ArpRbfLO9oSco7bz4EurV+d7umjpoop3dM5vYJirmlOv9n6Uzui7uKB78+/DQDl0AqTyYmqdenm7ZflurNOeJJnE+/oSECkDez31s/EbD/0hwSdv2F1z+Har0NC+ESia62FrmRnP/fDc5ni/MxLN0/9pYEusSU4DI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HRB2JuC3; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758843129; x=1790379129;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=x2bC1F85K4NxA4G//uoI4dHCwANWLRJ4s2jwAvMBiDE=;
  b=HRB2JuC39S/1w0sfXgvIFAcJf8v+OafzQ+ZDzaut7EtnXFYisY7Lgg8O
   LIhKHmBdzUt53dCaX/QoxJhxZkKlsSsasXuhOf81CSSwRAywbZliB1hyp
   41xD1EbNCRIiceKh2xJ6eD7FDlmimCLRuOf1IZig59wqXM83S8jtxzdNF
   l28Hioyr7L/355DOVSQRBf2nATQf9xtYb3PdPJjeSyqQjBsaqjS4nFHfM
   r0NznhCEc8/dNHG3czD2x/v8UZFOvLJLtMsuucYVpC6Zr1HMKHaMNDsWl
   WmyV3g9gV/GczL5R2qeGek3IlcNi5uNlIVslZ88XQLPTMUTLOfQueuCUB
   w==;
X-CSE-ConnectionGUID: nQz/5xbsTNmYEDb57M70OA==
X-CSE-MsgGUID: BXEzKluBQfuQET5A0C1OIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="64806505"
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="64806505"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 16:32:08 -0700
X-CSE-ConnectionGUID: ttDHBzTpT0ia8lUpjj721w==
X-CSE-MsgGUID: UvEgIkEkShmT1Gi9Li5nWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="182727124"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 16:32:07 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 16:32:06 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 25 Sep 2025 16:32:06 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.18) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 16:32:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DCdfHk/4Bk21RfZ/WiPE8pkc6cydSrNL11EzeavuZ3SkbmqaZbT6WGIEbzrbXGR76boX3j0OulfI0XGKa5FWoYy/6x70bitw+/AUna4o2eyVTevz3rFjgLTkwVfhQmGwMQGQs5AxWbT1rAJFOYCHOfWqZwGUDX/8rQecjt/iKMZe4fafjvnEkT4z0z0JjZ33Tcu2Bkf+un+UJn3OZtZMOZxx1qL2OctZrrFPMQWQad8KxZYZ8GQyHoZ2X66BxGHbxu24TAq53CRvABRJTGaVqLx4Ux+BKXSnlpGZBCGJB5KNBk/jB3gMKGBX3eugkkPKGMIl4+JaDzPr0CHcZW0lKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2bC1F85K4NxA4G//uoI4dHCwANWLRJ4s2jwAvMBiDE=;
 b=G2j8hQRQDXmTxj5mPkrkarZ6z/LVwIJtFXR3P/8tX9TukvJtOOd0OgXWpGknvuMpAvCPLRmW1raX+t+cbC8btLRNhbkfPdJ3CmAfhOilpIwc8J2FGPVwF3WILgDhu++nfXaBVV9Iitv8QhpntwDWd+kYvkARFkSdZIc3BTqeqTpsgZTf/wPguGr0yyIGKOm8sGhZ0bIUnTz0CDvA/IZuzIPzcsbJdF0hJ0YNGn4DtEF6SxoCPy157yVJva8mhklEzhoFsPyQNimu8nhIMhlCxWAcQ/JvZfZuBbOpDiNpxPhBobY4/+PZ14bfFRvU81wux/zS4xQpRH11jUUGcLseHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ5PPF6E07EBAE7.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::832) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Thu, 25 Sep
 2025 23:32:03 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9160.010; Thu, 25 Sep 2025
 23:32:03 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kas@kernel.org" <kas@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick
 P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Topic: [PATCH v3 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Index: AQHcKPMxZM5D8fzz+UCC7ed8PEA7hrSZt88AgArc9QCAAAKDAA==
Date: Thu, 25 Sep 2025 23:32:03 +0000
Message-ID: <72ddc0da1fb3e949d5b6a3ff73186799dab988e4.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
		 <20250918232224.2202592-2-rick.p.edgecombe@intel.com>
		 <56c3ac5d2b691e3c9aaaa9a8e2127d367e1bfd02.camel@intel.com>
	 <b6dbc85805ba02701d23902f020d83469fa34d2e.camel@intel.com>
In-Reply-To: <b6dbc85805ba02701d23902f020d83469fa34d2e.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ5PPF6E07EBAE7:EE_
x-ms-office365-filtering-correlation-id: de6b7244-6c32-4f2a-0b02-08ddfc8bbb8c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?UnRPeTV0K2x0Y01wY1R1RXZsT2ZDZ3FBclB6T1VTeU1aeFgxRE9uYkZiMG9L?=
 =?utf-8?B?dVpSRnVyazZsSnhLR2VXMTA3Nllud0N1TTlpZDBvbTFyOEhJZzE3OVd5SnJK?=
 =?utf-8?B?MHJXMDFuQXNOYVpFazJDUkJqeGJIKzZLQUJLRUk2S2Jsb1ZrTVF0OUExSHAy?=
 =?utf-8?B?aWVWTTZ2RGIwMHcwdG9RYzlJWUZNQVlNRlFPdVU3STVndkFYcytuSFU1MGhE?=
 =?utf-8?B?NDRHanNDZDZlVGtKZVUvOUFPMDZvcmpSS1JBUUFmL091a3Mxb1ROZCtJQXAr?=
 =?utf-8?B?YUVKdTVkc2duS2dZd0pDc0M0dGt2K2krVkYwMlVXRmpkNVVNVWFwcGcrZDRu?=
 =?utf-8?B?dzNERlJMZjdUcFVKTlh5UHNOcC9hZ043RnY4V0xXVzJBRFJGdHFqc0VwVjJG?=
 =?utf-8?B?V2VUYXk1N3IrdnBRejQ1dDZub2hkd2cwaDBLTE42VmtzUmNFaCtQNytReTNO?=
 =?utf-8?B?ZWZUeE9Sb3ZaOTh5ZmUrQmMvU3dOc1ZqbDdjNmxJVjFYemt4ampjMHVxejF0?=
 =?utf-8?B?WS9HOEhTWXZqbTJhU0s2VUJKVHVpVkhJUW45UjRQK1lIQVdRZmk5Q2NyY0F3?=
 =?utf-8?B?cUFPMFJuRjJnTDMxd25PN0k3eDNaRzhyRXBVdGQ4blhhMkdjdkQ4ZERnUENW?=
 =?utf-8?B?WmdkUHdtQ3ppSGdNZjdoc05wWWRXdmVBRXlydHVjc0ZZSHFsMVNsa1VGTVZZ?=
 =?utf-8?B?eCtDdGl3UGR2Wk1OK2VkbHRPK21kajVjY1cwZ21FSEdqOVBVL3NaKzZpc2ZK?=
 =?utf-8?B?ejNVRlR5Ynl0SFV2UGFHb0RZUGF4UVhuMDJkY2pVb3JmZnhpMXlVaEtydjJr?=
 =?utf-8?B?MnRvVU1lT09WVWQ5ZkxJb09mb1R3WnQyVmZiRlIxdFNKZWFwS0xOUTk4cmk3?=
 =?utf-8?B?Z01qUlRCY3Q2TkJlK0c2QW1MVWxtMXNHLzVieTJwZG1JNWJxNWQxVUlkMzJv?=
 =?utf-8?B?dW1hM3k4UWZjbThaWTJvbzFqSTlncmdpelpKNCtTeTlVc0FJYklXVk5rSVlL?=
 =?utf-8?B?MWs2RTVtVXpMZmIyazhFQVJBcXJzcHBzcUVLcElTbDNDL0ZSQ0IzN1pkUUUz?=
 =?utf-8?B?ZnMwNS9TYVhPKzJsZ01MVW5nNUltL09SNVhTaGk5T1ppWjAxdW0vZ0E0WlBJ?=
 =?utf-8?B?cDVoSjdxb290b1hEN2pZdjVWaW8zMEV2dlhPS0QxQ3VDZzZPb3lDaWtOcmMy?=
 =?utf-8?B?OTd0WHorMElNYjVzMm5kdVkzTzRxWmZBOXlWcy9YNDdoaHV6UkRCTHBxbG5X?=
 =?utf-8?B?V1puejZ4d05XaGcvR1R1RTFnRXpFKzIwVTM2Q21YS0hZMlQ4SEJQNUJSTVZ0?=
 =?utf-8?B?RzBrb2xhei9aQ0VUb3VvbXJMQ09OaUU1WWlIanU5YStDYkVwRy8za0RNM0NG?=
 =?utf-8?B?aGI0ajg4UXVCdDc2dHphVmdGcWZEOXJiWnBsalE3YUJBK0VLMTlRcWRnRUZy?=
 =?utf-8?B?emhPYzJ6UDBDa3ovZjNyUjBJMGJiY0NoYk1Jbm00WHk2Tm5YS01nclNMdjh1?=
 =?utf-8?B?eVFIOHE0K0ZoQkR3OTZCVE9sU2JzOGY4V1ZOc2FJRS9aWUVVVnRMbDh3TXJQ?=
 =?utf-8?B?Vk5sWWk0bitZdXN3S1FuZHhybDFScmhNbExlVWhZMDNDNU9mUVVyK0d0enRK?=
 =?utf-8?B?allibm5mSWx5blR5dm91eTlzOHF2MWh4UzZLNHR5Z3JHR3lKaXdPZE5JaFlY?=
 =?utf-8?B?TlR1c3BkL0prMUFYNnQzQlI1dE9oRE8zSVdEN3FoY21FQTV2cUpaRHQwcENG?=
 =?utf-8?B?TTdJRUJxRFU2K2NxbXF0eGpUODZFUk0vcTZNWUd6WXJmaTd4NmFNNTEvM1dz?=
 =?utf-8?B?bEN5bzNYdmVFem1nQjNiUnY2QXE3NkR6LzVyNG9BN2FyTVpxZm9FNEgrYWF6?=
 =?utf-8?B?dm55cFNyazNsZFJSbEFtbitZRlAyaTlKeUU1Uk92NFdJUlI0a214N1lsRVlZ?=
 =?utf-8?B?SXdYdm5HKzJLaGh0TUt6eWRHNDNyYmRIWGJIaGZkczdFb09sQXQ3Rnh2OEdT?=
 =?utf-8?B?MjRXYzh2bm84U3hqc2MwRHM4TlNrRkVOQUhCMzVBY1pIOUZwa1Z1bGNCaHhX?=
 =?utf-8?B?YmlyL0pBazVCVFlzcjF6Z3g5MVVNdjJ6NWgydz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dDErbFZCZHNsZ3NOR0RXem1nSkhNOXRwRDViakVINisxeVN2d1c2cXZFNk0r?=
 =?utf-8?B?ZU9TMldsMjdJK3M4c1ZVM2o2a3VDYjNEbDdpL1NvT3RYRmR3eEY1TXJTaXBQ?=
 =?utf-8?B?S29nRUNQSi8xTWdGeU41cmNWc0FpMFcxQXA4K0JhcXdhRDgzbVJza3R3MWh2?=
 =?utf-8?B?eWJ2MFJxMVdvTWZJOWlNd2lDMVRtVW90dVJvOE1VeHkzTTRkVHQ5Q0xQMDhV?=
 =?utf-8?B?cnhLTWo3WGVDM3F5NUtJWUpMVzNCVGdxL3FwbzBQZWZJSFBwQXdZZi8xU09M?=
 =?utf-8?B?WlU5U2ZrNjd5VkEreGViWmp4Y2dRMmRZREhia05ia3JmcVgzOUtxVG5xTmJV?=
 =?utf-8?B?dmRtMTRkUjlXWnVtVW11b01qcGVadlRLait6R3JId09DOEdXYnZocG9QbmNZ?=
 =?utf-8?B?NVZ1UTRsaFJ0M0V4cjA4V2Fsd2dEL0ErYlUwVGQrUDFYaXpxZE9SZUVURUJt?=
 =?utf-8?B?VTA4ZHlyZ3NyanY1VjF1RTl1c0FXMnc3WWhjYTRLVWFXaWNIYWIrWFVBdURx?=
 =?utf-8?B?bEVaZDRrWXplRTVQRXVXOGQ0WHZQbzRlYkx4TU5sd2xXVGozbkM4ZTdoZFBt?=
 =?utf-8?B?bVZWTjZYamVteTR0UndNNzloRUFPYVRHb3A2d3FRcU9zelBJbFg4RUxLVHlW?=
 =?utf-8?B?c0ZXVFRSNWlFREtjT0NvbjJEZ2dhankraE43NUZ0RUZob1dWampXbmt4QnlS?=
 =?utf-8?B?Snc1YWdFNUYranNGeVNFMysxNkxORWRWdFg3SjRsTmhRTUEyM21FNlJGUGYw?=
 =?utf-8?B?a1JpdkFwMExWR3Y5NnlZVkhiWGd5Q2gyemJYdTNmZUhkemt6dThIWDFDTTJz?=
 =?utf-8?B?ZG5aNk1nRHQ2WHV6b05JdURXa0oxb3hNMkVUNDhrMVFQU0RGVWlhWmQ0Ykk1?=
 =?utf-8?B?Z2U5cWpBMW12bEJSRlZXNllORGpjTDlyL3pOZmFiYkJGRkxjd0ZuYmo0UGF6?=
 =?utf-8?B?ZEhGZW40VXlHTmpZRVJGL1Q5c0Y1NTRVK0Y2aEVNZUpFVnNhdStjNHdXdUFZ?=
 =?utf-8?B?RUFiT0FDRmZwOHVBVENuUEJiMGwyYlNJRVpycXhLcFhxWXZDL1RHeWFBQWlT?=
 =?utf-8?B?WmJDVjBnQXdadmtkVldMZGx2ZG41TVRpUE1aSkRhMGluY0JhVFhJWW40RlZH?=
 =?utf-8?B?WXdlMktoRk9BS3ZSdUdjQm5HY25ST1lkKzZtNXIyYWo1ZzlNTGUveGRyQ3Yv?=
 =?utf-8?B?UTFKQVVkbHp1KzdoYjBTcnlEcyt0bis1RUhvdSthbjAvYmU5am9VTFNSSGhs?=
 =?utf-8?B?d3pJUkZ2TUxPTVFNYk5scWFVeG0xZHJ0cm93ZE01eS9lTmpndllBQ2krbFhw?=
 =?utf-8?B?NGlrdG9CTTMwMndVRDBuSGR6eXNnUlZUQ0tNMUhsaVNySzMwOVYwMDQwR0xh?=
 =?utf-8?B?czhCcHpNZHlXNXdvc0lqTng0czdtMEVmTTE1eHRzTkllbUN5YXR5WDVDWmdL?=
 =?utf-8?B?eHc5R3c3ZFZJd1ZHVzN4Q3JxbU0wM2h6RFEzUUNxTzNCVUlET1lnZk4vcmNW?=
 =?utf-8?B?SDU0dHpMNEZScUhXQTNlTDBRZm1aUGp3ai9KeEs0OU5Dc2NNLzh4VGp4NkFh?=
 =?utf-8?B?anpSNDgxTnJDYWlqbWsra2xpSUlMMGpLbXRoRzU0K21wOEl4NFBqWSt4SlRG?=
 =?utf-8?B?VGpOeFFuekxlaVRxczNiKytWbWZUY3FiNDluSXFMOStic09rUHl6TlN6UlhT?=
 =?utf-8?B?Q0tQYUpHTWJnN0h2SGRuRGxMNEtHLytHS1E2d1Y0T0UwQkVQREI5UWhicEt2?=
 =?utf-8?B?bS9JT05PcFhzN0FLZ2ZEWmNKY3I4bFhWaUYrVE41ZE1mV3RoWG92RGpnTW5X?=
 =?utf-8?B?c2NrYUJua1luRDVqN0k5ZTMzVmduRi9VRTRxNElSVDN6UXpLWlFuTThwT2pp?=
 =?utf-8?B?NU5aQVcxcXlzUStTSVY2VktSaHl2YW4rRHkxaVpDeGZHTkpndEdGRjhVYTZL?=
 =?utf-8?B?anFrRDcyTHdXZWx5UGtYR2xVSU5DMXE5THhFazg4Wm9XbkNydUZXTzlZN1Mv?=
 =?utf-8?B?RGVsekt1RDRsTHJZblJjSElWOEJGZU93cjE5Z1NUZmR6anZvTWthWVcvMVkv?=
 =?utf-8?B?aFlEMzRZMEpLWktENHU3QUpHb0VUSnpDWXdCVDZBY3o3UDJLaFhiTWhPbTZs?=
 =?utf-8?Q?iJOHwMrGtPnPWplttuTGsvX/0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <96CF192919F60141A21442081DFCCD65@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de6b7244-6c32-4f2a-0b02-08ddfc8bbb8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2025 23:32:03.3491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4oIofQ9XSlAqXECJ9KQwTf7juduFycjR/IMweIFjkCQN9QyB8NKbJWkhapPjqQVeCPDprzl2CTQEDHexcGwfLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF6E07EBAE7
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA5LTI1IGF0IDIzOjIzICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gRnJpLCAyMDI1LTA5LTE5IGF0IDAxOjI5ICswMDAwLCBIdWFuZywgS2FpIHdyb3Rl
Og0KPiA+IFRoZSBleGlzdGluZyBhc20vc2hhcmVkL3RkeC5oIGlzIHVzZWQgZm9yIHNoYXJpbmcg
VERYIGNvZGUgYmV0d2VlbiB0aGUNCj4gPiBlYXJseSBjb21wcmVzc2VkIGNvZGUgYW5kIHRoZSBu
b3JtYWwga2VybmVsIGNvZGUgYWZ0ZXIgdGhhdCwgaS5lLiwgaXQncw0KPiA+IG5vdCBmb3Igc2hh
cmluZyBiZXR3ZWVuIFREWCBndWVzdCBhbmQgaG9zdC4NCj4gPiANCj4gPiBBbnkgcmVhc29uIHRv
IHB1dCB0aGUgbmV3IHRkeF9lcnJuby5oIHVuZGVyIGFzbS9zaGFyZWQvID8NCj4gDQo+IFdlbGwg
dGhpcyBzZXJpZXMgZG9lc24ndCBhZGRyZXNzIHRoaXMsIGJ1dCB0aGUgY29tcHJlc3NlZCBjb2Rl
IGNvdWxkIHVzZQ0KPiBJU19URFhfU1VDQ0VTUygpLCBldGMuIEkgYXNzdW1lIHRoZSBwdXJwb3Nl
IHdhcyB0byBwdXQgaXQgaW4gYSBwbGFjZSB3aGVyZSBhbGwNCj4gY2FsbGVycyBjb3VsZCB1c2Ug
dGhlbS4NCg0KU3VyZS4gDQoNCj4gDQo+IElmIHlvdSB0aGluayB0aGF0IGlzIGdvb2QgcmVhc29u
aW5nIHRvbywgdGhlbiBJIHRoaW5rIGl0J3Mgd29ydGggbWVudGlvbmluZyBpbg0KPiB0aGUgbG9n
Lg0KDQpJIGFtIGZpbmUgZWl0aGVyIHdheS4NCg0KU2luY2UgKGFzIHlvdSBzYWlkKSBjb21wcmVz
c2VkIGNvZGUgaXNuJ3QgY2hhbmdlZCB0byB1c2UgSVNfVERYX3h4KCkgaW4NCnRoaXMgc2VyaWVz
LCBpdCdzIGhhcmQgdG8gc2VlIHRoZSByZWFzb24gKGZyb20gdGhlIGNvZGUgY2hhbmdlKSB3aHkg
eW91DQpwdXQgaXQgdW5kZXIgYXNtL3NoYXJlZC8gdy9vIGV4cGxhaW5pbmcgaXQgaW4gdGhlIGNo
YW5nZWxvZy4NCg==

