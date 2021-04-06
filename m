Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7593557EC
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 17:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345759AbhDFPcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 11:32:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31070 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345705AbhDFPb5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 11:31:57 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 136FPOQC192258;
        Tue, 6 Apr 2021 11:31:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yg5hgJW/dqVI1M8pudLf08TQ7yBTw4bBP1gtw4NhU2Q=;
 b=BgDTCrN99nANmwFfUQsQYu8lL7KcMVdd1yjdfSFgvUfZKBuUYpL3vQWLkxIJ8mXDA575
 bGMAkZKqnhA0nVQxDILsDbKnSiJydmFANIWgfPltQKADoR0mWdFpfx3kMbS88xHI/IwC
 HGFMtymHcZOlwo93WkqPeaN0bewb/rumvRA63+4ErwJ5EwELJbnpCm275kSaISA5A+s8
 cOQ/vHoC1XQybw58fu9X+SgllfCart+qzNdK8TPw1Wvj5eTFhGfIbv4BnU5d7IKLlAqg
 ow65UvRUSDbK8as/P/us+GFa/2vh1Eikta/q5oxxeST1HG5yLvMm99JW5MeetDjPRxzN 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5ky164e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 11:31:47 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 136FPhlf193760;
        Tue, 6 Apr 2021 11:31:47 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5ky163x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 11:31:47 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 136FNRVE031182;
        Tue, 6 Apr 2021 15:31:46 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04wdc.us.ibm.com with ESMTP id 37q2n1gs4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 15:31:46 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 136FVhab10748388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 15:31:43 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 266AFBE053;
        Tue,  6 Apr 2021 15:31:43 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 903AEBE05B;
        Tue,  6 Apr 2021 15:31:41 +0000 (GMT)
Received: from cpe-172-100-182-241.stny.res.rr.com.com (unknown [9.85.175.110])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 15:31:41 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v15 06/13] s390/vfio-ap: refresh guest's APCB by filtering APQNs assigned to mdev
Date:   Tue,  6 Apr 2021 11:31:15 -0400
Message-Id: <20210406153122.22874-7-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20210406153122.22874-1-akrowiak@linux.ibm.com>
References: <20210406153122.22874-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EgBWQ7-HcmhOrm823UUIvOumvEgdYcVX
X-Proofpoint-GUID: YbkKFAPKaqMduOViYddK3b4cIvkUPLjx
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_04:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refresh the guest's APCB by filtering the APQNs assigned to the matrix mdev
that do not reference an AP queue device bound to the vfio_ap device
driver. The mdev's APQNs will be filtered according to the following rules:

* The APID of each adapter and the APQI of each domain that is not in the
  host's AP configuration is filtered out.

* The APID of each adapter comprising an APQN that does not reference a
  queue device bound to the vfio_ap device driver is filtered. The APQNs
  are derived from the Cartesian product of the APID of each adapter and
  APQI of each domain assigned to the mdev.

The filtering will take place:

* Whenever an adapter, domain or control domains is assigned or
  unassigned.

* When a queue device is bound to or unbound from the vfio_ap device
  driver.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 84 +++++++++++++++++++++++++++++--
 1 file changed, 81 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index ce57d7f24f74..a8ae1d22aeba 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -311,6 +311,76 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
+/*
+ * vfio_ap_mdev_filter_apcb
+ *
+ * @matrix_mdev: the mdev whose AP configuration is to be filtered.
+ * @shadow_apcb: the APCB to use to store the guest's AP configuration after
+ *		 filtering takes place.
+ */
+static void vfio_ap_mdev_filter_apcb(struct ap_matrix_mdev *matrix_mdev,
+				     struct ap_matrix *shadow_apcb)
+{
+	int ret;
+	unsigned long apid, apqi, apqn;
+
+	ret = ap_qci(&matrix_dev->info);
+	if (ret)
+		return;
+
+	/*
+	 * Copy the adapters, domains and control domains to the shadow_apcb
+	 * from the matrix mdev, but only those that are assigned to the host's
+	 * AP configuration.
+	 */
+	bitmap_and(shadow_apcb->apm, matrix_mdev->matrix.apm,
+		   (unsigned long *)matrix_dev->info.apm, AP_DEVICES);
+	bitmap_and(shadow_apcb->aqm, matrix_mdev->matrix.aqm,
+		   (unsigned long *)matrix_dev->info.aqm, AP_DOMAINS);
+	bitmap_and(shadow_apcb->adm, matrix_mdev->matrix.adm,
+		   (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);
+
+	for_each_set_bit_inv(apid, shadow_apcb->apm, AP_DEVICES) {
+		for_each_set_bit_inv(apqi, shadow_apcb->aqm, AP_DOMAINS) {
+			/*
+			 * If the APQN is not bound to the vfio_ap device
+			 * driver, then we can't assign it to the guest's
+			 * AP configuration. The AP architecture won't
+			 * allow filtering of a single APQN, so if we're
+			 * filtering APIDs, then filter the APID; otherwise,
+			 * filter the APQI.
+			 */
+			apqn = AP_MKQID(apid, apqi);
+			if (!vfio_ap_mdev_get_queue(matrix_mdev, apqn)) {
+				clear_bit_inv(apid, shadow_apcb->apm);
+				break;
+			}
+		}
+	}
+}
+
+/**
+ * vfio_ap_mdev_refresh_apcb
+ *
+ * Refresh the guest's APCB by filtering the APQNs assigned to the matrix mdev
+ * that do not reference an AP queue device bound to the vfio_ap device driver.
+ *
+ * @matrix_mdev:  the matrix mdev whose AP configuration is to be filtered
+ */
+static void vfio_ap_mdev_refresh_apcb(struct ap_matrix_mdev *matrix_mdev)
+{
+	struct ap_matrix shadow_apcb;
+
+	vfio_ap_matrix_init(&matrix_dev->info, &shadow_apcb);
+	vfio_ap_mdev_filter_apcb(matrix_mdev, &shadow_apcb);
+
+	if (memcmp(&shadow_apcb, &matrix_mdev->shadow_apcb,
+		   sizeof(struct ap_matrix)) != 0) {
+		memcpy(&matrix_mdev->shadow_apcb, &shadow_apcb,
+		       sizeof(struct ap_matrix));
+	}
+}
+
 static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -711,6 +781,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 		goto share_err;
 
 	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
 	ret = count;
 	goto done;
 
@@ -780,6 +851,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -888,6 +960,7 @@ static ssize_t assign_domain_store(struct device *dev,
 		goto share_err;
 
 	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
 	ret = count;
 	goto done;
 
@@ -957,6 +1030,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
 	ret = count;
 
 done:
@@ -1016,6 +1090,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	 * number of control domains that can be assigned.
 	 */
 	set_bit_inv(id, matrix_mdev->matrix.adm);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -1069,6 +1144,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	}
 
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
+	vfio_ap_mdev_refresh_apcb(matrix_mdev);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -1202,8 +1278,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 		}
 
 		kvm_get_kvm(kvm);
-		memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
-		       sizeof(struct ap_matrix));
 		matrix_mdev->kvm_busy = true;
 		mutex_unlock(&matrix_dev->lock);
 		kvm_arch_crypto_set_masks(kvm, matrix_mdev->shadow_apcb.apm,
@@ -1567,6 +1641,8 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	vfio_ap_queue_link_mdev(q);
+	if (q->matrix_mdev)
+		vfio_ap_mdev_refresh_apcb(q->matrix_mdev);
 	dev_set_drvdata(&apdev->device, q);
 	mutex_unlock(&matrix_dev->lock);
 
@@ -1580,8 +1656,10 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	mutex_lock(&matrix_dev->lock);
 	q = dev_get_drvdata(&apdev->device);
 
-	if (q->matrix_mdev)
+	if (q->matrix_mdev) {
 		vfio_ap_mdev_unlink_queue_fr_mdev(q);
+		vfio_ap_mdev_refresh_apcb(q->matrix_mdev);
+	}
 
 	vfio_ap_mdev_reset_queue(q, 1);
 	dev_set_drvdata(&apdev->device, NULL);
-- 
2.21.3

