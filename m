Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094F12E1126
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 02:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgLWBRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 20:17:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1726 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726979AbgLWBRH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Dec 2020 20:17:07 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BN13cEI155792;
        Tue, 22 Dec 2020 20:16:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=D7VSNzunWAWaQScRcdog+GKeDFDI3D8msMICfU3q4Mc=;
 b=b/vBG/nirZFjq/bUByv06dyM+gs9FLPQOwteYKjcDN1uKCqCGEGW+85EjYI5kqYQ4Xsc
 vxwxvn2IAJLxquiJepwFu/N74mnehn9jHUFWSIKUR1+W212vqPTztHQDpQdLTDbLdHXt
 4O+rGkztKbL0O73/rxSStZt1Gto7qIKjTyiRpZiVR4I2abSra5ZxIjmLr6sr6IkoDflR
 IKnpGywamd/ITIgSA8WlvNcDoy8jJDcOIXgNwZpo3/BCKvvDFzGw7nCZ+SdoNHG3dhHB
 jip6COGNpiaRHJr7GBj7XKqauMV6AMKYlNzuP4KtC/x9/Gfe26qvlFbdeo0f9Z+ubotK /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35ktwd9exd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:23 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BN1Fj14009036;
        Tue, 22 Dec 2020 20:16:22 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35ktwd9ex1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:22 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BN1BZrK032031;
        Wed, 23 Dec 2020 01:16:22 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 35kk8rbvng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Dec 2020 01:16:22 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BN1GKRf8127112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Dec 2020 01:16:20 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C62F112066;
        Wed, 23 Dec 2020 01:16:20 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EBAA112062;
        Wed, 23 Dec 2020 01:16:19 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.193.150])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 23 Dec 2020 01:16:18 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v13 06/15] s390/vfio-ap: allow assignment of unavailable AP queues to mdev device
Date:   Tue, 22 Dec 2020 20:15:57 -0500
Message-Id: <20201223011606.5265-7-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201223011606.5265-1-akrowiak@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-22_13:2020-12-21,2020-12-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012230003
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current implementation does not allow assignment of an AP adapter or
domain to an mdev device if each APQN resulting from the assignment
does not reference an AP queue device that is bound to the vfio_ap device
driver. This patch allows assignment of AP resources to the matrix mdev as
long as the APQNs resulting from the assignment:
   1. Are not reserved by the AP BUS for use by the zcrypt device drivers.
   2. Are not assigned to another matrix mdev.

The rationale behind this is twofold:
   1. The AP architecture does not preclude assignment of APQNs to an AP
      configuration that are not available to the system.
   2. APQNs that do not reference a queue device bound to the vfio_ap
      device driver will not be assigned to the guest's CRYCB, so the
      guest will not get access to queues not bound to the vfio_ap driver.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 241 ++++++++----------------------
 1 file changed, 62 insertions(+), 179 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index cdcc6378b4a5..2d58b39977be 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -379,134 +379,37 @@ static struct attribute_group *vfio_ap_mdev_type_groups[] = {
 	NULL,
 };
 
-struct vfio_ap_queue_reserved {
-	unsigned long *apid;
-	unsigned long *apqi;
-	bool reserved;
-};
+#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
+			 "already assigned to %s"
 
-/**
- * vfio_ap_has_queue
- *
- * @dev: an AP queue device
- * @data: a struct vfio_ap_queue_reserved reference
- *
- * Flags whether the AP queue device (@dev) has a queue ID containing the APQN,
- * apid or apqi specified in @data:
- *
- * - If @data contains both an apid and apqi value, then @data will be flagged
- *   as reserved if the APID and APQI fields for the AP queue device matches
- *
- * - If @data contains only an apid value, @data will be flagged as
- *   reserved if the APID field in the AP queue device matches
- *
- * - If @data contains only an apqi value, @data will be flagged as
- *   reserved if the APQI field in the AP queue device matches
- *
- * Returns 0 to indicate the input to function succeeded. Returns -EINVAL if
- * @data does not contain either an apid or apqi.
- */
-static int vfio_ap_has_queue(struct device *dev, void *data)
+static void vfio_ap_mdev_log_sharing_err(const char *mdev_name,
+					 unsigned long *apm,
+					 unsigned long *aqm)
 {
-	struct vfio_ap_queue_reserved *qres = data;
-	struct ap_queue *ap_queue = to_ap_queue(dev);
-	ap_qid_t qid;
-	unsigned long id;
-
-	if (qres->apid && qres->apqi) {
-		qid = AP_MKQID(*qres->apid, *qres->apqi);
-		if (qid == ap_queue->qid)
-			qres->reserved = true;
-	} else if (qres->apid && !qres->apqi) {
-		id = AP_QID_CARD(ap_queue->qid);
-		if (id == *qres->apid)
-			qres->reserved = true;
-	} else if (!qres->apid && qres->apqi) {
-		id = AP_QID_QUEUE(ap_queue->qid);
-		if (id == *qres->apqi)
-			qres->reserved = true;
-	} else {
-		return -EINVAL;
-	}
+	unsigned long apid, apqi;
 
-	return 0;
-}
-
-/**
- * vfio_ap_verify_queue_reserved
- *
- * @matrix_dev: a mediated matrix device
- * @apid: an AP adapter ID
- * @apqi: an AP queue index
- *
- * Verifies that the AP queue with @apid/@apqi is reserved by the VFIO AP device
- * driver according to the following rules:
- *
- * - If both @apid and @apqi are not NULL, then there must be an AP queue
- *   device bound to the vfio_ap driver with the APQN identified by @apid and
- *   @apqi
- *
- * - If only @apid is not NULL, then there must be an AP queue device bound
- *   to the vfio_ap driver with an APQN containing @apid
- *
- * - If only @apqi is not NULL, then there must be an AP queue device bound
- *   to the vfio_ap driver with an APQN containing @apqi
- *
- * Returns 0 if the AP queue is reserved; otherwise, returns -EADDRNOTAVAIL.
- */
-static int vfio_ap_verify_queue_reserved(unsigned long *apid,
-					 unsigned long *apqi)
-{
-	int ret;
-	struct vfio_ap_queue_reserved qres;
-
-	qres.apid = apid;
-	qres.apqi = apqi;
-	qres.reserved = false;
-
-	ret = driver_for_each_device(&matrix_dev->vfio_ap_drv->driver, NULL,
-				     &qres, vfio_ap_has_queue);
-	if (ret)
-		return ret;
-
-	if (qres.reserved)
-		return 0;
-
-	return -EADDRNOTAVAIL;
-}
-
-static int
-vfio_ap_mdev_verify_queues_reserved_for_apid(struct ap_matrix_mdev *matrix_mdev,
-					     unsigned long apid)
-{
-	int ret;
-	unsigned long apqi;
-	unsigned long nbits = matrix_mdev->matrix.aqm_max + 1;
-
-	if (find_first_bit_inv(matrix_mdev->matrix.aqm, nbits) >= nbits)
-		return vfio_ap_verify_queue_reserved(&apid, NULL);
-
-	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, nbits) {
-		ret = vfio_ap_verify_queue_reserved(&apid, &apqi);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
+	for_each_set_bit_inv(apid, apm, AP_DEVICES)
+		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
+			pr_warn(MDEV_SHARING_ERR, apid, apqi, mdev_name);
 }
 
 /**
  * vfio_ap_mdev_verify_no_sharing
  *
- * Verifies that the APQNs derived from the cross product of the AP adapter IDs
- * and AP queue indexes comprising the AP matrix are not configured for another
- * mediated device. AP queue sharing is not allowed.
+ * Verifies that each APQN derived from the Cartesian product of the AP adapter
+ * IDs and AP queue indexes comprising the AP matrix are not configured for
+ * another mediated device. AP queue sharing is not allowed.
  *
- * @matrix_mdev: the mediated matrix device
+ * @matrix_mdev: the mediated matrix device to which the APQNs being verified
+ *		 are assigned.
+ * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
+ * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
  *
- * Returns 0 if the APQNs are not shared, otherwise; returns -EADDRINUSE.
+ * Returns 0 if the APQNs are not shared, otherwise; returns -EBUSY.
  */
-static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
+static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
+					  unsigned long *mdev_apm,
+					  unsigned long *mdev_aqm)
 {
 	struct ap_matrix_mdev *lstdev;
 	DECLARE_BITMAP(apm, AP_DEVICES);
@@ -523,20 +426,31 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
 		 * We work on full longs, as we can only exclude the leftover
 		 * bits in non-inverse order. The leftover is all zeros.
 		 */
-		if (!bitmap_and(apm, matrix_mdev->matrix.apm,
-				lstdev->matrix.apm, AP_DEVICES))
+		if (!bitmap_and(apm, mdev_apm, lstdev->matrix.apm, AP_DEVICES))
 			continue;
 
-		if (!bitmap_and(aqm, matrix_mdev->matrix.aqm,
-				lstdev->matrix.aqm, AP_DOMAINS))
+		if (!bitmap_and(aqm, mdev_aqm, lstdev->matrix.aqm, AP_DOMAINS))
 			continue;
 
-		return -EADDRINUSE;
+		vfio_ap_mdev_log_sharing_err(dev_name(mdev_dev(lstdev->mdev)),
+					     apm, aqm);
+
+		return -EBUSY;
 	}
 
 	return 0;
 }
 
+static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev,
+				       unsigned long *mdev_apm,
+				       unsigned long *mdev_aqm)
+{
+	if (ap_apqn_in_matrix_owned_by_def_drv(mdev_apm, mdev_aqm))
+		return -EADDRNOTAVAIL;
+
+	return vfio_ap_mdev_verify_no_sharing(matrix_mdev, mdev_apm, mdev_aqm);
+}
+
 static void vfio_ap_mdev_link_queue(struct ap_matrix_mdev *matrix_mdev,
 				    struct vfio_ap_queue *q)
 {
@@ -608,10 +522,10 @@ static void vfio_ap_mdev_link_adapter(struct ap_matrix_mdev *matrix_mdev,
  *	   driver; or, if no APQIs have yet been assigned, the APID is not
  *	   contained in an APQN bound to the vfio_ap device driver.
  *
- *	4. -EADDRINUSE
+ *	4. -EBUSY
  *	   An APQN derived from the cross product of the APID being assigned
  *	   and the APQIs previously assigned is being used by another mediated
- *	   matrix device
+ *	   matrix device or the mdev lock could not be acquired.
  */
 static ssize_t assign_adapter_store(struct device *dev,
 				    struct device_attribute *attr,
@@ -619,6 +533,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 {
 	int ret;
 	unsigned long apid;
+	DECLARE_BITMAP(apm, AP_DEVICES);
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
@@ -633,33 +548,24 @@ static ssize_t assign_adapter_store(struct device *dev,
 	if (apid > matrix_mdev->matrix.apm_max)
 		return -ENODEV;
 
-	/*
-	 * Set the bit in the AP mask (APM) corresponding to the AP adapter
-	 * number (APID). The bits in the mask, from most significant to least
-	 * significant bit, correspond to APIDs 0-255.
-	 */
+	memset(apm, 0, sizeof(apm));
+	set_bit_inv(apid, apm);
+
 	mutex_lock(&matrix_dev->lock);
 
-	ret = vfio_ap_mdev_verify_queues_reserved_for_apid(matrix_mdev, apid);
-	if (ret)
-		goto done;
+	ret = vfio_ap_mdev_validate_masks(matrix_mdev, apm,
+					  matrix_mdev->matrix.aqm);
+	if (ret) {
+		mutex_unlock(&matrix_dev->lock);
+		return ret;
+	}
 
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
-
-	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
-	if (ret)
-		goto share_err;
-
 	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
-	ret = count;
-	goto done;
 
-share_err:
-	clear_bit_inv(apid, matrix_mdev->matrix.apm);
-done:
 	mutex_unlock(&matrix_dev->lock);
 
-	return ret;
+	return count;
 }
 static DEVICE_ATTR_WO(assign_adapter);
 
@@ -718,26 +624,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(unassign_adapter);
 
-static int
-vfio_ap_mdev_verify_queues_reserved_for_apqi(struct ap_matrix_mdev *matrix_mdev,
-					     unsigned long apqi)
-{
-	int ret;
-	unsigned long apid;
-	unsigned long nbits = matrix_mdev->matrix.apm_max + 1;
-
-	if (find_first_bit_inv(matrix_mdev->matrix.apm, nbits) >= nbits)
-		return vfio_ap_verify_queue_reserved(NULL, &apqi);
-
-	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, nbits) {
-		ret = vfio_ap_verify_queue_reserved(&apid, &apqi);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
 static void vfio_ap_mdev_link_domain(struct ap_matrix_mdev *matrix_mdev,
 				     unsigned long apqi)
 {
@@ -774,10 +660,10 @@ static void vfio_ap_mdev_link_domain(struct ap_matrix_mdev *matrix_mdev,
  *	   driver; or, if no APIDs have yet been assigned, the APQI is not
  *	   contained in an APQN bound to the vfio_ap device driver.
  *
- *	4. -EADDRINUSE
+ *	4. -BUSY
  *	   An APQN derived from the cross product of the APQI being assigned
  *	   and the APIDs previously assigned is being used by another mediated
- *	   matrix device
+ *	   matrix device or the mdev lock could not be acquired.
  */
 static ssize_t assign_domain_store(struct device *dev,
 				   struct device_attribute *attr,
@@ -785,6 +671,7 @@ static ssize_t assign_domain_store(struct device *dev,
 {
 	int ret;
 	unsigned long apqi;
+	DECLARE_BITMAP(aqm, AP_DOMAINS);
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
@@ -799,28 +686,24 @@ static ssize_t assign_domain_store(struct device *dev,
 	if (apqi > max_apqi)
 		return -ENODEV;
 
+	memset(aqm, 0, sizeof(aqm));
+	set_bit_inv(apqi, aqm);
+
 	mutex_lock(&matrix_dev->lock);
 
-	ret = vfio_ap_mdev_verify_queues_reserved_for_apqi(matrix_mdev, apqi);
-	if (ret)
-		goto done;
+	ret = vfio_ap_mdev_validate_masks(matrix_mdev, matrix_mdev->matrix.apm,
+					  aqm);
+	if (ret) {
+		mutex_unlock(&matrix_dev->lock);
+		return ret;
+	}
 
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
-
-	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
-	if (ret)
-		goto share_err;
-
 	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
-	ret = count;
-	goto done;
 
-share_err:
-	clear_bit_inv(apqi, matrix_mdev->matrix.aqm);
-done:
 	mutex_unlock(&matrix_dev->lock);
 
-	return ret;
+	return count;
 }
 static DEVICE_ATTR_WO(assign_domain);
 
-- 
2.21.1

