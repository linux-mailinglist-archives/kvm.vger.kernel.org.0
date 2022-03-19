Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7894DE6BA
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 08:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242386AbiCSHaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 03:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiCSHaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 03:30:06 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B7E710F8
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 00:28:45 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id m26-20020a05600c3b1a00b0038c8b999f58so509197wms.1
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 00:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n7beTvn/X/EKIQqoz+HYeAQGQ6+8HEp6/29IkuC0UhQ=;
        b=veZGdPo2q+V6N+Xh15YvztKSwjz9harc3Vuhoy8meTpt2US8gDe0V7NJFkojC6jGoV
         kj1tUAvOv0q227GLleTgBZSeKHauYLppxOTsQZl1WzXI0Dpd4cEJNxSocA4siEdkgwKK
         lOBS+XssOvvzNbXfisJPV8a7RL+DDZjNB/55iWonTJD/37iwg90Y49n6l+tf6VdWMCCv
         jcslEsRMBzcTbq/pOp+I/EgN2kF4WyAMxe+OaJV8FF6/q691RDBP3wuALy6gQMylhrtE
         APPRlsGbv4Xi9mCS+gDYGQHrX0+4zU3u9lB1s1lCiBwt3y3qOSqmThUsVOeNPE2AqQMa
         O3YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n7beTvn/X/EKIQqoz+HYeAQGQ6+8HEp6/29IkuC0UhQ=;
        b=ul6FihYy9BUzS2dsvsnkugIsb/ht67BF9lkUrmt7RmcpT0ut2zp75aeTTETcGGPQUP
         3BGE8Qs7eND26h6J2AuRcjQy/KPrHngUfa5P3bXu2SN+vr6vPtaPtGKZTyKhzITNhY7j
         eeif6O4jXP6E+fRC1RVRB3BH9z/fhDEqtCMCIqrXgShtCKvh16Ig73PvPoDRsVIqrUXn
         x6/dSuobrdIAJy/ActxiO/A4akoVOaN01YRuNw+DdFRtQfdEJBSENXZPl4LydQ1SuBO9
         UkMuhyEUhJx/LrB/2MhbIvAItR5349n8S1r5hKcRB8IhMDUfGGyVwVfMMxixMGfFNALl
         9XjQ==
X-Gm-Message-State: AOAM533TGggARSaYfXQHGYbyeC3PXJb7ldkeFrLGUMmH6tzo8y1GJ3c1
        coCM3BVQblPNXdAmbNEo4mKfEWIqWqpZyqTSLPlFpA==
X-Google-Smtp-Source: ABdhPJz+C4BUeGlkPl2+cpv+6lErkkmM6uljZzTZjgGT7NFMOsZSiBeo6bGz2fpDoUUNmgcDWh2CzuAqkrFfGG8FDYs=
X-Received: by 2002:a05:600c:3c9c:b0:389:cc3b:9462 with SMTP id
 bg28-20020a05600c3c9c00b00389cc3b9462mr18913699wmb.105.1647674920453; Sat, 19
 Mar 2022 00:28:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com> <20220311174001.605719-8-oupton@google.com>
In-Reply-To: <20220311174001.605719-8-oupton@google.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 19 Mar 2022 12:58:28 +0530
Message-ID: <CAAhSdy3mH5JQ9N9JzbUpBw3ZdqKtLretsUKL3WAdMhpEXVmJRg@mail.gmail.com>
Subject: Re: [PATCH v4 07/15] KVM: Create helper for setting a system event exit
To:     Oliver Upton <oupton@google.com>
Cc:     "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atishp@atishpatra.org>,
        James Morse <james.morse@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 11:11 PM Oliver Upton <oupton@google.com> wrote:
>
> Create a helper that appropriately configures kvm_run for a system event
> exit.
>
> No functional change intended.
>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Acked-by: Anup Patel <anup@brainfault.org>
> ---
>  arch/arm64/kvm/psci.c         | 5 +----
>  arch/riscv/kvm/vcpu_sbi_v01.c | 4 +---
>  arch/x86/kvm/x86.c            | 6 ++----
>  include/linux/kvm_host.h      | 2 ++
>  virt/kvm/kvm_main.c           | 8 ++++++++
>  5 files changed, 14 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index efd4428fda1c..78266716165e 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -173,10 +173,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
>                 tmp->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
>         kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
>
> -       memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> -       vcpu->run->system_event.type = type;
> -       vcpu->run->system_event.flags = flags;
> -       vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +       kvm_vcpu_set_system_event_exit(vcpu, type, flags);
>  }
>
>  static void kvm_psci_system_off(struct kvm_vcpu *vcpu)
> diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
> index 07e2de14433a..c5581008dd88 100644
> --- a/arch/riscv/kvm/vcpu_sbi_v01.c
> +++ b/arch/riscv/kvm/vcpu_sbi_v01.c
> @@ -24,9 +24,7 @@ static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
>                 tmp->arch.power_off = true;
>         kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
>
> -       memset(&run->system_event, 0, sizeof(run->system_event));
> -       run->system_event.type = type;
> -       run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +       kvm_vcpu_set_system_event_exit(vcpu, type, 0);

This patch needs to be rebased on the latest kvm/next because we have
done some refactoring to support SBI v0.3 SRST extension.

Thanks,
Anup

>  }
>
>  static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7131d735b1ef..b3b94408cc61 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9903,14 +9903,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>                 if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
>                         kvm_vcpu_reload_apic_access_page(vcpu);
>                 if (kvm_check_request(KVM_REQ_HV_CRASH, vcpu)) {
> -                       vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> -                       vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
> +                       kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_CRASH, 0);
>                         r = 0;
>                         goto out;
>                 }
>                 if (kvm_check_request(KVM_REQ_HV_RESET, vcpu)) {
> -                       vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> -                       vcpu->run->system_event.type = KVM_SYSTEM_EVENT_RESET;
> +                       kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_RESET, 0);
>                         r = 0;
>                         goto out;
>                 }
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f11039944c08..c2a4fd2382e2 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2202,6 +2202,8 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
>  }
>  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
>
> +void kvm_vcpu_set_system_event_exit(struct kvm_vcpu *vcpu, u32 type, u64 flags);
> +
>  /*
>   * This defines how many reserved entries we want to keep before we
>   * kick the vcpu to the userspace to avoid dirty ring full.  This
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 58d31da8a2f7..197bae04ca34 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3194,6 +3194,14 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
>
> +void kvm_vcpu_set_system_event_exit(struct kvm_vcpu *vcpu, u32 type, u64 flags)
> +{
> +       memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> +       vcpu->run->system_event.type = type;
> +       vcpu->run->system_event.flags = flags;
> +       vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +}
> +
>  void kvm_sigset_activate(struct kvm_vcpu *vcpu)
>  {
>         if (!vcpu->sigset_active)
> --
> 2.35.1.723.g4982287a31-goog
>
