Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCFF5F4146
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 13:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiJDLDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 07:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiJDLDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 07:03:40 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D79D2F67D
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 04:03:39 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id au23so7290971ejc.1
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 04:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=mENYIcsM8H7by6Cq0FHD+iv07XiZcyZ7ZAKXcrPZEag=;
        b=rfLLEkmV/DjE1s0QvEakV00KEhKQZB4INowQDebL2Y/KgsKP82zsFVc0K2ZCCGHOLY
         qNafbLxiKJKzEAvqUrtMP+sgCSqfZBzWviaVVgsqMoDB9YIFtCFGjB1SNE75D59tGX81
         nrMgfdCDbh6TXW+W8DLKfY5EYmxUDfiGV1ixn1+XL7MYtOWBQAf5ruulwBwCO0Be5ZDR
         LXr5xwKhmUUI5h8zBaDItEIb2+8iJLlmqrY8Nwap6XLv6NL642bJ+f4l/RrxmGxwwUer
         2RXIyIqLVL3H1nWhgxC0HH8XJn4GZwDnXUgPVBm2pCtzSBEKp+v9OwrWsYrcceHz5jmE
         aZeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=mENYIcsM8H7by6Cq0FHD+iv07XiZcyZ7ZAKXcrPZEag=;
        b=auhd26B8oPROZG6FjCOEnRVUxGfNitjSajrZtBghVlD6C4v9auJWRiBe8fRS4vLifY
         bPpH5ICQkwzB1o+5myuKE4NNpAa6jEeIZIYe76LfIHD7abK6pDrAiitNuoTeEOakKQvA
         XIo04tbzQRWtSI/U/rSsMM0pRzyLguOABJqMY0ZYChKSXbY9D1D9hV/GAyE39+EDcE4X
         9qWveyjYsUuvEvPIXdDqhIuIPFmSDKVmewF/Lq2elmIuNgz/HyCJBD2DrLbt05KsvLA5
         vTF3r/g+MO6KFdSiWud57zcTl8iNte6oV/xDK2veDuOGZYl97HSpwzUXPWYdQ2QrgFfh
         aBdQ==
X-Gm-Message-State: ACrzQf0ydlPl/dXWTJRRhTyU/YzH+ofevmvi/x0VRS6rvCuXviAcdOYH
        iXl4+bDNVSsA9/XzxqgxyjAzSFNmbqz1xq0rPTmeCA==
X-Google-Smtp-Source: AMsMyM47K1gxC4lHvGyjZA6dcDghY+EwIVm1mLHKNNnxSZf/Mc3o4uNOSa2RoeR+5aHsI+/nMDaXajeQMWDp6mByGKc=
X-Received: by 2002:a17:907:724b:b0:782:f2bb:24d3 with SMTP id
 ds11-20020a170907724b00b00782f2bb24d3mr18604159ejc.555.1664881417827; Tue, 04
 Oct 2022 04:03:37 -0700 (PDT)
MIME-Version: 1.0
References: <YziPyCqwl5KIE2cf@zx2c4.com> <20221003103627.947985-1-Jason@zx2c4.com>
 <b529059a-7819-e49d-e4dc-7ae79ee21ec5@amsat.org> <CAHmME9pUuduiEcmi2xaY3cd87D_GNX1bkVeXNqVq6AL_e=Kt+Q@mail.gmail.com>
 <YzwM+KhUG0bg+P2e@zx2c4.com> <CAFEAcA9KsooNnYxiqQG-RHustSx0Q3-F8ibpQbXbwxDCA+2Fhg@mail.gmail.com>
 <CAHmME9qmSX=QmBa-k4T1U=Gnz-EtahnYxLmOewpN85H9TqNSmA@mail.gmail.com>
In-Reply-To: <CAHmME9qmSX=QmBa-k4T1U=Gnz-EtahnYxLmOewpN85H9TqNSmA@mail.gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 4 Oct 2022 12:03:26 +0100
Message-ID: <CAFEAcA9-_qmtJgy_WRJT5TUKMm_60U53Mb9a+_BqUnQSS7PPcg@mail.gmail.com>
Subject: Re: [PATCH v2] mips/malta: pass RNG seed to to kernel via env var
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Oct 2022 at 11:56, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Tue, Oct 4, 2022 at 12:53 PM Peter Maydell <peter.maydell@linaro.org> wrote:
> >
> > On Tue, 4 Oct 2022 at 11:40, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > I think the unusual thing here is that this patch isn't
> > "this facility is implemented by u-boot [commit whatever,
> > docs whatever], and here is the patch adding it to QEMU's
> > handling of the same interface". That is, for boards like
> > Malta the general expectation is that we're emulating
> > a piece of real hardware and the firmware/bootloader
> > that it would be running, so "this is a patch that
> > implements an interface that the real bootloader doesn't
> > have" is a bit odd.
>
> Except it's not different from other platforms that get bootloader
> seeds as such. A bootloader can easily pass this; QEMU most certainly
> should pass this. (I sincerely hope you're not arguing in favor of
> holding back progress in this area for yet another decade.)

What I'm asking, I guess, is why you're messing with this board
model at all if you haven't added this functionality to u-boot.
This is just an emulation of an ancient bit of MIPS hardware, which
nobody really cares about very much I hope.

I'm not saying this is a bad patch -- I'm just saying that
QEMU should not be in the business of defining bootloader-to-kernel
interfaces if it can avoid it, so usually the expectation is
that we are just implementing interfaces that are already
defined, documented and implemented by a real bootloader and kernel.

[from your other mail]
> Also, in case you've missed the actual context of this patch, it
> happens for `-kernel ...`. So we're now strictly in the realm of QEMU
> things.

-kernel generally means "emulate the platform's boot loader":
it is exactly because we do not want to be in a realm of
QEMU-defined interfaces that we try to follow what the
platform boot loader does rather than defining new
interfaces. That's not always possible or the right thing,
but it's usually the cleaner way to go.

thanks
-- PMM
