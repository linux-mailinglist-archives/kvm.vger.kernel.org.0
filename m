Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACF16A73B9
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 19:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjCASox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 13:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjCASos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 13:44:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21A42D175
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 10:44:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DA72B81023
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 18:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02A5C433D2;
        Wed,  1 Mar 2023 18:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677696284;
        bh=G9AkJ6//uTGDoR5bgmBlp3xFgIA9EgvmfqcVSo26mbk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OS1tvCKYbiz/S4Uz2iYuT2o9tAIjNyG0HBO0Pd2OI7OWKiY2XHPDeNZWaq3SWxtbo
         LwM1I4E9MVY3tNvHv5gWLpJWf5zvRwfnWqnTYMdGrPL6SDcv4iD8mh/+ek3ys9zGe6
         dqwc7ioCprCARD8szCm8ulJG3481pnOlAIABaLay7UKgbvW0rAhxK1q41QdtyHSnab
         CWn9X1cxHAYPOy3zPVj0if/XuLwvSPLrQSmbX5wGnxpJGzFUUaAATgXYK824Q7Tmtz
         AZzevICGhsLX7/cjeymT1xMD28iB3Stfh/Z9SjyTs5vG6aq9CzU02Yqa4sBg+cRZo2
         Pl8FCepvDT2Ng==
Date:   Wed, 1 Mar 2023 18:44:38 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH -next v14 19/19] riscv: Enable Vector code to be built
Message-ID: <Y/+dFpdbOdLRUmY5@spud>
References: <20230224170118.16766-20-andy.chiu@sifive.com>
 <202302250924.ukv4ZxOc-lkp@intel.com>
 <Y/+SoGfspjGwlH7g@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3AJ2nIKwr1Cl4KTp"
Content-Disposition: inline
In-Reply-To: <Y/+SoGfspjGwlH7g@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--3AJ2nIKwr1Cl4KTp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 01, 2023 at 11:00:00AM -0700, Nathan Chancellor wrote:
> Hi Andy,
>=20
> On Sat, Feb 25, 2023 at 09:33:30AM +0800, kernel test robot wrote:
> > Hi Andy,
> >=20
> > I love your patch! Perhaps something to improve:
> >=20
> > [auto build test WARNING on next-20230224]
> >=20
> > url:    https://github.com/intel-lab-lkp/linux/commits/Andy-Chiu/riscv-=
Rename-__switch_to_aux-fpu/20230225-011059
> > patch link:    https://lore.kernel.org/r/20230224170118.16766-20-andy.c=
hiu%40sifive.com
> > patch subject: [PATCH -next v14 19/19] riscv: Enable Vector code to be =
built
> > config: riscv-randconfig-r014-20230222 (https://download.01.org/0day-ci=
/archive/20230225/202302250924.ukv4ZxOc-lkp@intel.com/config)
> > compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project db=
89896bbbd2251fff457699635acbbedeead27f)
> > reproduce (this is a W=3D1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/s=
bin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # install riscv cross compiling tool for clang build
> >         # apt-get install binutils-riscv64-linux-gnu
> >         # https://github.com/intel-lab-lkp/linux/commit/cd0ad21a9ef9d63=
f1eef80fd3b09ae6e0d884ce3
> >         git remote add linux-review https://github.com/intel-lab-lkp/li=
nux
> >         git fetch --no-tags linux-review Andy-Chiu/riscv-Rename-__switc=
h_to_aux-fpu/20230225-011059
> >         git checkout cd0ad21a9ef9d63f1eef80fd3b09ae6e0d884ce3
> >         # save the config file
> >         mkdir build_dir && cp config build_dir/.config
> >         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross =
W=3D1 O=3Dbuild_dir ARCH=3Driscv olddefconfig
> >         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross =
W=3D1 O=3Dbuild_dir ARCH=3Driscv SHELL=3D/bin/bash lib/zstd/
> >=20
> > If you fix the issue, kindly add following tag where applicable
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Link: https://lore.kernel.org/oe-kbuild-all/202302250924.ukv4ZxOc-lkp=
@intel.com/
> >=20
> > All warnings (new ones prefixed by >>):
> >=20
> > >> warning: Invalid size request on a scalable vector; Cannot implicitl=
y convert a scalable size to a fixed-width size in `TypeSize::operator Scal=
arTy()`
>=20
> Please consider adding the following diff to patch 19 to avoid this
> issue (see the upstream bug report for more details):
>=20
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index eb691dd8ee4f..187cd6c1d8c9 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -423,6 +423,8 @@ config TOOLCHAIN_HAS_V
>  	depends on !64BIT || $(cc-option,-mabi=3Dlp64 -march=3Drv64iv)
>  	depends on !32BIT || $(cc-option,-mabi=3Dilp32 -march=3Drv32iv)
>  	depends on LLD_VERSION >=3D 140000 || LD_VERSION >=3D 23800
> +	# https://github.com/llvm/llvm-project/issues/61096
> +	depends on !(CC_IS_CLANG && CLANG_VERSION >=3D 160000 && KASAN)

Please don't! As far as I can tell, this is what I was warning about in:
https://lore.kernel.org/linux-riscv/20230224170118.16766-1-andy.chiu@sifive=
=2Ecom/T/#m2c0e6128230d407c843e10406305da9ff5dca902

The randconfig has RISCV_ISA_C enabled, so you're getting an ISA string
containing "fdcv" and `fdv,,$(riscv-march-y)` fails to remove either fd,
or v.

The below is very much valid though, please test v15 with clang/llvm
Andy!

> Additionally, with older versions of clang 15.x and older, I see:
>=20
>   arch/riscv/kernel/vector.c:50:3: error: expected expression
>                   u32 width =3D RVV_EXRACT_VL_VS_WIDTH(insn_buf);
>                   ^
>   arch/riscv/kernel/vector.c:52:7: error: use of undeclared identifier 'w=
idth'
>                   if (width =3D=3D RVV_VL_VS_WIDTH_8 || width =3D=3D RVV_=
VL_VS_WIDTH_16 ||
>                       ^
>   arch/riscv/kernel/vector.c:52:37: error: use of undeclared identifier '=
width'
>                   if (width =3D=3D RVV_VL_VS_WIDTH_8 || width =3D=3D RVV_=
VL_VS_WIDTH_16 ||
>                                                     ^
>   arch/riscv/kernel/vector.c:53:7: error: use of undeclared identifier 'w=
idth'
>                       width =3D=3D RVV_VL_VS_WIDTH_32 || width =3D=3D RVV=
_VL_VS_WIDTH_64)
>                       ^
>   arch/riscv/kernel/vector.c:53:38: error: use of undeclared identifier '=
width'
>                       width =3D=3D RVV_VL_VS_WIDTH_32 || width =3D=3D RVV=
_VL_VS_WIDTH_64)
>                                                      ^
>   arch/riscv/kernel/vector.c:57:3: error: expected expression
>                   u32 csr =3D RVG_EXTRACT_SYSTEM_CSR(insn_buf);
>                   ^
>   arch/riscv/kernel/vector.c:59:8: error: use of undeclared identifier 'c=
sr'
>                   if ((csr >=3D CSR_VSTART && csr <=3D CSR_VCSR) ||
>                        ^
>   arch/riscv/kernel/vector.c:59:29: error: use of undeclared identifier '=
csr'
>                   if ((csr >=3D CSR_VSTART && csr <=3D CSR_VCSR) ||
>                                             ^
>   arch/riscv/kernel/vector.c:60:8: error: use of undeclared identifier 'c=
sr'
>                       (csr >=3D CSR_VL && csr <=3D CSR_VLENB))
>                        ^
>   arch/riscv/kernel/vector.c:60:25: error: use of undeclared identifier '=
csr'
>                       (csr >=3D CSR_VL && csr <=3D CSR_VLENB))
>                                         ^
>   10 errors generated.
>=20
> which is fixed by:
>=20
> diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
> index 585e2c51b28e..8c98db9c0ae1 100644
> --- a/arch/riscv/kernel/vector.c
> +++ b/arch/riscv/kernel/vector.c
> @@ -46,14 +46,15 @@ static bool insn_is_vector(u32 insn_buf)
>  		is_vector =3D true;
>  		break;
>  	case RVV_OPCODE_VL:
> -	case RVV_OPCODE_VS:
> +	case RVV_OPCODE_VS: {
>  		u32 width =3D RVV_EXRACT_VL_VS_WIDTH(insn_buf);
> =20
>  		if (width =3D=3D RVV_VL_VS_WIDTH_8 || width =3D=3D RVV_VL_VS_WIDTH_16 =
||
>  		    width =3D=3D RVV_VL_VS_WIDTH_32 || width =3D=3D RVV_VL_VS_WIDTH_64)
>  			is_vector =3D true;
>  		break;
> -	case RVG_OPCODE_SYSTEM:
> +	}
> +	case RVG_OPCODE_SYSTEM: {
>  		u32 csr =3D RVG_EXTRACT_SYSTEM_CSR(insn_buf);
> =20
>  		if ((csr >=3D CSR_VSTART && csr <=3D CSR_VCSR) ||
> @@ -61,6 +62,7 @@ static bool insn_is_vector(u32 insn_buf)
>  			is_vector =3D true;
>  		break;
>  	}
> +	}
>  	return is_vector;
>  }
> =20
> ---
>=20
> Cheers,
> Nathan

--3AJ2nIKwr1Cl4KTp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/+dFgAKCRB4tDGHoIJi
0l+8AQDiMiLdgkWVTVkHqZiXBKBOneufFmTinIodVbJkus+2YQEA5fLZb8tDSC0L
hcGpOcVINQsRdQCiAZWKkeL6WV5oQQ8=
=Vdb2
-----END PGP SIGNATURE-----

--3AJ2nIKwr1Cl4KTp--
