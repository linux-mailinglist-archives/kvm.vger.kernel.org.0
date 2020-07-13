Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F5921CE68
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 06:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgGMEuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 00:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgGMEuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 00:50:10 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F928C061794;
        Sun, 12 Jul 2020 21:50:10 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B4rmc1xSHz9sRW;
        Mon, 13 Jul 2020 14:50:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1594615808;
        bh=vD4a5aVxi8ud4WRzptuIQbiMT2/JMG1qfDJO/MwTYVg=;
        h=Date:From:To:Cc:Subject:From;
        b=ugFlKEggYDY9ZnCIRnGHwIQdHESNjAXYRZ5XFSx+SiFjUiTKX+jtlZZa4LR78cWv+
         Pk9Q5D7eCoZofTBZv2XksiBNZWQ7S0vuO9NsbEVFJVpABTituAnpD6tgyrJKs2EwEw
         sBXJjy0tBCUMkzdVBrbDc8vclsx6pcY6qFibToNbM7HT2Tj7ljq+nFwAH+6QUJX9pj
         uCbFy2r/2ECFi7DKnRKP74Le1EIDcHoWGA5T/uJHhPWENGVkZdRt4Z6Q4sfeGg1X5m
         fbXtySpttdtxcoO+bF+88LHIw0nlxEPPgDY7TL6UC60Wzr1cUCuMRgmsc37I4EyYI7
         OG1djXADpJXlw==
Date:   Mon, 13 Jul 2020 14:50:07 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Collin Walling <walling@linux.ibm.com>
Subject: linux-next: manual merge of the kvms390 tree with the kvm tree
Message-ID: <20200713145007.26acf3fb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/271y1+tT.CFkT.HuXE1J7Id";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/271y1+tT.CFkT.HuXE1J7Id
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvms390 tree got a conflict in:

  include/uapi/linux/kvm.h

between commit:

  1aa561b1a4c0 ("kvm: x86: Add "last CPU" to some KVM_EXIT information")

from the kvm tree and commit:

  23a60f834406 ("s390/kvm: diagnose 0x318 sync and reset")

from the kvms390 tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/uapi/linux/kvm.h
index ff9b335620d0,35cdb4307904..000000000000
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@@ -1032,7 -1031,7 +1032,8 @@@ struct kvm_ppc_resize_hpt=20
  #define KVM_CAP_PPC_SECURE_GUEST 181
  #define KVM_CAP_HALT_POLL 182
  #define KVM_CAP_ASYNC_PF_INT 183
 -#define KVM_CAP_S390_DIAG318 184
 +#define KVM_CAP_LAST_CPU 184
++#define KVM_CAP_S390_DIAG318 185
 =20
  #ifdef KVM_CAP_IRQ_ROUTING
 =20

--Sig_/271y1+tT.CFkT.HuXE1J7Id
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8L5/8ACgkQAVBC80lX
0GyKLQf+Lqj8KOEXiT2CAYfJgVYRKUtBCOM6LoCUsF4NPCC8phf94IO1IOet/6+T
4sOZDqXYiHCXFix0Qlqw3Xex3yKcoBEllrIN4V7tjPr9E3aywBpqsKDTFUX7zy0j
h5WsSVtgc3iRdm35FuDWlVYmV6848S7PSe1CEQkWkIRWf7O2p7TjkuRKCMR0TaUk
gl4XmJPCHb+Yj2tTjTEwYYStYVhzmyaDPjBXj7OblCeJQUO979+ZgWWp0S2NoVZ5
mdiTgSBiyTpt7tPuGNUkoHtgv7fEklYf/4j4tQ9h+13ynN/NnIChHzrBuf2FHNf/
QthQaVGupphinkQMeh8IapOgfnRJug==
=sbvW
-----END PGP SIGNATURE-----

--Sig_/271y1+tT.CFkT.HuXE1J7Id--
