Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B60836BF0E
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 08:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhD0GCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 02:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhD0GCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 02:02:05 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD47AC061574
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 23:01:22 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e5so29500275wrg.7
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 23:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V788y0c+X/a1zmRPAQAXGKRnxOC2AaVnSQkeOdvO5LI=;
        b=tnW9bOiTFXPdF5WqGiM1bx3GweauOGsZgLIXJirpLSfLqj14Q9Pe/UOlTG0Vwsf+PS
         eYwZmaMxTyPKnvnlWVbEwGY/GsxPcC76DX/CexpPZlM8luIkEShUH3OgBhUzY2v3zJgf
         dxAZA3ZbmExm7jNMA3v9edYryBIZDXaR7gGDJuVWz/F6naoK9onAtJgLg2vmkXrFdCns
         c8bbc/3XB6dsZiaL7CssoZhS5S/6VrOp9QZDw6St/ExqVv1jvTbBFss7sEz53aMAlwM0
         dgJt2L97DBdoLgo3Oo7ITi5k1qcOX5CxamQSeyFaQgAP731aDuRy0fHogvKCiBaiPg8y
         aZGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V788y0c+X/a1zmRPAQAXGKRnxOC2AaVnSQkeOdvO5LI=;
        b=Ox+LYmL16hl2ClkeFnKMRONMbMw+mCOvh/GwFdEkOG+WKyy6tYZWmj1Sz5bV4pCtsw
         VolOrqrR/lPdK/WPZX1UkoVRIzEyjtp+66FzVCXFvx6CbLNGBp03bPM4fJJqEgOJE6o3
         nfHFM85wMeJrX+OkofQRcuEbM10knl+wYarw/nIJXgXby56LStnn9K+2KrcResvRyPPS
         nGyodgiGu8kTBcldbszU23FF3KUNlvwDeiDYZ4t+Qh6CklbuMpcXwXK+R0+VMhCUbNsS
         7ZauNohfh1KyERMQhWdCDd6ffuiaQ4jDdDuc+h2pfBG5khxAQDrfFxBogyIf7t6VAwZc
         XqsA==
X-Gm-Message-State: AOAM533IsHN4SektODPC97N02OTMqikOi8oqNfV73WiVCKevSH3pYzlk
        1ccqO1imsI/QuzMDCuj1RsdlWBT6SWlZ8MNkBZsxHw==
X-Google-Smtp-Source: ABdhPJwk/5A/pxkyur4hIjIrmR7tCVZaRwKqnd5AmklHqVov2deqZIaDvFuOFFB8FvsspJDazxupGWPv/FRiFupz7Zs=
X-Received: by 2002:adf:f6c8:: with SMTP id y8mr6962352wrp.325.1619503281250;
 Mon, 26 Apr 2021 23:01:21 -0700 (PDT)
MIME-Version: 1.0
References: <mhng-d64da1be-bacd-4885-aaf2-fea3c763418c@palmerdabbelt-glaptop> <5b988c4e-25e9-f2b9-b08d-35bc37a245e4@sifive.com>
In-Reply-To: <5b988c4e-25e9-f2b9-b08d-35bc37a245e4@sifive.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 27 Apr 2021 11:31:09 +0530
Message-ID: <CAAhSdy2g13XkeiG4-=0pHVw9Oq5zAeseM2LgxHf6daXD+qnc1Q@mail.gmail.com>
Subject: Re: [PATCH v16 00/17] KVM RISC-V Support
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>,
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

Hi Paolo,

Looks like it will take more time for KVM RISC-V to be merged under arch/riscv.

Let's go ahead with your suggestion of having KVM RISC-V under drivers/staging
so that development is not blocked.

I will send-out v18 series which will add KVM RISC-V under the staging
directory.

Should we target Linux-5.14 ?

Regards,
Anup

On Tue, Apr 27, 2021 at 11:13 AM Paul Walmsley <paul.walmsley@sifive.com> wrote:
>
> On Fri, 9 Apr 2021, Palmer Dabbelt wrote:
>
> > On Wed, 31 Mar 2021 02:21:58 PDT (-0700), pbonzini@redhat.com wrote:
> >
> > > Palmer, are you okay with merging RISC-V KVM?  Or should we place it in
> > > drivers/staging/riscv/kvm?
> >
> > I'm certainly ready to drop my objections to merging the code based on
> > it targeting a draft extension, but at a bare minimum I want to get a
> > new policy in place that everyone can agree to for merging code.  I've
> > tried to draft up a new policy a handful of times this week, but I'm not
> > really quite sure how to go about this: ultimately trying to build
> > stable interfaces around an unstable ISA is just a losing battle.  I've
> > got a bunch of stuff going on right now, but I'll try to find some time
> > to actually sit down and finish one.
> >
> > I know it might seem odd to complain about how slowly things are going
> > and then throw up another roadblock, but I really do think this is a
> > very important thing to get right.  I'm just not sure how we're going to
> > get anywhere with RISC-V without someone providing stability, so I want
> > to make sure that whatever we do here can be done reliably.  If we don't
> > I'm worried the vendors are just going to go off and do their own
> > software stacks, which will make getting everyone back on the same page
> > very difficult.
>
> I sympathize with Paolo, Anup, and others also.  Especially Anup, who has
> been updating and carrying the hypervisor patches for a long time now.
> And also Greentime, who has been carrying the V extension patches.  The
> RISC-V hypervisor specification, like several other RISC-V draft
> specifications, is taking longer to transition to the officially "frozen"
> stage than almost anyone in the RISC-V community would like.
>
> Since we share this frustration, the next questions are:
>
> - What are the root causes of the problem?
>
> - What's the right forum to address the root causes?
>
> To me, the root causes of the problems described in this thread aren't
> with the arch/riscv kernel maintenance guidelines, but rather with the
> RISC-V specification process itself.  And the right forum to address
> issues with the RISC-V specification process is with RISC-V International
> itself: the mailing lists, the participants, and the board of directors.
> Part of the challenge -- not simply with RISC-V, but with the Linux kernel
> or any other community -- is to ensure that incentives (and disincentives)
> are aligned with the appropriately responsible parts of the community.
> And when it comes to specification development, the right focus to align
> those incentives and disincentives is on RISC-V International.
>
> The arch/riscv patch acceptance guidelines are simply intended to ensure
> that the definition of what is and isn't RISC-V remains clear and
> unambiguous.  Even though the guidelines can result in short-term pain,
> the intention is to promote long-term stability and sustainable
> maintainability - particularly since the specifications get baked into
> hardware.  We've observed that attempting to chase draft specifications
> can cause significant churn: for example, the history of the RISC-V vector
> specification illustrates how a draft extension can undergo major,
> unexpected revisions throughout its journey towards ratification.  One of
> our responsibilities as kernel developers is to minimize that churn - not
> simply for our own sanity, or for the usability of RISC-V, but to ensure
> that we remain members in good standing of the broader kernel community.
> Those of us who were around for the ARM32 and ARM SoC kernel accelerando
> absorbed strong lessons in maintainability, and I doubt anyone here is
> interested in re-learning those the hard way.
>
> RVI states that the association is open to community participation.  The
> organizations that have joined RVI, I believe, have a strong stake in the
> health of the RISC-V ecosystem, just as the folks have here in this
> discussion.  If the goal really is to get quality specifications out the
> door faster, then let's focus the energy towards building consensus
> towards improving the process at RISC-V International.  If that's
> possible, the benefits won't only accrue to Linux developers, but to the
> entire RISC-V hardware and software development community at large.  If
> nothing else, it will be an interesting test of whether RISC-V
> International can take action to address these concerns and balance them
> with those of other stakeholders in the process.
>
>
> - Paul
