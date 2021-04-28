Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D678D36D2C6
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 09:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbhD1HIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 03:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhD1HId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 03:08:33 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F6DC061574
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 00:07:49 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x5so11528073wrv.13
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 00:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ePLPOp5H+0aF2LuqZ4lYuqUerlVt+njfmTxese7LhY=;
        b=OP4mXI4jjEoHoY29ERXrwS+GN54cc7kw+RjLLxk3LXHyetIfxpfFLjXZKPgu+690Rh
         glkTr6oapoKRje3Em4EMhVPdR6R8HMpKI3KfwfBk0U94sSiEGVNarG+MTnJcks3WSNWL
         gB2gnhcsMTpTkHeM5f6fNZng7TOxuOuFl6FhF4oHPFf4MdPYLRJGWXM5QXWP+ckJc6Ov
         UYIrAhUwJ3F/fY2qhSqZHbegDeuWxnWOUaGgbEbuf2W03LTsRXZgzzzmkmhLWi5dgYCG
         Su1s3TEagHdybmkhZWfgzCfn0GEuMCcHQ/VsMP07KN1QARxdWj3+9yYY6I/aaJ4nrIws
         knvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ePLPOp5H+0aF2LuqZ4lYuqUerlVt+njfmTxese7LhY=;
        b=ODvYbdPcYgf427I0FFkUne6ZVUnucAcx83aOShBMbmT7b8ic6hcFVp/cmHI+gg59OM
         fSjpN2e2OmE9aljK6JXda1FLwb373p/uRXRejUGqMhKL3Zp93ab1hbgFMMc8R4UM2UsE
         tU3fn0YB7T5iKeCkHsdNANuvUBoep7Q76E/mmf6lEDXM3/JOBZ3dDBAjT9W/slJdtC4v
         3c/AXT9c/dLA2rilddSmDrYU0FkwY4W3hr16xsCp4SumL0uLO/eL49Qa8qg7tjwMxlhv
         bbRzdPcKGmwBQVf5wibK3jAkRO68BQ/V1IEfCvwZ3Qy/7AHCODIXUtY9RwII6YbzeJ8L
         o6JA==
X-Gm-Message-State: AOAM530SVPx/PWFu9xRc0ESserIEcBStQOHbn917qupfrk4qyd9aaS+4
        oqQUNv8IZZss5MVOKoQZ5RbJPz486G2kIHtREiPs8A==
X-Google-Smtp-Source: ABdhPJz4qnl6RSSFskgOfFvyG++QMnht2mgJkG97O1L2rp+YCN+OC2F2vDr/zAZ0zYJu71bovqsMjIrdqkTivs+EoQQ=
X-Received: by 2002:adf:e846:: with SMTP id d6mr14148118wrn.356.1619593667902;
 Wed, 28 Apr 2021 00:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <mhng-d64da1be-bacd-4885-aaf2-fea3c763418c@palmerdabbelt-glaptop>
 <5b988c4e-25e9-f2b9-b08d-35bc37a245e4@sifive.com> <CAAhSdy2g13XkeiG4-=0pHVw9Oq5zAeseM2LgxHf6daXD+qnc1Q@mail.gmail.com>
 <d6e2b882-ae97-1984-fc03-2ac595ee56b4@redhat.com>
In-Reply-To: <d6e2b882-ae97-1984-fc03-2ac595ee56b4@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 28 Apr 2021 12:37:25 +0530
Message-ID: <CAAhSdy3V-8H8rLrGedfSPa1vFCSxcXCqaa0wA518JJstD9kPeg@mail.gmail.com>
Subject: Re: [PATCH v16 00/17] KVM RISC-V Support
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
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

On Tue, Apr 27, 2021 at 12:34 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 27/04/21 08:01, Anup Patel wrote:
> > Hi Paolo,
> >
> > Looks like it will take more time for KVM RISC-V to be merged under arch/riscv.
> >
> > Let's go ahead with your suggestion of having KVM RISC-V under drivers/staging
> > so that development is not blocked.
> >
> > I will send-out v18 series which will add KVM RISC-V under the staging
> > directory.
> >
> > Should we target Linux-5.14 ?
>
> Yes, 5.14 is reasonable.  You'll have to adjust the MMU notifiers for
> the new API introduced in 5.13.

Sure, I will rebase on the new API introduced in 5.13

Regards,
Anup

>
> Paolo
>
> > Regards,
> > Anup
> >
> > On Tue, Apr 27, 2021 at 11:13 AM Paul Walmsley <paul.walmsley@sifive.com> wrote:
> >>
> >> On Fri, 9 Apr 2021, Palmer Dabbelt wrote:
> >>
> >>> On Wed, 31 Mar 2021 02:21:58 PDT (-0700), pbonzini@redhat.com wrote:
> >>>
> >>>> Palmer, are you okay with merging RISC-V KVM?  Or should we place it in
> >>>> drivers/staging/riscv/kvm?
> >>>
> >>> I'm certainly ready to drop my objections to merging the code based on
> >>> it targeting a draft extension, but at a bare minimum I want to get a
> >>> new policy in place that everyone can agree to for merging code.  I've
> >>> tried to draft up a new policy a handful of times this week, but I'm not
> >>> really quite sure how to go about this: ultimately trying to build
> >>> stable interfaces around an unstable ISA is just a losing battle.  I've
> >>> got a bunch of stuff going on right now, but I'll try to find some time
> >>> to actually sit down and finish one.
> >>>
> >>> I know it might seem odd to complain about how slowly things are going
> >>> and then throw up another roadblock, but I really do think this is a
> >>> very important thing to get right.  I'm just not sure how we're going to
> >>> get anywhere with RISC-V without someone providing stability, so I want
> >>> to make sure that whatever we do here can be done reliably.  If we don't
> >>> I'm worried the vendors are just going to go off and do their own
> >>> software stacks, which will make getting everyone back on the same page
> >>> very difficult.
> >>
> >> I sympathize with Paolo, Anup, and others also.  Especially Anup, who has
> >> been updating and carrying the hypervisor patches for a long time now.
> >> And also Greentime, who has been carrying the V extension patches.  The
> >> RISC-V hypervisor specification, like several other RISC-V draft
> >> specifications, is taking longer to transition to the officially "frozen"
> >> stage than almost anyone in the RISC-V community would like.
> >>
> >> Since we share this frustration, the next questions are:
> >>
> >> - What are the root causes of the problem?
> >>
> >> - What's the right forum to address the root causes?
> >>
> >> To me, the root causes of the problems described in this thread aren't
> >> with the arch/riscv kernel maintenance guidelines, but rather with the
> >> RISC-V specification process itself.  And the right forum to address
> >> issues with the RISC-V specification process is with RISC-V International
> >> itself: the mailing lists, the participants, and the board of directors.
> >> Part of the challenge -- not simply with RISC-V, but with the Linux kernel
> >> or any other community -- is to ensure that incentives (and disincentives)
> >> are aligned with the appropriately responsible parts of the community.
> >> And when it comes to specification development, the right focus to align
> >> those incentives and disincentives is on RISC-V International.
> >>
> >> The arch/riscv patch acceptance guidelines are simply intended to ensure
> >> that the definition of what is and isn't RISC-V remains clear and
> >> unambiguous.  Even though the guidelines can result in short-term pain,
> >> the intention is to promote long-term stability and sustainable
> >> maintainability - particularly since the specifications get baked into
> >> hardware.  We've observed that attempting to chase draft specifications
> >> can cause significant churn: for example, the history of the RISC-V vector
> >> specification illustrates how a draft extension can undergo major,
> >> unexpected revisions throughout its journey towards ratification.  One of
> >> our responsibilities as kernel developers is to minimize that churn - not
> >> simply for our own sanity, or for the usability of RISC-V, but to ensure
> >> that we remain members in good standing of the broader kernel community.
> >> Those of us who were around for the ARM32 and ARM SoC kernel accelerando
> >> absorbed strong lessons in maintainability, and I doubt anyone here is
> >> interested in re-learning those the hard way.
> >>
> >> RVI states that the association is open to community participation.  The
> >> organizations that have joined RVI, I believe, have a strong stake in the
> >> health of the RISC-V ecosystem, just as the folks have here in this
> >> discussion.  If the goal really is to get quality specifications out the
> >> door faster, then let's focus the energy towards building consensus
> >> towards improving the process at RISC-V International.  If that's
> >> possible, the benefits won't only accrue to Linux developers, but to the
> >> entire RISC-V hardware and software development community at large.  If
> >> nothing else, it will be an interesting test of whether RISC-V
> >> International can take action to address these concerns and balance them
> >> with those of other stakeholders in the process.
> >>
> >>
> >> - Paul
> >
>
