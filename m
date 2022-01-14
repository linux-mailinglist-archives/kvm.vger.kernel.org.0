Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8BD48F164
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244945AbiANUdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:33:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45242 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244573AbiANUce (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:34 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EKPoMk026177;
        Fri, 14 Jan 2022 20:32:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hB5M2YwZaXA6KrkFpe8A2fbdPnlXqaAJFjzZdYhFQaI=;
 b=a6I4/D2jHK8JfGd6OGiv4yjJdbHxmpDiRRneeou9zVRlRLq1Qh84Wbo1HY5PIFL1fKTt
 /SBdQQCXt5uxVYmm0h13uEzB60YIuXqTjat91dYp7dKok3AJeZFTztAcwocWAUWe7Pn7
 N5LXCX9fwOgtS0hhsAhFNG0AgO1U80gCwScrkZd1ZLEmlZdpES0TMV+2iADlaxaMcnNY
 oTvWoTK61b092au5k0BlhjA20SS18xwNOdIjTgvU/ZkxbG13sG4QH4cpbZcAYB/x73KQ
 tnlCp7bjyDZBHZiku1b94jDPkCD0OQyt8t4Eh+4PHqFunD5fnrKMVNmBhvt2co/1iSKf Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkg72r44m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:33 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKWWAW015947;
        Fri, 14 Jan 2022 20:32:33 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkg72r446-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:32 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKMYJM018427;
        Fri, 14 Jan 2022 20:32:31 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3df28cqdn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:31 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWUSx29360458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:30 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CBD8C6065;
        Fri, 14 Jan 2022 20:32:30 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60648C6069;
        Fri, 14 Jan 2022 20:32:28 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:28 +0000 (GMT)
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
Subject: [PATCH v2 20/30] KVM: s390: pci: provide routines for enabling/disabling IOAT assist
Date:   Fri, 14 Jan 2022 15:31:35 -0500
Message-Id: <20220114203145.242984-21-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: m1_kFpthsUlWh2nzDx1j5mzCBfdYiY_Y
X-Proofpoint-GUID: umnMqzT2c3oE-A2DWtBj6k9xC48fDASF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These routines will be wired into the vfio_pci_zdev ioctl handlers to
respond to requests to enable / disable a device for PCI I/O Address
Translation assistance.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h |  15 ++++
 arch/s390/include/asm/pci_dma.h |   2 +
 arch/s390/kvm/pci.c             | 139 ++++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h             |   2 +
 4 files changed, 158 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 01fe14fffd7a..770849f13a70 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -16,11 +16,21 @@
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/pci.h>
+#include <linux/mutex.h>
 #include <asm/pci_insn.h>
+#include <asm/pci_dma.h>
+
+struct kvm_zdev_ioat {
+	unsigned long *head[ZPCI_TABLE_PAGES];
+	unsigned long **seg;
+	unsigned long ***pt;
+	struct mutex lock;
+};
 
 struct kvm_zdev {
 	struct zpci_dev *zdev;
 	struct kvm *kvm;
+	struct kvm_zdev_ioat ioat;
 	struct zpci_fib fib;
 };
 
@@ -33,6 +43,11 @@ int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
 			    bool assist);
 int kvm_s390_pci_aif_disable(struct zpci_dev *zdev);
 
+int kvm_s390_pci_ioat_probe(struct zpci_dev *zdev);
+int kvm_s390_pci_ioat_enable(struct zpci_dev *zdev, u64 iota);
+int kvm_s390_pci_ioat_disable(struct zpci_dev *zdev);
+u8 kvm_s390_pci_get_dtsm(struct zpci_dev *zdev);
+
 int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
 int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
 int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
diff --git a/arch/s390/include/asm/pci_dma.h b/arch/s390/include/asm/pci_dma.h
index 91e63426bdc5..69e616d0712c 100644
--- a/arch/s390/include/asm/pci_dma.h
+++ b/arch/s390/include/asm/pci_dma.h
@@ -50,6 +50,8 @@ enum zpci_ioat_dtype {
 #define ZPCI_TABLE_ALIGN		ZPCI_TABLE_SIZE
 #define ZPCI_TABLE_ENTRY_SIZE		(sizeof(unsigned long))
 #define ZPCI_TABLE_ENTRIES		(ZPCI_TABLE_SIZE / ZPCI_TABLE_ENTRY_SIZE)
+#define ZPCI_TABLE_PAGES		(ZPCI_TABLE_SIZE >> PAGE_SHIFT)
+#define ZPCI_TABLE_ENTRIES_PAGES	(ZPCI_TABLE_ENTRIES * ZPCI_TABLE_PAGES)
 
 #define ZPCI_TABLE_BITS			11
 #define ZPCI_PT_BITS			8
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 7ed9abc476b6..39c13c25a700 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -13,12 +13,15 @@
 #include <asm/pci.h>
 #include <asm/pci_insn.h>
 #include <asm/pci_io.h>
+#include <asm/pci_dma.h>
 #include <asm/sclp.h>
 #include "pci.h"
 #include "kvm-s390.h"
 
 struct zpci_aift *aift;
 
+#define shadow_ioat_init zdev->kzdev->ioat.head[0]
+
 static inline int __set_irq_noiib(u16 ctl, u8 isc)
 {
 	union zpci_sic_iib iib = {{0}};
@@ -344,6 +347,135 @@ int kvm_s390_pci_aif_disable(struct zpci_dev *zdev)
 }
 EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_disable);
 
+int kvm_s390_pci_ioat_probe(struct zpci_dev *zdev)
+{
+	/* Must have a KVM association registered */
+	if (!zdev->kzdev || !zdev->kzdev->kvm)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_ioat_probe);
+
+int kvm_s390_pci_ioat_enable(struct zpci_dev *zdev, u64 iota)
+{
+	gpa_t gpa = (gpa_t)(iota & ZPCI_RTE_ADDR_MASK);
+	struct kvm_zdev_ioat *ioat;
+	struct page *page;
+	struct kvm *kvm;
+	unsigned int idx;
+	void *iaddr;
+	int i, rc = 0;
+
+	if (shadow_ioat_init)
+		return -EINVAL;
+
+	/* Ensure supported type specified */
+	if ((iota & ZPCI_IOTA_RTTO_FLAG) != ZPCI_IOTA_RTTO_FLAG)
+		return -EINVAL;
+
+	kvm = zdev->kzdev->kvm;
+	ioat = &zdev->kzdev->ioat;
+	mutex_lock(&ioat->lock);
+	idx = srcu_read_lock(&kvm->srcu);
+	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+		page = gfn_to_page(kvm, gpa_to_gfn(gpa));
+		if (is_error_page(page)) {
+			srcu_read_unlock(&kvm->srcu, idx);
+			rc = -EIO;
+			goto out;
+		}
+		iaddr = page_to_virt(page) + (gpa & ~PAGE_MASK);
+		ioat->head[i] = (unsigned long *)iaddr;
+		gpa += PAGE_SIZE;
+	}
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	zdev->kzdev->ioat.seg = kcalloc(ZPCI_TABLE_ENTRIES_PAGES,
+					sizeof(unsigned long *), GFP_KERNEL);
+	if (!zdev->kzdev->ioat.seg)
+		goto unpin;
+	zdev->kzdev->ioat.pt = kcalloc(ZPCI_TABLE_ENTRIES,
+				       sizeof(unsigned long **), GFP_KERNEL);
+	if (!zdev->kzdev->ioat.pt)
+		goto free_seg;
+
+out:
+	mutex_unlock(&ioat->lock);
+	return rc;
+
+free_seg:
+	kfree(zdev->kzdev->ioat.seg);
+unpin:
+	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+		kvm_release_pfn_dirty((u64)ioat->head[i] >> PAGE_SHIFT);
+		ioat->head[i] = 0;
+	}
+	mutex_unlock(&ioat->lock);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_ioat_enable);
+
+static void free_pt_entry(struct kvm_zdev_ioat *ioat, int st, int pt)
+{
+	if (!ioat->pt[st][pt])
+		return;
+
+	kvm_release_pfn_dirty((u64)ioat->pt[st][pt]);
+}
+
+static void free_seg_entry(struct kvm_zdev_ioat *ioat, int entry)
+{
+	int i, st, count = 0;
+
+	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+		if (ioat->seg[entry + i]) {
+			kvm_release_pfn_dirty((u64)ioat->seg[entry + i]);
+			count++;
+		}
+	}
+
+	if (count == 0)
+		return;
+
+	st = entry / ZPCI_TABLE_PAGES;
+	for (i = 0; i < ZPCI_TABLE_ENTRIES; i++)
+		free_pt_entry(ioat, st, i);
+	kfree(ioat->pt[st]);
+}
+
+int kvm_s390_pci_ioat_disable(struct zpci_dev *zdev)
+{
+	struct kvm_zdev_ioat *ioat;
+	int i;
+
+	if (!shadow_ioat_init)
+		return -EINVAL;
+
+	ioat = &zdev->kzdev->ioat;
+	mutex_lock(&ioat->lock);
+	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+		kvm_release_pfn_dirty((u64)ioat->head[i] >> PAGE_SHIFT);
+		ioat->head[i] = 0;
+	}
+
+	for (i = 0; i < ZPCI_TABLE_ENTRIES_PAGES; i += ZPCI_TABLE_PAGES)
+		free_seg_entry(ioat, i);
+
+	kfree(ioat->seg);
+	kfree(ioat->pt);
+	mutex_unlock(&ioat->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_ioat_disable);
+
+u8 kvm_s390_pci_get_dtsm(struct zpci_dev *zdev)
+{
+	return (zdev->dtsm & KVM_S390_PCI_DTSM_MASK);
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_get_dtsm);
+
 int kvm_s390_pci_interp_probe(struct zpci_dev *zdev)
 {
 	/* Must have appropriate hardware facilities */
@@ -424,6 +556,10 @@ int kvm_s390_pci_interp_disable(struct zpci_dev *zdev)
 	if (zdev->kzdev->fib.fmt0.aibv != 0)
 		kvm_s390_pci_aif_disable(zdev);
 
+	/* If we are using the IOAT assist, disable it now */
+	if (zdev->kzdev->ioat.head[0])
+		kvm_s390_pci_ioat_disable(zdev);
+
 	/* Remove the host CLP guest designation */
 	zdev->gd = 0;
 
@@ -453,6 +589,8 @@ int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
 	if (!kzdev)
 		return -ENOMEM;
 
+	mutex_init(&kzdev->ioat.lock);
+
 	kzdev->zdev = zdev;
 	zdev->kzdev = kzdev;
 
@@ -467,6 +605,7 @@ void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
 	kzdev = zdev->kzdev;
 	WARN_ON(kzdev->zdev != zdev);
 	zdev->kzdev = 0;
+	mutex_destroy(&kzdev->ioat.lock);
 	kfree(kzdev);
 }
 EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_release);
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index 387b637863c9..54355634df82 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -16,6 +16,8 @@
 #include <asm/airq.h>
 #include <asm/kvm_pci.h>
 
+#define KVM_S390_PCI_DTSM_MASK 0x40
+
 struct zpci_gaite {
 	u32 gisa;
 	u8 gisc;
-- 
2.27.0

