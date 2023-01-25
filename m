Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0833C67BD99
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 22:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbjAYVEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 16:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbjAYVEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 16:04:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F0223674
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 13:04:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3156F615E6
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 21:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7DAC433D2;
        Wed, 25 Jan 2023 21:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674680690;
        bh=5XgIUsKQQfnJqmrJCF1Ci6vFUC+8ejjb8Ltko66AhdE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nj1pO4t16aTOFuGuZ7TSeefZfsF8eqqi44PedPJ5/hJf45UnJzobGr+D7VnlO85AJ
         Ded5+078L02E5qvIHARMMPCN79F6DRhz9u9mC+8a1b+u37npcELVAJVhJvax0/b9iV
         sNWFPCR3i43WjhvCi27BxeiO/ydEkzP35sapJgkj2V3CUgxYiQW9mhqbzqXYWkIMs4
         Ss2yD0ivce40sRHbaSka3/KnovHZBt23pWEekz7bQgy4q8gbAQqdy5SQO/13MBr3BN
         JXZABfSmVduBbnX0yiE0X7XE4o+qb72nv8kstxe+l06+XoAHJZMivz1kLHOHknf1T4
         xbyEuyC6MLBXA==
Date:   Wed, 25 Jan 2023 21:04:45 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH -next v13 19/19] riscv: Enable Vector code to be built
Message-ID: <Y9GZbVrZxEZAraVu@spud>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-20-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lkDM2IpOgivVn4g+"
Content-Disposition: inline
In-Reply-To: <20230125142056.18356-20-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--lkDM2IpOgivVn4g+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Andy,

Thanks for respinning this, I think a lot of people will be happy to see
it!

On Wed, Jan 25, 2023 at 02:20:56PM +0000, Andy Chiu wrote:

> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> index 12d91b0a73d8..67411cdc836f 100644
> --- a/arch/riscv/Makefile
> +++ b/arch/riscv/Makefile
> @@ -52,6 +52,13 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:=3D rv32ima
>  riscv-march-$(CONFIG_ARCH_RV64I)	:=3D rv64ima
>  riscv-march-$(CONFIG_FPU)		:=3D $(riscv-march-y)fd
>  riscv-march-$(CONFIG_RISCV_ISA_C)	:=3D $(riscv-march-y)c
> +riscv-march-$(CONFIG_RISCV_ISA_V)	:=3D $(riscv-march-y)v
> +
> +ifeq ($(CONFIG_RISCV_ISA_V), y)
> +ifeq ($(CONFIG_CC_IS_CLANG), y)
> +        riscv-march-y +=3D -mno-implicit-float -menable-experimental-ext=
ensions
> +endif
> +endif

Uh, so I don't think this was actually tested with (a recent version of)
clang:
clang-15: error: unknown argument: '-menable-experimental-extensions_zicbom=
_zihintpause'

Firstly, no-implicit-float is a CFLAG, so why add it to march?
There is an existing patch on the list for enabling this flag, but I
recall Palmer saying that it was not actually needed?
Palmer, do you remember why that was?

I dunno what enable-experimental-extensions is, but I can guess. Do we
really want to enable vector for toolchains where the support is
considered experimental? I'm not au fait with the details of clang
versions nor versions of the Vector spec, so take the following with a
bit of a pinch of salt...
Since you've allowed this to be built with anything later than clang 13,
does that mean that different versions of clang may generate vector code
that are not compatible?
I'm especially concerned by:
https://github.com/riscv/riscv-v-spec/releases/tag/0.9
which appears to be most recently released version of the spec, prior to
clang/llvm 13 being released.

> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index e2b656043abf..f4299ba9a843 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -416,6 +416,16 @@ config RISCV_ISA_SVPBMT
> =20
>  	   If you don't know what to do here, say Y.
> =20
> +config RISCV_ISA_V
> +	bool "VECTOR extension support"
> +	depends on GCC_VERSION >=3D 120000 || CLANG_VERSION >=3D 130000

Are these definitely the versions you want to support?
What are the earliest (upstream) versions that support the frozen
version of the vector spec?

Also, please copy what has been done with "TOOLCHAIN_HAS_FOO" for other
extensions and check this support with cc-option instead. Similarly,
you'll need to gate this support on the linker being capable of
accepting vector:
/stuff/toolchains/gcc-11/bin/riscv64-unknown-linux-gnu-ld: -march=3Drv64i2p=
0_m2p0_a2p0_f2p0_d2p0_c2p0_v1p0_zihintpause2p0_zve32f1p0_zve32x1p0_zve64d1p=
0_zve64f1p0_zve64x1p0_zvl128b1p0_zvl32b1p0_zvl64b1p0: prefixed ISA extensio=
n must separate with _
/stuff/toolchains/gcc-11/bin/riscv64-unknown-linux-gnu-ld: failed to merge =
target specific data of file arch/riscv/kernel/vdso/vgettimeofday.o

> +	default n

I forget, but is the reason for this being default n, when the others
are default y a conscious choice?
I'm a bit of a goldfish sometimes memory wise, and I don't remember if
that was an outcome of the previous discussions.
If it is intentionally different, that needs to be in the changelog IMO.

> +	help
> +	  Say N here if you want to disable all vector related procedure
> +	  in the kernel.
> +
> +	  If you don't know what to do here, say Y.
> +
>  config TOOLCHAIN_HAS_ZICBOM

^ you can use this one here as an example :)

I'll reply here again once the patchwork automation has given the series
a once over and see if it comes up with any other build issues.
Thanks,
Conor.


--lkDM2IpOgivVn4g+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9GZbQAKCRB4tDGHoIJi
0vxmAQC/ka5xvUwWRzYCMdL2d95EkAC0HKbR302kC5upl5J6owEAlSoDmFq8aDwQ
55BjL9+qD28qiZowz0+jc9GBpGCDYwE=
=bYeS
-----END PGP SIGNATURE-----

--lkDM2IpOgivVn4g+--
