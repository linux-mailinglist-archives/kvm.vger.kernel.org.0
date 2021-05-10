Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E825F379469
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 18:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhEJQp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 12:45:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34288 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231926AbhEJQpr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 12:45:47 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AGXkVW090351;
        Mon, 10 May 2021 12:44:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=95mgFF6cc+9rDFcBxh+TLSVqOxk4O7uoivWsQhZ5aF8=;
 b=he7EkBtMIQk2Bkam9tnwuhCYrHGLMleMHw2Z2REzUlgixol53AGeqM8ik/hWMNmfnMgS
 Ex+54mrETkAXidPacrPLupM+nGpzuUY1qrJ+CMbVODD3E/QvFSfuxjPLZ1dzUc0KpQJP
 REHLGVega1Jv3ZfHffbZqk10181ft7kw6qToeL3e7N5ofFig014gcrvPXmxfmrsTlSQB
 Ozo6wgOo8Am9HTaPUPtwoGzC+PJ3rtDdLN8G/ZCwLwJaCPjR9qtz9zTWXJq+S1IWUd/v
 Hb1tOJ9qpX8h6rzGLO9QBYLo373ZQTk6A5TxbWt10l4CH411ZavhXv57nt06PCH7elP5 OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f5hrq1un-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 12:44:40 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AGY42T093199;
        Mon, 10 May 2021 12:44:39 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f5hrq1u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 12:44:39 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AGh2hC021562;
        Mon, 10 May 2021 16:44:38 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03dal.us.ibm.com with ESMTP id 38dj993hvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 16:44:38 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AGiaN838535500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 16:44:36 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA8A8AE063;
        Mon, 10 May 2021 16:44:36 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 912A9AE05F;
        Mon, 10 May 2021 16:44:35 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com.com (unknown [9.85.140.234])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 16:44:35 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v16 05/14] s390/vfio-ap: introduce shadow APCB
Date:   Mon, 10 May 2021 12:44:14 -0400
Message-Id: <20210510164423.346858-6-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510164423.346858-1-akrowiak@linux.ibm.com>
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DkuMtxmcngxzz6lL26DL6j86o6kjs_hU
X-Proofpoint-ORIG-GUID: M3VH5Ici7U4OUwydwiLGSGAQ7jlnyC9N
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_09:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxscore=0 malwarescore=0 priorityscore=1501 spamscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100113
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
index e391b9cfe32b..8f705b0e12e4 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -353,6 +353,7 @@ static int vfio_ap_mdev_create(struct mdev_device *mdev)
 	matrix_mdev->mdev = mdev;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
 	init_waitqueue_head(&matrix_mdev->wait_for_kvm);
+	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
 	hash_init(matrix_mdev->qtable);
 	mdev_set_drvdata(mdev, matrix_mdev);
 	matrix_mdev->pqap_hook.hook = handle_pqap;
@@ -1222,12 +1223,13 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 		}
 
 		kvm_get_kvm(kvm);
+		memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
+		       sizeof(struct ap_matrix));
 		matrix_mdev->kvm_busy = true;
 		mutex_unlock(&matrix_dev->lock);
-		kvm_arch_crypto_set_masks(kvm,
-					  matrix_mdev->matrix.apm,
-					  matrix_mdev->matrix.aqm,
-					  matrix_mdev->matrix.adm);
+		kvm_arch_crypto_set_masks(kvm, matrix_mdev->shadow_apcb.apm,
+					  matrix_mdev->shadow_apcb.aqm,
+					  matrix_mdev->shadow_apcb.adm);
 		mutex_lock(&matrix_dev->lock);
 		kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
 		matrix_mdev->kvm = kvm;
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index af3f53a3ea4c..6f4f1f5bd611 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -75,6 +75,7 @@ struct ap_matrix {
  * @list:	allows the ap_matrix_mdev struct to be added to a list
  * @matrix:	the adapters, usage domains and control domains assigned to the
  *		mediated matrix device.
+ * @shadow_apcb:    the shadow copy of the APCB field of the KVM guest's CRYCB
  * @group_notifier: notifier block used for specifying callback function for
  *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
  * @kvm:	the struct holding guest's state
@@ -82,6 +83,7 @@ struct ap_matrix {
 struct ap_matrix_mdev {
 	struct list_head node;
 	struct ap_matrix matrix;
+	struct ap_matrix shadow_apcb;
 	struct notifier_block group_notifier;
 	struct notifier_block iommu_notifier;
 	bool kvm_busy;
-- 
2.30.2

