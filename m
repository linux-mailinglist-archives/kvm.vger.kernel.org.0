Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2DF4939DF
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 12:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354220AbiASLtX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 06:49:23 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:52991 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbiASLtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 06:49:22 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Jf3p80ltYz4y3p;
        Wed, 19 Jan 2022 22:49:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1642592960;
        bh=AI8Xp8WmFMzDYfkAVqP8te/3eXUi2hDB4d00oNT2g3g=;
        h=Date:From:To:Cc:Subject:From;
        b=iWx5D1yShLEExjx2+/bZbAIBXwoWH5lO7wB4dm19dwy9KqjBOxc18HHvICVn37Te0
         qNoNv0JZ3PyjZxu3G0h3QAdOhX0ECLtR8uwQ4Vp6SNf3pTHDi9DgORiyIG8CpNct2A
         pF3F0H0rYSwXoyiDW1Fwvua/cHx4nV9IWX5MvRkBmfh0yOTzxWc/hnmi/qvKg7BikA
         uWEKIyfxJaHOlIwPFWQezpKf4xlKd4yIfwSPaSzkze/+9OOIpAZeu8LKB2Cv1jM/Vm
         e10XFrWpE4fapoCzjTTshX8GKLhDDVdZ4gEXFNbP+z7RSv1caYRn1NthUPIfzJSyq8
         u1yJJUuZnLd1w==
Date:   Wed, 19 Jan 2022 22:49:18 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Wei Wang <wei.w.wang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm tree
Message-ID: <20220119224918.026a21f1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/YP+XCLo2kK.6P1+hz607rTI";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/YP+XCLo2kK.6P1+hz607rTI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  32c8644b37cf ("kvm: selftests: conditionally build vm_xsave_req_perm()")

Fixes tag

  Fixes: 415a3c33e8 ("kvm: selftests: Add support for KVM_CAP_XSAVE2")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed in the future by setting core.abbrev to 12 (or more) or
    (for git v2.11 or later) just making sure it is not set (or set to
    "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/YP+XCLo2kK.6P1+hz607rTI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHn+r8ACgkQAVBC80lX
0Gz0OggAiMDH9+/N4KishH8m9aWwABnNUu0uAHYkKbaZEI2TSnQSENmQ9Zydug23
ZH+pvst4VJHP5t0n7dkD5GdoGy56KrwiioX8cldpfoidXjLyMBoJ0iIN9vhpOLam
pzWWECxTaNl+q+9J+AEY72/BFFLjFphbD+pWEvOUiddIaqhCBCZCdiWbsYG+xLCN
sIPHrsJWyWD5Q2DJqrhjgFJhKtjmlgmobzRxkjISfKLUvPBKvFrlzrV8FVQgjzjr
32he1Hh6An12wideEFKbE+kknsoMSE7i1EeCavQI6oiZFM9sC725GfEPX9lpjtWj
iSrRroT+N3tm+acoKa/WfYqafebQkg==
=2Fns
-----END PGP SIGNATURE-----

--Sig_/YP+XCLo2kK.6P1+hz607rTI--
