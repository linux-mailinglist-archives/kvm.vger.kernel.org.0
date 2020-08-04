Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3678223C1EE
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 00:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgHDW3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 18:29:41 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:48147 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgHDW3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 18:29:41 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BLqDz0ZqKz9sRK;
        Wed,  5 Aug 2020 08:29:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1596580179;
        bh=WoofWK6zkGi4H6IHzt499LN7kOmRiarBusIWwUY5Z/o=;
        h=Date:From:To:Cc:Subject:From;
        b=JPK1eueYnJRZDa1+2G8efUrd8Ox4SRGyHjJTB08U07Vf2UriaxA76tmhSDTLqpZ5r
         KUxXMsR1vVfGNzZPn3hrYFvd4ra2s1FF2sF1Y0f7eWa/XexJNmq1xF/0bqgs/YT9gd
         U9RBeK5JVWTKyMRt2KUOxY846jIjYKChq1Kyx6RJZ5rq9mBlcrjCmwhr1Ioa1VONP2
         QCes0ypCmD6NjGyEiErtw0x16YWyEvXJmzMB5J9tNUESgCdjmTsJLO530vfT9eiERF
         pqHjZp1rtEh/p5F/w35eRs4DH3UhJwsq/7Holaq+fkRxj5F9Be5uK+7hEWwoVwNfq7
         DxCI7+KHZ62cw==
Date:   Wed, 5 Aug 2020 08:29:38 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mohammed Gamal <mgamal@redhat.com>
Subject: linux-next: Signed-off-by missing for commit in the kvm tree
Message-ID: <20200805082938.32f248e8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Sv.ebZX6FhRJQ2UIKrPRp0r";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/Sv.ebZX6FhRJQ2UIKrPRp0r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  1dbf5d68af6f ("KVM: VMX: Add guest physical address check in EPT violatio=
n and misconfig")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/Sv.ebZX6FhRJQ2UIKrPRp0r
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8p4VIACgkQAVBC80lX
0GzM+Qf7B8FXNsjEOtBNevQ6UOlERRA/SzXTAg8Dw9HUhJhIwkb5hHMX+JmtLaHd
tQtUQY6fZ0LMF6FTqFtbqMja4M4MTsjx8bN5FQo0jAWUtywRkvkjChVRp17itcpJ
NP4QNp2o2QmFfQI4Qe8I4MF1Y7Ckq1uiFYtW27eXmVha1gQCCZjL35VtdXn0jK9Z
04BYylurv9pzR4GghflCjjz5ipMLrZZEd8JI5pMLAPOcvOXzGOloQkbIAusxLGv9
D6NkIE14pOHygnvzCEiEQKGN4pd14iexnRfQZsHHMWOS7ZhjmUB8//Rqe8IO/qDx
nq5QWiCbfSzfjodPlpnTHdkILJw4Aw==
=cpTl
-----END PGP SIGNATURE-----

--Sig_/Sv.ebZX6FhRJQ2UIKrPRp0r--
