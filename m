Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57349367995
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 07:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbhDVF6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 01:58:07 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:44511 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229923AbhDVF6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 01:58:03 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FQmsh0Pskz9sTD;
        Thu, 22 Apr 2021 15:57:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1619071048;
        bh=sg9p+Yym4WtkPibvGln+BlE8RicUroqClBfSKpfPyY4=;
        h=Date:From:To:Cc:Subject:From;
        b=GoNHdzV6ijIt79lu9nIC7atw6SkqgdrUYlZMQG+2IVvYcZ2YILdsnp8M7pBwDa0Eh
         F8yOEsmioe9+Z2r4NidAS53Zasklj07lfrG3L6uxav2x4Htz6PkAzaj/xt2pCVF2R9
         BRa5AKLF6ClDLBEOxYS3lNuod1i52YtAfzUNFntDiefwsEQCEDZVRTt7vl3xMw/a04
         Ff+ug+rI0WoGfEURpOIulmEm65pPtnQVApfLY6Tl7gRWiWG0UBPx2l4XxNdvBQN6O8
         yM4955hchw2rH8y+j8IiZu5sCDyEKrRbCvbo2+J8dJ4d4mGbnGRAL02eqI4DsEA+nu
         3yd7Ls7aMlFDg==
Date:   Thu, 22 Apr 2021 15:57:27 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Nathan Tempelman <natet@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: linux-next: manual merge of the cgroup tree with the kvm tree
Message-ID: <20210422155727.70ca2e49@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/1EmnoDOHwrH+rqAlBqfORKI";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/1EmnoDOHwrH+rqAlBqfORKI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the cgroup tree got a conflict in:

  arch/x86/kvm/svm/svm.h

between commit:

  54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context")

from the kvm tree and commit:

  7aef27f0b2a8 ("svm/sev: Register SEV and SEV-ES ASIDs to the misc control=
ler")

from the cgroup tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/x86/kvm/svm/svm.h
index 454da1c1d9b7,9806aaebc37f..000000000000
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@@ -68,7 -65,7 +68,8 @@@ struct kvm_sev_info=20
  	unsigned long pages_locked; /* Number of pages locked */
  	struct list_head regions_list;  /* List of registered regions */
  	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 +	struct kvm *enc_context_owner; /* Owner of copied encryption context */
+ 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
  };
 =20
  struct kvm_svm {

--Sig_/1EmnoDOHwrH+rqAlBqfORKI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCBEEcACgkQAVBC80lX
0Gx3BQgAnXwVvX8Ls+1RuPeLhvaMyLudVx1yoD16tvrM32rMfif/wEZqCrmk1gHO
J01gSUM07C/90ykbQUHCK5jiB2cHjDeeMp7jKf8gBSuV/R/Lx6SppgX5CwaGCz7g
2ycCeRpfgPHUTYaDRXlrRrPxkrU+6pmVNrJpuq4zp6dw1ooe4ICBPWihSF4dBRdv
QmS8WtPc7lupsaouWdkZXvv+rSKJY3VVQP8PfjdKrEZQrcV9iSFglOvtux3caESI
AdoEeO2LJ8Vx5sP3AyKM9/FsmbLv1IWrNHxpmR0llzyURdnHQPQTDaOkSqtSyXGk
HmCHkcPCnfVPuUusgzpTjYnsPln7Vg==
=dNwJ
-----END PGP SIGNATURE-----

--Sig_/1EmnoDOHwrH+rqAlBqfORKI--
