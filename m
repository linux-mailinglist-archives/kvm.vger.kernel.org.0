Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235AA6C6C42
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 16:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbjCWP0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 11:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjCWP0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 11:26:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5D42331C
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679585200; x=1711121200;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=86yrhXo0wuZkXMT9LRZ/k4xl+d7WKjf/eV20kO0UvSc=;
  b=Fr/1ukIJPX4nCowte0l7lQqxvzhPLygMrb74xrWwJvv34B4e9soLMJbX
   SYA1MoYPUHiIklLr4D3VaW2sLaoU30pMOeOdsYQn28UHxgqL/AWHigl2V
   XqRKvlzfofWe6uCerbbaKZchpBaaSeQFcnBQEg9s8rHTvGGek/xaCBfcL
   uQ4fpxRW0/1dLdS/ouxc6DtBpdbcCUylglPI8b4hdiyrK+1QwRmY41Chm
   SC++Yz0nhK5o2/JAy0lr2pbTDs7uc/SsD+rOCdBrzZaQP1Wfj5SldFZSV
   cY2Bu7TVxn8ijRbTVpF2lqf+un4du222fVQDr1K+sCkBxV3BBWkAISSm1
   w==;
X-IronPort-AV: E=Sophos;i="5.98,285,1673938800"; 
   d="asc'?scan'208";a="203103645"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Mar 2023 08:26:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 08:26:35 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 23 Mar 2023 08:26:32 -0700
Date:   Thu, 23 Mar 2023 15:26:14 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Andy Chiu <andy.chiu@sifive.com>
CC:     <linux-riscv@lists.infradead.org>, <palmer@dabbelt.com>,
        <anup@brainfault.org>, <atishp@atishpatra.org>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <vineetg@rivosinc.com>, <greentime.hu@sifive.com>,
        <guoren@linux.alibaba.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: Re: [PATCH -next v16 19/20] riscv: detect assembler support for
 .option arch
Message-ID: <04cc3420-26a7-4263-b120-677c758eabea@spud>
References: <20230323145924.4194-1-andy.chiu@sifive.com>
 <20230323145924.4194-20-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Yj+/LCxZH129o5eE"
Content-Disposition: inline
In-Reply-To: <20230323145924.4194-20-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Yj+/LCxZH129o5eE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 23, 2023 at 02:59:23PM +0000, Andy Chiu wrote:
> Some extensions use .option arch directive to selectively enable certain
> extensions in parts of its assembly code. For example, Zbb uses it to
> inform assmebler to emit bit manipulation instructions. However,
> supporting of this directive only exist on GNU assembler and has not
> landed on clang at the moment, making TOOLCHAIN_HAS_ZBB depend on
> AS_IS_GNU.
>=20
> While it is still under review at https://reviews.llvm.org/D123515, the
> upcoming Vector patch also requires this feature in assembler. Thus,
> provide Kconfig AS_HAS_OPTION_ARCH to detect such feature. Then
> TOOLCHAIN_HAS_XXX will be turned on automatically when the feature land.
>=20
> Suggested-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
>  arch/riscv/Kconfig | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 36a5b6fed0d3..4f8fd4002f1d 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -244,6 +244,12 @@ config RISCV_DMA_NONCOHERENT
>  config AS_HAS_INSN
>  	def_bool $(as-instr,.insn r 51$(comma) 0$(comma) 0$(comma) t0$(comma) t=
0$(comma) zero)
> =20
> +config AS_HAS_OPTION_ARCH
> +	# https://reviews.llvm.org/D123515
> +	def_bool y
> +	depends on $(as-instr, .option arch$(comma) +m)
> +	depends on !$(as-instr, .option arch$(comma) -i)

Oh cool, I didn't expect this to work given what Nathan said in his
mail, but I gave it a whirl and it does seem to.
I suppose:
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

I'd rather it be this way so that it is "hands off", as opposed to the
version check that would need updating in the future. And I guess it
means that support for V & IAS will automatically turn on for stable
kernels too once the LLVM change lands, which is nice ;)

Thanks Andy!

> +
>  source "arch/riscv/Kconfig.socs"
>  source "arch/riscv/Kconfig.errata"
> =20
> @@ -442,7 +448,7 @@ config TOOLCHAIN_HAS_ZBB
>  	depends on !64BIT || $(cc-option,-mabi=3Dlp64 -march=3Drv64ima_zbb)
>  	depends on !32BIT || $(cc-option,-mabi=3Dilp32 -march=3Drv32ima_zbb)
>  	depends on LLD_VERSION >=3D 150000 || LD_VERSION >=3D 23900
> -	depends on AS_IS_GNU
> +	depends on AS_HAS_OPTION_ARCH
> =20
>  config RISCV_ISA_ZBB
>  	bool "Zbb extension support for bit manipulation instructions"
> --=20
> 2.17.1
>=20
>=20

--Yj+/LCxZH129o5eE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBxvlgAKCRB4tDGHoIJi
0uljAP0QSmWLx9NqoMEEU7pnQbE6zzkqpFQ5YjbqmKh316V3zwD/enaTKpjMwAaq
HMvtUIntHRWG0phcQM9GLmnilJBSlQk=
=byEg
-----END PGP SIGNATURE-----

--Yj+/LCxZH129o5eE--
