Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA17E67D7A4
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 22:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbjAZVYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 16:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbjAZVYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 16:24:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A689746
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 13:24:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED3056191F
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 21:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB51C433EF;
        Thu, 26 Jan 2023 21:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674768285;
        bh=luqlVhEbetEToBmyzWO92pNHVb5a7EEXGPmVX+vqcR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kGouwijeXy1umKpYKvOLV3pT2AQ9hvUg5np+iOd58CdrGiQi9ive25w5fAqJwVEdX
         S3LfXa03CaSaHZSjTQgmsxPuv9vJKKtnuGuMdE21rECcRyWgXZ61DZYB5pdbtn3hVI
         byOt3Mx5+wlu6eDLFaRM669ND8rPBR2EvUG1P2H58G7qJztdrJO3/kZjqIfgB0/luw
         lCsglhidkfLbkxOHTTUopMyKCT8rRBUsc9f64htXhxB2cM6nSjgQGlM+83rHBahth8
         wb+VTZjFIPV5yfDcI/i+iN8J4RFMu/hq5IB7xPWPdDP1wOktNu2mQu4TR7WDpS3KsU
         zPDK/eyUVJa8Q==
Date:   Thu, 26 Jan 2023 21:24:38 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Anup Patel <apatel@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Jisheng Zhang <jszhang@kernel.org>
Subject: Re: [PATCH -next v13 07/19] riscv: Introduce riscv_vsize to record
 size of Vector context
Message-ID: <Y9LvltKhEIa5q3Ji@spud>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-8-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yVxqZRNVlMvgnfvG"
Content-Disposition: inline
In-Reply-To: <20230125142056.18356-8-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--yVxqZRNVlMvgnfvG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey again Andy!

On Wed, Jan 25, 2023 at 02:20:44PM +0000, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> This patch is used to detect the size of CPU vector registers and use
> riscv_vsize to save the size of all the vector registers. It assumes all
> harts has the same capabilities in a SMP system.
>=20
> [guoren@linux.alibaba.com: add has_vector checking]
> Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
>  arch/riscv/include/asm/vector.h |  3 +++
>  arch/riscv/kernel/cpufeature.c  | 12 +++++++++++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vec=
tor.h
> index 0fda0faf5277..16cb4a1c1230 100644
> --- a/arch/riscv/include/asm/vector.h
> +++ b/arch/riscv/include/asm/vector.h
> @@ -13,6 +13,8 @@
>  #include <asm/hwcap.h>
>  #include <asm/csr.h>
> =20
> +extern unsigned long riscv_vsize;

Hmm, naming this with a riscv_v_ prefix too would be good I think.

> +
>  static __always_inline bool has_vector(void)
>  {
>  	return static_branch_likely(&riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_VECTO=
R]);
> @@ -31,6 +33,7 @@ static __always_inline void rvv_disable(void)
>  #else /* ! CONFIG_RISCV_ISA_V  */
> =20
>  static __always_inline bool has_vector(void) { return false; }
> +#define riscv_vsize (0)
> =20
>  #endif /* CONFIG_RISCV_ISA_V */
> =20
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeatur=
e.c
> index c433899542ff..3aaae4e0b963 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -21,6 +21,7 @@
>  #include <asm/processor.h>
>  #include <asm/smp.h>
>  #include <asm/switch_to.h>
> +#include <asm/vector.h>
> =20
>  #define NUM_ALPHA_EXTS ('z' - 'a' + 1)
> =20
> @@ -31,6 +32,10 @@ static DECLARE_BITMAP(riscv_isa, RISCV_ISA_EXT_MAX) __=
read_mostly;
> =20
>  DEFINE_STATIC_KEY_ARRAY_FALSE(riscv_isa_ext_keys, RISCV_ISA_EXT_KEY_MAX);
>  EXPORT_SYMBOL(riscv_isa_ext_keys);
> +#ifdef CONFIG_RISCV_ISA_V
> +unsigned long riscv_vsize __read_mostly;
> +EXPORT_SYMBOL_GPL(riscv_vsize);
> +#endif

I really don't think that this should be in here at all. IMO, this
should be moved out to vector.c or something along those lines and...

> =20
>  /**
>   * riscv_isa_extension_base() - Get base extension word
> @@ -258,7 +263,12 @@ void __init riscv_fill_hwcap(void)
>  	}
> =20
>  	if (elf_hwcap & COMPAT_HWCAP_ISA_V) {
> -#ifndef CONFIG_RISCV_ISA_V
> +#ifdef CONFIG_RISCV_ISA_V
> +		/* There are 32 vector registers with vlenb length. */
> +		rvv_enable();
> +		riscv_vsize =3D csr_read(CSR_VLENB) * 32;
> +		rvv_disable();
> +#else

=2E..so should all of this code, especially the csr_read(). vector.c
would then provide the actual implementation, and vector.h would provide
an implementation with an empty function body.
The code here could the, following my previous suggestion of
IS_ENABLED() look along the lines of:
	if (elf_hwcap & COMPAT_HWCAP_ISA_V) {
		if (IS_ENABLED(CONFIG_RISCV_ISA_V))
			riscv_v_setup_vsize();
		else
			elf_hwcap &=3D ~COMPAT_HWCAP_ISA_V;
	}

Having the csr_read() in particular looks rather out of place to me in
this file. Better off keeping the vector stuff together & having
unneeded ifdefs is my pet peeve ;)

Thanks,
Conor.

--yVxqZRNVlMvgnfvG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9LvlgAKCRB4tDGHoIJi
0s8wAQCQ95n8aRO64+ZGQZL9lgfLa7RuurhJvSSBuZswO824LwEA+J9kNto4P/yw
gTSF+6o+sq1iEg1iD8vvY70J1uwN+wo=
=h6ks
-----END PGP SIGNATURE-----

--yVxqZRNVlMvgnfvG--
