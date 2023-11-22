Return-Path: <kvm+bounces-2240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C14F7F3BAB
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 03:14:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B7E0282AAE
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 02:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04DAE881E;
	Wed, 22 Nov 2023 02:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="LT5DOMUG"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA91298;
	Tue, 21 Nov 2023 18:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1700619270;
	bh=jMhp3OO1OuD6ZqqAsOzECGZ72/P154caojLkXwRL41U=;
	h=Date:From:To:Cc:Subject:From;
	b=LT5DOMUGm6oxoBluIfXnUbTw906Ry0buC3EaQQnVidLlrMLljA2K40T2xlof4w/Ag
	 sHlnqbuLOtBbNeMAbIizkhafQEnta+dd7I8DQazbOL60zdUsWaB0X0U22xto88mjoR
	 dykM7PJNh4DPm70zxYi+QbTX8SqsxcXpmU2Uhwv03hf5biTxjvrJVNRjoLS3jJYx9o
	 6ovPPqQkk27PyjdBDCdAIZ1So3AXyRSHI6M1QIL7ECGuL8dlMBwUvGKc9e2LhyHlTd
	 4XMyeh6A1UsNJUI+oljCmwjRr26EqQU7eDsekA33LwPZaw7jX3fnJlelBLFa6ZaMmz
	 aOYz2AOtzsIHQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4SZlDj1X1Mz4xSQ;
	Wed, 22 Nov 2023 13:14:29 +1100 (AEDT)
Date: Wed, 22 Nov 2023 13:14:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, Christian Brauner
 <brauner@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Ackerley Tng <ackerleytng@google.com>, Chao Peng
 <chao.p.peng@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Roth
 <michael.roth@amd.com>, Sean Christopherson <seanjc@google.com>, Yu Zhang
 <yu.c.zhang@linux.intel.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the kvm tree
Message-ID: <20231122131428.599f2931@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/GLQFgBlUXh5M6MunK=g/i._";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/GLQFgBlUXh5M6MunK=g/i._
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

arch/x86/kvm/../../../virt/kvm/guest_memfd.c: In function 'kvm_gmem_punch_h=
ole':
arch/x86/kvm/../../../virt/kvm/guest_memfd.c:100:58: error: 'struct address=
_space' has no member named 'private_list'; did you mean 'i_private_list'?
  100 |         struct list_head *gmem_list =3D &inode->i_mapping->private_=
list;
      |                                                          ^~~~~~~~~~=
~~
      |                                                          i_private_=
list
arch/x86/kvm/../../../virt/kvm/guest_memfd.c: In function 'kvm_gmem_error_f=
olio':
arch/x86/kvm/../../../virt/kvm/guest_memfd.c:273:49: error: 'struct address=
_space' has no member named 'private_list'; did you mean 'i_private_list'?
  273 |         struct list_head *gmem_list =3D &mapping->private_list;
      |                                                 ^~~~~~~~~~~~
      |                                                 i_private_list
arch/x86/kvm/../../../virt/kvm/guest_memfd.c: In function '__kvm_gmem_creat=
e':
arch/x86/kvm/../../../virt/kvm/guest_memfd.c:373:51: error: 'struct address=
_space' has no member named 'private_list'; did you mean 'i_private_list'?
  373 |         list_add(&gmem->entry, &inode->i_mapping->private_list);
      |                                                   ^~~~~~~~~~~~
      |                                                   i_private_list

Caused by commit

  a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific=
 backing memory")

interacting with commit

  488e2eea5100 ("fs: Rename mapping private members")

from the vfs-brauner tree.

I have applied the following merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 22 Nov 2023 13:10:06 +1100
Subject: [PATCH] fix up for "KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for gu=
est-specific backing memory"

interacting with "fs: Rename mapping private members" from the vfs-brauner
tree.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 virt/kvm/guest_memfd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 451435123fe7..16d58806e913 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -97,7 +97,7 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem=
, pgoff_t start,
=20
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t=
 len)
 {
-	struct list_head *gmem_list =3D &inode->i_mapping->private_list;
+	struct list_head *gmem_list =3D &inode->i_mapping->i_private_list;
 	pgoff_t start =3D offset >> PAGE_SHIFT;
 	pgoff_t end =3D (offset + len) >> PAGE_SHIFT;
 	struct kvm_gmem *gmem;
@@ -270,7 +270,7 @@ static int kvm_gmem_migrate_folio(struct address_space =
*mapping,
 static int kvm_gmem_error_folio(struct address_space *mapping,
 		struct folio *folio)
 {
-	struct list_head *gmem_list =3D &mapping->private_list;
+	struct list_head *gmem_list =3D &mapping->i_private_list;
 	struct kvm_gmem *gmem;
 	pgoff_t start, end;
=20
@@ -370,7 +370,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t si=
ze, u64 flags)
 	kvm_get_kvm(kvm);
 	gmem->kvm =3D kvm;
 	xa_init(&gmem->bindings);
-	list_add(&gmem->entry, &inode->i_mapping->private_list);
+	list_add(&gmem->entry, &inode->i_mapping->i_private_list);
=20
 	fd_install(fd, file);
 	return fd;
--=20
2.40.1

--=20
Cheers,
Stephen Rothwell

--Sig_/GLQFgBlUXh5M6MunK=g/i._
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmVdZAQACgkQAVBC80lX
0Gy7+wf8COi5Jx/3jUo0LmfleOMMQZcluv5ylZ8f9gfVZsxnt9C7gMoNVkAHzup0
u1IY0VZss3/exLMzL6TOKOCQlzub5qmMkYdL7HD9YzKrbwU/EFm3nX2r60RsATc6
fCWtDRcEludWMQemnW4ZiWKXylD7Nj4o4IReIVqdDDs98R7JnHwMRBB7bwSGe8Jx
ZdijsunCXPehjZRcIOjUs452+ELXnF8f+JDc9nSkOe8PBEz9rhpv0iaHUnHV1/uE
V651+TLvK5gcgXiz8lZesr3O2tSuXck6fyAbT3s8bXTjmNr6dnV6rZbzhWhUC5vm
mtQltBcVO7y6wvxwfKNWlgwpa65RLg==
=nvCs
-----END PGP SIGNATURE-----

--Sig_/GLQFgBlUXh5M6MunK=g/i._--

