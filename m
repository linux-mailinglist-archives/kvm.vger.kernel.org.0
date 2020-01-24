Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA39314771C
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 04:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbgAXDNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 22:13:43 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:45357 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730664AbgAXDNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 22:13:43 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 483kkF0d8yz9sRK;
        Fri, 24 Jan 2020 14:13:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1579835621;
        bh=xjH+ret28pP1Rq1aa24wBrrovKhsRU+e+N3Sj/jXDmg=;
        h=Date:From:To:Cc:Subject:From;
        b=WCoDdnF1RjGF/PNWyp0sEDUtzZK6Pk5Z7mX54PGEtDolCzq8iriPEux7//gYU0NJG
         fqDlOP5aq78J54W/mD6Q9J8EwKYZjMGVPGvs8hbdUj+fYhuhqPH+MmcVNMAAv36R9w
         QiDNTHSqE/TQLNcI52YvYAmIKSLkPP9gABg48sXGgqMp9PP97yFTElzpmektqzd0QV
         AFOYOAH2v44WrrYKaeArxb27ZB6McOAuzwHVUUaELMYg94eVLFCB3RMZBif8V3iH/q
         +ugHZuFP0FQLuf/h5+l6Uf/58lNdWJd3CF6bMOfJvoTa23dKKqBj/qXT18lzyfbJhr
         49+AWK8v5yCSA==
Date:   Fri, 24 Jan 2020 14:13:40 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: linux-next: Fixes tag needs some work in the kvm tree
Message-ID: <20200124141340.4b3d10d6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/K0AZeBGCvjZfU/VXQT95PO=";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/K0AZeBGCvjZfU/VXQT95PO=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  90bbff59a2fb ("KVM: x86/mmu: Enforce max_level on HugeTLB mappings")

Fixes tag

  Fixes: ad163aa8903d ("KVM: x86/mmu: Persist gfn_lpage_is_disallowed() to =
max_level")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: 2f57b7051fe8 ("KVM: x86/mmu: Persist gfn_lpage_is_disallowed() to ma=
x_level")

--=20
Cheers,
Stephen Rothwell

--Sig_/K0AZeBGCvjZfU/VXQT95PO=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4qYOQACgkQAVBC80lX
0Gw59gf9GPhre4+kKVSCk14xUoU3XnCAD7BM6z9Jlc143Ve36MP6/dfcBTDQF0Hc
7Gi8TthRESW+EoYnXhL93vof5iG0SR4a1rKB6Kl6GfxWOMFnv37BAxa4sCcDpXAk
394UylzG3k8+SPT5sYynGuw6h+9iOTIA8u0gkgK9EOaYQf7VLWwbIwj2iDCQ8EIt
rgV7z997/6OWBKACI9x4JXn9ry8U3pluqr0ACc9urTxCDXvlVQXuotDgG8xkNNBQ
kmFCwjW+4u3/YMqxj4HnDX14M/x9+WowgodWNnxYTm9rJ1IQr0hOSb9/9pQ5m7oJ
5A64bv2mzflYpKeVvjjyGhHi8Asg4A==
=I5Nf
-----END PGP SIGNATURE-----

--Sig_/K0AZeBGCvjZfU/VXQT95PO=--
