Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591B15F969D
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 03:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiJJBbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Oct 2022 21:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiJJBbT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Oct 2022 21:31:19 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD15D45059;
        Sun,  9 Oct 2022 18:31:17 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Mm1b73HRRz4x1D;
        Mon, 10 Oct 2022 12:31:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1665365475;
        bh=cj/OupvxK+ninXY9OhqPvK9B+YFYEM0VDCh1CryGPRE=;
        h=Date:From:To:Cc:Subject:From;
        b=XWcMCySKsRrw+YO+VOLaq9LAxE9tT7sLJT0qhBirE30gbzdsm10ZchcogRhely9oG
         sDwMnPU19sFHnCQKb5C73lEXD0ce3bZ8Jp5HNrt574X2jlY1hoJGQ0ZO9IrSL+2Zjo
         aeUmW0EOYunhAiHUH/u9Hgc1gf+bh5Kp3juGVsChKYVFyuw7wV3pETNqfkTxNRvnZJ
         Bz/SH/SQCpN/ZGtThyXx5GRy7kobog8WHq3WZ+J20utx+vUoKL4ub1etb2dVjXgg1/
         fZejFqdh1r+MyXzuGA0gw0mruWxUkelQ+SVSi8MqRzyUK8ZYSsDJ4zuIFgbcGX6Fex
         dyCpgun7M9CRA==
Date:   Mon, 10 Oct 2022 12:31:11 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Anup Patel <anup@brainfault.org>,
        Anup Patel <apatel@ventanamicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-ID: <20221010123111.268dfe21@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qShRLmC/nQK=QnZO+IWJE9U";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/qShRLmC/nQK=QnZO+IWJE9U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/riscv/kernel/cpu.c

between commit:

  61a41d16ad20 ("RISC-V: Print SSTC in canonical order")

from Linus' tree and commit:

  122979aa26cd ("RISC-V: Probe Svinval extension form ISA string")

from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/riscv/kernel/cpu.c
index 87455d12970f,7d1cd653ca02..000000000000
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@@ -96,6 -95,8 +96,7 @@@ static struct riscv_isa_ext_data isa_ex
  	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
  	__RISCV_ISA_EXT_DATA(zicbom, RISCV_ISA_EXT_ZICBOM),
  	__RISCV_ISA_EXT_DATA(zihintpause, RISCV_ISA_EXT_ZIHINTPAUSE),
 -	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
+ 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
  	__RISCV_ISA_EXT_DATA("", RISCV_ISA_EXT_MAX),
  };
 =20

--Sig_/qShRLmC/nQK=QnZO+IWJE9U
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNDdd8ACgkQAVBC80lX
0GwMjAf/SzxSZ9xNjHA9197AuxKdqWtKSZiX8X/FXdiVRcMYm1SqAS5wIRT0rVOn
Vh4O5ZlGCzAwW8SLS5Zx12q5Qy7KgLadUjLRwGDtGy/hCRiFqgbefmPrtylZRc5q
8heP1b9WZb2qaUMrl61PaCCMgcxIOPFcHnOf/c5d1g9ynq4Yt1xcUG9ByGgibajt
lzvkQ27zUl+feQ14CHgP5/xQyerjhJCLuzUketGTnJpu/yHw+7v1ZLtBFMSZlTjB
CGDrxbAj6XfWCHhB+B1b7KwOPVtT7rDxB4R9TbuIADK96dsZcZDo+Ls6vHS5+J8H
Sn/4OOSbrLReDEVNc3kTR5LoB8CKxw==
=XYGg
-----END PGP SIGNATURE-----

--Sig_/qShRLmC/nQK=QnZO+IWJE9U--
