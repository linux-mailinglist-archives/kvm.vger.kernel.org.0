Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E856D8DDC
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 05:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbjDFDHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 23:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235393AbjDFDG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 23:06:26 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5BBAD04;
        Wed,  5 Apr 2023 20:06:11 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PsRGP20nxz4wgv;
        Thu,  6 Apr 2023 13:06:04 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1680750365;
        bh=+7JnYdXl4iRYhR/fNbCL6DbEPldREXhma/t+L8lv3Js=;
        h=Date:From:To:Cc:Subject:From;
        b=nx9WwZzDcwf8f02O4B1Eo+3/kc7fR4+ptzZdOyJ0xWtJ2BN1fMxGw/Oq14JTz6CaE
         L8Q7Etru1Qc+P+W6khw3YznWVtBDi0bppM8Bct2Hzl1BjBkhKJhNzHDTHpcm5t+kpD
         qRUSW9YHeah0KwYMJaYdSj9WJJBiiSya6raaBfjKzFRgNQ6qkjfj/mVzZEI8k/fL/p
         gxwttRbW7wq+tw5Oy2jR9SPLVS+dLpnvNTnQVlZ/+B7oiaQ60s6OYQueQg+9+78mPm
         5+Y7pKPewP4FUIRXc/ND8Pv9RYjAtkPxOUqzvU3/eTgyvXceujVFlrXQ13FD6uMtMC
         LldLzWDgaMU+Q==
Date:   Thu, 6 Apr 2023 13:06:03 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Thomas Huth <thuth@redhat.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20230406130603.273997ca@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Z+Kjzg/rPvU7tRqN1R3suNi";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/Z+Kjzg/rPvU7tRqN1R3suNi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  arch/arm64/kvm/arm.c

between commit:

  d8708b80fa0e ("KVM: Change return type of kvm_arch_vm_ioctl() to "int"")

from the kvm tree and commit:

  e0fc6b21616d ("KVM: arm64: Add vm fd device attribute accessors")

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
index aaa752be3776,4ec888fdd4f7..000000000000
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@@ -220,7 -234,7 +234,8 @@@ int kvm_vm_ioctl_check_extension(struc
  	case KVM_CAP_VCPU_ATTRIBUTES:
  	case KVM_CAP_PTP_KVM:
  	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 +	case KVM_CAP_IRQFD_RESAMPLE:
+ 	case KVM_CAP_COUNTER_OFFSET:
  		r =3D 1;
  		break;
  	case KVM_CAP_SET_GUEST_DEBUG2:
@@@ -1440,7 -1475,28 +1476,27 @@@ static int kvm_vm_ioctl_set_device_addr
  	}
  }
 =20
+ static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+ {
+ 	switch (attr->group) {
+ 	case KVM_ARM_VM_SMCCC_CTRL:
+ 		return kvm_vm_smccc_has_attr(kvm, attr);
+ 	default:
+ 		return -ENXIO;
+ 	}
+ }
+=20
+ static int kvm_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+ {
+ 	switch (attr->group) {
+ 	case KVM_ARM_VM_SMCCC_CTRL:
+ 		return kvm_vm_smccc_set_attr(kvm, attr);
+ 	default:
+ 		return -ENXIO;
+ 	}
+ }
+=20
 -long kvm_arch_vm_ioctl(struct file *filp,
 -		       unsigned int ioctl, unsigned long arg)
 +int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned lon=
g arg)
  {
  	struct kvm *kvm =3D filp->private_data;
  	void __user *argp =3D (void __user *)arg;

--Sig_/Z+Kjzg/rPvU7tRqN1R3suNi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQuNxsACgkQAVBC80lX
0Gxkkgf8CkKLR8AuSGIbWV+bE1n+NeVjsa6k0ugcz8f5hzGsf9aqX42s6meXooKk
Ih2hWUUwi/4ilmGEqMk2IM8ZkYGbHAgsH2GrtzSo2M28shgQUfIO/qLt9D2PZrsh
y0tg0i6i47iELIASqj8KjWXpnLiq9evWuKDxVHUMMfUXdF5AWvEmOG4qK/wXERNy
n/G/f7jYpdqF09sUEigKIw6KhP1fu3GIOS30ymr/+Efgp0PJ4Tnb+NVCVSRIdPNB
qzxkNul6FPVpL9AFaswPny/SwIWV2d6KKhvCzE87RWULlifMrnR5d6qan1SNbpPJ
yP8BQdwO89+qqwRYihiin8skrbyVdw==
=gLJS
-----END PGP SIGNATURE-----

--Sig_/Z+Kjzg/rPvU7tRqN1R3suNi--
