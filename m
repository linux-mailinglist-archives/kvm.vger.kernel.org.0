Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C691472CF
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 21:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgAWUnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 15:43:51 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:33733 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729012AbgAWUnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 15:43:50 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 483Z4M6d2Xz9sP3;
        Fri, 24 Jan 2020 07:43:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1579812228;
        bh=83x96HuRmZI8HHCCDM2x3tssC2dnG1Ta+2mmPEAAWCw=;
        h=Date:From:To:Cc:Subject:From;
        b=TW7NOjaJRth72YbYMqruCrwL+W51IX4hZVKDv8n+t4Dc6vPl6/8G6HGbM9CkEslnD
         eoq67NnLRqk4r+W+Y7Z8f3Zs1bzPjmVmFZoAgyTorJaCW0511323Xwzf31/xtATjPV
         DUAJkFEmZ1cXQ/THOgvLfgtfxrXYm8LfN1NjiUhBJjDb+N9ioEHRdvzunxjSNEdq7u
         qTKD+NluiBl16fT2TK3Q4Ie+KPZbHWd2lIQjpELXOu2ee3bWZBdx6icjI17Q5pKB1S
         vO0/DJxYjvOT+k2IRlFXF7+IN8NQaJ200Z725zSY/Qf2RNg65TFcWTRiZ1lmQMyBmt
         SSVujzqnQ1C/g==
Date:   Fri, 24 Jan 2020 07:43:42 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marios Pomonis <pomonis@google.com>
Subject: linux-next: Signed-off-by missing for commit in the kvm tree
Message-ID: <20200124074331.30855ca4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/lESH38tHS8EWSmCvUcbj37q";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/lESH38tHS8EWSmCvUcbj37q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  821189a1c9b1 ("KVM: x86: Refactor prefix decoding to prevent Spectre-v1/L=
1TF attacks")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/lESH38tHS8EWSmCvUcbj37q
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4qBX4ACgkQAVBC80lX
0GyUaQf/VBHGHO0SyZgerneK71woKrNjHeKPH85NnUQyv0y0Dma6SIPNIbjyNvju
giTysRD9dBeSBK9/ue1DImtkQhXZBzyrfUmL0hEDY79kUERhHUE5pXZf+Sxlqajw
NL1HMhuFopccV3LFWCuLQfZw61Xz8S4LmeUxzX3e7AabRiVpGQOIOXJswJeL2VSp
L5mavH6h+iajJBdLQlbTV7PZ5ZjX8+qOg41/96BaZ27u5csqopWOUkXO1SVntZgH
REkfLSwPgJ/+e4Ja92T/NxRRWIy06CYjlFia4nBDVXB25UmVDpCvQlXKAuE9DFLU
HOwk/7AiqVM5ary6+XoRecgMXqKwFg==
=9kGt
-----END PGP SIGNATURE-----

--Sig_/lESH38tHS8EWSmCvUcbj37q--
