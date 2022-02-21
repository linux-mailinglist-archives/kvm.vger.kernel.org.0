Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC11B4BE47C
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354951AbiBUKar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 05:30:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354419AbiBUKag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 05:30:36 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE4035272
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 01:51:54 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q8-20020a17090a178800b001bc299b8de1so3392131pja.1
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 01:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LQH0oXYOtonMJ/YymHMO0iip6tbgo2yPt2wFBQnpQPs=;
        b=XNWvK9S3nmEtvFBsP3LXBaxUCwjZOXwAkCFcPuTkxQxDO7C3fsigVPNu2UuKBxk9J6
         H+7aEAGVVLOBMMPU/KUI3Z4lu/96YSBLpThoIBGlJdxz1foqj7V4X0tKup1OGLjCGKNx
         U99TUt3ME5SEdOjrTmnv1EgKeV2Eqy+biejfqB3e+mBJvcPyYVb0lpVX4kT6bnboqoJh
         1DLizOA2TAa8HSn8z/wbeY3RdR76AxRktYdA+XQWGErJpq4l5MoUvaKoFtJuj5arhGoB
         1z1pdEW/lm2f5b0vSnjX6UUv80u0t2MfjW9xEDMQeaOCNS8zYwq4IhUSs9rEkVFo4tBD
         M6Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LQH0oXYOtonMJ/YymHMO0iip6tbgo2yPt2wFBQnpQPs=;
        b=VjVbjSMujSQCBpOjGMpLqP2NWVL8qkdatYyoPB2GGwFMYS3WMD/W2XE6UEeeFNhDDf
         SMWy4U8gQdLNWJgxk7TjeqrFI0nd6wbINHVnurOYopGbXDi0NX3+QH1R9Xg9rpQ8qcfU
         UaKgkxPJFNEXal82J+5RkJJt8+TjHQnALu2Ges2avk3SPIrbBeNvV0CJ3DmZGv7y4Sh2
         j4tsMMKQRl2XM7KuArFEqHTwSPVOrsBDlB0F9F6IDjtelS0ytSQ1PON6Si7E84MP6kHw
         GjE3Hr4O6GQN1JqE7iDlkmirx2f+5Jvob8lX0xCCNm5XHapOuegYPyNxBp92FlR7C6EC
         daQg==
X-Gm-Message-State: AOAM531lwHOHha+v/X/Dbg5f5r18aWGA3eSAvOzXBPQdC01uPEHCgrYQ
        IBpUoBQPJXQd2m7kRXwFABZiozOeyFkquZY+Hkcdz7f34vA=
X-Google-Smtp-Source: ABdhPJzj+ZuQk9cqdUsx94ps+dYux2wLeG8B+O6heHBti9pS88aj8InSxsgxxilaFe0Uhs7eDP8gW7FQ4DbiNTQeX+k=
X-Received: by 2002:a17:902:e8c2:b0:14d:bc86:be4d with SMTP id
 v2-20020a170902e8c200b0014dbc86be4dmr18375051plg.106.1645437113439; Mon, 21
 Feb 2022 01:51:53 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <YhMtxWcFMjdQTioe@apples>
In-Reply-To: <YhMtxWcFMjdQTioe@apples>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Mon, 21 Feb 2022 09:51:42 +0000
Message-ID: <CAJSP0QVNRYTOGDsjCJJLOT=7yo1EB6D9LBwgQ4-CE539HdgHNQ@mail.gmail.com>
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

On Mon, 21 Feb 2022 at 06:14, Klaus Jensen <its@irrelevant.dk> wrote:
>
> On Jan 28 15:47, Stefan Hajnoczi wrote:
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
> > - Mentors typically spend at least 5 hours per week during the coding period
> >
> > Changes since last year: GSoC now has 175 or 350 hour project sizes
> > instead of 12 week full-time projects. GSoC will accept applicants who
> > are not students, before it was limited to students.
> >
> > For more background on QEMU internships, check out this video:
> > https://www.youtube.com/watch?v=xNVCX7YMUL8
> >
> > Please let me know if you have any questions!
> >
> > Stefan
> >
>
> Hi,
>
> I'd like to revive the "NVMe Performance" proposal from Paolo and Stefan
> from two years ago.
>
>   https://wiki.qemu.org/Internships/ProjectIdeas/NVMePerformance
>
> I'd like to mentor, but since this is "iothread-heavy", I'd like to be
> able to draw a bit on Stefan, Paolo if possible.

Hi Klaus,
I can give input but I probably will not have enough time to
participate as a full co-mentor or review every line of every patch.

If you want to go ahead with the project, please let me know and I'll post it.

One thing I noticed about the project idea is that KVM ioeventfd
doesn't have the right semantics to emulate the traditional Submission
Queue Tail Doorbell register. The issue is that ioeventfd does not
capture the value written by the driver to the MMIO register. eventfd
is a simple counter so QEMU just sees that the guest has written but
doesn't know which value. Although ioeventfd has modes for matching
specific values, I don't think that can be used for NVMe Submission
Queues because there are too many possible register values and each
one requires a separate file descriptor. It might request 100s of
ioeventfds per sq, which won't scale.

The good news is that when the Shadow Doorbell Buffer is implemented
and enabled by the driver, then I think it becomes possible to use
ioeventfd for the Submission Queue Tail Doorbell.

I wanted to mention this so applicants/interns don't go down a dead
end trying to figure out how to use ioeventfd for the traditional
Submission Queue Tail Doorbell register.

Stefan
