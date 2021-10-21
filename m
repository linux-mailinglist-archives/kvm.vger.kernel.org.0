Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E672F436616
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhJUP0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:26:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12428 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231833AbhJUP03 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:26:29 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEBxZ2026868;
        Thu, 21 Oct 2021 11:24:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Fwa+ixfhx945VSlyuzhpDZvI7tkAN13lmAFl4Vhr6r8=;
 b=OQyuPRmnU8OuYmIeK+aJmU4eJByJ/mz67yDpYouMEMavGEXGaAPRAxFbBfVCcEeo0k3e
 Yc14t+JhfN5tmvLRPoaqjPfyxkKD7WphehtoBCkA+viMRqssfxsUWdtprZ1oVu8b76gH
 YRxA23TPqP0WqcdDmeN7k9UWczFcIRlWeXNlQzk/Q9yE8VJXrWgUKMWcb8l6D9631aoI
 4Za1SSqybuth07GSNp1q6mskuZ942wYY9DnbFisOd2qBVMowz7D8GyHagSIllxZqsAC2
 cqR/uG+GauWb1CwlQjRx//CVV5q4hXtMjiXvy4B9OXU6rX9ojm2Bqxgq+0t2nEvA+pHF ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btthkw4w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:24:12 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19LF0FsT029507;
        Thu, 21 Oct 2021 11:24:12 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btthkw4vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:24:11 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LF3ifX004818;
        Thu, 21 Oct 2021 15:24:11 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 3bqpcd8hux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 15:24:10 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LFO9sb22282762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 15:24:09 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D58EBE05D;
        Thu, 21 Oct 2021 15:24:09 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DC18BE05B;
        Thu, 21 Oct 2021 15:24:07 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com.com (unknown [9.160.98.118])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 15:24:07 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v17 09/15] s390/vfio-ap: allow hot plug/unplug of AP resources using mdev device
Date:   Thu, 21 Oct 2021 11:23:26 -0400
Message-Id: <20211021152332.70455-10-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021152332.70455-1-akrowiak@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qG8TzNi689NroA-AmlAGVNjDzzukGEpd
X-Proofpoint-GUID: C86LBx8eYtpO1jHO5jjCP7OmD_evkxZb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210079
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
is executed, the AP configuration assigned to the matrix mediated device
will be filtered and assigned to the AP control block (APCB) that supplies
the AP configuration to the guest so that no adapter, domain or control
domain that is not in the host's AP configuration nor any APQN that does
not reference a queue device bound to the vfio_ap device driver is
assigned.

After updating the APCB, if the mdev is in use by a KVM guest, it is
hot plugged into the guest to dynamically provide access to the adapters,
domains and control domains provided via the newly refreshed APCB.

Keep in mind that the kvm->lock must be taken outside of the
matrix_mdev->lock to avoid circular lock dependencies (i.e., a lockdep
splat). This will necessitate taking the matrix_dev->guests_lock in order
to find the guest(s) in the matrix_dev->guests list to which the affected
APQN(s) may be assigned. The kvm->lock can then be taken prior to the
matrix_dev->lock and the APCB plugged into the guest without any problem.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 388 ++++++++++++++++----------
 drivers/s390/crypto/vfio_ap_private.h |   7 +-
 2 files changed, 238 insertions(+), 157 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index a2875cf79091..5a484e7afbd0 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -105,8 +105,8 @@ static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
 	if (!q)
 		return;
 	if (q->saved_isc != VFIO_AP_ISC_INVALID &&
-	    !WARN_ON(!(q->matrix_mdev && q->matrix_mdev->kvm))) {
-		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
+	    !WARN_ON(!(q->matrix_mdev && q->matrix_mdev->guest->kvm))) {
+		kvm_s390_gisc_unregister(q->matrix_mdev->guest->kvm, q->saved_isc);
 		q->saved_isc = VFIO_AP_ISC_INVALID;
 	}
 	if (q->saved_pfn && !WARN_ON(!q->matrix_mdev)) {
@@ -211,7 +211,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
 		return status;
 	}
 
-	kvm = q->matrix_mdev->kvm;
+	kvm = q->matrix_mdev->guest->kvm;
 	gisa = kvm->arch.gisa_int.origin;
 
 	h_nib = (h_pfn << PAGE_SHIFT) | (nib & ~PAGE_MASK);
@@ -283,7 +283,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	matrix_mdev = vcpu->kvm->arch.crypto.data;
 
 	/* If the there is no guest using the mdev, there is nothing to do */
-	if (!matrix_mdev || !matrix_mdev->kvm)
+	if (!matrix_mdev || !matrix_mdev->guest->kvm)
 		goto out_unlock;
 
 	q = vfio_ap_mdev_get_queue(matrix_mdev, apqn);
@@ -314,10 +314,25 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
-static void vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
+static void vfio_ap_mdev_hotplug_apcb(struct ap_matrix_mdev *matrix_mdev)
 {
+	if (matrix_mdev->guest->kvm)
+		kvm_arch_crypto_set_masks(matrix_mdev->guest->kvm,
+					  matrix_mdev->shadow_apcb.apm,
+					  matrix_mdev->shadow_apcb.aqm,
+					  matrix_mdev->shadow_apcb.adm);
+}
+
+static bool vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
+{
+	DECLARE_BITMAP(shadow_adm, AP_DOMAINS);
+
+	bitmap_copy(shadow_adm, matrix_mdev->shadow_apcb.adm, AP_DOMAINS);
 	bitmap_and(matrix_mdev->shadow_apcb.adm, matrix_mdev->matrix.adm,
 		   (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);
+
+	return !bitmap_equal(shadow_adm, matrix_mdev->shadow_apcb.adm,
+			     AP_DOMAINS);
 }
 
 /*
@@ -327,16 +342,23 @@ static void vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
  *				queue device bound to the vfio_ap device driver.
  *
  * @matrix_mdev: the mdev whose AP configuration is to be filtered.
+ *
+ * Return: a boolean value indicating whether the KVM guest's APCB was changed
+ *	   by the filtering or not.
  */
-static void vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev)
+static bool vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev)
 {
 	int ret;
 	unsigned long apid, apqi, apqn;
+	DECLARE_BITMAP(shadow_apm, AP_DEVICES);
+	DECLARE_BITMAP(shadow_aqm, AP_DOMAINS);
 
 	ret = ap_qci(&matrix_dev->info);
 	if (ret)
-		return;
+		return false;
 
+	bitmap_copy(shadow_apm, matrix_mdev->shadow_apcb.apm, AP_DEVICES);
+	bitmap_copy(shadow_aqm, matrix_mdev->shadow_apcb.aqm, AP_DOMAINS);
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
 
 	/*
@@ -368,6 +390,11 @@ static void vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev)
 			}
 		}
 	}
+
+	return !bitmap_equal(shadow_apm, matrix_mdev->shadow_apcb.apm,
+			     AP_DEVICES) ||
+	       !bitmap_equal(shadow_aqm, matrix_mdev->shadow_apcb.aqm,
+			     AP_DOMAINS);
 }
 
 static int vfio_ap_mdev_probe(struct mdev_device *mdev)
@@ -607,6 +634,37 @@ static void vfio_ap_mdev_link_adapter(struct ap_matrix_mdev *matrix_mdev,
 				       AP_MKQID(apid, apqi));
 }
 
+/**
+ * vfio_ap_mdev_get_locks - lock the kvm->lock and matrix_dev->lock mutexes
+ *
+ * @matrix_mdev: the matrix mediated device object
+ */
+static void vfio_ap_mdev_get_locks(struct ap_matrix_mdev *matrix_mdev)
+{
+	down_read(&matrix_dev->guests_lock);
+
+	/* The kvm->lock must be must be taken before the matrix_dev->lock */
+	if (matrix_mdev->guest)
+		mutex_lock(&matrix_mdev->guest->kvm->lock);
+
+	mutex_lock(&matrix_dev->lock);
+}
+
+/**
+ * vfio_ap_mdev_put_locks - release the kvm->lock and matrix_dev->lock mutexes
+ *
+ * @matrix_mdev: the matrix mediated device object
+ */
+static void vfio_ap_mdev_put_locks(struct ap_matrix_mdev *matrix_mdev)
+{
+	/* The kvm->lock must be must be taken before the matrix_dev->lock */
+	if (matrix_mdev->guest)
+		mutex_unlock(&matrix_mdev->guest->kvm->lock);
+
+	mutex_unlock(&matrix_dev->lock);
+	up_read(&matrix_dev->guests_lock);
+}
+
 /**
  * assign_adapter_store - parses the APID from @buf and sets the
  * corresponding bit in the mediated matrix device's APM
@@ -645,23 +703,14 @@ static ssize_t assign_adapter_store(struct device *dev,
 	unsigned long apid;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
-
-	/* If the KVM guest is running, disallow assignment of adapter */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
-		goto done;
+		return ret;
 
-	if (apid > matrix_mdev->matrix.apm_max) {
-		ret = -ENODEV;
-		goto done;
-	}
+	if (apid > matrix_mdev->matrix.apm_max)
+		return -ENODEV;
 
+	vfio_ap_mdev_get_locks(matrix_mdev);
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
 
 	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
@@ -671,10 +720,13 @@ static ssize_t assign_adapter_store(struct device *dev,
 	}
 
 	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
-	vfio_ap_mdev_filter_matrix(matrix_mdev);
+
+	if (vfio_ap_mdev_filter_matrix(matrix_mdev))
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	vfio_ap_mdev_put_locks(matrix_mdev);
 
 	return ret;
 }
@@ -717,30 +769,23 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	unsigned long apid;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
-
-	/* If the KVM guest is running, disallow unassignment of adapter */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
-		goto done;
+		return ret;
 
-	if (apid > matrix_mdev->matrix.apm_max) {
-		ret = -ENODEV;
-		goto done;
-	}
+	if (apid > matrix_mdev->matrix.apm_max)
+		return -ENODEV;
 
+	vfio_ap_mdev_get_locks(matrix_mdev);
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
-	vfio_ap_mdev_filter_matrix(matrix_mdev);
-	ret = count;
-done:
-	mutex_unlock(&matrix_dev->lock);
-	return ret;
+
+	if (vfio_ap_mdev_filter_matrix(matrix_mdev))
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+
+	vfio_ap_mdev_put_locks(matrix_mdev);
+
+	return count;
 }
 static DEVICE_ATTR_WO(unassign_adapter);
 
@@ -793,22 +838,13 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	mutex_lock(&matrix_dev->lock);
-
-	/* If the KVM guest is running, disallow assignment of domain */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
-		goto done;
-	if (apqi > max_apqi) {
-		ret = -ENODEV;
-		goto done;
-	}
+		return ret;
+	if (apqi > max_apqi)
+		return -ENODEV;
 
+	vfio_ap_mdev_get_locks(matrix_mdev);
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
 
 	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
@@ -818,10 +854,13 @@ static ssize_t assign_domain_store(struct device *dev,
 	}
 
 	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
-	vfio_ap_mdev_filter_matrix(matrix_mdev);
+
+	if (vfio_ap_mdev_filter_matrix(matrix_mdev))
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+
 	ret = count;
 done:
-	mutex_unlock(&matrix_dev->lock);
+	vfio_ap_mdev_put_locks(matrix_mdev);
 
 	return ret;
 }
@@ -864,31 +903,23 @@ static ssize_t unassign_domain_store(struct device *dev,
 	unsigned long apqi;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
-
-	/* If the KVM guest is running, disallow unassignment of domain */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
-		goto done;
+		return ret;
 
-	if (apqi > matrix_mdev->matrix.aqm_max) {
-		ret = -ENODEV;
-		goto done;
-	}
+	if (apqi > matrix_mdev->matrix.aqm_max)
+		return -ENODEV;
 
+	vfio_ap_mdev_get_locks(matrix_mdev);
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
-	vfio_ap_mdev_filter_matrix(matrix_mdev);
-	ret = count;
 
-done:
-	mutex_unlock(&matrix_dev->lock);
-	return ret;
+	if (vfio_ap_mdev_filter_matrix(matrix_mdev))
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+
+	vfio_ap_mdev_put_locks(matrix_mdev);
+
+	return count;
 }
 static DEVICE_ATTR_WO(unassign_domain);
 
@@ -914,22 +945,14 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	unsigned long id;
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
-	mutex_lock(&matrix_dev->lock);
-
-	/* If the KVM guest is running, disallow assignment of control domain */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
-
 	ret = kstrtoul(buf, 0, &id);
 	if (ret)
-		goto done;
+		return ret;
 
-	if (id > matrix_mdev->matrix.adm_max) {
-		ret = -ENODEV;
-		goto done;
-	}
+	if (id > matrix_mdev->matrix.adm_max)
+		return -ENODEV;
+
+	vfio_ap_mdev_get_locks(matrix_mdev);
 
 	/* Set the bit in the ADM (bitmask) corresponding to the AP control
 	 * domain number (id). The bits in the mask, from most significant to
@@ -937,11 +960,13 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 * number of control domains that can be assigned.
 	 */
 	set_bit_inv(id, matrix_mdev->matrix.adm);
-	vfio_ap_mdev_filter_cdoms(matrix_mdev);
-	ret = count;
-done:
-	mutex_unlock(&matrix_dev->lock);
-	return ret;
+
+	if (vfio_ap_mdev_filter_cdoms(matrix_mdev))
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+
+	vfio_ap_mdev_put_locks(matrix_mdev);
+
+	return count;
 }
 static DEVICE_ATTR_WO(assign_control_domain);
 
@@ -968,28 +993,21 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	mutex_lock(&matrix_dev->lock);
-
-	/* If a KVM guest is running, disallow unassignment of control domain */
-	if (matrix_mdev->kvm) {
-		ret = -EBUSY;
-		goto done;
-	}
-
 	ret = kstrtoul(buf, 0, &domid);
 	if (ret)
-		goto done;
-	if (domid > max_domid) {
-		ret = -ENODEV;
-		goto done;
-	}
+		return ret;
+	if (domid > max_domid)
+		return -ENODEV;
 
+	vfio_ap_mdev_get_locks(matrix_mdev);
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
-	clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
-	ret = count;
-done:
-	mutex_unlock(&matrix_dev->lock);
-	return ret;
+
+	if (vfio_ap_mdev_filter_cdoms(matrix_mdev))
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+
+	vfio_ap_mdev_put_locks(matrix_mdev);
+
+	return count;
 }
 static DEVICE_ATTR_WO(unassign_control_domain);
 
@@ -1095,6 +1113,9 @@ static int vfio_ap_mdev_create_guest(struct kvm *kvm,
 	if (!guest)
 		return -ENOMEM;
 
+	guest->kvm = kvm;
+	guest->matrix_mdev = matrix_mdev;
+	matrix_mdev->guest = guest;
 	list_add(&guest->node, &matrix_dev->guests);
 
 	return 0;
@@ -1123,17 +1144,15 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 	int ret;
 	struct ap_matrix_mdev *m;
 
-	if (kvm->arch.crypto.crycbd) {
-		down_write(&matrix_dev->guests_lock);
-		ret = vfio_ap_mdev_create_guest(kvm, matrix_mdev);
-		if (WARN_ON(ret))
-			return ret;
+	down_write(&matrix_dev->guests_lock);
 
+	if (kvm->arch.crypto.crycbd) {
 		mutex_lock(&kvm->lock);
 		mutex_lock(&matrix_dev->lock);
 
 		list_for_each_entry(m, &matrix_dev->mdev_list, node) {
-			if (m != matrix_mdev && m->kvm == kvm) {
+			if (m != matrix_mdev && m->guest &&
+			    m->guest->kvm == kvm) {
 				mutex_unlock(&matrix_dev->lock);
 				mutex_unlock(&kvm->lock);
 				up_write(&matrix_dev->guests_lock);
@@ -1141,18 +1160,27 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 			}
 		}
 
-		kvm_get_kvm(kvm);
-		matrix_mdev->kvm = kvm;
+		ret = vfio_ap_mdev_create_guest(kvm, matrix_mdev);
+		if (WARN_ON(ret)) {
+			mutex_unlock(&matrix_dev->lock);
+			mutex_unlock(&kvm->lock);
+			up_write(&matrix_dev->guests_lock);
+			return ret;
+		}
+
+		kvm_get_kvm(matrix_mdev->guest->kvm);
 		kvm->arch.crypto.data = matrix_mdev;
-		kvm_arch_crypto_set_masks(kvm, matrix_mdev->shadow_apcb.apm,
+		kvm_arch_crypto_set_masks(matrix_mdev->guest->kvm,
+					  matrix_mdev->shadow_apcb.apm,
 					  matrix_mdev->shadow_apcb.aqm,
 					  matrix_mdev->shadow_apcb.adm);
 
 		mutex_unlock(&matrix_dev->lock);
-		mutex_unlock(&kvm->lock);
-		up_write(&matrix_dev->guests_lock);
+		mutex_unlock(&matrix_mdev->guest->kvm->lock);
 	}
 
+	up_write(&matrix_dev->guests_lock);
+
 	return 0;
 }
 
@@ -1186,16 +1214,11 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static void vfio_ap_mdev_remove_guest(struct kvm *kvm)
+static void vfio_ap_mdev_remove_guest(struct ap_matrix_mdev *matrix_mdev)
 {
-	struct ap_guest *guest, *tmp;
-
-	list_for_each_entry_safe(guest, tmp, &matrix_dev->guests, node) {
-		if (guest->kvm == kvm) {
-			list_del(&guest->node);
-			break;
-		}
-	}
+	list_del(&matrix_mdev->guest->node);
+	matrix_mdev->guest = NULL;
+	kfree(matrix_mdev->guest);
 }
 
 /**
@@ -1203,7 +1226,6 @@ static void vfio_ap_mdev_remove_guest(struct kvm *kvm)
  * by @matrix_mdev.
  *
  * @matrix_mdev: a matrix mediated device
- * @kvm: the pointer to the kvm structure being unset.
  *
  * Note: The matrix_dev->lock must be taken prior to calling
  * this function; however, the lock will be temporarily released while the
@@ -1212,26 +1234,25 @@ static void vfio_ap_mdev_remove_guest(struct kvm *kvm)
  * certain circumstances, will result in a circular lock dependency if this is
  * done under the @matrix_mdev->lock.
  */
-static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev,
-				   struct kvm *kvm)
+static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 {
-	if (kvm && kvm->arch.crypto.crycbd) {
-		down_write(&matrix_dev->guests_lock);
-		vfio_ap_mdev_remove_guest(kvm);
+	down_write(&matrix_dev->guests_lock);
 
-		mutex_lock(&kvm->lock);
+	if (matrix_mdev->guest) {
+		mutex_lock(&matrix_mdev->guest->kvm->lock);
 		mutex_lock(&matrix_dev->lock);
 
-		kvm_arch_crypto_clear_masks(kvm);
+		kvm_arch_crypto_clear_masks(matrix_mdev->guest->kvm);
 		vfio_ap_mdev_reset_queues(matrix_mdev);
-		kvm_put_kvm(kvm);
-		kvm->arch.crypto.data = NULL;
-		matrix_mdev->kvm = NULL;
+		matrix_mdev->guest->kvm->arch.crypto.data = NULL;
+		kvm_put_kvm(matrix_mdev->guest->kvm);
 
 		mutex_unlock(&matrix_dev->lock);
-		mutex_unlock(&kvm->lock);
-		up_write(&matrix_dev->guests_lock);
+		mutex_unlock(&matrix_mdev->guest->kvm->lock);
+		vfio_ap_mdev_remove_guest(matrix_mdev);
 	}
+
+	up_write(&matrix_dev->guests_lock);
 }
 
 static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
@@ -1246,7 +1267,7 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
 
 	if (!data)
-		vfio_ap_mdev_unset_kvm(matrix_mdev, matrix_mdev->kvm);
+		vfio_ap_mdev_unset_kvm(matrix_mdev);
 	else if (vfio_ap_mdev_set_kvm(matrix_mdev, data))
 		notify_rc = NOTIFY_DONE;
 
@@ -1377,7 +1398,7 @@ static void vfio_ap_mdev_close_device(struct vfio_device *vdev)
 				 &matrix_mdev->iommu_notifier);
 	vfio_unregister_notifier(vdev->dev, VFIO_GROUP_NOTIFY,
 				 &matrix_mdev->group_notifier);
-	vfio_ap_mdev_unset_kvm(matrix_mdev, matrix_mdev->kvm);
+	vfio_ap_mdev_unset_kvm(matrix_mdev);
 }
 
 static int vfio_ap_mdev_get_device_info(unsigned long arg)
@@ -1504,38 +1525,99 @@ static void vfio_ap_queue_link_mdev(struct vfio_ap_queue *q)
 	}
 }
 
+/**
+ * vfio_ap_mdev_get_qlocks: lock all of the locks required for probe/remove
+ *			    callbacks.
+ *
+ * @apqn: the APQN of the queue device being probed or removed
+ *
+ * Return: the struct ap_guest object using the matrix mdev to which @apqn is
+ *	   assigned.
+ */
+static struct ap_guest *vfio_ap_mdev_get_qlocks(int apqn)
+{
+	struct ap_guest *guest;
+	unsigned long apid = AP_QID_CARD(apqn);
+	unsigned long apqi = AP_QID_QUEUE(apqn);
+
+	down_read(&matrix_dev->guests_lock);
+
+	list_for_each_entry(guest, &matrix_dev->guests, node) {
+		if (test_bit_inv(apid, guest->matrix_mdev->matrix.apm) &&
+		    test_bit_inv(apqi, guest->matrix_mdev->matrix.aqm)) {
+			mutex_lock(&guest->kvm->lock);
+			mutex_lock(&matrix_dev->lock);
+
+			return guest;
+		}
+	}
+
+	mutex_lock(&matrix_dev->lock);
+
+	return NULL;
+}
+
+/**
+ * vfio_ap_mdev_put_qlocks - unlock all of the locks required for probe/remove
+ *			     callbacks.
+ *
+ * @guest: the guest using the queue device being probed/removed
+ */
+static void vfio_ap_mdev_put_qlocks(struct ap_guest *guest)
+{
+	if (guest)
+		mutex_unlock(&guest->kvm->lock);
+
+	mutex_unlock(&matrix_dev->lock);
+	up_read(&matrix_dev->guests_lock);
+}
+
 int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 {
 	struct vfio_ap_queue *q;
+	struct ap_guest *guest;
+	int apqn = to_ap_queue(&apdev->device)->qid;
 
 	q = kzalloc(sizeof(*q), GFP_KERNEL);
 	if (!q)
 		return -ENOMEM;
 
-	mutex_lock(&matrix_dev->lock);
-	q->apqn = to_ap_queue(&apdev->device)->qid;
+	q->apqn = apqn;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
-	vfio_ap_queue_link_mdev(q);
-	if (q->matrix_mdev)
-		vfio_ap_mdev_filter_matrix(q->matrix_mdev);
+	guest = vfio_ap_mdev_get_qlocks(apqn);
+
+	if (guest) {
+		vfio_ap_mdev_link_queue(guest->matrix_mdev, q);
+
+		if (vfio_ap_mdev_filter_matrix(guest->matrix_mdev))
+			vfio_ap_mdev_hotplug_apcb(guest->matrix_mdev);
+	} else {
+		vfio_ap_queue_link_mdev(q);
+	}
+
 	dev_set_drvdata(&apdev->device, q);
-	mutex_unlock(&matrix_dev->lock);
+	vfio_ap_mdev_put_qlocks(guest);
 
 	return 0;
 }
 
 void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 {
+	struct ap_guest *guest;
 	struct vfio_ap_queue *q;
+	int apqn = to_ap_queue(&apdev->device)->qid;
 
-	mutex_lock(&matrix_dev->lock);
+	guest = vfio_ap_mdev_get_qlocks(apqn);
 	q = dev_get_drvdata(&apdev->device);
 
-	if (q->matrix_mdev)
+	if (q->matrix_mdev) {
 		vfio_ap_unlink_queue_fr_mdev(q);
+		if (vfio_ap_mdev_filter_matrix(q->matrix_mdev))
+			vfio_ap_mdev_hotplug_apcb(q->matrix_mdev);
+	}
 
 	vfio_ap_mdev_reset_queue(q, 1);
 	dev_set_drvdata(&apdev->device, NULL);
+	vfio_ap_mdev_put_qlocks(guest);
 	kfree(q);
-	mutex_unlock(&matrix_dev->lock);
 }
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 6d28b287d7bf..0e825ffbd0cc 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -28,6 +28,7 @@
 
 struct ap_guest {
 	struct kvm *kvm;
+	struct ap_matrix_mdev *matrix_mdev;
 	struct list_head node;
 };
 
@@ -106,11 +107,9 @@ struct ap_queue_table {
  *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
  * @iommu_notifier: notifier block used for specifying callback function for
  *		    handling the VFIO_IOMMU_NOTIFY_DMA_UNMAP even
- * @kvm:	the struct holding guest's state
- * @pqap_hook:	the function pointer to the interception handler for the
- *		PQAP(AQIC) instruction.
  * @mdev:	the mediated device
  * @qtable:	table of queues (struct vfio_ap_queue) assigned to the mdev
+ * @guest:	the KVM guest using the matrix mdev
  */
 struct ap_matrix_mdev {
 	struct vfio_device vdev;
@@ -119,9 +118,9 @@ struct ap_matrix_mdev {
 	struct ap_matrix shadow_apcb;
 	struct notifier_block group_notifier;
 	struct notifier_block iommu_notifier;
-	struct kvm *kvm;
 	struct mdev_device *mdev;
 	struct ap_queue_table qtable;
+	struct ap_guest *guest;
 };
 
 /**
-- 
2.31.1

