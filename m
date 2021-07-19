Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3723CEE6B
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 23:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388109AbhGSUnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 16:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385585AbhGSTDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 15:03:18 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D29C061574
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 12:36:31 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id q16so32176687lfa.5
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 12:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gmu9FJSBhEcTSsmtt+iIhZ+8zB3ttk3MjsTqKSz3Yrw=;
        b=ibg8A6Fhp+23S6tzVmCXeCEtj3odd8AVkQbrVXxhoRY4hnV6gHo2WGoSgPOUVxw0xp
         qAkVNVkfWmVR4/Ha1068xBHFDcyEuYHenDejQPoKAOL/4l8/Sp5ILgH9PU4FUlqE6Wjp
         29uaJBXcRd++t/O167Y4BlwyJMNAdiTbX3Uft4nOjOFo+2E+VuhE47aAGYI8g6tAPjEX
         sEQxADLvqI+UDxQRTpx0KbQADJ4BSKAjek4vY4hqD1AeNo8VoiJydWppvu7wTge17KFl
         WePVEJ1ETYzJulqcA7YDnUIsSV1ux5dQ9HEuz9EhiytfdiDIsiVfs8JzFgK88b0heUw7
         v9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gmu9FJSBhEcTSsmtt+iIhZ+8zB3ttk3MjsTqKSz3Yrw=;
        b=WdfsQjiaqFGpQTn6WReQK6tLj+kWfdyVlizcwydrpg0WAe+AsBEXeJwpsyc/EK7WjF
         ibSF9YQgvEFbuIskj6HXe4j6zORwY8hP11msglAWwfASIxvrthpEGyU0RmeLW71JuJeu
         fuBV1lsDTwD+x/axhYlYWM948PbEWhvaQ/7miVi6tBc64S3uB+QV1aAMcDUWpw7nWGgd
         /oqIzPPt9xh41m2VognQbPfGwxWyfH5VPnuLLXbEOiEUSeITU5y4NshdhXPYotgs8lH0
         b4FUAK/S86CzUw9EvkBLLas3b1gXEL5MZkMvacdnIgxLBSGApCPbsoA/NbG/VeH7Ztj1
         UArA==
X-Gm-Message-State: AOAM531G3WIQx6Ip8IwJXy27qbKcQpmHH8ERBi+D0XjVhcttr04N0jOV
        3BihggtVf1L/zeHqvRVLV3a2BPP8+K2FOyfbUfj70w==
X-Google-Smtp-Source: ABdhPJwHb2gGExmEkhtp61ra3gEDYpWPNEBUJorQ1IC6P0PEeGqqusawSvPdSUGD+XYIHJG6fexg/5948QAeT1sZEv8=
X-Received: by 2002:a05:6512:3237:: with SMTP id f23mr17557452lfe.524.1626723832655;
 Mon, 19 Jul 2021 12:43:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com> <20210719160346.609914-15-tabba@google.com>
In-Reply-To: <20210719160346.609914-15-tabba@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 19 Jul 2021 12:43:41 -0700
Message-ID: <CAOQ_Qshr4dmvFSd7Cr0tBg0iy2Fvp78RvyCteJ3vSBFVoBrN8Q@mail.gmail.com>
Subject: Re: [PATCH v3 14/15] KVM: arm64: Handle protected guests at 32 bits
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kernel-team@android.com,
        kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
        will@kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 9:04 AM Fuad Tabba <tabba@google.com> wrote:
>
> Protected KVM does not support protected AArch32 guests. However,
> it is possible for the guest to force run AArch32, potentially
> causing problems. Add an extra check so that if the hypervisor
> catches the guest doing that, it can prevent the guest from
> running again by resetting vcpu->arch.target and returning
> ARM_EXCEPTION_IL.
>
> Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
> AArch32 systems")
>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Would it make sense to document how we handle misbehaved guests, in
case a particular VMM wants to clean up the mess afterwards?

--
Thanks,
Oliver

> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 8431f1514280..f09343e15a80 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -23,6 +23,7 @@
>  #include <asm/kprobes.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_fixed_config.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/fpsimd.h>
> @@ -477,6 +478,29 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>                         write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
>         }
>
> +       /*
> +        * Protected VMs might not be allowed to run in AArch32. The check below
> +        * is based on the one in kvm_arch_vcpu_ioctl_run().
> +        * The ARMv8 architecture doesn't give the hypervisor a mechanism to
> +        * prevent a guest from dropping to AArch32 EL0 if implemented by the
> +        * CPU. If the hypervisor spots a guest in such a state ensure it is
> +        * handled, and don't trust the host to spot or fix it.
> +        */
> +       if (unlikely(is_nvhe_hyp_code() &&
> +                    kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
> +                    FIELD_GET(FEATURE(ID_AA64PFR0_EL0),
> +                              PVM_ID_AA64PFR0_ALLOW) <
> +                            ID_AA64PFR0_ELx_32BIT_64BIT &&
> +                    vcpu_mode_is_32bit(vcpu))) {
> +               /*
> +                * As we have caught the guest red-handed, decide that it isn't
> +                * fit for purpose anymore by making the vcpu invalid.
> +                */
> +               vcpu->arch.target = -1;
> +               *exit_code = ARM_EXCEPTION_IL;
> +               goto exit;
> +       }
> +
>         /*
>          * We're using the raw exception code in order to only process
>          * the trap if no SError is pending. We will come back to the
> --
> 2.32.0.402.g57bb445576-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
