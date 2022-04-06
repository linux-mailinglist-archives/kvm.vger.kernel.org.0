Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9819F4F6D6B
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 23:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbiDFVxr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 17:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237441AbiDFVxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 17:53:31 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94E863B9;
        Wed,  6 Apr 2022 14:48:46 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KYdSF12Bbz4xQp;
        Thu,  7 Apr 2022 07:48:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1649281725;
        bh=DK+cW/YSbM9QgVsfA5avIq8Gu1o021YU+/DT6CxtWjU=;
        h=Date:From:To:Cc:Subject:From;
        b=laYmvDjk7ccbjaCiEwOdNagS8zFtObDx+4+vqJ03uQvo8LfOBqhjFjeYsA2eYx35Q
         r5AZ6rKDEs6CAw8UkOULDPsV2NE7a4VygnZQNhK6NamiZoVPFPew1w+8jIRlsJS7fl
         KAI8uu0WlaAy696klBOUFpiUT0OAsRyG/jTF8asv8YlVExOxzUToYOiIh3TZPDtqQ2
         nfVoLBICXgvVRZtDOvC308vyl1AZWj/D3JqMhpBj/7fhaTnjZ0fMfDCDKErR8XK2IT
         NOclIVFKqpnFvvlOxQZ5eAz8sOEiRwZArPYCHbly4K/NpZPXAs3/kG9JkRWQ/5+vCX
         ZPL+8Su2nRd8A==
Date:   Thu, 7 Apr 2022 07:48:44 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20220407074844.110f9285@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+RrxcgKx5ma81EbkCOODyfU";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/+RrxcgKx5ma81EbkCOODyfU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

n commit

  c1be1ef1b4a7 ("Documentation: kvm: Add missing line break in api.rst")

Fixes tag

  Fixes: da40d85805937d (RISC-V: KVM: Document RISC-V specific parts of KVM=
 API, 2021-09-27)

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

The date does not add anything.

--=20
Cheers,
Stephen Rothwell

--Sig_/+RrxcgKx5ma81EbkCOODyfU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJOCrwACgkQAVBC80lX
0Gxr6Af+KSn9hJ9N/4vtyfaVu1a3EwBDJCJ+TQEBOxdLW/cpZH1+ZkH3/9dpT2Wd
1pmOzhKB92NCgZDHI0TcPWVyJcdKL7yPU3Ci+DhVcH6Qudr4bbG8OK4MdkZHAqHJ
zAjX2yLcQFdk+xcxoAQHy9Iw+BD0VzC68Punaf3JJ8jHjI3p9QOFrMZkSWFFZjCU
mOuvIo/I4hFZryudu2XbpEXnLtTMhzehfVaX+RcprFUred4Ku+EFsn/IUUcvuZy3
Uctwuc5P2bnsb52Nb7LzqRrZFtXInqkUh99hfWoHTBs/20FLjI7XhqRHM8McN6Yl
Y4hJLzLeBGZ+y+YMzg9f53fTTxRewg==
=AOr2
-----END PGP SIGNATURE-----

--Sig_/+RrxcgKx5ma81EbkCOODyfU--
