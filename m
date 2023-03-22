Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161DA6C4F37
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 16:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjCVPRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 11:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbjCVPRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 11:17:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0ACC67728;
        Wed, 22 Mar 2023 08:17:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 239DBB81D0A;
        Wed, 22 Mar 2023 15:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC84EC433D2;
        Wed, 22 Mar 2023 15:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679498238;
        bh=x14uXdcyN6NwgG+IiJ4mbAithUacI0jt05p67YoWCxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vHu19ck37uJ0Noh8bpkiMcCiwaHGbeUk3AoCX1D9/uQoq+m7Jeuc8mcRjW+sjs9Lk
         fbtSCGNHoVaCLkM+gy9b113QC3L9P3tPRFwAwXVYqne0L6m1WsStAc3vF68MVMmioy
         DFgwckFmD9AIGERIB82AVK9Ky5AeChx0LNAwp/CFcXL7eda2sw3GF0mPer4I4lyLnp
         gfkoc0/szZ4DO1Ledjhc2NLZDfgsL8NnB9ScltQ4AeiF9yhWDzy4Ovu7qZvWWgAy/5
         u3d8cxwwZoaBPfWmkClx6UKw4Dc/iBmHk4ZwkcWBzuibER73j2ug9b6v5sdS8H50su
         L4dbHUHyU98Zg==
Date:   Wed, 22 Mar 2023 15:17:13 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        regressions@leemhuis.info, regressions@lists.linux.dev
Subject: Re: [PATCH] riscv: require alternatives framework when selecting FPU
 support
Message-ID: <1884bd96-2783-4556-bc57-8b733758baff@spud>
References: <ZBruFRwt3rUVngPu@zx2c4.com>
 <20230322120907.2968494-1-Jason@zx2c4.com>
 <20230322124631.7p67thzeblrawsqj@orel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="B7v5JtRVPQGXVgO3"
Content-Disposition: inline
In-Reply-To: <20230322124631.7p67thzeblrawsqj@orel>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--B7v5JtRVPQGXVgO3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 22, 2023 at 01:46:31PM +0100, Andrew Jones wrote:
> On Wed, Mar 22, 2023 at 01:09:07PM +0100, Jason A. Donenfeld wrote:
> > When moving switch_to's has_fpu() over to using riscv_has_extension_
> > likely() rather than static branchs, the FPU code gained a dependency on
> > the alternatives framework. If CONFIG_RISCV_ALTERNATIVE isn't selected
> > when CONFIG_FPU is, then has_fpu() returns false, and switch_to does not
> > work as intended. So select CONFIG_RISCV_ALTERNATIVE when CONFIG_FPU is
> > selected.
> >=20
> > Fixes: 702e64550b12 ("riscv: fpu: switch has_fpu() to riscv_has_extensi=
on_likely()")
> > Link: https://lore.kernel.org/all/ZBruFRwt3rUVngPu@zx2c4.com/
> > Cc: Jisheng Zhang <jszhang@kernel.org>
> > Cc: Andrew Jones <ajones@ventanamicro.com>
> > Cc: Heiko Stuebner <heiko@sntech.de>
> > Cc: Conor Dooley <conor.dooley@microchip.com>

Thanks for fixing it!
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
> >  arch/riscv/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > index c5e42cc37604..0f59350c699d 100644
> > --- a/arch/riscv/Kconfig
> > +++ b/arch/riscv/Kconfig
> > @@ -467,6 +467,7 @@ config TOOLCHAIN_HAS_ZIHINTPAUSE
> >  config FPU
> >  	bool "FPU support"
> >  	default y
> > +	select RISCV_ALTERNATIVE
> >  	help
> >  	  Say N here if you want to disable all floating-point related proced=
ure
> >  	  in the kernel.
> > --=20
> > 2.40.0
> >
>=20
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>=20
> I took a look to see if we missed anything else and see that we should
> do the same patch for KVM. I'll send one.
>=20
> (It's tempting to just select RISCV_ALTERNATIVE from RISCV, but maybe we
>  can defer that wedding a bit longer.)

At that point, the config option should just go away entirely, no?

--B7v5JtRVPQGXVgO3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBsb2wAKCRB4tDGHoIJi
0m+3AQCe8JDweaSMp3gkW9PkqtzV9SdMdFtfRNgo0IR/sPVzowD/brjdaYh5/LCw
MO5YGP9cVuRb+cGX+RlJV2Skhb0lHgA=
=pPeQ
-----END PGP SIGNATURE-----

--B7v5JtRVPQGXVgO3--
