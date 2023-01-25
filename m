Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665FE67BF50
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 22:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbjAYVyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 16:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235442AbjAYVyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 16:54:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E2F3A83
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 13:54:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 202E7B81BF9
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 21:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F26C433EF;
        Wed, 25 Jan 2023 21:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674683649;
        bh=ZN1uW23vOmhcaFY+mNFCJHfLFOBnYP+iaRziojbCcPU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VcvdHMggvX0H1zSapjMQFMNDQkuqHeHY+dFA8VYvbhjA4tmzSmNfeXznC5+ECr3T4
         LDZAeXz60xABhlXpoZ8S5qRSGhxRzkejKpY//kw0NU5MPfzDl2ZwZvaiK407lN1Kl2
         D46xbzqoCWE+wOWGAKwyhe9G/Kw/1/OvSwx3nuYpwK/whHP/y9NDXP86B2T1C1Ty4I
         5Zf/F2DJ/unSZEPVulAmm8QTVlBYB5dK9mzIyxJiaCn7PHjY5qlZSWq1SDrVU+gHQb
         PqM8cy5DuOydazxHlPxKzBX/JLU/CZpkA4V9Yc44O6YCh1p2Q4Arvj4kyFn/4u6sPz
         xn93rZFQ6oPDA==
Date:   Wed, 25 Jan 2023 21:54:04 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Myrtle Shah <gatecat@ds0.me>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>
Subject: Re: [PATCH -next v13 04/19] riscv: Clear vector regfile on bootup
Message-ID: <Y9Gk/FCFBbWC/Pyi@spud>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-5-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QkQd2AdTGvM4bKJV"
Content-Disposition: inline
In-Reply-To: <20230125142056.18356-5-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--QkQd2AdTGvM4bKJV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 25, 2023 at 02:20:41PM +0000, Andy Chiu wrote:
> clear vector registers on boot if kernel supports V.
>=20
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> [vineetg: broke this out to a seperate patch]
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

But this patch didn't carry over the long list of contributors from it's
source? Seems a bit odd, that's all.
There was also an Rb from Palmer that got dropped too. Was that
intentional?
https://lore.kernel.org/linux-riscv/20220921214439.1491510-6-stillson@rivos=
inc.com/

Thanks,
Conor.

> ---
>  arch/riscv/kernel/head.S | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>=20
> diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
> index b865046e4dbb..ea803c96eeff 100644
> --- a/arch/riscv/kernel/head.S
> +++ b/arch/riscv/kernel/head.S
> @@ -431,6 +431,29 @@ ENTRY(reset_regs)
>  	csrw	fcsr, 0
>  	/* note that the caller must clear SR_FS */
>  #endif /* CONFIG_FPU */
> +
> +#ifdef CONFIG_RISCV_ISA_V
> +	csrr	t0, CSR_MISA
> +	li	t1, COMPAT_HWCAP_ISA_V
> +	and	t0, t0, t1
> +	beqz	t0, .Lreset_regs_done
> +
> +	/*
> +	 * Clear vector registers and reset vcsr
> +	 * VLMAX has a defined value, VLEN is a constant,
> +	 * and this form of vsetvli is defined to set vl to VLMAX.
> +	 */
> +	li	t1, SR_VS
> +	csrs	CSR_STATUS, t1
> +	csrs	CSR_VCSR, x0
> +	vsetvli t1, x0, e8, m8, ta, ma
> +	vmv.v.i v0, 0
> +	vmv.v.i v8, 0
> +	vmv.v.i v16, 0
> +	vmv.v.i v24, 0
> +	/* note that the caller must clear SR_VS */
> +#endif /* CONFIG_RISCV_ISA_V */
> +
>  .Lreset_regs_done:
>  	ret
>  END(reset_regs)
> --=20
> 2.17.1
>=20

--QkQd2AdTGvM4bKJV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9Gk/AAKCRB4tDGHoIJi
0rg7AQDBkFQa3C0x2AvR7Zwiq+OLiMQanh8SjizKjJSc5xZCEQD9EPpHQR7bMN94
zDloGjv3VwUaOSGmqFOplaI2vx4d1QM=
=6ee2
-----END PGP SIGNATURE-----

--QkQd2AdTGvM4bKJV--
