Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70DB17658F5
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 18:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjG0QlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 12:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjG0Qk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 12:40:58 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6EDA13598;
        Thu, 27 Jul 2023 09:40:36 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD37CD75;
        Thu, 27 Jul 2023 09:41:18 -0700 (PDT)
Received: from [10.57.89.117] (unknown [10.57.89.117])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 716303F5A1;
        Thu, 27 Jul 2023 09:40:32 -0700 (PDT)
Message-ID: <1cb495f2-fb0d-5a93-5a7f-d717bf3ef97a@arm.com>
Date:   Thu, 27 Jul 2023 17:40:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [Question - ARM CCA] vCPU Hotplug Support in ARM Realm world
 might require ARM spec change?
To:     Salil Mehta <salil.mehta@huawei.com>,
        "steven.price@arm.com" <steven.price@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Salil Mehta <salil.mehta@opnsrc.net>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        yuzenghui <yuzenghui@huawei.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Gareth Stockwell <Gareth.Stockwell@arm.com>
References: <9cb24131a09a48e9a622e92bf8346c9d@huawei.com>
 <7da93c6e-1cbf-8840-282e-f115197b80c4@arm.com>
 <0d268afa-c04b-7a4e-be5e-2362d3dfa64d@arm.com>
 <93c9c8356e444fb287393a935a8c7899@huawei.com>
 <8a828ef2-b09b-4322-26fa-eae6cc88753f@arm.com>
 <ef506b02d6774a7d87f6b2d941427333@huawei.com>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ef506b02d6774a7d87f6b2d941427333@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/07/2023 15:24, Salil Mehta wrote:
> Hi Suzuki,
> 
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Sent: Tuesday, July 25, 2023 12:20 PM
>>
>> Hi Salil
>>
>> On 25/07/2023 01:05, Salil Mehta wrote:
>>> Hi Suzuki,
>>> Sorry for replying late as I was on/off last week to undergo some medical test.
>>>
>>>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>> Sent: Monday, July 24, 2023 5:27 PM
>>>>
>>>> Hi Salil
>>>>
>>>> On 19/07/2023 10:28, Suzuki K Poulose wrote:
>>>>> Hi Salil
>>>>>
>>>>> Thanks for raising this.
>>>>>
>>>>> On 19/07/2023 03:35, Salil Mehta wrote:
>>>>>> [Reposting it here from Linaro Open Discussion List for more eyes to look at]
>>>>>>
>>>>>> Hello,
>>>>>> I have recently started to dabble with ARM CCA stuff and check if our
>>>>>> recent changes to support vCPU Hotplug in ARM64 can work in the realm
>>>>>> world. I have realized that in the RMM specification[1] PSCI_CPU_ON
>>>>>> command(B5.3.3) does not handles the PSCI_DENIED return code(B5.4.2),
>>>>>> from the host. This might be required to support vCPU Hotplug feature
>>>>>> in the realm world in future. vCPU Hotplug is an important feature to
>>>>>> support kata-containers in realm world as it reduces the VM boot time
>>>>>> and facilitates dynamic adjustment of vCPUs (which I think should be
>>>>>> true even with Realm world as current implementation only makes use
>>>>>> of the PSCI_ON/OFF to realize the Hotplug look-like effect?)
>>>>>>
>>>>>>
>>>>>> As per our recent changes [2], [3] related to support vCPU Hotplug on
>>>>>> ARM64, we handle the guest exits due to SMC/HVC Hypercall in the
>>>>>> user-space i.e. VMM/Qemu. In realm world, REC Exits to host due to
>>>>>> PSCI_CPU_ON should undergo similar policy checks and I think,
>>>>>>
>>>>>> 1. Host should *deny* to online the target vCPUs which are NOT plugged
>>>>>> 2. This means target REC should be denied by host. Can host call
>>>>>>       RMI_PSCI_COMPETE in such s case?
>>>>>> 3. The *return* value (B5.3.3.1.3 Output values) should be PSCI_DENIED
>>>>>
>>>>> The Realm exit with EXIT_PSCI already provides the parameters passed
>>>>> onto the PSCI request. This happens for all PSCI calls except
>>>>> (PSCI_VERSION and PSCI_FEAUTRES). The hyp could forward these exits to
>>>>> the VMM and could invoke the RMI_PSCI_COMPLETE only when the VMM blesses
>>>>> the request (wherever applicable).
>>>>>
>>>>> However, the RMM spec currently doesn't allow denying the request.
>>>>> i.e., without RMI_PSCI_COMPLETE, the REC cannot be scheduled back in.
>>>>> We will address this in the RMM spec and get back to you.
>>>>
>>>> This is now resolved in RMMv1.0-eac3 spec, available here [0].
>>>>
>>>> This allows the host to DENY a PSCI_CPU_ON request. The RMM ensures that
>>>> the response doesn't violate the security guarantees by checking the
>>>> state of the target REC.
>>>>
>>>> [0] https://developer.arm.com/documentation/den0137/latest/
>>>
>>>
>>> Many thanks for taking this up proactively and getting it done as well
>>> very efficiently. Really appreciate this!
>>>
>>> I acknowledge below new changes part of the newly released RMM
>>> Specification [3] (Page-2) (Release Information 1.0-eac3 20-07-2023):
>>>
>>> 1. Addition of B2.19 PsciReturnCodePermitted function [3] (Page-126)
>>> 2. Addition of 'status' in B3.3.7.2 Failure conditions of the
>>>      B3.3.7 RMI_PSCI_COMPLETE command [3] (Page-160)
>>>
>>>
>>> Some Further Suggestions:
>>> 1. It would be really helpful if PSCI_DENIED can be accommodated somewhere
>>>      in the flow diagram (D1.4.1 PSCI_CPU_ON flow) [3] (Page-297) as well.
>>
>> Good point, yes, will get that added.
> 
> 
> Great. Thanks!
> 
> 
>>> 2. You would need changes to handle the return value of the PSCI_DENIED
>>>      in this below patch [2] as well from ARM CCA series [1]
>>>
>>
>> Of course. Please note that the series [1] is based on RMMv1.0-beta0 and
>> we are in the process of rebasing our changes to v1.0-eac3, which
>> includes a lot of other changes. The updated series will have all the
>> required changes.
> 
> 
> Ok. When are you planning to post this new series with v1.0-eac3 changes?

Please see :

https://lkml.kernel.org/r/42cbffac-05a8-a279-9bdb-f76354c1a1b1@arm.com

Suzuki

