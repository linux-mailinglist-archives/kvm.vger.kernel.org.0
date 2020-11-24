Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCC42C3363
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 22:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387422AbgKXVkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 16:40:45 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733307AbgKXVko (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 16:40:44 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLWEZ3116442;
        Tue, 24 Nov 2020 16:40:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Qbn+y1MZKYvE7n+nWzMgxJawXr+Le+d0oajYMIse2XE=;
 b=FSLiVwA8Mj+da7vy2UkdeGQCgwzkH97Ciu+dWpjhFr/5QTG0g5JgJSpPtpsMC1xwauLF
 vgQV9au/qwtcUAgKTXlbEP7+hmi7+FlIFYAqWREDbGpLRk06pnZS71Pmy2z8I+U1Rsh7
 KcMcUljHBKKswALacMHcrShow/DZzA1kiDooN6Oqzy1fmYHtPEyZxLEtwumu35jpq53E
 VGnydfXxO9HAfn/B/JXiayJvjaRHLnnDBmi75cVl46oO1P8h8i+460MnNw4M3ucOQjtU
 q6i19gi0MbUYgNaAhC/7nQ72xeQXwnYfJExcYDckiqK1R+AxJIoIvV3m2k5eVs61tYar UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350rkptyte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:41 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AOLWJmY116946;
        Tue, 24 Nov 2020 16:40:40 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350rkptyt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:40 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLbU0m010757;
        Tue, 24 Nov 2020 21:40:39 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 34xth99hh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 21:40:39 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOLebie11141546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 21:40:38 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD945AE064;
        Tue, 24 Nov 2020 21:40:37 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3746AE05C;
        Tue, 24 Nov 2020 21:40:36 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.195.249])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 21:40:36 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v12 10/17] s390/vfio-ap: initialize the guest apcb
Date:   Tue, 24 Nov 2020 16:40:09 -0500
Message-Id: <20201124214016.3013-11-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201124214016.3013-1-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_07:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=3 priorityscore=1501 mlxlogscore=999 spamscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The APCB is a control block containing the masks that specify the adapters,
domains and control domains to which a KVM guest is granted access. When
the vfio_ap device driver is notified that the KVM pointer has been set,
the guest's APCB is initialized from the AP configuration of adapters,
domains and control domains assigned to the matrix mdev. The linux device
model, however, precludes passing through to a guest any devices that
are not bound to the device driver facilitating the pass-through.
Consequently, APQNs assigned to the matrix mdev that do not reference
AP queue devices must be filtered before assigning them to the KVM guest's
APCB; however, the AP architecture precludes filtering individual APQNs, so
the APQNs will be filtered by APID. That is, if a given APQN does not
reference a queue device bound to the vfio_ap driver, its APID will not
get assigned to the guest's APCB. For example:

Queues bound to vfio_ap:
04.0004
04.0022
04.0035
05.0004
05.0022

Adapters/domains assigned to the matrix mdev:
04 0004
   0022
   0035
05 0004
   0022
   0035

APQNs assigned to APCB:
04.0004
04.0022
04.0035

The APID 05 was filtered from the matrix mdev's matrix because
queue device 05.0035 is not bound to the vfio_ap device driver.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 59 +++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index a69422d76e7f..633c61995891 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -318,6 +318,13 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
+static void vfio_ap_copy_masks(struct ap_matrix *dst, struct ap_matrix *src)
+{
+	bitmap_copy(dst->apm, src->apm, AP_DEVICES);
+	bitmap_copy(dst->aqm, src->aqm, AP_DOMAINS);
+	bitmap_copy(dst->adm, src->adm, AP_DOMAINS);
+}
+
 static bool vfio_ap_mdev_has_crycb(struct ap_matrix_mdev *matrix_mdev)
 {
 	return (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd);
@@ -332,6 +339,55 @@ static void vfio_ap_mdev_commit_shadow_apcb(struct ap_matrix_mdev *matrix_mdev)
 					  matrix_mdev->shadow_apcb.adm);
 }
 
+static void vfio_ap_mdev_init_apcb(struct ap_matrix_mdev *matrix_mdev)
+{
+	unsigned long apid, apqi, apqn;
+
+	vfio_ap_copy_masks(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix);
+
+	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
+		/*
+		 * If the APID is not assigned to the host AP configuration,
+		 * we can not assign it to the guest's AP configuration
+		 */
+		if (!test_bit_inv(apid,
+				  (unsigned long *)matrix_dev->info.apm)) {
+			clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+			continue;
+		}
+
+		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
+				     AP_DOMAINS) {
+			/*
+			 * If the APQI is not assigned to the host AP
+			 * configuration, then it can not be assigned to the
+			 * guest's AP configuration
+			 */
+			if (!test_bit_inv(apqi, (unsigned long *)
+					  matrix_dev->info.aqm)) {
+				clear_bit_inv(apqi,
+					      matrix_mdev->shadow_apcb.aqm);
+				continue;
+			}
+
+			/*
+			 * If the APQN is not bound to the vfio_ap device
+			 * driver, then we can't assign it to the guest's
+			 * AP configuration. The AP architecture won't
+			 * allow filtering of a single APQN, so let's filter
+			 * the APID.
+			 */
+			apqn = AP_MKQID(apid, apqi);
+
+			if (!vfio_ap_mdev_get_queue(matrix_mdev, apqn)) {
+				clear_bit_inv(apid,
+					      matrix_mdev->shadow_apcb.apm);
+				break;
+			}
+		}
+	}
+}
+
 static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -1256,8 +1312,7 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 	if (ret)
 		return NOTIFY_DONE;
 
-	memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
-	       sizeof(matrix_mdev->shadow_apcb));
+	vfio_ap_mdev_init_apcb(matrix_mdev);
 	vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
 
 	return NOTIFY_OK;
-- 
2.21.1

