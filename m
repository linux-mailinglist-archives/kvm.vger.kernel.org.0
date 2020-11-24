Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008072C3367
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 22:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388030AbgKXVlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 16:41:11 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21536 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733185AbgKXVkq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 16:40:46 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLWF0i116491;
        Tue, 24 Nov 2020 16:40:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3MYcAqCXJLi1SAS8RmIxDNuikj5WHIqIvtv/T8j4X9A=;
 b=E1nb1Avr3fq65rAZCNX6riIpDkGK9i2jfpKN8IrDH1lOGW0ECivMq4OgaFw3IwCXfWWe
 Gd9+Woy/z/kZ2g4knsEEa4pGsynEyPTzMw6lhOAfYnt9/wyWbX1Alx3JhLb5M0+eyBQT
 bapD5BREc1I+E7gENLmi988NFq7s6H4iNTo5XIVNXfvE5QEr7symUTchiZBf+k203F0M
 HrEKB6JjhWI+E5xDyzzkAp++xe4mX5EyspjToqi1FDaJuh5R7P0SjB0DTn+1C35fFRiy
 L9jEhRRvsHPkJvSYFVg8F9UMI49cRsDuqyPwn9jDeFAk8/Nub0wVD9xlrRIapdQ5RSwX BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350rkptyu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:43 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AOLWEa9116409;
        Tue, 24 Nov 2020 16:40:43 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350rkptytw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:43 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLc7Rv032749;
        Tue, 24 Nov 2020 21:40:42 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 34xth9hb12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 21:40:42 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOLeflT11797170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 21:40:41 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3090AE063;
        Tue, 24 Nov 2020 21:40:40 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E2A6AE05F;
        Tue, 24 Nov 2020 21:40:39 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.195.249])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 21:40:39 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v12 12/17] s390/vfio-ap: allow hot plug/unplug of AP resources using mdev device
Date:   Tue, 24 Nov 2020 16:40:11 -0500
Message-Id: <20201124214016.3013-13-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201124214016.3013-1-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_07:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=3 priorityscore=1501 mlxlogscore=999 spamscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's hot plug/unplug adapters, domains and control domains assigned to or
unassigned from an AP matrix mdev device while it is in use by a guest per
the following rules:

* Assign an adapter to mdev's matrix:

  The adapter will be hot plugged into the guest under the following
  conditions:
  1. The adapter is not yet assigned to the guest's matrix
  2. At least one domain is assigned to the guest's matrix
  3. Each APQN derived from the APID of the newly assigned adapter and
     the APQIs of the domains already assigned to the guest's
     matrix references a queue device bound to the vfio_ap device driver.

  The adapter and each domain assigned to the mdev's matrix will be hot
  plugged into the guest under the following conditions:
  1. The adapter is not yet assigned to the guest's matrix
  2. No domains are assigned to the guest's matrix
  3  At least one domain is assigned to the mdev's matrix
  4. Each APQN derived from the APID of the newly assigned adapter and
     the APQIs of the domains assigned to the mdev's matrix references a
     queue device bound to the vfio_ap device driver.

* Unassign an adapter from mdev's matrix:

  The adapter will be hot unplugged from the KVM guest if it is
  assigned to the guest's matrix.

* Assign a domain to mdev's matrix:

  The domain will be hot plugged into the guest under the following
  conditions:
  1. The domain is not yet assigned to the guest's matrix
  2. At least one adapter is assigned to the guest's matrix
  3. Each APQN derived from the APQI of the newly assigned domain and
     the APIDs of the adapters already assigned to the guest's
     matrix references a queue device bound to the vfio_ap device driver.

  The domain and each adapter assigned to the mdev's matrix will be hot
  plugged into the guest under the following conditions:
  1. The domain is not yet assigned to the guest's matrix
  2. No adapters are assigned to the guest's matrix
  3  At least one adapter is assigned to the mdev's matrix
  4. Each APQN derived from the APQI of the newly assigned domain and
     the APIDs of the adapters assigned to the mdev's matrix references a
     queue device bound to the vfio_ap device driver.

* Unassign adapter from mdev's matrix:

  The domain will be hot unplugged from the KVM guest if it is
  assigned to the guest's matrix.

* Assign a control domain:

  The control domain will be hot plugged into the KVM guest if it is not
  assigned to the guest's APCB. The AP architecture ensures a guest will
  only get access to the control domain if it is in the host's AP
  configuration, so there is no risk in hot plugging it; however, it will
  become automatically available to the guest when it is added to the host
  configuration.

* Unassign a control domain:

  The control domain will be hot unplugged from the KVM guest if it is
  assigned to the guest's APCB.

Note: Now that hot plug/unplug is implemented, there is the possibility
      that an assignment/unassignment of an adapter, domain or control
      domain could be initiated while the guest is starting, so the
      matrix device lock will be taken for the group notification callback
      that initializes the guest's APCB when the KVM pointer is made
      available to the vfio_ap device driver.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 190 +++++++++++++++++++++++++-----
 1 file changed, 159 insertions(+), 31 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 586ec5776693..4f96b7861607 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -631,6 +631,60 @@ static void vfio_ap_mdev_manage_qlinks(struct ap_matrix_mdev *matrix_mdev,
 	}
 }
 
+static bool vfio_ap_assign_apid_to_apcb(struct ap_matrix_mdev *matrix_mdev,
+					unsigned long apid)
+{
+	unsigned long apqi, apqn;
+	unsigned long *aqm = matrix_mdev->shadow_apcb.aqm;
+
+	/*
+	 * If the APID is already assigned to the guest's shadow APCB, there is
+	 * no need to assign it.
+	 */
+	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm))
+		return false;
+
+	/*
+	 * If no domains have yet been assigned to the shadow APCB and one or
+	 * more domains have been assigned to the matrix mdev, then use
+	 * the domains assigned to the matrix mdev; otherwise, there is nothing
+	 * to assign to the shadow APCB.
+	 */
+	if (bitmap_empty(matrix_mdev->shadow_apcb.aqm, AP_DOMAINS)) {
+		if (bitmap_empty(matrix_mdev->matrix.aqm, AP_DOMAINS))
+			return false;
+
+		aqm = matrix_mdev->matrix.aqm;
+	}
+
+	/* Make sure all APQNs are bound to the vfio_ap driver */
+	for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
+		apqn = AP_MKQID(apid, apqi);
+
+		if (vfio_ap_mdev_get_queue(matrix_mdev, apqn) == NULL)
+			return false;
+	}
+
+	set_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+
+	/*
+	 * If we verified APQNs using the domains assigned to the matrix mdev,
+	 * then copy the APQIs of those domains into the guest's APCB
+	 */
+	if (bitmap_empty(matrix_mdev->shadow_apcb.aqm, AP_DOMAINS))
+		bitmap_copy(matrix_mdev->shadow_apcb.aqm,
+			    matrix_mdev->matrix.aqm, AP_DOMAINS);
+
+	return true;
+}
+
+static void vfio_ap_mdev_hot_plug_adapter(struct ap_matrix_mdev *matrix_mdev,
+					  unsigned long apid)
+{
+	if (vfio_ap_assign_apid_to_apcb(matrix_mdev, apid))
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
+}
+
 /**
  * assign_adapter_store
  *
@@ -673,10 +727,6 @@ static ssize_t assign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
 		return ret;
@@ -698,12 +748,22 @@ static ssize_t assign_adapter_store(struct device *dev,
 	}
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_manage_qlinks(matrix_mdev, LINK_APID, apid);
+	vfio_ap_mdev_hot_plug_adapter(matrix_mdev, apid);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(assign_adapter);
 
+static void vfio_ap_mdev_hot_unplug_adapter(struct ap_matrix_mdev *matrix_mdev,
+					    unsigned long apid)
+{
+	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm)) {
+		clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
+	}
+}
+
 /**
  * unassign_adapter_store
  *
@@ -730,10 +790,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
 		return ret;
@@ -744,12 +800,67 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_manage_qlinks(matrix_mdev, UNLINK_APID, apid);
+	vfio_ap_mdev_hot_unplug_adapter(matrix_mdev, apid);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(unassign_adapter);
 
+static bool vfio_ap_assign_apqi_to_apcb(struct ap_matrix_mdev *matrix_mdev,
+					unsigned long apqi)
+{
+	unsigned long apid, apqn;
+	unsigned long *apm = matrix_mdev->shadow_apcb.apm;
+
+	/*
+	 * If the APQI is already assigned to the guest's shadow APCB, there is
+	 * no need to assign it.
+	 */
+	if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
+		return false;
+
+	/*
+	 * If no adapters have yet been assigned to the shadow APCB and one or
+	 * more adapters have been assigned to the matrix mdev, then use
+	 * the adapters assigned to the matrix mdev; otherwise, there is nothing
+	 * to assign to the shadow APCB.
+	 */
+	if (bitmap_empty(matrix_mdev->shadow_apcb.apm, AP_DEVICES)) {
+		if (bitmap_empty(matrix_mdev->matrix.apm, AP_DEVICES))
+			return false;
+
+		apm = matrix_mdev->matrix.apm;
+	}
+
+	/* Make sure all APQNs are bound to the vfio_ap driver */
+	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
+		apqn = AP_MKQID(apid, apqi);
+
+		if (vfio_ap_mdev_get_queue(matrix_mdev, apqn) == NULL)
+			return false;
+	}
+
+	set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
+
+	/*
+	 * If we verified APQNs using the adapters assigned to the matrix mdev,
+	 * then copy the APIDs of those adapters into the guest's APCB
+	 */
+	if (bitmap_empty(matrix_mdev->shadow_apcb.apm, AP_DEVICES))
+		bitmap_copy(matrix_mdev->shadow_apcb.apm,
+			    matrix_mdev->matrix.apm, AP_DEVICES);
+
+	return true;
+}
+
+static void vfio_ap_mdev_hot_plug_domain(struct ap_matrix_mdev *matrix_mdev,
+					 unsigned long apqi)
+{
+	if (vfio_ap_assign_apqi_to_apcb(matrix_mdev, apqi))
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
+}
+
 /**
  * assign_domain_store
  *
@@ -793,10 +904,6 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	/* If the guest is running, disallow assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		return ret;
@@ -817,12 +924,21 @@ static ssize_t assign_domain_store(struct device *dev,
 	}
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_manage_qlinks(matrix_mdev, LINK_APQI, apqi);
+	vfio_ap_mdev_hot_plug_domain(matrix_mdev, apqi);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(assign_domain);
 
+static void vfio_ap_mdev_hot_unplug_domain(struct ap_matrix_mdev *matrix_mdev,
+					   unsigned long apqi)
+{
+	if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
+		clear_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
+	}
+}
 
 /**
  * unassign_domain_store
@@ -850,10 +966,6 @@ static ssize_t unassign_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		return ret;
@@ -864,12 +976,22 @@ static ssize_t unassign_domain_store(struct device *dev,
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_manage_qlinks(matrix_mdev, UNLINK_APQI, apqi);
+	vfio_ap_mdev_hot_unplug_domain(matrix_mdev, apqi);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(unassign_domain);
 
+static void vfio_ap_mdev_hot_plug_ctl_domain(struct ap_matrix_mdev *matrix_mdev,
+					     unsigned long domid)
+{
+	if (!test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
+		set_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
+		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
+	}
+}
+
 /**
  * assign_control_domain_store
  *
@@ -895,10 +1017,6 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &id);
 	if (ret)
 		return ret;
@@ -914,12 +1032,23 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	if (!mutex_trylock(&matrix_dev->lock))
 		return -EBUSY;
 	set_bit_inv(id, matrix_mdev->matrix.adm);
+	vfio_ap_mdev_hot_plug_ctl_domain(matrix_mdev, id);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
 }
 static DEVICE_ATTR_WO(assign_control_domain);
 
+static void
+vfio_ap_mdev_hot_unplug_ctl_domain(struct ap_matrix_mdev *matrix_mdev,
+				   unsigned long domid)
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
@@ -946,10 +1075,6 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	/* If the guest is running, disallow un-assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &domid);
 	if (ret)
 		return ret;
@@ -958,6 +1083,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
+	vfio_ap_mdev_hot_unplug_ctl_domain(matrix_mdev, domid);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -1099,8 +1225,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 {
 	struct ap_matrix_mdev *m;
 
-	mutex_lock(&matrix_dev->lock);
-
 	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
 		if ((m != matrix_mdev) && (m->kvm == kvm)) {
 			mutex_unlock(&matrix_dev->lock);
@@ -1111,7 +1235,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 	matrix_mdev->kvm = kvm;
 	kvm_get_kvm(kvm);
 	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
-	mutex_unlock(&matrix_dev->lock);
 
 	return 0;
 }
@@ -1148,7 +1271,7 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
 static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 				       unsigned long action, void *data)
 {
-	int ret;
+	int ret = NOTIFY_DONE;
 	struct ap_matrix_mdev *matrix_mdev;
 
 	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
@@ -1156,23 +1279,28 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 
 	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
 
+	mutex_lock(&matrix_dev->lock);
+
 	if (!data) {
 		if (matrix_mdev->kvm)
 			kvm_put_kvm(matrix_mdev->kvm);
 
 		matrix_mdev->kvm = NULL;
 
-		return NOTIFY_OK;
+		ret = NOTIFY_OK;
+		goto done;
 	}
 
 	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
 	if (ret)
-		return NOTIFY_DONE;
+		goto done;
 
 	vfio_ap_mdev_init_apcb(matrix_mdev);
 	vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
 
-	return NOTIFY_OK;
+done:
+	mutex_unlock(&matrix_dev->lock);
+	return ret;
 }
 
 static int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
-- 
2.21.1

