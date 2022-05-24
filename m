Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E053853296A
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 13:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbiEXLk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 07:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236918AbiEXLkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 07:40:25 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE178D6AE
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:39:51 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id e28so24691146wra.10
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ua5miAVVPytEV/pRLQijDYQegeFjG3YVeTCN9Y4tQKQ=;
        b=2Iy6sEGyvbf8HM80oeNnhGeK0vpM9aHyFtiw8sW44EhJiwYL8SM4xpDSk7F2LZLfQP
         YKiWM7KeaNqBkLGuF9SAICkJoZde6Vd2yo+VaThbt+XR3Fe1a/GkvvCQXYoBD05y3Qcj
         5WGgS3ajQ6/zmW/9DXZ96ex3FK8VlZmB7VK94pU915ka3x6Tk+Q6XFF6q42dx08118+A
         SZgHyp8TTppWc/Bz53Dc0vbIxUZUkNv2fmTpUQUrljP94sVQkhbtaQSTGi3nHbb8xvkW
         pNrUwJ3kUQU4Ad8OHLZDA8pYnpva7UZjBUBXm//V4h9OANPwEVbHPP4eEbwwSZDHreh2
         YX4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ua5miAVVPytEV/pRLQijDYQegeFjG3YVeTCN9Y4tQKQ=;
        b=sPysH8d//HHiEFh69nb+U2NCgBwbCM21vSkW9Q6SmvDleaWxxXh1/VcivkzIGDNXWC
         kLkiuzUizl/GR5GH+VUP7xBg6q6pSu9qa6CPYM4E6wheHa3FTPu7eFHl74sh1Ou5OBNk
         Ef+W7xnskAV/1zmVftEnHJC3yvkVRAtkw6W2Ok4Qiy87iRoQh4hxT8H3N5qDHX9yQ4jW
         /Ke5R6PM3wgxDu2yfhGiRJmuKZohyQ2j8KrtjiS1mwIM0XZFen4dUow6nBh3RUn7Aj+T
         8LUhFEqJLuQWHF/ug2gfJb83H7Kv/kMNbOCQ5FUTpzAGJCnkyRy5eLf9olg9rT1bMQHb
         +p8g==
X-Gm-Message-State: AOAM530oHBepPDOe4L/HbJBGfXfbmajf8pld6aWpxPrFyDpQDMJuViuK
        YDfM7yAnaAMyWcj6/GTNT/KEztUsjmIbC9x0fGs7dA==
X-Google-Smtp-Source: ABdhPJwQMXMJXK0lf8v2HhkmTrwPsi2WahY3qRzko1+QZ+nAWE89e7LvkbXoDbq14EdxWG7+ny8GGD7BNg4RU8Ij2h0=
X-Received: by 2002:a05:6000:1f18:b0:20f:e61b:520e with SMTP id
 bv24-20020a0560001f1800b0020fe61b520emr6422447wrb.214.1653392389529; Tue, 24
 May 2022 04:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220426185245.281182-1-atishp@rivosinc.com> <20220426185245.281182-5-atishp@rivosinc.com>
In-Reply-To: <20220426185245.281182-5-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 24 May 2022 17:09:38 +0530
Message-ID: <CAAhSdy2XE9L_LdbxPM3NVHJYmXJFpRO934x5aGNZ7aKF-91eXQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] RISC-V: KVM: Support sstc extension
To:     Atish Patra <atishp@rivosinc.com>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Atish Patra <atishp@atishpatra.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        DTML <devicetree@vger.kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 27, 2022 at 12:23 AM Atish Patra <atishp@rivosinc.com> wrote:
>
> Sstc extension allows the guest to program the vstimecmp CSR directly
> instead of making an SBI call to the hypervisor to program the next
> event. The timer interrupt is also directly injected to the guest by
> the hardware in this case. To maintain backward compatibility, the
> hypervisors also update the vstimecmp in an SBI set_time call if
> the hardware supports it. Thus, the older kernels in guest also
> take advantage of the sstc extension.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_host.h       |   1 +
>  arch/riscv/include/asm/kvm_vcpu_timer.h |   8 +-
>  arch/riscv/include/uapi/asm/kvm.h       |   1 +
>  arch/riscv/kvm/main.c                   |  12 ++-
>  arch/riscv/kvm/vcpu.c                   |   5 +-
>  arch/riscv/kvm/vcpu_timer.c             | 138 +++++++++++++++++++++++-
>  6 files changed, 159 insertions(+), 6 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 78da839657e5..50a97c821f83 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -135,6 +135,7 @@ struct kvm_vcpu_csr {
>         unsigned long hvip;
>         unsigned long vsatp;
>         unsigned long scounteren;
> +       u64 vstimecmp;

No need for separate "vstimecmp" here instead you can re-use
"next_cycles" of  "struct kvm_vcpu_timer".

>  };
>
>  struct kvm_vcpu_arch {
> diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/include/asm/kvm_vcpu_timer.h
> index 375281eb49e0..a24a265f3ccb 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_timer.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
> @@ -28,6 +28,11 @@ struct kvm_vcpu_timer {
>         u64 next_cycles;
>         /* Underlying hrtimer instance */
>         struct hrtimer hrt;
> +
> +       /* Flag to check if sstc is enabled or not */
> +       bool sstc_enabled;
> +       /* A function pointer to switch between stimecmp or hrtimer at runtime */
> +       int (*timer_next_event)(struct kvm_vcpu *vcpu, u64 ncycles);
>  };
>
>  int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles);
> @@ -39,6 +44,7 @@ int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu);
>  int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu);
>  int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu);
>  int kvm_riscv_guest_timer_init(struct kvm *kvm);
> -
> +bool kvm_riscv_vcpu_timer_pending(struct kvm_vcpu *vcpu);
>  #endif
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 92bd469e2ba6..d2f02ba1947a 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -96,6 +96,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>         KVM_RISCV_ISA_EXT_H,
>         KVM_RISCV_ISA_EXT_I,
>         KVM_RISCV_ISA_EXT_M,
> +       KVM_RISCV_ISA_EXT_SSTC,
>         KVM_RISCV_ISA_EXT_MAX,
>  };
>
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 2e5ca43c8c49..83c4db7fc35f 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -32,7 +32,7 @@ int kvm_arch_hardware_setup(void *opaque)
>
>  int kvm_arch_hardware_enable(void)
>  {
> -       unsigned long hideleg, hedeleg;
> +       unsigned long hideleg, hedeleg, henvcfg;
>
>         hedeleg = 0;
>         hedeleg |= (1UL << EXC_INST_MISALIGNED);
> @@ -51,6 +51,16 @@ int kvm_arch_hardware_enable(void)
>
>         csr_write(CSR_HCOUNTEREN, -1UL);
>
> +       if (riscv_isa_extension_available(NULL, SSTC)) {
> +#ifdef CONFIG_64BIT
> +               henvcfg = csr_read(CSR_HENVCFG);
> +               csr_write(CSR_HENVCFG, henvcfg | 1UL<<HENVCFG_STCE);
> +#else
> +               henvcfg = csr_read(CSR_HENVCFGH);
> +               csr_write(CSR_HENVCFGH, henvcfg | 1UL<<HENVCFGH_STCE);
> +#endif
> +       }
> +
>         csr_write(CSR_HVIP, 0);
>
>         return 0;
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 93492eb292fd..da1559725b03 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -143,7 +143,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>
>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>  {
> -       return kvm_riscv_vcpu_has_interrupts(vcpu, 1UL << IRQ_VS_TIMER);
> +       return kvm_riscv_vcpu_timer_pending(vcpu);
>  }
>
>  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
> @@ -374,6 +374,7 @@ static unsigned long kvm_isa_ext_arr[] = {
>         RISCV_ISA_EXT_h,
>         RISCV_ISA_EXT_i,
>         RISCV_ISA_EXT_m,
> +       RISCV_ISA_EXT_SSTC,
>  };
>
>  static int kvm_riscv_vcpu_get_reg_isa_ext(struct kvm_vcpu *vcpu,
> @@ -754,6 +755,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>                                      vcpu->arch.isa);
>         kvm_riscv_vcpu_host_fp_restore(&vcpu->arch.host_context);
>
> +       kvm_riscv_vcpu_timer_save(vcpu);
> +
>         csr->vsstatus = csr_read(CSR_VSSTATUS);
>         csr->vsie = csr_read(CSR_VSIE);
>         csr->vstvec = csr_read(CSR_VSTVEC);
> diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> index 5c4c37ff2d48..d226a931de92 100644
> --- a/arch/riscv/kvm/vcpu_timer.c
> +++ b/arch/riscv/kvm/vcpu_timer.c
> @@ -69,7 +69,18 @@ static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcpu_timer *t)
>         return 0;
>  }
>
> -int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles)
> +static int kvm_riscv_vcpu_update_vstimecmp(struct kvm_vcpu *vcpu, u64 ncycles)
> +{
> +#if __riscv_xlen == 32
> +               csr_write(CSR_VSTIMECMP, ncycles & 0xFFFFFFFF);
> +               csr_write(CSR_VSTIMECMPH, ncycles >> 32);
> +#else
> +               csr_write(CSR_VSTIMECMP, ncycles);
> +#endif
> +               return 0;
> +}
> +
> +static int kvm_riscv_vcpu_update_hrtimer(struct kvm_vcpu *vcpu, u64 ncycles)
>  {
>         struct kvm_vcpu_timer *t = &vcpu->arch.timer;
>         struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
> @@ -88,6 +99,68 @@ int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles)
>         return 0;
>  }
>
> +int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles)
> +{
> +       struct kvm_vcpu_timer *t = &vcpu->arch.timer;
> +
> +       return t->timer_next_event(vcpu, ncycles);
> +}
> +
> +static enum hrtimer_restart kvm_riscv_vcpu_vstimer_expired(struct hrtimer *h)
> +{
> +       u64 delta_ns;
> +       struct kvm_vcpu_timer *t = container_of(h, struct kvm_vcpu_timer, hrt);
> +       struct kvm_vcpu *vcpu = container_of(t, struct kvm_vcpu, arch.timer);
> +       struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
> +
> +       if (kvm_riscv_current_cycles(gt) < t->next_cycles) {
> +               delta_ns = kvm_riscv_delta_cycles2ns(t->next_cycles, gt, t);
> +               hrtimer_forward_now(&t->hrt, ktime_set(0, delta_ns));
> +               return HRTIMER_RESTART;
> +       }
> +
> +       t->next_set = false;
> +       kvm_vcpu_kick(vcpu);
> +
> +       return HRTIMER_NORESTART;
> +}
> +
> +bool kvm_riscv_vcpu_timer_pending(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_vcpu_timer *t = &vcpu->arch.timer;
> +       struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
> +       u64 vstimecmp_val = vcpu->arch.guest_csr.vstimecmp;
> +
> +       if (!kvm_riscv_delta_cycles2ns(vstimecmp_val, gt, t) ||
> +           kvm_riscv_vcpu_has_interrupts(vcpu, 1UL << IRQ_VS_TIMER))
> +               return true;
> +       else
> +               return false;
> +}
> +
> +static void kvm_riscv_vcpu_timer_blocking(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_vcpu_timer *t = &vcpu->arch.timer;
> +       struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
> +       u64 delta_ns;
> +       u64 vstimecmp_val = vcpu->arch.guest_csr.vstimecmp;

Define delta_ns is same line as vstimecmp_val

> +
> +       if (!t->init_done)
> +               return;
> +
> +       delta_ns = kvm_riscv_delta_cycles2ns(vstimecmp_val, gt, t);
> +       if (delta_ns) {
> +               t->next_cycles = vstimecmp_val;
> +               hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
> +               t->next_set = true;
> +       }
> +}
> +
> +static void kvm_riscv_vcpu_timer_unblocking(struct kvm_vcpu *vcpu)
> +{
> +       kvm_riscv_vcpu_timer_cancel(&vcpu->arch.timer);
> +}
> +
>  int kvm_riscv_vcpu_get_reg_timer(struct kvm_vcpu *vcpu,
>                                  const struct kvm_one_reg *reg)
>  {
> @@ -180,10 +253,20 @@ int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu)
>                 return -EINVAL;
>
>         hrtimer_init(&t->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> -       t->hrt.function = kvm_riscv_vcpu_hrtimer_expired;
>         t->init_done = true;
>         t->next_set = false;
>
> +       /* Enable sstc for every vcpu if available in hardware */
> +       if (riscv_isa_extension_available(NULL, SSTC)) {
> +               t->sstc_enabled = true;
> +               t->hrt.function = kvm_riscv_vcpu_vstimer_expired;
> +               t->timer_next_event = kvm_riscv_vcpu_update_vstimecmp;
> +       } else {
> +               t->sstc_enabled = false;
> +               t->hrt.function = kvm_riscv_vcpu_hrtimer_expired;
> +               t->timer_next_event = kvm_riscv_vcpu_update_hrtimer;
> +       }
> +
>         return 0;
>  }
>
> @@ -202,7 +285,7 @@ int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu)

Set "next_cycles" to -1ULL in kvm_riscv_vcpu_timer_reset() because if we have
older kernel (which does not use Sstc) as Guest then it will get timer interrupt
immediately after enabling sie.STIE.

>         return kvm_riscv_vcpu_timer_cancel(&vcpu->arch.timer);
>  }
>
> -void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
> +static void kvm_riscv_vcpu_update_timedelta(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
>
> @@ -214,6 +297,55 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
>  #endif
>  }
>
> +void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_vcpu_csr *csr;
> +       struct kvm_vcpu_timer *t = &vcpu->arch.timer;
> +
> +       kvm_riscv_vcpu_update_timedelta(vcpu);
> +
> +       if (!t->sstc_enabled)
> +               return;
> +
> +       csr = &vcpu->arch.guest_csr;
> +#ifdef CONFIG_64BIT
> +       csr_write(CSR_VSTIMECMP, csr->vstimecmp);
> +#else
> +       csr_write(CSR_VSTIMECMP, (u32)csr->vstimecmp);
> +       csr_write(CSR_VSTIMECMPH, (u32)(csr->vstimecmp >> 32));
> +#endif
> +
> +       /* timer should be enabled for the remaining operations */
> +       if (unlikely(!t->init_done))
> +               return;
> +
> +       kvm_riscv_vcpu_timer_unblocking(vcpu);
> +}
> +
> +void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_vcpu_csr *csr;
> +       struct kvm_vcpu_timer *t = &vcpu->arch.timer;
> +
> +       if (!t->sstc_enabled)
> +               return;
> +
> +       csr = &vcpu->arch.guest_csr;
> +       t = &vcpu->arch.timer;
> +#ifdef CONFIG_64BIT
> +       csr->vstimecmp = csr_read(CSR_VSTIMECMP);
> +#else
> +       csr->vstimecmp = csr_read(CSR_VSTIMECMP);
> +       csr->vstimecmp |= (u64)csr_read(CSR_VSTIMECMPH) << 32;
> +#endif
> +       /* timer should be enabled for the remaining operations */
> +       if (unlikely(!t->init_done))
> +               return;
> +
> +       if (kvm_vcpu_is_blocking(vcpu))
> +               kvm_riscv_vcpu_timer_blocking(vcpu);
> +}
> +
>  int kvm_riscv_guest_timer_init(struct kvm *kvm)
>  {
>         struct kvm_guest_timer *gt = &kvm->arch.timer;
> --
> 2.25.1
>

Regards,
Anup
