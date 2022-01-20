Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE6A4955DF
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 22:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377761AbiATVOl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 16:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242456AbiATVOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 16:14:40 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19B5C061574;
        Thu, 20 Jan 2022 13:14:39 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JfwHs5CSzz4xdl;
        Fri, 21 Jan 2022 08:14:33 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1642713274;
        bh=RwSfI1Hhj/yPRKsrqvU5qkp+Fk66faVrNHX3k6y1sN0=;
        h=Date:From:To:Cc:Subject:From;
        b=czFPqbeIQXsMX6MFDNM32jOwB0+UVB8Q4iiBJx0bN8nVV7BC2nSLweI5ESsKr0i3z
         3YAHKyA5ZVLRmV6+Q7LMDYJS9GxLdfDboyfx2NwL1hj5QURDyjfCRiIY6F8oekEk/f
         LFPqU4fv6U9Tt2PU1QNAbo/hjD1Bu+a5rWt4uESjIestDU6nyiMcpF9DucnmczqckK
         e1VCXHrcJzO014/Fg+o/AAnIpa/k1wguY0yKVBbUnG+v0B7VlVdCQbsYQgUj3H2yBy
         TzSAHydWn+AYzp5MvPIvBwHXJ2o1BkscAVzM1wqYBseMgGeEkPefCn7tyYNDrj3Z9h
         SDFiX/iUwR7pQ==
Date:   Fri, 21 Jan 2022 08:14:32 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Wei Wang <wei.w.wang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20220121081432.5b671602@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/D79gjQMVc5FvAGz/93aS+zR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/D79gjQMVc5FvAGz/93aS+zR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  1a1d1dbce6d5 ("kvm: selftests: conditionally build vm_xsave_req_perm()")

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

--Sig_/D79gjQMVc5FvAGz/93aS+zR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHp0LgACgkQAVBC80lX
0Gz59wf2KAspZps4psA/DoXH1Lm9C4ypROiKmPmiKeaj5cP0NRlZWpdZp3LaRsyZ
tMS+iG5ytSn6y27OzxGhqAE5G11jKXURDg83bGNbKQb3q+cpFNEqXgY9Hyr9jBuJ
ZD75PaExfxfqCyK/UEagmyvJGnmAO3BfT7V4+pk8zO6mthkUWdyNRmO6EPcazyLV
vVebemoftEEYEhp/oEKU7ElPKpXjI52O4sto7xYGnWF0aFsQwZv1DQFKIEyYvLaR
Ykz2tjfQNm0Sx5/9MKDd6jPek8b5jhDOD6jiqlrnP9BgLdJyHBPz96WY1qvUyyAM
gRnt5t0NtRmXIOvI1WeXIL518owN
=U/DQ
-----END PGP SIGNATURE-----

--Sig_/D79gjQMVc5FvAGz/93aS+zR--
