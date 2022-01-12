Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B23B48BBF3
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 01:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347289AbiALAkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 19:40:32 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:33685 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbiALAkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 19:40:31 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JYTHX6nYqz4y41;
        Wed, 12 Jan 2022 11:40:24 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1641948029;
        bh=OKHUQyNaR3xR6APh61tWn+dSE3ThCx0C1NbFgssUJOo=;
        h=Date:From:To:Cc:Subject:From;
        b=bxDD0CMvsC14Kf5Ye+9a0teF0LfFJkkW/p6AE471U0tXoAnZ/0TWhnujYUWVZBwAL
         GBNz0W6Rm2Bta6zOUEA9qcnjufhkMjfcjkzDF7tgGx1wS1yoYVimpLLYIWDNqHdwAb
         qiOfMBNoq5IOJVhGzrGcaC/CkFH356CuJCTGM3mQBfUmrhvHmF7544U1iThM7zCxps
         izwSM4qlRAhU7BxEEtunbUByofSoAzj7vMTwN864Zg6NlK0OyGmoYKp8usLKD9/UEY
         h7qQeAShdty+k4rnOI2UBxi8hXToTj4zPX4XxQdQW0JI/13lU/dglMF6tf84/DUGwu
         TBbwocBk4X3Yg==
Date:   Wed, 12 Jan 2022 11:40:24 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul@pwsan.com>
Cc:     Anup Patel <anup.patel@wdc.com>, Anup Patel <anup@brainfault.org>,
        Atish Patra <atish.patra@wdc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Atish Patra <atishp@rivosinc.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: linux-next: manual merge of the kvm tree with the risc-v tree
Message-ID: <20220112114024.7be8aac6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/K7Ubz=brIb1y3c3=TxKJ2aa";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/K7Ubz=brIb1y3c3=TxKJ2aa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/riscv/include/asm/sbi.h

between commit:

  b579dfe71a6a ("RISC-V: Use SBI SRST extension when available")

from the risc-v tree and commit:

  c62a76859723 ("RISC-V: KVM: Add SBI v0.2 base extension")

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

diff --cc arch/riscv/include/asm/sbi.h
index 289621da4a2a,9c46dd3ff4a2..000000000000
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@@ -27,7 -27,14 +27,15 @@@ enum sbi_ext_id=20
  	SBI_EXT_IPI =3D 0x735049,
  	SBI_EXT_RFENCE =3D 0x52464E43,
  	SBI_EXT_HSM =3D 0x48534D,
 +	SBI_EXT_SRST =3D 0x53525354,
+=20
+ 	/* Experimentals extensions must lie within this range */
+ 	SBI_EXT_EXPERIMENTAL_START =3D 0x08000000,
+ 	SBI_EXT_EXPERIMENTAL_END =3D 0x08FFFFFF,
+=20
+ 	/* Vendor extensions must lie within this range */
+ 	SBI_EXT_VENDOR_START =3D 0x09000000,
+ 	SBI_EXT_VENDOR_END =3D 0x09FFFFFF,
  };
 =20
  enum sbi_ext_base_fid {

--Sig_/K7Ubz=brIb1y3c3=TxKJ2aa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHeI3gACgkQAVBC80lX
0GyRLwf/dZfNTizbKDGcGjR+EDWhOPre6wrMErgFDFsCmdSpqGtfgBlkE/8FFONf
Sp9JeRtbfJW9QuR3oMu9LjJ294pR0BxACew/jJicA+8PYbYIFZ/BCp/81Fj0TcYa
i5R+ibntAEFAqQCRwo1RNmdVWyB0qQITy3Wo3SmqDRG6hscQttxvmk6UPHnxolj7
P0BjIuN3rKxFqZz6F65dA8CWeQKlEUbcIsVIf/+CzL/hMcQSorxYORgWOrRar5+V
NKYwZNNtK/D5ZeBs4ldLo6WQ39QTtBCrWSPvkd4RNv6bVLu7f9Nr329j25HMmKOi
wX2CC1mDTBST8SsJAcSbAXWxd/WCBA==
=Gwix
-----END PGP SIGNATURE-----

--Sig_/K7Ubz=brIb1y3c3=TxKJ2aa--
