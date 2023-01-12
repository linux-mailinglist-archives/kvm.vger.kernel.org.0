Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58364666BD0
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 08:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236520AbjALHtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 02:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239211AbjALHtC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 02:49:02 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4C141D5C;
        Wed, 11 Jan 2023 23:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673509736; x=1705045736;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vMUmhc0Tn/B+KYMP/tYkNeijDWua0V32T+gVHgjqFtE=;
  b=Tv0DG1qvtRg0r8tFtBxqawtJqZNEKeq8JfZnZalhvI5OyrhjRFVeXCZw
   YUqVJDU+ioztd4gWPABdM6d5NCrfaYLQoKXqQ/7saf/RvaSqRY3fL+72F
   VJXKjHSKa95fISy4X6zCUHo8i1vmfae7Te09V7CQ/vB5A8LlmBh4Qjw/M
   pLFSkRkJNxtub+65pv130YGtm1/ETXUrBqhutcVNY/JBJscjTiLKoPBUJ
   o8KWVuJ2jecsE42cz9AgGWrCM1Tt03HSPAP5fpfg13MqaKkVTIdkU1kcL
   KzEEnZVx7sxBYe8vpRlOwoldvBb/3En7Z3SISe1cX+KwqeBs24A2HCIBo
   g==;
X-IronPort-AV: E=Sophos;i="5.96,319,1665471600"; 
   d="asc'?scan'208";a="131964178"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jan 2023 00:48:54 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 00:48:54 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Thu, 12 Jan 2023 00:48:52 -0700
Date:   Thu, 12 Jan 2023 07:48:29 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Jisheng Zhang <jszhang@kernel.org>
CC:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        Guo Ren <guoren@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>
Subject: Re: [PATCH v3 10/13] riscv: alternative: patch alternatives in the
 vDSO
Message-ID: <Y7+7TRv7+V0nKNiZ@wendy>
References: <20230111171027.2392-1-jszhang@kernel.org>
 <20230111171027.2392-11-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6yQljiZjzbsXjRJM"
Content-Disposition: inline
In-Reply-To: <20230111171027.2392-11-jszhang@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--6yQljiZjzbsXjRJM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Jisheng,

On Thu, Jan 12, 2023 at 01:10:24AM +0800, Jisheng Zhang wrote:
> Make it possible to use alternatives in the vDSO, so that better
> implementations can be used if possible.
>=20
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Guo Ren <guoren@kernel.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

FYI, from this patch onwards the rv32 build is broken.
Should be reproduceable with the in-tree rv32_defconfig.

Unfortunately no logs for you, I've got a CI bug to fix!

Thanks,
Conor.

> ---
>  arch/riscv/include/asm/vdso.h     |  4 ++++
>  arch/riscv/kernel/alternative.c   | 25 +++++++++++++++++++++++++
>  arch/riscv/kernel/vdso.c          |  5 -----
>  arch/riscv/kernel/vdso/vdso.lds.S |  7 +++++++
>  4 files changed, 36 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/riscv/include/asm/vdso.h b/arch/riscv/include/asm/vdso.h
> index a7644f46d0e5..f891478829a5 100644
> --- a/arch/riscv/include/asm/vdso.h
> +++ b/arch/riscv/include/asm/vdso.h
> @@ -28,8 +28,12 @@
>  #define COMPAT_VDSO_SYMBOL(base, name)						\
>  	(void __user *)((unsigned long)(base) + compat__vdso_##name##_offset)
> =20
> +extern char compat_vdso_start[], compat_vdso_end[];
> +
>  #endif /* CONFIG_COMPAT */
> =20
> +extern char vdso_start[], vdso_end[];
> +
>  #endif /* !__ASSEMBLY__ */
> =20
>  #endif /* CONFIG_MMU */
> diff --git a/arch/riscv/kernel/alternative.c b/arch/riscv/kernel/alternat=
ive.c
> index 3d4f1f32c7f6..a883a309139f 100644
> --- a/arch/riscv/kernel/alternative.c
> +++ b/arch/riscv/kernel/alternative.c
> @@ -11,7 +11,9 @@
>  #include <linux/cpu.h>
>  #include <linux/uaccess.h>
>  #include <asm/alternative.h>
> +#include <asm/module.h>
>  #include <asm/sections.h>
> +#include <asm/vdso.h>
>  #include <asm/vendorid_list.h>
>  #include <asm/sbi.h>
>  #include <asm/csr.h>
> @@ -160,6 +162,27 @@ static void __init_or_module _apply_alternatives(str=
uct alt_entry *begin,
>  				stage);
>  }
> =20
> +static void __init apply_vdso_alternatives(void)
> +{
> +	const struct elf64_hdr *hdr;
> +	const struct elf64_shdr *shdr;
> +	const struct elf64_shdr *alt;
> +	struct alt_entry *begin, *end;
> +
> +	hdr =3D (struct elf64_hdr *)vdso_start;
> +	shdr =3D (void *)hdr + hdr->e_shoff;
> +	alt =3D find_section(hdr, shdr, ".alternative");
> +	if (!alt)
> +		return;
> +
> +	begin =3D (void *)hdr + alt->sh_offset,
> +	end =3D (void *)hdr + alt->sh_offset + alt->sh_size,
> +
> +	_apply_alternatives((struct alt_entry *)begin,
> +			    (struct alt_entry *)end,
> +			    RISCV_ALTERNATIVES_BOOT);
> +}
> +
>  void __init apply_boot_alternatives(void)
>  {
>  	/* If called on non-boot cpu things could go wrong */
> @@ -168,6 +191,8 @@ void __init apply_boot_alternatives(void)
>  	_apply_alternatives((struct alt_entry *)__alt_start,
>  			    (struct alt_entry *)__alt_end,
>  			    RISCV_ALTERNATIVES_BOOT);
> +
> +	apply_vdso_alternatives();
>  }
> =20
>  /*
> diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
> index e410275918ac..4e631c098f4d 100644
> --- a/arch/riscv/kernel/vdso.c
> +++ b/arch/riscv/kernel/vdso.c
> @@ -22,11 +22,6 @@ struct vdso_data {
>  };
>  #endif
> =20
> -extern char vdso_start[], vdso_end[];
> -#ifdef CONFIG_COMPAT
> -extern char compat_vdso_start[], compat_vdso_end[];
> -#endif
> -
>  enum vvar_pages {
>  	VVAR_DATA_PAGE_OFFSET,
>  	VVAR_TIMENS_PAGE_OFFSET,
> diff --git a/arch/riscv/kernel/vdso/vdso.lds.S b/arch/riscv/kernel/vdso/v=
dso.lds.S
> index 150b1a572e61..4a0606633290 100644
> --- a/arch/riscv/kernel/vdso/vdso.lds.S
> +++ b/arch/riscv/kernel/vdso/vdso.lds.S
> @@ -40,6 +40,13 @@ SECTIONS
>  	. =3D 0x800;
>  	.text		: { *(.text .text.*) }		:text
> =20
> +	. =3D ALIGN(4);
> +	.alternative : {
> +		__alt_start =3D .;
> +		*(.alternative)
> +		__alt_end =3D .;
> +	}
> +
>  	.data		: {
>  		*(.got.plt) *(.got)
>  		*(.data .data.* .gnu.linkonce.d.*)
> --=20
> 2.38.1
>=20

--6yQljiZjzbsXjRJM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY7+7PwAKCRB4tDGHoIJi
0uEeAQD9G+uLbu+8Gxiocxeb/U5F/Z622cqxCP2S5hcdl9HrxAEA5R0sXrC2ZRY9
VB1eNSPNCHca9c/1ktnoYwr7MSa5TQc=
=LDuC
-----END PGP SIGNATURE-----

--6yQljiZjzbsXjRJM--
