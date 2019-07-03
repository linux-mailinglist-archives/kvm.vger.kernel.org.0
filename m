Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF63F5EECC
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 23:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfGCVtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 17:49:14 -0400
Received: from ozlabs.org ([203.11.71.1]:56685 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbfGCVtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 17:49:14 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45fF9z1y9kz9s8m;
        Thu,  4 Jul 2019 07:49:11 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562190551;
        bh=ogYrAdqmBL5sV/Ifv2mvi7wFD/kypvfY6pwW/9HHGMY=;
        h=Date:From:To:Cc:Subject:From;
        b=YnADNR5aXZq0RBozBxpyZRbBUhE18DQHskZE8/xRalMseUrvh7vA43ympqxzEm348
         UBrkTnRCkrpl+pDakNk5nStyIHeI80uyW9lqSmWrbF6x2cOo1J+eu9r9cVzvBGMtAT
         HxWpSZt0jyHwErnXuvnuulUjaYB4/UyIBBTuSO6QmPx49S78f2PTL3J0HVR3RjYzsj
         9WBHrzV5jq5ubwXCT1/yM/8coPxhR4CDobL17fR1bCzVORjy9T43jC5zRVz+Pt4zWk
         DrFYwaE9g86F0zAvRQswD8bfXmbZ6xMgSIbjc90ApRApxA16uKmD0BmoTDH4a7KCyo
         nzwl0bIfG1rDA==
Date:   Thu, 4 Jul 2019 07:49:08 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Fixes tags need some work in the kvm tree
Message-ID: <20190704074908.5fb3d184@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.bYtCXpIAYKBGltV7yY8X/U"; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/.bYtCXpIAYKBGltV7yY8X/U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  e8a70bd4e925 ("KVM: nVMX: allow setting the VMFUNC controls MSR")

Fixes tag

  Fixes: 27c42a1bb ("KVM: nVMX: Enable VMFUNC for the L1 hypervisor", 2017-=
08-03)

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").
  - The trailing date is unexpected.
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

In commit

  6defc591846d ("KVM: nVMX: include conditional controls in /dev/kvm KVM_GE=
T_MSRS")

Fixes tag

  Fixes: 1389309c811 ("KVM: nVMX: expose VMX capabilities for nested hyperv=
isors to userspace", 2018-02-26)

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").
  - The trailing date is unexpected.
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

--=20
Cheers,
Stephen Rothwell

--Sig_/.bYtCXpIAYKBGltV7yY8X/U
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0dItQACgkQAVBC80lX
0Gwv5wf9FteVffOioPU1RApnBCZ95sSTsrIv9feDYWWXcAB6wtw7eDLCrczS3Uda
+rT2sPpC9gkgsJXX6BnQ01FjOhbg1I8QTBTp9yJtOWNLxNxTlz94Vwz7YBmwjMCo
SRPyLE4TUVGnb7v+T9Ge1AWHhQ1EgsU+l5JAGdiGIfzJ1m1NU1c3Xb172DBey1Pk
VsuOwXbAjDE7YnL5PZF0dGDcqUly1SQ+CkB439DWf5YVutMCQLVP8cvKaHS3gyIS
eq+po8CUylXVFVB/jjD03FGIyPDXBDAnHmqcgoQryxyQTy5XFnr/uB5GTLxXOZ9A
kaOBIrrXWuirTQgGdSUYq0QedIq4+g==
=zY54
-----END PGP SIGNATURE-----

--Sig_/.bYtCXpIAYKBGltV7yY8X/U--
