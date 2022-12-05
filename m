Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00D1643123
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 20:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiLETK3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 14:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbiLETJw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 14:09:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764721A835;
        Mon,  5 Dec 2022 11:09:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 312E7B811EC;
        Mon,  5 Dec 2022 19:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9F5C433C1;
        Mon,  5 Dec 2022 19:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670267374;
        bh=6ugKg8XgFTkNG84QNFHtzuPWco24KqBv6OpdEDRioF0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FQ6ZDMbocsys8DvrxnXnZS67TgJYhZkYERnmdFOeolKoOj8ggiPZUAs/0ZD+Ql78i
         +77/x2EExotYgU3SpDgxtbTIeL1jKBPu8BmdHv0HbBfc4Aa5c4EQ1jCciEdlSx2Nfy
         kzvuJkVM6iVjtUrBO7KwGFXQc/CInJWMWtViYk7STVfM+VtHPxlQyxP1QpkGLTPZT0
         MhCbWkxud8JmjP0lk1ny1l2XQFZT/+Kf5WfExvxFMyjH0Gc2gE0IjTwQDwI0lytl8g
         IvLhQWnpJRfuDGyqB9Y5veYtY1lHqtXKYlKi+LKEW6Zroj69Gxl6C5xd4P37gHxhPP
         aPnxC2j5REpDw==
Date:   Mon, 5 Dec 2022 19:09:29 +0000
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
Subject: Re: [PATCH v2 03/13] riscv: cpufeature: detect
 RISCV_ALTERNATIVES_EARLY_BOOT earlier
Message-ID: <Y45B6eB0BQTSZMEa@spud>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <20221204174632.3677-4-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ROJIk5MPQ3MQ0MkM"
Content-Disposition: inline
In-Reply-To: <20221204174632.3677-4-jszhang@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ROJIk5MPQ3MQ0MkM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2022 at 01:46:22AM +0800, Jisheng Zhang wrote:
> Now, the riscv_cpufeature_patch_func() do nothing in the stage of
> RISCV_ALTERNATIVES_EARLY_BOOT. We can move the detection of "early
> boot" stage earlier.
>=20
> In following patch, we will make riscv_cpufeature_patch_func() scans
> all ISA extensions.

I'm not 100% on the motivation here. Let me try and regurgitate the
changelog in a way that makes more sense to me and maybe you can confirm
it.

Currently riscv_cpufeature_patch_func() does nothing at the
RISCV_ALTERNATIVES_EARLY_BOOT stage.
Add a check to detect whether we are in this stage and exit early.
This will allow us to use riscv_cpufeature_patch_func() for scanning of
all ISA extensions.

Would that be a correct summary?

Thanks,
Conor.

>=20
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  arch/riscv/kernel/cpufeature.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeatur=
e.c
> index 364d1fe86bea..a4d2af67e05c 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -305,6 +305,9 @@ void __init_or_module riscv_cpufeature_patch_func(str=
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
> 2.37.2
>=20

--ROJIk5MPQ3MQ0MkM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY45B6QAKCRB4tDGHoIJi
0gcWAQCiQMg5Wozpr0WVgdCehOiu3NTihv2RvGoWtlhZoCEB0QEAs910IJMPlZ99
OxKW1kxlggOReEGh+AHf4JDbq+k4VA0=
=f2RF
-----END PGP SIGNATURE-----

--ROJIk5MPQ3MQ0MkM--
