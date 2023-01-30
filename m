Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D324680612
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 07:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjA3GjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 01:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbjA3GjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 01:39:09 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66202707
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 22:39:06 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id h5so12771714ybj.8
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 22:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k/w3jr6cU/SPLd8Szgs8C4HZyivNbPsKjMXJDKWEI0E=;
        b=LVFQeYhjsIXKCV2C+1DEMd9ztzNQ2rESS1Vz631hrKNbZz2QICMJex09fotut4ebUl
         qWBuGE0GMnFG52g2VMs8xogcxDhQQhiHpNMR8b+MCpl2FAmj5yDq6WnUThRMIOf4MoQG
         4dGwg5ThvSzyho6oY/TUFWbicBLDY4i1RbP5YW9yJrUVC8cETdY8TvItGeyyZ+0WzIqd
         knfTz6ydj2GltoFwzQdLJhdz3/1CM8JGNLAgFXUYGQFAVqL7tRwSn+h97UFIibZbFo9J
         fk1f5yp8t+dWWDwu2PzswHuam+92orGememSqyn/uhvR4qbONYAQKlpbyikY2E1PuhYq
         KPSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k/w3jr6cU/SPLd8Szgs8C4HZyivNbPsKjMXJDKWEI0E=;
        b=iUkhV+/tg9ATGpFwanTPGhlsuC17G5+0I7SeIEoUITcI7suRZZU0y8BvolC8H75G1g
         ntghrX3HLulhxmOs36PWTBXL+IgnauUtia6YXYMmdCco+BuGCRA0ldSAbSv6PP9l9smy
         aWqakwqlUqQTkALpdL2heUbNJw0WXj7Wi4GaISSOtfog7hUvAK7+Fo0kMX9WRTls6ACB
         B10s0ztLN4ydwxF1EVDCcVerHtg5PDnm8UhOSLDM7kAtpsAy4ydrcNH3xArtjb1U1bxN
         tc1lCsiDcYTr/1yM7xpVyahO3PB0f5bbjIOSLC1JhNBOEZ74kYAeJJaZKRcGA80d8Fe0
         j6FA==
X-Gm-Message-State: AFqh2ko9ZwJ2p8GJI2ez8fpwW1hsYS2FAusmwxfhUrEHxr9UUpQheYWl
        z1i736peTz9hE1BCKTmesnMs22XTCBXPCFyE9DtcYQ==
X-Google-Smtp-Source: AMrXdXul0tNk+CXd8EYXzFJgjAnnIQvfNIIzeLbwoGFAXTtjhQb5Hg/X2zWSbHDpRhN3FNG4+kzRe/M/XNi0FYNsl/Y=
X-Received: by 2002:a25:71c3:0:b0:7b2:343d:6b11 with SMTP id
 m186-20020a2571c3000000b007b2343d6b11mr6222313ybc.75.1675060745665; Sun, 29
 Jan 2023 22:39:05 -0800 (PST)
MIME-Version: 1.0
References: <20230125142056.18356-1-andy.chiu@sifive.com> <20230125142056.18356-20-andy.chiu@sifive.com>
 <Y9GZbVrZxEZAraVu@spud>
In-Reply-To: <Y9GZbVrZxEZAraVu@spud>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Mon, 30 Jan 2023 14:38:54 +0800
Message-ID: <CABgGipWndcnUxUvWtyxyETtLaJT42VaZoiat7uDmnOjREEt9tg@mail.gmail.com>
Subject: Re: [PATCH -next v13 19/19] riscv: Enable Vector code to be built
To:     Conor Dooley <conor@kernel.org>,
        Vineet Gupta <vineetg@rivosinc.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 26, 2023 at 5:04 AM Conor Dooley <conor@kernel.org> wrote:
> Uh, so I don't think this was actually tested with (a recent version of)
> clang:
> clang-15: error: unknown argument: '-menable-experimental-extensions_zicbom_zihintpause'
>
> Firstly, no-implicit-float is a CFLAG, so why add it to march?
> There is an existing patch on the list for enabling this flag, but I
> recall Palmer saying that it was not actually needed?
> Palmer, do you remember why that was?
>
> I dunno what enable-experimental-extensions is, but I can guess. Do we
> really want to enable vector for toolchains where the support is
> considered experimental? I'm not au fait with the details of clang
> versions nor versions of the Vector spec, so take the following with a
> bit of a pinch of salt...
> Since you've allowed this to be built with anything later than clang 13,
> does that mean that different versions of clang may generate vector code
> that are not compatible?
Thanks for pointing this out. We found that Vector in clang13 was
still an experimental feature. And the first version of clang which
lists Vector v1.0 (ratified) as a standard support is clang14. Thus,
we will require the minimum clang toolchain version to be 14 in the
following revision.
> I'm especially concerned by:
> https://github.com/riscv/riscv-v-spec/releases/tag/0.9
> which appears to be most recently released version of the spec, prior to
> clang/llvm 13 being released.
>
> > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > index e2b656043abf..f4299ba9a843 100644
> > --- a/arch/riscv/Kconfig
> > +++ b/arch/riscv/Kconfig
> > @@ -416,6 +416,16 @@ config RISCV_ISA_SVPBMT
> >
> >          If you don't know what to do here, say Y.
> >
> > +config RISCV_ISA_V
> > +     bool "VECTOR extension support"
> > +     depends on GCC_VERSION >= 120000 || CLANG_VERSION >= 130000
>
> Are these definitely the versions you want to support?
> What are the earliest (upstream) versions that support the frozen
> version of the vector spec?
It is 14 for clang and 2.38 for GNU binutils
>
> Also, please copy what has been done with "TOOLCHAIN_HAS_FOO" for other
> extensions and check this support with cc-option instead. Similarly,
Yes, updating it.
> you'll need to gate this support on the linker being capable of
> accepting vector:
> /stuff/toolchains/gcc-11/bin/riscv64-unknown-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_f2p0_d2p0_c2p0_v1p0_zihintpause2p0_zve32f1p0_zve32x1p0_zve64d1p0_zve64f1p0_zve64x1p0_zvl128b1p0_zvl32b1p0_zvl64b1p0: prefixed ISA extension must separate with _
> /stuff/toolchains/gcc-11/bin/riscv64-unknown-linux-gnu-ld: failed to merge target specific data of file arch/riscv/kernel/vdso/vgettimeofday.o
>
> > +     default n
>
> I forget, but is the reason for this being default n, when the others
> are default y a conscious choice?
Yes, I think it could be y if V is allocated in the first-use trap, as
far as I'm concerned. Hey Vineet, do you have any comments about that?
> I'm a bit of a goldfish sometimes memory wise, and I don't remember if
> that was an outcome of the previous discussions.
> If it is intentionally different, that needs to be in the changelog IMO.
>
> > +     help
> > +       Say N here if you want to disable all vector related procedure
> > +       in the kernel.
> > +
> > +       If you don't know what to do here, say Y.
> > +
> >  config TOOLCHAIN_HAS_ZICBOM
>
> ^ you can use this one here as an example :)
Ok! Thanks
>
> I'll reply here again once the patchwork automation has given the series
> a once over and see if it comes up with any other build issues.
> Thanks,
> Conor.
>
Thanks,
Andy
