Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C86644D6E
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 21:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiLFUod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 15:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiLFUob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 15:44:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837F743852;
        Tue,  6 Dec 2022 12:44:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46E03B815F6;
        Tue,  6 Dec 2022 20:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D78DC433D6;
        Tue,  6 Dec 2022 20:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670359468;
        bh=VyFPKDskm09hB3DBPKUEg9fDFjmHc83whLCSf6+IOc8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IqE4P1ST/kOEAMpHGncY2mQC42fpXvtPwi7fEW4ygWIoFXRBQwuTgi+T4Oj1cPt5U
         PcjNwTHqkBmsHx/9f43E+84ht/2lDZommmLHFk+mU3z1b9QLM7RJQOx6kV11zhvH3r
         P5nikwVYyFulq41FCiW40m3CjFGxVG9GoTFMzcCPWle7Ea+HjyVFxQrp4HhjtxEwi/
         +0uNRruA6Qk6w9CyFMhuXtIQyt0LHEe/dVvePp/0v4RJtT3kfWGs3eidwAFiA38Uv5
         cG6SSrO4TkMC9CGupB9JjNKVwRsNOqoTu+l8T9neSqXAK5HoiDJgMvjSnEO23A++f9
         txRPoFxC8sExw==
Date:   Tue, 6 Dec 2022 20:44:23 +0000
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
Subject: Re: [PATCH v2 08/13] riscv: module: move find_section to module.h
Message-ID: <Y4+pp6XEu3GSWCiE@spud>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <20221204174632.3677-9-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Kfeymfl++SYTH9yC"
Content-Disposition: inline
In-Reply-To: <20221204174632.3677-9-jszhang@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Kfeymfl++SYTH9yC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2022 at 01:46:27AM +0800, Jisheng Zhang wrote:
> Move it to the header so that the implementation can be shared
> by the alternatives code.

I'm not a super big fan of these perfunctory commit messages.
Maybe I'm being a bit ornery, but a few words about why the alternatives
could benefit from this would be nice. Also, s/it/find_section()/ please.

How about:
> Move find_section() to module.h so that the implementation can be shared
> by the alternatives code. This will allow us to use alternatives in
> the vdso.


> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---
>  arch/riscv/include/asm/module.h | 15 +++++++++++++++
>  arch/riscv/kernel/module.c      | 15 ---------------

Silly question maybe, but is module.h the right place to put this?
But I have nothing better to suggest, and I hate bikeshedding stuff when
I have no suggestion to make.

Rationale behind the movement seems grand to me though, so I suppose:
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

>  2 files changed, 15 insertions(+), 15 deletions(-)
>=20
> diff --git a/arch/riscv/include/asm/module.h b/arch/riscv/include/asm/mod=
ule.h
> index 76aa96a9fc08..78722a79fc59 100644
> --- a/arch/riscv/include/asm/module.h
> +++ b/arch/riscv/include/asm/module.h
> @@ -111,4 +111,19 @@ static inline struct plt_entry *get_plt_entry(unsign=
ed long val,
> =20
>  #endif /* CONFIG_MODULE_SECTIONS */
> =20
> +static inline const Elf_Shdr *find_section(const Elf_Ehdr *hdr,
> +					   const Elf_Shdr *sechdrs,
> +					   const char *name)
> +{
> +	const Elf_Shdr *s, *se;
> +	const char *secstrs =3D (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offse=
t;
> +
> +	for (s =3D sechdrs, se =3D sechdrs + hdr->e_shnum; s < se; s++) {
> +		if (strcmp(name, secstrs + s->sh_name) =3D=3D 0)
> +			return s;
> +	}
> +
> +	return NULL;
> +}
> +
>  #endif /* _ASM_RISCV_MODULE_H */
> diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
> index 91fe16bfaa07..76f4b9c2ec5b 100644
> --- a/arch/riscv/kernel/module.c
> +++ b/arch/riscv/kernel/module.c
> @@ -429,21 +429,6 @@ void *module_alloc(unsigned long size)
>  }
>  #endif
> =20
> -static const Elf_Shdr *find_section(const Elf_Ehdr *hdr,
> -				    const Elf_Shdr *sechdrs,
> -				    const char *name)
> -{
> -	const Elf_Shdr *s, *se;
> -	const char *secstrs =3D (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offse=
t;
> -
> -	for (s =3D sechdrs, se =3D sechdrs + hdr->e_shnum; s < se; s++) {
> -		if (strcmp(name, secstrs + s->sh_name) =3D=3D 0)
> -			return s;
> -	}
> -
> -	return NULL;
> -}
> -
>  int module_finalize(const Elf_Ehdr *hdr,
>  		    const Elf_Shdr *sechdrs,
>  		    struct module *me)
> --=20
> 2.37.2
>=20

--Kfeymfl++SYTH9yC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY4+ppwAKCRB4tDGHoIJi
0vdPAPwMCMePiLIxdM2S19748MS5S9G5teWeIfVGdq6nal4HMQD/a2JizR3i5tUB
H5BxI52RGgMvF963Rr0R5Ftrp24+yQw=
=/QTm
-----END PGP SIGNATURE-----

--Kfeymfl++SYTH9yC--
