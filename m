Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335406A3F5A
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 11:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjB0KTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 05:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjB0KTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 05:19:08 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F5A7697
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 02:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1677493146; x=1709029146;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sojdSkzgAlSHlPcxfvTgJuh5oLl0x4fCBeR1P4DYod0=;
  b=0RAQqZqm7k/xrH0h5qkk9Y5bvZSPXFVvp9buS80VxtaTdCy57bUvMFTN
   jXCqK+935i1l8zG/9HTknPtk90aESP2hhTEwWU8vi64SOAqdoMp/Po3iU
   pO/LeNggrIWqLFlUtrlMy44uJ3i56JdabXNbSdbXKAUurpdU2HEkwlCnQ
   qrIwkARJ6guijkXcjGvgmX+huypqpVuZ+XQ+cd6gerdZKf+V03mSoEDr5
   zUNHvEoT30p9jOQ1Od7FfGxAYmBoh8ey0pHmgByew+Eb/vpZsHM89cxAj
   dYhaZH9UEFCTh8wM+40IFXAsgLAO+IqKnNtWZc+2+c6qwJkVRb9ple1QX
   g==;
X-IronPort-AV: E=Sophos;i="5.97,331,1669100400"; 
   d="asc'?scan'208";a="139211448"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Feb 2023 03:19:05 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 03:19:03 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Mon, 27 Feb 2023 03:19:01 -0700
Date:   Mon, 27 Feb 2023 10:18:34 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Andy Chiu <andy.chiu@sifive.com>
CC:     <linux-riscv@lists.infradead.org>, <palmer@dabbelt.com>,
        <anup@brainfault.org>, <atishp@atishpatra.org>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <vineetg@rivosinc.com>, <greentime.hu@sifive.com>,
        <guoren@linux.alibaba.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH -next v14 19/19] riscv: Enable Vector code to be built
Message-ID: <Y/yDeurep0ZBnLdR@wendy>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-20-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1gdVvARvsfu9C4N3"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-20-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--1gdVvARvsfu9C4N3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Andy,

On Fri, Feb 24, 2023 at 05:01:18PM +0000, Andy Chiu wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
>=20
> This patch adds a config which enables vector feature from the kernel
> space.
>=20
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
> Suggested-by: Atish Patra <atishp@atishpatra.org>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

At this point, you've basically re-written this patch and should be
listed as a co-author at the very least!

> ---
>  arch/riscv/Kconfig  | 18 ++++++++++++++++++
>  arch/riscv/Makefile |  3 ++-
>  2 files changed, 20 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 81eb031887d2..19deeb3bb36b 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -418,6 +418,24 @@ config RISCV_ISA_SVPBMT
> =20
>  	   If you don't know what to do here, say Y.
> =20
> +config TOOLCHAIN_HAS_V
> +	bool
> +	default y
> +	depends on !64BIT || $(cc-option,-mabi=3Dlp64 -march=3Drv64iv)
> +	depends on !32BIT || $(cc-option,-mabi=3Dilp32 -march=3Drv32iv)
> +	depends on LLD_VERSION >=3D 140000 || LD_VERSION >=3D 23800
> +
> +config RISCV_ISA_V
> +	bool "VECTOR extension support"
> +	depends on TOOLCHAIN_HAS_V
> +	select DYNAMIC_SIGFRAME

So, nothing here makes V depend on CONFIG_FPU...

> +	default y
> +	help
> +	  Say N here if you want to disable all vector related procedure
> +	  in the kernel.
> +
> +	  If you don't know what to do here, say Y.
> +
>  config TOOLCHAIN_HAS_ZBB
>  	bool
>  	default y
> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> index 76989561566b..375a048b11cb 100644
> --- a/arch/riscv/Makefile
> +++ b/arch/riscv/Makefile
> @@ -56,6 +56,7 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:=3D rv32ima
>  riscv-march-$(CONFIG_ARCH_RV64I)	:=3D rv64ima
>  riscv-march-$(CONFIG_FPU)		:=3D $(riscv-march-y)fd

=2E..but march only contains fd if CONFIG_FPU is enabled...

>  riscv-march-$(CONFIG_RISCV_ISA_C)	:=3D $(riscv-march-y)c
> +riscv-march-$(CONFIG_RISCV_ISA_V)	:=3D $(riscv-march-y)v
> =20
>  # Newer binutils versions default to ISA spec version 20191213 which mov=
es some
>  # instructions from the I extension to the Zicsr and Zifencei extensions.
> @@ -65,7 +66,7 @@ riscv-march-$(toolchain-need-zicsr-zifencei) :=3D $(ris=
cv-march-y)_zicsr_zifencei
>  # Check if the toolchain supports Zihintpause extension
>  riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE) :=3D $(riscv-march-y)_zi=
hintpause
> =20
> -KBUILD_CFLAGS +=3D -march=3D$(subst fd,,$(riscv-march-y))
> +KBUILD_CFLAGS +=3D -march=3D$(subst fdv,,$(riscv-march-y))

=2E..so I think this will not work if !CONFIG_FPU && RISCV_ISA_V.
IIRC, vector uses some floating point opcodes, but does it (or Linux's
implementation) actually depend on having floating point support in the
kernel?
If not, this cannot be done in a oneliner. Otherwise, CONFIG_RISCV_ISA_V
should explicitly depend on CONFIG_FPU.

>  KBUILD_AFLAGS +=3D -march=3D$(riscv-march-y)
> =20
>  KBUILD_CFLAGS +=3D -mno-save-restore
> --=20
> 2.17.1
>=20
>=20

--1gdVvARvsfu9C4N3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/yDegAKCRB4tDGHoIJi
0i4IAP41YdSGjTqH1QRgMkRLPFQfD7HiWOHOEkYVUdbXjzsq9wEAmGW2shtjgjDR
YeMqZLkAuUwj0SL5IEQRz1gI0B4f0Qk=
=BDSG
-----END PGP SIGNATURE-----

--1gdVvARvsfu9C4N3--
