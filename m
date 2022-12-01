Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CD863E6ED
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 02:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiLABJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 20:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiLABJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 20:09:44 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905D942F7B;
        Wed, 30 Nov 2022 17:09:42 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NMyfD5F24z4xFv;
        Thu,  1 Dec 2022 12:09:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1669856981;
        bh=brvavOSOc62js08CKp3eQxixTiCVzmBixPUmp8sxcW8=;
        h=Date:From:To:Cc:Subject:From;
        b=AAjY4PhM/3tjlWzLFpEF1CVHxtrnPlvH4pXdCV5tiOKOblqlcs+XvkDhJk3DI85qp
         yjZDxpLjtKHfqgcUOvsJhnZCuRKbV76/2Q6skzSTlb9Tp0np3jO95gHcjrJCeHyXja
         voC+0YjKnVMAwVhAOHPfgdY+knE6+1+wT5+JnTL7HkGDKu5WF0Yp4pxxPVEM+vkXfw
         p1zwvMBmWT+BTv+kCr5hDUICis7a96E8Prba5lbhmU/PvBgZWYtcP3HlG6iIgu8CeQ
         FC/kaU+6u2nzZpNhuOol+VOkUU/uph1dQz1DzZgkxvqEcNqOxC8N68NnhmeSbf1i/e
         ZatCSvrstGlrQ==
Date:   Thu, 1 Dec 2022 12:09:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>
Cc:     Gavin Shan <gshan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Vishal Annapurve <vannapurve@google.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20221201120939.3c19f004@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/StyU/QJYB47_8rLAkHl4wg4";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/StyU/QJYB47_8rLAkHl4wg4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  tools/testing/selftests/kvm/memslot_perf_test.c

between commits:

  018ea2d71a43 ("KVM: selftests: Add atoi_paranoid() to catch errors missed=
 by atoi()")
  dc88244bf548 ("KVM: selftests: Automatically do init_ucall() for non-bare=
bones VMs")
  197ebb713ad0 ("KVM: selftests: move common startup logic to kvm_util.c")

from the kvm tree and commits:

  34396437b11f ("KVM: selftests: memslot_perf_test: Probe memory slots for =
once")
  8675c6f22698 ("KVM: selftests: memslot_perf_test: Support variable guest =
page size")
  a69170c65acd ("KVM: selftests: memslot_perf_test: Report optimal memory s=
lots")

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

diff --cc tools/testing/selftests/kvm/memslot_perf_test.c
index 36b20abfb948,2ad40f7c9c08..000000000000
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@@ -252,23 -284,22 +284,21 @@@ static bool prepare_vm(struct vm_data *
  	struct timespec tstart;
  	struct sync_area *sync;
 =20
- 	max_mem_slots =3D kvm_check_cap(KVM_CAP_NR_MEMSLOTS);
- 	TEST_ASSERT(max_mem_slots > 1,
- 		    "KVM_CAP_NR_MEMSLOTS should be greater than 1");
- 	TEST_ASSERT(nslots > 1 || nslots =3D=3D -1,
- 		    "Slot count cap should be greater than 1");
- 	if (nslots !=3D -1)
- 		max_mem_slots =3D min(max_mem_slots, (uint32_t)nslots);
- 	pr_info_v("Allowed number of memory slots: %"PRIu32"\n", max_mem_slots);
+ 	host_page_size =3D getpagesize();
+ 	guest_page_size =3D vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
+ 	mempages =3D mem_size / guest_page_size;
 =20
- 	TEST_ASSERT(mempages > 1,
- 		    "Can't test without any memory");
+ 	data->vm =3D __vm_create_with_one_vcpu(&data->vcpu, mempages, guest_code=
);
 -	ucall_init(data->vm, NULL);
+ 	TEST_ASSERT(data->vm->page_size =3D=3D guest_page_size, "Invalid VM page=
 size");
 =20
  	data->npages =3D mempages;
- 	data->nslots =3D max_mem_slots - 1;
- 	data->pages_per_slot =3D mempages / data->nslots;
- 	if (!data->pages_per_slot) {
- 		*maxslots =3D mempages + 1;
+ 	TEST_ASSERT(data->npages > 1, "Can't test without any memory");
+ 	data->nslots =3D nslots;
+ 	data->pages_per_slot =3D data->npages / data->nslots;
+ 	rempages =3D data->npages % data->nslots;
+ 	if (!check_slot_pages(host_page_size, guest_page_size,
+ 			      data->pages_per_slot, rempages)) {
+ 		*maxslots =3D get_max_slots(data, host_page_size);
  		return false;
  	}
 =20
@@@ -884,9 -966,9 +965,9 @@@ static bool parse_args(int argc, char *
  			map_unmap_verify =3D true;
  			break;
  		case 's':
 -			targs->nslots =3D atoi(optarg);
 +			targs->nslots =3D atoi_paranoid(optarg);
- 			if (targs->nslots <=3D 0 && targs->nslots !=3D -1) {
- 				pr_info("Slot count cap has to be positive or -1 for no cap\n");
+ 			if (targs->nslots <=3D 1 && targs->nslots !=3D -1) {
+ 				pr_info("Slot count cap must be larger than 1 or -1 for no cap\n");
  				return false;
  			}
  			break;
@@@ -994,6 -1103,12 +1090,9 @@@ int main(int argc, char *argv[]
  	struct test_result rbestslottime;
  	int tctr;
 =20
 -	/* Tell stdout not to buffer its content */
 -	setbuf(stdout, NULL);
 -
+ 	if (!check_memory_sizes())
+ 		return -1;
+=20
  	if (!parse_args(argc, argv, &targs))
  		return -1;
 =20

--Sig_/StyU/QJYB47_8rLAkHl4wg4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmOH/tMACgkQAVBC80lX
0GzDdAf9EwHzX9q8/A8wU1nDscw28nlh5ATvstpiKd1W6+q0xPn+uQiRgac7J/CP
K7Eys7ifm6JiwLU+CkP+wRBgIizITNtmcAXyGcMzf4DT5Byop/e9PpBW+CUwE72e
gzzALRhmYYNdqjuHk73ULD61KcfiF+jb9egmgRHESR1GIZYGNtPHxTUscbb7UQLn
Vc983LX+Zc9O2t6ApRNpEfhj10C/7RZRg1GmoJMwpHTKXtrGNe1KKLC7PGW/xS40
aIYoqKiw9xaqGi8i09RX9xvV2ifiC57Gb7m1KlhGrht5oqDdOIQ4yPqnHustp74E
GX8jhnrzAmecJz5Bo8OrZswf5tfL8w==
=gwKS
-----END PGP SIGNATURE-----

--Sig_/StyU/QJYB47_8rLAkHl4wg4--
