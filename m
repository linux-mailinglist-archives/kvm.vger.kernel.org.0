Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18733557DF
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 17:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345699AbhDFPbw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 11:31:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229741AbhDFPbu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 11:31:50 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 136F4ULx158100;
        Tue, 6 Apr 2021 11:31:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZQ2gG3MATR/hwbzYW9j97nQECT8aVGf+Owt/oy9Xsew=;
 b=lplKfxC9Z+2qh6c2nSroEmyDMg6ppVNHJh+g1wkKQRyiaarOqi1eiuVyc80OMha6mwBA
 wMNyrAKuX8trcy4/F/u2+pRY/ly9+jA8w4oQhEB/WGQ8UaGEE/UeLtJ0zLSn0Iuy0eDL
 r14BfcTbyI8HLlM9JLbH2xcmvACoAJwfml+gkcspEob+abuOZVSmncNbuL2GfMSkTaxp
 yNJnZstTl4ikgaZfhP9tqfxa3/jBsuRIYxdn3/csvpVNJAt4O+C5ir8Yb5xtkOMB8XeM
 JFwV1qh9IEbzdjK47yDzrhEx73AiUYYR6UNAR4ZbaaMk40jj4b08rsRlgg8SfgctlNLZ Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5way4y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 11:31:40 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 136F4m2G159794;
        Tue, 6 Apr 2021 11:31:40 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5way4xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 11:31:40 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 136FNQS0023901;
        Tue, 6 Apr 2021 15:31:39 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 37qbgye8rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 15:31:39 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 136FVaIx25231798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 15:31:36 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27B1DBE056;
        Tue,  6 Apr 2021 15:31:36 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90857BE04F;
        Tue,  6 Apr 2021 15:31:34 +0000 (GMT)
Received: from cpe-172-100-182-241.stny.res.rr.com.com (unknown [9.85.175.110])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 15:31:34 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v15 02/13] s390/vfio-ap: use new AP bus interface to search for queue devices
Date:   Tue,  6 Apr 2021 11:31:11 -0400
Message-Id: <20210406153122.22874-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20210406153122.22874-1-akrowiak@linux.ibm.com>
References: <20210406153122.22874-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M-UmUBMs0SvYvl2QTGrsKkbOczdzdI0m
X-Proofpoint-ORIG-GUID: orW8GHKM8itR-oo8Y3beTRDsZinIbdB-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_03:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 impostorscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060102
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
 drivers/s390/crypto/vfio_ap_ops.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 6946a7e26eff..128a66d57305 100644
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
@@ -1232,15 +1225,17 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 
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
+	if (queue->ap_dev.device.driver == &matrix_dev->vfio_ap_drv->driver)
+		q = dev_get_drvdata(&queue->ap_dev.device);
+
+	put_device(&queue->ap_dev.device);
 
 	return q;
 }
-- 
2.21.3

