Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AE6468B67
	for <lists+kvm@lfdr.de>; Sun,  5 Dec 2021 15:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbhLEOgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Dec 2021 09:36:48 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:58879 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbhLEOgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Dec 2021 09:36:47 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J6TZ70bt7z4xgs;
        Mon,  6 Dec 2021 01:33:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638714799;
        bh=XH4eKjONXfchJfV7m4iehQIX8QjdiwCGdXRNbyP9tsw=;
        h=Date:From:To:Cc:Subject:From;
        b=KMD9aru3qCsVEly82tnG7MfNFp5zwu7O97cYRNdEbVdLshIqg+Qk7BHJ2MBDcrekM
         isV1fz27ZRpUnjfktaF0XqTi9IiYUpXBp3tHfyJV8XkeyWLiV0KMWr2cysSTma5QcC
         NL4PfUVCWGz5sYZnoTuA5K48ucQVq4aieWFuA13PgcuQ3lZ+iszQzwIOaJ8nMauurP
         JnPuoSyeHzK40+pXgUpa3r1kWbcQYuCGRUYu5fpDlPjDTPgFsykyEYdnG3leKg1sL6
         nXSkVZeuAOz9RZte2IMY4vLwQNO1gCEf+jr+RnA9tePDPLOwviLuvEMrnDY64OxHPI
         cl1I6+rmZVedQ==
Date:   Mon, 6 Dec 2021 01:33:17 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20211206013317.47915c46@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ss09jJYcDCtvouMn4sCHGos";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/ss09jJYcDCtvouMn4sCHGos
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  ef8b4b720368 ("KVM: ensure APICv is considered inactive if there is no AP=
IC")

Fixes tag

  Fixes: ee49a8932971 ("KVM: x86: Move SVM's APICv sanity check to common x=
86", 2021-10-22)

has these problem(s):

  - Subject has leading but no trailing quotes
  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

Adding the date to Fixes tags adds nothing.

--=20
Cheers,
Stephen Rothwell

--Sig_/ss09jJYcDCtvouMn4sCHGos
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGsza0ACgkQAVBC80lX
0GzQ9Af9FNP3xG0BIZ94mPUGSXkMflHc8Ar569q70rcdSp/bQj4i9h3P1aMq5myI
dybpZbn/ofcq/CEWDA+T9t3BIXO91qWs5YombaSnyjAwadRw6oUhFW8tAwXvq8VO
iyp615NQVHs3hKiEoQ86T30AZ8wEceJUG2VutUhKiOtRh62gySlPJePWfkf1wyXa
pVcmGIuIb1BvQLOoAnxBocA2Ucb5+HSXvHkd6gC4Yx9dowCBzOcew31JmkSKvrDX
JU2xdltnT2QgGM7kbOATN93zobEqKGnDakHc1qwovko+20/Btn1CIF+GCuG9LDzo
KmhHU6w5/Nizupvga0JASlIBrMW6QA==
=HZd4
-----END PGP SIGNATURE-----

--Sig_/ss09jJYcDCtvouMn4sCHGos--
