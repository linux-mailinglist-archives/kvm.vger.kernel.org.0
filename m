Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6263A4A9C6B
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 16:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376347AbiBDPyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 10:54:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33248 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240524AbiBDPyA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 10:54:00 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214Ex3Rh001257;
        Fri, 4 Feb 2022 15:53:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/teVOhDZ6tCkJSewRcih5C5xJlWKe2Hx7KQEofoSlzw=;
 b=qyIMBUztJQ8VMXmK+2SQk/tWXuK5cuuw8GaYb5vSTa+iGZDbyFSDlbF7ApQVM+FMChc+
 W+/pu+UzoFnvSCB1XnqTVERHDULdCCarsyZQOxyLZSTysHRRbYvONWdxFBJxNV9OMaIF
 UUSxiC+8rPEg+pu7qpbufXekAsPnULQT1qI1njbLwXZXrmHazZNpCOc84MhA0B3rVWbW
 knK8df+77g8Rmh1PhycVxtQbAqkaEZpsmvJdKw5GeEOqwSJYjnzFgI7BK90e573NrXck
 S/BhSGOqtEcZTouNrFOpK08fI4w2/1Cje9w3mp7BZmpLJVxdWI0v1yd/gXpWLH1dJw+K bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0qxg0wyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:53:59 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214Fo41Z027143;
        Fri, 4 Feb 2022 15:53:59 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0qxg0wyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:53:58 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214Fldch009754;
        Fri, 4 Feb 2022 15:53:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3e0r11p09m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:53:57 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214Frrve44171624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 15:53:53 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06858AE056;
        Fri,  4 Feb 2022 15:53:53 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E16FAE04D;
        Fri,  4 Feb 2022 15:53:52 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.8.50])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 15:53:52 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: [PATCH v7 04/17] KVM: s390: pv: refactor s390_reset_acc
Date:   Fri,  4 Feb 2022 16:53:36 +0100
Message-Id: <20220204155349.63238-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204155349.63238-1-imbrenda@linux.ibm.com>
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HtSxKALhUHH7E-_nhUg5oP9YM7kQe0S6
X-Proofpoint-ORIG-GUID: at6erSHHMlfM97OftDs_lFri_JG-Q86b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 adultscore=0 mlxscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor s390_reset_acc so that it can be reused in upcoming patches.

We don't want to hold all the locks used in a walk_page_range for too
long, and the destroy page UVC does take some time to complete.
Therefore we quickly gather the pages to destroy, and then destroy them
without holding all the locks.

The new refactored function optionally allows to return early without
completing if a fatal signal is pending (and return and appropriate
error code). Two wrappers are provided to call the new function.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
(dropping Janosch's Ack because of major changes to the patch)
---
 arch/s390/include/asm/gmap.h | 36 +++++++++++++-
 arch/s390/kvm/pv.c           | 12 ++++-
 arch/s390/mm/gmap.c          | 95 +++++++++++++++++++++++++-----------
 3 files changed, 111 insertions(+), 32 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 746e18bf8984..2a913014f63c 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -147,7 +147,41 @@ int gmap_mprotect_notify(struct gmap *, unsigned long start,
 void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
 			     unsigned long gaddr, unsigned long vmaddr);
 int gmap_mark_unmergeable(void);
-void s390_reset_acc(struct mm_struct *mm);
 void s390_remove_old_asce(struct gmap *gmap);
 int s390_replace_asce(struct gmap *gmap);
+void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
+int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
+			    unsigned long end, int interruptible);
+
+/**
+ * s390_uv_destroy_range - Destroy a range of pages in the given mm.
+ * @mm the mm on which to operate on
+ * @start the start of the range
+ * @end the end of the range
+ *
+ * This call will call cond_sched, so it should not generate stalls, but it
+ * will otherwise only return when it completed.
+ */
+static inline void s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
+					 unsigned long end)
+{
+	(void)__s390_uv_destroy_range(mm, start, end, 0);
+}
+
+/**
+ * s390_uv_destroy_range_interruptibe - Destroy a range of pages in the
+ * given mm, but stop when a fatal signal is received.
+ * @mm the mm on which to operate on
+ * @start the start of the range
+ * @end the end of the range
+ *
+ * This call will call cond_sched, so it should not generate stalls.  It
+ * will return -EINTR if a fatal signal is received, or 0 if the whole range
+ * has been destroyed.
+ */
+static inline int s390_uv_destroy_range_interruptible(struct mm_struct *mm, unsigned long start,
+						      unsigned long end)
+{
+	return __s390_uv_destroy_range(mm, start, end, 1);
+}
 #endif /* _ASM_S390_GMAP_H */
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 3c59ef763dde..2ab22500e092 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -12,6 +12,8 @@
 #include <asm/gmap.h>
 #include <asm/uv.h>
 #include <asm/mman.h>
+#include <linux/pagewalk.h>
+#include <linux/sched/mm.h>
 #include "kvm-s390.h"
 
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
@@ -157,8 +159,14 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	int cc;
 
-	/* make all pages accessible before destroying the guest */
-	s390_reset_acc(kvm->mm);
+	/*
+	 * if the mm still has a mapping, make all its pages accessible
+	 * before destroying the guest
+	 */
+	if (mmget_not_zero(kvm->mm)) {
+		s390_uv_destroy_range(kvm->mm, 0, TASK_SIZE);
+		mmput(kvm->mm);
+	}
 
 	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
 			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index ce6cac4463f2..6eb5acb4be3d 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2676,44 +2676,81 @@ void s390_reset_cmma(struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(s390_reset_cmma);
 
-/*
- * make inaccessible pages accessible again
- */
-static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
-			    unsigned long next, struct mm_walk *walk)
+#define DESTROY_LOOP_THRESHOLD 32
+
+struct reset_walk_state {
+	unsigned long next;
+	unsigned long count;
+	unsigned long pfns[DESTROY_LOOP_THRESHOLD];
+};
+
+static int s390_gather_pages(pte_t *ptep, unsigned long addr,
+			     unsigned long next, struct mm_walk *walk)
 {
+	struct reset_walk_state *p = walk->private;
 	pte_t pte = READ_ONCE(*ptep);
 
-	/* There is a reference through the mapping */
-	if (pte_present(pte))
-		WARN_ON_ONCE(uv_destroy_owned_page(pte_val(pte) & PAGE_MASK));
-
-	return 0;
+	if (pte_present(pte)) {
+		/* we have a reference from the mapping, take an extra one */
+		get_page(phys_to_page(pte_val(pte)));
+		p->pfns[p->count] = phys_to_pfn(pte_val(pte));
+		p->next = next;
+		p->count++;
+	}
+	return p->count >= DESTROY_LOOP_THRESHOLD;
 }
 
-static const struct mm_walk_ops reset_acc_walk_ops = {
-	.pte_entry		= __s390_reset_acc,
+static const struct mm_walk_ops gather_pages_ops = {
+	.pte_entry = s390_gather_pages,
 };
 
-#include <linux/sched/mm.h>
-void s390_reset_acc(struct mm_struct *mm)
+/*
+ * Call the Destroy secure page UVC on each page in the given array of PFNs.
+ * Each page needs to have an extra reference, which will be released here.
+ */
+void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns)
 {
-	if (!mm_is_protected(mm))
-		return;
-	/*
-	 * we might be called during
-	 * reset:                             we walk the pages and clear
-	 * close of all kvm file descriptors: we walk the pages and clear
-	 * exit of process on fd closure:     vma already gone, do nothing
-	 */
-	if (!mmget_not_zero(mm))
-		return;
-	mmap_read_lock(mm);
-	walk_page_range(mm, 0, TASK_SIZE, &reset_acc_walk_ops, NULL);
-	mmap_read_unlock(mm);
-	mmput(mm);
+	unsigned long i;
+
+	for (i = 0; i < count; i++) {
+		/* we always have an extra reference */
+		uv_destroy_owned_page(pfn_to_phys(pfns[i]));
+		/* get rid of the extra reference */
+		put_page(pfn_to_page(pfns[i]));
+		cond_resched();
+	}
+}
+EXPORT_SYMBOL_GPL(s390_uv_destroy_pfns);
+
+/**
+ * __s390_uv_destroy_range - Walk the given range of the given address
+ * space, and call the destroy secure page UVC on each page.
+ * Optionally exit early if a fatal signal is pending.
+ * @mm the mm to operate on
+ * @start the start of the range
+ * @end the end of the range
+ * @interruptible if not 0, stop when a fatal signal is received
+ * Return: 0 on success, -EINTR if the function stopped before completing
+ */
+int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
+			    unsigned long end, int interruptible)
+{
+	struct reset_walk_state state = { .next = start };
+	int r = 1;
+
+	while (r > 0) {
+		state.count = 0;
+		mmap_read_lock(mm);
+		r = walk_page_range(mm, state.next, end, &gather_pages_ops, &state);
+		mmap_read_unlock(mm);
+		cond_resched();
+		s390_uv_destroy_pfns(state.count, state.pfns);
+		if (interruptible && fatal_signal_pending(current))
+			return -EINTR;
+	}
+	return 0;
 }
-EXPORT_SYMBOL_GPL(s390_reset_acc);
+EXPORT_SYMBOL_GPL(__s390_uv_destroy_range);
 
 /**
  * s390_remove_old_asce - Remove the topmost level of page tables from the
-- 
2.34.1

