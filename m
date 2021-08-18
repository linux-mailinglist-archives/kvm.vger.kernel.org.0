Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890A63F04A6
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 15:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237395AbhHRN1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 09:27:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236993AbhHRN1H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 09:27:07 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ID2tmo131673;
        Wed, 18 Aug 2021 09:26:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=27slXD3Y7o5k12p033188Z4V+R5GoVkuvNOzohMAd3g=;
 b=sK7y2ltIHllpRIg7ukHR2DLcJtzKAfX9yI9uKzjIHhVJcivpYz6yhho4RSC99/I68uAO
 AbYZGH+Luz3IItZMv8ydODLkHkgogOJ9ltPMqLRrhIEJGcqYa9ho5A+bNKDDctqK1Z5b
 imXrSjt6rssgEJ+AFPDHsLF1oozKpq4BzxaGve8uhRleBnwxuIxAWVPEbQtRZBiSg3Iq
 AbOa6+PJD2c6R7zJE4XwRHb61JZG9sWbDfrEGv8E+VeH5Kf+JikYUsfYo0qsJHnH4YQz
 R9xP3S00P6AwsxeXSiDiUUJszxnZGwW2nUlSf1PW/tYjsCbIwNWQ0jO7GI0nt3YVn1yR 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3agp1yknmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:26:31 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17ID2wBB131961;
        Wed, 18 Aug 2021 09:26:31 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3agp1yknkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:26:31 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IDCeim014904;
        Wed, 18 Aug 2021 13:26:29 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3afwrhtehh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 13:26:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IDMvRL61800816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 13:22:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 759C14C046;
        Wed, 18 Aug 2021 13:26:24 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC07F4C050;
        Wed, 18 Aug 2021 13:26:23 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.177])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 13:26:23 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v4 05/14] KVM: s390: pv: leak the ASCE page when destroy fails
Date:   Wed, 18 Aug 2021 15:26:11 +0200
Message-Id: <20210818132620.46770-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818132620.46770-1-imbrenda@linux.ibm.com>
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 035iyZJkmzpwP9ANpc0uRlnm_aM_Weg-
X-Proofpoint-GUID: c7MRnumkwfA5jLSgeFmAKB-2erH11Ysl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_04:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 impostorscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a protected VM is created, the topmost level of page tables of its
ASCE is marked by the Ultravisor; any attempt to use that memory for
protected virtualization will result in failure.

Only a successful Destroy Configuration UVC will remove the marking.

When the Destroy Configuration UVC fails, the topmost level of page
tables of the VM does not get its marking cleared; to avoid issues it
must not be used again.

This is a permanent error and the page becomes in practice unusable, so
we set it aside and leak it.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |  2 ++
 arch/s390/kvm/pv.c           |  4 ++-
 arch/s390/mm/gmap.c          | 55 ++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 40264f60b0da..746e18bf8984 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -148,4 +148,6 @@ void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
 			     unsigned long gaddr, unsigned long vmaddr);
 int gmap_mark_unmergeable(void);
 void s390_reset_acc(struct mm_struct *mm);
+void s390_remove_old_asce(struct gmap *gmap);
+int s390_replace_asce(struct gmap *gmap);
 #endif /* _ASM_S390_GMAP_H */
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 00d272d134c2..76b0d64ce8fa 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -168,9 +168,11 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	atomic_set(&kvm->mm->context.is_protected, 0);
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
 	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
-	/* Inteded memory leak on "impossible" error */
+	/* Intended memory leak on "impossible" error */
 	if (!cc)
 		kvm_s390_pv_dealloc_vm(kvm);
+	else
+		s390_replace_asce(kvm->arch.gmap);
 	return cc ? -EIO : 0;
 }
 
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 9bb2c7512cd5..5a138f6220c4 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2706,3 +2706,58 @@ void s390_reset_acc(struct mm_struct *mm)
 	mmput(mm);
 }
 EXPORT_SYMBOL_GPL(s390_reset_acc);
+
+/*
+ * Remove the topmost level of page tables from the list of page tables of
+ * the gmap.
+ * This means that it will not be freed when the VM is torn down, and needs
+ * to be handled separately by the caller, unless an intentional leak is
+ * intended.
+ */
+void s390_remove_old_asce(struct gmap *gmap)
+{
+	struct page *old;
+
+	old = virt_to_page(gmap->table);
+	spin_lock(&gmap->guest_table_lock);
+	list_del(&old->lru);
+	spin_unlock(&gmap->guest_table_lock);
+	/* in case the ASCE needs to be "removed" multiple times */
+	INIT_LIST_HEAD(&old->lru);
+}
+EXPORT_SYMBOL_GPL(s390_remove_old_asce);
+
+/*
+ * Try to replace the current ASCE with another equivalent one.
+ * If the allocation of the new top level page table fails, the ASCE is not
+ * replaced.
+ * In any case, the old ASCE is removed from the list, therefore the caller
+ * has to make sure to save a pointer to it beforehands, unless an
+ * intentional leak is intended.
+ */
+int s390_replace_asce(struct gmap *gmap)
+{
+	unsigned long asce;
+	struct page *page;
+	void *table;
+
+	s390_remove_old_asce(gmap);
+
+	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
+	if (!page)
+		return -ENOMEM;
+	table = page_to_virt(page);
+	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
+
+	spin_lock(&gmap->guest_table_lock);
+	list_add(&page->lru, &gmap->crst_list);
+	spin_unlock(&gmap->guest_table_lock);
+
+	asce = (gmap->asce & ~PAGE_MASK) | __pa(table);
+	WRITE_ONCE(gmap->asce, asce);
+	WRITE_ONCE(gmap->mm->context.gmap_asce, asce);
+	WRITE_ONCE(gmap->table, table);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(s390_replace_asce);
-- 
2.31.1

