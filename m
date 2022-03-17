Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F53C4DD123
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 00:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiCQX02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 19:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiCQX01 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 19:26:27 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D5728AC7B
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 16:25:09 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q11so5692740pln.11
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 16:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JmUCQVk4p0cql4Zp5v3fHTvJoVt4VmVRaNw9Ggc3AOk=;
        b=W6h6qL8S3g8afytfz20rv6rSCgPNASLmfu6fexAtiaRSoo2VJ2M3/5p4O9kcHWCIm8
         CBNWQVBFx8ahfSa/z0fnD8ZqgEOFe2IJr1e1EjXADZScIvbFE4pa5nokY2SaT/8/wrtx
         U3XHWem/Kvx/Q7JZmQJBQPajx/d91ZcIpg/w6rGXBDed+EUbZL0E/NsAOJvejZswCxvf
         YZweh0g39yeF66nNV6y1AXCLeID3Yhm3lFQB8KMPZhK4yvsZRlQZNwlJuY9G5lySbEOb
         nZzF1rbE5iRtTCk8pqFrl5hXfNidoJsgW3gjHW2GcSan71hc5KFTNi/2+hHUau8VWZWM
         +5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JmUCQVk4p0cql4Zp5v3fHTvJoVt4VmVRaNw9Ggc3AOk=;
        b=13wPbByOH1Voxd27pTCjd9kjtCnLmUZVL+Opkyefn6cBa9JuiYSZDKdhqi8yFap8hm
         H3+m+UEAdwvrriXNMtSqzL5eyU4vvw0I5IbFU7QtNK7l1kdCuYexlAIFZJgmnVCuhVce
         zwvvOAUBzXWf1ibB7WO5jlfEQGCIz9Xisv9pwmXaq169004ovxfPmj28obd9I29+8iih
         8upPjtiq0WBPV5AilNGCEqiDzczlMB9Q9nHqIFqtiBc0VwLRNDmse0/qHV9mDOf9TWzN
         3vjKGQDEsKk5Iy6MZVr9FwIr0CGXyyw6gWBJA0UlVM9n7KAAfnHUU7ns5zp1Pni+zG1j
         fp0g==
X-Gm-Message-State: AOAM5312PQHdq4UNJXGVy+tbYI6W7u+p41cVazrJYHO6QZT8z+WEOWed
        jcCIcNt8vX9eMP00zGLyl4shd/XhYJN21uDw6MA=
X-Google-Smtp-Source: ABdhPJzlMtDWWeTtXNzB4CxVuuhC16aWEKWXdrV4zLSspA09ZzbRfR7c0y+Xi6FADWZaGPxctgiSAg==
X-Received: by 2002:a17:90a:dd45:b0:1bc:9466:9b64 with SMTP id u5-20020a17090add4500b001bc94669b64mr18673989pjv.23.1647559508482;
        Thu, 17 Mar 2022 16:25:08 -0700 (PDT)
Received: from ?IPV6:2600:1700:38d4:55df:8747:480:f0df:4c1a? ([2600:1700:38d4:55df:8747:480:f0df:4c1a])
        by smtp.gmail.com with ESMTPSA id p15-20020a056a000b4f00b004f7b71f8bd6sm7892507pfo.47.2022.03.17.16.25.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 16:25:07 -0700 (PDT)
Message-ID: <a37bb4b7-3772-4579-a4e6-d27fb29411a6@google.com>
Date:   Thu, 17 Mar 2022 16:25:05 -0700
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
From:   Junaid Shahid <junaids@google.com>
In-Reply-To: <91dd5f0a-61da-074d-42ed-bf0886f617d9@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 3/16/22 14:34, Alexandre Chartre wrote:
> 
> Hi Junaid,
> 
> On 2/23/22 06:21, Junaid Shahid wrote:
>> This patch series is a proof-of-concept RFC for an end-to-end implementation of
>> Address Space Isolation for KVM. It has similar goals and a somewhat similar
>> high-level design as the original ASI patches from Alexandre Chartre
>> ([1],[2],[3],[4]), but with a different underlying implementation. This also
>> includes several memory management changes to help with differentiating between
>> sensitive and non-sensitive memory and mapping of non-sensitive memory into the
>> ASI restricted address spaces.
>>
>> This RFC is intended as a demonstration of what a full ASI implementation for
>> KVM could look like, not necessarily as a direct proposal for what might
>> eventually be merged. In particular, these patches do not yet implement KPTI on
>> top of ASI, although the framework is generic enough to be able to support it.
>> Similarly, these patches do not include non-sensitive annotations for data
>> structures that did not get frequently accessed during execution of our test
>> workloads, but the framework is designed such that new non-sensitive memory
>> annotations can be added trivially.
>>
>> The patches apply on top of Linux v5.16. These patches are also available via
>> gerrit at https://linux-review.googlesource.com/q/topic:asi-rfc.
>>
> Sorry for the late answer, and thanks for investigating possible ASI
> implementations. I have to admit I put ASI on the back-burner for
> a while because I am more and more wondering if the complexity of
> ASI is worth the benefit, especially given challenges to effectively
> exploit flaws that ASI is expected to mitigate, in particular when VMs
> are running on dedicated cpu cores, or when core scheduling is used.
> So I have been looking at a more simplistic approach (see below, A
> Possible Alternative to ASI).
> 
> But first, your implementation confirms that KVM-ASI can be broken up
> into different parts: pagetable management, ASI core and sibling cpus
> synchronization.
> 
> Pagetable Management
> ====================
> For ASI, we need to build a pagetable with a subset of the kernel
> pagetable mappings. Your solution is interesting as it is provides
> a broad solution and also works well with dynamic allocations (while
> my approach to copy mappings had several limitations). The drawback
> is the extend of your changes which spread over all the mm code
> (while the simple solution to copy mappings can be done with a few
> self-contained independent functions).
> 
> ASI Core
> ========
> 
> KPTI
> ----
> Implementing KPTI with ASI is possible but this is not straight forward.
> This requires some special handling in particular in the assembly kernel
> entry/exit code for syscall, interrupt and exception (see ASI RFC v4 [4]
> as an example) because we are also switching privilege level in addition
> of switching the pagetable. So this might be something to consider early
> in your implementation to ensure it is effectively compatible with KPTI.

Yes, I will look in more detail into how to implement KPTI on top of this ASI implementation, but at least at a high level, it seems that it should work. Of course, the devil is always in the details :)

> 
> Going beyond KPTI (with a KPTI-next) and trying to execute most
> syscalls/interrupts without switching to the full kernel address space
> is more challenging, because it would require much more kernel mapping
> in the user pagetable, and this would basically defeat the purpose of
> KPTI. You can refer to discussions about the RFC to defer CR3 switch
> to C code [7] which was an attempt to just reach the kernel entry C
> code with a KPTI pagetable.

In principle, the ASI restricted address space would not contain any sensitive data, so having more mappings should be ok as long as they really are non-sensitive. Of course, it is possible that we may mistakenly think that some data is not sensitive and mark it as such, but in reality it really was sensitive in some way. In that sense, a strict KPTI is certainly a little more secure than the KPTI-Next that I mentioned, but KPTI-Next would also have lower performance overhead compared to the strict KPTI.

> 
> Interrupts/Exceptions
> ---------------------
> As long as interrupts/exceptions are not expected to be processed with
> ASI, it is probably better to explicitly exit ASI before processing an
> interrupt/exception, otherwise you will have an extra overhead on each
> interrupt/exception to take a page fault and then exit ASI.

I agree that for those interrupts/exceptions that will need to access sensitive data, it is better to do an explicit ASI Exit at the start. But it is probably possible for many interrupts to be handled without needing to access sensitive data, in which case, it would be better to avoid the ASI Exit.

> 
> This is particularily true if you have want to have KPTI use ASI, and
> in that case the ASI exit will need to be done early in the interrupt
> and exception assembly entry code.
> 
> ASI Hooks
> ---------
> ASI hooks are certainly a good idea to perform specific actions on ASI
> enter or exit. However, I am not sure they are appropriate places for cpus
> stunning with KVM-ASI. That's because cpus stunning doesn't need to be
> done precisely when entering and exiting ASI, and it probably shouldn't be
> done there: it should be done right before VMEnter and right after VMExit
> (see below).
> 

I believe that performing sibling CPU stunning right after VM Exit will negate most of the performance advantage of ASI. I think that it is feasible to do the stunning on ASI Exit. Please see below for how we handle the problem that you have mentioned.


> Sibling CPUs Synchronization
> ============================
> KVM-ASI requires the synchronization of sibling CPUs from the same CPU
> core so that when a VM is running then sibling CPUs are running with the
> ASI associated with this VM (or an ASI compatible with the VM, depending
> on how ASI is defined). That way the VM can only spy on data from ASI
> and won't be able to access any sensitive data.
> 
> So, right before entering a VM, KVM should ensures that sibling CPUs are
> using ASI. If a sibling CPU is not using ASI then KVM can either wait for
> that sibling to run ASI, or force it to use ASI (or to become idle).
> This behavior should be enforced as long as any sibling is running the
> VM. When all siblings are not running the VM then other siblings can run
> any code (using ASI or not).
> 
> I would be interesting to see the code you use to achieve this, because
> I don't get how this is achieved from the description of your sibling
> hyperthread stun and unstun mechanism.
> 
> Note that this synchronization is critical for ASI to work, in particular
> when entering the VM, we need to be absolutely sure that sibling CPUs are
> effectively using ASI. The core scheduling sibling stunning code you
> referenced [6] uses a mechanism which is fine for userspace synchronization
> (the delivery of the IPI forces the sibling to immediately enter the kernel)
> but this won't work for ASI as the delivery of the IPI won't guarantee that
> the sibling as enter ASI yet. I did some experiments that show that data
> will leak if siblings are not perfectly synchronized.

I agree that it is not secure to run one sibling in the unrestricted kernel address space while the other sibling is running in an ASI restricted address space, without doing a cache flush before re-entering the VM. However, I think that avoiding this situation does not require doing a sibling stun operation immediately after VM Exit. The way we avoid it is as follows.

First, we always use ASI in conjunction with core scheduling. This means that if HT0 is running a VCPU thread, then HT1 will be running either a VCPU thread of the same VM or the Idle thread. If it is running a VCPU thread, then if/when that thread takes a VM Exit, it will also be running in the same ASI restricted address space. For the idle thread, we have created another ASI Class, called Idle-ASI, which maps only globally non-sensitive kernel memory. The idle loop enters this ASI address space.

This means that when HT0 does a VM Exit, HT1 will either be running the guest code of a VCPU of the same VM, or it will be running kernel code in either a KVM-ASI or the Idle-ASI address space. (If HT1 is already running in the full kernel address space, that would imply that it had previously done an ASI Exit, which would have triggered a stun_sibling, which would have already caused HT0 to exit the VM and wait in the kernel).

If HT1 now does an ASI Exit, that will trigger the stun_sibling() operation in its pre_asi_exit() handler, which will set the state of the core/HT0 to Stunned (and possibly send an IPI too, though that will be ignored if HT0 was already in kernel mode). Now when HT0 tries to re-enter the VM, since its state is set to Stunned, it will just wait in a loop until HT1 does an unstun_sibling() operation, which it will do in its post_asi_enter handler the next time it does an ASI Enter (which would be either just before VM Enter if it was KVM-ASI, or in the next iteration of the idle loop if it was Idle-ASI). In either case, HT1's post_asi_enter() handler would also do a flush_sensitive_cpu_state operation before the unstun_sibling(), so when HT0 gets out of its wait-loop and does a VM Enter, there will not be any sensitive state left.

One thing that probably was not clear from the patch, is that the stun state check and wait-loop is still always executed before VM Enter, even if no ASI Exit happened in that execution.

> 
> A Possible Alternative to ASI?
> =============================
> ASI prevents access to sensitive data by unmapping them. On the other
> hand, the KVM code somewhat already identifies access to sensitive data
> as part of the L1TF/MDS mitigation, and when KVM is about to access
> sensitive data then it sets l1tf_flush_l1d to true (so that L1D gets
> flushed before VMEnter).
> 
> With KVM knowing when it accesses sensitive data, I think we can provide
> the same mitigation as ASI by simply allowing KVM code which doesn't
> access sensitive data to be run concurrently with a VM. This can be done
> by tagging the kernel thread when it enters KVM code which doesn't
> access sensitive data, and untagging the thread right before it accesses
> sensitive data. And when KVM is about to do a VMEnter then we synchronize
> siblings CPUs so that they run threads with the same tag. Sounds familar?
> Yes, because that's similar to core scheduling but inside the kernel
> (let's call it "kernel core scheduling").
> 
> I think the benefit of this approach would be that it should be much
> simpler to implement and less invasive than ASI, and it doesn't preclude
> to later do ASI: ASI can be done in addition and provide an extra level
> of mitigation in case some sensitive is still accessed by KVM. Also it
> would provide the critical sibling CPU synchronization mechanism that
> we also need with ASI.
> 
> I did some prototyping to implement this kernel core scheduling a while
> ago (and then get diverted on other stuff) but so far performances have
> been abyssal especially when doing a strict synchronization between
> sibling CPUs. I am planning go back and do more investigations when I
> have cycles but probably not that soon.
> 

This also seems like an interesting approach. It does have some different trade-offs compared to ASI. First, there is the trade-off between a blacklist vs. whitelist approach. Secondly, ASI has a more structured approach based on the sensitivity of the data itself, instead of having to audit every new code path to verify whether or not it can potentially access any sensitive data. On the other hand, as you point out, this approach is much simpler than ASI, which is certainly a plus.

Thanks,
Junaid
