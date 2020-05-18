Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5EF1D706F
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 07:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgERFmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 01:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgERFmp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 01:42:45 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5F8C061A0C;
        Sun, 17 May 2020 22:42:45 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49QSb56qHjz9sPK;
        Mon, 18 May 2020 15:42:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1589780563;
        bh=OZXkqJ/Ua5mmXPX03SU7RZ5lmFd03+MILYNEQaoroR0=;
        h=Date:From:To:Cc:Subject:From;
        b=PLpI1CnWIlGwPqpKU/O+3JguxMENXVN/HQKqPD49/uLcNjLS2dHTa+VtS6aUdIOSL
         VjFw40Ko+AS2E/qH/wDmLGQYLn2ZqH0hlWOBuJKc9ChM+mwX7YTkbbz8t+H6Kg3xl5
         y3sx1rsrvOHzsYe2eZ2327FwRWQN2TG2leIPFS3LXN7bqDvExfkrzQGK0fKUXspEs4
         N9hvwRVVaULYVp8EuTFbjqlvQDhckcWX/iMQGihqdHCvI6cg5ZBX7p9Nby4jDLJFo9
         VwYBhjC+54mPh7xvUcnp8swn8K9vgRXgAij9lV/X8CkfXL4mLenysOjHvc2f9B30W4
         Ze8IlHDwJszcA==
Date:   Mon, 18 May 2020 15:42:40 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Qian Cai <cai@lca.pw>, Wanpeng Li <wanpengli@tencent.com>
Subject: linux-next: manual merge of the kvm tree with the rcu tree
Message-ID: <20200518154240.777ca18e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Lw2gywd8ZNI=5ZwAIi9Bxji";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/Lw2gywd8ZNI=5ZwAIi9Bxji
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/svm/svm.c

between commit:

  9f24847d8fdb ("kvm/svm: Disable KCSAN for svm_vcpu_run()")

from the rcu tree and commits:

  a9ab13ff6e84 ("KVM: X86: Improve latency for single target IPI fastpath")
  404d5d7bff0d ("KVM: X86: Introduce more exit_fastpath_completion enum val=
ues")

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

--Sig_/Lw2gywd8ZNI=5ZwAIi9Bxji
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7CIFAACgkQAVBC80lX
0Gx4hwf5ASoL+5CtYpxMRe2Vbi1nhpHDiWzG5EGUnI7uAIdqUgf7W4K36Kp5H2Q4
H+JYJ7ZfvfNceY0vwZWWd9MwjSmHrLNp2ba/xAb1FKqmVZjEjnyuouzBoJEz+7Lz
7GAysptpayD7hYDG8oHxtFMOSNOx48VzKBjEgI3B1qRTTiWS5fyLtLOG6zw+vqF3
sc+j4+Z1OoozhV7zJHbhDnGhTi2ABOUW+xewKrJM49tZgXag/4XFYGivddyyeU2Y
LooiEU1bHRt3eT/3TzMXRPmYnWdIEgH56tG517KUL2bZ8+SonLwhtO2F5gu0IqbZ
++Rkq0jBuAGoyPZNp/HQ0FaOEAqiLQ==
=DYlb
-----END PGP SIGNATURE-----

--Sig_/Lw2gywd8ZNI=5ZwAIi9Bxji--
