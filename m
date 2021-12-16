Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A67477BFD
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 19:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbhLPSwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 13:52:49 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:38319 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbhLPSws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 13:52:48 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JFLpR0X0tz4xbd;
        Fri, 17 Dec 2021 05:52:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1639680767;
        bh=JcA6rBDWH7m1IIVYFKTnEzPJgaAJKfG/8CKZ4GroV6Q=;
        h=Date:From:To:Cc:Subject:From;
        b=tmgRB7iwnr10U7s6thG0ztlDXZKc615Smbht4SBXRQRnKzv4h42KXvTp45trYrufA
         2U7ah7VnRYZCr9My/E2oh3aCuYWIZw9VYGmclCUZdpF07Ly3Ymgb+xqzxPS4u/qtB9
         /DMNXXPDbuVFwSD9GhXgvb0oMRPL8adbbqAhNkTHXBHBgWLv3eFo75pILAw/6+SizH
         lfp2B4ycwMVLOgiZisYTq+v4N/XIQX9JCXVBkkoiqSr/ELmTnGnUDO5qEVCaXUkIK9
         k8m60Ta7ZUW/I4oZoZxLO54yISukGv0ebWN9m3zpNIGxg6KIM5vwQ5AAB9Eu3dSqk/
         LlXC0pYgi2O1w==
Date:   Fri, 17 Dec 2021 05:52:46 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the kvm tree
Message-ID: <20211217055246.2e5fdf11@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/9x+=96Rt4RXq83Eda9F21Uw";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/9x+=96Rt4RXq83Eda9F21Uw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commits

  244893fa2859 ("KVM: Dynamically allocate "new" memslots from the get-go")
  0f9bdef3d933 ("KVM: Wait 'til the bitter end to initialize the "new" mems=
lot")
  44401a204734 ("KVM: Optimize overlapping memslots check")
  f4209439b522 ("KVM: Optimize gfn lookup in kvm_zap_gfn_range()")
  bcb63dcde829 ("KVM: Call kvm_arch_flush_shadow_memslot() on the old slot =
in kvm_invalidate_memslot()")
  a54d806688fe ("KVM: Keep memslots in tree-based structures instead of arr=
ay-based ones")
  6a656832aa75 ("KVM: s390: Introduce kvm_s390_get_gfn_end()")
  ed922739c919 ("KVM: Use interval tree to do fast hva lookup in memslots")
  26b8345abc75 ("KVM: Resolve memslot ID via a hash table instead of via a =
static array")
  1e8617d37fc3 ("KVM: Move WARN on invalid memslot index to update_memslots=
()")
  c928bfc2632f ("KVM: Integrate gfn_to_memslot_approx() into search_memslot=
s()")
  f5756029eef5 ("KVM: x86: Use nr_memslot_pages to avoid traversing the mem=
slots array")
  e0c2b6338ac8 ("KVM: x86: Don't call kvm_mmu_change_mmu_pages() if the cou=
nt hasn't changed")
  7cd08553ab10 ("KVM: Don't make a full copy of the old memslot in __kvm_se=
t_memory_region()")
  ec5c86976674 ("KVM: s390: Skip gfn/size sanity checks on memslot DELETE o=
r FLAGS_ONLY")
  77aedf26fe5d ("KVM: x86: Don't assume old/new memslots are non-NULL at me=
mslot commit")
  07921665a651 ("KVM: Use prepare/commit hooks to handle generic memslot me=
tadata updates")
  6a99c6e3f52a ("KVM: Stop passing kvm_userspace_memory_region to arch mems=
lot hooks")
  d01495d4cffb ("KVM: RISC-V: Use "new" memslot instead of userspace memory=
 region")
  9d7d18ee3f48 ("KVM: x86: Use "new" memslot instead of userspace memory re=
gion")
  cf5b486922dc ("KVM: s390: Use "new" memslot instead of userspace memory r=
egion")
  eaaaed137ecc ("KVM: PPC: Avoid referencing userspace memory region in mem=
slot updates")
  3b1816177bfe ("KVM: MIPS: Drop pr_debug from memslot commit to avoid usin=
g "mem"")
  509c594ca2dc ("KVM: arm64: Use "new" memslot instead of userspace memory =
region")
  537a17b31493 ("KVM: Let/force architectures to deal with arch specific me=
mslot data")
  ce5f0215620c ("KVM: Use "new" memslot's address space ID instead of dedic=
ated param")
  4e4d30cb9b87 ("KVM: Resync only arch fields when slots_arch_lock gets rea=
cquired")
  47ea7d900b1c ("KVM: Open code kvm_delete_memslot() into its only caller")
  afa319a54a8c ("KVM: Require total number of memslot pages to fit in an un=
signed long")

are missing a Signed-off-by from their committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/9x+=96Rt4RXq83Eda9F21Uw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmG7iv4ACgkQAVBC80lX
0GyyxAgAjMYQyhJDpbj9lb8bGG/WW+K+6sJjOP3xx0yFjZvL/O32Tf23WMe+jlRb
FcxYwV62qku7qaIN89SuWf2Y4ev2B8RMl0UTcF6MyUWLh9erG/VSZmAH8ihz3X2i
6MncshPdmhq5m0ZBgDbIhdFvMqcRC0Y6ZPCxyt1MwFjSRTFQkupVaUpDcPhS9QkE
9wRMcWIAptRfIjiCZSdCd0F+3UVXiI6qrXx3xdEdgGX0ffEgT6YOjtFt59U52lMh
kDH78gGoI9XfVN1+l4zTotxM0fubK+fb8spOnfFtGZgd/cstx62tf14jkshZ45L9
nAKmAkBEGzyU3UZeqdhtGdsRtFU79w==
=3u6B
-----END PGP SIGNATURE-----

--Sig_/9x+=96Rt4RXq83Eda9F21Uw--
