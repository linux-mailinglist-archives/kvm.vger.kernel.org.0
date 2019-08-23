Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05C529AE05
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 13:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730512AbfHWLVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 07:21:54 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43745 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfHWLVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 07:21:54 -0400
Received: by mail-wr1-f66.google.com with SMTP id y8so8274722wrn.10
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 04:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vdrvMv/f5RhT0oKtOYt+vGch+ye3w2fzkU92C9WXmi4=;
        b=yKB40M81u3P9jcBjgCSP2BBA466Cs6Kma/DUmGyoZ0qBBPF/8eectJtZn3Z2YHUZ4y
         a7y2CFusjtZrAx1+rsb1BBeOG+iSmDnLHYqA/R3r6zk4lL2MqVIM/d/qR1HhSi54n1lH
         vty9zYG2tu7Xnx0xy+txTcsnN4d0Ev3T9Uq+k6RDLaWv53Ijs07M5OI7uZwkIiBn++tj
         k81mZFnhC0pIgvjr3Yfw4ic9EApHQPcEsT3cPlzw7WFI53vpLYTDTLStz2s1rS53TptP
         6upw6YMQz0lw/FFCzVM+VCCanF34aCj0UxVfN5hhUn3f7/Cj5an/u2lQeSIHl1Qq1nfa
         rWGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vdrvMv/f5RhT0oKtOYt+vGch+ye3w2fzkU92C9WXmi4=;
        b=P1ISJTE93dFwWWanMBwk6R/9rEM78Ki1gxIeM/TM3n+Iml8vUdbZ5F+qdRZ6XAM7RW
         qylIfYHLflJ5hpTof9dD/E2jja+HBH73fplpIlUXN5dDYpdDEEjtYrFx8F1l/Q0Jt5Vj
         MRYqjcll8LjZAui+vuXSbqud6wifn4Bv89Mo+t9cVbZl8hHLaFMP1JsGXmanGgI0cih0
         FkDAnooujkGt8KpdFKnueORRibKx0SOol80oCD483RQwmf+tGHKFnfSvllJlcqOGozwj
         fm9c+RhTYSqqpOaqiwX5esV1DvudSpvjaf4Q4NUXqvm0hCxNY/IXHgDzaecHufPToPjY
         Hg9Q==
X-Gm-Message-State: APjAAAVUCRbxsYiQswBhn4/fwu65Khuw6ENb+5EdzcV0Pis5ZYbxKl+g
        JT95jUcN4tJcYy7KUQsQx6JZeqn3pz4byQjoNn0wMA==
X-Google-Smtp-Source: APXvYqwxICw/0ZHX6I0dCk0HldrXSs1fpHSG4cT5Hh5ZKrhcdTDqfX3JBb9+eTwqVsGhNmbVp6ETTaFtfeobWRQOww4=
X-Received: by 2002:a05:6000:10cf:: with SMTP id b15mr4559812wrx.180.1566559310727;
 Fri, 23 Aug 2019 04:21:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190822084131.114764-1-anup.patel@wdc.com> <20190822084131.114764-14-anup.patel@wdc.com>
 <77b9ff3c-292f-ee17-ddbb-134c0666fde7@amazon.com> <CAAhSdy1h+m0gA2pro-XAb4qhe0Q+8knjW+8+6jaz3efOdKWskA@mail.gmail.com>
 <a44f86ac-8902-0aa3-1eee-013ac97d667b@amazon.com> <CAAhSdy20D=t5hbeWDi=1XmNAe5rwvNyjMth-WUwrVe+HcagVpg@mail.gmail.com>
 <58899115-88a3-5167-2ed4-886498648f63@amazon.com>
In-Reply-To: <58899115-88a3-5167-2ed4-886498648f63@amazon.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 23 Aug 2019 16:51:39 +0530
Message-ID: <CAAhSdy3mvfwrz4PkT-iMqwBBRKH7b911DuoPp7JHAkGTHwtDmA@mail.gmail.com>
Subject: Re: [PATCH v5 13/20] RISC-V: KVM: Implement stage2 page table programming
To:     Alexander Graf <graf@amazon.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 22, 2019 at 7:39 PM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 22.08.19 15:58, Anup Patel wrote:
> > On Thu, Aug 22, 2019 at 6:57 PM Alexander Graf <graf@amazon.com> wrote:
> >>
> >>
> >>
> >> On 22.08.19 14:38, Anup Patel wrote:
> >>> On Thu, Aug 22, 2019 at 5:58 PM Alexander Graf <graf@amazon.com> wrote:
> >>>>
> >>>> On 22.08.19 10:45, Anup Patel wrote:
> >>>>> This patch implements all required functions for programming
> >>>>> the stage2 page table for each Guest/VM.
> >>>>>
> >>>>> At high-level, the flow of stage2 related functions is similar
> >>>>> from KVM ARM/ARM64 implementation but the stage2 page table
> >>>>> format is quite different for KVM RISC-V.
> >>>>>
> >>>>> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> >>>>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> >>>>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> >>>>> ---
> >>>>>     arch/riscv/include/asm/kvm_host.h     |  10 +
> >>>>>     arch/riscv/include/asm/pgtable-bits.h |   1 +
> >>>>>     arch/riscv/kvm/mmu.c                  | 637 +++++++++++++++++++++++++-
> >>>>>     3 files changed, 638 insertions(+), 10 deletions(-)
> >>>>>
> >>>>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> >>>>> index 3b09158f80f2..a37775c92586 100644
> >>>>> --- a/arch/riscv/include/asm/kvm_host.h
> >>>>> +++ b/arch/riscv/include/asm/kvm_host.h
> >>>>> @@ -72,6 +72,13 @@ struct kvm_mmio_decode {
> >>>>>         int shift;
> >>>>>     };
> >>>>>
> >>>>> +#define KVM_MMU_PAGE_CACHE_NR_OBJS   32
> >>>>> +
> >>>>> +struct kvm_mmu_page_cache {
> >>>>> +     int nobjs;
> >>>>> +     void *objects[KVM_MMU_PAGE_CACHE_NR_OBJS];
> >>>>> +};
> >>>>> +
> >>>>>     struct kvm_cpu_context {
> >>>>>         unsigned long zero;
> >>>>>         unsigned long ra;
> >>>>> @@ -163,6 +170,9 @@ struct kvm_vcpu_arch {
> >>>>>         /* MMIO instruction details */
> >>>>>         struct kvm_mmio_decode mmio_decode;
> >>>>>
> >>>>> +     /* Cache pages needed to program page tables with spinlock held */
> >>>>> +     struct kvm_mmu_page_cache mmu_page_cache;
> >>>>> +
> >>>>>         /* VCPU power-off state */
> >>>>>         bool power_off;
> >>>>>
> >>>>> diff --git a/arch/riscv/include/asm/pgtable-bits.h b/arch/riscv/include/asm/pgtable-bits.h
> >>>>> index bbaeb5d35842..be49d62fcc2b 100644
> >>>>> --- a/arch/riscv/include/asm/pgtable-bits.h
> >>>>> +++ b/arch/riscv/include/asm/pgtable-bits.h
> >>>>> @@ -26,6 +26,7 @@
> >>>>>
> >>>>>     #define _PAGE_SPECIAL   _PAGE_SOFT
> >>>>>     #define _PAGE_TABLE     _PAGE_PRESENT
> >>>>> +#define _PAGE_LEAF      (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC)
> >>>>>
> >>>>>     /*
> >>>>>      * _PAGE_PROT_NONE is set on not-present pages (and ignored by the hardware) to
> >>>>> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> >>>>> index 2b965f9aac07..9e95ab6769f6 100644
> >>>>> --- a/arch/riscv/kvm/mmu.c
> >>>>> +++ b/arch/riscv/kvm/mmu.c
> >>>>> @@ -18,6 +18,432 @@
> >>>>>     #include <asm/page.h>
> >>>>>     #include <asm/pgtable.h>
> >>>>>
> >>>>> +#ifdef CONFIG_64BIT
> >>>>> +#define stage2_have_pmd              true
> >>>>> +#define stage2_gpa_size              ((phys_addr_t)(1ULL << 39))
> >>>>> +#define stage2_cache_min_pages       2
> >>>>> +#else
> >>>>> +#define pmd_index(x)         0
> >>>>> +#define pfn_pmd(x, y)                ({ pmd_t __x = { 0 }; __x; })
> >>>>> +#define stage2_have_pmd              false
> >>>>> +#define stage2_gpa_size              ((phys_addr_t)(1ULL << 32))
> >>>>> +#define stage2_cache_min_pages       1
> >>>>> +#endif
> >>>>> +
> >>>>> +static int stage2_cache_topup(struct kvm_mmu_page_cache *pcache,
> >>>>> +                           int min, int max)
> >>>>> +{
> >>>>> +     void *page;
> >>>>> +
> >>>>> +     BUG_ON(max > KVM_MMU_PAGE_CACHE_NR_OBJS);
> >>>>> +     if (pcache->nobjs >= min)
> >>>>> +             return 0;
> >>>>> +     while (pcache->nobjs < max) {
> >>>>> +             page = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
> >>>>> +             if (!page)
> >>>>> +                     return -ENOMEM;
> >>>>> +             pcache->objects[pcache->nobjs++] = page;
> >>>>> +     }
> >>>>> +
> >>>>> +     return 0;
> >>>>> +}
> >>>>> +
> >>>>> +static void stage2_cache_flush(struct kvm_mmu_page_cache *pcache)
> >>>>> +{
> >>>>> +     while (pcache && pcache->nobjs)
> >>>>> +             free_page((unsigned long)pcache->objects[--pcache->nobjs]);
> >>>>> +}
> >>>>> +
> >>>>> +static void *stage2_cache_alloc(struct kvm_mmu_page_cache *pcache)
> >>>>> +{
> >>>>> +     void *p;
> >>>>> +
> >>>>> +     if (!pcache)
> >>>>> +             return NULL;
> >>>>> +
> >>>>> +     BUG_ON(!pcache->nobjs);
> >>>>> +     p = pcache->objects[--pcache->nobjs];
> >>>>> +
> >>>>> +     return p;
> >>>>> +}
> >>>>> +
> >>>>> +struct local_guest_tlb_info {
> >>>>> +     struct kvm_vmid *vmid;
> >>>>> +     gpa_t addr;
> >>>>> +};
> >>>>> +
> >>>>> +static void local_guest_tlb_flush_vmid_gpa(void *info)
> >>>>> +{
> >>>>> +     struct local_guest_tlb_info *infop = info;
> >>>>> +
> >>>>> +     __kvm_riscv_hfence_gvma_vmid_gpa(READ_ONCE(infop->vmid->vmid_version),
> >>>>> +                                      infop->addr);
> >>>>> +}
> >>>>> +
> >>>>> +static void stage2_remote_tlb_flush(struct kvm *kvm, gpa_t addr)
> >>>>> +{
> >>>>> +     struct local_guest_tlb_info info;
> >>>>> +     struct kvm_vmid *vmid = &kvm->arch.vmid;
> >>>>> +
> >>>>> +     /* TODO: This should be SBI call */
> >>>>> +     info.vmid = vmid;
> >>>>> +     info.addr = addr;
> >>>>> +     preempt_disable();
> >>>>> +     smp_call_function_many(cpu_all_mask, local_guest_tlb_flush_vmid_gpa,
> >>>>> +                            &info, true);
> >>>>
> >>>> This is all nice and dandy on the toy 4 core systems we have today, but
> >>>> it will become a bottleneck further down the road.
> >>>>
> >>>> How many VMIDs do you have? Could you just allocate a new one every time
> >>>> you switch host CPUs? Then you know exactly which CPUs to flush by
> >>>> looking at all your vcpu structs and a local field that tells you which
> >>>> pCPU they're on at this moment.
> >>>>
> >>>> Either way, it's nothing that should block inclusion. For today, we're fine.
> >>>
> >>> We are not happy about this either.
> >>>
> >>> Other two options, we have are:
> >>> 1. Have SBI calls for remote HFENCEs
> >>> 2. Propose RISC-V ISA extension for remote FENCEs
> >>>
> >>> Option1 is mostly extending SBI spec and implementing it in runtime
> >>> firmware.
> >>>
> >>> Option2 is ideal solution but requires consensus among wider audience
> >>> in RISC-V foundation.
> >>>
> >>> At this point, we are fine with a simple solution.
> >>
> >> It's fine to explicitly IPI other CPUs to flush their TLBs. What is not
> >> fine is to IPI *all* CPUs to flush their TLBs.
> >
> > Ahh, this should have been cpu_online_mask instead of cpu_all_mask
> >
> > I will update this in next revision.
>
> What I was trying to say is that you only want to flush currently
> running other vcpus and add a hint for all the others saying "please
> flush the next time you come up".
>
> I think we had a mechanism for that somewhere in the EVENT magic.
>
> But as I said, this is a performance optimization - that's something I'm
> happy to delay. Security and user space ABI are the bits I'm worried
> about at this stage.

I had thought about this previously. This will be certainly a good
optimization. Let me add a TODO comment here so that we don't
forget it.

Regards,
Anup

>
>
> Alex
