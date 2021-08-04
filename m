Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3901A3E0477
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 17:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239324AbhHDPl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 11:41:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30358 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239251AbhHDPlT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 11:41:19 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 174FYgvl185708;
        Wed, 4 Aug 2021 11:41:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1fB9VKi0uCutQdU+DnII+bjeAGRBkJfc9YpztvBYXAU=;
 b=JBYpjEI9Pn3W+Y1gC6GbZbNKmbHadj4D5wFJh2qDo3AspUMRfNAhdsfrAj8oa8WOqzC5
 OyUNdUbJSJWKo0SEsDCxRYSpBy6PJYxLoCpkYLt7wUOGohSzjWoMZMqPJC7o+7BlZAgo
 q3TEI9jCM1XOSPZn0MvGYRVztkHKgYKSfFnJF5AfHbjBmNkpw0EbJv+Fc0lzTwDTUYjz
 jtHGZx7eHI3JupW2US+bwu51e0N/a5hAt5lm3BTtrri325uREJZzBy8W7RUBYLzgkSAt
 EVxuGOx+glOp9a8yWxpSU7qz6JxFoDv5HZadm5PdZmE++T33nrNOnaNb96xbBinmlFpM 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a7342vrd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 11:41:06 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 174FYlox186298;
        Wed, 4 Aug 2021 11:41:06 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a7342vrbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 11:41:06 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 174FY3oN005150;
        Wed, 4 Aug 2021 15:41:04 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3a4wsj0hv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 15:41:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 174Fex5o56361372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Aug 2021 15:40:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 084814C05C;
        Wed,  4 Aug 2021 15:40:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C3E04C052;
        Wed,  4 Aug 2021 15:40:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.150])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 Aug 2021 15:40:58 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v3 11/14] KVM: s390: pv: extend lazy destroy to handle shutdown
Date:   Wed,  4 Aug 2021 17:40:43 +0200
Message-Id: <20210804154046.88552-12-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210804154046.88552-1-imbrenda@linux.ibm.com>
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9-3rarjR5XzBd9Rjvs0gHSmCiI-N1jyq
X-Proofpoint-GUID: -jlygSIub35190yb89nvflZtSuAqX91E
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-04_03:2021-08-04,2021-08-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108040089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the lazy destroy infrastructure to handle almost all kinds of
exit of the userspace process. The only case not handled is if the
process is killed by the OOM, in which case the old behaviour will
still be in effect.

Add the uv_destroy_page_lazy function to set aside pages when unmapping
them during mm teardown; the pages will be processed and freed when the
protected VM is torn down.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/mmu.h         |  3 ++
 arch/s390/include/asm/mmu_context.h |  2 ++
 arch/s390/include/asm/pgtable.h     |  9 ++++--
 arch/s390/include/asm/uv.h          | 15 +++++++++
 arch/s390/kernel/uv.c               | 47 +++++++++++++++++++++++++++++
 arch/s390/kvm/pv.c                  | 41 ++++++++++++++++++-------
 6 files changed, 104 insertions(+), 13 deletions(-)

diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
index e12ff0f29d1a..e2250dbe3d9d 100644
--- a/arch/s390/include/asm/mmu.h
+++ b/arch/s390/include/asm/mmu.h
@@ -18,6 +18,7 @@ typedef struct {
 	unsigned long vdso_base;
 	/* The mmu context belongs to a secure guest. */
 	atomic_t is_protected;
+	struct list_head deferred_list;
 	/*
 	 * The following bitfields need a down_write on the mm
 	 * semaphore when they are written to. As they are only
@@ -34,6 +35,8 @@ typedef struct {
 	unsigned int uses_cmm:1;
 	/* The gmaps associated with this context are allowed to use huge pages. */
 	unsigned int allow_gmap_hpage_1m:1;
+	/* The mmu context should be destroyed synchronously */
+	unsigned int pv_sync_destroy:1;
 } mm_context_t;
 
 #define INIT_MM_CONTEXT(name)						   \
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index c7937f369e62..5c598afe07a8 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -27,8 +27,10 @@ static inline int init_new_context(struct task_struct *tsk,
 	cpumask_clear(&mm->context.cpu_attach_mask);
 	atomic_set(&mm->context.flush_count, 0);
 	atomic_set(&mm->context.is_protected, 0);
+	mm->context.pv_sync_destroy = 0;
 	mm->context.gmap_asce = 0;
 	mm->context.flush_mm = 0;
+	INIT_LIST_HEAD(&mm->context.deferred_list);
 #ifdef CONFIG_PGSTE
 	mm->context.alloc_pgste = page_table_allocate_pgste ||
 		test_thread_flag(TIF_PGSTE) ||
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 0f1af2232ebe..c311503edc3b 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1118,9 +1118,14 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 	} else {
 		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
 	}
+
 	/* At this point the reference through the mapping is still present */
-	if (mm_is_protected(mm) && pte_present(res))
-		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
+	if (pte_present(res) && mm_is_protected(mm)) {
+		if (full && !mm->context.pv_sync_destroy)
+			uv_destroy_page_lazy(mm, pte_val(res) & PAGE_MASK);
+		else
+			uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
+	}
 	return res;
 }
 
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index c8bd72be8974..934227611773 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -350,6 +350,15 @@ static inline int uv_remove_shared(unsigned long addr) { return 0; }
 #if IS_ENABLED(CONFIG_KVM)
 extern int prot_virt_host;
 
+struct destroy_page_lazy {
+	struct list_head list;
+	unsigned short count;
+	unsigned long pfns[];
+};
+
+/* This guarantees that up to PV_MAX_LAZY_COUNT can fit in a page */
+#define PV_MAX_LAZY_COUNT ((PAGE_SIZE - sizeof(struct destroy_page_lazy)) / sizeof(long))
+
 static inline int is_prot_virt_host(void)
 {
 	return prot_virt_host;
@@ -358,6 +367,7 @@ static inline int is_prot_virt_host(void)
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
 int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
 int uv_destroy_owned_page(unsigned long paddr);
+int uv_destroy_page_lazy(struct mm_struct *mm, unsigned long paddr);
 int uv_convert_from_secure(unsigned long paddr);
 int uv_convert_owned_from_secure(unsigned long paddr);
 int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
@@ -374,6 +384,11 @@ static inline int uv_destroy_owned_page(unsigned long paddr)
 	return 0;
 }
 
+static inline int uv_destroy_page_lazy(struct mm_struct *mm, unsigned long paddr)
+{
+	return 0;
+}
+
 static inline int uv_convert_from_secure(unsigned long paddr)
 {
 	return 0;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index bc79085d7152..5b632846c4a4 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -186,6 +186,53 @@ int uv_convert_owned_from_secure(unsigned long paddr)
 	return rc;
 }
 
+/*
+ * Set aside the given page and put it in the list of pages to be cleared in
+ * background. The caller must already hold a reference to the page.
+ */
+int uv_destroy_page_lazy(struct mm_struct *mm, unsigned long paddr)
+{
+	struct list_head *head = &mm->context.deferred_list;
+	struct destroy_page_lazy *lazy;
+	struct page *page;
+	int rc;
+
+	/* get an extra reference here */
+	get_page(phys_to_page(paddr));
+
+	lazy = list_first_entry(head, struct destroy_page_lazy, list);
+	/*
+	 * We need a fresh page to store more pointers. The current page
+	 * might be shared, so it cannot be used directly. Instead, make it
+	 * accessible and release it, and let the normal unmap code free it
+	 * later, if needed.
+	 * Afterwards, try to allocate a new page, but not very hard. If the
+	 * allocation fails, we simply return. The next call to this
+	 * function will attempt to do the same again, until enough pages
+	 * have been freed.
+	 */
+	if (list_empty(head) || lazy->count >= PV_MAX_LAZY_COUNT) {
+		rc = uv_convert_owned_from_secure(paddr);
+		/* in case of failure, we intentionally leak the page */
+		if (rc)
+			return rc;
+		/* release the extra reference */
+		put_page(phys_to_page(paddr));
+
+		/* try to allocate a new page quickly, but allow failures */
+		page = alloc_page(GFP_ATOMIC | __GFP_NOMEMALLOC | __GFP_NOWARN);
+		if (!page)
+			return -ENOMEM;
+		lazy = page_to_virt(page);
+		lazy->count = 0;
+		list_add(&lazy->list, head);
+		return 0;
+	}
+	/* the array of pointers has space, just add this entry */
+	lazy->pfns[lazy->count++] = phys_to_pfn(paddr);
+	return 0;
+}
+
 /*
  * Calculate the expected ref_count for a page that would otherwise have no
  * further pins. This was cribbed from similar functions in other places in
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 8267376a9a0d..e10392a8b1ae 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -19,6 +19,7 @@
 
 struct deferred_priv {
 	struct mm_struct *mm;
+	bool has_mm;
 	unsigned long old_table;
 	u64 handle;
 	void *stor_var;
@@ -197,19 +198,34 @@ static int kvm_s390_pv_deinit_vm_now(struct kvm *kvm, u16 *rc, u16 *rrc)
 
 static int kvm_s390_pv_destroy_vm_thread(void *priv)
 {
+	struct destroy_page_lazy *lazy, *next;
 	struct deferred_priv *p = priv;
 	u16 rc, rrc;
 	int r;
 
-	/* Clear all the pages as long as we are not the only users of the mm */
-	s390_uv_destroy_range(p->mm, 1, 0, TASK_SIZE_MAX);
-	/*
-	 * If we were the last user of the mm, synchronously free (and clear
-	 * if needed) all pages.
-	 * Otherwise simply decrease the reference counter; in this case we
-	 * have already cleared all pages.
-	 */
-	mmput(p->mm);
+	list_for_each_entry_safe(lazy, next, &p->mm->context.deferred_list, list) {
+		list_del(&lazy->list);
+		s390_uv_destroy_pfns(lazy->count, lazy->pfns);
+		free_page(__pa(lazy));
+	}
+
+	if (p->has_mm) {
+		/* Clear all the pages as long as we are not the only users of the mm */
+		s390_uv_destroy_range(p->mm, 1, 0, TASK_SIZE_MAX);
+		if (atomic_read(&p->mm->mm_users) == 1) {
+			mmap_write_lock(p->mm);
+			/* destroy synchronously if there are no other users */
+			p->mm->context.pv_sync_destroy = 1;
+			mmap_write_unlock(p->mm);
+		}
+		/*
+		 * If we were the last user of the mm, synchronously free
+		 * (and clear if needed) all pages.
+		 * Otherwise simply decrease the reference counter; in this
+		 * case we have already cleared all pages.
+		 */
+		mmput(p->mm);
+	}
 
 	r = uv_cmd_nodata(p->handle, UVC_CMD_DESTROY_SEC_CONF, &rc, &rrc);
 	WARN_ONCE(r, "protvirt destroy vm failed rc %x rrc %x", rc, rrc);
@@ -241,7 +257,9 @@ static int deferred_destroy(struct kvm *kvm, struct deferred_priv *priv, u16 *rc
 	priv->old_table = (unsigned long)kvm->arch.gmap->table;
 	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
 
-	if (s390_replace_asce(kvm->arch.gmap))
+	if (!priv->has_mm)
+		s390_remove_old_asce(kvm->arch.gmap);
+	else if (s390_replace_asce(kvm->arch.gmap))
 		goto fail;
 
 	t = kthread_create(kvm_s390_pv_destroy_vm_thread, priv,
@@ -300,8 +318,9 @@ int kvm_s390_pv_deinit_vm_deferred(struct kvm *kvm, u16 *rc, u16 *rrc)
 
 	mmgrab(kvm->mm);
 	if (mmget_not_zero(kvm->mm)) {
+		priv->has_mm = true;
 		kvm_s390_clear_2g(kvm);
-	} else {
+	} else if (list_empty(&kvm->mm->context.deferred_list)) {
 		/* No deferred work to do */
 		mmdrop(kvm->mm);
 		kfree(priv);
-- 
2.31.1

