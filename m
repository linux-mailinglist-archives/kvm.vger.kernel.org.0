Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853772D882C
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 17:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406342AbgLLQ21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Dec 2020 11:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395002AbgLLQ2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Dec 2020 11:28:16 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AB9C0613CF
        for <kvm@vger.kernel.org>; Sat, 12 Dec 2020 08:27:36 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id h4so6740266qkk.4
        for <kvm@vger.kernel.org>; Sat, 12 Dec 2020 08:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HHcj+g8rYVBSjYDCvlsBJ0jZcjObbWH2W9LXixAgWA4=;
        b=mzPxnWcQhaDtxSh85WyBDWdv/CzQGa06y3Lg6qGiD5dvHKKvnNhXoOUeuEQO+TX0v+
         xQfXdJ8xJYXiKm3TMBOCSUoQxmBIxVENffYiNLOejzL0i0hFyHKIMQwPs/YUIkMgIBgI
         +0WRohfX8lZgn+gOHpIycGbytFzhD7rvierj4miGBRFySou5gGyyjT43+cGEbKpmGRgz
         eo/fM/GWP31TtCbMwqdCIJEZPChbo2olsgnM7ZIZ4Fo/d7Q4y86FM8UCF8cqShFuglDH
         5zNhK657A/b3uw4z06DO8Uz51SHA39nrFgWqlMZLWzCUgAbwCRii0KxMeGdJli39AzGa
         PJKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HHcj+g8rYVBSjYDCvlsBJ0jZcjObbWH2W9LXixAgWA4=;
        b=WKEU47AK1hoRV89HIQ6VrWnvoyLVbe0Iv8k3Pl0votn3p0lahQQIWkFBYLMaNt8aj5
         J9OcLz3jrw4rxRbrGBjOErivyoXtjhAYHaiHoZk3P/Hx84GpaTIMYpk/MkEIyFjX3Kcx
         tO1z2Kb8CS3IQ2GpcIyQYQ4kGqncZC/LPqDAq0oOnodOTPwt58Ulk4kq0q4rZPXr1LlQ
         /KV7kvF+SGQmXElAKozpNm/YzzK2DXj8eUXH23btcS+xUloPpkgoj57GuzWrGV/6ATem
         cPS/fnvMXKVv5RnAieBRtT+g+CdOXLpEKYY4TWHXyfxsM7TsofKDYW80uClNaoLSjnpz
         2Lag==
X-Gm-Message-State: AOAM53031zK2e/5sVzppm+2v5eqJ6J7K7E6243dMTAtwBmrGSer58pkh
        reHhVwsrE0ebsespVxI6r0Za1Vs5NWf5q9oslwDEwHpEE5Q=
X-Google-Smtp-Source: ABdhPJzPXAESTa0psDLnSiWKHm/ZsGcIvo2WzMua7a60edem2qQddRc4s1yshf039diZqTe7G1LNFDRZuh7k5j+/M4E=
X-Received: by 2002:a37:dcc6:: with SMTP id v189mr1432469qki.292.1607790455485;
 Sat, 12 Dec 2020 08:27:35 -0800 (PST)
MIME-Version: 1.0
References: <20201029135600.122392-1-ubizjak@gmail.com>
In-Reply-To: <20201029135600.122392-1-ubizjak@gmail.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Sat, 12 Dec 2020 17:27:28 +0100
Message-ID: <CAFULd4YaRJ+9CN5XZSKXTJzO8CCAOGCeooxoj5=OwjLucnJiDw@mail.gmail.com>
Subject: Re: [PATCH] KVM/VMX/SVM: Move kvm_machine_check function to x86.h
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping.  This relatively simple patch didn't receive any feedback.

Uros.

On Thu, Oct 29, 2020 at 2:56 PM Uros Bizjak <ubizjak@gmail.com> wrote:
>
> Move kvm_machine_check to x86.h to avoid two exact copies
> of the same function in kvm.c and svm.c.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/svm/svm.c | 20 --------------------
>  arch/x86/kvm/vmx/vmx.c | 20 --------------------
>  arch/x86/kvm/x86.h     | 20 ++++++++++++++++++++
>  3 files changed, 20 insertions(+), 40 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2f32fd09e259..f2ad59d19040 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -33,7 +33,6 @@
>  #include <asm/debugreg.h>
>  #include <asm/kvm_para.h>
>  #include <asm/irq_remapping.h>
> -#include <asm/mce.h>
>  #include <asm/spec-ctrl.h>
>  #include <asm/cpu_device_id.h>
>
> @@ -1929,25 +1928,6 @@ static bool is_erratum_383(void)
>         return true;
>  }
>
> -/*
> - * Trigger machine check on the host. We assume all the MSRs are already set up
> - * by the CPU and that we still run on the same CPU as the MCE occurred on.
> - * We pass a fake environment to the machine check handler because we want
> - * the guest to be always treated like user space, no matter what context
> - * it used internally.
> - */
> -static void kvm_machine_check(void)
> -{
> -#if defined(CONFIG_X86_MCE)
> -       struct pt_regs regs = {
> -               .cs = 3, /* Fake ring 3 no matter what the guest ran on */
> -               .flags = X86_EFLAGS_IF,
> -       };
> -
> -       do_machine_check(&regs);
> -#endif
> -}
> -
>  static void svm_handle_mce(struct vcpu_svm *svm)
>  {
>         if (is_erratum_383()) {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0f390c748b18..0329f09a2ca6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -40,7 +40,6 @@
>  #include <asm/irq_remapping.h>
>  #include <asm/kexec.h>
>  #include <asm/perf_event.h>
> -#include <asm/mce.h>
>  #include <asm/mmu_context.h>
>  #include <asm/mshyperv.h>
>  #include <asm/mwait.h>
> @@ -4714,25 +4713,6 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
>         return 1;
>  }
>
> -/*
> - * Trigger machine check on the host. We assume all the MSRs are already set up
> - * by the CPU and that we still run on the same CPU as the MCE occurred on.
> - * We pass a fake environment to the machine check handler because we want
> - * the guest to be always treated like user space, no matter what context
> - * it used internally.
> - */
> -static void kvm_machine_check(void)
> -{
> -#if defined(CONFIG_X86_MCE)
> -       struct pt_regs regs = {
> -               .cs = 3, /* Fake ring 3 no matter what the guest ran on */
> -               .flags = X86_EFLAGS_IF,
> -       };
> -
> -       do_machine_check(&regs);
> -#endif
> -}
> -
>  static int handle_machine_check(struct kvm_vcpu *vcpu)
>  {
>         /* handled by vmx_vcpu_run() */
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 3900ab0c6004..e1bde3f3f2d5 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -3,6 +3,7 @@
>  #define ARCH_X86_KVM_X86_H
>
>  #include <linux/kvm_host.h>
> +#include <asm/mce.h>
>  #include <asm/pvclock.h>
>  #include "kvm_cache_regs.h"
>  #include "kvm_emulate.h"
> @@ -366,6 +367,25 @@ static inline bool kvm_dr6_valid(u64 data)
>         return !(data >> 32);
>  }
>
> +/*
> + * Trigger machine check on the host. We assume all the MSRs are already set up
> + * by the CPU and that we still run on the same CPU as the MCE occurred on.
> + * We pass a fake environment to the machine check handler because we want
> + * the guest to be always treated like user space, no matter what context
> + * it used internally.
> + */
> +static inline void kvm_machine_check(void)
> +{
> +#if defined(CONFIG_X86_MCE)
> +       struct pt_regs regs = {
> +               .cs = 3, /* Fake ring 3 no matter what the guest ran on */
> +               .flags = X86_EFLAGS_IF,
> +       };
> +
> +       do_machine_check(&regs);
> +#endif
> +}
> +
>  void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
>  void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
>  int kvm_spec_ctrl_test_value(u64 value);
> --
> 2.26.2
>
