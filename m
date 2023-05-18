Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C64708731
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 19:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjERRsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 13:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjERRrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 13:47:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBEEA9
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 10:47:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02D276510A
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 17:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320B3C433EF;
        Thu, 18 May 2023 17:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684432061;
        bh=USjwvx+K9igUSpQ4sS7LlyJXHC3ABEpSlAR4iN8rmMQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AotWzmcqKomLPCgLrJlJ0tI49tPiaVnSHeIJe5+CaNXdW1+ykdhyW3sARApMc88uC
         s7CcqkidDKMLb0Jx2HRIS/Vr9/RnI1m1jev4G1PKHLQZHnG2hQaVWZ62KqbKqjX9BR
         f+o5Ars5P17nDwTO8eEKHyfm/u84NQ+BQiHe9E/Of9X0Ptoy3y2ndbVhIEhikr/1FZ
         twcEV3PGC3cIk1teeyNuW2XHycCeBWqEj1JJq+m/vd2HRKZ+vRuf1y1a7Y8Q6qF5Ey
         AVT/Io/XbzsEB2MzEHX0SiRH+4BEuA7ljRKutDyIpfW4YZpHys5qsDTR+YgKEYDkvc
         3ZXkjlwKc9ygw==
Date:   Thu, 18 May 2023 18:47:34 +0100
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
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
        Mattias Nissler <mnissler@rivosinc.com>
Subject: Re: [PATCH -next v20 11/26] riscv: Allocate user's vector context in
 the first-use trap
Message-ID: <20230518-external-sixteen-f2d2ae444547@spud>
References: <20230518161949.11203-1-andy.chiu@sifive.com>
 <20230518161949.11203-12-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JqzHJXxaEWN8S6RA"
Content-Disposition: inline
In-Reply-To: <20230518161949.11203-12-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--JqzHJXxaEWN8S6RA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 18, 2023 at 04:19:34PM +0000, Andy Chiu wrote:
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
> Hey Heiko and Conor, I am dropping you guys' A-b, T-b, and R-b because I
> added a check in riscv_v_first_use_handler().

> +bool riscv_v_first_use_handler(struct pt_regs *regs)
> +{
> +	u32 __user *epc =3D (u32 __user *)regs->epc;
> +	u32 insn =3D (u32)regs->badaddr;
> +
> +	/* Do not handle if V is not supported, or disabled */
> +	if (!has_vector() || !(elf_hwcap & COMPAT_HWCAP_ISA_V))
> +		return false;

Remind me please, in what situation is this actually even possible?
The COMPAT_HWCAP_ISA_V flag only gets set if CONFIG_RISCV_ISA_V is
enabled & v is in the DT.
has_vector() is backed by different things whether alternatives are
enabled or not. With alternatives, it depends on the bit being set in
the riscv_isa bitmap & the Kconfig option.
Without alternatives it is backed by __riscv_isa_extension_available()
which only depends in the riscv_isa bitmap.
Since the bit in the bitmap does not get cleared if CONFIG_RISCV_ISA_V
is not set, unlike the elf_hwcap bit which does, it seems like this
might be the condition you are trying to prevent?

If so,
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Otherwise, please let me know where I have gone wrong!

Thanks,
Conor.

--JqzHJXxaEWN8S6RA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZGZktgAKCRB4tDGHoIJi
0jBjAP43M+8VnOUuyPI5wMK5s570SUnfEYjrVN/aExukXNTvhgEAusFeyqLf8+Jz
+H7+bvlRv8qn/5r5HUv8o62L8hDZlwQ=
=klJB
-----END PGP SIGNATURE-----

--JqzHJXxaEWN8S6RA--
