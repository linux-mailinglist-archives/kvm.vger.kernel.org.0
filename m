Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E866D459D74
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 09:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbhKWIJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 03:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbhKWIJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 03:09:36 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CDFC061714
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 00:06:28 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id u1so37374513wru.13
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 00:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Dc9IyqXO7Wm3+bDtKtLtx9+DbBZ47LkjAeuYVgRscE=;
        b=uyE143lDDpEzHULTmTWN3E6pSz0XnoCTz9jlrWpHMlE6TbfSeOBjEgvIM9577xSgXj
         BBxJ0zrcoG5tqvWdYwTXWCO29y0BUU7yvmo35N2IaN9UaKoj8HQFcImmcUSTmURsGlFf
         5gygDqK3dkkC05wLYASGKJyOX7LLOmYDK/P+hGqZsq95cuzLi6xbVTvafUq1PCqqcBU7
         vVdZupRVVNvlF21oKydJsqvF/1K0NaWazGmdwvwj3dYbXh0Bj+VG5pXt8NsBQLK+l2ij
         FPhQJKHGkPytqV1mIuEqsA28nV332n2VHVkXtDC+dK3axYh7V+JwA/u8N35m7QeDpJok
         hKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Dc9IyqXO7Wm3+bDtKtLtx9+DbBZ47LkjAeuYVgRscE=;
        b=IDGjUrxATdIB8p6mnWaYsaHiSt6z/wJvStPDThPpWRG1grIKqJPQSZwI6TDwRvD4Ds
         qAet7fRCIpoJJ4jMGs9mF6kJR6K9HIv56HnRf3TXl4I15E+ge7xqjGtUOoFyOlNcBca6
         4AWeL5/+O3daW4tFDm0KSXOOYgYry9A2RKvrKE8eEyaVmebTHvF+OiDsgSDVW3LpHtuK
         BWFmUq1rRbSfsb1BnoQtwXgwBB6xImD0+QeYJiIwm0/uG4wcPqbUsKv+eBaB4BYOCVHc
         Z2JljWXhLD5HBQUhrUJFP14zdYeTJy9+vIOvRi78L6lXeF3U4+G7fsbyVCUBwTesJqbV
         7GEQ==
X-Gm-Message-State: AOAM532rajkeMPWF1lA/LdowXcRnbKOernT/IrwdOtzxY+6t/Wc6U2yi
        fLXw7gThFP7J1zUAdVIHX85a1pHoCPkRSY+gktdSOA==
X-Google-Smtp-Source: ABdhPJw/0TlGByNPXLRpWckwAfeK5n1U/QSPywu8h+JqZ5aS4wDj0Pv0sWPe4vPMhb02puhJ/NUfbfRfX4m2azGkTRk=
X-Received: by 2002:adf:8165:: with SMTP id 92mr5106482wrm.199.1637654787221;
 Tue, 23 Nov 2021 00:06:27 -0800 (PST)
MIME-Version: 1.0
References: <20211118083912.981995-1-atishp@rivosinc.com> <20211118083912.981995-6-atishp@rivosinc.com>
In-Reply-To: <20211118083912.981995-6-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 23 Nov 2021 13:36:16 +0530
Message-ID: <CAAhSdy1V6cUYBmpTz8tT0gMg7=ZP1hQ25_zVdPg56TtnegLriw@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] RISC-V: KVM: Add SBI HSM extension in KVM
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
> SBI HSM extension allows OS to start/stop harts any time. It also allows
> ordered booting of harts instead of random booting.
>
> Implement SBI HSM exntesion and designate the vcpu 0 as the boot vcpu id.
> All other non-zero non-booting vcpus should be brought up by the OS
> implementing HSM extension. If the guest OS doesn't implement HSM
> extension, only single vcpu will be available to OS.
>
> Reviewed-by: Anup Patel <anup.patel@wdc.com>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

I have queued this for 5.17

Thanks,
Anup

> ---
>  arch/riscv/include/asm/sbi.h  |   1 +
>  arch/riscv/kvm/Makefile       |   1 +
>  arch/riscv/kvm/vcpu.c         |  23 ++++++++
>  arch/riscv/kvm/vcpu_sbi.c     |   4 ++
>  arch/riscv/kvm/vcpu_sbi_hsm.c | 105 ++++++++++++++++++++++++++++++++++
>  5 files changed, 134 insertions(+)
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_hsm.c
>
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 4f9370b6032e..79af25c45c8d 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -90,6 +90,7 @@ enum sbi_hsm_hart_status {
>  #define SBI_ERR_INVALID_PARAM  -3
>  #define SBI_ERR_DENIED         -4
>  #define SBI_ERR_INVALID_ADDRESS        -5
> +#define SBI_ERR_ALREADY_AVAILABLE -6
>
>  extern unsigned long sbi_spec_version;
>  struct sbiret {
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 4757ae158bf3..aaf181a3d74b 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -26,4 +26,5 @@ kvm-y += vcpu_sbi.o
>  kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
>  kvm-y += vcpu_sbi_base.o
>  kvm-y += vcpu_sbi_replace.o
> +kvm-y += vcpu_sbi_hsm.o
>  kvm-y += vcpu_timer.o
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index e3d3aed46184..50158867406d 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -53,6 +53,17 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>         struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
>         struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
>         struct kvm_cpu_context *reset_cntx = &vcpu->arch.guest_reset_context;
> +       bool loaded;
> +
> +       /**
> +        * The preemption should be disabled here because it races with
> +        * kvm_sched_out/kvm_sched_in(called from preempt notifiers) which
> +        * also calls vcpu_load/put.
> +        */
> +       get_cpu();
> +       loaded = (vcpu->cpu != -1);
> +       if (loaded)
> +               kvm_arch_vcpu_put(vcpu);
>
>         memcpy(csr, reset_csr, sizeof(*csr));
>
> @@ -64,6 +75,11 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>
>         WRITE_ONCE(vcpu->arch.irqs_pending, 0);
>         WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> +
> +       /* Reset the guest CSRs for hotplug usecase */
> +       if (loaded)
> +               kvm_arch_vcpu_load(vcpu, smp_processor_id());
> +       put_cpu();
>  }
>
>  int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
> @@ -100,6 +116,13 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>
>  void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  {
> +       /**
> +        * vcpu with id 0 is the designated boot cpu.
> +        * Keep all vcpus with non-zero cpu id in power-off state so that they
> +        * can brought to online using SBI HSM extension.
> +        */
> +       if (vcpu->vcpu_idx != 0)
> +               kvm_riscv_vcpu_power_off(vcpu);
>  }
>
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index cf284e080f3e..f62d25bc9733 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -25,6 +25,8 @@ static int kvm_linux_err_map_sbi(int err)
>                 return SBI_ERR_INVALID_ADDRESS;
>         case -EOPNOTSUPP:
>                 return SBI_ERR_NOT_SUPPORTED;
> +       case -EALREADY:
> +               return SBI_ERR_ALREADY_AVAILABLE;
>         default:
>                 return SBI_ERR_FAILURE;
>         };
> @@ -43,6 +45,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
>
>  static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
>         &vcpu_sbi_ext_v01,
> @@ -50,6 +53,7 @@ static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
>         &vcpu_sbi_ext_time,
>         &vcpu_sbi_ext_ipi,
>         &vcpu_sbi_ext_rfence,
> +       &vcpu_sbi_ext_hsm,
>  };
>
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
> diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
> new file mode 100644
> index 000000000000..2e383687fa48
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
> @@ -0,0 +1,105 @@
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
> +#include <asm/kvm_vcpu_sbi.h>
> +
> +static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_cpu_context *reset_cntx;
> +       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +       struct kvm_vcpu *target_vcpu;
> +       unsigned long target_vcpuid = cp->a0;
> +
> +       target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
> +       if (!target_vcpu)
> +               return -EINVAL;
> +       if (!target_vcpu->arch.power_off)
> +               return -EALREADY;
> +
> +       reset_cntx = &target_vcpu->arch.guest_reset_context;
> +       /* start address */
> +       reset_cntx->sepc = cp->a1;
> +       /* target vcpu id to start */
> +       reset_cntx->a0 = target_vcpuid;
> +       /* private data passed from kernel */
> +       reset_cntx->a1 = cp->a2;
> +       kvm_make_request(KVM_REQ_VCPU_RESET, target_vcpu);
> +
> +       kvm_riscv_vcpu_power_on(target_vcpu);
> +
> +       return 0;
> +}
> +
> +static int kvm_sbi_hsm_vcpu_stop(struct kvm_vcpu *vcpu)
> +{
> +       if (vcpu->arch.power_off)
> +               return -EINVAL;
> +
> +       kvm_riscv_vcpu_power_off(vcpu);
> +
> +       return 0;
> +}
> +
> +static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +       unsigned long target_vcpuid = cp->a0;
> +       struct kvm_vcpu *target_vcpu;
> +
> +       target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
> +       if (!target_vcpu)
> +               return -EINVAL;
> +       if (!target_vcpu->arch.power_off)
> +               return SBI_HSM_HART_STATUS_STARTED;
> +       else
> +               return SBI_HSM_HART_STATUS_STOPPED;
> +}
> +
> +static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +                                  unsigned long *out_val,
> +                                  struct kvm_cpu_trap *utrap,
> +                                  bool *exit)
> +{
> +       int ret = 0;
> +       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +       struct kvm *kvm = vcpu->kvm;
> +       unsigned long funcid = cp->a6;
> +
> +       switch (funcid) {
> +       case SBI_EXT_HSM_HART_START:
> +               mutex_lock(&kvm->lock);
> +               ret = kvm_sbi_hsm_vcpu_start(vcpu);
> +               mutex_unlock(&kvm->lock);
> +               break;
> +       case SBI_EXT_HSM_HART_STOP:
> +               ret = kvm_sbi_hsm_vcpu_stop(vcpu);
> +               break;
> +       case SBI_EXT_HSM_HART_STATUS:
> +               ret = kvm_sbi_hsm_vcpu_get_status(vcpu);
> +               if (ret >= 0) {
> +                       *out_val = ret;
> +                       ret = 0;
> +               }
> +               break;
> +       default:
> +               ret = -EOPNOTSUPP;
> +       }
> +
> +       return ret;
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm = {
> +       .extid_start = SBI_EXT_HSM,
> +       .extid_end = SBI_EXT_HSM,
> +       .handler = kvm_sbi_ext_hsm_handler,
> +};
> --
> 2.33.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
