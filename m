Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3FD523506
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 16:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244379AbiEKOIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 10:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244372AbiEKOIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 10:08:52 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0EF69B44
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 07:08:50 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id v65so2798342oig.10
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 07:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jbZi7aD7HF5d+cYrJ2gTsbZ+g97ak3Jgaq79GRl++zQ=;
        b=sqcisbmPoXayTwTEmdEN8L2/Fnh2yGozJM478qj99EiB32SHbtOahaEyOafgJ71uxf
         so8C9gl3bgWMHr4V2T1C32SjXrLeIT7SK7bDwhmFqY27FMzS4TYvxUz4sHukJt3ZqShA
         xcEPWxvULhcKC76iQVT4FWzXTfuyqN5JOEtLc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jbZi7aD7HF5d+cYrJ2gTsbZ+g97ak3Jgaq79GRl++zQ=;
        b=owgVdrHbPGVYybeGYSu4tf4qqwr+IkFoMHh6QkUIuHtNkqvpBhaLEwUO0yuDhs2ZgQ
         e2+4m42PYlzBDu6OfxluZ/AHU4iRc34XLhfG/bCxEFMl4I6Ry4b4fB/Ib5H98IDLz7OT
         OWt+rDPp9oyeczTI4jVFab+EeV23yw+n+h/i8n/ooHTeiPJsQ8a4xr39vmOkzpZ2Jnwq
         528TXGV7gPhCXmeaZoXgeAjWc1PIzUFDwa3+TM4Fxkl/N+ikmst3UIiZdk1vJXEhBYs1
         cimj/EKxvYPJk4Tnt91yUrstvvqb7vonJXefagl/sxz4i/XbX4DCXoxHci9Q7SCuQ1Va
         HGIQ==
X-Gm-Message-State: AOAM533SJfL9PBv5CrQjXFgyjXC1kEIBzIPuToa8E2efm6okJ1iyYwbW
        f3A58NWQW+5TYfO9neTrapWqKz21fF/nYWQiiOB9ZA==
X-Google-Smtp-Source: ABdhPJzJK0McCFXYnWPs4hNAYlc6rqskS1kcny5wteDXCAegY/XjPtjP55SAJ2efbmDTeyfZJE1FVurfTl2wHNiqhcU=
X-Received: by 2002:a05:6808:199c:b0:326:a498:b638 with SMTP id
 bj28-20020a056808199c00b00326a498b638mr2665422oib.186.1652278130080; Wed, 11
 May 2022 07:08:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGDS+GM9Aw6Yvhv+F6wMGvrkz421kfq0j_PZa9F0AKyp5cEQA@mail.gmail.com>
 <YnGUazEgCJWgB6Yw@google.com> <CAJGDS+F0hB=0bj8spt9sophJyhdXTkYXK8LXUrt=7mov4s2JJA@mail.gmail.com>
 <CAJGDS+E5f2Xo68dsEkOfchZybU1uTSb=BgcTgQMLe0tW32m5xg@mail.gmail.com>
 <CALMp9eT3FeDa735Mo_9sZVPfovGQbcqXAygLnz61-acHV-L7+w@mail.gmail.com> <YnvBMnD6fuh+pAQ6@google.com>
In-Reply-To: <YnvBMnD6fuh+pAQ6@google.com>
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Wed, 11 May 2022 19:38:38 +0530
Message-ID: <CAJGDS+GMxG1gXMS1cW1+sS1V67h65iUpMGwQ=+-MVTE6DTOBjg@mail.gmail.com>
Subject: Re: Causing VMEXITs when kprobes are hit in the guest VM
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Jim and Sean,

Thank you for your answers.

If I re-inject the #BP back into the guest, does it automatically take
care of updating the RIP and continuing execution?

I have seen that advancing RIP is unpredictable, works for some
instructions, not for others, so ideally I wouldn't want to go that
route.

Regards,
Arnabjyoti Kalita

On Wed, May 11, 2022 at 7:29 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, May 11, 2022, Jim Mattson wrote:
> > On Fri, May 6, 2022 at 11:31 PM Arnabjyoti Kalita
> > <akalita@cs.stonybrook.edu> wrote:
> > >
> > > Dear Sean and all,
> > >
> > > When a VMEXIT happens of type "KVM_EXIT_DEBUG" because a hardware
> > > breakpoint was triggered when an instruction was about to be executed,
> > > does the instruction where the breakpoint was placed actually execute
> > > before the VMEXIT happens?
> > >
> > > I am attempting to record the occurrence of the debug exception in
> > > userspace. I do not want to do anything extra with the debug
> > > exception. I have modified the kernel code (handle_exception_nmi) to
> > > do something like this -
> > >
> > > case BP_VECTOR:
> > >     /*
> > >      * Update instruction length as we may reinject #BP from
> > >      * user space while in guest debugging mode. Reading it for
> > >      * #DB as well causes no harm, it is not used in that case.
> > >      */
> > >       vmx->vcpu.arch.event_exit_inst_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
> > >       kvm_run->exit_reason = KVM_EXIT_DEBUG;
> > >       ......
> > >       kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
> > >       kvm_run->debug.arch.exception = ex_no;
> > >       kvm_rip_write(vcpu, rip + vmcs_read32(VM_EXIT_INSTRUCTION_LEN));
> > >    <---Change : update RIP here
> > >       break;
> > >
> > > This allows the guest to proceed after the hardware breakpoint
> > > exception was triggered. However, the guest kernel keeps running into
> > > page fault at arbitrary points in time. So, I'm not sure if I need to
> > > handle something else too.
> > >
> > > I have modified the userspace code to not trigger any exception, it
> > > just records the occurence of this VMEXIT and lets the guest continue.
> > >
> > > Is this the right approach?
> >
> > Probably not. I'm not sure how kprobes work, but the tracepoint hooks
> > at function entry are multi-byte nopl instructions. The int3
> > instruction that raises a #BP fault is only one byte. If you advance
> > past that byte, you will try to execute the remaining bytes of the
> > original nopl. You want to skip past the entire nopl.
>
> And kprobes aren't the only thing that will generate #BP, e.g. the kernel uses
> INT3 for patching, userspace debuggers in the guest can insert INT3, etc...  The
> correct thing to do is to re-inject the #BP back into the guest without touching
> RIP.
