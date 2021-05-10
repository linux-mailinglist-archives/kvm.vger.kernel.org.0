Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036E437946E
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 18:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhEJQqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 12:46:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24598 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231963AbhEJQpu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 12:45:50 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AGXYOV095372;
        Mon, 10 May 2021 12:44:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+qxlsUU1masaphYo8j62UHleY/+go/kZjN/nOYawLt4=;
 b=R0KqKxn+iKegHNWhWltMp6hhevW+4gNqTHUHerY1F2r6tp+79SgY8It/C/LMMiirTLgV
 4TZeQXF6XI0/O4Uk+MNy9Olpw5CIvrqpFjxfYVwjKkRHPPrt+Zb1qLsF5xfonJu86hTx
 9pxAD7hNYArrxMm3TV+35tSbMgI7LPpRn4MUeBk1N8LdFE+yCNqE54+9lFeyhdK7VO5c
 ZebZ2qOY/zbeWFePaSQYgGzHALT6t01cp0ztz++1P9yu3Pewpei5v4OrLr850GL4mm98
 N1y9KIx0+XYX8gatP8YxaMWeWM/Hku/Q5EnYS9fniXb3HqZOADkq2+tuupeOKypyZXH6 xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f7wks9hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 12:44:43 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AGZP02108928;
        Mon, 10 May 2021 12:44:43 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f7wks9h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 12:44:43 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AGgWLS000715;
        Mon, 10 May 2021 16:44:42 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 38dj98ugx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 16:44:42 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AGieuI40304996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 16:44:40 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F438AE062;
        Mon, 10 May 2021 16:44:40 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84A94AE063;
        Mon, 10 May 2021 16:44:39 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com.com (unknown [9.85.140.234])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 16:44:39 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v16 08/14] s390/vfio-ap: allow hot plug/unplug of AP resources using mdev device
Date:   Mon, 10 May 2021 12:44:17 -0400
Message-Id: <20210510164423.346858-9-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510164423.346858-1-akrowiak@linux.ibm.com>
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hSaX_VGnlTkWvVaZ12sgqGkMUiTOcDo8
X-Proofpoint-GUID: a7nWrVKGPzqxjY_457U89h7WLOossiNo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_09:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's allow adapters, domains and control domains to be hot plugged into
and hot unplugged from a KVM guest using a matrix mdev when:

* The adapter, domain or control domain is assigned to or unassigned from
  the matrix mdev

* A queue device with an APQN assigned to the matrix mdev is bound to or
  unbound from the vfio_ap device driver.

Whenever an assignment or unassignment of an adapter, domain or control
domain is performed as well as when a bind or unbind of a queue device
is executed, the AP control block (APCB) that supplies the AP configuration
to the guest is first refreshed.

After refreshing the APCB, if the mdev is in use by a KVM guest, it is
hot plugged into the guest to provide access to dynamically provide
access to the adapters, domains and control domains provided via the
newly refreshed APCB.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 91 ++++++++++++++++++++++++-------
 1 file changed, 71 insertions(+), 20 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 6486245aa89a..e388eaf4f601 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -24,7 +24,7 @@
 #define VFIO_AP_MDEV_TYPE_HWVIRT "passthrough"
 #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
 
-static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
+static int vfio_ap_mdev_reset_queues(struct ap_matrix *matrix);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 
 static struct vfio_ap_queue *
@@ -262,8 +262,8 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.sie_block->eca & ECA_AIV))
 		return -EOPNOTSUPP;
 
-	apqn = vcpu->run->s.regs.gprs[0] & 0xffff;
 	mutex_lock(&matrix_dev->lock);
+	apqn = vcpu->run->s.regs.gprs[0] & 0xffff;
 
 	if (!vcpu->kvm->arch.crypto.pqap_hook)
 		goto out_unlock;
@@ -336,6 +336,31 @@ static void vfio_ap_mdev_clear_apcb(struct ap_matrix_mdev *matrix_mdev)
 		wake_up_all(&matrix_mdev->wait_for_kvm);
 	}
 }
+
+static void vfio_ap_mdev_commit_apcb(struct ap_matrix_mdev *matrix_mdev)
+{
+	/*
+	 * If the KVM pointer is in the process of being set, wait until the
+	 * process has completed.
+	 */
+	wait_event_cmd(matrix_mdev->wait_for_kvm,
+		       !matrix_mdev->kvm_busy,
+		       mutex_unlock(&matrix_dev->lock),
+		       mutex_lock(&matrix_dev->lock));
+
+	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		matrix_mdev->kvm_busy = true;
+		mutex_unlock(&matrix_dev->lock);
+		kvm_arch_crypto_set_masks(matrix_mdev->kvm,
+					  matrix_mdev->shadow_apcb.apm,
+					  matrix_mdev->shadow_apcb.aqm,
+					  matrix_mdev->shadow_apcb.adm);
+		mutex_lock(&matrix_dev->lock);
+		matrix_mdev->kvm_busy = false;
+		wake_up_all(&matrix_mdev->wait_for_kvm);
+	}
+}
+
 /*
  * vfio_ap_mdev_filter_apcb
  *
@@ -403,6 +428,7 @@ static void vfio_ap_mdev_refresh_apcb(struct ap_matrix_mdev *matrix_mdev)
 		   sizeof(struct ap_matrix)) != 0) {
 		memcpy(&matrix_mdev->shadow_apcb, &shadow_apcb,
 		       sizeof(struct ap_matrix));
+		vfio_ap_mdev_commit_apcb(matrix_mdev);
 	}
 }
 
@@ -492,7 +518,7 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
 	WARN(vfio_ap_mdev_has_crycb(matrix_mdev),
 	     "Removing mdev leaves KVM guest without any crypto devices");
 	vfio_ap_mdev_clear_apcb(matrix_mdev);
-	vfio_ap_mdev_reset_queues(mdev);
+	vfio_ap_mdev_reset_queues(&matrix_mdev->matrix);
 	vfio_ap_mdev_unlink_fr_queues(matrix_mdev);
 	list_del(&matrix_mdev->node);
 	kfree(matrix_mdev);
@@ -682,7 +708,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * un-assignment of adapter
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -760,7 +786,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * un-assignment of adapter
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -841,7 +867,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * assignment of domain
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -918,7 +944,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * un-assignment of domain
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -943,6 +969,16 @@ static ssize_t unassign_domain_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(unassign_domain);
 
+static void vfio_ap_mdev_hot_plug_cdom(struct ap_matrix_mdev *matrix_mdev,
+				       unsigned long domid)
+{
+	if (!test_bit_inv(domid, matrix_mdev->shadow_apcb.adm) &&
+	    test_bit_inv(domid, (unsigned long *)matrix_dev->info.adm)) {
+		set_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
+		vfio_ap_mdev_commit_apcb(matrix_mdev);
+	}
+}
+
 /**
  * assign_control_domain_store
  *
@@ -974,7 +1010,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * assignment of control domain.
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -994,7 +1030,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 * number of control domains that can be assigned.
 	 */
 	set_bit_inv(id, matrix_mdev->matrix.adm);
-	vfio_ap_mdev_refresh_apcb(matrix_mdev);
+	vfio_ap_mdev_hot_plug_cdom(matrix_mdev, id);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -1002,6 +1038,15 @@ static ssize_t assign_control_domain_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(assign_control_domain);
 
+static void vfio_ap_mdev_hot_unplug_cdom(struct ap_matrix_mdev *matrix_mdev,
+					 unsigned long domid)
+{
+	if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
+		clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
+		vfio_ap_mdev_commit_apcb(matrix_mdev);
+	}
+}
+
 /**
  * unassign_control_domain_store
  *
@@ -1034,7 +1079,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	 * If the KVM pointer is in flux or the guest is running, disallow
 	 * un-assignment of control domain.
 	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+	if (matrix_mdev->kvm_busy) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -1048,7 +1093,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	}
 
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
-	vfio_ap_mdev_refresh_apcb(matrix_mdev);
+	vfio_ap_mdev_hot_unplug_cdom(matrix_mdev, domid);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -1257,7 +1302,7 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 		mutex_unlock(&matrix_dev->lock);
 		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
 		mutex_lock(&matrix_dev->lock);
-		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
+		vfio_ap_mdev_reset_queues(&matrix_mdev->matrix);
 		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
 		kvm_put_kvm(matrix_mdev->kvm);
 		matrix_mdev->kvm = NULL;
@@ -1356,18 +1401,15 @@ int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
 	return ret;
 }
 
-static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
+static int vfio_ap_mdev_reset_queues(struct ap_matrix *matrix)
 {
 	int ret;
 	int rc = 0;
 	unsigned long apid, apqi;
 	struct vfio_ap_queue *q;
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
-			     matrix_mdev->matrix.apm_max + 1) {
-		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
-				     matrix_mdev->matrix.aqm_max + 1) {
+	for_each_set_bit_inv(apid, matrix->apm, AP_DEVICES) {
+		for_each_set_bit_inv(apqi, matrix->aqm, AP_DOMAINS) {
 			q = vfio_ap_find_queue(AP_MKQID(apid, apqi));
 			ret = vfio_ap_mdev_reset_queue(q, 1);
 			/*
@@ -1478,7 +1520,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 			       mutex_unlock(&matrix_dev->lock),
 			       mutex_lock(&matrix_dev->lock));
 
-		ret = vfio_ap_mdev_reset_queues(mdev);
+		ret = vfio_ap_mdev_reset_queues(&matrix_mdev->matrix);
 		break;
 	default:
 		ret = -EOPNOTSUPP;
@@ -1545,8 +1587,17 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	vfio_ap_queue_link_mdev(q);
-	if (q->matrix_mdev)
+	if (q->matrix_mdev) {
+		/*
+		 * If the KVM pointer is in the process of being set, wait
+		 * until the process has completed.
+		 */
+		wait_event_cmd(q->matrix_mdev->wait_for_kvm,
+			       !q->matrix_mdev->kvm_busy,
+			       mutex_unlock(&matrix_dev->lock),
+			       mutex_lock(&matrix_dev->lock));
 		vfio_ap_mdev_refresh_apcb(q->matrix_mdev);
+	}
 	dev_set_drvdata(&apdev->device, q);
 	mutex_unlock(&matrix_dev->lock);
 
-- 
2.30.2

