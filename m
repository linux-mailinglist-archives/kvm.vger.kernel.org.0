Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0683FFD60
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 04:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfKRDiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Nov 2019 22:38:54 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:57149 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbfKRDiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Nov 2019 22:38:54 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47GZS800YNz9sQp;
        Mon, 18 Nov 2019 14:38:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1574048328;
        bh=yaXFgIGPp85/ZA+H5oyIXwU76mmH3dZ/R5xtn/8YK7k=;
        h=Date:From:To:Cc:Subject:From;
        b=kuqGaGLThrS7SzPFkEnKrJGOLjbrRiRu1V9XK/mgVuPhcAqT3b+TtV0EDumCIrnzf
         hqy0qXacVHxqE6iqD4Rne/gV7eXdVifvWeskLPZ/4Iovw7uvYShKZnfAn+tips67JT
         MyRXGISVw/p1IGKNPVWRmA510dTdPptFxCWRixoUVqF0BBj3uxA2FT1yGghlMfXkZQ
         9xR2pdRNQZRBIHRspOQukf3ZoxjPl/8EEt+CJ7wKgJzsps9VAujXES/dvwpTfuXzdL
         jlDpLCRiFhRgqQNJRSKKDiLutMsafmanR7jl5LUmBGRvF/qQcqW/cCg3c6CptJdyQ8
         KEvrSk7Kt/J0A==
Date:   Mon, 18 Nov 2019 14:38:42 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Subject: linux-next: manual merge of the kvm-arm tree with the kbuild tree
Message-ID: <20191118143842.2e7ad24d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5HUdFAqHGOdiC_qEUQxSxps";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/5HUdFAqHGOdiC_qEUQxSxps
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  include/Kbuild

between commit:

  fcbb8461fd23 ("kbuild: remove header compile test")

from the kbuild tree and commit:

  55009c6ed2d2 ("KVM: arm/arm64: Factor out hypercall handling from PSCI co=
de")

from the kvm-arm tree.

I fixed it up (I just removed the file) and can carry the fix as necessary.=
 This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/5HUdFAqHGOdiC_qEUQxSxps
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3SEkIACgkQAVBC80lX
0GxjCgf+MYGRV9Y/05JQmaOc2sNC396tDuXdZI64Mp1pXcLb/8BCkd8gvCCqhe6a
41IwK0dm+RD+afmeZgQyk5L7u3e2msMITifbl+dTZYB56OwQH6U624niroKfi4Ql
MJVXH/c8TUo83uiUJiwWG/dtKgIZDkY6tK27pmzeAqkiTm+UY3bP+Yn8pxeDyOxi
jwIdmf91d2Uy0pgDIrKJtK9/wBYJ24tmOZlNxrARb9xUHZKH3I6CH7mmc6L5f2K6
+GS634T7EzpFVRsiCFrX7ges/nUKOzJy60LHANnyQwM/6UznNKHLp9HJTIwsPANt
PuDyaTEMsBL/0AkFhmc0q9V6pHhHEA==
=A29g
-----END PGP SIGNATURE-----

--Sig_/5HUdFAqHGOdiC_qEUQxSxps--
