Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31612DBD7D
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 10:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgLPJZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 04:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgLPJZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 04:25:23 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7034C0613D6
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 01:24:42 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id z11so21895624qkj.7
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 01:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VnOERqJmNL9fajfQHoyutXn+UfnLadGj9bydZ04YbIo=;
        b=uD74+aiG/aHlTDkROMZ7Zs/+MVYoNtZLwBCHmP15fCLtYSiSD09I5VuEhRX30dTckP
         gQFKJbebmS937xmxFPP5tzJBW6fsjx9qS7pWqzEKk5VEBnjaFA28/oa+Dp2KCMPrzLeF
         vTr5iK3aEayGTNFZNBifQL08jRA5cr2Nas+6RERN/LAFIX/qHVKSyM26/VrdbVZYfMvo
         oGaorOAJVUc8gCHRWOt72RebpWUbfdVj4kP4SOpCZB90W5OCRzspuD3B5yXQC/t4n28u
         JlWtBitiGCey/b8U0tA5Z9zuzfSB49XbjlIXZkHf3zUxvivObC2JRsZPN4kII0VQmpy2
         XyNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VnOERqJmNL9fajfQHoyutXn+UfnLadGj9bydZ04YbIo=;
        b=ozU+bz8KLe8XgI6iL16WnCCKgbKzBd7Ms0aDfKXQL4b7SCa+MZ4cA5mtHMWstzg7EQ
         JL0U7wcqjw+YJazQebxMMppjNSEB6OlYoTO1/JVElsjaHikkzvLD140EHTv18yri0HRO
         RnHey76Hio+RlR0lXrfbs2EME2VjipbSfn3lauGYLwkmLnZr43Nw/ZPCBiMXjI42SJBg
         MuGXwk8UhI0g0LqUMsMcM5jMCZXOEoaH6q0SQ62MiIb5rMICyVRvvJO4UZQW6iDhuUNY
         njAvE1tDdSc78kdjRanMwOVQDkLWH40wyayU9RVwA2X38ytZ4YLST/T0ePYje7zLJ0tt
         OTMQ==
X-Gm-Message-State: AOAM5313D2k869N709p8gXqnc8p+qYskCiZgcVEKxEhTBHVwi487FIjN
        u13JMH2tqnSMGDPP89xIVL45qRA7XHT7EGViBm2GYVJ6o7Gz9A==
X-Google-Smtp-Source: ABdhPJyjr9dR1o7cz7G6NeibDKnN/6X3I4zE2yOd0bLycyQoS6dU5wD81UnS97yqEIzJQschUrVl8jEbCPFCpSZMPRk=
X-Received: by 2002:a37:458:: with SMTP id 85mr41956906qke.61.1608110681874;
 Wed, 16 Dec 2020 01:24:41 -0800 (PST)
MIME-Version: 1.0
References: <20201029134145.107560-1-ubizjak@gmail.com>
In-Reply-To: <20201029134145.107560-1-ubizjak@gmail.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Wed, 16 Dec 2020 10:24:30 +0100
Message-ID: <CAFULd4av_xehfPBBL76dH+On4ezLa6rqU6YkqBuLhPcvZTr5pQ@mail.gmail.com>
Subject: Re: [PATCH] KVM/nVMX: Use __vmx_vcpu_run in nested_vmx_check_vmentry_hw
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping.  This patch didn't receive any feedback.

Thanks,
Uros.

On Thu, Oct 29, 2020 at 2:41 PM Uros Bizjak <ubizjak@gmail.com> wrote:
>
> Replace inline assembly in nested_vmx_check_vmentry_hw
> with a call to __vmx_vcpu_run.  The function is not
> performance critical, so (double) GPR save/restore
> in __vmx_vcpu_run can be tolerated, as far as performance
> effects are concerned.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 32 +++-----------------------------
>  arch/x86/kvm/vmx/vmx.c    |  2 --
>  arch/x86/kvm/vmx/vmx.h    |  1 +
>  3 files changed, 4 insertions(+), 31 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 89af692deb7e..6ab62bf277c4 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -12,6 +12,7 @@
>  #include "nested.h"
>  #include "pmu.h"
>  #include "trace.h"
> +#include "vmx.h"
>  #include "x86.h"
>
>  static bool __read_mostly enable_shadow_vmcs = 1;
> @@ -3056,35 +3057,8 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
>                 vmx->loaded_vmcs->host_state.cr4 = cr4;
>         }
>
> -       asm(
> -               "sub $%c[wordsize], %%" _ASM_SP "\n\t" /* temporarily adjust RSP for CALL */
> -               "cmp %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
> -               "je 1f \n\t"
> -               __ex("vmwrite %%" _ASM_SP ", %[HOST_RSP]") "\n\t"
> -               "mov %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
> -               "1: \n\t"
> -               "add $%c[wordsize], %%" _ASM_SP "\n\t" /* un-adjust RSP */
> -
> -               /* Check if vmlaunch or vmresume is needed */
> -               "cmpb $0, %c[launched](%[loaded_vmcs])\n\t"
> -
> -               /*
> -                * VMLAUNCH and VMRESUME clear RFLAGS.{CF,ZF} on VM-Exit, set
> -                * RFLAGS.CF on VM-Fail Invalid and set RFLAGS.ZF on VM-Fail
> -                * Valid.  vmx_vmenter() directly "returns" RFLAGS, and so the
> -                * results of VM-Enter is captured via CC_{SET,OUT} to vm_fail.
> -                */
> -               "call vmx_vmenter\n\t"
> -
> -               CC_SET(be)
> -             : ASM_CALL_CONSTRAINT, CC_OUT(be) (vm_fail)
> -             : [HOST_RSP]"r"((unsigned long)HOST_RSP),
> -               [loaded_vmcs]"r"(vmx->loaded_vmcs),
> -               [launched]"i"(offsetof(struct loaded_vmcs, launched)),
> -               [host_state_rsp]"i"(offsetof(struct loaded_vmcs, host_state.rsp)),
> -               [wordsize]"i"(sizeof(ulong))
> -             : "memory"
> -       );
> +       vm_fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
> +                                vmx->loaded_vmcs->launched);
>
>         if (vmx->msr_autoload.host.nr)
>                 vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d14c94d0aff1..0f390c748b18 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6591,8 +6591,6 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>         }
>  }
>
> -bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
> -
>  static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>                                         struct vcpu_vmx *vmx)
>  {
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index f6f66e5c6510..32db3b033e9b 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -339,6 +339,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
>  struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr);
>  void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
>  void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
> +bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
>  int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
>  void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
>
> --
> 2.26.2
>
