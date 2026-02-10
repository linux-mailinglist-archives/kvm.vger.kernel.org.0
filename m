Return-Path: <kvm+bounces-70764-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MN2xLFNRi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70764-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:40:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 045A211CA1A
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:39:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 087B53069266
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F8438E5F0;
	Tue, 10 Feb 2026 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="g/A0m9mX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE1638B7CC;
	Tue, 10 Feb 2026 15:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737696; cv=none; b=sFqUmA+JnkKeNnF6Cx2ckPs+QLGyrqVnH+g9PSr9L+nkfzmd2z2F+XQP2Wo0sT9jT6P9yc6yf3wFomJUQLfkYSvLHqQJxAL5yzgLOykEPih7Sr8WDmwXN2WCoFum/U8+8SsluapHqOE8fJ6r5LHNcW5O3EP9yBIhKEAkCQzqlJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737696; c=relaxed/simple;
	bh=2tryDIq73yRqVKzA/bltIywZJuOEKbcwUG/ZTtg5WB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1wi2te+7RldoxQAerYieFvX84GppW9kHeJGdno1jbYYSnTERFccNVbpvk0RcnFuIzeSYNWd3RJdPec/AE+3qt6UlYqz5c743Ui5XvpNhr4S3kY7pElZ60uvkguOWzbM78hFbcgy4u/b+uzD6hjR2ykr0pm6YNkrEcYx0xWB+Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=g/A0m9mX; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A8prxd163318;
	Tue, 10 Feb 2026 15:34:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=EWkfNk4OSw6mzkGeZ
	ByDjXvokKM0c3PJ8ZRTpjDgsc8=; b=g/A0m9mXu+2coC1utVZyEMQqlMpiP5V4F
	Z2CXHL+VK8dDes/sNDrAQ+f7y0vGc/LoO7Lqr5wqekAlWsKAEAosCnhVyOv0Ff9V
	uhi68yA+YxVSh4StA7/ICB5oO58C6cJ11HGnLVAlcevZng9Y1pfrZ6z+IsdZJV5T
	PdelHi6TqFKZK5VxlXQS8zh0yJQId7XaOTj1Ku6CF46LAfnoVOWSvgph1CC2oQ7l
	Knz0CuLzOTeOc/HxfLsXhd/tXYwu1EWd+vC1+trAwWyHhr3SK5lcW/8pOtLr7xbB
	bQ21dY0whqORH+FoB96ryvTP286JjP9H8hCMYv0NsWcC2IsV7C3UA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696ucybx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:35 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AFHf9h012611;
	Tue, 10 Feb 2026 15:34:34 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6h7k9rg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYTB915860150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D36C20040;
	Tue, 10 Feb 2026 15:34:29 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0EAFF20043;
	Tue, 10 Feb 2026 15:34:29 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:28 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 20/36] KVM: s390: New gmap code
Date: Tue, 10 Feb 2026 16:34:01 +0100
Message-ID: <20260210153417.77403-21-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698b500b cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8
 a=EoYcdVckXceJWVHm2r4A:9 a=yDVgLJAh9znUKtHr:21
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX5YNuClYHXJw9
 oeGZcg/gIL+Ame21OeGGivVb7VI6h4fONEozmXHgIJWVzJEtsmjITu1GQtSyduR3ah+SUhq5dUR
 ddgp09ctfMsl3vpVoG18kNr4HqOKtF8/Iue0F8fCoPYdwyAiCY6eTRwBZ5vhIBweIyGXoPCtenJ
 0PNRFf0TgpTWIl8hNo0GsoG7ZxuOKp9a94OJNXtJpW5TcIor/igeq/Rvf+SgqMFGxPMm4cFeBgs
 LMa5T7tPyqTdJB5BtzEcE7G28BDJy1IWRIfiRGwEwFoUAvi3LnLg9VdtWQP1yUtHNPxjq6hRWM4
 GRLoEMKmSnbz2LyQhnJ2YWqACcYeluvzj8A4vbXfFa+zhrp6VqdLODZnLfl0vTssfReQ7Tx7PHx
 skDl6/MwzIE9DoPDGNxB2EEhzfO4kJD72l3tsODzqjtISVWW2hC9f21/+HhDByzPArzqqvlDgE0
 2sXT+KfEw7Zp5LFdamA==
X-Proofpoint-ORIG-GUID: jGFuQNb4b8U7YxvcfGuHcWDgxUUDoQcf
X-Proofpoint-GUID: jGFuQNb4b8U7YxvcfGuHcWDgxUUDoQcf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70764-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[fc1.sd:url,s.sd:url,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,fc0.tl:url,linux.ibm.com:mid,h.tt:url];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 045A211CA1A
X-Rspamd-Action: no action

New gmap (guest map) code. This new gmap code will only be used by KVM.

This will replace the existing gmap.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/Makefile |    2 +-
 arch/s390/kvm/gmap.c   | 1165 ++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/gmap.h   |  244 +++++++++
 3 files changed, 1410 insertions(+), 1 deletion(-)
 create mode 100644 arch/s390/kvm/gmap.c
 create mode 100644 arch/s390/kvm/gmap.h

diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 84315d2f75fb..21088265402c 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -9,7 +9,7 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
 kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o gmap-vsie.o
-kvm-y += dat.o
+kvm-y += dat.o gmap.o
 
 kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
new file mode 100644
index 000000000000..5736145ef53a
--- /dev/null
+++ b/arch/s390/kvm/gmap.c
@@ -0,0 +1,1165 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Guest memory management for KVM/s390
+ *
+ * Copyright IBM Corp. 2008, 2020, 2024
+ *
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
+ *               Martin Schwidefsky <schwidefsky@de.ibm.com>
+ *               David Hildenbrand <david@redhat.com>
+ *               Janosch Frank <frankja@linux.ibm.com>
+ */
+
+#include <linux/compiler.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/pgtable.h>
+#include <linux/pagemap.h>
+#include <asm/lowcore.h>
+#include <asm/uv.h>
+#include <asm/gmap_helpers.h>
+
+#include "dat.h"
+#include "gmap.h"
+#include "kvm-s390.h"
+
+static inline bool kvm_s390_is_in_sie(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.sie_block->prog0c & PROG_IN_SIE;
+}
+
+static int gmap_limit_to_type(gfn_t limit)
+{
+	if (!limit)
+		return TABLE_TYPE_REGION1;
+	if (limit <= _REGION3_SIZE >> PAGE_SHIFT)
+		return TABLE_TYPE_SEGMENT;
+	if (limit <= _REGION2_SIZE >> PAGE_SHIFT)
+		return TABLE_TYPE_REGION3;
+	if (limit <= _REGION1_SIZE >> PAGE_SHIFT)
+		return TABLE_TYPE_REGION2;
+	return TABLE_TYPE_REGION1;
+}
+
+/**
+ * gmap_new() - Allocate and initialize a guest address space.
+ * @kvm: The kvm owning the guest.
+ * @limit: Maximum address of the gmap address space.
+ *
+ * Return: A guest address space structure.
+ */
+struct gmap *gmap_new(struct kvm *kvm, gfn_t limit)
+{
+	struct crst_table *table;
+	struct gmap *gmap;
+	int type;
+
+	type = gmap_limit_to_type(limit);
+
+	gmap = kzalloc(sizeof(*gmap), GFP_KERNEL_ACCOUNT);
+	if (!gmap)
+		return NULL;
+	INIT_LIST_HEAD(&gmap->children);
+	INIT_LIST_HEAD(&gmap->list);
+	INIT_LIST_HEAD(&gmap->scb_users);
+	INIT_RADIX_TREE(&gmap->host_to_rmap, GFP_KVM_S390_MMU_CACHE);
+	spin_lock_init(&gmap->children_lock);
+	spin_lock_init(&gmap->host_to_rmap_lock);
+	refcount_set(&gmap->refcount, 1);
+
+	table = dat_alloc_crst_sleepable(_CRSTE_EMPTY(type).val);
+	if (!table) {
+		kfree(gmap);
+		return NULL;
+	}
+
+	gmap->asce.val = __pa(table);
+	gmap->asce.dt = type;
+	gmap->asce.tl = _ASCE_TABLE_LENGTH;
+	gmap->asce.x = 1;
+	gmap->asce.p = 1;
+	gmap->asce.s = 1;
+	gmap->kvm = kvm;
+	set_bit(GMAP_FLAG_OWNS_PAGETABLES, &gmap->flags);
+
+	return gmap;
+}
+
+static void gmap_add_child(struct gmap *parent, struct gmap *child)
+{
+	KVM_BUG_ON(is_ucontrol(parent) && parent->parent, parent->kvm);
+	KVM_BUG_ON(is_ucontrol(parent) && !owns_page_tables(parent), parent->kvm);
+	KVM_BUG_ON(!refcount_read(&child->refcount), parent->kvm);
+	lockdep_assert_held(&parent->children_lock);
+
+	child->parent = parent;
+
+	if (is_ucontrol(parent))
+		set_bit(GMAP_FLAG_IS_UCONTROL, &child->flags);
+	else
+		clear_bit(GMAP_FLAG_IS_UCONTROL, &child->flags);
+
+	if (test_bit(GMAP_FLAG_ALLOW_HPAGE_1M, &parent->flags))
+		set_bit(GMAP_FLAG_ALLOW_HPAGE_1M, &child->flags);
+	else
+		clear_bit(GMAP_FLAG_ALLOW_HPAGE_1M, &child->flags);
+
+	if (kvm_is_ucontrol(parent->kvm))
+		clear_bit(GMAP_FLAG_OWNS_PAGETABLES, &child->flags);
+	list_add(&child->list, &parent->children);
+}
+
+struct gmap *gmap_new_child(struct gmap *parent, gfn_t limit)
+{
+	struct gmap *res;
+
+	lockdep_assert_not_held(&parent->children_lock);
+	res = gmap_new(parent->kvm, limit);
+	if (res) {
+		scoped_guard(spinlock, &parent->children_lock)
+			gmap_add_child(parent, res);
+	}
+	return res;
+}
+
+int gmap_set_limit(struct gmap *gmap, gfn_t limit)
+{
+	struct kvm_s390_mmu_cache *mc;
+	int rc, type;
+
+	type = gmap_limit_to_type(limit);
+
+	mc = kvm_s390_new_mmu_cache();
+	if (!mc)
+		return -ENOMEM;
+
+	do {
+		rc = kvm_s390_mmu_cache_topup(mc);
+		if (rc)
+			return rc;
+		scoped_guard(write_lock, &gmap->kvm->mmu_lock)
+			rc = dat_set_asce_limit(mc, &gmap->asce, type);
+	} while (rc == -ENOMEM);
+
+	kvm_s390_free_mmu_cache(mc);
+	return 0;
+}
+
+static void gmap_rmap_radix_tree_free(struct radix_tree_root *root)
+{
+	struct vsie_rmap *rmap, *rnext, *head;
+	struct radix_tree_iter iter;
+	unsigned long indices[16];
+	unsigned long index;
+	void __rcu **slot;
+	int i, nr;
+
+	/* A radix tree is freed by deleting all of its entries */
+	index = 0;
+	do {
+		nr = 0;
+		radix_tree_for_each_slot(slot, root, &iter, index) {
+			indices[nr] = iter.index;
+			if (++nr == 16)
+				break;
+		}
+		for (i = 0; i < nr; i++) {
+			index = indices[i];
+			head = radix_tree_delete(root, index);
+			gmap_for_each_rmap_safe(rmap, rnext, head)
+				kfree(rmap);
+		}
+	} while (nr > 0);
+}
+
+void gmap_remove_child(struct gmap *child)
+{
+	if (KVM_BUG_ON(!child->parent, child->kvm))
+		return;
+	lockdep_assert_held(&child->parent->children_lock);
+
+	list_del(&child->list);
+	child->parent = NULL;
+}
+
+/**
+ * gmap_dispose() - Remove and free a guest address space and its children.
+ * @gmap: Pointer to the guest address space structure.
+ */
+void gmap_dispose(struct gmap *gmap)
+{
+	/* The gmap must have been removed from the parent beforehands */
+	KVM_BUG_ON(gmap->parent, gmap->kvm);
+	/* All children of this gmap must have been removed beforehands */
+	KVM_BUG_ON(!list_empty(&gmap->children), gmap->kvm);
+	/* No VSIE shadow block is allowed to use this gmap */
+	KVM_BUG_ON(!list_empty(&gmap->scb_users), gmap->kvm);
+	/* The ASCE must be valid */
+	KVM_BUG_ON(!gmap->asce.val, gmap->kvm);
+	/* The refcount must be 0 */
+	KVM_BUG_ON(refcount_read(&gmap->refcount), gmap->kvm);
+
+	/* Flush tlb of all gmaps */
+	asce_flush_tlb(gmap->asce);
+
+	/* Free all DAT tables. */
+	dat_free_level(dereference_asce(gmap->asce), owns_page_tables(gmap));
+
+	/* Free additional data for a shadow gmap */
+	if (is_shadow(gmap))
+		gmap_rmap_radix_tree_free(&gmap->host_to_rmap);
+
+	kfree(gmap);
+}
+
+/**
+ * s390_replace_asce() - Try to replace the current ASCE of a gmap with a copy.
+ * @gmap: The gmap whose ASCE needs to be replaced.
+ *
+ * If the ASCE is a SEGMENT type then this function will return -EINVAL,
+ * otherwise the pointers in the host_to_guest radix tree will keep pointing
+ * to the wrong pages, causing use-after-free and memory corruption.
+ * If the allocation of the new top level page table fails, the ASCE is not
+ * replaced.
+ * In any case, the old ASCE is always removed from the gmap CRST list.
+ * Therefore the caller has to make sure to save a pointer to it
+ * beforehand, unless a leak is actually intended.
+ *
+ * Return: 0 in case of success, -EINVAL if the ASCE is segment type ASCE,
+ *         -ENOMEM if runinng out of memory.
+ */
+int s390_replace_asce(struct gmap *gmap)
+{
+	struct crst_table *table;
+	union asce asce;
+
+	/* Replacing segment type ASCEs would cause serious issues */
+	if (gmap->asce.dt == ASCE_TYPE_SEGMENT)
+		return -EINVAL;
+
+	table = dat_alloc_crst_sleepable(0);
+	if (!table)
+		return -ENOMEM;
+	memcpy(table, dereference_asce(gmap->asce), sizeof(*table));
+
+	/* Set new table origin while preserving existing ASCE control bits */
+	asce = gmap->asce;
+	asce.rsto = virt_to_pfn(table);
+	WRITE_ONCE(gmap->asce, asce);
+
+	return 0;
+}
+
+bool _gmap_unmap_prefix(struct gmap *gmap, gfn_t gfn, gfn_t end, bool hint)
+{
+	struct kvm *kvm = gmap->kvm;
+	struct kvm_vcpu *vcpu;
+	gfn_t prefix_gfn;
+	unsigned long i;
+
+	if (is_shadow(gmap))
+		return false;
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		/* Match against both prefix pages */
+		prefix_gfn = gpa_to_gfn(kvm_s390_get_prefix(vcpu));
+		if (prefix_gfn < end && gfn <= prefix_gfn + 1) {
+			if (hint && kvm_s390_is_in_sie(vcpu))
+				return false;
+			VCPU_EVENT(vcpu, 2, "gmap notifier for %llx-%llx",
+				   gfn_to_gpa(gfn), gfn_to_gpa(end));
+			kvm_s390_sync_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu);
+		}
+	}
+	return true;
+}
+
+struct clear_young_pte_priv {
+	struct gmap *gmap;
+	bool young;
+};
+
+static long gmap_clear_young_pte(union pte *ptep, gfn_t gfn, gfn_t end, struct dat_walk *walk)
+{
+	struct clear_young_pte_priv *p = walk->priv;
+	union pgste pgste;
+	union pte pte, new;
+
+	pte = READ_ONCE(*ptep);
+
+	if (!pte.s.pr || (!pte.s.y && pte.h.i))
+		return 0;
+
+	pgste = pgste_get_lock(ptep);
+	if (!pgste.prefix_notif || gmap_mkold_prefix(p->gmap, gfn, end)) {
+		new = pte;
+		new.h.i = 1;
+		new.s.y = 0;
+		if ((new.s.d || !new.h.p) && !new.s.s)
+			folio_set_dirty(pfn_folio(pte.h.pfra));
+		new.s.d = 0;
+		new.h.p = 1;
+
+		pgste.prefix_notif = 0;
+		pgste = __dat_ptep_xchg(ptep, pgste, new, gfn, walk->asce, uses_skeys(p->gmap));
+	}
+	p->young = 1;
+	pgste_set_unlock(ptep, pgste);
+	return 0;
+}
+
+static long gmap_clear_young_crste(union crste *crstep, gfn_t gfn, gfn_t end, struct dat_walk *walk)
+{
+	struct clear_young_pte_priv *priv = walk->priv;
+	union crste crste, new;
+
+	crste = READ_ONCE(*crstep);
+
+	if (!crste.h.fc)
+		return 0;
+	if (!crste.s.fc1.y && crste.h.i)
+		return 0;
+	if (!crste_prefix(crste) || gmap_mkold_prefix(priv->gmap, gfn, end)) {
+		new = crste;
+		new.h.i = 1;
+		new.s.fc1.y = 0;
+		new.s.fc1.prefix_notif = 0;
+		if (new.s.fc1.d || !new.h.p)
+			folio_set_dirty(phys_to_folio(crste_origin_large(crste)));
+		new.s.fc1.d = 0;
+		new.h.p = 1;
+		dat_crstep_xchg(crstep, new, gfn, walk->asce);
+	}
+	priv->young = 1;
+	return 0;
+}
+
+/**
+ * gmap_age_gfn() - Clear young.
+ * @gmap: The guest gmap.
+ * @start: The first gfn to test.
+ * @end: The gfn after the last one to test.
+ *
+ * Context: Called with the kvm mmu write lock held.
+ * Return: 1 if any page in the given range was young, otherwise 0.
+ */
+bool gmap_age_gfn(struct gmap *gmap, gfn_t start, gfn_t end)
+{
+	const struct dat_walk_ops ops = {
+		.pte_entry = gmap_clear_young_pte,
+		.pmd_entry = gmap_clear_young_crste,
+		.pud_entry = gmap_clear_young_crste,
+	};
+	struct clear_young_pte_priv priv = {
+		.gmap = gmap,
+		.young = false,
+	};
+
+	_dat_walk_gfn_range(start, end, gmap->asce, &ops, 0, &priv);
+
+	return priv.young;
+}
+
+struct gmap_unmap_priv {
+	struct gmap *gmap;
+	struct kvm_memory_slot *slot;
+};
+
+static long _gmap_unmap_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *w)
+{
+	struct gmap_unmap_priv *priv = w->priv;
+	struct folio *folio = NULL;
+	unsigned long vmaddr;
+	union pgste pgste;
+
+	pgste = pgste_get_lock(ptep);
+	if (ptep->s.pr && pgste.usage == PGSTE_GPS_USAGE_UNUSED) {
+		vmaddr = __gfn_to_hva_memslot(priv->slot, gfn);
+		gmap_helper_try_set_pte_unused(priv->gmap->kvm->mm, vmaddr);
+	}
+	if (ptep->s.pr && test_bit(GMAP_FLAG_EXPORT_ON_UNMAP, &priv->gmap->flags))
+		folio = pfn_folio(ptep->h.pfra);
+	pgste = gmap_ptep_xchg(priv->gmap, ptep, _PTE_EMPTY, pgste, gfn);
+	pgste_set_unlock(ptep, pgste);
+	if (folio)
+		uv_convert_from_secure_folio(folio);
+
+	return 0;
+}
+
+static long _gmap_unmap_crste(union crste *crstep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	struct gmap_unmap_priv *priv = walk->priv;
+	struct folio *folio = NULL;
+
+	if (crstep->h.fc) {
+		if (crstep->s.fc1.pr && test_bit(GMAP_FLAG_EXPORT_ON_UNMAP, &priv->gmap->flags))
+			folio = phys_to_folio(crste_origin_large(*crstep));
+		gmap_crstep_xchg(priv->gmap, crstep, _CRSTE_EMPTY(crstep->h.tt), gfn);
+		if (folio)
+			uv_convert_from_secure_folio(folio);
+	}
+
+	return 0;
+}
+
+/**
+ * gmap_unmap_gfn_range() - Unmap a range of guest addresses.
+ * @gmap: The gmap to act on.
+ * @slot: The memslot in which the range is located.
+ * @start: The first gfn to unmap.
+ * @end: The gfn after the last one to unmap.
+ *
+ * Context: Called with the kvm mmu write lock held.
+ * Return: false
+ */
+bool gmap_unmap_gfn_range(struct gmap *gmap, struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
+{
+	const struct dat_walk_ops ops = {
+		.pte_entry = _gmap_unmap_pte,
+		.pmd_entry = _gmap_unmap_crste,
+		.pud_entry = _gmap_unmap_crste,
+	};
+	struct gmap_unmap_priv priv = {
+		.gmap = gmap,
+		.slot = slot,
+	};
+
+	lockdep_assert_held_write(&gmap->kvm->mmu_lock);
+
+	_dat_walk_gfn_range(start, end, gmap->asce, &ops, 0, &priv);
+	return false;
+}
+
+static union pgste __pte_test_and_clear_softdirty(union pte *ptep, union pgste pgste, gfn_t gfn,
+						  struct gmap *gmap)
+{
+	union pte pte = READ_ONCE(*ptep);
+
+	if (!pte.s.pr || (pte.h.p && !pte.s.sd))
+		return pgste;
+
+	/*
+	 * If this page contains one or more prefixes of vCPUS that are currently
+	 * running, do not reset the protection, leave it marked as dirty.
+	 */
+	if (!pgste.prefix_notif || gmap_mkold_prefix(gmap, gfn, gfn + 1)) {
+		pte.h.p = 1;
+		pte.s.sd = 0;
+		pgste = gmap_ptep_xchg(gmap, ptep, pte, pgste, gfn);
+	}
+
+	mark_page_dirty(gmap->kvm, gfn);
+
+	return pgste;
+}
+
+static long _pte_test_and_clear_softdirty(union pte *ptep, gfn_t gfn, gfn_t end,
+					  struct dat_walk *walk)
+{
+	struct gmap *gmap = walk->priv;
+	union pgste pgste;
+
+	pgste = pgste_get_lock(ptep);
+	pgste = __pte_test_and_clear_softdirty(ptep, pgste, gfn, gmap);
+	pgste_set_unlock(ptep, pgste);
+	return 0;
+}
+
+static long _crste_test_and_clear_softdirty(union crste *table, gfn_t gfn, gfn_t end,
+					    struct dat_walk *walk)
+{
+	struct gmap *gmap = walk->priv;
+	union crste crste, new;
+
+	if (fatal_signal_pending(current))
+		return 1;
+	crste = READ_ONCE(*table);
+	if (!crste.h.fc)
+		return 0;
+	if (crste.h.p && !crste.s.fc1.sd)
+		return 0;
+
+	/*
+	 * If this large page contains one or more prefixes of vCPUs that are
+	 * currently running, do not reset the protection, leave it marked as
+	 * dirty.
+	 */
+	if (!crste.s.fc1.prefix_notif || gmap_mkold_prefix(gmap, gfn, end)) {
+		new = crste;
+		new.h.p = 1;
+		new.s.fc1.sd = 0;
+		gmap_crstep_xchg(gmap, table, new, gfn);
+	}
+
+	for ( ; gfn < end; gfn++)
+		mark_page_dirty(gmap->kvm, gfn);
+
+	return 0;
+}
+
+void gmap_sync_dirty_log(struct gmap *gmap, gfn_t start, gfn_t end)
+{
+	const struct dat_walk_ops walk_ops = {
+		.pte_entry = _pte_test_and_clear_softdirty,
+		.pmd_entry = _crste_test_and_clear_softdirty,
+		.pud_entry = _crste_test_and_clear_softdirty,
+	};
+
+	lockdep_assert_held(&gmap->kvm->mmu_lock);
+
+	_dat_walk_gfn_range(start, end, gmap->asce, &walk_ops, 0, gmap);
+}
+
+static int gmap_handle_minor_crste_fault(union asce asce, struct guest_fault *f)
+{
+	union crste newcrste, oldcrste = READ_ONCE(*f->crstep);
+
+	/* Somehow the crste is not large anymore, let the slow path deal with it. */
+	if (!oldcrste.h.fc)
+		return 1;
+
+	f->pfn = PHYS_PFN(large_crste_to_phys(oldcrste, f->gfn));
+	f->writable = oldcrste.s.fc1.w;
+
+	/* Appropriate permissions already (race with another handler), nothing to do. */
+	if (!oldcrste.h.i && !(f->write_attempt && oldcrste.h.p))
+		return 0;
+
+	if (!f->write_attempt || oldcrste.s.fc1.w) {
+		f->write_attempt |= oldcrste.s.fc1.w && oldcrste.s.fc1.d;
+		newcrste = oldcrste;
+		newcrste.h.i = 0;
+		newcrste.s.fc1.y = 1;
+		if (f->write_attempt) {
+			newcrste.h.p = 0;
+			newcrste.s.fc1.d = 1;
+			newcrste.s.fc1.sd = 1;
+		}
+		if (!oldcrste.s.fc1.d && newcrste.s.fc1.d)
+			SetPageDirty(phys_to_page(crste_origin_large(newcrste)));
+		/* In case of races, let the slow path deal with it. */
+		return !dat_crstep_xchg_atomic(f->crstep, oldcrste, newcrste, f->gfn, asce);
+	}
+	/* Trying to write on a read-only page, let the slow path deal with it. */
+	return 1;
+}
+
+static int _gmap_handle_minor_pte_fault(struct gmap *gmap, union pgste *pgste,
+					struct guest_fault *f)
+{
+	union pte newpte, oldpte = READ_ONCE(*f->ptep);
+
+	f->pfn = oldpte.h.pfra;
+	f->writable = oldpte.s.w;
+
+	/* Appropriate permissions already (race with another handler), nothing to do. */
+	if (!oldpte.h.i && !(f->write_attempt && oldpte.h.p))
+		return 0;
+	/* Trying to write on a read-only page, let the slow path deal with it. */
+	if (!oldpte.s.pr || (f->write_attempt && !oldpte.s.w))
+		return 1;
+
+	newpte = oldpte;
+	newpte.h.i = 0;
+	newpte.s.y = 1;
+	if (f->write_attempt) {
+		newpte.h.p = 0;
+		newpte.s.d = 1;
+		newpte.s.sd = 1;
+	}
+	if (!oldpte.s.d && newpte.s.d)
+		SetPageDirty(pfn_to_page(newpte.h.pfra));
+	*pgste = gmap_ptep_xchg(gmap, f->ptep, newpte, *pgste, f->gfn);
+
+	return 0;
+}
+
+/**
+ * gmap_try_fixup_minor() -- Try to fixup a minor gmap fault.
+ * @gmap: The gmap whose fault needs to be resolved.
+ * @fault: Describes the fault that is being resolved.
+ *
+ * A minor fault is a fault that can be resolved quickly within gmap.
+ * The page is already mapped, the fault is only due to dirty/young tracking.
+ *
+ * Return: 0 in case of success, < 0 in case of error, > 0 if the fault could
+ *         not be resolved and needs to go through the slow path.
+ */
+int gmap_try_fixup_minor(struct gmap *gmap, struct guest_fault *fault)
+{
+	union pgste pgste;
+	int rc;
+
+	lockdep_assert_held(&gmap->kvm->mmu_lock);
+
+	rc = dat_entry_walk(NULL, fault->gfn, gmap->asce, DAT_WALK_LEAF, TABLE_TYPE_PAGE_TABLE,
+			    &fault->crstep, &fault->ptep);
+	/* If a PTE or a leaf CRSTE could not be reached, slow path. */
+	if (rc)
+		return 1;
+
+	if (fault->ptep) {
+		pgste = pgste_get_lock(fault->ptep);
+		rc = _gmap_handle_minor_pte_fault(gmap, &pgste, fault);
+		if (!rc && fault->callback)
+			fault->callback(fault);
+		pgste_set_unlock(fault->ptep, pgste);
+	} else {
+		rc = gmap_handle_minor_crste_fault(gmap->asce, fault);
+		if (!rc && fault->callback)
+			fault->callback(fault);
+	}
+	return rc;
+}
+
+static inline bool gmap_2g_allowed(struct gmap *gmap, gfn_t gfn)
+{
+	return false;
+}
+
+static inline bool gmap_1m_allowed(struct gmap *gmap, gfn_t gfn)
+{
+	return false;
+}
+
+int gmap_link(struct kvm_s390_mmu_cache *mc, struct gmap *gmap, struct guest_fault *f)
+{
+	unsigned int order;
+	int rc, level;
+
+	lockdep_assert_held(&gmap->kvm->mmu_lock);
+
+	level = TABLE_TYPE_PAGE_TABLE;
+	if (f->page) {
+		order = folio_order(page_folio(f->page));
+		if (order >= get_order(_REGION3_SIZE) && gmap_2g_allowed(gmap, f->gfn))
+			level = TABLE_TYPE_REGION3;
+		else if (order >= get_order(_SEGMENT_SIZE) && gmap_1m_allowed(gmap, f->gfn))
+			level = TABLE_TYPE_SEGMENT;
+	}
+	rc = dat_link(mc, gmap->asce, level, uses_skeys(gmap), f);
+	KVM_BUG_ON(rc == -EINVAL, gmap->kvm);
+	return rc;
+}
+
+static int gmap_ucas_map_one(struct kvm_s390_mmu_cache *mc, struct gmap *gmap,
+			     gfn_t p_gfn, gfn_t c_gfn, bool force_alloc)
+{
+	struct page_table *pt;
+	union crste newcrste;
+	union crste *crstep;
+	union pte *ptep;
+	int rc;
+
+	if (force_alloc)
+		rc = dat_entry_walk(mc, p_gfn, gmap->parent->asce, DAT_WALK_ALLOC,
+				    TABLE_TYPE_PAGE_TABLE, &crstep, &ptep);
+	else
+		rc = dat_entry_walk(mc, p_gfn, gmap->parent->asce, DAT_WALK_ALLOC_CONTINUE,
+				    TABLE_TYPE_SEGMENT, &crstep, &ptep);
+	if (rc)
+		return rc;
+	if (!ptep) {
+		newcrste = _crste_fc0(p_gfn, TABLE_TYPE_SEGMENT);
+		newcrste.h.i = 1;
+		newcrste.h.fc0.tl = 1;
+	} else {
+		pt = pte_table_start(ptep);
+		dat_set_ptval(pt, PTVAL_VMADDR, p_gfn >> (_SEGMENT_SHIFT - PAGE_SHIFT));
+		newcrste = _crste_fc0(virt_to_pfn(pt), TABLE_TYPE_SEGMENT);
+	}
+	rc = dat_entry_walk(mc, c_gfn, gmap->asce, DAT_WALK_ALLOC, TABLE_TYPE_SEGMENT,
+			    &crstep, &ptep);
+	if (rc)
+		return rc;
+	dat_crstep_xchg(crstep, newcrste, c_gfn, gmap->asce);
+	return 0;
+}
+
+static int gmap_ucas_translate_simple(struct gmap *gmap, gpa_t *gaddr, union crste **crstepp)
+{
+	union pte *ptep;
+	int rc;
+
+	rc = dat_entry_walk(NULL, gpa_to_gfn(*gaddr), gmap->asce, DAT_WALK_CONTINUE,
+			    TABLE_TYPE_SEGMENT, crstepp, &ptep);
+	if (rc || (!ptep && !crste_is_ucas(**crstepp)))
+		return -EREMOTE;
+	if (!ptep)
+		return 1;
+	*gaddr &= ~_SEGMENT_MASK;
+	*gaddr |= dat_get_ptval(pte_table_start(ptep), PTVAL_VMADDR) << _SEGMENT_SHIFT;
+	return 0;
+}
+
+/**
+ * gmap_ucas_translate() - Translate a vcpu address into a host gmap address
+ * @mc: The memory cache to be used for allocations.
+ * @gmap: The per-cpu gmap.
+ * @gaddr: Pointer to the address to be translated, will get overwritten with
+ *         the translated address in case of success.
+ * Translates the per-vCPU guest address into a fake guest address, which can
+ * then be used with the fake memslots that are identity mapping userspace.
+ * This allows ucontrol VMs to use the normal fault resolution path, like
+ * normal VMs.
+ *
+ * Return: %0 in case of success, otherwise %-EREMOTE.
+ */
+int gmap_ucas_translate(struct kvm_s390_mmu_cache *mc, struct gmap *gmap, gpa_t *gaddr)
+{
+	gpa_t translated_address;
+	union crste *crstep;
+	gfn_t gfn;
+	int rc;
+
+	gfn = gpa_to_gfn(*gaddr);
+
+	scoped_guard(read_lock, &gmap->kvm->mmu_lock) {
+		rc = gmap_ucas_translate_simple(gmap, gaddr, &crstep);
+		if (rc <= 0)
+			return rc;
+	}
+	do {
+		scoped_guard(write_lock, &gmap->kvm->mmu_lock) {
+			rc = gmap_ucas_translate_simple(gmap, gaddr, &crstep);
+			if (rc <= 0)
+				return rc;
+			translated_address = (*gaddr & ~_SEGMENT_MASK) |
+					     (crstep->val & _SEGMENT_MASK);
+			rc = gmap_ucas_map_one(mc, gmap, gpa_to_gfn(translated_address), gfn, true);
+		}
+		if (!rc) {
+			*gaddr = translated_address;
+			return 0;
+		}
+		if (rc != -ENOMEM)
+			return -EREMOTE;
+		rc = kvm_s390_mmu_cache_topup(mc);
+		if (rc)
+			return rc;
+	} while (1);
+	return 0;
+}
+
+int gmap_ucas_map(struct gmap *gmap, gfn_t p_gfn, gfn_t c_gfn, unsigned long count)
+{
+	struct kvm_s390_mmu_cache *mc;
+	int rc;
+
+	mc = kvm_s390_new_mmu_cache();
+	if (!mc)
+		return -ENOMEM;
+
+	while (count) {
+		scoped_guard(write_lock, &gmap->kvm->mmu_lock)
+			rc = gmap_ucas_map_one(mc, gmap, p_gfn, c_gfn, false);
+		if (rc == -ENOMEM) {
+			rc = kvm_s390_mmu_cache_topup(mc);
+			if (rc)
+				return rc;
+			continue;
+		}
+		if (rc)
+			return rc;
+
+		count--;
+		c_gfn += _PAGE_ENTRIES;
+		p_gfn += _PAGE_ENTRIES;
+	}
+	return rc;
+}
+
+static void gmap_ucas_unmap_one(struct gmap *gmap, gfn_t c_gfn)
+{
+	union crste *crstep;
+	union pte *ptep;
+	int rc;
+
+	rc = dat_entry_walk(NULL, c_gfn, gmap->asce, 0, TABLE_TYPE_SEGMENT, &crstep, &ptep);
+	if (!rc)
+		dat_crstep_xchg(crstep, _PMD_EMPTY, c_gfn, gmap->asce);
+}
+
+void gmap_ucas_unmap(struct gmap *gmap, gfn_t c_gfn, unsigned long count)
+{
+	guard(read_lock)(&gmap->kvm->mmu_lock);
+
+	for ( ; count; count--, c_gfn += _PAGE_ENTRIES)
+		gmap_ucas_unmap_one(gmap, c_gfn);
+}
+
+static long _gmap_split_crste(union crste *crstep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	struct gmap *gmap = walk->priv;
+	union crste crste, newcrste;
+
+	crste = READ_ONCE(*crstep);
+	newcrste = _CRSTE_EMPTY(crste.h.tt);
+
+	while (crste_leaf(crste)) {
+		if (crste_prefix(crste))
+			gmap_unmap_prefix(gmap, gfn, next);
+		if (crste.s.fc1.vsie_notif)
+			gmap_handle_vsie_unshadow_event(gmap, gfn);
+		if (dat_crstep_xchg_atomic(crstep, crste, newcrste, gfn, walk->asce))
+			break;
+		crste = READ_ONCE(*crstep);
+	}
+
+	if (need_resched())
+		return next;
+
+	return 0;
+}
+
+void gmap_split_huge_pages(struct gmap *gmap)
+{
+	const struct dat_walk_ops ops = {
+		.pmd_entry = _gmap_split_crste,
+		.pud_entry = _gmap_split_crste,
+	};
+	gfn_t start = 0;
+
+	do {
+		scoped_guard(read_lock, &gmap->kvm->mmu_lock)
+			start = _dat_walk_gfn_range(start, asce_end(gmap->asce), gmap->asce,
+						    &ops, DAT_WALK_IGN_HOLES, gmap);
+		cond_resched();
+	} while (start);
+}
+
+static int _gmap_enable_skeys(struct gmap *gmap)
+{
+	gfn_t start = 0;
+	int rc;
+
+	if (uses_skeys(gmap))
+		return 0;
+
+	set_bit(GMAP_FLAG_USES_SKEYS, &gmap->flags);
+	rc = gmap_helper_disable_cow_sharing();
+	if (rc) {
+		clear_bit(GMAP_FLAG_USES_SKEYS, &gmap->flags);
+		return rc;
+	}
+
+	do {
+		scoped_guard(write_lock, &gmap->kvm->mmu_lock)
+			start = dat_reset_skeys(gmap->asce, start);
+		cond_resched();
+	} while (start);
+	return 0;
+}
+
+int gmap_enable_skeys(struct gmap *gmap)
+{
+	int rc;
+
+	mmap_write_lock(gmap->kvm->mm);
+	rc = _gmap_enable_skeys(gmap);
+	mmap_write_unlock(gmap->kvm->mm);
+	return rc;
+}
+
+static long _destroy_pages_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	if (!ptep->s.pr)
+		return 0;
+	__kvm_s390_pv_destroy_page(phys_to_page(pte_origin(*ptep)));
+	if (need_resched())
+		return next;
+	return 0;
+}
+
+static long _destroy_pages_crste(union crste *crstep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	phys_addr_t origin, cur, end;
+
+	if (!crstep->h.fc || !crstep->s.fc1.pr)
+		return 0;
+
+	origin = crste_origin_large(*crstep);
+	cur = ((max(gfn, walk->start) - gfn) << PAGE_SHIFT) + origin;
+	end = ((min(next, walk->end) - gfn) << PAGE_SHIFT) + origin;
+	for ( ; cur < end; cur += PAGE_SIZE)
+		__kvm_s390_pv_destroy_page(phys_to_page(cur));
+	if (need_resched())
+		return next;
+	return 0;
+}
+
+int gmap_pv_destroy_range(struct gmap *gmap, gfn_t start, gfn_t end, bool interruptible)
+{
+	const struct dat_walk_ops ops = {
+		.pte_entry = _destroy_pages_pte,
+		.pmd_entry = _destroy_pages_crste,
+		.pud_entry = _destroy_pages_crste,
+	};
+
+	do {
+		scoped_guard(read_lock, &gmap->kvm->mmu_lock)
+			start = _dat_walk_gfn_range(start, end, gmap->asce, &ops,
+						    DAT_WALK_IGN_HOLES, NULL);
+		if (interruptible && fatal_signal_pending(current))
+			return -EINTR;
+		cond_resched();
+	} while (start && start < end);
+	return 0;
+}
+
+int gmap_insert_rmap(struct gmap *sg, gfn_t p_gfn, gfn_t r_gfn, int level)
+{
+	struct vsie_rmap *rmap __free(kvfree) = NULL;
+	struct vsie_rmap *temp;
+	void __rcu **slot;
+	int rc = 0;
+
+	KVM_BUG_ON(!is_shadow(sg), sg->kvm);
+	lockdep_assert_held(&sg->host_to_rmap_lock);
+
+	rmap = kzalloc(sizeof(*rmap), GFP_ATOMIC);
+	if (!rmap)
+		return -ENOMEM;
+
+	rmap->r_gfn = r_gfn;
+	rmap->level = level;
+	slot = radix_tree_lookup_slot(&sg->host_to_rmap, p_gfn);
+	if (slot) {
+		rmap->next = radix_tree_deref_slot_protected(slot, &sg->host_to_rmap_lock);
+		for (temp = rmap->next; temp; temp = temp->next) {
+			if (temp->val == rmap->val)
+				return 0;
+		}
+		radix_tree_replace_slot(&sg->host_to_rmap, slot, rmap);
+	} else {
+		rmap->next = NULL;
+		rc = radix_tree_insert(&sg->host_to_rmap, p_gfn, rmap);
+		if (rc)
+			return rc;
+	}
+	rmap = NULL;
+
+	return 0;
+}
+
+int gmap_protect_rmap(struct kvm_s390_mmu_cache *mc, struct gmap *sg, gfn_t p_gfn, gfn_t r_gfn,
+		      kvm_pfn_t pfn, int level, bool wr)
+{
+	union crste *crstep;
+	union pgste pgste;
+	union pte *ptep;
+	union pte pte;
+	int flags, rc;
+
+	KVM_BUG_ON(!is_shadow(sg), sg->kvm);
+	lockdep_assert_held(&sg->parent->children_lock);
+
+	flags = DAT_WALK_SPLIT_ALLOC | (uses_skeys(sg->parent) ? DAT_WALK_USES_SKEYS : 0);
+	rc = dat_entry_walk(mc, p_gfn, sg->parent->asce, flags,
+			    TABLE_TYPE_PAGE_TABLE, &crstep, &ptep);
+	if (rc)
+		return rc;
+	if (level <= TABLE_TYPE_REGION1) {
+		scoped_guard(spinlock, &sg->host_to_rmap_lock)
+			rc = gmap_insert_rmap(sg, p_gfn, r_gfn, level);
+	}
+	if (rc)
+		return rc;
+
+	if (!pgste_get_trylock(ptep, &pgste))
+		return -EAGAIN;
+	pte = ptep->s.pr ? *ptep : _pte(pfn, wr, false, false);
+	pte.h.p = 1;
+	pgste = _gmap_ptep_xchg(sg->parent, ptep, pte, pgste, p_gfn, false);
+	pgste.vsie_notif = 1;
+	pgste_set_unlock(ptep, pgste);
+
+	return 0;
+}
+
+static long __set_cmma_dirty_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	__atomic64_or(PGSTE_CMMA_D_BIT, &pgste_of(ptep)->val);
+	if (need_resched())
+		return next;
+	return 0;
+}
+
+void gmap_set_cmma_all_dirty(struct gmap *gmap)
+{
+	const struct dat_walk_ops ops = { .pte_entry = __set_cmma_dirty_pte, };
+	gfn_t gfn = 0;
+
+	do {
+		scoped_guard(read_lock, &gmap->kvm->mmu_lock)
+			gfn = _dat_walk_gfn_range(gfn, asce_end(gmap->asce), gmap->asce, &ops,
+						  DAT_WALK_IGN_HOLES, NULL);
+		cond_resched();
+	} while (gfn);
+}
+
+static void gmap_unshadow_level(struct gmap *sg, gfn_t r_gfn, int level)
+{
+	unsigned long align = PAGE_SIZE;
+	gpa_t gaddr = gfn_to_gpa(r_gfn);
+	union crste *crstep;
+	union crste crste;
+	union pte *ptep;
+
+	if (level > TABLE_TYPE_PAGE_TABLE)
+		align = 1UL << (11 * level + _SEGMENT_SHIFT);
+	kvm_s390_vsie_gmap_notifier(sg, ALIGN_DOWN(gaddr, align), ALIGN(gaddr + 1, align));
+	if (dat_entry_walk(NULL, r_gfn, sg->asce, 0, level, &crstep, &ptep))
+		return;
+	if (ptep) {
+		if (READ_ONCE(*ptep).val != _PTE_EMPTY.val)
+			dat_ptep_xchg(ptep, _PTE_EMPTY, r_gfn, sg->asce, uses_skeys(sg));
+		return;
+	}
+	crste = READ_ONCE(*crstep);
+	dat_crstep_clear(crstep, r_gfn, sg->asce);
+	if (crste_leaf(crste) || crste.h.i)
+		return;
+	if (is_pmd(crste))
+		dat_free_pt(dereference_pmd(crste.pmd));
+	else
+		dat_free_level(dereference_crste(crste), true);
+}
+
+static void gmap_unshadow(struct gmap *sg)
+{
+	struct gmap_cache *gmap_cache, *next;
+
+	KVM_BUG_ON(!is_shadow(sg), sg->kvm);
+	KVM_BUG_ON(!sg->parent, sg->kvm);
+
+	lockdep_assert_held(&sg->parent->children_lock);
+
+	gmap_remove_child(sg);
+	kvm_s390_vsie_gmap_notifier(sg, 0, -1UL);
+
+	list_for_each_entry_safe(gmap_cache, next, &sg->scb_users, list) {
+		gmap_cache->gmap = NULL;
+		list_del(&gmap_cache->list);
+	}
+
+	gmap_put(sg);
+}
+
+void _gmap_handle_vsie_unshadow_event(struct gmap *parent, gfn_t gfn)
+{
+	struct vsie_rmap *rmap, *rnext, *head;
+	struct gmap *sg, *next;
+	gfn_t start, end;
+
+	list_for_each_entry_safe(sg, next, &parent->children, list) {
+		start = sg->guest_asce.rsto;
+		end = start + sg->guest_asce.tl + 1;
+		if (!sg->guest_asce.r && gfn >= start && gfn < end) {
+			gmap_unshadow(sg);
+			continue;
+		}
+		scoped_guard(spinlock, &sg->host_to_rmap_lock)
+			head = radix_tree_delete(&sg->host_to_rmap, gfn);
+		gmap_for_each_rmap_safe(rmap, rnext, head)
+			gmap_unshadow_level(sg, rmap->r_gfn, rmap->level);
+	}
+}
+
+/**
+ * gmap_find_shadow() - Find a specific ASCE in the list of shadow tables.
+ * @parent: Pointer to the parent gmap.
+ * @asce: ASCE for which the shadow table is created.
+ * @edat_level: Edat level to be used for the shadow translation.
+ *
+ * Context: Called with parent->children_lock held.
+ *
+ * Return: The pointer to a gmap if a shadow table with the given asce is
+ * already available, ERR_PTR(-EAGAIN) if another one is just being created,
+ * otherwise NULL.
+ */
+static struct gmap *gmap_find_shadow(struct gmap *parent, union asce asce, int edat_level)
+{
+	struct gmap *sg;
+
+	lockdep_assert_held(&parent->children_lock);
+	list_for_each_entry(sg, &parent->children, list) {
+		if (!gmap_is_shadow_valid(sg, asce, edat_level))
+			continue;
+		return sg;
+	}
+	return NULL;
+}
+
+static int gmap_protect_asce_top_level(struct kvm_s390_mmu_cache *mc, struct gmap *sg)
+{
+	KVM_BUG_ON(1, sg->kvm);
+	return -EINVAL;
+}
+
+/**
+ * gmap_create_shadow() - Create/find a shadow guest address space.
+ * @mc: The cache to use to allocate dat tables.
+ * @parent: Pointer to the parent gmap.
+ * @asce: ASCE for which the shadow table is created.
+ * @edat_level: Edat level to be used for the shadow translation.
+ *
+ * The pages of the top level page table referred by the asce parameter
+ * will be set to read-only and marked in the PGSTEs of the kvm process.
+ * The shadow table will be removed automatically on any change to the
+ * PTE mapping for the source table.
+ *
+ * Return: A guest address space structure, ERR_PTR(-ENOMEM) if out of memory,
+ * ERR_PTR(-EAGAIN) if the caller has to retry and ERR_PTR(-EFAULT) if the
+ * parent gmap table could not be protected.
+ */
+struct gmap *gmap_create_shadow(struct kvm_s390_mmu_cache *mc, struct gmap *parent,
+				union asce asce, int edat_level)
+{
+	struct gmap *sg, *new;
+	int rc;
+
+	scoped_guard(spinlock, &parent->children_lock)
+		sg = gmap_find_shadow(parent, asce, edat_level);
+	if (sg)
+		return sg;
+	/* Create a new shadow gmap. */
+	new = gmap_new(parent->kvm, asce.r ? 1UL << (64 - PAGE_SHIFT) : asce_end(asce));
+	if (!new)
+		return ERR_PTR(-ENOMEM);
+	new->guest_asce = asce;
+	new->edat_level = edat_level;
+	set_bit(GMAP_FLAG_SHADOW, &new->flags);
+
+	scoped_guard(spinlock, &parent->children_lock) {
+		/* Recheck if another CPU created the same shadow. */
+		sg = gmap_find_shadow(parent, asce, edat_level);
+		if (sg) {
+			gmap_put(new);
+			return sg;
+		}
+		if (asce.r) {
+			/* Only allow one real-space gmap shadow. */
+			list_for_each_entry(sg, &parent->children, list) {
+				if (sg->guest_asce.r) {
+					scoped_guard(write_lock, &parent->kvm->mmu_lock)
+						gmap_unshadow(sg);
+					break;
+				}
+			}
+			gmap_add_child(parent, new);
+			/* Nothing to protect, return right away. */
+			return new;
+		}
+	}
+
+	new->parent = parent;
+	/* Protect while inserting, protects against invalidation races. */
+	rc = gmap_protect_asce_top_level(mc, new);
+	if (rc) {
+		new->parent = NULL;
+		gmap_put(new);
+		return ERR_PTR(rc);
+	}
+	return new;
+}
diff --git a/arch/s390/kvm/gmap.h b/arch/s390/kvm/gmap.h
new file mode 100644
index 000000000000..ccb5cd751e31
--- /dev/null
+++ b/arch/s390/kvm/gmap.h
@@ -0,0 +1,244 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  KVM guest address space mapping code
+ *
+ *    Copyright IBM Corp. 2007, 2016, 2025
+ *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
+ *               Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+
+#ifndef ARCH_KVM_S390_GMAP_H
+#define ARCH_KVM_S390_GMAP_H
+
+#include "dat.h"
+
+/**
+ * enum gmap_flags - Flags of a gmap.
+ *
+ * @GMAP_FLAG_SHADOW: The gmap is a vsie shadow gmap.
+ * @GMAP_FLAG_OWNS_PAGETABLES: The gmap owns all dat levels; normally 1, is 0
+ *                             only for ucontrol per-cpu gmaps, since they
+ *                             share the page tables with the main gmap.
+ * @GMAP_FLAG_IS_UCONTROL: The gmap is ucontrol (main gmap or per-cpu gmap).
+ * @GMAP_FLAG_ALLOW_HPAGE_1M: 1M hugepages are allowed for this gmap,
+ *                            independently of the page size used by userspace.
+ * @GMAP_FLAG_ALLOW_HPAGE_2G: 2G hugepages are allowed for this gmap,
+ *                            independently of the page size used by userspace.
+ * @GMAP_FLAG_PFAULT_ENABLED: Pfault is enabled for the gmap.
+ * @GMAP_FLAG_USES_SKEYS: If the guest uses storage keys.
+ * @GMAP_FLAG_USES_CMM: Whether the guest uses CMMA.
+ * @GMAP_FLAG_EXPORT_ON_UNMAP: Whether to export guest pages when unmapping.
+ */
+enum gmap_flags {
+	GMAP_FLAG_SHADOW = 0,
+	GMAP_FLAG_OWNS_PAGETABLES,
+	GMAP_FLAG_IS_UCONTROL,
+	GMAP_FLAG_ALLOW_HPAGE_1M,
+	GMAP_FLAG_ALLOW_HPAGE_2G,
+	GMAP_FLAG_PFAULT_ENABLED,
+	GMAP_FLAG_USES_SKEYS,
+	GMAP_FLAG_USES_CMM,
+	GMAP_FLAG_EXPORT_ON_UNMAP,
+};
+
+/**
+ * struct gmap_struct - Guest address space.
+ *
+ * @flags: GMAP_FLAG_* flags.
+ * @edat_level: The edat level of this shadow gmap.
+ * @kvm: The vm.
+ * @asce: The ASCE used by this gmap.
+ * @list: List head used in children gmaps for the children gmap list.
+ * @children_lock: Protects children and scb_users.
+ * @children: List of child gmaps of this gmap.
+ * @scb_users: List of vsie_scb that use this shadow gmap.
+ * @parent: Parent gmap of a child gmap.
+ * @guest_asce: Original ASCE of this shadow gmap.
+ * @host_to_rmap_lock: Protects host_to_rmap.
+ * @host_to_rmap: Radix tree mapping host addresses to guest addresses.
+ */
+struct gmap {
+	unsigned long flags;
+	unsigned char edat_level;
+	struct kvm *kvm;
+	union asce asce;
+	struct list_head list;
+	spinlock_t children_lock;	/* Protects: children, scb_users */
+	struct list_head children;
+	struct list_head scb_users;
+	struct gmap *parent;
+	union asce guest_asce;
+	spinlock_t host_to_rmap_lock;	/* Protects host_to_rmap */
+	struct radix_tree_root host_to_rmap;
+	refcount_t refcount;
+};
+
+struct gmap_cache {
+	struct list_head list;
+	struct gmap *gmap;
+};
+
+#define gmap_for_each_rmap_safe(pos, n, head) \
+	for (pos = (head); n = pos ? pos->next : NULL, pos; pos = n)
+
+int s390_replace_asce(struct gmap *gmap);
+bool _gmap_unmap_prefix(struct gmap *gmap, gfn_t gfn, gfn_t end, bool hint);
+bool gmap_age_gfn(struct gmap *gmap, gfn_t start, gfn_t end);
+bool gmap_unmap_gfn_range(struct gmap *gmap, struct kvm_memory_slot *slot, gfn_t start, gfn_t end);
+int gmap_try_fixup_minor(struct gmap *gmap, struct guest_fault *fault);
+struct gmap *gmap_new(struct kvm *kvm, gfn_t limit);
+struct gmap *gmap_new_child(struct gmap *parent, gfn_t limit);
+void gmap_remove_child(struct gmap *child);
+void gmap_dispose(struct gmap *gmap);
+int gmap_link(struct kvm_s390_mmu_cache *mc, struct gmap *gmap, struct guest_fault *fault);
+void gmap_sync_dirty_log(struct gmap *gmap, gfn_t start, gfn_t end);
+int gmap_set_limit(struct gmap *gmap, gfn_t limit);
+int gmap_ucas_translate(struct kvm_s390_mmu_cache *mc, struct gmap *gmap, gpa_t *gaddr);
+int gmap_ucas_map(struct gmap *gmap, gfn_t p_gfn, gfn_t c_gfn, unsigned long count);
+void gmap_ucas_unmap(struct gmap *gmap, gfn_t c_gfn, unsigned long count);
+int gmap_enable_skeys(struct gmap *gmap);
+int gmap_pv_destroy_range(struct gmap *gmap, gfn_t start, gfn_t end, bool interruptible);
+int gmap_insert_rmap(struct gmap *sg, gfn_t p_gfn, gfn_t r_gfn, int level);
+int gmap_protect_rmap(struct kvm_s390_mmu_cache *mc, struct gmap *sg, gfn_t p_gfn, gfn_t r_gfn,
+		      kvm_pfn_t pfn, int level, bool wr);
+void gmap_set_cmma_all_dirty(struct gmap *gmap);
+void _gmap_handle_vsie_unshadow_event(struct gmap *parent, gfn_t gfn);
+struct gmap *gmap_create_shadow(struct kvm_s390_mmu_cache *mc, struct gmap *gmap,
+				union asce asce, int edat_level);
+void gmap_split_huge_pages(struct gmap *gmap);
+
+static inline bool uses_skeys(struct gmap *gmap)
+{
+	return test_bit(GMAP_FLAG_USES_SKEYS, &gmap->flags);
+}
+
+static inline bool uses_cmm(struct gmap *gmap)
+{
+	return test_bit(GMAP_FLAG_USES_CMM, &gmap->flags);
+}
+
+static inline bool pfault_enabled(struct gmap *gmap)
+{
+	return test_bit(GMAP_FLAG_PFAULT_ENABLED, &gmap->flags);
+}
+
+static inline bool is_ucontrol(struct gmap *gmap)
+{
+	return test_bit(GMAP_FLAG_IS_UCONTROL, &gmap->flags);
+}
+
+static inline bool is_shadow(struct gmap *gmap)
+{
+	return test_bit(GMAP_FLAG_SHADOW, &gmap->flags);
+}
+
+static inline bool owns_page_tables(struct gmap *gmap)
+{
+	return test_bit(GMAP_FLAG_OWNS_PAGETABLES, &gmap->flags);
+}
+
+static inline struct gmap *gmap_put(struct gmap *gmap)
+{
+	if (refcount_dec_and_test(&gmap->refcount))
+		gmap_dispose(gmap);
+	return NULL;
+}
+
+static inline void gmap_get(struct gmap *gmap)
+{
+	WARN_ON_ONCE(unlikely(!refcount_inc_not_zero(&gmap->refcount)));
+}
+
+static inline void gmap_handle_vsie_unshadow_event(struct gmap *parent, gfn_t gfn)
+{
+	scoped_guard(spinlock, &parent->children_lock)
+		_gmap_handle_vsie_unshadow_event(parent, gfn);
+}
+
+static inline bool gmap_mkold_prefix(struct gmap *gmap, gfn_t gfn, gfn_t end)
+{
+	return _gmap_unmap_prefix(gmap, gfn, end, true);
+}
+
+static inline bool gmap_unmap_prefix(struct gmap *gmap, gfn_t gfn, gfn_t end)
+{
+	return _gmap_unmap_prefix(gmap, gfn, end, false);
+}
+
+static inline union pgste _gmap_ptep_xchg(struct gmap *gmap, union pte *ptep, union pte newpte,
+					  union pgste pgste, gfn_t gfn, bool needs_lock)
+{
+	lockdep_assert_held(&gmap->kvm->mmu_lock);
+	if (!needs_lock)
+		lockdep_assert_held(&gmap->children_lock);
+	else
+		lockdep_assert_not_held(&gmap->children_lock);
+
+	if (pgste.prefix_notif && (newpte.h.p || newpte.h.i)) {
+		pgste.prefix_notif = 0;
+		gmap_unmap_prefix(gmap, gfn, gfn + 1);
+	}
+	if (pgste.vsie_notif && (ptep->h.p != newpte.h.p || newpte.h.i)) {
+		pgste.vsie_notif = 0;
+		if (needs_lock)
+			gmap_handle_vsie_unshadow_event(gmap, gfn);
+		else
+			_gmap_handle_vsie_unshadow_event(gmap, gfn);
+	}
+	return __dat_ptep_xchg(ptep, pgste, newpte, gfn, gmap->asce, uses_skeys(gmap));
+}
+
+static inline union pgste gmap_ptep_xchg(struct gmap *gmap, union pte *ptep, union pte newpte,
+					 union pgste pgste, gfn_t gfn)
+{
+	return _gmap_ptep_xchg(gmap, ptep, newpte, pgste, gfn, true);
+}
+
+static inline void _gmap_crstep_xchg(struct gmap *gmap, union crste *crstep, union crste ne,
+				     gfn_t gfn, bool needs_lock)
+{
+	unsigned long align = 8 + (is_pmd(*crstep) ? 0 : 11);
+
+	lockdep_assert_held(&gmap->kvm->mmu_lock);
+	if (!needs_lock)
+		lockdep_assert_held(&gmap->children_lock);
+
+	gfn = ALIGN_DOWN(gfn, align);
+	if (crste_prefix(*crstep) && (ne.h.p || ne.h.i || !crste_prefix(ne))) {
+		ne.s.fc1.prefix_notif = 0;
+		gmap_unmap_prefix(gmap, gfn, gfn + align);
+	}
+	if (crste_leaf(*crstep) && crstep->s.fc1.vsie_notif &&
+	    (ne.h.p || ne.h.i || !ne.s.fc1.vsie_notif)) {
+		ne.s.fc1.vsie_notif = 0;
+		if (needs_lock)
+			gmap_handle_vsie_unshadow_event(gmap, gfn);
+		else
+			_gmap_handle_vsie_unshadow_event(gmap, gfn);
+	}
+	dat_crstep_xchg(crstep, ne, gfn, gmap->asce);
+}
+
+static inline void gmap_crstep_xchg(struct gmap *gmap, union crste *crstep, union crste ne,
+				    gfn_t gfn)
+{
+	return _gmap_crstep_xchg(gmap, crstep, ne, gfn, true);
+}
+
+/**
+ * gmap_is_shadow_valid() - check if a shadow guest address space matches the
+ *                          given properties and is still valid.
+ * @sg: Pointer to the shadow guest address space structure.
+ * @asce: ASCE for which the shadow table is requested.
+ * @edat_level: Edat level to be used for the shadow translation.
+ *
+ * Return: true if the gmap shadow is still valid and matches the given
+ * properties and the caller can continue using it; false otherwise, the
+ * caller has to request a new shadow gmap in this case.
+ */
+static inline bool gmap_is_shadow_valid(struct gmap *sg, union asce asce, int edat_level)
+{
+	return sg->guest_asce.val == asce.val && sg->edat_level == edat_level;
+}
+
+#endif /* ARCH_KVM_S390_GMAP_H */
-- 
2.53.0


