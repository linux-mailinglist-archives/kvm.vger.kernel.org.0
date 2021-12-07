Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F6846C5A6
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241578AbhLGVDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:03:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38838 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241575AbhLGVDb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:03:31 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Kmh7u013987;
        Tue, 7 Dec 2021 21:00:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=n1Lpp4vqSlBbRD7sktJcJenh8wJ/3ur41O205X9Md3U=;
 b=bebjMDlW7+FNc+UbzETKCjsXFP783TMY3TrYIJ1t54/iTFYgF7p1Qq+g+U7Jcu8bZJTl
 9GICaWZTNyX0wfFe3HssRzbKRHIVAX3k0kL+IGg2fpvQyYkRO+82+YcX3Pd9lXlHOf5r
 LokU42DMItdoRf83h3oKy6qmb701c/jwinG6HyXYeZhbsGvBCuprajmKeszl518qYmrA
 rAwCGNdZkuOCowXVxQdAHARb+vOAKAJE/7VZgBPvavWXbCUk4ek/RbvESEm7zM8GJARq
 ulD6G/ITMwZw/GeKRcRu20vFIPJ0GZ3OCxSNlkNVGjn811fhNRHinaLMPoiKzdc6DtWd 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cteynr57g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:59 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7Ks7eB013916;
        Tue, 7 Dec 2021 20:59:59 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cteynr56x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:59 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KwN4S001889;
        Tue, 7 Dec 2021 20:59:58 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 3cqyyamj4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:58 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7KxucE19857948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 20:59:56 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A89B6AE06A;
        Tue,  7 Dec 2021 20:59:56 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F51FAE063;
        Tue,  7 Dec 2021 20:59:51 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 20:59:51 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 23/32] KVM: s390: pci: handle refresh of PCI translations
Date:   Tue,  7 Dec 2021 15:57:34 -0500
Message-Id: <20211207205743.150299-24-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Du-eSNj64sisfeYiIP3gDbvj4ug4RqDz
X-Proofpoint-ORIG-GUID: d-Zkh1jbxw7UJWYXEd9VPF6bNC_1-dee
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 adultscore=0 impostorscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a routine that will perform a shadow operation between a guest
and host IOAT.  A subsequent patch will invoke this in response to
an 04 RPCIT instruction intercept.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h |   1 +
 arch/s390/include/asm/pci_dma.h |   1 +
 arch/s390/kvm/pci.c             | 191 ++++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h             |   4 +-
 4 files changed, 196 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 254275399f21..97e3a369135d 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -30,6 +30,7 @@ struct kvm_zdev_ioat {
 struct kvm_zdev {
 	struct zpci_dev *zdev;
 	struct kvm *kvm;
+	u64 rpcit_count;
 	struct kvm_zdev_ioat ioat;
 	struct zpci_fib fib;
 };
diff --git a/arch/s390/include/asm/pci_dma.h b/arch/s390/include/asm/pci_dma.h
index e1d3c1d3fc8a..0ca15e5db3d9 100644
--- a/arch/s390/include/asm/pci_dma.h
+++ b/arch/s390/include/asm/pci_dma.h
@@ -52,6 +52,7 @@ enum zpci_ioat_dtype {
 #define ZPCI_TABLE_ENTRIES		(ZPCI_TABLE_SIZE / ZPCI_TABLE_ENTRY_SIZE)
 #define ZPCI_TABLE_PAGES		(ZPCI_TABLE_SIZE >> PAGE_SHIFT)
 #define ZPCI_TABLE_ENTRIES_PAGES	(ZPCI_TABLE_ENTRIES * ZPCI_TABLE_PAGES)
+#define ZPCI_TABLE_ENTRIES_PER_PAGE	(ZPCI_TABLE_ENTRIES / ZPCI_TABLE_PAGES)
 
 #define ZPCI_TABLE_BITS			11
 #define ZPCI_PT_BITS			8
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index a1c0c0881332..858c5ecdc8b9 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -123,6 +123,195 @@ int kvm_s390_pci_aen_init(u8 nisc)
 	return rc;
 }
 
+static int dma_shadow_cpu_trans(struct kvm_vcpu *vcpu, unsigned long *entry,
+				unsigned long *gentry)
+{
+	unsigned long idx;
+	struct page *page;
+	void *gaddr = NULL;
+	kvm_pfn_t pfn;
+	gpa_t addr;
+	int rc = 0;
+
+	if (pt_entry_isvalid(*gentry)) {
+		/* pin and validate */
+		addr = *gentry & ZPCI_PTE_ADDR_MASK;
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		page = gfn_to_page(vcpu->kvm, gpa_to_gfn(addr));
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+		if (is_error_page(page))
+			return -EIO;
+		gaddr = page_to_virt(page) + (addr & ~PAGE_MASK);
+	}
+
+	if (pt_entry_isvalid(*entry)) {
+		/* Either we are invalidating, replacing or no-op */
+		if (gaddr) {
+			if ((*entry & ZPCI_PTE_ADDR_MASK) ==
+			    (unsigned long)gaddr) {
+				/* Duplicate */
+				kvm_release_pfn_dirty(*entry >> PAGE_SHIFT);
+			} else {
+				/* Replace */
+				pfn = (*entry >> PAGE_SHIFT);
+				invalidate_pt_entry(entry);
+				set_pt_pfaa(entry, gaddr);
+				validate_pt_entry(entry);
+				kvm_release_pfn_dirty(pfn);
+				rc = 1;
+			}
+		} else {
+			/* Invalidate */
+			pfn = (*entry >> PAGE_SHIFT);
+			invalidate_pt_entry(entry);
+			kvm_release_pfn_dirty(pfn);
+			rc = 1;
+		}
+	} else if (gaddr) {
+		/* New Entry */
+		set_pt_pfaa(entry, gaddr);
+		validate_pt_entry(entry);
+	}
+
+	return rc;
+}
+
+unsigned long *dma_walk_guest_cpu_trans(struct kvm_vcpu *vcpu,
+					struct kvm_zdev_ioat *ioat,
+					dma_addr_t dma_addr)
+{
+	unsigned long *rto, *sto, *pto;
+	unsigned int rtx, rts, sx, px, idx;
+	struct page *page;
+	gpa_t addr;
+	int i;
+
+	/* Pin guest segment table if needed */
+	rtx = calc_rtx(dma_addr);
+	rto = ioat->head[(rtx / ZPCI_TABLE_ENTRIES_PER_PAGE)];
+	rts = rtx * ZPCI_TABLE_PAGES;
+	if (!ioat->seg[rts]) {
+		if (!reg_entry_isvalid(rto[rtx % ZPCI_TABLE_ENTRIES_PER_PAGE]))
+			return NULL;
+		sto = get_rt_sto(rto[rtx % ZPCI_TABLE_ENTRIES_PER_PAGE]);
+		addr = ((u64)sto & ZPCI_RTE_ADDR_MASK);
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+			page = gfn_to_page(vcpu->kvm, gpa_to_gfn(addr));
+			if (is_error_page(page)) {
+				srcu_read_unlock(&vcpu->kvm->srcu, idx);
+				return NULL;
+			}
+			ioat->seg[rts + i] = page_to_virt(page) +
+					     (addr & ~PAGE_MASK);
+			addr += PAGE_SIZE;
+		}
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	}
+
+	/* Allocate pin pointers for another segment table if needed */
+	if (!ioat->pt[rtx]) {
+		ioat->pt[rtx] = kcalloc(ZPCI_TABLE_ENTRIES,
+					(sizeof(unsigned long *)), GFP_KERNEL);
+		if (!ioat->pt[rtx])
+			return NULL;
+	}
+	/* Pin guest page table if needed */
+	sx = calc_sx(dma_addr);
+	sto = ioat->seg[(rts + (sx / ZPCI_TABLE_ENTRIES_PER_PAGE))];
+	if (!ioat->pt[rtx][sx]) {
+		if (!reg_entry_isvalid(sto[sx % ZPCI_TABLE_ENTRIES_PER_PAGE]))
+			return NULL;
+		pto = get_st_pto(sto[sx % ZPCI_TABLE_ENTRIES_PER_PAGE]);
+		if (!pto)
+			return NULL;
+		addr = ((u64)pto & ZPCI_STE_ADDR_MASK);
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		page = gfn_to_page(vcpu->kvm, gpa_to_gfn(addr));
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+		if (is_error_page(page))
+			return NULL;
+		ioat->pt[rtx][sx] = page_to_virt(page) + (addr & ~PAGE_MASK);
+	}
+	pto = ioat->pt[rtx][sx];
+
+	/* Return guest PTE */
+	px = calc_px(dma_addr);
+	return &pto[px];
+}
+
+
+static int dma_table_shadow(struct kvm_vcpu *vcpu, struct zpci_dev *zdev,
+			    dma_addr_t dma_addr, size_t size)
+{
+	unsigned int nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	struct kvm_zdev *kzdev = zdev->kzdev;
+	unsigned long *entry, *gentry;
+	int i, rc = 0, rc2;
+
+	if (!nr_pages || !kzdev)
+		return -EINVAL;
+
+	mutex_lock(&kzdev->ioat.lock);
+	if (!zdev->dma_table || !kzdev->ioat.head[0]) {
+		rc = -EINVAL;
+		goto out_unlock;
+	}
+
+	for (i = 0; i < nr_pages; i++) {
+		gentry = dma_walk_guest_cpu_trans(vcpu, &kzdev->ioat, dma_addr);
+		if (!gentry)
+			continue;
+		entry = dma_walk_cpu_trans(zdev->dma_table, dma_addr);
+
+		if (!entry) {
+			rc = -ENOMEM;
+			goto out_unlock;
+		}
+
+		rc2 = dma_shadow_cpu_trans(vcpu, entry, gentry);
+		if (rc2 < 0) {
+			rc = -EIO;
+			goto out_unlock;
+		}
+		dma_addr += PAGE_SIZE;
+		rc += rc2;
+	}
+
+out_unlock:
+	mutex_unlock(&kzdev->ioat.lock);
+	return rc;
+}
+
+int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
+			       unsigned long start, unsigned long size)
+{
+	struct zpci_dev *zdev;
+	u32 fh;
+	int rc;
+
+	/* If the device has a SHM bit on, let userspace take care of this */
+	fh = req >> 32;
+	if ((fh & aift.mdd) != 0)
+		return -EOPNOTSUPP;
+
+	/* Make sure this is a valid device associated with this guest */
+	zdev = get_zdev_by_fh(fh);
+	if (!zdev || !zdev->kzdev || zdev->kzdev->kvm != vcpu->kvm)
+		return -EINVAL;
+
+	/* Only proceed if the device is using the assist */
+	if (zdev->kzdev->ioat.head[0] == 0)
+		return -EOPNOTSUPP;
+
+	rc = dma_table_shadow(vcpu, zdev, start, size);
+	if (rc > 0)
+		rc = zpci_refresh_trans((u64) zdev->fh << 32, start, size);
+	zdev->kzdev->rpcit_count++;
+
+	return rc;
+}
+
 /* Modify PCI: Register floating adapter interruption forwarding */
 static int kvm_zpci_set_airq(struct zpci_dev *zdev)
 {
@@ -590,4 +779,6 @@ void kvm_s390_pci_init(void)
 {
 	spin_lock_init(&aift.gait_lock);
 	mutex_init(&aift.lock);
+
+	WARN_ON(zpci_get_mdd(&aift.mdd));
 }
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index 3c86888fe1b3..d252a631b693 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -33,6 +33,7 @@ struct zpci_aift {
 	struct kvm_zdev **kzdev;
 	spinlock_t gait_lock; /* Protects the gait, used during AEN forward */
 	struct mutex lock; /* Protects the other structures in aift */
+	u32 mdd;
 };
 
 static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
@@ -47,7 +48,8 @@ struct zpci_aift *kvm_s390_pci_get_aift(void);
 
 int kvm_s390_pci_aen_init(u8 nisc);
 void kvm_s390_pci_aen_exit(void);
-
+int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
+			       unsigned long start, unsigned long end);
 void kvm_s390_pci_init(void);
 
 #endif /* __KVM_S390_PCI_H */
-- 
2.27.0

