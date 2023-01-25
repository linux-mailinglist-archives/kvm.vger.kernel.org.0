Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEF667BDEC
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 22:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236322AbjAYVP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 16:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234993AbjAYVP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 16:15:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612A5C4
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 13:15:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ABC5B81BA4
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 21:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996CEC433D2;
        Wed, 25 Jan 2023 21:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674681353;
        bh=uXCPpInlcVIhGM5Zbz3rpQ2I6qyXx+ffowFClSGgvpQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dlj4wuBtyHd1FXSj2RR8DXwcISoRLlxVhEB4NhVzE6D6WXyrqO5OHLfNPT5T8ZMRT
         7KjycTQ/YePTEDqGg3pB0OmjkNUzEi9HgHN76uThpgOGsucQxwJqvVmbJkBZUoZ/7W
         dcZRzcHTCeGy7t4wYDUQ3FMRoBL2TPM5PZ59T39yrRUPSnFn/YqS7lyQ7eOAZjAC2h
         2McR7ucoD+x7vPnVF/NqfFT3qbyrHakE5v4fbvgOX/VfTYfUg4hX2bAQH1QoVwMmLR
         ONX/1Y1ByGWUhp2jcQradqtPeI75TOggiGcBCGSvVHJkJseLzsRZm8tQWgarWijlko
         iKqUO+xOCYleQ==
Date:   Wed, 25 Jan 2023 21:15:48 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Guo Ren <ren_guo@c-sky.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Jisheng Zhang <jszhang@kernel.org>
Subject: Re: [PATCH -next v13 01/19] riscv: Rename __switch_to_aux -> fpu
Message-ID: <Y9GcBGx6UrcVcK6y@spud>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-2-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ppdQFH89KdaPB4Y+"
Content-Disposition: inline
In-Reply-To: <20230125142056.18356-2-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ppdQFH89KdaPB4Y+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 25, 2023 at 02:20:38PM +0000, Andy Chiu wrote:
> From: Guo Ren <ren_guo@c-sky.com>
>=20
> The name of __switch_to_aux is not clear and rename it with the
> determine function: __switch_to_fpu. Next we could add other regs'
> switch.
>=20
> Signed-off-by: Guo Ren <ren_guo@c-sky.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>

With your SoB added here:
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

> ---
>  arch/riscv/include/asm/switch_to.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/=
switch_to.h
> index 11463489fec6..df1aa589b7fd 100644
> --- a/arch/riscv/include/asm/switch_to.h
> +++ b/arch/riscv/include/asm/switch_to.h
> @@ -46,7 +46,7 @@ static inline void fstate_restore(struct task_struct *t=
ask,
>  	}
>  }
> =20
> -static inline void __switch_to_aux(struct task_struct *prev,
> +static inline void __switch_to_fpu(struct task_struct *prev,
>  				   struct task_struct *next)
>  {
>  	struct pt_regs *regs;
> @@ -65,7 +65,7 @@ static __always_inline bool has_fpu(void)
>  static __always_inline bool has_fpu(void) { return false; }
>  #define fstate_save(task, regs) do { } while (0)
>  #define fstate_restore(task, regs) do { } while (0)
> -#define __switch_to_aux(__prev, __next) do { } while (0)
> +#define __switch_to_fpu(__prev, __next) do { } while (0)
>  #endif
> =20
>  extern struct task_struct *__switch_to(struct task_struct *,
> @@ -76,7 +76,7 @@ do {							\
>  	struct task_struct *__prev =3D (prev);		\
>  	struct task_struct *__next =3D (next);		\
>  	if (has_fpu())					\
> -		__switch_to_aux(__prev, __next);	\
> +		__switch_to_fpu(__prev, __next);	\
>  	((last) =3D __switch_to(__prev, __next));		\
>  } while (0)
> =20
> --=20
> 2.17.1
>=20

--ppdQFH89KdaPB4Y+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9GcBAAKCRB4tDGHoIJi
0kfuAP49b/MqYdf+9eQn9ErWfLX+NZl9L1C8IpgUe++nDq/usQD/S0DmMADE72Ts
vbNd85Fvij4E8Q+ufJaRgoyyLffaXAE=
=WV4W
-----END PGP SIGNATURE-----

--ppdQFH89KdaPB4Y+--
