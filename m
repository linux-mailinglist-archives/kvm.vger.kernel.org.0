Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F8F7A1293
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 02:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjIOAvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 20:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjIOAvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 20:51:31 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7C426B8;
        Thu, 14 Sep 2023 17:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1694739085;
        bh=62vzByMzFAc73j9n4JKFWW/CFI6vv7aJjHKFsQARQcY=;
        h=Date:From:To:Cc:Subject:From;
        b=gIceI6ZSNw6KcnsuPNGJ/z3UBRXrhQXFMILzsrBLdS25Orb+2XbMZfKqzXNIOCOoB
         UPjvCm0s8KcX6m3cG5FDFshu6vKsATrBveOZA35RGacZJHprMi/g8TqEzrvYeQxM00
         CwMuJw8sqLnEg6KuoKuEwB4WgtVwT4ql7IJY6ckuIQqr4oZdX2oO0culwGdNG/AHly
         mhq3gWIAbg5nreA+NI7c4DsQLCIYYcCERRcBK/bdroFj5enLlWMkYI3t5gqbAidyO2
         ammpKCQUec0e/fLAdAmPXI9xnYmQYM9jndQSAFmVQS4af9h3+oqAP7fVcuIMwqmCw5
         nqd30eVm3TRTw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RmwcF51l3z4x2b;
        Fri, 15 Sep 2023 10:51:25 +1000 (AEST)
Date:   Fri, 15 Sep 2023 10:51:21 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: duplicate patch in the kvm-arm tree
Message-ID: <20230915105121.3f3e7c29@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/cdjhKfdVR27b_XIwHziRtP0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/cdjhKfdVR27b_XIwHziRtP0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The following commit is also in the kvm-fixes tree as a different commit
(but the same patch):

  169c0f23cacc ("KVM: arm64: Properly return allocated EL2 VA from hyp_allo=
c_private_va_range()")

This is commit

  3579dc742f76 ("KVM: arm64: Properly return allocated EL2 VA from hyp_allo=
c_private_va_range()")

in the kvm-fixes tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/cdjhKfdVR27b_XIwHziRtP0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmUDqokACgkQAVBC80lX
0GzXrggApATE3ciUEdLzY+Tq0UGFRP6iRNJuN6gH5/abfAcuGd2emUoNp9bzFzA7
rIwyKX8ul25i7IHXfLsefSVe3/gceLpiwHNFyGf9q8ulcok0z34t8ZWKVHKPLW17
pD16w6xS0xujqJK6lJnq9ZGxDDSsYjmb4SZoULKvHTD6QEk2FmLigSVaB6ptLrDy
wskP+eqmQsa5FIoGfJB/OTcQzmrbtNKRbbM108HLp/tsJbbX7FksyD5AoA6X+0Mc
Tyv782yy9dZ8p59E9wlM1cugi53CZUY1CfCXyScRnr65mf1QXt/SyhqPoDeN7HW7
/ogh1x46coJBtj/Tnrhf0MzctVdneA==
=0c+Y
-----END PGP SIGNATURE-----

--Sig_/cdjhKfdVR27b_XIwHziRtP0--
