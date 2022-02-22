Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5624C0472
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 23:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236025AbiBVWSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 17:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiBVWSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 17:18:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B249EB6D19;
        Tue, 22 Feb 2022 14:17:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BC89B81A2C;
        Tue, 22 Feb 2022 22:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4211DC340E8;
        Tue, 22 Feb 2022 22:17:31 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="lXMDj8r4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645568244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vCnYHLy2ZxLW1+1wKyxbDfmohEew3lEiJPknv0zMRYw=;
        b=lXMDj8r4Yr5uWWxTJyy9JlZE8dPd9P561SOdb0cphGNYx4uYOF0/QjtLjtN93FcOp6uNlQ
        VupvtVgoxdsTRr0yiFFc/3WGr0DAPUbxmounmYEQjVl0cokQYpe4Am0KzYJUUjkCaqDOIk
        WVlMfbOqLv3Owc1ux6xbpSelgoQb0Mw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fedef2a4 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 22 Feb 2022 22:17:24 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id c6so44223237ybk.3;
        Tue, 22 Feb 2022 14:17:23 -0800 (PST)
X-Gm-Message-State: AOAM531a+v7B3JZn2f1FkbCZysTrcKGDwCqOUsj0vxEbI44kVeDuXi8m
        +u+4nDmpUmFpnqugFrgIm8U8BQpdfRbuyzR90/k=
X-Google-Smtp-Source: ABdhPJwlIOwo+38zIXLd6Qx86vOEC2pTybWrAlF+D1no8DxGsVb1DkoOkHcofqIhHbVsWXHFvpYK/Ea3CPmEoMWT/g0=
X-Received: by 2002:a05:6902:693:b0:613:7f4f:2e63 with SMTP id
 i19-20020a056902069300b006137f4f2e63mr24281380ybt.271.1645568240101; Tue, 22
 Feb 2022 14:17:20 -0800 (PST)
MIME-Version: 1.0
References: <1614156452-17311-1-git-send-email-acatan@amazon.com>
 <1614156452-17311-3-git-send-email-acatan@amazon.com> <CAHmME9o6cjZT1Cj1g5w5WQE83YxJNqB7eUCWn74FA9Pbb3Y6nQ@mail.gmail.com>
In-Reply-To: <CAHmME9o6cjZT1Cj1g5w5WQE83YxJNqB7eUCWn74FA9Pbb3Y6nQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 22 Feb 2022 23:17:09 +0100
X-Gmail-Original-Message-ID: <CAHmME9poYgfoniexZ2dvpEEvnWGLQTOjOvB2bck-Whhy9h+Hjw@mail.gmail.com>
Message-ID: <CAHmME9poYgfoniexZ2dvpEEvnWGLQTOjOvB2bck-Whhy9h+Hjw@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] drivers/virt: vmgenid: add vm generation id driver
To:     adrian@parity.io
Cc:     "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>, linux-s390@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        graf@amazon.com, Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Rapoport <rppt@kernel.org>, 0x7f454c46@gmail.com,
        borntraeger@de.ibm.com, Jann Horn <jannh@google.com>,
        Willy Tarreau <w@1wt.eu>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Andrew Lutomirski <luto@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>, bonzini@gnu.org,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Michael Ellerman <mpe@ellerman.id.au>, areber@redhat.com,
        ovzxemul@gmail.com, avagin@gmail.com, ptikhomirov@virtuozzo.com,
        gil@azul.com, asmehra@redhat.com, dgunigun@redhat.com,
        vijaysun@ca.ibm.com, oridgar@gmail.com, ghammer@redhat.com,
        Adrian Catangiu <acatan@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey again,

On Tue, Feb 22, 2022 at 10:24 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> This thread seems to be long dead, but I couldn't figure out what
> happened to the ideas in it. I'm specifically interested in this part:
>
> On Wed, Feb 24, 2021 at 9:48 AM Adrian Catangiu <acatan@amazon.com> wrote:
> > +static void vmgenid_acpi_notify(struct acpi_device *device, u32 event)
> > +{
> > +       uuid_t old_uuid;
> > +
> > +       if (!device || acpi_driver_data(device) != &vmgenid_data) {
> > +               pr_err("VMGENID notify with unexpected driver private data\n");
> > +               return;
> > +       }
> > +
> > +       /* update VM Generation UUID */
> > +       old_uuid = vmgenid_data.uuid;
> > +       memcpy_fromio(&vmgenid_data.uuid, vmgenid_data.uuid_iomap, sizeof(uuid_t));
> > +
> > +       if (memcmp(&old_uuid, &vmgenid_data.uuid, sizeof(uuid_t))) {
> > +               /* HW uuid updated */
> > +               sysgenid_bump_generation();
> > +               add_device_randomness(&vmgenid_data.uuid, sizeof(uuid_t));
> > +       }
> > +}
>
> As Jann mentioned in an earlier email, we probably want this to
> immediately reseed the crng, not just dump it into
> add_device_randomness alone. But either way, the general idea seems
> interesting to me. As far as I can tell, QEMU still supports this. Was
> it not deemed to be sufficiently interesting?
>
> Thanks,
> Jason

Well I cleaned up this v7 and refactored it into something along the
lines of what I'm thinking. I don't yet know enough about this general
problem space to propose the patch and I haven't tested it either, but
in case you're curious, something along the lines of what I'm thinking
about lives at https://git.kernel.org/pub/scm/linux/kernel/git/crng/random.git/commit/?h=jd/vmgenid
if you (or somebody else) feels inclined to pick this up.

Looking forward to learning more from you in general, though, about
what the deal is with the VM gen ID, and if this is a real thing or
not.

Regards,
Jason
