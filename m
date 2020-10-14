Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8B328E162
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 15:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731283AbgJNNeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 09:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbgJNNeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 09:34:02 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668E9C061755
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 06:34:01 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id t9so2202441qtp.9
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 06:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3cj9i5uqo0RiJQaksvGE9VHCNsDvBMNyIbd6+Rvdgwg=;
        b=alHlUfyw3A/g+oCv/sEWfAOAAxz+sa+SJFoZuFWxaHpARqBVx+vZ0vhWoiNbqy/2p5
         X9lRPn0zWFPJfAdjIWoh9n669GUHihhRVLtWrnM/Wr+2abt413yRKtY2jrOHFSrQKGSz
         l9ihuPx8ZXrU0twyDuUN3djZ9JcpZbFe/Mh6WBmDbfrXyDqkXVDBaMdoOeBB62T2bWgJ
         deMxEk6Vltki7waP7DdHvIHbUVjRuZgkE9LOFFVAUNyMuOEl3R0FYHkaiDjdTaF8/WTy
         l4PA52ArcHC5NBkW/d8NbCsdyaWgPLob2zbKdCPHdGe8D31sSk6zVFzQylz/GmDUUZ6H
         aPHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3cj9i5uqo0RiJQaksvGE9VHCNsDvBMNyIbd6+Rvdgwg=;
        b=Qg6ux/nuw9MmD7jmi0YwTZUReP23+6bNt4jVqax3FieJwLZCvDFSkCEirZXq+TZO32
         8VUAF+YBQgDvukeTC1lVTtd4ff1Sg2mEfLHkRoXezGjOU+D44jAVXF8jnWj4MWY1s43L
         1A42nPyt1WA4DdsHjs5tPev6l5DdfOu259AeEcPYu0esevERc5LubhmkuHqkR65imOnc
         yhon5Ayohtvn0eR3Vg9yeUdNJ+2dmonvWwHM+xLPfDYZj5G7GORfjW3Lsm7sFw31FIe4
         xKC3vic9ZW0+yuaFy1doIcSJGY3whsgL4BXowRuknh6rp+KX1OHqPlU+SjfQbs5btOeg
         1j0w==
X-Gm-Message-State: AOAM533Aa9wkwADQZ6puiZI1OsSo+7YNwRwxz84ZSLvXg9X464N6BdrR
        GGePD9xZc7GKO7/lwFEwN2CaCueWIMeLB1yKn3tBiP3GxKA=
X-Google-Smtp-Source: ABdhPJzd4mtqdC8Yqqu+ENJ28sEA87WXyTiIQDHbfLjRHFi6hmc6rfJQD5cB5XAmi+hOnr45dt/l5WPB4wAageH5x10=
X-Received: by 2002:ac8:5c94:: with SMTP id r20mr4831960qta.292.1602682440489;
 Wed, 14 Oct 2020 06:34:00 -0700 (PDT)
MIME-Version: 1.0
References: <20201007144312.55203-1-ubizjak@gmail.com> <20201013150921.GB13936@linux.intel.com>
In-Reply-To: <20201013150921.GB13936@linux.intel.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Wed, 14 Oct 2020 15:33:49 +0200
Message-ID: <CAFULd4aCfuyRA5o8yreRU-o67ue8KGouZ2VR14oa7HBPHtQ2Cw@mail.gmail.com>
Subject: Re: [PATCH] KVM/nVMX: Move nested_vmx_check_vmentry_hw inline
 assembly to vmenter.S
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 13, 2020 at 5:19 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Oct 07, 2020 at 04:43:12PM +0200, Uros Bizjak wrote:
> > Move the big inline assembly block from nested_vmx_check_vmentry_hw
> > to vmenter.S assembly file, taking into account all ABI requirements.
> >
> > The new function is modelled after __vmx_vcpu_run, and also calls
> > vmx_update_host_rsp instead of open-coding the function in assembly.
>
> Is there specific motivation for this change?  The inline asm is ugly, but
> it's contained.

The motivation was mostly the removal of open-coded asm implementation
of vmx_update_host_rsp, with corresponding asm arguments. Later, I
also noticed, that the resulting asm is surprisingly similar to
__vmx_vcpu_run, so I assumed that it would be nice to put the whole
low-level function to vmenter.S
>
> If we really want to get rid of the inline asm, I'd probably vote to simply
> use __vmx_vcpu_run() instead of adding another assembly helper.  The (double)
> GPR save/restore is wasteful, but this flow is basically anti-performance
> anyways.  Outside of KVM developers, I doubt anyone actually enables this path.

If this is the case, then the removal of a bunch of bytes at the
expense of a few extra cycles is a good deal.

Uros.

> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c  | 32 +++-----------------------------
> >  arch/x86/kvm/vmx/vmenter.S | 36 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 39 insertions(+), 29 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 1bb6b31eb646..7b26e983e31c 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3012,6 +3012,8 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
> >       return 0;
> >  }
> >
> > +bool __nested_vmx_check_vmentry_hw(struct vcpu_vmx *vmx, bool launched);
> > +
> >  static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
> >  {
> >       struct vcpu_vmx *vmx = to_vmx(vcpu);
> > @@ -3050,35 +3052,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
> >               vmx->loaded_vmcs->host_state.cr4 = cr4;
> >       }
> >
> > -     asm(
> > -             "sub $%c[wordsize], %%" _ASM_SP "\n\t" /* temporarily adjust RSP for CALL */
> > -             "cmp %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
> > -             "je 1f \n\t"
> > -             __ex("vmwrite %%" _ASM_SP ", %[HOST_RSP]") "\n\t"
> > -             "mov %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
> > -             "1: \n\t"
> > -             "add $%c[wordsize], %%" _ASM_SP "\n\t" /* un-adjust RSP */
> > -
> > -             /* Check if vmlaunch or vmresume is needed */
> > -             "cmpb $0, %c[launched](%[loaded_vmcs])\n\t"
> > -
> > -             /*
> > -              * VMLAUNCH and VMRESUME clear RFLAGS.{CF,ZF} on VM-Exit, set
> > -              * RFLAGS.CF on VM-Fail Invalid and set RFLAGS.ZF on VM-Fail
> > -              * Valid.  vmx_vmenter() directly "returns" RFLAGS, and so the
> > -              * results of VM-Enter is captured via CC_{SET,OUT} to vm_fail.
> > -              */
> > -             "call vmx_vmenter\n\t"
> > -
> > -             CC_SET(be)
> > -           : ASM_CALL_CONSTRAINT, CC_OUT(be) (vm_fail)
> > -           : [HOST_RSP]"r"((unsigned long)HOST_RSP),
> > -             [loaded_vmcs]"r"(vmx->loaded_vmcs),
> > -             [launched]"i"(offsetof(struct loaded_vmcs, launched)),
> > -             [host_state_rsp]"i"(offsetof(struct loaded_vmcs, host_state.rsp)),
> > -             [wordsize]"i"(sizeof(ulong))
> > -           : "memory"
> > -     );
> > +     vm_fail = __nested_vmx_check_vmentry_hw(vmx, vmx->loaded_vmcs->launched);
> >
> >       if (vmx->msr_autoload.host.nr)
> >               vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
> > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > index 799db084a336..9fdcbd9320dc 100644
> > --- a/arch/x86/kvm/vmx/vmenter.S
> > +++ b/arch/x86/kvm/vmx/vmenter.S
> > @@ -234,6 +234,42 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >       jmp 1b
> >  SYM_FUNC_END(__vmx_vcpu_run)
> >
> > +/**
> > + * __nested_vmx_check_vmentry_hw - Run a vCPU via a transition to
> > + *                              a nested VMX guest mode
>
> This function comment is incorrect, this helper doesn't run the vCPU, it
> simply executes VMLAUNCH or VMRESUME, which are expected to fail (and we're
> in BUG_ON territory if they don't).
>
> > + * @vmx:     struct vcpu_vmx * (forwarded to vmx_update_host_rsp)
> > + * @launched:        %true if the VMCS has been launched
> > + *
> > + * Returns:
> > + *   0 on VM-Exit, 1 on VM-Fail
> > + */
> > +SYM_FUNC_START(__nested_vmx_check_vmentry_hw)
> > +     push %_ASM_BP
> > +     mov  %_ASM_SP, %_ASM_BP
> > +
> > +     push %_ASM_BX
> > +
> > +     /* Copy @launched to BL, _ASM_ARG2 is volatile. */
> > +     mov %_ASM_ARG2B, %bl
> > +
> > +     /* Adjust RSP to account for the CALL to vmx_vmenter(). */
> > +     lea -WORD_SIZE(%_ASM_SP), %_ASM_ARG2
> > +     call vmx_update_host_rsp
> > +
> > +     /* Check if vmlaunch or vmresume is needed */
> > +     cmpb $0, %bl
> > +
> > +     /* Enter guest mode */
> > +     call vmx_vmenter
> > +
> > +     /* Return 0 on VM-Exit, 1 on VM-Fail */
> > +     setbe %al
> > +
> > +     pop %_ASM_BX
> > +
> > +     pop %_ASM_BP
> > +     ret
> > +SYM_FUNC_END(__nested_vmx_check_vmentry_hw)
> >
> >  .section .text, "ax"
> >
> > --
> > 2.26.2
> >
