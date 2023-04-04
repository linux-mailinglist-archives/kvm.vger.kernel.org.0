Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35AE16D56C5
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 04:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbjDDCc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 22:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjDDCcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 22:32:24 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23919FE;
        Mon,  3 Apr 2023 19:32:23 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PrBcM4Q5qz4whh;
        Tue,  4 Apr 2023 12:32:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1680575541;
        bh=g+Ca+8o14efamQlex7/wChezECtdEwAVcLvKdZ0WtcI=;
        h=Date:From:To:Cc:Subject:From;
        b=rHJYBppLA0A7w+oS/BA8ig5K/bt8hD0qCNOBVtqjunGSIOBp3l5CymLq+msDLVtYo
         Ez+HmuS0pwWVEQJNZ1aGaiFQCQTdZFj6l6cBz8KKyeEZKEZ6N+WwBDrJsBFcgk8eKG
         S3tBSwaNHhoHts+N7yiuogtyRrAV+c9La6yxHZDCAMi8kawbHkPdJo1UsJK5aCyqK+
         5624ZkwSh6nGBE+jPn8ISQQvvL+N3X18PIXM5i+hDPx9Jhon0HRQB0CiwwZ4ea/JEQ
         Ottk3Qjx0e08Am7AldiuJWhL5MTxM22xA4bMuJKYXXmW+CYKS9zG3jKp03XsYhqsyA
         H/lb28FMaWSMw==
Date:   Tue, 4 Apr 2023 12:32:17 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm-fixes
 tree
Message-ID: <20230404123217.6b784b4b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/toJpyekP/=0eG=/jvVezQS3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/toJpyekP/=0eG=/jvVezQS3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  arch/arm64/kvm/arm.c

between commit:

  52882b9c7a76 ("KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE platform dependent")

from the kvm-fixes tree and commit:

  30ec7997d175 ("KVM: arm64: timers: Allow userspace to set the global coun=
ter offset")

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

diff --cc arch/arm64/kvm/arm.c
index aaa752be3776,0e5a3ff8cc5a..000000000000
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@@ -220,7 -232,7 +232,8 @@@ int kvm_vm_ioctl_check_extension(struc
  	case KVM_CAP_VCPU_ATTRIBUTES:
  	case KVM_CAP_PTP_KVM:
  	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 +	case KVM_CAP_IRQFD_RESAMPLE:
+ 	case KVM_CAP_COUNTER_OFFSET:
  		r =3D 1;
  		break;
  	case KVM_CAP_SET_GUEST_DEBUG2:

--Sig_/toJpyekP/=0eG=/jvVezQS3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQrjDIACgkQAVBC80lX
0GxnBgf+MPxydLj2MmhqjmXUtoz8BPZq7V7HRcuxAsPedrjkOZVZGYdri6F2y5xh
p1ux2wH9PqHTYCuxdajssenvSTqDNvYZJ5tWA9cv92EfTADzFVVG+nTn/zYJiRL7
v8w+EwHy1BezCIokKiRGzYeUeOaNkC/39kITrxzIGzRZGp8P0arlTcjdI22pr0JA
hwGxVVRxXrXkQSo85Jzwwm3IciMCKWN9767lMlzmT4hZbYqxzeEf8v6/cVfDXuFC
m/qwZ1Q7iFgHD1Za5BFPX1olK1Enb2K7mI5os6Y8LJT8zCxpfjBhyUXY3rjmSDbm
MOH0VE8LdqkKHoZ7Z0Zg89w/xyzupA==
=UnsP
-----END PGP SIGNATURE-----

--Sig_/toJpyekP/=0eG=/jvVezQS3--
