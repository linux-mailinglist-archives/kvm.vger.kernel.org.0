Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B65436620
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhJUP0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:26:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31774 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232134AbhJUP0g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:26:36 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LFI2bS008882;
        Thu, 21 Oct 2021 11:24:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SfyWnHUABVEOF5NOrQQSuAsd1mYShw1katQzKV1fRkk=;
 b=RM2uBB91q//iXR6v8pnXaaxcK57+4L4pIhD4gHk+B50PhG0VogTccHk+PLlnXUg7TOMB
 ConhXJN+NvVVPAPoGchMESWkyUz27b7qjBndJQkKM7zc31CF/LMcHGkRKHz4GLVwOtwB
 jdtxl8EDvF8+OcSFNqNmWhPxqe5MdGDq5gD8sfWxQToe/8Klscmd6rMQVIMqqIyXZ5L/
 iTww8iebFMpFRKbRYPVieUXYo7bCncvbk6YD39XKZ1pd75MAwoBDWL7a+BPUbyegxIqq
 TbN1bNc9HsLcvmQ/scYg6Q5zjk+M2mfs3kPJNDN0lHcicYK6IT9YU3vCxCGgdLmqmtYK aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3buaqs039g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:24:18 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19LFJdbT012252;
        Thu, 21 Oct 2021 11:24:18 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3buaqs038x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:24:17 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LF42dv009593;
        Thu, 21 Oct 2021 15:24:17 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 3bqpccfquc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 15:24:17 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LFOF8s28246354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 15:24:15 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EC1ABE05B;
        Thu, 21 Oct 2021 15:24:15 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2364BBE065;
        Thu, 21 Oct 2021 15:24:14 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com.com (unknown [9.160.98.118])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 15:24:13 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v17 12/15] s390/vfio-ap: implement in-use callback for vfio_ap driver
Date:   Thu, 21 Oct 2021 11:23:29 -0400
Message-Id: <20211021152332.70455-13-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021152332.70455-1-akrowiak@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: H5jqdUV8NPjUCHnVyKNLfdOszkQYh4yk
X-Proofpoint-ORIG-GUID: mzmWfLPrkS_jGuouOC5ABhbpeOVXmnij
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 suspectscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's implement the callback to indicate when an APQN
is in use by the vfio_ap device driver. The callback is
invoked whenever a change to the apmask or aqmask would
result in one or more queue devices being removed from the driver. The
vfio_ap device driver will indicate a resource is in use
if the APQN of any of the queue devices to be removed are assigned to
any of the matrix mdevs under the driver's control.

There is potential for a deadlock condition between the matrix_dev->lock
used to lock the matrix device during assignment of adapters and domains
and the ap_perms_mutex locked by the AP bus when changes are made to the
sysfs apmask/aqmask attributes.

Consider following scenario (courtesy of Halil Pasic):
1) apmask_store() takes ap_perms_mutex
2) assign_adapter_store() takes matrix_dev->lock
3) apmask_store() calls vfio_ap_mdev_resource_in_use() which tries
to take matrix_dev->lock
4) assign_adapter_store() calls ap_apqn_in_matrix_owned_by_def_drv
which tries to take ap_perms_mutex
BANG!

To resolve this issue, instead of using the mutex_lock(&matrix_dev->lock)
function to lock the matrix device during assignment of an adapter or
domain to a matrix_mdev as well as during the in_use callback, the
mutex_trylock(&matrix_dev->lock) function will be used. If the lock is not
obtained, then the assignment and in_use functions will terminate with
-EAGAIN.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  1 +
 drivers/s390/crypto/vfio_ap_ops.c     | 80 ++++++++++++++++++++++++---
 drivers/s390/crypto/vfio_ap_private.h |  2 +
 3 files changed, 74 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 1d1746fe50ea..df7528dcf6ed 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -44,6 +44,7 @@ MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
 static struct ap_driver vfio_ap_drv = {
 	.probe = vfio_ap_mdev_probe_queue,
 	.remove = vfio_ap_mdev_remove_queue,
+	.in_use = vfio_ap_mdev_resource_in_use,
 	.ids = ap_queue_ids,
 };
 
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 6b292ed30ada..5386b8635bec 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -635,16 +635,45 @@ static void vfio_ap_mdev_link_adapter(struct ap_matrix_mdev *matrix_mdev,
  * vfio_ap_mdev_get_locks - lock the kvm->lock and matrix_dev->lock mutexes
  *
  * @matrix_mdev: the matrix mediated device object
+ * @check_mdev_lock: indicates whether to check that the matrix_dev->lock mutex
+ *		     is already locked (true = check, false = do not check).
+ *
+ * Return:
+ *	-EAGAIN if the matrix_dev->lock mutex is already locked.
+ *	0 if both locks were acquired.
  */
-static void vfio_ap_mdev_get_locks(struct ap_matrix_mdev *matrix_mdev)
+static int vfio_ap_mdev_get_locks(struct ap_matrix_mdev *matrix_mdev,
+				  bool check_mdev_lock)
 {
+	/*
+	 * If the matrix_dev->lock mutex is to be checked, then there's no
+	 * sense in proceding if it is already locked.
+	 */
+	if (check_mdev_lock && mutex_is_locked(&matrix_dev->lock))
+		return -EAGAIN;
+
 	down_read(&matrix_dev->guests_lock);
 
 	/* The kvm->lock must be must be taken before the matrix_dev->lock */
 	if (matrix_mdev->guest)
 		mutex_lock(&matrix_mdev->guest->kvm->lock);
 
-	mutex_lock(&matrix_dev->lock);
+	/*
+	 * If the matrix_dev-> lock is to be checked, then let's try to acquire
+	 * it. If it can't be acquired, then let's bail out and return
+	 * a value indicating locking should be tried again.
+	 */
+	if (check_mdev_lock) {
+		if (!mutex_trylock(&matrix_dev->lock)) {
+			mutex_unlock(&matrix_mdev->guest->kvm->lock);
+			up_read(&matrix_dev->guests_lock);
+			return -EAGAIN;
+		}
+	} else {
+		mutex_lock(&matrix_dev->lock);
+	}
+
+	return 0;
 }
 
 /**
@@ -654,7 +683,6 @@ static void vfio_ap_mdev_get_locks(struct ap_matrix_mdev *matrix_mdev)
  */
 static void vfio_ap_mdev_put_locks(struct ap_matrix_mdev *matrix_mdev)
 {
-	/* The kvm->lock must be must be taken before the matrix_dev->lock */
 	if (matrix_mdev->guest)
 		mutex_unlock(&matrix_mdev->guest->kvm->lock);
 
@@ -691,6 +719,10 @@ static void vfio_ap_mdev_put_locks(struct ap_matrix_mdev *matrix_mdev)
  *	   An APQN derived from the cross product of the APID being assigned
  *	   and the APQIs previously assigned is being used by another mediated
  *	   matrix device
+ *
+ *     5. -EAGAIN
+ *        The mdev lock could not be acquired which is required in order to
+ *        change the AP configuration for the mdev
  */
 static ssize_t assign_adapter_store(struct device *dev,
 				    struct device_attribute *attr,
@@ -707,7 +739,10 @@ static ssize_t assign_adapter_store(struct device *dev,
 	if (apid > matrix_mdev->matrix.apm_max)
 		return -ENODEV;
 
-	vfio_ap_mdev_get_locks(matrix_mdev);
+	ret = vfio_ap_mdev_get_locks(matrix_mdev, true);
+	if (ret)
+		return ret;
+
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
 
 	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
@@ -815,7 +850,10 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	if (apid > matrix_mdev->matrix.apm_max)
 		return -ENODEV;
 
-	vfio_ap_mdev_get_locks(matrix_mdev);
+	ret = vfio_ap_mdev_get_locks(matrix_mdev, false);
+	if (ret)
+		return ret;
+
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_hot_unplug_adapter(matrix_mdev, apid);
 	vfio_ap_mdev_put_locks(matrix_mdev);
@@ -879,7 +917,10 @@ static ssize_t assign_domain_store(struct device *dev,
 	if (apqi > max_apqi)
 		return -ENODEV;
 
-	vfio_ap_mdev_get_locks(matrix_mdev);
+	ret = vfio_ap_mdev_get_locks(matrix_mdev, true);
+	if (ret)
+		return ret;
+
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
 
 	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
@@ -962,7 +1003,10 @@ static ssize_t unassign_domain_store(struct device *dev,
 	if (apqi > matrix_mdev->matrix.aqm_max)
 		return -ENODEV;
 
-	vfio_ap_mdev_get_locks(matrix_mdev);
+	ret = vfio_ap_mdev_get_locks(matrix_mdev, false);
+	if (ret)
+		return ret;
+
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_hot_unplug_domain(matrix_mdev, apqi);
 	vfio_ap_mdev_put_locks(matrix_mdev);
@@ -1000,7 +1044,9 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	if (id > matrix_mdev->matrix.adm_max)
 		return -ENODEV;
 
-	vfio_ap_mdev_get_locks(matrix_mdev);
+	ret = vfio_ap_mdev_get_locks(matrix_mdev, false);
+	if (ret)
+		return ret;
 
 	/* Set the bit in the ADM (bitmask) corresponding to the AP control
 	 * domain number (id). The bits in the mask, from most significant to
@@ -1047,7 +1093,10 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	if (domid > max_domid)
 		return -ENODEV;
 
-	vfio_ap_mdev_get_locks(matrix_mdev);
+	ret = vfio_ap_mdev_get_locks(matrix_mdev, false);
+	if (ret)
+		return ret;
+
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
 
 	if (vfio_ap_mdev_filter_cdoms(matrix_mdev))
@@ -1681,3 +1730,16 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	vfio_ap_mdev_put_qlocks(guest);
 	kfree(q);
 }
+
+int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
+{
+	int ret;
+
+	if (!mutex_trylock(&matrix_dev->lock))
+		return -EBUSY;
+
+	ret = vfio_ap_mdev_verify_no_sharing(apm, aqm);
+	mutex_unlock(&matrix_dev->lock);
+
+	return ret;
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 5d59bba8b153..97da41f87c65 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -149,4 +149,6 @@ void vfio_ap_mdev_unregister(void);
 int vfio_ap_mdev_probe_queue(struct ap_device *queue);
 void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
+int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.31.1

