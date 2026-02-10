Return-Path: <kvm+bounces-70742-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SE5/En5Qi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70742-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:36:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 813BF11C8E0
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:36:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B12E03004410
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00EC13815FE;
	Tue, 10 Feb 2026 15:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LF0v5c/s"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16C13876DE;
	Tue, 10 Feb 2026 15:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737677; cv=none; b=N8tYBebu2/CTBXzpVoyYpIiyZf1e5bqJyjWM2oYd2fnnjK85HtyBykFrBI/aNKnLX8wdZbaTq64vAEifzOgggRVZbVLVUSbLpIWSe1st8PcPdl0R1OfeB48cEf/jDdwwf/Sc2C/lClaZ00ycKNP174bR+8Y9csMlk7IdJjn2D9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737677; c=relaxed/simple;
	bh=JKojCQvri4Hh5DPjQNQmzpTzSfGXmx0a8lmsDtfaVEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIvkTyMbDvmWr16k3abVTCum8YuvZD57R34PjT0c62WUystKBaVWMnRQ/Y2pBKA7bDxdhgqea4QLx9RqtEMhL+H0o/iZEIJp5kBth8jsNdK7B8IynHsNOuZOF5kuN0VgkUJgJF3fpR1fBcM5jLKT7wKc8VZcV3NndOFWdcFSi9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LF0v5c/s; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A9U6iP169452;
	Tue, 10 Feb 2026 15:34:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=8Ka7ANGKUYlYsC2q2
	0si1LZvoXzOb0Lr13OYaU8q55Q=; b=LF0v5c/sTuZ0Nxy6zJm36f5P8MF5NMmgZ
	5jNxRRc2rtINKGgCjceyfGGOAMa14d8bHBFPiiH7xSWqv18GeVke3JHVyh/ZzcV1
	h3PNkgG4q6SqZ8+YI8MwKbO7bD8L/BK/9oCchO/ziPipN2mPsvYBCcDAu4AQuSk9
	ZLLiGUgzAdKaQvVjfF8JwcpXW0L4A6KXi5408hcKYMsZtABs93RYtqRmls/kg705
	W4f7AE3rgfWcm0Q3XV/FnJScfvfS6lz2zN/i4vvVWyV+7VXsfBMmoKhJv3A+MlmQ
	IGlhCWFNUfOQbZ6adItZav5vn1KLZOLT+avb6XrUFPTh1KK/BsTGw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696w4x9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:31 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AEtiOa012996;
	Tue, 10 Feb 2026 15:34:30 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6h7k9rg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYQYj39190986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CBD820040;
	Tue, 10 Feb 2026 15:34:26 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F4A92004B;
	Tue, 10 Feb 2026 15:34:25 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:25 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 14/36] KVM: s390: KVM page table management functions: allocation
Date: Tue, 10 Feb 2026 16:33:55 +0100
Message-ID: <20260210153417.77403-15-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260210153417.77403-1-imbrenda@linux.ibm.com>
References: <20260210153417.77403-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=YeCwJgRf c=1 sm=1 tr=0 ts=698b5007 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8
 a=8uwlcYluBythuep4mtsA:9
X-Proofpoint-GUID: 7enHlgfFF6t2Tdle9F-0jhoGA73j7hPd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX0zlZCOV3RdrP
 QhOLoL6dMGuQZDC91zZbsX+wWzjSUDj5IkjA8mKIHEJUnBeSUpzTWGgupUJ81ceSWDiBtS64F3x
 DgVPP2xOOhu5gOXS9YLZ88HweplsSZYV1GX59IFWJRNSbdUCd/GKe+oCdx/pLYs9+py8v7lErZ+
 PW9WeJrR+ukxcB0y6OEjMQ1/Vqle/Lb0emVJyGEXQZluG7Q9Z1nTShUjnaeZIyMwVAi9wisZGWy
 B/RpGT5SFNK/zWBmPRkEjfEAOfAQ6uE2jodDNrU5+HEmWyc6jCOgqP4usGwLm6wMeMJEMFRFkPm
 DIHUZjgRxi1V1T19UFzEVEN5qAi0JSo/vovBQPWbipjNjLzPpAdVHtyT3Imw30OdmTWUdZd5GSi
 BwQROSfM2J5NtqH59p6TJZtrj8xgrd4Azr9PNXgj8YXAhwkYMiqYd3qsxUC6P94Ma++naLdGHtC
 zq6ZoSw9zYCHJRHVyCA==
X-Proofpoint-ORIG-GUID: 7enHlgfFF6t2Tdle9F-0jhoGA73j7hPd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70742-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 813BF11C8E0
X-Rspamd-Action: no action

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds the boilerplate and functions for the allocation and
deallocation of DAT tables.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
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
2.53.0


