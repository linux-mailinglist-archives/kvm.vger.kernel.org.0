Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061AD446C5D
	for <lists+kvm@lfdr.de>; Sat,  6 Nov 2021 05:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhKFEq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Nov 2021 00:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbhKFEq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Nov 2021 00:46:28 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB46C061570
        for <kvm@vger.kernel.org>; Fri,  5 Nov 2021 21:43:47 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id v127so8666069wme.5
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 21:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zz9a+qzN2sZesmrzr2KrbwIAKYKAIzts5mTcnvexOVs=;
        b=kS6PrGMVjaniRBBJYPw2pCj3rF/VJtXH8YUrVQvgmxdSR3cawy2nFWRAq6NRk9okpc
         J4zPefwmr4IGQ4U/7NdNL+f66K2ExbBYUu35nKD5xPgDYLNF/PioAw+PXpVMUQE04iqx
         j+tqyzqkxfkpysGqJhU58QsOTETsa57EsvIkwvWo210Ot4QMnWNxIPBTiUbzwQD3PATU
         MteYlkXFZC8zwyeLQZyf94rWLbdQjCfPj4r38ee9xFqeJeGeIlkPHr/sd8wHEmZDkWyO
         ATOjdEc78PaQSjJS8irZ3BD3NXLR60MdbxtEXsQQ6PyvAoJwqFM+CBk5io33MzRHG4m6
         unZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zz9a+qzN2sZesmrzr2KrbwIAKYKAIzts5mTcnvexOVs=;
        b=IbzxMohRS4h0h3M1wyaATBgkkvTaLARTLQMz5q9VBFFSpUUn5ehURsubya9ti2Pgf5
         EVjX9eDlMeVJZoncdtURiZ9jJGIkoPJ+8/o4pa8S81LgU2fhl1igB/7Bk+H003NrNQJG
         VsKIDolR1f2rcMwbkVAyeNQHcxdWijvlXTWaAXBmXv4AoSP/+L8edU8ufCwp4mk9lI6v
         D09NMQBwHmBKdTFJP5nUjbbcfqeSDywcVFnUsE0rzgR+5htsIFJD7DuVyDBvs2RXIP8C
         fNzXYuDoKrFfmj9tTHq4NYUc9zzGN6EXmI9abqNz8lP1Kfim0nLJ6ji65mUZrodLyJf1
         N8JA==
X-Gm-Message-State: AOAM53362on8wBLBr+uclyGHF6d12wPMBmGr7OZ+SbxGHktkmY7nW0Bi
        /OYZ/2aGmUu9LreS0YDqEYgwEO7rAe9VXGIXTt0rjg==
X-Google-Smtp-Source: ABdhPJzQiQKc2vEeWX9WhWnr3cTKWYJEpLzh+KsOx3bW9rqQqMFG/LxhduMychBL61BxxSI9Oar2UzPfnIrw89u1z3E=
X-Received: by 2002:a1c:7201:: with SMTP id n1mr35835491wmc.176.1636173826086;
 Fri, 05 Nov 2021 21:43:46 -0700 (PDT)
MIME-Version: 1.0
References: <20211105235852.3011900-1-atish.patra@wdc.com> <20211105235852.3011900-3-atish.patra@wdc.com>
In-Reply-To: <20211105235852.3011900-3-atish.patra@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 6 Nov 2021 10:13:35 +0530
Message-ID: <CAAhSdy12kq6AHwRkgAoPaSxSDp6LM3oFj03Zyt8_jkQtBZRLZA@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] RISC-V: KVM: Reorganize SBI code by moving SBI
 v0.1 to its own file
To:     Atish Patra <atish.patra@wdc.com>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Anup Patel <anup.patel@wdc.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 6, 2021 at 5:29 AM Atish Patra <atish.patra@wdc.com> wrote:
>
> With SBI v0.2, there may be more SBI extensions in future. It makes more
> sense to group related extensions in separate files. Guest kernel will
> choose appropriate SBI version dynamically.
>
> Move the existing implementation to a separate file so that it can be
> removed in future without much conflict.
>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |   2 +
>  arch/riscv/kvm/Makefile               |   1 +
>  arch/riscv/kvm/vcpu_sbi.c             | 151 +++-----------------------
>  arch/riscv/kvm/vcpu_sbi_v01.c         | 129 ++++++++++++++++++++++
>  4 files changed, 149 insertions(+), 134 deletions(-)
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_v01.c
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 1a4cb0db2d0b..704151969ceb 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -25,5 +25,7 @@ struct kvm_vcpu_sbi_extension {
>                        bool *exit);
>  };
>
> +void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
> +
>  #endif /* __RISCV_KVM_VCPU_SBI_H__ */
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 30cdd1df0098..d3d5ff3a6019 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -23,4 +23,5 @@ kvm-y += vcpu_exit.o
>  kvm-y += vcpu_fp.o
>  kvm-y += vcpu_switch.o
>  kvm-y += vcpu_sbi.o
> +kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
>  kvm-y += vcpu_timer.o
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 05cab5f27eee..06b42f6977e1 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -9,9 +9,7 @@
>  #include <linux/errno.h>
>  #include <linux/err.h>
>  #include <linux/kvm_host.h>
> -#include <asm/csr.h>
>  #include <asm/sbi.h>
> -#include <asm/kvm_vcpu_timer.h>
>  #include <asm/kvm_vcpu_sbi.h>
>
>  static int kvm_linux_err_map_sbi(int err)
> @@ -32,8 +30,21 @@ static int kvm_linux_err_map_sbi(int err)
>         };
>  }
>
> -static void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu,
> -                                      struct kvm_run *run)
> +#ifdef CONFIG_RISCV_SBI_V01
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
> +#else
> +static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
> +       .extid_start = -1UL,
> +       .extid_end = -1UL,
> +       .handler = NULL,
> +};
> +#endif
> +
> +static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
> +       &vcpu_sbi_ext_v01,
> +};
> +
> +void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>
> @@ -71,126 +82,6 @@ int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
>         return 0;
>  }
>
> -#ifdef CONFIG_RISCV_SBI_V01
> -
> -static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
> -                                   struct kvm_run *run, u32 type)
> -{
> -       int i;
> -       struct kvm_vcpu *tmp;
> -
> -       kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> -               tmp->arch.power_off = true;
> -       kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> -
> -       memset(&run->system_event, 0, sizeof(run->system_event));
> -       run->system_event.type = type;
> -       run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> -}
> -
> -static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                                     unsigned long *out_val,
> -                                     struct kvm_cpu_trap *utrap,
> -                                     bool *exit)
> -{
> -       ulong hmask;
> -       int i, ret = 0;
> -       u64 next_cycle;
> -       struct kvm_vcpu *rvcpu;
> -       struct cpumask cm, hm;
> -       struct kvm *kvm = vcpu->kvm;
> -       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> -
> -       if (!cp)
> -               return -EINVAL;
> -
> -       switch (cp->a7) {
> -       case SBI_EXT_0_1_CONSOLE_GETCHAR:
> -       case SBI_EXT_0_1_CONSOLE_PUTCHAR:
> -               /*
> -                * The CONSOLE_GETCHAR/CONSOLE_PUTCHAR SBI calls cannot be
> -                * handled in kernel so we forward these to user-space
> -                */
> -               kvm_riscv_vcpu_sbi_forward(vcpu, run);
> -               *exit = true;
> -               break;
> -       case SBI_EXT_0_1_SET_TIMER:
> -#if __riscv_xlen == 32
> -               next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
> -#else
> -               next_cycle = (u64)cp->a0;
> -#endif
> -               ret = kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
> -               break;
> -       case SBI_EXT_0_1_CLEAR_IPI:
> -               ret = kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
> -               break;
> -       case SBI_EXT_0_1_SEND_IPI:
> -               if (cp->a0)
> -                       hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> -                                                          utrap);
> -               else
> -                       hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> -               if (utrap->scause)
> -                       break;
> -
> -               for_each_set_bit(i, &hmask, BITS_PER_LONG) {
> -                       rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
> -                       ret = kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
> -                       if (ret < 0)
> -                               break;
> -               }
> -               break;
> -       case SBI_EXT_0_1_SHUTDOWN:
> -               kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
> -               *exit = true;
> -               break;
> -       case SBI_EXT_0_1_REMOTE_FENCE_I:
> -       case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
> -       case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
> -               if (cp->a0)
> -                       hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> -                                                          utrap);
> -               else
> -                       hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> -               if (utrap->scause)
> -                       break;
> -
> -               cpumask_clear(&cm);
> -               for_each_set_bit(i, &hmask, BITS_PER_LONG) {
> -                       rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
> -                       if (rvcpu->cpu < 0)
> -                               continue;
> -                       cpumask_set_cpu(rvcpu->cpu, &cm);
> -               }
> -               riscv_cpuid_to_hartid_mask(&cm, &hm);
> -               if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
> -                       ret = sbi_remote_fence_i(cpumask_bits(&hm));
> -               else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA)
> -                       ret = sbi_remote_hfence_vvma(cpumask_bits(&hm),
> -                                               cp->a1, cp->a2);
> -               else
> -                       ret = sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
> -                                               cp->a1, cp->a2, cp->a3);
> -               break;
> -       default:
> -               ret = -EINVAL;
> -               break;
> -       }
> -
> -       return ret;
> -}
> -
> -const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
> -       .extid_start = SBI_EXT_0_1_SET_TIMER,
> -       .extid_end = SBI_EXT_0_1_SHUTDOWN,
> -       .handler = kvm_sbi_ext_v01_handler,
> -};
> -
> -static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
> -       &vcpu_sbi_ext_v01,
> -};
> -
>  const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid)
>  {
>         int i = 0;
> @@ -220,9 +111,11 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>
>         sbi_ext = kvm_vcpu_sbi_find_ext(cp->a7);
>         if (sbi_ext && sbi_ext->handler) {
> +#ifdef CONFIG_RISCV_SBI_V01
>                 if (cp->a7 >= SBI_EXT_0_1_SET_TIMER &&
>                     cp->a7 <= SBI_EXT_0_1_SHUTDOWN)
>                         ext_is_v01 = true;
> +#endif
>                 ret = sbi_ext->handler(vcpu, run, &out_val, &utrap, &userspace_exit);
>         } else {
>                 /* Return error for unsupported SBI calls */
> @@ -262,13 +155,3 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>
>         return ret;
>  }
> -
> -#else
> -
> -int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> -{
> -       kvm_riscv_vcpu_sbi_forward(vcpu, run);
> -       return 0;
> -}
> -
> -#endif
> diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
> new file mode 100644
> index 000000000000..5a8e2afc8a57
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_v01.c
> @@ -0,0 +1,129 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2021 Western Digital Corporation or its affiliates.
> + *
> + * Authors:
> + *     Atish Patra <atish.patra@wdc.com>
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/kvm_host.h>
> +#include <asm/csr.h>
> +#include <asm/sbi.h>
> +#include <asm/kvm_vcpu_timer.h>
> +#include <asm/kvm_vcpu_sbi.h>
> +
> +static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
> +                                   struct kvm_run *run, u32 type)
> +{
> +       int i;
> +       struct kvm_vcpu *tmp;
> +
> +       kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> +               tmp->arch.power_off = true;
> +       kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> +
> +       memset(&run->system_event, 0, sizeof(run->system_event));
> +       run->system_event.type = type;
> +       run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +}
> +
> +static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +                                     unsigned long *out_val,
> +                                     struct kvm_cpu_trap *utrap,
> +                                     bool *exit)
> +{
> +       ulong hmask;
> +       int i, ret = 0;
> +       u64 next_cycle;
> +       struct kvm_vcpu *rvcpu;
> +       struct cpumask cm, hm;
> +       struct kvm *kvm = vcpu->kvm;
> +       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +
> +       if (!cp)
> +               return -EINVAL;

This check on "cp" is unnecessary.

> +
> +       switch (cp->a7) {
> +       case SBI_EXT_0_1_CONSOLE_GETCHAR:
> +       case SBI_EXT_0_1_CONSOLE_PUTCHAR:
> +               /*
> +                * The CONSOLE_GETCHAR/CONSOLE_PUTCHAR SBI calls cannot be
> +                * handled in kernel so we forward these to user-space
> +                */
> +               kvm_riscv_vcpu_sbi_forward(vcpu, run);
> +               *exit = true;
> +               break;
> +       case SBI_EXT_0_1_SET_TIMER:
> +#if __riscv_xlen == 32
> +               next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
> +#else
> +               next_cycle = (u64)cp->a0;
> +#endif
> +               ret = kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
> +               break;
> +       case SBI_EXT_0_1_CLEAR_IPI:
> +               ret = kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
> +               break;
> +       case SBI_EXT_0_1_SEND_IPI:
> +               if (cp->a0)
> +                       hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> +                                                          utrap);
> +               else
> +                       hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> +               if (utrap->scause)
> +                       break;
> +
> +               for_each_set_bit(i, &hmask, BITS_PER_LONG) {
> +                       rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
> +                       ret = kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
> +                       if (ret < 0)
> +                               break;
> +               }
> +               break;
> +       case SBI_EXT_0_1_SHUTDOWN:
> +               kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
> +               *exit = true;
> +               break;
> +       case SBI_EXT_0_1_REMOTE_FENCE_I:
> +       case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
> +       case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
> +               if (cp->a0)
> +                       hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> +                                                          utrap);
> +               else
> +                       hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> +               if (utrap->scause)
> +                       break;
> +
> +               cpumask_clear(&cm);
> +               for_each_set_bit(i, &hmask, BITS_PER_LONG) {
> +                       rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
> +                       if (rvcpu->cpu < 0)
> +                               continue;
> +                       cpumask_set_cpu(rvcpu->cpu, &cm);
> +               }
> +               riscv_cpuid_to_hartid_mask(&cm, &hm);
> +               if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
> +                       ret = sbi_remote_fence_i(cpumask_bits(&hm));
> +               else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA)
> +                       ret = sbi_remote_hfence_vvma(cpumask_bits(&hm),
> +                                               cp->a1, cp->a2);
> +               else
> +                       ret = sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
> +                                               cp->a1, cp->a2, cp->a3);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +               break;
> +       };
> +
> +       return ret;
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
> +       .extid_start = SBI_EXT_0_1_SET_TIMER,
> +       .extid_end = SBI_EXT_0_1_SHUTDOWN,
> +       .handler = kvm_sbi_ext_v01_handler,
> +};
> --
> 2.31.1
>

Otherwise it looks good to me.

Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup
