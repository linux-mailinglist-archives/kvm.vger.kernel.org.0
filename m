Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF59361FC3
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 14:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbhDPM2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 08:28:02 -0400
Received: from ozlabs.org ([203.11.71.1]:40005 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234914AbhDPM2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 08:28:01 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FMFpW6jWXz9sVb;
        Fri, 16 Apr 2021 22:27:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1618576052;
        bh=JYdcLdPUbTo38tlUGmoVGoWuj6WMw32aNHJqgtTCmtY=;
        h=Date:From:To:Cc:Subject:From;
        b=qKkcct5wuDcOsZPYHyhGTQN3p9pM377ZvPDpG4ZNqnCrapu/6F9UCx4iSr8MTFBRb
         ejhzGMofCfqPpZCKNN8Rt8Fk95xEUEPA+4s68rxggS/ddIPNzT+H8m6GmhayrPbDb5
         faHRerQUMRT/U41nXfXhEyVYfnjB526cpflJMsqzYKsLx3tb2tbGcl+orX+qlVg3MB
         wU3mnj2GgnCmuELAQmEdzIjWeW/oEjx0QfZmJCHg/USbl69NzkD2POIj5VypgsWVpq
         4GDcHyX2VcBVCzFsErVnnJikU88nJ2rxpsOD0QErEGMHHLY6xFf2nbqm1CVgzH1tuz
         53c/9vpRRNvDw==
Date:   Fri, 16 Apr 2021 22:27:31 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm tree
Message-ID: <20210416222731.3e82b3a0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/1tsCH=y7VINn6jpuc5OMoAl";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/1tsCH=y7VINn6jpuc5OMoAl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  c3171e94cc1c ("KVM: s390: VSIE: fix MVPG handling for prefixing and MSO")

Fixes tag

  Fixes: bdf7509bbefa ("s390/kvm: VSIE: correctly handle MVPG when in VSIE")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

--=20
Cheers,
Stephen Rothwell

--Sig_/1tsCH=y7VINn6jpuc5OMoAl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmB5grMACgkQAVBC80lX
0GxTKgf8DPhUSMv9IFzE2TZZAUQun6lqp8YjsO2jTTU4tIeRuFmJmCg1tYFHRlzK
ORAvCmKJjtNC2B0uNXh3UrhxWVCeawPjw4OBRb8DoTCnIIBo274kHbqGG2I7WNZp
1BZZsTKa1wIf09f6fKn9MlYOPbLdFlOc3YvA/AGTfMOyRem0eF8Xozk6q/M+VvqL
7ki2t6bht6+9qLC35MU2vlt4B/ZWQtxkcdQIIOdq/f96H/fy4P5gKytG7ztlqSxM
51YWi0pCT5ElR/Mob1GxIRqHjTX5bDVqW0fiR1YFbhl9ZY+VLIwOLwKxNLEH7quq
NSU4+JeZOnmy7i5igVgtAiweDxUT/A==
=XIlH
-----END PGP SIGNATURE-----

--Sig_/1tsCH=y7VINn6jpuc5OMoAl--
