Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2D03557E5
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 17:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345704AbhDFPb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 11:31:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345698AbhDFPbw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 11:31:52 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 136FDd4l121794;
        Tue, 6 Apr 2021 11:31:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=HBoofbeX3zUsh9dh6XYHoFZF0e/Ij0l4DGGqJchRjbU=;
 b=PAvBne/KOK6P0kFLrO+C0ZrUTx41PDMC3DY+/FHf1Z5WHPdQh2TbxS2hogp3ZU2FVuvm
 104CWyGi6C7AaIhhIhNmLT9BJzPrHpOh5aQKray6zPgnion//MxRKtf3tpnXSC/HvMqR
 VPDNOgc6YaCFiJcZ+MUZxOKP8GqUUi+u7sAWb+72gFhk+l4t/l/8h986N4f9XT2KFrMK
 f0HGj81t/fsRLP2mCLHfRX1DKHB/Twa7USzbV9Jtu0em6TrshVumQK3t4lm/WJeO7jzN
 OFXf+oZ5IpAhSlgGp+7TpznDu9WVEK8SJyrOGgTPHC8PoQp+Yv8uaO4X0Uvu1CUHfFWz OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5exs1ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 11:31:42 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 136FEEX2123695;
        Tue, 6 Apr 2021 11:31:42 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5exs1te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 11:31:42 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 136FNfNi013593;
        Tue, 6 Apr 2021 15:31:41 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 37q3294t4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 15:31:41 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 136FVbGM13763028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 15:31:38 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA55ABE051;
        Tue,  6 Apr 2021 15:31:37 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F7D2BE04F;
        Tue,  6 Apr 2021 15:31:36 +0000 (GMT)
Received: from cpe-172-100-182-241.stny.res.rr.com.com (unknown [9.85.175.110])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 15:31:36 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v15 03/13] s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c
Date:   Tue,  6 Apr 2021 11:31:12 -0400
Message-Id: <20210406153122.22874-4-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20210406153122.22874-1-akrowiak@linux.ibm.com>
References: <20210406153122.22874-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JPA-6jcXzysCwX_6UvigquvHXzG8B98r
X-Proofpoint-ORIG-GUID: QMHkr5w0_GQOAolFgTZp60VOopQIEngt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_04:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104060104
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
 drivers/s390/crypto/vfio_ap_drv.c     | 41 ++-------------------------
 drivers/s390/crypto/vfio_ap_ops.c     | 28 ++++++++++++++++++
 drivers/s390/crypto/vfio_ap_private.h |  5 ++--
 3 files changed, 33 insertions(+), 41 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 7dc72cb718b0..73bd073fd5d3 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -43,43 +43,6 @@ static struct ap_device_id ap_queue_ids[] = {
 
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
-
-	mutex_lock(&matrix_dev->lock);
-	q = dev_get_drvdata(&apdev->device);
-	vfio_ap_mdev_reset_queue(q, 1);
-	dev_set_drvdata(&apdev->device, NULL);
-	kfree(q);
-	mutex_unlock(&matrix_dev->lock);
-}
-
 static void vfio_ap_matrix_dev_release(struct device *dev)
 {
 	struct ap_matrix_dev *matrix_dev = dev_get_drvdata(dev);
@@ -182,8 +145,8 @@ static int __init vfio_ap_init(void)
 		return ret;
 
 	memset(&vfio_ap_drv, 0, sizeof(vfio_ap_drv));
-	vfio_ap_drv.probe = vfio_ap_queue_dev_probe;
-	vfio_ap_drv.remove = vfio_ap_queue_dev_remove;
+	vfio_ap_drv.probe = vfio_ap_mdev_probe_queue;
+	vfio_ap_drv.remove = vfio_ap_mdev_remove_queue;
 	vfio_ap_drv.ids = ap_queue_ids;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 128a66d57305..c630abac81d0 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1446,3 +1446,31 @@ void vfio_ap_mdev_unregister(void)
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
index f82a6396acae..3ca2da62bdee 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -100,7 +100,8 @@ struct vfio_ap_queue {
 
 int vfio_ap_mdev_register(void);
 void vfio_ap_mdev_unregister(void);
-int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
-			     unsigned int retry);
+
+int vfio_ap_mdev_probe_queue(struct ap_device *queue);
+void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.3

