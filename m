Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7538E41E416
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 00:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347816AbhI3WoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 18:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhI3WoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 18:44:07 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F76BC06176A;
        Thu, 30 Sep 2021 15:42:23 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HL7Xt1Mvyz4xVP;
        Fri,  1 Oct 2021 08:42:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1633041742;
        bh=Fw7ZflyyDrdHyzV56mp4VSB3MF2k67NkE7+G3Rl3yes=;
        h=Date:From:To:Cc:Subject:From;
        b=QKmU207F/pKn/0liwnV94nwAxBYJ8fF+VgUT3o6VVcYtK01Wd5pqrpkyGrrOMzrOZ
         QaZLGPlf31dmtlLhrG+vSum24mHNc7xpv2oB6waVUBO4I86UFksYHtG8uSpo5dUA00
         RsVG1FDCjk9nn/QtsXJyoknTEnUDluQPibzEQV3ZDQKG0qp/j0AyQABHkN4oxOyyC9
         fCe+x4YXH6JGPbqpZbn8iqFokWmp/YHWBzQRFj0hFED42xcyvoBmDnBkPKhTOShTp2
         XCKkb3Ew5SFzEookIWPTxMUYMjV7bwwnrFWQlKFhFwcDv7igIYRlJi89XCfPzbnjrK
         z/xslEkXY+SeA==
Date:   Fri, 1 Oct 2021 08:42:21 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the kvm tree
Message-ID: <20211001084221.78ddd9ee@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/o.FcVG.Zz3jywx3AKKtCZTu";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/o.FcVG.Zz3jywx3AKKtCZTu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  912fd696981d ("KVM: x86: SVM: don't set VMLOAD/VMSAVE intercepts on vCPU =
reset")

is missing a Signed-off-by from its author and committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/o.FcVG.Zz3jywx3AKKtCZTu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFWPU0ACgkQAVBC80lX
0GwmwwgAogW2GXM/xiK12ejpD1H+3yCWJQW/Gat2jUHi3Kr+B6nY5A/QTWfWN/hB
j7EqkNBfRf59Bwxp80UdTSPwxYzh4OBfK4qNFl+XESXoPuJMpEq0ZR509u3fIdsp
xnbFsJiLTv9/AHOA6ssrsdihwv5I5QK+cHmgqYGXDw1s3ySvT2LsZU69JihhjAcK
EXoLnI7EJyXWN62yDGnqICbSa4LsZvjhg2agL8vxhbPad1vXvW9dvnBJYWJZFyod
2/861IpkkSTmq+FXXXXpYlws8jsTDOqr/pms0FpR6nsLo4XfKc4ti7YGW/sUa32i
XJW20TK3pZG6A44uex+ugN2s4Yu23w==
=+AlV
-----END PGP SIGNATURE-----

--Sig_/o.FcVG.Zz3jywx3AKKtCZTu--
