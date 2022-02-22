Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC224BF4FD
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 10:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiBVJsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 04:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiBVJso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 04:48:44 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0471D98F6C
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 01:48:18 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id x18so11453021pfh.5
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 01:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3TX4mJmzZJRe/EtqwIKj6zFku/q+ZjEK8yMiZWRvR1A=;
        b=C4/0COoCAvM4SF9804iJLGXS9TynxssLy9jCZ9js85ErtyxBF5SpflorQ19hE1H0xP
         G1X43F4lKRLPiX936lC81vgP7GxgQlpxoBOrj5i2I+TgYwrAOmTE0i9bgDpy3c395yg+
         kw7zpbjFBnKM1yv69gG4kR1OO7dZg46iD0W6/UOCbNCWu3j88NOIjCEJQNDNyHosyF1P
         nl7KPHec1RX8EgQdOYCgY+rtFwHIV7yPKZaHxR2O86SgbAgzsyPx0vFionXCZ0ZwPMDi
         uvyC1hG+Elb0BgWDvQCsb8MLp2mmafrDyfqPTFAWzEjgAEU5Zm6HwU3lHCbV2LUWTcxW
         Mfbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3TX4mJmzZJRe/EtqwIKj6zFku/q+ZjEK8yMiZWRvR1A=;
        b=cev3JUrwzdJLJ/uempppX4MPQAzgfh9ztBcKTkfwoVJ20LOURDL5jZ2/bcUvMXXnCn
         Rh0FA3pJO495UPfAb4IkQeq4TEx3ncJ4R5uUY4cNbl/sQshN4r6fhNDBo7Wa8/IseIkC
         1alh9TdEE4zbINrc9QRYsg5M0xkVg5lnLgyr2/O6S9Lr1NYD9kLSVBqLo9dpbufZGejr
         eO/md1QHoW9al0pbSqN1Dxp1XGbbH2Que5rkdRZCuTwqInSdBTZSZFOEKKLwaODEhuDD
         2vNKuNMegeovswkSA+fTgds/7IQ3BeLAMjG5jXM/VXso3jZK+3HSjP/wqm1Ns5O0DSh8
         5SdQ==
X-Gm-Message-State: AOAM533jpi9o9bZEOcOHqRQwsjYMeOvMoHeH5qxIujvHU5GDPDIvf9y6
        DzJvEESL3Oz4a+aiCrC4edgEEWxr5V2+tQLt5LY=
X-Google-Smtp-Source: ABdhPJx9aq1ReLVoodmp08Qg6AavV5Y1VRCuI7eR6LhO7U9ELoGiWEuCondvAtJkFdaf09TXOx8/h/gMcK0sZ7qbg4Y=
X-Received: by 2002:a63:d1d:0:b0:359:b894:23d1 with SMTP id
 c29-20020a630d1d000000b00359b89423d1mr18860809pgl.132.1645523297494; Tue, 22
 Feb 2022 01:48:17 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <YhMtxWcFMjdQTioe@apples> <CAJSP0QVNRYTOGDsjCJJLOT=7yo1EB6D9LBwgQ4-CE539HdgHNQ@mail.gmail.com>
 <YhN+5wz3MXVm3vXU@apples>
In-Reply-To: <YhN+5wz3MXVm3vXU@apples>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Tue, 22 Feb 2022 09:48:06 +0000
Message-ID: <CAJSP0QXz6kuwx6mycYz_xzxiVjdVR_AqHnpygwV4Ht-7B9pYmw@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Klaus Jensen <its@irrelevant.dk>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Hannes Reinecke <hare@suse.de>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Alex Agache <aagch@amazon.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Feb 2022 at 12:00, Klaus Jensen <its@irrelevant.dk> wrote:
>
> On Feb 21 09:51, Stefan Hajnoczi wrote:
> > On Mon, 21 Feb 2022 at 06:14, Klaus Jensen <its@irrelevant.dk> wrote:
> > >
> > > On Jan 28 15:47, Stefan Hajnoczi wrote:
> > > > Dear QEMU, KVM, and rust-vmm communities,
> > > > QEMU will apply for Google Summer of Code 2022
> > > > (https://summerofcode.withgoogle.com/) and has been accepted into
> > > > Outreachy May-August 2022 (https://www.outreachy.org/). You can now
> > > > submit internship project ideas for QEMU, KVM, and rust-vmm!
> > > >
> > > > If you have experience contributing to QEMU, KVM, or rust-vmm you can
> > > > be a mentor. It's a great way to give back and you get to work with
> > > > people who are just starting out in open source.
> > > >
> > > > Please reply to this email by February 21st with your project ideas.
> > > >
> > > > Good project ideas are suitable for remote work by a competent
> > > > programmer who is not yet familiar with the codebase. In
> > > > addition, they are:
> > > > - Well-defined - the scope is clear
> > > > - Self-contained - there are few dependencies
> > > > - Uncontroversial - they are acceptable to the community
> > > > - Incremental - they produce deliverables along the way
> > > >
> > > > Feel free to post ideas even if you are unable to mentor the project.
> > > > It doesn't hurt to share the idea!
> > > >
> > > > I will review project ideas and keep you up-to-date on QEMU's
> > > > acceptance into GSoC.
> > > >
> > > > Internship program details:
> > > > - Paid, remote work open source internships
> > > > - GSoC projects are 175 or 350 hours, Outreachy projects are 30
> > > > hrs/week for 12 weeks
> > > > - Mentored by volunteers from QEMU, KVM, and rust-vmm
> > > > - Mentors typically spend at least 5 hours per week during the coding period
> > > >
> > > > Changes since last year: GSoC now has 175 or 350 hour project sizes
> > > > instead of 12 week full-time projects. GSoC will accept applicants who
> > > > are not students, before it was limited to students.
> > > >
> > > > For more background on QEMU internships, check out this video:
> > > > https://www.youtube.com/watch?v=xNVCX7YMUL8
> > > >
> > > > Please let me know if you have any questions!
> > > >
> > > > Stefan
> > > >
> > >
> > > Hi,
> > >
> > > I'd like to revive the "NVMe Performance" proposal from Paolo and Stefan
> > > from two years ago.
> > >
> > >   https://wiki.qemu.org/Internships/ProjectIdeas/NVMePerformance
> > >
> > > I'd like to mentor, but since this is "iothread-heavy", I'd like to be
> > > able to draw a bit on Stefan, Paolo if possible.
> >
> > Hi Klaus,
> > I can give input but I probably will not have enough time to
> > participate as a full co-mentor or review every line of every patch.
> >
>
> Of course Stefan, I understand - I did not expect you to co-mentor :)
>
> > If you want to go ahead with the project, please let me know and I'll post it.
> >
>
> Yes, I'll go ahead as mentor for this.
>
> @Keith, if you want to join in, let us know :)
>
> > One thing I noticed about the project idea is that KVM ioeventfd
> > doesn't have the right semantics to emulate the traditional Submission
> > Queue Tail Doorbell register. The issue is that ioeventfd does not
> > capture the value written by the driver to the MMIO register. eventfd
> > is a simple counter so QEMU just sees that the guest has written but
> > doesn't know which value. Although ioeventfd has modes for matching
> > specific values, I don't think that can be used for NVMe Submission
> > Queues because there are too many possible register values and each
> > one requires a separate file descriptor. It might request 100s of
> > ioeventfds per sq, which won't scale.
> >
> > The good news is that when the Shadow Doorbell Buffer is implemented
> > and enabled by the driver, then I think it becomes possible to use
> > ioeventfd for the Submission Queue Tail Doorbell.
> >
>
> Yes, I agree.
>
> > I wanted to mention this so applicants/interns don't go down a dead
> > end trying to figure out how to use ioeventfd for the traditional
> > Submission Queue Tail Doorbell register.
> >
>
> Yeah, thats what the Shadow Doorbell mechanic is for.
>
> Suggested updated summary:
>
> QEMU's NVMe emulation uses the traditional trap-and-emulation method to
> emulate I/Os, thus the performance suffers due to frequent VM-exits.
> Version 1.3 of the NVMe specification defines a new feature to update
> doorbell registers using a Shadow Doorbell Buffer. This can be utilized
> to enhance performance of emulated controllers by reducing the number of
> Submission Queue Tail Doorbell writes.
>
> Further more, it is possible to run emulation in a dedicated thread
> called an IOThread. Emulating NVMe in a separate thread allows the vcpu
> thread to continue execution and results in better performance.
>
> Finally, it is possible for the emulation code to watch for changes to
> the queue memory instead of waiting for doorbell writes. This technique
> is called polling and reduces notification latency at the expense of an
> another thread consuming CPU to detect queue activity.
>
> The goal of this project is to add implement these optimizations so
> QEMU's NVMe emulation performance becomes comparable to virtio-blk
> performance.
>
> Tasks include:
>
>     Add Shadow Doorbell Buffer support to reduce doorbell writes
>     Add Submission Queue polling
>     Add IOThread support so emulation can run in a dedicated thread
>
> Maybe add a link to this previous discussion as well:
>
> https://lore.kernel.org/qemu-devel/1447825624-17011-1-git-send-email-mlin@kernel.org/T/#u

Great, I have added the project idea. I left in the sq doorbell
ioeventfd task but moved it after the Shadow Doorbell Buffer support
task and made it clear that the ioeventfd can only be used when the
Shadow Doorbell Buffer is enabled:
https://wiki.qemu.org/Google_Summer_of_Code_2022#NVMe_Emulation_Performance_Optimization

Stefan
