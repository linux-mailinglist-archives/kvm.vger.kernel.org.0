Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9545C253C
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 18:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732324AbfI3QgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 12:36:13 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38607 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731459AbfI3QgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 12:36:12 -0400
Received: by mail-io1-f66.google.com with SMTP id u8so39973490iom.5
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=57AYY0u9MsjJUEECwEHvJ6u5btLkPcCRtuHnRrQJapI=;
        b=vLauWTgcxacCbWHTj6hvXFeeR30sX8SyJgIlTSPJr45xUSCPN0cc61USSem4QktzVu
         1fLAbMtzn7E6wwIcQQ9Qd0RVLTIxhHY1MLeDcSpP9ufT4DJosLB+3r+OPzdZNHpkbKmz
         mz+YMahFibVjm4rf/MZy96c+siAyc/yhRsvsYoW9ClHHo3L01GmmDVMCsien66ZsT9og
         VF/owRigzm9RIzkwXRqavUQQfv3opkdTPdSklH3yVH4rP6CmaJIwNAyqlJUPXnACQtYF
         /6Rj7pf1GvmVE5IUCx+kLdTB7Fqc6G1uUJKPthXf1KSDFmgzErceeWha/VLVbEybmO9Y
         9xOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=57AYY0u9MsjJUEECwEHvJ6u5btLkPcCRtuHnRrQJapI=;
        b=JkcfgffOtUu5As4oFGS8OZCkkog1LXPaZwDa2Dci1qA7REBEokfVE5BcqNEtPG7Qzw
         PtTC3/SBblY+npcO3nW+fbwLx+W+rQv1PpQwSb85RKEqeF995hvJDYz/PfXieLb26P2Z
         8Wgj84MG3NLYuJo+xKME1s2/YQLALP2CFx1pkJ9mO/6rUze5rUoMjhvd04/UhtpyaCVZ
         ERbw6xnXANLGZMmBwCkp078wPzywkhxM9vVI7t2RMfcGUKFcN7yaZegsueQDqfRmseuB
         R2gOGjmMM/ty2411jKxTJvn7C8ucF2FH+swDmkfB6yLZgtPuua5SZd4Do6S1u5t0kqTT
         3N/g==
X-Gm-Message-State: APjAAAUNmAG9SleZYy5R9Z33QzIG3U9iJR8+DfbfGk7ffiYqyamTAIiS
        fTSJL2ug8D9g2Y+8rybTZmatfva9xUhwYi9WawEwdw==
X-Google-Smtp-Source: APXvYqx2dfIYRy7h7yKIgZKiCnDmCdiQI5dNKGF/qRsXgS205w50n9oDynATQka9xJ5xedvTduDqhuq0gE1j/gyAa60=
X-Received: by 2002:a02:ac82:: with SMTP id x2mr20116222jan.18.1569861371034;
 Mon, 30 Sep 2019 09:36:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190929145018.120753-1-liran.alon@oracle.com> <874l0u5jb4.fsf@vitty.brq.redhat.com>
In-Reply-To: <874l0u5jb4.fsf@vitty.brq.redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 30 Sep 2019 09:35:59 -0700
Message-ID: <CALMp9eS7wF1b6yBJrj_VL+HMEYjuZrYhmMHiCqJq8-33d9QE6A@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Remove proprietary handling of unexpected exit-reasons
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>, tao3.xu@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 12:34 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Liran Alon <liran.alon@oracle.com> writes:
>
> > Commit bf653b78f960 ("KVM: vmx: Introduce handle_unexpected_vmexit
> > and handle WAITPKG vmexit") introduced proprietary handling of
> > specific exit-reasons that should not be raised by CPU because
> > KVM configures VMCS such that they should never be raised.
> >
> > However, since commit 7396d337cfad ("KVM: x86: Return to userspace
> > with internal error on unexpected exit reason"), VMX & SVM
> > exit handlers were modified to generically handle all unexpected
> > exit-reasons by returning to userspace with internal error.
> >
> > Therefore, there is no need for proprietary handling of specific
> > unexpected exit-reasons (This proprietary handling also introduced
> > inconsistency for these exit-reasons to silently skip guest instruction
> > instead of return to userspace on internal-error).
> >
> > Fixes: bf653b78f960 ("KVM: vmx: Introduce handle_unexpected_vmexit and handle WAITPKG vmexit")
> >
> > Signed-off-by: Liran Alon <liran.alon@oracle.com>
>
> (It's been awhile since in software world the word 'proprietary' became
> an opposite of free/open-source to me so I have to admit your subject
> line really got me interested :-)
>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

I agree that proprietary is an unusual word choice.

Reviewed-by: Jim Mattson <jmattson@google.com>

> > ---
> >  arch/x86/kvm/vmx/vmx.c | 12 ------------
> >  1 file changed, 12 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index d4575ffb3cec..e31317fc8c95 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -5538,14 +5538,6 @@ static int handle_encls(struct kvm_vcpu *vcpu)
> >       return 1;
> >  }
> >
> > -static int handle_unexpected_vmexit(struct kvm_vcpu *vcpu)
> > -{
> > -     kvm_skip_emulated_instruction(vcpu);
> > -     WARN_ONCE(1, "Unexpected VM-Exit Reason = 0x%x",
> > -             vmcs_read32(VM_EXIT_REASON));
> > -     return 1;
> > -}
> > -
> >  /*
> >   * The exit handlers return 1 if the exit was handled fully and guest execution
> >   * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
> > @@ -5597,15 +5589,11 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
> >       [EXIT_REASON_INVVPID]                 = handle_vmx_instruction,
> >       [EXIT_REASON_RDRAND]                  = handle_invalid_op,
> >       [EXIT_REASON_RDSEED]                  = handle_invalid_op,
> > -     [EXIT_REASON_XSAVES]                  = handle_unexpected_vmexit,
> > -     [EXIT_REASON_XRSTORS]                 = handle_unexpected_vmexit,
> >       [EXIT_REASON_PML_FULL]                = handle_pml_full,
> >       [EXIT_REASON_INVPCID]                 = handle_invpcid,
> >       [EXIT_REASON_VMFUNC]                  = handle_vmx_instruction,
> >       [EXIT_REASON_PREEMPTION_TIMER]        = handle_preemption_timer,
> >       [EXIT_REASON_ENCLS]                   = handle_encls,
> > -     [EXIT_REASON_UMWAIT]                  = handle_unexpected_vmexit,
> > -     [EXIT_REASON_TPAUSE]                  = handle_unexpected_vmexit,
> >  };
> >
> >  static const int kvm_vmx_max_exit_handlers =
>
> --
> Vitaly
