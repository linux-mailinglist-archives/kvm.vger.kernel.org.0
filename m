Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9BC3AFC92
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 07:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhFVF2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 01:28:04 -0400
Received: from ozlabs.org ([203.11.71.1]:46219 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229921AbhFVF2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 01:28:03 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G8FGx3vFKz9sj5;
        Tue, 22 Jun 2021 15:25:45 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1624339546;
        bh=Sq6dz+nfRdjOkjGoPUI8aR0Wa8pNNFXqY2fU4CY0d5Y=;
        h=Date:From:To:Cc:Subject:From;
        b=Hp998rrx7QvgHJUjVLmrN+hGm4Jxg9LU+Y54xkaFndF6qrvN+/wWH6CaQ7GYYH1+E
         eWUB89b0x/kPhue8Piig9OgME87RuK6nDIB5k6jr0V+hedSn4zuM3P6uYQX8XOjLLS
         pxdk5Idh7v14gzpePwJFxdf4BWce7wCBuxZX70/6z6PVGLINqt2/Q/ZejbmRQJmgau
         xN3CrmKYWUwbMT//6YQY4xyzNtmhLIrAHT7Q8sJsVllA1wGpi3K4lGnjcsjs6XOwss
         FQYWBr7Q3KQR8n6UJQvBqfvLu580JEZpdBkGiCpD7esDVUW0MCG3iUxdsQTgqzPyz1
         vpBHnoAQxKn0Q==
Date:   Tue, 22 Jun 2021 15:25:44 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        PowerPC <linuxppc-dev@lists.ozlabs.org>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: linux-next: manual merge of the kvm tree with the powerpc tree
Message-ID: <20210622152544.74e01567@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/v4K.dbaPwQgah4cZkfiBlVg";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/v4K.dbaPwQgah4cZkfiBlVg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  include/uapi/linux/kvm.h

between commit:

  9bb4a6f38fd4 ("KVM: PPC: Book3S HV: Add KVM_CAP_PPC_RPT_INVALIDATE capabi=
lity")

from the powerpc tree and commits:

  644f706719f0 ("KVM: x86: hyper-v: Introduce KVM_CAP_HYPERV_ENFORCE_CPUID")
  6dba94035203 ("KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2")
  0dbb11230437 ("KVM: X86: Introduce KVM_HC_MAP_GPA_RANGE hypercall")

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

diff --cc include/uapi/linux/kvm.h
index 9016e96de971,9febe1412f7a..000000000000
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@@ -1083,7 -1083,9 +1083,10 @@@ struct kvm_ppc_resize_hpt=20
  #define KVM_CAP_SGX_ATTRIBUTE 196
  #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
  #define KVM_CAP_PTP_KVM 198
- #define KVM_CAP_PPC_RPT_INVALIDATE 199
+ #define KVM_CAP_HYPERV_ENFORCE_CPUID 199
+ #define KVM_CAP_SREGS2 200
+ #define KVM_CAP_EXIT_HYPERCALL 201
++#define KVM_CAP_PPC_RPT_INVALIDATE 202
 =20
  #ifdef KVM_CAP_IRQ_ROUTING
 =20

--Sig_/v4K.dbaPwQgah4cZkfiBlVg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDRdFgACgkQAVBC80lX
0Gx63Qf/VMvHp3tPL8/SVslFfCtK/PtYT7bGb8jxd/AehS36tMv8pt2uG7/J/pN7
kdXqVl1Pduyo+OSEI3A6aQDcqlq14hf10PIrNfcRBFmz7LnIj9ZxH75DD+bMIFay
l/Q79DQnbt1UyGQUcoShB8kIlAQoQtKg3MyPuIvY4Qkz22o21v6BaUpLusSrtKBV
j9gU0mW1zieTs8Rp5unCHjsOdP56McZxVa54a+hCAMt8Y9fvkbe0NxlPsz1cAgDA
XffvQi4iiY0IpuGhQvU/O/h+qghRcotzTL5H0G63viYfddyWE/feEHqMl25VqdKG
ndgIq21Ld2LDzGxRPnvaG9BeScHNHA==
=OEVB
-----END PGP SIGNATURE-----

--Sig_/v4K.dbaPwQgah4cZkfiBlVg--
