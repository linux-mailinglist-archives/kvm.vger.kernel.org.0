Return-Path: <kvm+bounces-40270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BB2DA55654
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 20:13:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E2A117517D
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 19:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB8625A652;
	Thu,  6 Mar 2025 19:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="keenBihO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289F726E15E;
	Thu,  6 Mar 2025 19:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741288418; cv=fail; b=sISjUbPO49/NOLr/LlzBNdHnESZtFsFnUdpIO4gmramZJYmgqBOGCUwqakqo3JS4Z7ewKxQhCsbVHIzpP+82LfbguFRA4SteExE6rfiWhexNErlSwlK5m3ESmx1J2YsCBFUXO7z2viKh1cgOR7SnbLfnTS01yMMuEGyOGmq6QFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741288418; c=relaxed/simple;
	bh=UkR+IS4KUxGdr1CH4oBTHUOaVseM4H5CvHx1b+c9Wjw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RY5/nUPI2+kKmy3tB6HqiSIFW/jf/ceVYtRjsvb8P4Sc7RB6DFywBM1UVvulnFQp6cKUoiXF2zYcuvLTM3SgmHbdb8gSTPhn/2raRk7UlfFW+qKKR7jXcQNN+pKYfFwZum+uhZckqkz8Wf0m+v1Ik496obs4Pjw2boHaTwzxEu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=keenBihO; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741288417; x=1772824417;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UkR+IS4KUxGdr1CH4oBTHUOaVseM4H5CvHx1b+c9Wjw=;
  b=keenBihONj2cO413bfmYLzqFSIjEMoTFhUl7tOpoWPNoTZYSxolmtX8f
   FbxSkzrN0mHN0Y/J+9oO5SoQDSO2BLwVIpwsERlgP6DXvKzb60Ux5R4Gn
   iif/P2L7Im5IuEed/1Wrf6KqMi2eHBvimkqE5pulh500VSc+Xqi/Tek4O
   uXCBoiTdGGbUVpPKuwkqvyMzWUMzBRa+zsbH1yK0UJkgvNSSOyNL+D5ui
   1GKOQlLaqRdAY9GVGp3uphpUj5mWZTFD70BoUrcE8r1sp2FL5BwDmK7BK
   YPJi6yS905173LrQQCwpuBtWNfWWvSYw4DyVBb7X7kql/vZQdGH54NxfN
   w==;
X-CSE-ConnectionGUID: BZmYn3EnSZKxZQT9YzkMfw==
X-CSE-MsgGUID: dRJ19FZFReGmb/7t5vmX8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="52965142"
X-IronPort-AV: E=Sophos;i="6.14,227,1736841600"; 
   d="scan'208";a="52965142"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 11:13:34 -0800
X-CSE-ConnectionGUID: 9XEKjtVUTMe8Sb4PLmvNTg==
X-CSE-MsgGUID: 79n4N7bjTyGVCajCVpwP6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,227,1736841600"; 
   d="scan'208";a="119121975"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2025 11:13:32 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 6 Mar 2025 11:13:31 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 6 Mar 2025 11:13:31 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 6 Mar 2025 11:13:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UYq9SeO8LX1awNjVBzU8aitm+AZ9DClArsm/+Y06saaYY6X/qluJa6W4YP+td7hH2RFmmKQiciQunKvDiSmFzznXeIThboWfubCXe1SwEayjRZbw5ukeyvlUbjJih0aHWoMZAxq5T2DoUtCQNrR/nhPDOo0geuBVGW10umLC/am5gtMjv8KUmxq9ExOVb8cdPvFJdVHuUbXGlIO1QRwJAqPqT5GW86vJznA+jcTWoXWm+0q+m1q8WkvDD8bfq8fcd9wueW59uiWXRC/EIV0uZUKRmJz8m1GASWCZ7zgL1KRQGsyJEhYRoqHA1JL+tj1I25KYoyL6wvxVpL2OTgTXmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPgf4geO0o9c7VzVMxzbi3Jc4/VBdL51NTpug8edO3M=;
 b=hkolVuCVG+ROwTJwjrFiLXuvJlIEiuQSKkYH2GJM86VE8yfZI4KZsxqIbARNdwROHQgA3mRZ84Ha7g4UK+LHyEDlWbAjIGNbzXhgjC8nySLXuVPtU7nIB3gcaPKiDL0h5zqYYxk4uyAVBiZT398Z9WVYkqQ3gqO+fz2O0W8Cr7MZy+NB2G16fvBM7diNSc39E9UW1g5GNfV8JEcgFSgo120g+zb15JxNSDnaQxOrNuh923GICJZS/8XAU27fe38eHZboZRIjpoXIgooYkU7Jq0FwuCfua9hvOIosRJtZWpYx3sffr5cUyoXJSKQToQitrmQBaBSf8mXF72xXjEn7Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3605.namprd11.prod.outlook.com (2603:10b6:a03:f5::33)
 by DM3PR11MB8734.namprd11.prod.outlook.com (2603:10b6:8:1af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Thu, 6 Mar
 2025 19:13:28 +0000
Received: from BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89]) by BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89%4]) with mapi id 15.20.8489.025; Thu, 6 Mar 2025
 19:13:28 +0000
Message-ID: <4b285117-3ad4-4346-bcd4-3644c693ee43@intel.com>
Date: Thu, 6 Mar 2025 21:13:18 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 05/12] KVM: TDX: Implement TDX vcpu enter/exit path
To: Paolo Bonzini <pbonzini@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	<seanjc@google.com>
CC: <kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>,
	<weijiang.yang@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-6-adrian.hunter@intel.com>
 <06c73413-d751-45bf-bde9-cdb4f56f95b0@intel.com>
 <632ea548-0e64-4a62-8126-120e42f4cd64@intel.com>
 <d9924ccd-7322-48aa-93be-82620f72791c@intel.com>
 <3e64b29e-34eb-4f9e-b7d1-a7803665ca55@intel.com>
 <d3f83243-5526-4196-956c-de349bebd81f@redhat.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <d3f83243-5526-4196-956c-de349bebd81f@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MI0P293CA0004.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:44::15) To BYAPR11MB3605.namprd11.prod.outlook.com
 (2603:10b6:a03:f5::33)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3605:EE_|DM3PR11MB8734:EE_
X-MS-Office365-Filtering-Correlation-Id: 26fcbffc-1f00-4a8b-afba-08dd5ce2f9b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a0g4QXc3Kzk4NE9adENrM2VUYmM3OG9nVWErZ1hDNDFyWEN6bGQ0SWptM2Rq?=
 =?utf-8?B?azU5NUNDblJkRWsvMktNWkM4K2pFSmVPOXg0VStKZW9jQThJRk5kTG9zVy9U?=
 =?utf-8?B?cmEwSXErdUpFV09ua2g3NkMzeU1nQjJ3VFlOdy9wZ1VxcFFsNWE1RHFuRXVh?=
 =?utf-8?B?eHVWQzNZa3hodTVqMGk3dW56UWZvbW5LNGxVbmk4RGtaSldyOHdMbkc5am9F?=
 =?utf-8?B?QXNXSC9yWVhiYVRCM1NPWWRYU2gzMjVCR01vUFQ0UTBmMWFlQTllNG8rQ1NO?=
 =?utf-8?B?ay9aamV1QW9rZ3grUllpbkdqTEt1cDFtbm1wNHgrMElqbUprUDFTd0ZvazU5?=
 =?utf-8?B?UFVXVEl4TXdudWF0YVJDVkdkWUJqUFRWcWEwaTQ4ODg2SEpaVjlwdU55cUZs?=
 =?utf-8?B?UHlzeWlmeEhhaGJJV05pQUZXV1UrdW9Ucm9IUFQvV2NXc0tBUTduMU03aTB4?=
 =?utf-8?B?d2Y2eFhINTVuYkhrZmJ5b21KQ0VRQlNzcnpTYUFlYU8vM3lzRDVkUzRpOEZ3?=
 =?utf-8?B?dG9wNDFzRjBVd3NrRVUxRnFhY05zOXBIYm5TNTJFQzVaY2E5UHFJZkIrMUZn?=
 =?utf-8?B?SjZQdCs5dHJ0N0huK1VTWmJibi9sZjdmVFVIRGFuSHBpVHhqMllBN1c0ZFNm?=
 =?utf-8?B?NmNob2E5Y3VFMlZSWHpNTVJYRmlzTVpQOVlKeUgwY0ExTUQyQVZOUi90TmhN?=
 =?utf-8?B?RmFlcW42aHVpckM4ZU01aW0vRENIUkdiZlFtbmF4MHQzNC9pWElUUkpEcGFQ?=
 =?utf-8?B?YU44NFNJemdxSDRLYjYxMVJ4MEdvNEY0Rm0welUyVFg1SmJVNm5FRFRPVEQ1?=
 =?utf-8?B?Vi9iMUlDWVFNOVllRDdxTjR0cUM1YXVCUit2cVlyQ1hNeVhuRzhHdkNTRWJB?=
 =?utf-8?B?b29NcDFkdzlTMnUxRm1ITDNobWdKV25CdTJ5OUtZWjRiRFBQN1VORUhhWThV?=
 =?utf-8?B?Tjd6aWJpbURPWVlrTVBKa1VWUmc3K2JBODNpbWxNaW9Pb1o0Z0pPbDcxZWh4?=
 =?utf-8?B?a1ZUTlhFRmdQczdMZThnQWRzKzRVbVNDaEZsc0VvSzRKcWJad1dhTDRwdXNR?=
 =?utf-8?B?QjVJbWNRL0JQT0lvWHNER1B4bGdtamFwWXAzTFovdmMwOHFiNS9TTW95MDBk?=
 =?utf-8?B?Uy9Ic1ppc1dISnZJM0UrMENuSTV1M3hIVG9MNi8xM1hUWmZxWFZnUXlWZzA3?=
 =?utf-8?B?eEU5eU10SU03VnFVRkZleVI5UGVhaXB0eU1pM2o4SkQ4SUJDK1ZJdENSRGcy?=
 =?utf-8?B?eXl2T3I4TWlFbFJJUGtwc2lsQ2RGamN5aUREbFg0bEZHb1hDVEpMMnNkbCtG?=
 =?utf-8?B?MVpHM1Q1bnJ2d201Z083QndCV2cwWENueWo4U3pCeGFwSTZWcjAyMzdzdzBs?=
 =?utf-8?B?dXRINlJYVFBLcUYvVldBaVp2bTNUV0RpbHR4ZmxFZ01RRWNGMXVUVmJDVGJ2?=
 =?utf-8?B?ZVAwckJEZFc3MWRWRy8rcDdzR3JLZnhjdXhlMEd3TzVPSk95L1VDRDVYV1ZP?=
 =?utf-8?B?MXpNNVEwYXVielF0YkFFME1sbkdleUVOODhTUlM2UTNLUlRSekN3YUVBL09Z?=
 =?utf-8?B?dzlJTE9DTzhvU01SakVpcHVZbUgxeGtuUlA0cHhDbktjcEtVbmliWnBvaW5I?=
 =?utf-8?B?MzNkOWxOM0ViRHFtbHRrV3cxMDNvKzQvaHNXZEx6UGN1UVJvQmVDQjgyb0wx?=
 =?utf-8?B?Vy9nRnhEVnhyTVhHQ3hESW5sSFBkcWhCVUoyby9vRW05VE9JbHFPUFVlSk5Z?=
 =?utf-8?B?NndVTzBzTExkT2tKd3lQcHBya2ZuS3YwRjYzV01XSWhNSDljSkgzbDJmSW9p?=
 =?utf-8?B?UTk5eG5wYm5uVlFEV0pGOXZXanRoQVhEKzV2UG1tM3VtZ0pwWHRiNGwvdUl2?=
 =?utf-8?Q?BNKtNRyyFaHYI?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3605.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHRDYTZVZmhLL3QwWERGU1NjOFhhMDRZTWZTYk5UdkRuYnRqSXI5bmRicmxO?=
 =?utf-8?B?ODBxRVQyejU0WWdNTWwrMnZwUWdCQjJZazcrRm5zd3dsUC9oRUx1NGkyQkxp?=
 =?utf-8?B?bzZBdE1MdjRJalRqdUJRekFVVHE5emdDU3BmeGd1a3gwRGpka2w4dWJLZDhT?=
 =?utf-8?B?ME5wb3lJMWRoenhmUVE3ZHdLcWh6WTBvbUlpMHVHNmF1dXRPaVQ2dW5WU0Nv?=
 =?utf-8?B?Uk4vcVRVL2RHZmp3dVJuTFJWNFNjb2N1bmVVMStaa3IwMG1kOUovK0wyMTZk?=
 =?utf-8?B?RTZmZ2pmTktBc1U0MGc5d3VrelMraGZqaVZWMXFrNkFUM25QOTBPNTRlOUVM?=
 =?utf-8?B?TEI4NldqQkIvSUE1L0pXaXZyTGY3aHJlcWJwemt5TTkzaTFMWU9xMy9QRkJO?=
 =?utf-8?B?RlBQRG5uaU5kZG9aNmZmL29NVmVIa0hoU3o3QmFVYkFOcmIzWWNBNmZGNC9k?=
 =?utf-8?B?eTZzendVT280eldHaFJVMHhiM3UxQWFISlhicUVyRTY4VEdrMkRVMU1nTnh5?=
 =?utf-8?B?R2pmRlRCd1RFOWp6amxYbmFDR21Mb3p5VWVKK1RGUkErcU1adXdjUFJHNDN0?=
 =?utf-8?B?RkRHWmJxZVVzVzQwcVRoTG00REc0QUVCTTNOMjJuaHQranJlSmxKRkpsUmEz?=
 =?utf-8?B?ZStmUzhhMEQvb2toeDQ5dnJHa1pTYWVUSWdtR2NLOXdKK0x6WXdyVkdpT3Bi?=
 =?utf-8?B?c3FVak5jVGY4dmFtdzlwZ2NNcmVENUdXeDBjM0NxSXRvcWY4V0s3ellOTXUw?=
 =?utf-8?B?WlVOV0hQY014b1dKcXpTeFV6elZYaEJlREdHTjFnMlloK1RJNVVlV3Bhd3lP?=
 =?utf-8?B?YTRsTGVGK3dub0w1MTIvL2JJTHpQc3FaUEFCT1ZFaDFZMlV0YjMrV1BjRnpG?=
 =?utf-8?B?T1pXY2dpZlJ1c05ycUMzQXVTMkxwM2dYVGNqa3kyOGI5cEF2U2JQQXRXVmJp?=
 =?utf-8?B?eWt3TzhsZmdLcURxTjJqWkQ5RzM3MHZlWFhmRWRaYzlJZVhZRHlHUjR6Mm8x?=
 =?utf-8?B?YjNjNE13YzhZdndXbUMzdUxlcDQwNDRFR0U4ZmZlS2cva1M5RHhlUGVWYmlq?=
 =?utf-8?B?SFZsQU82WG9KQVFaRjNKYit5L05HdUlFY1pOcUhiRm40RlNxMTJBd1N1d1dJ?=
 =?utf-8?B?V2htK1NialBpL0NwUzVLK1MrTGYxd0d5NHc3bmZpQkhWMGIramtVUUhKcGRB?=
 =?utf-8?B?STZyT3M2dEdrMnZvb1FDYldIWUVMUHd5OXNrOHJiSXp4ZUR2WWxld3IrZkln?=
 =?utf-8?B?Y0VIeFBQOFMyejBrb1NiUzltbHBqMWh5NWVZcGtBbnBZY0hGQ3FYSDZHTHVE?=
 =?utf-8?B?M3BhdjgxTDJRbFJ0ck4yelk3K2ZwNERuZnhtYUJ5MUF5T0JyVkZTZkhYV3RI?=
 =?utf-8?B?bFVkaFovLytjUFNwRnI3WGtTTEo2Q01vbW94YnZra2VBYmZKL1Z1Qzh4UDBN?=
 =?utf-8?B?cnFHUTN0TDRxcit1dVFwMHNVV082aHE0aTl3TU11MWRneDJJalU0ckxZMlVt?=
 =?utf-8?B?M0h0bC9ZSWFsVkxmT09FR2d1YzNpblpiY2lhdURMNVl6QlYram1DNVJld0ls?=
 =?utf-8?B?SUpHbGpHejVBR3hGS0xLdlNMRkxZMjBzY0IzL2NqQ0x0dUU4SUcvZmY3WGh5?=
 =?utf-8?B?eHE2UXN4eVFJZVB4NFRyN1pHbXNnbGhEWjNYNmRveFRKdVFJUjZXUWFWTFpk?=
 =?utf-8?B?SUp2QW5Gbi9mcGQ1c0NtUm9GYWJiTUVOdjJVQjZNQTdPcExEOVBkUG0wckcr?=
 =?utf-8?B?RnBrZkR6QVZBWFYzT3owT2oycmNEa1VDZmt4ZVpRdVdiTlhFUFI4bWtYc1Z6?=
 =?utf-8?B?YnNReG9MTGNnbWhLbmt3K0JZSysvejEyNmVqaktBOGVlTDIxQzlLZ2ZDcmR5?=
 =?utf-8?B?QjFOVkNDRGRxNlVlNHNTRVczd1FZYjhnRjlicTQ3V2JkanhGWDRqUURqU0xq?=
 =?utf-8?B?T2lRYXJNSFRaem12WTJWYTNDd3pmODJQY282NkpObFdZSXJiNEhUYXBYcS9u?=
 =?utf-8?B?YnpRbll5WXBDWGdIcDkrelRKMitETmZjN3hyMkhMVHRGLzZoN1NLUlBYeDBi?=
 =?utf-8?B?eVhqcTZDVUVLYklXRnRYNGg2eTRkSi9DNDVsVnR5WU9nU3puUUQvVnJXSVph?=
 =?utf-8?B?aGFxU3hKaXpudjg4SmtzMURkNGVrK3BjY2NFRG93ODVRWnRKNlZ1RWFxSEsx?=
 =?utf-8?B?SkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26fcbffc-1f00-4a8b-afba-08dd5ce2f9b8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3605.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 19:13:28.2000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pGehTc9EVy5fpMFjarCS2vYtD1s4H+nw2UDhR+4BsLJ7as2kTYnv6MYYft6w/5m8MtyU1cNbprLSGQH81BP2Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8734
X-OriginatorOrg: intel.com

On 6/03/25 20:19, Paolo Bonzini wrote:
> On 2/27/25 19:37, Adrian Hunter wrote:
>> On 25/02/25 08:15, Xiaoyao Li wrote:
>>> On 2/24/2025 8:27 PM, Adrian Hunter wrote:
>>>> On 20/02/25 15:16, Xiaoyao Li wrote:
>>>>> On 1/29/2025 5:58 PM, Adrian Hunter wrote:
>>>>>> +#define TDX_REGS_UNSUPPORTED_SET    (BIT(VCPU_EXREG_RFLAGS) |    \
>>>>>> +                     BIT(VCPU_EXREG_SEGMENTS))
>>>>>> +
>>>>>> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>>>>>> +{
>>>>>> +    /*
>>>>>> +     * force_immediate_exit requires vCPU entering for events injection with
>>>>>> +     * an immediately exit followed. But The TDX module doesn't guarantee
>>>>>> +     * entry, it's already possible for KVM to_think_ it completely entry
>>>>>> +     * to the guest without actually having done so.
>>>>>> +     * Since KVM never needs to force an immediate exit for TDX, and can't
>>>>>> +     * do direct injection, just warn on force_immediate_exit.
>>>>>> +     */
>>>>>> +    WARN_ON_ONCE(force_immediate_exit);
>>>>>> +
>>>>>> +    trace_kvm_entry(vcpu, force_immediate_exit);
>>>>>> +
>>>>>> +    tdx_vcpu_enter_exit(vcpu);
>>>>>> +
>>>>>> +    vcpu->arch.regs_avail &= ~TDX_REGS_UNSUPPORTED_SET;
>>>>>
>>>>> I don't understand this. Why only clear RFLAGS and SEGMENTS?
>>>>>
>>>>> When creating the vcpu, vcpu->arch.regs_avail = ~0 in kvm_arch_vcpu_create().
>>>>>
>>>>> now it only clears RFLAGS and SEGMENTS for TDX vcpu, which leaves other bits set. But I don't see any code that syncs the guest value of into vcpu->arch.regs[reg].
>>>>
>>>> TDX guest registers are generally not known but
>>>> values are placed into vcpu->arch.regs when needed
>>>> to work with common code.
>>>>
>>>> We used to use ~VMX_REGS_LAZY_LOAD_SET and tdx_cache_reg()
>>>> which has since been removed.
>>>>
>>>> tdx_cache_reg() did not support RFLAGS, SEGMENTS,
>>>> EXIT_INFO_1/EXIT_INFO_2 but EXIT_INFO_1/EXIT_INFO_2 became
>>>> needed, so that just left RFLAGS, SEGMENTS.
>>>
>>> Quote what Sean said [1]
>>>
>>>    “I'm also not convinced letting KVM read garbage for RIP, RSP, CR3, or
>>>    PDPTRs is at all reasonable.  CR3 and PDPTRs should be unreachable,
>>>    and I gotta imagine the same holds true for RSP.  Allow reads/writes
>>>    to RIP is fine, in that it probably simplifies the overall code.”
>>>
>>> We need to justify why to let KVM read "garbage" of VCPU_REGS_RIP,
>>> VCPU_EXREG_PDPTR, VCPU_EXREG_CR0, VCPU_EXREG_CR3, VCPU_EXREG_CR4,
>>> VCPU_EXREG_EXIT_INFO_1, and VCPU_EXREG_EXIT_INFO_2 are neeed.
>>>
>>> The changelog justify nothing for it.
>>
>> Could add VCPU_REGS_RIP, VCPU_REGS_RSP, VCPU_EXREG_CR3, VCPU_EXREG_PDPTR.
>> But not VCPU_EXREG_CR0 nor VCPU_EXREG_CR4 since we started using them.
> 
> Hi Adrian,
> 
> how is CR0 used? And CR4 is only used other than for loading the XSAVE state, I think?

I meant it is used in the sense that patch "[PATCH V2 07/12] KVM: TDX: 
restore host xsave state when exit from the guest TD" provides a value for it.

But it looks like it might be accessible via:
	store_regs()
		__get_sregs()
			__get_sregs_common()

Sean wanted a maximal CR0 value consistent with the CR4.

CR4 is also being used in kvm_update_cpuid_runtime().

> 
> I will change this to a list of specific available registers instead of using "&= ~", and it would be even better if CR0/CR4 are not on the list.
> 
> Paolo
> 
>>> btw, how EXIT_INFO_1/EXIT_INFO_2 became needed? It seems I cannot find any TDX code use them.
>>
>> vmx_get_exit_qual() / vmx_get_intr_info() are now used by TDX.
>>
>>>
>>> [1] https://lore.kernel.org/all/Z2GiQS_RmYeHU09L@google.com/
>>>
>>>>>
>>>>>> +    trace_kvm_exit(vcpu, KVM_ISA_VMX);
>>>>>> +
>>>>>> +    return EXIT_FASTPATH_NONE;
>>>>>> +}
>>>>>
>>>>
>>>
>>
>>
> 


