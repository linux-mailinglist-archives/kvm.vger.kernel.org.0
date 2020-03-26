Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E39381936ED
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 04:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgCZD1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 23:27:33 -0400
Received: from ozlabs.org ([203.11.71.1]:40923 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbgCZD1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 23:27:33 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48nr5Z0XdJz9sSH;
        Thu, 26 Mar 2020 14:27:30 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1585193250;
        bh=ZKW7qcECKhZTwsefzZv3KK0kIUy8HwxrSNINue5nCKs=;
        h=Date:From:To:Cc:Subject:From;
        b=c+9UbtkwAW96p6Br+QzTYW/T3AyEVUODTofZrCm+Oi/BqcS9TH4rVDEiSjp8pm8o9
         QEYb7n637GWve85Hp9VM47n9U53DdxkvtvnF2FvzWOivdVbmo5P2WygjIwnBTdsfd3
         nZ42XDPTVdTBLiISrip/t0ZF0gYQxHYOJ6KmMBz9vT2Na3gXbmfv9fLG7QjTImzei8
         1p6xBOoneIYOfwGx/g92bMlxQ+DXrMxY/eL0A7gzM6ECbZeOEFawSDhrRHwXcp9G5N
         TgxK6zi+TixVFKl0q7U2oKzyrrKFtRcp2lRjfOllDZM2EedTmjQzsorYzN3XUKrCqm
         QLzY+A7TgYlDQ==
Date:   Thu, 26 Mar 2020 14:27:27 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Jones <drjones@redhat.com>
Subject: linux-next: manual merge of the kvm tree with the spdx tree
Message-ID: <20200326142727.6991104f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/VtZ6W2G_3YXyJV6tZQUt48y";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/VtZ6W2G_3YXyJV6tZQUt48y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  tools/testing/selftests/kvm/.gitignore

between commit:

  d198b34f3855 (".gitignore: add SPDX License Identifier")

from the spdx tree and commit:

  1914f624f5e3 ("selftests: KVM: SVM: Add vmcall test to gitignore")

from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc tools/testing/selftests/kvm/.gitignore
index 2f85dc944fbd,16877c3daabf..000000000000
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@@ -1,6 -1,6 +1,7 @@@
 +# SPDX-License-Identifier: GPL-2.0-only
- /s390x/sync_regs_test
  /s390x/memop
+ /s390x/resets
+ /s390x/sync_regs_test
  /x86_64/cr4_cpuid_sync_test
  /x86_64/evmcs_test
  /x86_64/hyperv_cpuid

--Sig_/VtZ6W2G_3YXyJV6tZQUt48y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl58IR8ACgkQAVBC80lX
0GwFSwf9Hl5x/JggSMeSvHGQsBqJIqanz2n818jJh/abF0ssh8XqI2Laz1iJD/4D
EEKEhVSpZeDAFKseL5KC/xAi+lP5mRyrOirK0EolG+mPYDuyvGZnRferP9BITvgL
Fb6ZNh0YZwp+P13hmU/r50goHdyt7KMrIp6CXLJkMBEq/8AM+QurePpFlx5K/PDR
KGjgj+2Rt34hdpV95CFaV4KZ9LNaZigS44HOPA31qlecEQnhAljjk2s0jqwrz+Gi
HEyuWAtz01IVkZFMmZAGG9gBsjyEPtRITnW0jzrkWuVFpIoTKg7iVb5HoMbXA+S/
k3tdvYfZXMz4t3cGbKdYegDQV7i+KA==
=5Cf/
-----END PGP SIGNATURE-----

--Sig_/VtZ6W2G_3YXyJV6tZQUt48y--
