Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8952F3D0B29
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 11:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237157AbhGUIUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 04:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235695AbhGUH74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 03:59:56 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF139C061574
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 01:40:03 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id b18-20020a0568303112b02904cf73f54f4bso1403471ots.2
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 01:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j0mH812Q+H6nf50XosopteGpGbFozpi9Pxd4x5dKswI=;
        b=qIC8YvCO8PbewH0w8Yp4rcJ1AhQE2Vo9Hct4hWBUB7+021hwzAn0ncwjQeJD1Dk2Se
         FYnIfLHKTMXuCV78XdB7ApfT5HGJomGrLtrh3fS6MzHN/FVMOdga2/0hWeYYntPdswcv
         AGJq23LtpbRpnIBA3A68fqj7mb1AZoq5/Vf3++fP2lzaOZgXh312jg8SrgowAoch5v7n
         ggBQlLH7ec2PvPQGLOlGIgaveOzYLsnAgH0Ww3m8at54fuwV1us6Jyyfli31oeTuh0ee
         StjcmdKjtG7J71ziWLcw64ph9GPnZUFFfOwYzHGlV0d11Tu11c0LCy9jS7+WxjqAjvPh
         iqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j0mH812Q+H6nf50XosopteGpGbFozpi9Pxd4x5dKswI=;
        b=PhqTgrUiSuolrL+Jh3sUpP/5doRaxfd1whywiKOFSAYZJndfNFSf1b6fQWrRDIPANw
         CFRzT8+6/M7b3Ivxhjbqk3+ehFMSSN+tCcmIzQOmRB2xdx/5ZxjQcBvvWKfNI+k03SCz
         v4echOv+ULJ4j5uqGG6SW+F09GIuFLpOy0Q6Ww8sS54n0eAIKwj372NYIBbiU/ovwtVT
         gKhkcHpIUC5lXusIHIaqw1//bY067Y5UBsihpdfG8VYlo5gyngBbvTD7Yz5fk9e6+QlY
         XPuMenoSA3PTYUP5B3Kns+vgSPOEvsC9wczQ0yy5mPdbew93KLOOp/dHTB7rpHL5xFt1
         xQXw==
X-Gm-Message-State: AOAM530EHKH9B1AzphJg664iRxzgwF1JGMmzwlB0VGourpjtS7U+U4pK
        iI/oIX9At9kCAQbNm894xA97XKyYIDAwggfawT0/fw==
X-Google-Smtp-Source: ABdhPJz8wMJl99b6XXHrZ5unyCNp0pMN0AtIw+pAluMMpktoXDkoKasGVZ+UTnYKTHRgtx0Nj0isPvGyNhvgkEReXmo=
X-Received: by 2002:a05:6830:1455:: with SMTP id w21mr25392148otp.365.1626856803030;
 Wed, 21 Jul 2021 01:40:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com> <20210719160346.609914-15-tabba@google.com>
 <CAOQ_Qshr4dmvFSd7Cr0tBg0iy2Fvp78RvyCteJ3vSBFVoBrN8Q@mail.gmail.com>
In-Reply-To: <CAOQ_Qshr4dmvFSd7Cr0tBg0iy2Fvp78RvyCteJ3vSBFVoBrN8Q@mail.gmail.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Wed, 21 Jul 2021 09:39:26 +0100
Message-ID: <CA+EHjTxUr4s+7YuT-VxZGL5LkRRnXB1XKOAEfqP2+t+YffwFAQ@mail.gmail.com>
Subject: Re: [PATCH v3 14/15] KVM: arm64: Handle protected guests at 32 bits
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kernel-team@android.com,
        kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
        will@kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Mon, Jul 19, 2021 at 8:43 PM Oliver Upton <oupton@google.com> wrote:
>
> On Mon, Jul 19, 2021 at 9:04 AM Fuad Tabba <tabba@google.com> wrote:
> >
> > Protected KVM does not support protected AArch32 guests. However,
> > it is possible for the guest to force run AArch32, potentially
> > causing problems. Add an extra check so that if the hypervisor
> > catches the guest doing that, it can prevent the guest from
> > running again by resetting vcpu->arch.target and returning
> > ARM_EXCEPTION_IL.
> >
> > Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
> > AArch32 systems")
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> Would it make sense to document how we handle misbehaved guests, in
> case a particular VMM wants to clean up the mess afterwards?

I agree, especially since with this patch this could happen in more
than one place.

Thanks,
/fuad

> --
> Thanks,
> Oliver
>
> > ---
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index 8431f1514280..f09343e15a80 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -23,6 +23,7 @@
> >  #include <asm/kprobes.h>
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_emulate.h>
> > +#include <asm/kvm_fixed_config.h>
> >  #include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmu.h>
> >  #include <asm/fpsimd.h>
> > @@ -477,6 +478,29 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
> >                         write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
> >         }
> >
> > +       /*
> > +        * Protected VMs might not be allowed to run in AArch32. The check below
> > +        * is based on the one in kvm_arch_vcpu_ioctl_run().
> > +        * The ARMv8 architecture doesn't give the hypervisor a mechanism to
> > +        * prevent a guest from dropping to AArch32 EL0 if implemented by the
> > +        * CPU. If the hypervisor spots a guest in such a state ensure it is
> > +        * handled, and don't trust the host to spot or fix it.
> > +        */
> > +       if (unlikely(is_nvhe_hyp_code() &&
> > +                    kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
> > +                    FIELD_GET(FEATURE(ID_AA64PFR0_EL0),
> > +                              PVM_ID_AA64PFR0_ALLOW) <
> > +                            ID_AA64PFR0_ELx_32BIT_64BIT &&
> > +                    vcpu_mode_is_32bit(vcpu))) {
> > +               /*
> > +                * As we have caught the guest red-handed, decide that it isn't
> > +                * fit for purpose anymore by making the vcpu invalid.
> > +                */
> > +               vcpu->arch.target = -1;
> > +               *exit_code = ARM_EXCEPTION_IL;
> > +               goto exit;
> > +       }
> > +
> >         /*
> >          * We're using the raw exception code in order to only process
> >          * the trap if no SError is pending. We will come back to the
> > --
> > 2.32.0.402.g57bb445576-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
