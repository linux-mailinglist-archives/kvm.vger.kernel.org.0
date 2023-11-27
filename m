Return-Path: <kvm+bounces-2464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97CFE7F97B8
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 03:56:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CC58280E90
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 02:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B04E23D1;
	Mon, 27 Nov 2023 02:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NnIdgsQM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15D2111;
	Sun, 26 Nov 2023 18:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701053762; x=1732589762;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JFdamgichXSDOfaX0vpTlILFyIMKRiEIqXC7eh40eVM=;
  b=NnIdgsQMFlCNJjwbadLsS+vFfGEzNQav9UVZzCS9GzV2cMGqZcyvFZP3
   SO33wiUzt6eSmQjBDEFydSK9wyP8OwBav8zPfMLjEQqobE16tfJDWP8+/
   TkxnI5j7dh6S8nAqU9C7SDBIz94EqjFQX+Wwgf//DRTFhyVPHTCwynUxi
   JfEOD8M9vo1QZTV2mcn6ijk7uuSCgwUEm91weKNWI1FvGjjxk+Mhy1mNH
   XFinNSXaQhXo3NzzQw+7o4NbvKd7+XEIM1eHLbxc//up9819U8aBAKbuB
   dI0i7tlT8QvH8VzjzdKoYfKzplB5bpGT1X6rCPtgZ7Ilc4M6wTMLirx8y
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10906"; a="11326672"
X-IronPort-AV: E=Sophos;i="6.04,229,1695711600"; 
   d="scan'208";a="11326672"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2023 18:56:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,229,1695711600"; 
   d="scan'208";a="9654240"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Nov 2023 18:56:01 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Sun, 26 Nov 2023 18:56:00 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Sun, 26 Nov 2023 18:56:00 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Sun, 26 Nov 2023 18:56:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHB0AYbpydG7HAg3OUyhwTDdynwOP8rCOLOAf7jOZhuCdeEnt8ZayE0hplIOGe+1hzQRzei9bnLyXwv/+wQu1h2islWt7zjUvy3ew3oJ2gN88y4gXNN5qs8jFXedRLrtTUEQSrOMxrNfZyPSZPHCUfgx/cxyEB2NOlEOptI+g5BhI8J3oB7vtWYqwjShgoobNWo+NeT7I4sSVSJL4qAfBvwxvYwwVR/YD6ucvZfwRAz9/vEe7muqeA24tM2t/nFL6OehK5XHC0CohqReYC6mPk0TwfRtoX8oPfQFQ6oGi8pUde9FOx+hHLaYIf39JBRpjAgJ3ZTt6H4Qaqugtcfrcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F4zbvuNLp8O4e456synaPXqTJvyYdu27RmR7NFt7nI8=;
 b=jHaMASO7owoQruDeSjjoHTSBZJsD3l3WF2mbF9lOXjuhBsCDKxQ9aaBYNRbP11nTm9nAIBpo4XWNHyGNIbpw4UTH9EvwzEOTKttOO33+moVcMJduQmP7wmNp0p+5DAPsLcysNVfWy3zjIWd9LMvweCiYH1u1inHLaY1d4D+hK5ZZW+/ND//DBgscz/slIwZWjUPqHT/jyKK2ma64hokKUu1f1RBaXd8gMpEmHmK/wqlm5R+ppFn7xveQ+XH+6n+XwNb5JYFVYBnWEDNg4xomyCJfR9W8UKZDyVcssThJH9GLBzZ47NRxL6fThmDJA2tCOr9E8KkH73AUmq5B0aE0Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB4972.namprd11.prod.outlook.com (2603:10b6:806:fb::21)
 by DM4PR11MB6142.namprd11.prod.outlook.com (2603:10b6:8:b2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Mon, 27 Nov
 2023 02:55:58 +0000
Received: from SA2PR11MB4972.namprd11.prod.outlook.com
 ([fe80::5a42:f2a5:98f7:7be4]) by SA2PR11MB4972.namprd11.prod.outlook.com
 ([fe80::5a42:f2a5:98f7:7be4%3]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 02:55:58 +0000
Message-ID: <18f95549-8971-4b03-8569-61d9b1763364@intel.com>
Date: Mon, 27 Nov 2023 10:55:48 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
To: Peter Zijlstra <peterz@infradead.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <chao.gao@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-3-weijiang.yang@intel.com>
 <20231124094029.GK3818@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20231124094029.GK3818@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::19)
 To SA2PR11MB4972.namprd11.prod.outlook.com (2603:10b6:806:fb::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB4972:EE_|DM4PR11MB6142:EE_
X-MS-Office365-Filtering-Correlation-Id: 46ee3fec-8d6d-4a9f-4ded-08dbeef461ce
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /6lLMl0yzlq8JcdMl89rpGDGcrVBJ+VTHFq7TUqLn7yRijI0eojEe+cXn37j5P6SVD+qwxHAhgca8Wn27Fw3Q8DvUAF6JgDCBOnniVtslB0IBWgy5W+ObB4Gp72WT/cL8jXlgw+nwQjL+Q9OQ5qjds/nbHHeCURj42+NDqwtbQa9dXYlMcuwY9hdHWdfg6Dob/U/9PPTCsdSaDpgA6VfOdxq7ujeCVZ2dJR1Dn8csyG9bVIprllVluwAIinQpW7C+bpTzC07S4d0DOCvNRGi8OTvI6SGW2QiFpxeSMGid+zf6fdS76PsIGc/00Cnu301Blf0jRPQIk0L0U7BJl7LVYMi6+m18snQh7ez2Q8FLlnCTzCcMyM8Cof8yedHLu8IvzF/dqByWCVNtbj5XYx5A+2LdVmsIOTE7jcQpr3pbmgjBZmBxInWhK0jlRUmaT7UgHvjamcF62snhOXVEf9IdmAAGlyI2G23pXG7uasw9klaIHXatroF1JV7yWgOkvQHoQvw1KDyUC0vxzQ7g1qG3u96B52eu/P4FQpypWqiHv2nar+daXp6TS9T/+K+vsMfdVQn5KS4NHh+JuOPvENTVgW8l3+3i7K4gZQ5g4uNej6Uoy6U+Gv7iHc/69ZSQUuyhjTaraFe/GFMYFcr8nJV3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4972.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(376002)(366004)(136003)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(38100700002)(36756003)(41300700001)(31686004)(2906002)(83380400001)(82960400001)(5660300002)(26005)(86362001)(2616005)(6506007)(53546011)(4326008)(8676002)(8936002)(6666004)(31696002)(6512007)(6486002)(478600001)(66476007)(66946007)(66556008)(316002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnIwUGlablV6OXh2bExvYVZyVk1ib1JFaFNydUNQcjdVeDNYZjMvZXROaUZl?=
 =?utf-8?B?Smt0bmdHVDkzM1RHbi9hZG5SNk9Vd2h0WkloVmJYcnBTOXJubGZ1NjlDSWxj?=
 =?utf-8?B?ckM1d2VSZG94cEZ6TTVDcnBOQklJRUxaclVHRVlvVkNRaTl6SitIY2J1SDRM?=
 =?utf-8?B?K3owRlpnbGt6T3orTE1aZkxYSllXb2cvQjhDU05OSW5qL29OSHNwek80SGdU?=
 =?utf-8?B?QWtsYVpRSytWZnE4VFRYYXNqSE82dWo3VStFRGxTQitWZEZkZjRSL3BUWVdx?=
 =?utf-8?B?YVEwV0NYQ3htWnpHb1JUcGYvdEUvSkdUbzVKa3NBcFRYOGlubkdQWVJXSk9S?=
 =?utf-8?B?REFKZFMxVmZYWnBZN1FQK2xQUVEwWDNiZWwwdU0rR3NNVGNGbHZDN2htclVL?=
 =?utf-8?B?M3Y1RllKcVZzWk9qOFZKcFFRbEJoMi9kbnBQODZFbXUxVENzdkN4QnJHNERL?=
 =?utf-8?B?Tll6Q0xtem9iZFFoTFBaQUN0VkxNbVdyMDllbklWRk5wTTRmZ3RhYUtiR0pU?=
 =?utf-8?B?SXRSVS9EaHdwM2pMT1FNK1lrcnpWOUcvNU9keGRhTEVwTW50SmIvN0FQcjYx?=
 =?utf-8?B?eStrUVVtRDU5MUh6ZnhnWWNkeExFaUZveWFrbW1rZ1JmMHVlQ1U2amdQODgx?=
 =?utf-8?B?MzRQZlc3V0NiSXVmWDNPd2JGTDNRKzJFVGx4V3dpT2dsTkFFTUl6bXRHTGJy?=
 =?utf-8?B?RWM1R0pGRkdiUVpsdjl0UDBRRVEzc1NJMURDVEI1V25ydGwyRVdwVk93eExS?=
 =?utf-8?B?TGFpa3RsVXl5TzRCRDJsZzhqMVVFaXhzdHR1V21YZlhlcks4ZjVyY0JCNUxt?=
 =?utf-8?B?STl0ZDgrdEZBcktqUzAwTU5yU09obnFQSVlsUGN0aFFucXZBM084TkpzRUk2?=
 =?utf-8?B?U05PdkpGcWZiV1NZZmhJcnNkaGd0eEJWaWxDY3UyNGZCUFdoalEzUDdaS2JK?=
 =?utf-8?B?Kys1Q29yaGEzV1JZR1FhU1pJd0VmM09TYmRFV3dDaGJwd1VicGUyNVEwc3Iw?=
 =?utf-8?B?VnpUeDhqS2pMWTBzWVlUZVdnV0J3aU5ndXp0dFNMQk1QYkIzYWdCSHJlbnp5?=
 =?utf-8?B?NXVqMUI1YjlhWStUSVpGV0wwaTEyVW91ZlhBclFWM3d4WDVlY3NSeFUwV2ZV?=
 =?utf-8?B?UzlGQlBvWHBwcnNnQmprTjdDb2lIVWx3TDcrQm5Sc3N3cHoxeGtxaGRzOXdn?=
 =?utf-8?B?Vy8zMW40WTJESFZTTlg0cXJLRDVtM0xUWWt3ckRoK2FNdDZDYWhqaThQWjhi?=
 =?utf-8?B?cGVZTUV0cG54UWNyeGhIWWV3RTF3cFZzajRBSGxnYjJOU0IzNzY5VGZLNk14?=
 =?utf-8?B?YTdTUVY5ajZJZ0lJZGk5V2docW03aUtHOWpMbklRK3lMaE5XNTh3OGpDd2FQ?=
 =?utf-8?B?ZGZIeDRrSUxLRE9wajVtWFhYbEYyOFU0clFnQVpXaVpSN2U5U0plV0ZpVGI0?=
 =?utf-8?B?QTVsa1hCc0JZbGk5WEY1OFFDM0V3L3lqWHY4ck4rMGtPV1JRakZzMjBWUjVz?=
 =?utf-8?B?dHdrNCtDT0pWMG9SSXF6blpjV21kS1RkWmZiWnJEVDdrSm1OM0laMzhXK1Vk?=
 =?utf-8?B?S0pLckFqeHB2UnBzUTRsTU9SOU9DMThMeGI0WWZ3ZkZGanRia0NXSTk5VmI5?=
 =?utf-8?B?Sk1GMTdZMHUxNEZoZU1ZOTkrYlBDaTlUV2t6NmYxM0F5ZDZFUEtFbVZ3ekFY?=
 =?utf-8?B?d0QxMTVjLy9qeFJyam1UZTI3Nk54RUNSUjY0b3ZNOFd1Mm14NlBNQlM4WUF5?=
 =?utf-8?B?VWd0TDdpNHcrajRsTERqYkhROGNCa2VvN01SaFJ3T01BZFR3eFRLTGZBazBG?=
 =?utf-8?B?N05XS1UzdUd0QjI1Yndod1RrRVdKbmdwdS9GNkYxaWlyaDVZS0R0eGNtT1F2?=
 =?utf-8?B?NFk0RjJUVnBiYzlsOGFYako1Q2R0aGRzcndHbFdMYUpIOUxlME5HTFRrOGFT?=
 =?utf-8?B?ZDY2ZTFGcitkNWxMbHhjQm0xMlZEcjR2dXJ1SjVqS0Fpb01CaE5QTWh3UVFI?=
 =?utf-8?B?L0dLUzhrYTdwQUtCMHFaUm5CdTZXdERJS0IxNFFNcHVWREJGOTdKOG9JVnVQ?=
 =?utf-8?B?RDNsSzJLbm5CVytkVUFpd0pzQnJZVTY0K0pvdzNNd0VjYTJneVFlRGdKUkJG?=
 =?utf-8?B?Q3VyUFc1MldPQ3FiWjZEeWRLNU1Vd0k5QWp3bjVRbWt6a1NCSXRQclFIbmIv?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 46ee3fec-8d6d-4a9f-4ded-08dbeef461ce
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4972.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 02:55:58.6217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rw+eJ+wWltp2LdnU3jsJaDxYJIGXIQ9V8yHJlHB0KRtQuNYY8fkxsfk7UEg/Zns+15mSxK9nADndEQOYtx95vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6142
X-OriginatorOrg: intel.com

On 11/24/2023 5:40 PM, Peter Zijlstra wrote:
> On Fri, Nov 24, 2023 at 12:53:06AM -0500, Yang Weijiang wrote:
>> Remove XFEATURE_CET_USER entry from dependency array as the entry doesn't
>> reflect true dependency between CET features and the user xstate bit.
>> Enable the bit in fpu_kernel_cfg.max_features when either SHSTK or IBT is
>> available.
>>
>> Both user mode shadow stack and indirect branch tracking features depend
>> on XFEATURE_CET_USER bit in XSS to automatically save/restore user mode
>> xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever necessary.
>>
>> Note, the issue, i.e., CPUID only enumerates IBT but no SHSTK is resulted
>> from CET KVM series which synthesizes guest CPUIDs based on userspace
>> settings,in real world the case is rare. In other words, the exitings
>> dependency check is correct when only user mode SHSTK is available.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>> ---
>>   arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
>> index 73f6bc00d178..6e50a4251e2b 100644
>> --- a/arch/x86/kernel/fpu/xstate.c
>> +++ b/arch/x86/kernel/fpu/xstate.c
>> @@ -73,7 +73,6 @@ static unsigned short xsave_cpuid_features[] __initdata = {
>>   	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
>>   	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
>>   	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
>> -	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
>>   	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
>>   	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
>>   };
>> @@ -798,6 +797,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>>   			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>>   	}
>>   
>> +	/*
>> +	 * CET user mode xstate bit has been cleared by above sanity check.
>> +	 * Now pick it up if either SHSTK or IBT is available. Either feature
>> +	 * depends on the xstate bit to save/restore user mode states.
>> +	 */
>> +	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
>> +		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);
> So booting a host with "ibt=off" will clear the FEATURE_IBT, this was
> fine before this patch-set, but possibly not with.
>
> That kernel argument really only wants to tell the kernel not to use IBT
> itself, but not inhibit IBT from being used by guests.

Thanks for pointing this out!
If ibt=off actually causes XFEATURE_CET_USER unset in fpu_kernel_cfg.max_features, in KVM part (patch 24), we already have below check to disable SHSTK/IBT in this cases, so looks like it won't bring issues.

+if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |

+XFEATURE_MASK_CET_KERNEL)) !=

+(XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {

+kvm_cpu_cap_clear(X86_FEATURE_SHSTK);

+kvm_cpu_cap_clear(X86_FEATURE_IBT);

+kvm_caps.supported_xss &= ~XFEATURE_CET_USER;

+kvm_caps.supported_xss &= ~XFEATURE_CET_KERNEL;

+}

+

>


