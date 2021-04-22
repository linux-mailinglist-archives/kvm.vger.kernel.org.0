Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7C13678CD
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 06:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhDVEnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 00:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhDVEnp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 00:43:45 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6932C06174A;
        Wed, 21 Apr 2021 21:43:10 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FQlCv3cjKz9sRf;
        Thu, 22 Apr 2021 14:43:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1619066588;
        bh=Syn3qr1PGDyaL7XmaVT1PyuJyg2wGJIrvrm3IwZB9/I=;
        h=Date:From:To:Cc:Subject:From;
        b=sjr939eeh1tu6S1HQ8xL1IF2UkOCCXHcRufsWcYgvMEgeihcYVUu+EmAVscVkXzva
         oPS4d2exLKuT1tf63ti42cBKqoWUUwuZuSj0NYjg28ARw+GmywYsOVGF0QbxH9aJsJ
         Ta8wJcASNcTEBOjOKx0F4HCSXOd9C1bKttVO7yXOzR0W3xKGmVHQNtwrRvsNTlTK/z
         qcWualdC+PUqz36zvQGaTxNbj3zx/qG1v4eOvisK+T2ZSVnEVn6nMIVr/1uXywf2ut
         cEI9C8rPR7we+t0WXUiYO62mQm8yxC2aYXibSZGcSeHFExjOuN3qIWb1isZuyoICVG
         yle9h+UC440iQ==
Date:   Thu, 22 Apr 2021 14:43:06 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Jianyong Wu <jianyong.wu@arm.com>, Kai Huang <kai.huang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Tempelman <natet@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20210422144306.3ec8cfdb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/sb04XD1HIWOi_j8MCbcn=hh";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/sb04XD1HIWOi_j8MCbcn=hh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  include/uapi/linux/kvm.h

between commits:

  8b13c36493d8 ("KVM: introduce KVM_CAP_SET_GUEST_DEBUG2")
  fe7e948837f3 ("KVM: x86: Add capability to grant VM access to privileged =
SGX attribute")
  54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context")

from the kvm tree and commit:

  3bf725699bf6 ("KVM: arm64: Add support for the KVM PTP service")

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
index d76533498543,0e0f70c0d0dc..000000000000
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@@ -1078,9 -1078,7 +1078,10 @@@ struct kvm_ppc_resize_hpt=20
  #define KVM_CAP_DIRTY_LOG_RING 192
  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
  #define KVM_CAP_PPC_DAWR1 194
 -#define KVM_CAP_PTP_KVM 195
 +#define KVM_CAP_SET_GUEST_DEBUG2 195
 +#define KVM_CAP_SGX_ATTRIBUTE 196
 +#define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
++#define KVM_CAP_PTP_KVM 198
 =20
  #ifdef KVM_CAP_IRQ_ROUTING
 =20

--Sig_/sb04XD1HIWOi_j8MCbcn=hh
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCA/toACgkQAVBC80lX
0GyQ5Af/cJPoH5o4xEZAM/aCQpJpa8WwLJWn6uRoukB9Srn499nhUOcvtvLhHM/H
ssXkz+SjsQcYB7zUbRXUEVA0qHuRdhMdvs2lNP3HiltO2JIBv8iXKcNMUg4AssN+
FjTjJmBKS7SQPAu8E8r4OhkZX7kWr2bN3C4xYCkTwEv5DaMwx9UFpyey1fUkR9BY
RrViKUU3C0fs/KLQD08YGwEk9Zm4jakwkRkHWnqPEKRl6Clcex8HiOq2gK2DIPo4
SFtw5u2DuIm35EG8d1DoecHEfi/uN7zy33YTOxhxV+mlu2dr52Y/ltNRFHoi3rcU
5kdZ/+mOt0fDdWA6x+QWU4bb9700bQ==
=kKxv
-----END PGP SIGNATURE-----

--Sig_/sb04XD1HIWOi_j8MCbcn=hh--
