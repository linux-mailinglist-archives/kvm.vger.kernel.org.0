Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53523557F9
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 17:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345855AbhDFPcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 11:32:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40376 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345760AbhDFPcE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 11:32:04 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 136F3Por134323;
        Tue, 6 Apr 2021 11:31:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NNl3r1rojUhm55o51MbGtuTU1PqJB2bd2NDcPLdPgks=;
 b=DRoGnGYt6rSY18Ur6bS9U/Oaw9hPCpMrPNqcr6ez46zM3hem3/afjdTbFJiHhXgu/QGW
 oFBdtSWG1+7juEXxYrnl5QvSDToCy3TEsZty6UCjWYYwHwZS+vU88gMcb9T5Y6Pe4da6
 slmQmTGPpVk7JIKRqWI5WHlRUk+fxsimFy0mAFGeaoDzkPpx3aaEQ3PGbtBhXUvCAWxi
 Hm1wejniaetNb9BglFzoSaS/G+qNSoEBsiYiDYWn0dKIkiy8uosOOgi+SUBqVYUbTKe6
 Tt6OJ/feXoH7qhQ5fx2fh6ICZk2pnLzZY/+5mJtVu5J1VK7pulS19pdwD/nOuYF3AkGU Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5vvgtbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 11:31:55 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 136F3wvR137711;
        Tue, 6 Apr 2021 11:31:55 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5vvgtau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 11:31:55 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 136FN8Ck015691;
        Tue, 6 Apr 2021 15:31:53 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01dal.us.ibm.com with ESMTP id 37q2ntmxcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 15:31:53 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 136FVoaO29360456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 15:31:50 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36126BE04F;
        Tue,  6 Apr 2021 15:31:50 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A13ABBE053;
        Tue,  6 Apr 2021 15:31:48 +0000 (GMT)
Received: from cpe-172-100-182-241.stny.res.rr.com.com (unknown [9.85.175.110])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 15:31:48 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v15 10/13] s390/vfio-ap: implement in-use callback for vfio_ap driver
Date:   Tue,  6 Apr 2021 11:31:19 -0400
Message-Id: <20210406153122.22874-11-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20210406153122.22874-1-akrowiak@linux.ibm.com>
References: <20210406153122.22874-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KCWljT2hs5zwo2hTT7brIAPt1Gs4ll8d
X-Proofpoint-ORIG-GUID: nCQbKIOykg_MWyh-JwZJhn5HSDIyZvPe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_03:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxscore=0 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 impostorscore=0 clxscore=1015 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060102
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
 drivers/s390/crypto/vfio_ap_ops.c     | 38 ++++++++++++++++++++++-----
 drivers/s390/crypto/vfio_ap_private.h |  2 ++
 3 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 73bd073fd5d3..8934471b7944 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -147,6 +147,7 @@ static int __init vfio_ap_init(void)
 	memset(&vfio_ap_drv, 0, sizeof(vfio_ap_drv));
 	vfio_ap_drv.probe = vfio_ap_mdev_probe_queue;
 	vfio_ap_drv.remove = vfio_ap_mdev_remove_queue;
+	vfio_ap_drv.in_use = vfio_ap_mdev_resource_in_use;
 	vfio_ap_drv.ids = ap_queue_ids;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 8e7f24f0cd49..818757739f5d 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -667,10 +667,14 @@ static void vfio_ap_mdev_link_adapter(struct ap_matrix_mdev *matrix_mdev,
  *	   driver; or, if no APQIs have yet been assigned, the APID is not
  *	   contained in an APQN bound to the vfio_ap device driver.
  *
- *	4. -EBUSY
+ *	4. -EADDRINUSE
  *	   An APQN derived from the cross product of the APID being assigned
  *	   and the APQIs previously assigned is being used by another mediated
- *	   matrix device or the mdev lock could not be acquired.
+ *	   matrix device.
+ *
+ *	5. -EAGAIN
+ *	   The mdev lock could not be acquired which is required in order to
+ *	   change the AP configuration for the mdev
  */
 static ssize_t assign_adapter_store(struct device *dev,
 				    struct device_attribute *attr,
@@ -681,7 +685,8 @@ static ssize_t assign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	mutex_lock(&matrix_dev->lock);
+	if (!mutex_trylock(&matrix_dev->lock))
+		return -EAGAIN;
 
 	/*
 	 * If the KVM pointer is in flux or the guest is running, disallow
@@ -820,10 +825,14 @@ static void vfio_ap_mdev_link_domain(struct ap_matrix_mdev *matrix_mdev,
  *	   driver; or, if no APIDs have yet been assigned, the APQI is not
  *	   contained in an APQN bound to the vfio_ap device driver.
  *
- *	4. -BUSY
+ *	4. -EADDRINUSE
  *	   An APQN derived from the cross product of the APQI being assigned
  *	   and the APIDs previously assigned is being used by another mediated
- *	   matrix device or the mdev lock could not be acquired.
+ *	   matrix device.
+ *
+ *	5. -EAGAIN
+ *	   The mdev lock could not be acquired which is required in order to
+ *	   change the AP configuration for the mdev
  */
 static ssize_t assign_domain_store(struct device *dev,
 				   struct device_attribute *attr,
@@ -835,7 +844,8 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	mutex_lock(&matrix_dev->lock);
+	if (!mutex_trylock(&matrix_dev->lock))
+		return -EAGAIN;
 
 	/*
 	 * If the KVM pointer is in flux or the guest is running, disallow
@@ -963,6 +973,7 @@ static void vfio_ap_mdev_hot_plug_cdom(struct ap_matrix_mdev *matrix_mdev,
  * returns one of the following errors:
  *	-EINVAL if the ID is not a number
  *	-ENODEV if the ID exceeds the maximum value configured for the system
+ *	-EAGAIN if the mdev lock could not be acquired
  */
 static ssize_t assign_control_domain_store(struct device *dev,
 					   struct device_attribute *attr,
@@ -973,7 +984,8 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	mutex_lock(&matrix_dev->lock);
+	if (!mutex_trylock(&matrix_dev->lock))
+		return -EAGAIN;
 
 	/*
 	 * If the KVM pointer is in flux or the guest is running, disallow
@@ -1604,3 +1616,15 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	kfree(q);
 	mutex_unlock(&matrix_dev->lock);
 }
+
+int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
+{
+	int ret;
+
+	if (!mutex_trylock(&matrix_dev->lock))
+		return -EBUSY;
+	ret = vfio_ap_mdev_verify_no_sharing(apm, aqm);
+	mutex_unlock(&matrix_dev->lock);
+
+	return ret;
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 6f4f1f5bd611..601012751a4a 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -109,4 +109,6 @@ void vfio_ap_mdev_unregister(void);
 int vfio_ap_mdev_probe_queue(struct ap_device *queue);
 void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
+int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.3

