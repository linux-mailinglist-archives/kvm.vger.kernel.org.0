Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6711A267EC2
	for <lists+kvm@lfdr.de>; Sun, 13 Sep 2020 10:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgIMIi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Sep 2020 04:38:56 -0400
Received: from ozlabs.org ([203.11.71.1]:56281 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgIMIiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Sep 2020 04:38:01 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Bq2tt3Skwz9sTH;
        Sun, 13 Sep 2020 18:37:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1599986279;
        bh=TZ/X11rY3fq74UGOWp2hIHD1LZkCa8HXfpcrNfGTFII=;
        h=Date:From:To:Cc:Subject:From;
        b=AjZDffxountEa58G+H3yR6/EHoVoMVWnfR8iQVZNUzaW+WIxu3wCmvY6BPIWhRWWX
         b4JfAu1It0ZBgjxx+70fM6pRF2k9vOJGZzy/Tz1pdeuMFI/qvdNAG1X1YC7+sUXfwj
         64kf8SRUu106ihqDPArIYvWcyen5cdNYFzNz1Sj+yU2tnzVyEYeboIcryCyshXKZHP
         ko8OPl1F57lXAvuiXPNW1FRqX1cqWguOmLLkGD622dg6LDGGkaTIbFm0LXa1sp2CTj
         PACzbb520/uMHUdBMKMHKKQ9cmhD+13hazYjb5uBR0BL7LK8nzJiZUbZGbDSHb5ODG
         3oVczi8jY/+tw==
Date:   Sun, 13 Sep 2020 18:37:57 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chenyi Qiang <chenyi.qiang@intel.com>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20200913183757.6059a9ff@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/XS8g=j9AUNbSvJkJRwMRGqG";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/XS8g=j9AUNbSvJkJRwMRGqG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  c6b177a3beb9 ("KVM: nVMX: Fix the update value of nested load IA32_PERF_G=
LOBAL_CTRL control")

Fixes tag

  Fixes: 03a8871add95 ("KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL

has these problem(s):

  - Subject has leading but no trailing parentheses
  - Subject has leading but no trailing quotes

Please do not split Fixes tags over more than one line.

--=20
Cheers,
Stephen Rothwell

--Sig_/XS8g=j9AUNbSvJkJRwMRGqG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9d2mUACgkQAVBC80lX
0Gz/Lgf/ed4KrCsI6HW7bQgwIh0l+M9MVLBkMkjQeH2g88chsiuVwYqICcgeLodO
9Ob0iwIPPv9U/Y5xvbTh/N1TqPrE47G0nT+VYUkz2DRiwNjiVwgVQSbT04X/JCo8
oy3HjJPMiZmLSC/ejOkbnuEGWEmkdNCjVR6Nk0ZqWU+p14H9ZZbgcT+S4fm/P04D
FtRWbWwSwX2AiH1cTjQi1MVhIDC3pbo9Ipi65EhIhIxe7DzYhN/Gc6FAU82Zg+2H
aazSODAnCTWMqo4aeCEX+D2jOGK3t717FuuNddEWaT6RP1SW6Jk/lpQcS7lGnAli
+8eALEBDyprccfBwBDSUhJvjkmLMbQ==
=q0MB
-----END PGP SIGNATURE-----

--Sig_/XS8g=j9AUNbSvJkJRwMRGqG--
