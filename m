Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BFF2E111A
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 02:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgLWBRB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 20:17:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34038 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725902AbgLWBQ7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Dec 2020 20:16:59 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BN12xqc069495;
        Tue, 22 Dec 2020 20:16:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ymfZ1fqBftsnEhbqEq2x7jcQJPVn4B2iXzSFReUR6uk=;
 b=hgG/GZJ7t7hQn8V1CLVRcyDLz4DIvXocagE3+ORVuLvdblDFTxyH05tJjxqhSJp7RA+d
 Gtt3bT+AL61+f/D4PxQjONQbKJBVp/q4MXqMZmL1UWqI9XXTVR+0NoR2r5P1Zi7bk2qC
 ExvIrP4rSVE/jjN7RObE0FD1OzVQ4ICDaEPIhcNAU8xvCKkKPulawIosl54FZzlQ/W/O
 yU3ykC/Lu6UPW8Q3+0sUW9V6pgwuf/+vJi0fS0QezkdMARkq/atJ2M6viVLPv0ds1eAy
 9GMFYBFI5uTrWROGhlT/ULRcZ9mSk9dFrOyM9LoIyLrV14o12G7LdIJMI5G0CxV/T7eR cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ku80h056-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:19 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BN13740069889;
        Tue, 22 Dec 2020 20:16:18 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ku80h04t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:18 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BN1CjFP014150;
        Wed, 23 Dec 2020 01:16:17 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 35kejb61bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Dec 2020 01:16:17 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BN1GGbH21234028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Dec 2020 01:16:16 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA818112064;
        Wed, 23 Dec 2020 01:16:15 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30667112069;
        Wed, 23 Dec 2020 01:16:15 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.193.150])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 23 Dec 2020 01:16:15 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v13 03/15] s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c
Date:   Tue, 22 Dec 2020 20:15:54 -0500
Message-Id: <20201223011606.5265-4-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201223011606.5265-1-akrowiak@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-22_13:2020-12-21,2020-12-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012230003
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
 drivers/s390/crypto/vfio_ap_drv.c     | 44 ++-------------------------
 drivers/s390/crypto/vfio_ap_ops.c     | 34 +++++++++++++++++++--
 drivers/s390/crypto/vfio_ap_private.h |  6 ++--
 3 files changed, 37 insertions(+), 47 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index ca18c91afec9..73bd073fd5d3 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -43,46 +43,6 @@ static struct ap_device_id ap_queue_ids[] = {
 
 MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
 
-/**
- * vfio_ap_queue_dev_probe:
- *
- * Allocate a vfio_ap_queue structure and associate it
- * with the device as driver_data.
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
- * vfio_ap_queue_dev_remove:
- *
- * Takes the matrix lock to avoid actions on this device while removing
- * Free the associated vfio_ap_queue structure
- */
-static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
-{
-	struct vfio_ap_queue *q;
-	int apid, apqi;
-
-	mutex_lock(&matrix_dev->lock);
-	q = dev_get_drvdata(&apdev->device);
-	dev_set_drvdata(&apdev->device, NULL);
-	apid = AP_QID_CARD(q->apqn);
-	apqi = AP_QID_QUEUE(q->apqn);
-	vfio_ap_mdev_reset_queue(apid, apqi, 1);
-	kfree(q);
-	mutex_unlock(&matrix_dev->lock);
-}
-
 static void vfio_ap_matrix_dev_release(struct device *dev)
 {
 	struct ap_matrix_dev *matrix_dev = dev_get_drvdata(dev);
@@ -185,8 +145,8 @@ static int __init vfio_ap_init(void)
 		return ret;
 
 	memset(&vfio_ap_drv, 0, sizeof(vfio_ap_drv));
-	vfio_ap_drv.probe = vfio_ap_queue_dev_probe;
-	vfio_ap_drv.remove = vfio_ap_queue_dev_remove;
+	vfio_ap_drv.probe = vfio_ap_mdev_probe_queue;
+	vfio_ap_drv.remove = vfio_ap_mdev_remove_queue;
 	vfio_ap_drv.ids = ap_queue_ids;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 052f61391ec7..a83d6e75361b 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -140,7 +140,7 @@ static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
  * Returns if ap_aqic function failed with invalid, deconfigured or
  * checkstopped AP.
  */
-struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
+static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
 {
 	struct ap_qirq_ctrl aqic_gisa = {};
 	struct ap_queue_status status;
@@ -1137,8 +1137,8 @@ static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
 	return q;
 }
 
-int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
-			     unsigned int retry)
+static int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
+				    unsigned int retry)
 {
 	struct ap_queue_status status;
 	struct vfio_ap_queue *q;
@@ -1321,3 +1321,31 @@ void vfio_ap_mdev_unregister(void)
 {
 	mdev_unregister_device(&matrix_dev->device);
 }
+
+int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
+{
+	struct vfio_ap_queue *q;
+
+	q = kzalloc(sizeof(*q), GFP_KERNEL);
+	if (!q)
+		return -ENOMEM;
+	dev_set_drvdata(&apdev->device, q);
+	q->apqn = to_ap_queue(&apdev->device)->qid;
+	q->saved_isc = VFIO_AP_ISC_INVALID;
+	return 0;
+}
+
+void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
+{
+	struct vfio_ap_queue *q;
+	int apid, apqi;
+
+	mutex_lock(&matrix_dev->lock);
+	q = dev_get_drvdata(&apdev->device);
+	dev_set_drvdata(&apdev->device, NULL);
+	apid = AP_QID_CARD(q->apqn);
+	apqi = AP_QID_QUEUE(q->apqn);
+	vfio_ap_mdev_reset_queue(apid, apqi, 1);
+	kfree(q);
+	mutex_unlock(&matrix_dev->lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 0db6fb3d56d5..d9003de4fbad 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -90,8 +90,6 @@ struct ap_matrix_mdev {
 
 extern int vfio_ap_mdev_register(void);
 extern void vfio_ap_mdev_unregister(void);
-int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
-			     unsigned int retry);
 
 struct vfio_ap_queue {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -100,4 +98,8 @@ struct vfio_ap_queue {
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
 };
+
+int vfio_ap_mdev_probe_queue(struct ap_device *queue);
+void vfio_ap_mdev_remove_queue(struct ap_device *queue);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

