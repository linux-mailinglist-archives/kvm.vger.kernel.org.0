Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A6253F543
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 06:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbiFGErq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 00:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbiFGErk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 00:47:40 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE8F5002C
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 21:47:33 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id h188so22507145oia.2
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 21:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T1Oeoa7n5QDG+gTsiG56VGoP7hbCIGDGBtXMObcL+RI=;
        b=SIZk76Vz626zA8ncZ4xYPOa5eJlc0AzzPErAw21oJSIIGA1id6K3+ztfhxwwms5Fhq
         F+u1W8bakEjgZREX6uhVJ/YMt/diOemeBi0N9+uSsgQKFBYSP7PJn2P6Yonxk0Y1+c/6
         HNPpzV4asEPt9lUEKvFPZMqtO6DXBg4YluZ3qEbn3iG6Al6K7j+vvswIhCSRUuKpGbcv
         J/ko2uVFP8u0cVr0lusbBUmkrq9j0BvAg3JsPZ2UsF3RzhS0/OqOn5Wo/zyf/jGlWnfK
         1quBbjq2H7+B58i3cSCtYHpHhURdZViDZnuqbdp7E9WJh5e1sWJBIMSq+yxlsyfdGo8e
         CeCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T1Oeoa7n5QDG+gTsiG56VGoP7hbCIGDGBtXMObcL+RI=;
        b=OkkI8OdHUjrVRvZwD08Mwytm+15DggMmzzWOZiPWn/OQHbPQxAPTnWvZordJYWB7tt
         gKU11UL4p/aNfpaSpapo9Q0+6RoVHj8fRjXZKuLL+ib2WH1ytdhJLMrZmbD84TJYNdBI
         TcxTWt+6oTWQc3fDqxwGGlfMg/qHCLgeS9hU5oSqhfwBLsP8j2kaSl9gQFUdemqWiEeE
         S0dURcvcLDjWmAv9bG8us8qo0FK2voWQD4W4hacr+pBAOmIR4FgULXvdV1m546xh8vDM
         Ptk7D9EnR6S7agIT90EcyAux7r+lekcMa1tZBqTySpvS66kRhnBPMtQWqT4qCK3TFwH8
         tYQA==
X-Gm-Message-State: AOAM533uO7aK0cettqUUfiXB2XmExnTfZXdPZUd8IH/zqc/4JztHV6Yb
        b5e/r2FTktlBUMh469UnCr7AneU7YotLT4Z6vpWYeA==
X-Google-Smtp-Source: ABdhPJzM/y1Bdi+IWw5eq1YlfditPyyuVf2cLfzRK+X6/I314sxKlnjQR10W7nJpF/C+Qr5u4SPzl6E/ps4EXbjxwIk=
X-Received: by 2002:a05:6808:3198:b0:32b:a54:1238 with SMTP id
 cd24-20020a056808319800b0032b0a541238mr31223949oib.16.1654577252563; Mon, 06
 Jun 2022 21:47:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org> <20220528113829.1043361-4-maz@kernel.org>
 <CAAeT=FxmD4Nsrodr-FCjpNghAormCg4P+R7hF3+g_wfQ5T12Rg@mail.gmail.com> <87wndwluhy.wl-maz@kernel.org>
In-Reply-To: <87wndwluhy.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 6 Jun 2022 21:47:16 -0700
Message-ID: <CAAeT=FxcUF-nNhzwSTQm_oueF4Cu_8nDdFfoCi33HOpOZaBjXg@mail.gmail.com>
Subject: Re: [PATCH 03/18] KVM: arm64: Drop FP_FOREIGN_STATE from the
 hypervisor code
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kernel-team@android.com, Will Deacon <will@kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 4, 2022 at 1:10 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 03 Jun 2022 06:23:25 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Sat, May 28, 2022 at 4:38 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > The vcpu KVM_ARM64_FP_FOREIGN_FPSTATE flag tracks the thread's own
> > > TIF_FOREIGN_FPSTATE so that we can evaluate just before running
> > > the vcpu whether it the FP regs contain something that is owned
> > > by the vcpu or not by updating the rest of the FP flags.
> > >
> > > We do this in the hypervisor code in order to make sure we're
> > > in a context where we are not interruptible. But we already
> > > have a hook in the run loop to generate this flag. We may as
> > > well update the FP flags directly and save the pointless flag
> > > tracking.
> > >
> > > Whilst we're at it, rename update_fp_enabled() to guest_owns_fp_regs()
> > > to indicate what the leftover of this helper actually do.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> >
> > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> >
> >
> > > --- a/arch/arm64/kvm/fpsimd.c
> > > +++ b/arch/arm64/kvm/fpsimd.c
> > > @@ -107,16 +107,19 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
> > >  }
> > >
> > >  /*
> > > - * Called just before entering the guest once we are no longer
> > > - * preemptable. Syncs the host's TIF_FOREIGN_FPSTATE with the KVM
> > > - * mirror of the flag used by the hypervisor.
> > > + * Called just before entering the guest once we are no longer preemptable
> > > + * and interrupts are disabled. If we have managed to run anything using
> > > + * FP while we were preemptible (such as off the back of an interrupt),
> > > + * then neither the host nor the guest own the FP hardware (and it was the
> > > + * responsibility of the code that used FP to save the existing state).
> > > + *
> > > + * Note that not supporting FP is basically the same thing as far as the
> > > + * hypervisor is concerned (nothing to save).
> > >   */
> > >  void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu)
> > >  {
> > > -       if (test_thread_flag(TIF_FOREIGN_FPSTATE))
> > > -               vcpu->arch.flags |= KVM_ARM64_FP_FOREIGN_FPSTATE;
> > > -       else
> > > -               vcpu->arch.flags &= ~KVM_ARM64_FP_FOREIGN_FPSTATE;
> > > +       if (!system_supports_fpsimd() || test_thread_flag(TIF_FOREIGN_FPSTATE))
> > > +               vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED | KVM_ARM64_FP_HOST);
> > >  }
> >
> > Although kvm_arch_vcpu_load_fp() unconditionally sets KVM_ARM64_FP_HOST,
> > perhaps having kvm_arch_vcpu_load_fp() set KVM_ARM64_FP_HOST only when
> > FP is supported might be more consistent?
> > Then, checking system_supports_fpsimd() is unnecessary here.
> > (KVM_ARM64_FP_ENABLED is not set when FP is not supported)
>
> That's indeed a possibility. But I'm trying not to change the logic
> here, only to move it to a place that provides the same semantic
> without the need for an extra flag.
>
> I'm happy to stack an extra patch on top of this series though.

Thank you for your reply. I would prefer that.

Thanks,
Reiji



>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
