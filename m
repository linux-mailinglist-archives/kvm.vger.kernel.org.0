Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22321446C61
	for <lists+kvm@lfdr.de>; Sat,  6 Nov 2021 05:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbhKFEr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Nov 2021 00:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbhKFEr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Nov 2021 00:47:58 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB81C061714
        for <kvm@vger.kernel.org>; Fri,  5 Nov 2021 21:45:18 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id n29so5113765wra.11
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 21:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SqiIesU3qip9V6xFbDIzRvUoT9ObOdFEau43ovhUSME=;
        b=szvGi0Lene8uMqHuaOf/HKfEr+7hVxehYOKZ4X9NP4tkKpdMILXWokAG+9MatkcQ8v
         TSfNZ2V8hYmuKkj3GI49KOvKY6+nkbP8yxVnhaiNG895PlmaZAYwfX+j+6j8wKcIYhMc
         IIRSEnC1qrBAErcVXpSn3HkSxKTgqI4PDHl9nY6T0jPv6/P/Fmd2QFtpi2CfO0+VbI3d
         B7XvfIq/t4pR1slEUY0On7EzNdXYsJotbVPdccGM1PwtFFIgqgPvzvs0i4UFOj+t702V
         UoLSN2zYj6/FpoXB5c3oqgwbWZT57Vr6wNzqz/gowpaOYuS5WpkfYcAjd/Ze8Fp2Ruma
         hSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SqiIesU3qip9V6xFbDIzRvUoT9ObOdFEau43ovhUSME=;
        b=dT9TrbGCMzhPzRS3P2JzNc6sgOEAa8wgryN7r+zoxPSDm/liX8bPG0lZmYMysP9ay5
         Y1gdKeRt1FCDG7I8zghEkpX7Z0oDZfc5ZLMENZo8s5AVx1jyHPHyn3IEwAGYq0yiKb0h
         pfqx+W0imn7n8UTk4z3it8mDwqFOiT/aR2/Dr1hBr0MwwOuh50X8uOWiWewqfs8y0EMX
         F4kUBGPgXnleqpM2RjX43lAZ5DoqesLHhRDl+twBmTROWz73o9GzcjHUz3xR7dmkaLgJ
         AL/urx8e/lSmF6XZjmmwUlmgRUnCAShiFnJOp2bOUqx/5Ffp65u/DMiU0aedyzkcupf0
         kLmA==
X-Gm-Message-State: AOAM531mCxMOREnvbJgZ6p7ufUwHx2uh0qAG17DrZlLKv3OSkbZLUueL
        XDMo8+hzkHivimlw5a37Q6SAERj3mQ+MjlmoDB/Vkg==
X-Google-Smtp-Source: ABdhPJz28+203b3ojvCcKFq8O7xkMD9S3ToJ0Mckw7V5GM1PWMcwOP1l7m9nDc+lxP/eVUJnq/+5vm7aY270dbeyTF0=
X-Received: by 2002:a05:6000:1a45:: with SMTP id t5mr67340363wry.306.1636173916615;
 Fri, 05 Nov 2021 21:45:16 -0700 (PDT)
MIME-Version: 1.0
References: <20211105235852.3011900-1-atish.patra@wdc.com> <20211105235852.3011900-4-atish.patra@wdc.com>
In-Reply-To: <20211105235852.3011900-4-atish.patra@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 6 Nov 2021 10:15:05 +0530
Message-ID: <CAAhSdy1QrGmyUx8JWx=aTND6JSd89-f1cV_9i6hm_jQa1q0Xkg@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] RISC-V: KVM: Add SBI v0.2 base extension
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
> SBI v0.2 base extension defined to allow backward compatibility and
> probing of future extensions. This is also the only mandatory SBI
> extension that must be implemented by SBI implementors.
>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  2 +
>  arch/riscv/include/asm/sbi.h          |  8 +++
>  arch/riscv/kvm/Makefile               |  1 +
>  arch/riscv/kvm/vcpu_sbi.c             |  3 +-
>  arch/riscv/kvm/vcpu_sbi_base.c        | 73 +++++++++++++++++++++++++++
>  5 files changed, 86 insertions(+), 1 deletion(-)
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
> index 06b42f6977e1..92b682f4f29e 100644
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
> index 000000000000..1aeda3e10e7c
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> @@ -0,0 +1,73 @@
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
> +       if (!cp)
> +               return -EINVAL;

Drop the check on "cp" here.

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
> 2.31.1
>

Otherwise it looks good to me.

Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup
