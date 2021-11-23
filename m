Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA13A459D5F
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 09:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbhKWIHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 03:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbhKWIHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 03:07:10 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0E8C061574
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 00:04:03 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so1804033wme.4
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 00:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gCnCMlc4Bhw9UQ32N6qApy4OYSSYIVwFQqMyLza5Bik=;
        b=TZAz2AeNn/23X1gjznTOWc2ZraSySk2TdLVJflwdH9vx/O54sP4+BJJLAqYoDUuJMN
         LxFWRVVj4qdvyHTy5H7teVzjb1NkRhvhHQRZjw+5Rp5CgQ9ZgC4s2+ZCgHyU9rpx4jcD
         3myQrOh5n3UnPJx05uLz1nkPfobkHvOi/5sqNnmS7gCHzeen62t6Jct/HoXTlN+9+n/E
         j00ldy0Ju4uENr20gqJd+qTb5U3q7HlC5W4qVkRKdS80z1yWdLguidsx8XDpacdLFwCM
         jMvvAWPNmh5E89HdvDFvYosf+1tGPj0KnFXCmLetGeJ/HenmxGEMzGJUHO/XbLLQSkkX
         PcWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gCnCMlc4Bhw9UQ32N6qApy4OYSSYIVwFQqMyLza5Bik=;
        b=snL5SRFoscyMSVkkYz6dkumLewuJLUlLS0964tc+yoXeGuIj9Znk1pAcCdkSk0/H5n
         Dc6pn4szUuZXR8Q97oW7sUTk1CEpGnrLy1mzh6G6dNq7NL1lRS+VJ8F/StT87Rs/Rusy
         92W5AHnRNKqn0IY3ioNybTTgpTkpgQ+sUPuVSYTB19s249zf84ZI4Q3O2cCCga0Uwc5v
         2dQZ/WM1dAUwQA8/VCYup0uVj0DXpffdl7Vkn5cS8D/nKOpqpiD9cnQizkNoLW2ZyEph
         UrnTJoj1GmP3uU0xZBkaC+F1F5ZizZAk++HTw11FsDulvHivT44PCAg8mKJP4Pzfz7QU
         Pniw==
X-Gm-Message-State: AOAM531KDGd8qRzeVU7YgQXvNyELXTgeaeVcLNUzaoqgJmqyhJojOGb4
        Edt/35bkcPfYUE3xYzwnpYXrITyc9QXakmpnOemxSg==
X-Google-Smtp-Source: ABdhPJyAIwL9vABpW5ot/1B5KmNzIMarHU9hh3xe4WVG4z4uXSdu5AXtXk2ScDyzcEmNUs3J1rLD9nYTdCtHgPKWr6Q=
X-Received: by 2002:a05:600c:354f:: with SMTP id i15mr646798wmq.59.1637654641549;
 Tue, 23 Nov 2021 00:04:01 -0800 (PST)
MIME-Version: 1.0
References: <20211118083912.981995-1-atishp@rivosinc.com> <20211118083912.981995-5-atishp@rivosinc.com>
In-Reply-To: <20211118083912.981995-5-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 23 Nov 2021 13:33:50 +0530
Message-ID: <CAAhSdy2yZcNBXt00jqLKc2g+SeiytmefzTP=4OPO9f_bXtv8BA@mail.gmail.com>
Subject: Re: [PATCH v5 4/5] RISC-V: KVM: Add v0.1 replacement SBI extensions
 defined in v02
To:     Atish Patra <atishp@rivosinc.com>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Atish Patra <atish.patra@wdc.com>,
        Anup Patel <anup.patel@wdc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021 at 2:10 PM Atish Patra <atishp@rivosinc.com> wrote:
>
> From: Atish Patra <atish.patra@wdc.com>
>
> The SBI v0.2 contains some of the improved versions of required v0.1
> extensions such as remote fence, timer and IPI.
>
> This patch implements those extensions.
>
> Reviewed-by: Anup Patel <anup.patel@wdc.com>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

I have queued this for 5.17

Thanks,
Anup

> ---
>  arch/riscv/kvm/Makefile           |   1 +
>  arch/riscv/kvm/vcpu_sbi.c         |   7 ++
>  arch/riscv/kvm/vcpu_sbi_replace.c | 133 ++++++++++++++++++++++++++++++
>  3 files changed, 141 insertions(+)
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
> index 915a044a0b4f..cf284e080f3e 100644
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
> index 000000000000..67a64db1efc9
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> @@ -0,0 +1,133 @@
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
> +       if (cp->a6 != SBI_EXT_TIME_SET_TIMER)
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
> +       if (cp->a6 != SBI_EXT_IPI_SEND_IPI)
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
> 2.33.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
