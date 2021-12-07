Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16EBE46C561
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 21:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239146AbhLGVCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:02:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20392 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239267AbhLGVB7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:01:59 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KMTAM024463;
        Tue, 7 Dec 2021 20:58:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=HKDd1vF50KWEuKEzJoYxhqHT3nZ3owgeY2MiCJS1B9Y=;
 b=W+efO01K305mTnj0UcLGtUwWz/PaDecJW5I2344ZFXCnmFn78+glpqeii/xNXNHTEKbl
 7+hGu7FQ0JzFdisxqiDwjgMApFLYojSanvombibcqjXRycJdblSbmE5OKa5cs5GC6Ved
 s9908uk0LSuLkAdcp+kR4MMByf2t8MaJMqSykslVUbpYZAX57CP3tkBASHoJ/Q3fcsCI
 eqMJUvsr9XLTVWAauoIk//VVcRlpG/SCp61Ny21Vjo/3VANUuW1Bp6dDm/rd82AyMOqJ
 3yRHu7exgH7FBavZAjk8eA2lj/1USawRZOq6vZlGPnohi1q3P/aumVle5VrJvTDZW88m Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctekg0k9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:58:27 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KOrO6006818;
        Tue, 7 Dec 2021 20:58:27 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctekg0k9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:58:27 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KvnHT006788;
        Tue, 7 Dec 2021 20:58:26 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04wdc.us.ibm.com with ESMTP id 3cqyyamjw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:58:26 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7KwPt722217530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 20:58:25 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BEDCAE066;
        Tue,  7 Dec 2021 20:58:25 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C8C1AE063;
        Tue,  7 Dec 2021 20:58:20 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 20:58:20 +0000 (GMT)
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
Subject: [PATCH 06/32] s390/airq: allow for airq structure that uses an input vector
Date:   Tue,  7 Dec 2021 15:57:17 -0500
Message-Id: <20211207205743.150299-7-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mGfIzN36wNMjBTzjNS-_mpUf2G4Oa1dz
X-Proofpoint-ORIG-GUID: K5V7cw5w8dKBIW0j4sE8rGI_9mQ9TbpN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 suspectscore=0 priorityscore=1501 mlxlogscore=875
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When doing device passthrough where interrupts are being forwarded
from host to guest, we wish to use a pinned section of guest memory
as the vector (the same memory used by the guest as the vector).

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/airq.h     |  4 +++-
 arch/s390/pci/pci_irq.c          |  8 ++++----
 drivers/s390/cio/airq.c          | 10 +++++++---
 drivers/s390/virtio/virtio_ccw.c |  2 +-
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/airq.h b/arch/s390/include/asm/airq.h
index 7918a7d09028..e82e5626e139 100644
--- a/arch/s390/include/asm/airq.h
+++ b/arch/s390/include/asm/airq.h
@@ -47,8 +47,10 @@ struct airq_iv {
 #define AIRQ_IV_PTR		4	/* Allocate the ptr array */
 #define AIRQ_IV_DATA		8	/* Allocate the data array */
 #define AIRQ_IV_CACHELINE	16	/* Cacheline alignment for the vector */
+#define AIRQ_IV_GUESTVEC	32	/* Vector is a pinned guest page */
 
-struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags);
+struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags,
+			       unsigned long *vec);
 void airq_iv_release(struct airq_iv *iv);
 unsigned long airq_iv_alloc(struct airq_iv *iv, unsigned long num);
 void airq_iv_free(struct airq_iv *iv, unsigned long bit, unsigned long num);
diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index 880bcd73f11a..dfd4f3276a6d 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -296,7 +296,7 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 		zdev->aisb = bit;
 
 		/* Create adapter interrupt vector */
-		zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA | AIRQ_IV_BITLOCK);
+		zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA | AIRQ_IV_BITLOCK, 0);
 		if (!zdev->aibv)
 			return -ENOMEM;
 
@@ -421,7 +421,7 @@ static int __init zpci_directed_irq_init(void)
 	union zpci_sic_iib iib = {{0}};
 	unsigned int cpu;
 
-	zpci_sbv = airq_iv_create(num_possible_cpus(), 0);
+	zpci_sbv = airq_iv_create(num_possible_cpus(), 0, 0);
 	if (!zpci_sbv)
 		return -ENOMEM;
 
@@ -443,7 +443,7 @@ static int __init zpci_directed_irq_init(void)
 		zpci_ibv[cpu] = airq_iv_create(cache_line_size() * BITS_PER_BYTE,
 					       AIRQ_IV_DATA |
 					       AIRQ_IV_CACHELINE |
-					       (!cpu ? AIRQ_IV_ALLOC : 0));
+					(!cpu ? AIRQ_IV_ALLOC : 0), 0);
 		if (!zpci_ibv[cpu])
 			return -ENOMEM;
 	}
@@ -460,7 +460,7 @@ static int __init zpci_floating_irq_init(void)
 	if (!zpci_ibv)
 		return -ENOMEM;
 
-	zpci_sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC);
+	zpci_sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC, 0);
 	if (!zpci_sbv)
 		goto out_free;
 
diff --git a/drivers/s390/cio/airq.c b/drivers/s390/cio/airq.c
index 2f2226786319..375a58b1c838 100644
--- a/drivers/s390/cio/airq.c
+++ b/drivers/s390/cio/airq.c
@@ -122,10 +122,12 @@ static inline unsigned long iv_size(unsigned long bits)
  * airq_iv_create - create an interrupt vector
  * @bits: number of bits in the interrupt vector
  * @flags: allocation flags
+ * @vec: pointer to pinned guest memory if AIRQ_IV_GUESTVEC
  *
  * Returns a pointer to an interrupt vector structure
  */
-struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
+struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags,
+			       unsigned long *vec)
 {
 	struct airq_iv *iv;
 	unsigned long size;
@@ -146,6 +148,8 @@ struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
 					     &iv->vector_dma);
 		if (!iv->vector)
 			goto out_free;
+	} else if (flags & AIRQ_IV_GUESTVEC) {
+		iv->vector = vec;
 	} else {
 		iv->vector = cio_dma_zalloc(size);
 		if (!iv->vector)
@@ -185,7 +189,7 @@ struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
 	kfree(iv->avail);
 	if (iv->flags & AIRQ_IV_CACHELINE && iv->vector)
 		dma_pool_free(airq_iv_cache, iv->vector, iv->vector_dma);
-	else
+	else if (!(iv->flags & AIRQ_IV_GUESTVEC))
 		cio_dma_free(iv->vector, size);
 	kfree(iv);
 out:
@@ -204,7 +208,7 @@ void airq_iv_release(struct airq_iv *iv)
 	kfree(iv->bitlock);
 	if (iv->flags & AIRQ_IV_CACHELINE)
 		dma_pool_free(airq_iv_cache, iv->vector, iv->vector_dma);
-	else
+	else if (!(iv->flags & AIRQ_IV_GUESTVEC))
 		cio_dma_free(iv->vector, iv_size(iv->bits));
 	kfree(iv->avail);
 	kfree(iv);
diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 52c376d15978..ff84f45587be 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -241,7 +241,7 @@ static struct airq_info *new_airq_info(int index)
 		return NULL;
 	rwlock_init(&info->lock);
 	info->aiv = airq_iv_create(VIRTIO_IV_BITS, AIRQ_IV_ALLOC | AIRQ_IV_PTR
-				   | AIRQ_IV_CACHELINE);
+				| AIRQ_IV_CACHELINE, 0);
 	if (!info->aiv) {
 		kfree(info);
 		return NULL;
-- 
2.27.0

