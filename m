Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E71B17842D
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 21:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731904AbgCCUjw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 15:39:52 -0500
Received: from ozlabs.org ([203.11.71.1]:50479 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729681AbgCCUjw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 15:39:52 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48X85K1Jp1z9sPK;
        Wed,  4 Mar 2020 07:39:48 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1583267990;
        bh=TjvrRgnHhdcBJu19Jlnojiu/tbhukvpbVzMp/IdP1xs=;
        h=Date:From:To:Cc:Subject:From;
        b=tzTQnOec8I2gag1nBSCVDE+IhhXm5T65Po66j0RJdzhFtNPYuHnFNebjYLv44pPdW
         i6t90M3kHJHvoI3+cB4hCAUiModR0T0RRqOedSc5R8mz5+NH1AObHaCUun4I/PvUbK
         FyaoyRFlZ0y1Oc06RkAC2oeQPJ5ny+k+pxEd3QPqHdE0Km8nM8Htsrx/Pj2VN2lkc+
         WqO5rAqFcka42fv0YuG9x4WoIhgc5S1Jeko77q50D4JKwhYIYPIbUKtp9WSqpFGPtj
         1306WbxskM80Fu/x69jfAFwv8aLiiDbeB3X2PXEKuX5wlA7I9YdJ6mPqB6snshwLjR
         U7LmMGEQwduJw==
Date:   Wed, 4 Mar 2020 07:39:38 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Haiwei Li <lihaiwei.kernel@gmail.com>
Subject: linux-next: Fixes tags need some work in the kvm-fixes tree
Message-ID: <20200304073938.73ac724d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/s78gslOY7Cj_i6a9gEuspHl";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/s78gslOY7Cj_i6a9gEuspHl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  aaca21007ba1 ("KVM: SVM: Fix the svm vmexit code for WRMSR")

Fixes tag

  Fixes: 1e9e2622a149 ("KVM: VMX: FIXED+PHYSICAL mode single target IPI fas=
tpath", 2019-11-21)

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

In commit

  9a11997e757b ("KVM: X86: Fix dereference null cpufreq policy")

Fixes tag

  Fixes: aaec7c03de (KVM: x86: avoid useless copy of cpufreq policy)

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/s78gslOY7Cj_i6a9gEuspHl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5ewIsACgkQAVBC80lX
0Gxkpgf+IB9yxNHj3j/9pX/g2IdnBgBxNCbf1J9AZclS/iIt4wPidyRJ0eEWrIc/
NSAzTl8gypsGq7wexKm/GuzCHLJi836qHeHh72oPAwl9Dv7l0YILvWG5VgdalnFh
BDgQ2F5/1yKZKxlBnjWNn21ZWHjPEUfceqvdWGYLjXH2mGc3HhudOyEW0/cwej4t
Biz8z6V/rRVRxGM3FguyLdY2y/fikGQJD/t/bKKthr8h2wYOSq7AJervOqPTNhnb
1I/k7bBphyq5bym4sZUEDn2AO7rygJrhADgr5e1u4ib7pvZsDOJLweDshdzX0YyL
tg0vgXMGM2tJy+5Akd4tIuFAA1CdVw==
=f/mY
-----END PGP SIGNATURE-----

--Sig_/s78gslOY7Cj_i6a9gEuspHl--
