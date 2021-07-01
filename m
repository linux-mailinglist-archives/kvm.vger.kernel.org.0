Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5F43B923A
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 15:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236476AbhGAN1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 09:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236622AbhGAN1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 09:27:33 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737ADC061762
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 06:25:02 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 110-20020a9d0a770000b0290466fa79d098so6482270otg.9
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 06:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hraBInRNxPgdnbUbMg0qrqax/fr5kijfG4UaFdWb7BE=;
        b=irFqnuywbLSAokHXkS/wK61T/mygsiXIUO7uXOhZaGZTUB1TOAmTOxE2N5E/IxAQiU
         TrV/NMFqTwKQxydLqUimJkd1AQE9XbMZglLbz2n1gIn6eSy6eJtz/HqOjQMjVsYfzzMD
         IVXHHPoOkJi2oPpyEi/H1Ezw8w+MtR3glpkyOrnC0lbvALUIcQXzksP5ixPdalhdUhhX
         lH9PmMdOqPx+eGfDwb/JWInQflonLGx2mMJrJc8DLDMmkVtYbqNVZWh0Vwe91tLT9ZFX
         8d57IFh9PpWku+jBUusr/FYJhs0dEw01Dh6774lK+RRLce8QRvuTnvzu4YKlu4tqWBP7
         igzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hraBInRNxPgdnbUbMg0qrqax/fr5kijfG4UaFdWb7BE=;
        b=C1ibDRqre5nKl8ugdr3gxjk/HRuFbsnhBEAeEnxklJFbLM8z1KobF6Dl1rXgB8zDec
         Il+1bf1UKSCEUKUw3IpZIhbloGEFFEtpjJFskKjN4rNMyYUbeWWNN2dFZrC2LL0knJVa
         tT5vcWIYEDLfiCypheVmkYZ6rgYwHF3bVvgpdlwClWLrJfRjDY7Ycy43SwMRAu7WpmgW
         hW4tzV7tiqqID+YWgUog5xwxw1Jxe9aja4gZwHqan1mZeo1rb0N9LwpKn7orzZh2P+/k
         vGLsGzRI/L8+5rcx4B2zYoTT27vknQO24gN2Em94C4TxuA/uaqnjjPmL/M/82Ib7EY90
         Ny6w==
X-Gm-Message-State: AOAM531ZdW4nTDPoFRsc/2F3KBxAENHecjdH+PFahPkb7NxYxcSP0DaT
        yo6RTFwCj9yVp0W6B82Bim43J7HQ4RB/g4uqiXieNg==
X-Google-Smtp-Source: ABdhPJzlXLgqaANV6pZoXRl/E2Qhat/JRkTnMfbvN/lBw5fcXa7R8iRew0/Lw2QoXMgoqflPNvYiACCIRnRclJgMVJs=
X-Received: by 2002:a05:6830:1de2:: with SMTP id b2mr13983035otj.365.1625145901605;
 Thu, 01 Jul 2021 06:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com> <20210615133950.693489-3-tabba@google.com>
 <20210701125329.GA9757@willie-the-truck>
In-Reply-To: <20210701125329.GA9757@willie-the-truck>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 1 Jul 2021 14:24:25 +0100
Message-ID: <CA+EHjTz13dgJYSgVYwjiG89bhnNbXbJJAiY559yZRa0N=A50Cw@mail.gmail.com>
Subject: Re: [PATCH v2 02/13] KVM: arm64: MDCR_EL2 is a 64-bit register
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Thu, Jul 1, 2021 at 1:53 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jun 15, 2021 at 02:39:39PM +0100, Fuad Tabba wrote:
> > Fix the places in KVM that treat MDCR_EL2 as a 32-bit register.
> > More recent features (e.g., FEAT_SPEv1p2) use bits above 31.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_arm.h   | 20 ++++++++++----------
> >  arch/arm64/include/asm/kvm_asm.h   |  2 +-
> >  arch/arm64/include/asm/kvm_host.h  |  2 +-
> >  arch/arm64/kvm/debug.c             |  5 +++--
> >  arch/arm64/kvm/hyp/nvhe/debug-sr.c |  2 +-
> >  arch/arm64/kvm/hyp/vhe/debug-sr.c  |  2 +-
> >  6 files changed, 17 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index 692c9049befa..25d8a61888e4 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -280,18 +280,18 @@
> >  /* Hyp Debug Configuration Register bits */
> >  #define MDCR_EL2_E2TB_MASK   (UL(0x3))
> >  #define MDCR_EL2_E2TB_SHIFT  (UL(24))
> > -#define MDCR_EL2_TTRF                (1 << 19)
> > -#define MDCR_EL2_TPMS                (1 << 14)
> > +#define MDCR_EL2_TTRF                (UL(1) << 19)
> > +#define MDCR_EL2_TPMS                (UL(1) << 14)
> >  #define MDCR_EL2_E2PB_MASK   (UL(0x3))
> >  #define MDCR_EL2_E2PB_SHIFT  (UL(12))
> > -#define MDCR_EL2_TDRA                (1 << 11)
> > -#define MDCR_EL2_TDOSA               (1 << 10)
> > -#define MDCR_EL2_TDA         (1 << 9)
> > -#define MDCR_EL2_TDE         (1 << 8)
> > -#define MDCR_EL2_HPME                (1 << 7)
> > -#define MDCR_EL2_TPM         (1 << 6)
> > -#define MDCR_EL2_TPMCR               (1 << 5)
> > -#define MDCR_EL2_HPMN_MASK   (0x1F)
> > +#define MDCR_EL2_TDRA                (UL(1) << 11)
> > +#define MDCR_EL2_TDOSA               (UL(1) << 10)
> > +#define MDCR_EL2_TDA         (UL(1) << 9)
> > +#define MDCR_EL2_TDE         (UL(1) << 8)
> > +#define MDCR_EL2_HPME                (UL(1) << 7)
> > +#define MDCR_EL2_TPM         (UL(1) << 6)
> > +#define MDCR_EL2_TPMCR               (UL(1) << 5)
> > +#define MDCR_EL2_HPMN_MASK   (UL(0x1F))
>
> Personally, I prefer to use the BIT() macro for these things, but what
> you've got here is consistent with the rest of the file and I think that's
> more important.
>
> >  /* For compatibility with fault code shared with 32-bit */
> >  #define FSC_FAULT    ESR_ELx_FSC_FAULT
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 5e9b33cbac51..d88a5550552c 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -209,7 +209,7 @@ extern u64 __vgic_v3_read_vmcr(void);
> >  extern void __vgic_v3_write_vmcr(u32 vmcr);
> >  extern void __vgic_v3_init_lrs(void);
> >
> > -extern u32 __kvm_get_mdcr_el2(void);
> > +extern u64 __kvm_get_mdcr_el2(void);
> >
> >  #define __KVM_EXTABLE(from, to)                                              \
> >       "       .pushsection    __kvm_ex_table, \"a\"\n"                \
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 5645af2a1431..45fdd0b7063f 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -286,7 +286,7 @@ struct kvm_vcpu_arch {
> >
> >       /* HYP configuration */
> >       u64 hcr_el2;
> > -     u32 mdcr_el2;
> > +     u64 mdcr_el2;
> >
> >       /* Exception Information */
> >       struct kvm_vcpu_fault_info fault;
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index d5e79d7ee6e9..f7385bfbc9e4 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -21,7 +21,7 @@
> >                               DBG_MDSCR_KDE | \
> >                               DBG_MDSCR_MDE)
> >
> > -static DEFINE_PER_CPU(u32, mdcr_el2);
> > +static DEFINE_PER_CPU(u64, mdcr_el2);
> >
> >  /**
> >   * save/restore_guest_debug_regs
> > @@ -154,7 +154,8 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
> >
> >  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >  {
> > -     unsigned long mdscr, orig_mdcr_el2 = vcpu->arch.mdcr_el2;
> > +     unsigned long mdscr;
> > +     u64 orig_mdcr_el2 = vcpu->arch.mdcr_el2;
>
> This is arm64 code, so 'unsigned long' is fine here and you can leave the
> existing code as-is.

I'll keep the existing code as it is.

Thanks,
/fuad


> With that:
>
> Acked-by: Will Deacon <will@kernel.org>
>
> Will
