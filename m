Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B866A626A
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 23:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjB1WbV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 17:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjB1WbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 17:31:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2522ED5C
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 14:31:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC678611D5
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 22:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34D0C433D2;
        Tue, 28 Feb 2023 22:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677623477;
        bh=7/qNXPrtsBGH9MKoywHXDwQvHhOKCm3REudFDrbnPHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pRR2Z+u2PWE1yIvGGi2EGc5X+9NDnuJyz0PKr96VCyllLMlmSQ5EjuDXzk1RXOUle
         woDPeyxP/cIVb1Wc1Iapel0hgsH6bXjfHrQhIBlnX8vDijyxyUtmXwaT9PdqZf4dsX
         RK2ya0kWGQjgHbs8/t/ZC9BZQOUNLELpdfYPSwZhuqLq7c8TEhbvoeU4psFAvYCHuB
         Dmdpm+ObbjALB8Hvwl9oOSBMHCk9NxVK/4lq6nVLrPul1tpKazc1pBv1Jsjpe0o1Sv
         uJyTAsSJhx66NyiNu7K96OGetT3ljeJadYdS80nubWJ0Gp1tL18XYY4XMY0PNmjTyZ
         cCp+/P3evcsIA==
Date:   Tue, 28 Feb 2023 22:31:11 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@rivosinc.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH -next v14 03/19] riscv: Add new csr defines related to
 vector extension
Message-ID: <Y/6Ar88HPkwocNUe@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-4-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Wht2Hpp5etlnN4NY"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-4-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Wht2Hpp5etlnN4NY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2023 at 05:01:02PM +0000, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> Follow the riscv vector spec to add new csr numbers.
>=20
> [guoren@linux.alibaba.com: first porting for new vector related csr]
> Acked-by: Guo Ren <guoren@kernel.org>
> Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
> Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> [andyc: added SR_FS_VS]
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> ---
>  arch/riscv/include/asm/csr.h | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 0e571f6483d9..add51662b7c3 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -24,16 +24,24 @@
>  #define SR_FS_CLEAN	_AC(0x00004000, UL)
>  #define SR_FS_DIRTY	_AC(0x00006000, UL)
> =20
> +#define SR_VS           _AC(0x00000600, UL) /* Vector Status */
> +#define SR_VS_OFF       _AC(0x00000000, UL)
> +#define SR_VS_INITIAL   _AC(0x00000200, UL)
> +#define SR_VS_CLEAN     _AC(0x00000400, UL)
> +#define SR_VS_DIRTY     _AC(0x00000600, UL)

I just noticed that these are space-aligned, while the file uses tabs.
Could you please fix that up when you resubmit?

Thanks,
Conor.


--Wht2Hpp5etlnN4NY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/6ArwAKCRB4tDGHoIJi
0jCFAQChM2oiWmbuWIMy/5wEHYV4fPQQL3uCLSl4v07VLhZ3oQD+NTWvLvIRHkNk
SuJ8AMj4XJriJFSSCrcxOCIYLjqULAc=
=Gg4o
-----END PGP SIGNATURE-----

--Wht2Hpp5etlnN4NY--
