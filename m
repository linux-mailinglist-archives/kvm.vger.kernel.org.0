Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CF26548C6
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 23:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbiLVW7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 17:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235792AbiLVW7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 17:59:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2246D2A52C;
        Thu, 22 Dec 2022 14:58:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9889261DBC;
        Thu, 22 Dec 2022 22:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B63C433D2;
        Thu, 22 Dec 2022 22:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671749931;
        bh=ZWgMvBec2zTJYuyb0Svwk6xDFK1LoTGdFQ3B/mZFMIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MIei7yl96n5732UM4LP9k01gFdHTs5jCFI53oc8Fu2rBTS9Vqs/5/gzAxSWNDBPUZ
         heND8Iz+BzIp0Sx48Ls8+1epZbcJMoSreIzZUP/hSV7jmS/IlK7bvlv+2FbZOERygw
         c0sBu9ET9FYMFhWPzV6d3f1Lud0/qX3aKHy1g+a1V9KqfGusFB/IIhKrCrxbEqpAku
         6dey2T+1OsG4xVlO1+9HhzkiJ4bjNMMYwXD7ze8+28+WfOmGQ131UUKsAfXh7dlW9N
         PGN7x5MFs5v9TFw8aoqAljcuKnzwp0pLC5PxLVVIfYTQhM2LpK78xXocWrC0wjamH8
         F8oNFSO+LTYiQ==
Date:   Thu, 22 Dec 2022 22:58:46 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 04/13] riscv: hwcap: make ISA extension ids can be
 used in asm
Message-ID: <Y6ThJkjhdee2uNfS@spud>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <20221204174632.3677-5-jszhang@kernel.org>
 <Y44+QWJfaa7haS/5@spud>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9Y7Im1lgoL+dPIBi"
Content-Disposition: inline
In-Reply-To: <Y44+QWJfaa7haS/5@spud>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--9Y7Im1lgoL+dPIBi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2022 at 06:53:53PM +0000, Conor Dooley wrote:
> Hey Jisheng,
>=20
> On Mon, Dec 05, 2022 at 01:46:23AM +0800, Jisheng Zhang wrote:
> > We will make use of ISA extension in asm files, so make the multi-letter
> > RISC-V ISA extension IDs macros rather than enums and move them and
> > those base ISA extension IDs to suitable place.
>=20
> Which base ISA extension IDs? Changelog should match the patch contents,
> and it's a little unclear here since the base ISA extension IDs are
> visible here but in the context not the diff.
>=20
> >=20
> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/hwcap.h | 43 ++++++++++++++++------------------
> >  1 file changed, 20 insertions(+), 23 deletions(-)
> >=20
> > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hw=
cap.h
> > index b22525290073..996884986fea 100644
> > --- a/arch/riscv/include/asm/hwcap.h
> > +++ b/arch/riscv/include/asm/hwcap.h
> > @@ -12,20 +12,6 @@
> >  #include <linux/bits.h>
> >  #include <uapi/asm/hwcap.h>
> > =20
> > -#ifndef __ASSEMBLY__
> > -#include <linux/jump_label.h>
> > -/*
> > - * This yields a mask that user programs can use to figure out what
> > - * instruction set this cpu supports.
> > - */
> > -#define ELF_HWCAP		(elf_hwcap)
> > -
> > -enum {
> > -	CAP_HWCAP =3D 1,
> > -};
> > -
> > -extern unsigned long elf_hwcap;
> > -
> >  #define RISCV_ISA_EXT_a		('a' - 'a')
> >  #define RISCV_ISA_EXT_c		('c' - 'a')
> >  #define RISCV_ISA_EXT_d		('d' - 'a')
> > @@ -46,22 +32,33 @@ extern unsigned long elf_hwcap;
> >  #define RISCV_ISA_EXT_BASE 26
> > =20
> >  /*
> > - * This enum represent the logical ID for each multi-letter RISC-V ISA=
 extension.
> > + * These macros represent the logical ID for each multi-letter RISC-V =
ISA extension.
> >   * The logical ID should start from RISCV_ISA_EXT_BASE and must not ex=
ceed
> >   * RISCV_ISA_EXT_MAX. 0-25 range is reserved for single letter
> >   * extensions while all the multi-letter extensions should define the =
next
> >   * available logical extension id.
> >   */
> > -enum riscv_isa_ext_id {
> > -	RISCV_ISA_EXT_SSCOFPMF =3D RISCV_ISA_EXT_BASE,
> > -	RISCV_ISA_EXT_SVPBMT,
> > -	RISCV_ISA_EXT_ZICBOM,
> > -	RISCV_ISA_EXT_ZIHINTPAUSE,
> > -	RISCV_ISA_EXT_SSTC,
> > -	RISCV_ISA_EXT_SVINVAL,
> > -	RISCV_ISA_EXT_ID_MAX =3D RISCV_ISA_EXT_MAX,
> > +#define RISCV_ISA_EXT_SSCOFPMF		26
> > +#define RISCV_ISA_EXT_SVPBMT		27
> > +#define RISCV_ISA_EXT_ZICBOM		28
> > +#define RISCV_ISA_EXT_ZIHINTPAUSE	29
> > +#define RISCV_ISA_EXT_SSTC		30
> > +#define RISCV_ISA_EXT_SVINVAL		31
>=20
> Could you re-order these alphabetically when you move them please?

On reflection, this is a horrific idea - don't bother. It'd only be
temporary anyway as it'd need massaging when the next extension comes
along.

Either people will have a slightly harder seeing if something is added,
or a "slightly" harder time finding which is the next free number or
have to reshuffle the whole thing.
The latter sounds like a prime bug breeding ground, while the former is
just a search away.
So yeah, don't bother & apologies for the noise!

> > +
> > +#ifndef __ASSEMBLY__
> > +#include <linux/jump_label.h>
> > +/*
> > + * This yields a mask that user programs can use to figure out what
> > + * instruction set this cpu supports.
> > + */
> > +#define ELF_HWCAP		(elf_hwcap)
> > +
> > +enum {
> > +	CAP_HWCAP =3D 1,
> >  };
> > =20
> > +extern unsigned long elf_hwcap;
> > +
> >  /*
> >   * This enum represents the logical ID for each RISC-V ISA extension s=
tatic
> >   * keys. We can use static key to optimize code path if some ISA exten=
sions
> > --=20
> > 2.37.2
> >=20



--9Y7Im1lgoL+dPIBi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY6ThJQAKCRB4tDGHoIJi
0oLKAQCBXs1EjdtFjjO2TfICNa6J8PSQmdmGAOCdZGi8emFxxAD/QKv6vk+jdRYn
wOMpXkzglRwJgTXvV2fTjKDv+9NLfwg=
=W3Us
-----END PGP SIGNATURE-----

--9Y7Im1lgoL+dPIBi--
