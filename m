Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C248682983
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjAaJvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjAaJvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:51:52 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC3D1A8
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:51:47 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id h9so5915092plf.9
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l1+1j6tXbawgkfww5V65w6y7pgd7p8FEC5W/jVYhleg=;
        b=m4D4HYNZQzFbYCNIK3zadgXzGbzWJ3OADGu4qHz5wgNMIk2zU9XiKxMmmavePgw1Sv
         loiykXbX2M7Zb23OK2+Fgk1prmWbtjI75pdOpPC9XbxMn4nvSTHGgPQRVUBIDI4AXTgp
         vtS53Yh77O4F/D7Ml2d7j1SHLre+ZukFRGNNw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l1+1j6tXbawgkfww5V65w6y7pgd7p8FEC5W/jVYhleg=;
        b=LADkV3A8nTPMLG/4d6bHvI7oFwaWVfjOLNYgmGqRRGJFtl3kx+KvkpXpo0pLxBcfrO
         g5+u0B8ajgqIulrE0WFg0bqId5Qr730bQGB+uEERTxMPYYJP/sw6xH1j3nT803bANWO+
         M7zBhKy0xBNoA00ldIscTe0W96gmKW94rbp703Kjjp7FvG933/sxxwsW8IJ6SOFmClu+
         Bfxg8/icDB8d5mHOueWRUE+Jt+Grv53G9Zznc7EXf1CMAo864iGapSA52wYy59VSj3Zp
         JbtEVUtWCeN5W7fcYy5p4niA2JFDC4dsS7CM9j3gzIgTEo+km6vCzEpGJSYoiwn+MKWb
         eEfQ==
X-Gm-Message-State: AO0yUKVR8BonhP51h+oU+z6pmAf+rz9naq/9WngZTIOazOrt7uo3gzXi
        /O1frqtaNB1q/11Zg5L6mNVeUerUKZ+UQrqjDuv7
X-Google-Smtp-Source: AK7set/d4JMSpTgUYVc8I7gf4rVGYO75uruj3XoMWdE2b/ngPDtwdG1d6b5JjJ2EVNlsrTia06XZGNr9MPRamCo/AVQ=
X-Received: by 2002:a17:902:b706:b0:196:6dac:3426 with SMTP id
 d6-20020a170902b70600b001966dac3426mr1521159pls.23.1675158706819; Tue, 31 Jan
 2023 01:51:46 -0800 (PST)
MIME-Version: 1.0
References: <20230128072737.2995881-1-apatel@ventanamicro.com> <20230128072737.2995881-5-apatel@ventanamicro.com>
In-Reply-To: <20230128072737.2995881-5-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 31 Jan 2023 01:51:35 -0800
Message-ID: <CAOnJCUJEBooLbL0uACv7W_dV1dXP7YvA3-iL0HRBZ4Q-fPu3qg@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] RISC-V: KVM: Initial skeletal support for AIA
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:28 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> To incrementally implement AIA support, we first add minimal skeletal
> support which only compiles and detects AIA hardware support at the
> boot-time but does not provide any functionality.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/hwcap.h    |   6 ++
>  arch/riscv/include/asm/kvm_aia.h  | 109 ++++++++++++++++++++++++++++++
>  arch/riscv/include/asm/kvm_host.h |   7 ++
>  arch/riscv/kvm/Makefile           |   1 +
>  arch/riscv/kvm/aia.c              |  66 ++++++++++++++++++
>  arch/riscv/kvm/main.c             |  13 ++++
>  arch/riscv/kvm/vcpu.c             |  40 ++++++++++-
>  arch/riscv/kvm/vcpu_insn.c        |   4 +-
>  arch/riscv/kvm/vm.c               |   4 ++
>  9 files changed, 246 insertions(+), 4 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_aia.h
>  create mode 100644 arch/riscv/kvm/aia.c
>
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> index 341ef30a3718..a03d51df517b 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -65,6 +65,12 @@ enum riscv_isa_ext_id {
>  };
>  static_assert(RISCV_ISA_EXT_ID_MAX <= RISCV_ISA_EXT_MAX);
>
> +#ifdef CONFIG_RISCV_M_MODE
> +#define RISCV_ISA_EXT_SxAIA            RISCV_ISA_EXT_SMAIA
> +#else
> +#define RISCV_ISA_EXT_SxAIA            RISCV_ISA_EXT_SSAIA
> +#endif
> +
>  /*
>   * This enum represents the logical ID for each RISC-V ISA extension static
>   * keys. We can use static key to optimize code path if some ISA extensions
> diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
> new file mode 100644
> index 000000000000..258a835d4c32
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_aia.h
> @@ -0,0 +1,109 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2021 Western Digital Corporation or its affiliates.
> + * Copyright (C) 2022 Ventana Micro Systems Inc.
> + *
> + * Authors:
> + *     Anup Patel <apatel@ventanamicro.com>
> + */
> +
> +#ifndef __KVM_RISCV_AIA_H
> +#define __KVM_RISCV_AIA_H
> +
> +#include <linux/jump_label.h>
> +#include <linux/kvm_types.h>
> +
> +struct kvm_aia {
> +       /* In-kernel irqchip created */
> +       bool            in_kernel;
> +
> +       /* In-kernel irqchip initialized */
> +       bool            initialized;
> +};
> +
> +struct kvm_vcpu_aia {
> +};
> +
> +#define kvm_riscv_aia_initialized(k)   ((k)->arch.aia.initialized)
> +
> +#define irqchip_in_kernel(k)           ((k)->arch.aia.in_kernel)
> +
> +DECLARE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
> +#define kvm_riscv_aia_available() \
> +       static_branch_unlikely(&kvm_riscv_aia_available)
> +
> +static inline void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +static inline void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +static inline bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu,
> +                                                    u64 mask)
> +{
> +       return false;
> +}
> +
> +static inline void kvm_riscv_vcpu_aia_update_hvip(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +static inline void kvm_riscv_vcpu_aia_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +}
> +
> +static inline void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +static inline int kvm_riscv_vcpu_aia_get_csr(struct kvm_vcpu *vcpu,
> +                                            unsigned long reg_num,
> +                                            unsigned long *out_val)
> +{
> +       *out_val = 0;
> +       return 0;
> +}
> +
> +static inline int kvm_riscv_vcpu_aia_set_csr(struct kvm_vcpu *vcpu,
> +                                            unsigned long reg_num,
> +                                            unsigned long val)
> +{
> +       return 0;
> +}
> +
> +#define KVM_RISCV_VCPU_AIA_CSR_FUNCS
> +
> +static inline int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu)
> +{
> +       return 1;
> +}
> +
> +static inline void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +static inline int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
> +{
> +       return 0;
> +}
> +
> +static inline void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +static inline void kvm_riscv_aia_init_vm(struct kvm *kvm)
> +{
> +}
> +
> +static inline void kvm_riscv_aia_destroy_vm(struct kvm *kvm)
> +{
> +}
> +
> +void kvm_riscv_aia_enable(void);
> +void kvm_riscv_aia_disable(void);
> +int kvm_riscv_aia_init(void);
> +void kvm_riscv_aia_exit(void);
> +
> +#endif
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 93f43a3e7886..8776e7a465c7 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -14,6 +14,7 @@
>  #include <linux/kvm_types.h>
>  #include <linux/spinlock.h>
>  #include <asm/hwcap.h>
> +#include <asm/kvm_aia.h>
>  #include <asm/kvm_vcpu_fp.h>
>  #include <asm/kvm_vcpu_insn.h>
>  #include <asm/kvm_vcpu_sbi.h>
> @@ -93,6 +94,9 @@ struct kvm_arch {
>
>         /* Guest Timer */
>         struct kvm_guest_timer timer;
> +
> +       /* AIA Guest/VM context */
> +       struct kvm_aia aia;
>  };
>
>  struct kvm_cpu_trap {
> @@ -220,6 +224,9 @@ struct kvm_vcpu_arch {
>         /* SBI context */
>         struct kvm_vcpu_sbi_context sbi_context;
>
> +       /* AIA VCPU context */
> +       struct kvm_vcpu_aia aia_context;
> +
>         /* Cache pages needed to program page tables with spinlock held */
>         struct kvm_mmu_memory_cache mmu_page_cache;
>
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 019df9208bdd..adbc85a94364 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -25,3 +25,4 @@ kvm-y += vcpu_sbi_base.o
>  kvm-y += vcpu_sbi_replace.o
>  kvm-y += vcpu_sbi_hsm.o
>  kvm-y += vcpu_timer.o
> +kvm-y += aia.o
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> new file mode 100644
> index 000000000000..7a633331cd3e
> --- /dev/null
> +++ b/arch/riscv/kvm/aia.c
> @@ -0,0 +1,66 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2021 Western Digital Corporation or its affiliates.
> + * Copyright (C) 2022 Ventana Micro Systems Inc.
> + *
> + * Authors:
> + *     Anup Patel <apatel@ventanamicro.com>
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <asm/hwcap.h>
> +
> +DEFINE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
> +
> +static void aia_set_hvictl(bool ext_irq_pending)
> +{
> +       unsigned long hvictl;
> +
> +       /*
> +        * HVICTL.IID == 9 and HVICTL.IPRIO == 0 represents
> +        * no interrupt in HVICTL.
> +        */
> +
> +       hvictl = (IRQ_S_EXT << HVICTL_IID_SHIFT) & HVICTL_IID;
> +       hvictl |= ext_irq_pending;
> +       csr_write(CSR_HVICTL, hvictl);
> +}
> +
> +void kvm_riscv_aia_enable(void)
> +{
> +       if (!kvm_riscv_aia_available())
> +               return;
> +
> +       aia_set_hvictl(false);
> +       csr_write(CSR_HVIPRIO1, 0x0);
> +       csr_write(CSR_HVIPRIO2, 0x0);
> +#ifdef CONFIG_32BIT
> +       csr_write(CSR_HVIPH, 0x0);
> +       csr_write(CSR_HIDELEGH, 0x0);
> +       csr_write(CSR_HVIPRIO1H, 0x0);
> +       csr_write(CSR_HVIPRIO2H, 0x0);
> +#endif
> +}
> +
> +void kvm_riscv_aia_disable(void)
> +{
> +       if (!kvm_riscv_aia_available())
> +               return;
> +
> +       aia_set_hvictl(false);
> +}
> +
> +int kvm_riscv_aia_init(void)
> +{
> +       if (!riscv_isa_extension_available(NULL, SxAIA))
> +               return -ENODEV;
> +
> +       /* Enable KVM AIA support */
> +       static_branch_enable(&kvm_riscv_aia_available);
> +
> +       return 0;
> +}
> +
> +void kvm_riscv_aia_exit(void)
> +{
> +}
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 58c5489d3031..d8ff44eb04ca 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -53,11 +53,15 @@ int kvm_arch_hardware_enable(void)
>
>         csr_write(CSR_HVIP, 0);
>
> +       kvm_riscv_aia_enable();
> +
>         return 0;
>  }
>
>  void kvm_arch_hardware_disable(void)
>  {
> +       kvm_riscv_aia_disable();
> +
>         /*
>          * After clearing the hideleg CSR, the host kernel will receive
>          * spurious interrupts if hvip CSR has pending interrupts and the
> @@ -72,6 +76,7 @@ void kvm_arch_hardware_disable(void)
>
>  int kvm_arch_init(void *opaque)
>  {
> +       int rc;
>         const char *str;
>
>         if (!riscv_isa_extension_available(NULL, h)) {
> @@ -93,6 +98,10 @@ int kvm_arch_init(void *opaque)
>
>         kvm_riscv_gstage_vmid_detect();
>
> +       rc = kvm_riscv_aia_init();
> +       if (rc && rc != -ENODEV)
> +               return rc;
> +
>         kvm_info("hypervisor extension available\n");
>
>         switch (kvm_riscv_gstage_mode()) {
> @@ -115,11 +124,15 @@ int kvm_arch_init(void *opaque)
>
>         kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits());
>
> +       if (kvm_riscv_aia_available())
> +               kvm_info("AIA available\n");
> +
>         return 0;
>  }
>
>  void kvm_arch_exit(void)
>  {
> +       kvm_riscv_aia_exit();
>  }
>
>  static int __init riscv_kvm_init(void)
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 2260adaf2de8..3cf50eadc8ce 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -135,6 +135,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>
>         kvm_riscv_vcpu_timer_reset(vcpu);
>
> +       kvm_riscv_vcpu_aia_reset(vcpu);
> +
>         WRITE_ONCE(vcpu->arch.irqs_pending, 0);
>         WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
>
> @@ -155,6 +157,7 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>
>  int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  {
> +       int rc;
>         struct kvm_cpu_context *cntx;
>         struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
>         unsigned long host_isa, i;
> @@ -194,6 +197,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         /* Setup VCPU timer */
>         kvm_riscv_vcpu_timer_init(vcpu);
>
> +       /* Setup VCPU AIA */
> +       rc = kvm_riscv_vcpu_aia_init(vcpu);
> +       if (rc)
> +               return rc;
> +
>         /* Reset VCPU */
>         kvm_riscv_reset_vcpu(vcpu);
>
> @@ -213,6 +221,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
> +       /* Cleanup VCPU AIA context */
> +       kvm_riscv_vcpu_aia_deinit(vcpu);
> +
>         /* Cleanup VCPU timer */
>         kvm_riscv_vcpu_timer_deinit(vcpu);
>
> @@ -730,6 +741,9 @@ void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu)
>                 csr->hvip &= ~mask;
>                 csr->hvip |= val;
>         }
> +
> +       /* Flush AIA high interrupts */
> +       kvm_riscv_vcpu_aia_flush_interrupts(vcpu);
>  }
>
>  void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
> @@ -755,6 +769,9 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
>                 }
>         }
>
> +       /* Sync-up AIA high interrupts */
> +       kvm_riscv_vcpu_aia_sync_interrupts(vcpu);
> +
>         /* Sync-up timer CSRs */
>         kvm_riscv_vcpu_timer_sync(vcpu);
>  }
> @@ -791,10 +808,15 @@ int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
>
>  bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask)
>  {
> -       unsigned long ie = ((vcpu->arch.guest_csr.vsie & VSIP_VALID_MASK)
> -                           << VSIP_TO_HVIP_SHIFT) & mask;
> +       unsigned long ie;
> +
> +       ie = ((vcpu->arch.guest_csr.vsie & VSIP_VALID_MASK)
> +               << VSIP_TO_HVIP_SHIFT) & mask;
> +       if (READ_ONCE(vcpu->arch.irqs_pending) & ie)
> +               return true;
>
> -       return (READ_ONCE(vcpu->arch.irqs_pending) & ie) ? true : false;
> +       /* Check AIA high interrupts */
> +       return kvm_riscv_vcpu_aia_has_interrupts(vcpu, mask);
>  }
>
>  void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
> @@ -890,6 +912,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>         kvm_riscv_vcpu_guest_fp_restore(&vcpu->arch.guest_context,
>                                         vcpu->arch.isa);
>
> +       kvm_riscv_vcpu_aia_load(vcpu, cpu);
> +
>         vcpu->cpu = cpu;
>  }
>
> @@ -899,6 +923,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>
>         vcpu->cpu = -1;
>
> +       kvm_riscv_vcpu_aia_put(vcpu);
> +
>         kvm_riscv_vcpu_guest_fp_save(&vcpu->arch.guest_context,
>                                      vcpu->arch.isa);
>         kvm_riscv_vcpu_host_fp_restore(&vcpu->arch.host_context);
> @@ -966,6 +992,7 @@ static void kvm_riscv_update_hvip(struct kvm_vcpu *vcpu)
>         struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
>
>         csr_write(CSR_HVIP, csr->hvip);
> +       kvm_riscv_vcpu_aia_update_hvip(vcpu);
>  }
>
>  /*
> @@ -1040,6 +1067,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>
>                 local_irq_disable();
>
> +               /* Update AIA HW state before entering guest */
> +               ret = kvm_riscv_vcpu_aia_update(vcpu);
> +               if (ret <= 0) {
> +                       local_irq_enable();
> +                       continue;
> +               }
> +
>                 /*
>                  * Ensure we set mode to IN_GUEST_MODE after we disable
>                  * interrupts and before the final VCPU requests check.
> diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
> index 0bb52761a3f7..07e8c121922b 100644
> --- a/arch/riscv/kvm/vcpu_insn.c
> +++ b/arch/riscv/kvm/vcpu_insn.c
> @@ -213,7 +213,9 @@ struct csr_func {
>                     unsigned long wr_mask);
>  };
>
> -static const struct csr_func csr_funcs[] = { };
> +static const struct csr_func csr_funcs[] = {
> +       KVM_RISCV_VCPU_AIA_CSR_FUNCS
> +};
>
>  /**
>   * kvm_riscv_vcpu_csr_return -- Handle CSR read/write after user space
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index 65a964d7e70d..bc03d2ddcb51 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -41,6 +41,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>                 return r;
>         }
>
> +       kvm_riscv_aia_init_vm(kvm);
> +
>         kvm_riscv_guest_timer_init(kvm);
>
>         return 0;
> @@ -49,6 +51,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
>         kvm_destroy_vcpus(kvm);
> +
> +       kvm_riscv_aia_destroy_vm(kvm);
>  }
>
>  int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> --
> 2.34.1
>

LGTM.
Reviewed-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
