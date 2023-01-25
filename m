Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D0467BE9C
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 22:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbjAYVd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 16:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236773AbjAYVdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 16:33:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3E94B89D
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 13:33:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76F6A6164B
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 21:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C51BC433D2;
        Wed, 25 Jan 2023 21:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674682417;
        bh=VPBK89OzL1t7ADAvO8MGjPWy15t2/c+kWPCVkI5MBSU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ld+duX6dFv/VbZGFXLamPGkn//QJH+xLG0jPmFOChHbSMZoXpY2JUwHxxJAH1MIxV
         KkXI8+8xUcD5ZDpXhkH3NVPMXheYWj55BAuWF2vWuM6vupU1HPFwcXd3rO97bsd0NL
         lVg3nOkIg5S/eB6n6JYyuKoSycnXIHePiqi7EGR9+MB89KoZ1+oi0bvcpt/4Ev6Agu
         ADNwWYlJEUDZnmnKX98+lRr0Nzlv5bzVVFLUqBis5vqvSVl143Z+dqkCeeW3rioIqQ
         HeeLQ0N8DfrTi3lBnjvZU0o8Kj1jtu6IUL9+fa+kzd5noT+1I5mXQz7EGM1mPagYB3
         aA6zlX3ymoupg==
Date:   Wed, 25 Jan 2023 21:33:30 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Guo Ren <ren_guo@c-sky.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko@sntech.de>,
        Atish Patra <atishp@rivosinc.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Guo Ren <guoren@kernel.org>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Dao Lu <daolu@rivosinc.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Tsukasa OI <research_trasio@irq.a4lg.com>
Subject: Re: [PATCH -next v13 02/19] riscv: Extending cpufeature.c to detect
 V-extension
Message-ID: <Y9GgKiF8q2k9eRdh@spud>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-3-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3a+UxG8CC/ZmR3JD"
Content-Disposition: inline
In-Reply-To: <20230125142056.18356-3-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--3a+UxG8CC/ZmR3JD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 25, 2023 at 02:20:39PM +0000, Andy Chiu wrote:
> From: Guo Ren <ren_guo@c-sky.com>
>=20
> Add V-extension into riscv_isa_ext_keys array and detect it with isa
> string parsing.
>=20
> Signed-off-by: Guo Ren <ren_guo@c-sky.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
>  arch/riscv/include/asm/hwcap.h      |  4 ++++
>  arch/riscv/include/asm/vector.h     | 26 ++++++++++++++++++++++++++
>  arch/riscv/include/uapi/asm/hwcap.h |  1 +
>  arch/riscv/kernel/cpufeature.c      | 12 ++++++++++++
>  4 files changed, 43 insertions(+)
>  create mode 100644 arch/riscv/include/asm/vector.h
>=20
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwca=
p.h
> index 57439da71c77..f413db6118e5 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -35,6 +35,7 @@ extern unsigned long elf_hwcap;
>  #define RISCV_ISA_EXT_m		('m' - 'a')
>  #define RISCV_ISA_EXT_s		('s' - 'a')
>  #define RISCV_ISA_EXT_u		('u' - 'a')
> +#define RISCV_ISA_EXT_v		('v' - 'a')
> =20
>  /*
>   * Increse this to higher value as kernel support more ISA extensions.
> @@ -73,6 +74,7 @@ static_assert(RISCV_ISA_EXT_ID_MAX <=3D RISCV_ISA_EXT_M=
AX);
>  enum riscv_isa_ext_key {
>  	RISCV_ISA_EXT_KEY_FPU,		/* For 'F' and 'D' */
>  	RISCV_ISA_EXT_KEY_SVINVAL,
> +	RISCV_ISA_EXT_KEY_VECTOR,	/* For 'V' */

That's obvious surely, no?

>  	RISCV_ISA_EXT_KEY_ZIHINTPAUSE,
>  	RISCV_ISA_EXT_KEY_MAX,
>  };
> @@ -95,6 +97,8 @@ static __always_inline int riscv_isa_ext2key(int num)

You should probably check out Jisheng's series that deletes whole
sections of this code, including this whole function.
https://lore.kernel.org/all/20230115154953.831-3-jszhang@kernel.org/T/#u


> @@ -256,6 +257,17 @@ void __init riscv_fill_hwcap(void)
>  		elf_hwcap &=3D ~COMPAT_HWCAP_ISA_F;
>  	}
> =20
> +	if (elf_hwcap & COMPAT_HWCAP_ISA_V) {
> +#ifndef CONFIG_RISCV_ISA_V
> +		/*
> +		 * ISA string in device tree might have 'v' flag, but
> +		 * CONFIG_RISCV_ISA_V is disabled in kernel.
> +		 * Clear V flag in elf_hwcap if CONFIG_RISCV_ISA_V is disabled.
> +		 */
> +		elf_hwcap &=3D ~COMPAT_HWCAP_ISA_V;
> +#endif

I know that a later patch in this series calls rvv_enable() here, which
I'll comment on there, but I'd rather see IS_ENABLED as opposed to
ifdefs in C files where possible.

Thanks,
Conor.


--3a+UxG8CC/ZmR3JD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9GgKgAKCRB4tDGHoIJi
0kMeAQCk+Gb+qMqVyNUcJ8qsfakKAL8e78MvtzdpoT7zTtuKsAEAr3tw4rUtHnWh
THWJ8Oa3zHVrhdA+FRvz/Aon36+E/wU=
=xBo/
-----END PGP SIGNATURE-----

--3a+UxG8CC/ZmR3JD--
