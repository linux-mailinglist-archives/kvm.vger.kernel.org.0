Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA66668564
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 22:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240492AbjALVbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 16:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240618AbjALVaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 16:30:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828AA5D419;
        Thu, 12 Jan 2023 13:11:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DDE4B82028;
        Thu, 12 Jan 2023 21:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE5CC433F0;
        Thu, 12 Jan 2023 21:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673557886;
        bh=1lv/KvuGHQRZDolHVavCfpp7julHCynpA3AX6pvaaYA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W73etmzP/d6CGmvUkDbdoac85hc30hUPm02Kv4pn0xFu4zYtLpZjEWE93CUBNxd6i
         2nu133GHYGhFhQDdUOQL9B4okHCebgBjKSmBvbIWXrNDpQ5gnur9ig105lzUkf5Fxw
         k4nH+XqvNA/uPVc9r+2x6RT0P/mnPg5ZwR9xkkPvqF7nuQQrTet00VDk2+qEjKc2lt
         aULGfARm5St002zse5h/cpBDOXNCJ9vMOyMgq1PQjiJgFJHxCZLmpALsAMzY0k6bTC
         9qvVz0cXHBmLWRo00/ZEjHxVfDiyQTO4OI4w+g6zlj9w6ONR0vjO+4WoTdW31GGmHJ
         s8iXAduhRnVUw==
Date:   Thu, 12 Jan 2023 21:11:22 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Andrew Jones <ajones@ventanamicro.com>
Subject: Re: [PATCH v3 03/13] riscv: cpufeature: detect
 RISCV_ALTERNATIVES_EARLY_BOOT earlier
Message-ID: <Y8B3ekXED+xY82w4@spud>
References: <20230111171027.2392-1-jszhang@kernel.org>
 <20230111171027.2392-4-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LovTwAzFAus9XXMr"
Content-Disposition: inline
In-Reply-To: <20230111171027.2392-4-jszhang@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--LovTwAzFAus9XXMr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2023 at 01:10:17AM +0800, Jisheng Zhang wrote:
> Currently riscv_cpufeature_patch_func() does nothing at the
> RISCV_ALTERNATIVES_EARLY_BOOT stage. Add a check to detect whether we
> are in this stage and exit early. This will allow us to use
> riscv_cpufeature_patch_func() for scanning of all ISA extensions.
>=20
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>

Probably overkill at this stage, but:
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

BTW, would you mind CCing me on all patches in a series if I have
previously reviewed the series? Makes life easier :)

> ---
>  arch/riscv/kernel/cpufeature.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeatur=
e.c
> index 421b3d9578cc..37e8c5e69754 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -328,6 +328,9 @@ void __init_or_module riscv_cpufeature_patch_func(str=
uct alt_entry *begin,
>  	struct alt_entry *alt;
>  	u32 tmp;
> =20
> +	if (stage =3D=3D RISCV_ALTERNATIVES_EARLY_BOOT)
> +		return;
> +
>  	for (alt =3D begin; alt < end; alt++) {
>  		if (alt->vendor_id !=3D 0)
>  			continue;
> --=20
> 2.38.1
>=20
>=20
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

--LovTwAzFAus9XXMr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8B3eQAKCRB4tDGHoIJi
0l9WAQDjvV5jMZGRfroca+fqF0wW1R9hBcmFQzlJLcSWlBTmtgD7ByB9qSa0diKz
FIYUuKDPYTNZQkruAhzCCdeHLGitswk=
=MlP/
-----END PGP SIGNATURE-----

--LovTwAzFAus9XXMr--
