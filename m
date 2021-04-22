Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA39367CEA
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 10:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhDVIvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 04:51:45 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37443 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229938AbhDVIvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 04:51:44 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FQrk35PBnz9sTD;
        Thu, 22 Apr 2021 18:51:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1619081468;
        bh=p7v/3ySXxGYxDQXo7zR2Tdflwe/TTbmWoQHtiMgfIXM=;
        h=Date:From:To:Cc:Subject:From;
        b=a3mAbpplPOMYKzbFsuJnitDwhKx897ZNNJGMBtQK2fgOZ3o4NhDDH6lywMyWXT1i0
         Gc4KwS0ujQDyO+Y7QQ/WWm2q1oQoi7mQFjILPzakBEokZuLUHeJbPPaJLQ61Ad2Ixq
         s/AbjcaVMy2mrhEPWZk+f8YA3Ueg3aj/7txnHrxF6EFXAPaH+ZaIvpszu0u02lDi4a
         0mcx4NYhgxijdRg0RwW+iyLMaLdSS9BOhAbTptD6VpT3VhzNjRcLJHUf9PDXaZIdvJ
         zxKFribba5UjFLb7ykVLqdLTStoZiBcv4FAJTvOAVxtYfU+7BeWh+tQsEFgnwls/Do
         bRiP/1sAvWWSA==
Date:   Thu, 22 Apr 2021 18:51:06 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warnings after merge of the kvm tree
Message-ID: <20210422185106.046d2cea@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/tBluxrhKiA0gdSsSGl7x42M";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/tBluxrhKiA0gdSsSGl7x42M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (htmldocs) produced
these warnings:

Documentation/virt/kvm/amd-memory-encryption.rst:308: WARNING: Inline empha=
sis start-string without end-string.
Documentation/virt/kvm/amd-memory-encryption.rst:310: WARNING: Inline empha=
sis start-string without end-string.
Documentation/virt/kvm/amd-memory-encryption.rst:313: WARNING: Inline empha=
sis start-string without end-string.
Documentation/virt/kvm/amd-memory-encryption.rst:316: WARNING: Inline empha=
sis start-string without end-string.
Documentation/virt/kvm/amd-memory-encryption.rst:319: WARNING: Inline empha=
sis start-string without end-string.
Documentation/virt/kvm/amd-memory-encryption.rst:321: WARNING: Definition l=
ist ends without a blank line; unexpected unindent.
Documentation/virt/kvm/amd-memory-encryption.rst:369: WARNING: Title underl=
ine too short.

15. KVM_SEV_RECEIVE_START
------------------------
Documentation/virt/kvm/amd-memory-encryption.rst:369: WARNING: Title underl=
ine too short.

15. KVM_SEV_RECEIVE_START
------------------------
Documentation/virt/kvm/amd-memory-encryption.rst:398: WARNING: Title underl=
ine too short.

16. KVM_SEV_RECEIVE_UPDATE_DATA
----------------------------
Documentation/virt/kvm/amd-memory-encryption.rst:398: WARNING: Title underl=
ine too short.

16. KVM_SEV_RECEIVE_UPDATE_DATA
----------------------------
Documentation/virt/kvm/amd-memory-encryption.rst:422: WARNING: Title underl=
ine too short.

17. KVM_SEV_RECEIVE_FINISH
------------------------
Documentation/virt/kvm/amd-memory-encryption.rst:422: WARNING: Title underl=
ine too short.

17. KVM_SEV_RECEIVE_FINISH
------------------------

Introduced by commits

  4cfdd47d6d95 ("KVM: SVM: Add KVM_SEV SEND_START command")
  af43cbbf954b ("KVM: SVM: Add support for KVM_SEV_RECEIVE_START command")
  15fb7de1a7f5 ("KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command")
  6a443def87d2 ("KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command")

--=20
Cheers,
Stephen Rothwell

--Sig_/tBluxrhKiA0gdSsSGl7x42M
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCBOPoACgkQAVBC80lX
0Gwexwf+IrxvFyKV6PKpV6ooXpPzYu3kHxO9w4WPAJX0q+tlebcPh5ksMqVVfDAC
kv1TRZVTBdHW4/oA7NYT9azJpIibspdsghOUtNXxK4vjNajNG38bVLdxwd2p10jN
4OM829dHJDoOQHFLg90ss+iT6tYVS0YY/IE1bPyLAMZwWy/f8lz3PMx3Jj7KuV/s
Q7zNeaqgCclek0qS7TC4+PiRPV2JibH/0A2i35tCDwuP1OTvMWzdyWXqTOgysigu
TNYAatsNQQQvlQU//pLPbTOehqJhWd726qraOiHw5Ae0chiCbujLeYFmmnUvXNuH
RP9arUt7WYSogYa07+/8cvBpgfJZoA==
=L3sL
-----END PGP SIGNATURE-----

--Sig_/tBluxrhKiA0gdSsSGl7x42M--
