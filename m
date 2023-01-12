Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABC1668666
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 23:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbjALWHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 17:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjALWGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 17:06:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5726DD4;
        Thu, 12 Jan 2023 13:55:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79C0262174;
        Thu, 12 Jan 2023 21:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2D7C433EF;
        Thu, 12 Jan 2023 21:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673560557;
        bh=PiMWPgePScKOV0uoyAba+JA0J1HRl0Cq4MC1tYQpJ2I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ieaVvY3nG9tFozYB829OQL4xsKrLLExAZQQ/gKKeLggpsaa7ibA0jEqO73ITQggos
         v0TRc4N275UabsCNRMqf0ae6dxvAGVmADjDesNdW4wn24Fweou7DJHu2G49sABOElM
         fF3ThLKH3cldAsnBbIsBlCvU/srsCqL1G6MXK9QPlQrccCpCRivPbqzOLllK6OkiRA
         tcd6txb3MbRKzs4cCbOh7GJMHZyVWpTYbeVyHgWjuoyMik23zCm4kk3+9FQHSyoxmF
         ISmPED5Z+8hgi5nL5LIo10efpRJMggv5sWl9hYbQ81HeUy1Wlh2vvliRWkxuX0tI8A
         x7oOmaLMRaPyQ==
Date:   Thu, 12 Jan 2023 21:55:52 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Conor Dooley <conor.dooley@microchip.com>, jszhang@kernel.org
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Guo Ren <guoren@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>
Subject: Re: [PATCH v3 10/13] riscv: alternative: patch alternatives in the
 vDSO
Message-ID: <Y8CB6Cy5ZrTMIkFL@spud>
References: <20230111171027.2392-1-jszhang@kernel.org>
 <20230111171027.2392-11-jszhang@kernel.org>
 <Y7+7TRv7+V0nKNiZ@wendy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="t6Mgjx3f2BNOzJab"
Content-Disposition: inline
In-Reply-To: <Y7+7TRv7+V0nKNiZ@wendy>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--t6Mgjx3f2BNOzJab
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2023 at 07:48:29AM +0000, Conor Dooley wrote:
> Hey Jisheng,
>=20
> On Thu, Jan 12, 2023 at 01:10:24AM +0800, Jisheng Zhang wrote:
> > Make it possible to use alternatives in the vDSO, so that better
> > implementations can be used if possible.
> >=20
> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > Reviewed-by: Guo Ren <guoren@kernel.org>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>=20
> FYI, from this patch onwards the rv32 build is broken.
> Should be reproduceable with the in-tree rv32_defconfig.
>=20
> Unfortunately no logs for you, I've got a CI bug to fix!

Here's the error:

=2E./arch/riscv/kernel/alternative.c:174:21: error: incompatible pointer ty=
pes passing 'const struct elf64_hdr *' to parameter of type 'const Elf32_Eh=
dr *' (aka 'const struct elf32_hdr *') [-Werror,-Wincompatible-pointer-type=
s]
        alt =3D find_section(hdr, shdr, ".alternative");
                           ^~~
=2E./arch/riscv/include/asm/module.h:115:60: note: passing argument to para=
meter 'hdr' here
static inline const Elf_Shdr *find_section(const Elf_Ehdr *hdr,
                                                           ^
=2E./arch/riscv/kernel/alternative.c:174:26: error: incompatible pointer ty=
pes passing 'const struct elf64_shdr *' to parameter of type 'const Elf32_S=
hdr *' (aka 'const struct elf32_shdr *') [-Werror,-Wincompatible-pointer-ty=
pes]
        alt =3D find_section(hdr, shdr, ".alternative");
                                ^~~~
=2E./arch/riscv/include/asm/module.h:116:25: note: passing argument to para=
meter 'sechdrs' here
                                           const Elf_Shdr *sechdrs,
                                                           ^
=2E./arch/riscv/kernel/alternative.c:174:6: error: incompatible pointer typ=
es assigning to 'const struct elf64_shdr *' from 'const Elf32_Shdr *' (aka =
'const struct elf32_shdr *') [-Werror,-Wincompatible-pointer-types]
        alt =3D find_section(hdr, shdr, ".alternative");
            ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
3 errors generated.

Thanks,
Conor.


--t6Mgjx3f2BNOzJab
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8CB6AAKCRB4tDGHoIJi
0tFCAP0SCpBMI4iFNNCGroUlQ0Fd+5ofL2sPC2i+e4AjAW6TugD8Do9NPn+zAurA
/29Zj40trR91yfFMsLQgNM2qHVlkZAU=
=kql5
-----END PGP SIGNATURE-----

--t6Mgjx3f2BNOzJab--
