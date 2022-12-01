Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBB663E6C7
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 01:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiLAA5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 19:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLAA5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 19:57:48 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BB81FF92;
        Wed, 30 Nov 2022 16:57:45 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NMyNR1pd4z4xFv;
        Thu,  1 Dec 2022 11:57:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1669856263;
        bh=KXADFIMMmWG2dsbS7Re7sU/J+anY0jo/1Wlp2ldlTZc=;
        h=Date:From:To:Cc:Subject:From;
        b=KVJvCMdGO5y7GtEiY1nOHvbSM+gWYnpNyZ7RxSbYb1dv8F17zI4VYD7/PL+rsqCUt
         eL3iloa6dUkGSJA1lTxG2h6sNU2qIDHMDBqMRpICCSgETZ2e3yZOUnsNiuI4CSDMqU
         230fEzKC1FUYfEVi5tm7UIMhMHqCVCAJsNaz+GC/ZtJlpjm4pY2KMMSQ5qz1lLr2qB
         zTt1PQzhZr15ryCTjHIy/r3IsY/AvQ53B9KH4PyVobjRiPIkklS0TGXuTOFuPSn0Gu
         5pT8JjbzdjYgSA6SYsHfDuMPPzquJtbjjfkawrx2iykVH8Z/RY0BfHTfYihAMLdq9v
         qBtpHP4P+uMaw==
Date:   Thu, 1 Dec 2022 11:57:41 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, David Matlack <dmatlack@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20221201115741.7de32422@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.Ikwq/Ds1OUTjRj1j+hZle3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/.Ikwq/Ds1OUTjRj1j+hZle3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got conflicts in:

  tools/testing/selftests/kvm/access_tracking_perf_test.c
  tools/testing/selftests/kvm/memslot_modification_stress_test.c

between commit:

  7812d80c0f89 ("KVM: selftests: Rename perf_test_util symbols to memstress=
")

from the kvm tree and commit:

  9ec1eb1bccee ("KVM: selftests: Have perf_test_util signal when to stop vC=
PUs")

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

diff --cc tools/testing/selftests/kvm/access_tracking_perf_test.c
index 02d3587cab0a,942370d57392..000000000000
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@@ -321,11 -318,8 +318,8 @@@ static void run_test(enum vm_guest_mod
  	mark_memory_idle(vm, nr_vcpus);
  	access_memory(vm, nr_vcpus, ACCESS_READ, "Reading from idle memory");
 =20
- 	/* Set done to signal the vCPU threads to exit */
- 	done =3D true;
-=20
 -	perf_test_join_vcpu_threads(nr_vcpus);
 -	perf_test_destroy_vm(vm);
 +	memstress_join_vcpu_threads(nr_vcpus);
 +	memstress_destroy_vm(vm);
  }
 =20
  static void help(char *name)
diff --cc tools/testing/selftests/kvm/memslot_modification_stress_test.c
index d07e921bfcc5,3a5e4518307c..000000000000
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@@ -34,9 -34,7 +34,7 @@@
  static int nr_vcpus =3D 1;
  static uint64_t guest_percpu_mem_size =3D DEFAULT_PER_VCPU_MEM_SIZE;
 =20
- static bool run_vcpus =3D true;
-=20
 -static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
 +static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
  {
  	struct kvm_vcpu *vcpu =3D vcpu_args->vcpu;
  	struct kvm_run *run;
@@@ -107,14 -105,13 +105,12 @@@ static void run_test(enum vm_guest_mod
 =20
  	pr_info("Started all vCPUs\n");
 =20
 -	add_remove_memslot(vm, p->memslot_modification_delay,
 -			   p->nr_memslot_modifications);
 +	add_remove_memslot(vm, p->delay, p->nr_iterations);
 =20
- 	run_vcpus =3D false;
-=20
 -	perf_test_join_vcpu_threads(nr_vcpus);
 +	memstress_join_vcpu_threads(nr_vcpus);
  	pr_info("All vCPU threads joined\n");
 =20
 -	perf_test_destroy_vm(vm);
 +	memstress_destroy_vm(vm);
  }
 =20
  static void help(char *name)

--Sig_/.Ikwq/Ds1OUTjRj1j+hZle3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmOH/AUACgkQAVBC80lX
0GzhMgf/ThhiYtkIM/b6+mxQoe8ngRiH+8ZilGBTBSk3dnQUAlpNSx/1tkFF6uFm
meXTDwigtT1R2iVyDmFYSXz6QFEskH7vtIAF4eqnfpjnZXq7FT+GdP1AAxl40X47
Qv2YgVh6GOp/dpHjyefy+LwLiSgxMINnxqbkxETOBnR24qQZESN6eJD0w3N4+obj
QugQKd5nJ1JvDbVwn2NkUkDHmqbPNrj60PSQJwrkEP3zRWg+fuWgfLzLMOIUhBzn
/WW2bUpRposuEWuqBosy+x4lmM+iepH4Ljb/3e00GkHgml8HfgN9pdNqY73UfPvU
gww/P8E/VyLm+1EjUszs/vzSGiq5Yg==
=jCWp
-----END PGP SIGNATURE-----

--Sig_/.Ikwq/Ds1OUTjRj1j+hZle3--
