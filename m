Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532794B3B2A
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 12:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbiBMLiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Feb 2022 06:38:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235339AbiBMLip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Feb 2022 06:38:45 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4470E5B88E
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 03:38:40 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id d18-20020a9d51d2000000b005a09728a8c2so9686379oth.3
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 03:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sGy6+YA6Lv8KVw+rOUVLJDd2D7buJACZzak81xW9KKo=;
        b=p/fgOu3m900W/rw158RPGAl6q68tw63j/bzw1f/cElxOhFtNagDXCfqf5yGAvCD/Er
         R924kwWh95t8Dt3g3bXZ2OnDjcqE6gGHX2Re27mI77ucAt7GFpgEYglSiC0x7bzFqIlq
         wLU9nYAaZKjhFFUSQjVu0yAh79wj/2PzSrlRNjAwDDjhQf+C/tACUFw2VNMoiuoR6zOl
         mndvyTT2p8UwdJWf12IxfDeh87ZtUtLMMKhgtR3N1IHN3OQXM25WoJxMoDnLPZ8anfr0
         mzS737LkIxHlxHcUwMcHBGCLib8iVo3F5TOVjYCY/TMEfDsAw2IrAemK0coc62Lt4+IC
         VyPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sGy6+YA6Lv8KVw+rOUVLJDd2D7buJACZzak81xW9KKo=;
        b=7n1I+SFGuMxVbGi0RwRUfCLv3u+YevD95/TNA6c09Xr0syI7mvOdTButiq87zcBFi4
         +4/84I5ONkjPw7YbmPLtuo02nKx4s0En+eFpC4IWB9Mdt0RK1piwNYeYvgj8bb3saz55
         UX8KcZfm/OCvYDQXRpvHH9yBjbVMcQzqHH0Ot7IfCpvoxgatsyzBLWuTFVH58Puu1Sr5
         NiySPY7mGWQRLiAAVl1Rt6LigDKSRgO6HwCdkSHzztUhfGAB6m2WtC21xb9YYmVLTIX0
         7400EaDWPysSoOoucAgiL7Q+jdZ31QEjY9//0bblUe+Ph18L/f7Ho17upqkWzmLfPzaA
         147w==
X-Gm-Message-State: AOAM5318yONeqXg8m/F1L09sPHtfVqmPHEF+dAGNw1uSfryXmVbq9j0q
        fhHDN7nvApk65IqXRGyISDIElh94jZ1Ft9ie2qQ=
X-Google-Smtp-Source: ABdhPJy9wQzjQ3nZFfJ26JTm2zWAhExrPxP3STsy2GXOuB4wb6fVRTBG0UIZjTS5ZkLfuJEsp+7rGu9LO5N8VYolfDE=
X-Received: by 2002:a9d:7cce:: with SMTP id r14mr2532351otn.235.1644752319499;
 Sun, 13 Feb 2022 03:38:39 -0800 (PST)
MIME-Version: 1.0
References: <20220120123630.267975-1-peter.maydell@linaro.org>
 <20220120123630.267975-19-peter.maydell@linaro.org> <3f4f5e98-fcb8-bf4d-e464-6ad365af92f8@gmail.com>
 <87iltjxdz6.wl-maz@kernel.org> <CAFEAcA9yR4=PNCGJk6iMEq0EHejwwt-gQJfvByEk-EN6ER5o_g@mail.gmail.com>
In-Reply-To: <CAFEAcA9yR4=PNCGJk6iMEq0EHejwwt-gQJfvByEk-EN6ER5o_g@mail.gmail.com>
From:   Akihiko Odaki <akihiko.odaki@gmail.com>
Date:   Sun, 13 Feb 2022 20:38:28 +0900
Message-ID: <CAMVc7JWUm7v6gt48TP+ugzEeHwo6FA66TeE3h3fqyHmHsShoig@mail.gmail.com>
Subject: Re: [PULL 18/38] hw/arm/virt: Honor highmem setting when computing
 the memory map
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        qemu Developers <qemu-devel@nongnu.org>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com, Alexander Graf <agraf@csgraf.de>
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

On Sun, Feb 13, 2022 at 7:46 PM Peter Maydell <peter.maydell@linaro.org> wrote:
>
> On Sun, 13 Feb 2022 at 10:22, Marc Zyngier <maz@kernel.org> wrote:
> >
> > [+ Alex for HVF]
> >
> > On Sun, 13 Feb 2022 05:05:33 +0000,
> > Akihiko Odaki <akihiko.odaki@gmail.com> wrote:
> > > Hi,
> > > This breaks in a case where highmem is disabled but can have more than
> > > 4 GiB of RAM. M1 (Apple Silicon) actually can have 36-bit PA with HVF,
> > > which is not enough for highmem MMIO but is enough to contain 32 GiB
> > > of RAM.
> >
> > Funny. The whole point of this series is to make it all work correctly
> > on M1.
> >
> > > Where the magic number of 4 GiB / 32-bit came from?
> >
> > Not exactly a magic number. From QEMU's docs/system/arm/virt.rst:
> >
> > <quote>
> > highmem
> >   Set ``on``/``off`` to enable/disable placing devices and RAM in physical
> >   address space above 32 bits. The default is ``on`` for machine types
> >   later than ``virt-2.12``.
> > </quote>
> >
> > TL;DR: Removing the bogus 'highmem=off' option from your command-line
> > should get you going with large memory spaces, up to the IPA limit.
>
> Yep. I've tested this with hvf, and we now correctly:
>  * refuse to put RAM above 32-bits if you asked for a 32-bit
>    IPA space with highmem=off
>  * use the full 36-bit address space if you don't say highmem=off
>    on an M1
>
> Note that there is a macos bug where if you don't say highmem=off
> on an M1 Pro then you'll get a macos kernel panic. M1 non-Pro is fine.
>
> thanks
> -- PMM

I found that it actually gets the available PA bit of the emulated CPU
when highmem=on. I used "cortex-a72", which can have more than 36
bits. I just simply switched to "host"; hvf didn't support "host" when
I set up my VM but now it does.
Thanks for your prompt replies.

Regards,
Akihiko Odaki
