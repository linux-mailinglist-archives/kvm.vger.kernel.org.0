Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6CB2E112C
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 02:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgLWBRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 20:17:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727160AbgLWBRL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Dec 2020 20:17:11 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BN131Zm069607;
        Tue, 22 Dec 2020 20:16:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pwnT/vpI9Ic2Kt/Dy1RSmJV5Dj24oyhUuJw1vXf1Bw0=;
 b=GpGHCU7vgxRezkv3B8o4/047ncOrpEfcRGqVOuGjtsx+T4nZlW8ZfMeVYq7DzbgS0njd
 3pA4OIhsKhYLxQ1MMfIyeeycOcl7dSEWFkAGBqeF7Lwm0EffNzYiRohTrRTxmnq+WI80
 iJ3x1op7eqRtmnAeBnr4bICZC7jsokbCXOZEn4j9BfAq6jQC96G747gqWfxaBGc+GCdj
 OtkqFizx4Z1AQUg4HjLxZqUf9P4AxskyeZeJGzfNF7EiwEFDyIQnGKzrAVXwtEzlojyV
 fKtjbL6t0vbtYduaH9xLn+HGFM0nvUQSUdXsurQgKy9u26PWyzKfdZA6zFmcLn6cHpzh Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ku80h095-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:28 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BN1GO7M139851;
        Tue, 22 Dec 2020 20:16:28 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ku80h08y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:28 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BN1DHgQ004622;
        Wed, 23 Dec 2020 01:16:27 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 35kj7qvbqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Dec 2020 01:16:27 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BN1GPff23658986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Dec 2020 01:16:25 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 679EE112063;
        Wed, 23 Dec 2020 01:16:25 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 951A4112064;
        Wed, 23 Dec 2020 01:16:24 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.193.150])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 23 Dec 2020 01:16:24 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v13 11/15] s390/vfio-ap: implement in-use callback for vfio_ap driver
Date:   Tue, 22 Dec 2020 20:16:02 -0500
Message-Id: <20201223011606.5265-12-akrowiak@linux.ibm.com>
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
-EBUSY.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  1 +
 drivers/s390/crypto/vfio_ap_ops.c     | 21 ++++++++++++++++++---
 drivers/s390/crypto/vfio_ap_private.h |  2 ++
 3 files changed, 21 insertions(+), 3 deletions(-)

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
index 843862c88379..6bc2e80cc565 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -644,7 +644,8 @@ static ssize_t assign_adapter_store(struct device *dev,
 	memset(apm, 0, sizeof(apm));
 	set_bit_inv(apid, apm);
 
-	mutex_lock(&matrix_dev->lock);
+	if (!mutex_trylock(&matrix_dev->lock))
+		return -EBUSY;
 
 	ret = vfio_ap_mdev_validate_masks(matrix_mdev, apm,
 					  matrix_mdev->matrix.aqm);
@@ -777,7 +778,8 @@ static ssize_t assign_domain_store(struct device *dev,
 	memset(aqm, 0, sizeof(aqm));
 	set_bit_inv(apqi, aqm);
 
-	mutex_lock(&matrix_dev->lock);
+	if (!mutex_trylock(&matrix_dev->lock))
+		return -EBUSY;
 
 	ret = vfio_ap_mdev_validate_masks(matrix_mdev, matrix_mdev->matrix.apm,
 					  aqm);
@@ -896,7 +898,8 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 * least significant, correspond to IDs 0 up to the one less than the
 	 * number of control domains that can be assigned.
 	 */
-	mutex_lock(&matrix_dev->lock);
+	if (!mutex_trylock(&matrix_dev->lock))
+		return -EBUSY;
 	set_bit_inv(id, matrix_mdev->matrix.adm);
 	vfio_ap_mdev_hot_plug_cdom(matrix_mdev, id);
 	mutex_unlock(&matrix_dev->lock);
@@ -1446,3 +1449,15 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
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
+	ret = vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);
+	mutex_unlock(&matrix_dev->lock);
+
+	return ret;
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index d2d26ba18602..15b7cd74843b 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -107,4 +107,6 @@ struct vfio_ap_queue {
 int vfio_ap_mdev_probe_queue(struct ap_device *queue);
 void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
+int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

