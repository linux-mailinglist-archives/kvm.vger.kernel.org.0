Return-Path: <kvm+bounces-72652-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wPirNtqUp2mqiQAAu9opvQ
	(envelope-from <kvm+bounces-72652-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 03:11:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FFA31F9CB3
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 03:11:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5C24F303B93D
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 02:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B233191D6;
	Wed,  4 Mar 2026 02:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VnOIi4NJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D9D272E56
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 02:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772590295; cv=none; b=EkCH7BdtI92bmnoiV5hnlk+72SWwyYDNgrNOhn+lfxtxn049pD/0UzvTpMrSrUsGSdVf7sJu5PSocHvPVxOlb2Kzhbo5K311VYNtH9YORWhFtC6oLxFY80GgAG27KjzWhDwfjSBt0xage6HIXQfJS5RrAOSP0KZuxvYyOz0/9FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772590295; c=relaxed/simple;
	bh=u6snGURNRVdBF9Oym9NViXxmQu9pzKOjDuNKNbY3Y5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoQgh2Z3GhrkvQQh41hjAYebzL3HOTGRtD9AERNmI4yQvcJX3D0UeXJsKYBX0Qb1JxdJ7yXKx0nlcJ/emntep8o3d6rxlI3Fclh7c0vzVTCdqJlFlk8v6f/d/VqWBDR6EXiFExLOEMTLZxVrr8ATUr4GcA4wiEsd8Y8SnUI4KoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VnOIi4NJ; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772590291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6zO2kH0svbHx3wC9dGJj7zDc7KLoM6zIa0KkqCo/aKA=;
	b=VnOIi4NJ2EAfX/nJqT5BK5btiveTdW/sa7Ufo95ckq7KxfH+fb9DlRhbQLGWI10vo44wj6
	THZ5iYwXvG+I5znKhcEaqG2aVir82NnjBTbMyM/LATr4O8EOzIcytdSBKzKgrrG9Igngfp
	5zJ8ygBTJBc4R4ThrC5ulNktptEwybI=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org,
	david@kernel.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	ypodemsk@redhat.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	jgross@suse.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 2/2] x86/tlb: skip redundant sync IPIs for native TLB flush
Date: Wed,  4 Mar 2026 10:10:44 +0800
Message-ID: <20260304021046.18550-3-lance.yang@linux.dev>
In-Reply-To: <20260304021046.18550-1-lance.yang@linux.dev>
References: <20260304021046.18550-1-lance.yang@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6FFA31F9CB3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72652-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[infradead.org,kernel.org,intel.com,linux.intel.com,redhat.com,google.com,gmail.com,linutronix.de,alien8.de,zytor.com,arndb.de,oracle.com,nvidia.com,linux.alibaba.com,arm.com,surriel.com,suse.com,lists.linux.dev,vger.kernel.org,kvack.org,linux.dev];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[38];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lance.yang@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Action: no action

From: Lance Yang <lance.yang@linux.dev>

Enable the optimization introduced in the previous patch for x86.

Add pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast to track whether
flush_tlb_multi() sends real IPIs. Initialize it once in
native_pv_tlb_init() during boot.

On CONFIG_PARAVIRT systems, tlb_table_flush_implies_ipi_broadcast() reads
the pv_ops property. On non-PARAVIRT, it directly checks for INVLPGB.

PV backends (KVM, Xen, Hyper-V) typically have their own implementations
and don't call native_flush_tlb_multi() directly, so they cannot be trusted
to provide the IPI guarantees we need. They keep the property false.

Two-step plan as David suggested[1]:

Step 1 (this patch): Skip redundant sync when we're 100% certain the TLB
flush sent IPIs. INVLPGB is excluded because when supported, we cannot
guarantee IPIs were sent, keeping it clean and simple.

Step 2 (future work): Send targeted IPIs only to CPUs actually doing
software/lockless page table walks, benefiting all architectures.

Regarding Step 2, it obviously only applies to setups where Step 1 does
not apply: like x86 with INVLPGB or arm64.

[1] https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 arch/x86/include/asm/paravirt_types.h |  5 +++++
 arch/x86/include/asm/smp.h            |  3 +++
 arch/x86/include/asm/tlb.h            | 16 +++++++++++++++-
 arch/x86/include/asm/tlbflush.h       |  3 +++
 arch/x86/kernel/paravirt.c            | 20 ++++++++++++++++++++
 arch/x86/kernel/smpboot.c             |  1 +
 arch/x86/mm/tlb.c                     | 14 ++++++++++++++
 7 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 9bcf6bce88f6..ec01268f2e3e 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -112,6 +112,11 @@ struct pv_mmu_ops {
 	void (*flush_tlb_multi)(const struct cpumask *cpus,
 				const struct flush_tlb_info *info);
 
+	/*
+	 * True if flush_tlb_multi() sends real IPIs to all target CPUs.
+	 */
+	bool flush_tlb_multi_implies_ipi_broadcast;
+
 	/* Hook for intercepting the destruction of an mm_struct. */
 	void (*exit_mmap)(struct mm_struct *mm);
 	void (*notify_page_enc_status_changed)(unsigned long pfn, int npages, bool enc);
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 84951572ab81..ef1fe0cc4c73 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -105,6 +105,9 @@ void native_smp_prepare_boot_cpu(void);
 void smp_prepare_cpus_common(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
+
+void __init native_pv_tlb_init(void);
+
 int common_cpu_up(unsigned int cpunum, struct task_struct *tidle);
 int native_kick_ap(unsigned int cpu, struct task_struct *tidle);
 int native_cpu_disable(void);
diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 866ea78ba156..532578c5a2e7 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -5,10 +5,19 @@
 #define tlb_flush tlb_flush
 static inline void tlb_flush(struct mmu_gather *tlb);
 
+#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void);
+
 #include <asm-generic/tlb.h>
 #include <linux/kernel.h>
 #include <vdso/bits.h>
 #include <vdso/page.h>
+#include <asm/paravirt.h>
+
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+	return static_branch_likely(&tlb_ipi_broadcast_key);
+}
 
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
@@ -20,7 +29,12 @@ static inline void tlb_flush(struct mmu_gather *tlb)
 		end = tlb->end;
 	}
 
-	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
+	/*
+	 * Pass both freed_tables and unshared_tables so that lazy-TLB CPUs
+	 * also receive IPIs during unsharing page tables.
+	 */
+	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
+			   tlb->freed_tables || tlb->unshared_tables);
 }
 
 static inline void invlpg(unsigned long addr)
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 5a3cdc439e38..a1b5efef3b90 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -5,6 +5,7 @@
 #include <linux/mm_types.h>
 #include <linux/mmu_notifier.h>
 #include <linux/sched.h>
+#include <linux/jump_label.h>
 
 #include <asm/barrier.h>
 #include <asm/processor.h>
@@ -18,6 +19,8 @@
 
 DECLARE_PER_CPU(u64, tlbstate_untag_mask);
 
+DECLARE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
 void __flush_tlb_all(void);
 
 #define TLB_FLUSH_ALL	-1UL
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index a6ed52cae003..c8decadf16e0 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -154,6 +154,7 @@ struct paravirt_patch_template pv_ops = {
 	.mmu.flush_tlb_kernel	= native_flush_tlb_global,
 	.mmu.flush_tlb_one_user	= native_flush_tlb_one_user,
 	.mmu.flush_tlb_multi	= native_flush_tlb_multi,
+	.mmu.flush_tlb_multi_implies_ipi_broadcast = false,
 
 	.mmu.exit_mmap		= paravirt_nop,
 	.mmu.notify_page_enc_status_changed	= paravirt_nop,
@@ -221,3 +222,22 @@ NOKPROBE_SYMBOL(native_load_idt);
 
 EXPORT_SYMBOL(pv_ops);
 EXPORT_SYMBOL_GPL(pv_info);
+
+void __init native_pv_tlb_init(void)
+{
+	/*
+	 * If PV backend already set the property, respect it.
+	 * Otherwise, check if native TLB flush sends real IPIs to all target
+	 * CPUs (i.e., not using INVLPGB broadcast invalidation).
+	 */
+	if (pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast) {
+		static_branch_enable(&tlb_ipi_broadcast_key);
+		return;
+	}
+
+	if (pv_ops.mmu.flush_tlb_multi == native_flush_tlb_multi &&
+	    !cpu_feature_enabled(X86_FEATURE_INVLPGB)) {
+		pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
+		static_branch_enable(&tlb_ipi_broadcast_key);
+	}
+}
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5cd6950ab672..3cdb04162843 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1167,6 +1167,7 @@ void __init native_smp_prepare_boot_cpu(void)
 		switch_gdt_and_percpu_base(me);
 
 	native_pv_lock_init();
+	native_pv_tlb_init();
 }
 
 void __init native_smp_cpus_done(unsigned int max_cpus)
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 621e09d049cb..7b1acfb97782 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -26,6 +26,8 @@
 
 #include "mm_internal.h"
 
+DEFINE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
 #ifdef CONFIG_PARAVIRT
 # define STATIC_NOPV
 #else
@@ -1834,3 +1836,15 @@ static int __init create_tlb_single_page_flush_ceiling(void)
 	return 0;
 }
 late_initcall(create_tlb_single_page_flush_ceiling);
+
+#ifndef CONFIG_PARAVIRT
+void __init native_pv_tlb_init(void)
+{
+	/*
+	 * For non-PARAVIRT builds, check if native TLB flush sends real IPIs
+	 * (i.e., not using INVLPGB broadcast invalidation).
+	 */
+	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
+		static_branch_enable(&tlb_ipi_broadcast_key);
+}
+#endif
-- 
2.49.0


