Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B36418B44
	for <lists+kvm@lfdr.de>; Sun, 26 Sep 2021 23:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhIZVjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Sep 2021 17:39:32 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:47587 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhIZVjb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Sep 2021 17:39:31 -0400
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Sep 2021 17:39:31 EDT
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HHf5z1L1Lz4xbL;
        Mon, 27 Sep 2021 07:28:55 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1632691735;
        bh=+XN1ww0mHHW1+JZBjV/8qXo3Inu+Yv/12u2egqNhMHQ=;
        h=Date:From:To:Cc:Subject:From;
        b=eUgpL0ALqwFbR6RiXqIxT7AkGqfpkBOftyQlX3TW6T0s0buHUsHM+dlluqEWmQgjn
         7U0xRg7Zc6F0w32QAaV87xHgoKlfZsQXBO0F59Dx42+MNBPO0ZCBTDjlHWY96XB8SD
         MhdY1AvLUiLKNtXPaJoU+TlOZLCU9un68sV9nZYFnv9Q79jK1UfH4v91eU3iOSjKgh
         FdX5AXtJJcHoWTPG6B4d5gj1+Sff2La9+BSFosAVO52ffA8ITvMtxlExYkTQgWtuU+
         cWG/ughq7kG97FS8zRfxnWApshQiHQRNMvLxKCqb3/0d0BFApx4SmHwAP/QnINYp8W
         dyxfKObE7qXBA==
Date:   Mon, 27 Sep 2021 07:28:54 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Peter Gonda <pgonda@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20210927072854.6bf14f5c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/FS=lTeigZaKhWPq37.Bn1xi";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/FS=lTeigZaKhWPq37.Bn1xi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  5b92b6ca92b6 ("KVM: SEV: Allow some commands for mirror VM")

Fixes tag

  Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context", 202=
1-04-21)

has these problem(s):

  - Subject has leading but no trailing quotes
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

In commit

  f43c887cb7cb ("KVM: SEV: Update svm_vm_copy_asid_from for SEV-ES")

Fixes tag

  Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context", 202=
1-04-21)

has these problem(s):

  - Subject has leading but no trailing quotes
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

Do not include the date part in a fixes tag.  It adds nothing.

--=20
Cheers,
Stephen Rothwell

--Sig_/FS=lTeigZaKhWPq37.Bn1xi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFQ5hYACgkQAVBC80lX
0GzS7gf/bRsGUjI1PGPog1L0jDga+zpmeWVZYOn3z9zgZSDLqD5Z1M9KcmZz42gR
5zx5lfjutnbf2PPX7RfTlUrXBPEexQXYSJvMqXVx6HGI7yXmy5InU4fu9IWefnuJ
z2JMsdbhy/ffgRt1GNSg5edkfzx1bcbd/F+M65hjxPon1FN3ivDBQn7evea9e/lI
9DXKBBnkRlm3QdtQca35wvPHJJDIQtEuy5uAts7o6HFV7BF/PJ2Fd1h+OdGwXERx
x4WNw1xMqAEYKa6DwrlurmoeH2xkDDsEgwRXwXcUVOt6+TjoX2z9Ky7kH0gEJ0mO
YLtsgy7RT3/m1RkH2NB+JnKJJ1XpaA==
=ggg+
-----END PGP SIGNATURE-----

--Sig_/FS=lTeigZaKhWPq37.Bn1xi--
