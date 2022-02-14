Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFCC4B52D7
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 15:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354341AbiBNOLK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 09:11:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiBNOLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 09:11:09 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BBFAE65
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 06:11:01 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso18955099pjt.4
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 06:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PdZPgVs5vPBvparmcotK7oV7z3Yf94yHSi1g5mgwvgQ=;
        b=NFgMfI8iL9RjntLuL4L3Et/g8KAn+nqwhLCO1e8b0pgIBU78F7OsD10QzjnlCQpWBh
         sw9AGwM8pNao9geY2Zc5GRwBVH2y34nJ8kRKWumfvIwDW4Is7FYQpMC9VIkkxSjZpJfb
         ljXq4sZEP2Ih9CqtXe1zXOANirwykegokz4kZHbRAGgkATUmBsB5cNtDLbEWaL0ie0Yd
         9M186tDOqQg24kxlmlExINAPEHRLwVamX2Pr2ERFZtkbxHegWrpkuUSJh2MQ11k7Imuf
         eDUQ8bf1VCcDPyj9qamrCz/la6MV4GTP3Qll7qg+CiNq64n3Den7HWLyun+jGhgKUmyz
         EGKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PdZPgVs5vPBvparmcotK7oV7z3Yf94yHSi1g5mgwvgQ=;
        b=ZN5NAYaU+uBJJkzwyul6g7+A+3j2km6RZY2YPYLBczc4h1ZUtpLXKJ0o8bnjQl05Th
         xCbM5Dvk4ZEhFuFpk0eArUPfuHEhbfcDHHBUbPaWzUFlSqJ5tvDB7s8N5dZtWXAIPB+w
         crCttUTF2mOK1o/RCuCg+b3rJ0KU8SKnLzd0cOVd+vehpaHNnMVnVY5woYkFQK3GN4f4
         K+Z+KM7GOV0G2vUQpLiH9HGICykB7L41cU8e7GPYF9407lAWnmFTP2t8jrXFV/tkqIwN
         0S2+Wpj2xIbJ+651Uah04zM11ofDuS+x0w4RWctQRlTreKhlFETZ+kgIfK/SOg7Zhsi0
         s8bQ==
X-Gm-Message-State: AOAM532aUDZdg8fFtrhu3F19cJgbR6Sbe3VCgZj2VzbsuF62RmV1uVim
        4TydlWxag0Zb4IjZb9nghdF4wbefmqMGsF4N0EA=
X-Google-Smtp-Source: ABdhPJyZWYTkytm3GyM5hxpfoZooN/ycNQDscnLEgRToQfqjyCdFcZ9A9bXyTUGoDAhyNuh4cp0wjFoyZZ5gtAD1x1s=
X-Received: by 2002:a17:902:d64f:: with SMTP id y15mr14104486plh.145.1644847861164;
 Mon, 14 Feb 2022 06:11:01 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <87zgmtd0ov.fsf@linaro.org>
In-Reply-To: <87zgmtd0ov.fsf@linaro.org>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Mon, 14 Feb 2022 14:10:49 +0000
Message-ID: <CAJSP0QULu-2pppavMHnUn2=Lo8j3b3wteXUiQfkiF49OjHjGMQ@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        John Snow <jsnow@redhat.com>, Sergio Lopez <slp@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Alex Agache <aagch@amazon.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Feb 2022 at 13:42, Alex Benn=C3=A9e <alex.bennee@linaro.org> wro=
te:
>
>
> Stefan Hajnoczi <stefanha@gmail.com> writes:
>
> > Dear QEMU, KVM, and rust-vmm communities,
> > QEMU will apply for Google Summer of Code 2022
> > (https://summerofcode.withgoogle.com/) and has been accepted into
> > Outreachy May-August 2022 (https://www.outreachy.org/). You can now
> > submit internship project ideas for QEMU, KVM, and rust-vmm!
> >
> > If you have experience contributing to QEMU, KVM, or rust-vmm you can
> > be a mentor. It's a great way to give back and you get to work with
> > people who are just starting out in open source.
> >
> > Please reply to this email by February 21st with your project ideas.
> >
> > Good project ideas are suitable for remote work by a competent
> > programmer who is not yet familiar with the codebase. In
> > addition, they are:
> > - Well-defined - the scope is clear
> > - Self-contained - there are few dependencies
> > - Uncontroversial - they are acceptable to the community
> > - Incremental - they produce deliverables along the way
> >
> > Feel free to post ideas even if you are unable to mentor the project.
> > It doesn't hurt to share the idea!
> >
> > I will review project ideas and keep you up-to-date on QEMU's
> > acceptance into GSoC.
> >
> > Internship program details:
> > - Paid, remote work open source internships
> > - GSoC projects are 175 or 350 hours, Outreachy projects are 30
> > hrs/week for 12 weeks
> > - Mentored by volunteers from QEMU, KVM, and rust-vmm
> > - Mentors typically spend at least 5 hours per week during the coding p=
eriod
> >
> > Changes since last year: GSoC now has 175 or 350 hour project sizes
> > instead of 12 week full-time projects. GSoC will accept applicants who
> > are not students, before it was limited to students.
>
> I'm certainly up for mentoring new devices for vhost-device (rust-vmm
> vhost-user backends). Since we've become a code owner we're trying to
> clear the backlog (virto-vsock and virtio-block) but there are plenty of
> others that could be done. Of particular interest to me are:
>
>   - virtio-rpmb (we have a working C implementation I wrote)

Yes, it would be good to have an implementation. I mentioned this
device in my FOSDEM 22 talk about what's coming in VIRTIO 1.2:
https://vmsplice.net/~stefan/stefanha-fosdem-2022.pdf

>   - virtio-snd (in flight virtio spec)

There are QEMU patches in development by Shreyansh Chouhan although
that doesn't rule out a rust-vmm crate.

>   - virtio-video (again we have a working C version against v3)

Want to pick one device and write a project description for it?

> With my other hat on there are numerous TCG plugin projects that could
> be done. Adding basic plugins is fairly straight forward but it would be
> interesting to look at what is required to do a more involved plugin
> like panda-re's taint analysis (following ptrs as they move through the
> system). This will likely need some additional features exposed from the
> plugin interface to achieve.
>
> With that in mind there is also the idea of a central registry for
> register values which is a prerequisite for expanding access to TCG
> plugins but could also bring various quality of life improvements to
> other areas. I've written that up on a page:
>
>   https://wiki.qemu.org/Internships/ProjectIdeas/CentralRegisterRegistry

Thanks for posting that! Can you add links to the -d cpu, gdbstub, and
hmp/qmp register code? The idea is a little fuzzy in my mind, maybe
you could include a sketch of the API to give readers an idea of what
the project should deliver?

Stefan
