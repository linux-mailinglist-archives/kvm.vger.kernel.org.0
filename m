Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFBE57BFE4
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 00:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiGTWGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 18:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGTWGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 18:06:01 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4963AE42;
        Wed, 20 Jul 2022 15:05:58 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Lp8sc4fkDz4xCy;
        Thu, 21 Jul 2022 08:05:56 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1658354756;
        bh=vPttMMWc9zt/4UolFz2K4BGs30yfO2taUQuvNVWruNA=;
        h=Date:From:To:Cc:Subject:From;
        b=LMktGf0Pq4PSTwSj8k/uLW2YsSjjfPPqe7rDn6ysJie9ZNqvp6G4MrCsIIMkFy6XK
         yrl+7PEpi5WuPOrbuMcFjaiFMxaXPma5SIT4RCpks2RzLz7LraqKxzLyuPSfvyHp1N
         ry9hDrqI2Gj2PizEilgZl+f8gFo04bWy/qTlkk+kUoOXZED7HhQKIKEKNn35zy35Bf
         xXQYLdUGR4WY7914iH836/3CqS3UXwXFnEWpvc3q0QqNj4Wdp4+VDzIVB3vfHA3SLv
         mCQIHGhMv7UbSh39V6f+zS7Gjp/4klKyfCoW1sdkqs8s59X6Gn3He7MRjMdVsdVHx3
         CWCAJRjHMxHCA==
Date:   Thu, 21 Jul 2022 08:05:33 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Colton Lewis <coltonlewis@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm tree
Message-ID: <20220721080533.7d71118f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/0n3Xc2=LMdbu=kEa=+SsFNA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/0n3Xc2=LMdbu=kEa=+SsFNA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  594a1c271c15 ("KVM: selftests: Fix filename reporting in guest asserts")

Fixes tag

  Fixes: 4e18bccc2e5544f0be28fc1c4e6be47a469d6c60

has these problem(s):

  - missing subject

Please just use

  git log -1 --format=3D'Fixes: %h ("%s")' <commit>

So

Fixes: 4e18bccc2e55 ("kvm: selftest: unify the guest port macros")

--=20
Cheers,
Stephen Rothwell

--Sig_/0n3Xc2=LMdbu=kEa=+SsFNA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmLYfC4ACgkQAVBC80lX
0Gzdtgf7Bzce09XsU0k00K8INDOuIC7bNo1V1hKhcQUjhO/u0P5i5aKJFdIPcyh5
qjP7Q6uLne8iKerxJbKVrCdVBkVu98Goxhz7JDKAgtVIMnQ9WuMndX2QrsIV0ItL
APdcqEK/pD8RDiPn+MhcZwHSgOuvib7JD2Yj/0hnYpViEJnUB01UPR6herFOkUBt
5plJVroVUADNmPhfV6kR3c2RZnVa0rT02FUlezuQndCaLOV04lviqd8Q1roWecf1
Z/dHQZY8mqWN+s+mjep3eEgigVX3tBJZRSVT+RNqxnNOVGEc5/4sSIc6vBpRU3p5
MTzIONDtQDoi12T3Qa2d835q6RSYaQ==
=07cg
-----END PGP SIGNATURE-----

--Sig_/0n3Xc2=LMdbu=kEa=+SsFNA--
