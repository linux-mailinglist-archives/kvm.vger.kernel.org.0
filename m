Return-Path: <kvm+bounces-71976-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFxyFDhXoGkNigQAu9opvQ
	(envelope-from <kvm+bounces-71976-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:22:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D9111A76F1
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:22:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9888130F00CF
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F0863ACEE2;
	Thu, 26 Feb 2026 13:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="AVmi+LYA"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8F23D413F
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 13:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114027; cv=none; b=Gv6jqq3eQ08j+JAmV6ODTdJd7SkxW+BulH7XApP0Co8YScDvjwniLdC0pM0yOQqa0ux2J4+ZgFF1Vi/voCloQNJnYnkSeDA7snH7cjPsCi4xehmYJ90w6i6kCKAu1S24VZQif4l0Qr3qwXeynKoJKATZ3bE57YZvW10UaaK+g4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114027; c=relaxed/simple;
	bh=iyGk7z+qRy7AAHRo6501zoqRvFz1oj2S+nr5bIWvv7Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d6DCaZ0PiLpNxIldRNqyxPuSOOJo6dB64IkgLHEaolvoE3pROfCDjEWOspkJQtDBVFIGUQoPTDr2ewF9D/Gf8mN7ipqtoaQ3EVjy+g/bPm+0pByAjXguPVE3OUE8T5xwkUHP94cYuJAdYDw2276xlULTACHzbOYEmZzT5QwqoXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=AVmi+LYA; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772114025; x=1803650025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ve8KFPG1L20L/ARx7wUb1TI0Ojkb2i/B9LSYMr/XMgU=;
  b=AVmi+LYAqbCkI2f5PUlDQgKa4y/V7ykkA/R+ct3VBcPtSQ+DOTrmo8xl
   7KrZcESv0id0O1TCV9i9at4M7+MRsJONBxYXFVPK5JnGNYw9jZHy9BxKf
   z1ZwCQlX1OgYPJAAmg2QRHc2I+GuvrNZBUIW6gUCs7xpmg+9BwYkNwZhn
   /X3ms3LbD0AZq6mOfiqumlM2TAYv/sNF9af4jls+PbptAvyG8ZSyMTSFH
   jUbqboZwVOFmbzZsyKFzUnqndAMqD614dfFAB8DbKoa57MYErzAOqdVIj
   4vzqgAyzRLbIRX3tRYZkQgfdzy0eTdht7kRrmlVaXd7fD7CLyXTtgLCvD
   A==;
X-CSE-ConnectionGUID: Wjy/hH3pTUelLBNqnTRPag==
X-CSE-MsgGUID: CGq2ot+4T2i4G++mZGGDUg==
X-IronPort-AV: E=Sophos;i="6.21,312,1763424000"; 
   d="scan'208";a="13637417"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 13:53:42 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:3506]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.162:2525] with esmtp (Farcaster)
 id 572c3190-43cd-4ad4-976b-74242004b634; Thu, 26 Feb 2026 13:53:41 +0000 (UTC)
X-Farcaster-Flow-ID: 572c3190-43cd-4ad4-976b-74242004b634
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:53:41 +0000
Received: from dev-dsk-itazur-1b-11e7fc0f.eu-west-1.amazon.com (172.19.66.53)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:53:39 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, Fuad Tabba <tabba@google.com>,
	Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <pdurrant@amazon.com>,
	Nikita Kalyazin <kalyazin@amazon.com>, Patrick Roy
	<patrick.roy@campus.lmu.de>, Takahiro Itazuri <zulinx86@gmail.com>
Subject: [RFC PATCH v2 4/7] KVM: Rename invalidate_begin to invalidate_start for consistency
Date: Thu, 26 Feb 2026 13:53:05 +0000
Message-ID: <20260226135309.29493-5-itazur@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226135309.29493-1-itazur@amazon.com>
References: <20260226135309.29493-1-itazur@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: EX19D041UWA002.ant.amazon.com (10.13.139.121) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,google.com,kernel.org,infradead.org,amazon.com,campus.lmu.de,gmail.com];
	TAGGED_FROM(0.00)[bounces-71976-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[itazur@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 5D9111A76F1
X-Rspamd-Action: no action

Most MMU-related helpers use "_start" suffix.  Align with the prevailing
naming convention for consistency across MMU-related codebase.

```
$ git grep -E "invalidate(_range)?_start" | wc -l
123

$ git grep -E "invalidate(_range)?_begin" | wc -l
14
```

No functional change intended.

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---
 arch/x86/kvm/mmu/mmu.c       |  2 +-
 include/linux/kvm_host.h     |  2 +-
 include/linux/mmu_notifier.h |  4 ++--
 virt/kvm/guest_memfd.c       | 14 +++++++-------
 virt/kvm/kvm_main.c          |  6 +++---
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d3e705ac4c6f..e82a357e2219 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6859,7 +6859,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_sta=
rt, gfn_t gfn_end)
=20
 	write_lock(&kvm->mmu_lock);
=20
-	kvm_mmu_invalidate_begin(kvm);
+	kvm_mmu_invalidate_start(kvm);
=20
 	kvm_mmu_invalidate_range_add(kvm, gfn_start, gfn_end);
=20
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2ea5d2f172f7..618a71894ed1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1566,7 +1566,7 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_=
cache *mc);
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 #endif
=20
-void kvm_mmu_invalidate_begin(struct kvm *kvm);
+void kvm_mmu_invalidate_start(struct kvm *kvm);
 void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end);
 void kvm_mmu_invalidate_end(struct kvm *kvm);
 bool kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index d1094c2d5fb6..8ecf36a84e3b 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -134,8 +134,8 @@ struct mmu_notifier_ops {
 	 * Invalidation of multiple concurrent ranges may be
 	 * optionally permitted by the driver. Either way the
 	 * establishment of sptes is forbidden in the range passed to
-	 * invalidate_range_begin/end for the whole duration of the
-	 * invalidate_range_begin/end critical section.
+	 * invalidate_range_start/end for the whole duration of the
+	 * invalidate_range_start/end critical section.
 	 *
 	 * invalidate_range_start() is called when all pages in the
 	 * range are still mapped and have at least a refcount of one.
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5d6e966d4f32..79f34dad0c2f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -206,7 +206,7 @@ static enum kvm_gfn_range_filter kvm_gmem_get_invalidat=
e_filter(struct inode *in
 	return KVM_FILTER_PRIVATE;
 }
=20
-static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
+static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
 					pgoff_t end,
 					enum kvm_gfn_range_filter attr_filter)
 {
@@ -230,7 +230,7 @@ static void __kvm_gmem_invalidate_begin(struct gmem_fil=
e *f, pgoff_t start,
 			found_memslot =3D true;
=20
 			KVM_MMU_LOCK(kvm);
-			kvm_mmu_invalidate_begin(kvm);
+			kvm_mmu_invalidate_start(kvm);
 		}
=20
 		flush |=3D kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
@@ -243,7 +243,7 @@ static void __kvm_gmem_invalidate_begin(struct gmem_fil=
e *f, pgoff_t start,
 		KVM_MMU_UNLOCK(kvm);
 }
=20
-static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
+static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
 				      pgoff_t end)
 {
 	enum kvm_gfn_range_filter attr_filter;
@@ -252,7 +252,7 @@ static void kvm_gmem_invalidate_begin(struct inode *ino=
de, pgoff_t start,
 	attr_filter =3D kvm_gmem_get_invalidate_filter(inode);
=20
 	kvm_gmem_for_each_file(f, inode->i_mapping)
-		__kvm_gmem_invalidate_begin(f, start, end, attr_filter);
+		__kvm_gmem_invalidate_start(f, start, end, attr_filter);
 }
=20
 static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
@@ -287,7 +287,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, lo=
ff_t offset, loff_t len)
 	 */
 	filemap_invalidate_lock(inode->i_mapping);
=20
-	kvm_gmem_invalidate_begin(inode, start, end);
+	kvm_gmem_invalidate_start(inode, start, end);
=20
 	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
=20
@@ -401,7 +401,7 @@ static int kvm_gmem_release(struct inode *inode, struct=
 file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	__kvm_gmem_invalidate_begin(f, 0, -1ul,
+	__kvm_gmem_invalidate_start(f, 0, -1ul,
 				    kvm_gmem_get_invalidate_filter(inode));
 	__kvm_gmem_invalidate_end(f, 0, -1ul);
=20
@@ -582,7 +582,7 @@ static int kvm_gmem_error_folio(struct address_space *m=
apping, struct folio *fol
 	start =3D folio->index;
 	end =3D start + folio_nr_pages(folio);
=20
-	kvm_gmem_invalidate_begin(mapping->host, start, end);
+	kvm_gmem_invalidate_start(mapping->host, start, end);
=20
 	/*
 	 * Do not truncate the range, what action is taken in response to the
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 60a8b7ca8ab4..5871882ff1db 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -678,7 +678,7 @@ static __always_inline int kvm_age_hva_range_no_flush(s=
truct mmu_notifier *mn,
 	return kvm_age_hva_range(mn, start, end, handler, false);
 }
=20
-void kvm_mmu_invalidate_begin(struct kvm *kvm)
+void kvm_mmu_invalidate_start(struct kvm *kvm)
 {
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	/*
@@ -734,7 +734,7 @@ static int kvm_mmu_notifier_invalidate_range_start(stru=
ct mmu_notifier *mn,
 		.start		=3D range->start,
 		.end		=3D range->end,
 		.handler	=3D kvm_mmu_unmap_gfn_range,
-		.on_lock	=3D kvm_mmu_invalidate_begin,
+		.on_lock	=3D kvm_mmu_invalidate_start,
 		.flush_on_ret	=3D true,
 		.may_block	=3D mmu_notifier_range_blockable(range),
 	};
@@ -2571,7 +2571,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm,=
 gfn_t start, gfn_t end,
 		.end =3D end,
 		.arg.attributes =3D attributes,
 		.handler =3D kvm_pre_set_memory_attributes,
-		.on_lock =3D kvm_mmu_invalidate_begin,
+		.on_lock =3D kvm_mmu_invalidate_start,
 		.flush_on_ret =3D true,
 		.may_block =3D true,
 	};
--=20
2.50.1


