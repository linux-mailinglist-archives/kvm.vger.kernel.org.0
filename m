Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF96489496
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 10:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241887AbiAJJAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 04:00:35 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:52571 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242036AbiAJI6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 03:58:48 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JXSRT2PDtz4y4Z;
        Mon, 10 Jan 2022 19:58:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1641805125;
        bh=R24FBnuWNPJfvfg1NosQCQTFGwsK5/KBKgGWM0Ld1f8=;
        h=Date:From:To:Cc:Subject:From;
        b=jtML7XlxaRko5BrjYiatxljUcMHIAgahYBtgnQibGGyDNew5nCSuWVyPVzt+ztYzm
         zcxSTtKuR+f1Tt1peHKhTZAxFe7NTvRia+CHn2YpqMT7p6mkkoQe+/ocWNe9U+iSqo
         03ohRgH7mP393dgzKdwKdE/GyHE5AIJPb3oK68f12Kn0Jd9tlZWY8uutUWbggoruvi
         5vtJ7spsm97QolMA2/lh1DVUR9PYKZ6eXFaKu4ptovYjGffcgViXG28UoJYssHD4Is
         aGiSGpK/ehaPADxSRZZfbHMJU2bL2wGPSjrxk473wqEgHToJbgZ8p9E3113jpv8cV0
         CTVlCeWD1eMGg==
Date:   Mon, 10 Jan 2022 19:58:44 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Guang Zeng <guang.zeng@intel.com>, Jing Liu <jing2.liu@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the kvm tree
Message-ID: <20220110195844.7de09681@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4C4BxWxtIge57R94iiy5EJL";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/4C4BxWxtIge57R94iiy5EJL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (htmldocs) produced
this warning:

Documentation/virt/kvm/api.rst:5549: WARNING: Title underline too short.

4.42 KVM_GET_XSAVE2
------------------

Introduced by commit

  16786d406fe8 ("kvm: x86: Add support for getting/setting expanded xstate =
buffer")

--=20
Cheers,
Stephen Rothwell

--Sig_/4C4BxWxtIge57R94iiy5EJL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHb9UQACgkQAVBC80lX
0Gy0Bwf/ccjEHDcjRMn5LJuKO9LbYxlvmOgdwL7/pN6XodM3qa6+Eu3LIsPEMHWs
I5VM3RqEQzXHRHdC1V39KBdU1UZ9J8YUVMuISwdVfr3LycJsiDyS4qrP0bCR77H0
fyOU9erOhvycWBf/oKYVipG6pV0gXBguWS8T54ay+w4/y6QsvUcKnxF30++nTvNA
UOPBhCC0sa9Q8lBtVR5cSyO54xN3MVkTdiiEdPbUljGPNM8VLx2xnZpYTeVRXPjo
c9Wg9O+oFmSzIgv99wtHWLt5bY/VlP9fTSFGjTrTA3La8H01QqxtH68ho128I6x/
ZWt52XprkJdtCo/1gfp7rAJlEO6Arg==
=V5n6
-----END PGP SIGNATURE-----

--Sig_/4C4BxWxtIge57R94iiy5EJL--
