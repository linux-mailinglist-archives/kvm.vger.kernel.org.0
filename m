Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE19368DBC2
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 15:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbjBGOhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 09:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbjBGOg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 09:36:59 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54823A874
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 06:34:12 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-4c24993965eso197963607b3.12
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 06:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RTH+aH0oSY3ZVMd9O3U15uYMHnEaKKfdSwajJ12ADOI=;
        b=OVTQhbegMlYyAF7g4djIvtyt0hHaAhM6URGUcqV79ytkKaJSPqC0WwFghFl2Bz4TeM
         SmlvTClvHyY+w2+Ln0z9WhuEDQ/MZ3/zF7dx/Y+aLhZ9bjFkFqHZ4f1AFOPsTINeBHl9
         T7iVdmIS8lIcNcYHHO7QFYIkj3RMdhXYAmAR4RV7SmvNuDGefaks32Mgg+ji1+NaIUyQ
         oYQ4ZX4cVVrPmGwtVphzMeL/yN4660mDSr/V/udj7Mwuj6imMSlB4ARcHMl10x9CprA7
         VuulCT68r1CIc0B1MDq+IWJ73ghRaxV5EjRFFbavlGb0GuzRvEwRDfpIbOPh8Wrya7MC
         d3SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RTH+aH0oSY3ZVMd9O3U15uYMHnEaKKfdSwajJ12ADOI=;
        b=WcftUZLlwN+Ljr6PgDYwFvNJH+a7PohIqYNs2lcg9mRwwiBW/HtbNnwTW0VIIdVJ7U
         TKLX15XwQFaJZWu7sthSInto0HDAbnmwCBy5zwM9WY/WW6HjAQbSyctPuVukw/L4ibqK
         xLC0WuHTB9Uk6lBGE8jaoXtJVXNaSt2TJeBkyrv5y5VNyEab40neVJqbiC6BnjoI4lNx
         xOliEmkxknTgi8dXQosz8GtnxHmEgQX6/D6jVdNYtW2KuHiXteKqc/PwOPGIUJ1wfv8u
         PmPtybrox3No2UXyn8rQODFX7rPLmIhjRSwUN3FsYijj5q8VEOyakx90Uu1w49I199wp
         R/5A==
X-Gm-Message-State: AO0yUKUiZg3tEjIWH2087Mdz30PWgPwUj6t6VZY2EpEp1+p6JQMwTsWR
        UpprHUaxE9bXSVFwy/siepCs203hq9NcpLfKymg=
X-Google-Smtp-Source: AK7set++S9is4bzsa+KfhYVLzXm962DXR+Of+cTGrOBJRzVHYEGEkM2v3+gXYH3mkJxJfixxV/DpetVZ9yy3PmWI3+Q=
X-Received: by 2002:a81:a10f:0:b0:527:ac79:7808 with SMTP id
 y15-20020a81a10f000000b00527ac797808mr301705ywg.239.1675780382820; Tue, 07
 Feb 2023 06:33:02 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QUuuZLC0DJNEfZ7amyd3XnRhRNr1k+1OgLfDeF77X1ZDQ@mail.gmail.com>
 <CAELaAXysa3M-TPbLMCVCwpt40iqhXpF7PCan_i6SzY_YMafXrg@mail.gmail.com>
 <CAJSP0QWLdbNqyrGnhRB3AqMpH0xYFK6+=TpWrrytQzn9MGD2zA@mail.gmail.com>
 <CAELaAXwAF1QSyfFEzqBFJk69VZN9cEC=H=hHh6kvndFm9p0f6w@mail.gmail.com> <CAELaAXx6cUhcs+Yi4Kev6BfcG0LO8H_hAKWrCBL77TbmguKO+w@mail.gmail.com>
In-Reply-To: <CAELaAXx6cUhcs+Yi4Kev6BfcG0LO8H_hAKWrCBL77TbmguKO+w@mail.gmail.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Tue, 7 Feb 2023 09:32:50 -0500
Message-ID: <CAJSP0QXqOkVEza0S=A-Ct_6FqRGe3BQgkJEG6HnqoMAdLhJ5pA@mail.gmail.com>
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

On Tue, 7 Feb 2023 at 05:30, Alberto Faria <afaria@redhat.com> wrote:
>
> On Tue, Feb 7, 2023 at 10:23 AM Alberto Faria <afaria@redhat.com> wrote:
> > On Mon, Feb 6, 2023 at 9:22 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
> > > Great that you're interesting, Alberto! Both sound feasible. I would
> > > like to co-mentor the zoned storage project or can at least commit to
> > > being available to help because zoned storage is currently on my mind
> > > anyway :).
> >
> > Perfect, I'll have time to co-mentor one project, but probably not
> > two, so let's leave the NVMe driver project aside for now. If anyone
> > wants to take that one over, though, go for it.
> >
> > > Do you want to write up one or both of them using the project template
> > > below? You can use the other project ideas as a reference for how much
> > > detail to include: https://wiki.qemu.org/Google_Summer_of_Code_2023
> >
> > I feel like this is closer to a 175 hour project than a 350 hour one,
> > but I'm not entirely sure.
> >
> >   === Zoned device support for libblkio ===
> >
> >    '''Summary:''' Add support for zoned block devices to the libblkio library.
> >
> >    Zoned block devices are special kinds of disks that are split into several
> >    regions called zones, where each zone may only be written
> > sequentially and data
> >    can't be updated without resetting the entire zone.
> >
> >    libblkio is a library that provides an API for efficiently accessing block
> >    devices using modern high-performance block I/O interfaces like
> > Linux io_uring.
> >
> >    The goal is to extend libblkio so users can use it to access zoned devices
> >    properly. This will require adding support for more request types, expanding
> >    its API to expose additional metadata about the device, and making the
> >    appropriate changes to each libblkio "driver".
> >
> >    This is important for QEMU since it will soon support zoned devices too and
> >    several of its BlockDrivers rely on libblkio. In particular, this
> > project would
> >    enable QEMU to access zoned vhost-user-blk and vhost-vdpa-blk devices.
>
> Also, a stretch/bonus goal could be to make the necessary changes to
> QEMU to actually make use of libblkio's zoned device support.

Great, I have added it to the wiki and included a list of tasks:
https://wiki.qemu.org/Internships/ProjectIdeas/LibblkioZonedStorage

Feel free to edit it.

I think this project could just as easily be 350 hours, but I'm happy
to mentor a 175 hour project with a more modest scope.

Stefan
