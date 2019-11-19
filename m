Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE441019F3
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 08:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfKSHBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 02:01:11 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42850 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfKSHBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 02:01:11 -0500
Received: by mail-ot1-f67.google.com with SMTP id b16so16948740otk.9;
        Mon, 18 Nov 2019 23:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7LgV1sknVD5Bv8velpjYyNK1BQ/cwpcsqjgwpUS1s/E=;
        b=Www8ikI+vfjOlerOuAmCFf/i13LKc4tfj86gc3FInMjQzPr7gfZnH7YRkZ+uywqfLW
         cfUridv+hcHyRttTUpwa0afd1zmbCLi4l+8nGo3+MxuT6m7Tr1iQje9HFpoz14L+pLdQ
         lh8OgtwAtkX8vwWmKX39tqM+NppzVHQ7FGaV1Az2VHet/KKSxtXTe2eH7x1UAD+MHQYb
         LUhbz3rK/CWGHHEZUP43LB9K3FsM4ETcw/bwjtWizMITFnp7XJ8z1pC8jfQXn59FWEfC
         FDAjEgLZLSGc9sceSALaqtGpBAnaHD1DFbi4K3JJ81Vi9OfFVwURG3mCEm0YXJBNlHfc
         3ysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7LgV1sknVD5Bv8velpjYyNK1BQ/cwpcsqjgwpUS1s/E=;
        b=oOIxVUvUwi9jDAaaQmC9HoCfhrKa+kPhHzuApec/8+2Tk2RnVf95bFzU1Is9fAIS/V
         +J7U11QE27ISm6//N4r/jzo5aKkJ3o2V/ijGGb9YzMYKc3afg4k2XD0leM0A1Gn2+doX
         yGNXktDusHP7tCmQkf9cUKiTIW/zemgrc5T2tsjtVB9s49z/n5IDbDip1qOMhRp6aOKn
         LKbrLbSP0V4oNtiukrUlUybkE48J+ouVByfDsKYPfOkhX1gVePX0tg8w4BJjvMx0jc8d
         G9UfL2ljBDeV/9Vfvkq0rNuOO/pGSTS+rnFTMLgfJeVY0g7efzfQxHVY/xEUP9yvtH3y
         2lUw==
X-Gm-Message-State: APjAAAUbEo/Y1YyjHz3DNvXNdhQRd57GryZBkm/pRh5mpsWgr/vGMLt3
        J4Y0XXAQdYJgiyPj4Chz440fqPl09UNBrSthpVU=
X-Google-Smtp-Source: APXvYqwgiGmeWNG0xBRR7PFllSTee51nI/R8o9QR7KWUPxQbHy9MFb+u0fqj5fAOn8txMId1Wy2CqbDP6UjzKZnQfVI=
X-Received: by 2002:a05:6830:1697:: with SMTP id k23mr2349617otr.254.1574146869812;
 Mon, 18 Nov 2019 23:01:09 -0800 (PST)
MIME-Version: 1.0
References: <1571829384-5309-1-git-send-email-zhenzhong.duan@oracle.com> <1571829384-5309-3-git-send-email-zhenzhong.duan@oracle.com>
In-Reply-To: <1571829384-5309-3-git-send-email-zhenzhong.duan@oracle.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 19 Nov 2019 15:01:01 +0800
Message-ID: <CANRm+CxvhDzcz6jDCdpCGsfd0hHjyEWRGpTPhvL8-ggdtPvP8A@mail.gmail.com>
Subject: Re: [PATCH v8 2/5] x86/kvm: Change print code to use pr_*() format
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>, will@kernel.org,
        linux-hyperv@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        mikelley@microsoft.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Oct 2019 at 19:23, Zhenzhong Duan <zhenzhong.duan@oracle.com> wrote:
>
> pr_*() is preferred than printk(KERN_* ...), after change all the print
> in arch/x86/kernel/kvm.c will have "kvm-guest: xxx" style.
>
> No functional change.
>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krcmar <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>

Reviewed-by: Wanpeng Li <wanpengli@tencent.com>

> ---
>  arch/x86/kernel/kvm.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 3bc6a266..6562886 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -7,6 +7,8 @@
>   *   Authors: Anthony Liguori <aliguori@us.ibm.com>
>   */
>
> +#define pr_fmt(fmt) "kvm-guest: " fmt
> +
>  #include <linux/context_tracking.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> @@ -286,8 +288,8 @@ static void kvm_register_steal_time(void)
>                 return;
>
>         wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
> -       pr_info("kvm-stealtime: cpu %d, msr %llx\n",
> -               cpu, (unsigned long long) slow_virt_to_phys(st));
> +       pr_info("stealtime: cpu %d, msr %llx\n", cpu,
> +               (unsigned long long) slow_virt_to_phys(st));
>  }
>
>  static DEFINE_PER_CPU_DECRYPTED(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
> @@ -321,8 +323,7 @@ static void kvm_guest_cpu_init(void)
>
>                 wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
>                 __this_cpu_write(apf_reason.enabled, 1);
> -               printk(KERN_INFO"KVM setup async PF for cpu %d\n",
> -                      smp_processor_id());
> +               pr_info("setup async PF for cpu %d\n", smp_processor_id());
>         }
>
>         if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
> @@ -347,8 +348,7 @@ static void kvm_pv_disable_apf(void)
>         wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
>         __this_cpu_write(apf_reason.enabled, 0);
>
> -       printk(KERN_INFO"Unregister pv shared memory for cpu %d\n",
> -              smp_processor_id());
> +       pr_info("unregister PV shared memory for cpu %d\n", smp_processor_id());
>  }
>
>  static void kvm_pv_guest_cpu_reboot(void *unused)
> @@ -469,7 +469,8 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
>                 } else {
>                         ret = kvm_hypercall4(KVM_HC_SEND_IPI, (unsigned long)ipi_bitmap,
>                                 (unsigned long)(ipi_bitmap >> BITS_PER_LONG), min, icr);
> -                       WARN_ONCE(ret < 0, "KVM: failed to send PV IPI: %ld", ret);
> +                       WARN_ONCE(ret < 0, "kvm-guest: failed to send PV IPI: %ld",
> +                                 ret);
>                         min = max = apic_id;
>                         ipi_bitmap = 0;
>                 }
> @@ -479,7 +480,8 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
>         if (ipi_bitmap) {
>                 ret = kvm_hypercall4(KVM_HC_SEND_IPI, (unsigned long)ipi_bitmap,
>                         (unsigned long)(ipi_bitmap >> BITS_PER_LONG), min, icr);
> -               WARN_ONCE(ret < 0, "KVM: failed to send PV IPI: %ld", ret);
> +               WARN_ONCE(ret < 0, "kvm-guest: failed to send PV IPI: %ld",
> +                         ret);
>         }
>
>         local_irq_restore(flags);
> @@ -509,7 +511,7 @@ static void kvm_setup_pv_ipi(void)
>  {
>         apic->send_IPI_mask = kvm_send_ipi_mask;
>         apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
> -       pr_info("KVM setup pv IPIs\n");
> +       pr_info("setup PV IPIs\n");
>  }
>
>  static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
> @@ -631,11 +633,11 @@ static void __init kvm_guest_init(void)
>             !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
>             kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
>                 smp_ops.send_call_func_ipi = kvm_smp_send_call_func_ipi;
> -               pr_info("KVM setup pv sched yield\n");
> +               pr_info("setup PV sched yield\n");
>         }
>         if (cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "x86/kvm:online",
>                                       kvm_cpu_online, kvm_cpu_down_prepare) < 0)
> -               pr_err("kvm_guest: Failed to install cpu hotplug callbacks\n");
> +               pr_err("failed to install cpu hotplug callbacks\n");
>  #else
>         sev_map_percpu_data();
>         kvm_guest_cpu_init();
> @@ -738,7 +740,7 @@ static __init int kvm_setup_pv_tlb_flush(void)
>                         zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
>                                 GFP_KERNEL, cpu_to_node(cpu));
>                 }
> -               pr_info("KVM setup pv remote TLB flush\n");
> +               pr_info("setup PV remote TLB flush\n");
>         }
>
>         return 0;
> @@ -866,8 +868,8 @@ static void kvm_enable_host_haltpoll(void *i)
>  void arch_haltpoll_enable(unsigned int cpu)
>  {
>         if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL)) {
> -               pr_err_once("kvm: host does not support poll control\n");
> -               pr_err_once("kvm: host upgrade recommended\n");
> +               pr_err_once("host does not support poll control\n");
> +               pr_err_once("host upgrade recommended\n");
>                 return;
>         }
>
> --
> 1.8.3.1
>
