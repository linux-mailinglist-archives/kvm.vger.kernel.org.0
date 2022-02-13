Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FA24B3AF3
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 11:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbiBMKqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Feb 2022 05:46:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiBMKqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Feb 2022 05:46:09 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE5F5DE40
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 02:46:02 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id p9so1854005wra.12
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 02:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PQcF8Y+i7eV4kkrW2kf6trBLdlKoGxKPY/8Iaq1QQj4=;
        b=ecFXnrWY3adlMoX/kiqi9gvnmpbdmuDKmYvskGDXFo65y6coRh75wuFfZ0jVKJpeTo
         Xly8qDiRP2rzciOZEsD5CXU+3bYqfg3dXJBZT29arqtSrAXd0xyhT6b1d+DyW0/w5Njc
         1qsPzNoaYLqfVSkhCj7BVQFPJ0W9U0ug6rDn/VieJSBS2vCiihQpvqZeM7Kiw0a4ldhV
         VsK/3Po+9waC/y+qqk+Hp9zRT0u7s6d/kw0iSyDkF6oNwlwOMGOVI+IMNKRiJOUgudBK
         veLvX5PS0pxfMqVbFHpbDkb/oFhI+XWf8KOXMIut1esDuAoKOcGaNEz8J+Unb4zskHzP
         l0MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PQcF8Y+i7eV4kkrW2kf6trBLdlKoGxKPY/8Iaq1QQj4=;
        b=2RX2GCQ4utrjGRieLL3LtKcgzQhxPIm6apFlCq2VC0//PI2uQKcxz/AM5IIRwcfjr+
         58FxsL75QGP5IMOCwyAFnaGo1Fep01CujlIT4XGbLx/ELgCXCuTxf5OgpYb68zGgXa0b
         SD+3eHLiEUrToM6c5AbxnD8MZcPada5WdGxnW1XvLEZ+lzkCkrvVt1+OfoVyBKkOBzNl
         fKKa9dz5pmRejTQN4PINi0jzB+jgYuoete7tAd/QUFCxziQd3650qAjPnajDCIM+T5/r
         pTZdD6/qLLbgW99NpN/Zysxw0VeD3OW2WFdrAT+f8O4i5w/zYG1+hzsZKafNj5uIPZD7
         zLew==
X-Gm-Message-State: AOAM5322v29Up2JBP8dOy19IgIDJy0DapgbZo3OJYe3RxWC3x7lMxjDB
        2fu4a9IKVSfbZPd6fypXAYJywTU2EkC0Tj7Pyt0HcQ==
X-Google-Smtp-Source: ABdhPJyNontRdkRP4Jo3hktzFuN0UpoTAZKFoEiu6aBmNtZv1VP2RcJJIIDNzITalzofGnN/carqm1dtedUo76JYQgA=
X-Received: by 2002:a5d:62c4:: with SMTP id o4mr7463092wrv.319.1644749161346;
 Sun, 13 Feb 2022 02:46:01 -0800 (PST)
MIME-Version: 1.0
References: <20220120123630.267975-1-peter.maydell@linaro.org>
 <20220120123630.267975-19-peter.maydell@linaro.org> <3f4f5e98-fcb8-bf4d-e464-6ad365af92f8@gmail.com>
 <87iltjxdz6.wl-maz@kernel.org>
In-Reply-To: <87iltjxdz6.wl-maz@kernel.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Sun, 13 Feb 2022 10:45:50 +0000
Message-ID: <CAFEAcA9yR4=PNCGJk6iMEq0EHejwwt-gQJfvByEk-EN6ER5o_g@mail.gmail.com>
Subject: Re: [PULL 18/38] hw/arm/virt: Honor highmem setting when computing
 the memory map
To:     Marc Zyngier <maz@kernel.org>
Cc:     Akihiko Odaki <akihiko.odaki@gmail.com>, qemu-devel@nongnu.org,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com, Alexander Graf <agraf@csgraf.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 13 Feb 2022 at 10:22, Marc Zyngier <maz@kernel.org> wrote:
>
> [+ Alex for HVF]
>
> On Sun, 13 Feb 2022 05:05:33 +0000,
> Akihiko Odaki <akihiko.odaki@gmail.com> wrote:
> > Hi,
> > This breaks in a case where highmem is disabled but can have more than
> > 4 GiB of RAM. M1 (Apple Silicon) actually can have 36-bit PA with HVF,
> > which is not enough for highmem MMIO but is enough to contain 32 GiB
> > of RAM.
>
> Funny. The whole point of this series is to make it all work correctly
> on M1.
>
> > Where the magic number of 4 GiB / 32-bit came from?
>
> Not exactly a magic number. From QEMU's docs/system/arm/virt.rst:
>
> <quote>
> highmem
>   Set ``on``/``off`` to enable/disable placing devices and RAM in physical
>   address space above 32 bits. The default is ``on`` for machine types
>   later than ``virt-2.12``.
> </quote>
>
> TL;DR: Removing the bogus 'highmem=off' option from your command-line
> should get you going with large memory spaces, up to the IPA limit.

Yep. I've tested this with hvf, and we now correctly:
 * refuse to put RAM above 32-bits if you asked for a 32-bit
   IPA space with highmem=off
 * use the full 36-bit address space if you don't say highmem=off
   on an M1

Note that there is a macos bug where if you don't say highmem=off
on an M1 Pro then you'll get a macos kernel panic. M1 non-Pro is fine.

thanks
-- PMM
