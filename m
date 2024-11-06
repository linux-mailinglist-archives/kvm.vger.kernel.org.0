Return-Path: <kvm+bounces-30827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 460C29BDB65
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1A751F2137A
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 01:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A2D18C011;
	Wed,  6 Nov 2024 01:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LChkX0q4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A20156962;
	Wed,  6 Nov 2024 01:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730857573; cv=fail; b=dfKPvRXqQCvDHgzCobNu1BfmcYSXyJ8vyNh4F8JKLt0BvURe0wqYDwt/VfoPCqUZApT20yfENcXdXf6DBCuIzpK7BHtBMpETLne2h9+AQ2RQFO/krsBqGp6LvxDVKNL3tf3z/Sv8COIQCAwK94OugFJ0E/WSx1aXDE64c1MHCWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730857573; c=relaxed/simple;
	bh=AIMCHC/Z7xpFDpckO8YVypBNRXWy06D57N+rDqreoCU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rbzJgf4oSHg0ko0EdZiczoU7zwKfdEn+MWlOFUeJLyRDP6PnyWvoIdh3Nr2QFzk74oM9BPfgAe2YBDQySrqk5YW+nWqURmrbh8r7W1OqahYkiVknGbZRNQA/7bd82w2axGU71G3KJ6mHFyAbEc1enRK3LO7aIyJOi5Uvvj1Tj0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LChkX0q4; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730857571; x=1762393571;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AIMCHC/Z7xpFDpckO8YVypBNRXWy06D57N+rDqreoCU=;
  b=LChkX0q4SD6mcwqlVWjW8unHjoAC2N6W72GjOtNE6hdwVT5J1o7fK4ZX
   jtWcP44Jgoa9CDPIAcRpUFGbrO3cAsnbtsbJWTrfzr2iSkg3R15NlgHAm
   l8eh4wMGPhFoln+y9/8JTH0jAArYW1+KJqWWshi0C5bkcNMl0N9Gt8kr4
   dZ98pdYG1O+BEfiRT/4Ir0ndTirUTOapxj9MRcNRvB6vonmlHhgu8bABZ
   zsysLZBzcx5XsdQygRedGWMS0jNrW2A6HlAQ3gUTslDaLzccP1cEF2OgE
   J32GjrrtR9uGhUvnO82zST3uIwihcwmiXE6GnpRwEi7vEay7ysoYpGdTw
   g==;
X-CSE-ConnectionGUID: JJPnlZ7bSb+zSS7zUPVirA==
X-CSE-MsgGUID: NxmyWLAnRC2tajtQ3OcuDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30409424"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30409424"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 17:46:11 -0800
X-CSE-ConnectionGUID: bh4dpPGzSnCnOmv5u5f2hg==
X-CSE-MsgGUID: WIqBMVjESR6gKxpRW3JIOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="89088882"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 17:46:11 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 17:46:10 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 17:46:10 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 17:46:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q6tA34BS/h650i2y0yHSmXY+O4hIyv7nanDlXl5w/NPNMQsCi6tZ9UuyoPJRyvfP5fFA13ebSBttRb6HMHYHDAYv+j+KfIDUuZssOfoCbZdABRD9CdnCg0TX8N2ZEJuM5rXxyjRtv/5g0u6s0BRJC1Mfx5fkGMlGtWRU+oHpJYHICoRShHb+8oaK6ddmG6RMkw1yPaE1k0S2S0KdTo4bpZglg4ATOjeywsPJNIbUbclzKWGbxUXZxyG7yPsufw0sniiz9eo8HnhEmoUON7XsFrymLfJWFbqfvu1dtEzmqdsg3VUm82Ky24XOet0dHo0ELbPojpuH0ey/S/h35DSl0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIMCHC/Z7xpFDpckO8YVypBNRXWy06D57N+rDqreoCU=;
 b=dBgz9wawfXXLJEisAW5Edns+9wZOmh4YnIdNEjhzLALxq5UQ6o9pBeuizbcOE8CS/7K3LQJ8XqmXok0D3uh7VLJc9UGhEQNvUKFSWqe1JtSbINF+9L6S1JuseSNiJinhfu3u17a/sSBTRH2CouKJ1EHBJ9nRO4fXs8OxDdpzCAVO4OORCmLTi4p2j1hvBTSutiUy05I29QFpAY+tUkTEWVNyoFPCcLIm4hdLkz1NWLg+S/FhaSL1oqIR2KIImpctNX94ynvDIHIYyd6jR5uF1Pao62voSE/LXbsrP7qK15+9pag94vPJuymOQHL4U51Lcv4s3UvQZDhI/aeL4YbnuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BL1PR11MB5287.namprd11.prod.outlook.com (2603:10b6:208:31b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Wed, 6 Nov
 2024 01:46:07 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%5]) with mapi id 15.20.8114.031; Wed, 6 Nov 2024
 01:46:07 +0000
Message-ID: <8e9f8613-7d3a-4628-9b77-b6ad226b0872@intel.com>
Date: Wed, 6 Nov 2024 09:45:59 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/27] Enable CET Virtualization
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <ZjLP8jLWGOWnNnau@google.com>
 <0d8141b7-804c-40e4-b9f8-ac0ebc0a84cb@intel.com>
 <838cbb8b21fddf14665376360df4b858ec0e6eaf.camel@intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <838cbb8b21fddf14665376360df4b858ec0e6eaf.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0131.apcprd02.prod.outlook.com
 (2603:1096:4:188::6) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BL1PR11MB5287:EE_
X-MS-Office365-Filtering-Correlation-Id: a9dd1dea-95cd-4ff9-668c-08dcfe04c825
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZTFkQmZUaCtXa2xmOFo4SEg0WFk3MmRwZk1ZYkdVemdxRnlCN1BZV1lLcHhq?=
 =?utf-8?B?aGNCRS9DajY4WjNQajQ5cWVXWFdSMEJPQnYzWlpvMTNxZ0MvZGhvV3U4blMr?=
 =?utf-8?B?cU81eEFPamx1STYrYVVmdVh2dTdESTRORURqc3RjM25oTTkrWXNKZTdzUVZJ?=
 =?utf-8?B?WEVsNXlsdDJJbGZQL05NVFR1bW5kai95RnZ3cGhrakhYN2pZNU1rR2Y2SUF4?=
 =?utf-8?B?QzA1VWo0WDV4akdXbGhNRjhYYUluQ1BEVXcwenJQQVB3RGlSY1ZqdWluM0dK?=
 =?utf-8?B?S0hYQmtZcW0ydFcrU21FM1AvOXlxYU9JNHFUNXRoS0pvSlp5RGZqaWJiMFlU?=
 =?utf-8?B?QnNUTTQ1OE95bm1vOWppcWd4Vk1kYm9FQVdZNmQ1bDZPUFB6UzV6WURPOCtM?=
 =?utf-8?B?U3VoZXJTd3lQNE8xdVdncTJnVXF6bXhvMGYwcndnVlY1WnNaQnZqWDZ3Z3Ja?=
 =?utf-8?B?d00ybHZCUTdtSVora0wxU3Z6NHVHeWpsMVE1QWR2TjI2YmxhUEVhTG5EdTdZ?=
 =?utf-8?B?aGFOOUJLTWdETFMzUEdwcUNzUWNzQzZoR2xRNTlvQk84ejBMRnBXcmJ4eVRl?=
 =?utf-8?B?eTFUbVU4c2F2Y0RMME13N1RsY0pNVlpUemNtUjNscTRQeVZhbzFQanlWWDlP?=
 =?utf-8?B?U3REVUpIaTB6aGM0Qy9MVjdYUjUvVWx3T0xueGZwZWZtanFxQ2ZjT2Uyd1g0?=
 =?utf-8?B?SDNSOW0xcHRuU29lNUprK3o3WFVuaGgrTFVUVCtmUkpjaFZ6QXh5S0NJYTBs?=
 =?utf-8?B?NkhtaHptbEhqVzVsN2JpWWdkb0pFQ00yblpUcHBZR0FjMk9PMHJhdDRvaG1i?=
 =?utf-8?B?SkpUYmRBaEQxSEdzVVQ4Z2VTQzZDNFJIR2VKNGVTN0lFWEJyUlk2K1N1bE9s?=
 =?utf-8?B?eHVWYnEzWmdJSlRKK3NqN3Rqb0VuS25meHcwaU5vTTZkZ0ZybDZRcWxDSkIy?=
 =?utf-8?B?RURNRkxROStoV0wyME1QNmdRSUdHSlFKQkV6RHdqcXBxb3hIeHlyUG90UytM?=
 =?utf-8?B?RU5KU1NUTlg4TmMyQ3NnN3prQmR2MWwzaHVJdXlnemF0bC9rbWhEODR1cmVw?=
 =?utf-8?B?Z2JVazFxajNvcmdpYXlTUS9ieU96VmFLcnd0eFRaMU9leExiZUEwS3lhdVBR?=
 =?utf-8?B?aFYrQmc1RFI1NFJEM0UxQTU3NUZjV3g4akZRc1VWaEdoclJ0c3RhL1lxc05S?=
 =?utf-8?B?MGp2LzRSeXlESndiM2YyenZBTG5RU1VIS25nRnFSSnBJcmFRTmRIL3RZTmZY?=
 =?utf-8?B?b0ZsSmtBVXFaaFJYdUxnS2g2elY0MTlLYkU0ZUpyRzR4bG5wdk85eFVGV3lX?=
 =?utf-8?B?dlJpZjFDb3JIWStlT2NldjBZdkJhcXNvTmhNalkrTFZNYUFmamI3bW95a2F4?=
 =?utf-8?B?M1NlZGFOZHpNaGFnSnpqVFM4NUlueUR3UG5xcTVZNThQdy91VFlFQW5qSTV2?=
 =?utf-8?B?aEU4dUVRSlArVzFNMHhJWXdOOW02cFZLUFpGVmlGUU96TXhlUmUrdGxDQ3pF?=
 =?utf-8?B?WUtpT3dCRm5NZGxlQ3hpUlhzcUo1d05MeVJCamRiYTRMRlowc3hMMXdXc1dm?=
 =?utf-8?B?Y01Cemhyenk5dTJVM1dGM1FweVM4OHBMRmRHRDgyM01KaGxBN1g2TmREam5i?=
 =?utf-8?B?NHlyT0NLc1V1ME53WWdWQlQ5RzdCY1haWDg3b0F0SmViQnNwa3FHaENudXhM?=
 =?utf-8?B?SUQ1RFc4NDlDblQ4NzNmbkNtQVJ2OU12aHV1RXRGZzJUdGpvNG9PQVlDTjVF?=
 =?utf-8?Q?mLS691iSIZN2kDCyTh5tS5AeKuGlnfl/UoZcg+U?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3Ntck9nTXQxd3BXTWlmUXFJMmw3MkV2NHQzNGMxY0xlVkdpeGVtTkh6Wklh?=
 =?utf-8?B?MlByQ3Y4V3RJeTFiN2ZlZWVVek9PSjhUVGNOQ2p5RGgweWROTVVaa3R0ODFY?=
 =?utf-8?B?MnlZVGMwQXNlL1locW5sNWI5Q21BRXVvSUpCeXBDUWhBdkdFV2w0UURKa1Fp?=
 =?utf-8?B?MElPOWwrWHFoMmhvNzAvM3FrWVlKblJRUmRsanE1T3NPTTVBYm1YVnlEM1pT?=
 =?utf-8?B?YU0rSVQ1NkpPbjArcSs5dytPc3o4b0lRK3NWVDJmVzRlWExBbjhCQ3VQbG50?=
 =?utf-8?B?T2FNbXpoQmhpRE5PTkFFTUdxSWpKdHZqeTl1ZVlqdUlSNGdKQTN0VGgwb3hy?=
 =?utf-8?B?NGlvb3ZJQmdIY3huUDZZTEtzTnZrT2I0aUR4OGFQc09SNXVjd1hoQXZmemdE?=
 =?utf-8?B?b0Y5NUNJZDliS29tRmxWNVJTL0wxTFUzd25iMjB2bFVQeTA0VzdYZEVxZjll?=
 =?utf-8?B?cnZBSndBd1o3NkJKWlVIL1luWmNZOTEwLzVXUW9BTmlVS1FGcmJyazhTY0RZ?=
 =?utf-8?B?eUV2ODNMaTBiNFYwNWdvNG1HNlRMd3l3NjFUcUp5SVZLd3NOdnpHa2tGMWQz?=
 =?utf-8?B?WU81OURCUlE4NzJhaUdKYkQ5K09ySUlCcjJ4aTh5VlpGN3Mvak5HSXo5TEYx?=
 =?utf-8?B?OURjVHBFNTA2d1hFVnJSWXhZZERjdXp3ZnhBSWJ6R1d1RzI2a2tvSVVsZld0?=
 =?utf-8?B?eHJMUGdzbU5CNlplRFd0bE82TUVpMmd6d2taQWxPK1pDV3dkRmdRZ2VuejhR?=
 =?utf-8?B?Z3BrN2J5N2UwdmFCczJXZjBDVExTZ0RBZVZrN2huNnltQnRxVkp3dkZjc1h5?=
 =?utf-8?B?elNrSEZPR0FyRmZKRFRJOXlYNnRsNm05RmZUejJJWFBCSmhYazhuSFkwREVI?=
 =?utf-8?B?ajdMUW93VitTS3NmSVJjdG1oWjBlU3B5UFk0d05SclBNSnY4QkkxZXpPc0Fj?=
 =?utf-8?B?YnJONEdJajJ6NUh4U016aWFqOUNyRTBaY281R2F4Rlh5UzhlbEdFMm00QXh3?=
 =?utf-8?B?UXF2QWhtcmtZTk51OEdDQmg2SDRKbU1hZXdHYWR4QTBrSDB1a2oxaDBFc1BR?=
 =?utf-8?B?MEJ1ZVpmUExPU2tjTU9lSXBtVWRPcFVsK3pPY3NvcGRFcFFtWCtYV0ZDM3hp?=
 =?utf-8?B?TUVVZ3BtSWgwYnlzUlhCZEd1TWlZdjdLQTRzbDdGSCt3akkrS1JSUUlVZjVR?=
 =?utf-8?B?cG1HS1F4VmdOb2pLWFJOaWU0WnZhaTVmREJSNmFNYjdnRS9NL1BBQ25sNGZ6?=
 =?utf-8?B?UldRMjJkcVZNRE4xUXhyWkh6RGpUczNEKzRnZkN0SVpIV0QrWDFxQW55V2dR?=
 =?utf-8?B?aTFHZWhSN1kvcWhQV2ZJbFRyakJlWXcrcGZLNmRPNWZYY2JFeUNKcWcrOGxt?=
 =?utf-8?B?RkluVFVrY0g4WHNNSHhWWEl3djJCU2lqZU5Hd0V6QzJxQkZLYVc0Q0lGYjNL?=
 =?utf-8?B?RzdzbHhldDE5ODVYeHpXYWIzYjZSZlNnNlVvZmhLS05TMVJPbmJOZG16YktG?=
 =?utf-8?B?MlNPU2dHMUFEU252cDExL28wcnNIMnZYY1JrVjkxcHFQSU5tRStnWGZ2dWdY?=
 =?utf-8?B?VVZkaFlSOWRPQjVVcnpBU25CTWJ5cWhScjlRdldINTlJVkdSeFhxTkxibkU2?=
 =?utf-8?B?ZmlOaXlWUDh5UzJIc1RsVTlHcEJWL2c0Z0g4dWJ5ZktMTUIrL3ZleFhxejRx?=
 =?utf-8?B?akJjc1ZleE41RkgvS1JtR3daY0lJZk9XWXN2eE9zTWxURWxwcDdGRjFwc1Zy?=
 =?utf-8?B?d2dOVlBKYlIyRWY1K1kxb1hCeTEwS3NlSXoxTDU2Q2V6T3hwQ1pZN1E5NDdw?=
 =?utf-8?B?dGxOeE1rRkJLSU1lRmpBUWNOdytjMFhldU5od2xqRTQyZFJRd0ljVGw0WWZr?=
 =?utf-8?B?b1dZS2lhVjIxcWw1OFdLVzZHK2JIcmhNd1RLT3FXWFhhMmNBZlR3cU5LSGVV?=
 =?utf-8?B?WUpiNUh1bVVzTFJZdjAzZXJYVDM4aGd0Z3dwcTV3R3hWcHJxcEtteEhNbndQ?=
 =?utf-8?B?b3VnWUFJQzVyc1RMcUsyS1FzT21pV1k3VFB4MUcwVHVtMVFSaFpVTHIrN3JO?=
 =?utf-8?B?eFVpRFRMM0lBRnJtajV0SE9abVhRTDFmeGdjOHVXMDhiOG9WM3F5N1VDTWoz?=
 =?utf-8?B?aXJWZmpzZHk2MFBFZ1FMa0lydTZUS3JyaERlUXZCd0FXblJXVXA0dDFpK004?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a9dd1dea-95cd-4ff9-668c-08dcfe04c825
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 01:46:07.4691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uW91PuAMZkoD5DNgG7zBmfoHQprYd1Ac3BMxqkPGhCZueeDcRy8xYbW3SAl7IZBaSOpd2XYAyb3t9vzv3RRR0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5287
X-OriginatorOrg: intel.com

On 11/6/2024 2:25 AM, Edgecombe, Rick P wrote:
> On Mon, 2024-05-06 at 17:31 +0800, Yang, Weijiang wrote:
>>> A decent number of comments, but almost all of them are quite minor.  The
>>> big
>>> open is how to handle save/restore of SSP from userspace.
>>>
>>> Instead of spinning a full v10, maybe send an RFC for KVM_{G,S}ET_ONE_REG
>>> idea?
>> OK, I'll send an RFC patch after relevant discussion is settled.
>>
>>> That will make it easier to review, and if you delay v11 a bit, I should be
>>> able
>>> to get various series applied that have minor conflicts/dependencies, e.g.
>>> the
>>> MSR access and the kvm_host series.
>> I can wait until the series landed in x86-kvm tree.
>> Appreciated for your review and comments!
> It looks like this series is very close. Since this v10, there was some
> discussion on the FPU part that seemed settled:
> https://lore.kernel.org/lkml/1c2fd06e-2e97-4724-80ab-8695aa4334e7@intel.com/

Hi, Rick,
I have an internal branch to hold a v11 candidate for this series, which resolved Sean's comments
for this v10, waiting for someone to take over and continue the upstream work.

>
> Then there was also some discussion on the synthetic MSR solution, which seemed
> prescriptive enough:
> https://lore.kernel.org/kvm/20240509075423.156858-1-weijiang.yang@intel.com/
>
> Weijiang, had you started a v2 on the synthetic MSR series? Where did you get to
> on incorporating the other small v10 feedback?

Yes, Sean's review feedback for v1 is also included in my above v11 candidate.



