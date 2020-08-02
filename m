Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3967C235687
	for <lists+kvm@lfdr.de>; Sun,  2 Aug 2020 13:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgHBLLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Aug 2020 07:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgHBLLa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Aug 2020 07:11:30 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E566FC06174A;
        Sun,  2 Aug 2020 04:11:29 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BKJHK4qQPz9sRN;
        Sun,  2 Aug 2020 21:11:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1596366686;
        bh=5uCbBvvTxj60H9uD/TN9xyrNZM3pahYzd1cSEffXcpc=;
        h=Date:From:To:Cc:Subject:From;
        b=aRwD1cp3incqjLgV0BeWoQy0xKJV0WvTkE5ZbXtf0Z3kCapUbQLRL5eJmcH+2VDwC
         7Oe0qQjFzv6wzkkARQSwqAt1lFjSr+S/itHfmMRYY1B1YSZ3sHt7kQk/3Kkw/NFfPT
         T3KUq0tkHgyDmYJgoOyaIDN/xhtjI9C35/xvk1c1hse3XL7MIPh2vkQEuN/YFbIUtT
         ACWQQYv+WvYILdOa4EeVXjwsiJN1rKWs+SLnU/lDrZiFkYbh6oD2EpQoUjnVhxjU0C
         L0XAFpFOqjFv54SWeHHbQw/WVSwdQH3JEP+j4KDCcMW1Z+tpADVvP72IzzVcW7RFX1
         x3YKqCkeEF6Lw==
Date:   Sun, 2 Aug 2020 21:11:24 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: linux-next: Fixes tags need some work in the kvm-fixes tree
Message-ID: <20200802211124.00311643@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/esB4f=Wx.bHI8+faGsv2avb";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/esB4f=Wx.bHI8+faGsv2avb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  830f01b089b1 ("KVM: SVM: Fix disable pause loop exit/pause filtering capa=
bility on SVM")

Fixes tag

  Fixes: 8566ac8b ("KVM: SVM: Implement pause loop exit logic in SVM")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

In commit

  d2286ba7d574 ("KVM: LAPIC: Prevent setting the tscdeadline timer if the l=
apic is hw disabled")

Fixes tag

  Fixes: bce87cce88 (KVM: x86: consolidate different ways to test for in-ke=
rnel LAPIC)

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

Something to remember for next time.

--=20
Cheers,
Stephen Rothwell

--Sig_/esB4f=Wx.bHI8+faGsv2avb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8mn1wACgkQAVBC80lX
0GznBQf+LttyGsuUjfAwm29XPgV8AcmseDQx2xVX4/1z1jj+4Ehf5oRiqzVxHALE
VN7+dE1bm1DeK/Q9PiVjnJycLTFtXyX1Q1D+U2mQ3kNj6+gPaoLKNXtANueaan/u
ys67FMzeJl93Ip/GpA0UAuSPZmkzO8sgoRnk9sp0uxzB62smPcVk0Zr+q12uhPFY
cF5Xqrp1E6gz+ITGev7I5gGYf8MbXRrgv5fHysMmMaHYmIC194U+ftoj9g9t3Hqq
u5vIapqZNyXvailDQKqWrfZUsExbV0a9PWJ+h6dFW+Ec62BdWxz3pTFlJSY3L1Q9
10ExPaa9y1xzIpuFoHB3w8ZYJqn2AQ==
=nM1V
-----END PGP SIGNATURE-----

--Sig_/esB4f=Wx.bHI8+faGsv2avb--
