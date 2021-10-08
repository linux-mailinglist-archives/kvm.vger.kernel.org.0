Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029DB426261
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 04:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbhJHCSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 22:18:50 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:57447 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235226AbhJHCSt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Oct 2021 22:18:49 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HQWz73wKXz4xR9;
        Fri,  8 Oct 2021 13:16:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1633659413;
        bh=uAe3s4KDKeCI/VJ+ZcImRCB5utSt3BzwG7fBnqux3zo=;
        h=Date:From:To:Cc:Subject:From;
        b=lpNJi70m5v3oaQ94bBe4gUri1NVBnNIc3InT94xaBfH+pMEPviCe3p04LoC7yaVEl
         d4s42ZLfpbTSiDYPKp8/PbRAj+8DjBXTaS86w7XN2SWEU73HeYWckuWAg54J+pOKJf
         FUWhv2+oR7yWpwX3beUkDdWmPIjuz73rarBT3jbM83/gKZ9gOpHRyz/Fcm4WUFEnkT
         OoKH2cLRoVQ3dQqBoHEuZAEwd+d7JmztK3wM4CSgDt+lrs6iOap+120ll0+v7T6mc2
         ZOkjJVz8RJyNpsLfx5acu8B+54AFqPlYQaF09RZUDvUNzr7xvClJv+700PV5NtmSxx
         KExgesRfsV/kg==
Date:   Fri, 8 Oct 2021 13:16:49 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Anup Patel <anup.patel@wdc.com>, Anup Patel <anup@brainfault.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the kvm tree with the asm-generic tree
Message-ID: <20211008131649.01295541@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/D3b0zr0YQsB_VDXEC_sjald";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/D3b0zr0YQsB_VDXEC_sjald
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/riscv/Kconfig

between commit:

  b63dc8f2b02c ("firmware: include drivers/firmware/Kconfig unconditionally=
")

from the asm-generic tree and commit:

  99cdc6c18c2d ("RISC-V: Add initial skeletal KVM support")

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

diff --cc arch/riscv/Kconfig
index 0050a2adf67b,f5fe8a7f0e24..000000000000
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@@ -562,3 -561,6 +562,5 @@@ menu "Power management options
  source "kernel/power/Kconfig"
 =20
  endmenu
+=20
+ source "arch/riscv/kvm/Kconfig"
 -source "drivers/firmware/Kconfig"

--Sig_/D3b0zr0YQsB_VDXEC_sjald
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFfqhEACgkQAVBC80lX
0Gzx+gf+Iw2ih1KkdkXJG4AtUQBO3xyL5Xv+2Q8oE4TVE+THHcTgIFgMLPGcmLm6
g+fP7VQyI0sqVqc6Wr8kANKjANugSMRbXSnO02SUkjHIPa+A6z0TzMDvqAljMkQ+
rhqsKRyYfiXFM0i/23p9aqw+yMygZ9ZfIsCrXPrR5esJDvK7vvizNe1mTwW1IzZ0
NUZ/LkSpZcHl/6bgONVuj/cFlnuOYHoCz7ee13OvTb6s7YG1ppYQXoyN9J5uNZS7
Odp5cISSG9AdDUUEf59Hws8U4Q1eHLqembj9uyvIqdAbQ52dEff00FRvbTusZp+4
/LuviG1Peq9o2bdpmkU5LMX58eCFyg==
=0cut
-----END PGP SIGNATURE-----

--Sig_/D3b0zr0YQsB_VDXEC_sjald--
