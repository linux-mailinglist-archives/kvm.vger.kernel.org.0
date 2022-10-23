Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0334460965B
	for <lists+kvm@lfdr.de>; Sun, 23 Oct 2022 23:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJWVAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Oct 2022 17:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiJWVAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Oct 2022 17:00:39 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168BE50737;
        Sun, 23 Oct 2022 14:00:38 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MwVwN4WThz4xG5;
        Mon, 24 Oct 2022 08:00:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1666558836;
        bh=wV5KugerMag1PAb7Aqhg9gBZ73YytMjo2p8Adkzoiwk=;
        h=Date:From:To:Cc:Subject:From;
        b=PvmVOWJPwW5vzRF5JId1U27hOAU+YdqKxzBMQJx0RLv2QuXGXhGRBcOFWh8d2M9Nl
         CPZQS6C2cotWMURMF9jHBLY6xNaazi4itFNxc/RtxHZb6ySvAQXLP4DyJFWLrp1DLz
         dIHAOWkwe2NIggJYCkYIUQaL15kUKJ3+YaOV615puAFKxAAb9cvU+9jdKnh+ikjqqA
         7wi9H5RhhT4cP7/8HwDC5nlSkhaLbo0mvvovlvm6lLqxaEUQsmbofmRdS8EDccvKXD
         E/ZP6qKUlMdxyR4QFW8qMRYYGNKKMMs5tEWS6CUYqU6ttSmgUo3yK5lEHGTekfbTdb
         6CzEwy6VavnNw==
Date:   Mon, 24 Oct 2022 08:00:34 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Eric Ren <renzhengeek@gmail.com>, Marc Zyngier <maz@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20221024080034.36cc4709@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/du1CgDVgVO=N4hCQS/+xrq0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/du1CgDVgVO=N4hCQS/+xrq0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  c000a2607145 ("KVM: arm64: vgic: Fix exit condition in scan_its_table()")

Fixes tag

  Fixes: 920a7a8fa92a ("KVM: arm64: vgic-its: Add infrastructure for tableo=
okup")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

Thus:

Fixes: 920a7a8fa92a ("KVM: arm64: vgic-its: Add infrastructure for table lo=
okup")

--=20
Cheers,
Stephen Rothwell

--Sig_/du1CgDVgVO=N4hCQS/+xrq0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNVq3MACgkQAVBC80lX
0Gx81gf+PUs59nCwZvxmmOlxhJVWZDgIYiymcP0eTmgxGWoKZou/zbCp9FXA4Cbj
SDGixcR8tdm+Vo+GgM8UF3kpakVM6uCYCbbfcWKNmn7EK8IYsVR2mbUO10mn+gGU
TbxRsACsuA5uzJ+c3WVvWYLEhgxcJIiStHbYno28LVqhHzt+j282U1Vs+mdNNJBw
GN3DjrJTjc1kKU0RP0QlZWGWXITMFrksvZUuVQrjGEVXcaRCfowtFoCCTSg9xOGk
5EhEoQ/mAGTitXIzPtvWipQlhV32Giyag/Uj8Xt3De6zHVLfS/YMHarU9XefW314
3Psb1k3G/yuaFmIxnUhpDwgHebEjOw==
=xwgE
-----END PGP SIGNATURE-----

--Sig_/du1CgDVgVO=N4hCQS/+xrq0--
