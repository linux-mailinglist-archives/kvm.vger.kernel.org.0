Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4C0644D31
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 21:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLFUZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 15:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLFUZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 15:25:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB51DF88;
        Tue,  6 Dec 2022 12:25:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46E66B81B33;
        Tue,  6 Dec 2022 20:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8399EC433D6;
        Tue,  6 Dec 2022 20:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670358338;
        bh=NiR96ZKIvW7IpMispdHsgp2vT3FznbdvWds2IP2JVJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SQJ0xRSfGyt/EXVAtU8bHfgHspMYXuVOvWLqR/ovxSWRsgZHSw5L8LCDroazamMym
         IHqNu1g6g/kyotibAwUMred1WrpsoMAPImQGefc4DYXrOdrgw8fAawTSWGq0h4Wi9r
         CMd3P8V+cdPsG7LVmtibwhza1R6ReLm7VZi5lNEg1NvKCnDv6U8CL8CDYxXC+s4uDl
         I+AzxmxLGbGjRqSd9NdLpll15a8EqeSxZY34uM+aUlm8HP9tNFF67zu4a9huKBMsx0
         pqtLaO/fthDy4dCwev8aF6IvXXrUoub6FDpGwpuFOmpSeEWGVyQ1NY7YIsWaeNMF+i
         eTcj/cpdlspZA==
Date:   Tue, 6 Dec 2022 20:25:34 +0000
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
Subject: Re: [PATCH v2 06/13] riscv: introduce
 riscv_has_extension_[un]likely()
Message-ID: <Y4+lPiF7CpJJjmWR@spud>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <20221204174632.3677-7-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bxEn+e9TeJ7KX+1L"
Content-Disposition: inline
In-Reply-To: <20221204174632.3677-7-jszhang@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--bxEn+e9TeJ7KX+1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Jisheng,

Just a couple really minor bits here...

On Mon, Dec 05, 2022 at 01:46:25AM +0800, Jisheng Zhang wrote:
> Generally, riscv ISA extensions are fixed for any specific hardware
> platform, that's to say, the hart features won't change any more

s/that's to say, the hart/so a hart's/
s/any more//

> after booting, this chacteristic make it straightforward to use

"booting. This characteristic makes it"

> static branch to check one specific ISA extension is supported or not

"a static branch to check if a"

> to optimize performance.
>=20
> However, some ISA extensions such as SVPBMT and ZICBOM are handled
> via. the alternative sequences.
>=20
> Basically, for ease of maintenance, we prefer to use static branches
> in C code, but recently, Samuel found that the static branch usage in
> cpu_relax() breaks building with CONFIG_CC_OPTIMIZE_FOR_SIZE[1]. As
> Samuel pointed out, "Having a static branch in cpu_relax() is
> problematic because that function is widely inlined, including in some
> quite complex functions like in the VDSO. A quick measurement shows
> this static branch is responsible by itself for around 40% of the jump
> table."
>=20
> Samuel's findings pointed out one of a few downsides of static branches
> usage in C code to handle ISA extensions detected at boot time:
> static branch's metadata in the __jump_table section, which is not
> discarded after ISA extensions are finalized, wastes some space.
>=20
> I want to try to solve the issue for all possible dynamic handling of
> ISA extensions at boot time. Inspired by Mark[2], this patch introduces
> riscv_has_extension_*() helpers, which work like static branches but
> are patched using alternatives, thus the metadata can be freed after
> patching.
>=20
> [1]https://lore.kernel.org/linux-riscv/20220922060958.44203-1-samuel@shol=
land.org/
> [2]https://lore.kernel.org/linux-arm-kernel/20220912162210.3626215-8-mark=
=2Erutland@arm.com/

Can you make these into Link: tags please (and drop the line between the
and the SoB)? So:

Link: https://lore.kernel.org/linux-riscv/20220922060958.44203-1-samuel@sho=
lland.org/ [1]
Link: https://lore.kernel.org/linux-arm-kernel/20220912162210.3626215-8-mar=
k.rutland@arm.com/ [2]
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Changes themselves look grand, no comments there :)

Thanks!
Conor.

> ---
>  arch/riscv/include/asm/hwcap.h | 37 ++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>=20
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwca=
p.h
> index 996884986fea..e2d3f6df7701 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -8,6 +8,7 @@
>  #ifndef _ASM_RISCV_HWCAP_H
>  #define _ASM_RISCV_HWCAP_H
> =20
> +#include <asm/alternative-macros.h>
>  #include <asm/errno.h>
>  #include <linux/bits.h>
>  #include <uapi/asm/hwcap.h>
> @@ -96,6 +97,42 @@ static __always_inline int riscv_isa_ext2key(int num)
>  	}
>  }
> =20
> +static __always_inline bool
> +riscv_has_extension_likely(const unsigned long ext)
> +{
> +	compiletime_assert(ext < RISCV_ISA_EXT_MAX,
> +			   "ext must be < RISCV_ISA_EXT_MAX");
> +
> +	asm_volatile_goto(
> +	ALTERNATIVE("j	%l[l_no]", "nop", 0, %[ext], 1)
> +	:
> +	: [ext] "i" (ext)
> +	:
> +	: l_no);
> +
> +	return true;
> +l_no:
> +	return false;
> +}
> +
> +static __always_inline bool
> +riscv_has_extension_unlikely(const unsigned long ext)
> +{
> +	compiletime_assert(ext < RISCV_ISA_EXT_MAX,
> +			   "ext must be < RISCV_ISA_EXT_MAX");
> +
> +	asm_volatile_goto(
> +	ALTERNATIVE("nop", "j	%l[l_yes]", 0, %[ext], 1)
> +	:
> +	: [ext] "i" (ext)
> +	:
> +	: l_yes);
> +
> +	return false;
> +l_yes:
> +	return true;
> +}
> +
>  unsigned long riscv_isa_extension_base(const unsigned long *isa_bitmap);
> =20
>  #define riscv_isa_extension_mask(ext) BIT_MASK(RISCV_ISA_EXT_##ext)
> --=20
> 2.37.2
>=20

--bxEn+e9TeJ7KX+1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY4+lPQAKCRB4tDGHoIJi
0ioQAP4w8r5FQ0ejEXDGcp8UvPntHNhPculcXC9z8LBnhOgVggEAzzZHQlX1lhJN
t6WlREfcRjs9PY31RoG5eskhVoUzrg4=
=bz9l
-----END PGP SIGNATURE-----

--bxEn+e9TeJ7KX+1L--
