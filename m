Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB225AFBFF
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 07:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiIGFxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 01:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiIGFxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 01:53:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C970C5E656;
        Tue,  6 Sep 2022 22:53:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RlzwKapGFw1hICuzMzXUwm7KvvvcBSGH5mfB/voxaLbegaStb+Klo0lOYY09NNnssUEfGni6q0bJINAVmIi+/qpNlDXIEvnh/FVzzP3BziF+gXaZZcTzNeVven59wD0UKZ0EbGrKhvkyJAti4t931dBb0fR10KpJ3gXps5eYsMvkGoaAnOA5U/tgPpzBWz8fuWb4HEnWt9iolKyr5IxZQkraoWHMkvuUJGehCiz/TjWby8PivN6mFGqDitn3vy8T03Ap8dTrpy6fQDWyIKF1xzdTm1FFduj0PW6znIw8StX4q7agiJiunnFB7Ov9dVf6vQ31XzsLm3Z1irHGn9b0PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hAcgXj7GY+J4H57pCl7SgtpIgHS/7+GJAFHlcvtDiIA=;
 b=BaU06AFaR+rRN0m5v/fb+jgE1MQAACYZMcmNFVMaq7ZjUerNP5XlpByiolnAd1f3AkSkXCzJ8CVVCoxR+vAO0RKrpQMlQ7qNWb53VWMG2VlC/p8BTrpWPer0ffGavVJ5znXQcFl4WqtVmYy/eUkeB03m9mTmzaacroYjnmJHT+HXY+04WWq7oOXC6QYt6r9Fai0DflexoKH05KOnE607p+LT/IUlGcyn8zerJx0aY3yBngDgghQ1UN+j/XVJ6+6TptNvybPZirh5oB+S35GI9jgI0hHMN6gvk8eFahOzluPUcy6rqsDPXlx1iWxB2C5q6HqHTua8l+joFicVTTUYPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAcgXj7GY+J4H57pCl7SgtpIgHS/7+GJAFHlcvtDiIA=;
 b=ExplhDJf8KTJn+uZLGVNo7X/akJtgsrLYiKN5LkHDSrWPKmGdKBixkZXU1lHb8DU+7qeGQ08rK3o03s7fWlKtOC6TGzQOn/KKwO+fiyol9mixXhDOaPLjsEHFFkKGECAnPntvl9TYE8MTzluW7/M+JeTIlcMOw0NU3m3MHzvXQk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by IA1PR12MB6553.namprd12.prod.outlook.com (2603:10b6:208:3a3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.15; Wed, 7 Sep
 2022 05:53:05 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::e459:32ff:cdfc:fc8b]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::e459:32ff:cdfc:fc8b%8]) with mapi id 15.20.5588.016; Wed, 7 Sep 2022
 05:53:04 +0000
Message-ID: <c07eb8bf-67fc-c645-18f2-cd1623c7a093@amd.com>
Date:   Wed, 7 Sep 2022 11:22:54 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 4/4] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf
 0x80000022
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220905123946.95223-1-likexu@tencent.com>
 <20220905123946.95223-5-likexu@tencent.com>
 <CALMp9eQtjZ-iRiW5Jusa+NF-P0sdHtcoR8fPiBSKtNXKgstgVA@mail.gmail.com>
 <0e0f773b-0dde-2282-c2d0-fad2311f59a7@gmail.com>
 <CALMp9eQQe-XDUZmNtg5Z+Vv8hMu_R_fuTv2+-ZfuRwzNUmW0fA@mail.gmail.com>
 <d63e79d8-fcbc-9def-4a90-e7a4614493bb@gmail.com>
 <CALMp9eSXTpkKpmqJiS=0NuQOjCFKDeOqjN3wWfyPCBhx-H=Vsw@mail.gmail.com>
From:   Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <CALMp9eSXTpkKpmqJiS=0NuQOjCFKDeOqjN3wWfyPCBhx-H=Vsw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0001.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::6) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6346bf6d-8c0a-464e-b3eb-08da90953b4e
X-MS-TrafficTypeDiagnostic: IA1PR12MB6553:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H6MKf91AUZmswD++1PlAtKb4rb+olY2GOS97P16xQzff8SjzmY3KMG1pG3fTTP5Cl2l+zTGhN3iVqUFeKodHyFPhyVp6Q9ml7r6DGFTRJcutnP/1oiNNbdSOkJdHeIbhHkE+N+Kg1trkgjrzYff46c76tCP9xTTDD+crRcoJbi3U2SoTu3Ht+FXkgFBCYCvXRNFYL3/8BgNg4iC9a/9A6PXx3BqmB2ljUlDIkb1rFtwFsUnIaOElm5vCM0hjBkNSQtgxbCT1XClJAx+OiWtKVi/PCt7a+XbkVAGMFRXW4Uijwg24fdCQrD4J+N49KNXdWGPhvgw/JdXC5hDraCnOBd0oL3EOwZartn1cBSPPVx4V5sR8VZxMgSJk6Q8cJ6JYkDt68TiPN+OGjxmPcdxrNelUeCkac/UYXY6p3krgPC6dpxMpD5HWyrxdQtWrmUYIJYQqOHsX8O2CevZSc9w/EDVl6+5+PKOHMDmN9Z5Ulg4f/l7NRNPxJLYRk7VvWJdrmcb0Oq90st0IYX3EjaaOKGkpNvIcUvlkpi8IVkRIG0LB5Tzk2uQZLLPeXk9YzntO58lETcqXCdGpoitidHCd/Df6jkpn//Hk4lBuJpOFD40t8dyH4SpunSm3xwz6YhhYV4lNNve1L9/0yEzT5w/SefXLqqW7bi/eTGWJ4c8N9SdqskNypI8Y+kEZzuLIZPrlnBof2g40ZNG7zX25JS1MyYEF/S7LAfOPK2BZJAUhLX+eVVR5jWvIFOHahE2/j34mH+cwwfHdRbL8Sdy4Soc7Ekx0yWI+3sNnWAdQdPqra5oxCi8muJoihboFit/08M58
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(26005)(6506007)(6666004)(53546011)(2906002)(6512007)(31696002)(36756003)(86362001)(4326008)(66946007)(66476007)(31686004)(44832011)(5660300002)(8936002)(8676002)(66556008)(316002)(110136005)(41300700001)(478600001)(186003)(6486002)(2616005)(83380400001)(54906003)(38100700002)(213903007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFlGNVdySVJhUFhKWDBYY2FBczZmZndCQzVJaEc1ekN0SnkwQnd1b3BNYUZj?=
 =?utf-8?B?MiswSUxKNTVwTzgxZlJlK2dDYysyYzQ5aWlDSmRnemQxR0V0RDJRVTlaU2do?=
 =?utf-8?B?NExXbzZwOG11cWNlK3lKOWtzNkx2aDdSUllxTnNEaHQrT3FPNTNTL2o5OEo4?=
 =?utf-8?B?bTFiK29YL3l3M3lXUmhBMVV5SzdEMTN1ZCtrL1hEU0xFNkw3M1hlMDRGaStp?=
 =?utf-8?B?amxQcVdaa2dVWFRkYkoxR0U3cnlNY2t1SWloSVlnWnJHSnhXczM0bnBmUWlG?=
 =?utf-8?B?UjRUUWpLV2tZWXQwaGFlTFdMR0xzK09OYXdqUlpqczZaejRHQWkzam03VlBM?=
 =?utf-8?B?ZTExM0dLdHlRNDZBQll2amZjakszREhnSEJMdm92TjRFTWlEVkRiNnhWRjFa?=
 =?utf-8?B?SHBGWHpCUW9LaUhUelZSNmVLUzN1eWo2SUJ0UERaSWtPRTdsSExyTElQeUg3?=
 =?utf-8?B?Y1pKL1ZQRmVKeEQyZXF1Y1Noa29LaXdPMzl2Q2ZGUkw0cGhBUzRqQXZ0SE5L?=
 =?utf-8?B?Y2ZOMkxUVnNYdmdyUmNCdzFueHY3VjdhVVVXaGp3cUZldm5zOUYwZDg4L1ZN?=
 =?utf-8?B?WWFSUDl1RWt6MFdpNmVDeWMyVHhDZjFUMHhWbGpLeVhiQnMxZHY4ZWdkMFh5?=
 =?utf-8?B?SlBVTU5CbU5nck5Xc2VONmRqd1lRbkIvMVZzNGd6VE00VEd6MHh5aVNrWTZw?=
 =?utf-8?B?bEw5ZVc5Z3BzNHprb3B2SC9qeXBHcHU1WFlDcHg3cTZ3R1hQbDdBWk5OUXlI?=
 =?utf-8?B?b1lOaXpiMkxvelNhR3JRdXI3S1pDZ21LdEszNDg0ZU5WR0xTWGtmMGp2Tnp6?=
 =?utf-8?B?Q0p1RE50RStWU3k0R1U4b1lRTnJlNWFjM2VWSG5Kay9tUmpBTm04dFczQXZp?=
 =?utf-8?B?NlNqZHg0OHB5bVVnSG1leTZCYTVCSVJpMTEwS056WWRnZHZFdGlNQXVwZVpG?=
 =?utf-8?B?RVE1SyswTm9ZMVFPak94WVRmdEZmT3lxOGNjM09rUFZKRDcvSUg4VVI0djl1?=
 =?utf-8?B?TXlhd0NFaEszY1MrdGN5a3RVS1l4QnNocWt4ZEFJZlpZSzc2MWpMQ2pZUSts?=
 =?utf-8?B?YnZONTFrZ1BWVTF1bEtId2ttK0EyRmRrYTJmdHBqb2praG1YWk51UEErQU50?=
 =?utf-8?B?TWpQbHZYQ2Rkc1l5TDNHdmlGREhudTQ4MHZuUk9BMVVmcVBWSFJDOFhiRXBB?=
 =?utf-8?B?RE5icnIxN1pnWktLT2l5eGQ3TmhzTDdaMDNWbytNUUhsMkJkWm00OEE2VDZs?=
 =?utf-8?B?dHljZXg1QXBOYXl5Z0ZpRml5d3J2MUlrcXB0WkpLdEVkeEJtOXNIcG5USDY0?=
 =?utf-8?B?RU9EZkRoaHRSbGwrWlhBRzZKaWNtdDl3RFRwd1JGZFNJbUo5Rnh0cFNjdmlG?=
 =?utf-8?B?Qk5QdmRGdmtsOXJGV08yT1lWdmVneHVNd0NaU001TzNxZlBpM1lNNEplQSsr?=
 =?utf-8?B?NTV6MkxtVWFLc1dsREIvT2lkSUNSWW1SbWlYU1h2b1BUVjNLVEpiZjlUSzNp?=
 =?utf-8?B?QlEzUHdYUDRaTHFTNURtVUhNUVYxajFFd0x5Y2psdUx6bmE2VWhUbnZpRlhy?=
 =?utf-8?B?bzZRS2dZOWZPMkNFcC9jRHhtNDBaQ2NJMllKYVdZc0xJVEcyODZpNmZLRTlS?=
 =?utf-8?B?QkxYTkRVa1lrN1RIVlgyYlN3ZXRaZ3JidnRJNTdZaXJjek1EODNKSFpoTVYr?=
 =?utf-8?B?RlZIelFnTVFrZjdhNkRKQStXQTNsaGxON0hjV1FCelAzTjBQTGl2ellFd3k4?=
 =?utf-8?B?ZjZ2RXhlcnZjYThBbGdobTg4ZGhibGFHOGhuNXY5UWJnZEJvZmhWbXdyOFo5?=
 =?utf-8?B?QkRFa1hYSWdnSThpZk95THQrd2pmcHlPQmJnMFpXT0Uyb2RSeCtEaFRBM0Vn?=
 =?utf-8?B?K2pySmNnc1FpelNpK0ZsMkVCL3RCYjN2SDF2TERmWXRTdDJGQXJWaUlWK0I1?=
 =?utf-8?B?ZkVjWkMxK1UxNjA0RzFIbGdzRlZlUmlRRnF2a01hUVF0Y1QxNGdaTmV3bXRU?=
 =?utf-8?B?RkpuZFRFTXYvaWEraHd1ZTkvSk41anlLbTZvSGQ2WXRTK2FxWG03WXdJODZR?=
 =?utf-8?B?aGZXbmtJd2x1YzE3RU13NTYwMEYyTVRxQ0hwWkdGWWY0ZUFqQ2Z1dWRaQUdE?=
 =?utf-8?Q?5CNEOaytgAk30vt9dMcsNo95Y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6346bf6d-8c0a-464e-b3eb-08da90953b4e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 05:53:04.9002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lrYcOzz+7zfusXX7Sgp+sq4fR7ljJlGXSVVltH0BmjGBoT1z8kExxmfUlKeOxHyU73febGfTVljzYIso8FL7ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6553
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/7/2022 9:41 AM, Jim Mattson wrote:
> On Tue, Sep 6, 2022 at 8:59 PM Like Xu <like.xu.linux@gmail.com> wrote:
> [...]
>>>>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>>>>> index 75dcf7a72605..08a29ab096d2 100644
>>>>>> --- a/arch/x86/kvm/cpuid.c
>>>>>> +++ b/arch/x86/kvm/cpuid.c
>>>>>> @@ -1094,7 +1094,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>>>>>                   entry->edx = 0;
>>>>>>                   break;
>>>>>>           case 0x80000000:
>>>>>> -               entry->eax = min(entry->eax, 0x80000021);
>>>>>> +               entry->eax = min(entry->eax, 0x80000022);
>>>>>>                   /*
>>>>>>                    * Serializing LFENCE is reported in a multitude of ways, and
>>>>>>                    * NullSegClearsBase is not reported in CPUID on Zen2; help
>>>>>> @@ -1203,6 +1203,25 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>>>>>                   if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
>>>>>>                           entry->eax |= BIT(6);
>>>>>>                   break;
>>>>>> +       /* AMD Extended Performance Monitoring and Debug */
>>>>>> +       case 0x80000022: {
>>>>>> +               union cpuid_0x80000022_eax eax;
>>>>>> +               union cpuid_0x80000022_ebx ebx;
>>>>>> +
>>>>>> +               entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>>>>>> +               if (!enable_pmu)
>>>>>> +                       break;
>>>>>> +
>>>>>> +               if (kvm_pmu_cap.version > 1) {
>>>>>> +                       /* AMD PerfMon is only supported up to V2 in the KVM. */
>>>>>> +                       eax.split.perfmon_v2 = 1;
>>>>>> +                       ebx.split.num_core_pmc = min(kvm_pmu_cap.num_counters_gp,
>>>>>> +                                                    KVM_AMD_PMC_MAX_GENERIC);
>>>>>
>>>>> Note that the number of core PMCs has to be at least 6 if
>>>>> guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE). I suppose this leaf
>>>>> could claim fewer, but the first 6 PMCs must work, per the v1 PMU
>>>>> spec. That is, software that knows about PERFCTR_CORE, but not about
>>>>> PMU v2, can rightfully expect 6 PMCs.
>>>>
>>>> I thought the NumCorePmc number would only make sense if
>>>> CPUID.80000022.eax.perfmon_v2
>>>> bit was present, but considering that the user space is perfectly fine with just
>>>> configuring the
>>>> NumCorePmc number without setting perfmon_v2 bit at all, so how about:
>>>
>>> CPUID.80000022H might only make sense if X86_FEATURE_PERFCTR_CORE is
>>> present. It's hard to know in the absence of documentation.
>>
>> Whenever this happens, we may always leave the definition of behavior to the
>> hypervisor.
> 
> I disagree. If CPUID.0H reports "AuthenticAMD," then AMD is the sole
> authority on behavior.
> 

I understand that official documentation is not out yet. However, for Zen 4
models, it is expected that both the PerfMonV2 bit of CPUID.80000022H EAX and
the PerfCtrExtCore bit of CPUID.80000001H ECX will be set.

>>>
>>>>          /* AMD Extended Performance Monitoring and Debug */
>>>>          case 0x80000022: {
>>>>                  union cpuid_0x80000022_eax eax;
>>>>                  union cpuid_0x80000022_ebx ebx;
>>>>                  bool perfctr_core;
>>>>
>>>>                  entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>>>>                  if (!enable_pmu)
>>>>                          break;
>>>>
>>>>                  perfctr_core = kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE);
>>>>                  if (!perfctr_core)
>>>>                          ebx.split.num_core_pmc = AMD64_NUM_COUNTERS;
>>>>                  if (kvm_pmu_cap.version > 1) {
>>>>                          /* AMD PerfMon is only supported up to V2 in the KVM. */
>>>>                          eax.split.perfmon_v2 = 1;
>>>>                          ebx.split.num_core_pmc = min(kvm_pmu_cap.num_counters_gp,
>>>>                                                       KVM_AMD_PMC_MAX_GENERIC);
>>>>                  }
>>>>                  if (perfctr_core) {
>>>>                          ebx.split.num_core_pmc = max(ebx.split.num_core_pmc,
>>>>                                                       AMD64_NUM_COUNTERS_CORE);
>>>>                  }
>>>
>>> This still isn't quite right. All AMD CPUs must support a minimum of 4 PMCs.
>>
>> K7 at least. I could not confirm that all antique AMD CPUs have 4 counters w/o
>> perfctr_core.
> 
> The APM says, "All implementations support the base set of four
> performance counter / event-select pairs." That is unequivocal.
> 

That is true. The same can be inferred from amd_core_pmu_init() in
arch/x86/events/amd/core.c. If PERFCTR_CORE is not detected, it assumes
that the four legacy counters are always available.

- Sandipan
