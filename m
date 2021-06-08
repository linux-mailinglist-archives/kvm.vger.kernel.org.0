Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0A63A06B0
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 00:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbhFHWUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 18:20:17 -0400
Received: from ozlabs.org ([203.11.71.1]:57611 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhFHWUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 18:20:17 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G04Pp0K1hz9sT6;
        Wed,  9 Jun 2021 08:18:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1623190702;
        bh=OO63knGY6UYblmAqT8CT6DRPTVb3FfilKXIezBExOAQ=;
        h=Date:From:To:Cc:Subject:From;
        b=PzXTpfYOUZJGlJpKBlpHTfpV/uuEVonz6Xv+yz4pmYk7XZd8kIAZkVkfQ/WuE3Hxt
         i+mc6fV/ovqa4ntjOOXEKK4bPSZayqWY6WoPXCfH2l5WY2cwfKtYfja5NaGwd3ZL7h
         6LPHlh6bHwmQR5n+kdPH4f5LgF+T7fVv1z1TzH+RrWFAXq+nqfO9l+sOGO78KJs2ls
         kGEXvSnlJl0aHhgmoUsYHI3/lxDiN+4c2oH7MPLPzcr+nRCvbOH7ksE7KD1Ws4n1JF
         sIU6VNyQHVemrdJgOepwf06iPlSE+mlV+9bAgsP0t+LREDIsUFiIsZFANHjwYk8g7h
         oJ2Ry6XtATb3g==
Date:   Wed, 9 Jun 2021 08:18:21 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the kvm-fixes tree
Message-ID: <20210609081821.03275041@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/HgdO5VVvVWqgUjwB4oiQ6Ah";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/HgdO5VVvVWqgUjwB4oiQ6Ah
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  f31500b0d437 ("KVM: x86: Ensure liveliness of nested VM-Enter fail tracep=
oint message")

is missing a Signed-off-by from its committer


--=20
Cheers,
Stephen Rothwell

--Sig_/HgdO5VVvVWqgUjwB4oiQ6Ah
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmC/7K0ACgkQAVBC80lX
0Gz4awf9GVE82lz9w56N6yNPFHKd9B5yNZIDdYrQky2v130V/Qcyrkx+gxoK0gLx
TVJnEnMle/1ONNmAoNmKOm0Ae3misfgY6IRT+HCpJFegilRy5r5idIZ38y7JJJDo
MNE1kh85gSxFuZ6ucVdP7JLk4g3OQzdkxaWYs8VyF+9+KrsOwfWmLCXk5gy8yopN
qefxZpfhaYjiLKgrbxuPkGgD41Oo0fsYgJMNcVsU0GWSsSR7/eeWGMqP8BFey4ns
snk9+pk9ByYGwBY3zlcwOy65RuuuJVnvvx++RQN89elqbQHhI6ImSdBjPrpZ/lqA
KMJTOSQajwbSq65e3k3mou8NVWcxMQ==
=HLnu
-----END PGP SIGNATURE-----

--Sig_/HgdO5VVvVWqgUjwB4oiQ6Ah--
