Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3614D459D5D
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 09:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbhKWIGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 03:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbhKWIGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 03:06:44 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5DEC061714
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 00:03:36 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id c4so37329620wrd.9
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 00:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nTNgdmZ9wB/Gxu8oMf7Ub084hMMsDwJb0gLTfiLVOpU=;
        b=CIw9iIkTZyLu/hfw0VAvt3Sb2X6b4R6xVkYDNorbOb6BrdjuwNPsO/SPWi0rGhRMOc
         u424Aq0BYoP+unYRLh8TOP2MHhb/Dkse/wpxBIc+RN/mvi5/uRqmlUotgjGkmKfXn5Rw
         mFZOZVZtZwetJesLceCk8017PP18wxla6jz95V+3juZ7mqJ0tLC7NqBPn+miEHRYe+pc
         Fj9HW8s4xQOX1ka0ERAUK5eAfb/2/n5zu0GGLwC1Vtc6h02LwCEV8QXHPb3vtUQSvQw0
         kXclxnSTLiGkaH4Zvq6zIuEeR0wSHhnE1wR7z061YVp440RL6KXvRfKQ37LeO0RyImTi
         fkHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nTNgdmZ9wB/Gxu8oMf7Ub084hMMsDwJb0gLTfiLVOpU=;
        b=ySrb+JvkWhKTXi70bmumez85KfOdf6XQX3Ji/EHAgtxrcWqANc55jQSVKmpKF4Fpg5
         0CPuHrllnE/B/PcJeIx1XzLXP5GzlIvAtxanNUZ6YCgGpFqnlmYAh52u0eQCG+MZHKKg
         lku44tgbEt70fyot7O6ctEyinm/RPwrY1bWHIO8B6mZd2T59kRAwdZ5cs959aF0fqib+
         igF1BOf3lG3lXM2B8K8OCQLNXe6xD2Hrxv/ufQfb+FI0zeQp+iuR2oXaDNnBRUyRrePN
         ftW539klIvuj6egap1C25CQSu2dV+MSIegJvE8TBcti4Te034FrVlu8ocEBalvarvRUu
         uG7Q==
X-Gm-Message-State: AOAM533XMPQctfNmC4SvdSwpYr3uMrxlo3A92OJl7oXtMQ8+N92Z4aG5
        Bg+HVQyYqZlUrYT28K4OoYZ9FYQ+ayaY8R0Wc7hgzA==
X-Google-Smtp-Source: ABdhPJwqfFq6Kr3GoEK347Js9vj5hVc3xSOZTyxcCnjkoFM/qVHH23h3vMRZf+EOATwSFAxiA6xpJeRMA8rkQ3gCxws=
X-Received: by 2002:adf:8165:: with SMTP id 92mr5086376wrm.199.1637654613464;
 Tue, 23 Nov 2021 00:03:33 -0800 (PST)
MIME-Version: 1.0
References: <20211118083912.981995-1-atishp@rivosinc.com> <20211118083912.981995-4-atishp@rivosinc.com>
In-Reply-To: <20211118083912.981995-4-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 23 Nov 2021 13:33:21 +0530
Message-ID: <CAAhSdy2hPh-2r6iOs5T7eH3KJO3sMui6Nk+DER2muVssV0jBCA@mail.gmail.com>
Subject: Re: [PATCH v5 3/5] RISC-V: KVM: Add SBI v0.2 base extension
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
> SBI v0.2 base extension defined to allow backward compatibility and
> probing of future extensions. This is also the only mandatory SBI
> extension that must be implemented by SBI implementors.
>
> Reviewed-by: Anup Patel <anup.patel@wdc.com>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

I have queued this for 5.17

Thanks,
Anup

> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  2 +
>  arch/riscv/include/asm/sbi.h          |  8 +++
>  arch/riscv/kvm/Makefile               |  1 +
>  arch/riscv/kvm/vcpu_sbi.c             |  3 +-
>  arch/riscv/kvm/vcpu_sbi_base.c        | 70 +++++++++++++++++++++++++++
>  5 files changed, 83 insertions(+), 1 deletion(-)
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_base.c
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 704151969ceb..76e4e17a3e00 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -9,6 +9,8 @@
>  #ifndef __RISCV_KVM_VCPU_SBI_H__
>  #define __RISCV_KVM_VCPU_SBI_H__
>
> +#define KVM_SBI_IMPID 3
> +
>  #define KVM_SBI_VERSION_MAJOR 0
>  #define KVM_SBI_VERSION_MINOR 2
>
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 0d42693cb65e..4f9370b6032e 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -27,6 +27,14 @@ enum sbi_ext_id {
>         SBI_EXT_IPI = 0x735049,
>         SBI_EXT_RFENCE = 0x52464E43,
>         SBI_EXT_HSM = 0x48534D,
> +
> +       /* Experimentals extensions must lie within this range */
> +       SBI_EXT_EXPERIMENTAL_START = 0x0800000,
> +       SBI_EXT_EXPERIMENTAL_END = 0x08FFFFFF,
> +
> +       /* Vendor extensions must lie within this range */
> +       SBI_EXT_VENDOR_START = 0x09000000,
> +       SBI_EXT_VENDOR_END = 0x09FFFFFF,
>  };
>
>  enum sbi_ext_base_fid {
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index d3d5ff3a6019..84c02922a329 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -24,4 +24,5 @@ kvm-y += vcpu_fp.o
>  kvm-y += vcpu_switch.o
>  kvm-y += vcpu_sbi.o
>  kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
> +kvm-y += vcpu_sbi_base.o
>  kvm-y += vcpu_timer.o
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index a8e0191cd9fc..915a044a0b4f 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -39,9 +39,10 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
>         .handler = NULL,
>  };
>  #endif
> -
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
>  static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
>         &vcpu_sbi_ext_v01,
> +       &vcpu_sbi_ext_base,
>  };
>
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
> diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> new file mode 100644
> index 000000000000..641015549d12
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> @@ -0,0 +1,70 @@
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
> +static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +                                   unsigned long *out_val,
> +                                   struct kvm_cpu_trap *trap, bool *exit)
> +{
> +       int ret = 0;
> +       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +       struct sbiret ecall_ret;
> +
> +       switch (cp->a6) {
> +       case SBI_EXT_BASE_GET_SPEC_VERSION:
> +               *out_val = (KVM_SBI_VERSION_MAJOR <<
> +                           SBI_SPEC_VERSION_MAJOR_SHIFT) |
> +                           KVM_SBI_VERSION_MINOR;
> +               break;
> +       case SBI_EXT_BASE_GET_IMP_ID:
> +               *out_val = KVM_SBI_IMPID;
> +               break;
> +       case SBI_EXT_BASE_GET_IMP_VERSION:
> +               *out_val = 0;
> +               break;
> +       case SBI_EXT_BASE_PROBE_EXT:
> +               *out_val = kvm_vcpu_sbi_find_ext(cp->a0) ? 1 : 0;
> +               if ((!*out_val) &&
> +                   ((cp->a0 >= SBI_EXT_EXPERIMENTAL_START &&
> +                    cp->a0 <= SBI_EXT_EXPERIMENTAL_END) ||
> +                   ((cp->a0 >= SBI_EXT_VENDOR_START &&
> +                    cp->a0 <= SBI_EXT_VENDOR_END)))) {
> +               /* For experimental/vendor extensions forward to the userspace*/
> +                       kvm_riscv_vcpu_sbi_forward(vcpu, run);
> +                       *exit = true;
> +               }
> +               break;
> +       case SBI_EXT_BASE_GET_MVENDORID:
> +       case SBI_EXT_BASE_GET_MARCHID:
> +       case SBI_EXT_BASE_GET_MIMPID:
> +               ecall_ret = sbi_ecall(SBI_EXT_BASE, cp->a6, 0, 0, 0, 0, 0, 0);
> +               if (!ecall_ret.error)
> +                       *out_val = ecall_ret.value;
> +               /*TODO: We are unnecessarily converting the error twice */
> +               ret = sbi_err_map_linux_errno(ecall_ret.error);
> +               break;
> +       default:
> +               ret = -EOPNOTSUPP;
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base = {
> +       .extid_start = SBI_EXT_BASE,
> +       .extid_end = SBI_EXT_BASE,
> +       .handler = kvm_sbi_ext_base_handler,
> +};
> --
> 2.33.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
