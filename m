Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7087167D7E3
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 22:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjAZVpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 16:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjAZVou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 16:44:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D4559244
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 13:44:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0072461957
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 21:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BF8C4339B;
        Thu, 26 Jan 2023 21:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674769488;
        bh=xyqDfL1JGPMf1a5wwoJLuSjiH0eKBEc/Vbbvcw4rKKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DlSqOEB//BF9YSpkrCceSFhFUcdkSDiLZ5BUaNeH6RJbJchug2nlDGFSRCO0l9jaG
         36la2Lkdc7plVGRg32A3wSy0OrVu2bEQD3k7BdiX/xcXD5lWsriHIlxIWmF1WrIrSp
         uKMgJiG9i46y2JVLK98NFkocZcBLymnMjuAC/cSN/dCrQMuyRatMrCr4NbtKKElobZ
         4aw69KbURbvWTDEFDAsMIWyeM5h4vEu/2E87D9QqxsBPpFd1vc2015FKQNpSKO2E//
         VaRETdQ469xh416XrA3q7Xks2emMr9JSBeRedR6MoMbzYqqBN8taIHhhLfQh7/zzyE
         X0+0xyCUQP8FQ==
Date:   Thu, 26 Jan 2023 21:44:41 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Nick Knight <nick.knight@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Ruinland Tsai <ruinland.tsai@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH -next v13 09/19] riscv: Add task switch support for vector
Message-ID: <Y9L0SXMpWWi9L1Ty@spud>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-10-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KW2ZVp0Ro7F03E3R"
Content-Disposition: inline
In-Reply-To: <20230125142056.18356-10-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--KW2ZVp0Ro7F03E3R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 25, 2023 at 02:20:46PM +0000, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> This patch adds task switch support for vector. It also supports all
> lengths of vlen.
>=20
> [guoren@linux.alibaba.com: First available porting to support vector
> context switching]
> [nick.knight@sifive.com: Rewrite vector.S to support dynamic vlen, xlen a=
nd
> code refine]
> [vincent.chen@sifive.com: Fix the might_sleep issue in vstate_save,
> vstate_restore]
> [andrew@sifive.com: Optimize task switch codes of vector]
> [ruinland.tsai@sifive.com: Fix the arch_release_task_struct free wrong
> datap issue]
> [vineetg: Fixed lkp warning with W=3D1 build]
> [andy.chiu: Use inline asm for task switches]
>=20
> Suggested-by: Andrew Waterman <andrew@sifive.com>
> Co-developed-by: Nick Knight <nick.knight@sifive.com>
> Signed-off-by: Nick Knight <nick.knight@sifive.com>
> Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Co-developed-by: Ruinland Tsai <ruinland.tsai@sifive.com>
> Signed-off-by: Ruinland Tsai <ruinland.tsai@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

More comments about what people did than patch description, lol!

Anyways, this patch breaks the build for every config we have, so please
fix that when you are re-submitting:
https://patchwork.kernel.org/project/linux-riscv/patch/20230125142056.18356=
-10-andy.chiu@sifive.com/

Any of allmodconfig, rv32_defconfig, nommu_{k210,virt}_defconfig should
reproduce with gcc 12.2 - but I have no idea if it's the same same
failures for all 4.

> ---
>  arch/riscv/include/asm/processor.h   |  1 +
>  arch/riscv/include/asm/switch_to.h   | 18 ++++++++++++++++++
>  arch/riscv/include/asm/thread_info.h |  3 +++
>  arch/riscv/include/asm/vector.h      | 26 ++++++++++++++++++++++++++
>  arch/riscv/kernel/process.c          | 18 ++++++++++++++++++
>  arch/riscv/kernel/traps.c            | 14 ++++++++++++--
>  6 files changed, 78 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/=
processor.h
> index 94a0590c6971..44d2eb381ca6 100644
> --- a/arch/riscv/include/asm/processor.h
> +++ b/arch/riscv/include/asm/processor.h
> @@ -39,6 +39,7 @@ struct thread_struct {
>  	unsigned long s[12];	/* s[0]: frame pointer */
>  	struct __riscv_d_ext_state fstate;
>  	unsigned long bad_cause;
> +	struct __riscv_v_state vstate;

__riscv_d_ext_state
__riscv_v_state

:thinking: These should ideally match, probably no harm in adding the
_ext to the v one, no?

> diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
> index 549bde5c970a..1a48ff89b2b5 100644
> --- a/arch/riscv/kernel/traps.c
> +++ b/arch/riscv/kernel/traps.c
> @@ -24,6 +24,7 @@
>  #include <asm/processor.h>
>  #include <asm/ptrace.h>
>  #include <asm/thread_info.h>
> +#include <asm/vector.h>
> =20
>  int show_unhandled_signals =3D 1;
> =20
> @@ -111,8 +112,17 @@ DO_ERROR_INFO(do_trap_insn_misaligned,
>  	SIGBUS, BUS_ADRALN, "instruction address misaligned");
>  DO_ERROR_INFO(do_trap_insn_fault,
>  	SIGSEGV, SEGV_ACCERR, "instruction access fault");
> -DO_ERROR_INFO(do_trap_insn_illegal,
> -	SIGILL, ILL_ILLOPC, "illegal instruction");
> +
> +asmlinkage __visible __trap_section void do_trap_insn_illegal(struct pt_=
regs *regs)
> +{
> +	if (has_vector() && user_mode(regs)) {
> +		if (rvv_first_use_handler(regs))

And there's your build error, as this function is only added in the next
patch.

Thanks,
Conor.

> +			return;
> +	}
> +	do_trap_error(regs, SIGILL, ILL_ILLOPC, regs->epc,
> +		      "Oops - illegal instruction");
> +}


--KW2ZVp0Ro7F03E3R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9L0SQAKCRB4tDGHoIJi
0tn4AP9v/yFBusYIxwKebvK4EVn1R/J/I88SedlTaR3LarX/9gD/Sfb4BD7eMv+a
b7Pt9ZKUlwSisCZxGA5AilyvuWwEKQc=
=LGoc
-----END PGP SIGNATURE-----

--KW2ZVp0Ro7F03E3R--
