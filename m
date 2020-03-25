Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2920191FB0
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 04:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgCYDXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 23:23:08 -0400
Received: from ozlabs.org ([203.11.71.1]:33351 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727253AbgCYDXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 23:23:07 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48nD2w7478z9sRY;
        Wed, 25 Mar 2020 14:23:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1585106585;
        bh=n7eiGYig6krIs++Oy5vPeQXUu0dNzX6a8k72efUO+xo=;
        h=Date:From:To:Cc:Subject:From;
        b=tw/wbObGXHTxQTh+05Er0CnzM9ef6++/fPqPPP0i/chwqQA4BPd63wiB0hoW7fiiv
         +NvpcLNJdgEAeFZpX5805JMSOL2seNp1gvVQGwFGYR8/7H50ws8TwnQmssBgMH5r2Z
         uJDfcHwhoMK38ZOqX0UtazIYwHrU5/4kVBH8+6GJPEAMppLbteBg3H2lkb2A9KwoQ1
         W1esx9nylCD+EZ9xAI4u8+G6+o+AR06APU+2krnXzu+EnNY8EHgKMHX8WSw8ywWeoP
         LZKjGAIa+tJlSyLFxWh4yqgZcPdUuEuBZQD8ZXV31hM8VTXhK5r5ov+nnOpbkTmRvj
         WF6M5JTAvgUXw==
Date:   Wed, 25 Mar 2020 14:23:02 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20200325142302.75d5c4be@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/kZ.GubDEXycMN50rB_LcFxU";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/kZ.GubDEXycMN50rB_LcFxU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  arch/arm/kvm/coproc.c

between commit:

  4d395762599d ("KVM: Remove unnecessary asm/kvm_host.h includes")

from the kvm tree and commit:

  541ad0150ca4 ("arm: Remove 32bit KVM host support")

from the kvm-arm tree.

I fixed it up (I removed the file) and can carry the fix as necessary.
This is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/kZ.GubDEXycMN50rB_LcFxU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl56zpYACgkQAVBC80lX
0Gz2Jgf/eBESpCAhULsWMj2tymIqL397hLPFT0EfOxWq2TR2k2y+l+rQ/oL4z+nf
LjF6yz+2KZDwCCYj9vRqs72H29+6DofzvU8teL3DYdR2enzfVlzanmZ7AgfUH1un
TtNOlvBoQ3OQV1x0FVZPP0wEV98tsJsIElIU8+lS01lFo03Mv+OGIM4ppFqaBpDn
Ja5fBPVt4GUTbCy4rk14bPGzxrYawWi0a168Pin4jAflAujZEeH/EU0+Z1wyGnVI
89kNNEXyK213o7QPdsTu+rTZLvYMCuvEPEA3kSSve9RbIlkHEbysP7bvzgCpoHaG
gsSrDxml0tJn62ADbE5PS0qZHu5szQ==
=bF63
-----END PGP SIGNATURE-----

--Sig_/kZ.GubDEXycMN50rB_LcFxU--
