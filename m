Return-Path: <kvm+bounces-71975-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EKvEL19ToGlLiQQAu9opvQ
	(envelope-from <kvm+bounces-71975-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:06:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D981A735B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:06:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5B342316F2E8
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE75D3D1CAE;
	Thu, 26 Feb 2026 13:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="gcllh7LZ"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1694E3D5235
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 13:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114020; cv=none; b=mSjdJmsHwzn/bogF48eOhlvN8rP+iveq4cTfUiP/m7h3PYINHgd2ZPXoCqqnrJwu1ESi82sU4OEZ8J/MJFDaTPPOfHLxPzUhLClrHRC/junPSt9K8+UEPAD86fbi1+MkO/euB2fUWTBsTeTnYIU48a48UbkqgPaFdJ4ktKn8s7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114020; c=relaxed/simple;
	bh=OyHM4y1MfAa+AwnNiZUUarXhLRkbJfDsCTyjTm4Gjio=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iG4hnjRd/rHE/HAPDdPsFHIJ7j9BwaYPgLkCadbKrzJHjr2xuJBf6V1/CyKpjAEv5YCgMCsFeivHw7a6UXcSlUNXB+OV86BanXjxgXOO8hqKXECphwF+37P5kQQaO9U9TH1UPOqofY9HWMY3gTm9/WPlV0/TNOKjhnX+fWMpjfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=gcllh7LZ; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772114018; x=1803650018;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=83vf9vlnezp9HGuLaM9rEAK9OlEzZLycj9v2nOeu6r0=;
  b=gcllh7LZn2GrHzJ3TTShzTb7rguhxxtTTShPKk4dFvqxvf9+xHaSGD2n
   FtuYLoIprc7fc96euf90JXVKnimN56T/Y84d1LmYpmgygyZyLog9quiBR
   1qH9tl/A6aNoqzZeFHEKbA4JJeprpV1vMSBYawNYZuNU4KI8dUwBlriNN
   sdWHHbUx0L81ROvKleqgFOTVQmrnIFtTg0rvRNl+1gSh9MnUyd6vh2cfq
   NLCMbrKB6ZvxbxQDqnrXYljawIvNKD/aYuicztl9kkmby4HEEHkNLfSKd
   ceGU7WFabg9aiDJabgp6unxvyob89G3Xr/In4stU8mW5QXUQwHDCDynzD
   A==;
X-CSE-ConnectionGUID: 3EuIR15GRhSIME/yTkLCoA==
X-CSE-MsgGUID: 1cJJBX1oS1urvLRWDEzQ2Q==
X-IronPort-AV: E=Sophos;i="6.21,312,1763424000"; 
   d="scan'208";a="13853274"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 13:53:35 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:19743]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.26.67:2525] with esmtp (Farcaster)
 id daaf500f-8bb1-4f54-8c01-8e75d6ea9930; Thu, 26 Feb 2026 13:53:34 +0000 (UTC)
X-Farcaster-Flow-ID: daaf500f-8bb1-4f54-8c01-8e75d6ea9930
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:53:34 +0000
Received: from dev-dsk-itazur-1b-11e7fc0f.eu-west-1.amazon.com (172.19.66.53)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:53:32 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, Fuad Tabba <tabba@google.com>,
	Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <pdurrant@amazon.com>,
	Nikita Kalyazin <kalyazin@amazon.com>, Patrick Roy
	<patrick.roy@campus.lmu.de>, Takahiro Itazuri <zulinx86@gmail.com>
Subject: [RFC PATCH v2 3/7] KVM: pfncache: Obtain KHVA via vmap() for gmem with NO_DIRECT_MAP
Date: Thu, 26 Feb 2026 13:53:04 +0000
Message-ID: <20260226135309.29493-4-itazur@amazon.com>
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
X-ClientProxiedBy: EX19D036UWB002.ant.amazon.com (10.13.139.139) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,google.com,kernel.org,infradead.org,amazon.com,campus.lmu.de,gmail.com];
	TAGGED_FROM(0.00)[bounces-71975-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[itazur@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 27D981A735B
X-Rspamd-Action: no action

Currently, pfncaches map RAM pages via kmap(), which typically returns a
kernel address derived from the direct map.  However, guest_memfd
created with GUEST_MEMFD_FLAG_NO_DIRECT_MAP has their direct map removed
and uses an AS_NO_DIRECT_MAP mapping.  So kmap() cannot be used in this
case.

pfncaches can be used from atomic context where page faults cannot be
tolerated.  Therefore, it cannot fall back to access via a userspace
mapping like KVM does for other accesses to NO_DIRECT_MAP guest_memfd.

To obtain a fault-free kernel host virtual address (KHVA), use vmap()
for NO_DIRECT_MAP pages.  Since gpc_map() is the sole producer of KHVA
for pfncaches and only vmap() returns a vmalloc address, gpc_unmap()
can reliably pair vunmap() using is_vmalloc_addr().

Although vm_map_ram() could be faster than vmap(), mixing short-lived
and long-lived vm_map_ram() can lead to fragmentation.  For this reason,
vm_map_ram() is recommended only for short-lived ones.  Since pfncaches
typically have a lifetime comparable to that of the VM, vm_map_ram() is
deliberately not used here.

pfncaches are not dynamically allocated but are statically allocated on
a per-VM and per-vCPU basis.  For a normal VM (i.e. non-Xen), there is
one pfncache per vCPU.  For a Xen VM, there is one per-VM pfncache and
five per-vCPU pfncaches.  Given the maximum of 1024 vCPUs, a normal VM
can have up to 1024 pfncaches, consuming 4 MB of virtual address space.
A Xen VM can have up to 5121 pfncaches, consuming approximately 20 MB of
virtual address space.  Although the vmalloc area is limited on 32-bit
systems, it should be large enough and typically tens of TB on 64-bit
systems (e.g. 32 TB for 4-level paging and 12800 TB for 5-level paging
on x86_64).  If virtual address space exhaustion becomes a concern,
migration to an mm-local region (like forthcoming mermap?) could be
considered in the future.  Note that vmap() and vm_map_ram() only create
virtual mappings to existing pages; they do not allocate new physical
pages.

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---
 virt/kvm/pfncache.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 100a8e2f114b..531adc4dcb11 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -16,6 +16,7 @@
 #include <linux/highmem.h>
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/pagemap.h>
=20
 #include "kvm_mm.h"
=20
@@ -98,8 +99,19 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigne=
d long len)
=20
 static void *gpc_map(kvm_pfn_t pfn)
 {
-	if (pfn_valid(pfn))
-		return kmap(pfn_to_page(pfn));
+	if (pfn_valid(pfn)) {
+		struct page *page =3D pfn_to_page(pfn);
+		struct page *head =3D compound_head(page);
+		struct address_space *mapping =3D READ_ONCE(head->mapping);
+
+		if (mapping && mapping_no_direct_map(mapping)) {
+			struct page *pages[] =3D { page };
+
+			return vmap(pages, 1, VM_MAP, PAGE_KERNEL);
+		}
+
+		return kmap(page);
+	}
=20
 #ifdef CONFIG_HAS_IOMEM
 	return memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
@@ -115,7 +127,15 @@ static void gpc_unmap(kvm_pfn_t pfn, void *khva)
 		return;
=20
 	if (pfn_valid(pfn)) {
-		kunmap(pfn_to_page(pfn));
+		/*
+		 * For valid PFNs, gpc_map() returns either a kmap() address
+		 * (non-vmalloc) or a vmap() address (vmalloc).
+		 */
+		if (is_vmalloc_addr(khva))
+			vunmap(khva);
+		else
+			kunmap(pfn_to_page(pfn));
+
 		return;
 	}
=20
@@ -233,8 +253,11 @@ static kvm_pfn_t gpc_to_pfn_retry(struct gfn_to_pfn_ca=
che *gpc)
=20
 		/*
 		 * Obtain a new kernel mapping if KVM itself will access the
-		 * pfn.  Note, kmap() and memremap() can both sleep, so this
-		 * too must be done outside of gpc->lock!
+		 * pfn.  Note, kmap(), vmap() and memremap() can all sleep, so
+		 * this too must be done outside of gpc->lock!
+		 * Note that even though gpc->lock is dropped, it's still fine
+		 * to read gpc->pfn and other fields because gpc->refresh_lock
+		 * mutex prevents them from being updated.
 		 */
 		if (new_pfn =3D=3D gpc->pfn)
 			new_khva =3D old_khva;
--=20
2.50.1


