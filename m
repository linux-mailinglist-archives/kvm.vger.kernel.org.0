Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A3D4E5937
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 20:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344257AbiCWThD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 15:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240360AbiCWThB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 15:37:01 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4082389090
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 12:35:31 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id j13so2523939plj.8
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 12:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=F6VQICfczGm1sue/vFHPzsvWiKqEFDk9fWNgINubBfo=;
        b=bU8+iQisuveM8eRN1jSh90kf+XpNJtVwa046++IScBAxQr3WXjZNmVkx7kVFum9NZe
         9gZ9KbaC/jL31/+/o62g/ZZaurZJ/Mr1fzP+Je6C56y7kgvfsieCHjyCHhy5HiImz0uJ
         eDmazWbgMxMHiJxDxvnsug89MRPlPAtEudA3mh6kleIQbA8BGxAzcP+WEQ0poA9Z4k/s
         UN8eTZn135JFIkoOTmUx8rzh3+DoiDS++cHRLlMbARIn3v6A1ZIrMCO0ANuzG/P3mH+A
         q4ABJTvJ2aa9c32bTtdV+kEscesli8y6O7sXQIz0pwApjfsqnT6oTaQOYDdJ5cyucu7j
         wDaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F6VQICfczGm1sue/vFHPzsvWiKqEFDk9fWNgINubBfo=;
        b=vgOcFjUPpvt+VCebvXV5Teg9spl3HuEp8yeRNfBwC67somja3Op5MIEzYHL1yJemje
         2biHjpnK55szkm/IKEcSiAuh+NRDaFlJQU0vmmfT/qOihEbbM7WmCf3boX8wZpIS5sHv
         HwIxdmdIXLpUziE2es16u09R0S1DHL6CB5eP7Pj0fbwPwm9mvsAeApARROgVRxluGbid
         ZCcNcB4Y6IvbXPtPdi8hvR9HJ+OMjJFSncUVMUHj4N+6aatlqTB98tfBZfajBIl96Eg9
         uPBKTvCtwDKTp08qHtrtvmBgJ9UB0FnJDdrVnj6VyHsZ/SyFYDqGPd+DXDovOyARLmEe
         M7HA==
X-Gm-Message-State: AOAM5315/Q8JjEbfe8uqHAf5qg5W8JzrpvUdiLFGngj9qEAz6I661r6S
        sxI2DONra3oeuzJcnjM9B0VPrg==
X-Google-Smtp-Source: ABdhPJzelN7gfHOLXenSApvK4Gj0XG9iKRQK9rfNN6cDos7SP89vxRz72QGQHykUIIvfNTq3iDIW1w==
X-Received: by 2002:a17:90a:4890:b0:1bf:654e:e1a0 with SMTP id b16-20020a17090a489000b001bf654ee1a0mr13622867pjh.113.1648064130264;
        Wed, 23 Mar 2022 12:35:30 -0700 (PDT)
Received: from ?IPV6:2600:1700:38d4:55df:aed0:ee00:7944:65f6? ([2600:1700:38d4:55df:aed0:ee00:7944:65f6])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f70d5e92basm672522pfx.34.2022.03.23.12.35.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 12:35:29 -0700 (PDT)
Message-ID: <a23e32d3-9738-278b-42d3-5fe45cfab721@google.com>
Date:   Wed, 23 Mar 2022 12:35:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [RFC PATCH 00/47] Address Space Isolation for KVM
Content-Language: en-US
To:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, rppt@linux.ibm.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, luto@kernel.org, linux-mm@kvack.org
References: <20220223052223.1202152-1-junaids@google.com>
 <91dd5f0a-61da-074d-42ed-bf0886f617d9@oracle.com>
 <a37bb4b7-3772-4579-a4e6-d27fb29411a6@google.com>
 <c3131f1c-a354-ca3b-ed61-5b06ef1ab7a1@oracle.com>
From:   Junaid Shahid <junaids@google.com>
In-Reply-To: <c3131f1c-a354-ca3b-ed61-5b06ef1ab7a1@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/22 02:46, Alexandre Chartre wrote:
> 
> On 3/18/22 00:25, Junaid Shahid wrote:
>>
>> I agree that it is not secure to run one sibling in the unrestricted
>> kernel address space while the other sibling is running in an ASI
>> restricted address space, without doing a cache flush before
>> re-entering the VM. However, I think that avoiding this situation
>> does not require doing a sibling stun operation immediately after VM
>> Exit. The way we avoid it is as follows.
>>
>> First, we always use ASI in conjunction with core scheduling. This
>> means that if HT0 is running a VCPU thread, then HT1 will be running
>> either a VCPU thread of the same VM or the Idle thread. If it is
>> running a VCPU thread, then if/when that thread takes a VM Exit, it
>> will also be running in the same ASI restricted address space. For
>> the idle thread, we have created another ASI Class, called Idle-ASI,
>> which maps only globally non-sensitive kernel memory. The idle loop
>> enters this ASI address space.
>>
>> This means that when HT0 does a VM Exit, HT1 will either be running
>> the guest code of a VCPU of the same VM, or it will be running kernel
>> code in either a KVM-ASI or the Idle-ASI address space. (If HT1 is
>> already running in the full kernel address space, that would imply
>> that it had previously done an ASI Exit, which would have triggered a
>> stun_sibling, which would have already caused HT0 to exit the VM and
>> wait in the kernel).
> 
> Note that using core scheduling (or not) is a detail, what is important
> is whether HT are running with ASI or not. Running core scheduling will
> just improve chances to have all siblings run ASI at the same time
> and so improve ASI performances.
> 
> 
>> If HT1 now does an ASI Exit, that will trigger the stun_sibling()
>> operation in its pre_asi_exit() handler, which will set the state of
>> the core/HT0 to Stunned (and possibly send an IPI too, though that
>> will be ignored if HT0 was already in kernel mode). Now when HT0
>> tries to re-enter the VM, since its state is set to Stunned, it will
>> just wait in a loop until HT1 does an unstun_sibling() operation,
>> which it will do in its post_asi_enter handler the next time it does
>> an ASI Enter (which would be either just before VM Enter if it was
>> KVM-ASI, or in the next iteration of the idle loop if it was
>> Idle-ASI). In either case, HT1's post_asi_enter() handler would also
>> do a flush_sensitive_cpu_state operation before the unstun_sibling(),
>> so when HT0 gets out of its wait-loop and does a VM Enter, there will
>> not be any sensitive state left.
>>
>> One thing that probably was not clear from the patch, is that the
>> stun state check and wait-loop is still always executed before VM
>> Enter, even if no ASI Exit happened in that execution.
>>
> 
> So if I understand correctly, you have following sequence:
> 
> 0 - Initially state is set to "stunned" for all cpus (i.e. a cpu should
>      wait before VMEnter)
> 
> 1 - After ASI Enter: Set sibling state to "unstunned" (i.e. sibling can
>      do VMEnter)
> 
> 2 - Before VMEnter : wait while my state is "stunned"
> 
> 3 - Before ASI Exit : Set sibling state to "stunned" (i.e. sibling should
>      wait before VMEnter)
> 
> I have tried this kind of implementation, and the problem is with step 2
> (wait while my state is "stunned"); how do you wait exactly? You can't
> just do an active wait otherwise you have all kind of problems (depending
> if you have interrupts enabled or not) especially as you don't know how
> long you have to wait for (this depends on what the other cpu is doing).

In our stunning implementation, we do an active wait with interrupts enabled and with a need_resched() check to decide when to bail out to the scheduler (plus we also make sure that we re-enter ASI at the end of the wait in case some interrupt exited ASI). What kind of problems have you run into with an active wait, besides wasted CPU cycles?

In any case, the specific stunning mechanism is orthogonal to ASI. This implementation of ASI can be integrated with different stunning implementations. The "kernel core scheduling" that you proposed is also an alternative to stunning and could be similarly integrated with ASI.

> 
> That's why I have been dissociating ASI and cpu stunning (and eventually
> move to only do kernel core scheduling). Basically I replaced step 2 by
> a call to the scheduler to select threads using ASI on all siblings (or
> run something else if there's higher priority threads to run) which means
> enabling kernel core scheduling at this point.
> 
>>>
>>> A Possible Alternative to ASI?
>>> =============================
>>> ASI prevents access to sensitive data by unmapping them. On the other
>>> hand, the KVM code somewhat already identifies access to sensitive data
>>> as part of the L1TF/MDS mitigation, and when KVM is about to access
>>> sensitive data then it sets l1tf_flush_l1d to true (so that L1D gets
>>> flushed before VMEnter).
>>>
>>> With KVM knowing when it accesses sensitive data, I think we can provide
>>> the same mitigation as ASI by simply allowing KVM code which doesn't
>>> access sensitive data to be run concurrently with a VM. This can be done
>>> by tagging the kernel thread when it enters KVM code which doesn't
>>> access sensitive data, and untagging the thread right before it accesses
>>> sensitive data. And when KVM is about to do a VMEnter then we synchronize
>>> siblings CPUs so that they run threads with the same tag. Sounds familar?
>>> Yes, because that's similar to core scheduling but inside the kernel
>>> (let's call it "kernel core scheduling").
>>>
>>> I think the benefit of this approach would be that it should be much
>>> simpler to implement and less invasive than ASI, and it doesn't preclude
>>> to later do ASI: ASI can be done in addition and provide an extra level
>>> of mitigation in case some sensitive is still accessed by KVM. Also it
>>> would provide the critical sibling CPU synchronization mechanism that
>>> we also need with ASI.
>>>
>>> I did some prototyping to implement this kernel core scheduling a while
>>> ago (and then get diverted on other stuff) but so far performances have
>>> been abyssal especially when doing a strict synchronization between
>>> sibling CPUs. I am planning go back and do more investigations when I
>>> have cycles but probably not that soon.
>>>
>>
>> This also seems like an interesting approach. It does have some
>> different trade-offs compared to ASI. First, there is the trade-off
>> between a blacklist vs. whitelist approach. Secondly, ASI has a more
>> structured approach based on the sensitivity of the data itself,
>> instead of having to audit every new code path to verify whether or
>> not it can potentially access any sensitive data. On the other hand,
>> as you point out, this approach is much simpler than ASI, which is
>> certainly a plus.
> 
> I think the main benefit is that it provides a mechanism for running
> specific kernel threads together on sibling cpus independently of ASI.
> So it will be easier to implement (you don't need ASI) and to test.
> 

It would be interesting to see the performance characteristics of this approach compared to stunning. I think it would really depend on how long do we typically end up staying in the full kernel address space when running VCPUs.

Note that stunning can also be implemented independently of ASI by integrating it with the same conditional L1TF mitigation mechanism (l1tf_flush_l1d) that currently exists in KVM. The way I see it, this kernel core scheduling is an alternative to stunning, regardless of whether we integrate it with ASI or with the existing conditional mitigation mechanism.

> Then, once this mechanism has proven to work (and to be efficient),
> you can have KVM ASI use it.
> 

Yes, if this mechanism seems to work better than stunning, then we could certainly integrate this with ASI. Though it is possible that we may end up needing ASI to get to the "efficient" part.

Thanks,
Junaid
