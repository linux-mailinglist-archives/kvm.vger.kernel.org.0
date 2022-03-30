Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC554ECE11
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 22:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351065AbiC3Um2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 16:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiC3Um1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 16:42:27 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716AE1409B;
        Wed, 30 Mar 2022 13:40:39 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KTJGs1Cflz4xLb;
        Thu, 31 Mar 2022 07:40:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1648672837;
        bh=X/DC+4WoH4lqMOOV5oagJRxXJ+/7Uo6idVeEXbG3F1M=;
        h=Date:From:To:Cc:Subject:From;
        b=DuthNKoHeLD2BAore1SqxccPdxWqDPrdV3VCGT/2bNKoriaGGhhyw95wWgIFMOxU5
         HG/vUeZrn2gaMvr5jw2jC9WteaO3vxVh/q6vBOvvs15pS+b4jaFcQPZPQP/G/7vnvU
         RwhTcjcF5wWVKrmFh6g2Rp/HszOW+133i0y6byGBKRnxT7/c+ZPbL8UUDWGB50MhAx
         imKZYem5Ix3Bc2PLjRAOqCwfgD/d3Wb4DeJ+rwgs12onS25ONMZMcoXXwx/HKuujZt
         ZflNk0EYqSlGlYLv74B1l97Cvm/h+yXNWaqvgUVqd4nn8oFCfFm/MXEeQ9V2pB7p6K
         u0LSHgZiV3JgA==
Date:   Thu, 31 Mar 2022 07:40:36 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     David Woodhouse <dwmw@amazon.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-bys missing for commits in the kvm tree
Message-ID: <20220331074036.68c3dcdc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fbGDH=nd/pGqc+Fp5DSOsaf";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/fbGDH=nd/pGqc+Fp5DSOsaf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  0a1b5a0416dc ("KVM: x86/xen: Add self tests for KVM_XEN_HVM_CONFIG_EVTCHN=
_SEND")

is missing a Signed-off-by from its author.

Commit

  8c5649e00e00 ("KVM: x86: Support the vCPU preemption check with nopvspin =
and realtime hint")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/fbGDH=nd/pGqc+Fp5DSOsaf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJEwEQACgkQAVBC80lX
0GwUgAf+O0yOOVsJIaJz1ipnJa4b0yLJo6cwUv9UxymkOVQWVghKc8mp95+SBPh1
NsYv3HPj4AKRrdXN7AUMdb4xWbpwDE4fR8h3w+xR1+GeQ6WxhfWgv4vZ+QUxoNV5
D2nmawzB07ka/OK7OB2/pteYMReD3Kpa7YjOx6cF70Rt0Wac4OTGADWHRGBEQUjQ
MghyVaEFyUmUrl3KBkNx3OBtc8Mgh3HpXBmR5b8jNbEWVC78wuClt80MEZHrWzeL
u3H/nSlFCrtnZXQ94WzjUIIPBg13GBRR4gX+meZH8OgzAKyzWIWOA5z/+eCzv/3r
0Qd9yWjVcG7A93lxn887W8Wl7lPEWA==
=Nchx
-----END PGP SIGNATURE-----

--Sig_/fbGDH=nd/pGqc+Fp5DSOsaf--
