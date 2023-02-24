Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD6A6A1FFA
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 17:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjBXQsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 11:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBXQsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 11:48:22 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6051EBDF
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 08:48:20 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id x30-20020a056a00189e00b005a8e8833e93so6994604pfh.12
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 08:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ILR0j/26JTsbcQk101qnmkclUDQ7nmjDuNRVz9SIjzI=;
        b=PjUhLjR5FU+VRl8izc310auUt5M2kk/e9s/SRQxu6s50yPRY0S9RACug3nUHBfk9C3
         XzuqZHweYxk2chzDD/KWsWWaXMZqvDKyMdfBxiYzJlid7LAt9rwCiBmDBqCIKdmwqcXn
         Hd8lAbl5j8WCHvCZXwPt8ajRA2PokgkH7hksN04xcuSf0/hK3knYe9ujdVJjNz/wmvpI
         wqGOS4l3qEkIQ0IZ4xXzzEode6GfYKh1OB2Fd7tDQHxc+FWBbZHZZIHHAg39rReSWpfm
         hE6dNCLGYAy9ATyjnW4hEjjkaeSbxyFFsLjGRKgKkzOoT6Iuy9fqNys9+ukLkDLmeeGB
         kezg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ILR0j/26JTsbcQk101qnmkclUDQ7nmjDuNRVz9SIjzI=;
        b=YU8XaCt/O3KeDc+cux8lepjF5q3DWlh1oX8qbnyw5OSU5uwgEwJvAfWoMJ87LxG1k/
         /djL+kvVKn/yyCWlvRV3TCffPGOuG8QJPaepO/Gwfp3Y+YDmBzfKhT5igQqXOJcNlNA9
         7O7z47toYZozu6P6S9nKGqQDV3e+rmPjo42+rjLC9K8lpQs+lUI/ChISzl0k8OCFO92K
         Ras6wm8I1ZLGgqDnLLCdmOQ2FidoWKHTb3+duLlVHt7wGaszUtKXPNpMozE/cLJRIX6U
         7JzuFYhJZu4bdmIUThc9c93lT4KTFPHRVFMJU4VZCL/Y0IQyw4E3H0XQAt48Le+bDsAk
         rCWQ==
X-Gm-Message-State: AO0yUKWTWiu8w/ze34/umDq0/fvMP1kVSf8XH7k2NoQjZnlWfjUi4XkZ
        OZE33jyZ1Web+8sFenMXgtylLhJTmPk=
X-Google-Smtp-Source: AK7set8aro7L74Rqb5E5ITiT/vmpAgslfSFlgbbLNq7rVNbg/bLDNVUGqn9MNt5Fkz4J25zobYFuEDhSnxc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f7c7:b0:19c:140d:aad7 with SMTP id
 h7-20020a170902f7c700b0019c140daad7mr3144766plw.4.1677257300003; Fri, 24 Feb
 2023 08:48:20 -0800 (PST)
Date:   Fri, 24 Feb 2023 08:48:18 -0800
In-Reply-To: <3ad0d6fdd65a90150358c62161e392736f55a1b4.camel@redhat.com>
Mime-Version: 1.0
References: <20221129193717.513824-1-mlevitsk@redhat.com> <20221129193717.513824-3-mlevitsk@redhat.com>
 <Y9RuQz8dAT7DZGYk@google.com> <Y9hybI65So5X2LFg@google.com> <3ad0d6fdd65a90150358c62161e392736f55a1b4.camel@redhat.com>
Message-ID: <Y/jqUgR6zTcptcxw@google.com>
Subject: Re: [PATCH v2 02/11] KVM: nSVM: clean up the copying of V_INTR bits
 from vmcb02 to vmcb12
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023, Maxim Levitsky wrote:
> On Tue, 2023-01-31 at 01:44 +0000, Sean Christopherson wrote:
> > On Sat, Jan 28, 2023, Sean Christopherson wrote:
> > So I think this over two patches?
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 05d38944a6c0..ad1e70ac8669 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -139,13 +139,18 @@ void recalc_intercepts(struct vcpu_svm *svm)
> >  
> >         if (g->int_ctl & V_INTR_MASKING_MASK) {
> >                 /*
> > -                * Once running L2 with HF_VINTR_MASK, EFLAGS.IF and CR8
> > -                * does not affect any interrupt we may want to inject;
> > -                * therefore, writes to CR8 are irrelevant to L0, as are
> > -                * interrupt window vmexits.
> > +                * If L2 is active and V_INTR_MASKING is enabled in vmcb12,
> > +                * disable intercept of CR8 writes as L2's CR8 does not affect
> > +                * any interrupt KVM may want to inject.
> > +                *
> > +                * Similarly, disable intercept of virtual interrupts (used to
> > +                * detect interrupt windows) if the saved RFLAGS.IF is '0', as
> > +                * the effective RFLAGS.IF for L1 interrupts will never be set
> > +                * while L2 is running (L2's RFLAGS.IF doesn't affect L1 IRQs).
> >                  */
> >                 vmcb_clr_intercept(c, INTERCEPT_CR8_WRITE);
> > -               vmcb_clr_intercept(c, INTERCEPT_VINTR);
> > +               if (!(svm->vmcb01.ptr->save.rflags & X86_EFLAGS_IF))
> > +                       vmcb_clr_intercept(c, INTERCEPT_VINTR);
> 
> How about instead moving this code to svm_set_vintr?

I considered that, but it doesn't handle the case where INTERCEPT_VINTR was set
in vmcb01 before nested VMRUN, i.e. KVM is waiting for an interrupt window at
the time of L1, and L1 doesn't set RFLAGS.IF=1 prior to VMRUN.

> That is, in the guest mode, if the guest has V_INTR_MASKING_MASK, then
> then a nested VM exit is the next point the interrupt window could open,
> thus we don't set VINTR)
> 
> Or even better put the logic in svm_enable_irq_window (that is avoid
> calling svm_set_vintr in the first place).
> 
> I also think that it worth it to add a warning that 'svm_set_intercept'
> didn't work, that is didn't really set an intercept.

Heh, I had coded that up too, but switched to bailing from svm_set_vintr() if the
intercept was disabled because of the aforementioned scenario.

> In theory that can result in nasty CVEs in addition to logic bugs as you found.

I don't think this can result in a CVE, at least not without even worse bugs in
L1.  KVM uses INTERCEPT_VINTR purely to detect interrupt windows, and failure to
configure an IRQ window would at worst cause KVM to delay an IRQ.  If a missing
or late IRQ lets L2 extract data from L1, then L1 has problems of its own.

> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index b103fe7cbc82..59d2891662ef 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1580,6 +1580,16 @@ static void svm_set_vintr(struct vcpu_svm *svm)
> >  
> >         svm_set_intercept(svm, INTERCEPT_VINTR);
> >  
> > +       /*
> > +        * Recalculating intercepts may have clear the VINTR intercept.  If
> > +        * V_INTR_MASKING is enabled in vmcb12, then the effective RFLAGS.IF
> > +        * for L1 physical interrupts is L1's RFLAGS.IF at the time of VMRUN.
> > +        * Requesting an interrupt window if save.RFLAGS.IF=0 is pointless as
> > +        * interrupts will never be unblocked while L2 is running.
> > +        */
> > +       if (!svm_is_intercept(svm, INTERCEPT_VINTR))
> > +               return;
> 
> This won't be needed if we don't call the svm_set_vintr in the first place.
> 
> > +
> >         /*
> >          * This is just a dummy VINTR to actually cause a vmexit to happen.
> >          * Actual injection of virtual interrupts happens through EVENTINJ.
> > 
> 
> 
> 
> With all this said, I also want to note that this patch has *nothing* to do with VNMI,
> I only added it due to some refactoring, so feel free to drop it from vNMI queue,
> and deal with those bugs separately.

Ya, let's tackle this in a separate series.  I'll circle back to this after rc1
(I'm OOO next week).

Santosh, in the next version of the vNMI series, can you drop any patches that
aren't strictly necessary to enable vNMI?
