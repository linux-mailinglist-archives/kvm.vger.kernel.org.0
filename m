Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8F86A438E
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 14:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjB0N7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 08:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjB0N7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 08:59:37 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB82EB43
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 05:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1677506368; x=1709042368;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=v6O37f445n4RLV5R6biUlsJ/PrWMXyEC/3FIJ00LLK0=;
  b=HBy90/xf4bcmV9RFMtNa5WblFUProXwazaU+SEsX+wOs9OeX78ZnOeFe
   Um8xFBE0GYytNylm1Qgt1zUAhM8SEJmtkwyNePJJf2pu9In2dPyKKLePf
   /cuoj57/Wkbqm74wWpSMF16cmlgTB2OmS5wTiq21k12rMr1tGqmuZztBb
   +t97FFzkIUfid6tkGwxPa7j4+DBxEBwvrGkhdXym+VJTKEAsx4dOzHTSt
   PQTcs9zJo8os1lMJ+t6bYDGLGn+msisSf9noLo/PlZ3vp+0fzh30Bp7EU
   +77Lqp5OiC3JNEQkOBlP3cxhHMykA+zrQxLoPNEc/Shb+24RfujMK9w5U
   g==;
X-IronPort-AV: E=Sophos;i="5.98,332,1673938800"; 
   d="asc'?scan'208";a="198933742"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Feb 2023 06:59:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 06:59:22 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Mon, 27 Feb 2023 06:59:20 -0700
Date:   Mon, 27 Feb 2023 13:58:53 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Andy Chiu <andy.chiu@sifive.com>,
        <linux-riscv@lists.infradead.org>, <palmer@dabbelt.com>,
        <anup@brainfault.org>, <atishp@atishpatra.org>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <vineetg@rivosinc.com>, <greentime.hu@sifive.com>,
        <guoren@linux.alibaba.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH -next v14 19/19] riscv: Enable Vector code to be built
Message-ID: <Y/y3HbZJa8zQwivc@wendy>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-20-andy.chiu@sifive.com>
 <Y/yDeurep0ZBnLdR@wendy>
 <Y/yy3sDX2AxvBD0f@bruce.bluespec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NHHGYGTcCF3WT1JP"
Content-Disposition: inline
In-Reply-To: <Y/yy3sDX2AxvBD0f@bruce.bluespec.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--NHHGYGTcCF3WT1JP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 27, 2023 at 08:40:46AM -0500, Darius Rad wrote:
> On Mon, Feb 27, 2023 at 10:18:34AM +0000, Conor Dooley wrote:
> > On Fri, Feb 24, 2023 at 05:01:18PM +0000, Andy Chiu wrote:
> > > From: Guo Ren <guoren@linux.alibaba.com>
> > >=20
> > > This patch adds a config which enables vector feature from the kernel
> > > space.
> > >=20
> > > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> > > Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
> > > Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> > > Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
> > > Suggested-by: Atish Patra <atishp@atishpatra.org>
> > > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> >=20
> > At this point, you've basically re-written this patch and should be
> > listed as a co-author at the very least!
> >=20
> > > ---
> > >  arch/riscv/Kconfig  | 18 ++++++++++++++++++
> > >  arch/riscv/Makefile |  3 ++-
> > >  2 files changed, 20 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > > index 81eb031887d2..19deeb3bb36b 100644
> > > --- a/arch/riscv/Kconfig
> > > +++ b/arch/riscv/Kconfig
> > > @@ -418,6 +418,24 @@ config RISCV_ISA_SVPBMT
> > > =20
> > >  	   If you don't know what to do here, say Y.
> > > =20
> > > +config TOOLCHAIN_HAS_V
> > > +	bool
> > > +	default y
> > > +	depends on !64BIT || $(cc-option,-mabi=3Dlp64 -march=3Drv64iv)
> > > +	depends on !32BIT || $(cc-option,-mabi=3Dilp32 -march=3Drv32iv)
> > > +	depends on LLD_VERSION >=3D 140000 || LD_VERSION >=3D 23800
> > > +
> > > +config RISCV_ISA_V
> > > +	bool "VECTOR extension support"
> > > +	depends on TOOLCHAIN_HAS_V
> > > +	select DYNAMIC_SIGFRAME
> >=20
> > So, nothing here makes V depend on CONFIG_FPU...
> >=20
> > > +	default y
> > > +	help
> > > +	  Say N here if you want to disable all vector related procedure
> > > +	  in the kernel.
> > > +
> > > +	  If you don't know what to do here, say Y.
> > > +
> > >  config TOOLCHAIN_HAS_ZBB
> > >  	bool
> > >  	default y
> > > diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> > > index 76989561566b..375a048b11cb 100644
> > > --- a/arch/riscv/Makefile
> > > +++ b/arch/riscv/Makefile
> > > @@ -56,6 +56,7 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:=3D rv32ima
> > >  riscv-march-$(CONFIG_ARCH_RV64I)	:=3D rv64ima
> > >  riscv-march-$(CONFIG_FPU)		:=3D $(riscv-march-y)fd
> >=20
> > ...but march only contains fd if CONFIG_FPU is enabled...
> >=20
> > >  riscv-march-$(CONFIG_RISCV_ISA_C)	:=3D $(riscv-march-y)c
> > > +riscv-march-$(CONFIG_RISCV_ISA_V)	:=3D $(riscv-march-y)v
> > > =20
> > >  # Newer binutils versions default to ISA spec version 20191213 which=
 moves some
> > >  # instructions from the I extension to the Zicsr and Zifencei extens=
ions.
> > > @@ -65,7 +66,7 @@ riscv-march-$(toolchain-need-zicsr-zifencei) :=3D $=
(riscv-march-y)_zicsr_zifencei
> > >  # Check if the toolchain supports Zihintpause extension
> > >  riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE) :=3D $(riscv-march-y=
)_zihintpause
> > > =20
> > > -KBUILD_CFLAGS +=3D -march=3D$(subst fd,,$(riscv-march-y))
> > > +KBUILD_CFLAGS +=3D -march=3D$(subst fdv,,$(riscv-march-y))
> >=20
> > ...so I think this will not work if !CONFIG_FPU && RISCV_ISA_V.
> > IIRC, vector uses some floating point opcodes, but does it (or Linux's
> > implementation) actually depend on having floating point support in the
> > kernel?
>=20
> Yes.
>=20
> "The V extension requires the scalar processor implements the F and D
> extensions", RISC-V "V" Vector Extension, Section 18.3. V: Vector Extensi=
on
> for Application Processors.

Thanks, I should probably just have gone and read the spec!

> > If not, this cannot be done in a oneliner. Otherwise, CONFIG_RISCV_ISA_V
> > should explicitly depend on CONFIG_FPU.

Since it does depend on F & D, the Kconfig symbol should explicitly
depend on CONFIG_FPU.
The oneliner like that still doesn't work, as V is added to march after
C, leading (for clang-15 allmodconfig) to: -march=3Drv64imafdcv_zihintpause
Doing it as a oneline also breaks the case where CONFIG_FPU &&
!RISCV_ISA_VECTOR, which ends up with: -march=3Drv64imafdc_zihintpause.

Cheers,
Conor.


--NHHGYGTcCF3WT1JP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/y3HQAKCRB4tDGHoIJi
0vzxAQDx81kk349JUaKSa+IA5L5Pdfs39KahgQMLQ/Er425CQgEA5pE+edwmzKof
XW/CvkKd4pIK2J6fETt/gxnc1CC/vgY=
=JzC8
-----END PGP SIGNATURE-----

--NHHGYGTcCF3WT1JP--
