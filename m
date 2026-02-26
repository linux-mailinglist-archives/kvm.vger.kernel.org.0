Return-Path: <kvm+bounces-71974-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +BrvJYVVoGlLiQQAu9opvQ
	(envelope-from <kvm+bounces-71974-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:15:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EA0421A7505
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:15:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A09113170600
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F89D3D5232;
	Thu, 26 Feb 2026 13:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="QTZNUGvF"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F423D4126
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 13:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114015; cv=none; b=VSmu8GV0Q7Bhvtymirwbb7P8nCmXqewWTUm3XdHSw/T9NfQbLQ18ak4n+AyFb8Eae0VVimjsPXJzdfNNwr8PRDUuqe9dEfKNuHfAAuLO6YKoOmwZOq2gpyYoU5PK+Ci71Na18bxOdfqaI/Spd9ANx7DUUiguwNaM2+qQ0AoFQgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114015; c=relaxed/simple;
	bh=XUa8hIEOvJd2tQ59Z9AmtWToBS7IJoy42+da2o9KlrI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dxv/JTqtarD0AmIvZHvjEBiisHa7LYakA+bM3F+xIbRP9gBxzf84Z86YsQh1ZWmkL6H7zRsQzetYgMaQbEnGyc6tTorByQTFsRPwd+d2n8QXL2rx03K0ipf6kp6uxrFdURNKMX1P+3fXpn9AGV+C/VYYLbwWmSyFl3ZevjuchVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=QTZNUGvF; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772114013; x=1803650013;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zB+1Hkk2kc+8m3xnEUfto1Io45ubvPbWd0bs5ue0lSk=;
  b=QTZNUGvFa7II9J9RnSuCJsjDDtXjZneOG2smOfQhQBbC7M7LKcQNgRoE
   gFJf0fSsBsTeWTFt6R69UHcy5P3yCxH7klrF8eZYYnHsN96rptWhTSub2
   sseCMcQjdIcbgQMstGjEWXGPPdWGevrsjwCgHr99+UXnvUltu+OttJ6g2
   QHgIL88pH1azC2rnKDfpERZMQRCOEbCdJQezNgyGs7yDBqJ8ViSNSiV4g
   6sh35VE/iy/Ezq6Jjpnd/Qk/mIGkrgC0XA+YUznSYuaYs+p+N7SXRIuwH
   MRlp0T/Y4hjFNJfI+Xu/wRtYzEYsxL/NBM+l2hnPKea32cSYAArgrNc1w
   g==;
X-CSE-ConnectionGUID: tyGn8zeUTS+PixDQeVRFRA==
X-CSE-MsgGUID: WU1vdTGwSZSFKWncxADAvw==
X-IronPort-AV: E=Sophos;i="6.21,312,1763424000"; 
   d="scan'208";a="13862844"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 13:53:30 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:4925]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.3:2525] with esmtp (Farcaster)
 id 678df3cc-7007-4831-ad3f-0263e681a0ba; Thu, 26 Feb 2026 13:53:30 +0000 (UTC)
X-Farcaster-Flow-ID: 678df3cc-7007-4831-ad3f-0263e681a0ba
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:53:28 +0000
Received: from dev-dsk-itazur-1b-11e7fc0f.eu-west-1.amazon.com (172.19.66.53)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:53:26 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, Fuad Tabba <tabba@google.com>,
	Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <pdurrant@amazon.com>,
	Nikita Kalyazin <kalyazin@amazon.com>, Patrick Roy
	<patrick.roy@campus.lmu.de>, Takahiro Itazuri <zulinx86@gmail.com>
Subject: [RFC PATCH v2 2/7] KVM: pfncache: Resolve PFNs via kvm_gmem_get_pfn() for gmem-backed GPAs
Date: Thu, 26 Feb 2026 13:53:03 +0000
Message-ID: <20260226135309.29493-3-itazur@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226135309.29493-1-itazur@amazon.com>
References: <20260226135309.29493-1-itazur@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: EX19D042UWA004.ant.amazon.com (10.13.139.16) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-8.16 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71974-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[redhat.com,google.com,kernel.org,infradead.org,amazon.com,campus.lmu.de,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[itazur@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: EA0421A7505
X-Rspamd-Action: no action

Currently, pfncaches always resolve PFNs via hva_to_pfn(), which
requires a userspace mapping and relies on GUP.  This does not work for
guest_memfd in the following two ways:

  * guest_memfd created without GUEST_MEMFD_FLAG_MMAP does not have a
    userspace mapping for private memory.

  * guest_memfd created with GUEST_MEMFD_FLAG_NO_DIRECT_MAP uses an
    AS_NO_DIRECT_MAP mapping, which is rejected by GUP.

Resolve PFNs via kvm_gmem_get_pfn() for guest_memfd-backed and GPA-based
pfncaches.  Otherwise, fall back to the existing hva_to_pfn().

Note that HVA-based pfncaches always resolve PFNs via hva_to_pfn(), and
thus activation of HVA-based pfncaches for NO_DIRECT_MAP guest_memfd
fails.  Supporting this scenario would be technically possible, but
would require searching the corresponding memslot and GPA from the given
UHVA in order to determine whether it is backed by guest_memfd.  Doing
so would add overhead to the HVA-based pfncache activation / refresh
paths, to a greater or lesser extent, regardless of guest_memfd-backed
or not.  At the time of writing, only Xen uses HVA-based pfncaches.

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---
 virt/kvm/pfncache.c | 45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 728d2c1b488a..100a8e2f114b 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -152,7 +152,36 @@ static inline bool mmu_notifier_retry_cache(struct kvm=
 *kvm, unsigned long mmu_s
 	return kvm->mmu_invalidate_seq !=3D mmu_seq;
 }
=20
-static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
+static inline bool gpc_is_gmem_backed(struct gfn_to_pfn_cache *gpc)
+{
+	/* For HVA-based pfncaches, memslot is NULL */
+	return gpc->memslot && kvm_slot_has_gmem(gpc->memslot) &&
+	       (kvm_memslot_is_gmem_only(gpc->memslot) ||
+		kvm_mem_is_private(gpc->kvm, gpa_to_gfn(gpc->gpa)));
+}
+
+static kvm_pfn_t gpc_to_pfn(struct gfn_to_pfn_cache *gpc, struct page **pa=
ge)
+{
+	if (gpc_is_gmem_backed(gpc)) {
+		kvm_pfn_t pfn;
+
+		if (kvm_gmem_get_pfn(gpc->kvm, gpc->memslot,
+				     gpa_to_gfn(gpc->gpa), &pfn, page, NULL))
+			return KVM_PFN_ERR_FAULT;
+
+		return pfn;
+	}
+
+	return hva_to_pfn(&(struct kvm_follow_pfn) {
+		.slot =3D gpc->memslot,
+		.gfn =3D gpa_to_gfn(gpc->gpa),
+		.flags =3D FOLL_WRITE,
+		.hva =3D gpc->uhva,
+		.refcounted_page =3D page,
+	});
+}
+
+static kvm_pfn_t gpc_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 {
 	/* Note, the new page offset may be different than the old! */
 	void *old_khva =3D (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
@@ -161,14 +190,6 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_ca=
che *gpc)
 	unsigned long mmu_seq;
 	struct page *page;
=20
-	struct kvm_follow_pfn kfp =3D {
-		.slot =3D gpc->memslot,
-		.gfn =3D gpa_to_gfn(gpc->gpa),
-		.flags =3D FOLL_WRITE,
-		.hva =3D gpc->uhva,
-		.refcounted_page =3D &page,
-	};
-
 	lockdep_assert_held(&gpc->refresh_lock);
=20
 	lockdep_assert_held_write(&gpc->lock);
@@ -206,7 +227,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cac=
he *gpc)
 			cond_resched();
 		}
=20
-		new_pfn =3D hva_to_pfn(&kfp);
+		new_pfn =3D gpc_to_pfn(gpc, &page);
 		if (is_error_noslot_pfn(new_pfn))
 			goto out_error;
=20
@@ -319,7 +340,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *g=
pc, gpa_t gpa, unsigned l
 		}
 	}
=20
-	/* Note: the offset must be correct before calling hva_to_pfn_retry() */
+	/* Note: the offset must be correct before calling gpc_to_pfn_retry() */
 	gpc->uhva +=3D page_offset;
=20
 	/*
@@ -327,7 +348,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *g=
pc, gpa_t gpa, unsigned l
 	 * drop the lock and do the HVA to PFN lookup again.
 	 */
 	if (!gpc->valid || hva_change) {
-		ret =3D hva_to_pfn_retry(gpc);
+		ret =3D gpc_to_pfn_retry(gpc);
 	} else {
 		/*
 		 * If the HVA=E2=86=92PFN mapping was already valid, don't unmap it.
--=20
2.50.1


