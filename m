Return-Path: <kvm+bounces-70219-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UD1cJalhg2nAmAMAu9opvQ
	(envelope-from <kvm+bounces-70219-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:11:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FADFE8138
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8582630C682B
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:04:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF07C423175;
	Wed,  4 Feb 2026 15:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EunoD1TJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75EE2C21F2;
	Wed,  4 Feb 2026 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217392; cv=none; b=qq3xu5v1Ai4VdCW3yGLxJ+R1q2vGGHc9jKEKGDx9Jhao6M0Knn67m6eOhafi80FA2GRPd2UtEfTM2qvWBiL1cvsFP+Bv12KDy0gpEjhK2lrCl6OlLK7unLQ6MOTZ2VbYNqw5g+rcr4lAJaa/ee5xGncyS+a+diYDxF1HSJ7Aqvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217392; c=relaxed/simple;
	bh=X/9jsjyaBRXkNS4VcNwgMllC6zMauDO6PGpmUhvrsjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2cj5URWSBlPZcq49lTtaqB8WKDGCpSd8ctNryUo0YSqSz4bmVbVroAbhnhRQDpzjQyWSmwqf2qrRQzSjv79+QEqBVH+bxLA92JioQbQLd3UWcqrgykW9/v0G3khwRyVBr9zyerwj4CLUQJ5X0CItvGsNjmbVMf+6fgcstO2MrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EunoD1TJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 613Mbt1k021704;
	Wed, 4 Feb 2026 15:03:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=trNgtTtg42ZVX0hYX
	iZyZ0171YWRKKNwV7vaSwnffPM=; b=EunoD1TJwwwKma3J74KcJd7wcSg0yeQ5H
	gC+APJ4maXtiG87gOJK2Ym55WL3ZhobQawWznNYVv6dnXJy/c4CO6q6yQdrepcDm
	ep7b+P01nFZyDcbLaRhE6cHc8EDLD1kMCPaOv8iwKAKuM007Vhk7Xjf6A05chw2P
	ErUpTFEE/bcwI0uuGU1LgFePuwKm1fHmKc5k5spEs9lI0ZUFMlhy7NFFNg9XYoGk
	cz0vMLuhkFz7Hmck1e/dvzvVoXY3rTMEfJljrkFQ4qkOGpwgsR6d+Fei86LDsbZ2
	A/TuWjL7Nzef1zdtJH+OqCzGHY4/qQ+58AjLXZwntkT4QtGAqPJsQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dtad6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:08 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614COMTS009156;
	Wed, 4 Feb 2026 15:03:07 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1vey5s2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:07 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F33c830015832
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:03 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91D9C20040;
	Wed,  4 Feb 2026 15:03:03 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46F382004D;
	Wed,  4 Feb 2026 15:03:03 +0000 (GMT)
Received: from p-imbrenda.aag-de.ibm.com (unknown [9.52.223.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Feb 2026 15:03:03 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v7 13/29] KVM: s390: KVM page table management functions: allocation
Date: Wed,  4 Feb 2026 16:02:42 +0100
Message-ID: <20260204150259.60425-14-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260204150259.60425-1-imbrenda@linux.ibm.com>
References: <20260204150259.60425-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfX2gb73XrOvkCa
 E6oQTTev2NneT4uw/poewtbnnnMiHy7kpHq1LURMtkW5M1j+USr8WvqbebJKnAW2VQBslyuJduF
 iexRk/br0x/lp1g4KaOrbRVW8fEeP51sMZQfjOGCzenzNbJSWmLF+5dKQOCbiwOToxVvyBHJOTv
 fAd8ILYsPzzA97I9BTGK10FAKueuVZAahqnLkPWPE+fZID+C61vmbQfFpFp7X9UANTNFpABy63R
 uvCR+L2HtrvwXO1yQzgqWLV8LxGUJMR8Do8LYduJorYkt7OBMcCwHLP1jgMvabtg1FhXN+pF2Eo
 MO8N+PRD2cBNvUbp56DGxAkxNi5t9rAtHYtRLwrakOWwmvuUOJrBMB3ORXdZ75BSl4++rpskGJC
 4OMu74XSEcHYXmG3w+toDvhiYEs6kxIQhrPqYUr6ekCmJq6RATekdXGITcn0wEq09YvFWsLnHN4
 PTVzLrhR6uDhcASchGw==
X-Proofpoint-GUID: _zcMZEaWR1ccVvGANlvtJbHz7sxLxAu2
X-Proofpoint-ORIG-GUID: _zcMZEaWR1ccVvGANlvtJbHz7sxLxAu2
X-Authority-Analysis: v=2.4 cv=LesxKzfi c=1 sm=1 tr=0 ts=69835fad cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8
 a=ciOewYurfqE_QU1RCzEA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602040113
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70219-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 1FADFE8138
X-Rspamd-Action: no action

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds the boilerplate and functions for the allocation and
deallocation of DAT tables.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/Makefile     |   1 +
 arch/s390/kvm/dat.c        | 103 +++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h        |  77 +++++++++++++++++++++++++++
 arch/s390/mm/page-states.c |   1 +
 4 files changed, 182 insertions(+)
 create mode 100644 arch/s390/kvm/dat.c

diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 9a723c48b05a..84315d2f75fb 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -9,6 +9,7 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
 kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o gmap-vsie.o
+kvm-y += dat.o
 
 kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
new file mode 100644
index 000000000000..c324a27f379f
--- /dev/null
+++ b/arch/s390/kvm/dat.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  KVM guest address space mapping code
+ *
+ *    Copyright IBM Corp. 2007, 2020, 2024
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
+ *		 Martin Schwidefsky <schwidefsky@de.ibm.com>
+ *		 David Hildenbrand <david@redhat.com>
+ *		 Janosch Frank <frankja@linux.ibm.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/pagewalk.h>
+#include <linux/swap.h>
+#include <linux/smp.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/swapops.h>
+#include <linux/ksm.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/pgtable.h>
+#include <linux/kvm_types.h>
+#include <linux/kvm_host.h>
+#include <linux/pgalloc.h>
+
+#include <asm/page-states.h>
+#include <asm/tlb.h>
+#include "dat.h"
+
+int kvm_s390_mmu_cache_topup(struct kvm_s390_mmu_cache *mc)
+{
+	void *o;
+
+	for ( ; mc->n_crsts < KVM_S390_MMU_CACHE_N_CRSTS; mc->n_crsts++) {
+		o = (void *)__get_free_pages(GFP_KERNEL_ACCOUNT | __GFP_COMP, CRST_ALLOC_ORDER);
+		if (!o)
+			return -ENOMEM;
+		mc->crsts[mc->n_crsts] = o;
+	}
+	for ( ; mc->n_pts < KVM_S390_MMU_CACHE_N_PTS; mc->n_pts++) {
+		o = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+		if (!o)
+			return -ENOMEM;
+		mc->pts[mc->n_pts] = o;
+	}
+	for ( ; mc->n_rmaps < KVM_S390_MMU_CACHE_N_RMAPS; mc->n_rmaps++) {
+		o = kzalloc(sizeof(*mc->rmaps[0]), GFP_KERNEL_ACCOUNT);
+		if (!o)
+			return -ENOMEM;
+		mc->rmaps[mc->n_rmaps] = o;
+	}
+	return 0;
+}
+
+static inline struct page_table *dat_alloc_pt_noinit(struct kvm_s390_mmu_cache *mc)
+{
+	struct page_table *res;
+
+	res = kvm_s390_mmu_cache_alloc_pt(mc);
+	if (res)
+		__arch_set_page_dat(res, 1);
+	return res;
+}
+
+static inline struct crst_table *dat_alloc_crst_noinit(struct kvm_s390_mmu_cache *mc)
+{
+	struct crst_table *res;
+
+	res = kvm_s390_mmu_cache_alloc_crst(mc);
+	if (res)
+		__arch_set_page_dat(res, 1UL << CRST_ALLOC_ORDER);
+	return res;
+}
+
+struct crst_table *dat_alloc_crst_sleepable(unsigned long init)
+{
+	struct page *page;
+	void *virt;
+
+	page = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_COMP, CRST_ALLOC_ORDER);
+	if (!page)
+		return NULL;
+	virt = page_to_virt(page);
+	__arch_set_page_dat(virt, 1UL << CRST_ALLOC_ORDER);
+	crst_table_init(virt, init);
+	return virt;
+}
+
+void dat_free_level(struct crst_table *table, bool owns_ptes)
+{
+	unsigned int i;
+
+	for (i = 0; i < _CRST_ENTRIES; i++) {
+		if (table->crstes[i].h.fc || table->crstes[i].h.i)
+			continue;
+		if (!is_pmd(table->crstes[i]))
+			dat_free_level(dereference_crste(table->crstes[i]), owns_ptes);
+		else if (owns_ptes)
+			dat_free_pt(dereference_pmd(table->crstes[i].pmd));
+	}
+	dat_free_crst(table);
+}
diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
index d5e1a45813bc..a053f0d49bae 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -418,6 +418,46 @@ struct vsie_rmap {
 
 static_assert(sizeof(struct vsie_rmap) == 2 * sizeof(long));
 
+#define KVM_S390_MMU_CACHE_N_CRSTS	6
+#define KVM_S390_MMU_CACHE_N_PTS	2
+#define KVM_S390_MMU_CACHE_N_RMAPS	16
+struct kvm_s390_mmu_cache {
+	void *crsts[KVM_S390_MMU_CACHE_N_CRSTS];
+	void *pts[KVM_S390_MMU_CACHE_N_PTS];
+	void *rmaps[KVM_S390_MMU_CACHE_N_RMAPS];
+	short int n_crsts;
+	short int n_pts;
+	short int n_rmaps;
+};
+
+void dat_free_level(struct crst_table *table, bool owns_ptes);
+struct crst_table *dat_alloc_crst_sleepable(unsigned long init);
+
+int kvm_s390_mmu_cache_topup(struct kvm_s390_mmu_cache *mc);
+
+#define GFP_KVM_S390_MMU_CACHE (GFP_ATOMIC | __GFP_ACCOUNT | __GFP_NOWARN)
+
+static inline struct page_table *kvm_s390_mmu_cache_alloc_pt(struct kvm_s390_mmu_cache *mc)
+{
+	if (mc->n_pts)
+		return mc->pts[--mc->n_pts];
+	return (void *)__get_free_page(GFP_KVM_S390_MMU_CACHE);
+}
+
+static inline struct crst_table *kvm_s390_mmu_cache_alloc_crst(struct kvm_s390_mmu_cache *mc)
+{
+	if (mc->n_crsts)
+		return mc->crsts[--mc->n_crsts];
+	return (void *)__get_free_pages(GFP_KVM_S390_MMU_CACHE | __GFP_COMP, CRST_ALLOC_ORDER);
+}
+
+static inline struct vsie_rmap *kvm_s390_mmu_cache_alloc_rmap(struct kvm_s390_mmu_cache *mc)
+{
+	if (mc->n_rmaps)
+		return mc->rmaps[--mc->n_rmaps];
+	return kzalloc(sizeof(struct vsie_rmap), GFP_KVM_S390_MMU_CACHE);
+}
+
 static inline struct crst_table *crste_table_start(union crste *crstep)
 {
 	return (struct crst_table *)ALIGN_DOWN((unsigned long)crstep, _CRST_TABLE_SIZE);
@@ -717,4 +757,41 @@ static inline void pgste_set_unlock(union pte *ptep, union pgste pgste)
 	WRITE_ONCE(*pgste_of(ptep), pgste);
 }
 
+static inline void dat_free_pt(struct page_table *pt)
+{
+	free_page((unsigned long)pt);
+}
+
+static inline void _dat_free_crst(struct crst_table *table)
+{
+	free_pages((unsigned long)table, CRST_ALLOC_ORDER);
+}
+
+#define dat_free_crst(x) _dat_free_crst(_CRSTP(x))
+
+static inline void kvm_s390_free_mmu_cache(struct kvm_s390_mmu_cache *mc)
+{
+	if (!mc)
+		return;
+	while (mc->n_pts)
+		dat_free_pt(mc->pts[--mc->n_pts]);
+	while (mc->n_crsts)
+		_dat_free_crst(mc->crsts[--mc->n_crsts]);
+	while (mc->n_rmaps)
+		kfree(mc->rmaps[--mc->n_rmaps]);
+	kfree(mc);
+}
+
+DEFINE_FREE(kvm_s390_mmu_cache, struct kvm_s390_mmu_cache *, if (_T) kvm_s390_free_mmu_cache(_T))
+
+static inline struct kvm_s390_mmu_cache *kvm_s390_new_mmu_cache(void)
+{
+	struct kvm_s390_mmu_cache *mc __free(kvm_s390_mmu_cache) = NULL;
+
+	mc = kzalloc(sizeof(*mc), GFP_KERNEL_ACCOUNT);
+	if (mc && !kvm_s390_mmu_cache_topup(mc))
+		return_ptr(mc);
+	return NULL;
+}
+
 #endif /* __KVM_S390_DAT_H */
diff --git a/arch/s390/mm/page-states.c b/arch/s390/mm/page-states.c
index 01f9b39e65f5..5bee173db72e 100644
--- a/arch/s390/mm/page-states.c
+++ b/arch/s390/mm/page-states.c
@@ -13,6 +13,7 @@
 #include <asm/page.h>
 
 int __bootdata_preserved(cmma_flag);
+EXPORT_SYMBOL(cmma_flag);
 
 void arch_free_page(struct page *page, int order)
 {
-- 
2.52.0


