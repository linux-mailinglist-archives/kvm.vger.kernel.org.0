Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECB96CBFE9
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 14:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjC1M42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 08:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbjC1M4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 08:56:24 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E25597
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 05:56:18 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id y35so9930442ljq.4
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 05:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1680008177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pY8KWhN7SgpHmmDG69ixmsCEWsblRlF4c4Kuf0LRZ4U=;
        b=STHNi84isxh9ZXSer5QGVBlpqodlAQv0aIEc4KQcUqTrufjvjQVc+2doCTXNCia7Ix
         e1tOqVdR5NrkSw4zTdv2ha6SFxiPDGLUJOVJAfqx4rZIOymKps7d13/mKDAm+mrtFOfg
         uVsZLQwNmGOKNDmr9A7KqKU67ictliVieIsf2s6xgwH0JtS0/zF2I7xz96K+cNFjeLRL
         EGyNuv+7dDZ86RVC6+QZ93T7c39pebwFXWCa+/1c+v/DOHvDjg8Q2YsIyZ3CFFY5gB/Q
         szyRDTuAxBiCWToyCrU+y+KiPkVibQ+vGGyPKGp1ZAF+z+UcHQZjYD91YlV03XtQgw/Z
         dsAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680008177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pY8KWhN7SgpHmmDG69ixmsCEWsblRlF4c4Kuf0LRZ4U=;
        b=miuOUX1BsF8zh/hGqzJ8TK/AekYoupT0EKlvNn3um8CJyjzHkV1lahQejl1wA2qjpZ
         v+w/RUB8OVSIux04cHFJzo1++iNG5UNPXS5z4Pu2rl7TjUUBVYmQBdyi37vc60fjWhQo
         chEDXWpmWtuPDJPKE47FOPoORFpIesQn7NO5WoVOCVskW6qICNttcPZFyfEzTdorTani
         0ySSe3dnrtc54oJbOX0spkn7FAGYCcqVf5RiwiK3ZMaZUovvOFYNJOIihMqPTdx5x0nH
         dgX/yz0S/+AyNmTHr7Cb1oynvoUOI2PI4qbpwEG28ofVn/I0O+17VJCePGhDe/YiXf2+
         MVdw==
X-Gm-Message-State: AAQBX9fYkGfW42PoNEv8QBEk5wzlf9MJA8bjemkm6tgJQF0B9xJ+pN6j
        bhsk5fTCZK3Oc9JQPLC5YOD3xDyxZ6xKT80aGy+YdA==
X-Google-Smtp-Source: AKy350Y74Cl5niSL3xTzg6tRDS+C5dIVCvZ2/zCM7y3SdsWuQ+2kXtftzH5czZ368jHKUBzow/GXJOMb2pFvL1m9Gbo=
X-Received: by 2002:a2e:a175:0:b0:29c:8a14:74e6 with SMTP id
 u21-20020a2ea175000000b0029c8a1474e6mr4797617ljl.0.1680008177123; Tue, 28 Mar
 2023 05:56:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230323145924.4194-1-andy.chiu@sifive.com> <20230323145924.4194-20-andy.chiu@sifive.com>
 <04cc3420-26a7-4263-b120-677c758eabea@spud> <20230324145934.GB428955@dev-arch.thelio-3990X>
In-Reply-To: <20230324145934.GB428955@dev-arch.thelio-3990X>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Tue, 28 Mar 2023 20:55:00 +0800
Message-ID: <CABgGipWr8y-Of=brW2=_yiGb6EYu=b7FfXxF0sEkU=9xQ=11aA@mail.gmail.com>
Subject: Re: [PATCH -next v16 19/20] riscv: detect assembler support for
 .option arch
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 24, 2023 at 10:59=E2=80=AFPM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> On Thu, Mar 23, 2023 at 03:26:14PM +0000, Conor Dooley wrote:
> > On Thu, Mar 23, 2023 at 02:59:23PM +0000, Andy Chiu wrote:
> > > Some extensions use .option arch directive to selectively enable cert=
ain
> > > extensions in parts of its assembly code. For example, Zbb uses it to
> > > inform assmebler to emit bit manipulation instructions. However,
> > > supporting of this directive only exist on GNU assembler and has not
> > > landed on clang at the moment, making TOOLCHAIN_HAS_ZBB depend on
> > > AS_IS_GNU.
> > >
> > > While it is still under review at https://reviews.llvm.org/D123515, t=
he
> > > upcoming Vector patch also requires this feature in assembler. Thus,
> > > provide Kconfig AS_HAS_OPTION_ARCH to detect such feature. Then
> > > TOOLCHAIN_HAS_XXX will be turned on automatically when the feature la=
nd.
> > >
> > > Suggested-by: Nathan Chancellor <nathan@kernel.org>
> > > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > > ---
> > >  arch/riscv/Kconfig | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > > index 36a5b6fed0d3..4f8fd4002f1d 100644
> > > --- a/arch/riscv/Kconfig
> > > +++ b/arch/riscv/Kconfig
> > > @@ -244,6 +244,12 @@ config RISCV_DMA_NONCOHERENT
> > >  config AS_HAS_INSN
> > >     def_bool $(as-instr,.insn r 51$(comma) 0$(comma) 0$(comma) t0$(co=
mma) t0$(comma) zero)
> > >
> > > +config AS_HAS_OPTION_ARCH
> > > +   # https://reviews.llvm.org/D123515
> > > +   def_bool y
> > > +   depends on $(as-instr, .option arch$(comma) +m)
> > > +   depends on !$(as-instr, .option arch$(comma) -i)
> >
> > Oh cool, I didn't expect this to work given what Nathan said in his
> > mail, but I gave it a whirl and it does seem to.
>
> The second line is the clever part of this option that I had not
> considered, as it checks for something that should error in addition to
> something that shouldn't::
>
> $ echo '.option arch, -i' | riscv64-linux-gcc -c -o /dev/null -x assemble=
r -
> {standard input}: Assembler messages:
> {standard input}:1: Error: cannot + or - base extension `i' in .option ar=
ch `-i'
>
> Looking at D123515, I see this same option test is present and appears
> to error in the same manner so this should work when that change is
> merged.

Thanks for checking D123515 Nathan. It was just lucky that It gets the
same test coverage in Clang. I would take a look at that aspect in the
future if the same happens.

>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
>
> > I suppose:
> > Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> >
> > I'd rather it be this way so that it is "hands off", as opposed to the
> > version check that would need updating in the future. And I guess it
> > means that support for V & IAS will automatically turn on for stable
> > kernels too once the LLVM change lands, which is nice ;)
>
> Very much agreed!
>
> > Thanks Andy!
> >
> > > +
> > >  source "arch/riscv/Kconfig.socs"
> > >  source "arch/riscv/Kconfig.errata"
> > >
> > > @@ -442,7 +448,7 @@ config TOOLCHAIN_HAS_ZBB
> > >     depends on !64BIT || $(cc-option,-mabi=3Dlp64 -march=3Drv64ima_zb=
b)
> > >     depends on !32BIT || $(cc-option,-mabi=3Dilp32 -march=3Drv32ima_z=
bb)
> > >     depends on LLD_VERSION >=3D 150000 || LD_VERSION >=3D 23900
> > > -   depends on AS_IS_GNU
> > > +   depends on AS_HAS_OPTION_ARCH
> > >
> > >  config RISCV_ISA_ZBB
> > >     bool "Zbb extension support for bit manipulation instructions"
> > > --
> > > 2.17.1
> > >
> > >
>
>

Regards,
Andy
