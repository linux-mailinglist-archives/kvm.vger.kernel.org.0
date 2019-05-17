Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F12B211B1
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 03:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfEQBRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 21:17:03 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:38481 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726241AbfEQBRC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 21:17:02 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 454r3w0jBlz9s9N;
        Fri, 17 May 2019 11:17:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1558055820;
        bh=GmKkgxMc9neyWGN6pTHLiLtZljrkrN2L1tSS7tgt2FA=;
        h=Date:From:To:Cc:Subject:From;
        b=qLbiJJSgGXBCwRDi77lG6pdVk9RcLPCLQX63Z0QLNJAvcz9lrjkJPEh9Pu3F1MNxn
         gZij6JqzlY5JarJ4iqOmb4ANbC6oDU9QY657sLoq4YreeAzGmLVkOkp36XsnLT+2QE
         D99hjAKfM9nlBYo8s+WnWnLA4W0QmrIEIz1+WMa67u6/Rwb9VWiIVqvST4T/N8jGE8
         qNsASJbhDIZf5r88rdMJqM3okRGgH00t4PaSNFZV5xdCQ1VEhrmhRtbMK6M+oBBGzT
         XKVGYC05BLf/0Jy1DLSRSwdAy3Ird4oNtNn35dZaGL3o0RDOBbOpYPNVaozud8gSwY
         E0DEdIZpVuj+Q==
Date:   Fri, 17 May 2019 11:16:59 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-ID: <20190517111659.0abd4659@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Je8SHF0vaegqUhEkF/nQ7iM"; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/Je8SHF0vaegqUhEkF/nQ7iM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  tools/testing/selftests/kvm/dirty_log_test.c

between commit:

  76d58e0f07ec ("KVM: fix KVM_CLEAR_DIRTY_LOG for memory slots of unaligned=
 size")

from Linus' tree and commit:

  65c4189de8c1 ("KVM: fix KVM_CLEAR_DIRTY_LOG for memory slots of unaligned=
 size")

from the kvm tree.

I fixed it up (the only difference was a comment, so I just used the
former evrsion) and can carry the fix as necessary. This is now fixed
as far as linux-next is concerned, but any non trivial conflicts should
be mentioned to your upstream maintainer when your tree is submitted for
merging.  You may also want to consider cooperating with the maintainer
of the conflicting tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/Je8SHF0vaegqUhEkF/nQ7iM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzeC4sACgkQAVBC80lX
0GwJBQf/VxQyU+e+oOJtg/JYzZqy+NvzQ3vIIBLL1lbF5xsHIBsV3punUZXliCrZ
diJpeO2yiMlCl8q2q1QLJXYUnGcebwwfLHXS/tUhyYz8GmF3Bo1wSMkdQt8T63Vg
fTRdGYMpAdy8cUBD1HDs5CRiygD3EDq7/FI2vexsuF/H0lF41lqJovzn/4AKYb2A
SUdND7SnJ2rMJxcSSwQUcB1Ece7c8FCa2xT9BToA5fVZUfTE6LAXQ9k5yjwymr7O
O7egXL0anA846Eunw0dvJcZ203Hl6sYksmC7Zm9vKADaVVnHE44GEqIeOe9SBBSz
ALVmJM4Xe0UpYeERXt4kkF+ash19gA==
=hWq6
-----END PGP SIGNATURE-----

--Sig_/Je8SHF0vaegqUhEkF/nQ7iM--
