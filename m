Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D185577A50
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 07:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbiGRFTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 01:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiGRFTf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 01:19:35 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADACC6323;
        Sun, 17 Jul 2022 22:19:33 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LmVdH5dVyz4xbm;
        Mon, 18 Jul 2022 15:19:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1658121572;
        bh=B7cpHjbt5kcRv7FMz00EwdlkBbUF2kDdSz8ilusmmfg=;
        h=Date:From:To:Cc:Subject:From;
        b=haMct5wFAsJuiog/mdopFUDOhVUSoPypTiwnZyMi9C5NP4iMucfGf213TB3DLitdq
         WwJNLA8giKDRAZWsa5Hf4vQySnvtuPkJ4OSMxcLRt3SuCRvNeNl4XwUtQUXFRaOF5y
         RG1G15RxeJ9XlpXrbJ5IubSHYhqFx1/ovnw93c+FrBuHFEXhPcdAO5tQs9qv4+Uz0+
         rHV/NI5+3q2F/gYJbDAKD9Qyr/KXOaJ36LvO1ZRCngn11NtwLfSvv+VSFzeY3Nu8SZ
         GKNVB0KmPayU5t3HzIHfQaob1ljqL55do+v5DMrICA70KKmDoSMwKyvboKOngDcEI+
         i9wjjbIJowkfg==
Date:   Mon, 18 Jul 2022 15:19:30 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20220718151930.42ae670f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hjS3Ic2IcCL1BS9qDRACH88";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/hjS3Ic2IcCL1BS9qDRACH88
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  tools/testing/selftests/kvm/aarch64/vgic_init.c

between commits:

  98f94ce42ac6 ("KVM: selftests: Move KVM_CREATE_DEVICE_TEST code to separa=
te helper")
  7ed397d107d4 ("KVM: selftests: Add TEST_REQUIRE macros to reduce skipping=
 copy+paste")

from the kvm tree and commit:

  6a4f7fcd7504 ("KVM: arm64: selftests: Add support for GICv2 on v3")

from the kvm-arm tree.

I fixed it up (I think, see below) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc tools/testing/selftests/kvm/aarch64/vgic_init.c
index e8cab9840aa3,21ba4002fc18..000000000000
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@@ -661,9 -668,9 +661,9 @@@ int test_kvm_device(uint32_t gic_dev_ty
  	other =3D VGIC_DEV_IS_V2(gic_dev_type) ? KVM_DEV_TYPE_ARM_VGIC_V3
  					     : KVM_DEV_TYPE_ARM_VGIC_V2;
 =20
 -	if (!_kvm_create_device(v.vm, other, true, &fd)) {
 -		ret =3D _kvm_create_device(v.vm, other, false, &fd);
 +	if (!__kvm_test_create_device(v.vm, other)) {
 +		ret =3D __kvm_test_create_device(v.vm, other);
- 		TEST_ASSERT(ret && errno =3D=3D EINVAL,
+ 		TEST_ASSERT(ret && (errno =3D=3D EINVAL || errno =3D=3D EEXIST),
  				"create GIC device while other version exists");
  	}
 =20
@@@ -703,9 -711,15 +704,13 @@@ int main(int ac, char **av
  	}
 =20
  	ret =3D test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V2);
- 	__TEST_REQUIRE(!ret, "No GICv2 nor GICv3 support");
+ 	if (!ret) {
+ 		pr_info("Running GIC_v2 tests.\n");
+ 		run_tests(KVM_DEV_TYPE_ARM_VGIC_V2);
+ 		cnt_impl++;
+ 	}
+=20
 -	if (!cnt_impl) {
 -		print_skip("No GICv2 nor GICv3 support");
 -		exit(KSFT_SKIP);
 -	}
++	__TEST_REQUIRE(!cnt_impl, "No GICv2 nor GICv3 support");
 +
- 	pr_info("Running GIC_v2 tests.\n");
- 	run_tests(KVM_DEV_TYPE_ARM_VGIC_V2);
  	return 0;
  }

--Sig_/hjS3Ic2IcCL1BS9qDRACH88
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmLU7WIACgkQAVBC80lX
0Gwd5QgAlVWVIOS4ZLrhgdVmGIL/iLZEuoWSNuNv1NJbm3iQmUKmdVZi1wXqRyAe
caXEN62U4PSiPAD+Jr4eK0w/CnIe4A74y9bo/pLM8C3T6Lx/A4jaxDqEDmqzdV7v
2e+C9DHmjdZBT2TFGIkcNuPGUI0ZMMwe060phjFSExenEz6ssDji+UAayjSX44fb
Y11euD+Vpy/yrjooljP/YPIA4KEEN0SxjSHKf/wWYiVKyOH+//UjcGP8dlRQfgCg
fWG8g8SHsa18kClp2lRtvbozi1EUxz5lJarIHjkGCF3VX3m2CLXsiap59odKxEIl
Y0qIvpMhZ4jRJBH37JGceAu40GgN5g==
=6Ygb
-----END PGP SIGNATURE-----

--Sig_/hjS3Ic2IcCL1BS9qDRACH88--
