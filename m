Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F133AFCB2
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 07:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhFVFd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 01:33:26 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:43751 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229853AbhFVFd0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 01:33:26 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G8FP92yLZz9sjB;
        Tue, 22 Jun 2021 15:31:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1624339870;
        bh=+iTBWQ1I2dZ1rputthWeJ/k2YsXV48BguOCFkccfVsM=;
        h=Date:From:To:Cc:Subject:From;
        b=j7lrNnbCjMXFeINRUnZ0RewL4ixFZ75s05+TtrJU1Xt0At9CumtyqSGbtVzoDcK7c
         wvlZ4FPDEoHX798NGL0jS+CWBKoZX611iwZqLvwhj8jttj58mqBr7tHDpMElbqGBTX
         ptPOh6DNtbVZm14YKEBktMT+6/2suKyV7b1UBUAAW67j/znjEkLoEGDRfn9kekUuCg
         aXEK15o9pQFU9qPBbH4w5ESebDzGNzejLxrycB14mctRA3b7o2jYsJ81tTePqH56r0
         KKKl2FmcIvtLd9ApU6m7R0NX134Ka5Jwm+1SDUlQzD8UMFPuPZ2n/7eTEcl/LW0E0q
         SV/QWWTNrTNyQ==
Date:   Tue, 22 Jun 2021 15:31:07 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Jim Mattson <jmattson@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Ricardo Koller <ricarkol@google.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20210622153107.1db31b13@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/t1p/v3sR99B7_wU_ust+T8f";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/t1p/v3sR99B7_wU_ust+T8f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  tools/testing/selftests/kvm/Makefile

between commit:

  4c63c9234085 ("KVM: selftests: Hoist APIC functions out of individual tes=
ts")

from the kvm tree and commit:

  e3db7579ef35 ("KVM: selftests: Add exception handling support for aarch64=
")

from the kvm-arm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc tools/testing/selftests/kvm/Makefile
index 61e2accd080d,36e4ebcc82f0..000000000000
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@@ -34,8 -34,8 +34,8 @@@ ifeq ($(ARCH),s390
  endif
 =20
  LIBKVM =3D lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c li=
b/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
 -LIBKVM_x86_64 =3D lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.=
c lib/x86_64/ucall.c lib/x86_64/handlers.S
 +LIBKVM_x86_64 =3D lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx=
.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
- LIBKVM_aarch64 =3D lib/aarch64/processor.c lib/aarch64/ucall.c
+ LIBKVM_aarch64 =3D lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch6=
4/handlers.S
  LIBKVM_s390x =3D lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag31=
8_test_handler.c
 =20
  TEST_GEN_PROGS_x86_64 =3D x86_64/cr4_cpuid_sync_test

--Sig_/t1p/v3sR99B7_wU_ust+T8f
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDRdZsACgkQAVBC80lX
0GyiiQf/b4t2JydoHxXvWZMGRgMDwCw0u1z/7CwfdoShDBUMhuweR5Cfr8q+I9dx
u3SmYsXibM/zZJm+YhetjHPad3lKRu5qb5CtIkid6m4o3Ed5Fen69eTfbib97mxg
nU0f3Mp6Oz5u+kwj34Q0AzlJZPjXo5mRukzSnCa48an23GiklDxRl3wDMELZHn4d
cA+Eh2Xlu5VqKdmo3p9SWSyuA86D8jviOCXnvr7tCIxN35rticAYEkY+K2fVvnEp
dB1yI8oILMFP+QKKT3LYTzcP7GmmzL6xlRAmpaBzZ6piz1up1cREozqrLpFyXunw
agdPwyTohTDJvymxs5Ohc9k29keBxQ==
=lraZ
-----END PGP SIGNATURE-----

--Sig_/t1p/v3sR99B7_wU_ust+T8f--
