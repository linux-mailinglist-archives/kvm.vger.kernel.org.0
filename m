Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B996143909B
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 09:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhJYHzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 03:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhJYHzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 03:55:45 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A769C061745
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 00:53:23 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e4so11167149wrc.7
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 00:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PY7OImfFW1P8bQ0QlvHwXkZR2vZcIxhaTifA9ufJ8P4=;
        b=tl6PAuFwmzuHDpVrtoEOFdfzpUz4WGHJumUuIyVy43BBxGE3x2DFL/Z8Yk56HcwzKk
         xNqTrUmHHgu5zWuNYYcaxRARTao+zoXyxefMbnmrycezy5M4+9Dp+r1sCe78Y73p7Vd5
         WQFUh/FdrxqhgDCsnwZGFt6gmLuuXUqyQEy5o1Ql7ZfEsRvJ9AicyZgyJW7TEbjNtWO/
         8BO9VPtLpgJ+WZBbuTqjxRbDbL26W8jJ6V69z2jD9zJ1cBkLhSPh/QgUMZtVLvrMgmsE
         Nr/F1oa2+2XY/YAzN6GXpgfTPvw5o8khjo9IMysQe/D+25pvt1m4cPa74qJC2nGcTFa7
         QI4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PY7OImfFW1P8bQ0QlvHwXkZR2vZcIxhaTifA9ufJ8P4=;
        b=ZfSouThnM8C85bvhh7ZNtPmtRRaJ7f+MOZOJWbqPHZ0ENCXxXwCLmnjPcfTP01Vs3G
         afIcmVRI5wguMsCdKjp9BplrfxX2zD+A+qb57ixsQTWfJP2c8pVX5kkwHLdPZc85ZUvb
         vuFF/K/S349Z0CT88ThSw6kCdTntFhq1CAm9PGGqDgiuUVtU0OSiqM5pPB7x0usd23DE
         oiTRDNW3vrGMkXhQmrYiBUEvnHQR687GrkAZ039Ju0ExCD7Dho49Yh44NPBIP0TWFOq+
         jPdQq+08gvY83MmpWo8s3Z/xr9hXQAc72cJ05Od+ZYLk/23I4d1Ti6Ia81lad12HLHev
         rDHQ==
X-Gm-Message-State: AOAM531fhYqrPq+uSwGEgCGsiWRHy02Lq8ktPNfCxUNEir2CUTY54gcO
        Bf1UeXxX3KTv6pVq7c6olSSW5+7ANyEEFqszkGvqWQ==
X-Google-Smtp-Source: ABdhPJz6XFwHX4gF7AJsr/wjpA1dcgU7x3MQz4X9XMueINN1pYaIgzVg5wQVlnoaawxzU0i5CVeuceHYlqvQYOycT44=
X-Received: by 2002:adf:ce09:: with SMTP id p9mr21578993wrn.363.1635148401689;
 Mon, 25 Oct 2021 00:53:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211008032036.2201971-1-atish.patra@wdc.com> <20211008032036.2201971-2-atish.patra@wdc.com>
In-Reply-To: <20211008032036.2201971-2-atish.patra@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 25 Oct 2021 13:23:10 +0530
Message-ID: <CAAhSdy2gdUfgMn0B-z8tpsNbqdZDnN_dEfa=TB6TsLbu7uskfg@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] RISC-V: Mark the existing SBI v0.1 implementation
 as legacy
To:     Atish Patra <atish.patra@wdc.com>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <anup.patel@wdc.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 8, 2021 at 8:50 AM Atish Patra <atish.patra@wdc.com> wrote:
>
> The existing SBI specification impelementation follows v0.1 or legacy
> specification. The latest specification known as v0.2 allows more
> scalability and performance improvements.
>
> Rename the existing implementation as legacy and provide a way to allow
> future extensions.
>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  29 +++++
>  arch/riscv/kvm/vcpu_sbi.c             | 149 ++++++++++++++++++++------
>  2 files changed, 148 insertions(+), 30 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi.h
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> new file mode 100644
> index 000000000000..1a4cb0db2d0b
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/**
> + * Copyright (c) 2021 Western Digital Corporation or its affiliates.
> + *
> + * Authors:
> + *     Atish Patra <atish.patra@wdc.com>
> + */
> +
> +#ifndef __RISCV_KVM_VCPU_SBI_H__
> +#define __RISCV_KVM_VCPU_SBI_H__
> +
> +#define KVM_SBI_VERSION_MAJOR 0
> +#define KVM_SBI_VERSION_MINOR 2
> +
> +struct kvm_vcpu_sbi_extension {
> +       unsigned long extid_start;
> +       unsigned long extid_end;
> +       /**
> +        * SBI extension handler. It can be defined for a given extension or group of
> +        * extension. But it should always return linux error codes rather than SBI
> +        * specific error codes.
> +        */
> +       int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +                      unsigned long *out_val, struct kvm_cpu_trap *utrap,
> +                      bool *exit);
> +};
> +
> +const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
> +#endif /* __RISCV_KVM_VCPU_SBI_H__ */
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index ebdcdbade9c6..8c168d305763 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -12,9 +12,25 @@
>  #include <asm/csr.h>
>  #include <asm/sbi.h>
>  #include <asm/kvm_vcpu_timer.h>
> +#include <asm/kvm_vcpu_sbi.h>
>
> -#define SBI_VERSION_MAJOR                      0
> -#define SBI_VERSION_MINOR                      1
> +static int kvm_linux_err_map_sbi(int err)
> +{
> +       switch (err) {
> +       case 0:
> +               return SBI_SUCCESS;
> +       case -EPERM:
> +               return SBI_ERR_DENIED;
> +       case -EINVAL:
> +               return SBI_ERR_INVALID_PARAM;
> +       case -EFAULT:
> +               return SBI_ERR_INVALID_ADDRESS;
> +       case -EOPNOTSUPP:
> +               return SBI_ERR_NOT_SUPPORTED;
> +       default:
> +               return SBI_ERR_FAILURE;
> +       };
> +}
>
>  static void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu,
>                                        struct kvm_run *run)
> @@ -72,16 +88,17 @@ static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
>         run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
>  }
>
> -int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +static int kvm_sbi_ext_legacy_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +                                     unsigned long *out_val,
> +                                     struct kvm_cpu_trap *utrap,
> +                                     bool *exit)
>  {
>         ulong hmask;
> -       int i, ret = 1;
> +       int i, ret = 0;
>         u64 next_cycle;
>         struct kvm_vcpu *rvcpu;
> -       bool next_sepc = true;
>         struct cpumask cm, hm;
>         struct kvm *kvm = vcpu->kvm;
> -       struct kvm_cpu_trap utrap = { 0 };
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>
>         if (!cp)
> @@ -95,8 +112,7 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>                  * handled in kernel so we forward these to user-space
>                  */
>                 kvm_riscv_vcpu_sbi_forward(vcpu, run);
> -               next_sepc = false;
> -               ret = 0;
> +               *exit = true;
>                 break;
>         case SBI_EXT_0_1_SET_TIMER:
>  #if __riscv_xlen == 32
> @@ -104,47 +120,42 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  #else
>                 next_cycle = (u64)cp->a0;
>  #endif
> -               kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
> +               ret = kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
>                 break;
>         case SBI_EXT_0_1_CLEAR_IPI:
> -               kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
> +               ret = kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
>                 break;
>         case SBI_EXT_0_1_SEND_IPI:
>                 if (cp->a0)
>                         hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> -                                                          &utrap);
> +                                                          utrap);
>                 else
>                         hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> -               if (utrap.scause) {
> -                       utrap.sepc = cp->sepc;
> -                       kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> -                       next_sepc = false;
> +               if (utrap->scause)
>                         break;
> -               }
> +
>                 for_each_set_bit(i, &hmask, BITS_PER_LONG) {
>                         rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
> -                       kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
> +                       ret = kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
> +                       if (ret < 0)
> +                               break;
>                 }
>                 break;
>         case SBI_EXT_0_1_SHUTDOWN:
>                 kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
> -               next_sepc = false;
> -               ret = 0;
> +               *exit = true;
>                 break;
>         case SBI_EXT_0_1_REMOTE_FENCE_I:
>         case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
>         case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
>                 if (cp->a0)
>                         hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> -                                                          &utrap);
> +                                                          utrap);
>                 else
>                         hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> -               if (utrap.scause) {
> -                       utrap.sepc = cp->sepc;
> -                       kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> -                       next_sepc = false;
> +               if (utrap->scause)
>                         break;
> -               }
> +
>                 cpumask_clear(&cm);
>                 for_each_set_bit(i, &hmask, BITS_PER_LONG) {
>                         rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
> @@ -154,22 +165,100 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>                 }
>                 riscv_cpuid_to_hartid_mask(&cm, &hm);
>                 if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
> -                       sbi_remote_fence_i(cpumask_bits(&hm));
> +                       ret = sbi_remote_fence_i(cpumask_bits(&hm));
>                 else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA)
> -                       sbi_remote_hfence_vvma(cpumask_bits(&hm),
> +                       ret = sbi_remote_hfence_vvma(cpumask_bits(&hm),
>                                                 cp->a1, cp->a2);
>                 else
> -                       sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
> +                       ret = sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
>                                                 cp->a1, cp->a2, cp->a3);
>                 break;
>         default:
> -               /* Return error for unsupported SBI calls */
> -               cp->a0 = SBI_ERR_NOT_SUPPORTED;
> +               ret = -EINVAL;
>                 break;
>         };
>
> +       return ret;
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_legacy = {
> +       .extid_start = SBI_EXT_0_1_SET_TIMER,
> +       .extid_end = SBI_EXT_0_1_SHUTDOWN,
> +       .handler = kvm_sbi_ext_legacy_handler,
> +};
> +
> +static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
> +       &vcpu_sbi_ext_legacy,
> +};
> +
> +const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid)
> +{
> +       int i = 0;
> +
> +       for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
> +               if (sbi_ext[i]->extid_start <= extid &&
> +                   sbi_ext[i]->extid_end >= extid)
> +                       return sbi_ext[i];
> +       }
> +
> +       return NULL;
> +}
> +
> +int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +       int ret = 1;
> +       bool next_sepc = true;
> +       bool userspace_exit = false;
> +       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +       const struct kvm_vcpu_sbi_extension *sbi_ext;
> +       struct kvm_cpu_trap utrap = { 0 };
> +       unsigned long out_val = 0;
> +       bool ext_is_v01 = false;
> +
> +       if (!cp)
> +               return -EINVAL;

This is a redundant check because cp is always non-NULL.

> +
> +       sbi_ext = kvm_vcpu_sbi_find_ext(cp->a7);
> +       if (sbi_ext && sbi_ext->handler) {
> +               if (cp->a7 >= SBI_EXT_0_1_SET_TIMER &&
> +                   cp->a7 <= SBI_EXT_0_1_SHUTDOWN)
> +                       ext_is_v01 = true;
> +               ret = sbi_ext->handler(vcpu, run, &out_val, &utrap, &userspace_exit);
> +       } else {
> +               /* Return error for unsupported SBI calls */
> +               cp->a0 = SBI_ERR_NOT_SUPPORTED;
> +               goto ecall_done;
> +       }
> +
> +       /* Handle special error cases i.e trap, exit or userspace forward */
> +       if (utrap.scause) {
> +               /* No need to increment sepc or exit ioctl loop */
> +               ret = 1;
> +               utrap.sepc = cp->sepc;
> +               kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> +               next_sepc = false;
> +               goto ecall_done;
> +       }
> +
> +       /* Exit ioctl loop or Propagate the error code the guest */
> +       if (userspace_exit) {
> +               next_sepc = false;
> +               ret = 0;
> +       } else {
> +               /**
> +                * SBI extension handler always returns an Linux error code. Convert
> +                * it to the SBI specific error code that can be propagated the SBI
> +                * caller.
> +                */
> +               ret = kvm_linux_err_map_sbi(ret);
> +               cp->a0 = ret;
> +               ret = 1;
> +       }
> +ecall_done:
>         if (next_sepc)
>                 cp->sepc += 4;
> +       if (!ext_is_v01)
> +               cp->a1 = out_val;
>
>         return ret;
>  }
> --
> 2.31.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

Regards,
Anup
