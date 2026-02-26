Return-Path: <kvm+bounces-71980-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id COUrFGlWoGlLiQQAu9opvQ
	(envelope-from <kvm+bounces-71980-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:19:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5A511A7605
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:19:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 31C7A316979A
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503EA3D6466;
	Thu, 26 Feb 2026 13:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ssyzlWw3"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FFC3A0EAB
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 13:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114047; cv=none; b=lJgCZYAiLnP25B9vm9jhx9TeLttdX8z7Mu9WzSdmG+jpmeeD4Wz3pTwEQGRqo76XnWfPqajtwCET+OKb3eOv723lH2VSM7jznYAkopiOFNTt+StNmxFoEWOz9sfms908FsLXkJMTzieBPCNwOZhA+l/95K0TNS1EmRN1YaP6NDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114047; c=relaxed/simple;
	bh=wgp7h4u8JWSCG9MXNfyYcwya18YPvWlQN7yLCRCIFXU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omyMhhUHt3kK5VkUrFWTy9DDr2Uyewqq8w4H21ChDjKJbPn/5wlAKxPVfytXFEReJy0efUV7bziRE5PfWQTIloucDMhb/cz/mGoToOjGwFnf5O/j2UT/pUcr0rWFJ3IDRwEeXKMGmWMOap+dxIgOqYShWkgi2VvF/mlK+vw6iIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ssyzlWw3; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772114046; x=1803650046;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1cLW7dxL7oQwjTjxBqoOixl0aP0gjPtuUQLoyunm2uo=;
  b=ssyzlWw34/mo1mP657n+OamcTUhLTM5Ct9yjlD19DPPhJJGfdUsSg8WF
   H+GbtoEaZaYX+xtFa0C1YwbI/Ta4obENt4C4Oq+qG1jy508jNZvlY2snd
   FSJ07CDw48LEj0LXQkb0avLXKRj3/cs53w2qN0BGSQ9otJMky6/0lItAx
   vbi+WZV14JJYrm7Xk8RTDbFJx23OB9RhFKrTDdcVRY1obLn9NXo4VxBD3
   c/TgbgFZ3gTiQyC7EYYgaJthUzCr/20U1QlmP7fVz7sI6GzDuD1QUirYq
   j/u5Qm1+joDVtYefZdtQqT4knxMd9D+u0IGHOO2aCVSDZGTqZAwoeVsgQ
   g==;
X-CSE-ConnectionGUID: UnQZldRaQ+CneeRvrZqllw==
X-CSE-MsgGUID: qcCfNm5sREe1Y0R1JKfxPg==
X-IronPort-AV: E=Sophos;i="6.21,312,1763424000"; 
   d="scan'208";a="13862865"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 13:54:05 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:12513]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.162:2525] with esmtp (Farcaster)
 id 16a9a065-b96e-4a71-857f-c89ebcaf7b0f; Thu, 26 Feb 2026 13:54:05 +0000 (UTC)
X-Farcaster-Flow-ID: 16a9a065-b96e-4a71-857f-c89ebcaf7b0f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:54:00 +0000
Received: from dev-dsk-itazur-1b-11e7fc0f.eu-west-1.amazon.com (172.19.66.53)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:53:58 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, Fuad Tabba <tabba@google.com>,
	Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <pdurrant@amazon.com>,
	Nikita Kalyazin <kalyazin@amazon.com>, Patrick Roy
	<patrick.roy@campus.lmu.de>, Takahiro Itazuri <zulinx86@gmail.com>
Subject: [RFC PATCH v2 7/7] KVM: pfncache: Invalidate on gmem invalidation and memattr updates
Date: Thu, 26 Feb 2026 13:53:08 +0000
Message-ID: <20260226135309.29493-8-itazur@amazon.com>
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
X-ClientProxiedBy: EX19D044UWB002.ant.amazon.com (10.13.139.188) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,google.com,kernel.org,infradead.org,amazon.com,campus.lmu.de,gmail.com];
	TAGGED_FROM(0.00)[bounces-71980-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[itazur@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: E5A511A7605
X-Rspamd-Action: no action

Invalidate pfncaches when guest_memfd invalidation or memory attribute
updates render cached PFN resolutions stale.

Reuse active_invalidate_count to synchronize with the existing retry
logic and preserve ordering against mmu_invalidate_seq.

Invalidation needs to be performed using HVA ranges so that both
GPA-based and HVA-based pfncaches are covered.  Internally GPA-based
ones translate GPA to memslot/UHVA first and then resolve PFN, while
HVA-based ones only resolve PFN and do not store memslot/GPA context.
Technically, it is possible to make HVA-based pfncaches search the
corresponding memslot/GPA when activated / refreshed, but it would add
overhead to a greater ot lesser extent, regardless of guest_memfd-backed
or not.  At the time of writing, only Xen uses HVA-based pfncaches.

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 virt/kvm/guest_memfd.c | 50 ++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c    | 45 +++++++++++++++++++++++++++++++++++++
 virt/kvm/pfncache.c    |  4 ++--
 3 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 79f34dad0c2f..eb2f1a7e54dc 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -215,6 +215,33 @@ static void __kvm_gmem_invalidate_start(struct gmem_fi=
le *f, pgoff_t start,
 	struct kvm *kvm =3D f->kvm;
 	unsigned long index;
=20
+	/*
+	 * Prevent pfncaches from being activated / refreshed using stale PFN
+	 * resolutions.  To invalidate pfncaches _before_ invalidating the
+	 * secondary MMUs (i.e. without acquiring mmu_lock), pfncaches must use
+	 * active_invalidate_count instead of mmu_invalidate_in_progress.
+	 */
+	spin_lock(&kvm->invalidate_lock);
+	kvm->active_invalidate_count++;
+	spin_unlock(&kvm->invalidate_lock);
+
+	/*
+	 * Invalidation of pfncaches must be done using a HVA range.  pfncaches
+	 * can be either GPA-based or HVA-based, and all pfncaches store uhva
+	 * while HVA-based pfncaches do not have gpa/memslot info.  Thus,
+	 * using GFN ranges would miss invalidating HVA-based ones.
+	 */
+	xa_for_each_range(&f->bindings, index, slot, start, end - 1) {
+		pgoff_t pgoff =3D slot->gmem.pgoff;
+		gfn_t gfn_start =3D slot->base_gfn + max(pgoff, start) - pgoff;
+		gfn_t gfn_end =3D slot->base_gfn + min(pgoff + slot->npages, end) - pgof=
f;
+
+		unsigned long hva_start =3D gfn_to_hva_memslot(slot, gfn_start);
+		unsigned long hva_end =3D gfn_to_hva_memslot(slot, gfn_end);
+
+		gpc_invalidate_hva_range_start(kvm, hva_start, hva_end);
+	}
+
 	xa_for_each_range(&f->bindings, index, slot, start, end - 1) {
 		pgoff_t pgoff =3D slot->gmem.pgoff;
=20
@@ -259,12 +286,35 @@ static void __kvm_gmem_invalidate_end(struct gmem_fil=
e *f, pgoff_t start,
 				      pgoff_t end)
 {
 	struct kvm *kvm =3D f->kvm;
+	bool wake;
=20
 	if (xa_find(&f->bindings, &start, end - 1, XA_PRESENT)) {
 		KVM_MMU_LOCK(kvm);
 		kvm_mmu_invalidate_end(kvm);
 		KVM_MMU_UNLOCK(kvm);
 	}
+
+	/*
+	 * This must be done after the increment of mmu_invalidate_seq and
+	 * smp_wmb() in kvm_mmu_invalidate_end() to guarantee that
+	 * gpc_invalidate_retry() observes either the old (non-zero)
+	 * active_invalidate_count or the new (incremented) mmu_invalidate_seq.
+	 */
+	spin_lock(&kvm->invalidate_lock);
+	if (!WARN_ON_ONCE(!kvm->active_invalidate_count))
+		kvm->active_invalidate_count--;
+	wake =3D !kvm->active_invalidate_count;
+	spin_unlock(&kvm->invalidate_lock);
+
+	/*
+	 * guest_memfd invalidation itself doesn't need to block active memslots
+	 * swap as bindings updates are serialized by filemap_invalidate_lock().
+	 * However, active_invalidate_count is shared with the MMU notifier
+	 * path, so the waiter must be waked when active_invalidate_count drops
+	 * to zero.
+	 */
+	if (wake)
+		rcuwait_wake_up(&kvm->memslots_update_rcuwait);
 }
=20
 static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f51056e971d0..f56b98c85175 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2583,6 +2583,8 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm,=
 gfn_t start, gfn_t end,
 		.on_lock =3D kvm_mmu_invalidate_end,
 		.may_block =3D true,
 	};
+	struct kvm_memslots *slots =3D kvm_memslots(kvm);
+	struct kvm_memory_slot *slot;
 	unsigned long i;
 	void *entry;
 	int r =3D 0;
@@ -2609,6 +2611,34 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm=
, gfn_t start, gfn_t end,
 		cond_resched();
 	}
=20
+	/*
+	 * Prevent pfncaches from being activated / refreshed using stale PFN
+	 * resolutions.  To invalidate pfncaches _before_ invalidating the
+	 * secondary MMUs (i.e. without acquiring mmu_lock), pfncaches must use
+	 * active_invalidate_count instead of mmu_invalidate_in_progress.
+	 */
+	spin_lock(&kvm->invalidate_lock);
+	kvm->active_invalidate_count++;
+	spin_unlock(&kvm->invalidate_lock);
+
+	/*
+	 * Invalidation of pfncaches must be done using a HVA range.  pfncaches
+	 * can be either GPA-based or HVA-based, and all pfncaches store uhva
+	 * while HVA-based pfncaches do not have gpa/memslot info.  Thus,
+	 * using GFN ranges would miss invalidating HVA-based ones.
+	 */
+	kvm_for_each_memslot(slot, slots) {
+		gfn_t gfn_start =3D max(start, slot->base_gfn);
+		gfn_t gfn_end =3D min(end, slot->base_gfn + slot->npages);
+
+		if (gfn_start < gfn_end) {
+			unsigned long hva_start =3D gfn_to_hva_memslot(slot, gfn_start);
+			unsigned long hva_end =3D gfn_to_hva_memslot(slot, gfn_end);
+
+			gpc_invalidate_hva_range_start(kvm, hva_start, hva_end);
+		}
+	}
+
 	kvm_handle_gfn_range(kvm, &pre_set_range);
=20
 	for (i =3D start; i < end; i++) {
@@ -2620,6 +2650,21 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm=
, gfn_t start, gfn_t end,
=20
 	kvm_handle_gfn_range(kvm, &post_set_range);
=20
+	/*
+	 * This must be done after the increment of mmu_invalidate_seq and
+	 * smp_wmb() in kvm_mmu_invalidate_end() to guarantee that
+	 * gpc_invalidate_retry() observes either the old (non-zero)
+	 * active_invalidate_count or the new (incremented) mmu_invalidate_seq.
+	 *
+	 * memslots_update_rcuwait does not need to be waked when
+	 * active_invalidate_count drops to zero because active memslots swap is
+	 * also done while holding slots_lock.
+	 */
+	spin_lock(&kvm->invalidate_lock);
+	if (!WARN_ON_ONCE(!kvm->active_invalidate_count))
+		kvm->active_invalidate_count--;
+	spin_unlock(&kvm->invalidate_lock);
+
 out_unlock:
 	mutex_unlock(&kvm->slots_lock);
=20
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 2880a36257c2..2b44da46d2ab 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -144,7 +144,7 @@ static void gpc_unmap(kvm_pfn_t pfn, void *khva)
 #endif
 }
=20
-static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long=
 mmu_seq)
+static inline bool gpc_invalidate_retry(struct kvm *kvm, unsigned long mmu=
_seq)
 {
 	/*
 	 * active_invalidate_count acts for all intents and purposes like
@@ -274,7 +274,7 @@ static kvm_pfn_t gpc_to_pfn_retry(struct gfn_to_pfn_cac=
he *gpc)
 		 * attempting to refresh.
 		 */
 		WARN_ON_ONCE(gpc->valid);
-	} while (mmu_notifier_retry_cache(gpc->kvm, mmu_seq));
+	} while (gpc_invalidate_retry(gpc->kvm, mmu_seq));
=20
 	gpc->valid =3D true;
 	gpc->pfn =3D new_pfn;
--=20
2.50.1


