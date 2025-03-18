Return-Path: <kvm+bounces-41396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FF1AA67820
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:41:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBCC13A67E0
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 15:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D442720F08F;
	Tue, 18 Mar 2025 15:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LV/irIYS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD2220B1E1;
	Tue, 18 Mar 2025 15:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742312508; cv=fail; b=ggAyKaGVgldoa3qfhX+UV7hRZFB2tpPS3xP39LDA0/ZRxQYvyil1n3bldcDR+jnHJ2gDQPcQ2NtWQJUICOXqRdMFhsU/DT/xo00aRMjx61kkCyUHkTKlgIfqb44LaTdZ5TSkMcDs+C5XsPRHtLlWgtIYJBYgYtn00gvXJtstJYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742312508; c=relaxed/simple;
	bh=Kk10tnHmG2LwFk/Zw2SgFbDwPIWFbOlC98OnYpwMHPY=;
	h=Message-ID:Date:From:Subject:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pnYtl8FcwjvJK1hs8HPOUPYaIu41n07Sd8gTJDKweV7yxeO82jlF2gCeJZfdVJ1w3e5KKoLiCYK9tRQdzYKDqzxfSac6kNM+kHlXxoUTJpU8LOO8cTgoeqHaA0OP70YGGD/qpD4K/Txg01xC4dLHOnhCpTL5hwOlY//9FMewTWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LV/irIYS; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742312507; x=1773848507;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Kk10tnHmG2LwFk/Zw2SgFbDwPIWFbOlC98OnYpwMHPY=;
  b=LV/irIYS2Q/GbF7oN50YPKJ4Q1abFgdXfwnz1zjysuhE5uSJ1PTT9YmX
   8BLT7rW/ezWJHWGe3fAPsRsouJldHrB0Yc8EuAyyp5YIWDNaj+/0eAEkl
   thIRjOZIKAhNiA0ToSRQCOY0w/8vB/GIprvINYifRXfOPEjDKqf19PVNS
   KxhhBnLlz3tjwLT6FPz4m//vcvTx8xv8S7nWFRtPr7kllw3SN8qP+iiRy
   p1+qx11VgitnwYmemAxL42FoJFCSuA862AISRIexouv0DfLahtY4a/+BX
   J6QSlNZZgOcAoY6cYU2ExGyL9YQYD2QpOrHXFw2C8GyF8XiRtLpF0JbH9
   g==;
X-CSE-ConnectionGUID: BMHCv/tnRQib/VIPaBb3GA==
X-CSE-MsgGUID: HqbyrgSGTjajgKFr/kQLUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="43631450"
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="43631450"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:41:46 -0700
X-CSE-ConnectionGUID: Zv1FnVKYQveuAMTI7IUaIw==
X-CSE-MsgGUID: oH8VD0YpSbW1mKeKLzKe2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="122264331"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Mar 2025 08:41:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 18 Mar 2025 08:41:45 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 18 Mar 2025 08:41:45 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Mar 2025 08:41:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xx6F+MCEoy1YR9wtbsA22y/1qoFo09hxgc5IgMX+BgGX+LAOjUBa48JLJMN4csW/HaZEh9QiKugbmos2mwGDaIgeHGt2oDd9VIi8XXRuGJW/yZijD42leKgjuSBxUog3LEDRT7HSxDMb0v1UgxJuIrwMkjcJQB9mUm66gwWS1Rdd2EJU8vPZU1OhznVV5rlmPR5/ZkRLn8szxK2nPqtRk+HtOWOonVQCXIpkKtwex9z20lbjc5dFue9Qwjq4p3DvVbLkNAPrSccAeuXazGBIkMgjTpRzhjXH5m/uagiqIJbaEyJlkk3fmaC1fd1q5P7nTstEWLzjakyBUEBtBrTCHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rY4tnfRZZerITZtWpsCnFkzRB8aZ8PZspUnXM34nq2M=;
 b=yIDHLR9sMk0krn743oIH7NDghDaHdHR514XxD5dpRUIZnpNmnLfVg+Jk7GzN0gD3umgcqaA+LN9HyGKCA4pAI8lwEPta1H4VfG3YjjbpTdeJ2Jak+9b8HTPULASB9n07awhBd0A0hAtA49FFKrvVYfsCHLoiczV0z3SkHEcQfYYuIhQIE1TUleB6s/26NXPPqFo59nlZOKjsSNFK/7P9UbpewvCgrpWa1kV0fENdjJiPmOb8zQwnaRNaP7/+1MTK9uLXOJZRAkNeWLJZOI/Bhow3sW6iIYYtARngJmdiAX15+d0ruzZAXUVhy4MoyocVk0QtINCKZ3paXqRu5+XqKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3605.namprd11.prod.outlook.com (2603:10b6:a03:f5::33)
 by CY5PR11MB6437.namprd11.prod.outlook.com (2603:10b6:930:36::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 15:41:38 +0000
Received: from BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89]) by BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89%4]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 15:41:38 +0000
Message-ID: <2ac8bb8e-c05b-4dc3-a2c1-43e8b936e8f3@intel.com>
Date: Tue, 18 Mar 2025 17:41:26 +0200
User-Agent: Mozilla Thunderbird
From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH RFC] KVM: TDX: Defer guest memory removal to decrease
 shutdown time
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	<pbonzini@redhat.com>
CC: <seanjc@google.com>, <kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <linux-kernel@vger.kernel.org>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250313181629.17764-1-adrian.hunter@intel.com>
 <ful5rg4jmtxtpyf4apdgrcp3ohttqvwfdwbcrszf6h3jnlhlr5@pfkl6uvadwhu>
Content-Language: en-US
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <ful5rg4jmtxtpyf4apdgrcp3ohttqvwfdwbcrszf6h3jnlhlr5@pfkl6uvadwhu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MI0P293CA0006.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:44::17) To BYAPR11MB3605.namprd11.prod.outlook.com
 (2603:10b6:a03:f5::33)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3605:EE_|CY5PR11MB6437:EE_
X-MS-Office365-Filtering-Correlation-Id: a9429b26-aa50-4a58-641b-08dd66335e9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SFpodzhPalc3NVdLbGNTNUNuWjNkdVhIck9SemFiQmQ4VHhkYVZpM0NRSFA1?=
 =?utf-8?B?Wi9ZQmo5b3FzZitDSWtzUTJPQzhuZWFoeW9qVWNjemZPa3l4OG03WVptNWtx?=
 =?utf-8?B?aFdnTGsyZjNIWkVFcHU4ZmRScnZDVVFLUFJRNmRwSnFMQTBzQjd3RTlMd0lU?=
 =?utf-8?B?Nm82ZEFBZXR6aCs3blJHSTdQb3llaFhlTkw1aEV2QTVxTDJEWmxsdlVlbmor?=
 =?utf-8?B?Q2dkYVpBUXA2Ny9yald4dHc5TjhtOVZEdlJKTnI2czlwd2JxaEo0eHZoV0tR?=
 =?utf-8?B?cmtNL1pubWZ5REhDM1dEU2o3Q3pFSkNFN21DRUdocElwa0VQb2NPUElCMlZk?=
 =?utf-8?B?S0k2Z1QweGIvSFEvaHdkdjFxV2ZUUjRTcVVUK240RkptVHFKdkg3c2JDUFJL?=
 =?utf-8?B?ZkhKcjZrWWlQbzdSYkFoUVBjUWhCUjRvUnJtQnQ2TUwwamR6cnZ3dVVFYTBt?=
 =?utf-8?B?Z25ZaUNBaG1vNFN0Q1J5VVJObXovYWZicnZXYWoxYjZJYnpORmV0RTFiU0hu?=
 =?utf-8?B?eEZQNWlqLzNnK0dpRm8yV1BRSGJOWXNWNTF2YVdLRzdjSXVja2VLdmU4NVkw?=
 =?utf-8?B?b0hVWGlXTm13ZXpkTWlMMHRTc3VWTytqcXFoQjR0UG9LNU5PNGc1cktsZXBh?=
 =?utf-8?B?ZFh6WWxkd1psRFVrTHdNdTFjajRad3hxQy96SXdWTkNZVDlxZzk4NWpjSGw2?=
 =?utf-8?B?dHVJT0xZKzcrVTFCUWdFbjZyWm1OeThZSHRRbEVSZjVubm4yT2hGV3FPWThi?=
 =?utf-8?B?NXhDdHp4SU9SMG5PNFRHMkpIR0doaUZVNmlxM2xDc1F1c0VMWW0xMlNveUt4?=
 =?utf-8?B?TkZGTlhIMjRhbURRY2xzTU1IdHBHTWJ2NlNiRUFaTWpTK1JXNU9mR3ROSVo2?=
 =?utf-8?B?SVlVUzZQS1pqczhCakg4OE1TNjlaelNYT0JGS0tRRVlJcDhQMStCRllVNXUx?=
 =?utf-8?B?a1o2UENHS1JLRk52NGtQOXVKZk9ibldQWFpHUWVuc21PTzBpWTQ0VStBVytH?=
 =?utf-8?B?TzB2aWF6cXhRMHcvZUs4UUpVSmtIQ0s1bVdnNUtWenZwSmtLSXlWUGt5bnpj?=
 =?utf-8?B?dU5wbnpHN1czMUFmK090MVQvdTR6NzJSUEd5SUNYYkplc3J6SEttbFJTS1Aw?=
 =?utf-8?B?S3lFQXgvQVdwUVZ0YnZNcHBka3lHYVc4ekVHZXdJdFVDaU5sQlJlRTVVcmx2?=
 =?utf-8?B?Q0U0REpRc3ZObU51MHNuSDJ2OTBpUjRiS0JhTEdKdk1uTGcxK1ZneUdqRVFh?=
 =?utf-8?B?SUJEVWdMSExxcGlKRnhsT0pGcFhCZnZacm5kTU5lemtWUkZCbWI5RmNZVFp6?=
 =?utf-8?B?YWd4NklwelNCWW1NbDFvK3d0RVljSGpPaHlPMlU3K2tGSlE5OWFacmhqVitX?=
 =?utf-8?B?VkhsRE1hblhzVVlsRlZremJiVS8wNFBuRUJPdjRYR0I5Mit0M080TXJVdjRV?=
 =?utf-8?B?aVpPc3h4RWQ4aGxLYjIvVzhRU2I5ZUY4QzdvUC90OXVuem9yR1hLN2xMNGp1?=
 =?utf-8?B?U01TSHF1djBNYXphU2l5Zkxoa1kweGx5akZrV2w5MHJSZG13RGt3aElWc24r?=
 =?utf-8?B?WlhFaHhTSHR0bkFPb3VQTXNEZWY3MFZUUlNYNU91TTZLdnRKeFloUzhrUTJQ?=
 =?utf-8?B?YXZTRTlOTG1CVWpBdGdQSnJGL1NHdi92UHV5d2IxZitScGV1YTgzVUFnY3ZX?=
 =?utf-8?B?Vis5d1lvY0VBQzhOSjJaeVdTbEhYaEZ3QUVldjRiQjIrUWVVZnEycHVCR2t2?=
 =?utf-8?B?bHhZZ1RtTW1lVXBiL0dXNXVjZWE0elpaaU8wT3VaV1N5NnluOHFvUVU1aGF4?=
 =?utf-8?B?ZjhqblpaNks2S3dDOFZVOSt0cy9IdnNvM0Irdy85WkpQM2V5MzdxbzhvUnh3?=
 =?utf-8?Q?415QwMu6viXU0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3605.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2FNaXlseUdRNmNiNklubGlzNUI1TDQ2MmJQSHFPOHBhaUUxd3hMN01FTHBC?=
 =?utf-8?B?Mmg1S3ZST0VBMjg5K2xFTmx0SndpY2loUmsvemJDdDVTZE1FbWJ3WlBGTk5I?=
 =?utf-8?B?UUt5UzBSZ0dIV0NXNTBjM0tSNGY5VDZYMFFVV0ZIS0M3VWNKTG1tMFBiRThL?=
 =?utf-8?B?SXcrNTdXNXVGb2JuWUNEL2hwVjZiLzhRNlhDWk4zK04vRzEzQkJQR1o0aHZU?=
 =?utf-8?B?NVQzY2ZyK0d3WHVSUTlOYnE0UDFlcFZCeWJ4V1FRYU9WTU9pUmQxa2VBSGhJ?=
 =?utf-8?B?U2JsbUhydGVSVzQ1cmtmV3NEaVg0S3Z6Wjg1U3dtc1EvRm1YdGlvbzBmR2tT?=
 =?utf-8?B?OU5NdTdBS250M0dFM1VndUNGSnU3S2JaYnJFVVRQaDdIVTlSc3MyRVZwWlFD?=
 =?utf-8?B?b2dhMmk0ZlZRYk1YVkFVVkZVRVBiakNKdG95WFVlWjlveDdtNXdZdUNXc1Zr?=
 =?utf-8?B?N1pxU0RabW1hM1NVdC9WWWxOTVVuZ2ZLc2FzWHc1R3hZSGRsTG9jOWlIWWNU?=
 =?utf-8?B?bkJOT2ROTXlhZkVyYmxhMkc2dGR0bXlhRUdFbW9FSVcrYXViT291alpQOUpS?=
 =?utf-8?B?LzdrL21MZUgxcS80YTlhWnU1a29HNDBlank0OVROczRzbGVienA3cXU1T1pv?=
 =?utf-8?B?OCtCZ2dwWXhTN3lqVEJqTEgzS0Nza2JkM0tWK1poSk81RHhrVEtRUE5WaGZR?=
 =?utf-8?B?enZQb1VJMm13QmhEczFJRER5MlR0T3NPSXFhWi9qVGZYUlNtN3JJaE5wbnpB?=
 =?utf-8?B?ZTh6K1lRSVlIOGx0V1E5MlcxRW9rUWVtRVk0d0FYalZSdU9Vb3YvTUpGOUwv?=
 =?utf-8?B?dE4vbFRPV2syS1RFWjRFVVlscmZkOUJDLzVDWjhhQis3UCtJZkluaFlzaEN1?=
 =?utf-8?B?VFk3cVd0Rm9Qbk1KYVNoK1lGTlo2T2JYT3g0eTJxZXBmSUcydUUvR0VyeC9E?=
 =?utf-8?B?NWlEVGdhQ3NnTUpka01ueXR4cjh2b2pHa3g4MnE4b3pnaFhVUC9NZ09mNUhl?=
 =?utf-8?B?QTN6ZDlHZERPcld4U0xVWEl4dDQ0eFozemJ6TWxFYzE4dGFOZytYaXc2ZFBr?=
 =?utf-8?B?NWVMaEFkeSt0R3Y5Z3grZ0tSQmMwRHNjTmlPYy9ZejMyd1Urb2pDOGlITDlP?=
 =?utf-8?B?eGRoRG5ucU5jZEFVWWhhVEluKy9RcndjQ3lWdTI4Z201cXJVUkQyamUrMnNR?=
 =?utf-8?B?ZS9FWEdHcktwbE5DV1pZejlOTVRNaE5rTGkyNlBrcFFoOVc1Y1hDbjUwVWJX?=
 =?utf-8?B?UUlPL0twMWpGbkZUdkZzZThTM0ZqYXNzdmYwWlpNaDkrdDZrNHZWdGpJNTRh?=
 =?utf-8?B?bGV1OXBnWTZNc0NETU9vcUl4b0NybkxpODJOUE42bWo0OGNuM2VXSE53MzQ4?=
 =?utf-8?B?bUprbHZuMDcwSlc4SnphVmRUcG5nVXF4OG1icFBMby9zN1JsRXBodm1YL0JP?=
 =?utf-8?B?eGE2WjlNWXNKbTNjWDBQUFArcTZ0MXdiL1NjTVJVY05uWVVBQ3AxQ3NWcWxp?=
 =?utf-8?B?S3ErT0ZvbUsxRE9aMTNzRjVGbU5EUExjcmhxZEdwVktNZm5nSm5PKzlHRjBh?=
 =?utf-8?B?aWZuUmlWd1I3cUJGdDdkQU9KK2hpSzNjanN2SXdEZ0NkdjdtdGFxZnlNK2NU?=
 =?utf-8?B?LzdUQ254ZWc0YXhrTWJKbXVlTVl4dkp4UHc2MGpVWjhjcFNRSnhib2N6Q2wr?=
 =?utf-8?B?dkY1Q0pENk9zZFg4Z1RaSjV6TkpJNjcwTTlYYnhLdzk1VGtLZFZaeC9KT1F5?=
 =?utf-8?B?eEhXamQwVmFDUWc2cXQySnpJa3dpdEFhQlNBcGtVaFhwb2lmeWVtOVhPY1hC?=
 =?utf-8?B?aklhZ2pxU1JiMTlMOGhmWGprRG9lbGFmM3c3d0pabUszOW1rcC9UZ2ZzRHN5?=
 =?utf-8?B?dDFDZG5aOSswRU15dG5EY2RTbkpHbXNsbWJXZ0VPRGRocU4rRS9qQUtaRFU4?=
 =?utf-8?B?bkNtUzNvWWIvYVJ2YkltekZMbjRrWEdraWNvMm4wanZOb3Y1dzBYeGg4aFYz?=
 =?utf-8?B?SE1oVkFUUHN2STgreS9jeDRKdlY5OVJ4dXROV2RXRldMOWo4c09LK0hsSml0?=
 =?utf-8?B?c21nVmtIeDNYSWJteWtTYTRncWxjUXVWN2JjSFZ4cnZkWHhlUXJkQnJ4MTd5?=
 =?utf-8?B?S0dmU2pjMjErNE1BMUJxV1pGMHVUbnhtVnpjUm5pMG91cGQ2QkdXQTcxNUtT?=
 =?utf-8?B?NVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a9429b26-aa50-4a58-641b-08dd66335e9c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3605.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 15:41:37.9029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RYxdDSMGk8sXMERKvqsYZ+vPvsJoA5AxqcWxbaJ8NafEEfFEhArTKkCW0VdYXtCsyGWkgZBmZAwG29E85K3G9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6437
X-OriginatorOrg: intel.com

On 17/03/25 10:13, Kirill A. Shutemov wrote:
> On Thu, Mar 13, 2025 at 08:16:29PM +0200, Adrian Hunter wrote:
>> @@ -3221,6 +3241,19 @@ int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>>  	return PG_LEVEL_4K;
>>  }
>>  
>> +int tdx_gmem_defer_removal(struct kvm *kvm, struct inode *inode)
>> +{
>> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>> +
>> +	if (kvm_tdx->nr_gmem_inodes >= TDX_MAX_GMEM_INODES)
>> +		return 0;
> 
> We have graceful way to handle this, but should we pr_warn_once() or
> something if we ever hit this limit?
> 
> Hm. It is also a bit odd that we need to wait until removal to add a link
> to guest_memfd inode from struct kvm/kvm_tdx. Can we do it right away in
> __kvm_gmem_create()?

Sure.

The thing is, the inode is currently private within virt/kvm/guest_memfd.c
so there needs to be a way to make it accessible to arch code.  Either a
callback passes it, or it is put on struct kvm in some way.

> 
> Do I read correctly that inode->i_mapping->i_private_list only ever has
> single entry of the gmem? Seems wasteful.

Yes, it is presently used for only 1 gmem.

> 
> Maybe move it to i_private (I don't see flags being used anywhere) and
> re-use the list_head to link all inodes of the struct kvm?
> 
> No need in the gmem_inodes array.

There is also inode->i_mapping->i_private_data which is unused.

