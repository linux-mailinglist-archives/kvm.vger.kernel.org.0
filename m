Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FAF644E75
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 23:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiLFWRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 17:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLFWRH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 17:17:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E0649B51;
        Tue,  6 Dec 2022 14:16:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81FD0B81B4E;
        Tue,  6 Dec 2022 22:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74F7C433C1;
        Tue,  6 Dec 2022 22:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670365009;
        bh=SCKvjdFkoWahyssNW3KR7YKwBEXw4uCbZYWyEgkyLT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SQKugXn3vGaePN6d/lLbeRZ4+CUOM9i9yLk5xenA5/v+crzh6ZbCdEZbOssJCmFwu
         c3RlurGYiN4v+e5uGk5nGgMyWfuQ5SHSgf6YkyWJu85POCRtIc1vKuKDjv2Aso8aRn
         qpWK6KldgvQ6Eg9H+SWl5e+WztPTZ2vDx5AXtaZGDXhl/5+mstpP6iBkgtceFkl/39
         jG35/riADRnIfsPxuDbBXFxfwmG4yI29GXFSgkGCPdJecRawqN6DnZglz0APIcKFYD
         0VBwsYeHTcgrsCJPmNflHnPpcubPZMmN5Xy8rsUT1jji6aJVV/NL/sNgU0vzG6PeFf
         NEjN1PTpMmnCw==
Date:   Tue, 6 Dec 2022 22:16:44 +0000
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
Subject: Re: [PATCH v2 13/13] riscv: remove riscv_isa_ext_keys[] array and
 related usage
Message-ID: <Y4+/TPEfueQqahgb@spud>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <20221204174632.3677-14-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X6tcYWkrEqthglcL"
Content-Disposition: inline
In-Reply-To: <20221204174632.3677-14-jszhang@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--X6tcYWkrEqthglcL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2022 at 01:46:32AM +0800, Jisheng Zhang wrote:
> All users have switched to riscv_has_extension_*, removed unused

minor nit: remove

> definitions, vars and related setting code.
>=20
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>

May as well join the R-b club here, the removal of 2 places where
extensions need to be kept ordered is especially appreciated!

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks!

> ---
>  arch/riscv/include/asm/hwcap.h | 30 ------------------------------
>  arch/riscv/kernel/cpufeature.c |  9 ---------
>  2 files changed, 39 deletions(-)
>=20
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwca=
p.h
> index e2d3f6df7701..be00a4337578 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -60,18 +60,6 @@ enum {
> =20
>  extern unsigned long elf_hwcap;
> =20
> -/*
> - * This enum represents the logical ID for each RISC-V ISA extension sta=
tic
> - * keys. We can use static key to optimize code path if some ISA extensi=
ons
> - * are available.
> - */
> -enum riscv_isa_ext_key {
> -	RISCV_ISA_EXT_KEY_FPU,		/* For 'F' and 'D' */
> -	RISCV_ISA_EXT_KEY_ZIHINTPAUSE,
> -	RISCV_ISA_EXT_KEY_SVINVAL,
> -	RISCV_ISA_EXT_KEY_MAX,
> -};
> -
>  struct riscv_isa_ext_data {
>  	/* Name of the extension displayed to userspace via /proc/cpuinfo */
>  	char uprop[RISCV_ISA_EXT_NAME_LEN_MAX];
> @@ -79,24 +67,6 @@ struct riscv_isa_ext_data {
>  	unsigned int isa_ext_id;
>  };
> =20
> -extern struct static_key_false riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_MAX];
> -
> -static __always_inline int riscv_isa_ext2key(int num)
> -{
> -	switch (num) {
> -	case RISCV_ISA_EXT_f:
> -		return RISCV_ISA_EXT_KEY_FPU;
> -	case RISCV_ISA_EXT_d:
> -		return RISCV_ISA_EXT_KEY_FPU;
> -	case RISCV_ISA_EXT_ZIHINTPAUSE:
> -		return RISCV_ISA_EXT_KEY_ZIHINTPAUSE;
> -	case RISCV_ISA_EXT_SVINVAL:
> -		return RISCV_ISA_EXT_KEY_SVINVAL;
> -	default:
> -		return -EINVAL;
> -	}
> -}
> -
>  static __always_inline bool
>  riscv_has_extension_likely(const unsigned long ext)
>  {
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeatur=
e.c
> index adeac90b1d8e..3240a2915bf1 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -28,9 +28,6 @@ unsigned long elf_hwcap __read_mostly;
>  /* Host ISA bitmap */
>  static DECLARE_BITMAP(riscv_isa, RISCV_ISA_EXT_MAX) __read_mostly;
> =20
> -DEFINE_STATIC_KEY_ARRAY_FALSE(riscv_isa_ext_keys, RISCV_ISA_EXT_KEY_MAX);
> -EXPORT_SYMBOL(riscv_isa_ext_keys);
> -
>  /**
>   * riscv_isa_extension_base() - Get base extension word
>   *
> @@ -243,12 +240,6 @@ void __init riscv_fill_hwcap(void)
>  		if (elf_hwcap & BIT_MASK(i))
>  			print_str[j++] =3D (char)('a' + i);
>  	pr_info("riscv: ELF capabilities %s\n", print_str);
> -
> -	for_each_set_bit(i, riscv_isa, RISCV_ISA_EXT_MAX) {
> -		j =3D riscv_isa_ext2key(i);
> -		if (j >=3D 0)
> -			static_branch_enable(&riscv_isa_ext_keys[j]);
> -	}
>  }
> =20
>  #ifdef CONFIG_RISCV_ALTERNATIVE
> --=20
> 2.37.2
>=20

--X6tcYWkrEqthglcL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY4+/TAAKCRB4tDGHoIJi
0hI3AQCqj2tIrACOrGzynokG2RuMrrgWBEZybArbnX4L2Pe92gEAlBwKkfA8OArZ
tlTBLAt1k8b8ouzqGGFaJd9xQY4ltQ4=
=IvYj
-----END PGP SIGNATURE-----

--X6tcYWkrEqthglcL--
