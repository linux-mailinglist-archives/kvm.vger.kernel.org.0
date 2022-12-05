Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3AB86430CB
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 19:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiLESyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 13:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiLESyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 13:54:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E3F1FCFB;
        Mon,  5 Dec 2022 10:54:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4AF8B811E9;
        Mon,  5 Dec 2022 18:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002C8C433C1;
        Mon,  5 Dec 2022 18:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670266438;
        bh=dDkwloYPqTSZ4SPvf12m0QEAckEY0pJcFUlkg7vk9bw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dVE9deyV41By2ecKZTxyNR/vJluvD+S+wrV47jbjfV8izTa4gMYXx7zIVwLauOsyN
         IHLVw3h9kHqr4SHZB2URR7iU/abT0V9/hd34vcLM74k2roTRA22lvJmObJDJzHA6g4
         3qfgroGFhn4D/LIfrc4+DUSofA80f3hgJFeS1jVSc4v9m4CXqPaB9j72EGyto04aBz
         ylV3HyuobxbU0IcwC/x0l6GGOO/8PRYpDdYDfX9oeu3z6eORZ+phGKIFZiK+5kbTG2
         sc+yFdW1qyVq8CMgqZxRBGS7YJg67BmjczpwnszScQFrOdJr7Lpw/qIvcdRu+LQ0OM
         fytLkls7jOHsg==
Date:   Mon, 5 Dec 2022 18:53:53 +0000
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
Message-ID: <Y44+QWJfaa7haS/5@spud>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <20221204174632.3677-5-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SoXKSTu70JicbV71"
Content-Disposition: inline
In-Reply-To: <20221204174632.3677-5-jszhang@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--SoXKSTu70JicbV71
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Jisheng,

On Mon, Dec 05, 2022 at 01:46:23AM +0800, Jisheng Zhang wrote:
> We will make use of ISA extension in asm files, so make the multi-letter
> RISC-V ISA extension IDs macros rather than enums and move them and
> those base ISA extension IDs to suitable place.

Which base ISA extension IDs? Changelog should match the patch contents,
and it's a little unclear here since the base ISA extension IDs are
visible here but in the context not the diff.

>=20
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/include/asm/hwcap.h | 43 ++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 23 deletions(-)
>=20
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwca=
p.h
> index b22525290073..996884986fea 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -12,20 +12,6 @@
>  #include <linux/bits.h>
>  #include <uapi/asm/hwcap.h>
> =20
> -#ifndef __ASSEMBLY__
> -#include <linux/jump_label.h>
> -/*
> - * This yields a mask that user programs can use to figure out what
> - * instruction set this cpu supports.
> - */
> -#define ELF_HWCAP		(elf_hwcap)
> -
> -enum {
> -	CAP_HWCAP =3D 1,
> -};
> -
> -extern unsigned long elf_hwcap;
> -
>  #define RISCV_ISA_EXT_a		('a' - 'a')
>  #define RISCV_ISA_EXT_c		('c' - 'a')
>  #define RISCV_ISA_EXT_d		('d' - 'a')
> @@ -46,22 +32,33 @@ extern unsigned long elf_hwcap;
>  #define RISCV_ISA_EXT_BASE 26
> =20
>  /*
> - * This enum represent the logical ID for each multi-letter RISC-V ISA e=
xtension.
> + * These macros represent the logical ID for each multi-letter RISC-V IS=
A extension.
>   * The logical ID should start from RISCV_ISA_EXT_BASE and must not exce=
ed
>   * RISCV_ISA_EXT_MAX. 0-25 range is reserved for single letter
>   * extensions while all the multi-letter extensions should define the ne=
xt
>   * available logical extension id.
>   */
> -enum riscv_isa_ext_id {
> -	RISCV_ISA_EXT_SSCOFPMF =3D RISCV_ISA_EXT_BASE,
> -	RISCV_ISA_EXT_SVPBMT,
> -	RISCV_ISA_EXT_ZICBOM,
> -	RISCV_ISA_EXT_ZIHINTPAUSE,
> -	RISCV_ISA_EXT_SSTC,
> -	RISCV_ISA_EXT_SVINVAL,
> -	RISCV_ISA_EXT_ID_MAX =3D RISCV_ISA_EXT_MAX,
> +#define RISCV_ISA_EXT_SSCOFPMF		26
> +#define RISCV_ISA_EXT_SVPBMT		27
> +#define RISCV_ISA_EXT_ZICBOM		28
> +#define RISCV_ISA_EXT_ZIHINTPAUSE	29
> +#define RISCV_ISA_EXT_SSTC		30
> +#define RISCV_ISA_EXT_SVINVAL		31

Could you re-order these alphabetically when you move them please?

Thanks,
Conor.

> +
> +#ifndef __ASSEMBLY__
> +#include <linux/jump_label.h>
> +/*
> + * This yields a mask that user programs can use to figure out what
> + * instruction set this cpu supports.
> + */
> +#define ELF_HWCAP		(elf_hwcap)
> +
> +enum {
> +	CAP_HWCAP =3D 1,
>  };
> =20
> +extern unsigned long elf_hwcap;
> +
>  /*
>   * This enum represents the logical ID for each RISC-V ISA extension sta=
tic
>   * keys. We can use static key to optimize code path if some ISA extensi=
ons
> --=20
> 2.37.2
>=20

--SoXKSTu70JicbV71
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY44+QQAKCRB4tDGHoIJi
0lI5AQCQU4Yulx3aPJ/8VwGzte0KU1wRgZkLQgu+/cIrvg4iygEArz2COMO1jpcT
yHkDw3opFZX0/12MgPrroFAUZCOdQQw=
=Ph2m
-----END PGP SIGNATURE-----

--SoXKSTu70JicbV71--
