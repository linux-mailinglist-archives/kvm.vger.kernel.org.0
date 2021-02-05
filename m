Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C089310450
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 06:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhBEFDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 00:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhBEFDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 00:03:09 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5B1C061793;
        Thu,  4 Feb 2021 21:02:29 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DX3FF6YqMz9sWk;
        Fri,  5 Feb 2021 16:02:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1612501346;
        bh=NwPhTvIeS7tT6sFRTFNVfX2+yQiUXpr+GF1SGPGTVRg=;
        h=Date:From:To:Cc:Subject:From;
        b=iBrzxUTgWdVUMc/gPmR1pOhFXV76hVgHeLhKNRuiDN5wSmkzSuKMhlYTA0ncV1s1T
         YKCGKeEdHZtNlYNK7oFFi6c/D+JEzZ6ZCcxygZ3BOmtyzcx9PBGfcvsHgJ+BQfHWSs
         dMHt9b+/mDW7JKHp4nN/hv2Qtg0PtAeoQmSVNupILU4urJW3YA9x79U2ow3RT0Y8Eq
         MfFAnjqjbgGGiplgdOOVyfbcPMSb5pIVD4b8ErmKbM30j/NjLQA/W+91mMNL4jK0yP
         n9s/gRrRRqvUPGHKIEMDpV0P7XFEmFb7gZyGu7i+R0N4Qg73pnuo50jmotjBix79Zb
         kgph57bsFtlbQ==
Date:   Fri, 5 Feb 2021 16:02:24 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the kvm tree
Message-ID: <20210205160224.279c6169@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//OpUMOxbSSs4i.X0XPqqfSp";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_//OpUMOxbSSs4i.X0XPqqfSp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: modpost: ".follow_pte" [arch/powerpc/kvm/kvm.ko] undefined!

Caused by commit

  bd2fae8da794 ("KVM: do not assume PTE is writable after follow_pfn")

follow_pte is not EXPORTed.

I have used the kvm tree from next-20210204 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_//OpUMOxbSSs4i.X0XPqqfSp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAc0WEACgkQAVBC80lX
0Gxm/ggAmG+C/t2Rcdu9XsILQceXyRaALEn126Vx5BKNYF2sIEm/7LB4nZA67bth
7FjQyn0/ZqD7RmmLy5z5Y8SxSi2iv9ccJI2pB2qmI1W5r+YwwBRNa0lxZJ/P+sz0
EqfoSjczwEJ0Fpsm1FsfOEGBhCBK2ocD0HcxaDX99VNs/3EHPnKsrGIpyhlRs2t+
F2EPG9cu7sE8dj1gQaaUZmLLNDdaiBXvt3zODFHYKiXODYz6tpKyJC5IbqB+ntLC
N0PC/oks0xzxo2KOpF7EHXC86DP5VSKKjMhhJJ+pQw+Exd+FLThEUUm8Zub2p6B0
/yL3veBTD7s+Z1dxTirkQom9/mYZ/Q==
=XWFj
-----END PGP SIGNATURE-----

--Sig_//OpUMOxbSSs4i.X0XPqqfSp--
