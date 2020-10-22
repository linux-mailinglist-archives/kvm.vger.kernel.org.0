Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8D9296370
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 19:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902426AbgJVRMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 13:12:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45026 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2902416AbgJVRMp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Oct 2020 13:12:45 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09MH2ThD138710;
        Thu, 22 Oct 2020 13:12:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fEsR73KSzySNjHccG3Vkn3ywmRLH1siIOLgRb6GdUPk=;
 b=iWvZhRWc7nHCGRSozCCgB9RjcKm3N0/7sl3fVWH+el8KEMwlCc0dAcvEGtJTBlkqJqOu
 sEwAIoG2Q7GSclwqgImBi6ChLPZz8u+FBOHSvaPV/fG3p4yhWVi9/b2+DDiA9s0YG0ln
 JdFIKa1Taeu7V21KRhvLRmjCl1qpqyWMPlPpS9B/W5NS8wifuunpIsyy7jI1YTmloLxE
 OrwUyOCDAF1UhPxH+cs0hAM97GsPNClo0FAxAaXOPUpVDD9IwKThsBGqA0DuXyONNbnV
 zOd7HIk5xF3/YWDf3SU3EvzvHOlwvoxYNMbtXDFDHeOxqvWv0jIXa04yurzHgO1jFusf sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ba2gh22w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 13:12:44 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09MH2Zkk139396;
        Thu, 22 Oct 2020 13:12:44 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ba2gh22k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 13:12:44 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09MHCDed000598;
        Thu, 22 Oct 2020 17:12:43 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 347r89vdsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 17:12:43 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09MHCdoX131796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 17:12:39 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE3A778064;
        Thu, 22 Oct 2020 17:12:39 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D285D7805F;
        Thu, 22 Oct 2020 17:12:37 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.170.177])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 22 Oct 2020 17:12:37 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v11 10/14] s390/vfio-ap: allow hot plug/unplug of AP resources using mdev device
Date:   Thu, 22 Oct 2020 13:12:05 -0400
Message-Id: <20201022171209.19494-11-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201022171209.19494-1-akrowiak@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_12:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 priorityscore=1501 adultscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's hot plug/unplug adapters, domains and control domains assigned to or
unassigned from an AP matrix mdev device while it is in use by a guest per
the following:

* Hot plug AP adapter:

  When the APID of an adapter is assigned to a matrix mdev in use by a KVM
  guest, the adapter will be hot plugged into the KVM guest as long as each
  APQN derived from the Cartesian product of the APID being assigned and
  the APQIs already assigned to the matrix mdev references a queue device
  bound to the vfio_ap device driver.

* Hot unplug adapter:

  When the APID of an adapter is unassigned from a matrix mdev in use by a
  KVM guest, the adapter will be hot unplugged from the KVM guest.

* Hot plug domain:

  When the APQI of a domain is assigned to a matrix mdev in use by a KVM
  guest, the domain will be hot plugged into the KVM guest as long as each
  APQN derived from the Cartesian product of the APQI being assigned and
  the APIDs already assigned to the matrix mdev references a queue device
  bound to the vfio_ap device driver.

* Hot unplug domain:

  When the APQI of a domain is unassigned from a matrix mdev in use by a
  KVM guest, the domain will be hot unplugged from the KVM guest

* Hot plug control domain:

  When the domain number of a control domain is assigned to a matrix mdev
  in use by a KVM guest, the control domain will be hot plugged into the
  KVM guest. The AP architecture ensures a guest will only get access to
  the control domain if it is in the host's AP configuration, so there is
  no risk in hot plugging it; however, it will become automatically
  available to the guest when it is added to the host configuration.

* Hot unplug control domain:

  When the domain number of a control domain is unassigned from a matrix
  mdev in use by a KVM guest, the control domain will be hot unplugged
  from the KVM guest.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 148 ++++++++++++++++++++++++------
 1 file changed, 119 insertions(+), 29 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index c2c6dcec8829..dae1fba41941 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -517,12 +517,18 @@ static bool vfio_ap_mdev_matrixes_equal(struct ap_matrix *matrix1,
  * a matrix mdev's AP configuration and stores the result in the shadow copy of
  * the APCB used to supply a KVM guest's AP configuration.
  *
+ * Note: Filtering is applied only to adapters and domains. Changes to control
+ *	 domains will always be reflected in the shadow APCB.
+ *
  * @matrix_mdev:  the matrix mdev whose AP configuration is to be filtered
+ * @filter_apid:  indicates whether APIDs (true) or APQIs (false) shall be
+ *		  filtered
  *
  * Returns true if filtering has changed the shadow copy of the APCB used
  * to supply a KVM guest's AP configuration; otherwise, returns false.
  */
-static int vfio_ap_mdev_filter_guest_matrix(struct ap_matrix_mdev *matrix_mdev)
+static int vfio_ap_mdev_filter_guest_matrix(struct ap_matrix_mdev *matrix_mdev,
+					    bool filter_apid)
 {
 	struct ap_matrix shadow_apcb;
 	unsigned long apid, apqi, apqn;
@@ -561,9 +567,15 @@ static int vfio_ap_mdev_filter_guest_matrix(struct ap_matrix_mdev *matrix_mdev)
 			 * the APID.
 			 */
 			apqn = AP_MKQID(apid, apqi);
+
 			if (!vfio_ap_mdev_get_queue(matrix_mdev, apqn)) {
-				clear_bit_inv(apid, shadow_apcb.apm);
-				break;
+				if (filter_apid) {
+					clear_bit_inv(apid, shadow_apcb.apm);
+					break;
+				}
+
+				clear_bit_inv(apqi, shadow_apcb.aqm);
+				continue;
 			}
 		}
 
@@ -723,10 +735,6 @@ static ssize_t assign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
 		return ret;
@@ -746,12 +754,44 @@ static ssize_t assign_adapter_store(struct device *dev,
 	}
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APID, apid);
+
+	if (vfio_ap_mdev_has_crycb(matrix_mdev))
+		if (vfio_ap_mdev_filter_guest_matrix(matrix_mdev, true))
+			vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(assign_adapter);
 
+static bool vfio_ap_mdev_unassign_guest_apid(struct ap_matrix_mdev *matrix_mdev,
+					     unsigned long apid)
+{
+	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm)) {
+			clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+
+			/*
+			 * If there are no APIDs assigned to the guest, then
+			 * the guest will not have access to any queues, so
+			 * let's also go ahead and unassign the APQIs. Keeping
+			 * them around may yield unpredictable results during
+			 * a probe that is not related to a host AP
+			 * configuration change (i.e., an AP adapter is
+			 * configured online).
+			 */
+			if (bitmap_empty(matrix_mdev->shadow_apcb.apm,
+					 AP_DEVICES))
+				bitmap_clear(matrix_mdev->shadow_apcb.aqm, 0,
+					     AP_DOMAINS);
+
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /**
  * unassign_adapter_store
  *
@@ -778,10 +818,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
 		return ret;
@@ -792,6 +828,9 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_link_queues(matrix_mdev, UNLINK_APID, apid);
+
+	if (vfio_ap_mdev_unassign_guest_apid(matrix_mdev, apid))
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -841,10 +880,6 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	/* If the guest is running, disallow assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		return ret;
@@ -863,12 +898,43 @@ static ssize_t assign_domain_store(struct device *dev,
 	}
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APQI, apqi);
+
+	if (vfio_ap_mdev_has_crycb(matrix_mdev))
+		if (vfio_ap_mdev_filter_guest_matrix(matrix_mdev, false))
+			vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(assign_domain);
 
+static bool vfio_ap_mdev_unassign_guest_apqi(struct ap_matrix_mdev *matrix_mdev,
+					     unsigned long apqi)
+{
+	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
+			clear_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
+
+			/*
+			 * If there are no APQIs assigned to the guest, then
+			 * the guest will not have access to any queues, so
+			 * let's also go ahead and unassign the APIDs. Keeping
+			 * them around may yield unpredictable results during
+			 * a probe that is not related to a host AP
+			 * configuration change (i.e., an AP adapter is
+			 * configured online).
+			 */
+			if (bitmap_empty(matrix_mdev->shadow_apcb.aqm,
+					 AP_DOMAINS))
+				bitmap_clear(matrix_mdev->shadow_apcb.apm, 0,
+					     AP_DEVICES);
+
+			return true;
+		}
+	}
+
+	return false;
+}
 
 /**
  * unassign_domain_store
@@ -896,10 +962,6 @@ static ssize_t unassign_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		return ret;
@@ -910,12 +972,29 @@ static ssize_t unassign_domain_store(struct device *dev,
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_link_queues(matrix_mdev, UNLINK_APQI, apqi);
+
+	if (vfio_ap_mdev_unassign_guest_apqi(matrix_mdev, apqi))
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(unassign_domain);
 
+static bool vfio_ap_mdev_assign_guest_cdom(struct ap_matrix_mdev *matrix_mdev,
+					   unsigned long domid)
+{
+	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		if (!test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
+			set_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
+
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /**
  * assign_control_domain_store
  *
@@ -941,10 +1020,6 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &id);
 	if (ret)
 		return ret;
@@ -959,12 +1034,29 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 */
 	mutex_lock(&matrix_dev->lock);
 	set_bit_inv(id, matrix_mdev->matrix.adm);
+	if (vfio_ap_mdev_assign_guest_cdom(matrix_mdev, id))
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(assign_control_domain);
 
+static bool
+vfio_ap_mdev_unassign_guest_cdom(struct ap_matrix_mdev *matrix_mdev,
+				 unsigned long domid)
+{
+	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
+			clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
+
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /**
  * unassign_control_domain_store
  *
@@ -991,10 +1083,6 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	/* If the guest is running, disallow un-assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &domid);
 	if (ret)
 		return ret;
@@ -1003,6 +1091,8 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
+	if (vfio_ap_mdev_unassign_guest_cdom(matrix_mdev, domid))
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -1216,7 +1306,7 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
 		return NOTIFY_DONE;
 
-	if (vfio_ap_mdev_filter_guest_matrix(matrix_mdev))
+	if (vfio_ap_mdev_filter_guest_matrix(matrix_mdev, true))
 		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
 
 	return NOTIFY_OK;
@@ -1443,7 +1533,7 @@ static void vfio_ap_mdev_hot_plug_queue(struct vfio_ap_queue *q)
 	if ((q->matrix_mdev == NULL) || !vfio_ap_mdev_has_crycb(q->matrix_mdev))
 		return;
 
-	if (vfio_ap_mdev_filter_guest_matrix(q->matrix_mdev))
+	if (vfio_ap_mdev_filter_guest_matrix(q->matrix_mdev, true))
 		vfio_ap_mdev_commit_shadow_apcb(q->matrix_mdev);
 }
 
-- 
2.21.1

