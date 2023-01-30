Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC4168157F
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 16:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbjA3Pt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 10:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237297AbjA3Psh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 10:48:37 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD836582
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 07:48:25 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id mf7so14258729ejc.6
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 07:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6cSvTtaPluKjivYl4UrQE4bipaF+IzwEg2ePwmyFKRo=;
        b=Cedm42tTIOsEhgfb6LgujmAeg6lfxqPfaBVz3TYK7+w0tf3BR9jHq71TeBjS9VhyA8
         QRyokjxnWJIrBYox+pVP0IuDxAAD4Hu672xbY9vLkpfYucxS2qf/8GRsogStfI81OYUF
         +4sLUq1RvN6H2RZs/rWAMYvs3z777/zbgdnMBfcbuXX8Ee78rGU9TRoMLI5thuAczQpS
         j3UphqgjtUAjLoxDqskm/zgV5dT/6ox45G+R6n6XLYZBRcFg+jrt+8YWQLqvBGUdCLQl
         C7FVjavrW8bPUtIuo0WnZRMfstKiFhIaXtlbrfW5w567w+k/6xRH8/6KMwc0O8edcR7r
         doBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6cSvTtaPluKjivYl4UrQE4bipaF+IzwEg2ePwmyFKRo=;
        b=SLgTYMUQ1XOC0v59g8Y1sS7X/o5nqtu9su7Yq0EoVTaGqNz0C0AsH7qdU3BYDXHKZz
         JvN09LQavIuynSREkfU3SNheFpDG6Eq2qR5FFcnhy5RRmFZge5IRyrHYKVRD4NJdB7Wl
         eKYv+gqRqcfDWkfW9lbl2mgnV0+djwBmFMp7hHAcCbDZUMiL7GEQvqKDy24vXpgWoiLx
         OTRrS6mhpSSfSc0XXA/2MUUKrS7iXHsRutOuBxzrlwV56octlpdYcF1bYWmhBnrfo1oq
         UTDwuAEFPENf1WfppLCLmqkIi73kyOV6NQwY1M7pcyP7yWIQ48lYi0n7FMYVkqvT2E0B
         ms3g==
X-Gm-Message-State: AO0yUKVECRlbtXrLRVfhCc4NOn1ttUxMnmauWTbkZQfk3/np5jRIUroU
        VrA+M6lrm0olt0IXCvU05t9oxZTKWhqoHRFKEeAghQ==
X-Google-Smtp-Source: AK7set9qVB5OX6ni0Lk55dQYAPF5FY9x1JC11OZle5po67AkILOWqlwslRl3M2sAdorBp77iVCghti5lhVQF6GMNHlg=
X-Received: by 2002:a17:906:88f:b0:88a:7cf5:5d33 with SMTP id
 n15-20020a170906088f00b0088a7cf55d33mr617944eje.100.1675093703810; Mon, 30
 Jan 2023 07:48:23 -0800 (PST)
MIME-Version: 1.0
References: <20230127182558.2416400-1-atishp@rivosinc.com> <20230127182558.2416400-15-atishp@rivosinc.com>
In-Reply-To: <20230127182558.2416400-15-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 30 Jan 2023 21:18:10 +0530
Message-ID: <CAAhSdy1C1wKDBwRbyx=i63_AyGBsgN881_E-fxR=8qqYgwUtGw@mail.gmail.com>
Subject: Re: [PATCH v3 14/14] RISC-V: KVM: Increment firmware pmu events
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:56 PM Atish Patra <atishp@rivosinc.com> wrote:
>
> KVM supports firmware events now. Invoke the firmware event increment
> function from appropriate places.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/tlb.c              | 4 ++++
>  arch/riscv/kvm/vcpu_sbi_replace.c | 7 +++++++
>  2 files changed, 11 insertions(+)
>
> diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> index 309d79b..b797f7c 100644
> --- a/arch/riscv/kvm/tlb.c
> +++ b/arch/riscv/kvm/tlb.c
> @@ -181,6 +181,7 @@ void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
>
>  void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu)
>  {
> +       kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_RCVD);
>         local_flush_icache_all();
>  }
>
> @@ -264,15 +265,18 @@ void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu)
>                                                 d.addr, d.size, d.order);
>                         break;
>                 case KVM_RISCV_HFENCE_VVMA_ASID_GVA:
> +                       kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
>                         kvm_riscv_local_hfence_vvma_asid_gva(
>                                                 READ_ONCE(v->vmid), d.asid,
>                                                 d.addr, d.size, d.order);
>                         break;
>                 case KVM_RISCV_HFENCE_VVMA_ASID_ALL:
> +                       kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
>                         kvm_riscv_local_hfence_vvma_asid_all(
>                                                 READ_ONCE(v->vmid), d.asid);
>                         break;
>                 case KVM_RISCV_HFENCE_VVMA_GVA:
> +                       kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_RCVD);
>                         kvm_riscv_local_hfence_vvma_gva(
>                                                 READ_ONCE(v->vmid),
>                                                 d.addr, d.size, d.order);
> diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
> index abeb55f..71a671e 100644
> --- a/arch/riscv/kvm/vcpu_sbi_replace.c
> +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> @@ -11,6 +11,7 @@
>  #include <linux/kvm_host.h>
>  #include <asm/sbi.h>
>  #include <asm/kvm_vcpu_timer.h>
> +#include <asm/kvm_vcpu_pmu.h>
>  #include <asm/kvm_vcpu_sbi.h>
>
>  static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> @@ -25,6 +26,7 @@ static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                 return 0;
>         }
>
> +       kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_SET_TIMER);
>  #if __riscv_xlen == 32
>         next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
>  #else
> @@ -57,6 +59,7 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                 return 0;
>         }
>
> +       kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_IPI_SENT);
>         kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
>                 if (hbase != -1UL) {
>                         if (tmp->vcpu_id < hbase)
> @@ -67,6 +70,7 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                 ret = kvm_riscv_vcpu_set_interrupt(tmp, IRQ_VS_SOFT);
>                 if (ret < 0)
>                         break;
> +               kvm_riscv_vcpu_pmu_incr_fw(tmp, SBI_PMU_FW_IPI_RECVD);
>         }
>
>         return ret;
> @@ -90,6 +94,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
>         switch (funcid) {
>         case SBI_EXT_RFENCE_REMOTE_FENCE_I:
>                 kvm_riscv_fence_i(vcpu->kvm, hbase, hmask);
> +               kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_SENT);
>                 break;
>         case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
>                 if (cp->a2 == 0 && cp->a3 == 0)
> @@ -97,6 +102,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
>                 else
>                         kvm_riscv_hfence_vvma_gva(vcpu->kvm, hbase, hmask,
>                                                   cp->a2, cp->a3, PAGE_SHIFT);
> +               kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_SENT);
>                 break;
>         case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
>                 if (cp->a2 == 0 && cp->a3 == 0)
> @@ -107,6 +113,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
>                                                        hbase, hmask,
>                                                        cp->a2, cp->a3,
>                                                        PAGE_SHIFT, cp->a4);
> +               kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_SENT);
>                 break;
>         case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA:
>         case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID:
> --
> 2.25.1
>
