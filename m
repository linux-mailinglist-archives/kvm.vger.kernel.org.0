Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9D241409C
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 06:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhIVEjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 00:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhIVEjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 00:39:18 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE93AC061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 21:37:48 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r2so1332354pgl.10
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 21:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m6kldB4rj/R0WAkH0imKrXheJ5V9FdbCmll402cf/IA=;
        b=ICo+Qb1xVrXPRSI7NnKutgqIbTVSjHefGoL4UTvWcdLzlKBJcZSOAiv37rrnqZo5Rz
         jNJVc+p3x+rdeAuuHjiG9hFl/ETgaYUUm8MAeg5KJi1Bk02G1yoSkpeyIWxy2d9wZAtw
         i8YENzp7fDKb9uovIf0iENUaGw66di9BTbJjh/Zo1wJKNAkzSX4udgaHcybfT3HuiKiF
         bYitJiAyGbWz/wX/nZy8zut9LS8vOk9eL2QPKDL1xRWvGwwX0T2+e/i/jly2XCsK1cpU
         sdeeADNM/l3nMY1rLbHvXxjuGnmm38PHeJOlwbdjlTi4jwxwQUNHex7hqfXsEoKMrZH6
         MkhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m6kldB4rj/R0WAkH0imKrXheJ5V9FdbCmll402cf/IA=;
        b=UIqYsYDm/ORQbjf4zSYZSOa34XE/S/bVRDTXvFF325X6imKLiQMv6cY+bcGaPYdHHR
         cf9svPpqCJxzyLkCBG3Jagkwmsbm5K0KrmFqYDTh+liwE2hSzMUTWSZojrgsQ5PCpqeI
         baGjROjUzSaDJXHy9L25RGj2nMGReq+7r6W/EFDawZPXZAGQmzkXSoGqN4Qqx5ARi5e7
         P/gwKndBhHjctz1VZiG76Uj9mCQ6Z/du4u842ymZPJ7mblWmVFkIV6FWAtJ8U70/QEEx
         TI05raPiUMQ8twldCN5X+m+hIvATwPj/UkjtIHSOqrSRThRHMCDC6l4YE2UBCnLg8zuB
         618w==
X-Gm-Message-State: AOAM531uSgQLLqeaIWp1F2nyS25JnzLCFE7n1+3ohBYAdibWY6YlnceC
        qfrQTYyb4x+WehZqDClurkpS2kNnfyrlNq4P1TfsTw==
X-Google-Smtp-Source: ABdhPJxyLcmXtJzqXIty5HMyLdZx4wO2ii7Xm2RUsWDJqS7lv9IkDE3r3XN2xqczjqfgfhUPLESfVblUgyopY3T/WXI=
X-Received: by 2002:a63:f80a:: with SMTP id n10mr30957910pgh.303.1632285467778;
 Tue, 21 Sep 2021 21:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com> <20210916181510.963449-3-oupton@google.com>
In-Reply-To: <20210916181510.963449-3-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 21 Sep 2021 21:37:31 -0700
Message-ID: <CAAeT=Fznwct=D8tk-zRg1SGTa9FqrOrXZ7Boc9yMOnrZ5NPMZw@mail.gmail.com>
Subject: Re: [PATCH v8 2/8] KVM: arm64: Separate guest/host counter offset values
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Thu, Sep 16, 2021 at 11:15 AM Oliver Upton <oupton@google.com> wrote:
>
> In some instances, a VMM may want to update the guest's counter-timer
> offset in a transparent manner, meaning that changes to the hardware
> value do not affect the synthetic register presented to the guest or the
> VMM through said guest's architectural state. Lay the groundwork to
> separate guest offset register writes from the hardware values utilized
> by KVM.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm64/kvm/arch_timer.c  | 42 +++++++++++++++++++++++++++---------
>  include/kvm/arm_arch_timer.h |  3 +++
>  2 files changed, 35 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index c0101db75ad4..cf2f4a034dbe 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -84,11 +84,9 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
>
>  static u64 timer_get_offset(struct arch_timer_context *ctxt)
>  {
> -       struct kvm_vcpu *vcpu = ctxt->vcpu;
> -
>         switch(arch_timer_ctx_index(ctxt)) {
>         case TIMER_VTIMER:
> -               return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
> +               return ctxt->host_offset;
>         default:
>                 return 0;
>         }
> @@ -128,17 +126,33 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
>
>  static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>  {
> -       struct kvm_vcpu *vcpu = ctxt->vcpu;
> -
>         switch(arch_timer_ctx_index(ctxt)) {
>         case TIMER_VTIMER:
> -               __vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
> +               ctxt->host_offset = offset;
>                 break;
>         default:
>                 WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
>         }
>  }
>
> +static void timer_set_guest_offset(struct arch_timer_context *ctxt, u64 offset)
> +{
> +       struct kvm_vcpu *vcpu = ctxt->vcpu;
> +
> +       switch (arch_timer_ctx_index(ctxt)) {
> +       case TIMER_VTIMER: {
> +               u64 host_offset = timer_get_offset(ctxt);
> +
> +               host_offset += offset - __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
> +               __vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
> +               timer_set_offset(ctxt, host_offset);
> +               break;
> +       }
> +       default:
> +               WARN_ONCE(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
> +       }
> +}
> +
>  u64 kvm_phys_timer_read(void)
>  {
>         return timecounter->cc->read(timecounter->cc);
> @@ -749,7 +763,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
>
>  /* Make offset updates for all timer contexts atomic */
>  static void update_timer_offset(struct kvm_vcpu *vcpu,
> -                               enum kvm_arch_timers timer, u64 offset)
> +                               enum kvm_arch_timers timer, u64 offset,
> +                               bool guest_visible)

The name 'guest_visible' looks confusing to me because it also
affects the type of the 'offset' that its caller needs to specify.
(The 'offset' must be an offset from the guest's physical counter
if 'guest_visible' == true, and an offset from the host's virtual
counter otherwise.)
Having said that, I don't have a good alternative name for it though...
IMHO, 'is_host_offset' would be less confusing because it indicates
what the caller needs to specify.


>  {
>         int i;
>         struct kvm *kvm = vcpu->kvm;
> @@ -758,13 +773,20 @@ static void update_timer_offset(struct kvm_vcpu *vcpu,
>         lockdep_assert_held(&kvm->lock);
>
>         kvm_for_each_vcpu(i, tmp, kvm)
> -               timer_set_offset(vcpu_get_timer(tmp, timer), offset);
> +               if (guest_visible)
> +                       timer_set_guest_offset(vcpu_get_timer(tmp, timer),
> +                                              offset);
> +               else
> +                       timer_set_offset(vcpu_get_timer(tmp, timer), offset);
>
>         /*
>          * When called from the vcpu create path, the CPU being created is not
>          * included in the loop above, so we just set it here as well.
>          */
> -       timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
> +       if (guest_visible)
> +               timer_set_guest_offset(vcpu_get_timer(vcpu, timer), offset);
> +       else
> +               timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
>  }
>
>  static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
> @@ -772,7 +794,7 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
>         struct kvm *kvm = vcpu->kvm;
>
>         mutex_lock(&kvm->lock);
> -       update_timer_offset(vcpu, TIMER_VTIMER, cntvoff);
> +       update_timer_offset(vcpu, TIMER_VTIMER, cntvoff, true);
>         mutex_unlock(&kvm->lock);
>  }
>
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 51c19381108c..9d65d4a29f81 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -42,6 +42,9 @@ struct arch_timer_context {
>         /* Duplicated state from arch_timer.c for convenience */
>         u32                             host_timer_irq;
>         u32                             host_timer_irq_flags;
> +
> +       /* offset relative to the host's physical counter-timer */
> +       u64                             host_offset;
>  };

Just out of curiosity, have you considered having 'host_offset'
in one place (in arch_timer_cpu or somewhere ?) as physical offset
rather than having them separately for each arch_timer_context ?
I would think that could simplify the offset calculation code
and update_ptimer_cntpoff() doesn't need to call update_timer_offset()
for TIMER_VTIMER.  It would require extra memory accesses for
timer_get_offset(TIMER_VTIMER) though...

Otherwise,
Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji
