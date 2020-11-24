Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B1C2C3330
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 22:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732995AbgKXVkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 16:40:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13974 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732911AbgKXVkg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 16:40:36 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLXHiX097163;
        Tue, 24 Nov 2020 16:40:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yioDEj+M63jDuENENQ9FqNpqiIxNZdtbtF02M66jVDY=;
 b=LAkYKbBK1M+6e8GXxLyCPTdxWI0wivKJmtAMQ1saF+MxNw0PMpfV2WjzjyP5Bnt0zdU4
 Hp57hRhJjUWW+86ZkVGY/9Acfup06iLHDf3Ye6jjHHterfRx7Ngkzm1QiWonni9Yu6ga
 podp/HPuEuxcIZ+oEbKGOxd7377U6iv7NALcKJpk6VyjRr39YvLvPXMGH0LOT06b8DtD
 mKJI3oI2+ie3iPGuaFxWRQb8V//Y6JfN0tBEQVJPz0iWTAlvNqSjdZskCuiZGsuOw1Y7
 lbfg1c2Rg6KXZ5jqLK3CyZDLm6sKwj3dB7hZ6oLB1mTNTy/yBYEWcgS9jrMOTR2Pdlqa cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ygtubm2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:30 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AOLXxAS102386;
        Tue, 24 Nov 2020 16:40:30 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ygtubm2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:29 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLccji009152;
        Tue, 24 Nov 2020 21:40:29 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04wdc.us.ibm.com with ESMTP id 34xth92m83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 21:40:29 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOLeRcX10027566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 21:40:27 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1D45AE05C;
        Tue, 24 Nov 2020 21:40:27 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1CB3AE060;
        Tue, 24 Nov 2020 21:40:26 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.195.249])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 21:40:26 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v12 01/17] s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c
Date:   Tue, 24 Nov 2020 16:40:00 -0500
Message-Id: <20201124214016.3013-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201124214016.3013-1-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_08:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999 suspectscore=11
 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's move the probe and remove callbacks into the vfio_ap_ops.c
file to keep all code related to managing queues in a single file. This
way, all functions related to queue management can be removed from the
vfio_ap_private.h header file defining the public interfaces for the
vfio_ap device driver.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     | 45 ++-----------------------
 drivers/s390/crypto/vfio_ap_ops.c     | 47 +++++++++++++++++++++++++--
 drivers/s390/crypto/vfio_ap_private.h |  7 ++--
 3 files changed, 50 insertions(+), 49 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index be2520cc010b..73bd073fd5d3 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -43,47 +43,6 @@ static struct ap_device_id ap_queue_ids[] = {
 
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
-	vfio_ap_irq_disable(q);
-	kfree(q);
-	mutex_unlock(&matrix_dev->lock);
-}
-
 static void vfio_ap_matrix_dev_release(struct device *dev)
 {
 	struct ap_matrix_dev *matrix_dev = dev_get_drvdata(dev);
@@ -186,8 +145,8 @@ static int __init vfio_ap_init(void)
 		return ret;
 
 	memset(&vfio_ap_drv, 0, sizeof(vfio_ap_drv));
-	vfio_ap_drv.probe = vfio_ap_queue_dev_probe;
-	vfio_ap_drv.remove = vfio_ap_queue_dev_remove;
+	vfio_ap_drv.probe = vfio_ap_mdev_probe_queue;
+	vfio_ap_drv.remove = vfio_ap_mdev_remove_queue;
 	vfio_ap_drv.ids = ap_queue_ids;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e0bde8518745..66fd9784a156 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -144,7 +144,7 @@ static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
  * Returns if ap_aqic function failed with invalid, deconfigured or
  * checkstopped AP.
  */
-struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
+static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
 {
 	struct ap_qirq_ctrl aqic_gisa = {};
 	struct ap_queue_status status;
@@ -1128,8 +1128,8 @@ static void vfio_ap_irq_disable_apqn(int apqn)
 	}
 }
 
-int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
-			     unsigned int retry)
+static int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
+				    unsigned int retry)
 {
 	struct ap_queue_status status;
 	int retry2 = 2;
@@ -1302,3 +1302,44 @@ void vfio_ap_mdev_unregister(void)
 {
 	mdev_unregister_device(&matrix_dev->device);
 }
+
+/**
+ * vfio_ap_mdev_probe_queue:
+ *
+ * Allocate a vfio_ap_queue structure and associate it
+ * with the device as driver_data.
+ */
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
+/**
+ * vfio_ap_mdev_remove_queue:
+ *
+ * Takes the matrix lock to avoid actions on this device while removing
+ * Free the associated vfio_ap_queue structure
+ */
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
+	vfio_ap_irq_disable(q);
+	kfree(q);
+	mutex_unlock(&matrix_dev->lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index f46dde56b464..d9003de4fbad 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -90,8 +90,6 @@ struct ap_matrix_mdev {
 
 extern int vfio_ap_mdev_register(void);
 extern void vfio_ap_mdev_unregister(void);
-int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
-			     unsigned int retry);
 
 struct vfio_ap_queue {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -100,5 +98,8 @@ struct vfio_ap_queue {
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
 };
-struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
+
+int vfio_ap_mdev_probe_queue(struct ap_device *queue);
+void vfio_ap_mdev_remove_queue(struct ap_device *queue);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

