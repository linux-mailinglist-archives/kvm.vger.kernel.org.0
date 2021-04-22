Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4201F3678C4
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 06:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhDVEgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 00:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhDVEgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 00:36:01 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418FDC06174A;
        Wed, 21 Apr 2021 21:35:27 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FQl302nP5z9sWD;
        Thu, 22 Apr 2021 14:35:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1619066125;
        bh=J6FspMbMbwqJrRXda8UnHmNcHVOhCyowb8duKmLfOSw=;
        h=Date:From:To:Cc:Subject:From;
        b=XCysH9zOeVxHHXLBZSa36BFoivVaGM4PKot/gBSnV8htosWSGBEstPFo5yhIIjGFi
         euCAsvqw8RasMT5sigyEJgU5FNawovKODu8floFXxT4J5ox/E50Rhk7W39zhVcFt5Z
         tX0o+PxGvMEw/S0+swr/MoyuFXLtkwGHisY2u4n0rrSzRTCAr527kmRI7Ke0xCa8S2
         dtp91xRvySo6T9KFSL9cJfdOp5C5+4Iao8P+N5Y8eu7jvy/3GgJWNGSJCUVVq8ZJVj
         cKaYg5rbG6q0G0chE9N08hOW8UBiGHxa6MnlkZlvdCLHaIZGt7ICc+d2rZh4AlV59y
         wSZ43IoNInhRQ==
Date:   Thu, 22 Apr 2021 14:35:23 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the kvm tree with the mips tree
Message-ID: <20210422143523.553f85e6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/=QAjmtSPKbBuc5WvFF0N1Ec";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/=QAjmtSPKbBuc5WvFF0N1Ec
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/mips/kvm/trap_emul.c

between commit:

  45c7e8af4a5e ("MIPS: Remove KVM_TE support")

from the mips tree and commit:

  5194552fb1ff ("KVM: MIPS: rework flush_shadow_* callbacks into one that p=
repares the flush")

from the kvm tree.

I fixed it up (I just removed the file) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/=QAjmtSPKbBuc5WvFF0N1Ec
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCA/QsACgkQAVBC80lX
0GwYdwf/XXD1RnZIjUHXrROw7ob+8TAqDkU+QjKuZZpZhWZ5rq7XaRoKPR/kpNaM
pAE1hO82NlInTsGpfMhbIFJwSuFU/sILqsVFpDvooMa2GRDmwrofeacBRFVyXk++
4CBDAyy18gUMtx7JvZ1T8JlSxTORd6+587ShiUXmqrh7rPWSpcSMM4oknHTuAPGl
my3MbM7vBRKG9AARidWM0UXFdMEFUkj41awn36YPffSMBAqgcjlU+nAl+9EsPlx9
CxZatot2Ha+Wp2y61KCD83Ldd1ObTAFF8ZqZtuUnwkU1tSSOZPLitlfHiIdnrjt/
KgRl15nNUNxR7cN0DkG7Uj36/hhVRg==
=b+zy
-----END PGP SIGNATURE-----

--Sig_/=QAjmtSPKbBuc5WvFF0N1Ec--
