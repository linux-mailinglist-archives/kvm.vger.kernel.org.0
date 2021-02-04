Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9803130FDF5
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 21:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239984AbhBDUTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 15:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238716AbhBDUTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 15:19:06 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28866C061786;
        Thu,  4 Feb 2021 12:18:24 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DWqcZ0W0pz9sWd;
        Fri,  5 Feb 2021 07:18:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1612469902;
        bh=N8skiq60b3p/JqG4vFT3wOC8/bdobmxVebk0bQHMSI0=;
        h=Date:From:To:Cc:Subject:From;
        b=KrbNgKAy/XkH4agIDGVO8B1BNfBf1JakX+yp2RSx22Iasv86pTPv5+cUtxY+IfnOR
         3xiHlE4ceFfqeDvur+abTFKvC3CE0asdel7byipJAfkzf34zDhUO6/p0olOe6RrQP/
         pArbQ3INi1gfV1ETLApZNjPckb2EJefqpXY+4YZSZCpRDxzTW0eSnGMId0JeifxKtP
         YYhPH6acdS7oEAA69GRoGQ80Sxw+lR/mFzxUKNwuf1X750a40vCrCnKND0K94YCLci
         0nJLyht+bo/5KEEum4vUrk+z71gS00QZxWqcDNmIGcuJY/WsNacrFj86TX7vc+L4YO
         gWobYiJLMHcgA==
Date:   Fri, 5 Feb 2021 07:18:21 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the kvm tree
Message-ID: <20210205071821.7cbcb8b8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/vLbwssjVGP1sw9uxvwcA_7k";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/vLbwssjVGP1sw9uxvwcA_7k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  79033bebf6fa ("KVM: x86/xen: Fix coexistence of Xen and Hyper-V hypercall=
s")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/vLbwssjVGP1sw9uxvwcA_7k
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAcVo0ACgkQAVBC80lX
0GzXCAf+OrgPxg+4+TDGkl9SBZMVpm9HB6ND0x/vEPNVqkj8qUyRzwu2CoDAXCFp
w3rk7a37v21RTdO75e5LAmdbSW3o3T7Bkj3K38Orb91HF0u9931lMEcaBBVSrn6d
MIhS/4l/PQFEuMH7J1HfrHaP0yuJXU6zCsPt8PWqqrFMyhg0TPzQjsqGLhNbORlV
Nk1ee4vVb4g7pAcrpri/0vNWrHn996VBjl6/J0FYiS2BEGM/am18mAWAqPGjPHwS
all6OO0ASSszXNcTlnuDSbtU3M4pdM39Ejizp1cm7v4FObzmMWu7nVQx/fwwB17A
ZDZwnbMk5aKqXN9Hn6gzO+9XOfYpkw==
=db6f
-----END PGP SIGNATURE-----

--Sig_/vLbwssjVGP1sw9uxvwcA_7k--
