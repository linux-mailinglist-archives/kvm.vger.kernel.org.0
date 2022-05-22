Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3F7530017
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 02:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348490AbiEVAtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 20:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348667AbiEVAtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 20:49:15 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A684AE29;
        Sat, 21 May 2022 17:49:11 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L5MKb39Qlz4xYX;
        Sun, 22 May 2022 10:49:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1653180547;
        bh=6GBGQUNfenayWdG4wh7MBp6v8WRidvRkLBy3XrNfZ60=;
        h=Date:From:To:Cc:Subject:From;
        b=tqZfawZXWar8odKzH0NaVBTc6kdmbYm9rFgRcoXiLUhc4h7pFx6q5w8oyb+4T2NlW
         a0ZvYY17Y4CGC3fI+1Jn++Hyvy2Ysgle6EUlRmbRa5yy+IOV8V5e/Mmuw5MaG0HOHs
         qK49bbkfw7Zf3MZbPJDa6c0ge+AC5nVd4k8EUjaiRZ2D/hKueN4VKjnD6qN3PJS53M
         w9VnTHWQ+RKccY1pi9L721yNzAxt01lHRrRf4pNARBDxdTUSwd6LhyYLAyFcEGj6/V
         EzCsGPuVFJeLnG0/zMTV2xZ2I0nbZ6TNpymMvOb7dVNVjKTIeyoYmKF83lMm1xgiQI
         lVtvRFvwjCoog==
Date:   Sun, 22 May 2022 10:49:06 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm tree
Message-ID: <20220522104906.6d905d11@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/cLSV4iuw14whB3Xv2gynlzz";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/cLSV4iuw14whB3Xv2gynlzz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  abaaf90e1cb9 ("KVM: LAPIC: Drop pending LAPIC timer injection when cancel=
ing the timer")

Fixes tag

  Fixes: 4427593258 (KVM: x86: thoroughly disarm LAPIC timer around TSC dea=
dline switch)

has these problem(s):

  - SHA1 should be at least 12 digits long
    This can be fixed for the future by setting core.abbrev to 12 (or
    more) or (for git v2.11 or later) just making sure it is not set
    (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/cLSV4iuw14whB3Xv2gynlzz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKJiIIACgkQAVBC80lX
0GykiAf9E7tHEsjAxemxzP+zoGiThH9xQ4ulDS3y9+Vn2ar9lDGCUXAicD8wBdPB
C17a0OQ79rcARUtUXseDOxXtzeVBDjLmifI2YJuGMOSJXsu7e+vkHMXCDF6owLm3
ZOqU86eunLfvaJN86jjIe2hsdb1983RJvufl52QysE1chbGI69D/nkDHrTl9zm+h
8RwhuadUahIb5ryGdF76SVi8t+AIa7365ECAPz3pXvdzDMToTVLdYZLTnRZxQlQq
2PadSpa+fDFMB6Bq8zrmKRj5aqVOzm2vFBGPhtbRG8XjTT/12DRzIdCiV3RS56BS
PFhRv1zjsimRFc2mnLZGpTEZadHEcQ==
=rEO3
-----END PGP SIGNATURE-----

--Sig_/cLSV4iuw14whB3Xv2gynlzz--
