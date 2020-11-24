Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962E42C3339
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 22:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387492AbgKXVkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 16:40:47 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35716 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733125AbgKXVkq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 16:40:46 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLX8lW114343;
        Tue, 24 Nov 2020 16:40:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pyhDLsC21gBV6bMpWMDxlXAY8nD8NBmdUxVwQTR66JU=;
 b=g2lMh+ZJ3X9/3nGvWPhQelrsfDZ6Ix5k+jz8LyyU81DWFwCybaWoRqXTNYy1cXIiOPD3
 zs8cQoVWIxyH1fF6qfloF/oRovrUQ+ij0AhTwkBoqyUA8s7FkltRxINw7X63cjnILp3F
 igHic0ICPlrsPIYLpU80MUq9ve8x4iir/G7hZM9dbwvEYEi4kP+tbIUWPD1qkolGOQl5
 NywMS+7cPVSOo07vhDDLQF+y+E7ckZSJYUT2BcZ1fn1r9xMXOtzA65l6WCki5pmLyNeY
 7OIxUQ7Hodi03dRS2snMJT4Vhz81SsuUKl0DPCsNfyiFjWM2Aykeb7GxdA6Es1fOIlNA 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 350uq3bkbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:42 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AOLYY0p123939;
        Tue, 24 Nov 2020 16:40:41 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 350uq3bkbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:41 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLccGo009147;
        Tue, 24 Nov 2020 21:40:40 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04wdc.us.ibm.com with ESMTP id 34xth92m99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 21:40:40 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOLedJr11207420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 21:40:39 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 624B0AE05C;
        Tue, 24 Nov 2020 21:40:39 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F702AE060;
        Tue, 24 Nov 2020 21:40:38 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.195.249])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 21:40:37 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v12 11/17] s390/vfio-ap: allow assignment of unavailable AP queues to mdev device
Date:   Tue, 24 Nov 2020 16:40:10 -0500
Message-Id: <20201124214016.3013-12-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201124214016.3013-1-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_09:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 bulkscore=0 suspectscore=3 spamscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240126
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
 drivers/s390/crypto/vfio_ap_ops.c | 199 +++++-------------------------
 1 file changed, 28 insertions(+), 171 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 633c61995891..586ec5776693 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -475,122 +475,6 @@ static struct attribute_group *vfio_ap_mdev_type_groups[] = {
 	NULL,
 };
 
-struct vfio_ap_queue_reserved {
-	unsigned long *apid;
-	unsigned long *apqi;
-	bool reserved;
-};
-
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
-{
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
-
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
-}
-
 #define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
 			 "already assigned to %s"
 
@@ -656,6 +540,16 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
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
 enum qlink_action {
 	LINK_APID,
 	LINK_APQI,
@@ -790,34 +684,23 @@ static ssize_t assign_adapter_store(struct device *dev,
 	if (apid > matrix_mdev->matrix.apm_max)
 		return -ENODEV;
 
-	/*
-	 * Set the bit in the AP mask (APM) corresponding to the AP adapter
-	 * number (APID). The bits in the mask, from most significant to least
-	 * significant bit, correspond to APIDs 0-255.
-	 */
-	if (!mutex_trylock(&matrix_dev->lock))
-		return -EBUSY;
-
-	ret = vfio_ap_mdev_verify_queues_reserved_for_apid(matrix_mdev, apid);
-	if (ret)
-		goto done;
-
 	memset(apm, 0, sizeof(apm));
 	set_bit_inv(apid, apm);
 
-	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev, apm,
-					     matrix_mdev->matrix.aqm);
-	if (ret)
-		goto done;
+	if (!mutex_trylock(&matrix_dev->lock))
+		return -EBUSY;
 
+	ret = vfio_ap_mdev_validate_masks(matrix_mdev, apm,
+					  matrix_mdev->matrix.aqm);
+	if (ret) {
+		mutex_unlock(&matrix_dev->lock);
+		return ret;
+	}
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_manage_qlinks(matrix_mdev, LINK_APID, apid);
-	ret = count;
-
-done:
 	mutex_unlock(&matrix_dev->lock);
 
-	return ret;
+	return count;
 }
 static DEVICE_ATTR_WO(assign_adapter);
 
@@ -867,26 +750,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
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
 /**
  * assign_domain_store
  *
@@ -940,29 +803,23 @@ static ssize_t assign_domain_store(struct device *dev,
 	if (apqi > max_apqi)
 		return -ENODEV;
 
-	if (!mutex_trylock(&matrix_dev->lock))
-		return -EBUSY;
-
-	ret = vfio_ap_mdev_verify_queues_reserved_for_apqi(matrix_mdev, apqi);
-	if (ret)
-		goto done;
-
 	memset(aqm, 0, sizeof(aqm));
 	set_bit_inv(apqi, aqm);
 
-	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev,
-					     matrix_mdev->matrix.apm, aqm);
-	if (ret)
-		goto done;
+	if (!mutex_trylock(&matrix_dev->lock))
+		return -EBUSY;
 
+	ret = vfio_ap_mdev_validate_masks(matrix_mdev, matrix_mdev->matrix.apm,
+					  aqm);
+	if (ret) {
+		mutex_unlock(&matrix_dev->lock);
+		return ret;
+	}
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_manage_qlinks(matrix_mdev, LINK_APQI, apqi);
-	ret = count;
-
-done:
 	mutex_unlock(&matrix_dev->lock);
 
-	return ret;
+	return count;
 }
 static DEVICE_ATTR_WO(assign_domain);
 
-- 
2.21.1

