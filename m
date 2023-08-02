Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA4076D859
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 22:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbjHBUDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 16:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjHBUDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 16:03:52 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE92F0;
        Wed,  2 Aug 2023 13:03:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPinB9dveQK6KMmdkxbhWXLD37AfzzVD6dLSLMTW70iqgBLXFPtPacY5y3KnrOVO+0IMTQm+E00kSXEj2C5MG/bOQzeYqz8cJHZAZQE1gZCg31gkxsOXhd8fh3tOEpECy9Ggy231i1dzwImJfWkgQWkTegxqzvb15Ov9F/uE+gbhtMhp9uXDfEsyZ1TAGsAW161GMn8VzuCz1O8Le4spyLpvFFv27La8hd8fjEjuqLlbtICzRsvu5qH8YMObHJ8ghSXz1cOoRX+GQGK2m6o3A5rEdptUcYT3z/zFvfQgjhYcDXXmmr0XeBpRUjNVwGyzaKef9bucgVqOhMCp2cpIbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DjJ5p9TGUmx8rE5W3tIX1ybrAWgqcO9RXE/FKVbAqYw=;
 b=QFd+dvGcyIrGVPkA/Iqu49qhx4g/T42VpI2bkgWTuk9ya+Vp3Y5+zAEgNi4EI1sr5nvBOkarakDe7PxaM+kpLcrrE5+ydl1UFDIoJ7q2yNUOhe5i30fFu+7uuS2HStI0cUIuad6aKAyNXBJuZUlSmekqgXrRzNpaseUTFxXi+GNhDRMXkTuKv6hI4Xr7ryU3ZvtcTiZSKsMEJeIRRxInJGKILJA1HlUDvwyRS00UXRotj/ty3RAbrR2CeYOvsSOukt6jpXyp1FjKUcbnQgpsZ8XU05kHs2vh472qq359q81Zrcnbg1LaJ7PVzjyW0QFzFHMRHxZ8xc9X1lFepo5KZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjJ5p9TGUmx8rE5W3tIX1ybrAWgqcO9RXE/FKVbAqYw=;
 b=s/9cvPhw7gKw0XK/KN+Y6vlh12kjUXCubPyJo1v0G/nhqDhyWbBr5ixVa80Jj7vMqlcAmf3zxjtU09Emifl1BMr4eK/YjmxSwGGEwdzDit7MLBrpkRGwnOSLE+R5+Zc9qFnfpZYjE90b8HZln4QOusvVjPgBYKLIyG6jefdIwhk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5221.namprd12.prod.outlook.com (2603:10b6:208:30b::9)
 by DS0PR12MB7725.namprd12.prod.outlook.com (2603:10b6:8:136::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 20:03:48 +0000
Received: from BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::1ec8:e20e:d9e4:4718]) by BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::1ec8:e20e:d9e4:4718%7]) with mapi id 15.20.6652.019; Wed, 2 Aug 2023
 20:03:48 +0000
Message-ID: <bdf548d1-84cb-6885-c4eb-cbb16c4a3e3b@amd.com>
Date:   Wed, 2 Aug 2023 15:03:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [Question] int3 instruction generates a #UD in SEV VM
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Sean Christopherson <seanjc@google.com>,
        Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-coco@lists.linux.dev
References: <8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn>
 <ZMfFaF2M6Vrh/QdW@google.com> <4ebb3e20-a043-8ad3-ef6c-f64c2443412c@amd.com>
 <544b7f95-4b34-654d-a57b-3791a6f4fd5f@mail.ustc.edu.cn>
 <ZMpEUVsv5hSmrcH8@iZuf6hx7901barev1c282cZ> <ZMphvF+0H9wHQr5B@google.com>
 <bbc52f40-2661-3fa2-8e09-bec772728812@amd.com>
 <7a4f3f59-1482-49c4-92b2-aa621e9b06b3@amd.com>
In-Reply-To: <7a4f3f59-1482-49c4-92b2-aa621e9b06b3@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0186.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::11) To BL1PR12MB5221.namprd12.prod.outlook.com
 (2603:10b6:208:30b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5221:EE_|DS0PR12MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a6226b0-f071-4426-5e84-08db9393959d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tjS5ceE4lElCQoV4kK8OfVQZFnGHXjG/CMtMribHhZO6XLrop61kvCExJTjjRYsd2vb9JJF7TnvoTtn+h5lyDOiQhFHTTwOd+9sMIAU/Jy9HkrM6TUJz7byngQIPEJrPUnL7fN3aE9dvqSVVYNg/HXemPkOd5VPb9iWPFLVLMBMuWuBm6OktyvrSZ5qKBYfYkIEAWW0XopBK7lHgUqGIYe+/bnwVEfOVPglvbXDntdAd87DFEbhyxWP8sFDyyo5soTLd0Jo6L581aeYnxp9II08cslXhml4sndqiz1WM24okhgVpg8V9TZME7zkIOGaXuLHkUO+uNrl7WOewn1cd8i1z73WsOKJykFwNVLmOEkAKb6xwyHWlEfnoRUFUX2rBFyH3/xUdbJ3+6dGDEcz9lABsryhAZA3rNG4Yswa3vGIN9NIHj4jvip0wgJ3AmiZE3ZH1gR4PhzyRN0rO0KIyI6hD2E7iHYt/JhJdehypCi7imo1PH9UTDMxmAgik2e9tMmhPZ+gevguZCafZLPozej7qI6y2rWVcxKKMtuDn1KZ2xV0TU4HykRk/alUoOalX7rllh5gQlGR5HsAHWt5nPSTLfwYhZya0GN/6R4QtwPLvYQPykF/wpqOgHnCgeRrg1UgS3hr1FdeXASqdd2b+Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5221.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(451199021)(8936002)(5660300002)(31686004)(8676002)(41300700001)(316002)(66556008)(4326008)(66476007)(2906002)(66946007)(478600001)(38100700002)(6506007)(53546011)(26005)(2616005)(110136005)(83380400001)(6512007)(6486002)(86362001)(6666004)(31696002)(186003)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VElWU3F3U2dXOGI1dkRwK0p2M1FNeFRyUHRMQ3FBYnVYQm95RnVkRFhGZENU?=
 =?utf-8?B?M2Z3YnVQWm1PbC8vV3FvcHFSU0RncEZPS2Q3ek4yWkd0eGdLeGUreFNjcSs1?=
 =?utf-8?B?bjBLRUhWTzBMY0dVQ2FFVHFINE9hRXhVemhDdGdRbW8rOFZyQzNWdGdBQU4y?=
 =?utf-8?B?OWliTGp3YndMMHdWUUdINkI1SE90NGhtMHJNS3o5R1o5WGRHMGVTVjFhR1RK?=
 =?utf-8?B?bVMvK2ZCR3lvM3BnNU9OM0M0b1E4NS9FUmxzOU1DZjFQSWJ3SnVxY2hRU0hG?=
 =?utf-8?B?cXczSVl1MG1oNHJaeFNnZUZOOHNMYXVmb3BRWHlqeWwrb3BTVHZXa0ZhN0VB?=
 =?utf-8?B?THhIM2FCTDc2ZWhzUTd1THpEM05WR1BsbE5BU3VRNVRHbXFpZzhMbGw3MmMz?=
 =?utf-8?B?SThOZVJxdHNUWGhad2ZaZUdtTGk4ZCtabnVKRW9zZVlwdEVDMTcxeXpYU3JV?=
 =?utf-8?B?MFdUWUxXN2Zobnh1eFIyc2pObjYzUE8ydFdaZEMvQVdmcXF3Y0lJZzcyTStI?=
 =?utf-8?B?OVBVa0h0cURzWWJmb1NHSTJ2RkRIdHFINUFlU0gvZUp1QlV0SU9sVTE0SjhN?=
 =?utf-8?B?dWQ0S0lwdDhsVDR5N2xpejJVcDRWK1krbGJDRTVrTDBHdHlUT3JqTjUrVWRX?=
 =?utf-8?B?SmFWWW1UWkFEdHFaakJLL055OUFoSnNqSHZ2UmEya2xpUTB4bmJJYWpNNnd3?=
 =?utf-8?B?YzIrSFdiNlhSaDYxdWdEd0Z0UXJDRDAvdmc0Nzc5b3VheHNiZHIyNXBxVzhZ?=
 =?utf-8?B?VndydmJWM3kvdmhSVkNJT2wzNUhESXpTa2xEbDA4R0RtdlVXMlRqdkwrc1FD?=
 =?utf-8?B?VjU5SmUwOUhFZktIMk9xVnFJREJraVU0VmZINHRxaVB0MU5FcDJzRE9zYUhE?=
 =?utf-8?B?Yjd0ZjRqK0h1V1U3MmwzallwYmw2ZUhtZFo3NGJxRUoraVFzT2FIL3p3WGNL?=
 =?utf-8?B?WUhpM3NvSXFaUXlGaWRCZzRUUDZDclpYdTRQcUF0UWpzeTJvdlpSYjNWTE9L?=
 =?utf-8?B?Z0VFWStET1JmNDkyY1ZmbG9hNGJ5ZzNsd3liQkFlSjEvNFNZak8vQXhyWVBQ?=
 =?utf-8?B?OXJkVTJSSU5peFArSHMrd0c3NkFVaWFzSkRtZjN4MlNpVlA3Z3NmWDcvNXNJ?=
 =?utf-8?B?ZitlNzRkUlMwN3RLRTFLQWF4ME5xaFVqcjN4LzJteVdIWFE2aEppNGxMMTBG?=
 =?utf-8?B?NnBpNDBHYlZjbk1UL1JJNVJyTGdsa29EVUc5aks0WE9wSlQydHNTT3lOaEg5?=
 =?utf-8?B?U21vZWo0WEJzU3QzYUhjS3VWWlRHMEx3SFdKMy90cHV6YjZmc09PTUZ0Y3gr?=
 =?utf-8?B?eEFQNDRzVHdrYUN2V0QweGRpT1E4dkZmUnNxaU9zVWlHSGdYaVg3SElFeFVH?=
 =?utf-8?B?N0RuL1I2SXVsQ2QxN2dFRXo4THFuNktNN0VQM1VwZzZBeWJLMC9lQzc3RXRr?=
 =?utf-8?B?S1N5Z2J4WTJBZ08wb2NNc250eHdBVDA1MVlIb3hSZjNDdjdYOFJJblphTWFN?=
 =?utf-8?B?bDUrVG5hc1JSbUUrU2RjUlhvellSSlcxSWhrN2ZDL1J3VnJHZ1U5TWd3N2My?=
 =?utf-8?B?RmMxOXBONzFaQyswVXhwcFZOeE5tVDZVMlEwMTRiTHAzK29adnFxVms3Wm1o?=
 =?utf-8?B?UHFxZ1pXbUtoN2RpZDZkUUJ0UExZS3dJT3ZmaW0wU0pnakpTQ21yK2U0bU9T?=
 =?utf-8?B?T2M5NThKSldYSXZ2SGNtOGNKTWpQUUsxeXJJL1M2YThyVENJUmFZNERtQ043?=
 =?utf-8?B?Rjdwb3VIUGdhaTZFUWJZQ2phZEx2SDlWUzJGSk5zQzlPa3lDM2lDekZ1Zjl6?=
 =?utf-8?B?WnpIZitqcUp2V1JaQ1F2dFhFZk1LT1VtdzByaTE5dmQzcEpaa09MRnkwazVi?=
 =?utf-8?B?QmhzaW11Q1dMOTRaNnFUeTNBcGpCK24vTXRnZ2JWOVc0R0tiZXJickZaTlhV?=
 =?utf-8?B?U1BlTkZNeHdJR0VrV1l1UFlkSFh3dU9UVXVWVzF2eW1TdW1DTURRZUJmT29C?=
 =?utf-8?B?U2tncU5ZdENWR1I2NjhrZll0dTlCMmUyaSs1NHFPL0MralpacEFMK3oxZEQr?=
 =?utf-8?B?T25NVkZ4eHRUUmpnWXl3aHN3QVN1citiMnZ0V0xmMllrNGNxS29DS2FjQml5?=
 =?utf-8?Q?a/LZTi9g6fpWpYQ2PoUWk4say?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a6226b0-f071-4426-5e84-08db9393959d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5221.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 20:03:48.5947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bL6qMo1pKg1J1591rrC4YKhrwlIzKGRz28oygNiKc6hTHVqEQpFIHSfQD/wcTs0LU9Z5VZybHjJbIcXKBSlGKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7725
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/2/23 09:33, Tom Lendacky wrote:
> On 8/2/23 09:25, Tom Lendacky wrote:
>> On 8/2/23 09:01, Sean Christopherson wrote:
>>> On Wed, Aug 02, 2023, Wu Zongyo wrote:
>>>> On Mon, Jul 31, 2023 at 11:45:29PM +0800, wuzongyong wrote:
>>>>>
>>>>> On 2023/7/31 23:03, Tom Lendacky wrote:
>>>>>> On 7/31/23 09:30, Sean Christopherson wrote:
>>>>>>> On Sat, Jul 29, 2023, wuzongyong wrote:
>>>>>>>> Hi,
>>>>>>>> I am writing a firmware in Rust to support SEV based on project 
>>>>>>>> td-shim[1].
>>>>>>>> But when I create a SEV VM (just SEV, no SEV-ES and no SEV-SNP) 
>>>>>>>> with the firmware,
>>>>>>>> the linux kernel crashed because the int3 instruction in 
>>>>>>>> int3_selftest() cause a
>>>>>>>> #UD.
>>>>>>>
>>>>>>> ...
>>>>>>>
>>>>>>>> BTW, if a create a normal VM without SEV by qemu & OVMF, the int3 
>>>>>>>> instruction always generates a
>>>>>>>> #BP.
>>>>>>>> So I am confused now about the behaviour of int3 instruction, 
>>>>>>>> could anyone help to explain the behaviour?
>>>>>>>> Any suggestion is appreciated!
>>>>>>>
>>>>>>> Have you tried my suggestions from the other thread[*]?
>>>>> Firstly, I'm sorry for sending muliple mails with the same content. I 
>>>>> thought the mails I sent previously
>>>>> didn't be sent successfully.
>>>>> And let's talk the problem here.
>>>>>>>
>>>>>>>     : > > I'm curious how this happend. I cannot find any condition 
>>>>>>> that would
>>>>>>>     : > > cause the int3 instruction generate a #UD according to 
>>>>>>> the AMD's spec.
>>>>>>>     :
>>>>>>>     : One possibility is that the value from memory that gets 
>>>>>>> executed diverges from the
>>>>>>>     : value that is read out be the #UD handler, e.g. due to 
>>>>>>> patching (doesn't seem to
>>>>>>>     : be the case in this test), stale cache/tlb entries, etc.
>>>>>>>     :
>>>>>>>     : > > BTW, it worked nomarlly with qemu and ovmf.
>>>>>>>     : >
>>>>>>>     : > Does this happen every time you boot the guest with your 
>>>>>>> firmware? What
>>>>>>>     : > processor are you running on?
>>>>>>>     :
>>>>> Yes, every time.
>>>>> The processor I used is EPYC 7T83.
>>>>>>>     : And have you ruled out KVM as the culprit?  I.e. verified 
>>>>>>> that KVM is NOT injecting
>>>>>>>     : a #UD.  That obviously shouldn't happen, but it should be 
>>>>>>> easy to check via KVM
>>>>>>>     : tracepoints.
>>>>>>
>>>>>> I have a feeling that KVM is injecting the #UD, but it will take 
>>>>>> instrumenting KVM to see which path the #UD is being injected from.
>>>>>>
>>>>>> Wu Zongyo, can you add some instrumentation to figure that out if 
>>>>>> the trace points towards KVM injecting the #UD?
>>>>> Ok, I will try to do that.
>>>> You're right. The #UD is injected by KVM.
>>>>
>>>> The path I found is:
>>>>      svm_vcpu_run
>>>>          svm_complete_interrupts
>>>>         kvm_requeue_exception // vector = 3
>>>>             kvm_make_request
>>>>
>>>>      vcpu_enter_guest
>>>>          kvm_check_and_inject_events
>>>>         svm_inject_exception
>>>>             svm_update_soft_interrupt_rip
>>>>             __svm_skip_emulated_instruction
>>>>                 x86_emulate_instruction
>>>>                 svm_can_emulate_instruction
>>>>                     kvm_queue_exception(vcpu, UD_VECTOR)
>>>>
>>>> Does this mean a #PF intercept occur when the guest try to deliver a
>>>> #BP through the IDT? But why?
>>>
>>> I doubt it's a #PF.  A #NPF is much more likely, though it could be 
>>> something
>>> else entirely, but I'm pretty sure that would require bugs in both the 
>>> host and
>>> guest.
>>>
>>> What is the last exit recorded by trace_kvm_exit() before the #UD is 
>>> injected?
>>
>> I'm guessing it was a #NPF, too. Could it be related to the changes that
>> went in around svm_update_soft_interrupt_rip()?
>>
>> 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the 
>> instruction")
> 
> Sorry, that should have been:
> 
> 7e5b5ef8dca3 ("KVM: SVM: Re-inject INTn instead of retrying the insn on 
> "failure"")

Doh! I was right the first time... sigh

6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")

Thanks,
Tom

> 
>>
>> Before this the !nrips check would prevent the call into
>> svm_skip_emulated_instruction(). But now, there is a call to:
>>
>>    svm_update_soft_interrupt_rip()
>>      __svm_skip_emulated_instruction()
>>        kvm_emulate_instruction()
>>          x86_emulate_instruction() (passed a NULL insn pointer)
>>            kvm_can_emulate_insn() (passed a NULL insn pointer)
>>              svm_can_emulate_instruction() (passed NULL insn pointer)
>>
>> Because it is an SEV guest, it ends up in the "if (unlikely(!insn))" path
>> and injects the #UD.
>>
>> Thanks,
>> Tom
>>
