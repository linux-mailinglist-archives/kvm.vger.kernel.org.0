Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE6A10A576
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 21:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfKZUaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 15:30:25 -0500
Received: from ozlabs.org ([203.11.71.1]:41871 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfKZUaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 15:30:24 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47MwWc65Ggz9sRH;
        Wed, 27 Nov 2019 07:30:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1574800222;
        bh=afsoIn2XZqK4fz9PBhl5G8eJamsDD10MBu3yEOVkQg8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TKzABNkdBIRhUZFn4xtDqf6vrgHyPebdBu5IUD+MvfkmYZMgZg7Cco0hnih0elLP9
         VW+VreZXiZHRRREL+NGCLQFEcMgBViOXdzHFxLqr1ENpZ00Q/nBDo1L3dq3cMKInyY
         OdSqThyXGmBSancMCwEAXGasHUSPUTg3I5cSh8KTf69L9Eqp76yTiKCpT6JFdpFJQK
         klitAcJed/p9q59cu4SGI7Erf1Z1uA9Qc50F8r7TvYfblKspO8lMNh3NJQc0emggyA
         cTMB4yhkdu+Ix7wVStamc5y37tcji7+OhLJuz+aYJSxnNhITQoiOGCKDQnvBnqXvhv
         nyN6CY9NPTU/Q==
Date:   Wed, 27 Nov 2019 07:30:19 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm-arm tree with the kbuild
 tree
Message-ID: <20191127073019.41c44ae7@canb.auug.org.au>
In-Reply-To: <20191125135811.4a3d71da@canb.auug.org.au>
References: <20191118143842.2e7ad24d@canb.auug.org.au>
        <20191125135811.4a3d71da@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mO/2s2aVXGsrv_8fZYouSu1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/mO/2s2aVXGsrv_8fZYouSu1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 25 Nov 2019 13:58:11 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 18 Nov 2019 14:38:42 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > Today's linux-next merge of the kvm-arm tree got a conflict in:
> >=20
> >   include/Kbuild
> >=20
> > between commit:
> >=20
> >   fcbb8461fd23 ("kbuild: remove header compile test")
> >=20
> > from the kbuild tree and commit:
> >=20
> >   55009c6ed2d2 ("KVM: arm/arm64: Factor out hypercall handling from PSC=
I code")
> >=20
> > from the kvm-arm tree.
> >=20
> > I fixed it up (I just removed the file) and can carry the fix as necess=
ary. This
> > is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tree
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularly
> > complex conflicts. =20
>=20
> This is now a conflict between the kvm tree and the kbuild tree.

And now between the kbuild tree and Linus' tree.
--=20
Cheers,
Stephen Rothwell

--Sig_/mO/2s2aVXGsrv_8fZYouSu1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3di1sACgkQAVBC80lX
0GxKWgf/XqDJya979/i/Ee6kkS9stH/cuZLB0qgcdM0OJksaN6vsHD1mj6sv2qdx
h0qVO1ycAOLoM1Z3JGcbwvbJloYHG/lwejHc1yazpwdq+59pxBfqM1wCW100x+pH
BFUXLlChcdcwzLRe0aXSQeNMH2BMM/UMjGlZ0QtIg/7pGtJyKbpj8/JsvB2CD6a7
ptVB0dyrIVeC3kGo4O0F7M+P1hd0CoA+6X/syMRhdFAOKGYcBsdkVdbE+EIDMdeZ
3jrnJToTlIJVA6i0sGW3Px9mZfdHGfvK3M8ZPvTkixzp2YhliRa9JP7c4Cn7pywI
5oYRSi/GfCtGEsN1HD/VX9i80F0muw==
=MaQE
-----END PGP SIGNATURE-----

--Sig_/mO/2s2aVXGsrv_8fZYouSu1--
