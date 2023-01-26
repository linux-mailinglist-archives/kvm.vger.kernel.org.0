Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1CD767D748
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 22:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbjAZVHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 16:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbjAZVHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 16:07:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15BF6A301
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 13:06:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EB2AB81E0F
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 21:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2F0C4339B;
        Thu, 26 Jan 2023 21:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674767215;
        bh=Ppta7s+cza1Wa3n4i3Lt9bAtYmobvY+8Fx+wlBv7I7Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GlwzjLANHi+Xj3Y+7+StAUpxHetxmrzs765Gi+9wSHxqiFJ1C2goDeGk6tpUupRd5
         oyIfcbgkBwstgCcI8h4hXUTso57skhfP5V1QvxQ9ByRUbX86d2ZGDFLTbzD40Ml9sX
         YNbFdhebW3alSAj0iQ1PEpGCiMQ0vx7BWUgdm/yqGbpjeGv/2s+zmqZoxUYGxG7NiE
         ZiYDOC+dSifUpoUUuo+cOTXsFzSfwDQaLCurlVzHXI9DXC0v9aWpWif6C3H43ku53y
         rGr/RLpcTuzhQVO5zHi8mF6qplAe/PErs5z2NlcVdmG7oTTGhvsBM+jlOXWfdQsWJG
         KORUU+b+sdfyQ==
Date:   Thu, 26 Jan 2023 21:06:49 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH -next v13 06/19] riscv: Introduce Vector enable/disable
 helpers
Message-ID: <Y9LraUk0SZfYWu+O@spud>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-7-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zndK4lDP+3zPv3BZ"
Content-Disposition: inline
In-Reply-To: <20230125142056.18356-7-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--zndK4lDP+3zPv3BZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Andy,

On Wed, Jan 25, 2023 at 02:20:43PM +0000, Andy Chiu wrote:
> These are small and likely to be frequently called so implement as
> inline routines (vs. function call).
>=20
> Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> [vineetg: create new patch from meshup, introduced asm variant]
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> [andy.chiu: remove calls from asm thus remove asm vaiant]

Again, these chains are odd but a reflection of the series' history I
guess.

> ---
>  arch/riscv/include/asm/vector.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vec=
tor.h
> index 917c8867e702..0fda0faf5277 100644
> --- a/arch/riscv/include/asm/vector.h
> +++ b/arch/riscv/include/asm/vector.h
> @@ -11,12 +11,23 @@
>  #ifdef CONFIG_RISCV_ISA_V
> =20
>  #include <asm/hwcap.h>
> +#include <asm/csr.h>
> =20
>  static __always_inline bool has_vector(void)
>  {
>  	return static_branch_likely(&riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_VECTO=
R]);

This likely will need to drop the static branch due to Jisheng's series.
See here for what the equivalent change to has_fpu() was:
https://lore.kernel.org/all/20230115154953.831-1-jszhang@kernel.org/
Hopefully that series has been queued by the time you are resubmitting
this one.

>  }
> =20
> +static __always_inline void rvv_enable(void)

I'm not keen on these function names. IMO, they should be
riscv_v_{en,dis}able() to match other riscv specific functions, like
those of zicbom or sbi stuff.
Other parts of this series use riscv_v_foo & riscv_vfoo. Some of the kvm
bits spell out vector rather than v. Consistent naming of functions etc
would be appreciated.

Thanks,
Conor.


--zndK4lDP+3zPv3BZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9LraQAKCRB4tDGHoIJi
0mqsAP9Qo6HEuZtRfJkKXx2t6klPzSPuz6ZQJ/dPp3HjDgcnMQEA1QNZBTWJA/d9
dhQCa9qj+NiMhnhvwKGzggrdfRX3iAw=
=Jevm
-----END PGP SIGNATURE-----

--zndK4lDP+3zPv3BZ--
