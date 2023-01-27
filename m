Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0F767EF94
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 21:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbjA0UbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 15:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjA0UbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 15:31:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A09679216
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 12:31:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE983B821D3
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 20:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46583C433D2;
        Fri, 27 Jan 2023 20:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674851469;
        bh=CH9vEXq6cjjQQuKc4yHsTcQj0RJXiIwEwwGW9/HaeAs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qqzqOWUkTX1njH4vxEp03WTDozfnO7zH73gbFdvNqaASt8KeCO7tc6v1r5yH1J+Qz
         MbFOaaY/AtlXhN6ba+eG+YOPxWzr09nQFtXi2JrYNke8xGEhuxnTgycz5Eh0vJfA4w
         dFKa4RAL+6nCcZBwv22Alf/1lVnfnx2aJB8VciYkLEZQNnCZnSGs4ir+9C+5g6aA75
         UPuOCSqTRKKu98fPJU+DSDMToDRr+cI+UcrGemRnhq16Si0GmBFUrWjDUdKqTdgewQ
         Z5lHkRpDgO/WCFwssL37ok96kqMr5DlI+ToI7eCc6dQMDNYUDrANNPtXh6UokFc/N6
         zR680/bsVlx/Q==
Date:   Fri, 27 Jan 2023 20:31:03 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, ShihPo Hung <shihpo.hung@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Myrtle Shah <gatecat@ds0.me>
Subject: Re: [PATCH -next v13 15/19] riscv: Fix a kernel panic issue if $s2
 is set to a specific value before entering Linux
Message-ID: <Y9Q0h88UL0BRaF8d@spud>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-16-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Jy5FtS70Bk/OQG7w"
Content-Disposition: inline
In-Reply-To: <20230125142056.18356-16-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Jy5FtS70Bk/OQG7w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Andy,

On Wed, Jan 25, 2023 at 02:20:52PM +0000, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> Panic log:
> [    0.018707] Unable to handle kernel NULL pointer dereference at virtua=
l address 0000000000000000
> [    0.023060] Oops [#1]
> [    0.023214] Modules linked in:
> [    0.023725] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.14.0 #33
> [    0.023955] Hardware name: SiFive,FU800 (DT)
> [    0.024150] epc : __vstate_save+0x1c/0x48
> [    0.024654]  ra : arch_dup_task_struct+0x70/0x108
> [    0.024815] epc : ffffffff80005ad8 ra : ffffffff800035a8 sp : ffffffff=
81203d50
> [    0.025020]  gp : ffffffff812e8290 tp : ffffffff8120bdc0 t0 : 00000000=
00000000
> [    0.025216]  t1 : 0000000000000000 t2 : 0000000000000000 s0 : ffffffff=
81203d80
> [    0.025424]  s1 : ffffffff8120bdc0 a0 : ffffffff8120c820 a1 : 00000000=
00000000
> [    0.025659]  a2 : 0000000000001000 a3 : 0000000000000000 a4 : 00000000=
00000600
> [    0.025869]  a5 : ffffffff8120cdc0 a6 : ffffffe00160b400 a7 : ffffffff=
80a1fe60
> [    0.026069]  s2 : ffffffe0016b8000 s3 : ffffffff81204000 s4 : 00000000=
00004000
> [    0.026267]  s5 : 0000000000000000 s6 : ffffffe0016b8000 s7 : ffffffe0=
016b9000
> [    0.026475]  s8 : ffffffff81203ee0 s9 : 0000000000800300 s10: ffffffff=
812e9088
> [    0.026689]  s11: ffffffd004008000 t3 : 0000000000000000 t4 : 00000000=
00000100
> [    0.026900]  t5 : 0000000000000600 t6 : ffffffe00167bcc4
> [    0.027057] status: 8000000000000720 badaddr: 0000000000000000 cause: =
000000000000000f
> [    0.027344] [<ffffffff80005ad8>] __vstate_save+0x1c/0x48
> [    0.027567] [<ffffffff8000abe8>] copy_process+0x266/0x11a0
> [    0.027739] [<ffffffff8000bc98>] kernel_clone+0x90/0x2aa
> [    0.027915] [<ffffffff8000c062>] kernel_thread+0x76/0x92
> [    0.028075] [<ffffffff8072e34c>] rest_init+0x26/0xfc
> [    0.028242] [<ffffffff80800638>] arch_call_rest_init+0x10/0x18
> [    0.028423] [<ffffffff80800c4a>] start_kernel+0x5ce/0x5fe
> [    0.029188] ---[ end trace 9a59af33f7ba3df4 ]---
> [    0.029479] Kernel panic - not syncing: Attempted to kill the idle tas=
k!
> [    0.029907] ---[ end Kernel panic - not syncing: Attempted to kill the=
 idle task! ]---
>=20
> The NULL pointer accessing caused the kernel panic. There is a NULL
> pointer is because in vstate_save() function it will check
> (regs->status & SR_VS) =3D=3D SR_VS_DIRTY and this is true, but it should=
n't
> be true because vector is not used here. Since vector is not used, datap
> won't be allocated so it is NULL. The reason why regs->status is set to
> a wrong value is because pt_regs->status is put in stack and it is pollut=
ed
> after setup_vm() called.
>=20
> In prologue of setup_vm(), we can observe it will save s2 to stack however
> s2 is meaningless here because the caller is assembly code and s2 is just
> some value from previous stage. The compiler will base on calling
> convention to save the register to stack. Then 0x80008638 in s2 is saved
> to stack. It might be any value. In this failure case it is 0x80008638 and
> it will accidentally cause SR_VS_DIRTY to call the vstate_save() function.

> diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
> index 7cc975ce619d..512ebad013aa 100644
> --- a/arch/riscv/kernel/head.S
> +++ b/arch/riscv/kernel/head.S
> @@ -301,6 +301,7 @@ clear_bss_done:
>  	la tp, init_task
>  	la sp, init_thread_union + THREAD_SIZE
>  	XIP_FIXUP_OFFSET sp
> +	addi sp, sp, -PT_SIZE
>  #ifdef CONFIG_BUILTIN_DTB
>  	la a0, __dtb_start
>  	XIP_FIXUP_OFFSET a0
> @@ -318,6 +319,7 @@ clear_bss_done:
>  	/* Restore C environment */
>  	la tp, init_task
>  	la sp, init_thread_union + THREAD_SIZE
> +	addi sp, sp, -PT_SIZE

I've got no idea about this stuff, so I was just poking around at
existing, similar bits of asm.
grepping for code that does this (with your series applied), you are
the only one who is using PT_SIZE rather than PT_SIZE_ON_STACK:
rg "\bPT_SIZE" arch/riscv
arch/riscv/kernel/head.S
304:	addi sp, sp, -PT_SIZE
322:	addi sp, sp, -PT_SIZE

arch/riscv/kernel/asm-offsets.c
78:	DEFINE(PT_SIZE, sizeof(struct pt_regs));
472:	DEFINE(PT_SIZE_ON_STACK, ALIGN(sizeof(struct pt_regs), STACK_ALIGN));

arch/riscv/kernel/probes/rethook_trampoline.S
79:	addi sp, sp, -(PT_SIZE_ON_STACK)
90:	addi sp, sp, PT_SIZE_ON_STACK

arch/riscv/kernel/entry.S
35:	addi sp, sp, -(PT_SIZE_ON_STACK)
45:	addi sp, sp, -(PT_SIZE_ON_STACK)
277:	addi s0, sp, PT_SIZE_ON_STACK
417:	addi sp, sp, -(PT_SIZE_ON_STACK)
461:	addi sp, sp, -(PT_SIZE_ON_STACK)

arch/riscv/kernel/mcount-dyn.S
61:	addi	sp, sp, -PT_SIZE_ON_STACK
64:	addi	sp, sp, PT_SIZE_ON_STACK
66:	addi	sp, sp, -PT_SIZE_ON_STACK
104:	addi	sp, sp, PT_SIZE_ON_STACK
106:	addi	sp, sp, -PT_SIZE_ON_STACK
139:	addi	sp, sp, PT_SIZE_ON_STACK
179:	REG_L	a1, PT_SIZE_ON_STACK(sp)

As I said, I don't know this area, so I am just pointing out the
difference, and wondering if it is intentional!

Cheers,
Conor.


--Jy5FtS70Bk/OQG7w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9Q0hwAKCRB4tDGHoIJi
0oF3AP0Z15pGayQswQGlhn2kb9DurrmHCVDUpjOlzAuJb+20ewEA0jaMauqbMbls
DyKlABEOalx2XeLgCpaPSDuJEsApmwk=
=isMW
-----END PGP SIGNATURE-----

--Jy5FtS70Bk/OQG7w--
