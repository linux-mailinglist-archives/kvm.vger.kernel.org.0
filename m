Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A016643660D
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhJUP02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:26:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46118 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231937AbhJUP0V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:26:21 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEDou0023002;
        Thu, 21 Oct 2021 11:24:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lbRiA6vc7uHKGYpWya4nBy1XDXU8qo6ZxSO1b9DOtXM=;
 b=XPx9yP7Y7VE0dqzp41FaqU/VZTHMY/GHCcsqoZUWAXunpmWtxPwZ0MB6BMVISRZeaggd
 U8cOXUmQ3cD7QWuSkt6WYHtWnYfNTDbPbrJeGrh2EQ8lkNFWzo6WcR4dWGk14wKyBdYY
 gI0fwZsIfYSAc4BnE4ljeyZaFL3gDGEZsaWIcmnPSLSo8Wqf4c64UPWPJBeoHwDRHWr3
 2nYIzX8FWa+mvk3Y+lDRHK/hlAKzIjtpSoUpRslgLc6y8UB8VSRrWFxjSjjS+R59Q5dX
 lrBn7NcsRr7bdGyaGVd4EatbxFuh6mwcOexDdDKnTGBFSP2DHVSFI+tsrXkwyptz4RD3 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bu8yhb0ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:24:03 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19LFIb9a001486;
        Thu, 21 Oct 2021 11:24:02 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bu8yhb0rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:24:02 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LF3ifJ004818;
        Thu, 21 Oct 2021 15:24:01 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02dal.us.ibm.com with ESMTP id 3bqpcd8hs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 15:24:01 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LFNxa338338950
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 15:24:00 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1BAEBE061;
        Thu, 21 Oct 2021 15:23:59 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32E2FBE07A;
        Thu, 21 Oct 2021 15:23:58 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com.com (unknown [9.160.98.118])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 15:23:58 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v17 05/15] s390/vfio-ap: introduce shadow APCB
Date:   Thu, 21 Oct 2021 11:23:22 -0400
Message-Id: <20211021152332.70455-6-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021152332.70455-1-akrowiak@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zW7BF0VNjPDJ1vM_I40qy0mne0XO9kpe
X-Proofpoint-ORIG-GUID: l85YTJyh-80jGSHM40NyCUSgQggBjdcr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The APCB is a field within the CRYCB that provides the AP configuration
to a KVM guest. Let's introduce a shadow copy of the KVM guest's APCB and
maintain it for the lifespan of the guest.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 10 ++++++----
 drivers/s390/crypto/vfio_ap_private.h |  2 ++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e2be29e9d310..4305177029bf 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -332,6 +332,7 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 
 	matrix_mdev->mdev = mdev;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
+	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
 	hash_init(matrix_mdev->qtable.queues);
 	mdev_set_drvdata(mdev, matrix_mdev);
 	mutex_lock(&matrix_dev->lock);
@@ -1178,10 +1179,11 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 		kvm_get_kvm(kvm);
 		matrix_mdev->kvm = kvm;
 		kvm->arch.crypto.data = matrix_mdev;
-		kvm_arch_crypto_set_masks(kvm,
-					  matrix_mdev->matrix.apm,
-					  matrix_mdev->matrix.aqm,
-					  matrix_mdev->matrix.adm);
+		memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
+		       sizeof(struct ap_matrix));
+		kvm_arch_crypto_set_masks(kvm, matrix_mdev->shadow_apcb.apm,
+					  matrix_mdev->shadow_apcb.aqm,
+					  matrix_mdev->shadow_apcb.adm);
 
 		mutex_unlock(&kvm->lock);
 		mutex_unlock(&matrix_dev->lock);
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index c1f57f89973e..6dc0ebbf7a06 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -91,6 +91,7 @@ struct ap_queue_table {
  * @node:	allows the ap_matrix_mdev struct to be added to a list
  * @matrix:	the adapters, usage domains and control domains assigned to the
  *		mediated matrix device.
+ * @shadow_apcb:    the shadow copy of the APCB field of the KVM guest's CRYCB
  * @group_notifier: notifier block used for specifying callback function for
  *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
  * @iommu_notifier: notifier block used for specifying callback function for
@@ -105,6 +106,7 @@ struct ap_matrix_mdev {
 	struct vfio_device vdev;
 	struct list_head node;
 	struct ap_matrix matrix;
+	struct ap_matrix shadow_apcb;
 	struct notifier_block group_notifier;
 	struct notifier_block iommu_notifier;
 	struct kvm *kvm;
-- 
2.31.1

