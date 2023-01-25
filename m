Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA2467BF3B
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 22:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbjAYVwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 16:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236034AbjAYVwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 16:52:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EA659269
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 13:51:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98746B81BF8
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 21:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490EFC433EF;
        Wed, 25 Jan 2023 21:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674683469;
        bh=y4Dnp7P5ZAxBNlDPdekbEu7uLh7HXiQwNL2aSww+M8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kzCs/jPo8QVhjEcgWDKQG9xcpGP4SG4J0NMQGopAGMVzTRiUxw5C1sF1gKjJyJgAT
         1n0+vSlrvoeIGMBAs4DXx9gu0eFGi+QYrcqKII5zGAbZY5gNGFEJZqUC+2UNc0rIof
         FAglysKlBE7HJJpanya6p/LvFieGFKPXERgP/m8u+j0xHxZvL2PHFK9sbz/3RC1X2z
         Ag0wuP7Icf9lJXVhSFkxHodYXyZzem1ZAfPFYizTuP7VCopnebiHnaKyQ8kWdJ30x4
         8bC62nxyovNnudFlGbCEN2FIvlMob14ooaFCPVcN57PTRcYgKo6gPp0jSFe2+I7zUD
         zF7f02iGCi9OQ==
Date:   Wed, 25 Jan 2023 21:51:02 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Han-Kuan Chen <hankuan.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Changbin Du <changbin.du@intel.com>,
        Myrtle Shah <gatecat@ds0.me>
Subject: Re: [PATCH -next v13 05/19] riscv: Disable Vector Instructions for
 kernel itself
Message-ID: <Y9GkRltyP4bTCAkQ@spud>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-6-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LFlwIBge0HQUJj8n"
Content-Disposition: inline
In-Reply-To: <20230125142056.18356-6-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--LFlwIBge0HQUJj8n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 25, 2023 at 02:20:42PM +0000, Andy Chiu wrote:
> Disable vector instructions execution for kernel mode at its entrances.
>=20
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Co-developed-by: Han-Kuan Chen <hankuan.chen@sifive.com>
> Signed-off-by: Han-Kuan Chen <hankuan.chen@sifive.com>
> Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> [vineetg: split off vecreg file clearing]
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

That's a hilarious co-developed-by list for adding "| foo".
I can only assume that this is mostly related to the asm that was
removed by Vineet?

Either way:
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

> ---
>  arch/riscv/kernel/entry.S |  6 +++---
>  arch/riscv/kernel/head.S  | 12 ++++++------
>  2 files changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
> index 99d38fdf8b18..e38676d9a0d6 100644
> --- a/arch/riscv/kernel/entry.S
> +++ b/arch/riscv/kernel/entry.S
> @@ -77,10 +77,10 @@ _save_context:
>  	 * Disable user-mode memory access as it should only be set in the
>  	 * actual user copy routines.
>  	 *
> -	 * Disable the FPU to detect illegal usage of floating point in kernel
> -	 * space.
> +	 * Disable the FPU/Vector to detect illegal usage of floating point
> +	 * or vector in kernel space.
>  	 */
> -	li t0, SR_SUM | SR_FS
> +	li t0, SR_SUM | SR_FS_VS
> =20
>  	REG_L s0, TASK_TI_USER_SP(tp)
>  	csrrc s1, CSR_STATUS, t0
> diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
> index ea803c96eeff..7cc975ce619d 100644
> --- a/arch/riscv/kernel/head.S
> +++ b/arch/riscv/kernel/head.S
> @@ -140,10 +140,10 @@ secondary_start_sbi:
>  	.option pop
> =20
>  	/*
> -	 * Disable FPU to detect illegal usage of
> -	 * floating point in kernel space
> +	 * Disable FPU & VECTOR to detect illegal usage of
> +	 * floating point or vector in kernel space
>  	 */
> -	li t0, SR_FS
> +	li t0, SR_FS_VS
>  	csrc CSR_STATUS, t0
> =20
>  	/* Set trap vector to spin forever to help debug */
> @@ -234,10 +234,10 @@ pmp_done:
>  .option pop
> =20
>  	/*
> -	 * Disable FPU to detect illegal usage of
> -	 * floating point in kernel space
> +	 * Disable FPU & VECTOR to detect illegal usage of
> +	 * floating point or vector in kernel space
>  	 */
> -	li t0, SR_FS
> +	li t0, SR_FS_VS
>  	csrc CSR_STATUS, t0
> =20
>  #ifdef CONFIG_RISCV_BOOT_SPINWAIT
> --=20
> 2.17.1
>=20

--LFlwIBge0HQUJj8n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9GkRgAKCRB4tDGHoIJi
0jYZAP4+hFLKZ79vgyldR0weanvD2UvzyTF9OZQfv78TqGDBDwD+OwG1JW0JzlYc
kcJqCmvvauLvdwkGgnM/f3XnrUfedgA=
=dZEs
-----END PGP SIGNATURE-----

--LFlwIBge0HQUJj8n--
