Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512A266868B
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 23:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239644AbjALWI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 17:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbjALWIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 17:08:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4743055A;
        Thu, 12 Jan 2023 13:58:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6608962174;
        Thu, 12 Jan 2023 21:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67757C433EF;
        Thu, 12 Jan 2023 21:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673560713;
        bh=7jTaJPvuFk3LTd+EW/43yasn0cm+vCcnFWd5jX7gIis=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IL48f8XvKLiusCJp4ccWYIQeJzZJbm8EHCTbPfE37jhT0KAB4cAKQySL7va3f2QjW
         mNHmYqvxoeJkH3i9HJAf4urjWGBop22TOs34s4UhHhAIx4MbjqzHPO2aju732NrDZi
         7hJZetVVgiDXYAjA9GWKGoabx8W2xgGIbvQsxZUivkZqcPd/ZuZYCyNyoV6/V3KJJz
         kRx6Hhwku1QrDEjHg52YO5z5ZBiPEyl05/AJJcx2PFUOsWlm8v+balFNYP02bKBknA
         A/mWbH3bnSP9LlBZFmAcjcfl7X8/m1RSfvxRY1eWtOaLoJkeVVn3KHw0Ov7Q1KIhOn
         R346rOTBEMufQ==
Date:   Thu, 12 Jan 2023 21:58:28 +0000
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
Subject: Re: [PATCH v3 07/13] riscv: fpu: switch has_fpu() to
 riscv_has_extension_likely()
Message-ID: <Y8CChK9XBXTcT9wn@spud>
References: <20230111171027.2392-1-jszhang@kernel.org>
 <20230111171027.2392-8-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iRz1zVDwSZkikdOy"
Content-Disposition: inline
In-Reply-To: <20230111171027.2392-8-jszhang@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--iRz1zVDwSZkikdOy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2023 at 01:10:21AM +0800, Jisheng Zhang wrote:
> Switch has_fpu() from statich branch to the new helper

s/statich/static

> riscv_has_extension_likely().
>=20
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>

Modulo whatever psuedo-cpufeature shenanigans require renaming the
function, you can tack my name onto this list also...
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

> ---
>  arch/riscv/include/asm/switch_to.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/=
switch_to.h
> index 11463489fec6..60f8ca01d36e 100644
> --- a/arch/riscv/include/asm/switch_to.h
> +++ b/arch/riscv/include/asm/switch_to.h
> @@ -59,7 +59,8 @@ static inline void __switch_to_aux(struct task_struct *=
prev,
> =20
>  static __always_inline bool has_fpu(void)
>  {
> -	return static_branch_likely(&riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_FPU]);
> +	return riscv_has_extension_likely(RISCV_ISA_EXT_f) ||
> +		riscv_has_extension_likely(RISCV_ISA_EXT_d);
>  }
>  #else
>  static __always_inline bool has_fpu(void) { return false; }
> --=20
> 2.38.1
>=20
>=20
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

--iRz1zVDwSZkikdOy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8CChAAKCRB4tDGHoIJi
0vMiAP9YCgcxsMTZYYbLVAwFZL6doa/5LBmvynF1gtdgW+gvJQD/exnea7hq1CJf
2Xqcb22dMHywHjgYJqShWDxjhTgn1Qs=
=Hsd8
-----END PGP SIGNATURE-----

--iRz1zVDwSZkikdOy--
