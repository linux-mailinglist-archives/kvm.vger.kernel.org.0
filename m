Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C81436600
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhJUP0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:26:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8522 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231624AbhJUP0K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:26:10 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEBJ9o022350;
        Thu, 21 Oct 2021 11:23:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=QpuFna1xX5sy6xRT97SECUImIxZyeGI772b9K7FKfDc=;
 b=qX3ct10BTVqBYFax7V3cgxF+zs2x/I6kYfhlqcY74cT5hJB28Lo8LTuEZ8i93566pORi
 g8WIN6aLJ23yJ8DM3Bqdgiq75FksNyo8k/WcIykfiw1mwDZzMJ2QW95f+t0jGRorXnc6
 dMsUTwC7cu61jRtt7HV8irKE/ddROlak0ArMG7RokE2yCXPJWLUM8tmsKe8m2qwiNcrg
 0xBfKtMAVpQ/Z8PYPeReb0uJk48ZY9TXxw5fINjLOQYSqe+4hv+tm/i+KH2xYYy9QGD+
 tPazHrA4of29XpMa1fhOhYzTMyDPXDyaqh5rCUSFJNpy+i4QESY9vgxQp6Z4zxNBzeDg ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bty9eqrxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:23:52 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19LFChIn009134;
        Thu, 21 Oct 2021 11:23:52 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bty9eqrwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:23:52 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LF49bY028003;
        Thu, 21 Oct 2021 15:23:50 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma05wdc.us.ibm.com with ESMTP id 3bqpccyq6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 15:23:50 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LFNnvP27787606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 15:23:49 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A291BE051;
        Thu, 21 Oct 2021 15:23:49 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4E42BE05B;
        Thu, 21 Oct 2021 15:23:44 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com.com (unknown [9.160.98.118])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 15:23:44 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v17 01/15] s390/vfio-ap: Set pqap hook when vfio_ap module is loaded
Date:   Thu, 21 Oct 2021 11:23:18 -0400
Message-Id: <20211021152332.70455-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021152332.70455-1-akrowiak@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: basTLTTw5JCvrp3mfTGEeXXaLqKx3vxs
X-Proofpoint-GUID: PZB5RJa2rrH50o1_ierJJzataucwyNwp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 clxscore=1015 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rather than storing the function pointer to the PQAP(AQIC) instruction
interception handler with the mediated device (struct ap_matrix_mdev) when
the vfio_ap device driver is notified that the KVM point is being set,
let's store it once in a global variable when the vfio_ap module is
loaded.

There are three reasons for doing this:

1. The lifetime of the interception handler function coincides with the
   lifetime of the vfio_ap module, so it makes little sense to tie it to
   the mediated device and complete sense to tie it to the module in which
   the function resides.

2. The setting/clearing of the function pointer is protected by a mutex
   lock. This increases the number of locks taken during
   VFIO_GROUP_NOTIFY_SET_KVM notification and increases the complexity of
   ensuring locking integrity and avoiding circular lock dependencies.

3. The lock will only be taken for writing twice: When the vfio_ap module
   is loaded; and, when the vfio_ap module is removed. As it stands now,
   the lock is taken for writing whenever a guest is started or terminated.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h      | 10 ++++--
 arch/s390/kvm/kvm-s390.c              |  1 -
 arch/s390/kvm/priv.c                  | 45 ++++++++++++++++++++++-----
 drivers/s390/crypto/vfio_ap_ops.c     | 27 ++++++++--------
 drivers/s390/crypto/vfio_ap_private.h |  1 -
 5 files changed, 58 insertions(+), 26 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index a604d51acfc8..05569d077d7f 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -799,16 +799,17 @@ struct kvm_s390_cpu_model {
 	unsigned short ibc;
 };
 
-typedef int (*crypto_hook)(struct kvm_vcpu *vcpu);
+struct kvm_s390_crypto_hook {
+	int (*fcn)(struct kvm_vcpu *vcpu);
+};
 
 struct kvm_s390_crypto {
 	struct kvm_s390_crypto_cb *crycb;
-	struct rw_semaphore pqap_hook_rwsem;
-	crypto_hook *pqap_hook;
 	__u32 crycbd;
 	__u8 aes_kw;
 	__u8 dea_kw;
 	__u8 apie;
+	void *data;
 };
 
 #define APCB0_MASK_SIZE 1
@@ -998,6 +999,9 @@ extern char sie_exit;
 extern int kvm_s390_gisc_register(struct kvm *kvm, u32 gisc);
 extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
 
+extern int kvm_s390_pqap_hook_register(struct kvm_s390_crypto_hook *hook);
+extern int kvm_s390_pqap_hook_unregister(struct kvm_s390_crypto_hook *hook);
+
 static inline void kvm_arch_hardware_disable(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6a6dd5e1daf6..c91981599328 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2649,7 +2649,6 @@ static void kvm_s390_crypto_init(struct kvm *kvm)
 {
 	kvm->arch.crypto.crycb = &kvm->arch.sie_page2->crycb;
 	kvm_s390_set_crycb_format(kvm);
-	init_rwsem(&kvm->arch.crypto.pqap_hook_rwsem);
 
 	if (!test_kvm_facility(kvm, 76))
 		return;
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 53da4ceb16a3..3d91ff934c0c 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -31,6 +31,39 @@
 #include "kvm-s390.h"
 #include "trace.h"
 
+DEFINE_MUTEX(pqap_hook_lock);
+static struct kvm_s390_crypto_hook *pqap_hook;
+
+int kvm_s390_pqap_hook_register(struct kvm_s390_crypto_hook *hook)
+{
+	int ret = 0;
+
+	mutex_lock(&pqap_hook_lock);
+	if (pqap_hook)
+		ret = -EACCES;
+	else
+		pqap_hook = hook;
+	mutex_unlock(&pqap_hook_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pqap_hook_register);
+
+int kvm_s390_pqap_hook_unregister(struct kvm_s390_crypto_hook *hook)
+{
+	int ret = 0;
+
+	mutex_lock(&pqap_hook_lock);
+	if (hook != pqap_hook)
+		ret = -EACCES;
+	else
+		pqap_hook = NULL;
+	mutex_unlock(&pqap_hook_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pqap_hook_unregister);
+
 static int handle_ri(struct kvm_vcpu *vcpu)
 {
 	vcpu->stat.instruction_ri++;
@@ -610,7 +643,6 @@ static int handle_io_inst(struct kvm_vcpu *vcpu)
 static int handle_pqap(struct kvm_vcpu *vcpu)
 {
 	struct ap_queue_status status = {};
-	crypto_hook pqap_hook;
 	unsigned long reg0;
 	int ret;
 	uint8_t fc;
@@ -659,16 +691,15 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	 * hook function pointer in the kvm_s390_crypto structure. Lock the
 	 * owner, retrieve the hook function pointer and call the hook.
 	 */
-	down_read(&vcpu->kvm->arch.crypto.pqap_hook_rwsem);
-	if (vcpu->kvm->arch.crypto.pqap_hook) {
-		pqap_hook = *vcpu->kvm->arch.crypto.pqap_hook;
-		ret = pqap_hook(vcpu);
+	mutex_lock(&pqap_hook_lock);
+	if (pqap_hook) {
+		ret = pqap_hook->fcn(vcpu);
 		if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)
 			kvm_s390_set_psw_cc(vcpu, 3);
-		up_read(&vcpu->kvm->arch.crypto.pqap_hook_rwsem);
+		mutex_unlock(&pqap_hook_lock);
 		return ret;
 	}
-	up_read(&vcpu->kvm->arch.crypto.pqap_hook_rwsem);
+	mutex_unlock(&pqap_hook_lock);
 	/*
 	 * A vfio_driver must register a hook.
 	 * No hook means no driver to enable the SIE CRYCB and no queues.
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 94c1c9bd58ad..02275d246b39 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -293,13 +293,10 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	apqn = vcpu->run->s.regs.gprs[0] & 0xffff;
 	mutex_lock(&matrix_dev->lock);
 
-	if (!vcpu->kvm->arch.crypto.pqap_hook)
-		goto out_unlock;
-	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
-				   struct ap_matrix_mdev, pqap_hook);
+	matrix_mdev = vcpu->kvm->arch.crypto.data;
 
 	/* If the there is no guest using the mdev, there is nothing to do */
-	if (!matrix_mdev->kvm)
+	if (!matrix_mdev || !matrix_mdev->kvm)
 		goto out_unlock;
 
 	q = vfio_ap_get_queue(matrix_mdev, apqn);
@@ -348,7 +345,6 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 
 	matrix_mdev->mdev = mdev;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
-	matrix_mdev->pqap_hook = handle_pqap;
 	mutex_lock(&matrix_dev->lock);
 	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
 	mutex_unlock(&matrix_dev->lock);
@@ -1078,10 +1074,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 	struct ap_matrix_mdev *m;
 
 	if (kvm->arch.crypto.crycbd) {
-		down_write(&kvm->arch.crypto.pqap_hook_rwsem);
-		kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
-		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
-
 		mutex_lock(&kvm->lock);
 		mutex_lock(&matrix_dev->lock);
 
@@ -1095,6 +1087,7 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 
 		kvm_get_kvm(kvm);
 		matrix_mdev->kvm = kvm;
+		kvm->arch.crypto.data = matrix_mdev;
 		kvm_arch_crypto_set_masks(kvm,
 					  matrix_mdev->matrix.apm,
 					  matrix_mdev->matrix.aqm,
@@ -1155,16 +1148,13 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev,
 				   struct kvm *kvm)
 {
 	if (kvm && kvm->arch.crypto.crycbd) {
-		down_write(&kvm->arch.crypto.pqap_hook_rwsem);
-		kvm->arch.crypto.pqap_hook = NULL;
-		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
-
 		mutex_lock(&kvm->lock);
 		mutex_lock(&matrix_dev->lock);
 
 		kvm_arch_crypto_clear_masks(kvm);
 		vfio_ap_mdev_reset_queues(matrix_mdev);
 		kvm_put_kvm(kvm);
+		kvm->arch.crypto.data = NULL;
 		matrix_mdev->kvm = NULL;
 
 		mutex_unlock(&kvm->lock);
@@ -1391,12 +1381,20 @@ static const struct mdev_parent_ops vfio_ap_matrix_ops = {
 	.supported_type_groups	= vfio_ap_mdev_type_groups,
 };
 
+static struct kvm_s390_crypto_hook pqap_hook = {
+	.fcn = handle_pqap,
+};
+
 int vfio_ap_mdev_register(void)
 {
 	int ret;
 
 	atomic_set(&matrix_dev->available_instances, MAX_ZDEV_ENTRIES_EXT);
 
+	ret = kvm_s390_pqap_hook_register(&pqap_hook);
+	if (ret)
+		return ret;
+
 	ret = mdev_register_driver(&vfio_ap_matrix_driver);
 	if (ret)
 		return ret;
@@ -1413,6 +1411,7 @@ int vfio_ap_mdev_register(void)
 
 void vfio_ap_mdev_unregister(void)
 {
+	WARN_ON(kvm_s390_pqap_hook_unregister(&pqap_hook));
 	mdev_unregister_device(&matrix_dev->device);
 	mdev_unregister_driver(&vfio_ap_matrix_driver);
 }
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 648fcaf8104a..907f41160de7 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -97,7 +97,6 @@ struct ap_matrix_mdev {
 	struct notifier_block group_notifier;
 	struct notifier_block iommu_notifier;
 	struct kvm *kvm;
-	crypto_hook pqap_hook;
 	struct mdev_device *mdev;
 };
 
-- 
2.31.1

