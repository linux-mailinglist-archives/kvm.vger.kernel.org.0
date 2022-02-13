Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67384B3B63
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 13:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbiBMM52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Feb 2022 07:57:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiBMM52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Feb 2022 07:57:28 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63255B3F2
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 04:57:22 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d27so22724753wrc.6
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 04:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2c0SI7m7ZB+m4RaXReFLA6+iDUdiDg4G2NOqfn4wgmQ=;
        b=aIWlNEwWaI2UJKNAmkRKc6aBrQm3cGtJHiz2aA0Z7odhnA3B1av2838F3V38ouojFQ
         rQJIUHmH7pK3pIlfJvyojEXJ/jrxYmrHkcXH9+jHkcspcl8lzYfAjGhisTB91qaFWZ1W
         2BwwhmEX4y9/G17HyrYXTsfnFrYzQ1J6IZAyF2541fRZOA9GOZ0fP0FRfSDDIae9Bklr
         yXZadDm4hD8lk3qwt2ny3UlFloyTzA5v1upVlSIMM2Hl9jvykTVNK31f6Nh473mTdALw
         bVLtsY5lBiBenxv4FUbogTTfxRPiTSKH1Kmx0i8KUAHWT51UFIXTHJ6GjoLWC/WgDprv
         /C9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2c0SI7m7ZB+m4RaXReFLA6+iDUdiDg4G2NOqfn4wgmQ=;
        b=qBrZl9JJoICmagUXAnANtSIO0Hl+uvOC0EaSkzuNUc4wgVlf9yNtrlZVLgfA9Q40YU
         OkJywGN/8aU0Kr0YixlI+qQ6hoNcK6ulvXlkin4nO9S7V4tNHfEsQz7TDI7fpxspcql/
         pntazhO4jwVTxl/S545Wb89h78A4fOOQ5uI9hJB9pXwGTXbdgoy6IAA2FcvKiavmrW4r
         +2+hnm0n0Y0sB3fnrngGkwrwPeRHEcOExc0bpfmZ9tBLfnPPpcfnuUDJwSgPFGij0m10
         LMkndMlYxEprTA0BoomD/0vWmGrbbK1MN8M76+WFiSAHn6Mb7WjTUuoI68KUks24/i5g
         Oasw==
X-Gm-Message-State: AOAM532g411/pgF4vsCYPmuun0sjNq9i3wTnUtARSp1qu5EV9F6ZXC/x
        DNVmGQo0VR/9rpJTz6r2Q2x2KjaEbuIN1cMee6iYtT1MnP0=
X-Google-Smtp-Source: ABdhPJyhWkmqOt5Qv5V8sVaUI/z6NPBi3j81Oxw8fxbdgicbVi/hBwNisw0rORYtSXJDU+bZsM9nUw4+Wq9rLZHPZF4=
X-Received: by 2002:a5d:62c4:: with SMTP id o4mr7776005wrv.319.1644757041279;
 Sun, 13 Feb 2022 04:57:21 -0800 (PST)
MIME-Version: 1.0
References: <20220120123630.267975-1-peter.maydell@linaro.org>
 <20220120123630.267975-19-peter.maydell@linaro.org> <3f4f5e98-fcb8-bf4d-e464-6ad365af92f8@gmail.com>
 <87iltjxdz6.wl-maz@kernel.org> <CAFEAcA9yR4=PNCGJk6iMEq0EHejwwt-gQJfvByEk-EN6ER5o_g@mail.gmail.com>
 <CAMVc7JWUm7v6gt48TP+ugzEeHwo6FA66TeE3h3fqyHmHsShoig@mail.gmail.com>
In-Reply-To: <CAMVc7JWUm7v6gt48TP+ugzEeHwo6FA66TeE3h3fqyHmHsShoig@mail.gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Sun, 13 Feb 2022 12:57:10 +0000
Message-ID: <CAFEAcA817oN+UNJC=o-GTAXo0UypgsTkm7MvcLKDSR-9amkPXA@mail.gmail.com>
Subject: Re: [PULL 18/38] hw/arm/virt: Honor highmem setting when computing
 the memory map
To:     Akihiko Odaki <akihiko.odaki@gmail.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        qemu Developers <qemu-devel@nongnu.org>,
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

On Sun, 13 Feb 2022 at 11:38, Akihiko Odaki <akihiko.odaki@gmail.com> wrote:
> I found that it actually gets the available PA bit of the emulated CPU
> when highmem=on. I used "cortex-a72", which can have more than 36
> bits. I just simply switched to "host"; hvf didn't support "host" when
> I set up my VM but now it does.

It's a bug that we accept 'cortex-a72' there. What should happen
is something like:
 * we want to use the ID register values of a cortex-a72
 * QEMU's hvf layer should say "no, that doesn't match the actual
   CPU we're running on", and give an error

This works correctly with KVM because there the kernel refuses
attempts to set ID registers to values that don't match the host;
for hvf the hvf APIs do permit lying to the guest about ID register
values so we need to do the check ourselves.

(The other approach would be to check the ID register values
and allow them to the extent that the host CPU actually has
the support for the features they imply, so you could "downgrade"
to a less capable CPU but not tell the guest it has feature X
if it isn't really there. But this is (a) a lot more complicated
and (b) gets into the swamp of trying to figure out how to tell
the guest about CPU errata -- the guest needs to apply errata
workarounds for the real host CPU, not for whatever the emulated
CPU is. So "just reject anything that's not an exact match" is
the easy approach.)

-- PMM
