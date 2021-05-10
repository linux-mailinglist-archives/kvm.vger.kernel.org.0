Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D381379474
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 18:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhEJQqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 12:46:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9402 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232065AbhEJQpy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 12:45:54 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AGXIHv059074;
        Mon, 10 May 2021 12:44:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0N7RqCxhfZ7vLTijeeRj1JD1RKso95cnDLzgdeUfsrY=;
 b=EFF3bTaxMB/ObB+koJUCXC92AsjyQidphHiiaVt5D3PGTtJvyoRec2vWyEhz1wckyIKo
 CIrmgjsZ7+/c59ibJsj3uCBz7etzaf2cZbdnsI5a7Dcpe9mle97QCovubz653Pqzo15d
 WNsb+4okEwMEoXoKY0cWl2i7p/yXo59ln2bLq2a7vFMIVFGgrBAOjVu/hWoxUx9SKw3h
 FgkImoPWbcIA/Y4T/FB9eje3TZ/l20YG2dbo2K4oW0UY+V4IMPHTPb53OqHylSN66fuX
 Cc5jKwqcQNoe9NGmI+S21KON5B9pBPt/uNLSX8C6L3gmRXCMKM80emd7duGxsA+7l1au TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f7y6976g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 12:44:46 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AGXL3M060340;
        Mon, 10 May 2021 12:44:45 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f7y69761-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 12:44:45 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AGWIuP018134;
        Mon, 10 May 2021 16:44:44 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02wdc.us.ibm.com with ESMTP id 38dj997pkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 16:44:44 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AGig4M32571712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 16:44:42 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCA53AE05F;
        Mon, 10 May 2021 16:44:42 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 607B2AE063;
        Mon, 10 May 2021 16:44:40 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com.com (unknown [9.85.140.234])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 16:44:40 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v16 09/14] s390/vfio-ap: reset queues after adapter/domain unassignment
Date:   Mon, 10 May 2021 12:44:18 -0400
Message-Id: <20210510164423.346858-10-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510164423.346858-1-akrowiak@linux.ibm.com>
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aT3Fi2amq3DJaKuUoZidzpnSt8PbGp1r
X-Proofpoint-GUID: liUYFBYEM3b3pcjMIiikOIEi_JhRgPFU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_09:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an adapter or domain is unassigned from an mdev providing the AP
configuration to a KVM guest, one or more of the guest's queues may get
dynamically removed. Since the removed queues could get re-assigned to
another mdev, they need to be reset. So, when an adapter or domain is
unassigned from the mdev, the queues that are removed from the guest's
AP configuration will be reset.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 155 +++++++++++++++++++++++---
 drivers/s390/crypto/vfio_ap_private.h |   1 +
 2 files changed, 138 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e388eaf4f601..48e3db2f1c28 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -25,6 +25,8 @@
 #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
 
 static int vfio_ap_mdev_reset_queues(struct ap_matrix *matrix);
+static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
+				    unsigned int retry);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 
 static struct vfio_ap_queue *
@@ -488,12 +490,6 @@ static void vfio_ap_mdev_unlink_fr_queue(struct vfio_ap_queue *q)
 	q->matrix_mdev = NULL;
 }
 
-static void vfio_ap_mdev_unlink_queue(struct vfio_ap_queue *q)
-{
-	vfio_ap_mdev_unlink_queue_fr_mdev(q);
-	vfio_ap_mdev_unlink_fr_queue(q);
-}
-
 static void vfio_ap_mdev_unlink_fr_queues(struct ap_matrix_mdev *matrix_mdev)
 {
 	struct vfio_ap_queue *q;
@@ -740,8 +736,20 @@ static ssize_t assign_adapter_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(assign_adapter);
 
-static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev *matrix_mdev,
-					unsigned long apid)
+/*
+ * vfio_ap_unlink_adapter_fr_mdev
+ *
+ * @matrix_mdev: a pointer to the mdev currently in use by the KVM guest
+ * @apqi: the APID of the adapter that was unassigned from the mdev
+ * @qlist: a pointer to a list to which the queues unlinked from the mdev
+ *         will be stored.
+ *
+ * Unlinks the queues associated with the adapter from the mdev. Each queue that
+ * is unlinked will be added to @qlist.
+ */
+static void vfio_ap_unlink_adapter_fr_mdev(struct ap_matrix_mdev *matrix_mdev,
+					   unsigned long apid,
+					   struct list_head *qlist)
 {
 	unsigned long apqi;
 	struct vfio_ap_queue *q;
@@ -749,11 +757,79 @@ static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev *matrix_mdev,
 	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
 		q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
 
-		if (q)
-			vfio_ap_mdev_unlink_queue(q);
+		if (q) {
+			vfio_ap_mdev_unlink_queue_fr_mdev(q);
+			list_add(&q->qlist_node, qlist);
+		}
 	}
 }
 
+/*
+ * vfio_ap_reset_queues_removed
+ *
+ * @guest_apcb: a pointer to a matrix object containing the values from the
+ *		  guest's APCB prior to refreshing the guest's AP configuration
+ *		  as a result of unassigning an adapter or domain from an mdev.
+ * @qlist: the list of queues unlinked from the mdev as a result of unassigning
+ *	   an adapter or domain from an mdev.
+ *
+ * Resets the queues that were removed from the guest's AP configuration.
+ */
+static void vfio_ap_reset_queues_removed(struct ap_matrix *guest_apcb,
+					 struct list_head *qlist)
+{
+	struct vfio_ap_queue *q;
+	unsigned long apid, apqi;
+
+	list_for_each_entry(q, qlist, qlist_node) {
+		apid = AP_QID_CARD(q->apqn);
+		apqi = AP_QID_QUEUE(q->apqn);
+
+		if (test_bit_inv(apid, guest_apcb->apm) &&
+		    test_bit_inv(apqi, guest_apcb->aqm))
+			vfio_ap_mdev_reset_queue(q, 1);
+	}
+}
+
+/*
+ * vfio_ap_unlink_mdev_fr_queues
+ *
+ * @qlist: the list of queues unlinked from the mdev to which they were
+ *	   previously assigned.
+ *
+ * Unlink the mdev from each queue.
+ */
+static void vfio_ap_unlink_mdev_fr_queues(struct list_head *qlist)
+{
+	struct vfio_ap_queue *q;
+
+	list_for_each_entry(q, qlist, qlist_node)
+		vfio_ap_mdev_unlink_fr_queue(q);
+}
+
+/*
+ * vfio_ap_mdev_rem_adapter_refresh
+ *
+ * @matrix_mdev: the mdev currently in use by the KVM guest
+ * @apqi: the APID of the adapter unassigned from the mdev
+ *
+ * Refreshes the KVM guest's APCB and resets any queues that may have been
+ * dynamically removed from the guest's AP configuration.
+ */
+static void vfio_ap_mdev_rem_adapter_refresh(struct ap_matrix_mdev *matrix_mdev,
+					     unsigned long apid)
+{
+	LIST_HEAD(qlist);
+	struct ap_matrix shadow_matrix;
+
+	memcpy(&shadow_matrix, &matrix_mdev->shadow_apcb,
+	       sizeof(shadow_matrix));
+	vfio_ap_unlink_adapter_fr_mdev(matrix_mdev, apid, &qlist);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
+	vfio_ap_reset_queues_removed(&shadow_matrix, &qlist);
+	vfio_ap_unlink_mdev_fr_queues(&qlist);
+}
+
 /**
  * unassign_adapter_store
  *
@@ -801,8 +877,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	}
 
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
-	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
-	vfio_ap_mdev_refresh_apcb(matrix_mdev);
+	vfio_ap_mdev_rem_adapter_refresh(matrix_mdev, apid);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -898,8 +973,20 @@ static ssize_t assign_domain_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(assign_domain);
 
-static void vfio_ap_mdev_unlink_domain(struct ap_matrix_mdev *matrix_mdev,
-				       unsigned long apqi)
+/*
+ * vfio_ap_unlink_domain_fr_mdev
+ *
+ * @matrix_mdev: a pointer to the mdev currently in use by the KVM guest
+ * @apqi: the APQI of the domain that was unassigned from the mdev
+ * @qlist: a pointer to a list to which the queues unlinked from the mdev
+ *         will be stored.
+ *
+ * Unlinks the queues associated with the domain from the mdev. Each queue that
+ * is unlinked will be added to @qlist.
+ */
+static void vfio_ap_unlink_domain_fr_mdev(struct ap_matrix_mdev *matrix_mdev,
+					  unsigned long apqi,
+					  struct list_head *qlist)
 {
 	unsigned long apid;
 	struct vfio_ap_queue *q;
@@ -907,11 +994,44 @@ static void vfio_ap_mdev_unlink_domain(struct ap_matrix_mdev *matrix_mdev,
 	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
 		q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
 
-		if (q)
-			vfio_ap_mdev_unlink_queue(q);
+		if (q) {
+			vfio_ap_mdev_unlink_queue_fr_mdev(q);
+			list_add(&q->qlist_node, qlist);
+		}
 	}
 }
 
+/*
+ * vfio_ap_mdev_rem_domain_refresh
+ *
+ * @matrix_mdev: the mdev currently in use by the KVM guest
+ * @apqi: the APQI of the domain unassigned from the mdev
+ *
+ * Refreshes the KVM guest's APCB and resets any queues that may have been
+ * dynamically removed from the guest's AP configuration.
+ */
+static void vfio_ap_mdev_rem_domain_refresh(struct ap_matrix_mdev *matrix_mdev,
+					    unsigned long apqi)
+{
+	LIST_HEAD(qlist);
+	struct ap_matrix shadow_matrix;
+
+	memcpy(&shadow_matrix, &matrix_mdev->shadow_apcb,
+	       sizeof(shadow_matrix));
+	/*
+	 * Unlink the queues associated with the domain from the mdev
+	 * so the refresh can determine what adapter to unplug from the guest.
+	 */
+	vfio_ap_unlink_domain_fr_mdev(matrix_mdev, apqi, &qlist);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
+	vfio_ap_reset_queues_removed(&shadow_matrix, &qlist);
+	/*
+	 * Complete the unlinking of the queues associated with the domain
+	 * by unlinking the mdev from each queue.
+	 */
+	vfio_ap_unlink_mdev_fr_queues(&qlist);
+}
+
 /**
  * unassign_domain_store
  *
@@ -959,8 +1079,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	}
 
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
-	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
-	vfio_ap_mdev_refresh_apcb(matrix_mdev);
+	vfio_ap_mdev_rem_domain_refresh(matrix_mdev, apqi);
 	ret = count;
 
 done:
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 6f4f1f5bd611..1b95486fccf0 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -101,6 +101,7 @@ struct vfio_ap_queue {
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
 	struct hlist_node mdev_qnode;
+	struct list_head qlist_node;
 };
 
 int vfio_ap_mdev_register(void);
-- 
2.30.2

