Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4DB4A9C82
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 16:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376400AbiBDPyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 10:54:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26780 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376337AbiBDPyD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 10:54:03 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214FBOWq013668;
        Fri, 4 Feb 2022 15:54:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ALXddWXGqYghc3z+XYSeJTK1pdCl2IzGsHKRtSeggok=;
 b=WsVgrL2gRNsxHnv8jAK1BalifiuyObDiDJHb8kDrvcE4SKwvDxTPkBEcCO302hwFk4CJ
 XO1EN+M7NMmKcI7mRv9kPgOVlwWdL5DnEPCtxJDWRJm+JO0NkdHU9NqG8wZhZ+RRAj+w
 vX+E+HZqupW+zP8BuMpURslNW6dJ2C/cXotxgUyuRsn6cF2R11pB2QbbvDZcMrSH1PrR
 PEpxw80CGIGMjmrs6GxUyq85xHCVnKq7Axv1eJTfCr3Um//Q+MwmVwHNB6v+ukUHPcza
 JdvanJXUVC5U44Yjs28mmooPL2s2gP8UE1IPh1tc3IqfHOKTJX2bBUTM3cHYjM8tChLi 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx40sjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:03 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214FDoQR032698;
        Fri, 4 Feb 2022 15:54:02 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx40shw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214FlSJs022560;
        Fri, 4 Feb 2022 15:54:00 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3e0r0u6ajx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214FruXT33358284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 15:53:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1B67AE053;
        Fri,  4 Feb 2022 15:53:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C240AE058;
        Fri,  4 Feb 2022 15:53:56 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.8.50])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 15:53:56 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: [PATCH v7 10/17] KVM: s390: pv: add mmu_notifier
Date:   Fri,  4 Feb 2022 16:53:42 +0100
Message-Id: <20220204155349.63238-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204155349.63238-1-imbrenda@linux.ibm.com>
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: k2CAzf-98HA9q3tchVMLHwJyUYo3iFKn
X-Proofpoint-GUID: nA_S38EsFuuJmV1jfZnYBHX70KqIjIH4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0
 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an mmu_notifier for protected VMs. The callback function is
triggered when the mm is torn down, and will attempt to convert all
protected vCPUs to non-protected. This allows the mm teardown to use
the destroy page UVC instead of export.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/kvm/pv.c               | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index a22c9266ea05..1bccb8561ba9 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -19,6 +19,7 @@
 #include <linux/kvm.h>
 #include <linux/seqlock.h>
 #include <linux/module.h>
+#include <linux/mmu_notifier.h>
 #include <asm/debug.h>
 #include <asm/cpu.h>
 #include <asm/fpu/api.h>
@@ -921,6 +922,7 @@ struct kvm_s390_pv {
 	u64 guest_len;
 	unsigned long stor_base;
 	void *stor_var;
+	struct mmu_notifier mmu_notifier;
 };
 
 struct kvm_arch{
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index f1e812a45acb..d3b8fd9b5b3e 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -193,6 +193,21 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	return -EIO;
 }
 
+static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
+					     struct mm_struct *mm)
+{
+	struct kvm *kvm = container_of(subscription, struct kvm, arch.pv.mmu_notifier);
+	u16 dummy;
+
+	mutex_lock(&kvm->lock);
+	kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);
+	mutex_unlock(&kvm->lock);
+}
+
+static const struct mmu_notifier_ops kvm_s390_pv_mmu_notifier_ops = {
+	.release = kvm_s390_pv_mmu_notifier_release,
+};
+
 int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	struct uv_cb_cgc uvcb = {
@@ -234,6 +249,11 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 		return -EIO;
 	}
 	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
+	/* Add the notifier only once. No races because we hold kvm->lock */
+	if (kvm->arch.pv.mmu_notifier.ops != &kvm_s390_pv_mmu_notifier_ops) {
+		kvm->arch.pv.mmu_notifier.ops = &kvm_s390_pv_mmu_notifier_ops;
+		mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
+	}
 	return 0;
 }
 
-- 
2.34.1

