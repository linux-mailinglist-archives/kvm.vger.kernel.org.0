Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E664D6D0FCE
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 22:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjC3UPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 16:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjC3UPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 16:15:14 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458DDEFB2
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 13:15:10 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id h8so81288017ede.8
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 13:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680207308;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D7ChhDDaa5WWlb9EXJl+nkerhJSJjrpIcHobrR1EBBg=;
        b=M7VDGc84ubvP/5pQkUSml02h/gnQ5HfNfvtNDTM+mL3MOqp5PRHtv2J1ypmFIkLKqB
         PkoyQhJrD2KvFksWhFm3kwrCAV3Ru6ieU3vbaPL1Umjo0brT96NaQO2E2zb8EpVeMaZo
         AyDRifzFn/A7DLyoqrdGdJRTBdKX++6vVb3jFajlNOoFln4vjQVT3o//gIIdUCAmUHaw
         CZ+uRJ/Da7xw5f3zCGLuV3A88khp4bpl7qjNd2x43EkSQ9pnSypj9FDaChwGbwKFdTlD
         umxQaTdVmk/tYFb4s9T9wx6XXjoGdJ5rM0mYeKhJM51+u+xMwcb5IA+LJtVoU425xnhk
         6FNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680207308;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D7ChhDDaa5WWlb9EXJl+nkerhJSJjrpIcHobrR1EBBg=;
        b=Kemm0/WYDGWA1Qtj6+38NYC0Fu5fDb6AR1F5awpIWFN6YaV//BxQexlW+zrKAWZNgU
         I7MQBB3Q1XgRkfV0N5A5eF5thl0K47xprV1qeb41IoBr49sx5oVYHnCEKB74P1icjW2/
         F6otaau8FPXBGSFLyY2M751beruzOMJ9BB/XXhWJKLRokD+XqOhPZm5igvQGU8hwNrZq
         ACEh51XGnUmCuytEVCWRNDxH3s5x1t/waLWNvNP86GwY/nRK0ojJoR+SDnBHwiAarLDQ
         m3pCj0ww1Im39JjGV4l9yLmBNhuQTY+HbP9gAySlGTRS6VInhQCvJkd4Cz8votnX+KUQ
         RzUw==
X-Gm-Message-State: AAQBX9esIodexPVTo1611ldooj2nRlRfPmZdFtPgxNBgVklNgMZmsad3
        GkgfxwQ8aKNWOztSYaL7W6CGjhc60ZGsNx6tLX4=
X-Google-Smtp-Source: AKy350YUGmDPLZEBxGSPNyxgjfXA+eT8KTlp20Zp92vZuQoW4DmRlfA1m7Le1i2Cj3uJv2BV/6E4Jw==
X-Received: by 2002:a05:6402:1105:b0:502:2599:43ea with SMTP id u5-20020a056402110500b00502259943eamr20529342edv.31.1680207308550;
        Thu, 30 Mar 2023 13:15:08 -0700 (PDT)
Received: from ?IPV6:2003:f6:af13:8b00:c684:f698:a009:dbf2? ([2003:f6:af13:8b00:c684:f698:a009:dbf2])
        by smtp.gmail.com with ESMTPSA id q28-20020a50aa9c000000b005023aaf52desm297196edc.95.2023.03.30.13.15.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 13:15:07 -0700 (PDT)
Message-ID: <ea3a8fbc-2bf8-7442-e498-3e5818384c83@grsecurity.net>
Date:   Thu, 30 Mar 2023 22:15:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4 6/6] KVM: VMX: Make CR0.WP a guest owned bit
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <20230322013731.102955-7-minipli@grsecurity.net>
 <677169b4-051f-fcae-756b-9a3e1bb9f8fe@grsecurity.net>
 <ZCXDAiUOnsL3fRBj@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZCXDAiUOnsL3fRBj@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.03.23 19:12, Sean Christopherson wrote:
> On Thu, Mar 30, 2023, Mathias Krause wrote:
>> Just a heads up! We did more tests, especially with the backports we did
>> internally already, and ran into a bug when running a nested guest on an
>> ESXi host.
>>
>> Setup is like: ESXi (L0) -> Linux (L1) -> Linux (L2)
>>
>> The Linux system, especially the kernel, is the same for L1 and L2. It's
>> a grsecurity kernel, so makes use of toggling CR0.WP at runtime.
>>
>> The bug we see is that when L2 disables CR0.WP and tries to write to an
>> r/o memory region (implicitly to the r/o GDT via LTR in our use case),
>> this triggers a fault (EPT violation?) that gets ignored by L1, as,
>> apparently, everything is fine from its point of view.
> 
> It's not an EPT violation if there's a triple fault.  Given that you're dumping
> the VMCS from handle_triple_fault(), I assume that L2 gets an unexpected #PF that
> leads to a triple fault in L2.

Indeed it does, more on this below.

> 
> Just to make sure we're on the same page: L1 is still alive after this, correct?

Yes, L1 is still alive and doing fine.

>> I suspect the L0 VMM to be at fault here, as the VMCS structures look
>> good, IMO. Here is a dump of vmx->loaded_vmcs in handle_triple_fault():
> 
> ...
> 
>> The "host" (which is our L1 VMM, I guess) has CR0.WP enabled and that is
>> what I think confuses ESXi to enforce the read-only property to the L2
>> guest as well -- for unknown reasons so far.
> 
> ...
> 
>> I tried to reproduce the bug with different KVM based L0 VMMs (with and
>> without this series; vanilla and grsecurity kernels) but no luck. That's
>> why I'm suspecting a ESXi bug.
>    
> ...
> 
>> I'm leaning to make CR0.WP guest owned only iff we're running on bare
>> metal or the VMM is KVM to not play whack-a-mole for all the VMMs that
>> might have similar bugs. (Will try to test a few others here as well.)
>> However, that would prevent them from getting the performance gain, so
>> I'd rather have this fixed / worked around in KVM instead.
> 
> Before we start putting bandaids on this, let's (a) confirm this appears to be
> an issue with ESXi and (b) pull in VMware folks to get their input.
> 
>> Any ideas how to investigate this further?
> 
> Does the host in question support UMIP?

It should, but I've no access to the host. Within L1 I don't see umip
in /proc/cpuinfo. It's a "Intel(R) Xeon(R) Gold 6258R", though, so
Cascade Lake.

> 
> Can you capture a tracepoint log from L1 to verify that L1 KVM is _not_ injecting
> any kind of exception?  E.g. to get the KVM kitchen sink:
> 
>   echo 1 > /sys/kernel/debug/tracing/tracing_on
>   echo 1 > /sys/kernel/debug/tracing/events/kvm/enable
> 
>   cat /sys/kernel/debug/tracing/trace > log
> 
> Or if that's too noisy, a more targeted trace (exception injection + emulation)
> woud be:

I've even added 'echo 1 > /sys/kernel/tracing/events/kvmmmu/enable' to
the mix to get some more info and that leads to below (trimmed to the
part covering the error; L2 has 2 vCPUs bound to L1's vCPUs 1 and 2):

 qemu-system-x86-8397    [002] d....  1404.389366: kvm_exit: vcpu 1 reason CR_ACCESS rip 0xffffffff8100007a info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
 qemu-system-x86-8397    [002] .....  1404.389373: kvm_cr: cr_write 0 = 0x80050033

That's the initialization of L2's CR0 in secondary_startup_64() and
also the last CR0 write we'll see, as toggling CR0.WP won't generate a
VMEXIT because the bit is guest owned. So this is the value KVM will
cache as vcpu->arch.cr0.

 qemu-system-x86-8397    [002] .....  1404.389384: kvm_tdp_mmu_spte_changed: as id 0 gfn 0 level 4 old_spte 2c583e907 new_spte 0
 qemu-system-x86-8397    [002] .....  1404.389384: kvm_mmu_prepare_zap_page: sp gen 0 gfn 0 l3 8-byte q0 direct wux nxe ad root 0 sync
 qemu-system-x86-8397    [002] .....  1404.389386: kvm_tdp_mmu_spte_changed: as id 0 gfn 0 level 3 old_spte 2c583d907 new_spte 5a0
 qemu-system-x86-8397    [002] .....  1404.389386: kvm_mmu_prepare_zap_page: sp gen 0 gfn 0 l2 8-byte q0 direct wux nxe ad root 0 sync
 qemu-system-x86-8397    [002] .....  1404.389388: kvm_tdp_mmu_spte_changed: as id 0 gfn 0 level 2 old_spte 2c583c907 new_spte 5a0
 qemu-system-x86-8397    [002] .....  1404.389388: kvm_mmu_prepare_zap_page: sp gen 0 gfn 0 l1 8-byte q0 direct wux nxe ad root 0 sync
 qemu-system-x86-8397    [002] .....  1404.389391: kvm_tdp_mmu_spte_changed: as id 0 gfn 99 level 1 old_spte 600000455299b77 new_spte 5a0
 qemu-system-x86-8397    [002] .....  1404.389393: kvm_tdp_mmu_spte_changed: as id 0 gfn 9a level 1 old_spte 60000045529ab77 new_spte 5a0
 qemu-system-x86-8397    [002] .....  1404.389395: kvm_tdp_mmu_spte_changed: as id 0 gfn 9c level 1 old_spte 60000045529cb77 new_spte 5a0
 qemu-system-x86-8397    [002] .....  1404.389408: kvm_tdp_mmu_spte_changed: as id 0 gfn 9d level 1 old_spte 60000045529db77 new_spte 5a0
 qemu-system-x86-8397    [002] .....  1404.389411: kvm_tdp_mmu_spte_changed: as id 0 gfn 9e level 1 old_spte 60000045529eb77 new_spte 5a0
 qemu-system-x86-8396    [001] d....  1404.389421: kvm_exit: vcpu 0 reason EXTERNAL_INTERRUPT rip 0xffffffff8108aca7 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x800000fb error_code 0x00000000
 qemu-system-x86-8397    [002] .....  1404.389425: kvm_tdp_mmu_spte_changed: as id 0 gfn 1000 level 2 old_spte 2c583b907 new_spte 5a0
 qemu-system-x86-8397    [002] .....  1404.389425: kvm_mmu_prepare_zap_page: sp gen 0 gfn 1000 l1 8-byte q0 direct wux nxe ad root 0 sync
 qemu-system-x86-8397    [002] .....  1404.389427: kvm_tdp_mmu_spte_changed: as id 0 gfn 1000 level 1 old_spte 6000002c7c00b77 new_spte 5a0
 qemu-system-x86-8397    [002] .....  1404.389430: kvm_tdp_mmu_spte_changed: as id 0 gfn 2400 level 2 old_spte 60000021be00bf3 new_spte 5a0
 qemu-system-x86-8397    [002] .....  1404.389434: kvm_tdp_mmu_spte_changed: as id 0 gfn 2800 level 2 old_spte 60000021ba00bf3 new_spte 5a0
 qemu-system-x86-8396    [001] d....  1404.389435: kvm_entry: vcpu 0, rip 0xffffffff8108aca7
 qemu-system-x86-8397    [002] .....  1404.389436: kvm_tdp_mmu_spte_changed: as id 0 gfn 2a00 level 2 old_spte 60000021d400bf3 new_spte 5a0
 qemu-system-x86-8397    [002] .....  1404.389439: kvm_tdp_mmu_spte_changed: as id 0 gfn 2c00 level 2 old_spte 60000021d600bf3 new_spte 5a0
 qemu-system-x86-8396    [001] d....  1404.389448: kvm_exit: vcpu 0 reason EXTERNAL_INTERRUPT rip 0xffffffff8113b1f9 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x800000fb error_code 0x00000000
 qemu-system-x86-8396    [001] d....  1404.389456: kvm_entry: vcpu 0, rip 0xffffffff8113b1f9
 qemu-system-x86-8397    [002] d....  1404.389461: kvm_entry: vcpu 1, rip 0xffffffff8100007d
 qemu-system-x86-8396    [001] d....  1404.389462: kvm_exit: vcpu 0 reason EXTERNAL_INTERRUPT rip 0xffffffff8113b1f9 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x800000f6 error_code 0x00000000
 qemu-system-x86-8396    [001] d....  1404.389462: kvm_entry: vcpu 0, rip 0xffffffff8113b1f9
 qemu-system-x86-8397    [002] d....  1404.389481: kvm_exit: vcpu 1 reason CR_ACCESS rip 0xffffffff810000a0 info1 0x0000000000000104 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
 qemu-system-x86-8397    [002] .....  1404.389488: kvm_cr: cr_write 4 = 0xb0

Above is L2's init of CR4, still in secondary_startup_64().

 qemu-system-x86-8397    [002] d....  1404.389491: kvm_entry: vcpu 1, rip 0xffffffff810000a3
 qemu-system-x86-8397    [002] d....  1404.389501: kvm_exit: vcpu 1 reason CPUID rip 0xffffffff81000127 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
 qemu-system-x86-8397    [002] .....  1404.389501: kvm_cpuid: func 80000001 idx d3f0eef rax 50657 rbx 0 rcx 121 rdx 2c100800, cpuid entry found
 qemu-system-x86-8397    [002] d....  1404.389501: kvm_entry: vcpu 1, rip 0xffffffff81000129
 qemu-system-x86-8397    [002] d....  1404.389509: kvm_exit: vcpu 1 reason MSR_READ rip 0xffffffff81000130 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
 qemu-system-x86-8397    [002] .....  1404.389509: kvm_msr: msr_read c0000080 = 0xd01
 qemu-system-x86-8397    [002] d....  1404.389510: kvm_entry: vcpu 1, rip 0xffffffff81000132
 qemu-system-x86-8397    [002] d....  1404.389517: kvm_exit: vcpu 1 reason MSR_WRITE rip 0xffffffff81000149 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
 qemu-system-x86-8397    [002] .....  1404.389519: kvm_msr: msr_write c0000080 = 0xd01

That was the EFER setup...

 qemu-system-x86-8397    [002] d....  1404.389520: kvm_entry: vcpu 1, rip 0xffffffff8100014b
 qemu-system-x86-8397    [002] d....  1404.389536: kvm_exit: vcpu 1 reason CR_ACCESS rip 0xffffffff81053aee info1 0x0000000000000004 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
 qemu-system-x86-8397    [002] .....  1404.389537: kvm_cr: cr_write 4 = 0x3208b0

...remaining CR4 bits in cr4_init()...

 qemu-system-x86-8397    [002] d....  1404.389562: kvm_entry: vcpu 1, rip 0xffffffff81053af1
 qemu-system-x86-8397    [002] d....  1404.389574: kvm_exit: vcpu 1 reason EXTERNAL_INTERRUPT rip 0xffffffff81053af1 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x800000f6 error_code 0x00000000
 qemu-system-x86-8397    [002] d....  1404.389583: kvm_entry: vcpu 1, rip 0xffffffff81053af1
 qemu-system-x86-8397    [002] d....  1404.389594: kvm_exit: vcpu 1 reason MSR_WRITE rip 0xffffffff81054faa info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
 qemu-system-x86-8397    [002] .....  1404.389595: kvm_msr: msr_write c0000103 = 0x1

...TSC_AUX in setup_getcpu()...

 qemu-system-x86-8397    [002] d....  1404.389595: kvm_entry: vcpu 1, rip 0xffffffff81054fac
 qemu-system-x86-8397    [002] d....  1404.389646: kvm_exit: vcpu 1 reason LDTR_TR rip 0xffffffff810551b8 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000

...and, finally, the trapping LTR in cpu_init_exception_handling()!

Now I get why you where asking for UMIP. No, that warning in
handle_desc() doesn't trigger for me. ;)

But now the interesting part: the emulation of LTR:

 qemu-system-x86-8397    [002] .....  1404.389656: kvm_mmu_pagetable_walk: addr ffffffff810551b8 pferr 10 F
                                                                                                 ~~~~~
Just a nit, but this 'pferr' should probably be 'access' as it's not an ---------------------------^
an error code (yet) but the access mode for this page table walk.

 qemu-system-x86-8397    [002] .....  1404.389661: kvm_mmu_paging_element: pte 2929067 level 4
 qemu-system-x86-8397    [002] .....  1404.389662: kvm_mmu_paging_element: pte 2b2c063 level 3
 qemu-system-x86-8397    [002] .....  1404.389662: kvm_mmu_paging_element: pte 10001e3 level 2
 qemu-system-x86-8397    [002] .....  1404.389664: kvm_emulate_insn: 0:ffffffff810551b8:0f 00 d8 (prot64)

Instruction fetch went fine.

 qemu-system-x86-8397    [002] .....  1404.389666: kvm_mmu_pagetable_walk: addr fffffe0000201040 pferr 0
 qemu-system-x86-8397    [002] .....  1404.389666: kvm_mmu_paging_element: pte 800000000292b063 level 4
 qemu-system-x86-8397    [002] .....  1404.389666: kvm_mmu_paging_element: pte 8000000002b2f063 level 3
 qemu-system-x86-8397    [002] .....  1404.389666: kvm_mmu_paging_element: pte 8000000002d31063 level 2
 qemu-system-x86-8397    [002] .....  1404.389666: kvm_mmu_paging_element: pte 8000000002f3a161 level 1
 qemu-system-x86-8397    [002] .....  1404.389667: kvm_mmu_pagetable_walk: addr fffffe0000201048 pferr 0
 qemu-system-x86-8397    [002] .....  1404.389667: kvm_mmu_paging_element: pte 800000000292b063 level 4
 qemu-system-x86-8397    [002] .....  1404.389667: kvm_mmu_paging_element: pte 8000000002b2f063 level 3
 qemu-system-x86-8397    [002] .....  1404.389667: kvm_mmu_paging_element: pte 8000000002d31063 level 2
 qemu-system-x86-8397    [002] .....  1404.389667: kvm_mmu_paging_element: pte 8000000002f3a161 level 1

Read of the descriptor as well, but...

 qemu-system-x86-8397    [002] .....  1404.389668: kvm_mmu_pagetable_walk: addr fffffe0000201040 pferr 2 W
 qemu-system-x86-8397    [002] .....  1404.389668: kvm_mmu_paging_element: pte 800000000292b063 level 4
 qemu-system-x86-8397    [002] .....  1404.389668: kvm_mmu_paging_element: pte 8000000002b2f063 level 3
 qemu-system-x86-8397    [002] .....  1404.389668: kvm_mmu_paging_element: pte 8000000002d31063 level 2
 qemu-system-x86-8397    [002] .....  1404.389669: kvm_mmu_paging_element: pte 8000000002f3a161 level 1
 qemu-system-x86-8397    [002] .....  1404.389669: kvm_mmu_walker_error: pferr 3 P|W

 qemu-system-x86-8397    [002] .....  1404.389675: kvm_mmu_pagetable_walk: addr fffffe0000201040 pferr 2 W
 qemu-system-x86-8397    [002] .....  1404.389677: kvm_mmu_paging_element: pte 800000000292b063 level 4
 qemu-system-x86-8397    [002] .....  1404.389677: kvm_mmu_paging_element: pte 8000000002b2f063 level 3
 qemu-system-x86-8397    [002] .....  1404.389677: kvm_mmu_paging_element: pte 8000000002d31063 level 2
 qemu-system-x86-8397    [002] .....  1404.389678: kvm_mmu_paging_element: pte 8000000002f3a161 level 1
 qemu-system-x86-8397    [002] .....  1404.389678: kvm_mmu_walker_error: pferr 3 P|W

 qemu-system-x86-8397    [002] .....  1404.389684: kvm_inj_exception: #PF (0x3)

...the write failed and that's the page fault you were looking for...

 qemu-system-x86-8397    [002] d....  1404.389711: kvm_entry: vcpu 1, rip 0xffffffff810551b8
 qemu-system-x86-8397    [002] d....  1404.389730: kvm_exit: vcpu 1 reason TRIPLE_FAULT rip 0xffffffff810551b8 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000

...and here the triple fault I was seeing.

The page faults look legitimate on first sight, as the write bit isn't
set in the PTE. However, CR0.WP is 0, as show earlier in the VMCS dump,
so this shouldn't trigger a page fault.

Looks like I was too early to blame ESXi and this is more like a bug in
KVM's emulation of guest writes. I just don't see where the
kvm_read_cr0() is missing, yet -- obviously before we do the page table
walk, but even after adding one to init_emulate_ctxt() I still get the
fault, so there must be more to it. :/

Maybe it's not a stale CR0 value but the page table walker not taking
the guest's CR0.WP into account? Maybe a missing role update?

> [...]
> 
>> PS: ...should have left the chicken bit of v3 to be able to disable the
>> feature by a module parameter ;)
> 
> A chicken bit isn't a good solution for this sort of thing.  Toggling a KVM module
> param requires (a) knowing that it exists and (b) knowing the conditions under which
> it is/isn't safe to toggle the bit.

Sure. But it would have allowed me to notice that's indeed the last
patch of the series that's the culprit.

> 
> E.g. if this ends up being an ESXi L0 bug, then an option might be to add something
> in vmware_platform_setup() to communicate the bug to KVM so that KVM can precisely
> disable the optimization on affected platforms.
Agreed. But, as noted above, the signs are pointing to a bug in KVM.

Thanks,
Mathias
