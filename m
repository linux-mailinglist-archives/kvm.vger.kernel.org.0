Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5565D4AA1F0
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241589AbiBDVRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:17:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48400 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235523AbiBDVQa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:16:30 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214Jx4el016005;
        Fri, 4 Feb 2022 21:16:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hmcK15jmALasJ7KT7q+FT1Rdo+H8SgNMDwkoL8KHQaE=;
 b=DzAnGAs7xAGV592O2X6ej+o3meh9M6LjhL7rfebZcRNRFtRbO9teibG4xnjc8+6NqJUs
 01jlFQqqQ8qnguD/gfzTcfQBFj5GDPCSD8y42Qjx4X0NX19jzoJKQzuwJ54pz5KhkYjF
 pZI6a4YYQpiEYCFYlvTRyYhVlpGEztTacrVKlKkzhxY2pBKaPGa1VL+szHvU5t9bJHX9
 D5A5eCMm1bFmc3nT8AU5Q2x9l8nCpIJ8ElYRUwRCd7LL+UbRNyqoinvT0fIELgVFcMBN
 YYs7wmde2x/WdJLaYpko5F2EURVar94br1679tiUJ18dB3zqhJ0kubDaNhYC6YkGjHX5 hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0rt5nn0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:29 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214LDP3b016537;
        Fri, 4 Feb 2022 21:16:29 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0rt5nn09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:29 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LCf8U011927;
        Fri, 4 Feb 2022 21:16:28 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 3e0r0m2wk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:28 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LGRA931785378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:16:27 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15C0F136065;
        Fri,  4 Feb 2022 21:16:27 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59823136055;
        Fri,  4 Feb 2022 21:16:25 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:16:25 +0000 (GMT)
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
Subject: [PATCH v3 22/30] KVM: s390: pci: handle refresh of PCI translations
Date:   Fri,  4 Feb 2022 16:15:28 -0500
Message-Id: <20220204211536.321475-23-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: x4oF1JHi-K5m-tIH3gbYPqXqq3uaw-D3
X-Proofpoint-ORIG-GUID: otz9KLY0R_XXqStTwBTvwgWglrlWq4YT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
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
 arch/s390/kvm/pci.c             | 201 +++++++++++++++++++++++++++++++-
 arch/s390/kvm/pci.h             |   8 +-
 4 files changed, 209 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 370d6ba041fe..e4696f5592e1 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -29,6 +29,7 @@ struct kvm_zdev_ioat {
 struct kvm_zdev {
 	struct zpci_dev *zdev;
 	struct kvm *kvm;
+	u64 rpcit_count;
 	struct kvm_zdev_ioat ioat;
 	struct zpci_fib fib;
 };
diff --git a/arch/s390/include/asm/pci_dma.h b/arch/s390/include/asm/pci_dma.h
index 69e616d0712c..38004e0a4383 100644
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
index fa9d6ac1755b..6e1bd20d3552 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -159,6 +159,201 @@ int kvm_s390_pci_aen_init(u8 nisc)
 	return rc;
 }
 
+static int dma_shadow_cpu_trans(struct kvm_vcpu *vcpu, unsigned long *entry,
+				unsigned long *gentry)
+{
+	phys_addr_t gaddr = 0;
+	unsigned long idx;
+	struct page *page;
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
+		gaddr = page_to_phys(page) + (addr & ~PAGE_MASK);
+	}
+
+	if (pt_entry_isvalid(*entry)) {
+		/* Either we are invalidating, replacing or no-op */
+		if (gaddr != 0) {
+			if ((*entry & ZPCI_PTE_ADDR_MASK) == gaddr) {
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
+	} else if (gaddr != 0) {
+		/* New Entry */
+		set_pt_pfaa(entry, gaddr);
+		validate_pt_entry(entry);
+	}
+
+	return rc;
+}
+
+static unsigned long *dma_walk_guest_cpu_trans(struct kvm_vcpu *vcpu,
+					       struct kvm_zdev_ioat *ioat,
+					       dma_addr_t dma_addr)
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
+	mutex_lock(&kzdev->ioat.ioat_lock);
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
+	mutex_unlock(&kzdev->ioat.ioat_lock);
+	return rc;
+}
+
+int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
+			       unsigned long start, unsigned long size,
+			       u8 *status)
+{
+	struct zpci_dev *zdev;
+	u32 fh = req >> 32;
+	int rc;
+
+	/* Make sure this is a valid device associated with this guest */
+	zdev = get_zdev_by_fh(fh);
+	if (!zdev || !zdev->kzdev || zdev->kzdev->kvm != vcpu->kvm) {
+		*status = 0;
+		return -EINVAL;
+	}
+
+	/* Only proceed if the device is using the assist */
+	if (zdev->kzdev->ioat.head[0] == 0)
+		return -EOPNOTSUPP;
+
+	rc = dma_table_shadow(vcpu, zdev, start, size);
+	if (rc < 0) {
+		/*
+		 * If errors encountered during shadow operations, we must
+		 * fabricate status to present to the guest
+		 */
+		*status = KVM_S390_RPCIT_INS_RES;
+	} else if (rc > 0) {
+		/* Host RPCIT must be issued */
+		rc = zpci_refresh_trans((u64) zdev->fh << 32, start, size,
+					status);
+	}
+	zdev->kzdev->rpcit_count++;
+
+	return rc;
+}
+
 /* Modify PCI: Register floating adapter interruption forwarding */
 static int kvm_zpci_set_airq(struct zpci_dev *zdev)
 {
@@ -640,6 +835,8 @@ EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_release);
 
 int kvm_s390_pci_init(void)
 {
+	int rc;
+
 	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
 	if (!aift)
 		return -ENOMEM;
@@ -647,5 +844,7 @@ int kvm_s390_pci_init(void)
 	spin_lock_init(&aift->gait_lock);
 	mutex_init(&aift->aift_lock);
 
-	return 0;
+	rc = zpci_get_mdd(&aift->mdd);
+
+	return rc;
 }
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index 0fa0e3d61aaa..a409680a1dc2 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -18,6 +18,9 @@
 
 #define KVM_S390_PCI_DTSM_MASK 0x40
 
+#define KVM_S390_RPCIT_INS_RES 0x10
+#define KVM_S390_RPCIT_ERR 0x28
+
 struct zpci_gaite {
 	u32 gisa;
 	u8 gisc;
@@ -33,6 +36,7 @@ struct zpci_aift {
 	struct kvm_zdev **kzdev;
 	spinlock_t gait_lock; /* Protects the gait, used during AEN forward */
 	struct mutex aift_lock; /* Protects the other structures in aift */
+	u32 mdd;
 };
 
 extern struct zpci_aift *aift;
@@ -48,7 +52,9 @@ static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
 
 int kvm_s390_pci_aen_init(u8 nisc);
 void kvm_s390_pci_aen_exit(void);
-
+int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
+			       unsigned long start, unsigned long end,
+			       u8 *status);
 int kvm_s390_pci_init(void);
 
 #endif /* __KVM_S390_PCI_H */
-- 
2.27.0

