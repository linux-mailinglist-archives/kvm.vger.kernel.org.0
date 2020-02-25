Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD59616BB51
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 08:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgBYHzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 02:55:19 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41419 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbgBYHzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 02:55:19 -0500
Received: by mail-ot1-f66.google.com with SMTP id r27so11242836otc.8;
        Mon, 24 Feb 2020 23:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wpB86MNPuQluf2px2PUoNrc0vpFzF/KBEDkkr6xZ3J8=;
        b=VMwUMCXnkN7cgIefOvdxbEwUemR6aHEb0yF8PLWeG1CRXzztczvR2oXfs0yo+ijwWB
         P/D6OYIitzl7n8cVMM2elKxxKU3P0t8iD12Dtu+6FRvrchxiTpydxqu+eck2yeGBtnaN
         zBw+QpMNqj0p2PqsF1laoubsY9YxPmeessbRXu2vU17lK1EWQWm+63AHS2nentw4Mjoc
         Aku/8f4FaXIqWyOopGSo0UnCAaMIYqsZXZWjP0vck2puBlP6JqoQnOwi1IQAv8LEf4iV
         hWxxPdeg5SYJfKvsQl2RXhhJMFfsqCcgx78JmugNTb16w5BBTOltChqqKtxyBbYUGX6X
         JTzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wpB86MNPuQluf2px2PUoNrc0vpFzF/KBEDkkr6xZ3J8=;
        b=MDriBajOo6SReCiM4+w9Khq/wtZrSGvjV7nLdjIJT084wF4oz1951+jhGJAXErwBg5
         jngrCRvWsi2Sy5Q8gNWiDD7frHnXRiPdCnsZRYpQfF8kWfHTJLTUMDN3q/CsvnQP3k4S
         hXbgSABXQ7b44+FBA83+ws/loePrddEB8a0+hx0KpmxnwkkKL1yuQQ51q9UtpOlZ65VS
         maqS4MgkHcFNbQDfoXH23Lf2TrwqEtEkZrg1XZ0pd7Nrcj7BfvCXJFe29YVV1nHRvP7N
         1TMUGSaU9hyFOfG4PlX/z6ss9kRgFciZDjdlYxSn28vlrymgsDAqgqnHSEGkHaO7Uik3
         ldAg==
X-Gm-Message-State: APjAAAWaCWkrUMeZLfRGijUcqgfQXI0DyMmdYvy2vlDfW14y6/69xXq0
        NXDgRfiiz1p6fLE6EPYCwrKvZWX6fSBmRIqXkM2t2OhE
X-Google-Smtp-Source: APXvYqymYkXowCBI+4o4n/9GqHmhmSVSEVBWrKTOLkggfySlEYVizOYcEujRZtWDeWgKvXGZC9a8gpnzCeWX5l4RXXw=
X-Received: by 2002:a05:6830:1:: with SMTP id c1mr39975236otp.254.1582617317572;
 Mon, 24 Feb 2020 23:55:17 -0800 (PST)
MIME-Version: 1.0
References: <1581988104-16628-1-git-send-email-wanpengli@tencent.com> <1581988104-16628-2-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1581988104-16628-2-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 25 Feb 2020 15:55:06 +0800
Message-ID: <CANRm+CyHmdbsw572x=8=GYEOw-YQCXhz89i9+VEmROBVAu+rvg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 2/2] KVM: Pre-allocate 1 cpumask variable per
 cpu for both pv tlb and pv ipis
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping,
On Tue, 18 Feb 2020 at 09:12, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> Nick Desaulniers Reported:
>
>   When building with:
>   $ make CC=clang arch/x86/ CFLAGS=-Wframe-larger-than=1000
>   The following warning is observed:
>   arch/x86/kernel/kvm.c:494:13: warning: stack frame size of 1064 bytes in
>   function 'kvm_send_ipi_mask_allbutself' [-Wframe-larger-than=]
>   static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int
>   vector)
>               ^
>   Debugging with:
>   https://github.com/ClangBuiltLinux/frame-larger-than
>   via:
>   $ python3 frame_larger_than.py arch/x86/kernel/kvm.o \
>     kvm_send_ipi_mask_allbutself
>   points to the stack allocated `struct cpumask newmask` in
>   `kvm_send_ipi_mask_allbutself`. The size of a `struct cpumask` is
>   potentially large, as it's CONFIG_NR_CPUS divided by BITS_PER_LONG for
>   the target architecture. CONFIG_NR_CPUS for X86_64 can be as high as
>   8192, making a single instance of a `struct cpumask` 1024 B.
>
> This patch fixes it by pre-allocate 1 cpumask variable per cpu and use it for
> both pv tlb and pv ipis..
>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Acked-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * remove '!alloc' check
>  * use new pv check helpers
>
>  arch/x86/kernel/kvm.c | 33 +++++++++++++++++++++------------
>  1 file changed, 21 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 76ea8c4..377b224 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -432,6 +432,8 @@ static bool pv_tlb_flush_supported(void)
>                 kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
>  }
>
> +static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
> +
>  #ifdef CONFIG_SMP
>
>  static bool pv_ipi_supported(void)
> @@ -510,12 +512,12 @@ static void kvm_send_ipi_mask(const struct cpumask *mask, int vector)
>  static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
>  {
>         unsigned int this_cpu = smp_processor_id();
> -       struct cpumask new_mask;
> +       struct cpumask *new_mask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
>         const struct cpumask *local_mask;
>
> -       cpumask_copy(&new_mask, mask);
> -       cpumask_clear_cpu(this_cpu, &new_mask);
> -       local_mask = &new_mask;
> +       cpumask_copy(new_mask, mask);
> +       cpumask_clear_cpu(this_cpu, new_mask);
> +       local_mask = new_mask;
>         __send_ipi_mask(local_mask, vector);
>  }
>
> @@ -595,7 +597,6 @@ static void __init kvm_apf_trap_init(void)
>         update_intr_gate(X86_TRAP_PF, async_page_fault);
>  }
>
> -static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);
>
>  static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>                         const struct flush_tlb_info *info)
> @@ -603,7 +604,7 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>         u8 state;
>         int cpu;
>         struct kvm_steal_time *src;
> -       struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_tlb_mask);
> +       struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
>
>         cpumask_copy(flushmask, cpumask);
>         /*
> @@ -642,6 +643,7 @@ static void __init kvm_guest_init(void)
>         if (pv_tlb_flush_supported()) {
>                 pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>                 pv_ops.mmu.tlb_remove_table = tlb_remove_table;
> +               pr_info("KVM setup pv remote TLB flush\n");
>         }
>
>         if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> @@ -748,24 +750,31 @@ static __init int activate_jump_labels(void)
>  }
>  arch_initcall(activate_jump_labels);
>
> -static __init int kvm_setup_pv_tlb_flush(void)
> +static __init int kvm_alloc_cpumask(void)
>  {
>         int cpu;
> +       bool alloc = false;
>
>         if (!kvm_para_available() || nopv)
>                 return 0;
>
> -       if (pv_tlb_flush_supported()) {
> +       if (pv_tlb_flush_supported())
> +               alloc = true;
> +
> +#if defined(CONFIG_SMP)
> +       if (pv_ipi_supported())
> +               alloc = true;
> +#endif
> +
> +       if (alloc)
>                 for_each_possible_cpu(cpu) {
> -                       zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
> +                       zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
>                                 GFP_KERNEL, cpu_to_node(cpu));
>                 }
> -               pr_info("KVM setup pv remote TLB flush\n");
> -       }
>
>         return 0;
>  }
> -arch_initcall(kvm_setup_pv_tlb_flush);
> +arch_initcall(kvm_alloc_cpumask);
>
>  #ifdef CONFIG_PARAVIRT_SPINLOCKS
>
> --
> 2.7.4
>
