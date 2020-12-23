Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450B32E1143
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 02:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbgLWBSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 20:18:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51654 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726949AbgLWBRD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Dec 2020 20:17:03 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BN12Gr1136620;
        Tue, 22 Dec 2020 20:16:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hG5B8zKNxgzQYCl2W/YGL08c6+Hgezn5+xuZ5paq3CE=;
 b=XgzEIEqo8h6zqpkWFyEuatErg/vFcc1ldTox4Y89b1Tpb+TqJmtG6zeI+WX3jUAg/1/6
 IrKDdF5wIJdvWwwukA3bTZsVSqltzG1/P5X0V7t8DRIYphb2jcLWLLo4naCqot959Uyo
 4mN0LpY8JJz53DSN9XdGLE+QRw9oC3ruwkaWBWoLHlhuo7jKNMNwEXL4RN8ty+4Y1lmU
 qV7UXASUG5nQaNYRmQEocQCYrMGTqRvXT+1XmX5uN22h95bfS0SQesRbLaze2WzHWEP9
 WhGytZcoqKv+N4riw9qTB6o82w5XyRL9vU6xB+q1phRn70WMIM/NJ+Lp0d1kpWspMsQT rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35kuvng8bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:20 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BN18bfa161404;
        Tue, 22 Dec 2020 20:16:20 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35kuvng8bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:20 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BN1CNnK023356;
        Wed, 23 Dec 2020 01:16:19 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 35k7wbf5k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Dec 2020 01:16:19 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BN1GH5u25821594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Dec 2020 01:16:17 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C3FC112062;
        Wed, 23 Dec 2020 01:16:17 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25953112061;
        Wed, 23 Dec 2020 01:16:16 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.193.150])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 23 Dec 2020 01:16:16 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v13 04/15] s390/vfio-ap: use new AP bus interface to search for queue devices
Date:   Tue, 22 Dec 2020 20:15:55 -0500
Message-Id: <20201223011606.5265-5-akrowiak@linux.ibm.com>
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
 drivers/s390/crypto/vfio_ap_ops.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index a83d6e75361b..835c963ae16d 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -27,13 +27,6 @@
 static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 
-static int match_apqn(struct device *dev, const void *data)
-{
-	struct vfio_ap_queue *q = dev_get_drvdata(dev);
-
-	return (q->apqn == *(int *)(data)) ? 1 : 0;
-}
-
 /**
  * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
  * @matrix_mdev: the associated mediated matrix
@@ -49,7 +42,7 @@ static struct vfio_ap_queue *vfio_ap_get_queue(
 					struct ap_matrix_mdev *matrix_mdev,
 					int apqn)
 {
-	struct vfio_ap_queue *q;
+	struct vfio_ap_queue *q = NULL;
 
 	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
 		return NULL;
@@ -1124,15 +1117,17 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
 {
-	struct device *dev;
+	struct ap_queue *queue;
 	struct vfio_ap_queue *q = NULL;
 
-	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
-				 &apqn, match_apqn);
-	if (dev) {
-		q = dev_get_drvdata(dev);
-		put_device(dev);
-	}
+	queue = ap_get_qdev(apqn);
+	if (!queue)
+		return NULL;
+
+	put_device(&queue->ap_dev.device);
+
+	if (queue->ap_dev.device.driver == &matrix_dev->vfio_ap_drv->driver)
+		q = dev_get_drvdata(&queue->ap_dev.device);
 
 	return q;
 }
-- 
2.21.1

