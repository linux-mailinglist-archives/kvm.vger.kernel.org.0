Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72FDC531ABB
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiEWTpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 15:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiEWTpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 15:45:11 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0182DDF
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 12:44:37 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id e189so19038727oia.8
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 12:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=84la2nz4xGMiW0U++8HviTwtNtqkX3koEM6d9UlmYmM=;
        b=al3IiUgutxS7eqpfpl2RZd97HSBLT8VAb/R1q0yrKGvkN/LGAw1kDyytfAaiuw/ZfT
         RvKemynUhaH0AO9R9fu8Tsv5fne0/UMfi1FFiIcE/XKjeNZd5quDF9fUONEhe2vCly27
         JrTitvjsYQO/jhfC0CIN8t//gi6pwIZ5k+xzg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=84la2nz4xGMiW0U++8HviTwtNtqkX3koEM6d9UlmYmM=;
        b=0R1wnziMZ+5h8vg7y+WRztwH724JmEBqIBbhKD84TbUbcawhViXzxIkjrGD40rID1w
         TM+JkICxtn7cChQ5LAvVA/qjqT4e2u2CKpiKlknCoMR20uJw4sVi8dljSF7r2Y6V4l0a
         sg1ngX14dKMOJCzuo+IRQ5Qk11H1ZKGb65thDTREZhnyVnah1hVDTT5jVg72y79vJEs3
         MaOkCP5gBUtkQUQoLrnD9DADSGQNa39TfjOQtGffXFfeeSM0QHscV1oTVO8CisPtHKL3
         wAaDsJWyypNgQFyUiHtB8UkJxpMJMMOt35POTUbkjpQyE5KOSGEH7QPSFYCz9GSlPilZ
         7rAA==
X-Gm-Message-State: AOAM532lyafsKFWlvcp2I0ur3+PQ6pJf8WCL/uNHnRRriqPLv+YuLj0M
        Lh+lpXlmWipRPNUzWbdkU05D0DoWlFlK8if+9u7/EQ==
X-Google-Smtp-Source: ABdhPJz3PmPA4DK5qO/BZQH0Lg8hEwniLi1EFV5uRhLAPXOKpb+GsGDVJNGYWR4VzlN9kTgRlgIxzVe7A924m2nKmd8=
X-Received: by 2002:a05:6808:13d6:b0:326:c5b0:14c2 with SMTP id
 d22-20020a05680813d600b00326c5b014c2mr368688oiw.37.1653335076988; Mon, 23 May
 2022 12:44:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGDS+GM9Aw6Yvhv+F6wMGvrkz421kfq0j_PZa9F0AKyp5cEQA@mail.gmail.com>
 <YnGUazEgCJWgB6Yw@google.com> <CAJGDS+F0hB=0bj8spt9sophJyhdXTkYXK8LXUrt=7mov4s2JJA@mail.gmail.com>
 <CAJGDS+E5f2Xo68dsEkOfchZybU1uTSb=BgcTgQMLe0tW32m5xg@mail.gmail.com>
 <CALMp9eT3FeDa735Mo_9sZVPfovGQbcqXAygLnz61-acHV-L7+w@mail.gmail.com>
 <YnvBMnD6fuh+pAQ6@google.com> <CAJGDS+GMxG1gXMS1cW1+sS1V67h65iUpMGwQ=+-MVTE6DTOBjg@mail.gmail.com>
 <YnvFN7nT9DzfR8fq@google.com> <CAJGDS+G+z9S6QDEGRatR5u+q-5X_MAiWqnTsjf4L=4+PrThdsQ@mail.gmail.com>
 <YnvQd5zvDlop7oRK@google.com> <CAJGDS+HRzTTSy4SuVtt-dzTzWXHZ0n1TJdDxKO+jOtGdcrX0Yg@mail.gmail.com>
In-Reply-To: <CAJGDS+HRzTTSy4SuVtt-dzTzWXHZ0n1TJdDxKO+jOtGdcrX0Yg@mail.gmail.com>
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Tue, 24 May 2022 01:14:25 +0530
Message-ID: <CAJGDS+FY+JemV+2xnKN2fi839bs25XbE4-wLenKH_YCRLpuyOA@mail.gmail.com>
Subject: Re: Causing VMEXITs when kprobes are hit in the guest VM
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Sean and all,

I tried to re-inject the #BP into the guest from userspace using the
KVM_SET_VCPU_EVENTS ioctl. However, I see that after some time, the
VMEXITs stop happening (due to KVM_EXIT_DEBUG). I am suspicious that
the guest RIP hasn't been updated when I re-inject the #BP exception.
The kprobe logs tell me that the kprobe functions are being accessed
quite frequently (I  am attaching a kprobe at "free_one_page()" and I
do not expect it to be called almost every microsecond).

This is the code I wrote in userspace to re-inject the #BP interrupt
into the guest.

The below code is from QEMU version 5.0.1

switch (run->exit_reason) {
    /* other exit reason handling */
    case KVM_EXIT_DEBUG:
         struct kvm_vcpu_events events = {};
         events.exception.nr = run->debug.arch.exception;
         events.exception.has_error_code = 0;
         events.exception.pending = 1;
         events.exception.injected = 1;
         events.exception.error_code = 0;
         if (kvm_vcpu_ioctl(cpu, KVM_SET_VCPU_EVENTS, &events) < 0)
             printf("Error while doing ioctl KVM_SET_VCPU_EVENTS");
         ret = 0;
         break:

Do you see a need to initialize any other structure member in
kvm_vcpu_events{} ? Do I need to change any of the structure member
values that I am passing to the ioctl command? Why is the RIP still
not updating ?

Thank you very much for your answer again.

Best Regards,
Arnabjyoti Kalita



On Wed, May 11, 2022 at 10:32 PM Arnabjyoti Kalita
<akalita@cs.stonybrook.edu> wrote:
>
> Thank you for your answer, Sean.
>
> I think I now have a fair idea on how to proceed. I will re-inject the
> #BP into the guest from KVM and see what happens. I'm hoping the guest
> will handle the #BP and continue execution without me needing to make
> any more changes.
>
> Best Regards,
> Arnabjyoti Kalita
>
> On Wed, May 11, 2022 at 8:34 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, May 11, 2022, Arnabjyoti Kalita wrote:
> > > What could be the various ways a guest could handle #BP?
> >
> > The kernel uses INT3 to patch instructions/flows, e.g. for alternatives.  For those,
> > the INT3 handler will unwind to the original RIP and retry.  The #BP will keep
> > occurring until the patching completes.  See text_poke_bp_batch(), poke_int3_handler(),
> > etc...
> >
> > Userspace debuggers will do something similar; after catching the #BP, the original
> > instruction is restored and restarted.
> >
> > The reason INT3 is a single byte is so that software can "atomically" trap/patch an
> > instruction without having to worry about cache line splits.  CPUs are guaranteed
> > to either see the INT3 or the original instruction in its entirety, i.e. other CPUs
> > will never decode a half-baked instruction.
> >
> > The kernel has even fancier uses for things like static_call(), e.g. emulating
> > CALL, RET, and JMP from the #BP handler.
> >
> > > Can we "make" the guest skip the instruction that caused the #BP ?
> >
> > Well, technically yes, that's effectively what would happen if the host skips the
> > INT3 and doesn't inject the #BP.  Can you do that and expect the guest not to
> > crash?  Nope.
