Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B242D668687
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 23:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjALWKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 17:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240516AbjALWJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 17:09:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6256259FA8;
        Thu, 12 Jan 2023 13:59:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17555B82037;
        Thu, 12 Jan 2023 21:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF1DC433D2;
        Thu, 12 Jan 2023 21:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673560787;
        bh=0NOyF4E6Z65xt9Hiohb2w0h8D0mwuCxqaD02RpzDSFY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I2hc3REK3bBmKKCiJg7/YaXcsJFIx+CFnh7+FC2V4HJE2ayy3KisWJniln7KK+P3f
         Tq4qYYqr+oPg4LBD/AGvheBLze01qXQA/dJ1LGZfkwuudn6hyDbpIdpVVJRZinzF8I
         wvhDNJPJ1Ed8nsNHuLJBZAu51XCZ+v3qfKZIdYwHfpq57WdCHTgdCAPhxkjRyDZMw8
         j8iWzJKwjU8wIW6CrdKre1lJrYtvnMONpFBMELuUFyK7/QhBETOHSxFMvHGvvdnWnt
         5MRW0LVDOyt5y4NTFnNdIKDuohrwo0J0Pyb1kMq9ZLpUV2RcAo24t9wy5NOf3VoAnI
         eIhAr6fP/gNLw==
Date:   Thu, 12 Jan 2023 21:59:42 +0000
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
        Andrew Jones <ajones@ventanamicro.com>,
        Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH v3 11/13] riscv: cpu_relax: switch to
 riscv_has_extension_likely()
Message-ID: <Y8CCzs4RpxcGqqqB@spud>
References: <20230111171027.2392-1-jszhang@kernel.org>
 <20230111171027.2392-12-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QG8JsR+y5+VbgxNW"
Content-Disposition: inline
In-Reply-To: <20230111171027.2392-12-jszhang@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--QG8JsR+y5+VbgxNW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2023 at 01:10:25AM +0800, Jisheng Zhang wrote:
> Switch cpu_relax() from static branch to the new helper
> riscv_has_extension_likely()
>=20
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> Reviewed-by: Guo Ren <guoren@kernel.org>

With the same caveat here as with fpu, may as well join the
posse once more...
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

> ---
>  arch/riscv/include/asm/vdso/processor.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/riscv/include/asm/vdso/processor.h b/arch/riscv/include=
/asm/vdso/processor.h
> index fa70cfe507aa..edf0e25e43d1 100644
> --- a/arch/riscv/include/asm/vdso/processor.h
> +++ b/arch/riscv/include/asm/vdso/processor.h
> @@ -10,7 +10,7 @@
> =20
>  static inline void cpu_relax(void)
>  {
> -	if (!static_branch_likely(&riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_ZIHINTP=
AUSE])) {
> +	if (!riscv_has_extension_likely(RISCV_ISA_EXT_ZIHINTPAUSE)) {
>  #ifdef __riscv_muldiv
>  		int dummy;
>  		/* In lieu of a halt instruction, induce a long-latency stall. */
> --=20
> 2.38.1
>=20
>=20
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

--QG8JsR+y5+VbgxNW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8CCzgAKCRB4tDGHoIJi
0vpbAQDkOciNUDb1ACgDtLafu0yM1I9F1mimietpzXqFxZShSgD/Vq0X6XsG3KXk
QPi8Zzl1EltZQg4xgLXgUpZCOSn5LQc=
=tW5D
-----END PGP SIGNATURE-----

--QG8JsR+y5+VbgxNW--
