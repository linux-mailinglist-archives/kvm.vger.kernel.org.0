Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5053D5F41A2
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 13:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiJDLK7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 07:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiJDLKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 07:10:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13EC17E35
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 04:10:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4C03B819A2
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 11:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F33C433D7
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 11:10:35 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="RbPV9pZh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664881833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ajBRTUqWYq/z16/huV0n8Gpu7U+LrPQQWNIxTi9igwE=;
        b=RbPV9pZhKiaNu2vUFot+rletGTf/dZiNwMQ6GfirtAqbQSlhtqn/eyeW595oiK9SgyIQLT
        y+qVvyHGd+wzRNjWU69zWhtu5jfxwLx8dXHzOjm5hQs8kWtZK+3lXcAMsvBpuCURzrpOzD
        C2jHvWKKHq+aK2pZ5sTvHCcCVyiuJzw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 52932999 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <kvm@vger.kernel.org>;
        Tue, 4 Oct 2022 11:10:33 +0000 (UTC)
Received: by mail-ua1-f42.google.com with SMTP id i16so1537131uak.1
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 04:10:33 -0700 (PDT)
X-Gm-Message-State: ACrzQf2btwnxJ6EFJixd9E4zzzukODNm5qXe9RRVzrziOgNOrvgsdcTe
        5jKvM6LZjlnt7NNV+OwXxreqk1L9oBnubzKnO2A=
X-Google-Smtp-Source: AMsMyM7DVIxxPkp0Lz8qvkNYFm/cvlfmn+NmBE7zmMD51WOMVMRia/+Jif0CtqlJgBm/cX49zhZSqB64Y6oWaU0Jprg=
X-Received: by 2002:ab0:6154:0:b0:398:c252:23d8 with SMTP id
 w20-20020ab06154000000b00398c25223d8mr12012501uan.65.1664881831677; Tue, 04
 Oct 2022 04:10:31 -0700 (PDT)
MIME-Version: 1.0
References: <YziPyCqwl5KIE2cf@zx2c4.com> <20221003103627.947985-1-Jason@zx2c4.com>
 <b529059a-7819-e49d-e4dc-7ae79ee21ec5@amsat.org> <CAHmME9pUuduiEcmi2xaY3cd87D_GNX1bkVeXNqVq6AL_e=Kt+Q@mail.gmail.com>
 <YzwM+KhUG0bg+P2e@zx2c4.com> <CAFEAcA9KsooNnYxiqQG-RHustSx0Q3-F8ibpQbXbwxDCA+2Fhg@mail.gmail.com>
 <CAHmME9qmSX=QmBa-k4T1U=Gnz-EtahnYxLmOewpN85H9TqNSmA@mail.gmail.com> <CAFEAcA9-_qmtJgy_WRJT5TUKMm_60U53Mb9a+_BqUnQSS7PPcg@mail.gmail.com>
In-Reply-To: <CAFEAcA9-_qmtJgy_WRJT5TUKMm_60U53Mb9a+_BqUnQSS7PPcg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 4 Oct 2022 13:10:20 +0200
X-Gmail-Original-Message-ID: <CAHmME9qDN_m6+6R3OiNueHc0qEcvptpO9+0HxZ713knZ=8fkoQ@mail.gmail.com>
Message-ID: <CAHmME9qDN_m6+6R3OiNueHc0qEcvptpO9+0HxZ713knZ=8fkoQ@mail.gmail.com>
Subject: Re: [PATCH v2] mips/malta: pass RNG seed to to kernel via env var
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 4, 2022 at 1:03 PM Peter Maydell <peter.maydell@linaro.org> wrote:
> What I'm asking, I guess, is why you're messing with this board
> model at all if you haven't added this functionality to u-boot.
> This is just an emulation of an ancient bit of MIPS hardware, which
> nobody really cares about very much I hope.

I think most people emulating MIPS would disagree. This is basically a
reference platform for most intents and purposes. As I mentioned, this
involves `-kernel` -- the thing that's used when you explicitly opt-in
to not using a bootloader, so when you sign up for QEMU arranging the
kernel image and its environment. Neglecting to pass an RNG seed would
be a grave mistake.

> I'm not saying this is a bad patch -- I'm just saying that
> QEMU should not be in the business of defining bootloader-to-kernel
> interfaces if it can avoid it, so usually the expectation is
> that we are just implementing interfaces that are already
> defined, documented and implemented by a real bootloader and kernel.

Except that's not really the way things have ever worked here. The
kernel now has the "rngseed" env var functionality, which is useful
for a variety of scenarios -- kexec, firmware, and *most importantly*
for QEMU. Don't block progress here.

> -kernel generally means "emulate the platform's boot loader"

And here, a platform bootloader could pass this, just as is the case
with m68k's BI_RNG_SEED or x86's setup_data RNG SEED or device tree's
rng-seed or EFI's LINUX_EFI_RANDOM_SEED_TABLE_GUID or MIPS' "rngseed"
fw environment variable. These are important facilities to have.
Bootloaders and hypervisors alike must implement them. *Do not block
progress here.*

Jason
