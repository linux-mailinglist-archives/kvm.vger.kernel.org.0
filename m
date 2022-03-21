Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE854E2EE6
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 18:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243076AbiCURQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 13:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbiCURQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 13:16:49 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F40836B7D
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 10:15:23 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 17so20841850lji.1
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 10:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ASR2Tp21xFTBKs2aldi8ocrtwajoK0X33Y9PeeH/QZU=;
        b=DQasT1Sp9Zq9weVTaBBAUkSy7Jl9Mc3HJtFf945qq9AXunEtCTOG164JbIacqmXf6W
         iAaaVHB5+Q1ipwaMayQ7FTjZckUeLBC+3tfERVEEsSuZqRlZNTX1xBHQgOCrEDI2++mu
         VAKVIQPk2Key3jbGlD4PZn3xca+ObSYOwbJ1M4xLrTKN9gWDrVVHqCtSFopJXSWJd/Bu
         TCxHuQ38Ofn5voBFf8/MbG04rmjJ9I5r0LuIMwH34mNc6hxNdh7wrebR+613nFqdCfb3
         qmYY8SHkGtwgFQZdVHhjF99R14lt1xFgtWaifbKQxQTzC9j6UZpA58notU4rLq2RTDy0
         EK7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ASR2Tp21xFTBKs2aldi8ocrtwajoK0X33Y9PeeH/QZU=;
        b=0n1cwKuPUhOCnrtUtglgI9h9tuu4TR2d0jZH2/oLAkKxiuDenFoeJ/UqHXFqasn4eU
         4xON4EBCIsEFv5uu9c5iQ9CQ0MWK1VmZ5+O/z5hqN6U8f6AauW65HQX6bgq3kkeK/Dcq
         b2N//GMH0jYpF6TCPrDWsIvxjXE6ReyeW8Grt0J7wFdStUm6eV5iNrvYKSbytmo6DAt1
         3tuKrYVpU8GWkSLW5Zu2o50kzjmCs/Mml97TKMi+uJvYcyCOb7nUtI3FRDR/KxorIu6G
         84zUJ7CMnnXXWGh8xqW/TMnctj2HWDGP8qty3WN1gb3I+n2L2RVqQDmAJGQ3D91R6ihq
         00+A==
X-Gm-Message-State: AOAM531EuG+piD5dmvDywPPzogL08Y9IxnhOk8E08Tkjj35e0dD1HaC0
        MRg2r5QH0cWkMPpiry/P2sQ+bvupgLSFDt0J9dSiVw==
X-Google-Smtp-Source: ABdhPJy/ZfSIQDd1JA4aixgH4poyogQFYXTkSKoAkSkbJFmGoOIHzrbSC2uss7OMkvJYkXva6SeI2I7+zD9/CK9PxYM=
X-Received: by 2002:a05:651c:553:b0:247:df66:8698 with SMTP id
 q19-20020a05651c055300b00247df668698mr16133887ljp.331.1647882918885; Mon, 21
 Mar 2022 10:15:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220317005630.3666572-1-jingzhangos@google.com>
 <20220317005630.3666572-3-jingzhangos@google.com> <YjLJHDV58GRMxF2P@google.com>
In-Reply-To: <YjLJHDV58GRMxF2P@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 21 Mar 2022 10:14:52 -0700
Message-ID: <CALzav=fnkU3s+RXGO-LVJCj75FsxvR13n-y1nV1ksp=aLF-etA@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] KVM: arm64: Add debug tracepoint for vcpu exits
To:     Oliver Upton <oupton@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

On Wed, Mar 16, 2022 at 10:37 PM Oliver Upton <oupton@google.com> wrote:
>
> Hi Jing,
>
> On Thu, Mar 17, 2022 at 12:56:30AM +0000, Jing Zhang wrote:
> > This tracepoint only provides a hook for poking vcpu exits information,
> > not exported to tracefs.
> > A timestamp is added for the last vcpu exit, which would be useful for
> > analysis for vcpu exits.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 3 +++
> >  arch/arm64/kvm/arm.c              | 2 ++
> >  arch/arm64/kvm/trace_arm.h        | 8 ++++++++
> >  3 files changed, 13 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index daa68b053bdc..576f2c18d008 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -415,6 +415,9 @@ struct kvm_vcpu_arch {
> >
> >       /* Arch specific exit reason */
> >       enum arm_exit_reason exit_reason;
> > +
> > +     /* Timestamp for the last vcpu exit */
> > +     u64 last_exit_time;
> >  };
> >
> >  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index f49ebdd9c990..98631f79c182 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -783,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >       ret = 1;
> >       run->exit_reason = KVM_EXIT_UNKNOWN;
> >       while (ret > 0) {
> > +             trace_kvm_vcpu_exits(vcpu);
> >               /*
> >                * Check conditions before entering the guest
> >                */
> > @@ -898,6 +899,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >               local_irq_enable();
> >
> >               trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> > +             vcpu->arch.last_exit_time = ktime_to_ns(ktime_get());
> >
> >               /* Exit types that need handling before we can be preempted */
> >               handle_exit_early(vcpu, ret);
> > diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
> > index 33e4e7dd2719..3e7dfd640e23 100644
> > --- a/arch/arm64/kvm/trace_arm.h
> > +++ b/arch/arm64/kvm/trace_arm.h
> > @@ -301,6 +301,14 @@ TRACE_EVENT(kvm_timer_emulate,
> >                 __entry->timer_idx, __entry->should_fire)
> >  );
> >
> > +/*
> > + * Following tracepoints are not exported in tracefs and provide hooking
> > + * mechanisms only for testing and debugging purposes.
> > + */
> > +DECLARE_TRACE(kvm_vcpu_exits,
> > +     TP_PROTO(struct kvm_vcpu *vcpu),
> > +     TP_ARGS(vcpu));
> > +
>
> When we were discussing this earlier, I wasn't aware of the kvm_exit
> tracepoint which I think encapsulates what you're looking for.
> ESR_EL2.EC is the critical piece to determine what caused the exit.
>
> It is probably also important to call out that this trace point only
> will fire for a 'full' KVM exit (i.e. out of hyp and back to the
> kernel). There are several instances where the exit is handled in hyp
> and we immediately resume the guest.
>
> Now -- I am bordering on clueless with tracepoints, but it isn't
> immediately obvious how the attached program can determine the vCPU that
> triggered the TP. If we are going to propose modularizing certain KVM
> metrics with tracepoints then that would be a rather critical piece of
> information.
>
> Apologies for any confusion I added to the whole situation, but
> hopefully we can still engage in a broader conversation regarding
> how to package up optional KVM metrics.

These are all good questions.

For context to non-Google folks on the mailing list, we are interested
in exploring Marc's idea of using tracepoint hooking as a way for e.g.
cloud providers to implement proprietary stats without having to
modify KVM.

Adding specific tracepoints (like this series does) is probably
premature until we have figured out the broader design for how
out-of-module stats will work end-to-end and get that infrastructure
merged upstream.

>
> --
> Thanks,
> Oliver
