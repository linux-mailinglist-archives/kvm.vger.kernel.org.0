Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4745536643E
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 06:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhDUEIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 00:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbhDUEIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 00:08:48 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E97C06174A
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 21:08:14 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id p6so33133173wrn.9
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 21:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WaZO4G68UBU3vGgoF4QvbcfZTEDhOHGYS1PfQvi2NPo=;
        b=hH2Ior+J2Jj3gNXUDRQb2B5cZpo1VHS6g+VxjUN7R8OhdUl9fhcQUHHeg/UwbHPYkt
         dvGPFGGvtpzm8il69fqV/k0anKDrs22fD/uFqXYj0ug4Y+1RH4uNXWw4BUEMLlpXILc2
         Jx6VXSLIDhRyISk0eDiw/aZmSEU/hILFVJSJGngSlOVAe7pLyUlzfdScUA7dR9xmikir
         52k0XdSlSqtToZK98+AX7uP+/v58m4aOzTRqPceiJ5HDk6BuqTrDTiuQiVVNQK1ZyS+j
         ok3BfOLol+LEdd2mebvVJo/83uUq7QtERwHcfiTs0dQVkxVyz7NtJ9AEF8iR0m2daEqw
         JRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WaZO4G68UBU3vGgoF4QvbcfZTEDhOHGYS1PfQvi2NPo=;
        b=I18cnyRVjotfKFu7Z6sbpzmr3NEaDssvaZju1ySWgnyR5j1HdyWPzCb+loPtjXqFqp
         uANzYpCR/0lidjW9Lfb1resb9FFTyLj5PNzn6nQ7jVDMwWLZXVkVdPQiYaPtdVBH/nPr
         czy/Nq+dI7ippaCv57EK6a+LjGBUyO/PozZpnqs7Ic07mljH9Km/ED+rzY25VlTN/SJL
         TnkOvdYIPdXkB9Jb8PYKeeIUVmA98pblsUq66ncocouYrU2DWVH8euBOtWD+S33H2Mw6
         w/uK9/egmrhCwjrg/UqY1ZSv3aZ5rHUbqz3LlbP1x6cZdn4s4et7dG5H+0rHtAzOdVeG
         PT3w==
X-Gm-Message-State: AOAM530/Ix/4BeKRJEJdpq9Y28DtMvIQgnMBnCzGcHzxOkdYvXDO2l5h
        Tefqgd2duHomgiPuemAO5LCxk8X317CIU88N8LGlCi+c31s=
X-Google-Smtp-Source: ABdhPJy1qAwhycXgUCLM7eQQ0TAd+o7Pc7JTlOn+Av52SdM9p6+E9B1lX0Eh9/lh6HEocIJMfofebUvw4PhdiBPt1NU=
X-Received: by 2002:adf:ce12:: with SMTP id p18mr24500366wrn.144.1618978092690;
 Tue, 20 Apr 2021 21:08:12 -0700 (PDT)
MIME-Version: 1.0
References: <a49a7142-104e-fdaa-4a6a-619505695229@redhat.com> <mhng-d64da1be-bacd-4885-aaf2-fea3c763418c@palmerdabbelt-glaptop>
In-Reply-To: <mhng-d64da1be-bacd-4885-aaf2-fea3c763418c@palmerdabbelt-glaptop>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 21 Apr 2021 09:38:01 +0530
Message-ID: <CAAhSdy1EYhgA52m48DcyevM5j5EsuXPbVq5Z0KHB+SaXorNTeg@mail.gmail.com>
Subject: Re: [PATCH v16 00/17] KVM RISC-V Support
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Palmer,

On Sat, Apr 10, 2021 at 12:28 AM Palmer Dabbelt <palmer@dabbelt.com> wrote:
>
> On Wed, 31 Mar 2021 02:21:58 PDT (-0700), pbonzini@redhat.com wrote:
> > On 30/03/21 07:48, Anup Patel wrote:
> >>
> >> It seems Andrew does not want to freeze H-extension until we have virtualization
> >> aware interrupt controller (such as RISC-V AIA specification) and IOMMU. Lot
> >> of us feel that these things can be done independently because RISC-V
> >> H-extension already has provisions for external interrupt controller with
> >> virtualization support.
>
> Sorry to hear that.  It's really gotten to a point where I'm just
> embarrassed with how the RISC-V foundation is being run -- not sure if
> these other ones bled into Linux land, but this is the third ISA
> extension that's blown up over the last few weeks.  We had a lot of
> discussion about this on the binutils/GCC side of things and I've
> managed to convince myself that coupling the software stack to the
> specification process isn't viable -- we made that decision under the
> assumption that specifications would actually progress through the
> process, but in practice that's just not happening.
>
> My goal with the RISC-V stuff has always been getting us to a place
> where we have real shipping products running a software stack that is as
> close as possible to the upstream codebases.  I see that as the only way
> to get the software stack to a point where it can be sustainably
> maintained.  The "only frozen extensions" policy was meant to help this
> by steering vendors towards a common base we could support, but in
> practice it's just not working out.  The specification process is just
> so unreliable that in practice everything that gets built ends up
> relying on some non-standard behavior: whether it's a draft extension,
> some vendor-specific extension, or just some implementation quirks.
> There's always going to be some degree of that going on, but over the
> last year or so we've just stopped progressing.
>
> My worry with accepting the draft extensions is that we have no
> guarantee of compatibility between various drafts, which makes
> supporting multiple versions much more difficult.  I've always really
> only been worried about supporting what gets implemented in a chip I can
> actually run code on, as I can at least guarantee that doesn't change.
> In practice that really has nothing to do with the specification freeze:
> even ratified specifications change in ways that break compatibility so
> we need to support multiple versions anyway.  That's why we've got
> things like the K210 support (which doesn't quite follow the ratified
> specs) and are going to take the errata stuff.  I hadn't been all that
> worried about the H support because there was a plan to get is to
> hardware, but with the change I'm not really sure how that's going to
> happen.
>
> > Yes, frankly that's pretty ridiculous as it's perfectly possible to
> > emulate the interrupt controller in software (and an IOMMU is not needed
> > at all if you are okay with emulated or paravirtualized devices---which
> > is almost always the case except for partitioning hypervisors).
>
> There's certainly some risk to freezing the H extension before we have
> all flavors of systems up and running.  I spent a lot of time arguing
> that case years ago before we started telling people that the H
> extension just needed implementation, but that's not the decision we
> made.  I don't really do RISC-V foundation stuff any more so I don't
> know why this changed, but it's just too late.  It would be wonderful to
> have an implementation of everything we need to build out one of these
> complex systems, but I just just don't see how the current plan gets
> there: that's a huge amount of work and I don't see why anyone would
> commit to that when they can't count on it being supported when it's
> released.
>
> There are clearly some systems that can be built with this as it stands.
> They're not going to satisfy every use case, but at least we'll get
> people to start seriously using the spec.  That's the only way I can see
> to move forward with this.  It's pretty clear that sitting around and
> waiting doesn't work, we've tried that.
>
> > Palmer, are you okay with merging RISC-V KVM?  Or should we place it in
> > drivers/staging/riscv/kvm?
>
> I'm certainly ready to drop my objections to merging the code based on
> it targeting a draft extension, but at a bare minimum I want to get a
> new policy in place that everyone can agree to for merging code.  I've
> tried to draft up a new policy a handful of times this week, but I'm not
> really quite sure how to go about this: ultimately trying to build
> stable interfaces around an unstable ISA is just a losing battle.  I've
> got a bunch of stuff going on right now, but I'll try to find some time
> to actually sit down and finish one.

Can you send the patch for the updated policy which we can review ??

Will it be possible to get KVM RISC-V merged for Linux-5.13 ?

Regards,
Anup

>
> I know it might seem odd to complain about how slowly things are going
> and then throw up another roadblock, but I really do think this is a
> very important thing to get right.  I'm just not sure how we're going to
> get anywhere with RISC-V without someone providing stability, so I want
> to make sure that whatever we do here can be done reliably.  If we don't
> I'm worried the vendors are just going to go off and do their own
> software stacks, which will make getting everyone back on the same page
> very difficult.
>
> > Either way, the best way to do it would be like this:
> >
> > 1) you apply patch 1 in a topic branch
> >
> > 2) you merge the topic branch in the risc-v tree
> >
> > 3) Anup merges the topic branch too and sends me a pull request.
> >
> > Paolo
