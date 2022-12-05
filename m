Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F7A6433F1
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 20:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbiLETk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 14:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbiLETke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 14:40:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860EC29353;
        Mon,  5 Dec 2022 11:37:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 174A06131A;
        Mon,  5 Dec 2022 19:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6CDC433D7;
        Mon,  5 Dec 2022 19:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670269078;
        bh=wSny7RERsEy+UvZ++K0y8YLBWfl7nMC8O5faKH/dK5Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BlXA9gT0eqmwlqDoytEbsI9VfOu37m0BZQsf89RKkm4L/X+6Mnsz9vTR0N91jBoLc
         B3DeAOTuf5KRNarPtvhR7zFXHXsTOLczZljfJPdvFNDzwpxt1xTWBCqQWzxwo09uO2
         7iHqvay3TvlmYZgAFzglrP6YsOUW+2ZPP2vpQwaX2tnP66jfa2qMavGglFit/xrTMi
         Uw5Rf76NVuEjBVIPMymjBj1ZfxdXgF80x2TvkAsBmGw0lM3ZDigbbouaIn/6jVH5Sj
         6I5KCZAKJxfkgq0IPTqM+DLbwatH8e9d0dbd1T/Y37rEy02/PX//xw7H9Q6At/IjHe
         goPrJDaa2kJGw==
Date:   Mon, 5 Dec 2022 19:37:53 +0000
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
Subject: Re: [PATCH v2 05/13] riscv: cpufeature: extend
 riscv_cpufeature_patch_func to all ISA extensions
Message-ID: <Y45IkVXYshIciACY@spud>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <20221204174632.3677-6-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BmYcKwzzQlEdZjdk"
Content-Disposition: inline
In-Reply-To: <20221204174632.3677-6-jszhang@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--BmYcKwzzQlEdZjdk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2022 at 01:46:24AM +0800, Jisheng Zhang wrote:
> make the riscv_cpufeature_patch_func() scan all ISA extensions rather
> than limited feature macros.

Certainly looks like a nice cleanup. Perhaps for the changelog,
something along the lines of:

"riscv_cpufeature_patch_func() currently only scans a limited set of
cpufeatures, explicitly defined with macros. Extend it to probe for all
ISA extensions"

>=20
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  arch/riscv/include/asm/errata_list.h |  9 ++--
>  arch/riscv/kernel/cpufeature.c       | 73 +++++-----------------------
>  2 files changed, 15 insertions(+), 67 deletions(-)

> @@ -311,25 +264,23 @@ void __init_or_module riscv_cpufeature_patch_func(s=
truct alt_entry *begin,
>  	for (alt =3D begin; alt < end; alt++) {
>  		if (alt->vendor_id !=3D 0)
>  			continue;
> -		if (alt->errata_id >=3D CPUFEATURE_NUMBER) {
> -			WARN(1, "This feature id:%d is not in kernel cpufeature list",
> +		if (alt->errata_id >=3D RISCV_ISA_EXT_MAX) {
> +			WARN(1, "This extension id:%d is not in ISA extension list",
>  				alt->errata_id);
>  			continue;
>  		}
> =20
> -		tmp =3D (1U << alt->errata_id);
> -		if (cpu_req_feature & tmp) {
> -			/* do the basic patching */
> -			patch_text_nosync(alt->old_ptr, alt->alt_ptr,
> -					  alt->alt_len);
> +		if (!__riscv_isa_extension_available(NULL, alt->errata_id))
> +			continue;
> =20
> -			riscv_alternative_fix_auipc_jalr(alt->old_ptr,
> -							 alt->alt_len,
> -							 alt->old_ptr - alt->alt_ptr);
> -			riscv_alternative_fix_jal(alt->old_ptr,
> -						  alt->alt_len,
> -						  alt->old_ptr - alt->alt_ptr);
> -		}
> +		/* do the basic patching */
> +		patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
> +		riscv_alternative_fix_auipc_jalr(alt->old_ptr,
> +						 alt->alt_len,
> +						 alt->old_ptr - alt->alt_ptr);
> +		riscv_alternative_fix_jal(alt->old_ptr,
> +					  alt->alt_len,
> +					  alt->old_ptr - alt->alt_ptr);

nit:
Now that you've dropped a level of indent, can alt->alt_len move up a
line?

Thanks,
Conor.


--BmYcKwzzQlEdZjdk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY45IkQAKCRB4tDGHoIJi
0hVgAP0f7h5X+BsSkUkvJUlU5ALjV6I0EekLwH8GeuYfU1EEzQEA9g48tJXXGwRo
Wncokwq3bL0VVPX5RDCVCBtQ7BgoPws=
=GI0I
-----END PGP SIGNATURE-----

--BmYcKwzzQlEdZjdk--
