Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0BE26938CC
	for <lists+kvm@lfdr.de>; Sun, 12 Feb 2023 17:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjBLQeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 11:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBLQeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 11:34:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D021A9;
        Sun, 12 Feb 2023 08:34:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9A2360D54;
        Sun, 12 Feb 2023 16:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E83C433D2;
        Sun, 12 Feb 2023 16:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676219644;
        bh=xx7iI5wGy1JPuulc/US8zJWoV7JPTA0FzsZZDZGyoD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=artVvw6jfP5pzDgUWX6BF2j0okasaDZw3DTURs8vnrANfjR1XfYrukljFNimp6aQY
         t3LIUTMcRPBb5CN4Nvg7p6P/9EaZG6WfpJ5kI3CsyBIF+vK4DKMG1UzFmd4wGTycmi
         t6dPd6RQPwXp/Frjq7bpAzPnkw3UhE9rU+3tnbDw0DJl0j/0OFhrYCQ+yjsGfUucCo
         bLNjvSGh41oLdTWBrgU6QwKQ5YEBQSh+h+fpzAcep7nlaMBGt4+YtWDlixmCEAWC6X
         ldm4Q51PYmAAbZFmJlv+PBdCr83KqVyNDzfcsmWLUAvnYxsleCwkq7dJ7jikEnOwbr
         EnECFwNq/zcAw==
Date:   Sun, 12 Feb 2023 16:33:58 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v5 00/13] riscv: improve boot time isa extensions handling
Message-ID: <Y+kU9nDBTttZRLLq@spud>
References: <20230128172856.3814-1-jszhang@kernel.org>
 <20230212154333.GA3760469@roeck-us.net>
 <Y+kM//nuDv29Z9qJ@spud>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mYkRkqFoxF74+E/4"
Content-Disposition: inline
In-Reply-To: <Y+kM//nuDv29Z9qJ@spud>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--mYkRkqFoxF74+E/4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 12, 2023 at 03:59:59PM +0000, Conor Dooley wrote:
> On Sun, Feb 12, 2023 at 07:43:33AM -0800, Guenter Roeck wrote:
> > On Sun, Jan 29, 2023 at 01:28:43AM +0800, Jisheng Zhang wrote:
> > > Generally, riscv ISA extensions are fixed for any specific hardware
> > > platform, so a hart's features won't change after booting, this
> > > chacteristic makes it straightforward to use a static branch to check
> > > a specific ISA extension is supported or not to optimize performance.
> > >=20
> > > However, some ISA extensions such as SVPBMT and ZICBOM are handled
> > > via. the alternative sequences.
> > >=20
> > > Basically, for ease of maintenance, we prefer to use static branches
> > > in C code, but recently, Samuel found that the static branch usage in
> > > cpu_relax() breaks building with CONFIG_CC_OPTIMIZE_FOR_SIZE[1]. As
> > > Samuel pointed out, "Having a static branch in cpu_relax() is
> > > problematic because that function is widely inlined, including in some
> > > quite complex functions like in the VDSO. A quick measurement shows
> > > this static branch is responsible by itself for around 40% of the jump
> > > table."
> > >=20
> > > Samuel's findings pointed out one of a few downsides of static branch=
es
> > > usage in C code to handle ISA extensions detected at boot time:
> > > static branch's metadata in the __jump_table section, which is not
> > > discarded after ISA extensions are finalized, wastes some space.
> > >=20
> > > I want to try to solve the issue for all possible dynamic handling of
> > > ISA extensions at boot time. Inspired by Mark[2], this patch introduc=
es
> > > riscv_has_extension_*() helpers, which work like static branches but
> > > are patched using alternatives, thus the metadata can be freed after
> > > patching.
> > >=20
> >=20
> > This patch series results in boot failures when trying to boot the
> > qemu sifive_u emulation. There are many log messages along the line of
> >=20
> > [    0.000000] WARNING: CPU: 0 PID: 0 at arch/riscv/kernel/patch.c:63 p=
atch_insn_write+0x222/0x2f6
> > [    0.000000] Modules linked in:
> > [    0.000000] CPU: 0 PID: 0 Comm: swapper Tainted: G        W         =
 6.2.0-rc7-next-20230210 #1
> > [    0.000000] Hardware name: SiFive HiFive Unleashed A00 (DT)
> > [    0.000000] epc : patch_insn_write+0x222/0x2f6
> > [    0.000000]  ra : patch_insn_write+0x21e/0x2f6
> > [    0.000000] epc : ffffffff800068c6 ra : ffffffff800068c2 sp : ffffff=
ff81803df0
> > [    0.000000]  gp : ffffffff81a1ab78 tp : ffffffff81814f80 t0 : ffffff=
ffffffe000
> > [    0.000000]  t1 : 0000000000000001 t2 : 4c45203a76637369 s0 : ffffff=
ff81803e40
> > [    0.000000]  s1 : 0000000000000004 a0 : 0000000000000000 a1 : ffffff=
ffffffffff
> > [    0.000000]  a2 : 0000000000000004 a3 : 0000000000000000 a4 : 000000=
0000000001
> > [    0.000000]  a5 : 0000000000000000 a6 : 0000000000000000 a7 : 000000=
0052464e43
> > [    0.000000]  s2 : ffffffff80b4889c s3 : 000000000000082c s4 : ffffff=
ff80b48828
> > [    0.000000]  s5 : 0000000000000828 s6 : ffffffff8131a0a0 s7 : 000000=
0000000fff
> > [    0.000000]  s8 : 0000000008000200 s9 : ffffffff8131a520 s10: 000000=
0000000018
> > [    0.000000]  s11: 000000000000000b t3 : 0000000000000001 t4 : 000000=
000000000d
> > [    0.000000]  t5 : ffffffffd8180000 t6 : ffffffff81803bc8
> > [    0.000000] status: 0000000200000100 badaddr: 0000000000000000 cause=
: 0000000000000003
> > [    0.000000] [<ffffffff800068c6>] patch_insn_write+0x222/0x2f6
> > [    0.000000] [<ffffffff80006a36>] patch_text_nosync+0xc/0x2a
> > [    0.000000] [<ffffffff80003b86>] riscv_cpufeature_patch_func+0x52/0x=
98
> > [    0.000000] [<ffffffff80003348>] _apply_alternatives+0x46/0x86
> > [    0.000000] [<ffffffff80c02d36>] apply_boot_alternatives+0x3c/0xfa
> > [    0.000000] [<ffffffff80c03ad8>] setup_arch+0x584/0x5b8
> > [    0.000000] [<ffffffff80c0075a>] start_kernel+0xa2/0x8f8
> > [    0.000000] irq event stamp: 0
> > [    0.000000] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> > [    0.000000] hardirqs last disabled at (0): [<0000000000000000>] 0x0
> > [    0.000000] softirqs last  enabled at (0): [<0000000000000000>] 0x0
> > [    0.000000] softirqs last disabled at (0): [<0000000000000000>] 0x0
> > [    0.000000] ---[ end trace 0000000000000000 ]---
> > [    0.000000] ------------[ cut here ]------------
> >=20
> > then qemu hangs until the session is aborted.

Hmm, so this appears to be us attempting to patch in alternatives where
none actually exists - seemingly F & D.

>=20
> I have come across the same issue on PolarFire SoC while looking at
> Samuel's fixes for Zbb & the D1:
> https://lore.kernel.org/all/20230212021534.59121-1-samuel@sholland.org/
>=20
> Boot over NFS still works, which I think points to a hole in how my CI
> is operating - it assumed the completed boot + bootrr being happy to
> mean that there was nothing wrong!
>=20
> On the VisionFive 2 & D1 Nezha I don't see these splats though.
> It appears to be config related as the config I build for Icicle sees
> these splats in QEMU but the D1 config does not.
> I'll go do some digging!
>=20
> >=20
> > Similar messages are also seen with the "virt" emulation, but there the=
 boot
> > does not hang but fails to find a root device.
> >=20
> > Guenter
> >=20
> >=20
> >=20
> > ---
> > bisect:
> >=20
> > # bad: [6ba8a227fd19d19779005fb66ad7562608e1df83] Add linux-next specif=
ic files for 20230210
> > # good: [4ec5183ec48656cec489c49f989c508b68b518e3] Linux 6.2-rc7
> > git bisect start 'HEAD' 'v6.2-rc7'
> > # bad: [94613f0efc69ed41f9229ef5c294db3ec37145da] Merge branch 'master'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
> > git bisect bad 94613f0efc69ed41f9229ef5c294db3ec37145da
> > # bad: [8928ece68de4371dc6e1d3336d3029c1e18ae3b4] Merge branch 'for_nex=
t' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git
> > git bisect bad 8928ece68de4371dc6e1d3336d3029c1e18ae3b4
> > # good: [78a9f460e33d103256f3abb38f02f4759710c7dc] soc: document merges
> > git bisect good 78a9f460e33d103256f3abb38f02f4759710c7dc
> > # good: [b35b2472ebafa29d0bbe79fbee1da6ef3c4ec619] Merge branch 'for-ne=
xt' of git://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git
> > git bisect good b35b2472ebafa29d0bbe79fbee1da6ef3c4ec619
> > # bad: [57a87a64b520c37dd49f5fde84d09a4adb391180] Merge branch 'for-nex=
t' of git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git
> > git bisect bad 57a87a64b520c37dd49f5fde84d09a4adb391180
> > # good: [cfc8ba01cc84b24ec6eb293ec9fba893f7cd4581] Merge branch 'clk-ne=
xt' of git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git
> > git bisect good cfc8ba01cc84b24ec6eb293ec9fba893f7cd4581
> > # good: [6acecfa485d3de955c35a18730c106ddf1e7600e] powerpc/kcsan: Add K=
CSAN Support
> > git bisect good 6acecfa485d3de955c35a18730c106ddf1e7600e
> > # good: [8a16dea453dbc3e834b162640028e505882cd11e] Merge branch 'next' =
of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git
> > git bisect good 8a16dea453dbc3e834b162640028e505882cd11e
> > # good: [6be1ff430dab9fc047762b10b2c9669399ea1f37] riscv: pgtable: Fixu=
p comment for KERN_VIRT_SIZE
> > git bisect good 6be1ff430dab9fc047762b10b2c9669399ea1f37
> > # good: [e0c267e03b0c77c9ac79ac08eada41ba8eb1b95f] riscv: module: move =
find_section to module.h
> > git bisect good e0c267e03b0c77c9ac79ac08eada41ba8eb1b95f
> > # good: [e8ad17d2b5f38e595d597a3e2419d6d7cc727b17] riscv: KVM: Switch h=
as_svinval() to riscv_has_extension_unlikely()
> > git bisect good e8ad17d2b5f38e595d597a3e2419d6d7cc727b17
> > # good: [75ab93a244a516d1d3c03c4e27d5d0deff76ebfb] Merge patch series "=
Zbb string optimizations"
> > git bisect good 75ab93a244a516d1d3c03c4e27d5d0deff76ebfb
> > # bad: [9daca9a5b9ac35361ce2d8d5ec10b19b7048d6cd] Merge patch series "r=
iscv: improve boot time isa extensions handling"
> > git bisect bad 9daca9a5b9ac35361ce2d8d5ec10b19b7048d6cd
> > # good: [03966594e1170303c037b0cded35c464a13a4a45] riscv: remove riscv_=
isa_ext_keys[] array and related usage
> > git bisect good 03966594e1170303c037b0cded35c464a13a4a45
> > # first bad commit: [9daca9a5b9ac35361ce2d8d5ec10b19b7048d6cd] Merge pa=
tch series "riscv: improve boot time isa extensions handling"



--mYkRkqFoxF74+E/4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+kU9gAKCRB4tDGHoIJi
0oKbAP9ARAh+eueAaPRvlCJ/rNo9Q2wDrSzM4q4x237ZHVg+RgD8DCc9+Xcs9W9V
nkjOl76ShKo4luj4su6YQDGUBa9MnQA=
=PSF7
-----END PGP SIGNATURE-----

--mYkRkqFoxF74+E/4--
