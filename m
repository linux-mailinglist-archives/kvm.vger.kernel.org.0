Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1066A7193
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 17:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjCAQyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 11:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCAQyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 11:54:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAE434015
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 08:54:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 788DE6140B
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 16:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F24C433D2;
        Wed,  1 Mar 2023 16:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677689645;
        bh=ZJHIMz6Qurc7C2I/yWH+2t2TDANoy6FPff6UM9+d9iw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RVKI4Ch1yjFvcrRrpaxCVgM5wm//4lFcJfG4R3IJQnk5XYRuyUEOaCIKb7wYTSGi5
         vCZjCBHYmxeqfCMH0EuI2UdLAM626JKbz5yQssWhoGb0XghewvU7Phisz1btlux3qk
         XPNOFTnd90ucbcRFv9PSzUm3R0iaeZbpX62Jb3YL9ba5cUJeOXCwG8g5f3aIWaG7iD
         vvN9vgXLn6ymLpdGAYgGHHt2sAKoWdkdsp9onDMfR7COqjpMP6XlYFF1NvqQyeovFz
         +oS9I+GCPcnl3w+Aan4d55HHwarK2vRLFFhsskA62H1hPbohJYYCrm3pyDcAUwix9M
         y8O8oW+aVqojw==
Date:   Wed, 1 Mar 2023 16:53:58 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Liao Chang <liaochang1@huawei.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Mattias Nissler <mnissler@rivosinc.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH -next v14 10/19] riscv: Allocate user's vector context in
 the first-use trap
Message-ID: <Y/+DJmmZSFIgmEem@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-11-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="p/O4FNRjX/eMHP3j"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-11-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--p/O4FNRjX/eMHP3j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Andy,

On Fri, Feb 24, 2023 at 05:01:09PM +0000, Andy Chiu wrote:
> Vector unit is disabled by default for all user processes. Thus, a
> process will take a trap (illegal instruction) into kernel at the first
> time when it uses Vector. Only after then, the kernel allocates V
> context and starts take care of the context for that user process.
>=20
> Suggested-by: Richard Henderson <richard.henderson@linaro.org>
> Link: https://lore.kernel.org/r/3923eeee-e4dc-0911-40bf-84c34aee962d@lina=
ro.org
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---

> diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
> index 082baf2a061f..585e2c51b28e 100644
> --- a/arch/riscv/kernel/vector.c
> +++ b/arch/riscv/kernel/vector.c
> @@ -4,9 +4,19 @@
>   * Author: Andy Chiu <andy.chiu@sifive.com>
>   */
>  #include <linux/export.h>
> +#include <linux/sched/signal.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
> =20
> +#include <asm/thread_info.h>
> +#include <asm/processor.h>
> +#include <asm/insn.h>
>  #include <asm/vector.h>
>  #include <asm/csr.h>
> +#include <asm/ptrace.h>
> +#include <asm/bug.h>
> =20
>  unsigned long riscv_v_vsize __read_mostly;
>  EXPORT_SYMBOL_GPL(riscv_v_vsize);
> @@ -19,3 +29,84 @@ void riscv_v_setup_vsize(void)
>  	riscv_v_disable();
>  }
> =20
> +static bool insn_is_vector(u32 insn_buf)
> +{
> +	u32 opcode =3D insn_buf & __INSN_OPCODE_MASK;
> +	bool is_vector =3D false;
> +
> +	/*
> +	 * All V-related instructions, including CSR operations are 4-Byte. So,
> +	 * do not handle if the instruction length is not 4-Byte.
> +	 */
> +	if (unlikely(GET_INSN_LENGTH(insn_buf) !=3D 4))
> +		return false;
> +
> +	switch (opcode) {
> +	case RVV_OPCODE_VECTOR:
> +		is_vector =3D true;
> +		break;
> +	case RVV_OPCODE_VL:

> +	case RVV_OPCODE_VS:
> +		u32 width =3D RVV_EXRACT_VL_VS_WIDTH(insn_buf);
> +
> +		if (width =3D=3D RVV_VL_VS_WIDTH_8 || width =3D=3D RVV_VL_VS_WIDTH_16 =
||
> +		    width =3D=3D RVV_VL_VS_WIDTH_32 || width =3D=3D RVV_VL_VS_WIDTH_64)
> +			is_vector =3D true;
> +		break;
> +	case RVG_OPCODE_SYSTEM:
> +		u32 csr =3D RVG_EXTRACT_SYSTEM_CSR(insn_buf);
> +
> +		if ((csr >=3D CSR_VSTART && csr <=3D CSR_VCSR) ||
> +		    (csr >=3D CSR_VL && csr <=3D CSR_VLENB))
> +			is_vector =3D true;
> +		break;
> +	}

Unfortunately, this is not valid code:
/stuff/linux/arch/riscv/kernel/vector.c:50:3: error: expected expression
                u32 width =3D RVV_EXRACT_VL_VS_WIDTH(insn_buf);
                ^
/stuff/linux/arch/riscv/kernel/vector.c:52:7: error: use of undeclared iden=
tifier 'width'
                if (width =3D=3D RVV_VL_VS_WIDTH_8 || width =3D=3D RVV_VL_V=
S_WIDTH_16 ||
                    ^
/stuff/linux/arch/riscv/kernel/vector.c:52:37: error: use of undeclared ide=
ntifier 'width'
                if (width =3D=3D RVV_VL_VS_WIDTH_8 || width =3D=3D RVV_VL_V=
S_WIDTH_16 ||
                                                  ^
/stuff/linux/arch/riscv/kernel/vector.c:53:7: error: use of undeclared iden=
tifier 'width'
                    width =3D=3D RVV_VL_VS_WIDTH_32 || width =3D=3D RVV_VL_=
VS_WIDTH_64)
                    ^
/stuff/linux/arch/riscv/kernel/vector.c:53:38: error: use of undeclared ide=
ntifier 'width'
                    width =3D=3D RVV_VL_VS_WIDTH_32 || width =3D=3D RVV_VL_=
VS_WIDTH_64)
                                                   ^
/stuff/linux/arch/riscv/kernel/vector.c:57:3: error: expected expression
                u32 csr =3D RVG_EXTRACT_SYSTEM_CSR(insn_buf);
                ^
/stuff/linux/arch/riscv/kernel/vector.c:59:8: error: use of undeclared iden=
tifier 'csr'
                if ((csr >=3D CSR_VSTART && csr <=3D CSR_VCSR) ||
                     ^
/stuff/linux/arch/riscv/kernel/vector.c:59:29: error: use of undeclared ide=
ntifier 'csr'
                if ((csr >=3D CSR_VSTART && csr <=3D CSR_VCSR) ||
                                          ^
/stuff/linux/arch/riscv/kernel/vector.c:60:8: error: use of undeclared iden=
tifier 'csr'
                    (csr >=3D CSR_VL && csr <=3D CSR_VLENB))
                     ^
/stuff/linux/arch/riscv/kernel/vector.c:60:25: error: use of undeclared ide=
ntifier 'csr'
                    (csr >=3D CSR_VL && csr <=3D CSR_VLENB))
                                      ^
10 errors generated.
make[5]: *** [/stuff/linux/scripts/Makefile.build:252: arch/riscv/kernel/ve=
ctor.o] Error 1

:/

--p/O4FNRjX/eMHP3j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/+DJgAKCRB4tDGHoIJi
0lLaAP0QW27CObwxtZceLleA+ttTHug+obavwVf9fnbqudDIDgD/c2lWRU+FHw9l
XNDDmCOabPEYhZ1A/vaSPygpCtElZQg=
=bTyP
-----END PGP SIGNATURE-----

--p/O4FNRjX/eMHP3j--
