Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6D968C882
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 22:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjBFVWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 16:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBFVWB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 16:22:01 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3352018B1B
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 13:21:57 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-520dad0a7d2so173029617b3.5
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 13:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=leAds0lRa3TQRSKLSosccnuchFtxoTin8+WCJI8nDo0=;
        b=QmpRj4w7yawVlFoxtS+EF17ZSHyRrJhf7+8bmKkiAOYAXcEH0wWRAExc14Un65IbFe
         cCl1tH0pKivEEVHp+UUZU2SEe8zadJzsjOE++Rmp7n/JRDYoNt/z0VNA4BNnY7ZH63tP
         NVC4rpzy8AMy1JQFsLjDYZc93gh3Wh2dOWGUJ/Py/uZOsE7ZyhOKbrqDBgNTqf5Qpd5E
         ZUlxL5fBaxT35QUJ1rb85wkpNtn8Jnsh67diFojXm/k6eVEV8Y+kB+BC/ngUJmbSN0ov
         Fs37S1dcypklZAQ/kCFU6BwZrwxlZOthNB83CQVlsD1qvG3Y5rdlcL3z/NJwIKutKIeE
         ZLhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=leAds0lRa3TQRSKLSosccnuchFtxoTin8+WCJI8nDo0=;
        b=OtPF0VUjFpPMjUhdOP+Gi5jkHnfgNZXvMlvpkN5Hu0vJSXECK0hHIQcP0U7nFH0Ske
         C2z9fJP5IIN3aClDuPBfb8eRKF3KiZpgZv/anLNzPQ5mFUQ95kkPQK8eUvI86OIgSD5w
         +8HZR5aqbS2GdBwwwKpAyZPAo207fR+CfRVfvt/cCLn+/v/oEO+mPxWSd16nWStQbLot
         klKt2gmZF3v4xC5AZhCIT6CcdHv6aSnKFjJNie6wRzHiPz0hw/uwuc48NHhq8+TwU6TN
         JIjINMJcgaTh2SuxZqvVQL/SWgKYv8iTBzvBvPcTnV178KkOzvh7huaGQxor0PqxmWuI
         dgSg==
X-Gm-Message-State: AO0yUKUjGNfE/tSsc+B53yKO92OE6B/a/LSkIxbWO90fXAtE5jYTQ9jF
        mcLCbQ1GeVX21oGnoZ3aYJJd3FMZjLXq2cOzcXk=
X-Google-Smtp-Source: AK7set87l2TOphZIurh6Svk7x2EqYjTg+f4BEB4Y8PljERf49ARAy00DktAiPFVPas4tqNbpRbHuBnJ1mBekrjvfWBA=
X-Received: by 2002:a81:928c:0:b0:52a:7809:4054 with SMTP id
 j134-20020a81928c000000b0052a78094054mr69084ywg.111.1675718516390; Mon, 06
 Feb 2023 13:21:56 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QUuuZLC0DJNEfZ7amyd3XnRhRNr1k+1OgLfDeF77X1ZDQ@mail.gmail.com>
 <CAELaAXysa3M-TPbLMCVCwpt40iqhXpF7PCan_i6SzY_YMafXrg@mail.gmail.com>
In-Reply-To: <CAELaAXysa3M-TPbLMCVCwpt40iqhXpF7PCan_i6SzY_YMafXrg@mail.gmail.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Mon, 6 Feb 2023 16:21:44 -0500
Message-ID: <CAJSP0QWLdbNqyrGnhRB3AqMpH0xYFK6+=TpWrrytQzn9MGD2zA@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2023
To:     Alberto Faria <afaria@redhat.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Thomas Huth <thuth@redhat.com>, John Snow <jsnow@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Damien <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Bernhard Beschow <shentey@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, gmaglione@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 6 Feb 2023 at 14:51, Alberto Faria <afaria@redhat.com> wrote:
>
> On Fri, Jan 27, 2023 at 3:17 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
> > Dear QEMU, KVM, and rust-vmm communities,
> > QEMU will apply for Google Summer of Code 2023
> > (https://summerofcode.withgoogle.com/) and has been accepted into
> > Outreachy May 2023 (https://www.outreachy.org/). You can now
> > submit internship project ideas for QEMU, KVM, and rust-vmm!
> >
> > Please reply to this email by February 6th with your project ideas.
> >
> > If you have experience contributing to QEMU, KVM, or rust-vmm you can
> > be a mentor. Mentors support interns as they work on their project. It's a
> > great way to give back and you get to work with people who are just
> > starting out in open source.
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
> > For more background on QEMU internships, check out this video:
> > https://www.youtube.com/watch?v=xNVCX7YMUL8
> >
> > Please let me know if you have any questions!
> >
> > Stefan
>
> FWIW there is some work to be done on libblkio [1] that QEMU could
> benefit from. Maybe these would be appropriate as QEMU projects?
>
> One possible project would be to add zoned device support to libblkio
> and all its drivers [2]. This would allow QEMU to use zoned
> vhost-user-blk devices, for instance (once general zoned device
> support lands [3]).
>
> Another idea would be to add an NVMe driver to libblkio that
> internally relies on xNVMe [4, 5]. This would enable QEMU users to use
> the NVMe drivers from SPDK or libvfn.

Great that you're interesting, Alberto! Both sound feasible. I would
like to co-mentor the zoned storage project or can at least commit to
being available to help because zoned storage is currently on my mind
anyway :).

Do you want to write up one or both of them using the project template
below? You can use the other project ideas as a reference for how much
detail to include: https://wiki.qemu.org/Google_Summer_of_Code_2023

=== TITLE ===

 '''Summary:''' Short description of the project

 Detailed description of the project.

 '''Links:'''
 * Wiki links to relevant material
 * External links to mailing lists or web sites

 '''Details:'''
 * Skill level: beginner or intermediate or advanced
 * Language: C
 * Mentor: Email address and IRC nick
 * Suggested by: Person who suggested the idea

Thanks,
Stefan

>
> Thanks,
> Alberto
>
> [1] https://libblkio.gitlab.io/libblkio/
> [2] https://gitlab.com/libblkio/libblkio/-/issues/44
> [3] https://lore.kernel.org/qemu-devel/20230129102850.84731-1-faithilikerun@gmail.com/
> [4] https://gitlab.com/libblkio/libblkio/-/issues/45
> [5] https://github.com/OpenMPDK/xNVMe
>
