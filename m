Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138AF437983
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 17:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhJVPFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 11:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbhJVPFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 11:05:21 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197A0C061764
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 08:03:04 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id z14so4295764wrg.6
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 08:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3OwTB01Y4l/+kVc73bUX9Z/iYlcMp8gV7w4ueFIx8Ew=;
        b=wpSkuuN+E/3s4nGjBtt7p0E+89MzWCY9gMhvKz1Ef14MYys7krAIIthKGELpKTeuFk
         EpEzaOOtyERbGHOhnsembwGIFJlYjt5HVbHDton9+1RHtWbxoaITSkLIz0Kt7EjjjC8J
         pNe4gvOoH4qtoMDeBHIZ8ReIUfDiQFSikDCY6r/d/bJXnxJdRgd1/mU8m7NnyFK+1voW
         82rIb+FkSGT7XfptFXc2QjTey0N78CVh1PNSnL5cCFi+3VBkogj6aoyqPL/MIUAiJc1K
         s/W2WkxFBjsfrs4WJnOORyd83lN5UWWWljCUYFHNyaV9WATYUTXDNA563tvvjDAxqEF1
         /uZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3OwTB01Y4l/+kVc73bUX9Z/iYlcMp8gV7w4ueFIx8Ew=;
        b=QOYLjNq3KNERlRdxLfD3WKYMy3LG/XECWwk1UhrrZyLEaXuZtWVywXN7SiFoh9Bo9d
         Zi/qBqL8iuOt/WJJbrV+uOyhaIPGd17/RUnhQbu+bN1AvjDObixbhpHpdpN5gGqsSPvv
         dRCR3uzdtU8cJVvHoAyFOsKgxkBUpgWAA5dRdbpNYfmDcfYpilcrLjZaHw78oFYyfq8J
         oI39Q1AitMOq5SRseIxPmgi1/wfiWVZA60+zccbEGQX4/oOPXxPlhIW0aU1jiLsvs7qR
         bXAU6TXfXXcABkUF4GmrXURsuYd2KRNy2HAH/UneFSLCCBjkt8Hay4tiPXFy+ERBSayQ
         PHow==
X-Gm-Message-State: AOAM533iQNpO70bbXEvnlgPKMhWk0U62YwtsY6y2dUt1RS/fO0NEhcd1
        S4bS6wwLufGE8fwcm+YqcgJevS4Grds5QJLtzGJbLA==
X-Google-Smtp-Source: ABdhPJyp0dm3PoN0Wstx3HCArGjVpjcl9P3vKQZBf6Fq6JRJcyoPyekjhQzR4/Y3T+mdbjFmhbwZhgn3lvibDkD6Krc=
X-Received: by 2002:a05:6000:1acc:: with SMTP id i12mr431822wry.249.1634914981152;
 Fri, 22 Oct 2021 08:03:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com> <20211009021236.4122790-10-seanjc@google.com>
In-Reply-To: <20211009021236.4122790-10-seanjc@google.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 22 Oct 2021 20:32:49 +0530
Message-ID: <CAAhSdy1Wr6ODjDWd4V23Dh6M-V4LB1y1a+qwuxXe8CaZSgi9kw@mail.gmail.com>
Subject: Re: [PATCH v2 09/43] KVM: Drop obsolete kvm_arch_vcpu_block_finish()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        KVM General <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Atish Patra <atish.patra@wdc.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, Joerg Roedel <joro@8bytes.org>,
        kvm-ppc@vger.kernel.org, David Matlack <dmatlack@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jim Mattson <jmattson@google.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 9, 2021 at 7:43 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Drop kvm_arch_vcpu_block_finish() now that all arch implementations are
> nops.
>
> No functional change intended.
>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup.patel@wdc.com>
Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup

> ---
>  arch/arm64/include/asm/kvm_host.h   | 1 -
>  arch/mips/include/asm/kvm_host.h    | 1 -
>  arch/powerpc/include/asm/kvm_host.h | 1 -
>  arch/riscv/include/asm/kvm_host.h   | 1 -
>  arch/s390/include/asm/kvm_host.h    | 2 --
>  arch/s390/kvm/kvm-s390.c            | 5 -----
>  arch/x86/include/asm/kvm_host.h     | 2 --
>  virt/kvm/kvm_main.c                 | 1 -
>  8 files changed, 14 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 369c30e28301..fe4dec96d1c3 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -716,7 +716,6 @@ void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
>  static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>
>  void kvm_arm_init_debug(void);
>  void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 696f6b009377..72b90d45a46e 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -897,7 +897,6 @@ static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
>  int kvm_arch_flush_remote_tlb(struct kvm *kvm);
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 876c10803cda..4a195c161592 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -865,6 +865,5 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  static inline void kvm_arch_exit(void) {}
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>
>  #endif /* __POWERPC_KVM_HOST_H__ */
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index d7e1696cd2ec..b3f0c3773603 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -209,7 +209,6 @@ struct kvm_vcpu_arch {
>  static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>
>  #define KVM_ARCH_WANT_MMU_NOTIFIER
>
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a604d51acfc8..a22c9266ea05 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -1010,6 +1010,4 @@ static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>
> -void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu);
> -
>  #endif
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 08ed68639a21..17fabb260c35 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -5080,11 +5080,6 @@ static inline unsigned long nonhyp_mask(int i)
>         return 0x0000ffffffffffffUL >> (nonhyp_fai << 4);
>  }
>
> -void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu)
> -{
> -
> -}
> -
>  static int __init kvm_s390_init(void)
>  {
>         int i;
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 88f0326c184a..7aafc27ce7a9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1926,8 +1926,6 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>         static_call_cond(kvm_x86_vcpu_unblocking)(vcpu);
>  }
>
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
> -
>  static inline int kvm_cpu_get_apicid(int mps_cpu)
>  {
>  #ifdef CONFIG_X86_LOCAL_APIC
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 1292c7876d3f..f90b3ed05628 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3304,7 +3304,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>         }
>
>         trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
> -       kvm_arch_vcpu_block_finish(vcpu);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_block);
>
> --
> 2.33.0.882.g93a45727a2-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
