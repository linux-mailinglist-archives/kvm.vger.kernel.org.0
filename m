Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069F6112C0B
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 13:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfLDMuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 07:50:24 -0500
Received: from ozlabs.org ([203.11.71.1]:54621 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbfLDMuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 07:50:24 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47Sdx93ltvz9sRD;
        Wed,  4 Dec 2019 23:50:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1575463821;
        bh=TpLuQ4gPjW6F39pyE6T8j3XT7+Ol6XEeWwPWNAd3FK8=;
        h=Date:From:To:Cc:Subject:From;
        b=oIcJTdsX7P4bQiXg/tTwok99d45W5LG8vhZbS3jZ2IDoK5vSK6779PFUygL6+6e6t
         YseypujJqMaRpanRUqwi5HSiSSPoWxCh+VoBE7bMgz9QvsIV0/pCo8TMuzuVV885rU
         3h6+Vje0IlrehlOdddR3/64JgCAfaS9mOMEQ0xeHvzu/jbGbJXU1ubpR3aoXQj4b+j
         64hI9CsWa5DX79/p7ID7LbVQJ4LkYPF2WKMtcW0gRkzpG85YLGa3NsQrYEnBOdVW8e
         zmABco2lnt8h0wnfmncflxWZmSaKtJQtZAzfG7+TUUUFT9+oURhBCn2Jqf9AGXgZI8
         NgmfyD0TWa2jQ==
Date:   Wed, 4 Dec 2019 23:50:20 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm tree
Message-ID: <20191204235020.2e8e39bf@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/=oXvCgMglnVwzMn/jFTcJzI";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/=oXvCgMglnVwzMn/jFTcJzI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  433f4ba19041 ("KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUI=
D (CVE-2019-19332)")

Fixes tag

  Fixes: 84cffe499b94 ("kvm: Emulate MOVBE", 2013-10-29)

has these problem(s):

  - Unexpected trailing date
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

--=20
Cheers,
Stephen Rothwell

--Sig_/=oXvCgMglnVwzMn/jFTcJzI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3nq4wACgkQAVBC80lX
0GyLCgf/bz9XfQ76XEXH606Q1BRNkazO6byyzlPbTvrIGALWRZafyoiL+Ph8C5+1
sVvoTNH5dX942Ji+5vr6l1btPlVyE1ZtD8YAAnOBdIdN0vZJkSLMnMnto9wHqmy4
fNv+gEu1k6E78rRT+SXVk5NSog5G76jOePOcVkF/zbMbwUvvzD0W4A+vCXLDwvDb
/QIH+XHU2CUz3tWdYAdixDCY3DvHMQpBiovMFvmp6sjIeXgAHvEpvm/lv4YRH/7M
gO3xJcJi3sexhXVkvJUJY7hT3aaZGAxqAFuR6y4tLH0xwrTwuQjonwamfctN6qvH
uow2vA3r8dY0/w5jxE5lbg1SjaF81Q==
=cNbv
-----END PGP SIGNATURE-----

--Sig_/=oXvCgMglnVwzMn/jFTcJzI--
