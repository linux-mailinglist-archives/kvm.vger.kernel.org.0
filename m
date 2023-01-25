Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7AD67BFDA
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 23:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbjAYWYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 17:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjAYWYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 17:24:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD316CA3B
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 14:24:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 788AD6142E
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 22:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D12DC433D2;
        Wed, 25 Jan 2023 22:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674685445;
        bh=3Smre9hQ8LhrSiYVHVRxfH8uc7mGX4apvAk3pyqUt+w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WUpHi/eXfd2xdkVvLMv3dJ/dxAd33pO3g5hAcZYwGxdC+phESA47b+K7CdGfXPO4h
         N8ZjiBbMht5mYjYg8W/PT/8Swlya8izl79PYG6+ZW85aDI8zboEFaKptBdly3BloYQ
         23lo37WoYBIM022gwyGnBXEuTE8fv/bm9vZ30xgDzyI342ulYE1y5UZtFxXZeJPLvE
         hTAclaPeHqrecxihI1HK+WGxggzIVF4E6wo+agjgDAOdoosxWG2InisxoQ1+Yi0yax
         z7RWv3mgutGHwPRxHytffPnyDjZMq5YskFlDuPgmHqXMB8Z5cE8uZDwMqLmExauF8+
         gZn+iOYa6RxQg==
Date:   Wed, 25 Jan 2023 22:24:00 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Jessica Clarke <jrtc27@jrtc27.com>
Cc:     Andy Chiu <andy.chiu@sifive.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Vineet Gupta <vineetg@rivosinc.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH -next v13 19/19] riscv: Enable Vector code to be built
Message-ID: <Y9GsAOPMVX4qGero@spud>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-20-andy.chiu@sifive.com>
 <Y9GZbVrZxEZAraVu@spud>
 <08DF16C6-1D76-4FBE-871C-3A37C5349C87@jrtc27.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eIlcdKBA1YhB0Yws"
Content-Disposition: inline
In-Reply-To: <08DF16C6-1D76-4FBE-871C-3A37C5349C87@jrtc27.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--eIlcdKBA1YhB0Yws
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 25, 2023 at 09:38:00PM +0000, Jessica Clarke wrote:
> On 25 Jan 2023, at 21:04, Conor Dooley <conor@kernel.org> wrote:
> > On Wed, Jan 25, 2023 at 02:20:56PM +0000, Andy Chiu wrote:
> >=20
> >> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> >> index 12d91b0a73d8..67411cdc836f 100644
> >> --- a/arch/riscv/Makefile
> >> +++ b/arch/riscv/Makefile
> >> @@ -52,6 +52,13 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:=3D rv32ima
> >> riscv-march-$(CONFIG_ARCH_RV64I)	:=3D rv64ima
> >> riscv-march-$(CONFIG_FPU)		:=3D $(riscv-march-y)fd
> >> riscv-march-$(CONFIG_RISCV_ISA_C)	:=3D $(riscv-march-y)c
> >> +riscv-march-$(CONFIG_RISCV_ISA_V)	:=3D $(riscv-march-y)v
> >> +
> >> +ifeq ($(CONFIG_RISCV_ISA_V), y)
> >> +ifeq ($(CONFIG_CC_IS_CLANG), y)
> >> +        riscv-march-y +=3D -mno-implicit-float -menable-experimental-=
extensions
> >> +endif
> >> +endif
> >=20
> > Uh, so I don't think this was actually tested with (a recent version of)
> > clang:
> > clang-15: error: unknown argument: '-menable-experimental-extensions_zi=
cbom_zihintpause'
> >=20
> > Firstly, no-implicit-float is a CFLAG, so why add it to march?
> > There is an existing patch on the list for enabling this flag, but I
> > recall Palmer saying that it was not actually needed?
> > Palmer, do you remember why that was?
> >=20
> > I dunno what enable-experimental-extensions is, but I can guess. Do we
> > really want to enable vector for toolchains where the support is
> > considered experimental? I'm not au fait with the details of clang
> > versions nor versions of the Vector spec, so take the following with a
> > bit of a pinch of salt...
> > Since you've allowed this to be built with anything later than clang 13,
> > does that mean that different versions of clang may generate vector code
> > that are not compatible?
> > I'm especially concerned by:
> > https://github.com/riscv/riscv-v-spec/releases/tag/0.9
> > which appears to be most recently released version of the spec, prior to
> > clang/llvm 13 being released.
>=20
> For implementations of unratified extensions you both have to enable
> them with -menable-experimental-extensions and have to explicitly
> specify the version in the -march string specifically so this isn=E2=80=
=99t a
> concern. Only once ratified can you use the unversioned extension,
> which is implicitly the ratified version (ignoring the whole i2p0 vs
> i2p1 fiasco).

Ahh, thanks for the clarification Jess.

> But no, you probably don=E2=80=99t want experimental implementations, whi=
ch can
> exist when the ratified version is implemented in theory (so there=E2=80=
=99s no
> compatibility concern based on ISA changes) but isn=E2=80=99t deemed
> production-ready (e.g. potential ABI instability in the case of
> something like V).

And I guess, if you turn it on for one, it's on for all.
While the vector extension might be okay in that regard, another
extension well not be okay to use the "unversioned" experimental version
of. Sounds like removing that option and picking the version of clang
that adds the actual implementation is a better approach, at least IMO.


--eIlcdKBA1YhB0Yws
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9GsAAAKCRB4tDGHoIJi
0hqFAQC48XA84lz48uhvAtpzLEHeMOU2tUpSJ8GlckABIXQCJwEA3wPARCef7sAh
co6sjKqf4Skq3blkPVYO104tRYo0AAc=
=bxFQ
-----END PGP SIGNATURE-----

--eIlcdKBA1YhB0Yws--
