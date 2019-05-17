Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A5221189
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 03:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfEQBFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 21:05:09 -0400
Received: from ozlabs.org ([203.11.71.1]:35041 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbfEQBFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 21:05:09 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 454qp943VNz9s9y;
        Fri, 17 May 2019 11:05:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1558055105;
        bh=ooupRwlzmgFq0MFwFv3NKtnYvDLGwPP8J9xeQL+ZykQ=;
        h=Date:From:To:Cc:Subject:From;
        b=CgdytqRUncOwEPckLArZr8pyeLLPfMwXL2UdRxDu0rgPfN110WWIHvouxbDaIiztb
         VFTPie0DDU3W9NP0VijAo7x1vdF5FnyMSb1lZ/1hF85ZNJJ4jK+uIki0ftPRKhIzha
         HJ8Iod6twuI6WToHMTpO2w2urlan6YYjgvriUhPDRe6EqvpdSnwyi1ug73IUz7LtBR
         0zHifRYp9EY334caSvmCgGGS+SmNKssQt5DEv1LfrIRSF2IlMWErUfv/d8bwBXmItK
         YmegUKfWiE/lFQ9lsKL93lcv9umgALeipFqBkXmuRYri4/N7FfReySpJ27yor3Tjzg
         IjdTI9ViXiU6g==
Date:   Fri, 17 May 2019 11:04:47 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>, Peter Xu <peterx@redhat.com>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-ID: <20190517110447.34e65beb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/GkhwStloeVvNpPg8oh+2H7f"; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/GkhwStloeVvNpPg8oh+2H7f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  Documentation/virtual/kvm/api.txt

between commit:

  dbcdae185a70 ("Documentation: kvm: fix dirty log ioctl arch lists")

from Linus' tree and commit:

  d7547c55cbe7 ("KVM: Introduce KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2")

from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc Documentation/virtual/kvm/api.txt
index 64b38dfcc243,73a501eb9291..000000000000
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@@ -3809,8 -3936,8 +3936,8 @@@ to I/O ports
 =20
  4.117 KVM_CLEAR_DIRTY_LOG (vm ioctl)
 =20
- Capability: KVM_CAP_MANUAL_DIRTY_LOG_PROTECT
+ Capability: KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2
 -Architectures: x86
 +Architectures: x86, arm, arm64, mips
  Type: vm ioctl
  Parameters: struct kvm_dirty_log (in)
  Returns: 0 on success, -1 on error
@@@ -4798,9 -4968,9 +4968,9 @@@ and injected exceptions
  * For the new DR6 bits, note that bit 16 is set iff the #DB exception
    will clear DR6.RTM.
 =20
- 7.18 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT
+ 7.18 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2
 =20
 -Architectures: all
 +Architectures: x86, arm, arm64, mips
  Parameters: args[0] whether feature should be enabled or not
 =20
  With this capability enabled, KVM_GET_DIRTY_LOG will not automatically

--Sig_/GkhwStloeVvNpPg8oh+2H7f
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzeCK8ACgkQAVBC80lX
0Gweegf/cRv0YebzAmqhtNeCTu4uNeuma3G+ITfHVHUGsEZ8zQxGInYyu1GPxfB4
A219pIl1/hwzZ0LAnGi0h9QDSudZUlIsvQ49DY5Cw2Gojf4WnbfwZgQY3Pa6ii0M
PR0hQicg9KeeHIDwu/Y+qiczAB36jA8XxlPr+FqJ10YtrdYn3iM67Em/CWwat2Dh
cwZCdBUVoG1HPTDaxv7DTyRjHnCdDG7sR0Y+W+2XHeLK1mMeC/IuTZKLfgaOi4cO
1jZSL14SIkqyUibpbIa2A3WVXVX0mGItW/YWQLC8bHD/86XgID5KfYNnv1sDQxE6
wcydxA+pQ1K1PGlw1ZrmW2J1xf/oVQ==
=n3xT
-----END PGP SIGNATURE-----

--Sig_/GkhwStloeVvNpPg8oh+2H7f--
