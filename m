Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2AF3B3900
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 23:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhFXWBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 18:01:12 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:38623 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232591AbhFXWBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 18:01:11 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G9vCt3bN8z9sRf;
        Fri, 25 Jun 2021 07:58:50 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1624571930;
        bh=U0+KUgO34r3NW2Q6CiftK/OXjLeBJhn9Qmn2QRgn5tY=;
        h=Date:From:To:Cc:Subject:From;
        b=BDC4T2hTSpsBWSI0gypR2f1KiKAUTONw69UKYVzEg+c9eDEZM/FbWAsMG2wLUhjlG
         y8x3YR2KJ2UG+W1XBy69c8U7XBv5V9gmP0JtXW+3Fn8JiUNt+/kJWG763adYwiYOAl
         CvO+USUZPqbJkRaXfaVm5qbst5HnO6vhG9YU+6wAw/q5zlHwTlh1Tbo5GUjk1lFH3R
         jdHYQvvoEYaQIsjq13el7kwAW2GOZY09Ex1jssrRtUnnx2C35scip0l+dafF66y0GD
         EevqH2VsvyuGLKMstlsiOWKV9pAeZGMVJRkuiTaXYnzQOloc5oBaqVrUR5lwrhxqCQ
         P/9hng8nokGNw==
Date:   Fri, 25 Jun 2021 07:58:49 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commits in the kvm tree
Message-ID: <20210625075849.3cff81da@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6TC.a9LQ+qj5JmqmZBQfcEb";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/6TC.a9LQ+qj5JmqmZBQfcEb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commits

  df40a7ffa871 ("KVM: debugfs: Reuse binary stats descriptors")
  01bb3b73038a ("KVM: selftests: Add selftest for KVM statistics data binar=
y interface")
  a4b86b00ad24 ("KVM: stats: Add documentation for binary statistics interf=
ace")
  da28cb6cd042 ("KVM: stats: Support binary stats retrieval for a VCPU")
  170a9e1294a7 ("KVM: stats: Support binary stats retrieval for a VM")

are missing a Signed-off-by from their committers.

--=20
Cheers,
Stephen Rothwell

--Sig_/6TC.a9LQ+qj5JmqmZBQfcEb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDVABkACgkQAVBC80lX
0GyFAwf8Cy9ZJmKu1L6wrKhssUkK494mC41fud1JLXoYEz5OhOnqTnDxYGcbzY6P
4yZ/S+ircfRnqquvvlUgoX+edG2qCXuZSQvaBN0oChhmkJ5wIMe4Suf+bjCMMfFX
U8pyfwGhp+t57eNSv8ZoOWK3RJxkGApK/y8/FZeAVq5LA8QDfehHNbTu8v7hGw0c
pCZOyGgrnDe6sPrrjt0+IV/Exb1YyfZWGYdTpPUXWEESFmP8sjweSSP1oRh4vTlt
YXYaGJ1XYBXDXo58Sq6XPiq9AzjABVNYLR7gY0vKUOQKQB51SbVJkztOUpWqs/iu
qrg2DDaGcXbRR46qA0vYZb30c0zOKQ==
=/v/O
-----END PGP SIGNATURE-----

--Sig_/6TC.a9LQ+qj5JmqmZBQfcEb--
