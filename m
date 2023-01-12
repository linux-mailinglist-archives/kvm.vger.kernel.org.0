Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D1D66858C
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 22:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240069AbjALVgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 16:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238392AbjALVfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 16:35:48 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD237564D2;
        Thu, 12 Jan 2023 13:27:33 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NtHh43WZ9z4wgv;
        Fri, 13 Jan 2023 08:27:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1673558852;
        bh=rAODxuqk48nKj/uVHbAtKuCw3ifl3EXi8ZGj24YHAkE=;
        h=Date:From:To:Cc:Subject:From;
        b=Sqfom5VHt2vqu69t6jRWbzOqvPVVt0OHZ5XAHdrKnFKLBotWbSsettGplQ7PgcrHY
         drpd2riHIhRv308UJVuCDqS+rU0pVA6FcJondR9UjN4sVOkc5tt/WCjKqLeg1qyTyR
         QEnbvgVa9ibEMXs0Oj+0dKL2mb23fB2+7/8mSin2dNibK1/KCbGdrTbk7LOEebZuy9
         5KqBjSJTgHiq6NSXVrGjS0gEwscmv7IuDWjiRT2TgIwAE86Y7AWLhO9D1oKW0MV7Vo
         oAbHnfrgvVCKzww9qm4JVNAg+GK04Z60unqhyWfEsBN4R5Cq55jnhPgQwSOjFsMhcu
         BUIhFsBQTp+lg==
Date:   Fri, 13 Jan 2023 08:27:31 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     David Woodhouse <dwmw@amazon.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20230113082731.23df74fd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/YvsQoRftTL=__VyMrqJZSY=";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/YvsQoRftTL=__VyMrqJZSY=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  23e60258aeaf ("KVM: x86/xen: Fix lockdep warning on "recursive" gpc locki=
ng")

Fixes tag

  Fixes: 5ec3289b31 ("KVM: x86/xen: Compatibility fixes for shared runstate=
 area")

has these problem(s):

  - SHA1 should be at least 12 digits long
    This can be fixed for the future by setting core.abbrev to 12 (or
    more) or (for git v2.11 or later) just making sure it is not set
    (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/YvsQoRftTL=__VyMrqJZSY=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPAe0MACgkQAVBC80lX
0GxQ7QgAiZmVOjcHoThhWR2LVRbqyuAdxAJV5W1JFtoMYGfy/76RPHUirSg2LNZC
4B8aeZp2Po/TcsRWroeU5LNWjIqPXax16X96bFcnkpRGMg+GlviaG+JhKXfHSEUl
vMoZwnx7mr0upzChv5QqTZaW51vT/zWuLka4BJMLLeQGnSNu6tnasRalgsErXRgv
X0BBLXEqbfYrWvjB9sFv/SK30q40oHHBaajp+ZoAAWirDvflpkaZwVCTun7aIySJ
KBA9syfACQDSutvzMZu7GrBt54U0fETBTSF5if0R0EFcHvV0Ru1nyyO0Sdw8qjGh
m/UOgDYNTwfieSfY/UcwDoURrzINeg==
=gEzx
-----END PGP SIGNATURE-----

--Sig_/YvsQoRftTL=__VyMrqJZSY=--
