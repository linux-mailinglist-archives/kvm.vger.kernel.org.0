Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157A21AFEA0
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 00:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgDSW06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Apr 2020 18:26:58 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42495 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgDSW06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Apr 2020 18:26:58 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4954FD26njz9s71;
        Mon, 20 Apr 2020 08:26:56 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1587335216;
        bh=1t3nKIxwa3UFVp+S2fzmC0xdx/aJrfbzuPaqGW3cEpI=;
        h=Date:From:To:Cc:Subject:From;
        b=s3PNsvb5x/DOlUJygmoCKz+eeXNWrMLRoRU0nuvgsdGiSVvMxsyvClI+p670aZfir
         iEn36Jdk9+mkR6IUrX9uRGcU+WPMs8+VHvACGHW83Mmb9VSHPPeyHwLLfyNHEEUsXy
         YZApkT2eN+vfYpEPO2gS6wotObhRhcA9bp/VUWWzmJUwcuqBPANiPKlDq+P5hXbhSW
         38Fz+R3KSbCVYs6nbNOGxwG9FkbWsdiheI9d7GYjetVFKufmncbQTDbNI2hno0b1UY
         HFV7Oqnda49MhMQfAWpZRjHjsBPbp6E9P5tt3D+vstraWDOcRInoF/Yzk1Sr55LaeI
         INBb13ObOH7Xg==
Date:   Mon, 20 Apr 2020 08:26:54 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the kvm tree
Message-ID: <20200420082654.0aa91ae0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/JBlD/qXVz.FuC7+N7En=Zi=";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/JBlD/qXVz.FuC7+N7En=Zi=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  0d16b11933fc ("KVM: x86: make Hyper-V PV TLB flush use tlb_flush_guest()")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/JBlD/qXVz.FuC7+N7En=Zi=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6c0C4ACgkQAVBC80lX
0GzvNgf7BWQvV/P7qGKi28lD8sp6PbM5bJjCjwYM/OE94K6buCGz8xKgBWGzU7Jq
3jtkETOArBRxvg9Ai3uKD3PsHxBDATtwDB2bwrWAUdq3aN3o34FvQrAyZr/PEg3Z
ENtATX1++Xzo12yPZLvFJkGNSBWWeyMFCMrmW+hdE9cQR/no7TdML5oCoWairZUK
RaL4RvTxrhpyHEV4fB0/Ekflblltl9Tcz1s2OaYnT+yAharFia58RsVOK66ioux0
mktOpfscoBF8MAywLyvk5DHJXV1Gso69APAzNb9jrGLzEqoSWpOIcqrE8GluPhJD
A6k2JaNwXTcMqcGXyXS8SNSXIFCjAA==
=McZG
-----END PGP SIGNATURE-----

--Sig_/JBlD/qXVz.FuC7+N7En=Zi=--
