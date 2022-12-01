Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB5D63E798
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 03:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiLACQf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 21:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLACQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 21:16:33 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E0D8932A;
        Wed, 30 Nov 2022 18:16:31 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NN07F4bmdz4xG6;
        Thu,  1 Dec 2022 13:16:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1669860986;
        bh=S5ONOgZTz0o2WtCmNBz+lPKRdK6AlxXo3Pg1r0rdX+Y=;
        h=Date:From:To:Cc:Subject:From;
        b=qgDcVfK5GnoATJ2aezvzB2v9wS6E7f6tkrn+ne0/J5FHBMnvUzwTbtzFMB9M0aVVZ
         ixD9IR3Pqo6Cy8Sy0CPBpS0R1AVDGQufX3/9/ixNeUU5ieYaPj4VwncAqauK+5teqh
         cKm+SRrp3soXJJgqOGBH8nsJRVyrAuUSsoyRDm+PTTOuPeZMa/5hYfBq8t6qzgJ6o9
         lgk+Ouu/DHvNj2mh7Zk4rLhaoR3Sx/leBS3T9nl05kGWB1A0JEWuMdpNLXg0DHwIue
         xvfz23RD25gBCwMsw0KPeAZ4UNQZtUfBIFQ3iXbn70ZakmQYTszrSef5JDNrsNxDjU
         lW02TseOnZOAw==
Date:   Thu, 1 Dec 2022 13:16:23 +1100
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
Message-ID: <20221201131623.18ebc8d8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7OYHAZ/oIIkHuO+IrwWjSQq";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/7OYHAZ/oIIkHuO+IrwWjSQq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  tools/testing/selftests/kvm/include/perf_test_util.h

between commit:

  9fda6753c9dd ("KVM: selftests: Rename perf_test_util.[ch] to memstress.[c=
h]")

from the kvm tree and commit:

  9ec1eb1bccee ("KVM: selftests: Have perf_test_util signal when to stop vC=
PUs")

from the kvm-arm tree.

I fixed it up (I removed the file and applied the following patch) and
can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

(this patch covered another occurrence fo the needed rename)

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 1 Dec 2022 12:19:45 +1100
Subject: [PATCH] fix up for rename of perf_test_args to memstress_args

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 tools/testing/selftests/kvm/access_tracking_perf_test.c       | 2 +-
 tools/testing/selftests/kvm/demand_paging_test.c              | 2 +-
 tools/testing/selftests/kvm/include/memstress.h               | 2 ++
 tools/testing/selftests/kvm/lib/memstress.c                   | 4 ++--
 .../testing/selftests/kvm/memslot_modification_stress_test.c  | 2 +-
 5 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tool=
s/testing/selftests/kvm/access_tracking_perf_test.c
index 2c9e0abcac94..57a16371e9c2 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -208,7 +208,7 @@ static bool spin_wait_for_next_iteration(int *current_i=
teration)
 	int last_iteration =3D *current_iteration;
=20
 	do {
-		if (READ_ONCE(perf_test_args.stop_vcpus))
+		if (READ_ONCE(memstress_args.stop_vcpus))
 			return false;
=20
 		*current_iteration =3D READ_ONCE(iteration);
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testi=
ng/selftests/kvm/demand_paging_test.c
index f980ed8aeead..b0e1fc4de9e2 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -161,7 +161,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			vcpu_alias =3D addr_gpa2alias(vm, vcpu_args->gpa);
=20
 			prefault_mem(vcpu_alias,
-				vcpu_args->pages * perf_test_args.guest_page_size);
+				vcpu_args->pages * memstress_args.guest_page_size);
=20
 			/*
 			 * Set up user fault fd to handle demand paging
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testin=
g/selftests/kvm/include/memstress.h
index bbd2a302df10..4ae63963c14f 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -40,6 +40,8 @@ struct memstress_args {
=20
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
+	/* Test is done, stop running vCPUs. */
+	bool stop_vcpus;
 	/* Randomize which pages are accessed by the guest. */
 	bool random_access;
 	/* True if all vCPUs are pinned to pCPUs */
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/se=
lftests/kvm/lib/memstress.c
index 3742ce238129..5f1d3173c238 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -292,7 +292,7 @@ void memstress_start_vcpu_threads(int nr_vcpus,
=20
 	vcpu_thread_fn =3D vcpu_fn;
 	WRITE_ONCE(all_vcpu_threads_running, false);
-	WRITE_ONCE(perf_test_args.stop_vcpus, false);
+	WRITE_ONCE(memstress_args.stop_vcpus, false);
=20
 	for (i =3D 0; i < nr_vcpus; i++) {
 		struct vcpu_thread *vcpu =3D &vcpu_threads[i];
@@ -315,7 +315,7 @@ void memstress_join_vcpu_threads(int nr_vcpus)
 {
 	int i;
=20
-	WRITE_ONCE(perf_test_args.stop_vcpus, true);
+	WRITE_ONCE(memstress_args.stop_vcpus, true);
=20
 	for (i =3D 0; i < nr_vcpus; i++)
 		pthread_join(vcpu_threads[i].thread, NULL);
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c=
 b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 431dbc47d345..9855c41ca811 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -43,7 +43,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_=
args)
 	run =3D vcpu->run;
=20
 	/* Let the guest access its memory until a stop signal is received */
-	while (!READ_ONCE(perf_test_args.stop_vcpus)) {
+	while (!READ_ONCE(memstress_args.stop_vcpus)) {
 		ret =3D _vcpu_run(vcpu);
 		TEST_ASSERT(ret =3D=3D 0, "vcpu_run failed: %d\n", ret);
=20
--=20
2.35.1

--=20
Cheers,
Stephen Rothwell

--Sig_/7OYHAZ/oIIkHuO+IrwWjSQq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmOIDncACgkQAVBC80lX
0GyVCwf/edGjXd7ZvZT0fmFfLkguTmC35h3y2vHQKmhdYRrIlg6lM/C8idsqOdbL
BecCFGcT3gTE3wMYk6fjoOKsEE6dH61vhsviMH0IyUpaK/vnwxEBWsMfX06osVUh
jjTBw9dY9MAn8xxAx/j0vCn6VVkKWutFDqLKAiv8+IMj1/qbmbli9038+kKFpJmC
aFeJme5UhVA9dJxRVNffnEgXau0em2QkrsjFHi8qgXurL1YbSAtpccW55dpvLEmJ
z2NT7gLcSWfPvQ2TUer8/eoYdzhxBC53/f1MM80LMgjX424QUWG7sQBdqEEIHubO
TIEZWZIESmXxurCN5G2F1eCzwMgn5A==
=JMf6
-----END PGP SIGNATURE-----

--Sig_/7OYHAZ/oIIkHuO+IrwWjSQq--
