Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D392E112A
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 02:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgLWBRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 20:17:11 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1490 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727091AbgLWBRK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Dec 2020 20:17:10 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BN12GpG136631;
        Tue, 22 Dec 2020 20:16:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RpaYjH9LW/K/+9rWpC1gWUUVUPzJolxnI3K2P8ajM9k=;
 b=T9VhqhV0ySFSMMSn/mKMX9/EzodTgpFxJ+JClDVlbkEjoLRqIR8FOeSiwawGNBUUnWwJ
 rlsYjy9YopL7Xy4J7x3NXKp4r8NSHxSiVoUZVObH7iG2VspZXMxOwDs6c5fmMG//1vfU
 d9hsAmuor2jWmspa3Qvz6gOFvSbYQjQAGKMBKlswh3f8FWV7l4KFee3Y7qiyYD2698iF
 i6F8Bn6ciju2hn02fN4Uhtc2PrsN5thTG+0I6gA0DOtSzHYPzHqe5ReXgl3YDP3B0CK8
 ypMRRg0Gk7wupS8YKqdYhyYuVOyJrMbHEc18bY53cnf7iHZ3pPVR1PzprDRwbBNfbM3T JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35kuvng8e0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:26 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BN13Kkl142025;
        Tue, 22 Dec 2020 20:16:26 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35kuvng8dn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:26 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BN1DAeo000460;
        Wed, 23 Dec 2020 01:16:25 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03dal.us.ibm.com with ESMTP id 35k02ev72s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Dec 2020 01:16:25 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BN1GNJw21692918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Dec 2020 01:16:23 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 923DF112064;
        Wed, 23 Dec 2020 01:16:23 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8213112062;
        Wed, 23 Dec 2020 01:16:22 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.193.150])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 23 Dec 2020 01:16:22 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v13 09/15] s390/vfio-ap: allow hot plug/unplug of AP resources using mdev device
Date:   Tue, 22 Dec 2020 20:16:00 -0500
Message-Id: <20201223011606.5265-10-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201223011606.5265-1-akrowiak@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-22_13:2020-12-21,2020-12-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 priorityscore=1501 clxscore=1015
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012230003
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's allow adapters, domains and control domains to be hot plugged into
and hot unplugged from a KVM guest using a matrix mdev when:

* The adapter, domain or control domain is assigned to or unassigned from
  the matrix mdev

* A queue device with an APQN assigned to the matrix mdev is bound to or
  unbound from the vfio_ap device driver.

Whenever an assignment or unassignment of an adapter, domain or control
domain is performed as well as when a bind or unbind of a queue device
is executed, the AP control block (APCB) that supplies the AP configuration
to a guest is first refreshed. The APCB is refreshed by copying the AP
configuration from the mdev's matrix to the APCB, then filtering the
APCB according to the following rules:

* The APID of each adapter and the APQI of each domain that is not in the
  host's AP configuration is filtered out.

* The APID of each adapter comprising an APQN that does not reference a
  queue device bound to the vfio_ap device driver is filtered. The APQNs
  are derived from the Cartesian product of the APID of each adapter and
  APQI of each domain assigned to the mdev's matrix.

After refreshing the APCB, if the mdev is in use by a KVM guest, it is
hot plugged into the guest to provide access to dynamically provide
access to the adapters, domains and control domains provided via the
newly refreshed APCB.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 143 ++++++++++++++++++++++++------
 1 file changed, 118 insertions(+), 25 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 1b1d5975ee0e..843862c88379 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -307,6 +307,88 @@ static void vfio_ap_mdev_commit_shadow_apcb(struct ap_matrix_mdev *matrix_mdev)
 					  matrix_mdev->shadow_apcb.adm);
 }
 
+static void vfio_ap_mdev_filter_apcb(struct ap_matrix_mdev *matrix_mdev,
+				     struct ap_matrix *shadow_apcb)
+{
+	int ret;
+	unsigned long apid, apqi, apqn;
+
+	ret = ap_qci(&matrix_dev->info);
+	if (ret)
+		return;
+
+	memcpy(shadow_apcb, &matrix_mdev->matrix, sizeof(struct ap_matrix));
+
+	/*
+	 * Copy the adapters, domains and control domains to the shadow_apcb
+	 * from the matrix mdev, but only those that are assigned to the host's
+	 * AP configuration.
+	 */
+	bitmap_and(shadow_apcb->apm, matrix_mdev->matrix.apm,
+		   (unsigned long *)matrix_dev->info.apm, AP_DEVICES);
+	bitmap_and(shadow_apcb->aqm, matrix_mdev->matrix.aqm,
+		   (unsigned long *)matrix_dev->info.aqm, AP_DOMAINS);
+	bitmap_and(shadow_apcb->adm, matrix_mdev->matrix.adm,
+		   (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);
+
+	/* If there are no APQNs assigned, then filtering them be unnecessary */
+	if (bitmap_empty(shadow_apcb->apm, AP_DEVICES)) {
+		if (!bitmap_empty(shadow_apcb->aqm, AP_DOMAINS))
+			bitmap_clear(shadow_apcb->aqm, 0, AP_DOMAINS);
+		return;
+	} else if (bitmap_empty(shadow_apcb->aqm, AP_DOMAINS)) {
+		if (!bitmap_empty(shadow_apcb->apm, AP_DEVICES))
+			bitmap_clear(shadow_apcb->apm, 0, AP_DEVICES);
+		return;
+	}
+
+	for_each_set_bit_inv(apid, shadow_apcb->apm, AP_DEVICES) {
+		for_each_set_bit_inv(apqi, shadow_apcb->aqm, AP_DOMAINS) {
+			/*
+			 * If the APQN is not bound to the vfio_ap device
+			 * driver, then we can't assign it to the guest's
+			 * AP configuration. The AP architecture won't
+			 * allow filtering of a single APQN, so if we're
+			 * filtering APIDs, then filter the APID; otherwise,
+			 * filter the APQI.
+			 */
+			apqn = AP_MKQID(apid, apqi);
+			if (!vfio_ap_mdev_get_queue(matrix_mdev, apqn)) {
+				clear_bit_inv(apid, shadow_apcb->apm);
+				break;
+			}
+		}
+	}
+}
+
+/**
+ * vfio_ap_mdev_refresh_apcb
+ *
+ * Filter APQNs assigned to the matrix mdev that do not reference an AP queue
+ * device bound to the vfio_ap device driver.
+ *
+ * @matrix_mdev:  the matrix mdev whose AP configuration is to be filtered
+ * @shadow_apcb:  the shadow of the KVM guest's APCB (contains AP configuration
+ *		  for guest)
+ * @filter_apids: boolean value indicating whether the APQNs shall be filtered
+ *		  by APID (true) or by APQI (false).
+ *
+ * Returns the number of APQNs remaining after filtering is complete.
+ */
+static void vfio_ap_mdev_refresh_apcb(struct ap_matrix_mdev *matrix_mdev)
+{
+	struct ap_matrix shadow_apcb;
+
+	vfio_ap_mdev_filter_apcb(matrix_mdev, &shadow_apcb);
+
+	if (memcmp(&shadow_apcb, &matrix_mdev->shadow_apcb,
+		   sizeof(struct ap_matrix)) != 0) {
+		memcpy(&matrix_mdev->shadow_apcb, &shadow_apcb,
+		       sizeof(struct ap_matrix));
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
+	}
+}
+
 static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -552,10 +634,6 @@ static ssize_t assign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
 		return ret;
@@ -577,6 +655,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
 
 	mutex_unlock(&matrix_dev->lock);
 
@@ -619,10 +698,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
 		return ret;
@@ -633,6 +708,8 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
+
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -691,10 +768,6 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	/* If the guest is running, disallow assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		return ret;
@@ -715,6 +788,7 @@ static ssize_t assign_domain_store(struct device *dev,
 
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
 
 	mutex_unlock(&matrix_dev->lock);
 
@@ -757,10 +831,6 @@ static ssize_t unassign_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		return ret;
@@ -771,12 +841,24 @@ static ssize_t unassign_domain_store(struct device *dev,
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
+
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(unassign_domain);
 
+static void vfio_ap_mdev_hot_plug_cdom(struct ap_matrix_mdev *matrix_mdev,
+				       unsigned long domid)
+{
+	if (!test_bit_inv(domid, matrix_mdev->shadow_apcb.adm) &&
+	    test_bit_inv(domid, (unsigned long *) matrix_dev->info.adm)) {
+		set_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
+	}
+}
+
 /**
  * assign_control_domain_store
  *
@@ -802,10 +884,6 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &id);
 	if (ret)
 		return ret;
@@ -820,12 +898,22 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 */
 	mutex_lock(&matrix_dev->lock);
 	set_bit_inv(id, matrix_mdev->matrix.adm);
+	vfio_ap_mdev_hot_plug_cdom(matrix_mdev, id);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(assign_control_domain);
 
+static void vfio_ap_mdev_hot_unplug_cdom(struct ap_matrix_mdev *matrix_mdev,
+					unsigned long domid)
+{
+	if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
+		clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
+	}
+}
+
 /**
  * unassign_control_domain_store
  *
@@ -852,10 +940,6 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	/* If the guest is running, disallow un-assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &domid);
 	if (ret)
 		return ret;
@@ -864,6 +948,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
+	vfio_ap_mdev_hot_unplug_cdom(matrix_mdev, domid);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -1089,6 +1174,8 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 				  matrix_mdev->matrix.aqm,
 				  matrix_mdev->matrix.adm);
 
+	vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
+
 notify_done:
 	mutex_unlock(&matrix_dev->lock);
 	return notify_rc;
@@ -1330,6 +1417,8 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	vfio_ap_queue_link_mdev(q);
+	if (q->matrix_mdev)
+		vfio_ap_mdev_refresh_apcb(q->matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	return 0;
@@ -1337,6 +1426,7 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 
 void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 {
+	struct ap_matrix_mdev *matrix_mdev;
 	struct vfio_ap_queue *q;
 	int apid, apqi;
 
@@ -1347,8 +1437,11 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	apqi = AP_QID_QUEUE(q->apqn);
 	vfio_ap_mdev_reset_queue(apid, apqi, 1);
 
-	if (q->matrix_mdev)
+	if (q->matrix_mdev) {
+		matrix_mdev = q->matrix_mdev;
 		vfio_ap_mdev_unlink_queue(q);
+		vfio_ap_mdev_refresh_apcb(matrix_mdev);
+	}
 
 	kfree(q);
 	mutex_unlock(&matrix_dev->lock);
-- 
2.21.1

