Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13FE436619
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhJUP0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:26:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26782 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231984AbhJUP0c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:26:32 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LFN031013708;
        Thu, 21 Oct 2021 11:24:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sZHANLSp089XwmJ39HHGPasnOPwHzdyAISXjYIE4RsI=;
 b=moOblz9INYaFHXuabe1gALkjiJU0+boyP15YkqU5L+dxK/KoTiUObJSov9HMlJcyilra
 qI/qoowHqyyFcuNvmV1PGa1pcOwC7bRoAbWPkRCw4COWTQKwUKmbqiRRRNnDm9cr0wjL
 sQOdbIlm6I0sPaC4C4qiQW3Lst9lXZ9AjUlm8VU70E6ZhPLNdSGHHtkqjJwjs61dXKLf
 MsArTRYTeywTLYciIXc3GFpwyl6Frjm3CfpZfAosiXs4XqAruB+fwlECHDSmzcKuc+nP
 b5NwVimY84KXEdvwGcs9pVUzao+7OaA2lO4H2CYJUXsraoeyKVjh4ki41vaapsLkdeyB tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3buat480tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:24:15 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19LFOAGB016063;
        Thu, 21 Oct 2021 11:24:14 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3buat480t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:24:14 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LF2LmB000337;
        Thu, 21 Oct 2021 15:24:13 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 3bqpcdr763-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 15:24:13 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LFOBN629032708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 15:24:11 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B4EFBE065;
        Thu, 21 Oct 2021 15:24:11 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AC5BBE082;
        Thu, 21 Oct 2021 15:24:09 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com.com (unknown [9.160.98.118])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 15:24:09 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v17 10/15] s390/vfio-ap: reset queues after adapter/domain unassignment
Date:   Thu, 21 Oct 2021 11:23:27 -0400
Message-Id: <20211021152332.70455-11-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021152332.70455-1-akrowiak@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CBBaJuzkiGzdd1ylRBLK61omss01zYsi
X-Proofpoint-ORIG-GUID: b-wI5zaAzor42pd-UGuGQsjVHM7DXUPU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an adapter or domain is unassigned from an mdev providing the AP
configuration to a running KVM guest, one or more of the guest's queues may
get dynamically removed. Since the removed queues could get re-assigned to
another mdev, they need to be reset. So, when an adapter or domain is
unassigned from the mdev, the queues that are removed from the guest's
AP configuration will be reset.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 136 +++++++++++++++++++-------
 drivers/s390/crypto/vfio_ap_private.h |   2 +
 2 files changed, 100 insertions(+), 38 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 5a484e7afbd0..6b292ed30ada 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -24,9 +24,10 @@
 #define VFIO_AP_MDEV_TYPE_HWVIRT "passthrough"
 #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
 
-static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev);
+static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
+static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry);
 
 /**
  * vfio_ap_mdev_get_queue - retrieve a queue with a specific APQN from a
@@ -352,6 +353,7 @@ static bool vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev)
 	unsigned long apid, apqi, apqn;
 	DECLARE_BITMAP(shadow_apm, AP_DEVICES);
 	DECLARE_BITMAP(shadow_aqm, AP_DOMAINS);
+	struct vfio_ap_queue *q;
 
 	ret = ap_qci(&matrix_dev->info);
 	if (ret)
@@ -383,7 +385,8 @@ static bool vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev)
 			 * filter the APQI.
 			 */
 			apqn = AP_MKQID(apid, apqi);
-			if (!vfio_ap_mdev_get_queue(matrix_mdev, apqn)) {
+			q = vfio_ap_mdev_get_queue(matrix_mdev, apqn);
+			if (!q || q->reset_rc) {
 				clear_bit_inv(apid,
 					      matrix_mdev->shadow_apcb.apm);
 				break;
@@ -466,12 +469,6 @@ static void vfio_ap_unlink_mdev_fr_queue(struct vfio_ap_queue *q)
 	q->matrix_mdev = NULL;
 }
 
-static void vfio_ap_mdev_unlink_queue(struct vfio_ap_queue *q)
-{
-	vfio_ap_unlink_queue_fr_mdev(q);
-	vfio_ap_unlink_mdev_fr_queue(q);
-}
-
 static void vfio_ap_mdev_unlink_fr_queues(struct ap_matrix_mdev *matrix_mdev)
 {
 	struct vfio_ap_queue *q;
@@ -495,7 +492,7 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 	vfio_unregister_group_dev(&matrix_mdev->vdev);
 
 	mutex_lock(&matrix_dev->lock);
-	vfio_ap_mdev_reset_queues(matrix_mdev);
+	vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
 	vfio_ap_mdev_unlink_fr_queues(matrix_mdev);
 	list_del(&matrix_mdev->node);
 	mutex_unlock(&matrix_dev->lock);
@@ -732,17 +729,59 @@ static ssize_t assign_adapter_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(assign_adapter);
 
+static void vfio_ap_unlink_apqn_fr_mdev(struct ap_matrix_mdev *matrix_mdev,
+					unsigned long apid, unsigned long apqi,
+					struct ap_queue_table *qtable)
+{
+	struct vfio_ap_queue *q;
+
+	q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
+	/* If the queue is assigned to the matrix mdev, unlink it. */
+	if (q)
+		vfio_ap_unlink_queue_fr_mdev(q);
+
+	/* If the queue is assigned to the APCB, store it in @qtable. */
+	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
+	    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
+		hash_add(qtable->queues, &q->mdev_qnode, q->apqn);
+}
+
+/**
+ * vfio_ap_mdev_unlink_adapter - unlink all queues associated with unassigned
+ *				 adapter from the matrix mdev to which the
+ *				 adapter was assigned.
+ * @matrix_mdev: the matrix mediated device to which the adapter was assigned.
+ * @apid: the APID of the unassigned adapter.
+ * @qtable: table for storing queues associated with unassigned adapter.
+ */
 static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev *matrix_mdev,
-					unsigned long apid)
+					unsigned long apid,
+					struct ap_queue_table *qtable)
 {
 	unsigned long apqi;
+
+	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS)
+		vfio_ap_unlink_apqn_fr_mdev(matrix_mdev, apid, apqi, qtable);
+}
+
+static void vfio_ap_mdev_hot_unplug_adapter(struct ap_matrix_mdev *matrix_mdev,
+					    unsigned long apid)
+{
+	int bkt;
 	struct vfio_ap_queue *q;
+	struct ap_queue_table qtable;
+
+	hash_init(qtable.queues);
+	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid, &qtable);
 
-	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
-		q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
+	if (vfio_ap_mdev_filter_matrix(matrix_mdev))
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
 
-		if (q)
-			vfio_ap_mdev_unlink_queue(q);
+	vfio_ap_mdev_reset_queues(&qtable);
+
+	hash_for_each(qtable.queues, bkt, q, mdev_qnode) {
+		vfio_ap_unlink_mdev_fr_queue(q);
+		hash_del(&q->mdev_qnode);
 	}
 }
 
@@ -778,11 +817,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	vfio_ap_mdev_get_locks(matrix_mdev);
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
-	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
-
-	if (vfio_ap_mdev_filter_matrix(matrix_mdev))
-		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
-
+	vfio_ap_mdev_hot_unplug_adapter(matrix_mdev, apid);
 	vfio_ap_mdev_put_locks(matrix_mdev);
 
 	return count;
@@ -867,16 +902,33 @@ static ssize_t assign_domain_store(struct device *dev,
 static DEVICE_ATTR_WO(assign_domain);
 
 static void vfio_ap_mdev_unlink_domain(struct ap_matrix_mdev *matrix_mdev,
-				       unsigned long apqi)
+				       unsigned long apqi,
+				       struct ap_queue_table *qtable)
 {
 	unsigned long apid;
+
+	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES)
+		vfio_ap_unlink_apqn_fr_mdev(matrix_mdev, apid, apqi, qtable);
+}
+
+static void vfio_ap_mdev_hot_unplug_domain(struct ap_matrix_mdev *matrix_mdev,
+					   unsigned long apqi)
+{
+	int bkt;
 	struct vfio_ap_queue *q;
+	struct ap_queue_table qtable;
 
-	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
-		q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
+	hash_init(qtable.queues);
+	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi, &qtable);
+
+	if (vfio_ap_mdev_filter_matrix(matrix_mdev))
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+
+	vfio_ap_mdev_reset_queues(&qtable);
 
-		if (q)
-			vfio_ap_mdev_unlink_queue(q);
+	hash_for_each(qtable.queues, bkt, q, mdev_qnode) {
+		vfio_ap_unlink_mdev_fr_queue(q);
+		hash_del(&q->mdev_qnode);
 	}
 }
 
@@ -912,11 +964,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 
 	vfio_ap_mdev_get_locks(matrix_mdev);
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
-	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
-
-	if (vfio_ap_mdev_filter_matrix(matrix_mdev))
-		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
-
+	vfio_ap_mdev_hot_unplug_domain(matrix_mdev, apqi);
 	vfio_ap_mdev_put_locks(matrix_mdev);
 
 	return count;
@@ -1243,7 +1291,7 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 		mutex_lock(&matrix_dev->lock);
 
 		kvm_arch_crypto_clear_masks(matrix_mdev->guest->kvm);
-		vfio_ap_mdev_reset_queues(matrix_mdev);
+		vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
 		matrix_mdev->guest->kvm->arch.crypto.data = NULL;
 		kvm_put_kvm(matrix_mdev->guest->kvm);
 
@@ -1299,12 +1347,14 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
 
 	if (!q)
 		return 0;
+	q->reset_rc = 0;
 
 retry_zapq:
 	status = ap_zapq(q->apqn);
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
 		ret = 0;
+		q->reset_rc = status.response_code;
 		break;
 	case AP_RESPONSE_RESET_IN_PROGRESS:
 		if (retry--) {
@@ -1316,13 +1366,20 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
 	case AP_RESPONSE_Q_NOT_AVAIL:
 	case AP_RESPONSE_DECONFIGURED:
 	case AP_RESPONSE_CHECKSTOPPED:
-		WARN_ON_ONCE(status.irq_enabled);
+		WARN_ONCE(status.irq_enabled,
+			  "PQAP/ZAPQ for %02x.%04x failed with rc=%u while IRQ enabled",
+			  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
+			  status.response_code);
+		q->reset_rc = status.response_code;
 		ret = -EBUSY;
 		goto free_resources;
 	default:
 		/* things are really broken, give up */
-		WARN(true, "PQAP/ZAPQ completed with invalid rc (%x)\n",
+		WARN(true,
+		     "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",
+		     AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
 		     status.response_code);
+		q->reset_rc = status.response_code;
 		return -EIO;
 	}
 
@@ -1333,7 +1390,8 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
 		msleep(20);
 		status = ap_tapq(q->apqn, NULL);
 	}
-	WARN_ON_ONCE(retry2 <= 0);
+	WARN_ONCE(retry2 <= 0, "unable to verify reset of queue %02x.%04x",
+		  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn));
 
 free_resources:
 	vfio_ap_free_aqic_resources(q);
@@ -1341,20 +1399,22 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
 	return ret;
 }
 
-static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev)
+static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable)
 {
-	int ret, bkt, rc = 0;
+	int rc = 0, ret, bkt;
 	struct vfio_ap_queue *q;
 
-	hash_for_each(matrix_mdev->qtable.queues, bkt, q, mdev_qnode) {
+	hash_for_each(qtable->queues, bkt, q, mdev_qnode) {
 		ret = vfio_ap_mdev_reset_queue(q, 1);
 		/*
 		 * Regardless whether a queue turns out to be busy, or
 		 * is not operational, we need to continue resetting
 		 * the remaining queues.
 		 */
-		if (ret)
+		if (ret) {
 			rc = ret;
+			q->reset_rc = ret;
+		}
 	}
 
 	return rc;
@@ -1434,7 +1494,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 		ret = vfio_ap_mdev_get_device_info(arg);
 		break;
 	case VFIO_DEVICE_RESET:
-		ret = vfio_ap_mdev_reset_queues(matrix_mdev);
+		ret = vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
 		break;
 	default:
 		ret = -EOPNOTSUPP;
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 0e825ffbd0cc..5d59bba8b153 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -131,6 +131,7 @@ struct ap_matrix_mdev {
  * @apqn: the APQN of the AP queue device
  * @saved_isc: the guest ISC registered with the GIB interface
  * @mdev_qnode: allows the vfio_ap_queue struct to be added to a hashtable
+ * @reset_rc: the status response code from the last reset of the queue
  */
 struct vfio_ap_queue {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -139,6 +140,7 @@ struct vfio_ap_queue {
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
 	struct hlist_node mdev_qnode;
+	unsigned int reset_rc;
 };
 
 int vfio_ap_mdev_register(void);
-- 
2.31.1

