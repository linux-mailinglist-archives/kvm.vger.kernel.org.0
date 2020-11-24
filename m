Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085A92C332F
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 22:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732933AbgKXVkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 16:40:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7952 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732876AbgKXVke (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 16:40:34 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLXn6e147352;
        Tue, 24 Nov 2020 16:40:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fWF9+T5G44qbAhuLciArfLeY6QscM6LyEoyheeUp7q8=;
 b=X08a9bkZMSSZLHaxVERIxUX6+o/C6+EXPeE7Ab+kLQq6rRu/PQkCh67OPARyvTM5uxX+
 PN/VklMJ/Uz8QcDKaOHBC16MzBXwfdYUx3hCK8tZZZXaGeS8Cr7xWKelQy+t22aaZbyP
 cvwuvTvl8Ln8rQcJwHAe+n3XggYOvmrQHiPWKXoanS+Pi9Pt/ZKZAcj1IG0/nuPxIavO
 JzMtmeSPCAYhswjKZcNZYG2tUWIH8xN6QtnTAYrEtHVXgb4xgY7lO5Rn3psXa5Hl4rwj
 TIdqSPrm288+/8lG7vhGluKcC86TN2lAix172nknzSlBlSq1XECV5lST/98X4IBCslzv Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350n10y75x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:33 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AOLbJvn160719;
        Tue, 24 Nov 2020 16:40:32 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350n10y75d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:32 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLViP6025579;
        Tue, 24 Nov 2020 21:40:31 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01wdc.us.ibm.com with ESMTP id 34xth92hhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 21:40:31 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOLeTN811534918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 21:40:29 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B538DAE05C;
        Tue, 24 Nov 2020 21:40:29 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBE78AE05F;
        Tue, 24 Nov 2020 21:40:28 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.195.249])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 21:40:28 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v12 03/17] 390/vfio-ap: use new AP bus interface to search for queue devices
Date:   Tue, 24 Nov 2020 16:40:02 -0500
Message-Id: <20201124214016.3013-4-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201124214016.3013-1-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_09:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 malwarescore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0
 mlxscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch refactors the vfio_ap device driver to use the AP bus's
ap_get_qdev() function to retrieve the vfio_ap_queue struct containing
information about a queue that is bound to the vfio_ap device driver.
The bus's ap_get_qdev() function retrieves the queue device from a
hashtable keyed by APQN. This is much more efficient than looping over
the list of devices attached to the AP bus by several orders of
magnitude.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 31e39c1f6e56..8e6972495daa 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -33,36 +33,39 @@ static int match_apqn(struct device *dev, const void *data)
 	return (q->apqn == *(int *)(data)) ? 1 : 0;
 }
 
+
 /**
- * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
+ * vfio_ap_get_queue: Retrieve a queue with a specific APQN.
  * @matrix_mdev: the associated mediated matrix
  * @apqn: The queue APQN
  *
- * Retrieve a queue with a specific APQN from the list of the
- * devices of the vfio_ap_drv.
- * Verify that the APID and the APQI are set in the matrix.
+ * Retrieve a queue with a specific APQN from the AP queue devices attached to
+ * the AP bus.
  *
- * Returns the pointer to the associated vfio_ap_queue
+ * Returns the pointer to the vfio_ap_queue with the specified APQN, or NULL.
  */
 static struct vfio_ap_queue *vfio_ap_get_queue(
 					struct ap_matrix_mdev *matrix_mdev,
 					int apqn)
 {
-	struct vfio_ap_queue *q;
-	struct device *dev;
+	struct ap_queue *queue;
+	struct vfio_ap_queue *q = NULL;
 
 	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
 		return NULL;
 	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
 		return NULL;
 
-	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
-				 &apqn, match_apqn);
-	if (!dev)
+	queue = ap_get_qdev(apqn);
+	if (!queue)
 		return NULL;
-	q = dev_get_drvdata(dev);
-	q->matrix_mdev = matrix_mdev;
-	put_device(dev);
+
+	put_device(&queue->ap_dev.device);
+
+	if (queue->ap_dev.device.driver == &matrix_dev->vfio_ap_drv->driver) {
+		q = dev_get_drvdata(&queue->ap_dev.device);
+		q->matrix_mdev = matrix_mdev;
+	}
 
 	return q;
 }
-- 
2.21.1

