Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27D329636E
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 19:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902395AbgJVRMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 13:12:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2294 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2902367AbgJVRMj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Oct 2020 13:12:39 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09MH28mq054543;
        Thu, 22 Oct 2020 13:12:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=v3jO95AaVvEElo4NrAGwZiMGCqe6xcobZljhqbHeaqw=;
 b=Rirtmkaf24kl4lBNBp/0OxhX4aNuuzqm454stJP9T67ZL/04oAsyopvGytBc69v9UQt6
 pSWGPkPUVhaRkPiZUcoKIO8AFLgcoa6o3CsaYM4aF62+vANmMYKlnFMXy3RHQftuSmR6
 Zc49OjP1i9qiGVupb+7P0btUnhR9ZdVIojB0aUjSQrlxLvohDuxCpvbh6cMk2gzWh2zt
 ohC5YquZLTH1V295fLulNnTXCQ8BHioh1BGP0sEHJX13zegflGVpVYDQyA/RqyFKE75l
 QBhaMFkDZAZi9Byw60twIBaYuLdbnVsVPiNUzaLMT4RLlGPhaz9Hgsq0VS10X4oP7z0J 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34b00e2cgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 13:12:33 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09MH2iSk057254;
        Thu, 22 Oct 2020 13:12:33 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34b00e2cga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 13:12:33 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09MGsqxP006119;
        Thu, 22 Oct 2020 17:12:32 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01wdc.us.ibm.com with ESMTP id 347r89hw6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 17:12:32 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09MHCTfU49611014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 17:12:29 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40F6E78064;
        Thu, 22 Oct 2020 17:12:29 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D70C78060;
        Thu, 22 Oct 2020 17:12:27 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.170.177])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 22 Oct 2020 17:12:27 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v11 05/14] s390/vfio-ap: implement in-use callback for vfio_ap driver
Date:   Thu, 22 Oct 2020 13:12:00 -0400
Message-Id: <20201022171209.19494-6-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201022171209.19494-1-akrowiak@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_11:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 suspectscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010220108
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

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  1 +
 drivers/s390/crypto/vfio_ap_ops.c     | 78 +++++++++++++++++++--------
 drivers/s390/crypto/vfio_ap_private.h |  2 +
 3 files changed, 60 insertions(+), 21 deletions(-)

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
index 1357f8f8b7e4..9e9fad560859 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -522,18 +522,40 @@ vfio_ap_mdev_verify_queues_reserved_for_apid(struct ap_matrix_mdev *matrix_mdev,
 	return 0;
 }
 
+#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
+			 "already assigned to %s"
+
+static void vfio_ap_mdev_log_sharing_err(const char *mdev_name,
+					 unsigned long *apm,
+					 unsigned long *aqm)
+{
+	unsigned long apid, apqi;
+
+	for_each_set_bit_inv(apid, apm, AP_DEVICES)
+		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
+			pr_err(MDEV_SHARING_ERR, apid, apqi, mdev_name);
+}
+
 /**
  * vfio_ap_mdev_verify_no_sharing
  *
- * Verifies that the APQNs derived from the cross product of the AP adapter IDs
- * and AP queue indexes comprising the AP matrix are not configured for another
+ * Verifies that each APQN derived from the cross product of the AP adapter IDs
+ * and AP queue indexes comprising an AP matrix is not assigned to a
  * mediated device. AP queue sharing is not allowed.
  *
- * @matrix_mdev: the mediated matrix device
+ * @matrix_mdev: the mediated matrix device to which the APQNs being verified
+ *		 are assigned. If the value is not NULL, then verification will
+ *		 proceed for all other matrix mediated devices; otherwise, all
+ *		 matrix mediated devices will be verified.
+ * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
+ * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
  *
- * Returns 0 if the APQNs are not shared, otherwise; returns -EADDRINUSE.
+ * Returns 0 if no APQNs are not shared, otherwise; returns -EADDRINUSE if one
+ * or more APQNs are shared.
  */
-static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
+static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
+					  unsigned long *mdev_apm,
+					  unsigned long *mdev_aqm)
 {
 	struct ap_matrix_mdev *lstdev;
 	DECLARE_BITMAP(apm, AP_DEVICES);
@@ -550,14 +572,15 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
 		 * We work on full longs, as we can only exclude the leftover
 		 * bits in non-inverse order. The leftover is all zeros.
 		 */
-		if (!bitmap_and(apm, matrix_mdev->matrix.apm,
-				lstdev->matrix.apm, AP_DEVICES))
+		if (!bitmap_and(apm, mdev_apm, lstdev->matrix.apm, AP_DEVICES))
 			continue;
 
-		if (!bitmap_and(aqm, matrix_mdev->matrix.aqm,
-				lstdev->matrix.aqm, AP_DOMAINS))
+		if (!bitmap_and(aqm, mdev_aqm, lstdev->matrix.aqm, AP_DOMAINS))
 			continue;
 
+		vfio_ap_mdev_log_sharing_err(dev_name(mdev_dev(lstdev->mdev)),
+					     apm, aqm);
+
 		return -EADDRINUSE;
 	}
 
@@ -683,6 +706,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 {
 	int ret;
 	unsigned long apid;
+	DECLARE_BITMAP(apm, AP_DEVICES);
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
@@ -708,18 +732,18 @@ static ssize_t assign_adapter_store(struct device *dev,
 	if (ret)
 		goto done;
 
-	set_bit_inv(apid, matrix_mdev->matrix.apm);
+	memset(apm, 0, sizeof(apm));
+	set_bit_inv(apid, apm);
 
-	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
+	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev, apm,
+					     matrix_mdev->matrix.aqm);
 	if (ret)
-		goto share_err;
+		goto done;
 
+	set_bit_inv(apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APID, apid);
 	ret = count;
-	goto done;
 
-share_err:
-	clear_bit_inv(apid, matrix_mdev->matrix.apm);
 done:
 	mutex_unlock(&matrix_dev->lock);
 
@@ -831,6 +855,7 @@ static ssize_t assign_domain_store(struct device *dev,
 {
 	int ret;
 	unsigned long apqi;
+	DECLARE_BITMAP(aqm, AP_DOMAINS);
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
@@ -851,18 +876,18 @@ static ssize_t assign_domain_store(struct device *dev,
 	if (ret)
 		goto done;
 
-	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
+	memset(aqm, 0, sizeof(aqm));
+	set_bit_inv(apqi, aqm);
 
-	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
+	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev,
+					     matrix_mdev->matrix.apm, aqm);
 	if (ret)
-		goto share_err;
+		goto done;
 
+	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APQI, apqi);
 	ret = count;
-	goto done;
 
-share_err:
-	clear_bit_inv(apqi, matrix_mdev->matrix.aqm);
 done:
 	mutex_unlock(&matrix_dev->lock);
 
@@ -1442,3 +1467,14 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	kfree(q);
 	mutex_unlock(&matrix_dev->lock);
 }
+
+bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
+{
+	bool in_use;
+
+	mutex_lock(&matrix_dev->lock);
+	in_use = !!vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);
+	mutex_unlock(&matrix_dev->lock);
+
+	return in_use;
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 4e5cc72fc0db..c1d8b5507610 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -105,4 +105,6 @@ struct vfio_ap_queue {
 int vfio_ap_mdev_probe_queue(struct ap_device *queue);
 void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
+bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

