Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858223B3C16
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 07:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhFYFWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 01:22:38 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:49679 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230228AbhFYFWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 01:22:38 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GB51C5PTyz9sT6;
        Fri, 25 Jun 2021 15:20:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1624598416;
        bh=v9Sz1AU5rpnqUdoM7nrNk4xBnk8C9iV3y7lBBvJh+tk=;
        h=Date:From:To:Cc:Subject:From;
        b=E+kukCoDZyvBsnOaINvmk775PzqxHf4UorAxLPnt8zZUGMFwHrqqV1Dl92uCdXXrq
         qsYVWHR/tJ2+pOpfuFHUQTEEROvTH2HxO7bdqvY5gmZtpfaJyEQa20uwLooPXn0NuE
         KMdUs/s5Ny20MTZ3YNH2pGXSy6mtwgB+NIwnEwvThM+Cpfu7keEWIBoF/ZBxq1jNiW
         vc73nyHBlxgcPy1GoCK9TQufGBSD9FoB6QyQSY8usjMIT9WhZYhCh7xvyGNu+LhI/m
         5za90UB0Gl/IdLw4ifIm9gCoHVDt6G+37RoRygoeXhKwoo6H4Q3YRHnbPnWpQyuUAE
         hfpaYIIOQqSGw==
Date:   Fri, 25 Jun 2021 15:20:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Steven Price <steven.price@arm.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20210625152013.7e121403@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/T5mANbF8pk9bFU+ifqAdmRY";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/T5mANbF8pk9bFU+ifqAdmRY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  include/uapi/linux/kvm.h

between commits:

  cb082bfab59a ("KVM: stats: Add fd-based API to read binary stats data")
  19238e75bd8e ("kvm: x86: Allow userspace to handle emulation errors")

from the kvm tree and commit:

  ea7fc1bb1cd1 ("KVM: arm64: Introduce MTE VM feature")

from the kvm-arm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/uapi/linux/kvm.h
index 68c9e6d8bbda,da1edd2b4046..000000000000
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@@ -1105,12 -1083,7 +1105,13 @@@ struct kvm_ppc_resize_hpt=20
  #define KVM_CAP_SGX_ATTRIBUTE 196
  #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
  #define KVM_CAP_PTP_KVM 198
 -#define KVM_CAP_ARM_MTE 199
 +#define KVM_CAP_HYPERV_ENFORCE_CPUID 199
 +#define KVM_CAP_SREGS2 200
 +#define KVM_CAP_EXIT_HYPERCALL 201
 +#define KVM_CAP_PPC_RPT_INVALIDATE 202
 +#define KVM_CAP_BINARY_STATS_FD 203
 +#define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
++#define KVM_CAP_ARM_MTE 205
 =20
  #ifdef KVM_CAP_IRQ_ROUTING
 =20

--Sig_/T5mANbF8pk9bFU+ifqAdmRY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDVZ40ACgkQAVBC80lX
0GxcIAf+N9mDfqjtOVAEM7rCQ1twwNgmLH8aqAlBgpXDjVzX/5DHUq7aY3d0Zfpm
vOzerWE4wNLERyH8ZgQ6DodS7esT2+9Ax6LbvsMh6Iz78r7p39fMkTJbt7ooPMs/
sYDVdTMZxp03+1Pyy1OWIOutccaAo5dnJIJvg6+39/ajfnONm0mvMsFeqiUoux1U
pcKgroDuFOP8AOqcJVMf6HBLyGNJuvYW5aRH6FNOVEsNrwVVrvd7wIPS6ZJxWNKC
aWHP8dhrQpQRtxo+Wde5a0MBeJRgrLxHx/wiT+utTz1zn+URK33k5BEnsrqpCU/L
nKmMKceJq9vULb5VtmG7rA9LrMmc1A==
=G7Sv
-----END PGP SIGNATURE-----

--Sig_/T5mANbF8pk9bFU+ifqAdmRY--
