Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26402722C6D
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 18:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjFEQZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 12:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjFEQZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 12:25:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846B4CD
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 09:25:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1941A60EAA
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 16:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A67BC433EF;
        Mon,  5 Jun 2023 16:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685982299;
        bh=2k5gsovXlJIC1RZserxxFdrudV31qBUSxSuOtRRJwrA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iixl2+w277wloCrH/fuvS0EtM3J6dfF5nQQoMSsbPDBdLAwobs9zR94E1L1EcPn9P
         P0HiCilKL+3ZQ0+oxgiLOm/bbZ1y4kdGJjux1bsHe9gx4w4gaBk0pBeaFlivnnn4oz
         p5UzqsmwlJ2kkkhHDcA6tI6wc47r9elqZ6leUSGFtLQcbQv2rLTEGa9wkDnYRpXcNE
         IZj2VPBEMij8da+4j2SyftPyd26/afd21O7ZGuABxUQaguFEI27ROVfNH1mFbf81Ug
         dTx9J8g2kauMJi8MGeszYc44yAALPGE/JCSsxI5m8wN9DlpLBYRV46J3KmVTnkYTbE
         hEjlt38KuqBwg==
Date:   Mon, 5 Jun 2023 17:24:53 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Jisheng Zhang <jszhang@kernel.org>, Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH -next v21 20/27] riscv: hwcap: change ELF_HWCAP to a
 function
Message-ID: <20230605-embattled-navigator-408a7b60b2ab@spud>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
 <20230605110724.21391-21-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ye2ug/mzlrhRInNk"
Content-Disposition: inline
In-Reply-To: <20230605110724.21391-21-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ye2ug/mzlrhRInNk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 05, 2023 at 11:07:17AM +0000, Andy Chiu wrote:
> Using a function is flexible to represent ELF_HWCAP. So the kernel may
> encode hwcap reflecting supported hardware features just at the moment of
> the start of each program.
>=20
> This will be helpful when we introduce prctl/sysctl interface to control
> per-process availability of Vector extension in following patches.
> Programs started with V disabled should see V masked off in theirs
> ELF_HWCAP.

For the uninformed, like myself, this needs to be a function, rather
than open coding the masking of the V bit at the one user of ELF_HWCAP
this series adds, because the binfmt stuff needs to get the value in
create_elf_fdpic_tables() & co?

If that's your purpose,
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

One minor comment below.

>=20
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
>  arch/riscv/include/asm/elf.h   | 2 +-
>  arch/riscv/include/asm/hwcap.h | 2 ++
>  arch/riscv/kernel/cpufeature.c | 5 +++++
>  3 files changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/riscv/include/asm/elf.h b/arch/riscv/include/asm/elf.h
> index ca23c4f6c440..c24280774caf 100644
> --- a/arch/riscv/include/asm/elf.h
> +++ b/arch/riscv/include/asm/elf.h
> @@ -66,7 +66,7 @@ extern bool compat_elf_check_arch(Elf32_Ehdr *hdr);
>   * via a bitmap that coorespends to each single-letter ISA extension.  T=
his is
>   * essentially defunct, but will remain for compatibility with userspace.
>   */
> -#define ELF_HWCAP	(elf_hwcap & ((1UL << RISCV_ISA_EXT_BASE) - 1))
> +#define ELF_HWCAP	riscv_get_elf_hwcap()
>  extern unsigned long elf_hwcap;
> =20
>  /*
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwca=
p.h
> index 574385930ba7..e6c288ac4581 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -61,6 +61,8 @@
> =20
>  #include <linux/jump_label.h>
> =20
> +unsigned long riscv_get_elf_hwcap(void);
> +
>  struct riscv_isa_ext_data {
>  	/* Name of the extension displayed to userspace via /proc/cpuinfo */
>  	char uprop[RISCV_ISA_EXT_NAME_LEN_MAX];
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeatur=
e.c
> index 28032b083463..29c0680652a0 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -293,6 +293,11 @@ void __init riscv_fill_hwcap(void)
>  	pr_info("riscv: ELF capabilities %s\n", print_str);
>  }
> =20
> +unsigned long riscv_get_elf_hwcap(void)
> +{
> +	return (elf_hwcap & ((1UL << RISCV_ISA_EXT_BASE) - 1));

If you respin for some other reason, could you drop the open coded mask
creation as part of these changes?

Cheers,
Conor.

> +}
> +
>  #ifdef CONFIG_RISCV_ALTERNATIVE
>  /*
>   * Alternative patch sites consider 48 bits when determining when to pat=
ch
> --=20
> 2.17.1
>=20
>=20
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

--ye2ug/mzlrhRInNk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZH4MVAAKCRB4tDGHoIJi
0sGMAP9be9EOLf6i4DMdXuL6QfJTFwY/2NQFtH3LnUACf9gi/gD+MXwPxiXlWVKA
seOkZ2VbAthKJU/Oe82lycblm5OAMAQ=
=TfHl
-----END PGP SIGNATURE-----

--ye2ug/mzlrhRInNk--
