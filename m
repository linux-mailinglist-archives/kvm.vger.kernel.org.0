Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5064C2C336A
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 22:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388213AbgKXVlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 16:41:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34402 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733062AbgKXVkj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 16:40:39 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLYBZA152335;
        Tue, 24 Nov 2020 16:40:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lq2z1krvXHYnEj2PzVCoWrS85f8DswI9yBR/ra4XL3I=;
 b=EVrgMkHGvb9JtTFqLieZxD9Asu19iJNzdG5zGmrq+rrAbKSBrtKbSH1wQ2AyDqI2FNdZ
 5bHyPRJ/6Dpwwpen05Ufjeyoeq2EITYkMueDGBQ2wmQ4gnnk+AtstM1s0RQnzg4q8l/W
 o4YNnQfQ40cej8EPSQw0CozKIjLJgLl48+eRq8Kn1A7UE1Af+fwyFsNiY21uFVwGGQGP
 bHVYwAAXduw19tpqH8IIQOSeDJ1vM59M2G31qyFBq9/GNbZ/r/Wub1//u86ry/K9gx+O
 Qb528ihnNe8if+bk+1DFnprCdHq36VYmLc34eVaRYk4n/RLW/i/qqwdzsa7ut8bZwor/ Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350n10y770-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:35 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AOLY02a149663;
        Tue, 24 Nov 2020 16:40:35 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350n10y769-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:34 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLbMPF009348;
        Tue, 24 Nov 2020 21:40:33 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02wdc.us.ibm.com with ESMTP id 34xth92kq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 21:40:33 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOLeWY59437944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 21:40:32 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29908AE060;
        Tue, 24 Nov 2020 21:40:32 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29FEEAE05C;
        Tue, 24 Nov 2020 21:40:31 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.195.249])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 21:40:31 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v12 05/17] s390/vfio-ap: manage link between queue struct and matrix mdev
Date:   Tue, 24 Nov 2020 16:40:04 -0500
Message-Id: <20201124214016.3013-6-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201124214016.3013-1-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_09:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=11
 malwarescore=0 mlxlogscore=999 spamscore=0 clxscore=1015 phishscore=0
 bulkscore=0 mlxscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's create links between each queue device bound to the vfio_ap device
driver and the matrix mdev to which the queue is assigned. The idea is to
facilitate efficient retrieval of the objects representing the queue
devices and matrix mdevs as well as to verify that a queue assigned to
a matrix mdev is bound to the driver.

The links will be created as follows:

   * When the queue device is probed, if its APQN is assigned to a matrix
     mdev, the structures representing the queue device and the matrix mdev
     will be linked.

   * When an adapter or domain is assigned to a matrix mdev, for each new
     APQN assigned that references a queue device bound to the vfio_ap
     device driver, the structures representing the queue device and the
     matrix mdev will be linked.

The links will be removed as follows:

   * When the queue device is removed, if its APQN is assigned to a matrix
     mdev, the structures representing the queue device and the matrix mdev
     will be unlinked.

   * When an adapter or domain is unassigned from a matrix mdev, for each
     APQN unassigned that references a queue device bound to the vfio_ap
     device driver, the structures representing the queue device and the
     matrix mdev will be unlinked.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 161 +++++++++++++++++++++++---
 drivers/s390/crypto/vfio_ap_private.h |   3 +
 2 files changed, 146 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index dc699fd54505..07caf871943c 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -28,7 +28,6 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
 
 /**
  * vfio_ap_get_queue: Retrieve a queue with a specific APQN.
- * @matrix_mdev: the associated mediated matrix
  * @apqn: The queue APQN
  *
  * Retrieve a queue with a specific APQN from the AP queue devices attached to
@@ -36,32 +35,36 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
  *
  * Returns the pointer to the vfio_ap_queue with the specified APQN, or NULL.
  */
-static struct vfio_ap_queue *vfio_ap_get_queue(
-					struct ap_matrix_mdev *matrix_mdev,
-					int apqn)
+static struct vfio_ap_queue *vfio_ap_get_queue(int apqn)
 {
 	struct ap_queue *queue;
 	struct vfio_ap_queue *q = NULL;
 
-	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
-		return NULL;
-	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
-		return NULL;
-
 	queue = ap_get_qdev(apqn);
 	if (!queue)
 		return NULL;
 
 	put_device(&queue->ap_dev.device);
 
-	if (queue->ap_dev.device.driver == &matrix_dev->vfio_ap_drv->driver) {
+	if (queue->ap_dev.device.driver == &matrix_dev->vfio_ap_drv->driver)
 		q = dev_get_drvdata(&queue->ap_dev.device);
-		q->matrix_mdev = matrix_mdev;
-	}
 
 	return q;
 }
 
+static struct vfio_ap_queue *
+vfio_ap_mdev_get_queue(struct ap_matrix_mdev *matrix_mdev, unsigned long apqn)
+{
+	struct vfio_ap_queue *q;
+
+	hash_for_each_possible(matrix_mdev->qtable, q, mdev_qnode, apqn) {
+		if (q && (q->apqn == apqn))
+			return q;
+	}
+
+	return NULL;
+}
+
 /**
  * vfio_ap_wait_for_irqclear
  * @apqn: The AP Queue number
@@ -172,7 +175,6 @@ static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
 		  status.response_code);
 end_free:
 	vfio_ap_free_aqic_resources(q);
-	q->matrix_mdev = NULL;
 	return status;
 }
 
@@ -288,7 +290,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
 				   struct ap_matrix_mdev, pqap_hook);
 
-	q = vfio_ap_get_queue(matrix_mdev, apqn);
+	q = vfio_ap_mdev_get_queue(matrix_mdev, apqn);
 	if (!q)
 		goto out_unlock;
 
@@ -331,6 +333,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 
 	matrix_mdev->mdev = mdev;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
+	hash_init(matrix_mdev->qtable);
 	mdev_set_drvdata(mdev, matrix_mdev);
 	matrix_mdev->pqap_hook.hook = handle_pqap;
 	matrix_mdev->pqap_hook.owner = THIS_MODULE;
@@ -559,6 +562,87 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
 	return 0;
 }
 
+enum qlink_action {
+	LINK_APID,
+	LINK_APQI,
+	UNLINK_APID,
+	UNLINK_APQI,
+};
+
+static void vfio_ap_mdev_link_queue(struct ap_matrix_mdev *matrix_mdev,
+				    unsigned long apid, unsigned long apqi)
+{
+	struct vfio_ap_queue *q;
+
+	q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
+	if (q) {
+		q->matrix_mdev = matrix_mdev;
+		hash_add(matrix_mdev->qtable,
+			 &q->mdev_qnode, q->apqn);
+	}
+}
+
+static void vfio_ap_mdev_unlink_queue(unsigned long apid, unsigned long apqi)
+{
+	struct vfio_ap_queue *q;
+
+	q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
+	if (q) {
+		q->matrix_mdev = NULL;
+		hash_del(&q->mdev_qnode);
+	}
+}
+
+/**
+ * vfio_ap_mdev_manage_qlinks
+ *
+ * @matrix_mdev: The matrix mdev to link.
+ * @action:	 The action to take on @qlink_id.
+ * @qlink_id:	 The APID or APQI of the queues to link.
+ *
+ * Sets or clears the links between the queues with the specified @qlink_id
+ * and the @matrix_mdev:
+ *	@action == LINK_APID:	Set the links between the @matrix_mdev and the
+ *				queues with the specified @qlink_id (APID)
+ *	@action == LINK_APQI:	Set the links between the @matrix_mdev and the
+ *				queues with the specified @qlink_id (APQI)
+ *	@action == UNLINK_APID:	Clear the links between the @matrix_mdev and the
+ *				queues with the specified @qlink_id (APID)
+ *	@action == UNLINK_APQI:	Clear the links between the @matrix_mdev and the
+ *				queues with the specified @qlink_id (APQI)
+ */
+static void vfio_ap_mdev_manage_qlinks(struct ap_matrix_mdev *matrix_mdev,
+				       enum qlink_action action,
+				       unsigned long qlink_id)
+{
+	unsigned long id;
+
+	switch (action) {
+	case LINK_APID:
+		for_each_set_bit_inv(id, matrix_mdev->matrix.aqm,
+				     matrix_mdev->matrix.aqm_max + 1)
+			vfio_ap_mdev_link_queue(matrix_mdev, qlink_id, id);
+		break;
+	case UNLINK_APID:
+		for_each_set_bit_inv(id, matrix_mdev->matrix.aqm,
+				     matrix_mdev->matrix.aqm_max + 1)
+			vfio_ap_mdev_unlink_queue(qlink_id, id);
+		break;
+	case LINK_APQI:
+		for_each_set_bit_inv(id, matrix_mdev->matrix.apm,
+				     matrix_mdev->matrix.apm_max + 1)
+			vfio_ap_mdev_link_queue(matrix_mdev, id, qlink_id);
+		break;
+	case UNLINK_APQI:
+		for_each_set_bit_inv(id, matrix_mdev->matrix.apm,
+				     matrix_mdev->matrix.apm_max + 1)
+			vfio_ap_mdev_link_queue(matrix_mdev, id, qlink_id);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+}
+
 /**
  * assign_adapter_store
  *
@@ -628,6 +712,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 	if (ret)
 		goto share_err;
 
+	vfio_ap_mdev_manage_qlinks(matrix_mdev, LINK_APID, apid);
 	ret = count;
 	goto done;
 
@@ -679,6 +764,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
+	vfio_ap_mdev_manage_qlinks(matrix_mdev, UNLINK_APID, apid);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -769,6 +855,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	if (ret)
 		goto share_err;
 
+	vfio_ap_mdev_manage_qlinks(matrix_mdev, LINK_APQI, apqi);
 	ret = count;
 	goto done;
 
@@ -821,6 +908,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
+	vfio_ap_mdev_manage_qlinks(matrix_mdev, UNLINK_APQI, apqi);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -1155,6 +1243,11 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
 			     matrix_mdev->matrix.apm_max + 1) {
 		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
 				     matrix_mdev->matrix.aqm_max + 1) {
+			q = vfio_ap_mdev_get_queue(matrix_mdev,
+						   AP_MKQID(apid, apqi));
+			if (!q)
+				continue;
+
 			ret = vfio_ap_mdev_reset_queue(apid, apqi, 1);
 			/*
 			 * Regardless whether a queue turns out to be busy, or
@@ -1164,9 +1257,7 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
 			if (ret)
 				rc = ret;
 
-			q = vfio_ap_get_queue(matrix_mdev, AP_MKQID(apid, apqi);
-			if (q)
-				vfio_ap_free_aqic_resources(q);
+			vfio_ap_free_aqic_resources(q);
 		}
 	}
 
@@ -1292,6 +1383,29 @@ void vfio_ap_mdev_unregister(void)
 	mdev_unregister_device(&matrix_dev->device);
 }
 
+/*
+ * vfio_ap_queue_link_mdev
+ *
+ * @q: The queue to link with the matrix mdev.
+ *
+ * Links @q with the matrix mdev to which the queue's APQN is assigned.
+ */
+static void vfio_ap_queue_link_mdev(struct vfio_ap_queue *q)
+{
+	unsigned long apid = AP_QID_CARD(q->apqn);
+	unsigned long apqi = AP_QID_QUEUE(q->apqn);
+	struct ap_matrix_mdev *matrix_mdev;
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
+		    test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
+			q->matrix_mdev = matrix_mdev;
+			hash_add(matrix_mdev->qtable, &q->mdev_qnode, q->apqn);
+			break;
+		}
+	}
+}
+
 /**
  * vfio_ap_mdev_probe_queue:
  *
@@ -1305,9 +1419,13 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	q = kzalloc(sizeof(*q), GFP_KERNEL);
 	if (!q)
 		return -ENOMEM;
+	mutex_lock(&matrix_dev->lock);
 	dev_set_drvdata(&apdev->device, q);
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
+	vfio_ap_queue_link_mdev(q);
+	mutex_unlock(&matrix_dev->lock);
+
 	return 0;
 }
 
@@ -1328,7 +1446,14 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	apid = AP_QID_CARD(q->apqn);
 	apqi = AP_QID_QUEUE(q->apqn);
 	vfio_ap_mdev_reset_queue(apid, apqi, 1);
-	vfio_ap_irq_disable(q);
+	if (q->matrix_mdev) {
+		if (q->matrix_mdev->kvm) {
+			vfio_ap_free_aqic_resources(q);
+			kvm_put_kvm(q->matrix_mdev->kvm);
+		}
+		hash_del(&q->mdev_qnode);
+		q->matrix_mdev = NULL;
+	}
 	kfree(q);
 	mutex_unlock(&matrix_dev->lock);
 }
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index d9003de4fbad..4e5cc72fc0db 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/kvm_host.h>
+#include <linux/hashtable.h>
 
 #include "ap_bus.h"
 
@@ -86,6 +87,7 @@ struct ap_matrix_mdev {
 	struct kvm *kvm;
 	struct kvm_s390_module_hook pqap_hook;
 	struct mdev_device *mdev;
+	DECLARE_HASHTABLE(qtable, 8);
 };
 
 extern int vfio_ap_mdev_register(void);
@@ -97,6 +99,7 @@ struct vfio_ap_queue {
 	int	apqn;
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
+	struct hlist_node mdev_qnode;
 };
 
 int vfio_ap_mdev_probe_queue(struct ap_device *queue);
-- 
2.21.1

