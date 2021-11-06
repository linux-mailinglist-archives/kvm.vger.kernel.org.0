Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2082446C63
	for <lists+kvm@lfdr.de>; Sat,  6 Nov 2021 05:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbhKFEtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Nov 2021 00:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhKFEto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Nov 2021 00:49:44 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184A7C061570
        for <kvm@vger.kernel.org>; Fri,  5 Nov 2021 21:47:04 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id y196so8688948wmc.3
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 21:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8JhUKWBzUY5wx+JAyqtXWGvq745sL3nVjpcKRuZpRto=;
        b=yGHDErqQ3tVK9oyBmBNouGiNlZDvOuAwbZD0jWb64aWVDrbfojyN6hNohhWJ1/Td4b
         aaz0rGBUql7ThIt5JnRoep9M0FZldDYrtgbEtDKSN2sWQBlKBjS3pMA8hWGXbOdY64OC
         ic+ap8+tdi8rI6dPCPSBXkKv8nA5pYkwWrvazXoNrPCRBx4LdrdRex38wf/im6jpKc3+
         Dh5AjRC2pHxYcTe3hPy5hCnUJrmVO9oBjT+zscHWFOxfvCF3AvZUPKHhOHWQJtykm3x2
         oQfk4WGk1BtpPirTbIJlcjk0URhVAOIUPOYOTlNhAxrwngvJab6T1B8dj5K2UPJUNkXw
         Qadw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8JhUKWBzUY5wx+JAyqtXWGvq745sL3nVjpcKRuZpRto=;
        b=Niy2Rp3C2cB1NNSxKnvQvrZxfA5chCgQKdA8EQMVt8RlF3dTjMAMIg1zpcYfd9N5WK
         vJm4gAhZD790BQd/jWHYF5W1TBEoysby/lXWacDZDTQ6mVgnPJ2WFPGBH9kPLITrBZRR
         Ha92FOcCGqkzmVflkWSy5JwSS0hY+XZ0CWuYChiBV6MZY3bdjwnoD5mwQf/BPKQLFhm7
         gj+sG6OLn25P4AXXwz2P0Ttiwxjw1z8LI26snpq5JlzwlnT6YXNimRLiDy5hB7cw7myL
         yjTdnwj2+FsXb0Bg9Re3AdVnh+wisrXO6b8zvpQxiBs9kw01sPy/mUBNMRgw3/QGd6aG
         gHzA==
X-Gm-Message-State: AOAM530zHmdP/I2DfhI+bx5QTEpQPGqPgsLWTKBIbNZSMLD+Fv9YacRA
        rNRb05Fi7uuw9H04kNxWEMFMGTGVRrLYNmP5foCw4A==
X-Google-Smtp-Source: ABdhPJxsU7YNzgZsM0edzAeRENYydGjzXIRfpYv6eoSjiSe/hsTq95UbUGh8MEiumpgkHxchPi774IYqf3LvQ8JiJpM=
X-Received: by 2002:a1c:7201:: with SMTP id n1mr35850998wmc.176.1636174022562;
 Fri, 05 Nov 2021 21:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <20211105235852.3011900-1-atish.patra@wdc.com> <20211105235852.3011900-5-atish.patra@wdc.com>
In-Reply-To: <20211105235852.3011900-5-atish.patra@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 6 Nov 2021 10:16:51 +0530
Message-ID: <CAAhSdy0-079N2QQQg7bB=WiU3uZWXaGs1imGZJ6y36eXpnaBnA@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] RISC-V: KVM: Add v0.1 replacement SBI extensions
 defined in v02
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
> The SBI v0.2 contains some of the improved versions of required v0.1
> extensions such as remote fence, timer and IPI.
>
> This patch implements those extensions.
>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> ---
>  arch/riscv/kvm/Makefile           |   1 +
>  arch/riscv/kvm/vcpu_sbi.c         |   7 ++
>  arch/riscv/kvm/vcpu_sbi_replace.c | 136 ++++++++++++++++++++++++++++++
>  3 files changed, 144 insertions(+)
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_replace.c
>
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 84c02922a329..4757ae158bf3 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -25,4 +25,5 @@ kvm-y += vcpu_switch.o
>  kvm-y += vcpu_sbi.o
>  kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
>  kvm-y += vcpu_sbi_base.o
> +kvm-y += vcpu_sbi_replace.o
>  kvm-y += vcpu_timer.o
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 92b682f4f29e..3502c6166eba 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -40,9 +40,16 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
>  };
>  #endif
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time;
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
> +
>  static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
>         &vcpu_sbi_ext_v01,
>         &vcpu_sbi_ext_base,
> +       &vcpu_sbi_ext_time,
> +       &vcpu_sbi_ext_ipi,
> +       &vcpu_sbi_ext_rfence,
>  };
>
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
> diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
> new file mode 100644
> index 000000000000..a80fa7691b14
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> @@ -0,0 +1,136 @@
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
> +static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +                                   unsigned long *out_val,
> +                                   struct kvm_cpu_trap *utrap, bool *exit)
> +{
> +       int ret = 0;
> +       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +       u64 next_cycle;
> +
> +       if (!cp || (cp->a6 != SBI_EXT_TIME_SET_TIMER))
> +               return -EINVAL;
> +
> +#if __riscv_xlen == 32
> +       next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
> +#else
> +       next_cycle = (u64)cp->a0;
> +#endif
> +       kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
> +
> +       return ret;
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time = {
> +       .extid_start = SBI_EXT_TIME,
> +       .extid_end = SBI_EXT_TIME,
> +       .handler = kvm_sbi_ext_time_handler,
> +};
> +
> +static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +                                  unsigned long *out_val,
> +                                  struct kvm_cpu_trap *utrap, bool *exit)
> +{
> +       int i, ret = 0;
> +       struct kvm_vcpu *tmp;
> +       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +       unsigned long hmask = cp->a0;
> +       unsigned long hbase = cp->a1;
> +
> +       if (!cp || (cp->a6 != SBI_EXT_IPI_SEND_IPI))
> +               return -EINVAL;
> +
> +       kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> +               if (hbase != -1UL) {
> +                       if (tmp->vcpu_id < hbase)
> +                               continue;
> +                       if (!(hmask & (1UL << (tmp->vcpu_id - hbase))))
> +                               continue;
> +               }
> +               ret = kvm_riscv_vcpu_set_interrupt(tmp, IRQ_VS_SOFT);
> +               if (ret < 0)
> +                       break;
> +       }
> +
> +       return ret;
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi = {
> +       .extid_start = SBI_EXT_IPI,
> +       .extid_end = SBI_EXT_IPI,
> +       .handler = kvm_sbi_ext_ipi_handler,
> +};
> +
> +static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +                                     unsigned long *out_val,
> +                                     struct kvm_cpu_trap *utrap, bool *exit)
> +{
> +       int i, ret = 0;
> +       struct cpumask cm, hm;
> +       struct kvm_vcpu *tmp;
> +       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +       unsigned long hmask = cp->a0;
> +       unsigned long hbase = cp->a1;
> +       unsigned long funcid = cp->a6;
> +
> +       if (!cp)
> +               return -EINVAL;
> +
> +       cpumask_clear(&cm);
> +       cpumask_clear(&hm);
> +       kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> +               if (hbase != -1UL) {
> +                       if (tmp->vcpu_id < hbase)
> +                               continue;
> +                       if (!(hmask & (1UL << (tmp->vcpu_id - hbase))))
> +                               continue;
> +               }
> +               if (tmp->cpu < 0)
> +                       continue;
> +               cpumask_set_cpu(tmp->cpu, &cm);
> +       }
> +
> +       riscv_cpuid_to_hartid_mask(&cm, &hm);
> +
> +       switch (funcid) {
> +       case SBI_EXT_RFENCE_REMOTE_FENCE_I:
> +               ret = sbi_remote_fence_i(cpumask_bits(&hm));
> +               break;
> +       case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
> +               ret = sbi_remote_hfence_vvma(cpumask_bits(&hm), cp->a2, cp->a3);
> +               break;
> +       case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
> +               ret = sbi_remote_hfence_vvma_asid(cpumask_bits(&hm), cp->a2,
> +                                                 cp->a3, cp->a4);
> +               break;
> +       case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA:
> +       case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID:
> +       case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA:
> +       case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID:
> +       /* TODO: implement for nested hypervisor case */
> +       default:
> +               ret = -EOPNOTSUPP;
> +       }
> +
> +       return ret;
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence = {
> +       .extid_start = SBI_EXT_RFENCE,
> +       .extid_end = SBI_EXT_RFENCE,
> +       .handler = kvm_sbi_ext_rfence_handler,
> +};
> --
> 2.31.1
>

Drop checks on "cp" pointer in various functions above.

Otherwise it looks good to me.

Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup
