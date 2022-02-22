Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B334C4C03B8
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 22:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbiBVVZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 16:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbiBVVZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 16:25:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D967BE1B66;
        Tue, 22 Feb 2022 13:24:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C12FB81A2C;
        Tue, 22 Feb 2022 21:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27C8C340EF;
        Tue, 22 Feb 2022 21:24:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="eOQgnPCp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645565074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JVDKbWuQaqEUhqppE+Xa9vvhTXzWjrw/6DnshvBmlO0=;
        b=eOQgnPCpWRl5TMMpaPVhvbX6lq+sLxdAY8XQgNIujD8GpCWeghLZw1cOioWX9ZHqZq42aJ
        0U6KNQ0GbKy4KAbjj8gUNeGqbxnOPJ8h3rLImgPORyI8JEFRqKDXCdWFJyb/Yrkm7tWc0V
        OU1nnLROMDx67R/QmiMkZKbSlou8ISc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1ec5e406 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 22 Feb 2022 21:24:34 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id p19so43940630ybc.6;
        Tue, 22 Feb 2022 13:24:32 -0800 (PST)
X-Gm-Message-State: AOAM533rByRKf3PzatJuSPHFsa5T6Ry4V1y9miuCSBaQord//8uPntne
        UJsk8EOMvAE7yVOoOKhmIbNj2+7zVT3mf4aP780=
X-Google-Smtp-Source: ABdhPJwvfehACY5olNLdLYWx+1mbRCA/UudBhvxotju5WcW8qrMaLZ7L0JYyK5Hf2olVo7SAOkvPTIjxZVLW1My2qho=
X-Received: by 2002:a5b:d11:0:b0:623:fbda:40f4 with SMTP id
 y17-20020a5b0d11000000b00623fbda40f4mr25771486ybp.398.1645565070061; Tue, 22
 Feb 2022 13:24:30 -0800 (PST)
MIME-Version: 1.0
References: <1614156452-17311-1-git-send-email-acatan@amazon.com> <1614156452-17311-3-git-send-email-acatan@amazon.com>
In-Reply-To: <1614156452-17311-3-git-send-email-acatan@amazon.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 22 Feb 2022 22:24:19 +0100
X-Gmail-Original-Message-ID: <CAHmME9o6cjZT1Cj1g5w5WQE83YxJNqB7eUCWn74FA9Pbb3Y6nQ@mail.gmail.com>
Message-ID: <CAHmME9o6cjZT1Cj1g5w5WQE83YxJNqB7eUCWn74FA9Pbb3Y6nQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] drivers/virt: vmgenid: add vm generation id driver
To:     Adrian Catangiu <acatan@amazon.com>
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
        vijaysun@ca.ibm.com, oridgar@gmail.com, ghammer@redhat.com
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

Hi Adrian,

This thread seems to be long dead, but I couldn't figure out what
happened to the ideas in it. I'm specifically interested in this part:

On Wed, Feb 24, 2021 at 9:48 AM Adrian Catangiu <acatan@amazon.com> wrote:
> +static void vmgenid_acpi_notify(struct acpi_device *device, u32 event)
> +{
> +       uuid_t old_uuid;
> +
> +       if (!device || acpi_driver_data(device) != &vmgenid_data) {
> +               pr_err("VMGENID notify with unexpected driver private data\n");
> +               return;
> +       }
> +
> +       /* update VM Generation UUID */
> +       old_uuid = vmgenid_data.uuid;
> +       memcpy_fromio(&vmgenid_data.uuid, vmgenid_data.uuid_iomap, sizeof(uuid_t));
> +
> +       if (memcmp(&old_uuid, &vmgenid_data.uuid, sizeof(uuid_t))) {
> +               /* HW uuid updated */
> +               sysgenid_bump_generation();
> +               add_device_randomness(&vmgenid_data.uuid, sizeof(uuid_t));
> +       }
> +}

As Jann mentioned in an earlier email, we probably want this to
immediately reseed the crng, not just dump it into
add_device_randomness alone. But either way, the general idea seems
interesting to me. As far as I can tell, QEMU still supports this. Was
it not deemed to be sufficiently interesting?

Thanks,
Jason
