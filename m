Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28ED454F48
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 22:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhKQV0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 16:26:43 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:38841 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbhKQV0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 16:26:42 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HvbWw4wFQz4xbC;
        Thu, 18 Nov 2021 08:23:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1637184220;
        bh=r2lEfIc6Z9FG0L/36ey/V5SCOY3TzpjJDpD568xulo4=;
        h=Date:From:To:Cc:Subject:From;
        b=MgRaeD7lyQjJ9KJsD2CQ5fw79jo3q9g+E2kOf1p5dcafjFng6++J+Sw0Rj3/FhJ81
         kMxEnUZWr9VnVLH32zdc8MeA6WZBbwTaSzpZVKw6R7qJCxIviHxC2lFOatFZs1A8md
         vs7gXQ6+te089SrurIa/o0+W6bubxVqiXAu3wxfUQSSbvfqQJs/nS68SahzYN383DO
         tfzhSBWD6HBu1u2CBB3fVRrrOIG040KPP5RYeGyPFNstpHy2emFpIV6CIw7C4VtWjt
         6OyrHsP6VwP8KKTCIMClZVQagRK5ZKR1TMUvpFzkreLPSktn+UAQS3FOlNidwSSg8L
         dSFHPnKSVxl8w==
Date:   Thu, 18 Nov 2021 08:23:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20211118082339.3c5598db@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/LvEN1bAxOsL0WSHw7Dus9/b";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/LvEN1bAxOsL0WSHw7Dus9/b
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  a31a01172ebf ("cpuid: kvm_find_kvm_cpuid_features() should be declared 's=
tatic'")

Fixes tag

  Fixes: 17cd23d68fdf ("KVM: x86: Make sure KVM_CPUID_FEATURES really are K=
VM_CPUID_FEATURES")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: 760849b1476c ("KVM: x86: Make sure KVM_CPUID_FEATURES really are KVM=
_CPUID_FEATURES")

--=20
Cheers,
Stephen Rothwell

--Sig_/LvEN1bAxOsL0WSHw7Dus9/b
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGVctsACgkQAVBC80lX
0GywDQf8C6HXra6t78iPzfy0iP5MGwru79ar7j2geHsn9juG4egWP/3INQk7FLbu
m6ZT1TYodPMGpYuKmonQj87sAbGwZ4n/YidDyucvYbIvXp8SvTklC0RGB3mIxvlu
vvA2TYeCA5YwhrDo5ug0nZX0TJxLdQatcQy6EMMgo7a+LW8imTxPzZ8pkygicXd+
FtjK1vvfc52XB08lYL0qNjIF32mkdEBlQ6gFseCHbA6mCxCMXOuOO2zTS6rQ5wKV
I4jhDhwyzydxhvqhY/Kbehp8N6SM3TtbaMVQSJgTyvula0/Od9U+g0LJcmAx+A9W
80f40CzScIwjw1YtgncvEFr5v62Hpw==
=Rdaa
-----END PGP SIGNATURE-----

--Sig_/LvEN1bAxOsL0WSHw7Dus9/b--
