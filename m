Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C30D436603
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbhJUP0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:26:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52658 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231941AbhJUP0R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:26:17 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEBKhi028384;
        Thu, 21 Oct 2021 11:23:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1efW7U7mIAEiw5wxlXvRq+FFw7s4wdylizeIXJP9CrE=;
 b=JAcZK3QmHfXXTAu6t/yeXqfPwtGYmFbyumIbf7GNle1ft7bAhP0vrRGxizUDM5guYa0W
 lxmcgPm5BD8aivQi11ALAxEn4gLgePxNRvNxPJnyOWuufz1cG+GBcCDOquAVF+Zyv7wN
 kF+hdMpqRaqbainkP8vRdcOCZ5PccIo6lNXtoGypeaCjZSww4QK846WNpb+jN1BnToUH
 4UICZGN2urfInVsKIklY1idm1y/WZ+JkyTcNBVoXml4ZcM5zIJDAw6RCWBe2Nf9vj/dG
 Q/k3sFjBqzoA1PD66VyklpY8qS7xZFkR18WT1sp8sVt4lttls2EYvXbYO0+QpkNWeNlO mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bu9fmtc97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:23:59 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19LEaoKc031473;
        Thu, 21 Oct 2021 11:23:59 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bu9fmtc8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:23:59 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LF2LZP000335;
        Thu, 21 Oct 2021 15:23:57 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01dal.us.ibm.com with ESMTP id 3bqpcdr70e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 15:23:57 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LFNt3j24052424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 15:23:55 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 488ADBE082;
        Thu, 21 Oct 2021 15:23:55 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A61CDBE086;
        Thu, 21 Oct 2021 15:23:52 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com.com (unknown [9.160.98.118])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 15:23:52 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v17 03/15] s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c
Date:   Thu, 21 Oct 2021 11:23:20 -0400
Message-Id: <20211021152332.70455-4-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021152332.70455-1-akrowiak@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w3XTG6Ii5iQhkGUs3Qg28kOa1feZ08Nk
X-Proofpoint-GUID: z994tMzCx4Lb2VyFw7KxdV46Q_c6wM-z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 suspectscore=0 malwarescore=0 spamscore=0
 bulkscore=0 phishscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's move the probe and remove callbacks into the vfio_ap_ops.c
file to keep all code related to managing queues in a single file. This
way, all functions related to queue management can be removed from the
vfio_ap_private.h header file defining the public interfaces for the
vfio_ap device driver.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     | 45 ++-------------------------
 drivers/s390/crypto/vfio_ap_ops.c     | 31 ++++++++++++++++--
 drivers/s390/crypto/vfio_ap_private.h |  5 +--
 3 files changed, 34 insertions(+), 47 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 03311a476366..5255e338591d 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -41,50 +41,9 @@ static struct ap_device_id ap_queue_ids[] = {
 
 MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
 
-/**
- * vfio_ap_queue_dev_probe: Allocate a vfio_ap_queue structure and associate it
- *			    with the device as driver_data.
- *
- * @apdev: the AP device being probed
- *
- * Return: returns 0 if the probe succeeded; otherwise, returns -ENOMEM if
- *	   storage could not be allocated for a vfio_ap_queue object.
- */
-static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
-{
-	struct vfio_ap_queue *q;
-
-	q = kzalloc(sizeof(*q), GFP_KERNEL);
-	if (!q)
-		return -ENOMEM;
-	dev_set_drvdata(&apdev->device, q);
-	q->apqn = to_ap_queue(&apdev->device)->qid;
-	q->saved_isc = VFIO_AP_ISC_INVALID;
-	return 0;
-}
-
-/**
- * vfio_ap_queue_dev_remove: Free the associated vfio_ap_queue structure.
- *
- * @apdev: the AP device being removed
- *
- * Takes the matrix lock to avoid actions on this device while doing the remove.
- */
-static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
-{
-	struct vfio_ap_queue *q;
-
-	mutex_lock(&matrix_dev->lock);
-	q = dev_get_drvdata(&apdev->device);
-	vfio_ap_mdev_reset_queue(q, 1);
-	dev_set_drvdata(&apdev->device, NULL);
-	kfree(q);
-	mutex_unlock(&matrix_dev->lock);
-}
-
 static struct ap_driver vfio_ap_drv = {
-	.probe = vfio_ap_queue_dev_probe,
-	.remove = vfio_ap_queue_dev_remove,
+	.probe = vfio_ap_mdev_probe_queue,
+	.remove = vfio_ap_mdev_remove_queue,
 	.ids = ap_queue_ids,
 };
 
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 7a9d1b04ecd4..cd2fe1586327 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1191,8 +1191,7 @@ static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
 	return q;
 }
 
-int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
-			     unsigned int retry)
+static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
 {
 	struct ap_queue_status status;
 	int ret;
@@ -1410,3 +1409,31 @@ void vfio_ap_mdev_unregister(void)
 	mdev_unregister_device(&matrix_dev->device);
 	mdev_unregister_driver(&vfio_ap_matrix_driver);
 }
+
+int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
+{
+	struct vfio_ap_queue *q;
+
+	q = kzalloc(sizeof(*q), GFP_KERNEL);
+	if (!q)
+		return -ENOMEM;
+	mutex_lock(&matrix_dev->lock);
+	q->apqn = to_ap_queue(&apdev->device)->qid;
+	q->saved_isc = VFIO_AP_ISC_INVALID;
+	dev_set_drvdata(&apdev->device, q);
+	mutex_unlock(&matrix_dev->lock);
+
+	return 0;
+}
+
+void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
+{
+	struct vfio_ap_queue *q;
+
+	mutex_lock(&matrix_dev->lock);
+	q = dev_get_drvdata(&apdev->device);
+	vfio_ap_mdev_reset_queue(q, 1);
+	dev_set_drvdata(&apdev->device, NULL);
+	kfree(q);
+	mutex_unlock(&matrix_dev->lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 907f41160de7..e3f0d42b094c 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -118,7 +118,8 @@ struct vfio_ap_queue {
 
 int vfio_ap_mdev_register(void);
 void vfio_ap_mdev_unregister(void);
-int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
-			     unsigned int retry);
+
+int vfio_ap_mdev_probe_queue(struct ap_device *queue);
+void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.31.1

